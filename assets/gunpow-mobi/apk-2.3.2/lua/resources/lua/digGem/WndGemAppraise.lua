--WndGemAppraise.lua
--@brief	WndGemAppraise的UI模块
--@date		2017/03/15
--@author	Tianxiang_Xu
--@note		宝物鉴定界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGemAppraise:onEnter(element)
	self.m_root = element
    ChangeChatChannel(Chat_Channel_DigGem_Appraise)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGemAppraise:onExit(element)
	self:_unInit()
end

--@brief    加载界面完成回调
function WndGemAppraise:onEnterTransitionDidFinish(element)
    -- body
    self:setSpineAni()
    self:_setStaticInfo()

    self:setData(WndDigGem.m_tBagList)
    AdaptLanguage(self)
end

--@brief    关闭按钮回调
function WndGemAppraise:onCloseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击物品回调
function WndGemAppraise:onItemClick(tItem, nTag, tData)
    -- body
    --检查点击的宝物是否已经被放入鉴定栏，是则从鉴定栏移除
    local bInAppraise = false
    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id ~= nil and self.m_tAppraiseList[i].id == tData.id then
            if self.m_tAppraiseList[i].tagInBag == nTag then
                bInAppraise = true
                --宝物已经在鉴定栏，放回背包
                self:_updateBagItemNum(2, i)
                break 
            end
        end
    end

    if bInAppraise then
        return 
    end

    tData.tBtnList = {LocalStrings.DIGGEM_TEXT32}
    self.m_nClickItemTag = nTag
    
    WndItemInfo:showInfo(tItem.m_root,WndGemAppraise.m_root,1,tData)
    WndItemInfo:setClickButtonCallback(self,self.onAddForAppraise)
end

--@brief    点击物品tips鉴定按钮回调
function WndGemAppraise:onAddForAppraise(tag, tData)
    WZLog("WndGemAppraise:onAddForAppraise")
    local nLeftGridNum = self:_getLeftGridNum()
    if nLeftGridNum == 0 then
        MsgBoxManager:showTipBox(LocalStrings.DIGGEM_TEXT40)
    else
        if tData.lastNum == 1 then
            self:clickPutIn(tData.id, tData.lastNum)
        else
            tData.winType = 4
            tData.itemIds = tData.id
            WndTransactionOperate:show(tData)
        end
    end
end

--@brief    点击放入回调
function WndGemAppraise:clickPutIn(id, num)
    -- body
    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id == nil then
            self.m_tAppraiseList[i].id = id
            self.m_tAppraiseList[i].num = num 
            self.m_tAppraiseList[i].tagInBag = self.m_nClickItemTag
            --宝物放入鉴定栏，背包中相应的宝物的数量刷新
            self:_updateBagItemNum(1, i)
            break 
        end
    end

    --刷新待鉴定列表
    self:_createAppraiseList()
end

function WndGemAppraise:onSelect(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    for i = 1, #self.m_tBagList do
		local tData = self.m_tBagList[i]
		--属于快速选择物品，未被选中
		if ((tData.basicInfo.id >= 410 and tData.basicInfo.id <= 416) or (tData.basicInfo.id >= 2155 and tData.basicInfo.id <= 2160)) and self.m_tCellList[i].m_sell == nil then
    		for j = 1, #self.m_tAppraiseList do
    		    if self.m_tAppraiseList[j].id == nil then
    		        self.m_tAppraiseList[j].id = tData.basicInfo.id
    		        self.m_tAppraiseList[j].num = tData.lastNum
    		        self.m_tAppraiseList[j].tagInBag = i - 1
    		        --宝物放入鉴定栏，背包中相应的宝物的数量刷新
    		        self:_updateBagItemNum(1, j)
    		        break 
    		    end
    		end
		end
	end

    --刷新待鉴定列表
    self:_createAppraiseList()
end

--@brief    点击鉴定按钮回调
function WndGemAppraise:onAppraiseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local vId = WZLuaVector_int_:create()
    local vNum = WZLuaVector_int_:create()
    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id ~= nil then
            vId:push(self.m_tAppraiseList[i].id)
            vNum:push(self.m_tAppraiseList[i].num)
        end
    end
    if vId:size() == 0 then
        MsgBoxManager:showTipBox(LocalStrings.DIGGEM_TEXT33)
        return 
    end
    if CacheCenter:getMoneyList().gemCoin < self.m_nTotalCost then
        JudgeMoneyIsEnough(58, self.m_nTotalCost,nil,nil,196)
        return 
    end
    --进行鉴定
    ProtocolProcessorDigGem:send_MINING_Authenticate(vId, vNum)
end

--@brief    点击+号按钮回调
function WndGemAppraise:onClickAdd(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    
    if WndItemInfo.m_root then return end 

    if self.m_tAppraiseList[nTag].id ~= nil then
        --放入背包，重新设置背包中相应宝物的数量
        self:_updateBagItemNum(2, nTag)
    else
        MsgBoxManager:showTipBox(LocalStrings.DIGGEM_TEXT37)
    end

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function WndGemAppraise:_update()
    -- body
    self:_createBagList()
    self:_createAppraiseList()
end

--@brief    设置静态信息
function WndGemAppraise:_setStaticInfo()
    -- body
    --鉴定费用图标
    local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndGemAppraise", WZUIImage)
    if imgCostIcon then
        local basicInfo = GDatatab_item["id_58"]
        imgCostIcon:setFile(basicInfo.icon)
    end
    --鉴定费用
    self:_updateCostNum()
end

--@brief    创建可鉴定的物品列表
function WndGemAppraise:_createBagList()
    -- body
    local conBag = GetElement(self.m_root, "conBag_WndGemAppraise", WZUIContainer)
    local tableBagList = GetElement(self.m_root, "tableBagList_WndGemAppraise", WZUITableContainer)
    tableBagList:cleanTable()
    if self.m_tBagList and #self.m_tBagList == 0 then
        if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" 
            or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
            ShowPanelNullTip(conBag, LocalStrings.DIGGEM_TEXT41,nil,nil,16)
        else
            ShowPanelNullTip(conBag, LocalStrings.DIGGEM_TEXT41)
        end

        return 
    end
    removeShowPanelNullTip(conBag)

    tableBagList:setLoadCountPerFrame(3)

    self.m_tCellList = {}
    for i = 1, #self.m_tBagList do
        local celElement, tNewObj = CellGoodItem:createElement()
        if celElement and tNewObj then
            celElement:setTag(i-1)
            tableBagList:setCellElement(celElement)
            celElement:setScale(0.9)
            tNewObj:setCellGoodItem(self.m_tBagList[i], 2)
            tNewObj:setItemClickFun(self,self.onItemClick)

            table.insert(self.m_tCellList,tNewObj)
        end
    end
end

--@brief    创建待鉴定列表
function WndGemAppraise:_createAppraiseList()
    -- body
    for i = 1, #self.m_tAppraiseList do
        local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndGemAppraise", WZUIContainer)
        if self.m_tAppraiseList[i].id ~= nil then
            if conItem:getChildByTag(999) then
                conItem:removeChildByTag(999, true)
            end
            local celElement, tNewObj = CellGoodItem:createElement()
            if celElement and tNewObj then
                celElement:setTag(999)
                conItem:addChild(celElement)
                local tTempItem = {}
                local basicInfo = GDatatab_item["id_" .. self.m_tAppraiseList[i].id]
                tTempItem.name = basicInfo.name 
                tTempItem.icon = basicInfo.icon
                tTempItem.id = self.m_tAppraiseList[i].id
                tTempItem.lastNum = self.m_tAppraiseList[i].num
                tTempItem.lastTime = self.m_tAppraiseList[i].num

                tTempItem.quality = basicInfo.quality
                tTempItem.basicInfo = CopyTable(basicInfo)

                tNewObj:setCellGoodItem(tTempItem, 4)

                table.insert(self.m_tCellList,tNewObj)
            end
        else
            if conItem:getChildByTag(999) then
                conItem:removeChildByTag(999, true)
            end
        end
    end

    self.m_nTotalCost = self:_caculateTotalCost()
    --刷新费用
    self:_updateCostNum()
end

--@brief    更新费用显示
function WndGemAppraise:_updateCostNum()
    -- body
    local txtCost = GetElement(self.m_root, "txtCost_WndGemAppraise", WZUILabelTTF)
    if txtCost then
        txtCost:setText(self.m_nTotalCost)
    end
end

--@brief    当宝物放入或移出待鉴定栏的时候，更新背包中相应的宝物的数量显示
--@param    nType:1->从背包放入待鉴定栏；2->从鉴定栏放回背包
--@param    nIndex:相应的待鉴定数据索引
function WndGemAppraise:_updateBagItemNum(nType, nIndex)
    -- body
    if nType == 1 then
        --刷新背包中的数量
        self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:setItemCount(self.m_tBagList[self.m_tAppraiseList[nIndex].tagInBag + 1].lastNum - self.m_tAppraiseList[nIndex].num)
        if self.m_tBagList[self.m_tAppraiseList[nIndex].tagInBag + 1].lastNum - self.m_tAppraiseList[nIndex].num == 0 then
            self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:_setItemVisible(false)
        else
            self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:_setItemVisible(true)
        end
        --勾号的选中状态
        self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:showSelectedIcon(2)
    elseif nType == 2 then
        self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:setItemCount(self.m_tBagList[self.m_tAppraiseList[nIndex].tagInBag + 1].lastNum)
        self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:_setItemVisible(true)
        --移除勾号的选中状态
        self.m_tCellList[self.m_tAppraiseList[nIndex].tagInBag + 1]:removeGouIcon()
        --移出掉鉴定栏的宝物图标
        local conItem = GetElement(self.m_root, "conItem" .. nIndex .. "_WndGemAppraise", WZUIContainer)
        if conItem:getChildByTag(999) then
            conItem:removeChildByTag(999, true)
        end
        --清除掉移出鉴定栏的数据
        self.m_tAppraiseList[nIndex] = {}
        self.m_nTotalCost = self:_caculateTotalCost()
        --刷新费用
        self:_updateCostNum()
    end
end

--@brief    设置开箱特效
function WndGemAppraise:setSpineAni()
    local spinePath = "ui/otherUI/ui_jianding_01"
    local bIsExist = CheckEffectFile(spinePath)

    if bIsExist then 
        for i = 1, 6 do
            local joinSpine = GetElement(self.m_root, "spine" .. i .. "_WndGemAppraise", WZUISpine)

            joinSpine:setFileJson(spinePath .. ".json")
            joinSpine:setFileAtlas(spinePath .. ".atlas")
        end
    end
 end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndGemAppraise:_adaptLanguage_en(  )
    GetElement(self.m_root, "txtCostWord_WndGemAppraise", WZUILabelTTF):setScale(0.8)
    
end

function WndGemAppraise:_adaptLanguage_pt(  )
    GetElement(self.m_root, "txtCostWord_WndGemAppraise", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100)) 
    
    GetElement(self.m_root, "txtQuickSelect_WndGemAppraise", WZUILabelTTF):setScale(0.7)
end

function WndGemAppraise:_adaptLanguage_es(  )
    GetElement(self.m_root, "txtCostWord_WndGemAppraise", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100)) 

    GetElement(self.m_root, "txtQuickSelect_WndGemAppraise", WZUILabelTTF):setScale(0.7)
end

function WndGemAppraise:_adaptLanguage_tr(  )
    GetElement(self.m_root, "txtCostWord_WndGemAppraise", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100)) 
end

function WndGemAppraise:_adaptLanguage_ug(  )
    GetElement(self.m_root, "txtCostWord_WndGemAppraise", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100)) 
    
    local txtQuickSelect = GetElement(self.m_root, "txtQuickSelect_WndGemAppraise", WZUILabelTTF)
    txtQuickSelect:setScale(0.7)
    txtQuickSelect:setDimensions(GlobalMethod:CCSize(170))
end
-------------------------------------语言适配End----------------------------------------