--WBattleMachineMaritime3Totem.lua
--@brief    场景机关
--@date     2021/12/16
--@note     海洋领域减益扣血

WBattleMachineMaritime3Totem = {
    m_tAniFileIndex = nil,  --配置id
    m_tConfig = nil,    --配置
    m_nBattleId = nil,   --战场唯一id
    m_bCheckHurt = nil,  --检查伤害
    m_anim = nil,   --形象
    m_mover = nil,  --移动管理者
    m_tCollisionRang = nil, --碰撞区域
    m_bIsShowRang = false,  --是否显示碰撞区域
    m_tCollisionTable = nil,    --显示的碰撞框
    m_bAutoStandAction = true,  --自动切换待机

    m_nTimeIntervalValue = nil, --触发间隔
    m_nTimeDurationValue = nil, --持续时间
    m_nTimePassValue = nil, --存在时间（间隔累加计算）
    m_nTakeEffectCount = nil,   --触发次数（间隔累加计算）
    m_nTimePassValueReal = nil, --每回合结束 存在时间 （总ctb换算）
    m_nTakeEffectCountReal = nil, --每回合结束 触发次数（总ctb换算）
    m_nTimePassValueOther = nil, --每回合结束存在时间

   m_nDistance = 100,   --作用距离
   m_nBuffId = 1161,--对应buffId
   m_nBuffLv = 1, --对应buff等级
   m_nScale = 1,  --缩放
   m_nBaseWidth = 310, --火圈的资源大小

   m_nCheckTick = nil,
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function WBattleMachineMaritime3Totem:new(battleId,templateId,camp,bronPos, userAttack)
    WZLog("WBattleMachineMaritime3Totem:new",battleId,templateId,camp)
    -- WBattleGlobal:getCurrent():setBuildMonsterRecord(battleId,templateId)
    setmetatable(WBattleMachineMaritime3Totem,{__index = WCharacter})
    local tNewObj = {}
    setmetatable(tNewObj, { __index = WBattleMachineMaritime3Totem })
    tNewObj.m_nBattleId = battleId
    tNewObj.m_nPlayerId = templateId
    tNewObj.m_nCamp = camp
    tNewObj.m_bIsInCtb = false--不参与ctb轮转
    
    tNewObj.m_tAniFileIndex =  "machine_1017"
    --伤害几爽基础相关属性
    tNewObj:parseMonsterData()
    tNewObj.m_bOffCollision = true --不参与子弹碰撞计算
    WBattleGlobal:getCurrent().m_tCharacterAttributeList[tNewObj.m_nBattleId] = {battleId=tNewObj.m_nBattleId, atk=userAttack}

    tNewObj.m_nDistance = tNewObj.m_tSkillParam ~= -1 and tNewObj.m_tSkillParam[1][2] or 100
    tNewObj.m_nTimeDurationValue = tNewObj.m_tSkillParam ~= -1 and tNewObj.m_tSkillParam[1][1] or 10000
    tNewObj.m_nBuffId = tNewObj.m_tSkillParam ~= -1 and tNewObj.m_tSkillParam[1][3] or 1 
    local buffInfo = GDatatab_buff["id_"..tNewObj.m_nBuffId]
    tNewObj.m_nBuffLv = buffInfo.buff_level
    tNewObj.m_nScale = tNewObj.m_nDistance/tNewObj.m_nBaseWidth

    tNewObj.m_nTimePassValue = 0
    tNewObj.m_nTakeEffectCount = 0
    tNewObj.m_nTimePassValueReal = 0
    tNewObj.m_nTakeEffectCountReal = 0
    tNewObj.m_nTimePassValueOther = 0


    tNewObj.m_bActiveAttack = false
    tNewObj.m_bPassiveAttack = false
    tNewObj.m_tActiveSkillList = {}
    tNewObj.m_tPassiveSkillList = {}
    --设置当前方向向左
    tNewObj.m_nCurDirect = 0
    tNewObj.m_nCheckTick = 5

    tNewObj:_init()
    local firstPos = bronPos or {x = 900,y = 800}
    tNewObj:setPosition(Vector2:create(firstPos.x, firstPos.y))

    return tNewObj
end

--@brief 获取buffId
function WBattleMachineMaritime3Totem:getBuffInfo()
    return self.m_nBuffId,self.m_nBuffLv,self.m_nBattleId,self:getLeftCTB(),self.m_nMonsterType
end

--@brief 获得配置id
function WBattleMachineMaritime3Totem:getAniFileIndex()
    return self.m_tAniFileIndex
end

--@brief 道具刷新
function WBattleMachineMaritime3Totem:update(dt)
    if self:isDead() then
        self:updateDeadAct()
        return
    end

    WCharacter.update(self,dt)

    if self:getAnimation():isCurrentAnimationDone() == true and self.m_bAutoStandAction then
        self:getAnimation():play(self:getNormalAnimationName(), true)
    end
end

--@brief ctb刷新
function WBattleMachineMaritime3Totem:updateBuffByCTB(dt, updateCTB_time, runCount)
    if self:isDead() then
        return
    end
    
    WCharacter.updateBuffByCTB(self,dt,updateCTB_time)
    if dt ~= nil then
        --持续时间计数
        self.m_nTimePassValue = self.m_nTimePassValue + BattleCtbManager.SECOND_PER_CTB * dt
        if updateCTB_time > BattleCtbManager.m_nUpdateCTB_time then
            self.m_nTimePassValue = self.m_nTimePassValue - (updateCTB_time - BattleCtbManager.m_nUpdateCTB_time)
        end

        if self.m_nTimeDurationValue ~= -1 and self.m_nTimePassValue >= self.m_nTimeDurationValue then
            self:doSuicide()
        end
    else
        --真实时间换算
        self.m_nTimePassValueReal = self.m_nTimePassValueReal + BattleCtbManager.m_nUpdateCTB_time
        self.m_nTimePassValue = self.m_nTimePassValueReal
    end

    if runCount == 1 then
        self.m_nTimePassValueOther = self.m_nTimePassValueOther + BattleCtbManager.m_nUpdateCTB_time
    end
end

--@brief 剩余ctb
function WBattleMachineMaritime3Totem:getLeftCTB()
    local duration = self.m_nTimeDurationValue - self.m_nTimePassValueOther
    if duration < 0 then
        duration = 0
    end
    return duration
end

--@brief    初始化基础动画
function WBattleMachineMaritime3Totem:initAnim()
    WZLog("WBattleMachineMaritime3Totem:initAnim")
    local scale = self:getAnimScale()
    local anim = nil
    --初始化动画
    local isSpine = self:getConfig().isSpine or false

    if isSpine then
        --动画控制对象
        anim = BattleAnimation:createAnimation(self:getConfig().aniFileId or self.m_tAniFileIndex, false,"battle/monster")
    else
        --动画控制对象
        anim = BattleAnimation:createAnimation(self:getConfig().aniFileId or self.m_tAniFileIndex, true)
    end
    --动画控制对象
    anim:getAnimNode():retain()
    anim:setScale(scale)

    self.m_anim = anim  
    
    if self:getConfig().isMapCollision == true then
        self:setMover()
    end
    self:changeRectCollision()

    self:getAnimation():play(self:getAnimationName("skill"),false)
end

--@brief 设置碰撞
function WBattleMachineMaritime3Totem:setMover()
    --小怪Mover
    self.m_mover = WDMoveEntity:create(self:getAnimation():getAnimNode())
    self.m_mover:setAdjustChild(true)
    self.m_mover:retain()

    local center = Vector2:create(0,50)
    self.m_mover:setMoverCenter(center)
    self.m_mover:setMoverRadius(10)
end

--@brief    获取缩放系数
function WBattleMachineMaritime3Totem:getScale()
    return self.m_anim:getScale()
end

--@brief    设置缩放系数
function WBattleMachineMaritime3Totem:setScale(scale)
    self.m_anim:setScale(scale)
end


--@brief    获取移动控制对象
--@return   #1:WDMove移动控制对象
function WBattleMachineMaritime3Totem:getMover()
    return self.m_mover
end

--@brief 获取形象名字
function WBattleMachineMaritime3Totem:getAnimationName(index)
    return self.animNormal[index] or self.animNormal["standby"]
end

--@brief 获取形象
function WBattleMachineMaritime3Totem:getAnimation()
    return self.m_anim
end

function WBattleMachineMaritime3Totem:getAnimScale()
    return self:getConfig().scale and self:getConfig().scale or self.m_nScale
end

--@brief    添加碰撞矩形
function WBattleMachineMaritime3Totem:changeRectCollision()
    local rectCollisionConfig = self:getConfig().rectCollision
    if not rectCollisionConfig then
        return
    end

    local size = self.m_anim:getAnimNode():getContentSize()
    local centerPos = self:getCenterPos()

    local config = self:getConfig()
    local scale = self:getAnimScale()
    if rectCollisionConfig then 
        for i, info in pairs (rectCollisionConfig)do
            self:addRectCollision(info.width * scale, info.height * scale,info.x * scale, info.y * scale)
            WZLog("WBattleMachineMaritime3Totem:changeRectCollision two", info.width, info.height,info.x, info.y, scale)
        end
    end
end

--@brief    添加矩形碰撞范围
--@param    width,height:宽高
--@param    xOffset,yOffset:x,y偏移量
--@note     偏移量的参考点是character的中心点
function WBattleMachineMaritime3Totem:addRectCollision(width,height,xOffset,yOffset)
    if self.m_tCollisionRang == nil then
        self.m_tCollisionRang = {}
    end

    local tRang = CollisionRang:new()
    tRang.m_nType = 0
    tRang.m_fRadius = width/2
    -- tRang.m_fWidth = width
    -- tRang.m_fHeight = height
    tRang.m_fXOffset = xOffset
    tRang.m_fYOffset = yOffset
    table.insert(self.m_tCollisionRang,tRang)
end



--@brief 获取中心点
function WBattleMachineMaritime3Totem:getCenterPos()
    local moverCenter = {x=0,y=0}
    if self:getMover() ~= nil then
        moverCenter.x = self:getMover():getMoverCenter().x
        moverCenter.y = self:getMover():getMoverCenter().y
    end
    local anchor = self:getAnimation():getAnimNode():getAnchorPoint()
    local size = self:getAnimation():getAnimNode():getContentSize()
    local heroCenter = CCPointMake(moverCenter.x + anchor.x*size.width, moverCenter.y + anchor.y*size.height)

    local toParentTranf = self:getAnimation():getAnimNode():nodeToParentTransform()
    heroCenter=CCPointApplyAffineTransform(heroCenter,toParentTranf)
    return heroCenter
end

--@brief    获得当前的位置
--@return   #1, 返回当前的位置
function WBattleMachineMaritime3Totem:getPosition()
    if not self.m_anim then
        return GlobalMethod:ccp(0,0)
    end
    return self.m_anim:getPosition()
end

--@brief    设置当前的位置
--@param    tPos 当前位置
function WBattleMachineMaritime3Totem:setPosition(tPos)
    if self.m_mover ~= nil then
        self.m_mover:setMoverPosition(Vector2:create(tPos.x,tPos.y))
    end
    if self.m_anim ~= nil then
        self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
    end
end

--@brief 
function WBattleMachineMaritime3Totem:setRotation(rota)
    if self.m_anim then
        self.m_anim:getAnimNode():setRotation(rota)
    end
end

--@brief 
function WBattleMachineMaritime3Totem:getRotation(rota)
    if self.m_anim then
        return self.m_anim:getAnimNode():getRotation()
    end
    return 0
end

--@brief 获取配置
function WBattleMachineMaritime3Totem:getConfig()
    if not self.m_tConfig then
        WZLog("WBattleMachineMaritime3Totem:getConfig",self.m_tAniFileIndex)
        local config = BattleMachineConfig[self.m_tAniFileIndex]
        self.m_tConfig = config
        self.m_tbulletPosOffset = config.bulletPosOffset or {x=0,y=0}
    end
    
    return self.m_tConfig
end

--@brief    获取对象类型
--@return   #1:对象类型(0:player,1:guai)
function WBattleMachineMaritime3Totem:getType()
    return 100
end

--@brief    获取子弹碰撞半径
--@return   #1:子弹碰撞半径
function WBattleMachineMaritime3Totem:getRadiusForBulletCollision()
    return 0
end

--@brief    获得碰撞范围
--@return   #1:碰撞范围
function WBattleMachineMaritime3Totem:getCollisionRang()
    return self.m_tCollisionRang
end

--@brief 射击点
function WBattleMachineMaritime3Totem:getShootPos(target)
    local targetHero = target

    local eOffset = BattleCommon:getPointTable(target.m_anim:getAnimNode():getContentSize().width * 0, target.m_anim:getAnimNode():getContentSize().height * 0.3)
    local sPos = BattleCommon:getPointTable(self:getPosition().x, self:getPosition().y + 10)
    local ePos = BattleCommon:getPointTable(target:getPosition().x + eOffset.x,target:getPosition().y + eOffset.y)

    --炮弹发射位置和角度修正
    if ePos.x <= sPos.x then
        sPos = BattleCommon:getShootPos(true, self)
    else
        sPos = BattleCommon:getShootPos(false, self)
    end

    return sPos,ePos
end

--@brief
--@return
function WBattleMachineMaritime3Totem:getAutoStandAction()
    return self.m_bAutoStandAction
end

--@brief 设置自动切换待机动画
--@return
function WBattleMachineMaritime3Totem:setAutoStandAction(val)
    self.m_bAutoStandAction = val
end

--@brief    获取待机动画
function WBattleMachineMaritime3Totem:getNormalAnimationName()
    return self:getAnimationName("standby")
end

--@brief    获取受伤动画
function WBattleMachineMaritime3Totem:getHurtAnimationName()
    return self:getAnimationName("hurt")
end

--@brief    获取死亡动画
function WBattleMachineMaritime3Totem:getDeadAnimationName()
    return self:getAnimationName("dead")
end

--@brief 设置死亡
function WBattleMachineMaritime3Totem:setDead(bDead, note)
    WZLog("WBattleMachineMaritime3Totem:setDead one", tostring(note))
    if self.m_bIsDead ~= bDead then
        self.m_bIsDead = bDead
    else
        return
    end
    if self.m_bIsDead then
         if WBattleGlobal:getCurrent():isSingleStage() then
            self:setServerDead(true)
        end
        WCharacter.clearAllBuff(self)
        self:getAnimation():play(self:getAnimationName("dead"),false)
    else
        self:getAnimation():play(self:getAnimationName("standby"),true)
    end

    WBattleGlobal:getCurrent():checkHurtBuffTotem(MonsterType.MARITIME3_TOTEM)
end

--@brief 自杀
function WBattleMachineMaritime3Totem:doSuicide()
    self:setDead(true,"doSelfKill")
    --地图buff检测
    -- WBattleGlobal:getCurrent():setHoldMonsterRecord(self.m_nBattleId)
    if WBattleGlobal:getCurrent():isSingleStage() then
        self:setServerDead(true)
    else
        if WBattleGlobal:getCurrent():isHostControl() then
            ProtocolProcessorBattleInterface:send_BATTLE_OutOfScene(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self:getBattleId() ,WBattleGlobal:getCurrent():getCurrentCharacterId())
        end
    end
end

--@brief 获取死亡标记
function WBattleMachineMaritime3Totem:isDead()
    return self.m_bIsDead
end

--@brief 死亡过程
function WBattleMachineMaritime3Totem:updateDeadAct()
    if self:isServerDead() then
        WZLog("WBattleMachineMaritime3Totem:updateDeadAct")
        WBattleGlobal:getCurrent():removeMachine(self.m_nBattleId)
    end
end
--@--brief wbattleglobal调用
function WBattleMachineMaritime3Totem:destroy()
    WZLog("WBattleMachineMaritime3Totem:destroy")
    if self:getAnimation():getAnimNode() then
        self:getAnimation():getAnimNode():removeFromParentAndCleanup(false)
        WZLog("WBattleMachineMaritime3Totem:release")
        self:getAnimation():getAnimNode():release()
    end

    if WBattleGlobal:getCurrent().m_battleManager ~= nil and  self.m_mover then
        WBattleGlobal:getCurrent().m_battleManager:removeEntity(self.m_mover)
    end

    if self.m_mover then
        self.m_mover:release()
        self.m_mover = nil
    end

    self.m_tAniFileIndex = nil
    self.m_tConfig = nil
    self.m_nBattleId = nil
    self.m_anim = nil
    self.m_tOwner = nil
    self.m_mover = nil
    self.m_tCollisionRang = nil
    self.m_bIsShowRang = nil
    self.m_tCollisionTable = nil
end


--@brief    获取中心位置
--@return   #1:中心位置
function WBattleMachineMaritime3Totem:getCenterPos()
   return self:getPetAttackPos()
end

function WBattleMachineMaritime3Totem:getPetAttackPos()
    local size = self:getConfig().animSize
    do
        local offsetH = size.height* 0.5
        return {x=self:getPosition().x,y=self:getPosition().y}
    end

end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief    初始化对象
function WBattleMachineMaritime3Totem:_init()
    WCharacter._init(self)

    self:_setAnimConfig()
    self:initAnim()
    self.m_bIsShowRang = true
end

--@brief 解析动画名字
function WBattleMachineMaritime3Totem:_setAnimConfig()
    local animationInfo = self:getConfig()["animNormal"]
    self.animNormal = {}
    if animationInfo ~= nil then
        local animationInfoList = SplitStringWithSeparator(animationInfo, "|")
        for id, info in pairs(animationInfoList) do
            StringIntsertToTable(self.animNormal,info)
        end
    end
end

function WBattleMachineMaritime3Totem:checkBuffTotemCollison()
    local tHeroList = WBattleGlobal:getCurrent():getHeroSortList()
    --碰撞队列对象
    local list = {}
    local animPos = self.m_anim:getPosition()
    local rangList = self:getCollisionRang()
    for i ,v in ipairs(tHeroList) do
        if not v:isDead() and v:getHp() > 0 and self:getCamp() ~= v:getCamp() then
            local pos = v:getCenterPos()
            local collision = false
            for id,rang in pairs(rangList) do
            --    local rect = {x = animPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = animPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
                local circle1 = {x = animPos.x, y = animPos.y, r = rang.m_fRadius}
                local circle = {x = pos.x, y=pos.y, r = v:getRadiusForHurt()}
                if BattleCommon:checkCircleCollosion(animPos,circle1.r,pos,circle.r) then
            --    if BattleCommon:rectCircleOverLap(rect,circle) then
                    collision = true
                    break 
                end
            end
            if collision then
               table.insert(list, v)
            end
        end
    end
    --怪物
    local tGuaiList = WBattleGlobal:getCurrent():getGuaiSortList()
    --碰撞队列对象
    WZLog("WBattleMachineMaritime3Totem:checkBuffTotemCollison one", #tGuaiList)
    for i ,v in ipairs(tGuaiList) do
        if not v:isDead() and v:getHp() > 0 and self:getCamp() ~= v:getCamp() then
            local collision = false
            local guaiRectList = v:getCollisionRang()
            local posChar = v:getPosition()
            posChar = Vector2:create(posChar.x, posChar.y)
            if guaiRectList then 
                for j, guaiRang in pairs(guaiRectList) do
                    if guaiRang.m_nType == 0 then 
                        posChar = v:getCenterPos()
                        for id,rang in pairs(rangList) do
                            local circle1 = {x = animPos.x, y = animPos.y, r = rang.m_fRadius}
                            local circle = {x = posChar.x, y=posChar.y, r = v:getRadiusForHurt()}
                            if BattleCommon:checkCircleCollosion(animPos,circle1.r,posChar,circle.r) then
                                collision = true
                                break 
                            end
                        end
                    elseif guaiRang.m_nType == 1 then
                        for id,rang in pairs(rangList) do
                            local circle1 = {x = animPos.x, y = animPos.y, r = rang.m_fRadius}
                            local rectChar = {x = posChar.x+guaiRang.m_fXOffset - guaiRang.m_fWidth*0.5,y = posChar.y+guaiRang.m_fYOffset,w = guaiRang.m_fWidth,h=guaiRang.m_fHeight}
                            if BattleCommon:rectCircleOverLap(rectChar,circle1) then
                                collision = true
                                break 
                            end
                        end
                    end
                    if collision then break end 
                end
            else
                posChar = v:getCenterPos()
                for id,rang in pairs(rangList) do
                    local circle1 = {x = animPos.x, y = animPos.y, r = rang.m_fRadius}
                    local circle = {x = posChar.x, y=posChar.y, r = v:getRadiusForHurt()}
                    if BattleCommon:checkCircleCollosion(animPos,circle1.r,posChar,circle.r) then
                        collision = true
                        break 
                    end
                end
            end
            if collision then
               table.insert(list, v)
            end
        end
    end
    WZLog("WBattleMachineMaritime3Totem:checkBuffTotemCollison", #list)
    return list
end

--@brief 
function WBattleMachineMaritime3Totem:getNameLayerOffset()
    return {x = 0, y = -10}
end

--@brief    获得人物名称信息的显示
--@return   #1, 人物名称信息的显示
function WBattleMachineMaritime3Totem:getPlayerNameIcon()
    return self.m_tBossName
end
-------------------------------------私有方法模块End----------------------------------------