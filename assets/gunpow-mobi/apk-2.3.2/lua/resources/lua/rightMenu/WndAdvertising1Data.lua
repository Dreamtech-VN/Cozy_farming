--WndAdvertising1Data.lua
--@brief	WndAdvertising1的数据模块
--@date		2016/09/23
--@author	zsq
--@note		活动内广告页面

WndAdvertising1 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAdvertising1:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nIndex = nil
	self.m_nDownLoading = nil
	--self.m_nCurAddPage = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAdvertising1:_unInit()
	self.m_root = nil
	self.m_nIndex = nil
	self.m_nDownLoading = nil
	--self.m_nCurAddPage = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAdvertising1:createElement()
	local element = WZUISystem:getInstance():createElement("WndAdvertising1")
	assert(element, "WndAdvertising1 create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
