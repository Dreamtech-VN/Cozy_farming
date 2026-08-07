--SceneBossRoom.lua
--@brief    SceneBossRoom的UI模块
--@date     2013/12/26
--@author   李光森
--@modify   qixiang_xie
--@note     战斗房间


-------------------------------------公有方法模块Begin--------------------------------------
--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function SceneBossRoom:onEnter(element)
    WZLog("SceneBossRoom:onEnter ")
    self.m_root = element

    self.m_bIsCreate = true
    self.m_toBattleLoadingScene = nil
    ProtocolProcessorSceneBossRoom:regAll() --注册协议
    CacheCenter:registerUpateDressSuitObserver(self)
    CacheCenter:registerUpateSkillSuitObserver(self)
    NotificationCenter:registerNotification(UPDATEMULTICOPYDATANOTIFICATION, self, self.updateData)

    IPDConnector.g_nNetConnectFlag = NET_FLAG_7
    
    --组队房间频道
    ChangeChatChannel(Chat_Channel_Team_Copy_Room)
    
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)

    self:addTop()
    if self.m_tData ~= nil then
        self:endPairTimer()
        self:_update()
    end
    self:anctionPlayFinish()

    self.m_root:enableSchedule("_updateCheckPlayerState",1)

    WndChat:addChatWindowToCurScene()

    self:checkVoice()

    --黑市商人出现
    WndGangsterInn:show()

    local isEndTeach, teachStep = TeachGroup1:isTeachFinish(15)

    if isEndTeach ~= true then
        TeachGroup1:endTeachStep({15,3})
        TeachGroup1:startGroupLevelUp(nil, nil, true, nil, {15,4,self.m_root})
    end
end

--@breif  动画播放完毕
function SceneBossRoom:anctionPlayFinish()
    local conCenter = GetElement(self.m_root, "conCenter_SceneBossRoom", WZUIContainer)
    local conBg = GetElement(self.m_root, "conBg_SceneBossRoom", WZUIContainer)

    conBg:enableSchedule("updatePlayerZOrder")
    conCenter:enableSchedule("updatePlayerAnimation",1.5)
end

--@brief  退出房间
function SceneBossRoom:exitRoom()
    if self.m_tData == nil or self.m_root == nil then
        WZLog("SceneBossRoom:onBackSceneCallback m_tData is nil")
        return
    end
    if self.m_toBattleLoadingScene ~= true then
        if WBattleGlobal:getCurrent().m_tMakePairOk and WBattleGlobal:getCurrent().m_tMakePairOk.battleId then
            WBattleGlobal:getCurrent().m_tMakePairOk.battleId = 0
        end
        ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat())
    end
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function SceneBossRoom:onExit(element)
    WZLog("SceneBossRoom:onExit", tostring(g_bIsPushScene), tostring(g_bIsPopScene))
    if g_bIsPushScene == true then
        return
    end
    if self.m_root then 
        local conCenter = GetElement(self.m_root, "conCenter_SceneBossRoom", WZUIContainer)
        local conBg = GetElement(self.m_root, "conBg_SceneBossRoom", WZUIContainer)

        conBg:disableSchedule()
        conCenter:disableSchedule()
        for i = 1, 3 do
            local conSeat = GetElement(conCenter, "conSeat" .. i .. "_SceneBossRoom", WZUIContainer)
            conSeat:stopAllActions()
        end
    end
    -- FootEffectManager:removeEffect1(self.m_sRoleFootSpine)
    if self.m_sRoleFootSpine then
        self.m_sRoleFootSpine:removeFromParentAndCleanup(true)
        self.m_sRoleFootSpine = nil
    end
    self:exitRoom()
    self:quitVoice()
    --add by wuweidong
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","SceneBossRoom")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","SceneBossRoom")
    self.m_root:disableSchedule()     
    NotificationCenter:unregisterNotification(nil, self)     
    CacheCenter:unregisterUpateDecorationObserver(self)
    CacheCenter:unregisterUpatePlayerPetInfoObserver(self)
    CacheCenter:unregisterUpateDressSuitObserver(self)
    CacheCenter:unregisterUpateSkillSuitObserver(self)
    ProtocolProcessorSceneBossRoom:unregAll() --反注册协议
    self:_unInit()
    IPDConnector.g_nNetConnectFlag = NET_FLAG_2
    
end

function SceneBossRoom:onEnterTransitionDidFinish()
    g_nMyAssistState = 0
    popSceneEnd()
    --延时显示成就特效
    ShowDelayAchie()
    AdaptLanguage(self)
    self:adaptIphoneX()
    self:setSkillSuitName()
    self:_showInviteList()
end

--@brief    获得主角的座位
--@return   #1:位置
function SceneBossRoom:_getPlayerSeat()
    WZLog("SceneBossRoom:_getPlayerSeat")
    
    if self.m_tData == nil then
        WZLog("SceneBossRoom:_getPlayerSeat m_tData is nil.")
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
function SceneBossRoom:findPlayerSeatById(playerId)
    WZLog("SceneBossRoom:findPlayerSeatById ",playerId)
    if self.m_tData == nil or playerId == nil then
        WZLog("SceneBossRoom:_getPlayerSeat m_tData is nil.")
        return
    end
    
    for i,vId in ipairs(self.m_tData.playerId) do
        if vId == playerId then
            return i
        end
    end
    return 0
end

--@brief    更新玩家座位
function SceneBossRoom:updatePlayerSeat()
    WZLog("SceneBossRoom:updatePlayerSeat")
    local isVoice = self:checkVoiceChannelLv(self.m_tData.roomChannel)
    local playerSeatIndex = self:_getPlayerSeat()
    playerSeatIndex = playerSeatIndex + 1
    GlobalGame.g_nPlayerInTeam = -1
    local indexTag = 0
    local maxCount = 3
    local conCenter = GetElement(self.m_root,"conCenter_SceneBossRoom",WZUIContainer)

    for i= 1,maxCount do
        self:checkCellChatBubble(i)
        local conSeat = WZUIContainer:luaTo(conCenter:getChildElement("conSeat".. i .."_SceneBossRoom"))
        local btnPlayerFigure  = WZUIButton:luaTo(conSeat:getChildElement("btnPlayerFigure_SceneBossRoom"))
        local btnPlayerPet = GetElement(conSeat,"btnPlayerPet_SceneBossRoom",WZUIButton)

        local conWeapon= WZUIContainer:luaTo(conSeat:getChildElement("conWeapon_SceneBossRoom"))
        local imgWeaponIcon = WZUIImage:luaTo(conWeapon:getChildElement("imgWeaponIcon_SceneBossRoom"))
        imgWeaponIcon:setFile("")

        local btnWeapon = WZUIButton:luaTo(conWeapon:getChildElement("btnWeapon_SceneBossRoom"))
        btnWeapon:setTag(-1)

        local spWeapon1 = GetElement(conWeapon,"spWeapon_SceneBossRoom",WZUISpine)
        spWeapon1:setVisible(false)
        local playerId = self.m_tData.playerId[i]
        self:showPlayerFigureAndPet(i)

        local conFigure = GetElement(conSeat,"conFigureVoice_SceneBossRoom",WZUIContainer)
        local anim = GetElement(conSeat,"animFigureVoice_SceneBossRoom",WZUISpine)
        local img = GetElement(conSeat,"imgFigureVoice_SceneBossRoom",WZUIImage)

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

        local conSeatInfo = GetElement(conSeat,"conSeatInfo_SceneBossRoom",WZUIContainer)
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
            cellObj:setBGRectVisible(false)
        end
         
    end
    
    self:showCoupleAnimation()
end

--@brief    开始配对计时器
function SceneBossRoom:startPairTimer()
    WZLog("SceneBossRoom:startPairTimer")
    self.m_nPairRemainTime = 10
    local downTime = GetElement(self.m_root,"txtMakePairTime_SceneBossRoom",WZUILabelAtlasFont)
    downTime:setText(self.m_nPairRemainTime)
    --downTime:setVisible(true)
    downTime:enableSchedule("_schedulePairTimer",1)
    self.m_root:enableSchedule("_scheduleCheckRoomPlayer", 0)
end


--@brief    检查房间玩家计算器的回调函数
function SceneBossRoom:_scheduleCheckRoomPlayer()
    if (not self:_allPlayersReady()) then
        self.m_root:disableSchedule()
        self:endPairTimer()
    end
end

--@brief    关闭配对计时器
function SceneBossRoom:endPairTimer()
    WZLog("SceneBossRoom:endPairTimer")
    if self.m_root == nil then return end
    local downTime = GetElement(self.m_root,"txtMakePairTime_SceneBossRoom",WZUILabelAtlasFont)
    downTime:setVisible(false)
    downTime:disableSchedule()
end

--@brief    触摸函数，判断消息是否在消息框显示范围内，如果不是的话，就让消息框不显示，反之，显示
--@param #1 element:表绑定的UI节点引用
--@param #2 point:点击位置
function SceneBossRoom:onTouchBegan(element, point)
    WZLog("SceneBossRoom:onTouchBegan")
    if WndDressUp.m_root ~= nil and (not WndDressUp:checkPoint(point)) then
        WndDressUp:onCloseClick()
    end

    if self.m_tCellDressSuit and not self.m_tCellDressSuit:checkPointInBtn(point) then
        self.m_tCellDressSuit:hideSuitList()
    end

    local nodedd = self.m_root:getChildByTag(88)
    if nodedd then
        local pppp = nodedd:convertToNodeSpace(point)
        local conSize = nodedd:getContentSize()
        if self.m_root:getChildByTag(88) and pppp.x <= 0 or pppp.y <= 0 or pppp.x > conSize.width or pppp.y > conSize.height then 
            self.m_root:removeChildByTag(88, true) 
        end
    end

    local conDifSchedule = GetElement(self.m_root, "conDifSchedule_SceneBossRoom", WZUIContainer)
    if conDifSchedule:isVisible() and not self:checkPointInBtn(point) then 
        conDifSchedule:setVisible(false)
        GetElement(self.m_root, "imgDifArrow_SceneBossRoom", WZUIImage):setFlipY(false)
    end

    local conSelPlayerInfo = GetElement(self.m_root, "conSelPlayerInfo_SceneBossRoom", WZUIContainer)
    if conSelPlayerInfo and conSelPlayerInfo:isVisible() and not self:checkPointInBtnSelRect(point) then 
        conSelPlayerInfo:setVisible(false)
    end

    local conForRoomInvite = GetElement(self.m_root, "conForRoomInvite_SceneBossRoom", WZUIContainer)
    if conForRoomInvite:isVisible() then 
        if not self:checkInInviteList(point) then 
            self:hideInviteListCallBack()
        end
    end
end

--@brief    检测触摸是否在邀请列表内
function SceneBossRoom:checkInInviteList(pt)
    WZLog("SceneBossRoom:checkInInviteList")
    local btn = GetElement(self.m_root, "conForRoomInvite_SceneBossRoom", WZUIContainer)
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

--@BRIEF  检查触摸是否在框内
function SceneBossRoom:checkPointInBtn(pt)
    WZLog("SceneBossRoom:checkPoint")
    if self.m_root == nil then return end
    local btn = GetElement(self.m_root, "conDifSchedule_SceneBossRoom", WZUIContainer)
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("获得btn 世界坐标",ptA.x,ptA.y, ptA.x + btnSize.width, ptA.y + btnSize.height, pt.x, pt.y)
    WZLog("按钮大小",btnSize.width,btnSize.height)
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        WZLog("SceneBossRoom:checkPoint  true")
        return true
    else
        return false
    end 
end

--@BRIEF  检查触摸是否在框内
function SceneBossRoom:checkPointInBtnSelRect(pt)
    WZLog("SceneBossRoom:checkPoint")
    if self.m_root == nil then return end
    local btn = GetElement(self.m_root, "conSelPlayerInfo_SceneBossRoom", WZUIContainer)
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("获得btn 世界坐标",ptA.x,ptA.y, ptA.x + btnSize.width, ptA.y + btnSize.height, pt.x, pt.y)
    WZLog("按钮大小",btnSize.width,btnSize.height)
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        WZLog("SceneBossRoom:checkPoint  true")
        return true
    else
        return false
    end 
end

--@brief  显示宠物tip
function SceneBossRoom:onClickPet(element)
    WZLog("SceneBossRoom:onClickPet")
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


function SceneBossRoom:onClickWorldInvite(element)
    -- body
    WZLog("SceneBossRoom:onClickWorldInvite")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tData.roomPassword == "" or self.m_tData.roomPassword == nil then
        local mapName = GDatatab_team_map["id_" .. self.m_tData.mapId].map_name
        local sendTxt = string.format(LocalStrings.WORLD_TEAM_IV_TXT,mapName)
        local otherInfo ={}
        otherInfo.mapId = self.m_tData.mapId
        otherInfo.roomId = self.m_tData.roomId
        WndChat:sendChatByChannel(CHANNEL_COPY,sendTxt,otherInfo)
    else
        MsgBoxManager:showTipBox(LocalStrings.WORLD_TEAM_IV_ERROR)
    end
end

--@brief 查看玩家武器信息
function SceneBossRoom:onClickWeapon(element)
    WZLog("SceneBossRoom:onClickWeapon")
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
function SceneBossRoom:onClickSkill(element)
    -- body
    WZLog("SceneBossRoom:onClickSkill")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local seatI = self:_getPlayerSeat()
    if self.m_tData.playerReady[seatI + 1] and not self:getIsRoomOwner() then
        MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
        return
    end
    WndSkillContainer:showById(1)
end

--@brief    点击协助、可协助按钮回调
function SceneBossRoom:onClickBattleHelp(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local seatI = self:_getPlayerSeat()
    if self.m_tData.playerReady[seatI + 1] and not self:getIsRoomOwner() then
        MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
        return
    end
    --只有协助次数，没有挑战次数，不让切换
    local tMultiCopyData = CacheCenter:getMultiCopyData()
    local copyData = GDatatab_team_map["id_" .. self.m_tData.mapId]
    if (copyData.difficulty < 4 and tMultiCopyData[copyData.map_num].passTime >= copyData.challenge_num and self:getMyAssist() == 1) or copyData.difficulty == 4 and tMultiCopyData.awakeTimes > 0 and self:getMyAssist() == 1 then
        MsgBoxManager:showTipBox(LocalStrings.BATTLE_HELP_TEXT9)
        return 
    end

    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_Assist(self.m_tData.roomId)
end

--@brief    展示选中玩家的信息
function SceneBossRoom:showSelPlayerInfo(nPlayerSeat)
    -- body
    if self.m_root == nil then return end 

    GetElement(self.m_root, "conSelPlayerInfo_SceneBossRoom", WZUIContainer):setVisible(true)
    self.m_nSelVipLevel = self.m_tData.vipLevel[nPlayerSeat]
    self.m_nSelPlayerSeatIndex = nPlayerSeat

    local playerEquipment = {}
    for i=1,5 do
        playerEquipment[i]= self.m_tData.playerEquipment[(nPlayerSeat-1)*5+i]
    end
    WZLog("SceneBossRoom:showSelPlayerInfo", Serialize(playerEquipment), self.m_nSelPlayerSeatIndex)
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

    local conSelHead = GetElement(self.m_root, "conSelHead_SceneBossRoom", WZUIContainer)
    local txtSelName = GetElement(self.m_root, "txtSelName_SceneBossRoom", WZUILabelTTF)
    CellHead:show(conSelHead, headId, faceId, self.m_tData.playerSex[nPlayerSeat], nil, nil, self.m_tData.vipLevel[nPlayerSeat],  self.m_tData.headColors[nPlayerSeat])
    txtSelName:setText(self.m_tData.playerName[nPlayerSeat])
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置控件静态文本
--@note     设置控件静态文本
function SceneBossRoom:_setUIStaticText()
    --描边字
    WZLog("SceneBossRoom:_setUIStaticText")
   

end
--@brief    scene更新函数
--@note     实际上的初始化函数
function SceneBossRoom:_update()    
    WZLog("SceneBossRoom:_update")             
    if self.m_root == nil then
        WZLog("SceneBossRoom:_update m_root is nil.")
        return
    end

    if self.m_tData == nil then
        WZLog("SceneBossRoom:_update m_tData is nil.")
        return
    end

    if self.m_sRoleFootSpine then
        self.m_sRoleFootSpine:removeFromParentAndCleanup(true)
        self.m_sRoleFootSpine = nil
    end
    --显示房间基本信息
    self:updateMiddleInfo()

    --更新玩家座位
    self:updatePlayerSeat()

    self:updateReaderBtn()

    if WindowManager:getSceneRoot():getName() == "WndFriendList" then
       WndFriendList:setInviteFriendIds(self.m_tData.playerId)
    end
    WndFriendList:setInviteFriendIds(self.m_tData.playerId)
    Teach:isStartTeach("SceneBossRoom:_update")

    self:updateRoomInviteTip()
    
    local tCopyData = GDatatab_team_map["id_"..self.m_tData.mapId]
     -- 更新难度
    self.checkTag = tCopyData.difficulty
    self:_setDifCheckBox()

    self:_shieldClick()

    self:_setBtnBattleHelpVisible()
    --self:_exitRoomByAssitOnly() 
    --套装
    self:_addDressSuit()
end

--显示娱乐赛信息
function SceneBossRoom:updateRoomInviteTip()
    WZLog("SceneBossRoom:updateRoomInviteTip")
    if self.m_tData == nil then return end
    
    if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then -- 排位赛
        self.m_tTopHangle:setTitleFile("ui/common/common_icon_pwss.png")
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
    elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then  --练习赛
        self.m_tTopHangle:setTitleFile("ui/common/common_icon_lxs.png")
    elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZF then --组队副本
        self.m_tTopHangle:setTitleFile("ui/common/common_icon_zdfb.png")
    else -- 对战赛
        self.m_tTopHangle:setTitleFile("ui/common/common_icon_dzs2.png")
    end
end

--@brief    配对计算器的回调函数
function SceneBossRoom:_schedulePairTimer()
    if self.m_nPairRemainTime > 0 then
        self.m_nPairRemainTime = self.m_nPairRemainTime - 1
        WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"txtMakePairTime_SceneBossRoom")):setText(self.m_nPairRemainTime)
    else
        WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"txtMakePairTime_SceneBossRoom")):setVisible(false)
    end
end

--@brief  更新房间基本信息
function SceneBossRoom:updateMiddleInfo()
    WZLog("SceneBossRoom:updateMiddleInfo")

    local conTop = GetElement(self.m_root,"conTop_SceneBossRoom",WZUIContainer)

    local roomName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtRoomName_SceneBossRoom"))
    roomName:setText(self.m_tData.roomId .. " " .. self.m_tData.roomName)

    local roomId = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtRoomId_SceneBossRoom"))
    roomId:setText("")
    GetElement(self.m_root, "conID_SceneBossRoom", WZUIContainer):setVisible(false)

    local roomPass = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtRoomPass_SceneBossRoom"))
    if self.m_tData.passWord == "-1" or self.m_tData.passWord == "" then
        roomPass:setText(LocalStrings.NONE)
    else
        roomPass:setText(self.m_tData.passWord)
    end
    
    local mapImage = WZUIImage:luaTo(self.m_root:getChildElement("imgMapBg_SceneBossRoom"))
    local imgChangeRoomInfo = WZUIImage:luaTo(self.m_root:getChildElement("imgChangeRoomInfo_SceneBossRoom"))
    mapImage:setFile(self:_getMapBgById())
    imgChangeRoomInfo:setVisible(false)

    local tempTitle = self:_getMapTitleById()
    if self.m_tData.roomAssist == 1 then 
        tempTitle = tempTitle .. LocalStrings.BATTLE_HELP_TEXT10
    end
    GetElement(self.m_root,"txtMapTitle_SceneBossRoom",WZUILabelTTF):setText(tempTitle)

    if self:getIsRoomOwner() then
       imgChangeRoomInfo:setVisible(true)
    end
end

--@brief  更新开始游戏按钮状态
function SceneBossRoom:updateReaderBtn()
    WZLog("SceneBossRoom:updateReaderBtn()")
    local imgStartGame = WZUIImage:luaTo(self.m_root:getChildElement("imgStartGame_SceneBossRoom"))
    
    if self:getIsRoomOwner() then
        imgStartGame:setFile("ui/common/common_icon_ksyx.png")
    else
        for i,v in ipairs(self.m_tData.playerId) do
            if v == GlobalGame.g_tPlayerInfo.nPlayerId then
                if self.m_tData.playerReady[i] then
                    imgStartGame:setFile("ui/common/common_icon_qxzb.png")
                else
                    imgStartGame:setFile("ui/common/common_icon_zhunbei2.png")
                end
                return
            end
        end
    end
end

--@brief    根据id返回地图背景图
--@param    mapId:地图id
--@return   #1:地图背景图string
function SceneBossRoom:_getMapBgById()
    WZLog("SceneBossRoom:_getMapBgById")
    local roomData = self.m_tData
    local tCopyData = GDatatab_team_map["id_"..roomData.mapId]
    return tCopyData.mini_map
end

--@brief    根据id返回地图标题图
--@param    mapId:地图id
--@return   #1:地图标题图string
function SceneBossRoom:_getMapTitleById()
    WZLog("SceneBossRoom:_getMapTitleById")
    local roomData = self.m_tData
    local tCopyData = GDatatab_team_map["id_"..roomData.mapId]
    return tCopyData.map_name
end

function SceneBossRoom:_getPlayerNum()
    local num = 0
    for i=1 , #self.m_tData.playerId do
        if self.m_tData.playerId[i] > 0 then num = num + 1 end
    end
    return num
end

--@brief  获取空位数量
function SceneBossRoom:getAllNULLSeat()
    WZLog("SceneBossRoom:getAllNULLSeat")
    local count = 0
    for i,v in ipairs(self.m_tData.playerId) do
        if v <=0 then
            count = count + 1
        end
    end
    return count
end

--@brief  判断是否有空位
function SceneBossRoom:hasNullSeat()
    for i,v in ipairs(self.m_tData.playerId) do
        if v <=0 and self.m_tData.seatUsed[i] then
            return true
        end
    end
    return false
end

--@brief    是否为房主
--@return   #1:true:是,false:否
function SceneBossRoom:getIsRoomOwner()
    WZLog("SceneBossRoom:getIsRoomOwner")
    if self.m_tData == nil then
        WZLog("SceneBossRoom:getIsRoomOwner m_tData is nil.")
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
function SceneBossRoom:_isSeatUsed(index)
    if self.m_tData == nil then 
        WZLog("SceneBossRoom:_isSeatUsed  m_tData is nil ")
        return
    end 
    if self.m_tData.playerId[ index ] > 0 then
        return true     
    end 
    return false
end

--@brief  更新座位信息
function SceneBossRoom:_updateSeatInfo(luaObject,elementObject,index,bgType,isused)
    WZLog("SceneBossRoom:_updateSeatInfo ",index)
    if luaObject ~= nil then
        luaObject:setBgType(bgType)
        local conCenter = GetElement(self.m_root,"conCenter_SceneBossRoom",WZUIContainer)
        local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneBossRoom",WZUIContainer)
        local imgPlayerStats = WZUIImage:luaTo(conSeat:getChildElement("imgPlayerStatus_SceneBossRoom"))
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
        luaObject:setData(curD.wnersId,curD.seatUsed[index],curD.playerId[index],curD.playerName[index],curD.playerLevel[index],curD.playerReady[index],curD.playerSex[index],curD.vipLevel[index],curD.playerTitle[index],curD.fighting[index],curD.playerNumMode,index,-1,curD.battleMode,0,curD.seatUsed,curD.serviceId[index],curD.roomChannel,0,0,0,curD.winTimes[index],curD.joinTimes[index],curD.continuousWinTimes[index],curD.matchscore[index],curD.qualifyingLevel[index],curD.assist[index], curD.assistTimesState[index], curD.professionId[index], curD.openStatus[index])
        luaObject:setSeatInfo(self.m_tData.seatUsed)
        local friendInfo = self:getFriendRV(self.m_tData.playerId[index])
        luaObject:setFriendInfo(friendInfo)

        local masterInfo = self:getMasterRV(self.m_tData.playerId[index],self.m_tData.playerLevel[index])
        luaObject:setMasterInfo(masterInfo)
        luaObject:setBGRectVisible(false)

        local spouseValue,spuseLevel,wifeName,husbandName = self:getSpouseRV(self.m_tData.playerId[index],self.m_tData.playerSex[index],self.m_tData.playerName[index])
        luaObject:setSpouseInfo(spouseValue,spuseLevel,wifeName,husbandName)

        luaObject:_update()
        luaObject:setBGRectVisible(false)
    end
end

--@brief    创建一个玩家座位
--@param    index:cell的识别
--@param    bgType:背景类型(1:红色,2:蓝色)
--@param    isused:座位是否关闭
--@return   #1:element的引用
--@return   #2:表的引用
function SceneBossRoom:_createASeat(index,bgType,isused)
    WZLog("SceneBossRoom:_createASeat",index,bgType,isused)
    local tagType = 1
    local conCenter = GetElement(self.m_root,"conCenter_SceneBossRoom",WZUIContainer)

    local cellElement,cellObj = CellRoomSeat:createElement(tagType)
    cellElement:setTag(index)
    cellObj:setBgType(bgType)
    
    local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneBossRoom")
    local imgPlayerStats = GetElement(conSeat,"imgPlayerStatus_SceneBossRoom",WZUIImage)
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
    cellObj:setData(curD.wnersId,curD.seatUsed[index],curD.playerId[index],curD.playerName[index],curD.playerLevel[index],curD.playerReady[index],curD.playerSex[index],curD.vipLevel[index],curD.playerTitle[index],curD.fighting[index],curD.playerNumMode,index,-1,curD.battleMode,0,curD.seatUsed,curD.serviceId[index],curD.roomChannel,0,0,0,curD.winTimes[index],curD.joinTimes[index],curD.continuousWinTimes[index],curD.matchscore[index],curD.qualifyingLevel[index],curD.assist[index], curD.assistTimesState[index], curD.professionId[index], curD.openStatus[index])
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
function SceneBossRoom:showPlayerFigureAndPet(index)
    WZLog("SceneBossRoom:showPlayerFigureAndPet")
    local playerEquipment = {}
    for i=1,5 do
        playerEquipment[i]= self.m_tData.playerEquipment[(index-1)*5+i]
    end
    local conCenter = GetElement(self.m_root,"conCenter_SceneBossRoom",WZUIContainer)
   
    if self.m_tData.seatUsed[index] and self.m_tData.playerId[index] > 0  then
        local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneBossRoom",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_SceneBossRoom",WZUIContainer)
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
        playerFigure, _, _, showMonster = self:createAPlayer(self.m_tData.playerSex[index],playerEquipment,self.m_tData.headColors[index],self.m_tData.bodyColors[index],animAtionName)
        playerFigure:getAnimNode():setTag(playerId)
        if mountId > 0 and not showMonster then 
            local basicInfo = GDatatab_item["id_" .. GDatatab_mounts["id_" .. mountId].item_id]
            playerFigure:setMount(basicInfo.animation_index_code)
            scalePlayer = 0.6
        end
        playerFigure:setScale(scalePlayer)
        local playerAnimNode = playerFigure:getAnimNode()
        if tTempList and tTempList[6] == true then 
            playerFigure:setScaleX(-1 * scalePlayer)
        else
            playerFigure:setScaleX(scalePlayer)
        end
        conPlayer:addChild(playerAnimNode)
        local countDown = 1.5
        --[5]是否跑动，[6]翻转
        local playerInfo  = {playerFigure, playerId, index, countDown, false, false}
        if tTempList then 
            playerInfo  = {playerFigure, playerId, index, countDown, tTempList[5], tTempList[6]}
        end
        table.insert(self.m_tScheduleList, playerInfo)
        
        local conPet = GetElement(conSeat,"conPet_SceneBossRoom",WZUIContainer)
        local btnPlayerPet = GetElement(conSeat,"btnPlayerPet_SceneBossRoom", WZUIButton)
        
        local petInfo = self.m_tPlayersPetInfo[index]
        conPet:setRelativePosition(GlobalMethod:ccp(0.207,0.59))
        btnPlayerPet:setRelativePosition(GlobalMethod:ccp(0.207,0.59))
        if tTempList and tTempList[6] == true then 
            conPet:setRelativePosition(GlobalMethod:ccp(0.794,0.59))
            btnPlayerPet:setRelativePosition(GlobalMethod:ccp(0.794,0.59))
        end
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
                if tTempList and tTempList[6] == true then 
                    petAnimation:getAnimNode():setScaleX(-0.65)
                end
                if par then par:setScale(0.65) end
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
        local conForNameAndTitle = GetElement(conSeat, "conForNameAndTitle_SceneBossRoom", WZUIContainer)
        if conForNameAndTitle then
            local txtPlayerName = GetElement(conSeat, "txtPlayerName_SceneBossRoom", WZUILabelTTF)
            local txtAssistWord = GetElement(conSeat, "txtAssistWord_SceneBossRoom", WZUILabelTTF)
            txtPlayerName:setText(self.m_tData.playerName[index])
            txtAssistWord:setText("")
            if self.m_tData.assist and self.m_tData.assist[index] == 1 then 
                txtAssistWord:setText("(" .. LocalStrings.BATTLE_HELP_TEXT5 .. ")")
            end
            local txtPlayerLv = GetElement(conSeat, "txtPlayerLv_SceneBossRoom", WZUILabelTTF)
            txtPlayerLv:setText("Lv" .. self.m_tData.playerLevel[index])
            if playerId == CacheCenter:getPlayerInfo().id then
                txtPlayerName:setColor(GlobalMethod:ccc3(99,255,95))
            else
                txtPlayerName:setColor(GlobalMethod:ccc3(255,255,255))
            end
            local conTitle = GetElement(conSeat, "conTitle_SceneBossRoom", WZUIContainer)
            local txtPlayerTitle = GetElement(conSeat, "txtPlayerTitle_SceneBossRoom", WZUILabelTTF)
            local tempPoint = GlobalMethod:ccp(0.5, 1.9)
            if self.m_tData.playerTitle[index] and self.m_tData.playerTitle[index] ~= "" then
                CreateDesiSpine(conTitle, txtPlayerTitle, self.m_tData.playerTitle[index], tempPoint, nil, 0.9)
            end
        end
        if playerId == CacheCenter:getPlayerInfo().id then
            self:showRoleFootEffect(conPlayer, playerFigure)
        end
    else
        local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneBossRoom",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_SceneBossRoom",WZUIContainer)
        local conPet = GetElement(conSeat,"conPet_SceneBossRoom",WZUIContainer)
        local btnPlayerPet = GetElement(conSeat,"btnPlayerPet_SceneBossRoom", WZUIButton)
        local txtPlayerName = GetElement(conSeat, "txtPlayerName_SceneBossRoom", WZUILabelTTF)
        local txtPlayerLv = GetElement(conSeat, "txtPlayerLv_SceneBossRoom", WZUILabelTTF)
        local txtPlayerTitle = GetElement(conSeat, "txtPlayerTitle_SceneBossRoom", WZUILabelTTF)
        local conTitle = GetElement(conSeat, "conTitle_SceneBossRoom", WZUIContainer)
        local txtAssistWord = GetElement(conSeat, "txtAssistWord_SceneBossRoom", WZUILabelTTF)
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
        if txtAssistWord then 
            txtAssistWord:setText("")
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

--@brief    创建一个角色动画
function SceneBossRoom:createAPlayer(playerSex,equipment,headColor,bodyColor,animName)
    WZLog("SceneBossRoom:createAPlayer")
    return CreatePlayerFigure(playerSex,equipment,animName,nil,nil,nil,nil,nil,nil,nil,headColor,bodyColor)
end
--@brief 显示足迹
function SceneBossRoom:showRoleFootEffect(conP, conPlayer)
    local footId = CacheCenter:getUsingFootMarkId()
    if footId == nil then return end
    if not self.m_sRoleFootSpine then
        self.m_sRoleFootSpine = FootEffectManager:addEffect1(conP, footId, conPlayer:getPosition(),true,20,nil,nil,-100)
    end
end
--@breif  更新玩家的动作
function SceneBossRoom:updatePlayerAnimation(element,delta)
    local isPlayRelax = false
    local countPlayer = #self.m_tScheduleList
    for i=1,countPlayer do
        local randomCount = math.random(5,14)
        if self.m_tScheduleList[i][5] == false then 
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
                    local conSeat = GetElement(self.m_root, "conSeat" .. self.m_tScheduleList[i][3] .. "_SceneBossRoom", WZUIContainer)
                    local conCenter = GetElement(self.m_root, "conCenter_SceneBossRoom", WZUIContainer)
                    local conSize = conCenter:getAbsContentSize()
                    local posCur = conSeat:getRelativePosition()
                    actionName, mountId = self:getPlayerAction(1, self.m_tScheduleList[i][3])
                    self.m_tScheduleList[i][1]:play(actionName, true)

                    local randomX = math.random(1,100)
                    local moveTo = WZUIActionMoveTo:create()
                    moveTo:setMoveX(randomX/100)
                    local conPet = GetElement(conSeat, "conPet_SceneBossRoom", WZUIContainer)
                    local btnPlayerPet = GetElement(conSeat, "btnPlayerPet_SceneBossRoom", WZUIButton)
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

                    local randomY = math.random(80,125)
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
function SceneBossRoom:actionFinishRemove(element)
    --body
    local nTag = element:getTag()
    local countPlayer = #SceneBossRoom.m_tScheduleList
    for i = 1, countPlayer do
        if SceneBossRoom.m_tScheduleList[i][3] == nTag then
            SceneBossRoom.m_tScheduleList[i][5] = false
            SceneBossRoom.m_tScheduleList[i][4] = 1.5
            local actionName, mountId = self:getPlayerAction(0, self.m_tScheduleList[i][3])
            SceneBossRoom.m_tScheduleList[i][1]:play(actionName, true)
            break 
        end
    end
end

--@brief    刷新玩家的层级
function SceneBossRoom:updatePlayerZOrder(element, delta)
    -- body
    local countPlayer = #self.m_tScheduleList
    for i=1,countPlayer do
        local conSeat = GetElement(self.m_root, "conSeat" .. self.m_tScheduleList[i][3] .. "_SceneBossRoom", WZUIContainer)
        local posCur = conSeat:getRelativePosition()

        conSeat:setZOrder(math.ceil(150 - posCur.y * 100))
    end
end

--@brief    添加时装套装入口
function SceneBossRoom:_addDressSuit()
    -- body
    if CheckButtonOpen(144, false) then
        local conForDressSuit = GetElement(self.m_root, "conFassion_SceneBossRoom", WZUIContainer)
        if conForDressSuit:getChildByTag(999) then 
            conForDressSuit:removeChildByTag(999, true)
        end
        if conForDressSuit then
            local wndDress, tCell = WndDressSuit:createElement()
            if wndDress and tCell then
                tCell:setType(4)
                self.m_tCellDressSuit = tCell
                wndDress:setTag(999)
                wndDress:setRelativePosition(GlobalMethod:ccp(0.5,0.05))
                conForDressSuit:addChild(wndDress)
            end
        end
    end
end

--@brief    点击时装按钮回调
function SceneBossRoom:onClickFashion(element)
    --body
    if CheckButtonOpen(144) then
        if self.m_tCellDressSuit then 
            self.m_tCellDressSuit:onClickShow(element)
        end
    end
end

--@brief    点击模式按钮回调
function SceneBossRoom:onClickDif(element)
    --body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- 只有房主才能选难度
    if (not self:getIsRoomOwner()) then
        MsgBoxManager:showTipBox(LocalStrings.ONLY_ROOMOWNER_CAN_SELECT)
        return
    end

    local conDifSchedule = GetElement(self.m_root, "conDifSchedule_SceneBossRoom", WZUIContainer)
    local bVisible = conDifSchedule:isVisible()
    conDifSchedule:setVisible(not bVisible)
    GetElement(self.m_root, "imgDifArrow_SceneBossRoom", WZUIImage):setFlipY(not bVisible)
end

--@brief    点击踢出房间按钮回调
function SceneBossRoom:onClickOutSel(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local bMatching = SceneBossRoom:getClickSeat()
    if bMatching == false then
        MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
        return 
    end
    ProtocolProcessorSceneRoom:send_ROOM_QuitRoom(self.m_tData.roomId, self.m_nSelPlayerSeatIndex - 1)
    GetElement(self.m_root, "conSelPlayerInfo_SceneBossRoom", WZUIContainer):setVisible(false)
end

--@brief    点击查看按钮回调
function SceneBossRoom:onCheckSel(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    local tag = self.m_nSelPlayerSeatIndex
    if self.m_tData.playerId[tag] then
        WndCheckOther:show(self.m_tData.playerId[tag])
    end
end

--@brief    点击展示邀请列表
function SceneBossRoom:onClickShowInvite(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    element:setVisible(false)
    self.m_tTopHangle:setWifiSignalVisible(false)
    self.m_tTopHangle:setBottomBarVisible(false)
    GetElement(self.m_root, "conForRoomInvite_SceneBossRoom", WZUIContainer):setVisible(true)
end

--@brief    隐藏邀请列表回调
function SceneBossRoom:hideInviteListCallBack()
    -- body
    GetElement(self.m_root, "conForRoomInvite_SceneBossRoom", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "btnShowInvite_SceneBossRoom", WZUIButton):setVisible(true)
    self.m_tTopHangle:setWifiSignalVisible(true)
    self.m_tTopHangle:setBottomBarVisible(true)
end
-------------------------------------回调方法模块Begin----------------------------------------

-- 点击修改副本信息按钮时的回调
function SceneBossRoom:onChangeInfo(element)
    -- 只有房主才能修改信息
    if (not self:getIsRoomOwner()) then return  end

    WZLog("SceneBossRoom:onChangeInfo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndBossRoomSetting:showInterface()
    WndBossRoomSetting:initRoomInfo(self.m_tData.roomName, self.m_tData.passWord)
    WndBossRoomSetting:setBackButtonCallback(self, self.changeInfoCallback)
end

-- 修改副本信息确认回调
function SceneBossRoom:changeInfoCallback(sRoomName, sRoomPass)
    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateRoom(self.m_tData.roomId, self.m_tData.playerNumMode, sRoomPass, self.m_tData.mapId, self.m_tData.wnersId, sRoomName)
end

--@brief  邀请玩家
function SceneBossRoom:onClickInvPlayer(element)
    WZLog("SceneBossRoom:onClickInvPlayer")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self:hasNullSeat() then
        MsgBoxManager:showTipBox(LocalStrings.HALL_NO_SEAT)
        return
    end

    WndFriendList:showInterface(6,self,self.inviteFriend)
end

--奖励预览
function SceneBossRoom:onClickPrize(element)
    -- body
    WZLog("SceneBossRoom:onClickPrize ")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local roomData = self.m_tData
    local tCopyData = GDatatab_team_map["id_"..roomData.mapId]

    local tDropData = tCopyData.reward_boy[1]
    if CacheCenter:getPlayerInfo().sex == 1 then tDropData = tCopyData.reward_girl[1] end
    if tDropData then
        local cell, tcell = CellTowerRewardTip:createElement()
        tcell:setTip(LocalStrings.REWARD_DESC)
        tcell:setData(tDropData)
        tcell:setShowByTower(false)
        cell:setShowAll(true)
        self.m_root:addChild(cell,5,88)
        
        local pooo  = GlobalMethod:ccp(element:getPositionX(),element:getPositionY())
        local ssss = element:convertToWorldSpace(pooo)
        cell:setPositionX(ssss.x-150)
        cell:setPositionY(ssss.y-100)
    end
end

--@brief    添加邀请列表
function SceneBossRoom:_showInviteList()
    -- body
    local conForRoomInvite = GetElement(self.m_root, "conForRoomInvite_SceneBossRoom", WZUIContainer)
    conForRoomInvite:setVisible(true)
    self.m_tTopHangle:setWifiSignalVisible(false)
    self.m_tTopHangle:setBottomBarVisible(false)
    
    WndRoomInviteList:showInterface(6, self, self.inviteFriend, nil, conForRoomInvite)

    local isEndTeach, teachStep = TeachGroup1:isTeachFinish(15)

    if isEndTeach ~= true then
        self:hideInviteListCallBack()
    end
end


-- 难度选择
function SceneBossRoom:onCheckBoxDifficult(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    self:changeDifficult(tag)
    self:_setDifCheckBox()

    GetElement(self.m_root, "conDifSchedule_SceneBossRoom", WZUIContainer):setVisible(false)
end

-- 获取玩家数据在数据列表里面的下标
function SceneBossRoom:_getPlayerDataIndex()
    local playInfo = CacheCenter:getPlayerInfo()
    for i=1, #self.m_tData.playerId do
        if self.m_tData.playerId[i] == playInfo.id then
            return i
        end
    end
end

-- 设置选择难度的checkbox
function SceneBossRoom:_setDifCheckBox()
    WZLog("SceneBossRoom:_setDifCheckBox =",self.checkTag)
    local conTop = GetElement(self.m_root,"conTop_SceneBossRoom",WZUIContainer)
    local checkDif = GetElement(conTop,"checkDif_SceneBossRoom",WZUIContainer)
    for i = 1, 4 do
        local state = self.checkTag == i and 1 or 0
        local check = WZUICheckBox:luaTo(WZUIElement:luaTo(checkDif:getChildByTag(i)))
        check:setCheckIndex(state)
    end
    --难度图标
    local tIconFile = {"ui/copy/copy_icon_jd1.png", "ui/copy/copy_icon_kn1.png", "ui/copy/copy_icon_dy1.png", "ui/copy/copy_icon_jx1.png"}
    local tDifName = {LocalStrings.COMMON, LocalStrings.DIFFICULTY, LocalStrings.HELL, LocalStrings.MULCOPY_TEXT2}
    local imgDifIcon = GetElement(self.m_root, "imgDifIcon_SceneBossRoom", WZUIImage)
    if imgDifIcon then 
        imgDifIcon:setFile(tIconFile[self.checkTag])
    end
    --
    local txtDifWord = GetElement(self.m_root, "txtDifWord_SceneBossRoom", WZUILabelTTF)
    if txtDifWord then 
        txtDifWord:setText(tDifName[self.checkTag])
        if ProjConfig.LANGUAGE == "vn" then
            txtDifWord:setScale(0.8)
        end
    end
end

-- 切换难度
-- 1. 只有房主才能切换难度
-- 2. 只有当前玩家都符合该难度时才能切换
function SceneBossRoom:changeDifficult(nDifficult)
    WZLog("SceneBossRoom:changeDifficult", nDifficult)
    -- 只有房主才能选难度
    if (not self:getIsRoomOwner()) then
        MsgBoxManager:showTipBox(LocalStrings.ONLY_ROOMOWNER_CAN_SELECT)
        return
    end

    -- 避免重复点击
    local nCurDifficult = self:_getDifficult()
    if nDifficult == nCurDifficult then  return end
    
    --检查房主星级
    local selfIndex = self:_getPlayerDataIndex()
    WZLog("SceneBossRoom:changeDifficult 000", self.m_tData.playerStar[selfIndex])
    if nDifficult-1 > self.m_tData.playerStar[selfIndex] then
        if nDifficult == 2 then
            MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_SWITCH_DIFFICULTY_TIPS1)
        elseif nDifficult == 3 then
            MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_SWITCH_DIFFICULTY_TIPS2)
        elseif nDifficult == 4 then 
            MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_SWITCH_DIFFICULTY_TIPS4)
        end
        return
    end
    
    local tMultiCopyData = CacheCenter:getMultiCopyData()
    if nDifficult == 4 and tMultiCopyData.awakeTimes > 0 then 
        MsgBoxManager:showTipBox(LocalStrings.MULCOPY_TEXT4)
        return 
    end
    --检查所有玩家星级
    for i=1, #self.m_tData.playerStar do
        if nDifficult-1 > self.m_tData.playerStar[i] and self.m_tData.playerId[i] > 0 then
            MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_SWITCH_DIFFICULTY_TIPS3)
            return
        end
    end
    if nDifficult == 4 then 
        local bCanChallenge = true
        local configData = GDatatab_team_map["id_" .. tMultiCopyData.awakeMapId]
        for i = 1, #self.m_tData.topMapId do
            if self.m_tData.playerId[i] > 0 then 
                if self.m_tData.playerLevel[i] < configData.map_level then 
                    bCanChallenge = false
                    break 
                end
            end
        end
        if not bCanChallenge then 
            MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_SWITCH_DIFFICULTY_TIPS3)
            return 
        end
    end
    WZLog("SceneBossRoom:changeDifficult 111", self.m_tData.playerStar[selfIndex])

    self.checkTag = nDifficult
    local nMapId = self:_getMapIdByDifficult(nDifficult)
    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateRoom(
        self.m_tData.roomId,
        self.m_tData.playerNumMode,
        self.m_tData.passWord,
        nMapId,
        self.m_tData.wnersId,
        self.m_tData.roomName)
end

-- 邀请界面点击邀请回调
function SceneBossRoom:inviteFriend(tFriend,selectIndex,bAssistFight,_type)
    --音效
    if _type and _type == 6 then
        ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_Invite(self.m_tData.roomId,tFriend.id,1)
    else
        ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_Invite(self.m_tData.roomId,tFriend.id)
    end
end


--@brief    点击CellRoomSeat回调
function SceneBossRoom:onClickCellRoomSeat(element)
    WZLog("SceneBossRoom:onClickCellRoomSeat")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    self:_showPlayerInfo(tag)
end

--@brief    显示玩家信息
--@param    nPlayerSeat：玩家座位号
function SceneBossRoom:_showPlayerInfo(nPlayerSeat)
    if self.m_tData.playerId[nPlayerSeat] then
        if self:getIsRoomOwner() and self.m_tData.playerId[nPlayerSeat] ~= CacheCenter:getPlayerInfo().id then 
            self:showSelPlayerInfo(nPlayerSeat)
        else
            WndCheckOther:show(self.m_tData.playerId[nPlayerSeat])
        end
    end
end


--brief    开始游戏按钮回调
function SceneBossRoom:onStartGameButtonClick(element)
    WZLog("SceneBossRoom:onStartGameButtonClick")
    --音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    CacheCenter.m_nPlayerLevel = CacheCenter:getPlayerInfo().level
    
    if self.click == true then return end
    local btnReadyGame_SceneBossRoom = GetElement(self.m_root,"btnReadyGame_SceneBossRoom",WZUIButton)
    btnReadyGame_SceneBossRoom:enableSchedule("startFinish", 1.5)
    self.click = true

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

    TeachGroup1:endTeachStep({15,4})
end

function SceneBossRoom:startFinish()
    local btnReadyGame_SceneBossRoom = GetElement(self.m_root,"btnReadyGame_SceneBossRoom",WZUIButton)
    btnReadyGame_SceneBossRoom:disableSchedule()
    self.click = false
end

--brief    是否所有玩家已准备
--@return  #1: true:是, false：否
function SceneBossRoom:_allPlayersReady()
    for i=1, self.m_tData.playerNum do
        if self.m_tData.playerId[i] > 0  and not self.m_tData.playerReady[i] then
            return false
        end
    end
    return true
end

function SceneBossRoom:_updateCheckPlayerState(element,dt)
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


------语音聊天
--@brief    加入语音聊天室
function SceneBossRoom:joinVoice()
    if self.m_bIsTryJoinVoice ~= true then
        GlobalGame.m_sVoiceRoomName = "room_" .. self.m_tData.roomChannel .. "_" .. self.m_tData.battleMode .. "_" .. self.m_tData.roomId
        local isOk =  WGCloudVoiceNotify:JoinTeamRoom(GlobalGame.m_sVoiceRoomName)
        WZLog("SceneBossRoom:joinVoice", GlobalGame.m_sVoiceRoomName, isOk, type(isOk))
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
function SceneBossRoom:quitVoice()
    WZLog("SceneBossRoom:quitVoice", GlobalGame.m_sVoiceRoomName)
    if GlobalGame.m_sVoiceRoomName == nil then return end
    WGCloudVoiceNotify:QuitRoom(GlobalGame.m_sVoiceRoomName)
    GlobalGame.m_sVoiceRoomName = nil
    GlobalGame.m_nVoiceId = nil
end

--@brief    语音聊天室成员状态回调
--0 停止说话
--1 开始说话
--2 继续说话
function SceneBossRoom:voiceMemberState(state)
    WZLog("SceneBossRoom:voiceMemberState one", Serialize(state))
    local index = -1
    for j=1,state.count do
        for i,v in pairs(self.m_tVoiceId) do
            local offset = (j-1) * 2
            WZLog("SceneBossRoom:voiceMemberState two-0", j, i, offset)
            if v == state.members[1 + offset] then
                index = i
                WZLog("SceneBossRoom:voiceMemberState three", state.members[2 + offset])

                if SceneBossRoom.m_tMicState[index] == 1 then
                    local conCenter = GetElement(self.m_root,"conCenter_SceneBossRoom",WZUIContainer)
                    
                    local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneBossRoom",WZUIContainer)
                    local anim = GetElement(conSeat,"animFigureVoice_SceneBossRoom",WZUISpine)
                    local img = GetElement(conSeat,"imgFigureVoice_SceneBossRoom",WZUIImage)
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
function SceneBossRoom:openVoiceTimer()
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
function SceneBossRoom:closeVoiceTimer()
    self.m_nVoiceTimer = 0
end

--@brief    听筒按钮点击后的Lua回调
function SceneBossRoom:onClickSpeaker(sender, state, isNoSend)
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
        GetElement(self.m_root,"imgSpeaker1_SceneBossRoom",WZUIImage):setGrayRender(false)
        GetElement(self.m_root,"imgSpeaker2_SceneBossRoom",WZUIImage):setGrayRender(false)
    else
        WGCloudVoiceNotify:CloseSpeaker()
        GetElement(self.m_root,"imgSpeaker1_SceneBossRoom",WZUIImage):setGrayRender(true)
        GetElement(self.m_root,"imgSpeaker2_SceneBossRoom",WZUIImage):setGrayRender(true)
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

function SceneBossRoom:onClickSpeakerCall(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        local data = WZDataFile:getInstance():getUserData()
        if data then        
            data:setStringValue("TalkData", "playTalk", "0")
            data:flush()
        end
        self:onClickSpeaker(true)
    end
end

function SceneBossRoom:onClickMicCall(nId, nResType)
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
function SceneBossRoom:onClickMic(sender, state, isNoSend)
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
        GetElement(self.m_root,"imgMic1_SceneBossRoom",WZUIImage):setGrayRender(false)
        GetElement(self.m_root,"imgMic2_SceneBossRoom",WZUIImage):setGrayRender(false)
    else
        WGCloudVoiceNotify:CloseMic()
        GetElement(self.m_root,"imgMic1_SceneBossRoom",WZUIImage):setGrayRender(true)
        GetElement(self.m_root,"imgMic2_SceneBossRoom",WZUIImage):setGrayRender(true)
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
function SceneBossRoom:checkVoice()
    local isVoice = false
    WZLog("SceneBossRoom:checkVoice", self.m_tData.roomChannel)
    if self:checkVoiceChannelLv(self.m_tData.roomChannel) then
        isVoice = true
    end
    self.m_bIsVoice = isVoice

    if isVoice then
        self.m_tVoiceId = {}
        self.m_tVoiceState = {}
        self.m_tMicState = {}
    else
        GetElement(self.m_root,"btnSpeaker_SceneBossRoom",WZUIButton):setVisible(false)
        GetElement(self.m_root,"btnMic_SceneBossRoom",WZUIButton):setVisible(false)
    end
end

--@brief    检查语音渠道和等级
function SceneBossRoom:checkVoiceChannelLv(channel)
    local isShow = false
    local battleMode = self.m_tData.battleMode
    WZLog("SceneBossRoom:checkVoiceChannelLv", channel, battleMode, CheckTalkButtonShow(12))
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

--@brief    设置协助按钮的可见与否
function SceneBossRoom:_setBtnBattleHelpVisible()
    -- body
    local tMultiCopyData = CacheCenter:getMultiCopyData()
    if tMultiCopyData == nil then return end 

    local btnBattleHelp = GetElement(self.m_root, "btnBattleHelp_SceneBossRoom", WZUIButton)
    if self:getIsRoomOwner() then
        btnBattleHelp:setVisible(false)
    else
        local nStarNum = 0
        local tempCopyData = GDatatab_team_map["id_" .. self.m_tData.mapId]
        local tempMapNum = tempCopyData.map_num
        for i,v in ipairs(tMultiCopyData) do
            local nMapId = v.mapId
            if tempMapNum == nMapId then
                nStarNum = v.starLevel
                break 
            end
        end
        WZLog("SceneBossRoom:_setBtnBattleHelpVisible", Serialize(tMultiCopyData), self.m_tData.mapId, nStarNum)
        if nStarNum < 3 then 
            btnBattleHelp:setVisible(false)
        else
            local nOwnerLevel = self:getOwnerLevel()
            local assistLvHigher = tonumber(CacheCenter:getGameParam().assistinbattleLvHigher)
            if tempCopyData.difficulty == 4 then 
                assistLvHigher = tonumber(CacheCenter:getGameParam().assistinAwakenLvHigher)
            end
            WZLog("SceneBossRoom:_setBtnBattleHelpVisible fff", nOwnerLevel, CacheCenter:getPlayerInfo().level, assistLvHigher, CacheCenter:getPlayerInfo().awakeAssistTime)
            if nOwnerLevel + assistLvHigher > CacheCenter:getPlayerInfo().level then 
                btnBattleHelp:setVisible(false)
            elseif tempCopyData.difficulty == 4 and CacheCenter:getPlayerInfo().awakeAssistTime ~= 1 then 
                btnBattleHelp:setVisible(false)
            else
                btnBattleHelp:setVisible(true)

                local assist = self:getMyAssist()
                g_nMyAssistState = assist
                local imgHelpIcon = GetElement(self.m_root, "imgHelpIcon_SceneBossRoom", WZUIImage)
                local txtBtnHelp = GetElement(self.m_root, "txtBtnHelp_SceneBossRoom", WZUILabelTTF)
                if imgHelpIcon then 
                    if assist == 1 then 
                        imgHelpIcon:setFile("ui/copy/common_xiezhu_01.png")
                        txtBtnHelp:setTextKey("BATTLE_HELP_TEXT5")
                    elseif assist == 0 then 
                        imgHelpIcon:setFile("ui/copy/common_xiezhu_ke.png")
                        txtBtnHelp:setTextKey("BATTLE_HELP_TEXT4")
                    end
                end
            end
        end
    end
    --设置觉醒难度是否可点击
    local checkBox4 = GetElement(self.m_root, "checkBox4_SceneBossRoom", WZUICheckBox)
    local tempMapNum1 = GDatatab_team_map["id_" .. self.m_tData.mapId].map_num
    local tempMapNum2 = GDatatab_team_map["id_" .. tMultiCopyData.awakeMapId].map_num
    if tempMapNum1 == tempMapNum2 then 
        checkBox4:setTouchEnable(true)
    else
        checkBox4:setTouchEnable(false)
        GetElement(self.m_root, "imgIcon4_SceneBossRoom", WZUIImage):setGrayRender(true)
        GetElement(self.m_root, "txtDifficultyNor4_SceneBossRoom", WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
        GetElement(self.m_root, "txtDifficultyNor4_SceneBossRoom", WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(138,122,106))
    end
end

--@brief    适配iphoneX
function SceneBossRoom:adaptIphoneX()
    -- body
    if IsIphoneX() then
        GetElement(self.m_root, "conForRoomInvite_SceneBossRoom", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.96, 0.5))
        GetElement(self.m_root, "btnShowInvite_SceneBossRoom", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.96, 0.5))
    end
end

--@brief    设置技能方案的名字
function SceneBossRoom:setSkillSuitName()
    -- body
    if not CheckButtonOpen(172, false) then return end 
    local tSkillSuit = CacheCenter:getSkillSuit()
    if tSkillSuit == nil then 
        ProtocolProcessorRecycling:send_PLAYERITEM_GetSuit(8)
        return 
    end

    local txtSkillSuitName = GetElement(self.m_root, "txtSkillSuitName_SceneBossRoom", WZUILabelTTF)
    for i = 1, #tSkillSuit do
        if tSkillSuit[i].bIsUsed then 
            txtSkillSuitName:setText(tSkillSuit[i].name .. LocalStrings.SKILLSUIT_TAIL)
            break 
        end
    end
end


--@brief    显示伴侣互动动画
function SceneBossRoom:showCoupleAnimation()
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
function SceneBossRoom:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtRoomName_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    GetElement(self.m_root,"txtRoomId_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.5))
    GetElement(self.m_root,"txtRoomPass_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.47,0.5))

    local txtEasy1 = GetElement(self.m_root,"txtEasy1_SceneBossRoom",WZUILabelTTF)
    if txtEasy1 then
        txtEasy1:setRelativePosition(GlobalMethod:ccp(0.688,0.5))
        GetElement(self.m_root,"txtEasy2_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.688,0.5))
        GetElement(self.m_root,"txtHard1_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.688,0.5))
        GetElement(self.m_root,"txtHard2_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.688,0.5))
        GetElement(self.m_root,"txtHell1_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.688,0.5))
        GetElement(self.m_root,"txtHell2_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.688,0.5))
    end
end

function SceneBossRoom:_adaptLanguage_en(  )
    local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneBossRoom",WZUILabelTTF)
    txtRoomName:setRelativePosition(GlobalMethod:ccp(0.56,0.5))
    txtRoomName:setFontSize(18)
    GetElement(self.m_root,"txtRoomId_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.5))
    GetElement(self.m_root,"txtRoomPass_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.47,0.5))
    
    GetElement(self.m_root,"txtMapTitle_SceneBossRoom",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(200))
end

function SceneBossRoom:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtRoomName_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.47,0.5))
    GetElement(self.m_root,"txtRoomId_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.5))
    GetElement(self.m_root,"txtRoomPass_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.47,0.5))
end

function SceneBossRoom:_adaptLanguage_pt(  )
    local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneBossRoom",WZUILabelTTF)
    txtRoomName:setRelativePosition(GlobalMethod:ccp(0.7,0.5))
    txtRoomName:setFontSize(18)
    GetElement(self.m_root,"txtRoomId_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    GetElement(self.m_root,"txtRoomPass_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))

    GetElement(self.m_root,"txtMapTitle_SceneBossRoom",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(200))

end

function SceneBossRoom:_adaptLanguage_es(  )
    local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneBossRoom",WZUILabelTTF)
    txtRoomName:setRelativePosition(GlobalMethod:ccp(0.77,0.5))
    txtRoomName:setFontSize(16)

    GetElement(self.m_root,"txtRoomId_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.5))
    GetElement(self.m_root,"txtRoomPass_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.5))

    GetElement(self.m_root,"txtRoomNameD_SceneBossRoom",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtMapTitle_SceneBossRoom",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(200))
end

function SceneBossRoom:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtRoomName_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.400896,0.5))
    GetElement(self.m_root,"txtRoomId_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.519078,0.5))
    GetElement(self.m_root,"txtRoomPass_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.323623,0.5))
end

function SceneBossRoom:_adaptLanguage_ug(  )
    local txtRoomNameD = GetElement(self.m_root,"txtRoomNameD_SceneBossRoom",WZUILabelTTF)
    txtRoomNameD:setScale(0.7)
    txtRoomNameD:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRoomNameD:setRelativePosition(GlobalMethod:ccp(1.17,0.5))
    local txtRoomIDD = GetElement(self.m_root,"txtRoomIDD_SceneBossRoom",WZUILabelTTF)
    txtRoomIDD:setScale(0.7)
    txtRoomIDD:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRoomIDD:setRelativePosition(GlobalMethod:ccp(1.17,0.5))
    local txtRoomPassD = GetElement(self.m_root,"txtRoomPassD_SceneBossRoom",WZUILabelTTF)
    txtRoomPassD:setScale(0.7)
    txtRoomPassD:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRoomPassD:setRelativePosition(GlobalMethod:ccp(1.17,0.5))
    local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneBossRoom",WZUILabelTTF)
    txtRoomName:setScale(0.7)
    txtRoomName:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRoomName:setRelativePosition(GlobalMethod:ccp(0.632713,0.5))
    local txtRoomId = GetElement(self.m_root,"txtRoomId_SceneBossRoom",WZUILabelTTF)
    txtRoomId:setScale(0.7)
    txtRoomId:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRoomId:setRelativePosition(GlobalMethod:ccp(0.528169,0.5))
    local txtRoomPass = GetElement(self.m_root,"txtRoomPass_SceneBossRoom",WZUILabelTTF)
    txtRoomPass:setScale(0.7)
    txtRoomPass:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRoomPass:setRelativePosition(GlobalMethod:ccp(0.705441,0.5))

    local txtWorld = GetElement(self.m_root,"txtWorldInvite_SceneBossRoom",WZUILabelTTF)
    txtWorld:setScale(0.7)
    txtWorld:setDimensions(GlobalMethod:CCSize(160,0))
end
-------------------------------------语言适配器模块End----------------------------------------


