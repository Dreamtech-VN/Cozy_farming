--WndDoubleTowerRoomData.lua
--@brief	WndDoubleTowerRoom的数据模块
--@date		2019/11/20
--@author	Tianxiang_Xu
--@note		双人爬塔房间

WndDoubleTowerRoom = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDoubleTowerRoom:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil                  --场景ui信息
	self.m_nLoadingId = nil             --转菊花id
	self.m_tPlayersPetInfo = nil         --存放竞技房间玩家的宠物信息
	self.m_nHomeowner = nil
	self.m_nRoomSeatModel = nil
	self.m_MasterList = nil   --师徒关系列表
    self.m_FriendList = nil   --朋友关系列表
    self.m_SpouseList = nil   --夫妻关系列表
    self.m_CoupleNum = nil
    self.m_ChumNum = nil
    self.m_MentoringNum = nil
    self.m_nMaxHelpTimes = nil 
    self.m_tScheduleList = {}           --存放执行定时器的对象
    self.m_tCellDressSuit = nil         --多套时装的cell
    self.m_nPairRemainTime = nil        --匹配剩余时间
    self.m_fShakeHands = nil
    self.click = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDoubleTowerRoom:_unInit()
	self.m_root = nil
	self.m_tData = nil                  --场景ui信息
	self.m_nLoadingId = nil             --转菊花id
	self.m_tPlayersPetInfo = nil         --存放竞技房间玩家的宠物信息
	self.m_nHomeowner = nil
	self.m_nRoomSeatModel = nil
	self.m_MasterList = nil   --师徒关系列表
    self.m_FriendList = nil   --朋友关系列表
    self.m_SpouseList = nil   --夫妻关系列表
    self.m_CoupleNum = nil
    self.m_ChumNum = nil
    self.m_MentoringNum = nil
    self.m_nMaxHelpTimes = nil 
    self.m_tScheduleList = nil           --存放执行定时器的对象
    self.m_tCellDressSuit = nil         --多套时装的cell
    self.m_nPairRemainTime = nil        --匹配剩余时间
    self.m_fShakeHands = nil
    self.click = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDoubleTowerRoom:createElement()
	if WndDoubleTowerRoom.m_root ~= nil then
		WindowManager:removeWindow(WndDoubleTowerRoom.m_root, WndDoubleTowerRoom, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDoubleTowerRoom")
	assert(element, "WndDoubleTowerRoom create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndDoubleTowerRoom:showInterface()
	-- body
	local wndRoom = WndDoubleTowerRoom:createElement()
	if wndRoom then 
		WindowManager:addWindow(wndRoom, WndDoubleTowerRoom, nil, nil, nil, true)
	end
end

--@brief    设置房间信息   
function WndDoubleTowerRoom:setData(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId, serverId,
    playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel, vipLevel, player_title, qualifyingLevel, zsleve, playerStar, playerFighting, pet, extranInfo, playerHeadColour, playerBodyColour, mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, matchLevel, matchscore, joinTimes, winTimes, continuousWinTimes, serviceId, assist, assistTimesState, floorState)
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
    self.m_tData = {roomId = roomId,battleMode = GlobalGame.g_tBattleMode.BATTLE_MODE_FB,playerStar = playerStar ,fighting = playerFighting,serviceId=serviceId, roomChannel=GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DTF, playerNumMode=playerNumMode, mapId=mapId, wnersId=wnersId, playerNum=playerNum, seatUsed=seatUsed, playerId=playerId, playerName=playerName, playerLevel=playerLevel, playerReady=playerReady, playerSex=playerSex, playerEquipment=playerEquipment, playerWeaponLevel=playerWeaponLevel, vipLevel=vipLevel, playerTitle=player_title,roomName=roomName,passWord=passWord,pet=pet,extranInfo=extranInfo,serviceId=serviceId,headColors=playerHeadColour,bodyColors=playerBodyColour,mentoringStr=mentoringStr,coupleStr=coupleStr,chumStr= chumStr,coupleNum=coupleNum,chumNum=chumNum,mentoringNum=mentoringNum,qualifyingLevel=matchLevel,matchscore = matchscore,joinTimes=joinTimes,winTimes=winTimes,continuousWinTimes=continuousWinTimes,assist=assist, assistTimesState = assistTimesState, floorState = floorState}
    WZLog("WndDoubleTowerRoom:setData", mapId, floorState, coupleStr, type(coupleNum), string.len(coupleNum))
    self.m_nHomeowner = wnersId
    self:initRelationShip()
    
    if self.m_root ~= nil then
    	self:endPairTimer()
        self:_update()
    end
end

--@brief    进入房间
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function WndDoubleTowerRoom:receiveEnterRoomOk(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId,serverId, playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel, vipLevel, player_title, qualifyingLevel, zsleve, playerStar, playerFighting, pet, extranInfo, playerHeadColour, playerBodyColour, 
    mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, matchLevel, matchscore, joinTimes, winTimes, continuousWinTimes, serviceId, assist, assistTimesState, floorState)
	if self.m_root == nil then 
		WndDoubleTowerRoom:showInterface()
	end
    self.m_tPlayersPetInfo = {}
    for i, v in ipairs(pet) do
        local petInfo = json.decode(v)
        table.insert(self.m_tPlayersPetInfo, petInfo)
    end
    self:closeLoading()
    
    self:setData(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId,serverId,
            playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel,vipLevel, player_title, qualifyingLevel, zsleve, playerStar,playerFighting, pet, extranInfo, playerHeadColour, playerBodyColour, mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, matchLevel, matchscore, joinTimes, winTimes, continuousWinTimes, serviceId, assist, assistTimesState, floorState)
    
    WZLog("WndDoubleTowerRoom:receiveEnterRoomOk =", Serialize(seatUsed))
end

--@breif  爬塔副本缓存信息更新
function WndDoubleTowerRoom:updateDoubleTowerData()
    WZLog("WndDoubleTowerRoom:updateDoubleTowerData")
    if WndDoubleTowerRoom.m_root ~= nil then
        self:_update()
    end
end

--根据玩家ID查找玩家所在位置
function WndDoubleTowerRoom:findPlayerSeatById(playerId)
    WZLog("WndDoubleTowerRoom:findPlayerSeatById ",playerId)
    if self.m_tData == nil or playerId == nil then
        WZLog("WndDoubleTowerRoom:_getPlayerSeat m_tData is nil.")
        return
    end
    
    for i,vId in ipairs(self.m_tData.playerId) do
        if vId == playerId then
            return i
        end
    end
    return 0
end

--@brief    更新多套时装数据
function WndDoubleTowerRoom:updateDressSuitData(nType)
    -- body
    if self.m_root == nil then return end 
    if self.m_tCellDressSuit == nil then return end 

    if nType == 1 then
        self.m_tCellDressSuit:changeDressSuitOK()
    else
        self.m_tCellDressSuit:setSuitData()
    end
end

--@brief    正在匹配中
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function WndDoubleTowerRoom:receiveMakePairError(nFlag, sMessage)
    if self.m_root == nil then
        return
    end
    WZLog("WndDoubleTowerRoom:receiveMakePairError",nFlag, sMessage)
    if nFlag == 0 then
        MsgBoxManager:showConfirmBox(sMessage,nil,nil,nil,nil,true)
        self:endPairTimer()
    end
end

--@brief    匹配失败
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function WndDoubleTowerRoom:receiveMakePairFail()
    if self.m_root == nil then return end 
    WZLog("WndDoubleTowerRoom:receiveMakePairFail")
    MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_MATCH_FAILED)
    
    self:endPairTimer()
    self:_update()
end

--@brief    匹配完成
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function WndDoubleTowerRoom:receiveMakePairOk(battleId, mapId, playerCount, playerId, serverId, playerName, playerTitle, playerCommunity, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, headId, faceId, bodyId, weaponId, wingId, item_id, playerBuffCount, buffId, petId,petSkill, petParam, guaiBattleId, guaiId,tournamentLevel,petLevel, colour, bodyColour, footmark, professionId, professionSkill, playerCamp, mountId, childId, childName, childSex, childImage, assistSkillIds, defaultShapeBigSkill, blastEffect, extPropertyKey, extPropertyValue, extPropertyCount)
    if self.m_root == nil then return end 
    WZLog("WndDoubleTowerRoom:receiveMakePairOk")
    self:endPairTimer()
    WBattleGlobal:getCurrent():destroy()
    local bIsRoomOwner = self:getIsRoomOwner()
    WBattleGlobal:getCurrent().m_tMakePairOk = {
    battleId=battleId, battleMull=false, battleChannle=-1,mapId=mapId,playerCount=playerCount,playerId=playerId, serverId=serverId,playerName=playerName, playerTitle = playerTitle, playerCommunity=playerCommunity, playerLevel=playerLevel, playerSex=playerSex, maxHP=maxHP, maxPF=maxPF, maxSP=maxSP, attack=attack,critRate=critRate,defence=defence,injuryFree=injuryFree, wreckDefense=wreckDefense, reduceCrit=reduceCrit, power=power, armor=armor,constitution=constitution,agility=agility,lucky=lucky,headId=headId,faceId=faceId,bodyId=bodyId,weaponId=weaponId,wingId=wingId,item_id=item_id,playerBuffCount=playerBuffCount, buffId=buffId,petId=petId,petSkill=petSkill,petLevel=petLevel,petSkillId=petId,petParam=petParam,guaiBattleId=guaiBattleId,guaiId=guaiId,battleMode=BattleConstants.g_tBossBattleMode.MODE_DOUBLETOWER_STAGE,tournamentLevel=tournamentLevel, colour=colour, bodyColour=bodyColour ,footmark = footmark, professionId = professionId, professionSkill = professionSkill, playerCamp = playerCamp, mountId = mountId, childId = childId, childName = childName, childSex = childSex, childImage = childImage, assistSkillIds = assistSkillIds, bIsRoomOwner = bIsRoomOwner, defaultShapeBigSkill = defaultShapeBigSkill, blastEffect = blastEffect, extPropertyKey = extPropertyKey, extPropertyValue = extPropertyValue, extPropertyCount = extPropertyCount}

    WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_BOSS
    WBattleGlobal:getCurrent().battleMode = BattleConstants.g_tBossBattleMode.MODE_DOUBLETOWER_STAGE
    g_nRoomOwnerId = self.m_nHomeowner
    --保存标记，游戏中获取装备时，等自动跳转会副本界面时才弹装备提示
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    self.m_toBattleLoadingScene = true

    replaceScene(SceneBattleLoading:createElement())
end

--@brief    正在匹配中
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function WndDoubleTowerRoom:receiveMakePairring(roomId)
    if self.m_root == nil then
        return
    end
    WZLog("WndDoubleTowerRoom:receiveMakePairring",roomId)
    if roomId == self.m_tData.roomId then
        self:startPairTimer()
    end
end

--@brief    玩家被邀请进入副本房间
function WndDoubleTowerRoom:beInvited(roomId , playerName, mapId, password, roomChannel, assist, interfaceId, playerId)
    WZLog("WndDoubleTowerRoom:beInvited")
    local data = GDatatab_grouptower_map["id_"..mapId]
    -- 获取房间难度
    
    local desc = string.format(LocalStrings.DOUBLETOWER_TEXT10, playerName, data.name)
    interfaceId = interfaceId or 0
    playerId = playerId or 0
    WndInvited:showInterface(self, self.send_EnterRoom, roomId, password, mapId, desc, playerName, nil, nil, roomChannel, assist, interfaceId, playerId)
end

--@brief    被邀请时，确定按钮的回调  (发送进入房间的协议)
function WndDoubleTowerRoom:send_EnterRoom(roomId,roomChannel,password,mapId,des,battleId,assist)
    WZLog("WndDoubleTowerRoom:send_EnterRoom ",assist)
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(roomId, password, mapId, roomChannel, assist)
end

function WndDoubleTowerRoom:exitMulRoom()
	if self.m_root == nil then return end 

    ProtocolProcessorSceneBossRoom:unregAll()
  	WindowManager:removeWindow(self.m_root, self, true)
end

function WndDoubleTowerRoom:_getPlayerNum()
    local num = 0
    for i=1 , #self.m_tData.playerId do
        if self.m_tData.playerId[i] > 0 then num = num + 1 end
    end
    return num
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获取关卡数据
function WndDoubleTowerRoom:getFloorData(floorNum)
	-- body
	for i, value in pairs(GDatatab_grouptower_map) do
		if value.floor_num == floorNum then 
			return value 
		end
	end

	return nil 
end

--@brief 根据技能或道具组号获取道具名称
function WndDoubleTowerRoom:getSkillName(subType)
	-- body
    local tTempValue 
	for i, value in pairs(GDatatab_skill) do
        if tTempValue == nil then 
    		if value.sub_type == subType then
                tTempValue = value  
    		end
        elseif tTempValue and value.sub_type == subType and tTempValue.id > value.id then 
            tTempValue = value
        end
	end

    if ProjConfig.LANGUAGE == "vn" then
        if tTempValue then 
            local st, ed = string.find(tTempValue.name, "Lv%d")
            if st then 
                return string.gsub(tTempValue.name, "Lv%d", "")
            end
            return tTempValue.name
        end
    else
        if tTempValue then 
            local st, ed = string.find(tTempValue.name, LocalStrings.LEVEL1)
            if st then 
                return string.sub(tTempValue.name, ed + 1)
            end
            return tTempValue.name
        end
    end

	return ""
end

function WndDoubleTowerRoom:_NumberToBits(n, nCount)
    local tBits = {}

    while n >= 0 and #tBits < nCount do
        table.insert(tBits, math.fmod(n, 2))
        n = math.floor(n/2)
    end

    return tBits
end

function WndDoubleTowerRoom:closeLoading()
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
        self.m_nLoadingId = nil
    end
end

--@brief 	房间是否只有助战的玩家
function WndDoubleTowerRoom:_isByAssitOnly(playerId, assist)
    -- body
    WZLog("WndDoubleTowerRoom:_isByAssitOnly")
    local bOnlyAssit = true
    for i,v in ipairs(playerId) do
        if assist[i] == 0 then
            bOnlyAssit = false
            break
        end
    end
    return bOnlyAssit
end

--@brief 	房间里只剩下助战玩家则退出房间
function WndDoubleTowerRoom:_exitRoomByAssitOnly()
    -- body
    WZLog("WndDoubleTowerRoom:_exitRoomByAssitOnly")
    if self:_isByAssitOnly(self.m_tData.playerId, self.m_tData.assist) then
        ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat())
    end
end

--@brief    获得主角的座位
--@return   #1:位置
function WndDoubleTowerRoom:_getPlayerSeat()
    WZLog("WndDoubleTowerRoom:_getPlayerSeat")
    
    if self.m_tData == nil then
        WZLog("WndDoubleTowerRoom:_getPlayerSeat m_tData is nil.")
        return
    end
    
    for i,vId in ipairs(self.m_tData.playerId) do
        if vId == GlobalGame.g_tPlayerInfo.nPlayerId then
            return i-1
        end
    end
    
    return -1
end

--保存各种关系的数值
function WndDoubleTowerRoom:initRelationShip()
    WZLog("WndDoubleTowerRoom:initRelationShip")
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
function WndDoubleTowerRoom:getFriendRV(playerId)
    WZLog("WndDoubleTowerRoom:getFriendRV")
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
function WndDoubleTowerRoom:getMasterRV(playerId,playerLevel)
    WZLog("WndDoubleTowerRoom:getMasterRV = ",Serialize(self.m_MasterList))
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
function WndDoubleTowerRoom:getSpouseRV(playerId,playerSex,playerName)
    WZLog("WndDoubleTowerRoom:getSpouseRV ")
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

--@brief    是否为房主
--@return   #1:true:是,false:否
function WndDoubleTowerRoom:getIsRoomOwner()
    WZLog("WndDoubleTowerRoom:getIsRoomOwner")
    if self.m_tData == nil then
        WZLog("WndDoubleTowerRoom:getIsRoomOwner m_tData is nil.")
        return false
    end
    
    if self.m_tData.wnersId == GlobalGame.g_tPlayerInfo.nPlayerId then
        return true
    else
        return false
    end
end

--检查当前座位是否有冒泡,有的话检查玩家ID是否跟当前冒泡ID一样
function WndDoubleTowerRoom:checkCellChatBubble(seatIndex)
    WZLog("WndDoubleTowerRoom:checkCellChatBubble ")
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
-------------------------------------私有方法模块End----------------------------------------
