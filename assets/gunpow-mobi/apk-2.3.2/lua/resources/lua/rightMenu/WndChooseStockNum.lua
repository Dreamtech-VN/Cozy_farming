--WndChooseStockNum.lua
--@brief	WndChooseStockNum的UI模块
--@date		2017/09/27
--@author	Tianxiang_Xu
--@note		选择入股数量界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChooseStockNum:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndChooseStockNum:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndChooseStockNum:onEnterTransitionDidFinish(element)
    -- body
    self.m_nTempNum = self.m_tData.minBuyNum
    local nLeftNum = self.m_tData.totalNum - self.m_tData.curNum
    if self.m_tData.joinType == 1 and self.m_nTempNum <= nLeftNum then 
        self.m_bIsCanChooseNum = true
    end
    if self.m_nTempNum > nLeftNum then
        self.m_nTempNum = nLeftNum
    end
    self:_update()
end

--@brief    点击取消按钮回调
function WndChooseStockNum:onCancel(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self:closeWin()
end

--@brief    关闭购买界面
function WndChooseStockNum:closeWin()
    -- body
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击确定按钮回调
function WndChooseStockNum:onConfirm(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local nCostNum = self.m_nTempNum * self.m_tData.price
    local nCostId = self.m_tData.priceId

    if not JudgeMoneyIsEnough(nCostId, nCostNum, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseInstead) then 
        return 
    end

    self:sureToUseInstead()
end

--@brief    如果是消耗礼钻，不足用钻石代替回调
function WndChooseStockNum:sureToUseInstead()
    -- body
    WndGameActivity:_createLoading()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_Growdfunding(self.m_tData.rewardId, self.m_tData.verifyKey, self.m_nTempNum)
end

--@brief    输入完成回调
function WndChooseStockNum:onFinishInput(element)
    -- body
    element = WZUIEditBox:luaTo(element)
    local txt = element:getText()
    if txt ~= nil and txt ~= "" then
        --限制数量
        local nTempNum = string.find(txt, "%D")
        if nTempNum then 
            MsgBoxManager:showTipBox(LocalStrings.MANYCOLLECT_TEXT11)
        else
            local num = tonumber(txt)
            if num then 
                if num > self.m_tData.totalNum - self.m_tData.curNum then
                    self.m_nTempNum = self.m_tData.totalNum - self.m_tData.curNum
                else
                    self.m_nTempNum = num 
                    if self.m_nTempNum < self.m_tData.minBuyNum then 
                        self.m_nTempNum = self.m_tData.minBuyNum
                    end
                end
                self:_update()
            else
                MsgBoxManager:showTipBox(LocalStrings.MANYCOLLECT_TEXT11)
            end
        end
        element:setText("")
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function WndChooseStockNum:_update()
    -- body
    WZLog("WndChooseStockNum:_update", Serialize(self.m_tData))
    local freetxtContent = GetElement(self.m_root, "freetxtContent_WndChooseStockNum", WZUIFreeTextBox)
    local ftxtInputAtt = GetElement(self.m_root, "ftxtInputAtt_WndChooseStockNum", WZUIFreeTextBox)
    if freetxtContent then 
        if self.m_tData.joinType == 1 then
            ftxtInputAtt:setShowText(LocalStrings.MANYCOLLECT_TEXT15)
        end
        freetxtContent:setShowText(string.format(LocalStrings.MANYCOLLECT_TEXT10, self.m_nTempNum))
    end
    if freetxtContent then 
        if self.m_tData.joinType == 1 then
            ftxtInputAtt:setShowText(LocalStrings.MANYCOLLECT_TEXT15)
        end
    end
    WZLog("WndChooseStockNum:_update", self.m_nTempNum, self.m_tData.minBuyNum)
    if self.m_bIsCanChooseNum then 
        GetElement(self.m_root, "editorNum_WndChooseStockNum", WZUIEditBox):setTouchEnable(true)
    end
end




-------------------------------------私有方法模块End----------------------------------------
