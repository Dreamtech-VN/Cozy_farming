--WndVipGift.lua
--@brief	WndVipGift的UI模块
--@date		2017-1-13
--@author	mjf
--@note		VIP模块

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndVipGift:onEnter(element)
    self.m_root = element
end

--@brief	打开加载动画
function WndVipGift:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
    AdaptLanguage(self)
end

function WndVipGift:onTouchBegan()
	WndItemInfo:onCloseClick()
end

--@brief	窗口动画完成回调
function WndVipGift:actionCallback(elem,data)
    if self.m_nType == 2 then 
        local string = string.sub(self.m_sPushInfo[1],2,-2) 
        local gType = SplitStringWithSeparator(string,",")[1]
        local id = SplitStringWithSeparator(string,",")[2]
        local giftType = tonumber(gType)
        local item_id = tonumber(id)

        self.m_tData = {}
        self.m_tData.id = item_id
        self.m_tData.leftTimes = self.m_Count[1] 
        self.m_tData.giftType = giftType
        self.m_tData.limitType = 1
        self.m_tData.needVipLv = 0
        if giftType == 1 then 
            local vipData = GDatatab_recharge["id_" .. item_id]
            self.m_tData.name = GDatatab_item["id_" .. vipData.item_id].name 
            self.m_tData.itemId = vipData.item_id
        else
            local tShopData = CacheCenter:getShopGoodData(item_id)
            self.m_tData.name = GDatatab_item["id_" .. tShopData.shopItemId].name 
            self.m_tData.itemId = tShopData.shopItemId
        end
    end
    self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndVipGift:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end
-- 点击领取回调
function WndVipGift:onBuy(element)

    if tostring(ProjConfig:getChannelId()) == "8888" or tostring(ProjConfig:getChannelId()) == "53" or tostring(ProjConfig:getChannelId()) == "75" or tostring(ProjConfig:getChannelId()) == "275" or tostring(ProjConfig:getChannelId()) == "68" or tostring(ProjConfig:getChannelId()) == "10" then
        return
    end

    WZLog("WndVipGift:onBuy", self.m_nType, self.m_tData.leftTimes)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local curData = self.m_tData

    if self.m_nType == 2 then 
        if self.m_tData.leftTimes == 0 then
            MsgBoxManager:showTipBox(LocalStrings.NEWACTIVITY_TEXT3)
            return 
        end
        --背包已满提示
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        if self.m_tData.giftType == 1 then 
            self:_createLoading()
            PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
            local sdkData = {}
            local vipData = GDatatab_recharge["id_" .. self.m_tData.id]
            sdkData.id = self.m_tData.id
            sdkData.price = vipData.price
            sdkData.productName = vipData.name
            sdkData.payCode = vipData.pay_code_id
            sdkData.quantifier = LocalStrings.SHOP_IND
            sdkData.number = "1"
            sdkData.giftNumber = "0"
            sdkData.productDesc = vipData.name

            PassportSdkManager:getOrderNum(sdkData)
        else
            local tShopData = CacheCenter:getShopGoodData(self.m_tData.id)
            if not JudgeMoneyIsEnough(tShopData.moneyId, tShopData.floorPrice, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamondInstead) then
                return 
            end

            self:sureToUseDiamondInstead()
        end
    else
        if WndNewActivity and WndNewActivity.m_root then --在周年活动里进行充值
            local playerInfo = CacheCenter:getPlayerInfo()
            local temp = WndNewActivity:bRecharge(curData.price,curData.ids,playerInfo.id)
            if not temp then
                return
            end
        end

        if curData.limitType ~= 0 and curData.leftTimes <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_COUNT)
            return
        end

        if curData.needVipLv > 0 and CacheCenter.m_tPlayerInfo.vipLevel < curData.needVipLv then
            MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_VIP)
            return
        end

        if WndVip:isCountry() then
            local code = WndVipCountry:getWayCode()
            WZLog("CellVipPowerList:onRechage", tostring(code), curData.price)
            if code == nil then
                local country, way = WndVipCountry:getCountry(), WndVipCountry:getWay()
                country = country == 0 and 1 or country
                way = way == 0 and 1 or way
                local wndVipCountry = WndVipCountry:createElement()
                WndVipCountry:setData(country, way, curData.price)
                WindowManager:addWindow(wndVipCountry,WndVipCountry,nil,false)
                return
            end
        end

        if (not WndVip:isCountry()) and (tonumber(ProjConfig.CHANNEL_ID) == 1042 or tonumber(ProjConfig.CHANNEL_ID) == 1044) and CacheCenter:getPlayerInfo().level >= 15 and PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID then

            local wndVipChoose = WndVipChoose:createElement()
            if wndVipChoose ~= nil then
                WindowManager:addWindow(wndVipChoose, WndVipChoose, false)
                WndVipChoose:setData(self.sdkData)
            end
        else
            WndVip:createLoadingUI()
            PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
            for k, v in pairs(self.sdkData) do
                WZLog("-----------sdk vip info------------",k,v)
            end

            if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID and (not WndVip:isCountry()) then
                PassportSdkManager.s_paymentId = "google"
                PassportSdkManager.s_paymentEmail = ""
            elseif PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID then
                -- PassportSdkManager.s_paymentId = WndVipCountry:getWayCode()
                -- PassportSdkManager.s_paymentEmail = ""

                local wndVipChooseMail = WndVipChooseMail:createElement()
                WindowManager:addWindow(wndVipChooseMail, WndVipChooseMail, false)
                WndVipChooseMail:setData(self.sdkData)
                WndVipChooseMail.pmId = WndVipCountry:getWayCode()
                WndVip:closeLoadingUI()
                return
            end
            --PassportSdkManager:getOrderNum(self.sdkData)
        end
        PassportSdkManager:getOrderNum(self.sdkData)
    end
end 

--@brief    确认用礼钻代替钻石购买礼包
function WndVipGift:sureToUseDiamondInstead()
    -- body
    local index = 0
    local count = WZLuaVector_int_:create()
    count:push(index)
    local mallId = WZLuaVector_int_:create()
    mallId:push(self.m_tData.id)

    self:_createLoading()
    ProtocolProcessorWndShop:send_MALL_BuyItems(count, mallId, 1, 0)
end

--@note     设置UI界面数据
function WndVipGift:_update()
    local curData = self.m_tData

    WZLog("WndVipGift:_update one", Serialize(curData))
    local txtName =  GetElement(self.m_root, "txtName_WndVipGift", WZUILabelTTF)
    txtName:setText(curData.name)

    local str = ""
    local str1 = LocalStrings.BUY_GIFT_LIMIT1
    local str2 = LocalStrings.BUY_GIFT_LIMIT2
    local str3 = ""
    local str4 = LocalStrings.BUY_GIFT_LIMIT4
    local str5 = LocalStrings.BUY_GIFT_LIMIT5
    local str6 = LocalStrings.BUY_GIFT_LIMIT6
    if curData.needVipLv > 0 then
        if curData.limitType == 0 then
            str = string.format(str6, curData.needVipLv)
        elseif curData.limitType == 1 then
            str = string.format(str4, curData.needVipLv, curData.leftTimes)
        elseif curData.limitType == 2 then
            str = string.format(str5, curData.needVipLv, curData.leftTimes)
        end
    elseif curData.needVipLv == 0 then
        if curData.limitType == 0 then
            str = str3
        elseif curData.limitType == 1 then
            str = string.format(str1, curData.leftTimes)
        elseif curData.limitType == 2 then
            str = string.format(str2, curData.leftTimes)
        end
    end

    local txtMoney = GetElement(self.m_root, "txtRemain_WndVipGift", WZUIFreeTextBox)
    if curData.leftTimes == -1 then
        sFormat = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]]
        txtMoney:setShowText(string.format(sFormat, LocalStrings.COMMUNITYINFO235)) 
    else
        txtMoney:setShowText(str)
    end

    --根据渠道号屏蔽限购
    local tabChannel = {1042,1043,1065,1066,1067,1069,1072,1074,1087,1089,1091,1094,1096,1097,1098,1101,1099,1102,1103,1104,1105}
    for _,v in ipairs(tabChannel) do
        if ProjConfig.CHANNEL_ID == v then
            txtMoney:setVisible(false)
        end
    end
    
    local txtName = GetElement(self.m_root, "txtBtn_WndVipGift", WZUILabelTTF)
    if self.m_nType == 2 then 
        self:_showBtnWord()
        self:_showCost()
        self:_showLeftTime()
        self.m_root:enableSchedule("_showLeftTime", 1)
    else
        txtName:setVisible(true)
        txtName:setText(string.format(LocalStrings.GIFT_PRICE, curData.showPrice))
    end

    WZLog("WndVipGift:_update two")
    self:_createItem()
    self:_createReward()
end

--@brief    按钮字
function WndVipGift:_showBtnWord()
    -- body
    local txtName = GetElement(self.m_root, "txtBtn_WndVipGift", WZUILabelTTF)
    local ftxtCurPrice = GetElement(self.m_root, "ftxtCurPrice_WndVipGift", WZUIFreeTextBox)
    local sFormat = [[<I Z="0.5" P="1">%s</I><T C="99,255,95" S="18" P="1" SC="0,72,3" SS="4" SE="1">%d</T><T C="99,255,95" S="18" P="1" SC="0,72,3" SS="4" SE="1">%s</T>]]
    if txtName then
        GetElement(self.m_root, "conBtn_WndVipGift", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.4))
        if self.m_tData.giftType == 1 then   --vip礼包
            txtName:setVisible(true)
            txtName:setUseSystemFont(true)
            local vipData = GDatatab_recharge["id_" .. self.m_tData.id]
            txtName:setText(vipData.unit .. LocalStrings.BUY)
        else
            txtName:setVisible(false)
            ftxtCurPrice:setVisible(true)
            local tShopData = CacheCenter:getShopGoodData(self.m_tData.id)
            local priceIcon = GDatatab_item["id_" .. tShopData.moneyId].icon
            local curPrice = math.ceil(tShopData.floorPrice * (tShopData.discount/10000))
            ftxtCurPrice:setShowText(string.format(sFormat, priceIcon, curPrice, LocalStrings.BUY))
        end
    end
end

--@brief    消耗
function WndVipGift:_showCost()
    -- body
    WZLog("WndVipGift:_showCost", Serialize(self.m_sOriginPrice))
    GetElement(self.m_root, "imgLine_WndVipGift", WZUIImage):setVisible(true)
    local ftxtPrice = GetElement(self.m_root, "ftxtPrice_WndVipGift", WZUIFreeTextBox)
    local txtOriginPrice = GetElement(self.m_root, "txtOriginPrice_WndVipGift", WZUILabelTTF)
    local sFormat = [[<T C="255,236,193" S="18" P="1" SC="105,65,46" SS="4" SE="1">%s:</T><I Z="0.5" P="1">%s</I><T C="255,236,193" S="18" P="1" SC="105,65,46" SS="4" SE="1">%d</T>]]
    if ftxtPrice then
        local string = string.sub(self.m_sOriginPrice[1],2,-2) 
        local costId = SplitStringWithSeparator(string,",")[1]
        local num = SplitStringWithSeparator(string,",")[2]
        if self.m_tData.giftType == 1 then 
            ftxtPrice:setVisible(false)
            txtOriginPrice:setVisible(true)
            txtOriginPrice:setUseSystemFont(true)
            txtOriginPrice:setText(LocalStrings.LIMITE_BUY_ORIGINPRICE .. ":" .. num)
        else
            txtOriginPrice:setVisible(false)
            ftxtPrice:setVisible(true)
            local priceIcon = GDatatab_item["id_" .. costId].icon
            ftxtPrice:setShowText(string.format(sFormat, LocalStrings.LIMITE_BUY_ORIGINPRICE, priceIcon, num))
        end
    end
end

--@brief    限时礼包剩余时间
function WndVipGift:_showLeftTime()
    -- body
    local nCurTime = SystemTime:getServerTime()
    if nCurTime > self.m_nEndTime[1] then 
        self.m_root:disableSchedule()
        return 
    end
    local nLeftSeconds = self.m_nEndTime[1] - nCurTime 
    local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_WndVipGift", WZUIFreeTextBox)

    if ftxtLeftTime then 
        ftxtLeftTime:setVisible(true)
        if nLeftSeconds >= 0 then 
            local hours,minutes,seconds
            hours = math.floor(nLeftSeconds/3600)
            minutes = math.floor((nLeftSeconds%3600)/60)
            seconds = nLeftSeconds%60
            ftxtLeftTime:setShowText(string.format(LocalStrings.VIPWEEK_PACKAGE4, hours, minutes, seconds))
        else
            self.m_root:disableSchedule()
        end
    end
end

--@brief    创建物品
function WndVipGift:_createItem()
    local curData = self.m_tData

    local key = "id_"..curData.itemId
    local tData = GDatatab_item[key]
    local name = tData.name
    local icon = tData.icon
    local quality = tData.quality
    local itemInfo = {name=name,icon=icon,lastTime="",lastNum="",quality=quality,basicInfo=CopyTable(tData)}

    WZLog("WndVipGift:_createItem one",Serialize(tData))

    local txtName =  GetElement(self.m_root, "txtDesc_WndVipGift", WZUILabelTTF)
    txtName:setText(tData.desc)

    local txtName2 =  GetElement(self.m_root, "txtName2_WndVipGift", WZUILabelTTF)
    if tData.sub_type == 0 then
        txtName2:setText(LocalStrings.BAGTIP7)
    elseif tData.sub_type == 1 then
        txtName2:setText(LocalStrings.BAGTIP8)
    end

    local con = GetElement(self.m_root,"conItem",WZUIContainer)
    con:removeAllChildrenWithCleanup(true)
    local celElement,tLuaObj = CellGoodItem:createElement()
    if celElement ~= nil then 
        celElement = WZUIContainer:luaTo(celElement)
        tLuaObj:setCellGoodItem(itemInfo, 16)
        tLuaObj:setItemClickFun(self, self.onClickItem)
        celElement:setScale(1)
        con:addChild(celElement)
		--if tLuaObj.m_imgItem ~= nil then
		--	tLuaObj.m_imgItem:setScale(0.5)
		--end
    end

end

--@brief    更新vip奖励
function WndVipGift:_createReward()
    local curData = self.m_tData
    local tab = GetElement(self.m_root,"tabReward_WndVipGift",WZUITableContainer)
    tab:setVisible(true)
    tab:cleanTable()

    local sex = CacheCenter:getPlayerInfo().sex
    local giftList = {}
    local sexIndex = {"man_item_id","woman_item_id"}
    for k,v in pairs(GDatatab_gifts) do
        if v.item_id ==  curData.itemId then
            local temp = {}
            temp.id = v[sexIndex[sex+1]]
            temp.count = v["count"]
            table.insert(giftList,temp)
        end
    end

    for i = 1, #giftList do
        local curData = giftList[i]
        local key = "id_"..curData.id
        local tData = GDatatab_item[key]
        local name = tData.name
        local icon = tData.icon
        local quality = tData.quality
        local itemInfo = {name=name,icon=icon,lastTime=curData.count,lastNum=curData.count,quality=quality,basicInfo=CopyTable(tData)}

        local cell,tcell = CellGoodItem:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setCellGoodItem(itemInfo, 16)
        tcell:setItemClickFun(self, self.onClickItem)
    end
end

function WndVipGift:onClickItem(tItem, nTag, tData)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_root == nil then return end
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end
-------------------------------------公有方法模块End----------------------------------------
-- 关闭
function WndVipGift:onTempClose()
    WZLog("WndVipGift:onTempClose one")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    if self.m_nType == 2 then 
        self:_showCloseAniForNewUserPackage()
    else
        WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
    end
end

--@brief    新手礼包关闭展示关闭动画
function WndVipGift:_showCloseAniForNewUserPackage()
    -- body
    local nodeParent, relationPosition
    if self.m_nFuncId == 11 and WndEquipmentLottery.m_root then 
        nodeParent = GetElement(WndEquipmentLottery.m_root, "conMiddle_WndEquipmentLottery", WZUIContainer)
    elseif self.m_nFuncId == 27 and WndPets.m_root then
        nodeParent = GetElement(WndPets.m_root,"conPetLeft_WndPets",WZUIContainer)
    elseif self.m_nFuncId == 41 and WndImproveStrengthen.m_root then
        nodeParent = GetElement(WndImproveStrengthen.m_root, "conTop_WndImproveStrengthen", WZUIContainer)
    elseif self.m_nFuncId == 43 and WndGemMountingStrengthen.m_root then
        nodeParent = WndGemMountingStrengthen.m_root
    elseif self.m_nFuncId == 64 and WndBlessBag.m_root then
        nodeParent = GetElement(WndBlessBag.m_root, "conRight_WndBlessBag", WZUIContainer)
    elseif self.m_nFuncId == 131 and WndFamilyOperate.m_root then
        nodeParent = GetElement(WndFamilyOperate.m_root, "conRightUp_WndFamileOperate", WZUIContainer)
    elseif self.m_nFuncId == 28 and WndMounts.m_root then
        nodeParent = GetElement(WndMounts.m_root, "conForMount_WndMounts", WZUIContainer)
    elseif self.m_nFuncId == 76 and WndCard.m_root then
        nodeParent = GetElement(WndCard.m_root, "conTopMenu_WndCard", WZUIContainer)
    end 
    if nodeParent then
        local nodeBtn = nodeParent:getChildByTag(self.m_nFuncId)
        if nodeBtn then 
            WindowManagerAni:createDisappearAction2(self.m_root, self.onCloseActionCallback, self, nil, nodeBtn)
        else
            self:onClose()
        end
    else
        self:onClose()
    end
end

function WndVipGift:onClose()
    WZLog("WndVipGift:onClose one")
    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

function WndVipGift:onCloseActionCallback()
    WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------语言适配Begin------------------------------------------
function WndVipGift:_adaptLanguage_pt(  )
    GetElement(self.m_root, "txtBtn_WndVipGift", WZUILabelTTF):setScale(0.6)
    local txtMoney = GetElement(self.m_root, "txtRemain_WndVipGift", WZUIFreeTextBox)
    txtMoney:setMaxWidth(200)
    txtMoney:setScale(0.8)

    local ftxtCurPrice = GetElement(self.m_root, "ftxtCurPrice_WndVipGift", WZUIFreeTextBox)
    ftxtCurPrice:setScale(0.7)

    GetElement(self.m_root, "txtDesc_WndVipGift", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.205,0.387692))
end

function WndVipGift:_adaptLanguage_es(  )
    GetElement(self.m_root, "txtName2_WndVipGift", WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root, "txtBtn_WndVipGift", WZUILabelTTF):setScale(0.7)

    local txtMoney = GetElement(self.m_root, "txtRemain_WndVipGift", WZUIFreeTextBox)
    txtMoney:setMaxWidth(200)
    txtMoney:setScale(0.8)
    
    local ftxtCurPrice = GetElement(self.m_root, "ftxtCurPrice_WndVipGift", WZUIFreeTextBox)
    ftxtCurPrice:setScale(0.7)

    GetElement(self.m_root, "txtDesc_WndVipGift", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.205,0.387692))
end

function WndVipGift:_adaptLanguage_en(  )
    GetElement(self.m_root, "txtBtn_WndVipGift", WZUILabelTTF):setScale(0.7)

    local txtMoney = GetElement(self.m_root, "txtRemain_WndVipGift", WZUIFreeTextBox)
    txtMoney:setMaxWidth(200)
    txtMoney:setScale(0.8)

    local ftxtCurPrice = GetElement(self.m_root, "ftxtCurPrice_WndVipGift", WZUIFreeTextBox)
    ftxtCurPrice:setScale(0.7)
    
    GetElement(self.m_root, "txtDesc_WndVipGift", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.205,0.387692))
end

function WndVipGift:_adaptLanguage_vn(  )
    local ftxtCurPrice = GetElement(self.m_root, "ftxtCurPrice_WndVipGift", WZUIFreeTextBox)
    ftxtCurPrice:setScale(0.7)
end

function WndVipGift:_adaptLanguage_tr(  )
    GetElement(self.m_root, "txtBtn_WndVipGift", WZUILabelTTF):setScale(0.7)

    local ftxtCurPrice = GetElement(self.m_root, "ftxtCurPrice_WndVipGift", WZUIFreeTextBox)
    ftxtCurPrice:setScale(0.7)
end
-------------------------------------语言适配End--------------------------------------------