--SceneGuildWarRoom.lua
--@brief	SceneGuildWarRoom的UI模块
--@date		2017/2/24
--@note		公会战房间


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneGuildWarRoom:onEnter(element)
    WZLog("SceneGuildWarRoom:onEnter ")
	self.m_root = element
	AdaptLanguage(self)
 
    ProtocolProcessorSceneRoom:regAll() --注册协议
    --竞技房间频道
	ChangeChatChannel(Chat_Channel_Community_Room)
	IPDConnector.g_nNetConnectFlag = NET_FLAG_7
    --获取服务器日期时间
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarTime( )
  	
  	CacheCenter:registerFriendListObserver(self)
  	self:sendFriendGetFriend()
    GetElement(self.m_root,"conInvite_SceneGuildWarRoom",WZUIContainer):enableSchedule("sendFriendGetFriend",3)
   
    --CacheCenter:registerUpdateDecorationObserver(self) --注册监听玩家装备更换
    --CacheCenter:registerUpatePlayerPetInfoObserver(self) --注册监听玩家宠物更新
    CacheCenter:registerUpateSkillSuitObserver(self)
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    WndCurrentChat:setMaxCount(4)
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
end

--@breif  动画播放完毕
function SceneGuildWarRoom:anctionPlayFinish()
	
	self.m_root:enableSchedule("updatePlayerAnimation",1.5)
end

--@brief	设置所有按钮是否可点
function SceneGuildWarRoom:setAllBtnStats(bStats)
	WZLog("SceneGuildWarRoom:setAllBtnStats")
	self.m_bCanClickSeat = bStats
	if not self:getIsRoomOwner() then
		WZUIButton:luaTo(self.m_root:getChildElement("btnFight_SceneGuildWarRoom")):setTouchEnable(bStats)
	elseif self:getIsRoomOwner() and self.m_tData.startMode ~= 1 then
		WZUIButton:luaTo(self.m_root:getChildElement("btnFight_SceneGuildWarRoom")):setTouchEnable(bStats)
	end
	self.m_tTopHangle:setTopTouchEnable(bStats)
	--self.m_tWndBottomBar:setTouchEnable(bStats)
	--WZUIButton:luaTo(self.m_root:getChildElement("btnReturn_SceneGuildWarRoom")):setTouchEnable(bStats)
end

--@brief  如果准备游戏了，不能点击返回按钮，先取消准备才能退出
--@param  bStatus : true  不屏蔽顶部导航栏触摸事件  false 屏蔽顶部导航栏触摸事件
function SceneGuildWarRoom:setAllBtnStats2(bStatus)
	WZLog("SceneGuildWarRoom:setAllBtnStats2 = ",bStatus)
	self.m_tTopHangle:setShieldClick(bStatus)
end

--@brief  退出房间
function SceneGuildWarRoom:exitRoom()
	if self.m_tData == nil or self.m_root == nil then
		WZLog("SceneGuildWarRoom:onBackSceneCallback m_tData is nil")
		return
	end
    if self.m_toSceneBattleLoading ~= true then
        if WBattleGlobal:getCurrent().m_tMakePairOk and WBattleGlobal:getCurrent().m_tMakePairOk.battleId then
            WBattleGlobal:getCurrent().m_tMakePairOk.battleId = 0
        end
        ProtocolProcessorSceneRoom:send_ROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat() )
    end
end

--@brief  改变准备状态
function SceneGuildWarRoom:changeReadyStatus()
	WZLog("SceneGuildWarRoom:changeReadyStatus")
	local seatI = self:_getPlayerSeat()
	ProtocolProcessorSceneRoom:send_ROOM_GameReady(self.m_tData.roomId, seatI, not self.m_tData.playerReady[seatI + 1] )
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneGuildWarRoom:onExit(element)
    WZLog("SceneGuildWarRoom:onExit", tostring(g_bIsPushScene), tostring(g_bIsPopScene))
    if g_bIsPushScene == true then
        return
    end
    GetElement(self.m_root,"conInvite_SceneGuildWarRoom",WZUIContainer):disableSchedule()
    SceneGuildWarRoom:exitRoom()
    self:quitVoice()
    --add by wuweidong
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","SceneGuildWarRoom")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","SceneGuildWarRoom")
    self.m_root:disableSchedule()          
    CacheCenter:unregisterUpateDecorationObserver(self)
    CacheCenter:unregisterUpatePlayerPetInfoObserver(self)
    CacheCenter:unregisterFriendListObserver(self)
    CacheCenter:unregisterUpateSkillSuitObserver(self)

	ProtocolProcessorSceneRoom:unregAll() --反注册协议
	self:_unInit()
	IPDConnector.g_nNetConnectFlag = NET_FLAG_2
    
end


function SceneGuildWarRoom:onEnterTransitionDidFinish()
	WZLog("SceneGuildWarRoom:onEnterTransitionDidFinish")
    WndAthUpgrade:Show()
    --延时显示成就特效
    ShowDelayAchie()
    self:setSkillSuitName()
end

--@brief 发送邀请列表信息
function SceneGuildWarRoom:sendFriendGetFriend()
	WZLog("SceneGuildWarRoom:sendFriendGetFriend")
	--限制当打开私聊邀请列表的时候，不发协议
	if not WndFriendList.m_root then
    	ProtocolProcessorWndFriends:send_FRIEND_GetFriend(9,2)
    end
end


--@brief	获得主角的座位
--@return	#1:位置
function SceneGuildWarRoom:_getPlayerSeat()
	WZLog("SceneGuildWarRoom:_getPlayerSeat")
	
	if self.m_tData == nil then
		WZLog("SceneGuildWarRoom:_getPlayerSeat m_tData is nil.")
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
function SceneGuildWarRoom:findPlayerSeatById(playerId)
	WZLog("SceneGuildWarRoom:findPlayerSeatById ",playerId)
	if self.m_tData == nil or playerId == nil then
		WZLog("SceneGuildWarRoom:_getPlayerSeat m_tData is nil.")
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
function SceneGuildWarRoom:updatePlayerSeat()
	WZLog("SceneGuildWarRoom:updatePlayerSeat")
	if self.m_nPlayerCount ~= self:_getPlayerNum() then
		self.m_nPlayerCount = self:_getPlayerNum()
		if self.m_nPlayerCount > 1 then
			self:receiveFriendListData()
		end
	end
	local totalScore = 0
	for i = 1,#self.m_tData.tournamentExp do
		totalScore = totalScore + self.m_tData.tournamentExp[i]
	end
	GetElement(self.m_root,"labTotalScore_SceneGuildWarRoom",WZUILabelTTF):setText(string.format(LocalStrings.GUILD_WAR_TEAM_SCORE,totalScore))
	local playerSeatIndex = self:_getPlayerSeat()
	playerSeatIndex = playerSeatIndex + 1
	GlobalGame.g_nPlayerInTeam = -1
	local indexTag = 0

	local isVoice = self:checkVoiceChannelLv()
	for i=1,3 do
		self:checkCellChatBubble(i)
		local conSeat = WZUIContainer:luaTo(self.m_root:getChildElement("conSeat".. i .."_SceneGuildWarRoom"))
	    local btnPlayerFigure  = WZUIButton:luaTo(conSeat:getChildElement("btnPlayerFigure_SceneGuildWarRoom"))
	    local btnPlayerPet = GetElement(conSeat,"btnPlayerPet_SceneGuildWarRoom",WZUIButton)

	    local conWeapon= WZUIContainer:luaTo(conSeat:getChildElement("conWeapon_SceneGuildWarRoom"))
	    local imgWeaponIcon = WZUIImage:luaTo(conWeapon:getChildElement("imgWeaponIcon_SceneGuildWarRoom"))
	    imgWeaponIcon:setFile("")

        local btnWeapon = WZUIButton:luaTo(conWeapon:getChildElement("btnWeapon_SceneGuildWarRoom"))
        btnWeapon:setTag(-1)

        local spWeapon1 = GetElement(conWeapon,"spWeapon_SceneGuildWarRoom",WZUISpine)
        spWeapon1:setVisible(false)
	    local playerId = self.m_tData.playerId[i]
	    self:showPlayerFigureAndPet(i)

	    -- local conStatusBg = GetElement(self.m_root,"conStatusBg" .. i .. "_SceneGuildWarRoom",WZUIContainer)
        local conFigure = GetElement(conSeat,"conFigureVoice_SceneGuildWarRoom",WZUIContainer)
        local anim = GetElement(conSeat,"animFigureVoice_SceneGuildWarRoom",WZUISpine)
		local img = GetElement(conSeat,"imgFigureVoice_SceneGuildWarRoom",WZUIImage)

	    if playerId == nil or playerId  < 1  then
	        conWeapon:setVisible(false)
	        btnPlayerFigure:setVisible(false)
	        if conFigure then
	         	-- conStatusBg:setVisible(false)
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
	    	conWeapon:setVisible(true)
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

	    local conSeatInfo = GetElement(conSeat,"conSeatInfo_SceneGuildWarRoom",WZUIContainer)
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
	    end
	   
        
	end
	self:setPlayerTeam(indexTag)
end

--@brief	开始配对计时器
function SceneGuildWarRoom:startPairTimer()
	WZLog("SceneGuildWarRoom:startPairTimer")
	self.m_nPairRemainTime = 1

	self:controlUIElementVisible(true)

	self:updateDescTips()
	local lafTime = WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"lafTime_SceneGuildWarRoom"))
	lafTime:setText(self.m_nPairRemainTime)
	lafTime:enableSchedule("_schedulePairTimer",1)
end

--@brief	关闭配对计时器
function SceneGuildWarRoom:endPairTimer()
	WZLog("SceneGuildWarRoom:endPairTimer")
	local lafTime = WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"lafTime_SceneGuildWarRoom"))
	lafTime:disableSchedule()
	self:setTimeOutTipVisible(false)
	self:controlUIElementVisible(false)
end

--@brief	发送更新房间协议
function SceneGuildWarRoom:send_ROOM_UpdateRoom()
	WZLog("SceneGuildWarRoom:send_ROOM_UpdateRoom")
	if self.m_root == nil or self.m_tData == nil then
		WZLog("SceneGuildWarRoom:send_ROOM_UpdateRoom no data")
		return
	end
	ProtocolProcessorSceneRoom:send_ROOM_UpdateRoom(self.m_tData.roomId,self.m_tData.battleMode,self.m_tData.playerNumMode,self.m_tData.roomPassword,self.m_tData.mapId,self.m_tData.startMode,self.m_tData.roomName)
end


--@brief  玩家装备更改回调函数
function SceneGuildWarRoom:updateDecorationData()
	WZLog("SceneGuildWarRoom:updateDecorationData ---- ")
	if self.m_root == nil then
		return
	end
    --ProtocolProcessorSceneRoom:send_ROOM_UpdateRoom(self.m_tData.roomId,self.m_tData.battleMode,self.m_tData.playerNumMode, self.m_tData.roomPassword,self.m_tData.mapId, self.m_tData.wnersId,self.m_tData.startMode,self.m_tData.roomName)
end

--@brief   玩家宠物信息更新回调函数
function SceneGuildWarRoom:updatePlayerPetInfoData()
	WZLog("SceneGuildWarRoom:updatePlayerPetInfoData")
	if self.m_root == nil then
		return
	end
    --ProtocolProcessorSceneRoom:send_ROOM_UpdateRoom(self.m_tData.roomId,self.m_tData.battleMode,self.m_tData.playerNumMode, self.m_tData.roomPassword,self.m_tData.mapId, self.m_tData.wnersId,self.m_tData.startMode,self.m_tData.roomName)
end



--@brief	触摸函数，判断消息是否在消息框显示范围内，如果不是的话，就让消息框不显示，反之，显示
--@param #1	element:表绑定的UI节点引用
--@param #2	point:点击位置
function SceneGuildWarRoom:onTouchBegan(element, point)
	WZLog("SceneGuildWarRoom:onTouchBegan")
	if self.m_root == nil then 
		WZLog("SceneGuildWarRoom:onTouchBegan(element, point) self.m_root is nil ")
	end 
    if WndTips then
        --Modified By Tianxiang_Xu
        if WndSkillProp.m_root or WndStrengthen.m_root then
            return
        else
        	if not WndTips:checkPointInBtn(point) then
            	WndTips:onCloseClick()
            end
        end
	end
	local bFlag = WndPopupMenu:ifPointInMenu(point)
	if bFlag == false then WndPopupMenu:disappear() end

	if WndItemInfo.m_root == nil then return end
	local bPoint = WndItemInfo:checkPoint(point,dir)
	if not bPoint then
		WndItemInfo:onCloseClick()
	end
end

--@brief 判断点击的点是否在某个范围
function SceneGuildWarRoom:ifPointInMenu(element,point)
    WZLog("SceneGuildWarRoom:ifPointInMenu")
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
function SceneGuildWarRoom:onClickPet(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	local petInfo = self.m_tPlayersPetInfo[tag]
	if petInfo and petInfo.itemId ~= nil then
		if tag <= 3 then
			WndTips:show(element,self.m_root,13,petInfo,GlobalMethod:ccp(360,-20),true)
		else
			WndTips:show(element,self.m_root,13,petInfo,GlobalMethod:ccp(360,20),true)
		end
	end
end

--@brief 查看玩家武器信息
function SceneGuildWarRoom:onClickWeapon(element)
	WZLog("SceneGuildWarRoom:onClickWeapon")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local pNode =WZUIContainer:luaTo(element:getParent())

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
	
	WndItemInfo:showInfo(element,self.m_root,1,weaponInfo,false,GlobalMethod:ccp(40,0),true)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置控件静态文本
--@note		设置控件静态文本
function SceneGuildWarRoom:_setUIStaticText()
    --描边字
    WZLog("SceneGuildWarRoom:_setUIStaticText")
   

end
--@brief	scene更新函数
--@note 	实际上的初始化函数
function SceneGuildWarRoom:_update()    
    WZLog("SceneGuildWarRoom:_update")             
    if self.m_root == nil then
        WZLog("SceneGuildWarRoom:_update m_root is nil.")
		return
    end

	if self.m_tData == nil then
		WZLog("SceneGuildWarRoom:_update m_tData is nil.")
		return
	end

	if self.m_nNextStartTime then 
	   self:initRoomView()
    end

	WndPopupMenu:disappear()--关闭菜单

    self:updateReaderBtn()

    --更新玩家座位
    self:updatePlayerSeat()
end

--@brief 初始化房间
function SceneGuildWarRoom:initRoomView()
	if not self.m_bInitRoom then 
		if self.m_tData.sechedule == GlobalGame.g_tSchedule.SCHEDULE_GW_1 then
			self.m_tTopHangle:setTitleFile("ui/community/bag_icon_chuxianfj.png")
            GetElement(self.m_root,"labWarTitle_SceneGuildWarRoom",WZUILabelTTF):setText(LocalStrings.GUILD_WAR_CX_TITLE)
			GetElement(self.m_root,"txtRoomRule_SceneGuildWarRoom",WZUILabelTTF):setText(LocalStrings.COMMUNITYWAR_TEXT8)
			local sOutRaceTime = CacheCenter:getGameParam()["warOutTime"]
			local sTempTime = SplitStringWithSeparator(sOutRaceTime, "-")
			local timeEnd = self.m_nNextStartTime + (SceneCommunityWar:transformStringToTime(sTempTime[2]) - SceneCommunityWar:transformStringToTime(sTempTime[1]))
			local leftTime = timeEnd - SystemTime:getServerTime()
			self.m_nBattleLeftTime = leftTime
			ProtocolProcessorSceneRoom:send_GUILDWAR_MyGuildWarRank(1)
		elseif self.m_tData.sechedule == GlobalGame.g_tSchedule.SCHEDULE_GW_2 then
			self.m_tTopHangle:setTitleFile("ui/community/bag_icon_ruweisaifj.png")
			GetElement(self.m_root,"labWarTitle_SceneGuildWarRoom",WZUILabelTTF):setText(LocalStrings.GUILD_WAR_RW_TITLE)
            GetElement(self.m_root,"txtRoomRule_SceneGuildWarRoom",WZUILabelTTF):setText(LocalStrings.COMMUNITYWAR_TEXT9)

			local sInRaceTime = CacheCenter:getGameParam()["warFinalistTime"]
			local sTempTime = SplitStringWithSeparator(sInRaceTime, "-")
			local timeEnd = self.m_nNextStartTime + (SceneCommunityWar:transformStringToTime(sTempTime[2]) - SceneCommunityWar:transformStringToTime(sTempTime[1]))
			local leftTime = timeEnd - SystemTime:getServerTime()
			self.m_nBattleLeftTime = leftTime
			ProtocolProcessorSceneRoom:send_GUILDWAR_MyGuildWarRank(2)
		end
		self:updateBattleLeftTime()
		self.m_bInitRoom = true
	end
end


--@brief	配对计时器
--@param	element:表绑定的UI节点引用
--@param	delta:时间分量
function SceneGuildWarRoom:_schedulePairTimer(element, delta)
	WZLog("SceneGuildWarRoom:_schedulePairTimer")
	self.m_nPairRemainTime = self.m_nPairRemainTime + 1
	if self.m_tData.startMode == 1  then
		if self.m_nPairRemainTime >20 and self.m_nPairRemainTime < 60 then
			self:setTimeOutTipVisible(true)
		elseif self.m_nPairRemainTime >= 60 then
			self:setAllBtnStats(true)
		    self:endPairTimer()
			ProtocolProcessorSceneRoom:send_ROOM_EndPair(self.m_tData.roomId)
			if self:getIsRoomOwner() then
		        self:changeStartGameBtn(LocalStrings.START_GAME)
	        end
	        self.m_bStartGame = false
			MsgBoxManager:showConfirmBox(LocalStrings.MATCHES_TIMEOUT,nil,nil,nil,nil,true)
		end
	end

	self:updateDescTips()
	
	WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"lafTime_SceneGuildWarRoom")):setText(self.m_nPairRemainTime)
end

-- 更新小提示
function SceneGuildWarRoom:updateDescTips()
	local ttfDesc = GetElement(self.m_root,"txtTimeDownTip_SceneGuildWarRoom",WZUILabelTTF)
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
function SceneGuildWarRoom:setTimeOutTipVisible(visStats)
	local txtMatchTimeOut = self.m_root:getChildElement("txtMatchTimeOut_SceneGuildWarRoom")
	txtMatchTimeOut:setVisible(visStats)
end



--@brief  更新开始游戏按钮状态
function SceneGuildWarRoom:updateReaderBtn()
	WZLog("SceneGuildWarRoom:updateReaderBtn")
	local labStartGame = GetElement(self.m_root, "labStartGame_SceneGuildWarRoom", WZUILabelTTF)
	
	if self:getIsRoomOwner() then
		labStartGame:setText(LocalStrings.START_GAME)
		self:setAllBtnStats2(false)
	else
		for i,v in ipairs(self.m_tData.playerId) do
			if v == GlobalGame.g_tPlayerInfo.nPlayerId then
				if self.m_tData.playerReady[i] then
					labStartGame:setText(LocalStrings.CANCEL_READY_GAME)
					if ProjConfig.LANGUAGE == "en" then
						labStartGame:setDimensions(GlobalMethod:CCSize(100,0))
						labStartGame:setScale(0.8)
					elseif ProjConfig.LANGUAGE == "th" then
						labStartGame:setScale(0.8)
					elseif ProjConfig.LANGUAGE == "vn" then
						labStartGame:setScale(0.8)
					elseif ProjConfig.LANGUAGE == "tr" then
						labStartGame:setDimensions(GlobalMethod:CCSize(100,0))
						labStartGame:setScale(0.8)
					end
					self:setAllBtnStats2(true)
				else
					labStartGame:setText(LocalStrings.READY_GAME)
					if ProjConfig.LANGUAGE == "vn" then
						--labStartGame:setDimensions(GlobalMethod:CCSize(160,0))
						labStartGame:setScale(0.8)
					end
					self:setAllBtnStats2(false)
				end
				return
			end
		end
	end
end

function SceneGuildWarRoom:_getPlayerNum()
	local num = 0
	for i=1 , #self.m_tData.playerId do
		if self.m_tData.playerId[i] > 0 then num = num + 1 end
	end
	return num
end

--@brief	获得是否可以开始游戏
--@return	#1:true:是,false:否,3:玩家没有全部准备
function SceneGuildWarRoom:_getIsCanStart()
	WZLog("SceneGuildWarRoom:_getIsCanStart")
	if self.m_tData == nil then
		WZLog("SceneGuildWarRoom:_getIsCanStart m_tData is nil.")
		return false
	end
	local isCanStart = true
	local playerGameCount = 0  --参加混战人数，至少有两个人才能开始
	local readyCount = 0        --准备游戏玩家总算
	for i,v in ipairs(self.m_tData.playerId) do
		if v > 0 then
			if self.m_tData.playerReady[i] ==false then
				return 3
			end
		end
	end
	
	for i,v in ipairs(self.m_tData.playerId) do
		if v > 0 then
			playerGameCount = playerGameCount + 1
		end
	end
	if playerGameCount < 3 then
		isCanStart = false
	end
	
	return isCanStart
end


--@brief  获取空位数量
function SceneGuildWarRoom:getAllNULLSeat()
	WZLog("SceneGuildWarRoom:getAllNULLSeat")
	local count = 0
	for i,v in ipairs(self.m_tData.playerId) do
		if v <=0 then
			count = count + 1
		end
	end
	return count
end

--@brief  判断是否有空位
function SceneGuildWarRoom:hasNullSeat()
	for i,v in ipairs(self.m_tData.playerId) do
		if v <=0 and self.m_tData.seatUsed[i] then
			return true
		end
	end
	return false
end

--@brief	是否为房主
--@return	#1:true:是,false:否
function SceneGuildWarRoom:getIsRoomOwner()
	WZLog("SceneGuildWarRoom:getIsRoomOwner")
	if self.m_tData == nil then
		WZLog("SceneGuildWarRoom:getIsRoomOwner m_tData is nil.")
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
function SceneGuildWarRoom:_isSeatUsed(index)
	if self.m_tData == nil then 
		WZLog("SceneGuildWarRoom:_isSeatUsed  m_tData is nil ")
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
function SceneGuildWarRoom:isCanCloseOpenSeat(startMode,battleMode,index,option)
	if startMode == 3 then   --混战模式
		if option == 1 then
			return true
		end
		if self.m_tData.playerNumMode > 2 then
			return true
		end
	elseif startMode == 1 and battleMode == 1 then --匹配模式
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
function SceneGuildWarRoom:_changePlayerSeat(newSeat)
	local oldSeat = self:_getPlayerSeat()
	WZLog("SceneGuildWarRoom:_changePlayerSeat ",self.m_tData.roomId, oldSeat, newSeat)
	ProtocolProcessorSceneRoom:send_ROOM_UpdateSeat(self.m_tData.roomId, oldSeat, newSeat )	
end

--@brief  更新座位信息
function SceneGuildWarRoom:_updateSeatInfo(luaObject,elementObject,index,bgType,isused)
	WZLog("SceneGuildWarRoom:_updateSeatInfo ",index)
	if luaObject ~= nil then
		luaObject:setBgType(bgType)
		local conCenter = GetElement(self.m_root,"conCenter_SceneGuildWarRoom",WZUIContainer)
		local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneGuildWarRoom",WZUIContainer)
		local imgPlayerStats = WZUIImage:luaTo(conSeat:getChildElement("imgPlayerStatus_SceneGuildWarRoom"))
	    imgPlayerStats:setFile("")
	    if isused then
			if self.m_tData.wnersId == self.m_tData.playerId[index] then
			   imgPlayerStats:setFile("ui/common/common_icon_fangzhu.png")
			else
				if self.m_tData.playerReady[index] then
					imgPlayerStats:setFile("ui/hero/hero_icon_yxzb.png")
				else
					imgPlayerStats:setFile("")
				end
			end
	    end
	   
		GetElement(elementObject,"conCloseSeat",WZUIContainer):setVisible(false)
	    local curD = self.m_tData
	    luaObject:setData(curD.wnersId,curD.seatUsed[index],curD.playerId[index],curD.playerName[index],curD.playerLevel[index],curD.playerReady[index],curD.playerSex[index],curD.vipLevel[index],curD.playerTitle[index],curD.fighting[index],curD.playerNumMode,index,curD.startMode,curD.battleMode,curD.tournamentLevel[index],curD.seatUsed,curD.serviceId[index],curD.roomChannel,curD.playNum[index],curD.winNum[index],curD.tournamentExp[index],curD.winTimes[index],curD.joinTimes[index],curD.continuousWinTimes[index],curD.matchscore[index],curD.qualifyingLevel[index])
	    luaObject:setSeatInfo(self.m_tData.seatUsed)
	    local friendInfo = self:getFriendRV(self.m_tData.playerId[index])
        luaObject:setFriendInfo(friendInfo)

		local masterInfo = self:getMasterRV(self.m_tData.playerId[index],self.m_tData.playerLevel[index])
		luaObject:setMasterInfo(masterInfo)

		local spouseValue,spuseLevel,wifeName,husbandName = self:getSpouseRV(self.m_tData.playerId[index],self.m_tData.playerSex[index],self.m_tData.playerName[index])
		luaObject:setSpouseInfo(spouseValue,spuseLevel,wifeName,husbandName)

	    luaObject:_update()
	end
end

--@brief	创建一个玩家座位
--@param	index:cell的识别
--@param	bgType:背景类型(1:红色,2:蓝色)
--@param    isused:座位是否关闭
--@return	#1:element的引用
--@return	#2:表的引用
function SceneGuildWarRoom:_createASeat(index,bgType,isused)
	WZLog("SceneGuildWarRoom:_createASeat",index,bgType,isused)
	local cellElement,cellObj = CellRoomSeat:createElement()
	cellElement:setTag(index)
	cellElement:setScaleX(0.66666)
	cellElement:setScaleY(0.6373)
	-- cellElement:setBGRectVisible(false)

	--背景图替换，但因是通用得cellRoomSeat，所以单独改
	local fontStyle =  [[<T C="255,227,116" S="22" P="0">%s</T>]]
	local cellElementBg = GetElement(cellElement,"imgBg_CellRoomSeat",WZUIImage)
	cellElementBg:setFile("ui/common/common_ghz_di_02.png")
	local cellElementCenterIcon = GetElement(cellElement,"imgBgCenterIcon_CellRoomSeat",WZUIImage)
	cellElementCenterIcon:setFile("ui/common/common_icon_quan.png")
	local cellElementWaitLabel = GetElement(cellElement,"txtWaitSeat_CellRoomSeat",WZUILabelTTF)
	cellElementWaitLabel:setText(string.format(fontStyle,LocalStrings.WAITTING))

	cellObj:setBgType(bgType)
	local conSeat = GetElement(self.m_root,"conSeat" .. index .. "_SceneGuildWarRoom")
	local imgPlayerStats = GetElement(conSeat,"imgPlayerStatus_SceneGuildWarRoom",WZUIImage)
	imgPlayerStats:setFile("")
	--imgPlayerStats:setZOrder(8888)
	if isused then
		if self.m_tData.wnersId == self.m_tData.playerId[index] then
		   imgPlayerStats:setFile("ui/common/common_icon_fangzhu.png")
		else
			if self.m_tData.playerReady[index] then
				imgPlayerStats:setFile("ui/hero/hero_icon_yxzb.png")
				cellElementBg:setFile("ui/common/common_ghz_di_01.png")
			else
				imgPlayerStats:setFile("")
			end
		end
	end

	--公会战处理
	GetElement(cellElement,"conCloseSeat",WZUIContainer):setVisible(false)

	local curD = self.m_tData
	cellObj:setData(curD.wnersId,curD.seatUsed[index],curD.playerId[index],curD.playerName[index],curD.playerLevel[index],curD.playerReady[index],curD.playerSex[index],curD.vipLevel[index],curD.playerTitle[index],curD.fighting[index],curD.playerNumMode,index,curD.startMode,curD.battleMode,curD.tournamentLevel[index],curD.seatUsed,curD.serviceId[index],curD.roomChannel,curD.playNum[index],curD.winNum[index],curD.tournamentExp[index],curD.winTimes[index],curD.joinTimes[index],curD.continuousWinTimes[index],curD.matchscore[index],curD.qualifyingLevel[index])
    cellObj:setChangeSeatCallBack(self.changeSeatCallBack,SceneGuildWarRoom)
    cellObj:setCloseSeatCallBack(self.closeSeatCallBack,SceneGuildWarRoom)
    cellObj:setOpenSeatCallBack(self.openSeatCallBack,SceneGuildWarRoom)
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
function SceneGuildWarRoom:showPlayerFigureAndPet(index)
	WZLog("SceneGuildWarRoom:showPlayerFigureAndPet")
	local playerEquipment = {}
	for i=1,5 do
		playerEquipment[i]= self.m_tData.playerEquipment[(index-1)*5+i]
	end
	if self.m_tData.seatUsed[index] and self.m_tData.playerId[index] > 0 then
				local conSeat = GetElement(self.m_root,"conSeat" .. index .. "_SceneGuildWarRoom",WZUIContainer)
		local conPlayer = GetElement(conSeat,"conPlayer_SceneGuildWarRoom",WZUIContainer)
	    local playerFigure = conPlayer:getChildByTag(self.m_tData.playerId[index])
	    local indexx = nil
	    if playerFigure == nil then
	    	conPlayer:removeAllChildrenWithCleanup(true)
	    	local playerId = self.m_tData.playerId[index]
	    	playerFigure = self:createAPlayer(self.m_tData.playerSex[index],playerEquipment,self.m_tData.headColors[index],self.m_tData.bodyColors[index])
	    	playerFigure:getAnimNode():setTag(playerId)
	    	playerFigure:getAnimNode():setScale(0.7)
	    	--conPlayer:setZOrder(999)
	    	if index >=4 then
	    		--playerFigure:setFlipX(true)
	    	end
	    	local playerAnimNode = playerFigure:getAnimNode()
            -- playerAnimNode:setRelativePosition(GlobalMethod:ccp(0.45,-0.12))

            local tmpCon = WZUIContainer:create()
		    tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.2))
		    tmpCon:setUseAbsSize(true)
		    tmpCon:setAbsContentSize(GlobalMethod:CCSize(105,105))
		    tmpCon:addChild(playerAnimNode)


	    	conPlayer:addChild(tmpCon)
	    	local countDown = 1.5
	    	local playerInfo  = {playerFigure,playerId,index,countDown}
	    	table.insert(self.m_tScheduleList,playerInfo)
	    else
	    	UpdatePlayerFigure(playerFigure,playerEquipment,nil,self.m_tData.headColors[index],self.m_tData.bodyColors[index])
	    end
	    local conPet = GetElement(conSeat,"conPet_SceneGuildWarRoom",WZUIContainer)
	    local petInfo = self.m_tPlayersPetInfo[index]
	    
	    if petInfo ~= nil and petInfo.itemId ~= nil then
	    	local petTag = self.m_tData.playerId[index]+10
	    	local petFigure = conPet:getChildByTag(petTag)
	    	if petFigure == nil then
	    		conPet:removeAllChildrenWithCleanup(true)
	    		local petId = petInfo.itemId
	    		local animation = petInfo.animation
	    		local petAnimation,par = CreatePetAni(conPet,petId,animation,petInfo.advancedLevel, petInfo.petSkinItemId)
	            if index >=4 then
	    		   --animNode:setFlipX(true)
	    	    end
	            --conPet:setZOrder(999)
	            petAnimation:setScale(0.65)
				if par then par:setScale(0.65) end
	            petAnimation:getAnimNode():setTouchEnable(false)

	    	end
	    else
	    	local petTag = self.m_tData.playerId[index]+10
	    	local petFigure = conPet:getChildByTag(petTag)
	    	if petFigure == nil then
	    		conPet:removeAllChildrenWithCleanup(true)
	    	end
	    end
	else
		local conSeat = GetElement(self.m_root,"conSeat" .. index .. "_SceneGuildWarRoom",WZUIContainer)
		local conPlayer = GetElement(conSeat,"conPlayer_SceneGuildWarRoom",WZUIContainer)
		local conPet = GetElement(conSeat,"conPet_SceneGuildWarRoom",WZUIContainer)
		conPlayer:removeAllChildrenWithCleanup(true)
		conPet:removeAllChildrenWithCleanup(true)
        if self.m_tScheduleList ==nil or #self.m_tScheduleList == 0 then
        	return
        end
        local inde = 0
	    for i,v in ipairs(self.m_tScheduleList) do
	    	if v[3] == index then
	    		inde = i
	    	end
	    end
	    if inde > 0 then
	    	table.remove(self.m_tScheduleList,inde)
	    end
	end
end

--@brief	创建一个角色动画
function SceneGuildWarRoom:createAPlayer(playerSex,equipment,headColor,bodyColor)
	WZLog("SceneGuildWarRoom:createAPlayer")
	return CreatePlayerFigure(playerSex,equipment,nil,nil,nil,nil,nil,nil,nil,nil,headColor,bodyColor)
end

--@brief  根据index打开、关闭对应的座位
function SceneGuildWarRoom:findCanOpenOrCloseSeat(index)

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
function SceneGuildWarRoom:updatePlayerAnimation(element,delta)

	local isPlayRelax = false
	local countPlayer = #self.m_tScheduleList
    for i=1,countPlayer do
    	local randomCount = math.random(5,14)
    	if self.m_tScheduleList[i][1]:isPlaying("wait0") == false then
    		self.m_tScheduleList[i][1]:play("wait0",true)
    	end
    	
    	if self.m_tScheduleList[i][4] >= randomCount then
    		self.m_tScheduleList[i][1]:play("relax",false)
    		self.m_tScheduleList[i][4] = 1.5
    	else
    		self.m_tScheduleList[i][4] = self.m_tScheduleList[i][4] + delta
    	end
    end
end

-------------------------------------回调方法模块Begin----------------------------------------

--@brief  关闭座位
--@param index:关闭的座位index
function SceneGuildWarRoom:closeSeatCallBack(element,index)
	if not self.m_bCanClickSeat then
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
function SceneGuildWarRoom:openSeatCallBack(element,index)
	if not self.m_bCanClickSeat then
		return
	end
    ProtocolProcessorSceneRoom:send_ROOM_TurnOnSeat(self.m_tData.roomId, index-1)
end


--@brief 换位
function SceneGuildWarRoom:changeSeatCallBack(element,index)
	if not self.m_bCanClickSeat then
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
function SceneGuildWarRoom:onCloseClick(element)
	WZLog("SceneGuildWarRoom:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData == nil or self.m_root == nil then
		WZLog("SceneGuildWarRoom:onBackSceneCallback m_tData is nil")
		return
	end
	local seatI = self:_getPlayerSeat()
	if self.m_tData.playerReady[seatI + 1] and not self:getIsRoomOwner() then
		MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
		return
	end
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
	ProtocolProcessorSceneRoom:send_ROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat())
end

--@brief   座位点击事件
function SceneGuildWarRoom:onClickCellRoomSeat(element)
	WZLog("SceneGuildWarRoom:onClickCellRoomSeat")
	if not self.m_bCanClickSeat then
		return
	end

	local index = element:getTag()
	
	WndCheckOther:show(self.m_tData.playerId[index])
	
end 

function SceneGuildWarRoom:scheduleCalculate(element)
	WZLog("SceneGuildWarRoom:scheduleCalculate")
	element:disableSchedule()
	self.m_nCount = 0
end

--@brief  取消匹配成功
function SceneGuildWarRoom:cancelMatchingOk()
	if not self.m_root then
		return
	end
	WZLog("SceneGuildWarRoom:cancelMatchingOk")
	SceneGuildWarRoom:closeLoading()
	self.m_bStartGame = false
	self:endPairTimer()
	if self:getIsRoomOwner() then
		self:changeStartGameBtn(LocalStrings.START_GAME)
	end
	self:setAllBtnStats(true)
end

--@brief	准备游戏按钮点击回调
--@param 	element:button的引用
function SceneGuildWarRoom:onFightBtnClick(element)
	WZLog("SceneGuildWarRoom:onFightBtnClick = ",self.m_nCount)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
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
		elseif self:_getIsCanStart() == false then
			MsgBoxManager:showTipBox(LocalStrings.NOT_START_GAME)
			return 
		end
	end
	if self:getIsRoomOwner()  then
		WZLog("send_ROOM_MakePair",self.m_tData.roomId)
		ProtocolProcessorSceneRoom:send_ROOM_MakePair(self.m_tData.roomId,self.m_tData.roomChannel,self.m_tData.sechedule,self.m_tData.battleMode,self.m_tData.playerNumMode)
		local conBg = GetElement(self.m_root,"conBg_SceneGuildWarRoom",WZUIContainer)
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

--@brief	帮助按钮点击回调
--@param 	element:button的引用
function SceneGuildWarRoom:onHelpBtnClick(element)
	WZLog("SceneGuildWarRoom:onHelpBtnClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    if  self.m_tData.sechedule == GlobalGame.g_tSchedule.SCHEDULE_GW_1 then
        local sRule = string.gsub(LocalStrings.COMMUNITYWAR_TEXT12, "255,236,193", "127,70,26")
        WndSingleMapDesc:showInterface1(sRule)    
    elseif self.m_tData.sechedule == GlobalGame.g_tSchedule.SCHEDULE_GW_2 then
        local sRule = string.gsub(LocalStrings.COMMUNITYWAR_TEXT13, "255,236,193", "127,70,26")
        WndSingleMapDesc:showInterface1(sRule)    
    end
end

--@brief	排行榜按钮点击回调
--@param 	element:button的引用
function SceneGuildWarRoom:onRankBtnClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("SceneGuildWarRoom:onRankBtnClick")
	if self.m_tData.sechedule == GlobalGame.g_tSchedule.SCHEDULE_GW_1 then --出线赛
		WndFinalistQualifying:show(1)
	elseif self.m_tData.sechedule == GlobalGame.g_tSchedule.SCHEDULE_GW_2 then --入围赛
		WndFinalistQualifying:show(2)
	end
end

--loading 30秒自动把顶部导航栏设置为可点击
function SceneGuildWarRoom:scheduleMoninerLoading(element)
	WZLog("SceneGuildWarRoom:scheduleMoninerLoading")
	local labStartGame = GetElement(self.m_root,"labStartGame_SceneGuildWarRoom",WZUILabelTTF)
	if labStartGame:getText() == LocalStrings.START_GAME then
		element:disableSchedule()
		self.m_tTopHangle:setTopTouchEnable(true)
	end
end


function SceneGuildWarRoom:_updateCheckPlayerState(element,dt)
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
	for i,v in ipairs(self.m_tData.playerId) do
		if v > 0 then
			if self.m_tData.playerReady[i] ==false then
				allReady = false
			end
		end
	end

	self:updateBattleLeftTime(dt)
    -- GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change",'state_room_arean',self.m_tData.roomId,self:_getPlayerNum(),self:_getPlayerSeat(),allReady)
end

--@brief 刷新倒计时
function SceneGuildWarRoom:updateBattleLeftTime(dt)
	if self.m_nBattleLeftTime then
		if self.m_nBattleLeftTime < 0 then
			self.m_nLoadingId = MsgBoxManager:showLoadingBox()
			ProtocolProcessorSceneRoom:send_ROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat())
		else
			if dt then
				self.m_nBattleLeftTime = self.m_nBattleLeftTime - dt
			end
			local sNextTime = returnToTimeFormat(math.floor(self.m_nBattleLeftTime))
			GetElement(self.m_root,"leftTime_SceneGuildWarRoom",WZUILabelTTF):setText(sNextTime)
		end
	end
end

--@brief  匹配时与不时在匹配时需要控制的UI控件
--@param  matching ：是否正在匹配
function SceneGuildWarRoom:controlUIElementVisible(matching)
	WZLog("SceneGuildWarRoom:controlUIElementVisible")
	local txtRoomInfoTitle = GetElement(self.m_root,"txtRoomInfoTitle_SceneGuildWarRoom",WZUILabelTTF)
	local txtMatching = GetElement(self.m_root,"txtMatching_SceneGuildWarRoom",WZUILabelTTF)

	local conMark = GetElement(self.m_root,"conMark_SceneGuildWarRoom",WZUIContainer)
	local btnCancel = GetElement(conMark,"btnCancel",WZUIButton)
	if matching then
		conMark:setVisible(true)
		if self:getIsRoomOwner() then
			GetElement(self.m_root,"btnCancel",WZUIButton):setVisible(true)
		else
			GetElement(self.m_root,"btnCancel",WZUIButton):setVisible(false)
		end
	else
		conMark:setVisible(false)
	end

	if not self:getIsRoomOwner() then
		btnCancel:setVisible(false)
	end
end

function SceneGuildWarRoom:receiveFriendListData()
	if not self.m_root then
		return
	end
	--当打开的是邀请好友界面的时候，不刷新列表
	if WndFriendList.m_root then return end 
	
	local tTempList = CacheCenter:getFriendDataList()
	if not tTempList then
		SceneGuildWarRoom:updateInviteList({})
		return
	end
	local list = {}
	for i = 1 ,#tTempList do
		local id = tTempList[i].id 
		local bInsert = true
		for i,vId in ipairs(self.m_tData.playerId) do
			if vId == id then
				bInsert = false
				break
			end
		end
		if bInsert then
			table.insert(list,tTempList[i])
		end
	end
	local function sort(r1,r2) return r1.fighting > r2.fighting end
	table.sort(list,sort)

	
	local bSame = true
	WZLog("SceneGuildWarRoom:receiveFriendListData",#list,self.m_tFriendList and #self.m_tFriendList or 0)
	if self.m_tFriendList and #self.m_tFriendList == #list then
		for i = 1,#list do
			if list[i].id ~= self.m_tFriendList[i] then
				bSame = false
			end
		end
	else
		bSame = false
	end
	
	if not bSame then
		self.m_tFriendList = {}
		for i = 1,#list do
			table.insert(self.m_tFriendList,list[i].id)
		end
		self:updateInviteList(list)
	end
end

--@brief 发送邀请
function SceneGuildWarRoom:sendInviteFunc(id)
	WZLog("SceneGuildWarRoom:sendInviteFunc",id,SystemTime:getServerTime())
	if not id then
		return
	end
	if self:_getPlayerNum() >= 3 then
		MsgBoxManager:showTipBox(LocalStrings.HALL_NO_SEAT)
		return
	end
	if not self.m_tInviteTimeList then
		self.m_tInviteTimeList  = {}
	end
	self.m_tInviteTimeList[id] = SystemTime:getServerTime()
	ProtocolProcessorSceneRoom:send_ROOM_Invite(self.m_tData.roomId, id)
end

--@brief 刷新邀请列表
function SceneGuildWarRoom:updateInviteList(list)
	if not self.m_root then
		return
	end
	WZLog("SceneGuildWarRoom:updateInviteList",#list)
	local conTabInvite = GetElement(self.m_root, "conTabInvite_SceneGuildWarRoom", WZUITableContainer)
    conTabInvite:cleanTable()
    local conForInvite = GetElement(self.m_root, "conForInvite_SceneGuildWarRoom", WZUIContainer)
    if list == nil or #list == 0 then
        ShowPanelNullTip(conForInvite)
        return 
    end
    removeShowPanelNullTip(conForInvite)

    for i = 1 ,#list do
    	local data = list[i]
    	if self.m_tInviteTimeList and self.m_tInviteTimeList[data.id] then
    		data.inviteTime = self.m_tInviteTimeList[data.id]
    	end
        local eItem, tItem = CellGuildWarInvite:createElement()
        eItem:setTag(i-1)
        conTabInvite:setCellElement(eItem)
        tItem:setData(data)
        tItem:setClickCallback(self,self.sendInviteFunc)
    end
end

--@brief 刷新排名奖励
function SceneGuildWarRoom:updateRewardItem(rankNum)
	if not self.m_root then
		return
	end
	WZLog("SceneGuildWarRoom:updateRewardItem",rankNum)
	local conTabReward = GetElement(self.m_root, "conTabReward_SceneGuildWarRoom", WZUITableContainer)
    conTabReward:cleanTable()
	if rankNum < 1 then
		GetElement(self.m_root,"labRankReward_SceneGuildWarRoom",WZUILabelTTF):setText(LocalStrings.NOT_IN_RANKLIST)
	else
		--获得奖励数据表
		local tDataList = {}
		if self.m_tData.sechedule == GlobalGame.g_tSchedule.SCHEDULE_GW_1 then
			for k,v in pairs(GDatatab_ghbattle_reward) do
				if v.type == 1 then
					table.insert(tDataList,v)
				end
			end
		else
			for k,v in pairs(GDatatab_ghbattle_reward) do
				if v.type == 2 then
					table.insert(tDataList,v)
				end
			end
		end
		local sortFunc = function(a, b) return a.rank[1][1] < b.rank[1][1] end
    	table.sort(tDataList,sortFunc)

    	local nRewardIndex = rankNum
    	for i = 1, #tDataList do
    		if tDataList[i].rank[1][2] == -1 then
    			if rankNum >= tDataList[i].rank[1][1] then
    				nRewardIndex = i
    				break 
    			end
    		else
    			if rankNum >= tDataList[i].rank[1][1] and rankNum <= tDataList[i].rank[1][2] then 
    				nRewardIndex = i
    				break 
    			end
    		end
    	end
    	
    	--获得当前奖励
    	local list = {}
    	local tDropData = tDataList[nRewardIndex].rank_reward
		local sex = CacheCenter:getPlayerInfo().sex
    	for i = 1 ,#tDropData do
            local info = {}
            info.id = tDropData[i][sex+1]
            info.count = tDropData[i][3]
            local tmp = GDatatab_item["id_"..info.id]
            info.quality = tmp and tmp.quality or 1
            table.insert(list,info)
        end
        local sortFunc = function(a, b) return a.quality > b.quality end
        table.sort(list , sortFunc)

        --奖励显示
        for i = 1 ,#list do
            local eItem, tItem = self:_createCellGoodItem(list[i].count,list[i].id)
            eItem:setTag(i-1)
            conTabReward:setCellElement(eItem)
        end
    
		GetElement(self.m_root,"labRankReward_SceneGuildWarRoom",WZUILabelTTF):setText(string.format(LocalStrings.KING_AWARD_RANK,rankNum))

	end
end

-- 点击物品后的回调
function SceneGuildWarRoom:onClickListItem(tItem, nTag, tData)
    WZLog("SceneGuildWarRoom:onClickListItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false, nil, true)
end
-------------------------------------回调方法模块End----------------------------------------


--@brief    创建一个物品格子
--@param    nIndex, 序号
--@param    nItemId, 物品id
function SceneGuildWarRoom:_createCellGoodItem(nCount, nItemId)
    local eItem, tItem = CellGoodItem:createElement()
    tItem:setItemClickFun(self, self.onClickListItem)
    tItem:setCellGoodLocalId(nItemId, nCount, 16)
    eItem:setScale(0.9)
    return eItem, tItem
end









------语音聊天
--@brief    加入语音聊天室
function SceneGuildWarRoom:joinVoice()
	if self.m_bIsTryJoinVoice ~= true then
	    GlobalGame.m_sVoiceRoomName = "guild_war_room_" .. self.m_tData.roomId
	    local isOk =  WGCloudVoiceNotify:JoinTeamRoom(GlobalGame.m_sVoiceRoomName)
	    WZLog("SceneGuildWarRoom:joinVoice", GlobalGame.m_sVoiceRoomName, isOk, type(isOk))
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
function SceneGuildWarRoom:quitVoice()
    WZLog("SceneGuildWarRoom:quitVoice", GlobalGame.m_sVoiceRoomName)
    if GlobalGame.m_sVoiceRoomName == nil then return end
    WGCloudVoiceNotify:QuitRoom(GlobalGame.m_sVoiceRoomName)
    GlobalGame.m_sVoiceRoomName = nil
    GlobalGame.m_nVoiceId = nil
end

--@brief    语音聊天室成员状态回调
--0 停止说话
--1 开始说话
--2 继续说话
function SceneGuildWarRoom:voiceMemberState(state)
    WZLog("SceneGuildWarRoom:voiceMemberState one", Serialize(state))
    local index = -1
    for j=1,state.count do
        for i,v in pairs(self.m_tVoiceId) do
            local offset = (j-1) * 2
            WZLog("SceneGuildWarRoom:voiceMemberState two-0", j, i, offset)
            if v == state.members[1 + offset] then
            	index = i
                WZLog("SceneGuildWarRoom:voiceMemberState three", state.members[2 + offset])

                if SceneGuildWarRoom.m_tMicState[index] == 1 then
                	local conSeat = GetElement(self.m_root,"conSeat" .. index .. "_SceneGuildWarRoom",WZUIContainer)
                	local anim = GetElement(conSeat,"animFigureVoice_SceneGuildWarRoom",WZUISpine)
	                local img = GetElement(conSeat,"imgFigureVoice_SceneGuildWarRoom",WZUIImage)
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
function SceneGuildWarRoom:openVoiceTimer()
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
function SceneGuildWarRoom:closeVoiceTimer()
	self.m_nVoiceTimer = 0
end

--@brief	听筒按钮点击后的Lua回调
function SceneGuildWarRoom:onClickSpeaker(sender, state, isNoSend)
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
        GetElement(self.m_root,"imgSpeaker1_SceneGuildWarRoom",WZUIImage):setGrayRender(false)
        GetElement(self.m_root,"imgSpeaker2_SceneGuildWarRoom",WZUIImage):setGrayRender(false)
    else
        WGCloudVoiceNotify:CloseSpeaker()
        GetElement(self.m_root,"imgSpeaker1_SceneGuildWarRoom",WZUIImage):setGrayRender(true)
        GetElement(self.m_root,"imgSpeaker2_SceneGuildWarRoom",WZUIImage):setGrayRender(true)
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

function SceneGuildWarRoom:onClickSpeakerCall(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local data = WZDataFile:getInstance():getUserData()
		if data then		
			data:setStringValue("TalkData", "playTalk", "0")
			data:flush()
		end
		self:onClickSpeaker(true)
	end
end

function SceneGuildWarRoom:onClickMicCall(nId, nResType)
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
function SceneGuildWarRoom:onClickMic(sender, state, isNoSend)
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
        GetElement(self.m_root,"imgMic1_SceneGuildWarRoom",WZUIImage):setGrayRender(false)
        GetElement(self.m_root,"imgMic2_SceneGuildWarRoom",WZUIImage):setGrayRender(false)
    else
        WGCloudVoiceNotify:CloseMic()
        GetElement(self.m_root,"imgMic1_SceneGuildWarRoom",WZUIImage):setGrayRender(true)
        GetElement(self.m_root,"imgMic2_SceneGuildWarRoom",WZUIImage):setGrayRender(true)
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
function SceneGuildWarRoom:checkVoice()
	local isVoice = false
	WZLog("SceneGuildWarRoom:checkVoice")
	if self:checkVoiceChannelLv() then
		isVoice = true
	end
	self.m_bIsVoice = isVoice

	if isVoice then
		self.m_tVoiceId = {}
    	self.m_tVoiceState = {}
    	self.m_tMicState = {}
    else
    	GetElement(self.m_root,"btnSpeaker_SceneGuildWarRoom",WZUIButton):setVisible(false)
    	GetElement(self.m_root,"btnMic_SceneGuildWarRoom",WZUIButton):setVisible(false)
	end
end

--@brief    检查语音渠道和等级
function SceneGuildWarRoom:checkVoiceChannelLv()
	local isShow = false
	WZLog("SceneGuildWarRoom:checkVoiceChannelLv", CheckTalkButtonShow(16))
	if  CheckTalkButtonShow(16) then
		isShow = true
	end

	isShow = isShow
	return isShow
end

--@brief 道具按钮回调
function SceneGuildWarRoom:onClickSkill(element)
	WZLog("SceneGuildWarRoom:onClickSkill")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSkillContainer:showById(1)
end

--@brief    设置技能方案的名字
function SceneGuildWarRoom:setSkillSuitName()
    -- body
    if not CheckButtonOpen(172, false) then return end 
    local tSkillSuit = CacheCenter:getSkillSuit()
    if tSkillSuit == nil then 
        ProtocolProcessorRecycling:send_PLAYERITEM_GetSuit(8)
        return 
    end

    local txtSkillSuitName = GetElement(self.m_root, "txtSkillSuitName_SceneGuildWarRoom", WZUILabelTTF)
    for i = 1, #tSkillSuit do
        if tSkillSuit[i].bIsUsed then 
            txtSkillSuitName:setText(tSkillSuit[i].name .. LocalStrings.SKILLSUIT_TAIL)
            break 
        end
    end
end
----------------------------------语言适配Begin-----------------------------------------------
function SceneGuildWarRoom:_adaptLanguage_en(  )
	local txtTimeDownTip = GetElement(self.m_root,"txtTimeDownTip_SceneGuildWarRoom",WZUILabelTTF)
	txtTimeDownTip:setScale(0.8)
	txtTimeDownTip:setDimensions(GlobalMethod:CCSize(405))
	local txtMatchTimeOut = GetElement(self.m_root,"txtMatchTimeOut_SceneGuildWarRoom",WZUILabelTTF)
	txtMatchTimeOut:setFontSize(16)
	local labStartGame = GetElement(self.m_root,"labStartGame_SceneGuildWarRoom",WZUILabelTTF)
	labStartGame:setScale(0.8)
	labStartGame:setDimensions(GlobalMethod:CCSize(100,0))

	-- GetElement(self.m_root,"conRule_SceneGuildWarRoom",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.78,0.232007))

	-- local txtleftTime = GetElement(self.m_root,"txtleftTime_SceneGuildWarRoom",WZUILabelTTF)
	-- txtleftTime:setRelativePosition(GlobalMethod:ccp(0.652304,0.5))
	local txtRoomRule = GetElement(self.m_root,"txtRoomRule_SceneGuildWarRoom",WZUILabelTTF)
	txtRoomRule:setScale(0.8)
	txtRoomRule:setDimensions(GlobalMethod:CCSize(100,0))

	GetElement(self.m_root,"txtInviteList_SceneGuildWarRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.850599,0.757292))
	
end

function SceneGuildWarRoom:_adaptLanguage_th( )
	local txtTimeDownTip = GetElement(self.m_root,"txtTimeDownTip_SceneGuildWarRoom",WZUILabelTTF)
	txtTimeDownTip:setScale(0.78)
	local txtRoomRule = GetElement(self.m_root,"txtRoomRule_SceneGuildWarRoom",WZUILabelTTF)
	txtRoomRule:setScale(0.8)
	txtRoomRule:setDimensions(GlobalMethod:CCSize(100,0))
	local labStartGame = GetElement(self.m_root,"labStartGame_SceneGuildWarRoom",WZUILabelTTF)
	labStartGame:setScale(0.8)
	labStartGame:setDimensions(GlobalMethod:CCSize(100,0))
end

function SceneGuildWarRoom:_adaptLanguage_vn( )
	local txtTimeDownTip = GetElement(self.m_root,"txtTimeDownTip_SceneGuildWarRoom",WZUILabelTTF)
	txtTimeDownTip:setScale(0.8)
	txtTimeDownTip:setDimensions(GlobalMethod:CCSize(405))

	--GetElement(self.m_root,"txtInvite_SceneGuildWarRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.86,0.757292))
end

function SceneGuildWarRoom:_adaptLanguage_es(  )
	-- local txtInviteDesc = GetElement(self.m_root,"txtInviteDesc_SceneGuildWarRoom",WZUILabelTTF)
	-- txtInviteDesc:setRelativePosition(GlobalMethod:ccp(0.8,0.740105))

	local txtRoomRule = GetElement(self.m_root,"txtRoomRule_SceneGuildWarRoom",WZUILabelTTF)
	txtRoomRule:setScale(0.6)
	txtRoomRule:setDimensions(GlobalMethod:CCSize(150,0))

	local labStartGame = GetElement(self.m_root,"labStartGame_SceneGuildWarRoom",WZUILabelTTF)
	labStartGame:setDimensions(GlobalMethod:CCSize(130,0))
	labStartGame:setScale(0.7)

	GetElement(self.m_root,"txtInviteList_SceneGuildWarRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.850599,0.757292))
end

function SceneGuildWarRoom:_adaptLanguage_pt(  )
	local labStartGame = GetElement(self.m_root,"labStartGame_SceneGuildWarRoom",WZUILabelTTF)
	labStartGame:setDimensions(GlobalMethod:CCSize(130,0))
	labStartGame:setScale(0.7)

	local txtRoomRule = GetElement(self.m_root,"txtRoomRule_SceneGuildWarRoom",WZUILabelTTF)
	txtRoomRule:setScale(0.8)
	txtRoomRule:setDimensions(GlobalMethod:CCSize(100,0))
	
	GetElement(self.m_root,"txtInviteList_SceneGuildWarRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.850599,0.757292))
end

function SceneGuildWarRoom:_adaptLanguage_tr(  )
	GetElement(self.m_root,"conRule_SceneGuildWarRoom",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.8,0.232007))
	local txtTimeDownTip = GetElement(self.m_root,"txtTimeDownTip_SceneGuildWarRoom",WZUILabelTTF)
	txtTimeDownTip:setScale(0.8)
	txtTimeDownTip:setDimensions(GlobalMethod:CCSize(405))
	local txtMatchTimeOut = GetElement(self.m_root,"txtMatchTimeOut_SceneGuildWarRoom",WZUILabelTTF)
	txtMatchTimeOut:setFontSize(16)
	local txtleftTime = GetElement(self.m_root,"txtleftTime_SceneGuildWarRoom",WZUILabelTTF)
	txtleftTime:setRelativePosition(GlobalMethod:ccp(0.688762,0.5))

	local labStartGame = GetElement(self.m_root,"labStartGame_SceneGuildWarRoom",WZUILabelTTF)
	labStartGame:setScale(0.8)
	labStartGame:setDimensions(GlobalMethod:CCSize(130,0))
end
----------------------------------语言适配End-------------------------------------------------