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
    
    self.m_root:enableSchedule("updatePlayerAnimation",1.5)
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
    self:exitRoom()
    self:quitVoice()
    --add by wuweidong
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","SceneBossRoom")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","SceneBossRoom")
    self.m_root:disableSchedule()          
    CacheCenter:unregisterUpateDecorationObserver(self)
    CacheCenter:unregisterUpatePlayerPetInfoObserver(self)
    CacheCenter:unregisterUpateDressSuitObserver(self)
    ProtocolProcessorSceneBossRoom:unregAll() --反注册协议
    self:_unInit()
    IPDConnector.g_nNetConnectFlag = NET_FLAG_2
    
end

function SceneBossRoom:onEnterTransitionDidFinish()
    popSceneEnd()
    --延时显示成就特效
    ShowDelayAchie()
    AdaptLanguage(self)
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
        end
         
    end
    
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

    --self:_exitRoomByAssitOnly() 
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
        self.m_tTopHangle:setTitleFile("ui/common/common_scale9_zuduifb.png")
    else -- 对战赛
        self.m_tTopHangle:setTitleFile("ui/common/common_icon_jingjifangji.png")
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

    local roomName = WZUILabelTTF:luaTo(conTop:getChildElement("txtRoomName_SceneBossRoom"))
    roomName:setText(self.m_tData.roomName)

    local roomId = WZUILabelTTF:luaTo(conTop:getChildElement("txtRoomId_SceneBossRoom"))
    roomId:setText(self.m_tData.roomId)

    local roomPass = WZUILabelTTF:luaTo(conTop:getChildElement("txtRoomPass_SceneBossRoom"))
    if self.m_tData.passWord == "-1" or self.m_tData.passWord == "" then
        roomPass:setText(LocalStrings.NONE)
    else
        roomPass:setText(self.m_tData.passWord)
    end
    
    local mapImage = WZUIImage:luaTo(conTop:getChildElement("imgMapBg_SceneBossRoom"))
    local imgChangeRoomInfo = WZUIImage:luaTo(conTop:getChildElement("imgChangeRoomInfo_SceneBossRoom"))
    mapImage:setFile(self:_getMapBgById())
    imgChangeRoomInfo:setVisible(false)

    GetElement(conTop,"txtMapTitle_SceneBossRoom",WZUILabelTTF):setText(self:_getMapTitleById())

    if self:getIsRoomOwner() then
       imgChangeRoomInfo:setVisible(true)
    end

    self.m_tTopHangle:setTitleFile("ui/common/common_icon_jingjifangji.png")
    
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
        luaObject:setData(curD.wnersId,curD.seatUsed[index],curD.playerId[index],curD.playerName[index],curD.playerLevel[index],curD.playerReady[index],curD.playerSex[index],curD.vipLevel[index],curD.playerTitle[index],curD.fighting[index],curD.playerNumMode,index,-1,curD.battleMode,0,curD.seatUsed,curD.serviceId[index],curD.roomChannel,0,0,0,curD.winTimes[index],curD.joinTimes[index],curD.continuousWinTimes[index],curD.matchscore[index],curD.qualifyingLevel[index],curD.assist[index])
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
    cellObj:setData(curD.wnersId,curD.seatUsed[index],curD.playerId[index],curD.playerName[index],curD.playerLevel[index],curD.playerReady[index],curD.playerSex[index],curD.vipLevel[index],curD.playerTitle[index],curD.fighting[index],curD.playerNumMode,index,-1,curD.battleMode,0,curD.seatUsed,curD.serviceId[index],curD.roomChannel,0,0,0,curD.winTimes[index],curD.joinTimes[index],curD.continuousWinTimes[index],curD.matchscore[index],curD.qualifyingLevel[index],curD.assist[index])
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
        
        local conPet = GetElement(conSeat,"conPet_SceneBossRoom",WZUIContainer)
        
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
        local conForNameAndTitle = GetElement(conSeat, "conForNameAndTitle_SceneBossRoom", WZUIContainer)
        if conForNameAndTitle then
            local txtPlayerName = GetElement(conSeat, "txtPlayerName_SceneBossRoom", WZUILabelTTF)
            txtPlayerName:setText(self.m_tData.playerName[index])
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
        --套装按钮
        if playerId == CacheCenter:getPlayerInfo().id then
            self:_addDressSuit(conSeat)
        end
    else
        local conSeat = GetElement(conCenter,"conSeat" .. index .. "_SceneBossRoom",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_SceneBossRoom",WZUIContainer)
        local conPet = GetElement(conSeat,"conPet_SceneBossRoom",WZUIContainer)
        local conForDressSuit = GetElement(conSeat,"conForDressSuit_SceneBossRoom",WZUIContainer)
        local txtPlayerName = GetElement(conSeat, "txtPlayerName_SceneBossRoom", WZUILabelTTF)
        local txtPlayerLv = GetElement(conSeat, "txtPlayerLv_SceneBossRoom", WZUILabelTTF)
        local txtPlayerTitle = GetElement(conSeat, "txtPlayerTitle_SceneBossRoom", WZUILabelTTF)
        local conTitle = GetElement(conSeat, "conTitle_SceneBossRoom", WZUIContainer)
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

--@brief    创建一个角色动画
function SceneBossRoom:createAPlayer(playerSex,equipment,headColor,bodyColor,animName)
    WZLog("SceneBossRoom:createAPlayer")
    return CreatePlayerFigure(playerSex,equipment,animName,nil,nil,nil,nil,nil,nil,nil,headColor,bodyColor)
end

--@breif  更新玩家的动作
function SceneBossRoom:updatePlayerAnimation(element,delta)

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
function SceneBossRoom:_addDressSuit(element)
    -- body
    if CheckButtonOpen(144, false) then
        local conForDressSuit = GetElement(element, "conForDressSuit_SceneBossRoom", WZUIContainer)
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

-------------------------------------回调方法模块Begin----------------------------------------

-- 点击修改副本信息按钮时的回调
function SceneBossRoom:onChangeInfo(element)
    -- 只有房主才能修改信息
    if (not self:getIsRoomOwner()) then return  end

    WZLog("SceneBossRoom:onChangeInfo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wnd = WndBossRoomSetting:createElement()
    WindowManager:addWindow(wnd, WndBossRoomSetting,true,nil,nil)
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
        cell:setPositionY(ssss.y-50)
    end
end




-- 难度选择
function SceneBossRoom:onCheckBoxDifficult(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    self:changeDifficult(tag)
    self:_setDifCheckBox()
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
    for i = 1, 3 do
        local state = self.checkTag == i and 1 or 0
        local check = WZUICheckBox:luaTo(WZUIElement:luaTo(checkDif:getChildByTag(i)))
        check:setCheckIndex(state)
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
    if nDifficult-1 > self.m_tData.playerStar[selfIndex] then
        if nDifficult == 2 then
            MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_SWITCH_DIFFICULTY_TIPS1)
        elseif nDifficult == 3 then
            MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_SWITCH_DIFFICULTY_TIPS2)
        end
        return
    end
    
    --检查所有玩家星级
    for i=1, #self.m_tData.playerStar do
        if nDifficult-1 > self.m_tData.playerStar[i] and self.m_tData.playerId[i] > 0 then
            MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_SWITCH_DIFFICULTY_TIPS3)
            return
        end
    end

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
function SceneBossRoom:inviteFriend(tFriend,selectIndex,bAssistFight)
    WZLog("SceneBossRoom:inviteFriend ",bAssistFight)
    --音效
    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_Invite(self.m_tData.roomId,tFriend.id,bAssistFight)
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
        WndCheckOther:show(self.m_tData.playerId[nPlayerSeat])
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
-------------------------------------回调方法模块End----------------------------------------


-------------------------------------语言适配器模块Begin--------------------------------------
function SceneBossRoom:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtRoomName_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    GetElement(self.m_root,"txtRoomId_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.5))
    GetElement(self.m_root,"txtRoomPass_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.47,0.5))
    
    GetElement(self.m_root,"txtWorldInvite_SceneBossRoom",WZUILabelTTF):setScale(0.8)
end

function SceneBossRoom:_adaptLanguage_en(  )
    local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneBossRoom",WZUILabelTTF)
    txtRoomName:setRelativePosition(GlobalMethod:ccp(0.56,0.5))
    txtRoomName:setFontSize(18)
    GetElement(self.m_root,"txtRoomId_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.5))
    GetElement(self.m_root,"txtRoomPass_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.47,0.5))

    local txtWorld = GetElement(self.m_root,"txtWorldInvite_SceneBossRoom",WZUILabelTTF)
    txtWorld:setScale(0.7)
    txtWorld:setDimensions(GlobalMethod:CCSize(160,0))
    
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

    local txtWorld = GetElement(self.m_root,"txtWorldInvite_SceneBossRoom",WZUILabelTTF)
    txtWorld:setScale(0.8)
    txtWorld:setDimensions(GlobalMethod:CCSize(130,0))

    GetElement(self.m_root,"txtMapTitle_SceneBossRoom",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(200))

end

function SceneBossRoom:_adaptLanguage_es(  )
    local txtRoomName = GetElement(self.m_root,"txtRoomName_SceneBossRoom",WZUILabelTTF)
    txtRoomName:setRelativePosition(GlobalMethod:ccp(0.77,0.5))
    txtRoomName:setFontSize(16)

    GetElement(self.m_root,"txtRoomId_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.5))
    GetElement(self.m_root,"txtRoomPass_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.5))

    local txtWorld = GetElement(self.m_root,"txtWorldInvite_SceneBossRoom",WZUILabelTTF)
    txtWorld:setScale(0.8)
    txtWorld:setDimensions(GlobalMethod:CCSize(130,0))

    GetElement(self.m_root,"txtRoomNameD_SceneBossRoom",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtMapTitle_SceneBossRoom",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(200))
end

function SceneBossRoom:_adaptLanguage_tr(  )
    local txtWorld = GetElement(self.m_root,"txtWorldInvite_SceneBossRoom",WZUILabelTTF)
    txtWorld:setScale(0.7)
    txtWorld:setDimensions(GlobalMethod:CCSize(160,0))

    GetElement(self.m_root,"txtRoomName_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.400896,0.5))
    GetElement(self.m_root,"txtRoomId_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.519078,0.5))
    GetElement(self.m_root,"txtRoomPass_SceneBossRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.323623,0.5))
end
-------------------------------------语言适配器模块End----------------------------------------


