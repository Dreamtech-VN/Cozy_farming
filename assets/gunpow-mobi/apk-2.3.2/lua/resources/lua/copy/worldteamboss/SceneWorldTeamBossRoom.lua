--SceneWorldTeamBossRoom.lua
--@brief	SceneWorldTeamBossRoom的UI模块
--@date		2018/07/12
--@author	Tianxiang_Xu
--@note		世界组队boss房间


-------------------------------------公有方法模块Begin--------------------------------------
--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function SceneWorldTeamBossRoom:onEnter(element)
    WZLog("SceneWorldTeamBossRoom:onEnter ")
    self.m_root = element
    AdaptLanguage(self)

    self.m_bIsCreate = true
    self.m_toBattleLoadingScene = nil
    ProtocolProcessorWorldTeamBossRoom:regAll() --注册协议
    CacheCenter:registerUpateDressSuitObserver(self)
    CacheCenter:registerUpateSkillSuitObserver(self)

    IPDConnector.g_nNetConnectFlag = NET_FLAG_7
    
    --组队房间频道
    ChangeChatChannel(Chat_Channel_WorldTeam_BossRoom)
    
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    self:initRewardRankInfo()
    self:_initInspireState()
    self:addTop()

    if self.m_tData ~= nil then
        self:endPairTimer()
        self:_update()
    end
    self:anctionPlayFinish()

    self.m_root:enableSchedule("_updateCheckPlayerState",1)

    WndChat:addChatWindowToCurScene()
end

--@breif  动画播放完毕
function SceneWorldTeamBossRoom:anctionPlayFinish()
    
    self.m_root:enableSchedule("updatePlayerAnimation",1.5)
end

--@brief  退出房间
function SceneWorldTeamBossRoom:exitRoom()
    if self.m_tData == nil or self.m_root == nil then
        WZLog("SceneWorldTeamBossRoom:onBackSceneCallback m_tData is nil")
        return
    end
    if self.m_toBattleLoadingScene ~= true then
        if WBattleGlobal:getCurrent().m_tMakePairOk and WBattleGlobal:getCurrent().m_tMakePairOk.battleId then
            WBattleGlobal:getCurrent().m_tMakePairOk.battleId = 0
        end
        WZLog("SceneWorldTeamBossRoom:exitRoom", self.m_tData.roomId, self:_getPlayerSeat())
        ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat())
    end
end

-- 点击退出房间回调
function SceneWorldTeamBossRoom:onClose()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WZLog("SceneWorldTeamBossRoom:onBackSceneCallback")
    WZLog("roomId:",self.m_tData.roomId)
    WZLog("seat:",self:_getPlayerSeat())
    ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat())
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function SceneWorldTeamBossRoom:onExit(element)
    WZLog("SceneWorldTeamBossRoom:onExit", tostring(g_bIsPushScene), tostring(g_bIsPopScene))
    if g_bIsPushScene == true then
        return
    end
    self:exitRoom()
    self:quitVoice()
    self.m_conBossInfo:disableSchedule()
    --add by wuweidong
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","SceneWorldTeamBossRoom")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","SceneWorldTeamBossRoom")
    self.m_root:disableSchedule()          
    CacheCenter:unregisterUpateDecorationObserver(self)
    CacheCenter:unregisterUpatePlayerPetInfoObserver(self)
    CacheCenter:unregisterUpateDressSuitObserver(self)
    CacheCenter:unregisterUpateSkillSuitObserver(self)
    ProtocolProcessorWorldTeamBossRoom:unregAll() --反注册协议
    self:_unInit()
    IPDConnector.g_nNetConnectFlag = NET_FLAG_2
    
end

function SceneWorldTeamBossRoom:onEnterTransitionDidFinish()
    local tConfig = CacheCenter:getGameParam().teamWorldBossConfig
    self.m_tSysConfig = json.decode(tConfig)
    WZLog("SceneWorldTeamBossRoom:onEnterTransitionDidFinish", Serialize(self.m_tSysConfig))
    self:_setBoxPosition()
    self:createLoadingBox()
    ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetRoomState()
    ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetHurtRank()
    self:adaptIphoneX()
    
	self.m_conBossInfo = GetElement(self.m_root, "conBossInfo_SceneWorldTeamBossRoom", WZUIContainer)
    self:_initInspineBtn()

	ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetTeamWorldBossHp()
    popSceneEnd()
    --延时显示成就特效
    ShowDelayAchie()
    self:setSkillSuitName()
end

--@brief    获得主角的座位
--@return   #1:位置
function SceneWorldTeamBossRoom:_getPlayerSeat()
    WZLog("SceneWorldTeamBossRoom:_getPlayerSeat")
    
    if self.m_tData == nil then
        WZLog("SceneWorldTeamBossRoom:_getPlayerSeat m_tData is nil.")
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
function SceneWorldTeamBossRoom:findPlayerSeatById(playerId)
    WZLog("SceneWorldTeamBossRoom:findPlayerSeatById ",playerId)
    if self.m_tData == nil or playerId == nil then
        WZLog("SceneWorldTeamBossRoom:_getPlayerSeat m_tData is nil.")
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
function SceneWorldTeamBossRoom:updatePlayerSeat()
    WZLog("SceneWorldTeamBossRoom:updatePlayerSeat")
    local isVoice = self:checkVoiceChannelLv(self.m_tData.roomChannel)
    local playerSeatIndex = self:_getPlayerSeat()
    playerSeatIndex = playerSeatIndex + 1
    GlobalGame.g_nPlayerInTeam = -1
    local indexTag = 0
    local maxCount = 2
    local conCenter = GetElement(self.m_root,"conCenter_SceneWorldTeamBossRoom",WZUIContainer)

    for i= 1, maxCount do
        self:checkCellChatBubble(i)
        local conSeat = WZUIContainer:luaTo(conCenter:getChildElement("conSeat".. i .."_SceneWorldTeamBossRoom"))
        local btnPlayerFigure  = WZUIButton:luaTo(conSeat:getChildElement("btnPlayerFigure_SceneWorldTeamBossRoom"))
        local btnPlayerPet = GetElement(conSeat,"btnPlayerPet_SceneWorldTeamBossRoom",WZUIButton)

        local conWeapon= WZUIContainer:luaTo(conSeat:getChildElement("conWeapon_SceneWorldTeamBossRoom"))
        local imgWeaponIcon = WZUIImage:luaTo(conWeapon:getChildElement("imgWeaponIcon_SceneWorldTeamBossRoom"))
        imgWeaponIcon:setFile("")

        local btnWeapon = WZUIButton:luaTo(conWeapon:getChildElement("btnWeapon_SceneWorldTeamBossRoom"))
        btnWeapon:setTag(-1)

        local spWeapon1 = GetElement(conWeapon,"spWeapon_SceneWorldTeamBossRoom",WZUISpine)
        spWeapon1:setVisible(false)
        local playerId = self.m_tData.playerId[i]
        self:showPlayerFigureAndPet(i)

        local conFigure = GetElement(conSeat,"conFigureVoice_SceneWorldTeamBossRoom",WZUIContainer)
        local anim = GetElement(conSeat,"animFigureVoice_SceneWorldTeamBossRoom",WZUISpine)
        local img = GetElement(conSeat,"imgFigureVoice_SceneWorldTeamBossRoom",WZUIImage)

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

        local conSeatInfo = GetElement(conSeat,"conSeatInfo_SceneWorldTeamBossRoom",WZUIContainer)
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
    
    self:showCoupleAnimation()
end

--@brief    开始配对计时器
function SceneWorldTeamBossRoom:startPairTimer()
    WZLog("SceneWorldTeamBossRoom:startPairTimer")
    self.m_nPairRemainTime = 10
    local downTime = GetElement(self.m_root,"txtMakePairTime_SceneWorldTeamBossRoom",WZUILabelAtlasFont)
    downTime:setText(self.m_nPairRemainTime)
    --downTime:setVisible(true)
    downTime:enableSchedule("_schedulePairTimer",1)
    self.m_root:enableSchedule("_scheduleCheckRoomPlayer", 0)
end


--@brief    检查房间玩家计算器的回调函数
function SceneWorldTeamBossRoom:_scheduleCheckRoomPlayer()
    if (not self:_allPlayersReady()) then
        self.m_root:disableSchedule()
        self:endPairTimer()
    end
end

--@brief    关闭配对计时器
function SceneWorldTeamBossRoom:endPairTimer()
    WZLog("SceneWorldTeamBossRoom:endPairTimer")
    if self.m_root == nil then return end
    local downTime = GetElement(self.m_root,"txtMakePairTime_SceneWorldTeamBossRoom",WZUILabelAtlasFont)
    downTime:setVisible(false)
    downTime:disableSchedule()
end

--@brief    触摸函数，判断消息是否在消息框显示范围内，如果不是的话，就让消息框不显示，反之，显示
--@param #1 element:表绑定的UI节点引用
--@param #2 point:点击位置
function SceneWorldTeamBossRoom:onTouchBegan(element, point)
    WZLog("SceneWorldTeamBossRoom:onTouchBegan")
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
end


--@brief  显示宠物tip
function SceneWorldTeamBossRoom:onClickPet(element)
    WZLog("SceneWorldTeamBossRoom:onClickPet")
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


function SceneWorldTeamBossRoom:onClickWorldInvite(element)
    -- body
    WZLog("SceneWorldTeamBossRoom:onClickWorldInvite")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self:_challengeStateJudge() then return end 
    if not self:_challengeTimesJudge() then return end 

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
function SceneWorldTeamBossRoom:onClickWeapon(element)
    WZLog("SceneWorldTeamBossRoom:onClickWeapon")
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
function SceneWorldTeamBossRoom:onClickSkill(element)
    -- body
    WZLog("SceneWorldTeamBossRoom:onClickSkill")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local seatI = self:_getPlayerSeat()
    if self.m_tData.playerReady[seatI + 1] and not self:getIsRoomOwner() then
        MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
        return
    end
    WndSkillContainer:showById(1)
end


--@brief  钻石鼓舞回调
function SceneWorldTeamBossRoom:onDiamondInspire( element )
    WZLog("------diamondInspire----------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self:_challengeStateJudge() then return end 
    -- 鼓舞满
    if self.m_nMyInspire >= 10000 then
        MsgBoxManager:showTipBox(LocalStrings.WOLRD_BOSS_INSPIRE_FULL)
        return
    end

    local data =  GDatatab_team_world_boss_encouraging["id_1"]
    if JudgeMoneyIsEnough(data.type, data.cost, nil, nil, Chat_Channel_WorldTeam_BossRoom, nil, nil, nil, nil, self, self.sureInspire) then
        self:sureInspire()
    end
end

--@brief    确定鼓舞
function SceneWorldTeamBossRoom:sureInspire()
    -- body
    local data =  GDatatab_team_world_boss_encouraging["id_1"]
    ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Inspire(data.type)
end

--@brief  金币鼓舞回调
function SceneWorldTeamBossRoom:onGoldInspire( element )
    WZLog("------goldInspire----------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self:_challengeStateJudge() then return end 

    if self.m_nMyInspire >= 10000 then
        MsgBoxManager:showTipBox(LocalStrings.WOLRD_BOSS_INSPIRE_FULL)
        return
    end

    local data =  GDatatab_team_world_boss_encouraging["id_2"]
    if JudgeMoneyIsEnough(data.type, data.cost, nil, nil, Chat_Channel_WorldTeam_BossRoom) then
        ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Inspire(data.type)
    end
end

function SceneWorldTeamBossRoom:onClickRewardBox(element)
    -- body
    WZLog("SceneWorldTeamBossRoom:onClickRewardBox")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    local bossData = GDatatab_team_world_boss_map["id_" .. self.bossRoomInfo.mapId]
    local rewardList = {}
    rewardList.strartNum = nil
    rewardList.icon = {}   
    rewardList.id = {}
    rewardList.num = {}
    rewardList.nType = 4
    rewardList.strartNum = math.floor((self.bossRoomInfo.bossBloodMax - self.bossRoomInfo.bossBloodCurrent)/self.bossRoomInfo.bossBloodMax * 100) 
   
    rewardList.endNum = self.m_tSysConfig["stage" .. tag]
    rewardList.curNum = self.bossRoomInfo.hurt
    rewardList.targetNum = bossData.min_hurt
    local reward = bossData["fixed_reward" .. tag]
    if reward then
        for i = 1, #reward do
            table.insert(rewardList.icon, GDatatab_item["id_" .. reward[i][1]].icon)
            table.insert(rewardList.id, reward[i][1])
            table.insert(rewardList.num, reward[i][2])
        end
    end

    WndTips:show(element, SceneWorldTeamBossRoom.m_root, 3, rewardList, GlobalMethod:ccp(20,100), true)
end

--@brief    查找回调
function SceneWorldTeamBossRoom:onSearchButtonClick(element)
    WZLog("SceneWorldTeamBossRoom:onSearchButtonClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local seatI = self:_getPlayerSeat()
    if self.m_tData.playerReady[seatI + 1] and not self:getIsRoomOwner() then
        MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
        return
    end

    if not self:_challengeStateJudge() then return end 
    if not self:_challengeTimesJudge() then return end 

    local wndFindRoom = WndFindRoom:createElement()
    if wndFindRoom ~= nil then
        WindowManager:addWindow(wndFindRoom,WndFindRoom,true,nil,nil)
        WndFindRoom:setFindBtnCallBack(self.searchRoom,self)
    end
end

-- 快速游戏按钮点击回调
function SceneWorldTeamBossRoom:onFastGameButtonClick(element)
    WZLog("SceneWorldTeamBossRoom:onFastGameButtonClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local seatI = self:_getPlayerSeat()
    if self.m_tData.playerReady[seatI + 1] and not self:getIsRoomOwner() then
        MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
        return
    end

    if not self:_challengeStateJudge() then return end 
    if not self:_challengeTimesJudge() then return end 

    if self.m_nCount == 0 then
        self.m_nCount = 1
        element:enableSchedule("scheduleCalculate",1)
    else
        return
    end

    self:createLoadingBox()
    ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_QuickGame( )
end

function SceneWorldTeamBossRoom:scheduleCalculate(element)
    WZLog("SceneWorldTeamBossRoom:scheduleCalculate")
    element:disableSchedule()
    self.m_nCount = 0
end

--@brief    查找房间
--@param    入参与创建房间的协议发送方法参数相同
--@return   true:关闭WndEditBox，false:反之
--@note     调用这个函数发送查找房间协议,起到代理的作用
function SceneWorldTeamBossRoom:searchRoom(roomId, password)
    WZLog("SceneWorldTeamBossRoom:searchRoom =", password)
    WZLog("room id",roomId)
    local id = tonumber(roomId)
    if id == nil then
        MsgBoxManager:showTipBox(LocalStrings.ROOM_FIND_TIPS)
        return false
    elseif id == self.m_tData.roomId then 
        MsgBoxManager:showTipBox(LocalStrings.HAVED_IN_ROOM)
        return false 
    else
        if password == nil  then 
            WZLog("SceneWorldTeamBossRoom:searchRoom password == nil ")
            ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_SelectRoom(roomId, "-1")
        else
            WZLog("SceneWorldTeamBossRoom:searchRoom password ~= nil ")
            if password == "" then
                WZLog("SceneWorldTeamBossRoom:searchRoom 11111") 
                ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_SelectRoom(roomId, "")
            else 
                WZLog("SceneWorldTeamBossRoom:searchRoom 22222") 
                ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_SelectRoom(roomId, password) 
            end 
        end
        self:createLoadingBox()
        return true
    end
end

--@brief    点击奖励预览按钮回调
function SceneWorldTeamBossRoom:onClickRewardView(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("onClickRewardView", self.bossRoomInfo.mapId)
    local data = self.rankInfo[self.bossRoomInfo.mapId]

    WndRewardViewTip:showInterface(data, 0)
end

--@brief    点击浏览排名按钮回调
function SceneWorldTeamBossRoom:onCheckRank(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- WndHurtRankTip:showInterface(self.hurtInfo, 0)
    WndTowerRank:showWindow(3)
end

--@brief    点击顶部头像图标回调
function SceneWorldTeamBossRoom:onCheckHead(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    local tData = self.hurtInfo[1]
    
    WndCheckOther:show(tData.player[nTag].playerId)
end

--@brief    点击规则按钮回调
function SceneWorldTeamBossRoom:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface(LocalStrings.TEAMBOSS_TEXT2)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置控件静态文本
--@note     设置控件静态文本
function SceneWorldTeamBossRoom:_setUIStaticText()
    --描边字
    WZLog("SceneWorldTeamBossRoom:_setUIStaticText")
   

end
--@brief    scene更新函数
--@note     实际上的初始化函数
function SceneWorldTeamBossRoom:_update()    
    WZLog("SceneWorldTeamBossRoom:_update")             
    if self.m_root == nil then
        WZLog("SceneWorldTeamBossRoom:_update m_root is nil.")
        return
    end

    if self.m_tData == nil then
        WZLog("SceneWorldTeamBossRoom:_update m_tData is nil.")
        return
    end
    self:checkVoice()
    self:_showMyHurtAdd()
    self:_updateRoomSecrit()
    --更新玩家座位
    self:updatePlayerSeat()

    self:updateReaderBtn()

    if WindowManager:getSceneRoot():getName() == "WndWorldTeamBossInvite" then
       WndWorldTeamBossInvite:setInviteFriendIds(self.m_tData.playerId)
    end
    WndWorldTeamBossInvite:setInviteFriendIds(self.m_tData.playerId)

    self:_shieldClick()
    --怪物形象
    self:_buildGuai()
    --
    self:setBossInfo()
end

--@brief    配对计算器的回调函数
function SceneWorldTeamBossRoom:_schedulePairTimer()
    if self.m_nPairRemainTime > 0 then
        self.m_nPairRemainTime = self.m_nPairRemainTime - 1
        WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"txtMakePairTime_SceneWorldTeamBossRoom")):setText(self.m_nPairRemainTime)
    else
        WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"txtMakePairTime_SceneWorldTeamBossRoom")):setVisible(false)
    end
end

--@brief  更新房间基本信息
function SceneWorldTeamBossRoom:updateMiddleInfo()
    WZLog("SceneWorldTeamBossRoom:updateMiddleInfo")
    local txtRoomName = GetElement(self.m_root, "txtRoomName_SceneWorldTeamBossRoom", WZUILabelTTF)
    local txtRoomId = GetElement(self.m_root, "txtRoomId_SceneWorldTeamBossRoom", WZUILabelTTF)
    --我的排名
    if txtRoomName then 
        if self.bossRoomInfo.myRank == -1 then 
            txtRoomName:setText(LocalStrings.COMMUNITY_COMPETE_TEXT43)
        else
            txtRoomName:setText(self.bossRoomInfo.myRank)
        end
    end
    --我的伤害
    if txtRoomId then 
        if self.bossRoomInfo.myRank == -1 then 
            txtRoomId:setText(LocalStrings.COMMUNITY_COMPETE_TEXT43)
        else
            local hurtPercent = self.bossRoomInfo.hurt/self.bossRoomInfo.bossBloodMax * 100
            local nPercent = string.format("%0.2f", hurtPercent)
            txtRoomId:setText(nPercent .. "%")
        end
    end
end

--@brief  更新开始游戏按钮状态
function SceneWorldTeamBossRoom:updateReaderBtn()
    WZLog("SceneWorldTeamBossRoom:updateReaderBtn()")
    local imgStartGame = WZUIImage:luaTo(self.m_root:getChildElement("imgStartGame_SceneWorldTeamBossRoom"))
    
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

function SceneWorldTeamBossRoom:_getPlayerNum()
    local num = 0
    for i=1 , #self.m_tData.playerId do
        if self.m_tData.playerId[i] > 0 then num = num + 1 end
    end
    return num
end

--@brief  获取空位数量
function SceneWorldTeamBossRoom:getAllNULLSeat()
    WZLog("SceneWorldTeamBossRoom:getAllNULLSeat")
    local count = 0
    for i,v in ipairs(self.m_tData.playerId) do
        if v <=0 then
            count = count + 1
        end
    end
    return count
end

--@brief  判断是否有空位
function SceneWorldTeamBossRoom:hasNullSeat()
    for i,v in ipairs(self.m_tData.playerId) do
        if v <=0 and self.m_tData.seatUsed[i] then
            return true
        end
    end
    return false
end

--@brief    是否为房主
--@return   #1:true:是,false:否
function SceneWorldTeamBossRoom:getIsRoomOwner()
    WZLog("SceneWorldTeamBossRoom:getIsRoomOwner")
    if self.m_tData == nil then
        WZLog("SceneWorldTeamBossRoom:getIsRoomOwner m_tData is nil.")
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
function SceneWorldTeamBossRoom:_isSeatUsed(index)
    if self.m_tData == nil then 
        WZLog("SceneWorldTeamBossRoom:_isSeatUsed  m_tData is nil ")
        return
    end 
    if self.m_tData.playerId[ index ] > 0 then
        return true     
    end 
    return false
end

--@brief  更新座位信息
function SceneWorldTeamBossRoom:_updateSeatInfo(luaObject,elementObject,index,bgType,isused)
    WZLog("SceneWorldTeamBossRoom:_updateSeatInfo ",index)
    if luaObject ~= nil then
        luaObject:setBgType(bgType)
        local conCenter = GetElement(self.m_root,"conCenter_SceneWorldTeamBossRoom",WZUIContainer)
        local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneWorldTeamBossRoom",WZUIContainer)
        local imgPlayerStats = WZUIImage:luaTo(conSeat:getChildElement("imgPlayerStatus_SceneWorldTeamBossRoom"))
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
        luaObject:setData(curD.wnersId,curD.seatUsed[index],curD.playerId[index],curD.playerName[index],curD.playerLevel[index],curD.playerReady[index],curD.playerSex[index],curD.vipLevel[index],curD.playerTitle[index],curD.fighting[index],curD.playerNumMode,index,-1,curD.battleMode,0,curD.seatUsed,curD.serviceId[index],curD.roomChannel,0,0,0,curD.winTimes[index],curD.joinTimes[index],curD.continuousWinTimes[index],curD.matchscore[index],curD.qualifyingLevel[index])
        luaObject:setSeatInfo(self.m_tData.seatUsed)
        luaObject:setRoomId(self.m_tData.roomId)
        local friendInfo = self:getFriendRV(self.m_tData.playerId[index])
        luaObject:setFriendInfo(friendInfo)

        local masterInfo = self:getMasterRV(self.m_tData.playerId[index],self.m_tData.playerLevel[index])
        luaObject:setMasterInfo(masterInfo)

        local spouseValue,spuseLevel,wifeName,husbandName = self:getSpouseRV(self.m_tData.playerId[index],self.m_tData.playerSex[index],self.m_tData.playerName[index])
        luaObject:setSpouseInfo(spouseValue,spuseLevel,wifeName,husbandName)

        luaObject:_update()
    end
end

--@brief    创建一个玩家座位
--@param    index:cell的识别
--@param    bgType:背景类型(1:红色,2:蓝色)
--@param    isused:座位是否关闭
--@return   #1:element的引用
--@return   #2:表的引用
function SceneWorldTeamBossRoom:_createASeat(index,bgType,isused)
    WZLog("SceneWorldTeamBossRoom:_createASeat",index,bgType,isused)
    local tagType = 1
    local conCenter = GetElement(self.m_root,"conCenter_SceneWorldTeamBossRoom",WZUIContainer)

    local cellElement,cellObj = CellRoomSeat:createElement(tagType)
    cellElement:setTag(index)
    cellObj:setBgType(bgType)
    
    local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneWorldTeamBossRoom")
    local imgPlayerStats = GetElement(conSeat,"imgPlayerStatus_SceneWorldTeamBossRoom",WZUIImage)
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
    cellObj:setData(curD.wnersId, curD.seatUsed[index], curD.playerId[index], curD.playerName[index], curD.playerLevel[index], curD.playerReady[index], curD.playerSex[index], curD.vipLevel[index], curD.playerTitle[index], curD.fighting[index], curD.playerNumMode, index, -1, curD.battleMode, 0, curD.seatUsed, curD.serviceId[index], curD.roomChannel, 0, 0, 0, curD.winTimes[index], curD.joinTimes[index], curD.continuousWinTimes[index], curD.matchscore[index], curD.qualifyingLevel[index])
    cellObj:setSeatInfo(self.m_tData.seatUsed)
    cellObj:setRoomId(self.m_tData.roomId)
    cellObj:setChangeSeatCallBack(self.onClickInvPlayer, self)
    cellObj:setParentRoot(self.m_root)
    cellObj:setKickOutPt(GlobalMethod:ccp(0.72,0.1), 1.2)
    local friendInfo = self:getFriendRV(self.m_tData.playerId[index])
    cellObj:setFriendInfo(friendInfo)

    local masterInfo = self:getMasterRV(self.m_tData.playerId[index],self.m_tData.playerLevel[index])
    cellObj:setMasterInfo(masterInfo)

    local spouseValue,spuseLevel,wifeName,husbandName = self:getSpouseRV(self.m_tData.playerId[index],self.m_tData.playerSex[index],self.m_tData.playerName[index])
    cellObj:setSpouseInfo(spouseValue,spuseLevel,wifeName,husbandName)
    return cellElement,cellObj
end

--@brief 显示玩家形象与宠物
function SceneWorldTeamBossRoom:showPlayerFigureAndPet(index)
    WZLog("SceneWorldTeamBossRoom:showPlayerFigureAndPet")
    local playerEquipment = {}
    for i=1,5 do
        playerEquipment[i]= self.m_tData.playerEquipment[(index-1)*5+i]
    end
    local conCenter = GetElement(self.m_root,"conCenter_SceneWorldTeamBossRoom",WZUIContainer)
   
    if self.m_tData.seatUsed[index] and self.m_tData.playerId[index] > 0  then
        local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneWorldTeamBossRoom",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_SceneWorldTeamBossRoom",WZUIContainer)
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
        
        local conPet = GetElement(conSeat,"conPet_SceneWorldTeamBossRoom",WZUIContainer)
        
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
        local conForNameAndTitle = GetElement(conSeat, "conForNameAndTitle_SceneWorldTeamBossRoom", WZUIContainer)
        if conForNameAndTitle then
            local txtPlayerName = GetElement(conSeat, "txtPlayerName_SceneWorldTeamBossRoom", WZUILabelTTF)
            txtPlayerName:setText(self.m_tData.playerName[index])
            local txtPlayerLv = GetElement(conSeat, "txtPlayerLv_SceneWorldTeamBossRoom", WZUILabelTTF)
            txtPlayerLv:setText("Lv" .. self.m_tData.playerLevel[index])
            if playerId == CacheCenter:getPlayerInfo().id then
                txtPlayerName:setColor(GlobalMethod:ccc3(99,255,95))
            else
                txtPlayerName:setColor(GlobalMethod:ccc3(255,255,255))
            end
            local conTitle = GetElement(conSeat, "conTitle_SceneWorldTeamBossRoom", WZUIContainer)
            local txtPlayerTitle = GetElement(conSeat, "txtPlayerTitle_SceneWorldTeamBossRoom", WZUILabelTTF)
            local tempPoint = GlobalMethod:ccp(0.5, 1.9)
            if self.m_tData.playerTitle[index] and self.m_tData.playerTitle[index] ~= "" then
                -- CreateDesiSpine(conTitle, txtPlayerTitle, self.m_tData.playerTitle[index], tempPoint, nil, 0.9)
            end
        end
        --套装按钮
        if playerId == CacheCenter:getPlayerInfo().id then
            self:_addDressSuit(conSeat)
        end
        --鼓舞值
        local inspireFotmat = [[<I>%s</I><A IMG = "ui/common_num/worldteamboss_num_001.png" Z ="1" W = "18" H = "26" CHAR = "0">%d</A><I>%s</I>]]
        local inspireContent = string.format(inspireFotmat, "ui/world_boss/worldteamboss_text_001.png", self.m_tData.inspire[index]/10000*100, "ui/world_boss/worldteamboss_text_002.png")
        self:_addInspireValue(conSeat, inspireContent)
    else
        local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneWorldTeamBossRoom",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_SceneWorldTeamBossRoom",WZUIContainer)
        local conPet = GetElement(conSeat,"conPet_SceneWorldTeamBossRoom",WZUIContainer)
        local conForDressSuit = GetElement(conSeat,"conForDressSuit_SceneWorldTeamBossRoom",WZUIContainer)
        local txtPlayerName = GetElement(conSeat, "txtPlayerName_SceneWorldTeamBossRoom", WZUILabelTTF)
        local txtPlayerLv = GetElement(conSeat, "txtPlayerLv_SceneWorldTeamBossRoom", WZUILabelTTF)
        local txtPlayerTitle = GetElement(conSeat, "txtPlayerTitle_SceneWorldTeamBossRoom", WZUILabelTTF)
        local conTitle = GetElement(conSeat, "conTitle_SceneWorldTeamBossRoom", WZUIContainer)
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

        local inspireFotmat = [[<T C="62,34,8" S="22" P="0"> </T>]]
        self:_addInspireValue(conSeat, inspireFotmat)

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

--@brief    创建一个角色动画
function SceneWorldTeamBossRoom:createAPlayer(playerSex,equipment,headColor,bodyColor,animName)
    WZLog("SceneWorldTeamBossRoom:createAPlayer")
    return CreatePlayerFigure(playerSex,equipment,animName,nil,nil,nil,nil,nil,nil,nil,headColor,bodyColor)
end

--@breif  更新玩家的动作
function SceneWorldTeamBossRoom:updatePlayerAnimation(element,delta)

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

--@brief    添加时装套装入口
function SceneWorldTeamBossRoom:_addDressSuit(element)
    -- body
    if CheckButtonOpen(144, false) then
        local conForDressSuit = GetElement(element, "conForDressSuit_SceneWorldTeamBossRoom", WZUIContainer)
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

--@brief 	添加鼓舞值
function SceneWorldTeamBossRoom:_addInspireValue(conSeat, content)
	-- body
    local ftxtInspire = GetElement(conSeat, "ftxtInspire_SceneWorldTeamBossRoom", WZUIFreeTextBox)

    if ftxtInspire then
    	ftxtInspire:setShowText(content)
    end
end
-------------------------------------回调方法模块Begin----------------------------------------

-- 点击修改副本信息按钮时的回调
function SceneWorldTeamBossRoom:onChangeInfo(element)
    -- 只有房主才能修改信息
    if (not self:getIsRoomOwner()) then 
    	MsgBoxManager:showTipBox(LocalStrings.TEAMBOSS_TEXT5)
    	return  
    end

    WZLog("SceneWorldTeamBossRoom:onChangeInfo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndBossRoomSetting:showInterface()
    WndBossRoomSetting:initRoomInfo(self.m_tData.roomName, self.m_tData.passWord)
    WndBossRoomSetting:setBackButtonCallback(self, self.changeInfoCallback)
end

--@ 	修改副本信息确认回调
function SceneWorldTeamBossRoom:changeInfoCallback(sRoomName, sRoomPass)
	ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_UpdateRoom(self.m_tData.roomId, sRoomPass, sRoomName)
end

--@brief  邀请玩家
function SceneWorldTeamBossRoom:onClickInvPlayer(element)
    WZLog("SceneWorldTeamBossRoom:onClickInvPlayer")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self:_challengeStateJudge() then return end 
    if not self:_challengeTimesJudge() then return end 

    if not self:hasNullSeat() then
        MsgBoxManager:showTipBox(LocalStrings.HALL_NO_SEAT)
        return
    end

    WndWorldTeamBossInvite:showInterface(14, self, self.inviteFriend)
end

--奖励预览
function SceneWorldTeamBossRoom:onClickPrize(element)
    -- body
    WZLog("SceneWorldTeamBossRoom:onClickPrize ")
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
        cell:setPositionY(ssss.y-50)
    end
end

-- 获取玩家数据在数据列表里面的下标
function SceneWorldTeamBossRoom:_getPlayerDataIndex()
    local playInfo = CacheCenter:getPlayerInfo()
    for i=1, #self.m_tData.playerId do
        if self.m_tData.playerId[i] == playInfo.id then
            return i
        end
    end
end

-- 邀请界面点击邀请回调
function SceneWorldTeamBossRoom:inviteFriend(tFriend)
    WZLog("SceneWorldTeamBossRoom:inviteFriend ")
    --音效
    ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Invite(self.m_tData.roomId, tFriend.id, 4)
end


--@brief    点击CellRoomSeat回调
function SceneWorldTeamBossRoom:onClickCellRoomSeat(element)
    WZLog("SceneWorldTeamBossRoom:onClickCellRoomSeat")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    self:_showPlayerInfo(tag)
end

--@brief    显示玩家信息
--@param    nPlayerSeat：玩家座位号
function SceneWorldTeamBossRoom:_showPlayerInfo(nPlayerSeat)
    if self.m_tData.playerId[nPlayerSeat] then
        WndCheckOther:show(self.m_tData.playerId[nPlayerSeat])
    end
end


--brief    开始游戏按钮回调
function SceneWorldTeamBossRoom:onStartGameButtonClick()
    WZLog("SceneWorldTeamBossRoom:onStartGameButtonClick")
    --音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if not self:_challengeStateJudge() then return end 
    if not self:_challengeTimesJudge() then return end 

    CacheCenter.m_nPlayerLevel = CacheCenter:getPlayerInfo().level
    
    -- 房主在大家都准备的情况下可以开始游戏，房客则准备或者取消准备
    if self:getIsRoomOwner() then
        if self:_allPlayersReady() then
        	ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_MakePair(self.m_tData.roomId)
            self:receiveMakePairring(self.m_tData.roomId)
            g_copyST = os.time()
        else
            MsgBoxManager:showTipBox(LocalStrings.ROOM_HAVE_NOT_READY)
        end
    else
        --准备或取消游戏,这里没有等服务器回调
        local seatNum = self:_getPlayerSeat()
        if self.m_tData.playerReady[seatNum + 1] == true then
        	ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GameReady(self.m_tData.roomId, seatNum, false)
        else
        	ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GameReady(self.m_tData.roomId, seatNum, true)
        end
    end
end

--brief    是否所有玩家已准备
--@return  #1: true:是, false：否
function SceneWorldTeamBossRoom:_allPlayersReady()
    for i=1, self.m_tData.playerNum do
        if self.m_tData.playerId[i] > 0  and not self.m_tData.playerReady[i] then
            return false
        end
    end
    return true
end

function SceneWorldTeamBossRoom:_updateCheckPlayerState(element,dt)
    --发送心跳协议
    if self.m_fShakeHands == nil then
        self.m_fShakeHands = 0;
    end
    if os.time() - self.m_fShakeHands > BattleConstants.g_fShakeHandsTime and NetManager.g_bConnectFailed ~= true then
        self.m_fShakeHands = os.time()
        WZLog("send battle handshake=================")
        ProtocolProcessorBattleInterface:send_SYSTEM_BattleShakeHands(0)
    end
    if self.m_tData == nil then return end 

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
function SceneWorldTeamBossRoom:joinVoice()
    if self.m_bIsTryJoinVoice ~= true then
        GlobalGame.m_sVoiceRoomName = "room_" .. self.m_tData.roomChannel .. "_" .. self.m_tData.battleMode .. "_" .. self.m_tData.roomId
        local isOk =  WGCloudVoiceNotify:JoinTeamRoom(GlobalGame.m_sVoiceRoomName)
        WZLog("SceneWorldTeamBossRoom:joinVoice", GlobalGame.m_sVoiceRoomName, isOk, type(isOk))
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
function SceneWorldTeamBossRoom:quitVoice()
    WZLog("SceneWorldTeamBossRoom:quitVoice", GlobalGame.m_sVoiceRoomName)
    if GlobalGame.m_sVoiceRoomName == nil then return end
    WGCloudVoiceNotify:QuitRoom(GlobalGame.m_sVoiceRoomName)
    GlobalGame.m_sVoiceRoomName = nil
    GlobalGame.m_nVoiceId = nil
end

--@brief    语音聊天室成员状态回调
--0 停止说话
--1 开始说话
--2 继续说话
function SceneWorldTeamBossRoom:voiceMemberState(state)
    WZLog("SceneWorldTeamBossRoom:voiceMemberState one", Serialize(state))
    local index = -1
    for j=1,state.count do
        for i,v in pairs(self.m_tVoiceId) do
            local offset = (j-1) * 2
            WZLog("SceneWorldTeamBossRoom:voiceMemberState two-0", j, i, offset)
            if v == state.members[1 + offset] then
                index = i
                WZLog("SceneWorldTeamBossRoom:voiceMemberState three", state.members[2 + offset])

                if SceneWorldTeamBossRoom.m_tMicState[index] == 1 then
                    local conCenter = GetElement(self.m_root,"conCenter_SceneWorldTeamBossRoom",WZUIContainer)
                    
                    local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneWorldTeamBossRoom",WZUIContainer)
                    local anim = GetElement(conSeat,"animFigureVoice_SceneWorldTeamBossRoom",WZUISpine)
                    local img = GetElement(conSeat,"imgFigureVoice_SceneWorldTeamBossRoom",WZUIImage)
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
function SceneWorldTeamBossRoom:openVoiceTimer()
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
function SceneWorldTeamBossRoom:closeVoiceTimer()
    self.m_nVoiceTimer = 0
end

--@brief    听筒按钮点击后的Lua回调
function SceneWorldTeamBossRoom:onClickSpeaker(sender, state, isNoSend)

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
        GetElement(self.m_root,"imgSpeaker1_SceneWorldTeamBossRoom",WZUIImage):setGrayRender(false)
        GetElement(self.m_root,"imgSpeaker2_SceneWorldTeamBossRoom",WZUIImage):setGrayRender(false)
    else
        WGCloudVoiceNotify:CloseSpeaker()
        GetElement(self.m_root,"imgSpeaker1_SceneWorldTeamBossRoom",WZUIImage):setGrayRender(true)
        GetElement(self.m_root,"imgSpeaker2_SceneWorldTeamBossRoom",WZUIImage):setGrayRender(true)
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

function SceneWorldTeamBossRoom:onClickSpeakerCall(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        local data = WZDataFile:getInstance():getUserData()
        if data then        
            data:setStringValue("TalkData", "playTalk", "0")
            data:flush()
        end
        self:onClickSpeaker(true)
    end
end

function SceneWorldTeamBossRoom:onClickMicCall(nId, nResType)
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
function SceneWorldTeamBossRoom:onClickMic(sender, state, isNoSend)

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
        GetElement(self.m_root,"imgMic1_SceneWorldTeamBossRoom",WZUIImage):setGrayRender(false)
        GetElement(self.m_root,"imgMic2_SceneWorldTeamBossRoom",WZUIImage):setGrayRender(false)
    else
        WGCloudVoiceNotify:CloseMic()
        GetElement(self.m_root,"imgMic1_SceneWorldTeamBossRoom",WZUIImage):setGrayRender(true)
        GetElement(self.m_root,"imgMic2_SceneWorldTeamBossRoom",WZUIImage):setGrayRender(true)
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
function SceneWorldTeamBossRoom:checkVoice()
    local isVoice = false
    WZLog("SceneWorldTeamBossRoom:checkVoice", self.m_tData.roomChannel)
    if self:checkVoiceChannelLv(self.m_tData.roomChannel) then
        isVoice = true
    end
    self.m_bIsVoice = isVoice

    if isVoice then
        self.m_tVoiceId = {}
        self.m_tVoiceState = {}
        self.m_tMicState = {}
    else
        GetElement(self.m_root,"btnSpeaker_SceneWorldTeamBossRoom",WZUIButton):setVisible(false)
        GetElement(self.m_root,"btnMic_SceneWorldTeamBossRoom",WZUIButton):setVisible(false)
    end
end

--@brief    检查语音渠道和等级
function SceneWorldTeamBossRoom:checkVoiceChannelLv(channel)
    local isShow = false
    local battleMode = self.m_tData.battleMode
    WZLog("SceneWorldTeamBossRoom:checkVoiceChannelLv", channel, battleMode, CheckTalkButtonShow(12))
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

--@brief 	设置boss信息
function SceneWorldTeamBossRoom:setBossInfo()
	-- body
    if self.m_tData == nil then return end 
    if self.m_nMaxBlood == nil then return end 

	local nBossId = self.m_tData.mapId 

	local bossData = GDatatab_team_world_boss_map["id_" .. nBossId]
	local hp = self.m_nMaxBlood
	local progBossBlood = GetElement(self.m_root, "progBossBlood_SceneWorldTeamBossRoom", WZUIProgress)
	if progBossBlood then
		progBossBlood:setPercentage(math.floor(self.m_nBossCurBlood * 100 / hp))
	end
	--血量
	local txtBossBlood = GetElement(self.m_root, "txtBossBlood_SceneWorldTeamBossRoom", WZUILabelTTF)
	if txtBossBlood then
		txtBossBlood:setText(self.m_nBossCurBlood .. "/" .. hp)
	end
	--等级
	local txtLv = GetElement(self.m_root, "txtLv_SceneWorldTeamBossRoom", WZUILabelTTF)
	if txtLv then
		txtLv:setText(LocalStrings.LV .. GDatatab_monster["id_"..bossData.monster[1][1]].level)
	end
    --地图
    -- local imgMapBg = GetElement(self.m_root, "imgMapBg_SceneWorldTeamBossRoom", WZUIImage)
    -- if imgMapBg then 
    --     imgMapBg:setFile("map/" .. self:_getMapBgById())
    -- end

	self.m_conBossInfo:enableSchedule("refleshBossBlood", 10)
end

--@brief    跳转主城按钮回调
function SceneWorldTeamBossRoom:onBtnJumpCity(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local scene = SceneCity:createElement()
    replaceScene(scene)
end

--@brief 	定时刷新boss血量
function SceneWorldTeamBossRoom:refleshBossBlood(element)
	-- body
	ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetTeamWorldBossHp()
end

--@brief 	创建怪物形象
function SceneWorldTeamBossRoom:_buildGuai()
	-- body
	local conMoster = GetElement(self.m_root, "conMonster_SceneWorldTeamBossRoom", WZUIContainer)
	if conMoster:getChildByTag(44) then
		conMoster:removeChildByTag(44, true)
	end
	local mapId = self.m_tData.mapId
	local bossData = GDatatab_team_world_boss_map["id_" .. mapId]
	local guaiTable = WMonster
    guai = (guaiTable and guaiTable:buildGuai(bossData.monster[1][1],GDatatab_monster["id_"..bossData.monster[1][1]].scale,false))
    guai:getShopAnimation():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    guai:getShopAnimation():setRelativePosition(GlobalMethod:ccp(0.5, 0))
    if mapId == 10007 or mapId == 10008 or mapId == 10009 or mapId == 10010 then
        guai:getShopAnimation():play("wait_1", true)
    else
        guai:getShopAnimation():play("wait", true)
    end
    guai:getShopAnimation():setScale(bossData.scale/100)
    conMoster:addChild(guai:getShopAnimation(), 0, 44)

    local txtMonsterName = GetElement(self.m_root, "txtMonsterName_SceneWorldTeamBossRoom", WZUILabelTTF)
    if txtMonsterName then
    	txtMonsterName:setText(bossData.map_name)
    end
end

--@brief    初始化鼓励按钮
function SceneWorldTeamBossRoom:_initInspineBtn()
    -- body
    self:_updateGoldBtn()
    self:_updateDiamondBtn()
end
-- 更新金币鼓舞按键
function SceneWorldTeamBossRoom:_updateGoldBtn()
    -- 金币鼓舞按键
    local ftbCdGold = GetElement(self.m_root,"ftbCDGold_SceneWorldTeamBossRoom",WZUIFreeTextBox)
    local txtCdGold = GetElement(self.m_root,"txtCDGold_SceneWorldTeamBossRoom",WZUILabelTTF)

    txtCdGold:setVisible(true)
    ftbCdGold:setVisible(false)
    txtCdGold:setText(LocalStrings.MAYBE_SUCCESS_SCENEWORLDBOSS)

    local txtCost = GetElement(self.m_root,"ftxtGoldCost_SceneWorldTeamBossRoom",WZUIFreeTextBox)
    local data =  GDatatab_team_world_boss_encouraging["id_2"]
    local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="22" P="1" SC="128,54,13" SS="4" SE="1">%d</T>]]
    txtCost:setShowText(string.format(sFormat,GDatatab_item["id_" .. data.type].icon,data.cost))
end

-- 更新钻石鼓舞按键
function SceneWorldTeamBossRoom:_updateDiamondBtn()
    -- 钻石鼓舞按键
    local txtCost = GetElement(self.m_root,"ftxtDiaCost_SceneWorldTeamBossRoom",WZUIFreeTextBox)
    local data =  GDatatab_team_world_boss_encouraging["id_1"]
    local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="22" P="1" SC="128,54,13" SS="4" SE="1">%d</T>]]
    txtCost:setShowText(string.format(sFormat, GDatatab_item["id_" .. data.type].icon, data.cost))
end

--@brief    设置宝箱位置
function SceneWorldTeamBossRoom:_setBoxPosition()
    -- body
    for i = 1, 3 do
        local conRewardBox = GetElement(self.m_root, "conRewardBox" .. i .. "_SceneWorldTeamBossRoom", WZUIContainer)
        if conRewardBox then
            conRewardBox:setRelativePosition(GlobalMethod:ccp(1 - self.m_tSysConfig["stage" .. i]/100, 1.9))
        end
    end
end

--@brief    剩余挑战次数
function SceneWorldTeamBossRoom:_setLeftTimes()
    -- body
    local txtLeftTimes = GetElement(self.m_root, "txtLeftTimes_SceneWorldTeamBossRoom", WZUILabelTTF)
    if txtLeftTimes then
        txtLeftTimes:setText(LocalStrings.CHALLENGE_SURPLUS_COUNT .. self.bossRoomInfo.leftNum .. "/" .. self.m_tSysConfig.freeNum)
    end
end

--@brief    显示榜单第一名的信息
function SceneWorldTeamBossRoom:_showFirstRankInfo()
    -- body
    if self.hurtInfo == nil or #self.hurtInfo == 0 then 
        GetElement(self.m_root, "conFirstRank_SceneWorldTeamBossRoom", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "txtNoRank_SceneWorldTeamBossRoom", WZUILabelTTF):setVisible(true)
        GetElement(self.m_root, "txtNoRank_SceneWorldTeamBossRoom1", WZUILabelTTF):setVisible(true)
        return 
    end
    GetElement(self.m_root, "conFirstRank_SceneWorldTeamBossRoom", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "txtNoRank_SceneWorldTeamBossRoom", WZUILabelTTF):setVisible(true)
    GetElement(self.m_root, "txtNoRank_SceneWorldTeamBossRoom1", WZUILabelTTF):setVisible(false)

    for i=1,5 do
        local tData = self.hurtInfo[i]
        if tData then
            local head_con = GetElement(self.m_root,"worldTeamBoss_head"..i,WZUIContainer)
            head_con:setVisible(true)
            CellHead:show(head_con, tData.player[1].headId, tData.player[1].faceId, tData.player[1].sex, false, nil, tData.player[1].vipLevel, tData.player[1].headColor)
        end
    end
    --[[
    local tData = self.hurtInfo[1]
    --头像
    for i = 1, #tData.player do
        local conHead = GetElement(self.m_root, "conHead" .. i .. "_SceneWorldTeamBossRoom", WZUIContainer)
        conHead:setVisible(true)
        local cellElement =  CellHead:show(conHead, tData.player[i].headId, tData.player[i].faceId, tData.player[i].sex, false, nil, tData.player[i].vipLevel, tData.player[i].headColor)
        cellElement:setScale(0.9)
    end
    --名字
    local txtPlayerNames = GetElement(self.m_root, "txtPlayerNames_SceneWorldTeamBossRoom", WZUILabelTTF)
    if txtPlayerNames then 
        local count = #tData.player
        if count == 1 then
            txtPlayerNames:setText(tData.player[1].name)
        else
            txtPlayerNames:setText(tData.player[1].name .. "&" .. tData.player[2].name)
        end
    end
    --伤害
    local txtPlayerHurts = GetElement(self.m_root, "txtPlayerHurts_SceneWorldTeamBossRoom", WZUILabelTTF)
    if txtPlayerHurts then 
        txtPlayerHurts:setText(tData.hurt)
    end
    ]]
end
function SceneWorldTeamBossRoom:adaptIphoneX()
    if IsIphoneX() then
        local conRank_SceneWorldTeamBossRoom = GetElement(self.m_root,"conRank_SceneWorldTeamBossRoom",WZUIContainer)
        conRank_SceneWorldTeamBossRoom:setRelativePosition(GlobalMethod:ccp(0.85,0.5))
    end
end
--点击排行榜的头像
function SceneWorldTeamBossRoom:onBtnClickTeamBossHead(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local index = tonumber(element:getTag())
    local tData = self.hurtInfo[index]
    
    if self.hurtInfo and self.hurtInfo[index] and self.hurtInfo[index].player then
        WndCheckOther:show(self.hurtInfo[index].player[1].playerId)
    end
end

--@brief    显示我的伤害加成
function SceneWorldTeamBossRoom:_showMyHurtAdd()
    -- body
    local txtMyHurtAdd = GetElement(self.m_root, "txtMyHurtAdd_SceneWorldTeamBossRoom", WZUILabelTTF)
    if txtMyHurtAdd then 
        txtMyHurtAdd:setText(self.m_nMyInspire/100 .. "%")
    end
end

--@brief    更新房间密码
function SceneWorldTeamBossRoom:_updateRoomSecrit()
    -- body
    local txtRIdNum = GetElement(self.m_root, "txtRIdNum_SceneWorldTeamBossRoom", WZUILabelTTF)
    local txtRMMValue = GetElement(self.m_root, "txtRMMValue_SceneWorldTeamBossRoom", WZUILabelTTF)

    txtRIdNum:setText(self.m_tData.roomId)
    if self.m_tData.passWord ~= "-1" and self.m_tData.passWord ~= "" then
        txtRMMValue:setText(self.m_tData.passWord)
    else
        txtRMMValue:setText(LocalStrings.NO_PASSWORD)
    end
    
end

--@brief    设置技能方案的名字
function SceneWorldTeamBossRoom:setSkillSuitName()
    -- body
    if not CheckButtonOpen(172, false) then return end 
    local tSkillSuit = CacheCenter:getSkillSuit()
    if tSkillSuit == nil then 
        ProtocolProcessorRecycling:send_PLAYERITEM_GetSuit(8)
        return 
    end

    local txtSkillSuitName = GetElement(self.m_root, "txtSkillSuitName_SceneWorldTeamBossRoom", WZUILabelTTF)
    for i = 1, #tSkillSuit do
        if tSkillSuit[i].bIsUsed then 
            txtSkillSuitName:setText(tSkillSuit[i].name .. LocalStrings.SKILLSUIT_TAIL)
            break 
        end
    end
end


--@brief    显示伴侣互动动画
function SceneWorldTeamBossRoom:showCoupleAnimation()
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
function SceneWorldTeamBossRoom:_adaptLanguage_vn( )
    

    GetElement(self.m_root,"ftxtGoldCost_SceneWorldTeamBossRoom",WZUIFreeTextBox):setScale(0.9)

    GetElement(self.m_root, "txtCDGold_SceneWorldTeamBossRoom", WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root, "txtCDDiamond_SceneWorldTeamBossRoom", WZUILabelTTF):setScale(0.9)

    GetElement(self.m_root, "txtMonsterName_SceneWorldTeamBossRoom", WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root, "txtLeftTimes_SceneWorldTeamBossRoom", WZUILabelTTF):setScale(0.8)
    
    local txtCDGold = GetElement(self.m_root,"txtCDGold_SceneWorldTeamBossRoom",WZUILabelTTF)
    txtCDGold:setScale(0.6)
    txtCDGold:setDimensions(GlobalMethod:CCSize(120))
    local txtCDDiamond = GetElement(self.m_root,"txtCDDiamond_SceneWorldTeamBossRoom",WZUILabelTTF)
    txtCDDiamond:setScale(0.6)
    txtCDDiamond:setDimensions(GlobalMethod:CCSize(120))

    local ftxtGoldCost = GetElement(self.m_root,"ftxtGoldCost_SceneWorldTeamBossRoom",WZUIFreeTextBox)
    ftxtGoldCost:setScale(0.7)
    ftxtGoldCost:setRelativePosition(GlobalMethod:ccp(0.5,-0.32))
    local ftxtDiaCost = GetElement(self.m_root,"ftxtDiaCost_SceneWorldTeamBossRoom",WZUIFreeTextBox)
    ftxtDiaCost:setScale(0.7)
    ftxtDiaCost:setRelativePosition(GlobalMethod:ccp(0.5,-0.32))

    local txtNoRank = GetElement(self.m_root, "txtNoRank_SceneWorldTeamBossRoom1", WZUILabelTTF)
    txtNoRank:setRotation(90)

    local txtMyHurtAdd = GetElement(self.m_root, "txtMyHurtAdd_SceneWorldTeamBossRoom", WZUILabelTTF)
    txtMyHurtAdd:setRelativePosition(GlobalMethod:ccp(1.65,0.6))
end

function SceneWorldTeamBossRoom:_adaptLanguage_pt( )
    local ftxtGoldCost = GetElement(self.m_root,"ftxtGoldCost_SceneWorldTeamBossRoom",WZUIFreeTextBox)
    ftxtGoldCost:setScale(0.65)
    local ftxtDiaCost = GetElement(self.m_root,"ftxtDiaCost_SceneWorldTeamBossRoom",WZUIFreeTextBox)
    ftxtDiaCost:setScale(0.65)
end

function SceneWorldTeamBossRoom:_adaptLanguage_es( )
    GetElement(self.m_root, "txtLv_SceneWorldTeamBossRoom", WZUILabelTTF):setScale(0.8)
    local ftxtGoldCost = GetElement(self.m_root,"ftxtGoldCost_SceneWorldTeamBossRoom",WZUIFreeTextBox)
    ftxtGoldCost:setScale(0.65)
    local ftxtDiaCost = GetElement(self.m_root,"ftxtDiaCost_SceneWorldTeamBossRoom",WZUIFreeTextBox)
    ftxtDiaCost:setScale(0.65)
end

function SceneWorldTeamBossRoom:_adaptLanguage_en( )
    local ftxtGoldCost = GetElement(self.m_root,"ftxtGoldCost_SceneWorldTeamBossRoom",WZUIFreeTextBox)
    ftxtGoldCost:setScale(0.65)
    local ftxtDiaCost = GetElement(self.m_root,"ftxtDiaCost_SceneWorldTeamBossRoom",WZUIFreeTextBox)
    ftxtDiaCost:setScale(0.65)
end

function SceneWorldTeamBossRoom:_adaptLanguage_tr( )
    GetElement(self.m_root, "txtRoomPass_SceneWorldTeamBossRoom", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.5))
end
-------------------------------------语言适配end----------------------------------------
