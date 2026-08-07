--WndFootStar.lua
--@brief	WndFootStar的UI模块
--@date		2022/08/18
--@author	yrd
--@note		足迹星辰


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFootStar:onEnter(element)
	self.m_root = element

	self.m_nCurStarMap = g_nFootStarMapIndex

    ProtocolProcessorFootMark:regAll()
	ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsAllInfo()

	self:_initStaticText()
	self:_initWin3Data()
	self:_createWin2Grids()
	self:_createWin3Grids()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFootStar:onExit(element)
	g_nFootStarMapIndex = self.m_nCurStarMap
	self:_unInit()
	if WZFileUtil:isFileExist("pack/footmark/pack_footmark_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/footmark/pack_footmark_0.plist")
    end
    if WZFileUtil:isFileExist("pack/footmark/pack_footmark_1.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/footmark/pack_footmark_1.plist")
    end
end

--@brief	初始化静态文本
function WndFootStar:_initStaticText()
	GetElement(self.m_root,"txtWin3Btn1_WndFootStar",WZUILabelTTF):setText(LocalStrings.FOOT_STAR_TEXT2[6])
	GetElement(self.m_root,"txtWin3Btn2_WndFootStar",WZUILabelTTF):setText(LocalStrings.SYNTHESIS)
end

--@brief	更新全部星座孔位ui
function WndFootStar:updateAllStarMapUI()
	local tQualityImgPath = {
		"ui/footmark/stars/common_zjxc_bsd_lv.png",
		"ui/footmark/stars/common_zjxc_bsd_lan.png",
		"ui/footmark/stars/common_zjxc_bsd_zi.png",
		"ui/footmark/stars/common_zjxc_bsd_cheng.png",
		"ui/footmark/stars/common_zjxc_bsd_hong.png"
	}
	for i=1,#self.m_tAllStarMapData do
		for j=1,#self.m_tAllStarMapData[i] do
			local imgGemQuality = GetElement(self.m_root,"imgGemQuality"..i.."_"..j.."_WndFootStar",WZUIImage)
			local imgGemIcon = GetElement(self.m_root,"imgGemIcon"..i.."_"..j.."_WndFootStar",WZUIImage)
			if self.m_tAllStarMapData[i][j] == 0 then
				local tStarMapInfo = GDatatab_footmark_starmap["id_"..i]
				local gemType = tStarMapInfo.position[1][j]
				imgGemQuality:setFile(tQualityImgPath[1])
				imgGemIcon:setFile("ui/footmark/stars/common_zjxc_bslx_0"..gemType..".png")
			else
				local tItemInfo = GDatatab_item["id_"..self.m_tAllStarMapData[i][j]]
				imgGemQuality:setFile(tQualityImgPath[tItemInfo.quality])
				imgGemIcon:setFile(tItemInfo.icon)
			end
		end
	end

	self:updateCurStarMap()

	self:updateWin1StarMapQuality()
end

--@brief	更新星座ui
function WndFootStar:updateCurStarMap()
	local tStarMapInfo = GDatatab_footmark_starmap["id_"..self.m_nCurStarMap]
	--星座名
	GetElement(self.m_root,"txtStarName_WndFootStar",WZUILabelTTF):setText(tStarMapInfo.name)
	--星座图标
	GetElement(self.m_root,"imgStarRes_WndFootStar",WZUIImage):setFile(tStarMapInfo.icon)
	--星座图
	for i=1,self.m_nStarMapNum do
		local conStarMap = GetElement(self.m_root,"conStarMap"..i.."_WndFootStar",WZUIContainer)
		conStarMap:setVisible(self.m_nCurStarMap == i)
	end

	self:updateStarHoleStatus()

	self:updateExtendProperty()
end

--@brief	更新当前孔位选中状态
function WndFootStar:updateStarHoleStatus()
	local tStarMapInfo = GDatatab_footmark_starmap["id_"..self.m_nCurStarMap]
	for i = 1, #tStarMapInfo.position[1] do
		local conStarGem = GetElement(self.m_root,"conStarGem"..self.m_nCurStarMap.."_"..i.."_WndFootStar",WZUIContainer)
		if conStarGem:getChildByTag(11111) then
			conStarGem:removeChildByTag(11111, true)
		end
		if self.m_nSelStarHoleIndex == i then
			local imgSelected = WZUIImage:create()
			imgSelected:setFile("ui/common/frame_xz_4.png")
			imgSelected:setUseOriginSize(true)
			imgSelected:setTouchSwallow(false)
			conStarGem:addChild(imgSelected,100,11111)
		end
	end
end

--@brief	更新当前星座额外属性
function WndFootStar:updateExtendProperty()
	local tPropertyList = {}
	for k,v in pairs(GDatatab_footmark_property) do
		if v.starmap == self.m_nCurStarMap then
			table.insert(tPropertyList, v)
		end
	end
	table.sort(tPropertyList,function (a,b)
		return a.quality < b.quality
	end)

	local flcExProps = GetElement(self.m_root,"flcExProps_WndFootStar",WZUIFreeListContainer)
	flcExProps:removeAll()
	local nQuality = self:getStarMapMaxQuality(self.m_nCurStarMap)
	for i=1,#tPropertyList do
		local bComplete = false
		if nQuality >= tPropertyList[i].quality then
			bComplete = true
		end

		local strTips1 = string.format(LocalStrings.FOOT_STAR_TEXT2[11],LocalStrings.FOOT_STAR_TEXT3[tPropertyList[i].quality]) .. ": "
		local strTips2 = ""
		if tPropertyList[i].type == 0 then
			strTips2 = ATTR_TITLE[tPropertyList[i].property[1][1]] .. " +" ..tPropertyList[i].property[1][2]
		elseif tPropertyList[i].type == 1 then
			if tPropertyList[i].property[1][1] == 1404 then
				strTips2 = string.format(LocalStrings.FOOT_STAR_TEXT4[1], LocalStrings.PHANTOM_EQUIPMENT19) .. " +" .. (tPropertyList[i].property[1][2] / 100) .. "%"
			else
				strTips2 = string.format(LocalStrings.FOOT_STAR_TEXT4[1], ATTR_TITLE[tPropertyList[i].property[1][1]]) .. " +" .. (tPropertyList[i].property[1][2] / 100) .. "%"
			end
		elseif tPropertyList[i].type == 2 then
			strTips2 = string.format(LocalStrings.FOOT_STAR_TEXT4[2], ATTR_TITLE[tPropertyList[i].property[1][1]]) .. " +" .. (tPropertyList[i].property[1][2] / 100) .. "%"
		elseif tPropertyList[i].type == 3 then
			if tPropertyList[i].property[1][1] == 1401 then
				strTips2 = LocalStrings.FOOT_STAR_TEXT4[4] .. " +" .. (tPropertyList[i].property[1][2] / 100) .. "%"
			elseif tPropertyList[i].property[1][1] == 1402 then
				strTips2 = LocalStrings.FOOT_STAR_TEXT4[5] .. " +" .. (tPropertyList[i].property[1][2] / 100) .. "%"
			elseif tPropertyList[i].property[1][1] == 1403 then
				strTips2 = LocalStrings.FOOT_STAR_TEXT4[6] .. " +" .. (tPropertyList[i].property[1][2] / 100) .. "%"
			else
				strTips2 = string.format(LocalStrings.FOOT_STAR_TEXT4[3], ATTR_TITLE[tPropertyList[i].property[1][1]]) .. " +" .. (tPropertyList[i].property[1][2] / 100) .. "%"
			end
		end

		local strCompleteTips = strTips1 .. strTips2

	    local conTips = WZUIContainer:create()
	    conTips:setAbsContentSize(GlobalMethod:CCSize(440,25))
	    conTips:setUseAbsSize(true)
	    flcExProps:pushBack(conTips)

	    local imgPropStatus = WZUIImage:create()
	    imgStatusPath = bComplete and "ui/footmark/stars/common_dian_18.png" or "ui/footmark/stars/common_dian_19.png"
		imgPropStatus:setFile(imgStatusPath)
		imgPropStatus:setUseOriginSize(true)
		imgPropStatus:setTouchSwallow(false)
		imgPropStatus:setRelativePosition(GlobalMethod:ccp(0.04,0.5))
		conTips:addChild(imgPropStatus)

		local txtPropStatus = WZUILabelTTF:create()
	    txtStatusColor = bComplete and GlobalMethod:ccc3(229,105,22) or GlobalMethod:ccc3(138,122,106)
		txtPropStatus:setText(strCompleteTips)
		txtPropStatus:setColor(txtStatusColor)
		txtPropStatus:setFontSize(18)
		txtPropStatus:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		txtPropStatus:setRelativePosition(GlobalMethod:ccp(2.65,0.5))
		imgPropStatus:addChild(txtPropStatus)
	end
	flcExProps:getMoveElement():setPositionY(flcExProps:getMinPosition().y)
end

--@brief	点击星座翻页按钮
function WndFootStar:onClickTurn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	local nStarMapId = 0
	if tag == 1 then --上一页 lua负数对正数取模的结果为正数
		nStarMapId = (self.m_nCurStarMap - 2) % self.m_nStarMapNum + 1
	elseif tag == 2 then --下一页
		nStarMapId = self.m_nCurStarMap % self.m_nStarMapNum + 1
	end

	if not self:checkStarMapUnlock(nStarMapId) then
		return
	end

	self.m_nCurStarMap = nStarMapId

	self.m_nSelStarHoleIndex = 0
	self:updateCurStarMap()
end

--@brief	点击宝石孔位按钮
function WndFootStar:onClickGemHole(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()

	self.m_nSelStarHoleIndex = (tonumber(tag) - 1) % 100 + 1
	self:updateStarHoleStatus()

	--判断孔位上有没有宝石
	local nGemItemId = self.m_tAllStarMapData[self.m_nCurStarMap][self.m_nSelStarHoleIndex]
	if nGemItemId > 0 then --有宝石
		local tData = {}
		tData.basicInfo = GDatatab_item["id_"..nGemItemId]
		tData.btnType = 1
		tData.btnSynthesis = self:getNextQualityGemId(nGemItemId) ~= 0 --合成按钮是否置灰
		WndTips:show(element, self.m_root, 87, tData, nil, nil)
		WndTips:setCallBackFunc(self, self.onClickTipsBtns)
	else
		local tStarMapInfo = GDatatab_footmark_starmap["id_"..self.m_nCurStarMap]
		self:showWin2BagList(tStarMapInfo.position[1][self.m_nSelStarHoleIndex])
	end
end

--@brief	点击宝石弹窗中的按钮回调
function WndFootStar:onClickTipsBtns(tag,tData)
	if tag == 1 then --合成
		self:_initWin3Data()

		if tData.btnType == 1 then --把已镶嵌的宝石放到合成列表
			self.m_nWin3OpenHoldIndex = self.m_nSelStarHoleIndex
			self.m_nWin3DepositedList[1] = tData.basicInfo.id
		else
			self.m_nWin3OpenHoldIndex = 0
			self.m_nWin3DepositedList[1] = tData.basicInfo.id
		end

		self:showWin3BagList(-1)
	elseif tag == 2 then --镶嵌
		local starsId = self.m_nCurStarMap
		local pos = self.m_nSelStarHoleIndex
		local stoneId = tData.basicInfo.id
		self.m_tOperationParam = {starsId, pos, stoneId}
		ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsStoneMosaic(starsId, pos, stoneId)
	elseif tag == 3 then --拆卸
		--消耗是否足够
		local starmapstonedown = CacheCenter:getGameParam().starmapstonedown
		local ids,nums = SplitItemString(starmapstonedown)
		if not JudgeMoneyIsEnough(ids[tData.basicInfo.quality], nums[tData.basicInfo.quality], nil, nil, nil, nil, nil, nil, nil, self, self.clickSureStoneDown) then
			return
		end

		self:clickSureStoneDown()
	end
end

--@brief	确定拆除宝石
function WndFootStar:clickSureStoneDown()
	local starsId = self.m_nCurStarMap
	local pos = self.m_nSelStarHoleIndex
	self.m_tOperationParam = {starsId, pos, 0}
	ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsStoneDown(starsId, pos)
end

--@brief	点击宝石弹窗中的按钮回调
function WndFootStar:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.FOOT_STAR_TEXT5) 
end


--------------------窗口1选择星图界面begin--------------------

--@brief	点击列表中星座跳转按钮
function WndFootStar:onClickListStar(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conStarMapWin1_WndFootStar",WZUIContainer):setVisible(false)
	local tag = element:getTag()

	if not self:checkStarMapUnlock(tag) then
		return
	end

	self.m_nCurStarMap = tag

	self.m_nSelStarHoleIndex = 0
	self:updateCurStarMap()
end

--@brief	点击打开星座列表按钮
function WndFootStar:onClickSelectStar(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conStarMapWin1_WndFootStar",WZUIContainer):setVisible(true)
end

--@brief	点击关闭星座列表按钮
function WndFootStar:onClickCloseWin1(element)
	GetElement(self.m_root,"conStarMapWin1_WndFootStar",WZUIContainer):setVisible(false)
end

--@brief    更新每个星图达到的品质
function WndFootStar:updateWin1StarMapQuality()
	for i=1,self.m_nStarMapNum do
		local nQuality = self:getStarMapMaxQuality(i)
		local imgWin1Quality = GetElement(self.m_root,"imgWin1Quality"..i.."_WndFootStar",WZUIImage)
		if nQuality == 0 then
			imgWin1Quality:setScale(1)
			imgWin1Quality:setFile("ui/common/common_15.png")
		else
			local tQualityImgPath = {
				"ui/footmark/stars/common_zjxc_bsd_lv.png",
				"ui/footmark/stars/common_zjxc_bsd_lan.png",
				"ui/footmark/stars/common_zjxc_bsd_zi.png",
				"ui/footmark/stars/common_zjxc_bsd_cheng.png",
				"ui/footmark/stars/common_zjxc_bsd_hong.png"
			}
			imgWin1Quality:setScale(0.75)
			imgWin1Quality:setFile(tQualityImgPath[nQuality])
		end
	end
end

--------------------窗口1背包界面end--------------------


--------------------窗口2背包界面begin--------------------
--@brief    创建空背包格子
function WndFootStar:_createWin2Grids()
    local tcItemBag = GetElement(self.m_root, "tcWin2GemBag_WndFootStar", WZUITableContainer)
    self.m_tWin2GemCellList = {}
    for i = 1, self.m_nMaxGridsNum do
		local cellElement,tLuaObj = CellGoodItem:createElement()
		if cellElement ~= nil and tLuaObj ~= nil then
			cellElement:setTag(i-1)
			tcItemBag:setCellElement(cellElement)
			table.insert(self.m_tWin2GemCellList,tLuaObj)
			tLuaObj:setItemClickFun(self,self.onItemClick1)
		end
    end
end

--@brief	更新背包界面背包列表
function WndFootStar:updateWin2BagList()
	WZLog("WndFootStar:updateWin2BagList")
	self:updateWin2BagShowData()
	local tcItemBag = GetElement(self.m_root,"tcWin2GemBag_WndFootStar",WZUITableContainer)
	self.m_bInitBagPos1 = true
	self.m_nStartIndex1 = 1
	tcItemBag:enableSchedule("_addBagSchedule1",0)
end

--@brief	每帧加载装备Cell
function WndFootStar:_addBagSchedule1(element)
	local tcItemBag = GetElement(self.m_root,"tcWin2GemBag_WndFootStar",WZUITableContainer)

	for i=self.m_nStartIndex1,self.m_nMaxGridsNum do
		if self.m_tWin2GemShowList[i] then
			self.m_tWin2GemCellList[i]:setCellGoodItem(self.m_tWin2GemShowList[i],2)
		else
			self.m_tWin2GemCellList[i]:removeAllChild()
		end
		self.m_nStartIndex1 = self.m_nStartIndex1 + 1
	end

	if self.m_nStartIndex1 > self.m_nMaxGridsNum then
		element:disableSchedule()
		--拉倒最上面
		if self.m_bInitBagPos1 == true then
			tcItemBag:getMoveElement():setPositionY(tcItemBag:getMinPosition().y)
		end
		self.m_bInitBagPos1 = false
	end
end

--@brief	点击背包物品回调
function WndFootStar:onItemClick1(luaTable,tag,tData)
	WZLog("WndFootStar:onItemClick1",tag,tostring(tData))
	if tData == nil then
		return
	end

	local nGemItemId = self.m_tAllStarMapData[self.m_nCurStarMap][self.m_nSelStarHoleIndex]

	--选择一个同类型孔位,优先选空槽位
	local sub_type = tData.basicInfo.sub_type
	local nHoleType = self:getHoleGemType(self.m_nCurStarMap,self.m_nSelStarHoleIndex)
	if sub_type == nHoleType and (self.m_nSelStarHoleIndex == 0 or nGemItemId <= 0) then
	else
		self.m_nSelStarHoleIndex = self:getEmptyGemGrid(sub_type)
		self:updateStarHoleStatus()
	end

	--弹窗
	local nGemItemId = self.m_tAllStarMapData[self.m_nCurStarMap][self.m_nSelStarHoleIndex]
	if self.m_nSelStarHoleIndex == 0 then --当前星座没有选中的宝石类型时
		tData.btnType = 3
	elseif nGemItemId > 0 then --有宝石
		tData.btnType = 3
	else
		tData.btnType = 2
	end
	tData.btnSynthesis = self:getNextQualityGemId(tData.basicInfo.id) ~= 0 --合成按钮是否置灰
	WndTips:show(luaTable.m_root, self.m_root, 87, tData, GlobalMethod:ccp(0,0), nil)
	WndTips:setCallBackFunc(self, self.onClickTipsBtns)
end

--@brief	点击打开星座背包按钮
function WndFootStar:onClickBag(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nSelStarHoleIndex = 0
	self:updateStarHoleStatus()

	self:showWin2BagList(-1)
end

--@brief	点击星座背包宝石类型按钮
function WndFootStar:onClickSelectGemType1(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if tag == self.m_nWin2GemType then
		tag = -1
	end

	self.m_nSelStarHoleIndex = self:getEmptyGemGrid(tag)
	self:updateStarHoleStatus()

	self:showWin2BagList(tag)
end

--@brief	点击关闭星座背包按钮
function WndFootStar:onClickCloseWin2(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:hideWin2BagList()
end

--@brief	显示背包界面
function WndFootStar:showWin2BagList(gemtype)
	self.m_nWin2GemType = gemtype or -1
	self:updateWin2GemBtnStatus(gemtype)
	self:updateWin2BagList()
	
	GetElement(self.m_root,"conStarMapWin2_WndFootStar",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conStarMapWin3_WndFootStar",WZUIContainer):setVisible(false)
end

--@brief	隐藏背包界面
function WndFootStar:hideWin2BagList()
	GetElement(self.m_root,"conStarMapWin2_WndFootStar",WZUIContainer):setVisible(false)
end

--@brief	更新宝石类型按钮状态
function WndFootStar:updateWin2GemBtnStatus(gemtype)
	for i=1,7 do
		local imgWin2TypeBtnSel = GetElement(self.m_root,"imgWin2TypeBtnSel"..i.."_WndFootStar",WZUIImage)
		imgWin2TypeBtnSel:setVisible(i == gemtype)
	end
end

--------------------窗口2背包界面end--------------------



--------------------窗口3合成界面begin--------------------

--@brief    创建空背包格子
function WndFootStar:_createWin3Grids()
    local tcItemBag = GetElement(self.m_root, "tcWin3GemBag_WndFootStar", WZUITableContainer)
    self.m_tWin3GemCellList = {}
    for i = 1, self.m_nMaxGridsNum do
		local cellElement,tLuaObj = CellGoodItem:createElement()
		if cellElement ~= nil and tLuaObj ~= nil then
			cellElement:setTag(i-1)
			tcItemBag:setCellElement(cellElement)
			table.insert(self.m_tWin3GemCellList,tLuaObj)
			tLuaObj:setItemClickFun(self,self.onItemClick2)
		end
    end
end

--@brief	更新背包界面背包列表
function WndFootStar:updateWin3BagList()
	WZLog("WndFootStar:updateWin3BagList")
	self:updateWin3BagShowData()
	local tcItemBag = GetElement(self.m_root,"tcWin3GemBag_WndFootStar",WZUITableContainer)
	self.m_bInitBagPos2 = true
	self.m_nStartIndex2 = 1
	tcItemBag:enableSchedule("_addBagSchedule2",0)
end

--@brief	每帧加载装备Cell
function WndFootStar:_addBagSchedule2(element)
	local tcItemBag = GetElement(self.m_root,"tcWin2GemBag_WndFootStar",WZUITableContainer)

	for i=self.m_nStartIndex2,self.m_nMaxGridsNum do
		if self.m_tWin3GemShowList[i] then
			self.m_tWin3GemCellList[i]:setCellGoodItem(self.m_tWin3GemShowList[i],2)
		else
			self.m_tWin3GemCellList[i]:removeAllChild()
		end
		self.m_nStartIndex2 = self.m_nStartIndex2 + 1
	end

	if self.m_nStartIndex2 > self.m_nMaxGridsNum then
		element:disableSchedule()
		--拉倒最上面
		if self.m_bInitBagPos2 == true then
			tcItemBag:getMoveElement():setPositionY(tcItemBag:getMinPosition().y)
		end
		self.m_bInitBagPos2 = false
	end
end

--@brief	显示背包界面
function WndFootStar:showWin3BagList(gemtype)
	self.m_nWin3GemType = gemtype or -1
	self:updateWin3GemBtnStatus(gemtype)
	self:updateWin3BagList()

	self:updateLeftSynthesisUI()

	GetElement(self.m_root,"conStarMapWin2_WndFootStar",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conStarMapWin3_WndFootStar",WZUIContainer):setVisible(true)
end

--@brief	隐藏背包界面
function WndFootStar:hideWin3BagList()
	self:_initWin3Data()
	GetElement(self.m_root,"conStarMapWin3_WndFootStar",WZUIContainer):setVisible(false)
end

--@brief	更新左边合成界面
function WndFootStar:updateLeftSynthesisUI()
	WZLog("WndFootStar:updateLeftSynthesisUI",self.m_nWin3OpenHoldIndex,Serialize(self.m_nWin3DepositedList))
	--4个合成框
	local nCurItemId = 0
	local nSynthesisCount = 0
	for i=1,#self.m_nWin3DepositedList do
		local imgSynthesisItem = GetElement(self.m_root,"imgSynthesisItem"..i.."_WndFootStar",WZUIImage)
		local imgSynthesisQuality = GetElement(self.m_root,"imgSynthesisQuality"..i.."_WndFootStar",WZUIImage)
		imgSynthesisItem:setFile("ui/common/common_btn_+.png")
		imgSynthesisQuality:setFile("")
		if self.m_nWin3DepositedList[i] ~= 0 then
			local tItemInfo = GDatatab_item["id_"..self.m_nWin3DepositedList[i]]
			imgSynthesisItem:setFile(tItemInfo.icon)
			imgSynthesisQuality:setFile(g_tQualityRect[tItemInfo.quality])

			nCurItemId = self.m_nWin3DepositedList[i]
			nSynthesisCount = nSynthesisCount + 1
		end
	end

	--合成后展示
	local tMergeInfo = nil
	for k,v in pairs(GDatatab_footmark_merge) do
		if nCurItemId == tonumber(v.scrap) then
			tMergeInfo = v
			break
		end
	end
	local imgSynthesisItem0 = GetElement(self.m_root,"imgSynthesisItem0_WndFootStar",WZUIImage)
	local imgSynthesisQuality0 = GetElement(self.m_root,"imgSynthesisQuality0_WndFootStar",WZUIImage)
	imgSynthesisItem0:setFile("")
	imgSynthesisQuality0:setFile("")
	if tMergeInfo ~= nil then
		local tItemInfo0 = GDatatab_item["id_"..tonumber(tMergeInfo.items)]
		imgSynthesisItem0:setFile(tItemInfo0.icon)
		imgSynthesisQuality0:setFile(g_tQualityRect[tItemInfo0.quality])
	end

	--成功率
	local nLucky = 0
	if tMergeInfo then
		for i = 1, #tMergeInfo.rate do
			if tMergeInfo.rate[i][1] == nSynthesisCount then
				nLucky = tMergeInfo.rate[i][2] / 100
			end
		end
	end
	local txtSynthesisLucky = GetElement(self.m_root,"txtSynthesisLucky_WndFootStar",WZUILabelTTF)
	txtSynthesisLucky:setText(nLucky.."%")
	local txtSynthesisTips = GetElement(self.m_root,"txtSynthesisTips_WndFootStar",WZUILabelTTF)
	txtSynthesisTips:setText(LocalStrings.FOOT_STAR_TEXT2[5])
	if nSynthesisCount == 2 or nSynthesisCount == 3 or nSynthesisCount == 4 then
		if self.m_nWin3OpenHoldIndex ~= 0 then
			txtSynthesisTips:setText(LocalStrings.FOOT_STAR_TEXT2[15])
		else
			txtSynthesisTips:setText(LocalStrings.FOOT_STAR_TEXT2[17])
		end
	end

	--消耗
	local conWin3Cost = GetElement(self.m_root,"conWin3Cost_WndFootStar",WZUIContainer)
	local imgWin3Cost = GetElement(self.m_root,"imgWin3Cost_WndFoorStar",WZUIImage)
	local txtWin3Cost = GetElement(self.m_root,"txtWin3Cost_WndFoorStar",WZUILabelTTF)
	conWin3Cost:setVisible(false)
	local costItem = nil
	self.m_tWin3SynthesisCost = nil
	if tMergeInfo then
		for i = 1, #tMergeInfo.rate do
			if type(tMergeInfo.cost) == "table" and tMergeInfo.cost[i] and tMergeInfo.rate[i][1] == nSynthesisCount then
				self.m_tWin3SynthesisCost = {tMergeInfo.cost[i][1],tMergeInfo.cost[i][2]}
				local tempItemInfo = GDatatab_item["id_"..tMergeInfo.cost[i][1]]
				imgWin3Cost:setFile(tempItemInfo.icon)
				txtWin3Cost:setText(tMergeInfo.cost[i][2])
				conWin3Cost:setVisible(true)
			end
		end
	end

end

--@brief	点击左边合成界面格子
function WndFootStar:onClickSynthesisGrid(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if tag == 0 then --合成后的宝石
		local nNextItemId = 0
		for i=1,#self.m_nWin3DepositedList do
			if self.m_nWin3DepositedList[i] ~= 0 then
				for k,v in pairs(GDatatab_footmark_merge) do
					if self.m_nWin3DepositedList[i] == tonumber(v.scrap) then
						nNextItemId = tonumber(v.items)
						break
					end
				end
				break
			end
		end
		if nNextItemId ~= 0 then
			local tData = {}
			tData.basicInfo = GDatatab_item["id_"..nNextItemId]
			tData.btnType = 0
			tData.btnSynthesis = self:getNextQualityGemId(nNextItemId) ~= 0 --合成按钮是否置灰
			WndTips:show(element, self.m_root, 87, tData, nil, nil)
		end
	else --合成中的宝石
		if self.m_nWin3DepositedList[tag] == 0 then
		else
			if tag == 1 then
				self.m_nWin3OpenHoldIndex = 0
			end
			self.m_nWin3DepositedList[tag] = 0

			self:showWin3BagList(self.m_nWin3GemType)
		end
	end
end

--@brief	点击背包物品回调
function WndFootStar:onItemClick2(luaTable,tag,tData)
	WZLog("WndFootStar:onItemClick2")
	if tData == nil then
		return
	end

	local nListCount, nGemItemId, nEmptyIndex = self:getSynthesisListCount()
	--合成列表已满
	if nListCount == 4 then
		MsgBoxManager:showTipBox(LocalStrings.FOOT_STAR_TEXT2[7])
		return
	end
	--相同宝石才能合成
	if nGemItemId ~= 0 then
		if nGemItemId ~= tData.basicInfo.id then
			MsgBoxManager:showTipBox(LocalStrings.FOOT_STAR_TEXT2[8])
			return
		end
	end

	self.m_nWin3DepositedList[nEmptyIndex] = tData.basicInfo.id

	self:showWin3BagList(self.m_nWin3GemType)
end

--@brief	更新宝石类型按钮状态
function WndFootStar:updateWin3GemBtnStatus(gemtype)
	for i=1,7 do
		local imgWin3TypeBtnSel = GetElement(self.m_root,"imgWin3TypeBtnSel"..i.."_WndFootStar",WZUIImage)
		imgWin3TypeBtnSel:setVisible(i == gemtype)
	end
end

--@brief	点击星座背包宝石类型按钮
function WndFootStar:onClickSelectGemType2(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if tag == self.m_nWin3GemType then
		tag = -1
	end

	self:showWin3BagList(tag)
end

--@brief	点击关闭星座合成按钮
function WndFootStar:onClickCloseWin3(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:hideWin3BagList()
end

--@brief	点击一键添加按钮
function WndFootStar:onClickWin3Add(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nListCount, nGemItemId, nEmptyIndex = self:getSynthesisListCount()
	if nGemItemId == 0 then
		MsgBoxManager:showTipBox(LocalStrings.FOOT_STAR_TEXT2[9])
		return
	end

	local bIsAdd = false --是否有新宝石添加合成列表
	for i=1,#self.m_tWin3GemShowList do
		if self.m_tWin3GemShowList[i].basicInfo.id == nGemItemId then
			for j=1,#self.m_nWin3DepositedList do
				if self.m_nWin3DepositedList[j] == 0 then
					if self.m_tWin3GemShowList[i].lastNum > 0 then
						bIsAdd = true
						self.m_tWin3GemShowList[i].lastNum = self.m_tWin3GemShowList[i].lastNum - 1
						self.m_nWin3DepositedList[j] = self.m_tWin3GemShowList[i].basicInfo.id
					end
				end
			end
			break
		end
	end
	if bIsAdd == false then
		if nListCount == 4 then
			MsgBoxManager:showTipBox(LocalStrings.FOOT_STAR_TEXT2[18])
		else
			MsgBoxManager:showTipBox(LocalStrings.FOOT_STAR_TEXT2[19])
		end
		return
	end

	self:showWin3BagList(self.m_nWin3GemType)
end

--@brief	点击合成按钮
function WndFootStar:onClickWin3Synthesis(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nListCount, nGemItemId, nEmptyIndex = self:getSynthesisListCount()
	--没有宝石
	if nGemItemId == 0 then
		MsgBoxManager:showTipBox(LocalStrings.FOOT_STAR_TEXT2[10])
		return
	end
	--金币不足
    if not JudgeMoneyIsEnough(self.m_tWin3SynthesisCost[1], self.m_tWin3SynthesisCost[2], nil, nil) then 
        return
    end

	local starsId = 0
	local pos = 0
	local stoneId = nGemItemId
	local stoneNum = nListCount
	self.m_tOperationParam = nil
	if self.m_nWin3OpenHoldIndex ~= 0 then
		starsId = self.m_nCurStarMap
		pos = self.m_nWin3OpenHoldIndex
		self.m_tOperationParam = {starsId, pos, stoneId}
	end
	ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsStoneMerge(starsId, pos, stoneId, stoneNum)
end

--------------------窗口3合成界面end--------------------





-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
