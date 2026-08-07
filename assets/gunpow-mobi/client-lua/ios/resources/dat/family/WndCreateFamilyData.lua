--WndCreateFamilyData.lua
--@brief	WndCreateFamily的数据模块
--@date		2017/07/25
--@author	Tianxiang_Xu
--@note		创建家园窗口

WndCreateFamily = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCreateFamily:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCost = nil 					--创建花费
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCreateFamily:_unInit()
	self.m_root = nil
	self.m_tCost = nil 					
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCreateFamily:createElement()
	if WndCreateFamily.m_root ~= nil then
		WindowManager:removeWindow(WndCreateFamily.m_root, WndCreateFamily, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCreateFamily")
	assert(element, "WndCreateFamily create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndCreateFamily:showInterface()
	-- body
	local wndFamily = WndCreateFamily:createElement()
	if wndFamily then
		WindowManager:addWindow(wndFamily, WndCreateFamily, false, nil, nil, true)
	end
end

--@brief 	创建家园成功
function WndCreateFamily:createFamilyOK()
	-- body
	--进入家园场景
    SceneFamily:showInterface()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
