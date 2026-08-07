--WndTowerScroll.lua
--@brief	WndTowerScroll的UI模块
--@date		2015/06/25
--@author	xiaoyu_wu
--@modify   2015-7-2 qixiang_xie
--@note		爬塔副本主界面


-------------------------------------公有方法模块Begin--------------------------------------
local MAPSIZE = {w=1136,h=640} --地图块大小

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTowerScroll:onEnter(element)
    WZLog("WndTowerScroll:onEnter")
	self.m_root = element

--    SceneCity:updateRedDotBuilding("tower", false)
--    ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(21)
--    GlobalGame.g_tRedPointList.tower = nil

    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    ChangeChatChannel(Chat_Channel_Tower_Copy_Hall)

    self:_initData()

    ProtocolProcessorWndBag:regAll1()

    self:resertMapPos()

    self.m_nScreenSize = CCEGLView:sharedOpenGLView():getFrameSize()
    self.m_nWinSize = CCDirector:sharedDirector():getWinSize()
       
    local width = math.max(self.m_nScreenSize.width/self.m_nScreenSize.height*640,1136)
    local x = width/2
    self.tMapPt = {{x,0},{x,640},{x,1280},{x,1920},}
    self.tMiddlePt = {{x,0},{x,640},{x,1280},{x,1920},}
    ProtocolProcessorSingleMap:regAll()
    if self.m_nTowerType == 1 then 
        self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
        ProtocolProcessorSingleMap:send_MAP_GetHeroTowerData()
        NotificationCenter:registerNotification(UPDATETOWERCOPYDATANOTIFICATION, self, self.updateData2)
        self:_resetMoveContainerSize()
    elseif self.m_nTowerType == 2 then  -- 噩梦塔
        ChangeChatChannel(Chat_Channel_DoubleTower)
        self.m_nLevelSweepT = 5
        self.m_nAddSpeedPrice = 1
        NotificationCenter:registerNotification(UPDATEDOUBLETOWERCOPYDATANOTIFICATION, self, self.updateDoubleTowerData)
        ProtocolProcessorGlobal:send_BOSSMAPROOM_GetTwoTowerInfo()

        --说明按钮
        self:_resetTextPosition()
        --排行榜
        ProtocolProcessorSingleMap:send_BOSSMAPROOM_GetTwoTowerRank()
    else
        ProtocolProcessorSingleMap:send_MAP_GetFriendTowerInfo()
        NotificationCenter:registerNotification(UPDATETOWERCOPYDATANOTIFICATION, self, self.updateData2)

        --说明按钮
        self:_resetTextPosition()
        --排行榜
        ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerRank()
    end

    CacheCenter:registerUpdateDecorationObserver(self) --注册监听玩家装备更换
    CacheCenter:registerUpatePlayerInfoObserver(self)

    SoundManager:playBgMusic(SoundDefine.E_MUSIC_COPY_PAITA)
    
    GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change",'state_hall')

    self:_adaptIphoneX()
end



--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTowerScroll:onExit(element)
    WZLog("WndTowerScroll:onExit")
    if self.m_conScrollMap then 
        self.m_conScrollMap:disableSchedule()
    end
    if self.m_root then 
        self.m_root:disableSchedule()
    end

    CacheCenter:unregisterUpateDecorationObserver(self)
    if self.m_nTowerType == 2 then 
        NotificationCenter:unregisterNotification(UPDATEDOUBLETOWERCOPYDATANOTIFICATION, self)
    else
        NotificationCenter:unregisterNotification(UPDATETOWERCOPYDATANOTIFICATION, self)
        ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerInfo() --退出爬塔副本时重新更新爬塔副本信息
    end
    ProtocolProcessorWndBag:unregAll()
	self:_unInit()
end

function WndTowerScroll:onClick(element,pt)
    local point = self.m_root:getParentElement():convertToNodeSpace(pt)
    local isContainer = self:_clickContainerTips(point)
    if not isContainer then
        if self.m_root:getChildByTag(88) then self.m_root:removeChildByTag(88, true) end
    end
end

-- 点击排名显示排行榜
function WndTowerScroll:onBtnRank(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndTowerRank:showWindow(self.m_nTowerType)
end

--@brief  重置副本,需要重载地图
function WndTowerScroll:onCallBackReset(nType,cost)
    WZLog("------------sure reset-------------",nType,costCount)
    if nType == 2 then return end

    if not JudgeMoneyIsEnough(cost[1][1], cost[1][2], nil, nil, 22, nil, nil, nil, nil, self, self.clickSureMoney) then
        return
    end
    
    self:clickSureMoney()
end

--@brief    点击用钻石代替礼券确认框确定回调
function WndTowerScroll:clickSureMoney()
    self.m_bResert = true
    ProtocolProcessorSingleMap:send_SINGLEMAP_ResetTowerMap()
end

-- 点击重置按键
function WndTowerScroll:onBtnReset()
    WZLog("WndTowerScroll:onBtnReset")
    -- 第一关以前不能重置
    if not self.m_bLoadMapFinish then
        return
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nTowerType == 2 then 
        if self.UserData.helpTimes <= 0 then 
            MsgBoxManager:showTipBox(LocalStrings.DOUBLETOWER_TEXT15)
            return 
        end

        ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(0, "-1", 0, GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DTF)
    else
        if self.m_tMoveDest ~= nil then
            MsgBoxManager:showTipBox(LocalStrings.PLAYER_MOVING)
            return
        end
        -- 重置次数和VIP有关
        local  vipData  = self:_getVipTowerData()
        if vipData == nil then
             MsgBoxManager:showTipBox(LocalStrings.RESET_NOT_ENOUGH)
            return
        end
        local maxTimes = vipData.count
        local curTimes = self.UserData.resetTimes
        if curTimes >= maxTimes then
            MsgBoxManager:showTipBox(LocalStrings.RESET_NOT_ENOUGH)
            return
        end
        local cost = self:_getVipTowerCost(curTimes + 1)
        WndResertConfirm:showConfirmCancelBox(cost,self.UserData.nowFloor, self , self.onCallBackReset )
    end
end

-- 点击扫荡
function WndTowerScroll:onBtnRaids(element)
    WZLog("WndTowerScroll:onBtnRaids")
    -- 如果扫荡次数大于挑战次数，提示挑战次数不足
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local count =  CacheCenter:getRemainAmount()
    if count <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    if not self.m_bLoadMapFinish then
        return
    end
    
    if self.m_nTowerType == 2 then 
        local floorNum = self:wetherCanSweep(self.UserData.nowFloor)
        if self.UserData.topFloor > self.UserData.nowFloor then 
            if floorNum <= 0 then
                MsgBoxManager:showTipBox(LocalStrings.DOUBLETOWER_TEXT14)
                return
            end
        else
            if floorNum <= 0 then 
                MsgBoxManager:showTipBox(LocalStrings.SWEEPING_TIP2)
                return 
            end
        end
        if self.m_tMoveDest ~= nil then
            MsgBoxManager:showTipBox(LocalStrings.PLAYER_MOVING)
            return
        end

        ProtocolProcessorSingleMap:send_BOSSMAPROOM_TwoTowerOperation(2)

        return 
    else
        if self:_getFightNum() >= self.m_nCallengeCount then
            MsgBoxManager:showTipBox(LocalStrings.NO_CHALLENGE_TIMES)
            return
        end
    end
    
    local floorNum = self:wetherCanSweep(self.UserData.nowFloor)
    if floorNum <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.SWEEPING_TIP2)
        return
    end
    if self.m_tMoveDest ~= nil then
        MsgBoxManager:showTipBox(LocalStrings.PLAYER_MOVING)
        return
    end
    -- 发送扫荡消息
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaidsTower()
    SceneCity:updateRedDotBuilding("tower", false)
    ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(21)
    GlobalGame.g_tRedPointList.tower = nil

    local eventData = {stageType = 1,stageId = 4,subStageId = 1,stageCount = 1, playTime = 0,resultType = 2}
    PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
end

--@brief 确定快速扫荡回调
function WndTowerScroll:onCallBackAddSpeed( nId , nType)
    WZLog("------------sure add speed-------------",nType)
    if nType == 2 then return end

    local floorNum = self:wetherCanSweep(self.UserData.nowFloor)
    local needMoney = floorNum * self.m_nAddSpeedPrice
    if CacheCenter:getGameParam().isUseTicket == "0" then
        if not JudgeMoneyIsEnough(70, needMoney, nil, nil, 22, nil, nil, nil, nil, self, self.sureUseDiamondInsteadToSpeed) then 
            return 
        end
    else
        if not JudgeMoneyIsEnough(1, needMoney, nil, nil, 22, nil, nil, nil, nil, self, self.sureUseDiamondInsteadToSpeed) then 
            return 
        end
    end

    self:sureUseDiamondInsteadToSpeed()
end

--@brief    确认用钻石代替礼券加速扫荡
function WndTowerScroll:sureUseDiamondInsteadToSpeed()
    -- body
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    if self.m_nTowerType == 2 then 
        ProtocolProcessorSingleMap:send_BOSSMAPROOM_TwoTowerOperation(3)
    else
        ProtocolProcessorSingleMap:send_SINGLEMAP_CompleteRaidsTower(true)
    end
end

--@brief  是否确定停止扫荡
function WndTowerScroll:onCallBackStopSweeping(nId,nType)
    WZLog("WndTowerScroll:onCallBackStopSweeping")
    if nType == 2 then return end
    if self.m_nTowerType == 2 then 
        ProtocolProcessorSingleMap:send_BOSSMAPROOM_TwoTowerOperation(4)
    else
        ProtocolProcessorSingleMap:send_SINGLEMAP_CompleteRaidsTower(false)
    end
end

--@brief 快速扫荡
function WndTowerScroll:onBtnAddSpeed(element)
    WZLog("WndTowerScroll:onBtnAddSpeed")
    -- 加速按键直接完成扫荡到最高关卡
    if not self.m_bLoadMapFinish then
        return
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local floorNum = self:wetherCanSweep(self.UserData.nowFloor)
    local needMoney = floorNum * self.m_nAddSpeedPrice
    MsgBoxManager:showConfirmBox(string.format(LocalStrings.FAST_SWEEP_TIP,needMoney) , self , self.onCallBackAddSpeed )
end

--@brief 快速扫荡
function WndTowerScroll:onStopSweeping(element)
    WZLog("WndTowerScroll:onStopSweeping")
    -- 加速按键直接完成扫荡到最高关卡
    if not self.m_bLoadMapFinish then
        return
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    MsgBoxManager:showConfirmCancelBox(LocalStrings.STOP_SWEEPING2, self , self.onCallBackStopSweeping )
end


--@brief  查找点击的floor在世界坐标的位置
function WndTowerScroll:findElementWorldPT(element)
    local par = element:getParent()
    local parPar = element:getParent():getParent()
    local ppoint = par:convertToWorldSpace(GlobalMethod:ccp(element:getPositionX(),element:getPositionY()))
    local conScrollMap = GetElement(self.m_root,"conScrollMap_WndTowerScroll",WZUIContainer)
    ppoint = conScrollMap:convertToNodeSpace(ppoint)
    return ppoint
end

--@brief  点击玩家形象
function WndTowerScroll:onClickFHead(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(element:getParent():getTag())
end

--@brief    点击关卡时的回调方法
--@param	element:按钮绑定的UI节点引用
function WndTowerScroll:onClickLevel(element)
    -- 优先判断挑战次数
    WZLog("WndTowerScroll:onClickLevel ")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local count =  CacheCenter:getRemainAmount()
    if count <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    local parElement = WZUIContainer:luaTo(element:getParent())
    local conPlayerFigure = GetElement(parElement,"conPlayerFigure_WndTowerScroll",WZUIContainer)
    local imgLevelPassTag = GetElement(parElement,"imgLevelPassTag_WndTowerScroll",WZUIImage)
    local imgTreasureBox = conPlayerFigure:getChildByTag(1234)
    if not imgTreasureBox  then
        local monsterCon = conPlayerFigure:getChildByTag(1144)
        if not monsterCon:getChildByTag(12345) then
            return
        end
    end

    if imgLevelPassTag:isVisible() then
        return
    end

    local nIndex = parElement:getTag()
    local parNode = parElement
    local ppoint = self:findElementWorldPT(element)
    
    if self.m_nTowerType ~= 1 then 
        if nIndex / 2 <= self.UserData.nowFloor then
            if nIndex % 2 ~= 0 then
                return
            end
        end
        
        if self.SweepState == 1 then
            MsgBoxManager:showTipBox(LocalStrings.TOWER_SWEEPING)
            return
        end

        WZLog("WndTowerScroll:onClickLevel = ",nIndex,self.UserData.nowFloor)
    end
    if self.m_tMoveDest then
        MsgBoxManager:showTipBox(LocalStrings.MOVING)
        return
    end
   
    -- 起点特殊处理,nIndex < 0 表示起点
    if nIndex < 0 then return end
     
    if self.m_nTowerType ~= 1 and self:_checkMoveTo(parNode) then
        local curIndex = self.m_tPlayerStartP:getTag()
        if self.m_nTowerType == 2 then
            if (math.fmod(curIndex, 2) == 0 and curIndex + 1 == nIndex) or (math.fmod(curIndex, 2) == 1 and curIndex + 2 == nIndex) then
                if self.UserData.dareTimes <= 0 then 
                    self:tipToBuyChallengeTimes()
                else
                    local nNextFloor = nIndex
                    if math.fmod(curIndex, 2) == 1 then 
                        nNextFloor = (nIndex + 1)/2
                    else
                        nNextFloor = curIndex + 1
                    end
                    local floorData = WndDoubleTowerRoom:getFloorData(nNextFloor)
                    ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom(floorData.id, "", GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DTF)
                end
            end
        else
            if self:_getFightNum() >= self.m_nCallengeCount then
                MsgBoxManager:showTipBox(LocalStrings.CHALLEGE_OVER)
                return
            end
            self.m_oBeforeFloor  = self.m_tPlayerStartP
            self.m_tPlayerStartP = parNode
            if curIndex + 1 == nIndex then
                self.m_bChallenge = true
                self:_playerMoveTo(nIndex,ppoint,true)
            else
                self.m_bChallenge = false
                local previousFloor = self:findPreviousFloor(self.m_tPlayerStartP)
                local btnLevel = GetElement(previousFloor,"btnLevel_WndTowerScroll",WZUIButton)
                ppoint = self:findElementWorldPT(btnLevel)
                self:_playerMoveTo(nIndex,ppoint,true)
            end
        end
    else
        if parElement ~= self.m_tPlayerStartP then
            if self.m_nTowerType == 1 then 
                self:_checkInfoTipsHero(element, nIndex, ppoint) 
            else
                self:_checkInfoTips(element, nIndex, ppoint)
            end
        else
            WZLog("onclick element equest playerstartelement")
        end
    end
end

--@brief    双人塔挑战次数不足，提示购买
function WndTowerScroll:tipToBuyChallengeTimes()
    -- body
    local vipLimitData = self:_getVipLimitDataTwo()
    --次數已經用完
    if vipLimitData == nil then
        MsgBoxManager:showTipBox(LocalStrings.DOUBLETOWER_TEXT20)
        return 
    end
    --vip等級不夠
    if vipLimitData.vip_level > CacheCenter:getPlayerInfo().vipLevel then 
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
        MsgBoxManager:showConfirmBox(LocalStrings.DOUBLETOWER_TEXT21, self, self.needHigherCallBack, nil, tCustomUIConfig)
        return 
    end

    local icon = GDatatab_item["id_" .. vipLimitData.cost[1][1]].icon
    self.m_tBuyTimesCost = vipLimitData.cost[1]
    local content = string.format(LocalStrings.DOUBLETOWER_TEXT11, vipLimitData.cost[1][2], icon)
    MsgBoxManager:showConfirmBox(content, self, self.sureToBuyChallengeTimes)
end

--@brief    提示提升VIP等級的回调
--@param    nId:消息id
--@param    nResType:响应类型(超时，确定，取消)
function WndTowerScroll:needHigherCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

--@brief    点击确认购买挑战次数回调
function WndTowerScroll:sureToBuyChallengeTimes()
    -- body
    if not JudgeMoneyIsEnough(self.m_tBuyTimesCost[1], self.m_tBuyTimesCost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.surtToUseDiamondInstead) then 
        return 
    end

    self:surtToUseDiamondInstead()
end

--@brief    确定用蓝钻代替粉钻
function WndTowerScroll:surtToUseDiamondInstead()
    -- body
    self.m_nLoadingTag = MsgBoxManager:showLoadingBox()

    ProtocolProcessorSingleMap:send_BOSSMAPROOM_TwoTowerOperation(1)
end


--@brief    扫荡倒计时定时器的回调方法
--@param	element:定时器绑定的UI节点引用
--@param    delta:时间间隔
function WndTowerScroll:scheduleSweepCountdown(element, delta)
    WZLog("WndTowerScroll:scheduleSweepCountdown")
    self.m_nSweepTime = self.m_nSweepTime - 1
    self:_updateSweepState()
    if self.m_nTowerType == 1 then 
        if self.m_nSweepTime <= 0 then
            element:disableSchedule()
            self:_stopFightAnim()
        end
        return 
    end 
    if self.m_nSweepTime <= 0 then
        element:disableSchedule()
        self:_stopFightAnim()
        if self.m_nTowerType == 2 then 
            ProtocolProcessorSingleMap:send_BOSSMAPROOM_TwoTowerOperation(3)
        else
            ProtocolProcessorSingleMap:send_SINGLEMAP_CompleteRaidsTower(false)
        end
    else
        local afFightT = GetElement(self.m_tPlayerSweepCurLP,"afFightT_WndTowerScroll",WZUILabelTTF)
        local tT = afFightT:getText()
        tT = tonumber(tT)
        if tT == 1 then --扫完一层
            self:_stopFightAnim()
            --self:stopSweepSchedule()
            self:setSweepSuccess()
            if self.m_nSweepTime > 0 then
                self.m_oBeforeFloor = self.m_oNextFloor
                self.m_tPlayerStartP = self.m_oNextFloor
                local nextFloor = self:findNextFloor()
                if nextFloor then
                    self.m_oNextFloor = nextFloor
                    self.m_tPlayerSweepCurLP = nextFloor

                    local curIndex = self.m_tPlayerStartP:getTag()
                    local nIndex = self.m_oNextFloor:getTag()
                    local ppoint = nil
                    if curIndex + 1 == nIndex then
                        local btnLevel = nextFloor:getChildElement("btnLevel_WndTowerScroll")
                        self.m_bChallenge = true
                        ppoint = self:findElementWorldPT(btnLevel)
                        self:_playerMoveTo(nextFloor:getTag(),ppoint,true)
                    else
                        self.m_bChallenge = false
                        local previousFloor = self:findPreviousFloor(nextFloor)

                        local btnLevel = GetElement(previousFloor,"btnLevel_WndTowerScroll",WZUIButton)
                        ppoint = self:findElementWorldPT(btnLevel)
                        self:_playerMoveTo(nIndex,ppoint,true)
                    end
                else --走到尽头了,重载地图
                    WZLog("moving end map ")
                    element:disableSchedule()
                    self.m_oBeforeFloor = nil
                    self:_checkMapBlock()
                end
            end
            return
        end
        if tT ~= nil then
            tT = tT -1
            afFightT:setText(tT)
        end
    end
end


--@brief    人物更新定时器的回调方法
--@param	element:定时器绑定的UI节点引用
--@param    delta:时间间隔
function WndTowerScroll:scheduleUpdatePlayer(element, delta)
    WZLog("WndTowerScroll:scheduleUpdatePlayer")
    if self.m_tMoveDest == nil then
        element:disableSchedule()
        self.m_tPlayerAni:play("wait0", true)
        return
    end
    local nSpeed = 6
    local pos = self.m_tPlayerAni:getPosition()
    local nX = pos.x
    local nY = pos.y
    local nDistance =  math.sqrt((nX-self.m_tMoveDest.x)*(nX-self.m_tMoveDest.x) + (nY-self.m_tMoveDest.y)*(nY-self.m_tMoveDest.y))
    
    if nDistance < 1 then
        element:disableSchedule()
        self.m_tMoveDest = nil
        self.m_tPlayerAni:play("wait0", true)
        if self.m_bChallenge then
            self:_changePlayerCurSeat(self.m_tPlayerSweepCurLP)
        end
        self:_checkPlayerCloseToBorder()
        self:_moveDestWillDo()
        --self:checkReloadMap(false)
        return
    end
    local nDeltaX = (self.m_tMoveDest.x-nX)*math.min(nSpeed/nDistance,1)
    local nDeltaY = (self.m_tMoveDest.y-nY)*math.min(nSpeed/nDistance,1)
    self.m_tPlayerAni:setPosition({x=nX+nDeltaX,y=nY+nDeltaY})
    --self.m_tPlayerAni:getAnimNode():setPositionX(nX+nDeltaX)
    --self.m_tPlayerAni:getAnimNode():setPositionY(nY+nDeltaY)
    if self.m_tempNode then
        self.m_tempNode:setVisible(false)
        self.m_tempNode = nil
    end
end

--@brief  如果地图加载完成则初始化玩家形象并把地图移动到玩家所在层
function WndTowerScroll:scheduleMonitorMapLoad(element,delta)
    WZLog("WndTowerScroll:scheduleMonitorMapLoad")
    if self.m_nLoadCount >= self.m_nInitMapCount then
        element:disableSchedule()
        self.m_tFloorInfo = nil
        self:_initPlayerAni()
        self:movingMap()
        --加载完玩家形象，检测是否需要执行扫荡操作
        if self.m_nTowerType == 0 or self.m_nTowerType == 2 then 
            self:checkPlayerStats()
        end
    end
end

--@brief 移动地图到玩家所站位置
--@param nowFloor : 玩家所在位置
function WndTowerScroll:movingMap()
    WZLog("WndTowerScroll:movingMap-------------------")
    local movMap = GetElement(self.m_root,"movMap_WndTowerScroll",WZUIMoveContainer)
    local ptx,pty  = movMap:getMoveElement():getPosition()
    
    local ps = self.m_tPlayerAni:getPosition()
    local nX = ps.x
    local nY = ps.y 
    local minX = movMap:getMinPosition().x
    local maxX = movMap:getMaxPosition().x
    
    local moveMaxY = movMap:getMaxPosition().y
    local moveMinY = movMap:getMinPosition().y
    movMap:getMoveElement():setPositionY(moveMaxY)
    movMap:getMoveElement():setPositionX((maxX+minX)/2)
    
    local moveX = (maxX + minX )/2
    local offset = 52

    local conScrollMap = GetElement(self.m_root,"conScrollMap_WndTowerScroll",WZUIContainer)
    local playerP = conScrollMap:convertToWorldSpace(GlobalMethod:ccp(nX, nY))
    
    local moveY = moveMaxY - playerP.y + offset
    movMap:getMoveElement():setPositionY(pty)
    movMap:getMoveElement():setPositionX(ptx)
    if nY > MAPSIZE.h * 2 then
        moveY = moveMinY
        if moveY == pty then
            self.m_bLoadMapFinish = true
            movMap:setTouchEnable(true)
            return
        end
    end

    if moveY == pty  then
        self.m_bLoadMapFinish = true
        movMap:setTouchEnable(true)
        return
    end
    --英雄塔特殊处理，防止打到最顶层，加载界面时候，上方空白一小段
    if self.m_nTowerType == 1 then 
        if self.m_nPlayerCurIndex >= 7 then 
            moveY = moveMinY + nY - moveMaxY - offset
        end
    end
    
    local actionArray = CCArray:create()
    local actionMove= CCMoveTo:create(0.2,GlobalMethod:ccp(moveX,moveY))
    actionArray:addObject(actionMove)
    actionArray:addObject(CCCallFunc:create(function ()
        if self.m_root ~= nil then
            GetElement(self.m_root,"movMap_WndTowerScroll",WZUIMoveContainer):setTouchEnable(true)
        end
    end))
    movMap:getMoveElement():setPositionX(moveX)
    movMap:getMoveElement():runAction(CCSequence:create(actionArray))
    self.m_bLoadMapFinish = true
    WZLog("WndTowerScroll:movingMap 222")
end

--@brief   检测玩家当前状态，扫荡还是其他，如果是扫荡则继续执行扫荡操作
function WndTowerScroll:checkPlayerStats()
    WZLog("WndTowerScroll:checkPlayerStats")
    if self.SweepState == 1 and self.m_nSweepTime > 0 then
        local nextFloor = self:findNextFloor()
        if nextFloor then
            self:_conTipsShow(true,false,false)
            self.m_tPlayerSweepCurLP = nextFloor
            self:sweepingAction(nextFloor)
            self:startSweepSchedule()
        end
    elseif self.SweepState == 1 and self.m_nSweepTime <= 0 then
        if self.m_nTowerType == 2 then 
            ProtocolProcessorSingleMap:send_BOSSMAPROOM_TwoTowerOperation(3)
        else
            ProtocolProcessorSingleMap:send_SINGLEMAP_CompleteRaidsTower(false)
        end
    end
end

--@brief 执行扫荡操作
--@param nextFloor : 玩家需要扫荡的层
function WndTowerScroll:sweepingAction(nextFloor)
    WZLog("WndTowerScroll:sweepingAction")

    self:disableYellowArrow(nextFloor)
    local btnLevel= GetElement(nextFloor,"btnLevel_WndTowerScroll",WZUIButton)
    local ppoint = self:findElementWorldPT(btnLevel)

    local curIndex = self.m_tPlayerStartP:getTag()
    local nIndex = nextFloor:getTag()

    if curIndex + 1 == nIndex then
        self.m_bChallenge = true
        self:_playerMoveTo(nIndex,ppoint,true)
    else
        self.m_bChallenge = false
        local previousFloor = self:findPreviousFloor(nextFloor)
        btnLevel = GetElement(previousFloor,"btnLevel_WndTowerScroll",WZUIButton)
        ppoint = self:findElementWorldPT(btnLevel)
        self:_playerMoveTo(previousFloor:getTag(),ppoint,true)
    end
end

--@brief  玩家装备更改回调函数
function WndTowerScroll:updateDecorationData()
    WZLog("WndTowerScroll:updateDecorationData ---- ")
    if self.m_root == nil then
        return
    end
    
    local playerArm = self.m_conScrollMap:getChildByTag(1014)
    local flipX = self.m_tPlayerAni:isFlipX()
    WZLog("flipX === ",flipX)
    local sex = CacheCenter:getPlayerInfo().sex
    local tEquip = CacheCenter:getEquipmentList()
    local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()

    UpdatePlayerFigure(playerArm,tEquip,nil,headColor,bodyColor)
    if flipX then
        playerArm:getLuaObjectIndex():setFlipX(true)
    else
        playerArm:getLuaObjectIndex():setFlipX(false)
    end
end

--@brief  玩家信息更改回调函数
function WndTowerScroll:updatePlayerInfoData()
    WZLog("WndTowerScroll:updatePlayerInfoData ---- ")
    if self.m_root == nil then
        return
    end
    
    self:_initPlayerAni(true)
end

--@brief  控制奖励宝箱显示状态
--@param canChallenge : 是否可以挑战的层,可以挑战的层如果有宝箱则可以领取宝箱
function WndTowerScroll:controlBounsBoxStatus(parentNode,status,canChallenge)
    WZLog("WndTowerScroll:controlBounsBoxStatus = ",status,canChallenge)
    if parentNode and self.SweepState ==0  then
        local conPlayerFigure = GetElement(parentNode,"conPlayerFigure_WndTowerScroll",WZUIContainer)
        if conPlayerFigure then
            if conPlayerFigure:getChildByTag(1234)  then
                conPlayerFigure:getChildElement("armBonusBox_WndTowerScroll"):setVisible(status)
                local treasureBox = conPlayerFigure:getChildByTag(1234)
                if treasureBox then
                    treasureBox = WZUIImage:luaTo(treasureBox)
                    if treasureBox and (status or canChallenge) then
                        local iconF = treasureBox:getFile()
                        if iconF == "ui/common/common_icon_zi1.png" then
                            treasureBox:setFile("ui/common/common_icon_zi2.png")
                        elseif iconF == "ui/common/common_icon_lan1.png" then
                            treasureBox:setFile("ui/common/common_icon_lan2.png")
                        elseif iconF == "ui/common/common_icon_huang1.png" then
                            treasureBox:setFile("ui/common/common_icon_huang2.png")
                        end
                    elseif treasureBox and not status then
                        local iconF = treasureBox:getFile()
                        if iconF == "ui/common/common_icon_zi2.png" then
                            treasureBox:setFile("ui/common/common_icon_zi3.png")
                        elseif iconF == "ui/common/common_icon_lan2.png" then
                            treasureBox:setFile("ui/common/common_icon_lan3.png")
                        elseif iconF == "ui/common/common_icon_huang2.png" then
                            treasureBox:setFile("ui/common/common_icon_huang3.png")
                        end
                    end
                end
            end
        end
    end
end

--@brief    点击切换按钮回调
function WndTowerScroll:onClickSwitch(element)
    -- body
    WZLog("WndTowerScroll:onClickSwitch")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nTowerType ~= 1 then 
        if not CheckButtonOpen(151) then 
            return 
        end
    end
    if not self.m_bLoadMapFinish then
        return
    end

    if self.m_tMoveDest ~= nil then 
        self.m_tMoveDest = nil 
        self.m_conScrollMap:disableSchedule()
    end

    self.m_nTowerType = math.fmod(self.m_nTowerType + 1, 2)

    self.m_bLoadMapFinish = false
    self:_showContentByType()

    self:_resetMoveContainerSize()
    if self.m_nTowerType == 1 then 
        self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
        ProtocolProcessorSingleMap:send_MAP_GetHeroTowerData()
    else
        self:_initData()
        ProtocolProcessorSingleMap:send_MAP_GetFriendTowerInfo()
    end
end

--@brief    点击buff图标回调
function WndTowerScroll:onCLickBuff(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tData = {}
    tData.buffId = g_myHeroTowerBuffId
    WndTips:show(element, self.m_root, 55, tData, GlobalMethod:ccp(20, 20), true)
end

--@brief 	奖励预览
function WndTowerScroll:onClickRewad(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tData = {}
    tData.topFloor = self.UserData.topFloor
    WndTips:show(element, self.m_root, 65, tData, GlobalMethod:ccp(-30, 215), true)
end

--@brief    点击挑战按钮回调
function WndTowerScroll:onChallengeCallBack()
    -- body
    if self.m_root == nil then return end 

    if self.m_elementClick then 
        local parElement = WZUIContainer:luaTo(self.m_elementClick:getParent())

        local nIndex = parElement:getTag()
        local parNode = parElement
        local ppoint = self:findElementWorldPT(self.m_elementClick)

        local curIndex = self.m_tPlayerStartP:getTag()
        self.m_oBeforeFloor  = self.m_tPlayerStartP
        self.m_tPlayerStartP = parNode
        if curIndex + 1 == nIndex then
            self.m_bChallenge = true
            self:_playerMoveTo(nIndex,ppoint,true)
        else
            self.m_bChallenge = false
            local previousFloor = self:findPreviousFloor(self.m_tPlayerStartP)
            local btnLevel = GetElement(previousFloor,"btnLevel_WndTowerScroll",WZUIButton)
            ppoint = self:findElementWorldPT(btnLevel)
            self:_playerMoveTo(nIndex,ppoint,true)
        end
    end
end

--@brief    点击继续  回调
function WndTowerScroll:onClickContinue(element)
    -- body
    GetElement(self.m_root, "img9OpacityBg_WndTowerScroll", WZUI9Image):setOpacity(0)
    local conBuffIcon = GetElement(self.m_root, "conBuffIcon_WndTowerScroll", WZUIContainer)
    local conForBuff = GetElement(self.m_root, "conForBuff_WndTowerScroll", WZUIContainer)
    local conSize = conForBuff:getContentSize()
    local ptB = conForBuff:convertToWorldSpace(GlobalMethod:ccp(0,0))

    local moveTo = CCMoveTo:create(0.5, GlobalMethod:ccp(ptB.x + conSize.width/2, ptB.y + conSize.height/2))
    local scaleTo = CCScaleTo:create(0.5, 0.2)

    local spawnAct = CCSpawn:createWithTwoActions(moveTo, scaleTo)
    local actionArray = CCArray:create()
    actionArray:addObject(spawnAct)
    actionArray:addObject(CCCallFuncN:create(_removeTheBuffNode))
    local repH = CCSequence:create(actionArray)
    
    conBuffIcon:runAction(repH)
end

--@brief    动画回调
function _removeTheBuffNode(element)
    --body
    GetElement(WndTowerScroll.m_root, "CellBuffShow_WndTowerScroll", WZUIContainer):setVisible(false)
end

--@brief    刷新小排行榜
function WndTowerScroll:createMatchGoal()
    for i=1,5 do
        local conHead = GetElement(self.m_root,"conHead"..i.."_WndTowerScroll",WZUIContainer)
        local conRank = GetElement(self.m_root,"conRank"..i.."_WndTowerScroll",WZUIContainer)
        local txtNullSeat = GetElement(conHead, "txtNullSeat_WndTowerScroll", WZUILabelTTF)
        if self.matchGoal.playerInfo[i] then
            local m_bIsOffline = false
            CellHead:show(conHead,self.matchGoal.playerInfo[i].headId,self.matchGoal.playerInfo[i].faceId,self.matchGoal.playerInfo[i].playerSex, m_bIsOffline, nil, nil, self.matchGoal.playerInfo[i].headColor)
            conRank:setVisible(true)
        else
            conRank:setVisible(true)
            txtNullSeat:setVisible(true)
        end
    end
end

--@brief    点击头像回调
function WndTowerScroll:onClickHead(element)
    local tag = element:getTag()
    if self.matchGoal.playerInfo[tag] == nil then return end

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(self.matchGoal.playerInfo[tag].playerId) 
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
local tempPt = GlobalMethod:ccp(0,0)
local tempSize = GlobalMethod:CCSize(0,0)



local tFloorPt = {
    {0.642288,-0.0745681},
    {0.348966,-0.0745796},
    {0.0663236,0.255423},
    {0.406481,0.255867},
    {0.687576,0.595059},
    {0.327294,0.594773},
    {0.0955323,-0.072702},
    {0.411115,-0.075827},
    {0.687576,0.255996},
    {0.323125,0.253125},
    {0.0953425,0.592966},
    {0.42402,0.592966},
}

local tPlayerPt = {}

local LEVELCOUNTPERBLOCK = 4 --每个地图块包含的关卡数
local FLOORCOUNT = 2 --地图分两层，如果为2需要把图片进行旋转
local VISIBLEWIDTH = 1136 --可见宽度，从玩家当前位置起，左右各可见的宽度
local VISIBLEHEIGHT = 1920  --可见高度


--@brief	更新界面
function WndTowerScroll:_update()
    if self.m_root == nil or self.Data == nil or  self.UserData == nil then
        return
    end
    
    self:_showContentByType()
    self:initMap()
    self:_initMoreLanguage()
end

function WndTowerScroll:onTouchBegan(element,pt)
    WZLog("WndTowerScroll:onTouchBegan")
    if self.m_conScrollMap == nil then
        return 
    end
    
    if self.m_conScrollMap:getChildByTag(88) then self.m_conScrollMap:removeChildByTag(88, true) end
    
end

function WndTowerScroll:onToucdMoved(element,point)
    WZLog("WndTowerScroll:onToucdMoved")
    --local bIsCanMoveMap = self:_isCanMoveMap()
   local conScrollMap = GetElement(self.m_root,"conScrollMap_WndTowerScroll",WZUIContainer)
   local px,py = conScrollMap:getPosition()

   local bLeft = false   --是否向左滑动
   if point.x < self.m_nTouchStartX  then
      bLeft = true
   end
   if bLeft and px -2 > -((self.m_nInitMapCount-1)*MAPSIZE.w) then
      px = px -2
      conScrollMap:setPositionX(px)
   elseif px + 2 < 0 then
      px = px +2
      conScrollMap:setPositionX(px)
   end
end

function WndTowerScroll:onTouchEnded(element,point)
     WZLog("WndTowerScroll:onTouchEnd")
end

--@brief  爬塔副本说明
function WndTowerScroll:onTowerClickExplain(element)
    --获得说明文本
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nTowerType == 0 then 
        WndSingleMapDesc:showInterface(LocalStrings.TOWER_DESC)
    elseif self.m_nTowerType == 1 then 
        WndSingleMapDesc:showInterface(LocalStrings.TOWER_DESC_HERO)
    elseif self.m_nTowerType == 2 then 
        WndSingleMapDesc:showInterface(LocalStrings.DOUBLETOWER_TEXT5)
    end
end

--@brief  初始化地图信息
function WndTowerScroll:initMap()
    WZLog("WndTowerScroll:initMap")
    if self.m_root == nil or self.Data == nil or self.UserData == nil then
        return
    end

    self.m_conScrollMap = GetElement(self.m_root,"conScrollMap_WndTowerScroll",WZUIContainer)
    self.m_conScrollMap:removeAllChildrenWithCleanup(true)

    self.m_bPlayerMoveOut = false
    self.m_bLoadMapFinish = false

    self.m_nInitMapCount =  3 --最多加载三页(一页为640的高度)
    self.m_nLoadCount = 0
    self.m_bFirstLoad = true
    self.m_tPlayerStartP = nil
    self.m_oBeforeFloor = nil
    self.m_tPlayerAni = nil
    self.m_tempNode  = nil

    local nCurMapIndex = self.UserData.nowFloor * 2  --当前所在层在地图上的层次位置
    if self.UserData.isReward then
        nCurMapIndex = nCurMapIndex + 1
    end

    if nCurMapIndex < 10 then
        self.m_nPlayerStartIndex = 0
    else
        self.m_nPlayerStartIndex = (math.floor((nCurMapIndex + 2)/6)-1)*6  --计算从第几层开始加载关卡
    end

    if self.m_nPlayerStartIndex == 0 then
        self.m_nLoadMapDataIndex = 0
    else
        self.m_nLoadMapDataIndex  = math.abs(self.m_nPlayerStartIndex / 2)
    end

    local movMap = GetElement(self.m_root,"movMap_WndTowerScroll",WZUIMoveContainer)
    movMap:setTouchEnable(false)
    self.m_nPlayerCurIndex = self.UserData.nowFloor
    if self.UserData.isReward then
        self.m_nPlayerCurIndex = self.m_nPlayerCurIndex + 1
    end

    self.m_tOLevels = {}
    local bFirstMapScaleX = false  --第一张地图是否进行X轴反转
    local tempResult = (self.m_nPlayerStartIndex + 2) % 4
    if tempResult == 0 then
        bFirstMapScaleX = true
    end

    self:loadMap(bFirstMapScaleX)
    movMap:enableSchedule("addHurdlesToMap")
   
end

--@brief  添加小关卡到地图上
function WndTowerScroll:addHurdlesToMap(element)
    WZLog("WndTowerScroll:addHurdlesToMap =",self.m_nPlayerStartIndex)
    local language = ProjConfig.LANGUAGE
    if element ~= nil then
        element:disableSchedule()
    end
    LEVELCOUNTPERBLOCK = 4  --第一层只加载4个小层，二、三就加载6个小层
    local bScale = false
    local bFirstMapScaleX = false
    for i=1,4 do
        local conMap = self.m_conScrollMap:getChildByTag(i*1024)
        if conMap ~= nil then
            conMap = WZUIContainer:luaTo(conMap)
        else
            break
        end
        local imgMap = GetElement(conMap,"imgMap_WndTowerScroll",WZUIImage)
        local tempX = imgMap:getScaleX()
        if tempX < 0  then
            if i == 1 then
                bFirstMapScaleX = true
            end
            bScale = true
        else
            bScale = false
        end
        if i > 1 then
           LEVELCOUNTPERBLOCK = 6  --第一层只加载4个小层，二、三就加载6个小层
        end
        for j=1,LEVELCOUNTPERBLOCK do
            local tFloorInfo = nil 
            
            if self.m_nPlayerStartIndex % 2 == 1 then
                if self.m_nLoadMapDataIndex <= self.m_nTowerMapCount then
                    tFloorInfo = self.Data[self.m_nLoadMapDataIndex]
                    self.m_tFloorInfo = tFloorInfo
                end
            end
            if self.m_nPlayerStartIndex <=  self.m_nCountFloor*2  then  --爬塔副本所有层是否已加载完毕

                local CellFloor = CreateElement("CellFloor_WndTowerScroll")
                CellFloor:setTag(self.m_nPlayerStartIndex)
                
                local cellFloor = {}
                table.insert(cellFloor,self.m_nPlayerStartIndex)
                table.insert(cellFloor,CellFloor)
                table.insert(self.m_tOLevels,cellFloor)
                
                if bScale then
                    if i~=1 then
                        CellFloor:setRelativePosition(GlobalMethod:ccp(tFloorPt[4+j+2][1],tFloorPt[4+j+2][2]))
                    elseif i == 1 then

                        CellFloor:setRelativePosition(GlobalMethod:ccp(tFloorPt[4+j+4][1],tFloorPt[4+j+4][2]))
                    end
                else
                    if i < 3 and not bFirstMapScaleX then
                        CellFloor:setRelativePosition(GlobalMethod:ccp(tFloorPt[j+2][1],tFloorPt[j+2][2]))
                    else
                        CellFloor:setRelativePosition(GlobalMethod:ccp(tFloorPt[j][1],tFloorPt[j][2]))
                    end
                end
                CellFloor:setVisible(true)
                local armTowerStart = GetElement(CellFloor,"armTowerStart_WndTowerScroll",WZUIArmature)
                local imgFloorName = GetElement(CellFloor,"imgFloorName_WndTowerScroll",WZUIImage)
                local img2 = GetElement(CellFloor,"img2_WndTowerScroll",WZUIImage)
                local img1 = GetElement(CellFloor,"img1_WndTowerScroll",WZUIImage)
                local atlasFont = GetElement(CellFloor,"atlasFont_WndTowerScroll",WZUILabelAtlasFont)
                if self.m_nPlayerStartIndex == 0 then
                   armTowerStart:setVisible(true)
                   imgFloorName:setVisible(true)
                else
                    if self.m_nPlayerStartIndex <= 400 then
                        if self.m_nPlayerStartIndex % 2 == 1 then
                            if self.m_tFloorInfo.floor_num <10 then
                                img1:setRelativePosition(GlobalMethod:ccp(0.256234,0.583007))
                                img2:setRelativePosition(GlobalMethod:ccp(0.721605,0.583007))
                            end
                            if language == "en" or language == "th" then
                                img1:setVisible(false)
                                img2:setVisible(true)
                            elseif language == "vn" then
                                img1:setFile("ui/common/common_icon_ceng.png")
                                img1:setVisible(true)
                                img2:setVisible(false)
                            elseif language == "pt" then
                                img1:setVisible(false)
                                img2:setVisible(true)
                                atlasFont:setRelativePosition(GlobalMethod:ccp(0.266088,0.583007))
                                img2:setRelativePosition(GlobalMethod:ccp(0.726367,0.583007))                                
                            elseif language == "es" then
                                atlasFont:setScale(0.8)
                                img1:setVisible(true)
                                img2:setVisible(true)
                            elseif language == "ug" then
                                GetElement(CellFloor,"txtClickMeTotry_WndTowerScroll",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(180))
                            else
                                img1:setVisible(true)
                                img2:setVisible(true)
                            end
                            atlasFont:setVisible(true)
                            atlasFont:setText(tFloorInfo.floor_num)
                        else
                            local conFloorInfo = GetElement(CellFloor,"conFloorInfo_WndTowerScroll",WZUIContainer)
                            conFloorInfo:setVisible(false)
                        end
                    end
                end
               
                local conPlayerFigure = GetElement(CellFloor,"conPlayerFigure_WndTowerScroll",WZUIContainer)
                local monsterCon = conPlayerFigure:getChildByTag(1144)
                if self.m_nPlayerStartIndex >= self.UserData.nowFloor * 2 and self.m_nPlayerStartIndex % 2 == 0 and self.m_nPlayerStartIndex ~=0 and self.m_nPlayerStartIndex - self.UserData.nowFloor ~= self.UserData.nowFloor and self.m_tFloorInfo ~= nil and  self.m_tFloorInfo.floor_reward ~= -1 then
                    if self.m_nTowerType ~= 2 then 
                        local img = self:createTreasureBox(self.m_tFloorInfo.icon)
                        -- local bubble = self:createBubbleWindow()
                        -- conPlayerFigure:addChild()
                        conPlayerFigure:addChild(img)
                        if self.m_tFloorInfo.floor_num > self.UserData.topFloor then
                            local conBubbleParent = GetElement(CellFloor,"conBubbleParent_WndTowerScroll",WZUIContainer)
                            conBubbleParent:setVisible(true)
                            local conBubble = GetElement(CellFloor,"conBubble_WndTowerScroll",WZUIContainer)
                            conBubble:setVisible(true)
                            self:createBubbleWindow(conBubble)
                        end
                    end
                elseif self.m_nPlayerStartIndex >= self.UserData.nowFloor * 2 and self.m_nPlayerStartIndex % 2 == 0 and self.m_nPlayerStartIndex ~=0 and self.m_nPlayerStartIndex - self.UserData.nowFloor == self.UserData.nowFloor and self.UserData.isReward ==false and self.m_tFloorInfo ~= nil and  self.m_tFloorInfo.floor_reward ~= -1 then
                    if self.m_nTowerType ~= 2 then 
                        local img = self:createTreasureBox(self.m_tFloorInfo.icon)
                        conPlayerFigure:addChild(img)
                        if self.m_tFloorInfo.floor_num > self.UserData.topFloor then
                            local conBubbleParent = GetElement(CellFloor,"conBubbleParent_WndTowerScroll",WZUIContainer)
                            conBubbleParent:setVisible(true)
                           local conBubble = GetElement(CellFloor,"conBubble_WndTowerScroll",WZUIContainer)
                            conBubble:setVisible(true)
                            self:createBubbleWindow(conBubble)
                        end
                    end
                elseif self.m_nPlayerStartIndex < self.UserData.nowFloor * 2 and self.m_nPlayerStartIndex %2 == 0 and self.m_nPlayerStartIndex ~=0 and self.m_tFloorInfo ~= nil and  self.m_tFloorInfo.floor_reward ~= -1 then
                    if self.m_nTowerType ~= 2 then 
                        local img = self:createOpenTreauseBox(self.m_tFloorInfo.icon)
                        conPlayerFigure:addChild(img)
                    end
                elseif self.m_nPlayerStartIndex <= self.UserData.nowFloor * 2 and self.m_nPlayerStartIndex % 2 == 0 and self.m_nPlayerStartIndex ~=0 and self.m_nPlayerStartIndex - self.UserData.nowFloor == self.UserData.nowFloor and self.UserData.isReward ==true and self.SweepState == 1 and self.m_tFloorInfo ~= nil and  self.m_tFloorInfo.floor_reward ~= -1 then
                    if self.m_nTowerType ~= 2 then 
                        local img = self:createOpenTreauseBox(self.m_tFloorInfo.icon)
                        conPlayerFigure:addChild(img)
                    end
                elseif math.abs(self.UserData.nowFloor * 2 -1) < self.m_nPlayerStartIndex or (self.UserData.nowFloor == 0 and self.m_nPlayerStartIndex == 1 ) then
                    if tFloorInfo ~= nil then
                        if self.m_nTowerType == 2 then 
                            local animNode = self:_createDoubleTowerMonster(tFloorInfo)
                            self:_flipX(CellFloor,animNode, tFloorInfo)
                            monsterCon:addChild(animNode)
                        else
                            local monsterFig = tFloorInfo.monster_image
                            local animNode = self:_createMonster(monsterFig)
                            self:_flipX(CellFloor,animNode)
                            monsterCon:addChild(animNode)
                        end
                    end
                elseif  math.abs(self.UserData.nowFloor * 2 -1) >self.m_nPlayerStartIndex  or (math.abs(self.UserData.nowFloor * 2 -1) == self.m_nPlayerStartIndex and self.UserData.isReward )  then
                    if tFloorInfo ~= nil then
                        if self.m_nTowerType == 2 then 
                            local animNode = self:_createDoubleTowerMonster(tFloorInfo)
                            self:_flipX(CellFloor,animNode, tFloorInfo)
                            monsterCon:addChild(animNode)
                        else
                            local monsterFig = tFloorInfo.monster_image
                            local animNode = self:_createMonster(monsterFig)
                            self:_flipX(CellFloor,animNode)
                            monsterCon:addChild(animNode)
                        end
                        local imgLevelPassTag = GetElement(CellFloor,"imgLevelPassTag_WndTowerScroll",WZUIImage)
                        imgLevelPassTag:setVisible(true)
                        imgLevelPassTag:setZOrder(9999)
                    end
                end

                --找出玩家站在那层位置上
                if self.UserData.nowFloor == self.m_nPlayerStartIndex and self.UserData.nowFloor == 0 then
                    self.m_tPlayerStartP = CellFloor
                elseif self.UserData.nowFloor == self.m_nPlayerStartIndex and self.UserData.nowFloor ==1 and self.UserData.isReward == false then
                    self.m_tPlayerStartP = CellFloor
                elseif  self.UserData.nowFloor == (self.m_nPlayerStartIndex+1) / 2 and self.UserData.isReward == false then
                    self.m_tPlayerStartP = CellFloor
                elseif self.UserData.nowFloor == self.m_nPlayerStartIndex/2 and self.UserData.isReward == true  then
                    self.m_tPlayerStartP = CellFloor
                end

                if  self.m_tPlayerStartP ~= nil and self.m_oBeforeFloor == nil then
                    self.m_oBeforeFloor  = self.m_tPlayerStartP
                end                

                if self.m_tPlayerStartP and self.m_bFirstLoad then
                    self.m_bFirstLoad = false
                    if tFloorInfo ~= nil  then
                        if self.m_nTowerType == 2 then 
                            local animNode = self:_createDoubleTowerMonster(tFloorInfo)
                            self:_flipX(CellFloor,animNode, tFloorInfo)
                            monsterCon:addChild(animNode)
                        else
                            local monsterFig = tFloorInfo.monster_image
                            local animNode = self:_createMonster(monsterFig)
                            self:_flipX(CellFloor,animNode)
                            monsterCon:addChild(animNode)
                        end
                        monsterCon:setVisible(false)
                        local imgLevelPassTag = GetElement(CellFloor,"imgLevelPassTag_WndTowerScroll",WZUIImage)
                        imgLevelPassTag:setVisible(false)
                        imgLevelPassTag:setZOrder(9999)
                    elseif self.m_tFloorInfo ~= nil and self.m_tFloorInfo.floor_reward ~= -1 and not monsterCon:getChildByTag(12345) then
                        local img = self:createTreasureBox(self.m_tFloorInfo.icon)
                        img:setVisible(false)
                        conPlayerFigure:addChild(img)
                    end
                end

                if self.m_nPlayerStartIndex <= 400 then
                    WZLog("WndTowerScroll:loadMap two", startIndexMap, j)
                    conMap:addChild(CellFloor)
                end
                
                if tFloorInfo ~=nil then
                    local bHF = self:_findPF(self.m_nLoadMapDataIndex)
                    if bHF then
                        local conFirendF = GetElement(CellFloor,"conFirendF_WndTowerScroll",WZUIContainer)
                        local conPlayer1 = GetElement(conFirendF,"conPlayer1_WndTowerScroll",WZUIContainer)
                        local conPlayer2 = GetElement(conFirendF,"conPlayer2_WndTowerScroll",WZUIContainer)
                        self:_loadPlayerFFigure(self.m_nLoadMapDataIndex,conPlayer1,conPlayer2)
                    end
                end
                self.m_nPlayerStartIndex = self.m_nPlayerStartIndex + 1
                if self.m_nPlayerStartIndex % 2 == 1 then
                    self.m_nLoadMapDataIndex = self.m_nLoadMapDataIndex  + 1
                end
            end
        end
        self.m_nLoadCount = self.m_nLoadCount + 1
    end
    for i,v in ipairs(self.m_tEquipArmatures) do
       local action = WZUIArmatureAnimationById:create()
       action:setAnimationId(0)
       action:setLoop(1)
       v:runUIAction(action)
    end

    for i,v in ipairs(self.m_tArmatures) do
        v:play("wait",true)
        local animNode = v:getAnimNode()
        local animSize = animNode:getContentSize()
        if animSize.width > 140 and animSize.width < 200 then
            animNode:setScale(0.55)
        elseif animSize.width >= 200 then
            animNode:setScale(0.47)
        end
    end

    for i, v in ipairs(self.m_tSuitGuaiArmatures) do
        v:play("wait0",true)
        local animNode = v:getAnimNode()
        local animSize = animNode:getContentSize()
        if animSize.width > 140 and animSize.width < 200 then
            animNode:setScale(0.55)
        elseif animSize.width >= 200 then
            animNode:setScale(0.47)
        end
    end
    self.m_tEquipArmatures = {}
    self.m_tArmatures = {}
    self.m_tSuitGuaiArmatures = {}

    local nextFloor = self:findNextFloor()
    
    self.m_oNextFloor = nextFloor
    if nextFloor ~= nil then
        nextFloor:getChildElement("imgArrow_WndTowerScroll"):setVisible(true)
        self:controlBounsBoxStatus(nextFloor,true,true)
    end
    self:showSweepSuccess()
    WZLog("loadMapFinish")
end

--@brief  加载大地图
--@param  bFirstMapScaleX : 第一张地图是否进行X轴旋转
function WndTowerScroll:loadMap(bFirstMapScaleX, nCount)
    WZLog("WndTowerScroll:loadMap = ",bFirstMapScaleX)
    local nIndex = nil
    
    local bScale = false
    
    local movMap = GetElement(self.m_root,"movMap_WndTowerScroll",WZUIMoveContainer)
    local moveElement = movMap:getMoveElement()
    local moveElementScaleX  = moveElement:getScaleX()
    local moveElementScaleY  = moveElement:getScaleY()
    WZLog("moveElementScaleX =",moveElementScaleX,moveElementScaleY)
    local temp = self.m_nScreenSize.width * moveElementScaleX - self.m_nWinSize.width
    temp = temp + 828
    local scaleXXX = (self.m_nScreenSize.width - temp) / 2 / 153
    WZLog("scaleXXX = ",scaleXXX)
    if scaleXXX > 1 then
        scaleXXX = scaleXXX + 0.01
    else
        scaleXXX = 1 + 0.03
        WZLog("scaleXXX scaleXXX = ",scaleXXX)
    end

    local nLoadCount = nCount or 4
    for i = 1, nLoadCount do
        local conMap = CreateElement("conMap_WndTowerScroll")
        conMap:setTag(i*1024)
        conMap:setVisible(true)

        local conMiddleMap = CreateElement("conMiddleMap_WndTowerScroll")
        conMiddleMap:setTag(i*1024+10)
        conMiddleMap:setVisible(true)

        local imgMap =WZUIImage:luaTo(conMap:getChildElement("imgMap_WndTowerScroll"))
        
        conMap:setAbsPosition(GlobalMethod:ccp(self.tMapPt[i][1],self.tMapPt[i][2]))
        conMiddleMap:setAbsPosition(GlobalMethod:ccp(self.tMiddlePt[i][1],self.tMiddlePt[i][2]))   
       
        if scaleXXX > 1 then
            local conPillar1 = GetElement(conMiddleMap,"conPillar1_WndTowerScroll",WZUIContainer)
            local conPillar2 = GetElement(conMiddleMap,"conPillar2_WndTowerScroll",WZUIContainer)
            conPillar1:setScaleX(scaleXXX)
            conPillar2:setScaleX(scaleXXX)
        end

        if bFirstMapScaleX and (i == 1 or i == 3) then
            imgMap:setScaleX(-1)
        elseif (i == 2 or i == 4) and not bFirstMapScaleX then
            imgMap:setScaleX(-1)
        end
        if self.m_nTowerType == 2 then 
            imgMap:setFile("ui/copy/climbbg_001_1.png")
            GetElement(conMiddleMap, "imgPillar1_WndTowerScroll", WZUIImage):setFile("ui/copy/climbbg_002_1.png")
            GetElement(conMiddleMap, "imgPillar2_WndTowerScroll", WZUIImage):setFile("ui/copy/climbbg_002_1.png")
        end
        self.m_conScrollMap:addChild(conMiddleMap)
        self.m_conScrollMap:addChild(conMap)
    end
   
end

--@brief 创建怪物
function WndTowerScroll:_createMonster(monsterFig)
    WZLog("WndTowerScroll:_createMonster")
    local animNode = nil
    local stP,enP = string.find(monsterFig,".xml")
    if stP == nil or endP == nil then
        stP,enP = string.find(monsterFig,".altas")
        local animName = string.sub(monsterFig,0,stP-1)
        local anim = BattleAnimation:createAnimation(animName,false,"battle/monster")
        animNode = anim:getAnimNode()
        animNode:setRelativePosition(GlobalMethod:ccp(0.5,0.05))
        animNode:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        animNode:setUseOriginSize(true)
        animNode:setScale(0.6)
        animNode:setTag(12345)
        --self:_flipX(CellFloor,animNode)
        --conPlayerFigure:addChild(animNode)
        table.insert(self.m_tArmatures,anim)
    else
        animNode = WZArmature:create()
        animNode:setArmatureName( monsterFig )
        animNode:setUseOriginSize(true)
        animNode:setScale(0.5)
        animNode:setTag(12345)
        local file = "battle/monster/"..monsterFig
        animNode:setArmatureFile(file)
        --self:_flipX(CellFloor,equipArmature)
        table.insert(self.m_tEquipArmatures, animNode )
        --conPlayerFigure:addChild(equipArmature)
    end
    return animNode
end

--@brief    创建双人爬塔怪物
function WndTowerScroll:_createDoubleTowerMonster(floorData)
    WZLog("WndTowerScroll:_createDoubleTowerMonster")
    local animNode = nil
    local monsterData = GDatatab_monster["id_" .. floorData.monster[1][1]]
    if monsterData == nil then return end 
    if monsterData.AniFileId == -1 then 
        local suit_info = {}
        local suitConfig = {}
        if monsterData.suitConfig and monsterData.suitConfig ~= -1 then
            suitConfig.sex = monsterData.suitConfig[1][1]
            suitConfig.headId = monsterData.suitConfig[1][2]
            suitConfig.faceId = monsterData.suitConfig[1][3]
            suitConfig.bodyId = monsterData.suitConfig[1][4]
            suitConfig.weaponId = monsterData.suitConfig[1][5]
            suitConfig.wingId = monsterData.suitConfig[1][6]
        else
            suitConfig.sex = 0
            suitConfig.headId = 4903
            suitConfig.faceId = 4902
            suitConfig.bodyId = 4901
            suitConfig.weaponId = 4900
            suitConfig.wingId = 0
        end

        local tEquipment = {}
        table.insert(tEquipment, suitConfig.headId)
        table.insert(tEquipment, suitConfig.bodyId)
        table.insert(tEquipment, suitConfig.faceId)
        table.insert(tEquipment, suitConfig.wingId)

        local conPlayer = CreatePlayerFigure(suitConfig.sex, tEquipment, "wait0", nil, nil, nil, nil, nil, nil, nil, 0, 0, false)
        animNode = conPlayer:getAnimNode()
        animNode:setRelativePosition(GlobalMethod:ccp(0.5,0.02))
        animNode:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        animNode:setUseOriginSize(true)
        animNode:setScale(0.6)
        animNode:setTag(12345)

        table.insert(self.m_tSuitGuaiArmatures, conPlayer)
    else
        local stP,enP = string.find(monsterData.AniFileId,".xml")
        if stP == nil or endP == nil then
            stP,enP = string.find(monsterData.AniFileId,".altas")
            local animName
            if not stP then 
                animName = monsterData.AniFileId
            else
                animName = string.sub(monsterData.AniFileId,0,stP-1)
            end
            local anim = BattleAnimation:createAnimation(animName, false, "battle/monster")
            animNode = anim:getAnimNode()
            animNode:setRelativePosition(GlobalMethod:ccp(0.5,0.05))
            animNode:setAnchorPoint(GlobalMethod:ccp(0.5,0))
            animNode:setUseOriginSize(true)
            animNode:setScale(0.6)
            animNode:setTag(12345)
            --self:_flipX(CellFloor,animNode)
            --conPlayerFigure:addChild(animNode)
            table.insert(self.m_tArmatures,anim)
        else
            animNode = WZArmature:create()
            animNode:setArmatureName( monsterData.AniFileId )
            animNode:setUseOriginSize(true)
            animNode:setScale(0.5)
            animNode:setTag(12345)
            local file = "battle/monster/"..monsterData.AniFileId
            animNode:setArmatureFile(file)
            --self:_flipX(CellFloor,equipArmature)
            table.insert(self.m_tEquipArmatures, animNode )
            --conPlayerFigure:addChild(equipArmature)
        end
    end
    return animNode
end

--@brief 初始化好友头部形象
--@param level : 玩家朋友闯关的层数
--@param conPlayer1 : 放置头像形象的容器1
--@param conPlayer2 : 放置头像形象的容器2
function WndTowerScroll:_loadPlayerFFigure(level,conPlayer1,conPlayer2)
    local index = 1
    local gameParam = CacheCenter:getGameParam()
    for i,v in ipairs(self.m_tFriendsData.topFloor) do
        if level == v then
            local nSex = self.m_tFriendsData.sex[i]
            local bIsBoy = nSex ~= 1 and true or false
            local head  = self.m_tFriendsData.headId[i]
            local face = self.m_tFriendsData.faceId[i]
            local headColor = self.m_tFriendsData.headColor[i]
            if bIsBoy == true then
                if head == nil then head = gameParam.defaultManHeadId or 4903 end
                if face == nil then face = gameParam.defaultManFaceId or  4902 end
            else
                if head == nil then head = gameParam.defaultWomanHeadId or 4906 end
                if face == nil then face =gameParam.defaultWomanFaceId or 4905 end
            end
            if index == 1 then
                --conPlayer1:addChild(animNode)
                CellHead:show(conPlayer1,head,face,nSex,nil,nil,nil,headColor)
                --conPlayer:play("avatar",true)
                conPlayer1:setTag(self.m_tFriendsData.playerId[i])
                conPlayer1:setVisible(true)
                conPlayer1:setRelativePosition(GlobalMethod:ccp(0.16931,0.5))
                index = index + 1
            elseif index ==2 then
                CellHead:show(conPlayer2,head,face,nSex,nil,nil,nil,headColor)
                conPlayer2:setTag(self.m_tFriendsData.playerId[i])
                --conPlayer2:addChild(animNode)
                --conPlayer:play("avatar",true)
                conPlayer2:setVisible(true)
                conPlayer1:setRelativePosition(GlobalMethod:ccp(0,0.5))
                index = index + 1
            elseif index > 2  then
                return
            end
        end
    end
end

--@brief  获取当前层数是否有玩家朋友
--@param  level : 查找的层数
function WndTowerScroll:_findPF(level)
    if level == 0 then
        return false
    end
    if self.m_tFriendsData then
        for i,v in ipairs(self.m_tFriendsData.topFloor) do
            if v == level then
                return true
            end
        end
    end
    return false
end

--@brief  播放玩家战斗动画
--@note   处于扫荡状态才需要使用
--@param  t : 战斗倒数时间
function WndTowerScroll:_playFightAnim(t)
   WZLog("WndTowerScroll:_playightAni = ",t)
   if t <= 0 then
      t = self.m_nLevelSweepT
   end
   local conFire = GetElement(self.m_tPlayerSweepCurLP,"conFire_WndTowerScroll",WZUIContainer)
   conFire:setVisible(true)
   local afFightT = GetElement(self.m_tPlayerSweepCurLP,"afFightT_WndTowerScroll",WZUILabelTTF)
   afFightT:setText(t)
   self.m_conFire = conFire
end

--@brief  停止玩家战斗动画
--@note   处于扫荡状态才需要使用
--@param  t : 战斗倒数时间
function WndTowerScroll:_stopFightAnim()
    WZLog("WndTowerScroll:_stopFightAnim", type(self.m_tPlayerSweepCurLP))
    if self.m_tPlayerSweepCurLP then
        local conFire = GetElement(self.m_tPlayerSweepCurLP,"conFire_WndTowerScroll",WZUIContainer)
        WZLog("WndTowerScroll:_stopFightAnim 000", type(conFire))
        if conFire then
            conFire:setVisible(false)
        end
    end
end

--@brief 改变当前玩家座位上的怪物或物品状态
function WndTowerScroll:_changePlayerCurSeat(playerCurFloor)
    WZLog("WndTowerScroll:_changePlayerCurSeat")
    if not playerCurFloor or self.SweepState == 0 or self.m_nTowerType == 1 then return end
    local conPlayerFigure = playerCurFloor:getChildByTag(1313)
    if conPlayerFigure == nil then
        return
    end
    conPlayerFigure = WZUIContainer:luaTo(conPlayerFigure)
    local sweepGift = conPlayerFigure:getChildByTag(1234)
    local monster = conPlayerFigure:getChildByTag(1144)
    if sweepGift then
        sweepGift = WZUIImage:luaTo(sweepGift)
        local icon = sweepGift:getFile()
        if icon == "ui/common/common_icon_zi1.png" then
            sweepGift:setFile("ui/common/common_icon_zi3.png")
        elseif icon == "ui/common/common_icon_lan1.png" then
            sweepGift:setFile("ui/common/common_icon_lan3.png")
        elseif icon == "ui/common/common_icon_huang1.png" then
            sweepGift:setFile("ui/common/common_icon_huang3.png")
        end
        sweepGift:setVisible(true)
    elseif monster then
        monster:setVisible(false)
    end
end

--@brief  改变当前宝箱状态
function WndTowerScroll:_changeCurSeatTreasureBox(playerCurFloor)
    if not playerCurFloor or self.SweepState == 0 then return end
    local conPlayerFigure = playerCurFloor:getChildByTag(1313)
    if conPlayerFigure == nil then
        return
    end
    conPlayerFigure = WZUIContainer:luaTo(conPlayerFigure)
    local sweepGift = conPlayerFigure:getChildByTag(1234)
    if sweepGift then
        sweepGift = WZUIImage:luaTo(sweepGift)
        local icon = sweepGift:getFile()
        if icon == "ui/common/common_icon_zi1.png" then
            sweepGift:setFile("ui/common/common_icon_zi3.png")
        elseif icon == "ui/common/common_icon_lan1.png" then
            sweepGift:setFile("ui/common/common_icon_lan3.png")
        elseif icon == "ui/common/common_icon_huang1.png" then
            sweepGift:setFile("ui/common/common_icon_huang3.png")
        end
        sweepGift:setVisible(true)
    end
end

--@brief  扫荡完毕后需要更改怪物状态，显示已通关图片出来
function WndTowerScroll:_changeSweepFinishLevel(floor)
    WZLog("WndTowerScroll:_changeSweepFinishLevel = ")
    if floor == nil then
        return
    end
    local conPlayerFigure =floor:getChildByTag(1313)
    if not conPlayerFigure then return end
    conPlayerFigure = WZUIContainer:luaTo(conPlayerFigure)
    local monsterCon = conPlayerFigure:getChildByTag(1144)
    local monster = monsterCon:getChildByTag(12345)
    if monster then
        monsterCon:setVisible(true)
        local imgLevelPassTag = GetElement(conPlayerFigure,"imgLevelPassTag_WndTowerScroll",WZUIImage)
        if imgLevelPassTag then
            imgLevelPassTag:setVisible(true)
            imgLevelPassTag:setZOrder(999)
        end
    end
end

--@brief    当玩家走到尽头时需要重新加载地图   
function WndTowerScroll:_checkMapBlock()
    WZLog("WndTowerScroll:_checkMapBlock")
    self.m_tPlayerSweepCurLP = nil
    self.m_oNextFloor = nil

    local imgAction= GetElement(self.m_root,"imgAction_WndTowerScroll",WZUIImage)
    imgAction:setVisible(true)
    local fadeOut = CCFadeOut:create(0.8)
    imgAction:runAction(fadeOut)
    self:resertMapPos()
    self:initMap()
    self.m_root:enableSchedule("scheduleMonitorMapLoad",0.1)

end

--@brief    检查玩家是否靠近滚动容器边缘，如果靠近的话，调整滚动元素位置
--@note     扫荡操作需要检测是否需要滚动地图
function WndTowerScroll:_checkPlayerCloseToBorder()
    WZLog("WndTowerScroll:_checkPlayerCloseToBorder")
    local pos = self.m_tPlayerAni:getPosition()
    local nX = pos.x
    local nY = pos.y

    if nY >=VISIBLEHEIGHT then return end
    if self.SweepState ==0 then
        return 
    end
    self:movingMap()
end

--@brief	初始化玩家形象
--param     bUpdate :是否更新玩家形象
function WndTowerScroll:_initPlayerAni(bUpdate)
    WZLog("WndTowerScroll:_initPlayerAni")
    local tPlayerInfo = CacheCenter:getPlayerInfo()
    local tEquipment = CacheCenter:getEquipmentList()

    local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()
    local curPosX = nil
    local curPosY = nil
    local isFlipX = nil
    local animName = nil
    if bUpdate and self.m_tPlayerAni then
        isFlipX = self.m_tPlayerAni:isFlipX()
        local node =  self.m_conScrollMap:getChildByTag(1014)
        local px,py= node:getPosition()
        curPosX = px
        curPosY = py
        animName = self.m_tPlayerAni.m_playName
    end
    if self.m_conScrollMap == nil then 
        self.m_conScrollMap = GetElement(self.m_root,"conScrollMap_WndTowerScroll",WZUIContainer)
    end
    if self.m_conScrollMap:getChildByTag(1014) then
       self.m_conScrollMap:removeChildByTag(1014,true)
    end
   
    self.m_tPlayerAni = CreatePlayerFigure(tPlayerInfo.sex, tEquipment,nil,nil,nil,nil,nil,nil,nil,nil,headColor,bodyColor)
    
    local node = self.m_tPlayerAni:getAnimNode()
    node:setTouchEnable(false)
    local imgAction= GetElement(self.m_root,"imgAction_WndTowerScroll",WZUIImage)
    imgAction:disableSchedule()
    imgAction:enableSchedule("_scheduleMonitingPlayerAction",8)

    self.m_conScrollMap:addChild(node,2,1014)

    self.m_tPlayerAni:setScale(0.5)
    tempPt.x = 0.5
    tempPt.y = 0
    node:setAnchorPoint(tempPt)
   
    if not bUpdate then
        local btnLevel = GetElement(self.m_tPlayerStartP,"btnLevel_WndTowerScroll",WZUIButton)
    
        local ppoint = self.m_tPlayerStartP:convertToWorldSpace(GlobalMethod:ccp(btnLevel:getPositionX(),btnLevel:getPositionY()))
        local conScrollMap = GetElement(self.m_root,"conScrollMap_WndTowerScroll",WZUIContainer)
        ppoint = conScrollMap:convertToNodeSpace(ppoint)
        ppoint.x = ppoint.x 
        ppoint.y = ppoint.y 
        node:setPosition(ppoint)
        local px,py= node:getPosition()
        table.insert(self.m_tempPlayerPs,px)
        table.insert(self.m_tempPlayerPs,py)
        local nextFloor = self:findNextFloor2(self.m_tPlayerStartP)
        if nextFloor == nil then
            --node:setFlipX(true)
            return
        end
        local nextFloorPsX = nextFloor:getPositionX()
        local nextFloorPsY = nextFloor:getPositionY()
        local curPosX  = self.m_tPlayerStartP:getPositionX()
        local curPosY  = self.m_tPlayerStartP:getPositionY()
        if curPosX > nextFloorPsX then
            self.m_tPlayerAni:setFlipX(true)
        -- else
        --     local childByTag = GetElement(nextFloor,"conPlayerFigure_WndTowerScroll",WZUIContainer):getChildByTag(1234)
        --     if math.abs(nextFloorPsY - curPosY) > 20  and childByTag == nil then
        --         node:setFlipX(true)
        --     end
        end
    else
        self.m_tPlayerAni:setFlipX(isFlipX)
        node:setPosition(GlobalMethod:ccp(curPosX,curPosY))
        if animName then
            self.m_tPlayerAni:play(animName,true)
        end
    end

    --剩余血量
    if self.m_nTowerType == 1 then 
        self:_createSelfHP(node, self.m_nMyCurHP)
        self:playerHpFlipX()
    end
end

--@brief	根据地点序号检查玩家是否可以移动到这个地点
--@param    node, 地点节点
--@return   #1, 是否可以移动
function WndTowerScroll:_checkMoveTo(node)
    if node == self.m_oNextFloor then
        return true
    end
    return false
end

--@brief	玩家移动到某个地点
--@param    nIndex, 地点序号
--@param    bAni, 是否播放动画    
function WndTowerScroll:_playerMoveTo(nIndex,point,bAni)
    WZLog("WndTowerScroll:_playerMoveTo")

    local pt = point
    pt.x = pt.x 
    pt.y = pt.y 
    self.m_tMoveDest = {}
    self.m_tMoveDest.x = pt.x
    self.m_tMoveDest.y = pt.y
    self.m_nPlayerCurPTX  = pt.x
    self.m_conScrollMap:enableSchedule("scheduleUpdatePlayer")
    self.m_tPlayerAni:play("run", true)
    self:_changeSweepFinishLevel(self.m_oBeforeFloor)
    WZLog("WndTowerScroll:_playerMoveTo---------")
    if nIndex then self.m_nPlayerCurIndex = nIndex end
end

function WndTowerScroll:_initMoreLanguage()
    local txtFightNum = GetElement(self.m_root,"txtFightNum_WndTowerScroll", WZUILabelTTF)
    local txtAssistNum = GetElement(self.m_root,"txtAssistNum_WndTowerScroll", WZUILabelTTF)
    local challengeC = self.m_nCallengeCount - self.UserData.dareTimes
    if self.m_nTowerType == 2 then 
        challengeC = self.UserData.dareTimes
        txtAssistNum:setText(self.UserData.helpTimes)
    end
    if challengeC <=0 then
        txtFightNum:setText(0)
    else
        txtFightNum:setText(challengeC)
    end
    

    local txtTop = GetElement(self.m_root,"txtTopFloor_WndTowerScroll", WZUILabelTTF)
    txtTop:setText(self.UserData.topFloor..LocalStrings.TOWER_LEVEL2)

    if self.m_nTowerType ~= 2 then 
        local txtTop = GetElement(self.m_root,"txtResertT_WndTowerScroll", WZUILabelTTF)
        local vipData = self:_getVipTowerData()
        
        local count = 0
        if vipData ~= nil then
            count = vipData.count
        end
        txtTop:setText(count-self.UserData.resetTimes)
    end
end

-- 当处于扫荡状态时，需要提示倒计时
function WndTowerScroll:_updateSweepState()
    if self.SweepState == 1 and self.m_nSweepTime > 0 then
        if self.m_nTowerType == 1 then return end 
        local conSweap =  GetElement(self.m_root,"conSweap_WndTowerScroll",WZUIContainer)
        local txtSweapLT = GetElement(conSweap,"txtSweapLT_WndTowerScroll",WZUILabelTTF)
        local sec = math.floor(self.m_nSweepTime%60)
        local min = math.floor(self.m_nSweepTime/60)
        WZLog("WndTowerScroll:_updateSweepState = ",sec,min)
        if min <10 and min > 0 then
            if sec < 10 then
               txtSweapLT:setText("0"..min..":0"..sec)
            else
               txtSweapLT:setText("0"..min..":"..sec)
            end
           
        elseif min <=0 then
            if sec < 10 then
              txtSweapLT:setText("00:0"..sec)
            else
              txtSweapLT:setText("00:"..sec)
            end
        else
            if sec < 10 then
                txtSweapLT:setText(min..":0"..sec)
            else
                txtSweapLT:setText(min..":"..sec)
            end
        end
        local textLen = string.len(txtSweapLT:getText())

        if textLen <= 5 and textLen > 2 and ProjConfig.LANGUAGE == "cn" then
            GetElement(conSweap,"txtSweapLTD_WndTowerScroll",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.236667,0.5))
        elseif textLen <=5 and ProjConfig.LANGUAGE == "cn" then
            GetElement(conSweap,"txtSweapLTD_WndTowerScroll",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.343334,0.5))
        end

        local costDiamond = self:wetherCanSweep(self.UserData.nowFloor)
        local txtSweapFast = GetElement(self.m_root,"txtSweapFast_WndTowerScroll",WZUILabelTTF)
        txtSweapFast:setText((costDiamond*self.m_nAddSpeedPrice))
        local imgDiamond = GetElement(self.m_root, "imgDiamond_WndTowerScroll", WZUIImage)
        if imgDiamond then
            if CacheCenter:getGameParam().isUseTicket == "0" then
                imgDiamond:setFile(GDatatab_item["id_70"].icon)
            else
                imgDiamond:setFile(GDatatab_item["id_1"].icon)
            end
            imgDiamond:setScale(0.45)
        end
    else
        self:_conTipsShow(false,false,true)
    end
end

--@brief  根据不同的状态，显示底部不同的容器
function WndTowerScroll:_conTipsShow(sweepIng,resert,original)
    WZLog("WndTowerScroll:_conTipsShow = ",sweepIng,resert,original)
    local conSweap2 = GetElement(self.m_root,"conSweap2_WndTowerScroll", WZUIContainer)
    local conResert = GetElement(self.m_root,"conResert_WndTowerScroll", WZUIContainer)
    local conStart = GetElement(self.m_root,"conStart_WndTowerScroll",WZUIContainer)
    local conSweaping = GetElement(self.m_root,"conSweaping_WndTowerScroll",WZUIContainer)
    local conStopSweaping = GetElement(self.m_root,"conStopSweaping_WndTowerScroll",WZUIContainer)
    conSweaping:setVisible(false)
    conSweap2:setVisible(false)
    conResert:setVisible(false)
    conStart:setVisible(false)
    conStopSweaping:setVisible(false)
    if sweepIng then
        conSweap2:setVisible(true)
        conSweaping:setVisible(true)
        conStopSweaping:setVisible(true)
    elseif original then
        conStart:setVisible(true)
        conResert:setVisible(true)
    end

    if self.m_nTowerType == 2 then 
        conResert:setVisible(false)
        GetElement(self.m_root, "txtBtnReset_WndTowerScroll", WZUILabelTTF):setTextKey("QUICK_JOIN")
    end
end

--@brief  显示宝箱信息
function WndTowerScroll:_checkInfoTips(element,nFloor,pt)
    WZLog("WndTowerScroll:_checkInfoTips = ",nFloor,pt.x,pt.y,self.UserData.nowFloor)
    local bGetted = false
    if nFloor / 2 <= self.UserData.nowFloor then
        bGetted = true
    end
    local cell, tcell ,index
    if nFloor%2 == 0 then -- 奖励
        cell, tcell = CellTowerRewardTip:createElement()
        index = nFloor /2
        
    else -- 关卡
        index = (nFloor + 1)/2
        local nMonsterId = self.Data[index].monster[1][1]
        local tMonster = GDatatab_monster["id_"..nMonsterId]
        local tData
        WZLog("WndTowerScroll:_checkInfoTips", tMonster.AniFileId)
        if tMonster.AniFileId == -1 then 
            tData = {name = tMonster.name, desc = tMonster.script, sex = tMonster.suitConfig[1][1], head = tMonster.suitConfig[1][2], face = tMonster.suitConfig[1][3]}
        else
            tData = {name = tMonster.name, desc = tMonster.script, icon = MONSTER_IMAGE_PATH..tMonster.moster_picture..".png"}
        end
        WndTips:show(element, self.m_root, 15, tData, GlobalMethod:ccp(400,0))
        WndTips.m_root:setShowAll(true)
        return 
    end
    local txtGet = GetElement(cell,"txtGet_CellTowerRewardTip",WZUILabelTTF)
    tcell:isFirstPass(false)
    if bGetted then
        txtGet:setText(LocalStrings.HAS_GET)
    elseif self:isFristPass(self.Data[index].floor_num) then
        txtGet:setText(LocalStrings.FIRST_PASS .. LocalStrings.GET)
        tcell:isFirstPass(true)
    else
        txtGet:setText(LocalStrings.KING_WILL_AWARD)
    end
    tcell:setData(self.Data[index])
    self.m_conScrollMap:addChild(cell,5,88)

    -- 位置处理
    local anchor = GlobalMethod:ccp(0.5,0)
    cell:setAnchorPoint(anchor)
    cell:setPosition(GlobalMethod:ccp(pt.x,pt.y+60))
end

function WndTowerScroll:_clickContainerTips(p)
    local tips = self.m_root:getChildByTag(88)
    if not tips then return true end

    local size = tips:getContentSize()
    local pos = tips:convertToWorldSpace(GlobalMethod:ccp(0, 0))
    local rect = CCRectMake(pos.x, pos.y, size.width, size.height)
    if rect:containsPoint(p) then return true  end
    return false
end

--@brief 触发移动触摸时需要检测是否移动地图
--@param p :触摸的点
function WndTowerScroll:_isCanMoveMap(p)
    local bCanMove = false
    for i,v in ipairs(self.m_tCollisionList) do
        if v:containsPoint(p) then
            bCanMove = false
        end
    end
    return bCanMove
end

--@brief   是否需要X轴旋转
function WndTowerScroll:_isNeedFlipX(node, floorData)
    if node then
        local nX, nY =  node:getPosition()
        if self.m_nTowerType == 0 then 
            if nX < 350 then
                return true
            end
        elseif self.m_nTowerType == 2 and floorData then 
            local monsterData = GDatatab_monster["id_" .. floorData.monster[1][1]]
            if monsterData then 
                if monsterData.suitConfig == 999 then 
                    if nX >= 350 then
                        return true
                    end
                else
                    if nX < 350 then
                        return true
                    end
                end
            end
        else
            if nX >= 350 then
                return true
            end
        end
    end
    return false
end

--@brief   X轴旋转
function WndTowerScroll:_flipX(parNode,animNode, floorData)
    if self:_isNeedFlipX(parNode, floorData) then
        animNode:setFlipX(true)
    end
end

--@brief  玩家是否需要旋转
function WndTowerScroll:_playerIsNeedFlipX()
    if self.m_tPlayerAni and self.UserData.nowFloor > 0 then
        local pos = self.m_tPlayerAni:getPosition()
        local x = pos.x
        local y = pos.y
        if x < 200 then
            if not self.m_tPlayerAni:isFlipX() then
                self.m_tPlayerAni:setFlipX(true)
            else
                self.m_tPlayerAni:setFlipX(false)
            end
        elseif x > 650 then
            if not self.m_tPlayerAni:isFlipX() then
                self.m_tPlayerAni:setFlipX(true)
            else
                self.m_tPlayerAni:setFlipX(false)
            end
        end

        self:playerHpFlipX()
    end
end

--@breif  X轴旋转
function WndTowerScroll:_playerFlipX()
    if self.m_tPlayerAni then
        if not self.m_tPlayerAni:isFlipX() then
            self.m_tPlayerAni:setFlipX(true)
        else
            self.m_tPlayerAni:setFlipX(false)
        end
    end

    self:playerHpFlipX()
end

--@brief  每隔8秒监听玩家是否有操作
function WndTowerScroll:_scheduleMonitingPlayerAction(element)
    WZLog("_scheduleMonitingPlayerAction")
    if self.m_tPlayerAni == nil then
        element:disableSchedule()
        return
    end
    local pos = self.m_tPlayerAni:getPosition()
    local px = pos.x
    local py = pos.y
    local bSame = false
    if #self.m_tempPlayerPs == 2 then
        if self.m_tempPlayerPs[1] == px and self.m_tempPlayerPs[2] == py then
            bSame = true
        end
    end
    self.m_tempPlayerPs = {}
    table.insert(self.m_tempPlayerPs,px)
    table.insert(self.m_tempPlayerPs,py)
    if self.m_tempNode ~= nil then
        self.m_tempNode:setVisible(false)
    end
    
    if bSame and self.SweepState == 0 then
        local nextFloor = self:findNextFloor()
        if nextFloor ~= nil then
            local child = nextFloor:getChildElement("conNoneActionTip_WndTowerScroll")
            if child ~= nil then
                self.m_tempNode = child
                child:setVisible(true)
                if ProjConfig.LANGUAGE == "es" then
                    GetElement(child,"txtClickMeTotry_WndTowerScroll",WZUILabelTTF):setScale(0.8)
                end
            end
        end
    end
end

--@brief    根据塔类型显示或不显示相应的内容
function WndTowerScroll:_showContentByType()
    -- body
    local conSweap = GetElement(self.m_root, "conSweap_WndTowerScroll", WZUIContainer)
    local conHightRecord = GetElement(self.m_root, "conHightRecord_WndTowerScroll", WZUIContainer)
    -- local conRank = GetElement(self.m_root, "conRank_WdTowerScroll", WZUIContainer)
    local conForBuff = GetElement(self.m_root, "conForBuff_WndTowerScroll", WZUIContainer)
    local imgBtnSwitch = GetElement(self.m_root, "imgBtnSwitch_WndTowerScroll", WZUIImage)
    local conswept = GetElement(self.m_root,"conSwept_WndTowerScroll",WZUIContainer)

    if self.m_nTowerType == 0 then --怪物塔
        conSweap:setVisible(true)
        conHightRecord:setVisible(true)
        -- conRank:setVisible(true)
        conForBuff:setVisible(false)
        imgBtnSwitch:setFile("ui/copy/common_icon_herotowerbtn.png")
        GetElement(self.m_root, "imgHeroTowerRed_WndTowerScroll", WZUIImage):setVisible(GlobalGame.g_tRedPointList.heroTower)
        if SceneCopy.m_tCellTopHandle then
            SceneCopy.m_tCellTopHandle:setTitleFile("ui/common/common_icon_slt.png")
        end
        conswept:setVisible(true)
    elseif self.m_nTowerType == 1 then --英雄塔
        conSweap:setVisible(false)
        conHightRecord:setVisible(false)
        -- conRank:setVisible(true)
        conForBuff:setVisible(true)
        imgBtnSwitch:setFile("ui/copy/common_icon_towerbtn.png")
        if SceneCopy.m_tCellTopHandle then 
            SceneCopy.m_tCellTopHandle:setTitleFile("ui/common/common_icon_yxt.png")
        end

        local imgBuffIcon = GetElement(self.m_root, "imgBuffIcon_WndTowerScroll", WZUIImage)
        GetElement(self.m_root, "imgHeroTowerRed_WndTowerScroll", WZUIImage):setVisible(false)
        if imgBuffIcon then 
            if g_myHeroTowerBuffId then 
                local buffData = GDatatab_herotower_map["id_" .. g_myHeroTowerBuffId]
                imgBuffIcon:setFile(buffData.buff2icon)
            end
        end
    elseif self.m_nTowerType == 2 then --噩梦塔
        conSweap:setVisible(true)
        conHightRecord:setVisible(true)
        -- conRank:setVisible(true)
        conForBuff:setVisible(false)
        GetElement(self.m_root, "conResert_WndTowerScroll", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "txtBtnReset_WndTowerScroll", WZUILabelTTF):setTextKey("QUICK_JOIN")

        GetElement(self.m_root, "btnSwitchMode_WndTowerScroll", WZUIButton):setVisible(false)
        GetElement(self.m_root, "imgHeroTowerRed_WndTowerScroll", WZUIImage):setVisible(GlobalGame.g_tRedPointList.heroTower)
        if SceneCopy.m_tCellTopHandle then
            SceneCopy.m_tCellTopHandle:setTitleFile("ui/common/common_icon_xkhj.png")
        end
    end
end

--@brief    英雄塔
--@brief    更新界面
function WndTowerScroll:_updateHero()
    if self.m_root == nil or self.m_tEnemyData == nil then
        return
    end
    
    self:_showContentByType()
    self:initMapHero()
end

--@brief  初始化英雄塔地图信息
function WndTowerScroll:initMapHero()
    WZLog("WndTowerScroll:initMapHero")
    if self.m_root == nil or self.m_tEnemyData == nil then
        return
    end

    self.m_conScrollMap = GetElement(self.m_root,"conScrollMap_WndTowerScroll",WZUIContainer)
    self.m_conScrollMap:removeAllChildrenWithCleanup(true)

    self.m_bPlayerMoveOut = false
    self.m_bLoadMapFinish = false

    self.m_nInitMapCount =  3 --最多加载三页(一页为640的高度)
    self.m_nLoadCount = 0
    self.m_bFirstLoad = true
    self.m_tPlayerStartP = nil
    self.m_oBeforeFloor = nil
    self.m_tPlayerAni = nil
    self.m_tempNode  = nil

    self.m_nPlayerStartIndex = 0
    self.m_nLoadMapDataIndex = 0

    local movMap = GetElement(self.m_root,"movMap_WndTowerScroll",WZUIMoveContainer)
    movMap:setTouchEnable(false)
    self.m_nPlayerCurIndex = self.m_nMyFloor
    if self.m_nMyFloor > 0 and self.m_tHeroTowerBoxState[self.m_nMyFloor] == 2 then
        self.m_nPlayerCurIndex = self.m_nPlayerCurIndex + 1
    end

    self.m_tOLevels = {}
    local bFirstMapScaleX = false  --第一张地图是否进行X轴反转

    self:loadMap(bFirstMapScaleX, 3)
    movMap:enableSchedule("addHurdlesToMapHero")
end

--@brief  添加小关卡到地图上
function WndTowerScroll:addHurdlesToMapHero(element)
    WZLog("WndTowerScroll:addHurdlesToMapHero =",self.m_nPlayerStartIndex)
    local language = ProjConfig.LANGUAGE
    if element ~= nil then
        element:disableSchedule()
    end
    LEVELCOUNTPERBLOCK = 4  --第一层只加载4个小层，二、三就加载6个小层
    local bScale = false
    local bFirstMapScaleX = false
    for i=1,3 do
        local conMap = self.m_conScrollMap:getChildByTag(i*1024)
        if conMap ~= nil then
            conMap = WZUIContainer:luaTo(conMap)
        else
            break
        end
        local imgMap = GetElement(conMap,"imgMap_WndTowerScroll",WZUIImage)
        local tempX = imgMap:getScaleX()
        if tempX < 0  then
            if i == 1 then
                bFirstMapScaleX = true
            end
            bScale = true
        else
            bScale = false
        end
        if i > 1 then
           LEVELCOUNTPERBLOCK = 6  --第一层只加载4个小层，二、三就加载6个小层
        end
        for j=1,LEVELCOUNTPERBLOCK do
            local tFloorInfo = nil 
            
            if self.m_nPlayerStartIndex % 2 == 1 then
                if self.m_nLoadMapDataIndex <= self.m_nTowerMapCount then
                    tFloorInfo = self.m_tEnemyData[self.m_nLoadMapDataIndex]
                    self.m_tFloorInfo = tFloorInfo
                end
            end
            if self.m_nPlayerStartIndex <=  self.m_nCountFloor*2  then  --英雄塔副本所有层是否已加载完毕
                local CellFloor = CreateElement("CellFloor_WndTowerScroll")
                CellFloor:setTag(self.m_nPlayerStartIndex)
                
                local cellFloor = {}
                table.insert(cellFloor,self.m_nPlayerStartIndex)
                table.insert(cellFloor,CellFloor)
                table.insert(self.m_tOLevels,cellFloor)
                
                if bScale then
                    if i~=1 then
                        CellFloor:setRelativePosition(GlobalMethod:ccp(tFloorPt[4+j+2][1],tFloorPt[4+j+2][2]))
                    elseif i == 1 then
                        CellFloor:setRelativePosition(GlobalMethod:ccp(tFloorPt[4+j+4][1],tFloorPt[4+j+4][2]))
                    end
                else
                    if i < 3 and not bFirstMapScaleX then
                        CellFloor:setRelativePosition(GlobalMethod:ccp(tFloorPt[j+2][1],tFloorPt[j+2][2]))
                    else
                        CellFloor:setRelativePosition(GlobalMethod:ccp(tFloorPt[j][1],tFloorPt[j][2]))
                    end
                end
                CellFloor:setVisible(true)
                local armTowerStart = GetElement(CellFloor,"armTowerStart_WndTowerScroll",WZUIArmature)
                local imgFloorName = GetElement(CellFloor,"imgFloorName_WndTowerScroll",WZUIImage)
                local img2 = GetElement(CellFloor,"img2_WndTowerScroll",WZUIImage)
                local img1 = GetElement(CellFloor,"img1_WndTowerScroll",WZUIImage)
                local atlasFont = GetElement(CellFloor,"atlasFont_WndTowerScroll",WZUILabelAtlasFont)
                if self.m_nPlayerStartIndex == 0 then
                   armTowerStart:setVisible(true)
                   imgFloorName:setVisible(true)
                else
                    if self.m_nPlayerStartIndex <= 400 then
                        if self.m_nPlayerStartIndex % 2 == 1 then
                            if self.m_tFloorInfo.towerInfo.num < 10 then
                                img1:setRelativePosition(GlobalMethod:ccp(0.256234,0.583007))
                                img2:setRelativePosition(GlobalMethod:ccp(0.721605,0.583007))
                            end
                            if language == "en" or language == "th" then
                                img1:setVisible(false)
                                img2:setVisible(true)
                            elseif language == "vn" then
                                img1:setFile("ui/common/common_icon_ceng.png")
                                img1:setVisible(true)
                                img2:setVisible(false)
                            elseif language == "pt" then
                                img1:setVisible(false)
                                img2:setVisible(true)
                                atlasFont:setRelativePosition(GlobalMethod:ccp(0.266088,0.583007))
                                img2:setRelativePosition(GlobalMethod:ccp(0.726367,0.583007))                                
                            elseif language == "es" then
                                atlasFont:setScale(0.8)
                                img1:setVisible(true)
                                img2:setVisible(true)
                            else
                                img1:setVisible(true)
                                img2:setVisible(true)
                            end
                            atlasFont:setVisible(true)
                            atlasFont:setText(tFloorInfo.towerInfo.num)
                            if ProjConfig.LANGUAGE == "es" then
                                atlasFont:setScale(0.8)
                            end
                        else
                            local conFloorInfo = GetElement(CellFloor,"conFloorInfo_WndTowerScroll",WZUIContainer)
                            conFloorInfo:setVisible(false)
                        end
                    end
                end
               
                local conPlayerFigure = GetElement(CellFloor,"conPlayerFigure_WndTowerScroll",WZUIContainer)
                local monsterCon = conPlayerFigure:getChildByTag(1144)
                if self.m_nPlayerStartIndex >= self.m_nMyFloor * 2 and self.m_nPlayerStartIndex % 2 == 0 and self.m_nPlayerStartIndex ~=0 and self.m_nPlayerStartIndex - self.m_nMyFloor ~= self.m_nMyFloor and self.m_tFloorInfo ~= nil and  self.m_tFloorInfo.towerInfo.floor_reward ~= -1 then
                --    WZLog("WndTowerScroll:addHurdlesToMapHero 444")
                    local img = self:createTreasureBox(self.m_tFloorInfo.towerInfo.icon)
                    conPlayerFigure:addChild(img)
                elseif self.m_nPlayerStartIndex >= self.m_nMyFloor * 2 and self.m_nPlayerStartIndex % 2 == 0 and self.m_nPlayerStartIndex ~=0 and self.m_nPlayerStartIndex - self.m_nMyFloor == self.m_nMyFloor and self.m_bIsReward ==false and self.m_tFloorInfo ~= nil and  self.m_tFloorInfo.towerInfo.floor_reward ~= -1 then
                --    WZLog("WndTowerScroll:addHurdlesToMapHero 333")
                    local img = self:createTreasureBox(self.m_tFloorInfo.towerInfo.icon)
                    conPlayerFigure:addChild(img)
                elseif self.m_nPlayerStartIndex < self.m_nMyFloor * 2 and self.m_nPlayerStartIndex % 2 == 0 and self.m_nPlayerStartIndex ~=0 and self.m_tFloorInfo ~= nil and  self.m_tFloorInfo.towerInfo.floor_reward ~= -1 then
                --    WZLog("WndTowerScroll:addHurdlesToMapHero 222")
                    local img = self:createOpenTreauseBox(self.m_tFloorInfo.towerInfo.icon)
                    conPlayerFigure:addChild(img)
                -- elseif self.m_nPlayerStartIndex <= self.m_nMyFloor * 2 and self.m_nPlayerStartIndex % 2 == 0 and self.m_nPlayerStartIndex ~=0 and self.m_nPlayerStartIndex - self.m_nMyFloor == self.m_nMyFloor and self.m_bIsReward ==true and self.SweepState == 1 and self.m_tFloorInfo ~= nil and  self.m_tFloorInfo.towerInfo.floor_reward ~= -1 then
                --     local img = self:createOpenTreauseBox(self.m_tFloorInfo.towerInfo.icon)
                --     conPlayerFigure:addChild(img)
                elseif math.abs(self.m_nMyFloor * 2 -1) < self.m_nPlayerStartIndex or (self.m_nMyFloor == 0 and self.m_nPlayerStartIndex == 1 ) then
                    if tFloorInfo ~= nil then
                        local playerInfo = tFloorInfo.playerInfo
                        local conPlayer = self:_createPlayer(playerInfo)
                        conPlayer:setScale(0.5)
                        self:_flipX(CellFloor, conPlayer:getAnimNode())
                        monsterCon:addChild(conPlayer:getAnimNode())
                    end
                elseif  math.abs(self.m_nMyFloor * 2 -1) > self.m_nPlayerStartIndex  or (math.abs(self.m_nMyFloor * 2 -1) == self.m_nPlayerStartIndex and self.m_bIsReward )  then
                    if tFloorInfo ~= nil then
                        local playerInfo = tFloorInfo.playerInfo
                        local conPlayer = self:_createPlayer(playerInfo)
                        conPlayer:setScale(0.5)
                        self:_flipX(CellFloor, conPlayer:getAnimNode())
                        monsterCon:addChild(conPlayer:getAnimNode())

                        local imgLevelPassTag = GetElement(CellFloor,"imgLevelPassTag_WndTowerScroll",WZUIImage)
                        imgLevelPassTag:setVisible(true)
                        imgLevelPassTag:setZOrder(9999)
                    end
                end

                --找出玩家站在那层位置上
                WZLog("WndTowerScroll:addHurdlesToMapHero 111", self.m_nMyFloor, self.m_nPlayerStartIndex, tostring(self.m_bIsReward))
                if self.m_nMyFloor == self.m_nPlayerStartIndex and self.m_nMyFloor == 0 then
                    self.m_tPlayerStartP = CellFloor
                --    WZLog("WndTowerScroll:addHurdlesToMapHero 555")
                elseif self.m_nMyFloor == self.m_nPlayerStartIndex and self.m_nMyFloor ==1 and self.m_bIsReward == false then
                    self.m_tPlayerStartP = CellFloor
                --    WZLog("WndTowerScroll:addHurdlesToMapHero 666")
                elseif  self.m_nMyFloor == (self.m_nPlayerStartIndex+1) / 2 and self.m_bIsReward == false then
                    self.m_tPlayerStartP = CellFloor
                --    WZLog("WndTowerScroll:addHurdlesToMapHero 777")
                elseif self.m_nMyFloor == self.m_nPlayerStartIndex/2 and self.m_bIsReward == true  then
                    self.m_tPlayerStartP = CellFloor
                --    WZLog("WndTowerScroll:addHurdlesToMapHero 888")
                end

                if  self.m_tPlayerStartP ~= nil and self.m_oBeforeFloor == nil then
                    self.m_oBeforeFloor  = self.m_tPlayerStartP
                end                

                if self.m_tPlayerStartP and self.m_bFirstLoad then
                    self.m_bFirstLoad = false
                    if tFloorInfo ~= nil  then
                        local playerInfo = tFloorInfo.playerInfo
                        local conPlayer = self:_createPlayer(playerInfo)
                        conPlayer:setScale(0.5)
                        self:_flipX(CellFloor, conPlayer:getAnimNode())
                        monsterCon:addChild(conPlayer:getAnimNode())

                        monsterCon:setVisible(false)
                        local imgLevelPassTag = GetElement(CellFloor,"imgLevelPassTag_WndTowerScroll",WZUIImage)
                        imgLevelPassTag:setVisible(false)
                        imgLevelPassTag:setZOrder(9999)
                    elseif self.m_tFloorInfo ~= nil and self.m_tFloorInfo.towerInfo.floor_reward ~= -1 and not monsterCon:getChildByTag(12345) then
                        local img = self:createTreasureBox(self.m_tFloorInfo.towerInfo.icon)
                        img:setVisible(false)
                        conPlayerFigure:addChild(img)
                    end
                end

                if self.m_nPlayerStartIndex <= 400 then
                    WZLog("WndTowerScroll:loadMap two", j)
                    conMap:addChild(CellFloor)
                end
                
                self.m_nPlayerStartIndex = self.m_nPlayerStartIndex + 1
                if self.m_nPlayerStartIndex % 2 == 1 then
                    self.m_nLoadMapDataIndex = self.m_nLoadMapDataIndex  + 1
                end
            end
        end
        self.m_nLoadCount = self.m_nLoadCount + 1
    end

    local nextFloor = self:findNextFloor()
    
    self.m_oNextFloor = nextFloor
    if nextFloor ~= nil then
        nextFloor:getChildElement("imgArrow_WndTowerScroll"):setVisible(true)
        self:controlBounsBoxStatus(nextFloor,true,true)
    end
    WZLog("loadHeroMapFinish")
end

--@brief 创建怪物
function WndTowerScroll:_createPlayer(playerInfo)
    --body
    local tEquipment = {}
    table.insert(tEquipment, playerInfo.headId)
    table.insert(tEquipment, playerInfo.bodyId)
    table.insert(tEquipment, playerInfo.faceId)
    table.insert(tEquipment, playerInfo.wingId)

    local conPlayer = CreatePlayerFigure(playerInfo.sex, tEquipment,nil,nil,nil,nil,nil,nil,nil,nil,playerInfo.headColor,playerInfo.bodyColor, false)
    conPlayer:getAnimNode():setTag(12345)

    return conPlayer
end


--@brief    刷新对手
function WndTowerScroll:callRefreshEnemy(tEnamyData)
    -- body
    local tVipData = self:_getVipLimitData(tEnamyData)
    self.m_tClickEnemyData = tEnamyData
    --次數已經用完
    if tVipData == nil then
    --    MsgBoxManager:showTipBox(LocalStrings.CALL_TIMES_FINISH)
        return 
    end
    --vip等級不夠
    if tVipData.vip_level > CacheCenter:getPlayerInfo().vipLevel then 
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
        MsgBoxManager:showConfirmBox(LocalStrings.CALL_UNSUCCESS, self, self.needHigherCallBack, nil, tCustomUIConfig)
        return 
    end
    --提示需要消耗的钻石
    local txtContent = string.format(LocalStrings.TOWER_HERO_TEXT2, tVipData.cost[1][2])

    MsgBoxManager:showConfirmBox(txtContent,self,self.callSure, nil, nil)
end

function WndTowerScroll:callSure(nId, nResType)
    -- body
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WZLog("WndTowerScroll:callSure 222")
        local tVipData = self:_getVipLimitData(self.m_tClickEnemyData)
        if tVipData ~= nil then
            local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
            if not JudgeMoneyIsEnough(tVipData.cost[1][1], tVipData.cost[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, tCustomUIConfig, 1, self, self.sureUseDiamondInstead) then 
                return 
            end
        end
        
        self:sureUseDiamondInstead()
    end
end

--@brief    确认用钻石代替礼券召唤回调
function WndTowerScroll:sureUseDiamondInstead()
    -- body
    self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
    ProtocolProcessorSingleMap:send_MAP_ChangeHeroTowerEnemy(self.m_tClickEnemyData.towerInfo.num)
end

--@brief    获取当前VIP限购数据
function WndTowerScroll:_getVipLimitData(tEnemyData)
    -- body
    for key, value in pairs(GDatatab_vip_restriction) do
        if value.type == 27 and value.count == tEnemyData.refreshTimes + 1 then
            return value
        end
    end

    return nil 
end

--@brief    提示提升VIP等級的回调
--@param    nId:消息id
--@param    nResType:响应类型(超时，确定，取消)
function WndTowerScroll:needHigherCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

--@brief  英雄塔显示宝箱信息
function WndTowerScroll:_checkInfoTipsHero(element, nFloor, pt)
    WZLog("WndTowerScroll:_checkInfoTipsHero = ",nFloor,pt.x,pt.y, self.m_nMyFloor)
    local bGetted = false
    self.m_elementClick = element 

    if nFloor / 2 <= self.m_nMyFloor then
        bGetted = true
    end
    local cell, tcell ,index
    if nFloor%2 == 0 then -- 奖励
        index = nFloor /2 
--        self.m_tHeroTowerBoxState[index] = 1
        if index == self.m_nMyFloor and self.m_tHeroTowerBoxState[index] == 1 then 
            self:onChallengeCallBack()
            return 
        end
        cell, tcell = CellTowerRewardTip:createElement()
    else -- 关卡
        index = (nFloor + 1)/2
        local tData = self.m_tEnemyData[index]
        if index == self.m_nMyFloor + 1 then 
            if self.m_nMyFloor > 0 and self.m_tHeroTowerBoxState[self.m_nMyFloor] == 1 then 
                WndCheckOther:show(tData.playerInfo.playerId)
            else
                WndTips:show(element, self.m_root, 54, tData, GlobalMethod:ccp(-110,100), true)
            end
        else
            WndCheckOther:show(tData.playerInfo.playerId)
        end
        return 
    end
    local txtGet = GetElement(cell,"txtGet_CellTowerRewardTip",WZUILabelTTF)
    tcell:isFirstPass(false)
    if bGetted then
        txtGet:setText(LocalStrings.HAS_GET)
    else
        txtGet:setText(LocalStrings.KING_WILL_AWARD)
    end
    tcell:setData(self.m_tEnemyData[index].towerInfo)
    self.m_conScrollMap:addChild(cell, 5, 88)

    -- 位置处理
    local anchor = GlobalMethod:ccp(0.5, 0)
    cell:setAnchorPoint(anchor)
    cell:setPosition(GlobalMethod:ccp(pt.x, pt.y+60))
end

--@brief    创建玩家自己的血条
function WndTowerScroll:_createSelfHP(parentNode, percent)
    -- body
    local conHp = WZUIContainer:create()
    conHp:setUseAbsSize(true)
    conHp:setAbsContentSize(GlobalMethod:CCSize(125,25))
    conHp:setRelativePosition(GlobalMethod:ccp(0.5, 2.1))
    conHp:setScale(2)
    conHp:setTag(3838)
    parentNode:addChild(conHp)
    --
    local imgBG = WZUIImage:create()
    imgBG:setFile("ui/common/herotower_icon_progress2.png")
    imgBG:setUseOriginSize(true)
    imgBG:setTag(11)
    conHp:addChild(imgBG)
    --
    local prgHp = WZUIProgress:create()
    prgHp:setBgPicture("ui/common/herotower_icon_progress1.png")
    prgHp:setUseOriginSize(true)
    prgHp:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    prgHp:setPercentage(percent)
    prgHp:setTag(22)
    conHp:addChild(prgHp)
    --
    local txtHp = WZUILabelTTF:create()
    txtHp:setText("HP " .. percent .. "%")
    txtHp:setAnchorPoint(ccp(0.5,0.5))
    txtHp:setColor(GlobalMethod:ccc3(99,255,95))
    txtHp:setFontSize(16)
    txtHp:setEnableStroke(true)
    txtHp:setStrokeSize(2)
    txtHp:setStrokeColor(GlobalMethod:ccc3(0,72,3))
    txtHp:setTag(33)
    conHp:addChild(txtHp)
end

--@brief    玩家血量翻转
function WndTowerScroll:playerHpFlipX()
    -- body
    if self.m_tPlayerAni then 
        local isPlayerFlipX = self.m_tPlayerAni:isFlipX()
        WZLog("WndTowerScroll:playerHpFlipX", isPlayerFlipX)
        local conHp = self.m_tPlayerAni:getAnimNode():getChildByTag(3838)
        if conHp == nil then return end 
        local imgBG = conHp:getChildByTag(11)
        local prgHp = conHp:getChildByTag(22)
        local txtHp = conHp:getChildByTag(33)
        if isPlayerFlipX then 
            imgBG:setScaleX(-1)
            prgHp:setScaleX(-1)
            txtHp:setScaleX(-1)
        else
            imgBG:setScaleX(1)
            prgHp:setScaleX(1)
            txtHp:setScaleX(1)
        end
    end
end

--@brief    展示全屏buff
function WndTowerScroll:showHeroBuff()
    -- body
    if not self.m_bIsShowBigBuff then return end 
    if g_myHeroTowerBuffId == nil then return end 

    --本次登陆显示过就不显示了
    if g_bShowWndMsgConfirmBox ~= nil then
        for k,v in pairs(g_bShowWndMsgConfirmBox) do
            if v == "TOWER_DESC_HERO" then
                return 
            end
        end
    end

    if g_bShowWndMsgConfirmBox == nil then g_bShowWndMsgConfirmBox = {} end
    local bIsExist = false 
    for k,v in pairs(g_bShowWndMsgConfirmBox) do
        if v == "TOWER_DESC_HERO" then 
            bIsExist = true
            break 
        end
    end
    --没有保存这次提示的句子，加入这句
    if not bIsExist then 
        table.insert(g_bShowWndMsgConfirmBox, "TOWER_DESC_HERO")
    end

    local buffData = GDatatab_herotower_map["id_" .. g_myHeroTowerBuffId]
    if buffData == nil then return end 
    self.m_bIsShowBigBuff = false 
    GetElement(self.m_root, "CellBuffShow_WndTowerScroll", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "imgBuffIcon2_WndTowerScroll", WZUIImage):setFile(buffData.buff2icon)
    GetElement(self.m_root, "txtBuffName_WndTowerScroll", WZUILabelTTF):setText(buffData.name2)
end

--@brief    设置位置
function WndTowerScroll:_resetTextPosition()
    -- body
    if self.m_nTowerType == 2 then 
        GetElement(self.m_root, "txtAssistTime_WndTowerScroll", WZUILabelTTF):setVisible(true)
        GetElement(self.m_root, "conForRecord_WndTowerScroll", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.75,0.8))
        GetElement(self.m_root, "txtTop_WndTowerScroll", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.22,0.82))
        GetElement(self.m_root, "txtFight_WndTowerScroll", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.22,0.5))
    else
        GetElement(self.m_root, "conForRecord_WndTowerScroll", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.75,0.8))
    end
end

--@brief    重新设置滚动容器的大小
function WndTowerScroll:_resetMoveContainerSize()
    -- body
    local conScrollMap = GetElement(self.m_root, "conScrollMap_WndTowerScroll", WZUIContainer)
    local conMoveEle = GetElement(self.m_root, "conMoveEle_WndTowerScroll", WZUIContainer)
    if self.m_nTowerType == 1 then 
        conScrollMap:setAbsContentSize(GlobalMethod:CCSize(1136, 1970))
        conMoveEle:setAbsContentSize(GlobalMethod:CCSize(1136, 1970))
    else
        conScrollMap:setAbsContentSize(GlobalMethod:CCSize(1136, 2610))
        conMoveEle:setAbsContentSize(GlobalMethod:CCSize(1136, 2610))
    end
    conScrollMap:updateRelativeSize()
    conMoveEle:updateRelativeSize()
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Start----------------------------------------

--@brief    适配iphoneX 
function WndTowerScroll:_adaptIphoneX()
    if IsIphoneX() then
        GetElement(self.m_root, "conRankInfo_WndTowerScroll", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.1, 0.5))
    end
end

--@brief 英文适配函数
--@note  英文适配
function WndTowerScroll:_adaptLanguage_en()
    --body
	WZLog("WndTowerScroll:_adaptLanguage_en")
	-- GetElement(self.m_root,"txtSweap22_WndTowerScroll",WZUILabelTTF):setFontSize(16)
    local txtTop = GetElement(self.m_root,"txtTop_WndTowerScroll",WZUILabelTTF)
    txtTop:setFontSize(18)

    local txtSweapFast = GetElement(self.m_root,"txtSweapFast_WndTowerScroll",WZUILabelTTF)
    txtSweapFast:setRelativePosition(GlobalMethod:ccp(0.257602,0.5))
    txtSweapFast:setFontSize(16)
    local imgDiamond = GetElement(self.m_root,"imgDiamond_WndTowerScroll",WZUIImage)
    imgDiamond:setRelativePosition(GlobalMethod:ccp(0.354328,0.5))
    local txtQuicken = GetElement(self.m_root,"txtQuicken_WndTowerScroll",WZUILabelTTF)
    txtQuicken:setFontSize(16)
    txtQuicken:setRelativePosition(GlobalMethod:ccp(0.945188,0.5))

    local txtTop = GetElement(self.m_root,"txtTop_WndTowerScroll",WZUILabelTTF)
    txtTop:setFontSize(20)

    local txtFight = GetElement(self.m_root,"txtFight_WndTowerScroll",WZUILabelTTF)
    txtFight:setFontSize(20)
end

function WndTowerScroll:_adaptLanguage_pt()
    local txtTop = GetElement(self.m_root,"txtTop_WndTowerScroll",WZUILabelTTF)
    txtTop:setFontSize(20)
    
    local txtTopFloor = GetElement(self.m_root,"txtTopFloor_WndTowerScroll",WZUILabelTTF)
    txtTopFloor:setFontSize(20)

    -- local txtSweap22 = GetElement(self.m_root,"txtSweap22_WndTowerScroll",WZUILabelTTF)
    -- txtSweap22:setFontSize(18)
    -- txtSweap22:setRelativePosition(GlobalMethod:ccp(0.99006,0.5))

    local imgDiamond = GetElement(self.m_root,"imgDiamond_WndTowerScroll",WZUIImage)
    imgDiamond:setRelativePosition(GlobalMethod:ccp(0.35,0.484848))
    local txtSweapFast = GetElement(self.m_root,"txtSweapFast_WndTowerScroll",WZUILabelTTF)
    txtSweapFast:setRelativePosition(GlobalMethod:ccp(0.248718,0.5))
    txtSweapFast:setFontSize(18)    
    txtSweapFast:setScale(0.8)
    local txtQuicken = GetElement(self.m_root,"txtQuicken_WndTowerScroll",WZUILabelTTF)
    txtQuicken:setScale(0.8)
    txtQuicken:setRelativePosition(GlobalMethod:ccp(0.945188,0.5))

    local txtFight = GetElement(self.m_root,"txtFight_WndTowerScroll",WZUILabelTTF)
    txtFight:setFontSize(20)
end

function WndTowerScroll:_adaptLanguage_th()
    --body
    WZLog("WndTowerScroll:_adaptLanguage_th")
    -- local txtSweap22 = GetElement(self.m_root,"txtSweap22_WndTowerScroll",WZUILabelTTF)
    -- txtSweap22:setFontSize(18)
    -- txtSweap22:setRelativePosition(GlobalMethod:ccp(0.9,0.5))

    local imgDiamond = GetElement(self.m_root, "imgDiamond_WndTowerScroll", WZUIImage)
    imgDiamond:setRelativePosition(GlobalMethod:ccp(0.4,0.5))
    --GetElement(self.m_root,"txtSweapFast_WndTowerScroll",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.36,0.5))
end

function WndTowerScroll:_adaptLanguage_vn()
    --body
    WZLog("WndTowerScroll:_adaptLanguage_vn")
    local txtSweapLTD = GetElement(self.m_root,"txtSweapLTD_WndTowerScroll",WZUILabelTTF)
    txtSweapLTD:setRelativePosition(GlobalMethod:ccp(0.026667,0.5))
    txtSweapLTD:setFontSize(16)
    
    local conStopSweaping = GetElement(self.m_root,"conStopSweaping_WndTowerScroll",WZUIContainer)
    conStopSweaping:setRelativePosition(GlobalMethod:ccp(0.08104,0.075))
    conStopSweaping:setAbsContentSize(GlobalMethod:CCSize(156,66))
    conStopSweaping:updateRelativeSize()

    GetElement(conStopSweaping,"txtStopSweep_WndTowerScroll",WZUILabelTTF):setFontSize(18)

    local conSweaping = GetElement(self.m_root,"conSweaping_WndTowerScroll",WZUIContainer)
    conSweaping:setAbsContentSize(GlobalMethod:CCSize(176,66))
    conSweaping:updateRelativeSize()
    conSweaping:setRelativePosition(GlobalMethod:ccp(0.671743,0.0789449))

    local txtSweapFast = GetElement(conSweaping,"txtSweapFast_WndTowerScroll",WZUILabelTTF)
    txtSweapFast:setRelativePosition(GlobalMethod:ccp(0.348657,0.5))
    txtSweapFast:setFontSize(20)

    -- local txtSweap22 = GetElement(conSweaping,"txtSweap22_WndTowerScroll",WZUILabelTTF)
    -- txtSweap22:setRelativePosition(GlobalMethod:ccp(0.951598,0.5))
    -- txtSweap22:setFontSize(20)

    local imgDiamond = GetElement(conSweaping,"imgDiamond_WndTowerScroll",WZUIImage)
    imgDiamond:setRelativePosition(GlobalMethod:ccp(0.469712,0.484848))

    local txtTop = GetElement(self.m_root,"txtTop_WndTowerScroll",WZUILabelTTF)
    txtTop:setFontSize(16)
    local txtTopFloor = GetElement(self.m_root,"txtTopFloor_WndTowerScroll",WZUILabelTTF)
    txtTopFloor:setFontSize(16)
    local txtFight = GetElement(self.m_root,"txtFight_WndTowerScroll",WZUILabelTTF)
    txtFight:setFontSize(16)
    local txtFightNum = GetElement(self.m_root,"txtFightNum_WndTowerScroll",WZUILabelTTF)
    txtFightNum:setFontSize(16)
    local txtAssistTime = GetElement(self.m_root,"txtAssistTime_WndTowerScroll",WZUILabelTTF)
    txtAssistTime:setFontSize(16)
    local txtAssistNum = GetElement(self.m_root,"txtAssistNum_WndTowerScroll",WZUILabelTTF)
    txtAssistNum:setFontSize(16)

    local txtSweapFast = GetElement(self.m_root,"txtSweapFast_WndTowerScroll",WZUILabelTTF)
    txtSweapFast:setScale(0.8)
    txtSweapFast:setRelativePosition(GlobalMethod:ccp(0.174269,0.5))
    local imgDiamond = GetElement(self.m_root,"imgDiamond_WndTowerScroll",WZUIImage)
    imgDiamond:setScale(0.5)
    imgDiamond:setRelativePosition(GlobalMethod:ccp(0.385157,0.5))
    local txtQuicken = GetElement(self.m_root,"txtQuicken_WndTowerScroll",WZUILabelTTF)
    txtQuicken:setScale(0.8)
    txtQuicken:setRelativePosition(GlobalMethod:ccp(0.945188,0.5))

end

function WndTowerScroll:_adaptLanguage_tr() 
    local sweap = GetElement(self.m_root,"txtSweapLTD_WndTowerScroll",WZUILabelTTF)
    sweap:setFontSize(18)
    sweap:setDimensions(GlobalMethod:CCSize(150,0))

    local txtSweapFast = GetElement(self.m_root,"txtSweapFast_WndTowerScroll",WZUILabelTTF)
    txtSweapFast:setRelativePosition(GlobalMethod:ccp(0.26,0.5))
    txtSweapFast:setFontSize(18)
    local txtQuicken = GetElement(self.m_root,"txtQuicken_WndTowerScroll",WZUILabelTTF)
    txtQuicken:setScale(0.7)
    txtQuicken:setRelativePosition(GlobalMethod:ccp(0.95,0.5))
    local imgDiamond = GetElement(self.m_root,"imgDiamond_WndTowerScroll",WZUIImage)
    imgDiamond:setRelativePosition(GlobalMethod:ccp(0.38,0.484848))
end

function WndTowerScroll:_adaptLanguage_es(  )
    local txtSweapLTD = GetElement(self.m_root,"txtSweapLTD_WndTowerScroll",WZUILabelTTF)
    txtSweapLTD:setFontSize(16)
    txtSweapLTD:setRelativePosition(GlobalMethod:ccp(0.06,0.5))
    --GetElement(self.m_root,"txtSweap22_WndTowerScroll",WZUILabelTTF):setFontSize(18)
    local imgDiamond = GetElement(self.m_root,"imgDiamond_WndTowerScroll",WZUIImage)
    imgDiamond:setRelativePosition(GlobalMethod:ccp(0.35,0.484848))

    local txtSweapFast = GetElement(self.m_root,"txtSweapFast_WndTowerScroll",WZUILabelTTF)
    txtSweapFast:setRelativePosition(GlobalMethod:ccp(0.248718,0.5))
    txtSweapFast:setFontSize(18)
    txtSweapFast:setScale(0.8)
    local txtQuicken = GetElement(self.m_root,"txtQuicken_WndTowerScroll",WZUILabelTTF)
    txtQuicken:setScale(0.8)
    txtQuicken:setRelativePosition(GlobalMethod:ccp(0.945188,0.5))
end

function WndTowerScroll:_adaptLanguage_ug()
    local txtResertD = GetElement(self.m_root,"txtResertD_WndTowerScroll",WZUILabelTTF)
    txtResertD:setScale(0.7)
    txtResertD:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtResertD:setRelativePosition(GlobalMethod:ccp(0.95,0.5))
    local txtResertT = GetElement(self.m_root,"txtResertT_WndTowerScroll",WZUILabelTTF)
    txtResertT:setScale(0.7)
    txtResertT:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtResertT:setRelativePosition(GlobalMethod:ccp(0.17,0.5))

    local txtSweapLTD = GetElement(self.m_root,"txtSweapLTD_WndTowerScroll",WZUILabelTTF)
    txtSweapLTD:setScale(0.7)
    txtSweapLTD:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
    local txtSweapLT = GetElement(self.m_root,"txtSweapLT_WndTowerScroll",WZUILabelTTF)
    txtSweapLT:setScale(0.7)
    txtSweapLT:setRelativePosition(GlobalMethod:ccp(0.195,0.5))

    local txtbtnResert1 = GetElement(self.m_root,"txtbtnResert1_WndTowerScroll",WZUILabelTTF)
    txtbtnResert1:setScale(0.7)
    txtbtnResert1:setDimensions(GlobalMethod:CCSize(170))
    local txtbtnResert2 = GetElement(self.m_root,"txtbtnResert2_WndTowerScroll",WZUILabelTTF)
    txtbtnResert2:setScale(0.7)
    txtbtnResert2:setDimensions(GlobalMethod:CCSize(170))
    
    local imgDiamond = GetElement(self.m_root,"imgDiamond_WndTowerScroll",WZUIImage)
    imgDiamond:setScale(0.4)
    imgDiamond:setRelativePosition(GlobalMethod:ccp(0.36,0.484848))
    local txtSweapFast = GetElement(self.m_root,"txtSweapFast_WndTowerScroll",WZUILabelTTF)
    txtSweapFast:setScale(0.7)
    txtSweapFast:setRelativePosition(GlobalMethod:ccp(0.27,0.5))
    local txtQuicken = GetElement(self.m_root,"txtQuicken_WndTowerScroll",WZUILabelTTF)
    txtQuicken:setScale(0.7)
    txtQuicken:setRelativePosition(GlobalMethod:ccp(0.96,0.5))

    local txtStopSweep = GetElement(self.m_root,"txtStopSweep_WndTowerScroll",WZUILabelTTF)
    txtStopSweep:setScale(0.7)
    txtStopSweep:setDimensions(GlobalMethod:CCSize(170))

    local txtTop = GetElement(self.m_root,"txtTop_WndTowerScroll",WZUILabelTTF)
    txtTop:setScale(0.7)
    txtTop:setRelativePosition(GlobalMethod:ccp(0.95,0.674821))
    local txtFight = GetElement(self.m_root,"txtFight_WndTowerScroll",WZUILabelTTF)
    txtFight:setScale(0.7)
    txtFight:setRelativePosition(GlobalMethod:ccp(0.95,0.325178))
    local txtTopFloor = GetElement(self.m_root,"txtTopFloor_WndTowerScroll",WZUILabelTTF)
    txtTopFloor:setScale(0.7)
    txtTopFloor:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtTopFloor:setRelativePosition(GlobalMethod:ccp(0.54,0.674821))
    local txtFightNum = GetElement(self.m_root,"txtFightNum_WndTowerScroll",WZUILabelTTF)
    txtFightNum:setScale(0.7)
    txtFightNum:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtFightNum:setRelativePosition(GlobalMethod:ccp(0.35,0.325178))
end
-------------------------------------语言适配模块End----------------------------------------