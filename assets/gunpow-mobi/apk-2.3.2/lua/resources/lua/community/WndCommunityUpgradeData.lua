--WndCommunityUpgradeData.lua
--@brief	WndCommunityUpgrade的数据模块
--@date		2015/04/27
--@author	zsq
--@note		公会升级

WndCommunityUpgrade = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityUpgrade:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = nil			--0公会升级，1图腾升级,2技能学堂升级,3商店升级
	self.m_nCost = nil 			--公会升级需要的威望
	self.m_nCostZuan = nil
	self.m_nCostId = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityUpgrade:_unInit()
	self.m_root = nil
	self.m_nType = nil
	self.m_nCost = nil 			--公会升级需要的威望
	self.m_nCostZuan = nil
	self.m_nCostId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityUpgrade:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityUpgrade")
	assert(element, "WndCommunityUpgrade create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
