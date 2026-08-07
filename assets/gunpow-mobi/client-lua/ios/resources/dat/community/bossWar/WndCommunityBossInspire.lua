--WndCommunityBossInspire.lua
--@brief	WndCommunityBossInspire的UI模块
--@date		2017-01-19
--@note		公会boss活动结束界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityBossInspire:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    CacheCenter:getGameParam()
    self.isUseTicket = CacheCenter:getGameParam().isUseTicket
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityBossInspire:onExit(element)
	self:_unInit()
end

--@brief   关闭窗口
function WndCommunityBossInspire:OnCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_root then
        WindowManager:removeWindow(self.m_root , self , true)
    end
end


-- 对外接口
function WndCommunityBossInspire:showWnd(curHurtPre,copyId)
    local wndCommunityBossInspire = WndCommunityBossInspire:createElement()
    WindowManager:addWindow( wndCommunityBossInspire , WndCommunityBossInspire )
    self.m_nCopyId = copyId
    self:update(curHurtPre)
end

--@brief    点击确定充值回调
function WndCommunityBossInspire:clickSureMoney()
    PassportSdkManager:gotoPaymentPage()
end

--@brief 单次鼓舞
function WndCommunityBossInspire:OnInspireClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
     if self.m_nLeftInspire <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.GUILD_BOSS_INSPIRE_FULL)
        self:OnCloseClick()
        return
    end

    self.m_nInspireNum = 1
    if self.isUseTicket == "0" then
        if not JudgeMoneyIsEnough(70, self.m_nAddOncePrice, nil, nil, Chat_Channel_Guild_Boss, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
            return
        end
    else
        if not JudgeMoneyIsEnough(1, self.m_nAddOncePrice, nil, nil, Chat_Channel_Guild_Boss, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
            return
        end
    end

    self:sureUseDiamondInstead()
end

--@brief    确认用钻石代替礼券回调
function WndCommunityBossInspire:sureUseDiamondInstead()
    -- body
    WZLog("WndCommunityBossInspire:sureUseDiamondInstead", self.m_nInspireNum,self.m_nCopyId)

    self:createLoading()
    self.m_bInspireClick = true
    ProtocolProcessorCommunityBossRoom:send_GUILD_GuildInspire(self.m_nInspireNum,self.m_nCopyId)
end

--@brief 多次鼓舞
function WndCommunityBossInspire:OnInspireNumClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nLeftInspire <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.GUILD_BOSS_INSPIRE_FULL)
        self:OnCloseClick()
        return
    end
    self.m_nInspireNum = self.m_nLeftInspire < 10 and self.m_nLeftInspire or 10
    if self.isUseTicket == "0" then
        if not JudgeMoneyIsEnough(70, self.m_nAddOncePrice * self.m_nInspireNum, nil, nil, Chat_Channel_Guild_Boss, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
            return
        end
    else
        if not JudgeMoneyIsEnough(1, self.m_nAddOncePrice * self.m_nInspireNum, nil, nil, Chat_Channel_Guild_Boss, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
            return
        end
    end
    self:sureUseDiamondInstead()
end

function WndCommunityBossInspire:update(curHurtPre)
    if not self.m_root then
        return
    end
    self:closeLoading()
    
    if self.m_bInspireClick then
        MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_ADD_SUCCESS)
        self.m_bInspireClick = nil
    end

    GetElement(self.m_root, "labCurHurtPre_WndCommunityBossInspire",WZUILabelTTF):setText(string.format(LocalStrings.GUILD_BOSS_INSPIRE_ADD,curHurtPre))
   
    local addOnceHurt = tonumber(CacheCenter:getGameParam().guildBossInspireAdd)
    local addOncePrice = tonumber(CacheCenter:getGameParam().guildBossInspirePrice)
    self.m_nAddOncePrice = addOncePrice

    local inspireNum = 10
    self.m_nLeftInspire = (tonumber(CacheCenter:getGameParam().guildBossMaxHurtAdd) - curHurtPre)/addOnceHurt
    if self.m_nLeftInspire < 10 then
        inspireNum = self.m_nLeftInspire
    end

    local m_tIds,m_tNums = SplitItemString(CacheCenter:getGameParam().guildBossInspireRebate)
    local getOnce = m_tNums[1]
    --按钮
    GetElement(self.m_root, "labBtnInspireNum_WndCommunityBossInspire",WZUILabelTTF):setText(string.format(LocalStrings.GUILD_BOSS_INSPIRE_NUM,inspireNum))
    
    GetElement(self.m_root, "labHurtOne_WndCommunityBossInspire",WZUILabelTTF):setText(string.format(LocalStrings.GUILD_BOSS_INSPIRE_ADD,addOnceHurt))
    GetElement(self.m_root, "labHurtNum_WndCommunityBossInspire",WZUILabelTTF):setText(string.format(LocalStrings.GUILD_BOSS_INSPIRE_ADD,addOnceHurt * inspireNum))

    GetElement(self.m_root, "labGet_WndCommunityBossInspire",WZUILabelTTF):setText(getOnce)
    GetElement(self.m_root, "labGetNum_WndCommunityBossInspire",WZUILabelTTF):setText(getOnce * inspireNum)

    GetElement(self.m_root, "labCost_WndCommunityBossInspire",WZUILabelTTF):setText(addOncePrice)
    GetElement(self.m_root, "labCostNum_WndCommunityBossInspire",WZUILabelTTF):setText(addOncePrice * inspireNum)
    local imgCostIcon1 = GetElement(self.m_root, "imgCostIcon1_WndCommunityBossEnd", WZUIImage)
    imgCostIcon1:setScale(0.6)

    local imgCostIcon2 = GetElement(self.m_root, "imgCostIcon2_WndCommunityBossEnd", WZUIImage)  
    imgCostIcon2:setScale(0.6)

    if CacheCenter:getGameParam().isUseTicket == "0" then
        imgCostIcon1:setFile(GDatatab_item["id_70"].icon)
        imgCostIcon2:setFile(GDatatab_item["id_70"].icon)
    else
        imgCostIcon1:setFile(GDatatab_item["id_1"].icon)
        imgCostIcon2:setFile(GDatatab_item["id_1"].icon)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-------------------------------------------
function WndCommunityBossInspire:_adaptLanguage_en(  )
    local labBtnInsprit = GetElement(self.m_root,"labBtnInspireNum_WndCommunityBossInspire",WZUILabelTTF)
    labBtnInsprit:setDimensions(GlobalMethod:CCSize(130,0))
    labBtnInsprit:setFontSize(20)
end

function WndCommunityBossInspire:_adaptLanguage_vn(  )
    local labBtnInspireNum = GetElement(self.m_root,"labBtnInspireNum_WndCommunityBossInspire",WZUILabelTTF)
    labBtnInspireNum:setFontSize(24)
    local txtNotice = GetElement(self.m_root,"txtNotice_WndCommunityBossEnd",WZUILabelTTF)
    txtNotice:setScale(0.8)
end

function WndCommunityBossInspire:_adaptLanguage_pt(  )
    GetElement(self.m_root, "txtGet_WndCommunityBossInspire", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.179537,0.534468))
    GetElement(self.m_root, "txtGetNum_WndCommunityBossInspire", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.631547,0.534468))
    GetElement(self.m_root, "labGet_WndCommunityBossInspire", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.367537,0.531064))
    GetElement(self.m_root, "labGetNum_WndCommunityBossInspire", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.827537,0.531064))
    
    GetElement(self.m_root,"txtNotice_WndCommunityBossEnd",WZUILabelTTF):setScale(0.8)

    local labBtnInspireNum = GetElement(self.m_root,"labBtnInspireNum_WndCommunityBossInspire",WZUILabelTTF)
    labBtnInspireNum:setScale(0.7)
    labBtnInspireNum:setDimensions(GlobalMethod:CCSize(150))
end

function WndCommunityBossInspire:_adaptLanguage_es(  )
    GetElement(self.m_root, "txtGet_WndCommunityBossInspire", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.16,0.534468))
    GetElement(self.m_root, "txtGetNum_WndCommunityBossInspire", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.62,0.534468))
    GetElement(self.m_root, "txtGetDia_WndCommunityBossEnd", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.17,0.431064))
    GetElement(self.m_root, "txtGetDiaN_WndCommunityBossEnd", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.62,0.431064))
    local txtNotice = GetElement(self.m_root,"txtNotice_WndCommunityBossEnd",WZUILabelTTF)
    txtNotice:setScale(0.75)

    local labBtnInspireNum = GetElement(self.m_root,"labBtnInspireNum_WndCommunityBossInspire",WZUILabelTTF)
    labBtnInspireNum:setScale(0.77)
    labBtnInspireNum:setDimensions(GlobalMethod:CCSize(150,0))
end

function WndCommunityBossInspire:_adaptLanguage_tr(  )
    local labBtnInspireNum = GetElement(self.m_root,"labBtnInspireNum_WndCommunityBossInspire",WZUILabelTTF)
    labBtnInspireNum:setFontSize(22)
end
-------------------------------------语言适配End---------------------------------------------