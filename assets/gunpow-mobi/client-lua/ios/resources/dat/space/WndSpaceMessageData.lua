--WndSpaceMessageData.lua
--@brief	WndSpaceMessage的数据模块
--@date		2016/01/06
--@author	zsq
--@note		个人留言板

WndSpaceMessage = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSpaceMessage:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil
	self.pageNumber = nil
	self.totalNumber = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSpaceMessage:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.pageNumber = nil
	self.totalNumber = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSpaceMessage:createElement()
	local element = WZUISystem:getInstance():createElement("WndSpaceMessage")
	assert(element, "WndSpaceMessage create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	保存留言数据
function WndSpaceMessage:setData(playerId , playerName, playerLevel, headScul, sendTime, index, messages, serverId)
	self.m_tData = {}
	self.m_tData.playerId = VectorToTable(playerId)
	self.m_tData.playerName = VectorToTable(playerName)
	self.m_tData.playerLevel = VectorToTable(playerLevel)
	self.m_tData.headScul = VectorToTable(headScul)
	self.m_tData.sendTime = VectorToTable(sendTime)
	self.m_tData.index = VectorToTable(index)
	self.m_tData.messages = VectorToTable(messages)
	self.m_tData.serverId = VectorToTable(serverId)

	self:update()
end

--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示
function WndSpaceMessage:_getUpPage( )
	if self.pageNumber > 1 then
		return true
	else
		return false
	end
end

--@brief	判断是否显示下一页函数
--@note		当前页小于总页数的时候显示下一页，否则不显示
function WndSpaceMessage:_getDownPage()
	if self.pageNumber < self.totalNumber then
		return true
	else
		return false
	end
end


-------------------------------------私有方法模块End----------------------------------------
