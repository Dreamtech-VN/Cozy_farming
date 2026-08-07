--CellTimeFirstRecharge.lua
--@brief	CellTimeFirstRecharge的UI模块
--@date		2015/11/09
--@author	Tianxiang_Xu
--@note		活动-限时首充


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTimeFirstRecharge:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTimeFirstRecharge:onExit(element)
--    self.m_root:disableSchedule()
	self:_unInit()
end

function CellTimeFirstRecharge:showWindow()
    -- body
    self:_initStaticText()
    self:_setDynamicText()
    self:_updateRewardItems()
    AdaptLanguage(self)
end

--@brief    规则按钮回调
function CellTimeFirstRecharge:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WZLog("CellTimeFirstRecharge:onClickRule", self.content)
    WndSingleMapDesc:showInterface1(self.content)    
end

function CellTimeFirstRecharge:caculateTime()
    -- body
    if self.m_nLeftTime > 0 then
        self.m_nLeftTime = self.m_nLeftTime - 1
        local nHours = math.floor(self.m_nLeftTime / 3600)
        local nMinites = math.floor((self.m_nLeftTime - nHours * 3600) / 60) 
        local nSeconds = self.m_nLeftTime - nHours * 3600 - nMinites * 60 
        local sTime = string.format("%02d:%02d:%02d",nHours, nMinites, nSeconds)
        GetElement(self.m_root, "txtHours_CellTimeFirstRecharge", WZUILabelTTF):setText(sTime)
        local nDays = math.floor(self.m_nLeftTime / (24 * 3600 )) 
        if nDays == 0 then
            GetElement(self.m_root, "txtLastDay_CellTimeFirstRecharge", WZUILabelTTF):setVisible(false)
        else
            GetElement(self.m_root, "txtLastDay_CellTimeFirstRecharge", WZUILabelTTF):setText(tostring(nDays) .. LocalStrings.DAY)
        end
    else
        self.m_root:disableSchedule()
        GetElement(self.m_root, "txtLastDay_CellTimeFirstRecharge", WZUILabelTTF):setText(tostring(0) .. LocalStrings.DAY)
        GetElement(self.m_root, "txtHours_CellTimeFirstRecharge", WZUILabelTTF):setText("00:00:00")
    end
end

function CellTimeFirstRecharge:onRechargeEvent()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_THREETIMES_DIAMOND then 
        PassportSdkManager:gotoPaymentPage()
    else
        if self.m_nStatus == -1 then
            --充值
            PassportSdkManager:gotoPaymentPage()
        elseif self.m_nStatus == 0 then
            --领取奖励
            --背包已满提示
            if CacheCenter:getRemainAmount() <= 0 then
                MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
                return
            end
            CellTimeFirstRecharge.m_current_click = self
            self.m_nloadingId = MsgBoxManager:showLoadingBox()
            ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId, self.m_nRewardId )
        else
            --奖励领完
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellTimeFirstRecharge:_initStaticText()
    -- body
    --设置按钮字内容、颜色
    local txt_gotoButton = GetElement(self.m_root, "txt_gotoButton", WZUILabelTTF)
    local imgHavedGet = GetElement(self.m_root, "imgHavedGet_CellTimeFirstRecharge", WZUIImage)
    if txt_gotoButton == nil then return end
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_THREETIMES_DIAMOND then
        --规则按钮
        self:_createBtn()

        txt_gotoButton:setText(LocalStrings.IMMEDIATELY_RECHARGE)
        if self.m_nStatus == 1 then 
            imgHavedGet:setVisible(true)
            imgHavedGet:setFile("ui/gameActivity/commom_icon_yfq.png")
        end
    else
        if self.m_nStatus == -1 then
            txt_gotoButton:setText(LocalStrings.IMMEDIATELY_RECHARGE)
        elseif self.m_nStatus == 0 then
            txt_gotoButton:setText(LocalStrings.GET_REWARD)
        elseif self.m_nStatus == 1 then
            GetElement(self.m_root, "btn_getReward_event", WZUIButton):setVisible(false)
            imgHavedGet:setVisible(true)
        end
    end

    GetElement(self.m_root, "txtActivityWord_CellTimeFirstRecharge", WZUILabelTTF):setText(LocalStrings.ACTIVE_TIME .. ":")
    --活动时间
    local txtLastDay = GetElement(self.m_root, "txtLastDay_CellTimeFirstRecharge", WZUILabelTTF)
--    local needDay_str = os.date("%Y/%m/%d", self.startTime) .. "-" .. os.date("%Y/%m/%d", self.endTime)
    local DayStartTab = os.date("*t",self.startTime)
    local DayEndTab = os.date("*t",self.endTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    txtLastDay:setText(needDay_str)
--[[    if self.m_nLeftTime > 0 then
        local nHours = math.floor(self.m_nLeftTime / 3600)
        local nMinites = math.floor((self.m_nLeftTime - nHours * 3600) / 60) 
        local nSeconds = self.m_nLeftTime - nHours * 3600 - nMinites * 60 
        local sTime = string.format("%02d:%02d:%02d",nHours, nMinites, nSeconds)
        GetElement(self.m_root, "txtHours_CellTimeFirstRecharge", WZUILabelTTF):setText(sTime)
        local nDays = math.floor(self.m_nLeftTime / (24 * 3600 )) 
        if nDays == 0 then 
            GetElement(self.m_root, "txtLastDay_CellTimeFirstRecharge", WZUILabelTTF):setVisible(false)
        else
            GetElement(self.m_root, "txtLastDay_CellTimeFirstRecharge", WZUILabelTTF):setText(tostring(nDays) .. LocalStrings.DAY)
        end
    else
        self.m_root:disableSchedule()
        GetElement(self.m_root, "txtLastDay_CellTimeFirstRecharge", WZUILabelTTF):setText(tostring(0) .. LocalStrings.DAY)
        GetElement(self.m_root, "txtHours_CellTimeFirstRecharge", WZUILabelTTF):setText("00:00:00")
    end]]
end

--@brief    奖励物品表
function CellTimeFirstRecharge:_updateRewardItems(  )
    local tbCon_activty_forRecharge = GetElement(self.m_root,"tbCon_activty_forRecharge",WZUITableContainer)
    if tbCon_activty_forRecharge == nil then
        WZLog("tbCon_activty_forRecharge is nil")
        return
    end
    --tbCon_activty_forRecharge:removeAllChildrenWithCleanup(true)
    local count = #self.m_tRewardItems
    WZLog("CellTimeFirstRecharge:_updateRewardItems=="..count)
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
function CellTimeFirstRecharge:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief    获取奖励成功后的界面处理
function CellTimeFirstRecharge:_GetRewardOk()
    -- body
    if self.m_root == nil then return end 
    
    GetElement(self.m_root, "btn_getReward_event", WZUIButton):setVisible(false)
    GetElement(self.m_root, "imgHavedGet_CellTimeFirstRecharge", WZUIImage):setVisible(true)
end

--@brief    显示展示图
function CellTimeFirstRecharge:_showBK()
    -- body
    local imgBK = GetElement(self.m_root, "imgBK_CellTimeFirstRecharge", WZUIImage)
    if imgBK then 
        if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_THREETIMES_DIAMOND then
            imgBK:setFile("ui/newActivity/activity_pic_hd_sb_10.png")
        end
    end
end
function CellTimeFirstRecharge:_adaptLanguage_en()
    WZLog("CellTimeFirstRecharge:_adaptLanguage_en")
    local txt_grade_value = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txt_grade_value:setScale(0.9)

    GetElement(self.m_root,"txtDesc_CellTimeFirstRecharge",WZUILabelTTF):setScale(0.66)

    local txt_grade_value = GetElement(self.m_root,"txt_grade_value",WZUILabelTTF)
    txt_grade_value:setScale(0.8)
    local txtValue1 = GetElement(self.m_root,"txtValue1_CellTimeFirstRecharge",WZUILabelTTF)
    txtValue1:setScale(0.8)
    txtValue1:setRelativePosition(GlobalMethod:ccp(0.41625,0.5))
    local txtValue2 = GetElement(self.m_root,"txtValue2_CellTimeFirstRecharge",WZUILabelTTF)
    txtValue2:setScale(0.8)
    txtValue2:setRelativePosition(GlobalMethod:ccp(0.638333,0.5))
end

--@brief    
function CellTimeFirstRecharge:_setDynamicText()
    -- body
    local txtGrade = GetElement(self.m_root, "txtGrade_CellTimeFirstRecharge", WZUILabelTTF)
    local txtPrice = GetElement(self.m_root, "txtPrice_CellTimeFirstRecharge", WZUILabelTTF)
    local txtThreeWorld = GetElement(self.m_root, "txtThreeWorld_CellTimeFirstRecharge", WZUILabelTTF)
    local txtRewardAtt = GetElement(self.m_root, "txtRewardAtt_CellTimeFirstRecharge", WZUILabelTTF)

    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_THREETIMES_DIAMOND then
        txtRewardAtt:setVisible(false)
        txtGrade:setText(LocalStrings.REWARD_BTN_GET)
        txtPrice:setText(self.tips[1])
        txtPrice:setUseSystemFont(true)
        txtThreeWorld:setText(string.format(LocalStrings.GAMEACTIVITY_TIPTEXT4, LocalStrings.COMMUNITYWARHISTORY_NUMBER[10]))
    else
        txtRewardAtt:setVisible(true)
        txtGrade:setText(LocalStrings.RECHARGE_BETWEEN)
        txtPrice:setText(LocalStrings.ANY_MONEY)
        txtThreeWorld:setText(LocalStrings.CAN_RECEIVE)
    end

    self:_showBK()
end

--@brief    创建规则按钮
function CellTimeFirstRecharge:_createBtn()
    -- body
    local btnRule = WZUIButton:create()
    btnRule:setUseAbsSize(true)
    btnRule:setAbsContentSize(GlobalMethod:CCSize(60,60))
    btnRule:setRelativePosition(GlobalMethod:ccp(1.085,-0.08))
    local imgNor = WZUIImage:create()
    imgNor:setUseOriginSize(true)
    imgNor:setFile("ui/common/common_icon_bz.png")
    local imgSel = WZUIImage:create()
    imgSel:setUseOriginSize(true)
    imgSel:setScale(1.1)
    imgSel:setFile("ui/common/common_icon_bz.png")
    btnRule:setNormalElement(imgNor)
    btnRule:setSelectElement(imgSel)
    btnRule:setLuaDoneFunctionName("onClickRule")

    self.m_root:addChild(btnRule)
end
function CellTimeFirstRecharge:_adaptLanguage_tr()
    GetElement(self.m_root,"txtDesc_CellTimeFirstRecharge",WZUILabelTTF):setScale(0.58)

    local txt_grade_value = GetElement(self.m_root,"txt_grade_value",WZUILabelTTF)
    txt_grade_value:setScale(0.7)
    local txtValue1 = GetElement(self.m_root,"txtValue1_CellTimeFirstRecharge",WZUILabelTTF)
    txtValue1:setScale(0.7)
    txtValue1:setRelativePosition(GlobalMethod:ccp(0.26625,0.5))
    local txtValue2 = GetElement(self.m_root,"txtValue2_CellTimeFirstRecharge",WZUILabelTTF)
    txtValue2:setScale(0.7)
    txtValue2:setRelativePosition(GlobalMethod:ccp(0.8175,0.5))
end

function CellTimeFirstRecharge:_adaptLanguage_pt(  )
    local txt_grade_value = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txt_grade_value:setScale(0.8)
    GetElement(self.m_root,"txtDesc_CellTimeFirstRecharge",WZUILabelTTF):setFontSize(12)
    GetElement(self.m_root,"txt_grade_value",WZUILabelTTF):setFontSize(10)
    GetElement(self.m_root,"txtValue1_CellTimeFirstRecharge",WZUILabelTTF):setFontSize(10)
    GetElement(self.m_root,"txtValue2_CellTimeFirstRecharge",WZUILabelTTF):setFontSize(10)
end
-------------------------------------私有方法模块End----------------------------------------
