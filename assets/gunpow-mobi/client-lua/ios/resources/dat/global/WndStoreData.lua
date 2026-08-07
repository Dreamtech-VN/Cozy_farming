--WndStoreData.lua
--@brief	WndStore的数据模块
--@date		2016/11/29
--@author	qixiang
--@note		商店模块(竞技商店、宠物商店、黑市商店、公会商店、卡牌商店、符文商店、祈福商店)

WndStore = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndStore:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tFightShopData = nil     --竞技商店
	self.m_tPetShopData = nil       --宠物商店
	self.m_tCommunityShopData = nil  --公会商店
	self.m_tSurprisedShopData = nil  --黑市商店
	self.m_tBlessShopData = nil      --祈福商店
	self.m_tCardShopData = nil       --卡牌商店
	self.m_tRuneShopData = nil       --符文商店
	self.m_tEquipmentData = nil      --装备商店
	self.m_tAdventureData = nil      --冒险商店
	self.m_tPvpRankData = nil 		--排位商店
	self.m_nCommunityRefreshCount = nil
	self.m_nCommunityNextRefreshTime = nil

	self.m_nFightrefreshCount  = nil  --刷新次数
	self.m_nAdventurefreshCount  = nil  --刷新次数
	self.m_nCardRefreshCount = 0 --卡牌商店的刷新次数
	self.m_nRuneStoreRefreshCount = nil 
    self.m_nFightnextRefreshTime = nil --下次自动刷新时间(秒数)
    self.m_nAdventureRefreshTime = nil

	self.m_nStoreType = 1    --1 竞技商店 2 公会商店 3 宠物商店 4 祈福商店 5 卡牌商店 6 黑市商店 7符文商店 8装备商店 9冒险商店
	self.m_nLoadingTag = nil

	self.m_rootFightTable = nil
	self.m_rootCommunityTable = nil
	self.m_rootPetTable = nil
	self.m_rootSurprisedTable = nil
	self.m_rootRuneTable = nil --符文商店
	self.m_rootEquipTable = nil
	self.m_rootAdventureTable = nil --冒险商店
	self.m_cellSurprise = nil
	self.m_rootBlessTable = nil
	self.m_rootCardTable = nil
	self.m_rootPvpRankTable = nil
	self.m_nSurpriseLeftSecond = nil
	self.vipLimit = nil
	self.vipLimit2= nil
	self.vipLimit3 = nil
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
	self.m_callbackLua = nil
	self.m_callbackFun = nil
	self.m_tCheckBoxStr = {}
	
	self.m_nCurItemTag = -1

    self.m_tClickShopItem = nil
    self.m_bBuyCardItem = false
    self.m_bSurpriseIsOpen = nil
    self.m_noteCurShowBtn = nil
    self.m_bBuy = false
    self.m_tTempDataOnClick = nil 
    self.m_nEqiopfreshCount = nil
    self.m_nEqiopfreshTotalCount = nil

    self.m_nEqiopfreshCostId = nil
    self.m_nEqiopfreshCostCount = nil

    self.m_bAdventureOpen = nil --冒险商店
    self.m_nPvpRankRefreshCount = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndStore:_unInit()
	self.m_root = nil
	self.m_tFightShopData = nil     --竞技商店
	self.m_tPetShopData = nil       --宠物商店
	self.m_tCommunityShopData = nil  --公会商店
	self.m_tSurprisedShopData = nil  --黑市商店
	self.m_tBlessShopData = nil      --祈福商店
	self.m_tRuneShopData = nil       --符文商店
	self.m_tEquipmentData = nil      --装备商店
	self.m_tAdventureData = nil 
	self.m_tPvpRankData = nil 		--排位商店
	self.m_nCommunityRefreshCount = nil
	self.m_nCommunityNextRefreshTime = nil
	self.m_nStoreType = nil    
	self.m_nLoadingTag = nil
    self.m_rootCardTable = nil
    self.m_rootEquipTable = nil
    self.m_rootAdventureTable = nil
	self.m_nFightrefreshCount  = nil  --刷新次数
	self.m_nCardRefreshCount = nil
	self.m_nAdventurefreshCount = nil
	self.m_nRuneStoreRefreshCount = nil 
    self.m_nFightnextRefreshTime = nil --下次自动刷新时间(秒数)
    self.m_nAdventureRefreshTime = nil
    self.m_nSurpriseLeftSecond = nil
    self.vipLimit = nil
    self.vipLimit2= nil
    self.vipLimit3 = nil
    self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
	self.m_tCheckBoxStr = nil
	self.m_cellSurprise = nil
	self.m_callbackLua = nil
	self.m_callbackFun = nil
	self.m_nCurItemTag = nil
	self.m_tCardShopData = nil

    self.m_tClickShopItem = nil
    self.m_bBuyCardItem = nil
    self.m_bSurpriseIsOpen = nil
    self.m_noteCurShowBtn = nil
    self.m_rootRuneTable = nil --符文商店
    self.m_bBuy = nil
    self.m_tTempDataOnClick = nil 
    self.m_nEqiopfreshCount = nil
    self.m_nEqiopfreshTotalCount = nil

    self.m_nEqiopfreshCostId = nil
    self.m_nEqiopfreshCostCount = nil
    self.m_bAdventureOpen = nil --冒险商店
    self.m_rootPvpRankTable = nil
    self.m_nPvpRankRefreshCount = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndStore:createElement()
	if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    end
	local element = WZUISystem:getInstance():createElement("WndStore")
	self:_init()
	assert(element, "WndStore element create failed!")
	return element
end

--竞技商店
function WndStore:setFightShopData(tData,refreshCount,nextRefreshTime)
	WZLog("WndStore:setFightShopData")
	self.m_tFightShopData = tData
	self.m_nFightrefreshCount  = refreshCount  
    self.m_nFightnextRefreshTime = nextRefreshTime 
    self.m_rootFightTable:cleanTable()
    self:closeLoadingB()
    if self.m_nStoreType == 1 then
    	self.m_rootFightTable:setVisible(true)
    	self:showStoreList()
    	self:setButtomInfo()
    end
end

--冒险商店
function WndStore:setAdventureShopData(tData,refreshCount,nextRefreshTime)
	WZLog("WndStore:setAdventureShopData")
	self.m_tAdventureData = tData
	self.m_nAdventurefreshCount  = refreshCount  
    self.m_nAdventureRefreshTime = nextRefreshTime 
    self.m_rootAdventureTable:cleanTable()
    self:closeLoadingB()
    if self.m_nStoreType == 9 then
    	self.m_rootAdventureTable:setVisible(true)
    	self:showStoreList()
    	self:setButtomInfo()
    end
end

--装备商店
function WndStore:setEquipStoreData(id, gainNum, itemId, costId, price, leftNum, leftRefreshTimes, totalRefreshTimes, refreshCostId, refreshCostNum)
	WZLog("WndStore:setEquipStoreData =",refreshCostId,refreshCostNum)
	self.m_tEquipmentData = {}
	for i,v in ipairs(id) do
		local temp = {}
		table.insert(temp,v)
		table.insert(temp,gainNum[i])
		table.insert(temp,itemId[i])
		table.insert(temp,costId[i])
		table.insert(temp,price[i])
		table.insert(temp,leftNum[i])

		table.insert(self.m_tEquipmentData,temp)
	end
	
	self.m_nEqiopfreshCount = leftRefreshTimes
    self.m_nEqiopfreshTotalCount = totalRefreshTimes

    self.m_nEqiopfreshCostId = refreshCostId
    self.m_nEqiopfreshCostCount = refreshCostNum

    self.m_rootEquipTable:cleanTable()
    self:closeLoadingB()
    if self.m_nStoreType == 8 then
    	self.m_rootEquipTable:setVisible(true)
    	self:showStoreList()
    	self:setButtomInfo()
    end
end

--设置符文商店数据
function WndStore:setRuneStoreData(commodityIds,commodityNums,refreshTimes)
	-- body
	WZLog("WndStore:setRuneStoreData")
	if self.m_root == nil then return end
	self:closeLoadingB()
	self.m_tRuneShopData = {}
	self.m_nRuneStoreRefreshCount = refreshTimes
	for i,v in ipairs(commodityIds) do
		local temp = {}
		table.insert(temp,v)
		table.insert(temp,commodityNums[i])
		table.insert(self.m_tRuneShopData,temp)
	end
	local tempShotData = GDatatab_rune_shop
	local tempItemData = GDatatab_item
	local playerInfo = CacheCenter:getPlayerInfo()
	table.sort(self.m_tRuneShopData,function (a,b)
		local aData = tempShotData["id_" .. a[1]]
		local bData = tempShotData["id_" .. b[1]]
		local aItem = nil
		local bItem = nil
		if playerInfo.sex == 0 then
			aItem = aData.item_boy
			bItem = bData.item_boy
		elseif playerInfo.sex == 1 then
			aItem = aData.item_girl
			bItem = bData.item_girl
		end
		local aItemInfo = tempItemData["id_" .. aItem[1][1]]
		local bItemInfo = tempItemData["id_" .. bItem[1][1]]
		local aQuality = aItemInfo.quality
		local bQuality = aItemInfo.quality
		if aQuality > bQuality then
			return true
		elseif aQuality == bQuality then
			if aItemInfo.value > bItemInfo.value then
				return true
			elseif aItemInfo.value == bItemInfo.value then
				if aItemInfo.id >  bItemInfo.id then
			        return true
		        end
			end
		end
		return false
	end)
	if self.m_nStoreType == 7 then
		self.m_rootRuneTable:setVisible(true)
		self:showStoreList()
    	self:setButtomInfo()
	end
end

--宠物商店
function WndStore:setPetShopData(tData)
	WZLog("WndStore:setPetShopData ")
	self.m_tPetShopData = tData
	self.m_rootPetTable:cleanTable()
	self:closeLoadingB()
    if self.m_nStoreType == 3 then
    	self.m_rootPetTable:setVisible(true)
    	self:showStoreList()
    	self:setButtomInfo()
    end
end

--公会商店
function WndStore:setCommunityShopData(tData)
	WZLog("WndStore:setCommunityShopData ")
	self:closeLoadingB()
	if self.m_tCommunityShopData == nil then
		self.m_rootCommunityTable:cleanTable()
		self.m_tCommunityShopData = {}
		for k,v in pairs(GDatatab_guild_store) do
			table.insert(self.m_tCommunityShopData,v)
		end

		for i,v in ipairs(self.m_tCommunityShopData) do
			v.itemNum = 0
			v.id = v.store
			for j,k in ipairs(tData) do
				if v.store == k.itemId then
					v.itemNum = k.itemNum
				end
			end
		end

		table.sort(self.m_tCommunityShopData,function (a,b)
			if a.itemNum > 0 and b.itemNum > 0 then
				if GDatatab_item["id_" ..a.store].quality > GDatatab_item["id_" ..b.store].quality then
					return true
				end
				if GDatatab_item["id_" ..a.store].quality == GDatatab_item["id_" ..b.store].quality and a.itemNum > b.itemNum then
					return true
				end
			end

			if a.itemNum > 0 and b.itemNum <= 0 then
				return true
			end

			if a.itemNum == 0 and b.itemNum == 0 then
				if GDatatab_item["id_" ..a.store].quality > GDatatab_item["id_" ..b.store].quality then
					return true
				end
			end
			
			return false
		end)

		if self.m_nStoreType == 2 then
			self.m_rootCommunityTable:setVisible(true)
			self:showStoreList()
			self:setButtomInfo()
        end
	else
		for i,v in ipairs(tData) do
			for j,k in ipairs(self.m_tCommunityShopData) do
				if v.itemId == k.store then
					k.itemNum = v.itemNum
				end
			end
		end
		
		local count = #self.m_tCommunityShopData
		for i=1,count do
			local element = self.m_rootCommunityTable:getCellElement(i-1)
			if element then
				local itemNum =  self.m_tCommunityShopData[i].itemNum
				local node = element:getChildByTag(i-1)
			    node = WZUIContainer:luaTo(node)
			    local luaObjectIndex = node:getLuaObjectIndex()
			    luaObjectIndex:updateStoreNum(itemNum)
			end
		end
	end
end

--卡牌商店数据
function WndStore:setCardShopData(itemId, level, num, shopId, shopItem, shopPrice, shopRebate,shopStatus,refreshCount)
	WZLog("WndStore:setCardShopData ")
	if self.m_root == nil then return end
	self:closeLoadingB()

	self.m_nCardRefreshCount = refreshCount

	self.m_tCardShopData = {}
	
	for i,v in ipairs(shopId) do
		local tempT = {}
		table.insert(tempT,shopId[i])
		table.insert(tempT,shopItem[i])
		table.insert(tempT,shopPrice[i])
		table.insert(tempT,shopRebate[i])
		table.insert(tempT,shopStatus[i])
		table.insert(self.m_tCardShopData,tempT)
	end
	
    if self.m_bBuyCardItem and self.m_nStoreType == 5 then
    	self:_refreshShopItem()
    	self.m_bBuyCardItem = false
    else
    	if self.m_nStoreType == 5 then
    		self.m_rootCardTable:cleanTable()
			self.m_rootCardTable:setVisible(true)
			self:showStoreList()
			self:setButtomInfo()
        end
    end
end

--@brief 	排位商店数据
function WndStore:setPvpRankShopData(id, gainNum, itemId, costId, price, leftNum, totalRefreshTimes)
	-- body
	self.m_tPvpRankData = {}
	self.m_nPvpRankRefreshCount  = totalRefreshTimes  
    self.m_rootPvpRankTable:cleanTable()
    self:closeLoadingB()
    for i,v in ipairs(id) do
		local temp = {}
		if itemId[i] > 0 then
			table.insert(temp,v)
			table.insert(temp,gainNum[i])
			table.insert(temp,itemId[i])
			table.insert(temp,costId[i])
			table.insert(temp,price[i])
			table.insert(temp,leftNum[i])

			table.insert(self.m_tPvpRankData,temp)
		end
	end
	WZLog("WndStore:setPvpRankShopData", Serialize(self.m_tPvpRankData))
    if self.m_nStoreType == 10 then
    	self.m_rootPvpRankTable:setVisible(true)
    	self:showStoreList()
    	self:setButtomInfo()
    end
end

--@brief    购买成功返回
function WndStore:buyCardSuccess(shopId)
	WZLog("WndStore:buyCardSuccess ",shopId)
	if self.m_root == nil then return end
	self:closeLoadingB()

	MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_SUCCESS)
	local count = #self.m_tCardShopData
	for i=1,count do
		local element = self.m_rootCardTable:getCellElement(i-1)
		if element then
			local node = element:getChildByTag(i-1)
		    node = WZUIContainer:luaTo(node)
		    local luaObjectIndex = node:getLuaObjectIndex()
		    if shopId ==  luaObjectIndex:getShopId()  then
		    	 luaObjectIndex:setSellOut(true)
		    end
		end
	end
end

--显示公会商店等级
function WndStore:showCommunityShopLevel()
	WZLog("WndStore:showCommunityShopLevel")
	if self.m_nStoreType == 2 then
		local getElement = GetElement
		local guildInfo = CacheCenter:getGuildInfo()
	    if guildInfo == nil then return end
		local conButtom = getElement(self.m_root,"conButtom_WndStore",WZUIContainer)
		local conCommunityUpdate = getElement(conButtom,"conCommunityUpdate_WndStore",WZUIContainer)
		--是否显示升级建筑按钮
		if guildInfo.position >= 3 then
			conCommunityUpdate:setVisible(true)
		else
			conCommunityUpdate:setVisible(false)
		end
	end
end

function WndStore:updateCommunityDiscount()
	-- body
	WZLog("WndStore:updateCommunityDiscount")
	if self.m_nStoreType == 2 and self.m_tCommunityShopData then
		local getElement = GetElement
		local conTop = getElement(self.m_root,"conTop_WndStore",WZUIContainer)
		local ftbCommunityShopDiscount = getElement(conTop,"ftbCommunityShopDiscount_WndStore",WZUIFreeTextBox)
		local guildInfo = CacheCenter:getGuildInfo()
		local storeLevel = guildInfo.storeLevel
		local discount = 0
		for k,v in pairs(GDatatab_guild_store_discount) do
			if v.store_level == storeLevel then
				discount = v.discount
				break
			end
		end
		if discount ~= 0 then
			discount = discount / 1000
		end
		if discount < 10 then
			local temp
			if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
				temp = string.format(LocalStrings.COMMUNITY_STORE_DISCOUNT,(100-discount*10).."%")
			else
				temp = string.format(LocalStrings.COMMUNITY_STORE_DISCOUNT,discount)
			end
			ftbCommunityShopDiscount:setShowText(temp)
		end
		
		local count = #self.m_tCommunityShopData
		for i=1,count do
			local element = self.m_rootCommunityTable:getCellElement(i-1)
			if element then
				local node = element:getChildByTag(i-1)
			    node = WZUIContainer:luaTo(node)
			    local luaObjectIndex = node:getLuaObjectIndex()
			    luaObjectIndex:setDiscount(discount)
			end
		end
	end
	
end

--公会商店升级成功
function WndStore:communityShopUpdateSuccess()
	WZLog("WndStore:communityShopUpdateSuccess")
	if self.m_root == nil then return end
	self:showCommunityShopLevel()
	self:updateCommunityDiscount()
	if self.m_nStoreType == 2 then
		local txtCurSel = GetElement(self.m_root,"txtCurSel_WndStore",WZUILabelTTF)
		local temp = LocalStrings.COMMUNITY_STORE
		local guildInfo = CacheCenter:getGuildInfo()
		temp = temp .. " " .. "Lv" .. guildInfo.storeLevel
		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
			txtCurSel:setScale(0.8)
		end
		txtCurSel:setText(temp)
	end
end

--黑市商店
function WndStore:setSurpriseShopData(tData,leftSecond,isOpen)
	WZLog("WndStore:setSurpriseShopData")
	if self.m_root == nil then return end
	self.m_tSurprisedShopData = tData
	self.m_nSurpriseLeftSecond = leftSecond
	self.m_bSurpriseIsOpen = isOpen
	self.m_rootSurprisedTable:cleanTable()
	self:closeLoadingB()
	self:showLeftStoreList()
    if self.m_nStoreType == 6 then
    	self.m_cellSurprise:setVisible(true)
    	self:showStoreList()
    	self:setButtomInfo()
    end
end

--祈福商店
function WndStore:setBlessShopData(tData)
	WZLog("WndStore:setBlessShopData")
	self.m_tBlessShopData = tData
	self.m_rootBlessTable:cleanTable()
	self:closeLoadingB()
    if self.m_nStoreType == 4 then
    	self.m_rootBlessTable:setVisible(true)
    	self:showStoreList()
    	self:setButtomInfo()
    end
end

--显示相应的道具商店
--type : 1 竞技商店 2 公会商店 3 宠物商店  4 祈福商店  5卡牌商店 6 黑市商店 7 符文商店 8 装备商店 9 冒险商店 10 排位商店
function WndStore:showStoreByType(storeType,closeCallbackLua,closeCallbakcFun)
	WZLog("WndStore:showStoreByType = ",storeType)
	if storeType == 2 then
		if not self:communityStoreIsOpen() then
			return
		end
	elseif storeType == 3 then
		if not self:petStoreIsOpen() then
			return
		end
	elseif storeType == 4 then
		if not self:blessStoreIsOpen() then
			return
		end
	elseif storeType == 5 then
		if not self:cardStoreIsOpen() then
			return
		end
	elseif storeType == 7 then
		if not self:checkRuneStoreIsOpen() then
			return
		end
	elseif storeType == 8 then
		if not self:checkEquipStoreIsOpen() then
			return
		end
	elseif storeType == 10 then
		if not self:getPvpRankCheckButtonOpen() then
			return
		end
	end
	if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
        self.m_root = nil
    end
	if self.m_root == nil then
		local wndStore = self:createElement()
		self.m_nStoreType = storeType
		self.m_callbackLua = closeCallbackLua
	    self.m_callbackFun = closeCallbakcFun
		WindowManager:addWindow(wndStore,self,nil,true,nil,true)
	end
end


function WndStore:getFightCheckButtonOpen()
	WZLog("WndStore:getFightCheckButtonOpen")
	if CheckButtonOpen(ISLAND_BUILDING_HALL,false) then
		return true
	end
	return false
end

function WndStore:getCommunityCheckButtonOpen()
	WZLog("WndStore:getCommunityCheckButtonOpen")
	if CheckButtonOpen(ISLAND_BUILDING_COMMUNITY,false) then
		if CacheCenter:getPlayerInfo().guildId > 0 and CacheCenter:getPlayerInfo().guildLevel >= 2 then
			return true
	    end 
	end
	return false
end

function WndStore:getPetCheckButtonOpen()
	WZLog("WndStore:getPetCheckButtonOpen")
	if CheckButtonOpen(ISLAND_RIGHT_PET,false) then
		return true
	end
	return false
end

function WndStore:getBlessCheckButtonOpen()
	WZLog("WndStore:getBlessCheckButtonOpen")
	if CheckButtonOpen(ISLAND_UP_BLESS,false) then
		return true
	end
	return false
end

function WndStore:getPvpRankCheckButtonOpen()
	WZLog("WndStore:getPvpRankCheckButtonOpen")
	if CheckButtonOpen(ISLAND_UP_QUALIFYING,false) then
		return true
	end
	return false
end

function WndStore:storeItemBuySuccess()
	WZLog("WndStore:storeItemBuySuccess =",self.m_nCurItemTag)
	if self.m_root == nil then return end
	self:closeLoadingB()
	MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_SUCCESS)
	SoundManager:playEffectSound(SoundDefine.E_S_KILL_GOUMAICHENGGONG)
	if self.m_nCurItemTag ~= nil and self.m_nCurItemTag  >= 0 then
		local curListTable = self:getCurListTable()
		local cellElement = curListTable:getCellElement(self.m_nCurItemTag)
		if cellElement then
			if self.m_nStoreType == 1 or self.m_nStoreType == 3 or self.m_nStoreType == 7 or self.m_nStoreType == 8 or self.m_nStoreType == 9 or self.m_nStoreType == 10 then 
				cellElement = cellElement:getChildByTag(self.m_nCurItemTag)
				cellElement = WZUIContainer:luaTo(cellElement)
				local luaObjectIndex = cellElement:getLuaObjectIndex()
				luaObjectIndex:updateSellStatus()
			end
		end
	end
    self.m_nCurItemTag = -1
end

function WndStore:storeItemBuyFile(stats)
	WZLog("WndStore:storeItemBuySuccess ",stats)
	self:closeLoadingB()
	MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_FAIL)
    self.m_nCurItemTag = -1
end

-- 玩家购买道具后，更新道具状态
function WndStore:updateStoreSellStatus()
	WZLog("WndStore:updateStoreSellStatus")
    if self.m_tCurBuyTable ~= nil then
    	self.m_tCurBuyTable.leftBuyTime = self.m_tCurBuyTable.leftBuyTime - 1
    	if self.m_tCurBuyTable.leftBuyTime > 1 then
    		self.m_tCurBuyTable.leftBuyTime = 1
    	end
    	self.m_tCurBuyCell:setData(self.m_tCurBuyTable)
    	self.m_tCurBuyTable = nil
    	self.m_tCurBuyCell = nil
    end
end


function WndStore:setCurSelT()
	WZLog("WndStore:setCurSelT")
	local txtCurSel = GetElement(self.m_root,"txtCurSel_WndStore",WZUILabelTTF)
	if self.m_nStoreType == 1 then
		txtCurSel:setText(LocalStrings.PVP_HALL_3)
	elseif self.m_nStoreType == 2 then
		local temp = LocalStrings.COMMUNITY_STORE
		local guildInfo = CacheCenter:getGuildInfo()
		temp = temp .. " " .. "Lv" .. guildInfo.storeLevel
		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
			txtCurSel:setScale(0.8)
		end
		txtCurSel:setText(temp)
	elseif self.m_nStoreType == 3 then
		txtCurSel:setText(LocalStrings.PET_STORE)
	elseif self.m_nStoreType == 5 then
		txtCurSel:setText(LocalStrings.CARD_SHOP)
	elseif self.m_nStoreType == 4 then
		txtCurSel:setText(LocalStrings.BLESS_SHOP)
	elseif self.m_nStoreType == 6 then
		txtCurSel:setText(LocalStrings.GAME_ACTIVITY_TITLE39)
		if ProjConfig.LANGUAGE == "pt" then
			txtCurSel:setScale(0.8)
		end
	elseif self.m_nStoreType == 7 then
		txtCurSel:setText(LocalStrings.RUNE_STORE)
	elseif self.m_nStoreType == 8 then
		txtCurSel:setText(LocalStrings.EQUIPSTORE)
	elseif self.m_nStoreType == 9 then
		txtCurSel:setText(LocalStrings.ADVENTURE_STORE)
	elseif self.m_nStoreType == 10 then
		txtCurSel:setText(LocalStrings.QUALIFYING_SHOP)
	end
end

--显示左边商店列表按钮
function WndStore:showLeftStoreList()
	WZLog("WndStore:showLeftStoreList =",self.m_nStoreType)
	local tabStoreList = GetElement(self.m_root,"tabStoreList_WndStore",WZUITableContainer)
	tabStoreList:cleanTable()
	
	local playerInfo = CacheCenter:getPlayerInfo()
	local globalMethod = GlobalMethod
	local localStrings = LocalStrings
	local stringList = {localStrings.PVP_HALL_3,LocalStrings.EQUIPSTORE,localStrings.COMMUNITY_STORE,localStrings.PET_STORE,localStrings.BLESS_SHOP,localStrings.CARD_SHOP,LocalStrings.RUNE_STORE,LocalStrings.ADVENTURE_STORE,LocalStrings.QUALIFYING_SHOP}
	local btnIdList = {5,11,9,88,64,76,115,-2,23}
	
	if self.m_bSurpriseIsOpen then
		table.insert(stringList,1,LocalStrings.GAME_ACTIVITY_TITLE39)
		table.insert(btnIdList,1,-1)
	end
	
	local tempType = nil

	local startIndex = 1
	if self.m_bSurpriseIsOpen then
		startIndex = 2
	end

	if self.m_nStoreType == 6 then
		tempType = btnIdList[1]
	elseif self.m_nStoreType == 8 then
		tempType = btnIdList[startIndex+1]
	elseif self.m_nStoreType == 1 then
		tempType = btnIdList[startIndex]
	elseif self.m_nStoreType == 2 then
		tempType = btnIdList[startIndex+2]
	elseif self.m_nStoreType == 3 then
		tempType = btnIdList[startIndex+3]
	elseif self.m_nStoreType == 4 then
		tempType = btnIdList[startIndex+4]
	elseif self.m_nStoreType == 5 then
		tempType = btnIdList[startIndex+5]
	elseif self.m_nStoreType == 7 then
		tempType = btnIdList[startIndex+6]
	elseif self.m_nStoreType == 9 then
		tempType = btnIdList[startIndex+7]
	elseif self.m_nStoreType == 10 then
		tempType = btnIdList[startIndex+8]
	end

	local storeCount = #stringList
	local curCon = nil
	local index = 0
	for i=1,storeCount do
		local con = WZUIContainer:create()
		con:setUseAbsSize(true)
		con:setAbsContentSize(globalMethod:CCSize(216,75))
		local btn = WZUIButton:create()
		btn:setTag(btnIdList[i])
		con:addChild(btn)
		
		con:setTag(index)

		btn:setLuaDoneFunctionName("onCheckBoxTemp")
		local normalElement = WZUIContainer:create()
		local seleElement = WZUIContainer:create()
		local disableElement = WZUIContainer:create()

		local norImage = WZUIImage:create()
		norImage:setUseOriginSize(true)
		norImage:setFile("ui/common/common_btn_anniu16.png")

		local selImage = WZUIImage:create()
		selImage:setUseOriginSize(true)
		selImage:setFile("ui/common/common_btn_anniu16.png")

		local disImage = WZUIImage:create()
		disImage:setUseOriginSize(true)
		disImage:setFile("ui/common/common_btn_anniu20.png")

		local norLabel = WZUILabelTTF:create()
		norLabel:setLabelStyleKey("C1_F22_S4_C2")
		local selLabel = WZUILabelTTF:create()
		selLabel:setLabelStyleKey("C1_F22_S4_C2")
		local disLabel = WZUILabelTTF:create()
		disLabel:setLabelStyleKey("C1_F22_S4_C2")

		norLabel:setText(stringList[i])
		selLabel:setText(stringList[i])
		disLabel:setText(stringList[i])

		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
			norLabel:setDimensions(GlobalMethod:CCSize(200,0))
			norLabel:setScale(0.8)
			selLabel:setDimensions(GlobalMethod:CCSize(200,0))
			selLabel:setScale(0.8)
			disLabel:setDimensions(GlobalMethod:CCSize(200,0))
			disLabel:setScale(0.8)
		end

		normalElement:addChild(norImage)
		normalElement:addChild(norLabel)

		seleElement:addChild(selImage)
		seleElement:addChild(selLabel)

		disableElement:addChild(disImage)
		disableElement:addChild(disLabel)

		btn:setNormalElement(normalElement)
		btn:setSelectElement(seleElement)
		btn:setDisableElement(disableElement)
		if btnIdList[i] == tempType then
			btn:setTouchEnable(false)
			self.m_noteCurShowBtn = btn
			curCon = con
		end
		
		if btnIdList[i] > 0 and playerInfo.level >= GDatatab_button_info["id_" .. btnIdList[i]].open_level then
			tabStoreList:setCellElement(con)
			index = index + 1
		elseif btnIdList[i] > 0 and playerInfo.level >= GDatatab_button_info["id_" .. btnIdList[i]].open_level then
			tabStoreList:setCellElement(con)
			index = index + 1
		elseif btnIdList[i] > 0 and playerInfo.level >= GDatatab_button_info["id_" .. btnIdList[i]].open_level then
			tabStoreList:setCellElement(con)
			index = index + 1
		elseif btnIdList[i] > 0 and playerInfo.level >= GDatatab_button_info["id_" .. btnIdList[i]].open_level then
			tabStoreList:setCellElement(con)
			index = index + 1
		elseif btnIdList[i] > 0 and playerInfo.level >= GDatatab_button_info["id_" .. btnIdList[i]].open_level then
			tabStoreList:setCellElement(con)
			index = index + 1
		elseif btnIdList[i] > 0 and playerInfo.level >= GDatatab_button_info["id_" .. btnIdList[i]].open_level then
			tabStoreList:setCellElement(con)
			index = index + 1
		elseif btnIdList[i] > 0 and playerInfo.level >= GDatatab_button_info["id_" .. btnIdList[i]].open_level then
			tabStoreList:setCellElement(con)
			index = index + 1
		elseif btnIdList[i] < 0 then
			tabStoreList:setCellElement(con)
			index = index + 1
		end
	end

	if index >= 8 then
		local psY = curCon:getParent():getPositionY()
		local psX = curCon:getParent():getPositionX()
		local tempP = CCPoint(psX,psY)
		local movElement = tabStoreList:getMoveElement()
		local dddd = movElement:convertToWorldSpace(tempP)
		local minPP = tabStoreList:getMinPosition();
		local maxPP = tabStoreList:getMaxPosition();
		if dddd.y < 0 then
			movElement:setPositionY(maxPP.y)
		end
	end
end

--获取当前正在显示物品table
function WndStore:getCurListTable()
	WZLog("WndStore:getCurListTable")
	if self.m_nStoreType == 1 then
		return self.m_rootFightTable
	elseif self.m_nStoreType == 2 then
		return self.m_rootCommunityTable
	elseif self.m_nStoreType == 3 then
		return self.m_rootPetTable
	elseif self.m_nStoreType == 5 then
		return self.m_rootCardTable
	elseif self.m_nStoreType == 4 then
		return self.m_rootBlessTable
	elseif self.m_nStoreType == 6 then
		return self.m_cellSurprise
	elseif self.m_nStoreType == 7 then
		return self.m_rootRuneTable
	elseif self.m_nStoreType == 8 then
		return self.m_rootEquipTable
	elseif self.m_nStoreType == 9 then
		return self.m_rootAdventureTable
	elseif self.m_nStoreType == 10 then
		return self.m_rootPvpRankTable
	end
end

--设置当前购买的cellItem ID
function WndStore:setItemTag(tag)
	WZLog("WndStore:setItemTag ",tag)
	self.m_bBuy = true
	self.m_nCurItemTag = tag
end

-- 修改时间显示
function WndStore:_initTime(time)
    local h = 60*60
    local m = 60
    local hour = math.floor(time/h)
    local min = math.floor((time-hour*h)/m)
    local sec = time - hour*h - min*m
    if hour < 10 then hour = "0"..hour end
    if min < 10 then min = "0"..min end
    if sec < 10 then sec = "0"..sec end
    return hour..":"..min..":"..sec
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    根据item_id获取商品卡牌id
function WndStore:_getShopCardId(itemId)
    -- body
    for idx, value in pairs(GDatatab_card_shop) do
        if value.item_id == itemId then
            return value.id
        end
    end

    return nil 
end

--@brief    计算当前购买所需加个
--@param    startPrice:初始的价格
--@param    number:剩余的购买次数
--@param    step:价格步长
--@param    buyType:1->购买一张；2->购买全部
--@param    count:总购买次数
--@param    maxPrice:单次购买最高价格
function WndStore:_getPrice(startPrice, number, step, buyType, count, maxPrice)
    local price = 0
    if buyType == 1 then
        price = startPrice + (count - number) * step
        if price > maxPrice then
            price = maxPrice
        end
    else
        local tempPrice
        for i = 1, number do
            if i == 1 then
                tempPrice = startPrice + (count - number) * step
            else 
                tempPrice = tempPrice + step 
            end

            if tempPrice > maxPrice then
                tempPrice = maxPrice
            end
            price = price + tempPrice
        end
    end
    
    return price 
end

--@brief    判断是否新激活的卡牌还是只是数量增加
function WndStore:_judgeNewCard(tData)
    WZLog("WndStore:_judgeNewCard")
    local bIsShowNumTips = true 
    for i = 1, #self.m_tUnActiveCardList do
        if self.m_tUnActiveCardList[i].item_id == tData.item_id then
            bIsShowNumTips = false
            break
        end
    end

    return bIsShowNumTips 
end

-------------------------------------私有方法模块End----------------------------------------
