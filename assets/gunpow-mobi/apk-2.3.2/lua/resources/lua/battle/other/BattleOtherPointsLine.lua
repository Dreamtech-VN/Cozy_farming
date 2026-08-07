--BattleOtherPointsLine.lua
--@brief	战斗外路径指示线
--@date		2018/5/30
--@author	莫剑峰
--@note		准备发射及飞行时的路径指示线

--@brief	指示线数据表
BattleOtherPointsLine = {
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
    m_nRealLevel = 50,
    m_nVisibleCount = nil,  --可见点的数量
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一条指示线
--@return	#1:指示线数据表
function BattleOtherPointsLine:create(node, nCount, imgName,scale, rotate, anchorPoint, isWrong, zOrder, target, object, rect, winRect)
    BattleOtherPointsLine.parabolaRange = {
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

    BattleOtherPointsLine.playerLevel = {
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

    BattleOtherPointsLine.parabolaRangeY = {
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

    BattleOtherPointsLine.countPlayerCount = {
        [1]=60,
        [2]=55,
        [3]=50,
        [4]=45,
        [5]=40,
        [6]=35,
        [7]=30,
        [8]=25,
        [9]=10,
    }

    BattleOtherPointsLine.countPlayerLevel = {
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

    BattleOtherPointsLine:setBattleLayer(object)
    self.m_tRect = rect
    self.m_tWinRect = winRect
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("image/ui/combat/point/lx_sprite.plist")

    imgName = imgName or "ui/combat/battle_icon_miaozhun.png"
    self.m_nScale = scale or self.m_nScale
    self.m_bIsRotate = rotate or self.m_bIsRotate
    self.m_bisWrong = isWrong
    local line = {}
	setmetatable(line, {__index = BattleOtherPointsLine})
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
    --     BattleOtherPointsLine.POINT_TOTAL_SLICE = 50
    --     BattleOtherPointsLine.m_nMiniRate = 0.4
    --     BattleOtherPointsLine.POINT_MAX_A_RANGE = 2000
    --     BattleOtherPointsLine.POINT_MAX_B_RANGE = 2000
    --     BattleOtherPointsLine.POINT_MAX_C_RANGE = 2000
    -- end
	local endScale = 1/10
    line:createPointView(zOrder)
    self.m_tTarget = target

    WZLog("BattleOtherPointsLine:create end")
	return line
end

function BattleOtherPointsLine:createPointView(zOrder)
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
            if rate < BattleOtherPointsLine.m_nMiniRate then
               rate = BattleOtherPointsLine.m_nMiniRate
            end
            
            ccs:setScale(rate)
            WZLog("BattleOtherPointsLine:create one-1", i, rate, rate0, self.m_nScale, tostring(scale), nCount)
            --ccs:setScale(0.75 - (0.75 - endScale) * ( i/ (nCount-1) ) )
            self.m_uBatchNode:addChild(ccs)
            WZLog("BattleOtherPointsLine:create one-2")
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
            if rate < BattleOtherPointsLine.m_nMiniRate then
               rate = BattleOtherPointsLine.m_nMiniRate
            end
            ccs:setScale(rate)
            WZLog("BattleOtherPointsLine:create two-1", i, rate, rate0, self.m_nScale, tostring(scale), nCount)
            --ccs:setScale(0.75 - (0.75 - endScale) * ( i/ (nCount-1) ) )
            self.m_uBatchNode:addChild(ccs)
            WZLog("BattleOtherPointsLine:create two-2")
            table.insert(self.m_tPoints, ccs)
            self.m_tPointPos[i] = {x = 0,y = 0}
            self.m_tPointPosDelta[i] = {x = 0,y = 0}
        end
        WZLog("BattleOtherPointsLine:create three-1")
        self.m_tNode:addChild(self.m_uBatchNode, zOrder or self.m_nZOrder)
        WZLog("BattleOtherPointsLine:create three-2")
    end
end

--@brief	获取SceneBattle
--@return	tBattle: SceneBattle
function BattleOtherPointsLine:getBattle()
	return self.m_tLayer
end

function BattleOtherPointsLine:setBattleLayer(layer)
    self.m_tLayer = layer
end

--@brief    指示线闪烁
function BattleOtherPointsLine:lingth()
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
function BattleOtherPointsLine:setVisible(bVisible)
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
                        if rate < BattleOtherPointsLine.m_nMiniRate then
                           rate = BattleOtherPointsLine.m_nMiniRate
                        end
                        
                        ccs:setScale(rate)
                        --WZLog("BattleOtherPointsLine:create", i, rate, nCount)
                        self.m_uBatchNode:addChild(ccs)
                        table.insert(self.m_tPoints, ccs)
                        self.m_tPointPos[i] = {x = 0,y = 0}
                        self.m_tPointPosDelta[i] = {x = 0,y = 0}
                    else
                        local ccs = CCSprite:createWithTexture(self.m_uBatchNode:getTexture())
                        ccs:setVisible(false)
                       
                        local rate = (self.m_nCount - i + 1)/self.m_nCount
                        rate = rate * self.m_nScale
                        if rate < BattleOtherPointsLine.m_nMiniRate then
                           rate = BattleOtherPointsLine.m_nMiniRate
                        end
                        
                        ccs:setScale(rate)
                        --WZLog("BattleOtherPointsLine:create", i, rate, nCount)
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
end

function BattleOtherPointsLine:addPoint()
end

function BattleOtherPointsLine:removePoint()
    -- body
end

function BattleOtherPointsLine:isVisible()
    return self.m_uBatchNode:isVisible()
end


function BattleOtherPointsLine:setBatchVisible(value)
     if self.m_uBatchNode then
        self.m_uBatchNode:setVisible(value)
    end
end

--@brief	每帧更新的操作
--@param	dt:帧间时间
function BattleOtherPointsLine:updateDt(dt)

    if not self:isVisible() then
        if self.m_tBigSkillAnim ~= nil then
            self.m_tBigSkillAnim:getAnimNode():setVisible(false)
        end
        return
    end

    self.m_tCurrentIndex = self.m_tCurrentIndex + 1
    if self.m_tCurrentIndex >= BattleOtherPointsLine.POINT_TOTAL_SLICE then
        self.m_tCurrentIndex = 0
    end

    local pos = {x = 0, y = 0}
    for i = 1,#self.m_tPoints do
        pos.x = self.m_tPointPos[i].x + self.m_tPointPosDelta[i].x*self.m_tCurrentIndex
        pos.y = self.m_tPointPos[i].y + self.m_tPointPosDelta[i].y*self.m_tCurrentIndex
		self.m_tPoints[i]:setPosition(pos.x, pos.y)
    end
end

--@brief    更新抛物线的坐标
--@return	是否成功更新
function BattleOtherPointsLine:updateLinePos()
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
        WZLog("BattleOtherPointsLine:updateLinePos", tostring(self:getBattle()), tostring(self:getBattle() and self:getBattle():getFrontLayer()))
        local battle = self:getBattle():getFrontLayer():convertToWorldSpaceAuto(point)

        point = self.m_uBatchNode:convertToNodeSpaceAuto(point)
        self.m_tPointPos[i].x,self.m_tPointPos[i].y = point.x,point.y
        if i <= #self.m_tPoints then
            self.m_tPoints[i]:setPosition(point.x, point.y)
            -- --WZLog("BattleOtherPointsLine:updateLinePos one", i, point.x, point.y)
            if point.y > self.m_nMaxHeight then
                self.m_nMaxHeight = point.y
                self.m_nMaxHeightIndex = i
                -- --WZLog("BattleOtherPointsLine:updateLinePos two", i, point.x, point.y)
            end
        end

        if i > 1 then
            local pos = {x = 0,y = 0}
            pos.x = (self.m_tPointPos[i].x - self.m_tPointPos[i-1].x)/BattleOtherPointsLine.POINT_TOTAL_SLICE
            pos.y = (self.m_tPointPos[i].y - self.m_tPointPos[i-1].y)/BattleOtherPointsLine.POINT_TOTAL_SLICE
            self.m_tPointPosDelta[i-1] = pos
        end
        local firstPos = mover:getPosition()
        local lastPos = mover:getPosition()
        while BattleCommon:pointDis(firstPos,lastPos) < 20 do 
            mover:updatePosition()
            lastPos = mover:getPosition()
        end
    end
	return true
end

--@brief    更新抛物线显示
function BattleOtherPointsLine:updateLine(scale)
    if self:updateLinePos() then
        -- --WZLog("BattleOtherPointsLine:updateLine zero",self.m_nScale)
		--更新显示
		local startPos = self.m_tStartPos
		startPos.y = startPos.y + 0
		local point = CCAutoPoint:create(startPos.x, startPos.y)
		point = self:getBattle():getFrontLayer():convertToWorldSpaceAuto(point)
       
        startPos = self.m_uBatchNode:getParent():convertToNodeSpaceAuto(point) 
		local last = 0

		local _maxDis = 0
		--for i = #self.m_tPoints,1,-1 do
        for i = 1,#self.m_tPoints,1 do
			local ccs = self.m_tPoints[i]
			local checkPos = {}
			checkPos.x , checkPos.y = ccs:getPosition()
			_maxDis = math.max(_maxDis , ( math.abs(checkPos.x - startPos.x) + math.abs(checkPos.y - startPos.y))/2 )

            local isInVisibleRange = true --self:isInVisibleRange(startPos, checkPos, aLen, bLen, i)
            if isInVisibleRange == true and i < #self.m_tPoints then
                --print("BattleOtherPointsLine:updateLine two",i, #self.m_tPoints, checkPos.y, startPos.y, checkPos.x, startPos.x, aLen, bLen)
            elseif isInVisibleRange == false or i == #self.m_tPoints then
                --self.m_bIsShow = true
                --print("BattleOtherPointsLine:updateLine three",i, tostring(isInVisibleRange), #self.m_tPoints, checkPos.y, startPos.y, checkPos.x, startPos.x, aLen, bLen)
                if last == 0 then
                    last = i - 1
                end
                ccs:setVisible(false)

                -- --WZLog("BattleOtherPointsLine:updateLine", last)
                local isNearTarget = false
                for i = #self.m_tPoints,1,-1 do
                    local ccs = self.m_tPoints[i]
                    if false and i >= last then
                        ccs:setVisible(false)
                    else
                        if self.m_nVisibleCount == nil or (self.m_nVisibleCount and i <= self.m_nVisibleCount) then
                            ccs:setVisible(true)
                        else
                            ccs:setVisible(false)
                        end
                        local rate = (self.m_nCount - i + 1)/self.m_nCount
                        rate = rate * (scale or self.m_nScale)
                        if rate < BattleOtherPointsLine.m_nMiniRate then
                        rate = BattleOtherPointsLine.m_nMiniRate
                        end
                        ccs:setScale(rate)

                        if self.m_tTarget and isNearTarget == false then
                            local x, y = ccs:getPosition()
                            local pointPos = BattleCommon:getPointTable(x, y)
                            local dis = BattleCommon:pointDis(pointPos, self.m_tTarget)
                            --WZLog("BattleOtherPointsLine:updateLine", i, dis , tostring(pointPos.x), tostring(pointPos.y), tostring(self.m_tTarget.x), tostring(self.m_tTarget.y))
                            if dis <= self.m_nDisTarget then
                                isNearTarget = true
                            end

                            -- if isNearTarget then
                            --     for j = 1,#self.m_tPoints,1 do
                            --         if j >= i then
                            --             self.m_tPoints[j]:setVisible(false)
                            --         end
                            --     end
                            -- end
                        end

                    end
                end
                break
            end
        end
		_maxDis = _maxDis/400
	end
end

function BattleOtherPointsLine:getVisibleRange()
    local aNormal = BattleOtherPointsLine.POINT_MAX_A_RANGE * self:getBattle():getFrontLayer():getScale() * 1.5
    local bNormal = BattleOtherPointsLine.POINT_MAX_C_RANGE * self:getBattle():getFrontLayer():getScale() * 1.5
    local aLen,bLen = aNormal,bNormal
    local level = self.m_nRealLevel

    -- local x,y
    -- for i=1,#BattleOtherPointsLine.playerLevel do
    --     aLen = aNormal * BattleOtherPointsLine.parabolaRange[i] * 0.01
    --     x = BattleOtherPointsLine.parabolaRange[i]
    --     if BattleOtherPointsLine.playerLevel[i] > level then
    --         break
    --     end
    -- end

    -- for i=1,#BattleOtherPointsLine.countPlayerLevel do
    --     bLen = BattleOtherPointsLine.parabolaRangeY[i] * bNormal * 0.01
    --     y = BattleOtherPointsLine.parabolaRangeY[i]
    --     if BattleOtherPointsLine.countPlayerLevel[i] >= level then
    --         break
    --     end
    -- end

    aLen = aNormal * 200 * 0.01
    bLen = 400 * bNormal * 0.01
    WZLog("BattleOtherPointsLine:getVisibleRange", level, aLen, bLen)
    return aLen,bLen
end

function BattleOtherPointsLine:getCount()
    local count = 20
    local level = self.m_nRealLevel
    for i=1,#BattleOtherPointsLine.countPlayerLevel do
        count = BattleOtherPointsLine.countPlayerCount[i]
        if BattleOtherPointsLine.countPlayerLevel[i] >= level then
            break
        end
    end

    --WZLog("BattleOtherPointsLine:getCount", level, count)
    return count
end

--@brief	更新指示线位置及路径
--@param	tPos:指示线起点位置
--@param	tSpeed:指示线移动速度
--@param	tAcceleration:指示线移动加速度
--#return   #1,true 更新了 false 没有更新
function BattleOtherPointsLine:update(tPos, tSpeed, tAcceleration, scale)
    if self.m_tStartPos ~= nil and self.m_tSpeed ~= nil and BattleCommon:pointLen(self.m_tStartPos,tPos) < 0.1 and BattleCommon:pointLen(self.m_tSpeed,tSpeed) < 0.1 then
        return false
    end
    --print("BattleOtherPointsLine:update", tostring(self.m_tStartPos and self.m_tStartPos.x), tostring(self.m_tStartPos and self.m_tStartPos.y), tPos.x, tPos.y)
    self.m_nPreIndex = curIndex
    self.m_tStartPos = tPos
    self.m_tAcceleration = tAcceleration ~= nil and tAcceleration or BattleConstants.g_nFlyGravity
    self.m_tSpeed = tSpeed

    self:updateLine(scale)

    return true
end

--@brief	更新指示线位置及路径（教学用）
--@param	tPos:指示线起点位置
--@param	tSpeed:指示线移动速度
--@param	tAcceleration:指示线移动加速度
function BattleOtherPointsLine:updateInTeach(tPos, tSpeed, tAcceleration)
    self.m_tStartPos = tPos
    self.m_tAcceleration = tAcceleration
    self.m_tSpeed = tSpeed
    self:updateLinePos()
	for i = 1,#self.m_tPoints  do
		self.m_tPoints[i]:setVisible(true)
	end
end


function BattleOtherPointsLine:getEllipseRange()
    local aNormal = BattleOtherPointsLine.POINT_MAX_A_RANGE * self:getBattle():getFrontLayer():getScale() * 1.5
    local bNormal = BattleOtherPointsLine.POINT_MAX_B_RANGE * self:getBattle():getFrontLayer():getScale() * 1.5
    local aLen,bLen = aNormal,bNormal
    if BattleOtherPointsLine.playerLevel and BattleOtherPointsLine.parabolaRange then
        local level = self.m_nRealLevel

        for i=1,#BattleOtherPointsLine.playerLevel do
            -- --WZLog("BattleOtherPointsLine:getEllipseRange", BattleOtherPointsLine.parabolaRange[i], BattleOtherPointsLine.playerLevel[i], level)
            aLen,bLen = aNormal * BattleOtherPointsLine.parabolaRange[i] * 0.01 , bNormal * BattleOtherPointsLine.parabolaRange[i] * 0.01
            if BattleOtherPointsLine.playerLevel[i] > level then
                break
            end
        end
    end
    return aLen,bLen
end

function BattleOtherPointsLine:isInEllipse(startPos,checkPos,aLen,bLen, index)
	if BattleCommon:isInEllipse(checkPos,{x = startPos.x , y = startPos.y , a = aLen, b=bLen }) then
        --print("BattleOtherPointsLine:isInEllipse one-1", index, startPos.x, checkPos.x, startPos.y, checkPos.y, aLen, bLen, self.m_nMaxHeight)
		return true
	end
    --print("BattleOtherPointsLine:isInEllipse one-2", index, startPos.x, checkPos.x, startPos.y, checkPos.y, aLen, bLen, self.m_nMaxHeight)
	return false
end

--@brief    在节点附近画一个椭圆
--@param    tCenter2 圆心
--@param    tEllipse {x = 0,y = 0,a = 1,b = 1} 椭圆信息
--@param    tColor 颜色
function BattleOtherPointsLine:addEllipse(tEllipse,tColor)
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

function BattleOtherPointsLine:isInVisibleRange(startPos, checkPos, length, length2, index)
    do return true end
    if length == nil then
        return nil
    end

    local dis = BattleCommon:pointDis(startPos,checkPos)
    --print("BattleOtherPointsLine:isInVisibleRange one-1", index, startPos.x, checkPos.x, startPos.y, checkPos.y, dis, length, length2)

	if dis < length then

        local linePos = self.m_tStartPos
        local offset = {x=linePos.x+0,y=linePos.y+20}
        local point = CCAutoPoint:create(offset.x, offset.y)
        point = self:getBattle():getFrontLayer():convertToWorldSpaceAuto(point)
       
        offset = self.m_uBatchNode:getParent():convertToNodeSpaceAuto(point)

        -- --WZLog("BattleOtherPointsLine:isInVisibleRange one-2", offset.y, self.m_nMaxHeightIndex, index)

        if  false and checkPos.y >= offset.y  then
            if self.m_nMaxHeightIndex >= 1 and index > self.m_nMaxHeightIndex and self.m_nMaxHeight > startPos.y then
                -- --WZLog("BattleOtherPointsLine:isInVisibleRange two-0",startPos.y, checkPos.y, self.m_nMaxHeight)
                if checkPos.y - (startPos.y + 0) < (self.m_nMaxHeight - (startPos.y + 0)) * 0.5  then
                    --print("BattleOtherPointsLine:isInVisibleRange two-1")
                    return  false
                else
                    --print("BattleOtherPointsLine:isInVisibleRange three-0")
                    return  true
                end
            else
                --print("BattleOtherPointsLine:isInVisibleRange three-1")
                return true
            end
        else
            if startPos.y - checkPos.y >= length2 then
                --print("BattleOtherPointsLine:isInVisibleRange two-2", index)
                return false
            else
                --print("BattleOtherPointsLine:isInVisibleRange three-2", index)
                return  true
            end
        end
	end
    --print("BattleOtherPointsLine:isInVisibleRange three-4", index)
    return false
end

---[[

--@brief    在节点附近画一个圆
--@param    tCenter2 圆心
--@param    nRadius 半径
--@param    tColor 颜色
function BattleOtherPointsLine:addCircle(tCenter2,nRadius,tColor)
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
function BattleOtherPointsLine:setTarget(target)
    if self.m_tTarget == nil or self.m_tTarget.x ~= target.x or self.m_tTarget.y ~= target.y then
        self.m_tTarget = target
    end
end

--brief 刷新显示
function BattleOtherPointsLine:checkLineView()
    if self.m_nPointStyle ~= WndBattleSetting:getLineStyleData() then
        self.m_nPointStyle = WndBattleSetting:getLineStyleData()
        if self.m_uBatchNode then
            self.m_uBatchNode:removeFromParentAndCleanup(true)
            self.m_uBatchNode = nil
        end
        self:createPointView()
    end
end

function BattleOtherPointsLine:destroy()
    WZLog("BattleOtherPointsLine:destroy", tostring(self.m_drawNode), tostring(self.m_tPoints and #self.m_tPoints), tostring(self.m_uBatchNode))
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



--@brief    计算发射时候的速度
--@note     根据Hero位置和触摸位置得到最终的速度
function BattleOtherPointsLine:calSpeed(touch)
    ----WZLog("BattleMsgPlayerReadyShoot:calSpeed zero")
    local pressPoint = GlobalMethod:ccp( self.m_tTouchPoint.x , self.m_tTouchPoint.y )
    local touchPoint = GlobalMethod:ccp( touch.x,touch.y )
    local pos = pressPoint
    local playerSize = {width=100,height=100}
    pressPoint = CCDirector:sharedDirector():convertToUI(pressPoint)
    touchPoint = CCDirector:sharedDirector():convertToUI(touchPoint)

    local pointX,pointY = pressPoint.x - touchPoint.x , -(pressPoint.y - touchPoint.y)

    local length = math.sqrt(pointX * pointX + pointY * pointY)

    pointX = pointX / length
    pointY = pointY / length
    if length < BattleMsgPlayerReadyShoot.SHOOT_POWER_MIN then
        length = BattleMsgPlayerReadyShoot.SHOOT_POWER_MIN
    elseif length > BattleMsgPlayerReadyShoot.SHOOT_POWER_MAX then
        length = BattleMsgPlayerReadyShoot.SHOOT_POWER_MAX
    end
    local rate = (length - BattleMsgPlayerReadyShoot.SHOOT_POWER_MIN) / (BattleMsgPlayerReadyShoot.SHOOT_POWER_MAX - BattleMsgPlayerReadyShoot.SHOOT_POWER_MIN)
    local rateX = rate

    local perX = math.abs( pointX / (math.abs(pointX) + math.abs(pointY)) )
    rateX = rateX * perX
    if rateX > 0.2 then
        rateX = (rateX - 0.2) * 2.5
    else
        rateX = 0
    end
    if rate + rateX > 1 then
        rateX =  1 - rate
    end

    local scale = 1.0
    local l0 = playerSize.width
    local l1,l2,l3,l4,l5 = l0 * 1, l0 * 1.3, l0 * 1.6, l0 * 2, nil
    local s1,s2,s3,s4,s5 = 0.3,      0.325,    0.35,      0.375,    0.4

    if length <= l1 then
        scale = scale * s1
    elseif length <= l2 then
        scale = (scale * s1 * l1 / l0) + (scale * s2 * (length - l1) / l0)
    elseif length <= l3 then
        scale = (scale * s1 * l1 / l0) + (scale * s2 * (l2 - l1) / l0) + (scale * s3 * (length - l2) / l0)
    elseif length <= l4 then
        scale = (scale * s1 * l1 / l0) + (scale * s2 * (l2 - l1) / l0) + (scale * s3 * (l3 - l2) / l0) + (scale * s4 * (length - l3) / l0)
    else
        scale = (scale * s1 * l1 / l0) + (scale * s2 * (l2 - l1) / l0) + (scale * s3 * (l3 - l2) / l0) + (scale * s4 * (l4 - l3) / l0) + (scale * s5 * (length - l4) / l0)
    end

    local screenScale = 1
    scale = scale / math.sqrt(screenScale)
    local shootPowerX = (rate + rateX) * BattleMsgPlayerReadyShoot.SHOOT_POWER_BASE * scale
    local shootPowerY = rate * BattleMsgPlayerReadyShoot.SHOOT_POWER_BASE * scale

    local speedX = pointX * shootPowerX * BattleConstants.g_nShootSpeed
    local speedY = pointY * shootPowerY * BattleConstants.g_nShootSpeed

    local limit = 60
    if speedX >= limit then
        speedX = limit
    elseif speedX <= 0 - limit then
        speedX = 0 - limit
    end

    local limit = 60
    if speedY >= limit then
        speedY = limit
    elseif speedY <= 0 - limit then
        speedY = 0 - limit
    end

    WZLog("BattleOtherPointsLine:calSpeed one","speedX =",speedX,"speedY =",speedY,"pointX =",pointX,"pointY =",pointY,"length =",length,"rate =", rate,"rateX =", rateX, "perX =", perX,"scale =", scale,"shootPowerX =", shootPowerX,"shootPowerY =",shootPowerY,"touchPoint.x =",touchPoint.x,"touchPoint.y =",touchPoint.y,"pressPoint.x =",pressPoint.x,"pressPoint.y =",pressPoint.y)
    return {x=speedX,y=speedY}
end

--@brief    触摸面板Began回调
--@param    element:回调绑定的UI节点引用
--@param    point：触摸点
--@param    nIdx：触摸点id
--@note
function BattleOtherPointsLine:onTouchBegan(element, point)
    self.m_tTouchPoint = BattleTouch:pointWorldToNode(self:getBattle():getFrontLayer(), GlobalMethod:ccp(point.x, point.y))
    WZLog("BattleOtherPointsLine:onTouchBegan zero", tostring(self.m_tTouchPoint.x), tostring(self.m_tTouchPoint.y)) 
    
    if self.m_tTouchPoint.x >= 290 and self.m_tTouchPoint.x <= 350 and self.m_tTouchPoint.y >= 150 and self.m_tTouchPoint.y <= 210 then
        self.m_bTouchOk = true
        WZLog("BattleOtherPointsLine:onTouchBegan one")
    else
        self.m_tTouchPoint = nil
        self.m_bTouchOk = nil
        WZLog("BattleOtherPointsLine:onTouchBegan two")
    end
end

--@brief    触摸面板Moved回调
--@param    element:回调绑定的UI节点引用
--@param    point：触摸点
--@param    nIdx：触摸点id
--@note
function BattleOtherPointsLine:onTouchMoved(element, point)
    if self.m_bTouchOk then
        self.m_tSpeed = self:calSpeed(point)
        WZLog("BattleOtherPointsLine:onTouchMoved", point.x, point.y, self.m_tTouchPoint.x, self.m_tTouchPoint.y, self.m_tSpeed.x, self.m_tSpeed.y)

        self:update({x=427,y=212},self.m_tSpeed,nil, 1.0)
        if self.m_bIsVisible ~= true then
            self:setVisible(true)
        end
    end
end

--@brief    按下结束事件函数
function BattleOtherPointsLine:onTouchEnd(element, point)
    --WZLog("BattleOtherPointsLine:onTouchEnd", self.m_tSpeed.x)
    if self.m_bTouchOk then
        self:setVisible(false)
        if self.m_tSpeed.x > -1 then
            self:getBattle():onBtnKick()
            --self:buildBullet()
            
        else
            self:getBattle():shootFail()
        end
        self.m_tTouchPoint = nil
        self.m_bTouchOk = nil
    end
end

function BattleOtherPointsLine:buildBullet()
    self:getBattle():shootOk()
    local accele = BattleConstants.g_nFlyGravity
    local bullet = WBulletOther:buildBullet({x=320,y=180},{x=self.m_tSpeed.x,y=self.m_tSpeed.y},accele,nil,false,false)

    self.m_tBulletTeachs = self.m_tBulletTeachs or {}
    table.insert(self.m_tBulletTeachs,bullet)

    self:getBattle():getFrontLayer():addChild(bullet:getAnimation():getAnimNode(),3,3)
end

--@brief    每帧调用
function BattleOtherPointsLine:loop()
    local bullets = self.m_tBulletTeachs
    if bullets then
        for i=#bullets,1,-1 do

            local isExist = bullets[i] and bullets[i]:updatePosition()
            local pos = bullets[i] and bullets[i].m_mover:getMoverPosition()
            WZLog("BattleOtherPointsLine:loop one", i, pos and pos.x)

            if pos and (pos.x < self.m_tRect.x1 or pos.x > self.m_tRect.x2 or pos.y < self.m_tRect.y1 or pos.y > self.m_tRect.y2) then
                if bullets then
                    bullets[i]:destroy()
                    table.remove(bullets,i)              
                end
                self:getBattle():shootOut({x=pos.x,y=pos.y})
                WZLog("BattleOtherPointsLine:loop two")
            end

            if pos and (pos.x >= self.m_tWinRect.x1 and pos.x <= self.m_tWinRect.x2 and pos.y >= self.m_tWinRect.y1 and pos.y <= self.m_tWinRect.y2) then
                if bullets then
                    bullets[i]:destroy()
                    table.remove(bullets,i)              
                end
                ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ShootBall(true, WndFootballActivity.m_nPreResult)
                self:getBattle():shootIn({x=pos.x,y=pos.y})
                WZLog("BattleOtherPointsLine:loop three")
            end
        end
    end
end

--@brief    设置触摸开始
--@param    point：触摸点
--@param    nIdx：触摸点id
--@note
function BattleOtherPointsLine:setTouchOk(point)
    self.m_tTouchPoint = BattleTouch:pointWorldToNode(self:getBattle():getFrontLayer(), GlobalMethod:ccp(point.x, point.y))
    WZLog("BattleOtherPointsLine:setTouchOk zero", tostring(self.m_tTouchPoint.x), tostring(self.m_tTouchPoint.y)) 
    
    self.m_bTouchOk = true
    WZLog("BattleOtherPointsLine:setTouchOk one")
end

--@brief    触摸面板Moved回调
--@param    element:回调绑定的UI节点引用
--@param    point：触摸点
--@param    nIdx：触摸点id
--@note
function BattleOtherPointsLine:setTouchMove(element, point, nCount)
    if self.m_bTouchOk then
        self.m_nVisibleCount = nCount
        self.m_tSpeed = self:calSpeedBalloon(point)
        WZLog("BattleOtherPointsLine:setTouchMove", point.x, point.y, self.m_tTouchPoint.x, self.m_tTouchPoint.y)
        if self.m_bIsVisible ~= true then
            self:setVisible(true)
        end
    end
end

--@brief    计算发射时候的速度
--@note     根据气球位置和触摸位置得到最终的速度
function BattleOtherPointsLine:calSpeedBalloon(touch)
    local pressPoint = GlobalMethod:ccp( self.m_tTouchPoint.x , self.m_tTouchPoint.y )
    local touchPoint = GlobalMethod:ccp( touch.x,touch.y )
    local pos = pressPoint
    local playerSize = {width=54,height=71}

    local pointX,pointY = pressPoint.x - touchPoint.x , (pressPoint.y - touchPoint.y)

    local length = math.sqrt(pointX * pointX + pointY * pointY)
    
    pointX = pointX / (self.m_nVisibleCount - 1)
    pointY = pointY / (self.m_nVisibleCount - 1)
    
    local speedX = pointX
    local speedY = pointY

    WZLog("BattleOtherPointsLine:calSpeed one","speedX =",speedX,"speedY =",speedY,"touchPoint.x =",touchPoint.x,"touchPoint.y =",touchPoint.y)
    
    local pos = {x = 0, y = 0}
    for i = 1, #self.m_tPoints do
        pos.x = touchPoint.x + (i - 1) * speedX
        pos.y = touchPoint.y + (i - 1) * speedY
        self.m_tPoints[i]:setPosition(pos.x, pos.y)
        self.m_tPoints[i]:setVisible(true)
    end
end









