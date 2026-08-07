--CellEightyEightRecharge.lua
--@brief	CellEightyEightRecharge的UI模块
--@date		2015/11/09
--@author	Tianxiang_Xu
--@note		活动-限时首充


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellEightyEightRecharge:onEnter(element)
	self.m_root = element

    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellEightyEightRecharge:onExit(element)
	self:_unInit()
end

function CellEightyEightRecharge:showWindow()
    self:_initStaticText()
    self:_updateUI()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新静态文本
function CellEightyEightRecharge:_initStaticText()
    GetElement(self.m_root, "txtActivityWord_CellEightyEightRecharge", WZUILabelTTF):setText(LocalStrings.ACTIVE_TIME .. ":")
    --活动时间
    local txtLastDay = GetElement(self.m_root, "txtLastDay_CellEightyEightRecharge", WZUILabelTTF)
    local DayStartTab = os.date("*t",self.startTime)
    local DayEndTab = os.date("*t",self.endTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    txtLastDay:setText(needDay_str)
end

--@brief    更新ui
function CellEightyEightRecharge:_updateUI()
    local content = json.decode(self.content)

    local rewardItems = string.sub(content.rewardItems,2,-2)
    local tReward = SplitStringWithSeparator(rewardItems, ",")
    local conItem = GetElement(self.m_root,"conItem_CellEightyEightRecharge",WZUIContainer)
    local celElement, tLuaObj = CellGoodItem:createElement()
    if celElement and tLuaObj then
        tLuaObj:setCellGoodLocalId(tReward[1], 0, 15)
        tLuaObj:setItemClickFun(self, self.onOthersClick)
        conItem:addChild(celElement)
        celElement:setScale(1.2)
    end

    local imgBK = GetElement(self.m_root, "imgBK_CellEightyEightRecharge", WZUIImage)
    if imgBK then 
        if content.uiUrl then 
            local bIsExist = WZDataFile:getInstance():checkFileExist(content.uiUrl)
            if bIsExist then 
                imgBK:setFile(content.uiUrl)
            end
        end
    end

    local txtRewardNum = GetElement(self.m_root,"txtRewardNum_CellEightyEightRecharge",WZUILabelTTF)
    txtRewardNum:setText(tReward[2])

    local txtRewardAtt = GetElement(self.m_root,"txtRewardAtt_CellEightyEightRecharge",WZUILabelTTF)
    txtRewardAtt:setText(LocalStrings.RECHARGED_TEXT..":"..math.min(content.rechargeBlue,content.condition).."/"..content.condition)

    local btnRecharge = GetElement(self.m_root,"btnRecharge_CellEightyEightRecharge",WZUIButton)
    local btnGet = GetElement(self.m_root,"btnGet_CellEightyEightRecharge",WZUIButton)
    if content.status == -1 then --前往充值
        btnRecharge:setVisible(true)
        btnGet:setVisible(false)
    elseif content.status == 0 then --可领取
        btnRecharge:setVisible(false)
        btnGet:setVisible(true)
        btnGet:setTouchEnable(true)
    elseif content.status == 1 then --已领取
        btnRecharge:setVisible(false)
        btnGet:setVisible(true)
        btnGet:setTouchEnable(false)
    end
end

--@brief    点击前往充值按钮
function CellEightyEightRecharge:onClickRecharge(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    PassportSdkManager:gotoPaymentPage()
    WndActivityIntegrate:closeActivity()
end

--@brief    点击领取按钮
function CellEightyEightRecharge:onClickGet(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --领取奖励
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    CellEightyEightRecharge.m_current_click = self
    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.activityId, 0 )
end

--@brief    点击奖励图标
function CellEightyEightRecharge:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief    获取奖励成功后的界面处理
function CellEightyEightRecharge:_GetRewardOk()
    -- body
    if self.m_root == nil then return end 
    
    local content = json.decode(self.content)
    
    local txtRewardAtt = GetElement(self.m_root,"txtRewardAtt_CellEightyEightRecharge",WZUILabelTTF)
    txtRewardAtt:setText(LocalStrings.RECHARGED_TEXT..":"..content.condition.."/"..content.condition)

    local btnRecharge = GetElement(self.m_root,"btnRecharge_CellEightyEightRecharge",WZUIButton)
    local btnGet = GetElement(self.m_root,"btnGet_CellEightyEightRecharge",WZUIButton)
    btnRecharge:setVisible(false)
    btnGet:setVisible(true)
    btnGet:setTouchEnable(false)

end

--@brief    点击说明按你
function CellEightyEightRecharge:onClickRule(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface1(LocalStrings.ACTIVITY_EIGHTY_EIGHT_TEXT1) 
end

-------------------------------------私有方法模块End----------------------------------------


--------------------------------语言适配Begin------------------------------------

function CellEightyEightRecharge:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtLastDay_CellEightyEightRecharge",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.26,0.45))
end

----------------------------------语言适配End-------------------------------------
