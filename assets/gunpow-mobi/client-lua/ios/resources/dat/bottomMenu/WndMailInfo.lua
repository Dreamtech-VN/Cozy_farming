--WndMailInfo.lua
--@brief	WndMailInfo的UI模块
--@date		2013/12/10
--@author	liangguang_long
--@note     读邮件内容模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMailInfo:onEnter(element)
	self.m_root = element	
	self:_initMoreLanguage()--多语言版本文本
	--描边字多语言版本
	self:_moreLanguageForStroke()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMailInfo:onExit(element)
	self:_unInit()
end

--@brief	陈列读取邮件内容函数
function WndMailInfo:readMail(element)
	if self.m_root ==nil then 
		return 
	end
	local txtRecvMailContent = self.m_root:getChildElement("txtRecvMailContent_WndMailInfo")
	if txtRecvMailContent == nil then 
		return 
	end	
	txtRecvMailContent = WZUILabelTTF:luaTo(txtRecvMailContent)	
	txtRecvMailContent:setText(self.m_sComtent)
end

--@brief	点击关闭按钮时回调函数
--@note		关闭读邮件内容界面，返回邮件列表界面并发送邮件列表协议
function WndMailInfo:onCloseClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root == nil then 
		return 
	end
	self.m_tColseFun[2](self.m_tColseFun[1],self.m_nCurIndex,self.m_nCurPage,1)
	--@brief   创建加载框
	WndMail:createLoading()
	--关闭读邮件内容界面，返回邮件列表界面
	WindowManager:removeWindow(self.m_root, WndMailInfo, true)
	
end 

--@brief	点击回复邮件按钮时回调函数
--@note	    跳转到写邮件界面
function WndMailInfo:onRecoverMail(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then 
		return 
	end
	--设置为不打开邮件
	WndMail:setIsOpenMail( false )
	WndMail:recveMail(self.m_sSendName , self.m_sTheme,nil,self.m_nMailType,self.m_nTag,self.m_nSenderId)	
	--关闭读邮件内容界面，返回邮件列表界面
	WindowManager:removeWindow(self.m_root, WndMailInfo, true)
end

--@brief	点击删除按钮时回调函数
function WndMailInfo:onDelReadMail(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then 
		return 
	end
	--设置为不打开邮件
	WndMail:setIsOpenMail( true )
	WndMail:setOpenMailId(self.m_nTag)
	local Vans = WZLuaVector_int_:create()	
	Vans:push(self.m_nMailId)
	if tonumber(self.m_nMailType) == 10 then
		ProtocolProcessorWndMail:send_NEARBY_DeleteNearbyMail(0,Vans)
	else
		ProtocolProcessorWndMail:send_MAIL_DeleteMail(Vans)
	end
	WindowManager:removeWindow(self.m_root , WndMailInfo , true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	界面更新函数
--@note     更新用户名账号，主题，时间,内容
function WndMailInfo:_update()
	if self.m_root == nil then 
		return 
	end
	
	--用户名账号
	local txtSenderMailFreecon = self.m_root:getChildElement("txtSenderMailFreecon_WndMailInfo")
	if txtSenderMailFreecon == nil then 
		return 
	end
	txtSenderMailFreecon = WZUILabelTTF:luaTo(txtSenderMailFreecon)
	txtSenderMailFreecon:setText(self.m_sSendName)
	
	--时间
	local txtTimeMailFreecon = self.m_root:getChildElement("txtTimeMailFreecon_WndMailInfo")
	if txtTimeMailFreecon == nil then 
		return 
	end
	txtTimeMailFreecon = WZUILabelTTF:luaTo(txtTimeMailFreecon)
	txtTimeMailFreecon:setText(self.m_sSendTime)
	
	--主题内容
	local txtThemeMailFreecon = self.m_root:getChildElement("txtThemeMailFreecon_WndMailInfo")
	if txtThemeMailFreecon == nil then 
		return 
	end
	txtThemeMailFreecon = WZUILabelTTF:luaTo(txtThemeMailFreecon)
	txtThemeMailFreecon:setText(self.m_sTheme)	
	--陈列读取邮件内容函数
	self:readMail(element)
	--更新邮件内容布局函数
	self:_updateMainInfo()
	--邮件列表可见
	self:_setMailInfoList(true)
end

--@brief	更换打开邮件标题图片
--@param	 nIndex:当前邮件列表复选框按下的索引,1为收件箱，2为发件箱
--@note     如果打开收件箱邮件，标题是收件内容，如果是打开发件箱邮件，标题是发件内容
function WndMailInfo:_changTitleImg( nIndex )
	if self.m_root == nil then 
		return 
	end
	--标题图片
	local imgThemeMailInfo = self.m_root:getChildElement("imgThemeMailInfo_WndMailInfo")
	if imgThemeMailInfo == nil then
		return 
	end
	imgThemeMailInfo = WZUIImage:luaTo(imgThemeMailInfo)
	if nIndex == 2 then --如果是发件箱打开邮件，邮件内容标题是发件内容
		imgThemeMailInfo:setFile("common/text/mail_outbox_title.png")
	end
end

--@brief   显示删除按钮函数
--@note	   如果打开收件箱邮件是显示删除,回复按钮，如果打开发件箱邮件是显示删除按钮
function WndMailInfo:_showDelRecevieBtn()
	if self.m_root == nil then 
		return 
	end
	--删除和回复按钮容器
	local conMailInfoDeleteBtn = self.m_root:getChildElement("conMailInfoDeleteBtn_WndMailInfo")
	if conMailInfoDeleteBtn == nil then 
		return 
	end
	conMailInfoDeleteBtn = WZUIContainer:luaTo(conMailInfoDeleteBtn)	
    --删除按钮容器
	local conOnlyDelMainInfo = self.m_root:getChildElement("conOnlyDelMainInfo_WndMainInfo")
	if conOnlyDelMainInfo == nil then 
		return 
	end
	conOnlyDelMainInfo = WZUIContainer:luaTo(conOnlyDelMainInfo)	
	--发件箱显示删除,回复按钮
	if self.m_nCurIndex == 1 then
		if self.m_nMailType == 0 or self.m_nMailType == 10 then
			return
		else
			conMailInfoDeleteBtn:setVisible(false)
			conOnlyDelMainInfo:setVisible(true)
		end
	elseif self.m_nCurIndex == 2 then --收件箱显示只有一个删除
		conMailInfoDeleteBtn:setVisible(false)
		conOnlyDelMainInfo:setVisible(true)
	end 
end

--@brief   设置邮件主题容器的位置
--@note    pos:邮件主题容器的相对位置
function WndMailInfo:_setMailThemePos( pos )
	if self.m_root == nil then
		return
	end
	local conMainTheme = self.m_root:getChildElement("conMainTheme_WndMainInfo")
	if conMainTheme == nil then
		return
	end
	conMainTheme = WZUIContainer:luaTo(conMainTheme)
	conMainTheme:setRelativePosition( pos )
end

--@brief	获取邮件主题容器的大小,位置
--@return	size:返回大小  	
--@return	pos:返回位置  	
--@note		size:返回邮件主题容器的大小,位置
function WndMailInfo:_getMailThemeSizePos()
	if self.m_root == nil then
		return
	end
	local conMainTheme = self.m_root:getChildElement("conMainTheme_WndMainInfo")
	if conMainTheme == nil then
		return
	end
	conMainTheme = WZUIContainer:luaTo(conMainTheme)
	local size = conMainTheme:getAbsContentSize()
	local pos = conMainTheme:getRelativePosition()
	return size	, pos
end

--@brief	获取邮件内容文本的大小
--@return	size:返回大小
--@note		size:返回邮件内容的大小
function WndMailInfo:_getMainInfoTxtSize()
	if self.m_root == nil then
		return
	end
	local txtRecvMailContent = self.m_root:getChildElement("txtRecvMailContent_WndMailInfo")
	if txtRecvMailContent == nil then
		return
	end
	txtRecvMailContent = WZUILabelTTF:luaTo(txtRecvMailContent)
	local size = txtRecvMailContent:getLabelContentSize()
	return size
end

--@brief   设置滚动容器Element的高度
--@note  nHeight:滚动容器Element新高度的值
function WndMailInfo:_setMoveElementHeight( nHeight )
	if self.m_root == nil then
		return
	end
	--滚动容器的节点
	local rollconMainInfo = self.m_root:getChildElement("rollconMainInfo_WndMainInfo")
	if rollconMainInfo == nil then
		return
	end
	rollconMainInfo = WZUIMoveContainer:luaTo(rollconMainInfo)
	--滚动容器Element节点
	local moveElement = rollconMainInfo:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize( size.width , nHeight ) )
end

--@brief   	获取滚动容器的大小
--@return	size:返回大小
--@note 	size:返回滚动容器大小
function WndMailInfo:_getMoveContainerSize()
	if self.m_root == nil then
		return
	end
	--滚动容器的节点
	local rollconMainInfo = self.m_root:getChildElement("rollconMainInfo_WndMainInfo")
	if rollconMainInfo == nil then
		return
	end
	rollconMainInfo = WZUIMoveContainer:luaTo(rollconMainInfo)	
	local size = rollconMainInfo:getAbsContentSize()
	return size
end

--@brief  	更新滚动容器内部布局函数
function WndMailInfo:_upMoveContainerLayer()
	if self.m_root == nil then
		return
	end
	--滚动容器的节点
	local rollconMainInfo = self.m_root:getChildElement("rollconMainInfo_WndMainInfo")
	if rollconMainInfo == nil then
		return
	end
	rollconMainInfo = WZUIMoveContainer:luaTo(rollconMainInfo)
	rollconMainInfo:UpdateInsidePosition()   --更新滚动容器内部布局
	local moveElement = rollconMainInfo:getMoveElement()
	moveElement:setPositionY( rollconMainInfo:getMinPosition().y)		
end

--@brief  	更新邮件内容布局函数
function WndMailInfo:_updateMainInfo()
	if self.m_root == nil then
		return
	end
	--获取邮件内容文本的大小
	local size = self:_getMainInfoTxtSize()
	--获取邮件主题容器的大小
	local themeSize , themePos = self:_getMailThemeSizePos()
	--获取滚动容器的大小
	local rollSize = self:_getMoveContainerSize()
	local nDisp = 50
	local nHeight = size.height + themeSize.height + nDisp
	--设置滚动容器Element的高度
	self:_setMoveElementHeight( (nHeight + 15 ) / rollSize.height )
	--更新滚动容器内部布局函数
	self:_upMoveContainerLayer()
	--设置邮件主题容器的位置
	local y = themeSize.height / nHeight
	themePos.y = 1 - y
	self:_setMailThemePos( themePos )
	
end

--@brief	邮件列表是否可见
function WndMailInfo:_setMailInfoList(bShow)
	local conRecvMailDetail = self.m_root:getChildElement("conRecvMailDetail_WndMailInfo")
	if conRecvMailDetail then
		conRecvMailDetail = WZUIContainer:luaTo(conRecvMailDetail)
		conRecvMailDetail:setVisible(bShow)
	end
end

--@brief	--多语言版本文本
function WndMailInfo:_initMoreLanguage()
	if self.m_root == nil then 
		return 
	end 
	local sender = LocalStrings.SENDER
	if WndMail:getCheckIndex() == 1 then
		sender = LocalStrings.SENDER
	elseif WndMail:getCheckIndex() == 2 then
		sender = LocalStrings.MAIL_RECV..":"
	end
	--发送者
	local tCell = self.m_root:getChildElement("txtOpenMailSender_WndMailInfo")
	self:_setTxt(tCell,sender)
	self:_setTxtPro(tCell,self.m_root:getChildElement("txtSenderMailFreecon_WndMailInfo"))
	--时间
	tCell = self.m_root:getChildElement("txtOpenMailTime_WndMailInfo")
	self:_setTxt(tCell,LocalStrings.TIME)
	self:_setTxtPro(tCell,self.m_root:getChildElement("txtTimeMailFreecon_WndMailInfo"))
	--主题
	tCell = self.m_root:getChildElement("txtOpenMailTheme_WndMailInfo")
	self:_setTxt(tCell,LocalStrings.MAIL_THEME)
	self:_setTxtPro(tCell,self.m_root:getChildElement("txtThemeMailFreecon_WndMailInfo"))
	
end


--@brief	多语言描边字
function WndMailInfo:_moreLanguageForStroke()
	if self.m_root == nil then
		return
	end
	--删除按钮
	local txtBtnDeleteMail = self.m_root:getChildElement("txtBtnDeleteMail_WndMailInfo")
	if txtBtnDeleteMail then
		txtBtnDeleteMail = WZUILabelTTF:luaTo(txtBtnDeleteMail)
		txtBtnDeleteMail:setText( LocalStrings.DELECT )	
	end
	--删除按钮
	local txtBtnDelete = self.m_root:getChildElement("txtBtnDelete_WndMailInfo")
	if txtBtnDelete then
		txtBtnDelete = WZUILabelTTF:luaTo(txtBtnDelete)
		txtBtnDelete:setText( LocalStrings.DELECT )
	end
	--回复按钮
	local txtBtnReply = self.m_root:getChildElement("txtBtnReply_WndMailInfo")
	if txtBtnReply then 
		txtBtnReply = WZUILabelTTF:luaTo(txtBtnReply)
		txtBtnReply:setText( LocalStrings.REPLY )
	end
end  


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin---------------------------------------




--------------------------------------语言适配模块End----------------------------------------











