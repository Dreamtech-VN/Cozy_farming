--WndMultiWin.lua
--@brief	WndMultiWin的UI模块
--@date		2015-11-20
--@author	binshao
--@note		组队副本结算胜利


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMultiWin:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    if ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1051 
        or ProjConfig.CHANNEL_ID == 1053 then
        GetElement(self.m_root,"btnFBShare_WndMultiWin",WZUIButton):setVisible(true)
    end
    WZLog("self.m_tData-------------------",self.m_tData)
    self:_update()
    WindowManager:getSceneRoot():removeChildByTag(78945, true)
    Protocol:reg( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoomOk, "ProtocolProcessorBossMap:parse_BOSSMAPROOM_EnterRoomOk", "issiiiivbvivivsvivbvivivivivsvivivivivsvsvivissssssvivivivivivivivivivivitvsviviivi")

    if IsIphoneX() then
        local con = GetElement(self.m_root, "conVideo_WndMultiWin", WZUIContainer)
        if con then
            con:setRelativePositionLuaTo(0.97,0.5)
        end
    end
end

function WndMultiWin:onEnterTransitionDidFinish(element)
	if WndGangsterInn.m_bShouldClose == true then
		WndGangsterInn.m_bShouldClose = false
		MsgBoxManager:showTipBox(LocalStrings.INN12)
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMultiWin:onExit(element)
	self:_unInit()
    Protocol:unreg( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoomOk, "ProtocolProcessorBossMap:parse_BOSSMAPROOM_EnterRoomOk", "issiiiivbvivivsvivbvivivivivsvivivivivsvsvivissssssvivivivivivivivivivivitvsviviivi")
end

--@brief    战斗胜利之后分享到facebook
function WndMultiWin:onFBShare( element )
    local content
    for k,v in pairs(GDatatab_team_map) do
        if v.id == WBattleGlobal:getCurrent().m_tMakePairOk.mapId then
            content = v.map_name
            break
        end
    end

    SetFBShareByPackage(2, content)
end

--@brief	点击返回按钮后的回调
--@param	element:按钮绑定的UI节点
function WndMultiWin:onBack(element)
    WZLog("WndMultiWin:onBack")
    self:backRoom()
end

--@brief	点击卡牌时被调用的函数
--@param	tCard:卡牌绑定的UI节点引用
function WndMultiWin:onClickCard(tCard)
    WZLog("-------------------onClickCard------------------",tCard)
    local nType = tCard:getType()
    local nVipLevel = CacheCenter:getPlayerInfo().vipLevel
    local nDiamond = 0
    if CacheCenter:getGameParam().isUseTicket == "0" then 
        nDiamond = CacheCenter:getPlayerItemCountById(70)
    end
    local itemId,num = SplitItemString(CacheCenter:getGameParam().awakenFlop)
    local nDiamond2 = CacheCenter:getMoneyList().blueDiamond
    local mulcopyData = GDatatab_team_map["id_" .. WBattleGlobal:getCurrent().m_tMakePairOk.mapId]
    local awakenFlop = num[1] or 10
    if mulcopyData.difficulty == 4 then 
        awakenFlop = tonumber(num[2]) or 50
    end
    if nType == 2 and nVipLevel < 5 and not whetherHaveWelfareCard() and g_nMyAssistState == 0 then --vip免费翻牌 vip等级不足
        MsgBoxManager:showTipBox(LocalStrings.TURNCARD_VIP_NEWTIPS)
    elseif nType == 3 and not DiamondIsEnoughNum(math.ceil(awakenFlop * self.m_tData.flopRebate/100)) and g_nMyAssistState == 0 then --钻石翻牌 钻石不足
        MsgBoxManager:showTipBox(LocalStrings.TURNCARD_DIAMOND_TIPS)
    else
        if nType == 1 then
            if not self.m_bCard1Flag then
                self:flipCard(tCard, CacheCenter:getPlayerInfo().id)
            end
        elseif nType == 2 then
            if not self.m_bCard2Flag then
                self:flipCard(tCard, CacheCenter:getPlayerInfo().id)
            end
        else
            self:flipCard(tCard, CacheCenter:getPlayerInfo().id)
        end
    end
end


-- 重播录像
function WndMultiWin:onAgainVideo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    BattleMsgReplayGameRecord:replayRecord()
end

-- 退出录像
function WndMultiWin:onExitVideo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    SceneBattle:leftBattle()
end


--@brief	成功倒计时定时器
--@param	element:定时器绑定的UI节点引用
--@param    delta:时间间隔
function WndMultiWin:scheduleWinCountdown(element, delta)
    if self.m_root == nil then
        element:disableSchedule()
        return
    end
    self.m_nCountdown = math.max(self.m_nCountdown - 1, 0)

    for i = 1, #self.m_tWaitTime do
        self.m_tWaitTime[i] = self.m_tWaitTime[i] - delta
    end
    --发射特效
    if self.m_tWaitTime[1] <= 0 and self.m_tWaitTime[1] > -99 then
        self.m_tWaitTime[1] = -99
        self:_playPerfect(1)
    end
    --落下特效
    if self.m_tWaitTime[2] <= 0 and self.m_tWaitTime[2] > -99 then
        self.m_tWaitTime[2] = -99
        self:_playPerfect(2)
    end
    --奖励框动画
    if self.m_tWaitTime[3] <= 0 and self.m_tWaitTime[3] > -99 then
        self.m_tWaitTime[3] = -99
        self.m_tCellSettlmentObjs = self.m_tCellSettlmentObjs or {}
        for i = 1, #self.m_tCellSettlmentObjs do
            self.m_tCellSettlmentObjs[i]:setDelayDisplayTime((i-1)*0.5)
        end
    end

    if self.m_nCountdown <= 0 then
        element:disableSchedule()
        if self.isVideo then
            local con = GetElement(self.m_root, "conVideo_WndMultiWin", WZUIContainer)
            con:setVisible(true)
        else
            element:setVisible(false)
            if ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1051 or ProjConfig.CHANNEL_ID == 1053 then
                GetElement(self.m_root,"btnFBShare_WndMultiWin",WZUIButton):setVisible(true)
            end
            self:_updateTurnCardUI()
        end
    end
end


--@brief	翻牌倒计时定时器
--@param	element:定时器绑定的UI节点引用
--@param    delta:时间间隔
function WndMultiWin:scheduleTurnCardCountdown(element, delta)
    if self.m_root == nil then
        element:disableSchedule()
        return
    end
    self.m_nCountdown = math.max(self.m_nCountdown - 1, 0)
    self:_updateTurnCardBackTime()
    if self.m_nCountdown <= 0 then
        element:disableSchedule()
        local bBackFlag = true
        if self.m_bCard1Flag == false then --第一张牌未翻
            WZLog("---------------AUTO --------------------self.m_bCard1Flag")
            self:playerFlipCard(CacheCenter:getPlayerInfo().id, 1)
            bBackFlag = false
        end
        if self.m_bCard2Flag == false and (CacheCenter:getPlayerInfo().vipLevel >= 5 or g_nMyAssistState == 1 or whetherHaveWelfareCard()) then
            WZLog("---------------AUTO --------------------self.m_bCard2Flag")
            self:playerFlipCard(CacheCenter:getPlayerInfo().id, 2)
            bBackFlag = false
        end
        if self.m_bCard3Flag == false and g_nMyAssistState == 1 then 
            self:playerFlipCard(CacheCenter:getPlayerInfo().id, 3)
            bBackFlag = false
        end
        if bBackFlag then
            self:goback()
        else
            self.m_root:enableSchedule("goback",1.5)
        end
    end
end

--@brief    根据玩家id翻牌
--@param    nPlayerId, 玩家id
--@param    nIndex, 翻牌序号 1免费翻牌，2VIP翻牌，3钻石翻牌
function WndMultiWin:playerFlipCard(nPlayerId, nIndex)
    if self.m_root == nil or nIndex > 3 then
        return
    end
    if self.m_tFlipCardFlag[nPlayerId] == nil then self.m_tFlipCardFlag[nPlayerId] = {} end
    WZLog("----------------have player flip card-----------------",nPlayerId,nIndex)
    if utilsValueInTable(nIndex, self.m_tFlipCardFlag[nPlayerId]) then 
        return 
    else
        table.insert(self.m_tFlipCardFlag[nPlayerId], nIndex)
    end
    local tValidIndex = {}
    for i = nIndex*3 - 2, nIndex*3 do
        local nState = self.m_tCardObjList[i]:getState()
        if nState == 0 then
            table.insert(tValidIndex, i)
        end
    end
    local index = math.random(1, #tValidIndex)
    for i = 1, #self.m_tCardObjList do
        local info = self.m_tCardObjList[i]
        if info.m_nType == nIndex then
            WZLog("------------------card info-----------------","data = ",info,"type = ",info.m_nType,"state = ",info.m_nState)
        end
    end
    WZLog("-------------cardListInfo-------","randomIndex = ",index,"listIndex = ",tValidIndex[index],"data = ",self.m_tCardObjList[tValidIndex[index]],"state = ",self.m_tCardObjList[tValidIndex[index]].m_nType,"playerId = ",nPlayerId)
    local tCard = self.m_tCardObjList[tValidIndex[index]]
    self:flipCard(tCard, nPlayerId)
end

--@brief    翻牌
--@param    tCard,卡牌绑定的lua表对象
--@param    nId, 玩家id
function WndMultiWin:flipCard(tCard, nId)
    if tCard == nil or self.m_tData == nil then
        WZLog("!!!!!!WndMultiWin:flipCard data error!!!!!!")
        return
    end
    WZLog("--------------------flipCardInfo-------------------","data = ",tCard,"curId = ",nId,"selfId = ",CacheCenter:getPlayerInfo().id,"CardState = ",tCard.m_nState)
    local tData = self:_getPlayerSettlementDataById(nId)
    tCard:setData(tData)
    tCard:flipCard()

    if nId == CacheCenter:getPlayerInfo().id then
        local nType = tCard:getType()
        for i = (nType-1)*3+1, nType*3 do
            self.m_tCardObjList[i]:setTouchEnable(false)
        end
        if nType == 1 then
            self.m_bCard1Flag = true
        elseif nType == 2 then
            self.m_bCard2Flag = true
        elseif nType == 3 then
            self.m_bCard3Flag = true
        end
        ProtocolProcessorSceneBattle:send_BOSSMAPROOM_Reward(nType)
    end
end

--@brief	返回
function WndMultiWin:goback()
    WZLog("WndMultiWin:goback")
    if self.m_root == nil then
        return
    end
    self.m_root:disableSchedule()
    WZLog("-------------fight type ==========",WBattleGlobal:getCurrent().battleMode)
    -- if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_LOVE_STAGE then
    --     ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo()
    --     WndMarryManager:createLoading()
    -- else
        self:backRoom()
        -- return
        -- SceneCopy:showScene(2)
    -- end
    --弹穿上或打开提示窗口
    -- pushEquipInList()
    -- g_bIsShowWndDressUp = true
end

--@brief	返回房间
function WndMultiWin:backRoom()
    WZLog("-----------------WndMultiWin back room----------------------",WBattleGlobal:getCurrent():getMyRoomId(),WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
    self.m_bCanBackRoom = true
    ProtocolProcessorSceneBattle:send_BOSSMAPROOM_BackToRoom( WBattleGlobal:getCurrent():getMyRoomId(),WBattleGlobal:getCurrent().m_tMakePairOk.mapId )
end

--@brief	货币信息有更新时
function WndMultiWin:updateMoneyData()
    WZLog("WndMultiWin:updateMoneyData")
    if not self.m_root then return end
    self:_updateDiamond()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新界面
function WndMultiWin:_update()
    WZLog("--------------self.m_tData--------------",self.m_tData)
    if not self.m_root or not self.m_tData  then  return end
     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN)
    -- if WBattleGlobal:getCurrent():getMyHero().m_nBoyOrGirl == 0 then
    --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_BOY,false,true)
    -- else
    --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_GIRL,false,true)
    -- end
    self:_updateWinUI()
    --越南副本胜利弹商店评分
    local nStarNum = self:_getCopyLocalData().difficulty
    if nStarNum == 3 or nStarNum == 4 then 
        ShowStoreRating()
    end
end

--@brief	更新玩家列表
--@param    conParent, 父亲节点
--@param    tPlayerList, 玩家数据列表
function WndMultiWin:_updatePlayerFigure(conParent, tPlayerList, bFail)
    local tPlayerList = {}
    WZLog("#self.m_tData.playerIds-------------------",#self.m_tData.playerIds)
    for i = 1, #self.m_tData.playerIds do
        if self.m_tData.playerIds[i] > 0 then
            table.insert(tPlayerList, self:_getPlayerSettlementData(i))
        end
    end

    local CONPLAYER_SIZE = {width=166,height=288}
    local INTERVAL_X = 0

    local conPlayer = GetElement(conParent, "conPlayer_WndMultiWin")
    local size = conPlayer:getContentSize()
    local cellW,cellH = 180,250
    for i = 1, #tPlayerList do
        local cellPlayer = self:_createPlayerFigure(tPlayerList[i])
        conPlayer:addChild(cellPlayer)
        cellPlayer:setPosition((i-1)*cellW,size.height/2)
    end

    conPlayer:setContentSize(CCSize(#tPlayerList*cellW,size.height))
    conPlayer:setRelativePosition(GlobalMethod:ccp(0.5,0.28))
end

--@brief	创建玩家形象
function WndMultiWin:_createPlayerFigure(tData)
    WZLog("WndMultiWin:_createPlayerFigure")
    local tEquip = {tData.faceId, tData.headId, tData.bodyId, tData.wingId, tData.weaponId}
    local aniPlayer = CreatePlayerFigure(tData.sex, tEquip, "win",nil,nil,nil,nil,nil,nil,nil,tData.headColor,tData.bodyColor)
    aniPlayer:setScale(1)
    -- aniPlayer:getAnimNode():setRelativePositionLuaTo(0.5, 0.07)

    local cellPlayer = CreateElement("CellPlayer_WndMultiWin")
    if tData.id == CacheCenter:getPlayerInfo().id then --and tData.isWin
        local armBase = GetElement(cellPlayer, "armBase_WndMultiWin")
        armBase:setVisible(true)
    end

    local tmpCon = WZUIContainer:create()
    tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.4))
    tmpCon:setUseAbsSize(true)
    tmpCon:setAbsContentSize(GlobalMethod:CCSize(150,150))
    tmpCon:addChild(aniPlayer:getAnimNode())

    cellPlayer:addChild(tmpCon)

    -- cellPlayer:addChild(aniPlayer:getAnimNode())

    return cellPlayer
end

---------------------------------------胜利ui----------------------------------
--@brief	更新胜利的界面ui
function WndMultiWin:_updateWinUI()
    WZLog("WndMultiWin:_updateWinUI")
    local conWin = GetElement(self.m_root, "conWin_WndMultiWin")
    self.m_nCountdown = 7
    self.m_tWaitTime = {1, 2, 3, 6}
    conWin:enableSchedule("scheduleWinCountdown", 1)
    self:_updateStar()
    local tPlayerList = {}
    for i = 1, #self.m_tData.playerIds do
        if self.m_tData.playerIds[i] > 0 then
            table.insert(tPlayerList, self:_getPlayerSettlementData(i))
        end
    end
    self:_updatePlayerFigure(conWin, tPlayerList)
    self:_updatePlayerSettlement(tPlayerList)
    self:_createCard()
end

--@brief	更新星星数
function WndMultiWin:_updateStar()
    local nStarNum = self:_getCopyLocalData().difficulty
    local spine = GetElement(self.m_root, "winSpine_WndMultiWin", WZUISpine)
    if nStarNum < 1 or nStarNum > 4 then
        return
    end
    local aniName = {"easy","hard","hell","juexing"}
    self.m_sAniWaitName = (aniName[nStarNum]).."_wait"
    spine:play(aniName[nStarNum], false)
    GetElement(self.m_root,"conWinLeft_WndMultiWin",WZUIContainer):enableSchedule("_updateSpine")
end

--@brief 胜利动画
function WndMultiWin:_updateSpine(element,dt)
    if  GetElement(self.m_root, "winSpine_WndMultiWin", WZUISpine):isCurrentAnimationDone() then
        element:disableSchedule()
        GetElement(self.m_root, "winSpine_WndMultiWin", WZUISpine):play(self.m_sAniWaitName,true)
    end
    
end

--@brief	更新玩家结算信息
--@param    tPlayerList, 玩家数据列表
function WndMultiWin:_updatePlayerSettlement(tPlayerList)
    self.m_tCellSettlmentObjs = {}
    for i = 1, #tPlayerList do
        local eCellSettlement, tCellSettlement = CellMultiCopySettlement:createElement()
        self.m_tCellSettlmentObjs[i] = tCellSettlement

        local conSettlement = GetElement(self.m_root, "conSettlement"..i.."_WndMultiWin")
        conSettlement:addChild(eCellSettlement)
        
        tCellSettlement:setData(tPlayerList[i])
    end
end

--@brief  播放三星动画
function WndMultiWin:_playPerfect(tag)
    WZLog("EEEEEEEEEE:_playPerfect", tag)
   local effectFile = {}
   local effectElement = nil
   if tag == 1 then
        effectFile = {"ui_jiesuan_fashelihua_01.plist","ui_jiesuan_fashelihua_02.plist","ui_jiesuan_fashelihua_03.plist","ui_jiesuan_fashelihua_04.plist"}
        effectElement = GetElement(self.m_root, "conFashe_WndMultiWin", WZUIContainer)
   elseif tag == 2 then
        effectFile = {"ui_jiesuan_lihua_01.plist","ui_jiesuan_lihua_02.plist","ui_jiesuan_lihua_03.plist","ui_jiesuan_lihua_04.plist",}
        effectElement = GetElement(self.m_root, "conXialuo_WndMultiWin", WZUIContainer)
   end
   if effectElement == nil then
        return
   end
   for i = 1, 4 do
        local backFire = CCParticleSystemQuad:create("particle/"..effectFile[i])
        backFire:setAutoRemoveOnFinish(true)
        effectElement:addChild(backFire)
   end
end


---------------------------------------翻牌ui----------------------------------
--@brief	更新翻牌的界面ui
function WndMultiWin:_updateTurnCardUI()
    local conTurnCard = GetElement(self.m_root, "conTurnCard_WndMultiWin")
    conTurnCard:setVisible(true)
    self.m_nCountdown = 10
    conTurnCard:enableSchedule("scheduleTurnCardCountdown", 1)

    local tbconCard = GetElement(self.m_root, "tbconCard_WndMultiWin", WZUITableContainer)
    tbconCard:setVisible(true)
    WZLog("---------------_updateTurnCardUI------------------",self.filpCardInfo)

    self:_updateDiamond()
    CacheCenter:registerUpateMoneyObserver(self)
end

-- 优先创建牌
function WndMultiWin:_createCard()
    WZLog("--------------create card----------------")
    self.m_tCardObjList = {}
    local tbconCard = GetElement(self.m_root, "tbconCard_WndMultiWin", WZUITableContainer)
    tbconCard:cleanTable()
    for i = 1, 9 do
        local eCard, tCard = CellSettlementCard:createElement()
        eCard:setTag(i-1)
        if math.ceil(i/3) == 3 then 
            tCard:setDiscount(self.m_tData.flopRebate) --要在setType()之前调用
        end
        tCard:setType(math.ceil(i/3))
        tCard:setClickCallback(function(tClickedCard)
            self:onClickCard(tClickedCard)
        end)
        self.m_tCardObjList[i] = tCard
        tbconCard:setCellElement(eCard)
    end
    tbconCard:setVisible(false)
end

--@brief	更新钻石数量
function WndMultiWin:_updateDiamond()
    local txtDiamond = GetElement(self.m_root, "txtDiamond_WndMultiWin", WZUIFreeTextBox)
    txtDiamond:setVisible(true)
    local sTxt = string.format([[<I>ui/common/common_icon_zuanshi.png</I><T S="22" C="255,255,255" P="1"> %d</T>]], CacheCenter:getPlayerItemCountById(1))
    txtDiamond:setShowText(sTxt)

    local txtTicket = GetElement(self.m_root, "txtTicket_WndMultiWin", WZUIFreeTextBox)
    txtTicket:setVisible(true)
    local sTxtTicket 
    if CacheCenter:getGameParam().isUseTicket == "0" then
        sTxtTicket= string.format([[<I Z="0.7" P ="1">%s</I><T S="22" C="255,255,255" P="1">%d</T>]], GDatatab_item["id_70"].icon, CacheCenter:getMoneyList().ticket)
    else
        sTxtTicket= string.format([[<I Z="0.7" P ="1">%s</I><T S="22" C="255,255,255" P="1">%d</T>]], GDatatab_item["id_1"].icon, CacheCenter:getMoneyList().ticket)
        txtTicket:setVisible(false)
    end
    txtTicket:setShowText(sTxtTicket)

    local txtConsumeAtt = GetElement(self.m_root, "txtConsumeAtt_WndMultiWin", WZUILabelTTF)
    if txtConsumeAtt then
        txtConsumeAtt:setVisible(true)
        if CacheCenter:getGameParam().isUseTicket == "0" then
            txtConsumeAtt:setText(string.format(LocalStrings.CONSUME_FIRST, GDatatab_item["id_70"].name))
        else
            txtConsumeAtt:setText(string.format(LocalStrings.CONSUME_FIRST, GDatatab_item["id_1"].name))
        end
    end
end

--@brief	更新剩余返回时间
function WndMultiWin:_updateTurnCardBackTime()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_WndMultiWin", WZUIFreeTextBox)
    local sTime = string.format(LocalStrings.RESULT_DOWN_TIME2, self.m_nCountdown)
    txtCountdown:setShowText(sTime)
end

function WndMultiWin:event(animation, name, eventName)
    WZLog("WndMultiWin:event-one", name, eventName)
    if name == "event" then
        SoundManager:playEffectSound(SoundDefine.E_S_OVER_STAR)
    end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function WndMultiWin:_adaptLanguage_en()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_WndMultiWin", WZUIFreeTextBox)
    txtCountdown:setScale(0.7)
    txtCountdown:setMaxWidth(420)
end

function WndMultiWin:_adaptLanguage_pt()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_WndMultiWin", WZUIFreeTextBox)
    txtCountdown:setScale(0.7)
    txtCountdown:setMaxWidth(420)
end

function WndMultiWin:_adaptLanguage_es()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_WndMultiWin", WZUIFreeTextBox)
    txtCountdown:setScale(0.7)
    txtCountdown:setMaxWidth(420)
end

function WndMultiWin:_adaptLanguage_th()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_WndMultiWin", WZUIFreeTextBox)
    txtCountdown:setScale(0.7)
    txtCountdown:setMaxWidth(420)
end

function WndMultiWin:_adaptLanguage_vn()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_WndMultiWin", WZUIFreeTextBox)
    txtCountdown:setScale(0.7)
    txtCountdown:setMaxWidth(420)
end

function WndMultiWin:_adaptLanguage_tr()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_WndMultiWin", WZUIFreeTextBox)
    txtCountdown:setScale(0.7)
    txtCountdown:setMaxWidth(420)
end
-------------------------------------语言适配End----------------------------------------