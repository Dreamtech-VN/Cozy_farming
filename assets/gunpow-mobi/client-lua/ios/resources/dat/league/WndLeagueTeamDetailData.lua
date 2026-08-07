--WndLeagueTeamDetailData.lua
--@brief	WndLeagueTeamDetail的数据模块
--@date		2016/06/12
--@author	zsq
--@note		战队详情

WndLeagueTeamDetail = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLeagueTeamDetail:_init()
	self.m_root = nil	 	  			--场景根节点
	self.conPlayer1 = nil
	self.conPlayer2 = nil
	self.conPlayer3 = nil
	self.m_tDataList = nil
	self.m_nTag = nil
	self.m_tHeadData1 = nil
	self.m_tHeadData2 = nil
	self.m_tHeadData3 = nil
	self.m_tHeadData4 = nil
	self.m_tRoleData1 = nil
	self.m_tRoleData2 = nil
	self.m_tRoleData3 = nil
	self.m_tWeapon1 = nil
	self.m_tWeapon2 = nil
	self.m_tWeapon3 = nil
	self.m_tPet1 = nil
	self.m_tPet2 = nil
	self.m_tPet3 = nil
	--self.m_bNeedRecruit = true
	self.m_bGameStart = nil
	self.m_bExitTeam = nil
	self.m_nGameStage = nil
	self.m_nMatchingCountdown = nil
	self.m_nLeftTime = nil
	self.m_bFighting = nil

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
function WndLeagueTeamDetail:_unInit()
	self.m_root = nil
	self.conPlayer1 = nil
	self.conPlayer2 = nil
	self.conPlayer3 = nil
	self.m_tDataList = nil
	self.m_nTag = nil
	self.m_tHeadData1 = nil
	self.m_tHeadData2 = nil
	self.m_tHeadData3 = nil
	self.m_tHeadData4 = nil
	self.m_tRoleData1 = nil
	self.m_tRoleData2 = nil
	self.m_tRoleData3 = nil
	self.m_tWeapon1 = nil
	self.m_tWeapon2 = nil
	self.m_tWeapon3 = nil
	self.m_tPet1 = nil
	self.m_tPet2 = nil
	self.m_tPet3 = nil
	self.m_bGameStart = nil
	self.m_bExitTeam = nil
	self.m_nGameStage = nil
	self.m_nMatchingCountdown = nil
	self.m_nLeftTime = nil
	self.m_bFighting = nil

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

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLeagueTeamDetail:createElement()
	local element = WZUISystem:getInstance():createElement("WndLeagueTeamDetail")
	assert(element, "WndLeagueTeamDetail create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndLeagueTeamDetail:setData(teamId, teamName, photoURL, declaration, playerId, faceId, headId, bodyId, wingId, captain, score, fightNum, winNum, readyPlayerId, watchPlayerId, rank, sex, pet, status, timeMes, openTime, level, name, lastFight, itemId, extraInfo, kictNum, outNum, picStatue, canFight, readyed, fight, viceCaptain, headColor, bodyColor, mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, matchLevel, matchscore, joinTimes, winTimes, continuousWinTimes)
	self.m_tDataList = {}
	for i=1,#playerId do
		local tempTable = {}
		tempTable.playerId = playerId[i]
		tempTable.headId = headId[i]
		tempTable.faceId = faceId[i]
		tempTable.bodyId = bodyId[i]
		tempTable.wingId = wingId[i]
		tempTable.sex = sex[i]
		tempTable.pet = pet[i]
		tempTable.status = status[i]
		tempTable.level = level[i]
		tempTable.name = name[i]
		tempTable.itemId = itemId[i]
		tempTable.extraInfo = extraInfo[i]
		tempTable.headColor = headColor[i]
		tempTable.bodyColor = bodyColor[i]
		tempTable.matchLevel = matchLevel[i]
		tempTable.matchscore = matchscore[i]
		tempTable.joinTimes = joinTimes[i]
		tempTable.winTimes = winTimes[i]
		tempTable.continuousWinTimes = continuousWinTimes[i]
		if outNum ~= nil then
			tempTable.outNum = outNum[i]
		else
			tempTable.outNum = 0
		end
		table.insert(self.m_tDataList,tempTable)
	end
	WZLog("WndLeagueTeamDetail:setData",Serialize(self.m_tDataList))
	if self.m_tData == nil then self.m_tData = {} end
	self.m_tData.teamId = teamId
	self.m_tData.teamName = teamName
	self.m_tData.photoURL = photoURL
	self.m_tData.declaration = declaration
	self.m_tData.captain = captain
	self.m_tData.score = score
	self.m_tData.fightNum = fightNum
	self.m_tData.winNum = winNum
	self.m_tData.rank = rank
	self.m_tData.timeMes = timeMes
	self.m_tData.openTime = openTime
	self.m_tData.lastFight = lastFight
	self.m_tData.kictNum = kictNum
	self.m_tData.picStatus = picStatue
	self.m_tData.canFight = canFight
	self.m_tData.fight = fight
	self.m_tData.viceCaptain = viceCaptain

	self.m_tData.mentoringStr = mentoringStr
	self.m_tData.coupleStr = coupleStr
	self.m_tData.chumStr = chumStr
	self.m_tData.coupleNum = coupleNum
	self.m_tData.chumNum = chumNum
	self.m_tData.mentoringNum = mentoringNum

	--self.m_tData.mentoringStr = "19541|21821"
	--self.m_tData.coupleStr = "19541|21821"
	--self.m_tData.chumStr = ""
	--self.m_tData.coupleNum = "0|1"
	--self.m_tData.chumNum = ""
	--self.m_tData.mentoringNum = "2400|1"

	self.m_tData.playerId = playerId
	self.m_tData.playerName = name
	self.m_tData.playerSex = sex
	self.m_tData.playerLevel = level

	for i=1,#playerId do
		if playerId[i] == CacheCenter:getPlayerInfo().id then
			self.m_tData.exitNum = outNum[i]
		end
	end

	self.m_tData.readyPlayerId = readyPlayerId
	self.m_tData.watchPlayerId = watchPlayerId
	self.m_tData.readyed = readyed
	WZLog("WndLeagueTeamDetail:setData1",Serialize(mentoringStr),Serialize(coupleStr),Serialize(chumStr))
	WZLog("WndLeagueTeamDetail:setData2",Serialize(mentoringNum),Serialize(coupleNum),Serialize(chumNum))

	self.m_tData.matchLevel = {}
	self.m_tData.matchscore = {}
	self.m_tData.joinTimes = {}
	self.m_tData.winTimes = {}
	self.m_tData.continuousWinTimes = {}

	--初始化关系数据
	WndLeagueTeamDetail:initRelationShip()

	if #playerId >= 4 then self.m_bNeedRecruit = false end
	ChangeChatChannel(Chat_Channel_League_ROOM)
	self:update()
	self:getTeamData()

	if self.m_root and self.m_bIsVoice and self.m_bIsVoiceState and GetElement(self.m_root,"conFigureVoice1_WndLeagueTeamDetail",WZUIContainer) then
		if GlobalGame.m_nVoiceId then
			ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "1," .. GlobalGame.m_nVoiceId, 0 )
			ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "2," .. self.m_nSpeakerState, 0 )
			ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "3," .. self.m_nMicState, 0 )
		end
	end
end

--@brief	判断id是否在表中
function WndLeagueTeamDetail:idInTable(id,table)
	for i=1,#table do
		if table[i] == id then
			return true
		end
	end
	return false
end

function WndLeagueTeamDetail:getTeamData()
	local tData = CopyTable(self.m_tData)
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..self.m_tData.photoURL
	--如果文件存在，不下载，直接使用
	local bExist = WZFileUtil:isFileExist(path)
	if bExist then
		tData.photoURL = path
	else
		tData.photoURL = "ui/hero/hero_icon_yxlsdb.png"
	end
	if self.m_tData.photoURL == "" then
		tData.photoURL = "ui/hero/hero_icon_yxlsdb.png"
	end
	tData.captain = self.m_nCurCaptain
	return tData
end

--@brief	设置审核红点
function WndLeagueTeamDetail:setRedDot()
	if self.m_root == nil then return end
	if self.m_tData== nil then return end
	GetElement(self.m_root,"imgRed",WZUIImage):setVisible(false)
	--队长才显示红点
	if self.m_bNeedRecruit == true and CacheCenter:getPlayerInfo().id == self.m_tData.captain then
		GetElement(self.m_root,"imgRed",WZUIImage):setVisible(true)
	end
end

--@brief	显示聊天气泡
function WndLeagueTeamDetail:showBubble(msg, playerId,bubbleId)
	for i=1,4 do
		if self["m_tRoleData"..i] ~= nil and self["m_tRoleData"..i].playerId == playerId then
			local con = GetElement(self.m_root,"conChat"..i,WZUIContainer)
			con:removeAllChildrenWithCleanup(true)
			local cellChatBubblenode,tCell  = CellChatBubble:showChatBubble(con,GlobalMethod:ccp(10,10),false)
			tCell:addMsgToList(msg,playerId,bubbleId)
		end
	end
end

--@brief	匹配时的遮罩按钮
function WndLeagueTeamDetail:onForbiden()
	WZLog("遮罩遮罩遮罩遮罩遮罩遮罩遮罩遮罩遮罩遮罩遮罩遮罩遮罩遮罩")
end

-- 更新小提示
function WndLeagueTeamDetail:updateDesc()
    local ttfDesc = GetElement(self.m_root,"txtCountDownTip",WZUILabelTTF)
    local nIndex = math.random(1, #LocalStrings.HALL_DESC2)
    if ttfDesc:getText() == LocalStrings.HALL_DESC2[nIndex] then
        nIndex = nIndex+1
        if nIndex > #LocalStrings.HALL_DESC2 then nIndex = 1 end
    end
    ttfDesc:setText(LocalStrings.TIPS..":"..LocalStrings.HALL_DESC2[nIndex])
end
-------------------------------------私有方法模块End----------------------------------------



--@break	打开技能道具
function WndLeagueTeamDetail:onClickItem() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self:idInTable(CacheCenter:getPlayerInfo().id,self.m_tData.readyed) then
		MsgBoxManager:showTipBox(LocalStrings.NEWSKILL23)
	else
    	WndSkillContainer:showById(1)
	end
end

-------------------------------------处理关系按钮Begin----------------------------------------
function WndLeagueTeamDetail:updateRelationBtn(position, dataIndex) 
	WZLog("WndLeagueTeamDetail:updateRelationBtn", position)
	if self.m_root == nil then return end
	local playerId = self.m_tDataList[dataIndex].playerId
	local level = self.m_tDataList[dataIndex].level
	local name = self.m_tDataList[dataIndex].name
	local sex = self.m_tDataList[dataIndex].sex

	local friendInfo = self:getFriendRV(playerId)
    WndLeagueTeamDetail:setFriendInfo(friendInfo, position)

	local masterInfo = self:getMasterRV(playerId,level)
	WndLeagueTeamDetail:setMasterInfo(masterInfo, position)

	local spouseValue,spuseLevel,wifeName,husbandName = self:getSpouseRV(playerId,sex,name)
	WndLeagueTeamDetail:setSpouseInfo(spouseValue,spuseLevel,wifeName,husbandName, position)

	--排位按钮
	GetElement(self.m_root,"btnP"..position,WZUIButton):setVisible(false)


	local matchLevel = tonumber(self.m_tDataList[dataIndex].matchLevel)
		if matchLevel ~= 0 then

	self.m_tData.matchLevel[position] = self.m_tDataList[dataIndex].matchLevel
	self.m_tData.matchscore[position] = self.m_tDataList[dataIndex].matchscore
	self.m_tData.joinTimes[position] = self.m_tDataList[dataIndex].joinTimes
	self.m_tData.winTimes[position] = self.m_tDataList[dataIndex].winTimes
	self.m_tData.continuousWinTimes[position] = self.m_tDataList[dataIndex].continuousWinTimes

			GetElement(self.m_root,"btnP"..position,WZUIButton):setRelativePosition(ccp(0.3,0.5))
			GetElement(self.m_root,"btnP"..position,WZUIButton):setVisible(true)
    		local info = GDatatab_trio_rank_match_config["id_"..matchLevel]
			for k,v in pairs(GDatatab_trio_rank_match_config) do
				if v.level3 == matchLevel then
					info = v
				end
			end
			if matchLevel > 106 then
				info = GDatatab_trio_rank_match_config["id_999"]
			end
			GetElement(self.m_root,"btnimg"..position.."1",WZUIImage):setFile("ui/common/"..info.icon..".png")
			GetElement(self.m_root,"btnimg"..position.."2",WZUIImage):setFile("ui/common/"..info.icon..".png")
		end

    local btnLove = GetElement(self.m_root,"btnLove_CellRoomSeat"..position,WZUIButton)
    local btnFriend = GetElement(self.m_root,"btnFriend_CellRoomSeat"..position,WZUIButton)
    local btnMaster = GetElement(self.m_root,"btnMaster_CellRoomSeat"..position,WZUIButton)
    btnLove:setVisible(false)
    btnFriend:setVisible(false)
    btnMaster:setVisible(false)

    local imgLove = GetElement(btnLove,"imgLove_CellRoomSeat",WZUIImage)
    local imgLove2 = GetElement(btnLove,"imgLove2_CellRoomSeat",WZUIImage)
    imgLove:setFile("")
    imgLove2:setFile("")

    local imgFriend = GetElement(btnFriend,"imgFriend_CellRoomSeat",WZUIImage)
    local imgFriend2 = GetElement(btnFriend,"imgFriend2_CellRoomSeat",WZUIImage)
    imgFriend:setFile("")
    imgFriend2:setFile("")

    local imgMaster = GetElement(btnMaster,"imgMaster_CellRoomSeat",WZUIImage)
    local imgMaster2 = GetElement(btnMaster,"imgMaster2_CellRoomSeat",WZUIImage)
    imgMaster:setFile("")
    imgMaster2:setFile("")

    local visibleCount = 0
    local visTag1 = nil
    local visTag2 = nil
    local visTag3 = nil
    if self.m_nSpouseValue[position] ~= nil then
        btnLove:setVisible(true)
        visibleCount = visibleCount + 1
        visTag1 = true
        local icon = self:getSpouseImage(position)
        imgLove:setFile(icon)
        imgLove2:setFile(icon)
    end

    if self.m_tFriendValue[position] ~= nil and #self.m_tFriendValue[position] > 0 then
        btnFriend:setVisible(true)
        local icon = self:getFriendImage(position)
        imgFriend:setFile(icon)
        imgFriend2:setFile(icon)
        visibleCount = visibleCount + 1
        visTag2 = true
    end

    if self.m_nMasterValue[position] ~= nil and #self.m_nMasterValue[position] > 0 then
        btnMaster:setVisible(true)
        visibleCount = visibleCount + 1
        local icon = self:getMasterImage(position)
        imgMaster:setFile(icon)
        imgMaster2:setFile(icon)
        visTag3 = true
    end
    btnLove:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
    btnFriend:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
    btnMaster:setRelativePosition(GlobalMethod:ccp(0.75,0.5))

	WZLog("WndLeagueTeamDetail:updateRelationBtn1",visibleCount, visTag1, visTag2, visTag3)
    if visibleCount == 1 then
        if visTag2 then
            btnFriend:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
        elseif visTag3 then
            btnMaster:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
        end
    elseif visibleCount == 2 then
        if visTag1 == nil then
            btnFriend:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
            btnMaster:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
        elseif visTag2 == nil then
            btnMaster:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
        end
	elseif visibleCount == 0 then
		GetElement(self.m_root,"btnP"..position,WZUIButton):setRelativePosition(ccp(0.5,0.5))
    end

end

--设置密友度
function WndLeagueTeamDetail:setFriendInfo(friendValue, position)
	WZLog("WndLeagueTeamDetail:setFriendInfo")
	if self.m_tFriendValue == nil then self.m_tFriendValue = {} end
	self.m_tFriendValue[position] = friendValue
end

--设置师徒关系值
function WndLeagueTeamDetail:setMasterInfo(masterInfo, position)
	WZLog("WndLeagueTeamDetail:setMasterInfo")
	if self.m_nMasterValue == nil then self.m_nMasterValue = {} end
	self.m_nMasterValue[position] = masterInfo
end

--设置夫妻关系值
function WndLeagueTeamDetail:setSpouseInfo(spouseValue,spuseLevel,wifeName,husbandName, position)
	WZLog("WndLeagueTeamDetail:setSpouseInfo")
	if self.m_nSpouseValue == nil then self.m_nSpouseValue = {} end
	if self.m_nSpuseLevel == nil then self.m_nSpuseLevel = {} end
	if self.m_sWifeName == nil then self.m_sWifeName = {} end
	if self.m_sHusband == nil then self.m_sHusband = {} end
	self.m_nSpouseValue[position] = spouseValue    
	self.m_nSpuseLevel[position] = spuseLevel     
	self.m_sWifeName[position] = wifeName     
	self.m_sHusband[position] = husbandName
end

--保存各种关系的数值
function WndLeagueTeamDetail:initRelationShip()
	WZLog("WndLeagueTeamDetail:initRelationShip")
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
function WndLeagueTeamDetail:getFriendRV(playerId)
    WZLog("WndLeagueTeamDetail:getFriendRV")
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
function WndLeagueTeamDetail:getMasterRV(playerId,playerLevel)
    WZLog("WndLeagueTeamDetail:getMasterRV = ",Serialize(self.m_MasterList))
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
			WZLog("kk1",playerLevel)
			WZLog("kk2",tempLevel)
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
function WndLeagueTeamDetail:getSpouseRV(playerId,playerSex,playerName)
	WZLog("WndLeagueTeamDetail:getSpouseRV ")
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

--获取显示的密友图片
function WndLeagueTeamDetail:getFriendImage(position)
    WZLog("WndLeagueTeamDetail:getFriendImage")
	if self.m_tFriendValue[position] == nil then return end
    local maxValue = nil
    for i,v in ipairs(self.m_tFriendValue[position]) do
        if maxValue == nil then
            maxValue = tonumber(v[2])
        else
            if tonumber(v[2]) > maxValue then
                maxValue = tonumber(v[2])
            end
        end
    end
    local temp = nil
    local index = nil
    for j,k in pairs(GDatatab_relationship) do
        if k.type == 2 then
            if temp ~= nil then
                if maxValue >= k.degree and temp < k.degree then
                    temp = k.degree
                    index = k.id
                end
            else
                if maxValue >= k.degree then
                   index = k.id
                   temp = k.degree
                end
            end
        end
    end
    local imageIcon = nil
    if index ~= nil then
        imageIcon = GDatatab_relationship["id_" .. index ].icon
    end
    return imageIcon
end

--获取显示的师徒图片
function WndLeagueTeamDetail:getMasterImage(position)
    WZLog("WndLeagueTeamDetail:getMasterImage")
    local maxValue = nil
    local bMaster = nil
	if self.m_nMasterValue[position] == nil then return end
    for i,v in ipairs(self.m_nMasterValue[position]) do
        bMaster = v[1]
        if maxValue == nil then
            maxValue = tonumber(v[4])
        else
            if tonumber(v[4]) > maxValue then
                maxValue = tonumber(v[4])
            end
        end
    end
    local temp = nil
    local index = nil
    for j,k in pairs(GDatatab_relationship) do
        if not bMaster and k.type == 4 then
            index = k.id
            break
        else
            if k.type == 3 then
                if temp ~= nil then
                    if maxValue >= k.degree and temp < k.degree  then
                        index = k.id
                        temp = k.degree
                    end
                else
                    if maxValue >= k.degree then
                       index = k.id
                       temp = k.degree
                    end
                end
            end
        end
    end
    local imageIcon = nil
    if index ~= nil then
        imageIcon = GDatatab_relationship["id_" .. index ].icon
    end
    return imageIcon
end


--获取显示的夫妻图片
function WndLeagueTeamDetail:getSpouseImage(position)
    WZLog("WndLeagueTeamDetail:getSpouseImage")
    local maxValue = self.m_nSpuseLevel[position]
	if maxValue == nil then return end
    local temp = nil
    local index = nil
    for j,k in pairs(GDatatab_relationship) do
        if k.type == 1 then
            if temp ~= nil then
                if maxValue >= temp and temp < k.degree  then
                    index = k.id
                    temp = k.degree
                end
            else
                if maxValue >= k.degree then
                   index = k.id
                   temp = k.degree
                end
            end
        end
    end
    local imageIcon = nil
    if index ~= nil then
        imageIcon = GDatatab_relationship["id_" .. index ].icon
    end
    return imageIcon
end

--@brief 	查看排位按钮
function WndLeagueTeamDetail:onClickQualifyBtn( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
    local con =WZUIContainer:luaTo(element:getParent())
    con =con:getParent() and con:getParent() or con
    con =con:getParent() and con:getParent() or con
    con =con:getParent() and con:getParent() or con
    con =con:getParent() and con:getParent() or con
    con =WZUIContainer:luaTo(con)
	WZLog("WndLeagueTeamDetail:onClickQualifyBtn", tag)
	
	local winN = self.m_tData.winTimes[tag]
	local joinTimes = self.m_tData.joinTimes[tag]
	local continuousWinTimes = self.m_tData.continuousWinTimes[tag]
	local matchscore = self.m_tData.matchscore[tag]
	local matchLevel = self.m_tData.matchLevel[tag]
	
    local data = {winNum = winN,total = joinTimes,maxWinNum = continuousWinTimes, exp=matchscore,level=matchLevel}
    WndTips:show(element,self.m_root,17,data,GlobalMethod:ccp(220,110))
end

--查看密友信息
function WndLeagueTeamDetail:onTouchFriend(element)
    WZLog("WndLeagueTeamDetail:onTouchFriend")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local position = tonumber(element:getTag())
    local titleName = {}
    local valueName = {}
    for i,v in ipairs(self.m_tFriendValue[position]) do
        local friendName = v[1]
        local temp = nil
        local showTip = nil
        for j,k in pairs(GDatatab_relationship) do
            if k.type == 2 then
                if temp ~= nil then
                    if v[2] >= k.degree and temp < k.degree  then
                        temp = k.degree
                        showTip = k.title
                    end
                else
                    if v[2] >= k.degree then
                        temp = k.degree
                        showTip = k.title
                    end
                end
            end
        end

        local temp2 = SplitStringWithSeparator(showTip,"&")
        local sex = v[3]
        if sex == 0 then --男
            if self.m_tData.playerSex == sex then  --相同的性别
                title = friendName .. temp2[1]
            else
                title = friendName .. temp2[2]
            end
        else  --女
            if self.m_tData.playerSex == sex then  --相同的性别
                title = friendName .. temp2[3]
            else
                title = friendName .. temp2[2]
            end
        end
        table.insert(titleName,title)
        local value = LocalStrings.FRIENDLINESS .. v[2]
        table.insert(valueName,value)
    end
    local temppp = {}
    table.insert(temppp,titleName)
    table.insert(temppp,valueName)
    local con =WZUIContainer:luaTo(element:getParent())
    con =con:getParent() and con:getParent() or con
    con =con:getParent() and con:getParent() or con
    con =con:getParent() and con:getParent() or con
    con =con:getParent() and con:getParent() or con
    con =WZUIContainer:luaTo(con)
	if tonumber(element:getTag()) == 1 then
    	WndTips:show(element,con,31,temppp,GlobalMethod:ccp(180,0))
	elseif tonumber(element:getTag()) == 4 then
    	WndTips:show(element,con,31,temppp,GlobalMethod:ccp(-120,0))
	else
    	WndTips:show(element,con,31,temppp)
	end
end

--师徒
function WndLeagueTeamDetail:onClickMaster(element)
    WZLog("WndLeagueTeamDetail:onClickMaster")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local position = tonumber(element:getTag())
    local titleName = {}
    local valueName = {}
    for i,v in ipairs(self.m_nMasterValue[position]) do
        local bMaster = v[1]
        local masterNum = v[2]
        local masterName = v[3]
        local masterLevel = v[4] --师徒等级
        local temp = nil
        local showTip = nil
        for j,k in pairs(GDatatab_relationship) do
            if not bMaster then
               if k.type == 4 then
                    showTip = k.title
                    break
               end
            else
                if k.type == 3 then
                    if temp ~= nil then
                        if masterLevel >= k.degree and temp < k.degree then
                            temp = k.degree
                            showTip = k.title
                        end
                    else
                        if masterLevel >= k.degree then
                            temp = k.degree
                            showTip = k.title
                        end
                    end
                end
            end 
        end
        local title  = masterName .. showTip
        local value = LocalStrings.FRIENDLINESS .. masterNum

        table.insert(titleName,title)
        table.insert(valueName,value)
    end

    local temppp = {}
    table.insert(temppp,titleName)
    table.insert(temppp,valueName)
    local con =WZUIContainer:luaTo(element:getParent())
    con =con:getParent() and con:getParent() or con
    con =con:getParent() and con:getParent() or con
    con =con:getParent() and con:getParent() or con
    con =con:getParent() and con:getParent() or con
    con =WZUIContainer:luaTo(con)
    --WndTips:show(element,con,31,temppp)
	if tonumber(element:getTag()) == 1 then
    	WndTips:show(element,con,31,temppp,GlobalMethod:ccp(180,0))
	elseif tonumber(element:getTag()) == 4 then
    	WndTips:show(element,con,31,temppp,GlobalMethod:ccp(-120,0))
	else
    	WndTips:show(element,con,31,temppp)
	end
end

--夫妻关系
function WndLeagueTeamDetail:onTouchLove(element)
    WZLog("WndLeagueTeamDetail:onTouchLove")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local position = tonumber(element:getTag())
    local temp = 1
    local title = nil
    for k,v in pairs(GDatatab_relationship) do 
        if v.type == 1 then
            if self.m_nSpuseLevel[position] >= temp  then
                temp = v.degree
                if self.m_sWifeName[position] ~= nil then
                    title = self.m_sWifeName[position] .. v.title
                else
                    title = self.m_sHusband[position] .. v.title
                end
            end
        end
    end

    local titleName = {}
    local valueName = {}

    local value = LocalStrings.COUPLE_LOVE .. " : " .. self.m_nSpouseValue[position]

    table.insert(titleName,title)
    table.insert(valueName,value)

    local temppp = {}
    table.insert(temppp,titleName)
    table.insert(temppp,valueName)
    local con =WZUIContainer:luaTo(element:getParent())
    con =con:getParent() and con:getParent() or con
    con =con:getParent() and con:getParent() or con
    con =con:getParent() and con:getParent() or con
    con =con:getParent() and con:getParent() or con
    con =WZUIContainer:luaTo(con)
    --WndTips:show(element,con,31,temppp)
	if tonumber(element:getTag()) == 1 then
    	WndTips:show(element,con,31,temppp,GlobalMethod:ccp(180,0))
	elseif tonumber(element:getTag()) == 4 then
    	WndTips:show(element,con,31,temppp,GlobalMethod:ccp(-120,0))
	else
    	WndTips:show(element,con,31,temppp)
	end
end
