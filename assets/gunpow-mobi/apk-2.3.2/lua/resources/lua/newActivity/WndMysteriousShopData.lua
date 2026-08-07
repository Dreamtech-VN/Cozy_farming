--WndMysteriousShopData.lua
--@brief	WndMysteriousShop的数据模块
--@date		2024/10/21
--@author	yrd
--@note		双11神秘商店

WndMysteriousShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMysteriousShop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTabIndex = 1 				--标签下标

	self.m_nCoinId = 160732				--购物卡
	self.m_tCouponIds1 = {160741, 160742, 160743, 160744, 160745, 163117, 163118, 163119, 163120, 163121, 163122, 163123, 163124}	--折扣券
	self.m_tCouponIds2 = {160746, 160747, 160748, 160749, 160750, 160751, 163125, 163126, 163127, 163128}	--满减券

	self.m_tM1GiftsData = nil 			--神秘商店数据
	self.m_tM1GiftsObj = nil 			--神秘商店对象
	self.m_tM2TasksData = nil 			--今日任务数据
	self.m_tM2TasksObj = nil 			--今日任务对象
	self.m_tM3GiftsData = nil 			--全服秒杀数据
	self.m_tM3GiftsObj = nil 			--全服秒杀对象
	self.m_tM4CartData = nil 			--购物车数据
	self.m_tM4CartObj = nil 			--购物车对象

	self.m_tM1ConPtY = nil 				--记录神秘商店列表位置
	self.m_tM2ConPtY = nil 				--记录每日任务列表位置
	self.m_tM3ConPtY = nil 				--记录全服秒杀列表位置
	self.m_tM4ConPtY = nil 				--记录购物车列表位置
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMysteriousShop:_unInit()
	self.m_root = nil
	self.m_nTabIndex = nil

	self.m_nCoinId = nil
	self.m_tCouponIds1 = nil
	self.m_tCouponIds2 = nil

	self.m_tM1GiftsData = nil
	self.m_tM1GiftsObj = nil
	self.m_tM2TasksData = nil
	self.m_tM2TasksObj = nil
	self.m_tM3GiftsData = nil
	self.m_tM3GiftsObj = nil
	self.m_tM4CartData = nil
	self.m_tM4CartObj = nil

	self.m_tM1ConPtY = nil
	self.m_tM2ConPtY = nil
	self.m_tM3ConPtY = nil
	self.m_tM4ConPtY = nil

end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMysteriousShop:createElement()
	if WndMysteriousShop.m_root ~= nil then
		WindowManager:removeWindow(WndMysteriousShop.m_root, WndMysteriousShop, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMysteriousShop")
	assert(element, "WndMysteriousShop create element failed!")
	self:_init()
	return element
end

--@brief 	获取活动详情成功
function WndMysteriousShop:GetActivityInfoOK(activityId, maxCount, count, status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if g_cityExtenInfo.activity7144 == activityId then
		self.m_nActivityId = activityId
		-- self.m_nMaxCount = maxCount
		-- self.m_nCount = count
		-- self.m_nStatus = status
		-- self.m_nRewardCounts = rewardCounts
		-- self.m_nRewardItems = rewardItems
		-- self.m_nRewardItemsParamCount = rewardItemsParamCount
		self.m_nStartTime = startTime
		self.m_nEndTime = endTime
		self.m_tContent = json.decode(content)
		-- self.m_nRewardId = rewardId
		-- self.m_nFinishCondition = finishCondition
		-- self.m_nTips = tips
		
		self:_initActivityTime()
	end
end

--@brief 	获取其他活动数据
function WndMysteriousShop:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then
		local tResult = json.decode(jsonData)
		WZLog("WndMysteriousShop:_onGetOtherData", doType, Serialize(tResult))

		self.m_nResetTimes = tResult.resetTimes

		local sex = CacheCenter:getPlayerInfo().sex

		self.m_tM1GiftsData = {}
		for i=1,#tResult.ids do
			local tData = {}
			tData.id = tResult.ids[i]
			if sex == 0 then
				tData.itemId = tResult.boyItemIds[i]
			else
				tData.itemId = tResult.girlItemIds[i]
			end
			tData.itemNum = tResult.nums[i]
			tData.price = tResult.prices[i]
			tData.discountPrice = tResult.discountPrices[i]
			tData.limitNum = tResult.limitNums[i]
			tData.soldNum = tResult.soldNums[i]
			tData.shopCartNum = tResult.shopCartNum[i]
			tData.stacking = tResult.stacking[i]

			tData.activityId = activityId
			tData.costId = self.m_tContent.goodsConfig[3]
			table.insert(self.m_tM1GiftsData, tData)
		end

		self:updateUIM1()
	elseif doType == 2 then
		local tResult = json.decode(jsonData)
		WZLog("WndMysteriousShop:_onGetOtherData", doType, Serialize(tResult))

		self.m_nSecKillTime = tResult.secKillTime

		local sex = CacheCenter:getPlayerInfo().sex

		self.m_tM3GiftsData = {}
		for i=1,#tResult.ids do
			local tData = {}
			tData.id = tResult.ids[i]
			if sex == 0 then
				tData.itemId = tResult.boyItemIds[i]
			else
				tData.itemId = tResult.girlItemIds[i]
			end
			tData.itemNum = tResult.nums[i]
			tData.price = tResult.prices[i]
			tData.discountPrice = tResult.discountPrices[i]
			tData.playerDailyLimit = tResult.playerDailyLimits[i]
			tData.globalDailyLimit = tResult.globalDailyLimits[i]
			tData.playerDailyBuyNum = tResult.playerDailyBuyNums[i]
			tData.globalDailyBuyNum = tResult.globalDailyBuyNums[i]

			tData.activityId = activityId
			tData.costId = self.m_tContent.secKillConfig[3]
			table.insert(self.m_tM3GiftsData, tData)
		end

		self:updateUIM3()
	elseif doType == 4 then
		local tResult = json.decode(jsonData)

		self.m_nCartDisItem = tResult.cartDisItem

		self.m_tM4CartData = {}
		for i=1,#tResult.orderId do
			local tData = {}
			tData.orderId = tResult.orderId[i]
			if sex == 0 then
				tData.itemId = tResult.boyItemIds[i]
			else
				tData.itemId = tResult.girlItemIds[i]
			end
			tData.itemNum = tResult.itemNum[i]
			tData.price = tResult.prices[i]
			tData.discountPrice = tResult.discountPrices[i]
			tData.discountItem = tResult.discountItem[i]
			tData.staking = tResult.stakings[i]
			tData.option = tResult.options[i]
			tData.time = tResult.times[i]
			tData.shopCartNum = tResult.shopCartNum[i]

			tData.activityId = activityId
			tData.costId = self.m_tContent.goodsConfig[3]
			table.insert(self.m_tM4CartData, tData)
		end

		self:updateTitle4()
		self:updateUIM4()
	elseif doType == 8 then
		if result == 0 then
			MsgBoxManager:showTipBox(LocalStrings.MYSTERIOUS_SHOP_TEXT1[13])
		else
			MsgBoxManager:showTipBox(LocalStrings.OPERATION_ERROR)
		end
	elseif doType == 9 then
		if result == 0 then
			local tResult = json.decode(jsonData)
			WndRewardShow:showById({tResult.itemId},{tResult.itemNum}, nil, nil, nil, nil, nil, nil, nil, nil, nil, {tResult.playerItemIds})
		elseif result == 4 then
			MsgBoxManager:showTipBox(LocalStrings.MYSTERIOUS_SHOP_TEXT1[18])
			self:updateUI()
		else
			MsgBoxManager:showTipBox(LocalStrings.OPERATION_ERROR)
			self:updateUI()
		end
	elseif doType == 10 then
		if result == 0 then
			local tResult = json.decode(jsonData)
			WndRewardShow:showById(tResult.itemId,tResult.itemNum, nil, nil, nil, nil, nil, nil, nil, nil, nil, tResult.playerItemIds)
		else
			MsgBoxManager:showTipBox(LocalStrings.OPERATION_ERROR)
		end
	end
end

--@brief 	获取今日任务列表数据
function WndMysteriousShop:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == self.m_nActivityId then
		if taskGroup == 1 then
			self.m_tM2TasksData = {}
			for i=1,#id do
				local task = {}
				task.id = id[i]
				task.status = status[i]
				task.target = target[i]
				task.progress = progress[i]
				task.progressCount = progressCount[i]
				task.activityId = activityId
				table.insert(self.m_tM2TasksData, task)
			end
			self:sortM2TasksData()
			self:updateUIM2T1()
		elseif taskGroup == 2 then
			self.m_tM2SpecialTaskData = {}
			self.m_tM2SpecialTaskData.id = id[1]
			self.m_tM2SpecialTaskData.status = status[1]
			self.m_tM2SpecialTaskData.target = target[1]
			self.m_tM2SpecialTaskData.progress = progress[1]
			self.m_tM2SpecialTaskData.progressCount = progressCount[1]
			self:updateUIM2T2()
		end
	end
end

--@brief 	排序今日任务列表数据
function WndMysteriousShop:sortM2TasksData()
	table.sort(self.m_tM2TasksData, function (a,b)
		local tStatusSort = {[0]=1,[-1]=2,[1]=3}
		if tStatusSort[a.status] ~= tStatusSort[b.status] then
			return tStatusSort[a.status] < tStatusSort[b.status]
		else
			return a.id < b.id
		end
	end)
end

--@brief 	今日任务奖励
function WndMysteriousShop:_onGetTaskResult(activityId, id)
	WZLog("WndMysteriousShop:_onGetTaskResult", activityId, id)
	if self.m_nActivityId ~= activityId then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	
	local taskData = GDatatab_new_activity_task["id_" .. id]

	for i=1,#self.m_tM2TasksData do
		if self.m_tM2TasksData[i].id == id then
			self.m_tM2TasksData[i].status = 1
			break
		end
	end
	self:sortM2TasksData()
	for i=1,#self.m_tM2TasksObj do
		self.m_tM2TasksObj[i]:setData(self.m_tM2TasksData[i])
	end

	if self.m_tM2SpecialTaskData.id == id then
		self.m_tM2SpecialTaskData.status = 1
		self:updateSpecialTaskStatus()
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndMysteriousShop:updatePlayerItemData()
	WZLog("WndMysteriousShop:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateCoinNum()
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------神秘商店Begin----------------------------------------

CellMysteriousShop1 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellMysteriousShop1:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil					--数据
	self.m_bIsLoaded = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMysteriousShop1:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMysteriousShop1:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMysteriousShop1 table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellMysteriousShop1")
	element:setAbsContentSize(GlobalMethod:CCSize(276,222))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMysteriousShop1:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMysteriousShop1:setData(tData)
	self.m_tData = tData
	self:updateUI()
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMysteriousShop1:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMysteriousShop1:onExit(element)
	self:_unInit()
end

--@brief 	加载
function CellMysteriousShop1:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellMysteriousShop1")
	self.m_root:addChild(celElement)
	celElement:setVisible(true)
	self.m_bIsLoaded = true

	self:_initStaticText()
	self:updateUI()

	AdaptLanguage(self)
end

--@brief	初始化静态文本
function CellMysteriousShop1:_initStaticText()
	GetElement(self.m_root,"txtB1_CellMysteriousShop1",WZUILabelTTF):setText(LocalStrings.PEOPLE_SHOP_TEXT9)
	GetElement(self.m_root,"txtB2_CellMysteriousShop1",WZUILabelTTF):setText(LocalStrings.BUY)
end

--@brief	刷新界面
function CellMysteriousShop1:updateUI()
	if self.m_bIsLoaded ~= true then
		return
	end

	local itemInfo = GDatatab_item["id_"..self.m_tData.itemId]
	GetElement(self.m_root,"txtName_CellMysteriousShop1",WZUILabelTTF):setText(itemInfo.name)
	
	local conItem = GetElement(self.m_root,"conItem_CellMysteriousShop1",WZUIContainer)
	conItem:removeAllChildrenWithCleanup(true)
	local celElement, tNewObj = CellGoodItem:createElement()
	tNewObj:setCellGoodLocalId(self.m_tData.itemId, self.m_tData.itemNum, 15)
	if self.m_tData.itemNum == -1 then
		tNewObj:_addSidebarTime(self.m_tData.itemNum)
	end
	tNewObj:setItemClickFun(self,self.onClickItem)
	conItem:addChild(celElement)

	GetElement(self.m_root,"txtItemNum_CellMysteriousShop1",WZUILabelTTF):setText(math.abs(self.m_tData.itemNum))

	local itemInfo = GDatatab_item["id_"..self.m_tData.costId]
	GetElement(self.m_root,"imgPrice_CellMysteriousShop1",WZUIImage):setFile(itemInfo.icon)

	GetElement(self.m_root,"txtPriceWord_CellMysteriousShop1",WZUILabelTTF):setText(LocalStrings.DIGGEM_TEXT18..":")
	GetElement(self.m_root,"txtPrice_CellMysteriousShop1",WZUILabelTTF):setText(self.m_tData.discountPrice)

	local txtLimit = GetElement(self.m_root,"txtLimit_CellMysteriousShop1",WZUILabelTTF)
	txtLimit:setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[11]..":"..(self.m_tData.limitNum - self.m_tData.soldNum).."/"..self.m_tData.limitNum)

	local txtDiscount = GetElement(self.m_root,"txtDiscount_CellMysteriousShop1",WZUILabelTTF)
	local strContent = string.format("%d", (self.m_tData.discountPrice/self.m_tData.price*100))
	txtDiscount:setText(string.format(LocalStrings.MYSTERIOUS_SHOP_TEXT1[12], strContent))

	--购物车数量
	local conB1RedDot = GetElement(self.m_root,"conB1RedDot_CellMysteriousShop1",WZUIContainer)
	local txtB1RDNum = GetElement(self.m_root,"txtB1RDNum_CellMysteriousShop1",WZUILabelTTF)
	conB1RedDot:setVisible(false)
	txtB1RDNum:setText("")
	if self.m_tData.shopCartNum > 0 then
		conB1RedDot:setVisible(true)
		txtB1RDNum:setText(self.m_tData.shopCartNum)
	end
end

--@brief 	设置按钮回调
function CellMysteriousShop1:setCallback(tCell, func)
	self.m_tCallBackFun = {}
	self.m_tCallBackFun[1] = tCell
	self.m_tCallBackFun[2] = func
end

--@brief	点击物品弹出对应的tips
function CellMysteriousShop1:onClickItem(tCell,tag,tData)
	if tData == nil then
	   return
	end
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,WndMysteriousShop.m_root,1,tData,false)
end

--@brief	点击"加入购物车"
function CellMysteriousShop1:onClickAdd(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nLeftCount = self.m_tData.limitNum - self.m_tData.soldNum - self.m_tData.shopCartNum
	if nLeftCount == 1 then
		self:sendProtocolDoType3(1)
	elseif nLeftCount > 1 then
		local wndOpenChest = WndOpenChest:createElement()
		WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
		local tOther = {}
		tOther.maxNum = nLeftCount
		tOther.title = LocalStrings.PEOPLE_SHOP_TEXT9
		tOther.btnText = LocalStrings.CONFIRM
		WndOpenChest:setMysteriousShopData(self.m_tData, tOther)
		WndOpenChest:setCallback(self, self.onAddShoppingCart)
	else
		MsgBoxManager:showTipBox(LocalStrings.MYSTERIOUS_SHOP_TEXT1[24])
	end
end

--@brief	点击"购买"
function CellMysteriousShop1:onClickBuy(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nLeftCount = self.m_tData.limitNum - self.m_tData.soldNum - self.m_tData.shopCartNum
	if nLeftCount == 1 then
		self:sendProtocolDoType3Two(1)
	elseif nLeftCount > 1 then
		local wndOpenChest = WndOpenChest:createElement()
		WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
		local tOther = {}
		tOther.maxNum = nLeftCount
		tOther.title = LocalStrings.PEOPLE_SHOP_TEXT9
		tOther.btnText = LocalStrings.CONFIRM
		WndOpenChest:setMysteriousShopData(self.m_tData, tOther)
		WndOpenChest:setCallback(self, self.onAddShoppingCart2)
	else
		MsgBoxManager:showTipBox(LocalStrings.MYSTERIOUS_SHOP_TEXT1[24])
	end
end

--@brief	确定"加入购物车"数量后回调
function CellMysteriousShop1:onAddShoppingCart(num)
	self:sendProtocolDoType3(num)
end

--@brief	发送协议 dotype=3
function CellMysteriousShop1:sendProtocolDoType3(num)
	WndMysteriousShop:saveM1ConPt()

	local tData = {}
	tData.id = self.m_tData.id
	tData.num = num
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tData.activityId, 3, strJson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tData.activityId, 4, "") --用来计算购物车数量
end

--@brief	确定"购买"数量后回调
function CellMysteriousShop1:onAddShoppingCart2(num)
	self:sendProtocolDoType3Two(num)
end

--@brief	发送协议 dotype=3
function CellMysteriousShop1:sendProtocolDoType3Two(num)
	local tData = {}
	tData.id = self.m_tData.id
	tData.num = num
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tData.activityId, 3, strJson)

	WndMysteriousShop:onClickTitle(4)
end


--@brief	语言适配
function CellMysteriousShop1:_adaptLanguage_vn()
	local txtDiscount = GetElement(self.m_root,"txtDiscount_CellMysteriousShop1",WZUILabelTTF)
	txtDiscount:setScale(0.6)
	txtDiscount:setDimensions(GlobalMethod:CCSize(80,0))

	GetElement(self.m_root,"txtName_CellMysteriousShop1",WZUILabelTTF):setFontSize(18)

	GetElement(self.m_root,"txtB1_CellMysteriousShop1",WZUILabelTTF):setScale(0.8)
end

-------------------------------------神秘商店End----------------------------------------


-------------------------------------今日任务Begin----------------------------------------

CellMysteriousShop2 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellMysteriousShop2:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil					--数据
	self.m_bIsLoaded = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMysteriousShop2:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMysteriousShop2:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMysteriousShop2 table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellMysteriousShop2")
	element:setAbsContentSize(GlobalMethod:CCSize(806,100))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMysteriousShop2:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMysteriousShop2:setData(tData)
	self.m_tData = tData
	self:updateUI()
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMysteriousShop2:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMysteriousShop2:onExit(element)
	self:_unInit()
end

--@brief 	加载
function CellMysteriousShop2:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellMysteriousShop2")
	self.m_root:addChild(celElement)
	celElement:setVisible(true)
	self.m_bIsLoaded = true

	self:_initStaticText()
	self:updateUI()

	AdaptLanguage(self)
end

--@brief	初始化静态文本
function CellMysteriousShop2:_initStaticText()
	GetElement(self.m_root,"txtGet_CellMysteriousShop2",WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GET)
	GetElement(self.m_root,"txtGoto_CellMysteriousShop2",WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GO)
end

--@brief	刷新界面
function CellMysteriousShop2:updateUI()
	if self.m_bIsLoaded ~= true then
		return
	end

	local taskData = GDatatab_new_activity_task["id_" .. self.m_tData.id]

	local ftbTaskName = GetElement(self.m_root,"ftbTaskName_CellMysteriousShop2",WZUIFreeTextBox)
	ftbTaskName:setShowText(taskData.desc)

	local txtTaskProg = GetElement(self.m_root,"txtTaskProg_CellMysteriousShop2",WZUILabelTTF)
	txtTaskProg:setText(self.m_tData.progress.."/"..self.m_tData.target)

	local progTask = GetElement(self.m_root,"progTask_CellMysteriousShop2",WZUIProgress)
	progTask:setPercentage(self.m_tData.progress / self.m_tData.target * 100)

	for i=1,4 do
		local conItem = GetElement(self.m_root,"conItem"..i.."_CellMysteriousShop2",WZUIContainer)
		conItem:setVisible(false)
		local conRewardItem = GetElement(conItem,"conRewardItem_CellMysteriousShop2",WZUIContainer)
		conRewardItem:removeAllChildrenWithCleanup(true)
		local txtItemNum = GetElement(conItem,"txtItemNum_CellMysteriousShop2",WZUILabelTTF)
		txtItemNum:setText("")
		if taskData.reward[i] then
			conItem:setVisible(true)

			local celElement,tNewObj = CellGoodItem:createElement()
			celElement:setTag(i - 1)
			tNewObj:setCellGoodLocalId(taskData.reward[i][1], taskData.reward[i][2], 15)
			tNewObj:setItemClickFun(self, self.onClickItem)
			conRewardItem:addChild(WZUIContainer:luaTo(celElement))

			txtItemNum:setText(taskData.reward[i][2])
		end
	end

	local btnGoto = GetElement(self.m_root,"btnGoto_CellMysteriousShop2",WZUIButton)
	local btnGet = GetElement(self.m_root,"btnGet_CellMysteriousShop2",WZUIButton)
	local imgReceived = GetElement(self.m_root,"imgReceived_CellMysteriousShop2",WZUIImage)
	if self.m_tData.status == -1 then
		btnGoto:setVisible(true)
		btnGet:setVisible(false)
		imgReceived:setVisible(false)
	elseif self.m_tData.status == 0 then
		btnGoto:setVisible(false)
		btnGet:setVisible(true)
		imgReceived:setVisible(false)
	elseif self.m_tData.status == 1 then
		btnGoto:setVisible(false)
		btnGet:setVisible(false)
		imgReceived:setVisible(true)
	end
end

--@brief 	设置按钮回调
function CellMysteriousShop2:setCallback(tCell, func)
	self.m_tCallBackFun = {}
	self.m_tCallBackFun[1] = tCell
	self.m_tCallBackFun[2] = func
end

--@brief	点击物品弹出对应的tips
function CellMysteriousShop2:onClickItem(tCell,tag,tData)
	if tData == nil then
	   return
	end
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,WndMysteriousShop.m_root,1,tData,false)
end

--@brief	点击"前往"
function CellMysteriousShop2:onClickGoto(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local data = GDatatab_new_activity_task["id_" .. self.m_tData.id]
	if data and data.script and type(data.script) == "table" and data.script[1][1] > 0 then 
		local mainId = data.script[1][1]
		if mainId == 27 then --公会
			SceneCommunity:onJumpToCommunity()
		elseif mainId == 192 and CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().guildId == 0 then --公会副本
			SceneCommunity:onJumpToCommunity()
		elseif mainId > 0 then
			JumpByUIId(mainId)
		end
		WindowManager:removeWindow(WndMysteriousShop.m_root, WndMysteriousShop, true)
	end
end

--@brief	点击"领取"
function CellMysteriousShop2:onClickGet(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndMysteriousShop:saveM2ConPt()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tData.activityId, self.m_tData.id)
end


--@brief	语言适配
function CellMysteriousShop2:_adaptLanguage_vn()
	GetElement(self.m_root,"ftbTaskName_CellMysteriousShop2",WZUIFreeTextBox):setMaxWidth(290)
end

-------------------------------------今日任务End----------------------------------------


-------------------------------------全服秒杀Begin----------------------------------------

CellMysteriousShop3 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellMysteriousShop3:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil					--数据
	self.m_bIsLoaded = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMysteriousShop3:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMysteriousShop3:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMysteriousShop3 table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellMysteriousShop3")
	element:setAbsContentSize(GlobalMethod:CCSize(276,222))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMysteriousShop3:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMysteriousShop3:setData(tData)
	self.m_tData = tData
	self:updateUI()
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMysteriousShop3:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMysteriousShop3:onExit(element)
	self:_unInit()
end

--@brief 	加载
function CellMysteriousShop3:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellMysteriousShop3")
	self.m_root:addChild(celElement)
	celElement:setVisible(true)
	self.m_bIsLoaded = true

	self:_initStaticText()
	self:updateUI()

	AdaptLanguage(self)
end

--@brief	初始化静态文本
function CellMysteriousShop3:_initStaticText()
end

--@brief	刷新界面
function CellMysteriousShop3:updateUI()
	if self.m_bIsLoaded ~= true then
		return
	end

	local itemInfo = GDatatab_item["id_"..self.m_tData.itemId]
	GetElement(self.m_root,"txtName_CellMysteriousShop3",WZUILabelTTF):setText(itemInfo.name)
	
	local conItem = GetElement(self.m_root,"conItem_CellMysteriousShop3",WZUIContainer)
	conItem:removeAllChildrenWithCleanup(true)
	local celElement, tNewObj = CellGoodItem:createElement()
	tNewObj:setCellGoodLocalId(self.m_tData.itemId, self.m_tData.itemNum, 15)
	if self.m_tData.itemNum == -1 then
		tNewObj:_addSidebarTime(self.m_tData.itemNum)
	end
	tNewObj:setItemClickFun(self,self.onClickItem)
	conItem:addChild(celElement)

	GetElement(self.m_root,"txtItemNum_CellMysteriousShop3",WZUILabelTTF):setText(math.abs(self.m_tData.itemNum))

	local itemInfo = GDatatab_item["id_"..self.m_tData.costId]
	GetElement(self.m_root,"imgPrice_CellMysteriousShop3",WZUIImage):setFile(itemInfo.icon)

	local txtPrice = GetElement(self.m_root,"txtPrice_CellMysteriousShop3",WZUILabelTTF)
	txtPrice:setText(LocalStrings.DIGGEM_TEXT18..":"..self.m_tData.discountPrice)

	local txtLimit = GetElement(self.m_root,"txtLimit_CellMysteriousShop3",WZUILabelTTF)
	txtLimit:setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[11]..":"..(self.m_tData.playerDailyLimit - self.m_tData.playerDailyBuyNum).."/"..self.m_tData.playerDailyLimit)

	local txtLeftNum = GetElement(self.m_root,"txtLeftNum_CellMysteriousShop3",WZUILabelTTF)
	txtLeftNum:setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[17]..":"..(self.m_tData.globalDailyLimit - self.m_tData.globalDailyBuyNum))

	local txtDiscount = GetElement(self.m_root,"txtDiscount_CellMysteriousShop3",WZUILabelTTF)
	local strContent = string.format("%d", (self.m_tData.discountPrice/self.m_tData.price*100))
	txtDiscount:setText(string.format(LocalStrings.MYSTERIOUS_SHOP_TEXT1[12], strContent))

	local btnB2 = GetElement(self.m_root,"btnB2_CellMysteriousShop3",WZUIButton)
	local imgB2 = GetElement(self.m_root,"imgB2_CellMysteriousShop3",WZUI9Image)
	local txtB2 = GetElement(self.m_root,"txtB2_CellMysteriousShop3",WZUILabelTTF)
	if self.m_tData.globalDailyLimit <= self.m_tData.globalDailyBuyNum then --全局数量不足
		btnB2:setTouchEnable(false)
		imgB2:setGrayRender(true)
		txtB2:setColor(GlobalMethod:ccc3(255,255,255))
		txtB2:setStrokeColor(GlobalMethod:ccc3(79,60,48))
		txtB2:setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[18])
	elseif self.m_tData.playerDailyLimit <= self.m_tData.playerDailyBuyNum then --个人数量不足
		btnB2:setTouchEnable(false)
		imgB2:setGrayRender(true)
		txtB2:setColor(GlobalMethod:ccc3(255,255,255))
		txtB2:setStrokeColor(GlobalMethod:ccc3(79,60,48))
		txtB2:setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[19])
	else
		btnB2:setTouchEnable(true)
		imgB2:setGrayRender(false)
		txtB2:setColor(GlobalMethod:ccc3(255,250,236))
		txtB2:setStrokeColor(GlobalMethod:ccc3(0,108,3))
		txtB2:setText(LocalStrings.MYSTERIOUS_SHOP_TEXT1[19])
	end
end

--@brief 	设置按钮回调
function CellMysteriousShop3:setCallback(tCell, func)
	self.m_tCallBackFun = {}
	self.m_tCallBackFun[1] = tCell
	self.m_tCallBackFun[2] = func
end

--@brief	点击物品弹出对应的tips
function CellMysteriousShop3:onClickItem(tCell,tag,tData)
	if tData == nil then
	   return
	end
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,WndMysteriousShop.m_root,1,tData,false)
end

--@brief	点击物品弹出对应的tips
function CellMysteriousShop3:onClickBuy(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--时间未到
	local currentTimeStamp = SystemTime:getServerTime() --现在时间戳
	if currentTimeStamp < WndMysteriousShop.m_nSecKillTime then
		MsgBoxManager:showTipBox(LocalStrings.MYSTERIOUS_SHOP_TEXT1[20])
		return
	end

	--货币不足
	local costNum = CacheCenter:getPlayerItemCountById(self.m_tData.costId)
	if costNum < self.m_tData.discountPrice then
		local itemInfo = GDatatab_item["id_" .. self.m_tData.costId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, itemInfo.name), self, self.goToBuy)
		return
	end

	MsgBoxManager:showConfirmCancelBox(LocalStrings.MYSTERIOUS_SHOP_TEXT1[26], self, self.sureBuyCallBack)
end

--@brief 	前往小推车购买
function CellMysteriousShop3:goToBuy(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		WndActivityPropsGift:showInterface(self.m_tData.costId)
	end
end

--@brief	提示充值框的回调
--@param	nId:消息id
--@param	nResType:响应类型(超时，确定，取消)
function CellMysteriousShop3:sureBuyCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
		WndMysteriousShop:saveM3ConPt()

		local tData = {}
		tData.goodsId = self.m_tData.id
		tData.num = 1
		local strJson = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tData.activityId, 9, strJson)
    end
end


--@brief	语言适配
function CellMysteriousShop3:_adaptLanguage_vn()
	local txtDiscount = GetElement(self.m_root,"txtDiscount_CellMysteriousShop3",WZUILabelTTF)
	txtDiscount:setScale(0.6)
	txtDiscount:setDimensions(GlobalMethod:CCSize(80,0))

	GetElement(self.m_root,"txtLeftNum_CellMysteriousShop3",WZUILabelTTF):setFontSize(12)
end

-------------------------------------全服秒杀End----------------------------------------


-------------------------------------今日任务Begin----------------------------------------

CellMysteriousShop4 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellMysteriousShop4:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil					--数据
	self.m_bIsLoaded = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMysteriousShop4:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMysteriousShop4:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMysteriousShop4 table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellMysteriousShop4")
	element:setAbsContentSize(GlobalMethod:CCSize(778,100))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMysteriousShop4:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMysteriousShop4:setData(tData)
	self.m_tData = tData
	self:updateUI()
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMysteriousShop4:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMysteriousShop4:onExit(element)
	self:_unInit()
end

--@brief 	加载
function CellMysteriousShop4:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellMysteriousShop4")
	self.m_root:addChild(celElement)
	celElement:setVisible(true)
	self.m_bIsLoaded = true

	self:_initStaticText()
	self:updateUI()

	AdaptLanguage(self)
end

--@brief	初始化静态文本
function CellMysteriousShop4:_initStaticText()
	GetElement(self.m_root,"txtDelete_cellM4Tasks",WZUILabelTTF):setText(LocalStrings.POPUPMENUSTRING4)
end

--@brief	刷新界面
function CellMysteriousShop4:updateUI()
	if self.m_bIsLoaded ~= true then
		return
	end

	GetElement(self.m_root,"checkItem_cellM4Tasks",WZUICheckBox):setCheckIndex(self.m_tData.option)

	local conItem = GetElement(self.m_root,"conItem_cellM4Tasks",WZUIContainer)
	conItem:removeAllChildrenWithCleanup(true)
	local newElement,tNewObj = CellGoodItem:createElement()
	newElement = WZUIContainer:luaTo(newElement)
	tNewObj:setCellGoodLocalId(self.m_tData.itemId, self.m_tData.itemNum, 15)
	if self.m_tData.itemNum == -1 then
		tNewObj:_addSidebarTime(self.m_tData.itemNum)
	end
	tNewObj:setItemClickFun(self, self.onClickItem)
	conItem:addChild(newElement)

	GetElement(self.m_root,"txtItemNum_CellMysteriousShop4",WZUILabelTTF):setText(math.abs(self.m_tData.itemNum))

	local itemInfo = GDatatab_item["id_"..self.m_tData.itemId]
	GetElement(self.m_root,"txtItemName_cellM4Tasks",WZUILabelTTF):setText(itemInfo.name)

	local itemInfo = GDatatab_item["id_"..self.m_tData.costId]
	GetElement(self.m_root,"imgCost_CellMysteriousShop4",WZUIImage):setFile(itemInfo.icon)
	
	GetElement(self.m_root,"txtOriginalPrice_CellMysteriousShop4",WZUILabelTTF):setText(self.m_tData.discountPrice)

	--订单数
	local txtOrderNum = GetElement(self.m_root,"txtOrderNum_cellM4Tasks",WZUILabelTTF)
	txtOrderNum:setText("")
	if self.m_tData.shopCartNum > 1 then
		txtOrderNum:setText("*"..self.m_tData.shopCartNum)
	end

	local imgLine = GetElement(self.m_root,"imgLine_CellMysteriousShop4",WZUIImage)
	imgLine:setVisible(false)
	local txtDiscountPrice = GetElement(self.m_root,"txtDiscountPrice_CellMysteriousShop4",WZUILabelTTF)
	txtDiscountPrice:setText("")
	if self.m_tData.discountItem ~= 0 then
		imgLine:setVisible(true)

		local itemInfo = GDatatab_item["id_"..self.m_tData.discountItem]
		local tempPrice = math.floor(self.m_tData.discountPrice / 100 * itemInfo.property[1][2])
		txtDiscountPrice:setText(tempPrice)
	end

	local btnCoupon = GetElement(self.m_root,"btnCoupon_cellM4Tasks",WZUIButton)
	btnCoupon:setVisible(self.m_tData.staking == 1)

	local strFormat = [[<T C="255,255,255" S="20" P="1">%s</T>]]
	local strContent = string.format(strFormat, LocalStrings.MYSTERIOUS_SHOP_TEXT1[22])
	if self.m_tData.discountItem ~= 0 then
		local itemInfo = GDatatab_item["id_"..self.m_tData.discountItem]
		strFormat = [[<I Z="0.5">%s</I><T C="255,255,255" S="20" P="1">%s</T>]]
		strContent = string.format(strFormat, itemInfo.icon, itemInfo.name)
	end
	local ftbCoupon = GetElement(self.m_root,"ftbCoupon_cellM4Tasks",WZUIFreeTextBox)
	ftbCoupon:setShowText(strContent)

	--调整价格框
	local txtOriginalPrice = GetElement(self.m_root,"txtOriginalPrice_CellMysteriousShop4",WZUILabelTTF)
	local txtDiscountPrice = GetElement(self.m_root,"txtDiscountPrice_CellMysteriousShop4",WZUILabelTTF)
	local nFontWidth = 13 --单个字宽度
	local size1 = txtOriginalPrice:getLabelContentSize()
	local size2 = txtDiscountPrice:getLabelContentSize()

	local width = size1.width
	local height = 4
	local conM4Line = GetElement(self.m_root,"conM4Line_CellMysteriousShop4",WZUIContainer)
	conM4Line:setAbsContentSize(CCSize(width, height))
	conM4Line:updateRelativeSize()

	local originX = 100
	local originY = 15
	local offsetX = math.max(0, size1.width - nFontWidth * 3)
	txtDiscountPrice:setAbsPosition(ccp(originX + offsetX, originY))

	local width = 150
	local height = 30
	local deltaWidth = math.max(0, size1.width + size2.width - nFontWidth * 3 * 2)
	local conM4Cost = GetElement(self.m_root,"conM4Cost_CellMysteriousShop4",WZUIContainer)
	conM4Cost:setAbsContentSize(CCSize(width + deltaWidth, height))
	conM4Cost:updateRelativeSize()
end

--@brief 	设置按钮回调
function CellMysteriousShop4:setCallback(tCell, func)
	self.m_tCallBackFun = {}
	self.m_tCallBackFun[1] = tCell
	self.m_tCallBackFun[2] = func
end

--@brief 	设置按钮回调
function CellMysteriousShop4:setCouponCallback(tCell, func)
	self.m_tCouponCallBackFun = {}
	self.m_tCouponCallBackFun[1] = tCell
	self.m_tCouponCallBackFun[2] = func
end

--@brief	点击物品弹出对应的tips
function CellMysteriousShop4:onClickItem(tCell,tag,tData)
	if tData == nil then
	   return
	end
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,WndMysteriousShop.m_root,1,tData,false)
end

--@brief	点击勾选
function CellMysteriousShop4:onClickCheck(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndMysteriousShop:saveM4ConPt()

	local checkItem = GetElement(self.m_root,"checkItem_cellM4Tasks",WZUICheckBox)
	local nIndex = checkItem:getCheckIndex()

	local tData = {}
	tData.orderId = {self.m_tData.orderId}
	tData.option = nIndex
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tData.activityId, 7, strJson)
end

--@brief	点击折扣券列表
function CellMysteriousShop4:onClickCoupon(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = self.m_root:getTag()
	self.m_tCouponCallBackFun[2](self.m_tCouponCallBackFun[1], tag)
end

--@brief	点击删除
function CellMysteriousShop4:onClickDelete(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = {}
	tData.orderId = self.m_tData.orderId
	tData.num = self.m_tData.shopCartNum
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tData.activityId, 5, strJson)
end


--@brief	语言适配
function CellMysteriousShop4:_adaptLanguage_vn()
	GetElement(self.m_root,"ftbCoupon_cellM4Tasks",WZUIFreeTextBox):setScale(0.7)
end

-------------------------------------今日任务End----------------------------------------
