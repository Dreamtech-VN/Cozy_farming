--WndRelicSettlement.lua
--@brief	WndRelicSettlement的UI模块
--@date		2019/07/17
--@author	yrd
--@note		遗迹副本结算


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRelicSettlement:onEnter(element)
	self.m_root = element

	g_bIsPushSpecifyActivity = false
	SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRelicSettlement:onExit(element)
	self:_unInit()
end

function WndRelicSettlement:_update()
	
end
-- 更新赢的界面
function WndRelicSettlement:_updateWin()
    local conWin = GetElement(self.m_root, "conWin_WndRelicSettlement", WZUIContainer)
    conWin:setVisible(true)

    self:_updateReward()
    self:_updateConditionList()
    self:_updatePlayerAni()
    DelayCallFunction(self.onSchedule, self, 3)
    DelayCallFunction(self.onPlayOver, self, 4)
end

--@brief	更新获取星星的条件列表
function WndRelicSettlement:_updateConditionList()
    local tbconCondition = GetElement(self.m_root, "tbconCondition_WndRelicSettlement", WZUITableContainer)
    tbconCondition:cleanTable()
    
    local goal = {}
    goal[1] = {
        LocalStrings.COPY_GOAL1,
        LocalStrings.COMPLETE,
        1,
    }

    goal[2] = {
        LocalStrings.RELIC_TEXT_13,
        self.m_tData.hurtNum[1],
        1,
    }

    local tGoalList = {goal[1],goal[2]}
    self.cellList = {}
    for i = 1,#tGoalList do
        local eCell = self:_createCellCondition(i, tGoalList[i])
        eCell:setVisible(true)
        tbconCondition:setCellElement(eCell)
        self.cellList[i] = eCell
    end
end

--@brief    创建一个条件单元格
--@param    nIndex, 序号
--@param    tCondition, 条件信息表
--@return   条件单元格
function WndRelicSettlement:_createCellCondition(nIndex, tCondition)
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
    return eCell
end

function WndRelicSettlement:onSchedule(element, dt)
     WZLog("WndRelicSettlement:onSchedule")
    local txtGold = GetElement(self.m_root, "txtGold_WndRelicSettlement", WZUILabelTTF)
    txtGold:enableSchedule("_expAni",0.1)
    SoundManager:playEffectSound(SoundDefine.E_S_SETTLEMENT)
end

function WndRelicSettlement:onPlayOver(element)
    self:_setBackState()
    self.m_root:disableSchedule()
end

--@brief    返回按钮设为可见
function WndRelicSettlement:_setBackState(bFalse)
    self.b_doBack = true
    local txtCountdown = GetElement(self.m_root, "txtCountdown_WndRelicSettlement", WZUILabelTTF)
    txtCountdown:setVisible(true)
    txtCountdown:setText(LocalStrings.DAILY_COPY_CLICK_CONTINUE)
end

--@brief	更新奖励
function WndRelicSettlement:_updateReward()
    -- local con = GetElement(self.m_root, "conItemCon_WndRelicSettlement", WZUIContainer)
    local nGold = 0
    local nExp = 0
    --local nIndex = 1
    local otherR = {}
    for i,v in ipairs(self.m_tData.rewardId) do
        if v == 2 then --金币
            nGold = self.m_tData.rewardCount[i]
        elseif v == 3 then --经验
            nExp = self.m_tData.rewardCount[i]
        else

        end
    end

    local pInfo = self.m_tData.playerData
    if not pInfo then
        pInfo = {}
        pInfo.level = CacheCenter:getPlayerInfo().level
        pInfo.exp = 0
    end
    
    local txtLv = GetElement(self.m_root, "txteLv_WndRelicSettlement", WZUILabelTTF)
    txtLv:setText("Lv"..pInfo.level)

    local txtGold = GetElement(self.m_root, "txtGold_WndRelicSettlement", WZUILabelTTF)
    txtGold:setText(nGold)

    local txtExp = GetElement(self.m_root, "txtExp_WndRelicSettlement", WZUILabelTTF)
    txtExp:setText(nExp)

    self.needAddExp = nExp
    self.leftExp = nExp
    self.curLv =  pInfo.level
    self.curExp = pInfo.exp
    WZLog("----------------init lv and exp ---------------------",self.curLv,self.curExp,self.leftExp)
    self:_updateExpProgress()
end

function WndRelicSettlement:_expAni(element, delta)
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

--@brief	更新经验值进度条
function WndRelicSettlement:_updateExpProgress()
    local nMaxExp, maxExpFormat = GetMaxExpByLevel(self.curLv)
     if self.m_root == nil then
        WZLog(" WndRelicSettlement this is no m_root")
        return
    end
    if nMaxExp == nil then
        WZLog(" WndRelicSettlement this is no nMaxExp:", self.curLv)
        return
    end

    local prg = GetElement(self.m_root, "prgExp_WndRelicSettlement", WZUIProgress)
    prg:setPercentage(math.min(self.curExp*100/nMaxExp, 100))
    
    local txtExp = GetElement(self.m_root, "txteExp_WndRelicSettlement", WZUILabelTTF)
    local curExpStr = GetCurExpStr(self.curExp)
    txtExp:setText(curExpStr.."/"..maxExpFormat)
end

function WndRelicSettlement:_updatePlayerAni()
    local conPlayer =  GetElement(self.m_root, "conPlayer_WndRelicSettlement")
    local aniPlayer = CreateSelfAni()
    local aniNode = aniPlayer:getAnimNode()
    local tmpCon = WZUIContainer:create()
    tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
    tmpCon:setUseAbsSize(true)
    tmpCon:setAbsContentSize(GlobalMethod:CCSize(150,150))
    tmpCon:addChild(aniNode)

    conPlayer:addChild(tmpCon)
    aniPlayer:play("win", true)
end

--@brief    开始点击窗口后的回调
--@param    element:窗口绑定的lua表
--@param    pt:坐标点
function WndRelicSettlement:onTouchEnd(element, pt)
    WZLog("WndRelicSettlement:onTouchEnd")
    if self.b_doBack then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
        self:goback()
    end
end

--@brief	返回
function WndRelicSettlement:goback()
    WZLog("WndRelicSettlement:goback")
    if TeachGroup1.ISFIRSTBATTLE then
        TeachGroup1.ISFIRSTBATTLE = nil
        TeachGroup1:endFirstBattleTeach()
    else
        replaceScene(SceneCity:createElement())
        if IS_BATTLEOVER_JUMP_REMAINS == true then
            WndDigGem:showInterface()
            IS_BATTLEOVER_JUMP_REMAINS = false
        end
        --弹穿上或打开提示窗口
        pushEquipInList()
        g_bIsShowWndDressUp = true
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
