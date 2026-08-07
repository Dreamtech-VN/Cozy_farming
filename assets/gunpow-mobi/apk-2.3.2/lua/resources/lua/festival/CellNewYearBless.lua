--CellNewYearBless.lua
--@brief	CellNewYearBless的UI模块
--@date		2020/12/24
--@author	hyx
--@note		新年祈福


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewYearBless:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewYearBless:onExit(element)
	if self.m_nBtnBlessTicker then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nBtnBlessTicker)
		self.m_nBtnBlessTicker = nil
	end
	self:unregister()
	self:_unInit()
end

function CellNewYearBless:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetBlessInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetBlessResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetBoxResult,self)
end
function CellNewYearBless:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetBlessInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetBlessResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetBoxResult,self)
end
function CellNewYearBless:onEnterTransitionDidFinish(element)
	local boxContainer = GetElement(self.m_root,"box_container",WZUIContainer)
	for i=1,5 do
		local tab = {}
		tab.btnBox = GetElement(boxContainer, "btnBox"..i.."_CellBless", WZUIButton)
		tab.btnBox:setVisible(false)
		tab.imgBox = GetElement(boxContainer, "imgBtn"..i.."_CellBless", WZUIImage)
        tab.imgBox:setVisible(false)
        tab.txtTimes = GetElement(boxContainer, "txtTimes"..i.."_CellBless", WZUILabelTTF)
        tab.armBox = GetElement(boxContainer, "armBox"..i.."_CellBless", WZArmature)
        tab.armBox:setVisible(false)
		self.m_tCreateBelssBox[i] = tab
	end
	self:createFireWork()
end

function CellNewYearBless:onBtnClickBless(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nBtnBlessTicker then
		MsgBoxManager:showTipBox(LocalStrings.NEWYEAR_TEXT16)
		return
	end
	--存在1秒的时间冻结，主要是不给连续点击按钮的
	self.m_nBtnBlessTicker = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
        if self.m_nBtnBlessTicker then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nBtnBlessTicker)
			self.m_nBtnBlessTicker = nil
		end 
    end, 0.5, false)

	if self.m_nActivityId then
		local index = tonumber(element:getTag())
		if self.m_nRemainCount <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.ATH_CNT_NOT_ENOUGH)
		else
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, index, "")
		end
	end
end

function CellNewYearBless:onBtnClickBlessRank()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndRank = WndShopRank:createElement(3,self.m_nActivityId,self.m_nActivityType)
    WindowManager:addWindow(wndRank,WndShopRank,nil,false)
end

function CellNewYearBless:onBtnClickMoreReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndJoinReward:showInterface("", self.m_tShowBigReward.itemIds, self.m_tShowBigReward.itemNums, LocalStrings.TREASURE_TEXT7)
end

function CellNewYearBless:onClickBox(element)
	local index = tonumber(element:getTag())

	if self.m_tBlessBoxData[index] then
		if self.m_tBlessBoxData[index].status == -1 or self.m_tBlessBoxData[index].status == 1 then
			local data = {}
			data.cur_value = self.m_nDayTotleCount
			data.totle_value = self.m_tBlessBoxData[index].tager
			data.rewardIds = self.m_tBlessBoxData[index].rewardIds
			data.rewardNums = self.m_tBlessBoxData[index].rewardNums
			WndNewTipsReward:showInterface(self.m_root, element, data)
		elseif self.m_tBlessBoxData[index].status == 0 then
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId, self.m_tBlessBoxData[index].rewardId)
		end
	end
end
function CellNewYearBless:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		if bool == true then
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(self.m_nActivityId,self.m_nActivityType)
		end
		self.m_root:setVisible(bool)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewYearBless:_onGetBlessInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if self.m_nActivityId == activityId then
		self:setBlessBoxData(rewardId, rewardItems, rewardItemsParamCount, rewardCounts, finishCondition, status)
		self:setBigReward(content)
		self:setChangeData(count, maxCount)
	end
end
function CellNewYearBless:setBigReward(reward)
	local good_reward = GetElement(self.m_root,"good_reward",WZUIContainer)
	if good_reward then
		reward = json.decode(reward)
		self.m_tShowBigReward = reward
		local num = #reward.itemIds
		if num >= 4 then
			num = 4
		end
		for i=1, num do
			local id = reward.itemIds[i]
			local num = reward.itemNums[i]
			local items = GDatatab_item["id_"..id]
			if items then
				local celElement, tNewObj = CellGoodItem:createElement()
				good_reward:addChild(celElement)
				celElement:setUseAbsCoordinate(true)
				celElement:setAnchorPoint(GlobalMethod:ccp(0,0))
		 		celElement:setAbsPosition(GlobalMethod:ccp(0,0))

			    local itemInfo = {id=i, name=items.name,icon=items.icon,lastNum=num,quality=items.quality,basicInfo=items}
			    tNewObj:setCellGoodItem(itemInfo,17)
				celElement:setScale(0.8)
			    tNewObj:setItemClickFun(self,self.onItemClick)
			    celElement:setAbsPosition(GlobalMethod:ccp(10,210-(75 * (i-1))))
			end
		end
	end
end
function CellNewYearBless:onItemClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndItemInfo:showInfo(tCell.m_root,WndNewYearActivityMain.m_root,1,tData,false,nil,true)
end
--宝箱的状态
local closeBox = {"ui/common/common_icon_lan1.png","ui/common/common_icon_zi1.png","ui/common/common_icon_huang1.png","ui/common/common_icon_zis1.png","ui/common/common_icon_hong1.png"}
local openBox = {"ui/common/common_icon_lan2.png","ui/common/common_icon_zi2.png","ui/common/common_icon_huang2.png","ui/common/common_icon_zis2.png","ui/common/common_icon_hong2.png"}
local nullBox = {"ui/common/common_icon_lan3.png","ui/common/common_icon_zi3.png","ui/common/common_icon_huang3.png","ui/common/common_icon_zis3.png","ui/common/common_icon_hong3.png"}
function CellNewYearBless:setChangeData(remainCount, dayCount)
	GetElement(self.m_root,"remainBlessCount",WZUILabelTTF):setText(remainCount)
	GetElement(self.m_root,"todayBlessCount",WZUILabelTTF):setText(dayCount)
	if remainCount < 10 then
		GetElement(self.m_root,"btnBless_10",WZUIButton):setTouchEnable(false)
	else
		GetElement(self.m_root,"btnBless_10",WZUIButton):setTouchEnable(true)
	end
	self.m_nRemainCount = remainCount
	self.m_nDayTotleCount = dayCount
	local boxBlessProgress = GetElement(self.m_root,"boxBlessProgress",WZUIProgress)
	local totle = self.m_tBlessBoxData[#self.m_tBlessBoxData].tager
	local percent = dayCount / totle * 100
	local perGapping = math.floor((1 / #self.m_tBlessBoxData) * 100)
	local reachBoxIndex = 1
	for i=1, #self.m_tBlessBoxData do
		if i <= 5 and self.m_tCreateBelssBox[i] then 
	        if dayCount <= self.m_tBlessBoxData[i].tager then
	        	reachBoxIndex = i 
	        	break 
	        end 
		end
	end

	if self.m_tCreateBelssBox[reachBoxIndex] and boxBlessProgress then 
		local lastBoxNum = 0
		if reachBoxIndex > 1 then 
			lastBoxNum = self.m_tBlessBoxData[reachBoxIndex - 1].tager
		end
        local nTempNum = self.m_tBlessBoxData[reachBoxIndex].tager - lastBoxNum
        local num = 100 / #self.m_tBlessBoxData
        percent = perGapping * (reachBoxIndex - 1) + math.floor((dayCount - lastBoxNum) * num/nTempNum) 
		if percent >= 100 then
			percent = 100
		end
    	boxBlessProgress:setPercentage(percent)
    end

	self:setBoxStatus()
end
function CellNewYearBless:setBoxStatus()
	if not self.m_tBlessBoxData then return end
	local pos_x = (1 / #self.m_tBlessBoxData)
	
	local box_status = false
	for i=1, #self.m_tBlessBoxData do
		if i > 5 then return end
		if self.m_tCreateBelssBox[i] then
			self.m_tCreateBelssBox[i].btnBox:setVisible(true)
			self.m_tCreateBelssBox[i].btnBox:setRelativePosition(GlobalMethod:ccp(pos_x*i - 0.03, 0.5))

			self.m_tCreateBelssBox[i].txtTimes:setText(self.m_tBlessBoxData[i].tager)
			self.m_tCreateBelssBox[i].armBox:setVisible(self.m_tBlessBoxData[i].status == 0) --领取动画
			self.m_tCreateBelssBox[i].imgBox:setVisible(true)
			
			if self.m_tBlessBoxData[i].status == -1 then
				self.m_tCreateBelssBox[i].imgBox:setFile(closeBox[i])
			elseif self.m_tBlessBoxData[i].status == 0 then
				self.m_tCreateBelssBox[i].imgBox:setFile(openBox[i])
				box_status = true
			elseif self.m_tBlessBoxData[i].status == 1 then
				self.m_tCreateBelssBox[i].imgBox:setFile(nullBox[i])
			end
		end
	end
	
	if self.m_nRemainCount and self.m_nRemainCount <= 0 and box_status == false then
		WndNewYearActivityMain:setRedPointStatus(self.m_nActivityType, false)
		WndNewYearActivityMain:setHolidayTitleItemRedPoint(self.m_nActivityType, false)
	end
end
function CellNewYearBless:createFireWork()
	if self.m_sFireworkSpine then
		self.m_sFireworkSpine:removeFromParentAndCleanup(true)
		self.m_sFireworkSpine = nil
	end
	local fireworkSpine = GetElement(self.m_root,"fireworkSpine",WZUIContainer)
	local data = {}
--    data.path = "activity/ui_common_znyh"
    data.path = "ui/otherUI/moneycat"
    data.play = "animation"
    data.loop = true
    self.m_sFireworkSpine = createEffectSpine(fireworkSpine, data)
end
function CellNewYearBless:_onGetBlessResult(activityId, doType, result, msg)
	if self.m_nActivityId == activityId then
		if msg then
			msg = json.decode(msg)
			for i=1,#msg.status do
				self.m_tBlessBoxData[i].status = msg.status[i]
			end
			self:setChangeData(msg.num, msg.todayCount)

			self.m_tOpenFireWorkData = msg
			-- if self.m_sFireworkSpine then
			-- 	self.m_sFireworkSpine:play("wait_2", false)
			-- 	self.m_sFireworkSpine:setLuaSpineEventFunc("animationEventFunc")
			-- end
			self:animationEventFunc()
		end
	end
end
function CellNewYearBless:animationEventFunc(animation, name, eventName)
	-- if name == "complete" then
	-- 	self:createFireWork()
		
		local msg = self.m_tOpenFireWorkData
		-- msg.spItemIds = {100}
		-- msg.spItemNums = {10}
		--没有大奖的情况下
		if #msg.spItemIds == 0 then
			WndRewardShow:showById(msg.itemIds, msg.itemNums)
		else
			--如果有大奖奖励的话，先播放普通奖励，关闭后播放大奖奖励
			WndRewardShow:showById(msg.itemIds, msg.itemNums)
			local data = {id = msg.spItemIds[1], num = msg.spItemNums[1]}
			self.m_tGetBigReward = data
			WndRewardShow:closeCallBack(self, self.showBigReward)
		end
	end
--end

function CellNewYearBless:showBigReward()
	if self.m_tGetBigReward then
		CellNewYearBigBless:showInterface(self.m_tGetBigReward)
	end
end

function CellNewYearBless:_onGetBoxResult(itemsId, count, _type, rewardId)
	WndRewardShow:showById(itemsId, count)
	if self.m_tBlessBoxData and self.m_tBlessBoxData[rewardId] then
		self.m_tBlessBoxData[rewardId].status = 1
		self:setBoxStatus()
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function CellNewYearBless:_adaptLanguage_vn()
	
end
-------------------------------------语言适配end----------------------------------------
