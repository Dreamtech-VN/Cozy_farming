--CellDailyFirstRecharge.lua
--@brief	CellDailyFirstRecharge的UI模块
--@date		2015/11/09
--@author	Tianxiang_Xu
--@note		活动-每日首充


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDailyFirstRecharge:onEnter(element)
	self.m_root = element
    self.m_nStartTime = nil
    self.m_nEndTime = nil
    self.m_nActivityId = nil
    self.m_nEndTime = nil
    self.m_nServerTime = nil
    self.m_tRewardItems = nil
    self.m_tRewardItemsParamCount = nil
    self.m_nRewardId = nil
    self.m_nTarget = nil
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDailyFirstRecharge:onExit(element)
	self:_unInit()
    self.m_nStartTime = nil
    self.m_nEndTime = nil
    self.m_nActivityId = nil
    self.m_nEndTime = nil
    self.m_nServerTime = nil
    self.m_tRewardItems = nil
    self.m_tRewardItemsParamCount = nil
    self.m_nRewardId = nil
    self.m_nTarget = nil
end

function CellDailyFirstRecharge:showWindow()
    -- body
    if self.m_root == nil then return end 

    self:_initStaticText()
    self:_activityTime()
    self:_updateRewardItems()
end

function CellDailyFirstRecharge:onRechargeEvent()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nStatus == -1 then
        --充值
        PassportSdkManager:gotoPaymentPage()
    elseif self.m_nStatus == 0 then
        --背包已满提示
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        --领取奖励
        CellDailyFirstRecharge.m_current_click = self
        self.m_nloadingId = MsgBoxManager:showLoadingBox()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId, self.m_nRewardId )
    else
        --奖励领完
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    显示活动时间
function CellDailyFirstRecharge:_activityTime()
    -- body
    if self.m_root == nil then return end 

    WZLog("CellDailyFirstRecharge:_activityTime", self.m_nStartTime, self.m_nEndTime)
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellDailyFirstRecharge", WZUILabelTTF)
    if not txtTimeWord then return end
    
    txtTimeWord:setText(LocalStrings.ACTIVE_TIME .. ":")
    local txtTime = GetElement(self.m_root, "txtTime_CellDailyFirstRecharge", WZUILabelTTF) 
    local startDate = os.date("*t", self.m_nStartTime)
    local endDate = os.date("*t", self.m_nEndTime)
    local sTimeContent = string.format(LocalStrings.ACTIVITYTIME_FORMAT, startDate.month, startDate.day, startDate.hour, startDate.min, endDate.month, endDate.day, endDate.hour, endDate.min)
    txtTime:setText(sTimeContent)
end
function CellDailyFirstRecharge:_initStaticText()
    -- body
    if self.m_root == nil then return end 
    --设置按钮字内容、颜色
    local txt_gotoButton = GetElement(self.m_root, "txt_gotoButton", WZUILabelTTF)
    if txt_gotoButton == nil then return end
    if self.m_nStatus == -1 then
        txt_gotoButton:setText(LocalStrings.IMMEDIATELY_RECHARGE)
    elseif self.m_nStatus == 0 then
        txt_gotoButton:setText(LocalStrings.GET_REWARD)
    elseif self.m_nStatus == 1 then
        GetElement(self.m_root, "spineLight_CellDailyFirstRecharge", WZUISpine):setVisible(false)
        GetElement(self.m_root, "btn_getReward_event", WZUIButton):setTouchEnable(false)
        txt_gotoButton:setText(LocalStrings.ACTIVE_GET)
        txt_gotoButton:setColor(GlobalMethod:ccc3(255,255,255))
        txt_gotoButton:setStrokeColor(GlobalMethod:ccc3(80,61,50))
    end
    --设置充值的数量
    local txtMoneyValue = GetElement(self.m_root, "txtMoneyValue_CellDailyFirstRecharge", WZUILabelTTF)
    if txtMoneyValue == nil then return end 
    txtMoneyValue:setText(LocalStrings.ANY_MONEY)
--    txtMoneyValue:setText(self.m_nTarget .. LocalStrings.MONEY_UNIT)
end

--@brief    奖励物品表
function CellDailyFirstRecharge:_updateRewardItems(  )
    if self.m_root == nil then return end 
    
    local tbCon_activty_forRecharge = GetElement(self.m_root,"tbCon_activty_forRecharge",WZUITableContainer)
    if tbCon_activty_forRecharge == nil then
        WZLog("tbCon_activty_forRecharge is nil")
        return
    end
    --tbCon_activty_forRecharge:removeAllChildrenWithCleanup(true)
    local count = #self.m_tRewardItems
    WZLog("CellDailyFirstRecharge:_updateRewardItems=="..count)
    for i=1,count do
        local key = "id_"..self.m_tRewardItems[i]
        WZLog("------"..key)
        local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement ~= nil then 
            celElement = WZUIContainer:luaTo(celElement)
            if 27 == self.m_tRewardItems[i] then
                local itemInfo = {id = self.m_tRewardItems[i], name="",icon="ui/bottomMenu/pay/payment_first.png",lastTime=0,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
                tLuaObj:setCellGoodItem(itemInfo,5)
            else
                local itemInfo = {id = self.m_tRewardItems[i], name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=self.m_tRewardItemsParamCount[i],quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
                tLuaObj:setCellGoodItem(itemInfo,4)
            end
            celElement:setTag(i-1)
            tLuaObj:setItemClickFun(self,self.onOthersClick)
            tLuaObj:clearItemQualityPic(true)
            celElement:setScale(0.90)
            tbCon_activty_forRecharge:setCellElement(celElement)
        end
    end
end

--@brief    其它Item点击回调
function CellDailyFirstRecharge:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief    获取奖励成功后的界面处理
function CellDailyFirstRecharge:_GetRewardOk()
    -- body
    if self.m_root then 
        GetElement(self.m_root, "spineLight_CellDailyFirstRecharge", WZUISpine):setVisible(false)
        GetElement(self.m_root, "btn_getReward_event", WZUIButton):setTouchEnable(false)
        local txt_gotoButton = GetElement(self.m_root, "txt_gotoButton", WZUILabelTTF)
        if txt_gotoButton == nil then return end
        txt_gotoButton:setColor(GlobalMethod:ccc3(255,255,255))
        txt_gotoButton:setStrokeColor(GlobalMethod:ccc3(78,60,48))
    end

    if self.m_nActivityId then 
        WndGameActivity:removeAndUpdateActivityList(self.m_nActivityId)
    end
end

function CellDailyFirstRecharge:_adaptLanguage_en()
    WZLog("CellDailyFirstRecharge:_adaptLanguage_en")
    local txt_grade_value = GetElement(self.m_root,"txt_grade_value",WZUILabelTTF)
    txt_grade_value:setFontSize(18)

    local txtMoneyValue = GetElement(self.m_root, "txtMoneyValue_CellDailyFirstRecharge", WZUILabelTTF)
    txtMoneyValue:setFontSize(18)

    local txtGiftWords = GetElement(self.m_root,"txtGiftWords_CellDailyFirstRecharge",WZUILabelTTF)
    txtGiftWords:setFontSize(18)

    local textWidth = txt_grade_value:getLabelContentSize().width + 15
    txtMoneyValue:setRelativePosition(GlobalMethod:ccp(textWidth/480,0.5))

    local txt = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txt:setScale(0.9)
end

function CellDailyFirstRecharge:_adaptLanguage_pt(  )
    local txt_grade_value = GetElement(self.m_root,"txt_grade_value",WZUILabelTTF)
    txt_grade_value:setFontSize(18)
    txt_grade_value:setRelativePosition(GlobalMethod:ccp(0.025,0.9))

    local txtMoneyValue = GetElement(self.m_root, "txtMoneyValue_CellDailyFirstRecharge", WZUILabelTTF)
    txtMoneyValue:setFontSize(18)

    local txtGiftWords = GetElement(self.m_root,"txtGiftWords_CellDailyFirstRecharge",WZUILabelTTF)
    txtGiftWords:setFontSize(18)
    txtGiftWords:setRelativePosition(GlobalMethod:ccp(-1,-0.5))

    local textWidth = txt_grade_value:getLabelContentSize().width + 15
    txtMoneyValue:setRelativePosition(GlobalMethod:ccp(textWidth/480,0.9))

    local txt = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txt:setScale(0.9)

    GetElement(self.m_root, "btn_getReward_event", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.5,0.22))
end


function CellDailyFirstRecharge:_adaptLanguage_th()
    WZLog("CellDailyFirstRecharge:_adaptLanguage_th")
    local txt_grade_value = GetElement(self.m_root,"txt_grade_value",WZUILabelTTF)
    txt_grade_value:setFontSize(18)

    local txtMoneyValue = GetElement(self.m_root, "txtMoneyValue_CellDailyFirstRecharge", WZUILabelTTF)
    txtMoneyValue:setFontSize(18)

    local txtGiftWords = GetElement(self.m_root,"txtGiftWords_CellDailyFirstRecharge",WZUILabelTTF)
    txtGiftWords:setFontSize(18)

    local textWidth = txt_grade_value:getLabelContentSize().width + 15
    txtMoneyValue:setRelativePosition(GlobalMethod:ccp(textWidth/480,0.5))
end

function CellDailyFirstRecharge:_adaptLanguage_vn(  )
    local txtTime = GetElement(self.m_root,"txtTime_CellDailyFirstRecharge",WZUILabelTTF)
    txtTime:setRelativePosition(GlobalMethod:ccp(0.3,0.5))
    local txtMoney = GetElement(self.m_root,"txtMoneyValue_CellDailyFirstRecharge",WZUILabelTTF)
    txtMoney:setFontSize(20)
    txtMoney:setRelativePosition(GlobalMethod:ccp(0.25,0.45))
    local txtGrade = GetElement(self.m_root,"txt_grade_value",WZUILabelTTF)
    txtGrade:setFontSize(20)
    txtGrade:setRelativePosition(GlobalMethod:ccp(0.018,0.5))

    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellDailyFirstRecharge", WZUILabelTTF)
    txtTimeWord:setRelativePosition(GlobalMethod:ccp(0.02,0.5))
end

function CellDailyFirstRecharge:_adaptLanguage_es(  )
    GetElement(self.m_root,"txt_grade_value",WZUILabelTTF):setFontSize(14)
    GetElement(self.m_root,"txtMoneyValue_CellDailyFirstRecharge",WZUILabelTTF):setFontSize(14)
    GetElement(self.m_root,"txtGiftWords_CellDailyFirstRecharge",WZUILabelTTF):setFontSize(14)
    GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF):setFontSize(18)
end
function CellDailyFirstRecharge:_adaptLanguage_tr(  )
    local btnGetReward = GetElement(self.m_root,"btn_getReward_event",WZUIButton)
    btnGetReward:setRelativePosition(GlobalMethod:ccp(0.5,0.15))
    local txtGrade = GetElement(self.m_root,"txt_grade_value",WZUILabelTTF)
    txtGrade:setFontSize(14)
    txtGrade:setRelativePosition(GlobalMethod:ccp(0,0.5))
    local txtMoney = GetElement(self.m_root,"txtMoneyValue_CellDailyFirstRecharge",WZUILabelTTF)
    txtMoney:setFontSize(14)
    txtMoney:setRelativePosition(GlobalMethod:ccp(0.177,0.5))
    local txtGift = GetElement(self.m_root,"txtGiftWords_CellDailyFirstRecharge",WZUILabelTTF)
    txtGift:setFontSize(14)

    local txt = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txt:setScale(0.9)
end

-------------------------------------私有方法模块End----------------------------------------
