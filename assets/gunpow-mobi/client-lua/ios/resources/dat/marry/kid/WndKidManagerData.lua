--WndKidManagerData.lua
--@brief	WndKidManager的数据模块
--@date		2018/05/09
--@author	Tianxiang_Xu
--@note		小孩管理界面

WndKidManager = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidManager:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTabIndex = nil 					--标签索引
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidManager:_unInit()
	self.m_root = nil
	self.m_nTabIndex = nil 					--标签索引
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidManager:createElement()
	if WndKidManager.m_root ~= nil then
		WindowManager:removeWindow(WndKidManager.m_root, WndKidManager, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidManager")
	assert(element, "WndKidManager create element failed!")
	self:_init()
	return element
end

--@brief 	外部调用接口
function WndKidManager:showInterface(nIndex)
	-- body
	local wndManager = WndKidManager:createElement()
	self.m_nTabIndex = nIndex or 1
	WindowManager:addWindow(wndManager, WndKidManager, nil, nil, nil, true)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
