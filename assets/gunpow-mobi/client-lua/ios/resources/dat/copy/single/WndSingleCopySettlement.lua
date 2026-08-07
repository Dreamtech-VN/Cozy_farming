--WndSingleCopySettlement.lua
--@brief	WndSingleCopySettlement的UI模块
--@date		2015/05/22
--@author	xiaoyu_wu
--@note		单人副本结算窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSingleCopySettlement:onEnter(element)
	self.m_root = element
    if self.isWin then
        g_bIsPushSpecifyActivity = false
        self:_updateWin()
         SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN)
        -- if WBattleGlobal:getCurrent():getMyHero().m_nBoyOrGirl == 0 then
        --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_BOY,false,true)
        -- else
        --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_GIRL,false,true)
        -- end
    else
        g_bIsPushSpecifyActivity = true
        self:_updateLose()
        SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_LOSE)
    end
    ChangeChatChannel(Chat_Channel_Single_Copy_Reward)
    self:_setUIStaticText()
    self.m_nCountdown = 3
    WindowManager:getSceneRoot():removeChildByTag(78945, true)               
    --self:_updateBackTime()
    ProtocolProcessorSingleMap:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartChallengeOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_StartChallengeOk", "iivi")
    
    if AutoRunBattleConst.AUTO_RUN_BATTLE then
        self:goback()
    end

    if IsIphoneX() then
        local con = GetElement(self.m_root, "conVideo_WndSingleCopySettlement", WZUIContainer)
        if con then
            con:setRelativePositionLuaTo(0.97,0.5)
        end
    end
end

function WndSingleCopySettlement:onEnterTransitionDidFinish(element)
	if WndGangsterInn.m_bShouldClose == true then
		WndGangsterInn.m_bShouldClose = false
		MsgBoxManager:showTipBox(LocalStrings.INN12)
	end
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSingleCopySettlement:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
    ProtocolProcessorSingleMap:unregProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartChallengeOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_StartChallengeOk", "iivi")
end

--@brief	开始点击窗口后的回调
--@param	element:窗口绑定的lua表
--@param    pt:坐标点
function WndSingleCopySettlement:onTouchBegan(element, pt)
    WZLog("WndSingleCopySettlement:onTouchBegan")
    WndItemInfo:onCloseClick()
    if self.b_doBack then
        --SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
        --self:goback()
    end
end

--@brief    开始点击窗口后的回调
--@param    element:窗口绑定的lua表
--@param    pt:坐标点
function WndSingleCopySettlement:onTouchEnd(element, pt)
    WZLog("WndSingleCopySettlement:onTouchEnd")
    -- WndItemInfo:onCloseClick()
    if self.b_doBack then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
        self:goback()
    end
end

--@brief    战斗胜利分享到Facebook点击事件
function WndSingleCopySettlement:onFBShare( element )
    local content
    for k,v in pairs(GDatatab_single_map) do
        if v.id == WBattleGlobal:getCurrent().m_tMakePairOk.mapId then
            content = v.section_name
            break
        end
    end

    SetFBShareByPackage(2, content)
end

-- 重播录像
function WndSingleCopySettlement:onAgainVideo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    BattleMsgReplayGameRecord:replayRecord()
end

-- 退出录像
function WndSingleCopySettlement:onExitVideo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    SceneBattle:leftBattle()
end

--@brief	点击完成任务按钮后的回调
--@param	element:按钮绑定的UI节点
function WndSingleCopySettlement:onTask(element)
    WZLog("WndMultiCopySettlement:onTask")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:goback()
    DelayCallFunction(function()
        local wndTaskElement = WndTask:createElement()
        WindowManager:addWindow(wndTaskElement, WndTask)
    end, nil, 0)   
end

--@brief	点击重新开始按钮后的回调
--@param	element:按钮绑定的UI节点
function WndSingleCopySettlement:onAgain(element)
    WZLog("WndMultiCopySettlement:onAgain")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    GlobalGame.g_singleCopyData = CopyTable(WBattleGlobal:getCurrent().m_tMakePairOk)
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self.m_tData.pointId, COPYTYPE_SINGLE)
end

--@brief	点击返回按钮后的回调
--@param	element:按钮绑定的UI节点
function WndSingleCopySettlement:onBack(element)
    WZLog("WndMultiCopySettlement:onBack")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:goback()
end

--@brief	返回
function WndSingleCopySettlement:goback()
    WZLog("WndSingleCopySettlement:goback")
    if TeachGroup1.ISFIRSTBATTLE then
        TeachGroup1.ISFIRSTBATTLE = nil
        TeachGroup1:endFirstBattleTeach()
    elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) then
        local index = 1
        if WBattleGlobal:getCurrent():isFlyCopy() then
            index = 1
        elseif WBattleGlobal:getCurrent():isWindCopy() then
            index = 2
        elseif WBattleGlobal:getCurrent():isHoleCopy() then
            index = 3
        elseif WBattleGlobal:getCurrent():isThrowCopy() then
            index = 4
        end
        ScenePvp:showScene(index)
    elseif WBattleGlobal:getCurrent():getBattleMode() == BattleConstants.g_tBossBattleMode.MODE_NORMAL_TABOO then
         SceneTabooBattle:show(-1)
        --弹穿上或打开提示窗口
        pushEquipInList()
        g_bIsShowWndDressUp = true
    else
        if GlobalGame.g_nSingleCopyType == 3 then 
            SceneCopy:showScene(1, self.m_tData.pointId)
        else
            SceneCopy:showScene(1, self.m_tData.pointId, GlobalGame.g_nSingleCopyType)
        end
        --弹穿上或打开提示窗口
        pushEquipInList()
        g_bIsShowWndDressUp = true
    end
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndSingleCopySettlement:onClickItem(tItem, nTag, tData)
    WZLog("WndSingleCopySettlement:onClickItem")
    WndItemInfo:onCloseClick()
    local m_element = GetElement(self.m_root, "conWin_WndSingleCopySettlement", WZUIContainer)
    --WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false, nil, true)
    WndItemInfo:showInfo(tItem.m_root,m_element,1,tData, false)   
end

function WndSingleCopySettlement:onPlayOver(element)
	if not self.isWin then
		return
	end
	if self.isVideo then
            local con = GetElement(self.m_root, "conVideo_WndSingleCopySettlement", WZUIContainer)
            con:setVisible(true)
        else
            self:_setBackState()
        end
        self.m_root:disableSchedule()
end

function WndSingleCopySettlement:_expAni(element, delta)
    local exp = math.max(math.floor(self.needAddExp/20),1)
    local maxExp = GetMaxExpByLevel(self.curLv)
    local maxLv = GetPlayerMaxLevel()
    if self.leftExp == 0 then
        element:disableSchedule()
        return
    end
    local addExp = (self.leftExp > exp ) and exp or self.leftExp
    self.leftExp = self.leftExp - addExp
    self.curExp = self.curExp + addExp
    if self.curExp > maxExp then
        if self.curLv == maxLv then
            self.curExp = maxExp
            element:disableSchedule()
        else
            self.curExp = self.curExp - maxExp
            self.curLv = self.curLv + 1
            self:_showUpgrade()
            WZLog("----------------exp update-------------------")
        end
    end
    self:_updateExpProgress()
    WZLog("----------------expAni-------------------",exp,addExp,self.leftExp,self.curExp,self.curLv,maxExp)
end


function WndSingleCopySettlement:onFail(element)
    WZLog("------------------onFail--------------")
    if self.isVideo then return end
    local tag = element:getTag()
    local ui = self.failUiData[tag].Link
    self:goback()

    DelayCallFunction(function()
        JumpByUIId(ui)
    end, nil, 0)
end

function WndSingleCopySettlement:onTask()
    WZLog("------------------task--------------")
    MsgBoxManager:showTipBox("该功能未开启")
end

function WndSingleCopySettlement:onStar()
    WZLog("------------------star--------------")
    
end

function WndSingleCopySettlement:onShare()
    ---self:goback()
    MsgBoxManager:showTipBox("该功能未开启")
end


function WndSingleCopySettlement:onMoney()
    WZLog("------------------money--------------")

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 更新赢的界面
function WndSingleCopySettlement:_updateWin()
    local conWin = GetElement(self.m_root, "conWin_WndSingleCopySettlement", WZUIContainer)
    conWin:setVisible(true)
    if ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1051 
        or ProjConfig.CHANNEL_ID == 1053 then
        GetElement(self.m_root,"btnFBShare_WndSingleCopySettlement",WZUIButton):setVisible(true)
    end
    --self.m_root:enableSchedule("scheduleCountdown", 0.01)
   -- self:_setUIStaticText()
    self:_updateStar()
    self:_updateConditionList()
    self:_updateReward()
    self:_updatePlayerAni(true)
    self:_updateTaskButtonState()
    DelayCallFunction(self.onSchedule, self, 3)
    DelayCallFunction(self.onPlayOver, self, 4)
end

-- 更新输的界面
function WndSingleCopySettlement:_updateLose()
    local conWin = GetElement(self.m_root, "conLose_WndSingleCopySettlement", WZUIContainer)
    conWin:setVisible(true)
    local isEndTeach, teachStep = TeachGroup1:isTeachFinish(32)
    local isTeachFinish = true
    if CacheCenter:getPlayerInfo().level <= 5 and isEndTeach ~= true then
        isTeachFinish = false
    end
    local conWin = GetElement(self.m_root, "conLoseGoTo_WndSingleCopySettlement", WZUIContainer)
    if isTeachFinish and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) == false then
        conWin:setVisible(true)
    else
        conWin:setVisible(false)
    end
    local fielPath = "ui/copy_settlement/common_pic_sb.png"
    GetElement(self.m_root, "imgLeftBg_WndSingleCopySettlement", WZUIImage):setFile(fielPath)
    -- local rightElement = GetElement(self.m_root, "imgRightBg_WndSingleCopySettlement", WZUIImage)
    -- rightElement:setFile(fielPath)
    -- rightElement:setFlipX(true)
    self:_setBackState(true)
    self:_updatePlayerAni(false)
    self.failUiData = GetFailCopyUi()
    WZLog("WndSingleCopySettlement:_updateLose:", #self.failUiData, tostring(isTeachFinish))
    for i =1, #self.failUiData do
        WZLog("WndSingleCopySettlement:",self.failUiData[i].icon) 
         GetElement(self.m_root, "imgBtnIcon"..i.."_WndSingleCopySettlement", WZUIImage):setFile(self.failUiData[i].icon)
    end
    --self:_initText()

end

--@brief	更新星星数
function WndSingleCopySettlement:_updateStar()
    local tBits = NumberToBits(self.m_tData.factor, 3)
    local nStarNum = 0
    local tLevelData = GDatatab_single_map["id_"..self.m_tData.pointId]
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) then
        tLevelData = GDatatab_train_map["id_"..self.m_tData.pointId]
        if self.m_tData.round < tLevelData.pass_round then
            nStarNum = 3
        else
            nStarNum = 2
        end
    else
        if tLevelData.map_type == 3 then
            nStarNum = tLevelData.map_num
        else
            nStarNum = (tBits[1] or 0) + (tBits[2] or 0) + (tBits[3] or 0)
        end
    end
    GlobalGame.m_nStarNum = nStarNum
    if nStarNum == 3 then
      DelayCallFunction(self._playPerfect1, self, 2)
      DelayCallFunction(self._playPerfect2, self, 2)
    end
    WZLog("WndSingleCopySettlement:_updateStar", nStarNum)
    local spine = GetElement(self.m_root, "winSpine_WndSingleCopySettlement", WZUISpine)
    if nStarNum < 1 or nStarNum > 3 then
        return
    end
    self.m_nStarNum = nStarNum
    spine:play("victory"..nStarNum, false)
    GetElement(self.m_root,"conWinLeft_WndSingleCopySettlement",WZUIContainer):enableSchedule("_updateSpine")
end

--@brief 胜利动画
function WndSingleCopySettlement:_updateSpine(element,dt)
    if  GetElement(self.m_root, "winSpine_WndSingleCopySettlement", WZUISpine):isCurrentAnimationDone() then
        element:disableSchedule()
        GetElement(self.m_root, "winSpine_WndSingleCopySettlement", WZUISpine):play("victory_wait"..self.m_nStarNum,true)
    end
    
end

--@brief	更新获取星星的条件列表
function WndSingleCopySettlement:_updateConditionList()
    local tbconCondition = GetElement(self.m_root, "tbconCondition_WndSingleCopySettlement", WZUITableContainer)
    tbconCondition:cleanTable()
    
    local tLevelData = GDatatab_single_map["id_"..self.m_tData.pointId]
    local tBits = NumberToBits(self.m_tData.factor, 3)
    local hp = self.m_tData.curHp
    local maxHp = self.m_tData.maxHp
    local round = self.m_tData.round
    local score = self.m_tData.score        --关卡评分
    local info = self.m_tData
    WZLog("-----------single info---------",info.curHp,info.maxHp,info.round)

    local goalStr1, goalStr2
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) then
        tLevelData = GDatatab_train_map["id_"..self.m_tData.pointId]
        if WBattleGlobal:getCurrent():isFlyCopy() then
            goalStr1 = string.format(LocalStrings.TRAINCAMP_DEC6, tLevelData.pass_count)
        else
            --欧洲要求改的
            if ProjConfig.CHANNEL_ID == 1061 or ProjConfig.CHANNEL_ID == 1062 or ProjConfig.CHANNEL_ID == 1051 or ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1053 then
                if ProjConfig.LANGUAGE == "en" then
                    goalStr1 = LocalStrings.TRAINCAMP_DEC7
                else
                    goalStr1 = string.format(LocalStrings.TRAINCAMP_DEC7, tLevelData.pass_count)
                end
            else
                goalStr1 = string.format(LocalStrings.TRAINCAMP_DEC7, tLevelData.pass_count)
            end
        end
        goalStr2 = string.format("%d", WndCopyFlyInfoView.m_nCount)
        local isRound = self.m_tData.round < tLevelData.pass_round and 1 or 0
        tBits = {1,1,isRound}
    else
        goalStr1 = string.format(LocalStrings.COPY_GOAL2_2, tLevelData.pass_hp)
        goalStr2 = string.format("%d%%", math.ceil(hp*100/maxHp))
    end 

    local goal = {}
    goal[1] = {
        LocalStrings.COPY_GOAL1,
        LocalStrings.COMPLETE,
        tBits[1] or 0,
    }

    goal[2] = {
        goalStr1,
        goalStr2,
        tBits[2] or 0,
    }
    goal[3] = {
        string.format(LocalStrings.COPY_GOAL3_2, tLevelData.pass_round),
        round,
        tBits[3] or 0,
    }
    goal[4] = {
        LocalStrings.SINGLECOPY_TEXT6,
        score,
    }

    local tGoalList = {goal[1]}
    local roundLimit = tLevelData.pass_round
    local hpLimit = tLevelData.pass_hp
    if hpLimit and hpLimit ~= -1 then
        table.insert(tGoalList,goal[2])
    end
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TRAIN) then
        table.insert(tGoalList,goal[2])
    end
    if roundLimit ~= -1 then
        table.insert(tGoalList,goal[3])
    end
    if score and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) and tLevelData.map_type ~= 5 then
        table.insert(tGoalList,goal[4])
    end

    self.cellList = {}
    for i = 1,#tGoalList do
        local eCell = self:_createCellCondition(i, tGoalList[i])
        eCell:setVisible(true)
        tbconCondition:setCellElement(eCell)
        self.cellList[i] = eCell
    end
end

function WndSingleCopySettlement:onSchedule(element, dt)
     WZLog("WndSingleCopySettlement:onSchedule")
	if not self.isWin then
		return
	end
     WZLog("WndSingleCopySettlement:onSchedule22222")
    local txtGold = GetElement(self.m_root, "txtGold_WndSingleCopySettlement", WZUILabelTTF)
    txtGold:enableSchedule("_expAni",0.1)
    SoundManager:playEffectSound(SoundDefine.E_S_SETTLEMENT)
end


local COMPLETE_COLOR = GlobalMethod:ccc3(255,227,116)
local UNCOMPLETE_COLOR = GlobalMethod:ccc3(255,121,31)
--@brief    创建一个条件单元格
--@param    nIndex, 序号
--@param    tCondition, 条件信息表
--@return   条件单元格
function WndSingleCopySettlement:_createCellCondition(nIndex, tCondition)
    local eCell = CreateElement("CellSettlementCondition")
    eCell:setTag(nIndex-1)
    local txtCondition = GetElement(eCell, "txtCondition_CellSettlementCondition", WZUILabelTTF)
    txtCondition:setText(tCondition[1])
    
    local txtResult = GetElement(eCell, "txtResult_CellSettlementCondition", WZUILabelTTF)
    txtResult:setText(tCondition[2])
    
    local imgResult = GetElement(eCell, "imgResult_CellSettlementCondition", WZUIImage)
    WZLog("thisWW:", tCondition[3])
    if tCondition[3] == 0 then
        imgResult:setFile("ui/common/common_icon_weida.png")
        txtResult:setColor(GlobalMethod:ccc3(255,121,31))
    else
        imgResult:setFile("ui/common/common_icon_dacheng.png")
        txtResult:setColor(GlobalMethod:ccc3(255,227,116))
    end
    if nIndex == 4 then
        imgResult:setVisible(false)
    end
    if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
        txtCondition:setFontSize(20)
        txtResult:setFontSize(20)
    end
    return eCell
end

--@brief	更新奖励
function WndSingleCopySettlement:_updateReward()
    local con = GetElement(self.m_root, "conItemCon_WndSingleCopySettlement", WZUIContainer)
    local nGold = 0
    local nExp = 0
    --local nIndex = 1
    local otherR = {}
    for i,v in ipairs(self.m_tData.rewardId) do
        if v == 2 then --金币
            nGold = self.m_tData.rewardCount[i]
        elseif v == 3 then --经验
            nExp = self.m_tData.rewardCount[i]
        else --其他物品
--            WZLog("WndSingleCopySettlement:_updateReward itemId:",v)
--            local eItem = self:_createCellGoodItem(nIndex, v, self.m_tData.rewardCount[i])
--            local con = GetElement(self.m_root, "conReward"..nIndex.."_WndSingleCopySettlement")
--			if not con then break end
--            con:addChild(eItem)
--            nIndex = nIndex + 1
            local reward = {itemId = v,itemCnt = self.m_tData.rewardCount[i] }
            table.insert(otherR,reward)
        end
    end

    local tabReward = GetElement(self.m_root, "tabReward_WndSingleCopySettlement",WZUITableContainer)
    for i = 1, #otherR do
        local item = self:_createCellGoodItem(otherR[i])
        item:setTag(i-1)
        tabReward:setCellElement(item)
    end


    local pInfo = self.m_tData.playerData
    if not pInfo then
        pInfo = {}
        pInfo.level = CacheCenter:getPlayerInfo().level
        pInfo.exp = 0
    end
    
    local txtLv = GetElement(self.m_root, "txteLv_WndSingleCopySettlement", WZUILabelTTF)
    txtLv:setText("Lv"..pInfo.level)

    local txtGold = GetElement(self.m_root, "txtGold_WndSingleCopySettlement", WZUILabelTTF)
    txtGold:setText(nGold)

    local txtExp = GetElement(self.m_root, "txtExp_WndSingleCopySettlement", WZUILabelTTF)
    txtExp:setText(nExp)

    self.needAddExp = nExp
    self.leftExp = nExp
    self.curLv =  pInfo.level
    self.curExp = pInfo.exp
    WZLog("----------------init lv and exp ---------------------",self.curLv,self.curExp,self.leftExp)
    self:_updateExpProgress()
end

--@brief    创建一个物品格子
--@param    nIndex，序号
--@param    nItemId，物品id
--@param    nCount，物品数量
function WndSingleCopySettlement:_createCellGoodItem(reward)
    local eItem, tItem = CellGoodItem:createElement()
    --eItem:setTag(nIndex-1)
    eItem:setScale(0.9)
    --tItem:setFromTag(nIndex-1)
    tItem:setItemClickFun(self, self.onClickItem)
    local tData = {
        id = reward.itemId,
        lastNum = reward.itemCnt,
        lastTime = reward.itemCnt,
        isUse = false,
        data = "",
        playerItemId = -1,
        basicInfo = GetItemLocalData(reward.itemId)
    }
    tItem:setCellGoodItem(tData, 4)

    return eItem, tItem
end


function WndSingleCopySettlement:_updatePlayerAni(isWin)
    local tPlayerInfo = CacheCenter:getPlayerInfo()
    local conWin =  GetElement(self.m_root, "conPlayer_WndSingleCopySettlement")
    local conFail = GetElement(self.m_root, "conPlayerFail_WndSingleCopySettlement")
    local con =  isWin and conWin or conFail
    local info = self.m_tData.playerData
    WZLog("------52----------",Serialize(info))
    local aniName = isWin and "win" or "failure"
    local head,body = info.colour[1],info.bodyColour[1]
    local aniPlayer = CreatePlayerFigure(info.sex, info.equip, aniName,nil,nil,nil,nil,nil,false,nil,head,body)

    local aniNode = aniPlayer:getAnimNode()
    local tmpCon = WZUIContainer:create()
    tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
    tmpCon:setUseAbsSize(true)
    tmpCon:setAbsContentSize(GlobalMethod:CCSize(150,150))
    tmpCon:addChild(aniNode)

    con:addChild(tmpCon)
   
end


--@brief	更新经验值进度条
function WndSingleCopySettlement:_updateExpProgress()
    local nMaxExp = GetMaxExpByLevel(self.curLv)
     if self.m_root == nil then
        WZLog(" WndSingleCopySettlement this is no m_root")
        return
    end
    if nMaxExp == nil then
        WZLog(" WndSingleCopySettlement this is no nMaxExp:", self.curLv)
        return
    end

    local prg = GetElement(self.m_root, "prgExp_WndSingleCopySettlement", WZUIProgress)
    prg:setPercentage(math.min(self.curExp*100/nMaxExp, 100))
    
    local txtExp = GetElement(self.m_root, "txteExp_WndSingleCopySettlement", WZUILabelTTF)
    txtExp:setText(self.curExp.."/"..nMaxExp)
end

--@brief	显示升级
function WndSingleCopySettlement:_showUpgrade()
    local imgUpgrade = GetElement(self.m_root, "imgUpgrade_WndSingleCopySettlement")
    imgUpgrade:setVisible(true)

    local txtLv = GetElement(self.m_root, "txteLv_WndSingleCopySettlement", WZUILabelTTF)
    txtLv:setText("Lv"..self.curLv)
end

--@brief	更新任务按钮状态
function WndSingleCopySettlement:_updateTaskButtonState()
    local conTask = GetElement(self.m_root, "conTask_WndSingleCopySettlement")
    if self:_hasCompletedTask() == true then
        conTask:setVisible(true)
    end
end

--@brief    返回按钮设为可见
function WndSingleCopySettlement:_setBackState(bFalse)
    self.b_doBack = true
    local txtCountdown = nil 
    if bFalse ~= nil then
        txtCountdown = GetElement(self.m_root, "txtCountdown2_WndSingleCopySettlement", WZUILabelTTF)
    else
        txtCountdown = GetElement(self.m_root, "txtCountdown_WndSingleCopySettlement", WZUILabelTTF)
    end
    txtCountdown:setVisible(true)
    txtCountdown:setText(LocalStrings.DAILY_COPY_CLICK_CONTINUE)
end

--@brief	更新剩余返回时间
function WndSingleCopySettlement:_updateBackTime()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_WndSingleCopySettlement", WZUILabelTTF)
    local sTime = string.format(LocalStrings.BACK_TIME, self.m_nCountdown)
    txtCountdown:setText(sTime)
end

--@brief  播放三星动画
function WndSingleCopySettlement:_playPerfect1(element)
    WZLog("WndSingleCopySettlement:_playPerfect1")
   local effectFile = {}
   local effectElement = nil
   effectFile = {"ui_jiesuan_fashelihua_01.plist","ui_jiesuan_fashelihua_02.plist","ui_jiesuan_fashelihua_03.plist","ui_jiesuan_fashelihua_04.plist"}
   effectElement = GetElement(self.m_root, "conFashe_WndSingleCopySettlement", WZUIContainer)
   if effectElement == nil then
        WZLog("no  effectElement")
        return
   end
   for i = 1, 4 do 
        local backFire = CCParticleSystemQuad:create("particle/"..effectFile[i])
        backFire:setAutoRemoveOnFinish(true)
        effectElement:addChild(backFire)
   end
   WZLog("_playPerfect finsh")
end


--@brief  播放三星动画
function WndSingleCopySettlement:_playPerfect2(element)
   local effectFile = {}
   local effectElement = nil
   effectFile = {"ui_jiesuan_lihua_01.plist","ui_jiesuan_lihua_02.plist","ui_jiesuan_lihua_03.plist","ui_jiesuan_lihua_04.plist",}
   effectElement = GetElement(self.m_root, "conXialuo_WndSingleCopySettlement", WZUIContainer)
   if effectElement == nil then
        WZLog("no  effectElement")
        return
   end
   for i = 1, 4 do 
        local backFire = CCParticleSystemQuad:create("particle/"..effectFile[i])
        backFire:setAutoRemoveOnFinish(true)
        effectElement:addChild(backFire)

   end
   WZLog("_playPerfect finsh")
end

--@brief	设置控件静态文本
--@note		设置控件静态文本
function WndSingleCopySettlement:_setUIStaticText()
	--描边字
    local tNameMap = {
        {"txtReward_WndSingleCopySettlement", LocalStrings.PASS_REWARD},
        {"txtTask_WndSingleCopySettlement", LocalStrings.COMPLETE_TASK},
        {"txtAgain_WndSingleCopySettlement", LocalStrings.RECHALLENGE},
        {"txtBack_WndSingleCopySettlement", LocalStrings.BACK},
        {"txtShare_WndSingleCopySettlement", LocalStrings.SHARE},
    }
    for i,v in ipairs(tNameMap) do
        local txt = GetElement(self.m_root, v[1], WZUILabelTTF)
        txt:setText(v[2])
    end
end

function WndSingleCopySettlement:_initText()
    --描边字
    local tNameMap = {
        {"txtAgainLose_WndSingleCopySettlement", LocalStrings.RECHALLENGE},
        {"txtBackLose_WndSingleCopySettlement", LocalStrings.BACK},
    }
    for i,v in ipairs(tNameMap) do
        local txt = GetElement(self.m_root, v[1], WZUILabelTTF)
        txt:setText(v[2])
    end
end
-------------------------------------私有方法模块End----------------------------------------

function WndSingleCopySettlement:event(animation, name, eventName)
    WZLog("WndSingleCopySettlement:event-one", name, eventName)
    if name == "event" then
        SoundManager:playEffectSound(SoundDefine.E_S_OVER_STAR)
    end
end


-------------------------------------私有方法模块End----------------------------------------
function WndSingleCopySettlement:_adaptLanguage_pt(  )
    GetElement(self.m_root, "conWinLeft_WndSingleCopySettlement", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.45,0.45))
    
end

-------------------------------------私有方法模块End----------------------------------------