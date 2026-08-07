--WndGangsterInnOwnerData.lua
--@brief	WndGangsterInnOwner的数据模块
--@date		2016/10/11
--@author	zsq
--@note		黑店店主

WndGangsterInnOwner = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGangsterInnOwner:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGangsterInnOwner:_unInit()
	self.m_root = nil
	self.m_nType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGangsterInnOwner:createElement()
	local element = WZUISystem:getInstance():createElement("WndGangsterInnOwner")
	assert(element, "WndGangsterInnOwner create element failed!")
	self:_init()
	return element
end

function WndGangsterInnOwner:showWindow( ntype)
	local wnd = WndGangsterInnOwner:createElement()
	self.m_nType = ntype or 0
    WindowManager:addWindow(wnd, WndGangsterInnOwner, false)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
