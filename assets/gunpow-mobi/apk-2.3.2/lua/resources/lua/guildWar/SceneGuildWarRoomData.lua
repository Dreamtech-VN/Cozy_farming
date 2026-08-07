--SceneGuildWarRoomData.lua
--@brief	SceneGuildWarRoom的数据模块
--@date		2017/2/24
--@note		公会战房间

SceneGuildWarRoom = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneGuildWarRoom:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tData = nil                  --场景ui信息
	self.m_tMapData = nil				--地图信息
	self.m_nLoadingId = nil				--转菊花id
	self.m_nPairRemainTime = nil		--匹配剩余时间
	self.m_tPopupMenuItems = nil		--点击座位弹出框
	self.m_nPlayerIndex = nil			--点击玩家的index
	self.m_bCanClickSeat = true			--是否可以点击座位
	self.m_bShowTipsSkillProp = false	--显示技能道具提示
	self.m_nDialogLuaObj = nil			--技能道具对话框
	self.m_nDialogFlag = false           --对话框标记
	self.m_tPlayer = nil 
	self.m_tRoomType = {SPORTS = 1,REVIVE= 2} --竞技房间类型(竞技、复活)
	self.m_tMatchesType = {RANDOM =1,FREE=2,SCUFFLE=3} --战斗模式(匹配模式、组队模式、混战模式)
	self.m_isCanTouch = false
	self.m_tWndBottomBar = nil
	self.m_nCounter = 1.5
	self.m_tScheduleList = {}           --存放执行定时器的对象
	self.m_tPlayersPetInfo = nil         --存放竞技房间玩家的宠物信息
	self.m_nHomeowner = nil
	self.m_tTopHangle = nil
	self.m_bStartGame = false             --房主是否已点击开始游戏
	self.m_nCount = 0
	self.m_nRoomSeatModel = nil
    self.m_fShakeHands = nil
    self.m_MasterList = nil   --师徒关系列表
    self.m_FriendList = nil   --朋友关系列表
    self.m_SpouseList = nil   --夫妻关系列表
    self.m_CoupleNum = nil --夫妻恩爱值
    self.m_ChumNum = nil   --密友关系值
    self.m_MentoringNum = nil  --师徒关系值
    self.m_nPlayerCount = nil
    self.m_tFriendList = nil --邀请列表
    self.m_tInviteTimeList = nil --发送邀请时间记录
    self.m_bInitRoom = nil --房间初始化

    self.m_nCommunityState = nil 
    self.m_sCommunityTime = nil 
    self.m_nNextStartTime = nil
    self.m_nSpeakerState = 0
    self.m_nMicState = 0
    self.m_tVoiceId = nil
    self.m_tVoiceState = nil
    self.m_tMicState = nil
    self.m_nVoiceTimer = 0
    self.m_bIsFirstSendVoice = false
    self.m_bIsVoiceState = false
    self.m_bIsVoice = false
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneGuildWarRoom:_unInit()
	self.m_root = nil
	self.m_tMapData = nil
	self.m_nLoadingId = nil
	self.m_nPairRemainTime = nil
	self.m_tPopupMenuItems = nil
	self.m_nPlayerIndex = nil
	self.m_bCanClickSeat = nil
	self.m_bShowTipsSkillProp = nil
	self.m_nDialogLuaObj = nil
	self.m_nDialogFlag = nil            --对话框标记
	self.m_tPlayer = nil 
	self.m_tRoomType = nil
	self.m_tMatchesType = nil
	self.m_tWndBottomBar = nil
	self.m_tScheduleList = nil
	self.m_nCounter = nil
	self.m_tPlayersPetInfo = nil
	self.m_nHomeowner = nil
	self.m_tTopHangle = nil
	self.m_bStartGame = nil
	self.m_nCount = 0
	self.m_nRoomSeatModel = nil
    self.m_fShakeHands = nil
    self.m_MasterList = nil   --师徒关系列表
    self.m_FriendList = nil   --朋友关系列表
    self.m_SpouseList = nil   --夫妻关系列表
    self.m_CoupleNum = nil --夫妻恩爱值
    self.m_ChumNum = nil   --密友关系值
    self.m_MentoringNum = nil  --师徒关系值
    self.m_nPlayerCount = nil
    self.m_tFriendList = nil
    self.m_tInviteTimeList = nil
    self.m_bInitRoom = nil

    self.m_nCommunityState = nil 
    self.m_sCommunityTime = nil 
    self.m_nNextStartTime = nil
    self.m_nSpeakerState = 0
    self.m_nMicState = 0
    self.m_tVoiceId = nil
    self.m_tVoiceState = nil
    self.m_tMicState = nil
    self.m_nVoiceTimer = 0
    self.m_bIsFirstSendVoice = false
    self.m_bIsVoiceState = false
    self.m_bIsVoice = false
end


-------------------------------------公有方法模块Begin--------------------------------------
local roomSeatModel = nil
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneGuildWarRoom:createElement()
	WZLog("SceneGuildWarRoom:createElement")
	local element = WZUISystem:getInstance():createElement("SceneGuildWarRoom")
	assert(element, "SceneGuildWarRoom create element failed!")
	self:_init()
	return element
end

--@brief	设置房间信息   
function SceneGuildWarRoom:setData(roomId,roomStatus, battleMode, roomChannel, playerNumMode,sechedule, mapId, wnersId, startMode, playerNum, seatUsed, playerId, playerName, playerLevel, playerReady, playerSex, playerEquipment, playerWeaponLevel, vipLevel, playerTitle,roomName,roomPassword,fighting,pet,tournamentLevel,winNum,playNum,extranInfo,serviceId,tournamentExp,headColors,bodyColors,mentoringStr,coupleStr,chumStr,coupleNum,chumNum,mentoringNum,qualifyingLevel,matchscore,joinTimes,winTimes,continuousWinTimes, useMountsMes, professionId)
	if self.m_nRoomSeatModel == nil then
		self.m_nRoomSeatModel = playerNum
	end
    if self.m_tData ~= nil and self.m_tData.roomId ~= nil and self.m_root ~= nil then
    	if self.m_nHomeowner ~= wnersId and wnersId == GlobalGame.g_tPlayerInfo.nPlayerId then
    		MsgBoxManager:showTipBox(LocalStrings.HOMEOWNER_TIP)
    	end
    end
    self.m_tData = {roomId = roomId,roomStatus=roomStatus, battleMode=battleMode, roomChannel=roomChannel, playerNumMode=playerNumMode,sechedule=sechedule ,mapId=mapId, wnersId=wnersId, startMode=startMode, playerNum=playerNum, seatUsed=seatUsed, playerId=playerId, playerName=playerName, playerLevel=playerLevel, playerReady=playerReady, playerSex=playerSex, playerEquipment=playerEquipment, playerWeaponLevel=playerWeaponLevel, vipLevel=vipLevel, playerTitle=playerTitle,roomName=roomName,roomPassword=roomPassword,fighting=fighting,pet=pet,tournamentLevel=tournamentLevel,winNum=winNum,playNum=playNum,extranInfo=extranInfo,serviceId=serviceId,tournamentExp=tournamentExp,headColors=headColors,bodyColors=bodyColors,mentoringStr=mentoringStr,coupleStr=coupleStr,chumStr= chumStr,coupleNum=coupleNum,chumNum=chumNum,mentoringNum=mentoringNum,qualifyingLevel=qualifyingLevel,matchscore = matchscore,joinTimes=joinTimes,winTimes=winTimes,continuousWinTimes=continuousWinTimes, useMountsMes = useMountsMes, professionId = professionId}
    WZLog("SceneGuildWarRoom:setData = ",Serialize(self.m_tData))
    self.m_nHomeowner = wnersId
    self:initRelationShip()
	--公会战处理
    if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ then
        self.m_tData.startMode = 1
    end
	if self.m_root ~= nil then
		self:endPairTimer()
		self:_update()
	end
end

--@brief	进入房间
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneGuildWarRoom:receiveEnterRoomOk(roomId, roomStatus,battleMode, roomChannel, playerNumMode,sechedule,mapId, wnersId, startMode, playerNum, seatUsed, playerId, playerName, playerLevel, playerReady, playerSex, playerEquipment, playerWeaponLevel, vipLevel, playerTitle,roomName,roomPassword,fighting,pet,tournamentLevel,winNum,playNum,extranInfo,serviceId,tournamentExp,headColors,bodyColors,mentoringStr,coupleStr,chumStr,coupleNum,chumNum,mentoringNum,qualifyingLevel,matchscore,joinTimes,winTimes,continuousWinTimes, useMountsMes, professionId)
    WZLog("SceneGuildWarRoom:receiveEnterRoomOk =",roomId)
    self.m_tPlayersPetInfo = {}
    for i,v in ipairs(pet) do
    	local petInfo = json.decode(v)
    	table.insert(self.m_tPlayersPetInfo,petInfo)
    end
    self:closeLoading()
    
	self:setData(roomId, roomStatus,battleMode, roomChannel, playerNumMode,sechedule,mapId, wnersId, startMode, playerNum, seatUsed, playerId, playerName, playerLevel, playerReady, playerSex, playerEquipment, playerWeaponLevel, vipLevel, playerTitle,roomName,roomPassword,fighting,pet,tournamentLevel,winNum, playNum, extranInfo, serviceId, tournamentExp, headColors, bodyColors, mentoringStr,coupleStr, chumStr, coupleNum, chumNum, mentoringNum, qualifyingLevel, matchscore, joinTimes, winTimes, continuousWinTimes, useMountsMes, professionId)

	if self.m_root and self.m_bIsVoice and self.m_bIsVoiceState and GetElement(self.m_root,"conFigureVoice1_SceneGuildWarRoom",WZUIContainer) then
		if GlobalGame.m_nVoiceId then
			ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "1," .. GlobalGame.m_nVoiceId, 0 )
			ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "2," .. self.m_nSpeakerState, 0 )
			ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "3," .. self.m_nMicState, 0 )
		end
	end
end

function SceneGuildWarRoom:closeLoading()
	if self.m_nLoadingId ~= nil then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
		self.m_nLoadingId = nil
	end
end


--@brief	正在匹配中
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneGuildWarRoom:receiveMakePairring(roomId)
	if self.m_root == nil then
		return
	end
	WZLog("SceneGuildWarRoom:receiveMakePairring",roomId)
	if roomId == self.m_tData.roomId then
		self:setAllBtnStats(false)
		if  self.m_tData.startMode == 1 then
			self:startPairTimer()
		else
			self.m_nLoadingId = MsgBoxManager:showLoadingBox(30)
		end
		self.m_bStartGame = true
		if self:getIsRoomOwner() and self.m_tData.startMode == 1 then
			self:changeStartGameBtn(LocalStrings.CANCEL_PAIR_GAME)
		end
	end
end

--@brief  改开始游戏为取消匹配
function SceneGuildWarRoom:changeStartGameBtn(btnName)
	WZLog("SceneGuildWarRoom:changeStartGameBtn",btnName)
	local labStartGame = GetElement(self.m_root,"labStartGame_SceneGuildWarRoom",WZUILabelTTF)
	labStartGame:setText(btnName)
end


--@brief	正在匹配中
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneGuildWarRoom:receiveMakePairError(nFlag, sMessage)
	if self.m_root == nil then
		return
	end
	WZLog("SceneGuildWarRoom:receiveMakePairError",nFlag, sMessage)
	self.m_bStartGame = false
	self:closeLoading()
	if nFlag == 0 then
		MsgBoxManager:showConfirmBox(sMessage,nil,nil,nil,nil,true)
		self:setAllBtnStats(true)
		self:endPairTimer()
		if self:getIsRoomOwner() then
			self:changeStartGameBtn(LocalStrings.START_GAME)
		end
		--self:_update()
	end
end

--@brief	匹配失败
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneGuildWarRoom:receiveMakePairFail()
	if self.m_root == nil then
		return
	end
	WZLog("SceneGuildWarRoom:receiveMakePairFail")
	self.m_bStartGame = false
	self:closeLoading()
	if self.m_tData.startMode == 1 then
		MsgBoxManager:showConfirmBox(LocalStrings.MATCHES_TIMEOUT,nil,nil,nil,nil,true)
	else
		MsgBoxManager:showConfirmBox(LocalStrings.MATCH_FAILED,nil,nil,nil,nil,true)
	end
	self:setAllBtnStats(true)
	if self:getIsRoomOwner() then
		self:changeStartGameBtn(LocalStrings.START_GAME)
	end
	self:endPairTimer()
end

--@brief  是否已点击开始游戏按钮
function SceneGuildWarRoom:isStartGame()
	WZLog("SceneGuildWarRoom:isStartGame")
	local labStartGame = GetElement(self.m_root,"labStartGame_SceneGuildWarRoom",WZUILabelTTF)
	if self:getIsRoomOwner() then
		if labStartGame:getText() == LocalStrings.START_GAME then
		    return false
	    end
	end
	
	return true
end

--@brief	匹配完成
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneGuildWarRoom:receiveMakePairOk(battleId, battleMode, battleChannle, schedule, mapId, 
	playerCount, playerCamp,playerId, serverId, playerName, playerTitle, playerCommunity, 
	playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense,
	 reduceCrit, reduceBury, power, armor, constitution, agility, lucky, winRate, fighting, headId, 
	 faceId, bodyId, weaponId, wingId, item_id, playerBuffCount, buffId, petId, petSkill, petParam, 
	 weaponSkill,tournamentLevel,teamId,teamName,url,petLevel, colour, bodyColour, isCaptain,footmark, monsterId, professionId, professionSkill, mountId, childId, childName, childSex, childImage, assistSkillIds, defaultShapeBigSkill, blastEffect, extPropertyKey, extPropertyValue, extPropertyCount)
	if self.m_root == nil then
		return
	end
	WZLog("SceneGuildWarRoom:receiveMakePairOk")

	self:closeLoading()
	self:endPairTimer()

    TeachGroup1:endTeachStep({20,5})
    WBattleGlobal:getCurrent():destroy()
    WBattleGlobal:getCurrent().m_tMakePairOk = {
    battleId=battleId,battleMode=battleMode, battleChannle=battleChannle, schedule=schedule,mapId=mapId,playerCount=playerCount,playerCamp=playerCamp,playerId=playerId,serverId=serverId,playerName=playerName,

    playerTitle=playerTitle,playerCommunity=playerCommunity,playerLevel=playerLevel,playerSex=playerSex,maxHP=maxHP,maxPF=maxPF,maxSP=maxSP,attack=attack,

    critRate=critRate,defence=defence,injuryFree=injuryFree,wreckDefense=wreckDefense,reduceCrit=reduceCrit,reduceBury=reduceBury,power=power,armor=armor,

    constitution=constitution,agility=agility,lucky=lucky,winRate=winRate,fighting=fighting,headId=headId,faceId=faceId,bodyId=bodyId,weaponId=weaponId,wingId=wingId,item_id=item_id,

playerBuffCount=playerBuffCount,buffId=buffId,petId=petId, petSkill=petSkill,petLevel=petLevel,petSkillId=petId,petParam=petParam,guaiBattleId=guaiBattleId,guaiId=guaiId,weaponSkill=weaponSkill,tournamentLevel=tournamentLevel,
teamId =teamId,teamName=teamName,url=url, colour=colour, bodyColour=bodyColour, isCaptain=isCaptain,footmark = footmark, monsterId = monsterId, professionId = professionId, professionSkill = professionSkill, mountId = mountId, childId = childId, childName = childName, childSex = childSex, childImage = childImage, assistSkillIds = assistSkillIds, defaultShapeBigSkill = defaultShapeBigSkill, blastEffect = blastEffect, extPropertyKey = extPropertyKey, extPropertyValue = extPropertyValue, extPropertyCount = extPropertyCount}

	WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_NORMAL

    WZLog("self.m_tData.serviceMode", self.m_tData.serviceMode, self.m_tData.startMode)
    if self.m_tData.startMode == 1 and GlobalGame.g_tSysConfig.crossLevel ~= 0 then
        WBattleGlobal:getCurrent().m_nServiceMode = self.m_tData.serviceMode
    else
        WBattleGlobal:getCurrent().m_nServiceMode = 0
    end
	--等待一秒执行加载战斗场景界面
    WZLog("SceneGuildWarRoom:receiveMakePairOk",tostring(GlobalGame.g_tPlayerInfo.nLevel),tostring(GlobalGame.g_tSysConfig.openTipLevel),tostring(GlobalGame.g_tPlayerInfo.nLevel),tostring(self.m_nPairRemainTime))
    if self.m_nPairRemainTime == nil then
        self.m_nPairRemainTime = 10
    end
    self.m_toSceneBattleLoading = true
	replaceScene(SceneBattleLoading:createElement())
end

--@brief	退出房间
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneGuildWarRoom:receiveQuitRoomOk(mark)
	WZLog("SceneGuildWarRoom:receiveQuitRoomOk = ",mark)
	if self.m_root == nil then
		return
	end

    if mark then
		DelayCallFunction(function ()
			MsgBoxManager:showTipBox(LocalStrings.BOOSROOM_KICKEDOUT)
		end,nil,0.5)
    end

	--公会战房间退出到公会场景
    SceneCommunityWar:showInterface()
end

function SceneGuildWarRoom:removeBottomBar()
    local wndBottomBar = self.m_root:getChildByTag(88)
    if wndBottomBar then
        self.m_root:removeChildByTag(88,true)
    end
end


function SceneGuildWarRoom:setPlayerTeam(playerId,team)
	WZLog("SceneGuildWarRoom:setPlayerTeam")
	GlobalGame.g_nPlayerInTeam = team
end

--显示当前房间的玩家聊天信息
function SceneGuildWarRoom:showChat(txtMsg,playerId,bubbleId)
	WZLog("SceneGuildWarRoom:showChat ",txtMsg,playerId)
	local seatIndex = self:findPlayerSeatById(playerId)
	if seatIndex > 0 then
		local conPlayer = GetElement(self.m_root,"conPlayer" .. seatIndex .. "_SceneGuildWarRoom")
		if conPlayer ~= nil then
			local parentNode = conPlayer:getParent()
			local parentNode1Size = parentNode:getContentSize()
			local ps = parentNode:convertToWorldSpace(GlobalMethod:ccp(0,0))
			ps = self.m_root:convertToNodeSpace(ps)
			ps.x = ps.x + parentNode1Size.width/2
			ps.y = ps.y + parentNode1Size.height/2
			local tPS = {x=ps.x,y = ps.y}
			tPS.y = tPS.y+parentNode1Size.height/2.5
			WZLog("ps = ",ps.x,ps.y)
			local cellChatBubble = self.m_root:getChildByTag(seatIndex+1110)
			if not cellChatBubble then
				local cellChatBubblenode,luaObject  = CellChatBubble:showChatBubble(self.m_root,tPS)
				cellChatBubblenode:setTag(seatIndex+1110)
				luaObject:addMsgToList(txtMsg,playerId,bubbleId)
			else
				cellChatBubble = WZUIContainer:luaTo(cellChatBubble)
				local luaObject = cellChatBubble:getLuaObjectIndex()
				luaObject:addMsgToList(txtMsg,playerId,bubbleId)
			end
		end
	end
end

--检查当前座位是否有冒泡,有的话检查玩家ID是否跟当前冒泡ID一样
function SceneGuildWarRoom:checkCellChatBubble(seatIndex)
	WZLog("SceneGuildWarRoom:checkCellChatBubble ")
	local cellChatBubble = self.m_root:getChildByTag(seatIndex+1110)
	if cellChatBubble ~= nil then
		local cellChatBubbleLuaObject = cellChatBubble:getLuaObjectIndex()
		if cellChatBubbleLuaObject ~= nil then
			local curSeatPlayerId = cellChatBubbleLuaObject.m_nPlayerId
			if self.m_tData.playerId[seatIndex] ~= curSeatPlayerId  then
				self.m_root:removeChild(cellChatBubble,true)
			end
		end
	end
end

--保存各种关系的数值
function SceneGuildWarRoom:initRelationShip()
	WZLog("SceneGuildWarRoom:initRelationShip")
	self.m_MasterList = nil   --师徒关系列表
    self.m_FriendList = nil   --朋友关系列表
    self.m_SpouseList = nil   --夫妻关系列表
    self.m_CoupleNum = nil
    self.m_ChumNum = nil
    self.m_MentoringNum = nil

	if self.m_tData ~= nil then
		if self.m_tData.mentoringStr ~= "" and self.m_tData.mentoringStr ~= nil then  --师徒关系
			self.m_MasterList = {}
			local temp = self.m_tData.mentoringStr
		    local temp2 =  SplitStringWithSeparator(temp,",")
		    for i,v in ipairs(temp2) do
		    	table.insert(self.m_MasterList,v)
		    end
		end

		if self.m_tData.coupleStr ~= "" and self.m_tData.coupleStr ~= nil then  --夫妻关系
			self.m_SpouseList = {}
			local temp = self.m_tData.coupleStr
		    local temp2 =  SplitStringWithSeparator(temp,",")
		    for i,v in ipairs(temp2) do
		    	table.insert(self.m_SpouseList,v)
		    end
		end

		if self.m_tData.chumStr ~= "" and self.m_tData.chumStr ~= nil then --密友关系
			self.m_FriendList = {}
			local temp = self.m_tData.chumStr
		    local temp2 =  SplitStringWithSeparator(temp,",")
		    for i,v in ipairs(temp2) do
		    	table.insert(self.m_FriendList,v)
		    end
		end

		if self.m_tData.coupleNum ~= "" and self.m_tData.coupleNum ~= nil then --夫妻恩爱值
			self.m_CoupleNum = {}
			local temp = self.m_tData.coupleNum
		    local temp2 =  SplitStringWithSeparator(temp,",")
		    for i,v in ipairs(temp2) do
		    	table.insert(self.m_CoupleNum,v)
		    end
		end

		if self.m_tData.chumNum ~= "" and self.m_tData.chumNum ~= nil then --密友关系值
			self.m_ChumNum = {}
			local temp = self.m_tData.chumNum
		    local temp2 =  SplitStringWithSeparator(temp,",")
		    for i,v in ipairs(temp2) do
		    	table.insert(self.m_ChumNum,v)
		    end
		end

		if self.m_tData.mentoringNum ~= "" and self.m_tData.mentoringNum ~= nil then --师徒值
			self.m_MentoringNum = {}
			local temp = self.m_tData.mentoringNum
		    local temp2 =  SplitStringWithSeparator(temp,",")
		    for i,v in ipairs(temp2) do
		    	table.insert(self.m_MentoringNum,v)
		    end
		end
	end
end

--解析后的好友度信息使用按规则保存,返回
--@param  玩家ID
function SceneGuildWarRoom:getFriendRV(playerId)
    WZLog("SceneGuildWarRoom:getFriendRV")
    local temp3 = {}
    if self.m_FriendList == nil then
        return nil
    end
    for i,v in ipairs(self.m_FriendList) do
    	local temp =  SplitStringWithSeparator(v,"|")
    	local friendId = nil
    	if tonumber(temp[1]) == playerId then
    		friendId = temp[2]
    	elseif tonumber(temp[2]) == playerId then
    		friendId = temp[1]
    	end
    	if friendId ~= nil then
    	    friendId = tonumber(friendId)
			local index = nil
			for j,k in ipairs(self.m_tData.playerId) do
				if friendId == k then
				   index = j
				   break
				end
			end
			local friendName = nil --密友名字
			local friendSex = nil  --密友性别
			local friendValue = nil --密友值
			friendName = self.m_tData.playerName[index]
			friendSex = self.m_tData.playerSex[index]
			friendValue = self.m_ChumNum[i]
			friendValue = tonumber(friendValue)

			local temp2 = {}
			table.insert(temp2,friendName)
			table.insert(temp2,friendValue)
			table.insert(temp2,friendSex)

			table.insert(temp3,temp2)
    	end
    end
    return temp3
end

--解析师徒信息按规则保存,返回
--@param  玩家ID
function SceneGuildWarRoom:getMasterRV(playerId,playerLevel)
    WZLog("SceneGuildWarRoom:getMasterRV = ",Serialize(self.m_MasterList))
    if self.m_MasterList == nil then
        return nil
    end
    local temp3 = {}
    for i,v in ipairs(self.m_MasterList) do
    	local temp =  SplitStringWithSeparator(v,"|")
    	local masterId = nil
    	if tonumber(temp[1]) == playerId then
    		masterId = temp[2]
    	elseif tonumber(temp[2]) == playerId then
    		masterId = temp[1]
    	end
    	if masterId ~= nil then
    	    masterId = tonumber(masterId)
			local index = nil
			for j,k in ipairs(self.m_tData.playerId) do
				if masterId == k then
				   index = j
				   break
				end
			end
			local playerName = self.m_tData.playerName[index]
			local tempLevel = self.m_tData.playerLevel[index]
			local bMaster = nil
			if playerLevel > tempLevel then
				bMaster = true
			else 
				bMaster = false
			end

			local temp = {}
			
			local temp2 = self.m_MentoringNum[i]
			local temp33 = SplitStringWithSeparator(temp2,"|")

            local masterNum = temp33[1]
            local masterName = playerName
            local masterLevel = tonumber(temp33[2])

            table.insert(temp,bMaster)
            table.insert(temp,masterNum)
            table.insert(temp,masterName)
            table.insert(temp,masterLevel)

            table.insert(temp3,temp)
    	end
    end
    return temp3
end

--解析夫妻信息按规则保存,返回
--@param  玩家ID
function SceneGuildWarRoom:getSpouseRV(playerId,playerSex,playerName)
	WZLog("SceneGuildWarRoom:getSpouseRV ")
	if self.m_SpouseList == nil or self.m_CoupleNum == nil then
        return nil,nil,nil,nil
    end
	for i,v in ipairs(self.m_SpouseList) do
		local temp =  SplitStringWithSeparator(v,"|")
		local spouseId = nil
		if tonumber(temp[1]) == playerId then
			spouseId = temp[2]
		elseif tonumber(temp[2]) == playerId then
			spouseId = temp[1]
		end
		if spouseId ~= nil then
			spouseId = tonumber(spouseId)
			local husbandName = nil
			local wifeName = nil
			
			local index = nil
			for j,k in ipairs(self.m_tData.playerId) do
				if spouseId == k then
					index = j
					break
				end
			end
			if index ~= nil then
				if husbandName == nil then
					husbandName = self.m_tData.playerName[index]
				end

				if wifeName == nil then
					wifeName = self.m_tData.playerName[index]
				end
			end

			local tmepp =  self.m_CoupleNum[i]
			local temppp =  SplitStringWithSeparator(tmepp,"|")
			local spouseValue = temppp[1]
			local spuseLevel = temppp[2]
			return spouseValue,tonumber(spuseLevel),wifeName,husbandName
		end
	end
	return nil,nil,nil,nil
end

--@brief    设置数据
--@note     获取服务器的日期，最近开始比赛的时间戳
function SceneGuildWarRoom:onReceiveCommunityWarTimeOK(nowtime, startime, open)
    -- body
    if SceneGuildWarRoom.m_root == nil then return end 

    self:closeLoading()
    self.m_nCommunityState = open 
    self.m_sCommunityTime = nowtime 
    self.m_nNextStartTime = startime

    self:initRoomView()
end

--@brief    更新技能方案名字
function SceneGuildWarRoom:updateSkillSuitData()
    -- body
    if self.m_root == nil then return end 

    self:setSkillSuitName()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	根据id获取物品路径，再进行截取
--@param	物品id表
--@return   物品路径表
function SceneGuildWarRoom:idToPath(idTable)
	local playerEquipmentT = {}
    for key,val in pairs(idTable) do
    	if val ~= 0 and val ~=nil and val ~="" then
    		local shopItem = GDatatab_item["id_"..val].animation_index_code
    		local subType = GDatatab_item["id_"..val].sub_type
    		if key == 1 then
    			playerEquipmentT.head = shopItem
    		elseif key == 2 then
    			playerEquipmentT.face = shopItem
    		elseif key == 3 then
    			playerEquipmentT.body = shopItem
    		elseif key == 4 then
    			playerEquipmentT.weaponType = subType
    			playerEquipmentT.weapon = shopItem
    		elseif key == 5 then
    			playerEquipmentT.wing = shopItem
    		end
    	else
    		if key == 1 then
    			playerEquipmentT.head = ""
    		elseif key == 2 then
    			playerEquipmentT.face = ""
    		elseif key == 3 then
    			playerEquipmentT.body = ""
    		elseif key == 4 then
    			playerEquipmentT.weaponType = 0
    			playerEquipmentT.weapon = ""
    		elseif key == 5 then
    			playerEquipmentT.wing = ""
    		end
    	end
    end
    return playerEquipmentT
end

--@brief  添加顶部导航栏
function SceneGuildWarRoom:addTop()
	WZLog("SceneGuildWarRoom:addTop")
	local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    self.m_tTopHangle = tcell
    self.m_oTopObject = cell
    
    --bag_icon_ruweisaifj
    tcell:setTopData("ui/community/bag_icon_chuxianfj.png",SceneGuildWarRoom,SceneGuildWarRoom.onCloseClick,true,1,true,"SceneGuildWarRoom")
end

-------------------------------------私有方法模块End----------------------------------------
