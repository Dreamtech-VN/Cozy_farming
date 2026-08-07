--WndDoubleTowerRoom.lua
--@brief	WndDoubleTowerRoom的UI模块
--@date		2019/11/20
--@author	Tianxiang_Xu
--@note		双人爬塔房间


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDoubleTowerRoom:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDoubleTowerRoom:onExit(element)
	NotificationCenter:unregisterNotification(UPDATEDOUBLETOWERCOPYDATANOTIFICATION, self)
	CacheCenter:unregisterUpateDressSuitObserver(self)
	self.m_root:disableSchedule()
	self:exitRoom()
    ChangeChatChannel(g_nLastChannelId)
	ProtocolProcessorSceneBossRoom:unregAll() --反注册协议

	self:_unInit()
end

function WndDoubleTowerRoom:onEnterTransitionDidFinish(element)
	--body
	ProtocolProcessorSceneBossRoom:regAll() --注册协议
	self.m_root:enableSchedule("_updateCheckPlayerState", 1)

	self.m_toBattleLoadingScene = nil

	NotificationCenter:registerNotification(UPDATEDOUBLETOWERCOPYDATANOTIFICATION, self, self.updateDoubleTowerData)
	CacheCenter:registerUpateDressSuitObserver(self)
	--噩梦塔房间频道
    g_nLastChannelId = GlobalGame.g_nCurrentUIChannelId
    ChangeChatChannel(Chat_Channel_DoubleTower_Room)
    
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)

	WZLog("WndDoubleTowerRoom:onEnterTransitionDidFinish")
	self.m_nMaxChallengeTimes = tonumber(CacheCenter:getGameParam().doublePagodaTimes)
	self.m_nMaxHelpTimes = tonumber(CacheCenter:getGameParam().doublePagodahelpTimes)

--	self:_addTop()
	
	WndChat:addChatWindowToCurScene()
end

--@brief    关闭界面按钮点击相应
function WndDoubleTowerRoom:onCloseClick(element)
    -- body
    --播放点击音效
    ChangeChatChannel(g_nLastChannelId)
    
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	触摸开始回调
function WndDoubleTowerRoom:onTouchBegan(element, pt)
	-- body
	WndItemInfo:onCloseClick()

	if self.m_tCellDressSuit and not self.m_tCellDressSuit:checkPointInBtn(pt) then
        self.m_tCellDressSuit:hideSuitList()
    end
end

--@brief    点击奖励物品回调
function WndDoubleTowerRoom:onItemClick(luaTable, tag, tData)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- body
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root, self.m_root, 1, tData, nil, nil, true)
end

--@brief  显示宠物tip
function WndDoubleTowerRoom:onClickPet(element)
    WZLog("WndDoubleTowerRoom:onClickPet")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    local petInfo = self.m_tPlayersPetInfo[tag]
    if petInfo and petInfo.itemId ~= nil then
        if tag <= 3 then
            WndTips:show(element,self.m_root,13,petInfo,GlobalMethod:ccp(340,-40),true)
        else
            WndTips:show(element,self.m_root,13,petInfo,GlobalMethod:ccp(340,20),true)
        end
    end
end

--@brief 查看玩家武器信息
function WndDoubleTowerRoom:onClickWeapon(element)
    WZLog("WndDoubleTowerRoom:onClickWeapon")
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

--@brief    点击CellRoomSeat回调
function WndDoubleTowerRoom:onClickCellRoomSeat(element)
    WZLog("WndDoubleTowerRoom:onClickCellRoomSeat")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    self:_showPlayerInfo(tag)
end

--@brief    显示玩家信息
--@param    nPlayerSeat：玩家座位号
function WndDoubleTowerRoom:_showPlayerInfo(nPlayerSeat)
    if self.m_tData.playerId[nPlayerSeat] then
        WndCheckOther:show(self.m_tData.playerId[nPlayerSeat])
    end
end

--brief    开始游戏按钮回调
function WndDoubleTowerRoom:onClickChallenge(element)
    WZLog("WndDoubleTowerRoom:onClickChallenge")
    --音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    CacheCenter.m_nPlayerLevel = CacheCenter:getPlayerInfo().level
    
    if self.click == true then return end
    local btnStartGame = GetElement(self.m_root,"btnStartGame_WndDoubleTowerRoom",WZUIButton)
    btnStartGame:enableSchedule("startFinish", 1.5)
    self.click = true

    -- 房主在大家都准备的情况下可以开始游戏，房客则准备或者取消准备
    if self:getIsRoomOwner() then
        if self:_allPlayersReady() then
            ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_MakePair(self.m_tData.roomId)
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

function WndDoubleTowerRoom:startFinish()
    local btnStartGame = GetElement(self.m_root,"btnStartGame_WndDoubleTowerRoom",WZUIButton)
    btnStartGame:disableSchedule()

    self.click = false
end

--显示当前房间的玩家聊天信息
function WndDoubleTowerRoom:showChat(txtMsg, playerId, bubbleId)
    WZLog("WndDoubleTowerRoom:showChat ",txtMsg,playerId)
    local seatIndex = self:findPlayerSeatById(playerId)
    if seatIndex > 0 then
        local conSeat = GetElement(self.m_root,"conSeat" .. seatIndex .. "_WndDoubleTowerRoom",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_WndDoubleTowerRoom")
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

--@brief  退出房间
function WndDoubleTowerRoom:exitRoom()
    if self.m_tData == nil or self.m_root == nil then
        WZLog("WndDoubleTowerRoom:onBackSceneCallback m_tData is nil")
        return
    end
    if self.m_toBattleLoadingScene ~= true then
        if WBattleGlobal:getCurrent().m_tMakePairOk and WBattleGlobal:getCurrent().m_tMakePairOk.battleId then
            WBattleGlobal:getCurrent().m_tMakePairOk.battleId = 0
        end
        ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat())
    end
end

function WndDoubleTowerRoom:_updateCheckPlayerState(element,dt)
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
    GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change",'state_room_boss',self.m_tData.roomId,self:_getPlayerNum(),self:_getPlayerSeat(),allReady)
end

--@brief 	点击邀请按钮回调
function WndDoubleTowerRoom:showInviteFriends(element)
	-- body
	if not self:hasNullSeat() then
        MsgBoxManager:showTipBox(LocalStrings.HALL_NO_SEAT)
        return
    end

    WndFriendList:showInterface(16, self, self.inviteFriend)
end

-- 邀请界面点击邀请回调
function WndDoubleTowerRoom:inviteFriend(tFriend,selectIndex,bAssistFight,_type)
    --音效
    if _type and _type == 6 then
        ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_Invite(self.m_tData.roomId, tFriend.id, 5)
    else
        ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_Invite(self.m_tData.roomId, tFriend.id)
    end

    GetElement(self.m_root, "txtWaitWord_WndDoubleTowerRoom", WZUILabelTTF):setVisible(true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    添加顶部钻石栏
function WndDoubleTowerRoom:_addTop()
    -- body
    local conTop = GetElement(self.m_root, "conTop_WndDoubleTowerRoom", WZUIContainer)
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_xkhj.png", WndDoubleTowerRoom, WndDoubleTowerRoom.onCloseClick, true, true, true,nil,{scale=0.75})
    tNewObj:setTopType()
    conTop:addChild(celElement)
    self.m_topCellLua = tNewObj
end

--@brief 	刷新
function WndDoubleTowerRoom:_update()
	-- body
	WZLog("WndDoubleTowerRoom:_update")             
    if self.m_root == nil then
        WZLog("WndDoubleTowerRoom:_update m_root is nil.")
        return
    end

    if self.m_tData == nil then
        WZLog("WndDoubleTowerRoom:_update m_tData is nil.")
        return
    end

	local userData = CacheCenter:getDoubleTowerCopyData()
	if userData == nil then return end 
	local floorData = GDatatab_grouptower_map["id_" .. self.m_tData.mapId]
	local statePath = {"ui/common/common_icon_weida.png", "ui/common/common_icon_dacheng.png"}
	--第几层
	local txtFloorName = GetElement(self.m_root, "txtFloorName_WndDoubleTowerRoom", WZUILabelTTF)
	if txtFloorName then 
		txtFloorName:setText(floorData.name)
	end
	--完美通关条件
	local tBits = self:_NumberToBits(self.m_tData.floorState, 3)
	WZLog("WndDoubleTowerRoom:_update", Serialize(tBits))
    local nAchieConNum = 0 
	for i = 1, 3 do
		local conCondition = GetElement(self.m_root, "conCondition" .. i .. "_WndDoubleTowerRoom", WZUIContainer)
		conCondition:setVisible(true)
		local imgStar = GetElement(self.m_root, "imgStar" .. i .. "_WndDoubleTowerRoom", WZUIImage)
		local txtCondition = GetElement(self.m_root, "txtCondition" .. i .. "_WndDoubleTowerRoom", WZUILabelTTF)
		local imgState = GetElement(self.m_root, "imgState" .. i .. "_WndDoubleTowerRoom", WZUIImage)
		if tBits[i] == 0 then 
			imgStar:setGrayRender(true)
		else
			imgStar:setGrayRender(false)
            nAchieConNum = nAchieConNum + 1
		end
		local nConIndex = floorData["pass" .. i][1][1]
		local content 
		if nConIndex == 6 or nConIndex == 8 then 
			local skillName = self:getSkillName(floorData["pass" .. i][1][2])
			content = string.format(LocalStrings.DOUBLETOWER_TEXT6[nConIndex], skillName)
		else
			content = string.format(LocalStrings.DOUBLETOWER_TEXT6[nConIndex], floorData["pass" .. i][1][2])
		end
		txtCondition:setText(content)
		imgState:setFile(statePath[tBits[i] + 1])
	end
    --奖励获得状态
    if nAchieConNum > 0 then 
        -- GetElement(self.m_root, "imgRewardState1_WndDoubleTowerRoom", WZUIImage):setVisible(true)
        if nAchieConNum >= 3 then 
            GetElement(self.m_root, "imgRewardState2_WndDoubleTowerRoom", WZUIImage):setVisible(true)
        end
    else
        -- GetElement(self.m_root, "imgRewardState1_WndDoubleTowerRoom", WZUIImage):setVisible(false)
        GetElement(self.m_root, "imgRewardState2_WndDoubleTowerRoom", WZUIImage):setVisible(false)
    end
	--首次通关奖励
	local tbReward1 = GetElement(self.m_root, "tbReward1_WndDoubleTowerRoom", WZUITableContainer)
	tbReward1:cleanTable()
    local rewardTable = floorData.fixed_reward
    if not self:getIsRoomOwner() then 
        rewardTable = floorData.help_reward
        -- GetElement(self.m_root, "imgRewardState1_WndDoubleTowerRoom", WZUIImage):setVisible(false)
        GetElement(self.m_root, "txtRewardTitle1_WndProfession", WZUILabelTTF):setTextKey("DOUBLETOWER_TEXT18")
    end

    local needLv = GDatatab_button_info["id_"..191].open_level
    local playerLv = CacheCenter:getPlayerInfo().level
    local tData2 = CopyTable(rewardTable)
    if playerLv < needLv then
        for k,v in pairs(tData2) do
            if v[1] == 95 then
                table.remove(tData2,k)
            end
        end
    end

	for i = 1, #tData2 do
		local element, tCell = CellGoodItem:createElement()
		if element and tCell then 
			element:setTag(i - 1)
			tCell:setCellGoodLocalId(tData2[i][1], tData2[i][2], 16)
			tCell:setItemClickFun(self, self.onItemClick)
			element:setScale(0.9)
			tbReward1:setCellElement(element)
		end
	end
	--完美通关奖励
	local tbReward2 = GetElement(self.m_root, "tbReward2_WndDoubleTowerRoom", WZUITableContainer)
	tbReward2:cleanTable()
    rewardTable = floorData.floor_reward
    if not self:getIsRoomOwner() then 
        rewardTable = floorData.help_reward2
        GetElement(self.m_root, "imgRewardState2_WndDoubleTowerRoom", WZUIImage):setVisible(false)
        GetElement(self.m_root, "txtRewardTitle2_WndProfession", WZUILabelTTF):setTextKey("DOUBLETOWER_TEXT19")
    end
    --职业二转开启才能获得高级学识

    local tData1 = CopyTable(rewardTable)
    if playerLv < needLv then
        for k,v in pairs(tData1) do
            if v[1] == 95 then
                table.remove(tData1,k)
            end
        end
    end
	for i = 1, #tData1 do
    		local element, tCell = CellGoodItem:createElement()
    		if element and tCell then 
    			element:setTag(i - 1)
    			tCell:setCellGoodLocalId(tData1[i][1], tData1[i][2], 16)
    			tCell:setItemClickFun(self, self.onItemClick)
    			element:setScale(0.9)

    			tbReward2:setCellElement(element)
    		end
        -- end
	end
	--挑战次数
	local txtChallengeWord = GetElement(self.m_root, "txtChallengeWord_WndDoubleTowerRoom", WZUILabelTTF)
	if txtChallengeWord then 
		if not self:getIsRoomOwner() then 
			txtChallengeWord:setTextKey("DOUBLETOWER_TEXT9")
		end
	end
	local txtChallengeTimes = GetElement(self.m_root, "txtChallengeTimes_WndDoubleTowerRoom", WZUILabelTTF)
	if txtChallengeTimes then 
		if not self:getIsRoomOwner() then 
			txtChallengeTimes:setText(userData.helpTimes .. "/" .. self.m_nMaxHelpTimes)
		else
			txtChallengeTimes:setText(userData.dareTimes .. "/" .. self.m_nMaxChallengeTimes)
		end
	end
	--玩家形象
	--更新玩家座位
    self:updatePlayerSeat()

    self:updateReaderBtn()
    self:setOwnerAndPartnerWord()
end

--@brief    创建一个玩家座位
--@param    index:cell的识别
--@param    bgType:背景类型(1:红色,2:蓝色)
--@param    isused:座位是否关闭
--@return   #1:element的引用
--@return   #2:表的引用
function WndDoubleTowerRoom:_createASeat(index,bgType,isused)
    WZLog("WndDoubleTowerRoom:_createASeat",index,bgType,isused)
    local tagType = 1

    local cellElement,cellObj = CellRoomSeat:createElement(tagType)
    cellElement:setScale(0.8)
    cellElement:setTag(index)
    cellObj:setBgType(bgType)
    cellObj:setBGRectVisible(false)
    
    local conSeat = GetElement(self.m_root, "conSeat" .. index .. "_WndDoubleTowerRoom")
    local imgPlayerStats = GetElement(conSeat,"imgPlayerStatus_WndDoubleTowerRoom",WZUIImage)
    imgPlayerStats:setFile("")

    if isused then
        if self.m_tData.wnersId == self.m_tData.playerId[index] then
            imgPlayerStats:setFile("ui/common/common_icon_fangzhu.png")
        else
            if self.m_tData.playerReady[index] then
                imgPlayerStats:setFile("ui/common/common_icon_zhunbei4.png")
            else
                imgPlayerStats:setFile("")
            end
        end
    end
    
    local curD = self.m_tData
    cellObj:setData(curD.wnersId,curD.seatUsed[index],curD.playerId[index],curD.playerName[index],curD.playerLevel[index],curD.playerReady[index],curD.playerSex[index],curD.vipLevel[index],curD.playerTitle[index],curD.fighting[index],curD.playerNumMode,index,-1,curD.battleMode,0,curD.seatUsed,curD.serviceId[index],curD.roomChannel,0,0,0,curD.winTimes[index],curD.joinTimes[index],curD.continuousWinTimes[index],curD.matchscore[index],curD.qualifyingLevel[index],curD.assist[index], curD.assistTimesState[index])
    cellObj:setSeatInfo(self.m_tData.seatUsed)
    cellObj:setRoomId(self.m_tData.roomId)
    cellObj:setParentRoot(self.m_root)
    if curD.playerId[index] <= 0 then 
    	cellObj:setChangeSeatCallBack(self.showInviteFriends, self)
    	cellObj:setAddIconAndWaitWordVisible(true, false)
    end

    local friendInfo = self:getFriendRV(self.m_tData.playerId[index])
    cellObj:setFriendInfo(friendInfo)

    local masterInfo = self:getMasterRV(self.m_tData.playerId[index],self.m_tData.playerLevel[index])
    cellObj:setMasterInfo(masterInfo)

    local spouseValue,spuseLevel,wifeName,husbandName = self:getSpouseRV(self.m_tData.playerId[index],self.m_tData.playerSex[index],self.m_tData.playerName[index])
    cellObj:setSpouseInfo(spouseValue,spuseLevel,wifeName,husbandName)

    return cellElement,cellObj
end

--@brief  判断是否有空位
function WndDoubleTowerRoom:hasNullSeat()
    for i,v in ipairs(self.m_tData.playerId) do
        if v <= 0 and self.m_tData.seatUsed[i] then
            return true
        end
    end
    return false
end

--@brief    更新玩家座位
function WndDoubleTowerRoom:updatePlayerSeat()
    WZLog("WndDoubleTowerRoom:updatePlayerSeat")
    local isVoice = self:checkVoiceChannelLv(self.m_tData.roomChannel)
    local playerSeatIndex = self:_getPlayerSeat()
    playerSeatIndex = playerSeatIndex + 1
    GlobalGame.g_nPlayerInTeam = -1
    local indexTag = 0
    local maxCount = 2

    for i = 1, maxCount do
        self:checkCellChatBubble(i)
        local conSeat = WZUIContainer:luaTo(self.m_root:getChildElement("conSeat".. i .."_WndDoubleTowerRoom"))
        local btnPlayerFigure  = WZUIButton:luaTo(conSeat:getChildElement("btnPlayerFigure_WndDoubleTowerRoom"))
        local btnPlayerPet = GetElement(conSeat,"btnPlayerPet_WndDoubleTowerRoom",WZUIButton)

        local conWeapon= WZUIContainer:luaTo(conSeat:getChildElement("conWeapon_WndDoubleTowerRoom"))
        local imgWeaponIcon = WZUIImage:luaTo(conWeapon:getChildElement("imgWeaponIcon_WndDoubleTowerRoom"))
        imgWeaponIcon:setFile("")

        local btnWeapon = WZUIButton:luaTo(conWeapon:getChildElement("btnWeapon_WndDoubleTowerRoom"))
        btnWeapon:setTag(-1)

        local spWeapon1 = GetElement(conWeapon,"spWeapon_WndDoubleTowerRoom",WZUISpine)
        spWeapon1:setVisible(false)
        local playerId = self.m_tData.playerId[i]
        self:showPlayerFigureAndPet(i)

        local conFigure = GetElement(conSeat,"conFigureVoice_WndDoubleTowerRoom",WZUIContainer)
        local anim = GetElement(conSeat,"animFigureVoice_WndDoubleTowerRoom",WZUISpine)
        local img = GetElement(conSeat,"imgFigureVoice_WndDoubleTowerRoom",WZUIImage)

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

        local conSeatInfo = GetElement(conSeat,"conSeatInfo_WndDoubleTowerRoom",WZUIContainer)
        local conSeatInfoChild = conSeatInfo:getChildByTag(111)
        if conSeatInfoChild then
            WZLog("updateSeat.......")
            conSeatInfoChild = WZUIContainer:luaTo(conSeatInfoChild)
            local luaObject = conSeatInfoChild:getLuaObjectIndex()
            self:_updateSeatInfo(luaObject,conSeatInfoChild,i,indexTag,self.m_tData.seatUsed[i])
        else
            WZLog("createSeat...... ", i, indexTag, self.m_tData.seatUsed[i])
            local cellElement,cellObj = self:_createASeat(i, indexTag, self.m_tData.seatUsed[i])
            cellElement:setTag(111)
            conSeatInfo:addChild(cellElement)
        end
    end

    self:showCoupleAnimation()
end

--@brief    检查语音渠道和等级
function WndDoubleTowerRoom:checkVoiceChannelLv(channel)
    local isShow = false
    local battleMode = self.m_tData.battleMode
    WZLog("WndDoubleTowerRoom:checkVoiceChannelLv", channel, battleMode, CheckTalkButtonShow(12))
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

--@brief  更新开始游戏按钮状态
function WndDoubleTowerRoom:updateReaderBtn()
    WZLog("WndDoubleTowerRoom:updateReaderBtn()")
    local txtBtnChallenge = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtBtnChallenge_WndDoubleTowerRoom"))
    
    if self:getIsRoomOwner() then
        txtBtnChallenge:setTextKey("DOUBLETOWER_TEXT4")
    else
        for i,v in ipairs(self.m_tData.playerId) do
            if v == GlobalGame.g_tPlayerInfo.nPlayerId then
                if self.m_tData.playerReady[i] then
                    txtBtnChallenge:setTextKey("LEAGUE59")
                else
                    txtBtnChallenge:setTextKey("READY")
                end
                return
            end
        end
    end
end

--@brief 显示玩家形象与宠物
function WndDoubleTowerRoom:showPlayerFigureAndPet(index)
    WZLog("WndDoubleTowerRoom:showPlayerFigureAndPet")
    local playerEquipment = {}
    for i=1,5 do
        playerEquipment[i]= self.m_tData.playerEquipment[(index-1)*5+i]
    end
   
    if self.m_tData.seatUsed[index] and self.m_tData.playerId[index] > 0  then
        local conSeat = GetElement(self.m_root,"conSeat" .. index .. "_WndDoubleTowerRoom",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_WndDoubleTowerRoom",WZUIContainer)
        local playerFigure = conPlayer:getChildByTag(self.m_tData.playerId[index])
        local indexx = nil
        if playerFigure ~= nil then
            for i,v in ipairs(self.m_tScheduleList) do
                if v[1] == playerFigure then
                    indexx = i
                    break
                end
            end
            if indexx then
                table.remove(self.m_tScheduleList,indexx)
            end
        end
            conPlayer:removeAllChildrenWithCleanup(true)
            local playerId = self.m_tData.playerId[index]
            local animAtionName = nil
            local scalePlayer = 0.8
            playerFigure = self:createAPlayer(self.m_tData.playerSex[index],playerEquipment,self.m_tData.headColors[index],self.m_tData.bodyColors[index],animAtionName)
            playerFigure:getAnimNode():setTag(playerId)
            playerFigure:setScale(scalePlayer)
            local playerAnimNode = playerFigure:getAnimNode()
            playerAnimNode:setScale(1.5)
            conPlayer:addChild(playerAnimNode)
            local countDown = 1.5
            local playerInfo  = {playerFigure,playerId,index,countDown}
            table.insert(self.m_tScheduleList,playerInfo)
        
        local conPet = GetElement(conSeat,"conPet_WndDoubleTowerRoom",WZUIContainer)
        
        local petInfo = self.m_tPlayersPetInfo[index]
        
        if petInfo ~= nil and petInfo.itemId ~= nil then
            local petTag = self.m_tData.playerId[index]+10
            local petFigure = conPet:getChildByTag(petTag)
            if petFigure == nil then
                conPet:removeAllChildrenWithCleanup(true)
                local petId = petInfo.itemId
                local animation = petInfo.animation
                local petAnimation,par = CreatePetAni(conPet,petId,animation,petInfo.advancedLevel, petInfo.petSkinItemId)
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
        --名字和称号
        local conForNameAndTitle = GetElement(conSeat, "conForNameAndTitle_WndDoubleTowerRoom", WZUIContainer)
        if conForNameAndTitle then
            local txtPlayerName = GetElement(conSeat, "txtPlayerName_WndDoubleTowerRoom", WZUILabelTTF)
            txtPlayerName:setText(self.m_tData.playerName[index])
            local txtPlayerLv = GetElement(conSeat, "txtPlayerLv_WndDoubleTowerRoom", WZUILabelTTF)
            txtPlayerLv:setText("Lv" .. self.m_tData.playerLevel[index])
            if playerId == CacheCenter:getPlayerInfo().id then
                txtPlayerName:setColor(GlobalMethod:ccc3(99,255,95))
            else
                txtPlayerName:setColor(GlobalMethod:ccc3(255,255,255))
            end
            local conTitle = GetElement(conSeat, "conTitle_WndDoubleTowerRoom", WZUIContainer)
            local txtPlayerTitle = GetElement(conSeat, "txtPlayerTitle_WndDoubleTowerRoom", WZUILabelTTF)
            local tempPoint = GlobalMethod:ccp(0.5, 1.9)
            if self.m_tData.playerTitle[index] and self.m_tData.playerTitle[index] ~= "" then
                CreateDesiSpine(conTitle, txtPlayerTitle, self.m_tData.playerTitle[index], tempPoint, nil, 0.9)
            end
        end
        --套装按钮
        if playerId == CacheCenter:getPlayerInfo().id then
            self:_addDressSuit(conSeat)
        end
    else
        local conSeat = GetElement(self.m_root,"conSeat" .. index .. "_WndDoubleTowerRoom",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_WndDoubleTowerRoom",WZUIContainer)
        local conPet = GetElement(conSeat,"conPet_WndDoubleTowerRoom",WZUIContainer)
        local conForDressSuit = GetElement(conSeat,"conForDressSuit_WndDoubleTowerRoom",WZUIContainer)
        local txtPlayerName = GetElement(conSeat, "txtPlayerName_WndDoubleTowerRoom", WZUILabelTTF)
        local txtPlayerLv = GetElement(conSeat, "txtPlayerLv_WndDoubleTowerRoom", WZUILabelTTF)
        local txtPlayerTitle = GetElement(conSeat, "txtPlayerTitle_WndDoubleTowerRoom", WZUILabelTTF)
        local conTitle = GetElement(conSeat, "conTitle_WndDoubleTowerRoom", WZUIContainer)
        conPlayer:removeAllChildrenWithCleanup(true)
        conPet:removeAllChildrenWithCleanup(true)
        if conForDressSuit then 
            conForDressSuit:removeAllChildrenWithCleanup(true)
        end
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

function WndDoubleTowerRoom:onClickItem(element)
    WZLog("WndDoubleTowerRoom:onClickItem")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    WndSkillContainer:showById(1)
end

--@brief  更新座位信息
function WndDoubleTowerRoom:_updateSeatInfo(luaObject,elementObject,index,bgType,isused)
    WZLog("WndDoubleTowerRoom:_updateSeatInfo ",index)
    if luaObject ~= nil then
        luaObject:setBgType(bgType)
        local conSeat = GetElement(self.m_root,"conSeat" .. index .. "_WndDoubleTowerRoom",WZUIContainer)
        local imgPlayerStats = WZUIImage:luaTo(conSeat:getChildElement("imgPlayerStatus_WndDoubleTowerRoom"))
        imgPlayerStats:setFile("")
        if isused then
            if self.m_tData.wnersId == self.m_tData.playerId[index] then
                if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX and index <= 3  then
                    imgPlayerStats:setFile("ui/Hall/common_icon_fangzhu02.png")
                else
                    imgPlayerStats:setFile("ui/common/common_icon_fangzhu.png")
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
        luaObject:setData(curD.wnersId,curD.seatUsed[index],curD.playerId[index],curD.playerName[index],curD.playerLevel[index],curD.playerReady[index],curD.playerSex[index],curD.vipLevel[index],curD.playerTitle[index],curD.fighting[index],curD.playerNumMode,index,-1,curD.battleMode,0,curD.seatUsed,curD.serviceId[index],curD.roomChannel,0,0,0,curD.winTimes[index],curD.joinTimes[index],curD.continuousWinTimes[index],curD.matchscore[index],curD.qualifyingLevel[index],curD.assist[index], curD.assistTimesState[index])
        luaObject:setSeatInfo(self.m_tData.seatUsed)
        local friendInfo = self:getFriendRV(self.m_tData.playerId[index])
        luaObject:setFriendInfo(friendInfo)
        if curD.playerId[index] <= 0 then 
	    	luaObject:setChangeSeatCallBack(self.showInviteFriends, self)
	    	luaObject:setAddIconAndWaitWordVisible(true, false)
	    else 
	    	luaObject:setAddIconAndWaitWordVisible(false, false)
	    end

        local masterInfo = self:getMasterRV(self.m_tData.playerId[index],self.m_tData.playerLevel[index])
        luaObject:setMasterInfo(masterInfo)

        local spouseValue,spuseLevel,wifeName,husbandName = self:getSpouseRV(self.m_tData.playerId[index],self.m_tData.playerSex[index],self.m_tData.playerName[index])
        luaObject:setSpouseInfo(spouseValue,spuseLevel,wifeName,husbandName)

        luaObject:_update()
    end
end

--@brief    创建一个角色动画
function WndDoubleTowerRoom:createAPlayer(playerSex, equipment, headColor, bodyColor, animName)
    WZLog("WndDoubleTowerRoom:createAPlayer")
    return CreatePlayerFigure(playerSex, equipment, animName, nil, nil, nil, nil, nil, nil, nil, headColor, bodyColor)
end

--@brief    添加时装套装入口
function WndDoubleTowerRoom:_addDressSuit(element)
    -- body
    if CheckButtonOpen(144, false) then
        local conForDressSuit = GetElement(element, "conForDressSuit_WndDoubleTowerRoom", WZUIContainer)
        conForDressSuit:removeAllChildrenWithCleanup(true)
        if conForDressSuit then
            local wndDress, tCell = WndDressSuit:createElement()
            if wndDress and tCell then
                tCell:setType(4)
                self.m_tCellDressSuit = tCell
                conForDressSuit:addChild(wndDress)
            end
        end
    end
end

--@brief    开始配对计时器
function WndDoubleTowerRoom:startPairTimer()
    WZLog("WndDoubleTowerRoom:startPairTimer")
    self.m_nPairRemainTime = 10
    local downTime = GetElement(self.m_root,"txtMakePairTime_WndDoubleTowerRoom",WZUILabelAtlasFont)
    downTime:setText(self.m_nPairRemainTime)
    downTime:enableSchedule("_schedulePairTimer",1)
    self.m_root:enableSchedule("_scheduleCheckRoomPlayer", 0)
end

--@brief    配对计算器的回调函数
function WndDoubleTowerRoom:_schedulePairTimer()
    if self.m_nPairRemainTime > 0 then
        self.m_nPairRemainTime = self.m_nPairRemainTime - 1
        WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"txtMakePairTime_WndDoubleTowerRoom")):setText(self.m_nPairRemainTime)
    else
        WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"txtMakePairTime_WndDoubleTowerRoom")):setVisible(false)
    end
end

--@brief    检查房间玩家计算器的回调函数
function WndDoubleTowerRoom:_scheduleCheckRoomPlayer()
    if (not self:_allPlayersReady()) then
        self.m_root:disableSchedule()
        self:endPairTimer()
    end
end

--brief    是否所有玩家已准备
--@return  #1: true:是, false：否
function WndDoubleTowerRoom:_allPlayersReady()
    for i=1, self.m_tData.playerNum do
        if self.m_tData.playerId[i] > 0  and not self.m_tData.playerReady[i] then
            return false
        end
    end
    return true
end

--@brief    关闭配对计时器
function WndDoubleTowerRoom:endPairTimer()
    WZLog("WndDoubleTowerRoom:endPairTimer")
    if self.m_root == nil then return end
    local downTime = GetElement(self.m_root,"txtMakePairTime_WndDoubleTowerRoom",WZUILabelAtlasFont)
    downTime:setVisible(false)
    downTime:disableSchedule()
end

--@brief    设置房主和好友的文字提示
function WndDoubleTowerRoom:setOwnerAndPartnerWord()
    -- body
    local txtWaitWord = GetElement(self.m_root, "txtWaitWord_WndDoubleTowerRoom", WZUILabelTTF)
    if not self:getIsRoomOwner() then
        txtWaitWord:setVisible(true)
        txtWaitWord:setTextKey("DOUBLETOWER_TEXT13")
    end
end


--@brief    显示伴侣互动动画
function WndDoubleTowerRoom:showCoupleAnimation()
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

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function WndDoubleTowerRoom:_adaptLanguage_vn()
    GetElement(self.m_root,"txtCondition1_WndDoubleTowerRoom",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCondition2_WndDoubleTowerRoom",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCondition3_WndDoubleTowerRoom",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtChallengeWord_WndDoubleTowerRoom",WZUILabelTTF):setScale(0.9)
end
-------------------------------------语言适配end----------------------------------------
