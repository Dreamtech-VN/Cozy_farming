-- BattleMsgAssistedBoss8_1.lua
--@brief    召唤炎魔
--@date     2016/7/6
--@note

--@brief    消息数据表
BattleMsgAssistedBoss8_1 = {
    m_sName = "BattleMsgAssistedBoss8_1",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss8_1:init()
    WZLog("BattleMsgAssistedBoss8_1:init")
    local list = {}

    for i,v in pairs(self:getOwner().m_tCursummonList) do
        table.insert(list,v)
    end
    local sortFunc = function(a, b) return b:getBattleId() < a:getBattleId() end
    table.sort(list,sortFunc)
    local bornPosList = {GlobalMethod:ccp(315,425),GlobalMethod:ccp(718,413),GlobalMethod:ccp(1038,429)}
   
    for i,monster in ipairs(list) do
        index = WBattleGlobal:getCurrent():getBattleRandNum() % #bornPosList + 1
        local pos = bornPosList[index]
        monster:setPosition(pos)
        table.remove(bornPosList,index)

        WBattleGlobal:getCurrent().m_tGuais[monster:getBattleId()] = monster
        SceneBattle:getFrontLayer():addChild(monster:getAnimation():getAnimNode())
        if monster:getMover() then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(monster:getMover())
        end

        monster:setAppearAttribute()
        monster:play(monster:getAnimationName("standby"), true)

        local effect  = BattleEffect:createAnimation(1006)
        monster:getAnimation():getAnimNode():addChild(effect:getAnimNode())
    end

    self:getOwner():getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 10307}},nil,nil,nil,nil,nil,true)
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss8_1:process(dt)
    return true
end

--@brief 镜头控制
function BattleMsgAssistedBoss8_1:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss8_1:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss8_1:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss8_1:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss8_1:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss8_1:done()
    WZLog("BattleMsgAssistedBoss8_1:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
