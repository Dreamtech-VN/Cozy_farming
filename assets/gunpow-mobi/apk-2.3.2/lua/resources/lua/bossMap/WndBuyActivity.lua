--WndBuyActivity.lua
--@brief	WndBuyActivity的UI模块
--@date		2014/08/21
--@author	hugozheng
--@note		购买活力面板


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBuyActivity:onEnter(element)
	self.m_root = element
	WZLog("WndBuyActivity:onEnter(element)")
	
	--判断缓存信息是否存在
	if CacheCenter:hasPlayerInfo() then
	 	self:getStartInfoList()
	end

	--语言适配函数
	AdaptLanguage(self)
    self.m_sLanguage = ProjConfig.LANGUAGE
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBuyActivity:onExit(element)
    self.m_root:disableSchedule()
    if self.m_nCountTimeID ~= nil then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nCountTimeID)
    end
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function WndBuyActivity:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true,nil,nil)
    if NeedFyber(7) then
      local postData = {}
      postData.funType = "fyber_interstitial"
      PassportSdkManager:Others(postData)
    end
end

-- --@brief    特效播放回调函数
-- function WndBuyActivity:onFinishCallBack()
--     -- body
--     WZLog("********* WndBuyActivity:onFinishCallBack *********")
--     if self.m_tBaseData.nType == 1 then
--         local armatureFire = GetElement(self.m_root, "armatureFire_WndBuyActivity", WZArmature)
--         local action1 = WZUIArmatureAnimationById:create()
--         action1:setAnimationId(0)
--         action1:setLoop(-1)
--         armatureFire:runUIAction(action1)
--         armatureFire:setAnimationFinishLuaFunction("")
--     end
-- end

--@brief    点击规则按钮回调
function WndBuyActivity:onRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.BUYACTIVITY_RULE) 
end
-------------------------------------公有方法模块End----------------------------------------
--@brief	关闭按钮时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		
function WndBuyActivity:onCloseWindowBtn(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    if self.m_root then 
		WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
	end 
end 

--@brief	关闭整个窗口的动画效果
function WndBuyActivity:onCloseActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , WndBuyActivity , true)
end

--@brief	外部调用接口
--@param	itemId:物品ID
--@note		外部调用接口
function WndBuyActivity:showBuyInterface(itemId)
    --开启条件限制
    if itemId == 26 and (not CheckButtonOpen(35)) then
        return
    end
    if itemId == 1056 and (not CheckButtonOpen(36)) then
        return
    end
    if itemId == 58 and (not CheckButtonOpen(114)) then
        return 
    end
    if (itemId == 66 or itemId == 67) and (not CheckButtonOpen(131)) then
        return 
    end
    -- WZTempLog("itemId... 外部调用接口 ..: ", itemId)
	if self.m_root == nil then
		local wndBuyActivity = WndBuyActivity:createElement()
		WindowManager:addWindow(wndBuyActivity, WndBuyActivity, false)
		WZLog("itemType111",itemId)
	end
    if itemId == 1056 or itemId == 26 then
       GetElement(self.m_root,"btnRule",WZUIButton):setVisible(true)
    end
    local limitItem = nil
    if itemId == 26 then --金币
        ChangeChatChannel(Chat_Channel_Gold_Tree)
        limitItem = 1
    elseif itemId == 1056 then  --活力
        ChangeChatChannel(Chat_Channel_Add_Strength)
        limitItem = 2
    elseif itemId == 58 then --矿晶
        limitItem = 13        
    elseif itemId == 60 then --骰子
        limitItem = 15
    elseif itemId == 66 then --家园圣水
        limitItem = 16
    elseif itemId == 67 then --家园奇石
        limitItem = 17
    end

    self.m_nCousumeMax = tonumber(CacheCenter:getGameParam()["returnDiamondPerSpend"]) or 100

    if limitItem == 2 then 
        self:createLoading()
        ProtocolProcessorWndShop:send_MALL_GetLimitedTime(limitItem)
    elseif limitItem == 1 then 
        self:createLoading()
        ProtocolProcessorWndShop:send_MALL_GetUpdateLimited(limitItem)
    elseif limitItem == 13 then
        self:getDataFromServer(13 + 1, WndDigGem.m_nBuyGemCoinTimes, 0)
    elseif limitItem == 15 then
        self:getDataFromServer(15 + 1, CacheCenter:getBuyTabooCoinTimes(), 0)
    elseif limitItem == 16 then 
        self:getDataFromServer(16 + 1, SceneFamily.m_nWaterBuyTimes, 0)
    elseif limitItem == 17 then 
        self:getDataFromServer(17 + 1, SceneFamily.m_nStoneBuyTimes, 0)
    end
end

--@brief    获取相应Vip等级下的最大限购次数：购买金币或购买钻石,消耗的钻石，获得的结果值
--@param    #1购买的类型：1-1:金币；2-1:体力(要跟本地数据表中的类型匹配，所以要减1)
--@param    #2用户vip等级
function WndBuyActivity:getBaseInfo(nType, nVipLevel)
    -- body
    if self.m_tBaseData.nType == 1 then
        -- if self.m_sLanguage ~= "cn" then
        --     local armatureFire = GetElement(self.m_root, "armatureFire_WndBuyActivity", WZArmature)
        --     local action1 = WZUIArmatureAnimationById:create()
        --     action1:setAnimationId(0)
        --     armatureFire:runUIAction(action1)
        -- end
    end
    WZLog("********* WndBuyActivity:getBaseInfo *********")
    self:setPriceValue(self.m_tBaseData.nType, self.m_tBaseData.nCostValue, self.m_tBaseData.nLeftCount)

    if self.m_tBaseData.nType == 1 then 
        self.m_nCountTimeID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.updateDisplay, 1, false)
    end
    --Add By Tianxiang_Xu
    --设置各个TTF控件的文字显示
    self:_setStaticText()
    --End Add 
end

--@brief  点击异常提示触发的函数
--@param  nType，按钮类型，关闭，取消，确定
--@param  nId，按钮id
function WndBuyActivity:clickSureBack(nId,nType)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndBuyActivity:clickSureBack")
end

function WndBuyActivity:onBuyBtn(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN) 

    self:setPriceValue(self.m_tBaseData.nType, self.m_tBaseData.nCostValue, self.m_tBaseData.nLeftCount)

    if self.m_tBaseData.nType == 1 and CacheCenter:getPlayerInfo().vigor >= 999 then
        WZLog("--活力已达上限")
        MsgBoxManager:showConfirmBox(LocalStrings.CANNOT_BUY_VIGOR, self, self.clickSureBack, nil, nil, true)
        return  
    end

    if self.m_price == -1 then
        --购买次数不足
        self:_showTipsAccordCase()
        return
    end
    if self.m_price == -2 then
        --钻石不足
        WZLog("--钻石不足")
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
        if not JudgeMoneyIsEnough(self.m_tBaseData.nCostType, self.m_tBaseData.nCostValue, LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, nil, GlobalGame.g_nCurrentUIChannelId, WndBuyActivity, self.onCloseActionCallback, tCustomUIConfig, nil, self, self.sureUseDiamondInstead) then 
            return 
        end
        return
    end

    self:sureUseDiamondInstead()
end

--@brief    确认用钻石代替礼券
function WndBuyActivity:sureUseDiamondInstead()
    -- body
    if self.m_price == -3 then
        WZLog("--活力已达上限")
        MsgBoxManager:showConfirmBox(LocalStrings.CANNOT_BUY_VIGOR, self, self.clickSureBack, nil, nil, true)
        return
    end
    if self.m_tBaseData.nType == 0 then    --金币
        if not CheckButtonOpen(35) then
            return
        end
    elseif self.m_tBaseData.nTpye == 1 then --活力值
        if not CheckButtonOpen(36) then
            return
        end
    elseif self.m_tBaseData.nType == 13 then    --矿晶
        if not CheckButtonOpen(114) then
            return
        end
    elseif self.m_tBaseData.nType == 16 or self.m_tBaseData.nType == 17 then --圣水、奇石
        if not CheckButtonOpen(131) then
            return
        end
    end

    if self.m_tBaseData.nType == 13 then
        self.m_tResultAddNum = {}
        table.insert(self.m_tResultAddNum, self.m_tBaseData.nResultValue)
        ProtocolProcessorDigGem:send_MINING_MiningBuy(1)
    elseif self.m_tBaseData.nType == 15 then
        self.m_tResultAddNum = {}
        table.insert(self.m_tResultAddNum, self.m_tBaseData.nResultValue)
        ProtocolProcessorTaboo:send_ZONE_BuyDice(1)
    elseif self.m_tBaseData.nType == 16 or self.m_tBaseData.nType == 17 then
        self.m_tResultAddNum = {}
        table.insert(self.m_tResultAddNum, self.m_tBaseData.nResultValue)
        local nType = 1
        if self.m_tBaseData.nType == 17 then 
            nType = 2
        end
        ProtocolProcessorFamily:send_HOME_Purchase(nType, 1)
    else
        ProtocolProcessorWndShop:send_MALL_BuyLimitedItem(self.m_tBaseData.nType + 1, 1)
        self:createLoading()
    end
end

function WndBuyActivity:onBuyBtnFive(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN) 
    --vip等级限制
    WZLog("********** WndBuyActivity:onBuyBtnFive ************", CacheCenter:getGameParam()["buyGoldVipLimit"])
    local buyGoldVipLimited = CacheCenter:getGameParam()["buyGoldVipLimit"] or 4
    local nButtonId = 182   --功能开放表对应id
    local tBtnsInfo = GDatatab_button_info["id_"..nButtonId]
    if CacheCenter:getPlayerInfo().vipLevel < tonumber(buyGoldVipLimited) and not whetherHaveWelfareCard() and CacheCenter:getPlayerInfo().level < tBtnsInfo.open_level then
        MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.WELFARECARD_VIP_TIP, tBtnsInfo.open_level, tonumber(buyGoldVipLimited)), self, self.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
        return 
    end
    -- body
    local nCount, nNeedDiamonds = self:returnAttData() 
    self:setPriceValue(self.m_tBaseData.nType, nNeedDiamonds, nCount)
    
    if self.m_price == -1 then
        --购买次数不足
        WZLog("--购买次数不足")
        self:_showTipsAccordCase()
        return
    end
    if self.m_tBaseData.nLeftCount >= 2 then
        local sMsgBody = "BUY_FIVE_ATTENTION"
        if self.m_tBaseData.nType == 13 then
            sMsgBody = "BUY_FIVEGEM_ATTENTION"
        elseif self.m_tBaseData.nType == 15 then
            sMsgBody = "BUY_FIVETOUZI_ATTENTION"
        elseif self.m_tBaseData.nType == 16 or self.m_tBaseData.nType == 17 then 
            sMsgBody = "BUY_FIVEFAMILY_ATTENTION"
        end
        WndBuyFiveAttention:showBuyFiveAtt(sMsgBody, self, self.buyLimitedItem)
        return 
    end
    --当点“摇5次”按钮时，只剩余一次可用，直接发送购买协议
    if self.m_tBaseData.nType == 13 then
        ProtocolProcessorDigGem:send_MINING_MiningBuy(1)
    elseif self.m_tBaseData.nType == 15 then
        ProtocolProcessorTaboo:send_ZONE_BuyDice(1)
    elseif self.m_tBaseData.nType == 16 or self.m_tBaseData.nType == 17 then
        local nType = 1
        if self.m_tBaseData.nType == 17 then 
            nType = 2
        end
        ProtocolProcessorFamily:send_HOME_Purchase(nType, 1)
    else
        ProtocolProcessorWndShop:send_MALL_BuyLimitedItem(self.m_tBaseData.nType + 1, 1)
        self:createLoading()
    end
end


--@brief	提示充值框的回调
--@param	nId:消息id
--@param	nResType:响应类型(超时，确定，取消)
function WndBuyActivity:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self, true)
		PassportSdkManager:gotoPaymentPage()
    end
end

--@brief    确认购买订单被调用的函数,发送协议
function WndBuyActivity:buyLimitedItem()
    WZLog("确认购买订单被调用的函数,发送协议")
    local nShakeNum = 0
    if self.m_tBaseData.nLeftCount >= 5 then
        nShakeNum = 5
    else
        nShakeNum = self.m_tBaseData.nLeftCount
    end

    if self.m_tBaseData.nType == 13 then
        ProtocolProcessorDigGem:send_MINING_MiningBuy(nShakeNum)
    elseif self.m_tBaseData.nType == 15 then
        local nLeftNum = tonumber(CacheCenter:getTabooCoinMaxNum()) - tonumber(CacheCenter:getPlayerItemCountById(60))
        if nShakeNum > nLeftNum and nLeftNum > 0 then
            nShakeNum = nLeftNum
        end
        ProtocolProcessorTaboo:send_ZONE_BuyDice(nShakeNum)
    elseif self.m_tBaseData.nType == 16 or self.m_tBaseData.nType == 17 then
        local nType = 1
        if self.m_tBaseData.nType == 17 then 
            nType = 2
        end
        ProtocolProcessorFamily:send_HOME_Purchase(nType, nShakeNum)
    else
        ProtocolProcessorWndShop:send_MALL_BuyLimitedItem(self.m_tBaseData.nType + 1, nShakeNum )
        self:createLoading()
    end
end

--@brief	购买成功，关闭面板
--@param	nId:消息id
--@param	nResType:响应类型(超时，确定，取消)
function WndBuyActivity:onCloseWindowCallBack(nId, nResType)
    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self, true)
end

--@brief	设置购买界面标题图片
--@param	nType:物品类型
function WndBuyActivity:_setImgTitle(bshow1,bshow2)

end

--@brief    设置个TTF控件的显示文字内容
function WndBuyActivity:_setStaticText()
    -- body
    local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndBuyActivity", WZUIImage)
    imgCostIcon:setFile(GDatatab_item["id_" .. self.m_tBaseData.nCostType].icon)

    GetElement(self.m_root, "txtConsume_WndBuyActivity", WZUILabelTTF):setText(LocalStrings.PETUSE)
    GetElement(self.m_root, "txtCanGain_WndBuyActivity", WZUILabelTTF):setText(LocalStrings.KING_WILL_AWARD)
    GetElement(self.m_root, "txtActivityLimit_WndBuyActivity", WZUILabelTTF):setText(LocalStrings.BUY_ACTIVITY_LIMIT)
    GetElement(self.m_root, "txtBuyAct_WndBuyActivity", WZUILabelTTF):setText(LocalStrings.BUY)
    local sFormatBtn = LocalStrings.SHAKE_TIMES
    if self.m_tBaseData.nType == 13 or self.m_tBaseData.nType == 15 or self.m_tBaseData.nType == 16 or self.m_tBaseData.nType == 17 then
        GetElement(self.m_root, "txtGoldLimit_WndBuyActivity", WZUILabelTTF):setText(LocalStrings.BUY_ACTIVITY_LIMIT)
        GetElement(self.m_root, "btnRule_WndBuyActivity", WZUIButton):setVisible(false)
        sFormatBtn = LocalStrings.BUY_TIMES
    else
        GetElement(self.m_root, "txtGoldLimit_WndBuyActivity", WZUILabelTTF):setText(LocalStrings.BUY_GOLD_LIMIT)
    end
    GetElement(self.m_root, "txtOnceTime_WndBuyActivity", WZUILabelTTF):setText(string.format(sFormatBtn, 1))

    self:_updateFtnFiveText()
    
    --显示返还进度
    self:_updateConsumePrg(self.m_nCostCurDay)
    if ProjConfig.LANGUAGE == "en" then
        GetElement(self.m_root, "txtCanGain_WndBuyActivity", WZUILabelTTF):setText("for")
    end

    --设置显示的是购买金币还是购买活力的界面
    self:_setDisplayItem()
end

--@brief    设置显示的是购买金币还是购买活力的界面
function WndBuyActivity:_setDisplayItem()
    -- body
    local nConsumeNum = self.m_tBaseData.nCostValue
    local nGainNum = self.m_tBaseData.nResultValue
    GetElement(self.m_root, "txtGainNum_WndBuyActivity", WZUILabelTTF):setText(nGainNum)
    GetElement(self.m_root, "txtDiamondNum_WndBuyActivity", WZUILabelTTF):setText(nConsumeNum)
    local imgTitle = GetElement(self.m_root, "imgTitle_WndBuyActivity", WZUIImage)
    if self.m_tBaseData.nType == 0 then    --购买金币
        imgTitle:setFile("ui/common/bt_text_zcm.png")
        GetElement(self.m_root, "conGold_WndBuyActivity", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conActivity_WndBuyActivity", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "imgActivityBg_WndBuyActivity", WZUIImage):setVisible(false)
        GetElement(self.m_root, "imgGoldBg_WndBuyActivity", WZUIImage):setVisible(true)
        GetElement(self.m_root, "imgGoldBgR_WndBuyActivity", WZUIImage):setVisible(true)
        GetElement(self.m_root, "spineCat_WndBuyActivity", WZUISpine):setVisible(true)

        local sGoldLimitNum = self.m_tBaseData.nLeftCount .. "/" .. self.m_tBaseData.nMaxCount
        GetElement(self.m_root, "txtGoldLimitNum_WndBuyActivity", WZUILabelTTF):setText(sGoldLimitNum)
    elseif self.m_tBaseData.nType == 1 then  --购买活力
        imgTitle:setFile("ui/common/bt_text_bctl.png")
        GetElement(self.m_root, "conGold_WndBuyActivity", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conActivity_WndBuyActivity", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "imgActivityBg_WndBuyActivity", WZUIImage):setVisible(true)
        GetElement(self.m_root, "imgGoldBg_WndBuyActivity", WZUIImage):setVisible(false)
        GetElement(self.m_root, "imgGoldBgR_WndBuyActivity", WZUIImage):setVisible(false)
        GetElement(self.m_root, "spineCat_WndBuyActivity", WZUISpine):setVisible(false)

        local sActLimitNum = self.m_tBaseData.nLeftCount .. "/" .. self.m_tBaseData.nMaxCount
        GetElement(self.m_root, "txtActLimitNum_WndBuyActivity", WZUILabelTTF):setText(sActLimitNum)

        --活力值恢复时间提示
        local sFullRecovery = LocalStrings.FULL_RECOVERY
        local sNextRecovery = LocalStrings.NEXT_RECOVERY
        local sFullTime     = os.date("%X", self.m_nFullReSeconds)
        local sNextTime     = returnToTimeFormat(self.m_nNextReSeconds)

        WZLog("************** WndBuyActivity:_setDisplayItem **********************", sFullTime)

        GetElement(self.m_root, "txtFullRecoverWord", WZUILabelTTF):setText(sFullRecovery)
        GetElement(self.m_root, "txtFullRecoverTime", WZUILabelTTF):setText(sFullTime)
        GetElement(self.m_root, "txtNextRecoverWord", WZUILabelTTF):setText(sNextRecovery)
        GetElement(self.m_root, "txtNextRecoverTime", WZUILabelTTF):setText(sNextTime)

        GetElement(self.m_root, "txtActivityHavedFull", WZUILabelTTF):setText(LocalStrings.ACTIVITY_HAVED_FULL)

        
        if CacheCenter:getPlayerInfo().vigor < CacheCenter:getPlayerInfo().maxVigor then
            GetElement(self.m_root, "txtActivityHavedFull", WZUILabelTTF):setVisible(false)
        else
            GetElement(self.m_root, "txtActivityHavedFull", WZUILabelTTF):setVisible(true)
            GetElement(self.m_root, "txtFullRecoverWord", WZUILabelTTF):setVisible(false)
            GetElement(self.m_root, "txtFullRecoverTime", WZUILabelTTF):setVisible(false)
            GetElement(self.m_root, "txtNextRecoverWord", WZUILabelTTF):setVisible(false)
            GetElement(self.m_root, "txtNextRecoverTime", WZUILabelTTF):setVisible(false)
        end
    elseif self.m_tBaseData.nType == 13 then
        imgTitle:setFile("ui/common/bt_text_mks.png")
        GetElement(self.m_root, "imgGemBg_WndBuyActivity", WZUIImage):setVisible(true)

        GetElement(self.m_root, "conGold_WndBuyActivity", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "imgIconDiamond_WndBuyActivity", WZUIImage):setFile("ui/common/common_icon_kuangjing.png")
        local sGoldLimitNum = self.m_tBaseData.nLeftCount .. "/" .. self.m_tBaseData.nMaxCount
        GetElement(self.m_root, "txtGoldLimitNum_WndBuyActivity", WZUILabelTTF):setText(sGoldLimitNum)
    elseif self.m_tBaseData.nType == 15 then
        imgTitle:setFile("ui/common/bt_text_gmtz.png")
        GetElement(self.m_root, "imgTabooBg_WndBuyActivity", WZUIImage):setVisible(true)

        GetElement(self.m_root, "conGold_WndBuyActivity", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "imgIconDiamond_WndBuyActivity", WZUIImage):setFile("ui/taboo/login_icon_shaizi2.png")
        local sGoldLimitNum = self.m_tBaseData.nLeftCount .. "/" .. self.m_tBaseData.nMaxCount
        GetElement(self.m_root, "txtGoldLimitNum_WndBuyActivity", WZUILabelTTF):setText(sGoldLimitNum)
    elseif self.m_tBaseData.nType == 16 or self.m_tBaseData.nType == 17 then
        local imgGemBg = GetElement(self.m_root, "imgGemBg_WndBuyActivity", WZUIImage)
        imgGemBg:setVisible(true)
        if self.m_tBaseData.nType == 16 then
            imgTitle:setFile("ui/common/bt_text_mss.png")
            imgGemBg:setFile("ui/family/bg/common_pic_maishengshui.png")
        elseif self.m_tBaseData.nType == 17 then
            imgTitle:setFile("ui/common/bt_text_mqs.png")
            imgGemBg:setFile("ui/family/bg/common_pic_maiqishi.png")
        end

        GetElement(self.m_root, "conGold_WndBuyActivity", WZUIContainer):setVisible(true)
        local imgIconDiamond = GetElement(self.m_root, "imgIconDiamond_WndBuyActivity", WZUIImage)
        imgIconDiamond:setFile(GDatatab_item["id_" .. self.m_tBaseData.nResultType].icon)
        local sGoldLimitNum = self.m_tBaseData.nLeftCount .. "/" .. self.m_tBaseData.nMaxCount
        GetElement(self.m_root, "txtGoldLimitNum_WndBuyActivity", WZUILabelTTF):setText(sGoldLimitNum)
    end
end

--@brief    创建节点WZUILabelAtlasFont,用于显示购买成功后的结果显示
--@param    #1购买的类型：1->金币；2->活力
--@param    #2增加的数量
--@param    #3暴击的倍数：0表示没有暴击
function WndBuyActivity:_createAtlasFont(nType, nAddNum, nMultiple)
    -- body
    --音效
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS2) 
    --加号
    local imgAddSign = WZUIImage:create()
    imgAddSign:setFile("ui/common/common_num_yaoqianshujiahao.png")
    imgAddSign:setUseOriginSize(true)
    imgAddSign:setAnchorPoint(ccp(1, 0.5))
    imgAddSign:setRelativePosition(ccp(0.2, 0.5))

    --增加的类型图标
    local imgIcon = WZUIImage:create()
    if nType == 1 then 
        imgIcon:setFile("ui/common/common_icon_jinbi.png")
    elseif nType == 2 then 
        imgIcon:setFile("ui/common/common_icon_huoli.png")
    elseif nType == 13 then 
        imgIcon:setFile("ui/common/common_icon_kuangjing.png")
    elseif nType == 15 then
        imgIcon:setFile("ui/taboo/login_icon_shaizi2.png")
    elseif nType == 16 or nType == 17 then 
        imgIcon:setFile(GDatatab_item["id_" .. self.m_tBaseData.nResultType].icon)
        imgIcon:setScale(0.6)
    end
    imgIcon:setUseOriginSize(true)
    imgIcon:setAnchorPoint(ccp(0, 0.5))
    imgIcon:setRelativePosition(ccp(0.2, 0.5))

    --获得的结果数量
    local txtAtlasFont = WZUILabelAtlasFont:create()
    txtAtlasFont:setCharMapFileName("ui/common_num/common_num_yaoqianshuzi.png")
    txtAtlasFont:setStartChar(48)
    txtAtlasFont:setHeight(34)
    txtAtlasFont:setWidth(26)
    txtAtlasFont:setUseOriginSize(true)
    txtAtlasFont:setAnchorPoint(ccp(0, 0.5))
    txtAtlasFont:setRelativePosition(ccp(0.3, 0.5))

    txtAtlasFont:setText(nAddNum)

--    txtAtlasFont:addChild(imgAddSign)

    local imgBaoJi = nil 
    local imgMulSign = nil 
    local txtAtlasBaoJiNum = nil

    if nMultiple > 1 then
        --暴击
        imgBaoJi = WZUIImage:create()
        imgBaoJi:setFile("ui/combat/common_icon_baoji.png")
        imgBaoJi:setUseOriginSize(true)
        imgBaoJi:setScaleY(0.46)
        imgBaoJi:setScaleX(0.46)
        imgBaoJi:setAnchorPoint(ccp(0, 0.5))
        imgBaoJi:setRelativePosition(ccp(0.6, 0.5))
        --乘号
        imgMulSign = WZUIImage:create()
        imgMulSign:setFile("ui/common/common_num_yaoqianshuchenhao.png")
        imgMulSign:setUseOriginSize(true)
        imgMulSign:setAnchorPoint(ccp(1, 0.5))
        imgMulSign:setRelativePosition(ccp(0.8, 0.5))
        --暴击倍数
        txtAtlasBaoJiNum = WZUILabelAtlasFont:create()
        txtAtlasBaoJiNum:setCharMapFileName("ui/common_num/common_num_yaoqianshuzi.png")
        txtAtlasBaoJiNum:setStartChar(48)
        txtAtlasBaoJiNum:setHeight(34)
        txtAtlasBaoJiNum:setWidth(26)
        txtAtlasBaoJiNum:setUseOriginSize(true)
        txtAtlasBaoJiNum:setAnchorPoint(ccp(0, 0.5))
        txtAtlasBaoJiNum:setRelativePosition(ccp(0.8, 0.5))

        txtAtlasBaoJiNum:setText(nMultiple)
    else  --没有暴击时候，居中
        imgAddSign:setAnchorPoint(ccp(0.5, 0.5))
        imgAddSign:setRelativePosition(ccp(0.35, 0.5))

        imgIcon:setAnchorPoint(ccp(1, 0.5))
        imgIcon:setRelativePosition(ccp(0.45, 0.5))

        txtAtlasFont:setAnchorPoint(ccp(0, 0.5))
        txtAtlasFont:setRelativePosition(ccp(0.5, 0.5))
    end

     local conResult = WZUIContainer:create()
    local conRoot = GetElement(self.m_root, "conBuyActivity_WndBuyActivity", WZUIContainer)

     if conResult then
        conResult:addChild(imgAddSign)
        conResult:addChild(imgIcon)
        conResult:addChild(txtAtlasFont)
        if nMultiple > 1 then
            conResult:addChild(imgBaoJi)
            conResult:addChild(imgMulSign)
            conResult:addChild(txtAtlasBaoJiNum)
        end
        conRoot:addChild(conResult, 10, 10)
     end
    --购买成功后的界面特效
    if self.m_tBaseData.nType == 1 then
    --     WZLog("********************** self.m_tBaseData.nType *************")
    --     if self.m_sLanguage ~= "cn" then
    --         local armatureFire = GetElement(self.m_root, "armatureFire_WndBuyActivity", WZArmature)
    --         local action1 = WZUIArmatureAnimationById:create()
    --         action1:setAnimationId(1)
    --         action1:setLoop(0)
    --         armatureFire:runUIAction(action1)
    -- --        armatureFire:setAnimationFinishLuaFunction("onFinishCallBack")
    --     end
    elseif self.m_tBaseData.nType == 0 then 
        local sizeCon = GetElement(self.m_root, "conGold_WndBuyActivity", WZUIContainer):getAbsContentSize()

        local backFire = CCParticleSystemQuad:create("particle/skills_zcm_01.plist")
        backFire:setDuration(0.1)
        backFire:setPositionType(kCCPositionTypeRelative)
        backFire:setAutoRemoveOnFinish(true)
        backFire:setPosition(sizeCon.width / 2, sizeCon.height * 2 / 7)

        local particle = CCParticleBatchNode:createWithTexture(backFire:getTexture())
        particle:addChild(backFire)
        conRoot:addChild(particle)
    end

    local actionScaleTo1 = WZUIActionScaleTo:create()
    actionScaleTo1:setDuration(0.2)
    actionScaleTo1:setScaleY(1.1)
    actionScaleTo1:setScaleX(1.1)
    local actionScaleTo2 = WZUIActionScaleTo:create()
    actionScaleTo2:setDuration(0.2)
    actionScaleTo2:setScaleY(0.7)
    actionScaleTo2:setScaleX(0.7)
    local actionScaleTo3 = WZUIActionScaleTo:create()
    actionScaleTo3:setDuration(0.2)
    actionScaleTo3:setScaleY(0.85)
    actionScaleTo3:setScaleX(0.85)
     local actionScaleTo4 = WZUIActionScaleTo:create()
    actionScaleTo4:setDuration(0.5)
    actionScaleTo4:setScaleY(0.85)
    actionScaleTo4:setScaleX(0.85)
    local actionSqu = WZUIActionSequence:create()
    actionSqu:setIsLoop(false)
    actionSqu:setChildAction(actionScaleTo1)
    actionSqu:setChildAction(actionScaleTo2)
    actionSqu:setChildAction(actionScaleTo3)
    actionSqu:setChildAction(actionScaleTo4)

    local action = WZUIActionSpawn:create()

    local actMoveTo = WZUIActionMoveTo:create()
    actMoveTo:setDuration(0.6)
    actMoveTo:setMoveX(0.5)
    actMoveTo:setMoveY(0.65)

    local actFadeTo = WZUIActionContainerFadeFromTo:create()
    actFadeTo:setDuration(0.6)
    actFadeTo:setOpacityFrom(255)
    actFadeTo:setOpacityTo(0)

    action:setChildAction(actFadeTo)
    action:setChildAction(actMoveTo)

    actionSqu:setChildAction(action)
    actionSqu:setFinishLuaFunction("onActionFinishBack")

    conResult:runUIAction(actionSqu)
end

function WndBuyActivity:action3( )
    -- body
    if self.m_tBuyResult ~= nil then
        if #self.m_tBuyResult >= 1 then
            self:_createAtlasFont(self.m_tBuyResult[1].nLimitItem, self.m_tBuyResult[1].nAddNum, self.m_tBuyResult[1].nMultiple)
            table.remove(self.m_tBuyResult, 1)
        else
            self.m_root:disableSchedule()
            if self.m_nReturnNum ~= nil and self.m_nReturnNum > 0 then
                local tRewardId = {}
                table.insert(tRewardId, self.m_tBaseData.nCostType)
                local tRewardNum = {}
                table.insert(tRewardNum, self.m_nReturnNum)
                self.m_nReturnNum = 0
                WndRewardShow:showById(tRewardId, tRewardNum)
            end
        end
    else
        self.m_root:disableSchedule()
    end
end

function WndBuyActivity:onActionFinishBack(element, b)
    -- body
    WZLog("***********************WndBuyActivity:onActionFinishBack****************************")
    if self.m_tBaseData.nType == 1 then
        -- if self.m_sLanguage ~= "cn" then
        --     local armatureFire = GetElement(self.m_root, "armatureFire_WndBuyActivity", WZArmature)
        --     local action1 = WZUIArmatureAnimationById:create()
        --     action1:setAnimationId(0)
        --     action1:setLoop(-1)
        --     armatureFire:runUIAction(action1)
        -- end
    end

    element:removeFromParentAndCleanup(true)
    element = nil
end

--@brief    更新界面的某些显示信息
function WndBuyActivity:updateDisplayInfo()
    -- body
    self:_updateFtnFiveText()

   self:_setDisplayItem()
end

--@brief    更新体力界面显示的恢复时间
--@param    #1完全恢复时刻
--@param    #2下点恢复时间
function WndBuyActivity:updateLeftTime(nFullReSeconds, nNextReSeconds)
    --body
    --活力值恢复时间提示
    WZLog("******** WndBuyActivity:updateLeftTime *******", nFullReSeconds, nNextReSeconds)
    local sFullRecovery = LocalStrings.FULL_RECOVERY
    local sNextRecovery = LocalStrings.NEXT_RECOVERY

    local sFullTime     = os.date("%X", nFullReSeconds)
    local sNextTime     = returnToTimeFormat(nNextReSeconds)

    GetElement(self.m_root, "txtFullRecoverTime", WZUILabelTTF):setText(sFullTime)
    GetElement(self.m_root, "txtNextRecoverWord", WZUILabelTTF):setText(sNextRecovery)
    GetElement(self.m_root, "txtNextRecoverTime", WZUILabelTTF):setText(sNextTime)

    if CacheCenter:getPlayerInfo().vigor < CacheCenter:getPlayerInfo().maxVigor then
        GetElement(self.m_root, "txtActivityHavedFull", WZUILabelTTF):setVisible(false)
    else
        GetElement(self.m_root, "txtActivityHavedFull", WZUILabelTTF):setVisible(true)
        GetElement(self.m_root, "txtFullRecoverWord", WZUILabelTTF):setVisible(false)
        GetElement(self.m_root, "txtFullRecoverTime", WZUILabelTTF):setVisible(false)
        GetElement(self.m_root, "txtNextRecoverWord", WZUILabelTTF):setVisible(false)
        GetElement(self.m_root, "txtNextRecoverTime", WZUILabelTTF):setVisible(false)
    end

    if self.m_bIsSendAgain then
        self.m_bIsSendAgain = false
        ProtocolProcessorWndShop:send_MALL_GetUpdateLimited(2)
        self:createLoading()
    end
end

--@brief    更新界面显示的剩余可用次数
function WndBuyActivity:updateLeftCount()
    -- body
    if self.m_tBaseData.nType == 0 or self.m_tBaseData.nType == 13 or self.m_tBaseData.nType == 15 or self.m_tBaseData.nType == 16 or self.m_tBaseData.nType == 17 then    --购买金币
        local sGoldLimitNum = self.m_tBaseData.nLeftCount .. "/" .. self.m_tBaseData.nMaxCount
        GetElement(self.m_root, "txtGoldLimitNum_WndBuyActivity", WZUILabelTTF):setText(sGoldLimitNum)
        --设置连续5次按钮不可用
        self:_updateFtnFiveText()
    elseif self.m_tBaseData.nType == 1 then  --购买活力
        local sActLimitNum = self.m_tBaseData.nLeftCount .. "/" .. self.m_tBaseData.nMaxCount
        GetElement(self.m_root, "txtActLimitNum_WndBuyActivity", WZUILabelTTF):setText(sActLimitNum)
    end

    local nConsumeNum = self.m_tBaseData.nCostValue
    local nGainNum = self.m_tBaseData.nResultValue
    GetElement(self.m_root, "txtGainNum_WndBuyActivity", WZUILabelTTF):setText(nGainNum)
    GetElement(self.m_root, "txtDiamondNum_WndBuyActivity", WZUILabelTTF):setText(nConsumeNum)
end

--@brief    更新界面显示信息
function WndBuyActivity:updateDisplay()
    -- body
    local bUpdateTime = false
    if WndBuyActivity.m_tBaseData.nType == 1 then     --摇钱树界面才显示
        if WndBuyActivity.m_nNextReSeconds >= 1 and WndBuyActivity.m_nNextReSeconds ~= nil then
            bUpdateTime = true
            WndBuyActivity.m_nNextReSeconds = WndBuyActivity.m_nNextReSeconds - 1
            if WndBuyActivity.m_nNextReSeconds == 0 then
                WZLog("******** 222222 ***********")
                ProtocolProcessorWndShop:send_MALL_GetLimitedTime(2)
            end
        else
            if CacheCenter:getPlayerInfo().vigor < CacheCenter:getPlayerInfo().maxVigor then
                WZLog("******** 333333 ***********")
                ProtocolProcessorWndShop:send_MALL_GetLimitedTime(2)
            end
        end

        if bUpdateTime then 
            WndBuyActivity:updateLeftTime(WndBuyActivity.m_nFullReSeconds, WndBuyActivity.m_nNextReSeconds)
        end
    end
end

--@brief    更新消耗进度
function WndBuyActivity:_updateConsumePrg(nCurCost)
    -- body
    if self.m_tBaseData.nType == 13 or self.m_tBaseData.nType == 15 or self.m_tBaseData.nType == 16 or self.m_tBaseData.nType == 17 then
        GetElement(self.m_root, "conConsume_WndBuyActivity", WZUIContainer):setVisible(false)
        return 
    end
    local prgConsume = GetElement(self.m_root, "prgConsume_WndBuyActivity", WZUIProgress)
    if prgConsume then
        if self.m_nCousumeMax == nil or self.m_nCousumeMax == 0 then
            prgConsume:setPercentage(0)
        else
            prgConsume:setPercentage(math.floor(100 * nCurCost/self.m_nCousumeMax))
        end
    end
    local ftxtConsumeValue = GetElement(self.m_root, "ftxtConsumeValue_WndBuyActivity", WZUIFreeTextBox)
    local returnNum = self:getReturnData()
    local tCostItemData = GDatatab_item["id_" .. self.m_tBaseData.nCostType]
    if ftxtConsumeValue then
        ftxtConsumeValue:setShowText(string.format(LocalStrings.BUYACTIVITY_RETURN, tCostItemData.icon, nCurCost, self.m_nCousumeMax, tCostItemData.icon, returnNum))
    end
end

--@brief    设置连摇按钮文本
function WndBuyActivity:_updateFtnFiveText()
    -- body
    local nTimes = 5 
    if self.m_tBaseData.nLeftCount >= 5 then
        nTimes = 5 
    elseif self.m_tBaseData.nLeftCount >= 1 and self.m_tBaseData.nLeftCount < 5 then
        nTimes = self.m_tBaseData.nLeftCount
    elseif self.m_tBaseData.nLeftCount < 1 then
        nTimes = 5
    end
    if self.m_tBaseData.nType == 15 then
        local nLeftNum = tonumber(CacheCenter:getTabooCoinMaxNum()) - tonumber(CacheCenter:getPlayerItemCountById(60))
        if nTimes > nLeftNum and nLeftNum > 0 then
            nTimes = nLeftNum
        end
    end

    local sFormatBtn = LocalStrings.SHAKE_TIMES
    if self.m_tBaseData.nType == 13 or self.m_tBaseData.nType == 15 or self.m_tBaseData.nType == 16 or self.m_tBaseData.nType == 17 then
        sFormatBtn = LocalStrings.BUY_TIMES
    end

    local text = string.format(sFormatBtn, nTimes)

    GetElement(self.m_root, "txtFiveNor_WndBuyActivity", WZUILabelTTF):setText(text)
    GetElement(self.m_root, "txtFiveSel_WndBuyActivity", WZUILabelTTF):setText(text)
    GetElement(self.m_root, "txtFiveDisable_WndBuyActivity", WZUILabelTTF):setText(text)
end

--@brief    当购买次数用完后，根据情况弹出不同的提示
function WndBuyActivity:_showTipsAccordCase( ... )
    -- body
    local nMaxVipValue = GetMaxVipLevel()
    WZLog("--购买次数不足", CacheCenter:getPlayerInfo().vipLevel, self.m_tBaseData.nType, nMaxVipValue)
    if CacheCenter:getPlayerInfo().vipLevel < nMaxVipValue then
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
        MsgBoxManager:showConfirmBox(LocalStrings.BUY_UNSUCCESS, self, self.needMoreDiamondCallBack, nil, tCustomUIConfig)
    elseif CacheCenter:getPlayerInfo().vipLevel == nMaxVipValue then
        if self.m_tBaseData.nType == 0 then
            local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.CONFIRM}
            MsgBoxManager:showTipBox(LocalStrings.SHAKE_TIMES_FINISH)
        elseif self.m_tBaseData.nType == 1 then 
            MsgBoxManager:showTipBox(LocalStrings.BUY_ACTIVITY_TIMES_FINISH)
        elseif self.m_tBaseData.nType == 13 or self.m_tBaseData.nType == 15 or self.m_tBaseData.nType == 16 or self.m_tBaseData.nType == 17 then 
            MsgBoxManager:showTipBox(LocalStrings.SHOP_DAY_LIMITED)
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Begin--------------------------------------
--@brief 简体适配函数
--@note  简体适配
function WndBuyActivity:_adaptLanguage_cn()
    -- GetElement(self.m_root, "armatureFire_WndBuyActivity", WZArmature):setVisible(false)
end

--@brief 繁体适配函数
--@note  繁体适配
function WndBuyActivity:_adaptLanguage_hk()
    
end
--@brief 英文适配函数
--@note  英文适配
function WndBuyActivity:_adaptLanguage_en()
    GetElement(self.m_root, "txtConsume_WndBuyActivity", WZUILabelTTF):setVisible(false)
    GetElement(self.m_root,"txtDiamondNum_WndBuyActivity",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-1,0.5))
    GetElement(self.m_root,"txtCanGain_WndBuyActivity",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.264,0.5))
    GetElement(self.m_root,"txtGainNum_WndBuyActivity",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.288,0.57))
    GetElement(self.m_root,"imgIconActivity_WndBuyActivity",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.8,0.5))

    local txtOnceTime = GetElement(self.m_root,"txtOnceTime_WndBuyActivity",WZUILabelTTF)
    txtOnceTime:setDimensions(GlobalMethod:CCSize(120))
    txtOnceTime:setScale(0.8)
    local txtFiveNor = GetElement(self.m_root,"txtFiveNor_WndBuyActivity",WZUILabelTTF)
    txtFiveNor:setDimensions(GlobalMethod:CCSize(120))
    txtFiveNor:setScale(0.8)
    local txtFiveSel = GetElement(self.m_root,"txtFiveSel_WndBuyActivity",WZUILabelTTF)
    txtFiveSel:setDimensions(GlobalMethod:CCSize(120))
    txtFiveSel:setScale(0.8)
    local txtFiveDisable = GetElement(self.m_root,"txtFiveDisable_WndBuyActivity",WZUILabelTTF)
    txtFiveDisable:setDimensions(GlobalMethod:CCSize(120))
    txtFiveDisable:setScale(0.8)
    -- GetElement(self.m_root, "armatureFire_WndBuyActivity", WZArmature):setVisible(false)
end
--@brief 葡语适配函数
--@note  葡语适配
function WndBuyActivity:_adaptLanguage_pt()
    GetElement(self.m_root,"txtDiamondNum_WndBuyActivity",WZUILabelTTF):setFontSize(18)
    local txtCanGain = GetElement(self.m_root,"txtCanGain_WndBuyActivity",WZUILabelTTF)
    txtCanGain:setFontSize(16)
    txtCanGain:setRelativePosition(GlobalMethod:ccp(0.48,0.5))

    GetElement(self.m_root, "imgIconActivity_WndBuyActivity", WZUIImage):setRelativePosition(GlobalMethod:ccp(1.42,0.5))
    GetElement(self.m_root, "imgIconDiamond_WndBuyActivity", WZUIImage):setRelativePosition(GlobalMethod:ccp(1.42,0.5))
    
    local txtGainNum = GetElement(self.m_root,"txtGainNum_WndBuyActivity",WZUILabelTTF)
    txtGainNum:setFontSize(16)
    txtGainNum:setRelativePosition(GlobalMethod:ccp(0.55,0.57))

    local txtGoldLimit = GetElement(self.m_root, "txtGoldLimit_WndBuyActivity", WZUILabelTTF)
    txtGoldLimit:setScale(0.8)
    txtGoldLimit:setRelativePosition(GlobalMethod:ccp(0.76,0.5))
    local txtGoldLimitNum = GetElement(self.m_root, "txtGoldLimitNum_WndBuyActivity", WZUILabelTTF)
    txtGoldLimitNum:setScale(0.8)
    txtGoldLimitNum:setRelativePosition(GlobalMethod:ccp(1,0.5))

    local txtActivityLimit = GetElement(self.m_root,"txtActivityLimit_WndBuyActivity",WZUILabelTTF)
    txtActivityLimit:setFontSize(17)
    txtActivityLimit:setRelativePosition(GlobalMethod:ccp(0.7,0.5))
    local txtActLimitNum = GetElement(self.m_root,"txtActLimitNum_WndBuyActivity",WZUILabelTTF)
    txtActLimitNum:setFontSize(18)
    txtActLimitNum:setRelativePosition(GlobalMethod:ccp(0.7,0.5))

    local txtOnceTime = GetElement(self.m_root,"txtOnceTime_WndBuyActivity",WZUILabelTTF)
    txtOnceTime:setDimensions(GlobalMethod:CCSize(120))
    txtOnceTime:setScale(0.8)
    local txtFiveNor = GetElement(self.m_root,"txtFiveNor_WndBuyActivity",WZUILabelTTF)
    txtFiveNor:setDimensions(GlobalMethod:CCSize(120))
    txtFiveNor:setScale(0.8)
    local txtFiveSel = GetElement(self.m_root,"txtFiveSel_WndBuyActivity",WZUILabelTTF)
    txtFiveSel:setDimensions(GlobalMethod:CCSize(120))
    txtFiveSel:setScale(0.8)
    local txtFiveDisable = GetElement(self.m_root,"txtFiveDisable_WndBuyActivity",WZUILabelTTF)
    txtFiveDisable:setDimensions(GlobalMethod:CCSize(120))
    txtFiveDisable:setScale(0.8)
end

--@brief  越南语适配函数
--@return 无
--@note   备注
function WndBuyActivity:_adaptLanguage_vn()
    --GetElement(self.m_root,"txtDiamondNum_WndBuyActivity",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtCanGain_WndBuyActivity",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtGainNum_WndBuyActivity",WZUILabelTTF):setFontSize(18)

    GetElement(self.m_root, "txtConsume_WndBuyActivity", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.06,0.5))
    -- GetElement(self.m_root, "imgDiamond_WndBuyActivity", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.0666667,0.5))
    GetElement(self.m_root, "txtDiamondNum_WndBuyActivity", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.88,0.5))
    GetElement(self.m_root, "txtCanGain_WndBuyActivity", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.476,0.5))
    GetElement(self.m_root, "txtGainNum_WndBuyActivity", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.57))

    GetElement(self.m_root, "imgIconActivity_WndBuyActivity", WZUIImage):setRelativePosition(GlobalMethod:ccp(1.33333,0.5))
    GetElement(self.m_root, "imgIconDiamond_WndBuyActivity", WZUIImage):setRelativePosition(GlobalMethod:ccp(1.33333,0.5))

end

function WndBuyActivity:_adaptLanguage_tr( )
    local txtActivity = GetElement(self.m_root,"txtActivityLimit_WndBuyActivity",WZUILabelTTF)
    txtActivity:setFontSize(18)
    txtActivity:setRelativePosition(GlobalMethod:ccp(0.73,0.5))
    local txtActLimit = GetElement(self.m_root,"txtActLimitNum_WndBuyActivity",WZUILabelTTF)
    txtActLimit:setFontSize(20)
    txtActLimit:setRelativePosition(GlobalMethod:ccp(0.73,0.5))

    local txtGoldLimit = GetElement(self.m_root,"txtGoldLimit_WndBuyActivity",WZUILabelTTF)
    --txtGoldLimit:setDimensions(GlobalMethod:CCSize(80,0))
    txtGoldLimit:setFontSize(14)

    local txtOnceTime = GetElement(self.m_root,"txtOnceTime_WndBuyActivity",WZUILabelTTF)
    txtOnceTime:setDimensions(GlobalMethod:CCSize(130,0))
    txtOnceTime:setScale(0.8)

    local txtFiveNor = GetElement(self.m_root,"txtFiveNor_WndBuyActivity",WZUILabelTTF)
    txtFiveNor:setDimensions(GlobalMethod:CCSize(130,0))
    txtFiveNor:setScale(0.8)

    local txtFiveSel = GetElement(self.m_root,"txtFiveSel_WndBuyActivity",WZUILabelTTF)
    txtFiveSel:setDimensions(GlobalMethod:CCSize(130,0))
    txtFiveSel:setScale(0.8)

    local txtFiveDisable = GetElement(self.m_root,"txtFiveDisable_WndBuyActivity",WZUILabelTTF)
    txtFiveDisable:setDimensions(GlobalMethod:CCSize(130,0))
    txtFiveDisable:setScale(0.8)
end

function WndBuyActivity:_adaptLanguage_es(  )
    local txtOnceTime = GetElement(self.m_root,"txtOnceTime_WndBuyActivity",WZUILabelTTF)
    txtOnceTime:setDimensions(GlobalMethod:CCSize(120))
    txtOnceTime:setScale(0.8)
    local txtFiveNor = GetElement(self.m_root,"txtFiveNor_WndBuyActivity",WZUILabelTTF)
    txtFiveNor:setDimensions(GlobalMethod:CCSize(120))
    txtFiveNor:setScale(0.8)
    local txtFiveSel = GetElement(self.m_root,"txtFiveSel_WndBuyActivity",WZUILabelTTF)
    txtFiveSel:setDimensions(GlobalMethod:CCSize(120))
    txtFiveSel:setScale(0.8)
    local txtFiveDisable = GetElement(self.m_root,"txtFiveDisable_WndBuyActivity",WZUILabelTTF)
    txtFiveDisable:setDimensions(GlobalMethod:CCSize(120))
    txtFiveDisable:setScale(0.8)

    local txtConsume = GetElement(self.m_root,"txtConsume_WndBuyActivity",WZUILabelTTF)
    txtConsume:setFontSize(16)
    txtConsume:setRelativePosition(GlobalMethod:ccp(0.07,0.5))

    local txtGoldLimit = GetElement(self.m_root, "txtGoldLimit_WndBuyActivity", WZUILabelTTF)
    txtGoldLimit:setScale(0.8)
    txtGoldLimit:setDimensions(GlobalMethod:CCSize(110,0))

    GetElement(self.m_root, "imgCostIcon_WndBuyActivity", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.8,0.5))
    GetElement(self.m_root, "txtDiamondNum_WndBuyActivity", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.3,0.5))
end

function WndBuyActivity:_adaptLanguage_th(  )
    -- GetElement(self.m_root, "armatureFire_WndBuyActivity", WZArmature):setVisible(false)
end

function WndBuyActivity:_adaptLanguage_ug()
    GetElement(self.m_root,"txtDiamondNum_WndBuyActivity",WZUILabelTTF):setFontSize(18)
    local txtCanGain = GetElement(self.m_root,"txtCanGain_WndBuyActivity",WZUILabelTTF)
    txtCanGain:setFontSize(16)
    txtCanGain:setRelativePosition(GlobalMethod:ccp(0.48,0.5))

    GetElement(self.m_root, "imgIconActivity_WndBuyActivity", WZUIImage):setRelativePosition(GlobalMethod:ccp(1.42,0.5))
    GetElement(self.m_root, "imgIconDiamond_WndBuyActivity", WZUIImage):setRelativePosition(GlobalMethod:ccp(1.42,0.5))
    
    local txtGainNum = GetElement(self.m_root,"txtGainNum_WndBuyActivity",WZUILabelTTF)
    txtGainNum:setFontSize(16)
    txtGainNum:setRelativePosition(GlobalMethod:ccp(0.55,0.57))

    local txtGoldLimit = GetElement(self.m_root, "txtGoldLimit_WndBuyActivity", WZUILabelTTF)
    txtGoldLimit:setScale(0.8)
    txtGoldLimit:setRelativePosition(GlobalMethod:ccp(0.76,0.5))
    local txtGoldLimitNum = GetElement(self.m_root, "txtGoldLimitNum_WndBuyActivity", WZUILabelTTF)
    txtGoldLimitNum:setScale(0.8)
    txtGoldLimitNum:setRelativePosition(GlobalMethod:ccp(1,0.5))

    local txtActivityLimit = GetElement(self.m_root,"txtActivityLimit_WndBuyActivity",WZUILabelTTF)
    txtActivityLimit:setFontSize(17)
    txtActivityLimit:setRelativePosition(GlobalMethod:ccp(0.7,0.5))
    local txtActLimitNum = GetElement(self.m_root,"txtActLimitNum_WndBuyActivity",WZUILabelTTF)
    txtActLimitNum:setFontSize(18)
    txtActLimitNum:setRelativePosition(GlobalMethod:ccp(0.7,0.5))

    local txtOnceTime = GetElement(self.m_root,"txtOnceTime_WndBuyActivity",WZUILabelTTF)
    txtOnceTime:setDimensions(GlobalMethod:CCSize(160))
    txtOnceTime:setScale(0.7)
    local txtFiveNor = GetElement(self.m_root,"txtFiveNor_WndBuyActivity",WZUILabelTTF)
    txtFiveNor:setDimensions(GlobalMethod:CCSize(160))
    txtFiveNor:setScale(0.7)
    local txtFiveSel = GetElement(self.m_root,"txtFiveSel_WndBuyActivity",WZUILabelTTF)
    txtFiveSel:setDimensions(GlobalMethod:CCSize(160))
    txtFiveSel:setScale(0.7)
    local txtFiveDisable = GetElement(self.m_root,"txtFiveDisable_WndBuyActivity",WZUILabelTTF)
    txtFiveDisable:setDimensions(GlobalMethod:CCSize(160))
    txtFiveDisable:setScale(0.7)

    local txtConsume = GetElement(self.m_root, "txtConsume_WndBuyActivity", WZUILabelTTF)
    txtConsume:setScale(0.7)
    txtConsume:setRelativePosition(GlobalMethod:ccp(0.07,0.5))
    local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndBuyActivity", WZUIImage)
    imgCostIcon:setScale(0.7)
    imgCostIcon:setRelativePosition(GlobalMethod:ccp(0.725,0.5))
    local txtDiamondNum = GetElement(self.m_root, "txtDiamondNum_WndBuyActivity", WZUILabelTTF)
    txtDiamondNum:setScale(0.7)
    txtDiamondNum:setRelativePosition(GlobalMethod:ccp(1.05833,0.5))
    local txtCanGain = GetElement(self.m_root, "txtCanGain_WndBuyActivity", WZUILabelTTF)
    txtCanGain:setScale(0.7)
    txtCanGain:setRelativePosition(GlobalMethod:ccp(0.43,0.5))
    local txtGainNum = GetElement(self.m_root, "txtGainNum_WndBuyActivity", WZUILabelTTF)
    txtGainNum:setScale(0.7)
    txtGainNum:setRelativePosition(GlobalMethod:ccp(0.5,0.57))

    local imgIconDiamond = GetElement(self.m_root, "imgIconDiamond_WndBuyActivity", WZUIImage)
    imgIconDiamond:setScale(0.7)
    imgIconDiamond:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    local txtGoldLimit = GetElement(self.m_root, "txtGoldLimit_WndBuyActivity", WZUILabelTTF)
    txtGoldLimit:setScale(0.8)
    txtGoldLimit:setRelativePosition(GlobalMethod:ccp(0.8,0.5))
    txtGoldLimit:setDimensions(GlobalMethod:CCSize(200))
    local txtGoldLimitNum = GetElement(self.m_root, "txtGoldLimitNum_WndBuyActivity", WZUILabelTTF)
    txtGoldLimitNum:setScale(0.8)
    txtGoldLimitNum:setRelativePosition(GlobalMethod:ccp(1,0.5))

    local imgIconActivity = GetElement(self.m_root, "imgIconActivity_WndBuyActivity", WZUIImage)
    imgIconActivity:setScale(0.7)
    imgIconActivity:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    local txtActivityLimit = GetElement(self.m_root, "txtActivityLimit_WndBuyActivity", WZUILabelTTF)
    txtActivityLimit:setScale(0.8)
    txtActivityLimit:setRelativePosition(GlobalMethod:ccp(0.8,0.5))
    txtActivityLimit:setDimensions(GlobalMethod:CCSize(200))
    local txtActLimitNum = GetElement(self.m_root, "txtActLimitNum_WndBuyActivity", WZUILabelTTF)
    txtActLimitNum:setScale(0.8)
    txtActLimitNum:setRelativePosition(GlobalMethod:ccp(0.816346,0.5))
end

-------------------------------------语言适配模块End--------------------------------------
