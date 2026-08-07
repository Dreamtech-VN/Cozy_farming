--CellJJCBattleSettlement.lua
--@brief	CellJJCBattleSettlement的UI模块
--@date		2015-8-31
--@author	binshao
--@note		竞技场战斗结算单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellJJCBattleSettlement:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellJJCBattleSettlement:onExit(element)
	self:_unInit()
    NotificationCenter:unregisterNotification("parse_FRIEND_AddFriendOK", self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 更新
function CellJJCBattleSettlement:_update()
    local curData = self.m_tData
    -- 胜利标志
    local imgResult = GetElement(self.m_root, "imgResult_CellJJCBattleSettlement", WZUIImage)
    local imgFile = curData.isWin and "ui/common/common_icon_shengli.png" or "ui/common/common_icon_shibai.png"
    imgResult:setFile(imgFile)

    -- 战斗类型，竞技场或者公会战
    local imgPath = {GDatatab_item["id_13"].icon,GDatatab_item["id_18"].icon}
    local imgModen = GetElement(self.m_root, "imgScore_CellJJCBattleSettlement", WZUIImage)

    imgModen:setFile(imgPath[1])

    -- 竞技等级
    local hallInfo = GDatatab_integral["id_"..curData.tournamentLevel]
    local imgLv = GetElement(self.m_root, "imgAthLv_CellJJCBattleSettlement",WZUIImage)
    imgLv:setFile("ui/common/"..hallInfo.iocn..".png")

    local LvNum = (curData.tournamentLevel-1)%10+1
    local lafLv = GetElement(self.m_root, "lafAthLv_CellJJCBattleSettlement",WZUILabelAtlasFont)
    lafLv:setText(LvNum)

    -- 等级
    local txtLevel = GetElement(self.m_root, "txtLevel_CellJJCBattleSettlement", WZUILabelTTF)
    if curData.playerLevel then
        txtLevel:setText("Lv"..curData.playerLevel)
    end

    -- 名字
    WZLog("--------------------serverID---------------",curData.serverId)
    local serverId = IPDhttpServer:getCurServerId()
    local str = {LocalStrings.ALL_SERCER_RANK_NAME_ME,LocalStrings.ALL_SERCER_RANK_NAME_OTHER}
    local ftbName = GetElement(self.m_root, "ftbName_CellJJCBattleSettlement", WZUIFreeTextBox)
    local txtName = GetElement(self.m_root, "txtName_CellJJCBattleSettlement", WZUILabelTTF)
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
    local txtKill = GetElement(self.m_root, "txtKill_CellJJCBattleSettlement", WZUILabelTTF)
    txtKill:setText(LocalStrings.SETTLMENT_KILL.." "..curData.killCount)
    -- 命中
    local txtHitRate = GetElement(self.m_root, "txtHitRate_CellJJCBattleSettlement", WZUILabelTTF)
    txtHitRate:setText(LocalStrings.SETTLMENT_HIT.." "..curData.shootRate.."%")
    -- 分数
    local txtScore = GetElement(self.m_root, "txtScore_CellJJCBattleSettlement", WZUILabelTTF)
    local score = curData.integral < 0 and curData.integral or "+"..curData.integral
    txtScore:setText(score)

    -- 竞技场练习模式不显示积分
    if g_areaIndex == 2 then
        txtScore:setVisible(false)
        imgModen:setVisible(false)
    else
        txtScore:setVisible(true)
        imgModen:setVisible(true)
    end

    -- 击杀标志
    local imgPath = {"common_icon_shousha.png","common_icon_shuangsha.png","common_icon_sansha.png","common_icon_sisha.png","common_icon_wusha.png", "common_icon_liusha.png"}
    local imgKill = GetElement(self.m_root, "imgFirstBlood_CellJJCBattleSettlement",WZUIImage)
    if curData.killCount >= 2 and curData.killCount <= 6 then
        imgKill:setFile("ui/common/"..imgPath[curData.killCount])
    elseif curData.isFirstSkill then
        imgKill:setFile("ui/common/"..imgPath[curData.killCount])
    end

    -- 设置玩家的名字颜色
    local txt = {txtLevel,txtName,txtKill,txtHitRate,txtScore }
    local color = curData.playerId == CacheCenter:getPlayerInfo().id and ccc3(99,255,95) or ccc3(255,236,193)
    for i = 1, #txt do txt[i]:setColor(color)  end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellJJCBattleSettlement:_adaptLanguage_vn(  )
    GetElement(self.m_root,"imgScore_CellJJCBattleSettlement",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.79,0.5))
    GetElement(self.m_root,"txtKill_CellJJCBattleSettlement",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.5))
    GetElement(self.m_root,"txtHitRate_CellJJCBattleSettlement",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.54,0.5))
    GetElement(self.m_root,"txtScore_CellJJCBattleSettlement",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.818,0.5))
end
-------------------------------------语言适配End--------------------------------------------