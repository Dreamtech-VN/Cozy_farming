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
	self.m_root = element
    NotificationCenter:registerNotification(UPDATESINGLECOPYDATANOTIFICATION, self, self.updateData)
    self:_initUI()
    SceneCopy:setBackFunction(function()
        WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
        SceneCopy:setBackFunction(nil)
    end)
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
    local nStarNum = WndSingleCopy:getStarNumById(self.m_tLevelData.id)
    if nStarNum >= 3 then
        self:setContentVisible(false, true, false)
    end

     AdaptLanguage(self)
end

--@brief    弹窗动画完成后的回调
function WndSingleCopyInfo:actionCallback(element, data)
	--初始化界面
    TeachGroup1:startGroup({1,5,WndSingleCopyInfo.m_root}, {3,7,WndSingleCopyInfo.m_root}, {5,14,WndSingleCopyInfo.m_root}, {8,11,WndSingleCopyInfo.m_root}, {9,11,WndSingleCopyInfo.m_root}, {32,8,WndSingleCopyInfo.m_root})
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSingleCopyInfo:onExit(element)
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
    
    if CacheCenter:getPlayerInfo().vipLevel < 2 then
        MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.MULTI_SWEEP_TIP,2), self, self._EventToVIP, MSGBOXLEVEL_NORMAL, nil)
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

    TeachGroup1:endTeachStep({1,5},{3,7},{5,14},{8,11},{9,11},{32,8})
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
    -- local wp = element:convertToWorldSpace(GlobalMethod:ccp(0, 0))
    -- wp.x = wp.x + element:getContentSize().width+350/2
    -- wp.y = wp.y + element:getContentSize().height
    local imgMoster =  WZUIImage:luaTo(WZUIContainer:luaTo(element:getParent()):getChildElement("imgMoster_WndSingleCopyInfo"))
    local monsterFile = imgMoster:getFile()
   
    local imgMosterType = element:getParent():getChildElement("imgMosterType_WndSingleCopyInfo")
    local nMonsterId = imgMosterType:getTag()
    if nMonsterId == -1 then
        return
    end
    local tMonster = GDatatab_monster["id_"..nMonsterId]
    if monsterFile == "" or monsterFile == nil  then
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
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,false,offset)
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

    self:setContentVisible(true, false, false)
end

function WndSingleCopyInfo:onClickShowVedioList(element)
    WZLog("WndSingleCopyInfo:onClickShowVedioList")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    self:setContentVisible(false, false, true)
end

--@brief    设置右框内容
function WndSingleCopyInfo:setContentVisible(bVisible1, bVisible2, bVisible3)
    -- body
    local conMiddleInfo = GetElement(self.m_root,"conMiddleInfo_WndSingleCopyInfo",WZUIContainer)
    --信息
    local cbLevelInfo = GetElement(conMiddleInfo,"cbLevelInfo_WndSingleCopyInfo",WZUICheckBox)
    cbLevelInfo:setTouchEnable(not bVisible1)
    if not bVisible1 then
        cbLevelInfo:setCheckIndex(0)
    end
    local conLeveInfoSelected = GetElement(conMiddleInfo,"conLeveInfoSelected_WndSingleCopyInfo",WZUIContainer)
    conLeveInfoSelected:setVisible(bVisible1)
    local conLevelInfo = GetElement(conMiddleInfo,"conLevelInfo_WndSingleCopyInfo",WZUIContainer)
    conLevelInfo:setVisible(bVisible1)
    --岛主
    local cbHostInfo = GetElement(conMiddleInfo,"cbHostInfo_WndSingleCopyInfo",WZUICheckBox)
    cbHostInfo:setTouchEnable(not bVisible2)
    if not bVisible2 then
        cbHostInfo:setCheckIndex(0)
    end
    local conHostSelect = GetElement(conMiddleInfo,"conHostSelect_WndSingleCopyInfo",WZUIContainer)
    conHostSelect:setVisible(bVisible2)
    local conIslandHostInfo = GetElement(conMiddleInfo,"conIslandHostInfo_WndSingleCopyInfo",WZUIContainer)
    conIslandHostInfo:setVisible(bVisible2)
    --录像
    local cbVideoInfo = GetElement(conMiddleInfo,"cbVideoInfo_WndSingleCopyInfo",WZUICheckBox)
    cbVideoInfo:setTouchEnable(not bVisible3)
    if not bVisible3 then
        cbVideoInfo:setCheckIndex(0)
    end
    local conVedioSelect = GetElement(conMiddleInfo,"conVedioSelect_WndSingleCopyInfo",WZUIContainer)
    conVedioSelect:setVisible(bVisible3)
    local conVideoList = GetElement(conMiddleInfo,"conVideoList_WndSingleCopyInfo",WZUIContainer)
    conVideoList:setVisible(bVisible3)
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
    local txtNoIslangHost = GetElement(self.m_root, "txtNoIslangHost_WndSingleCopyInfo", WZUILabelTTF)
    local bVisible = txtNoIslangHost:isVisible()

    if not bVisible and self.m_tIslandHostData and self.m_tIslandHostData.id > 0 then
        WndCheckOther:show(self.m_tIslandHostData.id)
    end
end

--@brief    点击下届候选人按钮回调
function WndSingleCopyInfo:onClickNextList(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    GetElement(self.m_root, "conHostRank_WndSingleCopyInfo", WZUIContainer):setVisible(true)
end

--@brief    点击岛主标签回调
function WndSingleCopyInfo:onClickShowIslandHost(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    
    self:setContentVisible(false, true, false)
end

--@brief   点击隐藏挑战排名
function WndSingleCopyInfo:onCloseHostRank(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    GetElement(self.m_root, "conHostRank_WndSingleCopyInfo", WZUIContainer):setVisible(false)
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
    local tbconEnemy = GetElement(self.m_root, "tbconEnemy_WndSingleCopyInfo", WZUITableContainer)
    tbconEnemy:cleanTable()
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
    local isScroll = #tEnemyList > 5 and true or false
    tbconEnemy:setEnableMoveHorizontal(isScroll)
    
    for i = 1, #tEnemyList do
        local nMonsterId = tEnemyList[i][1]
        local eCellMonster = self:_createMonsterCell(nMonsterId)
        eCellMonster:setTag(i-1)
        tbconEnemy:setCellElement(eCellMonster)
    end

    if #tEnemyList < 5 then
        local totalEnemyList = #tEnemyList
        for i=totalEnemyList+1,5 do
            local eCellMonster = self:_createMonsterCell(nil)
            eCellMonster:setTag(i-1)
            tbconEnemy:setCellElement(eCellMonster)
        end
    end
end

--@brief	根据怪物id创建怪物头像
--@param    nMonsterId, 怪物id
function WndSingleCopyInfo:_createMonsterCell(nMonsterId)
    local cellMonster = CreateElement("CellMonster_WndSingleCopyInfo")
    if nMonsterId then
        local tMonster = GDatatab_monster["id_"..nMonsterId]
        if tMonster then
            local imageMoster = WZUIImage:luaTo(cellMonster:getChildElement("imgMoster_WndSingleCopyInfo"))
            local imgMonsterType  = WZUIImage:luaTo(cellMonster:getChildElement("imgMosterType_WndSingleCopyInfo"))
            local monsterType = tMonster.type
            imgMonsterType:setFile("")
            imgMonsterType:setTag(nMonsterId)
            if monsterType ==2 then
                imgMonsterType:setFile("ui/common/common_icon_boss.png")
            elseif monsterType == 3 then
                imgMonsterType:setFile("ui/common/common_icon_jingying.png")
                imgMonsterType:setZOrder(999)
            end
            imageMoster:setFile(MONSTER_IMAGE_PATH..tMonster.moster_picture..".png")
            local cellBg = GetElement(cellMonster,"cellBg_CellMonster",WZUIImage)
            cellBg:setFile("ui/common/common_scale9_beibaodi2.png")
            local imgKuang = GetElement(cellMonster,"imgKuang_CellMonster",WZUI9Image)
            imgKuang:setVisible(true)
        end
    end
    cellMonster:setVisible(true)
    return cellMonster
end

--@brief  创建怪物形象
function WndSingleCopyInfo:createMonsterHead(sex,equip)
    WZLog("WndSingleCopy:createMonsterHead ")
    local conPlayer = CreatePlayerFigure(sex, equip, "avatar")
    local animNode = conPlayer:getAnimNode()
    animNode:setTouchEnable(false)
    animNode:setRelativePosition(GlobalMethod:ccp(0.30,-0.230))
    animNode:setScale(0.5)
    if tostring(sex) == "0" then
        animNode:setRelativePosition(GlobalMethod:ccp(0.23,-0.175))
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
        local eItem, tItem = self:_createCellGoodItem(i, tDropData[i])
        tbconDrop:setCellElement(eItem)
    end

end

--@brief    创建一个物品格子
--@param    nIndex, 序号
--@param    nItemId, 物品id
function WndSingleCopyInfo:_createCellGoodItem(nIndex, nItemId)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setTag(nIndex-1)
    --eItem:setScale(1)
    tItem:setFromTag(nIndex-1)
    tItem:setItemClickFun(self, self.onClickListItem)
    local tData = nil
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
            img:setVisible(true)
            img2:setVisible(false)
        else
            img:setGrayRender(false)
            img2:setVisible(true)
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
            txtGoal:setFontSize(20)
        end
        local starS = string.format(LocalStrings.PASS_LEVEL_STAT,i)
        if nState == 0 then
            imgStar:setFile("ui/common/common_icon_xingxing2.png")
            imgStar:setGrayRender(true)
            txtGoal:setColor(GlobalMethod:ccc3(195,171,148))
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
                    local temp2 = showText .. "\n" .. temp
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
                   temp2 = showText .. "\n" .. temp
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
    local tHostData = self.m_tIslandHostData
    local conIslangHostHead = GetElement(self.m_root, "conIslangHostHead_WndSingleCopyInfo", WZUIContainer)
    local txtNoIslangHost = GetElement(self.m_root, "txtNoIslangHost_WndSingleCopyInfo", WZUILabelTTF)
    local txtIslandHostName = GetElement(self.m_root, "txtIslandHostName_WndSingleCopyInfo", WZUILabelTTF)
    if tHostData.id > 0 then
        local cellElement =  CellHead:show(conIslangHostHead, tHostData.headId, tHostData.faceId, tHostData.sex, nil, nil, tHostData.vipLevel, tHostData.headColor)
        --名字
        if txtIslandHostName then
            txtIslandHostName:setText(tHostData.name)
        end

        conIslangHostHead:setVisible(true)
        txtIslandHostName:setVisible(true)
        
        txtNoIslangHost:setVisible(false)
    else
        conIslangHostHead:setVisible(false)
        txtIslandHostName:setVisible(false)

        txtNoIslangHost:setVisible(true)
    end
end

--@brief    展示挑战的岛主数据
function WndSingleCopyInfo:_showIslandHostInfo()
    -- body
    local tHostData = self.m_tIslandHostData
    local txtHostScore = GetElement(self.m_root, "txtHostScore_WndSingleCopyInfo", WZUILabelTTF)
    if tHostData.id > 0 then
        if txtHostScore then
            txtHostScore:setText(LocalStrings.SINGLECOPY_TEXT6 .. tHostData.score)
        end
    else
        if txtHostScore then
            txtHostScore:setText(LocalStrings.COMMUNITY_COMPETE_TEXT43)
        end
    end
    --
    local ftxtRewardWords = GetElement(self.m_root, "ftxtRewardWords_WndSingleCopyInfo", WZUIFreeTextBox)
    if ftxtRewardWords then
        ftxtRewardWords:setShowText(LocalStrings.SINGLECOPY_TEXT4)
    end
    local tbHostRewardList = GetElement(self.m_root, "tbHostRewardList_WndSingCopyInfo", WZUITableContainer)
    tbHostRewardList:cleanTable()

    local tDropData = self.m_tLevelData.dwar_boss
    if tDropData == 0 then return end 
    for i = 1, #tDropData do
        local eItem, tItem = self:_createCellGoodItem(i, tDropData[i])
        tbHostRewardList:setCellElement(eItem)
    end
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

    local ftxtRewardWords = GetElement(self.m_root, "ftxtRewardWords_WndSingleCopyInfo", WZUIFreeTextBox)
    ftxtRewardWords:setScale(0.8)
    ftxtRewardWords:setMaxWidth(340)

    GetElement(self.m_root,"txtIslandOwner_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)        
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
    local txtEnemies = GetElement(self.m_root,"txtEnemies_WndSingleCopyInfo",WZUILabelTTF)
    txtEnemies:setDimensions(GlobalMethod:CCSize(120))
    txtEnemies:setScale(0.73)
    
    local txtHostInfo1 = GetElement(self.m_root,"txtHostInfo1_WndSingleCopyInfo",WZUILabelTTF)
    txtHostInfo1:setScale(0.6)
    txtHostInfo1:setDimensions(GlobalMethod:CCSize(130))
    local txtHostInfo2 = GetElement(self.m_root,"txtHostInfo2_WndSingleCopyInfo",WZUILabelTTF)
    txtHostInfo2:setScale(0.6)
    txtHostInfo2:setDimensions(GlobalMethod:CCSize(130))

    GetElement(self.m_root,"txtIslandOwner_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8) 

    GetElement(self.m_root,"txtIslandHostInfo1_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtIslandHostInfo2_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)

    local txtNextCandidate = GetElement(self.m_root,"txtNextCandidate_WndSingleCopyInfo",WZUILabelTTF)
    txtNextCandidate:setScale(0.6)
    txtNextCandidate:setDimensions(GlobalMethod:CCSize(160))

    local ftxtRewardWords = GetElement(self.m_root, "ftxtRewardWords_WndSingleCopyInfo", WZUIFreeTextBox)
    ftxtRewardWords:setScale(0.7)
    ftxtRewardWords:setMaxWidth(400)

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
    local conTitle = GetElement(self.m_root,"conTitle_WndSingleCopyInfo",WZUIContainer)
    conTitle:setAbsContentSize(GlobalMethod:CCSize(182,34))
    conTitle:updateRelativeSize()

    local conTitle2 = GetElement(self.m_root,"conTitle2_WndSingleCopyInfo",WZUIContainer)
    conTitle2:setAbsContentSize(GlobalMethod:CCSize(152,34))
    conTitle2:updateRelativeSize()

    local txtSweep1 = GetElement(self.m_root,"txtSweep1_WndSingleCopyInfo",WZUILabelTTF)
    txtSweep1:setFontSize(20)

    local txtSweep2 = GetElement(self.m_root,"txtSweep2_WndSingleCopyInfo",WZUILabelTTF)
    txtSweep2:setFontSize(19)

    local txtVigour = GetElement(self.m_root,"txtVigour_WndSingleCopyInfo",WZUILabelTTF)
    txtVigour:setRelativePosition(GlobalMethod:ccp(0.272043,0.922778))

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

    GetElement(self.m_root,"txtIslandHostInfo1_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtIslandHostInfo2_WndSingleCopyInfo",WZUILabelTTF):setScale(0.8)

    local ftxtRewardWords = GetElement(self.m_root, "ftxtRewardWords_WndSingleCopyInfo", WZUIFreeTextBox)
    ftxtRewardWords:setScale(0.8)
    ftxtRewardWords:setMaxWidth(340)
    
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
    GetElement(self.m_root,"txtTopTitle_WndSingleCopyInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.935691))
    local txtVig = GetElement(self.m_root,"txtVig_WndSingleCopyInfo",WZUILabelTTF)
    --txtVig:setDimensions(GlobalMethod:CCSize(100,0))
    txtVig:setScale(0.7)
    local txtCanFire = GetElement(self.m_root,"txtCanFireCount_WndSingleCopyInfo",WZUILabelTTF)
    txtCanFire:setRelativePosition(GlobalMethod:ccp(0.88,0.927906))
    local txtVigour = GetElement(self.m_root,"txtVigour_WndSingleCopyInfo",WZUILabelTTF)
    txtVigour:setScale(0.7)
    txtVigour:setRelativePosition(GlobalMethod:ccp(0.27,0.922778))

    local txtEnemies = GetElement(self.m_root,"txtEnemies_WndSingleCopyInfo",WZUILabelTTF)
    txtEnemies:setDimensions(GlobalMethod:CCSize(120))
    txtEnemies:setScale(0.7)
    local txtGetReward = GetElement(self.m_root,"txtGetReward_WndSingleCopyInfo",WZUILabelTTF)
    txtGetReward:setDimensions(GlobalMethod:CCSize(120))
    txtGetReward:setScale(0.7)
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

    local txtEnemies = GetElement(self.m_root,"txtEnemies_WndSingleCopyInfo",WZUILabelTTF)
    txtEnemies:setDimensions(GlobalMethod:CCSize(160))
    txtEnemies:setScale(0.5)
    local txtGetReward = GetElement(self.m_root,"txtGetReward_WndSingleCopyInfo",WZUILabelTTF)
    txtGetReward:setDimensions(GlobalMethod:CCSize(160,0))
    txtGetReward:setScale(0.5)

    local txtHostInfo1 = GetElement(self.m_root,"txtHostInfo1_WndSingleCopyInfo",WZUILabelTTF)
    txtHostInfo1:setScale(0.6)
    txtHostInfo1:setDimensions(GlobalMethod:CCSize(130))
    local txtHostInfo2 = GetElement(self.m_root,"txtHostInfo2_WndSingleCopyInfo",WZUILabelTTF)
    txtHostInfo2:setScale(0.6)
    txtHostInfo2:setDimensions(GlobalMethod:CCSize(130))
    
    GetElement(self.m_root,"txtIslandOwner_WndSingleCopyInfo",WZUILabelTTF):setScale(0.75) 

    GetElement(self.m_root,"txtIslandHostInfo1_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtIslandHostInfo2_WndSingleCopyInfo",WZUILabelTTF):setScale(0.7)

    local txtNextCandidate = GetElement(self.m_root,"txtNextCandidate_WndSingleCopyInfo",WZUILabelTTF)
    txtNextCandidate:setScale(0.6)
    txtNextCandidate:setDimensions(GlobalMethod:CCSize(160))
    
    local ftxtRewardWords = GetElement(self.m_root, "ftxtRewardWords_WndSingleCopyInfo", WZUIFreeTextBox)
    ftxtRewardWords:setScale(0.7)
    ftxtRewardWords:setMaxWidth(400)
    
    local txtCantAtt = GetElement(self.m_root, "txtCantAtt_WndSingleCopyInfo", WZUILabelTTF)
    txtCantAtt:setScale(0.8)
    txtCantAtt:setDimensions(GlobalMethod:CCSize(320))
end

-------------------------------------语言适配End----------------------------------------
