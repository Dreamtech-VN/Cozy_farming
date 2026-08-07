--WndActivities.lua
--@brief	WndActivities的UI模块
--@date		2014/01/08
--@author	liangguang_long
--@note		活动广场模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndActivities:onEnter(element)
	--SoundManager:playBgMusic(SoundDefine.E_S_OPEN_WIN)
	self.m_root = element
	--注册协议组所有协议
	ProtocolProcessorWndActivities:regAll()
	--获取广场信息（SQUARE_GetInfo = 1）
	ProtocolProcessorWndActivities:send_SQUARE_GetInfo()
	--@brief   创建加载框
	--self:createLoading()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndActivities:onExit(element)
	WZLog("WndActivities:onExit()")
	self:_unInit()
	--反注册协议组所有协议
	ProtocolProcessorWndActivities:unregAll()
	g_checkLoginActivities = false
end

--@brief	关闭按钮回调函数
function WndActivities:onCloseClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then
		return
	end
	if self.extendParameters == "clickFacebook" then
		ProtocolProcessorPrefetchCache:send_TASK_AddFaceBookNum(2,"")
	end
	--关闭活动广场窗口
	WindowManager:removeWindow( self.m_root , WndActivities , true )
	WZLog("WndActivities::::end")
end

--@brief	打开网站成功回调函数
function WndActivities:onOpenUrlSuccess(url,a)
    WZLog("WndActivities:onOpenUrlSuccess()",url,a)
	if self.m_root == nil then
		return
	end
    GetElement(self.m_root,"conTitle_WndActivities",WZUIContainer):setVisible(true)
	--关闭加载框
	self:closeLoading()
end

--@brief	打开网站失败回调函数
function WndActivities:onOpenUrlFail()
	WZLog("Open URL Fail::::::")
	if g_checkLoginActivities == false then
		MsgBoxManager:showTipBox( LocalStrings.URLFAIL )
	end
	--关闭活动广场窗口
	self:closeLoading()
	WindowManager:removeWindow( self.m_root , WndActivities , true )
end

--@brief   创建加载框
function WndActivities:createLoading()
	WZLog("WndActivities:createLoading")
	self.m_nLoadingId = MsgBoxManager:showLoadingBox(-1)
end

--@brief   关闭加载框
function WndActivities:closeLoading()
	WZLog("WndActivities:closeLoading")
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId(nId)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function WndActivities:_update()
	if self.m_root == nil or self.m_sSqureUrl == nil then 
		return 
	end
	--设置活动网址函数
	self:_setActivityUrl( self.m_sSqureUrl )
end

--@brief	设置活动网址函数
--@param	sActivityUrl:活动网址
function WndActivities:_setActivityUrl( sActivityUrl,sExtendParameter)
	if self.m_root == nil or sActivityUrl == nil then
		return
	end
	if sExtendParameter then
		self.extendParameters = sExtendParameter
	end
	local webviewUrl = self.m_root:getChildElement("webviewUrl_WndActivities")
	if webviewUrl == nil then
		return
	end
	webviewUrl = WZUIWebView:luaTo(webviewUrl)
	WZLog("url:::::::::::::::::1" , sActivityUrl)
	--sActivityUrl = "http://oa.zhwyd.com:8081/newddd/square/CN_0_4/indexNew_201312910583485.html"	
	webviewUrl:setURL ( sActivityUrl )
	webviewUrl:setScalesPageToFit(true)
end



-------------------------------------私有方法模块End----------------------------------------
