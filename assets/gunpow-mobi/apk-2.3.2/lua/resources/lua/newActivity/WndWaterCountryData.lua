--WndWaterCountryData.lua
--@brief	WndWaterCountry的数据模块
--@date		2021/10/26
--@author	XTX
--@note		水之国度活动主界面

WndWaterCountry = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWaterCountry:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nRTabIndex = 1 				
	self.m_nCurCostNum = 0 				--当前全服消耗的水符道具
	self.m_nTotalNum = nil 				
	self.m_tPeriodBoxList = nil 
	self.m_tPeriodRecordList = nil 
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tMyCodeList = nil 			--我的水符石
	self.m_nWaterType = 1 				--1：水滴石穿；2：上善若水
	self.m_tOpenResult = nil   			--开启结果
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_tContent = nil 
	self.m_bOpenState = false 			--是否正在开启
	self.m_nActivityId = nil
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWaterCountry:_unInit()
	self.m_root = nil
	self.m_nRTabIndex = nil 
	self.m_nCurCostNum = nil 				--当前全服消耗的水符道具
	self.m_tPeriodBoxList = nil 
	self.m_tPeriodRecordList = nil 
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tMyCodeList = nil
	self.m_nWaterType = nil 
	self.m_tOpenResult = nil   			--开启结果
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_tContent = nil 
	self.m_bOpenState = nil  			--是否正在开启
	self.m_nActivityId = nil
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWaterCountry:createElement()
	if WndWaterCountry.m_root ~= nil then
		WindowManager:removeWindow(WndWaterCountry.m_root, WndWaterCountry, true)
	end
	local element = WZUISystem:getInstance():createElement("WndWaterCountry")
	assert(element, "WndWaterCountry create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndWaterCountry:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndWaterCountry:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndWaterCountry, false)
	end
end

--@brief 	获取活动详情成功
function WndWaterCountry:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	if g_cityExtenInfo.activity7031 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nChooseReward = GetOperateTimes("WATERCOUNTRYACTIVITYID", self.m_nActivityId) 

		self:_analyzeBigReward()
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndWaterCountry:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --刷新开宝藏进度
		local tResult = json.decode(jsonData)
		self.m_nTotalNum = tResult.bzTarget
		self.m_nCurCostNum = tResult.bzProgress
		self:showMyCode()
	elseif doType == 2 then --当前宝藏
		local tResult = json.decode(jsonData)
		self.m_tPeriodBoxList = {} 
		local nSex = CacheCenter:getPlayerInfo().sex
		for i = 1, 3 do
			local tItem = {}

			tItem.periodNum = tResult.version
			tItem.periodName = LocalStrings.WATERCOUNTRY_TEXT5[i]

			local array = SplitStringWithSeparator(tResult["bz" .. i .. "Rewards"], "&")
			local tReward = {}
			for i = 1, #array do
				local string = string.sub(array[i], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
				local num = tonumber(SplitStringWithSeparator(string,",")[3])
				table.insert(tReward, {id, num})
			end
			tItem.periodReward = tReward

			table.insert(self.m_tPeriodBoxList, tItem)
		end
		--回顾数据
		
		if self.m_nRTabIndex == 1 then 
			self:showCurBox()	
		end
	elseif doType == 3 then --获取我的水符石
		self.m_tMyCodeList = {}
		local tResult = json.decode(jsonData)

		self.m_tMyCodeList = tResult.bzms
		self:showMyCodeList()
	elseif doType == 4 then --开启结果
		local tResult = json.decode(jsonData)
		self.m_tOpenResult = tResult

		if result == 1 then 
			self:showOpenAction()
		end
	elseif doType == 5 then --夺宝回顾
		local tResult = json.decode(jsonData)
		self.m_tPeriodRecordList = {} 
		self.m_tPeriodRecordList = tResult.bzLogs
		if self.m_nRTabIndex == 2 then 
			self:showPeriodRecordList()
		end
	elseif doType == 6 then --大奖限量
		local tResult = json.decode(jsonData)
		local nSex = CacheCenter:getPlayerInfo().sex
		local sBigReward = tResult.rewards
		local array = SplitStringWithSeparator(sBigReward, "&")
		local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ACTIVITY_TEXT19, strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31}
		for i = 1, #tResult.globalLimit do
			local tab = {}
			tab.id = i - 1
			tab.limitNum = tResult.playerLimitConfig[i]
			tab.dailyLimit = tResult.globalLimitConfig[i]
			tab.dailyBuyNum = tResult.globalLimit[i]
			tab.soldNum = tResult.playerLimit[i]
			if utilsValueInTable(i - 1, tResult.optionalList) then 
				tItem.chooseState[i] = 1
			else
				tItem.chooseState[i] = 0
			end
			
			tItem.leftConfig[i] = tab
		end

		for i = 1, #array do
			local string = string.sub(array[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(string,",")[3])

			table.insert(tItem.reward_ids2, id)
			table.insert(tItem.reward_nums2, num)
		end
		self.m_tBigRewardList[2] = tItem

		local otherData = {}
		otherData.winType = 1
		otherData.activityId = self.m_nActivityId
		WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.TREASURE_TEXT7, false, 2, otherData, 2)
	elseif doType == 7 then 
		local tResult = json.decode(jsonData)
		if result == 0 then 
			local tTempList = nil 
			tTempList = self.m_tBigRewardList[2]
			tTempList.chooseState[tResult.id + 1] = tResult.status
			if tResult.status == 1 then 
				WndJoinReward:chooseReturn(2, tResult.id + 1, tResult.status)
			end
		elseif result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndWaterCountry:updatePlayerItemData()
	if self.m_root ~= nil then
		self:_updateArrowNum()
	end
end

--@brief 	设置射箭的状态
function WndWaterCountry:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndWaterCountry:_afterCloseReward()
	if self.m_root == nil then return end 

	local tBigReward = {}
	if #self.m_tOpenResult.fItemIds > 0 then 
		for i = 1, #self.m_tOpenResult.fItemIds do
			local tItem = {}
			tItem.itemId = self.m_tOpenResult.fItemIds[i]
			tItem.itemNum = self.m_tOpenResult.fItemNums[i]
			tItem.type = 1

			table.insert(tBigReward, tItem)
		end
	end

	if #self.m_tOpenResult.sItemIds > 0 then 
		for i = 1, #self.m_tOpenResult.sItemIds do
			local tItem = {}
			tItem.itemId = self.m_tOpenResult.sItemIds[i]
			tItem.itemNum = self.m_tOpenResult.sItemNums[i]
			tItem.type = 2

			table.insert(tBigReward, tItem)
		end
	end

	if #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(6, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndWaterCountry:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.ACTIVITY_TEXT18}
	self.m_tBigRewardList = {}
	for i = 1, #array do
		WZLog("WndWaterCountry:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.superRewards
	local array1 = SplitStringWithSeparator(specialReward, "&")
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ACTIVITY_TEXT19}
	for i = 1, #array1 do
		WZLog("WndWaterCountry:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end


-------------------------------------私有方法模块End----------------------------------------
CellPeriodRecord = {}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPeriodRecord:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPeriodRecord:_unInit()
	self.m_root = nil
	self.m_tData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPeriodRecord:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPeriodRecord table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setName("__CellPeriodRecord")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(245,122))
	element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

function CellPeriodRecord:setData(tData)
	self.m_tData = tData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPeriodRecord:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPeriodRecord:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPeriodRecord:onExit(element)
	self:_unInit()
end

--@brief    加载
function CellPeriodRecord:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("cellPeriodRecord")
    celElement:setVisible(true)
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true
    self:_update()

    AdaptLanguage(self)
end

--@brief    刷新
function CellPeriodRecord:_update()
	local element = self.m_root
	if element then 
		local openDate = os.date("*t", self.m_tData.time)
		local openTimeStr = string.format("%02d.%02d %02d:%02d", openDate.month, openDate.day, openDate.hour, openDate.min)
		GetElement(element, "txtOpenTimeL_cellPeriodRecord", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[13] .. ":")
		GetElement(element, "txtOpenTime_cellPeriodRecord", WZUILabelTTF):setText(openTimeStr)
		GetElement(element, "txtNameL_cellPeriodRecord", WZUILabelTTF):setText(LocalStrings.PLAYER .. ":")
		GetElement(element, "txtName_cellPeriodRecord", WZUILabelTTF):setText(self.m_tData.name)
		GetElement(element, "txtBoxTypeNameL_cellPeriodRecord", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[11] .. ":")
		GetElement(element, "txtBoxTypeName_cellPeriodRecord", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT5[self.m_tData.type])
		GetElement(element, "txtCodeNumL_cellPeriodRecord", WZUILabelTTF):setText(LocalStrings.WATERCOUNTRY_TEXT2[12] .. ":")
		GetElement(element, "txtCodeNum_cellPeriodRecord", WZUILabelTTF):setText(self.m_tData.bzm)
		local conHead = GetElement(element, "conHead_cellPeriodRecord", WZUIContainer)
		local headElement = CellHead:show(conHead, self.m_tData.headId, self.m_tData.faceId, self.m_tData.sex, nil, nil, self.m_tData.vipLevel, self.m_tData.headColor, nil, nil, nil, nil, self.m_tData.headEffectId)
		GetElement(element, "btnHead_cellPeriodRecord", WZUIButton):setTag(self.m_tData.playerId)
	end
end


function CellPeriodRecord:_adaptLanguage_vn()
	GetElement(self.m_root, "txtNameL_cellPeriodRecord", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtBoxTypeNameL_cellPeriodRecord", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtCodeNumL_cellPeriodRecord", WZUILabelTTF):setScale(0.7)
end