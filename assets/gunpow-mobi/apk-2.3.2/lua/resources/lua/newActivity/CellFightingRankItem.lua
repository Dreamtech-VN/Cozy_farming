--CellFightingRankItem.lua
--@brief	CellFightingRankItem的UI模块
--@date		2017/08/23
--@author	Tianxiang_Xu
--@note		战力月榜之王活动-展示子节点cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFightingRankItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFightingRankItem:onExit(element)
	self:_unInit()
end

--@brief    点击膜拜按钮回调
function CellFightingRankItem:onClickWorship(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tData.playerId == CacheCenter:getPlayerInfo().id then
        MsgBoxManager:showTipBox(LocalStrings.CANT_WORSHIP_SELF)
        return 
    end

    CellFightingRankItem.m_current_click = self
    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_WorshipFigthingKing(self.m_tData.playerId)
end

--@brief    获取玩家信息
function CellFightingRankItem:onClickInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tData.playerId == -1 then 
        return 
    end

    if CellFightingRankPanel.m_current.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
        WndSpaceSendFlower:showInterface(1, self.m_tData.playerId)
    else
        WndCheckOther:show(self.m_tData.playerId)
    end
end

--@brief    加载
function CellFightingRankItem:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellFightingRankItem")
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true 
    AdaptLanguage(self)
    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellFightingRankItem:_update()
    -- body
    --排名
    self:_showRank()
    if self.m_tData.playerId == -1 then 
        GetElement(self.m_root, "conRole_CellFightingRankItem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conForInfo_CellFightingRankItem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conNull_CellFightingRankItem", WZUIContainer):setVisible(true)
        return 
    end
    GetElement(self.m_root, "conRole_CellFightingRankItem", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "conForInfo_CellFightingRankItem", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "conNull_CellFightingRankItem", WZUIContainer):setVisible(false)
    --等级，名字
    local ftxtName = GetElement(self.m_root, "ftxtName_CellFightingRankItem", WZUIFreeTextBox)
    if ProjConfig.LANGUAGE == "vn" then
        ftxtName:setMaxWidth(160)
    end
    local sFormat = [[<T C="255,255,255" S="18" P="1" SC="127,70,26" SS="4" SE="1">Lv%d</T><T C="255,227,116" S="18" P="1" SC="127,70,26" SS="4" SE="1"> %s</T>]]
    if ftxtName then 
        ftxtName:setShowText(string.format(sFormat, self.m_tData.level, self.m_tData.name))
    end
    --战力
    local txtFighting = GetElement(self.m_root, "txtFighting_CellFightingRankItem", WZUILabelTTF)
    --WZLog("--&&&&&&&&&&&&--111",CellFightingRankPanel.m_current.activityId)
    if CellFightingRankPanel.m_current.activityId == g_tGameActivityTypes.ACTIVITY_NEWSERVER_FIGHTINGRANK then
        if txtFighting then 
            txtFighting:setText(LocalStrings.COMBAT .. ":" .. self.m_tData.fighting)
        end
        --膜拜次数
        self:_showWorshipTimes()
    else
        if CellFightingRankPanel.m_current.activityId == g_tGameActivityTypes.ACIVIITY_RECHARGERANK or 
            CellFightingRankPanel.m_current.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK then
            txtFighting:setText(LocalStrings.ACTIVITY_TOTAL_RECHARGE..":"..self.m_tData.fighting)

            if ProjConfig.LANGUAGE == "vn" then
                txtFighting:setText(LocalStrings.ACTIVITY_TOTAL_RECHARGE..":"..math.floor(self.m_tData.fighting / 2000))
            end

            --东南亚渠道号 要求钻石乘6
            if ProjConfig.CHANNEL_ID == 1009 or ProjConfig.CHANNEL_ID == 1016 or ProjConfig.CHANNEL_ID == 1038 or ProjConfig.CHANNEL_ID == 1046 or ProjConfig.CHANNEL_ID == 1063 then
                txtFighting:setText(LocalStrings.ACTIVITY_TOTAL_RECHARGE..":"..math.floor(self.m_tData.fighting * 6))
            end
            --美洲渠道号 要求钻石乘5
            if ProjConfig.CHANNEL_ID == 1087 or ProjConfig.CHANNEL_ID == 1065 or ProjConfig.CHANNEL_ID == 1069 or ProjConfig.CHANNEL_ID == 1081 or ProjConfig.CHANNEL_ID == 1044 or ProjConfig.CHANNEL_ID == 1066 or ProjConfig.CHANNEL_ID == 1043 or ProjConfig.CHANNEL_ID == 1089 or ProjConfig.CHANNEL_ID == 1042 then
                txtFighting:setText(LocalStrings.ACTIVITY_TOTAL_RECHARGE..":"..math.floor(self.m_tData.fighting * 5))
            end

        elseif CellFightingRankPanel.m_current.activityId == g_tGameActivityTypes.ACIVIITY_CONSUMERANK or 
            CellFightingRankPanel.m_current.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK then
            txtFighting:setText(LocalStrings.GAME_ACTIVITY_TITLE6..":"..self.m_tData.fighting)
        elseif CellFightingRankPanel.m_current.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
            txtFighting:setText(LocalStrings.NUMBER_OF_FLOWERS_RECEIVED..":"..self.m_tData.fighting)
        end
        txtFighting:setRelativePosition(GlobalMethod:ccp(0.5,0.6))
        GetElement(self.m_root, "txtTimes_CellFightingRankItem", WZUILabelTTF):setVisible(false)
        GetElement(self.m_root,"btnWorship_CellFightingRankItem",WZUIButton):setVisible(false)
        if self.m_tData.cross == 1 then --跨服
            sFormat = [[<I Z="1">ui/common/common_icon_kuafu.png</I><T C="255,227,116" S="14" P="1" SC="105,65,46" SS="4" SE="1"> Lv%d</T><T C="255,255,255" S="14" P="1" SC="105,65,46" SS="4" SE="1"> %s</T>]] 
            ftxtName:setShowText(string.format(sFormat, self.m_tData.level, self.m_tData.name))
        end
    end
    --创建人物形象
    self:createRole()
end

--@brief    排名
function CellFightingRankItem:_showRank()
    -- body
    --排名
    local imgRankIndex = GetElement(self.m_root, "imgRankIndex_CellFightingRankItem", WZUIImage)
    local txtRankIndex = GetElement(self.m_root, "txtRankIndex_CellFightingRankItem", WZUILabelAtlasFont)
    if self.m_tData.rank <= 3 then
        imgRankIndex:setVisible(true)
        txtRankIndex:setVisible(false) 
        if self.m_tData.rank == 1 then 
            imgRankIndex:setFile("ui/common/common_icon_1st.png")
        elseif self.m_tData.rank == 2 then 
            imgRankIndex:setFile("ui/common/common_icon_2nd.png")
        else
            imgRankIndex:setFile("ui/common/common_icon_3rd.png")
        end
    else
        imgRankIndex:setVisible(false)
        txtRankIndex:setVisible(true)
        txtRankIndex:setText(self.m_tData.rank)
    end
end

--@brief    显示膜拜次数
function CellFightingRankItem:_showWorshipTimes()
    -- body
    local txtTimes = GetElement(self.m_root, "txtTimes_CellFightingRankItem", WZUILabelTTF)
    if txtTimes then 
        txtTimes:setText(string.format(LocalStrings.NEWACTIVITY_TEXT7, self.m_tData.worshipNum))
    end
end

--@brief    创建人物形象
function CellFightingRankItem:createRole()
    if self.m_root == nil then return end

    local anchorPoint = GlobalMethod:ccp(0.5, 0)
    local nSex = self.m_tData.sex or 0
    local tEquip = {}
    table.insert(tEquip,self.m_tData.headId)
    table.insert(tEquip,self.m_tData.faceId)
    table.insert(tEquip,self.m_tData.bodyId)
    table.insert(tEquip,self.m_tData.wingId)

    local conPlayerAni = self.m_root:getChildElement("conRole_CellFightingRankItem")

    local conPlayer
    if self.m_tPlayerAni == nil then --"wait0"
        conPlayer = CreatePlayerFigure(nSex, tEquip, "wait0", nil, nil, ccp(-0.4,1.5), nil, nil, nil, nil,self.m_tData.headColor, self.m_tData.bodyColor)
        conPlayerAni:addChild(conPlayer:getAnimNode())
        conPlayer:getAnimNode():setScale(0.55)
        self.m_tPlayerAni = conPlayer
        conPlayer:getAnimNode():setRelativePosition(anchorPoint) 
        conPlayer:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    else
        conPlayer = self.m_tPlayerAni
        conPlayer:getAnimNode():setRelativePosition(anchorPoint)
    end
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function CellFightingRankItem:_adaptLanguage_pt( )
    GetElement(self.m_root, "txtNull_CellFightingRankItem", WZUILabelTTF):setScale(0.7)
end

function CellFightingRankItem:_adaptLanguage_en( )
    GetElement(self.m_root, "txtFighting_CellFightingRankItem", WZUILabelTTF):setScale(0.8)
end
function CellFightingRankItem:_adaptLanguage_tr( )
    GetElement(self.m_root, "txtFighting_CellFightingRankItem", WZUILabelTTF):setScale(0.8)
end
function CellFightingRankItem:_adaptLanguage_ug( )
    GetElement(self.m_root, "txtNull_CellFightingRankItem", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(130))
end

-------------------------------------语言适配End----------------------------------------