--SceneLoginData.lua
--@brief	SceneLogin的数据模块
--@date		2013/12/09
--@author	SuYuan
--@note		登陆界面

SceneLogin = {
	--请不要在这里定义变量
    g_curerntUserAccount = nil
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneLogin:_init()
	self.m_root = nil	 	  			--场景根节点

	self.m_loginType = 0                --登录方式（0 UDID登陆，1 账号登陆，2 SDK方式登陆）
    

    self.m_callback = nil               --得到账号密码 回调函数
    self.m_callbacktable = nil          --得到账号密码 回调表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneLogin:_unInit()
	self.m_root = nil
    self.m_callback = nil            
    self.m_callbacktable = nil         
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneLogin:createElement()
	local element = WZUISystem:getInstance():createElement("SceneLogin")
	assert(element, "SceneLogin create element failed!")
	self:_init()
	return element
end

--@brief	判断登陆场景是否已经退出
--@return	#1:登陆场景是否退出，true：未退出，false：已经退出
--@note		给外部提供的用来判断登陆场景是否已经退出的接口
function SceneLogin:isActive()
	if nil == self.m_root then
		return false
	end
	
	return true
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
