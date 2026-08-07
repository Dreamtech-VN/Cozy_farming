--WndGangsterInnOwner.lua
--@brief	WndGangsterInnOwner的UI模块
--@date		2016/10/11
--@author	zsq
--@note		黑店店主


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGangsterInnOwner:onEnter(element)
	self.m_root = element
end

function WndGangsterInnOwner:onEnterTransitionDidFinish(element)
	local tNewUserPackageList = CacheCenter:getLimitPackageList()
	if self.m_nType == 1 then
		GetElement(self.m_root,"imgGangsterInn_WndGangsterInnOwner",WZUIImage):setFile("ui/inn/common_icon_lxsrcxl.png")
	else
		GetElement(self.m_root,"imgGangsterInn_WndGangsterInnOwner",WZUIImage):setFile("ui/inn/common_icon_heissrcxl.png")
	end
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndGangsterInnOwner:actionCallback(element, data)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGangsterInnOwner:onExit(element)
	self:_unInit()
end

--@brief	点击窗口
function WndGangsterInnOwner:onTouchBegan()
	WZLog("WndGangsterInnOwner:onTouchBegan")
	-- WindowManager:removeWindow(self.m_root, self, true)

	
	--local wnd = WndGangsterInn:createElement()
    --WindowManager:addWindow(wnd, WndGangsterInn, false)
    if g_isFirstGangsterInnShow == true and WndOwnCity and WndOwnCity.m_root then
		local nodeBtn = WndOwnCity.m_root:getChildByTag(505)
		WindowManagerAni:createDisappearAction2(self.m_root, self.onCloseActionCallback, self, nil, nodeBtn)
    else
    	WindowManager:removeWindow(self.m_root, self, true)
		WndStore:showStoreByType(6)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndGangsterInnOwner:onCloseActionCallback( ... )
	g_isFirstGangsterInnShow = false
	WindowManager:removeWindow(self.m_root, self, true)
end




-------------------------------------私有方法模块End----------------------------------------
