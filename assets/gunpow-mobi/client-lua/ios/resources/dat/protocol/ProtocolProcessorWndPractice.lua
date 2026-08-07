--ProtocolProcessorWndPractice.lua
--@brief	背包模块协议
--@date  	2016/07/23
--@author 	zhangming
--@note 	修炼模块所使用协议


ProtocolProcessorWndPractice = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndPractice:regAll()
	WZLog("ProtocolProcessorWndPractice:regAll")
	--@brief	获取修炼信息（PLAYER_GetPlayerInfoOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_UPGRADE, Protocol.UPGRADE_RequestUpgradeInfoOk, "ProtocolProcessorWndPractice:parse_UPGRADE_RequestUpgradeInfoOk", "viviviiviiiiiiitsi")
	--@brief	获取抽奖信息成功（PLAYER_UpdateContextOK = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_UPGRADE, Protocol.UPGRADE_RequestUpgradeRandomOk, "ProtocolProcessorWndPractice:parse_UPGRADE_RequestUpgradeRandomOk", "viviviiiiii")
	--@brief	双修操作（UPGRADE_ShuangXiuActionOK = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_UPGRADE, Protocol.UPGRADE_ShuangXiuActionOK, "ProtocolProcessorWndPractice:parse_UPGRADE_ShuangXiuActionOK", "bt")

	--@brief	双修操作（UPGRADE_ShuangXiuAction=5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_UPGRADE, Protocol.UPGRADE_ShuangXiuAction, "ProtocolProcessorWndPractice:send_UPGRADE_ShuangXiuAction_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndPractice:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取修炼信息（PLAYER_GetPlayerInfo = 1）
function ProtocolProcessorWndPractice:send_UPGRADE_RequestUpgradeInfo()
	WZLog("send_UPGRADE_RequestUpgradeInfo",Protocol.MAIN_UPGRADE,Protocol.UPGRADE_RequestUpgradeInfo)
	local sender = Protocol:getSender( Protocol.MAIN_UPGRADE, Protocol.UPGRADE_RequestUpgradeInfo )
	if sender==nil then WZLog("sender == nil") return end
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取抽奖信息（PLAYER_UpdateContext = 3
function ProtocolProcessorWndPractice:send_UPGRADE_RequestUpgradeRandom(num, useType)
	WZLog("send_UPGRADE_RequestUpgradeRandom")
	local sender = Protocol:getSender( Protocol.MAIN_UPGRADE, Protocol.UPGRADE_RequestUpgradeRandom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( num )	-- 修炼次数
	sender:writeInt( useType )	-- 修炼次数
	SendProtocol(sender,false) --true:showLoading
end

--@brief	双修操作（UPGRADE_ShuangXiuAction=5）
function ProtocolProcessorWndPractice:send_UPGRADE_ShuangXiuAction(opType)
	WZLog("send_UPGRADE_ShuangXiuAction")
	local sender = Protocol:getSender( Protocol.MAIN_UPGRADE, Protocol.UPGRADE_ShuangXiuAction )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( opType )	-- 0: 开启双修卡槽;1：退出双修
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取修炼信息（PLAYER_GetPlayerInfoOk = 2）
function ProtocolProcessorWndPractice:parse_UPGRADE_RequestUpgradeInfoOk(id, level, exp, itime, attrList, value, nextValue,vigor,todayValue, maxNum, maxValue, shuangXiuStatus, shuangXiuInfo, timeLimit)
	-- shuangXiuStatus : 0: 未开启卡槽，且未有双休对象;1： 有双休对象;2：开启卡槽，无双休对象
	-- shuangXiuInfo : 双修对象信息（包括姓名，id,sex,head,face,body,wing,headcolor,bodycolor)
	-- timeLimit : 惩罚剩余时间
	WZLog("ProtocolProcessorWndPractice:parse_UPGRADE_RequestUpgradeInfoOk")
	local data = {}
	data.itime = itime
	data.value = value
	data.nextValue = nextValue
	data.vigor = vigor
	data.todayValue = todayValue
	data.curLv = {}
	data.curExp = {}
	data.attrList = {}
	data.maxNum = maxNum
	data.maxValue = maxValue
	for i = 0 , id:size() - 1 do
		table.insert(data.curLv, level:get(i))
		table.insert(data.curExp, exp:get(i))
		table.insert(data.attrList, tonumber(attrList:get(i)))
	end
	WndPractice:setDate(data, shuangXiuStatus, shuangXiuInfo, timeLimit)
end

--@brief	获取抽奖信息成功（PLAYER_UpdateContextOK = 4）
function ProtocolProcessorWndPractice:parse_UPGRADE_RequestUpgradeRandomOk(result,exp,attrList,value,nextValue, maxNum, maxValue, itime)
	WZLog("ProtocolProcessorWndBag:parse_UPGRADE_RequestUpgradeRandomOk:")
	local data = {}
	data.value = value
	data.nextValue = nextValue
	data.addExp = {}
	data.attrList = {}
	data.result = {}
	data.maxNum = maxNum
	data.maxValue = maxValue
	data.itime = itime
	for i = 0 , exp:size() - 1 do
		table.insert(data.addExp, exp:get(i))
		table.insert(data.attrList, attrList:get(i))
	end
	for i = 0 , result:size() - 1 do
		table.insert(data.result, result:get(i))
	end
	WZLog("ProtocolProcessorWndBag:parse_UPGRADE_RequestUpgradeRandomOk", Serialize(data))
	WndPractice:setRollResult(data)
end

--@brief	双修操作（UPGRADE_ShuangXiuActionOK = 6）
function ProtocolProcessorWndPractice:parse_UPGRADE_ShuangXiuActionOK(result, opType)
	-- result : 操作结果
	-- opType : 0: 开启双修卡槽;1：退出双修
	WZLog("ProtocolProcessorWndPractice:parse_UPGRADE_ShuangXiuActionOK:")
	WndPractice:openDoublePracticeOK(result, opType)
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	双修操作（UPGRADE_ShuangXiuAction=5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPractice:send_UPGRADE_ShuangXiuAction_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPractice:send_UPGRADE_ShuangXiuAction_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_UPGRADE, Protocol.UPGRADE_ShuangXiuAction, nflag, sMessage)
end

