--BattleMsgBossMapSkill.lua
--@brief    副本boss射击消息
--@date     2015/4/3
--@author   莫剑峰
--@note

--@brief    消息数据表
BattleMsgBossMapSkill = {
    m_sName = "BattleMsgBossMapSkill",
    m_nBattleId = 0, --战斗id
    m_nPlayerOrGuai = 0, --是玩家还是怪
    m_nCurrentPlayerId = 0, --角色id(当前在操作的角色）
    m_tSpeed = nil, --发射速度
    m_nLeftRight = 0, --1：左 0：右（向左还是向右）
    m_bIsLeftFlip = false,
    m_tStartPos = nil, --发射初始位置
    m_nPlayerCount = 0, --同步角色数量
    m_tPlayerIds = nil, --用户id
    m_tCurPositionX = nil, --没飞行前的x坐标
    m_tCurPositionY = nil, --没飞行前的y坐标
    m_nGuaiCount = 0, --同步角色数量
    m_tGuaiBattleIds = nil, --怪物id
    m_tGuaiCurPositionX = nil, --怪没飞行前的x坐标
    m_tGuaiCurPositionY = nil, --怪没飞行前的y坐标
    
    -------------------------------------处理逻辑使用的变量--------------------------------------
    m_nHurtNum = 0,             --伤害数字数量
    m_tStepFunction = nil,      --步骤函数
    m_tScreenSpring = nil,      --屏幕是否在震动
    
    m_status = 0, --状态
    m_nFollowBulletTime = 0, --子弹跟踪时间
    m_nShootDeltaTime = 0,   --发炮间隔时间
    m_nReadyToShootDeltaTime = 1.2,   --从做发炮准备动作到正式发炮的间隔时间, 默认为等待到动画结束就发炮
    m_nEveryBulletShootDeltaTime = 0.5,   --每个子弹出现的间隔时间, 默认为等待到动画结束再计算
    
    m_tOwner = nil,   --拥有者
    m_sReadyShootAnim = "", --准备射击的动画名称
    m_nBulletType = 1,  --子弹类型  0:投砸  1:射击
    m_nCheckCharacterCollisionRadius = 2,   --与人物碰撞时使用的半径 ,默认为2
    m_bIsPenetrateMap = true, --是否穿透地图
    m_nAttTimes = 1, --攻击次数
    m_nAttack = 0,  --子弹攻击力
    m_tAcceleration = nil,--子弹加速度
    m_bIsIgnoreDef = false, --是否无视防御
    m_bIsNeedExplode = false,    --是否需要播放爆炸动画
    
    --子弹动画属性
    m_sBulletAnimMainName = "", --子弹动画主动画名
    m_sBulletAnimFlyName = "", --子弹动画飞行动画名
    m_sBulletAnimExplodeWeaponName = "", --子弹动画爆破花纹所属的武器名
    m_nBulletAnimScale = 1, --子弹动画放大率
    m_bBulletAnimFlipX = false, --子弹动画是否X方向翻转
    m_nBulletAnimDefaultDirection = 1,            --子弹的动画的默认方向 0:向右 , 1:向左
    m_tTargetHero = nil,   --目标玩家
    m_tWeaponAnim = nil,    --武器动画
    m_sExplodeAnimName = "weapon1a", --爆炸动画
    m_sHeroOriWeaponName = nil, --所有者的武器名
    m_nScatterNum = 1,  --散射数
    m_nShootPower = nil,    --发射力度

    m_bIsOldBulletAnim = false, --子弹是否老动画
    m_sWeaponName = nil,     --子弹名称
    m_tSkillTypeList = nil, --技能类型列表
    m_nShootedCount = 0,    --已经发射的回数
    m_bIsNeedHurt = nil,    --是否需要计算伤害
    m_tSummonMonsterList = nil,

    m_nShootSummonCount = nil,
    m_tShootSummonMonsterList = nil,

    m_bIsAtkAfterMove = false,  --移动完是否攻击
    m_bIsMoveEnd = false,       --是否移动完
    m_tMoveOffset = nil,        --距离
    m_tOriginalPos = nil,       --怪的原位置
    m_tTargetPos = nil,         --目标地点
    m_nDefaultDistance = 400,   --默认移动距离
    m_tMonsterList = nil,
    m_tMoveEndList = nil,
    m_isCanAttack = nil,

    m_bMovePlayed = nil,        --移动动画是否已经播放
    m_tAttackEndList = nil,
    m_tEndPos = nil,
    m_tMoveEndPos = nil,
    m_nDt = 0.015,
    m_bIsZoom = nil,

    m_sTalkText = "",   --对话框的文本内容
    m_tPosOffset = nil, --对话框的位置偏移
    m_nDirection = CellDialog and CellDialog.DIR_LEFT, --对话框的方向,默认为左  
    m_nMaxWidth = nil,  --显示最大宽度,默认对话框背景宽度
    m_nScale = nil, --缩放大小,默认为1
    m_bNeedZoomToBoss = nil,    --是否需要把屏幕移向boss, 默认为不需要
    m_nTime = 3,                --对话框持续时间
    m_tFollowObj = nil,         --跟随对象
    m_bIsUpdatePos = nil,       --是否需要更新位置

    m_isClearAttackPos = nil,
    m_bIsBlockMsg = nil,      --消息阻塞
    --全局变量
    g_tEffectList = {},        --当前特效列表

    m_bIsCompareAction = true, --是否计数行为
    m_nTakeEffectType = -1,

    m_tChoseTargetPos = nil, --目标选择点
    m_bIsSummonMsg = false, --召唤技能标记
    m_tCallBackFunc = nil,  --回调函数结构

    m_bIsPetSkillEffect = false, --宠物效果
    m_tHurtTargetHeroList = nil, --命中触发队列
    m_tSpatterAngle = nil,       --溅射弹角度值
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgBossMapSkill:init()
    WZLog("BattleMsgBossMapSkill:init", self.m_tSkillTypeList[1])
    if TeachGroup1.ISBATTLE_MYTURN ~= true and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_NORMAL and (self.m_tSkillTypeList[1] ~= SkillTypeConfig.EFFECT and self.m_tSkillTypeList[1] ~= SkillTypeConfig.HIT_DO_EFFECT) then
        return "done"
    end

    if self.m_tSkillTypeList[1] and self.m_tSkillTypeList[1] ~= SkillTypeConfig.EFFECT and self.m_tSkillTypeList[1] ~= SkillTypeConfig.HIT_DO_EFFECT then
       -- SceneBattle:getBattleLoop():setBattleStatus(BattleLoop.S_PLAYER_SHOOT)
        WBattleGlobal:getCurrent():ClearHurt()
    end

    local hero = self.m_tOwner
    if hero == nil or hero:isDead() then
        WZLog("BattleMsgBossMapSkill:init", "can't find player:", self.m_nCurrentPlayerId)
        return "done"
    end

    WZLog("BattleMsgBossMapSkill:init one", hero:getBattleId(), hero.m_sWeaponName)
    
    if hero:getType() ~= 0 then
        --WndBattleHud:endTurnTime()
    end
    self.m_sHeroOriWeaponName = hero.m_sWeaponName
    if TeachGroup1.ISBATTLE_MYTURN ~= true then
        hero.m_sWeaponName = self.m_sWeaponName or hero.m_sWeaponName
    end
    hero:setRunStatus(RunStatus.DEF_ST_READY_SHOOT)
    
    self.m_nAttTimes =  self.m_nAttTimes
    if self.m_tShootSummonMonsterList ~= nil then
        self.m_nAttTimes = #self.m_tShootSummonMonsterList
    end

    self.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    self.m_nPlayerOrGuai = 1
    self.m_nCurrentPlayerId = hero.m_nBattleId

    local tHeroList = WBattleGlobal:getCurrent():getHeroList()
    self.m_nPlayerCount = 0
    self.m_tPlayerIds = {}
    self.m_tCurPositionX = {}
    self.m_tCurPositionY = {}
    
    local tGuaiList = WBattleGlobal:getCurrent():getGuaiList()
    
    for i ,v in pairs(tHeroList) do
        self.m_nPlayerCount = self.m_nPlayerCount + 1
        
        self.m_tPlayerIds[self.m_nPlayerCount] = v:getBattleId()
        self.m_tCurPositionX[self.m_nPlayerCount] = v:getPosition().x
        self.m_tCurPositionY[self.m_nPlayerCount] = v:getPosition().y
        
    end

    for i ,v in pairs(tGuaiList) do
        self.m_nPlayerCount = self.m_nPlayerCount + 1

        self.m_tPlayerIds[self.m_nPlayerCount] = v:getBattleId()
        self.m_tCurPositionX[self.m_nPlayerCount] = v:getPosition().x
        self.m_tCurPositionY[self.m_nPlayerCount] = v:getPosition().y
    end
    --[[
    self.m_tTargetHero = self.m_tTargetHero or WMonster:getRandomPlayer()

    if self.m_tStartPos == nil then
        local endPos = self.m_tTargetHero:getPosition()
        if self.m_tEndPos ~= nil then
           endPos = self.m_tEndPos
        end
        if endPos.x < hero:getPosition().x then
            self.m_nLeftRight = DirectionType.LEFT
        end

        local offset = BattleCommon:getPointTable(0, 0)
        if self.m_tOffset ~= nil then
            offset.x, offset.y = self.m_tOffset.x, self.m_tOffset.y
        end

        if self.m_nLeftRight == DirectionType.RIGHT then
            offset.x = 0 - offset.x
        end

        self.m_tStartPos = BattleCommon:getPointTable(hero:getPosition().x + offset.x, hero:getPosition().y + offset.y + 10)
    end


    self.m_bIsLeftFlip = hero.m_bIsLeftFlip

    if self.m_tSkillTypeList[1] and self.m_tSkillTypeList[1] ~= SkillTypeConfig.EFFECT and self.m_tSkillTypeList[1] ~= SkillTypeConfig.HIT_DO_EFFECT then
        if (self.m_bIsLeftFlip == true and self.m_nLeftRight == DirectionType.LEFT) or (self.m_bIsLeftFlip ~= true and self.m_nLeftRight == DirectionType.RIGHT) then
            WZLog("hero:getAnimation():setFlipX(true)", hero:getBattleId(), self.m_nLeftRight, tostring(self.m_bIsLeftFlip))
            hero:getAnimation():setFlipX(true)
            hero.m_bIsFilpX = true
        else
            WZLog("hero:getAnimation():setFlipX(false)", hero:getBattleId(), self.m_nLeftRight, tostring(self.m_bIsLeftFlip))
            hero:getAnimation():setFlipX(false)
            hero.m_bIsFilpX = false
        end
    end
    --]]
    self.m_tTargetHero = self.m_tTargetHero or WMonster:getRandomPlayer()
    self:updateFlipX(self.m_tTargetHero)

    --协议发送
    if self.m_tSkillTypeList[1] and self.m_tOwner:isCanControl() and (self.m_tSkillTypeList[1] ~= SkillTypeConfig.EFFECT and self.m_tSkillTypeList[1] ~= SkillTypeConfig.HIT_DO_EFFECT ) then
        if self.m_nId and self.m_nId ~= -1 then
            self.m_tOwner:sendAiProcol(self.m_nId)
        end
    end

    --处理步骤
    self.m_tStepFunction = {}
    

    WZLog("BattleMsgBossMapSkill:init end", tostring(self.m_nTalkId))
    if self.m_nTalkId ~= nil then
        self:addStep(EffectTypeConfig.TALK)
    end
    --技能列表 直接处理（子弹伤害，召唤等）
    for i, skillType in ipairs (self.m_tSkillTypeList) do
        self:addStep(skillType)
    end
end

--@brief 方向处理
function BattleMsgBossMapSkill:updateFlipX(target)
    self.m_tTargetHero = target

    if target == nil then
        return
    end

    local hero = self.m_tOwner
    local endPos = self.m_tTargetHero:getPosition()
    if self.m_tEndPos ~= nil then
       endPos = self.m_tEndPos
    end
    --WZLog("updateFlipX",hero:getPosition().x,target:getPosition().x)
    if endPos.x < hero:getPosition().x then
        self.m_nLeftRight = DirectionType.LEFT
    else
        self.m_nLeftRight = DirectionType.RIGHT
    end

    local offset = BattleCommon:getPointTable(0, 0)
    if self.m_tOffset ~= nil then
        offset.x, offset.y = self.m_tOffset.x, self.m_tOffset.y
    end

    if self.m_nLeftRight == DirectionType.RIGHT then
        offset.x = 0 - offset.x
    end
    self.m_tStartPos = BattleCommon:getPointTable(hero:getPosition().x + offset.x, hero:getPosition().y + offset.y + 10)
    self.m_bIsLeftFlip = hero.m_bIsLeftFlip

    if self.m_tSkillTypeList[1] and self.m_tSkillTypeList[1] ~= SkillTypeConfig.EFFECT and self.m_tSkillTypeList[1] ~= SkillTypeConfig.HIT_DO_EFFECT then
        if (self.m_bIsLeftFlip == true and self.m_nLeftRight == DirectionType.LEFT) or (self.m_bIsLeftFlip ~= true and self.m_nLeftRight == DirectionType.RIGHT) then
            WZLog("hero:getAnimation():setFlipX(true)", hero:getBattleId(), self.m_nLeftRight, tostring(self.m_bIsLeftFlip))
            hero:getAnimation():setFlipX(true)
            hero.m_bIsFilpX = true
        else
            WZLog("hero:getAnimation():setFlipX(false)", hero:getBattleId(), self.m_nLeftRight, tostring(self.m_bIsLeftFlip))
            hero:getAnimation():setFlipX(false)
            hero.m_bIsFilpX = false
        end
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgBossMapSkill:process(dt)
    self.m_nDt = dt
     --重连成功，而且正在等待怪物id
    if self.m_bIsWaitMonsterId and self.m_bIsReconnectDone then
        return true
    end
    --WZLog("BattleMsgBossMapSkill:process")
    if not self.m_tOwner or self.m_tOwner:isDead() then
        return true
    end
    
    if self.m_tSkillTypeList[1] and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_SHOOT and self.m_tSkillTypeList[1] ~= SkillTypeConfig.EFFECT and self.m_tSkillTypeList[1] ~= SkillTypeConfig.HIT_DO_EFFECT then
        return true
    end

    if self.m_sReadyShootAnim and self.m_sReadyShootAnim ~= "" and (self.m_tOwner:getAnimation():isPlaying(self.m_tOwner:getAnimationName(self.m_sReadyShootAnim)) and self.m_tOwner:getAnimation():isCurrentAnimationDone() == true) and self.m_tOwner:getAnimationName(self.m_sReadyShootAnim.."Ing") ~= self.m_tOwner:getAnimationName("standby") then
            --WZLog("BattleMsgBossMapSkill:process 1", self.m_tOwner:getAnimationName(self.m_sReadyShootAnim.."Ing"))
        self.m_tOwner:getAnimation():play(self.m_tOwner:getAnimationName(self.m_sReadyShootAnim.."Ing"),true)
    elseif self.m_sReadyShootAnim and self.m_sReadyShootAnim ~= "" and (self.m_tOwner:getAnimation():isPlaying(self.m_tOwner:getAnimationName(self.m_sReadyShootAnim)) and self.m_tOwner:getAnimation():isCurrentAnimationDone() == true) and self.m_tOwner:getAnimationName(self.m_sReadyShootAnim.."End") ~= self.m_tOwner:getAnimationName("standby") then
        --WZLog("BattleMsgBossMapSkill:process 3")
        self.m_tOwner:getAnimation():play(self.m_tOwner:getAnimationName(self.m_sReadyShootAnim.."End"),false)
    end

    --更新子弹状态
    self:_updateBullet()
    
    --屏幕震动
    self:_updateScene()

    if self.m_bIsBlockMsg then
        return false
    end

    if #self.m_tStepFunction > 0 then
        local res = self.m_tStepFunction[1][1](self,self.m_tStepFunction[1][2],self.m_tStepFunction[1][3],self.m_tStepFunction[1][4])
        if res == true or res == nil then
            table.remove(self.m_tStepFunction,1)
        end
        return false
    elseif self.m_tHurtBullet == nil or self.m_tHurtBullet.m_tExplodeElement:explodeIsEnd() == true then
        return true
    else
        return false
    end
    
    return true
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgBossMapSkill:done()

    WZLog("BattleMsgBossMapSkill:done zero",tostring(MsgManager.m_tBlockMsgList ~= nil and MsgManager.m_tBlockMsgList[1] ~= nil and MsgManager.m_tBlockMsgList[1].m_nSkillStatusCount))

    if self.m_tOwner:getAI() then
        self.m_tOwner:getAI().m_bIsUseSkill = nil
    end

    if TeachGroup1.ISBATTLE_MYTURN ~= true then
        self.m_tOwner.m_sWeaponName = self.m_sHeroOriWeaponName or self.m_tOwner.m_sWeaponName
    end

    --执行回调
    -- WZLog("BattleMsgBossMapSkill:done cbFunc",tostring(self.m_nSkillId),tostring(self.m_tCallBackFunc))
    if self.m_tCallBackFunc then
        self.m_tCallBackFunc[1](self.m_tCallBackFunc[2],self.m_tCallBackFunc[3])
        self.m_tCallBackFunc = nil
    end

    if self.m_nTakeEffectType ~= 2 and (MsgManager.m_tBlockMsgList ~= nil and MsgManager.m_tBlockMsgList[1] ~= nil and MsgManager.m_tBlockMsgList[1].m_nSkillStatusCount > 0) then
        
        local msg = MsgManager.m_tBlockMsgList[1]


        if true then

            if self.m_tHurtBullet and self.m_bIsDoSkill == nil then
                self.m_bIsDoSkill = true
                if self.m_tOwner:getType() == 0 then
                    local charas, values, distance, critType,hurtRatios = self.m_tHurtBullet:checkHurt()
                    self:_charaAddHurtValue(charas,values,hurtRatios)
                    WZLog("WBullet:checkHurt three-1",Serialize(values), Serialize(distance))
                    self:_sendHurtProtocol(charas,nil,values,distance,critType)

                else
                    local charas,values,distance, critType,hurtRatios = self.m_tHurtBullet:checkHurt()--self:_checkHurt(self.m_tHurtBullet)
                    charas = self:_charaAddHurtValue(charas,values,hurtRatios)
                    self:_sendHurtProtocol(charas)
                end
                self.m_tHurtBullet:destroy()
                self.m_tHurtBullet = nil
                -- WBattleGlobal:getCurrent().m_bIsDoEffectAfterAttack = nil
                WBattleGlobal:getCurrent():setDoEffectAfterAttack(nil,"bossMapSkill-1")

            end

            WZLog("BattleMsgBossMapSkill:done one", tostring(self:waitForHurtNum()), msg.m_nSkillStatusCount)
            if self:waitForHurtNum() ~= true then
                return false
            end
            -- WBattleGlobal:getCurrent().m_bIsDoEffectAfterAttack = nil
            WBattleGlobal:getCurrent():setDoEffectAfterAttack(nil,"bossMapSkill-2")

            msg.m_nSkillStatusCount = msg.m_nSkillStatusCount - 1

            --MsgManager.m_tBlockMsgList[1].m_nSkillStatus = MsgStatus.MSG_STATUS_PROCESS
            
            local loop = SceneBattle:getBattleLoop()
            -- loop:setBattleStatus(BattleLoop.S_NORMAL)

            if msg:_isPetAttack() then
                --msg.m_bIsPetShoot = true
            elseif self.m_tOwner:getType() == 0 and msg.m_bIsPetShoot ~= true and self.m_tSpatterInfo == nil then
                msg.m_nSkillStatusCount = -1
                WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),38,nil,nil,true)
            end
        end
        return
    else
        WBattleGlobal:getCurrent():setDoEffectAfterAttack(nil,"bossMapSkill-3")
    end

    if self.m_isClearAttackPos then
        self.m_tOwner:setAttackPos(nil)
    end

    --WZLog("BattleMsgBossMapSkill:done four", self.m_bIsCompareAction,self.m_tOwner:getAI().m_nAiActionCount)
    if self.m_bIsCompareAction and self.m_tOwner:getAI() ~= nil and self.m_tOwner:getAI().m_nAiActionCount ~= nil and self.m_tOwner:getAI().m_nAiActionCount > 0 then
        WZLog("BattleMsgBossMapSkill:done three", self.m_tOwner:getAI().m_nAiActionCount)
        self.m_tOwner:getAI().m_nAiActionCount = self.m_tOwner:getAI().m_nAiActionCount - 1
        if self.m_tOwner:getAI().m_nAiActionCount == 0 then
            self.m_tOwner:getAI().m_nAiActionCount = 100
        end
    end
    
    --WndBattleHud:endTurnTime()
    local loop = SceneBattle:getBattleLoop()
    if loop:getBattleStatus() == BattleLoop.S_PLAYER_SHOOT and self.m_nTakeEffectType ~= 2 then
        WZLog("BattleMsgBossMapSkill:done four", self.m_nTakeEffectType)
        -- loop:setBattleStatus(BattleLoop.S_NORMAL)
    end

    if self.m_nSkillAiChange then 
        self.m_tOwner:setAiState(self.m_nSkillAiChange)
    end
end

--@brief    等待受伤数字消失
function BattleMsgBossMapSkill:waitForHurtNum()
    WZLog("BattleMsgBossMapSkill:waitForHurtNum")

    return not WBattleGlobal:getCurrent():IsAnyOneHurt()
end


--@brief    添加步骤
--@note     添加处理步骤
function BattleMsgBossMapSkill:addStep(skillType, param, isBuff)
    if TeachGroup1.ISBATTLE_MYTURN == true then
        param = {WBattleGlobal:getCurrent():getMyHero()}
    end
    WZLog("BattleMsgBossMapSkill:addStep zero", skillType)
    if skillType == SkillTypeConfig.BIG_SKILL then
        table.insert(self.m_tStepFunction,{self._zoomToHero})
        table.insert(self.m_tStepFunction,{self._readyShowBigSkill})
        table.insert(self.m_tStepFunction,{self._showBigSkill})

    elseif skillType == SkillTypeConfig.SHOOT then
        table.insert(self.m_tStepFunction,{self._zoomToHero})
        table.insert(self.m_tStepFunction,{self._playReadyShootAnim})
        table.insert(self.m_tStepFunction,{self._readyShoot})
        table.insert(self.m_tStepFunction,{self._repeatShoot})
        table.insert(self.m_tStepFunction,{self._shooting})
        table.insert(self.m_tStepFunction,{self._waitForBulletAndHurt})
        table.insert(self.m_tStepFunction,{self._shooted})

    elseif skillType == SkillTypeConfig.SUMMON or skillType == EffectTypeConfig.SUMMON then
        self.m_tOwner.m_bIsUseSkill = true
        table.insert(self.m_tStepFunction,{self._sendBuildSummonMonster})
        table.insert(self.m_tStepFunction,{self._zoomToHero})
        if self.m_tSkillTypeList[2] then
            table.insert(self.m_tStepFunction,{self._doSummonAction})
        end
        table.insert(self.m_tStepFunction,{self._buildSummonMonster})
        --table.insert(self.m_tStepFunction,{self._zoomToHero,self.m_tSummonList})

    elseif skillType == SkillTypeConfig.SHOOT_SUMMON then
        table.insert(self.m_tStepFunction,{self._zoomToHero})
        table.insert(self.m_tStepFunction,{self._sendBuildShootedSummonMonster})
        table.insert(self.m_tStepFunction,{self._playReadyShootAnim})
        table.insert(self.m_tStepFunction,{self._readyShoot})
        table.insert(self.m_tStepFunction,{self._repeatShoot})
        table.insert(self.m_tStepFunction,{self._shooting})
        table.insert(self.m_tStepFunction,{self._waitForBulletAndHurt})

    elseif skillType == SkillTypeConfig.MOVE or skillType == EffectTypeConfig.MOVE then
        self.m_tOwner.m_bIsUseSkill = true
        table.insert(self.m_tStepFunction,{self._readyMonsterListMove})
        table.insert(self.m_tStepFunction,{self._monsterListMove})

    elseif skillType == SkillTypeConfig.BEAT then
        table.insert(self.m_tStepFunction,{self._readyMonsterListMeleeAttack})
        table.insert(self.m_tStepFunction,{self._monsterListMeleeAttack})

    elseif skillType == SkillTypeConfig.TRANS or skillType == EffectTypeConfig.TRANS then
        table.insert(self.m_tStepFunction,{self._sendBossChangeProtocol})
        table.insert(self.m_tStepFunction,{self._playTransformAnim})
        table.insert(self.m_tStepFunction,{self._changeBossAnim})

    elseif skillType == SkillTypeConfig.SKILL then
        local config = self:_getSkillData(self.m_nSkillId)
        table.insert(self.m_tStepFunction,{self._getSkillConfig})
        local camera = config.camera
        if camera and tonumber(camera) == -1 then
           camera = nil
        end
        if camera then 
            table.insert(self.m_tStepFunction,{self._ZoomOut})
        else
            table.insert(self.m_tStepFunction,{self._zoomToHero})
        end
        table.insert(self.m_tStepFunction,{self._readySkillAction})
        table.insert(self.m_tStepFunction,{self._doSkillAction})
        table.insert(self.m_tStepFunction,{self._endSkillAction})
        table.insert(self.m_tStepFunction,{self._ZoomOut})
        if not config.isHurtAdvance or config.isHurtAdvance == -1 then
            table.insert(self.m_tStepFunction,{self._doSkillEffect})
        end
    elseif skillType == SkillTypeConfig.HIT_DO_EFFECT then
        table.insert(self.m_tStepFunction,{self._getSkillConfig})
        table.insert(self.m_tStepFunction,{self._doSkillEffect})
    elseif skillType == EffectTypeConfig.HURT or skillType == EffectTypeConfig.RECOVERY then
        if #param > 0 then
            --table.insert(self.m_tStepFunction,{self._ZoomOut})
            table.insert(self.m_tStepFunction,{self._waitForSkillHurt,param})
            --table.insert(self.m_tStepFunction,{self._zoomToHero,param})
        end
    elseif skillType == EffectTypeConfig.INVINCIBLE then
        --table.insert(self.m_tStepFunction,{self._ZoomOut})
        table.insert(self.m_tStepFunction,{self._Invincible,param})
    elseif skillType == EffectTypeConfig.CHANGE_HURT_VALUE or skillType == EffectTypeConfig.CHANGE_HURT_PERCENT or skillType == EffectTypeConfig.CHANGE_HURT_ADD_VALUE or skillType == EffectTypeConfig.CHANGE_HURT_MUL_PERCENT then
        table.insert(self.m_tStepFunction,{self._ChangeHurt,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.CHANGE_BEHURT_VALUE or skillType == EffectTypeConfig.CHANGE_BEHURT_PERCENT or skillType == EffectTypeConfig.CHANGE_BEHURT_ADD_VALUE then
        table.insert(self.m_tStepFunction,{self._ChangeBeHurt,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT or skillType == EffectTypeConfig.CHANGE_CRIT_HURT_ADD_VALUE then
        table.insert(self.m_tStepFunction,{self._ChangeCritHurt,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT or skillType == EffectTypeConfig.CHANGE_BECRIT_HURT_ADD_VALUE then
        table.insert(self.m_tStepFunction,{self._ChangeBeCritHurt,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.CHANGE_RECOVERY_PERCENT then
        table.insert(self.m_tStepFunction,{self._ChangeRecovery,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.NO_HOLE then
        table.insert(self.m_tStepFunction,{self._NoHole,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.DEAD then
        --table.insert(self.m_tStepFunction,{self._ZoomOut})
        table.insert(self.m_tStepFunction,{self._Dead,param})
    elseif skillType == EffectTypeConfig.TRANSFER then
        table.insert(self.m_tStepFunction,{self._ZoomOut})
        table.insert(self.m_tStepFunction,{self._Transer,param})
        table.insert(self.m_tStepFunction,{self._zoomToHero,param})
    elseif false and skillType == EffectTypeConfig.TRANSFER_MOVE then
        table.insert(self.m_tStepFunction,{self._zoomToHero,param})
        table.insert(self.m_tStepFunction,{self._TranserMove,param})
    elseif skillType == EffectTypeConfig.TALK then
        table.insert(self.m_tStepFunction,{self._initDialog})
        --table.insert(self.m_tStepFunction,{self._zoomToHero})
        table.insert(self.m_tStepFunction,{self._showDialog})
    elseif skillType == SkillTypeConfig.EFFECT then
        table.insert(self.m_tStepFunction,{self._getEffectConfig})
        table.insert(self.m_tStepFunction,{self._doEffect})
    elseif skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE or skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT or skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT then
        table.insert(self.m_tStepFunction,{self._changeAttribute,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.CHANGE_CTB_VALUE then
        WZLog("BattleMsgBossMapSkill:addStep CTB", self._changeCtbValue,param,skillType,isBuff)
        table.insert(self.m_tStepFunction,{self._changeCtbValue,param,skillType,isBuff})
    elseif skillType == EffectTypeConfig.PET_CRIT then
        table.insert(self.m_tStepFunction,{self._petCrit,param})
    elseif skillType == EffectTypeConfig.CANCEL_BUFF_ASSIGN then
        table.insert(self.m_tStepFunction,{self._canelBuff,param})
    elseif skillType == EffectTypeConfig.SCATTER_SHOOT then
        table.insert(self.m_tStepFunction,{self._changeScatter,param})
    elseif skillType == EffectTypeConfig.TIMES_SHOOT then
        table.insert(self.m_tStepFunction,{self._changeAtkTimes,param})
    elseif skillType == EffectTypeConfig.SPEC_SHOOT then
        table.insert(self.m_tStepFunction,{self._specShooting})
        table.insert(self.m_tStepFunction,{self._repeatShoot})
        table.insert(self.m_tStepFunction,{self._waitForBulletAndHurt})
    elseif skillType == EffectTypeConfig.REPEL_FLY or skillType == EffectTypeConfig.REPEL_FLY_BOSS then
        table.insert(self.m_tStepFunction,{self._repelFly,param,skillType})
    elseif skillType == EffectTypeConfig.HIDE then
        table.insert(self.m_tStepFunction,{self._hide,param,isBuff})
    elseif skillType == EffectTypeConfig.ADD_BUFF then
        WZLog("BattleMsgBossMapSkill:addStep one_addBuff", self.m_nAddBuffId)
        table.insert(self.m_tStepFunction,{self._addBuff,param})
    elseif skillType == EffectTypeConfig.CANCEL_BUFF_ALL then
        table.insert(self.m_tStepFunction,{self._canelBuff,param})
    elseif skillType == EffectTypeConfig.CANCEL_BUFF_TYPE then
        table.insert(self.m_tStepFunction,{self._canelBuff,param})
    elseif skillType == EffectTypeConfig.CANCEL_BUFF_ID then
        table.insert(self.m_tStepFunction,{self._canelBuff,param})
    elseif skillType == EffectTypeConfig.EFFECT_TIPS_IN then
        table.insert(self.m_tStepFunction,{self._ZoomOut})
        table.insert(self.m_tStepFunction,{self._initEffect,param})
    elseif skillType == EffectTypeConfig.EFFECT_TIPS_OUT then
        table.insert(self.m_tStepFunction,{self._ZoomOut})
        table.insert(self.m_tStepFunction,{self._clearEffect,param})
    elseif skillType == EffectTypeConfig.MONSTER_CHANGE_STATE then
        table.insert(self.m_tStepFunction,{self._zoomToHero})
        table.insert(self.m_tStepFunction,{self._monsterChangeState,param})
        table.insert(self.m_tStepFunction,{self._ZoomOut})
    elseif skillType == EffectTypeConfig.TORNADO then
        self.m_bIsSummonMsg = true
        WZLog("EffectTypeConfigTORNADO", type(self.m_tOwnPlayerId))
        if self:_isGhostSkill(self.m_nSkillId) and self.m_tOwnPlayerId then
            table.insert(self.m_tStepFunction,{self._waitGhostMonsterId})
            table.insert(self.m_tStepFunction,{self._buildGhostTornado})
        else
            table.insert(self.m_tStepFunction,{self._waitMonsterId})
            table.insert(self.m_tStepFunction,{self._buildTornado})
        end
    elseif skillType == EffectTypeConfig.SPATTER then
        table.insert(self.m_tStepFunction,{self._spatter})
    elseif skillType == EffectTypeConfig.TREAT_TOTEM then
        -- table.insert(self.m_tStepFunction,{self._requestMonsterId})
        self.m_bIsSummonMsg = true
        table.insert(self.m_tStepFunction,{self._waitMonsterId})
        table.insert(self.m_tStepFunction,{self._buildTreatTotem})
    elseif skillType == EffectTypeConfig.BUFF_TOTEM then
         self.m_bIsSummonMsg = true
        table.insert(self.m_tStepFunction,{self._waitMonsterId})
        table.insert(self.m_tStepFunction,{self._buildBuffTotem})
    elseif skillType == EffectTypeConfig.IMMUNITY_BUFF_ASSIGN then
        table.insert(self.m_tStepFunction,{self._immunityBuff,param})
    elseif skillType == EffectTypeConfig.IMMUNITY_EFFECT_ASSIGN then
        table.insert(self.m_tStepFunction,{self._immunityEffect,param})
    elseif skillType == EffectTypeConfig.TRANSFER_POSITION then
        table.insert(self.m_tStepFunction,{self._transferPositionStart,param})
        table.insert(self.m_tStepFunction,{self._waitForTransEffect})
        table.insert(self.m_tStepFunction,{self._transferPosition})
    elseif skillType == EffectTypeConfig.POINT_LINE_ADD then
        table.insert(self.m_tStepFunction,{self._pointLineAdd,param})
    end

end




-------------------------------------私有方法模块--------------------------------------

--@brief    获取效果配置
function BattleMsgBossMapSkill:_getEffectConfig()
    WZLog("BattleMsgBossMapSkill:_getEffectConfig", self.m_nEffcetId)
    local skillInfo = self:_getSkillData(self.m_nEffcetId)

    if skillInfo.skill_type == 0 or skillInfo.skill_type == 2 then
        self.m_tOwner.m_fRadiusForBulletExplodeChange = (skillInfo.scope > 0 and skillInfo.scope) or nil
    end
    if type(skillInfo.boom_scope) == "table" then
        self.m_tOwner.m_fRectForBulletExplodeBombChange = {x=skillInfo.boom_scope[1][1],y=skillInfo.boom_scope[1][2]}
        WZLog("BattleMsgBossMapSkill:_getEffectConfig one", skillInfo.effect_id[1][1], Serialize(skillInfo.boom_scope))
    end
    self.m_tOwner.m_tSkillCdList[self.m_nEffcetId] = skillInfo.cooling_time

    if skillInfo.skill_type ~= 1 and skillInfo.skill_type ~= 4 and skillInfo.skill_type ~= 5 and skillInfo.skill_type ~= 9 then
        self.m_tOwner.m_bIsUseSkill = true
    end
    local config = self:_getEffectData(skillInfo.effect_id[1][1])
    self.m_tEffcetConfig = config
    self.m_tEffcetInfo = skillInfo

    self.m_tEffcetConfig = config.effect

    if skillInfo.sub_type == SkillTableTypeConfig.FROZEN then
        self.m_tOwner:setCanFrozen(true)
        --self.m_tOwner:setCanFollow(true)
    elseif skillInfo.sub_type == SkillTableTypeConfig.NBOMB then
        self.m_tOwner.m_bWeaponAtomicBomb = true
    elseif skillInfo.sub_type == SkillTableTypeConfig.POWER then
        self.m_tOwner.m_bIsPowerBomb = true
    elseif skillInfo.sub_type == SkillTableTypeConfig.IMPACT then
        self.m_tOwner.m_bIsRepulse = true
    elseif skillInfo.sub_type == SkillTableTypeConfig.TRACK then
        self.m_tOwner:setCanFollow(true)
    elseif skillInfo.sub_type == SkillTableTypeConfig.POISION then
        self.m_tOwner.m_bIsPoisonBomb = true
    elseif skillInfo.sub_type == SkillTableTypeConfig.SILENCE then
        self.m_tOwner.m_bIsSilentBomb = true
    elseif skillInfo.sub_type == SkillTableTypeConfig.BOUND then
        self.m_tOwner.m_bIsBindBomb = true
    elseif skillInfo.sub_type == SkillTableTypeConfig.TORNADO then
        self.m_tOwner.m_bIsTornadoBomb = true
    elseif skillInfo.sub_type == SkillTableTypeConfig.SPATTER then
        self.m_tOwner.m_bIsSpatterBomb = true
    elseif skillInfo.sub_type == SkillTableTypeConfig.MIST then
        self.m_tOwner.m_bIsMistBomb = true
    elseif skillInfo.sub_type == SkillTableTypeConfig.CURE then
        self.m_tOwner.m_bIsCureBomb = true
    elseif skillInfo.sub_type == SkillTableTypeConfig.TRANSFER_POSITION then
        self.m_tOwner.m_tIsTransferPosBomb = true
    end
    WZLog("BattleMsgBossMapSkill:_getEffectConfig two", self.m_nEffcetId, skillInfo.effect_id[1][1], Serialize(self.m_tEffcetConfig), Serialize(self.m_tOwner.m_fRectForBulletExplodeBombChange or {}))
end

--@brief    效果生效
function BattleMsgBossMapSkill:_doEffect()
    local skillInfo = self:_getSkillData(self.m_nEffcetId)
    WZLog("BattleMsgBossMapSkill:_doEffect", Serialize(self.m_tEffcetConfig), Serialize(skillInfo))

    local effect = self.m_tEffcetConfig
    local boss = self.m_tOwner
    for i, skillParm in pairs (effect) do
        local effectParm = skillParm
        local takeEffectParm = effectParm[1]

        local turnTime = WBattleGlobal:getCurrent().m_nTurnTimes
        local effect = effectParm[3] .. "_" ..effectParm[4]
        WZLog("BattleMsgBossMapSkill:_doEffect one", takeEffectParm, tostring(boss.m_bActiveAttack), tostring(effectParm.isTakeEffect), turnTime, tostring(effectParm.isTakeEffect), tostring(effectParm.isTakeEffect == nil or turnTime > effectParm.isTakeEffect))
        local isCanTakeEffect = false
        if boss.m_tSkillTakeEffectInfo == self.m_nEffcetId and boss.m_tSkillTakeEffectIndex and #boss.m_tSkillTakeEffectIndex > 0 then
            for j,u in pairs (boss.m_tSkillTakeEffectIndex) do
                if i == u then
                    isCanTakeEffect = true
                    break
                end
            end
        else
            isCanTakeEffect = nil
        end
        if ((isCanTakeEffect == nil and (takeEffectParm == TakeEffectType.USE or 
            (boss.m_bActiveAttack == true and takeEffectParm == TakeEffectType.HIT and (skillInfo.skill_type ~= 4 or (skillInfo.sub_type == 1 or skillInfo.sub_type == 0 and boss.m_bPetActiveAttack))) or 
            (boss.m_bActiveAttack == true and takeEffectParm == TakeEffectType.COLLISION))) or 
            isCanTakeEffect == true) and (effectParm.isTakeEffect == nil or 
            turnTime > effectParm.isTakeEffect) then

            local targetParm = effectParm[2]
            effectParm.isTakeEffect = turnTime
            if self.m_tTargetPlayerId and GDatatab_skill["id_" .. self.m_nSkillId].skill_type == 9 then 
                targetHeroList = self:_getHeroById(self.m_tTargetPlayerId)
            else
                targetHeroList = self:_chooseEffectTarget(takeEffectParm,targetParm)
            end
        
            if takeEffectParm == TakeEffectType.HIT then
                for i, v in pairs(targetHeroList) do
                    local isExist = false
                    if boss.m_tSkillTakeEffectList ~= nil then
                        for j, u in pairs(boss.m_tSkillTakeEffectList) do
                            if v:getBattleId() == u then
                                isExist = true
                            end
                        end
                    else
                        boss.m_tSkillTakeEffectList = {}
                    end
                    if isExist == false then
                        table.insert(boss.m_tSkillTakeEffectList,v:getBattleId())
                    end
                end
            end
            
            WZLog("BattleMsgBossMapSkill:_doEffect two", #targetHeroList,tostring(takeEffectParm), tostring(targetParm), effect, tostring(effectParm[5]), tostring(effectParm[6]))
            self:_doEffectType(effectParm,targetHeroList,nil)
            local effect = effectParm[3] .. "_" ..effectParm[4]
            self:addStep(effect, targetHeroList, nil)
        elseif skillInfo.skill_type == 4 and skillInfo.sub_type == 0 and takeEffectParm == TakeEffectType.HIT then
            boss.m_tPetSkillTakeEffectInfo = boss.m_tPetSkillTakeEffectInfo or {}
            table.insert(boss.m_tPetSkillTakeEffectInfo, self.m_nEffcetId)
            WZLog("pet hit use effect",self.m_nEffcetId)
        elseif boss.m_bActiveAttack ~= true and takeEffectParm == TakeEffectType.HIT then

            boss.m_tSkillTakeEffectList = {}
            boss.m_tSkillTakeEffectInfo = self.m_nEffcetId
            if boss.m_tSkillTakeEffectIndex == nil then
                boss.m_tSkillTakeEffectIndex = {}
            end
            table.insert(boss.m_tSkillTakeEffectIndex, i)
            local effect = effectParm[3] .. "_" ..effectParm[4]

            if effect == EffectTypeConfig.REPEL_FLY or effect == EffectTypeConfig.REPEL_FLY_BOSS then
                self.m_tOwner.m_nWeaponRepulseDis = self.m_nRepelFlyX
            elseif effect == EffectTypeConfig.SPATTER then
                self.m_tOwner.m_nIsSpatter = true
            end
            WZLog("hit use effect",self.m_nEffcetId, effect)
        elseif boss.m_bActiveAttack ~= true and takeEffectParm == TakeEffectType.COLLISION then
            local effect = effectParm[3] .. "_" ..effectParm[4]
            WZLog("碰撞后生效2",self.m_nEffcetId, effect)
            boss.m_tSkillTakeEffectCollionList = {}
            boss.m_tSkillTakeEffectCollionInfo = self.m_nEffcetId
            if boss.m_tSkillTakeEffectCollionIndex == nil then
                boss.m_tSkillTakeEffectCollionIndex = {}
            end
            table.insert(boss.m_tSkillTakeEffectCollionIndex, i)
            

            if effect == EffectTypeConfig.REPEL_FLY or effect == EffectTypeConfig.REPEL_FLY_BOSS then
                self.m_tOwner.m_nWeaponRepulseDis = self.m_nRepelFlyX
            elseif effect == EffectTypeConfig.SPATTER then
                self.m_tOwner.m_nIsSpatter = true
            end

        end
    end
end

--@brief    选择目标
function BattleMsgBossMapSkill:_doEffectType(effectParm,targetHeroList,isBuff)
    WZLog("BattleMsgBossMapSkill:_doEffectType", Serialize(effectParm))
    local isEndEffect = nil
    local boss = self.m_tOwner
    local effect = effectParm[3] .. "_" ..effectParm[4]
    local flashParam = {} 
    local flashParent = {}
    if effect == EffectTypeConfig.PET_CRIT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-31", i)
        self.m_nPetCritValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-32", i)
        self.m_nChangeHurtPercentIndex = effectParm[5]
        self.m_nChangeHurtPercent = effectParm[6]
    elseif effect == EffectTypeConfig.CANCEL_BUFF_ASSIGN then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-33", i)
        self.m_nCancelBuffAssign = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-1", i)
        self.m_nChangeValueIndex = effectParm[5]
        self.m_nChangeValue = effectParm[6]
    elseif effect == EffectTypeConfig.CHANGE_CTB_VALUE then
        self.m_nChangeValue = -effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-2", i)
        self.m_nChangePercentIndex = effectParm[5]
        self.m_nChangePercent = effectParm[6]
    elseif effect == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_ATTACK then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-2", i)
        self.m_nChangePercentIndexAttack = effectParm[5]
        self.m_nChangePercentAttack = effectParm[6]
    elseif effect == EffectTypeConfig.SCATTER_SHOOT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-3", i)
        self.m_nAttScatterNum = effectParm[5]
    elseif effect == EffectTypeConfig.TIMES_SHOOT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-4", i)
        self.m_nAttTimes = effectParm[5]
    elseif effect == EffectTypeConfig.SPEC_SHOOT then
        self.m_nBulletId = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_HURT_VALUE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-5", i)
        self.m_nHurtChangeValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_HURT_PERCENT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-6", i)
        self.m_nHurtAddPercent = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_HURT_ADD_VALUE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-7", i)
        self.m_nHurtAddValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_BEHURT_VALUE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-8", i)
        self.m_nBeHurtChangeValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_BEHURT_PERCENT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-9", i)
        self.m_nBeHurtAddPercent = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_BEHURT_ADD_VALUE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-10", i)
        self.m_nBeHurtAddValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-64", i)
        self.m_nCritHurtAddPercent = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-65", i)
        self.m_nBeCritHurtAddPercent = effectParm[5]
        elseif effect == EffectTypeConfig.CHANGE_CRIT_HURT_ADD_VALUE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-66", i)
        self.m_nCritHurtAddValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_BECRIT_HURT_ADD_VALUE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-67", i)
        self.m_nBeCritHurtAddValue = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_RECOVERY_PERCENT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-68", i)
        self.m_nRecoveryAddPercent = effectParm[5]
    elseif effect == EffectTypeConfig.NO_HOLE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-69", i)
        self.m_nNoHole = effectParm[5]
    elseif effect == EffectTypeConfig.CHANGE_HURT_MUL_PERCENT then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-70", i)
        self.m_nHurtMulPercent = effectParm[5] / 100
    elseif effect == EffectTypeConfig.HIDE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-11", i)
        self.m_nHideTurn = effectParm[5]
    elseif effect == EffectTypeConfig.REPEL_FLY or effect == EffectTypeConfig.REPEL_FLY_BOSS then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-13", i)
        self.m_nRepelFlyX = effectParm[5]
        self.m_nRepelFlyY = effectParm[6]
    elseif effect == EffectTypeConfig.TRANSFER_MOVE then
        self.m_nTransferMoveDistance = effectParm[5]
    elseif effect == EffectTypeConfig.ADD_BUFF then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-14", i)
        self.m_nAddBuffId = self.m_nAddBuffId or {}
        table.insert(self.m_nAddBuffId, effectParm[5])
    elseif effect == EffectTypeConfig.CANCEL_BUFF_ALL then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-14-1", i)
    elseif effect == EffectTypeConfig.CANCEL_BUFF_TYPE then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-14-2", i)
        self.m_nCancelBuffType = effectParm[5]
    elseif effect == EffectTypeConfig.CANCEL_BUFF_ID then
        WZLog("BattleMsgBossMapSkill:_doEffect seven-14-3", i)
        self.m_nCancelBuffId = effectParm[5]
    elseif effect == EffectTypeConfig.FLY then
        BattleHeroUse:useFly(boss:getBattleId())
    elseif effect == EffectTypeConfig.TRANSFER_MOVE then
        self.m_nTransferMoveDistance = effectParm[5]
    elseif effect == EffectTypeConfig.TRANS then
        WZLog("BattleMsgBossMapSkill:_doSkillEffect three", i)
        local monsterData = BossData["id_"..effectParm[3]]
        self.m_nTransAniFileId = monsterData.AniFileId
        self.m_nTransAiType = monsterData.attack_type
        self.m_nTransDataId = effectParm[5]
    elseif effect == EffectTypeConfig.HURT then
        WZLog("BattleMsgBossMapSkill:_doSkillEffect four-1", i)
        self.m_nHurtType = effectParm[5] or HurtTypeConfig.CALCULATE
        self.m_nHurtIndex = effectParm[6]
    elseif effect == EffectTypeConfig.RECOVERY then
        WZLog("BattleMsgBossMapSkill:_doSkillEffect four-2", i)
        self.m_nHurtType = effectParm[5] or HurtTypeConfig.CALCULATE_RESTORE
        self.m_nHurtIndex = effectParm[6]
    elseif effect == EffectTypeConfig.MOVE then
        WZLog("BattleMsgBossMapSkill:_doSkillEffect five", i)

        local moveMonsterList = {}
        self.m_tOwner:getNearestPlayer()
        table.insert(moveMonsterList, self.m_tOwner)

        local atkParm = nil
        local moveParm = nil
        local bossPos = self.m_tOwner:getPosition()

        if effectParm[5] ~= nil and effectParm[5] ~= 0 and effectParm[6] ~= nil and effectParm[6] ~= 0 then
            moveParm = BattleCommon:getPointTable(bossPos.x + effectParm[5], bossPos.y + effectParm[6])
        elseif effectParm[5] ~= nil and effectParm[5] ~= 0 then
            moveParm = BattleCommon:getPointTable(bossPos.x + effectParm[5], 0)
        elseif effectParm[6] ~= nil and effectParm[6] ~= 0 then
            moveParm = BattleCommon:getPointTable(0, bossPos.y + effectParm[6])
        end

        self.m_tMonsterList = moveMonsterList
        self.m_tMoveEndPos = moveParm
    elseif effect == EffectTypeConfig.INVINCIBLE then
        WZLog("BattleMsgBossMapSkill:_doSkillEffect six", i)
    elseif effect == EffectTypeConfig.SUMMON then
        WZLog("BattleMsgBossMapSkill:_doSkillEffect eight", i)

        local summonMonsterList = {}
        local posX = {}
        local posY = {}
        for i = 1, effectParm[6] do
            if effectParm[(6+2*i)] ~= nil and effectParm[(7+2*i)] ~= nil then
                table.insert(posX, effectParm[(6+2*i)])
                table.insert(posY, effectParm[(7+2*i)])
            else
                for index, condition in ipairs (self.m_tConditionList) do
                    if condition.conditionType == AiConditionConfig.ACTIVE_ATTACK then
                        table.insert(posX, boss.m_tActiveAttackPos.x)
                        table.insert(posY, boss.m_tActiveAttackPos.y)
                        WZLog("WMonsterAI:doAction three-1", boss.m_tActiveAttackPos.x, boss.m_tActiveAttackPos.y)
                        break
                    end
                end
            end
        end
        table.insert(summonMonsterList, {battleId={},id=effectParm[5],count=effectParm[6],maxCount=effectParm[7],scale=BossData["id_"..effectParm[5]].scale,posX=posX,posY=posY})
        --WZLog("WMonsterAI:doAction three-2", parms.actionParm1, parms.actionParm2, parms.actionParm3, parms.actionParm4, 1, parms.actionParm6, parms.actionParm7, parms.actionParm8)

        self.m_tSummonMonsterList = summonMonsterList
    elseif effect == EffectTypeConfig.TRANSFER then
        for index, condition in ipairs (self.m_tConditionList) do
            if condition.conditionType == AiConditionConfig.ACTIVE_ATTACK then
                targetHeroList = boss.m_tActiveAttackHero
                break
            end
        end
        self.m_tTransferPos = {}
        for i = 1 , (#effectParm - 2) / 2 do
            table.insert(self.m_tTransferPos, BattleCommon:getPointTable(effectParm[5+(i-1)*2],effectParm[6+(i-1)*2]))
        end
    elseif effect == EffectTypeConfig.EFFECT_TIPS_IN then
        local pos = nil
        if effectParm[6] == 2 then
            pos = BattleCommon:getPointTable(0,0)
        else
            pos = targetHeroList[1]:getPosition()
            pos.y = SceneBattle:getFrontLayer():getContentSize().height / 2
        end
        self.m_tOwner:setTmpState(effectParm[5])
        self.m_tOwner:setAttackPos(pos)
    elseif effect == EffectTypeConfig.EFFECT_TIPS_OUT then
        self.m_tOwner:setTmpState(nil)
        self.m_isClearAttackPos = true
        self:_doSkillEffectEnd(effect, effectParm[5],flashParam,flashParent,isMoment)
        isEndEffect = "break" --传递参数不一样 不调用通用结尾
    elseif effect == EffectTypeConfig.MONSTER_CHANGE_STATE then
       self:_doSkillEffectEnd(effect, effectParm[5],flashParam,flashParent,isMoment)
        isEndEffect = "break" --传递参数不一样 不调用通用结尾
    elseif effect == EffectTypeConfig.CREATE_EFFECT_ME then
        table.insert(flashParam, effectParm[5])
        table.insert(flashParent, EffectPosType.MYSELF)
    elseif effect == EffectTypeConfig.CREATE_EFFECT_TARGET then
        table.insert(flashParam, effectParm[5])
        table.insert(flashParent, EffectPosType.TARGET)
    elseif effect == EffectTypeConfig.CREATE_EFFECT_SCENE then
        table.insert(flashParam, effectParm[5])
        table.insert(flashParent, EffectPosType.SCENE)
    elseif effect == EffectTypeConfig.CREATE_EFFECT_LINE then
        table.insert(flashParam, effectParm[6])
        table.insert(flashParent, EffectPosType.LINE)
        table.insert(flashParam, effectParm[5])
        table.insert(flashParent, EffectPosType.MYSELF)
        table.insert(flashParam, effectParm[7])
        table.insert(flashParent, EffectPosType.TARGET)
    elseif effect == EffectTypeConfig.DEAD then
        self:addStep(effect, targetHeroList)
        isEndEffect = "return"
    elseif effect == EffectTypeConfig.TORNADO then
        if self:_isGhostSkill(self.m_nSkillId) and self.m_tOwnPlayerId then 
            local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tOwnPlayerId)
            self.m_tTornadoInfo = {battleId = hero:getBattleId() + 1000,templateId = effectParm[6], camp=hero:getCamp(), bronPos={x=self.m_tOwner:getPosition().x, y=self.m_tOwner:getPosition().y}}
            self.m_tSummonMonsterId = {}
            self.m_tSummonMonsterBattleId = {}
            hero.m_tCursummonList = {}
            local count = effectParm[5]
            for i = 1,count,1 do
                local index = 5 + i
                local posIndex = 6 + count + (i - 1)*2
                local templateId = effectParm[index]
               
                WZLog("BattleMsgSkillEffect:_doEffect summon",index,posIndex)
                table.insert(self.m_tSummonMonsterId,templateId)
            end
        else
            WZLog("BattleMsgBossMapSkill:_doEffect nine-2", targetHeroList[1]:getBattleId(), targetHeroList[1]:getCamp(), targetHeroList[1].m_tActiveAttackPos[1].x,targetHeroList[1].m_tActiveAttackPos[1].y)
            self.m_tTornadoInfo = {battleId = self.m_tOwner:getBattleId() + 1000,templateId = effectParm[6], camp=targetHeroList[1]:getCamp(), bronPos=CopyTable(targetHeroList[1].m_tActiveAttackPos[1])}
            self.m_tSummonMonsterId = {}
            self.m_tSummonMonsterBattleId = {}
            self.m_tOwner.m_tCursummonList = {}
            local count = effectParm[5]
            for i = 1,count,1 do
                local index = 5 + i
                local posIndex = 6 + count + (i - 1)*2
                local templateId = effectParm[index]
               
                WZLog("BattleMsgSkillEffect:_doEffect summon",index,posIndex)
                table.insert(self.m_tSummonMonsterId,templateId)
            end
        end
    elseif effect == EffectTypeConfig.SPATTER then
        WZLog("BattleMsgBossMapSkill:_doEffect nine-3")
        self.m_tSpatterInfo = {pos=CopyTable(targetHeroList[1].m_tActiveAttackPos[1]),speed=CopyTable(targetHeroList[1].m_tActiveAttackSpeed[1]),count=effectParm[5],hurtSkillId=effectParm[6]}
    elseif effect == EffectTypeConfig.TREAT_TOTEM or effect == EffectTypeConfig.BUFF_TOTEM then
        WZLog("BattleMsgBossMapSkill:_doEffect EffectTypeConfig.TREAT_TOTEM",effectParm[5],effectParm[6],effectParm[7])
        local tmpBronPos = {x = targetHeroList[1]:getPosition().x - 30,y = targetHeroList[1]:getPosition().y + 100}
        self.m_tTreatTotemInfo = {battleId = self.m_tOwner:getBattleId() + 1000,templateId = effectParm[6],bronPos = tmpBronPos,charaId=targetHeroList[1]:getBattleId(), camp=targetHeroList[1]:getCamp()}
        self.m_tSummonMonsterId = {}
        self.m_tSummonMonsterBattleId = {}
        self.m_tOwner.m_tCursummonList = {}
        local count = effectParm[5]
        for i = 1,count,1 do
            local index = 5 + i
            local posIndex = 6 + count + (i - 1)*2
            local templateId = effectParm[index]
            local posX = -100
            local posY = 500
            WZLog("BattleMsgSkillEffect:_doEffect summon",index,posIndex)
            table.insert(self.m_tSummonMonsterId,templateId)
        end
    elseif effect == EffectTypeConfig.IMMUNITY_BUFF_ASSIGN then
        self.m_nImmunityBuffType = effectParm[5]
    elseif effect == EffectTypeConfig.IMMUNITY_EFFECT_ASSIGN then
        self.m_nImmunityEffectType = effectParm[5].. "_" ..effectParm[6]
    elseif effect == EffectTypeConfig.TRACK_SHOOT then
        self.m_tOwner:setCanFollow(true)
    elseif effect == EffectTypeConfig.PENETRATE_SHOOT then
        self.m_tOwner:setCanPenetrate(true)
    elseif tostring(effectParm[3]) == EffectTypeConfig.HURT_OFF_TARGET then
        for i,v in pairs(targetHeroList) do
            v.m_nHurtOffState = effectParm[4]
        end
    elseif effect == EffectTypeConfig.POINT_LINE_ADD then
        self.m_nPointLineValue = {range = effectParm[5],rangeY = effectParm[6],count = effectParm[7]}
    end
    return isEndEffect,flashParam,flashParent
end

--@brief    选择目标
--@param 触发类型 
function BattleMsgBossMapSkill:_chooseEffectTarget(takeType,effectParm)
    local chooseTargetType = effectParm
    self.m_tTargetHeroList = {}

    if chooseTargetType == EffectTargetType.MYSELF then
        table.insert(self.m_tTargetHeroList, self.m_tOwner)
    elseif chooseTargetType == EffectTargetType.SKLL_TO then
        return self.m_tSkillTargetChoose
    end

    --区分命中目标
    local tHeroList = WBattleGlobal:getCurrent():getCharacterList()
    if takeType == TakeEffectType.HIT then
        if self.m_tOwner.m_bPetActiveAttack then
            tHeroList = {self.m_tOwner.m_tPetAttackHero}
        else
            tHeroList = self.m_tOwner.m_tHitTargets or {}
        end
    end

    for i, chara in pairs(tHeroList) do
        local isMacth = false
        local battleId = self.m_tOwner:getBattleId()
        local tBattleId = chara:getBattleId()
        if chooseTargetType == EffectTargetType.HIT_ROLE then
            isMacth = true
        elseif chooseTargetType== EffectTargetType.MYTEAM then
            if chara:getHp() > 0 and not chara:isDead() and WBattleGlobal:getCurrent():isSameTeam(battleId,tBattleId) then
                isMacth = true
            end
        elseif chooseTargetType == EffectTargetType.ENEMY then
            if chara:getHp() > 0 and not chara:isDead() and not WBattleGlobal:getCurrent():isSameTeam(battleId,tBattleId) then
                isMacth = true
            end
        end
        if isMacth then
            table.insert(self.m_tTargetHeroList,chara)
        end
    end
   
    WZLog("BattleMsgBossMapSkill:_chooseEffectTarget", tostring(self.m_tOwner.m_bPetActiveAttack),effectParm,#self.m_tTargetHeroList)
    return self.m_tTargetHeroList
end

--@brief 申请战斗id
function BattleMsgBossMapSkill:_requestMonsterId()
    WZLog("BattleMsgBossMapSkill:_requestMonsterId", tostring(self.m_tOwner:isCanControl()))
    if not self.m_tSummonMonsterId then
         WZLog("BattleMsgBossMapSkill:_requestMonsterId false")
        return true
    end

    if self.m_bIsSummon == nil then
        self.m_bIsSummon = true
        self.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        self.m_nCurrentId = self.m_tOwner:getBattleId()


        if  self.m_tOwner:isCanControl() then
            WZLog("BattleMsgBossMapSkill:_requestMonsterId two", self.m_nBattleId, self.m_nCurrentId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)

            ProtocolProcessorBattleInterface:send_BATTLE_BuildGuai(self.m_nBattleId,  self.m_nCurrentId,
                                                                    self.m_tSummonMonsterId,
                                                                   self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)
        else
            self.m_bClientSummon = true
        end

        if WBattleGlobal:getCurrent():isSingleStage() then
            self.m_bIsSummon = nil
            return true
        end
    end
    --客机使用召唤技能，等待battleId过程，转为可以控制的主机，发送召唤申请
    if not WBattleGlobal:getCurrent():isSingleStage() and self.m_bClientSummon and self.m_tOwner:isCanControl() then
        self.m_bClientSummon = nil
        WZLog("BattleMsgSkillShow:_requestMonsterId two", self.m_nBattleId, self.m_nPlayerOrGuai, self.m_nCurrentId, #self.m_tSummonMonsterBattleId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)

        ProtocolProcessorBattleInterface:send_BATTLE_BuildGuai(self.m_nBattleId,  self.m_nCurrentId,
                                                                self.m_tSummonMonsterId,
                                                               self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)
    end

    if self.m_tOwner.guaiId ~= nil and #self.m_tOwner.guaiId > 0 then  
        self.m_bIsSummon = nil
        return true
    else
        WZLog("BattleMsgBossMapSkill:_requestMonsterId wait")
        return false
    end
end

--溅射
function BattleMsgBossMapSkill:_spatter()
    WZLog("BattleMsgBossMapSkill:_spatter", self.m_tSpatterInfo.count, self.m_tSpatterInfo.hurtSkillId)
    if not self.m_bSpatterInit then
        if self.m_tOwner:isCanControl() then
            ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_tOwner:getBattleId(), self.m_tSpatterInfo.hurtSkillId)
        end
        
        local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
        msg.m_nId = nil --不发协议
        msg.m_tOwner = self.m_tOwner
        msg.m_tSkillTypeList = {[1]=SkillTypeConfig.HIT_DO_EFFECT}
        msg.m_nSkillId = self.m_tSpatterInfo.hurtSkillId
        msg.m_nTakeEffectType = TakeEffectType.USE
        msg.m_tSpatterAngle = self.m_tSpatterAngle
        msg.m_tCallBackFunc = {self._createBulletSpatter,self,self.m_tSpatterInfo.count}
        MsgManager:pushNonBlockMsg(msg)

        self.m_bSpatterDone = false
        self.m_bSpatterInit = true
    end

    return self.m_bSpatterDone
    -- self:_createBulletSpatter(self.m_tSpatterInfo.count)
end

--@brief    创建溅射子弹
--@param    nScatterNum:溅射数量
function BattleMsgBossMapSkill:_createBulletSpatter(nScatterNum)
    --单人副本，生成溅射弹角度
    if WBattleGlobal:getCurrent():isSingleStage() then 
        local tSpatterAngle = GetRandomNum(nScatterNum + 2, 110, 70)
        WBattleGlobal:getCurrent():setCurSpatterAngle(tSpatterAngle)
    end

    local speedx, speedy, startX, startY, isCollision = self.m_tSpatterInfo.speed.x, self.m_tSpatterInfo.speed.y, self.m_tSpatterInfo.pos.x, self.m_tSpatterInfo.pos.y, self.m_tSpatterInfo.speed.isCollision

    local dire = 1
    -- if isCollision then
    --     dire = speedy < 0 and 1 or -1
    -- else
    --     dire = 1
    -- end
    local maxSpeed = math.max(speedx, speedy)
    speedx, speedy = 0,(math.abs(maxSpeed) < 20 and 20 * dire) or (math.abs(maxSpeed) < 22 and 22 * dire) or 25 * dire

    WZLog("BattleMsgBossMapSkill:_createBulletSpatter two", nScatterNum, startX, startY, tostring(speedx),tostring(speedy), self.m_tSpatterInfo.speed.y, tostring(isCollision))

    local hero = self.m_tOwner
    if hero:getWeaponType() == 0 then
        SoundManager:playEffectSound(SoundDefine.E_S_SHOOT_1)
    else
        SoundManager:playEffectSound(SoundDefine.E_S_SHOOT_2)
    end

    local startAngle = 0
--    startAngle = -1 * BattleConstants.g_fWB_SCATTER_ANGLE * (math.floor(nScatterNum / 2) - (nScatterNum+1)%2/2)
    self.m_tSpatterAngle = WBattleGlobal:getCurrent():getCurSpatterAngle()
    WZLog("BattleMsgBossMapSkill:_createBulletSpatter three", type(self.m_tSpatterAngle), #self.m_tSpatterAngle, Serialize(self.m_tSpatterAngle))
    self.m_nSpatterIndex = 1
    self.m_tSpeedPt = {x=speedx,y=speedy}
    self:_showOtherSpatter()
--    DelayCallFunction(self._showOtherSpatter, self, 0.5)
--    SceneBattle:getFrontLayer():enableSchedule("_showOtherSpatter", 0.5)
    -- local speedVec = BattleCommon:vectorWithAngle({x=speedx,y=speedy}, startAngle)
    -- for i=1,nScatterNum do
    --     speedVec.x = tonumber(string.format("%.4f",speedVec.x))
    --     speedVec.y = tonumber(string.format("%.4f",speedVec.y))
    --     WZLog("BattleMsgBossMapSkill:_createBulletSpatter three",i,startX,startY,speedVec.x,speedVec.y)
    --     local bullet = WBattleGlobal:getCurrent():buildBullet(self.m_tOwner:getBattleId(),startX,startY,speedVec.x,speedVec.y, true)
    --     if speedx > 0 then
    --         bullet:getAnimation():getAnimNode():setFlipY(true)
    --     end
    --     --[[
    --     if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
    --         SceneBattle:getFrontLayer():addChild(bullet:getBackFire():getParent(),2)
    --     end
    --     ]]
    --     SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode(),3)

    --     -- local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    --     -- if hero:isHide() == true then
    --     --     if WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) then
    --     --         bullet:getAnimation():getAnimNode():setOpacity(51)
    --     --     else
    --     --         bullet:getAnimation():getAnimNode():setOpacity(0)
    --     --     end
    --     --     if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
    --     --         bullet:getBackFire():setVisible(false)
    --     --     end
    --     -- end

    -- --    speedVec = BattleCommon:vectorWithAngle(speedVec,BattleConstants.g_fWB_SCATTER_ANGLE)
    --     if self.m_tSpatterAngle[i + 1] then 
    --         speedVec = BattleCommon:vectorWithAngle({x=speedx,y=speedy}, self.m_tSpatterAngle[i + 1])
    --     end
    -- end

    -- if (MsgManager.m_tBlockMsgList ~= nil and MsgManager.m_tBlockMsgList[1] ~= nil and MsgManager.m_tBlockMsgList[1].m_nBuildBulletsSkillStatusCount >= 1) then
    --     MsgManager.m_tBlockMsgList[1].m_nBuildBulletsSkillStatusCount = MsgManager.m_tBlockMsgList[1].m_nBuildBulletsSkillStatusCount - 1
    -- end

    -- self.m_bSpatterDone = true
end

--@brief    生成溅射弹
function BattleMsgBossMapSkill:_showOtherSpatter(element, dt)
    -- body
    if self.m_nSpatterIndex > self.m_tSpatterInfo.count then 
        WZLog("BattleMsgBossMapSkill:_showOtherSpatter 00000")
        if (MsgManager.m_tBlockMsgList ~= nil and MsgManager.m_tBlockMsgList[1] ~= nil and MsgManager.m_tBlockMsgList[1].m_nBuildBulletsSkillStatusCount >= 1) then
            MsgManager.m_tBlockMsgList[1].m_nBuildBulletsSkillStatusCount = MsgManager.m_tBlockMsgList[1].m_nBuildBulletsSkillStatusCount - 1
        end
        if g_SpatterScheduleId then 
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_SpatterScheduleId)
            g_SpatterScheduleId = nil 
        end
        self.m_bSpatterDone = true
        return 
    else
        g_SpatterScheduleId = DelayCallFunction(self._showOtherSpatter, self, 0.2)
    end
    local startX, startY = self.m_tSpatterInfo.pos.x, self.m_tSpatterInfo.pos.y

    local speedVec = BattleCommon:vectorWithAngle(self.m_tSpeedPt, self.m_tSpatterAngle[self.m_nSpatterIndex])
    speedVec.x = tonumber(string.format("%.4f",speedVec.x))
    speedVec.y = tonumber(string.format("%.4f",speedVec.y))
    WZLog("BattleMsgBossMapSkill:_showOtherSpatter", speedVec.x, speedVec.y)
    local bullet = WBattleGlobal:getCurrent():buildBullet(self.m_tOwner:getBattleId(), startX, startY, speedVec.x, speedVec.y, true)
    if self.m_tSpeedPt.x > 0 then
        bullet:getAnimation():getAnimNode():setFlipY(true)
    end
    --[[
    if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
        SceneBattle:getFrontLayer():addChild(bullet:getBackFire():getParent(),2)
    end
    ]]
    SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode(),3)

    -- local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    -- if hero:isHide() == true then
    --     if WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) then
    --         bullet:getAnimation():getAnimNode():setOpacity(51)
    --     else
    --         bullet:getAnimation():getAnimNode():setOpacity(0)
    --     end
    --     if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
    --         bullet:getBackFire():setVisible(false)
    --     end
    -- end

--    speedVec = BattleCommon:vectorWithAngle(speedVec,BattleConstants.g_fWB_SCATTER_ANGLE)
    self.m_nSpatterIndex = self.m_nSpatterIndex + 1
end

--生成龙卷风
function BattleMsgBossMapSkill:_buildTornado()
    WZLog("BattleMsgBossMapSkill:_buildTornado", self.m_tTornadoInfo.camp,self.m_tTornadoInfo.templateId)
    if not WBattleGlobal:getCurrent():isSingleStage() then
        --只创建一个 直接赋值
        for i=1,#self.m_tSummonMonsterId do
             for j, v in pairs(self.m_tOwner.guaiId) do
                if self.m_tSummonMonsterId[i] == v then
                    self.m_tTornadoInfo.battleId = self.m_tOwner.guaiBattleId[j]
                    table.remove(self.m_tOwner.guaiId, j)
                    table.remove(self.m_tOwner.guaiBattleId, j)
                    table.remove(self.m_tOwner.guaiPositionX, j)
                    table.remove(self.m_tOwner.guaiPositionY, j)
                    break
                end
            end
        end
    else
        --单人副本创建小怪 为小怪添加battleId
        self.m_tTornadoInfo.battleId = WBattleGlobal:getCurrent():getBuildGuaiBattleId(true)
    end

    local tornado = WBattleGlobal:getCurrent():buildMachine(MonsterType.TORANDO,self.m_tTornadoInfo)
    SceneBattle:getFrontLayer():addChild(tornado.m_anim:getAnimNode())
    -- if WBattleGlobal:getCurrent().m_tMapEvents == nil then
    --     WBattleGlobal:getCurrent().m_tMapEvents = {}
    -- end

    -- local chara = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tTornadoInfo.charaId)
    -- chara:endTornado()

    -- local mapEvent = MapEnenvtTornado:buildEvent(1, "龙卷风", effect1, effect2, self.m_tTornadoInfo)
    -- if mapEvent ~= nil then
    --     table.insert(WBattleGlobal:getCurrent().m_tMapEvents, mapEvent)
    -- end

end

--@brief 等待怪物id
function BattleMsgBossMapSkill:_waitMonsterId()
    if  WBattleGlobal:getCurrent():isSingleStage() then 
        return true
    end

    if self.m_tOwner.guaiId == nil or #self.m_tOwner.guaiId == 0 then 
        WZLog("BattleMsgBossMapSkill:_waitMonsterId wait")
        self.m_bIsWaitMonsterId = true
        return false
    end
    self.m_bIsWaitMonsterId = false
    return true
end

--@brief 等待怪物id
function BattleMsgBossMapSkill:_waitGhostMonsterId()
    if  WBattleGlobal:getCurrent():isSingleStage() then 
        return true
    end
    
    if self.m_tOwnPlayerId == nil then return true end 

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tOwnPlayerId)
    if hero.guaiId == nil or #hero.guaiId == 0 then 
        WZLog("BattleMsgBossMapSkill:_waitGhostMonsterId wait")
        self.m_bIsWaitMonsterId = true
        return false
    end

    self.m_bIsWaitMonsterId = false
    return true
end

--生成龙卷风
function BattleMsgBossMapSkill:_buildGhostTornado()
    WZLog("BattleMsgBossMapSkill:_buildGhostTornado", self.m_tTornadoInfo.camp,self.m_tTornadoInfo.templateId)
    if self.m_tOwnPlayerId == nil then return end 

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tOwnPlayerId)

    if not WBattleGlobal:getCurrent():isSingleStage() then
        --只创建一个 直接赋值
        for i=1,#self.m_tSummonMonsterId do
             for j, v in pairs(hero.guaiId) do
                if self.m_tSummonMonsterId[i] == v then
                    self.m_tTornadoInfo.battleId = hero.guaiBattleId[j]
                    table.remove(hero.guaiId, j)
                    table.remove(hero.guaiBattleId, j)
                    table.remove(hero.guaiPositionX, j)
                    table.remove(hero.guaiPositionY, j)
                    break
                end
            end
        end
    else
        --单人副本创建小怪 为小怪添加battleId
        self.m_tTornadoInfo.battleId = WBattleGlobal:getCurrent():getBuildGuaiBattleId(true)
    end

    local tornado = WBattleGlobal:getCurrent():buildMachine(MonsterType.TORANDO,self.m_tTornadoInfo)
    SceneBattle:getFrontLayer():addChild(tornado.m_anim:getAnimNode())
end


--@brief 创建治疗图腾
function BattleMsgBossMapSkill:_buildTreatTotem()
    if not WBattleGlobal:getCurrent():isSingleStage() then
        --只创建一个 直接赋值
        for i=1,#self.m_tSummonMonsterId do
             for j, v in pairs(self.m_tOwner.guaiId) do
                if self.m_tSummonMonsterId[i] == v then
                    self.m_tTreatTotemInfo.battleId = self.m_tOwner.guaiBattleId[j]
                    table.remove(self.m_tOwner.guaiId, j)
                    table.remove(self.m_tOwner.guaiBattleId, j)
                    table.remove(self.m_tOwner.guaiPositionX, j)
                    table.remove(self.m_tOwner.guaiPositionY, j)
                    break
                end
            end
        end
    else
        --单人副本创建小怪 为小怪添加battleId
        self.m_tTreatTotemInfo.battleId = WBattleGlobal:getCurrent():getBuildGuaiBattleId(true)
    end

    local treatTotem = WBattleGlobal:getCurrent():buildMachine(MonsterType.TREAT_TOTEM,self.m_tTreatTotemInfo)
    SceneBattle:getFrontLayer():addChild(treatTotem.m_anim:getAnimNode())
end

--@brief 创建攻击图腾
function BattleMsgBossMapSkill:_buildBuffTotem()
    if not WBattleGlobal:getCurrent():isSingleStage() then
        --只创建一个 直接赋值
        for i=1,#self.m_tSummonMonsterId do
             for j, v in pairs(self.m_tOwner.guaiId) do
                if self.m_tSummonMonsterId[i] == v then
                    self.m_tTreatTotemInfo.battleId = self.m_tOwner.guaiBattleId[j]
                    table.remove(self.m_tOwner.guaiId, j)
                    table.remove(self.m_tOwner.guaiBattleId, j)
                    table.remove(self.m_tOwner.guaiPositionX, j)
                    table.remove(self.m_tOwner.guaiPositionY, j)
                    break
                end
            end
        end
    else
        --单人副本创建小怪 为小怪添加battleId
        self.m_tTreatTotemInfo.battleId = WBattleGlobal:getCurrent():getBuildGuaiBattleId(true)
    end

    local buffTotem = WBattleGlobal:getCurrent():buildMachine(MonsterType.BUFF_TOTEM,self.m_tTreatTotemInfo)
    SceneBattle:getFrontLayer():addChild(buffTotem.m_anim:getAnimNode())
end

--@brief 移除buff
function BattleMsgBossMapSkill:_canelBuff(targetHeroList)
   WZLog("BattleMsgBossMapSkill:_canelBuff id", self.m_nCancelBuffId)
   WZLog("BattleMsgBossMapSkill:_canelBuff type", tostring(self.m_nCancelBuffType), tostring(self.m_nCancelBuffAssign))

    for id, hero in pairs (targetHeroList) do
        if hero:isDead() ~= true then
            for index, buff in pairs (hero.m_tBuffChangeStateList) do 
                local isClear = false
                if self.m_nCancelBuffId and self.m_nCancelBuffId == buff.m_nID then
                    isClear = true
                end
                if self.m_nCancelBuffType and self.m_nCancelBuffType == buff.m_nType then
                    isClear = true
                end
                if self.m_nCancelBuffAssign and self.m_nCancelBuffAssign == buff.m_nType then
                    isClear = true
                end
                if not self.m_nCancelBuffId and not self.m_nCancelBuffType and not self.m_nCancelBuffAssign then
                    isClear = true
                end
                if isClear then
                    hero:removeBuffSpecialInfluence(buff)
                    buff:removeAnime()
                    hero.m_tBuffChangeStateList[index] = nil
                end
            end
        end
    end
end

--加buff
function BattleMsgBossMapSkill:_addBuff(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_addBuff one", Serialize(self.m_nAddBuffId),self.m_tOwner:getBattleId())

    for i, buffId in pairs (self.m_nAddBuffId) do
        local buffInfo = GDatatab_buff["id_"..buffId]
        
        for id, hero in pairs (targetHeroList) do
            if hero:isDead() ~= true then
                local buffNew = BuffBody:new(buffInfo,hero, self.m_tOwner:getBattleId())
                local buffExistIndex = nil
                local buffExist = nil
                local offBuff = false
                local isShapeRecovery = false
                for index, buff in pairs (hero.m_tBuffChangeStateList) do 
                    if buff.m_nType == BuffType.SHAPE_RECOVERY and buffNew.m_nType == BuffType.SHAPE_RECOVERY then
                        isShapeRecovery = true
                        buff.m_nTimePassValueReal = 0
                        buff.m_nTakeEffectCountReal = 0
                        buff.m_nTimePassValue = 0
                        buff.m_nTakeEffectCount = 0
                        offBuff = true
                        local round = WBattleGlobal:getCurrent().m_nTurnTimes
                        WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList = WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList or {}
                        table.insert(WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList, {actionTimes = hero.m_nActionTimes,round=round,playerId=hero:getBattleId(),buffId=buffId,userId=self.m_tOwner:getBattleId(),isMapBuff=buffNew.m_bIsMapBuff})
                        table.insert(WBattleGlobal:getCurrent().m_tBuffInfoCurRound, {id=buffId, playerId=hero:getBattleId(), buffInfo=buffInfo})
                        break
                    end

                    if buff.m_nType == BuffType.SHAPE_NO_HOLE and buffNew.m_nType == BuffType.SHAPE_NO_HOLE then
                        isShapeRecovery = true
                        buff.m_nTimePassValueReal = 0
                        buff.m_nTakeEffectCountReal = 0
                        buff.m_nTimePassValue = 0
                        buff.m_nTakeEffectCount = 0
                        offBuff = true
                        local round = WBattleGlobal:getCurrent().m_nTurnTimes
                        WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList = WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList or {}
                        table.insert(WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList, {actionTimes = hero.m_nActionTimes,round=round,playerId=hero:getBattleId(),buffId=buffId,userId=self.m_tOwner:getBattleId(),isMapBuff=buffNew.m_bIsMapBuff})
                        table.insert(WBattleGlobal:getCurrent().m_tBuffInfoCurRound, {id=buffId, playerId=hero:getBattleId(), buffInfo=buffInfo})
                        break
                    end
                    if buffNew.m_nType == buff.m_nType then
                        buffExistIndex = index
                        buffExist = buff
                        if buffNew.m_nLv < buff.m_nLv then
                            offBuff = true
                        end
                        --break
                    end
                end
                --免疫冰冻等
                
                if hero.m_bOffFrozen then
                    local immunizeList = {EffectTypeConfig.LIMIT_MOVE, EffectTypeConfig.LIMIT_FLY, EffectTypeConfig.LIMIT_USE_SKILL, EffectTypeConfig.LIMIT_USE_ITEM, EffectTypeConfig.LIMIT_ALL_ACTION, EffectTypeConfig.LIMIT_VISIBLE}
                    for id, effectParm in pairs (buffNew.m_nEffect) do
                        local effect = effectParm[3] .. "_" ..effectParm[4]
                        for id, effectType in pairs (immunizeList) do
                            if effect == effectType then
                                -- buffExist = buffNew
                                offBuff = true
                                WZLog("BattleMsgBossMapSkill:_addBuff offBuff", effectType)
                            end
                        end
                    end
                end

                if TeachGroup1.ISFIRSTBATTLE then
                    offBuff = true
                end

                --被动免疫
                local offSkillId = hero:getIsImmunityByPetSkill(0,buffInfo.buff_type)
                if buffNew.m_nType == BuffType.SHAPE_NO_HOLE then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.NO_HOLE})
                    WZLog("BattleMsgBossMapSkill:_addBuff four", self.m_nSkillId)
                elseif offSkillId then
                    BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId)
                    offBuff = true
                end

                WZLog("BattleMsgBossMapSkill:_addBuff two", hero:getBattleId(), tostring(offBuff))
                if not offBuff then
                    WZLog("BattleMsgBossMapSkill:_addBuff three-0", tostring(buffExistIndex), buffNew.m_nEffect)

                    local round = WBattleGlobal:getCurrent().m_nTurnTimes
                    WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList = WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList or {}
                    table.insert(WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList, {actionTimes = hero.m_nActionTimes,round=round,playerId=hero:getBattleId(),buffId=buffId,userId=self.m_tOwner:getBattleId(),isMapBuff=buffNew.m_bIsMapBuff})


                    if buffExistIndex then
                        buffExist:removeAnime()
                        hero.m_tBuffChangeStateList[buffExistIndex] = nil
                    end

                    if buffNew.m_nType == BuffType.SHAPE_RECOVERY and isShapeRecovery == false then
                        BattlePetSkillManager:triggerPassiveSkillView(hero,self.m_nSkillId)
                    end
                    
                    table.insert(hero.m_tBuffChangeStateList, buffNew)

                    local buffInfo = "buffInfo:"
                    if hero.m_tActiveAttackPos and hero.m_tActiveAttackPos[1] then
                        buffInfo = buffInfo .. "x=" .. hero.m_tActiveAttackPos[1].x .. ",y=" .. hero.m_tActiveAttackPos[1].y
                    else
                        buffInfo = buffInfo .. "nil"
                    end
                    table.insert(WBattleGlobal:getCurrent().m_tBuffInfoCurRound, {id=buffId, playerId=hero:getBattleId(), buffInfo=buffInfo})
                    buffNew:addAnime()
                    if buffNew.m_nTimeIntervalValue == -1 then
                        for i,buffEffect in pairs (buffNew.m_nEffect) do
                            self:_doEffectType(buffEffect,{[1]=hero},true)
                            local effect = buffEffect[3] .. "_" ..buffEffect[4]
                            self:addStep(effect, {[1]=hero}, true)
                        end
                    end
                end
            end
        end
    end
end

--击飞
function BattleMsgBossMapSkill:_repelFly(targetHeroList,skillType)
    WZLog("BattleMsgBossMapSkill:_repelFly one", tostring(self.m_tOwner.m_bActiveAttack))
    
    for i, hero in pairs (targetHeroList) do
        --被动免疫
        local offSkillId = hero:getIsImmunityByPetSkill(1,skillType)
        if offSkillId then
            BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId)
        else
            local heroPos = hero:getAnimation():getPosition()
            if self.m_tOwner.m_tActiveAttackPos ~= nil and #self.m_tOwner.m_tActiveAttackPos > 0 and heroPos.x > self.m_tOwner.m_tActiveAttackPos[1].x then
                WZLog("BattleMsgBossMapSkill:_repelFly two", self.m_nRepelFlyX)
                hero:setRepulse(self.m_nRepelFlyX/10)
            else
                WZLog("BattleMsgBossMapSkill:_repelFly three", self.m_nRepelFlyX)
                hero:setRepulse(-1*self.m_nRepelFlyX/10)
            end
        end
    end
end

--冰冻
function BattleMsgBossMapSkill:_frozen(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_frozen", tostring(self.m_tOwner.m_nUseSkillState))
    for i, hero in pairs (targetHeroList) do
        hero.m_tAttributeChangeStateList.m_nDebuffFrozenRound = {timeType=self.m_nDebuffFrozenRoundTimeType,timeValue=self.m_nDebuffFrozenRoundTimeValue,value=self.m_nDebuffFrozenRound}
    end
end

--改变散射数
function BattleMsgBossMapSkill:_changeScatter(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_changeScatter")
    for i, hero in pairs (targetHeroList) do
        hero.m_tAttributeChangeStateList.m_nAttScatterNum = {timeType=self.m_nAttScatterNumTimeType,timeValue=self.m_nAttScatterNumTimeValue,value=self.m_nAttScatterNum}
    end
end

--改变连射数
function BattleMsgBossMapSkill:_changeAtkTimes(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_changeAtkTimes", self.m_nAttTimes)
    for i, hero in pairs (targetHeroList) do
        WZLog("BattleMsgBossMapSkill:_changeAtkTimes", hero:getBattleId(), self.m_nAttTimes)
        hero.m_tAttributeChangeStateList.m_nAttTimes = {timeType=self.m_nAttTimesTimeType,timeValue=self.m_nAttTimesTimeValue,value=self.m_nAttTimes}
    end
end

--改变宠物暴击
function BattleMsgBossMapSkill:_petCrit(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_petCrit", self.m_nPetCritValue)
    for i, hero in pairs (targetHeroList) do
        WZLog("BattleMsgBossMapSkill:_petCrit", hero:getBattleId(), self.m_nPetCritValue)
        hero.m_tAttributeChangeStateList.m_nPetCritValue = {value=self.m_nPetCritValue}
    end
end

--隐身
function BattleMsgBossMapSkill:_hide(targetHeroList, isBuff)
    WZLog("BattleMsgBossMapSkill:_hide", tostring(self.ishide))
    if self.ishide == true then
        --return false
    end
    self.ishide = true
    for i, hero in pairs (targetHeroList) do
        local nPlayerId = hero:getBattleId()
        WZLog("BattleMsgBossMapSkill:_hide one", nPlayerId, hero.m_sPlayerName, tostring(WBattleGlobal:getCurrent():isMyTeam(nPlayerId)), tostring(not hero:isDead()), hero:getHp())
        if isBuff == nil then
            hero.m_tAttributeChangeStateList.m_nHideTurn = {timeType=self.m_nHideTurnTimeType,timeValue=self.m_nHideTurnTimeValue,value=self.m_nHideTurn}
        end

        --[[
        local opecity = 255
        if WBattleGlobal:getCurrent():isMyTeam(nPlayerId) and not hero:isDead() and hero:getHp() > 0 then
            opecity = 128
        else
            opecity = 0
        end

        hero:getAnimation():getAnimNode():setOpacity(opecity)
        if hero:getPlayerNameIcon() and opecity == 0 then
            hero:getPlayerNameIcon():setOpecity(opecity)
        end
        if hero:getPet() then
            hero:getPet():getAnimation():getAnimNode():setOpacity(opecity)
        end
        if hero.m_angerAnim then
            hero.m_angerAnim:getAnimNode():setOpacity(opecity)
        end

        if hero.m_angerAnim2 then
            hero.m_angerAnim2:getAnimNode():setOpacity(opecity)
        end

        if hero.m_frozenAnim ~= nil then
            hero.m_frozenAnim:getAnimNode():setOpacity(opecity)
        end

        if hero.m_tHurtAnim ~= nil then
            for i, v in pairs(hero.m_tHurtAnim) do
                v:getAnimNode():setOpacity(opecity)
            end
        end

        for id,buff in pairs (hero.m_tBuffChangeStateList) do
            local effect = 0
            for id, effectParm in pairs (buff.m_nEffect) do
                effect = effectParm[3] .. "_" ..effectParm[4]
            end
            if buff.m_tAnim then
                buff.m_tAnim:getAnimNode():setOpacity(opecity)
            end
            WZLog("BattleMsgBossMapSkill:_hide two", effect, tostring(buff.m_tAnim))
        end
        --]]
    end
    --return false
end

--改变ctb
function BattleMsgBossMapSkill:_changeCtbValue(targetHeroList,skillType,isBuff)
    for i,hero in pairs(targetHeroList) do
        if not hero:isDead() then
            WZLog("BattleMsgBossMapSkill:_changeCtbValue", self.m_nSkillId, WBattleGlobal.getCurrent().m_nAwakeSkillId)
            if not self.m_nSkillId == WBattleGlobal.getCurrent().m_nAwakeSkillId then
                BattleCtbManager:addCtb(hero:getBattleId(),self.m_nChangeValue or 0)
            end
             --设置ctb过程记录
            WBattleGlobal:getCurrent():setCtbProRecord(hero:getBattleId(), self.m_nChangeValue )
        end
    end
end

--改变属性
function BattleMsgBossMapSkill:_changeAttribute(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgBossMapSkill:_changeAttribute", targetHeroList, skillType, tostring(self.m_nChangeValueIndex), tostring(self.m_nChangePercentIndex), tostring(self.m_nChangeValue), tostring(self.m_nChangePercent))
    local Attribute = {}
    for i, v in pairs (AttributeConfig)do
        Attribute[v] = i
    end

    for i, hero in pairs (targetHeroList) do
        if isBuff == nil and not hero:isDead() and hero:getHp() > 0 then
            if skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE then
                if self.m_nChangeValueIndex == AttributeConfig.HP then
                    local change = self.m_nChangeValue or 0

                    if change > 0 then
                        change = math.ceil(change)
                    else
                        change = math.floor(change)
                    end
                    change = hero:hurtEffectHandle(change * -1)
                    
                    if change < 0 then
                        local recoveryAddPercent = hero:getRecoveryAddPercent()
                        change = change * (1+recoveryAddPercent)

                        if recoveryAddPercent ~= 0 then
                            local offSkillId = hero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_RECOVERY_PERCENT)
                            if offSkillId then
                                BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId, true)
                            end
                        end
                        WZLog("BattleMsgBossMapSkill:_changeAttribute 11", change, recoveryAddPercent)
                    end

                    if change * -1 + hero.m_nHP > hero.m_nMaxHP then
                        change = (hero.m_nMaxHP - hero.m_nHP) * -1
                    end

                    WZLog("BattleMsgBossMapSkill:_changeAttribute 1", change)
                    local curHp = hero.m_nHP - change
                    hero:setHp(curHp)
                    --设置过程伤害记录
                    if math.abs(change) > 0 then
                        WBattleGlobal:getCurrent():setHpProRecord(hero:getBattleId(),-change)
                    end

                    if change < 0 and (hero:isHide() == true and WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) or hero:isHide() ~= true) then
                        local pos = BattleCommon:getPointTable(hero:getPosition().x + 100,hero:getPosition().y + 50)
                        local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",3))
                        element:setLuaObjectIndex(self)
                        if element ~= nil then
                            GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText(change * -1)
                            local conHurt = WZUIContainer:luaTo(element)
                            conHurt:setAbsPosition(GlobalMethod:ccp(pos.x,pos.y))
                            SceneBattle:getFrontLayer():addChild(conHurt,6)
                        end
                    end

                elseif self.m_nChangeValueIndex == AttributeConfig.PF then
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 2")
                    hero.m_nPF = hero.m_nPF + (self.m_nChangeValue or 0)
                    hero:setPF(hero.m_nPF)
                elseif self.m_nChangeValueIndex == AttributeConfig.SP then
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 3")
                    hero.m_nSP = hero.m_nSP + (self.m_nChangeValue or 0)
                    if TeachGroup1.ISBATTLE_MYTURN then
                        hero.m_nSP = 100
                    end
                    hero:setSp(hero.m_nSP)
                else
                    hero.m_tAttributeChangeStateList["m_n"..Attribute[self.m_nChangeValueIndex].."AddValue"] = {timeType=self.m_nChangeValueTimeType,timeValue=self.m_nChangeValueTimeValue,value=self.m_nChangeValue}
                    if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                        hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_ATTRIBUTE_VALUE, subType = self.m_nChangeValueIndex,param = self.m_nChangeValue})
                    end
                end

                if self.m_nChangeValueIndex == AttributeConfig.BrokeRange then
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 7")
                    
                end
            elseif skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT then
                if self.m_nChangePercentIndex == AttributeConfig.HP then
                    local change = hero:getMaxHp(true) * (self.m_nChangePercent or 0)/100
                    if change > 0 then
                        change = math.ceil(change)
                    else
                        change = math.floor(change)
                    end
                    change = hero:hurtEffectHandle(change * -1)

                    if change < 0 then
                        local recoveryAddPercent = hero:getRecoveryAddPercent()
                        change = change * (1+recoveryAddPercent)

                        if recoveryAddPercent ~= 0 then
                            local offSkillId = hero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_RECOVERY_PERCENT)
                            if offSkillId then
                                BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId, true)
                            end
                        end
                        WZLog("BattleMsgBossMapSkill:_changeAttribute 11", change, recoveryAddPercent)
                    end

                    if change * -1 + hero.m_nHP > hero.m_nMaxHP then
                        change = (hero.m_nMaxHP - hero.m_nHP) * -1
                    end
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 4", change)
                    local curHp = hero.m_nHP - change
                    hero:setHp(curHp)
                    --设置过程伤害记录
                    if math.abs(change) > 0 then
                        WBattleGlobal:getCurrent():setHpProRecord(hero:getBattleId(),-change)
                    end

                    if change < 0 and (hero:isHide() == true and WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) or hero:isHide() ~= true) then
                        local pos = BattleCommon:getPointTable(hero:getPosition().x + 100,hero:getPosition().y + 20)
                        local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",3))
                        element:setLuaObjectIndex(self)
                        if element ~= nil then
                            GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText(change * -1)
                            local conHurt = WZUIContainer:luaTo(element)
                            conHurt:setAbsPosition(GlobalMethod:ccp(pos.x,pos.y))
                            SceneBattle:getFrontLayer():addChild(conHurt,6)
                        end
                    end
                elseif self.m_nChangePercentIndex == AttributeConfig.PF then
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 5")
                    hero.m_nPF = hero.m_nPF + (hero:getMaxPF(true) * (self.m_nChangePercent or 0)/100)
                    hero:setPF(hero.m_nPF)
                elseif self.m_nChangePercentIndex == AttributeConfig.SP then
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 6")
                    hero.m_nSP = hero.m_nSP + (100 * (self.m_nChangePercent or 0)/100)
                    hero:setSp(hero.m_nSP)
                else
                    hero.m_tAttributeChangeStateList["m_n"..Attribute[self.m_nChangePercentIndex].."AddPercent"] = {timeType=self.m_nChangeValueTimeType,timeValue=self.m_nChangeValueTimeValue,value=self.m_nChangePercent}
                    if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                        hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT, subType = self.m_nChangePercentIndex,param = self.m_nChangePercent})
                    end
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 44", "m_n"..Attribute[self.m_nChangePercentIndex].."AddPercent", self.m_nChangePercent)
                
                end

                if self.m_nChangeValueIndex == AttributeConfig.BrokeRange then
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 8")
                    hero.m_bWeaponAtomicBomb = true
                end
            elseif skillType == EffectTypeConfig.CHANGE_ATTRIBUTE_PERCENT_HURT then
                if self.m_nChangeHurtPercentIndex == AttributeConfig.HP then
                    local value = hero.m_nCurRoundHurt or 0
                    if self.m_bIsPetSkillEffect then
                        value = WBattleGlobal:getCurrent().m_nPetAttackHurtCurRound or 0
                    end
                    --伤害为负数 +血
                    if value < 0 then
                        return
                    end
                    local change = math.ceil(value * (self.m_nChangeHurtPercent or 0)/100)
                    if change > 0 then
                        change = math.ceil(change)
                    else
                        change = math.floor(change)
                    end

                    change = hero:hurtEffectHandle(change * -1)

                    if change < 0 then
                        local recoveryAddPercent = hero:getRecoveryAddPercent()
                        change = change * (1+recoveryAddPercent)

                        if recoveryAddPercent ~= 0 then
                            local offSkillId = hero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_RECOVERY_PERCENT)
                            if offSkillId then
                                BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId, true)
                            end
                        end
                        WZLog("BattleMsgBossMapSkill:_changeAttribute 11", change, recoveryAddPercent)
                    end

                    if change * -1 + hero.m_nHP > hero.m_nMaxHP then
                        change = (hero.m_nMaxHP - hero.m_nHP) * -1
                    end
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 14", value, change)
                    local curHp = hero.m_nHP - change
                    hero:setHp(curHp)
                    --设置过程伤害记录
                    if math.abs(change) > 0 then
                        WBattleGlobal:getCurrent():setHpProRecord(hero:getBattleId(),-change)
                    end

                    if change <= 0 and (hero:isHide() == true and WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) or hero:isHide() ~= true) then
                        local pos = BattleCommon:getPointTable(hero:getPosition().x + 100,hero:getPosition().y + 20)
                        local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",3))
                        element:setLuaObjectIndex(self)
                        if element ~= nil then
                            GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText(change * -1)
                            local conHurt = WZUIContainer:luaTo(element)
                            conHurt:setAbsPosition(GlobalMethod:ccp(pos.x,pos.y))
                            SceneBattle:getFrontLayer():addChild(conHurt,6)
                        end
                    end
                end
            else
                if self.m_nChangePercentIndexAttack == AttributeConfig.HP then
                    local change = self.m_tOwner:getAttack(true) * (self.m_nChangePercentAttack or 0)/100
                    if change > 0 then
                        change = math.ceil(change)
                    else
                        change = math.floor(change)
                    end

                    change = hero:hurtEffectHandle(change * -1)

                    if change < 0 then
                        local recoveryAddPercent = hero:getRecoveryAddPercent()
                        change = change * (1+recoveryAddPercent)

                        if recoveryAddPercent ~= 0 then
                            local offSkillId = hero:getIsImmunityByPetSkill(1,EffectTypeConfig.CHANGE_RECOVERY_PERCENT)
                            if offSkillId then
                                BattlePetSkillManager:triggerPassiveSkillView(hero,offSkillId, true)
                            end
                        end
                        WZLog("BattleMsgBossMapSkill:_changeAttribute 11", change, recoveryAddPercent)
                    end

                    if change * -1 + hero.m_nHP > hero.m_nMaxHP then
                        change = (hero.m_nMaxHP - hero.m_nHP) * -1
                    end
                    WZLog("BattleMsgBossMapSkill:_changeAttribute 4", change)
                    local curHp = hero.m_nHP - change
                    hero:setHp(curHp)
                    --设置过程伤害记录
                    if math.abs(change) > 0 then
                        WBattleGlobal:getCurrent():setHpProRecord(hero:getBattleId(),-change)
                    end

                    if change < 0 and (hero:isHide() == true and WBattleGlobal:getCurrent():isMyTeam(hero:getBattleId()) or hero:isHide() ~= true) then
                        local pos = BattleCommon:getPointTable(hero:getPosition().x + 100,hero:getPosition().y + 20)
                        local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",3))
                        element:setLuaObjectIndex(self)
                        if element ~= nil then
                            GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText(change * -1)
                            local conHurt = WZUIContainer:luaTo(element)
                            conHurt:setAbsPosition(GlobalMethod:ccp(pos.x,pos.y))
                            SceneBattle:getFrontLayer():addChild(conHurt,6)
                        end
                    end
                end
            end
        end
    end
end

--@brief    伤害数字显示完成的回调
function BattleMsgBossMapSkill:_finishFlyingNum(element)
    WZLog("BattleMsgBossMapSkill_finishFlyingNum", tostring(element))

    element:removeFromParentAndCleanup(true)
end

--初始化对白框
function BattleMsgBossMapSkill:_initDialog()
    WZLog("BattleMsgBossMapSkill:_initDialog",self.m_nTalkId)
    
    if GDatatab_talk ~= nil and GDatatab_talk["id_"..self.m_nTalkId] ~= nil then
        self.m_sTalkText = GDatatab_talk["id_"..self.m_nTalkId].talk          --文本内容
    else
        self.m_sTalkText = nil
        return true
    end
    self.m_nMaxWidth = 280           --最大宽度
    self.m_nScale = 1.0              --缩放大小
    self.m_bNeedZoomToBoss = true   --是否需要把屏幕移向怪
    self.m_tOwner = self.m_tOwner
    self.m_tFollowObj = self.m_tOwner
    self.m_bIsUpdatePos = true
    self.m_nTime = 3
    
    local height = 70
    local width = 50
    
    if self.m_tOwner.m_tCollisionRang ~= nil then
        height = self.m_tOwner.m_tCollisionRang[1].m_fHeight * 0.7 + 30
        width = self.m_tOwner.m_tCollisionRang[1].m_fWidth * 0.4 + 30
    elseif self.m_tOwner.m_nAiType == MonsterAiType.AI_ROBOT then
        height = 70
        width = 50
    end

    if self.m_tOwner:getPosition().x < 450 then
        self.m_nDirection = CellDialog.DIR_RIGHT
        self.m_tPosOffset = BattleCommon:getPointTable(width, height)   --位置偏移量
    elseif self.m_tOwner:getPosition().x > 1200 then
        self.m_nDirection = CellDialog.DIR_LEFT
        self.m_tPosOffset = BattleCommon:getPointTable(-width, height)   --位置偏移量
    else
        if self.m_tOwner.m_bIsFilpX == true then
            self.m_nDirection = CellDialog.DIR_LEFT
            self.m_tPosOffset = BattleCommon:getPointTable(-width, height)   --位置偏移量
        else
            self.m_nDirection = CellDialog.DIR_RIGHT
            self.m_tPosOffset = BattleCommon:getPointTable(width, height)   --位置偏移量
        end
    end

    WZLog("WMonsterAI:talk", tostring(self.m_tOwner.m_tCollisionRang), height, width)

    if self.m_tOwner.m_tDialog ~= nil then
        self.m_tOwner.m_tDialog:removeDialog()
        self.m_tOwner.m_tDialog = nil
    end
    
    return true
end

--@brief    显示对话框
function BattleMsgBossMapSkill:_showDialog()
    if self.m_sTalkText == nil or self.m_sTalkText == "" then
        return true
    end
    WZLog("BattleMsgBossMapSkill:_showDialog", self.m_nTime, self.m_tPosOffset.x, self.m_tPosOffset.y, tostring( self.m_bIsUpdatePos), self.m_sTalkText, self.m_nDirection)

    local boss = self.m_tOwner

    local nameInfo = nil
    if self.m_bIsRelyNameInfo ~= nil and self.m_bIsRelyNameInfo == false then
        nameInfo = boss:getAnimation():getAnimNode()
        WZLog("BattleMsgBossMapSkill:_showDialog III")
    elseif boss:getPlayerNameIcon() ~= nil then
        nameInfo = boss:getPlayerNameIcon().m_tNameLayer
        WZLog("BattleMsgBossMapSkill:_showDialog IV")
    elseif boss.m_tGuaiName ~= nil then
        WZLog("BattleMsgBossMapSkill:_showDialog V")
        nameInfo = boss.m_tGuaiName.m_tNameLayer
    elseif boss.m_tBossName ~= nil then
        WZLog("BattleMsgBossMapSkill:_showDialog VI")
        nameInfo = boss.m_tBossName.m_tNameLayer
    elseif boss.m_tBossNameAndHP ~= nil then
        WZLog("BattleMsgBossMapSkill:_showDialog VII")
        nameInfo = boss.m_tBossNameAndHP.m_tNameLayer
    end

    if boss.m_nAiType == MonsterAiType.AI_MELEE_SKY then
        self.m_tPosOffset.x = self.m_tPosOffset.x - 450
    end

    --self.m_tPosOffset = {x=0,y=0}
    boss.m_tDialogElement,boss.m_tDialog = CellDialog:addDialog(nameInfo, SceneBattle:getInfoLayer(), self.m_sTalkText, self.m_nDirection, self.m_nTime, nil, nil, self.m_tPosOffset.x, self.m_tPosOffset.y, self.m_nMaxWidth, self.m_nScale, nil, nil, self.m_bIsUpdatePos, self.m_tFollowObj,100,nil,nil,nil,nil,true)
    ---[[
    if boss.m_mover ~= nil and (boss.m_nAiType == nil or boss.m_nAiType ~= MonsterAiType.AI_MELEE_SKY ) then
        WZLog("BattleMsgBossMapSkill:_showDialog II",self.m_tPosOffset.x,self.m_tPosOffset.y)
        local node = TrackNode:create(boss.m_tDialogElement)
        node:setPreAdd(Vector2:create(self.m_tPosOffset.x,self.m_tPosOffset.y))
        boss.m_mover:addTrackNode(node)
    end
    --]]
    return true
end

--@brief    无敌
function BattleMsgBossMapSkill:_Invincible(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_Invincible")
    for i, hero in pairs (targetHeroList) do
        WZLog("BattleMsgBossMapSkill:_Invincible two", hero:getBattleId())
        hero.m_tAttributeChangeStateList.m_nBuffInvincibleRound = 1
    end
end

--@brief    改变伤害
function BattleMsgBossMapSkill:_ChangeHurt(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgBossMapSkill:_ChangeHurt")
    if isBuff == nil then
        for i, hero in pairs (targetHeroList) do
            WZLog("BattleMsgBossMapSkill:_ChangeHurt two", hero:getBattleId(), skillType, tostring(self.m_nHurtChangeValue), tostring(self.m_nHurtAddPercent), tostring(self.m_nHurtAddValue))
            hero.m_nBuffPowerUpRound = 2

            if skillType == EffectTypeConfig.CHANGE_HURT_VALUE then
                hero:changeAttrListValue("m_nHurtChangeValue", self.m_nHurtChangeValue)
                --hero.m_tAttributeChangeStateList.m_nHurtChangeValue = {timeType=self.m_nHurtChangeValueTimeType,timeValue=self.m_nHurtChangeValueTimeValue,value=self.m_nHurtChangeValue}
            elseif skillType == EffectTypeConfig.CHANGE_HURT_PERCENT then
                hero:changeAttrListValue("m_nHurtAddPercent", self.m_nHurtAddPercent)
                --hero.m_tAttributeChangeStateList.m_nHurtAddPercent = {timeType=self.m_nHurtAddPercentTimeType,timeValue=self.m_nHurtAddPercentTimeValue,value=self.m_nHurtAddPercent}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_HURT_PERCENT,param = self.m_nHurtAddPercent})
                end
            elseif skillType == EffectTypeConfig.CHANGE_HURT_ADD_VALUE then
                hero:changeAttrListValue("m_nHurtAddValue", self.m_nHurtAddValue)
                --hero.m_tAttributeChangeStateList.m_nHurtAddValue = {timeType=self.m_nHurtAddValueTimeType,timeValue=self.m_nHurtAddValueTimeValue,value=self.m_nHurtAddValue}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_HURT_ADD_VALUE,param = self.m_nHurtAddValue})
                end
            elseif skillType == EffectTypeConfig.CHANGE_HURT_MUL_PERCENT then
                hero:changeAttrListValue("m_nHurtMulPercent", self.m_nHurtMulPercent)
                --hero.m_tAttributeChangeStateList.m_nHurtMulPercent = {timeType=self.m_nHurtAddPercentTimeType,timeValue=self.m_nHurtAddPercentTimeValue,value=self.m_nHurtMulPercent}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_HURT_MUL_PERCENT,param = self.m_nHurtMulPercent})
                end
            end
        end
    end
end

--@brief    改变被动伤害
function BattleMsgBossMapSkill:_ChangeBeHurt(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgBossMapSkill:_ChangeBeHurt", tostring(isBuff))
    if isBuff == nil then
        for i, hero in pairs (targetHeroList) do
            WZLog("BattleMsgBossMapSkill:_ChangeBeHurt two", hero:getBattleId(), skillType, tostring(self.m_nBeHurtChangeValue), tostring(self.m_nBeHurtAddPercent), tostring(self.m_nBeHurtAddValue))

            if skillType == EffectTypeConfig.CHANGE_BEHURT_VALUE then
                hero:changeAttrListValue("m_nBeHurtChangeValue", self.m_nBeHurtChangeValue)
                --hero.m_tAttributeChangeStateList.m_nBeHurtChangeValue = {timeType=self.m_nBeHurtChangeValueTimeType,timeValue=self.m_nBeHurtChangeValueTimeValue,value=self.m_nBeHurtChangeValue}
            elseif skillType == EffectTypeConfig.CHANGE_BEHURT_PERCENT then
                hero:changeAttrListValue("m_nBeHurtAddPercent", self.m_nBeHurtAddPercent)
                --hero.m_tAttributeChangeStateList.m_nBeHurtAddPercent = {timeType=self.m_nBeHurtAddPercentTimeType,timeValue=self.m_nBeHurtAddPercentTimeValue,value=self.m_nBeHurtAddPercent}
                --宠物伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_BEHURT_PERCENT,param = self.m_nBeHurtAddPercent})
                end
            elseif skillType == EffectTypeConfig.CHANGE_BEHURT_ADD_VALUE then
                hero:changeAttrListValue("m_nBeHurtAddValue", self.m_nBeHurtAddValue)
                --hero.m_tAttributeChangeStateList.m_nBeHurtAddValue = {timeType=self.m_nBeHurtAddValueTimeType,timeValue=self.m_nBeHurtAddValueTimeValue,value=self.m_nBeHurtAddValue}
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_BEHURT_ADD_VALUE,param = self.m_nBeHurtAddValue})
                end
            end
        end
    end
end

--@brief    改变暴击伤害
function BattleMsgBossMapSkill:_ChangeCritHurt(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgBossMapSkill:_ChangeCritHurt")
    if isBuff == nil then
        for i, hero in pairs (targetHeroList) do
            WZLog("BattleMsgBossMapSkill:_ChangeCritHurt two", hero:getBattleId(), skillType, tostring(self.m_nCritHurtAddPercent))
            if skillType == EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT then
                hero:changeAttrListValue("m_nCritHurtAddPercent", self.m_nCritHurtAddPercent)
                --hero.m_tAttributeChangeStateList.m_nCritHurtAddPercent = {value=self.m_nCritHurtAddPercent}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_CRIT_HURT_PERCENT,param = self.m_nCritHurtAddPercent})
                end
            elseif skillType == EffectTypeConfig.CHANGE_CRIT_HURT_ADD_VALUE then
                hero:changeAttrListValue("m_nCritHurtAddValue", self.m_nCritHurtAddValue)
                --hero.m_tAttributeChangeStateList.m_nCritHurtAddValue = {value=self.m_nCritHurtAddValue}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_CRIT_HURT_ADD_VALUE,param = self.m_nCritHurtAddValue})
                end
            end
        end
    end
end

--@brief    改变被暴击伤害
function BattleMsgBossMapSkill:_ChangeBeCritHurt(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgBossMapSkill:_ChangeCritHurt")
    if isBuff == nil then
        for i, hero in pairs (targetHeroList) do
            WZLog("BattleMsgBossMapSkill:_ChangeBeCritHurt two", hero:getBattleId(), skillType, tostring(self.m_nBeCritHurtAddPercent))
            if skillType == EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT then
                hero:changeAttrListValue("m_nBeCritHurtAddPercent", self.m_nBeCritHurtAddPercent)
                --hero.m_tAttributeChangeStateList.m_nBeCritHurtAddPercent = {value=self.m_nBeCritHurtAddPercent}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_BECRIT_HURT_PERCENT,param = self.m_nBeCritHurtAddPercent})
                end
            elseif skillType == EffectTypeConfig.CHANGE_BECRIT_HURT_ADD_VALUE then
                hero:changeAttrListValue("m_nBeCritHurtAddValue", self.m_nBeCritHurtAddValue)
                --hero.m_tAttributeChangeStateList.m_nBeCritHurtAddValue = {value=self.m_nBeCritHurtAddValue}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_BECRIT_HURT_ADD_VALUE,param = self.m_nBeCritHurtAddValue})
                end
            end
        end
    end
end

--@brief    改变回血加成
function BattleMsgBossMapSkill:_ChangeRecovery(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgBossMapSkill:_ChangeRecovery")
    if isBuff == nil then
        for i, hero in pairs (targetHeroList) do
            WZLog("BattleMsgBossMapSkill:_ChangeRecovery two", hero:getBattleId(), skillType, tostring(self.m_nRecoveryAddPercent))
            if skillType == EffectTypeConfig.CHANGE_RECOVERY_PERCENT then
                hero:changeAttrListValue("m_nRecoveryAddPercent", self.m_nRecoveryAddPercent)
                --hero.m_tAttributeChangeStateList.m_nRecoveryAddPercent = {value=self.m_nRecoveryAddPercent}
                --幻化伤害减免
                if self.m_tSkillConfig and self.m_tSkillConfig.skill_type == 4 then
                    hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.CHANGE_RECOVERY_PERCENT,param = self.m_nRecoveryAddPercent})
                end
            end
        end
    end
end

--@brief    免坑
function BattleMsgBossMapSkill:_NoHole(targetHeroList, skillType, isBuff)
    WZLog("BattleMsgBossMapSkill:_NoHole")
    if isBuff == nil then
        WZLog("BattleMsgBossMapSkill:_NoHole two", hero:getBattleId(), skillType, tostring(self.m_nNoHole))
    end
end

--@brief    死亡
function BattleMsgBossMapSkill:_Dead(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_Dead")
    if not targetHeroList then
       self.m_tOwner:setDead(true,8)
       return
    end
    
    for i, hero in pairs (targetHeroList) do
        WZLog("BattleMsgBossMapSkill:_Dead two", hero:getBattleId())

        hero:setDead(true,9)
    end
end

--@brief    传送
function BattleMsgBossMapSkill:_Transer(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_Transer")

    if self.m_bIsTranser == nil then 
        self.m_bIsTranser = true
        self.m_nShootDeltaTime = 0

        local randList = WBattleGlobal:getCurrent().m_tBattleRand

        for i, hero in pairs (targetHeroList) do
            
            local randIndex = (WBattleGlobal:getCurrent():getTurnTimes() + hero:getBattleId()) % 10 + 1
            local randValue = randList[randIndex] % #self.m_tTransferPos + 1
            WZLog("BattleMsgBossMapSkill:_Transer two", hero:getBattleId(), randIndex, randValue)
            hero:setPosition(Vector2:create(self.m_tTransferPos[randValue].x,self.m_tTransferPos[randValue].y))
            hero:setMoveUpdatable(true)
        end
    else
        self.m_nShootDeltaTime = self.m_nShootDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
        if self.m_nShootDeltaTime >= 1.5 then
            return true
        end
    end
    return false
end

--@brief    吸引
function BattleMsgBossMapSkill:_TranserMove(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_TranserMove")
    local boss = self.m_tOwner
    local targetPos = boss:getPosition()

    for i, hero in pairs (targetHeroList) do
        --WZLog("BattleMsgBossMapSkill:_TranserMove two", hero:getBattleId(), self.m_nTransferMoveDistance)
        local heroPos = hero:getPosition()
        local result = heroPos.x > targetPos.x and targetPos.x + self.m_nTransferMoveDistance or targetPos.x - self.m_nTransferMoveDistance
        hero:setPosition(Vector2:create(result,heroPos.y))
        hero:setMoveUpdatable(true)
    end
    
    return true
end

--@brief    添加技能效果
function BattleMsgBossMapSkill:_doSkillEffect(skillParm)
    --WZLog("BattleMsgBossMapSkill:_doSkillEffect",skillParm)
    if skillParm then
        for i, skillParm in pairs (skillParm) do
            self:_doSkillEffectParser(skillParm,i,true)
        end
        return
    end

    local effect = self.m_tSkillEffectParm
    for i, skillParm in pairs (effect) do
        --WZLog("BattleMsgBossMapSkill:_doSkillEffect",Serialize(skillParm))
        self:_doSkillEffectParser(skillParm,i)
    end

    table.insert(self.m_tOwner.m_tActiveSkillList, self.m_nSkillId)
    
    return true
end

--@brief 技能效果解析
function BattleMsgBossMapSkill:_doSkillEffectParser(skillParm,i,isMoment)
    i = i or 1
    local boss = self.m_tOwner
    while skillParm do
        local effectParm = skillParm--skillParm[1]
        local targetParm = self.m_tSkillTargetChoose --skillParm[2]
        local flashParam = {} --skillParm[2] 
        local flashParent = {} --skillParm[3] 
        local takeEffectParm = effectParm[1]
        --WZLog("BattleMsgBossMapSkill:_doSkillEffectParser",i, boss:getId(), tostring(boss.m_nUseSkillState), tostring(takeEffectParm), Serialize(skillParm))
        
        local turnTime = WBattleGlobal:getCurrent().m_nTurnTimes
        local effect = effectParm[3] .. "_" ..effectParm[4]

        local isCanTakeEffect = false
        if boss.m_tSkillTakeEffectInfo == self.m_nSkillId and boss.m_tSkillTakeEffectIndex and #boss.m_tSkillTakeEffectIndex > 0 then
            for j,u in pairs (boss.m_tSkillTakeEffectIndex) do
                if i == u then
                    isCanTakeEffect = true
                    break
                end
            end
        else
            isCanTakeEffect = nil
        end
        if ((isCanTakeEffect == nil and (takeEffectParm == TakeEffectType.USE or (boss.m_bActiveAttack == true and takeEffectParm == TakeEffectType.HIT) or (boss.m_bActiveAttack == true and takeEffectParm == TakeEffectType.COLLISION))) or isCanTakeEffect == true) and (effectParm.isTakeEffect == nil or turnTime > effectParm.isTakeEffect) then
            local targetParm = effectParm[2]
            effectParm.isTakeEffect = turnTime
            if self.m_tTargetPlayerId and GDatatab_skill["id_" .. self.m_nSkillId].skill_type == 9 then 
                targetHeroList = self:_getHeroById(self.m_tTargetPlayerId)
            else
                targetHeroList = self:_chooseEffectTarget(takeEffectParm,targetParm)
            end
        
            if takeEffectParm == TakeEffectType.HIT then
                for i, v in pairs(targetHeroList) do
                    local isExist = false
                    if boss.m_tSkillTakeEffectList ~= nil then
                        for j, u in pairs(boss.m_tSkillTakeEffectList) do
                            if v:getBattleId() == u then
                                isExist = true
                            end
                        end
                    else
                        boss.m_tSkillTakeEffectList = {}
                    end
                    if isExist == false then
                        table.insert(boss.m_tSkillTakeEffectList,v:getBattleId())
                    end
                end
            end
            
            WZLog("BattleMsgBossMapSkill:_doSkillEffect two", i , effect, tostring(targetParm), tostring(effectParm[3]), tostring(effectParm[4]))
            
        
            local isEndEffect,flashParam,flashParent = self:_doEffectType(effectParm,targetHeroList,nil)
            if isEndEffect == "return" then
                return
            elseif isEndEffect == "break" then
                break
            end

            self:_doSkillEffectEnd(effect, targetHeroList,flashParam,flashParent,isMoment)
            
        elseif boss.m_bActiveAttack ~= true and takeEffectParm == TakeEffectType.HIT then
            boss.m_tSkillTakeEffectList = {}
            boss.m_tSkillTakeEffectInfo = self.m_nSkillId
            if boss.m_tSkillTakeEffectIndex == nil then
                boss.m_tSkillTakeEffectIndex = {}
            end
            table.insert(boss.m_tSkillTakeEffectIndex, i)

        elseif boss.m_bActiveAttack ~= true and takeEffectParm == TakeEffectType.COLLISION then

            WZLog("碰撞后生效1", self.m_nSkillId)
            boss.m_tSkillTakeEffectCollionList = {}
            boss.m_tSkillTakeEffectCollionInfo = self.m_nSkillId
            if boss.m_tSkillTakeEffectCollionIndex == nil then
                boss.m_tSkillTakeEffectCollionIndex = {}
            end
            table.insert(boss.m_tSkillTakeEffectCollionIndex, i)
        end
        break
    end
end


--@brief 技能效果解析结束
function BattleMsgBossMapSkill:_doSkillEffectEnd(effectType,parms,flashParam,flashParent,isMoment)
    WZLog("BattleMsgBossMapSkill:_doSkillEffectEnd",effectType,#parms,isMoment)
    if isMoment then
        --立即处理效果
        if effectType == EffectTypeConfig.HURT then
            if #parms > 0 then
                self:_waitForSkillHurt(parms,isMoment)
            end
            return
        end
        if effectType == EffectTypeConfig.SPEC_SHOOT then
            self:_specShooting()
            self:_createBullet(self.m_nBulletId)
            if not self.b_isWaitForBulletStep then
                table.insert(self.m_tStepFunction,{self._waitForBulletAndHurt})
                self.b_isWaitForBulletStep = true
            end
            return
            --self:_waitForBulletAndHurt()
        end
        if #flashParam > 0 then
            self:_doFlashSkillEffect(flashParam,flashParent)
            return
        end
    end
    self:_doFlashSkillEffect(flashParam,flashParent)
    self:addStep(effectType, parms)
end


--@brief    起飞
function BattleMsgBossMapSkill:_monsterChangeState(distanceY)
    do return end
    --WZLog("BattleMsgBossMapSkill:_monsterChangeFly",distanceY)
    if not self.m_bMovePlayed then 
        local pos = self.m_tOwner:getPosition()
        local array = CCArray:create()
        
        array:addObject(CCMoveTo:create(3.0,GlobalMethod:ccp(pos.x,pos.y + distanceY)))
        array:addObject(CCCallFunc:create(function() self.m_bIsMoveEnd = true end))
        self.m_tOwner:changeState("animAir")
        self.m_tOwner:getAnimation():getAnimNode():runAction(CCSequence:create(array))
        
        self.m_bMovePlayed = true
        self.m_bIsMoveEnd = false
    end
    if self.m_bIsMoveEnd then
        return true
    end
    self:_zoomToHero()
    return false
end

--@brief    创建技能效果特效
function BattleMsgBossMapSkill:_doFlashSkillEffect(flashParam,flashParent)
    if flashParam then
        self:_createSkillEffect(flashParam,flashParent)
    end
end

--@brief    获取特效信息
function BattleMsgBossMapSkill:_getEffectInfo(effectId,conType,target,isNoCtrl)
    local info = {}
    info.effectId = effectId
    info.target = target
    info.isNoCtrl = isNoCtrl
    info.conType = conType or EffectPosType.MYSELF

    if info.conType == EffectPosType.MYSELF or info.conType == EffectPosType.LINE then
        info.pos = self.m_tOwner:getPosition() or BattleCommon:getPointTable(0,0)
    elseif info.conType == EffectPosType.SCENE then 
        local size = SceneBattle:getFrontLayer():getContentSize()
        info.pos = BattleCommon:getPointTable(size.width/2, size.height/2)--self.m_tOwner:getAttackPos() or BattleCommon:getPointTable(0,0)
    elseif info.conType == EffectPosType.TARGET then
        info.pos = target:getPosition()
        --WZLog("BattleMsgBossMapSkill:_getEffectInfo",info.pos.x,info.pos.y)
        --WZLog("BattleMsgBossMapSkill:_getEffectInfo")
    else
        info.pos = BattleCommon:getPointTable(0,0)
    end
     --WZLog("BattleMsgBossMapSkill:_getEffectInfo2",info.pos.x,info.pos.y)
    return info
end

--@brief    创建特效
function BattleMsgBossMapSkill:_initEffect(effectInfo)
    WZLog("BattleMsgBossMapSkill:_initEffect",tostring(effectInfo.effectId),tostring(effectInfo.conType),effectInfo.isNoCtrl,effectInfo.target)
    if effectInfo.effectId == -1 or effectInfo.effectId == nil then 
         --WZLog("BattleMsgBossMapSkill:_initEffect2",effectInfo.effectId)
        return
    end

    if self.g_tEffectList[effectInfo.effectId] then
        return
    end

    local effect  = BattleEffect:createAnimation(effectInfo.effectId)
    local pos =  effectInfo.pos 
    effect:setPosition(effectInfo.pos)
    SceneBattle:getFrontLayer():addChild(effect:getAnimNode())
   
    --非自动移除特效 保存在列表中手动清理
    if not effect.m_bIsAutoRemove then
        self.g_tEffectList[effectInfo.effectId] = effect
    else
        if not effectInfo.isNoCtrl and effect:getIsBlockMsg() then
            self.m_bIsBlockMsg = true
            local function effectCB()
               self.m_bIsBlockMsg = false
            end

            effect:addEndCallBack(effectCB)
        end
    end
    if not effectInfo.isNoCtrl and effect.m_bIsOnStep then
        local function effectStepCB(effectDoneId,screenSpring)
            self:effectStepCallBack(effectDoneId,screenSpring)
        end
        effect:setStepCallBack(effectStepCB)
    end

    effect:playEffect()
    --[[
    local rotaRe = nil
    --  激光类型 调整scale 位置
    if effectInfo.conType == EffectPosType.LINE and effectInfo.target then
        local pos1 = effectInfo.target:getPosition()
        local pos2 = effect:getPosition()
        local effectPos = BattleCommon:getPointTable((pos1.x + pos2.x)/2,(pos1.y + pos2.y)/2)
        local rotation =  math.atan((pos1.y - pos2.y)/(pos1.x - pos2.x)) * 180 / math.pi
        if pos1.x < pos2.x then
            rotation = -rotation
        else
            rotation = 180 - rotation
        end
        rotaRe = rotation
        local distance = math.sqrt(math.pow((pos1.y-pos2.y),2)+math.pow((pos1.x-pos2.x),2)) 
        local scale = distance/effect:getEffectSize().width
        --WZLog("BattleMsgBossMapSkill:_initEffect",pos1.x,pos2.y,pos2.x,pos2.y,rotation,scale,effect:getEffectSize().width,effect:getEffectSize().height)
        effect:setRotation(rotation)
        effect:setScaleX(scale)
        effect:setPosition(effectPos)

    end
    --]]
    effect:setFlipX(self.m_tOwner.m_bIsFilpX)

    return effect
end

--@brief    特效步骤回调
--@desc     传入id 重新获取效果配置，不传入id直接使用原技能指向效果id（分段动作 isHurtAdvance  = 1 执行）
function BattleMsgBossMapSkill:effectStepCallBack(effectDoneId,screenSpring)
    --WZLog("BattleMsgBossMapSkill:effectStepCallBack",effectDoneId)
    local config = nil
    if not effectDoneId or effectDoneId == self.m_nSkillEffcetId then 
        param = self.m_tSkillEffectParm
    else
        local effectConfig = self:_getEffectData(effectDoneId)
        param = effectConfig and effectConfig.effect or {{0,4,-1,1}}
    end
    
    self:_doSkillEffect(param)
    if screenSpring then
        self:_setSceneSpring(BattleCommon:getPointTable(0,0))
    end
end

function BattleMsgBossMapSkill:_clearEffect(effectId)
    WZLog("BattleMsgBossMapSkill:_clearEffect",effectId)

    local effect = self.g_tEffectList[effectId]
    
    if not effect then
        return
    end

    if effect:getAnimNode():getParent() then
        effect:getAnimNode():removeFromParentAndCleanup(true)
    end
    self.g_tEffectList[effectId] = nil
end

--@brief    创建技能特效 
function BattleMsgBossMapSkill:_createSkillEffect(effectString,effectParent)
    --WZLog("BattleMsgBossMapSkill:_createSkillEffect one",effectString,effectParent)
    local t = type(effectString)
    local nSplitArray = nil
    if t == "string" or t == "number"then
       effectString = string.gsub(effectString, " ", "")
       nSplitArray = SplitStringWithSeparator(effectString, ",")
    elseif t == "table" then
        nSplitArray = effectString
       -- WZLog("BattleMsgBossMapSkill:_createSkillEffect two",#effectString)
    end
    local effectList = {}
    local lineIndexs = {}

    for i, v in pairs(nSplitArray) do
        if v == nil or v == "" then
            break
        end
        local effectId = tonumber(v)
        --WZLog("BattleMsgBossMapSkill:_createSkillEffect two",i,effectId)

        local conType = EffectPosType.MYSELF
        if effectParent and effectParent[i] then
            conType = effectParent[i]
        end
        if conType == EffectPosType.TARGET or conType == EffectPosType.LINE then
            --对多个目标创建同一特效，只有第一个特效做回调效果处理
            for k = 1,#self.m_tSkillTargetChoose do
                local target = self.m_tSkillTargetChoose[k]
                local isNoCtrl = true
                if k == 1 then
                    isNoCtrl = false
                end
                local effectInfo = self:_getEffectInfo(effectId,conType,target,isNoCtrl)
                local effect = self:_initEffect(effectInfo)
                table.insert(effectList,effect)
                if conType == EffectPosType.LINE then
                    table.insert(lineIndexs,i)
                end
            end
        else
            --自身创建特效
            local effectInfo = self:_getEffectInfo(effectId,conType,target,isNoCtrl)
            local effect = self:_initEffect(effectInfo)
            table.insert(effectList,effect)
        end
    end
    --直线特效 头 尾rotation调整(必须包含3个)
    if #lineIndexs > 0 then
        for i = 1,#lineIndexs do
            index = lineIndexs[i]
            effectLine = effectList[index]
            effcetBegin = effectList[index+1]
            effectEnd = effectList[index+2]
            self:_setLineEffectView(effcetBegin,effectLine,effectEnd)
        end
    end
end

--@brief 调整激光连线类特效
function BattleMsgBossMapSkill:_setLineEffectView(effcetBegin,effectLine,effectEnd)
   local pos1 = effcetBegin:getPosition()
        local pos2 = effectEnd:getPosition()
        local effectPos = BattleCommon:getPointTable((pos1.x + pos2.x)/2,(pos1.y + pos2.y)/2)
        local rotation =  math.atan((pos1.y - pos2.y)/(pos1.x - pos2.x)) * 180 / math.pi
        if pos1.x > pos2.x then
            rotation = -rotation
        else
            rotation = rotation
        end
        local distance = math.sqrt(math.pow((pos1.y-pos2.y),2)+math.pow((pos1.x-pos2.x),2)) 
        local scale = distance/effectLine:getEffectSize().width
        --WZLog("BattleMsgBossMapSkill:_setLineEffectView",pos1.x,pos1.y,pos2.x,pos2.y,rotation,scale,effectLine:getEffectSize().width,effectLine:getEffectSize().height)
        --WZLog("BattleMsgBossMapSkill:_setLineEffectView2",effectPos.x,effectPos.y,rotation)
        effectLine:setRotation(rotation)
        effectLine:setScaleX(scale)
        effectLine:setPosition(effectPos)

        effcetBegin:setRotation(rotation)
        effectEnd:setRotation(rotation)
end

--@brief    等待技能受伤
function BattleMsgBossMapSkill:_waitForSkillHurt(targetHeroList,isMoment)
    WZLog("BattleMsgBossMapSkill:_waitForSkillHurt")

    local hero = self.m_tOwner
    if isMoment or ((hero:getAnimation():isPlaying(hero:getAnimationName("standby")) or hero:getAnimation():isCurrentAnimationDone() == true) and self:_getIsSceneSpring() == false) then
        if not isMoment then
            self:_setSceneSpring(BattleCommon:getPointTable(0,0))
        end
        self.m_tOwner.m_bActiveAttack = true
  
        if self.m_tOwner.m_tHitTargets == nil then
            self.m_tOwner.m_tHitTargets = {}
        end
        for i,v in pairs(targetHeroList) do
            local isExist = false
            for j, u in pairs (self.m_tOwner.m_tHitTargets) do
                if v:getBattleId() == u:getBattleId() then
                    isExist = true
                end
            end
            if  isExist == false then
                table.insert(self.m_tOwner.m_tHitTargets, v)
                WZLog("BattleMsgBossMapSkill:_waitForSkillHurt one", v:getBattleId())
            end
        end


        local hero = self.m_tOwner
        if hero.m_tHitTargets ~= nil and #hero.m_tHitTargets > 0 and hero.m_tSkillTakeEffectInfo ~= nil then
            local isSkillEffectTaked = false
            --WZLog("BattleMsgBossMapSkill:_updateBullet two-3.0", #hero.m_tHitTargets, #hero.m_tSkillTakeEffectList)
            local charas,values,hurtRatios = self:_checkSkillHurt(targetHeroList)
            charas = self:_charaAddHurtValue(charas,values,hurtRatios)
            if #hero.m_tHitTargets <= #hero.m_tSkillTakeEffectList then
                isSkillEffectTaked = true
            end
            if isSkillEffectTaked == false then
                self.m_nSkillStatusCount = self.m_nSkillStatusCount + 1

                WMonsterAI:castSkill(nil,
                    nil,
                    nil,
                    {[1]=SkillTypeConfig.HIT_DO_EFFECT},
                    nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                    nil,
                    nil,
                    nil,nil,
                    nil,nil,nil,nil,
                    hero.m_tSkillTakeEffectInfo,
                    nil,
                    nil, TakeEffectType.HIT,
                    nil,
                    targetHeroList
                    )
            end
        else
            --WZLog("BattleMsgBossMapSkill:_updateBullet two-4.1")
            local charas,values,hurtRatios = self:_checkSkillHurt(targetHeroList)
            charas = self:_charaAddHurtValue(charas,values,hurtRatios)
        end

        return true
    else
        return false
    end    
end

--@brief    检查技能伤害
function BattleMsgBossMapSkill:_checkSkillHurt(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_checkSkillHurt")
    return BattleMethod:checkSkillHurt(self.m_tOwner,targetHeroList)
    --[[
    local tHurtCharas = targetHeroList
    local tHurtValues = {}

    for i, targetHero in pairs(tHurtCharas) do
        local hurt = 0
        hurt = WBossBullet:calculateHurt(0,self.m_tOwner,targetHero)
        table.insert(tHurtValues,hurt)
    end

    return tHurtCharas,tHurtValues
    ]]
end

--@brief    选择目标
function BattleMsgBossMapSkill:_chooseTarget(hero,effectParm)
    -- hero = hero or self.m_tOwner

    -- local chooseTargetType = effectParm[1]
    -- --self.m_tSkillTargetHeroList = {}
    -- local tSkillTargetHeroList = {}
    -- if chooseTargetType == ChooseTargetConfig.RANDOM then
    --     table.insert(tSkillTargetHeroList, WMonster:getRandomPlayer())
    -- elseif chooseTargetType == ChooseTargetConfig.NEAREST then
    --     table.insert(tSkillTargetHeroList, self.m_tOwner:getNearestPlayer())
    -- elseif chooseTargetType== ChooseTargetConfig.FAREST then
    --     table.insert(tSkillTargetHeroList, WMonster:getFarestPlayer())
    -- elseif chooseTargetType == ChooseTargetConfig.HP_MAX then
    --     table.insert(tSkillTargetHeroList, WMonster:getHpMaxPlayer())
    -- elseif chooseTargetType == ChooseTargetConfig.HP_MIN then
    --     table.insert(tSkillTargetHeroList, WMonster:getHpMinPlayer())
    -- elseif chooseTargetType == ChooseTargetConfig.NEAR_BOSS_LIST then
    --     WZLog("BattleMsgBossMapSkill:_chooseTarget",effectParm[2][1])
    --     _, tSkillTargetHeroList = self.m_tOwner:getHeroNearBoss(effectParm[2][1])
    -- elseif chooseTargetType == ChooseTargetConfig.NEAR_POSITION_LIST then
    --     _, tSkillTargetHeroList = self.m_tOwner:getHeroNearPos(effectParm[2][1],effectParm[2][2])
    -- elseif chooseTargetType == ChooseTargetConfig.ALL_HERO then
    --     tSkillTargetHeroList = WMonster:getAllPlayer()
    -- elseif chooseTargetType == ChooseTargetConfig.MYSELF then
    --     table.insert(tSkillTargetHeroList, self.m_tOwner)
    -- elseif chooseTargetType == ChooseTargetConfig.ALL_BOSS then
    --     tSkillTargetHeroList = WMonster:getAllMonsterBoss()
    -- elseif chooseTargetType == ChooseTargetConfig.DISTANCE_X then
    --     local centerPos = self.m_tOwner:getAttackPos() --指定中心点或者以自身为中心计算
    --     tSkillTargetHeroList = WMonster:getDistanceXPlayer(centerPos,effectParm[2][1],effectParm[2][2])
    -- elseif chooseTargetType == ChooseTargetConfig.DISTANCE then
    --     local centerPos = effectParm[3] and BattleCommon:getPointTable(effectParm[3][1],effectParm[3][2]) or hero:getPosition() --指定中心点或者以自身为中心计算
    --     tSkillTargetHeroList = WMonster:getDistancePlayer(centerPos,effectParm[2][1],effectParm[2][2],effectParm[2][3])
    -- elseif chooseTargetType == ChooseTargetConfig.TARGET_IN_RECT then
    --     local x = effectParm[2][1]
    --     local y = effectParm[2][2]
    --     local tx = x + effectParm[2][3]
    --     local ty = y + effectParm[2][4]
    --     local result,heroList = WMonster:getPlayerWithArea(x, tx, y, ty,true)
    --     tSkillTargetHeroList = heroList
    -- elseif chooseTargetType == ChooseTargetConfig.DISTANCE_TEAM_POS then
    --     local isMyTeam = effectParm[2][1] == 0 and true or false
    --     local list
    --     if isMyTeam then
    --         list = self.m_tOwner:getMyTeam()
    --     else
    --         list = self.m_tOwner:getMyEnemy()
    --     end

    --     local centerPos = effectParm[3]
    --     for i,v in pairs(list) then
    --         if BattleCommon:getPointDis(centerPos,v:getPosition) <= effectParm[2][2] then
    --             table.insert(tSkillTargetHeroList,v)
    --         end
    --     end
    -- end
    -- WZLog("BattleMsgBossMapSkill:_chooseTarget",#tSkillTargetHeroList)
    -- return tSkillTargetHeroList
    return BattleChooseMethod:chooseTarget(hero,effectParm)
end

--@brief 播放技能动作
function BattleMsgBossMapSkill:_playSkillAnimation(name,isOnce)
    isOnce = isOnce or false
    self.m_tOwner:getAnimation():play(self.m_tOwner:getAnimationName(name),isOnce)
    local shockScreen = self.m_tOwner:getShockScreenByAniName(name)
    if shockScreen then
        self:_setSceneSpring(BattleCommon:getPointTable(0,0))
    end
    -- body
end

--@brief    准备施放技能动作
function BattleMsgBossMapSkill:_readySkillAction()
    WZLog("BattleMsgBossMapSkill:_readySkillAction")
    if self.m_tSkillConfig.readySkillAnim and self.m_tSkillConfig.readySkillAnim ~= -1 then
        self:_playSkillAnimation(self.m_tSkillConfig.readySkillAnim,false)
    end

    if self.m_tSkillConfig.readySkillSound and self.m_tSkillConfig.readySkillSound ~= -1 then
        SoundManager:playEffectSound(self.m_tSkillConfig.readySkillSound..".mp3")
    end

    if self.m_tSkillConfig.readySkillEffects and self.m_tSkillConfig.readySkillEffects ~= -1 then
        self:_createSkillEffect(self.m_tSkillConfig.readySkillEffects)
    end
    return true
end

--@brief    施放技能动作
function BattleMsgBossMapSkill:_doSkillAction()
    WZLog("BattleMsgBossMapSkill:_doSkillAction")
    local hero = self.m_tOwner
    if hero:getAnimation():isPlaying(hero:getAnimationName("standby")) or hero:getAnimation():isCurrentAnimationDone() == true then
        if not self.m_bDoSkillAction then
            --第一次做动作处理
            self.m_bDoSkillAction = true
             if self.m_tSkillConfig.doSkillSound and self.m_tSkillConfig.doSkillSound ~= -1 then
                SoundManager:playEffectSound(self.m_tSkillConfig.doSkillSound..".mp3")
            end

            if self.m_tSkillConfig.doSkillEffects and self.m_tSkillConfig.doSkillEffects ~= -1 then
                self:_createSkillEffect(self.m_tSkillConfig.doSkillEffects)
            end
            
            if self.m_tSkillConfig.doSkillAnim and self.m_tSkillConfig.doSkillAnim ~= -1 then
                self.m_tDoSkillList = {}

                local actionStr = string.gsub(self.m_tSkillConfig.doSkillAnim, " ", "")
                local actionList = SplitStringWithSeparator(actionStr, ",")
                for i, action in pairs (actionList) do
                    table.insert(self.m_tDoSkillList,action)
                end
                --self.m_tOwner:getAnimation():play(self.m_tOwner:getAnimationName(self.m_tDoSkillList[1]),false)
                self:_playSkillAnimation(self.m_tDoSkillList[1],false)
                table.remove(self.m_tDoSkillList,1)
                if #self.m_tDoSkillList < 1 then
                    return true
                end
            else
                return true
            end
        else
            --最后一个动作判断由_endSkillAction判断
            if self.m_tDoSkillList and #self.m_tDoSkillList >= 1 then      
                local index = #self.m_tDoSkillEffectList - #self.m_tDoSkillList
                local effectId = self.m_tDoSkillEffectList[index]
                --WZLog("doSkillEffectList",index,#self.m_tDoSkillEffectList,effectId)
                --self.m_tOwner:getAnimation():play(self.m_tOwner:getAnimationName(self.m_tDoSkillList[1]),false)
                self:_playSkillAnimation(self.m_tDoSkillList[1],false)
                table.remove(self.m_tDoSkillList,1)
                if tonumber(effectId) ~= -1 then
                    self:effectStepCallBack(effectId)
                end
                 if #self.m_tDoSkillList < 1 then
                    return true
                end

            end
        end
    end
    return false
end

--@brief    结束施放技能动作
function BattleMsgBossMapSkill:_endSkillAction()
    WZLog("BattleMsgBossMapSkill:_endSkillAction")
    local hero = self.m_tOwner
    if hero:getAnimation():isPlaying(hero:getAnimationName("standby")) or hero:getAnimation():isCurrentAnimationDone() == true then
        if self.m_tSkillConfig.endSkillAnim and self.m_tSkillConfig.endSkillAnim ~= -1 then
            self:_playSkillAnimation(self.m_tSkillConfig.endSkillAnim,false)
        end

        if self.m_tSkillConfig.endSkillSound and self.m_tSkillConfig.endSkillSound ~= -1 then
            SoundManager:playEffectSound(self.m_tSkillConfig.endSkillSound..".mp3")
        end

        if self.m_tSkillConfig.endSkillEffects and self.m_tSkillConfig.endSkillEffects ~= -1 then
            self:_createSkillEffect(self.m_tSkillConfig.endSkillEffects)
        end

        if self.m_tSkillConfig.isHurtAdvance and self.m_tSkillConfig.isHurtAdvance ~= -1 then
            self:effectStepCallBack(self.m_nSkillEffcetId)
        end
        return true
    end
    return false
end

--@brief    获取技能表配置
function BattleMsgBossMapSkill:_getSkillData(id)
    --if self.m_tOwner:getType() == 0 then
        return CopyTable(GDatatab_skill["id_"..id])
    --end
    --return CopyTable(SkillConfig["id_"..id])
end

--@brief    获取技能效果表配置 
function BattleMsgBossMapSkill:_getEffectData(id)
    if self.m_tOwner:getType() == 0 then
        return CopyTable(GDatatab_effect["id_"..id])
    else
        return CopyTable(EffectConfig["id_"..id])
    end
end

--@brief    获取技能配置
function BattleMsgBossMapSkill:_getSkillConfig()
    WZLog("BattleMsgBossMapSkill:_getSkillConfig", self.m_nSkillId)
    local config = self:_getSkillData(self.m_nSkillId)
    if config.skill_type ~= 1 and config.skill_type ~= 4 and config.skill_type ~= 5 then
        self.m_tOwner.m_bIsUseSkill = true
    end
    self.m_tSkillConfig = config

    if config.doSkillEffectList and tonumber(config.doSkillEffectList) ~= -1 then
        self.m_tDoSkillEffectList = {}
        local effectStr = string.gsub(config.doSkillEffectList, " ", "")
        local effectList = SplitStringWithSeparator(effectStr, ",")
        for i, effect in pairs (effectList) do
            table.insert(self.m_tDoSkillEffectList,effect)
        end
    end
    if not config or tonumber(config.effect_id[1][1]) == -1 then
        self.m_tSkillEffectParm = {{0,4,-1,1}}
    else
        self.m_tSkillEffectParm = self:_getEffectData(config.effect_id[1][1]).effect--self:_SplitAiStringWithSeparator(self:_getEffectData(config.effect).effect)
    end
    
    self.m_nSkillEffcetId = config.effect_id[1][1] --技能效果id

    self.m_tSkillTargetChoose = self:_chooseTarget(self.m_tOwner,{[1]=config.choose,[2]=config.chooseParm[1],[3]=config.chooseParm[2]})

    --调整技能方向
    self:updateFlipX(self.m_tSkillTargetChoose[1])
    
    local aichange = config.aichange and tonumber(config.aichange) or nil
    if aichange == -1 then
        aichange = nil
    end 
    self.m_nSkillAiChange = aichange

    WZLog("BattleMsgBossMapSkill:_getSkillConfig two",self.m_tSkillTargetChoose, Serialize(self.m_tSkillEffectParm))
end

--@brief    根据分隔符拆分ai字符串"
function BattleMsgBossMapSkill:_SplitAiStringWithSeparator(s)
    WZLog("SplitAiStringWithSeparator 0", s)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    local sSeparator = " | "
    local sChange = "%]%&%["
    local sChanged = " | "
    
    s = string.gsub(s, " ", "")
    s = string.gsub(s, sChange, sChanged)
    s = string.gsub(s, "%[", "")
    s = string.gsub(s, "%]", "")
    WZLog("SplitAiStringWithSeparator 1", s)
    local sSplited = " | "
    nSplitArray = SplitStringWithSeparator(s, sSplited)
    
    for i, v in pairs(nSplitArray) do
        if v == nil or v == "" then
            break
        end
        WZLog("SplitAiStringWithSeparator array: ", tostring(v), i)
        nSplitArray[i] = self:_splitStringWithSeparator(v, "|")
        for j, u in pairs(nSplitArray[i]) do
            if u == nil or u == "" then
                break
            end
            WZLog("SplitAiStringWithSeparator array: ", tostring(u), j)
            nSplitArray[i][j] = self:_splitStringWithSeparator(u, ",")
            
        end
    end
    
    WZLog("BattleMsgBossMapSkill:SplitAiStringWithSeparator one", Serialize(nSplitArray))
    return nSplitArray
end

function BattleMsgBossMapSkill:_splitStringWithSeparator(s, sSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}

    while true do

       local nFindLastIndex = string.find(s, sSeparator, nFindStartIndex)
       if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(s, nFindStartIndex, string.len(s))
            nSplitArray[nSplitIndex] = tonumber(nSplitArray[nSplitIndex]) or nSplitArray[nSplitIndex]
            break
       end

       nSplitArray[nSplitIndex] = string.sub(s, nFindStartIndex, nFindLastIndex - 1)
       nSplitArray[nSplitIndex] = tonumber(nSplitArray[nSplitIndex]) or nSplitArray[nSplitIndex]
       nFindStartIndex = nFindLastIndex + string.len(sSeparator)
       nSplitIndex = nSplitIndex + 1

    end

    return nSplitArray
end


--@brief    播放变身特效动画
function BattleMsgBossMapSkill:_playTransformAnim()
    WZLog("BattleMsgBossMapSkill:_playTransformAnim")
    self.m_tOwner:addTransAnim()
    return true
end

--@brief    更换Boss动画
function BattleMsgBossMapSkill:_changeBossAnim()
    if self.m_tOwner.m_transAnim:isCurrentAnimationDone() then
        WZLog("BattleMsgBossMapSkill:_changeBossAnim")
        self:_trans()
        return true
    end
    
    return false
end

--@brief    发送Boss变身协议
function BattleMsgBossMapSkill:_sendBossChangeProtocol()
    WZLog("BattleMsgBossMapSkill:_sendBossChangeProtocol")
    --不是主机，则不发送协议
    

    table.insert(self.m_tOwner.m_tAniFileId, self.m_nTransAniFileId)
    table.insert(self.m_tOwner.m_tAiType, self.m_nTransAiType)
    table.insert(self.m_tOwner.m_tDataId, self.m_nTransDataId)
    table.insert(self.m_tOwner.m_tState, self.m_nTransState or MonsterState.NORMAL)

    if not self.m_tOwner:isCanControl() then
        return true
    end

    local battleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    local guaiBattleId = self.m_tOwner:getBattleId()
    local guaiOldId = self.m_tOwner.m_tDataId[#self.m_tOwner.m_tDataId-1]
    local guaiNewId = self.m_tOwner.m_tDataId[#self.m_tOwner.m_tDataId]

    ProtocolProcessorBattleInterface:send_BATTLE_BossChange(battleId, guaiBattleId, guaiOldId, guaiNewId)
    return true
end

--@brief    变身
function BattleMsgBossMapSkill:_trans()
    WZLog("BattleMsgBossMapSkill:_trans")
    self.m_tOwner:trans(#self.m_tOwner.m_tAniFileId)
    self.m_tOwner:setAppearAttribute(false)
    self.m_tOwner:changeState(self.m_tOwner.m_tState[#self.m_tOwner.m_tAniFileId])
    self.m_tOwner.m_anim:play(self.m_tOwner:getAnimationName("standby"),true)
    --WBattleGlobal:getCurrent():setGuaiInfo(self.m_tOwner, self.m_tOwner.m_sAniFileId, nil)
    return true
end

--@brief    创建大招动画
function BattleMsgBossMapSkill:_readyShowBigSkill()
    WZLog("BattleMsgBossMapSkill:_readyShowBigSkill")
    BattlePlayerBigSkillAnim:readyShow(WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId), nil, true, self.m_tOwner.m_bIsLeftFlip)
    return true
end

--@brief    播放大招动画
function BattleMsgBossMapSkill:_showBigSkill()
    WZLog("BattleMsgBossMapSkill:_showBigSkill")
    if BattlePlayerBigSkillAnim:process() then
        return true
    end
    return false
end


--@brief    发送生成小怪协议
function BattleMsgBossMapSkill:_sendBuildSummonMonster()
    WZLog("BattleMsgBossMapSkill:_sendBuildSummonMonster", tostring(self.m_tOwner:isCanControl()))
    if self.m_bIsSummon == nil then
        self.m_bIsSummon = true

        --获取小怪ID(每帧执行一次)
        self.m_tSummonMonsterBattleId = {}
        self.m_tSummonMonsterId = {}
        self.m_tSummonMonsterIndex = {}
        self.m_tSummonMonsterPositionX = {}
        self.m_tSummonMonsterPositionY = {}
        self.m_tSummonMonsterScale = {}

        local summonCount = 0
        for i, v in pairs(self.m_tSummonMonsterList) do
            v.summonedCount = 0
            for j, u in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
                if u:getId() == v.id then
                    v.summonedCount = v.summonedCount + 1
                end
            end
            v.shouldCount = math.min(v.count, v.maxCount - v.summonedCount)
            summonCount = summonCount + v.shouldCount
        end

        self.m_tBattleIDs = WBattleGlobal:getCurrent():requestGuaiBattleId(summonCount)
        if self.m_tBattleIDs == nil or #self.m_tBattleIDs < summonCount then
            --return false
        end
        self.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        self.m_nPlayerOrGuai = 1
        self.m_nCurrentId = self.m_tOwner:getBattleId()

        for id, summonMonster in pairs(self.m_tSummonMonsterList) do
            for i=1,summonMonster.shouldCount do
                table.insert(self.m_tSummonMonsterBattleId,i)
                table.insert(self.m_tSummonMonsterId,summonMonster.id)
                table.insert(self.m_tSummonMonsterIndex,summonMonster.index)
                table.insert(self.m_tSummonMonsterPositionX,summonMonster.posX[i] or summonMonster.posX[1] + (i-1) * 150)
                table.insert(self.m_tSummonMonsterPositionY,summonMonster.posY[i] or summonMonster.posY[1])
                table.insert(self.m_tSummonMonsterScale,summonMonster.scale)
            end
        end

        if  #self.m_tSummonMonsterBattleId > 0 and self.m_tOwner:isCanControl() then
            WZLog("BattleMsgBossMapSkill:_sendBuildSummonMonster two", self.m_nBattleId, self.m_nPlayerOrGuai, self.m_nCurrentId, #self.m_tSummonMonsterBattleId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)

            ProtocolProcessorBattleInterface:send_BATTLE_BuildGuai(self.m_nBattleId,  self.m_nCurrentId,
                                                                    self.m_tSummonMonsterId,
                                                                   self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)
        else
            self.m_bIsZoom = false
        end

        if WBattleGlobal:getCurrent():isSingleStage() then
            self.m_bIsSummon = nil
            return true
        end
    end
    if self.m_tOwner.guaiId ~= nil and #self.m_tOwner.guaiId > 0 then  
        self.m_bIsSummon = nil
        return true
    else
        WZLog("BattleMsgBossMapSkill:_sendBuildSummonMonster false")
        return false
    end
end

function BattleMsgBossMapSkill:_doSummonAction()
    self.m_tOwner:getAnimation():play(self.m_tOwner:getAnimationName("skill1"),false)
end

--@brief    生成小怪
function BattleMsgBossMapSkill:_buildSummonMonster()
    WZLog("BattleMsgBossMapSkill:_buildSummonMonster")
    if self.m_tOwner:getAnimation():isPlaying(self.m_tOwner:getAnimationName("standby")) or self.m_tOwner:getAnimation():isCurrentAnimationDone() == true then
        self.m_tSummonList = {}
        self.m_tSummonMonsterBattleId = {}
        for i=1,#self.m_tSummonMonsterId do

            if self.m_tOwner.guaiId ~= nil then 
                for j, v in pairs(self.m_tOwner.guaiId) do
                    WZLog("BattleMsgBossMapSkill:_buildSummonMonster zero-1", self.m_tSummonMonsterId[i], v, self.m_tSummonMonsterPositionX[i],self.m_tOwner.guaiPositionX[i])
                    if self.m_tSummonMonsterId[i] == v then
                        self.m_tSummonMonsterBattleId[i] = self.m_tOwner.guaiBattleId[j]
                        table.remove(self.m_tOwner.guaiId, j)
                        table.remove(self.m_tOwner.guaiBattleId, j)
                        table.remove(self.m_tOwner.guaiPositionX, j)
                        table.remove(self.m_tOwner.guaiPositionY, j)
                        WZLog("BattleMsgBossMapSkill:_buildSummonMonster zero-2",i,j,self.m_tSummonMonsterBattleId[i])
                        break
                    end
                end
            end

            local battleId = self.m_tSummonMonsterBattleId[i] or -2
            --单人副本创建小怪 为小怪添加battleId
            if WBattleGlobal:getCurrent():isSingleStage() and WBattleGlobal:getCurrent():getCopyData() then
                battleId = WBattleGlobal:getCurrent():getCopyData():getBuildGuaiIndex()
                WBattleGlobal:getCurrent():getCopyData():addBuildGuaiIndex()
            end
            local monster = WMonster:buildGuai(self.m_tSummonMonsterId[i], self.m_tSummonMonsterScale[i], true, battleId)
            --self:setGuaiInfo(monster, self.m_tSummonMonsterId[i])
            
            WZLog("BattleMsgBossMapSkill:_buildSummonMonster two", i, battleId, monster.m_sAniFileId, monster.m_nPlayerId, 
                monster.m_sPlayerName, monster.m_nLevel, monster.m_nRealLevel, monster.m_nCamp, monster.m_nMaxHP, 
                monster.m_nHP, monster.m_nPF, monster.m_nAttack, monster.m_nCriticalhitAttackRate, monster.m_nDefence, 
                monster.m_nInjuryFree, monster.m_nWreckDefense, monster.m_nReduceCrit, monster.m_nReduceBury, monster.m_nGuaiType)
            monster:setPosition(BattleCommon:getPointTable(self.m_tSummonMonsterPositionX[i],self.m_tSummonMonsterPositionY[i]))
            monster:setBoss(self.m_tOwner)
            table.insert(self.m_tOwner.m_tOwnedMonsterList, monster)
            WBattleGlobal:getCurrent().m_tGuais[battleId] = monster
            SceneBattle:getFrontLayer():addChild(monster:getAnimation():getAnimNode())
            if monster:getMover() then
                WBattleGlobal:getCurrent().m_battleManager:addEntity(monster:getMover())
            end

            monster:setAppearAttribute()
            monster:getAnimation():play(monster:getAnimationName("standby"), true)
            monster:getAnimation():getAnimNode():setAnchorPoint(monster:getSceneAnchorPoint())
            table.insert(self.m_tSummonList, monster)

            if battleId > 0 and not WBattleGlobal:getCurrent():isExpCopy() then
                WZLog("BattleMsgBossMapSkill:_buildSummonMonster three", battleId)
                BattleCtbManager:addCellBattleCtb(battleId)
            else
                monster.m_bIsInCtb = false
            end

            GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.MONSTER_CREATE)
        end
        return true
    end

    return false
end

--@brief    发送射击生成小怪协议
function BattleMsgBossMapSkill:_sendBuildShootedSummonMonster()

    if self.m_tOwner:isCanControl() ~= true then
        return true
    end
    --获取小怪ID(每帧执行一次)
    self.m_tSummonMonsterBattleId = {}
    self.m_tSummonMonsterId = {}
    self.m_tSummonMonsterIndex = {}
    self.m_tSummonMonsterPositionX = {}
    self.m_tSummonMonsterPositionY = {}
    self.m_tSummonMonsterScale = {}

    local summonCount = 0
    for i, v in pairs(self.m_tShootSummonMonsterList) do
        v.summonedCount = 0
        for j, u in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
            if u:getId() == v.id then
                v.summonedCount = v.summonedCount + 1
            end
        end
        v.shouldCount = math.min(v.count, v.maxCount - v.summonedCount)
        summonCount = summonCount + v.shouldCount
    end

    self.m_tBattleIDs = WBattleGlobal:getCurrent():requestGuaiBattleId(summonCount)
    if self.m_tBattleIDs == nil or #self.m_tBattleIDs < summonCount then
        return false
    end
    self.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    self.m_nPlayerOrGuai = 1
    self.m_nCurrentId = self.m_tOwner:getBattleId()

    for id, summonMonster in pairs(self.m_tShootSummonMonsterList) do
        for i=1,summonMonster.shouldCount do
                table.insert(summonMonster.battleId,self.m_tBattleIDs[1])
                table.insert(self.m_tSummonMonsterBattleId,self.m_tBattleIDs[1])
                table.insert(self.m_tSummonMonsterId,summonMonster.id)
                table.insert(self.m_tSummonMonsterIndex,summonMonster.index)
                table.insert(self.m_tSummonMonsterPositionX,summonMonster.posX[i] or summonMonster.posX[1] + (i-1) * 150)
                table.insert(self.m_tSummonMonsterPositionY,summonMonster.posY[i] or summonMonster.posY[1])
                table.insert(self.m_tSummonMonsterScale,summonMonster.scale)
                table.remove(self.m_tBattleIDs,1)
        end
    end

    if #self.m_tSummonMonsterBattleId > 0 then
        WZLog("BattleMsgBossMapSkill:_sendBuildSummonMonster", self.m_nBattleId, self.m_nPlayerOrGuai, self.m_nCurrentId, #self.m_tSummonMonsterBattleId, #self.m_tSummonMonsterId, #self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)

        ProtocolProcessorBattleInterface:send_BATTLE_BuildGuai(self.m_nBattleId, self.m_nPlayerOrGuai, self.m_nCurrentId, 
                                                               summonCount, self.m_tSummonMonsterBattleId, self.m_tSummonMonsterId, 
                                                               self.m_tSummonMonsterPositionX, self.m_tSummonMonsterPositionY)
    end
    return true
end

--@brief    射击生成小怪
function BattleMsgBossMapSkill:_buildShootedSummonMonster(bullet, index)
    WZLog("BattleMsgBossMapSkill:_buildShootedSummonMonster", index)

    local summonMonster = self.m_tShootSummonMonsterList[index]
    for i=1,summonMonster.shouldCount do
        local monster = WMonster:buildGuai(summonMonster.id, summonMonster.scale, true,summonMonster.battleId[i])
        --self:setGuaiInfo(monster, summonMonster.id)
        monster:setPosition(BattleCommon:getPointTable(summonMonster.posX[i] or summonMonster.posX[1],summonMonster.posY[i] or summonMonster.posY[1]))
        monster:setBoss(self.m_tOwner)
        table.insert(self.m_tOwner.m_tOwnedMonsterList, monster)
        SceneBattle:getFrontLayer():addChild(monster:getAnimation():getAnimNode())
        if monster:getMover() then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(monster:getMover())
        end
        monster:setAppearAttribute()
        monster:getAnimation():play(monster:getAnimationName("standby"), true)
    end

    return true
end

--@brief    小怪准备移动
function BattleMsgBossMapSkill:_readyMonsterListMove()
    WZLog("BattleMsgBossMapSkill:_readyMonsterListMove")
    
    self.m_tMoveEndList = {}
    self.m_tTargetPos = {}
    self.m_tMoveOffset = {}
    
    --调整小怪移动方向
    for id, monster in ipairs (self.m_tMonsterList) do
        if monster.m_bIsAir == true then
            local cur_pos = monster.m_anim:getPosition()
            local target_pos = self.m_tMoveEndPos or monster.m_tTargetPlayer:getPosition()
            if BattleCommon:pointDis(cur_pos, target_pos) > self.m_nDefaultDistance then
                target_pos = self:_getMoveDistance(monster)
            end
            self.m_tTargetPos[id] = target_pos
            self.m_tMoveOffset[id] = {x = cur_pos.x - target_pos.x, y = cur_pos.y - target_pos.y}
        end

        monster:adjustDirect(self.m_tMoveEndPos or monster.m_tTargetPlayer:getPosition())
        monster.m_nAttackArea = 80
        if monster:isInBuffState(EffectTypeConfig.LIMIT_MOVE) then
           table.insert(self.m_tMoveEndList,monster)
        end
    end
end

--@brief    计算应该移动的距离
function BattleMsgBossMapSkill:_getMoveDistance(monster)
    local cur_pos = monster:getPosition()
    local target_pos = self.m_tMoveEndPos or monster.m_tTargetPlayer:getPosition()
    local x1 = cur_pos.x
    local y1 = cur_pos.y
    local x2 = target_pos.x
    local y2 = target_pos.y
    if y1 - y2 == 0 then y2 = y2-1 end
    local k = (x1 - x2) / (y1 - y2)
    local d0 = BattleCommon:pointDis(cur_pos, target_pos)
    local d = self.m_nDefaultDistance
    
    local y3
    if (x1 > x2 and y1 < y2) or (x1 < x2 and y1 < y2) then
        y3 = y1 + d / math.sqrt(k * k + 1)
    else
        y3 = y1 - d / math.sqrt(k * k + 1)
    end
    local x3 = x1 - k * (y1 - y3)
    local d1 = BattleCommon:pointDis(cur_pos, BattleCommon:getPointTable(x3, y3))
    
    WZLog("BattleMsgBossMapSkill:_getMoveDistance", x3, y3, x1, y1, x2, y2, d0, d1, d, k)
    
    return {x = x3, y = y3}
end

--@brief    小怪群移动
function BattleMsgBossMapSkill:_monsterListMove()
    self:_followMonsterListMove()

    if not self.m_bMovePlayed then
        for id, monster in pairs (self.m_tMonsterList) do
            if not monster:isInBuffState(EffectTypeConfig.LIMIT_MOVE) then
                monster:getAnimation():play(monster:getAnimationName("move"), true)
            end
        end
        self.m_bMovePlayed = true
    end

    for id, monster in pairs (self.m_tMonsterList) do
        local isMoveEnd = false
        for index, monsterMoveEndId in pairs (self.m_tMoveEndList) do
            if monster:getBattleId() == monsterMoveEndId then
                isMoveEnd = true
            end
        end

        if isMoveEnd == false then
            monster:setPF(self.m_tOwner:getPF()-1)
            monster:setRunStatus(RunStatus.DEF_ST_MOVE)
            
            local cur_pos = monster.m_anim:getPosition()
            local target_pos = self.m_tTargetPos[id] or self.m_tMoveEndPos or monster.m_tTargetPlayer:getAnimation():getPosition()
            
            if self.m_bIsMoveEnd == false then

                monster:setMoveUpdatable(true)
                monster:getMover():setMoveAcceleration(monster.m_tMoveSpeed.x,-1)
            elseif self.m_bIsMoveEnd == false and monster.m_bIsAir == true then
                local pos = {x = cur_pos.x - self.m_tMoveOffset[id].x * self.m_nDt, y = cur_pos.y - self.m_tMoveOffset[id].y * self.m_nDt}
                monster:setPosition(pos)
            end
            
            if monster.m_bIsAir == true and monster.m_tDialog ~= nil and monster.m_tDialog.m_tFollowObjOriginalPos ~= nil then
                local scale = 1
                if monster.m_bIsAir == true then
                    scale = 0.60
                end
                local moveDistance = BattleCommon:getPointTable((monster:getPosition().x - monster.m_tDialog.m_tFollowObjOriginalPos.x) * scale,(monster:getPosition().y - monster.m_tDialog.m_tFollowObjOriginalPos.y) * scale)
                monster.m_tDialog.m_root:setPositionX(monster.m_tDialog.m_tOriginalPos.x + moveDistance.x)
                monster.m_tDialog.m_root:setPositionY(monster.m_tDialog.m_tOriginalPos.y + moveDistance.y)
            end
        
        

            --WZLog("guaiMove")
            --达到可进行攻击的距离则移动结束

            WZLog("BattleMsgBossMapSkill:_monsterListMove zero", monster:getBattleId(), cur_pos.x, cur_pos.y, target_pos.x, target_pos.y, monster.m_nAttackArea, monster.m_tTargetPlayer:getRadiusForHurt(), tostring(BattleCommon:checkCircleCollosion(cur_pos,monster.m_nAttackArea,target_pos,monster.m_tTargetPlayer:getRadiusForHurt())))

            if BattleCommon:checkCircleCollosion(cur_pos,monster.m_nAttackArea,target_pos,0) == true then
                WZLog("BattleMsgBossMapSkill:_monsterListMove one", monster:getBattleId(), cur_pos.x, cur_pos.y, target_pos.x, target_pos.y)
                table.insert(self.m_tMoveEndList, monster:getBattleId())

                monster:setMoveUpdatable(false)
                monster:getMover():setMoveAcceleration(0,0)

                monster:getAnimation():play(monster:getAnimationName("standby"), true)

                if self.m_bIsAtkAfterMove == true then
                    self.m_isCanAttack = true
                end
                
                monster:setActFinished(true)
            elseif monster:getPF() <= 0 or (monster.m_bIsAir == true and BattleCommon:pointDis(cur_pos, self.m_tTargetPos[id]) < 15 ) then
                WZLog("BattleMsgBossMapSkill:_monsterListMove two", monster:getBattleId())
                table.insert(self.m_tMoveEndList, monster:getBattleId())

                monster:getAnimation():play(monster:getAnimationName("standby"), true)
                monster:setActFinished(true)
            end
        end
    end

    WZLog("BattleMsgBossMapSkill:_monsterListMove three", #self.m_tMonsterList, #self.m_tMoveEndList)
    if #self.m_tMonsterList == #self.m_tMoveEndList then
        WZLog("BattleMsgBossMapSkill:_monsterListMove four")
        self.m_bIsMoveEnd = true

        return true
    end

    return false
end

--@brief    屏幕跟踪小怪
function BattleMsgBossMapSkill:_followMonsterListMove()
    if true then
        BattleScreen:followHero(self.m_tOwner:getMover():getMoverPosition())
        WZLog("BattleScreen:followHero 6")
    end
end

--@brief    小怪准备攻击
function BattleMsgBossMapSkill:_readyMonsterListMeleeAttack()
    WZLog("BattleMsgBossMapSkill:_readyMonsterListMeleeAttack")

    for id, monster in pairs (self.m_tMonsterList) do
        monster:adjustDirect(monster.m_tTargetPlayer:getPosition())

        local charas,values = self:_checkMeleeHurt(monster)
        WZLog("BattleMsgBossMapSkill:_readyMonsterListMeleeAttack two", monster:getBattleId())
        if BattleCommon:tableLen(charas) > 0 then
            WZLog("BattleMsgBossMapSkill:_readyMonsterListMeleeAttack three", monster:getBattleId())
            monster:getAnimation():play(monster:getAnimationName("beat"), false)
        end
    end

    self.m_tAttackEndList = {}
    return true
end

--@brief    小怪攻击
function BattleMsgBossMapSkill:_monsterListMeleeAttack()
    WZLog("BattleMsgBossMapSkill:_monsterListMeleeAttack")

    for id, monster in pairs (self.m_tMonsterList) do
        local isAttackEnd = false
        for index, monsterAttackEndId in pairs (self.m_tAttackEndList) do
            if monster:getBattleId() == monsterAttackEndId then
                isAttackEnd = true
            end
        end

        if isAttackEnd == false then
            local hero = monster
            local charas,values,hurtRatios = self:_checkMeleeHurt(monster)
            local actionEnd = hero:getAnimation():isPlaying(hero:getAnimationName("standby")) or hero:getAnimation():isCurrentAnimationDone()
            if (actionEnd or monster.m_bIsAir == true) and BattleCommon:tableLen(charas) > 0 then
                charas = self:_charaAddHurtValue(charas,values,hurtRatios)
                self:_sendHurtProtocol(charas, monster)

                table.insert(self.m_tAttackEndList, monster:getBattleId())
            elseif BattleCommon:tableLen(charas) > 0 then
                table.insert(self.m_tAttackEndList, monster:getBattleId())
            end
        end
    end

    if #self.m_tMonsterList == #self.m_tAttackEndList then
        return true
    end

    return false
end

--@brief    检查近攻伤害
--@return   #1:受伤的人物列表
--@return   #2:受伤值
function BattleMsgBossMapSkill:_checkMeleeHurt(monster)
    WZLog("BattleMsgBossMapSkill:_checkMeleeHurt one")
    return BattleMethod:checkMeleeHurt(monster)
    -- local guai = monster
    -- local tHurtCharas = {}
    -- local tHurtValues = {}
    -- for i,charaList in pairs(guai.m_tCollisionCharacters) do
    --     for id,chara in pairs(charaList) do
    --         if id ~= self.m_tOwner:getBattleId() then
    --             local guaiPos = guai:getMover():getMoverPosition()
    --             guaiPos = {x=guaiPos:getX(),y=guaiPos:getY()}
                
    --             local charaPos = chara:getCenterPos()
    --             charaPos = Vector2:create(charaPos.x,charaPos.y)
                
    --             local nCheckCharacterCollisionRadius = guai.m_nAttackArea --guai.m_anim:getAnimNode():getContentSize().width * 1

    --             WZLog("BattleMsgBossMapSkill:_checkMeleeHurt two", nCheckCharacterCollisionRadius, tostring(BattleCommon:checkCircleCollosion(guaiPos,nCheckCharacterCollisionRadius * 1,charaPos,chara:getRadiusForHurt())))
    --             if not chara:isDead() and chara:getHp() > 0 and BattleCommon:checkCircleCollosion(guaiPos,nCheckCharacterCollisionRadius * 1,charaPos,chara:getRadiusForHurt()) == true then
    --                 local hurtValue = self:_getMeleeHurt(chara, monster)
    --                 tHurtCharas[id] = chara
    --                 tHurtValues[id] = hurtValue
    --             end
    --         end
    --     end
    -- end
    -- return tHurtCharas,tHurtValues
end

--@brief    计算近攻伤害
--@return   #1：伤害
function BattleMsgBossMapSkill:_getMeleeHurt(chara, monster)
    local guai = monster
    local guaiPos = guai:getMover():getMoverPosition()
    local charaPos = chara:getCenterPos()
    
    local hurt = 0
    if chara:getIsInvincible() then
        hurt = 1
    else
        hurt,recordRatio = BattleMethod:getMeleeHurt(chara, monster)
    end

    WZLog("BattleMsgBossMapSkill:_getMeleeHurt", tostring(chara.m_nBuffInvincibleRound), hurt)
    return hurt,recordRatio
end

--@brief    播放准备射击动画
function BattleMsgBossMapSkill:_readyShoot()
    self.m_tOwner.m_bIsUseSkill = true
    self.m_nShootDeltaTime = self.m_nShootDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
    
    local hero = self.m_tOwner
    local isCanRepeatShoot = false
    
    --是否能跳转到射击子弹
    if self.m_nReadyToShootDeltaTime ~= 0 and self.m_nShootDeltaTime >= self.m_nReadyToShootDeltaTime then
        isCanRepeatShoot = true
    elseif self.m_nReadyToShootDeltaTime == 0 and hero:getAnimation():isCurrentAnimationDone() == true then
        isCanRepeatShoot = true
    end

    WZLog("BattleMsgBossMapSkill:_readyShoot", tostring(isCanRepeatShoot), self.m_nReadyToShootDeltaTime, self.m_nShootDeltaTime, tostring(hero:getAnimation():isCurrentAnimationDone()))

    --跳转到射击子弹
    if isCanRepeatShoot then
        SoundManager:playEffectSound(SoundDefine.E_S_SHOOT)
        hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
        self:_repeatShoot()
        return true
    else
        hero:setRunStatus(RunStatus.DEF_ST_READY_SHOOT)
        return false
    end
end

--@brief    射击子弹
function BattleMsgBossMapSkill:_repeatShoot()
    WZLog("BattleMsgBossMapSkill:_repeatShoot")
    
    self.m_nShootDeltaTime = self.m_nShootDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
    
    local hero = self.m_tOwner
    if self.m_nAttTimes <= 0 then
        hero:setRunStatus(RunStatus.DEF_ST_SHOOT)
        return true
    end
    
    local isCanRepeatShoot = false
    
    --是否能射击另一个子弹
    if self.m_nEveryBulletShootDeltaTime ~= 0.5 and self.m_nShootDeltaTime >= self.m_nEveryBulletShootDeltaTime then
        isCanRepeatShoot = true
        elseif self.m_nEveryBulletShootDeltaTime == 0.5 and (hero:getAnimation():isCurrentAnimationDone() == true or self.m_nShootDeltaTime >= self.m_nEveryBulletShootDeltaTime )then
        isCanRepeatShoot = true
    end
    
    if isCanRepeatShoot then
        self.m_nShootDeltaTime = 0
        self:_createBullet()
        if self.m_nAttTimes <=  1 then
            hero:setRunStatus(RunStatus.DEF_ST_SHOOT)
            WBattleGlobal:getCurrent().m_nAttackedCount = self.m_nAttTimes
            self.m_nAttTimes = self.m_nAttTimes - 1
            return true
        else
            hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
            
            self.m_nAttTimes = self.m_nAttTimes - 1
            return false
        end

    else
        hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
        return false
    end
end

--@brief    播放正在射击动画
function BattleMsgBossMapSkill:_shooting()
    --WZLog("BattleMsgBossMapSkill:_shooting")
    
    local hero = self.m_tOwner
    self:_followBullet()
    if hero:getAnimation():isPlaying(hero:getAnimationName("standby")) or hero:getAnimation():isCurrentAnimationDone() == true then
        hero:setRunStatus(RunStatus.DEF_ST_NORMAL)
        hero:setMoveUpdatable(true)
        WBattleGlobal:getCurrent().m_nAttackedCount = 1
        return true
    else
        hero:setRunStatus(RunStatus.DEF_ST_SHOOT)
        return false
    end
end

function BattleMsgBossMapSkill:_specShooting()
    if not self.m_nBulletId and self.m_bWaitingAction then
        return true
    end
    local bulletInfo = BattleMethod:getBossBulletInfo(bulletId)

    self.m_tBulletInfo = bulletInfo
    self.m_bIsOldBulletAnim = bulletInfo.m_bIsOldBulletAnim
    self.m_sBulletAnimMainName = bulletInfo.m_sBulletAnimMainName
    self.m_sBulletAnimFlyName = bulletInfo.m_sBulletAnimFlyName
    self.m_sWeaponName = bulletInfo.m_sWeaponName or self.m_tOwner and self.m_tBoss:getWeaponName()
    self.m_tWeaponAnim = bulletInfo.m_tWeaponAnim--{weapon=self.m_sWeaponName}
    self.m_nBulletAnimScale = bulletInfo.m_nBulletAnimScale
    self.m_nBulletType = bulletInfo.m_nBulletType
    self.m_nCheckCharacterCollisionRadius = bulletInfo.m_nCheckCharacterCollisionRadius
    self.m_bIsPenetrateMap = bulletInfo.m_bIsPenetrateMap
    self.m_nAttTimes = bulletInfo.m_nAttTimes
    self.m_bIsIgnoreDef = bulletInfo.m_bIsIgnoreDef
    self.m_bBulletAnimFlipX = bulletInfo.m_bBulletAnimFlipX
    self.m_bIsNeedExplode = bulletInfo.m_bIsNeedExplode
    self.m_nBulletAnimDefaultDirection = bulletInfo.m_nBulletAnimDefaultDirection
    self.m_nEveryBulletShootDeltaTime = bulletInfo.m_nEveryBulletShootDeltaTime
    self.m_bIsNeedHurt = bulletInfo.m_bIsNeedHurt
    self.m_nScatterNum = bulletInfo.m_nScatterNum
    self.m_tOffset = bulletInfo.m_tOffset or BattleCommon:getPointTable(0,0)
    self.m_tAcceleration = bulletInfo.m_tAcceleration
end

--@brief    等待子弹消失和英雄受伤
function BattleMsgBossMapSkill:_waitForBulletAndHurt()
    WZLog("BattleMsgBossMapSkill:_waitForBulletAndHurt")
    
    if self:_waitForBullet() and self:_waitForHurtNum() then
        BattleScreen:resetZoomToHero()
        return true
    else
        return false
    end
end

--@brief    播放正在射击动画
function BattleMsgBossMapSkill:_shooted()
    return true
end

--@brief    等待子弹消失
function BattleMsgBossMapSkill:_waitForBullet()
    WZLog("BattleMsgBossMapSkill:_waitForBullet")
    
    self:_followBullet()
    if self:_isHaveBullet() == false then
        return true
    else
        return false
    end
end

--@brief    等待受伤数字消失
function BattleMsgBossMapSkill:_waitForHurtNum()
    WZLog("BattleMsgBossMapSkill:_waitForHurtNum")
    
    return not WBattleGlobal:getCurrent():IsAnyOneHurt()
end

--@brief    屏幕移向英雄
function BattleMsgBossMapSkill:_zoomToHero(heroList)
    if WBattleGlobal:getCurrent().m_bIsZoomToHero == true then
        return true
    end
    local hero = (heroList and heroList[1]) or self.m_tOwner
    local isZoom = BattleScreen:zoomToHero(hero:getId() , hero:getPosition())
    WZLog("BattleMsgBossMapSkill:_zoomToHero", hero:getId(), hero:getPosition().x, hero:getPosition().y, tostring(isZoom))
    return isZoom
end

--@brief    屏幕移向生成的小怪
function BattleMsgBossMapSkill:_zoomToSummonMonster()
    WZLog("BattleMsgBossMapSkill:_zoomToSummonMonster")

    local hero = self.m_tOwner.m_tOwnedMonsterList[1]
    return BattleScreen:zoomToHero(hero:getId() , hero:getPosition())
end

--@brief    屏幕移向英雄
function BattleMsgBossMapSkill:_resetZoomOut()
    WZLog("BattleMsgBossMapSkill:_resetZoomOut")

    BattleScreen:resetZoomOut()
    return true
end

--@brief    屏幕显示最大范围
function BattleMsgBossMapSkill:_ZoomOut()
    WZLog("BattleMsgBossMapSkill:_ZoomOut")
    if self.m_bIsZoom == false or WBattleGlobal:getCurrent().m_bIsZoomToHero == true then
        self.m_bIsZoom = nil
        return true
    else
        return BattleScreen:zoomOut(nil,nil)
    end
end

--@brief    对英雄添加受伤数字
--@param    charas:英雄列表
--@param    hurtValue:受伤数字
function BattleMsgBossMapSkill:_charaAddHurtValue(charas,hurtValue,hurtRatios)
    WZLog("BattleMsgBossMapSkill:_charaAddHurtValue one")
    return BattleMethod:charaAddHurtValue(self.m_tOwner,charas,hurtValue,hurtRatios)
   
    --[[
    local newCharas = {}
    local newValue = {}
    local shootHero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tOwner:getBattleId())
    for id,chara in pairs(charas) do
        WZLog("BattleMsgPlayerShoot:_charaAddHurtValue", tostring(id), tostring(chara.m_animPlayerShield), tostring(hurtValue[id]))
        chara:markHurt(hurtValue[id],shootHero)
        if hurtValue[id] > 0 then
            newCharas[id] = chara
            newValue[id] = hurtValue[id]
        end
    end

    WZLog("BattleMsgPlayerShoot:_charaAddHurtValue", Serialize(newValue))
    return newCharas,newValue
    ]]
end

--@brief    更新子弹状态
function BattleMsgBossMapSkill:_updateBullet()
    --WZLog("BattleMsgBossMapSkill:_updateBullet")
    
    local bullets = WBattleGlobal:getCurrent():getBossBulletsList()
    --WZLog("BattleMsgBossMapSkill:_updateBullet #bullets = "..#bullets, tostring(self.m_bIsPenetrateMap), tostring(self.m_bIsNeedHurt))
    for i=#bullets,1,-1 do
        if bullets[i]:getStatus() == BossBulletStatus.DEF_ST_FLY then
            --WZLog("BattleMsgBossMapSkill:_updateBullet BossBulletStatus.DEF_ST_FLY")
            bullets[i]:updatePosition()
            
            --碰撞检测
            local isCollision = false
            if self.m_bIsPenetrateMap then
                isCollision,_ = bullets[i]:checkCharacterCollision()
            else
                isCollision = bullets[i]:checkCollision()
            end
            if isCollision then
                local charas,values = self:_checkHurt(bullets[i])
                    

                if self.m_tShootSummonMonsterList ~= nil then
                    self:_buildShootedSummonMonster(bullets[i], bullets[i].m_nShootedCount)
                end

                local hero = self.m_tOwner
                if hero.m_tHitTargets ~= nil and #hero.m_tHitTargets > 0 and hero.m_tSkillTakeEffectInfo ~= nil then
                    local isSkillEffectTaked = false
                    --WZLog("BattleMsgBossMapSkill:_updateBullet two-3.0", #hero.m_tHitTargets, #hero.m_tSkillTakeEffectList)
                    if #hero.m_tHitTargets <= #hero.m_tSkillTakeEffectList then
                        isSkillEffectTaked = true
                    end

                    bullets[i]:markExplode(false)
                    if isSkillEffectTaked == false then
                        self.m_nSkillStatusCount = self.m_nSkillStatusCount + 1
                        local hurtBullet = nil
                        if self.m_bIsNeedHurt == true then
                            hurtBullet = bullets[i]
                            bullets[i]:markExplode(true)
                        end 
                        WMonsterAI:castSkill(nil,
                            nil,
                            nil,
                            {[1]=SkillTypeConfig.HIT_DO_EFFECT},
                            nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil,nil,nil,nil,nil,
                            nil,
                            nil,
                            nil,nil,
                            nil,nil,nil,nil,
                            hero.m_tSkillTakeEffectInfo,
                            nil,
                            nil, TakeEffectType.HIT,
                            hurtBullet
                            )
                        
                    end
                elseif self.m_bIsNeedHurt == true then
                    --WZLog("BattleMsgBossMapSkill:_updateBullet two-4.1")
                    local tHurtCharas, tHurtValues, tDistance, tCritType,tHurtRatio = bullets[i]:checkHurt()--self:_checkHurt(bullets[i])
                    charas = self:_charaAddHurtValue(tHurtCharas,tHurtValues,tHurtRatio)
                    self:_sendHurtProtocol(charas)
                    bullets[i]:markExplode(false)
                end

                if self.m_bIsNeedExplode == true then
                    bullets[i]:explode()
                    bullets[i].m_nCurStatus = BossBulletStatus.DEF_ST_EXPLODE
                else
                    SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE)
                    bullets[i].m_nCurStatus = BossBulletStatus.DEF_ST_EXPLODE
                end

                if bullets[i].m_bIsMark ~= true then
                    self:_setSceneSpring(bullets[i]:getMover():getMoverPosition())
                end

                --飞出屏外
            elseif bullets[i]:checkOutOfScene() then
                bullets[i]:destroy()
                WBattleGlobal:getCurrent():removeBossBulletByIndex(i)
            end
        elseif bullets[i]:getStatus() == BossBulletStatus.DEF_ST_EXPLODE or bullets[i]:getStatus() == BulletStatus.DEF_ST_END_EXPLODE then
            --WZLog("BattleMsgBossMapSkill:_updateBullet BossBulletStatus.DEF_ST_EXPLODE")
            --是否爆炸完毕
            local explodeName = nil 
            if self.m_bIsOldBulletAnim == false then
                explodeName = "0"
            end
            if bullets[i]:explodeIsEnd(explodeName) or self.m_bIsNeedExplode == false then
                --WZLog("BattleMsgBossMapSkill:_updateBullet explodeIsEnd()")

                bullets[i]:destroy()
                WBattleGlobal:getCurrent():removeBossBulletByIndex(i)
            end
        end
    end
end

--@brief    更新屏幕(主要是屏幕震动)
function BattleMsgBossMapSkill:_updateScene()
    --WZLog("BattleMsgBossMapSkill:_updateScene")
    --[[
    if self.m_tScreenSpring ~= nil then
        BattleScreen:setSpring(self.m_tScreenSpring)
        if BattleScreen:screenSpring() == true then
            self.m_tScreenSpring = nil
        end
    end
    --]]

    if self.m_tScreenSpring ~= nil then
        if not self.m_bOnScreenSpring then
            self.m_bOnScreenSpring = true
            BattleScreen:screenSpring()
            BattleScreen:setSpring(self.m_tScreenSpring,true)
        end

        if BattleScreen:screenSpring() == true then
            self.m_tScreenSpring = nil
            self.m_bOnScreenSpring = nil
        end
    end
end

--@brief    设置屏幕震动
--@param    tPos:震动时的位置
function BattleMsgBossMapSkill:_setSceneSpring(tPos)
    self.m_tScreenSpring = {x=tPos.x,y=tPos.y}
end

--@brief    判断是否屏幕震动
--@return   ＃1:true/false
function BattleMsgBossMapSkill:_getIsSceneSpring()
    return self.m_tScreenSpring ~= nil
end

--@brief    发送受伤协议
function BattleMsgBossMapSkill:_sendHurtProtocol(charas, monster, values,distance,critType)
    WZLog("BattleMsgBossMapSkill:_sendHurtProtocol one")
    if monster ~= nil then
        BattleMethod:sendHurtProtocol(monster, charas, values,distance,critType)
    else
        BattleMethod:sendHurtProtocol(self.m_tOwner, charas, values,distance,critType)
    end
    --[[
    if charas == nil then
        return
    end
    
    if self.m_tOwner:getType() == 0 then
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tOwner:getBattleId())
        WZLog("BattleMsgBossMapSkill:_sendHurtProtocol two-1", tostring(charas), tostring(self.m_tOwner:getBattleId()), tostring(hero:isCanControl()), tostring(hero.m_bLoseNet))
        if charas == nil or not (hero:isCanControl() or hero.m_bLoseNet) then
            return
        end

        WZLog("BattleMsgBossMapSkill:_sendHurtProtocol two-2",tostring(charas),tostring(values),tostring(distance),tostring(critType))
        WBattleGlobal:getCurrent():sendHurtProtocol(self.m_nCurrentPlayerId,charas,values,distance,critType)
    else
        local nCurrentId = self.m_nCurrentPlayerId
        if monster ~= nil then
            nCurrentId = monster:getBattleId()
        end
        local hurtCount = 0
        local hurtIds = WZLuaVector_int_:create()
        local hurtValues = WZLuaVector_int_:create()
        local distance = WZLuaVector_int_:create()

        for id,chara in pairs(charas) do
            hurtIds:push(chara:getBattleId())
            local hurtList = chara:getHurtValueList()
            hurtValues:push(hurtList[#hurtList])
            distance:push(0)
        end

        local attatkType = 0
        local hurtIndex = 0
        if self.m_bIsIgnoreDef == true then
            attatkType = 1
        end
        if self.m_attatkType ~= nil then
            attatkType = self.m_attatkType
        end
        if self.m_hurtIndex ~= nil then
            hurtIndex = self.m_hurtIndex
        end
        WZLog("BattleMsgBossMapSkill:_sendHurtProtocol two-3", tostring(self.m_attatkType), tostring(self.m_hurtIndex))
        if (hurtCount > 0) and self.m_tOwner:isCanControl() then
            ProtocolProcessorBattleInterface:send_BATTLE_Hurt(self.m_nBattleId, nCurrentId, hurtIds, hurtValues, distance)
        end
    end
    ]]
end

--@brief    播放准备射击的动画
function BattleMsgBossMapSkill:_playReadyShootAnim()
    WZLog("BattleMsgBossMapSkill:_playReadyShootAnim", self.m_sReadyShootAnim)
    self.m_tOwner:getAnimation():play(self.m_tOwner:getAnimationName(self.m_sReadyShootAnim),false)
    return true
end

--@brief    屏幕跟踪子弹
function BattleMsgBossMapSkill:_followBullet()
    WZLog("BattleMsgBossMapSkill:_followBullet")
    
    local bullet = WBattleGlobal:getCurrent():getBossBulletByIndex(1)
    if bullet ~= nil then
        if self._followBullet_time_ == nil then
            self._followBullet_time_ = 0
            else
            self._followBullet_time_ = self._followBullet_time_ + SceneBattle:getBattleLoop():getBattleDeltaTime()
        end
        if self:_getIsSceneSpring() == false then
            BattleScreen:followBullet(bullet:getMover():getMoverPosition(),self._followBullet_time_)
        end
    end
end

--@brief    是否还有子弹
--@return   #1：true：是，false：否
function BattleMsgBossMapSkill:_isHaveBullet()
    local bullet = WBattleGlobal:getCurrent():getBossBulletByIndex(1)
    if bullet ~= nil then
        return true
    end
    return false
end

--@brief    创建子弹
function BattleMsgBossMapSkill:_createBullet(id)
    local isPlay = self.m_tOwner:getAnimation():isPlaying(self.m_tOwner:getAnimationName(self.m_sReadyShootAnim.."Ing"))
    WZLog("BattleMsgBossMapSkill:_createBullet", tostring(self.m_sReadyShootAnim), tostring(isPlay), self.m_tOwner:getAnimationName(self.m_sReadyShootAnim.."Ing"), self.m_tOwner:getAnimationName("standby"))
    if self.m_sReadyShootAnim and self.m_sReadyShootAnim ~= "" and self.m_tOwner:getAnimationName(self.m_sReadyShootAnim.."Ing") ~= self.m_tOwner:getAnimationName("standby") then
        --WZLog("BattleMsgBossMapSkill:process 2", self.m_tOwner:getAnimationName(self.m_sReadyShootAnim.."End"))
        self.m_tOwner:getAnimation():play(self.m_tOwner:getAnimationName(self.m_sReadyShootAnim.."End"),false)
    end

    self.m_nShootedCount = self.m_nShootedCount + 1
    local nBulletType
    nBulletType = self.m_nBulletType

    local nScatterNum = self.m_nScatterNum
    local startAngle = 0
    startAngle = -1 * BattleConstants.g_fWB_SCATTER_ANGLE * (math.floor(nScatterNum / 2) - (nScatterNum+1)%2/2)

    local speed = self.m_tSpeed
    if speed == nil and (self.m_nBulletType == BulletType.THROW or self.m_nBulletType == BulletType.THROW_II)then
        speed = self:_shoot()
    elseif speed == nil and self.m_nBulletType == BulletType.LINE then
        speed = self:_shootLine(self.m_nShootPower)
    else
        self:_shoot()
        speed = {x=-20,y=0}
    end
    local speedVec = BattleCommon:vectorWithAngle(speed,startAngle)
    for i=1,nScatterNum do

        if self.m_bIsOldBulletAnim == true then
            WZLog("BattleMsgBossMapSkill:_createBullet one-0", tostring(self.m_nLeftRight), tostring(self.m_bIsOldBulletAnim), tostring(self.m_tOwner.m_nWeaponType), tostring(self.m_nBulletType), tostring(nBulletType), tostring(self.m_tAcceleration.x), tostring(self.m_tAcceleration.y), self.m_tStartPos.x, self.m_tStartPos.y)
            local bullet = WBattleGlobal:getCurrent():buildBossBullet(self:_createBulletAnim(),self.m_tStartPos,speedVec,self.m_tAcceleration,self.m_tOwner,nBulletType,true)

            if self.m_nLeftRight == 0 then
                WZLog("BattleMsgBossMapSkill:_createBullet one-1")
                --bullet:getAnimation():getAnimNode():setFlipX(true)
            end
            bullet.m_nShootedCount = self.m_nShootedCount
            bullet:getAnimation():getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
            bullet:setCheckCharacterCollisionRadius(self.m_nCheckCharacterCollisionRadius)
            bullet:setAnimDefaultDirection(self.m_nBulletAnimDefaultDirection)
            SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode())
            bullet:getAnimation():play(self.m_sBulletAnimFlyName,true)
            bullet.m_nBulletId = id
        else
            WZLog("BattleMsgBossMapSkill:_createBullet two",tostring(self.m_tOwner.m_tbulletPosOffset.x), tostring(self.m_tOwner.m_tbulletPosOffset.y) , tostring(self.m_nLeftRight), tostring(self.m_bIsOldBulletAnim), tostring(self.m_tOwner.m_nWeaponType), tostring(self.m_nBulletType), tostring(nBulletType), tostring(self.m_tAcceleration.x), tostring(self.m_tAcceleration.y), self.m_tStartPos.x, self.m_tStartPos.y)
            --[[
            local startPos
            if self.m_nLeftRight == DirectionType.LEFT then
                startPos = BattleCommon:getPointTable(self.m_tStartPos.x + self.m_tOwner.m_tbulletPosOffset.x,self.m_tStartPos.y + self.m_tOwner.m_tbulletPosOffset.y)
            else
                startPos = BattleCommon:getPointTable(self.m_tStartPos.x - self.m_tOwner.m_tbulletPosOffset.x,self.m_tStartPos.y + self.m_tOwner.m_tbulletPosOffset.y)
            end
            --]]

            local bullet = WBattleGlobal:getCurrent():buildBossBullet(self:_createBulletAnim(),BattleCommon:getPointTable(self.m_tStartPos.x,self.m_tStartPos.y),speedVec,self.m_tAcceleration,self.m_tOwner,nBulletType,true)
            
            bullet.m_nShootedCount = self.m_nShootedCount
            bullet:getAnimation():getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
            bullet:setCheckCharacterCollisionRadius(self.m_nCheckCharacterCollisionRadius)
            bullet:setAnimDefaultDirection(self.m_nBulletAnimDefaultDirection)
            SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode())
            bullet.m_nBulletId = id
        end

        speedVec = BattleCommon:vectorWithAngle(speedVec,BattleConstants.g_fWB_SCATTER_ANGLE)
    end
end

--@brief    创建子弹动画
function BattleMsgBossMapSkill:_createBulletAnim()
    return BattleMethod:createBulletAnim(self.m_tBulletInfo)
    --[[
    if self.m_tWeaponAnim == nil then
        self.m_tWeaponAnim = {}
    end
    
    local bullet = nil
    if self.m_bIsOldBulletAnim == true then

        bullet = BattleAnimation:createAnimation(self.m_sBulletAnimMainName)
        bullet:addAnimation(self.m_sBulletAnimFlyName,self.m_tWeaponAnim, 0.1, true)
        bullet:play(self.m_sBulletAnimFlyName,true)
    else
        bullet = BattleAnimation:createAnimation(self.m_sBulletAnimMainName, true)
        
    end
    
    bullet:setScale(self.m_nBulletAnimScale)
    
    if self.m_sBulletAnimExplodeWeaponName ~= "" then
        bullet:addAnimation("blasting",{weapon=self.m_sBulletAnimExplodeWeaponName}, 0.1, true,IWCO_BATTLEEFFICIENTS)
    elseif self.m_tWeaponAnim ~= nil then

    end
    
    return bullet
    ]]
end

--@brief    检查伤害
--@return   #1:受伤的人物列表
--@return   #2:受伤值
function BattleMsgBossMapSkill:_checkHurt(bullet)
    WZLog("BattleMsgBossMapSkill:_checkHurt")
    
    --local bullet = WBattleGlobal:getCurrent():getBossBulletByIndex(1)
    local tHurtCharas = {}
    local tHurtValues = {}
    for i,charaList in pairs(bullet.m_tCollisionCharacters) do
        for id,chara in pairs(charaList) do
            if id ~= self.m_tOwner:getBattleId() then
                local bulletPos = bullet:getMover():getMoverPosition()
                bulletPos = {x=bulletPos:getX(),y=bulletPos:getY()}
                
                local charaPos = chara:getCenterPos()
                charaPos = Vector2:create(charaPos.x,charaPos.y)
                
                --WZLog("BattleMsgBossMapSkill:_checkHurt bulletPos = ("..bulletPos.x..", "..bulletPos.y..") charaPos = ("..charaPos.x..", "..charaPos.y.."self.m_nCheckCharacterCollisionRadius = "..self.m_nCheckCharacterCollisionRadius..") chara:getRadiusForHurt() = "..chara:getRadiusForHurt(), chara:getId())
                if not chara:isDead() and chara:getHp() > 0 and BattleCommon:checkCircleCollosion(bulletPos,self.m_nCheckCharacterCollisionRadius * 1,charaPos,chara:getRadiusForHurt()) == true then
                    local hurtValue = self:_getHurt(chara)
                    tHurtCharas[id] = chara
                    tHurtValues[id] = hurtValue

                    if chara.m_nDebuffFrozenRound ~= nil and chara.m_nDebuffFrozenRound > 0 and bullet.m_bIsFrozen == nil and (hurtValue > 0 or chara.m_bIsAbsorb == true or chara.m_bIsImmunity == true ) then
                        chara:removeFrozenAnimation()
                        WZLog("BattleMsgPlayerShoot:_checkHitEnemy chara:removeFrozenAnimation")
                        if WBattleGlobal:getCurrent():isSingleStage() then
                            chara.m_nDebuffFrozenRound = 0
                        else
                            chara.m_nDebuffFrozenRound = nil
                        end
                    end
                end
            end
        end
    end

    self.m_tOwner.m_bActiveAttack = true
    if bullet ~= nil then
        table.insert(self.m_tOwner.m_tActiveAttackPos, {x=bullet:getPosition().x, y=bullet:getPosition().y,bulletId = bullet.m_nBulletId})
    end
    if self.m_tOwner.m_tHitTargets == nil then
        self.m_tOwner.m_tHitTargets = {}
    end
    for i,v in pairs(tHurtCharas) do
        local isExist = false
        for j, u in pairs (self.m_tOwner.m_tHitTargets) do
            if v:getBattleId() == u:getBattleId() then
                isExist = true
            end
        end
        if tHurtValues[i] > -1 and isExist == false then
            table.insert(self.m_tOwner.m_tHitTargets, v)
            WZLog("BattleMsgBossMapSkill:_checkHurt one", v:getBattleId())
        end
    end
    WZLog("BattleMsgBossMapSkill:_checkHurt two", tostring(bullet))

    return tHurtCharas,tHurtValues
end

--@brief    计算伤害
--@return   #1：伤害
function BattleMsgBossMapSkill:_getHurt(chara)
    WZLog("BattleMsgBossMapSkill:_getHurt")
    return BattleMethod:getHurt(self.m_tOwner,chara,self.m_bIsIgnoreDef)
    --[[
    local bullet = WBattleGlobal:getCurrent():getBossBulletByIndex(1)
    local bulletPos = bullet:getMover():getMoverPosition()
    local charaPos = chara:getCenterPos()
    
    local hurt = 0
    if chara.m_nBuffInvincibleRound ~= nil and chara.m_nBuffInvincibleRound > 0 then
        hurt = 1
    elseif self.m_bIsIgnoreDef == true then
        hurt = self.m_nAttack
    else
        local AttackOriginal = self.m_tOwner:getAttack(true)
        self.m_tOwner.m_nAttack = self.m_nAttack
        WZLog("BattleMsgBossMapSkill:_getHurt AttackOriginal = "..AttackOriginal.." self.m_nAttack = "..self.m_nAttack)
        hurt = WBossBullet:calculateHurt(0,self.m_tOwner,chara)
        self.m_tOwner.m_nAttack = AttackOriginal
    end
    
    return hurt
    ]]
end

--@brief    计算抛物线射击
--@return   发射速度
function BattleMsgBossMapSkill:_shoot()
    local sPos,ePos = self:_getCompareBulletPos()
    local angle
    local face

    local degree = -30
    local degreeOffset = -90
    if ePos.y >= 800 then
        degree = -80
        degreeOffset = -20
    end
    --炮弹发射位置和角度修正
    if ePos.x <= sPos.x then
        face = 1
        angle = degree + degreeOffset;
    else
        face = 0
        angle = degree;
    end

    local isAtkSucceed = false
    local rand = 3
    local power= (1 + rand) * SceneBattle:getFrontLayer():getScale() * 0.9;
    local speed = BattleCommon:angleToPoint(BattleCommon:degressToRadius(-angle))
    isAtkSucceed, speed = BattleCommon:vectorNormalize(speed)
    isAtkSucceed, power = BattleCommon:getStartSpeedPowerWithSpeed(speed, sPos, ePos, power, self.m_tAcceleration)

    if isAtkSucceed == false then
        speed = self:_shootLine(self.m_nShootPower)
    else
        speed.x = speed.x * power
        speed.y = speed.y * power
    end
    WZLog("BattleMsgBossMapSkill:_shoot ", speed.x, speed.y, power, isAtkSucceed)
    return speed
end

--@brief    计算直线射击
--@return   发射速度
function BattleMsgBossMapSkill:_shootLine(shootPower)
    local sPos,ePos = self:_getCompareBulletPos()
    local angle
    local face

    local power = 15
    local scale = 2
    if shootPower ~= nil then
        scale = shootPower
    end
    local speed = {}
    
    if ePos.x <= sPos.x then
        face = 1
    else
        face = 0
    end
    
    if face == 1 then
        speed.x = -1 * scale
    else
        speed.x = scale
    end
    
    --斜率公式
    if (ePos.x - sPos.x == 0) then
        speed.x = 0
        speed.y = 10
    elseif (ePos.y - sPos.y == 0) then
        if (ePos.x - sPos.x >= 0) then
            speed.x = 10
        else
            speed.x = -10
        end
        speed.y = 5
    else
        speed.y = (speed.x) / ((ePos.x - sPos.x) / (ePos.y - sPos.y))
    end

    if (ePos.y - sPos.y > 500 or math.abs(speed.y) > 3.3) and shootPower == nil then
        speed.x = speed.x * 1
        speed.y = speed.y * 1
    else
        speed.x = speed.x * power
        speed.y = speed.y * power
    end

    if speed.y < -1000 then
        WZLog("BattleMsgBossMapSkill:_shootLine zero-0", speed.x, speed.y)
        speed.x = speed.x / 100
        speed.y = speed.y / 100
    elseif speed.y < -100 then
        WZLog("BattleMsgBossMapSkill:_shootLine zero-1", speed.x, speed.y)
        speed.x = speed.x / 10
        speed.y = speed.y / 10
    end
    WZLog("BattleMsgBossMapSkill:_shootLine ", speed.x, speed.y, ePos.x, ePos.y, sPos.x, sPos.y, power)
    return speed
end

--@brief    获得子弹计算相关点
--@return   startPos,endpos (startPos 由self.m_tStartPos记录)
function BattleMsgBossMapSkill:_getCompareBulletPos()
    local hero = self.m_tOwner
    
    local targetHero = self.m_tTargetHero
    
    local summonPos = nil
    if self.m_tShootSummonMonsterList ~= nil and self.m_tShootSummonMonsterList[self.m_nShootedCount] ~= nil and self.m_tShootSummonMonsterList[self.m_nShootedCount].posX ~= nil and self.m_tShootSummonMonsterList[self.m_nShootedCount].posX[1] ~= nil then
        summonPos = BattleCommon:getPointTable(self.m_tShootSummonMonsterList[self.m_nShootedCount].posX[1], self.m_tShootSummonMonsterList[self.m_nShootedCount].posY[1])
        WZLog("BattleMsgBossMapSkill:_getCompareBulletPos", summonPos.x, summonPos.y)
    end

    local eOffset = BattleCommon:getPointTable(targetHero.m_anim:getAnimNode():getContentSize().width * 0, targetHero.m_anim:getAnimNode():getContentSize().height * 0.3)
    local sPos = self.m_tStartPos
    local ePos = summonPos or self.m_tEndPos or BattleCommon:getPointTable(targetHero:getPosition().x + eOffset.x,targetHero:getPosition().y + eOffset.y)

    --炮弹发射位置和角度修正
    if ePos.x <= sPos.x then
        sPos = BattleCommon:getShootPos(true, self.m_tOwner)
    else
        sPos = BattleCommon:getShootPos(false, self.m_tOwner)
    end

    --子弹自身偏移 
    if self.m_nLeftRight == DirectionType.LEFT then
        sPos = BattleCommon:getPointTable(sPos.x + self.m_tOwner.m_tbulletPosOffset.x + self.m_tOffset.x,sPos.y + self.m_tOwner.m_tbulletPosOffset.y + self.m_tOffset.y)
    else
        sPos = BattleCommon:getPointTable(sPos.x - self.m_tOwner.m_tbulletPosOffset.x - self.m_tOffset.x,sPos.y + self.m_tOwner.m_tbulletPosOffset.y + self.m_tOffset.y)
    end

    self.m_tStartPos = sPos

    return sPos,ePos
end


--@brief    添加被动免疫buff效果
function BattleMsgBossMapSkill:_immunityBuff(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_immunityBuff", tostring(self.m_nImmunityBuffType))
    if isBuff == nil then
        for i, hero in pairs (targetHeroList) do
          hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.IMMUNITY_BUFF_ASSIGN,param = self.m_nImmunityBuffType})
        end
    end
end

--@brief    添加被动免疫效果
function BattleMsgBossMapSkill:_immunityEffect(targetHeroList, param)
    WZLog("BattleMsgBossMapSkill:_immunityEffect", tostring(self.m_nImmunityEffectType))
    if isBuff == nil then
        for i, hero in pairs (targetHeroList) do
            hero:addImmunityPetSkill(self.m_nSkillId,{type = EffectTypeConfig.IMMUNITY_EFFECT_ASSIGN,param = self.m_nImmunityEffectType})
        end
    end
end

--@brief    换位
function BattleMsgBossMapSkill:_transferPositionStart(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_transferPositionStart")
    local list = {}
    for i, hero in pairs (targetHeroList) do
        if not hero.m_bOffFrozen and hero:getBattleId() ~= self.m_tOwner:getBattleId() and not hero:isDead() then
            table.insert(list,hero)
        end
    end
    if #list == 0 or self.m_tOwner:isDead() then
        return
    end
    local function sort(a,b)
        return a:getBattleId() < b:getBattleId()
    end
    table.sort(list,sort)
    local index = WBattleGlobal:getCurrent():getBattleRandNum() % #list + 1
    local hero = list[index]
    local effect  = BattleEffect:createAnimation(305)
    self.m_tOwner:getAnimation():getAnimNode():addChild(effect:getAnimNode())

    local effect2  = BattleEffect:createAnimation(305)
    hero:getAnimation():getAnimNode():addChild(effect2:getAnimNode())

    self.m_tTransferHero = hero
    self.m_nShootDeltaTime = 0
end

--@brief    换位
function BattleMsgBossMapSkill:_waitForTransEffect()
    WZLog("BattleMsgBossMapSkill:_waitForTransEffect")
    if not self.m_tTransferHero then
        return true
    end
    if not self.m_nShootDeltaTime then
        return true
    end
    self.m_nShootDeltaTime = self.m_nShootDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
    if self.m_nShootDeltaTime >= 1 then
        return true
    end
    return false
end

--@brief    换位
function BattleMsgBossMapSkill:_transferPosition()
    WZLog("BattleMsgBossMapSkill:_transferPosition")
    if not self.m_tTransferHero then
        return true
    end
    local hero = self.m_tTransferHero
    local tx,ty,tro = hero:getPosition().x,hero:getPosition().y,hero:getAnimation():getRotate()
    local x,y,ro = self.m_tOwner:getPosition().x,self.m_tOwner:getPosition().y,self.m_tOwner:getAnimation():getRotate()
    hero:setPosition(GlobalMethod:ccp(x,y))
    hero:getAnimation():setRotate(ro)
    self.m_tOwner:setPosition(GlobalMethod:ccp(tx,ty))
    self.m_tOwner:getAnimation():setRotate(tro)
    if tx < x then
        self.m_tOwner:setLeftDirection(true)
        hero:setLeftDirection(false)
    else
        self.m_tOwner:setLeftDirection(false)
        hero:setLeftDirection(true)
    end
end

--@brief    延长线
function BattleMsgBossMapSkill:_pointLineAdd(targetHeroList)
    WZLog("BattleMsgBossMapSkill:_pointLineAdd")
    local param = self.m_nPointLineValue
    for i, hero in pairs (targetHeroList) do
        hero.m_tAttributeChangeStateList.m_nPointLineValue = {range = param.range,rangeY = param.rangeY,count = param.count}
    end
end

--@brief    通过id获取角色
function BattleMsgBossMapSkill:_getHeroById(tPlayerId)
    -- body
    local targetHeroList = {}

    for k = 1, #tPlayerId do
        for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
            if hero:getId() == tPlayerId[k] and not hero:isDead() then
                table.insert(targetHeroList, hero)
                break 
            end
        end
    end

    return targetHeroList
end

--@brief    判断是否幽灵技能
function BattleMsgBossMapSkill:_isGhostSkill(id)
    -- body
    local skillData = GDatatab_skill["id_" .. id]
    if skillData and skillData.skill_type == 9 then 
        return true 
    end

    return false 
end