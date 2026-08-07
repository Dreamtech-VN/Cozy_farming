--CellGrowupHaveData.lua
--@brief	CellGrowupHave的数据模块
--@date		2020/11/30
--@author	hyx
--@note		成长必备

CellGrowupHave = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellGrowupHave:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sBuyResultTicker = nil
	self.m_tRewardData = {}
	self.m_nMaxCount = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellGrowupHave:_unInit()
	self.m_root = nil
	self.m_sBuyResultTicker = nil
	self.m_tRewardData = {}
	self.m_nMaxCount = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellGrowupHave:createElement(activityId, activityType)
	if CellGrowupHave.m_root ~= nil then
		WindowManager:removeWindow(CellGrowupHave.m_root, CellGrowupHave, true)
	end
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellGrowupHave")
	assert(element, "ActivityAnswer create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self.m_nGameActivityId = activityId
	self.m_nGameActivityType = activityType
	return element, tNewObj
end
--协议返回的信息
function CellGrowupHave:setActivityReturnInfo(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	self.m_nStartTime = startTime
	self.m_nEndTime = endTime

	self.m_nMaxCount = maxCount
	local index = 1
	local table_insert = table.insert
	for i=1,#rewardCounts do
		local tab = {}

		tab.maxCount = maxCount
		tab.change_id = rewardId[i]
		tab.count = status[i]
		tab.old_price = target[i]

		local ids = {}
		local nums = {}
		for m=1,rewardCounts[i] do
			table_insert(ids, rewardItems[index])
			table_insert(nums, rewardItemsParamCount[index])
			index = index + 1
		end
		tab.ids = ids
		tab.nums = nums
		self.m_tRewardData[i] = tab
	end
end

function CellGrowupHave:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
--==========================================
CellGrowupHaveItem = {}
function CellGrowupHaveItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellGrowupHaveItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellGrowupHaveItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(200,350))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellGrowupHaveItem:setMessage(index, data)
	self.m_nIndex = index
	self.m_sGrowUpData = data
end

--@brief 	开始加载
function CellGrowupHaveItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellGrowupHaveItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setGrowupHaveDataItem()
end

function CellGrowupHaveItem:setGrowupHaveDataItem()
	if not self.m_sGrowUpData then return end
	local data = self.m_sGrowUpData
	local giftName = GetElement(self.m_root,"giftName",WZUILabelTTF)
	local str_gift = {LocalStrings.WEAPON,LocalStrings.ASCENDING45,LocalStrings.DRESS,LocalStrings.PHANTOM_NEWTEXT22,LocalStrings.PARTNER_2,
					  LocalStrings.WING,LocalStrings.BAG7}
	giftName:setText(str_gift[self.m_nIndex]..LocalStrings.BAG19)
	GetElement(self.m_root,"old_price",WZUILabelTTF):setText(LocalStrings.NEWSHOP15..data.old_price)

	local sellOut_CellGrowupHave = GetElement(self.m_root,"sellOut_CellGrowupHave",WZUIContainer)
	sellOut_CellGrowupHave:setVisible(data.count >= data.maxCount)

	local config = GDatatab_recharge["id_"..data.change_id]
	local price = 0
	if config then
		price = config.unit
	end
	GetElement(self.m_root,"new_price",WZUILabelTTF):setText(LocalStrings.LIMITE_BUY_CURPRICE..": "..price)
end

function CellGrowupHaveItem:setBuyFunc(func)
	self.m_sBuyFunc = func
end

function CellGrowupHaveItem:onBtnGrowupBuy()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_sBuyFunc and self.m_sGrowUpData then
		self.m_sBuyFunc(self.m_sGrowUpData.change_id, self.m_sGrowUpData.count)
	end
end
function CellGrowupHaveItem:onBtnCheckGift()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_sGrowUpData then
		local ids = self.m_sGrowUpData.ids
		local nums = self.m_sGrowUpData.nums
		WndJoinReward:showInterface(LocalStrings.OPTIMIZE_TEXT29,ids,nums,LocalStrings.BAG19)
	end
end
--@return	新建的表实例对象
function CellGrowupHaveItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
