--BattleMsgAssistedHitSkill.lua
--@brief    碰撞使用技能
--@date     2015/9/18
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedHitSkill = {
    m_sName = "BattleMsgAssistedHitSkill",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedHitSkill:init()
    WZLog("BattleMsgAssistedHitSkill:init")
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedHitSkill:process(dt)
    return true
end

--@brief 获得技能所有者
function BattleMsgAssistedHitSkill:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedHitSkill:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedHitSkill:done()
    WZLog("BattleMsgAssistedHitSkill:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
