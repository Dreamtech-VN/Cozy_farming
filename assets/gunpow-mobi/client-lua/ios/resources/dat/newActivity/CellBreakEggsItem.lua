--CellBreakEggsItem.lua
--@brief	CellBreakEggsItem的UI模块
--@date		2017/08/23
--@author	Tianxiang_Xu
--@note		砸金蛋活动-金蛋子节点cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBreakEggsItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBreakEggsItem:onExit(element)
	self:_unInit()
end

--@brief    点击金蛋回调
function CellBreakEggsItem:onClickEgg(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    if CellBreakEggsPanel.m_current.m_nHummerNum == 0 then 
        MsgBoxManager:showConfirmBox(LocalStrings.NEWACTIVITY_TEXT12, self, self.toRecharge)
        return 
    end

    CellBreakEggsItem.m_current_click = self
    --发送领取奖励协议
    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId, self.m_tData.rewardId)
end

--@brief    更新蛋的颜色类型
function CellBreakEggsItem:changeEggType()
    -- body
    if self.m_tData.state == 0 then 
        local nBreakTimes = CellBreakEggsPanel.m_current:getBreakTimes()
        local imgEgg = GetElement(self.m_root, "imgEgg_CellBreakEggsItem", WZUIImage)
        if math.mod(nBreakTimes, 3) == 0 then
            imgEgg:setFile("ui/gameActivity/kf_egg_colourful.png")
        else
            imgEgg:setFile("ui/gameActivity/kf_egg_gold.png")
        end
    end
end

--@brief    充值
function CellBreakEggsItem:toRecharge()
    -- body
    PassportSdkManager:gotoPaymentPage()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellBreakEggsItem:_update()
    -- body
    local imgEgg = GetElement(self.m_root, "imgEgg_CellBreakEggsItem", WZUIImage)
    local btnEgg = GetElement(self.m_root, "btnEgg_CellBreakEggsItem", WZUIButton)
    local spineBreakEgg = GetElement(self.m_root, "spineBreakEgg_CellBreakEggsItem", WZUISpine)
    if imgEgg then 
        if self.m_tData.state == 0 then 
            self:changeEggType()
            imgEgg:setVisible(true)
            btnEgg:setTouchEnable(true)
        else
            spineBreakEgg:setFileJson("ui/ui_jindan.json")
            spineBreakEgg:setFileAtlas("ui/ui_jindan.atlas")
            spineBreakEgg:setVisible(true)
            spineBreakEgg:play("wait", true)
            imgEgg:setVisible(false)
            btnEgg:setTouchEnable(false)
        end
    end
    --
end

--@brief    刷新状态
function CellBreakEggsItem:playEggAni()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_PET_ZHADAN)
    local spineBreakEgg = GetElement(self.m_root, "spineBreakEgg_CellBreakEggsItem", WZUISpine)
    if spineBreakEgg then 
        local nBreakTimes = CellBreakEggsPanel.m_current:getBreakTimes()
        local modTimes = math.mod(nBreakTimes, 3)
        WZLog("CellBreakEggsItem:playEggAni", nBreakTimes, modTimes)
        if math.mod(nBreakTimes, 3) == 0 then
            spineBreakEgg:setFileJson("ui/ui_caidan.json")
            spineBreakEgg:setFileAtlas("ui/ui_caidan.atlas")
        else
            WZLog("CellBreakEggsItem:playEggAni 33333")
            spineBreakEgg:setFileJson("ui/ui_jindan.json")
            spineBreakEgg:setFileAtlas("ui/ui_jindan.atlas")
        end
        spineBreakEgg:setVisible(true)
        spineBreakEgg:play("posui", false)
        spineBreakEgg:enableSchedule("changeAni", 0.8)
    end
end

--@brief    将动作切换为碎了后的状态
function CellBreakEggsItem:changeAni()
    -- body
    self:showReward()
    local spineBreakEgg = GetElement(self.m_root, "spineBreakEgg_CellBreakEggsItem", WZUISpine)
    spineBreakEgg:disableSchedule()
    if spineBreakEgg then 
        spineBreakEgg:play("wait", true)
    end
end
-------------------------------------私有方法模块End----------------------------------------
