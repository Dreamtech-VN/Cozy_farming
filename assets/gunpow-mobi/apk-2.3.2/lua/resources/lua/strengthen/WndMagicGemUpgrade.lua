--WndMagicGemUpgrade.lua
--@brief	WndMagicGemUpgrade的UI模块
--@date		2019/07/23
--@author	yrd
--@note		魔力宝石升级


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMagicGemUpgrade:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMagicGemUpgrade:onExit(element)
	self:_unInit()
end

function WndMagicGemUpgrade:_update()
    if self.m_tGemData == nil then
        return
    end

	local GemName = {"hpStone","attackStone","defendStone","","","gongmingStone"}
	local tGemExp = {"hpGemExp","attackGemExp","defendGemExp","","","gongmingGemExp"}


    local tGemUpInfo = GDatatab_dig_up["id_"..self.m_tGemData.id]

    for _,value in pairs(GDatatab_dig_up) do
    	if value.id > 41000 and self.m_tGemData.basicInfo.sub_type == GDatatab_item["id_"..value.id].sub_type and value.behind_id == -1 then --找到当前子类型中最高阶的魔力宝石
    		if value.id == self.m_tGemData.basicInfo.id then
				return
			end
    		self.m_nMaxExp = value.mine_exp - GDatatab_dig_up["id_"..self.m_tGemData.id].mine_exp
    		break
    	end
    end

	self.m_nNextExp = 0
    for i=1,#self.m_tAllSelGemData do
    	if self.m_tAllSelGemData[i] then
    		self.m_nNextExp = self.m_nNextExp + GDatatab_dig_up["id_"..self.m_tAllSelGemData[i].id].mine_exp * self.m_tAllSelGemData[i].lastNum --宝石本身经验
    		if self.m_tAllSelGemData[i].id > 41000 then
				local nGemAddExp = 0
				if self.m_tAllSelGemData[i].extraInfo[tGemExp[self.m_tAllSelGemData[i].subtype+1]] then
					nGemAddExp = self.m_tAllSelGemData[i].extraInfo[tGemExp[self.m_tAllSelGemData[i].subtype+1]]
				end
    			self.m_nNextExp = self.m_nNextExp + nGemAddExp --魔力宝石附加的经验
			end
    	end
    end
--    GetElement(self.m_root, "txtAvailableExp_WndMagicGemUpgrade", WZUILabelTTF):setText(string.format(LocalStrings.GEM_MOUNTING_13,self.m_nNextExp))
	local stoneId = self.m_tCurSelectedEquip.extraInfo[GemName[self.m_tGemData.basicInfo.sub_type+1]]
	local level = GDatatab_item["id_" .. stoneId].value
    GetElement(self.m_root, "txtCurLv_WndMagicGemUpgrade", WZUILabelTTF):setText(LocalStrings.LV .. level)
    
    self.m_nCurGemExp = self.m_tCurSelectedEquip.extraInfo[tGemExp[self.m_tGemData.basicInfo.sub_type+1]] or 0
    local needexp = tGemUpInfo.up_exp
    --当前经验可提升等级
    self:setAddMaxLevel()
    self:setAddLevel(self.m_nNextExp + self.m_nCurGemExp)
    GetElement(self.m_root, "txtAddLv_WndGemMountingStrengthen", WZUILabelTTF):setText(self.m_nAddLevel)
    --更新升级后的属性数值显示
    WndGemMountingStrengthen:showPropertyAtt(2, self.m_tGemData.id, self.m_nAddLevel)

    local proExp = GetElement(self.m_root, "proExp_WndMagicGemUpgrade", WZUIProgress)
    local txtUpgrade = GetElement(self.m_root, "txtUpgrade_WndMagicGemUpgrade", WZUILabelTTF)
    local sCurExp = tostring(self.m_nCurGemExp)
    if self.m_nNextExp > 0 then 
    	sCurExp = sCurExp .. "(+" .. self.m_nNextExp .. ")"
    end
    GetElement(self.m_root, "txtExp_WndMagicGemUpgrade", WZUILabelTTF):setText(sCurExp .."/"..needexp)

    if self.m_nCurGemExp >= needexp then
    	proExp:setPercentage(100)
    else
    	proExp:setPercentage(math.floor(self.m_nCurGemExp/needexp*100))
    end

    if tGemUpInfo.up_consume ~= -1 then
    	if self.m_nCurGemExp >= needexp then
	    	txtUpgrade:setText(LocalStrings.STAR_SOUL_BUTTON_UPDATE)
	    	self.m_nOperateType = 1
    	else
    		if self.m_nNextExp + self.m_nCurGemExp >= needexp then
    			txtUpgrade:setText(LocalStrings.STAR_SOUL_BUTTON_UPDATE)
	    		self.m_nOperateType = 1
			else
				txtUpgrade:setText(LocalStrings.DEVOUR_WORDS)
				self.m_nOperateType = 2
			end
    	end
	else
    	txtUpgrade:setText(LocalStrings.DEVOUR_WORDS)
    	self.m_nOperateType = 2
	end

    local tGemUpInfo = GDatatab_dig_up["id_"..self.m_tGemData.id]
    local txtCost1 = GetElement(self.m_root, "txtCost1_WndMagicGemUpgrade", WZUILabelTTF)
    local txtCost2 = GetElement(self.m_root, "txtCost2_WndMagicGemUpgrade", WZUILabelTTF)

    if self.m_nOperateType == 1 then
    	local tTotalCost = self:getTotalCost()

	    txtCost1:setText(tTotalCost[1][2])
	    txtCost2:setText(tTotalCost[2][2])
    else
    	txtCost1:setText(0)
		txtCost2:setText(0)
	end
    if tGemUpInfo.up_consume ~= -1 then
	    GetElement(self.m_root, "imgCost1_WndMagicGemUpgrade", WZUIImage):setFile(GDatatab_item["id_"..tGemUpInfo.up_consume[1][1]].icon)
	    GetElement(self.m_root, "imgCost2_WndMagicGemUpgrade", WZUIImage):setFile(GDatatab_item["id_"..tGemUpInfo.up_consume[2][1]].icon)
		local tmpnum = CacheCenter:getPlayerItemCountById(tGemUpInfo.up_consume[2][1])
		GetElement(self.m_root, "txtCost2N_WndMagicGemUpgrade", WZUILabelTTF):setText(string.format(LocalStrings.GEM_MOUNTING_11, tmpnum))
	end
	WZLog("-------拥有的宝石",Serialize(self.m_tAllSelGemData))
	local tMaterialItems = CopyTable(CacheCenter:getMaterialList())
	self.m_tListData = {}
    for i,v in pairs(tMaterialItems) do
        if v.maintype == 6 and v.subtype ~= 5 then
            -- if not (self.m_tAllSelGemData[1] and self.m_tAllSelGemData[1].playerItemId == v.playerItemId) and
            --     not (self.m_tAllSelGemData[2] and self.m_tAllSelGemData[2].playerItemId == v.playerItemId) and
            --     not (self.m_tAllSelGemData[3] and self.m_tAllSelGemData[3].playerItemId == v.playerItemId) then
                table.insert(self.m_tListData,v)
            -- end
        end
    end
    table.sort( self.m_tListData, sortToLow )
    local tbconEquip = GetElement(self.m_root,"tbGemItem_WndMagicGemUpgrade",WZUITableContainer)
    tbconEquip:cleanTable()
    self.m_tGemList = {}
    if #self.m_tListData > 0 then 
    	WndGemMountingStrengthen:setGetStoneBtnVisible(false)
    else
    	WndGemMountingStrengthen:setGetStoneBtnVisible(true)
    end
    for i=1,#self.m_tListData do
    	self.m_tListData[i].isChoose = false
        local cellElement,cellObj = CellGoodItem:createElement()
        cellElement:setTag(i-1)
        cellElement:setScale(0.78)
    	cellObj:setCellGoodItem(self.m_tListData[i],30)
    	cellObj:_showGemNum(self.m_tListData[i].lastNum)
    	cellObj:_setItemVisible(bShow)
    	cellObj:setItemClickFun(self,self.onClickItem)
    	cellObj:_showGemLv(self.m_tListData[i].basicInfo.value)
    	cellObj:setBackImgFile("ui/common/common_scale9_beibaodi.png")
    	tbconEquip:setCellElement(cellElement)
    	table.insert(self.m_tGemList,cellObj)
    end
end

--@brief 快速选择
function WndMagicGemUpgrade:onQuickChoose()
        -- body
    local tGemUpInfo = GDatatab_dig_up["id_"..self.m_tGemData.id]
    local needexp = tGemUpInfo.up_exp
    WZLog("选择了宝石",self.m_nCurGemExp,self.m_nNextExp,needexp)
    local lastExp = needexp - self.m_nCurGemExp - self.m_nNextExp
    if lastExp <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.EXCEED_GEMUPGRADE)
        return
    end
    local whileExp = 0
    local tData = CopyTable(self.m_tListData)
    for i = 1,#tData do
        local lostNum = 0 -- 已选宝石的数量
        local bIsSel = false
        for j=1,#self.m_tAllSelGemData do
            if tData[i].playerItemId == self.m_tAllSelGemData[j].playerItemId then
                -- tData[i].lastNum = tData[i].lastNum - self.m_tAllSelGemData[j].lastNum
                bIsSel = true
            end
        end
        if tData[i].lastNum > 0 and bIsSel == false and tData[i].basicInfo.value < 10 then
            -- whileExp = whileExp + GDatatab_dig_up["id_"..tData[i].id].mine_exp * tData[i].lastNum
            for j = 1,tData[i].lastNum do
            	whileExp = whileExp + GDatatab_dig_up["id_"..tData[i].id].mine_exp
            	if whileExp >= lastExp then
            		tData[i].lastNum = j
            		break
            	end
            end
            table.insert(self.m_tAllSelGemData,tData[i])
            self.m_tGemList[i]:showSelectedIcon(true)
            self.m_tListData[i].isChoose = true
	        if self.m_tListData[i].lastNum > 1 then
	            self.m_tGemList[i]:_showGemNum(tData[i].lastNum,self.m_tListData[i].lastNum)
	        end
        end

        if whileExp >= lastExp then
        	break
        end
    end
    local tData1 = {}
    for i = 1,#tData do
        if tData[i].lastNum > 0 and tData[i].basicInfo.value < 10 then
            table.insert(tData1,tData[i])
        end
    end
    if next(self.m_tAllSelGemData) then
        table.sort(self.m_tAllSelGemData,sortToLow)
    end
    if next(self.m_tAllSelGemData) and next(tData1) then
        if #self.m_tAllSelGemData == #tData1 and self:isEqeal(tData1,self.m_tAllSelGemData) then
            MsgBoxManager:showTipBox(LocalStrings.NOTCHOOSE_GEMUPGRADE)
        end
    else 
        MsgBoxManager:showTipBox(LocalStrings.NOTCHOOSE_GEMUPGRADE)
    end
    self:refreshExp()
end

function WndMagicGemUpgrade:isEqeal(tab1,tab2)
    -- body
    if tab1 == {} and tab2 == {} then return true end
    for i = 1,#tab1 do
        if tab1[i].playerItemId == tab2[i].playerItemId then
            return true
        else
            return false
        end
    end
end

--@brief 刷新
function WndMagicGemUpgrade:refreshExp()
	-- body
	local GemName = {"hpStone","attackStone","defendStone","","","gongmingStone"}
	local tGemExp = {"hpGemExp","attackGemExp","defendGemExp","","","gongmingGemExp"}


    local tGemUpInfo = GDatatab_dig_up["id_"..self.m_tGemData.id]

    for _,value in pairs(GDatatab_dig_up) do
    	if value.id > 41000 and self.m_tGemData.basicInfo.sub_type == GDatatab_item["id_"..value.id].sub_type and value.behind_id == -1 then --找到当前子类型中最高阶的魔力宝石
    		if value.id == self.m_tGemData.basicInfo.id then
				WindowManager:removeWindow(self.m_root, self, true)
				return
			end
    		self.m_nMaxExp = value.mine_exp - GDatatab_dig_up["id_"..self.m_tGemData.id].mine_exp
    		break
    	end
    end

	self.m_nNextExp = 0
    for i=1,#self.m_tAllSelGemData do
    	if self.m_tAllSelGemData[i] then
    		self.m_nNextExp = self.m_nNextExp + GDatatab_dig_up["id_"..self.m_tAllSelGemData[i].id].mine_exp * self.m_tAllSelGemData[i].lastNum --宝石本身经验
    		if self.m_tAllSelGemData[i].id > 41000 then
				local nGemAddExp = 0
				if self.m_tAllSelGemData[i].extraInfo[tGemExp[self.m_tAllSelGemData[i].subtype+1]] then
					nGemAddExp = self.m_tAllSelGemData[i].extraInfo[tGemExp[self.m_tAllSelGemData[i].subtype+1]]
				end
    			self.m_nNextExp = self.m_nNextExp + nGemAddExp --魔力宝石附加的经验
			end
    	end
    end
--    GetElement(self.m_root, "txtAvailableExp_WndMagicGemUpgrade", WZUILabelTTF):setText(string.format(LocalStrings.GEM_MOUNTING_13,self.m_nNextExp))
    local stoneId = self.m_tCurSelectedEquip.extraInfo[GemName[self.m_tGemData.basicInfo.sub_type+1]]
	local level = GDatatab_item["id_" .. stoneId].value
    GetElement(self.m_root, "txtCurLv_WndMagicGemUpgrade", WZUILabelTTF):setText(LocalStrings.LV .. level)

    self.m_nCurGemExp = self.m_tCurSelectedEquip.extraInfo[tGemExp[self.m_tGemData.basicInfo.sub_type+1]] or 0
    local needexp = tGemUpInfo.up_exp
    --当前经验可提升等级
    self:setAddMaxLevel()
    self:setAddLevel(self.m_nNextExp + self.m_nCurGemExp)
    GetElement(self.m_root, "txtAddLv_WndGemMountingStrengthen", WZUILabelTTF):setText(self.m_nAddLevel)
    --更新升级后的属性数值显示
    WndGemMountingStrengthen:showPropertyAtt(2, self.m_tGemData.id, self.m_nAddLevel)

    local proExp = GetElement(self.m_root, "proExp_WndMagicGemUpgrade", WZUIProgress)
    local txtUpgrade = GetElement(self.m_root, "txtUpgrade_WndMagicGemUpgrade", WZUILabelTTF)
    local sCurExp = tostring(self.m_nCurGemExp)
    if self.m_nNextExp > 0 then 
    	sCurExp = sCurExp .. "(+" .. self.m_nNextExp .. ")"
    end
    GetElement(self.m_root, "txtExp_WndMagicGemUpgrade", WZUILabelTTF):setText(sCurExp .."/"..needexp)

    if self.m_nCurGemExp >= needexp then
    	proExp:setPercentage(100)
    else
    	proExp:setPercentage(math.floor(self.m_nCurGemExp/needexp*100))
    end
    WZLog("nfsoklfjo",tGemUpInfo.up_consume,self.m_nCurGemExp,needexp,self.m_nNextExp)
    if tGemUpInfo.up_consume ~= -1 then
    	if self.m_nCurGemExp >= needexp then
	    	txtUpgrade:setText(LocalStrings.STAR_SOUL_BUTTON_UPDATE)
	    	self.m_nOperateType = 1
    	else
    		if self.m_nNextExp + self.m_nCurGemExp >= needexp then
    			txtUpgrade:setText(LocalStrings.STAR_SOUL_BUTTON_UPDATE)
	    		self.m_nOperateType = 1
			else
				txtUpgrade:setText(LocalStrings.DEVOUR_WORDS)
				self.m_nOperateType = 2
			end
    	end
	else
    	txtUpgrade:setText(LocalStrings.DEVOUR_WORDS)
    	self.m_nOperateType = 2
	end

    local tGemUpInfo = GDatatab_dig_up["id_"..self.m_tGemData.id]
    local txtCost1 = GetElement(self.m_root, "txtCost1_WndMagicGemUpgrade", WZUILabelTTF)
    local txtCost2 = GetElement(self.m_root, "txtCost2_WndMagicGemUpgrade", WZUILabelTTF)

    if self.m_nOperateType == 1 then
	    local tTotalCost = self:getTotalCost()

	    txtCost1:setText(tTotalCost[1][2])
	    txtCost2:setText(tTotalCost[2][2])
    else
    	txtCost1:setText(0)
		txtCost2:setText(0)
	end
    if tGemUpInfo.up_consume ~= -1 then
	    GetElement(self.m_root, "imgCost1_WndMagicGemUpgrade", WZUIImage):setFile(GDatatab_item["id_"..tGemUpInfo.up_consume[1][1]].icon)
	    GetElement(self.m_root, "imgCost2_WndMagicGemUpgrade", WZUIImage):setFile(GDatatab_item["id_"..tGemUpInfo.up_consume[2][1]].icon)
		local tmpnum = CacheCenter:getPlayerItemCountById(tGemUpInfo.up_consume[2][1])
		GetElement(self.m_root, "txtCost2N_WndMagicGemUpgrade", WZUILabelTTF):setText(string.format(LocalStrings.GEM_MOUNTING_11, tmpnum))
	end
end

--@brief 点击宝石回调
function WndMagicGemUpgrade:onClickItem(tcell,tag,tData)
	-- body
	WZLog("WndMagicGemUpgrade:onClickItem",tag)
	if tData == nil then return end
	if tData.lastNum == 1 then
		if tData.isChoose == false then
			self.m_tGemList[tag+1]:showSelectedIcon(true)
			tData.isChoose = true
			table.insert(self.m_tAllSelGemData,tData)
			self:refreshExp()
		else 
			self.m_tGemList[tag+1]:removeGouIcon()
			tData.isChoose = false
			for i=1,#self.m_tAllSelGemData do
				if self.m_tAllSelGemData[i].playerItemId == tData.playerItemId then
					table.remove(self.m_tAllSelGemData,i)
					break
				end
			end
			self:refreshExp()
			return
		end
	else 
		if tData.isChoose == false then
            WndMagicGemUpgradeSelect:show(tData,tag)
            local nCount = self:getGemCanSelCount(tData)
            WndMagicGemUpgradeSelect:setNum(nCount)
       	else 
       		self.m_tGemList[tag+1]:removeGouIcon()
       		tData.isChoose = false
			for i=1,#self.m_tAllSelGemData do
				if self.m_tAllSelGemData[i].playerItemId == tData.playerItemId then
					self.m_tGemList[tag+1]:_showGemNum(tData.lastNum)
					table.remove(self.m_tAllSelGemData,i)
					break
				end
			end
			self:refreshExp()
			return
    	end
	end
end

function sortToBig(a,b)
	-- body
	if a.basicInfo.value == b.basicInfo.value then
		return a.subtype> b.subtype
	else 		
		return a.basicInfo.value > b.basicInfo.value
	end
end

function sortToLow(a,b)
	-- body
	if a.basicInfo.value == b.basicInfo.value then
		return a.subtype< b.subtype
	else 		
		return a.basicInfo.value < b.basicInfo.value
	end
end

--@brief	取消按钮
function WndMagicGemUpgrade:onCancel(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	确定按钮
function WndMagicGemUpgrade:onSure(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndMagicGemUpgrade:onSure one")
	local tGemUpInfo = GDatatab_dig_up["id_"..self.m_tGemData.id]
	local needexp = tGemUpInfo.up_exp
	if tonumber(tGemUpInfo.up_consume) == -1 and self.m_nCurGemExp >= needexp then --到了可升阶的时候提示升阶
		MsgBoxManager:showTipBox(LocalStrings.GEM_MOUNTING_14)
		return
	end

    WZLog("WndMagicGemUpgrade:onSure two")
	local count=0
	for k,v in pairs(self.m_tAllSelGemData) do
		count = count + 1
	end
    if self.m_nOperateType == 2 and count == 0 then --没放材料点吞噬
    	MsgBoxManager:showTipBox(LocalStrings.GEM_STONE3)
    	return
	end

    WZLog("WndMagicGemUpgrade:onSure four")
	local tTotalCost = self:getTotalCost()
	for i = 1, #tTotalCost do
		if tTotalCost[i][2] > 0 and not JudgeMoneyIsEnough(tTotalCost[i][1], tTotalCost[i][2], nil, nil, GlobalGame.g_nCurrentUIChannelId) then 
			return 
		end
	end

    WZLog("WndMagicGemUpgrade:onSure three")
    local str = string.format(LocalStrings.GEM_MOUNTING_4,self.m_nNextExp-self.m_nMaxExp)
    if self.m_nMaxExp < self.m_nNextExp then --经验溢出
        MsgBoxManager:showConfirmCancelBox(str, self,self.sureToDevour)
        return
    end

    WZLog("WndMagicGemUpgrade:onSure five")
	self:sureToDevour(nil, MSGBOXRESTYPE_CONFIRM)
end

--@brief	确定吞噬高级宝石的回调
--@param	nId:消息id
--@param	nResType:响应类型(超时，确定，取消)
function WndMagicGemUpgrade:sureToDevour(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
		local stoneType = nil
		if self.m_tGemData.basicInfo.sub_type == 1 then
			stoneType = 1
		elseif self.m_tGemData.basicInfo.sub_type == 2 then
			stoneType = 2
		elseif self.m_tGemData.basicInfo.sub_type == 0 then
			stoneType = 3
		elseif self.m_tGemData.basicInfo.sub_type == 5 then
			stoneType = 4
		end
		local pItemId = WZLuaVector_int_:create()
		local pNum = WZLuaVector_int_:create()
		for i=1,#self.m_tAllSelGemData do
			if self.m_tAllSelGemData[i] then
				pItemId:push(self.m_tAllSelGemData[i].playerItemId)
				pNum:push(self.m_tAllSelGemData[i].lastNum)
			end
		end

		WZLog("WndMagicGemUpgrade:sureToDevour", stoneType)
		if stoneType then
			ProtocolProcessorStrengthen:send_FORGING_GemOperate(2, self.m_tCurSelectedEquip.playerItemId, stoneType, pItemId, pNum)
		end
	end
end

--@brief	添加宝石按钮
function WndMagicGemUpgrade:onAddGem(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_curTag = element:getTag()

	if self.m_tAllSelGemData == nil then self.m_tAllSelGemData = {} end
	if self.m_tAllSelGemData[self.m_curTag] ~= nil then
		self.m_tAllSelGemData[self.m_curTag] = nil
	    local conGrid = GetElement(self.m_root,"conGrid"..self.m_curTag,WZUIContainer)
	    conGrid:removeAllChildrenWithCleanup(true)
    	self:_update()
	    return
	end

	WndSelectTipsStrengthen:showSelectTips(4)
end

--@brief    关闭界面回调
function WndMagicGemUpgrade:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManager:removeWindow(self.m_root, self, true)   
end

--@brief	选完宝石后
function WndMagicGemUpgrade:addMagicGemToCell(tItemData,tag)
	-- WZLog("WndMagicGemUpgrade:addMagicGemToCell",Serialize(tItemData))
	WZLog("WndMagicGemUpgrade:addMagicGemToCell",tag)
	self.m_tabCurSelGemData = tItemData
	self.m_tag = tag

	if tItemData and ((tItemData.basicInfo.id <= 41000 and tItemData.basicInfo.value >= 7) or tItemData.basicInfo.id > 41000) then
	   	MsgBoxManager:showConfirmCancelBox(LocalStrings.GEM_MOUNTING_12, self,self.addHighGemToCell, nil, nil, "devouring_magic_gems")
	   	return
	end

    self:addHighGemToCell(nil, MSGBOXRESTYPE_CONFIRM)
    
end

function WndMagicGemUpgrade:addHighGemToCell(nId, nResType)
	
	local tItemData = self.m_tabCurSelGemData
	if nResType == MSGBOXRESTYPE_CONFIRM then
		if self.m_tAllSelGemData == nil then self.m_tAllSelGemData = {} end
		self.m_tListData[self.m_tag+1].isChoose = true
		self.m_tGemList[self.m_tag+1]:showSelectedIcon(true)
		if self.m_tListData[self.m_tag+1].lastNum > 1 then
			self.m_tGemList[self.m_tag+1]:_showGemNum(self.m_tabCurSelGemData.lastNum,self.m_tListData[self.m_tag + 1].lastNum)
		end
		table.insert(self.m_tAllSelGemData,tItemData)
		self:refreshExp()
		-- self.m_tAllSelGemData[self.m_curTag] = tItemData

	    -- local conGrid = GetElement(self.m_root,"conGrid"..self.m_curTag,WZUIContainer)
	    -- conGrid:removeAllChildrenWithCleanup(true)
	    -- local cell,tcell = CellGoodItem:createElement()
	    -- cell = WZUIContainer:luaTo(cell)
	   	-- tcell:setCellGoodItem(tItemData, 4)
	    -- conGrid:addChild(cell)
	else
		-- if self.m_tAllSelGemData == nil then self.m_tAllSelGemData = {} end
		-- self.m_tAllSelGemData[self.m_curTag] = nil
	 --    local conGrid = GetElement(self.m_root,"conGrid"..self.m_curTag,WZUIContainer)
	 --    conGrid:removeAllChildrenWithCleanup(true)
	end
    -- self:_update()
end


--@brief	清空格子
function WndMagicGemUpgrade:cleanGemCell()
	self.m_nOperateType = nil
	self.m_tAllSelGemData = {}
	self.m_nMaxExp = 0
	self.m_nNextExp = 0
	-- for i=1, 3 do
	-- 	local conGrid = GetElement(self.m_root,"conGrid"..i,WZUIContainer)
	-- 	conGrid:removeAllChildrenWithCleanup(true)
	-- end

	self:refreshEquipmentData()
end

function WndMagicGemUpgrade:refreshEquipmentData(  )
		--刷新
	local tEquip
	local equipList = CacheCenter:getEquipList()
	for k,v in pairs(equipList) do
		if v.playerItemId == self.m_tCurSelectedEquip.playerItemId then
			tEquip = v
		end
	end
	self.m_tCurSelectedEquip = tEquip
	WndStrengthen:updateCellEquip(tEquip)
	local LuaObj = {"m_specialStoneLuaObj","m_attackStoneLuaObj","m_defenseStoneLuaObj","","","m_extremeStoneLuaObj"}
	if self.m_tGemData == nil then return end 
	self.m_tGemData = WndGemMountingStrengthen[LuaObj[self.m_tGemData.basicInfo.sub_type+1]].m_tItem
end

--@brief 	点击加号按钮回调
function WndMagicGemUpgrade:onClickAddLevel(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nAddLevel >= self.m_nMaxAddLevel then 
		MsgBoxManager:showTipBox(LocalStrings.GEM_MOUNTING_14)
		return 
	else
		local tGemUpInfo = GDatatab_dig_up["id_"..self.m_tGemData.id]
	    local needexp = self:getNeedExp(self.m_nAddLevel + 1)
	    WZLog("WndMagicGemUpgrade:onClickAddLevel",self.m_nCurGemExp, self.m_nNextExp,needexp)
	    local lastExp = needexp - self.m_nCurGemExp - self.m_nNextExp
	    if lastExp <= 0 then
	        self.m_nAddLevel = self.m_nAddLevel + 1 
	        self:refreshExp()
	        return
	    end
	    local whileExp = 0
	    local tData = CopyTable(self.m_tListData)
	    for i = 1,#tData do
	        local lostNum = 0 -- 已选宝石的数量
	        local bIsSel = false
	        for j=1,#self.m_tAllSelGemData do
	            if tData[i].playerItemId == self.m_tAllSelGemData[j].playerItemId then
	                -- tData[i].lastNum = tData[i].lastNum - self.m_tAllSelGemData[j].lastNum
	                bIsSel = true
	            end
	        end
	        if tData[i].lastNum > 0 and bIsSel == false and tData[i].basicInfo.value < 10 then
	            for j = 1,tData[i].lastNum do
	            	whileExp = whileExp + GDatatab_dig_up["id_"..tData[i].id].mine_exp
	            	if whileExp >= lastExp then
	            		tData[i].lastNum = j
	            		break
	            	end
	            end
	            table.insert(self.m_tAllSelGemData,tData[i])
	            self.m_tGemList[i]:showSelectedIcon(true)
	            self.m_tListData[i].isChoose = true
		        if self.m_tListData[i].lastNum > 1 then
		            self.m_tGemList[i]:_showGemNum(tData[i].lastNum,self.m_tListData[i].lastNum)
		        end
	        end

	        if whileExp >= lastExp then
	        	self.m_nAddLevel = self.m_nAddLevel + 1 
	        	self:refreshExp()
	        	return 
	        end
	    end
	    local tData1 = {}
	    for i = 1,#tData do
	        if tData[i].lastNum > 0 and tData[i].basicInfo.value < 10 then
	            table.insert(tData1,tData[i])
	        end
	    end
	    if next(self.m_tAllSelGemData) then
	        table.sort(self.m_tAllSelGemData,sortToLow)
	    end
	    if next(self.m_tAllSelGemData) and next(tData1) then
	        if #self.m_tAllSelGemData == #tData1 and self:isEqeal(tData1,self.m_tAllSelGemData) then
	            MsgBoxManager:showTipBox(LocalStrings.NOTCHOOSE_GEMUPGRADE)
	        end
	    else 
	        MsgBoxManager:showTipBox(LocalStrings.NOTCHOOSE_GEMUPGRADE)
	    end
	    self:refreshExp()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
