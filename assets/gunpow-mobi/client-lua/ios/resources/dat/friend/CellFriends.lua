--CellFriends.lua
--@brief	CellFriends的UI模块
--@date		2014/03/26
--@author	liangguang_long
--@note		附近好友模块

RRANK_INDEX = 1     --推荐
FRIEND_INDEX = 2    --好友
ONLINE_INDEX = 3    --动态
RECOMMEND_INDEX = 4 --推荐

BTN_VIGOR = 1
BTN_GIFT = 2
BTN_CHAT = 3
BTN_SPACE = 4
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFriends:onEnter(element)
    WZLog("CellFriends:onEnter(element)")
	self.m_root = element
	self:_showMultiLanguage()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFriends:onExit(element)
	self:_unInit()
end

--@brief	背景按钮函数
--@param	element:表绑定的UI节点引用
function CellFriends:onBackClick(element)
	element = WZUIButton:luaTo(element)
	local tag = self.m_root:getTag()
    self.m_tBackFun[2](self.m_tBackFun[1] ,self,tag,self.m_tFriend)
    
    WndCheckOther:show(self.m_tFriend.id)
end

--@brief	赠送回调
function CellFriends:onGitfClick(element)
	WZLog("赠送回调::")
end

--@brief	领取回调
function CellFriends:onRecvClick(element)
	WZLog("领取回调::")
    self.m_nBtnIndex = BTN_VIGOR
	CellFriends.m_current_click = self
	local tag = self.m_root:getTag()
	CellFriends.m_current_click.tag = tag 
	if self.m_tBackFun and self.m_tBackFun[1] and self.m_tBackFun[3] then
		self.m_tBackFun[3](self.m_tBackFun[1],self,tag,self.m_tFriend)
	end
end

--点击好友头像
function CellFriends:event_ClickHead( element )
	WZLog("CellFriends:event_ClickHead")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_tBackFun[2](self.m_tBackFun[1] ,self,nil,self.m_tFriend)

	WndCheckOther:show(self.m_tFriend.id)
end

--@brief    设置是显示赠送还是显示添加好友按钮
--@param    nType FRIEND_INDEX = 2    --好友;RECOMMEND_INDEX = 4 --推荐
function CellFriends:setBtnType(nType)
    --body
    local txtValue = GetElement(self.m_root, "txtValue_CellFriend", WZUIFreeTextBox)
    if self.m_tFriend.friendliness == nil then
        self.m_tFriend.friendliness = 0
    end
    local sValueFormat = [[<T C="255,227,116" S="22" P="1">%s</T><T C="255,255,255" S="22" P="1">%d</T>]]
    local sValue
    if nType == FRIEND_INDEX then
        if self.m_tFriend.serverId and self.m_tFriend.serverId == tonumber(CacheCenter:getPlayerInfo().serverId) then
            GetElement(self.m_root, "btnAddFriend_CellFriends", WZUIButton):setVisible(false)
            local btnGift = GetElement(self.m_root, "btnGift_CellFriends", WZUIButton)
            btnGift:setVisible(true)
            GetElement(self.m_root, "btnChat_CellFriends", WZUIButton):setVisible(true)
            if CheckButtonShow(60) then
                GetElement(self.m_root, "btnSpace_CellFriends", WZUIButton):setVisible(true)
                --设置空间访问状态
                self:setSpaceVisitState(self.m_tFriend.spaceVisitState)
            else
                GetElement(self.m_root, "btnSpace_CellFriends", WZUIButton):setVisible(false)
            end
            GetElement(self.m_root, "btnVigor_CellFriends", WZUIButton):setVisible(true)
            sValue = string.format(sValueFormat, LocalStrings.FRIENDLINESS, self.m_tFriend.friendliness)
            --判断是否已经赠送过礼物
            if self.m_tFriend.canSendGift == 1 then
                btnGift:setTouchEnable(true)
            else
                btnGift:setTouchEnable(false)
            end
        elseif self.m_tFriend.serverId and self.m_tFriend.serverId ~= tonumber(CacheCenter:getPlayerInfo().serverId) then
            GetElement(self.m_root, "btnAddFriend_CellFriends", WZUIButton):setVisible(false)
            GetElement(self.m_root, "btnGift_CellFriends", WZUIButton):setVisible(false)

            local btnChat = GetElement(self.m_root, "btnChat_CellFriends", WZUIButton)
            btnChat:setVisible(true)
            btnChat:setRelativePosition(GlobalMethod:ccp(0.875,0.5))
            local btnSpace = GetElement(self.m_root, "btnSpace_CellFriends", WZUIButton)
            if CheckButtonShow(60) then
                btnSpace:setVisible(true)
                btnSpace:setRelativePosition(GlobalMethod:ccp(0.67,0.5))
                --设置空间访问状态
                self:setSpaceVisitState(self.m_tFriend.spaceVisitState)
            else
                btnSpace:setVisible(false)
            end

            GetElement(self.m_root, "btnVigor_CellFriends", WZUIButton):setVisible(false)
            sValueFormat = [[<T C="255,227,116" S="22" P="1">%s</T><T C="255,255,255" S="22" P="1">%s</T>]]
            sValue = string.format(sValueFormat, LocalStrings.SETTING_SERVE_NAME, CacheCenter:getServerNameByServerId(self.m_tFriend.serverId))
        end

        if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
            txtValue:setMaxWidth(300)
            txtValue:setScale(0.8)
        end

    elseif nType == RECOMMEND_INDEX then
        GetElement(self.m_root, "btnAddFriend_CellFriends", WZUIButton):setVisible(true)
        local btnChat = GetElement(self.m_root, "btnChat_CellFriends", WZUIButton)
        local btnSpace = GetElement(self.m_root, "btnSpace_CellFriends", WZUIButton)
        btnChat:setVisible(true)
        btnChat:setRelativePosition(GlobalMethod:ccp(0.67,0.5))
        if CheckButtonShow(60) then
            btnSpace:setVisible(true)
        else
            btnSpace:setVisible(false)
        end
        btnSpace:setRelativePosition(GlobalMethod:ccp(0.465,0.5))
        sValue = string.format(sValueFormat, LocalStrings.COMBAT .. "：", self.m_tFriend.fighting)
    end
    --显示战斗力或好友度
    txtValue:setShowText(sValue)
end

--@brief    重新设置好友度的值
--@param    新增好友度的值
function CellFriends:resetFriendlinessValue(nNewAddvalue)
    -- body
    WZLog("CellFriends:resetFriendlinessValue", self.m_tFriend.friendliness, nNewAddvalue)
    self.m_tFriend.friendliness = self.m_tFriend.friendliness + nNewAddvalue
    local sValueFormat = [[<T C="255,227,116" S="22" P="1">%s</T><T C="255,255,255" S="22" P="1">%d</T>]]
    local sValue = string.format(sValueFormat, LocalStrings.FRIENDLINESS, self.m_tFriend.friendliness)
    local txtValue = GetElement(self.m_root, "txtValue_CellFriend", WZUIFreeTextBox)
    txtValue:setShowText(sValue)
end

--@brief    更新好友度的显示
--@param    新好友度的值
function CellFriends:updateFriendlinessValue(nNewvalue)
    -- body
    self.m_tFriend.friendliness = nNewvalue
    --如果礼物界面打开，更新礼物界面的好友度
    if WndFriendGift.m_root then
        WndFriendGift:resetFriendliness(self.m_tFriend.id, self.m_tFriend.friendliness)
    end

    local sValueFormat = [[<T C="255,227,116" S="22" P="1">%s</T><T C="255,255,255" S="22" P="1">%d</T>]]
    local sValue = string.format(sValueFormat, LocalStrings.FRIENDLINESS, self.m_tFriend.friendliness)
    local txtValue = GetElement(self.m_root, "txtValue_CellFriend", WZUIFreeTextBox)
    if txtValue then
        txtValue:setShowText(sValue)
    end
    --更新密友图标
    if self.m_tFriend.bBestFriend == 1 then
        self:_showName()
    end
end

--@brief    添加好友回调
function CellFriends:onAddFriend(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_root == nil or self.m_tFriend == nil then 
        return 
    end
    local count = #self.m_tFriend
    local tag = 0
    local vector = WZLuaVector_int_:create()
    vector:push(self.m_tFriend.id)
    local nMaxFriendsNum = GetMaxFriends(CacheCenter:getPlayerInfo().vipLevel)
    if CacheCenter:getFriendCount() >= nMaxFriendsNum then
        local nMaxVipLevel = GetMaxVipLevel()
        if CacheCenter:getPlayerInfo().vipLevel >= nMaxVipLevel then
            MsgBoxManager:showTipBox(LocalStrings.FRIEND_MAX)
        else
            MsgBoxManager:showConfirmBox(LocalStrings.FRIENDS_FULL_ATT, self, self.needHigherVipCallBack, nil, nil)
        end
        return
    end

    local bInBlacklist = false 
    BANCHAT = CacheCenter:getFriendBlacklist()
    for i = 1, #BANCHAT do
        if BANCHAT[i].id == self.m_tFriend.id then
            bInBlacklist = true
            break 
        end
    end
    if bInBlacklist then
        MsgBoxManager:showConfirmBox(LocalStrings.BLACKLIST_TEXT4, self, self.continueToAddFriend)
        return
    end
    WndFriends:onAddFriend(vector)
    WZLog("CellFriends:onAddFriend:::::",tag)
end

--@brief    继续添加好友
function CellFriends:continueToAddFriend()
    -- body
    local vector = WZLuaVector_int_:create()
    vector:push(self.m_tFriend.id)
    
    WndFriends:onAddFriend(vector)
end

--@brief    查看空间按钮回调
function CellFriends:onCheckSpace(element)
    -- body
    WZLog("**** CellFriends:onCheckSpace ****", self.m_tFriend.id)
    self.m_nBtnIndex = BTN_SPACE

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSpaceMain:show(self.m_tFriend.id)
    --设置访问空间状态
    WndFriends:onClickSpace(self, self.m_tFriend.id)
end

--@brief    点击私聊按钮回调
function CellFriends:onChat(element)
    -- body
    WZLog("**** CellFriends:onChat ****")
    self.m_nBtnIndex = BTN_CHAT

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndChat:showChatWindowForPrivateWithIdAndName(self.m_tFriend.id,self.m_tFriend.name, self.m_tFriend.sex, self.m_tFriend.level, self.m_tFriend.vipLevel, self.m_tFriend.headItemId, self.m_tFriend.faceItemId, self.m_tFriend.headColor)
end

--@brief    点击送礼按钮回调
function CellFriends:onGift(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_nBtnIndex = BTN_GIFT
    CellFriends.m_current_click = self
    local tag = self.m_root:getTag()
    CellFriends.m_current_click.tag = tag 
    WZLog("***** CellFriends:onGift *****", tag)
    local wndFriendGift = WndFriendGift:createElement()
    if wndFriendGift then
        WindowManager:addWindow(wndFriendGift, WndFriendGift)
        WndFriendGift:setFriendId(self.m_tFriend.id, self.m_tFriend.friendliness)
    end
end

function CellFriends:needHigherVipCallBack(nId, nResType)
    -- body
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

--@brief    获取好友ID
function CellFriends:getFriendId()
    -- body
    return self.m_tFriend.id
end

--@brief    好友数据变化时，更新显示
function CellFriends:resetFriendData(tData)
    -- body
    self.m_tFriend = tData
    --更新函数
    self:_update()
end

--@brief    
function CellFriends:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellFriends")
    self.m_root:addChild(celElement)
    --更新函数
    self:_update()
    AdaptLanguage(self)
end

--@brief    获取好友数据
function CellFriends:getFriendData()
    -- body
    return self.m_tFriend
end

--@brief    设置访问空间标识状态
function CellFriends:setSpaceVisitState(spaceVisitState)
    -- body
    if self.m_root == nil then return end 

    self.m_tFriend.spaceVisitState = spaceVisitState

    local imgVisiteIcon = GetElement(self.m_root, "imgVisiteIcon_CellFriends", WZUIImage)
    if imgVisiteIcon then
        if self.m_tFriend.spaceVisitState == 1 then 
            imgVisiteIcon:setVisible(true)
        else
            imgVisiteIcon:setVisible(false)
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    点击后设置为已添加
function CellFriends:_setHavedAdd()
    -- body
    GetElement(self.m_root, "btnAddFriend_CellFriends", WZUIButton):setTouchEnable(false)
end

--@brief	更新函数
function CellFriends:_update()
	if self.m_root == nil or self.m_tFriend == nil then
		return
	end
	WZLog("type:::",self.m_root:getTag(),self.m_nType)
    self:setBtnType(self.m_nType)
	self:_showSex()--显示性别或顺序id
	self:_showOnline(self.m_nType)--显示在线或上一次登录时间
	self:_showName()--显示名称
	self:_showLevel()--显示等级
	self:_showFrameIndex()--显示赠送
    self:_showIsMentoring()--显示师徒关系
end

--@brief	显示在线
function CellFriends:_showOnline(nType)
	local txtOnlineState = GetElement(self.m_root, "txtOnlineState_CellFriends", WZUILabelTTF)
	
	if self.m_tFriend.isOnline == 0 or self.m_tFriend.isOnline == false then
        if nType == FRIEND_INDEX then
            local sText = self:_returnOfflineAtt(self.m_tFriend.offlineTime)
            txtOnlineState:setText(sText)
        elseif nType == RECOMMEND_INDEX then
            txtOnlineState:setText(LocalStrings.ISOFFLINE)
        end
	else
        txtOnlineState:setText(LocalStrings.ISONLINE)
	end
end

--@brief	显示性别
function CellFriends:_showSex()
	if self.m_tFriend.sex == true or self.m_tFriend.sex == 1 then
		--icon = "ui/bottomMenu/friend/sex_girl.png"
	end
	self:_showPhone()--显示头像
end

--@brief	显示头像
function CellFriends:_showPhone()
	--设置默认显示
	local conHead = WZUIContainer:luaTo(self.m_root:getChildElement("conHead_CellFriend"))
    WZLog("sex===",self.m_tFriend.sex)
	local m_bIsOffline = false   
	if self.m_tFriend.isOnline == 0 or self.m_tFriend.isOnline == false then
		m_bIsOffline = true  
	end
	if m_bIsOffline then 
		WZLog("玩家不在线")
	else 
		WZLog("玩家在线")
	end 
	local cellElement =  CellHead:show(conHead,self.m_tFriend.headItemId,self.m_tFriend.faceItemId,self.m_tFriend.sex,m_bIsOffline, nil, self.m_tFriend.vipLevel, self.m_tFriend.headColor)
	cellElement:setScale(1.13)
end

--@brief	显示名称
function CellFriends:_showName()
    local imgKuafu = WZUIImage:luaTo(self.m_root:getChildElement("imgKuafu_CellFriends"))
	local txtName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtName_CellFriends"))
	txtName:setText(self.m_tFriend.name or "")
    
    if self.m_tFriend.serverId and self.m_tFriend.serverId ~= tonumber(CacheCenter:getPlayerInfo().serverId) then
        imgKuafu:setVisible(true)
        txtName:setRelativePosition(GlobalMethod:ccp(0.15, 0.8))
    end
    --关系图标
    if self.m_nType == FRIEND_INDEX then
        AddRelationIcon(self.m_root, self.m_tFriend.relation, self.m_tFriend.bBestFriend, self.m_tFriend.isMentoring, self.m_tFriend, WndFriends.m_root, GlobalMethod:ccp(0.35,0.78))
    end
end

--@brief	显示等级
function CellFriends:_showLevel()
	local txtLevel = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtLevel_CellFriend"))
	txtLevel:setText(LocalStrings.LEVEL .. "：" .. self.m_tFriend.level)
end

--@brief	显示赠送
function CellFriends:_showFrameIndex()
	if self.m_tFriend.send == 1 or self.m_tFriend.send == true then
        GetElement(self.m_root, "btnVigor_CellFriends", WZUIButton):setTouchEnable(true)
	else
        GetElement(self.m_root, "btnVigor_CellFriends", WZUIButton):setTouchEnable(false)
	end
	if self.m_tFriend.canSendGift == 1 or self.m_tFriend.canSendGift == true then
        GetElement(self.m_root, "btnGift_CellFriends", WZUIButton):setTouchEnable(true)
    else
        GetElement(self.m_root, "btnGift_CellFriends", WZUIButton):setTouchEnable(false)
    end
end


function CellFriends:setSend( bSend )
    if self.m_nBtnIndex == BTN_VIGOR then
        self.m_tFriend.send = bSend 
    elseif self.m_nBtnIndex == BTN_GIFT then
	    self.m_tFriend.canSendGift = 1 
    end
end
--@brief    显示师徒关系
function CellFriends:_showIsMentoring()
    WZLog("CellFriends:_showIsMentoring()",self.m_tFriend.isMentoring)
end

--@note		多语言文本
function CellFriends:_showMultiLanguage()	

end

--@note		显示文本文字
function CellFriends:_showTTFText(name,desc)
	local element = WZUILabelTTF:luaTo(self.m_root:getChildElement(name))
	element:setText(desc)
	return element
end

--@brief    计算离线时间
function CellFriends:_returnOfflineAtt(offlineTime)
    -- body
    local curTime = SystemTime:getServerTime()
    local nTime = curTime - offlineTime
    WZLog("CellFriends:_returnOfflineAtt", offlineTime, nTime, self.m_tFriend.name, self.m_tFriend.id)
    local sText = LocalStrings.LASTONLINE
    if offlineTime <=0 then  --针对老客户
        nTime = 1
        local sTimeString = string.format(LocalStrings.HOUR_BEFORE, nTime)
        sText = sText .. sTimeString
        return sText
    end

    if nTime <= 3 * 60 then
        sText = sText .. LocalStrings.JUST_NOW
    elseif nTime < 60 * 60 then    --xx分钟前
        nTime = (nTime / 60) + 1
        local sTimeString = string.format(LocalStrings.MINUTE_BEFORE, nTime)
        sText = sText .. sTimeString
    elseif nTime < 3600 * 24 then --xx小时前
        nTime = nTime / 3600
        local sTimeString = string.format(LocalStrings.HOUR_BEFORE, nTime)
        sText = sText .. sTimeString
    elseif nTime < 3600 * 24 * 7 then --xx天前
        nTime = nTime / (3600 * 24)
        local sTimeString = string.format(LocalStrings.DAY_BEFORE, nTime)
        sText = sText .. sTimeString
    elseif nTime < 3600 * 24 * 7 * 4 then --xx周前
        nTime = nTime / (3600 * 24 * 7)
        local sTimeString = string.format(LocalStrings.WEEK_BEFORE, nTime)
        sText = sText .. sTimeString
    else
        local sTimeString = string.format(LocalStrings.MONTH_BEFORE, 1)
        sText = sText .. sTimeString
    end

    return sText
end
-------------------------------------私有方法模块End----------------------------------------

-----------------------------------语言适配Begin----------------------------------
function CellFriends:_adaptLanguage_pt(  )
    local txtValue = GetElement(self.m_root,"txtValue_CellFriend",WZUIFreeTextBox)
    txtValue:setScale(0.8)
    txtValue:setMaxWidth(300)
end

function CellFriends:_adaptLanguage_es(  )
    local txtValue = GetElement(self.m_root,"txtValue_CellFriend",WZUIFreeTextBox)
    txtValue:setScale(0.8)
    txtValue:setMaxWidth(300)
end
function CellFriends:_adaptLanguage_tr(  )
    local txtValue = GetElement(self.m_root,"txtValue_CellFriend",WZUIFreeTextBox)
    txtValue:setScale(0.8)
    txtValue:setMaxWidth(300)
end
-------------------------------------语言适配End------------------------------------








