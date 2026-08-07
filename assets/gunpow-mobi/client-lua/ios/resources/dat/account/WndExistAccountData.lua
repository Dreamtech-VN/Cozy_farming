--WndExistAccountData.lua
--@brief	WndExistAccount的数据模块
--@date		2014/01/24
--@author	SuYuan
--@note		已有账号窗口

WndExistAccount = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndExistAccount:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sAccount = nil				--账号
	self.m_sPassword = nil				--密码
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndExistAccount:_unInit()
	self.m_root = nil
	self.m_sAccount = nil
	self.m_sPassword = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndExistAccount:createElement()
	local element = WZUISystem:getInstance():createElement("WndExistAccount")
	assert(element, "WndExistAccount create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
