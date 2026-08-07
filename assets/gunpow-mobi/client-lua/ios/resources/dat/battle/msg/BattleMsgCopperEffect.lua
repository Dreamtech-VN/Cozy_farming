--BattleMsgCopperEffect.lua
--@brief    金币掉落效果
--@date     2015/8/29

--@brief    消息数据表
BattleMsgCopperEffect = {
    m_sName = "BattleMsgCopperEffect",
    --外部赋值
    m_tStartPos = nil,
    m_nBigCopper = 0,
    m_nMidCopper = 0,
    m_nMiniCopper = 0,
    --内部赋值
    m_tStartSpeed = nil,
    m_tMover = nil,
    m_tMoverNode = nil,
    m_tMoverTimes = nil,
    m_nCount = nil,
    m_tRandX = nil,
    m_tRandY = nil,
}


-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgCopperEffect:init()
    WZLog("BattleMsgCopperEffect:init")
    --BattleMapManager:showExploder()
    self.m_tMover = {}
    self.m_tMoverNode = {}
    self.m_tMoverTimes = {}
    self.m_tRandX = {}
    self.m_tRandY = {}

    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    self.m_tStartPos = self.m_tStartPos or hero:getAnimation():getPosition()
    self.m_nCount = self.m_nBigCopper + self.m_nMidCopper + self.m_nMiniCopper

    WZLog("BattleMsgCopperEffect:init", "count", self.m_nCount)
    self.m_tStartSpeed = {x=0,y=2}

    for i=1,self.m_nCount do
        local img 
        img = CCSprite:create("shopitems/gold.png")
        
        if i <= self.m_nBigCopper then
            --大金币
            img:setScale(1)
        elseif i <= self.m_nBigCopper + self.m_nMidCopper then
            --中金币
            img:setScale(0.5)
        else
            --小金币
            img:setScale(0.5)
        end
        
        --img:runAction(CCFadeTo:create(0.667 * (img:getScale() * 30 - 1.5) ,0))

        SceneBattle:getFrontLayer():addChild(img)
        local mover = WDMoveEntity:create(img)
        mover:retain()
        mover:setNormal(true)
        mover:setMoverCollisionType(BattleConstants.g_nE_COLLISION_CIRCLE)
        mover:setMoverRadius(2)
        mover:setMoverPosition(Vector2:create(self.m_tStartPos.x , self.m_tStartPos.y ))
        mover:setMoverPrePosition(Vector2:create(self.m_tStartPos.x ,self.m_tStartPos.y ))
        --mover:setFlyAcceleration(0,-1)

        local power = math.random(300,1200)/100

        local speedX = math.random(-6,6)
        local speedY = math.random(-24,1)

        local _,tmpSpeed = BattleCommon:vectorNormalize({x = speedX,y = speedY})


        table.insert(self.m_tRandX,(self.m_tStartSpeed.x + tmpSpeed.x)*power)
        table.insert(self.m_tRandY,(self.m_tStartSpeed.y + tmpSpeed.y)*power)
        --table.insert(self.m_tRandX,  )
        --table.insert(self.m_tRandY, math.random(100,2400)/100 )


        mover:setMoverSpeed(Vector2:create(self.m_tRandX[i],self.m_tRandY[i]))
        mover:setFly(true)
        WBattleGlobal:getCurrent().m_battleManager:addEntity(mover)
        table.insert(self.m_tMover,mover)
        table.insert(self.m_tMoverNode,img)
        table.insert(self.m_tMoverTimes,0)
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgCopperEffect:process()
    local hasRest = false
    local endTime = 8
    for i = self.m_nCount,1,-1 do
        if self.m_tMover[i] then
            local mover = self.m_tMover[i]
            if mover:isCollision() then
                self.m_tMoverTimes[i] = self.m_tMoverTimes[i] + 1
                if self.m_tMoverTimes[i] >= endTime then
                    self:deleteMover(i)
                    mover = nil
                else
                    --[[mover:setMoverSpeed(Vector2:create( (5 - i) * ( 1 - self.m_tMoverTimes[i] / endTime) , 8 * (1 -self.m_tMoverTimes[i] / endTime) ) )
                    mover:updatePostion()
                    local isCollision,newPos = BattleMapManager:checkCollision(mover,nil,nil)
                    if isCollision then
                        mover:setMoverPosition(Vector2:create(newPos.x,newPos.y))
                        mover:setMoverSpeed(Vector2:create( -(5 - i) * ( 1 - self.m_tMoverTimes[i] / endTime) , 8 * (1 -self.m_tMoverTimes[i] / endTime) ) )
                    end]]
                    --mover:checkCollision()
                    --mover:setMoverAcceleration(Vector2:create(0.1,-0.4))
                    local nowPer = ( 1 - self.m_tMoverTimes[i] / endTime)
                    --local maxPer = 0.15 < nowPer and 0.15 or nowPer
                    local _speed = mover:getCollisionSpeed()
                    local speed = {x = _speed.x,y = _speed.y}
                    mover:setMoverSpeed(Vector2:create(speed.x * 0.15 ,-speed.y * 0.25 ))
                    mover:updatePostion()
                    mover:updatePostion()
                    mover:setMoverCollisionType(BattleConstants.g_nE_COLLISION_POINT)
                    local isCollision = BattleMapManager:checkCollision(mover,nil,nil)
                    if isCollision then
                        mover:setMoverSpeed( Vector2:create( 0  , -1 ) )
                        mover:updatePostion()
                        mover:updatePostion()
                        isCollision = BattleMapManager:checkCollision(mover,nil,nil)
                        if isCollision then
                            self:deleteMover(i)
                            mover = nil
                        end
                    else
                        local xPower = math.random(70,90)/100
                        local yPower = math.random(70,90)/100
                        mover:setMoverSpeed(Vector2:create( -speed.x*nowPer*xPower  , -speed.y*nowPer*yPower ) )
                    end
                    if mover then
                        mover:setMoverCollisionType(BattleConstants.g_nE_COLLISION_CIRCLE)
                        --self.m_tMoverNode[i]:setScale(self.m_tMoverNode[i]:getScale()*0.8)
                    end
                end
            else
                local bOutOfX, bOutOfY = SceneBattle:checkIsOutOfScene(mover)
                if bOutOfX or bOutOfY then --超出屏幕外
                    self:deleteMover(i)
                    mover = nil
                end
            end
            hasRest = true
        end
    end
    return not hasRest
    --return false
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgCopperEffect:done()
    WZLog("BattleMsgCopperEffect:done")
end

function BattleMsgCopperEffect:deleteMover(nIdx)
    WBattleGlobal:getCurrent().m_battleManager:removeEntity(self.m_tMover[nIdx])
    --self.m_tMoverNode[nIdx]:removeFromParentAndCleanup(true)
    --self.m_tMoverNode[nIdx] = nil
    self.m_tMover[nIdx]:release()
    self.m_tMover[nIdx] = nil
    self:collection(self.m_tMoverNode[nIdx])
    self.m_tMoverNode[nIdx] = nil
end

function BattleMsgCopperEffect:collection(copper)
    if WBattleGlobal:getCurrent():getCopyData() and WBattleGlobal:getCurrent():getCopyData():getInfoView() then
        local copperInfo = WBattleGlobal:getCurrent():getCopyData():getInfoView():getLuaObjectIndex()
        local x,y = copper:getPosition()
        local tPos = GlobalMethod:ccp(x,y)
        local pos = SceneBattle:getFrontLayer():convertToWorldSpace(tPos)
        copper:retain()
        copper:removeFromParentAndCleanup(true)
        copperInfo:addCopper(copper,pos)
    else
        copper:removeFromParentAndCleanup(true)
    end
end


-------------------------------------私有方法模块--------------------------------------

