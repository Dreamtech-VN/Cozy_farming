--BattleMsgBulletParticleEffect.lua
--@brief	子弹爆炸粒子特效
--@date		2015/4/13
--@author	zjh

--@brief	消息数据表
BattleMsgBulletParticleEffect = {
    m_sName = "BattleMsgBulletParticleEffect",
	m_tStartPos = nil,
	m_tStartSpeed = nil,
	m_tMover = nil,
	m_tMoverNode = nil,
	m_tMoverTimes = nil,
	m_nCount = nil,
	m_tRandX = nil,
	m_tRandY = nil,
}


-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgBulletParticleEffect:init()
	WZLog("BattleMsgBulletParticleEffect:init")
	--BattleMapManager:showExploder()
	self.m_tMover = {}
	self.m_tMoverNode = {}
	self.m_tMoverTimes = {}
	self.m_tRandX = {}
	self.m_tRandY = {}

	local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
	self.m_tStartPos = self.m_tStartPos or hero:getAnimation():getPosition()
	if self.m_nCount == nil then
		if WDExplodeHole then

			local per =  WDExplodeHole:currentInstance():currentSize() / WDExplodeHole:currentInstance():total()
			self.m_nCount = math.ceil(per * 100) + 10
            WZLog("BattleMsgBulletParticleEffect:init one", WDExplodeHole:currentInstance():currentSize(), WDExplodeHole:currentInstance():total(), per, self.m_nCount)
		else
			self.m_nCount = self.m_nCount or 20
		end
	end
    
    local bIsBigSkill = WBattleGlobal:getCurrent():getCurrentHero() and WBattleGlobal:getCurrent():getCurrentHero():getUseBigSkill()
    if bIsBigSkill then
        self.m_nCount = math.min(self.m_nCount, 8)
    else
        self.m_nCount = math.min(self.m_nCount, 30)
    end
    WZLog("BattleMsgBulletParticleEffect:init two", self.m_nCount, tostring(self.m_tStartSpeed), tostring(self.m_tStartSpeed and self.m_tStartSpeed.x), tostring(self.m_tStartSpeed and self.m_tStartSpeed.y))
    if self.m_tStartSpeed then
		_,self.m_tStartSpeed = BattleCommon:vectorNormalize(self.m_tStartSpeed)
	else
		self.m_tStartSpeed = {x=0,y=1}
	end

	for i=1,self.m_nCount do
		local img 
		if WDExplodeHole then
			img = WDExplodeHole:currentInstance():getSprite(0)
			if i < self.m_nCount/5 then
				img:setScale(math.random(500,800)/1000)
			else
				img:setScale(math.random(800,1200)/1000)
			end
        else
			img = CCSprite:create("shopitems/gold.png")
			img:setScale(math.random(120,200)/1000)
			img:setColor(GlobalMethod:ccc3(0,0,0))
        end
		img:runAction(CCFadeTo:create(0.667 * (img:getScale() * 30 - 1.5) ,0))

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

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgBulletParticleEffect:process()
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
						self.m_tMoverNode[i]:setScale(self.m_tMoverNode[i]:getScale()*0.8)
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

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgBulletParticleEffect:done()
	WZLog("BattleMsgBulletParticleEffect:done")
end

function BattleMsgBulletParticleEffect:deleteMover(nIdx)
	WBattleGlobal:getCurrent().m_battleManager:removeEntity(self.m_tMover[nIdx])
	self.m_tMoverNode[nIdx]:removeFromParentAndCleanup(true)
	self.m_tMoverNode[nIdx] = nil
	self.m_tMover[nIdx]:release()
	self.m_tMover[nIdx] = nil
end


-------------------------------------私有方法模块--------------------------------------

