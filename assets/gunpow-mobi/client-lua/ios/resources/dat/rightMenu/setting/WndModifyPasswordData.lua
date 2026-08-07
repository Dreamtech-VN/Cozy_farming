--WndModifyPasswordData.lua
--@brief	WndModifyPassword的数据模块
--@date		2015-11-28
--@author	binshao
--@note	    修改密码

WndModifyPassword = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndModifyPassword:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_sMail = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndModifyPassword:_unInit()
    WZLog("WndModifyPassword:_unInit")
	self.m_root = nil
    self.m_sMail = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndModifyPassword:createElement()
	local element = WZUISystem:getInstance():createElement("WndModifyPassword")
	assert(element, "WndModifyPassword create element failed!")
	self:_init()
	return element
end

function WndModifyPassword:showWndUI()
    local wnd = WndModifyPassword:createElement()
    WindowManager:addWindow( wnd , WndModifyPassword )
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndModifyPassword:_createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(40,self,self._closeLoadingBox)
    end
end

function WndModifyPassword:_closeLoadingBox()
    MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
    self.loadingId = nil
end

-------------------------------------私有方法模块End----------------------------------------
