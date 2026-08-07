--WndHVDivineTree.lua
--@brief	WndHVDivineTree的UI模块
--@date		2023/06/06
--@author	XTX
--@note		度假村-精灵神树


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVDivineTree:onEnter(element)
	self.m_root = element

	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	GlobalGame:getGameEventDispathcer():Add(HolidayVEvent.HolidayVEvent_GetDivineTreeInfo,self._getDivineInfo,self)
	GlobalGame:getGameEventDispathcer():Add(HolidayVEvent.HolidayVEvent_ChooseFruit,self._chooseFruit,self)
	GlobalGame:getGameEventDispathcer():Add(HolidayVEvent.HolidayVEvent_SpeedFruit,self._speedFruit,self)
	self:_initStaticText()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVDivineTree:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	GlobalGame:getGameEventDispathcer():Remove(HolidayVEvent.HolidayVEvent_GetDivineTreeInfo,self._getDivineInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(HolidayVEvent.HolidayVEvent_ChooseFruit,self._chooseFruit,self)
	GlobalGame:getGameEventDispathcer():Remove(HolidayVEvent.HolidayVEvent_SpeedFruit,self._speedFruit,self)
	if self.m_root then 
		local spineTree = GetElement(self.m_root, "spineTree_WndHVDivineTree", WZUISpine)
		spineTree:disableSchedule()
		self.m_root:disableSchedule()
	end
	self:_unInit()
end

--@brief    onenter函数已执行
function WndHVDivineTree:onEnterTransitionDidFinish(element)
    WZLog("WndHVDivineTree:onEnterTransitionDidFinish")
    ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_TreeDetails()
	self:_createItemList()
end

--@brief    关闭窗口
function WndHVDivineTree:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    local nTag = element:getTag()
    if nTag == 2 then 
    	GetElement(self.m_root, "conChooseFruit_WndHVDivineTree", WZUIContainer):setVisible(false)
    else
		WindowManager:removeWindow(self.m_root, self, true)
	end
end

--@brief    点击规则按钮回调
function WndHVDivineTree:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	
	WndSingleMapDesc:showInterface1(LocalStrings.HOLIDAYVILLAGE_TEXT7) 
end

function WndHVDivineTree:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root, self.m_root, 1, tData, false, nil, true)
end

--@brief 	点击果实回调
function WndHVDivineTree:onClickFruit(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_tDivineTreeInfo.fruits[nTag] then 
		local fruitId = self.m_tDivineTreeInfo.fruits[nTag].fruitId
		if fruitId > 0 then 
			local nCurTime = SystemTime:getServerTime()
			if nCurTime >= self.m_tDivineTreeInfo.fruits[nTag].endTime then --已成熟，可领取
				ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FruitOp(2, nTag - 1, 0)
			else
				local fruitConfig = GDatatab_holiday_tree_fruit["id_" .. fruitId]
				local basicInfo = GDatatab_item["id_" .. fruitConfig.itemId]
				local tData = {}
				tData.basicInfo = basicInfo
				tData.lastNum = tonumber(fruitConfig.num)
				tData.lastTime = tonumber(fruitConfig.num)

				WndItemInfo:onCloseClick()
   				WndItemInfo:showInfo(element, self.m_root, 1, tData, false, nil, true)
			end
		else
			self.m_nClickPos = nTag
			self:showChooseItems()
		end
	else
		local openLv = self:getOpenLevel(nTag)
		MsgBoxManager:showTipBox(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT2[10], openLv))
	end
end

--@brief    点击赠送按钮回调
function WndHVDivineTree:onClickSure(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    if self.m_tSelCell == nil then 
    	MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT2[12])
    	return 
    end
    if self.m_tSelCell.tData.id then 
    	WZLog("WndHVDivineTree:onClickSure", self.m_nClickPos, self.m_tSelCell.tData.id)
    	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_FruitOp(1, self.m_nClickPos - 1, self.m_tSelCell.tData.id)
    end
    GetElement(self.m_root, "conChooseFruit_WndHVDivineTree", WZUIContainer):setVisible(false)
end

--@brief 	触摸开始
function WndHVDivineTree:onTouchBegin(element, pt)
	WndItemInfo:onCloseClick()
	self.m_nTouchStartTime = WZThread:getTickCount()
	self.m_nUseItemIndex = self:checkPointInBtn(pt)
	self.m_tTouchStartPos = {x = pt.x, y = pt.y}
	if self.m_nUseItemIndex > 0 then 
		local ownNum = CacheCenter:getPlayerItemCountById(self.m_tItemIdList[self.m_nUseItemIndex])
		if ownNum <= 0 then 
			self.m_nUseItemIndex = 0
		else
			if self.m_nodeImage == nil then 
				local basicInfo = GDatatab_item["id_" .. self.m_tItemIdList[self.m_nUseItemIndex]]
				self.m_nodeImage = WZUIImage:create()		--创建图片
				local ptA = self.m_nodeTreeCon:convertToNodeSpace(pt)
				self.m_nodeImage:setUseAbsCoordinate(true)
				self.m_nodeImage:setUseOriginSize(true)			--图片原始大小
				self.m_nodeImage:setScale(0.8)
				self.m_nodeImage:setFile(basicInfo.icon) 					--图片路径
				
				self.m_nodeTreeCon:addChild(self.m_nodeImage, 4, 88)
				self.m_nodeImage:setPosition(ptA)			--图片相对位置
			end
		end
	end
end

--@brief 	触摸开始
function WndHVDivineTree:onTouchEnd(element, pt)
	local nTempIndex = self:checkPointInBtn(pt)
	local nUseItemIndex = self:checkPointInBtn(self.m_tTouchStartPos)
	if nTempIndex == nUseItemIndex and nTempIndex ~= 0 then 
		local nCurTime = WZThread:getTickCount()
		if BattleCommon:pointDis(self.m_tTouchStartPos, pt) <= 20 and nCurTime - self.m_nTouchStartTime >= 800 then 
			local tData = {}
			tData.basicInfo = GDatatab_item["id_" .. self.m_tItemIdList[self.m_nUseItemIndex]]
			local conItem = GetElement(self.m_root, "conItem" .. self.m_nUseItemIndex .. "_WndHVDivineTree", WZUIContainer)
   			WndItemInfo:showInfo(conItem, self.m_root, 1, tData, false, nil, true)
   			if self.m_nodeImage then 
   				self.m_nodeImage:removeFromParentAndCleanup(true)
				self.m_nodeImage = nil 
				self.m_nUseItemIndex = 0
   			end
			return 
		end
	end
	if self.m_nodeImage then 
        local circle = {x = self.m_nodeImage:getPositionX(),y=self.m_nodeImage:getPositionY(),r = 25}
        for i = 1, #self.m_tRectRange do
            if BattleCommon:rectCircleOverLap(self.m_tRectRange[i], circle) then
            	WZLog("WndHVDivineTree:onTouchEnd", i)
            	if i <= 5 then 
            		local conFruit = GetElement(self.m_root, "conFruit" .. i .. "_WndHVDivineTree", WZUIContainer)
            		if conFruit:isVisible() then 
	            		if self.m_tDivineTreeInfo.fruits[i] and self.m_tDivineTreeInfo.fruits[i].fruitId > 0 and self.m_tDivineTreeInfo.fruits[i].endTime > SystemTime:getServerTime() then 
	            			ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_AccelerationOp(2, self.m_tItemIdList[self.m_nUseItemIndex], 1, i - 1)
	            		else
	            			if not self.m_tDivineTreeInfo.fruits[i] then 
	            				MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT2[15])
	            			elseif self.m_tDivineTreeInfo.fruits[i] and self.m_tDivineTreeInfo.fruits[i].fruitId == 0 then 
	            				MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT2[16])
	            			elseif self.m_tDivineTreeInfo.fruits[i] and self.m_tDivineTreeInfo.fruits[i].fruitId > 0 and self.m_tDivineTreeInfo.fruits[i].endTime <= SystemTime:getServerTime() then 
	            				MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT2[16])
	            			end
	            		end
	            	end
            	elseif i == 6 then 
            		if self.m_tDivineTreeInfo.level >= self.m_nMaxLevel then 
            			MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO170)
            		else
            			ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_AccelerationOp(1, self.m_tItemIdList[self.m_nUseItemIndex], 1, 0)
            		end
            	end
            	break 
            end
        end

		self.m_nodeImage:removeFromParentAndCleanup(true)
		self.m_nodeImage = nil 
	end
	self.m_nUseItemIndex = 0
end

--@brief 	触摸开始
function WndHVDivineTree:onTouchMove(element, pt)
	if self.m_nodeImage then 
		local ptA = self.m_nodeTreeCon:convertToNodeSpace(pt)
		self.m_nodeImage:setPosition(ptA)			--图片相对位置
	end
end

--@brief	检查坐标点是否在VIP按钮范围内
--@param	pt:鼠标点击的世界坐标
--@return	在按钮范围内返回true,否则返回false
function WndHVDivineTree:checkPointInBtn(pt)
	WZLog("WndHVDivineTree:checkPoint")
	if self.m_root == nil then return end
	local conItem = GetElement(self.m_root, "conItem1_WndHVDivineTree", WZUIContainer)

	local btnSize = conItem:getContentSize()
	--获得btn的世界坐标
	local ptA = conItem:convertToWorldSpace(GlobalMethod:ccp(0,0))
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		return 1
	end
	conItem = GetElement(self.m_root, "conItem2_WndHVDivineTree", WZUIContainer)
	btnSize = conItem:getContentSize()
	ptA = conItem:convertToWorldSpace(GlobalMethod:ccp(0,0))
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		return 2
	end 
	conItem = GetElement(self.m_root, "conItem3_WndHVDivineTree", WZUIContainer)
	btnSize = conItem:getContentSize()
	ptA = conItem:convertToWorldSpace(GlobalMethod:ccp(0,0))
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		return 3
	end 

	return 0
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndHVDivineTree:_update()
	self.m_tCurLvConfig = self:getUpgradeExp()
	local needExp = self.m_tCurLvConfig.max - self.m_tDivineTreeInfo.curExp
	self.m_nLeftSeconds = math.ceil(needExp/self.m_tCurLvConfig.exp[1][2]) * self.m_tCurLvConfig.exp[1][1]/1000
	self:_showTime()
	self:_initDynamicText()
	self:_showPro()
	self:_showFruitsState()
	self.m_root:enableSchedule("_showTime", 1)
end

--@brief 	初始化静态文本
function WndHVDivineTree:_initStaticText()
	GetElement(self.m_root, "txtTitle_WndHVDivineTree", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[4])
	GetElement(self.m_root, "txtCurTitle_WndHVDivineTree", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[8])
	GetElement(self.m_root, "txtNextTitle_WndHVDivineTree", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[9])
	GetElement(self.m_root, "txtTitle_conChooseFruit", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[12])
	self.m_nodeTreeCon = GetElement(self.m_root, "conTree_WndHVDivineTree", WZUIContainer)
	self:getCollectRect()

	self.m_nMaxLevel = self:getDivineTreeMaxLv()
end

--@brief 	初始化动态文本
function WndHVDivineTree:_initDynamicText()
	GetElement(self.m_root, "txtTreeLv_WndHVDivineTree", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[5] .. ":" .. self.m_tDivineTreeInfo.level)
end

--@brief 	创建左边丹药列表
function WndHVDivineTree:_createItemList(bUpdateNum)
	if bUpdateNum then 
		for i = 1, #self.m_tItemIdList do
			local num = CacheCenter:getPlayerItemCountById(self.m_tItemIdList[i])
			local tNewObj = self.m_tItemCell[i]
			if tNewObj then 
				tNewObj:setItemNumber(num)
			end
		end
	else
		self.m_tItemCell = {}

		for i = 1, #self.m_tItemIdList do
			local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndHVDivineTree", WZUIContainer)
			conItem:removeAllChildrenWithCleanup(true)

			local num = CacheCenter:getPlayerItemCountById(self.m_tItemIdList[i])
			local element, tNewObj = CellGoodItem:createElement()
			if element and tNewObj then 
				element:setScale(0.8)
				tNewObj:setCellGoodLocalId(self.m_tItemIdList[i], num, 4, true)
				tNewObj:setItemNumber(num)
				tNewObj:_setItemVisible(true)
				tNewObj:setItemClickFun(self, self.onItemClick)

				conItem:addChild(element)
				table.insert(self.m_tItemCell, tNewObj)
			end
		end
	end
end

--@brief 	显示属性
function WndHVDivineTree:_showPro()
	local conCurPro = GetElement(self.m_root, "conCurPro_WndHVDivineTree", WZUIContainer)
	local tCurLvData = SceneHolidayVillage:getDivineTreeConfigByLv(self.m_tDivineTreeInfo.level)
	local tNextLvData = SceneHolidayVillage:getDivineTreeConfigByLv(self.m_tDivineTreeInfo.level + 1)
	self:_showLvPro(conCurPro, tCurLvData)
	--下一级属性
	local conNextPro = GetElement(self.m_root, "conNextPro_WndHVDivineTree", WZUIContainer)
	if tNextLvData then 
		self:_showLvPro(conNextPro, tNextLvData)
	else
		GetElement(self.m_root, "conMax_WndHVDivineTree", WZUIContainer):setVisible(true)
	end
end

--@brief 	
function WndHVDivineTree:_showLvPro(conPro, tData)
	local nCount = #tData.property
	for i = 1, #tData.property do
		local txtProName = GetElement(conPro, "txtProName" .. i .. "_WndHVDivineTree", WZUILabelTTF)
		local txtProValue = GetElement(conPro, "txtProValue" .. i .. "_WndHVDivineTree", WZUILabelTTF)

		txtProName:setText(ATTR_TITLE[tData.property[i][1]])
		txtProValue:setText(tData.property[i][2])
	end

	local txtProName1 = GetElement(conPro, "txtProName" .. (nCount + 1) .. "_WndHVDivineTree", WZUILabelTTF)
	local txtProName2 = GetElement(conPro, "txtProName" .. (nCount + 2) .. "_WndHVDivineTree", WZUILabelTTF)
	txtProName1:setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[6] .. (tData.addition / 100) .. "%")
	txtProName2:setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[7] .. tData.num)
end

--@brief 	显示神树升级倒计时
function WndHVDivineTree:_showTime()
	local txtTreeTime = GetElement(self.m_root, "txtTreeTime_WndHVDivineTree", WZUILabelTTF)
	if self.m_tDivineTreeInfo.level >= self.m_nMaxLevel then 
		txtTreeTime:setText(LocalStrings.COMMUNITYINFO170)
	else
		if self.m_nLeftSeconds == nil then return end 
		if self.m_nLeftSeconds > 0 then 
			local strTime = returnToTimeFormat_Day(self.m_nLeftSeconds, true)
			txtTreeTime:setText(strTime)

			self.m_nLeftSeconds = self.m_nLeftSeconds - 1
		elseif self.m_nLeftSeconds <= 0 then 
			ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_TreeDetails()
		end
	end

	self:_updateFruitTime()
end

--@brief 	显示可选择的道具
function WndHVDivineTree:showChooseItems()
	GetElement(self.m_root, "conChooseFruit_WndHVDivineTree", WZUIContainer):setVisible(true)
	local tItemList = {}
	local tCurLvData = SceneHolidayVillage:getDivineTreeConfigByLv(self.m_tDivineTreeInfo.level)
	for i, value in pairs(GDatatab_holiday_tree_fruit) do
		if value.lvl <= self.m_tDivineTreeInfo.level then 
			local tTempValue = CopyTable(value)
			tTempValue.time = math.ceil(tTempValue.time * (1 - tCurLvData.addition/10000))
			table.insert(tItemList, tTempValue)
		end
	end

	local tableList = GetElement(self.m_root, "tableList_conChooseFruit", WZUITableContainer)
	tableList:cleanTable()

	for i = 1, #tItemList do
		local element, tNewObj = CellMounts:createElement()
        if element and tNewObj then 
	        element:setTag(i - 1)
	        tNewObj:setCellAllElement(tItemList[i])
	        tNewObj:setListType(3)
	        tableList:setCellElement(element)
	    end
	end
end

--@brief 	设置果实状态
function WndHVDivineTree:_showFruitsState()
	local nCurTime = SystemTime:getServerTime()
	local levelConfig = SceneHolidayVillage:getDivineTreeConfigByLv(self.m_tDivineTreeInfo.level)
	for i = 1, 5 do
		local conFruit = GetElement(self.m_root, "conFruit" .. i .. "_WndHVDivineTree", WZUIContainer)
		local spineFruit = GetElement(self.m_root, "spineFruit" .. i .. "_WndHVDivineTree", WZUISpine)
		local txtFruitState = GetElement(self.m_root, "txtFruitState" .. i .. "_WndHVDivineTree", WZUILabelTTF)
		if levelConfig then 
			local actionName = string.gsub(levelConfig.action, "Ss", "Zz")
			spineFruit:play(actionName, true)
		end
		if self.m_tDivineTreeInfo.fruits[i] then 
			spineFruit:setGrayRender(false)
			local fruitId = self.m_tDivineTreeInfo.fruits[i].fruitId
			if fruitId > 0 then 
				local fruitData = GDatatab_holiday_tree_fruit["id_" .. fruitId]
				if nCurTime >= self.m_tDivineTreeInfo.fruits[i].endTime then 
					txtFruitState:setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[13])
					txtFruitState:setColor(GlobalMethod:ccc3(99,255,95))
				else
					local seconds = self.m_tDivineTreeInfo.fruits[i].endTime - nCurTime
					local strTime = returnToTimeFormat_Day(seconds, true)
					txtFruitState:setColor(GlobalMethod:ccc3(255,236,193))
					txtFruitState:setText(strTime .. "\n" .. LocalStrings.HOLIDAYVILLAGE_TEXT2[14])
				end
				-- if conFruit:getChildByTag(11) then 
				-- 	conFruit:removeChildByTag(11, true)
				-- end
				-- local element, tNewObj = CellGoodItem:createElement()
				-- if element and tNewObj then 
				-- 	element:setTag(11)
				-- 	element:setScale(0.5)
				-- 	tNewObj:setCellGoodLocalId(fruitData.itemId, fruitData.num, 15)
				-- 	tNewObj:setItemNumber(fruitData.num)
				-- 	conFruit:addChild(element)
				-- end
			else
				txtFruitState:setText("")
			end
		else
			txtFruitState:setText("")
			spineFruit:setGrayRender(true)
		end
	end
end

--@brief 	果实成熟倒计时
function WndHVDivineTree:_updateFruitTime()
	local nCurTime = SystemTime:getServerTime()

	for i = 1, 5 do
		local conFruit = GetElement(self.m_root, "conFruit" .. i .. "_WndHVDivineTree", WZUIContainer)
		local txtFruitState = GetElement(self.m_root, "txtFruitState" .. i .. "_WndHVDivineTree", WZUILabelTTF)
		if self.m_tDivineTreeInfo.fruits[i] then 
			local fruitId = self.m_tDivineTreeInfo.fruits[i].fruitId
			if fruitId > 0 then 
				if nCurTime == self.m_tDivineTreeInfo.fruits[i].endTime then 
					txtFruitState:setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[13])
					txtFruitState:setColor(GlobalMethod:ccc3(99,255,95))
				elseif nCurTime < self.m_tDivineTreeInfo.fruits[i].endTime then 
					local seconds = self.m_tDivineTreeInfo.fruits[i].endTime - nCurTime
					local strTime = returnToTimeFormat_Day(seconds, true)
					txtFruitState:setColor(GlobalMethod:ccc3(255,236,193))
					txtFruitState:setText(strTime .. "\n" .. LocalStrings.HOLIDAYVILLAGE_TEXT2[14])
				end
			end
		end
	end
end

--@brief 	获取时间结晶生效区域
function WndHVDivineTree:getCollectRect()
	self.m_tRectRange = {}
	for i = 1, 5 do
		local conFruit = GetElement(self.m_root, "conFruit" .. i .. "_WndHVDivineTree", WZUIContainer)
		local conSize = conFruit:getContentSize()
		local rectFruit = {x=conFruit:getPositionX() - conSize.width/2, y=conFruit:getPositionY() - conSize.height/2, w=conSize.width, h=conSize.height}
		table.insert(self.m_tRectRange, rectFruit)
	end
	local conTreeBottom = GetElement(self.m_root, "conTreeBottom_WndHVDivineTree", WZUIContainer)
	local conSize = conTreeBottom:getContentSize()
	local rectTreeB = {x=conTreeBottom:getPositionX() - conSize.width/2, y=conTreeBottom:getPositionY() - conSize.height/2, w=conSize.width, h=conSize.height}
	table.insert(self.m_tRectRange, rectTreeB)
end


-------------------------------------私有方法模块End----------------------------------------



function WndHVDivineTree:_adaptLanguage_vn()
	local conCurPro = GetElement(self.m_root,"conCurPro_WndHVDivineTree",WZUIContainer)
	for i=1,5 do
		local txtProName = GetElement(conCurPro,"txtProName"..i.."_WndHVDivineTree",WZUILabelTTF)
		txtProName:setScale(0.7)
	end
	local txtProName6 = GetElement(conCurPro,"txtProName6_WndHVDivineTree",WZUILabelTTF)
	txtProName6:setScale(0.7)
	txtProName6:setDimensions(GlobalMethod:CCSize(290,0))
	txtProName6:setAlignment(kCCTextAlignmentLeft)
	GetElement(conCurPro,"txtProValue6_WndHVDivineTree",WZUILabelTTF):setScale(0.7)
	local txtProName7 = GetElement(conCurPro,"txtProName7_WndHVDivineTree",WZUILabelTTF)
	txtProName7:setScale(0.7)
	txtProName7:setDimensions(GlobalMethod:CCSize(290,0))
	txtProName7:setAlignment(kCCTextAlignmentLeft)
	GetElement(conCurPro,"txtProValue7_WndHVDivineTree",WZUILabelTTF):setScale(0.7)
	
	local conNextPro = GetElement(self.m_root,"conNextPro_WndHVDivineTree",WZUIContainer)
	for i=1,5 do
		local txtProName = GetElement(conNextPro,"txtProName"..i.."_WndHVDivineTree",WZUILabelTTF)
		txtProName:setScale(0.7)
	end
	local txtProName6 = GetElement(conNextPro,"txtProName6_WndHVDivineTree",WZUILabelTTF)
	txtProName6:setScale(0.7)
	txtProName6:setDimensions(GlobalMethod:CCSize(290,0))
	txtProName6:setAlignment(kCCTextAlignmentLeft)
	GetElement(conNextPro,"txtProValue6_WndHVDivineTree",WZUILabelTTF):setScale(0.7)
	local txtProName7 = GetElement(conNextPro,"txtProName7_WndHVDivineTree",WZUILabelTTF)
	txtProName7:setScale(0.7)
	txtProName7:setDimensions(GlobalMethod:CCSize(290,0))
	txtProName7:setAlignment(kCCTextAlignmentLeft)
	GetElement(conNextPro,"txtProValue7_WndHVDivineTree",WZUILabelTTF):setScale(0.7)
end
