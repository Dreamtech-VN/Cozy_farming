--BattleMsgAssistedBoss6_1.lua
--@brief    boss复活
--@date     2015/09/15
--@author   mbq

--@brief    消息数据表
BattleMsgAssistedBoss6_1 = {
    m_sName = "BattleMsgAssistedBoss6_1",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss6_1:init()
    WZLog("BattleMsgAssistedBoss6_1:init")
    self.m_nDeltaTime = 0
    local monster = self:getOwner().m_tCursummonList[1]
    if monster then

        if self:getOwner():getPosition().x > monster:getPosition().x then
            monster:getAnimation():setFlipX(true)
            monster.m_bIsFilpX = true
        end

        SceneBattle:getFrontLayer():addChild(monster:getAnimation():getAnimNode(),1)
        WBattleGlobal:getCurrent().m_tGuais[monster:getBattleId()] = monster
        if monster:getMover() then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(monster:getMover())
        end
        monster:setAppearAttribute()
        monster:play(monster:getAnimationName("reborn_3"), false)
        monster:setActFinished(true)

        BattleCtbManager:addCellBattleCtb(monster:getBattleId())
        
        local config = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = nil,param2 = nil,param3 = monster:getPosition()}
        self:msgDoAction(config,config.isWait)
    end


end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss6_1:process(dt)
    self.m_nDeltaTime = self.m_nDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
    if self.m_nDeltaTime < 2 then
        return false
    end

    return true
end


--@brief 添加表演
function BattleMsgAssistedBoss6_1:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss6_1:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss6_1:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end


--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss6_1:done()
    WZLog("BattleMsgAssistedBoss6_1:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------

