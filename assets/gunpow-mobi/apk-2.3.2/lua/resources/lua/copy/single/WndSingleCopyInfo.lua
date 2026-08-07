--WndSingleCopyInfo.lua
--@brief	WndSingleCopyInfo的UI模块
--@date		2015/04/10
--@author	xiaoyu_wu
--@modify   qixiang_xie
--@note		单人副本关卡信息

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSingleCopyInfo:onEnter(element)
    WZLog("WndSingleCopyInfo:onEnter")
	self.m_root = element
    NotificationCenter:registerNotification(UPDATESINGLECOPYDATANOTIFICATION, self, self.updateData)
    self:_initUI()
    SceneCopy:setBackFunction(function()
        WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
        SceneCopy:setBackFunction(nil)
    end)
    
    self.m_toBattleLoadingScene = nil
    if self.m_nJumpIsland == 1 then
        self.m_nJumpIsland = nil
        WndSingleCopy:setShowIslandOwner(false)
        self:setContentVisible(false, true, false)
        self:sendRoomProtocol(1)
    elseif self.m_nJumpIsland == 2 then
        self.m_nJumpIsland = nil
        WndSingleCopy:setShowIslandOwner(false)
        self:setContentVisible(false, true, false)
    else
        --打开上一次关闭时的页签
        if self.m_nCheckBoxIndex == 1 then
            self:onClickShowLevelInfo()
        elseif self.m_nCheckBoxIndex == 2 then
            self:onClickShowIslandHost()
        elseif self.m_nCheckBoxIndex == 3 then
            self:onClickShowVedioList()
        end
    end
end

--@brief onEnter函数执行完成回调
function WndSingleCopyInfo:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true, "actionCallback", self)
    CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物

    ProtocolProcessorSingleMap:send_MAP_RefreshMapRecord(self.m_tLevelData.id)
    local useCopyId = WndSingleCopyInfo:getHostCopyId(self.m_tLevelData.id)
    WZLog("WndSingleCopyInfo:onEnterTransitionDidFinish", useCopyId)
    if useCopyId then
        ProtocolProcessorSingleMap:send_MAP_GetMapLandlordData(useCopyId)
    end

    if self.m_nCopyType == 3 then
        GetElement(self.m_root,"cbVideoInfo_WndSingleCopyInfo",WZUICheckBox):setVisible(false)
        GetElement(self.m_root,"conVedioSelect_WndSingleCopyInfo",WZUIContainer):setVisible(false)
    end
    -- local nStarNum = WndSingleCopy:getStarNumById(self.m_tLevelData.id)
    -- if nStarNum >= 3 then
    --     self:setContentVisible(false, true, false)
    -- end

    if CheckButtonShow(216) ~= true then
        GetElement(self.m_root,"cbHostInfo_WndSingleCopyInfo",WZUICheckBox):setVisible(false)
        GetElement(self.m_root,"conHostSelect_WndSingleCopyInfo",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"cbVideoInfo_WndSingleCopyInfo",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        GetElement(self.m_root,"conVedioSelect_WndSingleCopyInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    end

    if self.m_bIsEnterRoom == true then
        self.m_bIsEnterRoom = nil
        WndSingleCopyInfo:receiveEnterRoomOk(self.m_EnterRoomData.roomId,self.m_EnterRoomData.passWord,self.m_EnterRoomData.roomName,self.m_EnterRoomData.playerNumMode,self.m_EnterRoomData.mapId,self.m_EnterRoomData.wnersId,self.m_EnterRoomData.playerNum,self.m_EnterRoomData.seatUsed,self.m_EnterRoomData.playerId,self.m_EnterRoomData.serverId,self.m_EnterRoomData.playerName,self.m_EnterRoomData.playerLevel,self.m_EnterRoomData.playerReady,self.m_EnterRoomData.playerSex,self.m_EnterRoomData.playerEquipment,self.m_EnterRoomData.playerEquipmentLevel,self.m_EnterRoomData.vipLevel,self.m_EnterRoomData.player_title,self.m_EnterRoomData.qualifyingLevel,self.m_EnterRoomData.zsleve,self.m_EnterRoomData.playerStar,self.m_EnterRoomData.playerFighting,
            self.m_EnterRoomData.pet,self.m_EnterRoomData.extranInfo,self.m_EnterRoomData.playerHeadColour,self.m_EnterRoomData.playerBodyColour,self.m_EnterRoomData.mentoringStr,self.m_EnterRoomData.coupleStr,self.m_EnterRoomData.chumStr,self.m_EnterRoomData.coupleNum,self.m_EnterRoomData.chumNum,self.m_EnterRoomData.mentoringNum,self.m_EnterRoomData.matchLevel,self.m_EnterRoomData.matchscore,self.m_EnterRoomData.joinTimes,self.m_EnterRoomData.winTimes,self.m_EnterRoomData.continuousWinTimes,self.m_EnterRoomData.serviceId,self.m_EnterRoomData.assist,self.m_EnterRoomData.assistTimesState,self.m_EnterRoomData.floorState)
    end

     AdaptLanguage(self)
end

--@brief    弹窗动画完成后的回调
function WndSingleCopyInfo:actionCallback(element, data)
	--初始化界面
    TeachGroup1:startGroup({1,5,WndSingleCopyInfo.m_root}, {3,6,WndSingleCopyInfo.m_root}, {6,3,WndSingleCopyInfo.m_root}, {5,11,WndSingleCopyInfo.m_root}, {9,7,WndSingleCopyInfo.m_root}, {32,4,WndSingleCopyInfo.m_root})

    self:showTipForButton()

    self:showIslandRedDot()
end

--@brief    岛主红点
function WndSingleCopyInfo:showIslandRedDot()
    local tIslandOwnerRedData = CacheCenter:getIslandOwnerRedData()
    if tIslandOwnerRedData == nil then
        return
    end
    local bShow = false
    for i=1,#tIslandOwnerRedData do
        if tIslandOwnerRedData[i] == self.m_tLevelData.id then
            bShow = true
            break
        end
    end
    self:setIslandRedDot(bShow)
end

function WndSingleCopyInfo:setIslandRedDot(bShow)
    local imgHostInfoReddot = GetElement(self.m_root,"imgHostInfoReddot_WndSingleCopyInfo",WZUIImage)
    imgHostInfoReddot:setVisible(bShow)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSingleCopyInfo:onExit(element)
    if self.m_root then 
        local conMiddleInfo = GetElement(self.m_root,"conMiddleInfo_WndSingleCopyInfo",WZUIContainer)
        conMiddleInfo:disableSchedule()
    end

    self:exitRoom()
    
	self:_unInit()
    CacheCenter:unregisterUpatePlayerInfoObserver(self)
    NotificationCenter:unregisterNotification(nil, self)
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndSingleCopyInfo:onCloseClick(element)
    WZLog("WndSingleCopyInfo:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    g_bIsShowWndDressUp = true
    WindowManager:removeWindow(self.m_root, self, true)
	--WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
    WZLog("WndSingleCopyInfo = ",WndSingleCopy.m_luaCell,g_fastGetItemId)
    if WndSingleCopy.m_luaCell ~= nil and g_fastGetItemId ~= nil then
        local wndFastGetItems = WndFastGetItems:createElement()
        local skillInfo =  GDatatab_skill["id_" .. g_fastGetItemId]
        local upgradeInfo = skillInfo.upgrade[1]
        WndFastGetItems:setGetItemId(upgradeInfo[1])
        local itemCount = CacheCenter:getPlayerItemCountById(upgradeInfo[1]) 
        WndFastGetItems:setItemCount(itemCount,upgradeInfo[2])
        WindowManager:addWindow(wndFastGetItems,WndFastGetItems,nil,nil,nil,true)
        WndSingleCopy.m_luaCell = nil
    end
end

--@brief	动画播完后的回调
function WndSingleCopyInfo:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
end


--@brief	点击多次扫荡按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndSingleCopyInfo:onMultiSweep(element)
    WZLog("WndSingleCopyInfo:onMultiSweep ````````````", self.m_nSweepCount)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local count =  CacheCenter:getRemainAmount()
    if count <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    
    local nButtonId = 180   --功能开放表对应id
    local tBtnsInfo = GDatatab_button_info["id_"..nButtonId]
    if CacheCenter:getPlayerInfo().vipLevel < 2 and not whetherHaveWelfareCard() and CacheCenter:getPlayerInfo().level < tBtnsInfo.open_level then
        MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.WELFARECARD_VIP_TIP, tBtnsInfo.open_level, 2), self, self._EventToVIP, MSGBOXLEVEL_NORMAL, nil)
        return
    end
    if not self.m_bSweepFinish then
        return 
    end
    local nTotalCount = self.m_tLevelData.pass_times
    local nCurCount = math.max(self.m_nChallengeCount, 0)
    nCurCount = nTotalCount - nCurCount
    --if nCurCount <= 1 then
        if nCurCount < 1 then
            local canResert ,reserTimes = self:canResert()
            reserTimes = reserTimes - 1
            if not canResert then
                self:showTips(LocalStrings.NO_CHALLENGE_TIMES)
                return
            end
            local totalCount = self:getVipSingleCopy().count
            self.m_nCostCount = self:getVipSingleCopyCost(reserTimes+1)
            local tips = LocalStrings.CHALLEGE_OVER .. "," .. LocalStrings.SINGLE_RESERT_TIP
            MsgBoxManager:showConfirmBox(string.format(tips,self.m_nCostCount ,reserTimes,totalCount),self,self.needResetLevel, nil, nil)
            return
        else
            --self:showTips(LocalStrings.NO_CHALLENGE_TIMES)
        end
        --return 
    --end
    local sweepCount = self.m_nSweepCount
    if sweepCount < 1 then
        sweepCount = 1
    end
    local costVigorCount = (self.m_tLevelData.pass_consume + self.m_tLevelData.play_consume)*sweepCount
    if CacheCenter:getPlayerInfo().vigor < costVigorCount then
        judgeNotEnoughJump(self, self.needMoreEnergy)
       return 
    end
    local nSweepCoupon = self:_getSweepCouponCount()
    if nSweepCoupon <1 then
        --弹出购买扫荡券窗口
        MsgBoxManager:showConfirmCancelBox(LocalStrings.WIPEOUTNUM,self,self.needMoreSweep, nil, nil)
    else
        --限制扫荡中如果获得装备，需关闭扫荡窗口时才弹出穿上提示
        g_bIsShowWndDressUp = false
        g_tTempItemForLaterShow = {}
        --保存当前的章节
        SceneCopy:_saveRecentChallengeSection(self.m_tLevelData.id)
        SceneCopy:_saveChallengeTime()
        
        self.m_bSweepFinish = false
        self.m_nSweepType = 2
        if self.m_nCopyType == 3 then
            ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaids(self.m_nCurLevelID,sweepCount)
        else
            ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaids(self.m_tLevelData.id, sweepCount)
        end
        

        local eventData = {stageType = 1,stageId = 2,subStageId = 1,stageCount = 1, playTime = 0,resultType = 2}
        PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
    end
end

--@brief	点击扫荡按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndSingleCopyInfo:onSweep(element)
    WZLog("WndSingleCopyInfo:onSweep ------",self.m_bSweepFinish)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local count =  CacheCenter:getRemainAmount()
    if count <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    if not self.m_bSweepFinish then
        return 
    end
    local nTotalCount = self.m_tLevelData.pass_times
    local nCurCount = math.max(self.m_nChallengeCount, 0)
    nCurCount = nTotalCount - nCurCount
    if nCurCount <= 0 then
        local canResert ,reserTimes = self:canResert()
        reserTimes = reserTimes - 1
        if not canResert then
            self:showTips(LocalStrings.NO_CHALLENGE_TIMES)
            return
        end
        local totalCount = self:getVipSingleCopy().count
        self.m_nCostCount = self:getVipSingleCopyCost(reserTimes+1)
        local tips = LocalStrings.CHALLEGE_OVER .. "," .. LocalStrings.SINGLE_RESERT_TIP
        MsgBoxManager:showConfirmBox(string.format(tips,self.m_nCostCount ,reserTimes,totalCount),self,self.needResetLevel, nil, nil)
        return 
    end
    if CacheCenter:getPlayerInfo().vigor < self.m_tLevelData.pass_consume + self.m_tLevelData.play_consume then
        judgeNotEnoughJump(self, self.needMoreEnergy)
       return 
    end
    local nSweepCoupon = self:_getSweepCouponCount()
    if nSweepCoupon == 0 then
        --弹出购买扫荡券窗口
        MsgBoxManager:showConfirmCancelBox(LocalStrings.WIPEOUTNUM,self,self.needMoreSweep, nil, nil)
    else
        --限制扫荡中如果获得装备，需关闭扫荡窗口时才弹出穿上提示
        g_bIsShowWndDressUp = false
        g_tTempItemForLaterShow = {}
        SceneCopy:_saveRecentChallengeSection(self.m_tLevelData.id)
        SceneCopy:_saveChallengeTime()

        self.m_bSweepFinish = false
        self.m_nSweepType = 1
        if self.m_nCopyType == 3 then
            ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaids(self.m_nCurLevelID,1)
        else
            ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaids(self.m_tLevelData.id, 1)
        end

        local eventData = {stageType = 1,stageId = 2,subStageId = 1,stageCount = 1, playTime = 0,resultType = 2}
        PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
    end
end

--@brief  重置当前关卡
function WndSingleCopyInfo:onClickReset(element)
    WZLog("WndSingleCopyInfo:onClickReset")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nLoadingTag ~= nil then
        return
    end
    local canResert ,reserTimes = self:canResert()
    reserTimes = reserTimes - 1
    if not canResert then
        local nextVipData = self:getNextVipData()
        if nextVipData == nil then
            MsgBoxManager:showTipBox(LocalStrings.TODAY_RESERT_NOT_ENOUGH)
        else
            local msg = LocalStrings.TODAY_RESERT_NOT_ENOUGH .. "," .. LocalStrings.SINGLE_RESERT_TIP2
            MsgBoxManager:showConfirmBox(string.format(msg,nextVipData.vip_level),self,self.clickSureMoney,nil,nil)
        end
        return
    end
    local totalCount = self:getVipSingleCopy().count
    self.m_nCostCount = self:getVipSingleCopyCost(reserTimes+1)
    MsgBoxManager:showConfirmBox(string.format(LocalStrings.SINGLE_RESERT_TIP,self.m_nCostCount,reserTimes,totalCount),self,self.needResetLevel, nil, nil)
end

--@brief  是否进行重置回调
function WndSingleCopyInfo:needResetLevel(id,nResType)
    local monNum =  CacheCenter:getPlayerItemCountById(1) 
    WZLog("WndSingleCopyInfo:needResetLevel === ",self.m_nCostCount,monNum,self.m_nLoadingTag)
    if self.m_nLoadingTag ~= nil then
        return
    end
    if nResType == MSGBOXRESTYPE_CONFIRM then
         if CacheCenter:getGameParam().isUseTicket == "0" then 
            local monNum =  CacheCenter:getPlayerItemCountById(70) 
            if monNum < self.m_nCostCount then
                self.m_root:enableSchedule("scheduleShowConfirmBox",0.5)
                return
            end
        end
        if monNum < self.m_nCostCount then
            self.m_root:enableSchedule("scheduleShowConfirmBox",0.5)
            return
        else
            self:sureUseDiamondInstead()
        end
    end
end

--显示确认框出来
function WndSingleCopyInfo:scheduleShowConfirmBox(element)
    WZLog("WndSingleCopyInfo:scheduleShowConfirmBox")
    element:disableSchedule()
    if not JudgeMoneyIsEnough(70,self.m_nCostCount,nil,nil,12, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
        return
    end
    self:sureUseDiamondInstead()
end

--@brief    确认用钻石代替礼券重置次数确认按钮回调
function WndSingleCopyInfo:sureUseDiamondInstead()
    -- body
    ProtocolProcessorSingleMap:send_MAP_ResetSingleMap(self.m_tLevelData.id)
    self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
end


--@brief    点击确定充值回调
function WndSingleCopyInfo:clickSureMoney()
    WZLog("WndSingleCopyInfo:clickSureMoney")
    PassportSdkManager:gotoPaymentPage()
end


--@brief  是否购买扫荡卷回调
function WndSingleCopyInfo:needMoreSweep(id,nResType)
    WZLog("WndSingleCopyInfo:needMoreSweep")
    if nResType == MSGBOXRESTYPE_CONFIRM then
        if self.m_nCopyType == 3 then
            WndPurchase:showBuyInterface(6,201,self,self.buySweepCouponCallback)
        else
            WndPurchase:showBuyInterface(6,106,self,self.buySweepCouponCallback)
        end        
    end
end

--@brief   是否补充活力值回调
function WndSingleCopyInfo:needMoreEnergy(id,nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(1056) 
    end
end

--@brief    前往vip充值
function WndSingleCopyInfo:_EventToVIP( nId, nResType )
    WZLog("CellGameSingInItem:_EventToVIP")
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndVip:showWndUI(0)
    end
end

--@brief	点击挑战关卡按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndSingleCopyInfo:onChallenge(element)
    if CacheCenter:getPlayerInfo() == nil then return end
    CacheCenter.m_nPlayerLevel = CacheCenter:getPlayerInfo().level
    CacheCenter.m_nPlayerExp = CacheCenter:getPlayerInfo().exp
   
    local count =  CacheCenter:getRemainAmount()
    if count <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    TeachGroup1:endTeachStep({1,5},{3,6},{5,11},{9,7},{32,4})
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

     WZLog("-----------------fight pro data-----------------",CacheCenter.m_nPlayerLevel,CacheCenter.m_nPlayerExp)
    WZLog("WndSingleCopyInfo:onChallenge --------------------------", self.m_tLevelData.id, COPYTYPE_SINGLE)
    
    if self.m_nLoadingTag ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)
        self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
        return
    end

    local nChallengeCount = self.m_tLevelData.pass_times - math.max(self.m_nChallengeCount, 0) --可挑战次数
    if nChallengeCount == 0 then
        local canResert ,reserTimes = self:canResert()
        if not canResert then
            self:showTips(LocalStrings.NO_CHALLENGE_TIMES2)
            return
        end
        reserTimes = reserTimes -1
        local totalCount = self:getVipSingleCopy().count
        self.m_nCostCount = self:getVipSingleCopyCost(reserTimes+1)
        MsgBoxManager:showConfirmBox(string.format(LocalStrings.CHALLEGE_OVER .. "," .. LocalStrings.SINGLE_RESERT_TIP,self.m_nCostCount ,reserTimes,totalCount),self,self.needResetLevel, nil, nil)
        return
    end

    local costVigorCount = self.m_tLevelData.pass_consume + self.m_tLevelData.play_consume
    if CacheCenter:getPlayerInfo().vigor < costVigorCount then
        judgeNotEnoughJump(self, self.needMoreEnergy)
       return 
    end
    --保存挑战的章节
    SceneCopy:_saveRecentChallengeSection(self.m_tLevelData.id)
    SceneCopy:_saveChallengeTime()
    self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
    g_fastGetItemId = nil
    if self.m_nCopyType == 1 then
        self:_postChallengeEvent()
    end

    -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
    if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
        ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
    end
    if self.m_nCopyType == 3 then
        ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self.m_nCurLevelID, COPYTYPE_SINGLE)
    else
        ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self.m_tLevelData.id, COPYTYPE_SINGLE)
    end
    g_copyST = os.time()
end

--@brief	点击禁用态挑战关卡按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndSingleCopyInfo:onDisabledChallenge(element)
    WZLog("WndSingleCopyInfo:onDisabledChallenge")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --提示错误信息：关卡挑战次数不足，无法进行挑战
    self:showTips(LocalStrings.CHALLENGE_NOT_ENOUGH)
end

--@brief	点击怪物头像时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndSingleCopyInfo:onClickMonster(element)
    WZLog("WndSingleCopyInfo:onClickMonster")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   
    local nMonsterId = element:getTag()
    if nMonsterId == -1 then
        return
    end
    local tMonster = GDatatab_monster["id_"..nMonsterId]
    if tMonster.AniFileId == -1 or tMonster.suitConfig ~= -1  then
        local sex = tMonster.suitConfig[1][1]
        local headId = tMonster.suitConfig[1][2]
        local faceId = tMonster.suitConfig[1][3]
        local tData = {name=tMonster.name,desc=tMonster.script,head=headId,face=faceId,sex=sex}
        WndTips:show(element,self.m_root,15,tData,GlobalMethod:ccp(400,0))
        return
    end
    
    local tData = {name=tMonster.name,desc=tMonster.script,icon=MONSTER_IMAGE_PATH..tMonster.moster_picture..".png"}
    WndTips:show(element,self.m_root,15,tData,GlobalMethod:ccp(400,0))
    return

end

--@brief	开始点击窗口后的回调
--@param	element:窗口绑定的lua表
--@param    pt:坐标点
function WndSingleCopyInfo:onTouchBegan(element, pt)
    if WndSingleCopyInfo.m_root ~= nil then
        if WndSingleCopyInfo.m_root:getChildByTag(88) then WndSingleCopyInfo.m_root:removeChildByTag(88,true) end
    end
    if WndDressUp.m_root ~= nil and (not WndDressUp:checkPoint(pt)) then
        WndDressUp:onCloseClick()
    end
end

--@brief	显示提示信息
--@param	sMsg:信息
function WndSingleCopyInfo:showTips(sMsg)
    MsgBoxManager:showTipBox(sMsg)
end

--@brief    购买扫荡券完成后的回调
function WndSingleCopyInfo:buySweepCouponCallback()
    self:_updateSweepInfo()
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndSingleCopyInfo:onClickListItem(tItem, nTag, tData)
    WZLog("WndSingleCopyInfo:onClickListItem")
    WndItemInfo:onCloseClick()
    local offset = GlobalMethod:ccp(0,0)
    if nTag >= 4 then
		if tData.basicInfo.main_type == 4 or tData.basicInfo.main_type == 9 then
        	offset = GlobalMethod:ccp(100,0)
		end
    end
    self.m_tData = tData
    local data = tData
--    data.tBtnList = {LocalStrings.GET_ACCESS}
    WndItemInfo:showInfo(self.m_root,self.m_root,1,data,false,offset)    
    WndItemInfo:setClickButtonCallback(self,self.onClickGetItem)
end


function WndSingleCopyInfo:onClickGetItem(element)
    if not self.m_tData then return end
    WndFastGetItems:show(self.m_tData.id)
end
--@brief  更新扫荡状态，如果用户点击了一次扫荡时又点击了10次扫荡会造成冲突
function WndSingleCopyInfo:updateSweepStatus()
    self.m_bSweepFinish = true
    self:resetLoadingTag()
    --WndSweepResult:setSweepStatus(false)
end

--@brief    更新玩家基础数据，如果打开界面时，缓存数据没有到，就等待更新
function WndSingleCopyInfo:updatePlayerInfoData()
    WZLog("WndSingleCopyInfo:更新玩家基础数据")
    if self.m_root == nil then
        return
    end
    --弹活力值增加动画
    self:setAddVigorAni(CacheCenter:getPlayerInfo())
end

--@brief    更新活力值，播放活力动画
function WndSingleCopyInfo:setAddVigorAni(tData)
    if self.m_root == nil or tData == nil or g_nCurVigor == nil then
        return
    end

    --活力值
    local nExp = tData.vigor - g_nCurVigor
    if nExp ~= 0 and g_nCurVigor ~= nil and tonumber(nExp) > 1 then
        g_nCurVigor = tData.vigor
        local parentNode = GetElement(self.m_root, "conOutside_WndSingleCopyInfo", WZUIContainer)
        createActChangeAni(parentNode, "ui/common_num/common_num_yaoqianshuzi.png", "ui/common/common_icon_huoli.png", nExp)
        return
    end
end

--显示单人副本关卡信息
function WndSingleCopyInfo:onClickShowLevelInfo(element)
    WZLog("WndSingleCopyInfo:onClickShowLevelInfo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    self.m_nCheckBoxIndex = 1
    self:setContentVisible(true, false, false)
    self:sendRoomProtocol(2)
end

function WndSingleCopyInfo:onClickShowVedioList(element)
    WZLog("WndSingleCopyInfo:onClickShowVedioList")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    self.m_nCheckBoxIndex = 3
    self:setContentVisible(false, false, true)
    self:sendRoomProtocol(2)
end

--@brief    设置右框内容
function WndSingleCopyInfo:setContentVisible(bVisible1, bVisible2, bVisible3)
    -- body
    local conOutside = GetElement(self.m_root,"conOutside_WndSingleCopyInfo",WZUIContainer)
    --信息
    local cbLevelInfo = GetElement(conOutside,"cbLevelInfo_WndSingleCopyInfo",WZUICheckBox)
    cbLevelInfo:setTouchEnable(not bVisible1)
    if not bVisible1 then
        cbLevelInfo:setCheckIndex(0)
    end
    local conLeveInfoSelected = GetElement(conOutside,"conLeveInfoSelected_WndSingleCopyInfo",WZUIContainer)
    conLeveInfoSelected:setVisible(bVisible1)
    local conLevelInfo = GetElement(conOutside,"conLevelInfo_WndSingleCopyInfo",WZUIContainer)
    conLevelInfo:setVisible(bVisible1)
    GetElement(conOutside,"conNorReward_WndSingleCopyInfo",WZUIContainer):setVisible(bVisible1)
    --岛主
    local cbHostInfo = GetElement(conOutside,"cbHostInfo_WndSingleCopyInfo",WZUICheckBox)
    cbHostInfo:setTouchEnable(not bVisible2)
    if not bVisible2 then
        cbHostInfo:setCheckIndex(0)
    end
    local conHostSelect = GetElement(conOutside,"conHostSelect_WndSingleCopyInfo",WZUIContainer)
    conHostSelect:setVisible(bVisible2)
    local conMonsterList = GetElement(conOutside,"conMonsterList_WndSingleCopyInfo",WZUIContainer)
    conMonsterList:setVisible(not bVisible2)
    local conTopInfo = GetElement(conOutside,"conTopInfo_WndSingleCopyInfo",WZUIContainer)
    conTopInfo:setVisible(not bVisible2)
    local conIslangHostHead = GetElement(conOutside,"conIslangHostHead_WndSingleCopyInfo",WZUIContainer)
    if conIslangHostHead:isVisible() and bVisible2 then 
        conIslangHostHead:setVisible(false)
    end
    GetElement(conOutside,"conBottom_WndSingleCopyInfo",WZUIContainer):setVisible(not bVisible2)
    GetElement(conOutside,"conIslandOwner_WndSingleCopyInfo",WZUIContainer):setVisible(bVisible2)
    local btnRewardsSwitch = GetElement(self.m_root,"btnRewardsSwitch_WndSingleCopyInfo",WZUIButton)
    if self.m_tLevelData.map_type == 1 then
        btnRewardsSwitch:setVisible(false)
    elseif self.m_tLevelData.map_type == 2 or self.m_tLevelData.map_type == 3 then
        btnRewardsSwitch:setVisible(true)
    end
    -- --岛主协议
    if bVisible2 == true then
        ProtocolProcessorSceneBossRoom:regAll()
        self.m_root:enableSchedule("_updateCheckPlayerState", 1)
    else
        ProtocolProcessorSceneBossRoom:unregAll()
        self.m_root:disableSchedule()
    end
    --录像
    local cbVideoInfo = GetElement(conOutside,"cbVideoInfo_WndSingleCopyInfo",WZUICheckBox)
    cbVideoInfo:setTouchEnable(bVisible3)
    if not bVisible3 then
        cbVideoInfo:setCheckIndex(0)
    end
    local conVedioSelect = GetElement(conOutside,"conVedioSelect_WndSingleCopyInfo",WZUIContainer)
    conVedioSelect:setVisible(bVisible3)
    local conVideoList = GetElement(conOutside,"conVideoList_WndSingleCopyInfo",WZUIContainer)
    conVideoList:setVisible(bVisible3)
    if bVisible1 or bVisible3 then 
        self:_showIslandHostHead()
    end

    --功能开放
    if CheckButtonShow(216) ~= true then
        cbHostInfo:setVisible(false)
        conHostSelect:setVisible(false)
    end
end

--@brief    发送岛主房间协议
--@param    nType:1创建房间,2退出房间
function WndSingleCopyInfo:sendRoomProtocol(nType)
    if nType == 1 then
        self:createRoom()
    elseif nType == 2 then
        self:exitRoom()
    end
end

--@brief    获得主角的座位
--@return   #1:位置
function WndSingleCopyInfo:_getPlayerSeat()
    WZLog("WndSingleCopyInfo:_getPlayerSeat")
    
    if self.m_tData == nil then
        WZLog("WndSingleCopyInfo:_getPlayerSeat m_tData is nil.")
        return
    end
    
    for i,vId in ipairs(self.m_tData.playerId) do
        if vId == GlobalGame.g_tPlayerInfo.nPlayerId then
            return i-1
        end
    end
    
    return -1
end

--播放录像
function WndSingleCopyInfo:onClickOpenVideo(element)
    WZLog("WndSingleCopyInfo:onClickOpenVideo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local battleId = element:getTag()
    battleId = tonumber(battleId)
    ProtocolProcessorGlobal:send_BATTLE_Record(battleId,1,self.m_tLevelData.id)
    self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
end

--点击了录像头像,显示玩家信息
function WndSingleCopyInfo:onClickVideoHead(element)
    WZLog("WndSingleCopyInfo:onClickVideoHead")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local playerId = element:getParent():getTag()
    if playerId and playerId >0 then
        WndCheckOther:show(playerId)
    end
end

--@brief    点击岛主头像回调
function WndSingleCopyInfo:onClickIslandHost(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tIslandHostData and self.m_tIslandHostData.landlordId > 0 then
        WndCheckOther:show(self.m_tIslandHostData.landlordId)
    end
end


--@brief    点击岛主标签回调
function WndSingleCopyInfo:onClickShowIslandHost(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    if CheckButtonOpen(216) ~= true then
        GetElement(self.m_root,"cbHostInfo_WndSingleCopyInfo",WZUICheckBox):setCheckIndex(1)
        return
    end
    
    self.m_nCheckBoxIndex = 2
    self:setContentVisible(false, true, false)
    self:sendRoomProtocol(1)

    --取消红点
    local landlordConfig = json.decode(CacheCenter:getGameParam().landlordConfig)
    if self.m_tIslandHostData and #self.m_tIslandHostData.landlordMapId >= landlordConfig.maxLandlordNum then
        CacheCenter.m_tIslandOwnerRedData = {}
    else
        CacheCenter:removeIslandOwnerRedData(self.m_tLevelData.id)
    end
    self:setIslandRedDot(false)
    WndSingleCopy:showIslandOwnerRedDot()
end

--@brief    点击了挑战排名头像,显示玩家信息
function WndSingleCopyInfo:onClickRankHead(element)
    WZLog("WndSingleCopyInfo:onClickRankHead")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local playerId = element:getParent():getTag()
    if playerId and playerId >0 then
        WndCheckOther:show(playerId)
    end
end

--@brief    点击规则按钮回调
function WndSingleCopyInfo:onClickHostRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.SINGLECOPY_TEXT13)
end

--@brief    刷新
function WndSingleCopyInfo:_update()
    -- body
    WZLog("WndSingleCopyInfo:_update")             
    if self.m_root == nil then
        WZLog("WndSingleCopyInfo:_update m_root is nil.")
        return
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
function WndSingleCopyInfo:_createASeat(index,bgType,isused)
    WZLog("WndSingleCopyInfo:_createASeat",index,bgType,isused)
    local tagType = 1

    local cellElement,cellObj = CellRoomSeat:createElement(tagType)
    cellElement:setScale(0.8)
    cellElement:setTag(index)
    cellObj:setBgType(bgType)
    cellObj:setBGRectVisible(false)
    
    local conSeat = GetElement(self.m_root, "conSeat" .. index .. "_WndSingleCopyInfo")
    local imgPlayerStats = GetElement(conSeat,"imgPlayerStatus_WndSingleCopyInfo",WZUIImage)
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
function WndSingleCopyInfo:hasNullSeat()
    for i,v in ipairs(self.m_tData.playerId) do
        if v <= 0 and self.m_tData.seatUsed[i] then
            return true
        end
    end
    return false
end

--@brief    岛主相关 - 更新玩家座位
function WndSingleCopyInfo:updatePlayerSeat()
    WZLog("WndSingleCopyInfo:updatePlayerSeat")
    local isVoice = self:checkVoiceChannelLv(self.m_tData.roomChannel)
    local playerSeatIndex = self:_getPlayerSeat()
    playerSeatIndex = playerSeatIndex + 1
    GlobalGame.g_nPlayerInTeam = -1
    local indexTag = 0
    local maxCount = 3

    for i = 1, maxCount do
        self:checkCellChatBubble(i)
        local conSeat = WZUIContainer:luaTo(self.m_root:getChildElement("conSeat".. i .."_WndSingleCopyInfo"))
        local btnPlayerFigure  = WZUIButton:luaTo(conSeat:getChildElement("btnPlayerFigure_WndSingleCopyInfo"))
        local btnPlayerPet = GetElement(conSeat,"btnPlayerPet_WndSingleCopyInfo",WZUIButton)

        local conWeapon= WZUIContainer:luaTo(conSeat:getChildElement("conWeapon_WndSingleCopyInfo"))
        local imgWeaponIcon = WZUIImage:luaTo(conWeapon:getChildElement("imgWeaponIcon_WndSingleCopyInfo"))
        imgWeaponIcon:setFile("")

        local btnWeapon = WZUIButton:luaTo(conWeapon:getChildElement("btnWeapon_WndSingleCopyInfo"))
        btnWeapon:setTag(-1)

        local spWeapon1 = GetElement(conWeapon,"spWeapon_WndSingleCopyInfo",WZUISpine)
        spWeapon1:setVisible(false)
        local playerId = self.m_tData.playerId[i]
        self:showPlayerFigureAndPet(i)

        local conFigure = GetElement(conSeat,"conFigureVoice_WndSingleCopyInfo",WZUIContainer)
        local anim = GetElement(conSeat,"animFigureVoice_WndSingleCopyInfo",WZUISpine)
        local img = GetElement(conSeat,"imgFigureVoice_WndSingleCopyInfo",WZUIImage)

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

        local conSeatInfo = GetElement(conSeat,"conSeatInfo_WndSingleCopyInfo",WZUIContainer)
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
end

--@brief    岛主相关 - 检查语音渠道和等级
function WndSingleCopyInfo:checkVoiceChannelLv(channel)
    local isShow = false
    local battleMode = self.m_tData.battleMode
    WZLog("WndSingleCopyInfo:checkVoiceChannelLv", channel, battleMode, CheckTalkButtonShow(12))
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

--检查当前座位是否有冒泡,有的话检查玩家ID是否跟当前冒泡ID一样
function WndSingleCopyInfo:checkCellChatBubble(seatIndex)
    WZLog("WndSingleCopyInfo:checkCellChatBubble ")
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

--@brief  更新开始游戏按钮状态
function WndSingleCopyInfo:updateReaderBtn()
    WZLog("WndSingleCopyInfo:updateReaderBtn()")
    local txtBtnChallenge = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtBtnChallenge_WndSingleCopyInfo"))
    
    if self:getIsRoomOwner() then
        if self.m_tIslandHostData and self.m_tIslandHostData.revenge > 0 then
            txtBtnChallenge:setTextKey("ISLAND_OWNER_TEXT16")
        else
            txtBtnChallenge:setTextKey("ISLAND_OWNER_TEXT1")
        end
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
function WndSingleCopyInfo:showPlayerFigureAndPet(index)
    WZLog("WndSingleCopyInfo:showPlayerFigureAndPet")
    local playerEquipment = {}
    for i=1,5 do
        playerEquipment[i]= self.m_tData.playerEquipment[(index-1)*5+i]
    end
   
    if self.m_tData.seatUsed[index] and self.m_tData.playerId[index] > 0  then
        local conSeat = GetElement(self.m_root,"conSeat" .. index .. "_WndSingleCopyInfo",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_WndSingleCopyInfo",WZUIContainer)
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
        
        local conPet = GetElement(conSeat,"conPet_WndSingleCopyInfo",WZUIContainer)
        
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
        local conForNameAndTitle = GetElement(conSeat, "conForNameAndTitle_WndSingleCopyInfo", WZUIContainer)
        if conForNameAndTitle then
            local txtPlayerName = GetElement(conSeat, "txtPlayerName_WndSingleCopyInfo", WZUILabelTTF)
            txtPlayerName:setText(self.m_tData.playerName[index])
            local txtPlayerLv = GetElement(conSeat, "txtPlayerLv_WndSingleCopyInfo", WZUILabelTTF)
            txtPlayerLv:setText("Lv" .. self.m_tData.playerLevel[index])
            if playerId == CacheCenter:getPlayerInfo().id then
                txtPlayerName:setColor(GlobalMethod:ccc3(99,255,95))
            else
                txtPlayerName:setColor(GlobalMethod:ccc3(255,255,255))
            end
            local conTitle = GetElement(conSeat, "conTitle_WndSingleCopyInfo", WZUIContainer)
            local txtPlayerTitle = GetElement(conSeat, "txtPlayerTitle_WndSingleCopyInfo", WZUILabelTTF)
            local tempPoint = GlobalMethod:ccp(0.5, 1.9)
            if self.m_tData.playerTitle[index] and self.m_tData.playerTitle[index] ~= "" then
                CreateDesiSpine(conTitle, txtPlayerTitle, self.m_tData.playerTitle[index], tempPoint, nil, 0.9)
            end
        end
        -- --套装按钮
        -- if playerId == CacheCenter:getPlayerInfo().id then
        --     self:_addDressSuit(conSeat)
        -- end
    else
        local conSeat = GetElement(self.m_root,"conSeat" .. index .. "_WndSingleCopyInfo",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_WndSingleCopyInfo",WZUIContainer)
        local conPet = GetElement(conSeat,"conPet_WndSingleCopyInfo",WZUIContainer)
        local conForDressSuit = GetElement(conSeat,"conForDressSuit_WndSingleCopyInfo",WZUIContainer)
        local txtPlayerName = GetElement(conSeat, "txtPlayerName_WndSingleCopyInfo", WZUILabelTTF)
        local txtPlayerLv = GetElement(conSeat, "txtPlayerLv_WndSingleCopyInfo", WZUILabelTTF)
        local txtPlayerTitle = GetElement(conSeat, "txtPlayerTitle_WndSingleCopyInfo", WZUILabelTTF)
        local conTitle = GetElement(conSeat, "conTitle_WndSingleCopyInfo", WZUIContainer)
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

--@brief  更新座位信息
function WndSingleCopyInfo:_updateSeatInfo(luaObject,elementObject,index,bgType,isused)
    WZLog("WndSingleCopyInfo:_updateSeatInfo ",index)
    if luaObject ~= nil then
        luaObject:setBgType(bgType)
        local conSeat = GetElement(self.m_root,"conSeat" .. index .. "_WndSingleCopyInfo",WZUIContainer)
        local imgPlayerStats = WZUIImage:luaTo(conSeat:getChildElement("imgPlayerStatus_WndSingleCopyInfo"))
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
function WndSingleCopyInfo:createAPlayer(playerSex, equipment, headColor, bodyColor, animName)
    WZLog("WndSingleCopyInfo:createAPlayer")
    return CreatePlayerFigure(playerSex, equipment, animName, nil, nil, nil, nil, nil, nil, nil, headColor, bodyColor)
end


--@brief  显示宠物tip
function WndSingleCopyInfo:onClickPet(element)
    WZLog("WndSingleCopyInfo:onClickPet")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    local petInfo = self.m_tPlayersPetInfo[tag]
    if petInfo and petInfo.itemId ~= nil then
        if tag <= 3 then
            WndTips:show(element,self.m_root,13,petInfo,GlobalMethod:ccp(340,-40))
        else
            WndTips:show(element,self.m_root,13,petInfo,GlobalMethod:ccp(340,20))
        end
    end
end

--@brief 查看玩家武器信息
function WndSingleCopyInfo:onClickWeapon(element)
    WZLog("WndSingleCopyInfo:onClickWeapon")
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
    
    WndItemInfo:showInfo(element,self.m_root,1,weaponInfo,false,GlobalMethod:ccp(20,0))
end

--@brief    点击CellRoomSeat回调
function WndSingleCopyInfo:onClickCellRoomSeat(element)
    WZLog("WndSingleCopyInfo:onClickCellRoomSeat")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    self:_showPlayerInfo(tag)
end

--@brief    显示玩家信息
--@param    nPlayerSeat：玩家座位号
function WndSingleCopyInfo:_showPlayerInfo(nPlayerSeat)
    if self.m_tData.playerId[nPlayerSeat] then
        WndCheckOther:show(self.m_tData.playerId[nPlayerSeat])
    end
end

--@brief    点击邀请按钮回调
function WndSingleCopyInfo:showInviteFriends(element)
    if not self:hasNullSeat() then
        MsgBoxManager:showTipBox(LocalStrings.HALL_NO_SEAT)
        return
    end

    if self:getIsRoomOwner() then
        WndFriendList:showInterface(18, self, self.inviteFriend)
    end
end

-- 邀请界面点击邀请回调
function WndSingleCopyInfo:inviteFriend(tFriend,selectIndex,bAssistFight)
    WZLog("WndSingleCopyInfo:inviteFriend ",bAssistFight)
    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_Invite(self.m_tData.roomId, tFriend.id, bAssistFight)

    GetElement(self.m_root, "txtWaitWord_WndSingleCopyInfo", WZUILabelTTF):setVisible(true)
end

--@brief    设置房主和好友的文字提示
function WndSingleCopyInfo:setOwnerAndPartnerWord()
    -- body
    local txtWaitWord = GetElement(self.m_root, "txtWaitWord_WndSingleCopyInfo", WZUILabelTTF)
    if not self:getIsRoomOwner() then
        txtWaitWord:setVisible(true)
        txtWaitWord:setTextKey("DOUBLETOWER_TEXT13")
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
local tempPt = GlobalMethod:ccp(0,0)
--@brief	初始化界面
function WndSingleCopyInfo:_initUI()
    if self.m_root == nil then
        return
    end
    
    if self.m_tLevelData == nil then
        return
    end
    self:_initTowerVipData()
    self:_initLevelInfo()
    self:_initEnemyList()
    self:_initStarInfo()
    self:_initDropList()
    self:_updateSweepInfo()
    if self.m_nCopyType == 3 then
        local imgSweep = GetElement(self.m_root,"imgSweep_WndSingleCopyInfo",WZUIImage)
        local strFile = GDatatab_item["id_201"].icon
        imgSweep:setFile(strFile)
    end
end

--@brief	初始化关卡信息
function WndSingleCopyInfo:_initLevelInfo()
    local txtTopTitle = GetElement(self.m_root, "txtTopTitle_WndSingleCopyInfo", WZUILabelTTF)
    txtTopTitle:setText(self.m_tLevelData.map_name)

    --背景
    local img9SectionBk = GetElement(self.m_root, "img9SectionBk_WndSingleCopyInfo", WZUI9Image)
    if img9SectionBk then 
        img9SectionBk:setFile("ui/copy/common_fb_jm_bg" .. (self.m_tLevelData.section + 1) .. ".png")
    end
    
    local nTotalCount = self.m_tLevelData.pass_times
   
    local nCurCount = math.max(self.m_nChallengeCount, 0)
    local txtCount = GetElement(self.m_root, "txtCanFireCount_WndSingleCopyInfo", WZUILabelTTF)
    nCurCount = nTotalCount - nCurCount
    txtCount:setText(nCurCount.."/"..nTotalCount)

    local allVigour = self.m_tLevelData.pass_consume + self.m_tLevelData.play_consume

    local txtVigour = GetElement(self.m_root, "txtVigour_WndSingleCopyInfo", WZUILabelTTF)
    txtVigour:setText(allVigour)

    local txtDesc = GetElement(self.m_root, "txtDesc_WndSingleCopyInfo", WZUILabelTTF)
    txtDesc:setText(self.m_tLevelData.map_desc)

    if self.m_nCopyType == 2 then
        local nTotalCount = self.m_tLevelData.pass_times
        local nCurCount = math.max(self.m_nChallengeCount, 0)
        nCurCount = nTotalCount - nCurCount
        local conReset = GetElement(self.m_root,"conReset_WndSingleCopyInfo",WZUIContainer)
        if nCurCount < 1 and self.m_nCopyType ~= 3 then
            if conReset then
                conReset:setVisible(true)
            end
        else
            conReset:setVisible(false)
        end
    end
end

--@brief	初始化敌人列表
function WndSingleCopyInfo:_initEnemyList()
    local tEnemyList = self.m_tLevelData.monster
    if self.m_nCopyType == 3 then
        local _, tState = WndSingleCopy:getStarNumById(self.m_tLevelData.id)
        if tState[1] == 1 and  tState[2] == 0 then
            local levelId = self.m_tLevelData.id + 1
            local copyTable =  GDatatab_single_map["id_" .. levelId]
            tEnemyList = copyTable.monster
        elseif tState[1] == 1 and   tState[2] == 1 then
            local levelId = self.m_tLevelData.id + 2
            local copyTable =  GDatatab_single_map["id_" .. levelId]
            tEnemyList = copyTable.monster
        end
    end
    
    for i = 1, 3 do 
        GetElement(self.m_root, "conMonsterSeat" .. i .. "_WndSingleCopyInfo", WZUIContainer):removeAllChildrenWithCleanup(true)
        GetElement(self.m_root, "conMonsterSeat" .. i .. "_WndSingleCopyInfo", WZUIContainer):setVisible(false)
    end

    for i = 1, #tEnemyList do
        local conMonsterSeat = GetElement(self.m_root, "conMonsterSeat" .. i .. "_WndSingleCopyInfo", WZUIContainer)
        if conMonsterSeat then 
            conMonsterSeat:setVisible(true)
            local nMonsterId = tEnemyList[i][1]
            local eCellMonster = self:_createMonsterCell(nMonsterId, i)
            eCellMonster:setTag(i-1)
            conMonsterSeat:addChild(eCellMonster)
        end
    end
end

--@brief	根据怪物id创建怪物头像
--@param    nMonsterId, 怪物id
function WndSingleCopyInfo:_createMonsterCell(nMonsterId, nIndex)
    local cellMonster = CreateElement("CellMonster_WndSingleCopyInfo")
    WZLog("WndSingleCopyInfo:_createMonsterCell", nMonsterId)
    if nMonsterId then
        local tMonster = GDatatab_monster["id_"..nMonsterId]
        if tMonster then
            local imgMonsterType  = WZUIImage:luaTo(cellMonster:getChildElement("imgMosterType_WndSingleCopyInfo"))
            local btnMonster = GetElement(cellMonster, "btnMonster_CellMonster", WZUIButton)
            local monsterType = tMonster.type
            imgMonsterType:setFile("")
            btnMonster:setTag(nMonsterId)
            if monsterType == 2 then
                imgMonsterType:setFile("ui/common/common_icon_boss.png")
            elseif monsterType == 3 then
                imgMonsterType:setFile("ui/common/common_icon_jingying.png")
                imgMonsterType:setZOrder(999)
            end
            --怪物形象
            local conMonster = GetElement(cellMonster, "conMonster_CellMonster", WZUIContainer)
            local conMonsterSeat = GetElement(cellMonster, "conMonsterSeat_WndSingleCopyInfo", WZUIContainer)
            conMonster:removeAllChildrenWithCleanup(true)
            if nIndex ~= 1 then 
                conMonsterSeat:setRelativePosition(GlobalMethod:ccp(0.5, 0.28))
            end
            if tMonster.AniFileId ~= -1 then 
                local monster = BattleAnimation:createAnimation(tMonster.AniFileId , false, "battle/monster")
                local aniNode = monster:getAnimNode()
                aniNode:setAnchorPoint(GlobalMethod:ccp(0.5,0))
                aniNode:setRelativePosition(GlobalMethod:ccp(0.5,0))
                aniNode:setScale(0.8)
                if monsterType == 2 then
                    aniNode:setScale(0.8)
                    if self.m_tLevelData.section == 6 then
                        aniNode:setScale(0.45)
                    elseif self.m_tLevelData.section == 5 then
                        aniNode:setScale(0.45)
                    elseif self.m_tLevelData.section == 3 or self.m_tLevelData.section == 11 then
                        aniNode:setScale(0.7)
                    elseif self.m_tLevelData.section == 7 or self.m_tLevelData.section == 8  then
                        aniNode:setScale(0.45)
                    elseif self.m_tLevelData.section == 13 then
                        aniNode:setScale(0.4)
                    elseif self.m_tLevelData.section == 14 then
                        aniNode:setScale(0.275)
                    end
                end
                aniNode:setFlipX(true)
                aniNode:setTouchEnable(false)
                if self.m_tLevelData.section == 14 and tMonster.AniFileId == "boss_1012" then
                    monster:play("wait_1", true)
                else
                    monster:play("wait", true)
                end
                conMonster:addChild(aniNode)
            elseif tMonster.AniFileId == -1 and tMonster.suitConfig ~= -1 then 
                local tEquip = {}
                for i = 2, #tMonster.suitConfig[1] do
                    table.insert(tEquip, tMonster.suitConfig[1][i])
                end
                local suitMonster = self:createMonsterHead(tMonster.suitConfig[1][1], tEquip, "wait0")
                conMonster:addChild(suitMonster)
                conMonster:setTouchEnable(false)
            end
        end
    end
    cellMonster:setVisible(true)
    return cellMonster
end

--@brief  创建怪物形象
function WndSingleCopyInfo:createMonsterHead(sex,equip, sAniName)
    WZLog("WndSingleCopy:createMonsterHead ")
    local conPlayer = CreatePlayerFigure(sex, equip, sAniName or "avatar")
    local animNode = conPlayer:getAnimNode()
    animNode:setTouchEnable(false)
    animNode:setRelativePosition(GlobalMethod:ccp(0.5,0))
    animNode:setScale(0.65)
    if tostring(sex) == "0" then
        animNode:setRelativePosition(GlobalMethod:ccp(0.5,0))
    end
    return animNode
end

--@brief	初始化掉落列表
function WndSingleCopyInfo:_initDropList()
    WZLog("WndSingleCopyInfo:_initDropList")
    local nSex = CacheCenter:getPlayerInfo().sex
    local tDropData = self.m_tLevelData.reward_boy[1]
    if nSex == 1 then
        tDropData = self.m_tLevelData.reward_girl[1]
    end

    if self.m_nCopyType == 3 and self.m_nCurLevelID ~= nil then
        local curCopyTableInfo = GDatatab_single_map["id_" .. self.m_nCurLevelID ]
        tDropData = curCopyTableInfo.reward_boy[1]
        if nSex == 1 then
            tDropData = curCopyTableInfo.reward_girl[1]
        end
        local _, tState = WndSingleCopy:getStarNumById(self.m_tLevelData.id)
        if tState[1] == 0 or  tState[2] == 0 or tState[3] == 0 then
            tDropData = curCopyTableInfo.fixed_reward
            GetElement(self.m_root,"txtGetReward_WndSingleCopyInfo",WZUILabelTTF):setTextKey("FIXED_REWARD")
        end
    end
    
    local tbconDrop = GetElement(self.m_root, "tbconDrop_WndSingleCopyInfo", WZUITableContainer)
    tbconDrop:cleanTable()
    
    for i = 1, #tDropData do
        local eItem, tItem = self:_createCellGoodItem(i, tDropData[i], false, true)
        tbconDrop:setCellElement(eItem)
    end

end

--@brief    创建一个物品格子
--@param    nIndex, 序号
--@param    nItemId, 物品id
--@param    bHostReward : 岛主奖励
--isUse 透明框
function WndSingleCopyInfo:_createCellGoodItem(nIndex, nItemId, bHostReward, isUse)
    isUse = isUse or nil
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setTag(nIndex-1)
    --eItem:setScale(1)
    tItem:setFromTag(nIndex-1)
    tItem:setItemClickFun(self, self.onClickListItem)
    local tData = nil
    if bHostReward then 
        if type(nItemId) == "table" then
            local itemId = nItemId[2]
            local itemNum = nItemId[3]
            tData = {
                id = itemId,
                lastNum = itemNum,
                lastTime = 1,
                isUse = false,
                data = "",
                playerItemId = -1,
                basicInfo = GetItemLocalData(itemId)
            }
        else
            tData = {
                id = nItemId,
                lastNum = 0,
                lastTime = 1,
                isUse = false,
                data = "",
                playerItemId = -1,
                basicInfo = GetItemLocalData(nItemId)
            }
        end
    else
        if type(nItemId) == "table" then
            local itemId = nItemId[1]
            local itemNum = nItemId[2]
            tData = {
                id = itemId,
                lastNum = itemNum,
                lastTime = 1,
                isUse = false,
                data = "",
                playerItemId = -1,
                basicInfo = GetItemLocalData(itemId)
            }
        else
            tData = {
                id = nItemId,
                lastNum = 0,
                lastTime = 1,
                isUse = false,
                data = "",
                playerItemId = -1,
                basicInfo = GetItemLocalData(nItemId)
            }
        end
    end
    if isUse then
        tItem:_setBgImgVisible(false)
        tItem:setConItemVisible(false)
    end
    tItem:setCellGoodItem(tData,4)
    return eItem, tItem
end

--@brief    更新星级信息
function WndSingleCopyInfo:_initStarInfo()
   
    local conStar = GetElement(self.m_root, "conStar_WndSingleCopyInfo")
    conStar:setVisible(true)

    local nStarNum = WndSingleCopy:getStarNumById(self.m_tLevelData.id)
    for i = 1, 3 do
        local img = GetElement(self.m_root, "imgStar"..i.."_WndSingleCopyInfo", WZUIImage)
        local index = 3 + i
        local img2 = GetElement(self.m_root, "imgStar".. index .."_WndSingleCopyInfo", WZUIImage)
        if i <= nStarNum then
            img:setVisible(false)
            img2:setVisible(true)
        else
            img:setVisible(true)
            img2:setVisible(false)
        end
    end
   
    local _, tState = WndSingleCopy:getStarNumById(self.m_tLevelData.id)

    local level1 = GDatatab_single_map["id_" .. self.m_tLevelData.id]
    local level2 = GDatatab_single_map["id_" .. self.m_tLevelData.id+1]
    local level3 = GDatatab_single_map["id_" .. self.m_tLevelData.id+2]

    local tGoalList = {}
    if self.m_nCopyType ~= 3 then
        tGoalList[1] = LocalStrings.COPY_GOAL1
        tGoalList[2] = string.format(LocalStrings.COPY_GOAL2, self.m_tLevelData.pass_hp)
        tGoalList[3] = string.format(LocalStrings.COPY_GOAL3, self.m_tLevelData.pass_round)
    else
        if level1.pass_hp ~= -1 then
            tGoalList[1] = string.format(LocalStrings.COPY_GOAL2, level1.pass_hp)
        elseif level1.pass_round ~= -1 then
            tGoalList[1] = string.format(LocalStrings.COPY_GOAL3, level1.pass_round)
        end

        if level2.pass_hp ~= -1 then
            tGoalList[2] = string.format(LocalStrings.COPY_GOAL2, level2.pass_hp)
        elseif level2.pass_round ~= -1 then
            tGoalList[2] = string.format(LocalStrings.COPY_GOAL3, level2.pass_round)
        end

        if level3.pass_hp ~= -1 then
            tGoalList[3] = string.format(LocalStrings.COPY_GOAL2, level3.pass_hp)
        elseif level3.pass_round ~= -1 then
            tGoalList[3] = string.format(LocalStrings.COPY_GOAL3, level3.pass_round)
        end
    end

    for i = 1, 3 do
        local nState = tState[i] or 0
        local txtGoal = GetElement(self.m_root, "txtGoal"..i.."_WndSingleCopyInfo", WZUILabelTTF)
        local imgStar = GetElement(self.m_root, "imgStar1"..i.."_WndSingleCopyInfo", WZUIImage)
        txtGoal:setText(tGoalList[i])
        if self.m_nCopyType == 3 then
            txtGoal:setFontSize(18)
        end
        local starS = string.format(LocalStrings.PASS_LEVEL_STAT,i)
        if nState == 0 then
            imgStar:setFile("ui/common/common_icon_xingxing2.png")
            imgStar:setGrayRender(true)
            txtGoal:setColor(GlobalMethod:ccc3(255,236,193))
            if self.m_nCurLevelID == nil and self.m_nCopyType == 3 then
                if i == 1 then
                    self.m_nCurLevelID = level1.id
                elseif i == 2 then
                    self.m_nCurLevelID = level2.id
                elseif i == 3 then
                    self.m_nCurLevelID = level3.id
                end
            end
            if self.m_nCopyType == 3 then
                if i > 1 and tState[i-1] == 1 or i == 1 then
                    local showText = starS .. "（" .. LocalStrings.TASK_DOING .. "）"
                    if ProjConfig.LANGUAGE ~= "cn" then
                        showText = starS .. "(" .. LocalStrings.TASK_DOING .. ")"
                    end
                    local temp = txtGoal:getText()
                    local temp2 = showText .. "" .. temp
                    txtGoal:setText(temp2)
                    txtGoal:setColor(GlobalMethod:ccc3(255,227,116))
                else
                    local showText = starS .. "（" .. LocalStrings.LOCKED .. "）"
                    if ProjConfig.LANGUAGE ~= "cn" then
                        showText = starS .. "(" .. LocalStrings.LOCKED .. ")"
                    end
                    txtGoal:setText(showText)
                end
            end
        else
            imgStar:setFile("ui/common/common_icon_xingxing2.png")
            imgStar:setGrayRender(false)
            txtGoal:setColor(GlobalMethod:ccc3(233,166,62))
            if self.m_nCopyType == 3 then
                local showText = starS .. "（" .. LocalStrings.PASS_LEVEL .. "）"
                if ProjConfig.LANGUAGE ~= "cn" then
                    showText = starS .. "(" .. LocalStrings.PASS_LEVEL .. ")"
                end
                local temp = txtGoal:getText()
                local temp2 = nil
                if i == 3 then
                   temp2 = showText .. "" .. temp
                   txtGoal:setText(temp2)
                else
                   txtGoal:setText(showText) 
                end
               
                txtGoal:setColor(GlobalMethod:ccc3(99,255,95))
            end
        end
    end
    if self.m_nCurLevelID  == nil and self.m_nCopyType == 3 then  --恶魔副本本关卡的三个关卡都打过了，默认挑战第三关
        self.m_nCurLevelID = level3.id
    end
end

--@brief	更新扫荡信息
function WndSingleCopyInfo:_updateSweepInfo()
    local nVIPLevel = CacheCenter:getPlayerInfo().vipLevel
    local nPlayerLevel = CacheCenter:getPlayerInfo().level
    local nStarNum = WndSingleCopy:getStarNumById(self.m_tLevelData.id)
    
    local nSweepCoupon = self:_getSweepCouponCount() --扫荡券个数
    
    local txtSweepCount = GetElement(self.m_root,"txtSweepCount_WndSingleCopyInfo",WZUILabelTTF)
    txtSweepCount:setText(tostring(nSweepCoupon))

    local btnSweep1 = GetElement(self.m_root,"btnSweep1_WndSingleCopyInfo",WZUIButton)
 
    local txtSweep1 = GetElement(self.m_root, "txtSweep1_WndSingleCopyInfo", WZUILabelTTF)
    txtSweep1:setText(string.format(LocalStrings.WIPE_OUT_MULTI, 1))

    local nChallengeCount = self.m_tLevelData.pass_times - math.max(self.m_nChallengeCount, 0) --可挑战次数
    local txtSweep2= GetElement(self.m_root, "txtSweep2_WndSingleCopyInfo", WZUILabelTTF)

    self.m_nSweepCount = math.min(nSweepCoupon, nChallengeCount, 10)
    if self.m_nSweepCount <= 1 then
        txtSweep2:setText(LocalStrings.MULTI_SWEEP)
    else
        txtSweep2:setText(string.format(LocalStrings.WIPE_OUT_MULTI, self.m_nSweepCount))
    end

    local conSweep = GetElement(self.m_root,"conSweep_WndSingleCopyInfo",WZUIContainer)

    if nPlayerLevel < 5 or nStarNum < 3 then
       conSweep:setVisible(false)
        return
    end
    conSweep:setVisible(true)
end

function WndSingleCopyInfo:_addTipsDescMonster(pt,monserId)
    if self.m_root:getChildByTag(88) then self.m_root:removeChildByTag(88,true) end

    local conM = CreateElement("TipsDescMonster")
    self.m_root:addChild(conM,5,88)
    conM:setPosition(pt)

    local tMonster = GDatatab_monster["id_"..monserId]

    local conH = GetElement(conM, "conMHead_TipsDescMonster", WZUIContainer)
    local imgHead = GetElement(conM, "imgMHead_TipsDescMonster", WZUIImage)
    imgHead:setFile("ui/main/bossMap/guaiicon/monster1.png")

    local txtName = GetElement(conM, "txtMName_TipsDescMonster", WZUILabelTTF)
    txtName:setText(tMonster.name)

    local txtDesc = GetElement(conM, "txtMDesc_TipsDescMonster", WZUILabelTTF)
    txtDesc:setText(tMonster.script)

end

--@brief    展示岛主头像
function WndSingleCopyInfo:_showIslandHostHead()
    -- body
    local tHostData
    if self.m_tIslandHostData then
        for i=1,#self.m_tIslandHostData.player do
            if self.m_tIslandHostData.player[i].playerId == self.m_tIslandHostData.landlordId then
                tHostData = self.m_tIslandHostData.player[i]
            end
        end
    end
    local conIslangHostHead = GetElement(self.m_root, "conIslangHostHead_WndSingleCopyInfo", WZUIContainer)
    local conTopInfo = GetElement(self.m_root, "conTopInfo_WndSingleCopyInfo", WZUIContainer)
    local ftxtIslandHostName = GetElement(self.m_root, "ftxtIslandHostName_WndSingleCopyInfo", WZUIFreeTextBox)
    if tHostData and tHostData.playerId > 0 then
        local cellElement =  CellHead:show(conIslangHostHead, tHostData.headId, tHostData.faceId, tHostData.sex, nil, nil, tHostData.vipLevel, tHostData.headColor)

        if conTopInfo:isVisible() then 
            conIslangHostHead:setVisible(true)
        else
            conIslangHostHead:setVisible(false)
        end
        conTopInfo:setRelativePosition(GlobalMethod:ccp(0.36,0.9))
    else
        conTopInfo:setRelativePosition(GlobalMethod:ccp(0.24,0.9))
        conIslangHostHead:setVisible(false)
    end
end

--@brief    展示挑战的岛主数据
function WndSingleCopyInfo:_showIslandHostInfo()
    --岛主奖励/助战奖励
    self:showIslandReward1()
    --可掠物质
    self:showIslandReward2()
    --岛主和助战玩家/怪物
    self:showIslandPlayer()

end

--@brief    显示岛主和助战玩家/怪物
function WndSingleCopyInfo:showIslandPlayer()
    local tbIslandPlayers = GetElement(self.m_root, "tbIslandPlayers_WndSingleCopyInfo", WZUITableContainer)
    tbIslandPlayers:cleanTable()
    local player = self.m_tIslandHostData.player
    if #player > 0 then
        for i=1,#player do
            local CellIslandPlayer = CreateElement("CellIslandPlayer_WndSingleCopyInfo")
            CellIslandPlayer:setTag(i-1)
            CellIslandPlayer:setVisible(true)
            local conHead = GetElement(CellIslandPlayer,"conHead_CellIslandPlayer",WZUIContainer)
            CellHead:show(conHead,player[i].headId,player[i].faceId,player[i].sex,nil,nil,player[i].vipLevel, player[i].headColor)
            local btnHead = GetElement(CellIslandPlayer,"btnHead_CellIslandPlayer",WZUIButton)
            btnHead:setVisible(true)
            btnHead:setTag(player[i].playerId)
            local imgStatus = GetElement(CellIslandPlayer,"imgStatus_CellIslandPlayer",WZUIImage)
            if player[i].playerId == self.m_tIslandHostData.landlordId then
                imgStatus:setFile("ui/common/text_fb_daozhu.png")
            else
                imgStatus:setFile("ui/common/text_fb_zz.png")
            end
            local txtLevel = GetElement(CellIslandPlayer,"txtLevel_CellIslandPlayer",WZUILabelTTF)
            txtLevel:setText(LocalStrings.LV..player[i].level)
            local txtName = GetElement(CellIslandPlayer,"txtName_CellIslandPlayer",WZUILabelTTF)
            txtName:setText(player[i].name)
            local txtFightWord = GetElement(CellIslandPlayer,"txtFightWord_CellIslandPlayer",WZUILabelTTF)
            txtFightWord:setText(LocalStrings.BATTLE..":")
            local txtFightValue = GetElement(CellIslandPlayer,"txtFightValue_CellIslandPlayer",WZUILabelTTF)
            txtFightValue:setText(player[i].fight)
            local btnQuit = GetElement(CellIslandPlayer,"btnQuit_CellIslandPlayer",WZUIButton)
            btnQuit:setVisible(player[i].playerId == CacheCenter:getPlayerInfo().id)
            tbIslandPlayers:setCellElement(CellIslandPlayer)

            if ProjConfig.LANGUAGE == "vn" then
                txtFightValue:setRelativePosition(GlobalMethod:ccp(0.55,0.31))
            end
        end
    else
        local singleInfo = GDatatab_single_map["id_"..self.m_tIslandHostData.mapId]
        if singleInfo.map_type == 2 or singleInfo.map_type == 3 then
            for k,v in pairs(GDatatab_single_map) do
                if v.map_type == 6 and v.section == singleInfo.section then
                    singleInfo = v
                end
            end
        end
        local tempMonster = singleInfo.monster
        for i=1,#tempMonster do
            local tMonsterInfo = GDatatab_monster["id_"..tempMonster[i][1]]
            local CellIslandPlayer = CreateElement("CellIslandPlayer_WndSingleCopyInfo")
            CellIslandPlayer:setTag(i-1)
            CellIslandPlayer:setVisible(true)
            local imgMonster = GetElement(CellIslandPlayer,"imgMonster_CellIslandPlayer",WZUIImage)
            imgMonster:setFile(MONSTER_IMAGE_PATH..tMonsterInfo.moster_picture..".png")
            local txtName = GetElement(CellIslandPlayer,"txtName_CellIslandPlayer",WZUILabelTTF)
            txtName:setText(tMonsterInfo.name)
            txtName:setFontSize(16)
            txtName:setRelativePosition(GlobalMethod:ccp(0.265,0.69))
            local txtFightValue = GetElement(CellIslandPlayer,"txtFightValue_CellIslandPlayer",WZUILabelTTF)
            txtFightValue:setText(tMonsterInfo.script)
            txtFightValue:setFontSize(16)
            txtFightValue:setRelativePosition(GlobalMethod:ccp(0.265,0.31))
            tbIslandPlayers:setCellElement(CellIslandPlayer)
        end

    end
end

--@brief    显示岛主奖励/助战奖励
function WndSingleCopyInfo:showIslandReward1()
    local conIslandRewards1 = GetElement(self.m_root, "conIslandRewards1_WndSingleCopyInfo", WZUIContainer)
    removeShowPanelNullTip(conIslandRewards1)
    local tbIslandRewards1 = GetElement(self.m_root, "tbIslandRewards1_WndSingleCopyInfo", WZUITableContainer)
    tbIslandRewards1:cleanTable()

    local level = CacheCenter:getPlayerInfo().level 
    local txtIslandRewards1 = GetElement(self.m_root, "txtIslandRewards1_WndSingleCopyInfo", WZUILabelTTF)
    if self.m_nSwitchReward == 1 then --岛主奖励
        txtIslandRewards1:setText(LocalStrings.SINGLECOPY_TEXT21)
        local tDropData = self.m_tLevelData.dwar_boss
        if tDropData == 0 then return end
        if #tDropData == 0 then
            ShowPanelNullTip(conIslandRewards1,LocalStrings.NONE)
            return
        end
        local nIndex = 1 
        for i = 1, #tDropData do
--            if tDropData[i][2] ~= 161021 or level >= 100 then  
                local eItem, tItem = self:_createCellGoodItem(nIndex, tDropData[i], true)
                tbIslandRewards1:setCellElement(eItem)
                eItem:setScale(0.8)

                tItem:setItemCount(tDropData[i][3] .. "/" .. tDropData[i][1] .. "h")

                nIndex = nIndex + 1 
--            end
        end
    elseif self.m_nSwitchReward == 2 then --助战奖励
        txtIslandRewards1:setText(LocalStrings.ISLAND_OWNER_TEXT4)
        local tDropData = self.m_tLevelData.dwar_assist
        if tDropData == 0 then return end 
        if #tDropData == 0 then
            ShowPanelNullTip(conIslandRewards1,LocalStrings.NONE)
            return
        end
        local nIndex = 1 
        for i = 1, #tDropData do
--            if tDropData[i][2] ~= 161021 or level >= 100 then  
                local eItem, tItem = self:_createCellGoodItem(nIndex, tDropData[i], true)
                tbIslandRewards1:setCellElement(eItem)
                eItem:setScale(0.8)

                tItem:setItemCount(tDropData[i][3] .. "/" .. tDropData[i][1] .. "h")

                nIndex = nIndex + 1 
--            end
        end
    end
end

--@brief    显示可掠物质
function WndSingleCopyInfo:showIslandReward2()
    local conIslandRewards2 = GetElement(self.m_root, "conIslandRewards2_WndSingleCopyInfo", WZUIContainer)
    removeShowPanelNullTip(conIslandRewards2)
    local tbIslandRewards2 = GetElement(self.m_root, "tbIslandRewards2_WndSingleCopyInfo", WZUITableContainer)
    tbIslandRewards2:cleanTable()

    local tDropData = self:getPredatoryMaterial()
    if #tDropData == 0 then
        ShowPanelNullTip(conIslandRewards2,LocalStrings.ISLAND_OWNER_TEXT21)
        return
    end
    local level = CacheCenter:getPlayerInfo().level 
    local nIndex = 1 
    for i = 1, #tDropData do
--        if tDropData[i][1] ~= 161021 or level >= 100 then 
            local eItem, tItem = self:_createCellGoodItem(nIndex, tDropData[i], false)
            tbIslandRewards2:setCellElement(eItem)
            eItem:setScale(0.8)

            tItem:setItemCount(tDropData[i][2])

            nIndex = nIndex + 1 
--        end
    end
end

--@brief    获取可掠物质数据
--@note    可掠物质等于岛主奖励超过8小时的部分*百分比
function WndSingleCopyInfo:getPredatoryMaterial()
    local landlordConfig = json.decode(CacheCenter:getGameParam().landlordConfig)
    local nOccupiedHour = math.floor(self.m_tIslandHostData.time/3600) --岛主占领时间

    if nOccupiedHour <= landlordConfig.protect then
        return {}
    end
    local tDropData = self.m_tLevelData.dwar_boss
    if tDropData == 0 then
        return {}
    end

    local tPlunderItem = {} --可掠物质

    for i=1,#tDropData do
        local tempItem = {}
        local tempCount1 = math.floor(nOccupiedHour / tDropData[i][1]) --总时长可得奖励次数
        local tempCount2 = math.floor(landlordConfig.protect / tDropData[i][1]) --8小时可得奖励次数
        tempItem[1] = tDropData[i][2]
        tempItem[2] = tDropData[i][3] * (tempCount1 - tempCount2)
        if tempItem[2] > 0 then
            table.insert(tPlunderItem,tempItem)
        end
    end

    return tPlunderItem
end

--@brief    点击切换岛主奖励/助战奖励
function WndSingleCopyInfo:onClickSwitchReward(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nSwitchReward == 1 then
        self.m_nSwitchReward = 2
    elseif self.m_nSwitchReward == 2 then
        self.m_nSwitchReward = 1
    end
    self:showIslandReward1()
end

--@brief    点击玩家头像
function WndSingleCopyInfo:onClickHead(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    WndCheckOther:show(tag)
end

--@brief    点击退出位置
function WndSingleCopyInfo:onClickQuit(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    MsgBoxManager:showConfirmBox(LocalStrings.ISLAND_OWNER_TEXT24, self, self.sureQuitLandlord)
end

--@brief    点击退出位置
function WndSingleCopyInfo:sureQuitLandlord(element)
    ProtocolProcessorSingleMap:send_MAP_QuitLandlord(self.m_tIslandHostData.mapId)
end

--@brief    点击岛主规则
function WndSingleCopyInfo:onClickIslandRule(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.ISLAND_OWNER_TEXT23)
end

--@brief    倒计时岛主保护时间
function WndSingleCopyInfo:_scheduleOwnerTime1(element)
    if self.m_tIslandHostData == nil then return end 
    if self.m_tIslandHostData.protectTime == nil then return end 

    local txtOwnerTime1 = GetElement(self.m_root, "txtOwnerTime1_WndSingleCopyInfo", WZUILabelTTF)
    if self.m_tIslandHostData.protectTime > 0 then
        self.m_tIslandHostData.protectTime = self.m_tIslandHostData.protectTime - 1
        local sTimeContent = returnToTimeFormat(self.m_tIslandHostData.protectTime)
        txtOwnerTime1:setText(sTimeContent)
    else
        element:disableSchedule()
        txtOwnerTime1:setText(LocalStrings.NONE)
    end
end

--@brief    倒计时岛主占领时间
function WndSingleCopyInfo:_scheduleOwnerTime2(element)
    if self.m_tIslandHostData == nil then return end 
    if self.m_tIslandHostData.time == nil then return end 

    local landlordConfig = json.decode(CacheCenter:getGameParam().landlordConfig)
    local nMaxtime = landlordConfig.remove * 3600

    local txtOwnerTime2 = GetElement(self.m_root, "txtOwnerTime2_WndSingleCopyInfo", WZUILabelTTF)
    if self.m_tIslandHostData.landlordId > 0 then 
        self.m_tIslandHostData.time = self.m_tIslandHostData.time + 1
        if self.m_tIslandHostData.time < nMaxtime then
            local sTimeContent = returnToTimeFormat(self.m_tIslandHostData.time)
            txtOwnerTime2:setText(sTimeContent)
        else
            element:disableSchedule()
            local sTimeContent = returnToTimeFormat(nMaxtime)
            txtOwnerTime2:setText(sTimeContent)
        end
    else
        txtOwnerTime2:setText("00:00:00")
        txtOwnerTime2:disableSchedule()
    end
end

--@brief    倒计时岛主复仇时间
function WndSingleCopyInfo:_scheduleOwnerTime3(element)
    if self.m_tIslandHostData == nil then return end 
    if self.m_tIslandHostData.revenge == nil then return end

    local txtBtnChallenge = GetElement(self.m_root,"txtBtnChallenge_WndSingleCopyInfo",WZUILabelTTF)
    self.m_tIslandHostData.revenge = self.m_tIslandHostData.revenge - 1
    if self.m_tIslandHostData.revenge <= 0 then
        self.m_tIslandHostData.revenge = 0
        txtBtnChallenge:disableSchedule()
        self:updateReaderBtn()
    end
end

function WndSingleCopyInfo:showTipForButton()
    if self.m_root == nil then
        return
    end

    if self.m_tButtonTipsAnim1 and self.m_tButtonTipsDialog1 then
        self.m_tButtonTipsAnim1:removeFromParentAndCleanup(true)
        self.m_tButtonTipsDialog1:removeFromParentAndCleanup(true)
        self.m_tButtonTipsAnim1, self.m_tButtonTipsDialog1 = nil, nil
    end

    if WindowManager:isHaveTeachTouchLayer() ~= true then
        local playerLevel = CacheCenter:getPlayerInfo().level
        if playerLevel >= 5 and playerLevel <= 8 then
            local btn = GetElement(self.m_root,"btnChallenge_WndSingleCopyInfo",WZUIButton)
            local txt = 3
            self.m_tButtonTipsAnim1, self.m_tButtonTipsDialog1 = WindowManager:addTipForButton(btn, 0.30, GlobalMethod:ccp(75,0), txt, 4, GlobalMethod:ccp(0,0))
        end
    end
end

--@brief    挑战事件
function WndSingleCopyInfo:_postChallengeEvent()
    -- body
    local tempCopyLevelInfo = GDatatab_single_map["id_" .. self.m_tLevelData.id]
    if tempCopyLevelInfo.map_type == 1 and tempCopyLevelInfo.section >= 1 and tempCopyLevelInfo.section <= 3 then 
        local eventKey = PostPlayerEvent["event_SingleCopyStart" .. tempCopyLevelInfo.section .. "_" .. tempCopyLevelInfo.map_num]
        if eventKey then 
            PostPlayerEvent:postEvent(eventKey)    
        end
    end
end

--@brief    添加时装套装入口
function WndSingleCopyInfo:_addDressSuit(element)
    -- body
    if CheckButtonOpen(144, false) then
        local conForDressSuit = GetElement(element, "conForDressSuit_WndSingleCopyInfo", WZUIContainer)
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

--@brief    点击挑战按钮回调
function WndSingleCopyInfo:onClickChallengeIsland(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local nStarNum = WndSingleCopy:getStarNumById(self.m_tLevelData.id)
    if self.m_tLevelData.map_type == 3 and nStarNum < 3 then --地狱难度且未3星
        MsgBoxManager:showTipBox(LocalStrings.ISLAND_OWNER_TEXT17) --地狱难度达到3星后才能挑战岛主
        return
    else
        if nStarNum == 0 then
            MsgBoxManager:showTipBox(LocalStrings.ISLAND_OWNER_TEXT13) --通关后才能挑战岛主
            return
        end
    end

    if self.m_tIslandHostData.landlordId == CacheCenter:getPlayerInfo().id then 
        MsgBoxManager:showTipBox(LocalStrings.SINGLECOPY_TEXT16)
        return
    end

    for i=1,#self.m_tIslandHostData.player do
        for j=1,#self.m_tData.playerId do
            if self.m_tIslandHostData.player[i].playerId == self.m_tData.playerId[j] then
                MsgBoxManager:showTipBox(LocalStrings.ISLAND_OWNER_TEXT26)
                return
            end
        end
    end

    if self.m_tIslandHostData.revenge == 0 and self.m_tIslandHostData.protectTime > 0 then 
        MsgBoxManager:showTipBox(LocalStrings.SINGLECOPY_TEXT17)
        return
    end

    local landlordConfig = json.decode(CacheCenter:getGameParam().landlordConfig)
    local nState = WndSingleCopy:judgeSectionHostState(self.m_tLevelData.id)
    if self:getIsRoomOwner() and (#self.m_tIslandHostData.landlordMapId >= landlordConfig.maxLandlordNum) then 
        MsgBoxManager:showConfirmBox(string.format(LocalStrings.ISLAND_OWNER_TEXT14,landlordConfig.maxLandlordNum), self, self.continueToChallengeIsland)
        return
    end

    self:continueToChallengeIsland()
end

--@brief    确定挑战该岛主
function WndSingleCopyInfo:continueToChallengeIsland()
    -- body
    WZLog("WndSingleCopyInfo:continueToChallengeIsland",Serialize(self.m_tLevelData))
    
    local copyId = self.m_tLevelData.id
    if self.m_tLevelData.map_type == 3 then
        copyId = self.m_tLevelData.id + 2
    end
    -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
    if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
        ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
    end
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(copyId, COPYTYPE_SINGLEHOST)
end

--@brief    开始配对计时器
function WndSingleCopyInfo:startPairTimer()
    WZLog("WndSingleCopyInfo:startPairTimer")
    self.m_nPairRemainTime = 10
    local downTime = GetElement(self.m_root,"txtMakePairTime_WndSingleCopyInfo",WZUILabelAtlasFont)
    downTime:setText(self.m_nPairRemainTime)
    downTime:enableSchedule("_schedulePairTimer",1)
    self.m_root:enableSchedule("_scheduleCheckRoomPlayer", 0)
end

--@brief    配对计算器的回调函数
function WndSingleCopyInfo:_schedulePairTimer()
    if self.m_nPairRemainTime > 0 then
        self.m_nPairRemainTime = self.m_nPairRemainTime - 1
        WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"txtMakePairTime_WndSingleCopyInfo")):setText(self.m_nPairRemainTime)
    else
        WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"txtMakePairTime_WndSingleCopyInfo")):setVisible(false)
    end
end

--@brief    检查房间玩家计算器的回调函数
function WndSingleCopyInfo:_scheduleCheckRoomPlayer()
    if (not self:_allPlayersReady()) then
        self.m_root:disableSchedule()
        self:endPairTimer()
    end
end

--brief    是否所有玩家已准备
--@return  #1: true:是, false：否
function WndSingleCopyInfo:_allPlayersReady()
    for i=1, self.m_tData.playerNum do
        if self.m_tData.playerId[i] > 0 and not self.m_tData.playerReady[i] then
            return false
        end
    end
    return true
end

--@brief    关闭配对计时器
function WndSingleCopyInfo:endPairTimer()
    WZLog("WndSingleCopyInfo:endPairTimer")
    if self.m_root == nil then return end
    local downTime = GetElement(self.m_root,"txtMakePairTime_WndSingleCopyInfo",WZUILabelAtlasFont)
    downTime:setVisible(false)
    downTime:disableSchedule()
end

--显示当前房间的玩家聊天信息
function WndSingleCopyInfo:showChat(txtMsg, playerId, bubbleId)
    WZLog("WndSingleCopyInfo:showChat ",txtMsg,playerId)
    local seatIndex = self:findPlayerSeatById(playerId)
    if seatIndex > 0 then
        local conSeat = GetElement(self.m_root,"conSeat" .. seatIndex .. "_WndSingleCopyInfo",WZUIContainer)
        local conPlayer = GetElement(conSeat,"conPlayer_WndSingleCopyInfo")
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
function WndSingleCopyInfo:exitRoom()
    if self.m_tData == nil or self.m_root == nil then
        WZLog("WndSingleCopyInfo:exitRoom m_tData is nil")
        return
    end

    self.m_bIslandRoom = nil
    if self.m_toBattleLoadingScene ~= true then
        if WBattleGlobal:getCurrent().m_tMakePairOk and WBattleGlobal:getCurrent().m_tMakePairOk.battleId then
            WBattleGlobal:getCurrent().m_tMakePairOk.battleId = 0
        end
        ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_QuitRoom(self.m_tData.roomId, self:_getPlayerSeat())
    end

end

--@brief  创建房间
function WndSingleCopyInfo:createRoom()
    local nStarNum = WndSingleCopy:getStarNumById(self.m_tLevelData.id)
    if self.m_tLevelData.map_type == 3 and nStarNum < 3 then --地狱难度且未3星
        MsgBoxManager:showTipBox(LocalStrings.ISLAND_OWNER_TEXT17) --地狱难度达到3星后才能挑战岛主
        return
    else
        if nStarNum == 0 then
            MsgBoxManager:showTipBox(LocalStrings.ISLAND_OWNER_TEXT13) --通关后才能挑战岛主
            return
        end
    end

    self.m_bIslandRoom = true

    if self.m_nCopyType == 3 then
        ProtocolProcessorGlobal:send_CHAT_ChangeChannel(self.m_nCurLevelID ) --服务端要求发副本id
        ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom(self.m_nCurLevelID, "", GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZTZ)
    else
        ProtocolProcessorGlobal:send_CHAT_ChangeChannel(self.m_tLevelData.id ) --服务端要求发副本id
        ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom(self.m_tLevelData.id, "", GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZTZ)
    end
end

--@brief  退出房间
function WndSingleCopyInfo:exitMulRoom(isInitiative)
    if self.m_root == nil then return end 

    ProtocolProcessorSceneBossRoom:unregAll()
    if isInitiative == true then
        WindowManager:removeWindow(self.m_root, self, true)
    end

end

function WndSingleCopyInfo:_getPlayerNum()
    local num = 0
    for i=1 , #self.m_tData.playerId do
        if self.m_tData.playerId[i] > 0 then num = num + 1 end
    end
    return num
end


function WndSingleCopyInfo:_updateCheckPlayerState(element,dt)
    if self.m_tData == nil then
        self.m_root:disableSchedule()
        return
    end
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


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Began----------------------------------------
function WndSingleCopyInfo:_adaptLanguage_en()
    GetElement(self.m_root,"txtTopTitle_WndSingleCopyInfo",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtSweep1_WndSingleCopyInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtSweep2_WndSingleCopyInfo",WZUILabelTTF):setFontSize(18)

    local txtGoal1 = GetElement(self.m_root,"txtGoal1_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal1:setFontSize(18)
    txtGoal1:setDimensions(GlobalMethod:CCSize(200,0))

    local txtGoal2 = GetElement(self.m_root,"txtGoal2_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal2:setFontSize(18)
    txtGoal2:setDimensions(GlobalMethod:CCSize(200,0))

    local txtGoal3 = GetElement(self.m_root,"txtGoal3_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal3:setFontSize(18)
    txtGoal3:setDimensions(GlobalMethod:CCSize(200,0))

    local txtVigour = GetElement(self.m_root,"txtVigour_WndSingleCopyInfo",WZUILabelTTF)
    txtVigour:setRelativePosition(GlobalMethod:ccp(0.274217,0.922778))
    GetElement(self.m_root,"txtCanFireCount_WndSingleCopyInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.862143,0.927906))

    local txtHostInfo1 = GetElement(self.m_root,"txtHostInfo1_WndSingleCopyInfo",WZUILabelTTF)
    txtHostInfo1:setScale(0.6)
    txtHostInfo1:setDimensions(GlobalMethod:CCSize(130))
    local txtHostInfo2 = GetElement(self.m_root,"txtHostInfo2_WndSingleCopyInfo",WZUILabelTTF)
    txtHostInfo2:setScale(0.6)
    txtHostInfo2:setDimensions(GlobalMethod:CCSize(130))
    GetElement(self.m_root,"txtVideoInfo_WndSingleCopyInfo",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"txtVideoInfoSel_WndSingleCopyInfo",WZUILabelTTF):setScale(0.9)

    GetElement(self.m_root,"txtIslandHostInfo1_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtIslandHostInfo2_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"txtNextCandidate_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)  
end

function WndSingleCopyInfo:_adaptLanguage_pt(  )
    local txtTop = GetElement(self.m_root,"txtTopTitle_WndSingleCopyInfo",WZUILabelTTF)
    txtTop:setFontSize(22)
    txtTop:setRelativePosition(GlobalMethod:ccp(0.45,0.935691))
    GetElement(self.m_root,"txtSweep1_WndSingleCopyInfo",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtSweep2_WndSingleCopyInfo",WZUILabelTTF):setFontSize(12)
    local txtGoal1 = GetElement(self.m_root,"txtGoal1_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal1:setFontSize(18)
    txtGoal1:setDimensions(GlobalMethod:CCSize(230,0))
    local txtGoal2 = GetElement(self.m_root,"txtGoal2_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal2:setFontSize(18)
    txtGoal2:setDimensions(GlobalMethod:CCSize(230,0))
    local txtGoal3 = GetElement(self.m_root,"txtGoal3_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal3:setFontSize(18)
    txtGoal3:setDimensions(GlobalMethod:CCSize(230,0))
    local txtDesc = GetElement(self.m_root,"txtDesc_WndSingleCopyInfo",WZUILabelTTF)
    txtDesc:setScale(0.83)
    txtDesc:setDimensions(GlobalMethod:CCSize(330,0))
    
    local txtGetReward = GetElement(self.m_root,"txtGetReward_WndSingleCopyInfo",WZUILabelTTF)
    txtGetReward:setDimensions(GlobalMethod:CCSize(120))
    txtGetReward:setScale(0.73)
    
    local txtHostInfo1 = GetElement(self.m_root,"txtHostInfo1_WndSingleCopyInfo",WZUILabelTTF)
    txtHostInfo1:setScale(0.6)
    txtHostInfo1:setDimensions(GlobalMethod:CCSize(130))
    local txtHostInfo2 = GetElement(self.m_root,"txtHostInfo2_WndSingleCopyInfo",WZUILabelTTF)
    txtHostInfo2:setScale(0.6)
    txtHostInfo2:setDimensions(GlobalMethod:CCSize(130))

    GetElement(self.m_root,"txtIslandHostInfo1_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtIslandHostInfo2_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)

    local txtNextCandidate = GetElement(self.m_root,"txtNextCandidate_WndSingleCopyInfo",WZUILabelTTF)
    txtNextCandidate:setScale(0.6)
    txtNextCandidate:setDimensions(GlobalMethod:CCSize(160))

    local txtCantAtt = GetElement(self.m_root, "txtCantAtt_WndSingleCopyInfo", WZUILabelTTF)
    txtCantAtt:setScale(0.8)
    txtCantAtt:setDimensions(GlobalMethod:CCSize(320))
end

function WndSingleCopyInfo:_adaptLanguage_th()
    WZLog("WndSingleCopyInfo:_adaptLanguage_th")
    local conSingleSweep = GetElement(self.m_root,"conSingleSweep_WndSingleCopyInfo",WZUIContainer)
    conSingleSweep:setAbsContentSize(GlobalMethod:CCSize(150,62))
    conSingleSweep:updateRelativeSize()
    conSingleSweep:setRelativePosition(GlobalMethod:ccp(0.300648,0.522298))


    local txtSweep1 = GetElement(conSingleSweep,"txtSweep1_WndSingleCopyInfo",WZUILabelTTF)
    txtSweep1:setFontSize(18)

    local conMultiSweep = GetElement(self.m_root,"conMultiSweep_WndSingleCopyInfo",WZUIContainer)
    conMultiSweep:setAbsContentSize(GlobalMethod:CCSize(150,62))
    conMultiSweep:updateRelativeSize()
    conMultiSweep:setRelativePosition(GlobalMethod:ccp(0.528867,0.522298))

    local txtSweep2 = GetElement(conMultiSweep,"txtSweep2_WndSingleCopyInfo",WZUILabelTTF)
    txtSweep2:setFontSize(18)
    for i=1,3 do
        GetElement(self.m_root,"txtGoal"..i.."_WndSingleCopyInfo",WZUILabelTTF):setFontSize(18)
    end

    GetElement(self.m_root,"txtVideoInfo_WndSingleCopyInfo",WZUILabelTTF):setScale(0.85)
    GetElement(self.m_root,"txtVideoInfoSel_WndSingleCopyInfo",WZUILabelTTF):setScale(0.85)

    GetElement(self.m_root,"txtNextCandidate_WndSingleCopyInfo",WZUILabelTTF):setScale(0.9)
end

function WndSingleCopyInfo:_adaptLanguage_vn()
    local conTitle2 = GetElement(self.m_root,"conTitle2_WndSingleCopyInfo",WZUIContainer)
    conTitle2:setAbsContentSize(GlobalMethod:CCSize(152,34))
    conTitle2:updateRelativeSize()

    local txtSweep1 = GetElement(self.m_root,"txtSweep1_WndSingleCopyInfo",WZUILabelTTF)
    txtSweep1:setFontSize(20)

    local txtSweep2 = GetElement(self.m_root,"txtSweep2_WndSingleCopyInfo",WZUILabelTTF)
    txtSweep2:setFontSize(19)

    GetElement(self.m_root,"txtDesc_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)
    local txtTop = GetElement(self.m_root,"txtTopTitle_WndSingleCopyInfo",WZUILabelTTF)
    txtTop:setRelativePosition(GlobalMethod:ccp(0.43,0.935691))

    GetElement(self.m_root,"txtReset_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)
    
    GetElement(self.m_root,"txtLevelInfo1_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtLevelInfo2_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtHostInfo1_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtHostInfo2_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtVideoInfo_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtVideoInfoSel_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)

    local txtIslandHostInfo1 = GetElement(self.m_root,"txtIslandHostInfo1_WndSingleCopyInfo",WZUILabelTTF)
    txtIslandHostInfo1:setRotation(90)
    txtIslandHostInfo1:setDimensions(GlobalMethod:CCSize(0,0))

    local txtOwnerTimeW1 = GetElement(self.m_root,"txtOwnerTimeW1_WndSingleCopyInfo",WZUILabelTTF)
    txtOwnerTimeW1:setScale(0.8)
    local txtOwnerTimeW2 = GetElement(self.m_root,"txtOwnerTimeW2_WndSingleCopyInfo",WZUILabelTTF)
    txtOwnerTimeW2:setScale(0.8)
    txtOwnerTimeW2:setRelativePosition(GlobalMethod:ccp(0.51,0.5))

    local txtBtnChallenge = GetElement(self.m_root,"txtBtnChallenge_WndSingleCopyInfo",WZUILabelTTF)
    txtBtnChallenge:setFontSize(20)
    txtBtnChallenge:setDimensions(GlobalMethod:CCSize(140,0))

    GetElement(self.m_root,"btnRewardsSwitch_WndSingleCopyInfo",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.93,0.5))
end

function WndSingleCopyInfo:_adaptLanguage_hk(  )
	GetElement(self.m_root,"txtVigour_WndSingleCopyInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.26,0.922778))
end

function WndSingleCopyInfo:_adaptLanguage_tr()
    local txtSweep1 = GetElement(self.m_root,"txtSweep1_WndSingleCopyInfo",WZUILabelTTF)
    txtSweep1:setDimensions(GlobalMethod:CCSize(130,0))
    txtSweep1:setFontSize(24)
    local txtSweep2 = GetElement(self.m_root,"txtSweep2_WndSingleCopyInfo",WZUILabelTTF)
    txtSweep2:setDimensions(GlobalMethod:CCSize(130,0))
    txtSweep2:setFontSize(20)

    local txtGoal1 = GetElement(self.m_root,"txtGoal1_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal1:setScale(0.8)
    txtGoal1:setDimensions(GlobalMethod:CCSize(260,0))
    local txtGoal2 = GetElement(self.m_root,"txtGoal2_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal2:setScale(0.8)
    txtGoal2:setDimensions(GlobalMethod:CCSize(260,0))
    local txtGoal3 = GetElement(self.m_root,"txtGoal3_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal3:setScale(0.8)
    txtGoal3:setDimensions(GlobalMethod:CCSize(260,0))

    GetElement(self.m_root,"txtVideoInfo_WndSingleCopyInfo",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"txtVideoInfoSel_WndSingleCopyInfo",WZUILabelTTF):setScale(0.9)
    --GetElement(self.m_root,"txtMTitle_WndSingleCopyInfo",WZUILabelTTF):setFontSize(18)
    -- GetElement(self.m_root,"txtTopTitle_WndSingleCopyInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.935691))
    local txtVig = GetElement(self.m_root,"txtVig_WndSingleCopyInfo",WZUILabelTTF)
    --txtVig:setDimensions(GlobalMethod:CCSize(100,0))
    txtVig:setScale(0.7)
    local txtCanFire = GetElement(self.m_root,"txtCanFireCount_WndSingleCopyInfo",WZUILabelTTF)
    txtCanFire:setRelativePosition(GlobalMethod:ccp(0.88,0.927906))
    local txtVigour = GetElement(self.m_root,"txtVigour_WndSingleCopyInfo",WZUILabelTTF)
    txtVigour:setScale(0.7)
    txtVigour:setRelativePosition(GlobalMethod:ccp(0.27,0.922778))

    local txtGetReward = GetElement(self.m_root,"txtGetReward_WndSingleCopyInfo",WZUILabelTTF)
    txtGetReward:setDimensions(GlobalMethod:CCSize(120))
    txtGetReward:setScale(0.7)

    local txtTop = GetElement(self.m_root,"txtTopTitle_WndSingleCopyInfo",WZUILabelTTF)
    txtTop:setFontSize(22)
    txtTop:setRelativePosition(GlobalMethod:ccp(0.45,0.935691))

    local txtDesc = GetElement(self.m_root,"txtDesc_WndSingleCopyInfo",WZUILabelTTF)
    txtDesc:setScale(0.83)
    txtDesc:setDimensions(GlobalMethod:CCSize(330,0))

    local txtHostInfo1 = GetElement(self.m_root,"txtHostInfo1_WndSingleCopyInfo",WZUILabelTTF)
    txtHostInfo1:setScale(0.6)
    txtHostInfo1:setDimensions(GlobalMethod:CCSize(130))
    local txtHostInfo2 = GetElement(self.m_root,"txtHostInfo2_WndSingleCopyInfo",WZUILabelTTF)
    txtHostInfo2:setScale(0.6)
    txtHostInfo2:setDimensions(GlobalMethod:CCSize(130))
    GetElement(self.m_root,"txtNextCandidate_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)
    
    local ftxtRewardWords = GetElement(self.m_root, "ftxtRewardWords_WndSingleCopyInfo", WZUIFreeTextBox)
    ftxtRewardWords:setScale(0.8)
    ftxtRewardWords:setMaxWidth(340)

    local txtCantAtt = GetElement(self.m_root, "txtCantAtt_WndSingleCopyInfo", WZUILabelTTF)
    txtCantAtt:setScale(0.8)
    txtCantAtt:setDimensions(GlobalMethod:CCSize(320))
    GetElement(self.m_root, "txtHostRankTitle_WndSingleCopyInfo", WZUILabelTTF):setScale(0.8)
end

function WndSingleCopyInfo:_adaptLanguage_es(  )
    local txtTop = GetElement(self.m_root,"txtTopTitle_WndSingleCopyInfo",WZUILabelTTF)
    txtTop:setFontSize(20)
    txtTop:setRelativePosition(GlobalMethod:ccp(0.45,0.935691))

    local txtSweep1 = GetElement(self.m_root,"txtSweep1_WndSingleCopyInfo",WZUILabelTTF)
    txtSweep1:setDimensions(GlobalMethod:CCSize(130,0))
    txtSweep1:setFontSize(20)

    local txtSweep2 = GetElement(self.m_root,"txtSweep2_WndSingleCopyInfo",WZUILabelTTF)
    txtSweep2:setDimensions(GlobalMethod:CCSize(130,0))
    txtSweep2:setFontSize(20)

    local txtGoal3 = GetElement(self.m_root,"txtGoal3_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal3:setFontSize(18)
    txtGoal3:setDimensions(GlobalMethod:CCSize(200,0))

    local txtGoal1 = GetElement(self.m_root,"txtGoal1_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal1:setFontSize(18)
    txtGoal1:setDimensions(GlobalMethod:CCSize(200,0))

    local txtDesc = GetElement(self.m_root,"txtDesc_WndSingleCopyInfo",WZUILabelTTF)
    txtDesc:setScale(0.8)
    txtDesc:setDimensions(GlobalMethod:CCSize(300,0))

    GetElement(self.m_root,"txtLevelInfo1_WndSingleCopyInfo",WZUILabelTTF):setScale(0.65)
    GetElement(self.m_root,"txtLevelInfo2_WndSingleCopyInfo",WZUILabelTTF):setScale(0.65)

    local txtKinkRestTimes = GetElement(self.m_root,"txtKinkRestTimes_WndSingleCopyInfo",WZUILabelTTF)
    txtKinkRestTimes:setScale(0.8)
    txtKinkRestTimes:setRelativePosition(GlobalMethod:ccp(0.556038,0.927906))
    local txtCanFire = GetElement(self.m_root,"txtCanFireCount_WndSingleCopyInfo",WZUILabelTTF)
    txtCanFire:setScale(0.8)
    txtCanFire:setRelativePosition(GlobalMethod:ccp(0.699099,0.927906))
    
    GetElement(self.m_root,"txtVideoDes_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)

    local txtGetReward = GetElement(self.m_root,"txtGetReward_WndSingleCopyInfo",WZUILabelTTF)
    txtGetReward:setDimensions(GlobalMethod:CCSize(160,0))
    txtGetReward:setScale(0.5)

    local txtHostInfo1 = GetElement(self.m_root,"txtHostInfo1_WndSingleCopyInfo",WZUILabelTTF)
    txtHostInfo1:setScale(0.6)
    txtHostInfo1:setDimensions(GlobalMethod:CCSize(130))
    local txtHostInfo2 = GetElement(self.m_root,"txtHostInfo2_WndSingleCopyInfo",WZUILabelTTF)
    txtHostInfo2:setScale(0.6)
    txtHostInfo2:setDimensions(GlobalMethod:CCSize(130))

    GetElement(self.m_root,"txtIslandHostInfo1_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtIslandHostInfo2_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)

    local txtNextCandidate = GetElement(self.m_root,"txtNextCandidate_WndSingleCopyInfo",WZUILabelTTF)
    txtNextCandidate:setScale(0.6)
    txtNextCandidate:setDimensions(GlobalMethod:CCSize(160))
    
    local txtCantAtt = GetElement(self.m_root, "txtCantAtt_WndSingleCopyInfo", WZUILabelTTF)
    txtCantAtt:setScale(0.8)
    txtCantAtt:setDimensions(GlobalMethod:CCSize(320))
end

function WndSingleCopyInfo:_adaptLanguage_ug(  )
    GetElement(self.m_root,"txtTopTitle_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)

    local txtVig = GetElement(self.m_root,"txtVig_WndSingleCopyInfo",WZUILabelTTF)
    txtVig:setScale(0.7)
    txtVig:setDimensions(GlobalMethod:CCSize(160))
    txtVig:setRelativePosition(GlobalMethod:ccp(0.299254,0.927906))
    local txtVigour = GetElement(self.m_root,"txtVigour_WndSingleCopyInfo",WZUILabelTTF)
    txtVigour:setScale(0.7)
    txtVigour:setRelativePosition(GlobalMethod:ccp(0.111174,0.927906))
    local imgVig = GetElement(self.m_root,"imgVig_WndSingleCopyInfo",WZUIImage)
    imgVig:setRelativePosition(GlobalMethod:ccp(0.0723911,0.931024))
    local txtKinkRestTimes = GetElement(self.m_root,"txtKinkRestTimes_WndSingleCopyInfo",WZUILabelTTF)
    txtKinkRestTimes:setScale(0.7)
    txtKinkRestTimes:setRelativePosition(GlobalMethod:ccp(0.819082,0.927906))
    local txtCanFireCount = GetElement(self.m_root,"txtCanFireCount_WndSingleCopyInfo",WZUILabelTTF)
    txtCanFireCount:setScale(0.7)
    txtCanFireCount:setRelativePosition(GlobalMethod:ccp(0.573012,0.927906))

    GetElement(self.m_root,"txtLevelInfo1_WndSingleCopyInfo",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"txtLevelInfo2_WndSingleCopyInfo",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"txtVideoInfo_WndSingleCopyInfo",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"txtVideoInfoSel_WndSingleCopyInfo",WZUILabelTTF):setScale(0.9)

    local txtGetReward = GetElement(self.m_root,"txtGetReward_WndSingleCopyInfo",WZUILabelTTF)
    txtGetReward:setDimensions(GlobalMethod:CCSize(160))
    txtGetReward:setScale(0.55)
    local txtEnemies = GetElement(self.m_root,"txtEnemies_WndSingleCopyInfo",WZUILabelTTF)
    txtEnemies:setDimensions(GlobalMethod:CCSize(160))
    txtEnemies:setScale(0.55)

    local txtGoal1 = GetElement(self.m_root,"txtGoal1_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal1:setScale(0.8)
    txtGoal1:setDimensions(GlobalMethod:CCSize(260,0))
    local txtGoal2 = GetElement(self.m_root,"txtGoal2_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal2:setScale(0.8)
    txtGoal2:setDimensions(GlobalMethod:CCSize(260,0))
    local txtGoal3 = GetElement(self.m_root,"txtGoal3_WndSingleCopyInfo",WZUILabelTTF)
    txtGoal3:setScale(0.8)
    txtGoal3:setDimensions(GlobalMethod:CCSize(260,0))

    GetElement(self.m_root,"txtVideoDes_WndSingleCopyInfo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(280,0))
    GetElement(self.m_root,"txtNullMsgTip_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root, "conStar_WndSingleCopyInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.87,0.935691))
end
-------------------------------------语言适配End----------------------------------------
