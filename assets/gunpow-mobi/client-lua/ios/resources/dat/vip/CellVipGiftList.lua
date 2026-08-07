--CellVipGiftList.lua
--@brief	CellVipGiftList的UI模块
--@date		2017/01/10
--@author	jiaming_liu
--@modify   binshao 2015-5-8
--@note		礼包列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellVipGiftList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellVipGiftList:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellVipGiftList:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellVipGiftList")
    self.m_root:addChild(cellElement)
    self:_update()

    --多语言版本界面适配
    AdaptLanguage(self)
end

-- 点击领取回调
function CellVipGiftList:clickReward(element)
    WZLog("CellVipGiftList:clickReward")
    if self.m_nType == 1 then 
        if CacheCenter:getPlayerInfo().vipLevel < self.data.needVip then
            MsgBoxManager:showConfirmBox(LocalStrings.NEWACTIVITY_TEXT9, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_NORMAL, nil)
            return 
        else
            if not JudgeMoneyIsEnough(self.m_tCurPrice.id, self.m_tCurPrice.num, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then 
                return 
            end

            self:sureUseDiamondInstead()
        end
    else
        ProtocolProcessorWndVip:send_VIP_DrawVipRebate(self.data.id )
        WndVip.m_tGiftId = self.id
        WndVip.m_tGiftNum = self.num
    end
    --element:setVisible(false)
    --GetElement(self.m_root, "txtReward_CellVipGiftList"):setVisible(true)
end 

--@brief    提示充值框的回调
--@param    nId:消息id
--@param    nResType:响应类型(超时，确定，取消)
function CellVipGiftList:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage(0, true)
    end
end

--@brief    确定用蓝钻代替粉钻消费
function CellVipGiftList:sureUseDiamondInstead()
    -- body
    WndVip:createLoadingUI()
    ProtocolProcessorWndVip:send_MALL_BuyVipGift(self.data.id)
end

--@note		设置UI界面数据
function CellVipGiftList:_update()
    local curData = self.data
    local txtName =  GetElement(self.m_root, "txtName_CellVipGiftList", WZUILabelTTF)
    local txt = GetElement(self.m_root,"txt_CellVipGiftList",WZUIFreeTextBox)
    local txtReward = GetElement(self.m_root, "txtReward_CellVipGiftList", WZUILabelTTF)
    local txtBtn = GetElement(self.m_root, "txtBtn_CellVipGiftList", WZUILabelTTF)
    local txtBtnSel = GetElement(self.m_root, "txtBtnSel_CellVipGiftList", WZUILabelTTF)

    if self.m_nType == 1 then 
        local conForPrice = GetElement(self.m_root, "conForPrice_CellVipGiftList", WZUIContainer)
        conForPrice:setVisible(true)
        txtName:setVisible(false)
        GetElement(self.m_root, "conProgress_CellVipGiftList"):setVisible(false)
        txtReward:setText(LocalStrings.BOUGHT)
        txtBtn:setText(LocalStrings.BUY)
        txtBtnSel:setText(LocalStrings.BUY)
        txtReward:setVisible(false)

        txt:setShowText(string.format(LocalStrings.VIPWEEK_PACKAGE2, curData.needVip))
        if curData.state > 0 then
            self:createHavedBuyIcon(conForPrice)
        else
            if CacheCenter:getPlayerInfo().vipLevel < curData.needVip then
                txtBtn:setText(LocalStrings.LEAGUE_REWARD_TEXT9)
                txtBtnSel:setText(LocalStrings.LEAGUE_REWARD_TEXT9)
            end
            GetElement(self.m_root, "btnReward_CellVipGiftList"):setVisible(true)
        end
        local ftxtOriginPrice = GetElement(self.m_root, "ftxtOriginPrice_CellVipGiftList", WZUIFreeTextBox)
        local sPriceFormat = [[<T C="255,236,193" S="20" P="1" SC="105,65,46" SS="4" SE="1">%s:</T><T C="255,227,116" S="20" P="1" SC="105,65,46" SS="4" SE="1">%d</T><I Z="0.6" P="1">%s</I>]]
        if ftxtOriginPrice then 
            local string = string.sub(curData.originPrice, 2, -2) 
            local id = SplitStringWithSeparator(string, ",")[1]
            local num = SplitStringWithSeparator(string, ",")[2]
            self.m_tOriginPrice = {id = tonumber(id), num = tonumber(num)}
            ftxtOriginPrice:setShowText(string.format(sPriceFormat, LocalStrings.LIMITE_BUY_ORIGINPRICE, self.m_tOriginPrice.num, GDatatab_item["id_" .. id].icon))
        end
        local ftxtCurPrice = GetElement(self.m_root, "ftxtCurPrice_CellVipGiftList", WZUIFreeTextBox)
        if ftxtCurPrice then 
            local string = string.sub(curData.curPrice, 2, -2) 
            local id = SplitStringWithSeparator(string, ",")[1]
            local num = SplitStringWithSeparator(string, ",")[2]
            self.m_tCurPrice = {id = tonumber(id), num = tonumber(num)}
            ftxtCurPrice:setShowText(string.format(sPriceFormat, LocalStrings.LIMITE_BUY_CURPRICE, self.m_tCurPrice.num, GDatatab_item["id_" .. id].icon))
        end
    else
        GetElement(self.m_root, "conForPrice_CellVipGiftList", WZUIContainer):setVisible(false)
        txtReward:setText(LocalStrings.ACTIVE_GET)
        txtBtn:setText(LocalStrings.INVITE_RECEIVE)
        txtBtnSel:setText(LocalStrings.INVITE_RECEIVE)
        txtName:setText(string.format(LocalStrings.VipRebateDesc or "%d", curData.name))

        txt:setShowText(string.format(LocalStrings.VipRebateDesc1, tostring(curData.name)))

        WZLog("CellVipGiftList:_update one", curData.id,curData.state, type(curData.state))
        if curData.state == 2 then
            txtReward:setVisible(true)
        elseif curData.state == 1 then
            GetElement(self.m_root, "btnReward_CellVipGiftList"):setVisible(true)
        elseif curData.state == 0 then
            GetElement(self.m_root, "conProgress_CellVipGiftList"):setVisible(true)
            GetElement(self.m_root, "txtProgress_CellVipGiftList", WZUILabelTTF):setText(curData.complete .. "/" .. curData.total)
            GetElement(self.m_root, "progress_WndOwnCity", WZUIProgress):setPercentage(curData.complete / curData.total * 100)
        end
    end

    self:_createVipReward()
end

--@brief    更新vip奖励
function CellVipGiftList:_createVipReward()
    local id = {}
    local num = {}
    local id2 = {}
    local num2 = {}
    local reward = self.data.reward
    WZLog("CellVipGiftList:_createVipReward one",reward)
    id, num = SplitItemString(reward)

    self.id = id
    self.num = num
    for i=1,#id do
        --WZLog("CellVipGiftList:_createVipReward two", Serialize(id), Serialize(num))
        if id[i] ~= nil then
            local key = "id_"..id[i] 
            local tData = GDatatab_item[key]
            local name = tData.name
            local icon = tData.icon
            local num =  num[i]
            local quality = tData.quality
            local itemInfo = {name=name,icon=icon,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(tData)}

            local con = GetElement(self.m_root,"conLeft"..i,WZUIContainer)
            con:removeAllChildrenWithCleanup(true)
            local celElement,tLuaObj = CellGoodItem:createElement()
            if celElement ~= nil then 
                celElement = WZUIContainer:luaTo(celElement)
                tLuaObj:setCellGoodItem(itemInfo, 16)
                tLuaObj:setItemClickFun(self, self.onClickItem)
                tLuaObj:setTag(i)
                celElement:setScale(0.85)
                con:addChild(celElement)
            end
        end
    end
end

function CellVipGiftList:onClickItem(tItem, nTag, tData)
    if self.m_root == nil then return end
    WndItemInfo:showInfo(tItem.m_root,WndVip.m_root,1,tData, false)
end

--@brief    创建已购买图标
function CellVipGiftList:createHavedBuyIcon(parentNode)
    -- body
    local imgBuyed = WZUIImage:create()
    imgBuyed:setUseOriginSize(true)
    imgBuyed:setFile("ui/common/common_icon_yigoumai01.png")
    imgBuyed:setRelativePosition(GlobalMethod:ccp(0.9, 0.5))
    parentNode:addChild(imgBuyed)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function CellVipGiftList:_adaptLanguage_tr(  )
    local txtBtn = GetElement(self.m_root, "txtBtn_CellVipGiftList", WZUILabelTTF)
    txtBtn:setScale(0.65)
    local txtBtnSel = GetElement(self.m_root, "txtBtnSel_CellVipGiftList", WZUILabelTTF)
    txtBtnSel:setScale(0.65)
end


-------------------------------------语言适配End----------------------------------------