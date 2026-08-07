--WndHVStoreData.lua
--@brief	WndHVStore的数据模块
--@date		2022/05/30
--@author	XTX
--@note		度假村-仓库界面

WndHVStore = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHVStore:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tStoreData = nil 
	self.m_nTabIndex = 1 				--1=种子；2=钻石道具
	self.m_tCellItem = nil 
	self.m_tCellSel = nil 
    self.m_tCellSelData = nil  
    self.m_bIsSow = false 				--是否播种
    self.m_tFieldData = nil 			--要播种的土坑
    self.m_tSpriteCardConfig = nil
    self.m_nMaxSell = 100 				--一次最多出售数量
    self.m_nChooseNum = 1 				--出售的数量
    self.m_nPerNum = nil 				--一束的数量
    self.m_tLuaTable = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHVStore:_unInit()
	self.m_root = nil
	self.m_tStoreData = nil 
	self.m_nTabIndex = nil 				--1=种子；2=钻石道具
	self.m_tCellItem = nil 
	self.m_tCellSel = nil 
    self.m_tCellSelData = nil  
    self.m_bIsSow = nil 				--是否播种
    self.m_tFieldData = nil
    self.m_tSpriteCardConfig = nil 
    self.m_nMaxSell = nil 				--一次最多出售数量
    self.m_nChooseNum = nil 				--出售的数量
    self.m_nPerNum = nil 
    self.m_tLuaTable = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHVStore:createElement()
	if WndHVStore.m_root ~= nil then
		WindowManager:removeWindow(WndHVStore.m_root, WndHVStore, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHVStore")
	assert(element, "WndHVStore create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndHVStore:showInterface(luaTable, bIsSow, tFieldData)
	local wndhv = WndHVStore:createElement()
	if wndhv then 
		self.m_tLuaTable = luaTable
		self.m_bIsSow = bIsSow or false
		self.m_tFieldData = tFieldData
		WindowManager:addWindow(wndhv, WndHVStore, false, nil, nil, true)
	end
end
	
--[[
ids	: int[] [商品id],
boyItemId	: int[] [男物品id],
girlItemId	: int[] [女物品id],
nums	: int[] [物品数量],
limitNum	: int[] [商品限量],
soldNum	: int[] [已经售出数量]
]]
function WndHVStore:setStoreData(warehouseType, itemIds, lastNum, synType)
	if self.m_root == nil then return end 
	if warehouseType == 0 then return end 

	if self.m_tStoreData == nil then 
		self.m_tStoreData = {}
	end
	if warehouseType > 0 then 
		if self.m_tStoreData[warehouseType] == nil then 
			self.m_tStoreData[warehouseType] = {}
		end
	end
	if synType == 0 then 
		if itemIds and next(itemIds) ~= nil then
			for i=1,#itemIds do
				local tab = {}
				tab.id = itemIds[i]
				tab.lastNum = lastNum[i]
				local key = "id_".. tab.id
				if GDatatab_item[key] then
					tab.basicInfo = CopyTable(GDatatab_item[key])
					if warehouseType == 1 then --种子显示种子图标
						local seedData = WndHVLibrary:getSeedDataByItemId(tab.id)
						tab.basicInfo.icon = seedData.icon_zz
						tab.seedType = seedData.type
					end
					if tab.basicInfo ~= nil then
						tab.maintype = tab.basicInfo.main_type
						tab.subtype = tab.basicInfo.sub_type
					end
				end

				table.insert(self.m_tStoreData[warehouseType], tab)
			end

		--	WZLog("WndHVStore:setStoreData", Serialize(self.m_tStoreData[warehouseType]))
		end
	elseif synType == 1 or synType == 2 then 
		local tempTable = self.m_tStoreData[warehouseType]
		for i = 1, #itemIds do
			local bIsExist = false 
			for j = 1, #tempTable do
				if tempTable[j].id == itemIds[i] then 
					tempTable[j].lastNum = lastNum[i]
					bIsExist = true 
					break 
				end
			end
			if not bIsExist then 
				local tab = {}
				tab.id = itemIds[i]
				tab.lastNum = lastNum[i]
				local key = "id_".. tab.id
				if GDatatab_item[key] then
					tab.basicInfo = CopyTable(GDatatab_item[key])
					if warehouseType == 1 then --种子显示种子图标
						local seedData = WndHVLibrary:getSeedDataByItemId(tab.id)
						tab.basicInfo.icon = seedData.icon_zz
						tab.seedType = seedData.type
					end
					if tab.basicInfo ~= nil then
						tab.maintype = tab.basicInfo.main_type
						tab.subtype = tab.basicInfo.sub_type
					end
				end

				table.insert(tempTable, tab)
			end
		end
	elseif synType == 3 then  --删
		local tempTable = self.m_tStoreData[warehouseType]
		for i = 1, #itemIds do
			local bIsExist = false 
			for j = 1, #tempTable do
				if tempTable[j].id == itemIds[i] then 
					table.remove(tempTable, j)
					break 
				end
			end
		end
	end

	self:_update()
end

--@brief	缓存推送更新物品时调用的函数
function WndHVStore:updatePlayerItemData()
	WZLog("WndHVStore:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		
	end
end

--@brief 	获取某个道具数量
function WndHVStore:getItemsCountByItemId(itemId)
	if self.m_tStoreData == nil or self.m_tStoreData[2] == nil then return 0 end 

	local tTempData = self.m_tStoreData[2]
	for i = 1, #tTempData do
		if tTempData[i].id == itemId then 
			return tTempData[i].lastNum
		end
	end

	return 0
end

--@brief 	出售结果
function WndHVStore:sellFlowerResult(itemIds, nums, extrItemIds, extrItemNums)
	local normalRewards = {}
	local tBigReward = {}
	WZLog("WndHVStore:sellFlowerResult", Serialize(itemIds), Serialize(nums), Serialize(extrItemIds), Serialize(extrItemNums))

	local strTitleFormat = [[<T C="255,250,236" S="36" P="1" SC="225,90,17" SS="4" SE="1">%s</T>]]
	for j = 1, #itemIds do
		local tItem = {}

		tItem.itemId = itemIds[j]
		tItem.itemNum = nums[j] * #itemIds
		tItem.type = 26
		tItem.imgRewardTitle = "ui/holidayVillage/otherImg/bt_text_djc_ck_cssy_01.png"
		tItem.imgBK = "ui/holidayVillage/otherImg/hd_pic_djc_ck_cssy.png"
	--	tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
		tItem.imgBKPt = GlobalMethod:ccp(0.48, 0.5)
		tItem.strTitle = string.format(strTitleFormat, LocalStrings.HOLIDAYVILLAGE_TEXT3[38])
		tItem.subType = 1 

		table.insert(normalRewards, tItem)
	end
	for j = 1, #extrItemIds do
		local tItem = {}

		tItem.itemId = extrItemIds[j]
		tItem.itemNum = extrItemNums[j]

		table.insert(tBigReward, tItem)
	end
	if #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(19, normalRewards, tBigReward)
	else
		WndHoraryBigReward:showInterface(6, normalRewards)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
CellHVStoreItem = {

}

function CellHVStoreItem:_init()
	self.m_root = nil 
	self.m_bIsLoaded = false 
	self.m_tData = nil 
	self.m_nCoinNumber = 0 	--货币的数量
	self.m_bIsChoose = false --是否选中
	self.m_nTabIndex = nil 
end

function CellHVStoreItem:_unInit()
	self.m_root = nil 
	self.m_bIsLoaded = nil  
	self.m_tData = nil 
	self.m_nCoinNumber = nil 
	self.m_bIsChoose = nil --是否选中
	self.m_nTabIndex = nil 
end

function CellHVStoreItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellHVStoreItem")
	element:setAbsContentSize(GlobalMethod:CCSize(80,80))
	element:setLuaObjectIndex(tNewObj)

	return element, tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellHVStoreItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellHVStoreItem:onExit(element)
	self:_unInit()
end

--@brief 	点击物品回调
function CellHVStoreItem:onClickGoods(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local data = self.m_tData
	WndHVStore:onItemClick(self, data)
end

function CellHVStoreItem:setSelState(bVisible)
	self.m_bIsChoose = bVisible
	if self.m_bIsLoaded == false then return end 

	GetElement(self.m_root, "img9Sel_CellHvStoreItem", WZUI9Image):setVisible(bVisible)
end

--@brief 	设置数据
function CellHVStoreItem:setData(tData, nTabIndex)
	self.m_tData = tData 
	self.m_nTabIndex = nTabIndex
end

--@brief 	加载
function CellHVStoreItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellHVStoreItem")
	celElement:setVisible(true)
	self.m_root:addChild(celElement)
	self.m_bIsLoaded = true 

	self:_update()
end

--@brief 	刷新
function CellHVStoreItem:_update()
	self:setShowItem(self.m_tData.id, self.m_tData.lastNum, true,ccp(0.5,0.85))
	self:setSelState(self.m_bIsChoose)
end

--显示物品
function CellHVStoreItem:setShowItem(id, num, visible, ccp)
	visible = visible or false
	ccp = ccp or GlobalMethod:ccp(0.5,0.88)
	local conItem = GetElement(self.m_root,"conItem_CellHVStoreItem",WZUIContainer)
	local tabItem = GDatatab_item["id_"..id]
	if tabItem then
		local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(tabItem)}
		if self.m_nTabIndex == 1 then --种子显示种子图标
			local seedData = WndHVLibrary:getSeedDataByItemId(id)
			itemInfo.basicInfo.icon = seedData.icon_zz
		end
		local celElement,tLuaObj = CellGoodItem:createElement()
		conItem:addChild(celElement)
		tLuaObj:setCellGoodItem(itemInfo, 4)
		tLuaObj:setItemCount(num)
	end
end

function CellHVStoreItem:_new()
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self

	return tNewObj
end