--BattleScreenControl.lua
--@brief	战斗场景镜头管理
--@date  	2014/01/08
--@author 	TaoYinqing



BattleScreenControl = {}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief 	创建一个战斗场景镜头管理器
--@param 	tNode	被管理的层
function BattleScreenControl:create(tNode)
	local obj = {}
	setmetatable(obj,{__index = BattleScreenControl})
	-- init
	obj.m_tNode = tNode
	local  size = tNode:getContentSize()
	obj.m_tTopRight = {x = size.width,y = size.height}
	obj.m_tBottomLeft = {x = 0, y = 0}
	obj.m_tWinTopRight = {x = 1136, y = 640}
	obj.m_tWinBottomLeft = {x = 0, y = 0}
	obj.m_nZoomInInit = 1.0
	obj.m_nZoomOutInit = 0.5
	obj.m_tOldCenterPos = {x = 0,y = 0}
    obj.m_nScrollDamping = 0.4
    obj.m_tFirstTouchPoint = {x = 0,y = 0}
    obj.m_tOldPosition = {x = 0,y = 0}
    obj.m_nFirstDistance = 0.0
    obj.m_nOldScale = 0.0
    obj.m_tOldCenter = {x = 0.0,y = 0.0}
    obj.m_nPinchDistanceThreshold = 3
    obj.m_nZoomRate = 1.0/200
    obj.m_nPinchDamping = 0.9
	obj.bottomExpand = 0
	obj.nowIsAutoOpenHudStatus = false
	obj.m_bDisableBoundPos = false
    --obj.m_tDiff = { x = 0 , y = 0}
    
    local size = CCEGLView:sharedOpenGLView():getFrameSize()
    local scaleX = size.width / obj.m_tWinTopRight.x
    local scaleY = size.height / obj.m_tWinTopRight.y
    if scaleX > scaleY then
        local diff = scaleX - scaleY
        diff = diff/scaleX
        diff = obj.m_tWinTopRight.y * diff
        obj.m_tWinTopRight.y = obj.m_tWinTopRight.y - diff/2
        obj.m_tWinBottomLeft.y = diff/2
    elseif scaleY > scaleX then
        local diff = scaleY - scaleX
        diff = diff/scaleY
        diff = obj.m_tWinTopRight.x * diff
        obj.m_tWinTopRight.x = obj.m_tWinTopRight.x - diff / 2
        obj.m_tWinBottomLeft.x = diff / 2
    end

    obj.m_tFinshPos = nil
    obj.m_bIsMoveStart = nil
    obj.m_bIsActionRun = nil
    return obj
end


function BattleScreenControl:setDisableBoundPos(bValue)
	--self.m_bDisableBoundPos = bValue
end 

--@brief	设置地图背景的右上角
--@param 	tPos 右上角的值
function BattleScreenControl:setTopRight(tPos)
	self.m_tTopRight.x,self.m_tTopRight.y = tPos.x,tPos.y
end

--@brief 	设置地图背景的左下角
--@param 	tPos 左下角的值
function BattleScreenControl:setBottomLeft(tPos)
	self.m_tBottomLeft.x , self.m_tBottomLeft.y = tPos.x,tPos.y
end

--@brief 	设置屏幕的右上角
--@param 	tPos 屏幕右上角的值
function BattleScreenControl:setWinTopRight(tPos)
	self.m_tWinTopRight.x , self.m_tWinTopRight.y = tPos.x , tPos.y
end


--@brief 	设置屏幕的左下角
--@param 	tPos 屏幕左下角
function BattleScreenControl:setWinBottomLeft(tPos)
	self.m_tWinBottomLeft.x,self.m_tWinBottomLeft.y = tPos.x,tPos.y
end

--@brief 	设置放大的最大值
--@param 	nZoomIn 放大的最大值
function BattleScreenControl:setZoomInInit(nZoomIn)
	self.m_nZoomInInit = nZoomIn
end

--@brief 	获得屏幕放大的最大值
--@return 	#1, 返回屏幕放大的最大值
function BattleScreenControl:getZoomInInit()
	return self.m_nZoomInInit
end

--@brief 	设置缩小的最小值
--@param 	nZoomOut 缩小的最小值
function BattleScreenControl:setZoomOutInit(nZoomOut)
	self.m_nZoomOutInit = nZoomOut
end

--@brief 	设置屏幕缩小的最小值
--@return 	#1, 返回屏幕缩小的最小值
function BattleScreenControl:getZoomOutInit()
	return self.m_nZoomOutInit
end

function BattleScreenControl:getOptimalZoomOutLimit(scaleOffset)
    scaleOffset = scaleOffset or 0.95
	--default to 100%
	local size = CCEGLView:sharedOpenGLView():getFrameSize()
	local scaleX = size.width / 1136
    local scaleY = size.height / 640
	
    local xMaxZoom = 1
    local yMaxZoom = 1

    local width = (self.m_tTopRight.x - self.m_tBottomLeft.x)
    local height = (self.m_tTopRight.y - self.m_tBottomLeft.y)

	local scale = scaleX
	if scaleX <  scaleY then 
		scale = scaleY
	end
	
	local xMinZoom = (size.width/scale/scaleOffset)/self.m_tNode:getContentSize().width
	
    --don't divide by zero
    if width ~= 0 then
        xMaxZoom = (self.m_tWinTopRight.x - self.m_tWinBottomLeft.x) / width
    end
    if height ~= 0 then
        yMaxZoom = (self.m_tWinTopRight.y - self.m_tWinBottomLeft.y) / height
    end

	--WZLog("BattleScreenControl:getOptimalZoomOutLimit",xMaxZoom,yMaxZoom,xMinZoom)
    --give the best out of the 2 zooms
    --return (xMaxZoom > yMaxZoom) ? xMaxZoom : yMaxZoom;
	if xMinZoom < xMaxZoom then 
		xMinZoom = xMaxZoom
	end
	
	if xMinZoom < yMaxZoom then 
		xMinZoom = yMaxZoom
	end 
	
    
    local realMinZoom = 0.5
    
    if realMinZoom < xMinZoom then 
        realMinZoom = xMinZoom
    end 
    
    
	--local _zoom = xMaxZoom > yMaxZoom and xMaxZoom or yMaxZoom
	--local  minZoom = 0.8 * CCEGLView:sharedOpenGLView():getFrameSize().width / BattleMapManager.m_nWidth
	return realMinZoom -- > minZoom and _zoom or minZoom
    --if xMaxZoom > yMaxZoom then
    --	return xMaxZoom
    --else
    --	return yMaxZoom
    --end
end

--@brief 	设置ScrollDamping'
function BattleScreenControl:setScrollDamping(nDamping)
	self.m_nScrollDamping = nDamping
end

--@brief	获取ScrollDamping
--@param 	#1, 返回当前的ScrollDamping
function BattleScreenControl:getScrollDamping()
	return self.m_nScrollDamping
end


--@brief    获取地图在屏幕中间的时候的坐标
function BattleScreenControl:getTopRightPos()
    local scale = self.m_tNode:getScale()
	local size = self.m_tNode:getContentSize()
	local anchorPoint = self.m_tNode:getAnchorPoint()
	local anchor = {x = size.width*anchorPoint.x,y = size.height*anchorPoint.y}
	anchor = BattleCommon:pointMult(anchor,1.0 - scale)
	-- Calculate corners
	local topRight = BattleCommon:pointAdd(BattleCommon:pointSub(BattleCommon:pointMult(self.m_tTopRight, scale), self.m_tWinTopRight), anchor)
	return {x = -topRight.x,y = -topRight.y}
    --local bottomLeft = BattleCommon:pointSub(BattleCommon:pointAdd(BattleCommon:pointMult(self.m_tBottomLeft, scale), self.m_tWinBottomLeft), anchor)
	--return {x = (topRight.x + bottomLeft.x)/2,y = (topRight.y+bottomLeft.y)/2}
end

--@brief    获取地图在屏幕中间的时候的坐标
function BattleScreenControl:getBottomLeftPos()
    local scale = self.m_tNode:getScale()
	local size = self.m_tNode:getContentSize()
	local anchorPoint = self.m_tNode:getAnchorPoint()
	local anchor = {x = size.width*anchorPoint.x,y = size.height*anchorPoint.y}
	anchor = BattleCommon:pointMult(anchor,1.0 - scale)
	-- Calculate corners
	--local topRight = BattleCommon:pointAdd(BattleCommon:pointSub(BattleCommon:pointMult(self.m_tTopRight, scale), self.m_tWinTopRight), anchor)
	local bottomLeft = BattleCommon:pointSub(BattleCommon:pointAdd(BattleCommon:pointMult(self.m_tBottomLeft, scale), self.m_tWinBottomLeft), anchor)
	return bottomLeft
    --return {x = (topRight.x + bottomLeft.x)/2,y = (topRight.y+bottomLeft.y)/2}
end

--@brief    获取地图在屏幕中间的时候的坐标
function BattleScreenControl:getMidPos()
    local scale = self.m_tNode:getScale()
	local size = self.m_tNode:getContentSize()
	local anchorPoint = self.m_tNode:getAnchorPoint()
	local anchor = {x = size.width*anchorPoint.x,y = size.height*anchorPoint.y}
	anchor = BattleCommon:pointMult(anchor,1.0 - scale)
	-- Calculate corners
	local topRight = BattleCommon:pointAdd(BattleCommon:pointSub(BattleCommon:pointMult(self.m_tTopRight, scale), self.m_tWinTopRight), anchor)
	local bottomLeft = BattleCommon:pointSub(BattleCommon:pointAdd(BattleCommon:pointMult(self.m_tBottomLeft, scale), self.m_tWinBottomLeft), anchor)
	return {x = (-topRight.x + bottomLeft.x)/2,y = (-topRight.y+bottomLeft.y)/2}
end

--@brief	限定坐标在允许的范围内 bound 内'
--@param	tPos 要限定的坐标值
--@return	#1, 限定后的坐标值
function BattleScreenControl:boundPos(tPos)
	if self.m_bDisableBoundPos == true then 
		return tPos
	end 
	-- Correct for anchor
	local scale = self.m_tNode:getScale()
	local size = self.m_tNode:getContentSize()
	local anchorPoint = self.m_tNode:getAnchorPoint()
	local anchor = {x = size.width*anchorPoint.x,y = size.height*anchorPoint.y}
	anchor = BattleCommon:pointMult(anchor,1.0 - scale)
	-- Calculate corners
	local topRight = BattleCommon:pointAdd(BattleCommon:pointSub(BattleCommon:pointMult(self.m_tTopRight, scale), self.m_tWinTopRight), anchor)
	local bottomLeft = BattleCommon:pointSub(BattleCommon:pointAdd(BattleCommon:pointMult(self.m_tBottomLeft, scale), self.m_tWinBottomLeft), anchor)
	
	-- if tPos.y > bottomLeft.y and self.bottomExpand ~= 0 then
		-- self.nowIsAutoOpenHudStatus = true
		-- self:setHudExpand(false)
		-- if WBattleGlobal:getCurrent():isMyTurn() then
			-- bottomLeft.y = bottomLeft.y + self.bottomExpand
		-- end
	-- else
		-- self.nowIsAutoOpenHudStatus = false
		-- self:setHudExpand(true)
	-- end
	
	self.nowIsAutoOpenHudStatus = false
	self:setHudExpand(true)
	
	-- bound x
	if tPos.x > bottomLeft.x then
		tPos.x = bottomLeft.x
	elseif tPos.x < -topRight.x then
		tPos.x = -topRight.x
	end
	
    -- bound y
	if tPos.y > bottomLeft.y then
		tPos.y = bottomLeft.y
	elseif tPos.y < -topRight.y then
		tPos.y = -topRight.y
	end
	
	return tPos;
end

--@brief 	限定放大缩小在一定的范围内
function BattleScreenControl:boundScale(isNoLimit)
    --WZLog("BattleScreenControl:boundScale 1", tostring(isNoLimit) , self.m_tNode:getScale(), self.m_nZoomInInit, self.m_nZoomOutInit)
	if self.m_tNode == nil  then
		return
	end

    isNoLimit = false
    local zoomOut = self.m_nZoomOutInit
    if isNoLimit == true then
         zoomOut = self:getOptimalZoomOutLimit(1)
    elseif BattleScreenControl.m_bIsFirstScaleOk ~= true then
        local firstScale = 1.2
        zoomOut = firstScale * self.m_nZoomOutInit
    end
    if self.m_tNode:getScale() > self.m_nZoomInInit then
        self.m_tNode:setScale(self.m_nZoomInInit)
    elseif self.m_tNode:getScale() < zoomOut then
        self.m_tNode:setScale(zoomOut)
    elseif BattleScreenControl.m_bIsFirstScaleOk ~= true then
        self.m_tNode:setScale(zoomOut)
    end
end

--@brief	更新节点的坐标到tPos'
--@param	tPos 要更新到的坐标
function BattleScreenControl:updatePosition(tPos)
	tPos = self:boundPos(tPos);
	self.m_tNode:setPosition(tPos.x,tPos.y)

	--[[if self == BattleMapManager:getFrontControl() and SceneBattle.m_root then
		WndBattleHud:setHudBtnOpacity()
	end]]
end

--@brief	把位置tPos设置为中心位置
--@param	tPos 坐标
--@param	nDamping 矫正值
--@return	#1, true 如果移动距离小于1.5个像素 否则 false
function BattleScreenControl:centerOnPoint(tPos,nDamping,isNoLimit)
--    WZLog("BattleScreenControl:centerOnPoint", tPos.x, tPos.y)
	if nDamping == nil then
		nDamping = 1.0
	end
    if nDamping > 1.0 then 
        nDamping = 0.95
    end 
	self:boundScale(isNoLimit)
	self.m_tOldCenterPos.x,self.m_tOldCenterPos.y = tPos.x,tPos.y
	local mid = BattleCommon:midPoint(self.m_tWinTopRight, self.m_tWinBottomLeft)
	mid = CCPointApplyAffineTransformAuto(CCAutoPoint:create(mid.x,mid.y), self.m_tNode:parentToNodeTransformAuto())
	local diff = BattleCommon:pointMult(BattleCommon:pointSub(mid, tPos), nDamping)
	local prePos = {x = 0, y = 0}
	prePos.x,prePos.y = self.m_tNode:getPosition()
    if BattleCommon:pointDis(prePos,tPos)<1.5 then
        return true
    end
	self:updatePosition(BattleCommon:pointAdd(prePos, diff))
	local curPos = {x = 0,y = 0}
	curPos.x,curPos.y = self.m_tNode:getPosition()
	if BattleCommon:pointDis(prePos,curPos)<1.5 then
   		return true
   	end
    return false
end

--@brief	移动镜头到中心位置tPos
--@param	tPos 位置坐标
--@param	nDuration 持续时长
--@param	nRate 频率
function BattleScreenControl:centerOnPointWithAction(tPos,nDuration,nRate)
	self:boundScale()
	self.m_tOldCenterPos.x,self.m_tOldCenterPos.y = tPos.x,tPos.y
	local mid = BattleCommon:midPoint(self.m_tWinTopRight, self.m_tWinBottomLeft)
	mid = CCPointApplyAffineTransformAuto(CCAutoPoint:create(mid.x,mid.y), self.m_tNode:parentToNodeTransformAuto())
	local diff = BattleCommon:pointSub(mid, tPos)
	local prePos = {x = 0, y = 0}
	prePos.x,prePos.y = self.m_tNode:getPosition()
	local final = self:boundPos(BattleCommon:pointAdd(prePos, diff))
	local moveTo = CCMoveTo:create(nDuration, GlobalMethod:ccp(final.x,final.y))
	local ease = CCEaseElasticOut:create(moveTo,nRate)
	self.m_tNode:runAction(ease)
end

--@brief 	放大到最大值，并且移动到中心点为tPos
--@param	tPos	中心点坐标
--@param	nDuration	持续时长
function BattleScreenControl:zoomInOnPoint(tPos,nDuration)
	self:zoomOnPoint(tPos,nDuration,self.m_nZoomInInit)
end

--@brief 	缩小到最小值，并且移动到中心点为tPos
--@param	tPos	中心点坐标
--@param	nDuration	持续时长
function BattleScreenControl:zoomOutOnPoint(tPos,nDuration)
	self:zoomOnPoint(tPos,nDuration,self.m_nZoomOutInit)
end

--@brief 	放大缩小到制定的nScale 并且中心点在tPos
--@param 	tPos 中心点
--@param 	nDuration 动画时长
--@param 	nScale 放大缩小值
function BattleScreenControl:zoomOnPoint(tPos,nDuration,nScale)
	-- self.m_tNode:runAction(CCPanZoomControllerScale::actionWithDuration(duration,scale,this, pt))
	-- BattleScaleZoomAction:createAction(uNode,nDuration,nScale,tPos,tControl)

	BattleActionManager:currentManager():addAction(BattleScaleZoomAction:createAction(self.m_tNode,nDuration,nScale,tPos,self))
end
--@brief    快速方法缩小
--@param    fTargetScale目标值
--@param    tPos 目标点
function BattleScreenControl:zoomToScaleAndPointQuickly(fTargetScale,tPos)
    self.m_tNode:setScale(self.m_tNode:getScaleX()+(fTargetScale-self.m_tNode:getScaleX())*0.05);
    local flag = 0
    if self:centerOnPoint(tPos,0.2) then
        flag = flag + 1
    end
    if self.m_tNode:getScaleX()-fTargetScale < 0.1 and self.m_tNode:getScaleX()-fTargetScale > -0.1 then
        flag = flag + 1
    end
    if flag == 2 then
        return true
    end
    return false
end

--@brief 	纪录滑动开始并做一些相应的工作
--@param 	tPos 开始点
function BattleScreenControl:beginScroll(tPos)
    self.m_bIsMoveStart = true
	self.m_tFirstTouchPoint.x,self.m_tFirstTouchPoint.y = tPos.x,tPos.y
end

--@brief 	移动
--@param 	tPos 当前点
function BattleScreenControl:moveScroll(tPos)
    
	local pos = BattleCommon:pointSub(tPos,self.m_tFirstTouchPoint)
	pos = BattleCommon:pointMult(pos,self.m_nScrollDamping*self.m_tNode:getScale())
	local cPos = {x = 0,y = 0}
	cPos.x,cPos.y = self.m_tNode:getPosition()

    local myHero = WBattleGlobal:getCurrent():getMyHero()
	if self == BattleMapManager:getFrontControl() and SceneBattle.m_root and SceneBattle:getBattleLoop():getBattleStatus() == BattleLoop.S_SCREEN_MOVE and myHero:getUseBigSkill() ~= true then
		self:addBottomExpand()
	end

	self.m_tFinshPos = {}
	self.m_tFinshPos.x = tPos.x
	self.m_tFinshPos.y = tPos.y
    --WZLog("BattleScreenControl:moveScroll",self.m_tFinshPos.x,self.m_tFinshPos.y,self.m_tFirstTouchPoint.x,self.m_tFirstTouchPoint.y)

	self:updatePosition(BattleCommon:pointAdd(cPos,pos))
end

--@brief 	移动结束
--@param 	tPos 当前点
function BattleScreenControl:endScroll(tPos)
	-- TODO
    --do return end
    
    local touch = SceneBattle:getBattleTouch()
    if self.m_bIsActionRun == nil and self.m_tFinshPos ~= nil and self.m_bIsMoveStart == true and touch.m_nTouchPassTime ~= nil then

        --WZLog("BattleScreenControl:endScroll one",touch.m_nTouchPassTime,self.m_tFinshPos.x,self.m_tFinshPos.y)

        if touch.m_nTouchPassTime >= 0.05 and touch.m_nTouchPassTime <= 0.5 and self.m_tFinshPos.y >= 1 and self.m_tFinshPos.x >= 1 then
            --WZLog("BattleScreenControl:endScroll two",self.m_tFinshPos.x,self.m_tFinshPos.y,self.m_tFirstTouchPoint.x,self.m_tFirstTouchPoint.y,self.m_tNode:getScale())

            local scale = 0.054
            local duration = 0.2
            local pos = BattleCommon:pointSub(self.m_tFinshPos,self.m_tFirstTouchPoint)
            pos = BattleCommon:pointMult(pos,self.m_nScrollDamping*self.m_tNode:getScale())

            local distance = {x=pos.x / touch.m_nTouchPassTime * scale, y=pos.y / touch.m_nTouchPassTime * scale}
            --WZLog("BattleScreenControl:endScroll two",distance.x,distance.y,self.m_tFinshPos.x,self.m_tFinshPos.y,self.m_tFirstTouchPoint.x,self.m_tFirstTouchPoint.y,touch.m_nTouchPassTime)
			BattleActionManager:currentManager():addAction(BattleScreenMoveInertiaAction:createAction(self.m_tNode,duration,distance,self.m_tFinshPos,self))
        end

        self.m_tFinshPos = nil
        self.m_bIsMoveStart = nil
        touch.m_nTouchPassTime = nil
    end
end

--@brief 	停止滑动
function BattleScreenControl:stopScrollUpdate()
	self:endScroll(self.m_tFirstTouchPoint)
end


--@brief 	放大begin
--@param 	tPoint1 触摸点1
--@param 	tPoint2 触摸点2
function BattleScreenControl:beginZoom(tPoint1,tPoint2)
	self.m_nFirstDistance = BattleCommon:pointDis(tPoint1,tPoint2)
	self.m_nOldScale = self.m_tNode:getScaleX()
    self.m_tOldCenter = self:getCurScreenCenter()
    self.m_tOldPosition.x,self.m_tOldPosition.y = self.m_tNode:getPosition()
	local pos = BattleCommon:midPoint(tPoint1,tPoint2)
    local p = self.m_tNode:convertToNodeSpaceAuto(CCAutoPoint:create(pos.x,pos.y))
    self.m_tFirstTouchPoint.x , self.m_tFirstTouchPoint.y = p.x ,p.y 
    --[[
    if self.m_tOldPosition.x < 0 then
        self.m_tFirstTouchPoint.x = self.m_tFirstTouchPoint.x - self.m_tOldPosition.x
    end
    
    if self.m_tOldPosition.y < 0 then
        self.m_tFirstTouchPoint.y = self.m_tFirstTouchPoint.y - self.m_tOldPosition.y
    end
    ]]
end

--@brief 	放大move
--@param 	tPoint1 触摸点1
--@param 	tPoint2 触摸点2
function BattleScreenControl:moveZoom(tPoint1,tPoint2)
	local length = BattleCommon:pointDis(tPoint1,tPoint2)
	local diff = length - self.m_nFirstDistance
	if math.abs(diff) < self.m_nPinchDistanceThreshold then
		return
	end
	local factor = diff*self.m_nZoomRate*self.m_nPinchDamping
	local scale = self.m_nOldScale + factor
	self.m_tNode:setScale(scale)
	self:boundScale()
    local curScale = self.m_tNode:getScaleX()
    local diffScale = self.m_nOldScale - curScale
    local prePos = {x = self.m_tFirstTouchPoint.x,y = self.m_tFirstTouchPoint.y}
	local pos = BattleCommon:pointMult(prePos,diffScale)
    pos = BattleCommon:pointAdd(pos,self.m_tOldPosition)
    self:updatePosition(pos)
	self:centerOnPoint(self:getCurScreenCenter())
end


--@brief 	放大缩小
--@param 	tPoint  定点
--@param 	nScale  放大缩小比例
function BattleScreenControl:zoomToPoint(tPoint,nScale,isNoLimit)
    local oldScale = self.m_tNode:getScale()
    local scale = nScale
    self.m_tNode:setScale(scale)
    self:boundScale(isNoLimit)
    local curScale = self.m_tNode:getScaleX()
    local diffScale = oldScale - curScale
    local prePos = tPoint
    local oldPosition = {x = 0,y = 0}
    oldPosition.x,oldPosition.y = self.m_tNode:getPosition()
    local pos = BattleCommon:pointMult(prePos,diffScale)
    pos = BattleCommon:pointAdd(pos,oldPosition)
    self:updatePosition(pos)
    self:centerOnPoint(self:getCurScreenCenter(),nil,isNoLimit)
end

--@brief 	放大end
--@param 	tPoint1 触摸点1
--@param 	tPoint2 触摸点2
function BattleScreenControl:endZoom(tPoint1,tPoint1)
 --TODO
end

--@brief 	获得当前屏幕中心点再地图里面的坐标
--@param 	#1, 返回当前屏幕中心再地图里面的坐标
function BattleScreenControl:getCurScreenCenter()
	local mid = BattleCommon:midPoint(self.m_tWinTopRight,self.m_tWinBottomLeft)
	local cpp = CCPointApplyAffineTransformAuto(CCAutoPoint:create(mid.x,mid.y),self.m_tNode:parentToNodeTransformAuto())
	return {x = cpp.x,y = cpp.y}
end

--@brief 	设置底部道具栏的扩展
--@param 	
function BattleScreenControl:setHudExpand(isPrevious)
	if SceneBattle.m_root then
		if SceneBattle:getBattleLoop():getBattleStatus() == BattleLoop.S_SCREEN_MOVE then
			if self == BattleMapManager:getFrontControl() then
				--WndBattleHud:processHudAutoShow(isPrevious)
			end
		end
	end
end

--@brief 	底部扩大的像素
--@param 	
function BattleScreenControl:addBottomExpand()
	self.bottomExpand = 60
end

--@brief 	重置底部扩大的像素
--@param 	
function BattleScreenControl:resetBottomExpand()
	self.bottomExpand = 0
end


--@brief 	判断是否处于底部扩展位置
--@param 	
function BattleScreenControl:isInExpand()
	return self.nowIsAutoOpenHudStatus
end

--@brief	在屏幕底部点击隐藏hud按钮，要将屏幕地图下拉80像素
--@note

function BattleScreenControl:dropDownFrontMapExpandSize()
	self:resetBottomExpand()
	if self.nowIsAutoOpenHudStatus then
		local posx,posy = SceneBattle:getFrontLayer():getPosition()
		local pos = {x = posx,y = posy}
		local tpos = self:boundPos(pos)
		self.m_tNode:setPosition(tpos.x,tpos.y)
	end
end
