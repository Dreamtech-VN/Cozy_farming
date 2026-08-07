--CellOrderRedPack.lua
--@brief	CellOrderRedPack的UI模块
--@date		2018/06/02
--@author	Tianxiang_Xu
--@note		口令红包-代言人模板


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellOrderRedPack:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellOrderRedPack:onExit(element)
	self:_unInit()
end

--@brief    点击前往按钮回调
function CellOrderRedPack:onClickGoTo(element)
    WZLog("CellOrderRedPack:onClickGoTo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not WndApartmentAct:_activityIsExit(g_tGameActivityTypes.ACTIVITY_ORDERREDPACK) then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return
    end

    local txtOverTip = GetElement(self.m_root,"txtOverTip_CellOrderRedPack",WZUILabelTTF)
    local tempText = txtOverTip:isVisible() and txtOverTip:getText() or ""
    WndChat:showChatWindowForFightingByOrder(CHANNEL_WORLD, tempText)
    
    WndApartmentAct:closeWindow()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellOrderRedPack:_update()
	-- body
	local txtOverTip = GetElement(self.m_root,"txtOverTip_CellOrderRedPack",WZUILabelTTF)
    local maxTip = #self.tips
    local indexxx = math.random(1, maxTip)
    txtOverTip:setText(self.tips[indexxx])

    local txtRedboxTip = GetElement(self.m_root,"txtRedboxTip_CellOrderRedPack",WZUILabelTTF)
    local temp = string.format(LocalStrings.REDPACK_ATT22, self.maxCount - self.count,self.maxCount)
    txtRedboxTip:setText(temp)

    local txtRedboxTime = GetElement(self.m_root,"txtRedboxTime_CellOrderRedPack",WZUILabelTTF)
    local startTimedd = SystemTime:getTimeConverLocal1(self.startTime)

    local endTimeddd = SystemTime:getTimeConverLocal1(self.endTime)
    txtRedboxTime:setText(startTimedd .. "-" .. endTimeddd)
    self.m_nRewardCounts = self.rewardCounts[1]
    local conGoToChat = GetElement(self.m_root,"conGoToChat_CellOrderRedPack",WZUIContainer)
    local txtOverTip = GetElement(self.m_root,"txtOverTip_CellOrderRedPack",WZUILabelTTF)
    txtOverTip:setVisible(true)
    if self.m_nRewardCounts > 0 and self.maxCount - self.count > 0 then
        local sTime   = returnToTimeFormat(self.m_nRewardCounts)
        local ftbCountdown = GetElement(self.m_root, "ftbCountdown_CellOrderRedPack", WZUIFreeTextBox)
        ftbCountdown:disableSchedule()
        ftbCountdown:setShowText(string.format(LocalStrings.REDPACK_ATT3, sTime))
        ftbCountdown:enableSchedule("caculateTime", 1)
        txtOverTip:setVisible(false)
        conGoToChat:setVisible(true)
    end

    if self.maxCount - self.count <= 0 then
        local txtStats = GetElement(self.m_root,"txtStats_CellOrderRedPack",WZUILabelTTF)
        txtStats:setTextKey("PASS_OVER")

        local ftbCountdown = GetElement(self.m_root,"ftbCountdown_CellOrderRedPack",WZUIFreeTextBox)
        ftbCountdown:disableSchedule()
        ftbCountdown:setShowText("")
        txtOverTip:setText(LocalStrings.PASS_OVER)
        txtOverTip:setVisible(true)
        conGoToChat:setVisible(false)
    end
end

--@brief    计时
function CellOrderRedPack:caculateTime(element)
    local ftbCountdown = GetElement(self.m_root, "ftbCountdown_CellOrderRedPack", WZUIFreeTextBox)
    local txtOverTip = GetElement(self.m_root, "txtOverTip_CellOrderRedPack",WZUILabelTTF)
    if self.m_nRewardCounts  and self.m_nRewardCounts > 0 then
        self.m_nRewardCounts = self.m_nRewardCounts - 1 
        if ftbCountdown then
            local sTime     = returnToTimeFormat(self.m_nRewardCounts)
            ftbCountdown:setShowText(string.format(LocalStrings.REDPACK_ATT3, sTime))
        end
        txtOverTip:setVisible(false)
    else
        ftbCountdown:setShowText("")
        element:disableSchedule()
        txtOverTip:setVisible(true)
    end
end


-------------------------------------私有方法模块End----------------------------------------
