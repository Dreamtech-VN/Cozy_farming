--WndEquipmentLottery.lua
--@brief	WndEquipmentLottery的UI模块
--@date		2016/05/10
--@author	xiang
--@note		装备抽奖系统


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndEquipmentLottery:onEnter(element)
	local GetElement = GetElement
	self.m_root = element
	--语言适配
	self.isUseTicket = CacheCenter:getGameParam().isUseTicket
	self.m_bCanTouch = nil
	-- ProtocolProcessorWndEquipmentRaffle:regAll()
	-- ProtocolProcessorWndEquipmentRaffle:send_EQUIP_GetFreeTime()
	-- ProtocolProcessorWndEquipmentRaffle:send_EQUIP_TenLotteryRewardStatus()
	ProtocolProcessorWndRankList:regAll3()
	ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo(1)
	self.m_bUpdate = true

	self:_addTop()
	local equipLotteryPrice =  CacheCenter:getGameParam().equipLotteryPrice
	self.m_tIds,self.m_tNums = SplitItemString(equipLotteryPrice)
	--如果有新手定推礼包，显示入口
	local conMiddle = GetElement(self.m_root, "conMiddle_WndEquipmentLottery", WZUIContainer)
	if IsIphoneX() then
		CreateLimitPackage(11, conMiddle, GlobalMethod:ccp(0.07,0.2), true)
	else
		CreateLimitPackage(11, conMiddle, GlobalMethod:ccp(0.053,0.2), true)
	end
	
	local txtDiamondCount = GetElement(self.m_root,"txtDiamondCount_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount:setText(self.m_tNums[2])

	local gameParam = CacheCenter:getGameParam()
	local txtDiamondCount2 = GetElement(self.m_root,"txtDiamondCount2_WndEquipmentLottery",WZUILabelTTF)
	local gainGold = tonumber(gameParam.equipLotteryGainGold)*10
	txtDiamondCount2:setText(LocalStrings.BUY2 .. gainGold)

	local txtFragmentCount = GetElement(self.m_root,"txtFragmentCount_WndEquipmentLottery",WZUILabelTTF)
	txtFragmentCount:setText(self.m_tNums[4])

	local imgReplace = GetElement(self.m_root,"imgReplace_WndEquipmentLottery",WZUIImage)
	imgReplace:setFile(GDatatab_item["id_"..self.m_tIds[1]].icon)

	local txtReplaceCount = GetElement(self.m_root,"txtReplaceCount_WndEquipmentLottery",WZUILabelTTF)
	txtReplaceCount:setText(self.m_tNums[1])

	local txtDiamondTen = GetElement(self.m_root,"txtDiamondTen_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondTen:setText(LocalStrings.CALL)

	local imgFaffle2 = GetElement(self.m_root,"imgFaffle2_WndEquipmentLottery",WZUIImage)
	local imgRed2 = GetElement(self.m_root,"imgRed2_WndEquipmentLottery",WZUIImage)
	imgRed2:setVisible(false)
	local fragmentCount =  CacheCenter:getPlayerItemCountById(self.m_tIds[1])
	WZLog("fragmentCount ======= ",fragmentCount)

	local freeTextTip3 = GetElement(self.m_root,"freeTextTip3_WndEquipmentLottery",WZUIFreeTextBox)
	local sssss = LocalStrings.BUY2 .. gainGold
	local bbbb = string.format(LocalStrings.DRAW_TIP_FREE_TEXT_ADDITIONAL,10)
	GetElement(self.m_root,"freeTextTipAdditional3_WndEquipmentLottery",WZUIFreeTextBox):setShowText(bbbb)
	local tempFreeText 
	if self.isUseTicket == "0" then
		tempFreeText= string.format(LocalStrings.DRAW_TIP_FREE_TEXT,self.m_tNums[3],GDatatab_item["id_70"].icon,sssss,GDatatab_item["id_2"].icon)
	else
		tempFreeText= string.format(LocalStrings.DRAW_TIP_FREE_TEXT,self.m_tNums[3],GDatatab_item["id_1"].icon,sssss,GDatatab_item["id_2"].icon)
	end
	freeTextTip3:setShowText(tempFreeText)

	local freeTextTip2 = GetElement(self.m_root,"freeTextTip2_WndEquipmentLottery",WZUIFreeTextBox)
	if fragmentCount >= tonumber(self.m_tNums[1]) then
		imgFaffle2:setScale(0.6)
		imgFaffle2:setFile(GDatatab_item["id_" .. self.m_tIds[1]].icon)
		txtDiamondCount:setText(self.m_tNums[1])
		if fragmentCount >= tonumber(self.m_tNums[1])*10 then
			imgRed2:setVisible(true)
		end
		freeTextTip2:setVisible(false)
	else
		imgFaffle2:setFile(GDatatab_item["id_2"].icon)
		imgFaffle2:setScale(0.6)
		txtDiamondCount:setText(LocalStrings.BUY2 .. gameParam.equipLotteryGainGold)
		freeTextTip2:setVisible(true)
		local ss = LocalStrings.BUY2 .. gameParam.equipLotteryGainGold
		local bbbb = string.format(LocalStrings.DRAW_TIP_FREE_TEXT_ADDITIONAL,1)
		GetElement(self.m_root,"freeTextTipAdditional2_WndEquipmentLottery",WZUIFreeTextBox):setShowText(bbbb)
		local tempS
		if self.isUseTicket == "0" then
			--imgFaffle2:setFile(GDatatab_item["id_70"].icon)
			tempS = string.format(LocalStrings.DRAW_TIP_FREE_TEXT,self.m_tNums[2],GDatatab_item["id_70"].icon,ss,GDatatab_item["id_2"].icon)
		else
			--imgFaffle2:setFile(GDatatab_item["id_1"].icon)
			tempS = string.format(LocalStrings.DRAW_TIP_FREE_TEXT,self.m_tNums[2],GDatatab_item["id_1"].icon,ss,GDatatab_item["id_2"].icon)
		end
	    freeTextTip2:setShowText(tempS)
	end
	--self:initUI()

    local isEndTeach41, step41 = TeachGroup1:isTeachFinish(41)
    if isEndTeach41 ~= true and step41 < 5 and CacheCenter:getPlayerInfo().level == 9 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
    end
    self:setFyberTime()

    AdaptLanguage(self)
    self:_AdaptationIphoneX()
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndEquipmentLottery:setFyberTime()
	if NeedFyber(5) then
    	local conFyber = self.m_root:getChildElement("conFyber_WndEquipmentLottery")
    	conFyber:setVisible(true)
    	GetElement(self.m_root,"txtFyber_WndEquipmentLottery",WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
    end 
end

function WndEquipmentLottery:onFunctionClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	DoFyberReward(5)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndEquipmentLottery:onExit(element)
	WZLog("WndEquipmentLottery:onExit")
	ProtocolProcessorWndEquipmentRaffle:unregAll()
	if self.m_scheduleId then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId)
	end
    if self.m_bIsCloseClick == nil then
        local isEndTeach41, teachStep41 = TeachGroup1:isTeachFinish(41)
        if teachStep41 > 4 then
            TeachGroup1:setTeachFinish(41, -1)
            TeachGroup1:removeTeach()
        end
    end
	self:_unInit()
end

function WndEquipmentLottery:updateSchedule(dt)
	WZLog("WndEquipmentLottery:updateSchedule")
	ProtocolProcessorWndEquipmentRaffle:send_EQUIP_GetFreeTime()
	WndEquipmentLottery.m_bUpdate = false
end

--初始化UI
function WndEquipmentLottery:initUI()
	WZLog("WndEquipmentLottery:initUI")
	local GetElement = GetElement
	local txtRaffle = GetElement(self.m_root,"txtRaffle_WndEquipmentLottery",WZUILabelTTF)
	local txtFF = GetElement(self.m_root,"txtFF_WndEquipmentLottery",WZUILabelTTF)
	txtFF:setVisible(false)
	local txtF= GetElement(self.m_root,"txtF_WndEquipmentLottery",WZUILabelTTF)
	local txtT = GetElement(self.m_root,"txtT_WndEquipmentLottery",WZUILabelTTF)

	local imgRed = GetElement(self.m_root,"imgRed_WndEquipmentLottery",WZUIImage)
	imgRed:setVisible(false)
	local imgRed2 = GetElement(self.m_root,"imgRed2_WndEquipmentLottery",WZUIImage)
	imgRed2:setVisible(false)

	local imgFaffle3 = GetElement(self.m_root, "imgFaffle3_WndEquipmentLottery", WZUIImage)
	if imgFaffle3 then
		imgFaffle3:setFile(GDatatab_item["id_2"].icon)
		-- if self.isUseTicket == "0" then
		-- 	imgFaffle3:setFile(GDatatab_item["id_70"].icon)
		-- else
		-- 	imgFaffle3:setFile(GDatatab_item["id_1"].icon)
		-- end
		imgFaffle3:setScale(0.6)
	end

	local conMiddle = GetElement(self.m_root,"conMiddle_WndEquipmentLottery",WZUIContainer)

	for i=1,3 do
		local spine = GetElement(conMiddle,"spine" .. i .. "_WndEquipmentLottery",WZUISpine)
		spine:setFileAtlas("ui/ui_zbcj.atlas")
		spine:setFileJson("ui/ui_zbcj.json")
		if i == 1 then
			spine:setAnimationName("box1")
		elseif i == 2 then
			spine:setAnimationName("box2")
		else
			spine:setAnimationName("box3")
		end
	end

	if self.m_nlotteryTime <= 1 then
		txtF:setVisible(false)
		txtRaffle:setText("")
		txtT:setVisible(false)
		txtFF:setText(LocalStrings.LUACK_DRAW_AGAIN_TIP3)
		txtFF:setVisible(true)
	else
		txtF:setVisible(true)
		txtT:setVisible(true)
		txtRaffle:setText(self.m_nlotteryTime)
	end
	local txtFragmentCount =GetElement(self.m_root,"txtFragmentCount_WndEquipmentLottery",WZUILabelTTF)
	if self.m_nleaveTime > 0 then
		self.m_root:enableSchedule("scheduleUpdateRaffleTime",1)
		local leaveTime = self:formatTime(self.m_nleaveTime)
	    local txtTime1 = GetElement(self.m_root,"txtTime1_WndEquipmentLottery",WZUILabelTTF)
	    local txtTip1 = GetElement(self.m_root,"txtTip1_WndEquipmentLottery",WZUILabelTTF)
	    txtTime1:setText(leaveTime)
	    txtTime1:setVisible(true)
	    txtTip1:setVisible(true)
	    imgRed:setVisible(false)
		txtFragmentCount:setText(self.m_tNums[4])
		if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
			if self:showTenFreeDraw() then
				txtFragmentCount:setText(self.m_tNums[4]*10) 
			end
		end
	else
		txtFragmentCount:setText(LocalStrings.PETFREE2)
		if ProjConfig.LANGUAGE == "tr" then
			txtFragmentCount:setFontSize(18)
		end
		imgRed:setVisible(true)
	end

    local txtDiamondCount = GetElement(self.m_root,"txtDiamondCount_WndEquipmentLottery",WZUILabelTTF)
    local imgFaffle2 = GetElement(self.m_root,"imgFaffle2_WndEquipmentLottery",WZUIImage)
    local txtDiamondTen = GetElement(self.m_root,"txtDiamondTen_WndEquipmentLottery",WZUILabelTTF)
    txtDiamondTen:setText(LocalStrings.CALL)
	local fragmentCount =  CacheCenter:getPlayerItemCountById(self.m_tIds[1])
	WZLog("fragmentCount ======= ",fragmentCount)
	local diamondNum = tonumber(self.m_tNums[1])
	local freeTextTip2 = GetElement(self.m_root,"freeTextTip2_WndEquipmentLottery",WZUIFreeTextBox)
	local gameParam = CacheCenter:getGameParam()
	if fragmentCount >= diamondNum then
		imgFaffle2:setScale(0.6)
		imgFaffle2:setFile(GDatatab_item["id_" .. self.m_tIds[1]].icon)
		txtDiamondCount:setText(self.m_tNums[1])
		if fragmentCount >= diamondNum*10 then --可以进行装备10连抽
			txtDiamondTen:setText(string.format(LocalStrings.TEN_DRAW,10))
			txtDiamondCount:setText(diamondNum*10)
			imgRed2:setVisible(true)
			if ProjConfig.LANGUAGE == "th" then
				txtDiamondTen:setFontSize(15)
			elseif ProjConfig.LANGUAGE == "vn" then
				txtDiamondTen:setFontSize(16)
				txtDiamondTen:setDimensions(GlobalMethod:CCSize(80,0))
			end
		end
		freeTextTip2:setVisible(false)
	else
		local tempS
		imgFaffle2:setFile(GDatatab_item["id_2"].icon)
		imgFaffle2:setScale(0.6)
		txtDiamondCount:setText(LocalStrings.BUY2 .. gameParam.equipLotteryGainGold)
		freeTextTip2:setVisible(true)
		local ss = LocalStrings.BUY2 .. gameParam.equipLotteryGainGold
		local bbbb = string.format(LocalStrings.DRAW_TIP_FREE_TEXT_ADDITIONAL,1)
		GetElement(self.m_root,"freeTextTipAdditional2_WndEquipmentLottery",WZUIFreeTextBox):setShowText(bbbb)
		if self.isUseTicket == "0" then
			--imgFaffle2:setFile(GDatatab_item["id_70"].icon)
			tempS= string.format(LocalStrings.DRAW_TIP_FREE_TEXT,self.m_tNums[2],GDatatab_item["id_70"].icon,ss,GDatatab_item["id_2"].icon)
		else
			--imgFaffle2:setFile(GDatatab_item["id_1"].icon)
			tempS= string.format(LocalStrings.DRAW_TIP_FREE_TEXT,self.m_tNums[2],GDatatab_item["id_1"].icon,ss,GDatatab_item["id_2"].icon)
		end
	    freeTextTip2:setShowText(tempS)
	end

	local fragmentCount =  CacheCenter:getPlayerItemCountById(self.m_tIds[4])
	if fragmentCount >= tonumber(self.m_tNums[4]) * 10 then
		imgRed:setVisible(true)
	end

	local txtReplaceCount = GetElement(self.m_root,"txtReplaceCount_WndEquipmentLottery",WZUILabelTTF)
	local fragmentCount =  CacheCenter:getPlayerItemCountById(self.m_tIds[1])
	if fragmentCount >= tonumber(self.m_tNums[1]) then
		-- txtReplaceCount:setLabelStyleKey("C15_F22")
		txtReplaceCount:setColor(GlobalMethod:ccc3(99,255,95))
	else
		-- txtReplaceCount:setLabelStyleKey("FONT_LABEL_7")
		txtReplaceCount:setColor(GlobalMethod:ccc3(255,89,74))
	end

	local txtFreeLuckDraw = GetElement(self.m_root,"txtFreeLuckDraw_WndEquipmentLottery",WZUILabelTTF)
	if self:showTenFreeDraw() and self.m_nleaveTime > 0 then
		txtFreeLuckDraw:setText(string.format(LocalStrings.TEN_DRAW,10))
		local costCount = tonumber(self.m_tNums[1])*10
		txtFragmentCount:setText(costCount)
		if ProjConfig.LANGUAGE == "vn" then
			txtFreeLuckDraw:setDimensions(GlobalMethod:CCSize(90,0))
			txtFreeLuckDraw:setFontSize(18)
		elseif ProjConfig.LANGUAGE == "th" then
			txtFreeLuckDraw:setFontSize(16)
		end
	else
		txtFreeLuckDraw:setText(LocalStrings.CALL)
	end
end

function WndEquipmentLottery:showTenFreeDraw()
	WZLog("WndEquipmentLottery:showTenFreeDraw")
	local fragmentCount =  CacheCenter:getPlayerItemCountById(self.m_tIds[4])
	local costKey = tonumber(self.m_tNums[4])
	if fragmentCount >= costKey*10 then
		return true
	end
	return false
end

-- 骨骼动画事件回调
--function WndEquipmentLottery:spineEvent(animation, name, eventName)
function WndEquipmentLottery:spineEvent1(element,delal)
	WZLog("WndEquipmentLottery:spineEvent1 ")
	element:disableSchedule()

	local conShelter = GetElement(self.m_root,"conShelter_WndEquipmentLottery",WZUIContainer)
	conShelter:setVisible(false)
	local conRSEEE = GetElement(self.m_root,"conRSEEE_WndEquipmentLottery",WZUIContainer)
	conRSEEE:setVisible(true)

	--if name == "complete" then  --播放完动画再刷新数据
		local conRSE = GetElement(self.m_root,"conRSE_WndEquipmentLottery",WZUIContainer)
		conRSE:setVisible(true)
		--local spRSE =  GetElement(self.m_root,"spRSE_WndEquipmentLottery",WZUISpine)
		-- spRSE:setVisible(false)
		-- local animName = spRSE:getAnimationName()
		-- spRSE:setAnimationName("")
		-- spRSE:setFileAtlas("")
		-- spRSE:setFileJson("")
	    local child = self.m_root:getChildByTag(1199)
	    child:setVisible(true)
		if self.m_nRaffleType == 1 or self.m_nRaffleType == 2 or self.m_nRaffleType == 3  then
			self:showBg()
		end
	--end
end

function WndEquipmentLottery:onSpineEvent( ... )
	WZLog("onSpineEvent = ")
end

function WndEquipmentLottery:showBg()
	local conRaffleBg = GetElement(self.m_root,"conRaffleBg_WndEquipmentLottery",WZUIContainer)
	conRaffleBg:setScaleY(0)
	conRaffleBg:setVisible(true)

	local act1=WZUIActionScaleTo:create()
	act1:setDuration(0.4)
    act1:setScaleX(1)
    act1:setScaleY(1)
    if self.m_nRaffleType == 3 or #self.m_tItems > 1 then
    	act1:setFinishLuaFunction("showEquipmentTen")
    else
    	act1:setFinishLuaFunction("showPrize")
    end
	act1:setFinishLuaTable(self)
	conRaffleBg:runUIAction(act1)
end

--显示奖品出来
function WndEquipmentLottery:showPrize()
	WZLog("WndEquipmentLottery:showPrize")

	local itemInfo = GDatatab_item["id_" .. self.m_tItems[1]]
	local icon = itemInfo.icon

	local conRSE = GetElement(self.m_root,"conRSE_WndEquipmentLottery",WZUIContainer)

	local conAnimationOne = GetElement(self.m_root,"conAnimationOne_WndEquipmentLottery",WZUIContainer)
	conAnimationOne:setVisible(true)

	local imgEquipment = GetElement(conAnimationOne,"imgEquipment_WndEquipmentLottery",WZUIImage)
	imgEquipment:setFile(icon)

	local txtEquipName = GetElement(conAnimationOne,"txtEquipName_ConAnimation",WZUILabelTTF)
	txtEquipName:setText(itemInfo.name)

	local spineOne = GetElement(conAnimationOne,"spineOne_conTenRaffle",WZUISpine)
	spineOne:setFileAtlas("ui/ui_zbcj.atlas")
	spineOne:setFileJson("ui/ui_zbcj.json")
	self:updateEquipName(txtEquipName,itemInfo.quality)
    spineOne:setScale(0.9)
	if itemInfo.quality == 4 then
		spineOne:setScale(0.8)
		spineOne:play("item_rare",true)
	elseif itemInfo.quality == 3 then
		spineOne:setScale(0.8)
		spineOne:play("item_rare",true)
	elseif itemInfo.quality == 2 then
		spineOne:play("item",true)
	else
		spineOne:play("item",true)
	end
	--判断是否添加微信分享按钮
	if itemInfo.quality >= 3 then
		self.m_bIsShowWeiXinBtn = true
	else
		self.m_bIsShowWeiXinBtn = false
	end
	
	local act1=WZUIActionScaleTo:create()
	act1:setDuration(0.2)
    act1:setScaleX(1)
    act1:setScaleY(1)
    act1:setFinishLuaFunction("showButtonBtn")
	act1:setFinishLuaTable(self)
	conAnimationOne:runUIAction(act1)
end

--显示底部按钮
function WndEquipmentLottery:showButtonBtn()
	WZLog("WndEquipmentLottery:showButtonBtn")
	local conBottomBtn = GetElement(self.m_root,"conBottomBtn_WndEquipmentLottery",WZUIContainer)
	conBottomBtn:setVisible(true)
    self.m_bPlayingSpine = false
	local imgLuckDrawType = GetElement(conBottomBtn,"imgLuckDrawType_ConButtonBtn",WZUIImage)

	local txtLuckDrawCount = GetElement(conBottomBtn,"txtLuckDrawCount_ConButtonBtn",WZUILabelTTF)
    local txtDrawAgain = GetElement(conBottomBtn,"txtDrawAgain_WndEquipmentLottery",WZUILabelTTF)
	txtDrawAgain:setText(LocalStrings.LUCK_DRAW_AGAIN)
    local gameParam = CacheCenter:getGameParam()
	if conBottomBtn:getChildByTag(888) then
		conBottomBtn:removeChildByTag(888, true)
	end
	if self.m_bIsShowWeiXinBtn then
		addWeChatBtn(conBottomBtn,2,GlobalMethod:ccp(0.8,0.31))
	end

	if self.m_nRaffleType == 1 then
		imgLuckDrawType:setFile("shopitems/wuqichoujiang_2.png")
		imgLuckDrawType:setScale(0.6)
		if self.m_nleaveTime > 0 then
			txtLuckDrawCount:setText(self.m_tNums[4])
			if self:showTenFreeDraw() then
				local temp = string.format(LocalStrings.DRAW_AGAIN_TEN,10)
				txtDrawAgain:setText(temp)
				txtLuckDrawCount:setText(tonumber(self.m_tNums[4])*10)
				if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
					txtLuckDrawCount:setText(self.m_tNums[4]*10)
				elseif ProjConfig.LANGUAGE == "vn" then
					txtDrawAgain:setScale(0.7)
				end
			end
		else
			txtLuckDrawCount:setText(LocalStrings.PETFREE2)
		end
		
	elseif self.m_nRaffleType == 2 then
		local fragmentCount =  CacheCenter:getPlayerItemCountById(self.m_tIds[1])
		local diamondNum = tonumber(self.m_tNums[1])
		if fragmentCount >= diamondNum then
			imgLuckDrawType:setScale(0.6)
			imgLuckDrawType:setFile(GDatatab_item["id_" .. self.m_tIds[1]].icon)
			txtLuckDrawCount:setText(self.m_tNums[1])
			if fragmentCount >= diamondNum*10 then --装备抽奖卷
				local temp = string.format(LocalStrings.DRAW_AGAIN_TEN,10)
				txtDrawAgain:setText(temp)
				txtLuckDrawCount:setText(diamondNum*10)
				if ProjConfig.LANGUAGE == "vn" then
					txtDrawAgain:setScale(0.7)
				end
			end
		else
			imgLuckDrawType:setFile(GDatatab_item["id_2"].icon)
			imgLuckDrawType:setScale(0.6)
			local tempS = LocalStrings.BUY2 .. gameParam.equipLotteryGainGold
			txtLuckDrawCount:setText(tempS)
		end
	else
		imgLuckDrawType:setFile(GDatatab_item["id_2"].icon)
		imgLuckDrawType:setScale(0.6)
		local dddd = tonumber(gameParam.equipLotteryGainGold) * 10
		local tempS = LocalStrings.BUY2 .. dddd
		txtLuckDrawCount:setText(tempS)
	end
end

--十连抽
function WndEquipmentLottery:showEquipmentTen(spineObject)
	WZLog("WndEquipmentLottery:showEquipmentTen")

	local conRSE = GetElement(self.m_root,"conRSE_WndEquipmentLottery",WZUIContainer)
	conRSE:setVisible(true)

	local conTenRaffle = GetElement(self.m_root,"conTenRaffle_WndEquipmentLottery",WZUIContainer)
	conTenRaffle:setVisible(true)

	for i = 1, 10 do
		local item = self.m_tItems[i]
		local itemInfo = GDatatab_item["id_" .. item]
		--判断是否添加微信分享按钮
		if itemInfo.quality >= 3 then
			self.m_bIsShowWeiXinBtn = true
			break 
		else
			self.m_bIsShowWeiXinBtn = false
		end
	end
	
	for i=1,10 do
		local item = self.m_tItems[i]
		local itemInfo = GDatatab_item["id_" .. item]
		local con= GetElement(conTenRaffle,"con" .. i .. "_conTenRaffle",WZUIContainer)
		con:setVisible(true)
		local act1=WZUIActionScaleTo:create()
		act1:setDuration(0.2)
		act1:setScaleX(1)
		act1:setScaleY(1)

		if i == 1 then
			act1:setFinishLuaFunction("showButtonBtn")
		    act1:setFinishLuaTable(self)
		end
		con:runUIAction(act1)
		local img = GetElement(con,"img" .. i .. "_conTenRaffle",WZUIImage)
		local txt = GetElement(con,"txt" .. i .. "_conTenRaffle",WZUILabelTTF)
		local spine = GetElement(con,"spine" .. i .. "_conTenRaffle",WZUISpine)
		spine:setFileAtlas("ui/ui_zbcj.atlas")
		spine:setFileJson("ui/ui_zbcj.json")
		img:setFile(itemInfo.icon)
		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" 
			or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr"
			or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "ug" then
			txt:setScale(0.6)
			txt:setDimensions(GlobalMethod:CCSize(240))
		end
		txt:setText(itemInfo.name)
		spine:setScale(0.9)
		self:updateEquipName(txt,itemInfo.quality)
		if itemInfo.quality == 4 then
		    spine:play("item_rare",true)
		elseif itemInfo.quality == 3 then
			spine:setScale(0.8)
			spine:play("item_rare",true)
		elseif itemInfo.quality == 2 then
			spine:play("item",true)
		else
			spine:play("item",true)
		end
	end
end

--在抽奖一次
function WndEquipmentLottery:onLuckDrawAgain(element)
	WZLog("WndEquipmentLottery:onLuckDrawAgain")

	-- local conRSEEE = GetElement(self.m_root,"conRSEEE_WndEquipmentLottery",WZUIContainer)
	-- conRSEEE:setVisible(false)

	local spineBox =  GetElement(self.m_root,"spineBox_WndEquipmentLottery",WZUISpine)
	spineBox:play("box3",true)

	if self.m_nRaffleType == 1 then
		self:onClickCommonExtract(nil)
	elseif self.m_nRaffleType == 2 then
		self:onClickDimondRafflt(nil)
	else
		self:onClickDiamondTen(nil)
	end
end

--查看物品大全
function WndEquipmentLottery:onClickAllEquipment(element)
	WZLog("WndEquipmentLottery:onClickAllEquipment")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndGoodsFull:showInterface(1)
end

--查看装备商店
function WndEquipmentLottery:onClickEquipStore(element)
	WZLog("WndEquipmentLottery:onClickEquipStore")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndStore:showStoreByType(8)
end

--@brief    关闭按钮点击被调用的函数
--@param	element:表绑定的UI节点引用
--@note		退出当前场景
function WndEquipmentLottery:onCloseClick(element)
	WZLog("WndEquipmentLottery:onCloseClick")
   SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    
    local isEndTeach41, step41 = TeachGroup1:isTeachFinish(41)
    if isEndTeach41 ~= true and step41 > 0 then
    	self.m_bIsCloseClick = true
    	-- WindowManager:removeWindow(self.m_root,self,true)
    	WndSummonEntrance:closeWin()
        SceneCity.m_tWndBottomBarObj:endMoveVerticalBar(nil, false)
        --return
    else
    	self.m_bIsCloseClick = true
    	-- WindowManager:removeWindow(self.m_root,self,true)
    	WndSummonEntrance:closeWin()
    	pushEquipInList()
    end

end

--碎片抽奖
function WndEquipmentLottery:onClickCommonExtract(element)
	WZLog("WndEquipmentLottery:onClickCommonExtract")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	PostPlayerEvent:postEvent(PostPlayerEvent.event_nineLvClickCall)

	local count =  CacheCenter:getRemainAmount()
	
	if count <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end

	if not self.m_bCanTouch then
		return
	end

	local txtFragmentCount =GetElement(self.m_root,"txtFragmentCount_WndEquipmentLottery",WZUILabelTTF)
	local txt = txtFragmentCount:getText()
	self.m_nRaffleType = 1
	self.m_nSummonTimeType = 1
	if txt == LocalStrings.PETFREE2 then
		self.m_bCanTouch = false
		g_bIsShowWndDressUp = false
        g_tTempItemForLaterShow = {}
		self.m_nLoadingId = MsgBoxManager:showLoadingBox()
		ProtocolProcessorWndEquipmentRaffle:send_EQUIP_Lottery(1)
	else
		local fragmentCount =  CacheCenter:getPlayerItemCountById(self.m_tIds[4])
		if fragmentCount < tonumber(self.m_tNums[4]) then
			MsgBoxManager:showTipBox(LocalStrings.NOTENOUTH3)
			WndFastGetItems:show(self.m_tIds[4],self.m_tNums[4])
            return
		end
		self.m_bCanTouch = false
		self.m_nLoadingId = MsgBoxManager:showLoadingBox()
		g_bIsShowWndDressUp = false
        g_tTempItemForLaterShow = {}
		ProtocolProcessorWndEquipmentRaffle:send_EQUIP_Lottery(1)
	end

	self.m_bTeachDraw = false

    TeachGroup1:endTeachStep({41,3})
    local isEndTeach41, step41 = TeachGroup1:isTeachFinish(41)
    if isEndTeach41 ~= true and step41 < 4 and CacheCenter:getPlayerInfo().level == 9 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
    end
end

--@brief 点击购买道具确认按钮的响应函数
--@param  id:消息的id，nType:消息响应类型
function WndEquipmentLottery:onBuyGiftClick(id,nType)
    if nType == MSGBOXRESTYPE_CONFIRM then
        WZLog("WndEquipmentLottery:onBuyItemClick")
        WndPurchase:showBuyInterface(6,tonumber(self.m_tIds[4]),nil,nil,nil)
    end
end

--钻石抽奖
function WndEquipmentLottery:onClickDimondRafflt(element)
	WZLog("WndEquipmentLottery:onClickDimondRafflt")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	PostPlayerEvent:postEvent(PostPlayerEvent.event_nineLvClickHCall)

	local count =  CacheCenter:getRemainAmount()
	if count <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end

	if not self.m_bCanTouch then
		return
	end

	local fragmentCount =  CacheCenter:getPlayerItemCountById(self.m_tIds[1])
	if fragmentCount < tonumber(self.m_tNums[1]) then
		if self.isUseTicket == "0" then --使用双货币
			if not JudgeMoneyIsEnough(70, tonumber(self.m_tNums[2]), nil, nil, 151, nil, nil, nil, nil, self, self.clickSureInstead) then
		    	return
			end
		else --不使用双货币
			if not JudgeMoneyIsEnough(1, tonumber(self.m_tNums[2]), nil, nil, 151, nil, nil, nil, nil, self, self.clickSureInstead) then
		    	return
			end
		end
	end
	
	self:clickSureInstead()
end

--@brief    点击确定充值回调
function WndEquipmentLottery:clickSureInstead()
    self.m_bCanTouch = false
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    self.m_nRaffleType = 2
    self.m_nSummonTimeType = 2
	ProtocolProcessorWndEquipmentRaffle:send_EQUIP_Lottery(2)
	
	TeachGroup1:endTeachStep({41,5})
end

--钻石十连抽
function WndEquipmentLottery:onClickDiamondTen(element)
	WZLog("WndEquipmentLottery:onClickDiamondTen")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local count =  CacheCenter:getRemainAmount()
	if count <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end

	if not self.m_bCanTouch then
		return
	end
	if self.isUseTicket == "0" then
		if not JudgeMoneyIsEnough(70, tonumber(self.m_tNums[3]), nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
			return
		end
	else
		if not JudgeMoneyIsEnough(1, tonumber(self.m_tNums[3]), nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
			return
		end
	end

	self:sureUseDiamondInstead()
end

function WndEquipmentLottery:onClickExplain(element)
	-- body
	WZLog("WndEquipmentLottery:onClickExplain")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.EQUIPMENT_DRAW_EXPLAIN)
end

--@brief 	十连抽确认用钻石代替礼券
function WndEquipmentLottery:sureUseDiamondInstead()
	-- body
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	self.m_bCanTouch = false
	self.m_nRaffleType = 3
	ProtocolProcessorWndEquipmentRaffle:send_EQUIP_Lottery(3)
end

--关闭抽奖动画界面
function WndEquipmentLottery:onClickCloseRSE(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_bPlayingSpine then
		return
	end

    pushEquipInList()
    local isEndTeach41, step41 = TeachGroup1:isTeachFinish(41)
    WZLog("WndEquipmentLottery:onClickCloseRSE", tostring(GlobalGame.m_bIsShowEquipDressUp), isEndTeach41, step41)
    if isEndTeach41 ~= true and step41 < 5 and CacheCenter:getPlayerInfo().level == 9 and GlobalGame.m_bIsShowEquipDressUp ~= nil then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
    elseif isEndTeach41 ~= true and step41 < 4 and CacheCenter:getPlayerInfo().level == 9 and WndEquipmentLottery.m_root and GlobalGame.m_bIsShowEquipDressUp == nil then
        TeachGroup1:endTeachStep({41,3})
        TeachGroup1:startGroup({41,5,WndEquipmentLottery.m_root})
    elseif isEndTeach41 ~= true and step41 <= 5 and CacheCenter:getPlayerInfo().level == 9 and WndEquipmentLottery.m_root and GlobalGame.m_bIsShowEquipDressUp == nil then
        TeachGroup1:endTeachStep({41,5})
    end
    
    self.m_bTeachDraw = true

    local conRSEEE = GetElement(self.m_root,"conRSEEE_WndEquipmentLottery",WZUIContainer)
	conRSEEE:setVisible(false)

	local conRSE = GetElement(conRSEEE,"conRSE_WndEquipmentLottery",WZUIContainer)
	conRSE:setVisible(false)

    self:hideContainer()
	g_bIsShowWndDressUp = true
	
 --    local conMiddle = GetElement(self.m_root,"conMiddle_WndEquipmentLottery",WZUIContainer)
	-- conMiddle:setVisible(true)

	self.m_nRaffleType = 0
	self:resetFile()
end

function WndEquipmentLottery:hideContainer()
	WZLog("WndEquipmentLottery:hideContainer")
	local conRSEEE = GetElement(self.m_root,"conRSEEE_WndEquipmentLottery",WZUIContainer)

	local conRSE = GetElement(conRSEEE,"conRSE_WndEquipmentLottery",WZUIContainer)

	local conRaffleBg = GetElement(conRSE,"conRaffleBg_WndEquipmentLottery",WZUIContainer)
	conRaffleBg:setScaleY(0)
	conRaffleBg:setVisible(false)

	local conBottomBtn = GetElement(conRSE,"conBottomBtn_WndEquipmentLottery",WZUIContainer)
	conBottomBtn:setVisible(false)

	local conAnimationOne = GetElement(conRSE,"conAnimationOne_WndEquipmentLottery",WZUIContainer)
	conAnimationOne:setVisible(false)
	conAnimationOne:setScale(0)

	local conTenRaffle = GetElement(conRSE,"conTenRaffle_WndEquipmentLottery",WZUIContainer)
	conTenRaffle:setVisible(false)

	for i=1,10 do
		local img= GetElement(self.m_root,"img" .. i .. "_conTenRaffle",WZUIImage)
		img:setFile("")

		local con = GetElement(self.m_root,"con" .. i .. "_conTenRaffle",WZUIContainer)
		con:setScale(0)
	end

end

--免费抽取装备定时器
function WndEquipmentLottery:scheduleUpdateRaffleTime(element)
	self.m_nleaveTime = self.m_nleaveTime -1
	if self.m_nleaveTime <=0 then
		element:disableSchedule()
	end
	local leaveTime = self:formatTime(self.m_nleaveTime)
    local txtTime1 = GetElement(self.m_root,"txtTime1_WndEquipmentLottery",WZUILabelTTF)
    txtTime1:setText(leaveTime)
end


function WndEquipmentLottery:onTouchBegan(element)
	WZLog("WndEquipmentLottery:onTouchBegan")
	WndItemInfo:onCloseClick()
	if self.m_topCellLua then
		self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
	end
end

--@brief 	点击限时特惠礼包按钮回调
function WndEquipmentLottery:OpenNewUserPackage(element)
	--body
	OpenNewUserPackage(element)
end

--@brief 	点击前往装备按钮回调
function WndEquipmentLottery:onClickGotoEquip(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if WndBagMain.m_root then
		self.m_bIsCloseClick = true
    	-- WindowManager:removeWindow(self.m_root,self,true)
    	WndSummonEntrance:closeWin()
		return 
	end
	WndBagMain:showBeibao()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--适配iphoneX
function WndEquipmentLottery:_AdaptationIphoneX()
    -- body
    WZLog("WndEquipmentLottery:_AdaptationIphoneX")
    if IsIphoneX() then
		-- local conMidLeft = GetElement(self.m_root,"conMidLeft_WndEquipmentLottery",WZUIContainer)
		-- conMidLeft:setRelativePosition(GlobalMethod:ccp(0.0177083,0.757813))

		local btnGotoEquip = GetElement(self.m_root,"btnGotoEquip_WndEquipmentLottery",WZUIButton)
		btnGotoEquip:setRelativePosition(GlobalMethod:ccp(0.9,0.828))
		local btnEquipLibrary = GetElement(self.m_root,"btnEquipLibrary_WndEquipmentLottery",WZUIButton)
		btnEquipLibrary:setRelativePosition(GlobalMethod:ccp(0.9,0.696))
		local btnEquipStore = GetElement(self.m_root,"btnEquipStore_WndEquipmentLottery",WZUIButton)
		btnEquipStore:setRelativePosition(GlobalMethod:ccp(0.9,0.564))
		
		local btnExplain = GetElement(self.m_root,"btnExplain_WndEquipmentLottery",WZUIButton)
		btnExplain:setRelativePosition(GlobalMethod:ccp(0.9,0.4))
	end
end



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------
function WndEquipmentLottery:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtPurple1_WndEquipmentLottery",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txtPurple3_WndEquipmentLottery",WZUILabelTTF):setScale(0.8)

	local txtFreeLuckDraw = GetElement(self.m_root,"txtFreeLuckDraw_WndEquipmentLottery",WZUILabelTTF)
	txtFreeLuckDraw:setFontSize(20)
	txtFreeLuckDraw:setRelativePosition(ccp(0.79,0.5))
	txtFreeLuckDraw:setDimensions(GlobalMethod:CCSize(95))

	local txtDiamondTen = GetElement(self.m_root,"txtDiamondTen_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondTen:setScale(0.8)
	txtDiamondTen:setDimensions(GlobalMethod:CCSize(100))
	local txtDiamondTen2 = GetElement(self.m_root,"txtDiamondTen2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondTen2:setScale(0.8)
	txtDiamondTen2:setDimensions(GlobalMethod:CCSize(100))

	local txtF = GetElement(self.m_root,"txtF_WndEquipmentLottery",WZUILabelTTF)
	txtF:setScale(0.6)
	txtF:setRelativePosition(ccp(0.201827,0.5875))
	local raffle = GetElement(self.m_root,"txtRaffle_WndEquipmentLottery",WZUILabelTTF)
	raffle:setScale(0.6)
	raffle:setRelativePosition(ccp(0.38,0.5875))
	local ttf = GetElement(self.m_root,"txtT_WndEquipmentLottery",WZUILabelTTF)
	ttf:setScale(0.6)
	ttf:setRelativePosition(ccp(0.575413,0.5875))
	local purple = GetElement(self.m_root,"txtPurple2_WndEquipmentLottery",WZUILabelTTF)
	purple:setScale(0.6)
	purple:setRelativePosition(ccp(0.865,0.5875))
	
	local ProbabilityGet = GetElement(self.m_root,"ProbabilityGet_WndEquipmentLottery",WZUILabelTTF)
	ProbabilityGet:setScale(0.8)
	ProbabilityGet:setRelativePosition(GlobalMethod:ccp(0.345224,0.5875))

	local txtTenRaffle = GetElement(self.m_root,"txtTenRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtTenRaffle:setScale(0.7)
	txtTenRaffle:setRelativePosition(GlobalMethod:ccp(0.394281,0.5875))

	GetElement(self.m_root,"txtDiamondCount2_WndEquipmentLottery",WZUILabelTTF):setScale(0.7)

	local txtFragmentCount = GetElement(self.m_root,"txtFragmentCount_WndEquipmentLottery",WZUILabelTTF)
	txtFragmentCount:setScale(0.8)
	txtFragmentCount:setRelativePosition(GlobalMethod:ccp(0.53,0.5))

	local time = GetElement(self.m_root,"txtTime1_WndEquipmentLottery",WZUILabelTTF)
	time:setScale(0.8)
	time:setRelativePosition(ccp(0.29,0.0821609))

	local tip = GetElement(self.m_root,"txtTip1_WndEquipmentLottery",WZUILabelTTF)
	tip:setScale(0.8)
	tip:setRelativePosition(ccp(0.62,0.0821609))

	GetElement(self.m_root,"txt1_conTenRaffle",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txt2_conTenRaffle",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txt3_conTenRaffle",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txt4_conTenRaffle",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txt5_conTenRaffle",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txt6_conTenRaffle",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txt7_conTenRaffle",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txt8_conTenRaffle",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txt9_conTenRaffle",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txt10_conTenRaffle",WZUILabelTTF):setScale(0.6)

	GetElement(self.m_root,"txtEquipName_ConAnimation",WZUILabelTTF):setScale(0.8)

	local tff = GetElement(self.m_root,"txtFF_WndEquipmentLottery",WZUILabelTTF)
	tff:setScale(0.8)
	tff:setRelativePosition(ccp(0.5,0.5875))

	local txtDrawAgain = GetElement(self.m_root,"txtDrawAgain_WndEquipmentLottery",WZUILabelTTF)
	txtDrawAgain:setScale(0.7)
	txtDrawAgain:setDimensions(GlobalMethod:CCSize(180))

	GetElement(self.m_root,"imgVertical1_WndEquipmentLottery",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.54,0.5))
	GetElement(self.m_root,"imgVertical2_WndEquipmentLottery",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.6,0.5))
	GetElement(self.m_root,"imgVertical3_WndEquipmentLottery",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.6,0.5))

	local freeTextTip2 = GetElement(self.m_root,"freeTextTip2_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip2:setMaxWidth(400)
	freeTextTip2:setScale(0.8)
	local freeTextTip3 = GetElement(self.m_root,"freeTextTip3_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip3:setMaxWidth(400)
	freeTextTip3:setScale(0.8)

	local txtReplaceRaffleTip = GetElement(self.m_root,"txtReplaceRaffleTip_WndEquipmentLottery",WZUILabelTTF)
	txtReplaceRaffleTip:setScale(0.8)
	txtReplaceRaffleTip:setDimensions(GlobalMethod:CCSize(180))
	local txtGiveMore = GetElement(self.m_root,"txtGiveMore_WndEquipmentLottery",WZUILabelTTF)
	txtGiveMore:setScale(0.8)
	txtGiveMore:setDimensions(GlobalMethod:CCSize(200))

	local txtDiamondCount = GetElement(self.m_root,"txtDiamondCount_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount:setScale(0.6)
	txtDiamondCount:setDimensions(GlobalMethod:CCSize(80))
	txtDiamondCount:setRelativePosition(GlobalMethod:ccp(0.35,0.5))
	local txtDiamondCount2 = GetElement(self.m_root,"txtDiamondCount2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount2:setScale(0.6)
	txtDiamondCount2:setDimensions(GlobalMethod:CCSize(80))
	txtDiamondCount2:setRelativePosition(GlobalMethod:ccp(0.35,0.5))

	GetElement(self.m_root,"txtGotoEquip_WndEquipmentLottery",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"imgBtn21_WndEquipmentLottery",WZUIImage):setScale(0.8)
	GetElement(self.m_root,"imgBtn22_WndEquipmentLottery",WZUIImage):setScale(0.8)
end

function WndEquipmentLottery:_adaptLanguage_pt(  )
	local ProbabilityGet = GetElement(self.m_root,"ProbabilityGet_WndEquipmentLottery",WZUILabelTTF)
	ProbabilityGet:setScale(0.5)
	local txtPurple1 = GetElement(self.m_root,"txtPurple1_WndEquipmentLottery",WZUILabelTTF)
	txtPurple1:setScale(0.6)
	txtPurple1:setRelativePosition(GlobalMethod:ccp(0.864859,0.5875))
	local txtTenRaffle = GetElement(self.m_root,"txtTenRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtTenRaffle:setScale(0.7)
	txtTenRaffle:setRelativePosition(GlobalMethod:ccp(0.394281,0.5875))

	local txtFreeLuckDraw = GetElement(self.m_root,"txtFreeLuckDraw_WndEquipmentLottery",WZUILabelTTF)
	txtFreeLuckDraw:setFontSize(16)
	txtFreeLuckDraw:setRelativePosition(ccp(0.77,0.5))
	txtFreeLuckDraw:setDimensions(GlobalMethod:CCSize(90))
	local txtDiamondTen = GetElement(self.m_root,"txtDiamondTen_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondTen:setFontSize(16)
	txtDiamondTen:setRelativePosition(ccp(0.77,0.5))
	txtDiamondTen:setDimensions(GlobalMethod:CCSize(80))
	local txtDiamondTen2 = GetElement(self.m_root,"txtDiamondTen2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondTen2:setFontSize(16)
	txtDiamondTen2:setRelativePosition(ccp(0.77,0.5))
	txtDiamondTen2:setDimensions(GlobalMethod:CCSize(80))

	local txtF = GetElement(self.m_root,"txtF_WndEquipmentLottery",WZUILabelTTF)
	txtF:setScale(0.5)
	txtF:setRelativePosition(GlobalMethod:ccp(0.126355,0.5875))
	local txtRaffle = GetElement(self.m_root,"txtRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtRaffle:setScale(0.5)
	txtRaffle:setRelativePosition(GlobalMethod:ccp(0.198054,0.5875))
	local txtT = GetElement(self.m_root,"txtT_WndEquipmentLottery",WZUILabelTTF)
	txtT:setScale(0.5)
	txtT:setRelativePosition(GlobalMethod:ccp(0.526356,0.5875))
	local purple = GetElement(self.m_root,"txtPurple2_WndEquipmentLottery",WZUILabelTTF)
	purple:setScale(0.5)
	purple:setRelativePosition(GlobalMethod:ccp(0.883726,0.5875))
	local tff = GetElement(self.m_root,"txtFF_WndEquipmentLottery",WZUILabelTTF)
	tff:setScale(0.7)
	tff:setRelativePosition(ccp(0.5,0.5875))

	GetElement(self.m_root,"txtFragmentCount_WndEquipmentLottery",WZUILabelTTF):setScale(0.7)

	local txtTime1 = GetElement(self.m_root,"txtTime1_WndEquipmentLottery",WZUILabelTTF)
	txtTime1:setRelativePosition(GlobalMethod:ccp(0.415038,0.0821609))
	local txtTip1 = GetElement(self.m_root,"txtTip1_WndEquipmentLottery",WZUILabelTTF)
	txtTip1:setScale(0.8)
	txtTip1:setDimensions(GlobalMethod:CCSize(140))
	txtTip1:setRelativePosition(GlobalMethod:ccp(0.697008,0.0821609))

	local txtDiamondCount = GetElement(self.m_root,"txtDiamondCount_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount:setScale(0.6)
	txtDiamondCount:setDimensions(GlobalMethod:CCSize(80))
	txtDiamondCount:setRelativePosition(GlobalMethod:ccp(0.35,0.5))
	local txtDiamondCount2 = GetElement(self.m_root,"txtDiamondCount2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount2:setScale(0.6)
	txtDiamondCount2:setDimensions(GlobalMethod:CCSize(80))
	txtDiamondCount2:setRelativePosition(GlobalMethod:ccp(0.35,0.5))

	local freeTextTip2 = GetElement(self.m_root,"freeTextTip2_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip2:setMaxWidth(400)
	freeTextTip2:setScale(0.8)
	local freeTextTip3 = GetElement(self.m_root,"freeTextTip3_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip3:setMaxWidth(400)
	freeTextTip3:setScale(0.8)

	local txtReplaceRaffleTip = GetElement(self.m_root,"txtReplaceRaffleTip_WndEquipmentLottery",WZUILabelTTF)
	txtReplaceRaffleTip:setScale(0.8)
	txtReplaceRaffleTip:setDimensions(GlobalMethod:CCSize(180))
	local txtGiveMore = GetElement(self.m_root,"txtGiveMore_WndEquipmentLottery",WZUILabelTTF)
	txtGiveMore:setScale(0.8)
	txtGiveMore:setDimensions(GlobalMethod:CCSize(200))

	local txtDrawAgain = GetElement(self.m_root,"txtDrawAgain_WndEquipmentLottery",WZUILabelTTF)
	txtDrawAgain:setScale(0.7)
	txtDrawAgain:setDimensions(GlobalMethod:CCSize(180))
end

function WndEquipmentLottery:_adaptLanguage_vn()
	GetElement(self.m_root,"txtPurple1_WndEquipmentLottery",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtPurple2_WndEquipmentLottery",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtPurple3_WndEquipmentLottery",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"imgFaffle1_WndEquipmentLottery",WZUIImage):setScale(0.6)
	GetElement(self.m_root,"imgFaffle2_WndEquipmentLottery",WZUIImage):setScale(0.6)
	GetElement(self.m_root,"imgFaffle3_WndEquipmentLottery",WZUIImage):setScale(0.6)
	
	
	local ProbabilityGet = GetElement(self.m_root,"ProbabilityGet_WndEquipmentLottery",WZUILabelTTF)
	ProbabilityGet:setScale(0.8)
	ProbabilityGet:setRelativePosition(GlobalMethod:ccp(0.33013,0.5875))
	GetElement(self.m_root,"txtFragmentCount_WndEquipmentLottery",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.57,0.5))
	local txtTime1 = GetElement(self.m_root,"txtTime1_WndEquipmentLottery",WZUILabelTTF)
	txtTime1:setRelativePosition(GlobalMethod:ccp(0.43,0.23))

	local txtFreeLuckDraw = GetElement(self.m_root,"txtFreeLuckDraw_WndEquipmentLottery",WZUILabelTTF)
    txtFreeLuckDraw:setRelativePosition(GlobalMethod:ccp(0.778869,0.5))

	local txtF = GetElement(self.m_root,"txtF_WndEquipmentLottery",WZUILabelTTF)
	txtF:setScale(0.8)
	txtF:setRelativePosition(GlobalMethod:ccp(0.167865,0.5875))
	local txtRaffle = GetElement(self.m_root,"txtRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtRaffle:setScale(0.8)
	txtRaffle:setRelativePosition(GlobalMethod:ccp(0.31,0.5875))
	local txtT = GetElement(self.m_root,"txtT_WndEquipmentLottery",WZUILabelTTF)
	txtT:setScale(0.8)
	txtT:setRelativePosition(GlobalMethod:ccp(0.473526,0.5875))
	local txtFF = GetElement(self.m_root,"txtFF_WndEquipmentLottery",WZUILabelTTF)
	txtFF:setScale(0.55)
	txtFF:setRelativePosition(GlobalMethod:ccp(0.367866,0.5875))

	GetElement(self.m_root,"txtReplaceRaffleTip_WndEquipmentLottery",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtGiveMore_WndEquipmentLottery",WZUILabelTTF):setScale(0.75)

	GetElement(self.m_root,"txtDiamondCount_WndEquipmentLottery",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtDiamondCount2_WndEquipmentLottery",WZUILabelTTF):setScale(0.7)

	local freeTextTip3 = GetElement(self.m_root,"freeTextTip3_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip3:setMaxWidth(400)

	GetElement(self.m_root,"txtGotoEquip_WndEquipmentLottery",WZUILabelTTF):setScale(0.8)
	
end

function WndEquipmentLottery:_adaptLanguage_th()
	WZLog("WndEquipmentLottery:_adaptLanguage_th")
	local conMiddle = GetElement(self.m_root,"conMiddle_WndEquipmentLottery",WZUIContainer)

	local txtPurple1 = GetElement(conMiddle,"txtPurple1_WndEquipmentLottery",WZUILabelTTF)
	txtPurple1:setFontSize(24)

	local ProbabilityGet = GetElement(self.m_root,"ProbabilityGet_WndEquipmentLottery",WZUILabelTTF)
	ProbabilityGet:setScale(0.8)
	ProbabilityGet:setRelativePosition(GlobalMethod:ccp(0.345224,0.5875))

	local txtFF = GetElement(conMiddle,"txtFF_WndEquipmentLottery",WZUILabelTTF)
	txtFF:setScale(0.8)
	local txtF = GetElement(self.m_root,"txtF_WndEquipmentLottery",WZUILabelTTF)
	txtF:setScale(0.7)
	txtF:setRelativePosition(GlobalMethod:ccp(0.198053,0.5875))
	local txtRaffle = GetElement(conMiddle,"txtRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtRaffle:setScale(0.7)
	txtRaffle:setRelativePosition(GlobalMethod:ccp(0.34145,0.5875))
	local txtT = GetElement(conMiddle,"txtT_WndEquipmentLottery",WZUILabelTTF)
	txtT:setScale(0.7)
	txtT:setRelativePosition(GlobalMethod:ccp(0.515035,0.5875))

	local txtTenRaffle = GetElement(conMiddle,"txtTenRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtTenRaffle:setScale(0.8)
	txtTenRaffle:setRelativePosition(GlobalMethod:ccp(0.394281,0.5875))

	GetElement(self.m_root,"txtReplaceRaffleTip_WndEquipmentLottery",WZUILabelTTF):setScale(0.8)

	local freeTextTip2 = GetElement(self.m_root,"freeTextTip2_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip2:setMaxWidth(400)
	freeTextTip2:setScale(0.8)
	local freeTextTip3 = GetElement(self.m_root,"freeTextTip3_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip3:setMaxWidth(400)
	freeTextTip3:setScale(0.8)

	GetElement(self.m_root,"txt1_conTenRaffle",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt2_conTenRaffle",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt3_conTenRaffle",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt4_conTenRaffle",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt5_conTenRaffle",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt6_conTenRaffle",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt7_conTenRaffle",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt8_conTenRaffle",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt9_conTenRaffle",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt10_conTenRaffle",WZUILabelTTF):setScale(0.8)

	local txtDiamondCount = GetElement(self.m_root,"txtDiamondCount_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount:setScale(0.7)
	txtDiamondCount:setDimensions(GlobalMethod:CCSize(100))
	-- txtDiamondCount:setRelativePosition(GlobalMethod:ccp(0.521726,0.5))
	--local imgFaffle2 = GetElement(self.m_root, "imgFaffle2_WndEquipmentLottery", WZUIImage)
	--imgFaffle2:setScale(0.5)
	--imgFaffle2:setRelativePosition(GlobalMethod:ccp(0.615029,0.516667))
	--GetElement(self.m_root,"imgVertical2_WndEquipmentLottery",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.726488,0.5))
	-- local txtDiamondTen = GetElement(self.m_root,"txtDiamondTen_WndEquipmentLottery",WZUILabelTTF)
	-- txtDiamondTen:setRelativePosition(GlobalMethod:ccp(0.855059,0.5))

	local txtDiamondCount2 = GetElement(self.m_root,"txtDiamondCount2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount2:setScale(0.7)
	txtDiamondCount2:setRelativePosition(GlobalMethod:ccp(0.521726,0.5))
	txtDiamondCount2:setDimensions(GlobalMethod:CCSize(100))	
	local imgFaffle3 = GetElement(self.m_root, "imgFaffle3_WndEquipmentLottery", WZUIImage)
	imgFaffle3:setScale(0.5)
	imgFaffle3:setRelativePosition(GlobalMethod:ccp(0.615029,0.516667))
	GetElement(self.m_root,"imgVertical3_WndEquipmentLottery",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.726488,0.5))
	local txtDiamondTen2 = GetElement(self.m_root,"txtDiamondTen2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondTen2:setRelativePosition(GlobalMethod:ccp(0.855059,0.5))
end

function WndEquipmentLottery:_adaptLanguage_tr()
	GetElement(self.m_root,"txtFragmentCount_WndEquipmentLottery",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.621577,0.5))
	GetElement(self.m_root,"imgVertical1_WndEquipmentLottery",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.640774,0.5))
	GetElement(self.m_root,"txtFreeLuckDraw_WndEquipmentLottery",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.797916,0.5))
	local txtDiamondCount = GetElement(self.m_root,"txtDiamondCount_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount:setScale(0.8)
	txtDiamondCount:setDimensions(GlobalMethod:CCSize(120))
	txtDiamondCount:setRelativePosition(GlobalMethod:ccp(0.42,0.5))
	local txtDiamondCount2 = GetElement(self.m_root,"txtDiamondCount2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount2:setScale(0.8)
	txtDiamondCount2:setDimensions(GlobalMethod:CCSize(120))
	txtDiamondCount2:setRelativePosition(GlobalMethod:ccp(0.42,0.5))

	local txtTime1 = GetElement(self.m_root,"txtTime1_WndEquipmentLottery",WZUILabelTTF)
	txtTime1:setScale(0.7)
	txtTime1:setRelativePosition(GlobalMethod:ccp(0.363755,0.0821609))
	local txtTip1 = GetElement(self.m_root,"txtTip1_WndEquipmentLottery",WZUILabelTTF)
	txtTip1:setScale(0.7)
	txtTip1:setDimensions(GlobalMethod:CCSize(200))
	txtTip1:setRelativePosition(GlobalMethod:ccp(0.671367,0.0821609))

	GetElement(self.m_root,"txtReplaceRaffleTip_WndEquipmentLottery",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(140))
	GetElement(self.m_root,"txtGiveMore_WndEquipmentLottery",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(140))

	local txtF = GetElement(self.m_root,"txtF_WndEquipmentLottery",WZUILabelTTF)
	txtF:setScale(0.7)
	txtF:setRelativePosition(GlobalMethod:ccp(0.288619,0.5875))
	local txtRaffle = GetElement(self.m_root,"txtRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtRaffle:setScale(0.7)
	txtRaffle:setRelativePosition(GlobalMethod:ccp(0.530129,0.5875))
	local txtT = GetElement(self.m_root,"txtT_WndEquipmentLottery",WZUILabelTTF)
	txtT:setScale(0.7)
	txtT:setRelativePosition(GlobalMethod:ccp(0.63579,0.5875))
	local txtFF = GetElement(self.m_root,"txtFF_WndEquipmentLottery",WZUILabelTTF)

	local txtTenRaffle = GetElement(self.m_root,"txtTenRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtTenRaffle:setScale(0.8)
	txtTenRaffle:setRelativePosition(GlobalMethod:ccp(0.379186,0.5875))

	local txtDrawAgain = GetElement(self.m_root,"txtDrawAgain_WndEquipmentLottery",WZUILabelTTF)
	txtDrawAgain:setScale(0.7)
	txtDrawAgain:setDimensions(GlobalMethod:CCSize(180))

	local freeTextTip2 = GetElement(self.m_root,"freeTextTip2_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip2:setMaxWidth(400)
	freeTextTip2:setScale(0.8)
	local freeTextTip3 = GetElement(self.m_root,"freeTextTip3_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip3:setMaxWidth(400)
	freeTextTip3:setScale(0.8)

	GetElement(self.m_root,"imgBtn21_WndEquipmentLottery",WZUIImage):setScale(0.6)
	GetElement(self.m_root,"imgBtn22_WndEquipmentLottery",WZUIImage):setScale(0.6)

	GetElement(self.m_root,"txtGotoEquip_WndEquipmentLottery",WZUILabelTTF):setScale(0.7)
	
end

function WndEquipmentLottery:_adaptLanguage_es(  )
	local ProbabilityGet = GetElement(self.m_root,"ProbabilityGet_WndEquipmentLottery",WZUILabelTTF)
	ProbabilityGet:setScale(0.5)
	local txtPurple1 = GetElement(self.m_root,"txtPurple1_WndEquipmentLottery",WZUILabelTTF)
	txtPurple1:setScale(0.6)
	txtPurple1:setRelativePosition(GlobalMethod:ccp(0.864859,0.5875))
	local txtTenRaffle = GetElement(self.m_root,"txtTenRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtTenRaffle:setScale(0.45)
	txtTenRaffle:setRelativePosition(GlobalMethod:ccp(0.379186,0.5875))

	local txtFreeLuckDraw = GetElement(self.m_root,"txtFreeLuckDraw_WndEquipmentLottery",WZUILabelTTF)
	txtFreeLuckDraw:setFontSize(16)
	txtFreeLuckDraw:setRelativePosition(ccp(0.77,0.5))
	txtFreeLuckDraw:setDimensions(GlobalMethod:CCSize(90))
	local txtDiamondTen = GetElement(self.m_root,"txtDiamondTen_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondTen:setFontSize(16)
	txtDiamondTen:setRelativePosition(ccp(0.77,0.5))
	txtDiamondTen:setDimensions(GlobalMethod:CCSize(80))
	local txtDiamondTen2 = GetElement(self.m_root,"txtDiamondTen2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondTen2:setFontSize(16)
	txtDiamondTen2:setRelativePosition(ccp(0.77,0.5))
	txtDiamondTen2:setDimensions(GlobalMethod:CCSize(80))

	local txtF = GetElement(self.m_root,"txtF_WndEquipmentLottery",WZUILabelTTF)
	txtF:setScale(0.5)
	txtF:setRelativePosition(GlobalMethod:ccp(0.239563,0.5875))
	local txtRaffle = GetElement(self.m_root,"txtRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtRaffle:setScale(0.5)
	txtRaffle:setRelativePosition(GlobalMethod:ccp(0.450884,0.5875))
	local txtT = GetElement(self.m_root,"txtT_WndEquipmentLottery",WZUILabelTTF)
	txtT:setScale(0.5)
	txtT:setRelativePosition(GlobalMethod:ccp(0.643337,0.5875))
	local purple = GetElement(self.m_root,"txtPurple2_WndEquipmentLottery",WZUILabelTTF)
	purple:setScale(0.5)
	purple:setRelativePosition(GlobalMethod:ccp(0.891274,0.5875))
	local tff = GetElement(self.m_root,"txtFF_WndEquipmentLottery",WZUILabelTTF)
	tff:setScale(0.7)
	tff:setRelativePosition(ccp(0.5,0.5875))

	GetElement(self.m_root,"txtFragmentCount_WndEquipmentLottery",WZUILabelTTF):setScale(0.7)
	local txtTenRaffle = GetElement(self.m_root,"txtTenRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtTenRaffle:setScale(0.8)
	txtTenRaffle:setRelativePosition(GlobalMethod:ccp(0.379186,0.5875))

	local txtDrawAgain = GetElement(self.m_root,"txtDrawAgain_WndEquipmentLottery",WZUILabelTTF)
	txtDrawAgain:setScale(0.7)
	txtDrawAgain:setDimensions(GlobalMethod:CCSize(180))
	local txtTime1 = GetElement(self.m_root,"txtTime1_WndEquipmentLottery",WZUILabelTTF)
	txtTime1:setRelativePosition(GlobalMethod:ccp(0.415038,0.0821609))
	local txtTip1 = GetElement(self.m_root,"txtTip1_WndEquipmentLottery",WZUILabelTTF)
	txtTip1:setScale(0.8)
	txtTip1:setDimensions(GlobalMethod:CCSize(140))
	txtTip1:setRelativePosition(GlobalMethod:ccp(0.697008,0.0821609))

	local txtDiamondCount = GetElement(self.m_root,"txtDiamondCount_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount:setScale(0.6)
	txtDiamondCount:setDimensions(GlobalMethod:CCSize(80))
	txtDiamondCount:setRelativePosition(GlobalMethod:ccp(0.35,0.5))
	local txtDiamondCount2 = GetElement(self.m_root,"txtDiamondCount2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount2:setScale(0.6)
	txtDiamondCount2:setDimensions(GlobalMethod:CCSize(80))
	txtDiamondCount2:setRelativePosition(GlobalMethod:ccp(0.35,0.5))
	local freeTextTip2 = GetElement(self.m_root,"freeTextTip2_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip2:setMaxWidth(400)
	freeTextTip2:setScale(0.8)
	local freeTextTip3 = GetElement(self.m_root,"freeTextTip3_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip3:setMaxWidth(400)
	freeTextTip3:setScale(0.8)

	GetElement(self.m_root,"imgBtn21_WndEquipmentLottery",WZUIImage):setScale(0.6)
	GetElement(self.m_root,"imgBtn22_WndEquipmentLottery",WZUIImage):setScale(0.6)
	local freeTextTip2 = GetElement(self.m_root,"freeTextTip2_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip2:setMaxWidth(400)
	freeTextTip2:setScale(0.8)
	local freeTextTip3 = GetElement(self.m_root,"freeTextTip3_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip3:setMaxWidth(400)
	freeTextTip3:setScale(0.8)

	local txtReplaceRaffleTip = GetElement(self.m_root,"txtReplaceRaffleTip_WndEquipmentLottery",WZUILabelTTF)
	txtReplaceRaffleTip:setScale(0.8)
	txtReplaceRaffleTip:setDimensions(GlobalMethod:CCSize(180))
	local txtGiveMore = GetElement(self.m_root,"txtGiveMore_WndEquipmentLottery",WZUILabelTTF)
	txtGiveMore:setScale(0.8)
	txtGiveMore:setDimensions(GlobalMethod:CCSize(200))

	local txtDrawAgain = GetElement(self.m_root,"txtDrawAgain_WndEquipmentLottery",WZUILabelTTF)
	txtDrawAgain:setScale(0.7)
	txtDrawAgain:setDimensions(GlobalMethod:CCSize(180))

	GetElement(self.m_root,"imgBtn21_WndEquipmentLottery",WZUIImage):setScale(0.7)
	GetElement(self.m_root,"imgBtn22_WndEquipmentLottery",WZUIImage):setScale(0.7)
end

function WndEquipmentLottery:_adaptLanguage_ug(  )
	local ProbabilityGet = GetElement(self.m_root,"ProbabilityGet_WndEquipmentLottery",WZUILabelTTF)
	ProbabilityGet:setScale(0.5)
	ProbabilityGet:setDimensions(GlobalMethod:CCSize(300))
	local txtPurple1 = GetElement(self.m_root,"txtPurple1_WndEquipmentLottery",WZUILabelTTF)
	txtPurple1:setScale(0.6)
	txtPurple1:setRelativePosition(GlobalMethod:ccp(0.864859,0.5875))
	local txtTenRaffle = GetElement(self.m_root,"txtTenRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtTenRaffle:setScale(0.45)
	txtTenRaffle:setRelativePosition(GlobalMethod:ccp(0.379186,0.5875))

	local txtFreeLuckDraw = GetElement(self.m_root,"txtFreeLuckDraw_WndEquipmentLottery",WZUILabelTTF)
	txtFreeLuckDraw:setFontSize(16)
	txtFreeLuckDraw:setRelativePosition(ccp(0.77,0.5))
	txtFreeLuckDraw:setDimensions(GlobalMethod:CCSize(90))
	local txtDiamondTen = GetElement(self.m_root,"txtDiamondTen_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondTen:setFontSize(16)
	txtDiamondTen:setRelativePosition(ccp(0.77,0.5))
	txtDiamondTen:setDimensions(GlobalMethod:CCSize(80))
	local txtDiamondTen2 = GetElement(self.m_root,"txtDiamondTen2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondTen2:setFontSize(16)
	txtDiamondTen2:setRelativePosition(ccp(0.77,0.5))
	txtDiamondTen2:setDimensions(GlobalMethod:CCSize(80))

	local txtF = GetElement(self.m_root,"txtF_WndEquipmentLottery",WZUILabelTTF)
	txtF:setScale(0.5)
	txtF:setDimensions(GlobalMethod:CCSize(110))
	txtF:setRelativePosition(GlobalMethod:ccp(0.590507,0.5875))
	local txtRaffle = GetElement(self.m_root,"txtRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtRaffle:setScale(0.5)
	txtRaffle:setRelativePosition(GlobalMethod:ccp(0.450884,0.5875))
	local txtT = GetElement(self.m_root,"txtT_WndEquipmentLottery",WZUILabelTTF)
	txtT:setScale(0.5)
	txtT:setRelativePosition(GlobalMethod:ccp(0.643337,0.5875))
	local purple = GetElement(self.m_root,"txtPurple2_WndEquipmentLottery",WZUILabelTTF)
	purple:setScale(0.5)
	purple:setRelativePosition(GlobalMethod:ccp(0.891274,0.5875))
	local tff = GetElement(self.m_root,"txtFF_WndEquipmentLottery",WZUILabelTTF)
	tff:setScale(0.7)
	tff:setRelativePosition(ccp(0.5,0.5875))

	local txtPurple2 = GetElement(self.m_root,"txtPurple2_WndEquipmentLottery",WZUILabelTTF)
	txtPurple2:setScale(0.5)
	txtPurple2:setDimensions(GlobalMethod:CCSize(110))
	txtPurple2:setRelativePosition(GlobalMethod:ccp(0.796934,0.5875))

	local txtTenRaffle = GetElement(self.m_root,"txtTenRaffle_WndEquipmentLottery",WZUILabelTTF)
	txtTenRaffle:setScale(0.5)
	txtTenRaffle:setDimensions(GlobalMethod:CCSize(300))
	txtTenRaffle:setRelativePosition(GlobalMethod:ccp(0.390507,0.5875))
	local txtPurple3 = GetElement(self.m_root,"txtPurple3_WndEquipmentLottery",WZUILabelTTF)
	txtPurple3:setScale(0.5)
	txtPurple3:setDimensions(GlobalMethod:CCSize(110))
	txtPurple3:setRelativePosition(GlobalMethod:ccp(0.845991,0.5875))

	local txtDiamondCount = GetElement(self.m_root,"txtDiamondCount_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount:setScale(0.6)
	txtDiamondCount:setDimensions(GlobalMethod:CCSize(80))
	txtDiamondCount:setRelativePosition(GlobalMethod:ccp(0.35,0.5))
	local txtDiamondCount2 = GetElement(self.m_root,"txtDiamondCount2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount2:setScale(0.6)
	txtDiamondCount2:setDimensions(GlobalMethod:CCSize(80))
	txtDiamondCount2:setRelativePosition(GlobalMethod:ccp(0.35,0.5))

	local freeTextTip2 = GetElement(self.m_root,"freeTextTip2_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip2:setMaxWidth(400)
	freeTextTip2:setScale(0.8)
	local freeTextTip3 = GetElement(self.m_root,"freeTextTip3_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip3:setMaxWidth(400)
	freeTextTip3:setScale(0.8)

	local txtReplaceRaffleTip = GetElement(self.m_root,"txtReplaceRaffleTip_WndEquipmentLottery",WZUILabelTTF)
	txtReplaceRaffleTip:setScale(0.8)
	txtReplaceRaffleTip:setDimensions(GlobalMethod:CCSize(180))
	local txtGiveMore = GetElement(self.m_root,"txtGiveMore_WndEquipmentLottery",WZUILabelTTF)
	txtGiveMore:setScale(0.8)
	txtGiveMore:setDimensions(GlobalMethod:CCSize(200))

	local txtTime1 = GetElement(self.m_root,"txtTime1_WndEquipmentLottery",WZUILabelTTF)
	txtTime1:setScale(0.8)
	txtTime1:setRelativePosition(GlobalMethod:ccp(0.333841,0.0821609))
	local txtTip1 = GetElement(self.m_root,"txtTip1_WndEquipmentLottery",WZUILabelTTF)
	txtTip1:setScale(0.8)
	txtTip1:setRelativePosition(GlobalMethod:ccp(0.654273,0.0821609))

	local txtDiamondCount = GetElement(self.m_root,"txtDiamondCount_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount:setScale(0.7)
	txtDiamondCount:setDimensions(GlobalMethod:CCSize(130))
	txtDiamondCount:setRelativePosition(GlobalMethod:ccp(0.459822,0.5))
	local imgFaffle2 = GetElement(self.m_root, "imgFaffle2_WndEquipmentLottery", WZUIImage)
	imgFaffle2:setRelativePosition(GlobalMethod:ccp(0.534077,0.516667))
	local imgVertical2 = GetElement(self.m_root, "imgVertical2_WndEquipmentLottery", WZUIImage)
	imgVertical2:setRelativePosition(GlobalMethod:ccp(0.621727,0.525))
	local txtDiamondTen = GetElement(self.m_root,"txtDiamondTen_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondTen:setScale(0.8)
	txtDiamondTen:setDimensions(GlobalMethod:CCSize(90))
	txtDiamondTen:setRelativePosition(GlobalMethod:ccp(0.797917,0.5))
	local txtReplaceRaffleTip = GetElement(self.m_root,"txtReplaceRaffleTip_WndEquipmentLottery",WZUILabelTTF)
	txtReplaceRaffleTip:setScale(0.7)
	txtReplaceRaffleTip:setDimensions(GlobalMethod:CCSize(200))

	local txtDiamondCount = GetElement(self.m_root,"txtDiamondCount2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondCount:setScale(0.7)
	txtDiamondCount:setDimensions(GlobalMethod:CCSize(130))
	txtDiamondCount:setRelativePosition(GlobalMethod:ccp(0.459822,0.5))
	local imgFaffle3 = GetElement(self.m_root, "imgFaffle3_WndEquipmentLottery", WZUIImage)
	imgFaffle3:setRelativePosition(GlobalMethod:ccp(0.538839,0.516667))
	local imgVertical3 = GetElement(self.m_root, "imgVertical3_WndEquipmentLottery", WZUIImage)
	imgVertical3:setRelativePosition(GlobalMethod:ccp(0.626488,0.5))
	local txtDiamondTen2 = GetElement(self.m_root,"txtDiamondTen2_WndEquipmentLottery",WZUILabelTTF)
	txtDiamondTen2:setScale(0.8)
	txtDiamondTen2:setRelativePosition(GlobalMethod:ccp(0.80744,0.5))
	local txtReplaceRaffleTip = GetElement(self.m_root,"txtReplaceRaffleTip_WndEquipmentLottery",WZUILabelTTF)
	txtReplaceRaffleTip:setScale(0.7)
	txtReplaceRaffleTip:setDimensions(GlobalMethod:CCSize(200))
	local txtGiveMore = GetElement(self.m_root,"txtGiveMore_WndEquipmentLottery",WZUILabelTTF)
	txtGiveMore:setScale(0.7)
	txtGiveMore:setDimensions(GlobalMethod:CCSize(220))
	txtGiveMore:setRelativePosition(GlobalMethod:ccp(0.361649,0.45))

	local freeTextTip2 = GetElement(self.m_root,"freeTextTip2_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip2:setMaxWidth(400)
	freeTextTip2:setScale(0.7)
	local freeTextTip3 = GetElement(self.m_root,"freeTextTip3_WndEquipmentLottery",WZUIFreeTextBox)
	freeTextTip3:setMaxWidth(400)
	freeTextTip3:setScale(0.7)

	local txtDrawAgain = GetElement(self.m_root,"txtDrawAgain_WndEquipmentLottery",WZUILabelTTF)
	txtDrawAgain:setScale(0.7)
	txtDrawAgain:setDimensions(GlobalMethod:CCSize(180))
	local txtConfirm1 = GetElement(self.m_root,"txtConfirm1_WndEquipmentLottery",WZUILabelTTF)
	txtConfirm1:setScale(0.7)
	txtConfirm1:setDimensions(GlobalMethod:CCSize(180))
	local txtConfirm2 = GetElement(self.m_root,"txtConfirm2_WndEquipmentLottery",WZUILabelTTF)
	txtConfirm2:setScale(0.7)
	txtConfirm2:setDimensions(GlobalMethod:CCSize(180))
end



--适配iphoneX
function WndEquipmentLottery:_AdaptationIphoneX()
    -- body
    WZLog("WndEquipmentLottery:_AdaptationIphoneX")
    if IsIphoneX() then
		local conMidLeft = GetElement(self.m_root,"conMidLeft_WndEquipmentLottery",WZUIContainer)
		conMidLeft:setRelativePosition(GlobalMethod:ccp(0.0177083,0.757813))

		local btnExplain = GetElement(self.m_root,"btnExplain_WndEquipmentLottery",WZUIButton)
		btnExplain:setRelativePosition(GlobalMethod:ccp(0.976917,0.015625))
	end
end
-------------------------------------语言适配End----------------------------------------
