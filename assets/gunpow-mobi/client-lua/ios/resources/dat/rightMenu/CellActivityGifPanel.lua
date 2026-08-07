--CellActivityGifPanel.lua
--@brief	CellActivityGifPanel的UI模块
--@date		2015/07/04
--@author	weidong_wu
--@note		优惠礼包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellActivityGifPanel:onEnter(element)
	self.m_root = element
	self:_setStaticTxtInfo()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellActivityGifPanel:onExit(element)
	self:_unInit()
end

--@brief 	显示窗口
function CellActivityGifPanel:showWindow(  )
	self:_setActivityOpenTime()
	self:_setBuyTimes(self.count)
	self:_setBuyValue(self.maxCount)
	self:_setGifItems()
	AdaptLanguage(self)
end


--@brief 	购买按钮的响应
function CellActivityGifPanel:event_BuyTimes( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("CellActivityGifPanel:event_BuyTimes", self.count, self.activityId, self.rewardId[1])
	if self.count == 0  then 
		MsgBoxManager:showTipBox(LocalStrings.ATH_CNT_NOT_ENOUGH)
        return 
	elseif self.count > 0 then 
        local moneyId = 1
        if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_DISCOUNTGIFBAG_TICKET then
            moneyId = 70
        end
        if not JudgeMoneyIsEnough(moneyId, self.maxCount, nil, nil, Chat_Channel_GameActivity, nil, nil, nil, nil, CellActivityGifPanel.m_current_panel, CellActivityGifPanel.m_current_panel.sureToUseDiamondInstead) then
            return 
        end
    end

    CellActivityGifPanel.m_current_panel:sureToUseDiamondInstead()
end

--@brief    确认用钻石代替礼券购买礼包
function CellActivityGifPanel:sureToUseDiamondInstead()
    -- body
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.activityId, self.rewardId[1] )
end

function CellActivityGifPanel:event_leftExPlain(  nId, nResType )
	WZLog("CellGameSingInItem:_EventToVIP")
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndVip:showWndUI(0)
    end
end

function CellActivityGifPanel:event_rightExPlain( element )
	WZLog("CellActivityGifPanel:event_rightExPlain")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
end

--@brief    其它Item点击回调
function CellActivityGifPanel:onOthersClick(luaTable,tag,tData)
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
function CellActivityGifPanel:_setGifItems(  )
	local conItem = GetElement(self.m_root,"conItem_CellActivityGifPanel",WZUIContainer)
	conItem:removeAllChildrenWithCleanup(true)

    local txtGiftName = GetElement(self.m_root, "txtGiftName_CellActivityGifPanel", WZUILabelTTF)

	local ItemCount = math.ceil(#self.rewardItems/2)
    WZLog("CellActivityGifPanel:_setGifItems", ItemCount)
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


--@brief 	设置活动的时间长度
function CellActivityGifPanel:_setActivityOpenTime(  )
	local DayStartTab = os.date("*t",self.startTime)
	local DayEndTab = os.date("*t",self.endTime)
    local format_txt_value = nil 
    format_txt_value = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtActivityOpenTime_CellActivityGifPanel = GetElement(self.m_root,"txtActivityOpenTime_CellActivityGifPanel",WZUILabelTTF)
	if txtActivityOpenTime_CellActivityGifPanel~=nil then 
		txtActivityOpenTime_CellActivityGifPanel:setText(format_txt_value)
	end
    -- if self.status == -1 then
    --     GetElement(self.m_root, "btnGetReward_CellActivityGifPanel", WZUIButton):setTouchEnable(false)
    -- end
end

--@brief 	设置可以购买的次数
function CellActivityGifPanel:_setBuyTimes( BuyTimes )
	local txtBuyTimesNum_CellActivityGifPanel = GetElement(self.m_root,"txtBuyTimesNum_CellActivityGifPanel",WZUILabelTTF)
	if txtBuyTimesNum_CellActivityGifPanel~= nil then 
		txtBuyTimesNum_CellActivityGifPanel:setText(string.format("%d",BuyTimes))
	end
    if BuyTimes == 0 then
        GetElement(self.m_root, "btnGetReward_CellActivityGifPanel", WZUIButton):setTouchEnable(false)
    end
end

--@brief 	设置购买礼包的消耗
function CellActivityGifPanel:_setBuyValue( BuyValues )
    local moneyId = 1
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_DISCOUNTGIFBAG_TICKET then
        moneyId = 70
    end
    
    local imgCostIcon = GetElement(self.m_root, "imgCostIcon_CellActivityGifPanel", WZUIImage)
    if imgCostIcon then
        imgCostIcon:setFile(GDatatab_item["id_" .. moneyId].icon)
        imgCostIcon:setScale(0.5)
    end
	local txtCostValue_CellActivityGifPanel = GetElement(self.m_root,"txtCostValue_CellActivityGifPanel",WZUILabelTTF)
	if txtCostValue_CellActivityGifPanel ~= nil then 
		txtCostValue_CellActivityGifPanel:setText(string.format("%d",BuyValues))
	end 
end	

--@brief 	设置静态字符信息
function CellActivityGifPanel:_setStaticTxtInfo(  )
	
	local txtActivityOpenTime_CellActivityGifPanel = GetElement(self.m_root,"txtActivityOpenTime_CellActivityGifPanel",WZUILabelTTF)
	if txtActivityOpenTime_CellActivityGifPanel~=nil then 
		txtActivityOpenTime_CellActivityGifPanel:setText("")
	end 
	local txtBuyTimesTips_1_CellActivityGifPanel = GetElement(self.m_root,"txtBuyTimesTips_1_CellActivityGifPanel",WZUILabelTTF)
	if txtBuyTimesTips_1_CellActivityGifPanel~= nil then 
		txtBuyTimesTips_1_CellActivityGifPanel:setText(LocalStrings.CAN_BUY_GIFT)
	end 
	local txtBuyTimesNum_CellActivityGifPanel = GetElement(self.m_root,"txtBuyTimesNum_CellActivityGifPanel",WZUILabelTTF)
	if txtBuyTimesNum_CellActivityGifPanel~= nil then 
		txtBuyTimesNum_CellActivityGifPanel:setText("0")
	end 
	local txtBuyTimesTips_2_CellActivityGifPanel = GetElement(self.m_root,"txtBuyTimesTips_2_CellActivityGifPanel",WZUILabelTTF)
	if txtBuyTimesTips_2_CellActivityGifPanel~= nil then 
		txtBuyTimesTips_2_CellActivityGifPanel:setText(LocalStrings.SHOP_CISHU)
	end 
end

--@brief    奖励获取成功回调  
function CellActivityGifPanel:_GetRewardOk()
    WZLog("CellActivityGifPanel:_GetRewardOk")
    self.count = self.count - 1 
    self:_setBuyTimes(self.count)
    if self.count == 0 then
        GetElement(self.m_root, "btnGetReward_CellActivityGifPanel", WZUIButton):setTouchEnable(false)
    end
	--g_tTempItemForLaterShow = {}
end

-------------------------------------私有方法模块End----------------------------------------

-----------------------------------------语言适配Begin--------------------------------------
function CellActivityGifPanel:_adaptLanguage_pt(  )
	for i=1,3 do
		local txtBuylabel = GetElement(self.m_root,"txtBuylabel_"..i.."_CellActivityGifPanel",WZUILabelTTF)
		txtBuylabel:setScale(0.75)
	end
	local txtBuyTimesTips = GetElement(self.m_root,"txtBuyTimesTips_1_CellActivityGifPanel",WZUILabelTTF)
	txtBuyTimesTips:setFontSize(18)
	txtBuyTimesTips:setRelativePosition(GlobalMethod:ccp(-0.1,0.475))
	local txtGiftName = GetElement(self.m_root,"txtGiftName_CellActivityGifPanel",WZUILabelTTF)
	txtGiftName:setFontSize(16)
	txtGiftName:setAlignment(kCCTextAlignmentCenter)
	txtGiftName:setRelativePosition(GlobalMethod:ccp(0.781952,0.59))
	txtGiftName:setDimensions(GlobalMethod:CCSize(160))
end

function CellActivityGifPanel:_adaptLanguage_vn(  )
	local txtGiftName = GetElement(self.m_root,"txtGiftName_CellActivityGifPanel",WZUILabelTTF)
	txtGiftName:setScale(0.7)
end
function CellActivityGifPanel:_adaptLanguage_es(  )
	for i=1,3 do
		local txtBuylabel = GetElement(self.m_root,"txtBuylabel_"..i.."_CellActivityGifPanel",WZUILabelTTF)
		txtBuylabel:setScale(0.7)
	end
	local txtBuyTimesTips = GetElement(self.m_root,"txtBuyTimesTips_1_CellActivityGifPanel",WZUILabelTTF)
	txtBuyTimesTips:setFontSize(16)
	txtBuyTimesTips:setRelativePosition(GlobalMethod:ccp(-0.23,0.475))

	GetElement(self.m_root,"txtBuyTimesNum_CellActivityGifPanel",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtBuyTimesTips_2_CellActivityGifPanel",WZUILabelTTF):setFontSize(16)

	local txtGiftName = GetElement(self.m_root,"txtGiftName_CellActivityGifPanel",WZUILabelTTF)
	txtGiftName:setFontSize(16)
	txtGiftName:setAlignment(kCCTextAlignmentCenter)
	txtGiftName:setRelativePosition(GlobalMethod:ccp(0.781952,0.59))
	txtGiftName:setDimensions(GlobalMethod:CCSize(160))
end
-- function CellActivityGifPanel:_adaptLanguage_en(  )
-- 	local txtBuyTimesTips = GetElement(self.m_root,"txtBuyTimesTips_1_CellActivityGifPanel",WZUILabelTTF)
-- 	txtBuyTimesTips:setRelativePosition(GlobalMethod:ccp(-0.1,0.475))
-- end
function CellActivityGifPanel:_adaptLanguage_tr(  )
	for i=1,3 do
		local txtBuylabel = GetElement(self.m_root,"txtBuylabel_"..i.."_CellActivityGifPanel",WZUILabelTTF)
		txtBuylabel:setScale(0.7)
	end
	local txtBuyTimesTips = GetElement(self.m_root,"txtBuyTimesTips_1_CellActivityGifPanel",WZUILabelTTF)
	txtBuyTimesTips:setScale(0.8)
	txtBuyTimesTips:setRelativePosition(GlobalMethod:ccp(-0.1,0.475))
	local txtGiftName = GetElement(self.m_root,"txtGiftName_CellActivityGifPanel",WZUILabelTTF)
	txtGiftName:setFontSize(16)
end
function CellActivityGifPanel:_adaptLanguage_en(  )
	for i=1,3 do
		local txtBuylabel = GetElement(self.m_root,"txtBuylabel_"..i.."_CellActivityGifPanel",WZUILabelTTF)
		txtBuylabel:setScale(0.7)
	end
	local txtBuyTimesTips = GetElement(self.m_root,"txtBuyTimesTips_1_CellActivityGifPanel",WZUILabelTTF)
	txtBuyTimesTips:setScale(0.8)
	txtBuyTimesTips:setRelativePosition(GlobalMethod:ccp(-0.1,0.475))
	local txtGiftName = GetElement(self.m_root,"txtGiftName_CellActivityGifPanel",WZUILabelTTF)
	txtGiftName:setFontSize(16)
	txtGiftName:setAlignment(kCCTextAlignmentCenter)
	txtGiftName:setRelativePosition(GlobalMethod:ccp(0.781952,0.59))
	txtGiftName:setDimensions(GlobalMethod:CCSize(160))
end
-----------------------------------------语言适配End----------------------------------------