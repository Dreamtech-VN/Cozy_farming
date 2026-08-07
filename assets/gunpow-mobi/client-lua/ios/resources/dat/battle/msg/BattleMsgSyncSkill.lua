--BattleMsgSyncSkill.lua
--@brief    同步技能
--@date     2016/04/19
--@note     怪物技能数据同步（要等回合开始消息处理）

--@brief    消息数据表
BattleMsgSyncSkill = {
    m_sName = "BattleMsgSyncSkill",
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgSyncSkill:init()
    WZLog("BattleMsgSyncSkill:init",self.m_nCurrentPlayerId,self.m_nSkillId)
    --怪物回合掉线直接发pass技能
    if self.m_nSkillId == BattleHeroUse.PASS_SKILL_ID then
    	return
    end
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCurrentPlayerId)
    if hero then
        hero:getAI():addSyncActionList(AiActionConfig.SKILL,self.m_nSkillId)
        hero:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = self.m_nSkillId}})
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgSyncSkill:process()
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgSyncSkill:done()
    MsgManager:exchangeBlockMsg("BattleMsgSkillShow",2)
end

-------------------------------------私有方法模块--------------------------------------
