--WndFyberData.lua
--@brief	WndFyber的数据模块
--@date		2016/12/20
--@author	zhangming
--@note		fyber广告奖励

WndFyber = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFyber:_init()
	self.m_root = nil	 	  			--场景根节点
	self.n_id = nil                     --ad弹窗的id
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFyber:_unInit()
	self.m_root = nil
	self.n_id = nil                     
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFyber:createElement()
	local element = WZUISystem:getInstance():createElement("WndFyber")
	assert(element, "WndFyber create element failed!")
	self:_init()
	return element
end


--@brief	创建场景
--@param	id, 场景的id 
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFyber:show(id)
	local wndFyber = WndFyber:createElement()
    WindowManager:addWindow(wndFyber,WndFyber)
    self.n_id = id
    self:_updateInfo()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
