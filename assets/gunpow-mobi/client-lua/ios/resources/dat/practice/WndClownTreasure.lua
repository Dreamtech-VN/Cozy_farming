--WndClownTreasure.lua
--@brief	WndClownTreasure的UI模块
--@date		2016/07/20
--@author	zhangming
--@note		小丑寻宝


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndClownTreasure:onEnter(element)
	WZLog("WndClownTreasure:onEnter")
	self.m_root = element
	AdaptLanguage(self)
	self.t_nConListPosY = {757,857,357,457,557,657,357}
	if WndBless and WndBless.m_root == nil then
		ProtocolProcessorBless:regAll()
	end
	
	ProtocolProcessorBless:send_PRAY_GetRaffleInfo()
end


--@brief	创建窗口动画
function WndClownTreasure:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"conGou_WndClownTreasure",WZUIContainer):setVisible(GlobalGame.G_ClownTreasure_Quick == 1)
	self:AnalysisReward()
	self:_initUi()
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndClownTreasure:onExit(element)
	WZLog("WndClownTreasure:onExit")
	if WndBless and WndBless.m_root == nil then
		ProtocolProcessorBless:unregAll()
	end
	self:_unInit()
end

--@brief    点击摇杆开始
function WndClownTreasure:onClickStar(element)
	WZLog("WndClownTreasure:onClickStar")
   SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nStatus == 1 then
		MsgBoxManager:showTipBox(LocalStrings.NOT_GET_TREASURE_TIP)
		return
	end
	local playerInfo = CacheCenter:getPlayerInfo()
	local vipLevel = playerInfo.vipLevel
	local raffleNum = tonumber(CacheCenter:getGameParam().raffleNum)
	
	local count,cost = self:_getVipLimitData2(22)
	local count2,cost2,needVipLevel = self:_getVipLimitData(22,self.m_nRaffleNum-raffleNum+1)
	
	if self.m_nRaffleNum - raffleNum < 0 then
		ProtocolProcessorBless:send_PRAY_Raffle()
		return
	end
	if self.m_nRaffleNum - raffleNum < count then
		local bResertCount = self.m_nRaffleNum - raffleNum
		local tips = string.format(LocalStrings.TREASURE_RESERT_TIP3 ,cost2[1][2],bResertCount,count)
		MsgBoxManager:showConfirmBox(tips,self,self.onResetCall)
	elseif self.m_nRaffleNum - raffleNum >= count and  needVipLevel ~= nil and needVipLevel < 15 then
		local strTip = string.format(LocalStrings.SINGLE_RESERT_TIP2,needVipLevel)
		MsgBoxManager:showConfirmCancelBox(strTip, self, self._EventToVIP, MSGBOXLEVEL_NORMAL, nil)
	else
		MsgBoxManager:showTipBox(LocalStrings.SHOP_DAY_LIMITED)
	end
end

--@brief    点击关闭界面
function WndClownTreasure:onClickClose(element)
	WZLog("WndClownTreasure:onClickClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_bOpenByStore then
		WndStore:showStoreByType(4)
	end
	WindowManager:removeWindow(WndClownTreasure.m_root,WndClownTreasure,true)
end

--@brief    点击快速选择
function WndClownTreasure:onClickQuick(element)
	WZLog("WndClownTreasure:onClickQuick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if GlobalGame.G_ClownTreasure_Quick == 0  then
		GlobalGame.G_ClownTreasure_Quick = 1
	else
		GlobalGame.G_ClownTreasure_Quick = 0
	end
	GetElement(self.m_root,"conGou_WndClownTreasure",WZUIContainer):setVisible(GlobalGame.G_ClownTreasure_Quick == 1)
end

--不同状态下显示不同的tip
function WndClownTreasure:changTip()
	-- body
	WZLog("WndClownTreasure:changTip")
	local conTips = GetElement(self.m_root,"conTips_WndClownTreasure",WZUIContainer)
	local txtTip = GetElement(conTips,"txtTip_WndClownTreasure",WZUILabelTTF)
	local indexx = math.random(5)
	local tempT = {LocalStrings.CLOWN_TIP1,LocalStrings.CLOWN_TIP2,LocalStrings.CLOWN_TIP3,LocalStrings.CLOWN_TIP4,LocalStrings.CLOWN_TIP5,LocalStrings.CLOWN_TIP6,LocalStrings.CLOWN_TIP7,LocalStrings.CLOWN_TIP8,LocalStrings.CLOWN_TIP9,LocalStrings.CLOWN_TIP10}
	local strTemp = nil
	if self.m_nStatus == 0 then
		strTemp = tempT[indexx]
	else
		indexx = indexx + 5
		strTemp = tempT[indexx]
	end
	txtTip:setText(strTemp)
end

function WndClownTreasure:updateUI(bResetPS)
	-- body
	WZLog("WndClownTreasure:updateUI")
	GetElement(self.m_root,"conAll_WndClownTreasure",WZUIContainer):setTouchEnable(true)
	
	local btnSure = GetElement(self.m_root,"btnSure_WndClownTreasure",WZUIButton)
	btnSure:setTouchEnable(false)

	local conRewardTip = GetElement(self.m_root,"conRewardTip_WndClownTreasure",WZUIContainer)

	local txtQifu1 = GetElement(conRewardTip,"txtQifu1_WndClownTreasure",WZUILabelTTF)
	txtQifu1:setText("")
	local txtQifu2 = GetElement(conRewardTip,"txtQifu2_WndClownTreasure",WZUILabelTTF)
	txtQifu2:setText("")

	local imgReward1 = GetElement(conRewardTip,"imgReward1_WndClownTreasure",WZUIImage)
	local imgReward2 = GetElement(conRewardTip,"imgReward2_WndClownTreasure",WZUIImage)
	imgReward1:setFile("")
	imgReward2:setFile("")

	local txtTip2 = GetElement(conRewardTip,"txtTip2_WndClownTreasure",WZUILabelTTF)
	conRewardTip:setVisible(true)
	if self.m_nRaffleNum <= 0 and self.m_nStatus == 0 then
		conRewardTip:setVisible(false)
	else
		if self.m_nRaffleNum == 0 and self.m_nStatus == 1 then
			txtTip2:setText(LocalStrings.TREASURE_RESET_TIP6)
		else
			local treasureCountStr = string.format(LocalStrings.TODAY_TREASURE_COUNT,self.m_nRaffleNum)
	        txtTip2:setText(treasureCountStr)
		end
	end

    if self.m_nStatus == 1 then
    	btnSure:setTouchEnable(true)
    	local xiaochouCount = 1
		for i,v in ipairs(self.m_tRaffleMark) do
			if v == 6 then
				xiaochouCount = xiaochouCount + 1
			end
		end
		if xiaochouCount > 0 then
			local rewardData = self.m_tRewardData[xiaochouCount]
			if #rewardData <= 2 then
				local itemInfo = GDatatab_item["id_" .. rewardData[1]]
				imgReward1:setFile(itemInfo.icon)
				txtQifu1:setText(rewardData[2])
			else
				local itemInfo = GDatatab_item["id_" .. rewardData[1]]
				imgReward1:setFile(itemInfo.icon)

				local itemInfo2 = GDatatab_item["id_" .. rewardData[3]]
				imgReward2:setFile(itemInfo2.icon)

				txtQifu1:setText(rewardData[2])
				txtQifu2:setText(rewardData[4])
			end
		end
    end

	local resetRef = tonumber(CacheCenter:getGameParam().raffleResetNum)
	WZLog("resetRef =",resetRef,self.m_nRaffleReset)
    local count,cost = self:_getVipLimitData(23,self.m_nRaffleReset-resetRef+1)

    local playerVipLevel = CacheCenter:getPlayerInfo().vipLevel
	for i=1,5 do
		local conRefresh = GetElement(self.m_root,"conRefresh" .. i .. "_WndClownTreasure",WZUIContainer)
		if self.m_nStatus == 0 then
			conRefresh:setVisible(false)
		else
			if self.m_tRaffleMark[i] ~= 6 then
				conRefresh:setVisible(true)
				local imgLizhuan = GetElement(conRefresh,"imgLizhuan_WndClownTreasure",WZUIImage)
				local txtStatus = GetElement(conRefresh,"txtStatus_WndClownTreasure",WZUILabelTTF)
				local txtCostCount = GetElement(conRefresh,"txtCostCount_WndClownTreasure",WZUILabelTTF)
				txtCostCount:setText("")
				if self.m_nRaffleReset < resetRef then
					imgLizhuan:setVisible(false)
					txtStatus:setVisible(true)
				elseif self.m_nRaffleReset >= resetRef and cost ~= nil and  (self.m_nRaffleReset - resetRef < count or (self.m_nRaffleReset - resetRef >= count and playerVipLevel < 15)) then
					imgLizhuan:setVisible(true)
					txtStatus:setVisible(false)
					imgLizhuan:setFile(GDatatab_item["id_" .. cost[1][1]].icon)
					txtCostCount:setText(cost[1][2])
				else
					conRefresh:setVisible(false)
				end
			else
				conRefresh:setVisible(false)
			end
		end
	end

	local conList = nil
	local xunzhanCount = 0 --祈福勋章数
	local qifubiCount = 0 --祈福币数

	if bResetPS == nil then
		for i,v in ipairs(self.m_tRaffleMark) do
			conList = GetElement(self.m_root,"conList" .. i .."_WndClownTreasure",WZUIContainer)
			conList:setPositionY(self.t_nConListPosY[v])
		end
	end
end

function WndClownTreasure:onClickSure(element)
	-- body
	WZLog("WndClownTreasure:onClickSure")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorBless:send_PRAY_GiveRaffleReward()
end

--单次刷新
function WndClownTreasure:onClickRefresh(element)
	-- body
	WZLog("WndClownTreasure:onClickRefresh")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local viplevel = CacheCenter:getPlayerInfo().vipLevel
	if self.m_nStatus == 1 then
		local tag = element:getTag()
		local resetRef = tonumber(CacheCenter:getGameParam().raffleResetNum)
		if  self.m_nRaffleReset <  resetRef then
			self.m_nTag = tag
			ProtocolProcessorBless:send_PRAY_ResetRaffle(tag-1)
		elseif self.m_nRaffleReset - resetRef >= 0 then
			local count,cost,needVipLevel = self:_getVipLimitData(23,self.m_nRaffleReset-resetRef + 1)
			local totocalCount,cost2 = self:_getVipLimitData2(23)
			self.m_nTag = tag
			if viplevel >= needVipLevel and JudgeMoneyIsEnough(cost[1][1],cost[1][2],nil,nil,nil,nil,nil,nil,nil,self,self.sendPRAYResetRaffle)  then
				local tipss = string.format(LocalStrings.TREASURE_RESERT_TIP5,cost[1][2],self.m_nRaffleReset - resetRef,totocalCount)
				MsgBoxManager:showConfirmCancelBox(tipss,self,self.onRefresh,nil,nil,"refreshClown")
			elseif viplevel < needVipLevel then
				local tipss = string.format(LocalStrings.TREASURE_RESERT_TIP4,self.m_nRaffleReset - resetRef,totocalCount,needVipLevel)
				MsgBoxManager:showConfirmCancelBox(tipss,self,self._EventToVIP)
			end
		end
	end
end

--显示说明
function WndClownTreasure:onClickExplain(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.CLOWN_EXPLAIN)
end

--重置拉杆
function WndClownTreasure:onResetCall(nId, nResType)
	WZLog("WndClownTreasure:onResetCall ",nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local raffleNum = tonumber(CacheCenter:getGameParam().raffleNum)
		local count,cost = self:_getVipLimitData(22,self.m_nRaffleNum-raffleNum+1)
		if JudgeMoneyIsEnough(cost[1][1],cost[1][2],nil,nil,nil,nil,nil,nil,nil,self,self.sendPrayRaffle) then
			ProtocolProcessorBless:send_PRAY_Raffle()
		end
	end
end

function WndClownTreasure:sendPrayRaffle(nId, nResType)
	-- body
	WZLog("WndClownTreasure:sendPrayRaffle")
	ProtocolProcessorBless:send_PRAY_Raffle()
end


function WndClownTreasure:onRefresh(nId,nResType)
	-- body
	WZLog("WndClownTreasure:onRefresh ",self.m_nTag)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		ProtocolProcessorBless:send_PRAY_ResetRaffle(self.m_nTag-1)
	end
end

function WndClownTreasure:sendPRAYResetRaffle()
	-- body
	WZLog("WndClownTreasure:sendPRAYResetRaffle")
	ProtocolProcessorBless:send_PRAY_ResetRaffle(self.m_nTag-1)
end

--@brief    前往vip充值
function WndClownTreasure:_EventToVIP( nId, nResType )
    WZLog("WndClownTreasure:_EventToVIP")
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndVip:showWndUI(0)
    end
end

-------------------------------------公有方法模块End----------------------------------------

--@breif 开始滚动相关数值
function WndClownTreasure:_startRoll()
	WZLog("WndClownTreasure:_startRoll")
	--快速播放跳过滚动

	if GlobalGame.G_ClownTreasure_Quick == 1 then
		self:_passRoll()
	else
		self.n_speed = 140
		self.t_bActionOver = {0,0,0,0,0}
		self.m_root:enableSchedule("_starRollSchedule",0.001)
	end
end

--@brief 开始滚动
function WndClownTreasure:_starRollSchedule()
	--290 900 355
	self.n_speed = math.max(self.n_speed - 3,12) --减速到某个值将不再减少
	for i = 1,5 do
		local element = GetElement(self.m_root,"conList"..i.."_WndClownTreasure")
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
		GetElement(self.m_root,"spine1_WndClownTreasure",WZUISpine):play("a_3", false)
		--开始初始化移动特效
		self:_initMove()
	end
end

function WndClownTreasure:_startSingleRoll()
	-- body
	WZLog("WndClownTreasure:_startSingleRoll")
	if GlobalGame.G_ClownTreasure_Quick == 1 then
		self:_passRoll()
	else
		self.n_speed = 140
		self.t_bActionOver = {0}
		self.m_root:enableSchedule("_starSingleRollSchedule",0.001)
	end
end

--@brief 开始滚动
function WndClownTreasure:_starSingleRollSchedule()
	--290 900 355
	self.n_speed = math.max(self.n_speed - 3,12) --减速到某个值将不再减少
	local element = GetElement(self.m_root,"conList".. self.m_nTag .."_WndClownTreasure")
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
		GetElement(self.m_root,"spine1_WndClownTreasure",WZUISpine):play("a_3", false)
		--开始初始化移动特效
		self:_initMove()
	end
end

--@brief 设置容器的位置
function WndClownTreasure:_setRollPosition(element,moveY)
	local posY = element:getPositionY()
	posY = posY + moveY
	if posY > 853 then
		posY = 257
	end
	element:setPositionY(posY)
end

--@breif 跳过动画直接滚动
function WndClownTreasure:_passRoll()
	for i,v in ipairs(self.m_tLuckDrawData) do
		conList = GetElement(self.m_root,"conList" .. i .."_WndClownTreasure",WZUIContainer)
		conList:setPositionY(self.t_nConListPosY[v])
	end
	self:_initMove()
end

--@breif 初始化特效动相关数值
function WndClownTreasure:_initMove()
	WZLog("WndClownTreasure:_initMove")
	self.m_tRaffleMark = self.m_tLuckDrawData
	self.m_nStatus = 1
	self:updateUI(false)
end

--brief 移动完后的处理
function WndClownTreasure:_moveOver(element)
	
end

--@brief 经验动画的添加
function WndClownTreasure:_addExp()
	WZLog("WndClownTreasure:_addExp")
	
end

--@brief 经验动画的定时器
function WndClownTreasure:_addExpSchedule(element)
	local tag = element:getTag()
	local needAddExp = self.t_data.addExp[tag]
	WZLog("WndClownTreasure:_addExpSchedule:",tag,needAddExp)
	if needAddExp == 0 then
		GetElement(self.m_root,"txt"..tag.."_WndClownTreasure",WZUILabelTTF):setVisible(false)
        element:disableSchedule()
		self.t_data.curAddNum = self.t_data.curAddNum + 1
		if self.t_data.curAddNum >= self.t_data.needAddNum then
			self:_addExpOver()
		end
        return
    end
	local speedRatio = G_Practice_Quick == 0 and 1 or 2 
	local exp = math.max(math.floor(self.t_data.addExp2[tag]/20*speedRatio),1)
    local maxExp = self:_getMaxExp(tag,self.t_data.curLv[tag])
    local addExp = (needAddExp > exp ) and exp or needAddExp
    self.t_data.addExp[tag] = needAddExp - addExp
    self.t_data.curExp[tag] = self.t_data.curExp[tag] + addExp
    if self.t_data.curExp[tag] >= maxExp then
    		if self.t_data.curLv[tag] >= 80 or self.t_data.curLv[tag] >= CacheCenter:getPlayerInfo().level then
    			return
    		end
        	self.t_data.curExp[tag] = self.t_data.curExp[tag] - maxExp
            self.t_data.curLv[tag] = self.t_data.curLv[tag] + 1
            maxExp = self:_getMaxExp(tag,self.t_data.curLv[tag])
            self:_showUpgrade(tag,self.t_data.curLv[tag])
    end
    self:_setExp(tag,self.t_data.curExp[tag],maxExp)
end

--@brief 经验动画的添加
function WndClownTreasure:_setExp(index,exp,maxExp)
	local txtElement = GetElement(self.m_root,"txt"..index.."_WndClownTreasure",WZUILabelTTF)
	local proElement = GetElement(self.m_root,"pro"..index.."_WndClownTreasure",WZUIProgress)
	proElement:setPercentage(exp/maxExp*100)
	txtElement:setVisible(true)
	txtElement:setText(string.format("%.1f%%",""..(exp/maxExp*100)))
end

--@brief 升级特效的修改
function WndClownTreasure:_showUpgrade(index,lv)
	GetElement(self.m_root,"txtLv"..index.."_WndClownTreasure",WZUILabelTTF):setText("Lv"..lv)
	local element = GetElement(self.m_root,"conItem"..index.."_WndClownTreasure",WZUIContainer)
	self:_createSpine(element, nil, nil, "exp_2")
end

--@brief 升级特效的播放完毕
function WndClownTreasure:_upgradeOver(element)
	local spine = WZUISpine:luaTo(element)
	if spine:isCurrentAnimationDone() then
		element:disableSchedule()
		element:removeFromParentAndCleanup(true)
	end
end

--@brief 获取得到当前等级的经验
function WndClownTreasure:_getMaxExp(index,lv)
	for k, v in pairs(GDatatab_upgrade_attr) do
		if v.type == index and v.level == lv then
			return v.lv_exp
		end
	end
	return 1
end


--brief  设置修炼界面的显示
function WndClownTreasure:_initUi(date)
	WZLog("WndClownTreasure:_initUi")
	local txtTip2 = GetElement(self.m_root,"txtTip2_WndClownTreasure",WZUILabelTTF)

end

-------------------------------------私有方法模块Begin--------------------------------------


--@brief    获取当前VIP限购数据
function WndClownTreasure:_getVipLimitData(nType,counttt)
	WZLog("WndClownTreasure:_getVipLimitData ",counttt)
	local playerInfo = CacheCenter:getPlayerInfo()
	local vipLevel = playerInfo.vipLevel
    -- body
    local countt = 0
    local costT= nil
    local vipLevel = nil
    for key, value in pairs(GDatatab_vip_restriction) do
        if value.type == nType and value.count == counttt then
        	countt = value.count
        	costT = value.cost
        	vipLevel = value.vip_level
        	break
        end
    end

    return countt,costT,vipLevel
end

--@brief    根据当前VIP等级获取重置次数
function WndClownTreasure:_getVipLimitData2(nType)
	WZLog("WndClownTreasure:_getVipLimitData2")
	local playerInfo = CacheCenter:getPlayerInfo()
	local vipLevel = playerInfo.vipLevel
    -- body
    local countt = 0
    local costT= nil
    for key, value in pairs(GDatatab_vip_restriction) do
        if value.type == nType and vipLevel >= value.vip_level and value.count > countt then
        	countt = value.count
        	costT = value.cost
        end
    end
    return countt,costT
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------
function WndClownTreasure:_adaptLanguage_vn(  )
	local txtTip = GetElement(self.m_root,"txtTip_WndClownTreasure",WZUILabelTTF)
	txtTip:setScale(0.8)
	txtTip:setDimensions(GlobalMethod:CCSize(220))

	local txtTip2 = GetElement(self.m_root,"txtTip2_WndClownTreasure",WZUILabelTTF)
	txtTip2:setScale(0.8)
	local imgReward1 = GetElement(self.m_root,"imgReward1_WndClownTreasure",WZUIImage)
	imgReward1:setRelativePosition(GlobalMethod:ccp(0.753675,0.525))
	local txtQifu1 = GetElement(self.m_root,"txtQifu1_WndClownTreasure",WZUILabelTTF)
	txtQifu1:setScale(0.8)
	txtQifu1:setRelativePosition(GlobalMethod:ccp(0.799242,0.5))
	local imgReward2 = GetElement(self.m_root,"imgReward2_WndClownTreasure",WZUIImage)
	imgReward2:setRelativePosition(GlobalMethod:ccp(1.02746,0.5))
	local txtQifu2 = GetElement(self.m_root,"txtQifu2_WndClownTreasure",WZUILabelTTF)
	txtQifu2:setScale(0.8)
	txtQifu2:setRelativePosition(GlobalMethod:ccp(1.07576,0.5))
end
function WndClownTreasure:_adaptLanguage_en()
	local txtTip2 = GetElement(self.m_root,"txtTip2_WndClownTreasure",WZUILabelTTF)
	txtTip2:setScale(0.8)
	txtTip2:setDimensions(GlobalMethod:CCSize(310))
	local imgReward1 = GetElement(self.m_root,"imgReward1_WndClownTreasure",WZUIImage)
	imgReward1:setRelativePosition(GlobalMethod:ccp(0.753675,0.525))
	local txtQifu1 = GetElement(self.m_root,"txtQifu1_WndClownTreasure",WZUILabelTTF)
	txtQifu1:setScale(0.8)
	txtQifu1:setRelativePosition(GlobalMethod:ccp(0.799242,0.5))
	local imgReward2 = GetElement(self.m_root,"imgReward2_WndClownTreasure",WZUIImage)
	imgReward2:setRelativePosition(GlobalMethod:ccp(1.02746,0.5))
	local txtQifu2 = GetElement(self.m_root,"txtQifu2_WndClownTreasure",WZUILabelTTF)
	txtQifu2:setScale(0.8)
	txtQifu2:setRelativePosition(GlobalMethod:ccp(1.07576,0.5))

	local txtTip = GetElement(self.m_root,"txtTip_WndClownTreasure",WZUILabelTTF)
	txtTip:setScale(0.8)
	txtTip:setDimensions(GlobalMethod:CCSize(220,80))
end

function WndClownTreasure:_adaptLanguage_pt()
	local txtTip2 = GetElement(self.m_root,"txtTip2_WndClownTreasure",WZUILabelTTF)
	txtTip2:setScale(0.8)
	txtTip2:setDimensions(GlobalMethod:CCSize(300))
	local imgReward1 = GetElement(self.m_root,"imgReward1_WndClownTreasure",WZUIImage)
	imgReward1:setRelativePosition(GlobalMethod:ccp(0.753675,0.525))
	local txtQifu1 = GetElement(self.m_root,"txtQifu1_WndClownTreasure",WZUILabelTTF)
	txtQifu1:setScale(0.8)
	txtQifu1:setRelativePosition(GlobalMethod:ccp(0.799242,0.5))
	local imgReward2 = GetElement(self.m_root,"imgReward2_WndClownTreasure",WZUIImage)
	imgReward2:setRelativePosition(GlobalMethod:ccp(1.02746,0.5))
	local txtQifu2 = GetElement(self.m_root,"txtQifu2_WndClownTreasure",WZUILabelTTF)
	txtQifu2:setScale(0.8)
	txtQifu2:setRelativePosition(GlobalMethod:ccp(1.07576,0.5))

	local txtTip = GetElement(self.m_root,"txtTip_WndClownTreasure",WZUILabelTTF)
	txtTip:setScale(0.8)
	txtTip:setDimensions(GlobalMethod:CCSize(220,80))
end

function WndClownTreasure:_adaptLanguage_es()
	local txtTip2 = GetElement(self.m_root,"txtTip2_WndClownTreasure",WZUILabelTTF)
	txtTip2:setScale(0.8)
	txtTip2:setDimensions(GlobalMethod:CCSize(300))
	local imgReward1 = GetElement(self.m_root,"imgReward1_WndClownTreasure",WZUIImage)
	imgReward1:setRelativePosition(GlobalMethod:ccp(0.753675,0.525))
	local txtQifu1 = GetElement(self.m_root,"txtQifu1_WndClownTreasure",WZUILabelTTF)
	txtQifu1:setScale(0.8)
	txtQifu1:setRelativePosition(GlobalMethod:ccp(0.799242,0.5))
	local imgReward2 = GetElement(self.m_root,"imgReward2_WndClownTreasure",WZUIImage)
	imgReward2:setRelativePosition(GlobalMethod:ccp(1.02746,0.5))
	local txtQifu2 = GetElement(self.m_root,"txtQifu2_WndClownTreasure",WZUILabelTTF)
	txtQifu2:setScale(0.8)
	txtQifu2:setRelativePosition(GlobalMethod:ccp(1.07576,0.5))

	local txtTip = GetElement(self.m_root,"txtTip_WndClownTreasure",WZUILabelTTF)
	txtTip:setScale(0.8)
	txtTip:setDimensions(GlobalMethod:CCSize(220,80))
end

function WndClownTreasure:_adaptLanguage_tr()
	for i=1,5 do
		local conRefresh = GetElement(self.m_root,"conRefresh" .. i .. "_WndClownTreasure",WZUIContainer)
		local txtStatus = GetElement(conRefresh,"txtStatus_WndClownTreasure",WZUILabelTTF)
		txtStatus:setScale(0.7)
	end
	local imgReward1 = GetElement(self.m_root,"imgReward1_WndClownTreasure",WZUIImage)
	imgReward1:setRelativePosition(GlobalMethod:ccp(0.88,0.525))
	local txtQifu1 = GetElement(self.m_root,"txtQifu1_WndClownTreasure",WZUILabelTTF)
	txtQifu1:setRelativePosition(GlobalMethod:ccp(0.92,0.5))
	local imgReward2 = GetElement(self.m_root,"imgReward2_WndClownTreasure",WZUIImage)
	imgReward2:setRelativePosition(GlobalMethod:ccp(1.13,0.5))
	local txtQifu2 = GetElement(self.m_root,"txtQifu2_WndClownTreasure",WZUILabelTTF)
	txtQifu2:setRelativePosition(GlobalMethod:ccp(1.19,0.5))
end
-------------------------------------语言适配End----------------------------------------
