--MapEnenvtTreatTotem.lua
--@brief    治疗图腾
--@date     2016/3/31
--@note 一个人只有存在一个图腾，如需多个 需要设置不同下标 管理创建移除（主要是移除）

--@brief    地图事件数据表
MapEnenvtTreatTotem = {
    ID = 5,      --id
    m_nType = 0,    --类型
    m_sName = "",   --名称
    m_nEffect1 = 0, --效果参数1
    m_nEffect2 = 0, --效果参数2
    m_nEffect3 = 0, --效果参数3
    m_nCharaId = 0, --持有者Id
    m_nCamp = -1,   --阵营

    m_nTimeIntervalValue = nil, --触发间隔
    m_nTimeDurationValue = nil, --持续时间
    m_nTimePassValue = nil, --存在时间（间隔累加计算）
    m_nTakeEffectCount = nil,   --触发次数（间隔累加计算）
    m_nTimePassValueReal = nil, --每回合结束 存在时间 （总ctb换算）
    m_nTakeEffectCountReal = nil, --每回合结束 触发次数（总ctb换算）

    m_anim = nil,                       --动画
}
-------------------------------------公有方法模块--------------------------------------

--@brief    生成一个事件
--@return   #1:事件对象
function MapEnenvtTreatTotem:buildEvent(weatherId, name, effect1, effect2, treatTotemInfo)
    WZLog("MapEnenvtTreatTotem:buildEvent",Serialize(treatTotemInfo))
    local mapEvent = MapEnenvtTreatTotem:new()

    mapEvent.m_nCharaId = treatTotemInfo.charaId
    mapEvent.m_tOwner = WBattleGlobal:getCurrent():getCharacterWithId(mapEvent.m_nCharaId)
    mapEvent.m_nCamp = treatTotemInfo.camp
    mapEvent.m_nSkillId = treatTotemInfo.skillId or 710
    
    mapEvent.m_nTimeIntervalValue = treatTotemInfo.interval or 2000
    mapEvent.m_nTimeDurationValue = treatTotemInfo.duration or 10000
    mapEvent.m_nTimePassValue = 0
    mapEvent.m_nTakeEffectCount = 0
    mapEvent.m_nTimePassValueReal = 0
    mapEvent.m_nTakeEffectCountReal = 0

    mapEvent.m_nType = weatherId
    mapEvent.m_sName = name
    mapEvent.m_nEffect1 = effect1
    mapEvent.m_nEffect2 = effect2

    local animRes = "skill_fsq"

    mapEvent.m_startActName = "hit1"
    mapEvent.m_continueActName = "xunhuan1"
    
    if mapEvent.m_nCamp ~= WBattleGlobal:getCurrent():getMyHero():getCamp() then
        mapEvent.m_startActName = "hit2"
        mapEvent.m_continueActName = "xunhuan2"
    end
    mapEvent.m_anim = nil
    mapEvent.m_anim = BattleAnimation:createAnimation(animRes, false, "battle/skill")
    SceneBattle:getFrontLayer():addChild(mapEvent.m_anim:getAnimNode())
    -- mapEvent.m_anim:setScale(1)

    --设置位置
    local firstPos = treatTotemInfo.bronPos

    SceneBattle.m_nMapEventShow = 1
    mapEvent.m_anim:setPosition(Vector2:create(firstPos.x, firstPos.y))
    mapEvent.m_anim:play(mapEvent.m_startActName)

    WZLog("MapEnenvtTreatTotem:buildEvent",firstPos.x, firstPos.y)
    return mapEvent
end



--@brief    销毁
function MapEnenvtTreatTotem:destroy()
    self:removeInBattle()

    WCharacter.destroy(self)
    if self.m_anim and self.m_anim:getAnimNode() ~= nil and self.m_anim:getAnimNode().removeFromParentAndCleanup ~= nil and self.m_anim:getAnimNode():getParent() ~= nil then

        self.m_anim:getAnimNode():removeFromParentAndCleanup(false)
    end
    WZLog("MapEnenvtTreatTotem:destroy two")

    self.m_anim = nil

    self.m_nType = 0
    self.m_sName = ""
    self.m_nEffect1 = 0
    self.m_nEffect2 = 0
    self.m_nEffect3 = 0
end

--@brief 移出场景
function MapEnenvtTreatTotem:removeInBattle()
    if WBattleGlobal:getCurrent().m_tMapEvents ~= nil and BattleCommon:tableLen(WBattleGlobal:getCurrent().m_tMapEvents) > 0 then
        for i, v in pairs (WBattleGlobal:getCurrent().m_tMapEvents) do
            local event = WBattleGlobal:getCurrent().m_tMapEvents[i]
            if event and event.m_nCharaId == self.m_nCharaId then
                WBattleGlobal:getCurrent().m_tMapEvents[i] = nil
            end
        end
    end
end
--@brief    定时更新函数
--@param    dt:距离上一次调用的时间（秒）
--@note     由定时器调用
function MapEnenvtTreatTotem:update(dt)
    WZLog("MapEnenvtTreatTotem:update")
    if self:getAnimation():isPlaying(self.m_continueActName) == false then
        if self:getAnimation():isCurrentAnimationDone() == true then
            WZLog("MapEnenvtTreatTotem:update=============")
            self:getAnimation():play(self.m_continueActName, true)
        end
    end
end

--@brief ctb刷新
function MapEnenvtTreatTotem:updateByCTBProcess(dt,updateCTB_time)
    WZLog("MapEnenvtTreatTotem:updateByCTBProcess zero", self.m_nTimePassValue,self.m_nTimeDurationValue)
    if dt ~= nil then
        --持续时间计数
        self.m_nTimePassValue = self.m_nTimePassValue + BattleCtbManager.SECOND_PER_CTB * dt
        if updateCTB_time > BattleCtbManager.m_nUpdateCTB_time then
            self.m_nTimePassValue = self.m_nTimePassValue - (updateCTB_time - BattleCtbManager.m_nUpdateCTB_time)
        end

        if self.m_nTimeIntervalValue > -1 and math.floor(self.m_nTimePassValue / self.m_nTimeIntervalValue) > self.m_nTakeEffectCount and self.m_nTakeEffectCount <= self.m_nTimeDurationValue / self.m_nTimeIntervalValue then
            self.m_nTakeEffectCount = self.m_nTakeEffectCount + 1
            self:doEffect()
        end

        if self.m_nTimeDurationValue ~= -1 and self.m_nTimePassValue >= self.m_nTimeDurationValue then
            self:destroy()
        end
    else
        --真实时间换算
        self.m_nTimePassValueReal = self.m_nTimePassValueReal + BattleCtbManager.m_nUpdateCTB_time
        self.m_nTimePassValue = self.m_nTimePassValueReal
        
        if self.m_nTimeIntervalValue > -1 then
            self.m_nTakeEffectCountReal = self.m_nTakeEffectCountReal + (BattleCtbManager.m_nUpdateCTB_time ) / self.m_nTimeIntervalValue
            self.m_nTakeEffectCount = self.m_nTakeEffectCountReal
        end
    end
end

function MapEnenvtTreatTotem:doEffect()
    WZLog("MapEnenvtTreatTotem:doEffect")
    local skillConfig = GDatatab_skill["id_"..self.m_nSkillId]
    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nCharaId)
    -- local targetList = BattleMsgSkillShow.chooseTarget(self,self.m_tBoss,{[1]=skillConfig.choose,[2]=skillConfig.chooseParm[1],[3]=skillConfig.chooseParm[2]})
    local targetList = BattleChooseMethod:chooseTarget(self,{[1]=skillConfig.choose,[2]=skillConfig.chooseParm[1],[3]=skillConfig.chooseParm[2]})
    local targetIds = {}
    for i,v in pairs(targetList) do
        table.insert(targetIds,v:getBattleId())
        --WZLog("WMonsterAI:doAction II",v:getBattleId())
    end
    if WBattleGlobal:getCurrent():isHostControl() then
        ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_nCharaId, self.m_nSkillId,targetIds)
    end

    local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
    msg.m_nId = nil --不发协议
    msg.m_tOwner = self
    msg.m_tSkillTypeList = {[1]=SkillTypeConfig.HIT_DO_EFFECT}
    msg.m_nSkillId = self.m_nSkillId
    msg.m_nTakeEffectType = TakeEffectType.USE
    MsgManager:pushNonBlockMsg(msg)
end

--@brief    事件处理
function MapEnenvtTreatTotem:eventProcess(bulletList, heroList)
    WZLog("MapEnenvtTreatTotem:eventProcess one", #bulletList, #heroList)
end

--@brief    设置当前的位置
--@param    tPos 当前位置
function MapEnenvtTreatTotem:setPosition(tPos)
    self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
end

--@brief    获取当前的位置
--@return   tPos 当前位置
function MapEnenvtTreatTotem:getPosition()
    return self.m_anim:getPosition()
end

--@brief    获取动画控制对象
--@return   #1:BattleAnimation动画控制对象
function MapEnenvtTreatTotem:getAnimation()
    return self.m_anim
end

--@brief    以本表为模版，MapEnenvtTreatTotem表为父表创建一个新的表实例对象
--@return   新建的表实例对象
function MapEnenvtTreatTotem:new()
    setmetatable(MapEnenvtTreatTotem,{__index = WCharacter})
    local tNewObj = {}
    setmetatable(tNewObj, {__index = MapEnenvtTreatTotem})
    tNewObj:setType(CharacterType.TYPE_GUAI)
        tNewObj:_init()
    return tNewObj
end

-------------------------------------私有方法模块--------------------------------------
