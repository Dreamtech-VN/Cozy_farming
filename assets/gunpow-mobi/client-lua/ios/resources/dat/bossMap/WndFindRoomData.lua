--WndFindRoomData.lua
--@brief	WndFindRoom的数据模块
--@date		2015-7-20
--@author	binshao
--@note		查找房间窗口

WndFindRoom = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFindRoom:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_findBtnCallBack = nil        --要传入的查找按钮回调函数
	self.m_tCallBackLuaObject = nil     --回调函数所在的表对象
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFindRoom:_unInit()
	self.m_root = nil
	self.m_findBtnCallBack = nil        --要传入的查找按钮回调函数
	self.m_tCallBackLuaObject = nil     --回调函数所在的表对象
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFindRoom:createElement()
	local element = WZUISystem:getInstance():createElement("WndFindRoom")
	assert(element, "WndFindRoom create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
