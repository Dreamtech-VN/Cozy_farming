--CellEatthingsPanel.lua
--@brief	CellEatthingsPanel的UI模块
--@date		2014/12/02
--@author	wuweidong
--@note		吃大餐面板


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellEatthingsPanel:onEnter(element)
	self.m_root = element
    self.m_sLanguage = ProjConfig.LANGUAGE
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellEatthingsPanel:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@breif    显示内容
function CellEatthingsPanel:showWindow(  )
    AdaptLanguage(self)
    self:_initDesc()
    self:_ActivityIsOpen()
end

--@brief    设置活动信息
function CellEatthingsPanel:setActivityReturnInfo(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
    local sTime = os.date("%X", nServerTime)

    self.m_nActivityId = activityId
    self.nServerTime = serverTime
    self.tRewardItemsParamCount = rewardItemsParamCount

    self.bState = -1
    for i = 1, #status do
        if status[i] == 0 then
            self.bState = status[i]
            self.rewardId = i - 1
        end
    end
    if self.rewardId == -1 then
        local hour_clock = os.date("%H", self.nServerTime)
        local nVigorIndex = 1
        if tonumber(hour_clock) < 12 then
            nVigorIndex = 1
        elseif tonumber(hour_clock) >= 14 and tonumber(hour_clock) < 18 then
            nVigorIndex = 2
        elseif tonumber(hour_clock) >= 20 and tonumber(hour_clock) < 21 then
            nVigorIndex = 3
        end
        self.nVigor = self.tRewardItemsParamCount[nVigorIndex]
    else
        self.nVigor = self.tRewardItemsParamCount[self.rewardId + 1]
    end
    WZLog("*********** CellEatthingsPanel:setMessage 1111***********", self.nVigor)

    self.m_root:enableSchedule("calculateTime", 1)
end

function CellEatthingsPanel:calculateTime()
    --body
    if self.nServerTime == nil then return end

    self.nServerTime = self.nServerTime + 1
end

function CellEatthingsPanel:setBtnTouchEnable(bValue)
    -- body
    local btn_eat_oprator = GetElement(self.m_root,"btn_eat_oprator",WZUIButton)
    local btn_too_full = GetElement(self.m_root,"btn_too_full",WZUIButton)
    if btn_eat_oprator == nil or btn_too_full == nil then
        return
    end
    local bIsVisible = false
    if bValue == false then
        bIsVisible = true
    end
    btn_eat_oprator:setVisible(bValue)
    btn_too_full:setVisible(bIsVisible)
end

--@breif    品尝按钮回调
function CellEatthingsPanel:event_touchFunc(  )
    --按钮点击的声音
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local hour_clock = os.date("%H", SystemTime:getServerTime())
    local nVigorIndex = 1
    if tonumber(hour_clock) < 12 then
        nVigorIndex = 1
    elseif tonumber(hour_clock) >= 14 and tonumber(hour_clock) < 18 then
        nVigorIndex = 2
    elseif tonumber(hour_clock) >= 20 then
        nVigorIndex = 3
    end
    nTempAddVigor = self.tRewardItemsParamCount[nVigorIndex]

    if CacheCenter:getPlayerInfo().vigor + nTempAddVigor >= g_nMaxVigor  then
            MsgBoxManager:showTipBox(LocalStrings.TIPS10)
        return 
    end

    WZLog("CellEatthingsPanel:event_touchFunc")
    self.nloadingId = MsgBoxManager:showLoadingBox()

    local hour_clock = os.date("%H", self.nServerTime)
    local rewardId = 0 
    if tonumber(hour_clock) >= 12 and tonumber(hour_clock) < 14 then
        rewardId = 0
    elseif tonumber(hour_clock) >= 18 and tonumber(hour_clock) < 20 then
        rewardId = 1
    elseif tonumber(hour_clock) >= 21 and tonumber(hour_clock) < 24 then
        rewardId = 2
    end

    if self.rewardId == -1 then
        self.rewardId = rewardId
    end

    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId, self.rewardId )
end

--@brief    好饱噢按钮回调
function CellEatthingsPanel:event_btnTooFull(  )
    --按钮点击的声音
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WZLog("CellEatthingsPanel:event_btnTooFull")
    MsgBoxManager:showTipBox(LocalStrings.TASTE_NEXT_TIME)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置文本内容
function CellEatthingsPanel:_initDesc(  )
    WZLog("****** CellEatthingsPanel:_initDesc ******")
    --设置可增加的活力值
    local txtActivityValue1 = GetElement(self.m_root, "txtActivityValue1_CellEatthingsPanel", WZUILabelTTF)
    if not txtActivityValue1 then return end
    GetElement(self.m_root, "txtActivityValue1_CellEatthingsPanel", WZUILabelTTF):setText("+"..self.tRewardItemsParamCount[1])
    GetElement(self.m_root, "txtActivityValue2_CellEatthingsPanel", WZUILabelTTF):setText("+"..self.tRewardItemsParamCount[2])
    GetElement(self.m_root, "txtActivityValue3_CellEatthingsPanel", WZUILabelTTF):setText("+"..self.tRewardItemsParamCount[3])

    if self.rewardId >= 0 then
        local txtEatTime = GetElement(self.m_root, string.format("txtEatTime%d_CellEatthingsPanel", self.rewardId), WZUILabelTTF)
        txtEatTime:setColor(GlobalMethod:ccc3(255, 89, 74))
        txtEatTime:setStrokeColor(GlobalMethod:ccc3(158, 0, 0))
    else
        local hour_clock = os.date("%H", self.nServerTime)
        local nTimeIndex = -1 
        if tonumber(hour_clock) >= 12 and tonumber(hour_clock) < 14 then
            nTimeIndex = 0
        elseif tonumber(hour_clock) >= 18 and tonumber(hour_clock) < 20 then
            nTimeIndex = 1
        elseif tonumber(hour_clock) >= 21 and tonumber(hour_clock) < 24 then
            nTimeIndex = 2
        end

        if nTimeIndex >= 0 then
            local txtEatTime = GetElement(self.m_root, string.format("txtEatTime%d_CellEatthingsPanel", nTimeIndex), WZUILabelTTF)
            txtEatTime:setColor(GlobalMethod:ccc3(255, 89, 74))
            txtEatTime:setStrokeColor(GlobalMethod:ccc3(158, 0, 0))
        end
    end
end


--@breif    判断开启时间
function CellEatthingsPanel:_ActivityIsOpen()
    local btn_eat_oprator = GetElement(self.m_root,"btn_eat_oprator",WZUIButton)
    local btn_too_full = GetElement(self.m_root,"btn_too_full",WZUIButton)
    if btn_eat_oprator == nil or btn_too_full == nil then
        return
    end

    local hour_clock = os.date("%H", self.nServerTime)
    if (tonumber(hour_clock) >= 12 and tonumber(hour_clock) < 14) or (tonumber(hour_clock) >= 18 and tonumber(hour_clock) < 20) or (tonumber(hour_clock) >= 21 and tonumber(hour_clock) < 24) then
        btn_eat_oprator:setVisible(true)
        btn_too_full:setVisible(false)
    else
        btn_eat_oprator:setVisible(false)
        btn_too_full:setVisible(true)
    end

    if self.bState ~= 0 then
        btn_eat_oprator:setVisible(false)
        btn_too_full:setVisible(true)
    else
        btn_eat_oprator:setVisible(true)
        btn_too_full:setVisible(false)
    end

    if CacheCenter.m_tWelfareItemRedDotList ~= nil then
        for idx=1,#CacheCenter.m_tWelfareItemRedDotList do
            if CacheCenter.m_tWelfareItemRedDotList[idx] == self.m_nActivityType then 
                btn_eat_oprator:setVisible(true)
                btn_too_full:setVisible(false)
                break 
            end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
--@brief 简体适配函数
--@note  简体适配
function CellEatthingsPanel:_adaptLanguage_cn()
    local conArmature_CellEatthingsPanel = GetElement(self.m_root, "conArmature_CellEatthingsPanel", WZUIContainer)
    if conArmature_CellEatthingsPanel then
       conArmature_CellEatthingsPanel:setVisible(false)
    end
end
-------------------------------------语言适配模块Start--------------------------------------
--@brief 英文适配函数
--@note  英文适配
function CellEatthingsPanel:_adaptLanguage_en()
    local txtContent = GetElement(self.m_root, "txtContent_CellEatthingsPanel", WZUILabelTTF)
    if txtContent then
        txtContent:setFontSize(18)
        txtContent:setDimensions(GlobalMethod:CCSize(500,0))
    end
    local conActivityTime = GetElement(self.m_root, "conActivityTime_CellEatthingsPanel", WZUIContainer)
    if conActivityTime then
        conActivityTime:setAbsContentSize(GlobalMethod:CCSize(500,50))
        conActivityTime:updateRelativeSize()
    end
    GetElement(self.m_root, "conArmature_CellEatthingsPanel", WZUIContainer):setVisible(false)
end

function CellEatthingsPanel:_adaptLanguage_pt(  )
    local txtContent = GetElement(self.m_root, "txtContent_CellEatthingsPanel", WZUILabelTTF)
    if txtContent then
        txtContent:setFontSize(18)
        txtContent:setDimensions(GlobalMethod:CCSize(500,0))
    end
    local conActivityTime = GetElement(self.m_root, "conActivityTime_CellEatthingsPanel", WZUIContainer)
    if conActivityTime then
        conActivityTime:setAbsContentSize(GlobalMethod:CCSize(500,50))
        conActivityTime:updateRelativeSize()
    end
    local txtFull = GetElement(self.m_root,"txt_toofull",WZUILabelTTF)
    txtFull:setScale(0.55)
end

--@brief 泰文适配函数
--@note  泰文适配
function CellEatthingsPanel:_adaptLanguage_th()
    GetElement(self.m_root, "conArmature_CellEatthingsPanel", WZUIContainer):setVisible(false)
end

function CellEatthingsPanel:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtContent_CellEatthingsPanel",WZUILabelTTF):setFontSize(16)
end

function CellEatthingsPanel:_adaptLanguage_tr(  )
    local txtContent = GetElement(self.m_root, "txtContent_CellEatthingsPanel", WZUILabelTTF)
    if txtContent then
        txtContent:setFontSize(18)
        txtContent:setDimensions(GlobalMethod:CCSize(500,0))
    end
    local txtFull = GetElement(self.m_root,"txt_toofull",WZUILabelTTF)
    txtFull:setScale(0.7)
    txtFull:setDimensions(GlobalMethod:CCSize(160,0))
end

function CellEatthingsPanel:_adaptLanguage_vn()
    local conArmature = GetElement(self.m_root, "conArmature_CellEatthingsPanel", WZUIContainer)
    if conArmature then
        conArmature:setVisible(false)
    end
end

function CellEatthingsPanel:_adaptLanguage_ug(  )
    local txtContent = GetElement(self.m_root, "txtContent_CellEatthingsPanel", WZUILabelTTF)
    if txtContent then
        txtContent:setFontSize(18)
        txtContent:setDimensions(GlobalMethod:CCSize(500,0))
    end
    local txtFull = GetElement(self.m_root,"txt_toofull",WZUILabelTTF)
    txtFull:setScale(0.7)
    txtFull:setDimensions(GlobalMethod:CCSize(160,0))
    GetElement(self.m_root,"txt_eatingAction_nor",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txt_eatingAction_sel",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txt_eatingAction_dis",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配模块End----------------------------------------