--BattleMsgAssistedBoss4_3.lua
--@brief    召唤分身
--@date     2015/09/15
--@author   zsq

--@brief    消息数据表
BattleMsgAssistedBoss4_3 = {
    m_sName = "BattleMsgAssistedBoss4_3",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    --目标点
    m_tBornPosTab = nil,
    m_nBuildCount = nil,
    m_nBuildDeltaTime = nil,
    m_tFlywheelList = nil,
    m_tMoveInfoList = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss4_3:init()
    WZLog("BattleMsgAssistedBoss4_3:init")

	--关闭对话框
	self:getOwner().m_tDialog:removeDialog(true)

	--把boss设置为满血
	self:getOwner():getAnimation():getAnimNode():setVisible(false)
	local bossHp = self:getOwner():getHp()
	local bossMaxHp = self:getOwner():getMaxHp()
	local boss = self:getOwner()
	-- boss.m_nMaxHP_bak = bossMaxHp
	-- boss:setMaxHp(bossHp)
	-- if boss.m_tBossName ~= nil and boss.m_tBossName.m_hp ~= nil then
 --    	boss.m_tBossName.m_hp:setPercentage(100)
	-- end

    local pos = self:getOwnerPos()
    local flix = 1
    if pos.x < 500 then
        flix = -1
    end
    self.m_tBornPosTab = {}
    table.insert(self.m_tBornPosTab,{x = 250,y = 850})
    table.insert(self.m_tBornPosTab,{x = 900,y = 1100})
    table.insert(self.m_tBornPosTab,{x = 1500,y = 850})

	self:getOwner():getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 10309}},nil,nil,nil,nil,nil,true)
	self:getOwner():getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 10307}},nil,nil,nil,nil,nil,true)
	self:getOwner():clearAllBuff()

	--随机设置boss位置
	--local randomIndex = math.random(3)
    local nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes()
    local randNumIndex = nTurnTimes % 10 + 1
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
	local randomIndex = randNumList[randNumIndex] % 3 + 1

	self:getOwner():setPosition(self.m_tBornPosTab[randomIndex])
	--self:getOwner():setVisible(true)
	self:getOwner():getAnimation():getAnimNode():setVisible(true)
	table.remove(self.m_tBornPosTab,randomIndex)

    self.m_nBuildCount = 1
    self.m_nBuildDeltaTime = 0
    self.m_tFlywheelList = {}
    self.m_tMoveInfoList = {}

    -- for i = 1,20 do
        -- WZLog("BattleMsgAssistedBoss4_3:pass")
        -- ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self:getOwner():getBattleId(), 1002)
    -- end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss4_3:process(dt)
    local isDone = true
    if self.m_nBuildCount <= #self:getOwner().m_tOwnedMonsterList then
        self.m_nBuildDeltaTime = self.m_nBuildDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
        if self.m_nBuildDeltaTime > 0.4 or #self.m_tFlywheelList == 0 then
            self:buildFlywheel()
            self.m_nBuildCount = self.m_nBuildCount + 1
        end
        isDone = false
    end


    return isDone
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss4_3:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss4_3:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 创建分身
function BattleMsgAssistedBoss4_3:buildFlywheel()
    WZLog("BattleMsgAssistedBoss4_3:buildFlywheel", self.m_nBuildCount, #self:getOwner().m_tOwnedMonsterList)
	--local bossHp = self:getOwner():getHp()
	--local bossMaxHp = self:getOwner():getMaxHp()
	--local rate = bossMaxHp / bossHp
    local body = self:getOwner().m_tOwnedMonsterList[self.m_nBuildCount]
    local pos = self.m_tBornPosTab[self.m_nBuildCount]
    body:setPosition(pos)
	--local maxHp = body:getMaxHp()
	--body:setMaxHp(maxHp*rate)
    SceneBattle:getFrontLayer():addChild(body:getAnimation():getAnimNode(),1)
    WBattleGlobal:getCurrent().m_tGuais[body:getBattleId()] = body
    if body:getMover() then
        WBattleGlobal:getCurrent().m_battleManager:addEntity(body:getMover())
    end
    body:setAppearAttribute()
    body:play(body:getAnimationName("wait"), true)
    --self:createBornEffect(body)
    table.insert(self.m_tFlywheelList,body)
end

--@brief 创建效果
function BattleMsgAssistedBoss4_3:createBornEffect(wheel)
    local effect  = BattleEffect:createAnimation(1001)
    wheel:getAnimation():getAnimNode():addChild(effect:getAnimNode())
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss4_3:done()
    WZLog("BattleMsgAssistedBoss4_3:done")
	--打乱头像顺序
	BattleCtbManager:randomTag()
    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------


