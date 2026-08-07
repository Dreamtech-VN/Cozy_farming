--WndHappyShake.lua
--@brief	WndHappyShake的UI模块
--@date		2020/05/27
--@author	XTX
--@note		全民摇摇乐活动界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHappyShake:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	self.t_nConListPosY = {306,440,573,708,842,976,1110,1244}
	ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerTaskList()
	if WZFileUtil:isFileExist("pack/pukepai/pack_pukepai_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/pukepai/pack_pukepai_0.plist")
    end


    local checkSkip = GetElement(self.m_root,"checkSkip_WndHappyShake",WZUICheckBox)
	local data = WZDataFile:getInstance():getUserData()
    if data then
        local nCheckIndex = data:getStringValue("HappyShake", "checkSkip") == "1" and 1 or 0
        self.m_nCheckIndex = nCheckIndex
        checkSkip:setCheckIndex(nCheckIndex)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHappyShake:onExit(element)
	self:_unInit()
	if WZFileUtil:isFileExist("pack/pukepai/pack_pukepai_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/pukepai/pack_pukepai_0.plist")
    end
end

--@brief 	切换倍数标签回调
function WndHappyShake:onCkeckTimes(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nStatus == 1 then 
		GetElement(self.m_root, "checkgroupMul_WndHappyShake", WZUICheckBoxGroup):setCheckIndex(self.m_nTabTimesIndex - 1)
		MsgBoxManager:showTipBox(LocalStrings.FOURYEAR_TEXT18)
		return 
	end
	local nTag = element:getTag()
	WZLog("WndHappyShake:onCkeckTimes", nTag)
	if nTag == self.m_nTabTimesIndex then return end 

	self.m_nSelRewardIndex = nil  
    self.m_tSelRewardCell = nil 
	self.m_nTabTimesIndex = nTag 
	--更新为相应的倍数奖励
	self:_showRewardList()
end

--@brief 	点击物品回调
function WndHappyShake:clickItemBack(luaTable, tag, tData)
	-- body
	if tData == nil then
       return
    end

    if self.m_nStatus == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.FOURYEAR_TEXT18)
		return 
	end

    WZLog("WndHappyShake:clickItemBack", tag)
    if self.m_nSelRewardIndex == nil then 
    	self.m_nSelRewardIndex = tag 
    	self.m_tSelRewardCell = luaTable
    	self.m_tSelRewardCell:setItemSelState(true)
    elseif self.m_nSelRewardIndex == tag then 
    	self.m_nSelRewardIndex = nil 
    	if self.m_tSelRewardCell then 
    		self.m_tSelRewardCell:setItemSelState(false)
    	end
    else
    	self.m_tSelRewardCell:setItemSelState(false)
    	
    	self.m_nSelRewardIndex = tag 
    	self.m_tSelRewardCell = luaTable
    	self.m_tSelRewardCell:setItemSelState(true)
    end
end

--@brief 	显示
function WndHappyShake:showWindow()
	-- body
	ProtocolProcessorNewActivity:send_ACTIVITY2_GetPokerInfo()
--	WndHappyShake:setTreasureInfo({"2-1","5-4","7-3","10-1","4-2"}, {0,2,0), 0, 2, 0)
end

--@brief 	点击确定按钮回调
function WndHappyShake:onClickSure(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nSelRewardIndex == nil then 
		MsgBoxManager:showTipBox(LocalStrings.FOURYEAR_TEXT12)
		return 
	end

	local tData = self.m_tRewardData[self.m_nTabTimesIndex]
	if self.m_nStatus ~= 1 then 
		if not JudgeMoneyIsEnough(tData.cost[1], tData.cost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiaInstead) then 
			return 
		end
	end

	self:sureToUseDiaInstead()
end

--@brief 	确定使用蓝钻代替进行摇一摇
function WndHappyShake:sureToUseDiaInstead()
	-- body
	--发送请求
	if self.m_nStatus == 1 then 
		--背包已满提示
	    if CacheCenter:getRemainAmount() <= 0 then
	        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
	        return
	    end
		ProtocolProcessorNewActivity:send_ACTIVITY2_PokerReward()
	else
		ProtocolProcessorNewActivity:send_ACTIVITY2_PokerLottery(self.m_tRewardData[self.m_nTabTimesIndex].times, self.m_nSelRewardIndex)
	end
end

--单次刷新
function WndHappyShake:onClickRefresh(element)
	-- body
	WZLog("WndHappyShake:onClickRefresh")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nStatus == 1 then
		local tag = element:getTag()
	
		local cost = self.m_tTarget[self.m_nRaffleReset + 1]
		local totocalCount = #self.m_tTarget
		if cost then 
			self.m_nTag = tag
			if JudgeMoneyIsEnough(cost[1], cost[2], nil, nil, nil, nil, nil, nil, nil, self, self.sendPRAYResetRaffle)  then
				local tipss = string.format(LocalStrings.FOURYEAR_TEXT20, cost[2], GDatatab_item["id_" .. cost[1]].icon,self.m_nRaffleReset, totocalCount)
				MsgBoxManager:showConfirmCancelBox(tipss, self, self.onRefresh, nil, {[MSGBOXUICFG_USEFREETXT] = true}, "refreshHappyShake")
			end
		else
			MsgBoxManager:showTipBox(LocalStrings.FOURYEAR_TEXT14)
		end
	end
end

function WndHappyShake:onRefresh(nId,nResType)
	-- body
	WZLog("WndHappyShake:onRefresh ",self.m_nTag)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		ProtocolProcessorNewActivity:send_ACTIVITY2_PokerReset(self.m_nTag-1)
	end
end

function WndHappyShake:sendPRAYResetRaffle()
	-- body
	WZLog("WndHappyShake:sendPRAYResetRaffle")
	ProtocolProcessorNewActivity:send_ACTIVITY2_PokerReset(self.m_nTag-1)
end

--@brief 	点击任务按钮回调
function WndHappyShake:onClickTask(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	WndHappyShakeTask:showInterface()
end

--@brief    点击规则按钮回调
function WndHappyShake:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.FOURYEAR_TEXT10) 
end

--@brief    勾选跳过动画按钮回调
function WndHappyShake:onClickSkip(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local checkSkip = GetElement(self.m_root,"checkSkip_WndHappyShake",WZUICheckBox)
    self.m_nCheckIndex = checkSkip:getCheckIndex()
    local data = WZDataFile:getInstance():getUserData()
    if data then
        data:setStringValue("HappyShake", "checkSkip", tostring(self.m_nCheckIndex))
        data:flush()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndHappyShake:_update()
	-- body
	self:_initUIText()
	self:_showRewardList()
	self:_showPolerTypeAndTimes()

	GetElement(self.m_root, "checkgroupMul_WndHappyShake", WZUICheckBoxGroup):setCheckIndex(self.m_nTabTimesIndex - 1)
end
--@brief 	初始化UI文本
function WndHappyShake:_initUIText()
	-- body
	local txtTimeWords = GetElement(self.m_root, "txtTimeWords_WndHappyShake", WZUILabelTTF)
	if txtTimeWords then 
		txtTimeWords:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":")
	end
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_WndHappyShake", WZUILabelTTF)
    if txtTimeValue then 
    	txtTimeValue:setText(needDay_str)
    end

    --倍数
    for i = 1, 3 do
    	local txtCheckNor = GetElement(self.m_root, "txtCheckNor" .. i .. "_WndHappyShake", WZUILabelTTF)
    	local txtCheckSel = GetElement(self.m_root, "txtCheckSel" .. i .. "_WndHappyShake", WZUILabelTTF)

    	txtCheckNor:setText(string.format(LocalStrings.FOURYEAR_TEXT11, self.m_tRewardData[i].times))
    	txtCheckSel:setText(string.format(LocalStrings.FOURYEAR_TEXT11, self.m_tRewardData[i].times))
    end
end

--@brief 	显示奖励
function WndHappyShake:_showRewardList()
	-- body
	local tableRewardList = GetElement(self.m_root, "tableRewardList_WndHappyShake", WZUITableContainer)
	tableRewardList:cleanTable()
	self.m_tRewardCell = {}

	local tData = self.m_tRewardData[self.m_nTabTimesIndex]
	for i = 1, #tData.reward do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			element:setScale(0.9)
			tNewObj:setCellGoodLocalId(tData.reward[i][1], tData.reward[i][2], 31)
			tNewObj:setItemClickFun(self, self.clickItemBack)
			table.insert(self.m_tRewardCell, tNewObj)
			if self.m_nSelRewardIndex and self.m_nSelRewardIndex == i - 1 then 
				tNewObj:setItemSelState(true)
				self.m_tSelRewardCell = tNewObj 
			end
			tableRewardList:setCellElement(element)
		end
	end

	--显示消耗
	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndHappyShake", WZUIFreeTextBox)
	if ftxtCost then 
		local sFormatCost = [[<T C="255,236,193" S="18" P="1" SC="128,54,13" SS="4" SE="1">%s</T><I Z="0.5" P="1">%s</I><T C="255,255,255" S="18" P="1" SC="128,54,13" SS="4" SE="1">%d</T>]]
		local basicInfo = GDatatab_item["id_" .. tData.cost[1]]
		ftxtCost:setShowText(string.format(sFormatCost, LocalStrings.COST, basicInfo.icon, tData.cost[2]))
	end
end

--@brief 	显示牌型和倍数
function WndHappyShake:_showPolerTypeAndTimes()
	-- body
	if self.m_nCount == nil or self.m_nMaxCount == nil then return end 
	--牌型
	local txtPokerType = GetElement(self.m_root, "txtPokerType_WndHappyShake", WZUILabelTTF)
	if txtPokerType then 
		txtPokerType:setText(LocalStrings.FOURYEAR_TEXT13[self.m_nMaxCount])
	end
	--倍数
	local txtActualTimes = GetElement(self.m_root, "txtActualTimes_WndHappyShake", WZUILabelTTF)
	if txtActualTimes then 
		txtActualTimes:setText(string.format(LocalStrings.FOURYEAR_TEXT11, self.m_nCount))
	end
end

--@breif 开始滚动相关数值
function WndHappyShake:_startRoll()
	WZLog("WndHappyShake:_startRoll")
	--快速播放跳过滚动

	if self.m_nCheckIndex == 1 then
		self:_passRoll()
	else
		self.n_speed = 140
		self.t_bActionOver = {0,0,0,0,0}
		self.m_root:enableSchedule("_starRollSchedule",0.001)
	end
end

--@brief 开始滚动
function WndHappyShake:_starRollSchedule()
	--290 900 355
	self.n_speed = math.max(self.n_speed - 3,12) --减速到某个值将不再减少
	for i = 1,5 do
		local element = GetElement(self.m_root,"conList"..i.."_WndHappyShake")
		local posY = element:getPositionY()
		local endPosY = self.t_nConListPosY[self.m_tLuckDrawData[i]]
		if self.n_speed <=12 and posY+self.n_speed >= endPosY and posY <= endPosY  then
			element:setPositionY(endPosY)
			self.t_bActionOver[i] = 1
		else
			self:_setRollPosition(element, self.n_speed)
		end	
	end
	if self.t_bActionOver[1] == 1 and self.t_bActionOver[2] == 1 and self.t_bActionOver[3] == 1 and self.t_bActionOver[4] == 1 and self.t_bActionOver[5] == 1 then
		self.m_root:disableSchedule()
		--开始初始化移动特效
		self:_initMove()
	end
end

--@brief 设置容器的位置
function WndHappyShake:_setRollPosition(element,moveY)
	local posY = element:getPositionY()
	posY = posY + moveY
	if posY > 1250 then
		posY = 257
	end
	element:setPositionY(posY)
end

--@breif 初始化特效动相关数值
function WndHappyShake:_initMove()
	WZLog("WndHappyShake:_initMove")
	self.m_tRaffleMark = self.m_tLuckDrawData
	self.m_nStatus = 1
	self:updateUI(false)
end

function WndHappyShake:updateUI(bResetPS)
	-- body
	WZLog("WndHappyShake:updateUI")
	GetElement(self.m_root,"conAll_WndHappyShake",WZUIContainer):setTouchEnable(true)
	
	local btnSure = GetElement(self.m_root,"btnSure_WndHappyShake",WZUIButton)
	btnSure:setTouchEnable(false)

    btnSure:setTouchEnable(true)
    local ftxtCost = GetElement(self.m_root, "ftxtCost_WndHappyShake", WZUIFreeTextBox)
    if self.m_nStatus == 1 then
    	GetElement(self.m_root, "txtBtnSureNor_WndHappyShake", WZUILabelTTF):setTextKey("GET_REWARD")
    	GetElement(self.m_root, "txtBtnSureSel_WndHappyShake", WZUILabelTTF):setTextKey("GET_REWARD")
    	GetElement(self.m_root, "txtBtnSureGray_WndHappyShake", WZUILabelTTF):setTextKey("GET_REWARD")
    	ftxtCost:setVisible(false)
    else
    	GetElement(self.m_root, "txtBtnSureNor_WndHappyShake", WZUILabelTTF):setTextKey("CONFIRM")
    	GetElement(self.m_root, "txtBtnSureSel_WndHappyShake", WZUILabelTTF):setTextKey("CONFIRM")
    	GetElement(self.m_root, "txtBtnSureGray_WndHappyShake", WZUILabelTTF):setTextKey("CONFIRM")
    	ftxtCost:setVisible(true)
    end

	WZLog("resetRef =", self.m_nRaffleReset)
	local cost = self.m_tTarget[self.m_nRaffleReset + 1]
	local totocalCount = #self.m_tTarget

	for i=1,5 do
		local conRefresh = GetElement(self.m_root,"conRefresh" .. i .. "_WndHappyShake",WZUIContainer)
		if self.m_nStatus == 0 then
			conRefresh:setVisible(false)
		else
		--	if self.m_tRaffleMark[i] ~= 6 then
				conRefresh:setVisible(true)
				local imgLizhuan = GetElement(conRefresh,"imgLizhuan_WndHappyShake",WZUIImage)
				local txtStatus = GetElement(conRefresh,"txtStatus_WndHappyShake",WZUILabelTTF)
				local txtCostCount = GetElement(conRefresh,"txtCostCount_WndHappyShake",WZUILabelTTF)
				txtCostCount:setText("")
				if self.m_nRaffleReset < totocalCount and cost ~= nil then
					imgLizhuan:setVisible(true)
					txtStatus:setVisible(false)
					imgLizhuan:setFile(GDatatab_item["id_" .. cost[1]].icon)
					txtCostCount:setText(cost[2])
				else
					conRefresh:setVisible(false)
				end
			-- else
			-- 	conRefresh:setVisible(false)
			-- end
		end
	end

	local conList = nil

	if bResetPS == nil then
		for i,v in ipairs(self.m_tRaffleMark) do
			conList = GetElement(self.m_root,"conList" .. i .."_WndHappyShake",WZUIContainer)
			conList:setPositionY(self.t_nConListPosY[v])
		end
	end

	--刷新倍数和牌型
	self:_showPolerTypeAndTimes()
end

--@breif 跳过动画直接滚动
function WndHappyShake:_passRoll()
	for i,v in ipairs(self.m_tLuckDrawData) do
		conList = GetElement(self.m_root,"conList" .. i .."_WndHappyShake",WZUIContainer)
		conList:setPositionY(self.t_nConListPosY[v])
	end
	self:_initMove()
end

function WndHappyShake:_startSingleRoll()
	-- body
	WZLog("WndHappyShake:_startSingleRoll")
	if self.m_nCheckIndex == 1 then
		self:_passRoll()
	else
		self.n_speed = 140
		self.t_bActionOver = {0}
		self.m_root:enableSchedule("_starSingleRollSchedule",0.001)
	end
end

--@brief 开始滚动
function WndHappyShake:_starSingleRollSchedule()
	--290 900 355
	self.n_speed = math.max(self.n_speed - 3, 12) --减速到某个值将不再减少
	local element = GetElement(self.m_root,"conList".. self.m_nTag .."_WndHappyShake")
	local posY = element:getPositionY()
	local endPosY = self.t_nConListPosY[self.m_nSingleRaffleMark]
	if self.n_speed <=12 and posY+self.n_speed >= endPosY and posY <= endPosY  then
		element:setPositionY(endPosY)
		self.t_bActionOver[1] = 1
	else
		self:_setRollPosition(element, self.n_speed)
	end	

	if self.t_bActionOver[1] == 1 then
		self.m_root:disableSchedule()
		--开始初始化移动特效
		self:_initMove()
	end
end

--@brief 	根据抽到的值设置牌
--@param 	raffleMark:1-13标识1——K
--@patam 	sharp:1-4标识：方块、梅花、红桃、黑桃
--@param 	nTag : 具体刷新某一张牌
function WndHappyShake:_setPositionPoker(raffleMark, sharp, nTag)
	-- body
	if nTag then 
		local nIndex = math.fmod(raffleMark, 8) + 1
		local conList = GetElement(self.m_root, "conList" .. nTag .. "_WndHappyShake", WZUIContainer)
		local imgPoker = GetElement(conList, "imgPoker" .. nIndex .. "_WndHappyShake", WZUIImage)
		if imgPoker then 
			imgPoker:setFile("ui/gameActivity/pukepai/pkp_" .. raffleMark .."_"  .. sharp .. ".png")
		end
	else
		for i = 1, #raffleMark do
			local nIndex = math.fmod(raffleMark[i], 8) + 1
			local conList = GetElement(self.m_root, "conList" .. i .. "_WndHappyShake", WZUIContainer)
			local imgPoker = GetElement(conList, "imgPoker" .. nIndex .. "_WndHappyShake", WZUIImage)
			if imgPoker then 
				imgPoker:setFile("ui/gameActivity/pukepai/pkp_" .. raffleMark[i] .."_" .. sharp[i] .. ".png")
			end
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------



-------------------------------------私有方法模块End----------------------------------------

function WndHappyShake:_adaptLanguage_vn()
	local txtTimeWords = GetElement(self.m_root,"txtTimeWords_WndHappyShake",WZUILabelTTF)
	txtTimeWords:setRelativePosition(GlobalMethod:ccp(0.13,0.984))

	local txtDesc = GetElement(self.m_root,"txtDesc_WndHappyShake",WZUILabelTTF)
	txtDesc:setScale(0.8)

	GetElement(self.m_root, "txtBtnSureNor_WndHappyShake", WZUILabelTTF):setScale(0.9)
	GetElement(self.m_root, "txtBtnSureSel_WndHappyShake", WZUILabelTTF):setScale(0.9)
	GetElement(self.m_root, "txtBtnSureGray_WndHappyShake", WZUILabelTTF):setScale(0.9)
end

-------------------------------------私有方法模块End----------------------------------------
