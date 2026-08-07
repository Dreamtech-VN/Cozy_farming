--WndSetting.lua
--@brief	WndSetting的UI模块
--@date		2015/04/22
--@author	binshao
--@note		设置模块

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSetting:onEnter(element)
    WZLog("sun---WndSetting:onEnter")
	self.m_root = element
	AdaptLanguage(self)
	self.m_nSoundState = SoundManager:getSoundState()
    self:_initMoreLanguage()
    self:_initUIstate()
	--注册协议组所有协议
	ProtocolProcessorWndSetting:regAll()

    local conBind = GetElement(self.m_root,"conBindMail_WndSetting",WZUIContainer)
    if PassportSdkManager:needLogin() or not g_isRegist then
        conBind:setVisible(false)
    else
        conBind:setVisible(true)
    end

    if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1043 then
    	local element = GetElement(self.m_root,"conShieldPlayer_WndSetting",WZUIContainer)
    	if element then
    		element:setVisible(false)
    	end
    end

    -- if true or ProjConfig.LANGUAGE == "vn" then
    -- 	GetElement(self.m_root,"conBindVn_WndSetting",WZUIContainer):setVisible(true)
    -- end

    self:modifyMailStateDesc()
end

--@brief    弹窗动画完成后的回调
function WndSetting:actionCallback(element, data)

end

--@brief onEnter函数执行完成回调
function WndSetting:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAppearAction(self.m_root, true, "actionCallback", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSetting:onExit(element)
	self:_unInit()
	--反注册协议组所有协议
	ProtocolProcessorWndSetting:unregAll()
end

--@brief	关闭整个窗口的动画效果
function WndSetting:onCloseActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , WndSetting , true)
end

--@brief	关闭设置界面btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnCloseClick( element )
	WZLog("sun---WndSetting:onBtnCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if not self.m_root then return end
	WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

--@brief	关闭设置界面btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnPswClick( element )
	WZLog("sun---WndSetting:onBtnPswClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_root then return end
	WndModifyPassword:showWndUI()
end

--@brief	越南包游客绑定的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnTouristsVnClick( element )
	WZLog("sun---WndSetting:onBtnTouristsVnClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_root then return end
	DoTouristsVn()
end

--@brief	关闭设置界面btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnLinkClick( element )
	WZLog("sun---WndSetting:onBtnLinkClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_root then return end
	WndActivities:showView()
    WndActivities:_setActivityUrl("https://www.facebook.com/messages/t/1300732029957097")
end

--@brief	音效checkbox的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onCheckSoundClick( element )
	WZLog("sun---WndSetting:onCheckSoundClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	-- 更新声音的状态，记录文件
	self.m_nSoundState = self.m_nSoundState == 1 and 0 or 1
	SoundManager:setEffectSoundMute(self.m_nSoundState,true)
	AudioManager:_refreshBackgroundMusic()
end

--@brief	背景音乐checkbox的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onCheckMusicClick( element )
	WZLog("sun---WndSetting:onCheckSoundClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	-- 更新声音的状态，记录文件
	self.m_nMusicState = self.m_nMusicState == 1 and 0 or 1
	SoundManager:setBgMusicMute(self.m_nMusicState,true)
	AudioManager:_refreshBackgroundMusic()
end

--@brief	屏蔽周围玩家checkbox的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onCheckShieldClick( element )
	WZLog("sun---WndSetting:onCheckShieldClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	-- 更新屏蔽周围玩家的状态，记录文件
	self.m_nShieldState = self.m_nShieldState == 1 and 0 or 1
    FigureSceneManager:setOtherVisible(self.m_nShieldState)

	--TODO:屏蔽周围玩家的接口
end

--@brief	语音自动播放checkbox的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onSoundDone( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndSetting:onSoundDone:",element:getTag())
	if self.m_addVolume == 0 then
		self.m_addVolume = 10
	else
	 	return
	end
	local tag =  element:getTag()
	self:setVolume(tag)
	element:disableSchedule()
end

function WndSetting:onSoundOut( element )
	WZLog("WndSetting:onSoundOut:")
	element:disableSchedule()
end

--@brief	设置音量
--@param	tag
function WndSetting:setVolume()

	if self.m_VolumeTag == 1 then --音乐减少
		self.m_initMusicVolume = math.max(0, self.m_initMusicVolume - 10)
		GetElement(self.m_root, "txtMusic_WndSetting", WZUILabelTTF):setText(self.m_initMusicVolume)
		AudioManager:setBackgroundMusicVolume(self.m_initMusicVolume/100)
	elseif self.m_VolumeTag == 2 then --音乐增加
		self.m_initMusicVolume = math.min(100, self.m_initMusicVolume + 10)
		GetElement(self.m_root, "txtMusic_WndSetting", WZUILabelTTF):setText(self.m_initMusicVolume)
		AudioManager:setBackgroundMusicVolume(self.m_initMusicVolume/100)
	elseif self.m_VolumeTag == 3 then --音效减少
		self.m_initSoundVolume = math.max(0, self.m_initSoundVolume - 10)
		GetElement(self.m_root, "txtSound_WndSetting", WZUILabelTTF):setText(self.m_initSoundVolume)
		AudioManager:setEffectsVolume(self.m_initSoundVolume/100)
	elseif self.m_VolumeTag == 4 then --音效增加
		self.m_initSoundVolume = math.min(100, self.m_initSoundVolume + 10)
		GetElement(self.m_root, "txtSound_WndSetting", WZUILabelTTF):setText(self.m_initSoundVolume)
		AudioManager:setEffectsVolume(self.m_initSoundVolume/100)
	end
end

--@brief	语音自动播放checkbox的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onSoundPush( element )
	WZLog("WndSetting:onSoundPush:",element:getTag())
	self.m_addVolume = 0
	local tag =  element:getTag()
	self.m_VolumeTag = tag
	element:enableSchedule("updateVolume",0.5)
end

--@brief  更新音量的大小
function  WndSetting:updateVolume(element)
	self:setVolume()
	local button = WZUIButton:luaTo(element)
	if not button:isSelectStatus() then
		element:disableSchedule()
	end
end

--@brief	语音自动播放checkbox的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onCheckTalkClick( element )
	WZLog("sun---WndSetting:onCheckTalkClick22")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	-- 更新自动播放语音的状态，记录文件
	self.m_playTalk = self.m_playTalk == 1 and 0 or 1
	local data = WZDataFile:getInstance():getUserData()
	if data then		
		data:setStringValue("TalkData", "playTalk", ""..self.m_playTalk)
		data:flush()
	end
end

--@brief	屏蔽好友邀请checkbox的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onCheckInviteClick( element )
	WZLog("sun---WndSetting:onCheckInviteClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	-- 更新拒绝好友的状态，记录文件
	self.m_nInviteState = self.m_nInviteState == 1 and 0 or 1
	G_Friend_BeInvite = self.m_nInviteState
	local data = WZDataFile:getInstance():getUserData()
	if data then		
		data:setStringValue("Invite", "Friend", ""..self.m_nInviteState)
		data:flush()
	end
end

--@brief	屏蔽战队邀请checkbox的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onCheckCorpsClick( element )
	WZLog("sun---WndSetting:onCheckCorpsClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	-- 更新拒绝好友的状态，记录文件
	self.m_nCorpsState = self.m_nCorpsState == 1 and 0 or 1
	G_Corps_INVITE = self.m_nCorpsState
	local data = WZDataFile:getInstance():getUserData()
	if data then		
		data:setStringValue("Invite", "Corps", ""..self.m_nCorpsState)
		data:flush()
	end
end

--@brief	屏蔽好友邀请checkbox的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onCheckAllInviteClick( element )
	WZLog("sun---WndSetting:onCheckAllInviteClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	-- 更新拒绝陌生人的状态，记录文件
	self.m_nAllInviteState = self.m_nAllInviteState == 1 and 0 or 1
	local data = WZDataFile:getInstance():getUserData()
	if data then		
		data:setStringValue("Invite", "AllInvite", ""..self.m_nAllInviteState)
		data:flush()
	end
	G_Stranger_BeInvite = self.m_nAllInviteState
end

--@brief	兑换礼包btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnGiftClick( element )
	WZLog("sun---WndSetting:onBtnGiftClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wndGift = WndGameGift:createElement()
    if wndGift then WindowManager:addWindow( wndGift , WndGameGift ) end
end

--@brief	兑换礼包btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnMailClick( element )
    WZLog("sun---WndSetting:onBtnMailClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("------------------bindInfo----------------",g_isBindMail)
--    if g_isBindMail then
--        MsgBoxManager:showTipBox(LocalStrings.SETTING_BINDED_MAIL, nil, nil, nil, nil)
--        return
--    end
    local wndMail = WndBindMail:createElement()
    WindowManager:addWindow( wndMail , WndBindMail )
end

--@brief	分享游戏btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnShareClick( element )
	WZLog("sun---WndSetting:onBtnShareClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if SNSSdkManager:hasChanel("facebook") then
		SNSSdkManager:shareFacebook();
	else
		MsgBoxManager:showTipBox(LocalStrings.CLOSE_SCRIPT)
	end
	-- local wndShare= WndGameShare:createElement()
	-- if wndShare then WindowManager:addWindow(wndShare , WndGameShare) end
end

--@brief	意见邮箱btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnAdviseClick( element )
    WZLog("sun---WndSetting:onBtnAdviseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local packName = WGameCmUtil:GetBundleIdentifier()
	if packName == "com.herogame.bombleadsa" then
		WZLog("sun---WndSetting:onBtnAdviseClick")
		PassportSdkManager:postGameInfoHK("showConversation")
		return
	end
	WZLog("sun---WndSetting:onBtnAdviseClick")
	local curSdkObj = PushSdkManager:getCurSdkObj()
  	if curSdkObj then
  		WZLog("sun---WndSetting:onBtnAdviseClick")
    	local config = curSdkObj.m_tConfig
    	if config then
    		WZLog("sun---WndSetting:onBtnAdviseClick--config")
    	else
    		WZLog("sun---WndSetting:onBtnAdviseClick--config nil")
    	end
    	if config.SDKOtherConfig.isOpenFeedback == "true" then
    		WZLog("sun---WndSetting:onBtnAdviseClick--isOpenFeedback:" .. config.SDKOtherConfig.isOpenFeedback)
    		if config.SDKOtherConfig.feedbackUrl and config.SDKOtherConfig.im_user_key then --动态自定义支付界面
    			WZLog("sun---WndSetting:onBtnAdviseClick--isOpenFeedback:true")
    			--android上传玩家信息
				local postData = {}
				postData.funType = "feedback"
				postData.feedbackUrl = config.SDKOtherConfig.feedbackUrl
				postData.im_user_key = config.SDKOtherConfig.im_user_key
				local language = WZFileUtil:getNodeValueFromXml("Language")
				local data = WZDataFile:getInstance():getUserData()
				if data then		
					local language1 = data:getStringValue("LanguageData", "language")
					WZLog("---WndSetting:onBtnAdviseClick--language:" .. language .. "-language1:" .. language1)
					if language1 ~= nil and language1 ~= "" then
						language = language1
					end
				end
				postData.language = language
				local playInfo = CacheCenter:getPlayerInfo()
				postData.serverName = IPDhttpServer:getCurServerName()
				postData.serverId = "" .. IPDhttpServer:getCurServerId()     --服务器id
				if playInfo  then
				    postData.guildName = playInfo.guildName
				    postData.vipLevel = playInfo.vipLevel
				    postData.roleName = playInfo.name
				    postData.roleId = playInfo.id 
				    postData.roleLevel = playInfo.level
				    postData.partyId = playInfo.guildId
				    if playInfo.sex == 0 then
				        postData.gender = LocalStrings.CHARM_BOY
				    else
				        postData.gender = LocalStrings.CHARM_GIRL
				    end
				    postData.rolePower = playInfo.fighting
				end
				local moneyList = CacheCenter:getMoneyList()
				if moneyList  then
				    postData.balance = moneyList.blueDiamond
				end
				PushSdkManager:others(json.encode(postData))
				return
			end
    	end
  	end

	local wndAdvise = WndGameAdvise:createElement()
	if wndAdvise then WindowManager:addWindow(wndAdvise,WndGameAdvise) end
end

--@brief	维护公告btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnAccountClick( element )
    WZLog("sun---WndSetting:onBtnAccountClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--MsgBoxManager:showTipBox("该功能未开启")
	local title,content = g_gameNoticeInfo.title,g_gameNoticeInfo.content
    if title == nil or #title <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.NO_ANNOUNCE_MES)
        return
    end
    local wndAnnouncement = WndAnnouncement:createElement()
    if wndAnnouncement ~= nil then
        WindowManager:addWindow(wndAnnouncement,WndAnnouncement,nil,false)
    end
end

--@brief    图鉴btn的点击回调函数
--@param    element:表绑定的UI节点引用
function WndSetting:onBtnLibraryClick( element )
    WZLog("sun---WndSetting:onBtnLibraryClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local wndLibrary = WndLibrary:createElement()
    if wndLibrary ~= nil then
        WindowManager:addWindow(wndLibrary,WndLibrary,nil,false,nil,true)
    end
     WindowManager:removeWindow(self.m_root , WndSetting , true)
end

--@brief	切换语言btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnLanClick( element )
    WZLog("sun---WndSetting:onBtnLanClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wndGameLanguage = WndGameLanguage:createElement()
    if wndGameLanguage ~= nil then
        WindowManager:addWindow(wndGameLanguage,WndGameLanguage,nil,false)
    end
end

--@brief	角色声音btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnRoleSoundClick( element )
    WZLog("sun---WndSetting:onBtnLanClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wndGameRoleSound = WndGameRoleSound:createElement()
    if wndGameRoleSound ~= nil then
        WindowManager:addWindow(wndGameRoleSound,WndGameRoleSound,nil,false)
    end
end

--@brief	前往评论btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnCommentClick( element )
    WZLog("sun---WndSetting:onBtnCommentClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local element = WndComment:createElement()
     WindowManager:addWindow(element, WndComment) 
end

--@brief	服务器btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndSetting:onBtnServersClick( element )
	WZLog("sun---WndSetting:onBtnServersClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local function changeServer()
		SceneLoginMgr:showScene(2,true,false)
        IPDConnector.g_nNetConnectFlag = NET_FLAG_1
        g_canInvite = false
        WndServersSel:showWndUI(0, true)
    end

    MsgBoxManager:showConfirmBox(LocalStrings.SETTING_CHANGE_SERVER_CONFIRM, nil, changeServer, MSGBOXLEVEL_HIGH, nil)
end

--@brief	维护公告btn的点击回调函数
--@param	element:表绑定的UI节点引用
function  WndSetting:onBtnNoticeClick( element )
	WZLog("sun---WndSetting:onBtnNoticeClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndNotice = WndGameNotice:createElement()
	if wndNotice then WindowManager:addWindow(wndNotice,WndGameNotice) end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin-------------------------------------
--@brief 重新设置移动容器的大小
function WndSetting:_setMoveContainer()
	local scroll = GetElement(self.m_root, "conMove_WndSetting", WZUIMoveContainer)
	--更改滚动容器Element的大小
	local moveElement = scroll:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize( size.width ,  1.28))
	scroll:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(scroll:getMinPosition().y)

end

--@brief 显示玩家的头像
function WndSetting:_showPlayerHead()
    local conHead = WZUIContainer:luaTo(self.m_root:getChildElement("conHead_WndSetting"))
    if conHead then
        local headAnim = CreateHeadAnim(conHead, 0.7)
        headAnim:setPosition(GlobalMethod:ccp(30,-40))
    end
end

--@brief 找回密码的设置
function WndSetting:_initPsw()
	if not g_isRegist or PassportSdkManager:needLogin() then --or ProjConfig.LANGUAGE_CHANGE == 1 then
		GetElement(self.m_root,"conPsw_WndSetting",WZUIContainer):setVisible(false)
	else
		GetElement(self.m_root,"conPsw_WndSetting",WZUIContainer):setVisible(true)
	end
end

--@brief 初始化声音,改变声音的checkbox状态
function WndSetting:_initSoundCheckBox()
	--                                                                         
	self.m_initMusicVolume = math.floor(AudioManager:getBackgroundMusicVolume() * 100)
	self.m_initSoundVolume = math.floor(AudioManager:getEffectsVolume() * 100)
	WZLog("WndSetting:_initSoundCheckBox:", self.m_initMusicVolume, self.m_initSoundVolume)
	GetElement(self.m_root, "txtMusic_WndSetting", WZUILabelTTF):setText(self.m_initMusicVolume)
	GetElement(self.m_root, "txtSound_WndSetting", WZUILabelTTF):setText(self.m_initSoundVolume)
	-- local checkBox =  WZUICheckBox:luaTo(self.m_root:getChildElement("checkSound_WndSetting"))
	-- if checkBox then checkBox:setCheckIndex(self.m_nSoundState) end
	-- local checkBox =  WZUICheckBox:luaTo(self.m_root:getChildElement("checkMusic_WndSetting"))
	-- if checkBox then checkBox:setCheckIndex(self.m_nMusicState) end
end

--@brief	初始化屏蔽周围玩家
function WndSetting:_initShieldCheckBox()
	local checkBox = WZUICheckBox:luaTo(self.m_root:getChildElement("checkShield_WndSetting"))
	local data = WZDataFile:getInstance():getUserData()
        if data then
            local key = data:getStringValue("FigureSceneManagerData", "OtherVisible")
            if key == "1" then
            	FigureSceneManager:setOtherVisible(1)
                self.m_nShieldState = 1
            end
        end
	if checkBox then checkBox:setCheckIndex(self.m_nShieldState) end
end

--@brief	初始化拒绝好友邀请
function WndSetting:_initInviteCheckBox()
	local checkBox = WZUICheckBox:luaTo(self.m_root:getChildElement("checkInvite_WndSetting"))
	local data = WZDataFile:getInstance():getUserData()
        if data then
            local key = data:getStringValue("Invite", "Friend")
            if key == "1" then
                self.m_nInviteState = 1
                G_Friend_BeInvite = self.m_nInviteState
            end
        end
	if checkBox then checkBox:setCheckIndex(self.m_nInviteState) end
end
function WndSetting:_initUserData( )
	local data = WZDataFile:getInstance():getUserData()
        if data then
            if data:getStringValue("Invite", "Friend") == "1" then
                self.m_nInviteState = 1
                G_Friend_BeInvite = self.m_nInviteState
            end
            if data:getStringValue("Invite", "Corps") == "1" then
                self.m_nCorpsState = 1
                G_Corps_INVITE = self.m_nCorpsState
            end
            if data:getStringValue("Invite", "AllInvite") == "1" then
                self.m_nAllInviteState = 1
                G_Stranger_BeInvite = self.m_nAllInviteState
            end
            if data:getStringValue("FigureSceneManagerData", "OtherVisible") == "1" then
                FigureSceneManager:setOtherVisible(1)
                self.m_nShieldState = 1
            end
        end
end
--@brief	初始化拒绝好友邀请
function WndSetting:_initCorpsCheckBox()
	-- if ProjConfig.LANGUAGE == "cn" then
	-- 	GetElement(self.m_root,"conTeamInvite_WndSetting",WZUIContainer):setVisible(true)
	-- else
	-- 	GetElement(self.m_root,"conTeamInvite_WndSetting",WZUIContainer):setVisible(false)
	-- end
	local checkBox = WZUICheckBox:luaTo(self.m_root:getChildElement("checkCorps_WndSetting"))
	local data = WZDataFile:getInstance():getUserData()
        if data then
            local key = data:getStringValue("Invite", "Corps")
            if key == "1" then
                self.m_nCorpsState = 1
                G_Corps_INVITE = self.m_nCorpsState
            end
        end
	if checkBox then checkBox:setCheckIndex(self.m_nCorpsState) end
end

--@brief	初始化拒绝陌生人邀请
function WndSetting:_initAllInviteCheckBox()
	local checkBox = WZUICheckBox:luaTo(self.m_root:getChildElement("checkAllInvite_WndSetting"))
	local data = WZDataFile:getInstance():getUserData()
        if data then
            local key = data:getStringValue("Invite", "AllInvite")
            if key == "1" then
                self.m_nAllInviteState = 1
                G_Stranger_BeInvite = self.m_nAllInviteState
            end
        end
	if checkBox then checkBox:setCheckIndex(self.m_nAllInviteState) end
end

--@brief	初始化自动播放语音
function WndSetting:_initTalkCheckBox()
	local checkBox = WZUICheckBox:luaTo(self.m_root:getChildElement("checkTalk_WndSetting"))
	if checkBox then checkBox:setCheckIndex(self.m_playTalk) end
end

--@brief 找回密码的设置
function WndSetting:initRoleSound(nSoundType)
	if self.m_root == nil then
		return
	end
	if ProjConfig.LANGUAGE == "cn" and ProjConfig.LANGUAGE_CHANGE ~= 1 then
		GetElement(self.m_root,"conPlayerSound_WndSetting",WZUIContainer):setVisible(true)
	else
		GetElement(self.m_root,"conPlayerSound_WndSetting",WZUIContainer):setVisible(false)
	end
	if nSoundType ~= nil then
		self.m_soundType = nSoundType
	end
	local s = {LocalStrings.ROLESOUND_1,LocalStrings.ROLESOUND_2,LocalStrings.ROLESOUND_3}
	GetElement(self.m_root,"txtRoleSound_WndSetting",WZUILabelTTF):setText(s[self.m_soundType])
end



--@brief 找回密码的设置
function WndSetting:_initLanguage()
	if ProjConfig.LANGUAGE_CHANGE == 1 then
		local filePath = "ui/setting/commom_icon_"..ProjConfig.LANGUAGE..".png"
		GetElement(self.m_root,"imgLan_WndSetting",WZUIImage):setFile(filePath)
		GetElement(self.m_root,"conLan_WndSetting",WZUIContainer):setVisible(true)
	end
end

--@brief 找回密码的设置
function WndSetting:_initComment()
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	local packageName = WGameCmUtil:GetBundleIdentifier()
	if platForm == 1 and packageName == "com.wyd.dandandao.hero" then
		if CheckButtonShow(124,false) then
			GetElement(self.m_root,"conComment_WndSetting",WZUIContainer):setVisible(true)
		end
    end
end

--@brief 初始化设置界面的checkbox状态
function  WndSetting:_initUIstate()
	if not self.m_root then return end
	if CacheCenter:getGameParam().gameStatus == "1" then
		GetElement(self.m_root,"conRight_WndSetting",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conBottom_WndSetting",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conGameFun_WndSetting",WZUIContainer):setVisible(false)
	end
	self:_initSoundCheckBox()
	self:_initShieldCheckBox()
	self:_initCorpsCheckBox()
	self:_initInviteCheckBox()
	self:_initAllInviteCheckBox()
	self:_initLanguage()
	self:initRoleSound()
	self:_initPsw()
	self:_initTalkCheckBox()
	self:_initComment()
	--self:_setMoveContainer()
end

-- 初始化多语言版本
function WndSetting:_initMoreLanguage()
    -- local sound = self.m_root:getChildElement("txtSound_WndSetting")
    -- if sound then WZUILabelTTF:luaTo(sound):setText(LocalStrings.SETTING_SOUND) end

    local shiled = self.m_root:getChildElement("txtShield_WndSetting")
    if shiled then WZUILabelTTF:luaTo(shiled):setText(LocalStrings.SETTING_SHIELD_PLAEYER) end

    local invite = self.m_root:getChildElement("txtInvite_WndSetting")
    if invite then WZUILabelTTF:luaTo(invite):setText(LocalStrings.SETTING_SHIELD_INVITE) end

    local gift = self.m_root:getChildElement("txtGift_WndSetting")
    if gift then WZUILabelTTF:luaTo(gift):setText(LocalStrings.SETTING_EXCHANGE_GIFT) end

    local share = self.m_root:getChildElement("txtShare_WndSetting")
    if share then WZUILabelTTF:luaTo(share):setText(LocalStrings.SETTING_SHARE_GAME) end

    local advise = self.m_root:getChildElement("txtAdvise_WndSetting")
    if advise then WZUILabelTTF:luaTo(advise):setText(LocalStrings.SETTING_ADVISE_MAIL) end

    local gameName = self.m_root:getChildElement("txtGameName_WndSetting")
    if gameName then
        local info = CacheCenter:getPlayerInfo()
        local txt = info.name
        WZUILabelTTF:luaTo(gameName):setText(txt)
    end

    local serverName = self.m_root:getChildElement("txtServerName_WndSetting")
    WZLog("WndSetting:_initMoreLanguage", type(serverName))
    if serverName then
        local txt = CacheCenter:getPlayerInfo().serverName
        WZLog("WndSetting:_initMoreLanguage 11111", type(txt))
        if txt == nil then 
            txt = CacheCenter:getServerNameByServerId(CacheCenter:getPlayerInfo().serverId)
        end
        WZUILabelTTF:luaTo(serverName):setText(txt)
        if ProjConfig.LANGUAGE == "cn" then
        	serverName:setRelativePosition(GlobalMethod:ccp(0.265,0.5))
        	serverName:setFontSize(20)
        end
    end
end


function WndSetting:modifyMailStateDesc()
    local txtBind = GetElement(self.m_root,"txtBindMail_WndSetting",WZUILabelTTF)
    WZLog("------------8525-------------------",g_isBindMail)
    if g_isBindMail then
        txtBind:setText(LocalStrings.SETTING_BIND_MAIL_AGAIN)
    else
        txtBind:setText(LocalStrings.SETTING_BIND_MAIL)
    end
end
-------------------------------------私有方法模块End--------------------------------------
-------------------------------------语言适配模块Star--------------------------------------
function WndSetting:_adaptLanguage_en()
	GetElement(self.m_root,"txtGift_WndSetting",WZUILabelTTF):setFontSize(20)

	GetElement(self.m_root,"txtPsw_WndSetting",WZUILabelTTF):setScale(0.8)

	local server = GetElement(self.m_root,"txtServerName_WndSetting",WZUILabelTTF)
	server:setRelativePosition(GlobalMethod:ccp(0.25,0.5))
	server:setFontSize(20)

	GetElement(self.m_root,"txtAccount_WndSetting",WZUILabelTTF):setFontSize(18)
	
	GetElement(self.m_root,"txtAllInvite_WndSetting",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.56,0.5))
	GetElement(self.m_root,"txtInvite_WndSetting",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.56,0.5))
	GetElement(self.m_root,"txtShield_WndSetting",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.56,0.5))
	GetElement(self.m_root,"txtTalk_WndSetting",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.56,0.5))
	
end

function WndSetting:_adaptLanguage_pt(  )
	local server = GetElement(self.m_root,"txtServerName_WndSetting",WZUILabelTTF)
	server:setRelativePosition(GlobalMethod:ccp(0.308544,0.5))
	server:setFontSize(16)

    GetElement(self.m_root,"txtNotice_WndSetting",WZUILabelTTF):setScale(0.85)

    GetElement(self.m_root,"txtTalk_WndSetting",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(120))
    GetElement(self.m_root,"txtShield_WndSetting",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(120))
    GetElement(self.m_root,"txtInvite_WndSetting",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(120))
    GetElement(self.m_root,"txtCorps_WndSetting",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(120))
    GetElement(self.m_root,"txtGift_WndSetting",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(120))

    local txtBindMail = GetElement(self.m_root,"txtBindMail_WndSetting",WZUILabelTTF)
    txtBindMail:setFontSize(20)
end

function WndSetting:_adaptLanguage_th()
	GetElement(self.m_root,"txtTalk_WndSetting",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.5))
	GetElement(self.m_root,"txtNotice_WndSetting",WZUILabelTTF):setFontSize(22)
	local txtAllInvite = GetElement(self.m_root,"txtAllInvite_WndSetting",WZUILabelTTF)
	if txtAllInvite then 
		txtAllInvite:setRelativePosition(GlobalMethod:ccp(0.53,0.5))
		txtAllInvite:setScale(0.9)
	end
end

function WndSetting:_adaptLanguage_tr()
    GetElement(self.m_root,"txtShield_WndSetting",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(130,0))
    GetElement(self.m_root,"txtInvite_WndSetting",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(130,0))
    GetElement(self.m_root,"txtAllInvite_WndSetting",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.52,0.5))

    GetElement(self.m_root,"txtNotice_WndSetting",WZUILabelTTF):setFontSize(22)
    local txtPsw = GetElement(self.m_root,"txtPsw_WndSetting",WZUILabelTTF)
    txtPsw:setFontSize(18)

    local txtAccount = GetElement(self.m_root,"txtAccount_WndSetting",WZUILabelTTF)
    txtAccount:setFontSize(18)

    GetElement(self.m_root,"txtCorps_WndSetting",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.44,0.5))

    GetElement(self.m_root,"conServerName_WndSetting",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.53,0.5))
end

function WndSetting:_adaptLanguage_es()
	GetElement(self.m_root,"conServerName_WndSetting",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.69,0.5))
	local server = GetElement(self.m_root,"txtServerName_WndSetting",WZUILabelTTF)
	server:setRelativePosition(GlobalMethod:ccp(0.334434,0.5))
	server:setFontSize(16)

    local txtNotice = GetElement(self.m_root,"txtNotice_WndSetting",WZUILabelTTF)
    txtNotice:setScale(0.8)
    txtNotice:setDimensions(GlobalMethod:CCSize(130,0))

    local txtTalk = GetElement(self.m_root,"txtTalk_WndSetting",WZUILabelTTF)
    txtTalk:setFontSize(18)
    txtTalk:setDimensions(GlobalMethod:CCSize(130))
    local txtShield = GetElement(self.m_root,"txtShield_WndSetting",WZUILabelTTF)
    txtShield:setFontSize(18)
    txtShield:setDimensions(GlobalMethod:CCSize(130))
    local txtInvite = GetElement(self.m_root,"txtInvite_WndSetting",WZUILabelTTF)
    txtInvite:setFontSize(18)
    txtInvite:setDimensions(GlobalMethod:CCSize(130))
    local txtCorps = GetElement(self.m_root,"txtCorps_WndSetting",WZUILabelTTF)
    txtCorps:setFontSize(18)
    txtCorps:setDimensions(GlobalMethod:CCSize(130))
    local txtGift = GetElement(self.m_root,"txtGift_WndSetting",WZUILabelTTF)
    txtGift:setFontSize(18)
    txtGift:setDimensions(GlobalMethod:CCSize(130))
    local txtAllInvite = GetElement(self.m_root,"txtAllInvite_WndSetting",WZUILabelTTF)
    txtAllInvite:setFontSize(18)
    txtAllInvite:setDimensions(GlobalMethod:CCSize(130))
    local txtAdvise = GetElement(self.m_root,"txtAdvise_WndSetting",WZUILabelTTF)
    txtAdvise:setFontSize(18)
    txtAdvise:setDimensions(GlobalMethod:CCSize(130))

    local txtBindMail = GetElement(self.m_root,"txtBindMail_WndSetting",WZUILabelTTF)
    txtBindMail:setFontSize(20)
    txtBindMail:setDimensions(GlobalMethod:CCSize(130,0))

    local txtPsw = GetElement(self.m_root,"txtPsw_WndSetting",WZUILabelTTF)
    txtPsw:setFontSize(20)
    txtPsw:setDimensions(GlobalMethod:CCSize(130,0))
end

function WndSetting:_adaptLanguage_vn()
	local txtBindTourists = GetElement(self.m_root,"txtBindTourists_WndSetting",WZUILabelTTF)
    txtBindTourists:setScale(0.8)
    txtBindTourists:setDimensions(GlobalMethod:CCSize(160))

    -- 越南屏蔽语音开关
    local conTalk = GetElement(self.m_root,"conTalk_WndSetting",WZUIContainer)
    conTalk:setVisible(false)
    
end

function WndSetting:_adaptLanguage_hk()
	GetElement(self.m_root,"conServerName_WndSetting",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.53,0.5))
end

-------------------------------------语言适配模块End--------------------------------------



