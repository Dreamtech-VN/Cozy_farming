--CellTowerRank.lua
--@brief	CellTowerRank的UI模块
--@date		2015/04/28
--@author	xiaoyu_wu
--@modify   qixiang_xie
--@note		爬塔副本排名单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTowerRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTowerRank:onExit(element)
	self:_unInit()
end

--@brief  显示排行榜里的人物信息
function CellTowerRank:onClickPlayerInfo(element)
    WZLog("CellTowerRank:onClickPlayerInfo")

    if self.m_nShowType == 6 and isYLGYLoginChannel() and CacheCenter:getPlayerInfo().level < 7 then
        return
    end
    
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tData.playerId)
end


--@brief  显示排行榜里的人物信息
function CellTowerRank:onClickHead(element)
    WZLog("CellTowerRank:onClickPlayerInfo")

    if self.m_nShowType == 6 and isYLGYLoginChannel() and CacheCenter:getPlayerInfo().level < 7 then
        return
    end

    local tag = element:getTag()
    if self.m_tData.player and self.m_tData.player[tag] and self.m_tData.player[tag].playerId then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

        WndCheckOther:show(self.m_tData.player[tag].playerId)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@加载数据
function CellTowerRank:onLoadData(element)
    WZLog("CellTowerRank:onLoadData")
    local cellElement = WZUISystem:getInstance():createElement("CellTowerRank")
    element:addChild(cellElement)

    if self.m_nShowType == 3 then
        self:_update2()
    elseif self.m_nShowType == 4 then
        self:_update3()
    elseif self.m_nShowType == 5 then
        self:_update4()
    elseif self.m_nShowType == 6 then
        self:_update5()
    else
        self:_update()
    end
end

--@brief    更新界面
function CellTowerRank:_update()
    -- 人物头像
    local sex = self.m_tData.playerSex == 0 and true or false
    local conHead = GetElement(self.m_root, "conHead1_CellTowerRank",WZUIContainer)
    CellHead:show(conHead,self.m_tData.headId,self.m_tData.faceId,self.m_tData.playerSex,nil,nil,self.m_tData.vipLevel,self.m_tData.headColor)
    
    local txtRank = GetElement(self.m_root,"txtRank_CellTowerRank",WZUILabelTTF)
    local imgRank = GetElement(self.m_root,"imgRank_CellTowerRank",WZUIImage)
    if self.m_nRank == 1 then
        imgRank:setFile("ui/common/common_icon_1st_1.png")
        txtRank:setText("")
    elseif self.m_nRank == 2 then
        imgRank:setFile("ui/common/common_icon_2nd_1.png")
        txtRank:setText("")
    elseif self.m_nRank == 3 then
        imgRank:setFile("ui/common/common_icon_3rd_1.png")
        txtRank:setText("")
    else
        imgRank:setFile("")
        txtRank:setText(self.m_nRank)
    end

    local txtLevel = GetElement(self.m_root, "txtLevel_CellTowerRank", WZUILabelTTF)
    txtLevel:setText("Lv"..self.m_tData.playerLevel)
    
    local txtName = GetElement(self.m_root, "txtName_CellTowerRank", WZUILabelTTF)
    txtName:setText(self.m_tData.playerName)

    if self.m_tData.serverId and self.m_tData.serverId ~= CacheCenter:getPlayerInfo().serverId then 
        GetElement(self.m_root, "imgKuaFu_CellTowerRank", WZUIImage):setVisible(true)
    end
    
    local txtUnion = GetElement(self.m_root, "txtUnion_CellTowerRank", WZUILabelTTF)
    if string.len(self.m_tData.playerGuild) == 0 then
        txtUnion:setText(LocalStrings.SHOP_NOGONGHUI)
    else
        txtUnion:setText(self.m_tData.playerGuild)
    end

    local txtFloor = GetElement(self.m_root, "txtFloor_CellTowerRank", WZUILabelTTF)
    txtFloor:setText(string.format(LocalStrings.NUMBER_LEVEL,self.m_tData.playerFloor))

    local playerName = CacheCenter:getPlayerInfo().name
    local imgBg = GetElement(self.m_root,"imgBg_CellTowerRank",WZUI9Image)
    if playerName == self.m_tData.playerName then
        imgBg:setFile("ui/common/frame_lieb_01.png")
        -- txtLevel:setColor(GlobalMethod:ccc3(0,72,3))
        -- txtName:setColor(GlobalMethod:ccc3(0,72,3))
        -- txtUnion:setColor(GlobalMethod:ccc3(0,72,3))
        -- txtFloor:setColor(GlobalMethod:ccc3(0,72,3))
        -- if txtRank then
        --     txtRank:setColor(GlobalMethod:ccc3(0,72,3))
        -- end
    else
        imgBg:setFile("ui/common/frame_lieb.png")
        -- txtLevel:setColor(GlobalMethod:ccc3(105,65,45))
        -- txtName:setColor(GlobalMethod:ccc3(79,60,48))
        -- txtUnion:setColor(GlobalMethod:ccc3(79,60,48))
        -- txtFloor:setColor(GlobalMethod:ccc3(79,60,48))
    end

end

--@brief    更新界面 组队世界boss
function CellTowerRank:_update2()
    local tPlayerData = self.m_tData.player

    GetElement(self.m_root,"btnPlayerInfo_CellTowerRank",WZUIButton):setVisible(false)

    --头像
    for i=1, #tPlayerData do
        local conHead = GetElement(self.m_root,"conHead"..i.."_CellTowerRank",WZUIContainer)
        conHead:setVisible(true)
        CellHead:show(conHead,tPlayerData[i].headId,tPlayerData[i].faceId,tPlayerData[i].playerSex,nil,nil,tPlayerData[i].vipLevel,tPlayerData[i].headColor)
    end
    
    --排名
    local txtRank = GetElement(self.m_root,"txtRank_CellTowerRank",WZUILabelTTF)
    local imgRank = GetElement(self.m_root,"imgRank_CellTowerRank",WZUIImage)
    if self.m_nRank == 1 then
        imgRank:setFile("ui/common/common_icon_1st_1.png")
        txtRank:setText("")
    elseif self.m_nRank == 2 then
        imgRank:setFile("ui/common/common_icon_2nd_1.png")
        txtRank:setText("")
    elseif self.m_nRank == 3 then
        imgRank:setFile("ui/common/common_icon_3rd_1.png")
        txtRank:setText("")
    else
        imgRank:setFile("")
        txtRank:setText(self.m_nRank)
    end
    GetElement(self.m_root,"conRank_CellTowerRank",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.297,0.5))

    --名字
    local strNname = ""
    if #tPlayerData == 1 then
        local strFormat = [[<T C="127,70,26" S="20" P="0">%s</T>]]
        strNname = string.format(strFormat,tPlayerData[1].playerName)
    elseif #tPlayerData == 2 then
        local strFormat = [[<T C="127,70,26" S="20" P="0">%s</T><T C="229,105,22" S="20" P="0">&</T><T C="127,70,26" S="20" P="0">%s</T>]]
        strNname = string.format(strFormat,tPlayerData[1].playerName,tPlayerData[2].playerName)
    end
    local ftbName = GetElement(self.m_root, "ftbName_CellTowerRank", WZUIFreeTextBox)
    ftbName:setShowText(strNname)
    GetElement(self.m_root,"conName_CellTowerRank",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    
    --伤害
    local hurtPercent = self.m_tData.hurt/SceneWorldTeamBossRoom.bossRoomInfo.bossBloodMax * 100
    local nPercent = string.format("%0.2f", hurtPercent)
    local txtFloor = GetElement(self.m_root, "txtFloor_CellTowerRank", WZUILabelTTF)
    txtFloor:setText(self.m_tData.hurt .. "(" .. nPercent .. "%" .. ")")

    --自己的状态
    local imgBg = GetElement(self.m_root,"imgBg_CellTowerRank",WZUI9Image)
    local playerName = CacheCenter:getPlayerInfo().name
    if playerName == self.m_tData.playerName then
        imgBg:setFile("ui/common/frame_lieb_01.png")
    else
        imgBg:setFile("ui/common/frame_lieb.png")
    end

end

--@brief    更新界面 单人世界boss
function CellTowerRank:_update3()
    --头像
    local conHead = GetElement(self.m_root, "conHead1_CellTowerRank",WZUIContainer)
    conHead:setRelativePosition(GlobalMethod:ccp(0.115,0.5))
    CellHead:show(conHead,self.m_tData.headId,self.m_tData.faceId,self.m_tData.playerSex,nil,nil,self.m_tData.vipLevel,self.m_tData.headColor)
    
    --排名
    local txtRank = GetElement(self.m_root,"txtRank_CellTowerRank",WZUILabelTTF)
    local imgRank = GetElement(self.m_root,"imgRank_CellTowerRank",WZUIImage)
    if self.m_nRank == 1 then
        imgRank:setFile("ui/common/common_icon_1st_1.png")
        txtRank:setText("")
    elseif self.m_nRank == 2 then
        imgRank:setFile("ui/common/common_icon_2nd_1.png")
        txtRank:setText("")
    elseif self.m_nRank == 3 then
        imgRank:setFile("ui/common/common_icon_3rd_1.png")
        txtRank:setText("")
    else
        imgRank:setFile("")
        txtRank:setText(self.m_nRank)
    end
    GetElement(self.m_root,"conRank_CellTowerRank",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.297,0.5))

    --名字    
    local txtName = GetElement(self.m_root, "txtName_CellTowerRank", WZUILabelTTF)
    txtName:setText(self.m_tData.playerName)
    GetElement(self.m_root,"conName_CellTowerRank",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.55,0.5))

    --伤害
    local hurtPercent = self.m_tData.hurt/SceneWorldBoss.bossRoomInfo.bossBloodMax * 100
    local nPercent = string.format("%0.2f", hurtPercent)
    local txtFloor = GetElement(self.m_root, "txtFloor_CellTowerRank", WZUILabelTTF)
    txtFloor:setText(self.m_tData.hurt .. "(" .. nPercent .. "%" .. ")")

    --自己的状态
    local imgBg = GetElement(self.m_root,"imgBg_CellTowerRank",WZUI9Image)
    local playerName = CacheCenter:getPlayerInfo().name
    if playerName == self.m_tData.playerName then
        imgBg:setFile("ui/common/frame_lieb_01.png")
    else
        imgBg:setFile("ui/common/frame_lieb.png")
    end

end


--@brief    更新界面 夫妻争霸
function CellTowerRank:_update4()
    local tPlayerData = self.m_tData.player

    GetElement(self.m_root,"btnPlayerInfo_CellTowerRank",WZUIButton):setVisible(false)

    --头像
    for i=1, #tPlayerData do
        local conHead = GetElement(self.m_root,"conHead"..i.."_CellTowerRank",WZUIContainer)
        conHead:setVisible(true)
        CellHead:show(conHead,tPlayerData[i].headId,tPlayerData[i].faceId,tPlayerData[i].playerSex,nil,nil,tPlayerData[i].vipLevel,tPlayerData[i].headColor)
    end
    
    --排名
    local txtRank = GetElement(self.m_root,"txtRank_CellTowerRank",WZUILabelTTF)
    local imgRank = GetElement(self.m_root,"imgRank_CellTowerRank",WZUIImage)
    if self.m_nShowSubType == 1 then
        if self.m_nRank == 1 then
            imgRank:setFile("ui/common/common_icon_1st_1.png")
            txtRank:setText("")
        elseif self.m_nRank == 2 then
            imgRank:setFile("ui/common/common_icon_2nd_1.png")
            txtRank:setText("")
        elseif self.m_nRank == 3 then
            imgRank:setFile("ui/common/common_icon_3rd_1.png")
            txtRank:setText("")
        else
            imgRank:setFile("")
            txtRank:setText(self.m_nRank)
        end
    elseif self.m_nShowSubType == 2 then
        imgRank:setFile("")
        txtRank:setText(string.format(LocalStrings.COMMONITY_DESC11,self.m_nRank))
    end

    GetElement(self.m_root,"conRank_CellTowerRank",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.297,0.5))

    --名字
    local strNname = ""
    if #tPlayerData == 1 then
        local strFormat = [[<T C="127,70,26" S="20" P="0">%s</T>]]
        strNname = string.format(strFormat,tPlayerData[1].playerName)
    elseif #tPlayerData == 2 then
        local strFormat = [[<T C="127,70,26" S="20" P="0">%s</T><T C="229,105,22" S="20" P="0">&</T><T C="127,70,26" S="20" P="0">%s</T>]]
        strNname = string.format(strFormat,tPlayerData[1].playerName,tPlayerData[2].playerName)
    end
    local ftbName = GetElement(self.m_root, "ftbName_CellTowerRank", WZUIFreeTextBox)
    ftbName:setShowText(strNname)
    GetElement(self.m_root,"conName_CellTowerRank",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    
    --伤害
    local txtFloor = GetElement(self.m_root, "txtFloor_CellTowerRank", WZUILabelTTF)
    -- local hurtPercent = self.m_tData.hurt/SceneCoupleHegemonyRoom.bossRoomInfo.bossBloodMax * 100
    -- local nPercent = string.format("%0.2f", hurtPercent)
    -- local strHurt = self.m_tData.hurt .. "(" .. nPercent .. "%" .. ")"
    local strHurt = self.m_tData.hurt
    txtFloor:setText(strHurt)

    --自己的状态
    local imgBg = GetElement(self.m_root,"imgBg_CellTowerRank",WZUI9Image)
    local playerName = CacheCenter:getPlayerInfo().name
    if playerName == self.m_tData.playerName then
        imgBg:setFile("ui/common/frame_lieb_01.png")
    else
        imgBg:setFile("ui/common/frame_lieb.png")
    end

end

--@brief    更新界面
function CellTowerRank:_update5()
    -- 人物头像
    local sex = self.m_tData.playerSex == 0 and true or false
    local conHead = GetElement(self.m_root, "conHead1_CellTowerRank",WZUIContainer)
    CellHead:show(conHead,self.m_tData.headId,self.m_tData.faceId,self.m_tData.sex,nil,nil,self.m_tData.vipLevel,self.m_tData.headColor)
    
    local txtRank = GetElement(self.m_root,"txtRank_CellTowerRank",WZUILabelTTF)
    local imgRank = GetElement(self.m_root,"imgRank_CellTowerRank",WZUIImage)
    if self.m_nRank == 1 then
        imgRank:setFile("ui/common/common_icon_1st_1.png")
        txtRank:setText("")
    elseif self.m_nRank == 2 then
        imgRank:setFile("ui/common/common_icon_2nd_1.png")
        txtRank:setText("")
    elseif self.m_nRank == 3 then
        imgRank:setFile("ui/common/common_icon_3rd_1.png")
        txtRank:setText("")
    else
        imgRank:setFile("")
        txtRank:setText(self.m_nRank)
    end

    local txtLevel = GetElement(self.m_root, "txtLevel_CellTowerRank", WZUILabelTTF)
    txtLevel:setText("Lv"..self.m_tData.level)
    
    local txtName = GetElement(self.m_root, "txtName_CellTowerRank", WZUILabelTTF)
    txtName:setText(self.m_tData.nickname)

    if self.m_tData.serverId and self.m_tData.serverId ~= CacheCenter:getPlayerInfo().serverId then 
        GetElement(self.m_root, "imgKuaFu_CellTowerRank", WZUIImage):setVisible(true)
    end

    local txtUnion = GetElement(self.m_root, "txtUnion_CellTowerRank", WZUILabelTTF)
    if self.m_tData.guildName == nil or string.len(self.m_tData.guildName) == 0 then
        txtUnion:setText(LocalStrings.SHOP_NOGONGHUI)
    else
        txtUnion:setText(self.m_tData.guildName)
    end

    local txtFloor = GetElement(self.m_root, "txtFloor_CellTowerRank", WZUILabelTTF)
    txtFloor:setText(string.format(LocalStrings.LEVEL_TEXT2,self.m_tData.point))

    local playerName = CacheCenter:getPlayerInfo().name
    local imgBg = GetElement(self.m_root,"imgBg_CellTowerRank",WZUI9Image)
    if playerName == self.m_tData.nickname then
        imgBg:setFile("ui/common/frame_lieb_01.png")
    else
        imgBg:setFile("ui/common/frame_lieb.png")
    end

end
-------------------------------------私有方法模块End----------------------------------------