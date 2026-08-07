--WndInvestRebateNorData.lua
--@brief	WndInvestRebateNor的数据模块
--@date		2020/12/03
--@author	XTX
--@note		投资返利-常规活动模板

WndInvestRebateNor = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndInvestRebateNor:_init()
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
function WndInvestRebateNor:_unInit()
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
function WndInvestRebateNor:createElement()
	if WndInvestRebateNor.m_root ~= nil then
		WindowManager:removeWindow(WndInvestRebateNor.m_root, WndInvestRebateNor, true)
	end
	local element = WZUISystem:getInstance():createElement("WndInvestRebateNor")
	assert(element, "WndInvestRebateNor create element failed!")
	self:_init()
	return element
end

--@brief 	设置活动数据
function WndInvestRebateNor:setMessage(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
	--
	self.m_nActivityId = activityId 
	self.m_sContent = content 
	self.m_tTips = tips
	self.m_nStartTime = startTime 
	self.m_nEndTime = endTime 
	self.m_nServerTime = serverTime 
	self.m_nCount = count 
	self.m_nMaxCount = maxCount   
	WZLog("WndInvestRebateNor:setMessage 000", activityId, content, Serialize(tips), startTime, endTime, serverTime, self.m_nCount)
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
	WZLog("WndInvestRebateNor:setMessage 111", Serialize(rewardCounts), Serialize(status), Serialize(rewardId), Serialize(target), Serialize(self.m_tRewardData))
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
	WZLog("WndInvestRebateNor:setMessage 222", Serialize(self.m_tBoxData))
end

--@brief    显示物品结果信息
--@parmas   itemId 物品Id  0为首充
function WndInvestRebateNor:showRewardBox(itemsId, count)
    self:_closeLoading()
    WZLog("WndInvestRebateNor:showRewardBox", Serialize(itemsId), Serialize(count))
    WndRewardShow:showById(itemsId, count)
    WndRewardShow:closeCallBack(WndInvestRebateNor, WndInvestRebateNor._regetActivityData, _G, pushEquipInList) 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndInvestRebateNor:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	WndInvestRebateNor.m_current = tNewObj
	return tNewObj
end

--@brief   创建加载框
function WndInvestRebateNor:_createLoading()
	if self.m_nLoadingId == nil then 
		self.m_nLoadingId = MsgBoxManager:showLoadingBox()
	end
end

--@brief   关闭加载框
function WndInvestRebateNor:_closeLoading()
	if self.m_nLoadingId then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
		self.m_nLoadingId = nil 
	end
end

--@brief 	刷新界面
function WndInvestRebateNor:_regetActivityData()
	-- body
	WndGameActivity:refreshActivityContext()
end





-------------------------------------私有方法模块End----------------------------------------
