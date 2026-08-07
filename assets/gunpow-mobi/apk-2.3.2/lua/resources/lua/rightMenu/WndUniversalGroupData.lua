--WndUniversalGroup Data.lua
--@brief	WndUniversalGroup 的数据模块
--@date		2020/05/26
--@author	XTX
--@note		全民团购界面

WndUniversalGroup = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndUniversalGroup:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nActivityId = nil  
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nServerTime = nil 
	self.m_nCount = nil 
	self.m_tRewardData = nil 
	self.m_tBoxData = nil 
	self.m_tTips = nil 
	self.m_nLoadingId = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndUniversalGroup:_unInit()
	self.m_root = nil
	self.m_nActivityId = nil  
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nServerTime = nil 
	self.m_nCount = nil 
	self.m_tRewardData = nil 
	self.m_tBoxData = nil 
	self.m_tTips = nil 
	self.m_nLoadingId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndUniversalGroup:createElement()
	if WndUniversalGroup.m_root ~= nil then
		WindowManager:removeWindow(WndUniversalGroup.m_root, WndUniversalGroup, true)
	end
	local element = WZUISystem:getInstance():createElement("WndUniversalGroup")
	assert(element, "WndUniversalGroup create element failed!")
	self:_init()
	return element
end

--@brief 	设置活动数据
function WndUniversalGroup:setMessage(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
	-- body
	self.m_nActivityId = activityId 
	self.m_tTips = tips
	self.m_nStartTime = startTime 
	self.m_nEndTime = endTime 
	self.m_nServerTime = serverTime 
	self.m_nCount = count  
	WZLog("WndUniversalGroup:setMessage 000", activityId, content, Serialize(tips), startTime, endTime, serverTime, self.m_nCount)
	--奖励数据
	self.m_tRewardData = {}
	local nIndex = 1
	local nRechargeNum = #self.m_tTips/3
	for i = 1, nRechargeNum do
		local tItem = {}
		tItem.rewardId = rewardId[i]
		tItem.status = status[i]
		tItem.rechargeId = self:_getCorrectRechargeId(tonumber(tips[i]))
		tItem.originPrice = tonumber(tips[2 * nRechargeNum + i])
		local vipData = GDatatab_recharge["id_" .. tItem.rechargeId]
		tItem.discount = tonumber(math.ceil(100 * (tonumber(vipData.price))/tItem.originPrice)/10)
		tItem.reward = {}
		for j = 1, rewardCounts[i] do
			table.insert(tItem.reward, {rewardItems[nIndex], rewardItemsParamCount[nIndex]})

			nIndex = nIndex + 1
		end

		table.insert(self.m_tRewardData, tItem)
	end
	table.sort(self.m_tRewardData, function (a, b)
		-- body
		return a.rewardId < b.rewardId
	end)
	WZLog("WndUniversalGroup:setMessage 111", Serialize(rewardCounts), Serialize(status), Serialize(rewardId), Serialize(target), Serialize(self.m_tRewardData))
	--宝箱数据
	self.m_tBoxData = {}
	local nCountIndex = nRechargeNum
	for i = 1, 6 do
		local tItem = {}
		tItem.rewardId = rewardId[nCountIndex + i]
		tItem.target = target[i]
		tItem.status = status[nCountIndex + i]
		tItem.reward = {}
		for j = 1, rewardCounts[nCountIndex + i] do
			table.insert(tItem.reward, {rewardItems[nIndex], rewardItemsParamCount[nIndex]})

			nIndex = nIndex + 1
		end

		table.insert(self.m_tBoxData, tItem)
	end
	WZLog("WndUniversalGroup:setMessage 222", Serialize(self.m_tBoxData))
end

--@brief    显示物品结果信息
--@parmas   itemId 物品Id  0为首充
function WndUniversalGroup:showRewardBox(itemsId, count)
    WndGameActivity:_closeLoading()
    WZLog("WndUniversalGroup:showRewardBox", Serialize(itemsId), Serialize(count))
    WndRewardShow:showById(itemsId, count)

    WndRewardShow:closeCallBack(WndUniversalGroup, WndUniversalGroup._regetActivityData, _G, pushEquipInList) 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新界面
function WndUniversalGroup:_regetActivityData()
	-- body
	if self.m_root == nil then return end 
	
	WndGameActivity:refreshActivityContext()
end

--@brief 	根据服务器发下来的充值id，查找对应渠道号的充值Id
function WndUniversalGroup:_getCorrectRechargeId(rechargeId)
	-- body
	local vipData = GDatatab_recharge["id_" .. rechargeId]

	if vipData == nil then return rechargeId end 

	for i, value in pairs(GDatatab_recharge) do
		if value.sort == vipData.sort and value.type == vipData.type then 
			return value.id
		end
	end

	return rechargeId 
end


-------------------------------------私有方法模块End----------------------------------------
