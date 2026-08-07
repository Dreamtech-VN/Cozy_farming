--WndMainHorary.lua
--@brief	WndMainHorary的UI模块
--@date		2021/07/19
--@author	hyx
--@note		占卜主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMainHorary:onEnter(element)
	self.m_root = element
	self:register()
	ProtocolProcessorFestivalActivity:regAll6()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMainHorary:onExit(element)
	if self.m_nVersion then
		local tab = {}
		tab.select = self.m_nRewardIndex
		tab.version = self.m_nVersion
		tab = json.encode(tab)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7023, 4, tab)
	end
	if self.m_sHorarySpine then
		self.m_sHorarySpine:removeFromParentAndCleanup(true)
	end
	if self.m_sChooseTypeSpine then
		self.m_sChooseTypeSpine:removeFromParentAndCleanup(true)
	end
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
end
function WndMainHorary:showInterface()
	local wndHorary = WndMainHorary:createElement()
	if wndHorary ~= nil then
	    WindowManager:addWindow(wndHorary,WndMainHorary,nil,nil)
	end
end
function WndMainHorary:getRootPanel()
	if self.m_root then
		return GetElement(self.m_root,"main_panel",WZUIContainer)
	end
end

function WndMainHorary:register()
	LoadActivityWordsRes(true)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetHoraryInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetHoraryResult,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
end
function WndMainHorary:unregister()
	LoadActivityWordsRes(false)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetHoraryInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetHoraryResult,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
end

function WndMainHorary:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
	if IsIphoneX() then
		GetElement(self.m_root,"todayRewardFreeList",WZUIFreeListContainer):setRelativePosition(ccp(2.24,0.51))
	end
end
function WndMainHorary:actionCallback()
	self:initShow()
end
function WndMainHorary:initShow()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7023, 7023)
	self:showRedDot()
end
--今日卦象奖励
function WndMainHorary:setTodayReward(data)
	if not data then return end

	local todayContainer = GetElement(self.m_root,"todayContainer",WZUIContainer)
	local todayReward = GetElement(todayContainer,"todayRewardFreeList",WZUIFreeListContainer)
	todayReward:removeAll()
	local ids, nums = self:getRewardData(data)
	for i = 1, #ids do
		if GDatatab_item["id_"..ids[i]] then
			local celElement, tLuaObj = CellGoodItem:createElement()
	        celElement = WZUIContainer:luaTo(celElement)
	        celElement:setTag(i-1)
	        celElement:setScale(0.8)		
	        local itemInfo = {lastTime=nums[i],lastNum=nums[i],basicInfo=CopyTable(GDatatab_item["id_"..ids[i]])}
	        tLuaObj:setCellGoodItem(itemInfo, 17)
	        tLuaObj:setItemClickFun(self,self.onClickItem)
	        todayReward:pushBack(celElement)
	        todayReward:getMoveElement():setPositionX(todayReward:getMaxPosition().x)
	        if self.m_nRewardIndex ~= -1 and (self.m_nRewardIndex+1) == i then
	        	tLuaObj:setItemSelState(true)
	        	self.m_tChooseItemCell = tLuaObj
	        end
	    end
    end
end
function WndMainHorary:onClickItem(tCell,tag,tData)
	if tData == nil then
       return
    end
    if self.m_tChooseItemCell then
    	self.m_tChooseItemCell:setItemSelState(false)
    end
    tCell:setItemSelState(true)
    if self.m_nVersion then 
	    local tab = {}
		tab.select = self.m_nRewardIndex
		tab.version = self.m_nVersion
		tab = json.encode(tab)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7023, 4, tab)
	end

    self.m_tChooseItemCell = tCell
    self.m_nRewardIndex = tag
    WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData, false,ccp(0,50))
end
--点击卡牌时候
function WndMainHorary:onBtnHoraryCard(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if not self.m_tGetCardData[tag] then return end

	if not self:getCount() and self.m_tGetCardData[tag] then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT77)
		return
	end
	self:setChooseTypeSpine(tag)
	GetElement(self.m_root,"txtBtnHorary1",WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT76)
	self.m_nCardSelect = tag - 1
end
--选中骨牌特效
function WndMainHorary:setChooseTypeSpine(index)
	local horaryCard = GetElement(self.m_root,"horaryCard"..index,WZUIContainer)
	local spine_con = GetElement(horaryCard,"spine_con",WZUIContainer)
	if self.m_sChooseTypeSpine then
		self.m_sChooseTypeSpine:removeFromParentAndCleanup(true)
		self.m_sChooseTypeSpine = nil
	end

	local existSpine = CheckEffectFile("activity/ui_common_zhanbo")
	if existSpine then 
		self.m_sChooseTypeSpine = WZUISpine:create()
		self.m_sChooseTypeSpine:setTouchEnable(false)
		self.m_sChooseTypeSpine:setFileJson("activity/ui_common_zhanbo.json")
		self.m_sChooseTypeSpine:setFileAtlas("activity/ui_common_zhanbo.atlas")
		self.m_sChooseTypeSpine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		self.m_sChooseTypeSpine:play("wait_5", true)
		spine_con:addChild(self.m_sChooseTypeSpine)
	else
		local _sIndex = "ui_common_zhanbo"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(14208,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
        end
	end
end
--占卜
function WndMainHorary:onBtnHorary(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_bIsOpenCard then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT100)
		return
	end
	local tag = element:getTag()
	if tag == 2 and not self:getCount() then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT78)
		return
	end
	if not self.m_nHoraryNumber then
		return
	end
	if self.m_nFreeTimes == 0 then
		if self.m_nHoraryNumber <= 0 then
			MsgBoxManager:showConfirmBox(LocalStrings.ACTIVITY_TEXT109, self, function()
				WndApartmentAct:showInterface(3044)
			end, nil, {[MSGBOXUICFG_CONFIRM] = LocalStrings.ACTIVITY_TEXT108})
			return
		end
	end
	if self:getCount() and self.m_nCardSelect == -1 and tag == 1 then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT94)
		return
	end
	if tag == 1 then
		if self.m_nCurMultiple > 1 then
			if self.m_nCardSelect == -1 then
				MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT94)
			else
				local str = self:getMultipleHorary(self.m_nCurMultiple)
				MsgBoxManager:showConfirmBox(string.format(LocalStrings.ACTIVITY_TEXT107,str), self, function()
					if self.m_nVersion then
						local tab = {}
						tab.select = self.m_nCardSelect
						tab.version = self.m_nVersion
						tab = json.encode(tab)
						ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7023, 3, tab)
					end
				end, nil, {[MSGBOXUICFG_CONFIRM] = LocalStrings.ACTIVITY_TEXT106},nil,nil,nil,function()
					self.m_bIsOpenCard = nil
				end)
			end
			return
		end
	end
	--有卦象的时候不会执行下面
	local _type = 3
	if tag == 2 then
		_type = 5
		if self.m_sChooseTypeSpine then
			self.m_sChooseTypeSpine:removeFromParentAndCleanup(true)
			self.m_sChooseTypeSpine = nil
		end
	end
	self.m_bIsOpenCard = true
	self.m_nHoraryType = _type
	if _type == 5 then
		if self.m_nVersion and self.m_nHoraryType then
			local tab = {}
			tab.select = self.m_nRewardIndex
			tab.version = self.m_nVersion
			tab = json.encode(tab)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7023, self.m_nHoraryType, tab)
		end
	else
		local existSpine = CheckEffectFile("activity/ui_common_zhanbo")
		if existSpine then 
			self:createHorarySpine()
			if self.m_sHorarySpine then
				self.m_sHorarySpine:play("wait_1", false)
				self.m_sHorarySpine:setLuaSpineEventFunc("animationEventFunc")
			end
		else
			local _sIndex = "ui_common_zhanbo"
	        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(14208,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
	        end

	        self:animationEventFunc(nil, "complete")
		end
	end
end
--
function WndMainHorary:createHorarySpine()
	if self.m_sHorarySpine then
		self.m_sHorarySpine:removeFromParentAndCleanup(true)
		self.m_sHorarySpine = nil
	end
	self.m_sHorarySpine = WZUISpine:create()
	self.m_sHorarySpine:setTouchEnable(false)
	self.m_sHorarySpine:setFileJson("activity/ui_common_zhanbo.json")
	self.m_sHorarySpine:setFileAtlas("activity/ui_common_zhanbo.atlas")
	self.m_sHorarySpine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	self.m_root:addChild(self.m_sHorarySpine)
end
function WndMainHorary:animationEventFunc(animation, name, eventName)
	if name == "complete" then
		if self.m_sHorarySpine then
			self.m_sHorarySpine:removeFromParentAndCleanup(true)
			self.m_sHorarySpine = nil
		end
		if self.m_nVersion and self.m_nHoraryType then
			local tab = {}
			tab.select = self.m_nCardSelect
			tab.version = self.m_nVersion
			tab = json.encode(tab)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7023, self.m_nHoraryType, tab)
		end
	end
end
--等级奖励
function WndMainHorary:onBtnReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndHoraryLevReward:showInterface()
end
function WndMainHorary:onBtnTodayRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndHoraryRule:showInterface()
end
function WndMainHorary:onBtnTask()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndDollMachineTask:showInterface(g_cityExtenInfo.activity7023, 1, 1)
end
function WndMainHorary:onBtnRank()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndShopRank:showInterface(6, g_cityExtenInfo.activity7023, 7023)
end
function WndMainHorary:onBtnBigReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.n_BigReward then
		local ids, nums = self:getRewardData(self.n_BigReward)
		WndJoinReward:showInterface("", ids, nums, LocalStrings.TREASURE_TEXT7)
	end
end
--截取奖励数据
function WndMainHorary:getRewardData(data)
	local array = SplitStringWithSeparator(data,"&")
	local table_insert = table.insert
	local ids = {}
	local nums = {}
	for i=1,#array do
		local _string = string.sub(array[i],2,-2)
		local id = nil
		if CacheCenter:getPlayerInfo().sex == 0 then
			id = SplitStringWithSeparator(_string,",")[1]
		else
			id = SplitStringWithSeparator(_string,",")[2]
		end
		local num = SplitStringWithSeparator(_string,",")[3]
		table_insert(ids,id)
		table_insert(nums,num)
	end
	return ids, nums
end
--界面的数据
function WndMainHorary:setHoraryData(data)
	self.m_nFreeTimes = data.free --1免费 0 收费
	self.m_nCardSelect = data.cardSelect
	-- 
	if not self.m_bIsFirstComeIn then
		self.m_nRewardIndex = data.gxSelect
		--初次进入有选择的时候
		if self.m_nCardSelect ~= -1 then
			self:setChooseTypeSpine(self.m_nCardSelect+1)
		end
		self:setTodayReward(self.n_tGxReward)
	end
	self.m_bIsFirstComeIn = true
	local txtBtnHorary1 = GetElement(self.m_root,"txtBtnHorary1",WZUILabelTTF)
	if data.free == 1 then
		txtBtnHorary1:setText(LocalStrings.ACTIVITY_TEXT89)
	else
		if self.m_nCardSelect ~= -1 then
			txtBtnHorary1:setText(LocalStrings.ACTIVITY_TEXT76)
		else
			txtBtnHorary1:setText(LocalStrings.ACTIVITY_TEXT90)
		end
	end
	--星石数量
	self.m_nHoraryNumber = data.num
	local txtHoraryNum = GetElement(self.m_root,"txtHoraryNum",WZUIFreeTextBox)
	local itemInfo = GDatatab_item["id_160129"]
	if itemInfo then
		txtHoraryNum:setShowText(string.format([[<I Z="0.35">%s</I><T C="255,255,255" S="16" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]],itemInfo.icon,data.num))
	end
	local levContainer = GetElement(self.m_root,"levContainer",WZUIContainer)
	--等级
	GetElement(levContainer,"txtLev",WZUILabelTTF):setText("Lv"..data.level)
	local txtLevelName = GetElement(levContainer,"txtLevelName",WZUILabelTTF)
	if data.level >= 5 then
		txtLevelName:setText(LocalStrings.ACTIVITY_TEXT82)
	else
		txtLevelName:setText(LocalStrings.ACTIVITY_TEXT81[data.level+1])
	end
	--经验
	local txtProgress = GetElement(levContainer,"txtProgress",WZUILabelTTF)
	local levProgress = GetElement(levContainer,"levProgress",WZUIProgress)
	if data.maxExp == -1 then
		txtProgress:setText("Max")
		levProgress:setPercentage(100)
	else
		txtProgress:setText(data.exp.."/"..data.maxExp)
		levProgress:setPercentage(data.exp / data.maxExp * 100)
	end
	--当前倍数
	local todayContainer = GetElement(self.m_root,"todayContainer",WZUIContainer)
	self.m_nCurMultiple = data.times
	local txtMultiple = GetElement(todayContainer,"txtMultiple",WZUILabelTTF)
	if data.times > 1 then
		txtMultiple:setText(data.times..LocalStrings.ACTIVITY_TEXT80)
	else
		txtMultiple:setText(LocalStrings.NONE)
	end
	--卡牌数据
	for i=1,3 do
		local horaryCardCon = GetElement(self.m_root,"horaryCard"..i,WZUIContainer)
		local imgCard1 = GetElement(horaryCardCon,"imgCard1",WZUIImage)
		local imgCard2 = GetElement(horaryCardCon,"imgCard2",WZUIImage)
		local imgHoraryType = GetElement(self.m_root,"imgHoraryType"..i,WZUIImage)
		imgHoraryType:setVisible(true)
		self.m_tGetCardData[i] = data.cards[i]
		if data.cards[i] == 0 then
			imgCard1:setVisible(true)
			imgCard2:setVisible(false)
			imgHoraryType:setFile("")
		else
			imgCard1:setVisible(false)
			imgCard2:setVisible(true)
			imgHoraryType:setVisible(true)
			imgHoraryType:setFile(string.format("ui/activityWords/text_hjqm_%d.png",data.cards[i]))
		end
	end
	--结束占卜的时候
	local imgBtnEndHorary = GetElement(self.m_root,"imgBtnEndHorary",WZUIImage)
	if not self:getCount() then
		imgBtnEndHorary:setGrayRender(true)
	else
		imgBtnEndHorary:setGrayRender(false)
	end
end
--根据倍数得出卦象名字
function WndMainHorary:getMultipleHorary(multiple)
	local horary_str = ""
	local data = LocalStrings.ACTIVITY_TEXT92
	local index = nil
	for i=1,#data do
		if tonumber(data[i][2]) == multiple then
			index = i
			break
		end
	end
	if index then
		local str = LocalStrings.ACTIVITY_TEXT86[index]
		if str then
			local _str = SplitStringWithSeparator(str,",")
			for i=1,#_str do
				horary_str = horary_str .. _str[i]
			end
		end
	end
	return horary_str
end
--判断已经占卜的数量
function WndMainHorary:getCount()
	local status = nil
	local index = 0
	for i=1,3 do
		if self.m_tGetCardData[i] ~= 0 then
			index = index + 1
		end
	end
	if index >= 3 then
		status = true
	end
	return status
end
function WndMainHorary:onBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.ACTIVITY_TEXT75)
end
--翻牌动画
function WndMainHorary:onTurnOverCard(index, msg)
	if not index or not self.m_root then 
		self.m_bIsOpenCard = nil
		return 
	end
	local horaryCardCon = GetElement(self.m_root,"horaryCard"..index,WZUIContainer)
	--[[
	一个参数是动作时间，第二、三参数分别是其实半径值和过程半径值，
	第四、五个参数分别是起始与Z轴夹角和运行过程与Z轴夹角，
	第六、七个参数分别表示起始与X轴夹角和运行过程与X轴夹角
	]]
    local conFront = GetElement(horaryCardCon,"imgCard1",WZUIImage)
    local conBack = GetElement(horaryCardCon,"imgCard2",WZUIImage)
    conFront:setVisible(true)
	conBack:setVisible(false)
	GetElement(self.m_root,"imgHoraryType"..index,WZUIImage):setVisible(false)
    local orbitFront_1 = CCOrbitCamera:create(0.2,0.5,0,0,90,0,0)
    local orbitFront_2 = CCOrbitCamera:create(0.2,0.5,0,90,90,0,0)
    local array = CCArray:create()
    array:addObject(orbitFront_1)
	array:addObject(CCCallFuncN:create(function()
		conFront:setVisible(false)
		conBack:setVisible(true)
	end))
	array:addObject(orbitFront_2)
	array:addObject(CCCallFuncN:create(function()
		self:setHoraryData(msg)
		self.m_bIsOpenCard = nil
	end))
    local actionArray =  CCSequence:create(array)
    horaryCardCon:runAction(actionArray)
end

function WndMainHorary:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
--任务红点
function WndMainHorary:setTaskRedPoint()
	if not self.m_root then return end
	local imgTaskRedPoint = GetElement(self.m_root,"imgTaskRedPoint",WZUIImage)
	local status = GlobalGame.g_tRedPointTypeList[117023] or GlobalGame.g_tRedPointTypeList[127023]
	imgTaskRedPoint:setVisible(status)
end
--等级红点
function WndMainHorary:setLevelRedPoint()
	if not self.m_root then return end
	local imgLevRedPoint = GetElement(self.m_root,"imgLevRedPoint",WZUIImage)
	local status = GlobalGame.g_tRedPointTypeList[17023]
	imgLevRedPoint:setVisible(status)
end

--@brief 	红点
function WndMainHorary:showRedDot()
	-- body
	if self.m_root == nil then return end 

	self:setTaskRedPoint()
    self:setLevelRedPoint()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndMainHorary:_onGetHoraryInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if activityId == tonumber(g_cityExtenInfo.activity7023) then
		content = json.decode(content)
		if content then
			self.n_BigReward = content.bigRewards
			self.n_tGxReward = content.gxRewards
			self:setTodayReward(self.n_tGxReward)
			self.m_nVersion = content.version
		end
		local txtActivityTime = GetElement(self.m_root,"txtActivityTime",WZUILabelTTF)
		local _start = SystemTime:getTimeConverLocal(startTime)
		local _end = SystemTime:getTimeConverLocal3(endTime)
		txtActivityTime:setText(_start.."-".._end)
	end
end
function WndMainHorary:_onGetHoraryResult(activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7023) then
		msg = json.decode(msg)
		if msg then
			if doType == 1 then
				local index = nil
				for i=1,3 do
					if self.m_tGetCardData[i] == 0 then
						index = i
						break
					end
				end
				local is_end = nil
				for i,v in pairs(msg.cards) do
					if v ~= 0 then
						is_end = true
					end
				end
				if not self.m_bIsFirstComeIn or not is_end then --开始进入界面或结束占卜的时候
					self:setHoraryData(msg)
				else
					if msg.cardSelect == -1 then --没有重新占卜的时候
						self:onTurnOverCard(index, msg)
					else
						self:onTurnOverCard(msg.cardSelect + 1, msg)
					end
				end
			elseif doType == 3 then --占卜/重新占卜
				if result == 1 then
					WndRewardShow:showById(msg.itemIds, msg.itemNums)
					MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT101..LocalStrings.ACTIVITY_TEXT83[msg.card],nil,nil,nil,nil,nil,nil,nil,nil,{x=0.5,y=0.8})

					if next(msg.sItemIds) ~= nil then
						local data = {id = msg.sItemIds[1], num = msg.sItemNums[1]}
						local function closeFun()
							WndHoraryBigReward:showInterface(1, data)
						end
						WndRewardShow:closeCallBack(self,closeFun)
					end
				elseif result == 2 then
					MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT88)
					self.m_bIsOpenCard = nil
				elseif result == 3 then
					MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT31)
					self.m_bIsOpenCard = nil
				end
			elseif doType == 5 then --结束占卜
				if result == 1 then
					if self.m_nCurMultiple > 1 and self.m_tChooseItemCell then
				    	self.m_tChooseItemCell:setItemSelState(false)
				    end
					local data = {id = msg.itemIds[1], num = msg.itemNums[1], gxId = msg.gxId}
					WndHoraryBigReward:showInterface(2, data)
				elseif result == 2 then
					MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT93)
				end
				self.m_bIsOpenCard = nil
				self.m_nRewardIndex = -1
			end
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------
