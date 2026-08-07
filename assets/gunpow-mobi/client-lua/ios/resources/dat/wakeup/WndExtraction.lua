--WndExtraction.lua
--@brief	WndExtraction的UI模块
--@date		2017/05/25
--@author	Tianxiang_Xu
--@note		萃取模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndExtraction:onEnter(element)
	self.m_root = element
    CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
    ProtocolProcessorWakeup:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndExtraction:onExit(element)
    CacheCenter:unregisterUpatePlayerItemObserver(self)
    if WndWakeup.m_root == nil then
        ProtocolProcessorWakeup:unregAll()
    end
	self:_unInit()
end

--@brief    加载界面完成回调
function WndExtraction:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"txtTitle",WZUILabelTTF):setText(LocalStrings.EXTRACTION_TEXT1)

    ProtocolProcessorMerge:regAll()
    -- body
    self:_setStaticInfo()

    self:setData()
    self:_moreLanguage()
    AdaptLanguage(self)
	self:_updateTab2()
end

--@brief    关闭按钮回调
function WndExtraction:onCloseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击物品回调
function WndExtraction:onItemClick(tItem, nTag, tData)
    -- body
    if not self.m_bIsCanExtraction then return end
    --检查点击的宝物是否已经被放入萃取栏，是则从萃取栏移除
    local bInAppraise = false

    local nTempId = tData.id
    if self.m_nLeftTopIndex == 2 then
        nTempId = tData.playerItemId
    elseif self.m_nLeftTopIndex == 3 then
        nTempId = tData.playerPetId
    elseif self.m_nLeftTopIndex == 4 then
        nTempId = tData.blessId
    end

    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id ~= nil and self.m_tAppraiseList[i].id == nTempId then
            if self.m_tAppraiseList[i].tagInBag == nTag then
                bInAppraise = true
                --宝物已经在萃取栏，放回背包
                self:_updateBagItemNum(2, i)
                break 
            end
        end
    end

    if bInAppraise then
        return 
    end

    tData.tBtnList = {LocalStrings.EXTRACTION_TEXT1}
    self.m_nClickItemTag = nTag
    if self.m_nLeftTopIndex == 3 then
        WndTips:show(tItem.m_root,WndExtraction.m_root,13,tData,GlobalMethod:ccp(200,15))
        WndTips:setCallBackFunc(self, self.onAddForAppraise)
    elseif self.m_nLeftTopIndex == 4 then
    else
        WndItemInfo:showInfo(tItem.m_root,WndExtraction.m_root,1,tData)
        WndItemInfo:setClickButtonCallback(self,self.onAddForAppraise)
    end
end

--@brief    点击物品tips萃取按钮回调
function WndExtraction:onAddForAppraise(tag, tData)
    WZLog("WndExtraction:onAddForAppraise")
    if not self.m_bIsCanExtraction then return end
    local nLeftGridNum = self:_getLeftGridNum()
    if nLeftGridNum == 0 then
        MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT30)
    else
        local keyId = tData.id
        local otherKey 
        if self.m_nLeftTopIndex == 4 then
            keyId = tData.blessId
        elseif self.m_nLeftTopIndex == 3 then
            keyId = tData.playerPetId
            otherKey = tData.petSkinItemId
        elseif self.m_nLeftTopIndex == 2 then
            keyId = tData.playerItemId
        else
            keyId = tData.id 
        end

        if tData.lastNum == 1 then
            if self.m_nLeftTopIndex == 4 then
                self:clickPutIn(keyId, tData.item_id, tData.lastNum, otherKey)
            else
                self:clickPutIn(keyId, tData.id, tData.lastNum, otherKey)
            end
        else
            tData.winType = 5
            tData.itemIds = tData.id
            tData.keyId = keyId
            tData.otherKey = otherKey
            local tCostData = GDatatab_awake_extract["id_" .. tData.id]
            tData.cost = CopyTable(tCostData.cost)
            WndTransactionOperate:show(tData)
        end
    end
end

--@brief    点击放入回调
function WndExtraction:clickPutIn(id, itemId, num, otherKey)
    -- body
    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id == nil then
            self.m_tAppraiseList[i].id = id
            self.m_tAppraiseList[i].itemId = itemId
            self.m_tAppraiseList[i].num = num 
            self.m_tAppraiseList[i].otherKey = otherKey 
            self.m_tAppraiseList[i].tagInBag = self.m_nClickItemTag
            --宝物放入萃取栏，背包中相应的宝物的数量刷新
            self:_updateBagItemNum(1, i)
            break 
        end
    end

    --刷新待萃取列表
    self:_createAppraiseList()
end

--@brief    点击萃取按钮回调
function WndExtraction:onExractionClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self.m_bIsCanExtraction then 
        return 
    end

    local bIsHaveGood = false 
    local bIsHaveHightQuality = false 
    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id ~= nil then
            bIsHaveGood = true
            local basicInfo = GDatatab_item["id_" .. self.m_tAppraiseList[i].itemId]
            if basicInfo.quality >= 3 then
                bIsHaveHightQuality = true 

                break 
            end
        end
    end
    if not bIsHaveGood then
        MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT28)
        return 
    end

    if bIsHaveHightQuality then
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.CONTINUE_GAME}
        MsgBoxManager:showConfirmBoxWithBg(LocalStrings.WAKEUP_TEXT34, self, self.onClickSure, nil, tCustomUIConfig)
        return 
    end

    self:onClickSure(element)
end

--@brief    点击继续按钮回调
function WndExtraction:onClickSure(element)
    -- body
    --背包已满
    local nTempNum = 0
    local bPetHavePhantom = false 
    
    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id ~= nil then
            if self.m_nLeftTopIndex == 3 and self.m_tAppraiseList[i].otherKey and self.m_tAppraiseList[i].otherKey > 0 then
                bPetHavePhantom = true 
            end
            nTempNum = nTempNum + 1
        end
    end
    WZLog("WndExtraction:onClickSure", CacheCenter:getRemainAmount(), nTempNum)
    if CacheCenter:getRemainAmount() - nTempNum < 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    local tTempCost = self:_caculateTotalCost()

    for i = 1, #tTempCost do
        local bIsEnough = JudgeMoneyIsEnough(tTempCost[i][1], tTempCost[i][2], nil,nil,207)
        if not bIsEnough then
            return 
        end
    end
    
    WZLog("WndExtraction:onExractionClick", Serialize(self.m_tAppraiseList))
    if bPetHavePhantom then 
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.CONTINUE_GAME}
        MsgBoxManager:showConfirmBox(LocalStrings.PET_TEXT12, self, self.continueToExtranction, nil, tCustomUIConfig)
        return 
    end
    
    self:continueToExtranction()
end

--@brief    继续
function WndExtraction:continueToExtranction()
    -- body
    if not self.m_root:getChildByTag(888) then
        local img9Black = WZUI9Image:create()
        img9Black:setOpacity(0)
        img9Black:setFile("ui/common/common_black_bg.png")
        img9Black:setTag(888)
        self.m_root:addChild(img9Black)
    end
    
    local vId = WZLuaVector_int_:create()
    local vNum = WZLuaVector_int_:create()
    local vType = WZLuaVector_int_:create()

    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id ~= nil then
            vId:push(self.m_tAppraiseList[i].id)
            vNum:push(self.m_tAppraiseList[i].num)
            vType:push(self.m_nLeftTopIndex)
        end
    end
    --进行萃取
    self:_createLoading()
    self.m_bIsCanExtraction = false 
    ProtocolProcessorWakeup:send_AWAKE_Extract(vType, vId, vNum)
end

--@brief    点击+号按钮回调
function WndExtraction:onClickAdd(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    
    if WndItemInfo.m_root then return end 

    if self.m_tAppraiseList[nTag].id ~= nil then
        --放入背包，重新设置背包中相应宝物的数量
        self:_updateBagItemNum(2, nTag)
    else
        MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT29)
    end
end

--@brief    自动添加
function WndExtraction:onAutoAddClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self.m_bIsCanExtraction then return end

    local nLeftGridNum = self:_getLeftGridNum()
    if self.m_tBagList == nil or #self.m_tBagList == 0 then
        MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT32)
    elseif nLeftGridNum == 0 then
        MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT30)
        return 
    else
        if 6 - nLeftGridNum == #self.m_tBagList then
            MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT31)
            return 
        end
    end

    local bIsAllHightQuality = true 
    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id == nil then 
            for j = 1, #self.m_tBagList do 
                if self.m_tBagList[j].basicInfo.quality < 3 then
                    local keyId = self.m_tBagList[j].id 
                    local itemId = self.m_tBagList[j].id 
                    local otherKey 
                    if self.m_nLeftTopIndex == 4 then
                        keyId = self.m_tBagList[j].blessId
                        itemId = self.m_tBagList[j].item_id
                    elseif self.m_nLeftTopIndex == 3 then
                        keyId = self.m_tBagList[j].playerPetId
                        otherKey = self.m_tBagList[j].petSkinItemId
                    elseif self.m_nLeftTopIndex == 2 then
                        keyId = self.m_tBagList[j].playerItemId
                    end
                    local bIsAdd = false 
                    for k = 1, #self.m_tAppraiseList do
                        if self.m_tAppraiseList[k].id == keyId then
                            bIsAdd = true
                            break 
                        end
                    end

                    if not bIsAdd then
                        bIsAllHightQuality = false 
                        self.m_nClickItemTag = j - 1
                        self:clickPutIn(keyId, itemId, self.m_tBagList[j].lastNum, otherKey)
                        break 
                    end
                end
            end
        end
    end

    if bIsAllHightQuality then
        MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT33)
    end
end

--@brief    点击右边标签回调
function WndExtraction:onChangeGood(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    if self.m_nLeftTopIndex == nTag then return end 

    self.m_nLeftTopIndex = nTag 
    self:setData()
end

--@brief    触摸开始回调
function WndExtraction:onTouchBegin(element, pt)
    -- body
    if WndTips.m_root and not WndTips:checkPointInBtn(pt) then
        WndTips:_onCloseClick()
    end

    if WndItemInfo.m_root and not WndItemInfo:checkPoint(pt) then
        WndItemInfo:closeWin(element,pt)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function WndExtraction:_update()
    -- body
    self:_createBagList()
    self:_createAppraiseList()
end

--@brief    设置静态信息
function WndExtraction:_setStaticInfo()
    -- body
    local txtCostWord = GetElement(self.m_root, "txtCostWord_WndExtraction", WZUILabelTTF)
    if txtCostWord then
        txtCostWord:setText(LocalStrings.EXTRACTION_TEXT8 .. ":")
    end
    --萃取费用
    self:_updateCostNum()
end

--@brief    创建可萃取的物品列表
function WndExtraction:_createBagList()
    -- body
    local conBag = GetElement(self.m_root, "conBag_WndExtraction", WZUIContainer)
    local tableBagList = GetElement(self.m_root, "tableBagList_WndExtraction", WZUITableContainer)
    tableBagList:cleanTable()
    if #self.m_tBagList == 0 then
        ShowPanelNullTip(conBag, LocalStrings.EXTRACTION_TEXT7[self.m_nLeftTopIndex])
        return 
    end
    removeShowPanelNullTip(conBag)

    tableBagList:setLoadCountPerFrame(4)

    self.m_tCellList = {}
    for i = 1, #self.m_tBagList do
        if self.m_nLeftTopIndex == 4 then
            local cellElement, tNewObj = CellBlessItem:createElement()
            if cellElement and tNewObj then
                cellElement:setTag(i - 1)
                tNewObj:setCallBackFun(self, self.onAddForAppraise)
                tNewObj:setExtractionCallBackFun(self, self.onItemClick)
                tNewObj:setData(self.m_tBagList[i], 3, self.m_root)
                tNewObj:setExtraction(true)
                tableBagList:setCellElement(cellElement)

                table.insert(self.m_tCellList,tNewObj)
            end
        else
            local celElement, tNewObj = CellGoodItem:createElement()
            if celElement and tNewObj then
                celElement:setTag(i-1)
                tableBagList:setCellElement(celElement)
                celElement:setScale(0.9)
                tNewObj:setCellGoodItem(self.m_tBagList[i], 4)
                tNewObj:setItemClickFun(self,self.onItemClick)

                table.insert(self.m_tCellList,tNewObj)
            end
        end
    end
end

--@brief    创建待萃取列表
function WndExtraction:_createAppraiseList()
    -- body
    for i = 1, #self.m_tAppraiseList do
        local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndExtraction", WZUIContainer)
        if self.m_tAppraiseList[i].id ~= nil then
            if conItem:getChildByTag(999) then
                conItem:removeChildByTag(999, true)
            end
            if self.m_nLeftTopIndex == 4 then
                local cellElement, tNewObj = CellBlessItem:createElement()
                if cellElement and tNewObj then
                    cellElement:setTag(999)
                    conItem:addChild(cellElement)
                    local tTempData = self:_getBlessDataById(self.m_tAppraiseList[i].id)
                    tNewObj:setData(tTempData, 3, self.m_root)
                    cellElement:setScale(0.9)
                end
            else
                local celElement, tNewObj = CellGoodItem:createElement()
                if celElement and tNewObj then
                    celElement:setTag(999)
                    conItem:addChild(celElement)
                    local tTempItem = {}
                    local basicInfo = GDatatab_item["id_" .. self.m_tAppraiseList[i].itemId]
                    tTempItem.name = basicInfo.name 
                    tTempItem.icon = basicInfo.icon
                    tTempItem.id = self.m_tAppraiseList[i].itemId
                    tTempItem.lastNum = self.m_tAppraiseList[i].num
                    tTempItem.lastTime = self.m_tAppraiseList[i].num

                    tTempItem.quality = basicInfo.quality
                    tTempItem.basicInfo = CopyTable(basicInfo)

                    tNewObj:setCellGoodItem(tTempItem, 4)

                    table.insert(self.m_tCellList,tNewObj)
                end
            end
        else
            if conItem:getChildByTag(999) then
                conItem:removeChildByTag(999, true)
            end
        end
    end

    --刷新费用
    self:_updateCostNum()
end

--@brief    更新费用显示
function WndExtraction:_updateCostNum()
    -- body
    local tTempCost = self:_caculateTotalCost()
    GetElement(self.m_root, "conCost1_WndExtraction", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conCost2_WndExtraction", WZUIContainer):setVisible(false)

    for i = 1, #tTempCost do
        GetElement(self.m_root, "conCost" .. i .. "_WndExtraction", WZUIContainer):setVisible(true)
        local txtCost = GetElement(self.m_root, "txtCost" .. i .. "_WndExtraction", WZUILabelTTF)
        if txtCost then
            txtCost:setText(tTempCost[i][2])
        end
        local imgCostIcon = GetElement(self.m_root, "imgCostIcon" .. i .. "_WndExtraction", WZUIImage)
        if imgCostIcon then
            imgCostIcon:setFile(GDatatab_item["id_" .. tTempCost[i][1]].icon)
            imgCostIcon:setScale(0.5)
        end

    end
end

--@brief    当宝物放入或移出待萃取栏的时候，更新背包中相应的宝物的数量显示
--@param    nType:1->从背包放入待萃取栏；2->从萃取栏放回背包
--@param    nIndex:相应的待萃取数据索引
function WndExtraction:_updateBagItemNum(nType, nIndex)
    -- body
    if nType == 1 then
        --刷新背包中的数量
        if self.m_nLeftTopIndex == 4 then
            self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:setConGouVisible(true)
            self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:setConGrayBGVisible(true)
        else
            self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:setItemCount(self.m_tBagList[self.m_tAppraiseList[nIndex].tagInBag + 1].lastNum - self.m_tAppraiseList[nIndex].num)
            if self.m_tBagList[self.m_tAppraiseList[nIndex].tagInBag + 1].lastNum - self.m_tAppraiseList[nIndex].num == 0 then
                self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:_setItemVisible(false)
            else
                self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:_setItemVisible(true)
            end
            --勾号的选中状态
            self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:showSelectedIcon(2)
        end
    elseif nType == 2 then
        if self.m_nLeftTopIndex == 4 then
            self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:setConGouVisible(false)
            self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:setConGrayBGVisible(false)
        else
            self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:setItemCount(self.m_tBagList[self.m_tAppraiseList[nIndex].tagInBag + 1].lastNum)
            self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:_setItemVisible(true)
            --移除勾号的选中状态
            self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:removeGouIcon()
        end
        --移出掉萃取栏的宝物图标
        local conItem = GetElement(self.m_root, "conItem" .. nIndex .. "_WndExtraction", WZUIContainer)
        if conItem:getChildByTag(999) then
            conItem:removeChildByTag(999, true)
        end
        --清楚掉移出萃取栏的数据
        self.m_tAppraiseList[nIndex] = {}
        --刷新费用
        self:_updateCostNum()
    end
end
-------------------------------------私有方法模块End----------------------------------------
--@brief    点击详情按钮回调
function WndExtraction:onClickRule(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndWakeupcoinJump:showInterface()
end

--@brief	操作日志
function WndExtraction:onCheck1(element)
	WZLog("WndExtraction:onCheck1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	GetElement(self.m_root,"txtTitle",WZUILabelTTF):setText(LocalStrings.EXTRACTION_TEXT1)
	self.m_nType = 0

	GetElement(self.m_root,"imgTab1_WndExtraction",WZUI9Image):setVisible(true)
	GetElement(self.m_root,"imgTab2_WndExtraction",WZUI9Image):setVisible(false)

	GetElement(self.m_root,"txtTab1_WndExtraction",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"txtTab1Sel_WndExtraction",WZUILabelTTF):setVisible(true)
	GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF):setVisible(true)
	GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF):setVisible(false)

	GetElement(self.m_root,"conTab1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conTab11",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conSy",WZUIContainer):setVisible(false)
end

--@brief	捐献日志
function WndExtraction:onCheck2(element)
	WZLog("WndExtraction:onCheck2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	GetElement(self.m_root,"txtTitle",WZUILabelTTF):setText(LocalStrings.WAKEUP6)
	self.m_nType = 1

	GetElement(self.m_root,"imgTab1_WndExtraction",WZUI9Image):setVisible(false)
	GetElement(self.m_root,"imgTab2_WndExtraction",WZUI9Image):setVisible(true)

	GetElement(self.m_root,"txtTab1_WndExtraction",WZUILabelTTF):setVisible(true)
	GetElement(self.m_root,"txtTab1Sel_WndExtraction",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF):setVisible(true)

	GetElement(self.m_root,"conTab1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab11",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conSy",WZUIContainer):setVisible(true)
end

-------------------------------------合成右边部分Start----------------------------------------
function WndExtraction:_updateTab2() 
	self:updateRightList()
end

--@brief	更新右侧界面
function WndExtraction:updateRightList()
	WZLog("WndExtraction:updateRightList")

    if CacheCenter:hasPlayerItems() ~= true then return end

    self.m_tItemDataList = CacheCenter:getWakeupSyntheticMaterialList()
    self:_updateItemList()
end

--@brief	更新玩家物品数据
--@note		从CacheCenter更新玩家数据
function WndExtraction:updatePlayerItemData()
	WZLog("WndExtraction:updatePlayerItemData")
	if self.m_root == nil then return end

	self:updateRightList()

	WZLog("上次合成的物品tag",WndExtraction.m_nTag)
	if WndExtraction.m_tData ~= nil then
		WZLog("上次合成的物品名字",WndExtraction.m_tData.basicInfo.name)
	end
	if WndExtraction.m_nTag ~= nil and WndExtraction.m_tData ~= nil then
		WndExtraction:_putItem(WndExtraction.m_nTag, WndExtraction.m_tData, nil, false, true)
	end
end

--@brief    更新列表
--@param    tbcon，WZUITableContainer元素节点
--@param    tDataList， 数据表
--@param    fSetCellData，设置单元格数据回调方法
function WndExtraction:_updateItemList()
    if self.m_tItemDataList == nil then return end
    self.m_tItemObjList = {}

	local tDataList = self.m_tItemDataList
    local tbconList = GetElement(self.m_root, "tableCon_WndExtraction", WZUITableContainer)

    local nCurPositionY = tbconList:getMoveElement():getPositionY()
    local tLastSize = tbconList:getMoveElement():getContentSize()

    local nMinCellCount = 20
    tbconList:cleanTable()
    for i=1, math.min(#tDataList, nMinCellCount) do
    	local eItem, tItem = CellWakeupSy:createElement()
		eItem:setTag(i-1)
        --eItem:setScale(0.9)
        tbconList:setCellElement(eItem)
        tItem:setCellGoodItem(tDataList[i], 10)
        --if i > #tDataList then
        --    eItem:setTouchEnable(false)
        --end
        --tItem:setItemClickFun(self, self.onClickListItem)
        table.insert(self.m_tItemObjList, i, tItem)
    end

    --重新设置列表的位置
    local tCurSize = tbconList:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > tbconList:getMaxPosition().y then
        nTempPositionY = tbconList:getMaxPosition().y
    end
    tbconList:getMoveElement():setPositionY(nTempPositionY)
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndExtraction:onClickListItem(tItem, nTag, tData)
    WZLog("WndExtraction:onClickListItem")
    WndItemInfo:onCloseClick()
	self.m_nTag = nTag
	self.m_tData = tData
    if self.m_tPutItem and self.m_tPutItem:getFromTag() == nTag then
        --点击的材料已经放上去时显示卸下tip窗口
        --self:_showDisboardItemTipWindow(tItem, nTag, tData)
		WndExtraction:btnDisboardCallback()
    else
        --self:_showMergeItemTipWindow(tItem, nTag, tData)
		WndExtraction:btnMergeCallback()
    end
end

--@brief    显示带合成按钮的物品tip窗口
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndExtraction:_showMergeItemTipWindow(tItem, nTag, tData)
    tData.tBtnList = {LocalStrings.SYNTHESIS}
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,nil,nil,nil,nil,nTag)
    WndItemInfo:setClickButtonCallback(self,self.btnMergeCallback)
	self.m_nTag = nTag
	self.m_tData = tData
end

--@brief	点击合成按钮回调
function WndExtraction:btnMergeCallback()
	WZLog("WndExtraction:btnMergeCallback",self.m_nTag)
	WndExtraction.m_nMergeNum = nil
    WndExtraction:_putItem(self.m_nTag,self.m_tData)
    --重置快速合成
	--WndExtraction.m_bQuick = false
    --local selQuick = GetElement(WndExtraction.m_root, "selCheckBox_WndExtraction", WZUICheckBox)
    --selQuick:setCheckIndex(0)

    WndItemInfo:onCloseClick()
end

--@brief    显示带卸下按钮的物品tip窗口
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndExtraction:_showDisboardItemTipWindow(tItem, nTag, tData)
    tData.tBtnList = {LocalStrings.UNROYAL}
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData)
    WndItemInfo:setClickButtonCallback(self,self.btnDisboardCallback)
end

--@brief	点击卸下按钮回调
function WndExtraction:btnDisboardCallback()
	WZLog("WndExtraction:btnDisboardCallback",self.m_nTag)
	WndExtraction.m_nMergeNum = nil
	GetElement(WndExtraction.m_root,"useNum_WndExtraction",WZUILabelTTF):setText(1)
    WndExtraction:_clearPutItem()
    --重置快速合成
	--WndExtraction.m_bQuick = false
    --local selQuick = GetElement(WndExtraction.m_root, "selCheckBox_WndExtraction", WZUICheckBox)
    --selQuick:setCheckIndex(0)

    WndItemInfo:onCloseClick()
end

--@brief    根据序号获取物品绑定的lua对象
--@param    nTag:序号
--@return   #1:物品绑定的lua对象
function WndExtraction:_getItemByTag(nTag)
	WZLog("WndExtraction:_getItemByTag",nTag,self.m_nSelectedIndex)
    if nTag == nil then return end

    if self.m_tItemObjList then
        return self.m_tItemObjList[nTag+1]
    end
end

--@brief	根据playerItemId获得物品数据表
function WndExtraction:_getItemByPlayerItemId(playerItemId)
	WZLog("WndExtraction:_getItemByPlayerItemId")
	if playerItemId == nil then return end

	for i=1,#self.m_tItemDataList do
		if self.m_tItemDataList[i].playerItemId == playerItemId then
			return self.m_tItemDataList[i]
		end
	end
end
-------------------------------------合成右边部分End----------------------------------------

-------------------------------------合成左边部分Start----------------------------------------
--@brief    摆放物品
--@param    nTag:序号   用来取右侧的格子
--@param    tData:物品数据表
--@param    bQuick:是否是快速合成
--@param    clearItem:是否需要返回物品
--@param    reset:是否是重新放置的物品
function WndExtraction:_putItem(nTag, tData, bQuick, clearItem, reset)
	--WZLog("WndExtraction:_putItem",nTag,bQuick)
	bQuick = self.m_bQuick
	self.m_nTag = nTag
	self.m_tData = tData
    local tItem = WndExtraction:_getItemByTag(nTag)
	if tItem == nil then return end
	if tData == nil then return end
	if tItem.m_tItem == nil then return end
	if self.m_root == nil then return end
	if self.m_root:isVisible() == false then return end
	--WZLog("右侧格子里的数据是",Serialize(tItem.m_tItem))
	--上次合成的物品和这次放置的物品不是同样的，返回
	if tItem.m_tItem.playerItemId ~= tData.playerItemId then
   		WndExtraction:_clearPutItem()
		return
	end
	local reset = reset or false
	local clearItem = clearItem or true
	--清空左侧，还原右侧
   	WndExtraction:_clearPutItem()

	--localData表数据
    self.m_tMergeInfo = GDatatab_itemmerge["id_"..tData.id]
    if self.m_tMergeInfo == nil then
        --提示错误信息:查找合成数据失败
        MsgBoxManager:showTipBox(LocalStrings.CANNOT_FIND_SYNTHESIS_DATA)
        return
    end

	--获得快速合成的物品数据
	local tDataCell = WndExtraction:_getItemByPlayerItemId(tData.playerItemId)
    local nScrapCount =  self.m_tMergeInfo.scrap[1][2]
	--WZLog("wtf******",Serialize(tDataCell))
    if tDataCell == nil or nScrapCount > tDataCell.lastNum then
        --提示错误信息:合成材料不足
		if reset == false then
        	MsgBoxManager:showTipBox(LocalStrings.CAN_NOT_MATERIALS)
		end
        return
    end
    
    local n = 1 --合成次数，不开启快速合成时为1
    local tPutItemData = CopyTable(tDataCell)
    if bQuick == true then
		self.m_nMergeMax = math.floor(tDataCell.lastNum/nScrapCount)
		if self.m_nMergeNum == nil then self.m_nMergeNum = self.m_nMergeMax end
        n = self.m_nMergeNum
    end
    
	WZLog("快速合成数量",n)
	--设置右侧物品减去材料后的数量
    local tItem = WndExtraction:_getItemByTag(nTag)
	if tItem.m_tItem.lastNum-nScrapCount*n == 0 then
		tItem:removeAllChild()
	else
    	WndExtraction:_updateGoodItemWithNumber(tItem, tItem.m_tItem.lastNum-nScrapCount*n)
	end
    
	--显示放置的材料
    tPutItemData.lastNum = self.m_tMergeInfo.scrap[1][2]*n
    local ePutItem, tPutItem = self:_createCellGoodItem(nTag)
    tPutItem:setCellGoodItem(tPutItemData, 10)
    tPutItem:setItemClickFun(self, self.onClickPutItem)
    local conMix1 = GetElement(self.m_root, "conMix1_WndExtraction")
    conMix1:addChild(ePutItem)
    --Add By Tianxiang_Xu
    --当选中快速合成时，显示合成消耗的数量
    if bQuick == true then 
        WndExtraction:_updateGoodItemWithNumber(tPutItem, nScrapCount*n)
    end
    --End Add 
    self.m_tPutItem = tPutItem

    local tResultInfo = self.m_tMergeInfo.items[1]
    local tResultItemData = {
        id = tResultInfo[1],
        lastNum = tResultInfo[2]*n,
        lastTime = tResultInfo[2]*n,
        isUse = false,
        data = "",
        playerItemId = -1,
        basicInfo = GetItemLocalData(tResultInfo[1])
    }
	--显示合成后的物品
    local eResultItem, tResultItem = self:_createCellGoodItem(9999)
    tResultItem:setCellGoodItem(tResultItemData, 10)
    tResultItem:setItemClickFun(self, self.onClickResultItem)
    local conMix2 = GetElement(self.m_root, "conMix2_WndExtraction")
    conMix2:addChild(eResultItem)
    self.m_tResultItem = tResultItem
    
    WndExtraction:_updateCurrency(n) --显示合成货币消耗信息
	GetElement(self.m_root,"useNum_WndExtraction",WZUILabelTTF):setText(n)
    
	--显示特效
	GetElement(self.m_root,"armature_WndExtraction",WZArmature):setVisible(true)
end

--@brief    创建一个物品格子
--@param    nTag，序号
function WndExtraction:_createCellGoodItem(nTag)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setTag(nTag)
    tItem:setFromTag(nTag)
    return eItem, tItem
end

--@brief    清除已摆放的物品,刷新右侧物品
--@param    bQuick:快速合成是否开启
function WndExtraction:_clearPutItem(bQuick)
	--WZLog("WndExtraction:_clearPutItem",bQuick)
    if self.m_root == nil then return end
    --删除碎片材料节点
    if self.m_tPutItem ~= nil then
        self.m_tPutItem.m_root:removeFromParentAndCleanup(true)
        self.m_tPutItem = nil
    end

    --删除合成结果节点
    if self.m_tResultItem ~= nil then
        self.m_tResultItem.m_root:removeFromParentAndCleanup(true)
        self.m_tResultItem = nil
    end

    --清除货币信息
    local imgCurrency = GetElement(self.m_root, "imgCost_WndExtraction", WZUIImage)
    imgCurrency:setFile("")
    local txtCurrency = GetElement(self.m_root, "txtValue_WndExtraction", WZUILabelTTF)
    txtCurrency:setText("")

    self.m_tMergeInfo = nil

	--隐藏特效
	GetElement(self.m_root,"armature_WndExtraction",WZArmature):setVisible(false)

	--刷新右边界面
	WndExtraction:updateRightList()
end

--@brief    更新物品数量信息
--@param    tItem:物品绑定的lua对象
--@param    nNumber:数量
function WndExtraction:_updateGoodItemWithNumber(tItem, nNumber)
		WZLog("WndExtraction:_updateGoodItemWithNumber", nNumber)
    if tItem == nil then
        return
    end
    --WZLog("WndExtraction:_updateGoodItemWithNumber", nNumber)
    local tData = tItem.m_tItem
    if tData ~= nil and tData.lastNum == 0 and  nNumber > 0 then
        tItem:setQuality(tData.basicInfo.quality)
        tItem:setConItemVisible(true)
        tItem.m_root:setTouchEnable(true)
    end
    tItem:setItemNumber(nNumber)
	tItem:setHighLight(true)
    if nNumber == 0 then
        tItem:setQuality(0)
        tItem:setConItemVisible(false)
        tItem.m_root:setTouchEnable(false)
    end
end

--@brief    更新货币信息
function WndExtraction:_updateCurrency(nMultiple)
    if self.m_tMergeInfo == nil then
        return
    end
    local nCurrencyId = self.m_tMergeInfo.cost[1][1]
    local nCurrencyCount = self.m_tMergeInfo.cost[1][2]*nMultiple
    local tCurrency = GetItemLocalData(nCurrencyId)
	self.m_nMId = nCurrencyId

    if tCurrency then
        local imgCurrency = GetElement(self.m_root, "imgCost_WndExtraction", WZUIImage)
        imgCurrency:setFile(tCurrency.icon)
		imgCurrency:setScale(0.5)
    end
    local txtCurrency = GetElement(self.m_root, "txtValue_WndExtraction", WZUILabelTTF)
    txtCurrency:setText(nCurrencyCount)
end

--@brief	点击快速合成按钮后的回调
--@param	element:按钮绑定的UI节点引用
--@note		刷新右边界面,放上最多的材料
function WndExtraction:onQuick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --检查VIP等级
    local cb = WZUICheckBox:luaTo(element)

    if CacheCenter:getPlayerInfo().vipLevel < 3 then
    	local sMsg = string.format(LocalStrings.MULTI_SWEEP_TIP, 3)
        MsgBoxManager:showConfirmCancelBox(sMsg, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
    	cb:setCheckIndex(0)
		self.m_bQuick = false
		return
	end

    if self.m_tPutItem == nil then
        --提示错误信息:请放置材料
        MsgBoxManager:showTipBox(LocalStrings.PUT_SYNTHESIS_MATERIAL)
        --cb:setCheckIndex(0)
		--self.m_bQuick = false
        return
    end
	
	if self.m_bQuick == nil then self.m_bQuick = false end
	self.m_nMergeNum = nil
	self.m_nMergeMax = nil

	self.m_bQuick = not self.m_bQuick

    local nTag = self.m_tPutItem:getFromTag()
	--刷新右边界面
	WndExtraction:updateRightList()
	--获得快速合成的物品数据
	local tData = WndExtraction:_getItemByPlayerItemId(self.m_tPutItem.m_tItem.playerItemId)
    --local tData = WndExtraction:_getItemByTag(nTag).m_tItem
	--放置材料
    self:_putItem(nTag, tData, self.m_bQuick)
end

--@brief	提示充值框的回调
--@param	nId:消息id
--@param	nResType:响应类型(超时，确定，取消)
function WndExtraction:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
    end
end

--@brief	合成成功后的回调
--@note     由协议层回调
function WndExtraction:synthesisSuccess()
	--MsgBoxManager:showTipBox("协议返回花费时间"..(WZThread:getUTickCount()-self.startTime))
	GetElement(self.m_root,"armature1_WndExtraction",WZArmature):setVisible(true)
	GetElement(self.m_root,"armature1_WndExtraction",WZArmature):play("0")
	self.m_root:enableSchedule("hideArm",1)

	WZLog("合成结果",Serialize(self.m_tSuccessItemInfo))
	if self.m_tSuccessItemInfo ~= nil then
		WndRewardShow:showById({self.m_tSuccessItemInfo.id},{self.m_tSuccessItemInfo.count})
	end
    pushEquipInList()
    g_bIsShowWndDressUp = true

	--清除左侧界面
	self:_clearPutItem()

    --重置快速合成
	--self.m_bQuick = false
    --local selQuick = GetElement(self.m_root, "selCheckBox_WndSynthesis", WZUICheckBox)
    --selQuick:setCheckIndex(0)
end

function WndExtraction:hideArm() 
	self.m_root:disableSchedule()
	GetElement(self.m_root,"armature1_WndExtraction",WZArmature):setVisible(false)
end

--@brief	点击合成按钮后的回调
--@param	element:按钮绑定的UI节点引用
function WndExtraction:onSynthesis(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tPutItem == nil then
		MsgBoxManager:showTipBox(LocalStrings.PUT_SYNTHESIS_MATERIAL)
		return
    end
	--记录合成结果
    if self.m_tResultItem then
        self.m_tSuccessItemInfo = {}
        self.m_tSuccessItemInfo.id = self.m_tResultItem.m_tItem.id
        self.m_tSuccessItemInfo.count = self.m_tResultItem.m_tItem.lastNum
    end

    local nTag = self.m_tPutItem:getFromTag()
    local tData = self.m_tPutItem.m_tItem
    --判断金币是否足够
    local txtCurrency = GetElement(self.m_root, "txtValue_WndExtraction", WZUILabelTTF)
	local needGold = tonumber(txtCurrency:getText())
    local playerGold = CacheCenter:getMoneyList().gold
	if self.m_nMId == 2 then
    	if needGold > playerGold then
    	    MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil, nil)
    	    return
    	end
	else
		if needGold > CacheCenter:getPlayerItemCountById(self.m_nMId) then
				local limitLeave = -1
				--判断物品是否限购
				CacheCenter:getShopItems(function(t,shopItemList)
					for k,v in pairs(shopItemList)	do
						if v.shopItemId == self.m_nMId and v.isOnSale == true then
							limitLeave = v.limitLeave
							break
						end
					end
				end)
				WZLog("限购数"..limitLeave)
				if limitLeave == -1 then
					--不限购
					checkIsOnSale(self.m_nMId)	
				--elseif limitLeave == 0 then
					--限购且购买次数已经用完
					--MsgBoxManager:showTipBox(LocalStrings.PETNOGOODS)
				else
					--限购且购买次数没有用完
					checkIsOnSale(self.m_nMId)	
				end
			return
		end
	end
    
    local selCheckBox = GetElement(self.m_root, "selCheckBox_WndExtraction", WZUICheckBox)
    local bIsFast = false
    if selCheckBox:getCheckIndex() == 1 then
        bIsFast = true
    end

    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}

	local mergeType = {1,2,0,0,4} 
	--self.startTime = WZThread:getUTickCount()
	WZLog("发送合成协议",tData.playerItemId, bIsFast, 0, self.m_nMergeNum)

	if bIsFast == true then
    	ProtocolProcessorMerge:send_MERGE_MergeItem(tData.playerItemId, bIsFast, 0, self.m_nMergeNum)
	else
    	ProtocolProcessorMerge:send_MERGE_MergeItem(tData.playerItemId, bIsFast, 0, 1)
	end
end

--@brief    快速购买金币框
--@param    nResType:响应类型(超时，确定，取消)
function WndExtraction:buyGold(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(26)
    end
end

--@brief	点击已摆放物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndExtraction:onClickPutItem(tItem, nTag, tData)
    WndItemInfo:onCloseClick()
	WndExtraction:_showDisboardItemTipWindow(tItem, nTag, tData)
end

--@brief	点击合成结果物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndExtraction:onClickResultItem(tItem, nTag, tData)
    WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tItem.m_root,WndExtraction.m_root,1,tData, false)
end

function WndExtraction:onMutiAdd()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self:checkQuick() then return end
	self.m_nMergeNum = math.min(self.m_nMergeMax, self.m_nMergeNum + 10)
	self:putQuickItem()
end

function WndExtraction:onMutiReduce()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self:checkQuick() then return end
	self.m_nMergeNum = math.max(1, self.m_nMergeNum - 10)
	self:putQuickItem()
end

function WndExtraction:onAdd()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self:checkQuick() then return end
	self.m_nMergeNum = math.min(self.m_nMergeMax, self.m_nMergeNum + 1)
	self:putQuickItem()
end

function WndExtraction:onReduce()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self:checkQuick() then return end
	self.m_nMergeNum = math.max(1, self.m_nMergeNum - 1)
	self:putQuickItem()
end

function WndExtraction:putQuickItem()
	WZLog("WndExtraction:putQuickItem")
    local nTag = self.m_tPutItem:getFromTag()
	--刷新右边界面
	WndExtraction:updateRightList()
	--获得快速合成的物品数据
	local tData = WndExtraction:_getItemByPlayerItemId(self.m_tPutItem.m_tItem.playerItemId)
	--放置材料
    self:_putItem(nTag, tData, self.m_bQuick)
end

function WndExtraction:checkQuick()
	WZLog("WndExtraction:checkQuick")
    if CacheCenter:getPlayerInfo().vipLevel < 3 then
    	local sMsg = string.format(LocalStrings.MULTI_SWEEP_TIP, 3)
        MsgBoxManager:showConfirmCancelBox(sMsg, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
		self.m_bQuick = false
		return false
	end

    if self.m_tPutItem == nil then
        --提示错误信息:请放置材料
        MsgBoxManager:showTipBox(LocalStrings.PUT_SYNTHESIS_MATERIAL)
        return false
    end

	if self.m_bQuick ~= true then
        --提示勾选快速合成
        MsgBoxManager:showTipBox(LocalStrings.BAGTIP46)
		return false
	end

	if self.m_nMergeNum == nil or self.m_nMergeMax == nil then
		WZLog("WndExtraction:checkQuick  初始化失败")
		return false
	end

	return true
end

function WndExtraction:onTouchEnd()
    --重置快速合成
    local selQuick = GetElement(self.m_root, "selCheckBox_WndExtraction", WZUICheckBox)
	if self.m_bQuick then
    	selQuick:setCheckIndex(1)
	else
    	selQuick:setCheckIndex(0)
	end
end

function WndExtraction:_moreLanguage()
    GetElement(self.m_root,"txtRapid_WndExtraction",WZUILabelTTF):setText(LocalStrings.BAGTIP13)
    GetElement(self.m_root,"txtVIPRapid_WndExtraction",WZUILabelTTF):setText(LocalStrings.BAGTIP14)
    GetElement(self.m_root,"cost_WndExtraction",WZUILabelTTF):setText(LocalStrings.BAGTIP15)
end
-------------------------------------合成左边部分End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndExtraction:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtBless1_WndExtraction",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtBless2_WndExtraction",WZUILabelTTF):setFontSize(18)

    local txtTab2 = GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF)
    txtTab2:setScale(0.6)
    txtTab2:setDimensions(GlobalMethod:CCSize(120))
    local txtTab2Sel = GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF)
    txtTab2Sel:setScale(0.6)
    txtTab2Sel:setDimensions(GlobalMethod:CCSize(120))
end

function WndExtraction:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtPet1_WndExtraction",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"txtPet2_WndExtraction",WZUILabelTTF):setScale(0.9)

    GetElement(self.m_root,"txtBtn1_WndExtraction",WZUILabelTTF):setScale(0.8)

    local txtCostWord = GetElement(self.m_root, "txtCostWord_WndExtraction", WZUILabelTTF)
    txtCostWord:setScale(0.8)
    txtCostWord:setDimensions(GlobalMethod:CCSize(80))
end

function WndExtraction:_adaptLanguage_en(  )
    local txtBtn1 = GetElement(self.m_root,"txtBtn1_WndExtraction",WZUILabelTTF)
    txtBtn1:setScale(0.7)
    txtBtn1:setDimensions(GlobalMethod:CCSize(120))

    local txtTab2 = GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF)
    txtTab2:setScale(0.6)
    txtTab2:setDimensions(GlobalMethod:CCSize(120))
    local txtTab2Sel = GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF)
    txtTab2Sel:setScale(0.6)
    txtTab2Sel:setDimensions(GlobalMethod:CCSize(120))

    local txtCostWord = GetElement(self.m_root, "txtCostWord_WndExtraction", WZUILabelTTF)
    txtCostWord:setScale(0.8)
    txtCostWord:setDimensions(GlobalMethod:CCSize(100,0))
end

function WndExtraction:_adaptLanguage_pt(  )
    local txtBtn1 = GetElement(self.m_root,"txtBtn1_WndExtraction",WZUILabelTTF)
    txtBtn1:setScale(0.7)
    txtBtn1:setDimensions(GlobalMethod:CCSize(120,0))

    local txtCostWord = GetElement(self.m_root, "txtCostWord_WndExtraction", WZUILabelTTF)
    txtCostWord:setScale(0.8)
    txtCostWord:setDimensions(GlobalMethod:CCSize(100,0))

    local txtTab2 = GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF)
    txtTab2:setScale(0.6)
    txtTab2:setDimensions(GlobalMethod:CCSize(120))
    local txtTab2Sel = GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF)
    txtTab2Sel:setScale(0.6)
    txtTab2Sel:setDimensions(GlobalMethod:CCSize(120))

    GetElement(self.m_root,"txtTab1_WndExtraction",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtTab1Sel_WndExtraction",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtVIPRapid_WndExtraction",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"imgCost_WndExtraction",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    GetElement(self.m_root,"txtValue_WndExtraction",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.63,0.5))
end

function WndExtraction:_adaptLanguage_es(  )
    local txtBtn1 = GetElement(self.m_root,"txtBtn1_WndExtraction",WZUILabelTTF)
    txtBtn1:setScale(0.7)
    txtBtn1:setDimensions(GlobalMethod:CCSize(120,0))

    local txtCostWord = GetElement(self.m_root, "txtCostWord_WndExtraction", WZUILabelTTF)
    txtCostWord:setScale(0.8)
    txtCostWord:setDimensions(GlobalMethod:CCSize(100,0))

    local txtTab2 = GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF)
    txtTab2:setScale(0.55)
    txtTab2:setDimensions(GlobalMethod:CCSize(160))
    local txtTab2Sel = GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF)
    txtTab2Sel:setScale(0.55)
    txtTab2Sel:setDimensions(GlobalMethod:CCSize(160))

    GetElement(self.m_root,"txtTab1_WndExtraction",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtTab1Sel_WndExtraction",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtVIPRapid_WndExtraction",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"imgCost_WndExtraction",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.6,0.5))
    GetElement(self.m_root,"txtValue_WndExtraction",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.67,0.5))
    GetElement(self.m_root,"txtPet2_WndExtraction",WZUILabelTTF):setFontSize(20)
end

function WndExtraction:_adaptLanguage_tr(  )
    local txtBtn1 = GetElement(self.m_root,"txtBtn1_WndExtraction",WZUILabelTTF)
    txtBtn1:setScale(0.7)
    txtBtn1:setDimensions(GlobalMethod:CCSize(120,0))

    local txtCostWord = GetElement(self.m_root, "txtCostWord_WndExtraction", WZUILabelTTF)
    txtCostWord:setScale(0.8)
    txtCostWord:setDimensions(GlobalMethod:CCSize(100,0))

    local txtTab2 = GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF)
    txtTab2:setScale(0.6)
    txtTab2:setDimensions(GlobalMethod:CCSize(120))
    local txtTab2Sel = GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF)
    txtTab2Sel:setScale(0.6)
    txtTab2Sel:setDimensions(GlobalMethod:CCSize(120))

    GetElement(self.m_root,"txtVIPRapid_WndExtraction",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"imgCost_WndExtraction",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    GetElement(self.m_root,"txtValue_WndExtraction",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.63,0.5))

    local txtRune1 = GetElement(self.m_root,"txtRune1_WndExtraction",WZUILabelTTF)
    txtRune1:setScale(0.8)
    txtRune1:setDimensions(GlobalMethod:CCSize(80,0))
    
    local txtRune2 = GetElement(self.m_root,"txtRune2_WndExtraction",WZUILabelTTF)
    txtRune2:setScale(0.8)
    txtRune2:setDimensions(GlobalMethod:CCSize(80,0))

    GetElement(self.m_root,"txtEquip1_WndExtraction",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtEquip2_WndExtraction",WZUILabelTTF):setScale(0.7)
end
-------------------------------------语言适配End--------------------------------------------