--SceneRoom.lua
--@brief	SceneRoom的UI模块
--@date		2013/12/26
--@author	李光森
--@modify   qixiang_xie
--@note		战斗房间


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneRoom:onEnter(element)
    WZLog("SceneRoom:onEnter ")
	self.m_root = element
 
    ProtocolProcessorSceneRoom:regAll() --注册协议
    --竞技房间频道
	ChangeChatChannel(Chat_Channel_Room)
	IPDConnector.g_nNetConnectFlag = NET_FLAG_7
  
    if Teach.CREATE_ROOM_MARK == true then
        Teach.CREATE_ROOM_MARK = nil
    end
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    self:addTop()
    if self.m_tData ~= nil then
		self:endPairTimer()
		self:_update()
	end
	
    self:anctionPlayFinish()
    self.m_toSceneBattleLoading = nil

    self.m_root:enableSchedule("_updateCheckPlayerState",1)
    WndChat:addChatWindowToCurScene()

    self:checkVoice()
    GlobalGame.g_lastRoomNumber = nil
	GlobalGame.g_lastRoomSeat = nil
end 

--@breif  动画播放完毕
function SceneRoom:anctionPlayFinish()
	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then  --练习赛
		return 
	end
	local conCenter = GetElement(self.m_root, "conCenter_SceneRoom", WZUIContainer)
	local conBg = GetElement(self.m_root, "conBg_SceneRoom", WZUIContainer)

    conBg:enableSchedule("updatePlayerZOrder")
	conCenter:enableSchedule("updatePlayerAnimation", 1.5)
end

--@brief	设置所有按钮是否可点
function SceneRoom:setAllBtnStats(bStats)
	WZLog("SceneRoom:setAllBtnStats")
	self.m_bCanClickSeat = bStats
	if not self:getIsRoomOwner() then
	--	WZUIButton:luaTo(self.m_root:getChildElement("btnReadyGame_SceneRoom")):setTouchEnable(bStats)
	elseif self:getIsRoomOwner() and self.m_tData.startMode ~= 1 then
		WZUIButton:luaTo(self.m_root:getChildElement("btnReadyGame_SceneRoom")):setTouchEnable(bStats)
	end
--	self.m_tTopHangle:setTopTouchEnable(bStats)
	self.m_tTopHangle:setMatchState(not bStats)
	--self.m_tWndBottomBar:setTouchEnable(bStats)
	--WZUIButton:luaTo(self.m_root:getChildElement("btnReturn_SceneRoom")):setTouchEnable(bStats)
end

--@brief  如果准备游戏了，不能点击返回按钮，先取消准备才能退出
--@param  bStatus : true  不屏蔽顶部导航栏触摸事件  false 屏蔽顶部导航栏触摸事件
function SceneRoom:setAllBtnStats2(bStatus)
	WZLog("SceneRoom:setAllBtnStats2 = ",bStatus)
	self.m_tTopHangle:setShieldClick(bStatus)
end

--@brief  退出房间
function SceneRoom:exitRoom(isSend)
	if self.m_root ~= nil then
		local btnArenaAddInfo = GetElement(self.m_root,"btnArenaAddInfo_SceneRoom",WZUIButton)
		btnArenaAddInfo:disableSchedule()
	end

	if self.m_tData == nil or self.m_root == nil then
		WZLog("SceneRoom:onBackSceneCallback m_tData is nil")
		if isSend and GlobalGame.g_lastRoomNumber and GlobalGame.g_lastRoomSeat then
			ProtocolProcessorSceneRoom:send_ROOM_QuitRoom(GlobalGame.g_lastRoomNumber, GlobalGame.g_lastRoomSeat)
			GlobalGame.g_lastRoomNumber = nil
			GlobalGame.g_lastRoomSeat = nil
		end
		return
	end
    if self.m_toSceneBattleLoading ~= true then
        if WBattleGlobal:getCurrent().m_tMakePairOk and WBattleGlobal:getCurrent().m_tMakePairOk.battleId then
            WBattleGlobal:getCurrent().m_tMakePairOk.battleId = 0
        end
        ProtocolProcessorSceneRoom:send_ROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat())
    else
    	GlobalGame.g_lastRoomNumber = self.m_tData.roomId
		GlobalGame.g_lastRoomSeat = self:_getPlayerSeat()
    end
end

--@brief  改变准备状态
function SceneRoom:changeReadyStatus()
	WZLog("SceneRoom:changeReadyStatus")
	local seatI = self:_getPlayerSeat()
	ProtocolProcessorSceneRoom:send_ROOM_GameReady(self.m_tData.roomId, seatI, not self.m_tData.playerReady[seatI + 1] )
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneRoom:onExit(element)
    WZLog("SceneRoom:onExit", tostring(g_bIsPushScene), tostring(g_bIsPopScene))
    if g_bIsPushScene == true then
        return
    end
    if self.m_root then 
        local conCenter = GetElement(self.m_root, "conCenter_SceneRoom", WZUIContainer)
        local conBg = GetElement(self.m_root, "conBg_SceneRoom", WZUIContainer)

        conBg:disableSchedule()
        conCenter:disableSchedule()
        for i = 1, 3 do
        	local conSeat = GetElement(conCenter, "conSeat" .. i .. "_SceneRoom", WZUIContainer)
        	conSeat:stopAllActions()
        end
    end
    for i,v in pairs(self.m_tShowVip18Effect) do
    	if v then
			v:removeFromParentAndCleanup(true)
			v = nil
		end
	end
	for i,v in pairs(self.m_tShowVip18Effect1) do
    	if v then
			v:removeFromParentAndCleanup(true)
			v = nil
		end
	end
    -- FootEffectManager:removeEffect1(self.m_sRoleFootSpine)
    if self.m_sRoleFootSpine then
		self.m_sRoleFootSpine:removeFromParentAndCleanup(true)
		self.m_sRoleFootSpine = nil
	end
    SceneRoom:exitRoom()
    self:quitVoice()
    --add by wuweidong
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","SceneRoom")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","SceneRoom")
    self.m_root:disableSchedule()          
    CacheCenter:unregisterUpateDecorationObserver(self)
    CacheCenter:unregisterUpatePlayerPetInfoObserver(self)
    CacheCenter:unregisterUpateDressSuitObserver(self)
    CacheCenter:unregisterUpateSkillSuitObserver(self)
	ProtocolProcessorSceneRoom:unregAll() --反注册协议
	self:_unInit()
    Teach:isStartTeach("SceneRoom:onExit")
	IPDConnector.g_nNetConnectFlag = NET_FLAG_2
    
end

function SceneRoom:onEnterTransitionDidFinish()
	WZLog("SceneRoom:onEnterTransitionDidFinish")
	CacheCenter:registerUpateDressSuitObserver(self) --注册多套时装
	CacheCenter:registerUpateSkillSuitObserver(self) --注册多套技能方案

    WndAthUpgrade:Show()
    CacheCenter:updateArenaAddInfo()
    local info = CacheCenter:getArenaAddInfo()
    local btnArenaAddInfo = GetElement(self.m_root,"btnArenaAddInfo_SceneRoom",WZUIButton)
    local btnAmuseBalance = GetElement(self.m_root,"btnAmuseBalance_SceneRoom",WZUIButton)
    if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then 
    	btnAmuseBalance:setVisible(true)
    end
    if #info.addValue > 0 then
    	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX or self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then  --练习赛,战略赛
        	btnArenaAddInfo:setVisible(false)
        	btnAmuseBalance:setRelativePosition(GlobalMethod:ccp(0.2, 0.5))
    	else
        	btnArenaAddInfo:setVisible(true)
        	btnAmuseBalance:setRelativePosition(GlobalMethod:ccp(-0.1, 0.5))
        	if GlobalGame.g_tRedPointList and GlobalGame.g_tRedPointList.pvpBuff then 
	            GetElement(self.m_root, "imgARedDot_SceneRoom", WZUIImage):setVisible(true)
	        end
        end
    else
        btnAmuseBalance:setRelativePosition(GlobalMethod:ccp(0.2, 0.5))
        btnArenaAddInfo:setVisible(false)
    end
    btnArenaAddInfo:enableSchedule("onSchedule", 10)

    --排位赛显示掉落
    
	WZLog("SceneRoom:onEnterTransitionDidFinish  111111", self.m_tData.roomChannel, GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW, RANK_OVER_REWARD_COUNT, RANK_OVER_REWARD_ID)
    if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then -- 排位赛
    	if RANK_OVER_REWARD_COUNT and RANK_OVER_REWARD_ID and RANK_OVER_REWARD_ID ~= "" and RANK_OVER_REWARD_COUNT ~= 0 then
	        local id, num = SplitItemString(RANK_OVER_REWARD_ID)
	        WndRewardShow:showById(id, num, nil, nil, nil, nil, nil, 1)
	        RANK_OVER_REWARD_ID = nil
	        RANK_OVER_REWARD_COUNT = nil
	    end
    elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then -- 战略赛
    	if RANK_OVER_REWARD_COUNT and RANK_OVER_REWARD_ID and RANK_OVER_REWARD_ID ~= "" and RANK_OVER_REWARD_COUNT ~= 0 then
	        local id, num = SplitItemString(RANK_OVER_REWARD_ID)
	        WndRewardShow:showById(id, num, nil, nil, nil, nil, nil, 1)
	        RANK_OVER_REWARD_ID = nil
	        RANK_OVER_REWARD_COUNT = nil
	        RANK_OVER_REWARD_LIMIT = nil
	    end
    elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then -- 战略赛
    	if RANK_OVER_REWARD_COUNT and RANK_OVER_REWARD_ID and RANK_OVER_REWARD_ID ~= "" and RANK_OVER_REWARD_COUNT ~= 0 then
	        local id, num = SplitItemString(RANK_OVER_REWARD_ID)
	        WndRewardShow:showById(id, num, nil, nil, nil, nil, nil, 1)
	        RANK_OVER_REWARD_ID = nil
	        RANK_OVER_REWARD_COUNT = nil
	        RANK_OVER_REWARD_LIMIT = nil
	    end
	elseif (self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DJ and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL) or (self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DZ and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL) or (self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL) or (self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_FH and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL) or (self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_WK and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL) or (self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_JH and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL) then 
		if RANK_OVER_REWARD_COUNT and RANK_OVER_REWARD_ID and RANK_OVER_REWARD_ID ~= "" then
	        local id, num = SplitItemString(RANK_OVER_REWARD_ID)
	        WndRewardShow:showById(id, num, nil, nil, nil, nil, nil, 2)
	        RANK_OVER_REWARD_ID = nil
	        RANK_OVER_REWARD_COUNT = nil
	        RANK_OVER_REWARD_LIMIT = nil	    end
    end

	upPlayerFightingAni()
	--延时显示成就特效
    ShowDelayAchie()
    AdaptLanguage(self)
    self:adaptIphoneX()
    self:setSkillSuitName()
    self:_showInviteList()
end

--@brief	获得主角的座位
--@return	#1:位置
function SceneRoom:_getPlayerSeat()
	WZLog("SceneRoom:_getPlayerSeat")
	
	if self.m_tData == nil then
		WZLog("SceneRoom:_getPlayerSeat m_tData is nil.")
		return
	end
	
	for i,vId in ipairs(self.m_tData.playerId) do
		if vId == GlobalGame.g_tPlayerInfo.nPlayerId then
			return i-1
		end
	end
	
	return -1
end

--根据玩家ID查找玩家所在位置
function SceneRoom:findPlayerSeatById(playerId)
	WZLog("SceneRoom:findPlayerSeatById ",playerId)
	if self.m_tData == nil or playerId == nil then
		WZLog("SceneRoom:_getPlayerSeat m_tData is nil.")
		return
	end
	
	for i,vId in ipairs(self.m_tData.playerId) do
		if vId == playerId then
			return i
		end
	end
	return 0
end



--@brief	更新玩家座位
function SceneRoom:updatePlayerSeat()
	WZLog("SceneRoom:updatePlayerSeat")
	local isVoice = self:checkVoiceChannelLv(self.m_tData.roomChannel)
	local playerSeatIndex = self:_getPlayerSeat()
	playerSeatIndex = playerSeatIndex + 1
	GlobalGame.g_nPlayerInTeam = -1
	local indexTag = 0
	local maxCount = 3
	local conCenter = GetElement(self.m_root,"conCenter_SceneRoom",WZUIContainer)
	conCenter:setVisible(true)
	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then
		conCenter:setVisible(false)
		conCenter = GetElement(self.m_root,"conCenter2_SceneRoom",WZUIContainer)
		conCenter:setVisible(true)
		maxCount = 6
	else
		if self.m_tTopHangle then
			self.m_tTopHangle:setChatBtnSize(0.85, GlobalMethod:ccp(0.5, 0.3))
		end
	end
	for i= 1,maxCount do
		self:checkCellChatBubble(i)
		local conSeat = WZUIContainer:luaTo(conCenter:getChildElement("conSeat".. i .."_SceneRoom"))
	    local btnPlayerFigure  = WZUIButton:luaTo(conSeat:getChildElement("btnPlayerFigure_SceneRoom"))
	    local btnPlayerPet = GetElement(conSeat,"btnPlayerPet_SceneRoom",WZUIButton)

	    local conWeapon= WZUIContainer:luaTo(conSeat:getChildElement("conWeapon_SceneRoom"))
	    local imgWeaponIcon = WZUIImage:luaTo(conWeapon:getChildElement("imgWeaponIcon_SceneRoom"))
	    imgWeaponIcon:setFile("")

        local btnWeapon = WZUIButton:luaTo(conWeapon:getChildElement("btnWeapon_SceneRoom"))
        btnWeapon:setTag(-1)

        local spWeapon1 = GetElement(conWeapon,"spWeapon_SceneRoom",WZUISpine)
        spWeapon1:setVisible(false)
	    local playerId = self.m_tData.playerId[i]
	    self:showPlayerFigureAndPet(i)

        local conFigure = GetElement(conSeat,"conFigureVoice_SceneRoom",WZUIContainer)
        local anim = GetElement(conSeat,"animFigureVoice_SceneRoom",WZUISpine)
		local img = GetElement(conSeat,"imgFigureVoice_SceneRoom",WZUIImage)

	    if playerId == nil or playerId  < 1  then
	        conWeapon:setVisible(false)
	        btnPlayerFigure:setVisible(false)
	        if conFigure then
                conFigure:setVisible(false)
	     	end
	    else
	    	local playerWeaponId = self.m_tData.playerEquipment[i*5-1]
	    	WZLog("playerWeaponId = ",playerWeaponId)
	    	if playerWeaponId ~= nil and playerWeaponId > 0 then
	    		local weaponIcon = GDatatab_item["id_" .. playerWeaponId].icon
	    	    imgWeaponIcon:setFile(weaponIcon)
	    	    btnWeapon:setTag(playerWeaponId)
	    	    local weaponExtranInfo = self.m_tData.extranInfo[i]
	    	    weaponExtranInfo = json.decode(weaponExtranInfo)
	    	    local starLevel = weaponExtranInfo.starLevel
	    	    starLevel = tonumber(starLevel)
	    	    if starLevel >=5 and  starLevel < 8 then
	    	    	spWeapon1:setVisible(true)
	    	    	spWeapon1:setAnimationName("5")
	    	    elseif starLevel >= 8 and starLevel < 10 then
	    	    	spWeapon1:setVisible(true)
	    	    	spWeapon1:setAnimationName("8")
	    	    elseif starLevel >= 10 and starLevel < 12 then
	    	    	spWeapon1:setVisible(true)
	    	    	spWeapon1:setAnimationName("10")
	    	    elseif starLevel >= 12 then
	    	    	spWeapon1:setVisible(true)
	    	    	spWeapon1:setAnimationName("12")
	    	    end
	    	end
	    	conWeapon:setVisible(false)
	        btnPlayerFigure:setVisible(true)

         	WZLog("updatePlayerSeat one", i, tostring(isVoice), playerId)
            if isVoice and playerId ~= CacheCenter:getPlayerInfo().id then
                conFigure:setVisible(true)
                img:setFile("ui/common/common_icon_yuying_02.png")
				img:setGrayRender(true)
				img:setVisible(true)
				anim:setVisible(false)
                WZLog("updatePlayerSeat twe")
            end
	    end
	    local petInfo = self.m_tPlayersPetInfo[i]
	    if petInfo ~= nil and petInfo.itemId ~= nil then
	    	btnPlayerPet:setVisible(true)
	    else
	    	btnPlayerPet:setVisible(false)
	    end

	    
	    if playerSeatIndex <=3 then
	    	if i<=3 then
	    		indexTag = 0
	    	else
	    		indexTag =1
	    	end
	    else
	    	if i >3 then
	    		indexTag=0
	    	else
	    		indexTag =1
	    	end
	    end

	    local conSeatInfo = GetElement(conSeat,"conSeatInfo_SceneRoom",WZUIContainer)
		local conSeatInfoChild = conSeatInfo:getChildByTag(111)
	    if conSeatInfoChild then
	    	WZLog("updateSeat.......")
	    	conSeatInfoChild = WZUIContainer:luaTo(conSeatInfoChild)
	    	local luaObject = conSeatInfoChild:getLuaObjectIndex()
	    	self:_updateSeatInfo(luaObject,conSeatInfoChild,i,indexTag,self.m_tData.seatUsed[i])
	    else
	    	WZLog("createSeat...... ",i,indexTag,self.m_tData.seatUsed[i])	    	
	    	local cellElement,cellObj = self:_createASeat(i,indexTag,self.m_tData.seatUsed[i])
    	    cellElement:setTag(111)
    	    conSeatInfo:addChild(cellElement)

    	    if self.m_tData.roomChannel ~= GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then  --练习赛
				cellObj:setBGRectVisible(false)
			end
	    end
         
	end
	self:setPlayerTeam(indexTag)

	self:showCoupleAnimation()
end
--vip的动画特效
function SceneRoom:setCreateVIPLevelEffect()
	if not self.m_tData then return end
	if not self.m_root then return end

	local conCenter = GetElement(self.m_root,"conCenter_SceneRoom",WZUIContainer)
	for i=1,3 do
		local conSeat = WZUIContainer:luaTo(conCenter:getChildElement("conSeat".. i .."_SceneRoom"))
    	if self.m_tData.vipLevel[i] >= 18 and not self.m_tShowVip18Effect[self.m_tData.playerId[i]] then
    		--人物底盘
			local temp_data = {}
			temp_data.path = "ui/otherUI/ui_common_viplongd"
			temp_data.play = "wait_1"
			temp_data.ccp = GlobalMethod:ccp(0.5,0.1)
			local existSpine = CheckEffectFile(temp_data.path)
			if existSpine then 
				self.m_tShowVip18Effect[self.m_tData.playerId[i]] = createEffectSpine(conSeat, temp_data)
				self.m_tShowVip18Effect[self.m_tData.playerId[i]]:setZOrder(-1)
			else
				local _sIndex = "ui_common_viplongd"
		        local downloadInfo = GetDownloadInfo(_sIndex, "uiEffect")
		        if downloadInfo then 
		        	DownloadManager:addDownloadTask(14200,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
		        end
			end
			--人物(向上的龙)
			local temp_data1 = {}
			temp_data1.path = "ui/otherUI/ui_common_viplongu"
			temp_data1.play = "wait_1"
			temp_data1.ccp = GlobalMethod:ccp(0.5,0.1)
			local existSpine1 = CheckEffectFile(temp_data1.path)
			if existSpine1 then 
				self.m_tShowVip18Effect1[self.m_tData.playerId[i]] = createEffectSpine(conSeat, temp_data1)
			else
				local _sIndex = "ui_common_viplongu"
		        local downloadInfo = GetDownloadInfo(_sIndex, "uiEffect")
		        if downloadInfo then 
		        	DownloadManager:addDownloadTask(14201,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
		        end
			end
    	end
    	if self.m_tData and self.m_tData.vipLevel[i] >= 7 and not self.m_tMakeActionData[self.m_tData.playerId[i]] then
	    	self:createVipEffect(self.m_tData.vipLevel[i], i)
	    end
	end
end
--@brief	开始配对计时器
function SceneRoom:startPairTimer()
	WZLog("SceneRoom:startPairTimer")
	self.m_nPairRemainTime = 1

	self:controlUIElementVisible(true)

	self:updateDescTips()
	local lafTime = WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"lafTime_SceneRoom"))
	lafTime:setText(self.m_nPairRemainTime)
	lafTime:enableSchedule("_schedulePairTimer",1)
end

--@brief	关闭配对计时器
function SceneRoom:endPairTimer()
	WZLog("SceneRoom:endPairTimer")
	local lafTime = WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"lafTime_SceneRoom"))
	lafTime:disableSchedule()
	self:setTimeOutTipVisible(false)
	self:controlUIElementVisible(false)
end

--@brief	发送更新房间协议
function SceneRoom:send_ROOM_UpdateRoom()
	WZLog("SceneRoom:send_ROOM_UpdateRoom")
	if self.m_root == nil or self.m_tData == nil then
		WZLog("SceneRoom:send_ROOM_UpdateRoom no data")
		return
	end
	ProtocolProcessorSceneRoom:send_ROOM_UpdateRoom(self.m_tData.roomId,self.m_tData.battleMode,self.m_tData.playerNumMode,self.m_tData.roomPassword,self.m_tData.mapId,self.m_tData.startMode,self.m_tData.roomName)
end

--@brief	触摸函数，判断消息是否在消息框显示范围内，如果不是的话，就让消息框不显示，反之，显示
--@param #1	element:表绑定的UI节点引用
--@param #2	point:点击位置
function SceneRoom:onTouchBegan(element, point)
	WZLog("SceneRoom:onTouchBegan")
	if self.m_root == nil then 
		WZLog("SceneRoom:onTouchBegan(element, point) self.m_root is nil ")
	end 
    
    if self.m_tCellDressSuit and not self.m_tCellDressSuit:checkPointInBtn(point) then
        self.m_tCellDressSuit:hideSuitList()
    end
    local conForRoomInvite = GetElement(self.m_root, "conForRoomInvite_SceneRoom", WZUIContainer)
    if conForRoomInvite:isVisible() then 
    	if not self:checkInInviteList(point) then 
    		self:hideInviteListCallBack()
    	end
    end

    local conSelPlayerInfo = GetElement(self.m_root, "conSelPlayerInfo_SceneRoom", WZUIContainer)
    if conSelPlayerInfo:isVisible() then 
    	if not self:checkInSelPlayerCon(point) then 
    		conSelPlayerInfo:setVisible(false)
    	end
    end
end

function SceneRoom:checkInInviteList(pt)
	WZLog("SceneRoom:checkInInviteList")
	local btn = GetElement(self.m_root, "conForRoomInvite_SceneRoom", WZUIContainer)
	if btn == nil then return false end
	local btnSize = btn:getContentSize()
	--获得btn的世界坐标
	local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
	WZLog("按钮大小",btnSize.width,btnSize.height)
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		return true
	end 
	return false
end

function SceneRoom:checkInSelPlayerCon(pt)
	WZLog("SceneRoom:checkInSelPlayerCon")
	local btn = GetElement(self.m_root, "conSelPlayerInfo_SceneRoom", WZUIContainer)
	if btn == nil then return false end
	local btnSize = btn:getContentSize()
	--获得btn的世界坐标
	local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
	WZLog("按钮大小",btnSize.width,btnSize.height)
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		return true
	end 
	return false
end

--@brief 判断点击的点是否在某个范围
function SceneRoom:ifPointInMenu(element,point)
    WZLog("SceneRoom:ifPointInMenu")
    if self.m_root == nil then
		return false
	end
    point = self.m_root:convertToNodeSpace(point)
	local menuSize = element:getContentSize()
	local elementPoint = element:convertToWorldSpace(CCPoint(0,0))
	if point.x >= elementPoint.x and point.x <= elementPoint.x+menuSize.width and point.y >= elementPoint.y and point.y <= elementPoint.y+menuSize.height then
        return true
	end
	return false
end



--@brief  显示宠物tip
function SceneRoom:onClickPet(element)
	WZLog("SceneRoom:onClickPet")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	local petInfo = self.m_tPlayersPetInfo[tag]
	if petInfo and petInfo.itemId ~= nil then
		if tag <= 2 then
			WndTips:show(element,self.m_root,13,petInfo,GlobalMethod:ccp(340,-40),true)
		elseif tag == 3 then
			WndTips:show(element,self.m_root,13,petInfo,GlobalMethod:ccp(150,-40),true)
		else
			if  tag == 6 then
				WndTips:show(element,self.m_root,13,petInfo,GlobalMethod:ccp(150,20),true)
			else
				WndTips:show(element,self.m_root,13,petInfo,GlobalMethod:ccp(340,20),true)
			end
		end
	end
end

--@brief 查看玩家武器信息
function SceneRoom:onClickWeapon(element)
	WZLog("SceneRoom:onClickWeapon")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local pNode = WZUIContainer:luaTo(element:getParent())
	local tag = pNode:getTag()
	local weapId = element:getTag()
	if weapId <=0 then
		return
	end
	local weaponInfo = {}
	weaponInfo.id = weapId
	weaponInfo.basicInfo = GDatatab_item["id_"..weapId]
	weaponInfo.extraInfo = json.decode(self.m_tData.extranInfo[tag])
	weaponInfo.maintype = weaponInfo.basicInfo.main_type
	weaponInfo.subtype = weaponInfo.basicInfo.sub_type
	weaponInfo.isUse = true
	
	WndItemInfo:showInfo(element,self.m_root,1,weaponInfo,false,GlobalMethod:ccp(20,0),true)
end

--显示换技能功能
function SceneRoom:onClickSkill(element)
	-- body
	WZLog("SceneRoom:onClickSkill")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_bCanClickSeat then 
		MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
		return 
	end
	local seatI = self:_getPlayerSeat()
	if self.m_tData.playerReady[seatI + 1] and not self:getIsRoomOwner() then
		MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
		return
	end

	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then  --战略赛
		local pvpMode = SceneRoom:getPlayerNumMode()
		local nType = 1
		WndPvpStrategicSkillProp:showInterface(pvpMode,nType)
	else
		WndSkillContainer:showById(1)
	end
end

-- 加成卡信息
function SceneRoom:onArenaAddInfoClick()
    WZLog("----------SceneRoom:onArenaAddInfoClick------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if GlobalGame.g_tRedPointList.pvpBuff then 
        GetElement(self.m_root, "imgARedDot_SceneRoom", WZUIImage):setVisible(false)
        GlobalGame.g_tRedPointList.pvpBuff = false
        ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(154)
    end
    local conTop = GetElement(self.m_root,"conTop_SceneRoom",WZUIContainer)
    if ProjConfig.LANGUAGE == "vn" then
        WndTips:show(conTop, SceneRoom.m_root, 32, {}, GlobalMethod:ccp(600,-240))
    elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" then
        WndTips:show(conTop, SceneRoom.m_root, 32, {}, GlobalMethod:ccp(420,-170))
    else 
    	WndTips:show(conTop, SceneRoom.m_root, 32, {}, GlobalMethod:ccp(800,-170))
    end
end

function SceneRoom:onSchedule(element,dt)
    if not self.m_root then
        return
    end
    CacheCenter:updateArenaAddInfo()
    local info = CacheCenter:getArenaAddInfo()
    
    local btnArenaAddInfo = GetElement(self.m_root,"btnArenaAddInfo_SceneRoom",WZUIButton)
    local btnAmuseBalance = GetElement(self.m_root,"btnAmuseBalance_SceneRoom",WZUIButton)
    if #info.addValue > 0 then
    	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX or self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then  --练习赛,战略赛
        	btnArenaAddInfo:setVisible(false)
        	btnAmuseBalance:setRelativePosition(GlobalMethod:ccp(0.2, 0.5))
    	else
        	btnArenaAddInfo:setVisible(true)
        	btnAmuseBalance:setRelativePosition(GlobalMethod:ccp(-0.1, 0.5))
        end
    else
        btnAmuseBalance:setRelativePosition(GlobalMethod:ccp(0.2, 0.5))
        btnArenaAddInfo:setVisible(false)
    end
end

--@brief 	点击展示邀请列表
function SceneRoom:onClickShowInvite(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    element:setVisible(false)
    self.m_tTopHangle:setWifiSignalVisible(false)
    self.m_tTopHangle:setBottomBarVisible(false)
    GetElement(self.m_root, "conForRoomInvite_SceneRoom", WZUIContainer):setVisible(true)
end

--@brief 	隐藏邀请列表回调
function SceneRoom:hideInviteListCallBack()
	-- body
	GetElement(self.m_root, "conForRoomInvite_SceneRoom", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "btnShowInvite_SceneRoom", WZUIButton):setVisible(true)
	self.m_tTopHangle:setWifiSignalVisible(true)
	self.m_tTopHangle:setBottomBarVisible(true)
end

--@brief 	娱乐赛点击天平按钮回调
function SceneRoom:onAmuseBalanceClick()
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {attrType = 3}
    if self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DJ and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --道具赛
		tData.attrType = 10
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DZ and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --队长赛
		tData.attrType = 2
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --乱斗赛
		tData.attrType = 8
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_FH and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --复活赛
		tData.attrType = 7
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_WK and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --挖坑赛
		tData.attrType = 9
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_JH and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --均衡赛
		tData.attrType = 6
	end
    WndTips:show(element,self.m_root,27,tData,GlobalMethod:ccp(-150,-185),true)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置控件静态文本
--@note		设置控件静态文本
function SceneRoom:_setUIStaticText()
    --描边字
    WZLog("SceneRoom:_setUIStaticText")
   

end
--@brief	scene更新函数
--@note 	实际上的初始化函数
function SceneRoom:_update()    
    WZLog("SceneRoom:_update")             
    if self.m_root == nil then
        WZLog("SceneRoom:_update m_root is nil.")
		return
    end
    
	if self.m_tData == nil then
		WZLog("SceneRoom:_update m_tData is nil.")
		return
	end
	-- FootEffectManager:removeEffect1(self.m_sRoleFootSpine)

	if self.m_sRoleFootSpine then
		self.m_sRoleFootSpine:removeFromParentAndCleanup(true)
		self.m_sRoleFootSpine = nil
	end

--	self.m_tData.battleMode = GlobalGame.g_tBattleMode.BATTLE_MODE_JH

    --显示房间基本信息
    self:updateMiddleInfo()

    self:updateReaderBtn()

    --更新玩家座位
    self:updatePlayerSeat()

    if WindowManager:getSceneRoot():getName() == "WndFriendList" then
       WndFriendList:setInviteFriendIds(self.m_tData.playerId)
    end
    WndFriendList:setInviteFriendIds(self.m_tData.playerId)
	Teach:isStartTeach("SceneRoom:_update")

	self:updateRoomInviteTip()
	--套装
	self:_addDressSuit()
	--更新邀请提示语（排位赛）
	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then -- 排位赛
		WndRoomInviteList:addInviteAtt(self.m_tData.playerNum, self.m_tData.qualifyingLevel, self.m_tData.playerId)
	elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then -- 战略赛赛
		WndRoomInviteList:addInviteAtt(self.m_tData.playerNum, self.m_tData.qualifyingLevel, self.m_tData.playerId)
	elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then -- 娱乐赛
		WndRoomInviteList:addInviteAtt(self.m_tData.playerNum, self.m_tData.tournamentLevel, self.m_tData.playerId)
	end
end

--显示娱乐赛信息
function SceneRoom:updateRoomInviteTip()
	WZLog("SceneRoom:updateRoomInviteTip")
	if self.m_tData == nil then return end
	
	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then -- 排位赛
		self.m_tTopHangle:setTitleFile("ui/common/common_icon_pws.png")
	elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then -- 战略赛
		self.m_tTopHangle:setTitleFile("ui/common/common_icon_zls.png")
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DJ and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --道具赛
		self.m_tTopHangle:setTitleFile("ui/common/common_icon_djs.png")
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DZ and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --队长赛
		self.m_tTopHangle:setTitleFile("ui/common/common_icon_dzs.png")
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --乱斗赛
		self.m_tTopHangle:setTitleFile("ui/common/common_icon_lds.png")
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_FH and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --复活赛
		self.m_tTopHangle:setTitleFile("ui/common/common_icon_fhs.png")
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_WK and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --挖坑赛
		self.m_tTopHangle:setTitleFile("ui/common/common_icon_wks.png")
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_JH and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --均衡赛
		self.m_tTopHangle:setTitleFile("ui/common/common_icon_jhs.png")
	elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then  --练习赛
		self.m_tTopHangle:setTitleFile("ui/common/common_icon_lxs.png")
    else -- 对战赛
		self.m_tTopHangle:setTitleFile("ui/common/common_icon_dzs2.png")
    end
end

--@brief	配对计时器
--@param	element:表绑定的UI节点引用
--@param	delta:时间分量
function SceneRoom:_schedulePairTimer(element, delta)
	WZLog("SceneRoom:_schedulePairTimer")
	self.m_nPairRemainTime = self.m_nPairRemainTime + 1
	if self.m_tData.startMode == 1  then
		if self.m_nPairRemainTime >20 and self.m_nPairRemainTime < 60 then
			self:setTimeOutTipVisible(true)
		elseif self.m_nPairRemainTime >= 60 then
			self:setAllBtnStats(true)
		    self:endPairTimer()
			ProtocolProcessorSceneRoom:send_ROOM_EndPair(self.m_tData.roomId)
			if self:getIsRoomOwner() then
		        self:changeStartGameBtn("ui/common/common_icon_ksyx.png")
	        end
	        self.m_bStartGame = false
			MsgBoxManager:showConfirmBox(LocalStrings.MATCHES_TIMEOUT,nil,nil,nil,nil,true)
		end
	end

	self:updateDescTips()
	
	WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"lafTime_SceneRoom")):setText(self.m_nPairRemainTime)
	WZUILabelTTF:luaTo(GetElement(self.m_root,"txtSmallMatchTime_SceneRoom")):setText(self.m_nPairRemainTime)
end

-- 更新小提示
function SceneRoom:updateDescTips()
	local ttfDesc = GetElement(self.m_root,"txtTimeDownTip_SceneRoom",WZUILabelTTF)
	local nIndex = math.random(1, #LocalStrings.HALL_DESC2)
    if ttfDesc:getText() == LocalStrings.HALL_DESC2[nIndex] then
        nIndex = nIndex+1
        if nIndex > #LocalStrings.HALL_DESC2 then nIndex = 1 end
    end
	if ttfDesc:getText() == "" then
		ttfDesc:setText(LocalStrings.TIPS..":"..LocalStrings.HALL_DESC2[nIndex])
	else
		if self.m_nPairRemainTime % 3 == 0 then
			ttfDesc:setText(LocalStrings.TIPS..":"..LocalStrings.HALL_DESC2[nIndex])
		end
	end
end

--@brief  设置匹配超时提示的控件是否显示
function SceneRoom:setTimeOutTipVisible(visStats)
	local txtMatchTimeOut = self.m_root:getChildElement("txtMatchTimeOut_SceneRoom")
	txtMatchTimeOut:setVisible(visStats)
end

--@brief  更新房间基本信息
function SceneRoom:updateMiddleInfo()
	WZLog("SceneRoom:updateMiddleInfo")

	local conTop = GetElement(self.m_root,"conTop_SceneRoom",WZUIContainer)

	local roomName = WZUILabelTTF:luaTo(conTop:getChildElement("txtRoomName_SceneRoom"))
	roomName:setText(self.m_tData.roomId .. " " .. self.m_tData.roomName)

	local roomId = WZUILabelTTF:luaTo(conTop:getChildElement("txtRoomId_SceneRoom"))
	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then 
		roomId:setText(LocalStrings.BATTLE_MODEL_RANK)
	elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then 
		roomId:setText(LocalStrings.PVP_STRATEGIC_TEXT1[1])
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DJ and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --道具赛
		roomId:setText(LocalStrings.ENTERTAINMENT_MATCH_3)
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DZ and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --队长赛
		roomId:setText(LocalStrings.ENTERTAINMENT_MATCH_2)
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_FH and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --复活赛
		roomId:setText(LocalStrings.ENTERTAINMENT_MATCH_5)
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_WK and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --挖坑赛 
		roomId:setText(LocalStrings.ENTERTAINMENT_MATCH_1)
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_JH and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --均衡赛
		roomId:setText(LocalStrings.ENTERTAINMENT_MATCH_6)
	else
		roomId:setText(self.m_tData.playerNumMode ..  "V" .. self.m_tData.playerNumMode)
	end

	local roomPass = WZUILabelTTF:luaTo(conTop:getChildElement("txtRoomPass_SceneRoom"))
	if self.m_tData.roomPassword == "-1" or self.m_tData.roomPassword == "" then
		roomPass:setText(LocalStrings.NONE)
	else
		roomPass:setText(self.m_tData.roomPassword)
	end
end

--@brief  更新开始游戏按钮状态
function SceneRoom:updateReaderBtn()
	WZLog("SceneRoom:updateReaderBtn()")
	local imgStartGame = WZUIImage:luaTo(self.m_root:getChildElement("imgStartGame_SceneRoom"))
	
	if self:getIsRoomOwner() then
		imgStartGame:setFile("ui/common/common_icon_ksyx.png")
		self:setAllBtnStats2(false)
	else
		for i,v in ipairs(self.m_tData.playerId) do
			if v == GlobalGame.g_tPlayerInfo.nPlayerId then
				if self.m_tData.playerReady[i] then
					imgStartGame:setFile("ui/common/common_icon_qxzb.png")
					self:setAllBtnStats2(true)
				else
					imgStartGame:setFile("ui/common/common_icon_zhunbei2.png")
					self:setAllBtnStats2(false)
				end
				return
			end
		end
	end
end



--@brief	根据id返回地图背景图
--@param	mapId:地图id
--@return	#1:地图背景图string
function SceneRoom:_getMapBgById(mapId)
	WZLog("SceneRoom:_getMapBgById ",mapId)
	local mapImage = GDatatab_battle_map["id_"..mapId].icon
	return RESOURCE_MAP_PATH..mapImage
end

--@brief	根据id返回地图标题图
--@param	mapId:地图id
--@return	#1:地图标题图string
function SceneRoom:_getMapTitleById(mapId)
	WZLog("SceneRoom:_getMapTitleById")
	local mapName = GDatatab_battle_map["id_"..mapId].animationIndexCode
	return RESOURCE_MAP_TITLE_PATH..mapName..".png"
end

function SceneRoom:_getPlayerNum()
	local num = 0
	for i=1 , #self.m_tData.playerId do
		if self.m_tData.playerId[i] > 0 then num = num + 1 end
	end
	return num
end

--@brief	获得是否可以开始游戏
--@return	#1:true:是,false:否,3:玩家没有全部准备
function SceneRoom:_getIsCanStart()
	WZLog("SceneRoom:_getIsCanStart")
	if self.m_tData == nil then
		WZLog("SceneRoom:_getIsCanStart m_tData is nil.")
		return false
	end
	local isCanStart = true
	local leftTeamCount = 0 --左边玩家人数
	local rightTeamCount = 0 --右边玩家人数
	local leftReadyCount = 0 --左边准备游戏人数
	local rightReadyCount = 0  --右边准备游戏人数
	local playerGameCount = 0  --参加混战人数，至少有两个人才能开始
	local readyCount = 0        --准备游戏玩家总算
	if self.m_tData.startMode == 1 then  --(1：匹配模式 2：组队模式)
		for i,v in ipairs(self.m_tData.playerId) do
			if v > 0 then
				if self.m_tData.playerReady[i] ==false then
					return 3
				end
			end
		end

	elseif self.m_tData.startMode == 2  then --组队模式
		local bExistUnread = false
		for i,v in ipairs(self.m_tData.playerId) do
			if v > 0 then
				if i <=3 then
					leftTeamCount = leftTeamCount + 1
					if self.m_tData.playerReady[i] then
						leftReadyCount = leftReadyCount + 1
					else
						bExistUnread = true
					end
				else
					if self.m_tData.playerReady[i] then
						rightReadyCount = rightReadyCount + 1
					else
						bExistUnread = true
					end
					rightTeamCount = rightTeamCount + 1
				end
			end
		end
		if leftTeamCount == rightTeamCount and leftReadyCount == rightReadyCount then
			isCanStart = true
		elseif bExistUnread then
			return 3
		else
			if leftTeamCount == 0 or rightTeamCount == 0 then 
				return 4
			else
				isCanStart = true
			end
		end
	end
	
	return isCanStart
end


--@brief  获取空位数量
function SceneRoom:getAllNULLSeat()
	WZLog("SceneRoom:getAllNULLSeat")
	local count = 0
	for i,v in ipairs(self.m_tData.playerId) do
		if v <=0 then
			count = count + 1
		end
	end
	return count
end

--@brief  判断是否有空位
function SceneRoom:hasNullSeat()
	for i,v in ipairs(self.m_tData.playerId) do
		if v <=0 and self.m_tData.seatUsed[i] then
			return true
		end
	end
	return false
end

--@brief	是否为房主
--@return	#1:true:是,false:否
function SceneRoom:getIsRoomOwner()
	WZLog("SceneRoom:getIsRoomOwner")
	if self.m_tData == nil then
		WZLog("SceneRoom:getIsRoomOwner m_tData is nil.")
		return false
	end
	
	if self.m_tData.wnersId == GlobalGame.g_tPlayerInfo.nPlayerId then
		return true
	else
		return false
	end
end

--@brief    座位是否被玩家占用
--@param     index:座位的下标
--@return    #1 true：座位被占用，false：座位没被占用
function SceneRoom:_isSeatUsed(index)
	if self.m_tData == nil then 
		WZLog("SceneRoom:_isSeatUsed  m_tData is nil ")
		return
	end 
	if self.m_tData.playerId[ index ] > 0 then
		return true		
	end 
	return false
end 

--@brief  是否可以进行开关座位
--@param  startMode:撮合模式
--@param  需要开关的座位index
--@param  option 1(开) 2(关)
function SceneRoom:isCanCloseOpenSeat(startMode,battleMode,index,option)
	if startMode == 1 and battleMode == 1 then --匹配模式
		return true
	elseif startMode == 2 and battleMode == 1 then --组队模式
		if option == 1 then
			return true
		elseif option == 2 then
			local iPlayerID = 0
			if index == 1 then
				iPlayerID = self.m_tData.playerId[4]
			elseif index == 2 then 
				iPlayerID = self.m_tData.playerId[5]
			elseif index == 3 then
				iPlayerID = self.m_tData.playerId[6]
            elseif index == 4 then
            	iPlayerID = self.m_tData.playerId[1]
            elseif index == 5 then
            	iPlayerID = self.m_tData.playerId[2]
            elseif index == 6 then
            	iPlayerID = self.m_tData.playerId[3]
			end
			if iPlayerID <= 0 then
				return true
			end
		end
	end
	return false
end

--@brief    玩家更换座位
--@param    newSeat:新座位的下标
function SceneRoom:_changePlayerSeat(newSeat)
	local oldSeat = self:_getPlayerSeat()
	WZLog("SceneRoom:_changePlayerSeat ",self.m_tData.roomId, oldSeat, newSeat)
	ProtocolProcessorSceneRoom:send_ROOM_UpdateSeat(self.m_tData.roomId, oldSeat, newSeat )	
end

--@brief  更新座位信息
function SceneRoom:_updateSeatInfo(luaObject,elementObject,index,bgType,isused)
	WZLog("SceneRoom:_updateSeatInfo ",index)
	if luaObject ~= nil then
		luaObject:setBgType(bgType)
		local conCenter = GetElement(self.m_root,"conCenter_SceneRoom",WZUIContainer)
		if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then
			conCenter = GetElement(self.m_root,"conCenter2_SceneRoom",WZUIContainer)
		end
		local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneRoom",WZUIContainer)
		local imgPlayerStats = WZUIImage:luaTo(conSeat:getChildElement("imgPlayerStatus_SceneRoom"))
	    imgPlayerStats:setFile("")
	    local imgReadyStatus = WZUIImage:luaTo(conSeat:getChildElement("imgReadyStatus_SceneRoom"))
	    if imgReadyStatus then
		    imgReadyStatus:setFile("")
		end
	    if isused then
			if self.m_tData.wnersId == self.m_tData.playerId[index] then
				if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX and index <= 3  then
					imgPlayerStats:setFile("ui/common/common_icon_fangzhu.png")
					-- if imgReadyStatus then
					-- 	imgReadyStatus:setFile("ui/hall/common_icon_ghzdls.png")
					-- end   
				else
					imgPlayerStats:setFile("ui/Hall/common_icon_fangzhu02.png")
					-- if imgReadyStatus then
					-- 	imgReadyStatus:setFile("ui/hall/common_icon_xfhb.png")
					-- end 
				end
			else
				if self.m_tData.playerReady[index] then
					if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX and index <= 3 then
						imgPlayerStats:setFile("ui/common/common_icon_zhunbei4.png")
						-- if imgReadyStatus then
						-- 	imgReadyStatus:setFile("ui/hall/common_icon_ghzdls.png")
						-- end
					else
						imgPlayerStats:setFile("ui/Hall/common_icon_zhunbei5.png")
						-- if imgReadyStatus then
						-- 	imgReadyStatus:setFile("ui/hall/common_icon_xfhb.png")
						-- end
					end
				else
					imgPlayerStats:setFile("")
				end
			end
	    end
	    local curD = self.m_tData
	    luaObject:setData(curD.wnersId,curD.seatUsed[index],curD.playerId[index],curD.playerName[index],curD.playerLevel[index],curD.playerReady[index],curD.playerSex[index],curD.vipLevel[index],curD.playerTitle[index],curD.fighting[index],curD.playerNumMode,index,curD.startMode,curD.battleMode,curD.tournamentLevel[index],curD.seatUsed,curD.serviceId[index],curD.roomChannel,curD.playNum[index],curD.winNum[index],curD.tournamentExp[index],curD.winTimes[index],curD.joinTimes[index],curD.continuousWinTimes[index],curD.matchscore[index],curD.qualifyingLevel[index], nil, nil, curD.professionId[index], curD.openStatus[index])
	    luaObject:setSeatInfo(self.m_tData.seatUsed)
	    local friendInfo = self:getFriendRV(self.m_tData.playerId[index])
        luaObject:setFriendInfo(friendInfo)

		local masterInfo = self:getMasterRV(self.m_tData.playerId[index],self.m_tData.playerLevel[index])
		luaObject:setMasterInfo(masterInfo)

		local spouseValue,spuseLevel,wifeName,husbandName = self:getSpouseRV(self.m_tData.playerId[index],self.m_tData.playerSex[index],self.m_tData.playerName[index])
		luaObject:setSpouseInfo(spouseValue,spuseLevel,wifeName,husbandName)

	    luaObject:_update()
	    if self.m_tData.roomChannel ~= GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then  --练习赛
	    	luaObject:setBGRectVisible(false)
	    end
	end
end
--跳转到主城按钮
function SceneRoom:onBtnSecenRoomJumpMain()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local scene = SceneCity:createElement()
    replaceScene(scene)
end
--@brief	创建一个玩家座位
--@param	index:cell的识别
--@param	bgType:背景类型(1:红色,2:蓝色)
--@param    isused:座位是否关闭
--@return	#1:element的引用
--@return	#2:表的引用
function SceneRoom:_createASeat(index,bgType,isused)
	WZLog("SceneRoom:_createASeat",index,bgType,isused)
	local tagType = 1
	local conCenter = GetElement(self.m_root,"conCenter_SceneRoom",WZUIContainer)
	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then
		conCenter = GetElement(self.m_root,"conCenter2_SceneRoom",WZUIContainer)
		tagType = 2
	end

	local cellElement,cellObj = CellRoomSeat:createElement(tagType)
	cellElement:setTag(index)
	cellObj:setBgType(bgType)

	local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneRoom")
	local imgPlayerStats = GetElement(conSeat,"imgPlayerStatus_SceneRoom",WZUIImage)
	imgPlayerStats:setFile("")

	if isused then
		if self.m_tData.wnersId == self.m_tData.playerId[index] then
			if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX and index <= 3  then
				imgPlayerStats:setFile("ui/common/common_icon_fangzhu.png")
			else  
				imgPlayerStats:setFile("ui/Hall/common_icon_fangzhu02.png")
			end
		else
			if self.m_tData.playerReady[index] then
				if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX and index <= 3 then
					imgPlayerStats:setFile("ui/Hall/common_icon_zhunbei5.png")
				else
					imgPlayerStats:setFile("ui/common/common_icon_zhunbei4.png")
				end
			else
				imgPlayerStats:setFile("")
			end
		end
	end
	
	local curD = self.m_tData
	cellObj:setData(curD.wnersId,curD.seatUsed[index],curD.playerId[index],curD.playerName[index],curD.playerLevel[index],curD.playerReady[index],curD.playerSex[index],curD.vipLevel[index],curD.playerTitle[index],curD.fighting[index],curD.playerNumMode,index,curD.startMode,curD.battleMode,curD.tournamentLevel[index],curD.seatUsed,curD.serviceId[index],curD.roomChannel,curD.playNum[index],curD.winNum[index],curD.tournamentExp[index],curD.winTimes[index],curD.joinTimes[index],curD.continuousWinTimes[index],curD.matchscore[index],curD.qualifyingLevel[index], nil, nil, curD.professionId[index], curD.openStatus[index])
    cellObj:setChangeSeatCallBack(self.changeSeatCallBack,SceneRoom)
    cellObj:setCloseSeatCallBack(self.closeSeatCallBack,SceneRoom)
    cellObj:setOpenSeatCallBack(self.openSeatCallBack,SceneRoom)
    cellObj:setSeatInfo(self.m_tData.seatUsed)
    cellObj:setRoomId(self.m_tData.roomId)
    cellObj:setParentRoot(self.m_root)
    local friendInfo = self:getFriendRV(self.m_tData.playerId[index])
    cellObj:setFriendInfo(friendInfo)

    local masterInfo = self:getMasterRV(self.m_tData.playerId[index],self.m_tData.playerLevel[index])
    cellObj:setMasterInfo(masterInfo)

    local spouseValue,spuseLevel,wifeName,husbandName = self:getSpouseRV(self.m_tData.playerId[index],self.m_tData.playerSex[index],self.m_tData.playerName[index])
	cellObj:setSpouseInfo(spouseValue,spuseLevel,wifeName,husbandName)
	return cellElement,cellObj
end

--@brief 显示玩家形象与宠物
function SceneRoom:showPlayerFigureAndPet(index)
	WZLog("SceneRoom:showPlayerFigureAndPet")
	local playerEquipment = {}
	for i=1,5 do
		playerEquipment[i]= self.m_tData.playerEquipment[(index-1)*5+i]
	end
	local conCenter = GetElement(self.m_root,"conCenter_SceneRoom",WZUIContainer)
	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then  --练习赛
		conCenter = GetElement(self.m_root,"conCenter2_SceneRoom",WZUIContainer)
	end
	if self.m_tData.seatUsed[index] and self.m_tData.playerId[index] > 0  then
		local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneRoom",WZUIContainer)
		local conPlayer = GetElement(conSeat,"conPlayer_SceneRoom",WZUIContainer)
		WZLog("显示玩家形象与宠物",self.m_tData.playerId[index])
	    local playerFigure = conPlayer:getChildByTag(self.m_tData.playerId[index])
	    local showMonster = false
	    local indexx = nil
	    local tTempList = nil 
	    if playerFigure ~= nil then
	    	for i,v in ipairs(self.m_tScheduleList) do
		    	if v[2] == self.m_tData.playerId[index] then
		    		indexx = i
		    		break
		    	end
		    end
		    if indexx then
		    	tTempList = CopyTable(self.m_tScheduleList[indexx])

		    	table.remove(self.m_tScheduleList,indexx)
		    end
	    end
    	conPlayer:removeAllChildrenWithCleanup(true)
    	local playerId = self.m_tData.playerId[index]
    	local animAtionName = nil
    	WZLog("HHHHHHHHHHHHHHHHH", type(tTempList), tTempList and tTempList[5] or "nil", tTempList and tTempList[6] or "nil")
        local actionName, mountId = self:getPlayerAction(0, index)
        if mountId > 0 then 
            animAtionName = actionName
            if tTempList and tTempList[5] == true then 
                animAtionName = self:getPlayerAction(1, index)
            end
        else
            animAtionName = actionName
            if tTempList and tTempList[5] == true then 
                animAtionName = self:getPlayerAction(1, index)
            end
        end
    	local scalePlayer = 0.8
    	-- if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then
    	-- 	animAtionName = "avatar"
    	-- 	local image = WZUIImage:create()
    	-- 	image:setFile("ui/hall/battle_scale9_touxiang.png")
    	-- 	image:setUseOriginSize(true)
    	-- 	image:setScale(0.92)
    	-- 	conPlayer:addChild(image)
    	-- 	scalePlayer = 0.5
    	-- end
--    	WZLog("练习赛玩家数据",Serialize(self.m_tData))
    	playerFigure, _, _, showMonster = self:createAPlayer(self.m_tData.playerSex[index],playerEquipment,self.m_tData.headColors[index],self.m_tData.bodyColors[index],animAtionName)
    	playerFigure:getAnimNode():setTag(playerId)
    	if mountId > 0 and not showMonster then 
    		if GDatatab_mounts["id_" .. mountId] then
	            local basicInfo = GDatatab_item["id_" .. GDatatab_mounts["id_" .. mountId].item_id]
	            playerFigure:setMount(basicInfo.animation_index_code)
	            scalePlayer = 0.6
	        end
        end
    	playerFigure:setScale(scalePlayer)
    	if tTempList and tTempList[6] == true then 
            playerFigure:setScaleX(-1 * scalePlayer)
        else
            playerFigure:getAnimNode():setScaleX(scalePlayer)
        end

    	local playerAnimNode = playerFigure:getAnimNode()
    	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then
    		playerFigure:setScale(0.6)
    		playerAnimNode:setRelativePosition(GlobalMethod:ccp(0.5,-0.3))
    		playerAnimNode:setAnchorPoint(GlobalMethod:ccp(0.5,0))

    	end
    	conPlayer:addChild(playerAnimNode)
    	-- if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then
    	-- 	local image = WZUIImage:create()
    	-- 	image:setFile("ui/city/newUI/main_icon_head.png")
    	-- 	image:setUseOriginSize(true)
    	-- 	conPlayer:addChild(image)
    	-- end
    	local countDown = 1.5
    	--[5]是否跑动，[6]翻转
    	local playerInfo  = {playerFigure, playerId, index, countDown, false, false}
    	if tTempList then 
    		playerInfo  = {playerFigure, playerId, index, countDown, tTempList[5], tTempList[6]}
    	end
    	table.insert(self.m_tScheduleList,playerInfo)
	    
	    local conPet = GetElement(conSeat,"conPet_SceneRoom",WZUIContainer)
	    local btnPlayerPet = GetElement(conSeat,"btnPlayerPet_SceneRoom", WZUIButton)
        
        conPet:setRelativePosition(GlobalMethod:ccp(0.207,0.59))
        btnPlayerPet:setRelativePosition(GlobalMethod:ccp(0.207,0.59))
        if tTempList and tTempList[6] == true then 
            conPet:setRelativePosition(GlobalMethod:ccp(0.794,0.59))
            btnPlayerPet:setRelativePosition(GlobalMethod:ccp(0.794,0.59))
        end

	    local petInfo = self.m_tPlayersPetInfo[index]
	    
	    if petInfo ~= nil and petInfo.itemId ~= nil then
	    	local petTag = self.m_tData.playerId[index]+10
	    	local petFigure = conPet:getChildByTag(petTag)
	    	if petFigure == nil then
	    		conPet:removeAllChildrenWithCleanup(true)
	    		local petId = petInfo.itemId
	    		local animation = petInfo.animation
	    		local petAnimation,par = CreatePetAni(conPet,petId,animation,petInfo.advancedLevel, petInfo.petSkinItemId)
	    		petAnimation:getAnimNode():setTag(petTag)
	            petAnimation:setScale(0.65)
				if par then par:setScale(0.65) end
				if tTempList and tTempList[6] == true then 
					petAnimation:getAnimNode():setScaleX(-0.65)
				end
	            petAnimation:getAnimNode():setTouchEnable(false)
	        else
                if tTempList and tTempList[6] == true then 
                    petFigure:setScaleX(-0.65)
                else
                    petFigure:setScaleX(0.65)
                end
	    	end
	    else
	    	local petTag = self.m_tData.playerId[index]+10
	    	local petFigure = conPet:getChildByTag(petTag)
	    	if petFigure == nil then
	    		conPet:removeAllChildrenWithCleanup(true)
	    	end
	    end
	    --名字和称号
	    local conForNameAndTitle = GetElement(conSeat, "conForNameAndTitle_SceneRoom", WZUIContainer)
	    if conForNameAndTitle then
		    local txtPlayerName = GetElement(conSeat, "txtPlayerName_SceneRoom", WZUILabelTTF)
		    txtPlayerName:setText(self.m_tData.playerName[index])
		    local txtPlayerLv = GetElement(conSeat, "txtPlayerLv_SceneRoom", WZUILabelTTF)
		    if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then --排位赛
		    	txtPlayerLv:setText("")
		    elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then --战略赛
		    	txtPlayerLv:setText("")
		    else
		    	txtPlayerLv:setText("Lv" .. self.m_tData.playerLevel[index])
		    end
		    if playerId == CacheCenter:getPlayerInfo().id then
		        txtPlayerName:setColor(GlobalMethod:ccc3(99,255,95))
		    else
		        txtPlayerName:setColor(GlobalMethod:ccc3(255,255,255))
		    end
		    local conTitle = GetElement(conSeat, "conTitle_SceneRoom", WZUIContainer)
		    local txtPlayerTitle = GetElement(conSeat, "txtPlayerTitle_SceneRoom", WZUILabelTTF)
		    local tempPoint = GlobalMethod:ccp(0.5, 1.9)
		    if self.m_tData.playerTitle[index] and self.m_tData.playerTitle[index] ~= "" then
		    	CreateDesiSpine(conTitle, txtPlayerTitle, self.m_tData.playerTitle[index], tempPoint, nil, 0.9)
		    end
		end
		if playerId == CacheCenter:getPlayerInfo().id then
			self:showRoleFootEffect(conPlayer, playerFigure)
		end
	else
		WZLog("有没有进来")
		local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneRoom",WZUIContainer)
		local conPlayer = GetElement(conSeat,"conPlayer_SceneRoom",WZUIContainer)
		local conPet = GetElement(conSeat,"conPet_SceneRoom",WZUIContainer)
		local btnPlayerPet = GetElement(conSeat,"btnPlayerPet_SceneRoom", WZUIButton)
		local txtPlayerName = GetElement(conSeat, "txtPlayerName_SceneRoom", WZUILabelTTF)
		local txtPlayerLv = GetElement(conSeat, "txtPlayerLv_SceneRoom", WZUILabelTTF)
		local txtPlayerTitle = GetElement(conSeat, "txtPlayerTitle_SceneRoom", WZUILabelTTF)
		local conTitle = GetElement(conSeat, "conTitle_SceneRoom", WZUIContainer)
		conPlayer:removeAllChildrenWithCleanup(true)
		conPet:removeAllChildrenWithCleanup(true)
		conPet:setRelativePosition(GlobalMethod:ccp(0.207,0.59))
        btnPlayerPet:setRelativePosition(GlobalMethod:ccp(0.207,0.59))

		if txtPlayerName then
			txtPlayerName:setText("")
		end
		if txtPlayerLv then
			txtPlayerLv:setText("")
		end
		if txtPlayerTitle then
			txtPlayerTitle:setText("")
		end
		if conTitle then
			if conTitle:getChildByTag(444) then
				conTitle:removeChildByTag(444, true)
			end
		end
		
	    if self.m_tScheduleList == nil or #self.m_tScheduleList == 0 then
	    	return
	    end
	    local inde = 0
	    for i,v in ipairs(self.m_tScheduleList) do
	    	if v[3] == index then
	    		inde = i
	    	end
	    end
	    if inde > 0 then
	    	conSeat:stopAllActions()
	    	table.remove(self.m_tScheduleList,inde)
	    end
	end
end

--@brief	创建一个角色动画
function SceneRoom:createAPlayer(playerSex,equipment,headColor,bodyColor,animName)
	WZLog("SceneRoom:createAPlayer")
	local isMonster = nil
	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then
		isMonster = true
	end
	WZLog("创建动画",Serialize(equipment))
	return CreatePlayerFigure(playerSex,equipment,animName,nil,nil,nil,nil,nil,nil,nil,headColor,bodyColor)
end

--@brief 显示足迹
function SceneRoom:showRoleFootEffect(conP, conPlayer)
    local footId = CacheCenter:getUsingFootMarkId()
    if footId == nil then 
    	self.m_sRoleFootSpine = nil
    	return nil 
    end
    if not self.m_sRoleFootSpine then
    	if conP and conPlayer then
	        self.m_sRoleFootSpine = FootEffectManager:addEffect1(conP, footId, conPlayer:getPosition(),true,20,nil,nil,-100)
	    end
    end
end

--@brief  根据index打开、关闭对应的座位
function SceneRoom:findCanOpenOrCloseSeat(index)

	if self.m_tData.startMode == 1 then --匹配模式(1-1 2-2 3-3)
		return index+3 

	elseif self.m_tData.startMode == 2 then --自由模式
		if index > 3 then
			if self.m_tData.playerId[index-3] == 0 then
			  return index - 3
			else
				for i=1,3 do
					if self.m_tData.playerId[i] == 0 then
						return i
					else
						return -1
					end
				end
		    end
		else 
			if self.m_tData.playerId[index+3] == 0 then
			  return index + 3
			else
				for i=4,6 do
					if self.m_tData.playerId[i] == 0 then
						return i
					else
						return -1
					end
				end
		    end
		end
	elseif self.m_tData.startMode == 3 then --混战模式
		return index
	end
end

--@breif  更新玩家的动作
function SceneRoom:updatePlayerAnimation(element,delta)
	local isPlayRelax = false
	local countPlayer = #self.m_tScheduleList
    for i=1,countPlayer do
        local randomCount = math.random(5,14)
        if self.m_tScheduleList[i] and self.m_tScheduleList[i][5] == false then 
        	local actionName, mountId = self:getPlayerAction(0, self.m_tScheduleList[i][3])
            if self.m_tScheduleList[i][1]:isPlaying(actionName) == false then
                self.m_tScheduleList[i][1]:play(actionName,true)
            end
            if self.m_tScheduleList[i][4] >= randomCount then
            	local randomTemp = math.random(1, 100)
            	if mountId == 0 and math.fmod(randomTemp, 3) == 0 then 
            		self.m_tScheduleList[i][1]:play(g_tRoleAnitionName[2], false)
            		self.m_tScheduleList[i][4] = 1.5
            	else
	            	local conCenter = GetElement(self.m_root, "conCenter_SceneRoom", WZUIContainer)
	                local conSeat = GetElement(conCenter, "conSeat" .. self.m_tScheduleList[i][3] .. "_SceneRoom", WZUIContainer)
	                local posCur = conSeat:getRelativePosition()
	                actionName, mountId = self:getPlayerAction(1, self.m_tScheduleList[i][3])
	                self.m_tScheduleList[i][1]:play(actionName, true)

	                local moveTo = WZUIActionMoveTo:create()
	                local randomX = math.random(1,100)
	                moveTo:setMoveX(randomX/100)
	                local conPet = GetElement(conSeat, "conPet_SceneRoom", WZUIContainer)
	                local btnPlayerPet = GetElement(conSeat, "btnPlayerPet_SceneRoom", WZUIButton)
	                if randomX > posCur.x * 100 then 
	                    if self.m_tScheduleList[i][6] == true then 
	                        local playerAnimNode = self.m_tScheduleList[i][1]:getAnimNode()
	                        local nScaleX = playerAnimNode:getScaleX()
	                        if nScaleX < 0 then 
	                            playerAnimNode:setScaleX(-1 * nScaleX)
	                        end
	                        self.m_tScheduleList[i][6] = false

	                        local petTag = self.m_tScheduleList[i][2]+10
	                        local petFigure = conPet:getChildByTag(petTag)
	                        if petFigure then 
	                            local nPetScaleX = petFigure:getScaleX()
	                            if nPetScaleX < 0 then 
	                                petFigure:setScaleX(-1 * nPetScaleX)
	                            end
	                        end

	                        conPet:setRelativePosition(GlobalMethod:ccp(0.207,0.59))
	                        btnPlayerPet:setRelativePosition(GlobalMethod:ccp(0.207,0.59))
	                    elseif self.m_tScheduleList[i][6] == false then 
	                        local playerAnimNode = self.m_tScheduleList[i][1]:getAnimNode()
	                        local nScaleX = playerAnimNode:getScaleX()
	                        if nScaleX < 0 then 
	                            playerAnimNode:setScaleX(-1 * nScaleX)
	                        end

	                        local petTag = self.m_tScheduleList[i][2]+10
	                        local petFigure = conPet:getChildByTag(petTag)
	                        if petFigure then 
	                            local nPetScaleX = petFigure:getScaleX()
	                            if nPetScaleX < 0 then 
	                                petFigure:setScaleX(-1 * nPetScaleX)
	                            end
	                        end

	                        conPet:setRelativePosition(GlobalMethod:ccp(0.207,0.59))
	                        btnPlayerPet:setRelativePosition(GlobalMethod:ccp(0.207,0.59))
	                    end
	                else
	                    if self.m_tScheduleList[i][6] == false then 
	                        local playerAnimNode = self.m_tScheduleList[i][1]:getAnimNode()
	                        local nScaleX = playerAnimNode:getScaleX()
	                        if nScaleX > 0 then 
	                            playerAnimNode:setScaleX(-1 * nScaleX)
	                        end
	                        self.m_tScheduleList[i][6] = true

	                        local petTag = self.m_tScheduleList[i][2]+10
	                        local petFigure = conPet:getChildByTag(petTag)
	                        if petFigure then 
	                            local nPetScaleX = petFigure:getScaleX()
	                            WZLog("LLLLLLLLLLLL", nPetScaleX)
	                            if nPetScaleX > 0 then 
	                                petFigure:setScaleX(-1 * nPetScaleX)
	                            end
	                        end

	                        conPet:setRelativePosition(GlobalMethod:ccp(0.794,0.59))
	                        btnPlayerPet:setRelativePosition(GlobalMethod:ccp(0.794,0.59))
	                    elseif self.m_tScheduleList[i][6] == true then 
	                        local playerAnimNode = self.m_tScheduleList[i][1]:getAnimNode()
	                        local nScaleX = playerAnimNode:getScaleX()
	                        if nScaleX > 0 then 
	                            playerAnimNode:setScaleX(-1 * nScaleX)
	                        end

	                        local petTag = self.m_tScheduleList[i][2]+10
	                        local petFigure = conPet:getChildByTag(petTag)
	                        if petFigure then 
	                            local nPetScaleX = petFigure:getScaleX()
	                            if nPetScaleX > 0 then 
	                                petFigure:setScaleX(-1 * nPetScaleX)
	                            end
	                        end

	                        conPet:setRelativePosition(GlobalMethod:ccp(0.794,0.59))
	                        btnPlayerPet:setRelativePosition(GlobalMethod:ccp(0.794,0.59))
	                    end
	                end
	                local randomY = math.random(80,145)
	                moveTo:setMoveY(randomY/100)
	                moveTo:setDuration(2)
	                moveTo:setFinishLuaFunction("actionFinishRemove")
	                conSeat:runUIAction(moveTo)

	                self.m_tScheduleList[i][5] = true
	                if self.m_sRoleFootSpine and self.m_tScheduleList and self.m_tScheduleList[i][2] == CacheCenter:getPlayerInfo().id then
	                	if self.m_tScheduleList[i][6] == true then
	                		self.m_sRoleFootSpine:setPositionX(150)
	                		self.m_sRoleFootSpine:setFlipX(true)
	                	else
	                		self.m_sRoleFootSpine:setPositionX(-50)
	                		self.m_sRoleFootSpine:setFlipX(false)
	                	end
	                end
	            end
            else
                self.m_tScheduleList[i][4] = self.m_tScheduleList[i][4] + delta
            end
        end
    end
end

--@brief    跑动动作完成后的处理
function SceneRoom:actionFinishRemove(element)
    --body
    local nTag = element:getTag()
    local countPlayer = #self.m_tScheduleList
    for i = 1, countPlayer do
        if self.m_tScheduleList[i] and self.m_tScheduleList[i][3] == nTag then
            self.m_tScheduleList[i][5] = false
            self.m_tScheduleList[i][4] = 1.5
            local actionName, mountId = self:getPlayerAction(0, self.m_tScheduleList[i][3])
            self.m_tScheduleList[i][1]:play(actionName, true)
            break 
        end
    end
end

--@brief    展示选中玩家的信息
function SceneRoom:showSelPlayerInfo(nPlayerSeat)
    -- body
    if self.m_root == nil then return end 

    GetElement(self.m_root, "conSelPlayerInfo_SceneRoom", WZUIContainer):setVisible(true)
    self.m_nSelVipLevel = self.m_tData.vipLevel[nPlayerSeat]
    self.m_nSelPlayerSeatIndex = nPlayerSeat

    local playerEquipment = {}
    for i=1,5 do
        playerEquipment[i]= self.m_tData.playerEquipment[(nPlayerSeat-1)*5+i]
    end
    WZLog("SceneRoom:showSelPlayerInfo", Serialize(playerEquipment), self.m_nSelPlayerSeatIndex)
    local headId, faceId 
    for i = 1, #playerEquipment do
        local basicInfo = GDatatab_item["id_" .. playerEquipment[i]]
        if basicInfo then 
	        if basicInfo.main_type == 5 and basicInfo.sub_type == 0 then 
	            headId = playerEquipment[i]
	        elseif basicInfo.main_type == 5 and basicInfo.sub_type == 1 then 
	            faceId = playerEquipment[i]
	        end
	    end
    end

    local conSelHead = GetElement(self.m_root, "conSelHead_SceneRoom", WZUIContainer)
    local txtSelName = GetElement(self.m_root, "txtSelName_SceneRoom", WZUILabelTTF)
    CellHead:show(conSelHead, headId, faceId, self.m_tData.playerSex[nPlayerSeat], nil, nil, 0,  self.m_tData.headColors[nPlayerSeat])
    txtSelName:setText(self.m_tData.playerName[nPlayerSeat])
end

--@brief    刷新玩家的层级
function SceneRoom:updatePlayerZOrder(element, delta)
    -- body
    local countPlayer = #self.m_tScheduleList
    for i=1,countPlayer do
    	if self.m_tScheduleList[i] then
	        local conSeat = GetElement(self.m_root, "conSeat" .. self.m_tScheduleList[i][3] .. "_SceneRoom", WZUIContainer)
	        local posCur = conSeat:getRelativePosition()

	        conSeat:setZOrder(math.ceil(150 - posCur.y * 100))
	    end
    end
end
-------------------------------------回调方法模块Begin----------------------------------------

--@brief	地图按钮点击回调
--@param 	element:button的引用
function SceneRoom:onMapBtnClick(element)
	WZLog("SceneRoom:onMapBtnClick")
	if not self.m_bCanClickSeat then
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
		return 
	end
	if self:getIsRoomOwner() then
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		local battleMode = self.m_tData.battleMode
		if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZ and battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_JJ then 
			if WndBossRoomSetting.m_root == nil then
				WndBossRoomSetting:showInterface(1)
			    WndBossRoomSetting:initRoomInfo2(self.m_tData.mapId, self.m_tData.roomName, self.m_tData.roomPassword, self.m_tData.startMode, self.m_tData.roomChannel, self.m_tData.battleMode, self.m_tData.startMode, self.m_tData.playerNumMode)
			    WndBossRoomSetting:setBackButtonCallback(SceneRoom, self.updateRoomSettingTwo)
			end
		elseif self.m_tData.roomChannel ~= GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then  --练习赛
			if WndBossRoomSetting.m_root == nil then
				WndBossRoomSetting:showInterface(2)
			    WndBossRoomSetting:initRoomInfo2(self.m_tData.mapId, self.m_tData.roomName, self.m_tData.roomPassword, self.m_tData.startMode, self.m_tData.roomChannel, self.m_tData.battleMode, self.m_tData.startMode, self.m_tData.playerNumMode)
			    WndBossRoomSetting:setBackButtonCallback(SceneRoom, self.updateRoomSettingTwo)
			end
		else
			if WndRoomSetting.m_root == nil then
				local roomSetting = WndRoomSetting:createElement()
			    WindowManager:addWindow(roomSetting,WndRoomSetting,nil,nil,nil,false)
			    WndRoomSetting:initRooInfo(self.m_tData.mapId,self.m_tData.roomName,self.m_tData.roomPassword,self.m_tData.startMode,self.m_tData.roomChannel,self.m_tData.battleMode,self.m_tData.startMode)
			    WndRoomSetting:setBackButtonCallback(SceneRoom,self.updateRoomSetting)
			end
		end
	end
end

--@brief  更新房间设置
--@param roomName : 房间名字
--@param roomPass : 房间密码
--@param mapId : 地图ID
function SceneRoom:updateRoomSetting(roomName,roomPass,mapId,startMode,battleMode)
	WZLog("SceneRoom:updateRoomSetting ",roomName,roomPass,mapId,startMode,battleMode)
	if self.m_tData.roomName == roomName and self.m_tData.roomPassword == roomPass and self.m_tData.mapId == mapId and self.m_tData.startMode == startMode and self.m_tData.battleMode == battleMode then
	   return
	end
	if startMode == 1 and self.m_tData.startMode ~= startMode then
		local nullCount = self:getAllNULLSeat()
		if self.m_tData.playerNumMode == 1 and nullCount <= 4 then
		   MsgBoxManager:showTipBox(LocalStrings.CHANGE_MATCH_ERROR)
		   return
	    end
		if 6-nullCount >3 then
		    MsgBoxManager:showTipBox(LocalStrings.CHANGE_MATCH_ERROR)
		    return
	    end
	end
	local playerNumMode = self.m_tData.playerNumMode
	
	ProtocolProcessorSceneRoom:send_ROOM_UpdateRoom(self.m_tData.roomId, battleMode, playerNumMode, roomPass, mapId, startMode, roomName)
end

--@brief  更新房间设置
--@param roomName : 房间名字
--@param roomPass : 房间密码
--@param mapId : 地图ID
function SceneRoom:updateRoomSettingTwo(roomName, roomPass, mapId, startMode, battleMode, playerNumMode)
	WZLog("SceneRoom:updateRoomSettingTwo ",roomName, roomPass, mapId, startMode, battleMode, playerNumMode)
	if self.m_tData.roomName == roomName and self.m_tData.roomPassword == roomPass and self.m_tData.mapId == mapId and self.m_tData.startMode == startMode and self.m_tData.battleMode == battleMode and self.m_tData.playerNumMode == playerNumMode then
	   return
	end
	if startMode == 1 and self.m_tData.startMode ~= startMode then
		local nullCount = self:getAllNULLSeat()
		if self.m_tData.playerNumMode == 1 and nullCount <= 4 then
		   MsgBoxManager:showTipBox(LocalStrings.CHANGE_MATCH_ERROR)
		   return
	    end
		if 6-nullCount >3 then
		    MsgBoxManager:showTipBox(LocalStrings.CHANGE_MATCH_ERROR)
		    return
	    end
	end
	local playerNum = self:_getPlayerNum()
	if playerNum > playerNumMode then 
		MsgBoxManager:showTipBox(LocalStrings.CHANGE_MATCH_ERROR)
		return 
	end
	
	ProtocolProcessorSceneRoom:send_ROOM_UpdateRoom(self.m_tData.roomId, battleMode, playerNumMode, roomPass, mapId, startMode, roomName)
end

--@brief  关闭座位
--@param index:关闭的座位index
function SceneRoom:closeSeatCallBack(element,index)
	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW  then -- 排位赛

	elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then -- 战略赛
	
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DJ and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --道具赛
		return
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DZ and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --队长赛
		return
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_FH and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --复活赛
		return
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_WK and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --挖坑赛
		return 
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_JH and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --挖坑赛
    	return
    end
	if not self.m_bCanClickSeat then
		MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
		return
	end
	if self:isCanCloseOpenSeat(self.m_tData.startMode,self.m_tData.battleMode,index,2) then
        ProtocolProcessorSceneRoom:send_ROOM_TurnOffSeat(self.m_tData.roomId,index-1)
	else
		MsgBoxManager:showTipBox(LocalStrings.CLOSE_SETAT_TIP)
	end
end

--@brief  打开座位
--@param  index : 打开座位
function SceneRoom:openSeatCallBack(element,index)
    if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW  then -- 排位赛

	elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then -- 战略赛
	
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DJ and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --道具赛
		return
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DZ and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --队长赛
		return
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_FH and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --复活赛
		return
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_WK and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --挖坑赛
		return 
    elseif self.m_tData.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_JH and self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then --挖坑赛
    	return 
    end
	if not self.m_bCanClickSeat then
		MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
		return
	end
    ProtocolProcessorSceneRoom:send_ROOM_TurnOnSeat(self.m_tData.roomId, index-1)
end

--@brief 获取排位赛玩家房间人数
function SceneRoom:getPwPlayerNum()
	local num = 0
	for i,v in ipairs(self.m_tData.playerId) do
		if v>0 then
			num = num + 1
		end
	end
	WZLog("获取排位赛玩家房间人数",num)
	return num 
end



--@brief  邀请玩家
function SceneRoom:onClickInvPlayer(element)
	WZLog("SceneRoom:onClickInvPlayer")
	if not self.m_bCanClickSeat then
		MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
 		return
 	end

    if not self:hasNullSeat() then
    	MsgBoxManager:showTipBox(LocalStrings.HALL_NO_SEAT)
    	return
    end

 	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
		local totalLevel = 0
		local count = 0
		for i,v in ipairs( self.m_tData.qualifyingLevel) do
			totalLevel = totalLevel + v
		end

		for i,v in ipairs(self.m_tData.playerId) do
			if v > 0 then
				count = count + 1
			end
		end
		local averageLevel = math.ceil(totalLevel / count)
		WZLog("averageLevel = ",averageLevel,count,totalLevel)
		WndFriendList:showInterface(11,SceneRoom,self.inviteFriends,averageLevel)
	elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then
		local totalLevel = 0
		local count = 0
		for i,v in ipairs( self.m_tData.qualifyingLevel) do
			totalLevel = totalLevel + v
		end

		for i,v in ipairs(self.m_tData.playerId) do
			if v > 0 then
				count = count + 1
			end
		end
		local averageLevel = math.ceil(totalLevel / count)
		WZLog("averageLevel = ",averageLevel,count,totalLevel)
		WndFriendList:showInterface(20,SceneRoom,self.inviteFriends,averageLevel)
	elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL or self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ  then
		WndFriendList:showInterface(12,SceneRoom,self.inviteFriends)
	else
		WndFriendList:showInterface(3,SceneRoom,self.inviteFriends)
	end
 	WndFriendList:setInviteFriendIds(self.m_tData.playerId)
end

--@brief	邀请好友回调
--@param	playerID:好友ID
function SceneRoom:inviteFriends(tFriend, m1,m2,m3)
	WZLog("SceneRoom:inviteFriends ",tFriend,tFriend.id)
    for i,v in ipairs(self.m_tData.playerId) do
    	if v == tFriend.id then
    	   MsgBoxManager:showTipBox(LocalStrings.BATTLETEAM_PLAYER_ALREADY_ROOM)
    	   return
    	end
    end
    if tFriend==nil or tFriend.id == nil then
       return
    end
    if m3 and m3 == 6 then
    	ProtocolProcessorSceneRoom:send_ROOM_Invite(self.m_tData.roomId, tFriend.id, 2)
    else
		ProtocolProcessorSceneRoom:send_ROOM_Invite(self.m_tData.roomId, tFriend.id)
	end
end

--@brief 换位
function SceneRoom:changeSeatCallBack(element,index)
	if not self.m_bCanClickSeat then
		MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
		return
	end
	local oldSeat = 0
	for i,v in ipairs(self.m_tData.playerId) do
		if v == GlobalGame.g_tPlayerInfo.nPlayerId then
			if self.m_tData.playerReady[i] and not self:getIsRoomOwner() then
				MsgBoxManager:showTipBox(LocalStrings.CHANGE_SEAT_TIPS)
				return
		    end
			oldSeat = i
		end
	end
	index = index -1
	oldSeat = oldSeat -1
	ProtocolProcessorSceneRoom:send_ROOM_UpdateSeat(self.m_tData.roomId,oldSeat,index)
end

--@brief    关闭按钮点击回调
--@param 	element:button的引用
function SceneRoom:onCloseClick(element)
	WZLog("SceneRoom:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	if self.m_tData == nil or self.m_root == nil then
		WZLog("SceneRoom:onBackSceneCallback m_tData is nil")
		return
	end

	local seatI = self:_getPlayerSeat()
	if self.m_tData.playerReady[seatI + 1] and not self:getIsRoomOwner() then
		MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
		return
	end
	
	self.m_nClickBackCount = self.m_nClickBackCount + 1
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
	ProtocolProcessorSceneRoom:send_ROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat())
	
	if self.m_nClickBackCount > 3 then --点击退出房间大于3次则直接退出房间
		self.m_nClickBackCount = 0
		self:receiveQuitRoomOk(nil)
		return
	end
end

--@brief   座位点击事件
function SceneRoom:onClickCellRoomSeat(element)
	WZLog("SceneRoom:onClickCellRoomSeat")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	local index = element:getTag()

	if not self.m_bCanClickSeat then
		if self.m_tData.playerId[index] == nil then 
			MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
			return
		end
	end
	if self:getIsRoomOwner() and self.m_tData.playerId[index] ~= CacheCenter:getPlayerInfo().id and self.m_tData.roomChannel ~= GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then 
        self:showSelPlayerInfo(index)
    else
		WndCheckOther:show(self.m_tData.playerId[index])
	end
end 

function SceneRoom:scheduleCalculate(element)
	WZLog("SceneRoom:scheduleCalculate")
	element:disableSchedule()
	self.m_nCount = 0
end

--@brief  取消匹配成功
function SceneRoom:cancelMatchingOk()
	if not self.m_root then
		return
	end
	WZLog("SceneRoom:cancelMatchingOk")
	SceneRoom:closeLoading()
	self.m_bStartGame = false
	self:endPairTimer()
	if self:getIsRoomOwner() then
		self:changeStartGameBtn("ui/common/common_icon_ksyx.png")
	end
	self:setAllBtnStats(true)

	TeachGroup1:startGroup({20,5,SceneRoom.m_root})
end

function SceneRoom:scheduleReplace(element)
    element:disableSchedule()
    local sceneCity = SceneCity:createElement()
    if sceneCity ~= nil then 
        replaceScene(sceneCity)
    end 
end

--@brief	准备游戏按钮点击回调
--@param 	element:button的引用
function SceneRoom:onStartGameC(element)
	WZLog("SceneRoom:onStartGameC = ",self.m_nCount)
    WZLog("SceneRoom:onStartGameC=roomChannel,battleMode", self.m_tData.roomChannel, self.m_tData.battleMode)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local bVisible = GetElement(self.m_root, "conSmallMark_SceneRoom", WZUIContainer):isVisible()
    if not self.m_bCanClickSeat and bVisible then 
    	MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
    	return 
    end
    WindowManager:removeTeachShelterLayer()
    if self.m_nCount == 0 then
    	self.m_nCount = 1
    	element:enableSchedule("scheduleCalculate",0.8)
    else
    	return
    end

    if self:getIsRoomOwner() then
    	if self:isStartGame() then
    		self.m_nLoadingId = MsgBoxManager:showLoadingBox(5)
    		ProtocolProcessorSceneRoom:send_ROOM_EndPair(self.m_tData.roomId)
    		return
    	end
    end

	if self:getIsRoomOwner()  then
		if self:_getIsCanStart() == 3 then
			MsgBoxManager:showTipBox(LocalStrings.ROOM_HAVE_NOT_READY)
			return 
		elseif self:_getIsCanStart() == 4 then
			MsgBoxManager:showTipBox(LocalStrings.ROOM_TEXT1)
			return 
		elseif self:_getIsCanStart() == false then
			MsgBoxManager:showTipBox(LocalStrings.NOT_START_GAME)
			return 
		end
	end
	if self:getIsRoomOwner()  then
		WZLog("send_ROOM_MakePair",self.m_tData.roomId)
		if CacheCenter:getPlayerInfo().level == 8 then 
			PostPlayerEvent:postEvent(PostPlayerEvent.event_eightLvClickStart)
		end
		ProtocolProcessorSceneRoom:send_ROOM_MakePair(self.m_tData.roomId,self.m_tData.roomChannel,self.m_tData.sechedule,self.m_tData.battleMode,self.m_tData.playerNumMode)
		local conBg = GetElement(self.m_root,"conBg_SceneRoom",WZUIContainer)
		conBg:enableSchedule("scheduleMoninerLoading",30)
		self:receiveMakePairring(self.m_tData.roomId)
	else
		if self.m_bStartGame then
			MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY_ERROR)
		else
			self:changeReadyStatus()
		end
	end
	--删除掉弹出框
	if self.m_nDialogLuaObj ~= nil then 
		self.m_nDialogLuaObj:removeDialog()
		self.m_nDialogLuaObj = nil
	end 
end


--loading 30秒自动把顶部导航栏设置为可点击
function SceneRoom:scheduleMoninerLoading(element)
	WZLog("SceneRoom:scheduleMoninerLoading")
	local imgStartGame = GetElement(self.m_root,"imgStartGame_SceneRoom",WZUIImage)
	local imgFile = imgStartGame:getFile()
	if imgFile == "ui/common/common_icon_ksyx.png" then
		element:disableSchedule()
		self.m_tTopHangle:setTopTouchEnable(true)
	end
end


function SceneRoom:_updateCheckPlayerState(element,dt)
    --发送心跳协议
    if self.m_fShakeHands == nil then
        self.m_fShakeHands = 0;
    end
    if os.time() - self.m_fShakeHands > BattleConstants.g_fShakeHandsTime and NetManager.g_bConnectFailed ~= true then
        self.m_fShakeHands = os.time()
        WZLog("send battle handshake=================")
        ProtocolProcessorBattleInterface:send_SYSTEM_BattleShakeHands(0)
    end

	local allReady = true
	if self.m_tData then
		for i,v in ipairs(self.m_tData.playerId) do
			if v > 0 then
				if self.m_tData.playerReady[i] ==false then
					allReady = false
				end
			end
		end
		GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change",'state_room_arean',self.m_tData.roomId,self:_getPlayerNum(),self:_getPlayerSeat(),allReady)
	end    
end

--@brief  匹配时与不时在匹配时需要控制的UI控件
--@param  matching ：是否正在匹配
function SceneRoom:controlUIElementVisible(matching)
	WZLog("SceneRoom:controlUIElementVisible")
	local conMark = GetElement(self.m_root,"conMark_SceneRoom",WZUIContainer)
	local btnCancel = GetElement(conMark,"btnCancel",WZUIButton)
	local btnHangup = GetElement(conMark,"btnHangup_SceneRoom",WZUIButton)
	if matching then
		conMark:setVisible(true)
		if self:getIsRoomOwner() then
			btnCancel:setVisible(true)
			btnCancel:setRelativePosition(GlobalMethod:ccp(0.75,0.106))
			btnHangup:setRelativePosition(GlobalMethod:ccp(0.25,0.106))
			btnHangup:setVisible(true)
		else
			btnCancel:setVisible(false)
			btnHangup:setVisible(true)
			btnHangup:setRelativePosition(GlobalMethod:ccp(0.5,0.106))
		end
	else
		GetElement(self.m_root,"conSmallMark_SceneRoom",WZUIContainer):setVisible(false)
		conMark:setVisible(false)
	end

	if not self:getIsRoomOwner() then
		btnCancel:setVisible(false)
		btnHangup:setVisible(true)
	end
end

function SceneRoom:onRuleClick()
	WZLog("SceneRoom:onRuleClick",self.m_tData.roomChannel)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tData.battleMode == 6 then --道具赛
    	WndSingleMapDesc:showInterface(LocalStrings.YULE_FIGHT_RULE3)
    elseif self.m_tData.battleMode == 4 then --队长赛
    	WndSingleMapDesc:showInterface(LocalStrings.YULE_FIGHT_RULE2)
    elseif self.m_tData.battleMode == 2 then --复活赛
    	WndSingleMapDesc:showInterface(LocalStrings.YULE_FIGHT_RULE5)
    elseif self.m_tData.battleMode == 5 then --挖坑赛
    	WndSingleMapDesc:showInterface(LocalStrings.YULE_FIGHT_RULE1)
    end
end

------语音聊天
--@brief    加入语音聊天室
function SceneRoom:joinVoice()
	if self.m_bIsTryJoinVoice ~= true then
	    GlobalGame.m_sVoiceRoomName = "room_" .. self.m_tData.roomChannel .. "_" .. self.m_tData.battleMode .. "_" .. self.m_tData.roomId
	    local isOk =  WGCloudVoiceNotify:JoinTeamRoom(GlobalGame.m_sVoiceRoomName)
	    WZLog("SceneRoom:joinVoice", GlobalGame.m_sVoiceRoomName, isOk, type(isOk))
	    if isOk ~= 0 then
	    	self.m_bIsTryJoinVoice = true
		    local call=CCCallFunc:create(function() 
		    			self.m_bIsTryJoinVoice = false
						self:joinVoice()
					end)
			local delay =  CCDelayTime:create(0.2)
			local array = CCArray:create()
			array:addObject(delay)
			array:addObject(call)
		    self.m_root:runAction(CCSequence:create(array))
		else
			self.m_bIsVoiceState = true
			self.m_bIsTryJoinVoice = false
		end
	end
end

--@brief    离开语音聊天室
function SceneRoom:quitVoice()
    WZLog("SceneRoom:quitVoice", GlobalGame.m_sVoiceRoomName)
    if GlobalGame.m_sVoiceRoomName == nil then return end
    WGCloudVoiceNotify:QuitRoom(GlobalGame.m_sVoiceRoomName)
    GlobalGame.m_sVoiceRoomName = nil
    GlobalGame.m_nVoiceId = nil
end

--@brief    语音聊天室成员状态回调
--0 停止说话
--1 开始说话
--2 继续说话
function SceneRoom:voiceMemberState(state)
    WZLog("SceneRoom:voiceMemberState one", Serialize(state))
    local index = -1
    for j=1,state.count do
        for i,v in pairs(self.m_tVoiceId) do
            local offset = (j-1) * 2
            WZLog("SceneRoom:voiceMemberState two-0", j, i, offset)
            if v == state.members[1 + offset] then
            	index = i
                WZLog("SceneRoom:voiceMemberState three", state.members[2 + offset])

                if SceneRoom.m_tMicState[index] == 1 then
                	local conCenter = GetElement(self.m_root,"conCenter_SceneRoom",WZUIContainer)
					if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then  --练习赛
						conCenter = GetElement(self.m_root,"conCenter2_SceneRoom",WZUIContainer)
					end
                	local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneRoom",WZUIContainer)
                	local anim = GetElement(conSeat,"animFigureVoice_SceneRoom",WZUISpine)
	                local img = GetElement(conSeat,"imgFigureVoice_SceneRoom",WZUIImage)
	                local file
	                local isGray
	                if state.members[2 + offset] == 0 then
						img:setVisible(true)
						anim:setVisible(false)
	                elseif state.members[2 + offset] == 1 or state.members[2 + offset] == 2 then
	                    img:setVisible(false)
	                    anim:setVisible(true)
	                end
	            end
                break
            end
        end
    end
end

--@brief    开启语音按钮定时器
function SceneRoom:openVoiceTimer()
	self.m_nVoiceTimer = 0.4
	local call=CCCallFunc:create(function() 
				self:closeVoiceTimer()
			end)
	local delay =  CCDelayTime:create(self.m_nVoiceTimer)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(call)
    self.m_root:runAction(CCSequence:create(array))
end

--@brief    关闭语音按钮定时器
function SceneRoom:closeVoiceTimer()
	self.m_nVoiceTimer = 0
end

--@brief	听筒按钮点击后的Lua回调
function SceneRoom:onClickSpeaker(sender, state, isNoSend)
	if TeachGroup1.ISBATTLE == true then
        return
    end

    if GetPlayTalk() == 1 then
    	MsgBoxManager:showConfirmCancelBox(LocalStrings.VOICE_OPENSTR or "", self, self.onClickSpeakerCall, nil)
    	return
    end

    if not WGCloudVoiceNotify:IsSupportVoice() then
        MsgBoxManager:showTipBox(LocalStrings.VOICE_NOSUPPORT or "")
        return
    end

	if self.m_nVoiceTimer > 0 and sender then
		MsgBoxManager:showTipBox(LocalStrings.VOICE_CLICKMORE or "")
		return
	end

    if sender then
    	self:openVoiceTimer()
	end
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndBattleHud:onClickSpeaker", self.m_nSpeakerState, state)
    if state then
        if state ~= self.m_nSpeakerState then
            return
        end
        self.m_nSpeakerState = state
    end
    if self.m_nSpeakerState == 0 then
        WGCloudVoiceNotify:OpenSpeaker()
        GetElement(self.m_root,"imgSpeaker1_SceneRoom",WZUIImage):setGrayRender(false)
        GetElement(self.m_root,"imgSpeaker2_SceneRoom",WZUIImage):setGrayRender(false)
    else
        WGCloudVoiceNotify:CloseSpeaker()
        GetElement(self.m_root,"imgSpeaker1_SceneRoom",WZUIImage):setGrayRender(true)
        GetElement(self.m_root,"imgSpeaker2_SceneRoom",WZUIImage):setGrayRender(true)
    end
    
    if self.m_nSpeakerState == 1 then
        self:onClickMic(nil, 1, true)
    end
    self.m_nSpeakerState = 1 - self.m_nSpeakerState

    if self.m_bIsVoiceState == false then
		self:joinVoice()
	elseif isNoSend == nil then
    	ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "2," .. self.m_nSpeakerState, 0 )
	end
end

function SceneRoom:onClickSpeakerCall(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local data = WZDataFile:getInstance():getUserData()
		if data then		
			data:setStringValue("TalkData", "playTalk", "0")
			data:flush()
		end
		self:onClickSpeaker(true)
	end
end

function SceneRoom:onClickMicCall(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local data = WZDataFile:getInstance():getUserData()
		if data then		
			data:setStringValue("TalkData", "playTalk", "0")
			data:flush()
		end
		self:onClickMic(true)
	end
end

--@brief    麦克风按钮点击后的Lua回调
function SceneRoom:onClickMic(sender, state, isNoSend)
	if TeachGroup1.ISBATTLE == true then
        return
    end

    if GetPlayTalk() == 1 then
    	MsgBoxManager:showConfirmCancelBox(LocalStrings.VOICE_OPENSTR or "", self, self.onClickMicCall, nil)
    	return
    end

    if not WGCloudVoiceNotify:IsSupportVoice() then
        MsgBoxManager:showTipBox(LocalStrings.VOICE_NOSUPPORT or "")
        return
    end
    
	if self.m_nVoiceTimer > 0 and sender then
		MsgBoxManager:showTipBox(LocalStrings.VOICE_CLICKMORE or "")
		return
	end

	if sender then
    	self:openVoiceTimer()
	end
    --SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndBattleHud:onClickMic one", self.m_nMicState)
    
    if state then
        if state ~= self.m_nMicState then
            return
        end
        self.m_nMicState = state
    end

    if self.m_nMicState == 0 then
        WGCloudVoiceNotify:OpenMic()
        GetElement(self.m_root,"imgMic1_SceneRoom",WZUIImage):setGrayRender(false)
        GetElement(self.m_root,"imgMic2_SceneRoom",WZUIImage):setGrayRender(false)
    else
        WGCloudVoiceNotify:CloseMic()
        GetElement(self.m_root,"imgMic1_SceneRoom",WZUIImage):setGrayRender(true)
        GetElement(self.m_root,"imgMic2_SceneRoom",WZUIImage):setGrayRender(true)
    end
    
    if self.m_nMicState == 0 then
        self:onClickSpeaker(nil, 0, true)
    end

    if self.m_nMicState == 1 then
        WZLog("WndBattleHud:onClickMic two")
        --self:onClickSpeaker(nil, 1 - self.m_nSpeakerState)
        local call=CCCallFunc:create(function() 
                self:onClickSpeaker(nil, 1 - self.m_nSpeakerState)
            end)
        local delay =  CCDelayTime:create(1)
        local array = CCArray:create()
        array:addObject(delay)
        array:addObject(call)
        self.m_root:runAction(CCSequence:create(array))
    end
    self.m_nMicState = 1 - self.m_nMicState

    if self.m_bIsVoiceState == false then
		self:joinVoice()
	elseif isNoSend == nil then
    	ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "3," .. self.m_nMicState, 0 )
	end
end

--@brief    检查是否可以语音
function SceneRoom:checkVoice()
	local isVoice = false
	WZLog("SceneRoom:checkVoice", self.m_tData.roomChannel,CCDirector:sharedDirector():getContentScaleFactor())
	local btnSpeaker = GetElement(self.m_root,"btnSpeaker_SceneRoom",WZUIButton)
	local btnMic = GetElement(self.m_root,"btnMic_SceneRoom",WZUIButton)

	if self:checkVoiceChannelLv(self.m_tData.roomChannel) then
		isVoice = true
	end
	self.m_bIsVoice = isVoice

	if isVoice then
		self.m_tVoiceId = {}
    	self.m_tVoiceState = {}
    	self.m_tMicState = {}
    else
    	btnSpeaker:setVisible(false)
    	btnMic:setVisible(false)
	end
end

--@brief    检查语音渠道和等级
function SceneRoom:checkVoiceChannelLv(channel)
	local isShow = false
	local battleMode = self.m_tData.battleMode
	WZLog("SceneRoom:checkVoiceChannelLv", channel, battleMode, CheckTalkButtonShow(12))
	if channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW and CheckTalkButtonShow(12) then
		isShow = true
	elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZ and battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_JJ and CheckTalkButtonShow(2) then
		isShow = true
	elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL and battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DJ and CheckTalkButtonShow(4) then
		isShow = true
	elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL and battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_WK and CheckTalkButtonShow(6) then
		isShow = true
	elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL and battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_FH and CheckTalkButtonShow(8) then
		isShow = true
	elseif channel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL and battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_DZ and CheckTalkButtonShow(10) then
		isShow = true
	end

	isShow = isShow
	return isShow
end

--@brief 	点击匹配小窗按钮回调
function SceneRoom:onCLickSmallMatch(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conSmallMark_SceneRoom", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conMark_SceneRoom", WZUIContainer):setVisible(true)
end

--@brief 	点击挂起按钮回调
function SceneRoom:onStartGameHangup(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conSmallMark_SceneRoom", WZUIContainer):setVisible(true)
	GetElement(self.m_root, "conMark_SceneRoom", WZUIContainer):setVisible(false)
end

--@brief 	添加时装套装入口
function SceneRoom:_addDressSuit()
	-- body
	-- if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then  --练习赛
	-- 	GetElement(self.m_root, "conFassion_SceneRoom", WZUIContainer):setVisible(false)
	-- 	return 
	-- end
	if CheckButtonOpen(144, false) then
		local conForDressSuit = GetElement(self.m_root, "conFassion_SceneRoom", WZUIContainer)
        if conForDressSuit:getChildByTag(999) then 
            conForDressSuit:removeChildByTag(999, true)
        end
		if conForDressSuit then
			local wndDress, tCell = WndDressSuit:createElement()
			if wndDress and tCell then
				tCell:setType(3)
				self.m_tCellDressSuit = tCell
				wndDress:setTag(999)
                wndDress:setRelativePosition(GlobalMethod:ccp(0.5,0.05))
				conForDressSuit:addChild(wndDress)
			end
		end
	end
end

--@brief    点击时装按钮回调
function SceneRoom:onClickFashion(element)
    --body
    if CheckButtonOpen(144) then
    	if self.m_tCellDressSuit then 
    		self.m_tCellDressSuit:onClickShow(element)
    	end
    end
end

--@brief    点击踢出房间按钮回调
function SceneRoom:onClickOutSel(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local bMatching = SceneRoom:getClickSeat()
    if bMatching == false then
        MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
        return 
    end
    ProtocolProcessorSceneRoom:send_ROOM_QuitRoom(self.m_tData.roomId, self.m_nSelPlayerSeatIndex - 1)
    GetElement(self.m_root, "conSelPlayerInfo_SceneRoom", WZUIContainer):setVisible(false)
end

--@brief    点击查看按钮回调
function SceneRoom:onCheckSel(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    local tag = self.m_nSelPlayerSeatIndex
    if self.m_tData.playerId[tag] then
        WndCheckOther:show(self.m_tData.playerId[tag])
    end
end

--@brief 	添加邀请列表
function SceneRoom:_showInviteList()
	-- body
	-- if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then
		-- GetElement(self.m_root, "conInviteBtn_SceneRoom", WZUIContainer):setVisible(true)
	-- else
		local conForRoomInvite = GetElement(self.m_root, "conForRoomInvite_SceneRoom", WZUIContainer)
		conForRoomInvite:setVisible(true)
		self.m_tTopHangle:setWifiSignalVisible(false)
		self.m_tTopHangle:setBottomBarVisible(false)
		if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
			local totalLevel = 0
			local count = 0
			for i,v in ipairs( self.m_tData.qualifyingLevel) do
				totalLevel = totalLevel + v
			end

			for i,v in ipairs(self.m_tData.playerId) do
				if v > 0 then
					count = count + 1
				end
			end
			local averageLevel = math.ceil(totalLevel / count)
			WZLog("averageLevel = ",averageLevel,count,totalLevel)
			WndRoomInviteList:showInterface(11, SceneRoom, self.inviteFriends, averageLevel, conForRoomInvite)
		elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then
			local totalLevel = 0
			local count = 0
			for i,v in ipairs( self.m_tData.qualifyingLevel) do
				totalLevel = totalLevel + v
			end

			for i,v in ipairs(self.m_tData.playerId) do
				if v > 0 then
					count = count + 1
				end
			end
			local averageLevel = math.ceil(totalLevel / count)
			WZLog("averageLevel = ",averageLevel,count,totalLevel)
			WndRoomInviteList:showInterface(20, SceneRoom, self.inviteFriends, averageLevel, conForRoomInvite)
		elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL or self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ  then
			WndRoomInviteList:showInterface(12, SceneRoom, self.inviteFriends, nil, conForRoomInvite)
		else
			WndRoomInviteList:showInterface(3, SceneRoom, self.inviteFriends, nil, conForRoomInvite)
		end
	 	WndRoomInviteList:setInviteFriendIds(self.m_tData.playerId)
	-- end

	local isEndTeach, teachStep = TeachGroup1:isTeachFinish(20)
	if not isEndTeach and teachStep < 7 then 
		self:hideInviteListCallBack()
	end
end

--@brief 	适配iphoneX
function SceneRoom:adaptIphoneX()
	-- body
	if IsIphoneX() then
		GetElement(self.m_root, "conForRoomInvite_SceneRoom", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.96, 0.5))
		GetElement(self.m_root, "btnShowInvite_SceneRoom", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.96, 0.5))
	end
end

--@brief    设置技能方案的名字
function SceneRoom:setSkillSuitName()
    -- body
    if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS then return end
    if not CheckButtonOpen(172, false) then return end 
    local tSkillSuit = CacheCenter:getSkillSuit()
    if tSkillSuit == nil then 
        ProtocolProcessorRecycling:send_PLAYERITEM_GetSuit(8)
        return 
    end

    local txtSkillSuitName = GetElement(self.m_root, "txtSkillSuitName_SceneRoom", WZUILabelTTF)
    for i = 1, #tSkillSuit do
        if tSkillSuit[i].bIsUsed then 
            txtSkillSuitName:setText(tSkillSuit[i].name .. LocalStrings.SKILLSUIT_TAIL)
            break 
        end
    end
end
--创建vip特效
function SceneRoom:createVipEffect(vip_count, index)
	if not self.m_root then return end
	self.m_tMakeActionData[self.m_tData.playerId[index]] = true

	local conCenter = GetElement(self.m_root,"conCenter_SceneRoom",WZUIContainer)
	local conSeat = WZUIContainer:luaTo(conCenter:getChildElement("conSeat".. index .."_SceneRoom"))

	local m_sVipEffect = WZUIContainer:create()
	m_sVipEffect:setUseAbsSize(true)
	m_sVipEffect:setAbsContentSize(GlobalMethod:CCSize(300,100))
	m_sVipEffect:setAnchorPoint(ccp(0.5,0))
	m_sVipEffect:setRelativePosition(ccp(0.55,0.7))
	m_sVipEffect:setShowAll(true)
    conSeat:addChild(m_sVipEffect)

    local vip_icon = WZUIImage:create()
    vip_icon:setAnchorPoint(ccp(0.5,0.5))
    vip_icon:setRelativePosition(ccp(0.4,0.5))
    vip_icon:setUseOriginSize(true)
    vip_icon:setFile("ui/vip/vip.png")
    m_sVipEffect:addChild(vip_icon, 10)

    local txtAtlasFont = WZUILabelAtlasFont:create()
    txtAtlasFont:setCharMapFileName("ui/common_num/VIP_0_9.png")
    txtAtlasFont:setStartChar(48)
    txtAtlasFont:setHeight(33)
    txtAtlasFont:setWidth(31)
    txtAtlasFont:setUseOriginSize(true)
    txtAtlasFont:setAnchorPoint(ccp(0,0.5))
    txtAtlasFont:setRelativePosition(ccp(0.5,0.5))
    txtAtlasFont:setText(vip_count)
    m_sVipEffect:addChild(txtAtlasFont)


	local temp_data = {}
	temp_data.path = "ui/otherUI/ui_common_vipfj"
	temp_data.play = "wait_2"
	temp_data.ccp = GlobalMethod:ccp(0.5,0.15)
	local existSpine = CheckEffectFile(temp_data.path)
	if existSpine then 
		createEffectSpine(m_sVipEffect, temp_data)
	else
		local _sIndex = "ui_common_vipfj"
        local downloadInfo = GetDownloadInfo(_sIndex, "uiEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(14202,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
        end
	end

	local array = CCArray:create()
    array:addObject(CCDelayTime:create(4.5))
    array:addObject(CCScaleTo:create(0.5, 0))
    array:addObject(CCCallFunc:create(function()
    	if m_sVipEffect then
			m_sVipEffect:removeFromParentAndCleanup(true)
			m_sVipEffect = nil
		end
	end))
	local seq = CCSequence:create(array)
	m_sVipEffect:runAction(seq)
end

--@brief    显示伴侣互动动画
function SceneRoom:showCoupleAnimation()
	local nCoupleList = {}
	if self.m_SpouseList then
		for i=1,#self.m_SpouseList do
		    local tmpList = SplitStringWithSeparator(self.m_SpouseList[i],"|")
		    for j=1,#tmpList do
		        table.insert(nCoupleList,tmpList[j])
		    end
		end
	end
    if self.m_tScheduleList then
        for k, v in ipairs (self.m_tScheduleList) do
        	local bFlag = false
        	for i=1, #nCoupleList do
        		if v[2] == tonumber(nCoupleList[i]) then
        			bFlag = true
        			break
        		end
        	end

            if v[1] and v[1]:getAnimNode() and v[1].m_running then
                ShowCoupleAni(v[1]:getAnimNode(), bFlag, GlobalMethod:ccp(0.5,1.7), 1)
            end
        end
    end
end

-------------------------------------回调方法模块End----------------------------------------


-------------------------------------语言适配器模块Begin--------------------------------------

function SceneRoom:_adaptLanguage_en()
    WZLog("----------------en---------------------")

    local txtMatchTimeOut = GetElement(self.m_root,"txtMatchTimeOut_SceneRoom",WZUILabelTTF)
    txtMatchTimeOut:setScale(0.8)

    GetElement(self.m_root,"txtRoomNameD_SceneRoom",WZUILabelTTF):setScale(0.8)
    local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneRoom",WZUILabelTTF)
    txtRoomName:setScale(0.8)
    txtRoomName:setRelativePosition(GlobalMethod:ccp(0.455442,0.5))
    GetElement(self.m_root,"txtRoomIDD_SceneRoom",WZUILabelTTF):setScale(0.8)
    local txtRoomId = GetElement(self.m_root,"txtRoomId_SceneRoom",WZUILabelTTF)
    txtRoomId:setScale(0.8)
    txtRoomId:setRelativePosition(GlobalMethod:ccp(0.346351,0.5))
    GetElement(self.m_root,"txtRoomPassD_SceneRoom",WZUILabelTTF):setScale(0.8)
    local txtRoomPass = GetElement(self.m_root,"txtRoomPass_SceneRoom",WZUILabelTTF)
    txtRoomPass:setScale(0.8)
    txtRoomPass:setRelativePosition(GlobalMethod:ccp(0.382714,0.5))

    local txtTimeDownTip = GetElement(self.m_root,"txtTimeDownTip_SceneRoom",WZUILabelTTF)
	txtTimeDownTip:setScale(0.8)
	txtTimeDownTip:setDimensions(GlobalMethod:CCSize(394))
    -- GetElement(self.m_root,"txtRoomMode_SceneRoom",WZUILabelTTF):setFontSize(16)

	local txtMatch = GetElement(self.m_root,"txtMatch_SceneRoom",WZUILabelTTF)
	txtMatch:setScale(0.8)
	local txtSmallMatchTime = GetElement(self.m_root,"txtSmallMatchTime_SceneRoom",WZUILabelTTF)
	txtSmallMatchTime:setScale(0.8)
	txtSmallMatchTime:setRelativePosition(GlobalMethod:ccp(0.6,0.6))

	GetElement(self.m_root, "conSmallMark_SceneRoom", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6,0.8))

	local txtBalance = GetElement(self.m_root, "txtBalance_SceneRoom", WZUILabelTTF)
	txtBalance:setScale(0.8)
	txtBalance:setRelativePosition(GlobalMethod:ccp(0.68,0.76))
end

function SceneRoom:_adaptLanguage_pt()
    GetElement(self.m_root,"txtRoomNameD_SceneRoom",WZUILabelTTF):setScale(0.8)
    local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneRoom",WZUILabelTTF)
    txtRoomName:setRelativePosition(GlobalMethod:ccp(0.569078,0.5))
    txtRoomName:setScale(0.8)

    GetElement(self.m_root,"txtRoomIDD_SceneRoom",WZUILabelTTF):setScale(0.8)
    local txtRoomId = GetElement(self.m_root,"txtRoomId_SceneRoom",WZUILabelTTF)
    txtRoomId:setRelativePosition(GlobalMethod:ccp(0.387259,0.5))
    txtRoomId:setScale(0.8)

    GetElement(self.m_root,"txtRoomPassD_SceneRoom",WZUILabelTTF):setScale(0.8)
    local txtRoomPass = GetElement(self.m_root,"txtRoomPass_SceneRoom",WZUILabelTTF)
    txtRoomPass:setRelativePosition(GlobalMethod:ccp(0.259987,0.5))
    txtRoomPass:setScale(0.8)

    local txtTimeDownTip = GetElement(self.m_root,"txtTimeDownTip_SceneRoom",WZUILabelTTF)
	txtTimeDownTip:setScale(0.8)
	txtTimeDownTip:setDimensions(GlobalMethod:CCSize(400))
	GetElement(self.m_root, "txtMatchTimeOut_SceneRoom", WZUILabelTTF):setScale(0.66)

	local txtMatch = GetElement(self.m_root,"txtMatch_SceneRoom",WZUILabelTTF)
	txtMatch:setScale(0.6)
	local txtSmallMatchTime = GetElement(self.m_root,"txtSmallMatchTime_SceneRoom",WZUILabelTTF)
	txtSmallMatchTime:setScale(0.6)
	txtSmallMatchTime:setRelativePosition(GlobalMethod:ccp(0.6,0.6))

	GetElement(self.m_root, "conSmallMark_SceneRoom", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6,0.8))

	local txtBalance = GetElement(self.m_root, "txtBalance_SceneRoom", WZUILabelTTF)
	txtBalance:setScale(0.65)
	txtBalance:setRelativePosition(GlobalMethod:ccp(0.67,0.8))
end

function SceneRoom:_adaptLanguage_vn()
    WZLog("SceneRoom:_adaptLanguage_vn ")

    GetElement(self.m_root,"txtRoomNameD_SceneRoom",WZUILabelTTF):setScale(0.8)
    local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneRoom",WZUILabelTTF)
    txtRoomName:setScale(0.8)
    txtRoomName:setRelativePosition(GlobalMethod:ccp(0.364532,0.5))
    GetElement(self.m_root,"txtRoomIDD_SceneRoom",WZUILabelTTF):setScale(0.8)
    local txtRoomId = GetElement(self.m_root,"txtRoomId_SceneRoom",WZUILabelTTF)
    txtRoomId:setScale(0.8)
    txtRoomId:setRelativePosition(GlobalMethod:ccp(0.328169,0.5))
    GetElement(self.m_root,"txtRoomPassD_SceneRoom",WZUILabelTTF):setScale(0.8)
    local txtRoomPass = GetElement(self.m_root,"txtRoomPass_SceneRoom",WZUILabelTTF)
    txtRoomPass:setScale(0.8)
    txtRoomPass:setRelativePosition(GlobalMethod:ccp(0.33726,0.5))

    local txtTimeDownTip = GetElement(self.m_root,"txtTimeDownTip_SceneRoom",WZUILabelTTF)
	txtTimeDownTip:setScale(0.8)
	txtTimeDownTip:setDimensions(GlobalMethod:CCSize(405))

	local txtBalance = GetElement(self.m_root, "txtBalance_SceneRoom", WZUILabelTTF)
	txtBalance:setScale(0.65)
	txtBalance:setRelativePosition(GlobalMethod:ccp(0.7,0.76))
end

function SceneRoom:_adaptLanguage_th()
    WZLog("SceneRoom:_adaptLanguage_th ")

    local txtMatchTimeOut = GetElement(self.m_root,"txtMatchTimeOut_SceneRoom",WZUILabelTTF)
    txtMatchTimeOut:setScale(0.8)

    local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneRoom",WZUILabelTTF)
    txtRoomName:setRelativePosition(GlobalMethod:ccp(0.332714,0.5))
    txtRoomName:setFontSize(16)

    local txtRoomId = GetElement(self.m_root,"txtRoomId_SceneRoom",WZUILabelTTF)
    txtRoomId:setRelativePosition(GlobalMethod:ccp(0.205442,0.5))

    local txtRoomPass = GetElement(self.m_root,"txtRoomPass_SceneRoom",WZUILabelTTF)
    txtRoomPass:setRelativePosition(GlobalMethod:ccp(0.391805,0.5))

    --GetElement(self.m_root,"txtBattleTip_SceneRoom",WZUILabelTTF):setFontSize(16)

	local txtTimeDownTip = GetElement(self.m_root,"txtTimeDownTip_SceneRoom",WZUILabelTTF)
	txtTimeDownTip:setScale(0.8)
	txtTimeDownTip:setDimensions(GlobalMethod:CCSize(394))

	local txtMatch = GetElement(self.m_root,"txtMatch_SceneRoom",WZUILabelTTF)
	txtMatch:setScale(0.8)
	local txtSmallMatchTime = GetElement(self.m_root,"txtSmallMatchTime_SceneRoom",WZUILabelTTF)
	txtSmallMatchTime:setScale(0.8)
	txtSmallMatchTime:setRelativePosition(GlobalMethod:ccp(0.6,0.6))
end

function SceneRoom:_adaptLanguage_tr()
    local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneRoom",WZUILabelTTF)
    txtRoomName:setRelativePosition(GlobalMethod:ccp(0.404545,0.5))
    txtRoomName:setAlignment(kCCTextAlignmentLeft)

    local txtRoomId = GetElement(self.m_root,"txtRoomId_SceneRoom",WZUILabelTTF)
    txtRoomId:setRelativePosition(GlobalMethod:ccp(0.523623,0.5))

    local txtRoomPass = GetElement(self.m_root,"txtRoomPass_SceneRoom",WZUILabelTTF)
    txtRoomPass:setRelativePosition(GlobalMethod:ccp(0.328169,0.5))

    local txtMatchTimeOut = GetElement(self.m_root,"txtMatchTimeOut_SceneRoom",WZUILabelTTF)
    txtMatchTimeOut:setScale(0.7)

    local txtTimeDownTip = GetElement(self.m_root,"txtTimeDownTip_SceneRoom",WZUILabelTTF)
	txtTimeDownTip:setScale(0.8)
	txtTimeDownTip:setDimensions(GlobalMethod:CCSize(400))

	GetElement(self.m_root, "conSmallMark_SceneRoom", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.55,0.799855))
	
	local txtMatch = GetElement(self.m_root,"txtMatch_SceneRoom",WZUILabelTTF)
	txtMatch:setScale(0.8)
	local txtSmallMatchTime = GetElement(self.m_root,"txtSmallMatchTime_SceneRoom",WZUILabelTTF)
	txtSmallMatchTime:setScale(0.8)
	txtSmallMatchTime:setRelativePosition(GlobalMethod:ccp(0.6,0.6))
end

function SceneRoom:_adaptLanguage_es(  )	
    GetElement(self.m_root,"txtRoomNameD_SceneRoom",WZUILabelTTF):setScale(0.7)
	local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneRoom",WZUILabelTTF)
	txtRoomName:setScale(0.7)
	txtRoomName:setRelativePosition(GlobalMethod:ccp(0.669078,0.5))
    GetElement(self.m_root,"txtRoomIDD_SceneRoom",WZUILabelTTF):setScale(0.7)
	local txtRoomId = GetElement(self.m_root,"txtRoomId_SceneRoom",WZUILabelTTF)
	txtRoomId:setScale(0.7)
	txtRoomId:setRelativePosition(GlobalMethod:ccp(0.509987,0.5))
    GetElement(self.m_root,"txtRoomPassD_SceneRoom",WZUILabelTTF):setScale(0.7)
	local txtRoomPass = GetElement(self.m_root,"txtRoomPass_SceneRoom",WZUILabelTTF)
	txtRoomPass:setScale(0.7)
	txtRoomPass:setRelativePosition(GlobalMethod:ccp(0.382714,0.5))

	local txtTimeDownTip = GetElement(self.m_root,"txtTimeDownTip_SceneRoom",WZUILabelTTF)
	txtTimeDownTip:setDimensions(GlobalMethod:CCSize(400,0))
	txtTimeDownTip:setScale(0.8)
	
	local txtMatch = GetElement(self.m_root,"txtMatch_SceneRoom",WZUILabelTTF)
	txtMatch:setScale(0.6)
	local txtSmallMatchTime = GetElement(self.m_root,"txtSmallMatchTime_SceneRoom",WZUILabelTTF)
	txtSmallMatchTime:setScale(0.6)
	txtSmallMatchTime:setRelativePosition(GlobalMethod:ccp(0.6,0.6))

	GetElement(self.m_root, "conSmallMark_SceneRoom", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6,0.8))

	local txtBalance = GetElement(self.m_root, "txtBalance_SceneRoom", WZUILabelTTF)
	txtBalance:setScale(0.6)
	txtBalance:setRelativePosition(GlobalMethod:ccp(0.705,0.8))
end

function SceneRoom:_adaptLanguage_ug(  )
    local txtRoomNameD = GetElement(self.m_root,"txtRoomNameD_SceneRoom",WZUILabelTTF)
    txtRoomNameD:setScale(0.7)
    txtRoomNameD:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRoomNameD:setRelativePosition(GlobalMethod:ccp(1.17,0.5))
    local txtRoomIDD = GetElement(self.m_root,"txtRoomIDD_SceneRoom",WZUILabelTTF)
    txtRoomIDD:setScale(0.7)
    txtRoomIDD:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRoomIDD:setRelativePosition(GlobalMethod:ccp(1.17,0.5))
    local txtRoomPassD = GetElement(self.m_root,"txtRoomPassD_SceneRoom",WZUILabelTTF)
    txtRoomPassD:setScale(0.7)
    txtRoomPassD:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRoomPassD:setRelativePosition(GlobalMethod:ccp(1.17,0.5))
    local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneRoom",WZUILabelTTF)
    txtRoomName:setScale(0.6)
    txtRoomName:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRoomName:setRelativePosition(GlobalMethod:ccp(0.632713,0.5))
    txtRoomName:setDimensions(GlobalMethod:CCSize(220))
    local txtRoomId = GetElement(self.m_root,"txtRoomId_SceneRoom",WZUILabelTTF)
    txtRoomId:setScale(0.7)
    txtRoomId:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRoomId:setRelativePosition(GlobalMethod:ccp(0.528169,0.5))
    local txtRoomPass = GetElement(self.m_root,"txtRoomPass_SceneRoom",WZUILabelTTF)
    txtRoomPass:setScale(0.7)
    txtRoomPass:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRoomPass:setRelativePosition(GlobalMethod:ccp(0.705441,0.5))

    GetElement(self.m_root,"txtMatchTimeOut_SceneRoom",WZUILabelTTF):setScale(0.55)
    
    local txtHangup = GetElement(self.m_root,"txtHangup_SceneRoom",WZUILabelTTF)
    txtHangup:setScale(0.7)
    txtHangup:setDimensions(GlobalMethod:CCSize(160,0))    
    local txtCancel = GetElement(self.m_root,"txtCancel_SceneRoom",WZUILabelTTF)
    txtCancel:setScale(0.7)
    txtCancel:setDimensions(GlobalMethod:CCSize(160,0))

    GetElement(self.m_root, "conSmallMark_SceneRoom", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.638333,0.799855))

    local txtTimeDownTip = GetElement(self.m_root,"txtTimeDownTip_SceneRoom",WZUILabelTTF)
	txtTimeDownTip:setScale(0.6)
	txtTimeDownTip:setDimensions(GlobalMethod:CCSize(540))

	local txtMatch = GetElement(self.m_root,"txtMatch_SceneRoom",WZUILabelTTF)
	txtMatch:setScale(0.5)
	local txtSmallMatchTime = GetElement(self.m_root,"txtSmallMatchTime_SceneRoom",WZUILabelTTF)
	txtSmallMatchTime:setScale(0.5)
	txtSmallMatchTime:setRelativePosition(GlobalMethod:ccp(0.637554,0.6))
end
-------------------------------------语言适配器模块End----------------------------------------


