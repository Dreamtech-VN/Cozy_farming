--WndBuildingUpgradeData.lua
--@brief	WndBuildingUpgrade的数据模块
--@date		2017/07/25
--@author	Tianxiang_Xu
--@note		家园建筑升级窗口

WndBuildingUpgrade = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBuildingUpgrade:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBuildingData = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBuildingUpgrade:_unInit()
	self.m_root = nil
	self.m_tBuildingData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBuildingUpgrade:createElement()
	if WndBuildingUpgrade.m_root ~= nil then
		WindowManager:removeWindow(WndBuildingUpgrade.m_root, WndBuildingUpgrade, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBuildingUpgrade")
	assert(element, "WndBuildingUpgrade create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndBuildingUpgrade:showInterface(tBuildingData)
	-- body
	local wndBuildUpgrade = WndBuildingUpgrade:createElement()
	if wndBuildUpgrade then
		self.m_tBuildingData = CopyTable(tBuildingData)
		WindowManager:addWindow(wndBuildUpgrade, WndBuildingUpgrade, nil, nil, nil, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
