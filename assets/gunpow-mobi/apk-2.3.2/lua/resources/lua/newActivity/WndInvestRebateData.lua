--WndInvestRebateData.lua
--@brief	WndInvestRebate的数据模块
--@date		2020/05/15
--@author	XTX
--@note		投资返利活动

WndInvestRebate = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndInvestRebate:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nActivityId = nil 
	self.m_sContent = nil 
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nServerTime = nil 
	self.m_nCount = nil 
	self.m_nMaxCount = nil 
	self.m_tRewardData = nil 
	self.m_tBoxData = nil 
	self.m_tTips = nil 
	self.m_nLoadingId = nil 
	self.m_tAllCell = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndInvestRebate:_unInit()
	self.m_root = nil
	self.m_nActivityId = nil 
	self.m_sContent = nil 
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nServerTime = nil 
	self.m_nCount = nil 
	self.m_nMaxCount = nil 
	self.m_tRewardData = nil 
	self.m_tBoxData = nil 
	self.m_tTips = nil 
	self.m_nLoadingId = nil 
	self.m_tAllCell = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndInvestRebate:createElement()
	if WndInvestRebate.m_root ~= nil then
		WindowManager:removeWindow(WndInvestRebate.m_root, WndInvestRebate, true)
	end
	local element = WZUISystem:getInstance():createElement("WndInvestRebate")
	assert(element, "WndInvestRebate create element failed!")
	self:_init()
	return element
end

--@brief 	设置活动数据
function WndInvestRebate:setMessage(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
	-- body
	self.m_nActivityId = activityId 
	self.m_sContent = content 
	self.m_tTips = tips
	self.m_nStartTime = startTime 
	self.m_nEndTime = endTime 
	self.m_nServerTime = serverTime 
	self.m_nCount = count 
	self.m_nMaxCount = maxCount   
	WZLog("WndInvestRebate:setMessage 000", activityId, content, Serialize(tips), startTime, endTime, serverTime, self.m_nCount)
	--奖励数据
	self.m_tRewardData = {}
	local nIndex = 1
	for i = 1, #self.m_tTips do
		local tItem = {}
		tItem.rewardId = rewardId[i]
		tItem.status = status[i]
		tItem.tips = target[i]
		tItem.rechargeId = tonumber(tips[i])
		tItem.reward = {}
		for j = 1, rewardCounts[i] do
			if rewardItems[nIndex] ~= -1 then
				table.insert(tItem.reward, {rewardItems[nIndex], rewardItemsParamCount[nIndex]})
			end
			nIndex = nIndex + 1
		end

		table.insert(self.m_tRewardData, tItem)
	end
	table.sort(self.m_tRewardData, function (a, b)
		-- body
		return a.rewardId < b.rewardId
	end)
	WZLog("WndInvestRebate:setMessage 111", Serialize(rewardCounts), Serialize(status), Serialize(rewardId), Serialize(target), Serialize(self.m_tRewardData))
	--宝箱数据
	self.m_tBoxData = {}
	local nCountIndex = #self.m_tTips
	for i = 1, 5 do
		local tItem = {}
		tItem.rewardId = rewardId[nCountIndex + i]
		tItem.target = target[nCountIndex + i]
		tItem.status = status[nCountIndex + i]
		tItem.reward = {}
		for j = 1, rewardCounts[nCountIndex + i] do
			table.insert(tItem.reward, {rewardItems[nIndex], rewardItemsParamCount[nIndex]})

			nIndex = nIndex + 1
		end

		table.insert(self.m_tBoxData, tItem)
	end
	WZLog("WndInvestRebate:setMessage 222", Serialize(self.m_tBoxData))
end

--@brief    显示物品结果信息
--@parmas   itemId 物品Id  0为首充
function WndInvestRebate:showRewardBox(itemsId, count)
    self:_closeLoading()
    WZLog("WndInvestRebate:showRewardBox", Serialize(itemsId), Serialize(count))
    WndRewardShow:showById(itemsId, count)
    WndRewardShow:closeCallBack(WndInvestRebate, WndInvestRebate._regetActivityData, _G, pushEquipInList) 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   创建加载框
function WndInvestRebate:_createLoading()
	if self.m_nLoadingId == nil then 
		self.m_nLoadingId = MsgBoxManager:showLoadingBox()
	end
end

--@brief   关闭加载框
function WndInvestRebate:_closeLoading()
	if self.m_nLoadingId then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
		self.m_nLoadingId = nil 
	end
end

--@brief 	刷新界面
function WndInvestRebate:_regetActivityData()
	-- body
	WndFrameActivity:_ActivityContext(g_tGameActivityTypes.ACTIVITY_INVESTREBATE)
end


-------------------------------------私有方法模块End----------------------------------------
