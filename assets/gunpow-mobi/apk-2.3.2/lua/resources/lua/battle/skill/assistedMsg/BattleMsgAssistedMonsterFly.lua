--BattleMsgAssistedMonsterFly.lua
--@brief    怪物飞行
--@date     2015/10/25
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedMonsterFly = {
    m_sName = "BattleMsgAssistedMonsterFly",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    --内部赋值变量
    m_nSpeedx = 0, --飞行速度
    m_nSpeedy = 0, --飞行速度
    m_nStartX = 0, --飞行初始位置
    m_nStartY = 0, --飞行初始位置
    m_nLeftRight = 0, --1：左 0：右（向左还是向右）

    m_nFlickerTime = 0,     --播放闪烁时长
    m_bOutOfScene = false,  --是否飞出屏幕

    --
    SHOW_FLICKER_TIME = 0.6,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedMonsterFly:init()
    local skillConfig = CopyTable(GDatatab_skill["id_"..19998])
    if skillConfig then
        BattleCtbManager:addCtb(self:getOwner():getBattleId(),skillConfig.consume)
    end
    self:getOwner().m_bIsUseSkill = true

    local flyParam = self:getFlyParam()
    self.m_nSpeedx = flyParam.m_nSpeedx
    self.m_nSpeedy = flyParam.m_nSpeedy
    self.m_nStartX = flyParam.m_nStartX
    self.m_nStartY = flyParam.m_nStartY + 20 
    WZLog("BattleMsgAssistedMonsterFly:init",self.m_nSpeedx,self.m_nSpeedy,self.m_nStartX,self.m_nStartY)
    if SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_NORMAL then
        return
    end
    SceneBattle:getBattleLoop():setBattleStatus(BattleLoop.S_PLAYER_FLY)
    local hero = self:getOwner()
    
    hero:setRunStatus(RunStatus.DEF_ST_FLY)
    hero:setPosition(Vector2:create(self.m_nStartX,self.m_nStartY))
    hero:getMover():setMoverPrePosition(Vector2:create(self.m_nStartX,self.m_nStartY))
    hero:getMover():setMoverSpeed(Vector2:create(self.m_nSpeedx,self.m_nSpeedy))
    hero:getMover():setFly(true)
    hero:setMoveUpdatable(true)
    hero:play("fly",true)

    self.m_backFire = WBulletBackFire:create(nil, BulletEffectId.EFFECT_FLY)
    self.m_backFire:getElement():retain()
    if hero:getAnimation():getAnimNode():getOpacity() > 0 then
        self.m_backFire:getTrackNode():setAffterAdd(Vector2:create(0,10))
        hero:getMover():addTrackNode(self.m_backFire:getTrackNode())
        SceneBattle:getFrontLayer():addChild(self.m_backFire:getElement():getParent(),2)
    end

    hero:getAnimation():setRotate(0)
    hero:getMover():setMoverRotate(0)
    
    WZLog("BattleMsgPlayerFly:init two", tostring(self.m_backFire), hero:getMover():getMoverPosition().x, hero:getMover():getMoverPosition().y)
    if self.m_nSpeedx < 0 then
        self.m_nLeftRight = 0
    else
        self.m_nLeftRight = 1
    end
    --怪物正方向为右
    if (WBattleGlobal:getCurrent():isDoubleTowerStage() and type(hero.suitConfig) == "number" and hero.suitConfig == 999) then
        if self.m_nLeftRight == 0 and hero:getAnimation():isFlipX() == false then
            hero:getAnimation():setFlipX(true)
            hero.m_bIsFilpX = true
       elseif self.m_nLeftRight == 1 and hero:getAnimation():isFlipX() == true then
            hero:getAnimation():setFlipX(false)
            hero.m_bIsFilpX = false
        end
    else
        if self.m_nLeftRight == 0 and hero:getAnimation():isFlipX() == true then
            hero:getAnimation():setFlipX(false)
            hero.m_bIsFilpX = false
        elseif self.m_nLeftRight == 1 and hero:getAnimation():isFlipX() == false then
            hero:getAnimation():setFlipX(true)--正方向
            hero.m_bIsFilpX = true
        end
    end
    
    SoundManager:playEffectSound(SoundDefine.E_S_FLY)
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedMonsterFly:process(dt)
    WZLog("BattleMsgAssistedMonsterFly:process", CCDirector:sharedDirector():getAnimationInterval())
    if self.m_bOutOfScene == true then
        self.m_nFlickerTime = self.m_nFlickerTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
        if self.m_nFlickerTime > BattleMsgPlayerFly.SHOW_FLICKER_TIME then
            return true
        end
        return false
    end
    local hero = self:getOwner()

    if hero == nil or hero:isDead() == true then
        return
    end
    
    --WZLog("BattleMsgPlayerFly:process", hero:getMover():getMoverSpeed().x, hero:getMover():getMoverSpeed().y, hero:getMover():getMoverPosition().x, hero:getMover():getMoverPosition().y)
    if hero:getMover():isCollision() == false then
        local sceneSize = SceneBattle:getFrontLayerSize()
        if hero:getMover():getMoverPosition().x < -100 or hero:getMover():getMoverPosition().x > sceneSize.width + 100 or hero:getMover():getMoverPosition().y < -100 then
            local oldPointX = self.m_nStartX
            local oldPointY = self.m_nStartY - 20
            
            local oldPoint = Vector2:create(oldPointX,oldPointY)
            hero:getMover():setFly(false)
            hero:setPosition(oldPoint)
            hero:getMover():setMoverPosition(oldPoint)
            hero:getMover():setMoverPrePosition(oldPoint)
            hero:getMover():setMoverSpeed(Vector2:create(0,0))
            hero:setMoveUpdatable(true)
            if self.m_backFire then
                WZLog("BattleMsgAssistedMonsterFly:done two-1")

                --self.m_backFire:getElement():release()
                hero:getMover():removeTrackNode(self.m_backFire:getTrackNode())

                self.m_backFire:removeElement()
                self.m_backFire = nil
            end
            if self:isCanCtrlCamera() then
                BattleMapManager:getFrontControl():centerOnPointWithAction(hero:getMover():getMoverPosition(),0,0.1)
                if WBattleGlobal:getCurrent():isFog() then
                    BattleMapManager:getFogControl():centerOnPointWithAction(hero:getMover():getMoverPosition(),0,0.1)
                end
            end
            self.m_bOutOfScene = true
            if not (hero.m_nHideTurn ~= nil and hero.m_nHideTurn > 0) then
                self:_showFlicker()
            end
            
            hero:play(hero:getAnimationName("standby"),true)

            return false
        else
            if self:isCanCtrlCamera() then
                WZLog("BattleScreen:followHero 1")
                BattleScreen:followHero(hero:getMover():getMoverPosition())
            end
            return false
        end
    end
    WZLog("BattleMsgAssistedMonsterFly:process hero:checkCollisionInFly true")
    hero:play(hero:getAnimationName("standby"),true)

    hero:getMover():setFly(false)
    hero:getAnimation():setRotate(0)
    hero:setMoveUpdatable(true)
    return true
end

--@brief 镜头控制
function BattleMsgAssistedMonsterFly:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedMonsterFly:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedMonsterFly:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedMonsterFly:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

function BattleMsgAssistedMonsterFly:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config)
end

--@brief 获得移动参数
function BattleMsgAssistedMonsterFly:getFlyParam()
    return self.m_tSkillShowMsg.m_tFlyParam
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedMonsterFly:done()
    WZLog("BattleMsgAssistedMonsterFly:done")
    local hero = self:getOwner()
    --hero:getMover():setMoverCollisionType(BattleConstants.g_nE_COLLISION_POINT)
    hero:getMover():setFly(false)
    hero:play(hero:getAnimationName("standby"),true)
    if SceneBattle:getBattleLoop():getBattleStatus() ==  BattleLoop.S_PLAYER_FLY then
        SceneBattle:getBattleLoop():setBattleStatus(BattleLoop.S_NORMAL)
    end
    if self.m_backFire then
        WZLog("BattleMsgPlayerFly:done two-2")
        --self.m_backFire:getElement():release()
        hero:getMover():removeTrackNode(self.m_backFire:getTrackNode())
        self.m_backFire:removeElement()
        self.m_backFire = nil
    end

    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
function BattleMsgAssistedMonsterFly:_showFlicker()
    local hero = self:getOwner()
    self.m_nFlickerTime = 0
    
    local times = 6
    local nTime = BattleMsgPlayerFly.SHOW_FLICKER_TIME / times
    local array = CCArray:create()
    for i=1,times do
        local opacity = (i%2 == 1) and 0 or 255
        local act=CCFadeTo:create(nTime,opacity)
        array:addObject(act)
    end
    hero:getAnimation():getAnimNode():runAction(CCSequence:create(array))
end
