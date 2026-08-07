--WndTowerSettlement.lua
--@brief	WndTowerSettlement的UI模块
--@date		2015/05/07
--@author	xiaoyu_wu
--@note		爬塔副本结算窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTowerSettlement:onEnter(element)
	self.m_root = element
    self:_setUIStaticText()
    self.n_waitTime = {2, 2, 3, 4, 5}    

    local bWin = self:returnResult()
    if bWin then
        -- 通知服务器挑战成功
        -- ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess(self.data.levelId, "", COPYTYPE_TOWER)
        SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN)
        g_bIsPushSpecifyActivity = false
        -- if WBattleGlobal:getCurrent():getMyHero().m_nBoyOrGirl == 0 then
        --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_BOY,false,true)
        -- else
        --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_GIRL,false,true)
        -- end
        if ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1051 
            or ProjConfig.CHANNEL_ID == 1053 then
            GetElement(self.m_root,"btnFBShare_WndTowerSettlement",WZUIButton):setVisible(true)
        end
        g_bIsPushSpecifyActivity = false
        self:_updateWinUI()
        self.m_root:enableSchedule("scheduleCountdown", 0.01)

        GetElement(self.m_root, "winSpine_WndTowerSettlement", WZUISpine):play("win",false)
        GetElement(self.m_root,"conWinLeft_WndTowerSettlement",WZUIContainer):enableSchedule("_updateSpine")
    else
        g_bIsPushSpecifyActivity = true
        self.n_waitTime[1] = -100
        self.n_waitTime[2] = -100
        SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_LOSE)
        self:_updateLoseUI()
    end
    self:_updateRightUI()
    ChangeChatChannel(Chat_Channel_Tower_Copy_Settlement)
    self.m_nCountdown = 5
    WindowManager:getSceneRoot():removeChildByTag(78945, true) 
    --self:_updateBackTime()
    ProtocolProcessorSingleMap:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartChallengeOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_StartChallengeOk", "iivi")
    --@brief    获取爬塔副本层奖励（SINGLEMAP_GetTowerRewardOk = 26）
    ProtocolProcessorSingleMap:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerRewardOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_GetTowerRewardOk", "")
    if AutoRunBattleConst.AUTO_RUN_BATTLE then
        self:goback()
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTowerSettlement:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
    if not g_TOWER_TAG then
        ProtocolProcessorSingleMap:unregProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartChallengeOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_StartChallengeOk", "iivi")
        ProtocolProcessorSingleMap:unregProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_GetTowerRewardOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_GetTowerRewardOk", "")
    end
end

--@brief    战斗胜利分享到Facebook点击事件
function WndTowerSettlement:onFBShare( element )
    SetFBShareByPackage(1)
end

-- 返回
function WndTowerSettlement:onBack(element)
    WZLog("WndTowerSettlement:onBack")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    g_TOWER_TAG = false
    self:goback()
end

--@brief 点击下一关
function WndTowerSettlement:onClickNext(element)
    -- body
    self.btnTime = nil
    self.btnTxt:disableSchedule()
    local tData = CacheCenter:getTowerCopyData()
    WZLog("点击下一关",Serialize(tData))
    ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerReward()    
end

-- 挑战下一关
function WndTowerSettlement:onNext(element)
    WZLog("WndTowerSettlement:onNext",self.data.levelId+1,COPYTYPE_TOWER)

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    CacheCenter.m_nPlayerLevel = CacheCenter:getPlayerInfo().level
    CacheCenter.m_nPlayerExp = CacheCenter:getPlayerInfo().exp
    g_TOWER_TAG = true

    -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
    if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
        ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
    end
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self.data.levelId + 1, COPYTYPE_TOWER )
end

--@brief	点击重新挑战按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndTowerSettlement:onAgain(element)
    WZLog("WndTowerSettlement:onAgain = ",self.data.levelId)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    GlobalGame.g_singleCopyData = CopyTable(WBattleGlobal:getCurrent().m_tMakePairOk)
    CacheCenter.m_nPlayerLevel = CacheCenter:getPlayerInfo().level
    CacheCenter.m_nPlayerExp = CacheCenter:getPlayerInfo().exp
    
    -- 处理战斗时默认皮肤大招id获取不到的问题,做一层保险
    if GlobalGame.g_saveBigSkillType == 2 and (CacheCenter.m_nDefaultShapeBigSkill == nil or CacheCenter.m_nDefaultShapeBigSkill <= 0) then
        ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(2)
    end
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self.data.levelId, COPYTYPE_TOWER)
end

--@brief	开始点击窗口后的回调
--@param	element:窗口绑定的lua表
--@param    pt:坐标点
function WndTowerSettlement:onTouchBegan(element, pt)
    WndItemInfo:onCloseClick()
end

--@brief    开始点击窗口后的回调
--@param    element:窗口绑定的lua表
--@param    pt:坐标点
function WndTowerSettlement:onTouchEnd(element, pt)
    WZLog("WndTowerSettlement:onTouchEnd")
   -- WndItemInfo:onCloseClick()
    if self.b_doBack then
        self:goback()
    end
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndTowerSettlement:onClickItem(tItem, nTag, tData)
    WZLog("WndTowerSettlement:onClickItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false, nil, true)
end

--@brief	倒计时定时器
--@param	element:定时器绑定的UI节点引用
--@param    delta:时间间隔
function WndTowerSettlement:scheduleCountdown(element, delta)
    if self.m_root == nil then
        element:disableSchedule()
        return
    end
    for i = 1, #self.n_waitTime do
        self.n_waitTime[i] = self.n_waitTime[i] - delta
    end
    --发射特效
    if self.n_waitTime[1] <= 0 and self.n_waitTime[1] > -99 then
        self.n_waitTime[1] = -99
        self:_playPerfect(1)
    end
    --落下特效
    if self.n_waitTime[2] <= 0 and self.n_waitTime[2] > -99 then
        self.n_waitTime[2] = -99
        self:_playPerfect(2)
    end
    --奖励框动画
    if self.n_waitTime[3] <= 0 and self.n_waitTime[3] > -99 then
        self.n_waitTime[3] = -99
        self:onSchedule()
    end
    --可以按游戏
    if self.n_waitTime[4] <= 0 then
        self:_setBackState()
        self.m_root:disableSchedule()
    end
    -- self.m_nCountdown = math.max(self.m_nCountdown - delta, 0)
    -- --self:_updateBackTime()
    if self.m_nCountdown <= 0 then
        self.m_root:disableSchedule()
        --self:goback()
    end
end

--@brief	更新经验条定时器
--@param	element:定时器绑定的节点
--@param    delta:时间
function WndTowerSettlement:_expAni(element, delta)
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
        end
    end
    self:_updateExpProgress()
    WZLog("----------------expAni-------------------",exp,addExp,self.leftExp,self.curExp,self.curLv,maxExp)
end


--@brief	返回
function WndTowerSettlement:goback()
    WZLog("WndTowerSettlement:goback")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local mapId = nil
    if WBattleGlobal:getCurrent():isHostChallengeStage() then
        mapId = self.data.mapId
    end
    WindowManager:removeWindow(self.m_root, self)
    if WBattleGlobal:getCurrent():isHeroTowerStage() then  
        SceneCopy:showScene(5)
    elseif WBattleGlobal:getCurrent():isHostChallengeStage() then 
        -- SceneCopy:showScene(1, nil, mapId)
        SceneCopy:showScene(1, nil, mapId, false, nil, nil, nil, 2)

        --弹穿上或打开提示窗口
        pushEquipInList()
        g_bIsShowWndDressUp = true

        ProtocolProcessorSceneBattle:send_BOSSMAPROOM_BackToRoom(WBattleGlobal:getCurrent():getMyRoomId(), WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
    else
        SceneCopy:showScene(4)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新胜利界面
function WndTowerSettlement:_updateWinUI()
    local conWin = GetElement(self.m_root, "conWin_WndTowerSettlement",WZUIContainer)
    conWin:setVisible(true)
    self:_updatePlayerAni(true)
    self:_showHeroTowerFloorReward()

    --岛主界面
    local conRight1 = GetElement(self.m_root,"conRight1_WndTowerSettlement",WZUIContainer)
    local conRight2 = GetElement(self.m_root,"conRight2_WndTowerSettlement",WZUIContainer)
    if WBattleGlobal:getCurrent():isHostChallengeStage() then
        conRight1:setVisible(false)
        conRight2:setVisible(true)
        self:_showIslandReward()
    end
end

--@brief  播放三星动画
function WndTowerSettlement:_playPerfect(tag)
   local effectFile = {}
   local effectElement = nil
   if tag == 1 then
        effectFile = {"ui_jiesuan_fashelihua_01.plist","ui_jiesuan_fashelihua_02.plist","ui_jiesuan_fashelihua_03.plist","ui_jiesuan_fashelihua_04.plist"}
        effectElement = GetElement(self.m_root, "conFashe_WndTowerSettlement", WZUIContainer)
   elseif tag == 2 then
        effectFile = {"ui_jiesuan_lihua_01.plist","ui_jiesuan_lihua_02.plist","ui_jiesuan_lihua_03.plist","ui_jiesuan_lihua_04.plist",}
        effectElement = GetElement(self.m_root, "conXialuo_WndTowerSettlement", WZUIContainer)
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

--@brief	更新获取星星的条件列表
function WndTowerSettlement:_updateConditionList()
    local tbconCondition = GetElement(self.m_root, "tbconCondition_WndTowerSettlement", WZUITableContainer)
    tbconCondition:cleanTable()
    self.cellList = {}
    local conditionCount = 2
    if WBattleGlobal:getCurrent():isHostChallengeStage() then 
        conditionCount = 1
    elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) then 
        conditionCount = 3
    end
    for i = 1, conditionCount do
        local eCell = self:_createCellCondition(i)
        eCell:setVisible(true)
        tbconCondition:setCellElement(eCell)
        self.cellList[i] = eCell
    end
end

function WndTowerSettlement:onSchedule(element, dt)
    WZLog("----------------7878------------------------")
   local txtGold = GetElement(self.m_root, "txtGold_WndTowerSettlement", WZUILabelTTF)
    txtGold:enableSchedule("_expAni",0.1)
    SoundManager:playEffectSound(SoundDefine.E_S_SETTLEMENT)
end

local COMPLETE_COLOR = GlobalMethod:ccc3(255,227,116)
local UNCOMPLETE_COLOR = GlobalMethod:ccc3(255,121,31)
--@brief    创建一个胜利条件单元格
function WndTowerSettlement:_createCellCondition(nIndex)
    local tCondition = {}
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) then 
        local conditionState, conditionValue = self:getAllConditionState()
        local allCondition = self:getAllContition()
        local bHp = conditionState[1]
        local bCnt = conditionState[2]
        tCondition = {
            {allCondition[1], conditionValue[1], conditionState[1]},
            {allCondition[2], conditionValue[2], conditionState[2]},
            {allCondition[3], conditionValue[3], conditionState[3]}
        }
    elseif WBattleGlobal:getCurrent():isHeroTowerStage() then 
        local buffData = GDatatab_herotower_map["id_" .. g_myHeroTowerBuffId]
        local maxHp = CacheCenter:getPlayerInfo().hp
        local basicHp = CacheCenter:getPlayerInfo().hp
        if buffData then 
            for i = 1, #buffData.buff2 do
                if buffData.buff2[i][1] == 1 then 
                    maxHp = maxHp + math.floor((basicHp * buffData.buff2[i][2])/100)
                end
            end
        end
        tCondition = {
            {LocalStrings.TOWER_HERO_TEXT3, self.data.floorName, self.data.nHp > 0},
            {LocalStrings.TOWER_HERO_TEXT4, math.floor(100 * self.data.nHp/maxHp) .. "%", self.data.nHp > 0}
        }
    elseif WBattleGlobal:getCurrent():isHostChallengeStage() then 
        tCondition = {
            {LocalStrings.SINGLECOPY_TEXT20, "", self.data.nHp > 0},
        }
    end
    local eCell = CreateElement("CellSettlemen_WndTowerSettlement")
    eCell:setTag(nIndex-1)
    eCell:setVisible(true)

    local str = ""
    if tCondition[nIndex][3] == true then
        str = "ui/common/common_icon_dacheng.png"
    else
        str = "ui/common/common_icon_weida.png"
    end
    local txtResultFree = GetElement(eCell,"txtResultFree",WZUIFreeTextBox)
    txtResultFree:setShowText(string.format([[<T C="255,236,193" S="20" P="1">%s</T><T C="233,166,62" S="20" P="1">%s</T><I Z="0.9">%s</I>]],tCondition[nIndex][1],tCondition[nIndex][2],str))
    return eCell
end

--@brief	更新奖励
function WndTowerSettlement:_updateReward()
    local nGold = 0
    local nExp = 0
    -- 金币和经验的奖励
    if self.data.rewardId and self.data.rewardCount then
        local rewardId = self.data.rewardId
        local rewardCnt = self.data.rewardCount
        WZLog("-----------------rewardId-----------------",rewardId)
        WZLog("-----------------rewardCnt-----------------",rewardCnt)
        for i = 1, #rewardId do
            if rewardId[i] == 2 then
                nGold = rewardCnt[i]
                WZLog("----------tower gold-----------",nGold)
            elseif rewardId[i] == 3 then
                local bWin = self:returnResult()
                if bWin then
                    nExp = rewardCnt[i]
                    WZLog("----------tower exp-----------",nExp)
                end
            end
        end
    end

    local txtGold = GetElement(self.m_root, "txtGold_WndTowerSettlement", WZUILabelTTF)
    txtGold:setText(nGold)

    local txtExp = GetElement(self.m_root, "txtExp_WndTowerSettlement", WZUILabelTTF)
    txtExp:setText(nExp)

    self.needAddExp = nExp
    local info = CacheCenter:getPlayerInfo()
    self.curLv =  info.level
    if info.exp >= nExp then
        self.curExp = info.exp - nExp
    else
        self.curExp = info.exp + GetMaxExpByLevel(self.curLv-1) - nExp
        self.curLv = self.curLv -1
    end
    WZLog("WndTowerSettlement:_updateReward:", self.curLv, self.curExp)
    self.leftExp = nExp
    self:_updateExpProgress()
end

--@brief    更新玩家形象
function WndTowerSettlement:_updatePlayerAni(isWin)
    if self.typeId == 3 then 
        self:_updatePlayerFigure(isWin)
    else
        local tPlayerInfo = CacheCenter:getPlayerInfo()
        local tEquipment = CacheCenter:getEquipmentList()
        if not isWin then --看132版本日志胜利屏蔽了这段,失败没屏蔽
            if tPlayerInfo.shapeId > 0 then
                tEquipment[3] = -tPlayerInfo.shapeId
            end
        end
        -- local tEquip = ConvertEquipmentList(tEquipment)
        local conWin =  GetElement(self.m_root, "conPlayer_WndTowerSettlement")
        local conFail = GetElement(self.m_root, "conPlayerFail_WndTowerSettlement")
        local con =  isWin and conWin or conFail
        local aniName = isWin and "win" or "failure"
        local head,body = CacheCenter:getHeadAndBodyColor()
        local aniP = CreatePlayerFigure( tPlayerInfo.sex , tEquipment, aniName,nil,nil,nil,nil,nil,false,nil,head,body)

        local playerAnim = aniP:getAnimNode()
        local tmpCon = WZUIContainer:create()
        tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
        tmpCon:setUseAbsSize(true)
        tmpCon:setAbsContentSize(GlobalMethod:CCSize(150,150))
        tmpCon:addChild(playerAnim)

        con:addChild(tmpCon)
    end
end

--@brief	更新经验值进度条
function WndTowerSettlement:_updateExpProgress()
    local nMaxExp, maxExpFormat = GetMaxExpByLevel(self.curLv)
    local prg = GetElement(self.m_root, "prgExp_WndTowerSettlement", WZUIProgress)
    prg:setPercentage(math.min(self.curExp*100/nMaxExp, 100))

    local txtExp = GetElement(self.m_root, "txteExp_WndTowerSettlement", WZUILabelTTF)
    local curExpStr = GetCurExpStr(self.curExp)
    txtExp:setText(curExpStr.."/"..maxExpFormat)

    local txtLv = GetElement(self.m_root, "txteLv_WndTowerSettlement", WZUILabelTTF)
    txtLv:setText("Lv"..self.curLv)
end

--@brief	显示升级
function WndTowerSettlement:_showUpgrade()
    local imgUpgrade = GetElement(self.m_root, "imgUpgrade_WndTowerSettlement")
    imgUpgrade:setVisible(true)
end

function WndTowerSettlement:onFail(element)
    WZLog("-------------WndTowerSettlement--onFail--------------")
    local tag = element:getTag()
    local ui = self.failUiData[tag].Link
    self:goback()
    DelayCallFunction(function()
        JumpByUIId(ui)
    end, nil, 0)
end

-- 强化装备
function WndTowerSettlement:onEquip()
    WZLog("------------------click equip---------------")
end

-- 完成任务
function WndTowerSettlement:onTask()
    WZLog("------------------click task---------------")
end

-- 装备升星
function WndTowerSettlement:onStar()
    WZLog("------------------click star---------------")
end

-- 充值
function WndTowerSettlement:onMoney()
    WZLog("------------------click money---------------")
end

function WndTowerSettlement:_updateLoseUI()
    local conLose = GetElement(self.m_root, "conLose_WndTowerSettlement",WZUIContainer)
    conLose:setVisible(true)
    local conLose2 = GetElement(self.m_root, "conReward_WndTowerSettlement",WZUIContainer)
    conLose2:setVisible(false)
     local fielPath = "ui/copy_settlement/common_pic_sb.png"
    GetElement(self.m_root, "imgLeftBg_WndTowerSettlement", WZUIImage):setFile(fielPath)
    local rightElement = GetElement(self.m_root, "imgRightBg_WndTowerSettlement", WZUIImage)
    rightElement:setFile(fielPath)
    rightElement:setFlipX(true)
    self:_setBackState(true)
    self:_updatePlayerAni(false)
    -- self.failUiData = GetFailCopyUi()
    -- for i =1, #self.failUiData do
    --      GetElement(self.m_root, "imgBtnIcon"..i.."_WndTowerSettlement", WZUIImage):setFile(self.failUiData[i].icon)
    -- end
end


function WndTowerSettlement:_updateRightUI()
    WZLog("-----------pata-------------")
    self:_updateConditionList()
    self:_updateReward()
end

--@brief    返回按钮设为可见
function WndTowerSettlement:_setBackState(bFalse)
    local txtCountdown = nil
    if bFalse ~= nil then
        txtCountdown = GetElement(self.m_root, "txtCountdown2_WndTowerSettlement", WZUILabelTTF)
    else
        txtCountdown = GetElement(self.m_root, "txtCountdown_WndTowerSettlement", WZUILabelTTF)
    end
    local bWin = self:returnResult()
    
    txtCountdown:setText(LocalStrings.DAILY_COPY_CLICK_CONTINUE)
    
    if bWin and self.typeId == 1 then
        txtCountdown:setVisible(false)
        GetElement(self.m_root, "btnAll_WndTowerSettlement",WZUIButton):setVisible(false) 
        GetElement(self.m_root, "btnBack",WZUIButton):setVisible(true)
        GetElement(self.m_root, "btnNext",WZUIButton):setVisible(true)
        GetElement(self.m_root, "txtNext_WndTowerSettlement", WZUILabelTTF):setText(LocalStrings.NEXT_TIME1)
        self:updateBtnTxt()
        self.b_doBack = false
    else 
        txtCountdown:setVisible(true)
        self.b_doBack = true
    end
    --txtCountdown:setText("点击屏幕返回游戏")
end

--爬塔副本结算页面5秒后自动进入下一关
function WndTowerSettlement:updateBtnTxt()
    -- body
    self.btnTxt = GetElement(self.m_root, "txtNext_WndTowerSettlement", WZUILabelTTF)
    -- btnTxt:setText(string.format(LocalStrings.))
    self.btnTime = 5
    self.btnTxt:enableSchedule("_btnTime",1)
end

function WndTowerSettlement:_btnTime()
    -- body
    self.btnTime = self.btnTime - 1
    self.btnTxt:setText(string.format(LocalStrings.NEXT_TIME,self.btnTime))
    if self.btnTime == 0 then
        self.btnTime = nil
        self.btnTxt:disableSchedule()
        ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerReward()
    end
end

-- 第二种失败方式
function WndTowerSettlement:_updateLose2UI()
    local conLose = GetElement(self.m_root, "conLose2_WndTowerSettlement",WZUIContainer)
    conLose:setVisible(true)
end

--@brief	更新剩余返回时间
function WndTowerSettlement:_updateBackTime()
    local txtCountdown = GetElement(self.m_root, "txtNext_WndTowerSettlement", WZUILabelTTF)
    local sTime = string.format(LocalStrings.NEXT_TIME, self.m_nCountdown)
    txtCountdown:setText(sTime)
end

--@brief	设置控件静态文本
--@note		设置控件静态文本
function WndTowerSettlement:_setUIStaticText()
	--描边字
    -- local tNameMap = {
    --     {"txtBack_WndTowerSettlement", LocalStrings.BACK},
    --     {"txtNext_WndTowerSettlement", LocalStrings.NEXT_FLOOR},
    --     {"txtPassAll_WndTowerSettlement", LocalStrings.PASS_ALL_TOWER_TIPS},
    --     {"txtReward_WndTowerSettlement", LocalStrings.PASS_REWARD},
    --     {"txtBackLose_WndTowerSettlement", LocalStrings.BACK},
    --     {"txtAgain_WndTowerSettlement", LocalStrings.RECHALLENGE},
    -- }
    -- for i,v in ipairs(tNameMap) do
    --     local txt = GetElement(self.m_root, v[1], WZUILabelTTF)
    --     txt:setText(v[2])
    -- end
end


--@brief 胜利动画
function WndTowerSettlement:_updateSpine(element,dt)
    if  GetElement(self.m_root, "winSpine_WndTowerSettlement", WZUISpine):isCurrentAnimationDone() then
        element:disableSchedule()
        GetElement(self.m_root, "winSpine_WndTowerSettlement", WZUISpine):play("win_wait",true)
    end
end

--@brief    显示英雄塔通关奖励
function WndTowerSettlement:_showHeroTowerFloorReward()
    -- body
    if WBattleGlobal:getCurrent():isHeroTowerStage() then
        GetElement(self.m_root, "conFloorReward_WndTowerSettlement", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conReward_WndTowerSettlement", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.65))
        local tableFloorReward = GetElement(self.m_root, "tableFloorReward_WndTowerSettlement", WZUITableContainer)
        tableFloorReward:cleanTable()

        for i = 1, #self.data.floorReward do
            local element, tNewObj = CellGoodItem:createElement()
            if element and tNewObj then 
                element:setTag(i - 1)
                tNewObj:setCellGoodLocalId(self.data.floorReward[i][1], self.data.floorReward[i][2], 4)
                tNewObj:setItemClickFun(self, self.onClickItem)
                element:setScale(0.6)

                tableFloorReward:setCellElement(element)
            end
        end
    end
end

--@brief    显示岛主挑战通关奖励
function WndTowerSettlement:_showIslandReward()
    if WBattleGlobal:getCurrent():isHostChallengeStage() then
        local conR2Reward1 = GetElement(self.m_root, "conR2Reward1_WndTowerSettlement", WZUIContainer)
        if self.data.flopRebate == 0 then
            conR2Reward1:setVisible(false)
        elseif self.data.flopRebate == 1 then
            conR2Reward1:setVisible(true)
        end

        local tcR2Reward1 = GetElement(self.m_root, "tcR2Reward1_WndTowerSettlement", WZUITableContainer)
        tcR2Reward1:cleanTable()
        local tCopyInfo = GDatatab_single_map["id_" .. WBattleGlobal:getCurrent().m_tMakePairOk.mapId]
        local tDropData = nil
        if WBattleGlobal:getCurrent().m_tMakePairOk.bIsRoomOwner == true then
            tDropData = tCopyInfo.dwar_boss
            GetElement(self.m_root,"txtR2Reward1_WndTowerSettlement",WZUILabelTTF):setTextKey("SINGLECOPY_TEXT21")
        else
            tDropData = tCopyInfo.dwar_assist
            GetElement(self.m_root,"txtR2Reward1_WndTowerSettlement",WZUILabelTTF):setTextKey("ISLAND_OWNER_TEXT4")
        end
        local level = CacheCenter:getPlayerInfo().level
        local nIndex = 1
        for i = 1, #tDropData do
--            if tDropData[i][2] ~= 161021 or level >= 100 then 
                local element, tNewObj = self:_createCellGoodItem(nIndex, tDropData[i], true)
                tNewObj:setItemClickFun(self, self.onClickItem)
                tNewObj:setItemCount(tDropData[i][3] .. "/" .. tDropData[i][1] .. "h")
                tcR2Reward1:setCellElement(element)

                nIndex = nIndex + 1
--            end
        end

        local conTR2Reward2 = GetElement(self.m_root, "conTR2Reward2_WndTowerSettlement", WZUIContainer)
        removeShowPanelNullTip(conTR2Reward2)
        local tcR2Reward2 = GetElement(self.m_root, "tcR2Reward2_WndTowerSettlement", WZUITableContainer)
        tcR2Reward2:cleanTable()
        if #self.data.rewardId == 0 then
            ShowPanelNullTip(conTR2Reward2,LocalStrings.ISLAND_OWNER_TEXT22)
            return
        end
        nIndex = 1
        for i=1,#self.data.rewardId do
--            if self.data.rewardId[i] ~= 161021 or level >= 100 then 
                local element, tNewObj = CellGoodItem:createElement()
                if element and tNewObj then 
                    element:setTag(nIndex - 1)
                    tNewObj:setCellGoodLocalId(self.data.rewardId[i], self.data.rewardCount[i], 4)
                    tNewObj:setItemClickFun(self, self.onClickItem)

                    tcR2Reward2:setCellElement(element)

                    nIndex = nIndex + 1
                end
--            end
        end
    end
end


--@brief    创建一个物品格子
--@param    nIndex, 序号
--@param    nItemId, 物品id
--@param    bHostReward : 岛主奖励
--isUse 透明框
function WndTowerSettlement:_createCellGoodItem(nIndex, nItemId, bHostReward, isUse)
    isUse = isUse or nil
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setTag(nIndex-1)
    --eItem:setScale(1)
    tItem:setFromTag(nIndex-1)
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

-------------------------------------私有方法模块End----------------------------------------
