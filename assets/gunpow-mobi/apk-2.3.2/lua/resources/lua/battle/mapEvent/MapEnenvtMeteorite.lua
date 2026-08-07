--MapEnenvtMeteorite.lua
--@brief	地图事件陨石数据表
--@date		2014/8/25
--@author	莫剑峰
--@note		地图事件相关属性及操作

--@brief	地图事件数据表
MapEnenvtMeteorite = {
    ID = 3,      --id
    m_nType = 0,    --类型
    m_sName = "",   --名称
    m_nEffect1 = 0, --效果参数1
    m_nEffect2 = 0, --效果参数2
    m_nEffect3 = 0, --效果参数3

    m_tCollisionRang = nil, 			--碰撞检测范围表
    m_tCollisionTable = nil,			--碰撞圈
    m_anim = nil,                       --动画
    m_tCollisionCharas = {},            --碰撞到的英雄
    m_tCollisionBullets = {},           --碰撞到的子弹
    m_isProcessEnd = nil,               --是否已经处理
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个事件
--@return	#1:事件对象
function MapEnenvtMeteorite:buildEvent(weatherId, name, effect1, effect2)
	local mapEvent = MapEnenvtMeteorite:new()
    
    mapEvent.m_nType = weatherId
    mapEvent.m_sName = name
    mapEvent.m_nEffect1 = effect1
    mapEvent.m_nEffect2 = effect2
    
    local animRes = "tssj_ys"
    mapEvent.m_anim = nil
    mapEvent.m_anim = BattleAnimation:createAnimation(animRes, true)

    mapEvent.m_anim:getAnimNode():retain()
    SceneBattle:getFrontLayer():addChild(mapEvent.m_anim:getAnimNode(),100)

    --设置位置
    local firstPos = mapEvent:getFirstPosition()
    if firstPos == nil then
        mapEvent:destroy()
        return nil
    end
    SceneBattle.m_nMapEventShow = 3
    mapEvent.m_anim:setPosition(Vector2:create(firstPos.x + 120, firstPos.y + 200))

    mapEvent.m_anim:play("2",false)
    --mapEvent.m_anim:play("0",true,"tssj_ys_xw")
    mapEvent.m_anim:getAnimNode():setVisible(false)

    --设置碰撞范围
    mapEvent:setCollisionRange()

    --初始化状态
    mapEvent:clearState()

    WZLog("MapEnenvtMeteorite:buildEvent four")
	return mapEvent
end

--@brief 	设置碰撞范围
function MapEnenvtMeteorite:setCollisionRange()

    local size = self.m_anim:getAnimNode():getContentSize()
    local widthScale, heightScale = nil,nil
    local offset = nil

    widthScale, heightScale = 0.20, 0.262
    offset = GlobalMethod:ccp(-125, 0)
    self:addCircleCollision(size.width * widthScale,offset.x,offset.y)

    WZLog("MapEnenvtMeteorite:setCollisionRange", size.width, size.height)
end

--@brief 	获取初始的位置
--@return 	1:初始位置
function MapEnenvtMeteorite:getFirstPosition()

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
    end

    WZLog("MapEnenvtBubble:getFirstPosition one", math.abs(leftestPos - rightestPos))
    if BattleCommon:tableLen(heroList) <= 2 and math.abs(leftestPos - rightestPos) < 200 then
        return nil
    end

    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    local l = math.min(leftestPos + 100 , rightestPos - 100)
    local r = math.max(leftestPos + 100 , rightestPos - 100)
    local u = math.max(downPos + 40, upPos + 0)
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
function MapEnenvtMeteorite:destroy()
    WZLog("MapEnenvtMeteorite:destroy one", tostring(self.ID), tostring(self.m_sName))

    WCharacter.destroy(self)
    WZLog("MapEnenvtMeteorite:destroy two", tostring(self.m_anim:getAnimNode():getParent()))

    if self.m_anim:getAnimNode() ~= nil and self.m_anim:getAnimNode().removeFromParentAndCleanup ~= nil  and self.m_anim:getAnimNode():getParent() ~= nil then

        self.m_anim:getAnimNode():release()
        self.m_anim:getAnimNode():removeFromParentAndCleanup(false)
    end
    WZLog("MapEnenvtMeteorite:destroy three")
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
function MapEnenvtMeteorite:update(dt)
    --WZLog("MapEnenvtMeteorite:update")

    if self:getAnimation():isPlaying("2") == true then
        if self.m_anim.isCurrentAnimationDone ~= nil and self.m_anim:isCurrentAnimationDone() == true then
            self.m_anim:play("2",true)
            self.m_anim:getAnimNode():setVisible(true)
        end
    end

    if self.m_anim:getAnimNode():isVisible() == false then
        return
    end

	if false and self.m_tCollisionRang ~= nil and ProjConfig.DEBUG == 1 then
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
                --WZLog("MapEnenvtMeteorite:update two",animPos.x,animPos.y,tRang.m_fXOffset,tRang.m_fYOffset,tRang.m_fWidth,tRang.m_fHeight)
			end
		end
	end

    local isCollision, bulletList, heroList = self:checkCollision()
    if isCollision == true then
        self:eventProcess(bulletList, heroList)
    end

    if self:getAnimation():isPlaying("3") == true then
        if self.m_anim:getAnimNode():isVisible() == true and self.m_anim.isCurrentAnimationDone ~= nil and self.m_anim:isCurrentAnimationDone() == true then
            self.m_anim:getAnimNode():setVisible(false)
        end
    end
end

--@brief	事件处理
function MapEnenvtMeteorite:eventProcess(bulletList, heroList)
    WZLog("MapEnenvtMeteorite:eventProcess one", #bulletList, #heroList)

    local wind = WBattleGlobal:getCurrent():getWindLevel().x

    for i, bullet in pairs (bulletList) do
        WZLog("MapEnenvtMeteorite:eventProcess three", tostring(bullet), tostring(bullet:getIsExist()), tostring(bullet.m_bIsProcessMapEvent), tostring(bullet.m_bIsCollisionMapEvent))
        if self.m_isProcessEnd == true then
            break
        end

        if bullet:getIsExist() == true and bullet.m_bIsProcessMapEvent == false and bullet.m_bIsCollisionMapEvent == true then
            bullet.m_bIsProcessMapEvent = true
            self.m_isProcessEnd = true

            local battleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
            local playerId = bullet.m_ownerChara:getBattleId()
            local eventId = self.ID
            if bullet.m_ownerChara:isCanControl() then
                ProtocolProcessorBattleInterface:send_BATTLE_EventContact(battleId, playerId, eventId)
            end

            if self:getAnimation():isPlaying("2") == true and self.m_anim:getAnimNode():isVisible() == true then
                self.m_anim:play("3",false)
            end

            local turnTimes = WBattleGlobal:getCurrent():getTurnTimes()
            WBattleGlobal:getCurrent().m_nMeteoriteAttackTurn = turnTimes + 1
            WBattleGlobal:getCurrent().m_nMeteoriteAttackHurt = self.m_nEffect1
            WBattleGlobal:getCurrent().m_nMeteoriteAttackerId = playerId

            WZLog("MapEnenvtMeteorite:eventProcess four", turnTimes, WBattleGlobal:getCurrent().m_nMeteoriteAttackTurn)

            SceneBattle:mapEvenShow(5)
        end
    end
end

--@brief	检查碰撞
--@param	pos:位置
--@param	raduis:半径
--@param	charaList:列表
--@return	#1:true:撞了,false:没撞
--@return	#2:碰撞的人物列表
function MapEnenvtMeteorite:checkCollision()
	local isCollision = false

    local animPos = self.m_anim:getPosition()
    local collisionRang = self:getCollisionRang()

    --检测与子弹的碰撞
    local bullets = WBattleGlobal:getCurrent():getBulletsList()

    for id,bullet in pairs(bullets) do
		if bullet.m_bIsCollisionMapEvent == false then
            
			local bulletPos = bullet.m_mover:getMoverPosition()
			local bulletRaidus = 2

            if collisionRang ~= nil then
                for i,rang in pairs(collisionRang) do
                    if bullet.m_bIsCollisionMapEvent == false then
                        --圆形检测
                        if rang.m_nType == 0 then
                            local tmpCharaPos = Vector2:create(animPos.x + rang.m_fXOffset,animPos.y + rang.m_fYOffset)
                            if BattleCommon:checkCircleCollosion(bulletPos,bulletRaidus,tmpCharaPos,rang.m_fRadius) then

                                isCollision = true
                                bullet.m_bIsCollisionMapEvent = true
                                table.insert(self.m_tCollisionBullets, bullet)

                                local heroId = bullet.m_ownerChara:getId()
                                local isHeroExist = false
                                for j, hero in pairs(self.m_tCollisionCharas) do
                                if heroId == hero:getId() then
                                    isHeroExist = true
                                end
                                end

                                if isHeroExist == false then
                                    table.insert(self.m_tCollisionCharas, bullet.m_ownerChara)
                                end

                                WZLog("MapEnenvtMeteorite:checkCollision one", id, tostring(bullet), heroId, #self.m_tCollisionBullets, #self.m_tCollisionCharas)
                            end

                        --矩形检测
                        elseif rang.m_nType == 1 then

                            local rect = {x = animPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = animPos.y+rang.m_fYOffset - rang.m_fHeight*0.5,w = rang.m_fWidth,h=rang.m_fHeight}
                            local circle = {x = bulletPos.x,y=bulletPos.y,r = bulletRaidus}

                            if BattleCommon:rectCircleOverLap(rect,circle) then

                                isCollision = true
                                bullet.m_bIsCollisionMapEvent = true
                                table.insert(self.m_tCollisionBullets, bullet)

                                local heroId = bullet.m_ownerChara:getId()
                                local isHeroExist = false
                                for j, hero in pairs(self.m_tCollisionCharas) do
                                    if heroId == hero:getId() then
                                        isHeroExist = true
                                    end
                                end

                                if isHeroExist == false then
                                    table.insert(self.m_tCollisionCharas, bullet.m_ownerChara)
                                end

                                WZLog("MapEnenvtMeteorite:checkCollision two", id, tostring(bullet), heroId, #self.m_tCollisionBullets, #self.m_tCollisionCharas)
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
function MapEnenvtMeteorite:clearState()
    self.m_tCollisionCharas = {}
    self.m_tCollisionBullets = {}
end

--@brief 	设置当前的位置
--@param 	tPos 当前位置
function MapEnenvtMeteorite:setPosition(tPos)
	self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
end

--@brief 	获取当前的位置
--@return 	tPos 当前位置
function MapEnenvtMeteorite:getPosition()
	return self.m_anim:getPosition()
end

--@brief	添加圆形碰撞范围
--@param 	radius:半径
--@param 	xOffset,yOffset:x,y偏移量
--@note		偏移量的参考点是character的中心点
function MapEnenvtMeteorite:addCircleCollision(radius,xOffset,yOffset)
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
function MapEnenvtMeteorite:addRectCollision(width,height,xOffset,yOffset)
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
function MapEnenvtMeteorite:clearCollisionRang()
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
function MapEnenvtMeteorite:getCollisionRang()
    return self.m_tCollisionRang
end

--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function MapEnenvtMeteorite:getAnimation()
    return self.m_anim
end

--@brief	获取动画中心位置
--@return	#1:动画中心位置
function MapEnenvtMeteorite:getCenterPos()
    if self:getAnimation() == nil or self:getAnimation():getAnimNode() == nil then
        return(GlobalMethod:ccp(0,0))
    end
    local size = self:getAnimation():getAnimNode():getContentSize()
    local animCenter = CCPointMake(0.5*size.width, 0.5*size.height)

    local toParentTranf = self:getAnimation():getAnimNode():nodeToParentTransform()
    animCenter=CCPointApplyAffineTransform(animCenter,toParentTranf)
    return animCenter
end

--@brief	以本表为模版，MapEnenvtMeteorite表为父表创建一个新的表实例对象
--@return	新建的表实例对象
function MapEnenvtMeteorite:new()
	setmetatable(MapEnenvtMeteorite,{__index = WCharacter})
	local tNewObj = {}
	setmetatable(tNewObj, {__index = MapEnenvtMeteorite})
	tNewObj:setType(CharacterType.TYPE_GUAI)
    	tNewObj:_init()
	return tNewObj
end

-------------------------------------私有方法模块--------------------------------------
