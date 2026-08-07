-- BattleMsgAssistedBoss4_1.lua
--@brief    冰刺
--@date     2015/9/15
--@author   zsq
--@note

--@brief    消息数据表
BattleMsgAssistedBoss4_1 = {
    m_sName = "BattleMsgAssistedBoss4_1",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss4_1:init()
    WZLog("BattleMsgAssistedBoss4_1:init")
    self.m_tTargetList = {}
    self.m_tFireList = {}
    local list = WBattleGlobal:getCurrent():getHeroList()
    for i,target in pairs(list) do
		if target:isInBuffState(EffectTypeConfig.LIMIT_ALL_ACTION) then
    		WZLog("BattleMsgAssistedBoss4_1:init two")
        	table.insert(self.m_tTargetList,target)
		end 
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss4_1:process(dt)
	WZLog("BattleMsgAssistedBoss4_1:process",#self.m_tTargetList)
	for i=1,#self.m_tTargetList do
		WZLog("BattleMsgAssistedBoss4_1:process two",i)
		local target = self.m_tTargetList[i]
        local pos = target:getCenterPos()
        local tPos = BattleCommon:getPointTable(pos.x-30,pos.y + 145)
    	self:stoneBoom(target,tPos)
	end
	self.m_tTargetList = {}
    return true
end

function BattleMsgAssistedBoss4_1:stoneBoom(target,tPos)
	WZLog("BattleMsgAssistedBoss4_1:stoneBoom")
    local effectBoom  = BattleEffect:createAnimation(1012)
    effectBoom:setPosition(tPos)
    SceneBattle:getFrontLayer():addChild(effectBoom:getAnimNode(),100)

    self:hurtTarget(target)
    
    --table.remove(self.m_tTargetList,index)
end

function BattleMsgAssistedBoss4_1:hurtTarget(target)
    local monster = self:getOwner()
    local tHurtCharas, tHurtValues, tDistance, tCritType, tHurtRatios = BattleMethod:checkMeleeHurtII(monster,target)
    if BattleCommon:tableLen(tHurtCharas) > 0 then
        BattleMethod:charaAddHurtValue(monster,tHurtCharas,tHurtValues,tHurtRatios)
        BattleMethod:sendHurtProtocol(monster,tHurtCharas, tHurtValues, tDistance, tCritType)
    end
end

--@brief 镜头控制
function BattleMsgAssistedBoss4_1:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss4_1:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss4_1:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss4_1:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss4_1:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss4_1:done()
    WZLog("BattleMsgAssistedBoss4_1:done")
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------
