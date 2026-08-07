--CellBuyLimitePanel.lua
--@brief	CellBuyLimitePanel的UI模块
--@date		2016/08/03
--@author	Tianxiang_Xu
--@note		新武器打折限购活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBuyLimitePanel:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBuyLimitePanel:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function CellBuyLimitePanel:onEnter(element)
    self.m_root = element
    self:_setStaticTxtInfo()
    AdaptLanguage(self)
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function CellBuyLimitePanel:onExit(element)
    self:_unInit()
end

--@brief    显示窗口
function CellBuyLimitePanel:showWindow()
    --设置背景
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEWWEAPON_TICKET then
        self.m_nCostId = 70
    end

    if self.content ~= nil then
        local nStart, nEnd = string.find(self.content, ".png")
        if nStart then
            local imgBK = GetElement(self.m_root, "imgBK_CellBuyLimitePanel", WZUIImage)
            if imgBK then
                imgBK:setFile(self.content)
            end
        end
    end
    self:_setActivityOpenTime()
    self:_setBuyTimes(self.count)
    self:_setBuyValue(self.maxCount)
    self:_setGifItems()
    AdaptLanguage(self)
end


--@brief    购买按钮的响应
function CellBuyLimitePanel:event_BuyTimes( element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("CellBuyLimitePanel:event_BuyTimes", self.count, self.activityId, self.rewardId[1])
    if self.count == 0  then 
        MsgBoxManager:showTipBox(LocalStrings.ATH_CNT_NOT_ENOUGH)
        return 
    elseif  self.count > 0 then 
        if not JudgeMoneyIsEnough(self.m_nCostId, self.maxCount, nil, nil, Chat_Channel_GameActivity, nil, nil, nil, nil, CellBuyLimitePanel.m_current_panel, CellBuyLimitePanel.m_current_panel.sureToUseDiamondInstead) then
            return 
        end
    end 

    CellBuyLimitePanel.m_current_panel:sureToUseDiamondInstead()
end

--@brief    确认用钻石代替礼券购买
function CellBuyLimitePanel:sureToUseDiamondInstead()
    -- body
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    
	--是否已有无限期时装
    local bIsHaved = gCheckHaveOrNot(self.rewardItems[1])
	--是否已有坐骑
	local hasMount = checkOwnMount(self.rewardItems[1])
	--礼包内是否有时装或坐骑
	local checkGiftOwn, text = checkGiftOwn(self.rewardItems[1])

    if bIsHaved then
        local tBasicInfo = GDatatab_item["id_" .. self.rewardItems[1]]

        MsgBoxManager:showConfirmBox(string.format(LocalStrings.ACTIVITY_HAVED_ATT, tBasicInfo.name), self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
	elseif hasMount then
        MsgBoxManager:showConfirmBox(LocalStrings.OWNMOUNT, self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
	elseif checkGiftOwn then
        MsgBoxManager:showConfirmBox(string.format(LocalStrings.OWN1, text), self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
    else
        self:event_SureBuyAgain(element)
    end
end

function CellBuyLimitePanel:event_SureBuyAgain(element)
    -- body
    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.activityId, self.rewardId[1] )
end

function CellBuyLimitePanel:event_leftExPlain(  nId, nResType )
    WZLog("CellGameSingInItem:_EventToVIP")
    if nResType == MSGBOXRESTYPE_CONFIRM then
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_vip)
        WndVip:showWndUI(0)
    end
end

function CellBuyLimitePanel:event_rightExPlain( element )
    WZLog("CellBuyLimitePanel:event_rightExPlain")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
end

--@brief    其它Item点击回调
function CellBuyLimitePanel:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 设置礼包物品
function CellBuyLimitePanel:_setGifItems(  )
    local conItem = GetElement(self.m_root,"conItem_CellBuyLimitePanel",WZUIContainer)
    conItem:removeAllChildrenWithCleanup(true)

    local txtGiftName = GetElement(self.m_root, "txtGiftName_CellBuyLimitePanel", WZUILabelTTF)

    local ItemCount = math.ceil(#self.rewardItems/2)
    WZLog("CellBuyLimitePanel:_setGifItems", ItemCount, #self.rewardItems)
    local nItemId = nil 
    for i=1,ItemCount do
        local m_tItemId = {}
        local m_tItemNum = {}
        if i*2 >#self.rewardItems then 
            local idx = i*2-1
            table.insert(m_tItemId,self.rewardItems[idx])
            table.insert(m_tItemNum,self.rewardItemsParamCount[idx])
        else 
            local idx_1 = i*2
            local idx_2 = i*2-1
            table.insert(m_tItemId,self.rewardItems[idx_2])
            table.insert(m_tItemId,self.rewardItems[idx_1])
            table.insert(m_tItemNum,self.rewardItemsParamCount[idx_2])
            table.insert(m_tItemNum,self.rewardItemsParamCount[idx_1])
        end 
        
        for j=1,#m_tItemId do
            local celElement,tLuaObj = CellGoodItem:createElement()
            if celElement ~= nil then 
                celElement = WZUIContainer:luaTo(celElement)
                local key = "id_"..m_tItemId[j]
                nItemId = m_tItemId[j]
                local itemInfo = {id = m_tItemId[j], name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=m_tItemNum[j],quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
                tLuaObj:setCellGoodItem(itemInfo,4)
                celElement:setTag(i-1)
                tLuaObj:setItemClickFun(self,self.onOthersClick)
            end
            conItem:addChild(celElement)
        end
    end
    txtGiftName:setColor(QUALITYCOLOR[GDatatab_item["id_"..nItemId].quality])
    txtGiftName:setText(GDatatab_item["id_"..nItemId].name)
end


--@brief    设置活动的时间长度
function CellBuyLimitePanel:_setActivityOpenTime(  )
    local DayStartTab = os.date("*t",self.startTime)
    local DayEndTab = os.date("*t",self.endTime)
    local format_txt_value = nil 
    format_txt_value = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityOpenTime = GetElement(self.m_root,"txtActivityOpenTime_CellBuyLimitePanel",WZUILabelTTF)
    if txtActivityOpenTime~=nil then 
        txtActivityOpenTime:setText(format_txt_value)
    end
end

--@brief    设置可以购买的次数
function CellBuyLimitePanel:_setBuyTimes( BuyTimes )
    local txtBuyTimesNum = GetElement(self.m_root,"txtBuyTimesNum_CellBuyLimitePanel",WZUILabelTTF)
    if txtBuyTimesNum ~= nil then 
        if BuyTimes <= 1 then
            GetElement(self.m_root, "conCount_CellBuyLimitePanel", WZUIContainer):setVisible(false)
        end
        txtBuyTimesNum:setText(string.format("%d",BuyTimes))
    end
    if BuyTimes == 0 then
        GetElement(self.m_root, "btnGetReward_CellBuyLimitePanel", WZUIButton):setTouchEnable(false)
    end
end

--@brief    设置购买礼包的消耗
function CellBuyLimitePanel:_setBuyValue( BuyValues )
    local txtCostValue = GetElement(self.m_root,"txtCostValue_CellBuyLimitePanel",WZUILabelTTF)
    if txtCostValue ~= nil then 
        WZLog("CellBuyLimitePanel:_setBuyValue", self.rewardItems[1])
        local nOriginPrice = CacheCenter:getPriceByItemId(self.rewardItems[1])
        txtCostValue:setText(LocalStrings.LIMITE_BUY_ORIGINPRICE .. ": " .. nOriginPrice)
    end 

    local txtCostDiscount = GetElement(self.m_root, "txtCostDiscount_CellBuyLimitePanel", WZUILabelTTF)
    txtCostDiscount:setText(BuyValues)

    local iconPath = GDatatab_item["id_" .. self.m_nCostId].icon
    local imgCostIcon1 = GetElement(self.m_root, "imgCostIcon1_CellBuyLimitePanel", WZUIImage)
    if imgCostIcon1 then
        imgCostIcon1:setFile(iconPath)
        imgCostIcon1:setScale(0.4)
    end
    local imgCostIcon2 = GetElement(self.m_root, "imgCostIcon2_CellBuyLimitePanel", WZUIImage)
    if imgCostIcon2 then
        imgCostIcon2:setFile(iconPath)
        imgCostIcon2:setScale(0.7)
    end
end 

--@brief    设置静态字符信息
function CellBuyLimitePanel:_setStaticTxtInfo(  )
    
    local txtActivityOpenTime = GetElement(self.m_root,"txtActivityOpenTime_CellBuyLimitePanel",WZUILabelTTF)
    if txtActivityOpenTime~=nil then 
        txtActivityOpenTime:setText("")
    end 
    local txtBuyTimesTips_1 = GetElement(self.m_root,"txtBuyTimesTips_1_CellBuyLimitePanel",WZUILabelTTF)
    if txtBuyTimesTips_1 ~= nil then 
        txtBuyTimesTips_1:setText(LocalStrings.CAN_BUY_GIFT)
    end 
    local txtBuyTimesNum = GetElement(self.m_root,"txtBuyTimesNum_CellBuyLimitePanel",WZUILabelTTF)
    if txtBuyTimesNum~= nil then 
        txtBuyTimesNum:setText("0")
    end 
    local txtBuyTimesTips_2 = GetElement(self.m_root,"txtBuyTimesTips_2_CellBuyLimitePanel",WZUILabelTTF)
    if txtBuyTimesTips_2 ~= nil then 
        txtBuyTimesTips_2:setText(LocalStrings.SHOP_CISHU)
    end 
end

--@brief    奖励获取成功回调  
function CellBuyLimitePanel:_GetRewardOk()
    WZLog("CellBuyLimitePanel:_GetRewardOk")
    self.count = self.count - 1 
    self:_setBuyTimes(self.count)
    if self.count == 0 then
        GetElement(self.m_root, "btnGetReward_CellBuyLimitePanel", WZUIButton):setTouchEnable(false)
    end
end

-------------------------------------私有方法模块End----------------------------------------

----------------------------------语言适配Begin-----------------------------------
function CellBuyLimitePanel:_adaptLanguage_pt(  )

    local time = GetElement(self.m_root,"txtActivityOpenTime_CellBuyLimitePanel",WZUILabelTTF)
    time:setRelativePosition(GlobalMethod:ccp(0.95,0.1))
    for i=1,3 do
        local txtBuy = GetElement(self.m_root,"txtBuylabel_"..i.."_CellBuyLimitePanel",WZUILabelTTF)
        txtBuy:setScale(0.7)
    end
end

function CellBuyLimitePanel:_adaptLanguage_es(  )
    for i=1,3 do
        local txtBuy = GetElement(self.m_root,"txtBuylabel_"..i.."_CellBuyLimitePanel",WZUILabelTTF)
        txtBuy:setScale(0.7)
    end

    local txtBuyTimesTips = GetElement(self.m_root,"txtBuyTimesTips_1_CellBuyLimitePanel",WZUILabelTTF)
    txtBuyTimesTips:setRelativePosition(GlobalMethod:ccp(-0.1,0.475))
end

function CellBuyLimitePanel:_adaptLanguage_en(  )
    for i=1,3 do
        local txtBuy = GetElement(self.m_root,"txtBuylabel_"..i.."_CellBuyLimitePanel",WZUILabelTTF)
        txtBuy:setScale(0.7)
    end
end
function CellBuyLimitePanel:_adaptLanguage_tr(  )
    for i=1,3 do
        local txtBuy = GetElement(self.m_root,"txtBuylabel_"..i.."_CellBuyLimitePanel",WZUILabelTTF)
        txtBuy:setScale(0.7)
    end
    local txtGiftName = GetElement(self.m_root, "txtGiftName_CellBuyLimitePanel", WZUILabelTTF)
    txtGiftName:setScale(0.8)
    txtGiftName:setDimensions(GlobalMethod:CCSize(280))
end
----------------------------------语言适配End-------------------------------------