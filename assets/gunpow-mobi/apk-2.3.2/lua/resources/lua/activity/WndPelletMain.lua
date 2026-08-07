--WndPelletMain.lua
--@brief	WndPelletMain的UI模块
--@date		2021/08/31
--@author	hyx
--@note		弹珠活动主界面
--[[
奖池从左到右排序是：A、C、S、B奖池
对应的数字 1  2  3  4 
]]
-------------------------------------公有方法模块Begin--------------------------------------
local pelletPosEnd = {{665,109},{707,109},{686,144},{659,174},{716,171}} --珠子投币的终点的坐标
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPelletMain:onEnter(element)
	self.m_root = element
	self:register()
	LoadActivityWordsRes(true)
	ProtocolProcessorFestivalActivity:regAll6()
end
local table_insert = table.insert
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPelletMain:onExit(element)
	self:stopLaunchTimeSchedule()
	self:_unInit()
	self:unregister()
	LoadActivityWordsRes(false)
end
function WndPelletMain:showInterface()
	local wndPellet = WndPelletMain:createElement()
	if wndPellet ~= nil then
	    WindowManager:addWindow(wndPellet,WndPelletMain,nil,false)
	end
end
function WndPelletMain:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetPelletInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetPelletResult,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
end
function WndPelletMain:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetPelletInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetPelletResult,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
end
function WndPelletMain:onEnterTransitionDidFinish(element)
	self:_setBallAni()
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndPelletMain:actionCallback()
	local conClipping = GetElement(self.m_root,"conClipping",WZUIClippingContainer)
	self.m_sImgSpring = GetElement(conClipping,"imgSpring",WZUIImage)
	self.m_sProgressLaunch = GetElement(self.m_root,"progressLaunch",WZUIProgress)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7028, 7028)
	self:showRedDot()
end

--按下发射键
function WndPelletMain:onBtnPushStart(element)
	element:setScale(1.05)
	if self.m_nPelletIndex <= 1 then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT147)
		return
	end
	if self.m_bIsCreatePellet then
		return
	end
	if self.m_bIsLuanchSpeed then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT158)
		return
	end
	if self.m_bIsCoinIng then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT159)
		return
	end

	if self:setIsLuanching() then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT158)
		return
	end
	for i=1,5 do
		self.m_tPelletMoveToY[i] = tonumber(pelletPosEnd[i][2])
	end
	self:stopLaunchTimeSchedule()
 	--1秒钟 --如果时间缩短或延长，需要重新计算
 	if not self.m_sLaunchTimeSchedule then
    	self.m_sLaunchTimeSchedule = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
    		self.m_nPushProgress = self.m_nPushProgress - 10
    		self.m_sProgressLaunch:setPercentage(self.m_nPushProgress)
    		self.m_nPushHeight = self.m_nPushHeight - 7
    		if self.m_nPushHeight <= -70 then
    			self.m_nPushHeight = -70
    		end
    		self.m_sImgSpring:setAbsPosition(ccp(50, self.m_nPushHeight))
    		for i=1,5 do
    			if self.m_tPelletBall[i] then
    				self.m_tPelletMoveToY[i] = tonumber(self.m_tPelletMoveToY[i]) - 7
    				self.m_tPelletBall[i]:setAbsPosition(ccp(pelletPosEnd[i][1], self.m_tPelletMoveToY[i]))
    			end
    		end
    		if self.m_nPushProgress <= 0 then
    			self:stopLaunchTimeSchedule()
    		end
    	end, 0.1, false)
    end
end
--松开发射键
function WndPelletMain:onBtnStart(element)
	element:setScale(1.0)
	if self.m_nPelletIndex <= 1 then
		return
	end
	if self.m_bIsCreatePellet then
		return
	end
	if self.m_bIsLuanchSpeed then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT158)
		return
	end
	if self.m_bIsCoinIng then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT159)
		return
	end
	if self:setIsLuanching() then return end
	self:setCoinGrayRender(false)

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_bIsLuanchSpeed = true
	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	local tab = {}
	tab.marbleNum = self.m_nPelletIndex - 1
	tab = json.encode(tab)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7028, 1, tab)
end
--离开按钮的时候
function WndPelletMain:onBtnPushMoveOut(element)
	element:setScale(1.0)
	if self.m_nPelletIndex <= 1 then
		return
	end
	if self.m_bIsLuanchSpeed then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT158)
		return
	end
	if self.m_bIsCoinIng then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT159)
		return
	end
	if self:setIsLuanching() then return end
	self:setCoinGrayRender(false)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_bIsLuanchSpeed = true
	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	local tab = {}
	tab.marbleNum = self.m_nPelletIndex - 1
	tab = json.encode(tab)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7028, 1, tab)
end
--发射珠子后收到协议就开始处理
function WndPelletMain:getProtoLaunchPelletPath(end_pos, func)
	if not end_pos then return end

	if not self.m_tPelletMoveToY[1] then
		for i=1,5 do
			self.m_tPelletMoveToY[i] = tonumber(pelletPosEnd[i][2])
		end
	end
	--发射弹簧回冲
	self:stopLaunchTimeSchedule()
	--1秒钟 
 	if not self.m_sLaunchTimeSchedule then
    	self.m_sLaunchTimeSchedule = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
    		self.m_nPushProgress = self.m_nPushProgress + 10
    		self.m_nPushHeight = self.m_nPushHeight + 7
    		if self.m_nPushHeight >= 0 then
    			self.m_nPushHeight = 0
    		end
    		if self.m_sImgSpring and self.m_sProgressLaunch then
    			self.m_sProgressLaunch:setPercentage(self.m_nPushProgress)
	    		self.m_sImgSpring:setAbsPosition(ccp(50, self.m_nPushHeight))
	    	end
    		for i=1,5 do
    			if self.m_tPelletBall[i] and self.m_tPelletMoveToY[i] and self.m_tIsLaunchPellet[i] == nil then
    				self.m_tPelletMoveToY[i] = tonumber(self.m_tPelletMoveToY[i]) + 7
    				self.m_tPelletBall[i]:setAbsPosition(ccp(pelletPosEnd[i][1], self.m_tPelletMoveToY[i]))
    			end
    		end

    		if self.m_nPushProgress >= 100 then
    			self:stopLaunchTimeSchedule()
    			self.m_nPushHeight = 0
    			self.m_sImgSpring:setAbsPosition(ccp(50, self.m_nPushHeight))
    			self.m_tIsLaunchPellet = {}
    		end
    	end, 0.1, false)
    end
    if next(end_pos) ~= nil then
	    for i=1,self.m_nPelletIndex do
			if self.m_tPelletBall[i] and self.m_tPelletBall[i]:isVisible() == true then
		 		delayTimer(function()
		 			self.m_bIsLuanchSpeed = nil
		 			self.m_tIsLaunchPellet[i] = true
		 			self.m_bIsCoinTurn[i] = true
		 			self:setRoadPath(self.m_tPelletBall[i], end_pos[i], function()
		 				--结束重置数据
					    self.m_bIsCoinTurn[i] = nil
					    if not self:setIsLuanching() then
					    	self.m_nPelletIndex = 1
					    	if func then
					    		func()
					    	end
					    end
		 			end)
		 		end, 0.15*(self.m_nPelletIndex-i-1))
		 	end
		end
	end
end
function WndPelletMain:stopLaunchTimeSchedule()
	if self.m_sLaunchTimeSchedule then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sLaunchTimeSchedule)
 		self.m_sLaunchTimeSchedule = nil
 	end
end
function WndPelletMain:stopCoinTimeSchedule()
	if self.m_sCoinTimeSchedule then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sCoinTimeSchedule)
 		self.m_sCoinTimeSchedule = nil
 	end
end
function WndPelletMain:onBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.ACTIVITY_TEXT150)
end
function WndPelletMain:onBtnBigReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tBigSpecialRewards then
		local ids, nums = WndMainHorary:getRewardData(self.m_tBigSpecialRewards)
   		WndJoinReward:showInterface("", ids, nums, LocalStrings.TREASURE_TEXT7)
	end
end
function WndPelletMain:onBtnRank()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFourStarRank:showInterface(g_cityExtenInfo.activity7028, 2)
end
function WndPelletMain:onBtnChip()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPelletChip:showInterface()
end
function WndPelletMain:onBtnTask()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndDollMachineTask:showInterface(g_cityExtenInfo.activity7028, 1, 3, {isBtnChange = false})
end
--
function WndPelletMain:setIsLuanching()
	local state = nil
	for i,v in pairs(self.m_bIsCoinTurn) do
		if v == true then
			state = true
			break
		end
	end
	return state
end
function WndPelletMain:onBtnCoin(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_bIsCreatePellet then
		return
	end
	if self.m_bIsCoinIng then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT159)
		return
	end
	if self.m_bIsLuanchSpeed then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT158)
		return
	end
	if self:setIsLuanching() then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT158)
		return
	end
	if self.m_nPelletIndex >= 6 then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT145)
		return
	end
	if self.m_nPlayerCoin <= 0 then
		MsgBoxManager:showConfirmBox(LocalStrings.ACTIVITY_TEXT146, self, function()
			WndApartmentAct:showInterface()
			WindowManager:removeWindow(WndPelletMain.m_root, WndPelletMain, true)
		end, nil, {[MSGBOXUICFG_CONFIRM] = LocalStrings.ACTIVITY_TEXT108})
		return
	end
	--如果存在弱网的时候
	if not self.m_sCoinTimeSchedule then
    	self.m_sCoinTimeSchedule = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
    		self.m_bIsCoinIng = nil
    		self.m_bIsCreatePellet = nil
    		self:stopCoinTimeSchedule()
    	end, 8, false)
    end
    self.m_bIsCreatePellet = true
	self.m_bIsCoinIng = true
	local tag = element:getTag()
	local num = 0
	if tag == 1 then
		num = 1
	else
		num = 5
	end
	local tab = {}
	tab.coinsNum = num
	tab = json.encode(tab)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7028, 2, tab)
end
--投币按钮置灰处理
function WndPelletMain:setCoinGrayRender(status)
	local btnOnceCoin = GetElement(self.m_root,"btnOnceCoin",WZUIButton)
	GetElement(btnOnceCoin,"imgOnceCoin",WZUIImage):setGrayRender(status)
	local txtOnceCoin = GetElement(btnOnceCoin,"txtOnceCoin",WZUILabelTTF)

	local btnFiveCoin = GetElement(self.m_root,"btnFiveCoin",WZUIButton)
	GetElement(btnFiveCoin,"imgFiveCoin",WZUIImage):setGrayRender(status)
	local txtFiveCoin = GetElement(btnFiveCoin,"txtFiveCoin",WZUILabelTTF)
	if status then
		txtOnceCoin:setColor(ccc3(255,255,255))
		txtOnceCoin:setStrokeColor(ccc3(80,61,50))
		txtFiveCoin:setColor(ccc3(255,255,255))
		txtFiveCoin:setStrokeColor(ccc3(80,61,50))
	else
		txtOnceCoin:setColor(ccc3(255,250,236))
		txtOnceCoin:setStrokeColor(ccc3(163,74,20))
		txtFiveCoin:setColor(ccc3(255,250,236))
		txtFiveCoin:setStrokeColor(ccc3(163,74,20))
	end
end
--创建珠子
function WndPelletMain:createPellet(num)
	if not self.m_root then return end

	num = num or 1
	if num > 0 then
		self.m_bIsCoinIng = true
	end
	local conCollde = GetElement(self.m_root,"conCollde",WZUIContainer)
	local conClipping = GetElement(self.m_root,"conClipping",WZUIClippingContainer)
	local imgCircle = GetElement(conClipping,"imgCircle",WZUIImage)
	imgCircle:setVisible(true)
	imgCircle:setAbsPosition(ccp(115,271))

	local mid_pos = {{21,225},{50,245}}
	local end_pos = {{27,107},{69,107},{47,141},{20,172},{79,169}}
	local array = CCArray:create()
	for i=self.m_nPelletIndex, num do
		local random = math.random(1,2)
		array:addObject(self:setCatmullRom(ccp(115,271), ccp(mid_pos[random][1], mid_pos[random][2]), ccp(end_pos[i][1], end_pos[i][2])))
		array:addObject(CCCallFunc:create(function()
			if self.m_tPelletBall[i] == nil then
				local imgBall = WZUIImage:create()
				imgBall:setFile("ui/activityWords/tndz_qiu_hong.png")
			    imgBall:setUseAbsCoordinate(true)
			    imgBall:setUseOriginSize(true)
				conCollde:addChild(imgBall)
				self.m_tPelletBall[i] = imgBall
			end
			self.m_tPelletBall[i]:setVisible(true)
			self.m_tPelletBall[i]:setAbsPosition(ccp(pelletPosEnd[i][1], pelletPosEnd[i][2]))
			self.m_tPelletBall[i]:setScale(0.7)
			if self.m_nPelletIndex >= num then
				self.m_bIsCreatePellet = nil
				self.m_bIsCoinIng = nil
				self:stopCoinTimeSchedule()
			end
			self.m_nPelletIndex = self.m_nPelletIndex + 1
			self:setCoinGrayRender(self.m_nPelletIndex >= 6)
		end))
	end
	array:addObject(CCCallFunc:create(function()
		imgCircle:setVisible(false)
	end))
	local seq = CCSequence:create(array)
	imgCircle:runAction(seq)	
end
--带拐弯的动作
function WndPelletMain:setCatmullRom(start_pos, mid_pos, end_pos)
	local pointArray = CCPointArray:create(20)
	pointArray:addControlPoint(start_pos)
	pointArray:addControlPoint(mid_pos)
	pointArray:addControlPoint(end_pos)
	return CCCatmullRomTo:create(0.05, pointArray)
end
--回忆录红点
function WndPelletMain:setRecallRedPoint()
	if not self.m_root then return end
	local visible = false
	if GlobalGame.g_tRedPointTypeList then
		visible = GlobalGame.g_tRedPointTypeList[37028] or GlobalGame.g_tRedPointTypeList[27028]
	end
	GetElement(self.m_root,"imgRecallRedPoint",WZUIImage):setVisible(visible)
end
--任务红点
function WndPelletMain:setTaskRedPoint()
	if not self.m_root then return end
	local visible = GlobalGame.g_tRedPointTypeList[127028]
	GetElement(self.m_root,"imgTaskRedPoint",WZUIImage):setVisible(visible)
end
function WndPelletMain:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self:setIsLuanching() then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT158)
		return
	end
	WindowManager:removeWindow(self.m_root, self, true)
end
--游戏币数量
function WndPelletMain:setPlayerCoin(num)
	if not self.m_root then return end
	if num then
		self.m_nPlayerCoin = self.m_nPlayerCoin + num
	end
	local coinRichText = GetElement(self.m_root,"coinRichText",WZUIFreeTextBox)
	local info = GDatatab_item["id_160145"]
	if info then
		local str = [[<I Z="0.4">%s</I><T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
		coinRichText:setShowText(string.format(str, info.icon, self.m_nPlayerCoin or 0))
	end
end
--*********协议返回***********
function WndPelletMain:_onGetPelletInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if activityId == tonumber(g_cityExtenInfo.activity7028) then
		local txtActivityTime = GetElement(self.m_root,"txtActivityTime",WZUILabelTTF)
		local _start = SystemTime:getTimeConverLocal8(startTime)
		local _end = SystemTime:getTimeConverLocal9(endTime)
		txtActivityTime:setText(_start.."-".._end)
		content = json.decode(content)
		if content then
			self.m_tBigSpecialRewards = content.specialRewards
			self.m_nPlayerCoin = content.coins
			self.m_nNoLuanchNum = content.marblesNum
			self:createPellet(self.m_nNoLuanchNum)
			self:setPlayerCoin()
		end
	end
end
--发射返回
function WndPelletMain:_onGetPelletResult(activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7028) then
		msg = json.decode(msg)
		if msg then
			if doType == 1 then
				self:getLaunchResult(msg)
				if result ~= 1 then
					self.m_bIsLuanchSpeed = nil
				end
			elseif doType == 2 then
				MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT160[result])
				if result == 1 then
					self.m_nPlayerCoin = msg.haveCoinsNum or 0
					self:setPlayerCoin()
					self:createPellet(msg.marblesNum)
				else
					self.m_bIsCoinIng = nil
					self:stopCoinTimeSchedule()
				end
			end
		end
	end
end
--收到发射协议处理
function WndPelletMain:getLaunchResult(data)
	local ids,nums = {},{}
	local big_ids, big_nums = {},{}
	local common_reward = {}
	local s_reward = 0 --S奖励
	if data.rewards then
		for i=1,#data.rewards do
			local _string = string.sub(data.rewards[i],2,-2)
			local id = SplitStringWithSeparator(_string,",")[1]
			local num = SplitStringWithSeparator(_string,",")[2]
			if data.targets[i] == 5 then --大奖
				table_insert(big_ids, id)
				table_insert(big_nums, num)
			else
				table_insert(ids, id)
				table_insert(nums, num)
				table_insert(common_reward, data.targets[i])
				if data.targets[i] == 3 then
					s_reward = s_reward + 1
				end
			end
		end
	end
	self:getProtoLaunchPelletPath(common_reward,function()
		local str = ""
		if s_reward > 0 then
			str = LocalStrings.ACTIVITY_TEXT173.."*"..s_reward.."  "
		end
		if data.memPieces > 0 then
			local _str = string.format("%s%s*%d",LocalStrings.GET, LocalStrings.ACTIVITY_TEXT154,data.memPieces)
			str = str .. _str
		end
		if str ~= "" then
			MsgBoxManager:showTipBox(str,0.5,nil,nil,nil,nil,nil,nil,nil,{x=0.5,y=0.8})
		end
		WndRewardShow:showById(ids, nums, common_reward)
		pushEquipInList()

		if next(big_ids) ~= nil then
			local tab = {}
			tab.id = big_ids
			tab.num = big_nums
			self.m_tBigRewardData = tab
			WndRewardShow:closeCallBack(self, self.showBigReward)
		end
	end)
end
function WndPelletMain:showBigReward()
	if self.m_tBigRewardData then
		WndHoraryBigReward:showInterface(4, self.m_tBigRewardData)
	end
end

--@brief 	红点
function WndPelletMain:showRedDot()
	-- body
	if self.m_root == nil then return end 

	self:setRecallRedPoint()
    self:setTaskRedPoint()
end

--@brief 	设置待机特效
function WndPelletMain:_setBallAni()
	local spinePath = "activity/ui_common_tndz"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineWait = GetElement(self.m_root, "spineWait_WndPelletMain", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("wait_1", true)
		end
	end

	local spinePath2 = "activity/ui_common_dzcbx"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		for i = 1, 4 do
			local spineWait = GetElement(self.m_root, "spineWait" .. i .. "_WndPelletmain", WZUISpine)
			if spineWait then 
				spineWait:setFileJson(spinePath2 .. ".json")
				spineWait:setFileAtlas(spinePath2 .. ".atlas")
				spineWait:play("wait_" .. i, true)
			end
		end
	end
end