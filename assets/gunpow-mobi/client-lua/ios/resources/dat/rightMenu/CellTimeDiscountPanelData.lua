--CellTimeDiscountPanelData.lua
--@brief	CellTimeDiscountPanel的数据模块
--@date		2016/08/11
--@author	Tianxiang_Xu
--@note		限时折扣活动

CellTimeDiscountPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellTimeDiscountPanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nStartTime = nil 	
	self.m_nEndTime = nil 
	self.m_rewardId = nil 
	self.m_target = nil 
	self.m_activityId = nil 
	self.m_rewardItems = nil 
	self.m_tCellList = nil 
	self.m_nloadingId = nil 
	self.m_rewardCounts = nil 
	self.m_rewardItemsParamCount = nil 
	self.m_nClickRewardId = nil 
	self.m_nActivityType = nil 
	self.m_tClickData = nil 
	self.m_tNeedVip = nil 
	self.m_nLeftSeconds = nil  
	self.m_tCurPrice = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellTimeDiscountPanel:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 	
	self.m_nEndTime = nil 
	self.m_rewardId = nil 
	self.m_target = nil 
	self.m_activityId = nil 
	self.m_rewardItems = nil
	self.m_tCellList = nil 
	self.m_nloadingId = nil 
	self.m_rewardCounts = nil 
	self.m_rewardItemsParamCount = nil 
	self.m_nClickRewardId = nil 
	self.m_nActivityType = nil 
	self.m_tClickData = nil 
	self.m_tNeedVip = nil 
	self.m_nLeftSeconds = nil  
	self.m_tCurPrice = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellTimeDiscountPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellTimeDiscountPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellTimeDiscountPanel")
	assert(element, "CellTimeDiscountPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellTimeDiscountPanel:setMessage(activityId, startTime, endTime, rewardId, rewardItems, target, rewardCounts, rewardItemsParamCount, activityType)
	-- body
	self.m_activityId = activityId
	self.m_nStartTime = startTime 	
	self.m_nEndTime = endTime
	self.m_rewardId = rewardId 
	self.m_target = target 
	self.m_rewardItems = rewardItems
	self.m_rewardCounts = rewardCounts 
	self.m_rewardItemsParamCount = rewardItemsParamCount 
	self.m_nActivityType = activityType

	WZLog("CellTimeDiscountPanel:setMessage", Serialize(rewardItems), Serialize(target), Serialize(self.m_rewardCounts), Serialize(self.m_rewardItemsParamCount))
end

--@brief 	设置开服活动-折扣限购数据
function CellTimeDiscountPanel:setMessage_newServer(configId, originPrice, curPrice, needVip, reward, timesLimit, times, countdown, activityType)
	-- body
	self.m_nActivityType = activityType
	self.m_nStartTime, self.m_nEndTime, self.m_activityId = WndGameActivity:getActivityTime(activityType)

	self.m_rewardId = configId
	self.m_target = originPrice
	self.m_tCurPrice = curPrice
	self.m_tNeedVip = needVip 
	self.m_rewardItems = reward
	self.m_rewardCounts = timesLimit
	self.m_rewardItemsParamCount = times            --已经购买的次数
	self.m_nLeftSeconds = countdown  

	WZLog("CellTimeDiscountPanel:setMessage_newServer", Serialize(self.m_target), Serialize(self.m_tCurPrice))
end

--@brief 	购买物品成功
function CellTimeDiscountPanel:ACTIVITY_BuyGoodsOk(rewardItems,rewardCount)
	--body
	MsgBoxManager:stopLoadingBoxByMsgId(CellTimeDiscountPanel.m_current.m_nloadingId)
	--减去相应数量的物品
	for k = 1, #rewardItems do
		for i = 1, #CellTimeDiscountPanel.m_current.m_tCellList do
			local tData = CellTimeDiscountPanel.m_current.m_tCellList[i]:getData()
			if tData.id == rewardItems[k] and self.m_nClickRewardId == tData.rewardId then
				if tData.times >= 1 then
					tData.times = tData.times - 1
				end
				CellTimeDiscountPanel.m_current.m_tCellList[i]:refreshItem(tData)
			end
		end
	end
	--展示购买的物品数量
	WndRewardShow:showById(rewardItems,rewardCount)
	WndRewardShow:closeCallBack(CellTimeDiscountPanel.m_current,CellTimeDiscountPanel.m_current._GetRewardOk, _G, pushEquipInList)

	--刷新界面
	WndGameActivity:refreshActivityContext()
end

--@brief 	
function CellTimeDiscountPanel:_GetRewardOk()
	-- body
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellTimeDiscountPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellTimeDiscountPanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
