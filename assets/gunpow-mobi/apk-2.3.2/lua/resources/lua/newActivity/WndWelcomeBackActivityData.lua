--WndWelcomeBackActivityData.lua
--@brief	WndWelcomeBackActivity的数据模块
--@date		2023/03/06
--@author	yrd
--@note		欢迎回来活动

WndWelcomeBackActivity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWelcomeBackActivity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nInterfaceIndex = nil
	self.m_tMsgData = nil
	self.m_nSelectedIndex = 0 			--被选中的复选框下标

	self.m_nLoadingBoxID = nil 

	self.m_nStartTime = nil 			--开始时间
	self.m_nEndTime = nil 				--结束时间
	self.m_tSignRewards = nil 			--专属坐骑 奖励
	self.m_tSignConfig = nil 			--专属坐骑 补签
	self.m_tDaKaRewards = nil 			--快速变强 奖励
	self.m_tDaKaConfig = nil 			--快速变强 补签

	self.m_tOtherData = nil 			--活动额外数据{day,signStatus,giftCount,giftStatus,daKaStatus,recharge,daKaDoubleStatus}

	self.m_tT1CellObjs = nil 			--专属坐骑列表对象
	self.m_tT2CellObjs = nil 			--快速变强列表对象

end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWelcomeBackActivity:_unInit()
	self.m_root = nil
	self.m_nInterfaceIndex = nil
	self.m_tMsgData = nil
	self.m_nSelectedIndex = nil

	self.m_nLoadingBoxID = nil 

	self.m_nStartTime = nil 			--开始时间
	self.m_nEndTime = nil 				--结束时间
	self.m_tSignRewards = nil 			--专属坐骑 奖励
	self.m_tSignConfig = nil 			--专属坐骑 补签
	self.m_tDaKaRewards = nil 			--快速变强 奖励
	self.m_tDaKaConfig = nil 			--快速变强 补签

	self.m_tOtherData = nil 			--活动额外数据{day,signStatus,giftCount,giftStatus,daKaStatus,recharge,daKaDoubleStatus}

	self.m_tT1CellObjs = nil 			--专属坐骑列表对象
	self.m_tT2CellObjs = nil 			--快速变强列表对象
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWelcomeBackActivity:createElement()
	if WndWelcomeBackActivity.m_root ~= nil then
		WindowManager:removeWindow(WndWelcomeBackActivity.m_root, WndWelcomeBackActivity, true)
	end
	local element = WZUISystem:getInstance():createElement("WndWelcomeBackActivity")
	assert(element, "WndWelcomeBackActivity create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndWelcomeBackActivity:showInterface(nIndex, tMsg)
	LoadNewActivityRes(true)
	local wndWater = WndWelcomeBackActivity:createElement()
	if wndWater then 
		self.m_nInterfaceIndex = nIndex or 1
		self.m_tMsgData = tMsg
		WindowManager:addWindow(wndWater, WndWelcomeBackActivity, false, nil, nil, true)
	end
end

--@brief 	获取活动详情成功
function WndWelcomeBackActivity:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	WZLog("WndWelcomeBackActivity:GetActivityInfoOK")
	if g_cityExtenInfo.activity7068 == activityId then
		WndWelcomeBackActivity:stopLoading()

		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId

		self.m_tContent = json.decode(content)
		WZLog("WndWelcomeBackActivity:GetActivityInfoOK self.m_tContent",TableToString(self.m_tContent))

		local sex = CacheCenter:getPlayerInfo().sex
		--"专属坐骑"奖励
		self.m_tSignRewards = {}
		local tmpSignRewards = json.decode(self.m_tContent.signRewards)
		for i=1,#tmpSignRewards do
			local rewards = {}
			local array = SplitStringWithSeparator(tmpSignRewards[i], "&")
			for j = 1, #array do
				local strTemp = string.sub(array[j], 2, -2)
				local id
				if sex == 0 then
					id = tonumber(SplitStringWithSeparator(strTemp,",")[1])
				elseif sex == 1 then
					id = tonumber(SplitStringWithSeparator(strTemp,",")[2])
				end
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

				table.insert(rewards, {id, num})
			end
			table.insert(self.m_tSignRewards, rewards)
		end

		--"专属坐骑"补签配置
		self.m_tSignConfig = json.decode(self.m_tContent.signConfig)

		--"快速变强"打卡奖励
		self.m_tDaKaRewards = {}
		local tmpDaKaRewards = json.decode(self.m_tContent.daKaRewards)
		for i=1,#tmpDaKaRewards do
			local rewards = {}
			local array = SplitStringWithSeparator(tmpDaKaRewards[i], "&")
			for j = 1, #array do
				local strTemp = string.sub(array[j], 2, -2)
				local id
				if sex == 0 then
					id = tonumber(SplitStringWithSeparator(strTemp,",")[1])
				elseif sex == 1 then
					id = tonumber(SplitStringWithSeparator(strTemp,",")[2])
				end
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

				table.insert(rewards, {id, num})
			end
			table.insert(self.m_tDaKaRewards, rewards)
		end

		--"快速变强"补签配置
		self.m_tDaKaConfig = json.decode(self.m_tContent.daKaConfig)

		--"快速变强"打卡翻倍
		self.m_tRechargeNum = json.decode(self.m_tContent.rechargeNum)

		--"快速变强"充值计费点配置
		self.m_tRechargeConfig = json.decode(self.m_tContent.rechargeConfig)

		--"快速变强"充值计费点显示配置
		self.m_tRechargeShowConfig = json.decode(self.m_tContent.rechargeShowConfig)

		--"快速变强"充值计费点原价
		self.m_tRechargePrice = json.decode(self.m_tContent.rechargePrice)

		--"快速变强"充值计费点奖励配置
		self.m_tRechargeRewards = {}
		local tmpRechargeRewards = json.decode(self.m_tContent.rechargeRewards)
		for i=1,#tmpRechargeRewards do
			local rewards = {}
			local array = SplitStringWithSeparator(tmpRechargeRewards[i], "&")
			for j = 1, #array do
				local strTemp = string.sub(array[j], 2, -2)
				local id
				if sex == 0 then
					id = tonumber(SplitStringWithSeparator(strTemp,",")[1])
				elseif sex == 1 then
					id = tonumber(SplitStringWithSeparator(strTemp,",")[2])
				end
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

				table.insert(rewards, {id, num})
			end
			table.insert(self.m_tRechargeRewards, rewards)
		end

		--"快速变强"进度礼包
		self.m_tGiftConfig = json.decode(self.m_tContent.giftConfig)

		--"快速变强"进度礼包奖励
		self.m_tGiftRewards = {}
		local tmpGiftRewards = json.decode(self.m_tContent.giftRewards)
		for i=1,#tmpGiftRewards do
			local rewards = {}
			local array = SplitStringWithSeparator(tmpGiftRewards[i], "&")
			for j = 1, #array do
				local strTemp = string.sub(array[j], 2, -2)
				local id
				if sex == 0 then
					id = tonumber(SplitStringWithSeparator(strTemp,",")[1])
				elseif sex == 1 then
					id = tonumber(SplitStringWithSeparator(strTemp,",")[2])
				end
				local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

				table.insert(rewards, {id, num})
			end
			table.insert(self.m_tGiftRewards, rewards)
		end

		--"快速变强"进度礼包
		self.m_tRechargeLimit = json.decode(self.m_tContent.rechargeLimit)


		self:_update()
	end
end


--@brief    添加保存是否主动弹感恩打卡活动设置
function WndWelcomeBackActivity:saveAutoActivity(nValue)
    WZLog("WndWelcomeBackActivity:saveAutoActivity")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "WELCOMEBACK" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("WELCOME_MARK", _KeyString)
    local curValue = string.format("%02d%02d_%d", curDate.month, curDate.day, nValue)
    if strValue == nil or strValue == "" or strValue ~= curValue then
        data:setStringValue("WELCOME_MARK", _KeyString, curValue)
        data:flush()
    end
end

--@brief    获取上次保存的感恩打卡活动设置
function WndWelcomeBackActivity:getAutoActivity()
    WZLog("WndWelcomeBackActivity:getAutoActivity")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "WELCOMEBACK" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("WELCOME_MARK", _KeyString)
    local curValue = string.format("%02d%02d", curDate.month, curDate.day)
    if strValue ~= nil and strValue ~= "" then
        local result = SplitStringWithSeparator(strValue, "_")
        if result[1] == curValue then 
            GlobalGame.g_autoWelcomeBack = tonumber(result[2]) == 0 
            return tonumber(result[2])
        end
    end

    return 0
end

--@brief 	获取其他活动数据
function WndWelcomeBackActivity:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --额外信息
		if result == 1 then
			self.m_tOtherData = json.decode(jsonData)

			WZLog("WndWelcomeBackActivity:_onGetOtherData 1",TableToString(self.m_tOtherData))
			if self.m_tContent then
				self:_update()
			end
		end
	elseif doType == 2 then
		--[[
		itemIds	: int[] 道具ID数组,
		itemNums	: int[] 道具数量数组,
		day	: int步数礼包奖励id(下标),
		status	: int状态 -1:不可领取 0:可领取 1:已领取,
		buSignNum	: int专属坐骑：补签次数
		--]]
		-- 7068	2	0	{"itemIds":[23062],"buSignNum":0,"itemNums":[1],"day":0,"status":1}
		if result == 0 then
			local tResult = json.decode(jsonData)
			WZLog("WndWelcomeBackActivity:_onGetOtherData 2", Serialize(tResult))
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			self.m_tContent.buSignNum = tResult.buSignNum

			local nIdx = tResult.day+1
			self.m_tOtherData.signStatus[nIdx] = tResult.status
			if self.m_tT1CellObjs and self.m_tT1CellObjs[nIdx] then 
				self.m_tT1CellObjs[nIdx]:updateStatue(tResult.status)
			end
		end
	elseif doType == 3 then
		--[[		
		itemIds	: int[] 道具ID数组,
		itemNums	: int[] 道具数量数组,
		day	: int打卡|补卡(下标),
		status	: int状态 -1:不可领取 0:可领取 1:已领取,
		buKaNum	: int快速变强：补卡次数,
		giftCount	: int快速变强：打卡礼包进度,
		recharge	: int[] 充值翻倍值,
		isMultiple	: int 是否翻倍 0:未翻倍 1:翻倍
		--]]
		if result == 0 then
			local tResult = json.decode(jsonData)
			WZLog("WndWelcomeBackActivity:_onGetOtherData 3", Serialize(tResult))

			self.m_tContent.buKaNum = tResult.buKaNum

			self.m_tOtherData.giftCount = tResult.giftCount
			for i=1,#self.m_tOtherData.giftStatus do
				if self.m_tOtherData.giftStatus[i] == -1 and tResult.giftCount >= self.m_tGiftConfig[i] then
					self.m_tOtherData.giftStatus[i] = 0
				end
			end
			self:updateT2BoxProgress()

			local nMultiNum = 1

			local nIdx = tResult.day+1
			self.m_tOtherData.daKaStatus[nIdx] = tResult.status
			for i=1,#self.m_tT2CellObjs do
				if self.m_tT2CellObjs[i].m_tData.type == 2 and self.m_tT2CellObjs[i].m_tData.index == nIdx then
					self.m_tT2CellObjs[i].m_tData.status = tResult.status
					self.m_tT2CellObjs[i]:updateUI()

					if tResult.isMultiple == 1 then
						nMultiNum = 1 + self.m_tT2CellObjs[i].m_tData.rechargeNum[2]
					end
				end
			end

			local nums = {}
			for i=1,#tResult.itemNums do
				local nNum = tResult.itemNums[i]
				if tResult.isMultiple == 1 then
					nNum = nNum * nMultiNum
				end
				table.insert(nums,nNum)
			end
			WndRewardShow:showById(tResult.itemIds, nums)

			self.m_tOtherData.recharge = tResult.recharge
			for i=1,#self.m_tT2CellObjs do
				for j=1,#tResult.recharge do
					if self.m_tT2CellObjs[i].m_tData.type == 2 and self.m_tT2CellObjs[i].m_tData.index == j then
						self.m_tT2CellObjs[i].m_tData.recharge = tResult.recharge[j]
						self.m_tT2CellObjs[i]:updateUI()
					end
				end
			end
		end
	elseif doType == 4 then
		--[[
		itemIds	: int[] 道具ID数组,
		itemNums	: int[] 道具数量数组,
		gift	: int累计礼包礼包奖励id(下标),
		status	: int状态 -1:不可领取 0:可领取 1:已领取
		--]]
		if result == 0 then
			local tResult = json.decode(jsonData)
			WZLog("WndWelcomeBackActivity:_onGetOtherData 4", Serialize(tResult))
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			self.m_tOtherData.giftStatus[tResult.gift+1] = tResult.status
			
			local tbList = GetElement(self.m_root,"tbList_WndWelcomeBackActivity",WZUITableContainer)
			self.m_tbConMove2PosX = tbList:getMoveElement():getPositionX()
			self:updateT2UI()
		end
	elseif doType == 7 then
		local tResult = json.decode(jsonData)
		WZLog("WndWelcomeBackActivity:_onGetOtherData", doType, Serialize(tResult))
		if result == 0 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
		end
	end
end

--@brief 	获取活动额外信息
--[[
day	: int回归第几天,
signStatus	: int[]专属坐骑：打卡状态 ：-1=不可签到,0=,可以签到,1=,已签到,2=可补签,
giftCount	: int快速变强：打卡礼包进度,
giftStatus	: int[]快速变强：打卡礼包进度状态： -1=不可领取,0=可领取,1=已领取,
daKaStatus	: int[]快速变强：打卡状态 ：-1=不可签到,0=,可以签到,1=,已签到,2=可补签,
recharge	: int 今日充值蓝钻数量,
daKaDoubleStatus	: int[]快速变强：打卡状态 ：-1=不可翻倍,0=未翻倍,1=已翻倍
--]]
function WndWelcomeBackActivity:getOtherData()
	return self.m_tOtherData
end

--@brief 	下订单
function WndWelcomeBackActivity:gotoBuy(rechargeId)
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

function WndWelcomeBackActivity:getContent()
	return self.m_tContent
end

function WndWelcomeBackActivity:getOtherData()
	return self.m_tOtherData
end

function WndWelcomeBackActivity:refreshActivityContext()
	if self.m_root == nil then return end

	-- if self.m_tCurBuyCellObj then
	-- 	local index = self.m_tCurBuyCellObj.m_tData.index
	-- 	self.m_tOtherData.rechargeBuyNum[index] = self.m_tOtherData.rechargeBuyNum[index] + 1
	-- 	self.m_tCurBuyCellObj.m_tData.rechargeBuyNum = self.m_tCurBuyCellObj.m_tData.rechargeBuyNum + 1
	-- 	self.m_tCurBuyCellObj:updateUI()
	-- 	self.m_tCurBuyCellObj = nil
	-- end

	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7068, 7068)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------CellWelcomeBackItem----------------------------------------

CellWelcomeBackItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellWelcomeBackItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_bIsLoaded = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellWelcomeBackItem:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellWelcomeBackItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellWelcomeBackItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellWelcomeBackItem")
	element:setAbsContentSize(GlobalMethod:CCSize(190,334))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	 设置数据
function CellWelcomeBackItem:setData(tData)
	self.m_tData = tData
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellWelcomeBackItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWelcomeBackItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWelcomeBackItem:onExit(element)
	self:_unInit()
end

--@brief 加载
function CellWelcomeBackItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellWelcomeBackItem")
	celElement:setVisible(true)
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true 
    self:updateUI()

    AdaptLanguage(self)
end


--@brief    刷新
function CellWelcomeBackItem:updateUI()
	WZLog("CellWelcomeBackItem:updateUI")
	if self.m_bIsLoaded ~= true then
		return
	end

	local conM1 = GetElement(self.m_root,"conM1_CellWelcomeBackItem",WZUIContainer)
	local conM2 = GetElement(self.m_root,"conM2_CellWelcomeBackItem",WZUIContainer)
	local conM3 = GetElement(self.m_root,"conM3_CellWelcomeBackItem",WZUIContainer)
	conM1:setVisible(false)
	conM2:setVisible(false)
	conM3:setVisible(false)
	if self.m_tData.type == 1 then --"专属坐骑"打卡
		conM1:setVisible(true)

		local imgM1Bk = GetElement(self.m_root, "imgM1Bk_CellWelcomeBackItem", WZUIImage)
		local conDone = GetElement(self.m_root, "conDone_CellWelcomeBackItem", WZUIContainer)
		local btnSign = GetElement(self.m_root, "btnSign_CellWelcomeBackItem", WZUIButton)
		local imgBtnSign = GetElement(self.m_root, "imgBtnSign_CellWelcomeBackItem", WZUIImage)
		local txtBtnSign = GetElement(self.m_root, "txtBtnSign_CellWelcomeBackItem", WZUILabelTTF)
		local txtM1Day1 = GetElement(self.m_root, "txtM1Day1_CellWelcomeBackItem", WZUILabelTTF)
		local txtM1Day2 = GetElement(self.m_root, "txtM1Day2_CellWelcomeBackItem", WZUILabelTTF)
		local txtM1Day3 = GetElement(self.m_root, "txtM1Day3_CellWelcomeBackItem", WZUILabelTTF)
		CCNodePropertySetter:setValue(txtM1Day1, "skewX", 10)
		CCNodePropertySetter:setValue(txtM1Day2, "skewX", 10)
		CCNodePropertySetter:setValue(txtM1Day3, "skewX", 10)
		txtM1Day1:setText(LocalStrings.ACITVITY_WELCOME_BACK[11])
		txtM1Day2:setText(self.m_tData.index)
		txtM1Day3:setText(LocalStrings.DAY)
		if self.m_tData.day == self.m_tData.index then --当前天
			imgM1Bk:setFile("ui/newActivity/common_hyhl_di_01.png")
			conDone:setRelativePosition(GlobalMethod:ccp(0.5,0.513))
			conDone:setAbsContentSize(GlobalMethod:CCSize(182,336))
			conDone:updateRelativeSize()
			btnSign:setRelativePosition(GlobalMethod:ccp(0.5,0.09))
			imgBtnSign:setFile("ui/newActivity/common_btn_hyhl_dk_01.png")
			txtBtnSign:setEnableStroke(true)
			txtM1Day1:setColor(ccc3(127,70,26))
			txtM1Day2:setColor(ccc3(127,70,26))
			txtM1Day3:setColor(ccc3(127,70,26))
		else
			imgM1Bk:setFile("ui/newActivity/common_hyhl_di_02.png")
			conDone:setRelativePosition(GlobalMethod:ccp(0.5,0.507))
			conDone:setAbsContentSize(GlobalMethod:CCSize(182,326))
			conDone:updateRelativeSize()
			btnSign:setRelativePosition(GlobalMethod:ccp(0.5,0.1))
			imgBtnSign:setFile("ui/newActivity/common_btn_hyhl_dk_02.png")
			txtBtnSign:setEnableStroke(false)
			txtM1Day1:setColor(ccc3(91,65,167))
			txtM1Day2:setColor(ccc3(91,65,167))
			txtM1Day3:setColor(ccc3(91,65,167))
		end

		local conReward = GetElement(self.m_root, "conReward_CellWelcomeBackItem", WZUIContainer)
		conReward:removeAllChildrenWithCleanup(true)
		local nStartY = 0.75 
		local nGapping = 0.5
		local nScale = 1
		for i = 1, #self.m_tData.items do
			local element, tNewObj = CellGoodItem:createElement()
			if element and tNewObj then
				tNewObj:setCellGoodLocalId(self.m_tData.items[i][1], self.m_tData.items[i][2], 17)
				tNewObj:setItemClickFun(self, self.onItemClick)
				element:setRelativePosition(GlobalMethod:ccp(0.5, nStartY - (i - 1)*nGapping))
				if self.m_tData.day == self.m_tData.index then
					tNewObj:setBackImgFile("ui/newActivity/common_hyhl_tbd_01.png", nil, nil, GlobalMethod:ccp(0.55, 0.42))			
				else
					tNewObj:setBackImgFile("ui/newActivity/common_hyhl_tbd_02.png", nil, nil, GlobalMethod:ccp(0.55, 0.42))			
				end
				tNewObj:setQualityFrameVisible(false)
				element:setScale(nScale)
				conReward:addChild(element)
			end
		end

		self:updateStatue()
	elseif self.m_tData.type == 2 then --"快速变强"打卡
		conM2:setVisible(true)

		local imgM2Bk = GetElement(self.m_root, "imgM2Bk_CellWelcomeBackItem", WZUIImage)
		imgM2Bk:setFile("ui/newActivity/common_hyhl_di_03.png")

		local ftbM2Attr = GetElement(self.m_root, "ftbM2Attr_CellWelcomeBackItem", WZUIFreeTextBox)
		local strFormat = [[<T C="255,236,193" S="22" P="1" SC="132,66,29" SS="4" SE="1">%s: </T><T C="99,255,95" S="22" P="1" SC="132,66,29" SS="4" SE="1">%s</T><BR>2</BR>]]
		local strContent = ""
		for i = 1, #self.m_tData.items do
			local basicInfo = GDatatab_item["id_" .. self.m_tData.items[i][1]]
			if basicInfo.main_type == 1 and basicInfo.sub_type == 61 then
				for j = 1, #basicInfo.property do
					strContent = strContent .. string.format(strFormat,ATTR_TITLE[basicInfo.property[j][1]],"+"..(basicInfo.property[j][2]*self.m_tData.items[i][2]))
				end
			else
				strContent = strContent .. string.format(strFormat,basicInfo.name,"*"..(self.m_tData.items[i][2]))
			end
		end
		ftbM2Attr:setShowText(strContent)

		local txtM2Clock = GetElement(self.m_root, "txtM2Clock_CellWelcomeBackItem", WZUILabelTTF)
		local strRecharge = string.format(LocalStrings.ACITVITY_WELCOME_BACK[7], self.m_tData.recharge.."/"..self.m_tData.rechargeNum[1], self.m_tData.rechargeNum[2])
		txtM2Clock:setText(strRecharge)

		local txtM2Day1 = GetElement(self.m_root, "txtM2Day1_CellWelcomeBackItem", WZUILabelTTF)
		local txtM2Day2 = GetElement(self.m_root, "txtM2Day2_CellWelcomeBackItem", WZUILabelTTF)
		local txtM2Day3 = GetElement(self.m_root, "txtM2Day3_CellWelcomeBackItem", WZUILabelTTF)
		CCNodePropertySetter:setValue(txtM2Day1, "skewX", 10)
		CCNodePropertySetter:setValue(txtM2Day2, "skewX", 10)
		CCNodePropertySetter:setValue(txtM2Day3, "skewX", 10)
		txtM2Day1:setText(LocalStrings.ACITVITY_WELCOME_BACK[11])
		txtM2Day2:setText(self.m_tData.index)
		txtM2Day3:setText(LocalStrings.DAY)

		self:updateStatue()
	elseif self.m_tData.type == 3 then --"快速变强"购买
		conM3:setVisible(true)

		local imgM3Bk = GetElement(self.m_root, "imgM3Bk_CellWelcomeBackItem", WZUIImage)
		imgM3Bk:setFile("ui/newActivity/common_hyhl_di_03.png")

		local conM3Item = GetElement(self.m_root,"conM3Item_CellWelcomeBackItem",WZUIContainer)

		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			tCell:setCellGoodLocalId(self.m_tData.rechargeRewards[1][1], 1, 5)
			tCell:setItemClickFun(self,self.onTips)
			conM3Item:addChild(celElement)
		end

		local txtM3PresentPrice = GetElement(self.m_root, "txtM3PresentPrice_CellWelcomeBackItem", WZUILabelTTF)
		txtM3PresentPrice:setText(LocalStrings.LIMITE_BUY_ORIGINPRICE..": "..string.format(LocalStrings.ACITVITY_WELCOME_BACK[9],self.m_tData.rechargePrice))
		local txtM3OriginalPrice = GetElement(self.m_root, "txtM3OriginalPrice_CellWelcomeBackItem", WZUILabelTTF)
		txtM3OriginalPrice:setText(LocalStrings.LIMITE_BUY_CURPRICE..": "..string.format(LocalStrings.ACITVITY_WELCOME_BACK[9],self.m_tData.rechargeConfig[2]))

		local basicInfo = GDatatab_item["id_" .. self.m_tData.rechargeRewards[2][1]]
		local txtM3Buy = GetElement(self.m_root, "txtM3Buy_CellWelcomeBackItem", WZUILabelTTF)
		txtM3Buy:setText(string.format(LocalStrings.ACITVITY_WELCOME_BACK[8], ATTR_TITLE[basicInfo.property[1][1]], basicInfo.property[1][2]*self.m_tData.rechargeRewards[2][2]))

		GetElement(self.m_root,"txtM3LimitWord_CellWelcomeBackItem",WZUILabelTTF):setText(LocalStrings.ACITVITY_WELCOME_BACK[6])
		local txtM3LimitVal = GetElement(self.m_root, "txtM3LimitVal_CellWelcomeBackItem", WZUILabelTTF)
		txtM3LimitVal:setText(self.m_tData.rechargeBuyNum.."/"..self.m_tData.rechargeLimit)

		-- GetElement(self.m_root,"txtM3DiscountWord_CellWelcomeBackItem",WZUILabelTTF):setText(LocalStrings.NEWSHOP12)
		local txtM3DiscountVal = GetElement(self.m_root, "txtM3DiscountVal_CellWelcomeBackItem", WZUILabelTTF)
		txtM3DiscountVal:setText(math.ceil(self.m_tData.rechargeConfig[2]/self.m_tData.rechargePrice*100).."%")

		local itemInfo = GDatatab_item["id_"..self.m_tData.rechargeConfig[1]]
		local strFormat = [[<I Z="0.4" P="1">%s</I><T C="127,70,26" S="18" P="1">%s</T><T C="127,70,26" S="18" P="1"> %s</T>]]
		GetElement(self.m_root,"ftbM3Buy_CellWelcomeBackItem",WZUIFreeTextBox):setShowText(string.format(strFormat, itemInfo.icon, self.m_tData.rechargeConfig[2], LocalStrings.BUY))

		self:updateStatue()
	end

end

function CellWelcomeBackItem:onTips(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    local rootTemp = WndWelcomeBackActivity.m_root
   	WndItemInfo:showInfo(tCell.m_root, rootTemp,1,tData,false,nil,true)
end

function CellWelcomeBackItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    local rootTemp = WndWelcomeBackActivity.m_root
   	WndItemInfo:showInfo(tCell.m_root, rootTemp,1,tData,false,nil,true)
end

--@brief 	修改奖励状态
function CellWelcomeBackItem:updateStatue(status)
	if status then
		self.m_tData.status = status
	end

	if self.m_bIsLoaded ~= true then return end

	if self.m_tData.type == 1 then
		local btnSign = GetElement(self.m_root, "btnSign_CellWelcomeBackItem", WZUIButton)
		local conDone = GetElement(self.m_root, "conDone_CellWelcomeBackItem", WZUIContainer)
		local txtBtnSign = GetElement(self.m_root, "txtBtnSign_CellWelcomeBackItem", WZUILabelTTF)
		if self.m_tData.status == -1 then
			conDone:setVisible(false)
			btnSign:setVisible(false)
		elseif self.m_tData.status == 0 then
			conDone:setVisible(false)
			btnSign:setVisible(true)
			txtBtnSign:setText(LocalStrings.INVITE_RECEIVE)
		elseif self.m_tData.status == 1 then
			conDone:setVisible(true)
			btnSign:setVisible(false)
		elseif self.m_tData.status == 2 then
			conDone:setVisible(false)
			btnSign:setVisible(true)
			txtBtnSign:setText(LocalStrings.NEWSINGIN5)
		end
	elseif self.m_tData.type == 2 then
		local btnM2Clock = GetElement(self.m_root, "btnM2Clock_CellWelcomeBackItem", WZUIButton)
		local imgM2Clock = GetElement(self.m_root, "imgM2Clock_CellWelcomeBackItem", WZUIImage)
		local txtM2BtnClock = GetElement(self.m_root, "txtM2BtnClock_CellWelcomeBackItem", WZUILabelTTF)
		if self.m_tData.status == -1 then
			imgM2Clock:setVisible(false)
			btnM2Clock:setVisible(false)
		elseif self.m_tData.status == 0 then
			imgM2Clock:setVisible(false)
			btnM2Clock:setVisible(true)
			txtM2BtnClock:setText(LocalStrings.FOOTMARK_TEXT29)
		elseif self.m_tData.status == 1 then
			imgM2Clock:setVisible(true)
			btnM2Clock:setVisible(false)
		elseif self.m_tData.status == 2 then
			imgM2Clock:setVisible(false)
			btnM2Clock:setVisible(true)
			txtM2BtnClock:setText(LocalStrings.NEWSINGIN5)
		end
	elseif self.m_tData.type == 3 then
		local btnM3Buy = GetElement(self.m_root, "btnM3Buy_CellWelcomeBackItem", WZUIButton)
		local imgM3Buy = GetElement(self.m_root, "imgM3Buy_CellWelcomeBackItem", WZUIImage)

		if self.m_tData.rechargeBuyNum < self.m_tData.rechargeLimit then
			btnM3Buy:setVisible(true)
			imgM3Buy:setVisible(false)
		else
			btnM3Buy:setVisible(false)
			imgM3Buy:setVisible(true)
		end

	end
end

--@brief 	点击打卡按钮回调
function CellWelcomeBackItem:onClickSign(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

	
    if self.m_tData.type == 1 then
		self:doSign()
	elseif self.m_tData.type == 2 then
		if self.m_tData.recharge < self.m_tData.rechargeNum[1] then
			local tCustomUIConfig = {MSGBOXUICFG_CANCEL=LocalStrings.CANCEL}
			MsgBoxManager:showConfirmBox(LocalStrings.ACITVITY_WELCOME_BACK[10], self, self.sureSign, nil, tCustomUIConfig, nil, nil, nil, self.cancelSign)
		else
			self:doSign()
		end
	end

end


function CellWelcomeBackItem:cancelSign()
end

function CellWelcomeBackItem:sureSign(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        self:doSign()
    end
end

--@brief 	点击打卡按钮回调
function CellWelcomeBackItem:doSign()
	if self.m_tData.status == 0 then
		self:sureToUseBlueDia()
	else
		local strContent = LocalStrings.SPRINGOUTING_TEXT1[23]
		local costFormat = [[<I Z="0.5" P="1">%s</I><T C="127,70,26" S="22" P="1">*%d</T>]]
		local costComma = [[<T C="127,70,26" S="22" P="1">,</T>]]
		local basicInfo = GDatatab_item["id_" .. self.m_tData.signConfig[1]]
		local nBuNum
		if self.m_tData.type == 1 then
			nBuNum = WndWelcomeBackActivity:getOtherData().buSignNum
		elseif self.m_tData.type == 2 then
			nBuNum = WndWelcomeBackActivity:getOtherData().buKaNum
		end
		local costNum = self.m_tData.signConfig[2] + nBuNum * self.m_tData.signConfig[3]
		local tempStr = string.format(costFormat, basicInfo.icon, costNum)
		if i ~= 1 then 
			strContent = strContent .. costComma
		end
		strContent = strContent .. tempStr

		strContent = strContent .. LocalStrings.SPRINGOUTING_TEXT1[24]
		local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.SPRINGOUTING_TEXT1[22], bgPath = "ui/newActivity/hd_pic_hyhl_tc_xiao.png", bShowClose = true}
		MsgBoxManager:showConfirmBox(strContent, self, self.sureToResign, nil, tCustomUIConfig, true)
	end
end

--@brief 	点击打卡按钮回调
function CellWelcomeBackItem:sureToResign(element)
	local nBuNum
	if self.m_tData.type == 1 then
		nBuNum = WndWelcomeBackActivity:getOtherData().buSignNum
	elseif self.m_tData.type == 2 then
		nBuNum = WndWelcomeBackActivity:getOtherData().buKaNum
	end
	local costNum = self.m_tData.signConfig[2] + nBuNum * self.m_tData.signConfig[3]
	if not JudgeMoneyIsEnough(self.m_tData.signConfig[1], costNum, nil, nil, nil, nil, nil, nil, nil, self, self.sureToUseBlueDia) then 
		return
	end
	self:sureToUseBlueDia()
end

--@brief 	确定购买
function CellWelcomeBackItem:sureToUseBlueDia()
	WZLog("CellWelcomeBackItem:sureToUseDiamond")
	local tData = {}
	tData.day = self.m_tData.index - 1
	local stringData = json.encode(tData)
	local doType = 2
	if self.m_tData.type == 1 then
		doType = 2
	elseif self.m_tData.type == 2 then
		doType = 3
	end
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tData.activityId, doType, stringData )
end

--@brief 	购买礼包
function CellWelcomeBackItem:onClickM3Buy(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if not JudgeMoneyIsEnough(self.m_tData.rechargeConfig[1], self.m_tData.rechargeConfig[2], nil, nil, nil, nil, nil, nil, nil, self, self.sureBuy) then 
		return
	end
	self:sureBuy()
end

--@brief 	确定购买
function CellWelcomeBackItem:sureBuy()
	local tData = {}
	tData.id = self.m_tData.index - 1
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(WndWelcomeBackActivity.m_nActivityId, 7, strJson)
end
-------------------------------------CellWelcomeBackItem----------------------------------------


----------------------------------------语言适配Begin---------------------------------------

function CellWelcomeBackItem:_adaptLanguage_vn(  )
	GetElement(self.m_root, "ftbM2Attr_CellWelcomeBackItem", WZUIFreeTextBox):setScale(0.6)

	local txtM3DiscountWord = GetElement(self.m_root,"txtM3DiscountWord_CellWelcomeBackItem",WZUILabelTTF)
	txtM3DiscountWord:setFontSize(10)
	txtM3DiscountWord:setDimensions(GlobalMethod:CCSize(40,0))
	txtM3DiscountWord:setRelativePosition(GlobalMethod:ccp(0.58,0.26))
end

---------------------------------------语言适配End-----------------------------------------
