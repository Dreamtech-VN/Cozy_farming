--CellArenaWinFightResult.lua
--@brief	CellArenaWinFightResult的UI模块
--@date		2017-1-4
--@note		竞技场战斗结算玩家信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellArenaWinFightResult:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellArenaWinFightResult:onExit(element)
	self:_unInit()
    NotificationCenter:unregisterNotification("parse_FRIEND_AddFriendOK", self)
end

--@brief    点击点赞或添加好友按钮回调
function CellArenaWinFightResult:onClickBtn(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    if nTag == 1 then --点赞
        if self.m_tData.playerId ~= CacheCenter:getPlayerInfo().id then 
            ProtocolProcessorGlobal:send_BATTLE_ThumbUp(self.m_tData.playerId)
        end
    else
        local bIsFriend = CacheCenter:judgeIsContainsById(self.m_tData.playerId)
        if bIsFriend then
            MsgBoxManager:showTipBox(LocalStrings.FRIEND_EXIST)
            return 
        end
        local vector = WZLuaVector_int_:create()
        vector:push(self.m_tData.playerId)
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
            if BANCHAT[i].id == self.m_tData.playerId then
                bInBlacklist = true
                break 
            end
        end
        if bInBlacklist then
            MsgBoxManager:showConfirmBox(LocalStrings.BLACKLIST_TEXT4, self, self.continueToAddFriend)
            return
        end
        ProtocolProcessorWndFriends:send_FRIEND_AddFriend(vector)
    end
end

function CellArenaWinFightResult:needHigherVipCallBack(nId, nResType)
    -- body
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

--@brief    继续添加好友
function CellArenaWinFightResult:continueToAddFriend()
    -- body
    local vector = WZLuaVector_int_:create()
    vector:push(self.m_tData.playerId)
    
    ProtocolProcessorWndFriends:send_FRIEND_AddFriend(vector)
end

--@brief    设置点赞按钮的状态
function CellArenaWinFightResult:setBtnZanState()
    -- body
    GetElement(self.m_root, "btnZan_CellArenaWinFightResult", WZUIButton):setTouchEnable(false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 更新
function CellArenaWinFightResult:_update()
    local curData = self.m_tData
    WZLog("CellArenaWinFightResult:_update",tostring(curData.isSameTeam))
    --背景
    local imgBg = GetElement(self.m_root, "imgBg_CellArenaWinFightResult",WZUI9Image)
    if curData.isSameTeam then
        imgBg:setFile("ui/hero/hero_scale9_zdlandi.png")
    else
        imgBg:setFile("ui/hero/hero_scale9_zdhongdi.png")
    end

    -- 名字
    local labName = GetElement(self.m_root, "labName_CellArenaWinFightResult", WZUILabelTTF)
    if curData.playerName then
        labName:setText(curData.playerName)
    end
    if curData.playerId == WBattleGlobal:getCurrent().m_tMakePairOk.selfId then
       labName:setColor(GlobalMethod:ccc3(99,255,95))
    end
    local labId = GetElement(self.m_root, "labId_CellArenaWinFightResult", WZUILabelTTF)
    if labId then 
        labId:setText("(id:" .. curData.playerId .. ")")
    end

    if tostring(curData.serverId) == tostring(CacheCenter:getPlayerInfo().serverId) then
        GetElement(self.m_root, "imgServerFlag_CellArenaWinFightResult",WZUIImage):setVisible(false)
    else
        GetElement(self.m_root, "imgServerFlag_CellArenaWinFightResult",WZUIImage):setVisible(true)
    end

    -- 击杀
    local labKill = GetElement(self.m_root, "labKill_CellArenaWinFightResult", WZUILabelTTF)
    labKill:setText(curData.killCount)
    -- 命中
    local labHitRate = GetElement(self.m_root, "labHitRate_CellArenaWinFightResult", WZUILabelTTF)
    labHitRate:setText(curData.shootRate.."%")
    -- 分数
    local labHurt = GetElement(self.m_root, "labHurt_CellArenaWinFightResult", WZUILabelTTF)
    labHurt:setText(curData.hurtTotal)

    -- 击杀标志
    local imgPath = {"common_icon_shousha.png","common_icon_shuangsha.png","common_icon_sansha.png","common_icon_sisha.png","common_icon_wusha.png", "common_icon_liusha.png"}
    local imgKillIcon = GetElement(self.m_root, "imgKillIcon_CellArenaWinFightResult",WZUIImage)
    if curData.killCount >= 2 and curData.killCount<= 6 then
        imgKillIcon:setFile("ui/common/"..imgPath[curData.killCount])
    elseif curData.isFirstSkill then
        imgKillIcon:setFile("ui/common/"..imgPath[curData.killCount])
    else
        imgKillIcon:setVisible(false)
    end

    local imgMvpIcon = GetElement(self.m_root, "imgMvpIcon_CellArenaWinFightResult",WZUIImage)
    if not curData.isMvp then
        imgMvpIcon:setVisible(false)
    end
    
    local conBtn = GetElement(self.m_root, "conBtn_CellArenaWinFightResult", WZUIContainer)
    local battleChannel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    if battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
        conBtn:setVisible(true)
        if not curData.isSameTeam then
            conBtn:setRelativePosition(GlobalMethod:ccp(0.915,0.5))
            GetElement(self.m_root, "btnZan_CellArenaWinFightResult", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.75,0.5))
            GetElement(self.m_root, "btnAdd_CellArenaWinFightResult", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.25,0.5))
            GetElement(self.m_root, "conInfo_CellArenaWinFightResult", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.455,0.5))
            labKill:setRelativePosition(GlobalMethod:ccp(0.406618,0.493339))
            labHitRate:setRelativePosition(GlobalMethod:ccp(0.514193,0.450569))
            labHurt:setRelativePosition(GlobalMethod:ccp(0.618751,0.472315))

            imgKillIcon:setRelativePosition(GlobalMethod:ccp(0.755,0.509469))
            imgMvpIcon:setRelativePosition(GlobalMethod:ccp(0.845,0.533279))
        else
            GetElement(self.m_root, "conInfo_CellArenaWinFightResult", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.605,0.5))
            labKill:setRelativePosition(GlobalMethod:ccp(0.4,0.493339))
            labHitRate:setRelativePosition(GlobalMethod:ccp(0.51,0.450569))
            labHurt:setRelativePosition(GlobalMethod:ccp(0.64,0.472315))

            imgKillIcon:setRelativePosition(GlobalMethod:ccp(0.755,0.509469))
            imgMvpIcon:setRelativePosition(GlobalMethod:ccp(0.845,0.533279))
        end
    end
    if self.m_tData.playerId == CacheCenter:getPlayerInfo().id then
        GetElement(self.m_root, "btnAdd_CellArenaWinFightResult", WZUIButton):setVisible(false)
    end
end
-------------------------------------私有方法模块End----------------------------------------