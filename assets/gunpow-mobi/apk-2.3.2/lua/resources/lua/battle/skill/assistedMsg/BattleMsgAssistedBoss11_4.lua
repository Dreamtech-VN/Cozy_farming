--BattleMsgAssistedBoss11_4.lua
--@brief    怪物移动
--@date     2015/9/15
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedBoss11_4 = {
    m_sName = "BattleMsgAssistedBoss11_4",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    --目标点
    m_tTargetPos = nil,
    m_bMovePlayed = nil,
    m_tAirMoveStep = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss11_4:init()
    WZLog("BattleMsgAssistedBoss11_4:init",self:getOwner():isInBuffState(EffectTypeConfig.LIMIT_MOVE))
    if self:getOwner():isInBuffState(EffectTypeConfig.LIMIT_MOVE) or self:getOwner():isInBuffState(EffectTypeConfig.LIMIT_ALL_ACTION) then
        self:getOwner().m_bIsCanMove = nil
    end
    self:readyMonsterMove()
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss11_4:process(dt)
    return self:monsterMove()
end

function BattleMsgAssistedBoss11_4:initMoveParam()
    local list = WBattleGlobal:getCurrent():getHeroSortList()
    local boss = self:getOwner()
    local nTempCtb = 10000
    local heroPos = nil
    for id, hero in ipairs(list) do
        if not hero:isDead() and hero:getCamp() ~= boss:getCamp() and nTempCtb > BattleCtbManager:getCtb(hero:getBattleId()) then
            nTempCtb = BattleCtbManager:getCtb(hero:getBattleId())
            heroPos = hero:getPosition()
        end
    end
    local offsetX = 150
    local face = WBattleGlobal:getCurrent():getCurRandNum() % 2
    if heroPos.x < offsetX then
        face = 0
    elseif heroPos.x > SceneBattle:getFrontLayerSize().width - offsetX then
        face = 1
    end

    if face == 0 then
        offsetX = 150
    else
        offsetX = -150
    end
    local targetPos = BattleCommon:getPointTable(heroPos.x + offsetX,heroPos.y)
      
    self.m_tSkillShowMsg.m_tMoveParm = {}
    self.m_tSkillShowMsg.m_tMoveParm.targetPos = targetPos
end

--@brief    怪准备瞬移
function BattleMsgAssistedBoss11_4:readyMonsterMove()
    if self.m_bIsNearPlayer then
        self:initMoveParam()
    end
end


--@brief    小怪移动
function BattleMsgAssistedBoss11_4:monsterMove()
    local moveEnd = false
    local monster = self:getOwner()
    if  monster:isDead() or  monster:isSacrifice() or monster:isBoom() then
        return
    end
    WZLog("BattleMsgAssistedBoss11_4:monsterMove",monster.m_bIsCanMove)
    if not monster.m_bIsCanMove or WBattleGlobal:getCurrent():isGameOver() then
        monster:play(monster:getAnimationName("standby"), true)
        monster:setActFinished(true)
        return true
    end

    monster:setPosition(self.m_tSkillShowMsg.m_tMoveParm.targetPos)
    moveEnd = true
    
    --镜头跟随
--    self:followMonsterListMove()
    if moveEnd then
        monster:play(monster:getAnimationName("standby"), true)
        monster:setActFinished(true)
        return true
    end
    return false
end

--@brief    屏幕跟踪小怪
function BattleMsgAssistedBoss11_4:followMonsterListMove()
    if not self:isCanCtrlCamera() then
        return
    end
    WZLog("BattleMsgAssistedBoss11_4:followMonsterListMove")
    BattleScreen:followHero(self:getOwner():getMover():getMoverPosition())
end

--@brief 镜头控制
function BattleMsgAssistedBoss11_4:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss11_4:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss11_4:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得移动参数
function BattleMsgAssistedBoss11_4:getMoveParam()
    return self.m_tSkillShowMsg.m_tMoveParm
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss11_4:done()
    WZLog("BattleMsgAssistedBoss11_4:done")
    self:getOwner().m_bIsCanMove = nil
    --技能位移
    if self.m_bIsNearPlayer then
        self.m_tSkillShowMsg.m_tMoveParm = nil
    end
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
