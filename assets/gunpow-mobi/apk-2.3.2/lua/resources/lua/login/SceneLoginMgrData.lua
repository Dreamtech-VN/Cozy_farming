--SceneLoginMgrData.lua
--@brief	SceneLoginMgr的数据模块
--@date		2016-5-20
--@author	binshao
--@note		登录模块

SceneLoginMgr = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneLoginMgr:_init()
	self.m_root = nil	 	  			--场景根节点
    self.t_position = {}
    self.m_bIsCloseGravity = false
    self.m_bIsCreate = true
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneLoginMgr:_unInit()
	self.m_root = nil
    self.t_position = nil 
    self.m_bIsCloseGravity = nil 
    self.m_bIsCreate = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneLoginMgr:createElement()
	local element = WZUISystem:getInstance():createElement("SceneLoginMgr")
	assert(element, "SceneLoginMgr create element failed!")
	self:_init()
	return element
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------