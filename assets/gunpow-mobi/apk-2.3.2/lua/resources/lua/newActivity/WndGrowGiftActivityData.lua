--WndGrowGiftActivityData.lua
--@brief	WndGrowGiftActivity的数据模块
--@date		2024/08/01
--@author	yrd
--@note		成长活动

WndGrowGiftActivity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGrowGiftActivity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCheckIndex = 0 				--页签
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGrowGiftActivity:_unInit()
	self.m_root = nil
	self.m_nCheckIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGrowGiftActivity:createElement()
	if WndGrowGiftActivity.m_root ~= nil then
		WindowManager:removeWindow(WndGrowGiftActivity.m_root, WndGrowGiftActivity, true)
	end
	local element = WZUISystem:getInstance():createElement("WndGrowGiftActivity")
	assert(element, "WndGrowGiftActivity create element failed!")
	self:_init()
	return element
end

--@brief 	获取活动详情成功
function WndGrowGiftActivity:GetActivityInfoOK(activityId, maxCount, count, status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if g_cityExtenInfo.activity7134 == activityId then
		self.m_nActivityId = activityId
		-- self.m_nMaxCount = maxCount
		self.m_nCount = count
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

		local nSex = CacheCenter:getPlayerInfo().sex

		self.m_tRechargeConfig = {}
		self.m_tRechargeConfig[1] = json.decode(self.m_tContent.normalRechargeConfig)
		self.m_tRechargeConfig[2] = json.decode(self.m_tContent.superRechargeConfig)

		local normalConfig = json.decode(self.m_tContent.normalConfig)
		local normalRewards = json.decode(self.m_tContent.normalRewards)
		local superConfig = json.decode(self.m_tContent.superConfig)
		local superRewards = json.decode(self.m_tContent.superRewards)
		self.m_tRewardsData = {}
		self.m_tRewardsData[1] = {}
		for i=1,#normalConfig do
			local tData = {}
			tData.index = i
			tData.config = normalConfig[i]
			tData.rewards = {}
			local array = SplitStringWithSeparator(normalRewards[i], "&")
			for i = 1, #array do
				local strTemp = string.sub(array[i], 2, -2)
				local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])
				table.insert(tData.rewards, {id, num})
			end
			table.insert(self.m_tRewardsData[1], tData)
		end
		self.m_tRewardsData[2] = {}
		for i=1,#superConfig do
			local tData = {}
			tData.index = i
			tData.config = superConfig[i]
			tData.rewards = {}
			local array = SplitStringWithSeparator(superRewards[i], "&")
			for i = 1, #array do
				local strTemp = string.sub(array[i], 2, -2)
				local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

				table.insert(tData.rewards, {id, num})
			end
			table.insert(self.m_tRewardsData[2], tData)
		end
	end
end

--@brief 	获取其他活动数据
function WndGrowGiftActivity:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --获取达人奖、大奖限量数据
		local tResult = json.decode(jsonData)
		WZLog("WndGrowGiftActivity:_onGetOtherData", doType, Serialize(tResult))

		self.m_tStatus = {}
		self.m_tStatus[1] = tResult.normalStatus
		self.m_tStatus[2] = tResult.superStatus

		for i=1,#self.m_tRewardsData[1] do
			self.m_tRewardsData[1][i].status = tResult.normalStatus
			self.m_tRewardsData[1][i].rewardStatus = tResult.normalRewardStatus[i]
		end
		for i=1,#self.m_tRewardsData[2] do
			self.m_tRewardsData[2][i].status = tResult.superStatus
			self.m_tRewardsData[2][i].rewardStatus = tResult.superRewardStatus[i]
		end

		self:updateUI()
	elseif doType == 2 then
		if result == 0 then
			local tResult = json.decode(jsonData)
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)

			self.m_tRewardsData[self.m_nCheckIndex+1][tResult.indexLv+1].rewardStatus = tResult.status
			self:updateUI()
		end
	elseif doType == 3 then
		if result == 1 then
			local tResult = json.decode(jsonData)
			self:gotoBuy(tResult.rechargeId)
		end
	end
end


--@brief    获得充值数据
function WndGrowGiftActivity:getRechargeData()
	local tRechargeData = nil
	for i, value in pairs(GDatatab_recharge) do
		if tonumber(value.type) == self.m_tRechargeConfig[self.m_nCheckIndex+1][1] and tonumber(value.sort) == self.m_tRechargeConfig[self.m_nCheckIndex+1][2] then 
			tRechargeData = value
		end
	end
	return tRechargeData
end

--@brief 	下订单
function WndGrowGiftActivity:gotoBuy(rechargeId)
	--购买
	local sdkData = {}
    local vipData = GDatatab_recharge["id_" .. rechargeId]
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

--@brief 	解锁成功回调
function WndGrowGiftActivity:_onRechargeSuccessResult()
	--刷新领取状态
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------分割线----------------------------------------

CellGrowGiftActivity = {}
function CellGrowGiftActivity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bIsLoaded = false
	self.m_tData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellGrowGiftActivity:_unInit()
	self.m_root = nil
	self.m_bIsLoaded = nil
	self.m_tData = nil
end

--@brief	创建控件
function CellGrowGiftActivity:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(119,321))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellGrowGiftActivity:setData(data)
	self.m_tData = data
	self:updateUI()
end

--@brief 	获取数据
function CellGrowGiftActivity:getData()
	return self.m_tData
end

--@brief 	开始加载
function CellGrowGiftActivity:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellGrowGiftActivity_WndGrowGiftActivity")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:updateUI()
end

function CellGrowGiftActivity:updateUI()
	if not self.m_bIsLoaded then
		return
	end

	GetElement(self.m_root,"txtLevel",WZUILabelTTF):setText(string.format(LocalStrings.ACTIVITY_SHOW_LEVEL, self.m_tData.config))

	for i=1,2 do
		local imgItemBg = GetElement(self.m_root,"imgItemBg"..i,WZUIImage)
		imgItemBg:setVisible(false)
		local conItem = GetElement(self.m_root,"conItem"..i,WZUIContainer)
		conItem:removeAllChildrenWithCleanup(true)
		if self.m_tData.rewards[i] then
			imgItemBg:setVisible(true)

			local celElement,tCell = CellGoodItem:createElement()
			celElement:setTag(i-1)
			celElement:setScale(0.8)
			tCell:setCellGoodLocalId(self.m_tData.rewards[i][1], self.m_tData.rewards[i][2], 17)
			tCell:setItemClickFun(self,self.onItemClick)
			tCell:_setBgImgVisible(false)
			conItem:addChild(celElement)
		end
	end

	local txtStatus = GetElement(self.m_root,"txtStatus",WZUILabelTTF)
	local conStatus1 = GetElement(self.m_root,"conStatus1",WZUIContainer)
	local conStatus2 = GetElement(self.m_root,"conStatus2",WZUIContainer)
	if self.m_tData.status == 0 then
		txtStatus:setVisible(true)
		txtStatus:setText(LocalStrings.GROW_GIFT_TEXT1[4])
		conStatus1:setVisible(false)
		conStatus2:setVisible(false)
	elseif self.m_tData.status == 1 then
		if self.m_tData.rewardStatus == -1 then
			txtStatus:setVisible(true)
			txtStatus:setText(LocalStrings.GROW_GIFT_TEXT1[5])
			conStatus1:setVisible(false)
			conStatus2:setVisible(false)
		elseif self.m_tData.rewardStatus == 0 then
			txtStatus:setVisible(true)
			txtStatus:setText(LocalStrings.CAN_GET)
			conStatus1:setVisible(false)
			conStatus2:setVisible(true)
		elseif self.m_tData.rewardStatus == 1 then
			txtStatus:setVisible(false)
			conStatus1:setVisible(true)
			conStatus2:setVisible(false)
		end
	end
end

--@brief	点击物品弹出对应的tips
function CellGrowGiftActivity:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndGrowGiftActivity.m_root,1,tData,false)
end

--@brief    点击领取奖励
function CellGrowGiftActivity:onClickGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tData.status == 1 then
		if self.m_tData.rewardStatus == -1 then
			MsgBoxManager:showTipBox(LocalStrings.GROW_GIFT_TEXT1[6])
		elseif self.m_tData.rewardStatus == 0 then
			local sjson = {}
			sjson.giftId = WndGrowGiftActivity.m_nCheckIndex
			sjson.indexLv = self.m_tData.index - 1
			sjson = json.encode(sjson)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7134, 2, sjson)
		end
	end
end

--@return	新建的表实例对象
function CellGrowGiftActivity:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end