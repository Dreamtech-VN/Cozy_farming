--WBattleMachineLaserGun.lua
--@brief    场景机关
--@date     2016/10/12
--@note     boss7火焰

WBattleMachineLaserGun = {
    m_tAniFileIndex = nil,  --配置id
    m_tConfig = nil,    --配置
    m_nBattleId = nil,   --战场唯一id
    m_anim = nil,   --形象
    m_mover = nil,  --移动管理者
    m_tCollisionRang = nil, --碰撞区域
    m_bIsShowRang = false,  --是否显示碰撞区域
    m_tCollisionTable = nil,    --显示的碰撞框
    m_bAutoStandAction = true,  --自动切换待机
    m_nLaserState = 0,    --状态
    m_nLaserType = 1, --类型 
}

WBattleMachineLaserGunStateType = {
    RED = 1,
    BLUE = 2,
    GREEN = 3,
    YELLOW = 4,
}
-------------------------------------公有方法模块Begin--------------------------------------

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function WBattleMachineLaserGun:new(battleId,templateId,camp,bronPos,laserType)
    WZLog("WBattleMachineLaserGun:new",laserType,battleId,templateId,camp,bronPos.x,bronPos.y)
    -- WBattleGlobal:getCurrent():setBuildMonsterRecord(battleId,templateId)
    setmetatable(WBattleMachineLaserGun,{__index = WCharacter})
    local tNewObj = {}
    setmetatable(tNewObj, { __index = WBattleMachineLaserGun })
    tNewObj.m_nBattleId = battleId
    tNewObj.m_nPlayerId = templateId
    tNewObj.m_nCamp = camp
    tNewObj.m_nMonsterType = MonsterType.BOSS_LASER
    tNewObj.m_bIsInCtb = false--不参与ctb轮转
    tNewObj.m_bOffHurt = true --不参与伤害计算
    tNewObj.m_bOffCollision = true --不参与子弹碰撞计算
    tNewObj.m_tAniFileIndex =  "machine_7002"
    tNewObj.m_nLaserType = laserType or WBattleMachineLaserGunStateType.RED
    tNewObj.m_nLaserState = 0
    tNewObj:parseMonsterData()
    
    --设置当前方向向左
    tNewObj.m_nCurDirect = 0

    tNewObj.m_bActiveAttack = false
    tNewObj.m_bPassiveAttack = false
    tNewObj.m_tActiveSkillList = {}
    tNewObj.m_tPassiveSkillList = {}

    tNewObj:_init()
    local firstPos = bronPos or {x = 900,y = 800}
    tNewObj:setPosition(Vector2:create(firstPos.x, firstPos.y + 250))
    
    return tNewObj
end

--@brief 获得配置id
function WBattleMachineLaserGun:getAniFileIndex()
    return self.m_tAniFileIndex
end

--@brief 道具刷新
function WBattleMachineLaserGun:update(dt)
    if self:isDead() then
        self:updateDeadAct()
        return
    end
    if self.m_bIsInSkill then
        if self:getAnimation():isCurrentAnimationDone() == true then
            self.m_bIsInSkill = false
            self:makeSkillHurt()
        end
    end
    WCharacter.update(self,dt)
    -- WZLog("WBattleMachineLaserGun:update",tostring(self:getAnimation():isCurrentAnimationDone()),self:getNormalAnimationName())
    if self:getAnimation():isCurrentAnimationDone() == true and self.m_bAutoStandAction then
        -- WZLog("WBattleMachineLaserGun:update-2")
        self:getAnimation():play(self:getNormalAnimationName(), true)
    end

    -- self:checkCollision()
    -- if not self:isDead() and self:getHp() > 0 then
    --     self:_addBossName()
    -- end
    
end

--@brief    检查碰撞
--@param    pos:位置
--@param    raduis:半径
--@param    charaList:列表
--@return   #1:true:撞了,false:没撞
--@return   #2:碰撞的人物列表
function WBattleMachineLaserGun:checkCollision()
    WZLog("WBattleMachineLaserGun:checkCollision")
    local list = WBattleGlobal:getCurrent():getHeroList()
    local collisionList = {}
    for id,hero in pairs(list) do
        if not hero:isDead() then
            local pos = hero:getPosition()
            local animPos = self.m_anim:getPosition()
            local rangList = self:getCollisionRang()
            local collision = false
            for id,rang in pairs(rangList) do
                local rect = {x = animPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = animPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
                local circle = {x = pos.x,y=pos.y,r = 20}
                if BattleCommon:rectCircleOverLap(rect,circle) then
                    collision = true
                end
            end
            if collision then
               table.insert(collisionList,hero);
            end
        end
    end
    if #collisionList > 0 then
        WZLog("WBattleMachineLaserGun:checkCollision-two",#collisionList)
        local boss = nil
        local bossList = WBattleGlobal:getCurrent():getBossArray()
        if #bossList >= 2 then
            boss = bossList[1]:getBattleId() > bossList[2]:getBattleId() and bossList[1] or bossList[2]
        elseif #bossList == 1 then
            boss = bossList[1]
        end
        if boss then
            BattleMethod:waitForSkillHurt(boss,collisionList)
            boss.m_nCurRoundHurt = 0 --不算入怪物本身的伤害
        end
    end
end

--@brief    初始化基础动画
function WBattleMachineLaserGun:initAnim()
    WZLog("WBattleMachineLaserGun:initAnim",self:getConfig().aniFileId)
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
    self.m_anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.05))
    
    if self:getConfig().isMapCollision == true then
        self:setMover()
    end
    self:changeRectCollision()

    self:getAnimation():play(self:getNormalAnimationName(),true)
end

--出现动画
function WBattleMachineLaserGun:playAppearAction()
    self:getAnimation():play(self:getAppearAnimationName(), false)
end

--@brief 设置碰撞
function WBattleMachineLaserGun:setMover()
    --小怪Mover
    WZLog("WBattleGlobalFire:setMover")
    self.m_mover = WDMoveEntity:create(self:getAnimation():getAnimNode())
    self.m_mover:setAdjustChild(true)
    self.m_mover:retain()

    local center = Vector2:create(0,50)
    self.m_mover:setMoverCenter(center)
    self.m_mover:setMoverRadius(10)
end

--@brief    获取缩放系数
function WBattleMachineLaserGun:getScale()
    return self.m_anim:getScale()
end

--@brief    设置缩放系数
function WBattleMachineLaserGun:setScale(scale)
    self.m_anim:setScale(scale)
end


--@brief    获取移动控制对象
--@return   #1:WDMove移动控制对象
function WBattleMachineLaserGun:getMover()
    return self.m_mover
end

--@brief 获取形象名字
function WBattleMachineLaserGun:getAnimationName(index)
    WZLog("WBattleMachineLaserGun:getAnimationName",index)
    return self.animNormal[index] or self.animNormal["wait_1"]
end

--@brief 获取形象
function WBattleMachineLaserGun:getAnimation()
    return self.m_anim
end

function WBattleMachineLaserGun:getAnimScale()
    return self:getConfig().scale and self:getConfig().scale or 1
end

--@brief    添加碰撞矩形
function WBattleMachineLaserGun:changeRectCollision()
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
            WZLog("WBattleMachineLaserGun:changeRectCollision two", info.width, info.height,info.x, info.y, scale)
        end
    end
end

--@brief    添加矩形碰撞范围
--@param    width,height:宽高
--@param    xOffset,yOffset:x,y偏移量
--@note     偏移量的参考点是character的中心点
function WBattleMachineLaserGun:addRectCollision(width,height,xOffset,yOffset)
    if self.m_tCollisionRang == nil then
        self.m_tCollisionRang = {}
    end

    local tRang = CollisionRang:new()
    tRang.m_nType = 1
    tRang.m_fWidth = width
    tRang.m_fHeight = height
    tRang.m_fXOffset = xOffset
    tRang.m_fYOffset = yOffset
    table.insert(self.m_tCollisionRang,tRang)
end



--@brief 获取中心点
function WBattleMachineLaserGun:getCenterPos()
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
function WBattleMachineLaserGun:getPosition()
    if not self.m_anim then
        return GlobalMethod:ccp(0,0)
    end
    return self.m_anim:getPosition()
end

--@brief    设置当前的位置
--@param    tPos 当前位置
function WBattleMachineLaserGun:setPosition(tPos)
    if self.m_mover ~= nil then
        self.m_mover:setMoverPosition(Vector2:create(tPos.x,tPos.y))
    end
    if self.m_anim ~= nil then
        self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
    end
end

--@brief 
function WBattleMachineLaserGun:setRotation(rota)
    if self.m_anim then
        self.m_anim:getAnimNode():setRotation(rota)
    end
end

--@brief 
function WBattleMachineLaserGun:getRotation(rota)
    if self.m_anim then
        return self.m_anim:getAnimNode():getRotation()
    end
    return 0
end

--@brief 获取配置
function WBattleMachineLaserGun:getConfig()
    if not self.m_tConfig then
        local config = BattleMachineConfig[self.m_tAniFileIndex]
        self.m_tConfig = config
        self.m_tbulletPosOffset = config.bulletPosOffset or {x=0,y=0}
    end
    
    return self.m_tConfig
end

--@brief    获取对象类型
--@return   #1:对象类型(0:player,1:guai)
function WBattleMachineLaserGun:getType()
    return 100
end

--@brief    获取子弹碰撞半径
--@return   #1:子弹碰撞半径
function WBattleMachineLaserGun:getRadiusForBulletCollision()
    return 0
end

--@brief    获得碰撞范围
--@return   #1:碰撞范围
function WBattleMachineLaserGun:getCollisionRang()
    return self.m_tCollisionRang
end

--@brief 射击点
function WBattleMachineLaserGun:getShootPos(target)
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
function WBattleMachineLaserGun:getAutoStandAction()
    return self.m_bAutoStandAction
end

--@brief 设置自动切换待机动画
--@return
function WBattleMachineLaserGun:setAutoStandAction(val)
    self.m_bAutoStandAction = val
end

--@brief    获取atk动画
function WBattleMachineLaserGun:getAtkAnimationName()
    return self:getAnimationName("atk_"..self.m_nLaserType)
end

--@brief    获取待机动画
function WBattleMachineLaserGun:getNormalAnimationName()
    if self.m_nLaserState == 0 then
        return self:getAnimationName("wait_"..self.m_nLaserType)
    else
        return self:getAnimationName("ready_"..self.m_nLaserType)
    end
end

--@brief    获取受伤动画
function WBattleMachineLaserGun:getHurtAnimationName()
    return self:getAnimationName("hurt")
end

--@brief    获取死亡动画
function WBattleMachineLaserGun:getDeadAnimationName()
    return self:getAnimationName("dead")
end

--@brief 设置死亡
function WBattleMachineLaserGun:setDead(bDead, note)
    WZLog("WBattleMachineLaserGun:setDead one", tostring(note))
    if self.m_bIsDead ~= bDead then
        self.m_bIsDead = bDead
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
end

--@brief 自杀
function WBattleMachineLaserGun:doSuicide()
    self:setDead(true,"doSelfKill")
    -- WBattleGlobal:getCurrent():setHoldMonsterRecord(self.m_nBattleId)
    if WBattleGlobal:getCurrent():isSingleStage() then
        self:setServerDead(true)
    else
        if WBattleGlobal:getCurrent():isHostControl() then
            ProtocolProcessorBattleInterface:send_BATTLE_OutOfScene(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self:getBattleId() ,WBattleGlobal:getCurrent():getCurrentCharacterId())
        end
    end

    if self.m_bIsEndCurRound then
        if WBattleGlobal:getCurrent():isMyTurn() then
            WndBattleHud:resetSkill(true,"giftHide")
            WndBattleHud:resetItem(true)
            WndBattleHud:resetKMSkill(true)
            WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),"gift")
        end
    end
end

--@brief 获取死亡标记
function WBattleMachineLaserGun:isDead()
    return self.m_bIsDead
end

--@brief 死亡过程
function WBattleMachineLaserGun:updateDeadAct()
    if self:isServerDead() and self:getAnimation():isCurrentAnimationDone() == true then
        WZLog("WBattleMachineLaserGun:updateDeadAct")
        WBattleGlobal:getCurrent():removeMachine(self.m_nBattleId)
    end
end
--@--brief wbattleglobal调用
function WBattleMachineLaserGun:destroy()
    WZLog("WBattleMachineLaserGun:destroy")
    if self:getAnimation():getAnimNode() then
        self:getAnimation():getAnimNode():removeFromParentAndCleanup(false)
        WZLog("WBattleMachineLaserGun:release")
        self:getAnimation():getAnimNode():release()
    end

    if WBattleGlobal:getCurrent().m_battleManager ~= nil and  self.m_mover then
        WBattleGlobal:getCurrent().m_battleManager:removeEntity(self.m_mover)
    end

    if self.m_mover then
        self.m_mover:release()
        self.m_mover = nil
    end

    self:clearPlayerNameIcon()
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
function WBattleMachineLaserGun:getCenterPos()
   return self:getPetAttackPos()
end

function WBattleMachineLaserGun:getPetAttackPos()
    local size = self:getConfig().animSize
    do
        local offsetH = size.height* 0.5
        return {x=self:getPosition().x,y=self:getPosition().y}
    end

end

--@brief 转换准备状态(添加buff实现 主机发送协议)
--10307(无敌) 10308（驱散无敌） 无需同步的技能服务器记录buff状态
function WBattleMachineLaserGun:setReady()
    if self.m_nLaserState == 1 then
        return
    end
    WZLog("WBattleMachineLaserGun:setReady")
    self.m_nLaserState = 1
    local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
    msg.m_nId = nil --不发协议
    msg.m_tOwner = self
    msg.m_tSkillTypeList = {[1]=SkillTypeConfig.HIT_DO_EFFECT}
    msg.m_nSkillId = 10307
    msg.m_nTakeEffectType = TakeEffectType.USE
    MsgManager:pushNonBlockMsg(msg)
    self:getAnimation():play(self:getNormalAnimationName(), true)
    if WBattleGlobal:getCurrent():isHostControl() then
        ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_nBattleId, 10307,{})
    end
end

--@brief 移除准备吧状态
function WBattleMachineLaserGun:setNormal()
    WZLog("WBattleMachineLaserGun:setNormal")
    if self.m_nLaserState == 0 then
        return
    end
    self.m_nLaserState = 0
    local msg = MsgManager:createMsg(BattleMsgBossMapSkill)
    msg.m_nId = nil --不发协议
    msg.m_tOwner = self
    msg.m_tSkillTypeList = {[1]=SkillTypeConfig.HIT_DO_EFFECT}
    msg.m_nSkillId = 10308
    msg.m_nTakeEffectType = TakeEffectType.USE
    MsgManager:pushNonBlockMsg(msg)

    self:getAnimation():play(self:getNormalAnimationName(), true)

    if WBattleGlobal:getCurrent():isHostControl() then
        ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_nBattleId, 10308,{})
    end
end

--@brief buff添加改变状态
function WBattleMachineLaserGun:updateStateByAddBuff()
    self.m_nLaserState = 1
end

--@brief    删除buff特殊影响
function WBattleMachineLaserGun:removeBuffSpecialInfluence(buff)
    WZLog("WBattleMachineLaserGun:removeBuffSpecialInfluence")
    WCharacter.removeBuffSpecialInfluence(self,buff)
    if buff and buff.m_nID == 7004 then
        self:setNormal()
    end
end


--@breif 攻击
function WBattleMachineLaserGun:doSkill()
    if self.m_nLaserState == 0 then
        return
    end
    self:setNormal()
    self.m_bIsInSkill = true
    self:getAnimation():play(self:getAtkAnimationName(),false)
end

function WBattleMachineLaserGun:makeSkillHurt()
    local targetList = {}
    local list = WBattleGlobal:getCurrent():getCharacterList(true)
    for id,hero in pairs(list) do
        if not hero:isDead() then
            local pos = hero:getPosition()
            local animPos = self.m_anim:getPosition()
            WZLog("WBattleMachineLaserGun:makeSkillHurt one", hero:getBattleId(), math.abs(pos.y - animPos.y), pos.y, animPos.y)
            if hero:getType() == 0 and math.abs(pos.y - animPos.y) < 100 then
               table.insert(targetList,hero)
            end
            if hero:getType() == 1 and animPos.y > pos.y then
                local isHurt = false
                for i,rang in pairs (hero:getCollisionRang()) do
                    local top = pos.y +  rang.m_fYOffset + rang.m_fHeight + 50
                    WZLog("WBattleMachineLaserGun:makeSkillHurt two", top, animPos.y, rang.m_fYOffset, rang.m_fHeight)
                    if animPos.y < top then
                        isHurt = true
                        break
                    end
                end
                if isHurt then
                    table.insert(targetList,hero)
                end
            end
        end
    end
    --添加孩子检测
    local kidList = WBattleGlobal:getCurrent():getKidSortList()
    for id, kid in pairs(kidList) do
        if not kid:isDead() then
            local pos = kid:getPosition()
            local animPos = self.m_anim:getPosition()
            WZLog("WBattleMachineLaserGun:makeSkillHurt three", kid:getBattleId(), math.abs(pos.y - animPos.y), pos.y, animPos.y)
            if math.abs(pos.y - animPos.y) < 100 then
               table.insert(targetList, kid)
            end
           
            local isHurt = false
            for i,rang in pairs (kid:getCollisionRang()) do
                local centerY = pos.y +  rang.m_fYOffset + rang.m_fHeight * 0.5
                WZLog("WBattleMachineLaserGun:makeSkillHurt four", centerY, animPos.y, rang.m_fYOffset, rang.m_fHeight)
                if math.abs(centerY - animPos.y) < (50 + rang.m_fHeight * 0.5) then
                    isHurt = true
                    break
                end
            end
            if isHurt then
                table.insert(targetList,kid)
            end
        end
    end
    BattleMethod:waitForSkillHurt(self,targetList)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief    初始化对象
function WBattleMachineLaserGun:_init()
    WCharacter._init(self)

    self:_setAnimConfig()
    self:initAnim()
    self.m_bIsShowRang = true
end

--@brief 解析动画名字
function WBattleMachineLaserGun:_setAnimConfig()
    local animationInfo = self:getConfig()["animNormal"]
    self.animNormal = {}
    if animationInfo ~= nil then
        local animationInfoList = SplitStringWithSeparator(animationInfo, "|")
        for id, info in pairs(animationInfoList) do
            StringIntsertToTable(self.animNormal,info)
        end
    end
end

function WBattleMachineLaserGun:_addBossName()
    if self:getLevel() == -1 then
        return nil
    end
    if self.m_tBossName == nil then
        local bSameCamp = self.m_nCamp == WBattleGlobal:getCurrent():getMyHero():getCamp()
        self.m_tBossName = BattleHeroName:create(self,SceneBattle:getInfoLayer(),bSameCamp)
        self.m_tBossName.m_nameLabel:setVisible(false)
    end
    if self.m_tBossName then
        self.m_tBossName:update()
    end
end

--@brief 
function WBattleMachineLaserGun:getNameLayerOffset()
    return {x = 0, y = -10}
end

--@brief    获得人物名称信息的显示
--@return   #1, 人物名称信息的显示
function WBattleMachineLaserGun:getPlayerNameIcon()
    return self.m_tBossName
end

--@brief    清理人物名称信息的显示
function WBattleMachineLaserGun:clearPlayerNameIcon()
   if self.m_tBossName ~= nil then
        self.m_tBossName:destroy()
        self.m_tBossName = nil
    end
end

--@brief    添加人物碰撞列表
--@param    tCharas:人物碰撞列表
function WBattleMachineLaserGun:addCollisionCharas(tCharas)
    if self.m_tCollisionCharacters == nil then
        self.m_tCollisionCharacters = {}
    end
    
    table.insert(self.m_tCollisionCharacters,tCharas)
end

-------------------------------------私有方法模块End----------------------------------------