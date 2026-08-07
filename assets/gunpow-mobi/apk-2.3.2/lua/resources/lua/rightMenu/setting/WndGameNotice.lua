--WndGameNotice.lua
--@brief	WndGameNotice的UI模块
--@date		2015-04-30
--@author	binshao
--@note		设置界面的公告

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGameNotice:onEnter(element)
    WZLog("WndGameNotice:onEnter")
	self.m_root = element
	self:_initLanguage( )
	ProtocolProcessorWndSetting:send_BULLETINT_GetAbout()
end

--@brief    弹窗动画完成后的回调
function WndGameNotice:actionCallback(element, data)
	self:_update()
end

--@brief onEnter函数执行完成回调
function WndGameNotice:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGameNotice:onExit(element)
    WZLog("WndGameNotice:onExit")
	self:_unInit()
end

function WndGameNotice:normalClose(  )
	WindowManager:removeWindow(self.m_root , WndGameNotice , true)
end


-- @brief  关闭公告界面Btn
function WndGameNotice:onBtnClose( )
	WZLog("WndGameNotice:onBtnCloseClick---------------------:")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	
	if self.m_root then WindowManagerAni:createCloseAction(self.m_root,"normalClose",self) end
end

-------------------------------------公有方法模块End--------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function WndGameNotice:_update()
	if self.m_root == nil then return end
	--设置说明文本内容
	self:_setText( self.m_sText )
	--更新滚动容器内部布局
	self:_upMoveContainerLayer()
end

--@brief	设置说明文本内容函数
--@param	sText:文本内容,在这里是关于说明内容
function WndGameNotice:_setText( sText )
	if self.m_root == nil or sText == nil then return end

	local txtNotice = self.m_root:getChildElement("txtNotice_WndGameNotice")
	if txtNotice == nil then return end
	txtNotice = WZUILabelTTF:luaTo(txtNotice)
	
	--91渠道特殊处理
	if USE_91IOS_SDK == ProjConfig.CHANNEL_ID then
		txtNotice:setText(LocalStrings.SDK91_ABOUT_TEXT .. WGameCmUtil:getAppVersion())
	else
		txtNotice:setText( sText )
	end
end

--@brief	获取说明文本的大小函数
--@return	size:返回文本内容的大小
function WndGameNotice:_getTextSize()
	if self.m_root == nil then return end

	local txtNotice = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtNotice_WndGameNotice"))
	if txtNotice then return txtNotice:getContentSize() end
end

--@brief  	更新滚动容器内部布局函数
function WndGameNotice:_upMoveContainerLayer()
	if self.m_root == nil then return end

	--文本大小size
	local txtSize = self:_getTextSize()

	-- 滑动层size
	local scroll = self.m_root:getChildElement("scrollNotice_WndGameNotice")
	if scroll == nil then  return end
	scroll = WZUIMoveContainer:luaTo(scroll)
	local scrollSize = scroll:getContentSize()

	--更改滚动容器Element的大小
	local moveElement = scroll:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize( size.width , txtSize.height / scrollSize.height ) )
	scroll:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(scroll:getMinPosition().y)
end

function WndGameNotice:_initLanguage( )

end
-------------------------------------私有方法模块End----------------------------------------
