--MapEnenvtTornado.lua
--@brief	地图事件龙卷风数据表
--@date		2014/8/25
--@author	莫剑峰
--@note		地图事件相关属性及操作

--@brief	地图事件数据表
MapEnenvtTornado = {
    ID = 1,      --id
    m_nType = 0,    --类型
    m_sName = "",   --名称
    m_nEffect1 = 0, --效果参数1
    m_nEffect2 = 0, --效果参数2
    m_nEffect3 = 0, --效果参数3
    m_nCharaId = 0, --持有者Id
    m_nCamp = -1,   --阵营

    m_tCollisionRang = nil, 			--碰撞检测范围表
    m_tCollisionTable = nil,			--碰撞圈
    m_anim = nil,                       --动画
    m_tCollisionCharas = {},            --碰撞到的英雄
    m_tCollisionBullets = {},           --碰撞到的子弹
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个事件
--@return	#1:事件对象
function MapEnenvtTornado:buildEvent(weatherId, name, effect1, effect2, tornadoInfo)
	local mapEvent = MapEnenvtTornado:new()

    mapEvent.m_nCharaId = tornadoInfo.charaId
    mapEvent.m_nCamp = tornadoInfo.camp
    mapEvent.m_nType = weatherId
    mapEvent.m_sName = name
    mapEvent.m_nEffect1 = effect1
    mapEvent.m_nEffect2 = effect2

    local animRes = "skill_longjuandan_chixu"

    if mapEvent.m_nCamp == WBattleGlobal:getCurrent():getMyHero():getCamp() then
        animRes = "skill_longjuandan_youfang_chixu"
    end
    mapEvent.m_anim = nil
    mapEvent.m_anim = BattleAnimation:createAnimation(animRes, false, "battle/skill")
    SceneBattle:getFrontLayer():addChild(mapEvent.m_anim:getAnimNode())
    mapEvent.m_anim:setScale(1.5)

    --设置位置
    local firstPos = tornadoInfo.pos

    SceneBattle.m_nMapEventShow = 1
    mapEvent.m_anim:setPosition(Vector2:create(firstPos.x + 0, firstPos.y + 300))
    mapEvent.m_anim:play("chixu",true)

    --设置碰撞范围
    mapEvent:setCollisionRange()

    --初始化状态
    mapEvent:clearState()

    WZLog("MapEnenvtTornado:buildEvent")
	return mapEvent
end

--@brief 	设置碰撞范围
function MapEnenvtTornado:setCollisionRange()

    local size = self.m_anim:getAnimNode():getContentSize()
    local widthScale, heightScale = nil,nil
    local offset = nil

    WZLog("MapEnenvtTornado:setCollisionRange",size.width, size.height)
    widthScale, heightScale = 0.35, 1.05
    offset = BattleCommon:getPointTable(0,-130)
    self:addRectCollision(size.width * widthScale,size.height * heightScale,offset.x,offset.y)
end

--@brief 	获取初始的位置
--@return 	1:初始位置
function MapEnenvtTornado:getFirstPosition()

    local leftestPos, rightestPos, upPos, downPos = nil, nil, nil, nil
    local heroList = {}
    for id,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        table.insert(heroList, {obj=hero, id=id})
    end

    Teach:bubbleSort(heroList, "id")
    for id, hero in ipairs(heroList) do
        hero = hero.obj
        if leftestPos == nil then
            leftestPos = hero:getPosition().x
            rightestPos = hero:getPosition().x
            upPos = hero:getPosition().y
            downPos = hero:getPosition().y
        end
        if hero:getPosition().x < leftestPos then
            leftestPos = hero:getPosition().x
        end
        if hero:getPosition().x > rightestPos then
            rightestPos = hero:getPosition().x
        end
        if hero:getPosition().y > upPos then
            upPos = hero:getPosition().y
        end
        if hero:getPosition().y < downPos then
            downPos = hero:getPosition().y
        end
        WZLog("MapEnenvtBubble:getFirstPosition", id, hero:getPosition().x, hero:getPosition().y)
    end

    WZLog("MapEnenvtBubble:getFirstPosition one", math.abs(leftestPos - rightestPos), leftestPos, rightestPos, upPos, downPos)
    if BattleCommon:tableLen(heroList) <= 2 and math.abs(leftestPos - rightestPos) < 200 then
        return nil
    end

    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    local l = math.min(leftestPos + 100 , rightestPos - 100)
    local r = math.max(leftestPos + 100 , rightestPos - 100)
    local u = math.max(downPos + 40, upPos )
    local d = downPos + 10

    local randList = WBattleGlobal:getCurrent().m_tBattleRand
    local rand = randList[WBattleGlobal:getCurrent():getTurnTimes() % 10 + 1]

    local xRange = r - l
    local xValue = l + 1 / (rand % 10 + 1) * xRange

    local yRange = u - d
    local yValue = d + 1 / (rand % 10 + 1) * yRange

    local pos = {x = xValue, y = yValue + 0}
    WZLog("MapEnenvtBubble:getFirstPosition two", l, r, d, u, pos.x, pos.y)
    return pos
end

--@brief	销毁
function MapEnenvtTornado:destroy()
    WZLog("MapEnenvtTornado:destroy one", tostring(self.ID), tostring(self.m_sName))

    WCharacter.destroy(self)
    if self.m_anim and self.m_anim:getAnimNode() ~= nil and self.m_anim:getAnimNode().removeFromParentAndCleanup ~= nil and self.m_anim:getAnimNode():getParent() ~= nil then

        self.m_anim:getAnimNode():removeFromParentAndCleanup(false)
    end
    WZLog("MapEnenvtTornado:destroy two")
    self:clearCollisionRang()
    self:clearState()

    self.m_tCollisionRang = nil
    self.m_tCollisionTable = nil
    self.m_anim = nil

    self.m_nType = 0
    self.m_sName = ""
    self.m_nEffect1 = 0
    self.m_nEffect2 = 0
    self.m_nEffect3 = 0
end

--@brief	定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function MapEnenvtTornado:update(dt)
    --WZLog("MapEnenvtTornado:update")

	if self.m_tCollisionRang ~= nil and ProjConfig.DEBUG == 1 then
        local animPos = self:getCenterPos()
		if self.m_tCollisionTable == nil then
			self.m_tCollisionTable = {}

			for i,tRang in pairs(self.m_tCollisionRang) do
				if tRang.m_nType == 0 then
    				self.m_tCollisionTable[i] = BattleAnimation:addCircle({x = animPos.x + tRang.m_fXOffset - tRang.m_fRadius*0.5, y = animPos.y+tRang.m_fYOffset - tRang.m_fRadius*0.5} ,tRang.m_fRadius,{r = 1,g = 1,b = 1,a = 1},SceneBattle:getFrontLayer())
				elseif tRang.m_nType == 1 then
    				self.m_tCollisionTable[i] = BattleAnimation:addRect({x = animPos.x + tRang.m_fXOffset - tRang.m_fWidth*0.5, y = animPos.y + tRang.m_fYOffset - tRang.m_fHeight*0.5,w = tRang.m_fWidth,h=tRang.m_fHeight},{r = 1,g = 1,b = 1,a = 1},SceneBattle:getFrontLayer())
				end
			end

		end

		for i,tRang in pairs(self.m_tCollisionRang) do
			if tRang.m_nType == 0 then
				self.m_tCollisionTable[i]:setPosition(animPos.x + tRang.m_fXOffset - tRang.m_fRadius*0.5, animPos.y + tRang.m_fYOffset - tRang.m_fRadius*0.5)
			elseif tRang.m_nType == 1 then
				self.m_tCollisionTable[i]:setPosition(animPos.x + tRang.m_fXOffset - tRang.m_fWidth*0.5, animPos.y + tRang.m_fYOffset - tRang.m_fHeight*0.5)
                --WZLog("MapEnenvtTornado:update two",animPos.x,animPos.y,tRang.m_fXOffset,tRang.m_fYOffset,tRang.m_fWidth,tRang.m_fHeight)
			end
		end
	end

    local isCollision, bulletList, heroList = self:checkCollision()
    if isCollision == true then
        -- if WBattleGlobal:getCurrent().m_nBattleType ~= BattleConstants.g_nBATTLE_TYPE_BOSS or (WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent():isSingleStage() == true) then
            self:eventProcess(bulletList, heroList)
        -- end
    end

    if self:getAnimation():isPlaying("chixu") == false then
        if self:getAnimation():isCurrentAnimationDone() == true then
            self:getAnimation():play("chixu", true)
        end
    end
end

--@brief	事件处理
function MapEnenvtTornado:eventProcess(bulletList, heroList)
    WZLog("MapEnenvtTornado:eventProcess one", #bulletList, #heroList)

    local wind = WBattleGlobal:getCurrent():getWindLevel().x

    for i = #bulletList ,1,-1 do-- bullet in pairs (bulletList) do
        local bullet = bulletList[i]
        WZLog("MapEnenvtTornado:eventProcess three", tostring(bullet), tostring(bullet:getIsExist()), tostring(bullet.m_bIsProcessMapEvent), tostring(bullet.m_bIsCollisionMapEvent))
        if bullet:getIsExist() == true then --and bullet.m_bIsProcessMapEvent == false and bullet.m_bIsCollisionMapEvent == true then
            bullet.m_bIsProcessMapEvent = true

            --处理
            local battleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
            local playerId = bullet.m_ownerChara:getBattleId()
            local eventId = self.ID
            if bullet.m_ownerChara:isCanControl() then
                --ProtocolProcessorBattleInterface:send_BATTLE_EventContact(battleId, playerId, eventId)
            end

            local startSpeed = bullet.m_tStartSpeed
            local moverSpeed = {x=bullet.m_mover:getMoverSpeed().x, y=bullet.m_mover:getMoverSpeed().y}
            local moverPos = {x=bullet.m_mover:getMoverPosition().x, y=bullet.m_mover:getMoverPosition().y}
            local windDirection = -1.0

            local changeSpeed = {x = moverSpeed.x * (windDirection + wind * 0), y = moverSpeed.y}

            bullet.m_mover:setMoverSpeed(Vector2:create(changeSpeed.x, changeSpeed.y))
            bullet.m_bIsAllCollision = true
            WZLog("MapEnenvtTornado:eventProcess two", wind, moverPos.x, moverPos.y, startSpeed.x, startSpeed.y, moverSpeed.x, moverSpeed.y,changeSpeed.x, changeSpeed.y)
        end
        table.remove(bulletList,i)
        table.remove(heroList,i)
    end
end

--@brief	检查碰撞
--@param	pos:位置
--@param	raduis:半径
--@param	charaList:列表
--@return	#1:true:撞了,false:没撞
--@return	#2:碰撞的人物列表
function MapEnenvtTornado:checkCollision()
	local isCollision = false

    local animPos = self.m_anim:getPosition()
    local collisionRang = self:getCollisionRang()

    --检测与子弹的碰撞
    local bullets = WBattleGlobal:getCurrent():getBulletsList()

    if bullets == nil or #bullets == 0 then
        bullets = WBattleGlobal:getCurrent():getBossBulletsList()
    end

    for id,bullet in pairs(bullets) do
        --无视龙卷风判定
        local offTornado = true
        if BattleMethod:canReflectBullet(bullet,self.m_nCharaId,2) then
            offTornado = false
        end

		if not offTornado and bullet.m_ownerChara:getCamp() ~= self.m_nCamp then
            
			local bulletPos = bullet.m_mover:getMoverPosition()
			local bulletRaidus = 2

            if collisionRang ~= nil then
                for i,rang in pairs(collisionRang) do
                    -- if bullet.m_bIsCollisionMapEvent == false then
                    if true then--bullet:checkCanReflect(self.m_nCharaId,2) then
                        --圆形检测
                        if rang.m_nType == 0 then
                            local tmpCharaPos = Vector2:create(animPos.x + rang.m_fXOffset,animPos.y + rang.m_fYOffset)
                            if BattleCommon:checkCircleCollosion(bulletPos,bulletRaidus,tmpCharaPos,rang.m_fRadius) then
                                return true
                            end

                        --矩形检测
                        elseif rang.m_nType == 1 then
                
                            local rect = {x = animPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = animPos.y+rang.m_fYOffset - rang.m_fHeight*0.5,w = rang.m_fWidth,h=rang.m_fHeight}
                            local circle = {x = bulletPos.x,y=bulletPos.y,r = bulletRaidus}
                
                            if BattleCommon:rectCircleOverLap(rect,circle) then

                                isCollision = true
                                -- bullet.m_bIsCollisionMapEvent = true
                                bullet:addReflectList(self.m_nCharaId,2)

                                table.insert(self.m_tCollisionBullets, bullet)

                                local heroId = bullet.m_ownerChara:getBattleId()
                                local isHeroExist = false
                                for j, hero in pairs(self.m_tCollisionCharas) do
                                    if heroId == hero:getBattleId() then
                                        isHeroExist = true
                                    end
                                end

                                if isHeroExist == false then
                                    table.insert(self.m_tCollisionCharas, bullet.m_ownerChara)
                                end

                                WZLog("MapEnenvtTornado:checkCollision two", id, tostring(bullet), heroId, #self.m_tCollisionBullets, #self.m_tCollisionCharas)
                            end
                        end
                    end
                end
            end
		end
	end

	return isCollision, self.m_tCollisionBullets, self.m_tCollisionCharas
end

--@brief	清理状态
function MapEnenvtTornado:clearState()
    self.m_tCollisionCharas = {}
    self.m_tCollisionBullets = {}
end

--@brief 	设置当前的位置
--@param 	tPos 当前位置
function MapEnenvtTornado:setPosition(tPos)
	self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
end

--@brief 	获取当前的位置
--@return 	tPos 当前位置
function MapEnenvtTornado:getPosition()
	return self.m_anim:getPosition()
end

--@brief	添加圆形碰撞范围
--@param 	radius:半径
--@param 	xOffset,yOffset:x,y偏移量
--@note		偏移量的参考点是character的中心点
function MapEnenvtTornado:addCircleCollision(radius,xOffset,yOffset)
    if self.m_tCollisionRang == nil then
        self.m_tCollisionRang = {}
    end

    local tRang = CollisionRang:new()
    tRang.m_nType = 0
    tRang.m_fRadius = radius
    tRang.m_fXOffset = xOffset
    tRang.m_fYOffset = yOffset
    table.insert(self.m_tCollisionRang,tRang)
end

--@brief	添加矩形碰撞范围
--@param 	width,height:宽高
--@param 	xOffset,yOffset:x,y偏移量
--@note		偏移量的参考点是character的中心点
function MapEnenvtTornado:addRectCollision(width,height,xOffset,yOffset)
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

--@brief	清除碰撞区域
function MapEnenvtTornado:clearCollisionRang()
    self.m_tCollisionRang = nil
    if self.m_tCollisionTable ~= nil then
        for i,tTable in pairs(self.m_tCollisionTable) do
            tTable:removeFromParentAndCleanup(true)
        end
    end
    self.m_tCollisionTable = nil
end

--@brief	获得碰撞范围
--@return 	#1:碰撞范围
function MapEnenvtTornado:getCollisionRang()
    return self.m_tCollisionRang
end

--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function MapEnenvtTornado:getAnimation()
    return self.m_anim
end

--@brief	获取动画中心位置
--@return	#1:动画中心位置
function MapEnenvtTornado:getCenterPos()
    if self:getAnimation() == nil or self:getAnimation():getAnimNode() == nil then
        return(BattleCommon:getPointTable(0,0))
    end
    local size = self:getAnimation():getAnimNode():getContentSize()
    local animCenter = CCPointMake(0.5*size.width, 0.5*size.height)

    local toParentTranf = self:getAnimation():getAnimNode():nodeToParentTransform()
    animCenter=CCPointApplyAffineTransform(animCenter,toParentTranf)
    return animCenter
end

--@brief	以本表为模版，MapEnenvtTornado表为父表创建一个新的表实例对象
--@return	新建的表实例对象
function MapEnenvtTornado:new()
	setmetatable(MapEnenvtTornado,{__index = WCharacter})
	local tNewObj = {}
	setmetatable(tNewObj, {__index = MapEnenvtTornado})
	tNewObj:setType(CharacterType.TYPE_GUAI)
    	tNewObj:_init()
	return tNewObj
end

-------------------------------------私有方法模块--------------------------------------
