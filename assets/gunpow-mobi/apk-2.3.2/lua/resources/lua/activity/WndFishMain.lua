--WndFishMain.lua
--@brief	WndFishMain的UI模块
--@date		2021/08/20
--@author	hyx
--@note		钓鱼主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFishMain:onEnter(element)
	self.m_root = element
	self:register()
	ProtocolProcessorFestivalActivity:regAll6()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFishMain:onExit(element)
	local tab = {}
	tab.rodType = self.m_nRodType or 1
	tab = json.encode(tab)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7024, 4, tab)

	if self.m_sFishRodSpine then
		self.m_sFishRodSpine:removeFromParentAndCleanup(true)
		self.m_sFishRodSpine = nil
	end
	self:unregister()
	self:_unInit()
	ProtocolProcessorFestivalActivity:unregAll()
	LoadNewActivityRes(false)
end
function WndFishMain:showInterface()
	LoadNewActivityRes(true)
	local wndFish = WndFishMain:createElement()
	if wndFish ~= nil then
	    WindowManager:addWindow(wndFish,WndFishMain,nil,nil)
	end
end

function WndFishMain:register()
	LoadActivityWordsRes(true)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetFishInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetFishResult,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.setTaskRedPoint, self)
end
function WndFishMain:unregister()
	LoadActivityWordsRes(false)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetFishInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetFishResult,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.setTaskRedPoint, self)
end

function WndFishMain:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function WndFishMain:actionCallback()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7024, 7024)
	self:setTaskRedPoint()
end
--钓鱼
function WndFishMain:onBtnFish(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:showFishRodName(false)
	if not self.m_nFreeTimes or not self.m_nRodType then 
		return 
	end

	if self.m_bStartFishIng then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT128)
		return
	end
	if self.m_nChooseReward == 0 then 
    	self:onBtnBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("FISHMAINACTIVITYID", self.m_nActivityId)
    	return 
    end
	self.m_bStartFishIng = true
	local count = 0
	local tag = element:getTag()
	if tag == 1 then
		if self.m_nFreeTimes > 0 then
			count = 0
		else
			count = 1
		end
	elseif tag == 2 then
		count = 5
	end
	if self.m_nFreeTimes <= 0 then --没有免费次数的时候
		local m_Status = nil
		if self.m_nRodType == 2 and self.m_nBaitNum < 2 then --高级杆的时候
			m_Status = true
		else
			if self.m_nBaitNum < count then
				m_Status = true	
			end
		end
		if m_Status then
			MsgBoxManager:showConfirmBox(LocalStrings.ACTIVITY_TEXT123, self, function()
				WndApartmentAct:showInterface()
				WindowManager:removeWindow(WndFishMain.m_root, WndFishMain, true)
			end, nil, {[MSGBOXUICFG_CONFIRM] = LocalStrings.ACTIVITY_TEXT108},nil,nil,nil,function()
				self.m_bStartFishIng = nil
			end)
			return
		end
	end
	local tab = {}
	tab.rodType = self.m_nRodType --鱼竿
	tab.optType = count --次数
	tab = json.encode(tab)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7024, 1, tab)
end
function WndFishMain:setRemainCount()
	if not self.m_root or not self.m_nFreeTimes then return end
	--是否存在免费次数
	local btnOnce = GetElement(self.m_root,"btnOnce",WZUIButton)
	local txtOnce = GetElement(btnOnce,"txtOnce",WZUILabelTTF)
	if tonumber(self.m_nFreeTimes) > 0 then
		txtOnce:setText(LocalStrings.ACTIVITY_TEXT111)
	else
		txtOnce:setText(LocalStrings.ACTIVITY_TEXT112)
	end

	local txtRichCount = GetElement(self.m_root,"txtRichCount",WZUIFreeTextBox)
	local str = [[<I Z="0.5">%s</I><T C="255,255,255" S="20" P="1">%d</T>]]
	local itemInfo = GDatatab_item["id_160138"]
	if itemInfo then
		txtRichCount:setShowText(string.format(str,itemInfo.icon, self.m_nBaitNum))
	end
end
--大奖预览
function WndFishMain:onBtnBigReward(element)
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	local tData = {}
	tData.pool = 7
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, strJson)
end
--任务
function WndFishMain:onBtnFishTask()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndDollMachineTask:showInterface(g_cityExtenInfo.activity7024, 1, 2)
end
--商店
function WndFishMain:onBtnFishShop()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndDollMachineShop:showInterface(1, g_cityExtenInfo.activity7024)
end
--排行榜
function WndFishMain:onBtnFishRank()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndShopRank:showInterface(7, g_cityExtenInfo.activity7024, 7024)
end
function WndFishMain:onBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.ACTIVITY_TEXT119)
end
--切换鱼竿
function WndFishMain:onBtnChooseYg(element)
	local tag
	if type(element) == "number" then
		tag = element
	else
		tag = element:getTag()
	end
	if self.m_nRodType == tag then return end
	self:showFishRodName(true, tag)

	if self.m_sFishRodSpine == nil then
		local data = {}
		data.path = "activity/diaoyu"
		data.play = "wait1"
		data.ccp = ccp(0.48,0.392)
		self.m_sFishRodSpine = createEffectSpine(self.m_root,data)
	end
	if self.m_sFishRodSpine then 
		self.m_sFishRodSpine:play("wait"..tag, true)
	end

	if self.m_nRodType then
		GetElement(self.m_root,"imgChooseYg"..tonumber(self.m_nRodType),WZUIImage):setVisible(false)
	end
	GetElement(self.m_root,"imgChooseYg"..tag,WZUIImage):setVisible(true)
	self.m_nRodType = tag
end
function WndFishMain:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
--任务红点
function WndFishMain:setTaskRedPoint()
	if not self.m_root then return end
	local visible = GlobalGame.g_tRedPointTypeList[127024] or GlobalGame.g_tRedPointTypeList[117024]
	GetElement(self.m_root,"imgTaskRedPoint",WZUIImage):setVisible(visible)
end
function WndFishMain:onTouchBegin()
	self:showFishRodName(false)
end
--显示鱼竿的名字 1、初级鱼竿，2、高级鱼竿
function WndFishMain:showFishRodName(visible,index)
	if not self.m_root then return end

	index = index or 1
	local conFishRod = GetElement(self.m_root,"conFishRod",WZUIContainer)
	conFishRod:setVisible(visible)
	local pos_x = {0.595,0.65}
	conFishRod:setRelativePosition(ccp(pos_x[index], 0.167))
	GetElement(conFishRod,"txtFishRodName",WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT135[index])
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFishMain:_onGetFishInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if activityId == tonumber(g_cityExtenInfo.activity7024) then
		content = json.decode(content)
		local txtActivityTime = GetElement(self.m_root,"txtActivityTime",WZUILabelTTF)
		local _start = SystemTime:getTimeConverLocal(startTime)
		local _end = SystemTime:getTimeConverLocal(endTime)
		txtActivityTime:setText(_start.."-".._end)
		self.m_nActivityId = activityId
		self.m_nChooseReward = GetOperateTimes("FISHMAINACTIVITYID", self.m_nActivityId) 

		if content then
			self.m_tBigReward = content.bigRewards
			self.m_tBigSpecialRewards = content.specialRewards
			self.m_nFreeTimes = content.freeTimes
			self.m_nBaitNum = content.baitNum
			self:onBtnChooseYg(content.rodType)
			self:setRemainCount()
		end
	end
end
function WndFishMain:_onGetFishResult(activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7024) then
		msg = json.decode(msg)
		if doType == 1 then 
			if msg and msg.result == 1 then
				self.m_nFreeTimes = msg.freeTimes
				self.m_nBaitNum = msg.baitNum
				self:setRemainCount()
				if self.m_sFishRodSpine then
					self.m_sFishRodSpine:play("wait"..(2+tonumber(msg.rodType)), false)
					self.m_sFishRodSpine:setLuaSpineEventFunc("animationEventFunc")
				else
					self.m_tFiveRewardData = msg
					self:animationEventFunc(nil, "complete", "jump")
				end
				self.m_tFiveRewardData = msg
			else
				MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT31)
				self.m_bStartFishIng = nil
			end
		elseif doType == 5 then 
			if msg then 
				local nSex = CacheCenter:getPlayerInfo().sex
				local sBigReward = msg.rewards
				local array = SplitStringWithSeparator(sBigReward, "&")
				local tItem = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.ACTIVITY_TEXT121, strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = msg.pool}
				for i = 1, #msg.globalLimit do
					local tab = {}
					tab.id = i - 1
					tab.limitNum = msg.playerLimitConfig[i]
					tab.dailyLimit = msg.globalLimitConfig[i]
					tab.dailyBuyNum = msg.globalLimit[i]
					tab.soldNum = msg.playerLimit[i]
					if utilsValueInTable(i - 1, msg.optionalList) then 
						tItem.chooseState[i] = 1
					else
						tItem.chooseState[i] = 0
					end
					
					tItem.leftConfig[i] = tab
				end

				for i = 1, #array do
					local string = string.sub(array[i], 2, -2) 
					local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
					local num = tonumber(SplitStringWithSeparator(string,",")[3])

					table.insert(tItem.reward_ids2, id)
					table.insert(tItem.reward_nums2, num)
				end

				self.m_tBigSpecialRewards = tItem

				if self.m_tBigReward and self.m_tBigSpecialRewards then
					local ids1, nums1 = WndMainHorary:getRewardData(self.m_tBigReward)
					--特等奖
					local tab_rewards1 = {}
					tab_rewards1.name = LocalStrings.ACTIVITY_TEXT120
					tab_rewards1.reward_ids1 = ids1 
					tab_rewards1.reward_nums1 = nums1
					local otherData = {}
					otherData.winType = 1
					otherData.activityId = self.m_nActivityId
					WndJoinReward:showInterface("", tab_rewards1, self.m_tBigSpecialRewards, LocalStrings.TREASURE_TEXT7, nil, 2, otherData, 2)
				end
			end
		elseif doType == 6 then 
			if msg then 
				if result == 0 then 
					local tTempList = nil 
					tTempList = self.m_tBigSpecialRewards
					tTempList.chooseState[msg.id + 1] = msg.status
					if msg.status == 1 then 
						WndJoinReward:chooseReturn(2, msg.id + 1, msg.status)
					end
				elseif result == 1 then
					MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
				end
			end
		end
	end
end
function WndFishMain:animationEventFunc(animation, name, eventName)
	if eventName == "jump" then
		local msg = self.m_tFiveRewardData
		if msg.optType == 0 or msg.optType == 1 then
			self:setShowReward(msg)
		elseif msg.optType == 5 then
			WndFishFiveReward:showInterface(msg)
			if msg.scaleNum and msg.scaleNum > 0 then
				local str = string.format("%s*%d",LocalStrings.ACTIVITY_TEXT137,msg.scaleNum)
				MsgBoxManager:showTipBox(str,nil,nil,nil,nil,nil,nil,nil,nil,{x=0.5,y=0.8})
			end
		end
		self.m_bStartFishIng = nil
	end
	if name == "complete" then
		if self.m_sFishRodSpine then
			self.m_sFishRodSpine:removeFromParentAndCleanup(true)
			self.m_sFishRodSpine = nil
		end
		local data = {}
		data.path = "activity/diaoyu"
		data.play = "wait1"
		data.ccp = ccp(0.48,0.392)
		self.m_sFishRodSpine = createEffectSpine(self.m_root,data)
		if self.m_sFishRodSpine then 
			self.m_sFishRodSpine:play("wait"..tonumber(self.m_nRodType), true)
		end
	end
end
function WndFishMain:setShowReward(data)
	local table_insert = table.insert
	local ids,nums = {},{}
	--6、大奖,7、特等奖
	local fish_type = 0
	local bigIds,bigNums,specialIds,specialNums = {},{},{},{}
	for i=1,#data.fishes do
		if data.fishes[i] ~= 6 or data.fishes[i] ~= 7 then
			fish_type = data.fishes[i]
		end
		local _string = string.sub(data.rewards[i],2,-2)
		if data.fishes[i] == 6 then
			local id = SplitStringWithSeparator(_string,",")[1]
			local num = SplitStringWithSeparator(_string,",")[2]
			table_insert(bigIds,id)
			table_insert(bigNums,num)
		elseif data.fishes[i] == 7 then 
			local id = SplitStringWithSeparator(_string,",")[1]
			local num = SplitStringWithSeparator(_string,",")[2]
			table_insert(specialIds,id)
			table_insert(specialNums,num)
		else			
			local array = SplitStringWithSeparator(_string,"&")
			for i=1,#array do
				local id = SplitStringWithSeparator(array[i],",")[1]
				local num = SplitStringWithSeparator(array[i],",")[2]
				table_insert(ids,id)
				table_insert(nums,num)
			end
		end
	end
	local temp_str = ""
	if data.scaleNum > 0 then
		temp_str = string.format("%s*%d",LocalStrings.ACTIVITY_TEXT137,data.scaleNum)
	end
	local str = string.format("%s%s*1 %s",LocalStrings.ACTIVITY_TEXT134, LocalStrings.ACTIVITY_TEXT124[fish_type],temp_str)
	MsgBoxManager:showTipBox(str,0.5,nil,nil,nil,nil,nil,nil,nil,{x=0.5,y=0.8})

	if next(ids) == nil then
		local tab = {}
		tab.bigIds = bigIds
		tab.bigNums = bigNums
		tab.specialIds = specialIds
		tab.specialNums = specialNums
		WndHoraryBigReward:showInterface(3, self.m_tBigRewardData)
	else
		WndRewardShow:showById(ids, nums)
		if next(bigIds) ~= nil or next(specialIds) then
			local tab = {}
			tab.bigIds = bigIds
			tab.bigNums = bigNums
			tab.specialIds = specialIds
			tab.specialNums = specialNums
			self.m_tBigRewardData = tab
			WndRewardShow:closeCallBack(self, self.showBigReward)
		end
	end
end
function WndFishMain:showBigReward()
	if self.m_tBigRewardData then
		WndHoraryBigReward:showInterface(3, self.m_tBigRewardData)
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin------------------------------------------

function WndFishMain:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtOnce",WZUILabelTTF):setFontSize(20)
end

-------------------------------------语言适配End--------------------------------------------
