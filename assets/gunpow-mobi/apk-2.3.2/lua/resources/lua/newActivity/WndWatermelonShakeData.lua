--WndWatermelonShakeData.lua
--@brief	WndWatermelonShake的数据模块
--@date		2022/06/27
--@author	XTX
--@note		夏日西瓜摇摇乐

WndWatermelonShake = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWatermelonShake:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCoinId = 160278 		
	self.m_nCoinId2 = 160279 		
	self.m_nCoinId3 = 160285 		
	self.m_bOpenState = false 
	self.m_nMaxLimit = 5 
	self.m_nPoolIndex = 1 				--1=A   2=S
	self.m_tSelItem = nil 				--已选择的奖励
	self.m_tRewardPool = nil 			--奖池数据
	self.m_nTotalShakeTimes = 0 		--累计摇奖次数
	self.m_nTransBaseNum = 10           --次数和奖励转换基数
	self.m_nActivityId = nil 
	self.m_nFirstRefreshCost = 1 		--首次刷新消耗
	self.m_nRefreshAddStep = 1 			--刷新消耗增长值
	self.m_nRefreshCount = 0 			--今日刷新次数
	self.m_tShakeReward = nil 			--摇摇乐奖励
	self.m_tCellPool = nil 				--奖池的奖励Cell
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWatermelonShake:_unInit()
	self.m_root = nil
	self.m_nCoinId = nil 
	self.m_nCoinId2 = nil 
	self.m_nCoinId3 = nil 
	self.m_bOpenState = nil 
	self.m_nMaxLimit = nil 
	self.m_nPoolIndex = nil 
	self.m_tSelItem = nil 
	self.m_tRewardPool = nil 			--奖池数据
	self.m_nTotalShakeTimes = nil 
	self.m_nTransBaseNum = nil           --转换基数
	self.m_nActivityId = nil 
	self.m_nFirstRefreshCost = nil 		--首次刷新消耗
	self.m_nRefreshAddStep = nil 		--刷新消耗增长值
	self.m_nRefreshCount = nil 			--今日刷新次数
	self.m_tShakeReward = nil 			--摇摇乐奖励
	self.m_tCellPool = nil 				--选中的奖励
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWatermelonShake:createElement()
	if WndWatermelonShake.m_root ~= nil then
		WindowManager:removeWindow(WndWatermelonShake.m_root, WndWatermelonShake, true)
	end
	local element = WZUISystem:getInstance():createElement("WndWatermelonShake")
	assert(element, "WndWatermelonShake create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndWatermelonShake:showInterface(activityId)
	local wndWater = WndWatermelonShake:createElement()
	if wndWater then 
		self.m_nActivityId = activityId
		WindowManager:addWindow(wndWater, WndWatermelonShake, false, nil, nil, true)
	end
end

--@brief 	设置射箭的状态
function WndWatermelonShake:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	设置摇摇乐奖励数据
function WndWatermelonShake:setShakeRewardData(shakeRewardIds, shakeRewardNums, dailyRefreshCount, yylConfig)
	if self.m_root == nil then return end 
	
	self.m_tShakeReward = {}
	self.m_nRefreshCount = dailyRefreshCount
	if yylConfig then 
		self.m_nFirstRefreshCost = yylConfig[2]
		self.m_nRefreshAddStep = yylConfig[3] 			--刷新消耗增长值
	end

	for i = 1, #shakeRewardIds do
		local tItem = {}

		tItem.itemId = shakeRewardIds[i]
		tItem.itemNum = shakeRewardNums[i]

		table.insert(self.m_tShakeReward, tItem)
	end

	self:_showShakeRewards()
	self:_updateLightNum()
end

--@brief 	设置奖池数据
function WndWatermelonShake:setRewardPoolData(rewardType, data)
	if self.m_root == nil then return end 

	if self.m_tRewardPool == nil then self.m_tRewardPool = {} end 
	if self.m_tRewardPool[rewardType + 1] == nil then self.m_tRewardPool[rewardType + 1] = {} end 
	self.m_tRewardPool[rewardType + 1] = WndDollMachineShop:setChipShopFishData(data, 887051)

	local tRewardData = self.m_tRewardPool[self.m_nPoolIndex]
	self.m_nTransBaseNum = tRewardData[1].price

	self:_update()
end

--@brief	缓存推送更新物品时调用的函数
function WndWatermelonShake:updatePlayerItemData()
	WZLog("WndWatermelonShake:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:updateChooseNum()
		self:_setFreeBtnText()
	end
end

--@brief 	领取自选奖励返回
function WndWatermelonShake:getPoolRewardOK(tResult)
	self.m_tSelItem = nil 
	WndRewardShow:showById(tResult.itemIds, tResult.itemNums, nil, nil, nil, nil, nil, nil, nil, nil, nil, tResult.playerItemIds)

	local tPoolData = self.m_tRewardPool[tResult.shopType + 1]
	for i = 1, #tResult.id do
		for k = 1, #tPoolData do
			if tPoolData[k].id == tResult.id[i] then 
				tPoolData[k].soldNum = tResult.soldNum[i]
				tPoolData[k].dailyBuyNum = tResult.dailyBuyNum[i]

				self.m_tCellPool[k]:setFishBuyData(tPoolData[k].soldNum, tPoolData[k].limitNum, tPoolData[k].dailyLimit, tPoolData[k].dailyBuyNum)
				self.m_tCellPool[k]:setItemSelState(false)
				break 
			end
		end
	end

	self:updateChooseNum()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
CellMelonShakeItem = {}
function CellMelonShakeItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tItemCell = nil 
	self.m_nPointDownTime = 0 
	self.m_nType = 0 		--0=西瓜摇摇乐；1=拜财神-招财进宝
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMelonShakeItem:_unInit()
	self.m_root = nil
	self.m_nCostId = nil 
	self.m_tItemCell = nil 
	self.m_nPointDownTime = 0 
	self.m_nType = nil 
end

--@brief	创建控件
function CellMelonShakeItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(80,80))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end
-- _type  1:钓鱼
function CellMelonShakeItem:setChipShopItemData(data, nType)
	self.m_sChipShopData = data
	self.m_nType = nType or 0
end

--@brief 	开始加载
function CellMelonShakeItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellMelonShakeItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setFishData()

	AdaptLanguage(self)
end

--显示物品
function CellMelonShakeItem:setShowItem(id, num)
	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	local tabItem = GDatatab_item["id_"..id]
	WZLog("CellMelonShakeItem:setShowItem", Serialize(self.m_sChipShopData), self.m_sChipShopData.origin)
	if tabItem then
		local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(tabItem), origin = self.m_sChipShopData.origin}
		local celElement,tLuaObj = CellGoodItem:createElement()
		goods_con:addChild(celElement)
		tLuaObj:setCellGoodItem(itemInfo, 17)
		tLuaObj:setItemClickFun(self, self.onBtnBuy)

		self.m_tItemCell = tLuaObj
	end
end

function CellMelonShakeItem:setDayLimit(canBuys, todayLimit, totalLimit, limitType)
	local sellOutContainer = GetElement(self.m_root,"sellOutContainer_CellMelonShakeItem",WZUIContainer)
	sellOutContainer:setVisible(false)
	local conLimit = GetElement(self.m_root,"conLimit_CellMelonShakeItem",WZUIContainer)
	local txtLimit = GetElement(self.m_root,"txtLimit_CellMelonShakeItem",WZUILabelTTF)
	local str = [[%s:%d/%d]]
	sellOutContainer:setVisible(canBuys == 0)
	local num = 0
	local buy_num = 0
	local str_name = ""
	
	if todayLimit ~= -1 and totalLimit ~= -1 then
		if canBuys <= todayLimit then
			str_name = LocalStrings.SHOP_LIMIT_TITLE --限购
			num = totalLimit
		else
			str_name = LocalStrings.WATERMELON_TEXT1[25] --今日
			num = todayLimit
		end
	elseif todayLimit == -1 then --今日限购
		str_name = LocalStrings.SHOP_LIMIT_TITLE
		num = totalLimit
	elseif totalLimit == -1 then
		str_name = LocalStrings.WATERMELON_TEXT1[25]
		num = todayLimit
	end
	buy_num = num - canBuys
	if canBuys == 0 then
		buy_num = num
	end
	--存在无限购买的时候
	if todayLimit == -1 and totalLimit == -1 then
		conLimit:setVisible(false)
	elseif todayLimit ~= -1 and totalLimit ~= -1 then
		if limitType == 1 then --今日
			str_name = LocalStrings.WATERMELON_TEXT1[25]
			num = todayLimit
			buy_num = num - canBuys
		elseif limitType == 2 then --总
			str_name = LocalStrings.SHOP_LIMIT_TITLE
			num = totalLimit
		end
	end
	txtLimit:setText(string.format(str, str_name, buy_num, num))
end

--@brief 	触摸开始回调
function CellMelonShakeItem:onBtnDown()
	self.m_nPointDownTime = os.time()
end

function CellMelonShakeItem:onBtnBuy(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nPressTime = os.time() - self.m_nPointDownTime
	self.m_nPointDownTime = os.time()
	if nPressTime >= 1 then 
		local tData = {}
		tData.basicInfo = GDatatab_item["id_" .. self.m_sChipShopData.reward]
		tData.lastNum = self.m_sChipShopData.num
		tData.lastTime = self.m_sChipShopData.num
		if self.m_nType == 0 then 
			tData.origin = 887051
			WndWatermelonShake:onClickItem2(self, 1, tData)
		elseif self.m_nType == 1 then 
			tData.origin = 867062
			WndBringTreasure:onClickItem2(self, 1, tData)
		end
		return
	end
	if self.m_nType == 0 then 
		WndWatermelonShake:onClickItem(self, self.m_sChipShopData)
	elseif self.m_nType == 1 then 
		WndBringTreasure:onClickItem(self, self.m_sChipShopData)
	end
end

--@brief 	设置选中状态
function CellMelonShakeItem:setItemSelState(bVisible)
	if self.m_tItemCell == nil then return end 

	self.m_tItemCell:setItemSelState(bVisible)
end

--@brief 	获取商品Id
function  CellMelonShakeItem:getShopId()
	-- body
	return self.m_sChipShopData.id
end
--========== 钓鱼模式 ============
function CellMelonShakeItem:setFishData()
	if not self.m_sChipShopData then return end

	local data = self.m_sChipShopData
	
	self:setShowItem(data.reward, data.num, true,ccp(0.5,0.85), true)

	self:setFishBuyData(data.soldNum, data.limitNum, data.dailyLimit, data.dailyBuyNum)
end
function CellMelonShakeItem:setFishBuyData(soldNum, limitNum, dailyLimit, dailyBuyNum)
	local sellOutContainer = GetElement(self.m_root,"sellOutContainer_CellMelonShakeItem",WZUIContainer)
	local conLimit = GetElement(self.m_root,"conLimit_CellMelonShakeItem",WZUIContainer)
	local txtLimit = GetElement(self.m_root,"txtLimit_CellMelonShakeItem",WZUILabelTTF)
	local visible = false
	local str_title, num1, num2 = "",0,0
	local str = [[%s:%d/%d]]
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
		str_title = LocalStrings.WATERMELON_TEXT1[25]
		num1 = dailyBuyNum
		num2 = dailyLimit
	elseif limitNum ~= -1 and dailyLimit == -1 then
		visible = true
		str_title = LocalStrings.SHOP_LIMIT_TITLE
		num1 = soldNum
		num2 = limitNum
	end
	conLimit:setVisible(visible)
	txtLimit:setText(string.format(str,str_title, num1, num2))
	if num1 >= num2 then
		sellOutContainer:setVisible(true)
	else
		sellOutContainer:setVisible(false)
	end
end
--======================
--@return	新建的表实例对象
function CellMelonShakeItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------语言适配Begin----------------------------------------

function CellMelonShakeItem:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtLimit_CellMelonShakeItem",WZUILabelTTF):setScale(0.7)
end

--------------------------------------语言适配End-----------------------------------------
