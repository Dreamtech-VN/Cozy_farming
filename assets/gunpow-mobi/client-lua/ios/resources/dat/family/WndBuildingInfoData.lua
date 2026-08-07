--WndBuildingInfoData.lua
--@brief	WndBuildingInfo的数据模块
--@date		2017/07/30
--@author	Tianxiang_Xu
--@note		建筑信息界面

WndBuildingInfo = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBuildingInfo:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBuildingData = nil 
	self.m_nType = nil 					--默认家园建筑；2->小家建筑
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBuildingInfo:_unInit()
	self.m_root = nil
	self.m_tBuildingData = nil 
	self.m_nType = nil 					--默认家园建筑；2->小家建筑
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBuildingInfo:createElement()
	if WndBuildingInfo.m_root ~= nil then
		WindowManager:removeWindow(WndBuildingInfo.m_root, WndBuildingInfo, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBuildingInfo")
	assert(element, "WndBuildingInfo create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndBuildingInfo:showInterface(tBuildingData, nType)
	-- body
	local wndBuildInfo = WndBuildingInfo:createElement()
	if wndBuildInfo then
		self.m_tBuildingData = CopyTable(tBuildingData)
		self.m_nType = nType
		WindowManager:addWindow(wndBuildInfo, WndBuildingInfo, nil, nil, nil, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
