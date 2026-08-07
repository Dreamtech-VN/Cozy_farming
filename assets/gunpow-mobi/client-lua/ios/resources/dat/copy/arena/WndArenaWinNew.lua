--WndArenaWinNew.lua
--@brief	WndArenaWinNew的UI模块
--@date		2015-11-19
--@author	binshao
--@note		竞技场胜利结算


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndArenaWinNew:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    ProtocolProcessorBattleSettlement:regAll()
    if self.m_tData.isWin then
         SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN)
        -- if WBattleGlobal:getCurrent():getMyHero().m_nBoyOrGirl == 0 then
        --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_BOY,false,true)
        -- else
        --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_GIRL,false,true)
        -- end
    else
        SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_LOSE)
    end

    WindowManager:getSceneRoot():removeChildByTag(78945, true)

    self:_initUI()
    self:_initStep()
    self.m_root:enableSchedule("onSchedule")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndArenaWinNew:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
    ProtocolProcessorBattleSettlement:unregAll()
end

--@brief	倒计时定时器
--@param	element:定时器绑定的UI节点引用
--@param    delta:时间间隔
function WndArenaWinNew:scheduleCountdown(element, delta)
    self.m_nCountdown = math.max(self.m_nCountdown - 1, 0)
    if self.m_nCountdown <= 0 then
        self.m_root:disableSchedule()
        self:goback()
    end
end

-- 重播录像
function WndArenaWinNew:onAgainVideo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    BattleMsgReplayGameRecord:replayRecord()
end

-- 退出录像
function WndArenaWinNew:onExitVideo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    SceneBattle:leftBattle()
end

--@brief	返回
function WndArenaWinNew:goback()
    WZLog("WndArenaWinNew:goback")
    if not self.m_root then return end
    local battleMode = WBattleGlobal:getCurrent().m_tMakePairOk.battleMode
    local battleChannel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    WZLog("-----cur channel-----------------",battleChannel)
    
    --混战
    if battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD then
        if self.isVideo then
            local con = GetElement(self.m_root, "conVideo_WndArenaWinNew", WZUIContainer)
            con:setVisible(true)
        else
            if battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_QS then
                SceneAthMelee:showInterface(2)
            else
                SceneAthMelee:showInterface(1)
            end
        end
    else
        if self.isVideo then
            local con = GetElement(self.m_root, "conVideo_WndArenaWinNew", WZUIContainer)
            con:setVisible(true)
        else
            ProtocolProcessorBattleSettlement:send_BATTLE_BackToRoom(WBattleGlobal:getCurrent():getMyRoomId() )
        end
    end
end



--@brief 排位赛结算信息
function WndArenaWinNew:onBtnRankResultClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:_doContinueClick()
end

--@brief 普通竞技结算信息
function WndArenaWinNew:onBtnArenaResultClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:_doContinueClick()
end


--@brief 胜利动画
function WndArenaWinNew:onBtnActionResultClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:_doContinueClick()
end

--@brief 对战详细信息
function WndArenaWinNew:onBtnFightResultClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:_doContinueClick()
end

function WndArenaWinNew:onSchedule(element,dt)
    --刷新spine动画
    if self.m_bNeedCheck then
        self:_checkSpineVisible()
    end

    --延迟
    if self.m_nDelayTime then
        self.m_nDelayTime = self.m_nDelayTime - dt
        if self.m_nDelayTime < 0 then
            self.m_nDelayTime = nil
        else
            return
        end
    end

    --按钮倒计时
    if self.m_nContinueBtnDelay and self.m_nContinueBtnDelay > 0 then
        self.m_nContinueBtnDelay = self.m_nContinueBtnDelay - dt
        if self.m_nContinueBtnDelay < 0 then
            self.m_nContinueBtnDelay = nil
        end
    end
    
   
    --步骤执行
    if #self.m_tStepList > 0 then
        local res = self.m_tStepList[1][1](self,self.m_tStepList[1][2],self.m_tStepList[1][3],self.m_tStepList[1][4])
        if res == true or res == nil then
            table.remove(self.m_tStepList,1)
        end
        return 
    end
end

-- -----------------------------------公有方法模块End----------------------------------------


-- -----------------------------------私有方法模块Begin--------------------------------------
--@brief 初始化ui
function WndArenaWinNew:_initUI()
    self.m_bgBar = GetElement(self.m_root, "bgBar_WndArenaWinNew", WZUI9Image)

    self.m_conRankResult = GetElement(self.m_root, "conRankResult_WndArenaWinNew", WZUIContainer)
    self.m_conArenaResult = GetElement(self.m_root, "conArenaResult_WndArenaWinNew", WZUIContainer)
    self.m_conFightResult = GetElement(self.m_root, "conFightResult_WndArenaWinNew", WZUIContainer)

    self.m_conRankResult:setVisible(false)
    self.m_conArenaResult:setVisible(false)
    
    self.m_conFightResult:setVisible(false)

    GetElement(self.m_root, "conSpineTileWin_WndArenaWinNew", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conSpineTileLose_WndArenaWinNew", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conBgWin_WndArenaWinNew", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conBgLose_WndArenaWinNew", WZUIContainer):setVisible(false)
    
    GetElement(self.m_root,"conActionResult_WndArenaWinNew",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"conActionResultBg_WndArenaWinNew",WZUIContainer):setVisible(false)
end

--@brief 配置动画步骤
function WndArenaWinNew:_initStep()
    self.m_tStepList = {}
   

    local battleChannel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle

    table.insert(self.m_tStepList,{self._waitForBgAction})

    --第2阶段
    table.insert(self.m_tStepList,{self._showActoinResult})
    table.insert(self.m_tStepList,{self._waitForContinueClick})

    table.insert(self.m_tStepList,{self._showBgInfo})
    -- table.insert(self.m_tStepList,{self._waitForBgAction2})

   

    --第四阶段
    table.insert(self.m_tStepList,{self._showFightResultInfo})
    table.insert(self.m_tStepList,{self._waitForContinueClick})

      --第三阶段
    if battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
        --排位赛
        table.insert(self.m_tStepList,{self._showRankResultInfo})
        table.insert(self.m_tStepList,{self._updateRankResultAction})
        table.insert(self.m_tStepList,{self._updateRankResultIconEnd})
        table.insert(self.m_tStepList,{self._updateRankResultIconAction})
        table.insert(self.m_tStepList,{self._showRankResultBtn})
        table.insert(self.m_tStepList,{self._waitForContinueClick})
    end
  --练习赛不加
    if battleChannel ~= GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then
        --通用结算
        table.insert(self.m_tStepList,{self._showArenaResultInfo})
        table.insert(self.m_tStepList,{self._updateArenaResultAction})
        table.insert(self.m_tStepList,{self._showArenaResultBtn})
        table.insert(self.m_tStepList,{self._waitForContinueClick})
    end
   
    table.insert(self.m_tStepList,{self._allActionDone})
end

--@brief等待背景动画(背景动画上升到顶部)
function WndArenaWinNew:_waitForBgAction()
   self.m_nDelayTime = 3.5
end

--@brief等待背景动画(结算背景渐显)
function WndArenaWinNew:_waitForBgAction2()
   self.m_nDelayTime = 0.5
end

--@brief 等待黑屏
function WndArenaWinNew:spineActionWaitDone()
     if self.m_tData.isWin then
        GetElement(self.m_root, "conSpineTileWin_WndArenaWinNew", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conSpineTileLose_WndArenaWinNew", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "spineTileWin_WndArenaWinNew", WZUISpine):play("win",false)
    else
        GetElement(self.m_root, "conSpineTileWin_WndArenaWinNew", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conSpineTileLose_WndArenaWinNew", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "spineTileLose_WndArenaWinNew", WZUISpine):play("fail",false)
    end
end

--@brief 显示结算结果(带渐显)
function WndArenaWinNew:_showBgInfo()
    if self.m_tData.isWin then
        GetElement(self.m_root, "conBgWin_WndArenaWinNew", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conBgLose_WndArenaWinNew", WZUIContainer):setVisible(false)
    else
        GetElement(self.m_root, "conBgWin_WndArenaWinNew", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conBgLose_WndArenaWinNew", WZUIContainer):setVisible(true)
    end
end

--@brief 继续按钮等待
function WndArenaWinNew:_waitForContinueClick()
    if self.m_sContinueBtnName and self.m_nContinueBtnDelay and self.m_nContinueBtnDelay > 0 then
        local btn = GetElement(self.m_root,self.m_sContinueBtnName,WZUITemplate)
        local btnLab = GetElement(self.m_root,self.m_sContinueBtnLabName,WZUILabelTTF)
        local txt = math.ceil(self.m_nContinueBtnDelay).."S ".. LocalStrings.CONTINUE
        btnLab:setText(txt)
        if ProjConfig.LANGUAGE == "pt" then
            btnLab:setScale(0.8)
        end
        return false
    end
    self:_doContinueClick()
    return true
end

--@brief 继续按钮点击
function WndArenaWinNew:_doContinueClick()
    self.m_nContinueBtnDelay = nil
    self.m_sContinueBtnName = nil
    self.m_sContinueBtnLabName = nil
    if self.m_tCurContainer then
        self.m_tCurContainer:setVisible(false)
        self.m_tCurContainer = nil
    end
    if self.m_tSecContainer then
        self.m_tSecContainer:setVisible(false)
        self.m_tSecContainer = nil
    end
end


--@brief 排位赛结算
function WndArenaWinNew:_showRankResultInfo()
    self.m_conRankResult:setVisible(true)
    GetElement(self.m_root,"btnRankResult_WndArenaWinNew",WZUIButton):setVisible(false)
    GetElement(self.m_root,"btnRankResultLab_WndArenaWinNew",WZUILabelTTF):setVisible(false)

    --玩家结算信息
    local fightInfo = self.m_tTeammate[1]
    local rankLv = self.m_tData.preRankLevel
    local killIndex = fightInfo.killCount < 3 and fightInfo.killCount or 3
    
    local template = self:getRankTemplateByLv(rankLv)
    --获得成就
    local rankAddlist = {}
    local winMax = tonumber(CacheCenter:getGameParam()["maxContinuousWinTimesConfigLimit"]) or 10
    if killIndex > 0 then
        if killIndex == 1 and fightInfo.isFirstSkill then
            table.insert(rankAddlist,{name = LocalStrings.BATTLE_FIRST_KILL,score = template.fk_integral})
        else
            table.insert(rankAddlist,{name = string.format(LocalStrings.BATTLE_RANK_KILL_SCORE,killIndex),score = template["kill_"..killIndex]})
        end
    end
    if self.m_tData.bGetVip then
        table.insert(rankAddlist,{name = LocalStrings.BATTLE_GET_MVP,score = template.mvp_integral})
    end
    if self.m_tData.continuousWinTimes > 1 then
        table.insert(rankAddlist,{name = string.format(LocalStrings.BATTLE_RANK_WINS,self.m_tData.continuousWinTimes),score = math.min(winMax,(self.m_tData.continuousWinTimes - 1)) * template.liansheng})
    end
    --勇者积分
    local txtBraveScore = GetElement(self.m_root, "txtBraveScore_WndArenaWinNew", WZUILabelTTF)
    if txtBraveScore then 
        if g_PvpRankAddPercent == 0 then
            txtBraveScore:setText(LocalStrings.BATTLE_HERO_SCORE)
        else
            txtBraveScore:setText(LocalStrings.BATTLE_HERO_SCORE .. "(+" .. g_PvpRankAddPercent .. "%)")
        end
    end

    local totalSocre = 0--self.m_tData.addRankScore
    --成就获得 显示
    for i = 1,3 do
        local titleLab = GetElement(self.m_root,string.format("labT%dRankResult_WndArenaWinNew",i + 1),WZUILabelTTF)
        local lab = GetElement(self.m_root,string.format("lab%dRankResult_WndArenaWinNew",i + 1),WZUILabelTTF)
        if i <= #rankAddlist then
            titleLab:setText(rankAddlist[i].name)
            lab:setText("+"..rankAddlist[i].score)
            totalSocre = totalSocre + rankAddlist[i].score
        else
            titleLab:setText("")
            lab:setText("")
        end
    end 

    local totalSocreLab = GetElement(self.m_root,"lab1RankResult_WndArenaWinNew",WZUILabelTTF)
    -- if totalSocre > 0 then
        totalSocreLab:setText("+"..totalSocre)
    -- else
    --     totalSocreLab:setText(tostring(totalSocre))
    -- end
    
    --计算下一等级
    local curLv = self.m_tData.preRankLevel
    local curExp = self.m_tData.preRankScore
    local addExp = self.m_tData.addRankScore
    local nextLv = curLv
    local template = self:getRankTemplateByLv(curLv)
    if self.m_tData.isWin then
        if curExp + addExp >= template.honor then
            nextLv = nextLv + 1
            --经验满足升星
            self.m_nRankScoreState = 1
        end
        nextLv = nextLv + template.win_level
    else
        if curExp + addExp >= template.honor then
            if template.fail_level == 0 then
                nextLv = nextLv + 1
                self.m_nRankScoreState = -2
            else
                --经验满足升星 降级保护--降级取消积分有剩余
                self.m_nRankScoreState = 1
            end
        elseif template.protect > 0 and curExp + addExp >= template.protect then
            --降级保护--降级取消积分无剩余
            self.m_nRankScoreState = 2
        else
            if template.protect > 0 then
                self.m_nRankScoreState = -1
            end
             nextLv = nextLv + template.fail_level
        end
    end

    --进度条变量
    self.m_nCurRankLv = self.m_tData.preRankLevel
    self.m_nAddRankExp = self.m_tData.addRankScore
    self.m_nCurRankExp = self.m_tData.preRankScore
    self.m_nEndRankLv = nextLv --最终结果
    self.m_nAddRankExpSpeed = self.m_nAddRankExp/60
    self:_initRankItemView(curLv,nextLv)
    self:_updateRankSecDes(curLv,nextLv)
    self:_updateRankProtectedView()

    if self.m_nAddRankExpSpeed == 0 then
        self.m_nDelayTime = 1.5
    end
end

--@brief 创建排位赛Item
function WndArenaWinNew:_initRankItemView(curLv,nextLv)
    WZLog("WndArenaWinNew:_initRankItemView",curLv,nextLv)
    local eCell,tCell = CellArenaWinRankIcon:createElement()
    local conIcon = GetElement(self.m_root,"conIcon1RankResult_WndArenaWinNew",WZUIContainer)
    conIcon:addChild(eCell)
    tCell:setData(curLv)
    self.m_tRankIcon = tCell

    local eCell2,tCell2 = CellArenaWinRankIcon:createElement()
    local conIcon2 = GetElement(self.m_root,"conIcon2RankResult_WndArenaWinNew",WZUIContainer)
    conIcon2:addChild(eCell2)
    eCell2:setScale(0.6)
    tCell2:setData(curLv,false,true)

    local eCell3,tCell3 = CellArenaWinRankIcon:createElement()
    local conIcon3 = GetElement(self.m_root,"conIcon3RankResult_WndArenaWinNew",WZUIContainer)
    conIcon3:addChild(eCell3)
    eCell3:setScale(0.6)
    tCell3:setData(nextLv,false,true)
end

--@brief 刷子排位赛界面描述
function WndArenaWinNew:_updateRankSecDes(curLv,nextLv)
    --tips 显示
    local template = self:getRankTemplateByLv(curLv)
    local templateNext = self:getRankTemplateByLv(nextLv)

    local danLv = template.level2
    local danLv2 = templateNext.level2
    local updaStar = nextLv - curLv
    -- BATTLE_RANK_UPGRADE_TIPS = "本局上升%d星",
    -- BATTLE_RANK_UPGRADE_TIPS_II = "本局上升%d星，并且段位提升",
    -- BATTLE_RANK_DnGRADE_TIPS = "本局下降%d星",
    -- BATTLE_RANK_DnGRADE_TIPS_II = "本局下降%d星，并且段位跌落",
    local desStr = nil
    WZLog("WndArenaWinNew:_updateRankSecDes",curLv,nextLv,danLv,danLv2)
    if danLv2 ~= danLv then 
        if updaStar > 0 then
            desStr = LocalStrings.BATTLE_RANK_UPGRADE_TIPS_II
        else
            desStr = LocalStrings.BATTLE_RANK_DnGRADE_TIPS_II
        end
    elseif danLv == danLv2 then
        if updaStar > 0 then
            desStr = LocalStrings.BATTLE_RANK_UPGRADE_TIPS
        elseif updaStar < 0 then
            desStr = LocalStrings.BATTLE_RANK_DnGRADE_TIPS
        end
    end
    local label = GetElement(self.m_root,"lab5RankResult_WndArenaWinNew",WZUILabelTTF)
    if desStr then
        label:setText(string.format(desStr,math.abs(updaStar)))
    else
        if not self.m_tData.isWin then
            if template.fail_level == 0 then
                label:setText(LocalStrings.BATTLE_RANK_LOSE_ICON_TIPS1)
            elseif self.m_nRankScoreState == 1 then
                label:setText(LocalStrings.BATTLE_RANK_LOSE_ICON_TIPS2)
            elseif self.m_nRankScoreState == 2 then
                label:setText(LocalStrings.BATTLE_RANK_LOSE_ICON_TIPS3)
            end
        else
            label:setText("")
        end
    end
    -- BATTLE_RANK_LOSE_TIPS = "勇者积分不足保护失败"
    -- BATTLE_RANK_LOSE_TIPS2 = "段位保护开启"
    -- BATTLE_RANK_LOSE_TIPS3 = "积分升级抵挡扣星"
    -- BATTLE_RANK_WIN_TIPS = "积分满，额外增加一星"
    -- BATTLE_RANK_COMMON_TIPS = "积分%d = 一星"
    local labTips = GetElement(self.m_root,"labTipsRankResult_WndArenaWinNew",WZUILabelTTF)
    local colorRed = ccc3(229,105,22)
    local colorGreen = ccc3(99,255,95)
    labTips:setColor(colorGreen)
    if self.m_tData.isWin then
        if self.m_nRankScoreState == 1 then
            labTips:setText(LocalStrings.BATTLE_RANK_WIN_TIPS)
        else
            labTips:setText(string.format(LocalStrings.BATTLE_RANK_COMMON_TIPS,template.honor))
        end
    else
        if self.m_nRankScoreState == 1 then
            labTips:setText(LocalStrings.BATTLE_RANK_LOSE_TIPS3)
        elseif self.m_nRankScoreState == 2 then
            labTips:setText(LocalStrings.BATTLE_RANK_LOSE_TIPS2)
        else
            if self.m_nRankScoreState == -1 then
                labTips:setText(LocalStrings.BATTLE_RANK_LOSE_TIPS)
                labTips:setColor(colorRed)
            elseif self.m_nRankScoreState == -2 then
                labTips:setText(LocalStrings.BATTLE_RANK_WIN_TIPS)
            else
                labTips:setText(string.format(LocalStrings.BATTLE_RANK_COMMON_TIPS,template.honor))
            end
        end
    end
end

--@brief 刷新排位等级
function WndArenaWinNew:_updateRankLv()
    if not self.m_tData.isWin and self.m_nRankScoreState > 0 then
        --有保护 不做变化处理
        return
    end
    self.m_tRankIcon:setNextData(self.m_nCurRankLv)
    self:_updateRankProtectedView()
end

--@brief 刷新保护显示
function WndArenaWinNew:_updateRankProtectedView()
    local template = self:getRankTemplateByLv(self.m_nCurRankLv)
    local img = GetElement(self.m_root,"imgProtectedFlag_WndArenaWinNew",WZUIImage)
    if template.protect > 0 then
        local posMin,posMax = 0.065,0.303
        local pre = template.protect/template.honor
        local pos = posMin + (posMax - posMin)*pre
        img:setVisible(true)
        img:setRelativePosition(GlobalMethod:ccp(pos,0.4))
    else
        img:setVisible(false)
    end
    --升级经验刷新
    self.m_nRankLvExpMax = template.honor
    self:_updateRankExpProgress(self.m_nCurRankExp,self.m_nRankLvExpMax)
end

--@brief 刷新排位赛经验
function WndArenaWinNew:_updateRankExpProgress(cur,max)
    --经验条
    local prg = GetElement(self.m_root, "proExpRankResult_WndArenaWinNew", WZUIProgress)
    prg:setPercentage(math.min(cur*100/max, 100))

    local txtExp = GetElement(self.m_root, "labProExpRankResult_WndArenaWinNew", WZUILabelTTF)
    txtExp:setText(math.floor(cur + 0.5).."/"..max)

    --绿色进度条
    -- local prg2 = GetElement(self.m_root, "proExpRankResult2_WndArenaWinNew", WZUIProgress)
    -- prg2:setPercentage(math.min(cur*100/max, 100))

    -- local txtExp2 = GetElement(self.m_root, "labProExpRankResult2_WndArenaWinNew", WZUILabelTTF)
    -- txtExp2:setText(math.floor(cur + 0.5).."/"..max)

    -- local template = self:getRankTemplateByLv(self.m_nCurRankLv)
    -- if template.protect > 0 and cur >= template.protect then
    --     GetElement(self.m_root, "conProRankResult_WndArenaWinNew", WZUIContainer):setVisible(false)
    --     GetElement(self.m_root, "conProRankResult2_WndArenaWinNew", WZUIContainer):setVisible(true)
    -- else
    --     GetElement(self.m_root, "conProRankResult_WndArenaWinNew", WZUIContainer):setVisible(true)
    --     GetElement(self.m_root, "conProRankResult2_WndArenaWinNew", WZUIContainer):setVisible(false)
    -- end
end

--@brief 更新经验
function WndArenaWinNew:_updateRankExpInfo()
    if self.m_nAddRankExp > 0 then
        --加经验

        --升级检验
        if self.m_nCurRankExp >= self.m_nRankLvExpMax then
            local nextLv = self.m_nCurRankLv + 1
            if self:getRankTemplateByLv(nextLv) then
                --升级
                self.m_nCurRankLv = nextLv
                self.m_nCurRankExp = self.m_nCurRankExp - self.m_nRankLvExpMax
                self:_updateRankLv()
            else
                --满级
                self.m_nCurRankExp = self.m_nRankLvExpMax
                self:_updateRankExpProgress(self.m_nCurRankExp,self.m_nRankLvExpMax)
                return true
            end
        end

        local speed = math.min(self.m_nAddRankExp,self.m_nAddRankExpSpeed)
        local nAddExp = math.min(self.m_nRankLvExpMax - self.m_nCurRankExp, speed)
        self.m_nCurRankExp = self.m_nCurRankExp + nAddExp
        self.m_nAddRankExp = self.m_nAddRankExp - nAddExp
        --容错处理 防止溢出（进入循环）
        if  self.m_nAddRankExp < 0 then
             self.m_nAddRankExp = 0
        end
       
    elseif self.m_nAddRankExp < 0 then
        --扣经验

        --检验降级
        if self.m_nCurRankExp <= 0 then
            --等级保护
            if self.m_nRankScoreState == 2 then
                self.m_nCurRankExp = 0
                self:_updateRankExpProgress(self.m_nCurRankExp,self.m_nRankLvExpMax)
                return true
            end
            -- local nextLv = self.m_nCurRankLv - 1
            -- WZLog("WndArenaWinNew:_updateRankExpInfo",nextLv,self.m_nAddRankExp)
            -- if nextLv > 1 then
            --     --降级
            --     self.m_nCurRankExp = self.m_nRankLvExpMax
            --     self.m_nCurRankLv = nextLv
            --     self:_updateRankLv()
            -- else
            --     --最低级
            --     self.m_nCurRankExp = 0
            --     self:_updateRankExpProgress(self.m_nCurRankExp,self.m_nRankLvExpMax)
            --     return true
            -- end
        end

        local speed = math.max(self.m_nAddRankExp,self.m_nAddRankExpSpeed)
        local nAddExp = math.max(0 - self.m_nCurRankExp,speed)
        self.m_nCurRankExp = self.m_nCurRankExp + nAddExp
        self.m_nAddRankExp = self.m_nAddRankExp - nAddExp
        --容错处理 防止溢出（进入循环）
        if  self.m_nAddRankExp > 0 then
             self.m_nAddRankExp = 0
        end
    else
        --经验加完
        self:_updateRankExpProgress(self.m_nCurRankExp,self.m_nRankLvExpMax)
        if not self.m_tData.isWin and self.m_nRankScoreState == 2 and self.m_nCurRankExp > 0 then
            --保护退经验
            self.m_nAddRankExp = -self.m_nCurRankExp
            self.m_nAddRankExpSpeed = self.m_nAddRankExp/60
            return false
        end
        return true
    end
    self:_updateRankExpProgress(self.m_nCurRankExp,self.m_nRankLvExpMax)
    return false
end

--@brief 获取配置表
function WndArenaWinNew:getRankTemplateByLv(level)
    for i, value in pairs(GDatatab_trio_rank_match_config) do
        if value.level3 == level then
            return value
        end
    end
    local template = GDatatab_trio_rank_match_config["id_999"]

    if level >= template.level3 then
        return template
    end
    return nil
end

--@brief 排位赛刷新
function WndArenaWinNew:_updateRankResultAction()
    if not self:_updateRankExpInfo() then
        return false
    end
    if not self.m_tRankIcon:getActionDone() then
        return false
    end
    return true
end

--@brief 排位赛等级变化
function WndArenaWinNew:_updateRankResultIconEnd()
    if self.m_nCurRankLv ~= self.m_nEndRankLv then
        self.m_tRankIcon:setNextData(self.m_nEndRankLv)
        self.m_nCurRankLv = self.m_nEndRankLv
        self:_updateRankProtectedView()
    end
end

--@brief 排位赛刷新
function WndArenaWinNew:_updateRankResultIconAction()
    if not self.m_tRankIcon:getActionDone() then
        return false
    end
    return true
end

--@brief 显示排位赛按钮
function WndArenaWinNew:_showRankResultBtn()
    WZLog("WndArenaWinNew:_showRankResultBtn")
    GetElement(self.m_root,"btnRankResult_WndArenaWinNew",WZUIButton):setVisible(true)
    GetElement(self.m_root,"btnRankResultLab_WndArenaWinNew",WZUILabelTTF):setVisible(true)
    if ProjConfig.LANGUAGE == "pt" then
        GetElement(self.m_root,"btnRankResultLab_WndArenaWinNew",WZUILabelTTF):setScale(0.7)
    end
    self.m_nContinueBtnDelay = self.m_nInfoBtnDelayTime
    self.m_sContinueBtnName = "btnRankResult_WndArenaWinNew"
    self.m_sContinueBtnLabName = "btnRankResultLab_WndArenaWinNew"
    self.m_tCurContainer = self.m_conRankResult

    --刷新显示
    self:_waitForContinueClick()
end

--@brief 常规结算
function WndArenaWinNew:_showArenaResultInfo()
    self.m_conArenaResult:setVisible(true)
    --求生
    local battleMode = WBattleGlobal:getCurrent().m_tMakePairOk.battleMode
    local battleChannel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    --混战
    if battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD and battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_QS then
        GetElement(self.m_root,"labArenaMoneyName_WndArenaWinNew",WZUILabelTTF):setText(LocalStrings.ADVENTURE_COIN)
        GetElement(self.m_root, "labArenaMoneyIconBig_WndArenaWinNew", WZUIImage):setFile("shopitems/adventure_01.png")
        GetElement(self.m_root, "labArenaMoneyIcon_WndArenaWinNew", WZUIImage):setFile("shopitems/adventure_01.png")
    else
        GetElement(self.m_root,"labArenaMoneyName_WndArenaWinNew",WZUILabelTTF):setText(LocalStrings.BATTLE_COPPER)
        GetElement(self.m_root, "labArenaMoneyIconBig_WndArenaWinNew", WZUIImage):setFile("shopitems/jingji.png")
        GetElement(self.m_root, "labArenaMoneyIcon_WndArenaWinNew", WZUIImage):setFile("shopitems/jingji.png")
    end

    GetElement(self.m_root,"btnArenaResult_WndArenaWinNew",WZUIButton):setVisible(false)
    GetElement(self.m_root,"btnArenaResultLab_WndArenaWinNew",WZUILabelTTF):setVisible(false)
    if battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
        GetElement(self.m_root, "conForMyPlayer_WndArenaWinNew", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6,0.5))
        GetElement(self.m_root, "conScore_WndArenaWinNew", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conRoleExp_WndArenaWinNew", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.44))
        GetElement(self.m_root, "conScoreCoin_WndArenaWinNew", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.735,0.44))
    end


    --玩家结算信息
    local fightInfo = self.m_tTeammate[1]

    local tEquip = {fightInfo.faceId, fightInfo.headId, fightInfo.bodyId, fightInfo.wingId, fightInfo.weaponId}
    local aniPlayer = CreatePlayerFigure(fightInfo.sex, tEquip, nil,nil,nil,nil,nil,nil,false,nil,fightInfo.headColor,fightInfo.bodyColor)
    local aniNode = aniPlayer:getAnimNode()
    aniNode:setScale(0.9)
    if self.m_tData.isWin then
        aniPlayer:play("win", true)
    else
        aniPlayer:play("failure", true)
    end

    local tmpCon = WZUIContainer:create()
    tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.7))
    tmpCon:setUseAbsSize(true)
    tmpCon:setAbsContentSize(GlobalMethod:CCSize(135,135))
    tmpCon:addChild(aniNode)

    
    local container = GetElement(self.m_root,"conRoleArenaResult_WndArenaWinNew",WZUIContainer)
    container:addChild(tmpCon)

    --头像
    local conRoleIconArenaResult = GetElement(self.m_root, "conRoleIconArenaResult_WndArenaWinNew", WZUIContainer)
    local cell,tcell = CellHead:show(conRoleIconArenaResult,fightInfo.headId,fightInfo.faceId,fightInfo.sex,nil,nil,nil,fightInfo.headColor,"ui/city/beta/common_scale9_zhezhaoheidifx02.png", 1)
    cell:setScale(0.9)
    --进度条变量
    self.m_nCurArenaLv = self.m_tData.preSportLevel
    self.m_nCurArenaExp = self.m_tData.preSportScore
    self.m_nAddArenaExp = self.m_tData.addSportScore
    self.m_nAddArenaExpSpeed = self.m_nAddArenaExp / 60 
   
    --玩家经验
    self.m_nCurHeroLv = self.m_tData.prePlayerLevel
    self.m_nCurHeroExp = self.m_tData.prePlayerExp
    self.m_nAddHeroExp = self.m_tData.addExp
    self.m_nAddHeroExpSpeed = self.m_nAddHeroExp / 60 
    WZLog("WndArenaWinNew:_showArenaResultInfo",self.m_nCurHeroLv,self.m_nCurHeroExp,self.m_nAddHeroExp)

    self:_updateArenaLabel(fightInfo)
    self:_updateHeroLv()
    self:_updateArenaLv()
end

--@brief 刷新文本信息
function WndArenaWinNew:_updateArenaLabel(fightInfo)
    local labAddExp = GetElement(self.m_root,"labAddExpArenaResult_WndArenaWinNew",WZUILabelTTF)
    if self.m_nAddHeroExp >= 0 then
        labAddExp:setText("+"..self.m_nAddHeroExp)
    else
        labAddExp:setText(self.m_nAddHeroExp)
    end

    local labAddExp2 = GetElement(self.m_root,"labAddExp2ArenaResult_WndArenaWinNew",WZUILabelTTF)
    if self.m_nAddArenaExp >= 0 then
        labAddExp2:setText("+"..self.m_nAddArenaExp)
    else
        labAddExp2:setText(self.m_nAddArenaExp)
    end

    local labAddCopper = GetElement(self.m_root,"labAddCopperArenaResult_WndArenaWinNew",WZUILabelTTF)
    labAddCopper:setText("+"..self.m_tData.gainCoin)

    local maxExp = self.m_tData.weekIncomeLimit
    local labExpWeek = GetElement(self.m_root,"labExpWeekAwardResult_WndArenaWinNew",WZUILabelTTF)
    labExpWeek:setText(self.m_tData.weekIncome .. "/" .. maxExp)

    local labExpWeekT = GetElement(self.m_root,"labExpWeekAwardTitleResult_WndArenaWinNew",WZUILabelTTF)
    local expWeekStr = ""
    if self.m_tData.weekIncome >= maxExp then
        expWeekStr =  LocalStrings.BATTLE_WEEK_AWARD_FULL
        labExpWeek:setColor(GlobalMethod:ccc3(255,89,74))
    else
        expWeekStr =  LocalStrings.BATTLE_WEEK_AWARD
        labExpWeek:setColor(GlobalMethod:ccc3(99,255,95))
    end
    labExpWeekT:setText(expWeekStr)

    local maxCopper = self.m_tData.weekCoinIncomeLimit
    local labCopperWeek = GetElement(self.m_root,"labCopperWeekAwardResult_WndArenaWinNew",WZUILabelTTF)
    labCopperWeek:setText(self.m_tData.weekCoinIncome .. "/" .. maxCopper)
    local labCopperWeekT = GetElement(self.m_root,"labCopperWeekAwardTitleResult_WndArenaWinNew",WZUILabelTTF)
    
    local copperWeekStr = ""
    if self.m_tData.weekCoinIncome >= maxCopper then
        copperWeekStr =  LocalStrings.BATTLE_WEEK_AWARD_FULL
        labCopperWeek:setColor(GlobalMethod:ccc3(255,89,74))
    else
        copperWeekStr =  LocalStrings.BATTLE_WEEK_AWARD
        labCopperWeek:setColor(GlobalMethod:ccc3(99,255,95))
    end
    labCopperWeekT:setText(copperWeekStr)
    if ProjConfig.LANGUAGE == "pt" then
        GetElement(self.m_root,"labCopperWeekAwardTitleResult_WndArenaWinNew",WZUILabelTTF):setScale(0.6)
    end
    if fightInfo.integralAdds > 0 then 
        GetElement(self.m_root,"labCardTitleArenaResult_WndArenaWinNew",WZUILabelTTF):setVisible(true)
        GetElement(self.m_root,"labCardAddArenaResult_WndArenaWinNew",WZUILabelTTF):setVisible(true)
        GetElement(self.m_root,"labCardAddArenaResult_WndArenaWinNew",WZUILabelTTF):setText("+"..fightInfo.integralAdds)
    else
        GetElement(self.m_root,"labCardTitleArenaResult_WndArenaWinNew",WZUILabelTTF):setVisible(false)
        GetElement(self.m_root,"labCardAddArenaResult_WndArenaWinNew",WZUILabelTTF):setVisible(false)
    end

end

--@brief 刷新等级
function WndArenaWinNew:_updateHeroLv()
    local labHeroLv = GetElement(self.m_root,"labHeroLvArenaResult_WndArenaWinNew",WZUILabelTTF)
    labHeroLv:setText("Lv"..self.m_nCurHeroLv)
end

--@brife 刷新竞技等级
function WndArenaWinNew:_updateArenaLv()
    local imgIcon = GetElement(self.m_root, "imgLvIconArenaResult_WndArenaWinNew", WZUIImage)
    local labLv = GetElement(self.m_root,"labLvArenaResult_WndArenaWinNew",WZUILabelAtlasFont)

    local template = GDatatab_integral["id_"..self.m_nCurArenaLv]
    if template then
        local path = "ui/common/".. template.iocn ..".png"
        imgIcon:setFile(path)
        labLv:setText(template.iocn_level)

        local labLvName = GetElement(self.m_root,"labLvNameArenaResult_WndArenaWinNew",WZUILabelTTF)
        labLvName:setText(template.dan)
    end
end

--@brief 更新经验
function WndArenaWinNew:_updateHeroExpInfo()
    --升级检验
    local maxExp = GetMaxExpByLevel(self.m_nCurHeroLv)
    
    if self.m_nAddHeroExp > 0 then
        --加经验

        --升级检验
        if self.m_nCurHeroExp >= maxExp then
            local nextLv = self.m_nCurHeroLv + 1

            if nextLv <= GetPlayerMaxLevel() then
                --升级
                self.m_nCurHeroLv = nextLv
                self.m_nCurHeroExp = self.m_nCurHeroExp - maxExp
                maxExp = GetMaxExpByLevel(self.m_nCurHeroLv)
                self:_updateHeroLv()
            else
                --满级
                self.m_nCurHeroExp = maxExp
                self:_updateHeroExpProgress(self.m_nCurHeroExp,maxExp)
                return true
            end
        end

        local speed = math.min(self.m_nAddHeroExp,self.m_nAddHeroExpSpeed)
        local nAddExp = math.min(GetMaxExpByLevel(self.m_nCurHeroLv) - self.m_nCurHeroExp, speed)
        self.m_nCurHeroExp = self.m_nCurHeroExp + nAddExp
        self.m_nAddHeroExp = self.m_nAddHeroExp - nAddExp
        
    else
        --经验加完
        self:_updateHeroExpProgress(self.m_nCurHeroExp,maxExp)
        return true
    end
    self:_updateHeroExpProgress(self.m_nCurHeroExp,maxExp)
    return false
end

--@brief 刷新经验显示
function WndArenaWinNew:_updateHeroExpProgress(cur,max)
    WZLog("WndArenaWinNew:_updateHeroExpProgress",cur,max)
    --经验条
    local prg = GetElement(self.m_root, "proExpArenaResult_WndArenaWinNew", WZUIProgress)
    prg:setPercentage(math.min(cur*100/max, 100))

    local txtExp = GetElement(self.m_root, "labProExpArenResult_WndArenaWinNew", WZUILabelTTF)
    txtExp:setText(math.floor(cur + 0.5).."/"..max)
end

--@brief 更新竞技经验
function WndArenaWinNew:_updateArenaExpInfo()
    local template = GDatatab_integral["id_"..self.m_nCurArenaLv]
    local maxExp = template.upgrade_integral

    if self.m_nAddArenaExp > 0 then
        --加经验

        --升级检验
        if self.m_nCurArenaExp >= maxExp then
            local nextLv = self.m_nCurArenaLv + 1
            local nextTemp =  GDatatab_integral["id_"..nextLv]
            if nextTemp then
                --升级
                self.m_nCurArenaLv = nextLv
                self.m_nCurArenaExp = 0
                maxExp = nextTemp.upgrade_integral
                self:_updateArenaLv()
            else
                --满级
                self.m_nCurArenaExp = maxExp
                self:_updateArenaExpProgress(self.m_nCurArenaExp,maxExp)
                return true
            end
        end

        local speed = math.min(self.m_nAddArenaExp,self.m_nAddArenaExpSpeed)
        local nAddExp = math.min(maxExp - self.m_nCurArenaExp, speed)
        self.m_nCurArenaExp = self.m_nCurArenaExp + nAddExp
        self.m_nAddArenaExp = self.m_nAddArenaExp - nAddExp
        --容错处理 防止溢出（进入循环）
        if  self.m_nAddArenaExp < 0 then
             self.m_nAddArenaExp = 0
        end
       
    elseif self.m_nAddArenaExp < 0 then
        --扣经验

        --检验降级
        if self.m_nCurArenaExp <= 0 then
            local nextLv = self.m_nCurArenaLv - 1
            local nextTemp =  GDatatab_integral["id_"..nextLv]
            if nextTemp then
                --降级
                self.m_nCurArenaExp = nextTemp.upgrade_integral
                self.m_nCurArenaLv = nextLv
                maxExp = nextTemp.upgrade_integral
                self:_updateArenaLv()
            else
                --最低级
                self.m_nCurArenaExp = 0
                self:_updateArenaExpProgress(self.m_nCurArenaExp,maxExp)
                return true
            end
        end

        local speed = math.max(self.m_nAddArenaExp,self.m_nAddArenaExpSpeed)
        local nAddExp = math.max(0 - self.m_nCurArenaExp,speed)
        self.m_nCurArenaExp = self.m_nCurArenaExp + nAddExp
        self.m_nAddArenaExp = self.m_nAddArenaExp - nAddExp
        --容错处理 防止溢出（进入循环）
        if  self.m_nAddArenaExp > 0 then
             self.m_nAddArenaExp = 0
        end
    else
        --经验加完
        self:_updateArenaExpProgress(self.m_nCurArenaExp,maxExp)
        return true
    end
    self:_updateArenaExpProgress(self.m_nCurArenaExp,maxExp)
    return false
end

--@brief 刷新竞技经验显示
function WndArenaWinNew:_updateArenaExpProgress(cur,max)
    --经验条
    local prg = GetElement(self.m_root, "proExpArenaResult2_WndArenaWinNew", WZUIProgress)
    prg:setPercentage(math.min(cur*100/max, 100))

    local txtExp = GetElement(self.m_root, "labProExpArenResult2_WndArenaWinNew", WZUILabelTTF)
    txtExp:setText(math.floor(cur + 0.5).."/"..max)
end

--@brief 常规动画刷新
function WndArenaWinNew:_updateArenaResultAction()
    local result = true
    if not self:_updateHeroExpInfo() then
        result = false
    end
    local battleChannel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    if battleChannel ~= GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
        if not self:_updateArenaExpInfo() then
            result = false
        end
    end
    return result
end

--@brief 显示常规结算按钮
function WndArenaWinNew:_showArenaResultBtn()
    GetElement(self.m_root,"btnArenaResult_WndArenaWinNew",WZUIButton):setVisible(true)
    GetElement(self.m_root,"btnArenaResultLab_WndArenaWinNew",WZUILabelTTF):setVisible(true)
    if ProjConfig.LANGUAGE == "pt" then
        GetElement(self.m_root,"btnArenaResultLab_WndArenaWinNew",WZUILabelTTF):setScale(0.7)
    end
    self.m_nContinueBtnDelay = self.m_nInfoBtnDelayTime
    self.m_sContinueBtnName = "btnArenaResult_WndArenaWinNew"
    self.m_sContinueBtnLabName = "btnArenaResultLab_WndArenaWinNew"
    --self.m_tCurContainer = self.m_conArenaResult

    --刷新显示
    self:_waitForContinueClick()
end

--@brief 显示通用信息
function WndArenaWinNew:_showActoinResult()
    GetElement(self.m_root,"conActionResult_WndArenaWinNew",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"conActionResultBg_WndArenaWinNew",WZUIContainer):setVisible(true)

    self.m_nContinueBtnDelay = self.m_nInfoBtnDelayTime
    self.m_sContinueBtnName = "btnActoinResult_WndArenaWinNew"
    self.m_sContinueBtnLabName = "btnActionResultLab_WndArenaWinNew"
    self.m_tCurContainer = GetElement(self.m_root,"conActionResult_WndArenaWinNew",WZUIContainer)
    self.m_tSecContainer = GetElement(self.m_root,"conActionResultBg_WndArenaWinNew",WZUIContainer)
    self:_initActionView()
end

function WndArenaWinNew:_initActionView()
    local nBattleChannle = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    local nBattleMode = WBattleGlobal:getCurrent().m_tMakePairOk.battleMode

    local leftList = self.m_tTeammate
    local rightList = self.m_tEnemy

    if nBattleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD then
        leftList = self.m_tWinTeam
        rightList = self.m_tFailTeam
    end
    
    local PosListL = nil
    if #leftList == 1 then
        PosListL = {GlobalMethod:ccp(0.25,0.3)}
    elseif #leftList == 2 then
        PosListL =  {GlobalMethod:ccp(0.37,0.25),GlobalMethod:ccp(0.13,0.25)}
    elseif #leftList == 3 then
        PosListL = {GlobalMethod:ccp(0.37,0.25),GlobalMethod:ccp(0.25,0.4),GlobalMethod:ccp(0.13,0.25)}
    elseif #leftList == 4 then
        PosListL = {GlobalMethod:ccp(0.37,0.3),GlobalMethod:ccp(0.25,0.4),GlobalMethod:ccp(0.25,0.2),GlobalMethod:ccp(0.23,0.3)}
    elseif #leftList == 5 then
        PosListL = {GlobalMethod:ccp(0.47,0.25),GlobalMethod:ccp(0.37,0.35),GlobalMethod:ccp(0.27,0.25),GlobalMethod:ccp(0.17,0.35),GlobalMethod:ccp(0.07,0.25)}
    end

    local PosListR = nil
    if #rightList == 1 then
        PosListR =  {GlobalMethod:ccp(0.75,0.3)}
    elseif #rightList == 2 then
        PosListR =  {GlobalMethod:ccp(0.63,0.25),GlobalMethod:ccp(0.87,0.25)}
    elseif #rightList == 3 then
        PosListR = {GlobalMethod:ccp(0.63,0.25),GlobalMethod:ccp(0.75,0.4),GlobalMethod:ccp(0.87,0.25)}
    elseif #rightList == 4 then
        PosListR = {GlobalMethod:ccp(0.63,0.3),GlobalMethod:ccp(0.75,0.4),GlobalMethod:ccp(0.75,0.2),GlobalMethod:ccp(0.87,0.3)}
    elseif #rightList == 5 then
        PosListR = {GlobalMethod:ccp(0.53,0.25),GlobalMethod:ccp(0.63,0.35),GlobalMethod:ccp(0.73,0.25),GlobalMethod:ccp(0.83,0.35),GlobalMethod:ccp(0.93,0.25)}
    else
        PosListR = {
                        GlobalMethod:ccp(0.25,0.25),GlobalMethod:ccp(0.5,0.25),GlobalMethod:ccp(0.8,0.25),
                        GlobalMethod:ccp(0.35,0.35),GlobalMethod:ccp(0.55,0.35),GlobalMethod:ccp(0.85,0.35)
                    }
    end
    

    local scale = 0.9
    if #leftList > 3 or #rightList > 3 then
        scale = 0.6
    end

    local container = GetElement(self.m_root,"conFightRole_WndArenaWinNew",WZUIContainer)
    for i = 1, #leftList do
        local fightInfo = leftList[i]
        local tEquip = {fightInfo.faceId, fightInfo.headId, fightInfo.bodyId, fightInfo.wingId, fightInfo.weaponId}
        local aniPlayer = CreatePlayerFigure(fightInfo.sex, tEquip, nil,nil,nil,nil,nil,nil,false,nil,fightInfo.headColor,fightInfo.bodyColor)
        local aniNode = aniPlayer:getAnimNode()
        aniPlayer:setScale(scale)
        if fightInfo.isWin then
            aniPlayer:play("win", true)
        else
            aniPlayer:play("failure", true)
        end

        local tmpCon = WZUIContainer:create()
        tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
        tmpCon:setUseAbsSize(true)
        tmpCon:setAbsContentSize(GlobalMethod:CCSize(90,90))
        tmpCon:addChild(aniNode)

        local element = WZUIContainer:luaTo(WZUISystem:getInstance():createElement("conFightRoleNode_WndArenaWinNew"))
        container:addChild(element)
        element:addChild(tmpCon)
        element:setRelativePosition(PosListL[i])
        element:setZOrder(i%2)

        -- --等级
        if nBattleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
            WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_WndArenaWinNew")):setText(fightInfo.playerName)
        else
            WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_WndArenaWinNew")):setText("Lv" .. tostring(fightInfo.playerLevel) .. fightInfo.playerName)
        end
        --跨服标记
        if tostring(fightInfo.serverId) ~= tostring(CacheCenter:getPlayerInfo().serverId) then
            GetElement(element, "imgOtherServerIcon_WndArenaWinNew", WZUIImage):setVisible(true)
            local txtPlayerName = WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_WndArenaWinNew"))
            txtPlayerName:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
        else
            GetElement(element, "imgOtherServerIcon_WndArenaWinNew", WZUIImage):setVisible(false)
        end

        if fightInfo.playerId == WBattleGlobal:getCurrent().m_tMakePairOk.selfId then
            WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_WndArenaWinNew")):setColor(GlobalMethod:ccc3(99,255,95))
            -- local effect = BattleAnimation:createAnimation("ui_jiesuan_renwudizuo_01",true, "ui")
            -- element:addChild(effect:getAnimNode())
            -- effect:setScale(scale)
            -- effect:play("0",true)
        end
    end

    for i = 1, #rightList do
        local fightInfo = rightList[i]
        local tEquip = {fightInfo.faceId, fightInfo.headId, fightInfo.bodyId, fightInfo.wingId, fightInfo.weaponId}
        local aniPlayer = CreatePlayerFigure(fightInfo.sex, tEquip, nil,nil,nil,nil,nil,nil,false,nil,fightInfo.headColor,fightInfo.bodyColor)
        local aniNode = aniPlayer:getAnimNode()
        aniPlayer:setScale(scale)
        aniPlayer:setFlipX(true)
        if fightInfo.isWin then
            aniPlayer:play("win", true)
        else
            aniPlayer:play("failure", true)
        end

       local tmpCon = WZUIContainer:create()
        tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
        tmpCon:setUseAbsSize(true)
        tmpCon:setAbsContentSize(GlobalMethod:CCSize(90,90))
        tmpCon:addChild(aniNode)

        local element = WZUIContainer:luaTo(WZUISystem:getInstance():createElement("conFightRoleNode_WndArenaWinNew"))
        container:addChild(element)
        element:addChild(tmpCon)
        element:setRelativePosition(PosListR[i])
        element:setZOrder(i%2)

        --等级
        WZLog("WndArenaWinNew:_initActionView")
        if nBattleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
            WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_WndArenaWinNew")):setText(fightInfo.playerName)
        else
            WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_WndArenaWinNew")):setText("Lv" .. tostring(fightInfo.playerLevel) .. fightInfo.playerName)
        end
        --跨服标记
        if tostring(fightInfo.serverId) ~= tostring(CacheCenter:getPlayerInfo().serverId) then
            GetElement(element, "imgOtherServerIcon_WndArenaWinNew", WZUIImage):setVisible(true)
            local txtPlayerName = WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_WndArenaWinNew"))
            txtPlayerName:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
        else
            GetElement(element, "imgOtherServerIcon_WndArenaWinNew", WZUIImage):setVisible(false)
        end
        if fightInfo.playerId == WBattleGlobal:getCurrent().m_tMakePairOk.selfId then
            WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_WndArenaWinNew")):setColor(GlobalMethod:ccc3(99,255,95))
            -- local effect = BattleAnimation:createAnimation("ui_jiesuan_renwudizuo_01",true, "ui")
            -- element:addChild(effect:getAnimNode())
            -- effect:setScale(scale)
            -- effect:play("0",true)
        end
    end

    if self.m_tData.isWin then
        GetElement(self.m_root, "spineActionWin_WndArenaWinNew", WZUISpine):setRelativePosition(GlobalMethod:ccp(0.25,0.308722))
        GetElement(self.m_root, "spineActionWinFront_WndArenaWinNew", WZUISpine):setRelativePosition(GlobalMethod:ccp(0.227631,0.299859))
        GetElement(self.m_root, "spineActionLose_WndArenaWinNew", WZUISpine):setRelativePosition(GlobalMethod:ccp(0.75,0.308722))
    else
        GetElement(self.m_root, "spineActionWin_WndArenaWinNew", WZUISpine):setRelativePosition(GlobalMethod:ccp(0.75,0.308722))
        GetElement(self.m_root, "spineActionWinFront_WndArenaWinNew", WZUISpine):setRelativePosition(GlobalMethod:ccp(0.727631,0.299859))
        GetElement(self.m_root, "spineActionLose_WndArenaWinNew", WZUISpine):setRelativePosition(GlobalMethod:ccp(0.25,0.308722))
    end

end

--@brief 显示通用信息
function WndArenaWinNew:_showFightResultInfo()
    self.m_conFightResult:setVisible(true)
    self.m_nContinueBtnDelay = self.m_nInfoBtnDelayTime
    self.m_sContinueBtnName = "btnFightResult_WndArenaWinNew"
    self.m_sContinueBtnLabName = "btnFightResultLab_WndArenaWinNew"
    self.m_tCurContainer = self.m_conFightResult
    self:_initFightView()
    self:_setResultPosition()
end

--@brief 战斗信息显示
function WndArenaWinNew:_initFightView()
    --tData.isSameTeam 同一队伍 
    --tData.headId ,faceId, sex 头像信息
    --tData.playerName 玩家名字
    --tData.killCount 杀人数
    --tData.shootRate 命中率
    --tData.hurtTotal 伤害总数
    --tData.isMvp 是否mvp 
    for i = 1,#self.m_tTeammate do
        local info = self.m_tTeammate[i]
        info.isSameTeam = true
        local eCell,tCell = CellArenaWinFightResult:createElement()
        local conIcon = GetElement(self.m_root,string.format("conCellL%dFightResult_WndArenaWinNew",i),WZUIContainer)
        eCell:setTag(11)
        conIcon:addChild(eCell)
        tCell:setData(info)
    end

    for i = 1,#self.m_tEnemy do
        local info = self.m_tEnemy[i]
        info.isSameTeam = false
        local eCell,tCell = CellArenaWinFightResult:createElement()
        local conIcon = GetElement(self.m_root,string.format("conCellR%dFightResult_WndArenaWinNew",i),WZUIContainer)
        eCell:setTag(11)
        conIcon:addChild(eCell)
        tCell:setData(info)
    end
end

--@brief  界面结算结束
function WndArenaWinNew:_allActionDone()
    self:goback()
end

--@brief    针对排位赛设置位置
function WndArenaWinNew:_setResultPosition()
    -- body
    local battleChannel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    if battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
        GetElement(self.m_root, "imgLKill_WndArenaWinNew", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.263637,0.65233))
        GetElement(self.m_root, "imgLShoot_WndArenaWinNew", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.312844,0.65233))
        GetElement(self.m_root, "imgLScore_WndArenaWinNew", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.379555,0.65233))

        GetElement(self.m_root, "imgRKill_WndArenaWinNew", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.679763,0.65233))
        GetElement(self.m_root, "imgRShoot_WndArenaWinNew", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.73076,0.65233))
        GetElement(self.m_root, "imgRScore_WndArenaWinNew", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.797973,0.65233))
    end
end
----------------------------------私有方法模块End----------------------------------------

----------------------------------语言适配Begin------------------------------------------
function WndArenaWinNew:_adaptLanguage_pt( )
    GetElement(self.m_root,"btnArenaResultLab_WndArenaWinNew",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"labCopperWeekAwardTitleResult_WndArenaWinNew",WZUILabelTTF):setScale(0.6)

    GetElement(self.m_root,"lab1RankResult_WndArenaWinNew",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.290841,0.60964))
    GetElement(self.m_root,"lab2RankResult_WndArenaWinNew",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.290841,0.563923))
    GetElement(self.m_root,"lab3RankResult_WndArenaWinNew",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.290841,0.51861))
    GetElement(self.m_root,"lab4RankResult_WndArenaWinNew",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.290841,0.471735))

    GetElement(self.m_root,"lab5RankResult_WndArenaWinNew",WZUILabelTTF):setScale(0.8)
end

function WndArenaWinNew:_adaptLanguage_es(  )
    GetElement(self.m_root,"labExpWeekAwardTitleResult_WndArenaWinNew",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"labCardTitleArenaResult_WndArenaWinNew",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"labCopperWeekAwardTitleResult_WndArenaWinNew",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"lab1RankResult_WndArenaWinNew",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.268966,0.60964))
    GetElement(self.m_root,"lab2RankResult_WndArenaWinNew",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.268966,0.563923))
    GetElement(self.m_root,"lab3RankResult_WndArenaWinNew",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.268966,0.51861))
    GetElement(self.m_root,"lab4RankResult_WndArenaWinNew",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.268966,0.471735))

    GetElement(self.m_root,"lab5RankResult_WndArenaWinNew",WZUILabelTTF):setScale(0.8)
end
----------------------------------语言适配Begin------------------------------------------