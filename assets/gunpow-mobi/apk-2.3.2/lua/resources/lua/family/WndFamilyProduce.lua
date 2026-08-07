--WndFamilyProduce.lua
--@brief	WndFamilyProduce的UI模块
--@date		2018/02/06
--@author	Tianxiang_Xu
--@note		家园打工和看守界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFamilyProduce:onEnter(element)
	self.m_root = element

	CacheCenter:registerUpatePlayerItemObserver(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFamilyProduce:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
end

--@brief 	界面加载完成回调
function WndFamilyProduce:onEnterTransitionDidFinish(element)
	-- body
	local sMorePetComfig = CacheCenter:getGameParam().openServantConfig
	self.m_tAddMorePetData = json.decode(sMorePetComfig)
	local hasPetInfo = CacheCenter:hasPlayerPetInfo()
    WZLog("WndFamilyProduce:onEnterTransitionDidFinish:",hasPetInfo,sMorePetComfig)
    if true or hasPetInfo ==false then
        --获取宠物缓存信息
        SceneFamily:_createLoading()
        ProtocolProcessorFamily:send_PET_GetAllPetList()
    else
    	if self.m_nLeftTabIndex == 0 then
	        self:generalPetList()

	        self:_showPetList()
	    end
    end

    ProtocolProcessorFamily:send_HOME_GetServrantEfficiency()

	self.m_tWorkEffect = json.decode(CacheCenter:getGameParam().servantWorkEfficiency)
    WZLog("WndFamilyProduce:onEnterTransitionDidFinish:",Serialize(self.m_tWorkEffect))
	GetElement(self.m_root, "checkGroup_WndFamilyProduce", WZUICheckBoxGroup):setCheckIndex(self.m_nLeftTabIndex)
	self.m_nMaxEffectCostCount = self:_getUpEffectMaxCount()
	self:setMountData()

	self:_setStaticText()
	self:_update()

	AdaptLanguage(self)
end

--@brief 	点击关闭按钮回调
function WndFamilyProduce:onBackClick(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击打工或守卫标签回调
function WndFamilyProduce:onClickTab(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local nTag = element:getTag()
	if self.m_nLeftTabIndex == nTag then return end

	self.m_nLeftTabIndex = nTag 
	if self.m_nLeftTabIndex == 0 then
		local hasPetInfo  =  CacheCenter:hasPlayerPetInfo()
	    if true or hasPetInfo ==false then
	        --获取宠物缓存信息
	        SceneFamily:_createLoading()
	        ProtocolProcessorFamily:send_PET_GetAllPetList()
	    else
	    	if self.m_nLeftTabIndex == 0 then
		        self:generalPetList()
		    end
		end
	end
	self:_update()
end

--@brief	点击开始打工按钮回调
function WndFamilyProduce:onClickWork(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local usingNum = #SceneFamily.m_tWorkerData
	local tNextData = self:getNextMorePetNumData(SceneFamily:getMaxPetNum())
	if usingNum >= SceneFamily:getMaxPetNum() then
		if tNextData then
			local id, num = SplitItemString(tNextData.item)
			local tBasicData = GDatatab_item["id_" .. id[1]]
			MsgBoxManager:showConfirmBox(string.format(LocalStrings.FAMILY_TEXT70, tonumber(num[1]), tBasicData.name, tNextData.num), self, self.openNextPet)
		else
			MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT61)
		end
		return 
	end

	if self.m_nPetSelId == nil then
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT84)
		return 
	end
	ProtocolProcessorFamily:send_HOME_EmployServant(self.m_nPetSelId)
end

--@brief 	确定开启下一个宠物打工仔
function WndFamilyProduce:openNextPet()
	-- body
	local tNextData = self:getNextMorePetNumData(SceneFamily:getMaxPetNum())
	if tNextData and tNextData.level > CacheCenter:getPlayerInfo().level then
		MsgBoxManager:showTipBox(string.format(LocalStrings.FAMILY_TEXT71, tNextData.level))
		return 
	end

	local id, num = SplitItemString(tNextData.item)

	if not JudgeMoneyIsEnough(tonumber(id[1]), tonumber(num[1]), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, ProtocolProcessorFamily, ProtocolProcessorFamily.send_HOME_AddServant) then
		return 
	end

	ProtocolProcessorFamily:send_HOME_AddServant()
end

--@brief	点击提高效率按钮回调
function WndFamilyProduce:onClickEffect(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if self.m_nCurWorkEffectIndex >= 4 then 
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT51)
		return 
	end

	local cost = self:_getUpEffectCost()
	if not JudgeMoneyIsEnough(cost[1], cost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamond) then
		return 
	end
	self:sureToUseDiamond()
end

--@brief 	确定用钻石代替粉钻提升效率
function WndFamilyProduce:sureToUseDiamond()
	-- body
	--发送提升效率的协议
	ProtocolProcessorFamily:send_HOME_RefreshServrantEfficiency()
end

--@brief	点击喂食按钮回调
function WndFamilyProduce:onClickFeed(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	GetElement(self.m_root, "conFirst_WndFamilyProduce", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conSecond_WndFamilyProduce", WZUIContainer):setVisible(true)
	self.m_nProtectIndex = 2
	self:_update()
end

--@brief	点击开始看守按钮回调
function WndFamilyProduce:onClickProtect(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nMountSelId == SceneFamily.m_nProtectMountId then
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT60)
		return 
	end

	if not SceneFamily.m_nLeftProtectTime or SceneFamily.m_nLeftProtectTime <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT48)
		return 
	end

	local buildingLevel = SceneFamily:getBuildingLevel(1, 7)
	local basicData = GDatatab_guardromon["id_" .. self.m_nMountSelId]
	if basicData.type > buildingLevel then
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT69)
		return 
	end
	--发送看守协议
	ProtocolProcessorFamily:send_HOME_StartGuard(self.m_nMountSelId)
end

--@brief	点击喂食按钮回调
function WndFamilyProduce:onClickStartFeed(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tRecoverConfig = json.decode(CacheCenter:getGameParam().homeThiefConfig) 
	local nHour = tRecoverConfig.maxGuardHour

	if SceneFamily.m_nLeftProtectTime >= nHour*3600 then
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT49)
		return
	end
	--发喂食协议
	local tTempData = self.m_tFoodData[self.m_nFoodSelIndex]
	if not JudgeMoneyIsEnough(tTempData.id, 1, nil, nil, GlobalGame.g_nCurrentUIChannelId) then
		return 
	end

	ProtocolProcessorFamily:send_HOME_FeedGuardromon(tTempData.id, 1)
end

--@brief	点击返回按钮回调
function WndFamilyProduce:onClickReturn(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conFirst_WndFamilyProduce", WZUIContainer):setVisible(true)
	GetElement(self.m_root, "conSecond_WndFamilyProduce", WZUIContainer):setVisible(false)
	self.m_nProtectIndex = 1
	self:_update()
end

--@brief 	点击食物回调
function WndFamilyProduce:onClickFood(element)
	-- body
	local nTag = element:getTag()
	WZLog("WndFamilyProduce:onClickFood", nTag)
	self.m_nFoodSelIndex = nTag	
	GetElement(self.m_root, "conFoodSelected_WndFamilyProduce", WZUIContainer):setRelativePosition(GlobalMethod:ccp(self.m_tFoodPosition[self.m_nFoodSelIndex][1], self.m_tFoodPosition[self.m_nFoodSelIndex][2])) 
end

--@brief 	点击坐骑头像回调
function WndFamilyProduce:onClickMountHead(luaTable,tag,tData)
	-- body
	-- local bVisible = luaTable:getItemGray()
	-- if bVisible then 
	-- 	MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT69)
	-- 	return 
	-- end
	local tTempData = self:_getProtectMountDataByItemId(tData.basicInfo.id)
	if self.m_nMountSelId == tTempData.id then return end 
	if self.m_tClickMountCell then
		self.m_tClickMountCell:setItemSelState(false)
	end
	self.m_tClickMountCell = luaTable
	self.m_tClickMountCell:setItemSelState(true)
	self.m_nMountSelId = tTempData.id
	self:_showProtectRole()
end

--@brief 	点击宠物头像回调
function WndFamilyProduce:onClickPetHead(luaTable, tData)
	-- body
	if self.m_nPetSelId == tData.playerPetId then return end 
	if self.m_tClickPetCell then
		self.m_tClickPetCell:setItemSelState(false)
	end

	self.m_tClickPetCell = luaTable 
	self.m_tClickPetCell:setItemSelState(true)
	self.m_nPetSelId = tData.playerPetId
end

--@brief 	点击打工效率条回调
function WndFamilyProduce:onClickEffectItem(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT81)
end

--@brief 	点击规则按钮回调
function WndFamilyProduce:onClickRule(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndSingleMapDesc:showInterface1(LocalStrings.FAMILY_TEXT82)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置静态文本
function WndFamilyProduce:_setStaticText()
	-- body
	local txtLuckyWorld = GetElement(self.m_root, "txtLuckyWorld_WndFamilyProduce", WZUILabelTTF)
	if txtLuckyWorld then
		txtLuckyWorld:setText(LocalStrings.LUCKVALUE .. ":")
	end
end

--@brief 	界面刷新
function WndFamilyProduce:_update()
	-- body
	local txtTitleName = GetElement(self.m_root, "txtTitleName_WndFamilyProduce", WZUILabelTTF)

	if self.m_nLeftTabIndex == 0 then
		txtTitleName:setText(LocalStrings.FAMILY_TEXT37)
		GetElement(self.m_root, "conWork_WndFamilyProduce", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conProtect_WndFamilyProduce", WZUIContainer):setVisible(false)
		self:_showPetList()
		self:_showWork()
	else
		txtTitleName:setText(LocalStrings.FAMILY_TEXT38)
		GetElement(self.m_root, "conWork_WndFamilyProduce", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conProtect_WndFamilyProduce", WZUIContainer):setVisible(true)
		self:_showMountsList()
		if self.m_nProtectIndex == 1 then	--看守特性界面
			GetElement(self.m_root, "conFirst_WndFamilyProduce", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "conSecond_WndFamilyProduce", WZUIContainer):setVisible(false)
			self:_showProtectRole()
		else 	--看守喂食界面
			GetElement(self.m_root, "conFirst_WndFamilyProduce", WZUIContainer):setVisible(false)
			GetElement(self.m_root, "conSecond_WndFamilyProduce", WZUIContainer):setVisible(true)
			self:_showFood()
		end
	end
end

--@brief 	展示打工界面
function WndFamilyProduce:_showWork()
	-- body
	--打工效率
	for i = 1, #self.m_tWorkEffect do
		local ftxtEfficiency = GetElement(self.m_root, "ftxtEfficiency" .. i .. "_WndFamilyProduce", WZUIFreeTextBox)
		if ftxtEfficiency then 
			local ids, num = SplitItemString(self.m_tWorkEffect[i].reward)
			local tBasicData = GDatatab_item["id_" .. ids[1]]
			ftxtEfficiency:setShowText(string.format(LocalStrings.FAMILY_TEXT57, self.m_tWorkEffect[i].name, math.floor(self.m_tWorkEffect[i].time/3600), tonumber(num[1]), tBasicData.icon))
		end
	end

	self:setWorkEffect()
end

--@brief 	设置打工幸运值
function WndFamilyProduce:setWorkEffect()
	-- body
	GetElement(self.m_root, "conEffectSelected_WndFamilyProduce", WZUIContainer):setRelativePosition(GlobalMethod:ccp(self.m_tEffectPosition[self.m_nCurWorkEffectIndex][1], self.m_tEffectPosition[self.m_nCurWorkEffectIndex][2]))
	--幸运值
	local prgConsume = GetElement(self.m_root, "prgConsume_WndBuyActivity", WZUIProgress)
	if prgConsume then
		prgConsume:setPercentage(math.floor(self.m_nCurLuckyValue))
	end
	local txtPrgWork = GetElement(self.m_root, "txtPrgWork_WndFamilyProduce", WZUILabelTTF)
	if txtPrgWork then
		txtPrgWork:setText(self.m_nCurLuckyValue .. "/" .. self.m_nMaxLuckyValue)
	end
	--提高效率花费
	local ftxtEffectCost = GetElement(self.m_root, "ftxtEffectCost_WndFamilyProduce", WZUIFreeTextBox)
	if ftxtEffectCost then
		local cost = self:_getUpEffectCost()
		if cost then 
			local sFormatCost = [[<T C="127,70,26" S="18" P="1">%s</T><T C="229,105,22" S="18" P="1">%d</T><I Z = "0.45">%s</I>]]
			ftxtEffectCost:setShowText(string.format(sFormatCost, LocalStrings.COST, cost[2], GDatatab_item["id_" .. cost[1]].icon))
		end
	end
end

--@brief 	显示食物界面
function WndFamilyProduce:_showFood()
	-- body
	self:_getFoodData()

	for i = 1, #self.m_tFoodData do
		local imgFoodIcon = GetElement(self.m_root, "imgFoodIcon" .. i .. "_WndFamilyProduce", WZUIImage)
		local txtItemName = GetElement(self.m_root, "txtItemName" .. i .. "_WndFamilyProduce", WZUILabelTTF)
		local txtDesc = GetElement(self.m_root, "txtDesc" .. i .. "_WndFamilyProduce", WZUILabelTTF)

		local tBasicData = self.m_tFoodData[i]
		local nNum = CacheCenter:getPlayerItemCountById(tBasicData.id)

		if tBasicData then
			imgFoodIcon:setFile(tBasicData.icon) 
			txtItemName:setText(tBasicData.name .. string.format(LocalStrings.PETHASNUM, nNum))
			txtDesc:setText(tBasicData.desc)
		end
	end

	GetElement(self.m_root, "conFoodSelected_WndFamilyProduce", WZUIContainer):setRelativePosition(GlobalMethod:ccp(self.m_tFoodPosition[self.m_nFoodSelIndex][1], self.m_tFoodPosition[self.m_nFoodSelIndex][2])) 
end

--@brief 	显示看守兽的特性
function WndFamilyProduce:_showProtectRole()
	-- body
	local tData = self:_getProtectMountData(self.m_nMountSelId)
	--当前选中的看守兽的名字
	local txtMountName = GetElement(self.m_root, "txtMountName_WndFamilyProduce", WZUILabelTTF)
	if txtMountName then
		txtMountName:setText(tData.name)
	end
	--看守兽的形象
	local conForAni = GetElement(self.m_root, "conForAni_WndFamilyProduce", WZUIContainer)
	self:_createMountAni(conForAni, tData)
	--看守兽的特性
	local txtPropertyAtt = GetElement(self.m_root, "txtPropertyAtt_WndFamilyProduce", WZUILabelTTF)
	if txtPropertyAtt then
		txtPropertyAtt:setText(string.format(LocalStrings.FAMILY_TEXT56, math.floor(tData.value/100)))
	end
	--剩余看守时间
	self:_showLeftProtectTime()
end

--@brief 	显示剩余看守时间
function WndFamilyProduce:_showLeftProtectTime()
	-- body
	if self.m_root == nil then return end
	if self.m_nLeftTabIndex == 0 then return end 
	WZLog("WndFamilyProduce:_showLeftProtectTime", SceneFamily.m_nLeftProtectTime)
	local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_conProtect", WZUIFreeTextBox)
	if ftxtLeftTime then
		if SceneFamily.m_nLeftProtectTime > 0 then
			local sTime = returnToTimeFormat(SceneFamily.m_nLeftProtectTime)
			ftxtLeftTime:setShowText(string.format(LocalStrings.FAMILY_TEXT47, sTime))
		else
			local sFormat = [[<T C="127,70,26" S="18" P="1">%s</T>]]
			ftxtLeftTime:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT48))
		end
	end
end

-- 坐骑动画
function WndFamilyProduce:_createMountAni(con, info)
    local sex = CacheCenter:getPlayerInfo().sex == 1 and true or false
    if con:getChildByTag(99) then con:removeChildByTag(99,true) end

    local head,body = CacheCenter:getHeadAndBodyColor()
    local ani = CreatePlayerFigure(sex, nil, "mount_show",nil,nil,nil,nil,nil,nil,nil,head,body,false)
    ani:setMount(info.basicInfo.animation_index_code)

    local node = ani:getAnimNode()
    node:setScale(0.6)
--    node:setRelativePosition(GlobalMethod:ccp(0.5, 0.52))
    con:addChild(node,0,99)
end

--@brief 	显示守卫兽列表
function WndFamilyProduce:_showMountsList()
	-- body
	local tbcon = GetElement(self.m_root, "tbcon_WndFamilyProduce", WZUITableContainer)
	tbcon:cleanTable()
	local conLeft = GetElement(self.m_root, "conLeft_WndFamilyProduce", WZUIContainer)
	removeShowPanelNullTip(conLeft)

	tbcon:setLoadCountPerFrame(4)
	GetElement(self.m_root, "ftxtWorkNum_WndFamilyProduce", WZUIFreeTextBox):setVisible(false)
	GetElement(self.m_root, "txtListName_WndFamilyProduce", WZUILabelTTF):setText(LocalStrings.FAMILY_TEXT46)

	local buildingLevel = SceneFamily:getBuildingLevel(1, 7)
	WZLog("WndFamilyProduce:_showMountsList", buildingLevel)
	for i = 1, #self.m_tMountsList do
		local cellElement,tcell = CellGoodItem:createElement()
        if cellElement then
            cellElement = WZUIContainer:luaTo(cellElement)
            tcell:setCellGoodLocalId(self.m_tMountsList[i].item_id, 1, 10)
            tcell:_setItemVisible(false)
            tcell:setItemClickFun(self, self.onClickMountHead)
            cellElement:setTag(i - 1)
            tbcon:setCellElement(cellElement)
            if self.m_tMountsList[i].id == self.m_nMountSelId then
            	tcell:setItemSelState(true)
            	self.m_tClickMountCell = tcell
            end
            if SceneFamily.m_nProtectMountId and self.m_tMountsList[i].id == SceneFamily.m_nProtectMountId then
            	tcell:setItemStateWord(LocalStrings.FAMILY_TEXT60)
            end
            if self.m_tMountsList[i].type > buildingLevel then
            	tcell:setItemGray(true)
            end 
        end
	end
end

--@brief 	显示宠物列表
function WndFamilyProduce:_showPetList()
	-- body
	WZLog("WndFamilyProduce:_showPetList", Serialize(self.m_tPetsList))
	local tbcon = GetElement(self.m_root, "tbcon_WndFamilyProduce", WZUITableContainer)
	tbcon:cleanTable()
	tbcon:setLoadCountPerFrame(4)
	local ftxtWorkNum = GetElement(self.m_root, "ftxtWorkNum_WndFamilyProduce", WZUIFreeTextBox)
	ftxtWorkNum:setVisible(true)
	GetElement(self.m_root, "txtListName_WndFamilyProduce", WZUILabelTTF):setText(LocalStrings.MY_PETS)
	if self.m_tPetsList == nil then return end 
	local usingNum = #SceneFamily.m_tWorkerData
	ftxtWorkNum:setShowText(string.format(LocalStrings.FAMILY_TEXT39, usingNum, SceneFamily:getMaxPetNum()))
	local conLeft = GetElement(self.m_root, "conLeft_WndFamilyProduce", WZUIContainer)
	if #self.m_tPetsList == 0 then
		ShowPanelNullTip( conLeft, LocalStrings.FAMILY_TEXT84)
		return 
	end
	removeShowPanelNullTip(conLeft)

	if self.m_nPetSelId == nil then 
		if self.m_tPetsList[1].useIndex == 0 then
			self.m_nPetSelId = self.m_tPetsList[1].playerPetId
		end
	end

	for i = 1, #self.m_tPetsList do
		local cellElement, tcell = CellFamilyPetHead:createElement()
        if cellElement then
            cellElement = WZUIContainer:luaTo(cellElement)
            tcell:setData(self.m_tPetsList[i])
            tcell:setItemClickFun(self, self.onClickPetHead)
            cellElement:setTag(i - 1)
            tbcon:setCellElement(cellElement)
            if self.m_nPetSelId == self.m_tPetsList[i].playerPetId then
            	tcell:setItemSelState(true)
            	self.m_tClickPetCell = tcell
            end
        end
	end

end

--@brief 	设置宠物打工仔的使用数量
function WndFamilyProduce:setPetUseNum()
	-- body
	local ftxtWorkNum = GetElement(self.m_root, "ftxtWorkNum_WndFamilyProduce", WZUIFreeTextBox)
	local usingNum = #SceneFamily.m_tWorkerData
	ftxtWorkNum:setShowText(string.format(LocalStrings.FAMILY_TEXT39, usingNum, SceneFamily:getMaxPetNum()))
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function WndFamilyProduce:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtCheck1_1_WndFamilyProduce",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCheck1_2_WndFamilyProduce",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCheck2_1_WndFamilyProduce",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCheck2_2_WndFamilyProduce",WZUILabelTTF):setScale(0.8)
	
	GetElement(self.m_root, "txtListName_WndFamilyProduce", WZUILabelTTF):setScale(0.75)

	GetElement(self.m_root, "txtbtnWork2_WndFamilyProduce", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtProtectFirst2_WndFamilyProduce", WZUILabelTTF):setScale(0.7)

	local txtLuckyWorld = GetElement(self.m_root, "txtLuckyWorld_WndFamilyProduce", WZUILabelTTF)
	txtLuckyWorld:setScale(0.8)
	txtLuckyWorld:setDimensions(GlobalMethod:CCSize(100))

	for i = 1, 4 do
		local ftxtEfficiency = GetElement(self.m_root, "ftxtEfficiency" .. i .. "_WndFamilyProduce", WZUIFreeTextBox)
		if ftxtEfficiency then
			ftxtEfficiency:setScale(0.8)
		end
	end
end

function WndFamilyProduce:_adaptLanguage_en(  )
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_1_WndFamilyProduce",WZUILabelTTF)
	txtCheck1:setScale(0.8)
	txtCheck1:setDimensions(GlobalMethod:CCSize(100,0))
	
	local txtCheck2 = GetElement(self.m_root,"txtCheck1_2_WndFamilyProduce",WZUILabelTTF)
	txtCheck2:setScale(0.8)
	txtCheck2:setDimensions(GlobalMethod:CCSize(100,0))

	local txtbtnWork2 = GetElement(self.m_root, "txtbtnWork2_WndFamilyProduce", WZUILabelTTF)
	txtbtnWork2:setScale(0.7)
	txtbtnWork2:setDimensions(GlobalMethod:CCSize(120,0))

	for i=1,3 do
		local txtbtnWork1 = GetElement(self.m_root, "txtbtnWork1_"..i.."_WndFamilyProduce", WZUILabelTTF)
		txtbtnWork1:setScale(0.7)
		txtbtnWork1:setDimensions(GlobalMethod:CCSize(120,0))
	end

	local txtLuckyWorld = GetElement(self.m_root, "txtLuckyWorld_WndFamilyProduce", WZUILabelTTF)
	txtLuckyWorld:setScale(0.8)
	txtLuckyWorld:setDimensions(GlobalMethod:CCSize(100))

	for i = 1, 4 do
		local ftxtEfficiency = GetElement(self.m_root, "ftxtEfficiency" .. i .. "_WndFamilyProduce", WZUIFreeTextBox)
		if ftxtEfficiency then
			ftxtEfficiency:setScale(0.8)
		end
	end

	GetElement(self.m_root,"txtLuckPrg_WndFamilyProduce",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.6))

	for i=1,4 do
		local txtDesc = GetElement(self.m_root,"txtDesc"..i.."_WndFamilyProduce",WZUILabelTTF)
		txtDesc:setDimensions(GlobalMethod:CCSize(220,0))
		txtDesc:setScale(0.8)
	end
end

function WndFamilyProduce:_adaptLanguage_th(  )
	GetElement(self.m_root, "txtbtnWork2_WndFamilyProduce", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtProtectFirst2_WndFamilyProduce", WZUILabelTTF):setScale(0.9)

	local txtLuckyWorld = GetElement(self.m_root, "txtLuckyWorld_WndFamilyProduce", WZUILabelTTF)
	txtLuckyWorld:setScale(0.8)
	txtLuckyWorld:setDimensions(GlobalMethod:CCSize(100))

	for i = 1, 4 do
		local ftxtEfficiency = GetElement(self.m_root, "ftxtEfficiency" .. i .. "_WndFamilyProduce", WZUIFreeTextBox)
		if ftxtEfficiency then
			ftxtEfficiency:setScale(0.8)
		end
	end
end

function WndFamilyProduce:_adaptLanguage_pt(  )
	local txtbtnWork1_1 = GetElement(self.m_root,"txtbtnWork1_1_WndFamilyProduce",WZUILabelTTF)
	txtbtnWork1_1:setScale(0.7)
	txtbtnWork1_1:setDimensions(GlobalMethod:CCSize(160))
	local txtbtnWork1_2 = GetElement(self.m_root,"txtbtnWork1_2_WndFamilyProduce",WZUILabelTTF)
	txtbtnWork1_2:setScale(0.7)
	txtbtnWork1_2:setDimensions(GlobalMethod:CCSize(160))
	local txtbtnWork1_3 = GetElement(self.m_root,"txtbtnWork1_3_WndFamilyProduce",WZUILabelTTF)
	txtbtnWork1_3:setScale(0.7)
	txtbtnWork1_3:setDimensions(GlobalMethod:CCSize(160))
	local txtbtnWork2 = GetElement(self.m_root, "txtbtnWork2_WndFamilyProduce", WZUILabelTTF)
	txtbtnWork2:setScale(0.7)
	txtbtnWork2:setDimensions(GlobalMethod:CCSize(160))
	local txtProtectFirst2 = GetElement(self.m_root, "txtProtectFirst2_WndFamilyProduce", WZUILabelTTF)
	txtProtectFirst2:setScale(0.7)
	txtProtectFirst2:setDimensions(GlobalMethod:CCSize(160))

	local txtLuckyWorld = GetElement(self.m_root, "txtLuckyWorld_WndFamilyProduce", WZUILabelTTF)
	txtLuckyWorld:setScale(0.7)
	txtLuckyWorld:setDimensions(GlobalMethod:CCSize(100))
	local txtLuckPrg = GetElement(self.m_root,"txtLuckPrg_WndFamilyProduce",WZUILabelTTF)
	txtLuckPrg:setDimensions(GlobalMethod:CCSize(240))
	txtLuckPrg:setRelativePosition(GlobalMethod:ccp(0.58,0.714286))

	local txtCheck1_1 = GetElement(self.m_root,"txtCheck1_1_WndFamilyProduce",WZUILabelTTF)
	txtCheck1_1:setScale(0.8)
	txtCheck1_1:setDimensions(GlobalMethod:CCSize(100,0))
	local txtCheck1_2 = GetElement(self.m_root,"txtCheck1_2_WndFamilyProduce",WZUILabelTTF)
	txtCheck1_2:setScale(0.8)
	txtCheck1_2:setDimensions(GlobalMethod:CCSize(100,0))
	local txtCheck2_1 = GetElement(self.m_root,"txtCheck2_1_WndFamilyProduce",WZUILabelTTF)
	txtCheck2_1:setScale(0.8)
	txtCheck2_1:setDimensions(GlobalMethod:CCSize(100,0))
	local txtCheck2_2 = GetElement(self.m_root,"txtCheck2_2_WndFamilyProduce",WZUILabelTTF)
	txtCheck2_2:setScale(0.8)
	txtCheck2_2:setDimensions(GlobalMethod:CCSize(100,0))

	for i = 1, 4 do
		local ftxtEfficiency = GetElement(self.m_root, "ftxtEfficiency" .. i .. "_WndFamilyProduce", WZUIFreeTextBox)
		if ftxtEfficiency then
			ftxtEfficiency:setScale(0.8)
		end
		local txtItemName = GetElement(self.m_root, "txtItemName" .. i .. "_WndFamilyProduce", WZUILabelTTF)
		if txtItemName then
			txtItemName:setDimensions(GlobalMethod:CCSize(230))
			txtItemName:setRelativePosition(GlobalMethod:ccp(0.26,0.75))			
		end
		local txtDesc = GetElement(self.m_root, "txtDesc" .. i .. "_WndFamilyProduce", WZUILabelTTF)
		if txtDesc then
			txtDesc:setDimensions(GlobalMethod:CCSize(230))
			txtDesc:setRelativePosition(GlobalMethod:ccp(0.26,0.62))
		end
	end
	local txtListName = GetElement(self.m_root, "txtListName_WndFamilyProduce", WZUILabelTTF)
	txtListName:setScale(0.74)
	txtListName:setDimensions(GlobalMethod:CCSize(170))
end

function WndFamilyProduce:_adaptLanguage_es(  )
	local txtbtnWork1_1 = GetElement(self.m_root,"txtbtnWork1_1_WndFamilyProduce",WZUILabelTTF)
	txtbtnWork1_1:setScale(0.7)
	txtbtnWork1_1:setDimensions(GlobalMethod:CCSize(160))
	local txtbtnWork1_2 = GetElement(self.m_root,"txtbtnWork1_2_WndFamilyProduce",WZUILabelTTF)
	txtbtnWork1_2:setScale(0.7)
	txtbtnWork1_2:setDimensions(GlobalMethod:CCSize(160))
	local txtbtnWork1_3 = GetElement(self.m_root,"txtbtnWork1_3_WndFamilyProduce",WZUILabelTTF)
	txtbtnWork1_3:setScale(0.7)
	txtbtnWork1_3:setDimensions(GlobalMethod:CCSize(160))
	local txtbtnWork2 = GetElement(self.m_root, "txtbtnWork2_WndFamilyProduce", WZUILabelTTF)
	txtbtnWork2:setScale(0.7)
	txtbtnWork2:setDimensions(GlobalMethod:CCSize(160))
	local txtProtectFirst2 = GetElement(self.m_root, "txtProtectFirst2_WndFamilyProduce", WZUILabelTTF)
	txtProtectFirst2:setScale(0.7)
	txtProtectFirst2:setDimensions(GlobalMethod:CCSize(160))

	local txtLuckyWorld = GetElement(self.m_root, "txtLuckyWorld_WndFamilyProduce", WZUILabelTTF)
	txtLuckyWorld:setScale(0.7)
	txtLuckyWorld:setDimensions(GlobalMethod:CCSize(100))
	local txtLuckPrg = GetElement(self.m_root,"txtLuckPrg_WndFamilyProduce",WZUILabelTTF)
	txtLuckPrg:setDimensions(GlobalMethod:CCSize(240))
	txtLuckPrg:setRelativePosition(GlobalMethod:ccp(0.58,0.714286))

	local txtCheck1_1 = GetElement(self.m_root,"txtCheck1_1_WndFamilyProduce",WZUILabelTTF)
	txtCheck1_1:setScale(0.8)
	txtCheck1_1:setDimensions(GlobalMethod:CCSize(100,0))
	local txtCheck1_2 = GetElement(self.m_root,"txtCheck1_2_WndFamilyProduce",WZUILabelTTF)
	txtCheck1_2:setScale(0.8)
	txtCheck1_2:setDimensions(GlobalMethod:CCSize(100,0))
	local txtCheck2_1 = GetElement(self.m_root,"txtCheck2_1_WndFamilyProduce",WZUILabelTTF)
	txtCheck2_1:setScale(0.8)
	txtCheck2_1:setDimensions(GlobalMethod:CCSize(100,0))
	local txtCheck2_2 = GetElement(self.m_root,"txtCheck2_2_WndFamilyProduce",WZUILabelTTF)
	txtCheck2_2:setScale(0.8)
	txtCheck2_2:setDimensions(GlobalMethod:CCSize(100,0))

	for i = 1, 4 do
		local ftxtEfficiency = GetElement(self.m_root, "ftxtEfficiency" .. i .. "_WndFamilyProduce", WZUIFreeTextBox)
		if ftxtEfficiency then
			ftxtEfficiency:setScale(0.8)
		end
		local txtItemName = GetElement(self.m_root, "txtItemName" .. i .. "_WndFamilyProduce", WZUILabelTTF)
		if txtItemName then
			txtItemName:setDimensions(GlobalMethod:CCSize(230))
			txtItemName:setRelativePosition(GlobalMethod:ccp(0.26,0.75))			
		end
		local txtDesc = GetElement(self.m_root, "txtDesc" .. i .. "_WndFamilyProduce", WZUILabelTTF)
		if txtDesc then
			txtDesc:setDimensions(GlobalMethod:CCSize(230))
			txtDesc:setRelativePosition(GlobalMethod:ccp(0.26,0.62))
		end
	end
	local txtListName = GetElement(self.m_root, "txtListName_WndFamilyProduce", WZUILabelTTF)
	txtListName:setScale(0.74)
	txtListName:setDimensions(GlobalMethod:CCSize(170))
end

function WndFamilyProduce:_adaptLanguage_tr(  )
	local txtListName = GetElement(self.m_root, "txtListName_WndFamilyProduce", WZUILabelTTF)
	txtListName:setScale(0.74)
	txtListName:setDimensions(GlobalMethod:CCSize(170))

	for i = 1, 4 do
		local ftxtEfficiency = GetElement(self.m_root, "ftxtEfficiency" .. i .. "_WndFamilyProduce", WZUIFreeTextBox)
		if ftxtEfficiency then
			ftxtEfficiency:setScale(0.8)
		end
		local txtItemName = GetElement(self.m_root, "txtItemName" .. i .. "_WndFamilyProduce", WZUILabelTTF)
		if txtItemName then
			txtItemName:setDimensions(GlobalMethod:CCSize(230))
			txtItemName:setRelativePosition(GlobalMethod:ccp(0.26,0.75))			
		end
		local txtDesc = GetElement(self.m_root, "txtDesc" .. i .. "_WndFamilyProduce", WZUILabelTTF)
		if txtDesc then
			txtDesc:setDimensions(GlobalMethod:CCSize(230))
			txtDesc:setRelativePosition(GlobalMethod:ccp(0.26,0.62))
		end
	end

	local txtLuckyWorld = GetElement(self.m_root, "txtLuckyWorld_WndFamilyProduce", WZUILabelTTF)
	txtLuckyWorld:setScale(0.8)
	txtLuckyWorld:setDimensions(GlobalMethod:CCSize(120))

	local txtbtnWork1_1 = GetElement(self.m_root,"txtbtnWork1_1_WndFamilyProduce",WZUILabelTTF)
	txtbtnWork1_1:setScale(0.7)
	txtbtnWork1_1:setDimensions(GlobalMethod:CCSize(160))
	local txtbtnWork1_2 = GetElement(self.m_root,"txtbtnWork1_2_WndFamilyProduce",WZUILabelTTF)
	txtbtnWork1_2:setScale(0.7)
	txtbtnWork1_2:setDimensions(GlobalMethod:CCSize(160))
	local txtbtnWork1_3 = GetElement(self.m_root,"txtbtnWork1_3_WndFamilyProduce",WZUILabelTTF)
	txtbtnWork1_3:setScale(0.7)
	txtbtnWork1_3:setDimensions(GlobalMethod:CCSize(160))
	local txtbtnWork2 = GetElement(self.m_root, "txtbtnWork2_WndFamilyProduce", WZUILabelTTF)
	txtbtnWork2:setScale(0.7)
	txtbtnWork2:setDimensions(GlobalMethod:CCSize(160))
	local txtProtectFirst1 = GetElement(self.m_root, "txtProtectFirst1_WndFamilyProduce", WZUILabelTTF)
	txtProtectFirst1:setScale(0.7)
	txtProtectFirst1:setDimensions(GlobalMethod:CCSize(160))
	local txtProtectFirst2 = GetElement(self.m_root, "txtProtectFirst2_WndFamilyProduce", WZUILabelTTF)
	txtProtectFirst2:setScale(0.7)
	txtProtectFirst2:setDimensions(GlobalMethod:CCSize(160))
	local txtProtectBtn1 = GetElement(self.m_root, "txtProtectSecond1_WndFamilyProduce", WZUILabelTTF)
	txtProtectBtn1:setScale(0.7)
	txtProtectBtn1:setDimensions(GlobalMethod:CCSize(160))
	local txtProtectBtn2 = GetElement(self.m_root, "txtProtectSecond2_WndFamilyProduce", WZUILabelTTF)
	txtProtectBtn2:setScale(0.7)
	txtProtectBtn2:setDimensions(GlobalMethod:CCSize(160))


end


function WndFamilyProduce:_adaptLanguage_hk(  )
	for i = 1, 4 do
		local ftxtEfficiency = GetElement(self.m_root, "ftxtEfficiency" .. i .. "_WndFamilyProduce", WZUIFreeTextBox)
		if ftxtEfficiency then
			ftxtEfficiency:setScale(0.8)
		end
	end
end

function WndFamilyProduce:_adaptLanguage_ug(  )
	local txtListName = GetElement(self.m_root, "txtListName_WndFamilyProduce", WZUILabelTTF)
	txtListName:setScale(0.74)
	txtListName:setDimensions(GlobalMethod:CCSize(170))

	for i = 1, 4 do
		local ftxtEfficiency = GetElement(self.m_root, "ftxtEfficiency" .. i .. "_WndFamilyProduce", WZUIFreeTextBox)
		if ftxtEfficiency then
			ftxtEfficiency:setScale(0.8)
		end
		local txtItemName = GetElement(self.m_root, "txtItemName" .. i .. "_WndFamilyProduce", WZUILabelTTF)
		if txtItemName then
			txtItemName:setDimensions(GlobalMethod:CCSize(260))
			txtItemName:setRelativePosition(GlobalMethod:ccp(0.26,0.75))			
		end
		local txtDesc = GetElement(self.m_root, "txtDesc" .. i .. "_WndFamilyProduce", WZUILabelTTF)
		if txtDesc then
			txtDesc:setDimensions(GlobalMethod:CCSize(230))
			txtDesc:setRelativePosition(GlobalMethod:ccp(0.26,0.62))
		end
	end

	local txtLuckyWorld = GetElement(self.m_root, "txtLuckyWorld_WndFamilyProduce", WZUILabelTTF)
	txtLuckyWorld:setScale(0.8)
	txtLuckyWorld:setDimensions(GlobalMethod:CCSize(120))

	local txtbtnWork1_1 = GetElement(self.m_root,"txtbtnWork1_1_WndFamilyProduce",WZUILabelTTF)
	txtbtnWork1_1:setScale(0.7)
	txtbtnWork1_1:setDimensions(GlobalMethod:CCSize(160))
	local txtbtnWork1_2 = GetElement(self.m_root,"txtbtnWork1_2_WndFamilyProduce",WZUILabelTTF)
	txtbtnWork1_2:setScale(0.7)
	txtbtnWork1_2:setDimensions(GlobalMethod:CCSize(160))
	local txtbtnWork1_3 = GetElement(self.m_root,"txtbtnWork1_3_WndFamilyProduce",WZUILabelTTF)
	txtbtnWork1_3:setScale(0.7)
	txtbtnWork1_3:setDimensions(GlobalMethod:CCSize(160))
	local txtbtnWork2 = GetElement(self.m_root, "txtbtnWork2_WndFamilyProduce", WZUILabelTTF)
	txtbtnWork2:setScale(0.55)
	txtbtnWork2:setDimensions(GlobalMethod:CCSize(200))
	local txtProtectFirst1 = GetElement(self.m_root, "txtProtectFirst1_WndFamilyProduce", WZUILabelTTF)
	txtProtectFirst1:setScale(0.7)
	txtProtectFirst1:setDimensions(GlobalMethod:CCSize(160))
	local txtProtectFirst2 = GetElement(self.m_root, "txtProtectFirst2_WndFamilyProduce", WZUILabelTTF)
	txtProtectFirst2:setScale(0.7)
	txtProtectFirst2:setDimensions(GlobalMethod:CCSize(160))
	local txtProtectBtn1 = GetElement(self.m_root, "txtProtectSecond1_WndFamilyProduce", WZUILabelTTF)
	txtProtectBtn1:setScale(0.7)
	txtProtectBtn1:setDimensions(GlobalMethod:CCSize(160))
	local txtProtectBtn2 = GetElement(self.m_root, "txtProtectSecond2_WndFamilyProduce", WZUILabelTTF)
	txtProtectBtn2:setScale(0.7)
	txtProtectBtn2:setDimensions(GlobalMethod:CCSize(160))

	local txtPropertyAtt = GetElement(self.m_root, "txtPropertyAtt_WndFamilyProduce", WZUILabelTTF)
	txtPropertyAtt:setScale(0.8)
	txtPropertyAtt:setDimensions(GlobalMethod:CCSize(390))

	GetElement(self.m_root, "ftxtLeftTime_conProtect", WZUIFreeTextBox):setScale(0.8)

	local txtLuckPrg = GetElement(self.m_root,"txtLuckPrg_WndFamilyProduce",WZUILabelTTF)
	txtLuckPrg:setDimensions(GlobalMethod:CCSize(300))
	txtLuckPrg:setRelativePosition(GlobalMethod:ccp(0.5,0.76))
end
-------------------------------------语言适配end----------------------------------------
