--WndPhantomData.lua
--@brief	WndPhantom的数据模块
--@date		2017/04/25
--@author	zsq
--@note		幻化主界面

WndPhantom = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPhantom:_init()
	self.m_root = nil	 	  			--场景根节点
	self.conPlayer = nil
	self.m_tSelectedCell = nil
	self.m_tCards = nil
	self.m_bShowAll = true
	self.m_nTab = 1
	self.showId = nil
	self.conPosition3 = nil
	self.m_tCellDressSuit = nil 		--多套时装的cell
	self.maxStarLevel = 0 				--最大進階等級
	self.m_bIsUseDiamondRefine = false 	--使用钻石炼化
	self.m_nTotalSkinNum = 0 			--皮肤的总数量
	self.m_nNextShapeId = nil 			--升品后的皮肤Id

    self.m_bIsFirst = true 
    self.m_nMoveMaxDis = nil 
    self.m_tOriginPos = nil 
    self.m_nRunIndex = nil 
    self.firstEntry = nil
    self.nAttackStep = nil 				--攻击步骤: 1抬手 2攻击 3收手
    self.m_nRefineTag = 1 				--是一次炼化还是5次炼化
    self.m_tMultiRefineData = nil       --用于保存多次炼化数据，用于关闭炼化记录后，更新本地数据（不用服务端推送更新）
    self.m_bCanStartRefine = true 		--是否可以开始炼化
    self.RefineData = {}				--羁绊格子数据
    self.m_phantomList = nil				--羁绊格子表

    self.m_nSelectedShapeId = nil 		--在创建界面后用来选中指定皮肤
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPhantom:_unInit()
	self.m_root = nil
	self.conPlayer = nil
	self.m_tSelectedCell = nil
	self.m_tCards = nil
	self.m_bShowAll = nil
	self.m_nTab = nil
	self.showId = nil
	self.conPosition3 = nil
	self.m_tCellDressSuit = nil 		--多套时装的cell
	self.maxStarLevel = nil 
	self.m_bIsUseDiamondRefine = nil 
	self.m_nTotalSkinNum = nil 			--皮肤的总数量
	self.m_nNextShapeId = nil

    self.m_bIsFirst = true 
    self.m_nMoveMaxDis = nil 
    self.m_tOriginPos = nil 
    self.m_nRunIndex = nil 
    self.firstEntry = nil 
    self.nAttackStep = nil
    self.m_nRefineTag = nil 
    self.m_tMultiRefineData = nil
    self.m_bCanStartRefine = false 		--是否可以开始炼化
    self.RefineData = nil
    self.m_phantomList = nil

    self.m_nSelectedShapeId = nil 		--在创建界面后用来选中指定皮肤
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPhantom:createElement()
	if WndPhantom.m_root ~= nil then
		WindowManager:removeWindow(WndPhantom.m_root, WndPhantom, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPhantom")
	assert(element, "WndPhantom create element failed!")
	self:_init()
	return element
end

--@brief	在创建界面后用来选中指定皮肤
function WndPhantom:setSelectedShapeId(shapeId)
	self.m_nSelectedShapeId = shapeId
end

--@brief    更新多套时装数据
function WndPhantom:updateDressSuitData(nType)
    -- body
    if self.m_tCellDressSuit == nil then return end 
    if nType == 1 then
    	self.m_tCellDressSuit:changeDressSuitOK()
    else
    	self.m_tCellDressSuit:setSuitData()
    end
end

--@brief 	炼化结果
function WndPhantom:refineSuccess(result, shapeId, refineProperty, saveStatus, fighting)
	--body
	if result == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT28)
		local tData = self.m_tSelectedCell.m_tData
		local refineProNum = self:getRefinePropertyNum(tData)
		if self.m_nRefineTag == 1 then 
			local tabRefineProp = self:caleRefineResult(tData, refineProperty, {1})
			local tSaveShowProp = {}
			for j = 1, #tabRefineProp[1] do
				if tSaveShowProp[tostring(tabRefineProp[1][j][1])] == nil then
					tSaveShowProp[tostring(tabRefineProp[1][j][1])] = 0
				end
				tSaveShowProp[tostring(tabRefineProp[1][j][1])] = tSaveShowProp[tostring(tabRefineProp[1][j][1])] + tabRefineProp[1][j][2] 
			end
			for i = 1, #self.m_tDataList do
				if self.m_tDataList[i].shapeId == shapeId then 
					self.m_tDataList[i].refineProperty = self:_arrangeProperty(json.decode(refineProperty[1]))
					self.m_tDataList[i].saveShowProp = self:_arrangeProperty(tSaveShowProp)
					break 
				end
			end
			WZLog("WndPhantom:refineSuccess", Serialize(self:_arrangeProperty(json.decode(refineProperty[1]))))
			if tData.id == shapeId then 
				tData.refineProperty = self:_arrangeProperty(json.decode(refineProperty[1]))
				tData.saveShowProp = self:_arrangeProperty(tSaveShowProp)
				self:_showRefineContent()
			end
			self:setRefineCtr(true)
		elseif self.m_nRefineTag == 5 then 
			local tabRefineProp = self:caleRefineResult(tData, refineProperty, saveStatus)
			local tSaveShowProp = {}
			local saveProperty = nil
			local nActureRefineTimes = 0 
			local refineTimes = #refineProperty
			local sAttaFormat1 = [[<T C="127,70,26" S="20" P="1">%s</T><T C="5,180,0" S="20" P="1">+%d</T><T C="127,70,26" S="20" P="1">，</T>]]
			local sAttaFormat2 = [[<T C="127,70,26" S="20" P="1">%s</T><T C="255,89,74" S="20" P="1">%d</T><T C="127,70,26" S="20" P="1">，</T>]]
			if ProjConfig.LANGUAGE == "vn" then
				sAttaFormat1 = [[<T C="127,70,26" S="18" P="1">%s</T><T C="5,180,0" S="18" P="1">+%d</T><T C="127,70,26" S="18" P="1">，</T>]]
				sAttaFormat2 = [[<T C="127,70,26" S="18" P="1">%s</T><T C="255,89,74" S="18" P="1">%d</T><T C="127,70,26" S="18" P="1">，</T>]]
			end
			for i = 1, 6 do
				GetElement(self.m_root, "tfbLog" .. i .. "_WndPhantom", WZUIFreeTextBox):setShowText([[<T C="255,89,74" S="22" P="1"></T>]])
			end

			local disTime = 0.3
			local upCnt = #refineProperty
			for i = 1, #refineProperty do
				local sRefineFormat = string.format(LocalStrings.PHANTOM_NEWTEXT38, i)
				-- local tTempPro = self:_arrangeProperty(json.decode(refineProperty[i]))
				local tTempPro = tabRefineProp[i]
				local tfbLog = GetElement(self.m_root, "tfbLog" .. i .. "_WndPhantom", WZUIFreeTextBox)
				for j = 1, #tTempPro do
					local attTemp = sAttaFormat1
					if tTempPro[j][2] < 0 then 
						attTemp = sAttaFormat2
					end
					sRefineFormat = sRefineFormat .. string.format(attTemp, ATTR_TITLE[tTempPro[j][1]], tTempPro[j][2])
				end
				if saveStatus[i] == 1 then 
					nActureRefineTimes = nActureRefineTimes + 1
					for j = 1, #tTempPro do
						if tSaveShowProp[tostring(tTempPro[j][1])] == nil then
							tSaveShowProp[tostring(tTempPro[j][1])] = 0
						end
						tSaveShowProp[tostring(tTempPro[j][1])] = tSaveShowProp[tostring(tTempPro[j][1])] + tTempPro[j][2] 
					end
					sRefineFormat = sRefineFormat .. LocalStrings.PHANTOM_NEWTEXT40
				else
					sRefineFormat = sRefineFormat .. LocalStrings.PHANTOM_NEWTEXT39
				end
				tfbLog:setShowText(sRefineFormat)

				tfbLog:setScale(0)
	            tfbLog:setVisible(true)
	            local act1 = CCDelayTime:create(0.1+disTime*i)
	            local act2 = CCScaleTo:create(0,1)
	            local act = CCSequence:createWithTwoActions(act1,act2)
	            tfbLog:runAction(act)

				if saveStatus[i] == 1 then 
					if saveProperty == nil then 
						saveProperty = json.decode(refineProperty[i])
					else
						local tPro = json.decode(refineProperty[i])
						for key, value in pairs(tPro) do
							saveProperty[key] = saveProperty[key] + value 
						end
					end
				end
			end

			--更新本地数据（不用服务端推送更新）
			for i = 1, #self.m_tDataList do
				if self.m_tDataList[i].shapeId == shapeId then 
					if self.m_tDataList[i].refinePropertySum == nil or #self.m_tDataList[i].refinePropertySum == 0 then
						self.m_tDataList[i].refinePropertySum = self:_arrangeProperty(saveProperty)
						for j=1,#self.m_tDataList[i].refinePropertySum do
							self.m_tDataList[i].refinePropertySum[j][2] = 0
						end
					end
					self.m_tDataList[i].fighting = fighting
					break 
				end
			end
			if tData.id == shapeId and saveProperty then
				tData.fighting = fighting 
				if tData.refinePropertySum == nil or #tData.refinePropertySum == 0 then
					tData.refinePropertySum = self:_arrangeProperty(saveProperty)
					for j=1,#tData.refinePropertySum do
						tData.refinePropertySum[j][2] = 0
					end
				end
				tData.refineProperty = self:_arrangeProperty(saveProperty)
				tData.saveShowProp = self:_arrangeProperty(tSaveShowProp)
				self:_showRefineContent(true)
			end

			local conLog = GetElement(self.m_root, "conLog_WndPhantom", WZUIContainer)
			conLog:setVisible(true)
			conLog:setScale(0)
			local tfbLog = GetElement(self.m_root, "tfbLog6_WndPhantom", WZUIFreeTextBox)
			if tfbLog then 
				local cost
				if self.m_bIsUseDiamondRefine then 
					cost = self:_getRefineCost(tData, 3)
				else
					cost = self:_getRefineCost(tData, 2)
				end
				tfbLog:setShowText(string.format(LocalStrings.PHANTOM_NEWTEXT41, refineTimes, nActureRefineTimes, refineTimes * cost[refineProNum][2], GDatatab_item["id_" .. cost[refineProNum][1]].icon))

				tfbLog:setScale(0)
			    local act1 = CCDelayTime:create(0.1+disTime*(upCnt+1))
			    local act2 = CCScaleTo:create(0,1)
			    local act = CCSequence:createWithTwoActions(act1,act2)
			    tfbLog:runAction(act)

			    local act3 = CCScaleTo:create(0.1,1)
			    conLog:runAction(act3)

			end
		end
	end
end

--@brief 	皮肤操作结果
--@param 	operateType:  操作类型【1=激活炼化|2=保存炼化|3=取消炼化|4=进阶】
function WndPhantom:skinOperateResult(result, operateType, shapeId, advancedLevel, blessingValue, property, refinePropertySum, fighting)
	-- body
	local tData = self.m_tSelectedCell.m_tData
	if result == 0 then 
		if operateType == 1 then 
			MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT27)

			for i = 1, #self.m_tDataList do
				if self.m_tDataList[i].shapeId == shapeId then 
					self.m_tDataList[i].refineProperty = ""
					self.m_tDataList[i].activeRefineStatus = true
					self.m_tDataList[i].refinePropertySum = self:_arrangeProperty(json.decode(refinePropertySum))
					break 
				end
			end
			if tData.id == shapeId then 
				tData.refineProperty = ""
				tData.activeRefineStatus = true
				tData.refinePropertySum = self:_arrangeProperty(json.decode(refinePropertySum))
				--刷新界面
				self:_showRefineContent()
			end
		elseif operateType == 2 then 
			MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT29)

			for i = 1, #self.m_tDataList do
				if self.m_tDataList[i].shapeId == shapeId then 
					self.m_tDataList[i].refineProperty = ""
					self.m_tDataList[i].curProperty = self:_arrangeProperty(json.decode(property))
					self.m_tDataList[i].refinePropertySum = self:_arrangeProperty(json.decode(refinePropertySum))
					self.m_tDataList[i].fighting = fighting
					break 
				end
			end
			if tData.id == shapeId then 
				tData.refineProperty = ""
				tData.curProperty = self:_arrangeProperty(json.decode(property))
				tData.refinePropertySum = self:_arrangeProperty(json.decode(refinePropertySum))
				tData.fighting = fighting
				--刷新界面
				self:_showRefineContent()
				self:_updateFire(tData)
			end
		elseif operateType == 3 then 
			MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT30)

			for i = 1, #self.m_tDataList do
				if self.m_tDataList[i].shapeId == shapeId then 
					self.m_tDataList[i].refineProperty = ""
					break 
				end
			end
			if tData.id == shapeId then 
				tData.refineProperty = ""

				--刷新界面
				self:_showRefineContent()
			end
		elseif operateType == 4 then 
			MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT31)

			for i = 1, #self.m_tDataList do
				if self.m_tDataList[i].shapeId == shapeId then 
					self.m_tDataList[i].advancedLevel = advancedLevel
					self.m_tDataList[i].blessingValue = blessingValue
					self.m_tDataList[i].curProperty = self:_arrangeProperty(json.decode(property))
					self.m_tDataList[i].fighting = fighting
					break 
				end
			end
			if tData.id == shapeId then 
				tData.advancedLevel = advancedLevel
				tData.blessingValue = blessingValue
				tData.curProperty = self:_arrangeProperty(json.decode(property))
				tData.fighting = fighting
				--刷新界面
				self.m_tSelectedCell:resetData(tData)
				self:_showAdvancedContent()
				self:_showStar(tData)
				self:_updateFire(tData)
			end
		end
	else
		if operateType == 2 then 
		elseif operateType == 3 then 
		elseif operateType == 4 then 
			MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT34)

			for i = 1, #self.m_tDataList do
				if self.m_tDataList[i].shapeId == shapeId then 
					self.m_tDataList[i].blessingValue = blessingValue
					break 
				end
			end
			if tData.id == shapeId then 
				tData.blessingValue = blessingValue
				--刷新界面
				self:_updateLuckyValue()
			end
		end
	end
end

--@brief 	炼化开关
function WndPhantom:refineLockResult(shapeId, operateProperty, status)
	-- body
	local tData = self.m_tSelectedCell.m_tData

	for i = 1, #self.m_tDataList do
		if self.m_tDataList[i].shapeId == shapeId then 
			local refineStatus = self.m_tDataList[i].refineStatus
			for j = 1, #refineStatus do
				if refineStatus[j][1] == operateProperty then 
					refineStatus[j][2] = status
					break 
				end
			end
		end
	end
	if tData.id == shapeId then 
		local refineStatus = tData.refineStatus
		for j = 1, #refineStatus do
			if refineStatus[j][1] == operateProperty then 
				refineStatus[j][2] = status
				break 
			end
		end
		--刷新界面
		self:_showPropertyLockState()
		self:_refineCost()
	end
end

function WndPhantom:updatePlayerItemData()
	if self.m_root == nil then return end 

	if self.m_nTab == 2 then 
		self:_showAdvancedCost()
	end
end

--@brief 	获取是否拥有某皮肤
function WndPhantom:whetherOwnPhantom(tData)
	-- body
	if tData.own then return true end 

	local tempValue 
	local nextShape = tData.next_shape
	while nextShape ~= -1 do
		for k,v in pairs(GDatatab_shape_skins) do
			if v.id == nextShape then 
				tempValue = v
				nextShape = v.next_shape
				break 
			end
		end
		if tempValue.own then 
			break 
		end
	end
	
	return tempValue
end

--@brief 	隐藏炼化记录
function WndPhantom:hideRefineRecord()
	-- body
	if self.m_root == nil then return end 
	local conLog = GetElement(self.m_root, "conLog_WndPhantom", WZUIContainer)
	if conLog:isVisible() then 
		conLog:setVisible(false)
		--更新本地皮肤的总洗练属性
		local tData = self.m_tSelectedCell.m_tData
		if tData.refineProperty ~= nil and tData.refineProperty ~= "" and tData.refineProperty ~= "{}" then 
			WZLog("WndPhantom:hideRefineRecord one", Serialize(tData.curProperty))
			for i = 1, #tData.refineProperty do
				local bIsKeyExist = false
				for j = 1, #tData.refinePropertySum do
					if tData.refinePropertySum[j][1] == tData.refineProperty[i][1] then 
						tData.refinePropertySum[j][2] = tData.refinePropertySum[j][2] + tData.refineProperty[i][2]
						bIsKeyExist = true
					end
				end
				if bIsKeyExist == false then
					local tempRefineProp = {[1]=tData.refineProperty[i][1],[2]=tData.refineProperty[i][2]}
					table.insert(tData.refinePropertySum,tempRefineProp)
					table.sort(tData.refinePropertySum,function (a, b) return a[1] < b[1] end)
				end
			end
			tData.curProperty = self:caculateCurPro(tData)
			tData.refineProperty = ""
			tData.saveShowProp = ""

			WZLog("WndPhantom:hideRefineRecord two", Serialize(tData.curProperty))
			for i = 1, #self.m_tDataList do
				if self.m_tDataList[i].shapeId == tData.id then 
					self.m_tDataList[i].refineProperty = ""
					self.m_tDataList[i].saveShowProp = ""
					self.m_tDataList[i].refinePropertySum = tData.refinePropertySum
					self.m_tDataList[i].curProperty = tData.curProperty
					self.m_tDataList[i].fighting = fighting
					break 
				end
			end

			self:_showRefineContent()
			self:_updateFire(tData)
		end

		self:setRefineCtr(true)
	end
end

--@brief 	设置是否可以开始下一次炼化
function WndPhantom:setRefineCtr(bBool)
	-- body
	if self.m_root == nil then return end 

	self.m_bCanStartRefine = bBool
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPhantom:setData(shapeId, remainTime, useShapeId, show, shapeLeve, shapeExp, activeRefineStatus, refineStatus, property, refinePropertySum, refineProperty, advanceLevel, blessingValue, fighting)
	self.useShapeId = useShapeId
	self.show = 1--show
	self.shapeLeve = shapeLeve
	self.shapeExp = shapeExp

	WZLog("WndPhantom:setData", self.useShapeId, Serialize(refineProperty))
	CacheCenter:getPlayerInfo().shapeId = useShapeId
	CacheCenter:getPlayerInfo().shapeLevel = shapeLeve

	self.m_tDataList = {}

	for i=1,#shapeId do
		local tempList = {}
		tempList.shapeId = shapeId[i]
		tempList.remainTime = remainTime[i]
		tempList.curProperty = self:_arrangeProperty(json.decode(property[i]))
		tempList.advancedLevel = advanceLevel[i]
		tempList.blessingValue = blessingValue[i]
		tempList.fighting = fighting[i]
		tempList.activeRefineStatus = activeRefineStatus[i]
		tempList.refineStatus = self:_arrangeProperty(json.decode(refineStatus[i]))
		if refineProperty[i] and refineProperty[i] ~= "" and refineProperty[i] ~= "{}" then 
			tempList.refineProperty = self:_arrangeProperty(json.decode(refineProperty[i]))
		else
			tempList.refineProperty = refineProperty[i]
		end

		tempList.refinePropertySum = self:_arrangeProperty(json.decode(refinePropertySum[i]))
		table.insert(self.m_tDataList,tempList)
	end

--	WZLog("WndPhantom:setData", Serialize(self.m_tDataList))
	self:_update()
	self:showPlayer()
end

function WndPhantom:showUseCard() 
	WZLog("WndPhantom:showUseCard")
	GetElement(self.m_root,"conUseCard",WZUIContainer):setVisible(true)

	local tData = self.m_tSelectedCell.m_tData
	--获得皮肤对应的体验卡id
	local cards = {}
	for i=0,1999 do
		local tItem = GDatatab_item["id_"..(8000+i)]
		--if tItem == nil then break end
		if tItem ~= nil and tItem.property[1][1] == tData.id and CacheCenter:getPlayerItemCountById(tItem.id) > 0 then
			table.insert(cards, tItem)
		end
		local tItem1 = GDatatab_item["id_"..(161000+i)]
		if tItem1 ~= nil and tItem1.property[1][1] == tData.id and CacheCenter:getPlayerItemCountById(tItem1.id) > 0 then
			table.insert(cards,tItem1)
		end
	end
	--按体验时间从小到大排序
	function sortC(a,b)
		if a.property[1][2] ~= b.property[1][2] then
			return a.property[1][2] < b.property[1][2]
		else
			return a.id < b.id
		end
	end

	table.sort(cards, sortC)
	self.m_tCards = cards

	for i=1,4 do
		GetElement(self.m_root,"conCard"..i,WZUIContainer):setVisible(false)
	end
	for i=1,#cards do
		local tData = CacheCenter:getPlayerItemById(cards[i].id)
		GetElement(self.m_root,"conCard"..i,WZUIContainer):setVisible(true)
		GetElement(self.m_root,"cardNum"..i,WZUILabelTTF):setText(tData.lastNum..LocalStrings.Expand)
		GetElement(self.m_root,"cardTime"..i,WZUILabelTTF):setText(string.format(LocalStrings.PHANTOM18,tData.basicInfo.property[1][2]/60/24))
	end

	local container = GetElement(self.m_root,"conUseCard",WZUIContainer)
	if container:getChildByTag(60) then container:removeChildByTag(60,true) end

	local imgBg = WZUI9Image:create()
	imgBg:setFile("ui/common/common_scale9_di24.png")
	imgBg:setRelativePosition(ccp(0.5,0.5))
	imgBg:setAnchorPoint(ccp(0.5,0.5))
	local con = WZUIContainer:create()
	con:setUseAbsCoordinate(true)
	con:setUseAbsSize(true)
	con:setAbsContentSize(GlobalMethod:CCSize(308,64*#cards))
	con:setAnchorPoint(ccp(0,0))
	con:setRelativePosition(ccp(0.5,0))
	con:addChild(imgBg)
	--con:setAbsPosition(ccp(maxWidth/2,labStartY/2))
	GetElement(self.m_root,"conUseCard",WZUIContainer):addChild(con,0,60)
end

function WndPhantom:closeCard() 
	GetElement(self.m_root,"conUseCard",WZUIContainer):setVisible(false)
end

function WndPhantom:useCard(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = tonumber(element:getTag())
	WZLog("WndPhantom:useCard",tag)
	WZLog("WndPhantom:useCard",tag,self.m_tCards)
	WZLog("WndPhantom:useCard",tag,self.m_tCards[tag].id)
	if self.m_tCards ~= nil and self.m_tCards[tag] ~= nil then
		local itemId = self.m_tCards[tag].id
		local tData = CacheCenter:getPlayerItemById(itemId)
		WndPhantom.show = 1
		ProtocolProcessorPhantom:send_SHAPE_UseItem(tData.playerItemId )
	end
	GetElement(self.m_root,"conUseCard",WZUIContainer):setVisible(false)
end

--@brief	体验时间计时器
function WndPhantom:init()
	if self.m_nScheduleId == nil then self.m_nScheduleId = 0 end
	if self.m_nScheduleId > 0 then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nScheduleId)
		self.m_nScheduleId = 0
	end 
	self.m_nScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WndPhantom.onCountdown, 1, false)
end

--@brief	体验时间计时器
function WndPhantom:onCountdown()
	--if WndPhantom.m_nLeftTime == nil then return end
	if WndPhantom.m_tDataList == nil then return end
	if WndPhantom.m_tSelectedCell == nil then return end
	if WndPhantom.m_tSelectedCell.m_tData == nil then return end
	--WZLog("WndPhantom:onCountdown",Serialize(WndPhantom.m_tDataList))
	--有皮肤到期时，重新请求数据
	for i=1,#WndPhantom.m_tDataList do
		if WndPhantom.m_tDataList[i].remainTime > 0 then
			WndPhantom.m_tDataList[i].remainTime = WndPhantom.m_tDataList[i].remainTime - 1
		end
		if WndPhantom.m_tDataList[i].remainTime == 0 and SceneBattle.m_root == nil and SceneBattleLoading.m_root == nil then
			ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo()
			WndPhantom.m_tDataList[i].remainTime = WndPhantom.m_tDataList[i].remainTime - 100
			CacheCenter:getPlayerInfo().shapeId = 0
			CacheCenter:getPlayerInfo().shapeLevel = 0
			break
		end
	end
	WndPhantom:setTimer()
end

function WndPhantom:setTimer() 
	if WndPhantom.m_tDataList == nil then return end
	if WndPhantom.m_tSelectedCell == nil then return end
	if WndPhantom.m_tSelectedCell.m_tData == nil then return end

	local leftSec = 0
	--显示剩余时间
	for i=1,#WndPhantom.m_tDataList do
		if WndPhantom.m_tDataList[i].shapeId == WndPhantom.m_tSelectedCell.m_tData.id then
			leftSec = WndPhantom.m_tDataList[i].remainTime
			break
		end
	end
	if WndPhantom.m_root ~= nil then
		local sFormatTime = [[<T C="255,236,193" S="18" P="1">%s:</T><T C="255,89,74" S="18" P="1">%s</T>]]
		if leftSec > 86400 then
			local day = math.ceil(leftSec/86400)
			GetElement(WndPhantom.m_root, "conTryTime_WndPhantom", WZUIContainer):setVisible(true)
			GetElement(WndPhantom.m_root,"txtLeftTime_WndPhantom", WZUIFreeTextBox):setShowText(string.format(sFormatTime, LocalStrings.PHANTOM19, day..LocalStrings.DAY))
		elseif leftSec > 0 then
			GetElement(WndPhantom.m_root, "conTryTime_WndPhantom", WZUIContainer):setVisible(true)
			GetElement(WndPhantom.m_root,"txtLeftTime_WndPhantom", WZUIFreeTextBox):setShowText(string.format(sFormatTime, LocalStrings.PHANTOM19,  returnToTimeFormat(leftSec)))
		elseif leftSec == -1 then
			GetElement(WndPhantom.m_root, "conTryTime_WndPhantom", WZUIContainer):setVisible(false)
		end
	end
end

--@brief 	獲取最大进阶等级
function WndPhantom:_getMaxStarLevel()
	-- body
	self.maxStarLevel = 0 
	if GDatatab_shape_advanced then
		for i, value in pairs(GDatatab_shape_advanced) do
			if value.level > self.maxStarLevel then 
				self.maxStarLevel = value.level 
			end
		end
	end
end

--@brief 	获取炼化消耗
--@param 	tData:需要炼化的皮肤数据
--@patam 	nType : 1->激活炼化；2->普通炼化；3->钻石炼化
function WndPhantom:_getRefineCost(tData, nType)
	-- body
	if GDatatab_shape_refine then
		for i, value in pairs(GDatatab_shape_refine) do
			if value.quality == tData.quality and value.type == nType then 
				return value.cost, value 
			end
		end
	end
end

--@brief 	获取当前皮肤最高品质
function WndPhantom:_getMaxQuality(tData)
	-- body
	WZLog("WndPhantom:_getMaxQuality", tData.id)
	local nQuality = tData.quality
	local sp_cost = tData.sp_cost
	local nextShape = tData.next_shape
	if sp_cost == -1 then 
		return nQuality
	end

	while sp_cost ~= -1 do 
		for i, value in pairs(GDatatab_shape_skins) do
			if nextShape == value.id then 
				sp_cost = value.sp_cost
				nQuality = value.quality
				nextShape = value.next_shape
				break 
			end
		end
	end

	return nQuality
end

--@brief 	获取当前皮肤最高品质数据
function WndPhantom:_getMaxQualityConfig(tData)
	-- body
	WZLog("WndPhantom:_getMaxQualityConfig", tData.id)
	local sp_cost = tData.sp_cost
	local nextShape = tData.next_shape
	local tLastData = tData
	if sp_cost == -1 then 
		return tLastData
	end

	while sp_cost ~= -1 do 
		for i, value in pairs(GDatatab_shape_skins) do
			if nextShape == value.id then 
				sp_cost = value.sp_cost
				nextShape = value.next_shape
				tLastData = value 
				break 
			end
		end
	end

	return tLastData
end

--@brief 	获取当前可炼化的是否需要炼化
function WndPhantom:getWhetherNeedRefine(tData)
	-- body
	local _, refineConfig = self:_getRefineCost(tData, 2)
	if self.m_bIsUseDiamondRefine then 
		_, refineConfig = self:_getRefineCost(tData, 3)
	end
	local tMaxRefinePro = refineConfig.property_limit

	local bHaveNoLock = false 
	for i = 1, #tData.curProperty do 
		if tData.refineStatus[i][2] == 1 then 
			bHaveNoLock = true
			break 
		end
	end
	WZLog("WndPhantom:getWhetherNeedRefine", Serialize(tData.refineStatus))
	if not bHaveNoLock then 
		return 1
	end

	local bNeedRefine = false 
	for i = 1, #tData.property do
		local refineProSum = 0
		for j = 1, #tData.refinePropertySum do
			if tData.refinePropertySum[j] and tData.refinePropertySum[j][1] == tData.property[i][1] and tData.refinePropertySum[j][2] then 
				refineProSum = tData.refinePropertySum[j][2]
				break 
			end
		end
		local nMaxRefinePro = 1
		for k, value in pairs(tMaxRefinePro) do
			if value[1] == tData.property[i][1] then 
				nMaxRefinePro = value[2]
				break 
			end
		end
		for k = 1, #tData.refineStatus do
			if tData.refineStatus[k][1] == tData.property[i][1] and tData.refineStatus[k][2] == 1 and refineProSum < nMaxRefinePro then 
				bNeedRefine = true
				break 
			end
		end
		if bNeedRefine then
			break 
		end
	end

	if not bNeedRefine then 
		return 2
	end

	return 3
end

--@brief 	属性整理
function WndPhantom:_arrangeProperty(tPro)
	-- body
	local tProperty = {}
	for key, value in pairs(tPro) do
		local tItem = {}

		tItem[1] = tonumber(key)
		tItem[2] = value

		table.insert(tProperty, tItem)
	end

	table.sort(tProperty, function (a, b)
		-- body
		return a[1] < b[1]
	end)

	return tProperty
end

--@brief 	统计已激活的皮肤的总属性
function WndPhantom:getTotalProperty()
	-- body
	local tTotalProperty = {}

	for i = 1, #self.m_tDataList do
		local tCurPro = CopyTable(self.m_tDataList[i].curProperty)
		for j = 1, #tCurPro do
			local bExist = false 
			for k = 1, #tTotalProperty do
				if tTotalProperty[k][1] == tCurPro[j][1] then 
					bExist = true
					tTotalProperty[k][2] = tTotalProperty[k][2] + tCurPro[j][2]
					break
				end
			end
			if not bExist then 
				table.insert(tTotalProperty, tCurPro[j])
			end
		end
	end

	return tTotalProperty
end

--@brief 	获取基础属性数据（皮肤配置表属性+炼化总属性）
function WndPhantom:getBasicPro(tData)
	-- body
	--属性
	local baseData = tData.property
	local curPro = tData.curProperty
	-- 当前进阶数据和下次进阶数据
    local curStarData 
    for k,v in pairs(GDatatab_shape_advanced) do
    	if v.level == tData.advancedLevel then curStarData = v end 
    end

    local basePro = {}
    local nPropertyRate = 0
    if curStarData then 
    	nPropertyRate = curStarData.property_rate
    end
    for i = 1, #curPro do
    	local tItem = {}
    	tItem[1] = baseData[i][1]
    	local refinePro = 0
    	for k = 1, #tData.refinePropertySum do
	    	if tData.refinePropertySum[k] and tData.refinePropertySum[k][1] == baseData[i][1] and tData.refinePropertySum[k][2] then 
	    		refinePro = tData.refinePropertySum[k][2]
	    		break 
	    	end
    	end
    	tItem[2] = baseData[i][2] + refinePro

    	table.insert(basePro, tItem)
    end

    return basePro
end

--@brief 	计算当前属性
function WndPhantom:caculateCurPro(tData)
	-- body
	local basePro = self:getBasicPro(tData)
	local curStarData 
    for k,v in pairs(GDatatab_shape_advanced) do
    	if v.level == tData.advancedLevel then curStarData = v end 
    end
    local nPropertyRate = 0
    if curStarData then 
    	nPropertyRate = curStarData.property_rate
    end

    local tTempPro = {}
    local curPro = tData.curProperty
	for i = 1, #basePro do
    	for k = 1, #curPro do
    		if curPro[k][1] == basePro[i][1] then 
    			local tItem = {}
    			tItem[1] = curPro[k][1]
	            local EndPro = math.ceil(basePro[i][2] * (1 + nPropertyRate/10000))
    			tItem[2] = EndPro
	            
	            table.insert(tTempPro, tItem)
	            break 
		    end
    	end
    end

    return tTempPro
end

--@brief 	获取当前可炼化的属性种类数量
function WndPhantom:getRefinePropertyNum(tData)
	-- body
	local _, refineConfig = self:_getRefineCost(tData, 2)
	if self.m_bIsUseDiamondRefine then 
		_, refineConfig = self:_getRefineCost(tData, 3)
	end
	local tMaxRefinePro = refineConfig.property_limit

	local bHaveNoLock = false 
	for i = 1, #tData.curProperty do 
		if tData.refineStatus[i][2] == 1 then 
			bHaveNoLock = true
			break 
		end
	end
	WZLog("WndPhantom:getRefinePropertyNum", Serialize(tData.refineStatus))
	if not bHaveNoLock then 
		return 0
	end

	local refineProNum = 0
	for i = 1, #tData.property do
		local refineProSum = 0
		for j = 1, #tData.refinePropertySum do
			if tData.refinePropertySum[j] and tData.refinePropertySum[j][1] == tData.property[i][1] and tData.refinePropertySum[j][2] then 
				refineProSum = tData.refinePropertySum[j][2]
				break 
			end
		end
		local nMaxRefinePro = 1
		for k, value in pairs(tMaxRefinePro) do
			if value[1] == tData.property[i][1] then 
				nMaxRefinePro = value[2]
				break 
			end
		end
		
		for k = 1, #tData.refineStatus do
			if tData.refineStatus[k][1] == tData.property[i][1] and tData.refineStatus[k][2] == 1 and refineProSum < nMaxRefinePro then 
				refineProNum = refineProNum + 1
			end
		end
	end

	return refineProNum
end

--@brief 	计算提炼结果,用来界面显示用的假数据
--@param	tData:当前选中的皮肤数据
--@param	refineProperty:服务器下发的未通过公式计算过的炼化结果
--@param	saveStatus:服务器下发的炼化将要保存状态
--@return	tabRefineProp:计算后的炼化结果(假数据用来显示)
function WndPhantom:caleRefineResult(tData, refineProperty, saveStatus)
	--解析未通过公式计算过的炼化属性
	local tabRefineProp = {}
	for i = 1, #refineProperty do
		tabRefineProp[i] = self:_arrangeProperty(json.decode(refineProperty[i]))
	end
	WZLog("WndPhantom:caleRefineResult tabRefineProp1 =",Serialize(tabRefineProp))

	--计算加上炼化前的全属性
	local tBeforeProperty = self:caculateCurPro(tData)
	WZLog("WndPhantom:caleRefineResult tBeforeProperty =",Serialize(tData.refinePropertySum),Serialize(tBeforeProperty))

	--计算加上炼化后的全属性
	local tAfterData = CopyTable(tData)
	for i = 1, #tabRefineProp do
		if saveStatus[i] == 1 then
			for k=1, #tabRefineProp[i] do
				local bIsKeyExist = false
				for j=1,#tAfterData.refinePropertySum do
					if tAfterData.refinePropertySum[j][1] == tabRefineProp[i][k][1] then 
						tAfterData.refinePropertySum[j][2] = tAfterData.refinePropertySum[j][2] + tabRefineProp[i][k][2]
						bIsKeyExist = true
					end
				end
				if bIsKeyExist == false then
					local tempRefineProp = {[1]=tabRefineProp[i][k][1],[2]=tabRefineProp[i][k][2]}
					table.insert(tAfterData.refinePropertySum,tempRefineProp)
					table.sort(tAfterData.refinePropertySum,function (a, b) return a[1] < b[1] end)
				end
			end
		end
	end
	local tAfterProperty = self:caculateCurPro(tAfterData)
	WZLog("WndPhantom:caleRefineResult tAfterProperty =",Serialize(tAfterData.refinePropertySum),Serialize(tAfterProperty))

	--炼化前后的差值
	local tDifference = {}
	for i=1,#tAfterProperty do
		for j=1,#tBeforeProperty do
			if tAfterProperty[i][1] == tBeforeProperty[j][1] then
				tDifference[i] = {}
				tDifference[i][1] = tAfterProperty[i][1]
				tDifference[i][2] = tAfterProperty[i][2] - tBeforeProperty[j][2]
			end
		end
	end
	WZLog("WndPhantom:caleRefineResult tDifference1 =",Serialize(tDifference))

	--和未通过公式计算过的炼化结果相减,得出炼化少算的值
	for i = 1, #tabRefineProp do
		if saveStatus[i] == 1 then
			for k=1, #tabRefineProp[i] do
				for j=1,#tDifference do
					if tabRefineProp[i][k][1] == tDifference[j][1] then 
						tDifference[j][2] = tDifference[j][2] - tabRefineProp[i][k][2]
					end
				end
			end
		end
	end
	WZLog("WndPhantom:caleRefineResult tDifference2 =",Serialize(tDifference))

	--炼化少算的值直接加到第一次成功的炼化上
	for i = 1, #tabRefineProp do
		if saveStatus[i] == 1 then
			for k=1, #tabRefineProp[i] do
				for j=1,#tDifference do
					if tabRefineProp[i][k][1] == tDifference[j][1] then 
						tabRefineProp[i][k][2] = tabRefineProp[i][k][2] + tDifference[j][2]
					end
				end
			end
			break
		end
	end
	WZLog("WndPhantom:caleRefineResult tabRefineProp2 =",Serialize(tabRefineProp))

	return tabRefineProp
end

-------------------------------------私有方法模块End----------------------------------------
