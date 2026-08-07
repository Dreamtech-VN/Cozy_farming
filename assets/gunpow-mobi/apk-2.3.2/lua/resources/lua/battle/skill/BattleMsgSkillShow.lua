--BattleMsgSkillShow.lua
--@brief    技能表演
--@date     2015/08/01

--@brief    消息数据表
BattleMsgSkillShow = {
    m_sName = "BattleMsgSkillShow",

    --外部赋值变量------------------------
    m_tOwner = nil,         --拥有者
    m_nBattleId = nil,      --战斗id
    m_nSkillId = nil,       --技能id
    m_nTalkId = nil,        --说话
    m_tMoveParm = nil,      --移动参数
    m_tFlyParam = nil,      --飞行参数
    --内部控制变量------------------------
    m_bhasNotHero = nil,   --没有攻击对象

    --技能附加参数
    m_skillParam1 = nil,
    m_skillParam2 = nil,
    m_skillParam3 = nil,
    m_skillParam4 = nil,

    m_nActionId = nil,    --表现id
    m_tTargetList = nil,        --技能对象目标

    m_tNextActList = nil,   --下一步动作列表
    
    m_tSkillLoopList = nil,    --需要skillLoop刷新状态列表
    m_tWaitTypeList = nil,      --需要等待结束的类型列表 在dt里面处理

    m_nLoopTime = nil,      --持续时间（等待延迟）
    m_nLoopDt = nil,        --时间记数
    m_tDelayCall = nil,     --延时回调

    m_tScreenSpring = nil,  --震屏控制点

    m_tCameraPlayer = nil,     --镜头目标点玩家 nil 为全景

    m_nFlashCount = nil,        --特效数量计数
    m_tEffectCount = nil,       --技能效果计数
    m_nEffectCountIndex = nil, --技能效果计数下标

    --子弹控制属性
    m_tStartPos = nil, --发射初始位置
    m_tShootSpeed = nil, -- 发射速度
    m_nShootDeltaTime = 0,   --发炮间隔时间
    m_nReadyToShootDeltaTime = 1.2,   --从做发炮准备动作到正式发炮的间隔时间, 默认为等待到动画结束就发炮
    m_nEveryBulletShootDeltaTime = 0.3,   --每个子弹出现的间隔时间
    m_nBulletType = 1,  --子弹类型  0:投砸  1:投砸（自调整角度）  2:射击
    m_nCheckCharacterCollisionRadius = 2,   --与人物碰撞时使用的半径 ,默认为2
    m_bIsPenetrateMap = true, --是否穿透地图
    m_bIsPenetrateMonster = false,--穿透怪物
    m_nAttTimes = 1, --攻击次数
    m_nAttack = 0,  --子弹攻击力
    m_tAcceleration = nil,--子弹加速度
    m_bIsIgnoreDef = false, --是否无视防御
    m_bIsNeedExplode = false,    --是否需要播放爆炸动画
    m_nFireType = nil,  --拖尾
    m_nBoomType = nil, --爆破
    m_sShootAnimName = nil, --射击动画名字
    --子弹动画属性
    m_sBulletAnimMainName = "", --子弹动画主动画名
    m_sBulletAnimFlyName = "", --子弹动画飞行动画名
    m_sBulletAnimExplodeWeaponName = "", --子弹动画爆破花纹所属的武器名
    m_nBulletAnimScale = 1, --子弹动画放大率
    m_bBulletAnimFlipX = false, --子弹动画是否X方向翻转
    m_nBulletAnimDefaultDirection = 1,            --子弹的动画的默认方向 0:向右 , 1:向左
    m_tTargetHero = nil,   --目标玩家
    m_nScatterNum = 1,  --散射数
    m_nShootPower = nil,    --发射力度
    m_nShootedCount = 0,    --已经发射的回数
    m_bIsNeedHurt = nil,    --是否需要计算伤害

    m_sShootNextAct = nil,  --射击下一个动作

    m_nShootRotation = nil, --子弹起始角度
    m_nShootOldRotation = nil,--旧发射角度
    --非技能发起者 的操作（播放动作，添加特效，射击子弹）
    m_tActionOwner = nil,   --播放动作者
    m_tShooter = nil,    --射击子弹者

    m_bClientSummon = nil, --召唤技能标记

    m_bIsSummonMsg = false, --召唤技能消息标记
    m_bIsReplayMsg = true,
    m_tEndPos = nil, --发射目标位置
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgSkillShow:init()
    WZLog("BattleMsgSkillShow:init",tostring(self.m_bIsReplayMsg))
    self:getSkillConfig()
    self.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    if self.m_tOwner:getType() ~= 0 then
        WndBattleHud:endTurnTime(true)
    end
    if self.m_bhasNotHero then
        return true
    end
    if self.m_tOwner:isDead() then
        return true
    end
    self.m_nEffectCountIndex = 0
    self:parseConfig()
    self:setNextStep()
end

--@获取技能配置
function BattleMsgSkillShow:getSkillConfig()
    if not self.m_nSkillId then
        return
    end

    local list = WMonster:getRandomPlayer()
    if not list then
        self.m_bhasNotHero = true
        return
    end

    local skillConfig = self:getSkillData(self.m_nSkillId)
    -- if skillConfig.skill_type == 0 then
        self.m_tOwner.m_fRadiusForBulletExplodeChange = (skillConfig.scope > 0 and skillConfig.scope) or nil
    -- end
    if type(skillConfig.boom_scope) == "table" then
        self.m_tOwner.m_fRectForBulletExplodeBombChange = {x=skillConfig.boom_scope[1][1],y=skillConfig.boom_scope[1][2],digHoleDir=skillConfig.direction}
    end

    self.m_tOwner.m_bIsUseSkill = true
    BattleCtbManager:addCtb(self.m_tOwner:getBattleId(),skillConfig.consume)

    self.m_tOwner.m_nActionTimes = self.m_tOwner.m_nActionTimes + 1
    --战斗记录
    if WBattleGlobal:getCurrent():isSingleStage() and self.m_nSkillId ~= nil then
       WBattleGlobal:getCurrent():setSkillIdRecord(self.m_nSkillId)
    end
    
    self.m_nActionId = skillConfig.show_id or 20000
    self.m_skillParam1 = skillConfig.param1
    self.m_skillParam2 = skillConfig.param2
    self.m_skillParam3 = skillConfig.param3
    self.m_skillParam4 = skillConfig.param4

    self.m_nFireType = skillConfig.zdfxtx ~= -1 and skillConfig.zdfxtx or BulletEffectId.EFFECT_DEFAULT
    self.m_nBoomType = skillConfig.zdbztx ~= -1 and skillConfig.zdbztx or BulletEffectId.EFFECT_DEFAULT
    
    self.m_tEffectIds = skillConfig.effect_id[1]
    WZLog("BattleMsgSkillShow:getSkillConfig",self.m_nSkillId,self.m_nActionId)
    self.m_tTargetList = self:chooseTarget(self.m_tOwner,{[1]=skillConfig.choose,[2]=skillConfig.chooseParm[1],[3]=skillConfig.chooseParm[2]})
    self:updateFlipX()

    -- if self.m_nTalkId ~= -1 then
    --     self.m_tOwner:getAI():castSkillTalk(nil,
    --     nil,
    --     self.m_nTalkId,{}
    --     )
    -- end
    self:initDialog()
end

--@brief    获取技能表配置
function BattleMsgSkillShow:getSkillData(id)
    return CopyTable(GDatatab_skill["id_"..id])
end

--@调整头方向
function BattleMsgSkillShow:updateFlipX(dirType)
    local hero = self.m_tOwner
    local endPos
    local direct = DirectionType.LEFT
    if dirType then
        direct  = dirType
    else
        local target = self.m_tTargetList[1] or WMonster:getRandomPlayer()
        endPos = target:getPosition()

        if endPos.x < hero:getPosition().x then
            direct = DirectionType.LEFT
        else
            direct = DirectionType.RIGHT
        end
    end
    self.m_nLeftRight = direct
    self.m_tStartPos = self:getShootStartPos()
    --self.m_tStartPos = BattleCommon:getPointTable(hero:getPosition().x, hero:getPosition().y + 10)

    if (WBattleGlobal:getCurrent():isDoubleTowerStage() and type(hero.suitConfig) == "number" and hero.suitConfig == 999) then
        if hero.m_bIsFilpX == true and direct == DirectionType.RIGHT then 
            hero:getAnimation():setFlipX(false)
            hero.m_bIsFilpX = false
        elseif hero.m_bIsFilpX ~= true and direct == DirectionType.LEFT then 
            hero:getAnimation():setFlipX(true)
            hero.m_bIsFilpX = true
        end
    else
        if hero.m_bIsFilpX ~= true and direct == DirectionType.RIGHT then
            WZLog("hero:getAnimation():setFlipX(true)", hero:getBattleId())
            hero:getAnimation():setFlipX(true)
            hero.m_bIsFilpX = true
        elseif hero.m_bIsFilpX == true and direct == DirectionType.LEFT then
            WZLog("hero:getAnimation():setFlipX(false)", hero:getBattleId())
            hero:getAnimation():setFlipX(false)
            hero.m_bIsFilpX = false
        end
    end
end

--@添加buff
function BattleMsgSkillShow:addBuff(targetType,buffId)
    targetType = targetType or BattleSkillTargetType.SELF
    local heroList = {}
    if targetType == BattleSkillTargetType.SELF then
        table.insert(heroList,self.m_tOwner)
    else
        heroList = self.m_tTargetList
    end
    WBattleGlobal:getCurrent():addBuff(heroList,buffId,self.m_tOwner:getBattleId())
    --主机发送协议
    if WBattleGlobal:getCurrent():isHostControl() then
        local idList = {}
        for _,hero in pairs(heroList) do
            table.insert(idList,hero:getBattleId())
        end
        if buffId ~= 7016 then 
            ProtocolProcessorSceneBattle:send_BATTLE_BuffChange(WBattleGlobal:getCurrent():getBattleId(), self.m_tOwner:getBattleId(), 0, buffId, 0, idList)
        end
    end
    self:reduceWait(BattleSkillType.ADD_BUFF)
end


--@breif 获得startPos
function BattleMsgSkillShow:getShootStartPos()
    local startPos = nil
    local hero = self.m_tOwner
    if self.m_tOwner:getMachine() then
        startPos = {x = self.m_tOwner:getMachine():getPosition().x, y = self.m_tOwner:getMachine():getPosition().y + 10}
    else
        startPos = {x = self.m_tOwner:getPosition().x, y = self.m_tOwner:getPosition().y + 10}
    end
    return startPos
end

--@breif 解析配置
function BattleMsgSkillShow:parseConfig()
    local actionId = self.m_nActionId or 1001
    self.m_tShowList = BattleSkillShowConfig["id_"..actionId]
    WZLog("BattleMsgSkillShow:parseConfig",actionId,Serialize(self.m_tShowList))

    local stepConfig = self.m_tShowList[1]
    self.m_tNextActList = self:getNextActList(stepConfig.nextAct)
end

function BattleMsgSkillShow:getNextActList(actStr)
    if actStr == -1 then
        return actStr
    end
 local acts = SplitStringWithSeparator(actStr, ",")
 return acts
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgSkillShow:process(dt)
    if self.m_bhasNotHero then
        return true
    end
     --重连成功，而且正在等待怪物id
    if self.m_bIsWaitMonsterId and self.m_bIsReconnectDone then
        return true
    end
    
    if self.m_tOwner:isDead() then
        return true
    end
    --震屏结束 表演结束 伤害数字结束
    if self.m_tScreenSpring == nil and self.m_bActIsEnd and  self:waitForHurtNum() then
        return self:allIsCollision()
    end

    self:skillLoop(dt)

    return false
end
--@所有人站稳
function BattleMsgSkillShow:allIsCollision()
    --WZLog("BattleMsgSkillShow:allIsCollision")
    if not self.m_bSelfMoveUpdatable then
        if not self.m_tOwner:isDead() and not self.m_tOwner.m_bIsAir then
            self.m_tOwner:setMoveUpdatable(true)
        end
        self.m_bSelfMoveUpdatable = true
    end
    
    local result = true
    for id, character in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
        if not character:isDead() and not character.m_bIsAir and character:getMover() then
            local vertical,horizontal = character:checkIsOutOfScene()
            
            if not vertical and not horizontal and character:getMover():isCollision() == false then
                result = false
            end
        end
    end
    WZLog("BattleMsgSkillShow:allIsCollision = ",result)
    return result
end

--@breif 减少等待计数
function BattleMsgSkillShow:reduceWait(actType)
    WZLog("BattleMsgSkillShow:reduceWait",actType)
    --移除skillLoop
    self:removeLoop(actType)

    local  index = -1
    for i = 1,#self.m_tWaitTypeList do
        if actType == self.m_tWaitTypeList[i] then
            index = i
            break
        end
    end

    if index ~= -1 then
        table.remove(self.m_tWaitTypeList,index)
    end
    
    for i = 1,#self.m_tWaitTypeList do
       WZLog("BattleMsgSkillShow:reduceWait list",self.m_tWaitTypeList[i])
    end
    for i = 1,#self.m_tSkillLoopList do
       WZLog("BattleMsgSkillShow:reduceWait loop",self.m_tSkillLoopList[i])
    end
    -- if #self.m_tWaitTypeList <= 0 and #self.m_tSkillLoopList <= 0 then
    if #self.m_tWaitTypeList <= 0 then
        self:setNextStep()
    end
end

--@breif 移除skillLoop列表
function BattleMsgSkillShow:removeLoop(actType)
    local  index = -1
    for i = 1,#self.m_tSkillLoopList do
        if actType == self.m_tSkillLoopList[i] then
            index = i
            break
        end
    end
    WZLog("BattleMsgSkillShow:removeLoop",actType,index)
    if index ~= -1 then
        table.remove(self.m_tSkillLoopList,index)
    end

end

--@breif 当前步骤表演开始
function BattleMsgSkillShow:playStepList()
    local nextActList = -1
    --变量重置begin
    self.m_tSkillLoopList = {}
    self.m_tWaitTypeList = {}
    self.m_tWaitTypeListKey = {}
    if self.m_nSkillId == 10220 then
        WZLog("BattleMsgSkillShow test")
    end
    --变量重置end
    WZLog("BattleMsgSkillShow:playStepList",#self.m_tNextActList)
    --计算等待个数，并找出下一个列表
    for i = 1, #self.m_tNextActList do
        local actId = tonumber(self.m_tNextActList[i])
        local actConfig = self.m_tShowList[actId]
        if actConfig then
            if actConfig.nextAct ~= -1 then
                nextActList = self:getNextActList(actConfig.nextAct)
            end
            
            --等待结束计数
            if actConfig.isWait and  actConfig.isWait == 1 then
                --过滤
                if actConfig.actType ~= BattleSkillType.PLAY_SOUND or actConfig.actType ~= BattleSkillType.PLAY_RESET_STEP or BattleSkillType.UPDATE_FLIPX then
                    table.insert(self.m_tWaitTypeList,actConfig.actType)
                end
            end
            if actConfig.isResetMachine then
                self.m_tActionOwner = nil
                self.m_tShooter = nil
            end
        end
    end
    local tmpActList = self.m_tNextActList
    self.m_tNextActList = nextActList
    if self.m_nSkillId == 10220 and self.m_tNextActList ~= -1 then
        WZLog("BattleMsgSkillShow test",self.m_tNextActList[1])
    end
    --执行行为
    for i = 1, #tmpActList do
        local actId = tonumber(tmpActList[i])
        local actConfig = self.m_tShowList[actId]
        if actConfig then
            self:doAction(actConfig)
        end
    end

    if #self.m_tWaitTypeList <= 0 then
        self:setNextStep()
    end
end

--@breif 切换下一个表演
function BattleMsgSkillShow:setNextStep()
    if self.m_tNextActList and self.m_tNextActList == -1 then
        self.m_bActIsEnd = true
        return
    end
    self:playStepList()
end

--@breif 处理表演
--@param2 外部调用直接doAction的设置是否等待(不走playStepList流程)
function BattleMsgSkillShow:doAction(actConfig,isWait)
    WZLog("BattleMsgSkillShow:doAction",actConfig.actType,tostring(isWait))
    if isWait then
        table.insert(self.m_tWaitTypeList,actConfig.actType)
    end
    local actType = actConfig.actType
    --@播放动作
    if actType == BattleSkillType.PLAY then
        local isStopAutoStandAction = false
        if actConfig.param2 then 
            self.m_sShootNextAct = actConfig.param2
            isStopAutoStandAction = true
        end
        self:playAnimation(actConfig.param1,nil,isStopAutoStandAction)
        table.insert(self.m_tSkillLoopList,actType)
    --@机关播放动作
    elseif actType == BattleSkillType.PLAY_MACHINE then
        self.m_tActionOwner = self.m_tOwner:getMachine()
        self:playAnimation(actConfig.param1)
        self:addTypeInLoopList(actType)
    --@循环播放
    elseif actType == BattleSkillType.PLAY_LOOP then
        self:playAnimation(actConfig.param1,true)
        --添加延时控制
        table.insert(self.m_tWaitTypeList,BattleSkillType.DELAY)
        self:delayTime(actConfig.param2,self.playStandby)
        self:addTypeInLoopList(BattleSkillType.DELAY)
    --@播放动作 不回切stand
    elseif actType == BattleSkillType.PLAY_STEP then
        self:playAnimation(actConfig.param1,nil,true)
        table.insert(self.m_tSkillLoopList,actType)
    --@恢复自动调用stand动作
    elseif actType == BattleSkillType.PLAY_RESET_STEP then
        self:getActor():setAutoStandAction(true)
        if actConfig.param1 then
            self:playAnimation(actConfig.param1)
        end
    --@射击循环检测
    elseif actType == BattleSkillType.MONSTER_SHOOT_ANIMA_LOOP then
        -- self:playAnimation(actConfig.param1)
        self:addTypeInLoopList(actType)

    elseif actType == BattleSkillType.PLAY_SOUND then
        self:playSound(actConfig.param1)
    elseif actType == BattleSkillType.UPDATE_FLIPX then
        self:updateFlipX(actConfig.param1)
    --@延迟
    elseif actType == BattleSkillType.DELAY then
        self:delayTime(actConfig.param1)
        self:addTypeInLoopList(actType)
    --@屏幕震动
    elseif actType == BattleSkillType.SPRING then
        self:springScene(actConfig.param1,actConfig.param2,actConfig.param3,actConfig.param4,actConfig.param5)
        -- self:addTypeInLoopList(actType)
    --@镜头移动
    elseif actType == BattleSkillType.CAMERA then
        self:cameraMove(actConfig.param1,actConfig.param2,actConfig.param3)
        self:addTypeInLoopList(actType)
    --@添加特效
    elseif actType == BattleSkillType.FLASH then
        self:createFlash(actConfig.param1,actConfig.param2)
    --@添加技能效果
    elseif actType == BattleSkillType.EFFECT then
        self.m_nEffectCountIndex = self.m_nEffectCountIndex + 1
        self:doEffect(actType,actConfig.param1)
        -- self:addTypeInLoopList(actType)
    elseif actType == BattleSkillType.EFFECT_IN_SKILL then
        WZLog("BattleMsgSkillShow:EFFECT_IN_SKILL",Serialize(self.m_tEffectIds))
        WZLog("BattleMsgSkillShow:EFFECT_IN_SKILL",actConfig.param1,self.m_tEffectIds[actConfig.param1])
        self.m_nEffectCountIndex = self.m_nEffectCountIndex + 1
        --处理整个列表效果
        if actConfig.param1 == -10000 then
            for i,effectId in pairs(self.m_tEffectIds) do
                self:doEffect(actType,effectId)
            end
        else
            self:doEffect(actType,self.m_tEffectIds[actConfig.param1])
        end
        -- self:addTypeInLoopList(actType)
    --@怪物射击
    elseif actType == BattleSkillType.MONSTER_SHOOT then
        self:monsterShoot(actConfig.param1,self.m_skillParam1,self.m_skillParam2)
        self:addTypeInLoopList(actType)
        self:addTypeInLoopList(BattleSkillType.REPEAT_SHOOT)
        self.m_sShootAnimName = actConfig.param2
        self.m_sShootEndAnimName = actConfig.param3
    --子弹刷新
    elseif actType == BattleSkillType.UPDATE_BULLET then
        self:addTypeInLoopList(actType)
    --@boss1炮台射击
    elseif actType == BattleSkillType.MONSTER_BOSS_GUN_SHOOT then
        self:addTypeInLoopList(actType)
        self:addTypeInLoopList(BattleSkillType.REPEAT_SHOOT)
    --@boss1炮台调整角度
    elseif actType == BattleSkillType.MONSTER_BOSS_GUN_ROTATION then
        self.m_tShooter = self.m_tOwner:getMachine()
        self.m_nShootOldRotation = self.m_tOwner:getMachine():getRotation()
        self:monsterShoot(actConfig.param1)
        self:getShootSpeed()
        self:addTypeInLoopList(actType)
    elseif actType == BattleSkillType.MONSTER_BOSS_GUN_ROTATION_RESET then
        self.m_nShootRotation = self.m_nShootOldRotation
        self:addTypeInLoopList(actType)
    --@镜头子弹跟随
    elseif actType == BattleSkillType.FOLLOW_BULLET then
        self:addTypeInLoopList(actType)
    --@固定坐标召唤(废旧)
    elseif actType == BattleSkillType.SUMMON then
        -- self:summon(self.m_skillParam1,self.m_skillParam2,self.m_skillParam3,self.m_skillParam4[1])
        -- self:addTypeInLoopList(BattleSkillType.SUMMON_SEND)
    --@射击召唤（废旧）
    elseif actType == BattleSkillType.SUMMON_II then
        -- self:summonII(self.m_skillParam1,self.m_skillParam2,self.m_skillParam3)
        -- self:addTypeInLoopList(BattleSkillType.SUMMON_SEND)
    --@创建召唤怪物
    elseif actType == BattleSkillType.SUMMON_BUILD then
        self:parseSummonMonster(actConfig.param1,actConfig.param2,actConfig.param3)
        -- self:addTypeInLoopList(BattleSkillType.SUMMON_BUILD)
        self:buildSummonMonster()
    --@特效表现辅助
    elseif actType == BattleSkillType.CREATE_ASSISTED_MSG then
       local bool = BattleMsgAssistedLib:createAssisted(self,actConfig.param1,self.m_skillParam1,self.m_skillParam2)
       if not bool then
        self:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
       end
    elseif actType == BattleSkillType.REMOVE_GUAI then
        self:removeGuai()
    elseif actType == BattleSkillType.MOVE_DISTANCE then
        self.m_tMoveDistance = {}
        if actConfig.param1 == 1 then
            self.m_tMoveDistance.isMoveX = true
        else
            self.m_tMoveDistance.isMoveX = false
        end
        self.m_tMoveDistance.distance = actConfig.param2
        if self.m_skillParam1 ~= -1 then
            self.m_tMoveDistance.distance = self.m_skillParam1
        end
        self.m_tMoveDistance.speed = actConfig.param3
        self:addTypeInLoopList(actType)
    elseif actType == BattleSkillType.ADD_BUFF then
        self:addBuff(actConfig.param1,actConfig.param2)
    end
end

--@移除怪物，连msg也会移除
function BattleMsgSkillShow:removeGuai()
    self.m_tOwner:clearMonsterList()
    self.m_tOwner:_removeDeadGuai()
end

--@添加tick函数
function BattleMsgSkillShow:addTypeInLoopList(actType)
    local  inList = false
    for i = 1,#self.m_tSkillLoopList do
        if actType == self.m_tSkillLoopList[i] then
            inList = true
            break
        end
    end
    if not inList then
        table.insert(self.m_tSkillLoopList,actType)
    end
end

--@循环播放 回切待机动作
function BattleMsgSkillShow:playStandby()
    local actor = self:getActor()
    actor:play(actor:getAnimationName("standby"),true)
    self:reduceWait(BattleSkillType.PLAY_LOOP)
end

--@播放动作
function BattleMsgSkillShow:playAnimation(animation,isLoop,isStopAutoStandAction)
    isLoop = isLoop or false
    local actor = self:getActor()
    if isStopAutoStandAction then
        actor:setAutoStandAction(false)
    end
    if self.m_tOwner and self.m_tOwner:getUseSkinBigSkill() then 
        actor = self.m_tOwner:getSkinBigSkillAnimation()
        WZLog("BattleMsgSkillShow:playAnimation skin",animation, isLoop)
        actor:play(animation,isLoop)
        return 
    end
    actor:play(actor:getAnimationName(animation),isLoop)
    WZLog("BattleMsgSkillShow:playAnimation",animation)
end

--@获得表演者
function BattleMsgSkillShow:getActor()
    local actor = self.m_tActionOwner or self.m_tOwner

    return actor
end

--@播放声音
function BattleMsgSkillShow:playSound(soundName)
    WZLog("BattleMsgSkillShow:playSound", soundName)
    soundName = soundName .. ".mp3"
    local filePath = CCFileUtils:sharedFileUtils():fullPathForFilename(soundName)
    local isExist = WZFileUtil:isFileExist(soundName)
    if isExist then
        SoundManager:playEffectSound(soundName)
        return
    end
    SoundManager:playEffectSound(GetRoleSound() .. "/" .. soundName)
end

--@延迟时间
function BattleMsgSkillShow:delayTime(time,callback)
    self.m_nLoopTime = time     
    self.m_nLoopDt = 0 
    self.m_tDelayCall = callback
end

--@震屏
function BattleMsgSkillShow:springScene(targetType,pos,time,distance,frequency)
    targetType = targetType or BattleSkillTargetType.SCENE
    self.m_tScreenSpring = BattleCommon:getPointTable(0,0)
    if targetType == BattleSkillTargetType.SCENE then
        --self.m_tScreenSpring = BattleCommon:getPointTable(0,0)
    elseif targetType == BattleSkillTargetType.SELF then
        self.m_tScreenSpring = self.m_tOwner:getPosition()
    elseif targetType == BattleSkillTargetType.TARGET then
        self.m_tScreenSpring = self.m_tTargetList[1] and self.m_tTargetList[1]:getPosition() or self.m_tOwner:getPosition()
    elseif targetType == BattleSkillTargetType.OTHER then
        self.m_tScreenSpring = pos or BattleCommon:getPointTable(0,0)
    end
    WZLog("BattleMsgSkillShow:springScene",targetType,self.m_tScreenSpring.x,self.m_tScreenSpring.y)
    BattleScreen:setSpring(self.m_tScreenSpring,true,time,distance,frequency)
end

--@镜头移动控制权
function BattleMsgSkillShow:isCanCtrlCamera()
    return self.m_tOwner:getBattleId() == WBattleGlobal:getCurrent():getCurrentCharacterId()
end

--@镜头移动
function BattleMsgSkillShow:cameraMove(targetType,cameraPosType,targetPos)
    if self.m_tOwner:isHide() == true then
        self:reduceWait(BattleSkillType.CAMERA)
        return
    end
    if targetType == BattleSkillTargetType.SCENE then
        self.m_tCameraPlayer = nil
    elseif targetType == BattleSkillTargetType.SELF then
        self.m_tCameraPlayer = self.m_tOwner
    elseif targetType == BattleSkillTargetType.TARGET then
        self.m_tCameraPlayer = self.m_tTargetList[1] or self.m_tOwner
    end
    if cameraPosType == BattleSkillTargetType.SCENE then
        self.m_tCameraPos = self.m_tOwner:getPosition()
    elseif cameraPosType == BattleSkillTargetType.SELF then
        self.m_tCameraPos = self.m_tOwner:getPosition()
    elseif cameraPosType == BattleSkillTargetType.TARGET then
        self.m_tCameraPos = self.m_tTargetList[1] and  self.m_tTargetList[1]:getPosition() or self.m_tOwner:getPosition()
    elseif cameraPosType == BattleSkillTargetType.OTHER then
        local sPos = self.m_tTargetList[1] and  self.m_tTargetList[1]:getPosition() or self.m_tOwner:getPosition()
        local ePos = self.m_tOwner:getPosition()
        self.m_tCameraPos = BattleCommon:getPointTable((sPos.x + ePos.x)/2,(sPos.y + ePos.y)/2)
    end

    --位移修正
    if targetPos then
        self.m_tCameraPos = BattleCommon:getPointTable(targetPos.x,targetPos.y + 120)
    end
    if self.m_tCameraPos then
        self.m_tCameraPos = BattleCommon:getPointTable(self.m_tCameraPos.x,self.m_tCameraPos.y + 120)
    end
    if self.m_tCameraPlayer then
        local pos = self.m_tCameraPlayer:getPosition()
        self.m_tCameraPos = BattleCommon:getPointTable(pos.x,pos.y + 120)
    end
end

--@创建特效管理
--@param #1 特效id 类型4时候为特效列表
--@param #2 特效类型    
function BattleMsgSkillShow:createFlash(flashIds,flashType)
    local nSplitArray = nil
    flashString = string.gsub(flashIds, " ", "")
    nSplitArray = SplitStringWithSeparator(flashString, ",")
    local flashList = {}
    local lineIndexs = {}
    self.m_nFlashCount = 0

    for i, v in pairs(nSplitArray) do
        if v == nil or v == "" then
            break
        end
        local flashId = tonumber(v)
        
        --对多个目标创建特效
        for k = 1,#self.m_tTargetList do
            local tmpType = flashType
            --连线特效目标修正
            if flashType == FlashPosType.LINE then
                if i == 2 then
                    tmpType = FlashPosType.MYSELF
                elseif i == 3 then
                    tmpType = FlashPosType.TARGET
                end
            end

            local target = self.m_tTargetList[k]
            local flashInfo = self:getFlashInfo(flashId,tmpType,target)
            local flash = self:initFlash(flashInfo)
            self.m_nFlashCount = self.m_nFlashCount + 1
            table.insert(flashList,flash)
            if tmpType == FlashPosType.LINE then
                table.insert(lineIndexs,i)
            end
        end
    end

    --直线特效 头 尾rotation调整(必须包含3个)
    if #lineIndexs > 0 then
        for i = 1,#lineIndexs do
            index = lineIndexs[i]
            flashLine = flashList[index]
            flashBegin = flashList[index+1]
            flashEnd = flashList[index+2]
            self:updateLineFlashView(flashBegin,flashLine,flashEnd)
        end
    end
end

--@brief 调整激光连线类特效
function BattleMsgSkillShow:updateLineFlashView(flashBegin,flashLine,flashEnd)
   local pos1 = flashBegin:getPosition()
    local pos2 = flashEnd:getPosition()
    local effectPos = BattleCommon:getPointTable((pos1.x + pos2.x)/2,(pos1.y + pos2.y)/2)
    local rotation =  math.atan((pos1.y - pos2.y)/(pos1.x - pos2.x)) * 180 / math.pi
    if pos1.x > pos2.x then
        rotation = -rotation
    else
        rotation = rotation
    end
    local distance = math.sqrt(math.pow((pos1.y-pos2.y),2)+math.pow((pos1.x-pos2.x),2)) 
    local scale = distance/flashLine:getEffectSize().width
    flashLine:setRotation(rotation)
    flashLine:setScaleX(scale)
    flashLine:setPosition(effectPos)

    flashBegin:setRotation(rotation)
    flashEnd:setRotation(rotation)
end

--@brief    获取特效信息
function BattleMsgSkillShow:getFlashInfo(flashId,flashType,target)
    local info = {}
    info.flashId = flashId
    info.target = target
    info.flashType = flashType or FlashPosType.MYSELF
    if info.flashType == FlashPosType.MYSELF or info.flashType == FlashPosType.LINE then
        info.pos = self.m_tOwner:getPosition() or BattleCommon:getPointTable(0,0)
    elseif info.flashType == FlashPosType.SCENE then 
        local size = SceneBattle:getFrontLayer():getContentSize()
        info.pos = BattleCommon:getPointTable(size.width/2, size.height/2)
    elseif info.flashType == FlashPosType.TARGET then
        info.pos = target:getPosition()
        
    else
        info.pos = BattleCommon:getPointTable(0,0)
    end
    return info
end

--@创建特效
function BattleMsgSkillShow:initFlash(effectInfo)
    if effectInfo.flashId == -1 or effectInfo.flashId == nil then 
        return
    end


    local effect  = BattleEffect:createAnimation(effectInfo.flashId)
    local pos =  effectInfo.pos 
    effect:setPosition(effectInfo.pos)
    SceneBattle:getFrontLayer():addChild(effect:getAnimNode(),10)
   
    local function effectCB()
       self.m_nFlashCount = self.m_nFlashCount - 1
       if self.m_nFlashCount <= 0 then
            self:reduceWait(BattleSkillType.FLASH)
        end
    end
    effect:addEndCallBack(effectCB)
    if effect.m_bIsOnStep then
        local function effectStepCB(effectDoneId)
            self:effectStepCallBack(effectDoneId)
        end
        effect:setStepCallBack(effectStepCB)
    end

    effect:playEffect()
   
    effect:setFlipX(self.m_tOwner.m_bIsFilpX)

    return effect
end

--@brief    特效步骤回调
--@desc     传入id 重新获取效果配置，不传入id直接使用原技能指向效果id（分段动作 isHurtAdvance  = 1 执行）
function BattleMsgSkillShow:effectStepCallBack(effectDoneId,screenSpring)
    --self:doEffect(effectDoneId)
    if screenSpring then
        self:springScene()
    end
end

--@处理效果
function BattleMsgSkillShow:doEffect(effectType,effectId)
    WZLog("BattleMsgSkillShow:doEffect",effectType,effectId,#self.m_tTargetList,self.m_nEffectCountIndex)
    if effectId == -1 or #self.m_tTargetList == 0 then
        self:reduceWait(effectType)
        return
    end
    if not self.m_tEffectCount then
        self.m_tEffectCount = {}
    end
    if not self.m_tEffectCount[self.m_nEffectCountIndex] then
        self.m_tEffectCount[self.m_nEffectCountIndex] = 1
    else
        self.m_tEffectCount[self.m_nEffectCountIndex] = self.m_tEffectCount[self.m_nEffectCountIndex] + 1
    end

    local msg = MsgManager:createMsg(BattleMsgSkillEffect)
    msg.m_tOwner = self.m_tOwner
    msg.m_nEffectId = effectId
    msg.m_tTargetList = self.m_tTargetList
    msg.m_nEffectCountIndex = self.m_nEffectCountIndex
    msg.m_tSkillShowMsg = self
    local function effectCB(effectIndex)
        WZLog("BattleMsgSkillShow:doEffect effectCB",effectIndex)
        if self.m_tEffectCount[effectIndex] then
            self.m_tEffectCount[effectIndex] = self.m_tEffectCount[effectIndex] - 1
            if self.m_tEffectCount[effectIndex] <= 0 then
                self.m_tEffectCount[effectIndex] = nil
                self:reduceWait(effectType)
            end
        else
            self:reduceWait(effectType)

        end
    end
    msg.m_tEffectDoneCB = effectCB
    WZLog("BattleMsgSkillShow:doEffect-2",msg.m_sName)
    if self.m_tOwner:getAI() then 
        self.m_tOwner:getAI():pushMonsterMsg(msg,false)
    else
        MsgManager:pushNonBlockMsg(msg)
    end
    -- MsgManager:pushNonBlockMsg(msg)
    --BattleMsgSkillShow.g_nEffectCount = BattleMsgSkillShow.g_nEffectCount + 1
end

--@brief 召唤
function BattleMsgSkillShow:summon(monsterId,count,maxCount,posList)
    summonMonsterList = {}
    posX = {}
    posY = {}
    for i = 1,#posList/2 do
        local index = i * 2
        if posList[index]then
            table.insert(posX, posList[index - 1])
            table.insert(posY, posList[index])
            --WZLog("BattleMsgSkillShow:summon",posList[index -1],posList[index])
        end
    end
    if type(monsterId) ~= "table" then
        table.insert(summonMonsterList, {id=monsterId,count=count,maxCount=maxCount,posX=posX,posY=posY})
    else
        for i = 1,#monsterId[1] do
            table.insert(summonMonsterList, {id=monsterId[1][i],count=count,maxCount=maxCount,posX={posX[i]},posY={posY[i]}})
        end
    end
    self.m_tSummonMonsterList = summonMonsterList
end

--@brief 攻击召唤
function BattleMsgSkillShow:summonII(monsterId,count,maxCount)
    summonMonsterList = {}
    posX = {}
    posY = {}
    for i = 1,count do
        if boss.m_tActiveAttackPos and #boss.m_tActiveAttackPos > 0 then
            table.insert(posX, boss.m_tActiveAttackPos[i].x)
            table.insert(posY, boss.m_tActiveAttackPos[i].y)
        end
    end
    table.insert(summonMonsterList, {id=monsterId,count=count,maxCount=maxNum,posX=posX,posY=posY})
    self.m_tSummonMonsterList = summonMonsterList
end

--@brief    配置创建小怪参数
function BattleMsgSkillShow:parseSummonMonster(isAuto,effectId,isFilpX)
    WZLog("BattleMsgSkillShow:parseSummonMonster one")
        self.m_bSummonAuto = isAuto
        self.m_bSummonEffectId = effectId
        self.m_bSummonIsFilpX = isFilpX
        self.m_nSummonIndex = 1
end

--@brief 小怪加入场景(普通)
function BattleMsgSkillShow:buildSummonMonster()
    --没有小怪创建成功
    if not self.m_bSummonAuto or not self.m_tOwner.m_tCursummonList or #self.m_tOwner.m_tCursummonList == 0 then
        self:reduceWait(BattleSkillType.SUMMON_BUILD)
        return
    end
    local monsterPos = nil
    for i,monster in pairs(self.m_tOwner.m_tCursummonList) do
        --加入场景
        
        WBattleGlobal:getCurrent().m_tGuais[monster:getBattleId()] = monster
        SceneBattle:getFrontLayer():addChild(monster:getAnimation():getAnimNode())
        if monster:getMover() then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(monster:getMover())
        end

        monster:setAppearAttribute()
        monster:play(monster:getAnimationName("standby"), true)

        --出现特效
        if self.m_bSummonEffectId then
            local effect  = BattleEffect:createAnimation(self.m_bSummonEffectId)
            monster:getAnimation():getAnimNode():addChild(effect:getAnimNode())
        end
        --调整方向
        if self.m_bSummonIsFilpX then
             if monster.m_bIsFilpX ~= true then
                monster:getAnimation():setFlipX(true)
                monster.m_bIsFilpX = true
            elseif monster.m_bIsFilpX == true then
                monster:getAnimation():setFlipX(false)
                monster.m_bIsFilpX = false
            end
        end
        if not monsterPos then
            monsterPos = monster:getPosition()
        end
    end
    WZLog("BattleMsgSkillShow:buildSummonMonster",monsterPos.x,monsterPos.y)
    --加入场景镜头拖动
    if  monsterPos then
        local config = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = nil,param2 = nil,param3 = monsterPos}
        self:doAction(config,config.isWait)
    end

    self:reduceWait(BattleSkillType.SUMMON_BUILD)
end

function BattleMsgSkillShow:monsterShoot(bulletId,attTimes,scatterNum)
    if not bulletId then
        bulletId = self.m_tOwner.m_nBulletId
    end
    local bulletInfo = BattleMethod:getBossBulletInfo(bulletId)
    self.m_tBulletInfo = bulletInfo
    self.m_bIsOldBulletAnim = bulletInfo.m_bIsOldBulletAnim
    self.m_sBulletAnimMainName = bulletInfo.m_sBulletAnimMainName
    self.m_sBulletAnimFlyName = bulletInfo.m_sBulletAnimFlyName
    self.m_nBulletAnimScale = bulletInfo.m_nBulletAnimScale
    self.m_nBulletType = bulletInfo.m_nBulletType
    self.m_nCheckCharacterCollisionRadius = bulletInfo.m_nCheckCharacterCollisionRadius
    self.m_bIsPenetrateMap = bulletInfo.m_bIsPenetrateMap
    self.m_bIsPenetrateMonster = bulletInfo.m_bIsPenetrateMonster
    self.m_nAttTimes = (attTimes and attTimes > 0) and attTimes or 1
    self.m_bIsIgnoreDef = bulletInfo.m_bIsIgnoreDef
    self.m_bBulletAnimFlipX = bulletInfo.m_bBulletAnimFlipX
    self.m_bIsNeedExplode = bulletInfo.m_bIsNeedExplode
    self.m_nBulletAnimDefaultDirection = bulletInfo.m_nBulletAnimDefaultDirection
    -- self.m_nEveryBulletShootDeltaTime = bulletInfo.m_nEveryBulletShootDeltaTime
    self.m_bIsNeedHurt = bulletInfo.m_bIsNeedHurt
    self.m_nScatterNum = (scatterNum and scatterNum > 0) and scatterNum or 1
    self.m_tOffset = bulletInfo.m_tOffset or {x = 0,y = 0}
    self.m_tAcceleration = bulletInfo.m_tAcceleration
    if self.m_nFireType == BulletEffectId.EFFECT_DEFAULT and bulletInfo.m_nFireType ~= -1 then
        self.m_nFireType = bulletInfo.m_nFireType
    end
    if self.m_nBoomType == BulletEffectId.EFFECT_DEFAULT and bulletInfo.m_nBoomType ~= -1 then
        self.m_nBoomType = bulletInfo.m_nBoomType
    end
    
    -- if WBattleGlobal:getCurrent():isSingleStage() then
    --     WBattleGlobal:getCurrent():setBulletNum(self.m_nAttTimes * self.m_nScatterNum)
    -- end
end

--@brief    创建子弹
function BattleMsgSkillShow:createBullet(bulletId)
    WZLog("BattleMsgSkillShow:createBullet",bulletId)
    SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE)
    
    self.m_nShootedCount = self.m_nShootedCount + 1
    local nBulletType
    nBulletType = self.m_nBulletType
    local nScatterNum = self.m_nScatterNum
    if not self.m_tShootSpeed then
        self.m_tShootSpeed = self:getShootSpeed()
    end
    local speedVec = self.m_tShootSpeed
    
    for i=1,nScatterNum do
        local startPos = {x = startX,y = startY}
        WZLog("BattleMsgSkillShow:createBullet two", tostring(self.m_nLeftRight), tostring(self.m_bIsOldBulletAnim), tostring(self.m_tOwner.m_nWeaponType), tostring(self.m_nBulletType), tostring(nBulletType), tostring(self.m_tAcceleration.x), tostring(self.m_tAcceleration.y), self.m_tStartPos.x, self.m_tStartPos.y)
        local bullet = WBattleGlobal:getCurrent():buildBossBullet(self:createBulletAnim(),self.m_tStartPos,speedVec,self.m_tAcceleration,self.m_tOwner,self.m_nBulletType,self.m_nFireType,self.m_nBoomType,self.m_bIsPenetrateMonster,self.m_bIsPenetrateMap)
        
        bullet.m_nShootedCount = self.m_nShootedCount
        bullet:getAnimation():getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        bullet:setCheckCharacterCollisionRadius(self.m_nCheckCharacterCollisionRadius)
        bullet:setAnimDefaultDirection(self.m_nBulletAnimDefaultDirection)
        bullet:getAnimation():setFlipX(true)
        if not self.m_tOwner.m_bIsFilpX then
            bullet:getAnimation():setFlipY(true)
        end
        SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode(),1)
        bullet:getAnimation():play("0")
        bullet:setStartRotation(speedVec)
        bullet.m_nBulletId = bulletId
        speedVec = BattleCommon:vectorWithAngle(speedVec,BattleConstants.g_fWB_SCATTER_ANGLE)

        if self.m_tOwner:isHide() == true then
            bullet:setOpacity(0)
            
            if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
                bullet:getBackFire():setVisible(false)
            end
        end
    end
end

--@brief 设置子弹射击参数
function BattleMsgSkillShow:getShootSpeed()
    local startAngle = 0
    --local nScatterNum = self.m_nScatterNum
    --startAngle = -1 * BattleConstants.g_fWB_SCATTER_ANGLE * (math.floor(nScatterNum / 2) - (nScatterNum+1)%2/2)

    local speed = self.m_tSpeed
    if speed == nil and (self.m_nBulletType == BulletType.THROW or self.m_nBulletType == BulletType.THROW_II)then
        speed = self:shoot()
    elseif speed == nil and self.m_nBulletType == BulletType.LINE then
        speed = self:shootLine(self.m_nShootPower)
    else
        self:shoot()
        speed = {x=-20,y=0}
    end
    local speedVec = BattleCommon:vectorWithAngle(speed,startAngle)

    if not self.m_nShootRotation then 
        self.m_nShootRotation = -BattleCommon:radiansToDegress(math.atan(speed.y/speed.x))/2
    end
    return speedVec
end

--@brief    创建子弹动画
function BattleMsgSkillShow:createBulletAnim()
    return BattleMethod:createBulletAnim(self.m_tBulletInfo)
end

--@brief 计算抛物线射击
--@return   发射速度
function BattleMsgSkillShow:shoot()
    local sPos,ePos = self:getCompareBulletPos()
    -- local angle
    -- local face

    -- local tAngle = math.abs(BattleCommon:radiansToDegress(math.atan2(ePos.y - sPos.y,ePos.x - sPos.x)))
    -- if tAngle > 90 then 
    --     tAngle = 180 - tAngle
    -- end

    -- local degree = -30
    -- local degreeOffset = -120
    -- if tAngle >= 60 then
    --     degree = -80
    --     degreeOffset = -20
    -- elseif tAngle >= 30 then
    --     degree = -70
    --     degreeOffset = -40
    -- end
    
    -- --炮弹发射位置和角度修正
    -- if ePos.x <= sPos.x then
    --     face = 1
    --     angle = degree + degreeOffset;
    -- else
    --     face = 0
    --     angle = degree;
    -- end
    -- local isAtkSucceed = false
    -- local rand = 3
    -- local power= (1 + rand) * SceneBattle:getFrontLayer():getScale() * 0.9;
    -- local speed = BattleCommon:angleToPoint(BattleCommon:degressToRadius(-angle))
    -- WZLog("BattleMsgSkillShow:shoot -1", speed.x, speed.y, power)
    -- isAtkSucceed, speed = BattleCommon:vectorNormalize(speed)
    -- isAtkSucceed, power = BattleCommon:getStartSpeedPowerWithSpeed(speed, sPos, ePos, power, self.m_tAcceleration)

    -- if isAtkSucceed == false or math.abs(speed.y * power) > 50 or math.abs(speed.x * power) > 50 then
    --     speed = self:shootLine(self.m_nShootPower)
    -- else
    --     speed.x = speed.x * power
    --     speed.y = speed.y * power
    -- end
    -- WZLog("BattleMsgSkillShow:shoot -2", speed.x, speed.y, power, isAtkSucceed)
    local isAtkSucceed,speed = BattleAiCheck:adjustAngle(sPos,ePos)
    -- if isAtkSucceed == false then
    --     speed = self:shootLine(100)
    -- end
    return speed
end

--@brief    计算直线射击
--@return   发射速度
function BattleMsgSkillShow:shootLine(shootPower)
    local sPos,ePos = self:getCompareBulletPos()
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

    if (ePos.y - sPos.y > 500 or math.abs(speed.y) > 20) and shootPower == nil then
        speed.x = speed.x * 1
        speed.y = speed.y * 1
    else
        local lowPower = 20/math.abs(speed.y)
        speed.x = speed.x * lowPower
        speed.y = speed.y * lowPower
    end

    -- if speed.y < -1000 or speed.x < -1000 then
    --     WZLog("BattleMsgSkillShow:shootLine zero-0", speed.x, speed.y)
    --     speed.x = speed.x / 100
    --     speed.y = speed.y / 100
    -- elseif speed.y < -100 or speed.x < -100 then
    --     WZLog("BattleMsgSkillShow:shootLine zero-1", speed.x, speed.y)
    --     speed.x = speed.x / 10
    --     speed.y = speed.y / 10
    -- end
    
    WZLog("BattleMsgSkillShow:shootLine zero-1", speed.x, speed.y)
    local limitSpeed = 50
    if math.abs(speed.y) > limitSpeed or math.abs(speed.x) > limitSpeed then
        local scaleX = limitSpeed/math.abs(speed.x)
        local scaleY = limitSpeed/math.abs(speed.y)
        local scale = scaleX < scaleY and scaleX or scaleY
        speed.x = math.floor(speed.x*scale*100)/100
        speed.y = math.floor(speed.y*scale*100)/100
    end
    WZLog("BattleMsgSkillShow:shootLine ", speed.x, speed.y, ePos.x, ePos.y, sPos.x, sPos.y, power)
    return speed
end

--@brief    获得子弹计算相关点
--@return   startPos,endpos (startPos 由self.m_tStartPos记录)
function BattleMsgSkillShow:getCompareBulletPos()
    local hero = self:getShooter()
    local targetHero = self.m_tTargetList[1] or WMonster:getRandomPlayer()
    
    local summonPos = nil
    if self.m_tShootSummonMonsterList ~= nil and self.m_tShootSummonMonsterList[self.m_nShootedCount] ~= nil and self.m_tShootSummonMonsterList[self.m_nShootedCount].posX ~= nil and self.m_tShootSummonMonsterList[self.m_nShootedCount].posX[1] ~= nil then
        summonPos = BattleCommon:getPointTable(self.m_tShootSummonMonsterList[self.m_nShootedCount].posX[1], self.m_tShootSummonMonsterList[self.m_nShootedCount].posY[1])
    end

    local eOffset = BattleCommon:getPointTable(targetHero.m_anim:getAnimNode():getContentSize().width * 0, targetHero.m_anim:getAnimNode():getContentSize().height * 0.3)
    local sPos = self:getShootStartPos()
    local ePos = summonPos or self.m_tEndPos or BattleCommon:getPointTable(targetHero:getPosition().x + eOffset.x,targetHero:getPosition().y + eOffset.y)
    
    --子弹自身偏移 
    --if self.m_nLeftRight == DirectionType.LEFT then
     local shootOffset = BattleCommon:getPointTable(self.m_tOffset.x + hero.m_tbulletPosOffset.x,self.m_tOffset.y + hero.m_tbulletPosOffset.y)
    --else
        --self.m_tOffset = BattleCommon:getPointTable(self.m_tOffset .x - self.m_tOwner.m_tbulletPosOffset.x,self.m_tOffset .y + self.m_tOwner.m_tbulletPosOffset.y)
    --end

    --炮弹发射位置和角度修正
    if ePos.x <= sPos.x then
        sPos = BattleCommon:getMonsterShootPos(true, hero,shootOffset)
    else
        sPos = BattleCommon:getMonsterShootPos(false, hero,shootOffset)
    end
    self.m_tStartPos = sPos
    WZLog("BattleMsgSkillShow:getCompareBulletPos",self.m_tStartPos.x,self.m_tStartPos.y)
    if WBattleGlobal:getCurrent():isSingleStage() then
        local rate = self.m_tOwner.m_nHitRate > 0 and self.m_tOwner.m_nHitRate or 100
        local hitPercentage = BattleAiCheck:getCurRandNum()%100
        if hitPercentage > rate then
            local ePosOriX = ePos.x
            ePos = BattleCommon:getPointTable(ePos.x + 100 * (hitPercentage > 85 and 1 or -1), ePos.y)
        end
    end
    return sPos,ePos
end

--@brief 获得射击者
function BattleMsgSkillShow:getShooter()
    local shooter = self.m_tShooter or self.m_tOwner
    return shooter
end

--@brief    检查伤害(废弃)
--@return   #1:受伤的人物列表
--@return   #2:受伤值
function BattleMsgSkillShow:checkHurt(bullet)
    WZLog("BattleMsgSkillShow:checkHurt")
    
    --local bullet = WBattleGlobal:getCurrent():getBossBulletByIndex(1)
    local tHurtCharas = {}
    local tHurtValues = {}
    local tHurtRatios = {}
    for i,charaList in pairs(bullet.m_tCollisionCharacters) do
        for id,chara in pairs(charaList) do
            --玩家身上是否有免攻击效果
            local bOffCollision = chara:isInBuffState(EffectTypeConfig.IMMUNITY_ATTACK)
            if not chara:isDead() and not bOffCollision then
                local bulletPos = bullet:getMover():getMoverPosition()
                bulletPos = {x=bulletPos:getX(),y=bulletPos:getY()}
                
                local charaPos = chara:getCenterPos()
                charaPos = Vector2:create(charaPos.x,charaPos.y)
                
                WZLog("BattleMsgSkillShow:_checkHurt bulletPos = ("..bulletPos.x..", "..bulletPos.y..") charaPos = ("..charaPos.x..", "..charaPos.y.."self.m_nCheckCharacterCollisionRadius = "..self.m_nCheckCharacterCollisionRadius..") chara:getRadiusForHurt() = "..chara:getRadiusForHurt(), chara:getId())
                if not chara:isDead() and BattleCommon:checkCircleCollosion(bulletPos,self.m_nCheckCharacterCollisionRadius * 1,charaPos,chara:getRadiusForHurt()) == true then
                    local hurt,recordRatio = self:getHurt(chara)
                    tHurtCharas[id] = chara
                    tHurtValues[id] = hurtValue
                    tHurtRatios[id] = recordRatio
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
            WZLog("BattleMsgSkillShow:_checkHurt one", v:getBattleId())
        end
    end
    WZLog("BattleMsgSkillShow:_checkHurt two", tostring(bullet))

    return tHurtCharas,tHurtValues,tHurtRatios
end


--@brief    计算伤害
--@return   #1：伤害
function BattleMsgSkillShow:getHurt(chara)
    WZLog("BattleMsgSkillShow:getHurt")
    return BattleMethod:getHurt(self.m_tOwner,chara,self.m_bIsIgnoreDef)
end

--@brief    对英雄添加受伤数字
--@param    charas:英雄列表
--@param    hurtValue:受伤数字
function BattleMsgSkillShow:charaAddHurtValue(charas,hurtValue,hurtRatios)
    WZLog("BattleMsgSkillShow:charaAddHurtValue one")
    return BattleMethod:charaAddHurtValue(self.m_tOwner,charas,hurtValue,hurtRatios)
end

--@brief    发送受伤协议
function BattleMsgSkillShow:sendHurtProtocol(charas, values,distance,critType,monster)
    WZLog("BattleMsgSkillShow:sendHurtProtocol one")
    if monster ~= nil then
        BattleMethod:sendHurtProtocol(monster, charas, values,distance,critType)
    else
        BattleMethod:sendHurtProtocol(self.m_tOwner, charas, values,distance,critType)
    end
end

--@brief    等待伤害数字消失
function BattleMsgSkillShow:waitForHurtNum()
    if self.m_bWaitHurtCheck then
        return true
    end
    local isHurt, hurtOne = WBattleGlobal:getCurrent():IsAnyOneHurt()
    WZLog("BattleMsgSkillShow:waitForHurtNum", tostring(hurtOne), tostring(not isHurt))
    return not isHurt
end

--@brief    选择目标
function BattleMsgSkillShow:chooseTarget(hero,effectParm)
    -- hero = hero or self.m_tOwner
    -- local chooseTargetType = effectParm[1]
    -- local tSkillTargetHeroList = {}
    -- if chooseTargetType == ChooseTargetConfig.RANDOM then
    --     table.insert(tSkillTargetHeroList, WMonster:getRandomPlayer())
    -- elseif chooseTargetType == ChooseTargetConfig.NEAREST then
    --     table.insert(tSkillTargetHeroList, hero:getNearestPlayer())
    -- elseif chooseTargetType== ChooseTargetConfig.FAREST then
    --     table.insert(tSkillTargetHeroList, WMonster:getFarestPlayer())
    -- elseif chooseTargetType == ChooseTargetConfig.HP_MAX then
    --     table.insert(tSkillTargetHeroList, WMonster:getHpMaxPlayer())
    -- elseif chooseTargetType == ChooseTargetConfig.HP_MIN then
    --     table.insert(tSkillTargetHeroList, WMonster:getHpMinPlayer())
    -- elseif chooseTargetType == ChooseTargetConfig.NEAR_BOSS_LIST then
    --     _, tSkillTargetHeroList = hero:getHeroNearBoss(effectParm[2][1])
    -- elseif chooseTargetType == ChooseTargetConfig.NEAR_POSITION_LIST then
    --     _, tSkillTargetHeroList = hero:getHeroNearPos(effectParm[2][1],effectParm[2][2])
    -- elseif chooseTargetType == ChooseTargetConfig.ALL_HERO then
    --     tSkillTargetHeroList = WMonster:getAllPlayer()
    -- elseif chooseTargetType == ChooseTargetConfig.MYSELF then
    --     table.insert(tSkillTargetHeroList, hero)
    -- elseif chooseTargetType == ChooseTargetConfig.ALL_BOSS then
    --     tSkillTargetHeroList = WMonster:getAllMonsterBoss()
    -- elseif chooseTargetType == ChooseTargetConfig.DISTANCE_X then
    --     local centerPos = effectParm[3] and BattleCommon:getPointTable(effectParm[3][1],effectParm[3][2]) or hero:getPosition() --指定中心点或者以自身为中心计算
    --     tSkillTargetHeroList = WMonster:getDistanceXPlayer(centerPos,effectParm[2][1],effectParm[2][2],effectParm[2][3])
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
    -- else
    --     table.insert(tSkillTargetHeroList, WMonster:getRandomPlayer())
    -- end
    
    -- WZLog("BattleMsgSkillShow:_chooseTarget",chooseTargetType,#tSkillTargetHeroList)
    -- --[[
    -- if #tSkillTargetHeroList == 0 then
    --     table.insert(tSkillTargetHeroList, WMonster:getRandomPlayer())
    -- end
    -- ]]
    -- return tSkillTargetHeroList
    return BattleChooseMethod:chooseTarget(hero,effectParm)
end

--@brief    初始化对话框
function BattleMsgSkillShow:initDialog()
    WZLog("BattleMsgSkillShow:initDialog")

    --161改
    do return end
    
    if self.m_nTalkId <= 0 then
        return
    end
    local text = nil
    if GDatatab_talk ~= nil and GDatatab_talk["id_"..self.m_nTalkId] ~= nil then
        text = GDatatab_talk["id_"..self.m_nTalkId].talk          --文本内容
    else
        return 
    end

    local maxWidth = 280           --最大宽度
    local scale = 1.0              --缩放大小
    local isUpdatePos = true
    local time = 3
    local direct = CellDialog.DIR_RIGHT
    local offsetPos = nil
    
    local pos = self.m_tOwner:getAnimDialogPos()
    local height = pos.x
    local width = pos.y
    
    if self.m_tOwner.m_tCollisionRang ~= nil then
        height = self.m_tOwner.m_tCollisionRang[1].m_fHeight * 0.7 + 30
        width = self.m_tOwner.m_tCollisionRang[1].m_fWidth * 0.4 + 30
    elseif self.m_tOwner.m_nAiType == MonsterAiType.AI_ROBOT then
        height = 70
        width = 50
    end

    if self.m_tOwner:getType() == 1 and self.m_tOwner.m_sAniFileId == "boss_2001" then
        height = self.m_tOwner.m_tCollisionRang[1].m_fHeight * 0.5 
    end

    -- if self.m_tOwner:getPosition().x < 450 then
    --     direct = CellDialog.DIR_RIGHT
    --     offsetPos = BattleCommon:getPointTable(width, height)   --位置偏移量
    -- elseif self.m_tOwner:getPosition().x > 1200 then
    --     direct = CellDialog.DIR_LEFT
    --     offsetPos = BattleCommon:getPointTable(-width, height)   --位置偏移量
    -- else
        if self.m_tOwner.m_bIsFilpX == false then
            direct = CellDialog.DIR_LEFT
            offsetPos = BattleCommon:getPointTable(-width, height)   --位置偏移量
        else
            direct = CellDialog.DIR_RIGHT
            offsetPos = BattleCommon:getPointTable(width, height)   --位置偏移量
        end
    -- end
    WZLog("BattleMsgSkillShow:initDialog",tostring(self.m_tOwner.m_bIsFilpX),self.m_tOwner:getPosition().x,direct)
    if self.m_tOwner.m_tDialog ~= nil then
        self.m_tOwner.m_tDialog:removeDialog()
        self.m_tOwner.m_tDialog = nil
    end

    self:showDialog(text,direct,offsetPos,maxWidth,scale,isUpdatePos,time)
end

--@brief    初始化对话框
function BattleMsgSkillShow:showDialog(text,direct,offsetPos,maxWidth,scale,isUpdatePos,time)
    if self.m_tOwner:isHide() then
        return
    end
    WZLog("BattleMsgSkillShow:showDialog")
    local boss = self.m_tOwner

    local nameInfo = nil
    if self.m_bIsRelyNameInfo ~= nil and self.m_bIsRelyNameInfo == false then
        nameInfo = boss:getAnimation():getAnimNode()
    elseif boss:getPlayerNameIcon() ~= nil then
        nameInfo = boss:getPlayerNameIcon().m_tNameLayer
    elseif boss.m_tGuaiName ~= nil then
        nameInfo = boss.m_tGuaiName.m_tNameLayer
    elseif boss.m_tBossName ~= nil then
        nameInfo = boss.m_tBossName.m_tNameLayer
    elseif boss.m_tBossNameAndHP ~= nil then
        nameInfo = boss.m_tBossNameAndHP.m_tNameLayer
    end

    boss.m_tDialogElement,boss.m_tDialog = CellDialog:addDialog(nameInfo, SceneBattle:getInfoLayer(),
        text, direct, time, nil, nil, 
        0, 0, maxWidth, scale, nil, nil, isUpdatePos, boss,100,nil,nil,nil,nil,true)
    ---[[
    local isSpecBoss = false
    --组队副本9boss 对话框特殊处理
    if math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 210 or
       math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 202 then
        isSpecBoss = true
    end

    if not isSpecBoss and boss.m_mover ~= nil and (boss.m_nAiType == nil or boss.m_nAiType ~= MonsterAiType.AI_MELEE_SKY ) then
        local node = TrackNode:create(boss.m_tDialogElement)
        boss.m_tDialog.m_trackNode = node
        node:setPreAdd(Vector2:create(offsetPos.x,offsetPos.y))
        boss.m_mover:addTrackNode(node)
    else
        boss.m_nDialogOffset = offsetPos
        local point = ccp(boss:getPosition().x, boss:getPosition().y)
        point = boss:getAnimation():getAnimNode():getParent():convertToWorldSpace(point)
        point = SceneBattle:getInfoLayer():convertToNodeSpace(point)
        local pos = GlobalMethod:ccp(point.x + offsetPos.x,point.y + offsetPos.y)
        boss.m_tDialogElement:setPosition(pos)
        boss.m_bDialogIsFilpX = boss.m_bIsFilpX
    end
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgSkillShow:done()
    WZLog("BattleMsgSkillShow:done",tostring(self.m_bIsReplayMsg))
    -- if not self.m_tOwner:isDead() then
    --     self.m_tOwner:setMoveUpdatable(true)
    -- end
    local bullets = WBattleGlobal:getCurrent():getBossBulletsList()
    for i=#bullets,1,-1 do
        --移除子弹
        bullets[i]:destroy()
        WBattleGlobal:getCurrent():removeBossBulletByIndex(i)
    end
    --射击动作回切 不做等待检测
    --表演结束 设置自动回切待机
    self.m_tOwner:setAutoStandAction(true)

    --移动不处理
    if self.m_tMoveParm then
        return
    end
    if self.m_tOwner:isDead() then
        return 
    end
    --行动移除
    if self.m_nSkillId and self.m_nSkillId > 0 and self.m_tOwner:getAI() then
        self.m_tOwner:getAI():removeActionList(AiActionConfig.SKILL,self.m_nSkillId)
    end
    -- if self.m_tOwner:getAI() ~= nil and self.m_tOwner:getAI().m_nAiActionCount ~= nil and self.m_tOwner:getAI().m_nAiActionCount > 0 then
    --     self.m_tOwner:getAI().m_nAiActionCount = self.m_tOwner:getAI().m_nAiActionCount - 1
    --     WZLog("BattleMsgSkillShow:done aiCount = ",self.m_tOwner:getAI().m_nAiActionCount)
    --     if self.m_tOwner:getAI().m_nAiActionCount == 0 then
    --         self.m_tOwner:getAI().m_nAiActionCount = 100
    --     end
    -- end
end

-------------------------------------私有方法模块--------------------------------------