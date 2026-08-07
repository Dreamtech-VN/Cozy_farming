--CellPreRechargePanel.lua
--@brief	CellPreRechargePanel的UI模块
--@date		2016/04/23
--@author	Tianxiang_Xu
--@note		活动预充值


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPreRechargePanel:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPreRechargePanel:onExit(element)
	self:_unInit()
end

--@brief    领取按钮事件
function CellPreRechargePanel:RechargeEvent(  )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --前往充值界面
    PassportSdkManager:gotoPaymentPage()
end

--@brief    点击前往按钮回调
function CellPreRechargePanel:onClickGoTo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_ATHLETICSHAPPINESS then
        JumpByUIId(2)
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_CHEATSWELFARE then
        JumpByUIId(25)
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_MULDOUBLE then
        JumpByUIId(15)
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_ELITEDOUBLE then
        JumpByUIId(12, nil, nil, 2)
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_RANKPVP_REWARD then
        JumpByUIId(154)
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_FLOP_CARD then
        JumpByUIId(15)
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_SHOP_LOTTERY then
        JumpByUIId(227)
    end
end

--@brief    点击前往按钮回调
function CellPreRechargePanel:onClickInfo(element)
    --body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface(self.tips)
end

--@brief    初始化信息
function CellPreRechargePanel:setActivityReturnInfo(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
    WZLog("CellPreRechargePanel:setMessage()", content, tips[1])
    self.m_context = content
    self.activityId = activityId
    self.tips = tips[1]
    self.m_nCount = count 
    self.m_nStartTime = startTime 
    self.m_nEndTime = endTime 
end

--@brief    设置奖励数据
function CellPreRechargePanel:setRewardData(rewardId, rewardItems, rewardItemsParamCount, rewardCounts)
    -- body
    self.m_rewardId = rewardId
    self.m_rewardItems = rewardItems
    self.m_rewardItemsPatamCount = rewardItemsParamCount
    self.m_rewardCounts = rewatdCounts

    WZLog("CellPreRechargePanel:setRewardData", Serialize(rewardId), Serialize(rewardItems), Serialize(rewardItemsParamCount), Serialize(rewardCounts))
end

--@brief    显示窗口
function CellPreRechargePanel:showWindow(  )
    if not self.m_root then return end
    
    WZLog("CellPreRechargePanel:showWindow()")
    if not self.m_root then return end
    
    local txt_gotoButton = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    if txt_gotoButton then
        txt_gotoButton:setText(LocalStrings.IMMEDIATELY_RECHARGE)
    end
    local imgBK = GetElement(self.m_root, "imgBK_CellPreRechargePanel", WZUIImage)
    local conTextBK = GetElement(self.m_root, "conTextBK_CellPreRechargePanel", WZUIContainer)
    local btnGoto = GetElement(self.m_root, "btnGoto_CellPreRechargePanel", WZUIButton)
    local txtgotoWord = GetElement(self.m_root, "txtgotoWord_CellPreRechargePanel", WZUILabelTTF)
    local rollconExplanation = self.m_root:getChildElement("rollconExplanation_CellPreRechargePanel")
    local txtDesc1 = GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox)
    local btnRuleInfo = GetElement(self.m_root, "btnRuleInfo_CellPreRechargePanel", WZUIButton)
    -- self.m_context = [[<T C="255,236,193" S="20" P="1">活动时间:每周六(0:00-23:59)</T><BR>5</BR><T C="255,236,193" S="20" P="1">活动内容：活动期间竞技场参与积分赛模式，可获得双倍积分</T>]]

    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_PRERECHARGE then
        --预充
        imgBK:setFile("ui/gameActivity/activity_pic_scflgg.png")
        conTextBK:setVisible(true)
        btnGoto:setVisible(false)
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_ATHLETICSHAPPINESS then
        --竞技了翻天
        imgBK:setFile("ui/gameActivity/activity_pic_jjlft.png")
        -- imgBK:setScaleY(1.02)
        txtgotoWord:setText(LocalStrings.GOTO_ATHLETICS)
        rollconExplanation:setRelativeSize(GlobalMethod:CCSize(0.8,1.6))
        rollconExplanation:updateRelativeSize()
        txtDesc1:setMaxWidth(320)

        GetElement(self.m_root, "btn_getReward_event", WZUIButton):setVisible(false)
        conTextBK:setVisible(false)
        btnGoto:setVisible(true)
        btnRuleInfo:setVisible(true)
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_CHEATSWELFARE then
        --秘境福利
        imgBK:setFile("ui/gameActivity/activity_pic_mjfl.png")
        imgBK:setScaleY(1.02)
        txtgotoWord:setText(LocalStrings.GOTO_SECRETSCENE)
        rollconExplanation:setRelativeSize(GlobalMethod:CCSize(0.68,0.6))
        rollconExplanation:updateRelativeSize()
        txtDesc1:setMaxWidth(320)

        if ProjConfig.LANGUAGE == "en" then
            txtgotoWord:setFontSize(16)
            txtgotoWord:setDimensions(GlobalMethod:CCSize(120,0))
        end

        GetElement(self.m_root, "btn_getReward_event", WZUIButton):setVisible(false)
        conTextBK:setVisible(false)
        btnGoto:setVisible(true)
        btnRuleInfo:setVisible(true)
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_MULDOUBLE then
        --组队双倍
        imgBK:setFile("ui/newActivity/activity_pic_hd_zdsb.png")
        txtgotoWord:setText(LocalStrings.GOTO_MULTIPLECOPY)
        txtDesc1:setMaxWidth(320)

        GetElement(self.m_root, "btn_getReward_event", WZUIButton):setVisible(false)
        conTextBK:setVisible(false)
        btnGoto:setVisible(true)

        if ProjConfig.LANGUAGE == "en" then
            txtgotoWord:setFontSize(20)
        end
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_ELITEDOUBLE then
        --精英双倍
        imgBK:setFile("ui/newActivity/activity_pic_hd_jysb.png")
        txtgotoWord:setText(LocalStrings.GOTO_ELITE)
        txtDesc1:setMaxWidth(420)

        GetElement(self.m_root, "btn_getReward_event", WZUIButton):setVisible(false)
        conTextBK:setVisible(false)
        btnGoto:setVisible(true)
        btnGoto:setRelativePosition(GlobalMethod:ccp(0.9,0.35))
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_FINDDOG then
        --寻找狗二弹
        imgBK:setFile("ui/gameActivity/activity_pic_ged.png")
        imgBK:setScaleY(1.02)
        rollconExplanation:setRelativeSize(GlobalMethod:CCSize(1,0.7))
        rollconExplanation:updateRelativeSize()
        txtDesc1:setMaxWidth(480)

        GetElement(self.m_root, "btn_getReward_event", WZUIButton):setVisible(false)
        conTextBK:setVisible(false)
        btnGoto:setVisible(false)
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_LINECONNECT then
        --红线情缘
        imgBK:setFile("ui/gameActivity/activity_pic_mv.png")
        imgBK:setScaleY(1.02)
        rollconExplanation:setRelativeSize(GlobalMethod:CCSize(1,1.1))
        rollconExplanation:updateRelativeSize()
        txtDesc1:setMaxWidth(480)

        GetElement(self.m_root, "btn_getReward_event", WZUIButton):setVisible(false)
        conTextBK:setVisible(false)
        btnGoto:setVisible(false)
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_RANKPVP_REWARD then
        --排位赛奖励
        imgBK:setFile("ui/newActivity/activity_pic_hd_pws.png")
        txtgotoWord:setText(LocalStrings.ACTIVE_BTN_GO)
        rollconExplanation:setRelativeSize(GlobalMethod:CCSize(1,0.9))
        rollconExplanation:updateRelativeSize()
        txtDesc1:setMaxWidth(320)
        
        GetElement(self.m_root, "btn_getReward_event", WZUIButton):setVisible(false)
        conTextBK:setVisible(false)
        btnGoto:setVisible(true)
        --今日获得
        local tempData = CacheCenter:getGameParam().trioRankMatchRewardConfig
        local tTempInfo = json.decode(tempData)
        WZLog("DDDDDDDDDDDDDDDDDDD", tempData, Serialize(tTempInfo))
        local txtPvpDrop = WZUILabelTTF:create()
        txtPvpDrop:setFontSize(20)
        txtPvpDrop:setColor(GlobalMethod:ccc3(255,255,255))
        txtPvpDrop:setText(string.format(LocalStrings.PVPNEW_TEXT3, self.m_nCount, tTempInfo.limit))
        txtPvpDrop:setRelativePosition(GlobalMethod:ccp(0.158, 0.28))
        self.m_root:addChild(txtPvpDrop, 22, 99)
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_FLOP_CARD then
        imgBK:setFile("ui/gameActivity/activity_pic_zdfpzk.png")
        txtgotoWord:setText(LocalStrings.GOTO_MULTIPLECOPY)
        txtDesc1:setMaxWidth(320)

        GetElement(self.m_root, "btn_getReward_event", WZUIButton):setVisible(false)
        conTextBK:setVisible(true)
        btnGoto:setVisible(true)

        self:setTime()
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_SHOP_LOTTERY then 
        imgBK:setFile("ui/newActivity/activity_pic_hd_scxb.png")
        txtgotoWord:setText(LocalStrings.GOTO_SHOP_LOTTERY)
        rollconExplanation:setVisible(false)
        conTextBK:setVisible(false)
        GetElement(self.m_root, "btn_getReward_event", WZUIButton):setVisible(false)
        btnRuleInfo:setVisible(false)

        btnGoto:setRelativePosition(GlobalMethod:ccp(0.6, 0.35))
        self:setTime()
        self:showSpecificReward()
    end

    self:_setExplainMessage()
end

--@brief    点击Item时回调tips
function CellPreRechargePanel:onOthersClick(luaTable, tag, tData)
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root, 1, tData,false)
end
-------------------------------------公有方法模块End----------------------------------------
--@brief 设置活动说明内容
function CellPreRechargePanel:_setExplainMessage( )
    local txtDesc1 = GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox)
    txtDesc1:setShowText(self.m_context) 
    self:_upMoveContainerLayer()
end

--@brief    更新滚动容器内部布局函数
function CellPreRechargePanel:_upMoveContainerLayer()
    WZLog("self:_upMoveContainerLayer()")
    if self.m_root == nil then
        return
    end
    --获取规则说明内容文本的大小
    local txtExplanation = GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox)
    local txtSize = txtExplanation:getContentSize() 
    txtExplanation:setAnchorPoint(GlobalMethod:ccp(0,1))
    txtExplanation:setPositionY(txtSize.height)
    WZLog("富文本框尺寸是",txtSize.width,txtSize.height)
--
    
    local rollconExplanation = self.m_root:getChildElement("rollconExplanation_CellPreRechargePanel")
    if rollconExplanation == nil then 
        return
    end
    rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
    local rollSize = rollconExplanation:getContentSize()
    --更改滚动容器Element的大小
    local moveElement = rollconExplanation:getMoveElement()
    local size = moveElement:getRelativeSize()
    if (txtSize.height / rollSize.height) > 1 then
        moveElement:setRelativeSize( GlobalMethod:CCSize(1 , txtSize.height / rollSize.height ) )
    end
    rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
    moveElement:setPositionY(rollconExplanation:getMinPosition().y)
    WZLog("滚动容器大小",rollSize.width,rollSize.height)
end

--@brief    显示活动时间
function CellPreRechargePanel:setTime()
    GetElement(self.m_root, "conTime_CellPreRechargePanel", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "txtActivityWord_CellPreRechargePanel", WZUILabelTTF):setText(LocalStrings.ACTIVE_TIME .. ":")
    local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    local format_txt_value = nil 
    format_txt_value = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtLastDay = GetElement(self.m_root, "txtLastDay_CellPreRechargePanel", WZUILabelTTF)
    if txtLastDay ~= nil then 
        txtLastDay:setText(format_txt_value)
    end
end

--@brief    显示特奖预览
function CellPreRechargePanel:showSpecificReward()
    if not self.m_rewardItems then return end
    
    -- body
    GetElement(self.m_root, "conReward_CellPreRechargePanel", WZUIContainer):setVisible(true)
    for i = 1, #self.m_rewardItems do
        local element, tCell = CellGoodItem:createElement()
        local rewardCon = GetElement(self.m_root, "rewardCon" .. i .. "_CellPreRechargePanel", WZUIContainer)
        if element and tCell and rewardCon then 
            rewardCon:setVisible(true)
            local conItem = GetElement(self.m_root, "conItem" .. i .. "_CellPreRechargePanel", WZUIContainer)
            local txtRewardname = GetElement(self.m_root, "txtRewardname" .. i .. "_CellPreRechargePanel", WZUILabelTTF)
            conItem:removeAllChildrenWithCleanup(true)

            txtRewardname:setText(GDatatab_item["id_" .. self.m_rewardItems[i]].name)
            tCell:setCellGoodLocalId(self.m_rewardItems[i], self.m_rewardItemsPatamCount[i], 4)
            tCell:setItemClickFun(self, self.onOthersClick)
            tCell:clearItemQualityPic(true)
            tCell:setNumRelativePosition()
            conItem:addChild(element)
        end
    end
end
-------------------------------------私有方法模块Begin--------------------------------------

function CellPreRechargePanel:_adaptLanguage_en()
    WZLog("CellPreRechargePanel:_adaptLanguage_en")
    local txt_grade_value = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txt_grade_value:setScale(0.9)
    
    local txtgotoWord = GetElement(self.m_root, "txtgotoWord_CellPreRechargePanel", WZUILabelTTF)
    txtgotoWord:setScale(0.8)
end

function CellPreRechargePanel:_adaptLanguage_pt(  )
    local txt_grade_value = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txt_grade_value:setScale(0.9)

    local txtgotoWord = GetElement(self.m_root, "txtgotoWord_CellPreRechargePanel", WZUILabelTTF)
    txtgotoWord:setScale(0.6)
end

function CellPreRechargePanel:_adaptLanguage_tr(  )
    local txtgotoWord = GetElement(self.m_root, "txtgotoWord_CellPreRechargePanel", WZUILabelTTF)
    txtgotoWord:setScale(0.8)
    txtgotoWord:setDimensions(GlobalMethod:CCSize(160))
end
function CellPreRechargePanel:_adaptLanguage_vn(  )
    local txtgotoWord = GetElement(self.m_root, "txtgotoWord_CellPreRechargePanel", WZUILabelTTF)
    txtgotoWord:setScale(0.8)
    GetElement(self.m_root, "txtLastDay_CellPreRechargePanel", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.416,0.5))
end

function CellPreRechargePanel:_adaptLanguage_ug(  )
    local txtgotoWord = GetElement(self.m_root, "txtgotoWord_CellPreRechargePanel", WZUILabelTTF)
    txtgotoWord:setScale(0.5)
    txtgotoWord:setDimensions(GlobalMethod:CCSize(260))
end
-------------------------------------私有方法模块End----------------------------------------
