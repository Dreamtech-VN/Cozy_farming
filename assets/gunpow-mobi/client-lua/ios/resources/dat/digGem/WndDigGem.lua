--WndDigGem.lua
--@brief	WndDigGem的UI模块
--@date		2017/03/13
--@author	Tianxiang_Xu
--@note		挖宝系统界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDigGem:onEnter(element)
	self.m_root = element
    ProtocolProcessorDigGem:regAll()
    ChangeChatChannel(Chat_Channel_DigGem)
    
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDigGem:onExit(element)
    ProtocolProcessorDigGem:unregAll()
	self:_unInit()
end

--@brief    界面加载完成回调
function WndDigGem:onEnterTransitionDidFinish(element)
    -- body
    --添加顶部货币栏
    self:_addTop()
    self.m_nTabIndex = GetElement(self.m_root, "checkBoxGroup_WndDigGem", WZUICheckBoxGroup):getCheckIndex()
    self:_createBagGrid()
    self:showRedDot(GlobalGame.g_tRedPointList.transaction)
    local particleGetGem = GetElement(self.m_root, "particleGetGem_WndDigGem", WZUIParticle)
    local conTarget = GetElement(self.m_root, "conTarget_WndDigGem", WZUIContainer)
    if particleGetGem then 
        self.m_tOriginPosition = particleGetGem:getRelativePosition()
    end
    if conTarget then
        self.m_tTargetPosition = conTarget:getRelativePosition()
        WZLog("WndDigGem:onEnterTransitionDidFinish", self.m_tTargetPosition.x, self.m_tTargetPosition.y)
    end

    self:sendGetDem(1)
    AdaptLanguage(self)
end

--@brief    触摸开始回调
function WndDigGem:onTouchBegin(element, pt)
    -- body
    if self.m_topCellLua then
        self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
    self.m_tClickGemInfo = nil 
end

--@brief    点击退出按钮回调
function WndDigGem:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    
    WindowManager:removeWindow(self.m_root, self, true)
end

--brief     点击宝物背包标签回调
function WndDigGem:onClickBag(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_nTabIndex == 0 then return end 

    self.m_nTabIndex = 0
    self:_updateRightContent()
end

--brief     点击挖宝日志标签回调
function WndDigGem:onClickLog(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_nTabIndex == 1 then return end 
    self.m_nTabIndex = 1
    if self.m_tLogList == nil then
        self:_createLoading()
        ProtocolProcessorDigGem:send_MINING_MiningLog( )
        return 
    end
    self:_updateRightContent()
end

--brief     点击图鉴按钮回调
function WndDigGem:onLibraryClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndGemLibrary:showInterface()
end

--brief     点击鉴定按钮回调
function WndDigGem:onAppraiseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WndGemAppraise:showInterface()
end

--brief     点击交易按钮回调
function WndDigGem:onExchangeClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WndTransaction:show()
end

--brief     点击回收按钮回调
function WndDigGem:onRecoverClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WndTransaction:showTab(3)
end

--@brief    点击开始挖宝按钮回调
function WndDigGem:onClickStart(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_bIsStart then
        --停止挖宝，发送协议
        self:_createLoading()
        self.m_nOperateType = 2 
        ProtocolProcessorDigGem:send_MINING_StopMining( )
    else
        --开始挖宝，弹出工具界面，选择工具
        if #self.m_tBagList >= self.m_nMaxNum then
            MsgBoxManager:showTipBox(LocalStrings.DIGGEM_TEXT12)
            return 
        end
        WndGemTool:showInterface()
    end
end

--@brief    点击宝石回调
function WndDigGem:onItemClick(tItem, nTag, tData)
    -- body
    self.m_tClickGemInfo = {}
    self.m_tClickGemInfo.tag = nTag 
    self.m_tClickGemInfo.tData = CopyTable(tData) 

    local conOutside = GetElement(self.m_root, "conOutside_WndDigGem", WZUIContainer)
    WndItemInfo:showInfo(tItem.m_root,conOutside,1,tData, false)
end

--@brief    点击工具使用按钮调用
function WndDigGem:onClickUseTool(tData)
    -- body
    self.m_tUseToolData = tData 
    --发送使用工具，开始挖矿协议
    self:_createLoading()
    self.m_nOperateType = 3
    ProtocolProcessorDigGem:send_MINING_StartMining(tData.id)
end

--@brief    购买挖宝工具
function WndDigGem:onClickBuyTool(tData)
    --body
    if tData.buy_price[1][1] == 2 then
        if CacheCenter:getMoneyList().gold < tData.buy_price[1][2] then
            JudgeMoneyIsEnough(2, tData.buy_price[1][2],nil,nil,194)
            return 
        end
    elseif tData.buy_price[1][1] == 58 then
        local bCanBuy = JudgeMoneyIsEnough(58, tData.buy_price[1][2],nil,nil,194)
        if not bCanBuy then
            return 
        end
    end
    self:_createLoading()
    self.m_nOperateType = 4
    ProtocolProcessorDigGem:send_MINING_BuyTool(tData.id)
end

--@brief    点击确认购买回调
function WndDigGem:_sureToBuy(num)
    -- body
    local nMaxCount, tCurIndex = self:getBuyData(13)
    local nLeftTimes = nMaxCount - self.m_nBuyGemCoinTimes
    WZLog("WndDigGem:_sureToBuy", nMaxCount, self.m_nBuyGemCoinTimes)
    if nLeftTimes == 0 then
        self:_showTipsAccordCase()
    else
        local bDiamondEnough = JudgeMoneyIsEnough(1, tCurIndex.cost[1][2],nil,nil,194)
        if bDiamondEnough then
            ProtocolProcessorDigGem:send_MINING_MiningBuy(num)
        end
    end
end

--@brief    发送挖宝申请
--@param    nType:
function WndDigGem:sendGetDem(nType)
    --body
    WZLog("WndDigGem:sendGetDem 0000000000")
    if self.m_root == nil then return end 
    self:_createLoading()
    self.m_nOperateType = nType
    ProtocolProcessorDigGem:send_MINING_GetMining()
end

--@brief    鉴定或出售，下架后刷新挖宝背包
function WndDigGem:updateGemBag(item, num)
    -- body
    if self.m_root == nil then return end 

    self:resetBagData(item, num)
    self:_updateRightContent()
end

--@brief    交易行红点
function WndDigGem:showRedDot(bVisible)
    -- body
    if self.m_root == nil then return end 
    
    local imgRedDot = GetElement(self.m_root, "imgRedDot_WndDigGem", WZUIImage)
    if imgRedDot then
        imgRedDot:setVisible(bVisible)
    end
end

--@brief    点击规则按钮回调
--@brief    点击帮助按钮回调
function WndDigGem:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.DIGGEM_TEXT42)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    创建背包格子
function WndDigGem:_createBagGrid()
    -- body
    local tableBagList = GetElement(self.m_root, "tableBagList_WndDigGem", WZUITableContainer)
    tableBagList:cleanTable()
    tableBagList:setLoadCountPerFrame(3)
    self.m_tCellGridList = {}

    for i= 1, self.m_nMaxNum do
        local celElement,tCell = CellGrid:createElement()
        if celElement and tCell then
            celElement:setTag(i-1)
            tableBagList:setCellElement(celElement)
            tCell:setItemClickFun(self,self.onItemClick)
            table.insert(self.m_tCellGridList,tCell)
        end
    end
end

--brief     设置背包格子数据
function WndDigGem:_setBagData()
    -- body
    for i = 1, self.m_nMaxNum do
        self.m_tCellGridList[i]:removeAllChild()
    end

    for i = 1, #self.m_tBagList do
        self.m_tCellGridList[i]:setCellGoodItem(self.m_tBagList[i],2)
    end

    if self.m_tClickGemInfo ~= nil then
        if self.m_tBagList[self.m_tClickGemInfo.tag + 1] and self.m_tBagList[self.m_tClickGemInfo.tag + 1].id ~= self.m_tClickGemInfo.tData.id then
            --取消之前的选中状态
            self.m_tCellGridList[self.m_tClickGemInfo.tag + 1]:setHighLight(false)
            if self.m_tBagList[self.m_tClickGemInfo.tag + 2] and self.m_tBagList[self.m_tClickGemInfo.tag + 2].id == self.m_tClickGemInfo.tData.id then
                self.m_tCellGridList[self.m_tClickGemInfo.tag + 2]:setHighLight(true)
                self.m_tClickGemInfo.tag = self.m_tClickGemInfo.tag + 1
            end
        end
    end
end
--@brief    创建日志列表
function WndDigGem:_createLog()
    -- body
    local tableLogList = GetElement(self.m_root, "tableLogList_WndDigGem", WZUITableContainer)
    local nCurPositionY = tableLogList:getMoveElement():getPositionY()
    local nLastSize = tableLogList:getMoveElement():getContentSize()
    tableLogList:cleanTable()

    local conLog = GetElement(self.m_root, "conLog_WndDigGem", WZUIContainer)
    if self.m_tLogList == nil or #self.m_tLogList == 0 then
        ShowPanelNullTip( conLog, LocalStrings.DIGGEM_TEXT21, GlobalMethod:ccc3(195,171,148))
        return 
    end
    removeShowPanelNullTip(conLog)

    for i = 1, #self.m_tLogList do
        local celElement, tNewObj = CellDigGemLog:createElement()
        if celElement and tNewObj then
            celElement:setTag(i - 1)
            tNewObj:setData(self.m_tLogList[i])
            tableLogList:setCellElement(celElement)
        end
    end

    --重新设置列表位置
    local nCurSize = tableLogList:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (nCurSize.height - nLastSize.height)/2
    if nTempPositionY > tableLogList:getMaxPosition().y then
        nTempPositionY = tableLogList:getMaxPosition().y
    end
    tableLogList:getMoveElement():setPositionY(nTempPositionY)
end

--@brief     添加顶部货币栏
function WndDigGem:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/digGem/common_icon_wabao.png", WndDigGem, WndDigGem.onClickClose, true, false, false,nil, {goldType = 7})
    self.m_root:addChild(celElement)

    self.m_topCellLua = tNewObj
end

--@brief    设置文本
function WndDigGem:_setStaticText()
    -- body
    local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_WndDigGem", WZUIFreeTextBox)
    local txtExp = GetElement(self.m_root, "txtExp_WndDigGem", WZUILabelTTF)
    if ftxtLeftTime then
        if self.m_bIsStart then
            self:_showLeftTime()
            ftxtLeftTime:setVisible(true)
            txtExp:setRelativePosition(GlobalMethod:ccp(0.5,0.7))
            self.m_root:enableSchedule("_caculateTime", 0.2)
        else
            ftxtLeftTime:setVisible(false)
            txtExp:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        end
    end
    
    --熟练度
    self:_showExp()
end

--@brief    挖宝剩余时间倒计时
function WndDigGem:_caculateTime(element, delta)
    -- body
    self.m_nTempSeconds = self.m_nTempSeconds + delta
    if self.m_nTempSeconds >= 1 then
        if self.m_nToolLeftTime > 0 then
            self.m_nToolLeftTime = self.m_nToolLeftTime - 1
            self.m_nTempSeconds = self.m_nTempSeconds - 1
            self:_showLeftTime()
            --计算下次挖到宝物时间，倒计时为零发送请求
            if self.m_nNextStartTime > 0 then
                self.m_nNextStartTime = self.m_nNextStartTime - 1
            else
                --挖到宝物
                if self.m_nNextStartTime == 0 then
                    self.m_nNextStartTime = -1
                    self:sendGetDem(5)
                end
            end
        else
            if self.m_nToolLeftTime == 0 then
                self.m_nToolLeftTime = -1
                self:sendGetDem(6)
            end
            self:_stopDigDemToDealWith(1)
        end
    end
end

--@brief    根据选中的标签，显示相应的信息
function WndDigGem:_updateRightContent()
    -- body
    --右边底部字
    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    if ftxtBottomText then
        if self.m_nTabIndex == 0 then
            local sFormat = [[<T C="255,227,116" S="20" P="1">%s:</T><T C="255,236,193" S="20" P="1">%d/%d</T>]]
            local nItemNum = #self.m_tBagList
            ftxtBottomText:setShowText(string.format(sFormat, LocalStrings.DIGGEM_TEXT7, nItemNum, self.m_nMaxNum))
        elseif self.m_nTabIndex == 1 then
            local sFormat = [[<T C="255,227,116" S="20" P="1">%s</T>]]
            ftxtBottomText:setShowText(string.format(sFormat, LocalStrings.DIGGEM_TEXT8))
        end
    end

    --
    if self.m_nTabIndex == 0 then
        GetElement(self.m_root, "conBag_WndDigGem", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conLog_WndDigGem", WZUIContainer):setVisible(false)

        self:_setBagData()
    elseif self.m_nTabIndex == 1 then
        GetElement(self.m_root, "conBag_WndDigGem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conLog_WndDigGem", WZUIContainer):setVisible(true)

        self:_createLog()
    end
end

--@brief    设置挖宝按钮字
function WndDigGem:_showBtnText(sText)
    -- body
    local txtBtnText = GetElement(self.m_root, "txtBtnText_WndDigGem", WZUILabelTTF)
    if txtBtnText then
        txtBtnText:setText(sText)
    end
end

--@brief    显示挖宝剩余时间
function WndDigGem:_showLeftTime()
    -- body
    local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_WndDigGem", WZUIFreeTextBox)
    local sTime = returnToTimeFormat(self.m_nToolLeftTime)
    local sTimeFormat = [[<T C="255,236,193" S="20" P="1">%s</T><T C="255,89,74" S="20" P="1">%s</T>]]
    if ftxtLeftTime then
        ftxtLeftTime:setShowText(string.format(sTimeFormat, LocalStrings.DIGGEM_TEXT3, sTime))
    end
end

--@brief    显示熟练度相关
function WndDigGem:_showExp()
    -- body
    local txtExp = GetElement(self.m_root, "txtExp_WndDigGem", WZUILabelTTF)
    if txtExp then
        txtExp:setText(LocalStrings.DIGGEM_TEXT6 .. ":" .. "Lv" .. self.m_nMyLevel .. "(" .. self.m_nCurExp .. "/" .. self.m_nCurMaxExp .. ")")
    end
end

--@brief    停止挖宝处理
--@param    nType: 1->时间到，自动停止；2->主动停止；3->背包满，自动停止
function WndDigGem:_stopDigDemToDealWith(nType)
    -- body
    local txtTipContent 
    if nType == 1 then
        txtTipContent = LocalStrings.DIGGEM_TEXT11
    elseif nType == 2 then
        txtTipContent = LocalStrings.DIGGEM_TEXT14
    elseif nType == 3 then
        txtTipContent = LocalStrings.DIGGEM_TEXT12
    end
    MsgBoxManager:showTipBox(txtTipContent)
    --
    self.m_root:disableSchedule()
    self.m_bIsStart = false
    self.m_nNextStartTime = 0
    self:_setStaticText()
    self:_showBtnText(LocalStrings.DIGGEM_TEXT4)
    --切换挖宝动画
    self:_showDigGemAni(0)
end

--@brief    显示挖宝动画
--@param    nIndex : 动画索引
function WndDigGem:_showDigGemAni(nIndex)
    -- body
    local spineRole = GetElement(self.m_root, "spineRole_WndDigGem", WZUISpine)
    if spineRole then
        if nIndex == 0 then
            GetElement(self.m_root, "imgDigging_WndDigGem", WZUIImage):setVisible(false)
            spineRole:setVisible(false)
        else
            spineRole:setAnimationName("dug" .. nIndex)
            spineRole:setVisible(true)
            GetElement(self.m_root, "imgDigging_WndDigGem", WZUIImage):setVisible(true)
        end
    end
end

--@brief    当购买次数用完后，根据情况弹出不同的提示
function WndDigGem:_showTipsAccordCase()
    -- body
    local nMaxVipValue = GetMaxVipLevel()

    if CacheCenter:getPlayerInfo().vipLevel < nMaxVipValue then
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
        MsgBoxManager:showConfirmBox(LocalStrings.BUY_UNSUCCESS, self, self.needMoreDiamondCallBack, nil, tCustomUIConfig)
    elseif CacheCenter:getPlayerInfo().vipLevel == nMaxVipValue then
        MsgBoxManager:showTipBox(LocalStrings.DIGGEM_TEXT35)
    end
end

--@brief    提示充值框的回调
--@param    nId:消息id
--@param    nResType:响应类型(超时，确定，取消)
function WndDigGem:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

--@brief    挖宝动作音效
function WndDigGem:attack()
    -- body
    WZLog("WndDigGem:attack")
--    SoundManager:playEffectSound(SoundDefine.E_S_KILL_WABAO)
end
-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function WndDigGem:_adaptLanguage_en(  )
    local txtBackpack1 = GetElement(self.m_root, "txtBackpack1_WndDigGem", WZUILabelTTF)
    txtBackpack1:setScale(0.85)
    txtBackpack1:setDimensions(GlobalMethod:CCSize(110))
    local txtBackpack2 = GetElement(self.m_root, "txtBackpack2_WndDigGem", WZUILabelTTF)
    txtBackpack2:setScale(0.85)
    txtBackpack2:setDimensions(GlobalMethod:CCSize(110))

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.8)
    ftxtBottomText:setMaxWidth(500)

    GetElement(self.m_root,"imgBtn2_WndDigGem",WZUIImage):setScale(0.7)
    GetElement(self.m_root,"imgBtn3_WndDigGem",WZUIImage):setScale(0.8)
end

function WndDigGem:_adaptLanguage_th(  )
    local txtLog1 = GetElement(self.m_root, "txtLog1_WndDigGem", WZUILabelTTF)
    txtLog1:setScale(0.75)
    local txtLog2 = GetElement(self.m_root, "txtLog2_WndDigGem", WZUILabelTTF)
    txtLog2:setScale(0.75)

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.7)
    ftxtBottomText:setMaxWidth(500)

    GetElement(self.m_root,"imgBtn2_WndDigGem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.58,0))
end

function WndDigGem:_adaptLanguage_vn(  )
    local txtBackpack1 = GetElement(self.m_root, "txtBackpack1_WndDigGem", WZUILabelTTF)
    txtBackpack1:setScale(0.8)
    txtBackpack1:setDimensions(GlobalMethod:CCSize(110))
    local txtBackpack2 = GetElement(self.m_root, "txtBackpack2_WndDigGem", WZUILabelTTF)
    txtBackpack2:setScale(0.8)
    txtBackpack2:setDimensions(GlobalMethod:CCSize(110))

    local txtLog1 = GetElement(self.m_root, "txtLog1_WndDigGem", WZUILabelTTF)
    txtLog1:setScale(0.8)
    txtLog1:setDimensions(GlobalMethod:CCSize(110))
    local txtLog2 = GetElement(self.m_root, "txtLog2_WndDigGem", WZUILabelTTF)
    txtLog2:setScale(0.8)
    txtLog2:setDimensions(GlobalMethod:CCSize(110))

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.8)
    ftxtBottomText:setMaxWidth(500)
end

function WndDigGem:_adaptLanguage_pt(  )
    local txtBackpack1 = GetElement(self.m_root, "txtBackpack1_WndDigGem", WZUILabelTTF)
    txtBackpack1:setScale(0.8)
    txtBackpack1:setDimensions(GlobalMethod:CCSize(120))
    local txtBackpack2 = GetElement(self.m_root, "txtBackpack2_WndDigGem", WZUILabelTTF)
    txtBackpack2:setScale(0.8)
    txtBackpack2:setDimensions(GlobalMethod:CCSize(120))

    local txtLog1 = GetElement(self.m_root, "txtLog1_WndDigGem", WZUILabelTTF)
    txtLog1:setScale(0.6)
    txtLog1:setDimensions(GlobalMethod:CCSize(160))
    local txtLog2 = GetElement(self.m_root, "txtLog2_WndDigGem", WZUILabelTTF)
    txtLog2:setScale(0.6)
    txtLog2:setDimensions(GlobalMethod:CCSize(160))

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.7)
    ftxtBottomText:setMaxWidth(380)

    local txtBtnText = GetElement(self.m_root, "txtBtnText_WndDigGem", WZUILabelTTF)
    txtBtnText:setScale(0.8)
    txtBtnText:setDimensions(GlobalMethod:CCSize(200))

    local imgBtn2 = GetElement(self.m_root,"imgBtn2_WndDigGem",WZUIImage)
    imgBtn2:setScale(0.6)
    imgBtn2:setRelativePosition(GlobalMethod:ccp(0.566667,0))
end

function WndDigGem:_adaptLanguage_es(  )
    local txtBackpack1 = GetElement(self.m_root, "txtBackpack1_WndDigGem", WZUILabelTTF)
    txtBackpack1:setScale(0.8)
    txtBackpack1:setDimensions(GlobalMethod:CCSize(120))
    local txtBackpack2 = GetElement(self.m_root, "txtBackpack2_WndDigGem", WZUILabelTTF)
    txtBackpack2:setScale(0.8)
    txtBackpack2:setDimensions(GlobalMethod:CCSize(120))

    local txtLog1 = GetElement(self.m_root, "txtLog1_WndDigGem", WZUILabelTTF)
    txtLog1:setScale(0.6)
    txtLog1:setDimensions(GlobalMethod:CCSize(160))
    local txtLog2 = GetElement(self.m_root, "txtLog2_WndDigGem", WZUILabelTTF)
    txtLog2:setScale(0.6)
    txtLog2:setDimensions(GlobalMethod:CCSize(160))

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.7)
    ftxtBottomText:setMaxWidth(380)

    local txtBtnText = GetElement(self.m_root, "txtBtnText_WndDigGem", WZUILabelTTF)
    txtBtnText:setScale(0.8)
    txtBtnText:setDimensions(GlobalMethod:CCSize(200))
end

function WndDigGem:_adaptLanguage_tr(  )
    local txtBackpack1 = GetElement(self.m_root, "txtBackpack1_WndDigGem", WZUILabelTTF)
    txtBackpack1:setScale(0.8)
    txtBackpack1:setDimensions(GlobalMethod:CCSize(120))
    local txtBackpack2 = GetElement(self.m_root, "txtBackpack2_WndDigGem", WZUILabelTTF)
    txtBackpack2:setScale(0.8)
    txtBackpack2:setDimensions(GlobalMethod:CCSize(120))

    local txtLog1 = GetElement(self.m_root, "txtLog1_WndDigGem", WZUILabelTTF)
    txtLog1:setScale(0.6)
    txtLog1:setDimensions(GlobalMethod:CCSize(160))
    local txtLog2 = GetElement(self.m_root, "txtLog2_WndDigGem", WZUILabelTTF)
    txtLog2:setScale(0.6)
    txtLog2:setDimensions(GlobalMethod:CCSize(160))

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.7)
    ftxtBottomText:setMaxWidth(380)

    local txtBtnText = GetElement(self.m_root, "txtBtnText_WndDigGem", WZUILabelTTF)
    txtBtnText:setScale(0.8)
    txtBtnText:setDimensions(GlobalMethod:CCSize(200))
    
    GetElement(self.m_root,"imgBtn3_WndDigGem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.6,0))
    GetElement(self.m_root,"imgBtn4_WndDigGem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.55,0))
end
---------------------------------------语言适配End------------------------------------------