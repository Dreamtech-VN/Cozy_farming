--WndDollMachine.lua
--@brief	WndDollMachine的UI模块
--@date		2021/04/29
--@author	hyx
--@note		娃娃机


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDollMachine:onEnter(element)
	self.m_root = element
	ProtocolProcessorFestivalActivity:regAll6()
	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}

	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDollMachine:onExit(element)
	if self.m_sImgDollHook then
		self.m_sImgDollHook:stopAllActions()
	end
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
	LoadNewActivityRes(false)
end
function WndDollMachine:showInterface()
	LoadNewActivityRes(true)
	local wndDollMachine = WndDollMachine:createElement()
	if wndDollMachine ~= nil then
	    WindowManager:addWindow(wndDollMachine,WndDollMachine,nil,false)
	end
end
function WndDollMachine:register()
	LoadActivityWordsRes(true)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetDollMachineInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetLotteryResult,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
end
function WndDollMachine:unregister()
	LoadActivityWordsRes(false)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetDollMachineInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetLotteryResult,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
end
function WndDollMachine:onEnterTransitionDidFinish(element)
	self:_setBallAni()
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndDollMachine:actionCallback()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7010, 7010)
	self.m_sImgDollHook = GetElement(self.m_root,"imgDollHook",WZUIImage)
	self.m_sImgGift = GetElement(self.m_root,"imgGift",WZUIImage)
    local status = GlobalGame.g_tRedPointList.task1_redpoint or GlobalGame.g_tRedPointList.task2_redpoint
	self:setTaskPoint(status)
end

function WndDollMachine:onBtnLottery(element)
	if self.m_bLotterying == true then 
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT20)
		return
	end
	if self.m_nChooseReward == 0 then 
    	self:onBtnOpenBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("DOLLMACHINEACTIVITYID", self.m_nActivityId)
    	return 
    end
	self.m_bLotterying = true
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nFreeCount <= 0 then
		self.m_bLotterying = nil
		if not self.m_nDollMachineNum then return end
		if self.m_nDollMachineNum <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT12)
			return
		end
	end
	if self.m_nDollMachineNum > 0 then
		self.m_bLotterying = true
	end
	local tag = element:getTag()
	local count = {1,5}
	local tab = {}
	tab.times = count[tag]
	tab = json.encode(tab)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7010, 1, tab)
end
function WndDollMachine:onBtnOpenBigReward(element)
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end
	
	local tData = {}
	tData.pool = 2
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, strJson)
end

function WndDollMachine:onBtnTask()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndDollMachineTask:showInterface(tonumber(g_cityExtenInfo.activity7010))
end

function WndDollMachine:onBtnShop()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndDollMachineShop:showInterface(nil, g_cityExtenInfo.activity7010)
end
function WndDollMachine:onBtnRank()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndRank = WndShopRank:createElement(5,g_cityExtenInfo.activity7010,7010)
    WindowManager:addWindow(wndRank,WndShopRank,nil,false)
end

function WndDollMachine:setTaskPoint(visible)
	if not self.m_root then return end
	local taskRedpoint = GetElement(self.m_root,"taskRedpoint",WZUIImage)
	if taskRedpoint then
		taskRedpoint:setVisible(visible)
	end
end
function WndDollMachine:onBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   	WndFourStarRuleDesc:showInterface(LocalStrings.ACTIVITY_TEXT24)
end
function WndDollMachine:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	红点
function WndDollMachine:showRedDot()
	-- body
	local status = GlobalGame.g_tRedPointList.task1_redpoint or GlobalGame.g_tRedPointList.task2_redpoint
    WndDollMachine:setTaskPoint(status)
    WndDollMachineTask:setTask1Redpoint(0)
    WndDollMachineTask:setTask2Redpoint(0)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndDollMachine:_onGetDollMachineInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	local activity_time = GetElement(self.m_root,"activity_time",WZUILabelTTF)
	local start_time = SystemTime:getTimeConverLocal4(startTime)
	local end_time = SystemTime:getTimeConverLocal4(endTime)
	activity_time:setText(start_time.."-"..end_time)

	self.m_nDollMachineNum = tonumber(content)
	GetElement(self.m_root,"txtMachineNum",WZUILabelTTF):setText(self.m_nDollMachineNum)
	self.m_nFreeCount = maxCount
	self:setBtnOnceText( maxCount )
	--特等奖
	self.m_tBigRewardIds = rewardItems
	self.m_tBigRewardNums = rewardCounts
	--一等奖
	self.m_tBigReward1Ids = rewardItemsParamCount
	self.m_tBigReward1Nums = finishCondition
	self.m_nActivityId = activityId
	self.m_nChooseReward = GetOperateTimes("DOLLMACHINEACTIVITYID", self.m_nActivityId) 
end
--抽奖返回
function WndDollMachine:_onGetLotteryResult(activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7010) then
		msg = json.decode(msg)
		if msg and doType == 1 then
			if result == 2 then
				MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT12)
				self.m_bLotterying = nil
			elseif result == 1 then
				self.m_nFreeCount = msg.freeCount
				self:setBtnOnceText( msg.freeCount )
				self.m_nDollMachineNum = tonumber(msg.num)
				if self.m_root then
					GetElement(self.m_root,"txtMachineNum",WZUILabelTTF):setText(self.m_nDollMachineNum)
				end

				-- msg.fItemIds = {1}
				-- msg.fItemNums = {10}
				-- msg.sItemIds = {10}
				-- msg.sItemNums = {100}
				if self.m_sImgDollHook then
					self.m_sImgDollHook:stopAllActions()
				end
				local time = 0.5
				local movetoX = math.random(40, 290)
				local array = CCArray:create()
				local act1 = nil
				if movetoX > 163 then
					act1 = CCMoveTo:create(time,ccp(290,310))
				else
					act1 = CCMoveTo:create(time,ccp(40,310))
				end
		        local act2 = CCMoveTo:create(time,ccp(movetoX,310))
		        local act3 = CCMoveTo:create(time,ccp(movetoX,170)) --抓
		        local act3_1 = CCCallFunc:create(function()
	            	local str_name ={ "shopitems/gift_001.png","shopitems/gift_002.png","ui/activityWords/common_wwj_01.png","shopitems/gift_003.png","shopitems/gift_004.png","shopitems/gift_005.png",
	            		"shopitems/gift_006.png","ui/activityWords/common_wwj_02.png","shopitems/gift_007.png","shopitems/gift_008.png","ui/activityWords/common_wwj_03.png"}
	            	if self.m_sImgGift then
	            		self.m_sImgGift:setVisible(true)
	            		self.m_sImgGift:setFile(str_name[math.random(1,11)])
	            	end
		    	end)

		        local act4 = CCMoveTo:create(time,ccp(movetoX,230)) --起
		        local act5 = CCMoveTo:create(time,ccp(movetoX,310))
		        local array2 = CCArray:create()
            	array2:addObject(act5)
            	array2:addObject(CCCallFunc:create(function()
            		if self.m_sImgGift then
	            		self.m_sImgGift:setVisible(false)
	            	end
					self:setDollHookAction(msg)
					self.m_bLotterying = nil            
	            end))
            	local action1 = CCSpawn:create(array2)
		        array:addObject(act1)
		        array:addObject(act2)
		        array:addObject(act3)
		        array:addObject(act3_1)
		        array:addObject(act4)
		        array:addObject(action1)
		        local seq = CCSequence:create(array)
	        	if self.m_sImgDollHook then
		        	self.m_sImgDollHook:runAction(seq)
		        end
			end
		elseif msg and doType == 4 then
			local tResult = msg
			local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.ACTIVITY_TEXT19, strAtt = LocalStrings.GONGANDDRUM_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
			for i = 1, #tResult.globalLimit do
				local tab = {}
				tab.id = i - 1
				tab.limitNum = tResult.playerLimitConfig[i]
				tab.dailyLimit = tResult.globalLimitConfig[i]
				tab.dailyBuyNum = tResult.globalLimit[i]
				tab.soldNum = tResult.playerLimit[i]
				if utilsValueInTable(i - 1, tResult.optionalList) then 
					tItem.chooseState[i] = 1
				else
					tItem.chooseState[i] = 0
				end
				
				tItem.leftConfig[i] = tab
			end

			tItem.reward_ids1 = tResult.rewardIds
			tItem.reward_nums1 = tResult.rewardNums
			self.m_tBigRewards = tItem

			--一等奖
			local tab_rewards1 = {}
			tab_rewards1.reward_ids2 = self.m_tBigReward1Ids 
			tab_rewards1.reward_nums2 = self.m_tBigReward1Nums
			local otherData = {}
			otherData.winType = 1
			otherData.activityId = self.m_nActivityId
			WndJoinReward:showInterface("", self.m_tBigRewards, tab_rewards1, LocalStrings.TREASURE_TEXT7, true, 2, otherData)
		elseif msg and doType == 5 then
			local tResult = msg
			if result == 0 then 
				local tTempList = nil 
				tTempList = self.m_tBigRewards
				tTempList.chooseState[tResult.id + 1] = tResult.status
				if tResult.status == 1 then 
					WndJoinReward:chooseReturn(3, tResult.id + 1, tResult.status)
				end
			elseif result == 1 then
				MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
			end
		end
	end
end
--抽奖动作
function WndDollMachine:setDollHookAction(msg)
	if not msg then return end

	local _type = msg.times
	
	local index = 0
	if next(msg.fItemIds) ~= nil or next(msg.sItemIds) ~= nil then
		index = 1
	end
	if next(msg.fItemIds) ~= nil and next(msg.sItemIds) ~= nil then
		index = 2
	end
	if _type == 1 or (_type == 5 and index == 0) then
		WndRewardShow:showById(msg.itemIds, msg.itemNums)
	end
	if (_type == 5 and index > 0) then
		WndDollMachineReward:showInterface(msg.times, msg, index)
	end
	if index > 0 then
		local function closeFun()
			WndDollMachineReward:showInterface(msg.times, msg, index)
		end
		WndRewardShow:closeCallBack(self,closeFun)			
	else
		WndRewardShow:closeCallBack(_G, pushEquipInList)
	end
	if next(msg.pieceItemIds) ~= nil then
		local info = GDatatab_item["id_"..msg.pieceItemIds[1]]
		MsgBoxManager:showTipBox(string.format("%s*%d", info.name,msg.pieceItemNums[1]),nil,nil,nil,nil,nil,nil,nil,nil,{x=0.5,y=0.8})
	end
end
--抽奖1次的变化
function WndDollMachine:setBtnOnceText( num )
	if not self.m_root then return end

	local txtBtnOnce = GetElement(self.m_root,"txtBtnOnce",WZUILabelTTF)
	if txtBtnOnce then
		if num > 0 then
			txtBtnOnce:setText(LocalStrings.ACTIVITY_TEXT13)
		else
			txtBtnOnce:setText(LocalStrings.ACTIVITY_TEXT2)
		end
	end
end

--@brief 	设置待机特效
function WndDollMachine:_setBallAni()
	local spinePath = "activity/ui_common_wwjts"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineWait = GetElement(self.m_root, "spineWait_WndDollMachine", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("wait_2", true)
		end
	else
		local _sIndex = "ui_common_wwjts"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7010, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndDollMachine)
        end
	end
end

function WndDollMachine:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndDollMachine:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function WndDollMachine:_adaptLanguage_vn()
	local txtBtnOnce = GetElement(self.m_root,"txtBtnOnce",WZUILabelTTF)
	txtBtnOnce:setScale(0.7)
	txtBtnOnce:setDimensions(GlobalMethod:CCSize(160,0))
end
-------------------------------------语言适配end----------------------------------------

