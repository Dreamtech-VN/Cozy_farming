--WndNationalFestival.lua
--@brief	WndNationalFestival的UI模块
--@date		2020/09/07
--@author	hyx
--@note		国庆签到


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndNationalFestival:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndNationalFestival:onExit(element)
	self:_unInit()
	self:unregister()
end

function WndNationalFestival:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetFestivalLoginInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onFestivalGetResult,self)
end
function WndNationalFestival:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetFestivalLoginInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onFestivalGetResult,self)
end

function WndNationalFestival:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndNationalFestival:actionCallback()
	self:initShow()
end
function WndNationalFestival:initShow()
	self:setRechargeSignIn()

	GetElement(self.m_root,"giftTipsLabel",WZUILabelTTF):setText(LocalStrings.FESTIVAL_TEXT1)
	self.openStatusLabel = GetElement(self.m_root,"openStatusLabel",WZUILabelTTF)
	
	self.statusRedPoint = GetElement(self.m_root,"statusRedPoint",WZUIImage)
	self.statusRedPoint:setVisible(false)
	local ruleTipsLabel = GetElement(self.m_root,"ruleTipsLabel",WZUIFreeTextBox)
	ruleTipsLabel:setShowText(LocalStrings.FESTIVAL_TEXT3)
	self.m_sItemFreeList = GetElement(self.m_root,"itemFreeList",WZUIFreeListContainer)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.rechargeSignInActivity ,6110)
end

function WndNationalFestival:showInterface()
	local wndNational = WndNationalFestival:createElement()
	if wndNational ~= nil then
	    WindowManager:addWindow(wndNational,WndNationalFestival,nil,false)
	end
end

function WndNationalFestival:onBtnClickRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.FESTIVAL_TEXT5)
end
--开始充值
function WndNationalFestival:onClickOpenGift()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.isOpenBigGift then return end
	if self.isOpenBigGift == 0 then
		local list = CacheCenter:getVipList()
		local change_id
		local _type, sort = self:getRechargeData()
		for i,v in pairs(list) do
			local info = GDatatab_recharge["id_" .. v.ids]
			if info then
	            if info.sort == sort and info.type == _type then
	               	change_id = info.id
	               	break
	            end
	        end
		end
		if change_id then
			local data = GDatatab_recharge["id_" .. change_id]
			--必带。id：产品id，price:价格；productName:商品名称；payCode:商品号
			if data then
				local tab = {}
				tab.id = data.id
				tab.price = data.price
				tab.number = 1
				tab.productName = data.name
				tab.payCode = GetPayCodeIdByChannelId(data)
				PassportSdkManager:getOrderNum(tab)
			end
		end
	elseif self.isOpenBigGift == 1 then
		self.extractCount = self.extractCount or 0
		local num = self:getLotteryNum()
		if (num - self.extractCount) <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.FESTIVAL_TEXT18)
		else
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(tonumber(g_cityExtenInfo.rechargeSignInActivity), 0, 2)
		end
	end
end

function WndNationalFestival:onBtnTouchReward()
	if not self.isOpenBigGift then return end

	if self.isOpenBigGift == 0 then
		local tipsReward = GetElement(self.m_root,"tipsReward",WZUIContainer)
		if tipsReward then
			tipsReward:setVisible(true)
		end
	end
end

function WndNationalFestival:onBtnClickTipReward()
	if not self.m_root then return end
	local tipsReward = GetElement(self.m_root,"tipsReward",WZUIContainer)
	if tipsReward then
		tipsReward:setVisible(false)
	end
end

function WndNationalFestival:onBtnClickClose()
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--[[
activityId: 活动ID
maxCount:0:未解锁 1:已解锁 
count: 今日已抽取随机礼包数
status 是否已领取奖励【玩家是否已领取该级别奖励(-1不可领取,0可领取，1已领取)】
rewardCounts:奖励物品(需要注意的是这个可能大于8)
rewardItems:奖励的物品
rewardItemsParamCount:奖励物品的个数
]]
function WndNationalFestival:_onGetFestivalLoginInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime)
	if g_cityExtenInfo.rechargeSignInActivity and tonumber(g_cityExtenInfo.rechargeSignInActivity) == tonumber(activityId) then
		self.isOpenBigGift = maxCount
		self.extractCount = count
		local activity_time = GetElement(self.m_root,"activity_time",WZUILabelTTF)
		activity_time:setVisible(false)
		activity_time:setText(LocalStrings.ACTIVE_TIME..": "..SystemTime:getTimeConverLocal(startTime).." - "..SystemTime:getTimeConverLocal(endTime))
		if self.openStatusLabel then
			self.openStatusLabel:setText(LocalStrings.FESTIVAL_TEXT2)
			if maxCount == 1 then
				self.openStatusLabel:setText(LocalStrings.FESTIVAL_TEXT4)
			end
		end
		self.m_tLoginGetStatus = status
		--红点
		if self.statusRedPoint then
			local red_status = false
			if maxCount == 1 then
				local num = self:getLotteryNum()
				if (num - count) > 0 then
					red_status = true
				end
			end
			self.statusRedPoint:setVisible(red_status)
		end
		if self.m_tFestivalLoginList and next(self.m_tFestivalLoginList) == nil then
			local data = self:_resolutionReward(rewardCounts, rewardItems, rewardItemsParamCount, status)
			if self.m_sItemFreeList then
				for i = 1, #data do
					local element, tLuaObj = CellNotionalFestivalItem:createElement()
					self.m_tFestivalLoginList[i] = tLuaObj
					self.m_sItemFreeList:pushBack(WZUIContainer:luaTo(element))
					self.m_sItemFreeList:getMoveElement():setPositionX(self.m_sItemFreeList:getMaxPosition().x)
					tLuaObj:setNationalFestivalMessage(i, data[i])
				end
			end
		else
			if self.m_tFestivalLoginList then
				for i,v in ipairs(self.m_tFestivalLoginList) do
					if v then
						v:setBtnGetStatus(status[i] or -1)
					end
				end
			end
		end
	end
end
--解析奖励和数量
function WndNationalFestival:_resolutionReward(rewardCounts, rewardItems, rewardItemsParamCount, status)
	local data = {}
	local item_ids = {}
	local num_ids = {}
	local index = 1
	for i=1,#rewardCounts do
		for j=1, rewardCounts[i] do
			if rewardItems[index] ~= -1 then
				item_ids[i] = rewardItems[index]
				num_ids[i] = rewardItemsParamCount[index]
			end
			index = index + 1
		end
	end
	for i=1, #item_ids do
		local tab = {}
		tab.id = item_ids[i]
		tab.num = num_ids[i]
		tab.status = status[i] or -1
		data[i] = tab
	end

	return data
end
--领取返回
function WndNationalFestival:_onFestivalGetResult(itemsId,count,_type, rewardId)
	WndRewardShow:showById(itemsId,count)
end

-------------------------------------私有方法模块End----------------------------------------

--@brief	越南适配
function WndNationalFestival:_adaptLanguage_vn()
	local ruleTipsLabel = GetElement(self.m_root,"ruleTipsLabel",WZUIFreeTextBox)
	ruleTipsLabel:setMaxWidth(750)
	ruleTipsLabel:setScale(0.8)
	ruleTipsLabel:setVisible(false)
end
