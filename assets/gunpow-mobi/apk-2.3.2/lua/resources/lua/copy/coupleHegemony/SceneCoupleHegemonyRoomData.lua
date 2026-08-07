--SceneCoupleHegemonyRoomData.lua
--@brief	SceneCoupleHegemonyRoom的数据模块
--@date		2018/07/12
--@author	Tianxiang_Xu
--@note		世界组队boss房间

SceneCoupleHegemonyRoom = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCoupleHegemonyRoom:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil                  --场景ui信息
    self.m_tMapData = nil               --地图信息
    self.m_nLoadingId = nil             --转菊花id
    self.m_nPairRemainTime = nil        --匹配剩余时间
    self.m_tPopupMenuItems = nil        --点击座位弹出框
    self.m_nPlayerIndex = nil           --点击玩家的index
    self.m_bCanClickSeat = true         --是否可以点击座位
    self.m_bShowTipsSkillProp = false   --显示技能道具提示
    self.m_nDialogLuaObj = nil          --技能道具对话框
    self.m_nDialogFlag = false           --对话框标记
    self.m_tPlayer = nil 
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
    self.m_nSpeakerState = 0
    self.m_nMicState = 0
    self.m_tVoiceId = nil
    self.m_tVoiceState = nil
    self.m_tMicState = nil
    self.m_nVoiceTimer = 0
    self.m_bIsFirstSendVoice = false
    self.m_bIsVoiceState = false
    self.m_bIsVoice = false
    self.checkTag = nil
    self.m_tCellDressSuit = nil         --多套时装的cell
    self.m_nBossCurBlood = 0 			--boss当前血量
    self.m_conBossInfo = nil 
    self.m_nMaxBlood = nil              --boss最大血量
    self.m_nMyInspire = nil 
    self.inspireData = {}
    self.loadingId = nil 
    self.bossRoomInfo = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCoupleHegemonyRoom:_unInit()
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
    self.m_nSpeakerState = 0
    self.m_nMicState = 0
    self.m_tVoiceId = nil
    self.m_tVoiceState = nil
    self.m_tMicState = nil
    self.m_nVoiceTimer = 0
    self.m_bIsFirstSendVoice = false
    self.m_bIsVoiceState = false
    self.m_bIsVoice = false
    self.checkTag = nil
    self.m_bIsCreate = nil
    self.m_tCellDressSuit = nil         --多套时装的cell
    self.m_nBossCurBlood = nil
    self.m_conBossInfo = nil 
    self.m_nMaxBlood = nil
    self.m_nMyInspire = nil 
    self.inspireData = {}
    self.loadingId = nil 
    self.bossRoomInfo = nil 
    self.m_tReturnCallBack = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------
local roomSeatModel = nil

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCoupleHegemonyRoom:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCoupleHegemonyRoom")
	assert(element, "SceneCoupleHegemonyRoom create element failed!")
	self:_init()
	return element
end

--@brief   外部接口
function SceneCoupleHegemonyRoom:showEnter()
    ProtocolProcessorWndCoupleHegemonyRoom:regAll() --注册协议

    local name = string.format(LocalStrings.ROOMS, CacheCenter:getPlayerInfo().name)
    ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_CreateRoom(name, "-1")
end

--@brief   外部接口
function SceneCoupleHegemonyRoom:showInterface()
    local scene = SceneCoupleHegemonyRoom:createElement()
    replaceScene( scene )
end

--@brief    设置房间信息   
function SceneCoupleHegemonyRoom:setData(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId, serverId,
            playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel, vipLevel, player_title, qualifyingLevel, zsleve, playerStar, playerFighting, pet, extranInfo, playerHeadColour, playerBodyColour, mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, matchLevel, matchscore, joinTimes, winTimes, continuousWinTimes, serviceId, inspire)
    if self.m_nRoomSeatModel == nil then
        self.m_nRoomSeatModel = playerNum
    end
    if self.m_tData ~= nil and self.m_tData.roomId ~= nil and self.m_root ~= nil then
        if self.m_nHomeowner ~= wnersId and wnersId == GlobalGame.g_tPlayerInfo.nPlayerId then
            MsgBoxManager:showTipBox(LocalStrings.HOMEOWNER_TIP)
        end
    end
    self.m_tData = {roomId = roomId,battleMode = GlobalGame.g_tBattleMode.BATTLE_MODE_FB,playerStar = playerStar ,fighting = playerFighting,serviceId=serviceId, roomChannel=GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_FQZB, playerNumMode=playerNumMode, mapId=mapId, wnersId=wnersId, playerNum=playerNum, seatUsed=seatUsed, playerId=playerId, playerName=playerName, playerLevel=playerLevel, playerReady=playerReady, playerSex=playerSex, playerEquipment=playerEquipment, playerWeaponLevel=playerWeaponLevel, vipLevel=vipLevel, playerTitle=player_title,roomName=roomName,passWord=passWord,pet=pet,extranInfo=extranInfo,serviceId=serviceId,headColors=playerHeadColour,bodyColors=playerBodyColour,mentoringStr=mentoringStr,coupleStr=coupleStr,chumStr= chumStr,coupleNum=coupleNum,chumNum=chumNum,mentoringNum=mentoringNum,qualifyingLevel=matchLevel,matchscore = matchscore,joinTimes=joinTimes,winTimes=winTimes,continuousWinTimes=continuousWinTimes, inspire=inspire}
    WZLog("SceneCoupleHegemonyRoom:setData")
    self.m_nHomeowner = wnersId

    self:initRelationShip()
    
    if self.m_root ~= nil then
        self:endPairTimer()
        self:_update()
    end
end

--@brief    进入房间
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function SceneCoupleHegemonyRoom:receiveEnterRoomOk(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId,serverId, playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel, vipLevel, player_title, qualifyingLevel,zsleve, playerStar, playerFighting, pet, extranInfo, playerHeadColour, playerBodyColour, mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, matchLevel, matchscore, joinTimes, winTimes, continuousWinTimes, serviceId, inspire)
    self.m_tPlayersPetInfo = {}
    for i,v in ipairs(pet) do
        local petInfo = json.decode(v)
        table.insert(self.m_tPlayersPetInfo,petInfo)
    end
    for i = 1, #playerId do
        if playerId[i] == CacheCenter:getPlayerInfo().id then 
            if self.m_nMyInspire == nil then 
                self.m_nMyInspire = inspire[i]
                break 
            end
        end
    end

    self:closeLoadingBox()
    
    self:setData(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId,serverId,
            playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel,
            vipLevel,player_title,qualifyingLevel,zsleve, playerStar,playerFighting,pet,extranInfo,playerHeadColour,playerBodyColour,
            mentoringStr,coupleStr,chumStr,coupleNum,chumNum,mentoringNum,matchLevel,matchscore,joinTimes,winTimes,continuousWinTimes,serviceId,inspire)
    
    WZLog("SceneCoupleHegemonyRoom:receiveEnterRoomOk =", Serialize(inspire))
    if self.m_root and self.m_bIsVoice and self.m_bIsVoiceState and GetElement(self.m_root,"conFigureVoice1_SceneCoupleHegemonyRoom",WZUIContainer) then
        if GlobalGame.m_nVoiceId then
            ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "1," .. GlobalGame.m_nVoiceId, 0 )
            ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "2," .. self.m_nSpeakerState, 0 )
            ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "3," .. self.m_nMicState, 0 )
        end
    end
end

function SceneCoupleHegemonyRoom:closeLoading()
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
        self.m_nLoadingId = nil
    end
end


--@brief    玩家被邀请进入副本房间
function SceneCoupleHegemonyRoom:beInvited(roomId , playerName,mapId, password, roomChannel, interfaceId, playerId)
    WZLog("SceneCoupleHegemonyRoom:beInvited")

    local data = GDatatab_couple_fight_boss_map["id_"..mapId]
    desc = string.format(LocalStrings.COUPLE_HEGEMONY_TEXT9, playerName)
    
    WndInvited:showInterface(self, self.send_EnterRoom, roomId, password, mapId, desc, playerName,nil,nil,roomChannel,nil,interfaceId, playerId)
end

--@brief    被邀请时，确定按钮的回调  (发送进入房间的协议)
function SceneCoupleHegemonyRoom:send_EnterRoom(roomId,roomChannel,password,mapId,des,battleId)
    WZLog("SceneCoupleHegemonyRoom:send_EnterRoom ")
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    ProtocolProcessorWndCoupleHegemonyRoom:regAll()
    
    ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_SelectRoom(roomId, password)
end

--@brief    手动更新房间
function SceneCoupleHegemonyRoom:updateRoom()
    WZLog("SceneCoupleHegemonyRoom:updateRoom")
    if self.m_root ~= nil then
    	ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_UpdateRoom(self.m_tData.roomId, self.m_tData.passWord, self.m_tData.roomName)
    end
end

--@brief    正在匹配中
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function SceneCoupleHegemonyRoom:receiveMakePairring(roomId)
    if self.m_root == nil then
        return
    end
    WZLog("SceneCoupleHegemonyRoom:receiveMakePairring",roomId)
    if roomId == self.m_tData.roomId then
        self:startPairTimer()
    end
end

--@brief  改开始游戏为取消匹配
function SceneCoupleHegemonyRoom:changeStartGameBtn(iconPath)
    WZLog("SceneCoupleHegemonyRoom:changeStartGameBtn")
    local imgStartGame = GetElement(self.m_root,"imgStartGame_SceneCoupleHegemonyRoom",WZUIImage)
    imgStartGame:setFile(iconPath)
end

--@brief    玩家技能
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function SceneCoupleHegemonyRoom:receiveGetPlayerSkillOk(itemId,skillExplain)
    WZLog("SceneCoupleHegemonyRoom:receiveGetPlayerSkillOk")
    if WndSkillProp.m_root ~= nil then
        WZLog("WndSkillProp.m_root ~= nil")
        self.m_bShowTipsSkillProp = false
    else
        for i=1,#itemId do
            if itemId[i] == 0 then
                self.m_bShowTipsSkillProp = true
            end
        end
    end 
end

--@brief    正在匹配中
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function SceneCoupleHegemonyRoom:receiveMakePairError(nFlag, sMessage)
    if self.m_root == nil then
        return
    end
    WZLog("SceneCoupleHegemonyRoom:receiveMakePairError",nFlag, sMessage)
    if nFlag == 0 then
        MsgBoxManager:showConfirmBox(sMessage,nil,nil,nil,nil,true)
        self:endPairTimer()
    end
end

--@brief    匹配失败
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function SceneCoupleHegemonyRoom:receiveMakePairFail()
    WZLog("SceneCoupleHegemonyRoom:receiveMakePairFail")
    MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_MATCH_FAILED)
    
    self:endPairTimer()
    self:_update()
end

--@brief    匹配完成
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function SceneCoupleHegemonyRoom:receiveStartOk(battleId, mapId, playerCount, playerId, serverId, playerName, playerTitle, playerGuild, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, inspire, headId, faceId, bodyId, weaponId, wingId, item_id, skillId, playerBuffCount, buffId, petAnimation, petGift, guaiBattleId, guaiId, guaiMaxHP, guaiNowHP, guaiAttack, petAdvancedLevel, colour, bodycolour, footmark, professionId, professionSkill, mountId, childId, childName, childSex, childImage, assistSkillIds, defaultShapeBigSkill, blastEffect, extPropertyKey, extPropertyValue, extPropertyCount)
	WZLog("SceneCoupleHegemonyRoom:receiveStartOk")

    for i , v in pairs( attack ) do
		WZLog("SceneCoupleHegemonyRoom:receiveStartOk attack = " , v)
	end
    local tempGuaiMaxHp = {}
    local tempGuaiNowHp = {}
    for i = 1, #guaiMaxHP do
        tempGuaiMaxHp[i] = tonumber(guaiMaxHP[i])
    end
    for i = 1, #guaiNowHP do
        tempGuaiNowHp[i] = tonumber(guaiNowHP[i])
    end

    local bIsRoomOwner = self:getIsRoomOwner()
    WBattleGlobal:getCurrent():destroy()
	WBattleGlobal:getCurrent().m_tMakePairOk ={
        battleId=battleId, battleMode=BattleConstants.g_tBossBattleMode.MODE_COUPLE_HEGEMONY, battleMull=false, battleChannle=-1,
        mapId=mapId,playerCount=playerCount,playerId=playerId,playerName=playerName,playerTitle=playerTitle,playerCommunity=playerGuild,
        playerLevel=playerLevel,playerSex=playerSex,maxHP=maxHP,maxPF=maxPF,maxSP=maxSP,attack=attack,critRate=critRate,defence=defence,
        injuryFree=injuryFree,wreckDefense=wreckDefense,reduceCrit=reduceCrit,power=power,armor=armor,constitution=constitution,agility=agility,
        lucky=lucky,inspire=inspire,headId=headId,faceId=faceId,bodyId=bodyId,weaponId=weaponId,wingId=wingId,item_id=item_id,playerBuffCount,
        buffId=buffId,petId=petAnimation,petSkill = skillId,petLevel=petAdvancedLevel,petSkillId=petAnimation,petParam=petGift, guaiBattleId=guaiBattleId,guaiId=guaiId,guaiMaxHP=tempGuaiMaxHp, guaiNowHP=tempGuaiNowHp,guaiAtk=guaiAttack,guaiLv = guaiLv,weaponSkill=skillId, colour=colour, bodyColour=bodycolour,footmark = footmark, professionId = professionId, professionSkill = professionSkill, mountId = mountId, childId = childId, childName = childName, childSex = childSex, childImage = childImage, assistSkillIds = assistSkillIds, bIsRoomOwner = bIsRoomOwner, defaultShapeBigSkill = defaultShapeBigSkill, blastEffect = blastEffect, extPropertyKey = extPropertyKey, extPropertyValue = extPropertyValue, extPropertyCount = extPropertyCount
    }
	WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_BOSS
    WBattleGlobal:getCurrent().battleMode = BattleConstants.g_tBossBattleMode.MODE_COUPLE_HEGEMONY
    self.m_toBattleLoadingScene = true
	replaceScene(SceneBattleLoading:createElement())

	--@brief   关闭加载框
	self:closeLoadingBox()
end

--@brief    退出房间需要发送退出协议
function SceneCoupleHegemonyRoom:onBackScene(isTurnToScene)
    if SceneCoupleHegemonyRoom.m_root == nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("SceneCoupleHegemonyRoom:onBackScene", self.m_tData, tostring(isTurnToScene))
    ProtocolProcessorSceneRoom:send_ROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat() )
    if isTurnToScene ~= nil then
        ProtocolProcessorSceneRoom:unregAll()
    end
end

--显示当前房间的玩家聊天信息
function SceneCoupleHegemonyRoom:showChat(txtMsg,playerId,bubbleId)
    WZLog("SceneCoupleHegemonyRoom:showChat ",txtMsg,playerId)
    local seatIndex = self:findPlayerSeatById(playerId)
    if seatIndex > 0 then
        local conCenter = GetElement(self.m_root,"conCenter_SceneCoupleHegemonyRoom",WZUIContainer)
        if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then  --练习赛
            conCenter = GetElement(self.m_root,"conCenter2_SceneCoupleHegemonyRoom",WZUIContainer)
        end
        local conSeat = GetElement(conCenter,"conSeat" .. seatIndex .. "_SceneCoupleHegemonyRoom",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_SceneCoupleHegemonyRoom")
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
function SceneCoupleHegemonyRoom:checkCellChatBubble(seatIndex)
    WZLog("SceneCoupleHegemonyRoom:checkCellChatBubble ")
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
function SceneCoupleHegemonyRoom:initRelationShip()
    WZLog("SceneCoupleHegemonyRoom:initRelationShip")
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
function SceneCoupleHegemonyRoom:getFriendRV(playerId)
    WZLog("SceneCoupleHegemonyRoom:getFriendRV")
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
function SceneCoupleHegemonyRoom:getMasterRV(playerId,playerLevel)
    WZLog("SceneCoupleHegemonyRoom:getMasterRV = ",Serialize(self.m_MasterList))
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
function SceneCoupleHegemonyRoom:getSpouseRV(playerId,playerSex,playerName)
    WZLog("SceneCoupleHegemonyRoom:getSpouseRV ")
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

--@brief    更新多套时装数据
function SceneCoupleHegemonyRoom:updateDressSuitData(nType)
    -- body
    if self.m_tCellDressSuit == nil then return end 
    if nType == 1 then
        self.m_tCellDressSuit:changeDressSuitOK()
    else
        self.m_tCellDressSuit:setSuitData()
    end
end

--@brief 	获取boss当前血量成功
function SceneCoupleHegemonyRoom:getBossBloodOk(nCurBlood, maxHp)
	-- body
    self:closeLoadingBox()

	self.m_nBossCurBlood = nCurBlood
    self.m_nMaxBlood = maxHp
	self.m_conBossInfo:disableSchedule()

	self:setBossInfo()
end

--@brief 	退出房间
function SceneCoupleHegemonyRoom:exitMulRoom()
    ProtocolProcessorWndCoupleHegemonyRoom:unregAll()
    local sceneIsland = SceneIsland:createElement()
    replaceScene(sceneIsland)
    if self.m_tReturnCallBack then
        self.m_tReturnCallBack[2](self.m_tReturnCallBack[1])
    end
end

--@brief    鼓舞返回
function SceneCoupleHegemonyRoom:inspireResult(inspire)
    if self.m_nMyInspire then 
        if self.m_nMyInspire >= inspire then 
            MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_ADD_Fail)
        else
            MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_ADD_SUCCESS)
        end
    end

    self.m_nMyInspire = inspire
    self:_showMyHurtAdd()
end

--@brief    设置伤害榜数据
function SceneCoupleHegemonyRoom:setHurtList(rankPlayerCount, rankPlayerId,rankPlayerName, rankPlayerSex, rankPlayerHeadId, rankPlayerFaceId, rankPlayerHeadColor, rankPlayerVipLevel, rankHurt, level, myRank, myHurt, curBossTotalHurt)
    -- body
    self:closeLoadingBox()
    local nIndex = 1
    self.hurtInfo = {}
    for i = 1, #rankPlayerCount do
        local tItem = {}
        tItem.rank = i
        tItem.count = rankPlayerCount[i]
        tItem.hurt = tonumber(rankHurt[i])
        tItem.player = {}
        for k = 1, rankPlayerCount[i] do
            local tempPlayer = {}
            tempPlayer.playerId = rankPlayerId[nIndex]
            tempPlayer.name = rankPlayerName[nIndex]
            tempPlayer.sex = rankPlayerSex[nIndex]
            tempPlayer.headId = rankPlayerHeadId[nIndex]
            tempPlayer.faceId = rankPlayerFaceId[nIndex]
            tempPlayer.headColor = rankPlayerHeadColor[nIndex]
            tempPlayer.vipLevel = rankPlayerVipLevel[nIndex]
            tempPlayer.level = level[nIndex]

            table.insert(tItem.player, tempPlayer)

            nIndex = nIndex + 1
        end
        table.insert(self.hurtInfo, tItem)
    end

    self.bossRoomInfo.myRank = myRank
    self.bossRoomInfo.hurt = myHurt
    self.bossRoomInfo.curBossTotalHurt = curBossTotalHurt
--    WZLog("SceneCoupleHegemonyRoom:setHurtList", Serialize(self.hurtInfo), self.bossRoomInfo.myRank, self.bossRoomInfo.hurt)

    self:updateMiddleInfo()
    self:_showFirstRankInfo()
end

--mapId int 地图id
--maxHp int boss总血量
--bossBloodCurrent  int boss当前血量
--inspire   int 当前鼓舞值（最大10000）
--myRank    int 我的伤害排名（0表示没有伤害）
--dimaCDTime    int 钻石鼓舞冷却时间(秒)
--goldCDTime    int 金币鼓舞冷却时间(秒)
--bossState     int BOSS状态 1 活着， 2死亡  3逃走
function SceneCoupleHegemonyRoom:setEnterRoomData( mapId, bossBloodCurrent, inspire, dimaCDTime, goldCDTime, bossState, openTime, challengeNum, leaveNum, maxHp)
    self:closeLoadingBox()
    if not self.m_root then return end
    if self.bossRoomInfo == nil then self.bossRoomInfo = {} end

    self.bossRoomInfo.mapId = mapId                         --房间地图id
    local bossData = GDatatab_couple_fight_boss_map["id_" .. mapId]
    self.bossRoomInfo.bossBloodMax = maxHp          --boss总血量
    self.bossRoomInfo.bossBloodCurrent = bossBloodCurrent   --boss当前血量
    
    self.bossRoomInfo.inspire = inspire                     --当前鼓舞值
    self.bossRoomInfo.bossLevel = GDatatab_monster["id_" .. bossData.monster[1][1]].level               --Boss的等级
    self.bossRoomInfo.diamondCDTime = dimaCDTime            -- 钻石鼓舞CD
    self.bossRoomInfo.goldCDTime = goldCDTime               -- 金币鼓舞CD
    self.bossRoomInfo.bossState = bossState                 -- boss状态
    self.bossRoomInfo.openTime = openTime                   -- 开启时间
    self.bossRoomInfo.totalNum = challengeNum                   -- 总挑战次数
    self.bossRoomInfo.leftNum = leaveNum                   -- 剩余挑战次数
    self.bossRoomInfo.bossName = bossData.map_name                   -- 怪物名字
    WZLog("SceneCoupleHegemonyRoom:setEnterRoomData", self.bossRoomInfo.totalNum, self.bossRoomInfo.leftNum, self.bossRoomInfo.openTime, self.bossRoomInfo.bossState, self.bossRoomInfo.bossBloodCurrent)
    -- 设置鼓舞状态、
    self:_setCurInspireState(inspire)

    self:_setLeftTimes()
end

--@brief    更新挑战次数
function SceneCoupleHegemonyRoom:updateChallengeTimes(times)
    -- body
    self:closeLoadingBox()

    self.bossRoomInfo.leftNum = times
    self:_setLeftTimes()
end

--@brief    设置退出世界boss回调
function SceneCoupleHegemonyRoom:setCallBackFun(tCell, func)
    -- body
    self.m_tReturnCallBack = {}
    self.m_tReturnCallBack[1] = tCell
    self.m_tReturnCallBack[2] = func
end

--@brief    更新技能方案名字
function SceneCoupleHegemonyRoom:updateSkillSuitData()
    -- body
    if self.m_root == nil then return end 

    self:setSkillSuitName()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief    根据id获取物品路径，再进行截取
--@param    物品id表
--@return   物品路径表
function SceneCoupleHegemonyRoom:idToPath(idTable)
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
function SceneCoupleHegemonyRoom:addTop()
    WZLog("SceneCoupleHegemonyRoom:addTop")
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    self.m_tTopHangle = tcell
    self.m_oTopObject = cell
    tcell:setTopData("ui/common/common_icon_fqzb.png",SceneCoupleHegemonyRoom,SceneCoupleHegemonyRoom.onClose,false,true,true,"SceneCoupleHegemonyRoom")
    tcell:setImageBgVisible(true)
    -- tcell:setWifiSignalVisible(false)
    -- tcell:setTopBGVisible(false)
    -- tcell.goldCellInfo.cell:setVisible(false)
    -- tcell:setTopTitleVisible(false)
    -- tcell:resetTitleSize()
end

function SceneCoupleHegemonyRoom:_shieldClick()
    WZLog("SceneCoupleHegemonyRoom:_shieldClick")
    local playerId = self.m_tData.playerId
    local wnersId = self.m_tData.wnersId
    local ready = self.m_tData.playerReady

    for i = 1, #playerId do
        local selfId = CacheCenter:getPlayerInfo().id
        if wnersId == selfId then
            if self.m_tTopHangle then
                self.m_tTopHangle:setShieldClick(false)
            end
            break
        elseif playerId[i] == selfId then
            if self.m_tTopHangle then
                self.m_tTopHangle:setShieldClick(ready[i])
            end
            break
        end
    end
end

-- 初始化当前鼓舞状态
-- startP 开始鼓舞值
-- endP 结束鼓舞值
-- bFlag 是否处于鼓舞状态
function SceneCoupleHegemonyRoom:_initInspireState()
    self.inspireData = {startP = 0, endP = 0, bFlag = false}
end

function SceneCoupleHegemonyRoom:_setCurInspireState(inspire)
    if self.inspireData.bFlag then
        self.inspireData.endP = self.bossRoomInfo.inspire
    else
        self.inspireData.startP = self.bossRoomInfo.inspire
    end
end

function SceneCoupleHegemonyRoom:createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(10,self,self.closeLoadingBox)
    end
end

function SceneCoupleHegemonyRoom:closeLoadingBox()
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
end

--@brief    挑战状态判断
function SceneCoupleHegemonyRoom:_challengeStateJudge()
    -- boss存活 boss死亡2 boss逃跑3 不能鼓舞
    if self.bossRoomInfo.bossState == 1 and self.bossRoomInfo.openTime > 0 then
        local coupleFightBossConfig = json.decode(CacheCenter:getGameParam().coupleFightBossConfig)
        local startTime = coupleFightBossConfig.startTime
        MsgBoxManager:showTipBox(string.format(LocalStrings.COUPLE_HEGEMONY_TEXT6,startTime))
        return false 
    elseif self.bossRoomInfo.bossState == 2 then
        MsgBoxManager:showTipBox(LocalStrings.COUPLE_HEGEMONY_TEXT7)
        return false
    elseif self.bossRoomInfo.bossState == 3 then
        MsgBoxManager:showTipBox(LocalStrings.COUPLE_HEGEMONY_TEXT5)
        return false
    end

    return true
end

--@brief    挑战次数判断
function SceneCoupleHegemonyRoom:_challengeTimesJudge()
    -- body
 --   do return true end 
    if self.bossRoomInfo.leftNum <= 0 then
        local num = self.bossRoomInfo.totalNum - self.m_tSysConfig.freeNum
        local buyData = self:getVipLimitData(num + 1)
        if buyData == nil then
            MsgBoxManager:showTipBox(LocalStrings.CHALLEGE_OVER)
        else
            local playerInfo = CacheCenter:getPlayerInfo()
            if playerInfo.vipLevel >= buyData.vip_level then
                local basicData = GDatatab_item["id_" .. buyData.cost[1][1]]
                local sContent = string.format(LocalStrings.TEAMBOSS_TEXT14, buyData.cost[1][2], basicData.icon)
                MsgBoxManager:showConfirmBox(sContent, self, self.sureToBuyTimes)
            else
                local sContent = string.format(LocalStrings.TEAMBOSS_TEXT15, buyData.vip_level)
                MsgBoxManager:showConfirmBox(sContent, self, self.sureToRecharge)
            end
        end
        return false
    else
        return true
    end
end

--@brief    确定购买次数
function SceneCoupleHegemonyRoom:sureToBuyTimes()
    -- body
    local num = self.bossRoomInfo.totalNum - self.m_tSysConfig.freeNum
    local buyData = self:getVipLimitData(num + 1)
    if buyData == nil then return end 

    if not JudgeMoneyIsEnough(buyData.cost[1][1], buyData.cost[1][2], nil, nil, Chat_Channel_WorldTeam_Boss, nil, nil, nil, nil, self, self.sureToUseDiaInstead) then
        return
    end

    self:sureToUseDiaInstead()
end

--@brief    确定使用蓝钻代替粉钻购买
function SceneCoupleHegemonyRoom:sureToUseDiaInstead()
    ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_BuyChallengeNum()
end

--@brief    确定充值
function SceneCoupleHegemonyRoom:sureToRecharge()
    PassportSdkManager:gotoPaymentPage()
end

--@brief    根据购买次数获取限购数据
function SceneCoupleHegemonyRoom:getVipLimitData(times)
    -- body
    for i, value in pairs(GDatatab_vip_restriction) do
        if value.type == 37 and value.count == times then
            return value
        end
    end

    return nil 
end

--@brief    根据id返回地图背景图
--@param    mapId:地图id
--@return   #1:地图背景图string
function SceneCoupleHegemonyRoom:_getMapBgById()
    WZLog("SceneCoupleHegemonyRoom:_getMapBgById")
    local roomData = self.m_tData
    local tCopyData = GDatatab_couple_fight_boss_map["id_"..roomData.mapId]
    return tCopyData.map .. "_bg.png"
end
-------------------------------------私有方法模块End----------------------------------------
