--CellVipPowerList.lua
--@brief	CellVipPowerList的UI模块
--@date		2014/04/24
--@author	jiaming_liu
--@modify   binshao 2015-5-8
--@note		1-10级会员权限列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellVipPowerList:onEnter(element)
	self.m_root = element
	--多语言版本界面适配
    
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellVipPowerList:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellVipPowerList:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellVipPowerList")
    self.m_root:addChild(cellElement)
	AdaptLanguage(self)
    self:_update()
end

-- 充值处理回调
function CellVipPowerList:onRechage()
    WZLog("CellVipPowerList:onRechage =",self.data.showType)
    if tostring(ProjConfig:getChannelId()) == "8888" or tostring(ProjConfig:getChannelId()) == "53" or tostring(ProjConfig:getChannelId()) == "75" or tostring(ProjConfig:getChannelId()) == "275" or tostring(ProjConfig:getChannelId()) == "68" or tostring(ProjConfig:getChannelId()) == "10" then
        return
    end

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.data.showType == 0 then
        WZLog("-------------- rechage info ----------------",self.data.ids,self.data.price,self.data.name,self.data.payCodeId)
        if self.data.itemId == 50 then
            if CacheCenter:canBuyMouthCard() then
                local limitDay = CacheCenter:getGameParam().limitMonthlyCardDay
                MsgBoxManager:showTipBox(string.format(LocalStrings.MAX_MOUTH_CARD,tonumber(limitDay)))
                return
            end
        end

        if WndVip:isCountry() then
            local code = WndVipCountry:getWayCode()
            WZLog("CellVipPowerList:onRechage", code)
            if code == nil then
                local country, way = WndVipCountry:getCountry(), WndVipCountry:getWay()
                country = country == 0 and 1 or country
                way = way == 0 and 1 or way
                local wndVipCountry = WndVipCountry:createElement()
                WndVipCountry:setData(country, way, self.data.price)
                WindowManager:addWindow(wndVipCountry,WndVipCountry,nil,false)
                return
            end
        end

        if (not WndVip:isCountry()) and (tonumber(ProjConfig.CHANNEL_ID) == 1042 or tonumber(ProjConfig.CHANNEL_ID) == 1044) and CacheCenter:getPlayerInfo().level >= 15 and PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID then

            local wndVipChoose = WndVipChoose:createElement()
            if wndVipChoose ~= nil then
                WindowManager:addWindow(wndVipChoose, WndVipChoose, false)
                WndVipChoose:setData(self.sdkData)
            end

        else
            WndVip:createLoadingUI()
            PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
            for k, v in pairs(self.sdkData) do
                WZLog("-----------sdk vip info------------",k,v)
            end
            if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID and (not WndVip:isCountry()) then
                PassportSdkManager.s_paymentId = "google"
                PassportSdkManager.s_paymentEmail = ""
            elseif PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID then
                -- PassportSdkManager.s_paymentId = WndVipCountry:getWayCode()
                -- PassportSdkManager.s_paymentEmail = ""

                local wndVipChooseMail = WndVipChooseMail:createElement()
                WindowManager:addWindow(wndVipChooseMail, WndVipChooseMail, false)
                WndVipChooseMail:setData(self.sdkData)
                WndVipChooseMail.pmId = WndVipCountry:getWayCode()
                WndVip:closeLoadingUI()
                return
            end
            -- SDKOtherConfig.isHasAuto == "true"时，channelId=1089的美洲ios包点击购买月卡由消耗型改为自动续订型 --1089变为1102
            --if self.sdkData ~= nil and self.sdkData.payCode == "yido_item_1399" and tonumber(ProjConfig:getChannelId()) == 1102 then
            if self.data.itemId == 50 and checkIsOpenIOSAutoRenewalSubscription() == true then
                WZLog("CellVipPowerList:onRechage_自动订阅", self.data.name, self.data.payCodeId, ProjConfig:getChannelId())
                local curSdkObj = PassportSdkManager:getCurSdkObj()
                --if curSdkObj then
                    --local config = curSdkObj.m_tConfig
                    --if config then
                        --if config.SDKOtherConfig.isHasAuto == "true" then
                            WZLog("CellVipPowerList:onRechage_自动订阅", "跳转到福利卡界面")
                            --curSdkObj:setCallbackByName("others",PassportSdkManager.payCallback, PassportSdkManager)
                            SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

                            if CheckButtonOpen(ISLAND_UP_CARD_WELFARE) then
                                --WndGameActivity:showInterface(167)
                                if WndVip.m_root then 
                                    WZLog("CellVipPowerList:onRechage_自动订阅", "关闭充值界面");
                                    WndVip:onTempClose()
                                end
                                WndFreeca:showInterface(g_tGameActivityTypes.ACTIVITY_MONTHCARD)
                                WndVip:closeLoadingUI()
                                return
                            end
                        --end
                    --end
                --end
            end
            PassportSdkManager:getOrderNum(self.sdkData)
            PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep4,g_payEventId)
        end
        -- PassportSdkManager:getOrderNum(self.sdkData)
        -- PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep4,g_payEventId)

    elseif self.data.showType == 1 then

        local wndVipGift = WndVipGift:createElement()
        if wndVipGift ~= nil then
            WindowManager:addWindow(wndVipGift, WndVipGift, false)
            WndVipGift:setData(self.data, self.sdkData)
        end
    end
end 

--@note		设置UI界面数据
function CellVipPowerList:_update()
    local curData = self.data
    local locData = GDatatab_recharge["id_"..curData.ids]

    local imgBg = GetElement(self.m_root, "imgBg_CellVipPowerList", WZUIImage)
    WZLog("-----------curItemId--------------",Serialize(curData))
    -- if curData.itemId == 50 then
    --     imgBg:setFile("ui/common/month_card_goldbg.png")
    -- elseif curData.itemId == 51 then
    --     imgBg:setFile("ui/common/month_card_bluebg.png")
    -- end

	--设置icon图标
    local imgDiamond = GetElement(self.m_root, "imgDiamond_CellVipPowerList", WZUIImage)
    imgDiamond:setFile(GDatatab_item["id_"..curData.itemId].icon)
	if WndVip.TabState == 1 and curData.icons ~= nil then
    	imgDiamond:setFile(curData.icons)
	end

    -- 设置标签，推荐和首充翻倍
    local imgIconTitleDi =  GetElement(self.m_root, "imgIconDescDi_CellVipPowerList", WZUIImage)
    local imgIconTitle =  GetElement(self.m_root, "imgIconDesc_CellVipPowerList", WZUIImage)
    if curData.flag == 3 then
        imgIconTitleDi:setFile("ui/common/common_icon_hongsjb.png")
        imgIconTitle:setFile("ui/common/common_icon_sanbei.png")
    elseif curData.flag == 2 then
        imgIconTitleDi:setFile("ui/common/common_icon_hongsjb.png")
        imgIconTitle:setFile("ui/common/common_icon_shuangbeiz.png")
    elseif curData.flag == 1 then
        imgIconTitleDi:setFile("ui/common/common_icon_zijb.png")
        imgIconTitle:setFile("ui/common/common_icon_tuijian.png")
    else
        imgIconTitleDi:setVisible(false)
        imgIconTitle:setVisible(false)
    end

    -- 名字
    local txtName =  GetElement(self.m_root, "txtName_CellVipPowerList", WZUILabelTTF)
    txtName:setText(locData.name)

    -- rmb
    local txtRmb =  GetElement(self.m_root, "txtRmb_CellVipPowerList", WZUILabelTTF)
    txtRmb:setUseSystemFont(true)
    txtRmb:setText(curData.showPrice)

    -- 说明
    local conOnly = GetElement(self.m_root, "conOnly_CellVipPowerList", WZUIContainer)
    if curData.remark and curData.remark ~= "" then
        local txtDesc =  GetElement(self.m_root, "txtRemark_CellVipPowerList", WZUILabelTTF)
        local txtDesc1 =  GetElement(self.m_root, "txtRemark1_CellVipPowerList", WZUILabelTTF)
        -- 长的描述需要修改
        if curData.flag == 2 then
            txtDesc:setText(locData.first_remark)
        else
            if locData.remark ~= "-1" then
                if string.len(curData.remark) > 24 then
                    txtDesc1:setText(locData.remark)
                else
                    txtDesc:setText(curData.remark)
                end
            end
        end
        conOnly:setVisible(true)
    else
        conOnly:setVisible(false)
    end

    -- 赠送说明
    local conGiven = GetElement(self.m_root, "conGiven_CellVip", WZUIContainer)
    if curData.giftNumber > 0 then
        conGiven:setVisible(true)
        local txtGiven = GetElement(self.m_root, "txtGiven_CellVipPowerList", WZUILabelTTF)
        txtGiven:setText(curData.giftNumber)
    else
        conGiven:setVisible(false)
    end

    if curData.limitType and curData.limitType ~= 0 then
        local txtMoney = GetElement(self.m_root, "txtRemain_WndVip", WZUILabelTTF)
        txtMoney:setText(string.format(LocalStrings.LAST_COUNT, curData.leftTimes))
        txtMoney:setVisible(true)

        --根据渠道号屏蔽限购
        local tabChannel = {1042,1043,1065,1066,1067,1069,1072,1074,1087,1089,1091,1094,1096,1097,1098,1101,1099,1102,1103,1104,1105}
        for _,v in ipairs(tabChannel) do
            if ProjConfig.CHANNEL_ID == v then
                txtMoney:setVisible(false)
            end
        end
    end

    --是否许愿池buffer 加成
    -- imgIconPromiseBuffer
    local m_imgIconPromiseBuffer = GetElement(self.m_root, "imgIconPromiseBuffer", WZUIImage)
    if WndPromiseShrine:checkRechargeIdIsValidBuffer(curData.ids) then
        m_imgIconPromiseBuffer:setVisible(true)
    else
        m_imgIconPromiseBuffer:setVisible(false)
    end

    WZLog("-----------curItemId1--------------",curData.itemId)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------语言适配模块Star--------------------------------------
function CellVipPowerList:_adaptLanguage_en()

	GetElement(self.m_root,"conGiven_CellVip",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.914473,0.78))
	GetElement(self.m_root,"txtGiven22_CellVipPowerList",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.035,0.65))
	GetElement(self.m_root,"txtRemark_CellVipPowerList",WZUILabelTTF):setFontSize(15)
	GetElement(self.m_root,"txtRemark1_CellVipPowerList",WZUILabelTTF):setFontSize(15)
	GetElement(self.m_root,"txtName_CellVipPowerList",WZUILabelTTF):setFontSize(15)

    GetElement(self.m_root, "txtRemain_WndVip", WZUILabelTTF):setScale(0.7)
end

function CellVipPowerList:_adaptLanguage_pt(  )
    GetElement(self.m_root,"conGiven_CellVip",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.914473,0.78))
    local txtGiven = GetElement(self.m_root,"txtGiven22_CellVipPowerList",WZUILabelTTF)
    txtGiven:setRelativePosition(GlobalMethod:ccp(0.15,0.65))
    txtGiven:setFontSize(11)
    local img = GetElement(self.m_root,"imgGiven_CellVipPowerList",WZUIImage)
    img:setRelativePosition(GlobalMethod:ccp(0.7,0.87))
    GetElement(self.m_root,"txtRemark_CellVipPowerList",WZUILabelTTF):setFontSize(15)
    local txtRemark1 = GetElement(self.m_root,"txtRemark1_CellVipPowerList",WZUILabelTTF)
    txtRemark1:setFontSize(14)
    local txtName = GetElement(self.m_root,"txtName_CellVipPowerList",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(220))

    local imgIconDesc = GetElement(self.m_root,"imgIconDesc_CellVipPowerList",WZUIImage)
    imgIconDesc:setScale(0.7)
    imgIconDesc:setRelativePosition(GlobalMethod:ccp(0.697368,0.308824))
    
    GetElement(self.m_root, "txtRemain_WndVip", WZUILabelTTF):setScale(0.6)
end

function CellVipPowerList:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtName_CellVipPowerList",WZUILabelTTF):setFontSize(20)
    --GetElement(self.m_root,"conGiven_CellVip",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.914473,0.85))
    local img = GetElement(self.m_root,"imgGiven_CellVipPowerList",WZUIImage)
    img:setRelativePosition(GlobalMethod:ccp(0.72,0.87))
end

function CellVipPowerList:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtRemark1_CellVipPowerList",WZUILabelTTF):setFontSize(15)
    local txtGiven = GetElement(self.m_root,"txtGiven22_CellVipPowerList",WZUILabelTTF)
    txtGiven:setRelativePosition(GlobalMethod:ccp(0.15,0.65))
    txtGiven:setFontSize(13)

    local img = GetElement(self.m_root,"imgGiven_CellVipPowerList",WZUIImage)
    img:setRelativePosition(GlobalMethod:ccp(0.72,0.68))
end

function CellVipPowerList:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtRemark1_CellVipPowerList",WZUILabelTTF):setFontSize(15)
    local txtGiven = GetElement(self.m_root,"txtGiven22_CellVipPowerList",WZUILabelTTF)
    txtGiven:setRelativePosition(GlobalMethod:ccp(0.15,0.65))
    txtGiven:setFontSize(13)

    local img = GetElement(self.m_root,"imgGiven_CellVipPowerList",WZUIImage)
    img:setRelativePosition(GlobalMethod:ccp(0.72,0.87))
end

function CellVipPowerList:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtRemark1_CellVipPowerList",WZUILabelTTF):setFontSize(15)
    local txtGiven = GetElement(self.m_root,"txtGiven22_CellVipPowerList",WZUILabelTTF)
    txtGiven:setRelativePosition(GlobalMethod:ccp(0.15,0.65))
    txtGiven:setFontSize(13)

    local img = GetElement(self.m_root,"imgGiven_CellVipPowerList",WZUIImage)
    img:setRelativePosition(GlobalMethod:ccp(0.72,0.87))
    local txtName = GetElement(self.m_root,"txtName_CellVipPowerList",WZUILabelTTF)
    txtName:setFontSize(16)
    txtName:setDimensions(GlobalMethod:CCSize(180,0))

    GetElement(self.m_root, "txtRemain_WndVip", WZUILabelTTF):setScale(0.6)
end
-------------------------------------语言适配模块End--------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------
