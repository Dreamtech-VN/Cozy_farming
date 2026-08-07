-- BattleMsgAssistedBoss5_1.lua
--@brief    召唤道具
--@date     2016/7/6
--@note

--@brief    消息数据表
BattleMsgAssistedBoss5_1 = {
    m_sName = "BattleMsgAssistedBoss5_1.lua",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss5_1:init()
    WZLog("BattleMsgAssistedBoss5_1:init")
    local list = {}
    for i,v in pairs(WBattleGlobal:getCurrent():getMachinesList()) do
        if v.m_nMonsterType == MonsterType.BOSS_GIFT and not v.m_anim.m_running then
            table.insert(list,v)
        end
    end
    local sortFunc = function(a, b) return b:getBattleId() < a:getBattleId() end
    table.sort(list,sortFunc)

    local bornPosList = {}
    for i = 1,#WBattleGlobal:getCurrent().bornPosList do
        table.insert(bornPosList,GlobalMethod:ccp(WBattleGlobal:getCurrent().bornPosList[i][1],WBattleGlobal:getCurrent().bornPosList[i][2]))
    end
    
    local offIndex = {}
    -- [150,936]&[377,787]&[615,708]&[861,790]&[1090,1004]&[1311,886]
    local offPos = {GlobalMethod:ccp(150,936),GlobalMethod:ccp(377,787),GlobalMethod:ccp(615,708),GlobalMethod:ccp(861,790),GlobalMethod:ccp(1090,1004),GlobalMethod:ccp(1311,886)}
    for i,pos in ipairs(offPos) do
        local isPush = false
        for k,player in pairs(WBattleGlobal:getCurrent():getCharacterList()) do
            local playerPos = player:getPosition()
            if BattleCommon:pointDis(pos,playerPos) < 100 then
                isPush = true
                break
            end
        end
        if isPush then
            table.insert(offIndex,i)
        end
    end

    local posList = {}
    for i = 1 ,#bornPosList do
        local canBornPos = true
        for k ,v in pairs(offIndex) do
            if i == v then
                canBornPos = false
                break
            end
        end
        if canBornPos then
            table.insert(posList,bornPosList[i])
        end
    end
    local defPos = {x = bornPosList[1].x,y = bornPosList[1].y}
    for i,gift in ipairs(list) do
        local index = 0
        if #posList > 0 then
            index = WBattleGlobal:getCurrent():getBattleRandNum() % #posList + 1
           
            local pos = posList[index]
            gift:setPosition(pos)
            table.remove(posList,index)
        else
            gift:setPosition(defPos)
        end
        SceneBattle:getFrontLayer():addChild(gift.m_anim:getAnimNode())
        self.m_tSkillShowMsg:playSound("xiaochoulihe")
        gift:playAppearAction()
        if gift:getMover() then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(gift:getMover())
        end
        gift:setMoveUpdatable(true)
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss5_1:process(dt)
    return true
end

--@brief 镜头控制
function BattleMsgAssistedBoss5_1:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss5_1:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss5_1:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss5_1:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss5_1:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss5_1:done()
    WZLog("BattleMsgAssistedBoss5_1:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
