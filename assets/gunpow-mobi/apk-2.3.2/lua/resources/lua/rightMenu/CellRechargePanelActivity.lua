--CellRechargePanelActivity.lua
--@brief	CellRechargePanelActivity的UI模块
--@date		2014/12/02
--@author	wuweidong
--@note		首冲活动面板


-------------------------------------公有方法模块Begin--------------------------------------
local tCustomUIConfig_Activity = {LocalStrings.REWARD_BTN_GET} --messagebox里的确定按钮改为充值按钮
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRechargePanelActivity:onEnter(element)
	self.m_root = element
    --self.m_root:enableSchedule("scheduleUpdateTime", 0.02)
	WZLog("CellRechargePanelActivity:onEnter",self.m_root~=nil)
	WindowManagerAni:createAppearAction(self.m_root, true, "onEnterFinish", self)
    AdaptLanguage(self)
end

function CellRechargePanelActivity:show()
    if not GlobalGame.g_bIsGetFirstRecharge then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return 
    end
    local wnd = CellRechargePanelActivity:createElement()
    WindowManager:addWindow(wnd, CellRechargePanelActivity, true)
end

function CellRechargePanelActivity:onEnterFinish()
    WZTempLog("******* CellRechargePanelActivity:onEnterFinish *******",CacheCenter:getPlayerInfo().vipLevel)
	if CacheCenter:getPlayerInfo().vipLevel <= 0 then
		self:setFirstRecharge()
	end
	self:createLoading()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo()
end

function CellRechargePanelActivity:onClose()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManager:removeWindow(self.m_root , self , true)
end

function CellRechargePanelActivity:onTouchBegan(element,pt)
	if WndItemInfo.m_root ~= nil then
		WndItemInfo:onCloseClick()
	end
end 

function CellRechargePanelActivity:getInfoOk(activityId, title, startTime, endTime, serverTime , types, type2)
	WZLog("CellRechargePanelActivity:getInfoOk",Serialize(types))
	for i=1,#types do
		if types[i] == g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE2 then
            self.activityId = activityId[i]
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(activityId[i],g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE2)
			break
		end
	end
end

function CellRechargePanelActivity:getDetailInfoOk(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	WZLog("CellRechargePanelActivity:getDetailInfoOk")
    if self.activityId and self.activityId ~= activityId then return end 

	self:closeLoading()
	self:setMessage(content,status,rewardItems,activityId,rewardId, rewardCounts, target, rewardItemsParamCount)
	self:showWindow()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRechargePanelActivity:onExit(element)
    self.m_root:disableSchedule()

    local isText = self.m_bIsText
	self:_unInit()

    WZLog("CellRechargePanelActivity:onExit one", tostring(isText), tostring(GlobalGame.g_checkLoginActivities), tostring(SceneCity.m_root))
    if isText and GlobalGame.g_checkLoginActivities and SceneCity.m_root then
        WZLog("CellRechargePanelActivity:onExit two")
        SceneCity:JoinByLogin()
    end
end

--@brief 坐标
function CellRechargePanelActivity:CheckPoint( Pt )
    WZLog("CellRechargePanelActivity:CheckPoint")
    local rollcon_CellRechargePanel = GetElement(CellRechargePanelActivity.m_current.m_root,"rollcon_CellRechargePanel",WZUIScrollContainer)
    local point =  rollcon_CellRechargePanel:convertToNodeSpace(Pt)
    local startX = rollcon_CellRechargePanel:getPositionX()-(rollcon_CellRechargePanel:getContentSize().width/2)
    local endX = rollcon_CellRechargePanel:getPositionX()+(rollcon_CellRechargePanel:getContentSize().width/2)
    local startY = rollcon_CellRechargePanel:getPositionY()-(rollcon_CellRechargePanel:getContentSize().height/2)
    local endY = rollcon_CellRechargePanel:getPositionY()+(rollcon_CellRechargePanel:getContentSize().height/2)
    if (point.x > startX and point.x <= endX) and (point.y>startY and point.y<=endY) then 
        return true
    end 
    return false
end

function CellRechargePanelActivity:scheduleUpdateTime( element, data )
    -- if wndActivityOnLine.b_AutoMove and self.b_needAutoMove  then
    --     --WZLog("=====")
    --     local rollcon_CellRechargePanel = GetElement(self.m_root,"rollcon_CellRechargePanel",WZUIScrollContainer)
    --     if rollcon_CellRechargePanel == nil then
    --         WZLog("rollcon_CellRechargePanel is nil...")
    --         return
    --     end
    --     local moveElement = rollcon_CellRechargePanel:getMoveElement()
    --     if self.MaxMoveY+rollcon_CellRechargePanel:getMinPosition().y >moveElement:getPositionY() then 
    --         --self.MaxMoveY = self.MaxMoveY - 5
    --         local PointY = moveElement:getPositionY() + 2
    --         moveElement:setPositionY(PointY)
    --     else 
    --         --self.MaxMoveY=self.CaCheMaxMoveY
    --         moveElement:setPositionY(rollcon_CellRechargePanel:getMinPosition().y)
    --     end
    -- end 
end

--@brief    初始化信息
function CellRechargePanelActivity:setMessage( txtContext ,status ,rewardItems,activityId,rewardId, rewardCounts, target, rewardItemsParamCount)

    self.m_context = txtContext
    self.b_status = status
    self.m_trewardItems = rewardItems --所有奖励
    self.activityId = activityId
    self.rewardId = rewardId
    self.m_rewardCounts = rewardCounts   --首充奖励数量，再冲数量，再冲数量
    self.m_target = target --总量进度
    self.m_rewardItemsParamCount = rewardItemsParamCount --当前充值数量

    WZLog("CellRechargePanelActivity:setMessage()", Serialize(self.b_status), Serialize(self.m_trewardItems), Serialize(self.m_target), Serialize(self.rewardId), Serialize(self.m_rewardCounts), Serialize(self.m_rewardItemsParamCount), self.activityId)
end

--@brief    显示窗口
function CellRechargePanelActivity:showWindow(  )
    WZLog("CellRechargePanelActivity:showWindow()")
    self.m_nPetGift = tonumber(CacheCenter:getGameParam()["firstRechargeGainPetGift"])

	GetElement(self.m_root,"btnRule",WZUIButton):setVisible(true)
    self:showBtnState()
    self:showBK()
    self:_setExplainMessage()
    self:_rollContainerLayer()
    self:_updateRewardItems()
end


--@brief    领取按钮事件
function CellRechargePanelActivity:RechargeEvent(  )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local bRecharge = true 
    local nIndex = 1
    for i = 1, #self.b_status do
        if self.b_status[i] == 0 then
            bRecharge = false
            nIndex = i
            break 
        elseif self.b_status[i] == -1 then
            bRecharge = true
            break 
        end
    end

    if bRecharge then 
        PassportSdkManager:gotoPaymentPage()
    else 
        --背包已满提示
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        self.m_nLoadingId0 = MsgBoxManager:showLoadingBox()
        CellRechargePanelActivity.m_current_click = self
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.activityId, self.rewardId[nIndex] )
    end 

end

--@brief    前往充值按钮事件
function CellRechargePanelActivity:RechargeForPayEvent(nId,nType)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if nType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end


--@brief    显示物品结果信息
--@parmas   itemId 物品Id  0为首充
function CellRechargePanelActivity:showRewardBox(rewardType,itemsId,count)
    MsgBoxManager:removeMsgById(CellRechargePanelActivity.m_current_click.m_nLoadingId0)
    local ItemsInfo_vsNum = {}
    local tablecount = #count
    WZLog("WndReward:showRewardBox:tablecount="..tablecount)
    for i=1,tablecount do
        local Num = 0
        Num = count[i]
        WZLog("itemInfo msg::"..count[i])
        table.insert(ItemsInfo_vsNum,Num)
    end
    WndRewardShow:showById(itemsId,ItemsInfo_vsNum)
    if 0 == rewardType then    --首冲物品显示
        if CellRechargePanelActivity.m_current_click == nil then
            return
        end
        WndRewardShow:closeCallBack(CellRechargePanelActivity.m_current_click,CellRechargePanelActivity.m_current_click._GameFirstRecharge, _G, pushEquipInList) 
    end

	if self.b_status[1] == 1 and self.b_status[2] == 1 and self.b_status[3] == 1 then
    	WindowManager:removeWindow(self.m_root , self , true)
	end
end

--回调函数
function CellRechargePanelActivity:_GameFirstRecharge(  )
    WZLog("CellRechargePanelActivity:_GameFirstRecharge")
    local btn_getReward_event = GetElement(self.m_root,"btn_getReward_event",WZUIButton)
    if btn_getReward_event == nil then
        return
    end

    local nIndex = 1
    for i = 1, #self.b_status do
        if self.b_status[i] == 0 then
            self.b_status[i] = 1
            nIndex = i + 1
        end
    end
    if nIndex > #self.b_status then
        btn_getReward_event:setTouchEnable(false)
		--关闭窗口
        --移除首充活动,重新获取活动列表
        --WndGameActivity:actionCallback()
		local spine = GetElement(self.m_root,"spine",WZUISpine)
		spine:setVisible(false)
    	WindowManager:removeWindow(self.m_root , self , true)
    else
        self:showWindow()
    end
end

function CellRechargePanelActivity:setFirstRecharge()
	local bg_Cell = GetElement(self.m_root,"bg_Cell",WZUIImage)
	local tbCon = GetElement(self.m_root,"tbCon_activty_forRecharge",WZUITableContainer)
	local conBtn = GetElement(self.m_root,"conBtn",WZUIContainer)
    local img1 = GetElement(self.m_root, "img1_CellRechargePanelActivity", WZUIImage)
    local img2 = GetElement(self.m_root, "img2_CellRechargePanelActivity", WZUIImage)
	local text1 = GetElement(self.m_root,"freeText_CellRechargePanelActivity",WZUIFreeTextBox)
    local conProgress = GetElement(self.m_root, "conProgress_CellRechargePanelActivity", WZUIContainer)
    local txtCurRecharge = GetElement(self.m_root, "txtCurRecharge_CellRechargePanelActivity", WZUIFreeTextBox)

	bg_Cell:setVisible(true)
	conBtn:setVisible(true)
			bg_Cell:setFile("ui/gameActivity/huodong_di.png")
			img1:setFile("ui/gameActivity/huodong_sc.png")
			img2:setFile("ui/gameActivity/huodong_baby.png")
			text1:setShowText(LocalStrings.SHOUCHONG1)
			bg_Cell:setRelativePosition(GlobalMethod:ccp(0.615,0.485))
			tbCon:setRelativePosition(GlobalMethod:ccp(0.5,0))
			conBtn:setRelativePosition(GlobalMethod:ccp(0.587024,-0.0193969))
			img1:setRelativePosition(GlobalMethod:ccp(0.469542,0.755891))
			img2:setRelativePosition(GlobalMethod:ccp(0.08,0.55))
			text1:setRelativePosition(GlobalMethod:ccp(0.24,0.62))
            conProgress:setVisible(false)
            txtCurRecharge:setVisible(false)
            if ProjConfig.LANGUAGE == "th" then
                img1:setRelativePosition(GlobalMethod:ccp(0.68,0.755891))
                img1:setScale(0.8)
            elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
                img1:setRelativePosition(GlobalMethod:ccp(0.68,0.755891))
                img1:setScale(0.6)
            end
            if ProjConfig.LANGUAGE == "vn" then
                img2:setFile("ui/gameActivity/huodong_baby2.png")
                img2:setRelativePosition(GlobalMethod:ccp(0,0.55))
                img1:setRelativePosition(GlobalMethod:ccp(0.68,0.755891))
                img1:setScale(0.8)
                text1:setScale(0.7)
                text1:setMaxWidth(700)
                txtCurRecharge:setScale(0.7)
            end

    WZLog("CellRechargePanelActivity:setFirstRecharge one", self.m_bIsText)
    if self.m_bIsText then
        WZLog("CellRechargePanelActivity:setFirstRecharge two")
        WindowManager:addTipForButton(GetElement(self.m_root, "img2_CellRechargePanelActivity", WZUIImage), 0.35, 
        BattleCommon:getPointTable(-2000,0), LocalStrings.FIRST_RECHARGE_TALK or "", 
        3, BattleCommon:getPointTable(330,220), "4.2", nil, nil, true)
    end
end

--@brief    设置相应的背景
function CellRechargePanelActivity:showBK()
    -- body
	local bg_Cell = GetElement(self.m_root,"bg_Cell",WZUIImage)
	local tbCon = GetElement(self.m_root,"tbCon_activty_forRecharge",WZUITableContainer)
	local conBtn = GetElement(self.m_root,"conBtn",WZUIContainer)
    local img1 = GetElement(self.m_root, "img1_CellRechargePanelActivity", WZUIImage)
    local img2 = GetElement(self.m_root, "img2_CellRechargePanelActivity", WZUIImage)
	local text1 = GetElement(self.m_root,"freeText_CellRechargePanelActivity",WZUIFreeTextBox)
    local conProgress = GetElement(self.m_root, "conProgress_CellRechargePanelActivity", WZUIContainer)
    local txtCurRecharge = GetElement(self.m_root, "txtCurRecharge_CellRechargePanelActivity", WZUIFreeTextBox)

	bg_Cell:setVisible(true)
	conBtn:setVisible(true)
        if self.b_status[1] and (self.b_status[1] == -1 or self.b_status[1] == 0) then
			bg_Cell:setFile("ui/gameActivity/huodong_di.png")
			img1:setFile("ui/gameActivity/huodong_sc.png")
			img2:setFile("ui/gameActivity/huodong_baby.png")
			text1:setShowText(LocalStrings.SHOUCHONG1)
			bg_Cell:setRelativePosition(GlobalMethod:ccp(0.615,0.485))
			tbCon:setRelativePosition(GlobalMethod:ccp(0.5,0))
			conBtn:setRelativePosition(GlobalMethod:ccp(0.587024,-0.0193969))
			img1:setRelativePosition(GlobalMethod:ccp(0.469542,0.755891))
			img2:setRelativePosition(GlobalMethod:ccp(0.08,0.55))
			text1:setRelativePosition(GlobalMethod:ccp(0.24,0.62))
            conProgress:setVisible(false)
            txtCurRecharge:setVisible(false)
            if ProjConfig.LANGUAGE == "vn" then
                img2:setFile("ui/gameActivity/huodong_baby2.png")
                img2:setRelativePosition(GlobalMethod:ccp(0,0.55))
            end
        elseif self.b_status[2] and (self.b_status[2] == -1 or self.b_status[2] == 0) then
			bg_Cell:setFile("ui/gameActivity/huodong_di2.png")
			img1:setFile("ui/gameActivity/huodong_xc1.png")
			img2:setFile("ui/gameActivity/huodong_lb.png")
			text1:setShowText(string.format(LocalStrings.SHOUCHONG2,tostring(self.m_target[2])))
			bg_Cell:setRelativePosition(GlobalMethod:ccp(0.615,0.48))
			tbCon:setRelativePosition(GlobalMethod:ccp(0.5,-0.2))
			conBtn:setRelativePosition(GlobalMethod:ccp(0.615307,-0.0812854))
			img1:setRelativePosition(GlobalMethod:ccp(0.471717,0.78))
			img2:setRelativePosition(GlobalMethod:ccp(-0.015,0.5))
			text1:setRelativePosition(GlobalMethod:ccp(0.24,0.644109))
            conProgress:setVisible(true)
            txtCurRecharge:setVisible(true)
            local progCostProgress = GetElement(self.m_root, "progCostProgress_CellRechargePanelActivity", WZUIProgress)
            local txtCurCostValue = GetElement(self.m_root, "txtCurCostValue_CellRechargePanelActivity", WZUILabelTTF)
            progCostProgress:setPercentage(math.floor(100 * self.m_rewardItemsParamCount[2]/self.m_target[2]))
            txtCurCostValue:setText(self.m_rewardItemsParamCount[2].."/"..self.m_target[2])
			txtCurRecharge:setShowText(string.format(LocalStrings.SHOUCHONG4,tostring(self.m_rewardItemsParamCount[2])))
			conProgress:setRelativePosition(GlobalMethod:ccp(0.74,0.363857))
			if tonumber(self.m_rewardItemsParamCount[2]) >= 100 then
				conProgress:setRelativePosition(GlobalMethod:ccp(0.75,0.363857))
			end
			if tonumber(self.m_rewardItemsParamCount[2]) >= 1000 then
				conProgress:setRelativePosition(GlobalMethod:ccp(0.78,0.363857))
			end
			if tonumber(self.m_rewardItemsParamCount[2]) >= 10000 then
				conProgress:setRelativePosition(GlobalMethod:ccp(0.8,0.363857))
			end
			if tonumber(self.m_rewardItemsParamCount[2]) >= 100000 then
				conProgress:setRelativePosition(GlobalMethod:ccp(0.82,0.363857))
			end
			if tonumber(self.m_rewardItemsParamCount[2]) >= 1000000 then
				conProgress:setRelativePosition(GlobalMethod:ccp(0.83,0.363857))
			end
            if ProjConfig.LANGUAGE == "vn" then
                img1:setRelativePosition(GlobalMethod:ccp(0.68,0.8))
                img1:setScale(0.8)
                conProgress:setRelativePosition(GlobalMethod:ccp(0.88,0.363857))
            end
        elseif self.b_status[3] and (self.b_status[3] == -1 or self.b_status[3] == 0) then
			bg_Cell:setFile("ui/gameActivity/huodong_di2.png")
			img1:setFile("ui/gameActivity/huodong_xc2.png")
			img2:setFile("ui/gameActivity/huodong_girl.png")
			text1:setShowText(string.format(LocalStrings.SHOUCHONG3,tostring(self.m_target[3])))
			bg_Cell:setRelativePosition(GlobalMethod:ccp(0.615,0.48))
			tbCon:setRelativePosition(GlobalMethod:ccp(0.5,-0.2))
			conBtn:setRelativePosition(GlobalMethod:ccp(0.615307,-0.0812854))
			img1:setRelativePosition(GlobalMethod:ccp(0.515,0.762791))
			img2:setRelativePosition(GlobalMethod:ccp(0.065,0.6))
			text1:setRelativePosition(GlobalMethod:ccp(0.24,0.644109))
			if CacheCenter:getPlayerInfo().sex == 0 then
				img1:setRelativePosition(GlobalMethod:ccp(0.515,0.762791))
				img2:setFile("ui/gameActivity/huodong_boy.png")
				img2:setRelativePosition(GlobalMethod:ccp(0.065,0.6))
			end
            conProgress:setVisible(true)
            txtCurRecharge:setVisible(true)
            --进度
			--self.m_rewardItemsParamCount[3] = 8888888
            local progCostProgress = GetElement(self.m_root, "progCostProgress_CellRechargePanelActivity", WZUIProgress)
            local txtCurCostValue = GetElement(self.m_root, "txtCurCostValue_CellRechargePanelActivity", WZUILabelTTF)
            progCostProgress:setPercentage(math.floor(100 * self.m_rewardItemsParamCount[3]/self.m_target[3]))
            txtCurCostValue:setText(self.m_rewardItemsParamCount[3].."/"..self.m_target[3])
			txtCurRecharge:setShowText(string.format(LocalStrings.SHOUCHONG4,tostring(self.m_rewardItemsParamCount[3])))
			conProgress:setRelativePosition(GlobalMethod:ccp(0.74,0.363857))
			if tonumber(self.m_rewardItemsParamCount[3]) >= 100 then
				conProgress:setRelativePosition(GlobalMethod:ccp(0.75,0.363857))
			end
			if tonumber(self.m_rewardItemsParamCount[3]) >= 1000 then
				conProgress:setRelativePosition(GlobalMethod:ccp(0.78,0.363857))
			end
			if tonumber(self.m_rewardItemsParamCount[3]) >= 10000 then
				conProgress:setRelativePosition(GlobalMethod:ccp(0.8,0.363857))
			end
			if tonumber(self.m_rewardItemsParamCount[3]) >= 100000 then
				conProgress:setRelativePosition(GlobalMethod:ccp(0.82,0.363857))
			end
			if tonumber(self.m_rewardItemsParamCount[3]) >= 1000000 then
				conProgress:setRelativePosition(GlobalMethod:ccp(0.83,0.363857))
			end
            if ProjConfig.LANGUAGE == "vn" then
                img1:setRelativePosition(GlobalMethod:ccp(0.7,0.762791))
                img1:setScale(0.8)
                conProgress:setRelativePosition(GlobalMethod:ccp(0.88,0.363857))
            end
        end
    if ProjConfig.LANGUAGE == "th" then
        img1:setRelativePosition(GlobalMethod:ccp(0.68,0.78))
        img1:setScale(0.8)
    elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
        img1:setRelativePosition(GlobalMethod:ccp(0.68,0.755891))
        img1:setScale(0.6)
        txtCurRecharge:setScale(0.6)
        text1:setMaxWidth(550)
    elseif ProjConfig.LANGUAGE == "vn" then
        img1:setRelativePosition(GlobalMethod:ccp(0.68,0.78))
        img1:setScale(0.8)
        text1:setScale(0.7)
        text1:setMaxWidth(700)
        txtCurRecharge:setScale(0.7)
    end
end

--@brief    显示按钮状态
function CellRechargePanelActivity:showBtnState()
    -- body
    local txt_gotoButton = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    local txt_gotoButton1 = GetElement(self.m_root,"txt_gotoButton1",WZUILabelTTF)
    local txt_gotoButton2 = GetElement(self.m_root,"txt_gotoButton2",WZUILabelTTF)
    -- if self.b_status[1] == -1 then
    --     txt_gotoButton:setText(LocalStrings.IMMEDIATELY_RECHARGE)
    -- elseif self.b_status[1] == 0 then 
    --     txt_gotoButton:setText(LocalStrings.GET_REWARD)
    -- elseif self.b_status[1] == 1 then
    --     if self.b_status[2] == -1 then
    --         txt_gotoButton:setText(LocalStrings.IMMEDIATELY_RECHARGE)
    --     elseif self.b_status[2] == 0 then 
    --         txt_gotoButton:setText(LocalStrings.GET_REWARD)
    --     elseif self.b_status[2] == 1 then
    --         if self.b_status[3] == -1 then
    --             txt_gotoButton:setText(LocalStrings.IMMEDIATELY_RECHARGE)
    --         elseif self.b_status[3] == 0 then 
    --             txt_gotoButton:setText(LocalStrings.GET_REWARD)
    --         elseif self.b_status[3] == 1 then
    --             txt_gotoButton:setText(LocalStrings.IMMEDIATELY_RECHARGE)
    --         end
    --     end
    -- end
    for i = 1, #self.b_status do
        if self.b_status[i] == -1 then
            txt_gotoButton:setText(LocalStrings.IMMEDIATELY_RECHARGE)
            txt_gotoButton1:setText(LocalStrings.IMMEDIATELY_RECHARGE)
            txt_gotoButton2:setText(LocalStrings.IMMEDIATELY_RECHARGE)
            break 
        elseif self.b_status[i] == 0 then 
            txt_gotoButton:setText(LocalStrings.GET_REWARD) 
            txt_gotoButton1:setText(LocalStrings.GET_REWARD) 
            txt_gotoButton2:setText(LocalStrings.GET_REWARD) 
            break 
        else

        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    奖励物品表
function CellRechargePanelActivity:_updateRewardItems(  )
    local tbCon_activty_forRecharge = GetElement(self.m_root,"tbCon_activty_forRecharge",WZUITableContainer)
    if tbCon_activty_forRecharge == nil then
        WZLog("tbCon_activty_forRecharge is nil")
        return
    end
    tbCon_activty_forRecharge:cleanTable()
    local nIndex = #self.b_status
    for i = 1, #self.b_status do
        if self.b_status[i] == -1 or self.b_status[i] == 0 then
            nIndex = i
            break 
        end
    end

    local count = self.m_rewardCounts[nIndex]

    WZLog("CellRechargePanelActivity:_updateRewardItems=="..nIndex)
    local idx = 1
    for j = 1, nIndex - 1 do
        idx = idx + self.m_rewardCounts[j] * 2
    end

    for i=1,count do
		if self.m_trewardItems ~= nil and self.m_trewardItems[idx] ~= nil then
        local key = "id_"..self.m_trewardItems[idx]
        local num = self.m_trewardItems[idx + 1]
        WZLog("------"..key)
        local celElement,tLuaObj = CellGoodItem:createElement()
		celElement:setScale(0.85)
        if celElement ~= nil then 
            celElement = WZUIContainer:luaTo(celElement)
            if 27 == self.m_trewardItems[idx] then
                local itemInfo = {id = self.m_trewardItems[idx], name="",icon="ui/bottomMenu/pay/payment_first.png",lastTime=0,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
                tLuaObj:setCellGoodItem(itemInfo,5)
                tLuaObj:setItemClickFun(self,self.onOthersClick)
            elseif self.m_trewardItems[idx] == 11013 then
                local petinfo = {
                    ["4"]=GDatatab_item[key].property[3][2],
                    ["commonSkill1"]=0,
                    ["10"]=0,
                    ["5"]=0,
                    ["animation"]=GDatatab_item[key].animation_index_code,
                    ["12"]=0,
                    ["7"]=0,
                    ["18"]=0,
                    ["quality"]=3,
                    ["itemId"]=self.m_trewardItems[idx],
                    ["19"]=0,
                    ["11"]=0,
                    ["icon"]=GDatatab_item[key].icon,
                    ["commonSkill2"]=0,
                    ["9"]=0,
                    ["upgradeLevel"]=1,
                    ["fighting"]=0,
                    ["inbornSkill"]=93,
                    ["gift"]=self.m_nPetGift * 100,
                    ["1"]=GDatatab_item[key].property[1][2],
                    ["3"]=GDatatab_item[key].property[2][2],
                    ["13"]=0,
                    ["advancedLevel"]=0,
                    ["14"]=0,
                    ["name"]=GDatatab_item[key].name,
                    ["20"]=0,
                }
                for key, value in pairs(GDatatab_pet) do
                    if value.item_id == self.m_trewardItems[idx] then
                        petinfo["1"] = petinfo["1"] + math.floor(value.property[1][2]/100)
                        petinfo["3"] = petinfo["3"] + math.floor(value.property[2][2]/100)
                        petinfo["4"] = petinfo["4"] + math.floor(value.property[3][2]/100)
                        break 
                    end
                end
                --计算战力用的
                local petHP2 = math.ceil(petinfo["1"]*petinfo["gift"]/10000)
                local petAttack2 = math.ceil(petinfo["3"]*petinfo["gift"]/10000)
                local petDefense2 = math.ceil(petinfo["4"]*petinfo["gift"]/10000)
                local fighting = math.floor((petHP2+4.8*petAttack2+6*petDefense2)*0.75)

                petinfo["fighting"] = fighting
                local itemInfo = {id = self.m_trewardItems[idx], name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key]),petInfo=petinfo}
                tLuaObj:setCellGoodItem(itemInfo,17)
                tLuaObj:setItemClickFun(self,self.onClickPet)
            else
                local itemInfo = {id = self.m_trewardItems[idx], name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
                tLuaObj:setCellGoodItem(itemInfo,17)
                 tLuaObj:setItemClickFun(self,self.onOthersClick)
            end
            celElement:setTag(i-1)
            tbCon_activty_forRecharge:setCellElement(celElement)
        end

		end
        idx = idx + 2
    end
end

--@brief    其它Item点击回调
function CellRechargePanelActivity:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief    其它Item点击回调
function CellRechargePanelActivity:onClickPet(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndTips:onCloseClick()
    WndTips:show(luaTable.m_root,self.m_root,13,tData.petInfo,GlobalMethod:ccp(430,40))
end


--@brief 设置按钮状态
function CellRechargePanelActivity:setButtonStates( bState )
    local btn_getReward_event = GetElement(CellRechargePanelActivity.m_current.m_root,"btn_getReward_event",WZUIButton)
	local spine = GetElement(self.m_root,"spine",WZUISpine)
    if btn_getReward_event == nil then
        return
    end
    if bState then
        btn_getReward_event:setTouchEnable(bState)
		spine:setVisible(bState)
    else
        btn_getReward_event:setTouchEnable(bState)
		spine:setVisible(bState)
    end
end

--@brief 设置按钮状态
function CellRechargePanelActivity:_setButtonStates( bState )
    local btn_getReward_event = GetElement(self.m_root,"btn_getReward_event",WZUIButton)
	local spine = GetElement(self.m_root,"spine",WZUISpine)
    if btn_getReward_event == nil then
        return
    end
    if bState then
        btn_getReward_event:setTouchEnable(bState)
		spine:setVisible(bState)
    else
        btn_getReward_event:setTouchEnable(bState)
		spine:setVisible(bState)
    end
end

--@brief 设置活动说明内容
function CellRechargePanelActivity:_setExplainMessage( )
    
end


--@brief    文字滚动层
function CellRechargePanelActivity:_rollContainerLayer()
    
end

function CellRechargePanelActivity:onRuleClick() 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local msg = LocalStrings["FIRST_CHARGE_RULE"]
  	WndSingleMapDesc:showInterface(msg)
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Start--------------------------------------
--@brief 英文适配函数
--@note  英文适配
function CellRechargePanelActivity:_adaptLanguage_en()
    GetElement(self.m_root, "txt_gotoButton", WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root, "txt_gotoButton1", WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root, "txt_gotoButton2", WZUILabelTTF):setScale(0.75)

    local freeText = GetElement(self.m_root,"freeText_CellRechargePanelActivity",WZUIFreeTextBox)
    freeText:setScale(0.7)
end

function CellRechargePanelActivity:_adaptLanguage_pt(  )
    GetElement(self.m_root, "txt_gotoButton", WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root, "txt_gotoButton1", WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root, "txt_gotoButton1", WZUILabelTTF):setScale(0.75)
    
    local freeText = GetElement(self.m_root,"freeText_CellRechargePanelActivity",WZUIFreeTextBox)
    freeText:setScale(0.7)
end

--@brief 西语适配函数
--@note  西语适配
function CellRechargePanelActivity:_adaptLanguage_es()
    local txt = GetElement(self.m_root, "txt_gotoButton", WZUILabelTTF)
    txt:setScale(0.75)
    txt:setDimensions(GlobalMethod:CCSize(130,0))

    local txt1 = GetElement(self.m_root, "txt_gotoButton1", WZUILabelTTF)
    txt1:setScale(0.75)
    txt1:setDimensions(GlobalMethod:CCSize(130,0))

    local txt2 = GetElement(self.m_root, "txt_gotoButton1", WZUILabelTTF)
    txt2:setScale(0.75)
    txt2:setDimensions(GlobalMethod:CCSize(130,0))

    local freeText = GetElement(self.m_root,"freeText_CellRechargePanelActivity",WZUIFreeTextBox)
    freeText:setScale(0.7)
end

function CellRechargePanelActivity:_adaptLanguage_th()
    local freeText = GetElement(self.m_root,"freeText_CellRechargePanelActivity",WZUIFreeTextBox)
    freeText:setScale(0.7)
end

function CellRechargePanelActivity:_adaptLanguage_tr(  )
    local txtCurRecharge = GetElement(self.m_root, "txtCurRecharge_CellRechargePanelActivity", WZUIFreeTextBox)
    local freeText = GetElement(self.m_root,"freeText_CellRechargePanelActivity",WZUIFreeTextBox)
    freeText:setScale(0.7)

    GetElement(self.m_root, "txt_gotoButton", WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root, "txt_gotoButton1", WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root, "txt_gotoButton2", WZUILabelTTF):setScale(0.75)
end

function CellRechargePanelActivity:_adaptLanguage_vn()
    GetElement(self.m_root, "txt_gotoButton", WZUILabelTTF):setScale(0.85)
    GetElement(self.m_root, "txt_gotoButton1", WZUILabelTTF):setScale(0.85)
    GetElement(self.m_root, "txt_gotoButton2", WZUILabelTTF):setScale(0.85)
end

function CellRechargePanelActivity:_adaptLanguage_ug(  )
    local txtCurRecharge = GetElement(self.m_root, "txtCurRecharge_CellRechargePanelActivity", WZUIFreeTextBox)
    txtCurRecharge:setScale(0.6)
    txtCurRecharge:setMaxWidth(200)
    txtCurRecharge:setRelativePosition(GlobalMethod:ccp(0.24,0.58))
    local freeText = GetElement(self.m_root,"freeText_CellRechargePanelActivity",WZUIFreeTextBox)
    freeText:setScale(0.6)
    freeText:setMaxWidth(700)
    freeText:setRelativePosition(GlobalMethod:ccp(0.23,0.62))

    local gotoButton = GetElement(self.m_root, "txt_gotoButton", WZUILabelTTF)
    gotoButton:setScale(0.65)
    gotoButton:setDimensions(GlobalMethod:CCSize(190))
    local gotoButton1 = GetElement(self.m_root, "txt_gotoButton1", WZUILabelTTF)
    gotoButton1:setScale(0.65)
    gotoButton1:setDimensions(GlobalMethod:CCSize(190))
    local gotoButton2 = GetElement(self.m_root, "txt_gotoButton2", WZUILabelTTF)
    gotoButton2:setScale(0.65)
    gotoButton2:setDimensions(GlobalMethod:CCSize(190))
end
-------------------------------------语言适配模块End----------------------------------------
