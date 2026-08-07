--TeachBattleLoop.lua
--@brief	战斗循环处理
--@date  	2013/1/3
--@author 	Zjh
--@note 	每帧要处理的内容


TeachBattleLoop =
{
	--m_tPrePoints	--上一帧触摸点集
	--m_tPressPoint	--人物范围触摸起点
	--m_nDeltaTime	--当前帧离上一帧的时间
	--m_nOldScale	--上一次前景放缩值
	--m_tOldPos		--上一次前景坐标
	--m_bNeedUpdateBg	--需要再次更新背景
	
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建一个循环对象
--@return 	循环对象
--@note		用于战斗的每帧检测
function TeachBattleLoop:create()
	local obj = {}
	setmetatable(obj, { __index = TeachBattleLoop } )
	obj.m_nDeltaTime = 0
	obj.m_nOldScale = 0
	obj.m_tOldPos = {x=0,y=0}
	obj.m_tPrePoints = {}
	obj.m_bNeedUpdateBg = true
	return obj
end

------战斗场景相关API

--@brief		获取上一帧触摸点
--@param	 	nPointId:触摸点Id
--@return	 	table:触摸点point
--@note
function TeachBattleLoop:getBattlePrePoint(nPointId)

	return self.m_tPrePoints[nPointId]

end

--@brief		获取当前帧离上一帧的时间
--@return	 	当前帧离上一帧的时间
--@note
function TeachBattleLoop:getBattleDeltaTime()

	return self.m_nDeltaTime

end

--@brief		获取人物范围触摸起点
--@return	 	人物范围触摸起点
--@note
function TeachBattleLoop:getPressPoint()

	return self.m_tPressPoint

end
------

--@brief	定时更新函数
--@param 	dt:一帧的时间
--@note		每帧调用一次
function TeachBattleLoop:update(dt)
	
	self.m_nDeltaTime = dt

	MsgManager:update(dt)

	self:_checkTouch(dt)

	BattleActionManager:currentManager():update(dt)

	TeachBattle:updateDt(dt)
	
	BattleShowHeroUse:update()
	
	self:_updateBg()

	SceneTeachBattle:getBattlePointsLine():updateDt(dt)

end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	检测触摸
--@param 	dt:一帧的时间
--@note		在S_NORMAL状态下，检测是否需要发送消息
function TeachBattleLoop:_checkTouch(dt)

	local touch = SceneTeachBattle:getBattleTouch()
	
	local hero = TeachBattle:getMyHero()

    --WZLog("TeachBattleLoop:_checkTouch one",touch:getTouchStatus(1),BattleTouch.TOUCH_BEGIN,BattleTouch.TOUCH_NONE)
	if touch:getTouchStatus(1) == BattleTouch.TOUCH_BEGIN then
		local anim = hero:getAnimation()
		local touchPoint = GlobalMethod:ccp( touch:getTouchPoint(1).x,touch:getTouchPoint(1).y )
		touchPoint = anim:getAnimNode():convertToNodeSpaceAR( touchPoint )
		touchPoint.y = touchPoint.y - anim:getAnimNode():getContentSize().height/2

		if BattleCommon:pointLen(touchPoint) < 90 then
			self.m_tPressPoint = touch:getTouchPoint(1)
		else
			self.m_tPressPoint = nil
		end
	elseif touch:getTouchStatus(1) == BattleTouch.TOUCH_NONE then
		self.m_tPressPoint = nil
	end
	
	touch:update()

	self.m_tPrePoints[1] = touch:getTouchPoint(1)

	self.m_tPrePoints[2] = touch:getTouchPoint(2)

end

--@brief	同步背景
--@note		将前景的变化同步到背景
function TeachBattleLoop:_updateBg()
	if self.m_bNeedUpdateBg == false or self.m_nOldScale ~= SceneTeachBattle:getFrontLayer():getScale() or self.m_tOldPos.x ~= SceneTeachBattle:getFrontLayer():getPositionX() or self.m_tOldPos.y ~= SceneTeachBattle:getFrontLayer():getPositionY() then
	
		self.m_nOldScale = SceneTeachBattle:getFrontLayer():getScale()
		self.m_tOldPos = {x=SceneTeachBattle:getFrontLayer():getPositionX(),y=SceneTeachBattle:getFrontLayer():getPositionY()}
		local scrCenter = BattleMapManager:getFrontControl():getCurScreenCenter()
		local center = {x=SceneTeachBattle:getFrontLayer():getContentSize().width/2 , y = SceneTeachBattle:getFrontLayer():getContentSize().height/2}
		local zoomPoint = BattleCommon:pointAdd(BattleCommon:pointMult(BattleCommon:pointSub(scrCenter,center),0.5),center)

		SceneTeachBattle:getBgLayer():setScale( self.m_nOldScale * 0.8)
		self.m_bNeedUpdateBg = BattleMapManager:getBgControl():centerOnPoint(zoomPoint)
		
	end
end

-------------------------------------私有方法模块End----------------------------------------




