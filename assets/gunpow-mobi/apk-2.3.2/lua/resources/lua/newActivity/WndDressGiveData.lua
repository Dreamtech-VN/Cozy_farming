--WndDressGiveData.lua
--@brief	WndDressGive的数据模块
--@date		2022/08/16
--@author	XTX
--@note		时装惠送活动

WndDressGive = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDressGive:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_bOpenState = false 
	self.m_tData = nil 					--列表数据
	self.m_nLoginDays = 0 
	self.m_nLoginDaysLimit = 5 
	self.m_tCellItem = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDressGive:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_bOpenState = nil  
	self.m_tData = nil 
	self.m_nLoginDays = nil  
	self.m_nLoginDaysLimit = nil  
	self.m_tCellItem = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDressGive:createElement()
	if WndDressGive.m_root ~= nil then
		WindowManager:removeWindow(WndDressGive.m_root, WndDressGive, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDressGive")
	assert(element, "WndDressGive create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndDressGive:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndDressGive:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndDressGive, false)
	end
end

--@brief 	获取活动详情成功
function WndDressGive:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndDressGive:GetActivityInfoOK", g_cityExtenInfo.activity7056, activityId, content)
	if g_cityExtenInfo.activity7056 == activityId then 
		self.m_tContent = json.decode(content)
		WZLog("WndDressGive:GetActivityInfoOK", count, maxCount, rewardItemsParamCount[1], Serialize(finishCondition), Serialize(self.m_tContent))
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nLoginDays = count 
		self.m_nLoginDaysLimit = maxCount 

		self:_analyzeActivityData(status, rewardId, rewardItemsParamCount, finishCondition)
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndDressGive:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 2 then --预购成功
		local tResult = json.decode(jsonData)
		WZLog("WndDressGive:_onGetOtherData 22", Serialize(tResult))
		if result == 1 then 
			WndDressGive:gotoBuy(tResult.rechargeId)
		end
	elseif doType == 5 then --累登奖励
		local tResult = json.decode(jsonData)
		WZLog("WndDressGive:_onGetOtherData 55", Serialize(tResult))
		if result == 1 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			self.m_tData[1].LoginRewardState = 2 
			self.m_tCellItem[1]:updateData(self.m_tData[1])
		end
	elseif doType == 6 then --额外奖励
		local tResult = json.decode(jsonData)
		WZLog("WndDressGive:_onGetOtherData 66", Serialize(tResult))
		if result == 1 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			self.m_tData[tResult.giftId + 1].extraRewardState = 0 
			self.m_tCellItem[tResult.giftId + 1]:updateData(self.m_tData[tResult.giftId + 1])
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	解析活动数据
function WndDressGive:_analyzeActivityData(status, rewardId, rewardItemsParamCount, finishCondition)
	-- body
	self.m_tData = {}

	local nSex = CacheCenter:getPlayerInfo().sex
	local nCount = #self.m_tContent.giftReward
	for i = 1, nCount do
		local tItem = {}
		local ids, nums = SplitItemString(self.m_tContent.giftReward[i], nSex)
		tItem.id = i - 1
		tItem.gift = {}
		for j = 1, #ids do
			local tItemTemp = {}
			tItemTemp[1] = ids[j]
			tItemTemp[2] = nums[j]

			table.insert(tItem.gift, tItemTemp)
		end
		ids, nums = SplitItemString(self.m_tContent.extReward[i])
		tItem.extraReward = {}
		for j = 1, #ids do
			local tItemTemp = {}
			tItemTemp[1] = ids[j]
			tItemTemp[2] = nums[j]

			table.insert(tItem.extraReward, tItemTemp)
		end
		local rechargeId = nil 
		local _string = string.sub(self.m_tContent.recharge[i + 1], 2, -2) 
		local _type = tonumber(SplitStringWithSeparator(_string, ",")[1])
		local _sort = tonumber(SplitStringWithSeparator(_string, ",")[2])
		for j,v in pairs(GDatatab_recharge) do
			if v.type == _type and v.sort == _sort then
				rechargeId = v.id
				break
			end
		end
		tItem.dayBuy = status[i]
		tItem.totalBuy = finishCondition[i]
		tItem.rechargeId = rechargeId
		if i == 1 then 
			_string = string.sub(self.m_tContent.recharge[1], 2, -2) 
			_type = tonumber(SplitStringWithSeparator(_string, ",")[1])
			_sort = tonumber(SplitStringWithSeparator(_string, ",")[2])
			for j, v in pairs(GDatatab_recharge) do
				if v.type == _type and v.sort == _sort then
					tItem.rechargeId2 = v.id
					break
				end
			end
			tItem.LoginRewardState = rewardItemsParamCount[1] 
			tItem.discountBuyTimes = finishCondition[nCount + 1]
		end

		_string = string.sub(self.m_tContent.buyLimit[i], 2, -2) 
		tItem.dayLimit = tonumber(SplitStringWithSeparator(_string, ",")[1])
		tItem.totalLimit = tonumber(SplitStringWithSeparator(_string, ",")[2])
		tItem.extraRewardState = rewardId[i] 

		table.insert(self.m_tData, tItem)
	end
end

--@brief 	下订单
function WndDressGive:gotoBuy(rechargeId)
	--购买
	local sdkData = {}
    local vipData = GDatatab_recharge["id_" .. rechargeId]
    WZLog("WndDressGive:gotoBuy:")
    sdkData.id = rechargeId
    sdkData.price = vipData.price
    sdkData.productName = tostring(vipData.name)
    sdkData.payCode = GetPayCodeIdByChannelId(vipData)
    sdkData.quantifier = LocalStrings.SHOP_IND
    sdkData.number = "1"
    sdkData.giftNumber = "0"
    sdkData.productDesc = tostring(vipData.name)

    PassportSdkManager:getOrderNum(sdkData)
end


-------------------------------------私有方法模块End----------------------------------------
CellDressGiveItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellDressGiveItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_bIsLoaded = false
	self.m_nIndex = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDressGiveItem:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil 
	self.m_nIndex = nil 
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellDressGiveItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellDressGiveItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellDressGiveItem")
	element:setAbsContentSize(GlobalMethod:CCSize(630,124))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	 设置数据
function CellDressGiveItem:setData(tData, nIndex)
	-- body
	self.m_tData = tData
	self.m_nIndex = nIndex
end

--@brief 	刷新数据
function CellDressGiveItem:updateData(tData)
	self.m_tData = tData
	if self.m_bIsLoaded == false then return end 

	self:_update()
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellDressGiveItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDressGiveItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDressGiveItem:onExit(element)
	self:_unInit()
end

--@brief 加载
function CellDressGiveItem:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellDressGiveItem")
	celElement:setVisible(true)
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true 
    self:_update()

    AdaptLanguage(self)
end

--@brief 	点击额外宝箱
function CellDressGiveItem:onClickExtraReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tData.extraRewardState > 0 then 
		local tData = {}
		tData.giftId = self.m_nIndex - 1
		local strJson = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(WndDressGive.m_nActivityId, 6, strJson)
	else
		local data = {}
		data.cur_value = 0
		data.totle_value = 1
		data.winType = 1
		data.rewardIds = {}
		data.rewardNums = {}
		for i = 1, #self.m_tData.extraReward do
			table.insert(data.rewardIds, self.m_tData.extraReward[i][1])
			table.insert(data.rewardNums, self.m_tData.extraReward[i][2])
		end
		WndNewTipsReward:showInterface(WndDressGive.m_root, element, data, true)
	end
end

--@brief 	点击下拉按钮回调
function CellDressGiveItem:onClickBuy(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nIndex == 1 and self.m_tData.LoginRewardState == 1 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(WndDressGive.m_nActivityId, 5, "")
		return 
	end
	
	local tData = {}
	tData.giftId = self.m_nIndex - 1
	local rechargeId = self.m_tData.rechargeId
	if self.m_nIndex == 1 then 
		if self.m_tData.LoginRewardState == 2 and self.m_tData.discountBuyTimes == 0 then 
			rechargeId = self.m_tData.rechargeId2
		end
	end
	tData.rechargeId = rechargeId

	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(WndDressGive.m_nActivityId, 2, strJson)
end

--@brief    刷新
function CellDressGiveItem:_update()
	WZLog("CellDressGiveItem:_update")
	--body
	local txtGiveAtt = GetElement(self.m_root, "txtGiveAtt_CellDressGive", WZUILabelTTF)
	if txtGiveAtt then 
		if self.m_nIndex == 1 then 
			txtGiveAtt:setText(string.format(LocalStrings.DRESSGIVE_TEXT1[3], WndDressGive.m_nLoginDaysLimit, WndDressGive.m_nLoginDays, WndDressGive.m_nLoginDaysLimit))
		else
			txtGiveAtt:setText("")
		end
	end
	local txtExtraAtt = GetElement(self.m_root, "txtExtraAtt_CellDressGive", WZUILabelTTF)
	if txtExtraAtt then 
		txtExtraAtt:setText(LocalStrings.DRESSGIVE_TEXT1[2])
	end
	local imgState = GetElement(self.m_root, "imgState_CellDressGiveItem", WZUIImage)
	local imgRedDot = GetElement(self.m_root, "imgRedDot_CellDressGiveItem", WZUIImage)
	local txtExtralNum = GetElement(self.m_root, "txtExtralNum_CellDressGiveItem", WZUILabelTTF)
	if self.m_tData.extraRewardState > 0 then 
		imgState:setVisible(true)
		imgRedDot:setVisible(true)
		txtExtralNum:setText(self.m_tData.extraRewardState)
	else
		imgState:setVisible(false)
		imgRedDot:setVisible(false)
		txtExtralNum:setText("")
	end
	--限购
	local txtLimitWord = GetElement(self.m_root, "txtLimitWord_CellDressGiveItem", WZUILabelTTF)
	txtLimitWord:setText("")
	local txtBuy = GetElement(self.m_root, "txtBuy_CellDressGiveItem", WZUILabelTTF)
	local btnBuy = GetElement(self.m_root, "btnBuy_CellDressGiveItem", WZUIButton)
	local rechargeData = nil 
	local strBtnText = ""
	txtBuy:setStrokeColor(GlobalMethod:ccc3(0,108,3))
	btnBuy:setTouchEnable(true)
	if self.m_nIndex == 1 then 
		if self.m_tData.LoginRewardState == 0 then 
			rechargeData = GDatatab_recharge["id_" .. self.m_tData.rechargeId] 
			strBtnText = rechargeData.unit .. LocalStrings.BUY
			if ProjConfig.LANGUAGE == "vn" then
				strBtnText = rechargeData.unit
			end
			txtBuy:setUseSystemFont(true)
		elseif self.m_tData.LoginRewardState == 1 then 
			strBtnText = LocalStrings.INVITE_RECEIVE
		elseif self.m_tData.LoginRewardState == 2 then 
			if self.m_tData.discountBuyTimes == 0 then 
				rechargeData = GDatatab_recharge["id_" .. self.m_tData.rechargeId2] 
			else
				rechargeData = GDatatab_recharge["id_" .. self.m_tData.rechargeId] 
			end
			strBtnText = rechargeData.unit .. LocalStrings.BUY
			if ProjConfig.LANGUAGE == "vn" then
				strBtnText = rechargeData.unit
			end
			txtBuy:setUseSystemFont(true)
		end
	else
		rechargeData = GDatatab_recharge["id_" .. self.m_tData.rechargeId] 
		strBtnText = rechargeData.unit .. LocalStrings.BUY
		if ProjConfig.LANGUAGE == "vn" then
			strBtnText = rechargeData.unit
		end
		txtBuy:setUseSystemFont(true)
	end
	if self.m_tData.dayLimit > 0 then 
		txtLimitWord:setText(LocalStrings.PEOPLE_SHOP_TEXT11 .. self.m_tData.dayBuy .. "/" ..self.m_tData.dayLimit)
		if self.m_tData.dayBuy >= self.m_tData.dayLimit then 
			if self.m_tData.LoginRewardState == nil or self.m_tData.LoginRewardState ~= 1 then 
				if self.m_tData.LoginRewardState == nil or self.m_tData.LoginRewardState ~= 1 then 
					strBtnText = LocalStrings.DRESSGIVE_TEXT1[4]
					txtBuy:setStrokeColor(GlobalMethod:ccc3(79,60,48))
					btnBuy:setTouchEnable(false)
				end
			end
		end
		if self.m_tData.totalLimit > 0 and self.m_tData.totalBuy >= self.m_tData.totalLimit then 
			txtLimitWord:setText(LocalStrings.ACTIVITY_TEXT15 .. ":" .. self.m_tData.totalBuy .. "/" ..self.m_tData.totalLimit)
			if self.m_tData.LoginRewardState == nil or self.m_tData.LoginRewardState ~= 1 then 
				strBtnText = LocalStrings.DRESSGIVE_TEXT1[4]
				txtBuy:setStrokeColor(GlobalMethod:ccc3(79,60,48))
				btnBuy:setTouchEnable(false)
			end
		end
	elseif self.m_tData.totalLimit > 0 then 
		txtLimitWord:setText(LocalStrings.ACTIVITY_TEXT15 .. ":" .. self.m_tData.totalBuy .. "/" ..self.m_tData.totalLimit)
		if self.m_tData.totalBuy >= self.m_tData.totalLimit then 
			if self.m_tData.LoginRewardState == nil or self.m_tData.LoginRewardState ~= 1 then 
				strBtnText = LocalStrings.DRESSGIVE_TEXT1[4]
				txtBuy:setStrokeColor(GlobalMethod:ccc3(79,60,48))
				btnBuy:setTouchEnable(false)
			end
		end
	end
	txtBuy:setText(strBtnText)
	--奖励
	for i = 1, #self.m_tData.gift do
		local conItem = GetElement(self.m_root, "conItem" .. i .. "_CellDressGiveItem", WZUIContainer)
		if conItem:getChildByTag(9) then 
			conItem:removeChildByTag(9, true)
		end
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(tonumber(self.m_tData.gift[i][1]), tonumber(self.m_tData.gift[i][2]), 15)
			tNewObj:setItemClickFun(self, self.onItemClick)
			conItem:addChild(element)
		end
	end
end

function CellDressGiveItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    local rootTemp = WndDressGive.m_root
   	WndItemInfo:showInfo(tCell.m_root, rootTemp,1,tData,false,nil,true)
end

-------------------------------------语言适配begin----------------------------------------

function CellDressGiveItem:_adaptLanguage_vn()
	local txtGiveAtt = GetElement(self.m_root, "txtGiveAtt_CellDressGive", WZUILabelTTF)
	txtGiveAtt:setRelativePosition(GlobalMethod:ccp(0.1,0.3))
	local txtExtraAtt = GetElement(self.m_root, "txtExtraAtt_CellDressGive", WZUILabelTTF)
	txtExtraAtt:setDimensions(GlobalMethod:CCSize(80,0))
end

-------------------------------------语言适配end----------------------------------------
