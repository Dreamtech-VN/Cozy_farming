--BattleMsgAssistedDailyMonsterMove.lua
--@brief    技能表现辅助消息模板表
--@date     2015/9/15
--@author   mbq
--@note

--@brief    消息数据表
BattleMsgAssistedDailyMonsterMove = {
    m_sName = "BattleMsgAssistedDailyMonsterMove",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
   
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedDailyMonsterMove:init()
    
    local targetPosList = {}

    local i = WBattleGlobal:getCurrent().m_nFlyCopyIndex
    local info = CopyTable(GDatatab_train_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_train_map["id_1011"]).monster
    WZLog("BattleMsgAssistedDailyMonsterMove:init1",i, Serialize(info))
    if info[i] then
        targetPosList = {BattleCommon:getPointTable(info[i][2],info[i][3])}
        WBattleGlobal:getCurrent().m_nFlyCopyIndex = WBattleGlobal:getCurrent().m_nFlyCopyIndex + 1
        WZLog("BattleMsgAssistedDailyMonsterMove:init2", i, info[i][2], info[i][3])

        local monster = self:getOwner()
        local index = 1
        monster:setPosition(targetPosList[index])    
    end
    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.TRAIN_COPY_FLY,nil)
end



--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedDailyMonsterMove:process(dt)
    return true
end



--@brief 镜头控制
function BattleMsgAssistedDailyMonsterMove:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedDailyMonsterMove:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedDailyMonsterMove:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedDailyMonsterMove:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

function BattleMsgAssistedDailyMonsterMove:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedDailyMonsterMove:done()
   WZLog("BattleMsgAssistedDailyMonsterMove:done")
   self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
