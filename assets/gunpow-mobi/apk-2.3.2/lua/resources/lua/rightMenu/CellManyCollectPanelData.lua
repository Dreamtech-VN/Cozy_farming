--CellManyCollectPanelData.lua
--@brief	CellManyCollectPanel的数据模块
--@date		2017/09/26
--@author	Tianxiang_Xu
--@note		全民众筹活动

CellManyCollectPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellManyCollectPanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tCollectList = nil 
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nCulateTime = 0 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellManyCollectPanel:_unInit()
	self.m_root = nil
	self.m_tCollectList = nil 
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nCulateTime = nil  
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellManyCollectPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellManyCollectPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellManyCollectPanel")
	assert(element, "CellManyCollectPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置众筹活动的数据
function CellManyCollectPanel:setMessage(configId, verifyKey, target, current, join, joinType, costItem, joinGain, randomGain, defaultNum)
	-- body
	self.m_tCollectList = {}
	self.m_nStartTime, self.m_nEndTime = WndGameActivity:getActivityTime(g_tGameActivityTypes.ACTIVITY_MANY_COLLECT)
	for i = 1, #configId do
		local tItem = {}
		tItem.rewardId = configId[i]
		tItem.verifyKey = verifyKey[i]
		tItem.curNum = current[i]
		tItem.totalNum = target[i]
		tItem.buyNum = join[i]      --已购买的股数
		tItem.joinType = joinType[i]  --类型：0:只能入股一次;1:无限制
		tItem.minBuyNum = defaultNum[i]

		local strPrice = string.sub(costItem[i],2,-2) 
		local id = SplitStringWithSeparator(strPrice,",")[1]
		local num = SplitStringWithSeparator(strPrice,",")[2]
		tItem.price = tonumber(num)
		tItem.priceId = tonumber(id)

		local strReward = string.sub(joinGain[i],2,-2) 
		id = SplitStringWithSeparator(strReward,",")[1]
		num = SplitStringWithSeparator(strReward,",")[2]
		tItem.itemId1 = tonumber(id)
		tItem.num1 = tonumber(num)

		strReward = string.sub(randomGain[i],2,-2) 
		id = SplitStringWithSeparator(strReward,",")[1]
		num = SplitStringWithSeparator(strReward,",")[2]
		tItem.itemId2 = tonumber(id)
		tItem.num2 = tonumber(num)

		table.insert(self.m_tCollectList, tItem)
	end

	table.sort(self.m_tCollectList, function (a,b)
		-- body
		return a.rewardId < b.rewardId
	end)
end

--@brief 	入股成功
function CellManyCollectPanel:ACTIVITY_ReceiveRewardOk(rewardItems, rewardCount)
	--body
	WndGameActivity:_closeLoading()
	MsgBoxManager:showTipBox(LocalStrings.MANYCOLLECT_TEXT3)
	if #rewardItems > 0 then 
		WndRewardShow:showById(rewardItems, rewardCount)
    	WndRewardShow:closeCallBack(nil,nil, _G, pushEquipInList)
	end
	if WndChooseStockNum.m_root then 
		WndChooseStockNum:closeWin()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellManyCollectPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellManyCollectPanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
