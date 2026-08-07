--WBattleMachine.lua
--@brief    场景机关
--@date     2015/08/14
--@note     场景机关

WBattleMachine = {
    m_tAniFileIndex = nil,  --配置id
    m_tConfig = nil,    --配置
    m_nBattleId = nil,   --战场唯一id
    m_anim = nil,   --形象
    m_tOwner = nil, --拥有者
    m_mover = nil,  --移动管理者
    m_tCollisionRang = nil, --碰撞区域
    m_bIsShowRang = false,  --是否显示碰撞区域
    m_tCollisionTable = nil,    --显示的碰撞框
    m_bAutoStandAction = true,  --自动切换待机

    m_bIsDead = nil --死亡标记
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function WBattleMachine:new(aniFileIndex,owner)
    setmetatable(WBattleMachine,{__index = WCharacter})
    local tNewObj = {}
    setmetatable(tNewObj, { __index = WBattleMachine })
    
    tNewObj.m_tAniFileIndex = aniFileIndex
    tNewObj.m_tOwner = owner
    tNewObj:_init()
    self.m_bOffHurt = true
    
    return tNewObj
end

--@brief 获得配置id
function WBattleMachine:getAniFileIndex()
    return self.m_tAniFileIndex
end

--@brief 道具刷新
function WBattleMachine:update(dt)
    if self:isDead() then
        self:updateDeadAct()
        return
    end

    if self:getAnimation():isCurrentAnimationDone() == true and self.m_bAutoStandAction then
        self:getAnimation():play(self:getNormalAnimationName(), true)
    end
    --显示碰撞区域
    if self.m_tCollisionRang then
        if self.m_bIsShowRang and ProjConfig.DEBUG == 1 then
            local charaPos = self:getCenterPos()

            if self.m_tCollisionTable == nil then
                self.m_tCollisionTable = {}
                for i,tRang in pairs(self.m_tCollisionRang) do
                    if tRang.m_nType == 0 then
                        self.m_tCollisionTable[i] = BattleAnimation:addCircle({x = charaPos.x + tRang.m_fXOffset - tRang.m_fRadius*0.5, y = charaPos.y+tRang.m_fYOffset - tRang.m_fRadius*0.5} ,tRang.m_fRadius,{r = 1,g = 1,b = 1,a = 1},SceneBattle:getFrontLayer())
                    elseif tRang.m_nType == 1 then
                        self.m_tCollisionTable[i] = BattleAnimation:addRect({x = charaPos.x, y = charaPos.y,w = tRang.m_fWidth,h=tRang.m_fHeight},{r = 1,g = 1,b = 1,a = 1},SceneBattle:getFrontLayer())
                    end
                end
            end

            for i,tRang in pairs(self.m_tCollisionRang) do
                if tRang.m_nType == 0 then
                    self.m_tCollisionTable[i]:setPosition(charaPos.x + tRang.m_fXOffset - tRang.m_fRadius*0.5, charaPos.y + tRang.m_fYOffset - tRang.m_fRadius*0.5)
                elseif tRang.m_nType == 1 then
                    self.m_tCollisionTable[i]:setPosition(charaPos.x + tRang.m_fXOffset - tRang.m_fWidth*0.5, charaPos.y + tRang.m_fYOffset )
                end
            end
        end
    end
end

--@brief ctb刷新
function WBattleMachine:updateCtb()

end

--@brief    初始化基础动画
function WBattleMachine:initAnim()
    WZLog("WBattleMachine:initAnim")
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

    self:getAnimation():play(self:getAnimationName("standby"),true)
end

--@brief 设置碰撞
function WBattleMachine:setMover()
    --小怪Mover
    self.m_mover = WDMoveEntity:create(self:getAnimation():getAnimNode())
    self.m_mover:setAdjustChild(true)
    self.m_mover:retain()

    local center = Vector2:create(0,50)
    self.m_mover:setMoverCenter(center)
    self.m_mover:setMoverRadius(10)
end

--@brief    获取缩放系数
function WBattleMachine:getScale()
    return self.m_anim:getScale()
end

--@brief    设置缩放系数
function WBattleMachine:setScale(scale)
    self.m_anim:setScale(scale)
end


--@brief    获取移动控制对象
--@return   #1:WDMove移动控制对象
function WBattleMachine:getMover()
    return self.m_mover
end

--@brief 获取形象名字
function WBattleMachine:getAnimationName(index)
    return self.animNormal[index] or self.animNormal["standby"]
end

--@brief 获取形象
function WBattleMachine:getAnimation()
    return self.m_anim
end

function WBattleMachine:getAnimScale()
    return self:getConfig().scale and self:getConfig().scale or 1
end

--@brief    添加碰撞矩形
function WBattleMachine:changeRectCollision()
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
            WZLog("WBattleMachineTornado:changeRectCollision two", info.width, info.height,info.x, info.y, scale)
        end
    end
end

--@brief    添加矩形碰撞范围
--@param    width,height:宽高
--@param    xOffset,yOffset:x,y偏移量
--@note     偏移量的参考点是character的中心点
function WBattleMachine:addRectCollision(width,height,xOffset,yOffset)
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
function WBattleMachine:getCenterPos()
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
function WBattleMachine:getPosition()
    if not self.m_anim then
        return GlobalMethod:ccp(0,0)
    end
    return self.m_anim:getPosition()
end

--@brief    设置当前的位置
--@param    tPos 当前位置
function WBattleMachine:setPosition(tPos)
    if self.m_mover ~= nil then
        self.m_mover:setMoverPosition(Vector2:create(tPos.x,tPos.y))
    end
    if self.m_anim ~= nil then
        self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
    end
end

--@brief 
function WBattleMachine:setRotation(rota)
    if self.m_anim then
        self.m_anim:getAnimNode():setRotation(rota)
    end
end

--@brief 
function WBattleMachine:getRotation(rota)
    if self.m_anim then
        return self.m_anim:getAnimNode():getRotation()
    end
    return 0
end

--@brief 获取配置
function WBattleMachine:getConfig()
    if not self.m_tConfig then
        local config = BattleMachineConfig[self.m_tAniFileIndex]
        self.m_tConfig = config
        self.m_tbulletPosOffset = config.bulletPosOffset or {x=0,y=0}
    end
    
    return self.m_tConfig
end

--@brief 获取拥有者
function WBattleMachine:getOwner()
    return self.m_tOwner
end

--@brief    获取对象类型
--@return   #1:对象类型(0:player,1:guai)
function WBattleMachine:getType()
    return 100
end

--@brief    获取子弹碰撞半径
--@return   #1:子弹碰撞半径
function WBattleMachine:getRadiusForBulletCollision()
    return 0
end

--@brief    获得碰撞范围
--@return   #1:碰撞范围
function WBattleMachine:getCollisionRang()
    return self.m_tCollisionRang
end

--@brief 射击点
function WBattleMachine:getShootPos(target)
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
function WBattleMachine:getAutoStandAction()
    return self.m_bAutoStandAction
end

--@brief 设置自动切换待机动画
--@return
function WBattleMachine:setAutoStandAction(val)
    self.m_bAutoStandAction = val
end

--@brief    获取待机动画
function WBattleMachine:getNormalAnimationName()
    return self:getAnimationName("standby")
end

--@brief 设置死亡
function WBattleMachine:setDead(val)
    if self.m_bIsDead == val then
        return
    end

    self.m_bIsDead = val
    self:getAnimation():play(self:getAnimationName("dead"),false)
end

--@brief 获取死亡标记
function WBattleMachine:isDead()
    return self.m_bIsDead
end

--@brief 死亡过程
function WBattleMachine:updateDeadAct()
    if self:getAnimation():isCurrentAnimationDone() == true then
        WBattleGlobal:getCurrent():removeMachine(self.m_nBattleId)
    end
end

function WBattleMachine:destroy()
    WZLog("WBattleMachine:destroy")
    if self:getAnimation():getAnimNode() then
        WZLog("WBattleMachine:release")
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

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief    初始化对象
function WBattleMachine:_init()
    WCharacter._init(self)
    self:_setAnimConfig()
    self:initAnim()
    self.m_bIsShowRang = true
end

--@brief 解析动画名字
function WBattleMachine:_setAnimConfig()
    local animationInfo = self:getConfig()["animNormal"]
    self.animNormal = {}
    if animationInfo ~= nil then
        local animationInfoList = SplitStringWithSeparator(animationInfo, "|")
        for id, info in pairs(animationInfoList) do
            StringIntsertToTable(self.animNormal,info)
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------