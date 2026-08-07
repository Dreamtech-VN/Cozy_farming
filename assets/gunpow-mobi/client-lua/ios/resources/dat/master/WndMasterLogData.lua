--WndMasterLogData.lua
--@brief	WndMasterLog的数据模块
--@date		2015/05/27
--@author	zsq
--@note		师徒消息

WndMasterLog = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMasterLog:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tMasterLog1 = nil
	self.m_tMasterLog2 = nil
	self.m_bLog1Received = nil
	self.m_bLog2Received = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMasterLog:_unInit()
	self.m_root = nil
	self.m_tMasterLog1 = nil
	self.m_tMasterLog2 = nil
	self.m_bLog1Received = nil
	self.m_bLog2Received = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMasterLog:createElement()
	local element = WZUISystem:getInstance():createElement("WndMasterLog")
	assert(element, "WndMasterLog create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置师徒日志(类型1)
function WndMasterLog:setMasterLog1(playerId, headId, faceId, message, sex, headColor)
	WZLog("WndMasterLog:setMasterLog1")
	self.m_tMasterLog1 = {}
	for i=#playerId,1,-1 do
		local tempTable = {}
		tempTable.playerId = playerId[i]
		tempTable.headId = headId[i]
		tempTable.faceId = faceId[i]
		tempTable.message = string.gsub(message[i], g_MasterMessage_Mark, "")
		tempTable.sex = sex[i]
		tempTable.headColor = headColor[i]
		table.insert(self.m_tMasterLog1,tempTable)
	end
	
	self.m_bLog1Received = true

	self:update()
end

--@brief	设置师徒日志(类型2)
function WndMasterLog:setMasterLog2(message, createTime, playerId, headId, faceId, sex, headColor)
	WZLog("WndMasterLog:setMasterLog2")
	self.m_tMasterLog2 = {}
	for i=1,#message do
		local tempTable = {}
		tempTable.message = string.gsub(message[i], g_MasterMessage_Mark, "")
		tempTable.createTime = createTime[i]
		tempTable.playerId = playerId[i]
		tempTable.headId = headId[i]
		tempTable.faceId = faceId[i]
		tempTable.sex = sex[i]
		tempTable.headColor = headColor[i]
		table.insert(self.m_tMasterLog2,tempTable)
	end
    table.sort(self.m_tMasterLog2, _sortMasterLog)
	
	self.m_bLog2Received = true

	self:update()
end

--@brief 	排序函数
function _sortMasterLog(a, b)
	return a.createTime > b.createTime
end
-------------------------------------私有方法模块End----------------------------------------
