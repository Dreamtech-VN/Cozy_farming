--BattleScaleZoomAction.lua

BattleScaleZoomAction = {}

--@brief    创建action
--@param    uNode 节点
--@param    nDuration 持续时间
--@param    nScale  缩放量
--@param    tPos 要置为中心点的值
--@param    tControl  屏幕控制实例
--@return   #1, 返回一个新的action
function BattleScaleZoomAction:createAction(uNode,nDuration,nScale,tPos,tControl)
	local obj = {}
    setmetatable(obj,{__index = BattleScaleZoomAction})
	obj.m_nDuration = nDuration
	obj.m_nScale = nScale
	obj.m_tPos	= tPos
	obj.m_tControl = tControl
    obj.m_uNode = uNode
    obj.m_nDeltaScale = nScale - obj.m_uNode:getScaleX()
	obj.m_nStartScale = obj.m_uNode:getScaleX()
    obj.m_nActionId = 0
    obj.m_nElapsed = 0.0
	return obj
end

--@brief    做滴答更新
--@param    上一桢到这一桢过去的时间
function BattleScaleZoomAction:update(nDt)
    if self.m_nDuration >= self.m_nElapsed then
        return
    end
	self.m_nElapsed = self.m_nElapsed + nDt
    local time = self.m_nElapsed/self.m_nDuration
    if time > 1.0 then
        time = 1.0
    end
    self.m_uNode:setScale(self.m_nStartScale + self.m_nDeltaScale*time)
    if time >= 1.0 then
        tControl:centerOnPoint(self.m_tPos,1.0)
    else
        tControl:centerOnPoint(self.m_tPos,tControl:getScrollDamping())
    end
end
--@brief    判断当前action是否结束了
--@return   ＃1， true 已经结束了  false 还没有结束
function BattleScaleZoomAction:isDone()
	return self.m_nDuration <= self.m_nElapsed
end

--@brief    设置id
--@param    nId 标识
function BattleScaleZoomAction:setActionId(nId)
    self.m_nActionId = nId
end

--@brief    获取当前id
--@return   #1, 返回当前id
function BattleScaleZoomAction:getActionId()
    return self.m_nActionId
end