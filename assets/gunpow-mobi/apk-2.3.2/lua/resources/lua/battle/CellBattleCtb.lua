--CellBattleCtb.lua
--@brief	CellBattleCtb的数据模块
--@date		2015/04/17
--@author	Zjh


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBattleCtb:onEnter(element)
	self.m_root = WZUIContainer:luaTo(element)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBattleCtb:onExit(element)
	self:_unInit()
end

--@brief	获取表节点
--@return	element:表绑定的UI节点引用
function CellBattleCtb:getRoot()
	return self.m_root
end

--return CharacterType.TYPE_HERO / CharacterType.TYPE_GUAI
function CellBattleCtb:getCharacterType()
	return self.m_tCharacter:getType()
end

--@brief	设置CellBattleCtb所属对象
--@param	tCharacter:对象表
--@note
function CellBattleCtb:setCharacter(tCharacter)
	self.m_tCharacter = tCharacter
	self.m_nCharacterId = tCharacter:getBattleId()
	if self:getRoot() then
		if self:getCharacterType() == CharacterType.TYPE_HERO or self.m_tCharacter.m_bIsGuaiWithSuit == true then

            local img = GetElement(self:getRoot(),"imgFigure2_CellBattleCtb",WZUIImage)
            local head,headObj = CellHead:show(img,GDatatab_item[tCharacter.m_tSuitInfo.head].id,GDatatab_item[tCharacter.m_tSuitInfo.face].id,tCharacter.m_nBoyOrGirl,nil,{x=0.5, y=0.3},nil,tCharacter.m_tSuitInfo.colour)
			head:setScale(0.54)

            self.m_tHeadAnim = headObj
		else
            local head = GetElement(self:getRoot(),"imgFigure_CellBattleCtb",WZUIImage)
			head:setFile(self.m_tCharacter:getHeadAnimation())
            head:setScale(0.34)
		end
	
		self:updateTeamColor()
	end

	if tCharacter.m_bIsCaptain then
		local captain = GetElement(self:getRoot(),"imgFigureCaptain_CellBattleCtb",WZUIImage)
		captain:setVisible(true)
		if WBattleGlobal:getCurrent():isMyTeam(self.m_tCharacter:getBattleId()) then
			captain:setFile("shopitems/zd_duizhangjf.png")
		else
			captain:setFile("shopitems/zd_duizhangdf.png")
		end
	end

	if WBattleGlobal:getCurrent():getMyHero() == tCharacter or WBattleGlobal:getCurrent():isSingleStage() or (not WBattleGlobal:getCurrent():isMyTeam(tCharacter:getBattleId())) or WndBattleHud:checkVoiceChannelLv() ~= true then
		GetElement(self.m_root,"conFigureVoice_CellBattleCtb",WZUIContainer):setVisible(false)
	end
end

function CellBattleCtb:getNextPer(nCtb)
	local MAX_CTB = BattleCtbManager.MAX_CTB

	local nowPer = nCtb / MAX_CTB * 100
	local prog = self:getProg()
	if nowPer > 100 then
		nowPer = 100
	elseif nowPer < 0 then
		nowPer = 0
	end
	return nowPer
end


function CellBattleCtb:setCtb(nCtb,isReset)
	WZLog("CellBattleCtb:setCtb", nCtb, self.m_tCharacter.m_nNowCTB)
	local prog = self:getProg()
	if nCtb > 10000 then
		nCtb = 10000
	end
	local nextPer = self:getNextPer(nCtb)
	if nextPer and self.m_bIsDead ~= true then
		prog:setPercentage( nextPer )
        self:getProgUnder():setPercentage(nextPer)
	end
	self.m_nCTB = nCtb
	if isReset then
    	self.m_tCharacter.m_nNowCTB = nCtb
	end
end

function CellBattleCtb:setDead(isDead)
    self.m_bIsDead = isDead
	self:getProg():setGrayRender(isDead)
	--self:getProg():setVisible(false)
    --self:getProgUnder():setGrayRender(isDead)
    self:getProgUnder():setVisible(not isDead)
	GetElement(self:getRoot(),"imgFigure_CellBattleCtb",WZUIImage):setGrayRender(isDead)

    GetElement(self:getRoot(),"imgFigureSel_CellBattleCtb",WZUIImage):setGrayRender(isDead)
    GetElement(self:getRoot(),"imgFigureBg_CellBattleCtb",WZUIImage):setGrayRender(isDead)
    --GetElement(self:getRoot(),"imgProgBgTime_CellBattleCtb",WZUIImage):setGrayRender(isDead)

    if self.m_tHeadAnim and self.m_tHeadAnim.m_tAnimNode then
        self.m_tHeadAnim.m_tAnimNode:setGrayRender(isDead)
    end
end

function CellBattleCtb:setExit(isExit, isQuit)
    local img = GetElement(self:getRoot(),"imgFigureOut_CellBattleCtb",WZUIImage)
    img:setVisible(isExit)
    if not isQuit then
        img:setFile("ui/common/common_icon_wifidx.png")
        img:setScale(0.25)
    else
    	img:setFile("ui/common/common_icon_diaoxian.png")
        img:setScale(1)
    end
end

function CellBattleCtb:addCtb(nCtb)
	local nextCtb = self.m_nCTB - nCtb > 10000 and 10000 or self.m_nCTB - nCtb
	local nowPer = self:getNextPer(nextCtb)


	self.m_tCharacter.m_nNowCTB = self.m_tCharacter.m_nNowCTB - nCtb < 0 and 0 or self.m_tCharacter.m_nNowCTB - nCtb
	if self.m_tCharacter.m_nNowCTB > 10000 then
		self.m_tCharacter.m_nNowCTB = 10000
	end
	WZLog("CellBattleCtb:addCtb", nCtb, self.m_nCTB, nextCtb, nowPer, self.m_tCharacter.m_nNowCTB)

	if nowPer and self.m_bIsDead ~= true then
		local prog = self:getProg()

		
		local progAction = WZUIActionProgressFromTo:create()
		progAction:setFromPercent(prog:getPercentage())
		progAction:setToPercent(nowPer)
		progAction:setDuration( 0.1 )
        progAction:setFinishLuaFunction("actionPlayEffect")
        progAction:setFinishLuaTable(self)

        self.m_bIsAction = true
		prog:runUIAction(progAction)

        local prog = self:getProgUnder()
        local progAction = WZUIActionProgressFromTo:create()
        progAction:setFromPercent(prog:getPercentage())
        progAction:setToPercent(nowPer)
        progAction:setDuration( 0.1 )
        prog:runUIAction(progAction)
	end

	self.m_nCTB = nextCtb
end

function CellBattleCtb:actionPlayEffect(element)
    self.m_bIsAction = nil
end

function CellBattleCtb:updateCtb(nowCtb)
	local prog = self:getProg()
	
	self.m_nUpdateCTB = nowCtb

	if BattleCtbManager.m_nUpdateCTB_time <= 0 then
		self.m_nCTB_Rate = 0
	else
		--算出对应的速率
		self.m_nCTB_Rate = (self.m_nUpdateCTB - self.m_nCTB)/BattleCtbManager.m_nUpdateCTB_time * BattleCtbManager.SECOND_PER_CTB
	end

	--冰冻的处理
	local isFrozen,remainTime = self.m_tCharacter:getFrozenState()
	if isFrozen == true then
		self.m_bFrozen = true
		--如果CTB不足以解开冰冻态，则不播动画
		if remainTime and remainTime > BattleCtbManager.m_tUpdateCtbValue[self.m_nCharacterId] then
			return
		end
		self.m_nDt = 0
	else
		self.m_bFrozen = false
	end
	prog:disableSchedule()

	if self.m_bIsDead == true then
		self.m_bProgAction = false
		return
	end

	prog:enableSchedule("updateCtbAction",0)

	self.m_bProgAction = true
end

function CellBattleCtb:updateCtbAction(element,dt)
	WZLog("CellBattleCtb:updateCtbAction",self.m_bFrozen)

	if self.m_bFrozen then
		self.m_nDt = self.m_nDt + dt
		local isFrozen,remainTime = self.m_tCharacter:getFrozenState()
		--如触发解冻，CTB动画开始
		if isFrozen ~= true then
			--重新计算速率
			self.m_nCTB_Rate = (self.m_nUpdateCTB - self.m_nCTB)/(BattleCtbManager.m_tUpdateCtbValue[self.m_nCharacterId] - self.m_nDt * BattleCtbManager.SECOND_PER_CTB) * BattleCtbManager.SECOND_PER_CTB
			self.m_bFrozen = false
			self.m_nDt = 0
		-- else
		-- 	local prog = WZUIProgress:luaTo(element)
		-- 	self.m_bProgAction = false
		-- 	prog:disableSchedule()
		-- 	return
		end
	end

	local prog = WZUIProgress:luaTo(element)
	local MAX_CTB = BattleCtbManager.MAX_CTB

	local ctb = self.m_nCTB + self.m_nCTB_Rate * dt

	if self.m_nCTB_Rate <= 0 or ctb >= self.m_nUpdateCTB then
		self.m_bProgAction = false
		ctb = self.m_nUpdateCTB
		prog:disableSchedule()
	end

	local nowPer = ctb / MAX_CTB * 100
	if prog:getPercentage() ~= nowPer then
		prog:setPercentage(nowPer)
	end

    local perUnder = self:getProgUnder():getPercentage()
    for i=1, 10 do
        local per = 9 + (i-1) * 10
--        WZLog("CellBattleCtb:updateCtbAction", i, prog:getPercentage(), nowPer, per, perUnder)
        if nowPer > per and perUnder < per then
            self:getProgUnder():setPercentage(i * 10)
        end
    end
	self.m_nCTB = ctb
end

function CellBattleCtb:hasProgAction()
	return self.m_bProgAction
end

function CellBattleCtb:showBigCtb(tSender)
	BattleCtbManager:showBigCtb()
    self.m_nShowBigCtb = 0
    if self.m_tMedalList and #self.m_tMedalList > 0 then
        for i, medal in pairs(self.m_tMedalList) do
            medal:setVisible(false)
        end
    end
end

function CellBattleCtb:updateTeamColor()
	if self:getCharacterType() == CharacterType.TYPE_HERO and WBattleGlobal:getCurrent():isMyTeam(self.m_tCharacter:getBattleId()) then
		GetElement(self:getRoot(),"imgFigureSel_CellBattleCtb",WZUIImage):setFile("ui/combat/battle_icon_touxianglan_sel.png")
		GetElement(self:getRoot(),"imgFigureBg_CellBattleCtb",WZUIImage):setFile("ui/combat/optimize/common_slale9_touxiangdi.png")
	else
		GetElement(self:getRoot(),"imgFigureSel_CellBattleCtb",WZUIImage):setFile("ui/combat/battle_icon_touxianghong_sel.png")
		GetElement(self:getRoot(),"imgFigureBg_CellBattleCtb",WZUIImage):setFile("ui/combat/optimize/common_slale9_touxiangdi.png")

	end
end

function CellBattleCtb:getProg()
    local prog
    if self.m_tProg == nil then
        if self:getCharacterType() == CharacterType.TYPE_HERO and WBattleGlobal:getCurrent():isMyTeam(self.m_tCharacter:getBattleId()) then
            prog = GetElement(self:getRoot(),"progTime_CellBattleCtb",WZUIProgress)
            WZLog("CellBattleCtb:getProg setBgPicture 1")
        else
            prog = GetElement(self:getRoot(),"progTime2_CellBattleCtb",WZUIProgress)
            WZLog("CellBattleCtb:getProg setBgPicture 2")
        end
        prog:setVisible(true)
        self.m_tProg = prog
    else
        prog = self.m_tProg
    end

    return prog
end

function CellBattleCtb:getProgUnder()
    local prog
    if self.m_tProgUnder == nil then
        if self:getCharacterType() == CharacterType.TYPE_HERO and WBattleGlobal:getCurrent():isMyTeam(self.m_tCharacter:getBattleId()) then
            prog = GetElement(self:getRoot(),"progTimeUnder_CellBattleCtb",WZUIProgress)
            WZLog("CellBattleCtb:getProg setBgPicture 1")
        else
            prog = GetElement(self:getRoot(),"progTimeUnder2_CellBattleCtb",WZUIProgress)
            WZLog("CellBattleCtb:getProg setBgPicture 2")
        end
        prog:setVisible(true)
        self.m_tProgUnder = prog
    else
        prog = self.m_tProgUnder
    end

    return prog
end

function CellBattleCtb:checkFadeAction()
	local imgList = { --[["imgProgSel_CellBattleCtb",]]"imgProgSel2_CellBattleCtb" --[[, "imgFigureSel_CellBattleCtb"]] }
	for i,imgName in pairs(imgList) do
		local img = GetElement(self:getRoot(),imgName,WZUIImage)
		if self.m_tCharacter:getBattleId() == WBattleGlobal:getCurrent():getCurrentCharacterId() then
			local action = WZUIActionSequence:create()

			local fadeOutA = WZUIActionFadeTo:create()
			fadeOutA:setOpacity(0)
			fadeOutA:setDuration(1)
			local fadeOutB = WZUIActionFadeTo:create()
			fadeOutB:setOpacity(255)
			fadeOutB:setDuration(1)

			action:setChildAction(fadeOutA)
			action:setChildAction(fadeOutB)
			action:setIsLoop(true)
			
			img:stopAllActions()
			img:setOpacity(255)
			img:runUIAction(action)
			img:setVisible(true)
		else
			img:stopAllActions()
			img:setOpacity(255)
			img:setVisible(false)
		end
	end
end

function CellBattleCtb:updateCurrentStatus()
	self:checkFadeAction()
end

function CellBattleCtb:updateByTurn()
	self:updateCurrentStatus()
end

function CellBattleCtb:getCtb()
	-- body
	return self.m_nCTB
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
--@brief	听筒按钮点击后的Lua回调
function CellBigBattleCtb:onClickSpeaker(sender)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WZLog("CellBigBattleCtb:onClickSpeaker", self.m_nVoiceId, self.m_nSpeakerState)
    if self.m_nSpeakerState == 0 then
        GetElement(self.m_root,"imgSpeaker1_CellBattleCtb",WZUIImage):setVisible(true)
        --GetElement(self.m_root,"imgSpeaker2_CellBattleCtb",WZUIImage):setVisible(true)
        WndBattleHud:forbidMemberVoice(self.m_nVoiceId, false, self.m_tCharacter:getBattleId())
    else
        GetElement(self.m_root,"imgSpeaker1_CellBattleCtb",WZUIImage):setVisible(false)
        --GetElement(self.m_root,"imgSpeaker2_CellBattleCtb",WZUIImage):setVisible(false)
        WndBattleHud:forbidMemberVoice(self.m_nVoiceId, true, self.m_tCharacter:getBattleId())
    end
    self.m_nSpeakerState = 1 - self.m_nSpeakerState
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBigBattleCtb:onEnter(element)
	self.m_root = WZUIContainer:luaTo(element)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBigBattleCtb:onExit(element)
	self:_unInit()
end

--@brief	获取表节点
--@return	element:表绑定的UI节点引用
function CellBigBattleCtb:getRoot()
	return self.m_root
end

--@brief	设置CellBattleCtb所属对象
--@param	tCharacter:对象表
--@note
function CellBigBattleCtb:setCharacter(tCharacter)
	self.m_tCharacter = tCharacter
	--self.m_nVoiceId = tCharacter:getBattleId()
	if self:getRoot() then

        local img = GetElement(self:getRoot(),"imgFigure2_CellBigBattleCtb",WZUIImage)
        local head,headObj = CellHead:show(img,GDatatab_item[tCharacter.m_tSuitInfo.head].id,GDatatab_item[tCharacter.m_tSuitInfo.face].id,tCharacter.m_nBoyOrGirl,nil,{x=0.5, y=0.3},nil,tCharacter.m_tSuitInfo.colour)
		head:setScale(0.6)
        self.m_tHeadAnim = headObj

		local sTxt = [[<T S="20" C="255,237,191">LV:%s</T><BR/><I Z="0.3" P="1">%s</I>]]
		local element = GetElement(self:getRoot(),"txtCharactor_CellBigBattleCtb",WZUIFreeTextBox)
		local txtCharaName = GetElement(self:getRoot(),"txtCharaName_CellBigBattleCtb", WZUILabelTTF)
		WZLog("CellBigBattleCtb:setCharacter", WBattleGlobal:getCurrent().m_nBattleType, WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle)
		local professionPath = ""
		if tCharacter:getProfessionId() and tCharacter:getProfessionId() > 0 then 
			professionPath = g_professionIcon[tCharacter:getProfessionId()]
	        if tCharacter:getIsProfessionSecondTurn() then 
	            professionPath = g_professionIcon2[tCharacter:getProfessionId()]
	        end
		end
		local strName = tCharacter:getPlayerName()
		if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and (WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW or WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS) then
			sTxt = [[<T S="20" C="255,237,191">ID:%d</T><BR/><I Z="0.3" P="1">%s</I>]]
			element:setShowText(string.format(sTxt, tCharacter:getId(), professionPath))
		else
			element:setShowText(string.format(sTxt,tCharacter:getLevel(), professionPath))
		end
		txtCharaName:setText(strName)
		if professionPath ~= "" then 
			txtCharaName:setRelativePosition(GlobalMethod:ccp(0.3, 0.25))
		else
			element:setRelativePosition(GlobalMethod:ccp(0, 0.75))
		end
		
		self:updateTeamColor()

		if WBattleGlobal:getCurrent():getMyHero() == tCharacter or WBattleGlobal:getCurrent():isSingleStage() or (not WBattleGlobal:getCurrent():isMyTeam(tCharacter:getBattleId())) or WndBattleHud:checkVoiceChannelLv() ~= true then
			GetElement(self.m_root,"btnSpeaker_CellBattleCtb",WZUIButton):setVisible(false)
		end
	end
end


function CellBigBattleCtb:showInfo(tSender)
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
	if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and (WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW or WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS) then
		return 
	end

	WZLog("CellBigBattleCtb:showInfo")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = self.m_tCharacter:getBattleId()
	if id == WBattleGlobal:getCurrent():getMyBattleId() then
		id = GlobalGame.g_tPlayerInfo.nPlayerId
	--跨服处理
	elseif WBattleGlobal:getCurrent().m_tMakePairOk.battleId < 0 then
		id = - id
	end
	if (WBattleGlobal:getCurrent():isDoubleTowerStage() or WBattleGlobal:getCurrent():isHostChallengeStage()) and not WBattleGlobal:getCurrent():isMyTeam(id) then 
		return 
	end
	if id == 2000000001 then return end 
	
	WndCheckOther:show(id)
end


function CellBigBattleCtb:updateTeamColor()
	if WBattleGlobal:getCurrent():isMyTeam(self.m_tCharacter:getBattleId()) then
		GetElement(self:getRoot(),"imgFigureBg_CellBigBattleCtb",WZUIImage):setFile("ui/combat/optimize/common_slale9_touxiangdi.png")
	else
		GetElement(self:getRoot(),"imgFigureBg_CellBigBattleCtb",WZUIImage):setFile("ui/combat/optimize/common_slale9_touxiangdi.png")
	end
end

function CellBigBattleCtb:showTopLine(bShow)
	GetElement(self:getRoot(),"imgTopLine_CellBigBattleCtb"):setVisible(bShow)
end

