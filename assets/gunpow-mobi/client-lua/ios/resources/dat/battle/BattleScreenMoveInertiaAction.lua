--BattleScreenMoveInertiaAction.lua
--@brief	屏幕移动惯性功能
--@date  	2014/8/7
--@author 	莫剑峰
--@note

BattleScreenMoveInertiaAction = {}

--@brief    创建action
--@param    uNode 节点
--@param    nDuration 持续时间
--@param    tDistance 惯性移动距离
--@param    tPos 位置的值
--@param    tControl  屏幕控制实例
--@return   #1, 返回一个新的action
function BattleScreenMoveInertiaAction:createAction(uNode,nDuration,tDistance,tPos,tControl)
    WZLog("BattleScreenMoveInertiaAction:createAction")
	local obj = {}
    setmetatable(obj,{__index = BattleScreenMoveInertiaAction})
	obj.m_nDuration = nDuration
	obj.m_tDistance	= tDistance
    obj.m_tPos	= tPos
	obj.m_tControl = tControl
    obj.m_uNode = uNode
    obj.m_nActionId = 0
    obj.m_nElapsed = 0.0

    obj.m_tControl.m_bIsActionRun = true
	return obj
end

--@brief    做滴答更新
--@param    上一桢到这一桢过去的时间
function BattleScreenMoveInertiaAction:update(nDt)
    if self.m_nElapsed >= self.m_nDuration then
        return
    end
	self.m_nElapsed = self.m_nElapsed + nDt

    local distanceDelta = nil

    if self.m_nElapsed <= self.m_nDuration * 0.3 then
        distanceDelta = {x = self.m_tDistance.x / self.m_nDuration, y = self.m_tDistance.y / self.m_nDuration}
    else
        local scale = 5
        distanceDelta = {x = self.m_tDistance.x / (self.m_nDuration + self.m_nElapsed * scale), y = self.m_tDistance.y / (self.m_nDuration + self.m_nElapsed * scale)}
    end
    --WZLog("BattleScreenMoveInertiaAction:update",distanceDelta.x,distanceDelta.y,self.m_tDistance.x,self.m_tDistance.y)


    local cPos = {x = 0,y = 0}
    cPos.x,cPos.y = self.m_tControl.m_tNode:getPosition()
    self.m_tControl:updatePosition(BattleCommon:pointAdd(cPos,distanceDelta))

end
--@brief    判断当前action是否结束了
--@return   ＃1， true 已经结束了  false 还没有结束
function BattleScreenMoveInertiaAction:isDone()
    if self.m_nDuration <= self.m_nElapsed == true then
        self.m_tControl.m_bIsActionRun = nil
    end
	return self.m_nDuration <= self.m_nElapsed
end

--@brief    设置id
--@param    nId 标识
function BattleScreenMoveInertiaAction:setActionId(nId)
    self.m_nActionId = nId
end

--@brief    获取当前id
--@return   #1, 返回当前id
function BattleScreenMoveInertiaAction:getActionId()
    return self.m_nActionId
end