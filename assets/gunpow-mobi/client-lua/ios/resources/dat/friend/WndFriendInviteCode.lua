--WndFriendInviteCode.lua
--@brief	WndFriendInviteCode的UI模块
--@date		2016/06/07
--@author	Tianxiang_Xu
--@note		填写邀请码窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFriendInviteCode:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFriendInviteCode:onExit(element)
	self:_unInit()
end

--@brief    点击关闭按钮回调
function WndFriendInviteCode:onCloseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

--@brief    关闭窗口动画完成回调函数
function WndFriendInviteCode:onCloseActionCallback()
    -- body
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    加载动画
function WndFriendInviteCode:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true,"onActionFinish",self)
end

--@brief    
function WndFriendInviteCode:onActionFinish()
    -- body
    self.m_nState = CacheCenter:getInviteCodeState()
    WZLog("WndFriendInviteCode:onActionFinish", self.m_nState)
    local tRewards = GDatatab_invite_rewards["id_1"].reward
    table.sort(tRewards, sortRewards)
    self.m_tRewardList = tRewards
    if self.m_nState == 1 then
        self:_createLoading()
        ProtocolProcessorWndFriends:send_INVITE_requestList( )
    else
        self:_update()
    end
end

--@brief    其它Item点击回调
function WndFriendInviteCode:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief    点击提交按钮回调
function WndFriendInviteCode:onClickSubmit(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local editInput = GetElement(self.m_root, "editInput_WndFriends", WZUIEditBox)
    self.m_sInputCode = editInput:getText()
    if self.m_sInputCode == nil or self.m_sInputCode == "" then
        MsgBoxManager:showTipBox(LocalStrings.INPUT_INVITE_CODE)
        return 
    elseif string.find(self.m_sInputCode, "%W") ~= nil then  --如果存在非字母数字字符
        MsgBoxManager:showTipBox(LocalStrings.ILLEGAL_CHARACTER)
        return 
    elseif self.m_sInputCode == CacheCenter:getMyInviteCode() then
        MsgBoxManager:showTipBox(LocalStrings.IS_MY_INVITE_CODE)
        return 
    end
    WZLog("WndFriendInviteCode:onClickSubmit", self.m_sInputCode)
    self:_createLoading()
    ProtocolProcessorWndFriends:send_INVITE_InviteWriteCode(self.m_sInputCode)
end

--@brief    触摸开始回调
function WndFriendInviteCode:onTouchBegin(element)
    -- body
    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

--@brief    查看玩家信息
function WndFriendInviteCode:onCheckOther(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCheckOther:show(self.m_tFriend.id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新界面信息
function WndFriendInviteCode:_update()
    -- body
    if self.m_nState == 0 then
        GetElement(self.m_root, "conSubmit_WndFriendInviteCode", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conCheck_WndFriendInviteCode", WZUIContainer):setVisible(false)
        local editInput = GetElement(self.m_root, "editInput_WndFriends", WZUIEditBox)
        editInput:setPlaceHolder(LocalStrings.CLICK_INPUT_INVITECODE)
    else
        GetElement(self.m_root, "conSubmit_WndFriendInviteCode", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conCheck_WndFriendInviteCode", WZUIContainer):setVisible(true)
        self:_showMyInviteFriend()
        self:_showInviteFriendInfo()
    end
    self:_createRewardList()
end
--@brief   创建加载框
function WndFriendInviteCode:_createLoading()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndFriendInviteCode:_closeLoading()
    if self.m_root == nil then
        return
    end
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

--@brief    设置已获得的邀请码奖励
function WndFriendInviteCode:_createRewardList()
    -- body
    if self.m_tRewardList == nil then return end

    local rewardList = self.m_tRewardList
    local tbconRewards 
    local conSize
    if self.m_nState == 0 then 
        conSize = GetElement(self.m_root, "conRewardB_WndFriendInviteCode", WZUIContainer):getAbsContentSize()
        tbconRewards = GetElement(self.m_root, "tbconRewardsB_WndFriendInviteCode", WZUITableContainer)
    else
        conSize = GetElement(self.m_root, "conRewardA_WndFriendInviteCode", WZUIContainer):getAbsContentSize()
        tbconRewards = GetElement(self.m_root, "tbconRewardsA_WndFriendInviteCode", WZUITableContainer)
    end

    for i = 1, #rewardList do
        local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement ~= nil then 
            celElement = WZUIContainer:luaTo(celElement)
            local key = "id_" .. rewardList[i][1]
            local itemInfo = {id = rewardList[i][1], name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=rewardList[i][2],quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
            tLuaObj:setCellGoodItem(itemInfo,16)
            tLuaObj:setItemClickFun(self,self.onOthersClick)
            celElement:setTag(i - 1)
            tbconRewards:setCellElement(celElement)
        end
    end

    tbconRewards:getMoveElement():setPositionX(0.5 * conSize.width)
end


--@brief    显示自己的邀请码好友
function WndFriendInviteCode:_showMyInviteFriend()
    -- body
    --邀请码好友头像
    local conHead = WZUIContainer:luaTo(self.m_root:getChildElement("conHead_WndFriendInviteCode"))
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

--@brief     显示邀请码好友信息
function WndFriendInviteCode:_showInviteFriendInfo()
    -- body
    WZLog("WndFriendInviteCode:_showInviteFriendInfo", self.m_sMyInviteCode)
    --我填写的邀请码
    if self.m_sMyInviteCode then
        local txtFreeCode = GetElement(self.m_root, "txtFreeCode_WndFriendInviteCode", WZUIFreeTextBox)
        local sCodeFormat = [[<T C="79,60,48" S="22" P="1">%s</T><T C="127,70,26" S="22" P="1">%s</T>]]
        local txtCodeContent = string.format(sCodeFormat, LocalStrings.INVITE_CODE_ATT1, self.m_sMyInviteCode)
        txtFreeCode:setShowText(txtCodeContent)
    end
    --名字
    local txtName = GetElement(self.m_root, "txtName_WndFriendInviteCode", WZUILabelTTF)
    txtName:setText(self.m_tFriend.name)
    --等级
    local txtLevel = GetElement(self.m_root, "txtLevel_WndFriendInviteCode", WZUILabelTTF)
    txtLevel:setText(LocalStrings.MOUNT_LEVEL1 .. self.m_tFriend.level)
    --服务器
    if self.m_tFriend.serverName then
        local txtServerName = GetElement(self.m_root, "txtServerName_WndFriendInviteCode", WZUIFreeTextBox)
        local sFormat = [[<T C="79,60,48" S="22" P="1">%s</T><T C="105,65,46" S="22" P="1">%s</T>]]
        local txtContent = string.format(sFormat, LocalStrings.SETTING_SERVE_NAME, self.m_tFriend.serverName)
        txtServerName:setShowText(txtContent)
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
--@brief 英文适配函数
--@note  英文适配
function WndFriendInviteCode:_adaptLanguage_en()
    local txtInvTip = GetElement(self.m_root,"txtInvTip_WndFriendInviteCode",WZUILabelTTF)
    txtInvTip:setFontSize(18)
end

function WndFriendInviteCode:_adaptLanguage_pt(  )
    local txtInvTip = GetElement(self.m_root,"txtInvTip_WndFriendInviteCode",WZUILabelTTF)
    txtInvTip:setFontSize(18)
    txtInvTip:setDimensions(GlobalMethod:CCSize(400,0))

    local txtFriendInviteCode = GetElement(self.m_root,"txtFriendInviteCode_WndFriendInviteCode",WZUILabelTTF)
    txtFriendInviteCode:setFontSize(20) 
end

function WndFriendInviteCode:_adaptLanguage_tr(  )
    local txtInvTip = GetElement(self.m_root,"txtInvTip_WndFriendInviteCode",WZUILabelTTF)
    txtInvTip:setFontSize(18)
end
-----------------------------------语言适配End-----------------------------------------------------

function WndFriendInviteCode:_adaptLanguage_es(  )
    local txtInvTip = GetElement(self.m_root,"txtInvTip_WndFriendInviteCode",WZUILabelTTF)
    txtInvTip:setFontSize(18)
    txtInvTip:setDimensions(GlobalMethod:CCSize(400,0))

    local txtFriendInviteCode = GetElement(self.m_root,"txtFriendInviteCode_WndFriendInviteCode",WZUILabelTTF)
    txtFriendInviteCode:setFontSize(20) 


    local txtFriendInviteReward = GetElement(self.m_root,"txtFriendInviteReward_WndFriendInviteCode",WZUILabelTTF)
    txtFriendInviteReward:setScale(0.8)
    
end
-------------------------------------语言适配模块End----------------------------------------