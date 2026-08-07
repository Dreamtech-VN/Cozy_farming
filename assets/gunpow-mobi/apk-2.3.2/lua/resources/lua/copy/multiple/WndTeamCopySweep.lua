--WndTeamCopySweep.lua
--@brief	WndTeamCopySweep的UI模块
--@date		2017/02/17
--@author	qixiang
--@note		组队副本扫荡


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTeamCopySweep:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	ProtocolProcessorSingleMap:regAll()
	self:showLoadingB()
	ProtocolProcessorSingleMap:send_MAP_GetTodayRaidsTeamTimes()
	local txtTeamCopTitle = GetElement(self.m_root,"txtTeamCopTitle_WndTeamCopySweep",WZUILabelTTF)
	local temp = LocalStrings.MULTI_SCRIPT .. LocalStrings.WIPE_OUT
	if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
		local temp = LocalStrings.MULTI_SCRIPT .. " " .. LocalStrings.WIPE_OUT
	end
	txtTeamCopTitle:setText(temp)

	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTeamCopySweep:onExit(element)
	self:_unInit()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
end


function WndTeamCopySweep:initUI()
	-- body
	WZLog("WndTeamCopySweep:initUI")
	local teamInfo = GDatatab_team_map["id_" .. self.m_nCopyId]
	if self.m_nDifficulty == 0 then
		local imgSelect = GetElement(self.m_root,"imgSelect1_WndTeamCopySweep",WZUIImage)
	    imgSelect:setVisible(true)
	    self.m_elementSel = imgSelect
	else
		local imgSelect = GetElement(self.m_root,"imgSelect" .. self.m_nDifficulty .. "_WndTeamCopySweep",WZUIImage)
	    imgSelect:setVisible(true)
	    self.m_elementSel = imgSelect
	end

	local txtCopyName = GetElement(self.m_root,"txtCopyName_WndTeamCopySweep",WZUILabelTTF)
	txtCopyName:setText(teamInfo.map_name)

	self.m_nDiff = self.m_nDifficulty
	if self.m_nDifficulty < 3 then
		local imgPass3 = GetElement(self.m_root,"imgPass3_WndTeamCopySweep",WZUIImage)
		imgPass3:setGrayRender(true)
	end

	if self.m_nDifficulty < 2 then
		local imgPass2 = GetElement(self.m_root,"imgPass2_WndTeamCopySweep",WZUIImage)
		imgPass2:setGrayRender(true)
	end

	if self.m_nDifficulty < 1 then
		local imgPass1 = GetElement(self.m_root,"imgPass1_WndTeamCopySweep",WZUIImage)
		imgPass1:setGrayRender(true)
	end

	local txtPlayerFight = GetElement(self.m_root,"txtPlayerFight_WndTeamCopySweep",WZUILabelTTF)
	txtPlayerFight:setText(teamInfo.sweep_fight)
    local txtSweepC = GetElement(self.m_root,"txtSweepC_WndTeamCopySweep",WZUILabelTTF)
	local param = CacheCenter:getGameParam()
	local teamRaidsTimesLimit  = param.teamRaidsTimesLimit --组队副本每天扫荡次数限制
	local timess =  teamRaidsTimesLimit - self.m_nRaidsTimes  --扫荡剩余次数
	local temp = timess .. "/" .. teamRaidsTimesLimit
	txtSweepC:setText(temp)

	self:showSweepCost()
	self:setChallengeTime()
end

function WndTeamCopySweep:updatePlayerItemData()
	-- body
	WZLog("WndTeamCopySweep:updatePlayerItemData")
	WndTeamCopySweep:showSweepCost()
end

-- 显示扫荡消耗
function WndTeamCopySweep:showSweepCost()
	-- body
	WZLog("WndTeamCopySweep:showSweepCost")
	local txtSweepCount = GetElement(self.m_root,"txtSweepCount_WndTeamCopySweep",WZUILabelTTF)
	local param = CacheCenter:getGameParam()
	local teamRaidsCostRollNum = param.teamRaidsCostRollNum --组队副本扫荡券消耗数量，不同难度的副本消耗不同数量(字符串[2,3]&[3,4]&[4,5...])
	local ids,nums = SplitItemString(teamRaidsCostRollNum)
	local imgItem = GetElement(self.m_root,"imgItem_WndTeamCopySweep",WZUIImage)
	local id = nil
	local num = nil
	WZLog("WndTeamCopySweep:showSweepCost",teamRaidsCostRollNum,self.m_nDiff,Serialize(ids))
	if self.m_nDiff == 0 or self.m_nDiff == 1 then
		id = ids[1]
		num = nums[1]
	elseif self.m_nDiff == 2 then
		id = ids[2]
		num = nums[2]
	elseif self.m_nDiff == 3 then
		id = ids[3]
		num = nums[3]
	end
	self.m_nSweepCostItemId = id
	self.m_nSweepCostNum = tonumber(num)
	local itemInfo = GDatatab_item["id_" ..id]
	imgItem:setFile(itemInfo.icon)
	itemCount = CacheCenter:getPlayerItemCountById(self.m_nSweepCostItemId)
	local temp = itemCount .. "/" .. num
	txtSweepCount:setText(temp)
end

function WndTeamCopySweep:onclickClose(element)
	-- body
	WZLog("WndTeamCopySweep:onclickClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end



--扫荡
function WndTeamCopySweep:onClickSweep(element)
	-- body
	WZLog("WndTeamCopySweep:onClickSweep =",self.m_nClickTag)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	local nTimes = 1
	if nTag == 2 then
		nTimes = self.m_nMaxTime - self.m_nPassTime
	end
	WZLog("WndTeamCopySweep:onClickSweep =hhh", nTimes)
	if self.m_nDiff > self.m_nDifficulty then
		MsgBoxManager:showTipBox(LocalStrings.HURDLES_NOT_OPEN)
		return
	end

	local copyId = nil
	if self.m_nDiff == 1 then
		copyId = self.m_nCopyId1
	elseif  self.m_nDiff == 2 then
		copyId = self.m_nCopyId2
	elseif self.m_nDiff == 3 then
		copyId = self.m_nCopyId3
	end
	
	local playerInfo = CacheCenter:getPlayerInfo()
	local mapInfo = GDatatab_team_map["id_" .. copyId]

	if playerInfo.level < mapInfo.sweep_level then
    	local tip = string.format(LocalStrings.SWEEP_COPY_LEVEL_OPEN_TIP,mapInfo.sweep_level)
    	MsgBoxManager:showTipBox(tip)
    	return
    end

    local txtPlayerFight =  GetElement(self.m_root,"txtPlayerFight_WndTeamCopySweep",WZUILabelTTF)
    local fight = tonumber(txtPlayerFight:getText())
    
    if  fight <= 0  then return end
    if playerInfo.fighting < fight then
    	local tip = string.format(LocalStrings.CARD_COUNT1,LocalStrings.BATTLE)
    	MsgBoxManager:showTipBox(tip)
    	return
    end

    if  CacheCenter:getPlayerInfo().vigor < nTimes * 15 then
        judgeNotEnoughJump(self, self.buyVigors)
        return
    end

    itemCount = CacheCenter:getPlayerItemCountById(self.m_nSweepCostItemId)
    if itemCount < nTimes * self.m_nSweepCostNum then

    	checkIsOnSale(tonumber(self.m_nSweepCostItemId))
    	return
    end

    local param = CacheCenter:getGameParam()
	local teamRaidsTimesLimit  = param.teamRaidsTimesLimit --组队副本每天扫荡次数限制
	local timess =  teamRaidsTimesLimit - self.m_nRaidsTimes  --扫荡剩余次数
	if timess - nTimes < 0 then
		MsgBoxManager:showTipBox(LocalStrings.SURPLUS_SWEEP_COUNT_LESS)
		return
	end
	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}

	self:showLoadingB()
	ProtocolProcessorSingleMap:send_MAP_StartRaidsTeam(copyId, nTimes)
	self.m_bSweeping = true

end

function WndTeamCopySweep:buyVigors(nId,nType)
    if nType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(1056)
    end
end

--@brief  是否购买扫荡卷回调
function WndTeamCopySweep:needMoreSweep(id,nResType)
    WZLog("WndTeamCopySweep:needMoreSweep")
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndPurchase:showBuyInterface(6,201)
    end
end

--选择难度
function WndTeamCopySweep:onClickDifficulty(element)
	-- body
	WZLog("WndTeamCopySweep:onClickDifficulty")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag =	element:getTag()
    if tag == self.m_nDiff then return end
    self.m_nDiff = tag
    local imgSelect = GetElement(self.m_root,"imgSelect" .. tag .. "_WndTeamCopySweep",WZUIImage)
    imgSelect:setVisible(true)
    if self.m_elementSel then
    	self.m_elementSel:setVisible(false)
    end
    self.m_elementSel = imgSelect
    local txtPlayerFight =  GetElement(self.m_root,"txtPlayerFight_WndTeamCopySweep",WZUILabelTTF)
    local teamMapInfo = nil
    if self.m_nDiff == 1 then
    	teamMapInfo = GDatatab_team_map["id_" .. self.m_nCopyId1]
    elseif self.m_nDiff == 2 then
    	teamMapInfo = GDatatab_team_map["id_" .. self.m_nCopyId2]
    elseif self.m_nDiff == 3 then
    	teamMapInfo = GDatatab_team_map["id_" .. self.m_nCopyId3]
    end
    txtPlayerFight:setText(teamMapInfo.sweep_fight)
    self:showSweepCost()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置次数
function WndTeamCopySweep:setChallengeTime()
	-- body
	local txtLeftTimes = GetElement(self.m_root, "txtLeftTimes_WndTeamCopySweep", WZUILabelTTF)
	local btnSweepAll = GetElement(self.m_root, "btnSweepAll_WndTeamCopySweep", WZUIButton)
	local nTimes = self.m_nMaxTime - self.m_nPassTime

	if txtLeftTimes then
		txtLeftTimes:setText(nTimes .. "/" .. self.m_nMaxTime)
	end
	if btnSweepAll then
		if nTimes > 1 then
			btnSweepAll:setVisible(true)
		else
			btnSweepAll:setVisible(false)
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function WndTeamCopySweep:_adaptLanguage_en(  )
	local txtCopyNameT = GetElement(self.m_root,"txtCopyNameT_WndTeamCopySweep",WZUILabelTTF)
	txtCopyNameT:setScale(0.8)
	txtCopyNameT:setRelativePosition(GlobalMethod:ccp(0.0447616,0.913303))
	local txtCopyName = GetElement(self.m_root,"txtCopyName_WndTeamCopySweep",WZUILabelTTF)
	txtCopyName:setScale(0.8)
	txtCopyName:setRelativePosition(GlobalMethod:ccp(0.302272,0.913303))
	local txtSweep = GetElement(self.m_root,"txtSweep_WndTeamCopySweep",WZUILabelTTF)
	txtSweep:setScale(0.8)
	txtSweep:setRelativePosition(GlobalMethod:ccp(0.632881,0.913))
	local txtSweepC = GetElement(self.m_root,"txtSweepC_WndTeamCopySweep",WZUILabelTTF)
	txtSweepC:setScale(0.8)
	txtSweepC:setRelativePosition(GlobalMethod:ccp(0.885,0.9133))
	GetElement(self.m_root,"txtDifficulty_WndTeamCopySweep",WZUILabelTTF):setScale(0.8)

	local txtPower = GetElement(self.m_root,"txtPower_WndTeamCopySweep",WZUILabelTTF)
	txtPower:setRelativePosition(GlobalMethod:ccp(0.486667,0.113379))

	local txtSweepAll = GetElement(self.m_root,"txtSweepAll_WndTeamCopySweep",WZUILabelTTF)
	txtSweepAll:setScale(0.7)
	
	GetElement(self.m_root,"imgItem_WndTeamCopySweep",WZUIImage):setScale(0.4)
end

function WndTeamCopySweep:_adaptLanguage_th(  )

	local txtCost = GetElement(self.m_root,"txtCost_WndTeamCopySweep",WZUILabelTTF)
	txtCost:setScale(0.7)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.27,0.113379))
	GetElement(self.m_root,"txtPower_WndTeamCopySweep",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtPlayerFight_WndTeamCopySweep",WZUILabelTTF):setScale(0.7)

	local txtCopyNameT = GetElement(self.m_root,"txtCopyNameT_WndTeamCopySweep",WZUILabelTTF)
	txtCopyNameT:setScale(0.7)
	txtCopyNameT:setRelativePosition(GlobalMethod:ccp(0.0447616,0.913303))
	local txtCopyName = GetElement(self.m_root,"txtCopyName_WndTeamCopySweep",WZUILabelTTF)
	txtCopyName:setScale(0.7)
	txtCopyName:setRelativePosition(GlobalMethod:ccp(0.223774,0.913303))
	local txtSweep = GetElement(self.m_root,"txtSweep_WndTeamCopySweep",WZUILabelTTF)
	txtSweep:setScale(0.7)
	txtSweep:setRelativePosition(GlobalMethod:ccp(0.468272,0.913))
	local txtSweepC = GetElement(self.m_root,"txtSweepC_WndTeamCopySweep",WZUILabelTTF)
	txtSweepC:setScale(0.7)
	txtSweepC:setRelativePosition(GlobalMethod:ccp(0.885,0.9133))
	GetElement(self.m_root,"txtDifficulty_WndTeamCopySweep",WZUILabelTTF):setScale(0.7)

	local txtSweepAll = GetElement(self.m_root,"txtSweepAll_WndTeamCopySweep",WZUILabelTTF)
	txtSweepAll:setScale(0.85)
end

function WndTeamCopySweep:_adaptLanguage_vn(  )
	local txtCopyName = GetElement(self.m_root,"txtCopyName_WndTeamCopySweep",WZUILabelTTF)
	txtCopyName:setRelativePosition(GlobalMethod:ccp(0.33,0.913303))
	local txtCost = GetElement(self.m_root,"txtCost_WndTeamCopySweep",WZUILabelTTF)
	txtCost:setScale(0.7)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.27,0.113379))
	local txtPower = GetElement(self.m_root,"txtPower_WndTeamCopySweep",WZUILabelTTF)
	txtPower:setScale(0.7)
	txtPower:setRelativePosition(GlobalMethod:ccp(0.508261,0.113379))
	local txtPlayerFight = GetElement(self.m_root,"txtPlayerFight_WndTeamCopySweep",WZUILabelTTF)
	txtPlayerFight:setScale(0.7)
	txtPlayerFight:setRelativePosition(GlobalMethod:ccp(0.579372,0.113379))

	local txtSweep = GetElement(self.m_root,"txtSweep_WndTeamCopySweep",WZUILabelTTF)
	txtSweep:setRelativePosition(GlobalMethod:ccp(0.66,0.913))

	local txtSweepAll = GetElement(self.m_root,"txtSweepAll_WndTeamCopySweep",WZUILabelTTF)
	txtSweepAll:setScale(0.7)
end

function WndTeamCopySweep:_adaptLanguage_es(  )
	local txtCopyName = GetElement(self.m_root,"txtCopyName_WndTeamCopySweep",WZUILabelTTF)
	txtCopyName:setRelativePosition(GlobalMethod:ccp(0.415132,0.913303))

	local txtCost = GetElement(self.m_root,"txtCost_WndTeamCopySweep",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.148223,0.113379))
	local txtPower = GetElement(self.m_root,"txtPower_WndTeamCopySweep",WZUILabelTTF)
	txtPower:setRelativePosition(GlobalMethod:ccp(0.659372,0.113379))
	local txtPlayerFight = GetElement(self.m_root,"txtPlayerFight_WndTeamCopySweep",WZUILabelTTF)
	txtPlayerFight:setRelativePosition(GlobalMethod:ccp(0.726039,0.113379))

	local txtSweepC = GetElement(self.m_root,"txtSweepC_WndTeamCopySweep",WZUILabelTTF)
	txtSweepC:setRelativePosition(GlobalMethod:ccp(0.53,0.24107))

	local txtCostDes = GetElement(self.m_root,"txtCostDes_WndTeamCopySweep",WZUILabelTTF)
	txtCostDes:setRelativePosition(GlobalMethod:ccp(0.1,0.602516))

	local imgItem = GetElement(self.m_root,"imgItem_WndTeamCopySweep",WZUIImage)
	imgItem:setRelativePosition(GlobalMethod:ccp(0.22,0.63165))

	local txtSweepCount = GetElement(self.m_root,"txtSweepCount_WndTeamCopySweep",WZUILabelTTF)
	txtSweepCount:setRelativePosition(GlobalMethod:ccp(0.25,0.605034))

	-- local imgArrow1 = GetElement(self.m_root,"imgArrow1_WndTeamCopySweep",WZUIImage)
	-- imgArrow1:setRelativePosition(GlobalMethod:ccp(0.06,0.110465))
	-- local imgArrow2 = GetElement(self.m_root,"imgArrow2_WndTeamCopySweep",WZUIImage)
	-- imgArrow2:setRelativePosition(GlobalMethod:ccp(0.94,0.110465))

	local txtCopyNameT = GetElement(self.m_root,"txtCopyNameT_WndTeamCopySweep",WZUILabelTTF)
	txtCopyNameT:setScale(0.7)
	txtCopyNameT:setRelativePosition(GlobalMethod:ccp(0.0447616,0.913303))
	local txtCopyName = GetElement(self.m_root,"txtCopyName_WndTeamCopySweep",WZUILabelTTF)
	txtCopyName:setScale(0.7)
	txtCopyName:setRelativePosition(GlobalMethod:ccp(0.305309,0.913303))
	local txtSweep = GetElement(self.m_root,"txtSweep_WndTeamCopySweep",WZUILabelTTF)
	txtSweep:setScale(0.7)
	txtSweep:setRelativePosition(GlobalMethod:ccp(0.550947,0.913))
	local txtSweepC = GetElement(self.m_root,"txtSweepC_WndTeamCopySweep",WZUILabelTTF)
	txtSweepC:setScale(0.7)
	txtSweepC:setRelativePosition(GlobalMethod:ccp(0.899403,0.9133))
	GetElement(self.m_root,"imgItem_WndTeamCopySweep",WZUIImage):setScale(0.4)
	
	local txtSweepAll = GetElement(self.m_root,"txtSweepAll_WndTeamCopySweep",WZUILabelTTF)
	txtSweepAll:setScale(0.7)
	txtSweepAll:setDimensions(GlobalMethod:CCSize(140))
end

function WndTeamCopySweep:_adaptLanguage_pt(  )
	local txtCopyName = GetElement(self.m_root,"txtCopyName_WndTeamCopySweep",WZUILabelTTF)
	txtCopyName:setRelativePosition(GlobalMethod:ccp(0.415132,0.913303))

	local txtCost = GetElement(self.m_root,"txtCost_WndTeamCopySweep",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.148223,0.113379))
	local txtPower = GetElement(self.m_root,"txtPower_WndTeamCopySweep",WZUILabelTTF)
	txtPower:setRelativePosition(GlobalMethod:ccp(0.659372,0.113379))
	local txtPlayerFight = GetElement(self.m_root,"txtPlayerFight_WndTeamCopySweep",WZUILabelTTF)
	txtPlayerFight:setRelativePosition(GlobalMethod:ccp(0.726039,0.113379))

	local txtSweepC = GetElement(self.m_root,"txtSweepC_WndTeamCopySweep",WZUILabelTTF)
	txtSweepC:setRelativePosition(GlobalMethod:ccp(0.53,0.24107))

	local txtCostDes = GetElement(self.m_root,"txtCostDes_WndTeamCopySweep",WZUILabelTTF)
	txtCostDes:setRelativePosition(GlobalMethod:ccp(0.1,0.602516))

	local imgItem = GetElement(self.m_root,"imgItem_WndTeamCopySweep",WZUIImage)
	imgItem:setRelativePosition(GlobalMethod:ccp(0.22,0.63165))

	local txtSweepCount = GetElement(self.m_root,"txtSweepCount_WndTeamCopySweep",WZUILabelTTF)
	txtSweepCount:setRelativePosition(GlobalMethod:ccp(0.25,0.605034))

	-- local imgArrow1 = GetElement(self.m_root,"imgArrow1_WndTeamCopySweep",WZUIImage)
	-- imgArrow1:setRelativePosition(GlobalMethod:ccp(0.06,0.110465))
	-- local imgArrow2 = GetElement(self.m_root,"imgArrow2_WndTeamCopySweep",WZUIImage)
	-- imgArrow2:setRelativePosition(GlobalMethod:ccp(0.94,0.110465))

	local txtCopyNameT = GetElement(self.m_root,"txtCopyNameT_WndTeamCopySweep",WZUILabelTTF)
	txtCopyNameT:setScale(0.8)
	txtCopyNameT:setRelativePosition(GlobalMethod:ccp(0.0447616,0.913303))
	local txtCopyName = GetElement(self.m_root,"txtCopyName_WndTeamCopySweep",WZUILabelTTF)
	txtCopyName:setScale(0.8)
	txtCopyName:setRelativePosition(GlobalMethod:ccp(0.342346,0.913303))
	local txtSweep = GetElement(self.m_root,"txtSweep_WndTeamCopySweep",WZUILabelTTF)
	txtSweep:setScale(0.8)
	txtSweep:setRelativePosition(GlobalMethod:ccp(0.61679,0.913))
	local txtSweepC = GetElement(self.m_root,"txtSweepC_WndTeamCopySweep",WZUILabelTTF)
	txtSweepC:setScale(0.8)
	txtSweepC:setRelativePosition(GlobalMethod:ccp(0.899403,0.9133))
	GetElement(self.m_root,"imgItem_WndTeamCopySweep",WZUIImage):setScale(0.4)
	
	local txtSweepAll = GetElement(self.m_root,"txtSweepAll_WndTeamCopySweep",WZUILabelTTF)
	txtSweepAll:setScale(0.7)
	txtSweepAll:setDimensions(GlobalMethod:CCSize(140))
end

function WndTeamCopySweep:_adaptLanguage_tr(  )
	-- local imgArrow1 = GetElement(self.m_root,"imgArrow1_WndTeamCopySweep",WZUIImage)
	-- imgArrow1:setRelativePosition(GlobalMethod:ccp(0.12,0.110465))
	local txtCost = GetElement(self.m_root,"txtCost_WndTeamCopySweep",WZUILabelTTF)
	txtCost:setScale(0.8)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.186001,0.113379))
	local txtPower = GetElement(self.m_root,"txtPower_WndTeamCopySweep",WZUILabelTTF)
	txtPower:setScale(0.8)
	txtPower:setRelativePosition(GlobalMethod:ccp(0.581594,0.113379))
	local txtPlayerFight = GetElement(self.m_root,"txtPlayerFight_WndTeamCopySweep",WZUILabelTTF)
	txtPlayerFight:setScale(0.8)
	txtPlayerFight:setRelativePosition(GlobalMethod:ccp(0.701595,0.113379))
	-- local imgArrow2 = GetElement(self.m_root,"imgArrow2_WndTeamCopySweep",WZUIImage)
	-- imgArrow2:setRelativePosition(GlobalMethod:ccp(0.88,0.110465))

	local txtSweepAll = GetElement(self.m_root,"txtSweepAll_WndTeamCopySweep",WZUILabelTTF)
	txtSweepAll:setScale(0.7)
	txtSweepAll:setDimensions(GlobalMethod:CCSize(140))

	local txtCopyNameT = GetElement(self.m_root,"txtCopyNameT_WndTeamCopySweep",WZUILabelTTF)
	txtCopyNameT:setScale(0.8)
	txtCopyNameT:setRelativePosition(GlobalMethod:ccp(0.0447616,0.913303))
	local txtCopyName = GetElement(self.m_root,"txtCopyName_WndTeamCopySweep",WZUILabelTTF)
	txtCopyName:setScale(0.8)
	txtCopyName:setRelativePosition(GlobalMethod:ccp(0.262869,0.913303))
	local txtSweep = GetElement(self.m_root,"txtSweep_WndTeamCopySweep",WZUILabelTTF)
	txtSweep:setScale(0.8)
	txtSweep:setRelativePosition(GlobalMethod:ccp(0.53,0.913))
	local txtSweepC = GetElement(self.m_root,"txtSweepC_WndTeamCopySweep",WZUILabelTTF)
	txtSweepC:setScale(0.8)
	txtSweepC:setRelativePosition(GlobalMethod:ccp(0.854108,0.9133))
	GetElement(self.m_root,"txtDifficulty_WndTeamCopySweep",WZUILabelTTF):setScale(0.8)

	local txtCostDes = GetElement(self.m_root,"txtCostDes_WndTeamCopySweep",WZUILabelTTF)
	txtCostDes:setScale(0.8)
	local imgItem = GetElement(self.m_root,"imgItem_WndTeamCopySweep",WZUIImage)
	imgItem:setScale(0.4)
	local txtSweepCount = GetElement(self.m_root,"txtSweepCount_WndTeamCopySweep",WZUILabelTTF)
	txtSweepCount:setScale(0.8)
	GetElement(self.m_root, "txtLeftWords_WndTeamCopySweep", WZUILabelTTF):setScale(0.8)
end
--------------------------------------语言适配End-------------------------------------------