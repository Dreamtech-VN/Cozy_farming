--WndSpreeRewardsData.lua
--@brief	WndSpreeRewards的数据模块
--@date		2014/01/17
--@author	xiaoyu_wu
--@note		获得奖励模块

WndSpreeRewards = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSpreeRewards:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tItemList = nil             --物品列表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSpreeRewards:_unInit()
	self.m_root = nil
    self.m_tItemList = nil             --物品列表
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSpreeRewards:createElement()
	local element = WZUISystem:getInstance():createElement("WndSpreeRewards")
	assert(element, "WndSpreeRewards create element failed!")
	self:_init()
	return element
end

--@brief	设置奖励物品列表数据
--@param	tItemName，奖励物品名称列表
--@param	tItemIcon，奖励物品图标路径列表
--@param	tItemNum，奖励物品数量列表
function WndSpreeRewards:setItemList(tItemName, tItemIcon, tItemNum)
    self.m_tItemList = {}
    self.m_tItemList.nCount = #tItemName
    self.m_tItemList.tItemName = tItemName
    self.m_tItemList.tItemIcon = tItemIcon
    self.m_tItemList.tItemNum = tItemNum
    --WZLog(Serialize(self.m_tItemList))
    self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
