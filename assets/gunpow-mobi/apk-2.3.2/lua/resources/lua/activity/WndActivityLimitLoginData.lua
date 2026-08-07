--WndActivityLimitLoginData.lua
--@brief	WndActivityLimitLogin的数据模块
--@date		2021/04/30
--@author	hyx
--@note		限时登录

WndActivityLimitLogin = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndActivityLimitLogin:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tLimitLoginData = {}
	self.m_nCurIndex = 1
	self.m_tCellLimitLoginItem = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndActivityLimitLogin:_unInit()
	self.m_root = nil
	self.m_tLimitLoginData = {}
	self.m_nCurIndex = 1
	self.m_tCellLimitLoginItem = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndActivityLimitLogin:createElement()
	if WndActivityLimitLogin.m_root ~= nil then
		WindowManager:removeWindow(WndActivityLimitLogin.m_root, WndActivityLimitLogin, true)
	end
	local element = WZUISystem:getInstance():createElement("WndActivityLimitLogin")
	assert(element, "WndActivityLimitLogin create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
