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
	local conList = GetElement(self.m_root,"conList_WndGoodsFunll",WZUIContainer)
	--conList:setTouchEnable(false)
	if self.m_nType == 2 then 
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

function CellItem:setData(equipList,realTag)
	self.m_nEquipIdList=equipList
	self.m_nRealTag = realTag
	
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
		txtTitleName:setText(luaObject:getTitleName(self.m_nRealTag))

		if ProjConfig.LANGUAGE == "pt" then
			txtTitleName:setScale(0.75)
		elseif ProjConfig.LANGUAGE == "es" then
			txtTitleName:setScale(0.6)
			txtTitleName:setDimensions(GlobalMethod:CCSize(160,0))
		elseif ProjConfig.LANGUAGE == "tr" then
			txtTitleName:setScale(0.7)
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
			for i,v in ipairs(luaObject.m_nEquipIdList) do
				if  i >= self.m_nRealTag and i<= self.m_nRealTag+7 then
					local conChild = GetElement(con,"con".. index .."_WndGoodsFull",WZUIContainer)
					if conChild == nil then
						return
					end
					local equipID = dwarTemp["id_" .. v].dwar
					
				 	local itemElement,itemLua = WndGoodsFull:createCellGoodItem(index,equipID)
				 	conChild:addChild(itemElement)
				 	index = index + 1
				end
			end
		end
	end
end

--@brief  初始化UI
function WndGoodsFull:initUI()
	WZLog("WndGoodsFull:initUI")
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

	table.sort(itemTypeList,function (a,b)
		if a < b then
			return true
		else
			return false
		end
	end)

	local isFrist = true
	for i,v in ipairs(itemTypeList) do
		for k1,v1 in pairs(dwarTemp) do
			if v1.item_type == v then
				if isFrist then
					isFrist = false
					local temp = {}
					table.insert(itemList,temp)
				end
				table.insert(itemList[v],v1.id)
			end
		end
		isFrist = true
	end

	for i,v in ipairs(itemList) do
		table.sort(v,function (a,b)
			if a < b then
				return true
			else
				return false
			end
		end)
	end

	local wfc = GetElement(self.m_root,"wfc_WndGoodsFull",WZUIFreeListContainer)
    local index = 1

	for i,v in ipairs(itemList) do
		local cellItem,cellItemTable = CellItem:createElement(true)
		cellItemTable:setData(nil,i)
		cellItem:setTag(index)
		wfc:pushBack(cellItem)
		local lineCount = math.ceil((#v)/7)
		local startIndex = 1
		for i=1,lineCount do
			index = index + 1
			local cellItem,cellItemTable = CellItem:createElement(false)
			cellItemTable:setData(v,startIndex)
			cellItem:setTag(index)
			wfc:pushBack(cellItem)
			startIndex = startIndex + 7
		end
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

    local ownList =CacheCenter:getOwnIdList()
    if self.m_nType == 2 then 
    	ownList = {}
    end

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



-------------------------------------私有方法模块End----------------------------------------
