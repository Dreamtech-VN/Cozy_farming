--CellLeagueInfo.lua
--@brief	CellLeagueInfo的UI模块
--@date		2016-7-7
--@author	binshao
--@note		英雄联赛战斗结算玩家信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeagueInfo:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeagueInfo:onExit(element)
	self:_unInit()
    NotificationCenter:unregisterNotification("parse_FRIEND_AddFriendOK", self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 更新
function CellLeagueInfo:_update()
    local curData = self.m_tData
    -- 底
    local imgDi = GetElement(self.m_root, "imgDi_CellLeagueInfo",WZUIImage)
    if curData.isWin then
        imgDi:setFile("ui/hero/hero_scale9_zdlandi.png")
    else
        imgDi:setFile("ui/hero/hero_scale9_zdhongdi.png")
    end

    -- 等级
    local txtLevel = GetElement(self.m_root, "txtLevel_CellLeagueInfo", WZUILabelTTF)
    if curData.playerLevel then
        txtLevel:setText("Lv"..curData.playerLevel)
    end

    -- 名字
    WZLog("--------------------serverID---------------",curData.serverId)
    local serverId = IPDhttpServer:getCurServerId()
    local str = {LocalStrings.ALL_SERCER_RANK_NAME_ME,LocalStrings.ALL_SERCER_RANK_NAME_OTHER}
    local ftbName = GetElement(self.m_root, "ftbName_CellLeagueInfo", WZUIFreeTextBox)
    local txtName = GetElement(self.m_root, "txtName_CellLeagueInfo", WZUILabelTTF)
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
    local txtKill = GetElement(self.m_root, "txtKill_CellLeagueInfo", WZUILabelTTF)
    txtKill:setText(curData.killCount)
    -- 命中
    local txtHitRate = GetElement(self.m_root, "txtHitRate_CellLeagueInfo", WZUILabelTTF)
    txtHitRate:setText(curData.shootRate.."%")
--    -- 分数
--    local txtScore = GetElement(self.m_root, "txtScore_CellLeagueInfo", WZUILabelTTF)
--    local score = curData.integral < 0 and curData.integral or "+"..curData.integral
--    txtScore:setText(score)
--    WZLog("-------------score---------league-----------",score)

    -- 击杀标志
    local imgPath = {"common_icon_shousha.png","common_icon_shuangsha.png","common_icon_sansha.png","common_icon_sisha.png","common_icon_wusha.png", "common_icon_liusha.png"}
    local imgKill = GetElement(self.m_root, "imgFirstBlood_CellLeagueInfo",WZUIImage)
    if curData.killCount >= 2 and curData.killCount<= 6 then
        imgKill:setFile("ui/common/"..imgPath[curData.killCount])
    elseif curData.isFirstSkill then
        imgKill:setFile("ui/common/"..imgPath[curData.killCount])
    end

    -- 设置玩家的名字颜色
    local txt = {txtLevel,txtName,txtKill,txtHitRate,txtScore }
    local color = curData.playerId == CacheCenter:getPlayerInfo().id and ccc3(99,255,95) or ccc3(255,236,193)
    for i = 1, #txt do txt[i]:setColor(color) end

    -- 右边的话，需要移动位置
    -- if self.isRight then
    --     txtLevel:setRelativePosition(GlobalMethod:ccp(0.246468,0.5))
    --     txtName:setRelativePosition(GlobalMethod:ccp(0.376667,0.5))
    --     ftbName:setRelativePosition(GlobalMethod:ccp(0.376667,0.5))
    --     txtKill:setRelativePosition(GlobalMethod:ccp(0.78924,0.5))
    --     txtHitRate:setRelativePosition(GlobalMethod:ccp(0.904567,0.5))
    --     --txtScore:setRelativePosition(GlobalMethod:ccp(0.851803,0.5))
    --     imgKill:setRelativePosition(GlobalMethod:ccp(0.130208,0.5))
    -- end
end
-------------------------------------私有方法模块End----------------------------------------