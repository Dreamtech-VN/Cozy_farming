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
    self.n_waitTime = {2, 2, 3, 4}    

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

        GetElement(self.m_root, "winSpine_WndSingleCopySettlement", WZUISpine):play("win",false)
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
    self.m_nCountdown = 10
    WindowManager:getSceneRoot():removeChildByTag(78945, true) 
    --self:_updateBackTime()
    ProtocolProcessorSingleMap:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartChallengeOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_StartChallengeOk", "iivi")

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
    ProtocolProcessorSingleMap:unregProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.SINGLEMAP_StartChallengeOk, "ProtocolProcessorSingleMap:parse_SINGLEMAP_StartChallengeOk", "iivi")
end

--@brief    战斗胜利分享到Facebook点击事件
function WndTowerSettlement:onFBShare( element )
    SetFBShareByPackage(1)
end

-- 返回
function WndTowerSettlement:onBack(element)
    WZLog("WndTowerSettlement:onBack")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:goback()
end

-- 挑战下一关
function WndTowerSettlement:onNext(element)
    WZLog("WndTowerSettlement:onNext")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    CacheCenter.m_nPlayerLevel = CacheCenter:getPlayerInfo().level
    CacheCenter.m_nPlayerExp = CacheCenter:getPlayerInfo().exp
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self.data.levelId + 1, COPYTYPE_TOWER )
    WindowManager:removeWindow(self.m_root, self)
end

--@brief	点击重新挑战按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndTowerSettlement:onAgain(element)
    WZLog("WndTowerSettlement:onAgain = ",self.data.levelId)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    GlobalGame.g_singleCopyData = CopyTable(WBattleGlobal:getCurrent().m_tMakePairOk)
    CacheCenter.m_nPlayerLevel = CacheCenter:getPlayerInfo().level
    CacheCenter.m_nPlayerExp = CacheCenter:getPlayerInfo().exp
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
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
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
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
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

    WindowManager:removeWindow(self.m_root, self)
    if WBattleGlobal:getCurrent():isHeroTowerStage() then  
        SceneCopy:showScene(4, 1)
    else
        SceneCopy:showScene(4)
    end
    --DelayCallFunction(WndTower.showWindow, WndTower, 0)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新胜利界面
function WndTowerSettlement:_updateWinUI()
    local conWin = GetElement(self.m_root, "conWin_WndTowerSettlement",WZUIContainer)
    conWin:setVisible(true)
    self:_updatePlayerFigure()
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
    for i = 1,2 do
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
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) then 
        local bHp = self.data.curHpPer >= self.staticData.pass_hp and true or false
        local bCnt = self.data.curRoundCnt <= self.staticData.pass_round and true or false
        local tCondition = {
            {LocalStrings.SHOP_GOODSSHEGN..self.staticData.pass_hp.."%"..LocalStrings.PRACTICE_BLOOD, self.data.curHpPer.."%", bHp},
            {string.format(LocalStrings.COPY_GOAL3_2,tonumber(self.staticData.pass_round)), self.data.curRoundCnt..LocalStrings.SHOP_CISHU, bCnt}
        }
        local eCell = CreateElement("CellSettlemen_WndTowerSettlement")
        eCell:setTag(nIndex-1)
        eCell:setVisible(true)

        local txtCondition = GetElement(eCell, "txtCondition_WndTowerSettlement", WZUILabelTTF)
        txtCondition:setText(tCondition[nIndex][1])
        local txtResult = GetElement(eCell, "txtResult_WndTowerSettlement", WZUILabelTTF)
        txtResult:setText(tCondition[nIndex][2])

        local imgResult = GetElement(eCell, "imgResult_WndTowerSettlement", WZUIImage)
        if tCondition[nIndex][3] == true then
            imgResult:setFile("ui/common/common_icon_dacheng.png")
        else
            imgResult:setFile("ui/common/common_icon_weida.png")
        end
        return eCell
    elseif WBattleGlobal:getCurrent():isHeroTowerStage() then 
        local tCondition = {
            {LocalStrings.TOWER_HERO_TEXT3, self.data.floorName, self.data.nHp > 0},
            {LocalStrings.TOWER_HERO_TEXT4, math.floor(100 * self.data.nHp/CacheCenter:getPlayerInfo().hp) .. "%", self.data.nHp > 0}
        }
        local eCell = CreateElement("CellSettlemen_WndTowerSettlement")
        eCell:setTag(nIndex-1)
        eCell:setVisible(true)

        local txtCondition = GetElement(eCell, "txtCondition_WndTowerSettlement", WZUILabelTTF)
        txtCondition:setText(tCondition[nIndex][1])
        local txtResult = GetElement(eCell, "txtResult_WndTowerSettlement", WZUILabelTTF)
        txtResult:setText(tCondition[nIndex][2])

        local imgResult = GetElement(eCell, "imgResult_WndTowerSettlement", WZUIImage)
        if tCondition[nIndex][3] == true then
            imgResult:setFile("ui/common/common_icon_dacheng.png")
        else
            imgResult:setFile("ui/common/common_icon_weida.png")
        end
        return eCell
    end
end

--@brief	更新奖励
function WndTowerSettlement:_updateReward()
    local nGold = 0
    local nExp = 0
    -- 金币和经验的奖励
    --local reward = self.staticData.fixed_reward
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

--@brief	更新玩家形象
function WndTowerSettlement:_updatePlayerFigure()
    local conPlayer = GetElement(self.m_root, "conPlayer_WndTowerSettlement")
    local tPlayerInfo = CacheCenter:getPlayerInfo()
    local tEquipment = CacheCenter:getEquipmentList()
    -- if tPlayerInfo.shapeId > 0 then
    --     tEquipment[3] = -tPlayerInfo.shapeId
    -- end
    -- local tEquip = ConvertEquipmentList(tEquipment)
    local head,body = CacheCenter:getHeadAndBodyColor()
    WZLog("WndTowerSettlement:_updatePlayerFigure", head, body, Serialize(tEquipment))
    local aniP = CreatePlayerFigure( tPlayerInfo.sex , tEquipment, "win",nil,nil,nil,nil,nil,nil,nil,head,body)
    local playerAnim = aniP:getAnimNode()

    local tmpCon = WZUIContainer:create()
    tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
    tmpCon:setUseAbsSize(true)
    tmpCon:setAbsContentSize(GlobalMethod:CCSize(150,150))
    tmpCon:addChild(playerAnim)

    conPlayer:addChild(tmpCon)
end

--@brief	更新经验值进度条
function WndTowerSettlement:_updateExpProgress()
    local nMaxExp = GetMaxExpByLevel(self.curLv)
    local prg = GetElement(self.m_root, "prgExp_WndTowerSettlement", WZUIProgress)
    prg:setPercentage(math.min(self.curExp*100/nMaxExp, 100))

    local txtExp = GetElement(self.m_root, "txteExp_WndTowerSettlement", WZUILabelTTF)
    txtExp:setText(self.curExp.."/"..nMaxExp)

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
    self:_updatePlayerFail()
    -- self.failUiData = GetFailCopyUi()
    -- for i =1, #self.failUiData do
    --      GetElement(self.m_root, "imgBtnIcon"..i.."_WndTowerSettlement", WZUIImage):setFile(self.failUiData[i].icon)
    -- end
end

--@brief    更新玩家形象
function WndTowerSettlement:_updatePlayerFail()
    local conPlayer = GetElement(self.m_root, "conPlayerFail_WndTowerSettlement")
    local tPlayerInfo = CacheCenter:getPlayerInfo()
    local tEquipment = CacheCenter:getEquipmentList()
    --local tEquip = ConvertEquipmentList(tEquipment)
    if  tPlayerInfo.shapeId > 0 and tPlayerInfo.showShape == 1 then
        tEquipment[3] = -tPlayerInfo.shapeId
    end

    local head,body = CacheCenter:getHeadAndBodyColor()
    local playerAnim = CreatePlayerFigure( tPlayerInfo.sex , tEquipment, "failure",nil,nil,nil,nil,nil,false,nil,head,body):getAnimNode()
    --playerAnim:setScale(1.2)
    local tmpCon = WZUIContainer:create()
    tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
    tmpCon:setUseAbsSize(true)
    tmpCon:setAbsContentSize(GlobalMethod:CCSize(150,150))
    tmpCon:addChild(playerAnim)

    conPlayer:addChild(tmpCon)
end


function WndTowerSettlement:_updateRightUI()
    WZLog("-----------pata-------------")
    self:_updateConditionList()
    self:_updateReward()
end

--@brief    返回按钮设为可见
function WndTowerSettlement:_setBackState(bFalse)
    self.b_doBack = true
    local txtCountdown = nil
    if bFalse ~= nil then
        txtCountdown = GetElement(self.m_root, "txtCountdown2_WndTowerSettlement", WZUILabelTTF)
    else
        txtCountdown = GetElement(self.m_root, "txtCountdown_WndTowerSettlement", WZUILabelTTF)
    end
    txtCountdown:setVisible(true)
    txtCountdown:setText(LocalStrings.DAILY_COPY_CLICK_CONTINUE)
    --txtCountdown:setText("点击屏幕返回游戏")
end

-- 第二种失败方式
function WndTowerSettlement:_updateLose2UI()
    local conLose = GetElement(self.m_root, "conLose2_WndTowerSettlement",WZUIContainer)
    conLose:setVisible(true)
end

--@brief	更新剩余返回时间
function WndTowerSettlement:_updateBackTime()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_WndTowerSettlement", WZUILabelTTF)
    local sTime = string.format(LocalStrings.BACK_TIME, self.m_nCountdown)
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
    --     {"txtAgain_WndSingleCopySettlement", LocalStrings.RECHALLENGE},
    -- }
    -- for i,v in ipairs(tNameMap) do
    --     local txt = GetElement(self.m_root, v[1], WZUILabelTTF)
    --     txt:setText(v[2])
    -- end
end


--@brief 胜利动画
function WndTowerSettlement:_updateSpine(element,dt)
    if  GetElement(self.m_root, "winSpine_WndSingleCopySettlement", WZUISpine):isCurrentAnimationDone() then
        element:disableSchedule()
        GetElement(self.m_root, "winSpine_WndSingleCopySettlement", WZUISpine):play("win_wait",true)
    end
    
end
-------------------------------------私有方法模块End----------------------------------------
