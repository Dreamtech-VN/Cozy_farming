--CellCommunityInfo.lua
--@brief	CellCommunityInfo的UI模块
--@date		2016-9-22
--@author	binshao
--@note		公会战战斗结算玩家信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityInfo:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityInfo:onExit(element)
	self:_unInit()
    NotificationCenter:unregisterNotification("parse_FRIEND_AddFriendOK", self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 更新
function CellCommunityInfo:_update()
    local curData = self.m_tData
    -- 底
    local imgDi = GetElement(self.m_root, "imgDi_CellCommunityInfo",WZUIImage)
    if curData.isWin then
        imgDi:setFile("ui/hero/hero_scale9_zdlandi.png")
    else
        imgDi:setFile("ui/hero/hero_scale9_zdhongdi.png")
    end

    -- 等级
    local txtLevel = GetElement(self.m_root, "txtLevel_CellCommunityInfo", WZUILabelTTF)
    if curData.playerLevel then
        txtLevel:setText("Lv"..curData.playerLevel)
    end

    -- 名字
    WZLog("--------------------serverID---------------",curData.serverId)
    local serverId = IPDhttpServer:getCurServerId()
    local str = {LocalStrings.ALL_SERCER_RANK_NAME_ME,LocalStrings.ALL_SERCER_RANK_NAME_OTHER}
    local ftbName = GetElement(self.m_root, "ftbName_CellCommunityInfo", WZUIFreeTextBox)
    local txtName = GetElement(self.m_root, "txtName_CellCommunityInfo", WZUILabelTTF)
    if curData.playerName then
        -- 本服
        if tonumber(serverId) == tonumber(curData.serverId) then
            ftbName:setVisible(false)
            txtName:setVisible(true)
            txtName:setText(curData.playerName)
        else
        -- 跨服
            ftbName:setVisible(true)
            txtName:setVisible(false)
            ftbName:setShowText(string.format(LocalStrings.ALL_SERCER_RANK_NAME1,curData.playerName))
        end
    end

    -- 击杀
    local txtKill = GetElement(self.m_root, "txtKill_CellCommunityInfo", WZUILabelTTF)
    txtKill:setText(curData.killCount)
    -- 命中
    local txtHitRate = GetElement(self.m_root, "txtHitRate_CellCommunityInfo", WZUILabelTTF)
    txtHitRate:setText(curData.shootRate.."%")

    -- 分数
    local txtHp = GetElement(self.m_root, "txtHp_CellCommunityInfo", WZUILabelTTF)
    txtHp:setText(curData.hpPer.."%")
    WZLog("-------------txtHp---------guild-----------",curData.hpPer, curData.integral)

    local txtIntegral = GetElement(self.m_root, "txtIntegral_CellCommunityInfo", WZUILabelTTF)
    local battleChannle = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    local schedule = WBattleGlobal:getCurrent().m_tMakePairOk.schedule
    if battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ and schedule == GlobalGame.g_tSchedule.SCHEDULE_GW_1 or schedule == GlobalGame.g_tSchedule.SCHEDULE_GW_2 then
        --积分
        if txtIntegral then
            txtIntegral:setText(curData.integral)
            txtIntegral:setVisible(true)
        end
    end

    -- 设置玩家的名字颜色
    local txt = {txtLevel,txtName,txtKill,txtHitRate,txtHp }
    local color = curData.playerId == CacheCenter:getPlayerInfo().id and ccc3(99,255,95) or ccc3(255,236,193)
    for i = 1, #txt do txt[i]:setColor(color) end

    -- 右边的话，需要移动位置
    if self.isRight then
        if WBattleGlobal:getCurrent():isGuildWarStage() then 
            local sNameFormat = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,236,193" S="20" P="0">%s</T>]]
            ftbName:setShowText(string.format(sNameFormat,curData.playerName))

            txtKill:setRelativePosition(GlobalMethod:ccp(0.59,0.5))
            txtHitRate:setRelativePosition(GlobalMethod:ccp(0.68,0.5))
            txtHp:setRelativePosition(GlobalMethod:ccp(0.76,0.5))
        else
            txtLevel:setRelativePosition(GlobalMethod:ccp(0.181364,0.5))
            txtName:setRelativePosition(GlobalMethod:ccp(0.295938,0.5))
            ftbName:setRelativePosition(GlobalMethod:ccp(0.295938,0.5))
            txtKill:setRelativePosition(GlobalMethod:ccp(0.686563,0.5))
            txtHitRate:setRelativePosition(GlobalMethod:ccp(0.784776,0.5))
            txtHp:setRelativePosition(GlobalMethod:ccp(0.84399,0.5))
        end
    else
        if WBattleGlobal:getCurrent():isGuildWarStage() then 
            local sNameFormat = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,236,193" S="20" P="0">%s</T>]]
            ftbName:setShowText(string.format(sNameFormat,curData.playerName))

            txtKill:setRelativePosition(GlobalMethod:ccp(0.59,0.5))
            txtHitRate:setRelativePosition(GlobalMethod:ccp(0.68,0.5))
            txtHp:setRelativePosition(GlobalMethod:ccp(0.75,0.5))
            local txtIntegral = GetElement(self.m_root, "txtIntegral_CellCommunityInfo", WZUILabelTTF)
            if txtIntegral then
                txtIntegral:setRelativePosition(GlobalMethod:ccp(0.883,0.5))
            end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------