--WndHVShopData.lua
--@brief	WndHVShop的数据模块
--@date		2022/05/30
--@author	XTX
--@note		度假村-商店界面

WndHVShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHVShop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tShopData = nil 
	self.m_nTabIndex = 1 				--1=种子；2=钻石道具
	self.m_tCellItem = nil 
	self.m_nRefreshInterval = 0 		--刷新间隔
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHVShop:_unInit()
	self.m_root = nil
	self.m_tShopData = nil 
	self.m_nTabIndex = nil 
	self.m_tCellItem = nil 
	self.m_nRefreshInterval = nil 		--刷新间隔
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHVShop:createElement()
	if WndHVShop.m_root ~= nil then
		WindowManager:removeWindow(WndHVShop.m_root, WndHVShop, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHVShop")
	assert(element, "WndHVShop create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndHVShop:showInterface()
	local wndhv = WndHVShop:createElement()
	if wndhv then 
		WindowManager:addWindow(wndhv, WndHVShop, false, nil, nil, true)
	end
end
	
--[[
ids	: int[] [商品id],
boyItemId	: int[] [男物品id],
girlItemId	: int[] [女物品id],
data	: string[] [商品配置],
lockState	: int[] [商品解锁状态],
rest	: int[] [剩余可购数量]
]]
function WndHVShop:setShopData(opType, synType, lockState, rest, data)
	if self.m_tShopData == nil then 
		self.m_tShopData = {}
	end
	if synType == 0 then 
		self.m_tShopData = {}
	end
	if self.m_tShopData[opType] == nil then 
		self.m_tShopData[opType] = {}
	end
	WZLog("WndHVShop:setShopData", Serialize(lockState), Serialize(rest), Serialize(data))
	if synType == 0 then  
		if lockState and next(lockState) ~= nil then
			for i=1,#lockState do
				local tab = {}

				local configData = json.decode(data[i])
				WZLog("WndHVShop:setShopData one", Serialize(configData))
				local strTemp = string.sub(configData.price, 2, -2) 
				tab.id = configData.id
				tab.num = tonumber(SplitStringWithSeparator(strTemp, ",")[1])
				tab.reward = configData.itemId
				tab.name = configData.name
				tab.openLevel = configData.lv
				tab.limitNum = configData.dayLimit
				tab.costId = tonumber(SplitStringWithSeparator(strTemp, ",")[2])
				tab.price = tonumber(SplitStringWithSeparator(strTemp, ",")[3])
				tab.dailyLimit = configData.sumLimit			
				tab.leftNum = rest[i]
				tab.lockState = lockState[i]
				tab.refreshTime = {}
				local arrayHour, arrayMin = SplitItemString(configData.refreshTime)
				for k = 1, #arrayHour do
					local tItem = {}
					tItem[1] = tonumber(arrayHour[k])
					tItem[2] = tonumber(arrayMin[k])

					table.insert(tab.refreshTime, tItem)
				end

				
				table.insert(self.m_tShopData[opType], tab)
			end
		end
		table.sort( self.m_tShopData[opType], function (a,b)
			return a.id < b.id
			end
			)
		self:_update()
	elseif synType == 2 then  
		if self.m_tShopData[opType] == nil then 
			self.m_tShopData[opType] = {}
		end

		for i=1,#lockState do
			for j = 1, #self.m_tShopData[opType] do
				local tab = self.m_tShopData[opType][j]

				local configData = json.decode(data[i])
				if configData.id == tab.id then 
					tab.leftNum = rest[i]
					tab.lockState = lockState[i]
					break 
				end
			end
		end
	end

end

--@brief 	购买结果
function WndHVShop:buyGoodsResult(result, shopId, leftNum, nums)
	if self.m_root == nil then return end 

	if result == 1 then 
		local tShopData = self.m_tShopData[self.m_nTabIndex]
		for i=1,#tShopData do
			if tShopData[i].id == shopId then
				WZLog("WndHVShop:buyGoodsResult", tShopData[i].reward, tShopData[i].num * nums)
				WndRewardShow:showById({tShopData[i].reward}, {tShopData[i].num * nums}, nil, nil, nil, nil, nil, 4)
				tShopData[i].leftNum = leftNum
				--需要获取当前商品的消耗货币剩余数量
				local nOwnNum = CellHVGoodsItem:getCoinOwnNum(tShopData[i].costId)
				if self.m_tCellItem[i] then
					self.m_tCellItem[i]:setBuyData(tShopData[i].leftNum, tShopData[i].limitNum, nOwnNum, tShopData[i].dailyLimit)
				end
				break
			end
		end
	elseif result == 3 or result == 4 then 
		if result == 3 then 
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[93])
		elseif result == 4 then 
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[94])
		end
		--重新刷新数量
		WZLog("WndHVShop:buyGoodsResult result", result)
		local tShopData = self.m_tShopData[self.m_nTabIndex]
		for i=1,#tShopData do
			if tShopData[i].id == shopId then
				tShopData[i].leftNum = leftNum
				--需要获取当前商品的消耗货币剩余数量
				local nOwnNum = CellHVGoodsItem:getCoinOwnNum(tShopData[i].costId)
				if self.m_tCellItem[i] then
					self.m_tCellItem[i]:setBuyData(tShopData[i].leftNum, tShopData[i].limitNum, nOwnNum, tShopData[i].dailyLimit)
				end
				break
			end
		end
	end
end

--@brief 	设置商店刷新最小间隔
function WndHVShop:setRefreshMinInterval(nSeconds)
	if self.m_root == nil then return end 

	self.m_nRefreshInterval = nSeconds
end

--@brief 	获取商店刷新最小间隔
function WndHVShop:getRefreshMinInterval()
	return self.m_nRefreshInterval
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
CellHVGoodsItem = {

}

function CellHVGoodsItem:_init()
	self.m_root = nil 
	self.m_bIsLoaded = false 
	self.m_tData = nil 
	self.m_nCoinNumber = 0 	--货币的数量
	self.m_nLeftSeconds = nil --刷新剩余时间
end

function CellHVGoodsItem:_unInit()
	self.m_root = nil 
	self.m_bIsLoaded = nil  
	self.m_tData = nil 
	self.m_nCoinNumber = nil 
	self.m_nLeftSeconds = nil 
end

function CellHVGoodsItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellHVGoodsItem")
	element:setAbsContentSize(GlobalMethod:CCSize(178,174))
	element:setLuaObjectIndex(tNewObj)

	return element, tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellHVGoodsItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellHVGoodsItem:onExit(element)
	if self.m_root then 
		self.m_root:disableSchedule()
	end
	self:_unInit()
end

function CellHVGoodsItem:buyCallBack(itemId,itemNum,storeId)
	WZLog("CellHVGoodsItem:onClickGoods", itemId, itemNum, storeId)
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ShopOp(3, storeId, itemNum)
end

--@brief 	点击物品回调
function CellHVGoodsItem:onClickGoods(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local data = self.m_tData
	local remain,buyLimitNum,num1,num2 = 0,0,0,0
	remain = data.num
	if data.limitNum == -1 and data.dailyLimit == -1 then
		buyLimitNum = math.floor(self.m_nCoinNumber / data.price)
	elseif data.limitNum ~= -1 and data.dailyLimit ~= -1 then
		buyLimitNum = data.dailyLimit
	elseif data.limitNum == -1 and data.dailyLimit ~= -1 then
		buyLimitNum = data.leftNum
	elseif data.limitNum ~= -1 and data.dailyLimit == -1 then
		buyLimitNum = data.leftNum
	end
	WndAuctionBuy:show(data.reward, remain, data.costId, data.price, data.id, self, self.buyCallBack, buyLimitNum, 3)
end

--@brief 	点击未解锁的商品回调
function CellHVGoodsItem:onClickLock(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	MsgBoxManager:showTipBox(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[80], self.m_tData.openLevel))
end

--@brief 	设置数据
function CellHVGoodsItem:setData(tData)
	self.m_tData = tData 
end

--@brief 	加载
function CellHVGoodsItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellHVGoodsItem")
	celElement:setVisible(true)
	self.m_root:addChild(celElement)
	self.m_bIsLoaded = true 

	self:_update()

	AdaptLanguage(self)
end

--@brief 	刷新
function CellHVGoodsItem:_update()
	self.m_nCoinNumber = self:getCoinOwnNum(self.m_tData.costId)
	self:showStatus()
	self:_showPrice()
	self:setShowItem(self.m_tData.reward, self.m_tData.num, true,ccp(0.5,0.85), true)
	self:setBuyData(self.m_tData.leftNum, self.m_tData.limitNum, self.m_nCoinNumber, self.m_tData.dailyLimit)
	self:_showRefreshTime()
	self.m_root:enableSchedule("_showRefreshTime", 1)
end

--@brief 	设置名字、等级，按钮状态
function CellHVGoodsItem:showStatus(tData)
	if tData then 
		self.m_tData = tData
	end
	if self.m_bIsLoaded == false then return end 

	local conLock = GetElement(self.m_root, "conLock_CellHVGoodsItem", WZUIContainer)
	if self.m_tData.lockState == 0 then 
		conLock:setVisible(true)
	else
		conLock:setVisible(false)
	end
end

--显示物品
function CellHVGoodsItem:setShowItem(id, num, visible, ccp, is_costom)
	visible = visible or false
	ccp = ccp or GlobalMethod:ccp(0.5,0.88)
	is_costom = is_costom or nil
	local conItem = GetElement(self.m_root,"conItem_CellHVGoodsItem",WZUIContainer)
	local tabItem = GDatatab_item["id_"..id]
	local txtItemName = GetElement(self.m_root,"txtName_CellHVGoodsItem",WZUILabelTTF)
	if tabItem then
	    txtItemName:setText(tabItem.name)
	    txtItemName:setColor(QUALITYCOLOR[tabItem.quality])
	    txtItemName:setVisible(visible)
	    txtItemName:setRelativePosition(ccp)
		local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(tabItem)}
		local seedData = WndHVLibrary:getSeedDataByItemId(id)
		if seedData then 
			itemInfo.basicInfo.icon = seedData.icon_zz
		end
		local celElement,tLuaObj = CellGoodItem:createElement()
		conItem:addChild(celElement)
		tLuaObj:setCellGoodItem(itemInfo, 5)
		tLuaObj:setItemClickFun(WndHVShop, self.onItemClick)
		tLuaObj:setItemCount(num, is_costom)
	end
end

function CellHVGoodsItem:setBuyData(leftNum, limitNum, num, dailyLimit)
	self.m_nCoinNumber = num
	local conSellOut = GetElement(self.m_root,"conSellOut_CellHVGoodsItem",WZUIContainer)
	local ftxtLimit = GetElement(self.m_root,"ftxtLimit_CellHVGoodsItem",WZUIFreeTextBox)
	local visible = false
	local str_title, num1, num2 = "",0,0
	local str = [[<T C="127,70,26" S="20" P="1">%s:</T><T C="229,105,22" S="20" P="1">%d/%d</T>]]
	if limitNum == -1 and dailyLimit == -1 then
		visible = false
		num1,num2 = 0,1
	elseif limitNum ~= -1 and dailyLimit ~= -1 then
		visible = true
		str_title = LocalStrings.SHOP_LIMIT_TITLE
		num1 = limitNum - leftNum
		num2 = limitNum
	elseif limitNum == -1 and dailyLimit ~= -1 then
		visible = true
		str_title = LocalStrings.SHOP_DAY_LIMIT_HV
		num1 = dailyLimit - leftNum
		num2 = dailyLimit
	elseif limitNum ~= -1 and dailyLimit == -1 then
		visible = true
		str_title = LocalStrings.SHOP_LIMIT_TITLE
		num1 = limitNum - leftNum
		num2 = limitNum
	end
	ftxtLimit:setVisible(visible)
	ftxtLimit:setShowText(string.format(str,str_title, num1, num2))
	if num1 >= num2 then
		conSellOut:setVisible(true)
	else
		conSellOut:setVisible(false)
	end
end

--@brief 	显示价格
function CellHVGoodsItem:_showPrice()
	local ftxtPrice = GetElement(self.m_root, "ftxtPrice_CellHVGoodsItem", WZUIFreeTextBox)
	local temp_info = GDatatab_item["id_" .. self.m_tData.costId]
	if temp_info then
		local str = [[<I Z="0.5">%s</I><T C="255,250,236" S="24" P="1" SC="0,108,3" SE="1" SS="4">%d</T>]]
		ftxtPrice:setShowText(string.format(str, temp_info.icon, self.m_tData.price))
	end
end

--@brief 	显示下次刷新时间
function CellHVGoodsItem:_showRefreshTime()
	if self.m_bIsLoaded == false then return end 

	local txtRefreshTime = GetElement(self.m_root, "txtRefreshTime_CellHVGoodsItem", WZUILabelTTF)
	if self.m_nLeftSeconds == nil then 
		local curDate = SystemTime:getTimeTabelByServerTimestamp(SystemTime:getServerTime())
		local nLeftSeconds = 0 
		local bIsInTime = false 
		for i = 1, #self.m_tData.refreshTime do
			if tonumber(curDate.hour) < self.m_tData.refreshTime[i][1] or (tonumber(curDate.hour) == self.m_tData.refreshTime[i][1] and tonumber(curDate.min) < self.m_tData.refreshTime[i][2]) then
				nLeftSeconds = (self.m_tData.refreshTime[i][1] - tonumber(curDate.hour)) * 3600 + self.m_tData.refreshTime[i][2] * 60 - tonumber(curDate.min) * 60 - tonumber(curDate.sec)
				bIsInTime = true 
				break 
			end 
		end
		--当前时钟已经过了当天配置的更新时刻
		if not bIsInTime then 
			nLeftSeconds = self.m_tData.refreshTime[1][1] * 3600 + self.m_tData.refreshTime[1][2] * 60 + (24 - tonumber(curDate.hour)) * 3600 - tonumber(curDate.min) * 60
		end

		self.m_nLeftSeconds = nLeftSeconds
	elseif self.m_nLeftSeconds > 0 then 
		self.m_nLeftSeconds = self.m_nLeftSeconds - 1
	elseif self.m_nLeftSeconds == 0 then 
		if WndHVShop:getRefreshMinInterval() <= 0 then 
			ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ShopOp(WndHVShop.m_nTabIndex, 0, 0)
			WndHVShop:setRefreshMinInterval(5)
		end
		return 
	end

	local strTime = returnToTimeFormat(self.m_nLeftSeconds)
	txtRefreshTime:setText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT3[1], strTime))
end

--@brief 	获取货币数量
function CellHVGoodsItem:getCoinOwnNum(id)
	local moneyList = CacheCenter:getMoneyList()
	local nOwnNum = 0 
	if id == 1 then 
		nOwnNum = moneyList.blueDiamond
	elseif id == 2 then 
		nOwnNum = moneyList.gold
	elseif id == 70 then 
		nOwnNum = moneyList.ticket
	else
		nOwnNum = CacheCenter:getPlayerItemCountById(id)
	end

	return nOwnNum
end

function CellHVGoodsItem:_new()
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self

	return tNewObj
end

-------------------------------------语言适配Begin----------------------------------------

function CellHVGoodsItem:_adaptLanguage_vn()
	local txtName = GetElement(self.m_root, "txtName_CellHVGoodsItem", WZUILabelTTF)
	txtName:setScale(0.5)
	txtName:setDimensions(CCSize(260,0))

	local ftxtLimit = GetElement(self.m_root,"ftxtLimit_CellHVGoodsItem",WZUIFreeTextBox)
	ftxtLimit:setMaxWidth(400)
	ftxtLimit:setScale(0.6)
end

-------------------------------------语言适配End----------------------------------------
