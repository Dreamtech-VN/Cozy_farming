--WndDollMachineShopData.lua
--@brief	WndDollMachineShop的数据模块
--@date		2021/04/29
--@author	hyx
--@note		娃娃机商店

WndDollMachineShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDollMachineShop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nChipNum = 0
	self.m_tChipShopData = {}
	self.m_tCellItemChip = {}
	self.m_nType = -1
	self.m_nActivityId = nil 
	self.m_nOtherData = nil 			--其他一些配置数据
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDollMachineShop:_unInit()
	self.m_root = nil
	self.m_nChipNum = nil 
	self.m_tChipShopData = nil 
	self.m_tCellItemChip = nil 
	self.m_nType = nil 
	self.m_nActivityId = nil 
	self.m_nOtherData = nil 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDollMachineShop:createElement(_type)
	if WndDollMachineShop.m_root ~= nil then
		WindowManager:removeWindow(WndDollMachineShop.m_root, WndDollMachineShop, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDollMachineShop")
	assert(element, "WndDollMachineShop create element failed!")
	self:_init()
	self.m_nType = _type or -1
	return element
end

--[[
shopIds:[],商品id
itemIds:[],
itemNums:[],
costItemIds:[],消耗物品id
costItemNums:[],消耗物品数量
todayBuys:[],今日购买了的数量
totalBuys:[],总购买了的数量
todayLimit:[],今日限购
totalLimit:[],总限购
sales 是否卖完
--]]									
function WndDollMachineShop:setChipShopData(shopIds,itemIds,itemNums,costItemIds,costItemNums,canBuys,todayLimit,totalLimit, limitType)
	if shopIds and next(shopIds) ~= nil then
		for i=1,#shopIds do
			local tab = {}
			tab.shopId = shopIds[i]
			tab.itemId = itemIds[i]
			tab.itemNum = itemNums[i]
			tab.costItemId = costItemIds[i]
			tab.costItemNum = costItemNums[i]
			tab.canBuys = canBuys[i]
			tab.todayLimit = todayLimit[i]
			tab.totalLimit = totalLimit[i]
			tab.limitType = limitType[i]
			tab.activityId = self.m_nActivityId
			self.m_tChipShopData[i] = tab
		end
	end
end
--钓鱼模式
--[[
ids	: int[] [商品id],
boyItemId	: int[] [男物品id],
girlItemId	: int[] [女物品id],
nums	: int[] [物品数量],
limitNum	: int[] [商品限量],
soldNum	: int[] [已经售出数量]
]]
--@param 	origin:来源，主要用于宠物装备
function WndDollMachineShop:setChipShopFishData(data, origin)
	local _data = {}
	if next(data.ids) ~= nil then
		local sex = CacheCenter:getPlayerInfo().sex
		local index = 1
		for i=1, #data.ids do
			local tab = {}
			tab.id = data.ids[i]
			tab.num = data.nums[i]
			tab.limitNum = data.limitNums[i]
			tab.dailyLimit = data.playerDailyLimits[i]
			tab.dailyBuyNum = data.dailyBuyNums[i]
			tab.soldNum = data.soldNums[i]
			tab.price = data.prices[i]
			tab.activityId = self.m_nActivityId
			tab.reward = {}
			if sex == 0 then
				tab.reward = data.boyItemIds[i]
			else
				tab.reward = data.girlItemIds[i]
			end
			if origin then 
				tab.origin = origin
			end
			_data[index] = tab
			index = index + 1
		end
	end
	return _data
end

--=========== 碎片商店子项 ===============
CellChipShopItem = {}
function CellChipShopItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nChipNumber = 0
	self.m_nCostId = nil 
	self.m_tOtherData = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellChipShopItem:_unInit()
	self.m_root = nil
	self.m_nChipNumber = 0
	self.m_nCostId = nil 
	self.m_tOtherData = nil 
end

--@brief	创建控件
function CellChipShopItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(192,184))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end
-- _type  1:钓鱼
function CellChipShopItem:setChipShopItemData(data, _type, num, otherData)
	self.m_sChipShopData = data
	self.m_nItemType = _type or -1
	self.m_nChipNumber = num or 0
	self.m_tOtherData = otherData or {}
end

--@brief 	开始加载
function CellChipShopItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("itemChipShop")
	celElement:setVisible(true)
	element:addChild(celElement)
	if self.m_nItemType == 1 then
		self:setFishData()
	else
		self:setData()
	end

	AdaptLanguage(self)
end

function CellChipShopItem:setData()
	if not self.m_sChipShopData then return end

	GetElement(self.m_root,"item_bg",WZUIImage):setFile("ui/activity/common_pic_di_15.png")
	local data = self.m_sChipShopData
	self:setShowItem(data.itemId, data.itemNum)
	self:setDayLimit(data.canBuys, data.todayLimit, data.totalLimit, data.limitType)
	local txtBuy = GetElement(self.m_root,"txtBuy",WZUIFreeTextBox)
	local temp_info = GDatatab_item["id_"..data.costItemId]
	if temp_info then
		local str = string.format([[<I Z="0.35">%s</I><T C="127,70,26" S="20" P="1"> %d</T>]], temp_info.icon, data.costItemNum)
		txtBuy:setShowText(str)
	end

	-- if data.itemId == 161021 then 
	-- 	if CacheCenter:getPlayerInfo().level < 100 then 
	-- 		GetElement(self.m_root, "conLock_itemChipShop", WZUIContainer):setVisible(true)
	-- 		GetElement(self.m_root, "txtOpenLevel_itemChipShop", WZUILabelTTF):setText(string.format(LocalStrings.LEVEL_UNLOCK, 100))
	-- 	end
	-- end
end
--显示物品
function CellChipShopItem:setShowItem(id, num, visible, ccp, is_costom)
	visible = visible or false
	ccp = ccp or GlobalMethod:ccp(0.5,0.88)
	is_costom = is_costom or nil
	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	local tabItem = GDatatab_item["id_"..id]
	local txtItemName = GetElement(self.m_root,"txtItemName",WZUILabelTTF)
	if tabItem then
	    txtItemName:setText(tabItem.name)
	    txtItemName:setColor(QUALITYCOLOR[tabItem.quality])
	    txtItemName:setVisible(visible)
	    txtItemName:setRelativePosition(ccp)
		local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(tabItem)}
		local celElement,tLuaObj = CellGoodItem:createElement()
		goods_con:addChild(celElement)
		tLuaObj:setCellGoodItem(itemInfo, 5)
		tLuaObj:setItemClickFun(WndDollMachineShop,self.onItemClick)
		tLuaObj:setItemCount(num, is_costom)
	end
	-- if id == 161021 then 
	-- 	if CacheCenter:getPlayerInfo().level < 100 then 
	-- 		GetElement(self.m_root, "conLock_itemChipShop", WZUIContainer):setVisible(true)
	-- 		GetElement(self.m_root, "txtOpenLevel_itemChipShop", WZUILabelTTF):setText(string.format(LocalStrings.LEVEL_UNLOCK, 100))
	-- 	end
	-- end
end

function CellChipShopItem:setDayLimit(canBuys, todayLimit, totalLimit, limitType)
	local sellOutContainer = GetElement(self.m_root,"sellOutContainer",WZUIContainer)
	sellOutContainer:setVisible(false)
	local txtLimit = GetElement(self.m_root,"txtLimit",WZUIFreeTextBox)
	local str = [[<T C="127,70,26" S="20" P="1">%s:</T><T C="229,105,22" S="20" P="1">%d/%d</T>]]
	sellOutContainer:setVisible(canBuys == 0)
	local num = 0
	local buy_num = 0
	local str_name = ""
	
	if todayLimit ~= -1 and totalLimit ~= -1 then
		if canBuys <= todayLimit then
			str_name = LocalStrings.SHOP_LIMIT_TITLE --限购
			num = totalLimit
		else
			str_name = LocalStrings.SHOP_DAY_LIMIT --今日
			num = todayLimit
		end
	elseif todayLimit == -1 then --今日限购
		str_name = LocalStrings.SHOP_LIMIT_TITLE
		num = totalLimit
	elseif totalLimit == -1 then
		str_name = LocalStrings.SHOP_DAY_LIMIT
		num = todayLimit
	end
	buy_num = num - canBuys
	if canBuys == 0 then
		buy_num = num
	end
	--存在无限购买的时候
	if todayLimit == -1 and totalLimit == -1 then
		txtLimit:setVisible(false)
	elseif todayLimit ~= -1 and totalLimit ~= -1 then
		if limitType == 1 then --今日
			str_name = LocalStrings.SHOP_DAY_LIMIT
			num = todayLimit
			buy_num = num - canBuys
		elseif limitType == 2 then --总
			str_name = LocalStrings.SHOP_LIMIT_TITLE
			num = totalLimit
		end
	end
	txtLimit:setShowText(string.format(str, str_name, buy_num, num))
end

function CellChipShopItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndDollMachineShop.m_root,1,tData,false,nil,true)
end
function CellChipShopItem:onBtnBuy()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_sChipShopData then
		local data = self.m_sChipShopData
		if self.m_nItemType == 1 then
			local function func(itemId,itemNum,storeId)
				local tab = {}
				tab.id = itemId.m_sChipShopData.id
				tab.num = storeId
				tab = json.encode(tab)
				local doType = 3 
				if data.activityId == g_cityExtenInfo.activity7035 or data.activityId == g_cityExtenInfo.activity7046 or data.activityId == g_cityExtenInfo.activity7049 or data.activityId == g_cityExtenInfo.activity7055 or data.activityId == g_cityExtenInfo.activity7063 or data.activityId == g_cityExtenInfo.activity7083 or data.activityId == g_cityExtenInfo.activity7089 or data.activityId == g_cityExtenInfo.activity7096 or data.activityId == g_cityExtenInfo.activity7100 then 
					doType = 5
				elseif data.activityId == g_cityExtenInfo.activity7081 or data.activityId == g_cityExtenInfo.activity7091 or data.activityId == g_cityExtenInfo.activity7093 or data.activityId == g_cityExtenInfo.activity7097 or data.activityId == g_cityExtenInfo.activity7102 or data.activityId == g_cityExtenInfo.activity7105 or data.activityId == g_cityExtenInfo.activity7107 then
					doType = 7
				end
				if data.activityId == g_cityExtenInfo.activity7055 or data.activityId == g_cityExtenInfo.activity7063 or data.activityId == g_cityExtenInfo.activity7081 or data.activityId == g_cityExtenInfo.activity7083 or data.activityId == g_cityExtenInfo.activity7089 or data.activityId == g_cityExtenInfo.activity7091 or data.activityId == g_cityExtenInfo.activity7093 or data.activityId == g_cityExtenInfo.activity7096 or data.activityId == g_cityExtenInfo.activity7097 or data.activityId == g_cityExtenInfo.activity7100 or data.activityId == g_cityExtenInfo.activity7102 or data.activityId == g_cityExtenInfo.activity7105 or data.activityId == g_cityExtenInfo.activity7107 then
					local tabTemp = {}
					tabTemp.id = {}
					tabTemp.num = {}
					tabTemp.id[1] = itemId.m_sChipShopData.id
					tabTemp.num[1] = storeId
					tab = json.encode(tabTemp)
				elseif self.m_tOtherData and self.m_tOtherData.doType_buy then 
					doType = self.m_tOtherData.doType_buy
					local tabTemp = {}
					tabTemp.id = {}
					tabTemp.num = {}
					tabTemp.id[1] = itemId.m_sChipShopData.id
					tabTemp.num[1] = storeId
					tab = json.encode(tabTemp)
				end
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(data.activityId, doType, tab)
			end
			local remain,buyLimitNum,num1,num2 = 0,0,0,0
			remain = data.num
			WZLog("CellChipShopItem:onBtnBuy", data.limitNum, data.dailyLimit, data.dailyBuyNum)
			if data.limitNum == -1 and data.dailyLimit == -1 then
				buyLimitNum = math.floor(self.m_nChipNumber / data.price)
			elseif data.limitNum ~= -1 and data.dailyLimit ~= -1 then
				buyLimitNum = data.dailyLimit
			elseif data.limitNum == -1 and data.dailyLimit ~= -1 then
				buyLimitNum = data.dailyLimit - data.dailyBuyNum
			elseif data.limitNum ~= -1 and data.dailyLimit == -1 then
				buyLimitNum = data.limitNum - data.soldNum
			end
			local winType = nil 
			if data.activityId == g_cityExtenInfo.activity7049 then 
				winType = 2
			end
			WndAuctionBuy:show(data.reward,remain,self.m_nCostId,data.price,data.reward,self,func,buyLimitNum, winType)
		else
			local function func(itemId,nNum,nStoreId)
				local tab = {}
				tab.shopId = self.m_sChipShopData.shopId
				tab.num = nStoreId
				tab = json.encode(tab)
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(data.activityId, 3, tab)
			end
			local num = 0
			if data.todayLimit ~= -1 and data.totalLimit ~= -1 then
				if data.canBuys < data.totalLimit then
					num = data.totalLimit
				else
					num = data.todayLimit
				end
			elseif data.todayLimit == -1 then
				num = data.totalLimit
				data.limitType = 2
			elseif data.totalLimit == -1 then
				num = data.todayLimit
				data.limitType = 1
			end
			local buy_num = num - data.canBuys
			if data.canBuys == 0 then
				buy_num = num
			end
			
			local mul_num = num - buy_num
			if data.todayLimit ~= -1 and data.totalLimit ~= -1 then
				if data.limitType == 1 then --今日
					num = data.todayLimit
					mul_num = data.canBuys
				elseif data.limitType == 2 then --总
					num = data.totalLimit
				end
			end
			WndBuyMultipleItem:show(data.itemId, num, data.costItemId, data.costItemNum, data.shopId, self, func, 4, mul_num, {data.itemNum, data.limitType})
		end
	end
end
--========== 钓鱼模式 ============
function CellChipShopItem:setFishData()
	if not self.m_sChipShopData then return end

	local data = self.m_sChipShopData
	if data.activityId == g_cityExtenInfo.activity7049 or data.activityId == g_cityExtenInfo.activity7091 then 
		GetElement(self.m_root,"item_bg",WZUIImage):setFile("ui/activity/common_pic_di_15.png")
	elseif data.activityId == g_cityExtenInfo.activity7102 or data.activityId == g_cityExtenInfo.activity7107 then 
		GetElement(self.m_root,"item_bg",WZUIImage):setFile("ui/common/common_pic_di_32.png")
	elseif self.m_tOtherData and self.m_tOtherData.item_bg then 
		GetElement(self.m_root,"item_bg",WZUIImage):setFile(self.m_tOtherData.item_bg)
	else
		GetElement(self.m_root,"item_bg",WZUIImage):setFile("ui/common/common_pic_di_03.png")
	end
	self:setShowItem(data.reward, data.num, true,ccp(0.5,0.85), true)

	local txtBuy = GetElement(self.m_root,"txtBuy",WZUIFreeTextBox)
	self.m_nCostId = 160139
	if data.activityId == g_cityExtenInfo.activity7035 then 
		self.m_nCostId = 160186
	elseif data.activityId == g_cityExtenInfo.activity7037 then 
		self.m_nCostId = 160227
	elseif data.activityId == g_cityExtenInfo.activity7046 then 
		self.m_nCostId = 160240
	elseif data.activityId == g_cityExtenInfo.activity7049 then 
		self.m_nCostId = 160259
	elseif data.activityId == g_cityExtenInfo.activity7055 then 
		self.m_nCostId = 171420
	elseif data.activityId == g_cityExtenInfo.activity7063 then 
		self.m_nCostId = 160407
	elseif data.activityId == g_cityExtenInfo.activity7081 then 
		self.m_nCostId = 160464
	elseif data.activityId == g_cityExtenInfo.activity7083 then 
		self.m_nCostId = WndWishingBottle.m_nCoin2Id --160470
	elseif data.activityId == g_cityExtenInfo.activity7089 then 
		self.m_nCostId = 160493
	elseif data.activityId == g_cityExtenInfo.activity7091 then 
		self.m_nCostId = 160504
	elseif data.activityId == g_cityExtenInfo.activity7093 then 
		self.m_nCostId = 160514
	elseif data.activityId == g_cityExtenInfo.activity7096 then 
		self.m_nCostId = 160518
	elseif data.activityId == g_cityExtenInfo.activity7097 then 
		self.m_nCostId = 160536
	elseif data.activityId == g_cityExtenInfo.activity7100 then 
		self.m_nCostId = 160540
	elseif data.activityId == g_cityExtenInfo.activity7102 then 
		self.m_nCostId = 160552
	elseif data.activityId == g_cityExtenInfo.activity7105 then 
		self.m_nCostId = 160563
	elseif data.activityId == g_cityExtenInfo.activity7107 then 
		self.m_nCostId = 160566
	elseif self.m_tOtherData and self.m_tOtherData.coinId then 
		self.m_nCostId = self.m_tOtherData.coinId
	end
	local temp_info = GDatatab_item["id_" .. self.m_nCostId]
	if temp_info then
		local str = [[<I Z="0.4">%s</I><T C="127,70,26" S="18" P="1">%d</T>]]
		txtBuy:setShowText(string.format(str, temp_info.icon, data.price))
	end
	self:setFishBuyData(data.soldNum, data.limitNum, self.m_nChipNumber, data.dailyLimit, data.dailyBuyNum)
end
function CellChipShopItem:setFishBuyData(soldNum, limitNum, num, dailyLimit, dailyBuyNum)
	self.m_nChipNumber = num
	local sellOutContainer = GetElement(self.m_root,"sellOutContainer",WZUIContainer)
	local txtLimit = GetElement(self.m_root,"txtLimit",WZUIFreeTextBox)
	local visible = false
	local str_title, num1, num2 = "",0,0
	local str = [[<T C="127,70,26" S="20" P="1">%s:</T><T C="229,105,22" S="20" P="1">%d/%d</T>]]
	if limitNum == -1 and dailyLimit == -1 then
		visible = false
		num1,num2 = 0,1
	elseif limitNum ~= -1 and dailyLimit ~= -1 then
		visible = true
		str_title = LocalStrings.SHOP_LIMIT_TITLE
		num1 = soldNum
		num2 = limitNum
	elseif limitNum == -1 and dailyLimit ~= -1 then
		visible = true
		str_title = LocalStrings.SHOP_DAY_LIMIT
		num1 = dailyBuyNum
		num2 = dailyLimit
	elseif limitNum ~= -1 and dailyLimit == -1 then
		visible = true
		str_title = LocalStrings.SHOP_LIMIT_TITLE
		num1 = soldNum
		num2 = limitNum
	end
	txtLimit:setVisible(visible)
	txtLimit:setShowText(string.format(str,str_title, num1, num2))
	if num1 >= num2 then
		sellOutContainer:setVisible(true)
	else
		sellOutContainer:setVisible(false)
	end
end
--======================
--@return	新建的表实例对象
function CellChipShopItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function CellChipShopItem:_adaptLanguage_vn()
	local txtLimit = GetElement(self.m_root,"txtLimit",WZUIFreeTextBox)
	txtLimit:setScale(0.7)
	txtLimit:setMaxWidth(400)

	local txtItemName = GetElement(self.m_root,"txtItemName",WZUILabelTTF)
	txtItemName:setScale(0.7)
end
-------------------------------------语言适配end----------------------------------------

