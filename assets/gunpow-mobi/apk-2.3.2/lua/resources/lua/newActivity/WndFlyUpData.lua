--WndFlyUpData.lua
--@brief	WndFlyUp的数据模块
--@date		2022/12/06
--@author	XTX
--@note		飞升仙界

WndFlyUp = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFlyUp:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nActivityId = nil 
	self.m_tItemIdList = {160370, 160371, 160372, 160373, 160374}
	self.m_tAcuPointData = nil 			--穴位数据
	self.m_tFlyupRewards = nil 			--飞升奖励	
	self.m_nCoinId = nil 			--选中消耗的丹药
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_bOpenState = false 
	self.m_tItemCell = nil 
	self.m_tOpenResult = nil 
	self.m_tBallAniName = {"wait_1"}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFlyUp:_unInit()
	self.m_root = nil
	self.m_nActivityId = nil 
	self.m_tItemIdList = nil 
	self.m_tAcuPointData = nil 			--穴位数据
	self.m_tFlyupRewards = nil 			--飞升奖励	
	self.m_nCoinId = nil 			--选中消耗的丹药
	self.m_nMaxLotteryCount = nil    --最大抽奖次数
	self.m_bOpenState = nil 
	self.m_tItemCell = nil 
	self.m_tOpenResult = nil 
	self.m_tBallAniName = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFlyUp:createElement()
	if WndFlyUp.m_root ~= nil then
		WindowManager:removeWindow(WndFlyUp.m_root, WndFlyUp, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFlyUp")
	assert(element, "WndFlyUp create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndFlyUp:showInterface(activityId)
	local wndWater = WndFlyUp:createElement()
	if wndWater then 
		self.m_nActivityId = activityId
		WindowManager:addWindow(wndWater, WndFlyUp, false, nil, nil, true)
	end
end

--@brief 	获取穴位激活数据
function WndFlyUp:setAcupointData(itemIds, progressNum)
	WZLog("WndFlyUp:setAcupointData", Serialize(itemIds), Serialize(progressNum))
	self.m_tAcuPointData = {}

	local nCount = #itemIds
	for i = 1, nCount do
		local tItem = {}
		tItem.indexId = itemIds[i][1]
		tItem.id = itemIds[i][2]
		tItem.target = itemIds[i][3]
		tItem.progress = progressNum[i][2]

		table.insert(self.m_tAcuPointData, tItem)
	end

	self:_drawAcupoint()
end

--@brief 	获取其他活动数据
function WndFlyUp:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --获取数据
		local tResult = json.decode(jsonData)
		WZLog("WndFlyUp:_onGetOtherData 111", Serialize(tResult))
		self:setAcupointData(tResult.flyUpConfig, tResult.flyUpData) 
		self:_update()
	elseif doType == 4 then --飞升结果
		local tResult = json.decode(jsonData)
		WZLog("WndFlyUp:_onGetOtherData 444", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --飞升仙界奖

		local rewardType = 8 
		if tResult.itemNums then 
			for i = 1, #tResult.itemNums do
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.itemNums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				table.insert(self.m_tOpenResult.normalRewards, tItem)
			end
		end

		--大奖
		if tResult.flyUpItemIds then 
			for j = 1, #tResult.flyUpItemIds do
				local tItem = {}

				tItem.itemId = tResult.flyUpItemIds[j]
				tItem.itemNum = tResult.flyUpItemNums[j]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_xxz_fsxjjd.png"
				tItem.imgTitle = "ui/activityWords/bt_text_xxz_fsxjj.png"
				tItem.imgTitleWordsPt = GlobalMethod:ccp(0.5, 1.05)
				tItem.titlePt = GlobalMethod:ccp(0.5, 1.15)
				tItem.goodsconPt = GlobalMethod:ccp(0.5, 0.5)
				tItem.txtBtnWords = LocalStrings.BEINGIMMORTAL_TEXT1[13]
			--	tItem.spineEffect = {path = "activity/ui_quanleida_ptj", _sIndex = "ui_quanleida_ptj", play = "wait1"}

				table.insert(self.m_tOpenResult.firstRewards, tItem)
			end
		end

		if result == 1 then 
			self:showOpenAction()
			self:updateAcupointData(tResult.flyUpData)
		else
			self:setOpenState(false)
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndFlyUp:updatePlayerItemData()
	WZLog("WndFlyUp:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_createItemList(true)
	end
end

--@brief 	设置射箭的状态
function WndFlyUp:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndFlyUp:_afterCloseReward()
	if self.m_root == nil then return end 

	local tBigReward = {}
	local nIndex = 1
	if self.m_tOpenResult.firstRewards and #self.m_tOpenResult.firstRewards > 0 then 
		table.insert(tBigReward, self.m_tOpenResult.firstRewards)
	end

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, nil, tBigReward)
	end
end

--@brief 	获取某穴位还需要多少丹药点亮
function WndFlyUp:_getNeedNum(itemId)
	local needNum = 0 
	for i = 1, #self.m_tAcuPointData do
		if self.m_tAcuPointData[i].id == itemId then 
			needNum = self.m_tAcuPointData[i].target - self.m_tAcuPointData[i].progress
			break 
		end
	end

	return needNum
end

--@brief 	获取穴位激活数据
function WndFlyUp:updateAcupointData(progressNum)
	local nCount = #progressNum/2
	for i = 1, nCount do
		for j = 1, #self.m_tAcuPointData do
			if progressNum[2*i - 1] == self.m_tAcuPointData[j].indexId then 
				self.m_tAcuPointData[j].progress = progressNum[i*2]
				break 
			end
		end
	end

	self:_drawAcupoint()
end

-------------------------------------私有方法模块End----------------------------------------
