--WndRemainsInfo.lua
--@brief	WndRemainsInfo的UI模块
--@date		2019/07/04
--@author	yrd
--@note		遗迹之光副本信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRemainsInfo:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	ProtocolProcessorDigGem:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRemainsInfo:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击时被调用的函数
--@param	element:表绑定的UI节点引用
function WndRemainsInfo:onCloseWindowBtn(element)
	if self.m_root ~= nil then
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
        WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	end 
end 

--@brief	退出场景时被调用的函数
function WndRemainsInfo:onCloseActionCallback(elem,data)
    WZLog("WndRemainsInfo:onCloseActionCallback",elem,data)
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndRemainsInfo:_update()	
	local txtBtnShare = GetElement(self.m_root,"txtBtnShare_WndRemainsInfo",WZUILabelTTF)
	txtBtnShare:setText(LocalStrings.SHARE)
	txtBtnShare:setLabelStyleKey("SMALL_ORANGE_BTN")
	local btnShare = GetElement(self.m_root,"btnShare_WndRemainsInfo",WZUIButton)
	btnShare:setButtonStatus(0)
	btnShare:setTouchEnable(true)
	self:_shareBtnCD()

	local tDigMap = GDatatab_dig_map["id_"..self.m_nMapNum]
	local sName = tDigMap.map_name

	local tMonsterInfo = GDatatab_monster["id_"..tDigMap.monster[1][1]]
	local nbossScale = tMonsterInfo.scale
    local monsterSpine = tMonsterInfo.AniFileId

	GetElement(self.m_root,"txtDiscovererName_WndRemainsInfo",WZUILabelTTF):setText(self.m_sPlayerName)
	GetElement(self.m_root,"txtCopyName_WndRemainsInfo",WZUILabelTTF):setText(sName)
	GetElement(self.m_root,"txtBossName_WndRemainsInfo",WZUILabelTTF):setText(tMonsterInfo.name)
	GetElement(self.m_root,"txtBossTalk_WndRemainsInfo",WZUILabelTTF):setText(tMonsterInfo.script)
	GetElement(self.m_root,"txtBossHP_WndRemainsInfo",WZUILabelTTF):setText(self.m_nBossBloodCurrent.."/"..self.m_nBossBloodMax)
	GetElement(self.m_root,"proBossHP_WndRemainsInfo",WZUIProgress):setPercentage(math.ceil(self.m_nBossBloodCurrent/self.m_nBossBloodMax*100))

	local spBoss = GetElement(self.m_root,"spBoss_WndRemainsInfo",WZUISpine)
    spBoss:setScale(0.8)
    spBoss:setFileAtlas("battle/monster/" .. monsterSpine .. ".atlas")
    spBoss:setFileJson("battle/monster/" .. monsterSpine .. ".json")
    spBoss:setAnimationName("wait")

    local sec = self.m_nMapTime%60
    local min = math.ceil(self.m_nMapTime/60)%60
    local hour = math.floor(math.ceil(self.m_nMapTime/60)/60)
	GetElement(self.m_root,"txtLeftTime_WndRemainsInfo",WZUILabelTTF):setText(string.format("%02d:%02d", hour, min))

	local txtMyRankName = GetElement(self.m_root,"txtMyRankName_WndRemainsInfo",WZUILabelTTF)
	local txtMyRankNum = GetElement(self.m_root,"txtMyRankNum_WndRemainsInfo",WZUILabelTTF)
	txtMyRankNum:setText(self.m_nPlayerRank)
	if self.m_nPlayerRank == -1 then
		txtMyRankName:setVisible(false)
		txtMyRankNum:setVisible(false)
	else
		txtMyRankName:setVisible(true)
		txtMyRankNum:setVisible(true)
	end
   	
	if self.m_nReward == 1 then
		GetElement(self.m_root,"conBtnChallenge_WndRemainsInfo",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"btnReceive_WndRemainsInfo",WZUIButton):setVisible(true)
	else
		GetElement(self.m_root,"conBtnChallenge_WndRemainsInfo",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"btnReceive_WndRemainsInfo",WZUIButton):setVisible(false)
	end

	local digdungeontimes = CacheCenter:getGameParam().digdungeontimes
	GetElement(self.m_root,"txtRemainingNum_WndRemainsInfo",WZUILabelTTF):setText(self.m_nChallengeTime.."/"..digdungeontimes)

    local sec = self.m_nTime%60
    local min = math.floor(self.m_nTime/60)%60
    local hour = math.floor(math.floor(self.m_nTime/60)/60)
	local txtLeftChallengeTime = GetElement(self.m_root,"txtLeftChallengeTime_WndRemainsInfo",WZUILabelTTF)
	txtLeftChallengeTime:setText(string.format(LocalStrings.RELIC_TEXT_9, hour, min, sec))
	txtLeftChallengeTime:disableSchedule()
	if self.m_nTime > 0 then
		txtLeftChallengeTime:setVisible(true)
		txtLeftChallengeTime:enableSchedule("_countdownTime", 1)
	else
		txtLeftChallengeTime:setVisible(false)
	end

    local flcReward = GetElement(self.m_root,"flcReward_WndRemainsInfo",WZUIFreeListContainer)
    if flcReward:size() > 0 then
        flcReward:removeAll()
    end
    for key,value in pairs(GDatatab_dig_reward) do
    	if value.difficulty == tDigMap.difficulty and value.rank == -1 then
			for i = 1, #value.reward do
		    	local celElement,tCell = CellGoodItem:createElement()
		    	celElement:setTag(i-1)
		    	celElement = WZUIContainer:luaTo(celElement)
		    	tCell:setCellGoodLocalId(value.reward[i][1], value.reward[i][2] , 4)
				tCell:setItemClickFun(self,self.onClickCallback2)
		    	flcReward:pushBack(celElement)
		    	if value.type == 1 then
		    		tCell:addSidebarFind()
	    		elseif value.type == 2 then
		    		tCell:addSidebarKill()
		    	end
			end
    	end
    end
    flcReward:getMoveElement():setPositionX(flcReward:getMaxPosition().x)
		
	for i=1,#self.m_tRankList do
		self.m_tRankList[i].reward = {}
	end
    for key,value in pairs(GDatatab_dig_reward) do
    	if value.difficulty == tDigMap.difficulty and value.rank ~= -1 then
			for i = 1, #self.m_tRankList do
				if value.rank[1][2] == -1 then
					if self.m_tRankList[i].rank >= value.rank[1][1] then
						-- self.m_tRankList[i].reward = value.reward
						-- WZLog("self.m_tRankList[i]",Serialize(self.m_tRankList[i]))
						-- WZLog("self.m_tRankList",Serialize(self.m_tRankList))
						self.m_tRankList[i].reward = CopyTable(value.reward)
					end
				else
					if self.m_tRankList[i].rank == value.rank[1][1] then
						self.m_tRankList[i].reward = CopyTable(value.reward)
					end
				end
			end
		end
	end
    local flcRanking = GetElement(self.m_root,"flcRanking_WndRemainsInfo",WZUIFreeListContainer)
    if flcRanking:size() > 0 then
        flcRanking:removeAll()
    end
    for i = 1, #self.m_tRankList do
    	local celElement,tCell = CellRemainsInfoRank:createElement()
    	celElement:setTag(i-1)
    	celElement = WZUIContainer:luaTo(celElement)
    	tCell:setData(self.m_tRankList[i])
    	flcRanking:pushBack(celElement)
    end
    flcRanking:getMoveElement():setPositionY(flcRanking:getMinPosition().y)
end

function WndRemainsInfo:onClickReward( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local mapid = tostring(self.mapId)
	ProtocolProcessorDigGem:send_MINING_GetMapReward(mapid)
end

function WndRemainsInfo:_countdownTime(element)
	local txtLeftChallengeTime = GetElement(self.m_root,"txtLeftChallengeTime_WndRemainsInfo",WZUILabelTTF)
	self.m_nTime = self.m_nTime - 1
    local sec = self.m_nTime%60
    local min = math.floor(self.m_nTime/60)%60
    local hour = math.floor(math.floor(self.m_nTime/60)/60)
	txtLeftChallengeTime:setText(string.format(LocalStrings.RELIC_TEXT_9, hour, min, sec))
	if self.m_nTime <= 0 then
		self.m_nTime = 0
		element:disableSchedule()

		local mapid = tostring(self.mapId)
		ProtocolProcessorDigGem:send_MINING_GetRelicInfo(mapid)
	end
end

--@brief	奖励弹窗
function WndRemainsInfo:onClickCallback2(tItem, nTag, tData)
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false, nil)
end

function WndRemainsInfo:onShareClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_sMapStatus == 0 then
		local conShare = GetElement(self.m_root,"conShare_WndRemainsInfo",WZUIContainer)
		conShare:setVisible(false)
		conShare:disableSchedule()
		conShare:enableSchedule("_updateCountDownShare",10)

		local mapid = tostring(self.mapId)
		local bubbleId = WndChat:getPlayerBubble()
		local shareType = 0
		ProtocolProcessorDigGem:send_MINING_ShareMap(mapid, bubbleId, shareType)
	else
		MsgBoxManager:showTipBox(LocalStrings.RELIC_TEXT_16)
	end
end

--@brief	分享倒计时
function WndRemainsInfo:_countdownShareCD(element)
	local txtBtnShare = GetElement(self.m_root,"txtBtnShare_WndRemainsInfo",WZUILabelTTF)
	self.m_nShareTime = self.m_nShareTime - 1
	txtBtnShare:setText(self.m_nShareTime)
	if self.m_nShareTime <= 0 then
		self.m_nShareTime = 0
		local txtBtnShare = GetElement(self.m_root,"txtBtnShare_WndRemainsInfo",WZUILabelTTF)
		txtBtnShare:setText(LocalStrings.SHARE)
		txtBtnShare:setLabelStyleKey("SMALL_ORANGE_BTN")
		local btnShare = GetElement(self.m_root,"btnShare_WndRemainsInfo",WZUIButton)
		btnShare:setButtonStatus(0)
		btnShare:setTouchEnable(true)

		btnShare:disableSchedule()
	end
end

function WndRemainsInfo:_updateCountDownShare(element)
	element:setVisible(false)
	element:disableSchedule()
end

--@brief	世界分享
function WndRemainsInfo:onShareWorld(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conShare_WndRemainsInfo",WZUIContainer):setVisible(false)

	local mapid = tostring(self.mapId)
	local bubbleId = WndChat:getPlayerBubble()
	local shareType = 1
	ProtocolProcessorDigGem:send_MINING_ShareMap(mapid, bubbleId, shareType)
end

--@brief 世界喇叭不足购买世界喇叭
function WndRemainsInfo:clickSureBack(nId,nType)
	if nType == MSGBOXRESTYPE_CONFIRM then
		WndPurchase:showBuyInterface(6,114,nil,nil,nil,self.m_nOrder)
	end
end

--@brief	公会分享
function WndRemainsInfo:onShareGuild(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conShare_WndRemainsInfo",WZUIContainer):setVisible(false)

	if checkInCommunity() ==false then
		MsgBoxManager:showTipBox(LocalStrings.TXT_NOSOCISY_FREND)
		return 
	end

	local mapid = tostring(self.mapId)
	local bubbleId = WndChat:getPlayerBubble()
	local shareType = 2
	ProtocolProcessorDigGem:send_MINING_ShareMap(mapid, bubbleId, shareType)
end

--@brief	cd按钮显示
function WndRemainsInfo:_shareBtnCD(element)
	if self.m_sMapStatus == 0 then
		if self.m_nShareTime == -1 then
			GetElement(self.m_root,"conShareBtn_WndRemainsInfo",WZUIContainer):setVisible(false)
		elseif self.m_nShareTime > 0 then
			GetElement(self.m_root,"conShareBtn_WndRemainsInfo",WZUIContainer):setVisible(true)
			local btnShare = GetElement(self.m_root,"btnShare_WndRemainsInfo",WZUIButton)
			local txtBtnShare = GetElement(self.m_root,"txtBtnShare_WndRemainsInfo",WZUILabelTTF)
			txtBtnShare:setText(LocalStrings.SHARE)
			txtBtnShare:setLabelStyleKey("SMALL_GRAY_BTN")
			txtBtnShare:setText(self.m_nShareTime)
			local btnShare = GetElement(self.m_root,"btnShare_WndRemainsInfo",WZUIButton)
			btnShare:setButtonStatus(2)
			btnShare:setTouchEnable(false)
			btnShare:enableSchedule("_countdownShareCD", 1)
		else
			GetElement(self.m_root,"conShareBtn_WndRemainsInfo",WZUIContainer):setVisible(true)
		end
	else
		GetElement(self.m_root,"conShareBtn_WndRemainsInfo",WZUIContainer):setVisible(false)
	end
end

--@brief	点击挑战按钮
function WndRemainsInfo:onStartGameButtonClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if SceneBossRoom.m_root or SceneMarryCopy.m_root or SceneWorldTeamBossRoom.m_root or SceneCoupleHegemonyRoom.m_root or SceneGuildWarRoom.m_root or SceneRoom.m_root then
        MsgBoxManager:showTipBox(LocalStrings.CURRENT_ROOM_CANNOT_RELIC)
        return
    end
	if self.m_nChallengeTime <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.RELIC_TEXT_14)
		return
	end

	local mapid = tostring(self.mapId)
	ProtocolProcessorDigGem:send_MINING_MakePair(mapid)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------

function WndRemainsInfo:_adaptLanguage_vn()
	GetElement(self.m_root,"txtLeftChallengeTime_WndRemainsInfo",WZUILabelTTF):setScale(0.85)
	GetElement(self.m_root,"txt1_WndRemainsInfo",WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root,"txt2_WndRemainsInfo",WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root,"txt3_WndRemainsInfo",WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root,"txt4_WndRemainsInfo",WZUILabelTTF):setScale(0.75)

	local txtBossTalk = GetElement(self.m_root,"txtBossTalk_WndRemainsInfo",WZUILabelTTF)
	txtBossTalk:setScale(0.8)
	txtBossTalk:setRelativePosition(GlobalMethod:ccp(0.7,0.503))
	txtBossTalk:setDimensions(GlobalMethod:CCSize(250))

end

-------------------------------------语言适配End----------------------------------------