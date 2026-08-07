--BattleMsgOtherPass.lua
--@brief	战斗相关消息
--@date		2018/9/8
--@author	莫剑峰
--@note		收到别人跳过本轮操作

--@brief	消息数据表
BattleMsgOtherPass = {
    m_sName = "BattleMsgOtherPass",
	m_nBattleId = 0, --战斗id
	m_nPlayerId = 0, --角色id
	m_nPlayerOrGuai = nil, --英雄还是怪物(0:player,1:guai)

    m_tCheckList = {},
    m_bIsAllFalse = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgOtherPass:init()
	WZLog("BattleMsgOtherPass:init",self.m_nPlayerId, self.m_nCurrentPlayerId)

    self.m_tStepFunction = {}
    table.insert(self.m_tStepFunction,self._checkAllCollision)
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgOtherPass:process()
    if #self.m_tStepFunction > 0 then
        local res = self.m_tStepFunction[1](self)
        if res == true or res == nil then
            table.remove(self.m_tStepFunction,1)
        end
        return false
    else
        return true
    end

    return true
end

--@brief    检查全部人是否着地或掉坑或死亡
function BattleMsgOtherPass:_checkAllCollision()
    for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        local _,isHole = hero:checkIsOutOfScene()
        if hero:isDead() ~= true and isHole ~= true and hero:getMover():isCollision() ~= true then
            table.insert(self.m_tCheckList, false)
        else
            table.insert(self.m_tCheckList, true)
        end
    end

    local isAllFalse = true
    for i,v in ipairs(self.m_tCheckList) do
        if v == false then
            isAllFalse = false
        end
    end

    if self.m_bIsAllFalse and isAllFalse then
        return true
    end
    self.m_bIsAllFalse = isAllFalse
    self.m_tCheckList = {}
    
    return false
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgOtherPass:done()
	WZLog("BattleMsgOtherPass:done")

    WndBattleHud:endTurnTime()
    WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),41,nil,nil,true)
end

-------------------------------------私有方法模块--------------------------------------
