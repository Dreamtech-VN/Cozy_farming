--MsgManager.lua
--@brief	消息管理器
--@date		2013/12/24
--@author	李俊鸿
--@note		管理战斗过程中各个模块之间的数据交互

--@brief	消息状态枚举
MsgStatus = {
	MSG_STATUS_PROCESS = 1, --正在处理
	MSG_STATUS_DONE = 2, --处理完成
	MSG_STATUS_PAUSE = 3, --处理暂停
}

--@brief	基本消息数据表
MsgBase = {
	m_nStatus = 0, --消息状态
	m_nSkillStatusCount = 0,	--技能状态计数器
	m_nBuildBulletsSkillStatusCount = 0,	--中途产生子弹技能状态计数器
}

--@brief	消息管理器数据表
MsgManager = {
	m_tBlockMsgList = {}, --阻塞模式消息队列
	m_tNonBlockMsgList = {}, --非阻塞模式消息队列
	m_tPriorMsgList = {},	--优先处理消息 阻塞式
}

-------------------------------------公有方法模块--------------------------------------
function MsgManager:new()
	local tNewObj = {}
	tNewObj.m_tBlockMsgList = {}
	tNewObj.m_tNonBlockMsgList = {}
	tNewObj.m_tPriorMsgList = {}
	setmetatable(tNewObj, {__index = MsgManager})
	return tNewObj
end

--@brief	创建一个新的消息数据表
--@param	tDataType:消息数据类型
--@return	#1,新创建的消息数据表
function MsgManager:createMsg(tDataType)
	local tMsg = {}
	setmetatable(tMsg, {__index = tDataType})
	tMsg.m_nStatus = 0
    tMsg.m_nSkillStatusCount = 0
    tMsg.m_nBuildBulletsSkillStatusCount = 0
	return tMsg
end

local insertToTable = table.insert
--@brief	将消息插入到阻塞模式消息队列
--@param	tMsg:即将插入的消息
function MsgManager:pushBlockMsg(tMsg,index)
    WZLog("MsgManager:pushBlockMsg",tostring(tMsg.m_sName),#self.m_tBlockMsgList,index)
    if index and index > 1 and index <= #self.m_tBlockMsgList then
    	insertToTable(self.m_tBlockMsgList,index,tMsg)
    else
        insertToTable(self.m_tBlockMsgList, tMsg)
    end
end

--@brief	将消息插入到非阻塞模式消息队列
--@param	tMsg:即将插入的消息
function MsgManager:pushNonBlockMsg(tMsg)
    WZLog("MsgManager:pushNonBlockMsg",tostring(tMsg.m_sName),#self.m_tNonBlockMsgList)
	insertToTable(self.m_tNonBlockMsgList, tMsg)
end

function MsgManager:pushPriorMsg(tMsg)
	insertToTable(self.m_tPriorMsgList, tMsg)
end

--@brief	消除消息队列中的所有消息
function MsgManager:clear(reconnectClear, isAction)
	WZLog("MsgManager:clear")
	if reconnectClear then
		local msg = self.m_tBlockMsgList[1]
		local msg2 = self.m_tNonBlockMsgList[1]

		if isAction then
			if msg and msg.clearAction then
				msg:clearAction()
			end

			if msg2 and msg2.clearAction then
				msg2:clearAction()
			end
		end
		
		self.m_tBlockMsgList = {}
		self.m_tNonBlockMsgList = {}
		self.m_tPriorMsgList = {}
		if msg and msg.m_bIsSummonMsg then
			msg.m_bIsReconnectDone = true
			MsgManager:pushBlockMsg(msg)
		end

		if msg2 and msg2.m_bIsSummonMsg then
			msg2.m_bIsReconnectDone = true
			MsgManager:pushNonBlockMsg(msg2)
		end
		return
	end
	self.m_tBlockMsgList = {}
	self.m_tNonBlockMsgList = {}
	self.m_tPriorMsgList = {}
end

--@brief	消息系统主循环函数
--@param	dt:距离上一次调用的时间（秒）
--@note		每帧调用或设置定时器调用
function MsgManager:update(dt)
--	assert(dt ~= nil)
	if #self.m_tPriorMsgList > 0 then
		self:_procMsgList(self.m_tPriorMsgList, true, dt)
	else
		self:_procMsgList(self.m_tBlockMsgList, true, dt)
		self:_procMsgList(self.m_tNonBlockMsgList, false, dt)
	end
end

--@brief    判断当前是否有新的阻塞消息
--@return   #1, true 有 false 没有
function MsgManager:hasNewBlockMsg()
    return table.getn(self.m_tBlockMsgList) > 1
end

--@brief 获得对应名字的消息
function MsgManager:getBlockMsgByName(msgName)
	for i,msg in pairs(self.m_tBlockMsgList) do
		if msg.m_sName == msgName then
			return msg
		end
	end
	return nil
	-- body
end

--@brief 获得对应名字的消息
function MsgManager:getNoneBlockMsgByName(msgName)
	for i,msg in pairs(self.m_tNonBlockMsgList) do
		if msg.m_sName == msgName then
			return msg
		end
	end
	return nil
	-- body
end

--@brief    交换堵塞消息位置
function MsgManager:exchangeBlockMsg(msgName,index)
	for i = 1,#self.m_tBlockMsgList do
		local msg = self.m_tBlockMsgList[i]
		if msg.msgName == msgName then
			removeFromTable(self.m_tBlockMsgList,i)
	    	insertToTable(self.m_tBlockMsgList, index, msg)
	    	break
		end
	end
end

--@brief 是否存在表演消息
function MsgManager:isInShowBlockMsg()
	local list = {"BattleMsgSkillShow","BattleMsgPlayerMove","BattleMsgPlayerShoot","BattleMsgPlayerFly","BattleMsgPetShoot"}
	for i = 1,#self.m_tBlockMsgList do
		local msg = self.m_tBlockMsgList[i]
		for k = 1,#list do
			if msg.msgName == list[k] then
				return true
			end
		end
	end
	return false
end

--@brief 是否存在出手中消息
function MsgManager:isInShowActionMsg()
	local list = {"isInShowActionMsg","BattleMsgPlayerFly","BattleMsgPetShoot"}
	for i = 1,#self.m_tBlockMsgList do
		local msg = self.m_tBlockMsgList[i]
		for k = 1,#list do
			if msg.msgName == list[k] then
				return true
			end
		end
	end
	return false
end

--@brief 非阻塞是否存在表演消息
function MsgManager:isInShowNonBlockMsg(msgName)
	local list = {"BattleMsgSkillShow","BattleMsgAssistedSkinBigSkill","BattleMsgAssistedSkinBigSkill2","BattleMsgPetBeatbackShoot","BattleMsgKidShoot"}
	WZLog("MsgManager:isInShowNonBlockMsg", #self.m_tNonBlockMsgList)
	for i = 1,#self.m_tNonBlockMsgList do
		local msg = self.m_tNonBlockMsgList[i]
		WZLog("MsgManager:isInShowNonBlockMsg one", i, msg.m_sName)
		if msgName then 
			if msg.m_sName == msgName then 
				return true 
			end
		else
			for k = 1, #list do
				if msg.m_sName == list[k] then
					return true
				end
			end
		end
	end
	return false
end
-------------------------------------私有方法模块--------------------------------------

--@brief	消息默认初始化函数
--@param	tMsg:当前处理的消息
function MsgBase:_init(tMsg)
	local sInit = "process"
	if tMsg.init ~= nil then
		sInit = tMsg:init()
	end
	tMsg.m_nStatus = MsgStatus.MSG_STATUS_PROCESS
	if sInit == "done" then
		tMsg.m_nStatus = MsgStatus.MSG_STATUS_DONE
		
		WZLog("MsgBase:_init", "done")
	end
end

--@brief	消息默认处理过程函数
--@param	tMsg:当前处理的消息
--@param	dt:距离上一次调用的时间（秒）
--@return	#1:当消息存在自定义的process函数时使用该函数的返回值，否则返回true表示消息处理结束
function MsgBase:_process(tMsg, dt)
	if tMsg.process ~= nil then
		return tMsg:process(dt)
	end
	return true
end

--@brief	消息默认处理完成函数
--@param	tMsg:当前处理的消息
function MsgBase:_done(tMsg)
    local isDone = nil
	if tMsg.done ~= nil then
		isDone = tMsg:done()
		--消息结束 游戏重播消息管理处理
		if tMsg.m_bIsReplayMsg then
			local msg = MsgManager:getNoneBlockMsgByName("BattleMsgReplayGame")
			if msg and BattleMsgReplayGameRecord.m_bIsSingleRecord then
				msg:doNextAction()
			end
		end
	end
    if isDone ~= false then
        tMsg.m_nStatus = MsgStatus.MSG_STATUS_DONE
    end
end

--@brief	处理消息队列中的消息
--@param	tMsgList:需要处理的消息队列
--@param	bBlock:是否以阻塞模式处理消息队列，即一条消息处理结束后再处理下一条消息
--@param	dt:距离上一次调用的时间（秒）
local removeFromTable = table.remove
function MsgManager:_procMsgList(tMsgList, bBlock, dt)
	local nIndex = 1
	while tMsgList[nIndex] ~= nil do
		local tMsg = tMsgList[nIndex]

		--初始化消息
		if tMsg.m_nStatus == 0 then
			MsgBase:_init(tMsg)
		end

		--处理消息并根据返回值判断消息是否处理结束
		if tMsg.m_nStatus == MsgStatus.MSG_STATUS_PROCESS then
			if MsgBase:_process(tMsg,dt) ~= false then
				MsgBase:_done(tMsg)
			end
		end

		--将处理完成的消息移出消息队列，或根据处理模式决定是否继续处理下一条消息
		if tMsg.m_nStatus == MsgStatus.MSG_STATUS_DONE then
			removeFromTable(tMsgList, nIndex)
        end
		
        if not bBlock then --非阻塞模式
			nIndex = nIndex + 1
		else --阻塞模式
			break
		end
	end
end
