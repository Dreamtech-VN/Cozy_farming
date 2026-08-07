--BattleMsgAssistedLib.lua
--@brief    技能表演辅助消息库
--@date     2015/09/15
--@author   mbq

--@brief    数据表
BattleMsgAssistedLib = {
    m_sName = "BattleMsgAssistedLib",
}

-------------------------------------公有方法模块Begin--------------------------------------
function BattleMsgAssistedLib:createAssisted(tSkillShowMsg,nMsgId,param1,param2)
    WZLog("BattleMsgAssistedLib:createAssisted",nMsgId)
    local msg = nil
    --@101 - 199创建碰撞触发技能
    --@201 - 209位移
    --@大于10000 特殊表演
    if nMsgId == 1 then
        msg = MsgManager:createMsg(BattleMsgAssistedMove)
    elseif nMsgId == 2 then
        msg = MsgManager:createMsg(BattleMsgAssistedSelfBoom)
        msg.m_nBoomFlashId = param1
        msg.m_bHurt = true
    elseif nMsgId == 3 then
        msg = MsgManager:createMsg(BattleMsgAssistedSelfBoom)
        msg.m_nBoomFlashId = param1
        msg.m_bHurt = false
    elseif nMsgId == 4 then
        msg = MsgManager:createMsg(BattleMsgAssistedMonsterFly)
    elseif nMsgId == 5 then
        msg = MsgManager:createMsg(BattleMsgAssistedMove)
        msg.m_bIsNearPlayer = true
    elseif nMsgId == 10 then
        msg = MsgManager:createMsg(BattleMsgAssistedMeleeHurt)
    elseif nMsgId == 101 then
        msg = MsgManager:createMsg(BattleMsgAssistedHitSkill)
    elseif nMsgId == 201 then
        msg = MsgManager:createMsg(BattleMsgAssistedParaMoveTo)
        msg.m_tTargetPos = BattleCommon:getPointTable(param1[1][1],param1[1][2])
        msg.m_nSpeed = param2
        msg.m_bIsBackFire = true
    elseif nMsgId == 202 then
        --跳跃攻击
        local targetHero = tSkillShowMsg.m_tTargetList[1] or tSkillShowMsg.m_tOwner
        local targetPos = targetHero:getPosition()
        msg = MsgManager:createMsg(BattleMsgAssistedParaMoveTo)
        msg.m_tTargetPos = BattleCommon:getPointTable(targetPos.x,targetPos.y + 30)
    elseif nMsgId == 203 then
        msg = MsgManager:createMsg(BattleMsgAssistedNearAttackOrder)
    --组队boss2
    elseif nMsgId == 2001 then
        msg = MsgManager:createMsg(BattleMsgAssistedFlywheelBuild)
    elseif nMsgId == 2002 then
        msg = MsgManager:createMsg(BattleMsgAssistedFlywheelAttack)
    --组队boss3
    elseif nMsgId == 1301 then
        msg = MsgManager:createMsg(BattleMsgAssistedTeamBossCOrder)
    --世界boss
    elseif nMsgId == 10002 then
        msg = MsgManager:createMsg(BattleMsgAssistedAirStone)
    --组队boss4
    elseif nMsgId == 10003 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss4_1)
    elseif nMsgId == 10004 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss4_2)
    elseif nMsgId == 10005 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss4_3)
    --组队boss5    
    elseif nMsgId == 1501 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss5_1)
    elseif nMsgId == 1502 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss5_2)
    elseif nMsgId == 1503 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss5_3)
    --组队boss6
    elseif nMsgId == 1601 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss6_3)
    elseif nMsgId == 1604 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss6_1)
    elseif nMsgId == 1613 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss6_2)
    --组队boss7
    elseif nMsgId == 1701 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss7_1)
    elseif nMsgId == 1702 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss7_2)
    --组队boss8
    elseif nMsgId == 1804 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss8_2)
    elseif nMsgId == 1805 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss8_1)

    --组队boss9
    elseif nMsgId == 1905 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss9_1)
    elseif nMsgId == 1906 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss9_2)

     --组队boss10
    elseif nMsgId == 2104 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss10_4)
    elseif nMsgId == 2106 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss10_1)
    elseif nMsgId == 2108 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss10_2)
    elseif nMsgId == 2110 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss10_3)
    elseif nMsgId == 2201 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss11_1)
    elseif nMsgId == 2202 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss11_2)
    elseif nMsgId == 2203 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss11_3)
    elseif nMsgId == 2205 then
        msg = MsgManager:createMsg(BattleMsgAssistedBoss11_4)
        msg.m_bIsNearPlayer = true
    elseif nMsgId == 3000 then
        msg = MsgManager:createMsg(BattleMsgAssistedSkinBigSkill)
        msg.m_tSkillShowMsg = tSkillShowMsg
        msg.m_tTargetPos = tSkillShowMsg.m_tEndPos
        MsgManager:pushNonBlockMsg(msg)
        return true
    elseif nMsgId == 3001 then
        msg = MsgManager:createMsg(BattleMsgAssistedSkinBigSkill2)
        msg.m_tSkillShowMsg = tSkillShowMsg
        msg.m_tSpatterTargetList = tSkillShowMsg.m_tSpatterTargetList
        msg.m_tActiveAttackPos = tSkillShowMsg.m_tActiveAttackPos
        MsgManager:pushNonBlockMsg(msg)
        return true
    --日常经验副本
    elseif nMsgId == 20001 then
        msg = MsgManager:createMsg(BattleMsgAssistedDailyCopyOrder)
    elseif nMsgId == 20003 then
        msg = MsgManager:createMsg(BattleMsgAssistedDailyMonsterMove)
    elseif nMsgId == 30001 then
        msg = MsgManager:createMsg(BattleMsgAssistedWeddedBossCOrder)
    end
    if msg then 
        msg.m_tSkillShowMsg = tSkillShowMsg
        tSkillShowMsg.m_tOwner:getAI():pushMonsterMsg(msg,false)
        -- MsgManager:pushNonBlockMsg(msg)
        return true
    end
    return false
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
