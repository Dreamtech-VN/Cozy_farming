--BattlePointsLine.lua
--@brief	战斗路径指示线
--@date		2013/12/24
--@author	李俊鸿
--@note		准备发射及飞行时的路径指示线

--@brief	指示线数据表
BattlePointsLine = {
	m_tPoints = nil, --指示线中的点集合
	m_drawNode = nil,
    m_tStartPos = nil, --指示线的开始点
    m_tAcceleration = nil, --加速度
    m_tSpeed = nil , --速度
    m_tCurrentIndex = nil, --当前滚到那个点
    m_nPreIndex = nil,
    m_tPointPos = nil,
    m_tPointPosDelta = nil,
    POINT_TOTAL_SLICE = 20,
	POINT_MAX_A_RANGE = 600,
	POINT_MAX_B_RANGE = 300,
    POINT_MAX_C_RANGE = 200,
    m_nMaxHeight = 0,
    m_nMaxHeightIndex = 1,
	
	m_nCurFrontScale,
    m_nScale = 1,
    m_nCount = 20,
    m_bIsShow = nil,
    m_bIsRotate = nil,
    m_bisWrong = nil,
    m_tWrongSprite = nil,
    m_nZOrder = 0,
    m_nMiniRate = 0.15,
    m_tTarget = nil,
    m_nDisTarget = 80,
    m_bIsVisible = false,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一条指示线
--@return	#1:指示线数据表
function BattlePointsLine:create(node, nCount, imgName,scale, rotate, anchorPoint, isWrong, zOrder, target)
    BattlePointsLine.parabolaRange = {
        [1]=240,
        [2]=220,
        [3]=200,
        [4]=180,
        [5]=160,
        [6]=140,
        [7]=135,
        [8]=130,
        [9]=125,
        [10]=120,
        [11]=115,
        [12]=110,
        [13]=105,
    }

    BattlePointsLine.playerLevel = {
        [1]=5,
        [2]=10,
        [3]=12,
        [4]=15,
        [5]=18,
        [6]=20,
        [7]=23,
        [8]=25,
        [9]=28,
        [10]=30,
        [11]=35,
        [12]=40,
        [13]=45,
    }

    BattlePointsLine.parabolaRangeY = {
        [1]=100,
        [2]=90,
        [3]=80,
        [4]=70,
        [5]=60,
        [6]=55,
        [7]=50,
        [8]=45,
        [9]=40,
    }

    BattlePointsLine.countPlayerCount = {
        [1]=60,
        [2]=55,
        [3]=50,
        [4]=45,
        [5]=40,
        [6]=35,
        [7]=30,
        [8]=25,
        [9]=20,
    }

    BattlePointsLine.countPlayerLevel = {
        [1]=5,
        [2]=10,
        [3]=15,
        [4]=20,
        [5]=25,
        [6]=30,
        [7]=35,
        [8]=40,
        [9]=45,
    }

    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("image/ui/combat/point/lx_sprite.plist")

    imgName = imgName or "ui/combat/battle_icon_miaozhun.png"
    self.m_nScale = scale or self.m_nScale
    self.m_bIsRotate = rotate or self.m_bIsRotate
    self.m_bisWrong = isWrong
    local line = {}
	setmetatable(line, {__index = BattlePointsLine})
	line.m_tPoints = {}
    line.m_tPointPos = {}
    line.m_tPointPosDelta = {}
    line.m_tCurrentIndex = 0
    line.m_nPreIndex = 0
	--nCount = 20
    nCount = self:getCount()
    self.m_nCount = nCount
    line.m_tNode = node
    line.m_anchor = anchorPoint
    line.m_nPointStyle = WndBattleSetting:getLineStyleData()
    
    -- if AutoRunBattleGM_FATHER:isInList() then
    --     nCount = 50
    --     BattlePointsLine.POINT_TOTAL_SLICE = 50
    --     BattlePointsLine.m_nMiniRate = 0.4
    --     BattlePointsLine.POINT_MAX_A_RANGE = 2000
    --     BattlePointsLine.POINT_MAX_B_RANGE = 2000
    --     BattlePointsLine.POINT_MAX_C_RANGE = 2000
    -- end
	local endScale = 1/10
    line:createPointView(zOrder)
    self.m_tTarget = target

    local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId

    if mapId == 9999 or mapId == 10101 then
        self.m_nDisTarget = 55
    end

    WZLog("BattlePointsLine:create end")
	return line
end

function BattlePointsLine:createPointView(zOrder)
    if self.m_uBatchNode then
        self.m_uBatchNode:removeFromParentAndCleanup(true)
        self.m_uBatchNode = nil
    end
  
    self.m_tPoints = {}
    self.m_tPointPos = {}
    self.m_tPointPosDelta = {}
    nCount = self:getCount()
    if self.m_nPointStyle == 4 then
        self.m_uBatchNode = CCSpriteBatchNode:create("ui/combat/point/lx_sprite.png")
        self.m_tNode:addChild(self.m_uBatchNode, zOrder or self.m_nZOrder)
        
        for i = 1, nCount do
            local animFrames = CCArray:create()
            for k = 1, 10  do
                local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("UI_laxian_play_%d.png",k))
                animFrames:addObject(frame)
            end
            local ccs = CCSprite:createWithSpriteFrameName("UI_laxian_play_1.png")
            local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)
            local action =  CCRepeatForever:create(CCAnimate:create(animation))
            ccs:runAction(action)
            --local ccs = CCSprite:createWithTexture(self.m_uBatchNode:getTexture())
            ccs:setVisible(false)
            if self.m_anchor then
                ccs:setAnchorPoint(self.m_anchor)
            end
            local rate0 = (self.m_nCount - i + 1)/self.m_nCount
            local rate = rate0 * self.m_nScale
            if rate < BattlePointsLine.m_nMiniRate then
               rate = BattlePointsLine.m_nMiniRate
            end
            
            ccs:setScale(rate)
            WZLog("BattlePointsLine:create one-1", i, rate, rate0, self.m_nScale, tostring(scale), nCount)
            --ccs:setScale(0.75 - (0.75 - endScale) * ( i/ (nCount-1) ) )
            self.m_uBatchNode:addChild(ccs)
            WZLog("BattlePointsLine:create one-2")
            table.insert(self.m_tPoints, ccs)
            self.m_tPointPos[i] = {x = 0,y = 0}
            self.m_tPointPosDelta[i] = {x = 0,y = 0}
        end
    else
        imgName = string.format("ui/combat/lx_03%d.png",self.m_nPointStyle)
        self.m_uBatchNode = CCSpriteBatchNode:create(imgName)
        for i = 1, nCount do
            local ccs = CCSprite:createWithTexture(self.m_uBatchNode:getTexture())
            ccs:setVisible(false)
            if self.m_anchor then
                ccs:setAnchorPoint(self.m_anchor)
            end
            local rate0 = (self.m_nCount - i + 1)/self.m_nCount
            local rate = rate0 * self.m_nScale
            if rate < BattlePointsLine.m_nMiniRate then
               rate = BattlePointsLine.m_nMiniRate
            end
            if false and i == 4 and TeachGroup1.ISBATTLE then
                local wrong = CCSprite:create("ui/teach/common_icon_xsyd3.png")
                ccs:addChild(wrong)
                wrong:setVisible(false)
                self.m_tWrongSprite = wrong
            end
            ccs:setScale(rate)
            WZLog("BattlePointsLine:create two-1", i, rate, rate0, self.m_nScale, tostring(scale), nCount)
            --ccs:setScale(0.75 - (0.75 - endScale) * ( i/ (nCount-1) ) )
            self.m_uBatchNode:addChild(ccs)
            WZLog("BattlePointsLine:create two-2")
            table.insert(self.m_tPoints, ccs)
            self.m_tPointPos[i] = {x = 0,y = 0}
            self.m_tPointPosDelta[i] = {x = 0,y = 0}
        end
        WZLog("BattlePointsLine:create three-1")
        self.m_tNode:addChild(self.m_uBatchNode, zOrder or self.m_nZOrder)
        WZLog("BattlePointsLine:create three-2")
    end
end

--@brief	获取SceneBattle
--@return	tBattle: SceneBattle
function BattlePointsLine:getBattle()
	if SceneBattle.m_root then
		return SceneBattle
	elseif SceneTeachBattle.m_root then
		return SceneTeachBattle
	end
	return SceneBattle
end

--@brief    指示线闪烁
function BattlePointsLine:lingth()
    if self.m_nPointStyle == 4 then
        return
    end

    for i = 1, #self.m_tPoints do
        local ccs = self.m_tPoints[i]
        
        local fadein = CCFadeIn:create(0.5)
        local fadeout = CCFadeOut:create(0.5)
        local fadein2 = CCFadeIn:create(0.5)
        local fadeout2 = CCFadeOut:create(0.5)
        local fadein3 = CCFadeIn:create(0.5)
        local fadeout3 = CCFadeOut:create(0.5)
        local array = CCArray:create()
        array:addObject(fadeout)
        array:addObject(fadein)
        array:addObject(fadeout2)
        array:addObject(fadein2)
        array:addObject(fadeout3)
        array:addObject(fadein3)
        ccs:runAction(CCSequence:create(array))
    end
    
end

--@brief	设置指示线可见性
--@param	bVisible:是否可见
function BattlePointsLine:setVisible(bVisible)
	--[[
     for i = 1, #self.m_tPoints do
		local ccs = self.m_tPoints[i]
		ccs:setVisible(bVisible)
	end
     --]]
     self.m_bIsVisible = bVisible

    self:setBatchVisible(bVisible)

    --点数不一致修正
    if bVisible and self.m_nCount ~= self:getCount() then
        nCount = self:getCount()
        local endScale = 1/10
        if self.m_nCount < nCount then
            for i = self.m_nCount + 1, nCount do
                if not self.m_tPoints[i] then
                    if self.m_nPointStyle == 4 then
                        local animFrames = CCArray:create()
                        for k = 1, 10  do
                            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("UI_laxian_play_%d.png",k))
                            animFrames:addObject(frame)
                        end
                        local ccs = CCSprite:createWithSpriteFrameName("UI_laxian_play_1.png")
                        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)
                        local action =  CCRepeatForever:create(CCAnimate:create(animation))
                        ccs:runAction(action)

                        ccs:setVisible(false)
                       
                        local rate = (self.m_nCount - i + 1)/self.m_nCount
                        rate = rate * self.m_nScale
                        if rate < BattlePointsLine.m_nMiniRate then
                           rate = BattlePointsLine.m_nMiniRate
                        end
                        
                        ccs:setScale(rate)
                        --WZLog("BattlePointsLine:create", i, rate, nCount)
                        self.m_uBatchNode:addChild(ccs)
                        table.insert(self.m_tPoints, ccs)
                        self.m_tPointPos[i] = {x = 0,y = 0}
                        self.m_tPointPosDelta[i] = {x = 0,y = 0}
                    else
                        local ccs = CCSprite:createWithTexture(self.m_uBatchNode:getTexture())
                        ccs:setVisible(false)
                       
                        local rate = (self.m_nCount - i + 1)/self.m_nCount
                        rate = rate * self.m_nScale
                        if rate < BattlePointsLine.m_nMiniRate then
                           rate = BattlePointsLine.m_nMiniRate
                        end
                        
                        ccs:setScale(rate)
                        --WZLog("BattlePointsLine:create", i, rate, nCount)
                        self.m_uBatchNode:addChild(ccs)
                        table.insert(self.m_tPoints, ccs)
                        self.m_tPointPos[i] = {x = 0,y = 0}
                        self.m_tPointPosDelta[i] = {x = 0,y = 0}
                    end
                end
            end
        else
            for i = self.m_nCount , nCount + 1,-1 do
                if self.m_tPoints[i] then
                    local css = self.m_tPoints[i]
                    self.m_uBatchNode:removeChild(css,true)
                    table.remove(self.m_tPoints,i)
                end
            end
        end
        self.m_nCount = nCount
    end


	if self.m_drawNode then
		self.m_drawNode:setVisible(bVisible)
	end
	if false and bVisible and self.m_nCurFrontScale then
		local heroPos = WBattleGlobal:getCurrent():getMyHero():getPosition()

		local increaseScale = self.m_nCurFrontScale - SceneBattle:getFrontLayer():getScaleX()
		if increaseScale > 0.05 then
			BattleMapManager:getFrontControl():zoomToPoint(heroPos,SceneBattle:getFrontLayer():getScaleX() + 0.005, true)
		elseif increaseScale < -0.05 then
			BattleMapManager:getFrontControl():zoomToPoint(heroPos, SceneBattle:getFrontLayer():getScaleX() - 0.005, true)
		end
        -- --WZLog("BattlePointsLine:setVisible one", self.m_nCurFrontScale, SceneBattle:getFrontLayer():getScaleX(), increaseScale)
	end
end

function BattlePointsLine:addPoint()
end

function BattlePointsLine:removePoint()
    -- body
end

function BattlePointsLine:isVisible()
    return self.m_uBatchNode:isVisible()
end


function BattlePointsLine:setBatchVisible(value)
     if self.m_uBatchNode then
        self.m_uBatchNode:setVisible(value)
    end
end

--@brief	每帧更新的操作
--@param	dt:帧间时间
function BattlePointsLine:updateDt(dt)

    if not self:isVisible() then
        if self.m_tBigSkillAnim ~= nil then
            self.m_tBigSkillAnim:getAnimNode():setVisible(false)
        end
        return
    end

    self.m_tCurrentIndex = self.m_tCurrentIndex + 1
    if self.m_tCurrentIndex >= BattlePointsLine.POINT_TOTAL_SLICE then
        self.m_tCurrentIndex = 0
    end
    --self:updateLine()
    --[[local startPos = WBattleGlobal:getCurrent():getMyHero():getPosition()
    startPos.y = startPos.y + 200
    local point = CCAutoPoint:create(startPos.x, startPos.y)
    point = BattlePointsLine:getBattle():getFrontLayer():convertToWorldSpaceAuto(point)
    startPos = self.m_tPoints[1]:getParent():convertToNodeSpaceAuto(point)
    --]]
    local pos = {x = 0, y = 0}
    for i = 1,#self.m_tPoints do
        pos.x = self.m_tPointPos[i].x + self.m_tPointPosDelta[i].x*self.m_tCurrentIndex
        pos.y = self.m_tPointPos[i].y + self.m_tPointPosDelta[i].y*self.m_tCurrentIndex
		self.m_tPoints[i]:setPosition(pos.x, pos.y)
    end
end

--@brief    更新抛物线的坐标
--@return	是否成功更新
function BattlePointsLine:updateLinePos()
	if self.m_tStartPos == nil or self.m_tAcceleration == nil or self.m_tSpeed == nil then
       return false
    end
    if self.m_tMover == nil then
        self.m_tMover = BattleMoverPosition:create()
    end
    local mover = self.m_tMover
    mover:setPosition({x = self.m_tStartPos.x,y = self.m_tStartPos.y})
    mover:setSpeed({x = self.m_tSpeed.x,y = self.m_tSpeed.y})
    mover:setAcceleration({x = self.m_tAcceleration.x,y = self.m_tAcceleration.y})

    self.m_nMaxHeight = 0
    self.m_nMaxHeightIndex = 1
    --更新位置
    for i = 1,#self.m_tPoints + 1 do
        self.m_tPointPos[i] = mover:getPosition()

        local point = CCAutoPoint:create(self.m_tPointPos[i].x, self.m_tPointPos[i].y)
        point = BattlePointsLine:getBattle():getFrontLayer():convertToWorldSpaceAuto(point)
        
        point = self.m_uBatchNode:convertToNodeSpaceAuto(point)
        self.m_tPointPos[i].x,self.m_tPointPos[i].y = point.x,point.y
        if i <= #self.m_tPoints then
            self.m_tPoints[i]:setPosition(point.x, point.y)
            -- --WZLog("BattlePointsLine:updateLinePos one", i, point.x, point.y)
            if point.y > self.m_nMaxHeight then
                self.m_nMaxHeight = point.y
                self.m_nMaxHeightIndex = i
                -- --WZLog("BattlePointsLine:updateLinePos two", i, point.x, point.y)
            end
        end

        if i > 1 then
            local pos = {x = 0,y = 0}
            pos.x = (self.m_tPointPos[i].x - self.m_tPointPos[i-1].x)/BattlePointsLine.POINT_TOTAL_SLICE
            pos.y = (self.m_tPointPos[i].y - self.m_tPointPos[i-1].y)/BattlePointsLine.POINT_TOTAL_SLICE
            self.m_tPointPosDelta[i-1] = pos
        end
        local firstPos = mover:getPosition()
        local lastPos = mover:getPosition()
        while BattleCommon:pointDis(firstPos,lastPos) < 20 
        do 
            mover:updatePosition()
            lastPos = mover:getPosition()
        end
        --mover:updatePosition()
        --mover:updatePosition()
        --mover:updatePosition()
    end
	return true
end

--@brief    更新抛物线显示
function BattlePointsLine:updateLine(scale)
    if self:updateLinePos() then
        local hero = WBattleGlobal:getCurrent():getMyHero()

        -- --WZLog("BattlePointsLine:updateLine zero",self.m_nScale)
		--更新显示
		local startPos = WBattleGlobal:getCurrent():getMyHero():getPosition()
		startPos.y = startPos.y + 0
		local point = CCAutoPoint:create(startPos.x, startPos.y)
		point = BattlePointsLine:getBattle():getFrontLayer():convertToWorldSpaceAuto(point)
       
        startPos = self.m_uBatchNode:getParent():convertToNodeSpaceAuto(point) 
        local aLen,bLen = self:getEllipseRange()
		local last = 0

		local _maxDis = 0
		--for i = #self.m_tPoints,1,-1 do
        for i = 1,#self.m_tPoints,1 do
			local ccs = self.m_tPoints[i]
			local checkPos = {}
			checkPos.x , checkPos.y = ccs:getPosition()
			_maxDis = math.max(_maxDis , ( math.abs(checkPos.x - startPos.x) + math.abs(checkPos.y - startPos.y))/2 )
            -- --WZLog("BattlePointsLine:updateLine one", checkPos.y, startPos.y, checkPos.x, startPos.x, aLen, bLen )

            aLen,bLen = self:getVisibleRange()
            local isInVisibleRange = self:isInVisibleRange(startPos, checkPos, aLen, bLen, i)
            if isInVisibleRange == true and i < #self.m_tPoints then
                --print("BattlePointsLine:updateLine two",i, #self.m_tPoints, checkPos.y, startPos.y, checkPos.x, startPos.x, aLen, bLen)
            elseif isInVisibleRange == false or i == #self.m_tPoints then
                --self.m_bIsShow = true
                --print("BattlePointsLine:updateLine three",i, tostring(isInVisibleRange), #self.m_tPoints, checkPos.y, startPos.y, checkPos.x, startPos.x, aLen, bLen)
                if last == 0 then
                    last = i - 1
                end
                ccs:setVisible(false)

                -- --WZLog("BattlePointsLine:updateLine", last)
                local isNearTarget = false
                for i = #self.m_tPoints,1,-1 do
                    local ccs = self.m_tPoints[i]
                    if i >= last then
                        ccs:setVisible(false)
                    else
                        if self.m_bIsRotate then
                            --[[
                            local rotatin = 0
                            if self.m_tSpeed.x < 0 then
                                rotatin = (-90 - i * 3 * (self.m_tSpeed.y / self.m_tSpeed.x))
                            elseif self.m_tSpeed.x > 0 then
                                rotatin = (0 + i * 3 * (self.m_tSpeed.y / self.m_tSpeed.x))
                            end
                            ccs:setRotation(rotatin)
                            --print("BattlePointsLine:updateLine rotatin")
                            --]]
                        end
                        if self.m_bisWrong == true then
                            ccs:setColor(GlobalMethod:ccc3(255,0,0))
                            if self.m_tWrongSprite then
                                -- --WZLog("BattlePointsLine:updateLine end")
                                self.m_tWrongSprite:setVisible(true)
                            end
                        elseif self.m_bisWrong == false then
                            ccs:setColor(GlobalMethod:ccc3(0,255,0))
                        end
                        ccs:setVisible(true)
                        local rate = (self.m_nCount - i + 1)/self.m_nCount
                        rate = rate * (scale or self.m_nScale)
                        if rate < BattlePointsLine.m_nMiniRate then
                        rate = BattlePointsLine.m_nMiniRate
                        end
                        ccs:setScale(rate)

                        if self.m_tTarget and isNearTarget == false then
                            local x, y = ccs:getPosition()
                            local pointPos = BattleCommon:getPointTable(x, y)
                            local dis = BattleCommon:pointDis(pointPos, self.m_tTarget)
                            --WZLog("BattlePointsLine:updateLine", i, dis , tostring(pointPos.x), tostring(pointPos.y), tostring(self.m_tTarget.x), tostring(self.m_tTarget.y))
                            if dis <= self.m_nDisTarget then
                                isNearTarget = true
                            end

                            if isNearTarget then
                                for j = 1,#self.m_tPoints,1 do
                                    if j >= i then
                                        self.m_tPoints[j]:setVisible(false)
                                    end
                                end
                            end
                        end

                    end
                end
                break
            end
        end
		_maxDis = _maxDis/400
		self.m_nCurFrontScale = BattleMapManager:getFrontControl():getZoomInInit() - _maxDis
	end
end

function BattlePointsLine:getVisibleRange()
    local aNormal = BattlePointsLine.POINT_MAX_A_RANGE * self:getBattle():getFrontLayer():getScale() * 1.5
    local bNormal = BattlePointsLine.POINT_MAX_C_RANGE * self:getBattle():getFrontLayer():getScale() * 1.5
    local aLen,bLen = aNormal,bNormal
    local aLenT,bLenT = WBattleGlobal:getCurrent():getMyHero():getAddPointLineVisibleRange()
    local level = WBattleGlobal:getCurrent():getMyHero().m_nRealLevel

    local x,y
    for i=1,#BattlePointsLine.playerLevel do
        aLen = aNormal * BattlePointsLine.parabolaRange[i] * 0.01
        x = BattlePointsLine.parabolaRange[i]
        if BattlePointsLine.playerLevel[i] > level then
            break
        end
    end

    for i=1,#BattlePointsLine.countPlayerLevel do
        bLen = BattlePointsLine.parabolaRangeY[i] * bNormal * 0.01
        y = BattlePointsLine.parabolaRangeY[i]
        if BattlePointsLine.countPlayerLevel[i] >= level then
            break
        end
    end

    --WZLog("BattlePointsLine:getVisibleRange", level, x, y, aLen, bLen)
    return aLen + aLenT,bLen + bLenT
end

function BattlePointsLine:getCount()
    local count = 20
    local level = WBattleGlobal:getCurrent():getMyHero().m_nRealLevel
    local countT = WBattleGlobal:getCurrent():getMyHero():getAddPointLineCount()
    if countT == 0 and WBattleGlobal:getCurrent():getMyHero():isFog() and not (WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_GS and WBattleGlobal:getCurrent():getMyHero():getCamp() == 1) then 
        count = 5
    else
        for i=1,#BattlePointsLine.countPlayerLevel do
            count = BattlePointsLine.countPlayerCount[i]
            if BattlePointsLine.countPlayerLevel[i] >= level then
                break
            end
        end
    end
    --WZLog("BattlePointsLine:getCount", level, count)
    return count + countT
end

--@brief	更新指示线位置及路径
--@param	tPos:指示线起点位置
--@param	tSpeed:指示线移动速度
--@param	tAcceleration:指示线移动加速度
--#return   #1,true 更新了 false 没有更新
function BattlePointsLine:update(tPos, tSpeed, tAcceleration, scale)
    if self.m_tStartPos ~= nil and self.m_tSpeed ~= nil and BattleCommon:pointLen(self.m_tStartPos,tPos) < 0.1 and BattleCommon:pointLen(self.m_tSpeed,tSpeed) < 0.1 then
        return false
    end
    --print("BattlePointsLine:update", tostring(self.m_tStartPos and self.m_tStartPos.x), tostring(self.m_tStartPos and self.m_tStartPos.y), tPos.x, tPos.y)
    self.m_nPreIndex = curIndex
    self.m_tStartPos = tPos
    self.m_tAcceleration = tAcceleration
    self.m_tSpeed = tSpeed

    -- if AutoRunBattleGM_FATHER:isInList() then
    --    self.m_tAcceleration = BattleCommon:pointAdd(BattleConstants.g_nFlyGravity,WBattleGlobal:getCurrent():getWind())
    -- end

    if WBattleGlobal:getCurrent():getMyHero().m_tAttributeChangeStateList.m_nPointLineValue or WBattleGlobal:getCurrent():isWindTeach() then
        self.m_tAcceleration = BattleCommon:pointAdd(BattleConstants.g_nFlyGravity,WBattleGlobal:getCurrent():getWind())
    end
    self:updateLine(scale)

    return true
end

--@brief	更新指示线位置及路径（教学用）
--@param	tPos:指示线起点位置
--@param	tSpeed:指示线移动速度
--@param	tAcceleration:指示线移动加速度
function BattlePointsLine:updateInTeach(tPos, tSpeed, tAcceleration)
    self.m_tStartPos = tPos
    self.m_tAcceleration = tAcceleration
    self.m_tSpeed = tSpeed
    self:updateLinePos()
	for i = 1,#self.m_tPoints  do
		self.m_tPoints[i]:setVisible(true)
	end
end


function BattlePointsLine:getEllipseRange()
    local aNormal = BattlePointsLine.POINT_MAX_A_RANGE * self:getBattle():getFrontLayer():getScale() * 1.5
    local bNormal = BattlePointsLine.POINT_MAX_B_RANGE * self:getBattle():getFrontLayer():getScale() * 1.5
    local aLen,bLen = aNormal,bNormal
    if BattlePointsLine.playerLevel and BattlePointsLine.parabolaRange then
        local level = 1
        for i=1,WBattleGlobal:getCurrent().m_tMakePairOk.playerCount do
            if WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i] == WBattleGlobal:getCurrent():getMyHero():getBattleId() then
                level = WBattleGlobal:getCurrent().m_tMakePairOk.playerLevel[i]
                break
            end
        end
        for i=1,#BattlePointsLine.playerLevel do
            -- --WZLog("BattlePointsLine:getEllipseRange", BattlePointsLine.parabolaRange[i], BattlePointsLine.playerLevel[i], level)
            aLen,bLen = aNormal * BattlePointsLine.parabolaRange[i] * 0.01 , bNormal * BattlePointsLine.parabolaRange[i] * 0.01
            if BattlePointsLine.playerLevel[i] > level then
                break
            end
        end
    end
    return aLen,bLen
end

function BattlePointsLine:isInEllipse(startPos,checkPos,aLen,bLen, index)
	if BattleCommon:isInEllipse(checkPos,{x = startPos.x , y = startPos.y , a = aLen, b=bLen }) then
        --print("BattlePointsLine:isInEllipse one-1", index, startPos.x, checkPos.x, startPos.y, checkPos.y, aLen, bLen, self.m_nMaxHeight)
		return true
	end
    --print("BattlePointsLine:isInEllipse one-2", index, startPos.x, checkPos.x, startPos.y, checkPos.y, aLen, bLen, self.m_nMaxHeight)
	return false
end

--@brief    在节点附近画一个椭圆
--@param    tCenter2 圆心
--@param    tEllipse {x = 0,y = 0,a = 1,b = 1} 椭圆信息
--@param    tColor 颜色
function BattlePointsLine:addEllipse(tEllipse,tColor)
    tColor = tColor or {r = 1.0,g = 0,b = 0,a = 1.0}
    local drawNode = CCDrawNode:create()
    local p2 = GlobalMethod:ccp(0,0)
    local color = ccc4f(tColor.r, tColor.g, tColor.b, tColor.a)
    local x = -tEllipse.a
    repeat
        p2.x = x
        p2.y = math.sqrt(math.pow(tEllipse.b,2)*(1 - math.pow(x,2)/math.pow(tEllipse.a,2)))
        drawNode:drawDot(p2, 1, color)
        p2.y = -p2.y
        drawNode:drawDot(p2, 1, color)
        x = x + 1
    until x > tEllipse.a
    drawNode:setPosition(tEllipse.x,tEllipse.y)
    self.m_tPoints[1]:getParent():addChild(drawNode)
    self.m_drawNode = drawNode
end

function BattlePointsLine:isInVisibleRange(startPos, checkPos, length, length2, index)
    if length == nil then
        return nil
    end

    local dis = BattleCommon:pointDis(startPos,checkPos)
    --print("BattlePointsLine:isInVisibleRange one-1", index, startPos.x, checkPos.x, startPos.y, checkPos.y, dis, length, length2)

	if dis < length then

        local linePos = WBattleGlobal:getCurrent():getMyHero():getPosition()
        local offset = {x=linePos.x+0,y=linePos.y+20}
        local point = CCAutoPoint:create(offset.x, offset.y)
        point = BattlePointsLine:getBattle():getFrontLayer():convertToWorldSpaceAuto(point)
       
        offset = self.m_uBatchNode:getParent():convertToNodeSpaceAuto(point)

        -- --WZLog("BattlePointsLine:isInVisibleRange one-2", offset.y, self.m_nMaxHeightIndex, index)

        if  false and checkPos.y >= offset.y  then
            if self.m_nMaxHeightIndex >= 1 and index > self.m_nMaxHeightIndex and self.m_nMaxHeight > startPos.y then
                -- --WZLog("BattlePointsLine:isInVisibleRange two-0",startPos.y, checkPos.y, self.m_nMaxHeight)
                if checkPos.y - (startPos.y + 0) < (self.m_nMaxHeight - (startPos.y + 0)) * 0.5  then
                    --print("BattlePointsLine:isInVisibleRange two-1")
                    return  false
                else
                    --print("BattlePointsLine:isInVisibleRange three-0")
                    return  true
                end
            else
                --print("BattlePointsLine:isInVisibleRange three-1")
                return true
            end
        else
            if startPos.y - checkPos.y >= length2 then
                --print("BattlePointsLine:isInVisibleRange two-2", index)
                return false
            else
                --print("BattlePointsLine:isInVisibleRange three-2", index)
                return  true
            end
        end
	end
    --print("BattlePointsLine:isInVisibleRange three-4", index)
    return false
end

---[[

--@brief    在节点附近画一个圆
--@param    tCenter2 圆心
--@param    nRadius 半径
--@param    tColor 颜色
function BattlePointsLine:addCircle(tCenter2,nRadius,tColor)
    tColor = tColor or {r = 1.0,g = 0,b = 0,a = 1.0}
    local drawNode = CCDrawNode:create()
    local p1 = GlobalMethod:ccp(0,0)
    local p2 = GlobalMethod:ccp(0,0)
    local color = ccc4f(tColor.r, tColor.g, tColor.b, tColor.a)
    --for (float angle = 0; angle <= 2 * M_PI; angle += 0.01)
    --{
    local angle = 0
    repeat
        p2.x = nRadius * math.cos(angle)
        p2.y = nRadius * math.sin(angle)
        WZLog(p2.x,p2.y)
        drawNode:drawDot(p2, 1, color)
        angle = angle + 0.01
    until angle > 2*math.pi
    drawNode:setPosition(tCenter2.x,tCenter2.y)
    self.m_tPoints[1]:getParent():addChild(drawNode)
	self.m_drawNode = drawNode
end
--]]

--@brief    设置目标
function BattlePointsLine:setTarget(target)
    if self.m_tTarget == nil or self.m_tTarget.x ~= target.x or self.m_tTarget.y ~= target.y then
        self.m_tTarget = target
    end
end

--brief 刷新显示
function BattlePointsLine:checkLineView()
    if self.m_nPointStyle ~= WndBattleSetting:getLineStyleData() then
        self.m_nPointStyle = WndBattleSetting:getLineStyleData()
        if self.m_uBatchNode then
            self.m_uBatchNode:removeFromParentAndCleanup(true)
            self.m_uBatchNode = nil
        end
        self:createPointView()
    end
end

function BattlePointsLine:destroy()
    WZLog("BattlePointsLine:destroy", tostring(self.m_drawNode), tostring(self.m_tPoints and #self.m_tPoints), tostring(self.m_uBatchNode))
    CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("image/ui/combat/point/lx_sprite.plist")
    if self.m_drawNode then
        self.m_drawNode:removeFromParentAndCleanup(true)
        self.m_drawNode = nil
    end

    if self.m_tPoints then
        for k,v in pairs(self.m_tPoints) do
            v:removeFromParentAndCleanup(true)
        end
    end

    if self.m_uBatchNode then
        self.m_uBatchNode:removeFromParentAndCleanup(true)
        self.m_uBatchNode = nil
    end

end
-------------------------------------私有方法模块--------------------------------------



















