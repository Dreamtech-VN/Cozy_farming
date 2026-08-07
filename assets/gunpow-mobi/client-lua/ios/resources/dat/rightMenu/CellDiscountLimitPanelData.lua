--CellDiscountLimitPanelData.lua
--@brief	CellDiscountLimitPanel的数据模块
--@date		2017/07/19
--@author	Tianxiang_Xu
--@note		折扣限购活动，可以配置消耗货币类型

CellDiscountLimitPanel = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellDiscountLimitPanel:_init()
	self.m_root = nil	 	  			--场景根节点
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
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDiscountLimitPanel:_unInit()
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
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellDiscountLimitPanel:createElement()
	if CellDiscountLimitPanel.m_root ~= nil then
		WindowManager:removeWindow(CellDiscountLimitPanel.m_root, CellDiscountLimitPanel, true)
	end
	local element = WZUISystem:getInstance():createElement("CellDiscountLimitPanel")
	assert(element, "CellDiscountLimitPanel create element failed!")
	self:_init()
	return element
end
--@brief 	设置数据
function CellDiscountLimitPanel:setMessage(activityId, startTime, endTime, rewardId, rewardItems, target, rewardCounts, rewardItemsParamCount, activityType)
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

	WZLog("CellDiscountLimitPanel:setMessage", Serialize(rewardItems), Serialize(target), Serialize(self.m_rewardCounts), Serialize(self.m_rewardItemsParamCount))
end

--@brief 	购买物品成功
function CellDiscountLimitPanel:ACTIVITY_BuyGoodsOk(rewardItems,rewardCount)
	--body
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nloadingId)
	--减去相应数量的物品
	for k = 1, #rewardItems do
		for i = 1, #self.m_tCellList do
			local tData = self.m_tCellList[i]:getData()
			if tData.id == rewardItems[k] and self.m_nClickRewardId == tData.rewardId then
				if tData.times >= 1 then
					tData.times = tData.times - 1
				end
				self.m_tCellList[i]:refreshItem(tData)
			end
		end
	end
	--展示购买的物品数量
	WndRewardShow:showById(rewardItems,rewardCount)
	WndRewardShow:closeCallBack(self,self._GetRewardOk, _G, pushEquipInList)

	--刷新界面
	WndGameActivity:refreshActivityContext()
end

--@brief 	
function CellDiscountLimitPanel:_GetRewardOk()
	-- body
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
