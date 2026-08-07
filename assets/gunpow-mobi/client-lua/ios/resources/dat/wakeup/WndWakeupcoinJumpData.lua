--WndWakeupcoinJumpData.lua
--@brief	WndWakeupcoinJump的数据模块
--@date		2017/05/27
--@author	Tianxiang_Xu
--@note		觉醒之晶解析界面

WndWakeupcoinJump = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWakeupcoinJump:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurPageIndex = nil 
	self.m_tImageList = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWakeupcoinJump:_unInit()
	self.m_root = nil
	self.m_nCurPageIndex = nil 
	self.m_tImageList = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWakeupcoinJump:createElement()
	if WndWakeupcoinJump.m_root ~= nil then
		WindowManager:removeWindow(WndWakeupcoinJump.m_root, WndWakeupcoinJump, true)
	end
	local element = WZUISystem:getInstance():createElement("WndWakeupcoinJump")
	assert(element, "WndWakeupcoinJump create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndWakeupcoinJump:showInterface()
	-- body
	local wndWake = WndWakeupcoinJump:createElement()
	if wndWake then
		WindowManager:addWindow(wndWake, WndWakeupcoinJump, nil, nil, nil, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
