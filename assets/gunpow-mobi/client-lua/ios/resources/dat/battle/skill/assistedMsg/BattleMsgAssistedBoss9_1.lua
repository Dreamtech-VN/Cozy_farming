-- BattleMsgAssistedBoss9_1.lua
--@brief    位移
--@date     2016/10/18
--@note

--@brief    消息数据表
BattleMsgAssistedBoss9_1 = {
    m_sName = "BattleMsgAssistedBoss9_1.lua",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss9_1:init()
    WZLog("BattleMsgAssistedBoss9_1:init")
    local rect = tRect or {x = 500,y = 1335,w = 1200,h = 750}
    
    local left, right, up , down = rect.x, rect.y, rect.w, rect.h

    local randNumber1, randNumber2 = 0, 0
    local x1
    local y1
    if WBattleGlobal:getCurrent().m_tBattleRand and #WBattleGlobal:getCurrent().m_tBattleRand > 0 then
        randNumber1 = WBattleGlobal:getCurrent().m_tBattleRand[1] and WBattleGlobal:getCurrent().m_tBattleRand[1] or math.random(9999)
        randNumber2 = WBattleGlobal:getCurrent().m_tBattleRand[3] and WBattleGlobal:getCurrent().m_tBattleRand[3] or math.random(9999)
    end

    local interval = math.abs(right - left)
    local interval2 = math.abs(up - down)
    x1 = left + randNumber1 % interval
    y1 = down + randNumber2 % interval2
    local randomIndex = WBattleGlobal:getCurrent():getCurRandNum() % 2 + 1
    self.m_tTargetPos = BattleCommon:getPointTable(x1,y1)
    WZLog("BattleMsgAssistedBoss9_1:init",randomIndex,self.m_tTargetPos.y)
    self:getOwner():setPosition(self.m_tTargetPos)
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss9_1:process(dt)
    return true
end

--@brief 镜头控制
function BattleMsgAssistedBoss9_1:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss9_1:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss9_1:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss9_1:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss9_1:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

function BattleMsgAssistedBoss9_1:playOwnerAnim(animName,isLoop)
    local monster = self:getOwner()
    monster:play(monster:getAnimationName(animName), isLoop)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss9_1:done()
    WZLog("BattleMsgAssistedBoss9_1:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
