--BattleMsgAssistedBoss6_1.lua
--@brief    boss抓取指定点掉落
--@date     2015/09/15
--@author   mbq

--@brief    消息数据表
BattleMsgAssistedBoss6_3 = {
    m_sName = "BattleMsgAssistedBoss6_3",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss6_3:init()
    WZLog("BattleMsgAssistedBoss6_3:init")
    local posList = {GlobalMethod:ccp(445,591),GlobalMethod:ccp(602,615),GlobalMethod:ccp(1141,622),GlobalMethod:ccp(1329,601)}

    local targetHeroList = self:getOwner().m_tHitTargets or {}
    if #targetHeroList == 0 then
        return
    end

    local heroList = {}
    for i,hero in pairs(targetHeroList) do
        if not hero.m_bOffRepulse then
            table.insert(heroList,hero)
        end
    end
    targetHeroList = heroList
    local sortFunc = function(a, b) return b:getBattleId() < a:getBattleId() end
    table.sort(targetHeroList,sortFunc)

    local randList = WBattleGlobal:getCurrent().m_tBattleRand

    for i, hero in ipairs (targetHeroList) do
        local randIndex = (WBattleGlobal:getCurrent():getTurnTimes() + hero:getBattleId()) % 10 + 1
        local randValue = randList[randIndex] % #posList + 1
        hero:setPosition(posList[randValue])
        if not hero.m_bIsAir then 
            hero:setMoveUpdatable(true)
        end
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss6_3:process(dt)
    return true
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss6_3:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss6_3:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end


--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss6_3:done()
    WZLog("BattleMsgAssistedBoss6_3:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------

