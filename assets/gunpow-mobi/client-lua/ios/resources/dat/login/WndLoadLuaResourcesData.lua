--WndLoadLuaResourcesData.lua
--@brief	WndLoadLuaResources的数据模块
--@date		2014/04/01
--@author	叶威
--@note		lua资源载入

WndLoadLuaResources = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLoadLuaResources:_init()
	self.m_root = nil	 	  			--场景根节点
	self.bLoadEnd = false
    self.m_loader = nil
    self.bConnectServer = false
    self.osTime = 0
    self.pointTime = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLoadLuaResources:_unInit()
	self.m_root = nil
	self.m_loader = nil
	self.bLoadEnd = nil
    self.bConnectServer = nil
    self.osTime = nil

    self.pointTime = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLoadLuaResources:createElement()
	local element = WZUISystem:getInstance():createElement("WndLoadLuaResources")
	assert(element, "WndLoadLuaResources create element failed!")
	self:_init()
	return element
end

--@brief	判断登陆场景是否已经退出
--@return	#1:登陆场景是否退出，true：未退出，false：已经退出
--@note		给外部提供的用来判断登陆场景是否已经退出的接口
function WndLoadLuaResources:isActive()
	if nil == self.m_root then
		return false
	end
	
	return true
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
