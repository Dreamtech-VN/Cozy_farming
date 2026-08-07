--WndSelectTipsStrengthenData.lua
--@brief	WndSelectTipsStrengthen的数据模块
--@date		2015/06/09
--@author	zsq
--@note		选择宝石或装备界面

WndUpgradeGem = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndUpgradeGem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil
	self.m_nTargetStoneId = nil
	self.m_tCell1 = nil
	self.m_tCell2 = nil
	self.m_tCell3 = nil
	self.m_nSelected = nil
	self.m_tDataList = nil
	self.m_tTotalCost = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndUpgradeGem:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_nTargetStoneId = nil
	self.m_tCell1 = nil
	self.m_tCell2 = nil
	self.m_tCell3 = nil
	self.m_nSelected = nil
	self.m_tDataList = nil
	self.m_tTotalCost = {}
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndUpgradeGem:createElement()
	local element = WZUISystem:getInstance():createElement("WndUpgradeGem")
	assert(element, "WndUpgradeGem create element failed!")
	self:_init()
	return element
end

--@brief    外部调用创建此窗口
function WndUpgradeGem:show(tData, stoneId, parentNode)
	WZLog("WndUpgradeGem:show",tag)
	parentNode:removeAllChildrenWithCleanup(true)
	local wnd = WndUpgradeGem:createElement()
	parentNode:addChild(wnd)
	
	self.m_tData = tData
	self.m_nTargetStoneId = stoneId
	
	self:update()
end
-------------------------------------公有方法模块End----------------------------------------

