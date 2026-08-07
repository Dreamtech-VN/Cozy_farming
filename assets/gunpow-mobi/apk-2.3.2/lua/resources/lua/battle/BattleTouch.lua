--BattleTouch.lua
--@brief	战斗触摸管理
--@date  	2013/1/6
--@author 	Zjh
--@note 	触摸管理


BattleTouch =
{
	--enum
	MAX_TOUCH_NUM = 10,

	TOUCH_BEGIN = 1,
	TOUCH_HOLD = 2,
	TOUCH_END = 3,
	TOUCH_NONE = 0,
	--
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建一个触摸对象
--@return 	触摸对象
--@note		用于战斗的触摸管理
function BattleTouch:create()
	local obj = {}
	setmetatable(obj, {__index = BattleTouch} )
	obj.m_tPoints = {}
	for i=1,BattleTouch.MAX_TOUCH_NUM do
		obj.m_tPoints[i] = {}
		obj.m_tPoints[i].status = BattleTouch.TOUCH_NONE
		obj.m_tPoints[i].nextStatus = nil		--用于TouchBegan的状态转移
		obj.m_tPoints[i].finish = 1
		obj.m_tPoints[i].x = 0
		obj.m_tPoints[i].y = 0
	end

    obj.m_nTouchPassTime = nil
	return obj
end

--@brief	重置触摸对象
function BattleTouch:reset()
	WZLog("BattleTouch:reset 1",SceneBattle:getBattleTouch())
	local obj = SceneBattle:getBattleTouch()
	for i=1,BattleTouch.MAX_TOUCH_NUM do
		obj.m_tPoints[i] = {}
		obj.m_tPoints[i].status = BattleTouch.TOUCH_NONE
		obj.m_tPoints[i].nextStatus = nil		--用于TouchBegan的状态转移
		obj.m_tPoints[i].finish = 1
		obj.m_tPoints[i].x = 0
		obj.m_tPoints[i].y = 0
	end
    obj.m_nTouchPassTime = nil

end

------触摸点相关API

--@brief	获取触摸状态
--@param	nTouchId：触摸id号
--@return	返回触摸enum值
--@note		ENUM:BattleTouch.TOUCH_BEGIN、TOUCH_HOLD、TOUCH_END、TOUCH_NONE
function BattleTouch:getTouchStatus(nTouchId)

	local index = nTouchId
	if nTouchId >=1 and nTouchId <= BattleTouch.MAX_TOUCH_NUM then
		local status = BattleTouch.TOUCH_NONE
		local count = 0
		for i=1,BattleTouch.MAX_TOUCH_NUM do
			if self.m_tPoints[i].status ~= BattleTouch.TOUCH_NONE then
				count = count + 1
				if nTouchId == count then
					status = self.m_tPoints[i].status
					index = i
					break
				end
			end
		end
		return  status, index
	end

	return BattleTouch.TOUCH_NONE, index
end

--@brief	获取触摸坐标
--@param	nTouchId：触摸id号
--@return	返回点的坐标Table{x,y}，没有点返回nil
--@note		Lua Table
function BattleTouch:getTouchPoint(nTouchId)
	local status, index = self:getTouchStatus(nTouchId)
	if status ~= BattleTouch.TOUCH_NONE then
		return {x=self.m_tPoints[index].x , y=self.m_tPoints[index].y}
	end

	return nil
end



--@brief	世界坐标转换成对于某个控件的局部坐标
--@param	element:相对要设的控件
--@param	point:CCPoint，一般传入触摸坐标
--@return	CCPoint:返回局部坐标
--@note		比如:如果element是人物则传入人物元素
function BattleTouch:pointWorldToNode(element, point)
	return element:getParent():convertToNodeSpace(point)
end

------

--@brief	更新触摸信息
--@note		每帧调用
function BattleTouch:update(dt)
    dt = dt or 0.1
	for i=1,BattleTouch.MAX_TOUCH_NUM do
		if self.m_tPoints[i].status == BattleTouch.TOUCH_END or self.m_tPoints[i].status == BattleTouch.TOUCH_NONE then
			if self.m_tPoints[i].finish == 1 then
				self.m_tPoints[i].status = BattleTouch.TOUCH_NONE
			else
				self.m_tPoints[i].finish = 1
			end
		elseif self.m_tPoints[i].status == BattleTouch.TOUCH_BEGIN then
			if self.m_tPoints[i].finish == 1 then
				self.m_tPoints[i].status = self.m_tPoints[i].nextStatus
			else
				self.m_tPoints[i].finish = 1
			end
		end
        --WZLog("BattleTouch:update",i,self.m_tPoints[i] and self.m_tPoints[i].finish,self.m_tPoints[i] and self.m_tPoints[i].status)
	end


    if BattleMapManager:getFrontControl().m_bIsMoveStart == true and self.m_nTouchPassTime == nil then
        self.m_nTouchPassTime = 0
    end

    if self.m_nTouchPassTime ~= nil then
        self.m_nTouchPassTime = self.m_nTouchPassTime + dt
    end
end


------触摸响应

--@brief	TouchBegan处理
--@param	element:触摸面板
--@param	point：触摸点
--@param	nTouchId：触摸点id
--@note
function BattleTouch:onTouchBegan(element, point, nTouchId)

	nTouchId = nTouchId + 1
	--WZLog("BattleTouch:onTouchBegan one",nTouchId,self.m_tPoints[nTouchId] and self.m_tPoints[nTouchId].finish,point.x,point.y)

    for index, touch in pairs (self.m_tPoints) do
        if nTouchId == index then
            if self.m_tPoints[nTouchId].finish == 1 then
                self.m_tPoints[nTouchId].status = BattleTouch.TOUCH_BEGIN
                self.m_tPoints[nTouchId].nextStatus = BattleTouch.TOUCH_HOLD
                self.m_tPoints[nTouchId].x = point.x
                self.m_tPoints[nTouchId].y = point.y
                self.m_tPoints[nTouchId].finish = 0
                
                if BattleMapManager:getFrontControl() ~= nil and SceneBattle:getFrontLayer() ~= nil then
                    BattleMapManager:getFrontControl():beginScroll(SceneBattle:getFrontLayer():convertToNodeSpace(GlobalMethod:ccp(point.x,point.y)))
                	if WBattleGlobal:getCurrent():isFog() then
                		BattleMapManager:getFogControl():beginScroll(SceneBattle:getFrontLayer():convertToNodeSpace(GlobalMethod:ccp(point.x,point.y)))
                	end
                end
            end
        else
            -- self.m_tPoints[index].status = BattleTouch.TOUCH_NONE
            -- self.m_tPoints[index].finish = 1
        end
    end

    WndBattleHud:hideBuffInfo()
end

--@brief	TouchMoved处理
--@param	element:触摸面板
--@param	point：触摸点
--@param	nTouchId：触摸点id
--@note
function BattleTouch:onTouchMoved(element, point, nTouchId)

	nTouchId = nTouchId + 1
	--WZLog("BattleTouch:onTouchMoved one",nTouchId,self.m_tPoints[nTouchId] and self.m_tPoints[nTouchId].finish,point.x,point.y)

	if nTouchId >= 1 and nTouchId <= BattleTouch.MAX_TOUCH_NUM then
		if self.m_tPoints[nTouchId].finish == 1 then
			self.m_tPoints[nTouchId].status = BattleTouch.TOUCH_HOLD
			self.m_tPoints[nTouchId].x = point.x
			self.m_tPoints[nTouchId].y = point.y
		else
			self.m_tPoints[nTouchId].nextStatus = BattleTouch.TOUCH_HOLD
		end
	end

    --[[
    for i,v in pairs(self.m_tPoints) do
        WZLog("onTouchMoved two",i,v.x,v.y)
    end
    WZLog("")
    --]]
end

--@brief	TouchEnd处理
--@param	element:触摸面板
--@param	point：触摸点
--@param	nTouchId：触摸点id
--@note
function BattleTouch:onTouchEnd(element, point, nTouchId)

	nTouchId = nTouchId + 1
	--WZLog("BattleTouch:onTouchEnd one",nTouchId,point.x,point.y)

	if nTouchId >= 1 and nTouchId <= BattleTouch.MAX_TOUCH_NUM then
		if self.m_tPoints[nTouchId].finish == 1 then
			self.m_tPoints[nTouchId].status = BattleTouch.TOUCH_END
			self.m_tPoints[nTouchId].x = point.x
			self.m_tPoints[nTouchId].y = point.y
			self.m_tPoints[nTouchId].finish = 0
		else
			self.m_tPoints[nTouchId].nextStatus = BattleTouch.TOUCH_END
		end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------




