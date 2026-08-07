--WndMultiLose.lua
--@brief	WndMultiLose的UI模块
--@date		2015-11-20
--@author	binshao
--@note		组队副本结算失败


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMultiLose:onEnter(element)
	self.m_root = element
    self:_update()
    WindowManager:getSceneRoot():removeChildByTag(78945, true)
    Protocol:reg( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoomOk, "ProtocolProcessorBossMap:parse_BOSSMAPROOM_EnterRoomOk", "issiiiivbvivivsvivbvivivivivsvivivivivsvsvivissssssvivivivivivivivivivivitvsviviivi")
    if IsIphoneX() then
        local con = GetElement(self.m_root, "conVideo_WndMultiLose", WZUIContainer)
        if con then
            con:setRelativePositionLuaTo(0.97,0.5)
        end
    end
end

function WndMultiLose:onEnterTransitionDidFinish(element)
	if WndGangsterInn.m_bShouldClose == true then
		WndGangsterInn.m_bShouldClose = false
		MsgBoxManager:showTipBox(LocalStrings.INN12)
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMultiLose:onExit(element)
	self:_unInit()
    Protocol:unreg( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoomOk, "ProtocolProcessorBossMap:parse_BOSSMAPROOM_EnterRoomOk", "issiiiivbvivivsvivbvivivivivsvivivivivsvsvivissssssvivivivivivivivivivivitvsviviivi")
end


--@brief	点击返回按钮后的回调
--@param	element:按钮绑定的UI节点
function WndMultiLose:onBack(element)
    WZLog("WndMultiLose:onBack")
    self:backRoom()
end

-- 重播录像
function WndMultiLose:onAgainVideo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    BattleMsgReplayGameRecord:replayRecord()
end

-- 退出录像
function WndMultiLose:onExitVideo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    SceneBattle:leftBattle()
end

--@brief	失败倒计时定时器
--@param	element:定时器绑定的UI节点引用
--@param    delta:时间间隔
function WndMultiLose:scheduleLoseCountdown(element, delta)
    WZLog("---------------fail--------------------",self.m_nCountdown,delta)
    if self.m_root == nil then
        element:disableSchedule()
        return
    end
    self.m_nCountdown = math.max(self.m_nCountdown - 1, 0)
    if self.m_nCountdown <= 0 then
        element:disableSchedule()
        self:backRoom()
    end
end

--@brief	返回
function WndMultiLose:goback()
    WZLog("WndMultiLose:goback")

    if self.m_root == nil then return  end
    self.m_root:disableSchedule()
    WZLog("-------------fight type ==========",WBattleGlobal:getCurrent().battleMode)
    if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_LOVE_STAGE then
        -- ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo()
        -- WndMarryManager:createLoading()
        -- SceneMarryWedding:showInterface()
        -- if WndFriends.m_root == nil then
        --     local wndFriends = WndFriends:createElement()
        --     if WndFriends.m_root then
        --         WndFriends:showMarryWed()
        --     end
        -- else
        --     WndFriends:showMarryWed()
        -- end
        local sceneCity = SceneCity:createElement()
        replaceScene(sceneCity)
        WndCouple:showInterface(1)
    else
        SceneCopy:showScene(2)
    end
    g_bIsShowWndDressUp = true
end

--@brief	返回房间
function WndMultiLose:backRoom()
    WZLog("-----------------WndMultiLose back room----------------------",WBattleGlobal:getCurrent():getMyRoomId(),WBattleGlobal:getCurrent().m_tMakePairOk.mapId)

    if self.isVideo then
        local con = GetElement(self.m_root, "conVideo_WndMultiLose", WZUIContainer)
        con:setVisible(true)
    else
        g_bIsShowWndDressUp = true
        self.m_bCanBackRoom = true
        ProtocolProcessorSceneBattle:send_BOSSMAPROOM_BackToRoom( WBattleGlobal:getCurrent():getMyRoomId(),WBattleGlobal:getCurrent().m_tMakePairOk.mapId )
    end
end

-- -----------------------------------公有方法模块End----------------------------------------

-- -----------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function WndMultiLose:_update()
    if self.m_root == nil or self.m_tData == nil then  return end
    SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_LOSE)
    self:_updateLoseUI()
end

--@brief	更新玩家列表
--@param    conParent, 父亲节点
--@param    tPlayerList, 玩家数据列表
function WndMultiLose:_updatePlayerFigure(conParent, tPlayerList, bFail)
    local tPlayerList = {}
    for i = 1, #self.m_tData.playerIds do
        if self.m_tData.playerIds[i] > 0 then
            table.insert(tPlayerList, self:_getPlayerSettlementData(i))
        end
    end

    local CONPLAYER_SIZE = {width=166,height=288}
    local INTERVAL_X = 0

    local conPlayer = GetElement(conParent, "conPlayerFail_WndMultiLose")
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
function WndMultiLose:_createPlayerFigure(tData)
    WZLog("WndMultiLose:_createPlayerFigure")
    local tEquip = {tData.faceId, tData.headId, tData.bodyId, tData.wingId, tData.weaponId}
    local aniPlayer = CreatePlayerFigure(tData.sex, tEquip, "failure",nil,nil,nil,nil,nil,false,nil,tData.headColor,tData.bodyColor)
    aniPlayer:setScale(1)
    -- aniPlayer:getAnimNode():setRelativePositionLuaTo(0.5, 0.5)

    local cellPlayer = CreateElement("CellPlayer_WndMultiLose")
    if tData.id == CacheCenter:getPlayerInfo().id then --and tData.isWin
        local armBase = GetElement(cellPlayer, "armBase_WndMultiLose")
        armBase:setVisible(true)
    end
    local tmpCon = WZUIContainer:create()
    tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.4))
    tmpCon:setUseAbsSize(true)
    tmpCon:setAbsContentSize(GlobalMethod:CCSize(150,150))
    tmpCon:addChild(aniPlayer:getAnimNode())

    cellPlayer:addChild(tmpCon)

    return cellPlayer
end

---------------------------------------胜利ui----------------------------------


---------------------------------------失败ui----------------------------------
--@brief	更新失败的界面ui
function WndMultiLose:_updateLoseUI()
    local conLose = GetElement(self.m_root, "conLose_WndMultiLose")
    self.m_nCountdown = 6
    conLose:enableSchedule("scheduleLoseCountdown", 1)

    local tPlayerList = {}
    for i = 1, #self.m_tData.playerIds do
        if self.m_tData.playerIds[i] > 0 then
            table.insert(tPlayerList, self:_getPlayerSettlementData(i))
        end
    end
    self:_updatePlayerFigure(conLose, tPlayerList, true)
end
-------------------------------------私有方法模块End----------------------------------------
