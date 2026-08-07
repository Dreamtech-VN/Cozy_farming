--WndRiseMainActivityData.lua
--@brief	WndRiseMainActivity的数据模块
--@date		2021/06/25
--@author	hyx
--@note		崛起之路

WndRiseMainActivity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRiseMainActivity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurChooseType = nil
	self.m_tRewardChooseItem = {}
	self.m_sBoxCommonObj = nil
	self.m_tBoxData = {}
	self.m_nChooseGiftType = nil
	self.m_tChooseCellItem = {} --选择的物品
	self.m_tChooseCountData = {} --计算选中的
	self.m_tChooseGiftIndex = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRiseMainActivity:_unInit()
	self.m_root = nil
	self.m_nCurChooseType = nil
	self.m_tRewardChooseItem = {}
	self.m_sBoxCommonObj = nil
	self.m_tRiseData = {}
	self.m_tBoxData = {}
	self.m_nChooseGiftType = nil
	self.m_tChooseCellItem = {}
	self.m_tChooseCountData = {}
	self.m_tChooseGiftIndex = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRiseMainActivity:createElement()
	if WndRiseMainActivity.m_root ~= nil then
		WindowManager:removeWindow(WndRiseMainActivity.m_root, WndRiseMainActivity, true)
	end
	local element = WZUISystem:getInstance():createElement("WndRiseMainActivity")
	assert(element, "WndRiseMainActivity create element failed!")
	self:_init()
	return element
end

--宝箱数据
function WndRiseMainActivity:setBoxProgressData(status,rewardItems,rewardItemsParamCount,rewardCounts,finishCondition)
	local index = 1
	local table_insert = table.insert
	local data = {}
	for i=1, #status do
		local tab = {}
		tab.id = i-1
		tab.tager = finishCondition[i]
		tab.status = status[i]
		local reward_id = {}
		local reward_num = {}
		for m=1,rewardCounts[i] do
			table_insert(reward_id,rewardItems[index])
			table_insert(reward_num,rewardItemsParamCount[index])
			index = index + 1
		end
		tab.reward_id = reward_id
		tab.reward_num = reward_num
		data[i] = tab
	end
	return data
end
--处理礼包的数据
function WndRiseMainActivity:setRiseData(data)
	if next(data.giftBuyCount) ~= nil then
		self.m_tRiseData = {}
		local index = 1
		local table_insert = table.insert
		for i=1,#data.giftBuyCount do
			local tab = {}
			tab.refreshTime = data.refreshTime
			tab.buyCount = data.giftBuyCount[i] --礼包今日已购买次数
			tab.buyLimit = data.giftBuyLimit[i] --礼包限购【-1=不限购】
			local money, id = WndEveryDayBuy:getBuyMoney(data.rechargeType[i], data.rechargeSort[i])
			tab.money = money
			tab.change_id = id

			local itemBuyCount = {}
			local itemBuyLimit = {}
			local itemId = {}
			local itemNum = {}
			local itemIndex = {}
			for m=1,data.giftSize[i] do
				table_insert(itemBuyCount, data.giftItemBuyCount[index]) --礼包中的道具今日已购买数量
				table_insert(itemBuyLimit, data.giftItemBuyLimit[index]) --礼包内道具限购【-1=不限购】
				table_insert(itemId, data.giftItemId[index]) --礼包内道具ID
				table_insert(itemNum, data.giftItemNum[index]) --礼包内道具数量
				table_insert(itemIndex, data.giftItemIndex[index]) --礼包内道具索引【道具在所属礼包道具池的位置下标，从0开始编号】
				index = index + 1
			end
			tab.itemBuyCount = itemBuyCount
			tab.itemBuyLimit = itemBuyLimit
			tab.itemId = itemId
			tab.itemNum = itemNum
			tab.itemIndex = itemIndex
			self.m_tRiseData[i] = tab
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
