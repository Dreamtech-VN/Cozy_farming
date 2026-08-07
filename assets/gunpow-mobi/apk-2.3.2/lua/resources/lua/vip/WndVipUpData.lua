--WndVipUpData.lua
--@brief	WndVipUp的数据模块
--@date		2015-11-18
--@author	binshao
--@note		VIP等级提升

WndVipUp = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndVipUp:_init()
	self.m_root = nil	 	  			--场景根节点
    self.canClick = false
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndVipUp:_unInit()
	self.m_root = nil
    self.canClick = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndVipUp:createElement()
	if self.m_root then
		WindowManager:removeWindow(self.m_root,WndVipUp)
	end
	local element = WZUISystem:getInstance():createElement("WndVipUp")
	assert(element, "WndVipUp create element failed!")
	self:_init()
	return element
end


--@brief 显示恩爱等级升级动画
function WndVipUp:showWndUI()
	local element = WndVipUp:createElement()
	WindowManager:addWindow(element,WndVipUp,nil,nil,nil,false)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
