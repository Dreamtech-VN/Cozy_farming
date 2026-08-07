--WndSelectTipsStrengthen.lua
--@brief	WndSelectTipsStrengthen的UI模块
--@date		2015/06/09
--@author	zsq
--@note		选择宝石或装备界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSelectTipsStrengthen:onEnter(element)
	self.m_root = element
	GetElement(self.m_root,"btnInset_WndSelectTipsStrengthen",WZUIButton):setTouchEnable(false)
	
    AdaptLanguage(self)
end

--@brief	加载动画
function WndSelectTipsStrengthen:onEnterTransitionDidFinish(element)
    --设置界面文本
    self:_setUIStaticText()
    
    WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
end

--@brief	加载动画完
function WndSelectTipsStrengthen:actionCallback()
    TeachGroup1:endTeachStep({11,5})

    if self.m_tListData and #self.m_tListData == 0 then
        WindowManager:removeTeachShelterLayer()
    else
        TeachGroup1:startGroup({11,6,self.m_root})

        if TeachGroup1.TASK_GO_ID == TeachGroup1.TASK_ID_15 then
            TeachGroup1:endTeachStep({38,2})
            TeachGroup1:startGroup({38,3,self.m_root})
        end
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSelectTipsStrengthen:onExit(element)
	self:_unInit()
end


--@brief    关闭按钮回调
function WndSelectTipsStrengthen:onCloseBtnClicked()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

--@brief	关闭整个窗口的动画效果
function WndSelectTipsStrengthen:onCloseActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief	购买宝石
function WndSelectTipsStrengthen:getGem()
    if self.m_nTipsTag == 5 then 
        local itemId = 0
        for i, value in pairs(GDatatab_item) do
            if value.main_type == 35 and value.sub_type == self.m_nStoneType then 
                itemId = value.id
                break 
            end
        end
        WndFastGetItems:show(itemId)
    elseif self.m_nTipsTag == 6 then 
        local itemId = 0
        for i, value in pairs(GDatatab_item) do
            if value.main_type == 46 and utilsValueInTable(value.sub_type, self.m_nStoneType) and value.value == 1 then 
                itemId = value.id
                break 
            end
        end
        WndFastGetItems:show(itemId)
    elseif self.m_nTipsTag == 7 then 
        local itemId = 0
        for i, value in pairs(GDatatab_item) do
            if value.main_type == 49 and value.sub_type == 1 then 
                itemId = value.id
                break 
            end
        end
        WndFastGetItems:show(itemId)
    else
    	if tostring(self.m_nStoneType) == "0" then
            checkIsOnSale(124)
    	elseif tostring(self.m_nStoneType) == "1" then
            checkIsOnSale(134)
    	elseif tostring(self.m_nStoneType) == "2" then
            checkIsOnSale(144)
    	end
    end
	--self:onCloseBtnClicked()
end

--@brief    继承前确定按钮回调
function WndSelectTipsStrengthen:onConfirmBtn3Click()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tSelectItem ~= nil then
        WndStrengthen:updateCellEquip(self.m_tSelectItem)
    end
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    确定按钮回调
function WndSelectTipsStrengthen:onConfirmBtnClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tSelectItem ~= nil then
        WndTransferStrengthen:addEquipToCell2(self.m_tSelectItem)
		-- GetElement(WndTransferStrengthen.m_root,"star2_WndTransferStrengthen",WZUIImage):setVisible(true)
		-- --显示箭头
		-- GetElement(WndTransferStrengthen.m_root,"imgArrow_WndTransfer",WZUIImage):setVisible(true)
    end
    WindowManager:removeWindow(self.m_root, self, true)

    if TeachGroup1.TASK_GO_ID == TeachGroup1.TASK_ID_15 then
        TeachGroup1:endTeachStep({38,4})
        TeachGroup1:startGroup({38,5,WndTransferStrengthen.m_root})
    end
end
--@brief    镶嵌按钮回调
function WndSelectTipsStrengthen:onInsetBtnClick()
	SoundManager:playEffectSound(SoundDefine.E_S_KILL_XIANGQIAN)
    if self.m_nTipsTag == 5 then 
        if self.m_tSelectItem == nil then return end
        if not JudgeMoneyIsEnough(self.m_nCostId, self.m_nInsetCostGold, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.continueToCastSoul) then
            return
        end 

        self:continueToCastSoul()
    elseif self.m_nTipsTag == 6 then 
        if self.m_tSelectItem == nil then return end
        self:continueToCastSoul()
    elseif self.m_nTipsTag == 7 then 
        if self.m_tSelectItem == nil then return end
        self:continueToCastSoul()
    else
        TeachGroup1:endTeachStep({11,7})
        if self.m_tSelectItem == nil then return end
        if CacheCenter:getMoneyList().gold < self.m_nInsetCostGold then
            MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil, nil)
            return
        end 
        WndGemMountingStrengthen:addStoneToCell(self.m_tSelectItem)
        WindowManager:removeWindow(self.m_root, self, true)
    end
end

--@brief    魔力宝石升级按钮回调
function WndSelectTipsStrengthen:onGemInsertClick()
    if self.m_tSelectItem.lastNum > 1 then
        WndMagicGemUpgradeSelect:show(self.m_tSelectItem)
        return
    end
    WndMagicGemUpgrade:addMagicGemToCell(self.m_tSelectItem)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    多选宝石后
function WndSelectTipsStrengthen:getSelectGemData(tData)
    WndMagicGemUpgrade:addMagicGemToCell(tData)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    快速购买金币框
--@param    nResType:响应类型(超时，确定，取消)
function WndSelectTipsStrengthen:buyGold(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(26)
    end
end

--@brief    cell被选中时调用
function WndSelectTipsStrengthen:cellSelected(nTag,cellData)
    WZLog("WndSelectTipsStrengthen:cellSelected")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local listCells = #self.m_tListData
    if listCells == 0 then return end
    --获取table控件
    local tbconList = GetElement(self.m_root,"tbTipsCell_WndSelectTipsStrengthen",WZUITableContainer)
    local t = nil
    for i=1,#self.m_tListData do
        local tCell = tbconList:getCellElement(i-1)
        local tCheckBox = WZUICheckBox:luaTo(tCell:getChildElement("checkboxSelect_CellStrengthenSelectTips"))
        if i == nTag+1 then
            if tCheckBox:getCheckIndex() == 1 then
                t = self.m_tListData[i]
            end
        else
            tCheckBox:setCheckIndex(0)
        end
    end
    if self.m_nTipsTag == 1 then
        --设置按钮是否可按
        if t == nil then
			GetElement(self.m_root,"btnInset_WndSelectTipsStrengthen",WZUIButton):setTouchEnable(false)
            self.m_nInsetCostGold = 0
        else
            TeachGroup1:endTeachStep({11,6})
            TeachGroup1:startGroup({11,7,WndSelectTipsStrengthen.m_root})

			GetElement(self.m_root,"btnInset_WndSelectTipsStrengthen",WZUIButton):setTouchEnable(true)
			local level = tonumber(t.id)%10 + 1
            self.m_nInsetCostGold = GDatatab_mosaic_config["id_"..level].cost[1][2]
        end
        --更新金币
        GetElement(self.m_root,"txtCost_WndSelectTipsStrengthen",WZUILabelTTF):setText(self.m_nInsetCostGold)
    elseif self.m_nTipsTag == 5 then 
        GetElement(self.m_root,"btnInset_WndSelectTipsStrengthen",WZUIButton):setTouchEnable(true)
    elseif self.m_nTipsTag == 6 then 
        GetElement(self.m_root, "conCostGold_WndSelectTipsStrengthen", WZUIContainer):setVisible(false)
        GetElement(self.m_root,"btnInset_WndSelectTipsStrengthen",WZUIButton):setTouchEnable(true)
    elseif self.m_nTipsTag == 7 then 
        GetElement(self.m_root, "conCostGold_WndSelectTipsStrengthen", WZUIContainer):setVisible(false)
        GetElement(self.m_root,"btnInset_WndSelectTipsStrengthen",WZUIButton):setTouchEnable(true)
    end
    if self.m_nTipsTag == 4 then
        GetElement(self.m_root,"btnGemInsert_WndSelectTipsStrengthen",WZUIButton):setTouchEnable(true)
    end
    --保存选择的物品
    self.m_tSelectItem = t


    if TeachGroup1.TASK_GO_ID == TeachGroup1.TASK_ID_15 then
        TeachGroup1:endTeachStep({38,3})
        TeachGroup1:startGroup({38,4,WndSelectTipsStrengthen.m_root})
    end

end

--@brief    注魂继续
function WndSelectTipsStrengthen:continueToCastSoul()
    -- body
    if self.m_nTipsTag == 5 then 
        WndDressCastSoul:addStoneToCell(self.m_tSelectItem, self.m_nGridIndex)
    elseif self.m_nTipsTag == 6 then 
        WndHVField:addStoneToCell(self.m_tSelectItem, self.m_nGridIndex, 1)
    elseif self.m_nTipsTag == 7 then 
        WndHVSpirit:addStoneToCell(self.m_tSelectItem, self.m_nGridIndex)
    end

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击卸下按钮回调
function WndSelectTipsStrengthen:onUnEquipBtnClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndHVField:addStoneToCell(self.m_tSelectItem, self.m_nGridIndex, -1)
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    初始化宝石列表
function WndSelectTipsStrengthen:_initStoneTips(t)
	GetElement(self.m_root,"btnGetGem",WZUIButton):setVisible(false)
    --tips名称
    local tipsName = LocalStrings.MY_GEM
    GetElement(self.m_root,"txtTipsName_WndSelectTipsStrengthen",WZUILabelTTF):setText(tipsName)
    --显示镶嵌按钮
    GetElement(self.m_root,"conComfirmBtn_WndSelectTipsStrengthen",WZUIContainer):setVisible(false)
    local btnInset = GetElement(self.m_root,"conInsetBtn_WndSelectTipsStrengthen",WZUIContainer)
    btnInset:setVisible(true)
	GetElement(self.m_root,"btnInset_WndSelectTipsStrengthen",WZUIButton):setTouchEnable(false)
    --镶嵌静态文本
    for i=1,3 do
        GetElement(self.m_root,string.format("txtInsetWord%d_WndSelectTipsStrengthen",i),WZUILabelTTF):setText(LocalStrings.GEMMOUNTING)
    end
    --初始化金币
    self.m_nInsetCostGold = 0
    GetElement(self.m_root,"txtCost_WndSelectTipsStrengthen",WZUILabelTTF):setText(self.m_nInsetCostGold)
    --创建宝石列表:宝石类别
	if t ~= nil and t.type ~= nil then
		self.m_nStoneType = t.type
	end
    local stoneId = nil
    if t ~= nil and t.tData ~= nil then
        stoneId = t.tData.basicInfo.id
    end
    local tMaterialItems = CopyTable(CacheCenter:getMaterialList())
    for i,v in pairs(tMaterialItems) do
        local isInsert = true
        if v.maintype == 6 and v.subtype == self.m_nStoneType and isInsert then
            table.insert(self.m_tListData,v)
        end
    end
    table.sort(self.m_tListData, _sortMaterials)

    local tbconEquip = GetElement(self.m_root,"tbTipsCell_WndSelectTipsStrengthen",WZUITableContainer)
    if tbconEquip == nil then return end
    for i=1,#self.m_tListData do
        local cellElement,cellObj = CellStrengthenSelectTips:createElement()
        cellElement:setTag(i-1)
        tbconEquip:setCellElement(cellElement)
        cellObj:initCellDataWithType(1,self.m_tListData[i])
    end
	--没有宝石显示购买宝石按钮
	if #self.m_tListData == 0 then
		GetElement(self.m_root,"btnGetGem",WZUIButton):setVisible(true)
	end
end

--@brief    初始化魔力宝石升级选择列表
function WndSelectTipsStrengthen:_initMagicGemUp()
    GetElement(self.m_root,"btnGetGem",WZUIButton):setVisible(false)
    --tips名称
    GetElement(self.m_root,"txtTipsName_WndSelectTipsStrengthen",WZUILabelTTF):setText(LocalStrings.MY_GEM)
    --显示镶嵌按钮
    GetElement(self.m_root,"conComfirmBtn_WndSelectTipsStrengthen",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"conInsetBtn_WndSelectTipsStrengthen",WZUIContainer):setVisible(false)
    local btnGemInsert = GetElement(self.m_root,"btnGemInsert_WndSelectTipsStrengthen",WZUIButton)
    btnGemInsert:setVisible(true)
    btnGemInsert:setTouchEnable(false)
    --镶嵌静态文本
    for i=1,3 do
        GetElement(self.m_root,string.format("txtGemInsert%d_WndSelectTipsStrengthen",i),WZUILabelTTF):setText(LocalStrings.GEM_MOUNTING_3)
    end

    local tMaterialItems = CopyTable(CacheCenter:getMaterialList())
    for i,v in pairs(tMaterialItems) do
        if v.maintype == 6 and v.subtype ~= 5 then
            if not (WndMagicGemUpgrade.m_tAllSelGemData[1] and WndMagicGemUpgrade.m_tAllSelGemData[1].playerItemId == v.playerItemId) and
                not (WndMagicGemUpgrade.m_tAllSelGemData[2] and WndMagicGemUpgrade.m_tAllSelGemData[2].playerItemId == v.playerItemId) and
                not (WndMagicGemUpgrade.m_tAllSelGemData[3] and WndMagicGemUpgrade.m_tAllSelGemData[3].playerItemId == v.playerItemId) then
                table.insert(self.m_tListData,v)
            end
        end
    end
    local tbconEquip = GetElement(self.m_root,"tbTipsCell_WndSelectTipsStrengthen",WZUITableContainer)
    for i=1,#self.m_tListData do
        local cellElement,cellObj = CellStrengthenSelectTips:createElement()
        cellElement:setTag(i-1)
        tbconEquip:setCellElement(cellElement)
        cellObj:initCellDataWithType(1,self.m_tListData[i])
    end
end

--@brief    初始化继承前装备列表
function WndSelectTipsStrengthen:_initEquipFrom()
	WZLog("WndSelectTipsStrengthen:_initEquipFrom")
	GetElement(self.m_root,"btnGetGem",WZUIButton):setVisible(false)
    --tips名称
    GetElement(self.m_root,"txtTipsName_WndSelectTipsStrengthen",WZUILabelTTF):setText(LocalStrings.STRENGTENTIP6)
    --显示确定按钮
    GetElement(self.m_root,"conComfirmBtn_WndSelectTipsStrengthen",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"btnComfirm_WndSelectTipsStrengthen",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"btnComfirm3_WndSelectTipsStrengthen",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"conInsetBtn_WndSelectTipsStrengthen",WZUIContainer):setVisible(false)
    --确定静态文本
    for i=1,3 do
        GetElement(self.m_root,string.format("txtComfirmWord%d_WndSelectTipsStrengthen",i),WZUILabelTTF):setText(LocalStrings.CONFIRM)
    end
    --创建装备列表:装备类型
    local tEquipItems = CopyTable(CacheCenter:getEquipList())

    for i,v in pairs(tEquipItems) do
		if (v.extraInfo.strongLevel ~= nil and v.extraInfo.strongLevel > 0) or (v.extraInfo.starLevel ~= nil and v.extraInfo.starLevel > 0) then
			local notTimeLimit = (v.basicInfo.time_limit == -1)
			if v.extraInfo.strongLevel == nil then v.extraInfo.strongLevel = 0 end
			if v.extraInfo.starLevel == nil then v.extraInfo.starLevel = 0 end
			if notTimeLimit then
            	table.insert(self.m_tListData,v)
			end
		end
    end
    table.sort(self.m_tListData, _sortEquips1)
	WZLog("lksjg",Serialize(self.m_tListData))
    local tbconEquip = GetElement(self.m_root,"tbTipsCell_WndSelectTipsStrengthen",WZUITableContainer)
    if tbconEquip == nil then
        return
    end
    for i=1,#self.m_tListData do
        local cellElement,cellObj = CellStrengthenSelectTips:createElement()
        cellElement:setTag(i-1)
        tbconEquip:setCellElement(cellElement)
        cellObj:initCellDataWithType(2,self.m_tListData[i])
    end
end

--@brief 	按强化升星等级排序
function _sortEquips1(a, b)
	if a.extraInfo.strongLevel == b.extraInfo.strongLevel then
		if a.extraInfo.starLevel == b.extraInfo.starLevel then
			return a.id < b.id
		else
			return a.extraInfo.starLevel > b.extraInfo.starLevel
		end
	else
		return a.extraInfo.strongLevel > b.extraInfo.strongLevel
	end
end

--@brief    初始化装备列表
function WndSelectTipsStrengthen:_initEquipTips(tEquip)
	GetElement(self.m_root,"btnGetGem",WZUIButton):setVisible(false)
    --tips名称
    local tipsName = LocalStrings.PLEASE_SELECT_TRANSFER_EQUIP
    local txtTipsName = GetElement(self.m_root,"txtTipsName_WndSelectTipsStrengthen",WZUILabelTTF)
    txtTipsName:setText(tipsName)
    if ProjConfig.LANGUAGE == "en" then
        GetElement(self.m_root,"txtTipsName_WndSelectTipsStrengthen",WZUILabelTTF):setFontSize(20)
    end
    if ProjConfig.LANGUAGE == "pt" then
        -- GetElement(self.m_root,"txtTipsName_WndSelectTipsStrengthen",WZUILabelTTF):setFontSize(14)
        txtTipsName:setScale(0.5)
    elseif ProjConfig.LANGUAGE == "tr" then
        txtTipsName:setScale(0.6)
    elseif ProjConfig.LANGUAGE == "en" then
        txtTipsName:setScale(0.6)
    end
    --显示确定按钮
    GetElement(self.m_root,"conComfirmBtn_WndSelectTipsStrengthen",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"conInsetBtn_WndSelectTipsStrengthen",WZUIContainer):setVisible(false)
    --确定静态文本
    for i=1,3 do
        GetElement(self.m_root,string.format("txtComfirmWord%d_WndSelectTipsStrengthen",i),WZUILabelTTF):setText(LocalStrings.CONFIRM)
    end
    --创建装备列表:装备类型
    local tEquipItems = CopyTable(CacheCenter:getEquipList())
    local ePlayerId = tEquip.playerItemId
    local eType = tEquip.subtype
	local quality = tEquip.basicInfo.quality
    for i,v in pairs(tEquipItems) do
		local notTimeLimit = (v.basicInfo.time_limit == -1)
		if notTimeLimit then

		if v.extraInfo.strongLevel == nil then v.extraInfo.strongLevel = 0 end
		if v.extraInfo.starLevel == nil then v.extraInfo.starLevel = 0 end
		if v.extraInfo.strongLevel == 0 and v.extraInfo.starLevel == 0 then
			v.sortFirst = 1
		else
			v.sortFirst = 0
		end
		local condition = true
		--橙装只能继承给橙装和紫装
		if quality == 4 then 
			if v.basicInfo.quality == 4 or v.basicInfo.quality == 3 then
				condition = true
			else
				condition = false
			end
		end
		--橙装只能被橙装继承
		if quality < 4 then
			if v.basicInfo.quality == 4 then
				condition = false
			elseif v.basicInfo.quality < 4 then
				condition = true
			end
		end
        if v.playerItemId ~= ePlayerId and v.subtype == eType and condition then
            table.insert(self.m_tListData,v)
        end
        --武器：subtype == 0 or 1
        if eType == 1 and v.playerItemId ~= ePlayerId and v.subtype == 0 and condition then
            table.insert(self.m_tListData,v)
        end
        if eType == 0 and v.playerItemId ~= ePlayerId and v.subtype == 1 and condition then
            table.insert(self.m_tListData,v)
        end

		end
    end
    table.sort(self.m_tListData, _sortEquips)
    local tbconEquip = GetElement(self.m_root,"tbTipsCell_WndSelectTipsStrengthen",WZUITableContainer)
    if tbconEquip == nil then
        return
    end
    for i=1,#self.m_tListData do
        local cellElement,cellObj = CellStrengthenSelectTips:createElement()
        cellElement:setTag(i-1)
        tbconEquip:setCellElement(cellElement)
        cellObj:initCellDataWithType(2,self.m_tListData[i])
    end
end

--@brief	设置静态文本
function WndSelectTipsStrengthen:_setUIStaticText()
    if self.m_nTipsTag == 5 then 
	   GetElement(self.m_root,"ttfGetGem",WZUILabelTTF):setText(LocalStrings.CASTSOUL_TEXT13)
    elseif self.m_nTipsTag == 6 then 
       GetElement(self.m_root,"ttfGetGem",WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[31])
    elseif self.m_nTipsTag == 7 then
       GetElement(self.m_root,"ttfGetGem",WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[27])
    else
       GetElement(self.m_root,"ttfGetGem",WZUILabelTTF):setText(LocalStrings.BUY..LocalStrings.SHOP_STONE)
    end
end

--@brief 	装备排序函数
function _sortEquips(a, b)
	--没有强化升星的
	if a.sortFirst == b.sortFirst then
		--品质
        if a.basicInfo.quality == b.basicInfo.quality then
            --3战斗力
            if a.extraInfo.fighting == b.extraInfo.fighting then
				return a.id < b.id
            else
                return a.extraInfo.fighting > b.extraInfo.fighting
            end
		else
            return a.basicInfo.quality > b.basicInfo.quality
		end
	else
		return a.sortFirst > b.sortFirst
	end
end

--@brief    宝石排序函数
function _sortMaterials(a,b)
    --宝石等级
    local aKey = "id_" .. a.basicInfo.id
    local bKey = "id_" .. b.basicInfo.id
    local aLv = GDatatab_item[aKey].value
    local bLv = GDatatab_item[bKey].value
    if aLv > bLv then
        return true
    else
        return false
    end
end

--@brief    初始化元魂列表
function WndSelectTipsStrengthen:_initSoulTips(stoneType)
    local nTabIndex = WndDressCastSoul.m_nTabIndex

    local sSuitConfig = CacheCenter:getGameParam().enchantingNumber
    local sWingConfig = CacheCenter:getGameParam().enchantingNumber2
    local sTitleConfig = CacheCenter:getGameParam().enchantingNumber6
    local string1 = string.sub(sSuitConfig, 2, -2)
    local string2 = string.sub(sWingConfig, 2, -2)
    local string3 = string.sub(sTitleConfig, 2, -2)
    local tSuitOpenLevel = SplitStringWithSeparator(string1, ",", nil, true)
    local tWingOpenLevel = SplitStringWithSeparator(string2, ",", nil, true)
    local tTitleOpenLevel = SplitStringWithSeparator(string3, ",", nil, true)

    local tGridLevel
    if nTabIndex == 1 then 
        tGridLevel = tSuitOpenLevel
    elseif nTabIndex == 2 then 
        tGridLevel = tWingOpenLevel
    elseif nTabIndex == 3 then 
        tGridLevel = tTitleOpenLevel
    end

    GetElement(self.m_root,"btnGetGem",WZUIButton):setVisible(false)
    --tips名称
    local tipsName = LocalStrings.CASTSOUL_TEXT11
    GetElement(self.m_root,"txtTipsName_WndSelectTipsStrengthen",WZUILabelTTF):setText(tipsName)
    --显示镶嵌按钮
    GetElement(self.m_root,"conComfirmBtn_WndSelectTipsStrengthen",WZUIContainer):setVisible(false)
    local btnInset = GetElement(self.m_root,"conInsetBtn_WndSelectTipsStrengthen",WZUIContainer)
    btnInset:setVisible(true)
    GetElement(self.m_root,"btnInset_WndSelectTipsStrengthen",WZUIButton):setTouchEnable(false)
    --镶嵌静态文本
    for i=1,3 do
        GetElement(self.m_root,string.format("txtInsetWord%d_WndSelectTipsStrengthen",i),WZUILabelTTF):setText(LocalStrings.CASTSOUL_TEXT12)
    end
    self.m_nGridIndex = stoneType
    --创建宝石列表:宝石类别
    if stoneType ~= nil then
        if stoneType <= #tGridLevel then 
            if nTabIndex == 3 then 
                self.m_nStoneType = 5
            else
                self.m_nStoneType = math.fmod((stoneType - 1), 3) + 1
            end
        else
            self.m_nStoneType = 4
        end
    end
    local sCostConfig = CacheCenter:getGameParam().enchantingNumber3
    local ids, nums = SplitItemString(sCostConfig)
    WZLog("WndSelectTipsStrengthen:_initSoulTips", Serialize(ids), Serialize(nums), stoneType)
    --初始化消耗
    self.m_nCostId = tonumber(ids[stoneType])
    self.m_nInsetCostGold = tonumber(nums[stoneType])
    GetElement(self.m_root,"txtCost_WndSelectTipsStrengthen",WZUILabelTTF):setText(self.m_nInsetCostGold)
    local imgGold = GetElement(self.m_root,"imgGold_WndSelectTipsStrengthen",WZUI9Image)
    if imgGold then 
        imgGold:setFile(GDatatab_item["id_" .. self.m_nCostId].icon)
        imgGold:setScale(0.5)
    end
    local tMaterialItems = CopyTable(CacheCenter:getMaterialList())
    for i,v in pairs(tMaterialItems) do
        local isInsert = true
        if v.maintype == 35 and v.subtype == self.m_nStoneType and isInsert then
            table.insert(self.m_tListData,v)
        end
    end
    table.sort(self.m_tListData, _sortMaterials)

    local tbconEquip = GetElement(self.m_root,"tbTipsCell_WndSelectTipsStrengthen",WZUITableContainer)
    if tbconEquip == nil then return end
    for i = 1, #self.m_tListData do
        local cellElement,cellObj = CellStrengthenSelectTips:createElement()
        cellElement:setTag(i-1)
        tbconEquip:setCellElement(cellElement)
        cellObj:initCellDataWithType(1, self.m_tListData[i])
    end
    --没有宝石显示购买宝石按钮
    if #self.m_tListData == 0 then
        GetElement(self.m_root,"btnGetGem",WZUIButton):setVisible(true)
    end
end

--@brief    初始化源石列表
--@param    镶嵌的位置
function WndSelectTipsStrengthen:_initHVStoneTips(tData)
    GetElement(self.m_root,"btnGetGem",WZUIButton):setVisible(false)
    --tips名称
    local tipsName = LocalStrings.HOLIDAYVILLAGE_TEXT1[30]
    GetElement(self.m_root,"txtTipsName_WndSelectTipsStrengthen",WZUILabelTTF):setText(tipsName)
    --显示镶嵌按钮
    GetElement(self.m_root,"conComfirmBtn_WndSelectTipsStrengthen",WZUIContainer):setVisible(false)
    local btnInset = GetElement(self.m_root,"conInsetBtn_WndSelectTipsStrengthen",WZUIContainer)
    btnInset:setVisible(true)
    GetElement(self.m_root,"btnInset_WndSelectTipsStrengthen",WZUIButton):setTouchEnable(false)

    GetElement(self.m_root,"conCostGold_WndSelectTipsStrengthen",WZUIContainer):setVisible(false)
    --镶嵌静态文本
    for i=1,3 do
        GetElement(self.m_root,string.format("txtInsetWord%d_WndSelectTipsStrengthen",i),WZUILabelTTF):setText(LocalStrings.GEMMOUNTING)
        GetElement(self.m_root,string.format("txtUnEquipWord%d_WndSelectTipsStrengthen",i),WZUILabelTTF):setText(LocalStrings.UNROYAL)
    end
    --初始化金币
    self.m_nInsetCostGold = 0
    GetElement(self.m_root,"txtCost_WndSelectTipsStrengthen",WZUILabelTTF):setText(self.m_nInsetCostGold)
    self.m_nGridIndex = tData.stonePos
    if tData.stoneId and tData.stoneId > 0 then 
        GetElement(self.m_root,"btnUnEquip_WndSelectTipsStrengthen",WZUIButton):setVisible(true)
    end

    self.m_nStoneType = tData.stone_type
    local tMaterialItems = CopyTable(CacheCenter:getMaterialList())
    for i,v in pairs(tMaterialItems) do
        if v.maintype == 46 then
            for j = 1, #tData.stone_type do
                if v.subtype == tData.stone_type[j] then 
                    table.insert(self.m_tListData,v)
                    break 
                end
            end
        end
    end
    table.sort(self.m_tListData, _sortMaterials)

    local tbconEquip = GetElement(self.m_root,"tbTipsCell_WndSelectTipsStrengthen",WZUITableContainer)
    if tbconEquip == nil then return end
    for i=1,#self.m_tListData do
        local cellElement,cellObj = CellStrengthenSelectTips:createElement()
        cellElement:setTag(i-1)
        tbconEquip:setCellElement(cellElement)
        cellObj:initCellDataWithType(1,self.m_tListData[i])
    end
    --没有宝石显示购买宝石按钮
    if #self.m_tListData == 0 then
        GetElement(self.m_root,"btnGetGem",WZUIButton):setVisible(true)
    end
end

--@brief    初始化度假村精灵
function WndSelectTipsStrengthen:_initHVSpirit(tData)
    GetElement(self.m_root,"btnGetGem",WZUIButton):setVisible(false)
    --tips名称
    local tipsName = LocalStrings.HOLIDAYVILLAGE_TEXT4[6]
    GetElement(self.m_root,"txtTipsName_WndSelectTipsStrengthen",WZUILabelTTF):setText(tipsName)
    --显示镶嵌按钮
    GetElement(self.m_root,"conComfirmBtn_WndSelectTipsStrengthen",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"conInsetBtn_WndSelectTipsStrengthen",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"btnInset_WndSelectTipsStrengthen",WZUIButton):setTouchEnable(false)

    GetElement(self.m_root,"conCostGold_WndSelectTipsStrengthen",WZUIContainer):setVisible(false)
    --镶嵌静态文本
    for i=1,3 do
        GetElement(self.m_root,string.format("txtInsetWord%d_WndSelectTipsStrengthen",i),WZUILabelTTF):setText(LocalStrings.BAGTIP48)
        GetElement(self.m_root,string.format("txtUnEquipWord%d_WndSelectTipsStrengthen",i),WZUILabelTTF):setText(LocalStrings.UNROYAL)
    end
    --初始化金币
    self.m_nInsetCostGold = 0
    GetElement(self.m_root,"txtCost_WndSelectTipsStrengthen",WZUILabelTTF):setText(self.m_nInsetCostGold)
    self.m_nGridIndex = tData.gridPos
    if tData.gridId and tData.gridId > 0 then 
        GetElement(self.m_root,"btnUnEquip_WndSelectTipsStrengthen",WZUIButton):setVisible(true)
    end

    --获取拥有且没放过的精灵
    self.m_tListData = CopyTable(CacheCenter:getHVSpiritList())
    local tSpiritData = WndHVSpirit:getSpiritData()
    for i=#self.m_tListData,1,-1 do
        for j=1,#tSpiritData do
            if tSpiritData[j].spiritId > 0 then
                local tSpiritInfo = GDatatab_holiday_spirit["id_"..tSpiritData[j].spiritId]
                if self.m_tListData[i] and self.m_tListData[i].id == tSpiritInfo.item_id then
                    table.remove(self.m_tListData,i)
                end
            end
        end
    end
    table.sort(self.m_tListData, function (a,b)
        return a.id > b.id
    end)

    local tbconEquip = GetElement(self.m_root,"tbTipsCell_WndSelectTipsStrengthen",WZUITableContainer)
    if tbconEquip == nil then return end
    for i=1,#self.m_tListData do
        local cellElement,cellObj = CellStrengthenSelectTips:createElement()
        cellElement:setTag(i-1)
        tbconEquip:setCellElement(cellElement)
        cellObj:initCellDataWithType(3,self.m_tListData[i])
    end
    --没有宝石显示购买宝石按钮
    if #self.m_tListData == 0 then
        GetElement(self.m_root,"btnGetGem",WZUIButton):setVisible(true)
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------
function WndSelectTipsStrengthen:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtTipsName_WndSelectTipsStrengthen",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtCost1_WndSelectTipsStrengthen",WZUILabelTTF):setFontSize(16)
    local imgGold = GetElement(self.m_root,"imgGold_WndSelectTipsStrengthen",WZUI9Image)
    imgGold:setRelativePosition(GlobalMethod:ccp(0.4,0.5))
end

function WndSelectTipsStrengthen:_adaptLanguage_ug(  )
    GetElement(self.m_root,"txtTipsName_WndSelectTipsStrengthen",WZUILabelTTF):setScale(0.7)

    local btnComfirm = GetElement(self.m_root,"btnComfirm_WndSelectTipsStrengthen",WZUIButton)
    local btnComfirm3 = GetElement(self.m_root,"btnComfirm3_WndSelectTipsStrengthen",WZUIButton)

    GetElement(btnComfirm,"txtComfirmWord1_WndSelectTipsStrengthen",WZUIButton):setScale(0.6)
    GetElement(btnComfirm,"txtComfirmWord2_WndSelectTipsStrengthen",WZUIButton):setScale(0.6)
    GetElement(btnComfirm,"txtComfirmWord3_WndSelectTipsStrengthen",WZUIButton):setScale(0.6)
    GetElement(btnComfirm3,"txtComfirmWord1_WndSelectTipsStrengthen",WZUIButton):setScale(0.6)
    GetElement(btnComfirm3,"txtComfirmWord2_WndSelectTipsStrengthen",WZUIButton):setScale(0.6)
    GetElement(btnComfirm3,"txtComfirmWord3_WndSelectTipsStrengthen",WZUIButton):setScale(0.6)
end
-------------------------------------语言适配End-----------------------------------------