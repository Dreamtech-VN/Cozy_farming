--WndCommunityMonthCardData.lua
--@brief	WndCommunityMonthCard的数据模块
--@date		2015/11/04
--@author	zsq
--@note		公会月卡窗口

WndCommunityMonthCard = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityMonthCard:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil
	self.tag = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityMonthCard:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.tag = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityMonthCard:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityMonthCard")
	assert(element, "WndCommunityMonthCard create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获得基金界面数据
function WndCommunityMonthCard:setData(playerId, playerName, playerLevel)
	self.m_tData = {}
	for i=1,#playerId do
		local tempList = {}
		tempList.id = playerId[i]
		tempList.name = playerName[i]
		tempList.level = playerLevel[i]
		table.insert(self.m_tData,tempList)
	end

	table.sort(self.m_tData , sortMonthCard)
	self:update()
end

--@brief	全部标签排序
function sortMonthCard(a,b)
	if a.level ~= b.level then--是否已装备
		return a.level >= b.level 
	else 
		return a.id < b.id
	end
end




-------------------------------------私有方法模块End----------------------------------------
