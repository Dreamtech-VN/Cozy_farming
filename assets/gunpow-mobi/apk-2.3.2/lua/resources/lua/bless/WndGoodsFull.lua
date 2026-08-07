--GoodsFull.lua
--@brief	GoodsFull的UI模块
--@date		2016/05/19
--@author	qixiang_xie
--@note		装备抽奖大全


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGoodsFull:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGoodsFull:onExit(element)
	self:_unInit()
end


--@brief	创建窗口动画
function WndGoodsFull:onEnterTransitionDidFinish(element)
	WZLog("WndGoodsFull:onEnterTransitionDidFinish")
    --WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
    self:actionCallback()
end

--动画播放完回调
function WndGoodsFull:actionCallback()
	WZLog("WndGoodsFull:actionCallback")
	-- local conList = GetElement(self.m_root,"conList_WndGoodsFunll",WZUIContainer)
	--conList:setTouchEnable(false)
	WZLog("--动画播放完回调:",self.m_nType)
	if self.m_nType == 2 then 
		GetElement(self.m_root,"conDesc_WndGoodsFull",WZUIContainer):setVisible(false)
		local sTitle = string.gsub(LocalStrings.REWARD_DESC, ": ", "")
		GetElement(self.m_root, "txtTitle_WndGoodsFull", WZUILabelTTF):setText(sTitle)
	else
		GetElement(self.m_root, "txtTitle_WndGoodsFull", WZUILabelTTF):setText(LocalStrings.GOODS_FULL)
		self:initUI()
	end
	--conList:enableSchedule("scheduleUpdateTouch",1)
end

function WndGoodsFull:scheduleUpdateTouch(element)
	WZLog("WndGoodsFull:scheduleUpdateTouch")
	element:disableSchedule()
	element = WZUIContainer:luaTo(element)
	element:setTouchEnable(true)
end

local comCCSize = CCSize(0,0)


local CellItem = {}

function CellItem:createElement(bTitle)
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	if bTitle then
		element:setAbsContentSize(GlobalMethod:CCSize(715,38))  
	else
		element:setAbsContentSize(GlobalMethod:CCSize(715,80))
	end
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

function CellItem:setData(equipList,realTag,ntype,bItemId)
	self.m_nEquipIdList=equipList
	self.m_nRealTag = realTag
	self.m_type = ntype
	self.m_bItemId = bItemId
end

function CellItem:getTitleName(index)
	if index == 1 then
		return LocalStrings.ITEM_TYPE1
	elseif index == 2 then
		return LocalStrings.ITEM_TYPE2
	elseif index == 3 then
		return LocalStrings.ITEM_TYPE3
	elseif index == 4 then
		return LocalStrings.ITEM_TYPE4
	elseif index == 5 then
		return LocalStrings.ITEM_TYPE5
	elseif index == 6 then
		return LocalStrings.ITEM_TYPE6
	elseif index == 7 then
		return LocalStrings.ITEM_TYPE7
	elseif index == 8 then
		return LocalStrings.ITEM_TYPE8
	elseif index == 9 then
		return LocalStrings.ITEM_TYPE9
	elseif index == 10 then
		return LocalStrings.ITEM_TYPE10
	elseif index == 11 then
		return LocalStrings.ITEM_TYPE11
	elseif index == 12 then
		return LocalStrings.ITEM_TYPE12
	elseif index == 13 then
		return LocalStrings.ITEM_TYPE13
	elseif index == 14 then
		return LocalStrings.ITEM_TYPE14
	elseif index == 15 then
		return LocalStrings.ITEM_TYPE15
	elseif index == 16 then
		return LocalStrings.ITEM_TYPE16
	elseif index == 17 then
		return LocalStrings.ITEM_TYPE17
	elseif index == 18 then
		return LocalStrings.ITEM_TYPE14
	elseif index == 19 then
		return LocalStrings.ITEM_TYPE15
	elseif index == 20 then
		return LocalStrings.ITEM_TYPE16
	elseif index == 21 then
		return LocalStrings.ITEM_TYPE17
	elseif index == 10000 then
		return LocalStrings.NEWBAG9
	elseif index == 10001 then
		return LocalStrings.GEM
	end
end

function CellItem:onLoadData(element)
	WZLog("CellItem:onLoadData ",element:getTag())
	element = WZUIContainer:luaTo(element)
	local luaObject = element:getLuaObjectIndex()
	local celSize = element:getAbsContentSize()
	local dwarTemp = GDatatab_dwar
	local GetElement = GetElement
	local CreateElement = CreateElement
	if self.m_nEquipIdList == nil then
		local conTitle = WZUIContainer:luaTo(CreateElement("conTitle_WndGoodsFull"))
		element:addChild(conTitle)
		local txtTitleName = GetElement(conTitle,"txtTitleName_WndGoodsFull",WZUILabelTTF)
		local txtAddAttr = GetElement(conTitle,"txtAddAttr_WndGoodsFull",WZUIFreeTextBox)

		if self.m_type == 2 then
			txtTitleName:setText(luaObject:getTitleName(self.m_nRealTag))
		else 
			local m_equiitemId = CacheCenter:getEquipIdList()
			local suitTemp = GDatatab_item_suit["id_"..self.m_nRealTag]
			local m_num = 0
			local tCompleteSuit = {false,false,false,false,false,false,} --套装各部位是否已满足条件
			for i = 1,#m_equiitemId do
				if suitTemp.bracelet_id == m_equiitemId[i] and tCompleteSuit[1] ~= true then
					m_num = m_num + 1
					tCompleteSuit[1] = true
				end
				if suitTemp.talisman_id == m_equiitemId[i] and tCompleteSuit[2] ~= true then
					m_num = m_num + 1
					tCompleteSuit[2] = true
				end
				if suitTemp.medal_id == m_equiitemId[i] and tCompleteSuit[3] ~= true then
					m_num = m_num + 1
					tCompleteSuit[3] = true
				end
				if suitTemp.ring_id == m_equiitemId[i] and tCompleteSuit[4] ~= true then
					m_num = m_num + 1
					tCompleteSuit[4] = true
				end
				if suitTemp.necklace_id == m_equiitemId[i] and tCompleteSuit[5] ~= true then
					m_num = m_num + 1
					tCompleteSuit[5] = true
				end
				if suitTemp.eardrop_id == m_equiitemId[i] and tCompleteSuit[6] ~= true then
					m_num = m_num + 1
					tCompleteSuit[6] = true
				end
			end
			WZLog("CellItem:onLoadData(element)",self.m_nRealTag, m_num)
			txtTitleName:setText(suitTemp.name)
			if suitTemp.collect_attr == - 1 then
				txtAddAttr:setVisible(false)
			else 
				if #suitTemp.collect_attr == 2 then
					local num1 = suitTemp.collect_attr[1][5]
					local num2 = suitTemp.collect_attr[2][5]
					if suitTemp.collect_attr[1][3] == 1 then
						num1 = (suitTemp.collect_attr[1][5])/100 .."%"
					end
					if suitTemp.collect_attr[2][3] == 1 then
						num2 = (suitTemp.collect_attr[2][5])/100 .."%"
					end
					local s1 = ATTR_TITLE[suitTemp.collect_attr[1][4]]
					if suitTemp.collect_attr[1][4] == - 1 then
						s1 = LocalStrings.PHANTOM_EQUIPMENT19
					end
					local s2 = ATTR_TITLE[suitTemp.collect_attr[2][4]]
					if suitTemp.collect_attr[2][4] == -1 then
						s2 = LocalStrings.PHANTOM_EQUIPMENT19
					end
					if m_num < suitTemp.collect_attr[1][1] then				
						txtAddAttr:setShowText(string.format(LocalStrings.GOODSFULL_TITLENAME1,LocalStrings.GOODFULL_TOY[suitTemp.collect_attr[1][2] + 1],s1,num1,s2,num2))
					else
						txtAddAttr:setShowText(string.format(LocalStrings.GOODSFULL_TITLENAME2,LocalStrings.GOODFULL_TOY[suitTemp.collect_attr[1][2] + 1],s1,num1,s2,num2))
					end
				elseif #suitTemp.collect_attr == 1 then
					local num1 = suitTemp.collect_attr[1][5]
					if suitTemp.collect_attr[1][3] == 1 then
						num1 = (suitTemp.collect_attr[1][5])/100 .."%"
					end
					local s1 = ATTR_TITLE[suitTemp.collect_attr[1][4]]
					if suitTemp.collect_attr[1][4] == - 1 then
						s1 = LocalStrings.PHANTOM_EQUIPMENT19
					end
					if m_num < suitTemp.collect_attr[1][1] then				
						txtAddAttr:setShowText(string.format(LocalStrings.GOODSFULL_TITLENAME3,LocalStrings.GOODFULL_TOY[suitTemp.collect_attr[1][2] + 1],s1,num1))
					else
						txtAddAttr:setShowText(string.format(LocalStrings.GOODSFULL_TITLENAME4,LocalStrings.GOODFULL_TOY[suitTemp.collect_attr[1][2] + 1],s1,num1))
					end
				end 
			end
		end

		if ProjConfig.LANGUAGE == "pt" then
			txtTitleName:setScale(0.75)
		elseif ProjConfig.LANGUAGE == "es" then
			txtTitleName:setScale(0.6)
			txtTitleName:setDimensions(GlobalMethod:CCSize(160,0))
		elseif ProjConfig.LANGUAGE == "tr" then
			txtTitleName:setScale(0.7)
		elseif ProjConfig.LANGUAGE == "ug" then
			txtTitleName:setScale(0.65)
			txtTitleName:setDimensions(GlobalMethod:CCSize(210,0))
		elseif ProjConfig.LANGUAGE == "vn" then
			txtAddAttr:setMaxWidth(600)
		end

	else

		local con = WZUIContainer:luaTo(CreateElement("conList_WndGoodsFull"))
		element:addChild(con)
		
		local index = 1
		if WndGoodsFull.m_nType == 2 then
			for i, value in pairs(WndGoodsFull.m_tRewardList) do
				if  i >= self.m_nRealTag and i<= self.m_nRealTag+7 then
					local conChild = GetElement(con,"con".. index .."_WndGoodsFull",WZUIContainer)
					if conChild == nil then
						return
					end
					local equipID = value
					
				 	local itemElement,itemLua = WndGoodsFull:createCellGoodItem(index,equipID)
				 	conChild:addChild(itemElement)
				 	index = index + 1
				end
			end 
		else
			if self.m_type == 1 or self.m_type == 3 then
				WZLog("self.m_type = :",self.m_type,Serialize(luaObject.m_nEquipIdList))
				for i,v in ipairs(luaObject.m_nEquipIdList) do
				-- 	if  i >= self.m_nRealTag and i<= self.m_nRealTag+7 then
					if i >1 and i < 8 then
						local conChild = GetElement(con,"con".. index .."_WndGoodsFull",WZUIContainer)
						if conChild == nil then
							return
						end
						local equipID = v
						
					 	local itemElement,itemLua = WndGoodsFull:createCellGoodItem(index,equipID)
					 	conChild:addChild(itemElement)
					 	index = index + 1
					 end
				end
			else 
				for i,v in ipairs(luaObject.m_nEquipIdList) do
					if  i >= self.m_nRealTag and i<= self.m_nRealTag+7 then
						local conChild = GetElement(con,"con".. index .."_WndGoodsFull",WZUIContainer)
						if conChild == nil then
							return
						end
						local equipID
						if self.m_bItemId then
							equipID = GDatatab_item["id_"..v].id
						else
							equipID = dwarTemp["id_" .. v].dwar
						end

					 	local itemElement,itemLua = WndGoodsFull:createCellGoodItem(index,equipID)
					 	conChild:addChild(itemElement)
					 	index = index + 1
					end
				end
			end
		end
	end
end

--@brief  初始化UI
function WndGoodsFull:initUI()
	local equipItemid = CacheCenter:getEquipIdList()
	WZLog("WndGoodsFull:initUI",Serialize(equipItemid))
	local itemTypeList = {}
	local itemList = {}
	local dwarTemp = GDatatab_dwar
	for k,v in pairs(dwarTemp) do
		local itemType = v.item_type
		local bExit =false
		for i,v in ipairs(itemTypeList) do
			if itemType == v then
				bExit = true
			end
		end
		if not bExit then
			table.insert(itemTypeList,itemType)
		end
	end
	WZLog("武器内容：",Serialize(itemTypeList))
	table.sort(itemTypeList,function (a,b)
		if a < b then
			return true
		else
			return false
		end
	end)

	local isFrist = true
	local index = 1
	local wfc = GetElement(self.m_root,"wfc_WndGoodsFull",WZUIFreeListContainer)
	if self.m_nType == 1 then
		for i,v in ipairs(itemTypeList) do
			for k1,v1 in pairs(dwarTemp) do
				if v1.item_type == v then
					if isFrist then
						isFrist = false
						local temp = {}
						table.insert(itemList,temp)
					end
					table.insert(itemList[v],v1.dwar)
				end
			end
			isFrist = true
		end
		WZLog("武器内容1：",Serialize(itemList))
		for i,v in ipairs(itemList) do
			table.sort(v,function (a,b)
				if a < b then
					return true
				else
					return false
				end
			end)
		end

		-- local itemList2[1] = itemList[1]
		local itemList2 = {[1] = {}}
		for i = 1,#itemList do
			if i == 1 then
				for j = 1,#itemList[i] do
					table.insert(itemList2[i],itemList[i][j])
				end
			end
		end

	    WZLog("武器内容2：",Serialize(itemList2))
		for i,v in ipairs(itemList2) do
			local cellItem,cellItemTable = CellItem:createElement(true)
			cellItemTable:setData(nil,i,2)
			cellItem:setTag(index)
			wfc:pushBack(cellItem)
			local lineCount = math.ceil((#v)/7)
			local startIndex = 1
			for i=1,lineCount do
				index = index + 1
				local cellItem,cellItemTable = CellItem:createElement(false)
				cellItemTable:setData(v,startIndex,nil,true)
				cellItem:setTag(index)
				wfc:pushBack(cellItem)
				startIndex = startIndex + 7
			end
			index = index + 1
		end

		-- --副手
		-- local tempItemList = {}
		-- for key,value in pairs(GDatatab_total_draw) do
		-- 	if value.type == 1 then
		-- 		local itemInfo = GDatatab_item["id_"..value.item_id[1][1]]
		-- 		if itemInfo.main_type == 4 and itemInfo.sub_type == 8 then
		-- 			if not utilsValueInTable(itemInfo.id, tempItemList) then
		-- 				table.insert(tempItemList,itemInfo.id)
		-- 			end
		-- 		end
		-- 	end
		-- end
		-- table.sort(tempItemList,function(a,b)
		-- 	local itemInfoA = GDatatab_item["id_"..a]
		-- 	local itemInfoB = GDatatab_item["id_"..b]
		-- 	if itemInfoA.quality ~= itemInfoB.quality then
		-- 		return itemInfoA.quality < itemInfoB.quality
		-- 	else
		-- 		return a < b
		-- 	end
		-- end)
		-- local cellItem,cellItemTable = CellItem:createElement(true)
		-- cellItemTable:setData(nil,10000,2)
		-- cellItem:setTag(index)
		-- wfc:pushBack(cellItem)
		-- local lineCount = math.ceil((#tempItemList)/7)
		-- local startIndex = 1
		-- for i=1,lineCount do
		-- 	index = index + 1
		-- 	local cellItem,cellItemTable = CellItem:createElement(false)
		-- 	cellItemTable:setData(tempItemList,startIndex,nil,true)
		-- 	cellItem:setTag(index)
		-- 	wfc:pushBack(cellItem)
		-- 	startIndex = startIndex + 7
		-- end
		-- index = index + 1

		-- --宝石
		-- local tempItemList = {}
		-- for key,value in pairs(GDatatab_total_draw) do
		-- 	if value.type == 1 then
		-- 		local itemInfo = GDatatab_item["id_"..value.item_id[1][1]]
		-- 		if itemInfo.main_type == 6 then
		-- 			if not utilsValueInTable(itemInfo.id, tempItemList) then
		-- 				table.insert(tempItemList,itemInfo.id)
		-- 			end
		-- 		end
		-- 	end
		-- end
		-- table.sort(tempItemList,function(a,b)
		-- 	local itemInfoA = GDatatab_item["id_"..a]
		-- 	local itemInfoB = GDatatab_item["id_"..b]
		-- 	if itemInfoA.quality ~= itemInfoB.quality then
		-- 		return itemInfoA.quality < itemInfoB.quality
		-- 	else
		-- 		return a < b
		-- 	end
		-- end)
		-- local cellItem,cellItemTable = CellItem:createElement(true)
		-- cellItemTable:setData(nil,10001,2)
		-- cellItem:setTag(index)
		-- wfc:pushBack(cellItem)
		-- local lineCount = math.ceil((#tempItemList)/7)
		-- local startIndex = 1
		-- for i=1,lineCount do
		-- 	index = index + 1
		-- 	local cellItem,cellItemTable = CellItem:createElement(false)
		-- 	cellItemTable:setData(tempItemList,startIndex,nil,true)
		-- 	cellItem:setTag(index)
		-- 	wfc:pushBack(cellItem)
		-- 	startIndex = startIndex + 7
		-- end
		-- index = index + 1


	    local miny = wfc:getMinPosition().y
		wfc:getMoveElement():setPositionY(miny)
	end

	local collect = {}
	-- string.sub(CacheCenter:getGameParam()["shapeequipdemand"],2,-2)
	-- SplitStringWithSeparator(shapeequipdemand, ",")
	if self.m_nType == 3 then
		collect = string.sub(CacheCenter:getGameParam()["collectshow"],2,-2)
	elseif self.m_nType == 1 then 
		collect = string.sub(CacheCenter:getGameParam()["luckcollectshow"],2,-2)
	end
	local collectNum = SplitStringWithSeparator(collect,",")
	WZLog("SplitStringWithSeparator(collect,):",Serialize(collectNum))

	local itemTypeList2 = {}
	local itemTypeList1 = GDatatab_item_suit
	for k,v in pairs(collectNum) do
		table.insert(itemTypeList2,itemTypeList1["id_"..v])
	end

	WZLog("显示套装内容",Serialize(itemTypeList2))
	for i,v in pairs(itemTypeList2) do
		WZLog("装备id列表",v.item_list[1][1],self.m_nType)
		local cellItem,cellItemTable = CellItem:createElement(true)
		cellItemTable:setData(nil,v.id)
		cellItem:setTag(index)
		wfc:pushBack(cellItem)
		local cellItem,cellItemTable = CellItem:createElement(false)
		cellItemTable:setData(v.item_list[1],index,self.m_nType)
		cellItem:setTag(index)
		wfc:pushBack(cellItem)
		index = index + 1
	end
    local miny = wfc:getMinPosition().y
	wfc:getMoveElement():setPositionY(miny)
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndGoodsFull:onClickListItem(tItem, nTag, tData)
    WZLog("WndGoodsFull:onClickListItem")
    WndItemInfo:onCloseClick()
    local offset = GlobalMethod:ccp(0,0)
    if nTag >= 4 then
		if tData.basicInfo.main_type == 4 or tData.basicInfo.main_type == 9 then
        	offset = GlobalMethod:ccp(100,0)
		end
    end
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,false,offset)
end

--@brief    创建一个物品格子
--@param    nIndex, 序号
--@param    nItemId, 物品id
function WndGoodsFull:createCellGoodItem(nIndex, nItemId)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setTag(nIndex)
    --eItem:setScale(1)
    tItem:setFromTag(nIndex)
    tItem:setItemClickFun(self, self.onClickListItem)
    local equipList = CacheCenter:getEquipmentIdList() --已装备物品列表
    WZLog("已装备物品列表:",Serialize(equipList))

    local ownList =CacheCenter:getOwnIdList()
    if self.m_nType == 2 then 
    	ownList = {}
    end
    WZLog("创建物品格子",equipList[nItemId])
    local tData = {
        id = nItemId,
        lastNum = 0,
        lastTime = 1,
        isUse = equipList[nItemId],
        own = ownList[nItemId],
        playerItemId = -1,
        basicInfo = GetItemLocalData(nItemId)
    }
    tItem:setCellGoodItem(tData,12)
    return eItem, tItem
end


--@brief	开始点击窗口后的回调
--@param	element:窗口绑定的lua表
--@param    pt:坐标点
function WndGoodsFull:onTouchBegan(element, pt)
	WZLog("WndGoodsFull:onTouchBegan...........")
    WndItemInfo:onCloseClick()
    WndTips:onCloseClick()
    
end

--关闭界面
function WndGoodsFull:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManagerAni:createDisappearAction(self.m_root,"onDisappearActionCallback",self)
	--WindowManager:removeWindow(self.m_root ,WndGoodsFull, true)
end

--窗口动画关闭完成回调
function WndGoodsFull:onDisappearActionCallback(elem,data)
	WZLog("WndGoodsFull:onDisappearActionCallback")
    WindowManager:removeWindow(self.m_root , WndGoodsFull , true)
end

-------------------------------------公有方法模块End----------------------------------------



-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化奖励预览数据
function WndGoodsFull:initRewardList(tRewardList)
	--body
	self.m_tRewardList = tRewardList --CopyTable(tRewardList)

	local wfc = GetElement(self.m_root,"wfc_WndGoodsFull",WZUIFreeListContainer)
    local index = 1
	
	local lineCount = math.ceil((#self.m_tRewardList)/7)
	local startIndex = 1
	for i=1,lineCount do
		index = index + 1
		local cellItem,cellItemTable = CellItem:createElement(false)
		cellItemTable:setData(self.m_tRewardList, startIndex)
		cellItem:setTag(index)
		wfc:pushBack(cellItem)
		startIndex = startIndex + 7
	end

	local miny = wfc:getMinPosition().y
	wfc:getMoveElement():setPositionY(miny)
end

function WndGoodsFull:onClickDesc()
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.GOODSFULL_TEXT)	
end

-------------------------------------私有方法模块End----------------------------------------
