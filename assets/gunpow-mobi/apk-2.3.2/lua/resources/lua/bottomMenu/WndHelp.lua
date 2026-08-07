--WndHelp.lua
--@brief	WndHelp的UI模块
--@date		2014/01/14
--@author	liangguang_long
--@note		帮助模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHelp:onEnter(element)
	self.m_root = element
	--描边字多语言版本文本
	self:_moreLanguageForStroke()
	--语言包适配
	AdaptLanguage(self)
	self:_update()
	--获取帮助（BULLETINT_GetHelp = 5）
	ProtocolProcessorWndSetting:send_BULLETINT_GetHelp()
	--@brief   创建加载框
	self:createLoading()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHelp:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮回调函数
function WndHelp:onCloseClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root == nil then
		return
	end
	--关闭帮助窗口
	WindowManager:removeWindow( self.m_root , WndHelp , true )
end

--@brief	确定按钮回调函数
function WndHelp:onSureClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then
		return
	end
	--关闭帮助窗口
	WindowManager:removeWindow( self.m_root , WndHelp , true )
end

--@brief   创建加载框
function WndHelp:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndHelp:closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId(nId)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function WndHelp:_update()
	if self.m_root == nil or self.m_sHelp == nil then
		return
	end
	--设置说明文本内容
	self:_setExplanation( self.m_sHelp )
	--更新滚动容器内部布局
	self:_upMoveContainerLayer()
end

--@brief	设置说明文本内容函数
--@param	sText:文本内容,在这里是帮助说明内容
function WndHelp:_setExplanation( sText )
	if self.m_root == nil or sText == nil then
		return
	end
	local txtExplanation = self.m_root:getChildElement("txtExplanation_WndHelp")
	if txtExplanation == nil then
		return
	end
	txtExplanation = WZUILabelTTF:luaTo(txtExplanation)
	txtExplanation:setText( sText )
end

--@brief	获取说明文本的大小函数
--@return	size:返回文本内容的大小
function WndHelp:_getExplanationSize()
	if self.m_root == nil then
		return
	end
	local txtExplanation = self.m_root:getChildElement("txtExplanation_WndHelp")
	if txtExplanation == nil then
		return
	end
	txtExplanation = WZUILabelTTF:luaTo(txtExplanation)
	local size = txtExplanation:getContentSize()
	WZLog("size::::::1" , size.width , size.height)
	return size
end

--@brief  	更新滚动容器内部布局函数
function WndHelp:_upMoveContainerLayer()
	if self.m_root == nil then
		return
	end
	--获取说明文本大小
	local txtSize = self:_getExplanationSize()
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndHelp")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize( size.width , txtSize.height / rollSize.height ) )
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
end

--@brief	描边字多语言版本文本
function WndHelp:_moreLanguageForStroke()
	if self.m_root == nil then
		return
	end
	local txtSure = self.m_root:getChildElement("txtBtnSure_WndHelp")
	if txtSure then
		txtSure = WZUILabelTTF:luaTo(txtSure)
		txtSure:setText( LocalStrings.CONFIRM)
	end
end



-------------------------------------私有方法模块End----------------------------------------
