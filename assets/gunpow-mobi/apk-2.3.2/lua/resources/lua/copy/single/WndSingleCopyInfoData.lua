--WndSingleCopyInfoData.lua
--@brief	WndSingleCopyInfo的数据模块
--@date		2015/04/10
--@author	xiaoyu_wu
--@note		单人副本关卡信息

WndSingleCopyInfo = {
	--请不要在这里定义变量
    NOTPASSED = -999
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSingleCopyInfo:_init()
	self.m_root = nil	 	  			--场景根节点
    self.singleCopyVipData = nil
    self.m_tLevelData = nil             --关卡数据表
    self.m_nChallengeCount = self.NOTPASSED       --已挑战次数，默认值为未通关
    self.m_nSweepCount = 0              --扫荡次数
    self.m_bSweepFinish = true           --记录是否已成功接收扫荡成功协议，防止多次点击扫荡按钮
    self.m_nSweepType = 1
    self.m_nLoadingTag = nil
    self.m_nCopyType = nil
    self.m_nCostCount = nil
    self.m_nCurLevelID = nil               --当前挑战的关卡
    self.m_tIslandHostData = nil            --岛主数据
    self.m_tMyIslandId = nil               --我占领的岛Id              --我占领的岛Id
    self.m_nSwitchReward = 1                --奖励展示: 1岛主奖励 2助战奖励
    self.m_tScheduleList = {}           --存放执行定时器的对象
    self.m_tData = nil                  --岛主挑战房间相关信息
    self.m_nHomeowner = nil
    self.m_bIslandRoom = nil            --是否在岛主房间

    self.m_tButtonTipsAnim1 = nil  --按钮引导1
    self.m_tButtonTipsDialog1 = nil --按钮引导1
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndSingleCopyInfo:_unInit()
    self.m_root = nil
    self.singleCopyVipData = nil
    self.m_tLevelData = nil
    self.m_nChallengeCount = nil
    self.m_nSweepCount = nil
    self.m_bSweepFinish = nil
    self.m_nSweepType = nil
    self.m_nLoadingTag = nil
    self.m_nCopyType = nil
    self.m_nCostCount = nil
    self.m_nCurLevelID = nil   
    self.m_tIslandHostData = nil            --岛主数据
    self.m_tMyIslandId = nil               --我占领的岛Id
    self.m_nSwitchReward = nil                --奖励展示: 1岛主奖励 2助战奖励
    self.m_tScheduleList = nil           --存放执行定时器的对象
    self.m_tData = nil                  --岛主挑战房间相关信息
    self.m_nHomeowner = nil
    self.m_bIslandRoom = nil            --是否在岛主房间
    
    self.m_tButtonTipsAnim1 = nil  --按钮引导1
    self.m_tButtonTipsDialog1 = nil --按钮引导1
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSingleCopyInfo:createElement()
    if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    end
	local element = WZUISystem:getInstance():createElement("WndSingleCopyInfo")
	assert(element, "WndSingleCopyInfo create element failed!")
	self:_init()
	return element
end

--@brief	显示窗口
--@note		调用此接口显示单人副本关卡信息窗口
function WndSingleCopyInfo:showWindow(tLevelData,copyType)
    local wndSingleCopyInfo = self:createElement()
    self.m_tLevelData = tLevelData
    self.m_nCopyType = copyType
    self:_getChallengeCount()
    WindowManager:addWindow(wndSingleCopyInfo, self,nil, true)
end

--@brief	获取关卡数据表
--@return   #1,数据表
function WndSingleCopyInfo:getLevelData()
    return self.m_tLevelData
end

--@brief	数据更新
function WndSingleCopyInfo:updateData()
    WZLog("WndSingleCopyInfo:updateData")
    if self:getLoadingTag()~=nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self:getLoadingTag())
    end
    self:_getChallengeCount()
    self:_updateSweepInfo()
    self:_initLevelInfo()
    self:resetLoadingTag()
end

--@brief 显示扫荡结果
function WndSingleCopyInfo:showSweepResult(pointId, rewardNum, rewardId, rewardCount)
    WZLog("WndSingleCopyInfo:showSweepResult")
    if self.m_root == nil then return end
    self.m_bSweepFinish = true
    WndSweepResult:showWindow({
        pointId = pointId,
        rewardNum = VectorToTable(rewardNum),
        rewardId = VectorToTable(rewardId),
        rewardCount = VectorToTable(rewardCount),
    },self.m_nSweepType)
    
end

--@brief  返回loadingTag
function WndSingleCopyInfo:getLoadingTag()
    return self.m_nLoadingTag
end

--@brief  返回loadingTag
function WndSingleCopyInfo:resetLoadingTag()
    if self.m_nLoadingTag then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)
    end
    self.m_nLoadingTag = nil
end

--@brief 获取对应VIP的爬塔信息
function WndSingleCopyInfo:getVipSingleCopy()
    local playerInfo = CacheCenter:getPlayerInfo() or {}
    local vipLevel = playerInfo.vipLevel
    local vipData = nil
    local count = 0
    if self.singleCopyVipData then
        for k,v in pairs(self.singleCopyVipData) do
            if vipLevel >= v.vip_level  then
                if v.count > count then
                    count = v.count
                    vipData = v
                end
            end
        end
    end
    return vipData
end

--@brief  获取当前VIP下一等级VIP的数据
function WndSingleCopyInfo:getNextVipData()
    WZLog("WndSingleCopyInfo:getNextVipData")
    local playerInfo = CacheCenter:getPlayerInfo()
    local vipLevel = playerInfo.vipLevel
    local curVipData = self:getVipSingleCopy()
    local nextCount = curVipData.count + 1
    for i,v in ipairs(self.singleCopyVipData) do
        if v.count == nextCount then
            return v
        end
    end
    return nil
end

--@brief  获取单人副本重置花费
--@param  resertCount : 重置次数
function WndSingleCopyInfo:getVipSingleCopyCost(resertCount)
    for k,v in pairs(self.singleCopyVipData) do
        if v.count  == resertCount then
            return v.cost[1][2]
        end
    end
end

--@brief  获取当前关卡重置次数
function WndSingleCopyInfo:getResertTime(mapId)
    local singleCopyInfo = CacheCenter:getSingleCopyData()
    for i,v in ipairs(singleCopyInfo) do
        if v.pointId == mapId then
            return v.restTimes
        end
    end
    return 0
end

--@brief  判断是否可以进行重置，可以则弹出相关提示
function WndSingleCopyInfo:canResert()
    local reserTimes = self:getResertTime(self.m_tLevelData.id)
    reserTimes = reserTimes + 1
    if self.m_nCopyType ~= 2 or self.m_nCopyType == 3 then
        return false ,reserTimes
    end
    local vipData = self:getVipSingleCopy()
    local totalCount = vipData.count
    if reserTimes > totalCount then
        return false ,reserTimes
    end
    return true ,reserTimes 
end


--单人副本关卡录像信息
function WndSingleCopyInfo:setVideoInfo(id,faceId,headId,name,level,playerId,sex,headColor)
    WZLog("WndSingleCopyInfo:setVideoInfo = ",#id)
    if id ~= nil and faceId ~= nil and headId ~= nil and name ~= nil and level ~= nil and self.m_root ~= nil then
        self.m_tVideoList = {id=id,faceId=faceId,headId=headId,name=name,level=level,playerId=playerId,sex=sex,headColor=headColor}
        if self.m_tVideoList ~= nil and (#self.m_tVideoList.id) > 0 then
            WZLog("WndSingleCopyInfo:enterSetVideoInfo....")
            local txtNullMsgTip = GetElement(self.m_root,"txtNullMsgTip_WndSingleCopyInfo",WZUILabelTTF)
            txtNullMsgTip:setVisible(false)
            self:showVideoList()
        end
    end
end

--显示录像列表信息
function WndSingleCopyInfo:showVideoList()
    WZLog("WndSingleCopyInfo:showVideoList")
    local tblVideoList = GetElement(self.m_root,"tblVideoList_WndSingCopyInfo",WZUITableContainer)
    tblVideoList:cleanTable()
    for i,v in ipairs(self.m_tVideoList.id) do
       
        local cellVideoInfo= CreateElement("CellVideoInfo_WndSingleCopyInfo")
        cellVideoInfo:setTag(i-1)
        cellVideoInfo:setVisible(true)

        local conPlayerHead = GetElement(cellVideoInfo,"conPlayerHead_CellVideoInfo",WZUIContainer)
        local cellHeadObject = CellHead:show(conPlayerHead,self.m_tVideoList.headId[i],self.m_tVideoList.faceId[i],self.m_tVideoList.sex[i],nil,nil,nil,self.m_tVideoList.headColor[i])
        cellHeadObject:setScale(1)
        conPlayerHead:setTag(self.m_tVideoList.playerId[i])

--        local btnHead = GetElement(cellVideoInfo,"btnHead_CellVideoInfo",WZUIButton)
--        btnHead:setTag(self.m_tVideoList.playerId[i])

        local txtPlayerLevel = GetElement(cellVideoInfo,"txtPlayerLevel_CellVideoInfo",WZUILabelTTF)
        txtPlayerLevel:setText( "Lv" ..self.m_tVideoList.level[i])

        local txtPlayerName = GetElement(cellVideoInfo,"txtPlayerName_CellVideoInfo",WZUILabelTTF)
        txtPlayerName:setText(self.m_tVideoList.name[i])
        if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
            txtPlayerName:setScale(0.8)
        end

        local btnPlayVideo = GetElement(cellVideoInfo,"btnPlayVideo_CellVideoInfo",WZUIButton)
        btnPlayVideo:setTag(v)
        tblVideoList:setCellElement(cellVideoInfo)
        if ProjConfig.LANGUAGE == "tr" then
            txtPlayerName:setScale(0.8)
        end
    end
end

--@brief    设置岛主信息数据
-- function WndSingleCopyInfo:setIslangHostInfo(landlordId, landlordName, landlordSex, landlordVipLevel, landlordHeadId, landlordHeadColor, landlordFaceId, landlordPropectTime, lanlordFighting, landlordBodyId, landlordBodyColor, landlordWingId, landlordLevel)
function WndSingleCopyInfo:setIslangHostInfo(mapId, landlordId, time, protectTime, revenge, playerId, serverId, name, sex, vipLevel, headId, headColor, faceId, fight, level, landlordMapId)
    --body
    -- self.m_tMyIslandId = seizeMapId
    -- self.m_tIslandHostData = {id = landlordId, name = landlordName, sex = landlordSex, vipLevel = landlordVipLevel, headId = landlordHeadId, faceId = landlordFaceId, headColor = landlordHeadColor, protectTime = landlordPropectTime, fighting = lanlordFighting, bodyId = landlordBodyId, bodyColor = landlordBodyColor, wingId = landlordWingId, level = landlordLevel}            --岛主数据
    
    self.m_tIslandHostData = {}
    self.m_tIslandHostData.mapId = mapId
    self.m_tIslandHostData.landlordId = landlordId
    self.m_tIslandHostData.time = time
    self.m_tIslandHostData.protectTime = protectTime
    self.m_tIslandHostData.revenge = revenge
    self.m_tIslandHostData.player = {}
    local tempMyData = nil
    for i=1,#playerId do
        local tempData = {}
        tempData.playerId = playerId[i]
        tempData.serverId = serverId[i]
        tempData.name = name[i]
        tempData.sex = sex[i]
        tempData.vipLevel = vipLevel[i]
        tempData.headId = headId[i]
        tempData.headColor = headColor[i]
        tempData.faceId = faceId[i]
        tempData.fight = fight[i]
        tempData.level = level[i]
        if playerId[i] == CacheCenter:getPlayerInfo().id then
            tempMyData = tempData
        else
            if playerId[i] == landlordId then
                table.insert(self.m_tIslandHostData.player,1,tempData)
            else
                table.insert(self.m_tIslandHostData.player,tempData)
            end
        end
    end
    if tempMyData ~= nil then
        table.insert(self.m_tIslandHostData.player,1,tempMyData)
    end
    self.m_tIslandHostData.landlordMapId = landlordMapId

    --岛主信息
    self:_showIslandHostHead()
    self:_showIslandHostInfo()

    local txtOwnerTime1 = GetElement(self.m_root,"txtOwnerTime1_WndSingleCopyInfo",WZUILabelTTF)
    if txtOwnerTime1 and self.m_tIslandHostData.protectTime > 0 then 
        txtOwnerTime1:enableSchedule("_scheduleOwnerTime1", 1)
    else
        txtOwnerTime1:setText(LocalStrings.NONE)
        txtOwnerTime1:disableSchedule()
    end
    local txtOwnerTime2 = GetElement(self.m_root,"txtOwnerTime2_WndSingleCopyInfo",WZUILabelTTF)
    if txtOwnerTime2 and self.m_tIslandHostData.landlordId > 0 then 
        txtOwnerTime2:enableSchedule("_scheduleOwnerTime2", 1)
    else
        txtOwnerTime2:setText("00:00:00")
        txtOwnerTime2:disableSchedule()
    end
    local txtBtnChallenge = GetElement(self.m_root,"txtBtnChallenge_WndSingleCopyInfo",WZUILabelTTF)
    txtBtnChallenge:disableSchedule()
    if self.m_tIslandHostData.revenge > 0 then
        txtBtnChallenge:enableSchedule("_scheduleOwnerTime3", 1)
    end
end

--@brief    进入房间
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function WndSingleCopyInfo:receiveEnterRoomOk(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId,serverId, playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel, vipLevel, player_title, qualifyingLevel, zsleve, playerStar, playerFighting, pet, extranInfo, playerHeadColour, playerBodyColour, 
    mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, matchLevel, matchscore, joinTimes, winTimes, continuousWinTimes, serviceId, assist, assistTimesState, floorState)
    if self.m_root == nil then 
        self.m_bIsEnterRoom = true
        self.m_EnterRoomData = {
            roomId = roomId,
            passWord = passWord,
            roomName = roomName,
            playerNumMode = playerNumMode,
            mapId = mapId,
            wnersId = wnersId,
            playerNum = playerNum,
            seatUsed = seatUsed,
            playerId = playerId,
            serverId = serverId,
            playerName = playerName,
            playerLevel = playerLevel,
            playerReady = playerReady,
            playerSex = playerSex,
            playerEquipment = playerEquipment,
            playerEquipmentLevel = playerEquipmentLevel,
            vipLevel = vipLevel,
            player_title = player_title,
            qualifyingLevel = qualifyingLevel,
            zsleve = zsleve,
            playerStar = playerStar,
            playerFighting = playerFighting,
            pet = pet,
            extranInfo = extranInfo,
            playerHeadColour = playerHeadColour,
            playerBodyColour = playerBodyColour,
            mentoringStr = mentoringStr,
            coupleStr = coupleStr,
            chumStr = chumStr,
            coupleNum = coupleNum,
            chumNum = chumNum,
            mentoringNum = mentoringNum,
            matchLevel = matchLevel,
            matchscore = matchscore,
            joinTimes = joinTimes,
            winTimes = winTimes,
            continuousWinTimes = continuousWinTimes,
            serviceId = serviceId,
            assist = assist,
            assistTimesState = assistTimesState,
            floorState = floorState
        }
        return
    else
        self.m_bIsEnterRoom = nil
    end
    self.m_tPlayersPetInfo = {}
    for i, v in ipairs(pet) do
        local petInfo = json.decode(v)
        table.insert(self.m_tPlayersPetInfo, petInfo)
    end
    
    self:setRoomData(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId,serverId,
            playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel,vipLevel, player_title, qualifyingLevel, zsleve, playerStar,playerFighting, pet, extranInfo, playerHeadColour, playerBodyColour, mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, matchLevel, matchscore, joinTimes, winTimes, continuousWinTimes, serviceId, assist, assistTimesState, floorState)
    
    WZLog("WndSingleCopyInfo:receiveEnterRoomOk =", Serialize(seatUsed))
end

--@brief    设置房间信息   
function WndSingleCopyInfo:setRoomData(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId, serverId,
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
    self.m_tData = {roomId = roomId,battleMode = GlobalGame.g_tBattleMode.BATTLE_MODE_FB,playerStar = playerStar ,fighting = playerFighting,serviceId=serviceId, roomChannel=GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZTZ, playerNumMode=playerNumMode, mapId=mapId, wnersId=wnersId, playerNum=playerNum, seatUsed=seatUsed, playerId=playerId, playerName=playerName, playerLevel=playerLevel, playerReady=playerReady, playerSex=playerSex, playerEquipment=playerEquipment, playerWeaponLevel=playerWeaponLevel, vipLevel=vipLevel, playerTitle=player_title,roomName=roomName,passWord=passWord,pet=pet,extranInfo=extranInfo,serviceId=serviceId,headColors=playerHeadColour,bodyColors=playerBodyColour,mentoringStr=mentoringStr,coupleStr=coupleStr,chumStr= chumStr,coupleNum=coupleNum,chumNum=chumNum,mentoringNum=mentoringNum,qualifyingLevel=matchLevel,matchscore = matchscore,joinTimes=joinTimes,winTimes=winTimes,continuousWinTimes=continuousWinTimes,assist=assist, assistTimesState = assistTimesState, floorState = floorState}
    WZLog("WndSingleCopyInfo:setRoomData", mapId, floorState, coupleStr, type(coupleNum), string.len(coupleNum))
    self.m_nHomeowner = wnersId
    self:initRelationShip()
    
    if self.m_root ~= nil then
        self:_update()
    end
end

--根据玩家ID查找玩家所在位置
function WndSingleCopyInfo:findPlayerSeatById(playerId)
    WZLog("WndSingleCopyInfo:findPlayerSeatById ",playerId)
    if self.m_tData == nil or playerId == nil then
        WZLog("WndSingleCopyInfo:findPlayerSeatById m_tData is nil.")
        return
    end
    
    for i,vId in ipairs(self.m_tData.playerId) do
        if vId == playerId then
            return i
        end
    end
    return 0
end

--@brief    房间是否只有助战的玩家
function WndSingleCopyInfo:_isByAssitOnly(playerId, assist)
    -- body
    WZLog("WndSingleCopyInfo:_isByAssitOnly")
    local bOnlyAssit = true
    for i,v in ipairs(playerId) do
        if assist[i] == 0 then
            bOnlyAssit = false
            break
        end
    end
    return bOnlyAssit
end

--保存各种关系的数值
function WndSingleCopyInfo:initRelationShip()
    WZLog("WndSingleCopyInfo:initRelationShip")
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
function WndSingleCopyInfo:getFriendRV(playerId)
    WZLog("WndSingleCopyInfo:getFriendRV")
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
function WndSingleCopyInfo:getMasterRV(playerId,playerLevel)
    WZLog("WndSingleCopyInfo:getMasterRV = ",Serialize(self.m_MasterList))
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
function WndSingleCopyInfo:getSpouseRV(playerId,playerSex,playerName)
    WZLog("WndSingleCopyInfo:getSpouseRV ")
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

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获取挑战次数
function WndSingleCopyInfo:_getChallengeCount()
    WZLog("WndSingleCopyInfo:_getChallengeCount")
    self.m_nChallengeCount = 0
    local tSingleCopyData = CacheCenter:getSingleCopyData() or {}
    local tempCopyLevelInfo = GDatatab_single_map["id_" .. self.m_tLevelData.id]
    for i,v in ipairs(tSingleCopyData) do
        if self.m_nCopyType == 3 and v.pointId > 0 then
            local tempCopyInfo = GDatatab_single_map["id_" .. v.pointId]
            WZLog("tempCopyInfo =",v.pointId)
            if tempCopyInfo and tempCopyInfo.map_type == tempCopyLevelInfo.map_type and tempCopyInfo.section == tempCopyLevelInfo.section and tempCopyInfo.idgroup == tempCopyLevelInfo.idgroup then
                self.m_nChallengeCount = self.m_nChallengeCount + v.passTime
            end
        else
            if self.m_tLevelData.id == v.pointId then
               self.m_nChallengeCount = v.passTime
            end
        end
    end
end

--@brief	获取扫荡券数量
--@return   #1,扫荡券数量
function WndSingleCopyInfo:_getSweepCouponCount()
    if self.m_nCopyType == 3 then
        return CacheCenter:getPlayerItemCountById(201)
    else
        return CacheCenter:getPlayerItemCountById(106)
    end
    
end


function WndSingleCopyInfo:_initTowerVipData()
    self.singleCopyVipData = {}
    for k ,v in pairs(GDatatab_vip_restriction) do
        if v.type == 6 then
           table.insert(self.singleCopyVipData,v)
        end
    end
end

--@brief    获取噩梦副本对应的三星的副本id
function WndSingleCopyInfo:getHostCopyId(id)
    -- body
    local level1 = GDatatab_single_map["id_" .. id]
    local level2 = GDatatab_single_map["id_" .. (id + 1)]
    local level3 = GDatatab_single_map["id_" .. (id + 2)]
    if level1.map_type == 3 then 
        if level1.map_num == 3 then
            return id
        elseif level2 and level2.idgroup == level1.idgroup and level2.map_num == 3 then
            return id + 1
        elseif level3 and level3.idgroup == level1.idgroup and level3.map_num == 3 then
            return id + 2
        end
    else
        return id
    end
end

--@brief    接收开始挑战协议成功,进入岛主挑战
function WndSingleCopyInfo:receiveStartChallengeOk()
    if self.m_tData == nil or self.m_tData.roomId == nil or self.m_root == nil then
        return
    end

    -- 房主在大家都准备的情况下可以开始游戏，房客则准备或者取消准备
    if self:getIsRoomOwner() then
        if self:_allPlayersReady() then
            ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_MakePair(self.m_tData.roomId )
            self:receiveMakePairring(self.m_tData.roomId)
            g_copyST = os.time()
        else
            MsgBoxManager:showTipBox(LocalStrings.ROOM_HAVE_NOT_READY)
        end
    else
        --准备或取消游戏,这里没有等服务器回调
        local seatNum = self:_getPlayerSeat()
        if self.m_tData.playerReady[seatNum + 1] == true then
            ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_GameReady(self.m_tData.roomId, seatNum, false )
        else
            ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_GameReady(self.m_tData.roomId, seatNum, true )
        end
    end
end

--@brief    正在匹配中
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function WndSingleCopyInfo:receiveMakePairring(roomId)
    if self.m_root == nil then
        return
    end
    WZLog("WndSingleCopyInfo:receiveMakePairring",roomId)
    if roomId == self.m_tData.roomId then
        self:startPairTimer()
    end
end

--@brief    玩家被邀请进入副本房间
function WndSingleCopyInfo:beInvited(roomId, playerName, mapId, password, roomChannel, assist)
    WZLog("WndSingleCopyInfo:beInvited")
    local data = GDatatab_single_map["id_"..mapId]
    local map_name = data.map_name
    local strDifficulty = {LocalStrings.COMMON,LocalStrings.DIFFICULTY,LocalStrings.HELL}
    local strDesc = strDifficulty[data.map_type]

    --房主已经是其他岛的岛主判断 assist:1代表已满,0代表未满
    local desc = string.format(LocalStrings.ISLAND_OWNER_TEXT7, playerName, map_name, strDesc)
    if assist == 1 then
        desc = string.format(LocalStrings.ISLAND_OWNER_TEXT8, playerName, map_name, strDesc)
    end
    
    WndInvited:showInterface(self, self.send_EnterRoom, roomId, password, mapId, desc, playerName, nil, nil, roomChannel, assist)
end

--@brief    被邀请时，确定按钮的回调  (发送进入房间的协议)
function WndSingleCopyInfo:send_EnterRoom(roomId,roomChannel,password,mapId,des,battleId,assist)
    WZLog("WndSingleCopyInfo:send_EnterRoom ",assist)
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(roomId, password, mapId, roomChannel, assist)
end

--@brief    是否为房主
--@return   #1:true:是,false:否
function WndSingleCopyInfo:getIsRoomOwner()
    WZLog("WndSingleCopyInfo:getIsRoomOwner")
    if self.m_tData == nil then
        WZLog("WndSingleCopyInfo:getIsRoomOwner m_tData is nil.")
        return false
    end
    
    if self.m_tData.wnersId == GlobalGame.g_tPlayerInfo.nPlayerId then
        return true
    else
        return false
    end
end

--brief    是否所有玩家已准备
--@return  #1: true:是, false：否
function WndSingleCopyInfo:_allPlayersReady()
    for i=1, self.m_tData.playerNum do
        if self.m_tData.playerId[i] > 0  and not self.m_tData.playerReady[i] then
            return false
        end
    end
    return true
end


--@brief    正在匹配中
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function WndSingleCopyInfo:receiveMakePairError(nFlag, sMessage)
    if self.m_root == nil then
        return
    end
    WZLog("WndSingleCopyInfo:receiveMakePairError",nFlag, sMessage)
    if nFlag == 0 then
        MsgBoxManager:showConfirmBox(sMessage,nil,nil,nil,nil,true)
        self:endPairTimer()
    end
end

--@brief    匹配失败
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function WndSingleCopyInfo:receiveMakePairFail()
    if self.m_root == nil then return end 
    WZLog("WndSingleCopyInfo:receiveMakePairFail")
    MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_MATCH_FAILED)
    
    self:endPairTimer()
    self:_update()
end

--@brief    匹配完成
--@param    入参与服务端发送给客户端的协议回调方法参数相同
function WndSingleCopyInfo:receiveMakePairOk(battleId, mapId, playerCount, playerId, serverId, playerName, playerTitle, playerCommunity, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, headId, faceId, bodyId, weaponId, wingId, item_id, playerBuffCount, buffId, petId,petSkill, petParam, guaiBattleId, guaiId,tournamentLevel,petLevel, colour, bodyColour, footmark, professionId, professionSkill, playerCamp, mountId, childId, childName, childSex, childImage, assistSkillIds, defaultShapeBigSkill, blastEffect, extPropertyKey, extPropertyValue, extPropertyCount)
    if self.m_root == nil then return end 
    WZLog("WndSingleCopyInfo:receiveMakePairOk")
    self:endPairTimer()
    WBattleGlobal:getCurrent():destroy()
    local bIsRoomOwner = self:getIsRoomOwner()
    WBattleGlobal:getCurrent().m_tMakePairOk = {
    battleId=battleId, battleMull=false, battleChannle=-1,mapId=mapId,playerCount=playerCount,playerId=playerId, serverId=serverId,playerName=playerName, playerTitle = playerTitle, playerCommunity=playerCommunity, playerLevel=playerLevel, playerSex=playerSex, maxHP=maxHP, maxPF=maxPF, maxSP=maxSP, attack=attack,critRate=critRate,defence=defence,injuryFree=injuryFree, wreckDefense=wreckDefense, reduceCrit=reduceCrit, power=power, armor=armor,constitution=constitution,agility=agility,lucky=lucky,headId=headId,faceId=faceId,bodyId=bodyId,weaponId=weaponId,wingId=wingId,item_id=item_id,playerBuffCount=playerBuffCount, buffId=buffId,petId=petId,petSkill=petSkill,petLevel=petLevel,petSkillId=petId,petParam=petParam,guaiBattleId=guaiBattleId,guaiId=guaiId,battleMode=BattleConstants.g_tBossBattleMode.MODE_ISLANDOWNER_STAGE,tournamentLevel=tournamentLevel, colour=colour, bodyColour=bodyColour ,footmark = footmark, professionId = professionId, professionSkill = professionSkill, playerCamp = playerCamp, mountId = mountId, childId = childId, childName = childName, childSex = childSex, childImage = childImage, assistSkillIds = assistSkillIds, bIsRoomOwner = bIsRoomOwner, defaultShapeBigSkill = defaultShapeBigSkill, blastEffect = blastEffect, extPropertyKey = extPropertyKey, extPropertyValue = extPropertyValue, extPropertyCount = extPropertyCount}

    WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_BOSS
    WBattleGlobal:getCurrent().battleMode = BattleConstants.g_tBossBattleMode.MODE_ISLANDOWNER_STAGE
    g_nRoomOwnerId = self.m_nHomeowner
    --保存标记，游戏中获取装备时，等自动跳转会副本界面时才弹装备提示
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    self.m_toBattleLoadingScene = true

    replaceScene(SceneBattleLoading:createElement())
end


function WndSingleCopyInfo:setJumpIsland(nJumpIsland)
    self.m_nJumpIsland = nJumpIsland
end

-------------------------------------私有方法模块End----------------------------------------
