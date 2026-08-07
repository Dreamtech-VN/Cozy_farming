--WndUpTaskRewards.lua
--@brief	WndUpTaskRewards的UI模块
--@date		2014/09/10
--@author	SuYuan
--@note		提升任务奖励弹窗


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndUpTaskRewards:onEnter(element)
	self.m_root = element

	self:_setStaticText()
	
    --多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndUpTaskRewards:onExit(element)
	self:_unInit()
end

--@brief	点击不再提示按钮的响应方法
--@param	element:不再提示按钮绑定的UI节点引用
--@note		点击不再提示按钮的响应方法
function WndUpTaskRewards:onDontTipAgain(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_bShowTip then
        self.m_bShowTip = false
    else
        self.m_bShowTip = true
    end
end

--@brief	点击取消按钮的响应方法
--@param	element:取消按钮绑定的UI节点引用
--@note		点击取消按钮的响应方法
function WndUpTaskRewards:onCancel(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	点击确定按钮的响应方法
--@param	element:确定按钮绑定的UI节点引用
--@note		点击确定按钮的响应方法
function WndUpTaskRewards:onOK(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if not self.m_bShowTip then
        local data = WZDataFile:getInstance():getUserData()
        if data ~= nil then
            if 1 == self.m_nTipType then
                data:setStringValue("TaskTipData", "ShowQuickCompleteStatus", 0)
            elseif 2 == self.m_nTipType then
                data:setStringValue("TaskTipData", "ShowUpRewardsStatus", 0)
            end
            data:flush()
        end
    end

    if "table" == type(self.m_tCallbackTable) and "function" == type(self.m_fnCallback) then
        self.m_fnCallback(self.m_tCallbackTable)
    end

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    设置点击确定按钮后执行的回调函数
--@param    tCallbackTable:回调函数所属lua表
--@param    fnCallback:回调函数
function WndUpTaskRewards:setCallback(tCallbackTable, fnCallback)
    self.m_tCallbackTable = tCallbackTable
    self.m_fnCallback = fnCallback
end

--@brief    设置本次操作消耗的钻石
--@param    nCost:消耗的钻石
function WndUpTaskRewards:setCost(nCost)
    self.m_nCost = nCost
end

--@brief    设置提示类型
--@param    nTipType:提示类型（1：快速完成，2：提升奖励）
function WndUpTaskRewards:setType(nTipType)
    self.m_nTipType = nTipType
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置界面上的静态文本
function WndUpTaskRewards:_setStaticText()
    if 1 == self.m_nTipType then
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.QUICK_COMPLETE_NEED)
    elseif 2 == self.m_nTipType then
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.IMPROVE_REWARD_NEED)
    end
    GetElement(self.m_root, "txtCost_WndUpTaskRewards", WZUILabelTTF):setText(self.m_nCost)
    GetElement(self.m_root, "txtNomoreTip_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.NOMORETIP)
    GetElement(self.m_root, "txtCancel_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.CANCEL)
    GetElement(self.m_root, "txtOK_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.CONFIRM)
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

--@brief	英文适配函数
--@note		英文适配函数
function WndUpTaskRewards:_adaptLanguage_en()
    GetElement(self.m_root, "txtCost_WndUpTaskRewards", WZUILabelTTF):setText(self.m_nCost)
    if 1 == self.m_nTipType then
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.QUICK_COMPLETE_NEED)
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.0,0.85))
        GetElement(self.m_root, "imgDiamondIcon", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.5,0.15))       
        GetElement(self.m_root, "txtCost_WndUpTaskRewards", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.15))
    elseif 2 == self.m_nTipType then
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.IMPROVE_REWARD_NEED)
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.85,0.5))
        GetElement(self.m_root, "imgDiamondIcon", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.9,0.5))
        GetElement(self.m_root, "txtCost_WndUpTaskRewards", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.95,0.5))
    end
    
    GetElement(self.m_root, "txtNomoreTip_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.NOMORETIP)
    
    GetElement(self.m_root, "tipsContent", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.4,0.3))
end

--@brief    越南语适配
function WndUpTaskRewards:_adaptLanguage_vn(  )
    GetElement(self.m_root, "txtCost_WndUpTaskRewards", WZUILabelTTF):setText(self.m_nCost)
    if 1 == self.m_nTipType then
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.QUICK_COMPLETE_NEED)
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.85,0.85))
        GetElement(self.m_root, "imgDiamondIcon", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.5,0.15))       
        GetElement(self.m_root, "txtCost_WndUpTaskRewards", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.15))
    elseif 2 == self.m_nTipType then
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.IMPROVE_REWARD_NEED)
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.75,0.5))
        GetElement(self.m_root, "imgDiamondIcon", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.8,0.5))
        GetElement(self.m_root, "txtCost_WndUpTaskRewards", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.85,0.5))
    end
    
    GetElement(self.m_root, "txtNomoreTip_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.NOMORETIP)
    
    GetElement(self.m_root, "tipsContent", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.45,0.3)) 
end

function WndUpTaskRewards:_adaptLanguage_pt(  )
    GetElement(self.m_root, "txtCost_WndUpTaskRewards", WZUILabelTTF):setText(self.m_nCost)
    if 1 == self.m_nTipType then
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.QUICK_COMPLETE_NEED)
        GetElement(self.m_root, "txtTip_WndUpTaskRewards",  WZUILabelTTF):setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(530,0))
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.45))
        GetElement(self.m_root, "imgDiamondIcon", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.65,0.15))       
        GetElement(self.m_root, "txtCost_WndUpTaskRewards", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.15))
    elseif 2 == self.m_nTipType then
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.IMPROVE_REWARD_NEED)
        GetElement(self.m_root, "txtTip_WndUpTaskRewards", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.75,0.5))
        GetElement(self.m_root, "imgDiamondIcon", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.8,0.5))
        GetElement(self.m_root, "txtCost_WndUpTaskRewards", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.85,0.5))
    end
    
    GetElement(self.m_root, "txtNomoreTip_WndUpTaskRewards", WZUILabelTTF):setText(LocalStrings.NOMORETIP)
    
    GetElement(self.m_root, "tipsContent", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.45,0.3))
    GetElement(self.m_root, "txtCancel_WndUpTaskRewards", WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root, "txtOK_WndUpTaskRewards", WZUILabelTTF):setFontSize(22)
end
-------------------------------------语言适配模块End----------------------------------------



