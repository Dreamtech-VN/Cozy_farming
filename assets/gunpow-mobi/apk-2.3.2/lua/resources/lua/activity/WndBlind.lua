--WndBlind.lua
--@brief	WndBlind的UI模块
--@date		2021/03/22
--@author	hyx
--@note		弹弹盲盒


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBlind:onEnter(element)
	self.m_root = element
	ProtocolProcessorFestivalActivity:regAll6()
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBlind:onExit(element)
	if self.m_nBlindScheduleId then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nBlindScheduleId)
		self.m_nBlindScheduleId = nil
	end 
	self:unregister()
	self:_unInit()
	ProtocolProcessorFestivalActivity:unregAll()
end
function WndBlind:showInterface()
	local wndBlind = WndBlind:createElement()
	if wndBlind ~= nil then
	    WindowManager:addWindow(wndBlind,WndBlind,nil,false)
	end
end
function WndBlind:register()
	LoadActivityWordsRes(true)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetBlindInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetBlindResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onWndBlindGetBoxResult,self)
end
function WndBlind:unregister()
	LoadActivityWordsRes(false)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetBlindInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetBlindResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onWndBlindGetBoxResult,self)
end

function WndBlind:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function WndBlind:actionCallback()
	self:initShow()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7009, 7009)
end
function WndBlind:initShow()
	self.main_container = GetElement(self.m_root,"main_container",WZUIContainer)
	for i=1,3 do
		tab = {}
		local box = GetElement(self.main_container,"box"..i,WZUIContainer)
		local data = {
			path = "ui/otherUI/ui_common_Manghe",
			play = "wait_"..i,
			loop = true,
			ccp = GlobalMethod:ccp(0.5,0.1)
		}
		local existSpine = CheckEffectFile(data.path)
		if existSpine then 
			createEffectSpine(box,data)
		else
			local _sIndex = "ui_common_Manghe"
	        local downloadInfo = GetDownloadInfo(_sIndex, "uiEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(14100,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
	        end
		end

		tab.txtFreeStart = GetElement(box,"txtFreeStart"..i,WZUIFreeTextBox)
		tab.txtLimitBuy = GetElement(box,"txtLimitBuy"..i,WZUIFreeTextBox)
		tab.btnStart = GetElement(box,"btnStart"..i,WZUIButton)
		tab.txtBtnStart = GetElement(box,"txtBtnStart"..i,WZUILabelTTF)
		tab.openActiviteCon = GetElement(box,"openActiviteCon"..i,WZUIContainer)
		tab.btnSwitch = GetElement(box, "btnSwitch" .. i .. "_WndBlind", WZUIButton)
		self.m_tBoxActivateData[i] = tab
	end
	local box_container = GetElement(self.main_container,"box_container",WZUIContainer)
	local data = {}
	data.title = LocalStrings.BLIND_TEXT2[1]
	local box_common, box_common_obj = CellCommonBox:createElement(data, g_cityExtenInfo.activity7009)
	box_container:addChild(box_common)
	self.m_sBoxCommonObj = box_common_obj
end

function WndBlind:onClickBtnStart(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--防止点击过快
	if self.m_nBlindScheduleId then
		MsgBoxManager:showTipBox(LocalStrings.BLIND_TEXT10)
		return
	end
	--存在0.5秒的时间冻结，主要是不给连续点击按钮的
	self.m_nBlindScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
        if self.m_nBlindScheduleId then 
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nBlindScheduleId)
			self.m_nBlindScheduleId = nil
		end 
    end, 0.5, false)
	local tag = element:getTag()
	if self.m_tOpenORActiveData[tag] and self.m_tOpenORActiveData[tag].openTime == 0 then
		local sdkData = {}
        local chargeData = GDatatab_recharge["id_" .. self.m_tOpenORActiveData[tag].rechargeId]
        if chargeData then
	        sdkData.id = self.m_tOpenORActiveData[tag].rechargeId
	        sdkData.price = chargeData.price
	        sdkData.productName = tostring(chargeData.name)
	        sdkData.payCode = GetPayCodeIdByChannelId(chargeData)
	        sdkData.number = "1"
	        sdkData.giftNumber = "0"
	        sdkData.productDesc = tostring(chargeData.name)
	        PassportSdkManager:getOrderNum(sdkData)
	    end
	else
		local tab = {}
		tab.openIndex = tag
		if self.m_tOpenTimesSel[tag] == 1 then 
			tab.times = 1
		else
			local nTimes = self.m_tOpenORActiveData[tag].openTime >= self.m_nMaxTimes and self.m_nMaxTimes or self.m_tOpenORActiveData[tag].openTime
			tab.times = nTimes
		end
		local strTab = json.encode(tab)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7009, 2, strTab)
	end
end
function WndBlind:onClickBlind(element)
	local tag = element:getTag()
	if not self.m_tOpenORActiveData[tag] then return end
	if self.m_tOpenORActiveData[tag].canBuy ~= 0 and self.m_tOpenORActiveData[tag].openTime == 0 then
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		MsgBoxManager:showTipBox(LocalStrings.BLIND_TEXT11)
	end
end
function WndBlind:onBtnRank()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndRank = WndShopRank:createElement(4,g_cityExtenInfo.activity7009,7009)
    WindowManager:addWindow(wndRank,WndShopRank,nil,false)
end
function WndBlind:onClickRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFourStarRuleDesc:showInterface(LocalStrings.BLIND_TEXT3)
end
function WndBlind:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击切换多次开启
function WndBlind:onClickSwitch(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_tOpenTimesSel[nTag] == 1 then 
		self.m_tOpenTimesSel[nTag] = 2
	else
		self.m_tOpenTimesSel[nTag] = 1
	end
	self:setBlindActiviteView()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndBlind:_onGetBlindInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	local start_time = SystemTime:getTimeConverLocal4(startTime)
	local end_time = SystemTime:getTimeConverLocal4(endTime)
	local txtActivityTime = GetElement(self.main_container,"txtActivityTime",WZUILabelTTF)
	txtActivityTime:setText(start_time.."-"..end_time)
	if self.m_sBoxCommonObj then
		self.m_tBoxRewardData = self.m_sBoxCommonObj:setBoxProgressData(rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts,finishCondition)
	end

	self.m_tShowReward = {}
	local nSex = CacheCenter:getPlayerInfo().sex
	for i=1,#tips do
		self.m_tShowReward[i] = {}
		local array = SplitStringWithSeparator(tips[i], "&")
		for j = 1, #array do
			local str = string.sub(array[j], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(str,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(str,",")[3])
			table.insert(self.m_tShowReward[i], {id,num})
		end
	end
end

function WndBlind:_onGetBlindResult(activityId, doType, result, msg)
	msg = json.decode(msg)
	if msg then
		if doType == 1 and self.m_sBoxCommonObj then
			for i,v in ipairs(self.m_tBoxRewardData) do
				self.m_tBoxRewardData[i].status = msg.status[i]
			end
			self.m_sBoxCommonObj:setInitBoxStatus(msg.todayCount,self.m_tBoxRewardData)
			self:setOpenORActiveteData(msg)
		elseif doType == 2 then --开启盲盒返回
			if result == 2 then
				MsgBoxManager:showTipBox(LocalStrings.BLIND_TEXT9)
				return
			end
			if self.m_tOpenORActiveData[msg.openIndex] then
				self.m_tOpenORActiveData[msg.openIndex].openTime = msg.openTimes
			end
			local data = {}
			for i=1,#msg.itemIds do
				local tab ={}
				tab.id = msg.itemIds[i]
				tab.num = msg.itemNums[i]
				data[i] = tab
			end

			local otherData = CopyTable(self.m_tOpenORActiveData[msg.openIndex])
			otherData.maxTimes = self.m_nMaxTimes
			otherData.openIndex = msg.openIndex
			WndBlindReward:showInterface(data, 0, otherData)
		end
		self:setBlindActiviteView()
	end
end

function WndBlind:setBlindActiviteView()
	for i=1,#self.m_tOpenORActiveData do
		if self.m_tBoxActivateData[i] then
			self.m_tBoxActivateData[i].txtFreeStart:setShowText(string.format(LocalStrings.BLIND_TEXT7,self.m_tOpenORActiveData[i].activeCount))
			self.m_tBoxActivateData[i].txtLimitBuy:setVisible(false)
			if self.m_tOpenORActiveData[i].canBuy ~= 0 then
				self.m_tBoxActivateData[i].btnStart:setTouchEnable(true)
				self.m_tBoxActivateData[i].txtBtnStart:setColor(GlobalMethod:ccc3(255,250,236))
				self.m_tBoxActivateData[i].txtBtnStart:setStrokeColor(GlobalMethod:ccc3(163,74,20))
				if self.m_tOpenORActiveData[i].openTime == 0 then--购买
					self.m_tBoxActivateData[i].openActiviteCon:setVisible(false)
					self.m_tBoxActivateData[i].btnSwitch:setVisible(false)
					local info = GDatatab_recharge["id_" .. self.m_tOpenORActiveData[i].rechargeId]
					if info then
						self.m_tBoxActivateData[i].txtBtnStart:setText(string.format(LocalStrings.BLIND_TEXT5,info.unit))
						self.m_tBoxActivateData[i].txtBtnStart:setUseSystemFont(true)
					end
					self.m_tBoxActivateData[i].txtLimitBuy:setVisible(true)
					self.m_tBoxActivateData[i].txtLimitBuy:setShowText(string.format(LocalStrings.BLIND_TEXT12, self.m_tOpenORActiveData[i].canBuy,self.m_tOpenORActiveData[i].buyCount))
				else--开启盲盒
					self.m_tBoxActivateData[i].btnSwitch:setVisible(true)
					self.m_tBoxActivateData[i].txtLimitBuy:setVisible(true)
					local limit = self.m_tOpenORActiveData[i].openTime
					self.m_tBoxActivateData[i].txtLimitBuy:setShowText(string.format(LocalStrings.BLIND_TEXT6, limit,self.m_tOpenORActiveData[i].activeCount))
					if self.m_tOpenTimesSel[i] == 1 then 
						self.m_tBoxActivateData[i].txtBtnStart:setText(LocalStrings.BLIND_TEXT4)
					elseif self.m_tOpenTimesSel[i] == 2 then 
						local nTimes = self.m_tOpenORActiveData[i].openTime >= self.m_nMaxTimes and self.m_nMaxTimes or self.m_tOpenORActiveData[i].openTime
						self.m_tBoxActivateData[i].txtBtnStart:setText(string.format(LocalStrings.BLIND_TEXT2[2], nTimes))
					end
					self.m_tBoxActivateData[i].openActiviteCon:setVisible(false)
				end
			else
				self.m_tBoxActivateData[i].openActiviteCon:setVisible(false)
				self.m_tBoxActivateData[i].txtBtnStart:setText(LocalStrings.BLIND_TEXT4)
				self.m_tBoxActivateData[i].btnSwitch:setVisible(false)
				if self.m_tOpenORActiveData[i].openTime == 0 then
					self.m_tBoxActivateData[i].openActiviteCon:setVisible(false)
					self.m_tBoxActivateData[i].btnStart:setTouchEnable(false)
					self.m_tBoxActivateData[i].txtBtnStart:setColor(GlobalMethod:ccc3(255,255,255))
					self.m_tBoxActivateData[i].txtBtnStart:setStrokeColor(GlobalMethod:ccc3(80,61,50))
				else
					self.m_tBoxActivateData[i].txtLimitBuy:setVisible(true)
					local limit = self.m_tOpenORActiveData[i].openTime
					self.m_tBoxActivateData[i].txtLimitBuy:setShowText(string.format(LocalStrings.BLIND_TEXT6, limit,self.m_tOpenORActiveData[i].activeCount))
				end
			end
		end
	end
end

function WndBlind:_onWndBlindGetBoxResult(itemsId, count, _type, rewardId)
	WndRewardShow:showById(itemsId, count)
	if self.m_tBoxRewardData and self.m_tBoxRewardData[rewardId] then
		self.m_tBoxRewardData[rewardId].status = 1
		if self.m_sBoxCommonObj then
			self.m_sBoxCommonObj:setBoxStatus()
		end
	end
end


--@brief	打开奖励列表
function WndBlind:onClickShowReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	self:showRewardList(tag)
end

--@brief	更新展示的奖励
function WndBlind:showRewardList(nTag)
	GetElement(self.m_root,"conReward_WndBlind",WZUIContainer):setVisible(true)
	if self.m_tShowReward == nil then
		return
	end

	local tconShowReward = GetElement(self.m_root,"tconShowReward_WndBlind",WZUITableContainer)
	tconShowReward:cleanTable()
	local tItems = self.m_tShowReward[nTag]
	for i=1,#tItems do
		local cellElement,tNewObj = CellGoodItem:createElement()
		tNewObj:setCellGoodLocalId(tItems[i][1],tItems[i][2],17)
		tNewObj:setItemClickFun(self,self.onClickItem)
		cellElement:setTag(i-1)
		tconShowReward:setCellElement(cellElement)
	end
end

--@brief	点击显示奖励列表中奖励
function WndBlind:onClickItem(luaTable,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief	关闭奖励列表
function WndBlind:onClickCloseReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    GetElement(self.m_root,"conReward_WndBlind",WZUIContainer):setVisible(false)
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------
function WndBlind:_adaptLanguage_vn()
	local txtFreeStart1 = GetElement(self.m_root,"txtFreeStart1",WZUIFreeTextBox)
	txtFreeStart1:setScale(0.8)
	txtFreeStart1:setMaxWidth(300)
	local txtFreeStart2 = GetElement(self.m_root,"txtFreeStart2",WZUIFreeTextBox)
	txtFreeStart2:setScale(0.8)
	txtFreeStart2:setMaxWidth(300)
	local txtFreeStart3 = GetElement(self.m_root,"txtFreeStart3",WZUIFreeTextBox)
	txtFreeStart3:setScale(0.8)
	txtFreeStart3:setMaxWidth(300)

	local txtBtnStart1 = GetElement(self.m_root,"txtBtnStart1",WZUILabelTTF)
	txtBtnStart1:setScale(0.8)
	txtBtnStart1:setDimensions(GlobalMethod:CCSize(140,0))
	local txtBtnStart2 = GetElement(self.m_root,"txtBtnStart2",WZUILabelTTF)
	txtBtnStart2:setScale(0.8)
	txtBtnStart2:setDimensions(GlobalMethod:CCSize(140,0))
	local txtBtnStart3 = GetElement(self.m_root,"txtBtnStart3",WZUILabelTTF)
	txtBtnStart3:setScale(0.8)
	txtBtnStart3:setDimensions(GlobalMethod:CCSize(140,0))
end
-------------------------------------语言适配模块End----------------------------------------

