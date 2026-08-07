-- BattleMsgAssistedBoss7_2.lua
--@brief    位移
--@date     2016/10/18
--@note

--@brief    消息数据表
BattleMsgAssistedBoss7_2 = {
    m_sName = "BattleMsgAssistedBoss7_2.lua",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss7_2:init()
    WZLog("BattleMsgAssistedBoss7_2:init")
    self.m_tTargetList = {GlobalMethod:ccp(1586,719),GlobalMethod:ccp(1586,519),GlobalMethod:ccp(1586,919)}
    local curPos = self:getOwnerPos()
    for i = 1,#self.m_tTargetList do
        local pos = self.m_tTargetList[i]
        if BattleCommon:pointDis(pos,curPos) < 10 then
            table.remove(self.m_tTargetList,i)
            break
        end
    end
    local randomIndex = WBattleGlobal:getCurrent():getCurRandNum() % 2 + 1
    self.m_tTargetPos = self.m_tTargetList[randomIndex]
    WZLog("BattleMsgAssistedBoss7_2:init",randomIndex,self.m_tTargetPos.y)
    self.m_tStepPos = BattleCommon:getPointTable((self.m_tTargetPos.x - curPos.x)/10,(self.m_tTargetPos.y - curPos.y)/10)
    self.m_nDis = BattleCommon:pointLen(self.m_tStepPos)
    self:playOwnerAnim("run",true)
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss7_2:process(dt)
    local curPos = self:getOwnerPos()
    if BattleCommon:pointDis(curPos,self.m_tTargetPos) < self.m_nDis*2 then
        self:getOwner():setPosition(self.m_tTargetPos)
         return true
    else
        local tPos = BattleCommon:getPointTable(curPos.x + self.m_tStepPos.x,curPos.y + self.m_tStepPos.y)
        self:getOwner():setPosition(tPos)
         return false
    end
    return true
end

--@brief 镜头控制
function BattleMsgAssistedBoss7_2:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss7_2:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss7_2:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss7_2:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss7_2:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

function BattleMsgAssistedBoss7_2:playOwnerAnim(animName,isLoop)
    local monster = self:getOwner()
    monster:play(monster:getAnimationName(animName), isLoop)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss7_2:done()
    WZLog("BattleMsgAssistedBoss7_2:done")
    --删除粒子
    if self.particle1 then
        self.particle1:removeFromParentAndCleanup(true)
        self.particle1 = nil
    end
    self:playOwnerAnim("standby",true)
  
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
