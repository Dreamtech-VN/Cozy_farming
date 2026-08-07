--WndSuperSpecialActivityData.lua
--@brief	WndSuperSpecialActivity的数据模块
--@date		2023/04/12
--@author	yrd
--@note		超值特购活动

WndSuperSpecialActivity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSuperSpecialActivity:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSuperSpecialActivity:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSuperSpecialActivity:createElement()
	if WndSuperSpecialActivity.m_root ~= nil then
		WindowManager:removeWindow(WndSuperSpecialActivity.m_root, WndSuperSpecialActivity, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSuperSpecialActivity")
	assert(element, "WndSuperSpecialActivity create element failed!")
	self:_init()
	return element
end

--@brief	接收活动信息
function WndSuperSpecialActivity:getActivityInfoOK(activityId, maxCount, count, status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if activityId == tonumber(g_cityExtenInfo.activity7073) then
		self.activityId = activityId 
		self.maxCount = maxCount 
		self.count = count 
		self.status = status 
		self.rewardCounts = rewardCounts 
		self.rewardItems = rewardItems 
		self.rewardItemsParamCount = rewardItemsParamCount 
		self.startTime = startTime 
		self.endTime = endTime 
		self.content = content 
		self.rewardId = rewardId 
		self.finishCondition = finishCondition 
		self.tips = tips

		self:_updateActivityTime()
	end
end

--@brief	充值
function WndSuperSpecialActivity:_onGetRewardRiseResult(activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7073) then
		msg = json.decode(msg)
		if doType == 1 then
			-- int refreshTime	: 礼包刷新时间,
			-- int[] rechargeType	: 礼包计费点type,
			-- int[] rechargeSort	: 礼包计费点sort,
			-- int[] giftBuyLimit	: 礼包限购【-1=不限购】,
			-- int[] giftItemId	: 礼包内道具ID,
			-- int[] giftItemNum	: 礼包内道具数量,
			-- int[] giftItemBuyLimit	: 礼包内道具限购【-1=不限购】,
			-- int[] giftSize	: 礼包大小，礼包中的道具个数，用于分割礼包都内容,
			-- int[] giftBuyCount	: 礼包今日已购买次数
			if result == 1 then
				self.refreshTime = msg.refreshTime
				self.rechargeType = msg.rechargeType
				self.rechargeSort = msg.rechargeSort
				self.giftBuyLimit = msg.giftBuyLimit
				self.giftItemId = msg.giftItemId
				self.giftItemNum = msg.giftItemNum
				self.giftItemBuyLimit = msg.giftItemBuyLimit
				self.giftSize = msg.giftSize
				self.giftBuyCount = msg.giftBuyCount

				self:updateUI()
				self:startTimer()
			end
		elseif doType == 2 then
			if result == 1 then 
				self:gotoBuy(msg.rechargeId)
			end
		end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
