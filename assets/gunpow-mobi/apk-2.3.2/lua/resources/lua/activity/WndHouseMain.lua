--WndHouseMain.lua
--@brief	WndHouseMain的UI模块
--@date		2021/09/27
--@author	hyx
--@note		房产主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHouseMain:onEnter(element)
	self.m_root = element
	self:register()
	self.m_nLastChatChannel = GlobalGame.g_nCurrentUIChannelId
	ChangeChatChannel(Chat_Channel_HouseInvest)
	ProtocolProcessorFestivalActivity:regAll6()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHouseMain:onExit(element)
	if self.m_sInvestSpine then
		self.m_sInvestSpine:removeFromParentAndCleanup(true)
		self.m_sInvestSpine = nil
	end
	if self.m_sInvestTaskTimeSchedule then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sInvestTaskTimeSchedule)
 		self.m_sInvestTaskTimeSchedule = nil
 	end
 	ChangeChatChannel(self.m_nLastChatChannel)
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
end
function WndHouseMain:register()
	LoadActivityWordsRes(true)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetHouseInvestInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetHouseInvestResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetInvestTaskResult,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
end
function WndHouseMain:unregister()
	LoadActivityWordsRes(false)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetHouseInvestInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetHouseInvestResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetInvestTaskResult,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
end
function WndHouseMain:showInterface()
	local wndHouse = WndHouseMain:createElement()
	if wndHouse ~= nil then
	    WindowManager:addWindow(wndHouse,WndHouseMain,nil,false)
	end
end
function WndHouseMain:onEnterTransitionDidFinish(element)
	self:_setTowerAni()
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function WndHouseMain:actionCallback()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7029, 7029)
	self:showRedDot()
end
--投资次数
function WndHouseMain:onBtnInvest(element)
	if self.m_sIsInvestIng then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nChooseReward == 0 then 
    	self:onBtnBigReward(0)

		self.m_nChooseReward = 1
		SaveOperateTimes("HOUSEMAINACTIVITYID", self.m_nActivityId)
    	return 
    end
	local tag = element:getTag()
	local count = 1
	local _type = 2
	if tag == 1 then
		count = 1
	elseif tag == 2 then
		count = 5
		_type = 1
	end
	if self.m_nInvestNumber < count then
		MsgBoxManager:showConfirmBox(LocalStrings.ACTIVITY_TEXT176, self, function()
			WndApartmentAct:showInterface()
			WindowManager:removeWindow(WndHouseMain.m_root, WndHouseMain, true)
		end, nil, {[MSGBOXUICFG_CONFIRM] = LocalStrings.ACTIVITY_TEXT108})
		return
	end
	if self.m_sInvestSpine then
		self.m_sInvestSpine:removeFromParentAndCleanup(true)
		self.m_sInvestSpine = nil
	end
	self.m_sIsInvestIng = true
	self.m_nCurInvestIndex = count
	local data = {}
	data.path = "activity/ui_fcdhjinbi_effect"
	data.play = "wait_".._type
	local existSpine = CheckEffectFile(data.path)
	if existSpine then 
		self.m_sInvestSpine = createEffectSpine(self.m_root,data)
		self.m_sInvestSpine:setLuaSpineEventFunc("animationEventFunc")
	else
		local _sIndex = "ui_fcdhjinbi_effect"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(14005,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
        end

        self:animationEventFunc(nil, "complete")
	end
end
function WndHouseMain:animationEventFunc(animation, name, eventName)
	if name == "complete" then
		if self.m_sInvestSpine then
			self.m_sInvestSpine:removeFromParentAndCleanup(true)
			self.m_sInvestSpine = nil
		end
		local tab = {}
		tab.times = self.m_nCurInvestIndex
		tab = json.encode(tab)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7029, 7, tab)
	end
end
--查看大奖
function WndHouseMain:onBtnBigReward(element)
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
end
--我的团队
function WndHouseMain:onBtnMyTeam()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndHouseInvite:showInterface()
end
--投资榜
function WndHouseMain:onBtnInvestRank()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndShopRank:showInterface(20, tonumber(g_cityExtenInfo.activity7029)) 
end
--投资任务
function WndHouseMain:onBtnInveatTask()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndDollMachineTask:showInterface(g_cityExtenInfo.activity7029, 1, 4)
end
--规则
function WndHouseMain:onBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.ACTIVITY_TEXT185)
end
--投资礼包
function WndHouseMain:onBtnInvestGift(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nInvestGiftCount <= 0 then
		local tData = {}
		tData.txtTitle = LocalStrings.ACTIVITY_TEXT214
		tData.nType = 2
		WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(50,-80), true)
		return
	end
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7029, 8, "")
end
--房产投资奖励
function WndHouseMain:onBtnHouseReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndHoraryLevReward:showInterface(1)
end
function WndHouseMain:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
--投资任务是否开启
function WndHouseMain:setInvestTaskState(state, taskId, time, progress, taget)
	local comInvestTask = GetElement(self.m_root,"comInvestTask",WZUIContainer)
	if state == 2 then
		for i=1,3 do
			if self.m_tInvestTaskRewardItem[i] and self.m_tInvestTaskRewardItem[i].cellElement and self.m_tInvestTaskRewardItem[i].cellElement:getChildByTag(10+i) then
		        self.m_tInvestTaskRewardItem[i].cellElement:removeChildByTag(10+i, true)
		    end
		end
		comInvestTask:setVisible(false)
		return
	else
		comInvestTask:setVisible(true)
	end
	self.m_nCurInvestTask = taskId
	GetElement(comInvestTask,"getInvestTask",WZUIButton):setVisible(state == 0)
	GetElement(comInvestTask,"imgGetInvestTask",WZUIImage):setVisible(state == 1)
	local richInvestTask = GetElement(comInvestTask,"richInvestTask",WZUIFreeTextBox)
	local config = GDatatab_new_activity_task["id_"..taskId]
	if config then
		local temp_str1,temp_str2 = "",""
		temp_str1 = progress[1].."/"..taget[1]
		if progress[2] then
			temp_str2 = progress[2].."/"..taget[2]
		end
		if temp_str2 ~= "" then
			richInvestTask:setShowText(string.format(config.desc,temp_str1,temp_str2))
		else
			richInvestTask:setShowText(string.format(config.desc,temp_str1))
		end

		for i,v in pairs(self.m_tInvestTaskRewardItem) do
			if v then
				v.cellElement:setVisible(false)
			end
		end
		for i=1, #config.reward do
			local tab_info = GDatatab_item["id_"..config.reward[i][1]]
			if tab_info then				
				if self.m_tInvestTaskRewardItem[i] == nil then
					local cellElement, tLuaObj = CellGoodItem:createElement()
					comInvestTask:addChild(cellElement)
					cellElement:setScale(0.7)
					cellElement:setUseAbsCoordinate(true)
					local tab = {}
					tab.cellElement = cellElement
					tab.tLuaObj = tLuaObj
					self.m_tInvestTaskRewardItem[i] = tab
				end
				local itemInfo = {lastTime=config.reward[i][2],lastNum=config.reward[i][2],basicInfo=CopyTable(tab_info)}
				self.m_tInvestTaskRewardItem[i].tLuaObj:setCellGoodItem(itemInfo, 17)
				self.m_tInvestTaskRewardItem[i].tLuaObj:setItemClickFun(WndHouseMain,self.onItemClick)
				local _x = 40 + (i-1) * 65
				self.m_tInvestTaskRewardItem[i].cellElement:setAbsPosition(GlobalMethod:ccp(_x, 60))
				self.m_tInvestTaskRewardItem[i].cellElement:setVisible(true)

				if state == 0 and not self.m_tInvestTaskRewardItem[i].cellElement:getChildByTag(10+i) then
					local spine = WZUISpine:create()
				   	spine:setTouchEnable(false)
				   	spine:setFileJson("ui/ui_common_JJLQ.json")
				   	spine:setFileAtlas("ui/ui_common_JJLQ.atlas")
				   	spine:setUseOriginSize(true)
				   	spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
					spine:play("wait_1",true)
				   	self.m_tInvestTaskRewardItem[i].cellElement:addChild(spine,1,10+i)
			   	end
			end
		end
	end
	local txtInvestTaskTime = GetElement(comInvestTask,"txtInvestTaskTime",WZUILabelTTF)
	txtInvestTaskTime:setText(SystemTime:getTimeConverLocal2(time))
	self.m_tInvesTime = time
	if not self.m_sInvestTaskTimeSchedule then
    	self.m_sInvestTaskTimeSchedule = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
    		self.m_tInvesTime = self.m_tInvesTime - 1
    		txtInvestTaskTime:setText(SystemTime:getTimeConverLocal2(self.m_tInvesTime))
    		if self.m_tInvesTime < 0 then
    			if self.m_sInvestTaskTimeSchedule then 
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sInvestTaskTimeSchedule)
			 		self.m_sInvestTaskTimeSchedule = nil
			 	end
			 	if comInvestTask then
					for i=1,3 do
						if self.m_tInvestTaskRewardItem[i] and self.m_tInvestTaskRewardItem[i].cellElement and self.m_tInvestTaskRewardItem[i].cellElement:getChildByTag(10+i) then
					        self.m_tInvestTaskRewardItem[i].cellElement:removeChildByTag(10+i, true)
					    end
					end
			 		comInvestTask:setVisible(false)
			 	end
    		end
    	end, 1, false)
    end
end
function WndHouseMain:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndHouseMain.m_root,1,tData,false,nil,true)
end
function WndHouseMain:onGetInvestTask()
	if self.m_nCurInvestTask then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(g_cityExtenInfo.activity7029, self.m_nCurInvestTask)
	end
end
--投资礼包个数
function WndHouseMain:setInvestGiftCount()
	if not self.m_root then return end
	local visible = false
	if self.m_nInvestGiftCount <= 0 then
		visible = false
	else
		visible = true
	end
	GetElement(self.m_root,"imgGiftRewardRedPoint",WZUIImage):setVisible(visible)
	GetElement(self.m_root,"txtGiftRewardRedPointNum",WZUILabelTTF):setText(self.m_nInvestGiftCount)
end
--我的房产信息
function WndHouseMain:setMyHouseMsgData(data)
	if not data then return end

	local comMyHouse = GetElement(self.m_root,"comMyHouse",WZUIContainer)
	local txtHouseName = GetElement(comMyHouse,"txtHouseName",WZUILabelTTF)
	local myHouseProgress = GetElement(comMyHouse,"myHouseProgress",WZUIProgress)
	local txtHouseProgress = GetElement(comMyHouse,"txtHouseProgress",WZUILabelTTF)
	txtHouseName:setText(LocalStrings.ACTIVITY_TEXT175[data.level+1])
	if data.exp == -1 then
		myHouseProgress:setPercentage(100)
		txtHouseProgress:setText("Max")
	else
		myHouseProgress:setPercentage(data.exp / data.maxExp * 100)
		txtHouseProgress:setText(data.exp .."/".. data.maxExp)
	end
	local imgBuildLevel = GetElement(self.m_root,"imgBuildLevel",WZUIImage)
	if data.level >= 1 and data.level <= 5 then
		imgBuildLevel:setVisible(false)
		local spineBuildLevel = GetElement(self.m_root,"spineBuildLevel",WZUISpine)
		spineBuildLevel:setVisible(true)
		spineBuildLevel:setAnimationName("wait_"..data.level)
	else
		imgBuildLevel:setVisible(true)
	end
end
--投资卡数量
function WndHouseMain:setInvestNumber()
	if not self.m_root then return end
	local richInvestCardCount = GetElement(self.m_root,"richInvestCardCount",WZUIFreeTextBox)
	local str = [[<I Z="0.4">%s</I><T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	local itemInfo = GDatatab_item["id_160154"]
	if itemInfo then
		richInvestCardCount:setShowText(string.format(str,itemInfo.icon, self.m_nInvestNumber))
	end
end
--房子奖励红点
function WndHouseMain:setLevelRewardRedPoint()
	if not self.m_root then return end
	GetElement(self.m_root,"imgLevelRewardRedPoint",WZUIImage):setVisible(GlobalGame.g_tRedPointTypeList[27029])
end
--邀请红点
function WndHouseMain:setTeamRedPoint()
	if not self.m_root then return end
	GetElement(self.m_root,"imgTeamRedPoint",WZUIImage):setVisible(GlobalGame.g_tRedPointTypeList[17029])
end
--任务红点
function WndHouseMain:setTaskRedPoint( )
	if not self.m_root then return end
	local visible = GlobalGame.g_tRedPointTypeList[117029] or GlobalGame.g_tRedPointTypeList[127029]
	GetElement(self.m_root,"imgTaskRedPoint",WZUIImage):setVisible(visible)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndHouseMain:showBigReward()
	if self.m_tBigRewardData then
		WndHoraryBigReward:showInterface(5, self.m_tBigRewardData)
	end
end
--投资任务奖励
function WndHouseMain:_onGetInvestTaskResult(activityId, taskId, activityType, rewardItems, rewardCount)
	if tonumber(g_cityExtenInfo.activity7029) == activityId then
		local ids = VectorToTable(rewardItems)
		local nums = VectorToTable(rewardCount)
		local num = 0
		for i=1,#ids do
			if ids[i] == 160154 then
				num = num + nums[i]
			end
		end
		self.m_nInvestNumber = self.m_nInvestNumber + num
		self:setInvestNumber()
		if self.m_nCurInvestTask and self.m_nCurInvestTask == taskId then
			for i=1,3 do
				if self.m_tInvestTaskRewardItem[i] and self.m_tInvestTaskRewardItem[i].cellElement and self.m_tInvestTaskRewardItem[i].cellElement:getChildByTag(10+i) then
			        self.m_tInvestTaskRewardItem[i].cellElement:removeChildByTag(10+i, true)
			    end
			end
			GetElement(self.m_root,"getInvestTask",WZUIButton):setVisible(false)
			GetElement(self.m_root,"imgGetInvestTask",WZUIImage):setVisible(true)
		end
	end
end

--@brief 	红点
function WndHouseMain:showRedDot()
	-- body
	if self.m_root then 
		self:setLevelRewardRedPoint()
	    self:setTeamRedPoint()
	    self:setTaskRedPoint( )
	end
	WndHouseInvite:setInviteNoticeRedPoint()
end

--@brief 	设置待机特效
function WndHouseMain:_setTowerAni()
	local spinePath = "activity/ui_fcdh_effect"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineBuildLevel = GetElement(self.m_root, "spineBuildLevel", WZUISpine)
		if spineBuildLevel then 
			spineBuildLevel:setFileJson(spinePath .. ".json")
			spineBuildLevel:setFileAtlas(spinePath .. ".atlas")
		end
	else
		local _sIndex = "ui_fcdh_effect"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7029, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndHouseMain)
        end
	end
end

function WndHouseMain:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndHouseMain:downloadEffectCallback",taskId,extraData,failed)
    if failed == 0 then 
    	self:_setTowerAni()
    end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndHouseMain:_adaptLanguage_vn()
	local richInvestTask = GetElement(self.m_root, "richInvestTask", WZUIFreeTextBox)
	richInvestTask:setScale(0.7)
	richInvestTask:setMaxWidth(280)
end
-------------------------------------语言适配end----------------------------------------
