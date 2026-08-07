--WndVip.lua
--@brief	WndVip的UI模块
--@date		2015-9-15
--@author	binshao
--@note		VIP模块

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndVip:onEnter(element)
    self.m_root = element
    AdaptLanguage(self)
    ChangeChatChannel(Chat_Channel_Vip_Recharge)
end

--@brief	打开加载动画
function WndVip:onEnterTransitionDidFinish(element)
    PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep3,g_payEventId)
    WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
	ProtocolProcessorWndVip:regAll()
	ProtocolProcessorWndVip:send_VIP_GetVipPrivilegeGift()
    ProtocolProcessorWndVip:send_ACTIVITY_GetWelfareCardActivityInfo(g_tGameActivityTypes.ACIVIITY_MONTHCARD_DISCOUNT)

    if self:isWebShow() then
        ProtocolProcessorWndVip:send_VIP_GetWebInfo( )
    end

	GetElement(self.m_root,"checkbox3_TempLeftTab",WZUICheckBox):setVisible(false)
	if CheckButtonShow(106) then
		GetElement(self.m_root,"checkbox3_TempLeftTab",WZUICheckBox):setVisible(true)
	end
	GetElement(self.m_root,"checkbox2_TempLeftTab",WZUICheckBox):setVisible(false)
	if CheckButtonShow(107) then
		GetElement(self.m_root,"checkbox2_TempLeftTab",WZUICheckBox):setVisible(true)
	end
    if not CheckButtonShow(106) and not CheckButtonShow(107) then
        GetElement(self.m_root,"checkbox4_TempLeftTab",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0,0.505))
    elseif CheckButtonShow(106) and not CheckButtonShow(107) then
        GetElement(self.m_root,"checkbox3_TempLeftTab",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0,0.505))
        GetElement(self.m_root,"checkbox4_TempLeftTab",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0,0.175))
    end
    --苹果审核状态不显示周礼包标签
    GetElement(self.m_root,"checkbox4_TempLeftTab",WZUICheckBox):setVisible(true)
    WZLog("审核状态", type(CacheCenter:getGameParam().gameStatus), CacheCenter:getGameParam().gameStatus)
    if tonumber(CacheCenter:getGameParam().gameStatus) == 1 then
        GetElement(self.m_root,"checkbox4_TempLeftTab",WZUICheckBox):setVisible(false)
    end
    AdaptLanguage(self)
end

function WndVip:isWebShow()
    local isWebShow = CheckButtonShow(130)

    if isWebShow then
        local version = string.gsub(WZDeviceInfo:appVersion(), "%.", ""); 

        local versionNo = tonumber(CacheCenter:getGameParam().webpage or 113)
        WZLog("WndVip:isWebShow1", version, versionNo, tostring(CacheCenter:getGameParam().webpage), isWebShow);
        if tonumber(version) > versionNo then
            isWebShow = false
        end

        WZLog("WndVip:isWebShow2", version, isWebShow);
    end

    return isWebShow
end

function WndVip:onTouchBegan()
	WndItemInfo:onCloseClick()
    WndTips:_onCloseClick()
end

--@brief	窗口动画完成回调
function WndVip:actionCallback(elem,data)
    --self:_update()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndVip:onExit(element)
    if self.m_conMid then 
        self.m_conMid:disableSchedule()
    end
    self.m_root:disableSchedule()
	self:_unInit()
	--ProtocolProcessorWndVip:unregAll()
    Teach:isStartTeach("WndVip:onExit", Teach.PreUIChannelId)
end

-- @brief    是否显示选择国家按钮
function WndVip:isCountry()
    local isCountry = CheckButtonShow(128)

    if isCountry then
        local version = string.gsub(WZDeviceInfo:appVersion(), "%.", ""); 

        local versionNo = 111
        WZLog("WndVip:isCountry1", version, versionNo, isCountry);
        if tonumber(version) < versionNo then
            isCountry = false
        end

        if ProjConfig.LANGUAGE == "cn" then
            isCountry = false
        end

        WZLog("WndVip:isCountry2", version, isCountry);
    end

    return isCountry
end

-- 选择充值方式
function WndVip:onCountry()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndVip:onCountry")

    local country, way = WndVipCountry:getCountry(), WndVipCountry:getWay()
    country = country == 0 and 1 or country
    way = way == 0 and 1 or way
    local wndVipCountry = WndVipCountry:createElement()
    WndVipCountry:setData(country, way)
    WindowManager:addWindow(wndVipCountry,WndVipCountry,nil,false)
end

-- 选择充值方式
function WndVip:setCountryNew(isNew)
    WZLog("WndVip:setCountryNew", isNew)
    GetElement(self.m_root, "imgPrivilegeNew_WndVip", WZUIImage):setVisible(isNew)
end

-- 显示VIP窗口
function WndVip:showWndUI(tag, needUpdate)
    if not CheckButtonOpen(ISLAND_UP_RECHARGE) then
        return
    end

    self.m_TempRoot = WndVip.m_root
    self.m_isNoWnd = false  
    self.m_needUpdate = needUpdate 
    if not WndVip.m_root then
        self.m_isNoWnd = true
        local wndVip = WndVip:createElement()
        WindowManager:addWindow( wndVip , WndVip)
    end
    self.btnState = tag
    local vipLevel = CacheCenter:getPlayerInfo().vipLevel
    self.powerDescIndex = vipLevel >= 1 and vipLevel or 1
    WZLog("--------------self.powerDescIndex-------------",self.powerDescIndex, tostring(CacheCenter:getVipList()))
    self.rechargeData = CacheCenter:getVipList()

    self:flushInterface(self.btnState)
end

--@brief    刷新界面数据
function WndVip:flushInterface(nTag)
    -- body
    if self.m_TempRoot and self.m_needUpdate or self.m_isNoWnd then
        if self.m_needUpdate and nTag == 0 then --主要用于购买周礼包需要充值的时候跳转
            GetElement(self.m_root, "checkGroup_TempLeftTab", WZUICheckBoxGroup):setCheckIndex(nTag)
            self:setConVisible(nTag + 1)
        end
        self:_update()

        if WndVip:isAnniversaryStart(1496937600) == false then
            WZLog("WndVip:showWndUI two")
            WndVip.m_root:enableSchedule("loop",1)
        end
    end
end

function WndVip:loop(element,dt)
    if WndVip:isAnniversaryStart() then
        self.m_root:disableSchedule()
        self:createLoadingUI()
        ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList(ProjConfig:getChannelId())
    end
end

function WndVip:isAnniversaryStart(testTime)
    local timeCur = os.date("*t",SystemTime:getServerTime())
    -- if testTime then
    --     timeCur = os.date("*t",testTime)
    -- end
    local timeEnd = SplitStringWithSeparator(CacheCenter:getGameParam().nianGifeStar or "", "-", nil, true) or {}
    local DayEndTab = {}
    local time = true
    if #timeEnd == 3 then
        DayEndTab.year = timeEnd[1]
        DayEndTab.month = timeEnd[2]
        DayEndTab.day = timeEnd[3]
        if timeCur.year > DayEndTab.year then
            time = true
        elseif timeCur.year < DayEndTab.year then
            time = false
        elseif timeCur.month > DayEndTab.month then
            time = true
        elseif timeCur.month < DayEndTab.month then
            time = false
        elseif timeCur.month == DayEndTab.month and timeCur.day >= DayEndTab.day then
            time = true
        else
            time = false
        end
    end

    WZLog("WndVip:isAnniversary", time, CacheCenter:getGameParam().nianGifeStar, "timeEnd", timeEnd[1], timeEnd[2], timeEnd[3], "timeCur", timeCur.year, timeCur.month, timeCur.day, "DayEndTab", DayEndTab.year, DayEndTab.month, DayEndTab.day)
    return time
end

-- 处于当前界面才更新数据
function WndVip:showWndUIRecharge()
    if WndVip.m_root then
        self.rechargeData = CacheCenter:getVipList()
        self:_update()
    end
end

function WndVip:getNotRecharge()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("------------------not recharte-----------------1")
    PassportSdkManager:payAppStore("", true)
end

function WndVip:onRuleClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if PassportSdkManager:bAppStorePay() then
        local btnInfo = {{txt = LocalStrings.CONFIRM},{txt = LocalStrings.VIP_NOT_GET,callFunc = {self,self.getNotRecharge}}}
        WndSingleMapDesc:showInterface(LocalStrings.RECHARGE_DESC,btnInfo)
    else
        WndSingleMapDesc:showInterface(LocalStrings.RECHARGE_DESC)
    end
end

function WndVip:onTab(element)
    WZLog("WndVip:onTab", element:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    local nTag = element:getTag()
    self:setConVisible(nTag)
end

--@brief    设置标签内容可见与否
function WndVip:setConVisible(nTag)
    -- body
    self.TabState =  nTag

    -- 设置显示的容器
    local stateConUp, stateConMid, stateConMidGift, stateConMidRebate, stateConWeekPackage
    local conTop = GetElement(self.m_root,"conTop_WndVip",WZUIContainer)
    local conUp = GetElement(self.m_root,"conUp_WndVip",WZUIContainer)
    local conMid = GetElement(self.m_root,"conTab1_WndVip",WZUIContainer)
    local conMidGift = GetElement(self.m_root,"conMidGift_WndVip",WZUIContainer)
    local conMidRebate = GetElement(self.m_root,"conMidRebate_WndVip",WZUIContainer)
    local conWeekPackage = GetElement(self.m_root,"conWeekPackage_WndVip",WZUIContainer)
    local btnCountry = GetElement(self.m_root,"btnCountry_WndVip",WZUIButton)
    if self.TabState == 1 then
        stateConUp = true
        stateConMid = true
        stateConMidGift = false
        stateConMidRebate = false
        statebtnCountry = true
    elseif self.TabState == 2 then
        stateConUp = false
        stateConMid = false
        stateConMidGift = true
        stateConMidRebate = false
        stateConWeekPackage = false
        statebtnCountry = false
    elseif self.TabState == 3 then
        stateConUp = false
        stateConMid = false
        stateConMidGift = false
        stateConMidRebate = true
        stateConWeekPackage = false
        statebtnCountry = false
    elseif self.TabState == 4 then
        stateConUp = false
        stateConMid = false
        stateConMidGift = false
        stateConMidRebate = false
        stateConWeekPackage = true
        statebtnCountry = false
    end
    conTop:setVisible(stateConUp)
    conUp:setVisible(stateConUp)
    conMid:setVisible(stateConMid)
    conMidGift:setVisible(stateConMidGift)
    conMidRebate:setVisible(stateConMidRebate)
    conWeekPackage:setVisible(stateConWeekPackage)
    btnCountry:setVisible(false)
    if WndVip:isCountry() then
        btnCountry:setVisible(statebtnCountry)
    end
end

-- 创建返利列表
function WndVip:_createRebateList()
    if not self.m_tRebateList0 and not self.m_tRebateList1 and not self.m_tRebateList2 then
        self:createLoadingUI()
        return
    end
    local tab = GetElement(self.m_root,"tabRebate_WndVip",WZUITableContainer)

    tab:setVisible(true)

    tab:cleanTable()
    WZLog("WndVip:_createRebateList")
    
    for i = 1, #self.m_tRebateList0 do
        local rData = self.m_tRebateList0[i]
        local cell,tcell = CellVipGiftList:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(rData)
    end
    for i = 1, #self.m_tRebateList1 do
        local rData = self.m_tRebateList1[i]
        local cell,tcell = CellVipGiftList:createElement()
        cell:setTag(i-1+#self.m_tRebateList0)
        tab:setCellElement(cell)
        tcell:setData(rData)
    end
    for i = 1, #self.m_tRebateList2 do
        local rData = self.m_tRebateList2[i]
        local cell,tcell = CellVipGiftList:createElement()
        cell:setTag(i-1+#self.m_tRebateList0+#self.m_tRebateList1)
        tab:setCellElement(cell)
        tcell:setData(rData)
    end
end

-- 创建礼包列表
function WndVip:_createGiftList()
    if not self.m_tGiftList then
        self:createLoadingUI()
        return
    end
    local tab = GetElement(self.m_root,"tabGift_WndVip",WZUITableContainer)

    tab:setVisible(true)

    tab:cleanTable()
    WZLog("WndVip:_createGiftList")
    
    for i = 1, #self.m_tGiftList do
        local rData = self.m_tGiftList[i]
        rData.showType = 1
        local cell,tcell = CellVipPowerList:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(rData)
    end
end

--@brief    创建周礼包列表
function WndVip:_createWeekPackageList()
--    self:setWeekPackageList()
    if not self.m_tWeekPackageList then
        self:createLoadingUI()
        ProtocolProcessorWndVip:send_MALL_GetVipGift()
        return
    end
    local tabWeekBagList = GetElement(self.m_root,"tabWeekBagList_WndVip",WZUITableContainer)

    tabWeekBagList:cleanTable()
    WZLog("WndVip:_createWeekPackageList")
    
    for i = 1, #self.m_tWeekPackageList do
        local rData = self.m_tWeekPackageList[i]
        local cell, tcell = CellVipGiftList:createElement()
        cell:setTag(i - 1)
        tabWeekBagList:setCellElement(cell)
        tcell:setData(rData, 1)
    end
end
-------------------------------------公有方法模块End----------------------------------------


local vipLevelPowerDesc =
{
    LocalStrings.VIP_LEVEL_1,LocalStrings.VIP_LEVEL_2,LocalStrings.VIP_LEVEL_3,LocalStrings.VIP_LEVEL_4,
    LocalStrings.VIP_LEVEL_5,LocalStrings.VIP_LEVEL_6,LocalStrings.VIP_LEVEL_7,LocalStrings.VIP_LEVEL_8,
    LocalStrings.VIP_LEVEL_9,LocalStrings.VIP_LEVEL_10,LocalStrings.VIP_LEVEL_11,LocalStrings.VIP_LEVEL_12,
    LocalStrings.VIP_LEVEL_13,LocalStrings.VIP_LEVEL_14,LocalStrings.VIP_LEVEL_15,
}

-- 查看前一个VIP等级
function WndVip:onPreVipLevel()
    WZLog("-----------------pre---------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.powerDescIndex == 1 then return end
    self.powerDescIndex = self.powerDescIndex - 1
    self:_updateVipLevel()
end

-- 查看下一个VIP等级
function WndVip:onNextVipLevel()
    WZLog("-----------------next---------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local maxLv = self:_getMaxLevel()
    if self.powerDescIndex == maxLv then return end
    self.powerDescIndex = self.powerDescIndex + 1
    self:_updateVipLevel()
end

-- 关闭
function WndVip:onTempClose()
    WZLog("WndVip:onTempClose one")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
    GlobalGame.g_isCanPopPaySucc = false
end

function WndVip:onCloseActionCallback()
	if CellRechargePanelActivity.m_root ~= nil then
		CellRechargePanelActivity:onEnterFinish()
	end
    WindowManager:removeWindow(self.m_root, self, true)
end

-- 网页充值
function WndVip:onWeb()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndVip:onWeb")

    if self:isWebShow() then
        local wndVipWeb = WndVipWeb:createElement()
        if wndVipWeb ~= nil then
            WndVipWeb:setData(self.m_nWebCount)
            WindowManager:addWindow(wndVipWeb,WndVipWeb,nil,false)
        end
    else
        self:onChange()
    end

end

-- 选择充值方式
-- function WndVip:onCountry()
--     SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
--     WZLog("WndVip:onCountry")

--     local country, way = WndVipCountry:getCountry(), WndVipCountry:getWay()
--     country = country == 0 and 1 or country
--     way = way == 0 and 1 or way
--     local wndVipCountry = WndVipCountry:createElement()
--     WndVipCountry:setData(country, way)
--     WindowManager:addWindow(wndVipCountry,WndVipCountry,nil,false)
-- end

-- 选择充值方式
-- function WndVip:setCountryNew(isNew)
--     GetElement(self.m_root, "imgPrivilegeNew_WndVip", WZUIImage):setVisible(isNew)
-- end

-- 按键切换
function WndVip:onChange()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.btnState =  self.btnState == 0 and 1 or 0

    if self:isWebShow() then
        -- btn文字
        local power = "ui/vip/vip_privilege00.png"
        local reward_get = "ui/vip/vip_privilege0.png"

        local str = self.btnState == 0 and power or reward_get
        GetElement(self.m_root, "imgPrivilege1_WndVip", WZUIImage):setFile(str)
        GetElement(self.m_root, "imgPrivilege2_WndVip", WZUIImage):setFile(str)
    else
        -- btn文字
        local str = self.btnState == 0 and LocalStrings.VIP_POWER or LocalStrings.REWARD_BTN_GET
        local txtBtn = GetElement(self.m_root, "txtBtn_WndVip", WZUILabelTTF)
        txtBtn:setText(str)

        if ProjConfig.LANGUAGE == "tr" then
            if txtBtn:getText() == LocalStrings.REWARD_BTN_GET then
                txtBtn:setScale(0.7)
            end
        end
    end

    -- -- 标题
    local path = {"ui/common/common_icon_vipcz.png","ui/common/common_icon_viptq.png"}
    local imgTitle = GetElement(self.m_root, "imgVipTitle_WndVip", WZUIImage)
    imgTitle:setFile(path[self.btnState+1])

    -- 设置显示的容器
    local state = self.btnState == 0 and true or false
    local conList = GetElement(self.m_root,"conRechargeList_WndVip",WZUIContainer)
    local conDesc = GetElement(self.m_root,"conPowerDesc_WndVip",WZUIContainer)
    conList:setVisible(state)
    conDesc:setVisible(not state)
    -- GetElement(self.m_root,"txtSelectPay_WndVip",WZUILabelTTF):setVisible(state)
end

--@brief	更新函数
function WndVip:_update()
    WZLog("WndVip:_update")
    self:closeLoadingUI()
    self:_initUI()
    self:_createRechargeList()
    self:_createPowerDesc()
	self:_createVipReward()
    self:_createGiftList()
    self:_createRebateList()
    self:_createWeekPackageList()
end

-- 初始化UI
function WndVip:_initUI()
    local pInfo = CacheCenter:getPlayerInfo()
    -- VIP 等级
    local txtCurVipLv = GetElement(self.m_root, "txtCurVipLevel_WndVip", WZUILabelAtlasFont)
    txtCurVipLv:setText(pInfo.vipLevel)

    local maxState = pInfo.vipLevel == self:_getMaxLevel()
    local con = GetElement(self.m_root,"conAddVip_WndVip",WZUIContainer)
    con:setVisible(not maxState)
    local con1 = GetElement(self.m_root,"conMaxVip_WndVip",WZUIContainer)
    con1:setVisible(maxState)
    if pInfo.vipLevel == self:_getMaxLevel() then
        local vipData = GDatatab_vip["id_"..pInfo.vipLevel]
        -- 进度条
        local txtPro = GetElement(self.m_root, "proVip_WndVip", WZUIProgress)
        txtPro:setPercentage(100)
        local txtPro = GetElement(self.m_root, "txtPro_WndVip", WZUILabelTTF)
        txtPro:setText(pInfo.vipExp.."/"..vipData.exp)
    else
        --说明
        local nextVipLv = pInfo.vipLevel+1
        local vipData = GDatatab_vip["id_"..nextVipLv]
        local txtMoney = GetElement(self.m_root, "txtMoney_WndVip", WZUIFreeTextBox)
        --txtMoney:setShowText(string.format(LocalStrings.VIP_DESC2,vipData.exp-pInfo.vipExp,pInfo.vipLevel+1))
        txtMoney:setShowText(string.format(LocalStrings.VipRebateDesc2,tostring(vipData.exp-pInfo.vipExp),"VIP"..(pInfo.vipLevel+1)))
		 
        WZLog("-----------8888------------------",LocalStrings.VIP_DESC2)

        -- 进度条
        local txtPro = GetElement(self.m_root, "proVip_WndVip", WZUIProgress)
        txtPro:setPercentage(math.floor(pInfo.vipExp/vipData.exp*100))
        local txtPro = GetElement(self.m_root, "txtPro_WndVip", WZUILabelTTF)
        txtPro:setText(pInfo.vipExp.."/"..vipData.exp)
    end

    -- btn文字
    local str = self.btnState == 0 and LocalStrings.VIP_POWER or LocalStrings.REWARD_BTN_GET
    local txtBtn = GetElement(self.m_root, "txtBtn_WndVip", WZUILabelTTF)
    local btn = GetElement(self.m_root, "btnWeb_WndVip", WZUIButton)
    if self:isWebShow() then
        btn:setVisible(false)
        GetElement(self.m_root, "btnPrivilege_WndVip", WZUIButton):setVisible(true)
        GetElement(self.m_root, "btnWeb2_WndVip", WZUIButton):setVisible(true)
    else
        btn:setVisible(true)
        GetElement(self.m_root, "btnWeb2_WndVip", WZUIButton):setVisible(false)
    end
    txtBtn:setText(str)
    if ProjConfig.LANGUAGE == "tr" then
        if txtBtn:getText() == LocalStrings.REWARD_BTN_GET then
            txtBtn:setScale(0.7)
        end
    end

    if WndVip:isCountry() then
        if self.TabState == 1 then
            GetElement(self.m_root, "btnCountry_WndVip", WZUIButton):setVisible(true)
        else
            GetElement(self.m_root, "btnCountry_WndVip", WZUIButton):setVisible(false)
        end
        local code = WndVipCountry:getWayCode()
        if code == "google" then
            self:setCountryNew(true)
        end
    end

    -- 标题
    local path = {"ui/common/common_icon_vipcz.png","ui/common/common_icon_viptq.png"}
    local imgTitle = GetElement(self.m_root, "imgVipTitle_WndVip", WZUIImage)
    imgTitle:setFile(path[self.btnState+1])

    -- 设置显示的容器
    local state = self.btnState == 0 and true or false
    local conList = GetElement(self.m_root,"conRechargeList_WndVip",WZUIContainer)
    local conDesc = GetElement(self.m_root,"conPowerDesc_WndVip",WZUIContainer)
    conList:setVisible(state)
    conDesc:setVisible(not state)
    -- GetElement(self.m_root,"txtSelectPay_WndVip",WZUILabelTTF):setVisible(state)

    -- 显示VIP等级的容器调整
    local txtVipLv = GetElement(self.m_root,"txtCurVipLevel_WndVip")
    if pInfo.vipLevel >= 10 then
        --txtVipLv:setRelativePosition(GlobalMethod:ccp(0.0927614,0.377713))
    else
        --txtVipLv:setRelativePosition(GlobalMethod:ccp(0.0971732,0.377713))
    end

    --许愿池buffer
    self.m_conPromiseBuffer = GetElement(self.m_root,"conPromiseBuffer",WZUIContainer)
    if WndPromiseShrine:isEnabledRechargeBuffer() then
        if ProjConfig.LANGUAGE == "cn" then
            self.m_conPromiseBuffer:setVisible(true)
        end
    else
        self.m_conPromiseBuffer:setVisible(false)
    end
    
end

-- 创建充值列表
function WndVip:_createRechargeList()
    self.rechargeData = CopyTable(CacheCenter:getVipList())
    if not self.rechargeData then
        self:createLoadingUI()
        return
    end
    local tab = GetElement(self.m_root,"tabRecharge_WndVip",WZUITableContainer)
    local txt = GetElement(self.m_root,"txtColseVip_WndVip",WZUILabelTTF)
--    if ProjConfig.CHANNEL_ID == 9 then
--        tab:setVisible(false)
--        txt:setVisible(true)
--    else
--        tab:setVisible(true)
--        txt:setVisible(false)
--    end

    tab:setVisible(true)
    txt:setVisible(false)

    tab:cleanTable()
    WZLog("--------------------update recharge list-------------------", Serialize(self.rechargeData), #self.rechargeData)

    --是否显示折扣的月卡
    local bDiscountMonthCard = false  
    local nCurTime = SystemTime:getServerTime()
    if self.m_nCardActivityState and self.m_nCardActivityState == 0 and self.m_nBuyCardTimes <= 0 and nCurTime < self.m_nCardActivityEndTime then
        bDiscountMonthCard = true
    end
    -- 永久福利卡买过不显示
    local tTempData = CopyTable(self.rechargeData)
    for i = 1, #tTempData do
        local rData = tTempData[i]
        local bRemove = false 
        if rData.itemId == 52 and self:judgeJYFLK() then
            bRemove = true 
        end
        -- 永久至尊卡买过不显示
        if rData.itemId == 56 and self:judgeYJZZ() then
            bRemove = true 
        end
        -- 娄艺潇礼包买过不显示
        if rData.itemId == 1283 or rData.itemId == 1257 then
            bRemove = true 
        end
            
        if bRemove then 
            for j = 1, #self.rechargeData do
                if self.rechargeData[j].itemId == rData.itemId then 
                    table.remove(self.rechargeData, j)
                    break 
                end
            end
        end
    end
    --如果月卡打折活动存在，移除掉没打折的月卡
    local nTempDiscountType = tonumber(CacheCenter:getGameParam().monthCardDiscountRechargeType)
    WZLog("WndVip:_createRechargeList", bDiscountMonthCard, type(self.m_nCardActivityState), type(self.m_nBuyCardTimes), type(self.m_nCardActivityEndTime))
    if bDiscountMonthCard then 
        for j = 1, #self.rechargeData do
            if self.rechargeData[j].itemId == 50 then 
                local tRechargeData = GDatatab_recharge["id_" .. self.rechargeData[j].ids]
                if tRechargeData.type ~= nTempDiscountType then  
                    table.remove(self.rechargeData, j)
                    break 
                end
            end
        end
    else
        for j = 1, #self.rechargeData do
            if self.rechargeData[j].itemId == 50 then 
                local tRechargeData = GDatatab_recharge["id_" .. self.rechargeData[j].ids]
                if tRechargeData.type == nTempDiscountType then  
                    table.remove(self.rechargeData, j)
                    break 
                end
            end
        end
    end

    for j = 1, #self.rechargeData do
        if self.rechargeData[j].itemId == 50 then 
            local tRechargeData = GDatatab_recharge["id_" .. self.rechargeData[j].ids]
            if tRechargeData.type == 105 then  
                table.remove(self.rechargeData, j)
                break 
            end
        end
    end

    
    for i = 1, #self.rechargeData do
        local rData = self.rechargeData[i]
        rData.showType = 0
        local cell,tcell = CellVipPowerList:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(rData)
    end
end

-- 创建VIP特权说明
function WndVip:_createPowerDesc()
    local txtVipLv = GetElement(self.m_root, "txtCheckVipLevel_WndVip", WZUILabelTTF)
    txtVipLv:setText(self.powerDescIndex)

    local ftb = GetElement(self.m_root,"ftbPowerDesc_WndVip",WZUIFreeTextBox)
    local scl = GetElement(self.m_root,"scrollPowerDesc_WndVip",WZUIScrollContainer)
    ftb:setShowText(vipLevelPowerDesc[self.powerDescIndex])

    local ftbSize = ftb:getContentSize()
    local SclSize = scl:getContentSize()
    ftb:setPositionY(ftbSize.height)

    --更改滚动容器Element的大小
    local con = scl:getMoveElement()
    local size = con:getRelativeSize()
    con:setRelativeSize( GlobalMethod:CCSize(1 , ftbSize.height/SclSize.height + 0.015))
    scl:UpdateInsidePosition()  --更新滚动容器内部布局
    con:setPositionY(scl:getMinPosition().y)
end

--@brief	更新vip奖励
function WndVip:_createVipReward()
	if self.m_tDataList == nil or #self.m_tDataList == 0 then return end
	local id = {}
	local num = {}
	local id2 = {}
	local num2 = {}
	for i=1,#self.m_tDataList do
		if self.m_tDataList[i].vipLevel == self.powerDescIndex then
            WZLog("WndVip:_createVipReward one", i, self.m_tDataList[i].gift, "limitGood:", self.m_tDataList[i].limitGood)
			id, num = SplitItemString(self.m_tDataList[i].gift)
			id2, num2 = SplitItemString(self.m_tDataList[i].limitGood)
		end
	end
	for i=1,4 do
        --WZLog("WndVip:_createVipReward two", Serialize(id), Serialize(num))
		if id[i] ~= nil then
        local key = "id_"..id[i]
		local tData = GDatatab_item[key]
        local name = tData.name
        local icon = tData.icon
        local num =  num[i]
        local quality = tData.quality
        local itemInfo = {name=name,icon=icon,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(tData)}

		local con = GetElement(self.m_root,"conLeft"..i,WZUIContainer)
		con:removeAllChildrenWithCleanup(true)
		local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement ~= nil then 
		   	celElement = WZUIContainer:luaTo(celElement)
            tLuaObj:setCellGoodItem(itemInfo, 16)
            tLuaObj:setItemClickFun(self, self.onClickItem)
			celElement:setScale(0.9)
			con:addChild(celElement)
        end
		end

		if id2[i] ~= nil then
        local key = "id_"..id2[i]
		local tData = GDatatab_item[key]
        local name = tData.name
        local icon = tData.icon
        local num =  num2[i]
        local quality = tData.quality
        local itemInfo = {name=name,icon=icon,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(tData)}
		local conRight = GetElement(self.m_root,"conRight"..i,WZUIContainer)
		conRight:removeAllChildrenWithCleanup(true)

		local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement ~= nil then 
		   	celElement = WZUIContainer:luaTo(celElement)
            tLuaObj:setCellGoodItem(itemInfo, 16)
            tLuaObj:setItemClickFun(self, self.onClickItem)
			celElement:setScale(0.9)
			conRight:addChild(celElement)
        end
		end
	end
end

function WndVip:onClickItem(tItem, nTag, tData)
	if self.m_root == nil then return end
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

-- 更新VIP等级
function WndVip:_updateVipLevel()
    self:_createPowerDesc()
	self:_createVipReward()
end

function WndVip:createLoadingUI()
    if not self.loadingId then self.loadingId = MsgBoxManager:showLoadingBox(20,self,self.closeLoadingUI) end
end

function WndVip:closeLoadingUI()
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
end

------------------------------------语言适配Begin-----------------------------------------
function WndVip:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtCheckVipLevel_WndVip",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.477841,0.5))
    local txtRightGift1 = GetElement(self.m_root,"txtRightGift1_WndVip",WZUILabelTTF)
    txtRightGift1:setRelativePosition(GlobalMethod:ccp(0.24,0.78))
    local txtRightGift2 = GetElement(self.m_root,"txtRightGift2_WndVip",WZUILabelTTF)
    txtRightGift2:setRelativePosition(GlobalMethod:ccp(0.72,0.78))

    local txt4 = GetElement(self.m_root,"txt4_TempLeftTab",WZUILabelTTF)
    txt4:setScale(0.8)
    txt4:setDimensions(GlobalMethod:CCSize(110,0))
    local txt4Sel = GetElement(self.m_root,"txt4Sel_TempLeftTab",WZUILabelTTF)
    txt4Sel:setScale(0.8)
    txt4Sel:setDimensions(GlobalMethod:CCSize(110,0))
end

function WndVip:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtCheckVipLevel_WndVip",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.471094,0.5))
    GetElement(self.m_root,"txtCheckVip_WndVip",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.57,0.5))
    local txt1 = GetElement(self.m_root,"txt1_TempLeftTab",WZUILabelTTF)
    txt1:setScale(0.75)
    txt1:setRelativePosition(GlobalMethod:ccp(0.43,0.5))
    local txt1Sel = GetElement(self.m_root,"txt1Sel_TempLeftTab",WZUILabelTTF)
    txt1Sel:setScale(0.75)
    txt1Sel:setRelativePosition(GlobalMethod:ccp(0.43,0.5))
    GetElement(self.m_root,"txt3_TempLeftTab",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txt3Sel_TempLeftTab",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtRightGift1_WndVip",WZUILabelTTF):setScale(0.8)
    local txtRightGift2 = GetElement(self.m_root,"txtRightGift2_WndVip",WZUILabelTTF)
    txtRightGift2:setScale(0.8)
    txtRightGift2:setRelativePosition(GlobalMethod:ccp(0.62,0.78))

    local txt4 = GetElement(self.m_root,"txt4_TempLeftTab",WZUILabelTTF)
    txt4:setScale(0.8)
    txt4:setDimensions(GlobalMethod:CCSize(110,0))
    local txt4Sel = GetElement(self.m_root,"txt4Sel_TempLeftTab",WZUILabelTTF)
    txt4Sel:setScale(0.8)
    txt4Sel:setDimensions(GlobalMethod:CCSize(110,0))
end

function WndVip:_adaptLanguage_vn( )
    GetElement(self.m_root,"txtCheckVip_WndVip",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.56,0.5))
    local txt1 = GetElement(self.m_root,"txt1_TempLeftTab",WZUILabelTTF)
    txt1:setScale(0.7)
    txt1:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    local txt1Sel = GetElement(self.m_root,"txt1Sel_TempLeftTab",WZUILabelTTF)
    txt1Sel:setScale(0.7)
    txt1Sel:setRelativePosition(GlobalMethod:ccp(0.45,0.5))

    local txt4 = GetElement(self.m_root,"txt4_TempLeftTab",WZUILabelTTF)
    txt4:setScale(0.7)
    txt4:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    local txt4Sel = GetElement(self.m_root,"txt4Sel_TempLeftTab",WZUILabelTTF)
    txt4Sel:setScale(0.7)
    txt4Sel:setRelativePosition(GlobalMethod:ccp(0.45,0.5))

    local txtRightGift2 = GetElement(self.m_root,"txtRightGift2_WndVip",WZUILabelTTF)
    txtRightGift2:setRelativePosition(GlobalMethod:ccp(0.62,0.78))
end

function WndVip:_adaptLanguage_pt( )
    local txtMoney = GetElement(self.m_root,"txtMoney_WndVip",WZUIFreeTextBox)
    txtMoney:setMaxWidth(500)
    txtMoney:setScale(0.85)
    txtMoney:setRelativePosition(GlobalMethod:ccp(0.5,0.2))

    local txtBtn = GetElement(self.m_root,"txtBtn_WndVip",WZUILabelTTF)
    txtBtn:setScale(0.8)

    GetElement(self.m_root,"txtCheckVipLevel_WndVip",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.473,0.5))
    GetElement(self.m_root,"txtCheckVip_WndVip",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.57,0.5))

    local txt1 = GetElement(self.m_root,"txt1_TempLeftTab",WZUILabelTTF)
    txt1:setScale(0.7)
    txt1:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    local txt1Sel = GetElement(self.m_root,"txt1Sel_TempLeftTab",WZUILabelTTF)
    txt1Sel:setScale(0.7)
    txt1Sel:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    local txt2 = GetElement(self.m_root,"txt2_TempLeftTab",WZUILabelTTF)
    txt2:setScale(0.7)
    txt2:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    local txt2Sel = GetElement(self.m_root,"txt2Sel_TempLeftTab",WZUILabelTTF)
    txt2Sel:setScale(0.7)
    txt2Sel:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    local txt3 = GetElement(self.m_root,"txt3_TempLeftTab",WZUILabelTTF)
    txt3:setScale(0.7)
    txt3:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    local txt3Sel = GetElement(self.m_root,"txt3Sel_TempLeftTab",WZUILabelTTF)
    txt3Sel:setScale(0.7)
    txt3Sel:setRelativePosition(GlobalMethod:ccp(0.45,0.5))

    local txtLeftGift1 = GetElement(self.m_root,"txtLeftGift1_WndVip",WZUILabelTTF)
    txtLeftGift1:setScale(0.8)
    local txtLeftGift2 = GetElement(self.m_root,"txtLeftGift2_WndVip",WZUILabelTTF)
    txtLeftGift2:setScale(0.8)
    local txtRightGift1 = GetElement(self.m_root,"txtRightGift1_WndVip",WZUILabelTTF)
    txtRightGift1:setScale(0.8)
    txtRightGift1:setRelativePosition(GlobalMethod:ccp(0.24,0.78))
    local txtRightGift2 = GetElement(self.m_root,"txtRightGift2_WndVip",WZUILabelTTF)
    txtRightGift2:setRelativePosition(GlobalMethod:ccp(0.68,0.78))
    txtRightGift2:setScale(0.8)

    GetElement(self.m_root,"imgPrivilegeNew_WndVip",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.848809,0.842858))

    local txt4 = GetElement(self.m_root,"txt4_TempLeftTab",WZUILabelTTF)
    txt4:setScale(0.7)
    txt4:setDimensions(GlobalMethod:CCSize(110,0))
    local txt4Sel = GetElement(self.m_root,"txt4Sel_TempLeftTab",WZUILabelTTF)
    txt4Sel:setScale(0.7)
    txt4Sel:setDimensions(GlobalMethod:CCSize(110,0))
end

function WndVip:_adaptLanguage_es( )
    local txtMoney = GetElement(self.m_root,"txtMoney_WndVip",WZUIFreeTextBox)
    txtMoney:setMaxWidth(500)
    txtMoney:setScale(0.85)
    txtMoney:setRelativePosition(GlobalMethod:ccp(0.5,0.2))

    GetElement(self.m_root,"txtCheckVipLevel_WndVip",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.473,0.5))
    GetElement(self.m_root,"txtCheckVip_WndVip",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.57,0.5))

    local txt1 = GetElement(self.m_root,"txt1_TempLeftTab",WZUILabelTTF)
    txt1:setScale(0.65)
    txt1:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    local txt1Sel = GetElement(self.m_root,"txt1Sel_TempLeftTab",WZUILabelTTF)
    txt1Sel:setScale(0.65)
    txt1Sel:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    local txt2 = GetElement(self.m_root,"txt2_TempLeftTab",WZUILabelTTF)
    txt2:setScale(0.7)
    txt2:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    local txt2Sel = GetElement(self.m_root,"txt2Sel_TempLeftTab",WZUILabelTTF)
    txt2Sel:setScale(0.7)
    txt2Sel:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    local txt3 = GetElement(self.m_root,"txt3_TempLeftTab",WZUILabelTTF)
    txt3:setScale(0.7)
    txt3:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    local txt3Sel = GetElement(self.m_root,"txt3Sel_TempLeftTab",WZUILabelTTF)
    txt3Sel:setScale(0.7)
    txt3Sel:setRelativePosition(GlobalMethod:ccp(0.45,0.5))

    local txtLeftGift1 = GetElement(self.m_root,"txtLeftGift1_WndVip",WZUILabelTTF)
    txtLeftGift1:setScale(0.8)
    local txtLeftGift2 = GetElement(self.m_root,"txtLeftGift2_WndVip",WZUILabelTTF)
    txtLeftGift2:setScale(0.8)
    txtLeftGift2:setRelativePosition(GlobalMethod:ccp(0.55,0.78))

    local txtRightGift1 = GetElement(self.m_root,"txtRightGift1_WndVip",WZUILabelTTF)
    txtRightGift1:setScale(0.7)
    --txtRightGift1:setRelativePosition(GlobalMethod:ccp(0.15,0.78))
    local txtRightGift2 = GetElement(self.m_root,"txtRightGift2_WndVip",WZUILabelTTF)
    txtRightGift2:setRelativePosition(GlobalMethod:ccp(0.64,0.78))
    txtRightGift2:setScale(0.7)

    local txt4 = GetElement(self.m_root,"txt4_TempLeftTab",WZUILabelTTF)
    txt4:setScale(0.7)
    txt4:setDimensions(GlobalMethod:CCSize(110,0))
    local txt4Sel = GetElement(self.m_root,"txt4Sel_TempLeftTab",WZUILabelTTF)
    txt4Sel:setScale(0.7)
    txt4Sel:setDimensions(GlobalMethod:CCSize(110,0))
end

function WndVip:_adaptLanguage_tr(  )
    local txtMoney = GetElement(self.m_root,"txtMoney_WndVip",WZUIFreeTextBox)
    txtMoney:setMaxWidth(500)
    txtMoney:setScale(0.85)

    GetElement(self.m_root,"txtCheckVipLevel_WndVip",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.472443,0.5))
    GetElement(self.m_root,"txtCheckVip_WndVip",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.56343,0.5))

    local txtRightGift1 = GetElement(self.m_root,"txtRightGift1_WndVip",WZUILabelTTF)
    txtRightGift1:setScale(0.7)
    txtRightGift1:setRelativePosition(GlobalMethod:ccp(0.2,0.78))
   
    local txtRightGift2 = GetElement(self.m_root,"txtRightGift2_WndVip",WZUILabelTTF)
    txtRightGift2:setRelativePosition(GlobalMethod:ccp(0.64,0.78))
    txtRightGift2:setScale(0.7)

    local txt2 = GetElement(self.m_root,"txt2_TempLeftTab",WZUILabelTTF)
    txt2:setScale(0.7)
    txt2:setDimensions(GlobalMethod:CCSize(100,0))
    local txt2Sel = GetElement(self.m_root,"txt2Sel_TempLeftTab",WZUILabelTTF)
    txt2Sel:setScale(0.7)
    txt2Sel:setDimensions(GlobalMethod:CCSize(100,0))

    local txt3 = GetElement(self.m_root,"txt3_TempLeftTab",WZUILabelTTF)
    txt3:setScale(0.7)
    txt3:setDimensions(GlobalMethod:CCSize(100,0))
    local txt3Sel = GetElement(self.m_root,"txt3Sel_TempLeftTab",WZUILabelTTF)
    txt3Sel:setScale(0.7)
    txt3Sel:setDimensions(GlobalMethod:CCSize(100,0))

    local txt4 = GetElement(self.m_root,"txt4_TempLeftTab",WZUILabelTTF)
    txt4:setScale(0.5)
    txt4:setDimensions(GlobalMethod:CCSize(150,0))
    local txt4Sel = GetElement(self.m_root,"txt4Sel_TempLeftTab",WZUILabelTTF)
    txt4Sel:setScale(0.5)
    txt4Sel:setDimensions(GlobalMethod:CCSize(150,0))
end

--------------------------------------语言适配End-----------------------------------------