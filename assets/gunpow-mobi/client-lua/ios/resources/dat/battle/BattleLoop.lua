--BattleLoop.lua
--@brief	战斗循环处理
--@date  	2013/1/3
--@author 	Zjh
--@note 	每帧要处理的内容


BattleLoop =
{
	--m_tPrePoints	--上一帧触摸点集
	--m_nStatus		--战斗场景状态
	--m_tPressPoint	--移动检测点
	--m_nPressTime	--移动检测时间
	--m_nDeltaTime	--当前帧离上一帧的时间
	--m_nOldScale	--上一次前景放缩值
	--m_tOldPos		--上一次前景坐标
	--m_bNeedUpdateBg	--需要再次更新背景
    --m_gcCtrl          -- 控制gc

	--Status
	S_NORMAL	= 1,
	S_PLAYER_MOVE	= 2,
	S_SCREEN_ZOOM	= 3,
	S_SCREEN_MOVE	= 4,
	S_PLAYER_READY_SHOOT = 5,
	S_PLAYER_SHOOT = 6,
	S_PLAYER_READY_FLY = 7,
	S_PLAYER_FLY = 8,
	S_ZOOM_TO_HERO = 9,
	S_ZOOM_OUT = 10,

	--宠物
	S_PET_SHOOT = 50,

	--boss相关
	S_BOSS_SHOOT = 100,
	S_MONSTER_MOVE = 101,
	S_MONSTER_ATTACK = 102,

	CHANGE_PRESS_DIS = 20,	--按同一点不能超过的距离
	MOVE_PRESS_TIME = 0.3,	--触发移动的时间长

}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建一个循环对象
--@return 	循环对象
--@note		用于战斗的每帧检测
function BattleLoop:create()
	local obj = {}
	setmetatable(obj, { __index = BattleLoop } )
	obj.m_nStatus = BattleLoop.S_NORMAL
	obj.m_nPressTime = 0
	obj.m_nDeltaTime = 0
	obj.m_nOldScale = 0
	obj.m_tOldPos = {x=0,y=0}
	obj.m_tPrePoints = {}
	obj.m_bNeedUpdateBg = true
    obj.m_gcCtrl = 0
    obj.m_nIndex = 0
    obj.m_nTotalTime = 0
    obj.m_fShakeHands = nil
    obj.m_nIndex = 0
	return obj
end

------战斗场景相关API

--@brief	设置战斗场景状态
--@param 	nStatus:战斗场景的状态
--@note		用于维护逻辑的改变
function BattleLoop:setBattleStatus(nStatus)
    WZLog("BattleLoop:setBattleStatus", nStatus)
	self.m_nStatus = nStatus

end

--@brief		获取战斗场景状态
--@return	 	nStatus:战斗场景的状态
--@note
function BattleLoop:getBattleStatus()

	return self.m_nStatus

end

--@brief		获取战斗帧数
function BattleLoop:getCount()

	return self.m_nIndex

end

--@brief		获取上一帧触摸点
--@param	 	nPointId:触摸点Id
--@return	 	table:触摸点point
--@note
function BattleLoop:getBattlePrePoint(nPointId)

	return self.m_tPrePoints[nPointId]

end

--@brief		获取当前帧离上一帧的时间
--@return	 	当前帧离上一帧的时间
--@note
function BattleLoop:getBattleDeltaTime()

	return self.m_nDeltaTime

end

function BattleLoop:getPressPoint()

    return self.m_tPressPoint

end
------

--@brief	定时更新函数
--@param 	dt:一帧的时间
--@note		每帧调用一次
function BattleLoop:update(dt)
    --发送心跳协议
    if self.m_fShakeHands == nil then 
        self.m_fShakeHands = 0;
    end 
    if os.time() - self.m_fShakeHands > BattleConstants.g_fShakeHandsTime and NetManager.g_bConnectFailed ~= true and WBattleGlobal:getCurrent().m_tMakePairOk and WBattleGlobal:getCurrent().m_tMakePairOk.battleId then
     self.m_fShakeHands = os.time()
        WZLog("send battle handshake=================")
        ProtocolProcessorBattleInterface:send_SYSTEM_BattleShakeHands(WBattleGlobal:getCurrent().m_tMakePairOk.battleId)
    end


	self.m_gcCtrl = self.m_gcCtrl + 1
    if self.m_gcCtrl >= 5 then
        self.m_gcCtrl = 0
        --collectgarbage("step")
        --collectgarbage("stop")
    end
	self.m_nDeltaTime = dt
    self.m_nTotalTime = self.m_nTotalTime + dt

    self.m_nIndex = self.m_nIndex + 1

	if SceneBattle.m_root then

    --[[
    local hero = WBattleGlobal:getCurrent():getMyHero()
    if hero and hero:getMover() then
        local mover = hero:getMover()
        --print("BattleLoop:update",mover:getMoverSpeed().x,mover:getMoverSpeed().y)

    end


    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    if ProjConfig.DEBUG == 1 and hero then
        hero.m_bUseBigSkill = true
    end
    --]]
        WBattleGlobal:getCurrent():checkCollectGarbage(60)  --如果60秒没有做过一次垃圾回收就自动回收一次
        if WBattleGlobal:getCurrent().m_battleManager ~= nil then
            WBattleGlobal:getCurrent().m_battleManager:update()
        end
        WBattleGlobal:getCurrent():update(dt)

        WndBattleHud:updateTurnTime(dt)

        BattleActionManager:currentManager():update(dt)
        BattleEffectManager:getInstance():update(dt)

        if TeachGroup1.ISBATTLE_MYTURN and (TeachGroup1.ISATTACK or TeachGroup1.ISFLY or TeachGroup1.ISMOVING) then
        	self:_checkTouchTeach(dt)
        else
        	self:_checkTouch(dt)
    	end

        BattleShowHeroUse:update()

        SceneBattle:getBattlePointsLine():updateDt(dt)

		self:_updateBg()
	end

	MsgManager:update(dt)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	检测触摸
--@param 	dt:一帧的时间
--@note		在S_NORMAL状态下，检测是否需要发送消息
function BattleLoop:_checkTouch(dt)
	if WBattleGlobal:getCurrent():isReplayGame() then
		return
	end
    if WBattleGlobal:getCurrent():isGameOver() == true or WBattleGlobal:getCurrent():isAudience() then
        return
    end
	local touch = SceneBattle:getBattleTouch()

	if touch == nil then
		return
	end
	local myHero = WBattleGlobal:getCurrent():getMyHero()
    --WZLog("BattleLoop:_checkTouch", self:getBattleStatus(), touch:getTouchStatus(1), touch:getTouchStatus(2))
	local lockPress = false
	if self:getBattleStatus() == BattleLoop.S_NORMAL and WBattleGlobal:getCurrent():isWaitNextRound() == false and WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle == nil then
		if touch:getTouchStatus(1) == BattleTouch.TOUCH_HOLD and touch:getTouchStatus(2) == BattleTouch.TOUCH_HOLD then
			--WZLog("S_SCREEN_ZOOM 1")
			local msg = MsgManager:createMsg(BattleMsgScreenZoomCtrl)
			MsgManager:pushBlockMsg(msg)
		elseif touch:getTouchStatus(1) == BattleTouch.TOUCH_HOLD and touch:getTouchStatus(2) == BattleTouch.TOUCH_BEGIN then
			--WZLog("S_SCREEN_ZOOM 1_1")
			local msg = MsgManager:createMsg(BattleMsgScreenZoomCtrl)
			MsgManager:pushBlockMsg(msg)
		elseif touch:getTouchStatus(1) == BattleTouch.TOUCH_HOLD then
			if WBattleGlobal:getCurrent():isGhostStage() and myHero.m_bIsDead then 
				if self.m_tPressPoint then 
				if BattleCommon:pointDis(self.m_tPressPoint , touch:getTouchPoint(1)) < BattleLoop.CHANGE_PRESS_DIS then
					self.m_nPressTime = self.m_nPressTime + dt
					self:_ghostMove(touch)
					lockPress = true
				else
				--	WZLog("S_SCREEN_MOVE 33333  000")
					local msg = MsgManager:createMsg(BattleMsgScreenMoveCtrl)
					msg.m_nTouchId = 1
					MsgManager:pushNonBlockMsg(msg)
				end
				end
			else
			if self.m_tPressPoint then
				if BattleCommon:pointDis(self.m_tPressPoint , touch:getTouchPoint(1)) < BattleLoop.CHANGE_PRESS_DIS then
					self.m_nPressTime = self.m_nPressTime + dt

					if self.m_nPressTime > BattleLoop.MOVE_PRESS_TIME then
						local hero = WBattleGlobal:getCurrent():getMyHero()
						WZLog("S_PLAYER_MOVE 2", hero:isInBuffState(EffectTypeConfig.LIMIT_MOVE), hero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT), hero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_SCATTER_TIMES_SHOOT))
						
                        if hero:isInBuffState(EffectTypeConfig.LIMIT_MOVE) ~= true and 
                        	hero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_TIMES_SHOOT) ~= true and
                        	hero:isInBuffState(EffectTypeConfig.LIMIT_ONLY_SCATTER_TIMES_SHOOT) ~= true then
                        	hero:setStopMoveByTornado(0)
                            local msg = MsgManager:createMsg(BattleMsgPlayerMoveCtrl)
                            MsgManager:pushBlockMsg(msg)
                        end
					else
						lockPress = true
					end
				else
					--WZLog("S_SCREEN_MOVE 3")
					local msg = MsgManager:createMsg(BattleMsgScreenMoveCtrl)
					msg.m_nTouchId = 1
					MsgManager:pushBlockMsg(msg)
				end
			end
			end
		elseif touch:getTouchStatus(2) == BattleTouch.TOUCH_HOLD and touch:getTouchStatus(1) == BattleTouch.TOUCH_NONE then
			--WZLog("S_SCREEN_MOVE 4")
			local msg = MsgManager:createMsg(BattleMsgScreenMoveCtrl)
			msg.m_nTouchId = 2
			MsgManager:pushBlockMsg(msg)

		elseif	touch:getTouchStatus(1) == BattleTouch.TOUCH_BEGIN then
			local currentCharacter = WBattleGlobal:getCurrent():getCurrentCharacter()
			if WBattleGlobal:getCurrent():isGhostStage() and myHero.m_bIsDead then
				self.m_nPressTime = 0 
			else
			if currentCharacter and currentCharacter:getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() then
				local anim = currentCharacter:getAnimation()
				local touchPoint = CCAutoPoint:create(touch:getTouchPoint(1).x,touch:getTouchPoint(1).y)
				touchPoint = anim:getAnimNode():convertToNodeSpaceARAuto( touchPoint )
				touchPoint.y = touchPoint.y - anim:getAnimNode():getContentSize().height/2
				WZLog("S_PLAYER_READY 11", BattleCommon:pointLen(touchPoint), WBattleGlobal:getCurrent().m_nScale, currentCharacter:getBattleId(),touchPoint.x, touchPoint.y)
				local distanceLen = 150 + WBattleGlobal:getCurrent().m_nScale * BattleConstants.g_nTouchDistance
				if WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_GS and currentCharacter.m_nCamp == 1 then 
					distanceLen = distanceLen / 2
				end
				if BattleCommon:pointLen(touchPoint) < distanceLen and not WBattleGlobal:getCurrent():isAudience() then
					WZLog("S_PLAYER_READY_SHOOTORFLY 5")
					if currentCharacter:isUseFly() == false and WBattleGlobal:getCurrent():isFlyCopy() == false then
						--print("S_PLAYER_READY_SHOOT 6")
						local msg = MsgManager:createMsg(BattleMsgPlayerReadyShoot)
						msg.m_tPressPoint = touch:getTouchPoint(1)
						MsgManager:pushBlockMsg(msg)

						--镜头保存
						if currentCharacter:getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() then
							BattleScreen.m_nLastScale = SceneBattle:getFrontLayer():getScale()
                            WBattleGlobal:getCurrent().m_nPreZoomSize = BattleMapManager:getFrontControl().m_tNode:getScaleX()
                            WBattleGlobal:getCurrent().m_nPreZoomPosCenter = SceneBattle:getFrontLayer():convertToNodeSpace(GlobalMethod:ccp(480,320))
                            WBattleGlobal:getCurrent().m_nPreZoomPosMyself = WBattleGlobal:getCurrent():getCurrentCharacter():getAnimation():getPosition()
                            --print("BattleScreenControl:moveZoom three",WBattleGlobal:getCurrent().m_nPreZoomPosCenter.x,WBattleGlobal:getCurrent().m_nPreZoomPosCenter.y, WBattleGlobal:getCurrent().m_nPreZoomPosMyself.x, WBattleGlobal:getCurrent().m_nPreZoomPosMyself.y)
						end

					else
						--print("S_PLAYER_READY_FLY 7")
						local msg = MsgManager:createMsg(BattleMsgPlayerReadyFly)
						msg.m_tPressPoint = touch:getTouchPoint(1)
						MsgManager:pushBlockMsg(msg)
					end
				end
			end
			end
			self.m_tPressPoint = touch:getTouchPoint(1)
			lockPress = true
		end
    elseif self:getBattleStatus() == BattleLoop.S_NORMAL and WBattleGlobal:getCurrent():isWaitNextRound() == true or WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then
        if touch:getTouchStatus(1) == BattleTouch.TOUCH_HOLD and touch:getTouchStatus(2) == BattleTouch.TOUCH_HOLD then
            --print("S_SCREEN_ZOOM 8")
            local msg = MsgManager:createMsg(BattleMsgScreenZoomCtrl)
            MsgManager:pushBlockMsg(msg)
            
        elseif touch:getTouchStatus(1) == BattleTouch.TOUCH_HOLD then
        --    print("S_SCREEN_MOVE 99999")
            if WBattleGlobal:getCurrent():isGhostStage() and myHero.m_bIsDead then 
            	if self.m_tPressPoint then
					if BattleCommon:pointDis(self.m_tPressPoint , touch:getTouchPoint(1)) < BattleLoop.CHANGE_PRESS_DIS then
						self.m_nPressTime = self.m_nPressTime + dt
						self:_ghostMove(touch)
						lockPress = true
					else
					--	WZLog("S_SCREEN_MOVE 33333 111")
						local msg = MsgManager:createMsg(BattleMsgScreenMoveCtrl)
						msg.m_nTouchId = 1
						MsgManager:pushNonBlockMsg(msg)
					end
				end
            else
	            if self.m_tPressPoint then
	                local msg = MsgManager:createMsg(BattleMsgScreenMoveCtrl)
	                msg.m_nTouchId = 1
	                MsgManager:pushBlockMsg(msg)
	            end
        	end
        elseif touch:getTouchStatus(2) == BattleTouch.TOUCH_HOLD and touch:getTouchStatus(1) == BattleTouch.TOUCH_NONE then
            --print("S_SCREEN_MOVE 10")
            local msg = MsgManager:createMsg(BattleMsgScreenMoveCtrl)
            msg.m_nTouchId = 2
            MsgManager:pushBlockMsg(msg)
        elseif	touch:getTouchStatus(1) == BattleTouch.TOUCH_BEGIN then
            self.m_tPressPoint = touch:getTouchPoint(1)
            lockPress = true
        end
	else
		local currentCharacter = WBattleGlobal:getCurrent():getCurrentCharacter()
	--	WZLog("UUUUUUUUUUUUUUUUUUUUUU", touch:getTouchStatus(1))
		if touch:getTouchStatus(1) == BattleTouch.TOUCH_BEGIN then
			if WBattleGlobal:getCurrent():isGhostStage() and myHero.m_bIsDead then 
				self.m_tPressPoint = touch:getTouchPoint(1)
				self.m_nPressTime = 0
				lockPress = true
			else
				if currentCharacter and currentCharacter:getBattleId() ~= WBattleGlobal:getCurrent():getMyBattleId() then
					if self:getBattleStatus() ~= BattleLoop.S_NORMAL and WBattleGlobal:getCurrent():isWaitNextRound() == false and WBattleGlobal:getCurrent():isGameOver() == false then
						if self:getBattleStatus() ~= BattleLoop.S_SCREEN_ZOOM and self:getBattleStatus() ~= BattleLoop.S_SCREEN_MOVE and not WBattleGlobal:getCurrent():isAudience() then
							MsgBoxManager:showTipBox(LocalStrings.BATTLE_NOT_MY_TURN)
						end
					end
				end
			end
		elseif touch:getTouchStatus(1) == BattleTouch.TOUCH_HOLD then
			if WBattleGlobal:getCurrent():isGhostStage() and myHero.m_bIsDead then 
				if self.m_tPressPoint then
					if BattleCommon:pointDis(self.m_tPressPoint , touch:getTouchPoint(1)) < BattleLoop.CHANGE_PRESS_DIS then
						self.m_nPressTime = self.m_nPressTime + dt
						self:_ghostMove(touch)
						lockPress = true
					else
				--		WZLog("S_SCREEN_MOVE 33333 222")
						local msg = MsgManager:createMsg(BattleMsgScreenMoveCtrl)
						msg.m_nTouchId = 1
						MsgManager:pushNonBlockMsg(msg)
					end
				end
			end			
		end
	end

	if lockPress ==false then
		self.m_nPressTime = 0
		self.m_tPressPoint = nil
	end

	touch:update(dt)

	self.m_tPrePoints[1] = touch:getTouchPoint(1)

	self.m_tPrePoints[2] = touch:getTouchPoint(2)

end

--@brief	检测触摸
--@param 	dt:一帧的时间
--@note		在S_NORMAL状态下，检测是否需要发送消息
function BattleLoop:_checkTouchTeach(dt)
    if  TeachGroup1.ISATTACK ~= true and TeachGroup1.ISFLY ~= true and TeachGroup1.ISMOVING ~= true then
        return
    end
	local touch = SceneBattle:getBattleTouch()
	
	local hero = WBattleGlobal:getCurrent():getMyHero()

    --WZLog("TeachBattleLoop:_checkTouch one-1",touch:getTouchStatus(1),BattleTouch.TOUCH_BEGIN,BattleTouch.TOUCH_HOLD,BattleTouch.TOUCH_NONE, tostring(TeachGroup1.ISATTACK), tostring(BattleMsgPlayerReadyShoot.isRun))
	if touch:getTouchStatus(1) == BattleTouch.TOUCH_BEGIN then
		local anim = hero:getAnimation()
		local touchPoint = GlobalMethod:ccp( touch:getTouchPoint(1).x,touch:getTouchPoint(1).y )
		touchPoint = anim:getAnimNode():convertToNodeSpaceAR( touchPoint )
		touchPoint.y = touchPoint.y - anim:getAnimNode():getContentSize().height/2

		--WZLog("TeachBattleLoop:_checkTouch one-2", BattleCommon:pointLen(touchPoint), touchPoint.x, touchPoint.y)
		if BattleCommon:pointLen(touchPoint) < 150 then
			self.m_tPressPoint = touch:getTouchPoint(1)
            local msg
            if TeachGroup1.ISATTACK and BattleMsgPlayerReadyShoot.isRun == nil then
                msg = MsgManager:createMsg(BattleMsgPlayerReadyShoot)
                msg.m_tPressPoint = touch:getTouchPoint(1)
                MsgManager:pushNonBlockMsg(msg)
            elseif TeachGroup1.ISFLY and BattleMsgPlayerReadyFly.isRun == nil then
                msg = MsgManager:createMsg(BattleMsgPlayerReadyFly)
                msg.m_tPressPoint = touch:getTouchPoint(1)
                MsgManager:pushNonBlockMsg(msg)
            end

		else
			self.m_tPressPoint = nil
		end

    elseif touch:getTouchStatus(1) == BattleTouch.TOUCH_HOLD and TeachGroup1.ISMOVING and BattleMsgPlayerMoveCtrl.isRun == nil then
    	hero:setStopMoveByTornado(0)
        local msg = MsgManager:createMsg(BattleMsgPlayerMoveCtrl)
        MsgManager:pushNonBlockMsg(msg)
        --WZLog("TeachBattleLoop:_checkTouch two")
	elseif touch:getTouchStatus(1) == BattleTouch.TOUCH_NONE then
		self.m_tPressPoint = nil
	end
	
	touch:update()

	self.m_tPrePoints[1] = touch:getTouchPoint(1)

	self.m_tPrePoints[2] = touch:getTouchPoint(2)

end

--@brief	同步背景
--@note		将前景的变化同步到背景
function BattleLoop:_updateBg()
	if SceneBattle:getFrontLayer() then
        local curPos = {x = SceneBattle:getFrontLayer():getPositionX(),y = SceneBattle:getFrontLayer():getPositionY()}
		local midPos = {x = SceneBattle:getMidLayer():getPositionX(),y = SceneBattle:getMidLayer():getPositionY()}
		local bgPos = {x = SceneBattle:getBgLayer():getPositionX(),y = SceneBattle:getBgLayer():getPositionY()}
		local fogPos = {x = SceneBattle:getFogLayer():getPositionX(),y = SceneBattle:getFogLayer():getPositionY()}
		
		if self.m_bNeedUpdateBg == false or math.abs(self.m_nOldScale - SceneBattle:getFrontLayer():getScale()) > 0.0001 or BattleCommon:pointDis(self.m_tOldPos,curPos) ~= 0 then
            --BattleMapManager:getFrontControl():boundScale()
            curPos = BattleMapManager:getFrontControl():boundPos(curPos)
            SceneBattle:getFrontLayer():setPositionX(curPos.x)
            SceneBattle:getFrontLayer():setPositionY(curPos.y)
            self.m_nOldScale = SceneBattle:getFrontLayer():getScale()

            if WBattleGlobal:getCurrent():isFog() then
	           --  fogPos = BattleMapManager:getFrontControl():boundPos(fogPos)
	            SceneBattle:getFogLayer():setPositionX(curPos.x)
	            SceneBattle:getFogLayer():setPositionY(curPos.y)
	            if self.m_nOldScale ~= SceneBattle:getFogLayer():getScale() then
	            	SceneBattle:getFogLayer():setScale(self.m_nOldScale)
	            end

	        end

            
			
			WZLog("BattleLoop:_updateBg", self.m_nOldScale, SceneBattle:getFogLayer():getScale(), curPos.x, curPos.y)
			self.m_tOldPos = curPos

			local fSize = SceneBattle:getFrontLayer():getContentSize()
			local mSize = SceneBattle:getMidLayer():getContentSize()
			local bSize = SceneBattle:getBgLayer():getContentSize()
			
            local mScale = fSize.width/mSize.width
            local bScale = fSize.width/bSize.width
            
            if mScale < fSize.height/mSize.height then
                mScale = fSize.height/mSize.height
            end
            if bScale < fSize.height/bSize.height then
                bScale = fSize.height/bSize.height
            end
            
            
			local winTopRight = BattleMapManager:getFrontControl().m_tWinTopRight
			local winBottomLeft = BattleMapManager:getFrontControl().m_tWinBottomLeft
			
			local screenWidth = winTopRight.x - winBottomLeft.x
			local screenHeight = winTopRight.y - winBottomLeft.y
			

			if mSize.width > 0 and mSize.height > 0 then 
                SceneBattle:getMidLayer():setScale(self.m_nOldScale * mScale)
                BattleMapManager:getMidControl():boundScale()
				local mScale = SceneBattle:getMidLayer():getScale()

				local mPos = {x = self.m_tOldPos.x,y = self.m_tOldPos.y}
				local mMidPos = BattleMapManager:getMidControl():getMidPos()
                local mTopRight = BattleMapManager:getMidControl():getTopRightPos()
                local mBottomLeft = BattleMapManager:getMidControl():getBottomLeftPos()
                local mLenX =  math.abs(mTopRight.x - mBottomLeft.x)
                local mLenY =  math.abs(mTopRight.y - mBottomLeft.y)
                
                local fMidPos = BattleMapManager:getFrontControl():getMidPos()
                local fTopRight = BattleMapManager:getFrontControl():getTopRightPos()
                local fBottomLeft = BattleMapManager:getFrontControl():getBottomLeftPos()
                local fLenX =  math.abs(fTopRight.x - fBottomLeft.x)
                local fLenY =  math.abs(fTopRight.y - fBottomLeft.y)
                
				if fLenX ~= 0 then mPos.x = -(fMidPos.x - self.m_tOldPos.x)*0.85 + mMidPos.x end
                if fLenY ~= 0 then mPos.y = -(fMidPos.y - self.m_tOldPos.y)*0.85 + mMidPos.y end
                mPos = BattleMapManager:getMidControl():boundPos(mPos)
				SceneBattle:getMidLayer():setPositionX(mPos.x)
                SceneBattle:getMidLayer():setPositionY(mPos.y)
			end
			
			if bSize.width > 0 and bSize.height > 0 then 
				--SceneBattle:getBgLayer():setScale( self.m_nOldScale)
                SceneBattle:getBgLayer():setScale(self.m_nOldScale *bScale)
                BattleMapManager:getBgControl():boundScale()
				local bScale = SceneBattle:getBgLayer():getScale()

				local bPos = {x = self.m_tOldPos.x,y = self.m_tOldPos.y}
				
                local bMidPos = BattleMapManager:getBgControl():getMidPos()
                local fMidPos = BattleMapManager:getFrontControl():getMidPos()
                
                local bMidPos = BattleMapManager:getBgControl():getMidPos()
                local bTopRight = BattleMapManager:getBgControl():getTopRightPos()
                local bBottomLeft = BattleMapManager:getBgControl():getBottomLeftPos()
                local bLenX =  math.abs(bTopRight.x - bBottomLeft.x)
                local bLenY =  math.abs(bTopRight.y - bBottomLeft.y)
                
                local fMidPos = BattleMapManager:getFrontControl():getMidPos()
                local fTopRight = BattleMapManager:getFrontControl():getTopRightPos()
                local fBottomLeft = BattleMapManager:getFrontControl():getBottomLeftPos()
                local fLenX =  math.abs(fTopRight.x - fBottomLeft.x)
                local fLenY =  math.abs(fTopRight.y - fBottomLeft.y)

				if fLenX ~= 0 then bPos.x = -(fMidPos.x - self.m_tOldPos.x)*0.7 + bMidPos.x end
                if fLenY ~= 0 then bPos.y = -(fMidPos.y - self.m_tOldPos.y)*0.7 + bMidPos.y end
                bPos = BattleMapManager:getBgControl():boundPos(bPos)
				SceneBattle:getBgLayer():setPositionX(bPos.x)
                SceneBattle:getBgLayer():setPositionY(bPos.y)
			end	
		end
	end
end

--@brief 	幽灵移动处理
function BattleLoop:_ghostMove(touch)
	-- body
	if self.m_nPressTime > BattleLoop.MOVE_PRESS_TIME then
		WZLog("BattleLoop:_ghostMove")
        --幽灵移动
		local stepX
		local stepY
		local addYRate 
		local anim = WBattleGlobal:getCurrent():getMyHero():getAnimation()
		local touchPoint = GlobalMethod:ccp( touch:getTouchPoint(1).x,touch:getTouchPoint(1).y )
		touchPoint = touch:pointWorldToNode( anim:getAnimNode() , touchPoint )

		local ptDis = math.sqrt((anim:getPosition().y - touchPoint.y ) * (anim:getPosition().y - touchPoint.y ) + (anim:getPosition().x - touchPoint.x ) * (anim:getPosition().x - touchPoint.x ))
		if ptDis >= BattleMsgPlayerMoveCtrl.MIN_ENABLEMOVE_DISTANCE then
			if anim:getPosition().x < touchPoint.x then
				stepX = 0
			else
				stepX = 1
			end
			if anim:getPosition().y < touchPoint.y then
				stepY = 0
			else
				stepY = 1
			end

			addYRate = math.asin((touchPoint.y - anim:getPosition().y) / ptDis)
			WZLog("BattleLoop:_ghostMove", addYRate)

			local msg = MsgManager:createMsg(BattleMsgGhostMove)
			msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
			msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
			msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
			msg.m_nMovecount = 1
			msg.m_tMovestep = {}
			msg.m_tMovestepY = {}
			table.insert(msg.m_tMovestep, stepX)
			table.insert(msg.m_tMovestepY, stepY)
			msg.m_nAddYRate = addYRate
			msg.m_nCurPositionX = anim:getPosition().x
			msg.m_nCurPositionY = anim:getPosition().y
			MsgManager:pushNonBlockMsg(msg)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------




