--WndFourStar.lua
--@brief	WndFourStar的UI模块
--@date		2021/02/19
--@author	hyx
--@note		四象星宿


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFourStar:onEnter(element)
	self.m_root = element
	ProtocolProcessorFestivalActivity:regAll6()
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFourStar:onExit(element)
	if self.m_sSummonRewardSpine then
		self.m_sSummonRewardSpine:removeFromParentAndCleanup(true)
		self.m_sSummonRewardSpine = nil
	end
	if self.m_sSummonStartSpine then
		self.m_sSummonStartSpine:removeFromParentAndCleanup(true)
		self.m_sSummonStartSpine = nil
	end
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
end

function WndFourStar:register()
	LoadActivityWordsRes(true)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetFourStarInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetFourStarResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onWndFourStarGetBoxResult,self)

end
function WndFourStar:unregister()
	LoadActivityWordsRes(false)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetFourStarInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetFourStarResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onWndFourStarGetBoxResult,self)
end

function WndFourStar:showInterface()
	local wndStar = WndFourStar:createElement()
	if wndStar ~= nil then
	    WindowManager:addWindow(wndStar,WndFourStar,nil,false)
	end
end

function WndFourStar:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndFourStar:actionCallback()
	self:getPoleType()
	self:initShow()
	if g_cityExtenInfo then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7008, 7008)
	end
end

function WndFourStar:initShow()
	local box_contation = GetElement(self.m_root,"box_contation",WZUIContainer)
	if g_cityExtenInfo then
		local box_common, box_common_obj = CellCommonBox:createElement(nil, g_cityExtenInfo.activity7008)
		box_contation:addChild(box_common)
		self.m_sBoxCommonObj = box_common_obj

		local status = self:getLibraryRedPoint()
		self:setImgLibraryRedPoint(status)
	end
end
function WndFourStar:setImgLibraryRedPoint(visible)
	if self.m_root == nil then return end 
	
	local imgLibraryRedPoint = GetElement(self.m_root,"imgLibraryRedPoint",WZUIImage)
	if imgLibraryRedPoint then
		imgLibraryRedPoint:setVisible(visible)
	end
end

function WndFourStar:onBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFourStarRuleDesc:showInterface(LocalStrings.FOURSTAR_TEXT1)
end

--召唤或选择奖励
function WndFourStar:onBtnSummon()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_nSummonChoose then return end
	if self.m_nSummonChoose == 1 then
		if self.m_nSummonCount > 0 then
			if not self.m_sSummonStartSpine then
				local fourStarContainer = GetElement(self.m_root,"fourStarContainer",WZUIContainer)
				local data = {
					path = "ui/otherUI/ui_common_zhaohuan",
					play = "ui_common_zhaohuan"
				}
				local existSpine = CheckEffectFile(data.path)
				if existSpine then 
					self.m_sSummonStartSpine = createEffectSpine(fourStarContainer,data)
					self.m_sSummonStartSpine:setLuaSpineEventFunc("setSummonStart")
				else
					self:setSummonStart(nil, "end")
				end
			end
		else
			MsgBoxManager:showTipBox(LocalStrings.FOURSTAR_TEXT17)
		end
	elseif self.m_nSummonChoose == 2 then
		WndFourStarChooseReward:showInterface()
	end
end
function WndFourStar:setSummonStart(animation, name, eventName)
	if name == "end" then
		local nTimes = 1 
		if self.m_nCalabashType == 1 then 
			if self.m_nSummonCount >= 10 then 
				nTimes = 10
			else
				nTimes = self.m_nSummonCount
			end	
		end
		local tab = {}
		tab.version = self.m_nSummonVersion
		tab.times = nTimes
		tab = json.encode(tab)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7008, 3, tab)
		if self.m_sSummonStartSpine then
			self.m_sSummonStartSpine:removeFromParentAndCleanup(true)
			self.m_sSummonStartSpine = nil
		end
	end
end

function WndFourStar:onBtnLibrary()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFourStarLabrary:showInterface()
end
function WndFourStar:onBtnRank()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFourStarRank:showInterface()
end
function WndFourStar:onBtnChooseReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFourStarChooseReward:showInterface()
end

function WndFourStar:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local curDate = os.date("*t", SystemTime:getServerTime())
    local curValue = string.format("%02d%02d_%d", curDate.month, curDate.day, self.m_nCalabashType)
	SaveActivityPoleType("FOURSTAR", curValue)

	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击十连抽复选框回调
function WndFourStar:onClickTen(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	self.m_nCalabashType = GetElement(self.m_root, "cbTen_WndFourStar", WZUICheckBox):getCheckIndex()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFourStar:_onGetFourStarInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	self:setTxtSummonCount(count)
	self:setBoxProgressData(rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts,finishCondition)
	local txtActivityTime = GetElement(self.m_root,"txtActivityTime",WZUIFreeTextBox)
	if txtActivityTime then
		local str = string.format([[<T C="255,227,116" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T><T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s-%s</T>]],
					LocalStrings.PEOPLE_SHOP_TEXT1,SystemTime:getTimeConverLocal4(startTime),SystemTime:getTimeConverLocal4(endTime))
		txtActivityTime:setShowText(str)
	end
	if self.m_sBoxCommonObj then
		self.m_sBoxCommonObj:setInitBoxStatus(maxCount,self.m_tBoxProgressData, g_cityExtenInfo.activity7008)
	end
end

function WndFourStar:_onGetFourStarResult(activityId, doType, result, msg)
	msg = json.decode(msg)
	if msg then
		if doType == 7 or doType == 6 then
			self:setSummonReward(msg)
			if doType == 7 then
				if self.m_sIsFirstComeIn == true then
					WndFourStarRuleDesc:showInterface(LocalStrings.FOURSTAR_TEXT1,function()
						WndFourStarChooseReward:showInterface()
					end)
				end
			end

			local txtSummonChange = GetElement(self.m_root,"txtSummonChange",WZUILabelTTF)
			if self.m_nSummonChoose == 1 then
				txtSummonChange:setText(LocalStrings.FOURSTAR_TEXT8)
			elseif self.m_nSummonChoose == 2 then
				txtSummonChange:setText(LocalStrings.FOURSTAR_TEXT9)
			end
			for i=1,4 do
				local summonReward = GetElement(self.m_root,"summonReward"..i,WZUIContainer)
				if self.m_tSummonReward[i].status == -1 then
					summonReward:setVisible(false)
				else
					summonReward:setVisible(true)
				end
				local tabItem = GDatatab_item["id_"..self.m_tSummonReward[i].id]
				if tabItem then
					local reward_img = GetElement(summonReward,"reward_img"..i,WZUIImage)
					reward_img:setFile(tabItem.icon)
				end
				GetElement(summonReward,"reward_count"..i,WZUILabelTTF):setText(math.abs(self.m_tSummonReward[i].num))
			end
		elseif doType == 3 then --召唤
			self:setTxtSummonCount(msg.num)
			if self.m_sBoxCommonObj then
				for i,v in ipairs(msg.status) do
					self.m_tBoxProgressData[i].status = v
				end
				self.m_sBoxCommonObj:setInitBoxStatus(msg.todayCount,self.m_tBoxProgressData)
			end
			if msg.itemIds and #msg.itemIds > 1 then --用通用奖励展示界面展示
				local rewardType = 8 
				local itemIdIndex = 1
				local normalRewards = {}
				local bigRewards = {}
				if msg.itemIds then 
					for i = 1, #msg.itemIds do
						local tItem = {}
						tItem.itemId = msg.itemIds[i]
						tItem.itemNum = msg.itemNums[i]
						tItem.type = rewardType
						tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
						tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
						table.insert(normalRewards, tItem)

						itemIdIndex = itemIdIndex + 1
					end
				end
				local bigRewardType = 26 
				local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
				if msg.bigItemIds then 
					for i = 1, #msg.bigItemIds do
						local tItem = {}

						tItem.itemId = msg.bigItemIds[i]
						tItem.itemNum = msg.bigItemNums[i]
						tItem.type = bigRewardType
					--	tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_dxj.png"
						tItem.imgBK = "ui/activity/hd_pic_sxxx_jl.png"
						tItem.strTitle = LocalStrings.FOURSTAR_TEXT27
						tItem.txtTitlePt = {0.5,0.885}
						tItem.goodsconPt = {0.5,0.455}

						table.insert(bigRewards, tItem)

						itemIdIndex = itemIdIndex + 1
					end
				end
				--弹活得碎片提示语
				if msg.pieceItemIds then 
					local strContent = ""
					for i = 1, #msg.pieceItemIds do
						if i == 1 then 
							strContent = strContent .. LocalStrings.CRAZY_DOUBLING_TEXT8 .. " "
						else
							strContent = strContent .. ", "
						end
						local basicData = GDatatab_item["id_" .. msg.pieceItemIds[i]]
						strContent = strContent .. basicData.name .. "*" .. msg.pieceItemNums[i]
					end

					if strContent ~= "" then 
						MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
					end
				end

				if normalRewards and #normalRewards > 0 then 
					WndHoraryBigReward:showInterface(8, normalRewards, bigRewards)
				elseif #bigRewards > 0 then 
					WndHoraryBigReward:showInterface(9, bigRewards)
				end
			else --如果只有一个普通奖励，还走原来的奖励展示
				local index = 1
				self.m_sSummonRewardData = msg
				if msg.bigItemIds or msg.pieceItemIds then
					index = 2
					if msg.bigItemIds and msg.pieceItemIds then
						index = 3
					end
				end
				WndFourStarSummonReward:showInterface(self.m_sSummonRewardData, index)
			end
		end
	end
end
function WndFourStar:setTxtSummonCount(count)
	self.m_nSummonCount = count  
	local info = GDatatab_item["id_" .. self.m_nCoinId]
	if info then
		local txtSummonCount = GetElement(self.m_root,"txtSummonCount",WZUIFreeTextBox)
		local str =string.format([[<I Z="0.5">%s</I><T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">:%s</T>]],info.icon,count)
		txtSummonCount:setShowText(str)
	end
end
--获得召唤奖励
function WndFourStar:getSummonReward(animation, name, eventName)
	if name == "end" then
		if self.m_sSummonRewardSpine then
			self.m_sSummonRewardSpine:removeFromParentAndCleanup(true)
			self.m_sSummonRewardSpine = nil
		end
	end
end
function WndFourStar:_onWndFourStarGetBoxResult(itemsId, count, _type, rewardId)
	WndRewardShow:showById(itemsId, count)
	if self.m_tBoxProgressData and self.m_tBoxProgressData[rewardId] then
		self.m_tBoxProgressData[rewardId].status = 1
		if self.m_sBoxCommonObj then
			self.m_sBoxCommonObj:setBoxStatus()
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndFourStar:_adaptLanguage_vn()
	GetElement(self.m_root,"btnChooseReward_WndFourStar",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.69,0.22))
end
-------------------------------------语言适配End----------------------------------------
