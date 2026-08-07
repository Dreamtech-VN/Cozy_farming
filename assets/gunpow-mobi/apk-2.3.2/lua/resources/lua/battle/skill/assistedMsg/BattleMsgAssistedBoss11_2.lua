-- BattleMsgAssistedBoss11_2.lua
--@brief    隐身
--@date     2016/10/18
--@note

--@brief    消息数据表
BattleMsgAssistedBoss11_2 = {
    m_sName = "BattleMsgAssistedBoss11_2.lua",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss11_2:init()
    WZLog("BattleMsgAssistedBoss11_2:init")
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss11_2:process(dt)
    if self:getOwner():isHide() then 
        self:getOwner():hide()
        local tTargetPos = self:initMoveParam()
        WZLog("BattleMsgAssistedBoss11_2:init", tTargetPos.y)
        self:getOwner():setPosition(tTargetPos)
        self:getOwner():changeScale(0.3)
    else 
        return false 
    end
    return true
end

function BattleMsgAssistedBoss11_2:initMoveParam()
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
      
    return targetPos
end

--@brief 镜头控制
function BattleMsgAssistedBoss11_2:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss11_2:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss11_2:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss11_2:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss11_2:msgDoAction(config)
    WZLog("BattleMsgAssistedBoss11_2:msgDoAction")
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

function BattleMsgAssistedBoss11_2:playOwnerAnim(animName,isLoop)
    local monster = self:getOwner()
    monster:play(monster:getAnimationName(animName), isLoop)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss11_2:done()
    WZLog("BattleMsgAssistedBoss11_2:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
