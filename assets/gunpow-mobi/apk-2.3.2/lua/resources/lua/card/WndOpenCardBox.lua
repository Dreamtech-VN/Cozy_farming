--WndOpenCardBox.lua
--@brief	WndOpenCardBox的UI模块
--@date		2016/07/27
--@author	Tianxiang_Xu
--@note		打开卡套界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndOpenCardBox:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)

    TeachGroup1:endTeachStep({44,5})
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndOpenCardBox:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief    界面加载完成回调
function WndOpenCardBox:onEnterTransitionDidFinish(element)
    -- body
    self.m_nMaxCdTime = tonumber(CacheCenter:getGameParam().cardtime)
    WindowManagerAni:createAction(self.m_root,false,"onActionFinish",self)
end

--@brief    动画完成
function WndOpenCardBox:onActionFinish()
    --获取我已经通关的单人副本关卡
    self.m_nMySimpleCopyId = WndSingleCopy:getCommonTypeLastLevel()
    --设置定时器
    self.m_root:enableSchedule("caculateTime", 0.1)
    self:_update()

    local isFinish44, finishStep44 = TeachGroup1:isTeachFinish(44)
    WZLog("WndOpenCardBox:onActionFinish", tostring(isFinish44), finishStep44, CacheCenter:getPlayerInfo().level)
    if isFinish44 ~= true and finishStep44 >= 0 and CacheCenter:getPlayerInfo().level == 17 then
        TeachGroup1:startGroup({44,6,self.m_root})
    end
end

--@brief    点击关闭按钮回调
function WndOpenCardBox:onCloseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击开启卡套回调
function WndOpenCardBox:onClickOpen(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_tag = element:getTag()
    TeachGroup1:endTeachStep({44,6})
    if self.m_nMySimpleCopyId == nil then
        MsgBoxManager:showTipBox(LocalStrings.CARD_TEXT30)
        return
    end
    --开启次数不足
    if self.m_nLeftOpenTimes <= 0 and self.m_tData.basicInfo.sub_type == 0 then
        MsgBoxManager:showTipBox(LocalStrings.CARD_TEXT18)
        return 
    end
    if self.m_bIsOpening then return end 
    --cd时间阶段，提示钻石消除CD时间
    local nNextCdTime = self.m_nTime + self.m_tData.cd_time
    if nNextCdTime > self.m_nMaxCdTime then
        if self.m_tData.cd_time > 0 then
            if not self:clickTimeSpeed() then 
                local price = tonumber(CacheCenter:getGameParam()["opencardsetprice"])
                local diamondNum = math.ceil(self.m_nTime / 60) * price
                MsgBoxManager:showConfirmBox(string.format(LocalStrings.CARD_TEXT19,diamondNum), self,self.clickSure)
                return 
            end

            return 
        end
    end
    --发送打开卡套协议
    self:sureUseDiamondInstead()
end

--@brief    点击确认消除cd时间回调
function WndOpenCardBox:clickSure()
    -- body
    local price = tonumber(CacheCenter:getGameParam()["opencardsetprice"])
    local diamondNum = math.ceil(self.m_nTime / 60) * price
    if CacheCenter:getGameParam().isUseTicket == "0" then
        if not JudgeMoneyIsEnough(70, diamondNum, LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, nil, Chat_Channel_OpenCardSet, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
            return 
        end
    else
        if not JudgeMoneyIsEnough(1, diamondNum, LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, nil, Chat_Channel_OpenCardSet, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
            return 
        end
    end

    self:sureUseDiamondInstead()
end

--@brief    确认用钻石代替礼券开启卡套回调
function WndOpenCardBox:sureUseDiamondInstead()
    -- body
    --发送打开卡套协议
    self.m_nTempLocalTime = WZThread:getUTickCount()
    self:_createLoading()
    self:setOpenTab(true)
    ProtocolProcessorCard:send_CARD_OpenCardSet(self.m_tData.item_id,self.m_tag)
end

--@brief    打开卡套返回
function WndOpenCardBox:openCardBoxOK(code, itemId, itemNum, cdTime, openNum)
    -- body
    WZLog("WndOpenCardBox:openCardBoxOK", code, cdTime, openNum, Serialize(itemId), Serialize(itemNum))
    self:_stopLoading()
    if code == 0 then --打开卡套成功
        if #itemId == 1 and itemId[1] == 26 then
            for i = 1, #itemId do
                if itemId[i] == 26 then
                    MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_TEXT28, itemNum[i]))
                    break
                end
            end
        end
        self.m_nTime = cdTime 
        local totalOpenNum = tonumber(CacheCenter:getGameParam()["opencardsettimes"])
        self.m_nLeftOpenTimes = totalOpenNum - openNum
        --刷新时间
        self:_refreshTime()
        --刷新数据
        local itemData = GDatatab_item["id_"..self.m_tData.item_id]
        local isOrange = 0
        if itemData.main_type == 16 and itemData.sub_type == 1 and itemData.quality == 4 then
            isOrange = openNum
        end
        WndCard:refreshCardDataAndInfo(CopyTable(itemId), CopyTable(itemNum), cdTime, openNum, self.m_tData, self.m_bacth, isOrange)
        local  bShowReward = false
        for i = 1, #itemId do
            if itemId[i] ~= 26 then
                bShowReward = true
                break 
            end
        end
        if bShowReward then
            WndCardRewardShow:showById(CopyTable(itemId),CopyTable(itemNum))
        end
        if self.m_tData.number == 0 then
            WindowManager:removeWindow(self.m_root, self, true)
        else
        end
    elseif code == 1 then
        MsgBoxManager:showTipBox(LocalStrings.SEND_PROPOSAL_LETTER2)
    elseif code == 2 then
        MsgBoxManager:showTipBox(LocalStrings.CARD_TEXT18)
    end

    self:setOpenTab(false)
end

--@brief    计时器
function WndOpenCardBox:caculateTime(element, detal)
    -- body
    self.m_nCaculateTime = self.m_nCaculateTime + detal 
    if self.m_nCaculateTime >= 1 then
        if self.m_nTime > 0 then
            self.m_nTime = self.m_nTime - 1 
            self:_refreshTime()
        end
        self.m_nCaculateTime = self.m_nCaculateTime - 1 
    end
end

--@brief    点击加速按钮回调
function WndOpenCardBox:clickTimeSpeed()
    -- body
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
        return true
    end

    return false 
end

--@brief    确认用钻石代替礼券开启卡套回调
function WndOpenCardBox:useTimeCoin()
    -- body
    --发送打开卡套协议
    self:_createLoading()
    ProtocolProcessorCard:send_CARD_SpeedUp(self.m_tData.item_id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新界面信息
function WndOpenCardBox:_update()
    if not self.m_tData then return end

    -- body
    local txtBtnText = GetElement(self.m_root, "txtBtnText_WndOpenCardBox", WZUILabelTTF)
    local imgCardBoxIcon = GetElement(self.m_root, "imgCardBoxIcon_WndOpenCardBox", WZUIImage)
    local imgSection = GetElement(self.m_root, "imgSection_WndOpenCardBox", WZUIImage)
    local txtBtnText1 = GetElement(self.m_root,"txtBtnText1_WndOpenCardBox",WZUILabelTTF)
    if self.m_tData.basicInfo.sub_type == 1 then  --卡包
        txtBtnText:setText(LocalStrings.CARD_TEXT38)
        --图标
        imgCardBoxIcon:setFile(self.m_tData.icon)
        imgCardBoxIcon:setScale(0.9)
        imgSection:setVisible(false)
    else
        txtBtnText:setText(LocalStrings.CARD_TEXT38)
        --图标
        imgCardBoxIcon:setFile(string.format("ui/card/kapai_icon_book%d.png", self.m_tData.basicInfo.quality))
        imgCardBoxIcon:setScale(0.9)
        --章节
        imgSection:setFile(string.format("ui/card/kapai_icon_zj%d.png", self.m_tData.section))
    end
    
    -- self.m_nLeftOpenTimes
    WZLog("刷新界面信息",WndCard.m_nTime,Serialize(self.m_tData),self.m_nLeftOpenTimes)
    local openTime = 1
    local leftTime = self.m_nMaxCdTime - self.m_nTime
    if self.m_tData.cd_time == 0 then 
        openTime = self.m_tData.number 
        self.m_bacth = 0
    else
        self.m_bacth = 1
        for i = 1,100 do
            if self.m_tData.cd_time * i == leftTime then
                openTime = i 
                break
            elseif self.m_tData.cd_time * i > leftTime then
                openTime = i - 1
                break
            end
        end
        openTime = math.min(openTime,self.m_nLeftOpenTimes)
        openTime = math.min(openTime,self.m_tData.number)
        if openTime == 0 then openTime = 1 end
    end
    self.m_maxNum = openTime
    txtBtnText1:setText(string.format(LocalStrings.CARD_TEXT39,openTime))


    --CD时间
    self:_refreshTime()
    --卡套的名字
    local txtCardBoxName = GetElement(self.m_root, "txtCardBoxName_WndOpenCardBox", WZUILabelTTF)
    txtCardBoxName:setText(self.m_tData.basicInfo.name)
    txtCardBoxName:setColor(QUALITYCOLOR[self.m_tData.basicInfo.quality])
    --获得物品的信息
    local txtFreeText1 = GetElement(self.m_root, "txtFreeText1_WndOpenCardBox", WZUIFreeTextBox)
    local txtFreeText2 = GetElement(self.m_root, "txtFreeText2_WndOpenCardBox", WZUIFreeTextBox)
    local txtFreeText5 = GetElement(self.m_root, "txtFreeText5_WndOpenCardBox", WZUIFreeTextBox)
    local sContent1 = string.format(LocalStrings.CARD_TEXT6, self.m_tData.coin_range[1][1], self.m_tData.coin_range[1][2])
    txtFreeText1:setShowText(sContent1)
    local sContent2 = string.format(LocalStrings.CARD_TEXT7, "ui/common/common_icon_lk.png", self.m_tData.card_range[1][1], self.m_tData.card_range[1][2])
    txtFreeText2:setShowText(sContent2)
    local sCDTime = returnToTimeFormat(self.m_tData.cd_time)
    local sContent5 = string.format(LocalStrings.CARD_TEXT8, sCDTime)
    txtFreeText5:setShowText(sContent5)

    local txtFreeText3 = GetElement(self.m_root, "txtFreeText3_WndOpenCardBox", WZUIFreeTextBox)
    if self.m_tData.at_least_2 and type(self.m_tData.at_least_2) == "table" and self.m_tData.at_least_2[1][1] > 0 then
        local sContent3 = string.format(LocalStrings.CARD_TEXT12, "ui/common/common_icon_zk02.png", self.m_tData.at_least_2[1][1])
        txtFreeText3:setShowText(sContent3)
    end
    local txtFreeText4 = GetElement(self.m_root, "txtFreeText4_WndOpenCardBox", WZUIFreeTextBox)
    if self.m_tData.at_least_3 and type(self.m_tData.at_least_3) == "table" and self.m_tData.at_least_3[1][1] > 0 then
        local sContent4 = string.format(LocalStrings.CARD_TEXT13, "ui/common/common_icon_zk02.png", self.m_tData.at_least_3[1][1])
        txtFreeText4:setShowText(sContent4)
    end

    if self.m_tData.at_least_2[1][1] == 0 and self.m_tData.at_least_3[1][1] == 0 then
        txtCardBoxName:setRelativePosition(GlobalMethod:ccp(0,0.82))
        txtFreeText1:setRelativePosition(GlobalMethod:ccp(0,0.64))
        txtFreeText2:setRelativePosition(GlobalMethod:ccp(0,0.46))
        txtFreeText3:setVisible(false)
        txtFreeText4:setVisible(false)
        txtFreeText5:setRelativePosition(GlobalMethod:ccp(-0.30,0.10))
    elseif self.m_tData.at_least_2[1][1] ~= 0 and self.m_tData.at_least_3[1][1] == 0 then
        txtCardBoxName:setRelativePosition(GlobalMethod:ccp(0,0.82))
        txtFreeText1:setRelativePosition(GlobalMethod:ccp(0,0.64))
        txtFreeText2:setRelativePosition(GlobalMethod:ccp(0,0.46))
        txtFreeText3:setRelativePosition(GlobalMethod:ccp(0,0.28))
        txtFreeText5:setRelativePosition(GlobalMethod:ccp(-0.30,0.10))
    elseif self.m_tData.at_least_2[1][1] == 0 and self.m_tData.at_least_3[1][1] ~= 0 then
        txtCardBoxName:setRelativePosition(GlobalMethod:ccp(0,0.82))
        txtFreeText1:setRelativePosition(GlobalMethod:ccp(0,0.64))
        txtFreeText2:setRelativePosition(GlobalMethod:ccp(0,0.46))
        txtFreeText4:setRelativePosition(GlobalMethod:ccp(0,0.28))
        txtFreeText5:setRelativePosition(GlobalMethod:ccp(-0.30,0.10))
    end
    --有几率获得的卡牌列表
    WndOpenCardBox:_createCardList()
end

--@brief    计时更新时间显示
function WndOpenCardBox:_refreshTime()
    -- body
    if self.m_root == nil then return end 
    --CD时间
    if self.m_nTime == 0 then
        GetElement(self.m_root, "conCDTime_WndOpenCardBox", WZUIContainer):setVisible(false)
    else
        GetElement(self.m_root, "conCDTime_WndOpenCardBox", WZUIContainer):setVisible(false)
    end
    local txtTime = GetElement(self.m_root, "txtTime_WndOpenCardBox", WZUILabelTTF)
    local sTimeContent = returnToTimeFormat(self.m_nTime)
    txtTime:setText(sTimeContent)
    self:_refreshBtnText()
end

--@brief    批量打开卡套的显示刷新
function WndOpenCardBox:_refreshBtnText()
    -- body
    local txtBtnText1 = GetElement(self.m_root,"txtBtnText1_WndOpenCardBox",WZUILabelTTF)
    local leftTime = self.m_nMaxCdTime - self.m_nTime
    if self.m_tData.cd_time == 0 then 
        openTime = self.m_tData.number 
        self.m_bacth = 0
    else
        self.m_bacth = 1
        for i = 1,100 do
            if self.m_tData.cd_time * i == leftTime then
                openTime = i 
                break
            elseif self.m_tData.cd_time * i > leftTime then
                openTime = i - 1
                break
            end
        end
        openTime = math.min(openTime,self.m_nLeftOpenTimes)
        openTime = math.min(openTime,self.m_tData.number)
        if openTime == 0 then openTime = 1 end
    end
    self.m_maxNum = openTime
    txtBtnText1:setText(string.format(LocalStrings.CARD_TEXT39,openTime))
end

--@brief    有可能获得的卡牌
function WndOpenCardBox:_createCardList()
    -- body
    if self.m_nMySimpleCopyId == nil then
        local  conCardList = GetElement(self.m_root, "conCardList_WndOpenCardBox", WZUIContainer)
        ShowPanelNullTip( conCardList, LocalStrings.CARD_TEXT29)

        if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt"
            or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "vn" then
            ShowPanelNullTip(conCardList,LocalStrings.CARD_TEXT29,nil,nil,nil,nil,GlobalMethod:CCSize(300,0))
        end

        return
    end
    local flconCardList = GetElement(self.m_root, "flconCardList_WndOpenCardBox", WZUIFreeListContainer)
    flconCardList:removeAll()

    local tCardList = {}
    local tRule
    if type(self.m_tData.rule) ~= "string" then
        tRule = SplitStringWithSeparator(tostring(self.m_tData.rule),"#")
    else
        tRule = SplitStringWithSeparator(self.m_tData.rule,"#")
    end

    WZLog("WndOpenCardBox:_createCardList", type(self.m_nMySimpleCopyId))
    
    for idx, value in pairs(GDatatab_card_treasury) do
        for j = 1, #tRule do
            if value.reward_id == tonumber(tRule[j]) then
                local id = self:_getCardId(value.item_id, 1)
                local tItem = CopyTable(GDatatab_card_property["id_" .. id])
                tItem.item_id = value.item_id
                tItem.curNum = 0
                tItem.state = 1
                tItem.useType = 8 
                tItem.bIsNew = false
                tItem.level = 0
                WZLog("WndOpenCardBox:_createCardList", tItem.item_id)
                tItem.basicInfo = CopyTable(GDatatab_item["id_" .. tItem.item_id])
                tItem.upgradeNum = tItem.cost[2][2]

                if self.m_tData.copy ~= -1 and self.m_tData.basicInfo.sub_type == 0 then    --卡套
                    if value.copy == self.m_tData.copy then
                        table.insert(tCardList, tItem)
                    end
                else 
                    if self.m_nMySimpleCopyId then
                        if value.copy <= self.m_nMySimpleCopyId then
                            table.insert(tCardList, tItem)
                        end
                    end
                end
                
            end
        end
    end

    --小于5个时候，不可拖动列表

    -- if #tCardList <= 4 then
    --     flconCardList:setTouchEnable(false)
    --     flconCardList:setTouchContainerEnable(false)
    -- end

    table.sort(tCardList, sortActiveCard)
    
    for i = 1, #tCardList do
        local celElement, tNewObj = CellCardItem:createElementOther()
        if celElement and tNewObj then
            tNewObj:setDataOther(tCardList[i], GlobalMethod:ccp(0.5,0.45))
            celElement:setTag(i - 1)
            celElement = WZUIContainer:luaTo(celElement)
            celElement:setAbsContentSize(GlobalMethod:CCSize(126,142))
            celElement:setScale(0.8)
            celElement:setRelativeSize(GlobalMethod:CCSize(116/325, 1))
            
            flconCardList:pushBack(celElement)
        end
    end

    -- if #tCardList > 4 then
        flconCardList:getMoveElement():setPositionX(flconCardList:getMaxPosition().x)
    -- end
end
-------------------------------------私有方法模块End----------------------------------------

------------------------------------------语言适配Begin------------------------------------------
function WndOpenCardBox:_adaptLanguage_en(  )
    local txtBtnText = GetElement(self.m_root,"txtBtnText_WndOpenCardBox",WZUILabelTTF)
    txtBtnText:setFontSize(18)
    txtBtnText:setDimensions(GlobalMethod:CCSize(110,0))
    GetElement(self.m_root,"txtFreeText3_WndOpenCardBox",WZUIFreeTextBox):setMaxWidth(400)
    GetElement(self.m_root,"txtFreeText4_WndOpenCardBox",WZUIFreeTextBox):setMaxWidth(400)

    GetElement(self.m_root,"txtCardBoxName_WndOpenCardBox",WZUILabelTTF):setScale(0.7)
end

function WndOpenCardBox:_adaptLanguage_pt(  )
    local txtBtnText = GetElement(self.m_root,"txtBtnText_WndOpenCardBox",WZUILabelTTF)
    txtBtnText:setFontSize(20)
    txtBtnText:setDimensions(GlobalMethod:CCSize(120,0))
    GetElement(self.m_root,"txtFreeText3_WndOpenCardBox",WZUIFreeTextBox):setMaxWidth(400)
    GetElement(self.m_root,"txtFreeText4_WndOpenCardBox",WZUIFreeTextBox):setMaxWidth(400)
    GetElement(self.m_root,"txtCardBoxName_WndOpenCardBox",WZUILabelTTF):setFontSize(18)
end

function WndOpenCardBox:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtCardBoxName_WndOpenCardBox",WZUILabelTTF):setScale(0.8)
    local txtFreeText1 = GetElement(self.m_root,"txtFreeText1_WndOpenCardBox",WZUIFreeTextBox)
    txtFreeText1:setScale(0.8)
    local txtFreeText2 = GetElement(self.m_root,"txtFreeText2_WndOpenCardBox",WZUIFreeTextBox)
    txtFreeText2:setScale(0.8)
    local txtFreeText3 = GetElement(self.m_root,"txtFreeText3_WndOpenCardBox",WZUIFreeTextBox)
    txtFreeText3:setScale(0.65)
    txtFreeText3:setMaxWidth(400)
    local txtFreeText4 = GetElement(self.m_root,"txtFreeText4_WndOpenCardBox",WZUIFreeTextBox)
    txtFreeText4:setScale(0.65)
    txtFreeText4:setMaxWidth(400)
end

function WndOpenCardBox:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtFreeText3_WndOpenCardBox",WZUIFreeTextBox):setMaxWidth(400)
    GetElement(self.m_root,"txtFreeText4_WndOpenCardBox",WZUIFreeTextBox):setMaxWidth(400)
    local txtBtnText = GetElement(self.m_root,"txtBtnText_WndOpenCardBox",WZUILabelTTF)
    txtBtnText:setFontSize(18)
    txtBtnText:setDimensions(GlobalMethod:CCSize(110,0))
    
    GetElement(self.m_root,"txtCardBoxName_WndOpenCardBox",WZUILabelTTF):setScale(0.7)
end

function WndOpenCardBox:_adaptLanguage_es(  )
    local txtBtnText = GetElement(self.m_root,"txtBtnText_WndOpenCardBox",WZUILabelTTF)
    txtBtnText:setFontSize(16)
    txtBtnText:setDimensions(GlobalMethod:CCSize(130,0))

    local txtCardName = GetElement(self.m_root,"txtCardBoxName_WndOpenCardBox",WZUILabelTTF)
    txtCardName:setFontSize(14)
    txtCardName:setDimensions(GlobalMethod:CCSize(280,0))
    txtCardName:setRelativePosition(GlobalMethod:ccp(0,0.93))
    txtCardName:setAlignment(kCCTextAlignmentLeft)

    local txtFree1 = GetElement(self.m_root,"txtFreeText1_WndOpenCardBox",WZUIFreeTextBox)
    txtFree1:setMaxWidth(500)
    txtFree1:setScale(0.65)
    local txtFree2 = GetElement(self.m_root,"txtFreeText2_WndOpenCardBox",WZUIFreeTextBox)
    txtFree2:setMaxWidth(500)
    txtFree2:setScale(0.65)
    local txtFree3 = GetElement(self.m_root,"txtFreeText3_WndOpenCardBox",WZUIFreeTextBox)
    txtFree3:setMaxWidth(500)
    txtFree3:setScale(0.65)
    local txtFree4 = GetElement(self.m_root,"txtFreeText4_WndOpenCardBox",WZUIFreeTextBox)
    txtFree4:setMaxWidth(500)
    txtFree4:setScale(0.65)
    local txtFree5 = GetElement(self.m_root,"txtFreeText5_WndOpenCardBox",WZUIFreeTextBox)
    txtFree5:setMaxWidth(500)
    txtFree5:setScale(0.65)
end

function WndOpenCardBox:_adaptLanguage_ug(  )
    local txtBtnText = GetElement(self.m_root,"txtBtnText_WndOpenCardBox",WZUILabelTTF)
    txtBtnText:setScale(0.55)
    txtBtnText:setDimensions(GlobalMethod:CCSize(240,0))
    local txtFreeText1 = GetElement(self.m_root,"txtFreeText1_WndOpenCardBox",WZUIFreeTextBox)
    txtFreeText1:setScale(0.7)
    txtFreeText1:setMaxWidth(400)
    local txtFreeText2 = GetElement(self.m_root,"txtFreeText2_WndOpenCardBox",WZUIFreeTextBox)
    txtFreeText2:setScale(0.7)
    txtFreeText2:setMaxWidth(400)
    local txtFreeText3 = GetElement(self.m_root,"txtFreeText3_WndOpenCardBox",WZUIFreeTextBox)
    txtFreeText3:setScale(0.7)
    txtFreeText3:setMaxWidth(400)
    local txtFreeText4 = GetElement(self.m_root,"txtFreeText4_WndOpenCardBox",WZUIFreeTextBox)
    txtFreeText4:setScale(0.7)
    txtFreeText4:setMaxWidth(400)
    local txtFreeText5 = GetElement(self.m_root,"txtFreeText5_WndOpenCardBox",WZUIFreeTextBox)
    txtFreeText5:setScale(0.7)
    txtFreeText5:setMaxWidth(400)

    GetElement(self.m_root,"txtCardBoxName_WndOpenCardBox",WZUILabelTTF):setScale(0.7)
end
------------------------------------------语言适配End--------------------------------------------