--WndDressCastSoul.lua
--@brief	WndDressCastSoul的UI模块
--@date		2020/05/20
--@author	XTX
--@note		时装铸魂界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDressCastSoul:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	CacheCenter:registerUpdateDecorationObserver(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDressCastSoul:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)--反注册物品
	CacheCenter:unregisterUpateDecorationObserver(self)
	self:_unInit()
end

--@brief 	界面加载完成回调
function WndDressCastSoul:onEnterTransitionDidFinish(element)
	-- body
	self:_addTop()
	self:_initStaticUIText()
	self:setSuitAndWingData()
	ProtocolProcessorRecycling:send_PLAYERITEM_GetYuanSoulInfo()
end

--@brief    退出界面回调
function WndDressCastSoul:caculateTime()
	local tSuitList = self.m_tSuitList

	if tSuitList then 
		for i = 1, #tSuitList do 
			for j = 1, #tSuitList[i].lastTime do
				if tSuitList[i].lastTime[j] > 0 then 
					tSuitList[i].lastTime[j] = tSuitList[i].lastTime[j] - 1
					MsgBoxManager:showTipBox("时装剩余时间：" .. returnToTimeFormat_Day(tSuitList[i].lastTime[j]))
				end
			end
		end
	end
end

--@brief    退出界面回调
function WndDressCastSoul:onClickClose()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击时装标签回调
function WndDressCastSoul:onTabDress(element)
    -- body
    if self.m_nTabIndex == 1 then
        return 
    end
    self.m_nTabIndex = 1 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    self:_update()
end

--@brief	点击切换标签
function WndDressCastSoul:onClickNextTitle(element)
	-- body
	local tag = element:getTag()
	WZLog("点击切换标签",tag)
	if tag == 1 then
		self.m_nTabIndex = self.m_nTabIndex - 1
		if self.m_nTabIndex < 1 then
			self.m_nTabIndex = 3
		end
	elseif tag == 2 then
		self.m_nTabIndex = self.m_nTabIndex + 1 
		if self.m_nTabIndex > 3 then
			self.m_nTabIndex = 1
		end
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	self:_update()
end

--@brief    点击翅膀标签回调
function WndDressCastSoul:onTabWing(element)
    -- body
    if self.m_nTabIndex == 2 then
        return 
    end
    self.m_nTabIndex = 2 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    self:_update()
end

--@brief    点击属性标签回调
function WndDressCastSoul:onTabProperty(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    local tData = {}
    tData.property = self:caculateProperty()
    tData.fighting = WndCard:_caculateFighting(tData.property)
    local nHaveNum = self:getCollectSuitNum()

    tData.suitNum = nHaveNum
    tData.tabIndex = self.m_nTabIndex

    WndTips:show(element, self.m_root, 62, tData, GlobalMethod:ccp(-200, -50), true)
end

--@brief    点击规则按钮回调
function WndDressCastSoul:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.CASTSOUL_TEXT1)    
end

--@brief 	切换下一套时装回调
function WndDressCastSoul:onClickNext(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

end

--@brief 	切换上一套时装回调
function WndDressCastSoul:onClickLast(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
end

--@brief 	点击物品格子回调
function WndDressCastSoul:onClickItem(luaTable, tag, tData)
	-- body
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    local lastTime = CacheCenter:getPlayerItemCountById(tData.basicInfo.id)
    if lastTime == 0 then 
    	tData.tBtnList = {LocalStrings.SKINSKILL4}
    	WndItemInfo:showInfo(luaTable.m_root, self.m_root, 1, tData, true, nil, true)
    	WndItemInfo:setClickButtonCallback(self, self.getPath)
    else
    	WndItemInfo:showInfo(luaTable.m_root, self.m_root, 1, tData, false, nil, true)
    end
end

--@brief 	点击物品格子回调
function WndDressCastSoul:onClickItem2(luaTable, tag, tData)
	-- body
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    local lastTime = CacheCenter:getPlayerItemCountById(tData.basicInfo.id)
    if lastTime == 0 then 
    	tData.tBtnList = {LocalStrings.BUY}
    	WndItemInfo:showInfo(luaTable.m_root, self.m_root, 1, tData, true, nil, true)
    	WndItemInfo:setClickButtonCallback(self, self.onClickQuickBuy)
    else
    	WndItemInfo:showInfo(luaTable.m_root, self.m_root, 1, tData, false, nil, true)
    end
end

--@brief 	点击已经注魂的格子回调
function WndDressCastSoul:clickSoulItem(luaTable, tag, tData)
	-- body
	if tData == nil then
       return
    end

    WndCastSoulUpgrade:showInterface(tData, self.m_nTabIndex)
 --    WndItemInfo:onCloseClick()

	-- tData.tBtnList = {LocalStrings.STAR_SOUL_BUTTON_UPDATE}
	-- WndItemInfo:showInfo(luaTable.m_root, self.m_root, 1, tData, true, nil, true)
	-- WndItemInfo:setClickButtonCallback(self, self.onClickSoulUpgrade)
end

--@brief 	时装点击购买按钮回调
function WndDressCastSoul:onClickQuickBuy(tag, tData)
	-- body
	if tData == nil then return end 

	local nType = {[0]=2,[1]=3,[2]=4,[3]=5}
	WndPurchase:showBuyInterface(nType[tData.basicInfo.sub_type],tData.basicInfo.id)
end

--@brief 	点击获取途径按钮回调
function WndDressCastSoul:getPath(tag, tData)
	WndItemInfo:onCloseClick()

	WndFastGetItems:show(tData.basicInfo.id)
end

--@brief 	点击添加宝石按钮回调
function WndDressCastSoul:onAdd(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	
	WndSelectTipsStrengthen:showSelectTips(5, nTag)
end

--@brief 	点击添加宝石按钮回调
function WndDressCastSoul:onUnLock(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()

	if self.m_nTabIndex == 1 then 
		local tGridLevel1 = self.m_tSuitOpenLevel
		local tGridLevel2 = self.m_tSuitGMOpenLevel
		if nTag <= #tGridLevel1 then 
			local num = self:getCollectSuitNum(1)
			MsgBoxManager:showTipBox(string.format(LocalStrings.CASTSOUL_TEXT9, tGridLevel1[nTag], num))
		else
			MsgBoxManager:showTipBox(string.format(LocalStrings.CASTSOUL_TEXT23, tGridLevel2[nTag - #tGridLevel1]))
		end
	elseif self.m_nTabIndex == 2 then 
		local tGridLevel1 = self.m_tWingOpenLevel
		local tGridLevel2 = self.m_tWingGMOpenLevel
		if nTag <= #tGridLevel1 then 
			local num = self:getCollectSuitNum(2)
			MsgBoxManager:showTipBox(string.format(LocalStrings.CASTSOUL_TEXT10, tGridLevel1[nTag], num))
		else
			MsgBoxManager:showTipBox(string.format(LocalStrings.CASTSOUL_TEXT23, tGridLevel2[nTag - #tGridLevel1]))
		end
	elseif self.m_nTabIndex == 3 then 
		local tGridLevel1 = self.m_tTitleOpenLevel
		local tGridLevel2 = self.m_tTitleGMOpenLevel
		if nTag <= #tGridLevel1 then 
			local num = self:getCollectSuitNum(3)
			MsgBoxManager:showTipBox(string.format(LocalStrings.OTHER_TEXT1[5], tGridLevel1[nTag], num))
		else
			MsgBoxManager:showTipBox(string.format(LocalStrings.CASTSOUL_TEXT23, tGridLevel2[nTag - #tGridLevel1]))
		end
	end
end

--@brief    选择元魂添加到cell时调用
function WndDressCastSoul:addStoneToCell(tData, gridId)
	WZLog("WndDressCastSoul:addStoneToCell", self.m_nTabIndex, gridId, Serialize(tData))
    if tData == nil then return end

	local tGridLevel1
	if self.m_nTabIndex == 1 then 
		tGridLevel1 = self.m_tSuitOpenLevel
	elseif self.m_nTabIndex == 2 then
		tGridLevel1 = self.m_tWingOpenLevel
	elseif self.m_nTabIndex == 3 then
		tGridLevel1 = self.m_tTitleOpenLevel
	end
    --发送铸魂协议
    local yType = self.m_nTabIndex
    if self.m_nTabIndex == 3 then 
    	yType = 5
    end
    local nTempGrid = gridId
    if self.m_nTabIndex == 1 and gridId > #tGridLevel1 then 
    	yType = 3
    	nTempGrid = gridId - #tGridLevel1
    elseif self.m_nTabIndex == 2 and gridId > #tGridLevel1 then 
    	yType = 4
    	nTempGrid = gridId - #tGridLevel1
    elseif self.m_nTabIndex == 3 and gridId > #tGridLevel1 then 
    	yType = 6
    	nTempGrid = gridId - #tGridLevel1
    end
 	ProtocolProcessorRecycling:send_PLAYERITEM_CastSoul(yType, 1, nTempGrid - 1, tData.playerItemId,0)
end

--@brief 	切换套装选中状态
function WndDressCastSoul:changeSuitSelState(tCell)
	-- body
	if self.m_tCurSelCell then 
		if self.m_tCurSelCell:getSuitId() == tCell:getSuitId() then return end 

		self.m_tCurSelCell:setSelState(false)
		self.m_tCurSelCell.m_root:setScale(0.84)
	end

	self.m_tCurSelCell = tCell
	self.m_tCurSelCell.m_root:setScale(1)
	self.m_tCurSelCell:setSelState(true)

	--更新玩家形象
	if self.m_nTabIndex == 1 then 
		self.m_nSuitIndex = self.m_tCurSelCell.m_root:getTag()
	elseif self.m_nTabIndex == 2 then 
		self.m_nWingIndex = self.m_tCurSelCell.m_root:getTag()
	elseif self.m_nTabIndex == 3 then 
		self.m_nTitleIndex = self.m_tCurSelCell.m_root:getTag()
	end
	self:showPlayer()
end

--@brief 	点击升级元魂按钮回调
function WndDressCastSoul:onClickSoulUpgrade(tag, tData)
	-- body
	local maxLevel = self:getMaxLevelByItemId(tData.id)
	if tData.basicInfo.levelInfo.level >= maxLevel then 
		MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TEXT15)
	else
		--跳转到升级界面
		WndCastSoulUpgrade:showInterface(tData, self.m_nTabIndex)
	end
end

--@brief    触摸开始
function WndDressCastSoul:onTouchBegan(element, pt)
    -- body
    self.m_nMoveDistance = 0
    self.m_nTouchBeginX = pt.x
    self.m_bIsPtInList = self:checkInList(pt)

    self.m_nTouchBeginTime = WZThread:getUTickCount()
    local tableSuitList = GetElement(self.m_root, "tableSuitList_WndDressCastSoul", WZUITableContainer)
    self.m_nStartPtx = tableSuitList:getMoveElement():getPositionX()
end

--@brief    触摸滑动
function WndDressCastSoul:onTouchMove(element, pt)
    -- body
    if self.m_nTouchBeginX == nil then 
        self.m_nTouchBeginX = pt.x
    end
    local moveX = pt.x - self.m_nTouchBeginX
    self.m_nMoveDistance = self.m_nMoveDistance + moveX
    self.m_nTouchBeginX = pt.x
end

--@brief    触摸结束
function WndDressCastSoul:onTouchEnd(element, pt)
    -- body
    local tempPt = GlobalMethod:ccp(0,0)
    local tableSuitList = GetElement(self.m_root, "tableSuitList_WndDressCastSoul", WZUITableContainer)

    -- if self.m_nMoveDistance > 0 and math.abs(self.m_nMoveDistance) > 30 and self.m_bIsPtInList then 
    -- 	local conSuit = GetElement(self.m_root, "conSuit_WndDressCastSoul", WZUIContainer)
    -- 	tempPt.x = 0
    --     local ptA = tableSuitList:convertToNodeSpace(conSuit:convertToWorldSpace(tempPt))
    --     WZLog("WndDressCastSoul:onTouchEnd 000", ptA.x)
    --     tableSuitList:slideToPosition(0.15, -ptA.x * 2, 0, 1, "actionPlaying")
    -- elseif self.m_nMoveDistance < 0 and math.abs(self.m_nMoveDistance) > 30 and self.m_bIsPtInList then
    -- 	local conSuit = GetElement(self.m_root, "conSuit_WndDressCastSoul", WZUIContainer)
    -- 	tempPt.x = 0
    --     local ptA = tableSuitList:convertToNodeSpace(conSuit:convertToWorldSpace(tempPt))
    --     WZLog("WndDressCastSoul:onTouchEnd 111", ptA.x)
    --     tableSuitList:slideToPosition(0.15, ptA.x*2, 0, 1, "actionPlaying")
    -- end
end

function WndDressCastSoul:actionPlaying()
    WZLog("WndDressCastSoul:actionPlayer")
    local tableSuitList = GetElement(self.m_root, "tableSuitList_WndDressCastSoul", WZUITableContainer)
    local endPtx = tableSuitList:getMoveElement():getPositionX()
    local minPtx = tableSuitList:getMinPosition().x
    local maxPtx = tableSuitList:getMaxPosition().x
    local moveDistance = endPtx - self.m_nStartPtx
    local tempWidth = 130.5

    local nIndex = math.ceil(math.abs(moveDistance) / tempWidth)
    -- if moveDistance > 0 then
    -- 	local acturePtX = endPtx + (nIndex * tempWidth - moveDistance)
    -- 	tableSuitList:getMoveElement():setPositionX(acturePtX)
    -- else
    -- 	local acturePtX = endPtx - (nIndex * tempWidth + moveDistance)
    -- 	tableSuitList:getMoveElement():setPositionX(acturePtX)
    -- end
    WZLog("WndDressCastSoul:actionPlayer one", moveDistance, nIndex, minPtx, maxPtx, self.m_nStartPtx, endPtx)


end

function WndDressCastSoul:checkInList(pt)
    WZLog("WndDressCastSoul:checkInList")
    local btn = GetElement(self.m_root, "conSuit_WndDressCastSoul", WZUIContainer)
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        return true
    end 
    return false
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndDressCastSoul:_update()
	-- body
	self:showPlayer()
    self:showContentByTab()
    self:showSuitList()
    self:showGridList()
end

--@brief 	静态文本
function WndDressCastSoul:_initStaticUIText()
	-- body
	local sSuitConfig = CacheCenter:getGameParam().enchantingNumber
	local sWingConfig = CacheCenter:getGameParam().enchantingNumber2
	local sTitleConfig = CacheCenter:getGameParam().enchantingNumber6
	local sSuitGMConfig = CacheCenter:getGameParam().enchantingNumber4 --共鸣
	local sWingGMConfig = CacheCenter:getGameParam().enchantingNumber5
	local sTitleGMConfig = CacheCenter:getGameParam().enchantingNumber7
	local string1 = string.sub(sSuitConfig, 2, -2) 
	local string2 = string.sub(sWingConfig, 2, -2) 
	local string5 = string.sub(sTitleConfig, 2, -2) 
	local string3 = string.sub(sSuitGMConfig, 2, -2) 
	local string4 = string.sub(sWingGMConfig, 2, -2) 
	local string6 = string.sub(sTitleGMConfig, 2, -2) 
	self.m_tSuitOpenLevel = SplitStringWithSeparator(string1, ",", nil, true)
	self.m_tWingOpenLevel = SplitStringWithSeparator(string2, ",", nil, true)
	self.m_tTitleOpenLevel = SplitStringWithSeparator(string5, ",", nil, true)
	self.m_tSuitGMOpenLevel = SplitStringWithSeparator(string3, ",", nil, true)
	self.m_tWingGMOpenLevel = SplitStringWithSeparator(string4, ",", nil, true)
	self.m_tTitleGMOpenLevel = SplitStringWithSeparator(string6, ",", nil, true)

	-- local txtCollectWord = GetElement(self.m_root, "txtCollectWord_WndDressCastSoul", WZUILabelTTF)
	-- if txtCollectWord then 
	-- 	txtCollectWord:setText(LocalStrings.CASTSOUL_TEXT3 .. ":")
	-- end
end
--@brief     添加顶部货币栏
function WndDressCastSoul:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_zhuhun.png", WndDressCastSoul, WndDressCastSoul.onClickClose, true, false, false,nil, {goldType = 1})
    self.m_root:addChild(celElement)
    self.m_topCellLua = tNewObj
end

--@brief 	显示玩家形象
function WndDressCastSoul:showPlayer()
	-- body
	local head,face,body,wing
	local headColor = 0
	local bodyColor = 0
	local nSex = CacheCenter:getPlayerInfo().sex == 0 and true or false 
	local tEquipList = CacheCenter:getEquipedDecorationList()
	local conTitle = GetElement(self.m_root, "conTitle_WndDressCastSoul", WZUIContainer)
	conTitle:setVisible(false)
	if self.m_nTabIndex == 2 then 
		local wingId = self.m_tWingList[self.m_nWingIndex].suitId
		wing = GDatatab_item["id_" .. wingId].animation_index_code
		--使用玩家身上的时装
		headColor, bodyColor = CacheCenter:getHeadAndBodyColor()
		WZLog("WndDressCastSoul:showPlayer One", headColor, bodyColor)
		if tEquipList then 
			for i = 1, #tEquipList do
				local basicInfo = tEquipList[i].basicInfo
				if basicInfo ~= nil then
					if basicInfo.sub_type == 0 then
						head = basicInfo.animation_index_code
					elseif basicInfo.sub_type == 1 then
						face = basicInfo.animation_index_code
					elseif basicInfo.sub_type == 2 then
						body = basicInfo.animation_index_code
					end
				end
			end
		end
	elseif self.m_nTabIndex == 1 then 
		if tEquipList then 
			for i = 1, #tEquipList do
				if tEquipList[i].subtype == 3 then 
					wing = tEquipList[i].basicInfo.animation_index_code
					break 
				end
			end
		end

		local tDressList = self.m_tSuitList[self.m_nSuitIndex].suitId
		local color = self.m_tSuitList[self.m_nSuitIndex].color
		for i = 1, #tDressList do
			local basicInfo = GDatatab_item["id_" .. tDressList[i]]
			if basicInfo ~= nil then
				if basicInfo.sub_type == 0 then
					head = basicInfo.animation_index_code
					headColor = color[i]
				elseif basicInfo.sub_type == 1 then
					face = basicInfo.animation_index_code
				elseif basicInfo.sub_type == 2 then
					body = basicInfo.animation_index_code
					bodyColor = color[i]
				end
			end
		end
	elseif self.m_nTabIndex == 3 then 
		--使用玩家身上的时装
		conTitle:setVisible(true)
		local tempPoint = GlobalMethod:ccp(0.5,1.53)
		local txtTitle = GetElement(self.m_root, "txtTitle_WndDressCastSoul", WZUILabelTTF)
		local strTitle = self.m_tTitleList[self.m_nTitleIndex].name
    	CreateDesiSpine(conTitle, txtTitle, strTitle, tempPoint, true)
		headColor, bodyColor = CacheCenter:getHeadAndBodyColor()
		WZLog("WndDressCastSoul:showPlayer One", headColor, bodyColor)
		if tEquipList then 
			for i = 1, #tEquipList do
				local basicInfo = tEquipList[i].basicInfo
				if basicInfo ~= nil then
					if basicInfo.sub_type == 0 then
						head = basicInfo.animation_index_code
					elseif basicInfo.sub_type == 1 then
						face = basicInfo.animation_index_code
					elseif basicInfo.sub_type == 2 then
						body = basicInfo.animation_index_code
					elseif basicInfo.sub_type == 3 then
						wing = basicInfo.animation_index_code
					end
				end
			end
		end
	end
	--设置默认显示
	local gameParam = CacheCenter:getGameParam()
	if nSex == true then
		if head == nil then head = GDatatab_item["id_"..gameParam.defaultManHeadId].animation_index_code end
		if face == nil then face = GDatatab_item["id_"..gameParam.defaultManFaceId].animation_index_code end
		if body == nil then body = GDatatab_item["id_"..gameParam.defaultManBodyId].animation_index_code end
	else
		if head == nil then head = GDatatab_item["id_"..gameParam.defaultWomanHeadId].animation_index_code end
		if face == nil then face = GDatatab_item["id_"..gameParam.defaultWomanFaceId].animation_index_code end
		if body == nil then body = GDatatab_item["id_"..gameParam.defaultWomanBodyId].animation_index_code end
	end

	local conPlayer
	local conPlayerAni = GetElement(self.m_root, "conPlayerAni_WndDressCastSoul", WZUIContainer)

	if not self.conPlayer then 
		conPlayer = YDPlayerAnimation:createAnimation(nSex)
		conPlayer:getAnimNode():setTag(50)
		conPlayerAni:addChild(conPlayer:getAnimNode())
		self.conPlayer = conPlayer
	else
		conPlayer = self.conPlayer
		changeDress = true
	end
	self.conPlayer:getAnimNode():setTouchEnable(false)

	WZLog("WndDressCastSoul:showPlayer", headColor, bodyColor)
	conPlayer:setHead(head, headColor)
	conPlayer:setFace(face)
	conPlayer:setBody(body)
	conPlayer:setBodyRanSe(bodyColor)
	if wing then
		conPlayer:setWing(wing)
	end

	conPlayer:play("wait0", true)

	self:showCurSelSuit()
end

--@brief	展示当前选中的时装
function WndDressCastSoul:showCurSelSuit()
	-- body
	local tDressList = {}
	local lastTime = {}
	if self.m_nTabIndex == 1 then 
		tDressList = self.m_tSuitList[self.m_nSuitIndex].suitId
		lastTime = self.m_tSuitList[self.m_nSuitIndex].lastTime
	elseif self.m_nTabIndex == 2 then 
		tDressList = {} 
		tDressList[1] = self.m_tWingList[self.m_nWingIndex].suitId
		lastTime= {}
		lastTime[1] = self.m_tWingList[self.m_nWingIndex].lastTime
	elseif self.m_nTabIndex == 3 then 
		tDressList = {} 
		tDressList[1] = self.m_tTitleList[self.m_nTitleIndex].suitId
		lastTime= {}
		lastTime[1] = self.m_tTitleList[self.m_nTitleIndex].lastTime
	end 
	for i = 1, 3 do
		GetElement(self.m_root, "conCur" .. (i - 1) .. "_WndDressCastSoul", WZUIContainer):setVisible(false)
	end
	WZLog("WndDressCastSoul:showCurSelSuit", Serialize(tDressList))
	for i = 1, #tDressList do
		local basicInfo = GDatatab_item["id_" .. tDressList[i]]
		if basicInfo ~= nil then
			local conCur 
			if self.m_nTabIndex == 1 then 
				conCur = GetElement(self.m_root, "conCur" .. basicInfo.sub_type .. "_WndDressCastSoul", WZUIContainer)
				if i == 1 then 
					conCur:setRelativePosition(GlobalMethod:ccp(0.5, 0.85))
				end
			elseif self.m_nTabIndex == 2 then 
				conCur = GetElement(self.m_root, "conCur0_WndDressCastSoul", WZUIContainer)
				conCur:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
			elseif self.m_nTabIndex == 3 then 
				conCur = GetElement(self.m_root, "conCur0_WndDressCastSoul", WZUIContainer)
				conCur:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
			end
			conCur:setVisible(true)
			local conGood = GetElement(conCur, "conGood_WndDressCastSoul", WZUIContainer)

			conGood:removeAllChildrenWithCleanup(true)

			local element, tNewObj = CellGoodItem:createElement()
			if element and tNewObj then 
				tNewObj:setCellGoodLocalId(tDressList[i], lastTime[i], 18)
				tNewObj:_setItemVisible(false)
				tNewObj:setItemClickFun(self, self.onClickItem)
				conGood:addChild(element)
			end
			--商城出售的，显示价格角标
			local priceShop = [[<I Z="0.35" P="1">%s</I><T C="255,255,255" S="16" P="1" SC="105,65,46" SS="4" SE="1">%d</T>]]
			local ftxtPrice = GetElement(conCur, "ftxtPrice_WndDressCastSoul", WZUIFreeTextBox)
			if lastTime[i] == -1 or lastTime[i] > 0 then 
				GetElement(conCur, "imgCorner_WndDressCastSoul", WZUIImage):setVisible(true)
				GetElement(conCur, "txtHavedWord_WndDressCastSoul", WZUILabelTTF):setVisible(true)
				ftxtPrice:setVisible(false)
				GetElement(conCur, "txtUnCollect_WndDressCastSoul", WZUILabelTTF):setVisible(false)
			else
				GetElement(conCur, "imgCorner_WndDressCastSoul", WZUIImage):setVisible(false)
				GetElement(conCur, "txtHavedWord_WndDressCastSoul", WZUILabelTTF):setVisible(false)
				ftxtPrice:setVisible(false)
				GetElement(conCur, "txtUnCollect_WndDressCastSoul", WZUILabelTTF):setVisible(true)
				if CacheCenter:itemIsOnSale(tDressList[i]) then 
					local shopData = CacheCenter:getShopDataByItemId(tDressList[i])
					if shopData ~= -1 then 
						tNewObj:setItemClickFun(self, self.onClickItem2)

						GetElement(conCur, "imgCorner_WndDressCastSoul", WZUIImage):setVisible(true)
						ftxtPrice:setVisible(true)
						local agingPrice = json.decode(shopData.agingPrice)
						WZLog("WndDressCastSoul:showCurSelSuit", Serialize(agingPrice))
						local minPrice = nil 
						for i = 0, 2 do
					        local data = agingPrice[tostring(i)]
					        if data then
					            for k,v in pairs(data) do
					                if minPrice == nil then 
					                	minPrice = tonumber(v)
					                elseif minPrice > tonumber(v) then 
					                	minPrice = tonumber(v)
					                end
					            end
					        end
					    end
					    minPrice = math.ceil(minPrice*shopData.discount/10000) --折扣
						ftxtPrice:setShowText(string.format(priceShop, GDatatab_item["id_" .. shopData.moneyId].icon, minPrice))
					end
				end
			end
		end
	end
end

--@brief 	根据标签选择显示的内容
function WndDressCastSoul:showContentByTab()
	-- body
	local tTitleStr = {LocalStrings.CASTSOUL_TEXT2, LocalStrings.CASTSOUL_TEXT20, LocalStrings.OTHER_TEXT1[2]}
	GetElement(self.m_root, "conCurSuit_WndDressCastSoul", WZUIContainer):setVisible(true)
	local txtSoulType = GetElement(self.m_root, "txtSoulType_WndDressCastSoul", WZUILabelTTF)
	txtSoulType:setText(tTitleStr[self.m_nTabIndex])
	--已收集的数量
	local num = self:getCollectSuitNum()
	local txtCollectNum = GetElement(self.m_root, "txtCollectNum_WndDressCastSoul", WZUIFreeTextBox)
	if txtCollectNum then 
		if self.m_nTabIndex == 3 then 
			txtCollectNum:setShowText(string.format(LocalStrings.OTHER_TEXT1[7], num))
		else
			txtCollectNum:setShowText(string.format(LocalStrings.OPTIMIZE_TEXT3, num))
		end
	end

	local imgTurnRedDot = GetElement(self.m_root, "imgTurnRedDot_WndDressCastSoul", WZUIImage)
	if self:checkTurnPageRed() then
		imgTurnRedDot:setVisible(true) --红点
	else
		imgTurnRedDot:setVisible(false)
	end
end

--@brief 	检测翻页红点,用来提示玩家翻到槽位有红点的一页
function WndDressCastSoul:checkTurnPageRed()
	local nTotalPage = 3
	local nextPage = (self.m_nTabIndex + 1) % nTotalPage == 0 and 3 or (self.m_nTabIndex + 1) % nTotalPage
	local nSlotCount = self:getCollectSuitNum(nextPage)

	local tGridSoul 
	if nextPage == 1 then 
		tGridLevel = self.m_tSuitOpenLevel
		tGridSoul = self.m_tSuitSoulList
	elseif nextPage == 2 then 
		tGridLevel = self.m_tWingOpenLevel
		tGridSoul = self.m_tWingSoulList
	elseif nextPage == 3 then 
		tGridLevel = self.m_tTitleOpenLevel
		tGridSoul = self.m_tTitleSoulList
	end
	local nUnlockCount = 0 --解锁的数量
	local nEquippedCount = 0 --已装备的数量
	for i = 1, #tGridLevel do
		if nSlotCount >= tGridLevel[i] then
			nUnlockCount = nUnlockCount + 1
		end
		if tGridSoul[i] and tGridSoul[i].soulId and tGridSoul[i].soulId > 0 then
			nEquippedCount = nEquippedCount + 1
		end
	end
	
	if nUnlockCount > nEquippedCount then
		return true
	end
	return false
end

--@brief 	显示套装列表
function WndDressCastSoul:showSuitList()
	-- body
	local tSuitList 
	local nSelIndex 
	if self.m_nTabIndex == 1 then 
		tSuitList = self.m_tSuitList
		nSelIndex = self.m_nSuitIndex
	elseif self.m_nTabIndex == 2 then 
		tSuitList = self.m_tWingList
		nSelIndex = self.m_nWingIndex
	elseif self.m_nTabIndex == 3 then 
		tSuitList = self.m_tTitleList
		nSelIndex = self.m_nTitleIndex
	end

	local tableSuitList = GetElement(self.m_root, "tableSuitList_WndDressCastSoul", WZUITableContainer)
	tableSuitList:cleanTable()
	tableSuitList:setMoveActionFinishCallback("actionPlaying")
	self.m_tCurSelCell = nil  

	--创建一个空白的
	local element, tNewObj = CellDressCastSoul:createElement()
	if element and tNewObj then 
		element:setTag(0)
		element:setVisible(false)
		tNewObj:setData(nil, self.m_nTabIndex)
		element:setScale(0.84)

		tableSuitList:setCellElement(element)
	end

	for i = 1, #tSuitList do
		local element, tNewObj = CellDressCastSoul:createElement()
		if element and tNewObj then 
			element:setTag(i)
			tNewObj:setData(tSuitList[i], self.m_nTabIndex)
			if nSelIndex == i then 
				element:setScale(1)
				tNewObj:setSelState(true)
				self.m_tCurSelCell = tNewObj 
			else
				element:setScale(0.84)
			end

			tableSuitList:setCellElement(element)
		end
	end

	--创建2个空白的
	local nTempTag = #tSuitList + 1
	local element, tNewObj = CellDressCastSoul:createElement()
	if element and tNewObj then 
		element:setTag(nTempTag)
		element:setVisible(false)
		tNewObj:setData(nil, self.m_nTabIndex)
		element:setScale(0.84)

		tableSuitList:setCellElement(element)
	end

	nTempTag = nTempTag + 1
	local element, tNewObj = CellDressCastSoul:createElement()
	if element and tNewObj then 
		element:setTag(nTempTag)
		element:setVisible(false)
		tNewObj:setData(nil, self.m_nTabIndex)
		element:setScale(0.84)

		tableSuitList:setCellElement(element)
	end
end

--@brief 	显示元魂列表
function WndDressCastSoul:showGridList()
	local tGridLevel1
	local tGridSoul1 
	if self.m_nTabIndex == 1 then 
		tGridLevel1 = self.m_tSuitOpenLevel
		tGridSoul1 = self.m_tSuitSoulList
	elseif self.m_nTabIndex == 2 then 
		tGridLevel1 = self.m_tWingOpenLevel
		tGridSoul1 = self.m_tWingSoulList
	elseif self.m_nTabIndex == 3 then 
		tGridLevel1 = self.m_tTitleOpenLevel
		tGridSoul1 = self.m_tTitleSoulList
	end
	local nHaveNum = self:getCollectSuitNum()

	local tGridLevel2
	local tGridSoul2
	if self.m_nTabIndex == 1 then
		tGridLevel2 = self.m_tSuitGMOpenLevel
		tGridSoul2 = self.m_tSuitResponseList
	elseif self.m_nTabIndex == 2 then
		tGridLevel2 = self.m_tWingGMOpenLevel
		tGridSoul2 = self.m_tWingResponseList
	elseif self.m_nTabIndex == 3 then
		tGridLevel2 = self.m_tTitleGMOpenLevel
		tGridSoul2 = self.m_tTitleResponseList
	end

	local nCountCol = math.ceil(#tGridLevel1 / 3)
	local nLevelCol = #tGridLevel2
	local nMaxCol = math.max(nCountCol,nLevelCol)

	local tcGridList = GetElement(self.m_root,"tcGridList_WndDressCastSoul",WZUITableContainer)
	--提前保存列表位置坐标
	if self.m_nMoveElementPosX ~= nil then
		self.m_nMoveElementPosX = tcGridList:getMoveElement():getPositionX()
	end
	tcGridList:cleanTable()
	for i=1,(nMaxCol * 4) do
		local conGrid = CreateElement("conGrid_WndDressCastSoul")
		conGrid:setTag(i-1)
		conGrid:setVisible(false)
		tcGridList:setCellElement(conGrid)

		local txtLock = GetElement(conGrid, "txtLock_WndDressCastSoul", WZUILabelTTF)
		local conLock = GetElement(conGrid, "conLock_WndDressCastSoul", WZUIContainer)
		local conAdd = GetElement(conGrid, "conAdd_WndDressCastSoul", WZUIContainer)
		local imgRedDot = GetElement(conGrid, "imgRedDot_WndDressCastSoul", WZUIImage)

		local txtSoulLevel = GetElement(conGrid, "txtSoulLevel_WndDressCastSoul", WZUILabelTTF)
		local txtStoneAtt = GetElement(conGrid, "txtStoneAtt_WndDressCastSoul", WZUILabelTTF)

		local btnAdd = GetElement(conGrid, "btnAdd_WndDressCastSoul", WZUIButton)
		local btnLock = GetElement(conGrid, "btnLock_WndDressCastSoul", WZUIButton)

		conLock:setVisible(false)
		conAdd:setVisible(false)
		imgRedDot:setVisible(false)

		if i % 4 ~= 0 then --数量解锁
			local index = (math.ceil(i/4)-1)*3+i%4
			if tGridLevel1[index] then
				conGrid:setVisible(true)

				btnAdd:setTag(index)
				btnLock:setTag(index)

				if self.m_nTabIndex == 3 then 
					txtLock:setText(string.format(LocalStrings.OTHER_TEXT1[6], tGridLevel1[index]))
				else
					txtLock:setText(string.format(LocalStrings.CASTSOUL_TEXT5, tGridLevel1[index]))
				end

				if self.m_nTabIndex == 3 then
					txtStoneAtt:setText(LocalStrings.CASTSOUL_TEXT7)
				else
					txtStoneAtt:setText(LocalStrings.CASTSOUL_TEXT7 .. "\n" .. "(" .. LocalStrings.CASTSOUL_TEXT8[math.fmod((index - 1), 3) + 1] .. ")")
				end

				txtSoulLevel:setVisible(false)

				if nHaveNum >= tGridLevel1[index] then 
					if tGridSoul1[index] and tGridSoul1[index].soulId and tGridSoul1[index].soulId > 0 then 
						conLock:setVisible(false)
						conAdd:setVisible(false)
						imgRedDot:setVisible(false) --红点

						local element, tNewObj = CellGoodItem:createElement()
						if element and tNewObj then 
							element:setTag(99)
							local levelInfo = CopyTable(GDatatab_spirit["id_" .. tGridSoul1[index].soulId])
							-- 这里写死了第9个以后的元魂有使用另一套配置
							if index > 9 then
								levelInfo.exp = levelInfo.exp2
								levelInfo.property = levelInfo.property2
								levelInfo.rate = levelInfo.rate2
								levelInfo.luckeylimit = levelInfo.luckeylimit2
							end
							levelInfo.exp2 = nil
							levelInfo.property2 = nil
							levelInfo.rate2 = nil
							levelInfo.luckeylimit2 = nil

							local key = "id_" .. levelInfo.item_id
							local basicInfo = CopyTable(GDatatab_item[key])
							basicInfo.icon = levelInfo.icon
							basicInfo.quality = levelInfo.quality
							basicInfo.property = levelInfo.property
							basicInfo.gridId = index
							basicInfo.levelInfo = levelInfo
							basicInfo.lucky = tGridSoul1[index].lucky

							local itemInfo = {id = levelInfo.item_id, name="", icon=levelInfo.icon, lastTime=0, quality = levelInfo.quality, basicInfo = basicInfo, level = levelInfo.level, gridId = index, cost = levelInfo.exp}
							tNewObj:setCellGoodItem(itemInfo, 17)
							tNewObj:setItemClickFun(self, self.clickSoulItem)
							txtSoulLevel:setVisible(true)
							txtSoulLevel:setText(LocalStrings.LV .. levelInfo.level)

							conGrid:addChild(element)
						end
					else
						conLock:setVisible(false)
						conAdd:setVisible(true)
						imgRedDot:setVisible(true) --红点
					end
				else
					conLock:setVisible(true)
					conAdd:setVisible(false)
					imgRedDot:setVisible(false) --红点
				end

			end
		else --等级解锁
			local index = math.ceil(i/4)
			if tGridLevel2[index] then
				conGrid:setVisible(true)

				btnAdd:setTag(#tGridSoul1 + index)
				btnLock:setTag(#tGridSoul1 + index)

				txtLock:setText(string.format(LocalStrings.CASTSOUL_TEXT22, tGridLevel2[index]))

				txtStoneAtt:setText(LocalStrings.CASTSOUL_TEXT21)

				txtSoulLevel:setVisible(false)

				local bIsOpen = self:judgeOpenResponseGrid(index, tGridLevel2[index])
				if bIsOpen then 
					if tGridSoul2[index] and tGridSoul2[index].soulId and tGridSoul2[index].soulId > 0 then 
						GetElement(conGrid, "conLock_WndDressCastSoul", WZUIContainer):setVisible(false)
						GetElement(conGrid, "conAdd_WndDressCastSoul", WZUIContainer):setVisible(false)
						GetElement(conGrid, "imgRedDot_WndDressCastSoul", WZUIImage):setVisible(false) --红点

						local element, tNewObj = CellGoodItem:createElement()
						if element and tNewObj then 
							element:setTag(99)
							local levelInfo = CopyTable(GDatatab_spirit["id_" .. tGridSoul2[index].soulId])
							-- 这里写死了第3个以后的元魂有使用另一套配置
							if index > 3 then
								levelInfo.exp = levelInfo.exp2
								levelInfo.property = levelInfo.property2
								levelInfo.rate = levelInfo.rate2
								levelInfo.luckeylimit = levelInfo.luckeylimit2
							end
							levelInfo.exp2 = nil
							levelInfo.property2 = nil
							levelInfo.rate2 = nil
							levelInfo.luckeylimit2 = nil

							local key = "id_" .. levelInfo.item_id
							local basicInfo = CopyTable(GDatatab_item[key])
							basicInfo.icon = levelInfo.icon
							basicInfo.quality = levelInfo.quality
							basicInfo.property = levelInfo.property
							basicInfo.gridId = index
							basicInfo.levelInfo = levelInfo
							basicInfo.lucky = tGridSoul2[index].lucky

							local itemInfo = {id = levelInfo.item_id, name="", icon=levelInfo.icon, lastTime=0, quality = levelInfo.quality, basicInfo = basicInfo, level = levelInfo.level, gridId = index, cost = levelInfo.exp}
							tNewObj:setCellGoodItem(itemInfo, 17)
							tNewObj:setItemClickFun(self, self.clickSoulItem)
							txtSoulLevel:setVisible(true)
							txtSoulLevel:setText(LocalStrings.LV .. levelInfo.level)

							conGrid:addChild(element)
						end
					else
						GetElement(conGrid, "conLock_WndDressCastSoul", WZUIContainer):setVisible(false)
						GetElement(conGrid, "conAdd_WndDressCastSoul", WZUIContainer):setVisible(true)
						GetElement(conGrid, "imgRedDot_WndDressCastSoul", WZUIImage):setVisible(true) --红点
					end
				else
					GetElement(conGrid, "conLock_WndDressCastSoul", WZUIContainer):setVisible(true)
					GetElement(conGrid, "conAdd_WndDressCastSoul", WZUIContainer):setVisible(false)
					GetElement(conGrid, "imgRedDot_WndDressCastSoul", WZUIImage):setVisible(false) --红点
				end
			end
		end

		if ProjConfig.LANGUAGE == "vn" then
			txtLock:setScale(0.8)
			txtLock:setDimensions(CCSize(80,0))
			txtStoneAtt:setScale(0.8)
			txtStoneAtt:setDimensions(CCSize(80,0))
		end
	end

	-- 设置列表位置坐标
	if self.m_nMoveElementPosX == nil then
		tcGridList:getMoveElement():setPositionX(tcGridList:getMaxPosition().x)
		self.m_nMoveElementPosX = tcGridList:getMoveElement():getPositionX()
	else
		tcGridList:getMoveElement():setPositionX(self.m_nMoveElementPosX)
	end

end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------

function WndDressCastSoul:_adaptLanguage_vn()

end

-------------------------------------语言适配end----------------------------------------
