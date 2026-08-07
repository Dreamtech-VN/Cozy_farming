--WndSpaceRecordData.lua
--@brief	WndSpaceRecord的数据模块
--@date		2016/01/06
--@author	zsq
--@note		个人记录

WndSpaceRecord = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSpaceRecord:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = nil
	self.m_tData = nil
	self.pageNumber = nil
	self.totalNumber = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSpaceRecord:_unInit()
	self.m_root = nil
	self.m_nType = nil
	self.m_tData = nil
	self.pageNumber = nil
	self.totalNumber = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSpaceRecord:createElement()
	local element = WZUISystem:getInstance():createElement("WndSpaceRecord")
	assert(element, "WndSpaceRecord create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	保存踩一踩数据
function WndSpaceRecord:setData1(playerId , playerName, playerLevel, headScul, isAwards, popularity, sendGift, serverId)
	self.m_tData = {}
	self.m_tData.playerId = self:reverseTable(VectorToTable(playerId))
	self.m_tData.playerName = self:reverseTable(VectorToTable(playerName))
	self.m_tData.playerLevel = self:reverseTable(VectorToTable(playerLevel))
	self.m_tData.headScul = self:reverseTable(VectorToTable(headScul))
	self.m_tData.isAwards = self:reverseTable(VectorToTable(isAwards))
	self.m_tData.serverId = self:reverseTable(VectorToTable(serverId))

	self.m_tData.num1 = popularity
	self.m_tData.num2 = sendGift

	self:update()
end

--@brief	保存收鲜花数据
function WndSpaceRecord:setData2(playerId , playerName, playerLevel, headScul, flowersId, visitorsNum, todayNum, serverId)
	self.m_tData = {}
	self.m_tData.playerId = self:reverseTable(VectorToTable(playerId))
	self.m_tData.playerName = self:reverseTable(VectorToTable(playerName))
	self.m_tData.playerLevel = self:reverseTable(VectorToTable(playerLevel))
	self.m_tData.headScul = self:reverseTable(VectorToTable(headScul))
	self.m_tData.flowersId = self:reverseTable(VectorToTable(flowersId))
	self.m_tData.serverId = self:reverseTable(VectorToTable(serverId))

	self.m_tData.num1 = visitorsNum
	self.m_tData.num2 = todayNum

	self:update()
end

function WndSpaceRecord:reverseTable(tab)
	local tmp = {}
	for i = 1, #tab do
		local key = #tab
		tmp[i] = table.remove(tab)
	end

	return tmp
end

--@brief	保存访客数据
function WndSpaceRecord:setData3(playerId , playerName, playerLevel, headScul, interviewTime, visitorsNum, todayNum, serverId)
	self.m_tData = {}
	self.m_tData.playerId = VectorToTable(playerId)
	self.m_tData.playerName = VectorToTable(playerName)
	self.m_tData.playerLevel = VectorToTable(playerLevel)
	self.m_tData.headScul = VectorToTable(headScul)
	self.m_tData.interviewTime = VectorToTable(interviewTime)
	self.m_tData.serverId = VectorToTable(serverId)

	self.m_tData.num1 = visitorsNum
	self.m_tData.num2 = todayNum

	self:update()
end

--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示
function WndSpaceRecord:_getUpPage( )
	if self.pageNumber > 1 then
		return true
	else
		return false
	end
end

--@brief	判断是否显示下一页函数
--@note		当前页小于总页数的时候显示下一页，否则不显示
function WndSpaceRecord:_getDownPage()
	if self.pageNumber < self.totalNumber then
		return true
	else
		return false
	end
end
-------------------------------------私有方法模块End----------------------------------------
