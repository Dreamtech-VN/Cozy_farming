--WndCard.lua
--@brief	WndCard的UI模块
--@date		2016/07/25
--@author	Tianxiang_Xu
--@note		卡牌系统


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCard:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)

    ProtocolProcessorCard:regAll()
    self.m_nServerTime = SystemTime:getServerTime()
    self.m_root:enableSchedule("refreshShop", 0.2)

    TeachGroup1:endTeachStep({44,3})
    self:_AdaptationIphoneX()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCard:onExit(element)
    self.m_root:disableSchedule()
    local conMiddle = GetElement(self.m_root, "conMiddle_WndCard", WZUIContainer)
    conMiddle:disableSchedule()
    ProtocolProcessorCard:unregAll()
	self:_unInit()
end

--@brief    加载界面完成回调
function WndCard:onEnterTransitionDidFinish(element)
    -- body
    ChangeChatChannel(Chat_Channel_Card)
    local conMiddle = GetElement(self.m_root, "conMiddle_WndCard", WZUIContainer)
    conMiddle:enableSchedule("_cardBoxAttTalk", 3)
    self.m_nTotalOpenTimes = tonumber(CacheCenter:getGameParam()["opencardsettimes"])
    self.m_tCDTimePrice = tonumber(CacheCenter:getGameParam()["opencardsetprice"])
    --获取物品表中所有的卡牌
    self:_getAllCards()
    --添加顶部货币项
    self:_addTop()

    --新手定推礼包入口
    local conTopMenu = GetElement(self.m_root, "conTopMenu_WndCard", WZUIContainer)
    CreateLimitPackage(76, conTopMenu, GlobalMethod:ccp(0.5, 0.6))
    
    self:_createLoading()
    ProtocolProcessorCard:send_CARD_GetCardMes()
    ProtocolProcessorCard:send_CARD_GetCardSetList()
end

--@brief    觸摸開始
function WndCard:onTouchBegan(element, pt)
    --移除战力总属性tips
    local conLeftList = GetElement(self.m_root, "conLeftList_WndCard", WZUIContainer)
    if conLeftList:getChildByTag(999) then
        conLeftList:removeChildByTag(999, true)
    end

    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end

    if self.m_topCellLua then
        self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
end


--@brief    退出界面回调
function WndCard:onClickClose()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击卡牌标签回调
function WndCard:onTabCard(element)
    -- body
    if self.m_nTabIndex == 1 then
        return 
    end
    self.m_nTabIndex = 1 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    self:_setContainerVisible(true, false)

    self.m_tCardDataSel = nil 
    self.m_nOperateType = 0 
    self:_drawCard()
end

--@brief    点击卡套标签回调
function WndCard:onTabCardBox(element)
    -- body
    TeachGroup1:endTeachStep({44,4})
    if self.m_nTabIndex == 2 then
        return 
    end
    self.m_nTabIndex = 2 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    self:_setContainerVisible(false, true)

    self.m_nOperateType = 2
    self:_createLoading()
    ProtocolProcessorCard:send_CARD_GetCardSetList()
end

--@brief    点击商店标签回调
function WndCard:onTabShop(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndStore:showStoreByType(5,self,self.getCardList)
end



--@brief    点击规则按钮回调
function WndCard:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.CARD_TEXT34)    
end

--@brief    点击升级回调
function WndCard:onClickUpgrade(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local cardCoinNum = CacheCenter:getMoneyList().card
    --获取当前要上级的卡牌的数据
    local tData = self.m_tClickCell:getData()
    self.m_tCardDataSel = tData
    WZLog("WndCard:onClickUpgrade", cardCoinNum, tData.cost[1][2], tData.curNum , tData.cost[2][2])
    --卡币不足
    if cardCoinNum < tData.cost[1][2] then
        MsgBoxManager:showTipBox(LocalStrings.CARD_TEXT17)
        return
    end
    --卡牌数量不足
    if tData.curNum < tData.cost[2][2] then
        MsgBoxManager:showTipBox(LocalStrings.CARD_TEXT16)
        return 
    end
    --调用升级协议
    self.m_nOperateType = 1
    self:_createLoading()
    ProtocolProcessorCard:send_CARD_UpCard(tData.item_id)
end

--@brief    点击卡牌回调
--@param    tCardData:卡牌的数据
function WndCard:onClickCard(tCell, tCardData)
    -- body
    --不用加声音，已经在cell中的点击函数中加了
    --设置卡牌的选中状态
    self:setCardSel(tCardData)

    self:_showCardDetail(tCardData)
end

--@brief    点击卡套回调
--@param    tCardBoxData:卡套的数据
function WndCard:onClickCardBox(tCardBoxData)
    -- body
    WndOpenCardBox:showInterface(tCardBoxData, self.m_nTime, self.m_nLeftOpenTimes)
end

--@brief    点击卡牌标签中的头像按钮回调
--@note     查看总战力和总属性
function WndCard:onClickHead(element)
    -- body
    --不用加声音，已经在cell中的点击函数中加了
    local tProperty = self:_getTotalProperty()
    if tProperty == nil or #tProperty == 0 then
        MsgBoxManager:showTipBox(LocalStrings.CARD_TEXT26)
        return 
    end

    local nTotalFighting = self:_caculateFighting(tProperty)

    WZLog("WndCard:onClickHead", nTotalFighting, Serialize(tProperty))
    local conLeftList = GetElement(self.m_root, "conLeftList_WndCard", WZUIContainer)
    self:_createPropertyTips(conLeftList, nTotalFighting, tProperty)
end

--@brief    凌晨发协议刷新商店
function WndCard:refreshShop(element, delta)
    -- body
    self.m_nCaculateTime = self.m_nCaculateTime + delta
    if self.m_nCaculateTime >= 1 then
        self.m_nServerTime = self.m_nServerTime + 1 
        if self.m_nTime then
            if self.m_nTime >= 1 then
                self.m_nTime = self.m_nTime - 1 
                self:_refreshCDTime()
            end 
        end
        self.m_nCaculateTime = self.m_nCaculateTime - 1
        -- local sCurTime = os.date("%X", self.m_nServerTime)
        -- if sCurTime == "00:00:00" then
        --     self:_createLoading()
        --     self.m_nOperateType = 99
        --     ProtocolProcessorCard:send_CARD_GetCardMes()
        -- end
    end
end

--@brief    将创建的卡牌的表添加到一个表中统一管理
function WndCard:addCardCell(tNewObj)
    -- body
    if self.m_tAllCardCell == nil then
        self.m_tAllCardCell = {}
    end

    table.insert(self.m_tAllCardCell, tNewObj)
end

--@brief    设置点中的卡牌高亮
function WndCard:setCardSel(tData)
    -- body
    WZLog("WndCard:setCardSel", type(self.m_tAllCardCell))
    if self.m_tAllCardCell == nil then return end

    for i = 1, #self.m_tAllCardCell do
        local tempData = self.m_tAllCardCell[i]:getData()
        WZLog("WndCard:setCardSel", tempData.item_id, tData.item_id)
        if tempData.item_id == tData.item_id then
            self.m_tAllCardCell[i]:setHighLightVisible(true)
        else
            self.m_tAllCardCell[i]:setHighLightVisible(false)
        end
    end
end

--@brief    刷新CD时间
function WndCard:_refreshCDTime()
    -- body
    if self.m_nTime then
        local txtOpenTime = GetElement(self.m_root, "txtOpenTime_WndCard", WZUIFreeTextBox)
        local sTime = returnToTimeFormat(self.m_nTime)
        local sContent 

        --卡套红点
        local conRed = GetElement(self.m_root, "conRed_WndCard", WZUIContainer)
        if self.m_nTime <= 0 then
            if self.m_tCardBoxList and #self.m_tCardBoxList > 0 then
                conRed:setVisible(true)
                WndBottomBar:setCardRedPoint(true)
            else
                conRed:setVisible(false)
                WndBottomBar:setCardRedPoint(false)
            end
            sContent = string.format(LocalStrings.CARD_TEXT31)
            GetElement(self.m_root, "btnTimeSpeed_WndCard", WZUIButton):setVisible(false)
        else
            GetElement(self.m_root, "btnTimeSpeed_WndCard", WZUIButton):setVisible(true)
            conRed:setVisible(false)
            sContent = string.format(LocalStrings.CARD_TEXT5, sTime)
            
            WndBottomBar:setCardRedPoint(false)
        end

        txtOpenTime:setShowText(sContent)
    end
end

--@brief    卡套冒泡
function WndCard:_cardBoxAttTalk(element)
    -- body
    WZLog("WndCard:_cardBoxAttTalk")
    local conMiddle = element
    local bHaveCardBag = self:_judgeHaveCardBag()
    if self.m_nTime == nil or self.m_nTime > 0 or self.m_tCardBoxList == nil or #self.m_tCardBoxList == 0 or (self.m_nLeftOpenTimes == 0 and (not bHaveCardBag)) then 
        if conMiddle:getChildByTag(777) then
            conMiddle:removeChildByTag(777, true)
        end
        return 
    end

    if conMiddle:getChildByTag(777) then
        conMiddle:removeChildByTag(777, true)
    else
        local imgTalkBK = WZUIImage:create()
        imgTalkBK:setTouchEnable(false)
        imgTalkBK:setUseOriginSize(true)
        imgTalkBK:setScale(0.8)
        imgTalkBK:setFile("ui/common/common_icon_duihuakuang.png")
        imgTalkBK:setAnchorPoint(GlobalMethod:ccp(1, 0))
        imgTalkBK:setRelativePosition(GlobalMethod:ccp(0.96, 0.9))

        conMiddle:addChild(imgTalkBK, 2, 777)

        local txtAtt = WZUILabelTTF:create()
        txtAtt:setFontSize(22)
        txtAtt:setTouchEnable(false)
        txtAtt:setDimensions(GlobalMethod:CCSize(170,0))
        txtAtt:setRelativePosition(GlobalMethod:ccp(0.5,0.6))
        txtAtt:setColor(GlobalMethod:ccc3(127,72,26))
        txtAtt:setText(LocalStrings.CARD_TEXT32)
        imgTalkBK:addChild(txtAtt)
        if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or  ProjConfig.LANGUAGE == "en" then
            txtAtt:setScale(0.7)
            txtAtt:setDimensions(GlobalMethod:CCSize(240,0))
        end
    end
end

--@brief  点击限时特惠礼包按钮回调
function WndCard:OpenNewUserPackage(element)
    --body
    OpenNewUserPackage(element)
end

--@brief    点击加速按钮回调
function WndCard:onClickTimeSpeed(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nTime <= 0 then return end 

    local nNum = CacheCenter:getPlayerItemCountById(79)
    local nNeedMinutes = math.ceil(self.m_nTime/60)
    if nNum > 0 then 
        local nHours, nMinutes = 0, 0
        if nNum >= nNeedMinutes then 
            nHours = math.floor(nNeedMinutes/60)
            nMinutes = nNeedMinutes - nHours * 60
        else
            nHours = math.floor(nNum/60)
            nMinutes = nNum - nHours * 60
        end
        local sContent = string.format(LocalStrings.TOPGOLD_TEXT3, GDatatab_item["id_79"].icon, nHours, nMinutes)
        MsgBoxManager:showConfirmBox(sContent, self, self.useTimeCoin)
    else
        local price = tonumber(CacheCenter:getGameParam()["opencardsetprice"])
        local diamondNum = math.ceil(self.m_nTime / 60) * price
        MsgBoxManager:showConfirmBox(string.format(LocalStrings.CARD_TEXT19, diamondNum), self,self.clickSure)
    end
end

--@brief    使用时间币消除时间
function WndCard:useTimeCoin()
    -- body
    self:sureUseDiamondInstead()
end

--@brief    点击确认消除cd时间回调
function WndCard:clickSure()
    -- body
    local price = tonumber(CacheCenter:getGameParam()["opencardsetprice"])
    local diamondNum = math.ceil(self.m_nTime / 60) * price
    if CacheCenter:getGameParam().isUseTicket == "0" then
        if not JudgeMoneyIsEnough(70, diamondNum, LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, nil, Chat_Channel_Card, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
            return 
        end
    else
        if not JudgeMoneyIsEnough(1, diamondNum, LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, nil, Chat_Channel_Card, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
            return 
        end
    end

    self:sureUseDiamondInstead()
end

--@brief    确认用钻石代替礼券开启卡套回调
function WndCard:sureUseDiamondInstead()
    -- body
    --发送打开卡套协议
    self:_createLoading()
    ProtocolProcessorCard:send_CARD_SpeedUp()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief     添加顶部货币栏
function WndCard:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_kapai.png", WndCard, WndCard.onClickClose, true, false, false,nil, {goldType = 5})
    self.m_root:addChild(celElement)

    self.m_topCellLua = tNewObj
end

--@brief    初始化左边卡牌列表
function WndCard:_initCardList()
    -- body
    self.m_nLeftListIndex = 1
    self.m_nListTag = 0
    self.m_tAllCardCell = {}

    local conflActiveCard = GetElement(self.m_root, "conflActiveCard_WndCard", WZUIFreeListContainer)
    conflActiveCard:removeAll()

    conflActiveCard:enableSchedule("_createCardList")
end
--@brief    创建左边卡牌列表
function WndCard:_createCardList(element)
    -- body
    element = WZUIFreeListContainer:luaTo(element)
    if self.m_nLeftListIndex > 4 then
        if self.m_nOperateType == 1 then
            if self.m_tCardDataSel then
                self:setCardSel(self.m_tCardDataSel)
            end
        else
            if self.m_tActiveCardList and #self.m_tActiveCardList ~= 0 then
                self:setCardSel(self.m_tActiveCardList[1])
            elseif self.m_tUnActiveCardList and #self.m_tUnActiveCardList ~= 0 then
                self:setCardSel(self.m_tUnActiveCardList[1])
            end
        end
        element:disableSchedule()
        return 
    end
    if self.m_nLeftListIndex == 1 then
        local celElement, tNewObj = CellCardMark:createElement()
        if celElement and tNewObj then
            local sTitle = string.format(LocalStrings.CARD_TEXT1, self.m_nCollectCardNum)
            tNewObj:setData(sTitle, true)
            tNewObj:setCallBackFunc(self, self.onClickHead, self.addCardCell)
            celElement:setTag(self.m_nListTag)
            celElement = WZUIContainer:luaTo(celElement)
            celElement:setContentSize(GlobalMethod:CCSize(630,50))
            celElement:setRelativeSize(GlobalMethod:CCSize(1,50/480))
            element:pushBack(celElement)
        end
    elseif self.m_nLeftListIndex == 2 then      --已经收集的卡牌列表
        if self.m_tActiveCardList ~= nil and #self.m_tActiveCardList ~= 0 then
            local nListNum = math.ceil(#self.m_tActiveCardList/4)
            for i = 1, nListNum do
                local celElement, tNewObj = CellCardListItem:createElement()
                if celElement and tNewObj then
                    --获取一行4张卡牌的数据
                    local tData = {}
                    for j = 1, 4 do
                        if self.m_tActiveCardList[(i - 1)*4 + j] then
                            table.insert(tData, self.m_tActiveCardList[(i - 1)*4 + j])
                        else
                            break
                        end
                    end
                    tNewObj:setCallBackFunc(self, self.onClickCard, self.addCardCell)
                    tNewObj:setData(tData)
                    celElement:setTag(self.m_nListTag)
                    celElement = WZUIContainer:luaTo(celElement)
                    celElement:setContentSize(GlobalMethod:CCSize(580,180))
                    celElement:setRelativeSize(GlobalMethod:CCSize(1,180/480))
                    element:pushBack(celElement)

                    self.m_nListTag = self.m_nListTag + 1
                    element:getMoveElement():setPositionY(element:getMinPosition().y)
                end
            end
        end
    elseif self.m_nLeftListIndex == 3 then
        local celElement, tNewObj = CellCardMark:createElement()
        if celElement and tNewObj then
            local sTitle = string.format(LocalStrings.CARD_TEXT3, self.m_nUnCollectCardNum)
            tNewObj:setData(sTitle, false)
            celElement:setTag(self.m_nListTag)
            celElement = WZUIContainer:luaTo(celElement)
            celElement:setContentSize(GlobalMethod:CCSize(630,50))
            celElement:setRelativeSize(GlobalMethod:CCSize(1,50/480))
            element:pushBack(celElement)
        end
    elseif self.m_nLeftListIndex == 4 then         --未收集的卡牌列表
        if self.m_tUnActiveCardList ~= nil and #self.m_tUnActiveCardList ~= 0 then
            local nListNum = math.ceil(#self.m_tUnActiveCardList/4)
            for i = 1, nListNum do
                local celElement, tNewObj = CellCardListItem:createElement()
                if celElement and tNewObj then
                    --获取一行4张卡牌的数据
                    local tData = {}
                    for j = 1, 4 do
                        if self.m_tUnActiveCardList[(i - 1)*4 + j] then
                            table.insert(tData, self.m_tUnActiveCardList[(i - 1)*4 + j])
                        else
                            break
                        end
                    end
                    tNewObj:setCallBackFunc(self, self.onClickCard, self.addCardCell)
                    tNewObj:setData(tData)
                    celElement:setTag(self.m_nListTag)
                    celElement = WZUIContainer:luaTo(celElement)
                    celElement:setContentSize(GlobalMethod:CCSize(580,140))
                    celElement:setRelativeSize(GlobalMethod:CCSize(1,100/480))
                    element:pushBack(celElement)
                    
                    self.m_nListTag = self.m_nListTag + 1
                    element:getMoveElement():setPositionY(element:getMinPosition().y)
                end
            end
        end
    end

    self.m_nLeftListIndex = self.m_nLeftListIndex + 1 
    self.m_nListTag = self.m_nListTag + 1
    element:getMoveElement():setPositionY(element:getMinPosition().y)
end

--@brief    显示卡牌的详细信息
function WndCard:_showCardDetail(tData)
    -- body
    local qualityName = {LocalStrings.CARD_TEXT23, LocalStrings.CARD_TEXT24, LocalStrings.CARD_TEXT25, LocalStrings.CARD_TEXT37}
    --卡牌图标
    local conIcon = GetElement(self.m_root, "conIcon_WndCard", WZUIContainer)
    if conIcon:getChildByTag(99) then
        WZLog("WndCard:_showCardDetail")
        conIcon:removeChildByTag(99, true)
    end
    local celElement, tNewObj = CellCardItem:createElement()
    tNewObj:setData(tData)
    tNewObj:setPrgVisible(false)
    celElement:setAnchorPoint(GlobalMethod:ccp(0.5, 1))
    celElement:setRelativePosition(GlobalMethod:ccp(0.5, 1))
    conIcon:addChild(celElement,0,99)
    self.m_tClickCell = tNewObj
    if self.m_bUpgradeSuccess == true then
        --卡牌升级成功动画
        self.m_bUpgradeSuccess = false
        self:playUpgradeSpine()
    end
    --卡牌名字
    local txtCardName = GetElement(self.m_root, "txtCardName_WndCard", WZUILabelTTF)
    txtCardName:setText(tData.basicInfo.name)
    txtCardName:setColor(QUALITYCOLOR[tData.basicInfo.quality])
    --卡牌品质
    local txtQualityValue = GetElement(self.m_root, "txtQualityValue_WndCard", WZUILabelTTF)
    txtQualityValue:setText(qualityName[tData.basicInfo.quality])
    --等级
    local txtLevelValue = GetElement(self.m_root, "txtLevelValue_WndCard", WZUILabelTTF)
    txtLevelValue:setText(tData.level)
    --数量
    local txtExpValue = GetElement(self.m_root, "txtExpValue_WndCard", WZUILabelTTF)
    --数量条
    local prgExp = GetElement(self.m_root, "prgExp_WndCard", WZUIProgress)
    if tData.level >= self:_getMaxLevel(tData.item_id) then
        txtExpValue:setText(tData.curNum .. "/" .. "Max")
        prgExp:setPercentage(100)
    else
        txtExpValue:setText(tData.curNum .. "/" .. tData.upgradeNum)
        prgExp:setPercentage(math.floor(100 * tData.curNum/tData.upgradeNum))
    end
    
    --属性
    WZLog("tData.state", tData.state)
    if tData.state == 0 then
        GetElement(self.m_root, "conProperty_WndCard", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conFighting_WndCard", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conBtn_WndCard", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conPath_WndCard", WZUIContainer):setVisible(true)

        local txtPathWords = GetElement(self.m_root, "txtPathWords_WndCard", WZUILabelTTF)
        txtPathWords:setText(LocalStrings.GET_ACCESS .. ":")
        local txtPath = GetElement(self.m_root, "txtPath_WndCard", WZUILabelTTF)
        txtPath:setText(tData.basicInfo.channel)
    else
        local conProperty = GetElement(self.m_root, "conProperty_WndCard", WZUIContainer)
        conProperty:setVisible(true)
        GetElement(self.m_root, "conFighting_WndCard", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conBtn_WndCard", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conPath_WndCard", WZUIContainer):setVisible(false)
        --按钮上级消耗
        local txtUpgradeCost = GetElement(self.m_root, "txtUpgradeCost_WndCard", WZUILabelTTF)
        txtUpgradeCost:setText(tData.cost[1][2])
        --隐藏掉
        if conProperty:getChildByTag(88) then
            conProperty:removeChildByTag(88, true)
        end
        local propertyNum = #tData.property
        local conText = WZUIContainer:create()
        conText:setUseAbsSize(true)
        conText:setAbsContentSize(GlobalMethod:CCSize(296, propertyNum * 30))
        conText:setAnchorPoint(GlobalMethod:ccp(0,0.5))
        conText:setRelativePosition(GlobalMethod:ccp(0,0.5))
        conProperty:addChild(conText,0,88)
        
        local sPropertyFormat = [[<T C="255,227,116" S="20" P="1">%s:</T><T C="255,236,193" S="20" P="1">%d</T>]]
        for i = 1, #tData.property do
            local txtProperty = WZUIFreeTextBox:create()
            txtProperty:setMaxWidth(150)
            txtProperty:setUseAbsSize(true)
            txtProperty:setAnchorPoint(GlobalMethod:ccp(0,0.5))
            txtProperty:setRelativePosition(GlobalMethod:ccp(0.07,1-(1 + (i - 1)*2)/(propertyNum*2)))
            local sProperty = string.format(sPropertyFormat, ATTR_TITLE[tData.property[i][1]], tData.property[i][2])
            txtProperty:setShowText(sProperty)
            conText:addChild(txtProperty)
            if ProjConfig.LANGUAGE == "es" then
                txtProperty:setScale(0.8)
            end
        end
        --如果是最高等级，隐藏掉下一级的属性，显示MAX特效
        if tData.level >= self:_getMaxLevel(tData.item_id) then
            GetElement(self.m_root, "spineMax_CellCardItem", WZUISpine):setVisible(true)
            GetElement(self.m_root, "btnUpgrade_WndCard", WZUIButton):setVisible(false)
            GetElement(self.m_root, "txtMaxLevel_WndCard", WZUILabelTTF):setVisible(true)
        else
            GetElement(self.m_root, "spineMax_CellCardItem", WZUISpine):setVisible(false)
            GetElement(self.m_root, "btnUpgrade_WndCard", WZUIButton):setVisible(true)
            GetElement(self.m_root, "txtMaxLevel_WndCard", WZUILabelTTF):setVisible(false)
            --获取当前卡牌下一等级的数据
            local tNextData = self:_getNextData(tData.item_id, tData.level)
            --展示升到下一等级卡牌的属性
            if tNextData then
                for i = 1, #tNextData.property do
                    local txtNextProperty = WZUILabelTTF:create()
                    txtNextProperty:setFontSize(20)
                    txtNextProperty:setColor(GlobalMethod:ccc3(99,255,95))
                    txtNextProperty:setAnchorPoint(GlobalMethod:ccp(0,0.5))
                    txtNextProperty:setRelativePosition(GlobalMethod:ccp(0.63,1-(1 + (i - 1)*2)/(propertyNum*2)))
                    txtNextProperty:setText(tNextData.property[i][2])
                    conText:addChild(txtNextProperty)
                    if ProjConfig.LANGUAGE == "es" then
                        txtNextProperty:setScale(0.8)
                    end
                end
            end
        end
        
        --战斗力
        self:_cardFighting(tData)
    end
    --如果是新的卡牌，發送协议，改变状态
    if tData.bIsNew then
        tNewObj:setSpineVisible(false)
        ProtocolProcessorCard:send_CARD_LookCard(tData.item_id)
    end
    --当点击的是new状态的卡牌的时候，这只new特效不可见
    for i = 1, #self.m_tActiveCardList do
        if self.m_tActiveCardList[i].item_id == tData.item_id then
            self.m_tActiveCardList[i].bIsNew = false
            break
        end
    end
    for i = 1, #self.m_tAllCardCell do
        local tempData = self.m_tAllCardCell[i]:getData()
        if tempData.item_id == tData.item_id then
            self.m_tAllCardCell[i]:setSpineVisible(false)
            break
        end
    end
end

--@brief    切换标签时显示相应的内容
--@param    bCardVisible: 卡牌界面是否可见
--@param    bCardBoxVisible: 卡套界面是否可见
function WndCard:_setContainerVisible(bCardVisible, bCardBoxVisible)
    -- body
    GetElement(self.m_root, "conMain_WndCard", WZUIContainer):setVisible(bCardVisible)
    GetElement(self.m_root, "conCardBox_WndCard", WZUIContainer):setVisible(bCardBoxVisible)
end

--@brief    初始化卡套界面
function WndCard:_initCardBox()
    -- body
    --次数
    local txtLeftTimes = GetElement(self.m_root, "txtLeftTimes_WndCard", WZUILabelTTF)
    txtLeftTimes:setText(string.format(LocalStrings.CARD_TEXT4, self.m_nLeftOpenTimes, self.m_nTotalOpenTimes))
    --CD时间
    self:_refreshCDTime()
    --卡套列表
    local tbBoxList = GetElement(self.m_root, "tbBoxList_WndCard", WZUITableContainer)
    tbBoxList:cleanTable()

    WZLog("WndCard:_initCardBox", self.m_tCardBoxList and #self.m_tCardBoxList)
    --判断卡套列表是否为空
    local conCardBox = GetElement(self.m_root, "conCardBox_WndCard", WZUIContainer)
    if self.m_tCardBoxList == nil or #self.m_tCardBoxList == 0 then
         ShowPanelNullTip(conCardBox, LocalStrings.CARD_TEXT33, GlobalMethod:ccc3(255,236,193))

        TeachGroup1:setTeachFinish(44, -1, true)
        ProtocolProcessorTeach:send_TASK_TiroStep(44, -1)
        TeachGroup1:removeTeach()
        return
    end

    --移除暂无数据
    removeShowPanelNullTip(conCardBox)

    for i = 1, #self.m_tCardBoxList do
        local celElement, tNewObj = CellCardBoxItem:createElement()
        if celElement and tNewObj then
            tNewObj:setData(self.m_tCardBoxList[i])
            tNewObj:setCallBackFunc(self, self.onClickCardBox)
            celElement:setTag(i - 1)
            tbBoxList:setCellElement(celElement)
        end
    end

    local isFinish44, finishStep44 = TeachGroup1:isTeachFinish(44)
    if self.m_nTabIndex == 2 and isFinish44 ~= true and finishStep44 >= 0 and CacheCenter:getPlayerInfo().level == 32 then
        TeachGroup1:startGroup({44,5,tbBoxList})
    end
end

--@brief    计算已激活的卡牌总属性
function WndCard:_getTotalProperty()
    --body
    if self.m_tActiveCardList == nil or #self.m_tActiveCardList == 0 then
        return nil 
    end

    local tProperty = {}

    for i = 1, #self.m_tActiveCardList do 
        if self.m_tActiveCardList[i].property then
            local property = self.m_tActiveCardList[i].property
            for j = 1, #property do
                local bExist = false 
                for k = 1, #tProperty do
                    if tProperty[k][1] == property[j][1] then
                        bExist = true
                        tProperty[k][2] = tProperty[k][2] + property[j][2]
                        break 
                    end
                end
                if bExist == false then
                    local tempData = {property[j][1],property[j][2]}
                    table.insert(tProperty, tempData)
                end
            end
        end
    end
    return tProperty
end

--@brief    创建战力属性总tips
--@param    parentNode:tips添加到的父节点
--@param    fighting:总战力
--@param    tProperty:总属性
function WndCard:_createPropertyTips(parentNode, fighting, tProperty)
    -- body
    local conTips = WZUIContainer:create()
    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
        conTips:setAbsContentSize(GlobalMethod:CCSize(190,252))
    else
        conTips:setAbsContentSize(GlobalMethod:CCSize(175,252))
    end
    conTips:setUseAbsSize(true)
    conTips:setAnchorPoint(GlobalMethod:ccp(0, 1))
    conTips:setRelativePosition(GlobalMethod:ccp(0.1,0.97))

    local imgBK = WZUI9Image:create()
    imgBK:setFile("ui/common/common_scale9_di24.png")
    conTips:addChild(imgBK)

    local sFormat = [[<T C="255,227,116" S="20" P="1">%s:</T><T C="255,236,193" S="20" P="1"> %d</T>]]
    local ptX = 0.1
    if ProjConfig.LANGUAGE == "en" then
        ptX = 0.05
    end
    if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" or 
        ProjConfig.LANGUAGE == "es" then
        sFormat = [[<T C="255,227,116" S="18" P="1">%s:</T><T C="255,236,193" S="18" P="1">%d</T>]]
    end
    local txtFighting = WZUIFreeTextBox:create()
    txtFighting:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
    txtFighting:setRelativePosition(GlobalMethod:ccp(ptX, 0.9))
    txtFighting:setMaxWidth(200)
    txtFighting:setShowText(string.format(sFormat, LocalStrings.COMBAT_IN_ALL, fighting))
    conTips:addChild(txtFighting)
    if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
        txtFighting:setScale(0.7)
        txtFighting:setMaxWidth(400)
    elseif ProjConfig.LANGUAGE == "vn" then
        txtFighting:setScale(0.8)
    end
    for i= 1, #tProperty do
        local txtProperty = WZUIFreeTextBox:create()
        txtProperty:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
        txtProperty:setRelativePosition(GlobalMethod:ccp(ptX, 0.79 - 0.115 * (i - 1)))
        txtProperty:setMaxWidth(200)
        txtProperty:setShowText(string.format(sFormat, ATTR_TITLE[tProperty[i][1]], tProperty[i][2]))
        conTips:addChild(txtProperty)
        if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
            txtProperty:setScale(0.7)
            txtProperty:setMaxWidth(400)
        elseif ProjConfig.LANGUAGE == "vn" then
            txtProperty:setScale(0.8)
        end
    end
    parentNode:addChild(conTips, 2, 999)
end

--@brief    某一卡牌的战斗力加成
function WndCard:_cardFighting(tData)
    -- body

    local txtAddFighting = GetElement(self.m_root, "txtAddFighting_WndCard", WZUILabelAtlasFont)

    local nCardFighting = self:_caculateFighting(tData.property)

    txtAddFighting:setText(nCardFighting)
end

--@brief    显示卡牌
function WndCard:_drawCard()
    -- body
    self:_initCardList()
    if self.m_tActiveCardList and #self.m_tActiveCardList ~= 0 then
        self:_showCardDetail(self.m_tActiveCardList[1])
    elseif self.m_tUnActiveCardList and #self.m_tUnActiveCardList ~= 0 then
        self:_showCardDetail(self.m_tUnActiveCardList[1])
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------------
function WndCard:_adaptLanguage_en(  )
    local txt = GetElement(self.m_root,"txtQualityValue_WndCard",WZUILabelTTF)
    txt:setRelativePosition(GlobalMethod:ccp(0.705,0.88))
    txt:setFontSize(16)

    local txtUpgradeCost = GetElement(self.m_root, "txtUpgradeCost_WndCard", WZUILabelTTF)
    local txtUpgradeWord = GetElement(self.m_root, "txtUpgradeWord_WndCard", WZUILabelTTF)
    if txtUpgradeWord then
        txtUpgradeWord:setFontSize(20)
        txtUpgradeWord:setRelativePosition(GlobalMethod:ccp(0.98, 0.5))
        txtUpgradeCost:setFontSize(20)
    end

    GetElement(self.m_root,"txtCardName_WndCard",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtCardQuality_WndCard",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtCardLevel_WndCard",WZUILabelTTF):setFontSize(18)
    
end

function WndCard:_adaptLanguage_pt(  )
    local txt = GetElement(self.m_root,"txtQualityValue_WndCard",WZUILabelTTF)
    txt:setRelativePosition(GlobalMethod:ccp(0.7,0.88))
    txt:setFontSize(16)

    local txtCardName = GetElement(self.m_root,"txtCardName_WndCard",WZUILabelTTF)
    txtCardName:setFontSize(12)
    txtCardName:setRelativePosition(GlobalMethod:ccp(0.45,0.94))

    GetElement(self.m_root,"txtUpgradeWord_WndCard",WZUILabelTTF):setFontSize(20)
    local txtCardQuality = GetElement(self.m_root,"txtCardQuality_WndCard",WZUILabelTTF)
    txtCardQuality:setFontSize(14)
    txtCardQuality:setRelativePosition(GlobalMethod:ccp(0.45,0.88))
    GetElement(self.m_root,"txtCardLevel_WndCard",WZUILabelTTF):setFontSize(18)
    local txtOpenTime = GetElement(self.m_root,"txtOpenTime_WndCard",WZUIFreeTextBox)
    txtOpenTime:setScale(0.6)
    txtOpenTime:setMaxWidth(400)
    local txtMaxLevel = GetElement(self.m_root,"txtMaxLevel_WndCard",WZUILabelTTF)
    txtMaxLevel:setDimensions(GlobalMethod:CCSize(150,0))
    txtMaxLevel:setFontSize(18)
end

function WndCard:_adaptLanguage_vn(  )
    -- local txtRefreshTime = GetElement(self.m_root,"txtRefreshTime_WndCard",WZUIFreeTextBox)
    -- txtRefreshTime:setMaxWidth(400)
    local txt = GetElement(self.m_root,"txtQualityValue_WndCard",WZUILabelTTF)
    txt:setRelativePosition(GlobalMethod:ccp(0.72,0.88))
    txt:setFontSize(16)
    GetElement(self.m_root,"txtCardName_WndCard",WZUILabelTTF):setFontSize(14)
    GetElement(self.m_root,"txtCardQuality_WndCard",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtUpgradeWord_WndCard",WZUILabelTTF):setFontSize(20)
end

function WndCard:_adaptLanguage_tr(  )
    local txt = GetElement(self.m_root,"txtQualityValue_WndCard",WZUILabelTTF)
    txt:setFontSize(16)

    GetElement(self.m_root,"txtCardName_WndCard",WZUILabelTTF):setFontSize(14)
    GetElement(self.m_root,"txtUpgradeWord_WndCard",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtUpgradeCost_WndCard",WZUILabelTTF):setFontSize(20)
    local txtCardQuality = GetElement(self.m_root,"txtCardQuality_WndCard",WZUILabelTTF)
    txtCardQuality:setFontSize(14)

    GetElement(self.m_root,"txtCardLevel_WndCard",WZUILabelTTF):setFontSize(18)
    
    local txtMaxLevel = GetElement(self.m_root,"txtMaxLevel_WndCard",WZUILabelTTF)
    txtMaxLevel:setDimensions(GlobalMethod:CCSize(150,0))
    txtMaxLevel:setFontSize(18)

    GetElement(self.m_root,"txtLevelValue_WndCard",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.82))
end

function WndCard:_adaptLanguage_es(  )
    local txtCardName = GetElement(self.m_root,"txtCardName_WndCard",WZUILabelTTF)
    txtCardName:setScale(0.7)
    txtCardName:setDimensions(GlobalMethod:CCSize(200,0))
    txtCardName:setRelativePosition(GlobalMethod:ccp(0.44,0.94))

    local txtCardQuality = GetElement(self.m_root,"txtCardQuality_WndCard",WZUILabelTTF)
    txtCardQuality:setScale(0.8)
    txtCardQuality:setRelativePosition(GlobalMethod:ccp(0.48,0.871597))

    local txtQualityValue = GetElement(self.m_root,"txtQualityValue_WndCard",WZUILabelTTF)
    txtQualityValue:setScale(0.8)
    txtQualityValue:setRelativePosition(GlobalMethod:ccp(0.680405,0.871597))

    GetElement(self.m_root,"txtCardLevel_WndCard",WZUILabelTTF):setScale(0.8)

    local txtLevelValue = GetElement(self.m_root, "txtLevelValue_WndCard", WZUILabelTTF)
    txtLevelValue:setScale(0.8)
    txtLevelValue:setRelativePosition(GlobalMethod:ccp(0.612838,0.82))

    GetElement(self.m_root,"txtUpgradeWord_WndCard",WZUILabelTTF):setScale(0.6)
    GetElement(self.m_root,"txtUpgradeCost_WndCard",WZUILabelTTF):setScale(0.8)

    local txtOpenTime = GetElement(self.m_root,"txtOpenTime_WndCard",WZUIFreeTextBox)
    txtOpenTime:setScale(0.6)
    txtOpenTime:setMaxWidth(400)

    local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndCard",WZUILabelTTF)
    txtCheck1:setDimensions(GlobalMethod:CCSize(110,0))
    txtCheck1:setScale(0.7)

    local txtCheckSel1 = GetElement(self.m_root,"txtCheckSel1_WndCard",WZUILabelTTF)
    txtCheckSel1:setDimensions(GlobalMethod:CCSize(110,0))
    txtCheckSel1:setScale(0.7)

    local txtMaxLevel = GetElement(self.m_root,"txtMaxLevel_WndCard",WZUILabelTTF)
    txtMaxLevel:setDimensions(GlobalMethod:CCSize(150,0))
    txtMaxLevel:setFontSize(18)
end


--适配iphoneX
function WndCard:_AdaptationIphoneX()
    -- body
    WZLog("WndCard:_AdaptationIphoneX")
    if IsIphoneX() then
        local imgMidBg = GetElement(self.m_root,"imgMidBg_WndCard",WZUI9Image)
        imgMidBg:setScaleX(1.2)

        local imgCardBoxTopBg = GetElement(self.m_root,"imgCardBoxTopBg_WndCard",WZUI9Image)
        imgCardBoxTopBg:setScaleX(1.2)
    end
end
-------------------------------------语言适配End----------------------------------------------