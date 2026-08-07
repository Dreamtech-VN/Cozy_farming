--WndBuyFiveAttention.lua
--@brief	WndBuyFiveAttention的UI模块
--@date		2015/08/24
--@author	Tianxiang_Xu
--@note		购买五次金币提示


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBuyFiveAttention:onEnter(element)
	self.m_root = element

    ChangeChatChannel(Chat_Channel_Gold_Tree_Resert)
    self:_initStaticText()
    --语言适配函数
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBuyFiveAttention:onExit(element)
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function WndBuyFiveAttention:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, false, nil, nil)

end

function WndBuyFiveAttention:onCheckBox(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)   
end

--brief     点击确认购买
function WndBuyFiveAttention:onClickConfirm()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nShakeTimes, nCostValue, nGainValue, nCostId = WndBuyActivity:returnAttData()
    local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
    if not JudgeMoneyIsEnough(nCostId, nCostValue, nil, nil, Chat_Channel_Gold_Tree_Resert, WndBuyFiveAttention, WndBuyFiveAttention.needMoreDiamondCallBack, tCustomUIConfig, nil, WndBuyFiveAttention, WndBuyFiveAttention.confirmBuy) then 
        return 
    end

    WndBuyFiveAttention:confirmBuy()
end

--@brief    购买n次
function WndBuyFiveAttention:confirmBuy()
    -- body
    local checkBoxIndex = GetElement(self.m_root, "checkBox_WndBuyFiveAttention", WZUICheckBox):getCheckIndex() 
    local bVisible = GetElement(self.m_root, "conForAtt_WndBuyFiveAttention", WZUIContainer):isVisible()
    if bVisible and checkBoxIndex == 1 then 
        self:addAttToList()
    end
    self.m_tCallBack[2](self.m_tCallBack[1])

    self:onCloseActionCallback()
end

--@brief    点击取消，关闭提示窗口
function WndBuyFiveAttention:onClickCancel()
    -- body
    if self.m_root == nil then
        return
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self:onCloseActionCallback()
end

--@brief    关闭整个窗口的动画效果
function WndBuyFiveAttention:onCloseActionCallback()
    if self.m_root then 
        WindowManager:removeWindow(self.m_root , self , true)
    end
end

--@brief    提示充值框的回调
--@param    nId:消息id
--@param    nResType:响应类型(超时，确定，取消)
function WndBuyFiveAttention:needMoreDiamondCallBack(nId, nResType)
    WindowManagerAni:createCloseAction2(self.m_root, "onCloseActionCallback", self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置窗口中各控件的文字
function WndBuyFiveAttention:_initStaticText()
    -- body
    local imgGaainIcon = GetElement(self.m_root, "imgGaainIcon_WndBuyFiveAttention", WZUIImage)
    GetElement(self.m_root, "txtTitle_WndBuyFiveAttention", WZUILabelTTF):setText(LocalStrings.BUY_FIVE_AFFIRM)
    GetElement(self.m_root, "txtCostWord_WndBuyFiveAttention", WZUILabelTTF):setText(LocalStrings.BUY_FIVE_NEED_CONSUME)
    GetElement(self.m_root, "txtGetWord_WndBuyFiveAttention", WZUILabelTTF):setText(LocalStrings.BUY_FIVE_CAN_GET)
    GetElement(self.m_root, "txtCancel_WndBuyFiveAttention", WZUILabelTTF):setText(LocalStrings.CANCEL)
    GetElement(self.m_root, "txtConfirm_WndBuyFiveAttention", WZUILabelTTF):setText(LocalStrings.CONFIRM)

    self.m_nShakeTimes, self.m_nCostValue, self.m_nGainValue, self.m_nCostId = WndBuyActivity:returnAttData()
    local sFormat = LocalStrings.BUY_FIVE_ATTENTION
    if WndBuyActivity.m_tBaseData.nType == 13 then
        sFormat = LocalStrings.BUY_FIVEGEM_ATTENTION
        imgGaainIcon:setFile("ui/common/common_icon_kuangjing.png")
        GetElement(self.m_root, "txtGetWord_WndBuyFiveAttention", WZUILabelTTF):setText(LocalStrings.MOUNT_CAN_LOCK)
        GetElement(self.m_root, "conForAtt_WndBuyFiveAttention", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conInfo_WndBuyFiveAttention", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.6))
    elseif WndBuyActivity.m_tBaseData.nType == 15 then
        sFormat = LocalStrings.BUY_FIVETOUZI_ATTENTION
        imgGaainIcon:setFile("ui/taboo/login_icon_shaizi2.png")
        GetElement(self.m_root, "txtGetWord_WndBuyFiveAttention", WZUILabelTTF):setText(LocalStrings.MOUNT_CAN_LOCK)
    elseif WndBuyActivity.m_tBaseData.nType == 16 or WndBuyActivity.m_tBaseData.nType == 17 then
        sFormat = LocalStrings.BUY_FIVEFAMILY_ATTENTION
        local basicInfo = GDatatab_item["id_" .. WndBuyActivity.m_tBaseData.nResultType]
        imgGaainIcon:setFile(basicInfo.icon)
        imgGaainIcon:setScale(0.4)
        GetElement(self.m_root, "txtGetWord_WndBuyFiveAttention", WZUILabelTTF):setText(LocalStrings.MOUNT_CAN_LOCK)
        GetElement(self.m_root, "conForAtt_WndBuyFiveAttention", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conInfo_WndBuyFiveAttention", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.6))
    end
    if WndBuyActivity.m_tBaseData.nType == 16 or WndBuyActivity.m_tBaseData.nType == 17 then
        local sFreeBoxTxt = string.format(sFormat, self.m_nShakeTimes, GDatatab_item["id_" .. WndBuyActivity.m_tBaseData.nResultType].name)
        GetElement(self.m_root, "freetxtContent_WndBuyFiveAttention", WZUIFreeTextBox):setShowText(sFreeBoxTxt)
    else
        local sFreeBoxTxt = string.format(sFormat, self.m_nShakeTimes)
        GetElement(self.m_root, "freetxtContent_WndBuyFiveAttention", WZUIFreeTextBox):setShowText(sFreeBoxTxt)
    end

    GetElement(self.m_root, "txtGetNum_WndBuyFiveAttention", WZUILabelTTF):setText(self.m_nGainValue)
    GetElement(self.m_root, "txtCostNum_WndBuyFiveAttention", WZUILabelTTF):setText(self.m_nCostValue)
    local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndBuyFiveAttention", WZUIImage)
    imgCostIcon:setFile(GDatatab_item["id_" .. self.m_nCostId].icon)
    imgCostIcon:setScale(0.5)
end


--@brief  越南语适配函数
--@return 无
--@note   备注
function WndBuyFiveAttention:_adaptLanguage_vn()
    GetElement(self.m_root,"txtCostWord_WndBuyFiveAttention",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtCostNum_WndBuyFiveAttention",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtGetWord_WndBuyFiveAttention",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtGetNum_WndBuyFiveAttention",WZUILabelTTF):setFontSize(18)
    local freetxtContent = GetElement(self.m_root, "freetxtContent_WndBuyFiveAttention", WZUIFreeTextBox)
    freetxtContent:setScale(0.8)
end


function WndBuyFiveAttention:_adaptLanguage_en()
    GetElement(self.m_root,"txtCostWord_WndBuyFiveAttention",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtGetWord_WndBuyFiveAttention",WZUILabelTTF):setFontSize(18)
end

function WndBuyFiveAttention:_adaptLanguage_tr(  )
    local txtGetWord = GetElement(self.m_root,"txtGetWord_WndBuyFiveAttention",WZUILabelTTF)
    txtGetWord:setFontSize(16)
    txtGetWord:setRelativePosition(GlobalMethod:ccp(0.05,0.27))
    local imgGold = GetElement(self.m_root,"imgGaainIcon_WndBuyFiveAttention",WZUIImage)
    imgGold:setRelativePosition(GlobalMethod:ccp(0.6,0.27))
end
function WndBuyFiveAttention:_adaptLanguage_es(  )
    local imgGold = GetElement(self.m_root,"imgGaainIcon_WndBuyFiveAttention",WZUIImage)
    imgGold:setRelativePosition(GlobalMethod:ccp(0.59,0.27))
end

function WndBuyFiveAttention:_adaptLanguage_pt(  )
    local txtGetWord = GetElement(self.m_root,"txtGetWord_WndBuyFiveAttention",WZUILabelTTF)
    txtGetWord:setRelativePosition(GlobalMethod:ccp(0.07,0.27))

    local freetxtContent = GetElement(self.m_root, "freetxtContent_WndBuyFiveAttention", WZUIFreeTextBox)
    freetxtContent:setRelativePosition(GlobalMethod:ccp(0,0.78))
    freetxtContent:setMaxWidth(320)
    GetElement(self.m_root,"imgArrow1_WndBuyFiveAttention",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.29,0.85))
    GetElement(self.m_root,"imgArrow2_WndBuyFiveAttention",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.71,0.85))
end
-------------------------------------私有方法模块End----------------------------------------
