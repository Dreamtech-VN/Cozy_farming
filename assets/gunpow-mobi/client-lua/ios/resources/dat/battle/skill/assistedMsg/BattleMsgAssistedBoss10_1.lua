-- BattleMsgAssistedBoss10_1.lua
--@brief    毒雾喷射
--@date     2016/10/18
--@note

--@brief    消息数据表
BattleMsgAssistedBoss10_1 = {
    m_sName = "BattleMsgAssistedBoss10_1.lua",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
    m_tTargetHero = nil,
    m_nBuffId = nil
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss10_1:init()
    WZLog("BattleMsgAssistedBoss10_1:init")
   
    self.m_bShootEnd = false
    self.m_tBulletList = {}
    self.m_tStepList = {}
    self.m_tTargetHero = nil
    self.m_nBuffId = 7016
    for id, character in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
        if not character:isDead() then
            local inBuff = character:isInBuffById(self.m_nBuffId)
            if inBuff then
                self.m_tTargetHero = character
                WZLog("BattleMsgAssistedBoss10_1:init-one")
                break
            end
        end
    end
    
    if not self.m_tTargetHero then
        self.m_tTargetHero =  WMonster:getRandomPlayer()
    end
    local heroPos = self.m_tTargetHero:getPosition()
    local ownerPos = self:getOwnerPos()
    if heroPos.x <  ownerPos.x then
        self.m_nStartX = heroPos.x
        self.m_nEndX = ownerPos.x
    else
        self.m_nStartX = ownerPos.x
        self.m_nEndX = heroPos.x
    end

    local direct = DirectionType.LEFT
      
    if heroPos.x < ownerPos.x then
        direct = DirectionType.LEFT
    else
        direct = DirectionType.RIGHT
    end
    self.m_tSkillShowMsg:updateFlipX(direct)
end


--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss10_1:process(dt)
    self:makeHurt()
    return true
end


function BattleMsgAssistedBoss10_1:makeHurt()
    local targetList = {}
    local list = WBattleGlobal:getCurrent():getHeroSortList()
    for i,target in pairs(list) do
        if not target:isDead() and target:getPosition().x >= self.m_nStartX  and target:getPosition().x <= self.m_nEndX  then
            table.insert(targetList,target)
        end
    end
    BattleMethod:waitForSkillHurt(self:getOwner(),targetList)
end

--@brief    更新屏幕(主要是屏幕震动)
function BattleMsgAssistedBoss10_1:updateScene()
    if self.m_tScreenSpring ~= nil then
        if BattleScreen:screenSpring() == true then
            self.m_tScreenSpring = nil
        end
        return true
    end
    return false
end

--@brief    设置屏幕震动
--@param    tPos:震动时的位置
function BattleMsgAssistedBoss10_1:setSceneSpring(tPos)
    if self.m_tScreenSpring then
        return
    end
    self.m_tScreenSpring = {x=tPos.x,y=tPos.y}
    BattleScreen:setSpring(self.m_tScreenSpring)
end


function BattleMsgAssistedBoss10_1:playOwnerAnim(animName,isLoop)
    local monster = self:getOwner()
    monster:play(monster:getAnimationName(animName), isLoop)
end

--@brief 镜头控制
function BattleMsgAssistedBoss10_1:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss10_1:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss10_1:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss10_1:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss10_1:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss10_1:done()
    WZLog("BattleMsgAssistedBoss10_1:done")
    if self.m_tTargetHero and not self.m_tTargetHero:isDead() then
        WBattleGlobal:getCurrent():removeHeroBuffById(self:getOwner():getBattleId(),self.m_tTargetHero,self.m_nBuffId)
    end
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
