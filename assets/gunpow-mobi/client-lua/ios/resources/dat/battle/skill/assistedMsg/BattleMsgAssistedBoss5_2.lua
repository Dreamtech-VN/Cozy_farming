-- BattleMsgAssistedBoss5_2.lua
--@brief    召唤聚光灯
--@date     2016/7/6
--@note

--@brief    消息数据表
BattleMsgAssistedBoss5_2 = {
    m_sName = "BattleMsgAssistedBoss5_2.lua",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss5_2:init()
    WZLog("BattleMsgAssistedBoss5_2:init")
    local list = {}
    for i,v in pairs(WBattleGlobal:getCurrent():getMachinesList()) do
        if v.m_nMonsterType == MonsterType.BOSS_LIGHT then
            table.insert(list,v)
        end
    end
    local sortFunc = function(a, b) return b:getBattleId() < a:getBattleId() end
    table.sort(list,sortFunc)
    local bornPosList = {GlobalMethod:ccp(150,936),GlobalMethod:ccp(377,787),GlobalMethod:ccp(615,708),GlobalMethod:ccp(861,790),GlobalMethod:ccp(1090,1004),GlobalMethod:ccp(1311,886)}
    local posList = {}
    for i,pos in ipairs(bornPosList) do
        local isPush = true
        for i,player in pairs(WBattleGlobal:getCurrent():getHeroList()) do
            local playerPos = player:getPosition()
            if BattleCommon:pointDis(pos,playerPos) < 100 then
                isPush = false
                break
            end
        end
        if isPush then
            table.insert(posList,pos)
        end
    end
    local defPos = {x = posList[1].x,y = posList[1].y}
    for i,light in ipairs(list) do
        local index = 0
        if #posList > 0 then
            index = WBattleGlobal:getCurrent():getBattleRandNum() % #posList + 1
           
            local pos = posList[index]
            light:setPosition(pos)
            table.remove(posList,index)
        else
            light:setPosition(defPos)
        end
        SceneBattle:getFrontLayer():addChild(light.m_anim:getAnimNode())
        light:playAppearAction()
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss5_2:process(dt)
    return true
end

--@brief 镜头控制
function BattleMsgAssistedBoss5_2:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss5_2:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss5_2:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss5_2:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss5_2:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss5_2:done()
    WZLog("BattleMsgAssistedBoss5_2:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
