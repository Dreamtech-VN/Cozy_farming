--WndRechargeSuccess.lua
--@brief	WndRechargeSuccess的UI模块
--@date		2015-9-15
--@author	binshao
--@note		充值成功模块

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRechargeSuccess:onEnter(element)
    self.m_root = element
    AdaptLanguage(self)
end

--@brief	打开加载动画
function WndRechargeSuccess:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end

--@brief	窗口动画完成回调
function WndRechargeSuccess:actionCallback(element,data)
    -- 充值成功需要重新获取充值列表
    ProtocolProcessorRecharge:send_PURCHASE_GetGiftIdList(ProjConfig:getChannelId())
    ProtocolProcessorWndVip:send_VIP_GetVipRebateInfo( )
    ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList(ProjConfig:getChannelId(),7)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRechargeSuccess:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------
-- 关闭回调
function WndRechargeSuccess:onCloseActionCallback()
    WindowManager:removeWindow(self.m_root, self, true)
end


-- 点击确定
function WndRechargeSuccess:onClickSure()
    WZLog("WndRechargeSuccess:onClose one")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

-- 点击特权
function WndRechargeSuccess:onClickPower()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------------click power---------------")
    WndVip:showWndUI(1,true)
    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end


--@brief	更新函数
function WndRechargeSuccess:_update()
    local pInfo = CacheCenter:getPlayerInfo()
    local data = self.data
    local curVipLv = data.vipLevel
    local isMaxVip = curVipLv == self:_getMaxLevel() and true or false

    -- 显示VIP显示的内容
    local conMax = GetElement(self.m_root,"comMax_WndRechargeSuccess",WZUIContainer)
    local conMin = GetElement(self.m_root,"comMin_WndRechargeSuccess",WZUIContainer)
    conMax:setVisible(isMaxVip)
    conMin:setVisible(not isMaxVip)

    -- 显示按钮个数
    local conSingle = GetElement(self.m_root,"conSingleBtn_WndRechargeSuccess",WZUIContainer)
    local conDouble = GetElement(self.m_root,"conDoubleBtn_WndRechargeSuccess",WZUIContainer)
    local isSingle = (isMaxVip or not data.isUp) and true or false
    conSingle:setVisible(isSingle)
    conDouble:setVisible(not isSingle)

    if isMaxVip then
        WZLog("----------------8989-------------------")
        local curLv = GetElement(self.m_root, "ftbMaxVip_WndRechargeSuccess", WZUIFreeTextBox)
        curLv:setShowText(string.format(LocalStrings.RECHARGE_SUCCESS2,curVipLv,data.count))
    else
        local curLv = GetElement(self.m_root, "txtCurLv_WndRechargeSuccess", WZUIFreeTextBox)
        curLv:setShowText(string.format(LocalStrings.RECHARGE_SUCCESS2,curVipLv,data.count))

        -- 再充值多少VIP升级
        local rmb = GDatatab_vip["id_"..(curVipLv+1)].exp-pInfo.vipExp
        local nextLv = GetElement(self.m_root, "ftbDesc1_WndRechargeSuccess", WZUIFreeTextBox)
        nextLv:setShowText(string.format(LocalStrings.RECHARGE_SUCCESS3,rmb,curVipLv+1))
    end

    local txtPs = GetElement(self.m_root, "ttfCardDesc_WndRechargeSuccess", WZUILabelTTF)
    if data.itemId == 50 then
        txtPs:setVisible(true)
        txtPs:setText(LocalStrings.RECHARGE_DESC1)
        WZLog("-------------956--------------",LocalStrings.RECHARGE_DESC1)
    elseif data.itemId == 51 then
        txtPs:setVisible(true)
        txtPs:setText(LocalStrings.RECHARGE_DESC2)
        WZLog("-------------956--------------",LocalStrings.RECHARGE_DESC2)
    else
        txtPs:setVisible(false)
    end

    local conChange = GetElement(self.m_root,"conVipChange_WndRechargeSuccess",WZUIContainer)
    conChange:setVisible(false)
    if data.isUp then
        if self.m_root ~= nil then
            self.m_root:enableSchedule("descLvAni",1)
        end
        WndVipUp:showWndUI()
    end
end

function WndRechargeSuccess:descLvAni()
    self.m_root:disableSchedule()
    local conChange = GetElement(self.m_root,"conVipChange_WndRechargeSuccess",WZUIContainer)
    local info = CacheCenter:getPlayerInfo()
    local curLv,preLv = info.vipLevel, info.vipLevel-1
    local txtPreLv = GetElement(self.m_root,"txtPreLv1_WndRechargeSuccess",WZUILabelTTF)
    local txtCurLv = GetElement(self.m_root,"txtCurLv1_WndRechargeSuccess",WZUILabelTTF)
    txtPreLv:setText("Lv"..preLv)
    txtCurLv:setText("Lv"..curLv)
    conChange:setVisible(true)
end

--------------------------------------语言适配Begin-------------------------
function WndRechargeSuccess:_adaptLanguage_tr(  )
    local txtCurLv = GetElement(self.m_root,"txtCurLv_WndRechargeSuccess",WZUIFreeTextBox)
    txtCurLv:setRelativePosition(GlobalMethod:ccp(0.03,0.5))

    local ftbDesc = GetElement(self.m_root,"ftbDesc1_WndRechargeSuccess",WZUIFreeTextBox)
    ftbDesc:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
    ftbDesc:setScale(0.8)

    local ttfCard = GetElement(self.m_root,"ttfCardDesc_WndRechargeSuccess",WZUILabelTTF)
    --ttfCard:setDimensions(GlobalMethod:CCSize(400,0))
    ttfCard:setFontSize(13)

    local ftbMaxVip = GetElement(self.m_root, "ftbMaxVip_WndRechargeSuccess", WZUIFreeTextBox)
    ftbMaxVip:setRelativePosition(GlobalMethod:ccp(0.65,0.5))
end

function WndRechargeSuccess:_adaptLanguage_en(  )
    local txtCurLv = GetElement(self.m_root,"txtCurLv_WndRechargeSuccess",WZUIFreeTextBox)
    txtCurLv:setRelativePosition(GlobalMethod:ccp(0.03,0.5))

    local ftbDesc = GetElement(self.m_root,"ftbDesc1_WndRechargeSuccess",WZUIFreeTextBox)
    ftbDesc:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
    ftbDesc:setScale(0.8)

    local ttfCard = GetElement(self.m_root,"ttfCardDesc_WndRechargeSuccess",WZUILabelTTF)
    ttfCard:setDimensions(GlobalMethod:CCSize(400,0))
    ttfCard:setFontSize(13)
end

function WndRechargeSuccess:_adaptLanguage_vn(  )
    local ttfCard = GetElement(self.m_root,"ttfCardDesc_WndRechargeSuccess",WZUILabelTTF)
    ttfCard:setFontSize(16)
    local ftbDesc = GetElement(self.m_root,"ftbDesc1_WndRechargeSuccess",WZUIFreeTextBox)
    ftbDesc:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
    ftbDesc:setScale(0.8)
end

function WndRechargeSuccess:_adaptLanguage_pt(  )
    local txtCurLv = GetElement(self.m_root,"txtCurLv_WndRechargeSuccess",WZUIFreeTextBox)
    txtCurLv:setRelativePosition(GlobalMethod:ccp(0.03,0.5))

    local ftbDesc = GetElement(self.m_root,"ftbDesc1_WndRechargeSuccess",WZUIFreeTextBox)
    ftbDesc:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
    ftbDesc:setScale(0.8)

    local ttfCard = GetElement(self.m_root,"ttfCardDesc_WndRechargeSuccess",WZUILabelTTF)
    ttfCard:setDimensions(GlobalMethod:CCSize(400,0))
    ttfCard:setFontSize(13)
end
function WndRechargeSuccess:_adaptLanguage_es(  )
    local txtCurLv = GetElement(self.m_root,"txtCurLv_WndRechargeSuccess",WZUIFreeTextBox)
    txtCurLv:setRelativePosition(GlobalMethod:ccp(0.03,0.5))

    local ftbDesc = GetElement(self.m_root,"ftbDesc1_WndRechargeSuccess",WZUIFreeTextBox)
    ftbDesc:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
    ftbDesc:setScale(0.8)

    local ttfCard = GetElement(self.m_root,"ttfCardDesc_WndRechargeSuccess",WZUILabelTTF)
    ttfCard:setDimensions(GlobalMethod:CCSize(400,0))
    ttfCard:setFontSize(13)
end
-------------------------------------语言适配End--------------------------------------