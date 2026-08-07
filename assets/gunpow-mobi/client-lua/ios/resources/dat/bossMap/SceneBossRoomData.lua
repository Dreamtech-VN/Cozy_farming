--SceneBossRoomData.lua
--@brief    SceneBossRoom的数据模块
--@date     2013/12/26
--@author   李光森
--@note     战斗房间

SceneBossRoom = {
    --请不要在这里定义变量
}

--@brief    定义并初始化表的成员变量
--@note     变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneBossRoom:_init()
    self.m_root = nil                   --场景根节点
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
    self.click = false
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function SceneBossRoom:_unInit()
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
    self.click = false
end


-------------------------------------公有方法模块Begin--------------------------------------
local roomSeatModel = nil
--@brief    创建场景
--@return   #1，场景element的引用
--@note     请仅用此方法创建场景
function SceneBossRoom:createElement()
    WZLog("SceneBossRoom:createElement")
    local element = WZUISystem:getInstance():createElement("SceneBossRoom")
    assert(element, "SceneBossRoom create element failed!")
    self:_init()
    return element
end

--@brief    设置房间信息   
function SceneBossRoom:setData(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId,serverId,
            playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel,
            vipLevel,player_title,qualifyingLevel,zsleve, playerStar,playerFighting,pet,extranInfo,playerHeadColour,playerBodyColour,
            mentoringStr,coupleStr,chumStr,coupleNum,chumNum,mentoringNum,matchLevel,matchscore,joinTimes,winTimes,continuousWinTimes,serviceId,assist)
    if self.m_nRoomSeatModel == nil then
        self.m_nRoomSeatModel = playerNum
    end
    if self.m_tData ~= nil and self.m_tData.roomId ~= nil and self.m_root ~= nil then
        if self.m_nHomeowner ~= wnersId and wnersId == GlobalGame.g_tPlayerInfo.nPlayerId then
            if not self:_isByAssitOnly(playerId,assist) then
                MsgBoxManager:showTipBox(LocalStrings.HOMEOWNER_TIP)
            end
        end
    end
    self.m_tData = {roomId = roomId,battleMode = GlobalGame.g_tBattleMode.BATTLE_MODE_FB,playerStar = playerStar ,fighting = playerFighting,serviceId=serviceId, roomChannel=GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZF, playerNumMode=playerNumMode, mapId=mapId, wnersId=wnersId, playerNum=playerNum, seatUsed=seatUsed, playerId=playerId, playerName=playerName, playerLevel=playerLevel, playerReady=playerReady, playerSex=playerSex, playerEquipment=playerEquipment, playerWeaponLevel=playerWeaponLevel, vipLevel=vipLevel, playerTitle=player_title,roomName=roomName,passWord=passWord,pet=pet,extranInfo=extranInfo,serviceId=serviceId,headColors=playerHeadColour,bodyColors=playerBodyColour,mentoringStr=mentoringStr,coupleStr=coupleStr,chumStr= chumStr,coupleNum=coupleNum,chumNum=chumNum,mentoringNum=mentoringNum,qualifyingLevel=matchLevel,matchscore = matchscore,joinTimes=joinTimes,winTimes=winTimes,continuousWinTimes=continuousWinTimes,assist=assist}
    WZLog("SceneBossRoom:setData")
    self.m_nHomeowner = wnersId
    self:initRelationShip()
    
    if self.m_root ~= nil then
        self:endPairTimer()
        self:_update()
    end
end

--@brief    进入房间
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function SceneBossRoom:receiveEnterRoomOk(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId,serverId,
            playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel,
            vipLevel,player_title,qualifyingLevel,zsleve, playerStar,playerFighting,pet,extranInfo,playerHeadColour,playerBodyColour,
            mentoringStr,coupleStr,chumStr,coupleNum,chumNum,mentoringNum,matchLevel,matchscore,joinTimes,winTimes,continuousWinTimes,serviceId,assist)
    self.m_tPlayersPetInfo = {}
    for i,v in ipairs(pet) do
        local petInfo = json.decode(v)
        table.insert(self.m_tPlayersPetInfo,petInfo)
    end
    self:closeLoading()
    
    self:setData(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId,serverId,
            playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel,
            vipLevel,player_title,qualifyingLevel,zsleve, playerStar,playerFighting,pet,extranInfo,playerHeadColour,playerBodyColour,
            mentoringStr,coupleStr,chumStr,coupleNum,chumNum,mentoringNum,matchLevel,matchscore,joinTimes,winTimes,continuousWinTimes,serviceId,assist)
    
    WZLog("SceneBossRoom:receiveEnterRoomOk =",Serialize(assist))
    if self.m_root and self.m_bIsVoice and self.m_bIsVoiceState and GetElement(self.m_root,"conFigureVoice1_SceneBossRoom",WZUIContainer) then
        if GlobalGame.m_nVoiceId then
            ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "1," .. GlobalGame.m_nVoiceId, 0 )
            ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "2," .. self.m_nSpeakerState, 0 )
            ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "3," .. self.m_nMicState, 0 )
        end
    end
end

function SceneBossRoom:closeLoading()
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
        self.m_nLoadingId = nil
    end
end


--@brief    玩家被邀请进入副本房间
function SceneBossRoom:beInvited(roomId , playerName,mapId, password,roomChannel,assist)
    WZLog("SceneBossRoom:beInvited")
    local data = GDatatab_team_map["id_"..mapId]
    -- 获取房间难度
    local diff = 1
    for k,v in pairs(GDatatab_team_map) do
        if v.id == mapId then
            diff = v.difficulty
            break
        end
    end
    local diffName = {LocalStrings.COMMON,LocalStrings.DIFFICULTY,LocalStrings.HELL}
    local desc = string.format(LocalStrings.ROOM_BEINVITED_4,playerName,data.map_name,diffName[diff])
    if assist == 1 then --不是助战玩家
        desc = string.format(LocalStrings.ROOM_BEINVITED,playerName,data.map_name,diffName[diff])
    end
    
    WndInvited:showInterface( self , self.send_EnterRoom , roomId , password, mapId,desc,playerName,nil,nil,roomChannel,assist)
end

--@brief    被邀请时，确定按钮的回调  (发送进入房间的协议)
function SceneBossRoom:send_EnterRoom(roomId,roomChannel,password,mapId,des,battleId,assist)
    WZLog("SceneBossRoom:send_EnterRoom ",assist)
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(roomId,password,mapId,roomChannel,assist)
end

--@brief    手动更新房间
function SceneBossRoom:updateRoom()
    WZLog("SceneBossRoom:updateRoom")
    if self.m_root ~= nil then
        ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateRoom(self.m_tData.roomId, -1, self.m_tData.passWord, -1, -1, self.m_tData.roomName)
    end
end

--@brief    正在匹配中
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function SceneBossRoom:receiveMakePairring(roomId)
    if self.m_root == nil then
        return
    end
    WZLog("SceneBossRoom:receiveMakePairring",roomId)
    if roomId == self.m_tData.roomId then
        self:startPairTimer()
    end
end

--brief    获取地图难度
function SceneBossRoom:_getDifficult()
    local tCopyData = GDatatab_team_map["id_"..self.m_tData.mapId]
    return tCopyData.difficulty
end

--@brief  改开始游戏为取消匹配
function SceneBossRoom:changeStartGameBtn(iconPath)
    WZLog("SceneBossRoom:changeStartGameBtn")
    local imgStartGame = GetElement(self.m_root,"imgStartGame_SceneBossRoom",WZUIImage)
    imgStartGame:setFile(iconPath)
end

--@brief    玩家技能
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function SceneBossRoom:receiveGetPlayerSkillOk(itemId,skillExplain)
    WZLog("SceneBossRoom:receiveGetPlayerSkillOk")
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

--brief    根据难度获取地图id
function SceneBossRoom:_getMapIdByDifficult(nDifficult)
    local tCopyData = GDatatab_team_map["id_"..self.m_tData.mapId]
    for i,v in pairs(GDatatab_team_map) do
        if v.map_num == tCopyData.map_num and v.difficulty == nDifficult then
            return v.id
        end
    end
end

--房间是否只有助战的玩家
function SceneBossRoom:_isByAssitOnly(playerId,assist)
    -- body
    WZLog("SceneBossRoom:_isByAssitOnly")
    local bOnlyAssit = true
    for i,v in ipairs(playerId) do
        if assist[i] == 1 then
            bOnlyAssit = false
            break
        end
    end
    return bOnlyAssit
end

--房间里只剩下助战玩家则退出房间
function SceneBossRoom:_exitRoomByAssitOnly()
    -- body
    WZLog("SceneBossRoom:_exitRoomByAssitOnly")
    if self:_isByAssitOnly(self.m_tData.playerId,self.m_tData.assist) then
        ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat())
    end
end



--@brief    正在匹配中
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function SceneBossRoom:receiveMakePairError(nFlag, sMessage)
    if self.m_root == nil then
        return
    end
    WZLog("SceneBossRoom:receiveMakePairError",nFlag, sMessage)
    if nFlag == 0 then
        MsgBoxManager:showConfirmBox(sMessage,nil,nil,nil,nil,true)
        self:endPairTimer()
    end
end

--@brief    匹配失败
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function SceneBossRoom:receiveMakePairFail()
    WZLog("SceneBossRoom:receiveMakePairFail")
    MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_MATCH_FAILED)
    
    self:endPairTimer()
    self:_update()
end

--@brief    匹配完成
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function SceneBossRoom:receiveMakePairOk(battleId, mapId, playerCount, playerId, serverId, playerName, playerTitle, playerCommunity, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, headId, faceId, bodyId, weaponId, wingId, item_id, playerBuffCount, buffId, petId,petSkill, petParam, guaiBattleId, guaiId,tournamentLevel,petLevel, colour, bodyColour,footmark)
    WZLog("SceneBossRoom:receiveMakePairOk")
    self:endPairTimer()
    WBattleGlobal:getCurrent():destroy()
    WBattleGlobal:getCurrent().m_tMakePairOk = {
    battleId=battleId, battleMull=false, battleChannle=-1,mapId=mapId,playerCount=playerCount,playerId=playerId, serverId=serverId,playerName=playerName,

    playerTitle=playerTitle,playerCommunity=playerCommunity,playerLevel=playerLevel,playerSex=playerSex,maxHP=maxHP,maxPF=maxPF,maxSP=maxSP,attack=attack,

    critRate=critRate,defence=defence,injuryFree=injuryFree,wreckDefense=wreckDefense,reduceCrit=reduceCrit,power=power,armor=armor,

    constitution=constitution,agility=agility,lucky=lucky,headId=headId,faceId=faceId,bodyId=bodyId,weaponId=weaponId,wingId=wingId,item_id=item_id,

    playerBuffCount=playerBuffCount,buffId=buffId,petId=petId,petSkill=petSkill,petLevel=petLevel,petSkillId=petId,petParam=petParam,guaiBattleId=guaiBattleId,guaiId=guaiId,battleMode=BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_2,tournamentLevel=tournamentLevel, colour=colour, bodyColour=bodyColour ,footmark = footmark}


    WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_BOSS
    WBattleGlobal:getCurrent().battleMode = BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_2
    --保存标记，游戏中获取装备时，等自动跳转会副本界面时才弹装备提示
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    self.m_toBattleLoadingScene = true

    replaceScene(SceneBattleLoading:createElement())
end


-- 点击退出房间回调
function SceneBossRoom:onClose()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WZLog("SceneBossRoom:onBackSceneCallback")
    WZLog("roomId:",self.m_tData.roomId)
    WZLog("seat:",self:_getPlayerSeat())
    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat())
end

function SceneBossRoom:exitMulRoom()
    
    ProtocolProcessorSceneBossRoom:unregAll()
    SceneCopy:showScene(2)
end

--@brief    退出房间需要发送退出协议
function SceneBossRoom:onBackScene(isTurnToScene)
    if SceneBossRoom.m_root == nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("SceneBossRoom:onBackScene", self.m_tData, tostring(isTurnToScene))
    ProtocolProcessorSceneRoom:send_ROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat() )
    if isTurnToScene ~= nil then
        ProtocolProcessorSceneRoom:unregAll()
    end
end

--显示当前房间的玩家聊天信息
function SceneBossRoom:showChat(txtMsg,playerId,bubbleId)
    WZLog("SceneBossRoom:showChat ",txtMsg,playerId)
    local seatIndex = self:findPlayerSeatById(playerId)
    if seatIndex > 0 then
        local conCenter = GetElement(self.m_root,"conCenter_SceneBossRoom",WZUIContainer)
        if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then  --练习赛
            conCenter = GetElement(self.m_root,"conCenter2_SceneBossRoom",WZUIContainer)
        end
        local conSeat = GetElement(conCenter,"conSeat" .. seatIndex .. "_SceneBossRoom",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_SceneBossRoom")
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
function SceneBossRoom:checkCellChatBubble(seatIndex)
    WZLog("SceneBossRoom:checkCellChatBubble ")
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
function SceneBossRoom:initRelationShip()
    WZLog("SceneBossRoom:initRelationShip")
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
function SceneBossRoom:getFriendRV(playerId)
    WZLog("SceneBossRoom:getFriendRV")
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
function SceneBossRoom:getMasterRV(playerId,playerLevel)
    WZLog("SceneBossRoom:getMasterRV = ",Serialize(self.m_MasterList))
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
function SceneBossRoom:getSpouseRV(playerId,playerSex,playerName)
    WZLog("SceneBossRoom:getSpouseRV ")
    if self.m_SpouseList == nil then
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
function SceneBossRoom:updateDressSuitData(nType)
    -- body
    if self.m_tCellDressSuit == nil then return end 
    if nType == 1 then
        self.m_tCellDressSuit:changeDressSuitOK()
    else
        self.m_tCellDressSuit:setSuitData()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief    根据id获取物品路径，再进行截取
--@param    物品id表
--@return   物品路径表
function SceneBossRoom:idToPath(idTable)
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
function SceneBossRoom:addTop()
    WZLog("SceneBossRoom:addTop")
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    self.m_tTopHangle = tcell
    self.m_oTopObject = cell
    tcell:setTopData("ui/common/common_icon_jingjifangji.png",SceneBossRoom,SceneBossRoom.onClose,true,true,true,"SceneBossRoom")
end

function SceneBossRoom:_shieldClick()
    WZLog("SceneBossRoom:_shieldClick")
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

-------------------------------------私有方法模块End----------------------------------------
