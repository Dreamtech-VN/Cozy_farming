--WndNewYearMain.lua
--@brief	WndNewYearMain的UI模块
--@date		2020/12/01
--@author	hyx
--@note		元旦求签


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndNewYearMain:onEnter(element)
	self.m_root = element
	self:register()
	ProtocolProcessorFestivalActivity:regAll4()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndNewYearMain:onExit(element)
	if self.m_sRemainTimeTicker then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sRemainTimeTicker)
		self.m_sRemainTimeTicker = nil
	end 

	if self.m_sRewardSpine then
		self.m_sRewardSpine:removeFromParentAndCleanup(true)
		self.m_sRewardSpine = nil
	end
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
end
function WndNewYearMain:onEnterTransitionDidFinish(element)
	self:_setSpineAni()
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndNewYearMain:actionCallback()
	self:initShow()
end
function WndNewYearMain:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_NewYearInfo,self._onGetNewYearInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_NewYearSignResult,self._onGetNewYearSignResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_NewYearSignGet,self._onGetNewYearSignGetResult,self)
end
function WndNewYearMain:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_NewYearInfo,self._onGetNewYearInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_NewYearSignResult,self._onGetNewYearSignResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_NewYearSignGet,self._onGetNewYearSignGetResult,self)
end
function WndNewYearMain:showInterface()
	local wndNewYear = WndNewYearMain:createElement()
    WindowManager:addWindow(wndNewYear,WndNewYearMain,nil,false)
end

function WndNewYearMain:initShow()
	self:setConfigInitData()

	self.m_sImgSelectDayGet = GetElement(self.m_root,"imgSelectDayGet",WZUIImage)
	self.m_sTxtActivityTime = GetElement(self.m_root,"txtActivityTime",WZUILabelTTF)
		
	self:setSignSelectVisible(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120Info( )
end
--任务红点
function WndNewYearMain:setTaskRedPointVisible(visible)
	local imageTaskRedPoint = GetElement(self.m_root,"imageTaskRedPoint",WZUIImage)
	if imageTaskRedPoint then
		imageTaskRedPoint:setVisible(visible)
	end
end
--签到红点
function WndNewYearMain:setSignRedPointVisible(status)
	local imageSignRedPoint = GetElement(self.m_root,"imageSignRedPoint",WZUIContainer)
	if imageSignRedPoint then
		local visible = false
		if status == 1 then
			visible = true
		end
		imageSignRedPoint:setVisible(visible)
	end
end
--求签数量
function WndNewYearMain:setSignCount(num)
	local txtMyAskCount = GetElement(self.m_root,"txtMyAskCount",WZUILabelTTF)
	if txtMyAskCount then
		txtMyAskCount:setText(LocalStrings.EVERYDAYBUY_TEXT21..num)
	end
end
function WndNewYearMain:onBtnTab(element)
	local index = element:getTag()

	if index == 1 then
		self:setSignSelectVisible(true)
		if self.m_nJoinRewardStatus == 0 then
			local str = string.format(LocalStrings.EVERYDAYBUY_TEXT23,self.m_nJoinRewardCount)
			local ids,nuns = self:getJoinRewardData()
			WndJoinReward:showInterface(str,ids,nuns)
		elseif self.m_nJoinRewardStatus == 1 then
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120ReceiveReward( )
		elseif self.m_nJoinRewardStatus == 2 then
			MsgBoxManager:showTipBox(LocalStrings.EVERYDAYBUY_TEXT24)
		end
	elseif index == 2 then
		self:setSignSelectVisible(false)
		local cellTask = CellNewYearTask:createElement()
    	WindowManager:addWindow(cellTask,CellNewYearTask,nil,false)
	elseif index == 3 then
		local wndRank = WndShopRank:createElement(2)
        WindowManager:addWindow(wndRank,WndShopRank,nil,false)
	end
end
function WndNewYearMain:setSignSelectVisible(visible)
	if self.m_sImgSelectDayGet then
		self.m_sImgSelectDayGet:setVisible(visible)
	end
end
function WndNewYearMain:onBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)	
	WndSingleMapDesc:showInterface(LocalStrings.EVERYDAYBUY_TEXT28)
end
--求签
function WndNewYearMain:onBtnAskSign()
	if self.m_nTouchSignTicker then
		MsgBoxManager:showTipBox(LocalStrings.EVERYDAYBUY_TEXT27)
		return
	end
	local monNum =  CacheCenter:getPlayerItemCountById(self.m_nDivinationCostId) 
	if tonumber(monNum) < tonumber(self.m_nDivinationCostNum) then
		MsgBoxManager:showTipBox(LocalStrings.EVERYDAYBUY_TEXT29)
		return
	end
	--存在0.5秒的时间冻结，主要是不给连续点击按钮的
	self.m_nTouchSignTicker = true

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)	
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120Do( )
end
function WndNewYearMain:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndNewYearMain:_onGetNewYearInfo(startTime, endTime, nextDayTime, prayItemNum, joinRewardStatus, isTaskReward)
	if not self.m_sRemainTimeTicker then
		self.m_sRemainTimeTicker = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
			nextDayTime = nextDayTime - 1 
			if nextDayTime <= 0 then
				if self.m_sRemainTimeTicker then 
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sRemainTimeTicker)
				end
				MsgBoxManager:showConfirmBox(LocalStrings.EVERYDAYBUY_TEXT15, self, function()
					ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120Info( )
				end, nil, nil,true)
			end
	    end, 1, false)
	end
	if self.m_sTxtActivityTime then
		self.m_sTxtActivityTime:setText(SystemTime:getTimeConverLocal4(startTime).."-"..SystemTime:getTimeConverLocal4(endTime))
	end
	self.m_nJoinRewardStatus = joinRewardStatus
	self:setTaskRedPointVisible(isTaskReward)
	self:setSignCount(prayItemNum)
	self:setSignRedPointVisible(joinRewardStatus)
end
function WndNewYearMain:_onGetNewYearSignResult(result, itemId, itemNum, prayItemNum, joinRewardStatus, isTaskReward)
	self:setTaskRedPointVisible(isTaskReward)
	self:setSignCount(prayItemNum)
	self.m_nJoinRewardStatus = joinRewardStatus
	self:setSignRedPointVisible(joinRewardStatus)

	self.m_tSignReward = {result = result, itemId = itemId, itemNum = itemNum}
	if self.m_root then
		local existSpine = CheckEffectFile("ui/otherUI/ui_qiuqian")
		if existSpine then 
			self.m_sRewardSpine = WZUISpine:create()
			self.m_sRewardSpine:setTouchEnable(false)
			self.m_sRewardSpine:setFileJson("ui/otherUI/ui_qiuqian.json")
			self.m_sRewardSpine:setFileAtlas("ui/otherUI/ui_qiuqian.atlas")
			local str = {"wait_2","wait_3","wait_4","wait_1"}
			self.m_sRewardSpine:play(str[result+1], false)	
			self.m_sRewardSpine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			self.m_root:addChild(self.m_sRewardSpine)
		    self.m_sRewardSpine:setLuaSpineEventFunc("animationEventFunc")
		else
			local _sIndex = "ui_qiuqian"
	        local downloadInfo = GetDownloadInfo(_sIndex, "uiEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(14205,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
	        end

	        self:animationEventFunc(nil, "end")
		end
	end
end
function WndNewYearMain:animationEventFunc(animation, name, eventName)
	if name == "end" then
		WndNewYearSignReward:showInterface(self.m_tSignReward.result, self.m_tSignReward.itemId, self.m_tSignReward.itemNum)
		if self.m_sRewardSpine then
			self.m_nTouchSignTicker = false
			self.m_sRewardSpine:removeFromParentAndCleanup(true)
			self.m_sRewardSpine = nil
		end
	end
end
function WndNewYearMain:_onGetNewYearSignGetResult(result, itemId, itemNum)
	if result == 0 then
		WndRewardShow:showById(itemId, itemNum)
		self.m_nJoinRewardStatus = 2
		self:setSignRedPointVisible(false)
	else
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
	end
end

--@brief 	设置待机特效
function WndNewYearMain:_setSpineAni()
	local spinePath = "ui/otherUI/hd_pic_ydqd"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineCircle = GetElement(self.m_root, "spineCircle_WndNewYearMain", WZUISpine)
		if spineCircle then 
			spineCircle:setFileJson(spinePath .. ".json")
			spineCircle:setFileAtlas(spinePath .. ".atlas")
			spineCircle:play("ui_box", true)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
