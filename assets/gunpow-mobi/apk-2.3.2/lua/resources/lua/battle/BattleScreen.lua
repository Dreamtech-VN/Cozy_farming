--BattleScreen.lua
--@brief	屏幕操作功能
--@date  	2013/1/14
--@author 	Zjh
--@note


BattleScreen =
{
	m_nNormalScale, --标准状态的scale
	m_nFollowBulletScale,
	m_nLastScale,	--自己状态下的Scale
	--spring
	m_nSpringTime,
	m_nSpringDistance,
	m_nSpringUpDown,
	m_nSpringPos,
	m_nTargetpos,
	--zoom to hero
	m_nScreenLockTime = 0 ,

}

-------------------------------------公有方法模块Begin--------------------------------------


--@brief	获取SceneBattle
--@return	tBattle: SceneBattle
function BattleScreen:getBattle()
	if SceneBattle.m_root then
		return SceneBattle
	elseif SceneTeachBattle.m_root then
		return SceneTeachBattle
	end
	return SceneBattle
end

--@brief	屏幕跟踪英雄位置
--@param	heroPos:英雄位置
--@return	#1 bool, true表示完全到达跟踪位置
--@note		一般跟踪可以不用完全到达跟踪位置
function BattleScreen:followHero(heroPos)
	local myHero = WBattleGlobal:getCurrent():getMyHero()
	if WBattleGlobal:getCurrent():isGhostStage() and myHero.m_bIsDead then 
		return true
	end
    BattleScreenControl.m_bIsFirstScaleOk = true
    if WBattleGlobal:getCurrent():isFog() and BattleMapManager:getFogControl() then
    	BattleMapManager:getFogControl():centerOnPoint(heroPos,BattleScreen:getBattle():getBattleLoop():getBattleDeltaTime()*3)
	end
	return BattleMapManager:getFrontControl():centerOnPoint(heroPos,BattleScreen:getBattle():getBattleLoop():getBattleDeltaTime()*3)
end

--@brief	屏幕跟踪子弹
--@param	bulletPos:子弹位置
--@param	nFlyTime:子弹飞行时间
--@note
function BattleScreen:followBullet(bulletPos,nFlyTime)
	local myHero = WBattleGlobal:getCurrent():getMyHero()
	if WBattleGlobal:getCurrent():isGhostStage() and myHero.m_bIsDead then 
		return true
	end
	local dt = BattleScreen:getBattle():getBattleLoop():getBattleDeltaTime()
	-- if nFlyTime > 0.2 then
		-- local scale = BattleScreen:getBattle():getFrontLayer():getScale()
		-- local scaleTo = scale+(self.m_nFollowBulletScale-scale)*dt*2
		-- BattleScreen:getBattle():getFrontLayer():setScale(scaleTo)
        -- WZLog("BattleScreen:setScale 1", scale, scaleTo)
	-- end
	BattleMapManager:getFrontControl():centerOnPoint(bulletPos,dt*5)
	if WBattleGlobal:getCurrent():isFog() then
		BattleMapManager:getFogControl():centerOnPoint(bulletPos,dt*5)
	end
end

--@brief	设置屏幕抖动
--@param	bulletPos:子弹位置
--@param	reset:强制重置，无视相同的位置
--@note
function BattleScreen:setSpring(bulletPos,reset,time,distance,frequency)
	if bulletPos == nil then
		return
	end
	if reset then
		self.m_nTargetpos = nil
	end
	if self.m_nTargetpos and BattleCommon:pointEqual(self.m_nTargetpos,bulletPos) then
		return
	else
		self.m_nTargetpos = { x = bulletPos.x , y = bulletPos.y}
	end

    WZLog("BattleScreen:setSpring",bulletPos.x,bulletPos.y,tostring(reset),tostring(time), tostring(distance), tostring(frequency))
	self.m_nSpringTime = time or 0.6
	self.m_nSpringDistance = distance or 8
	self.m_nSpringUpDown = 0
    self.m_nSpringFrequency = frequency or 0.05
	self.m_nSpringPos = {x = BattleScreen:getBattle():getFrontLayer():getPositionX(), y = BattleScreen:getBattle():getFrontLayer():getPositionY()}
	self.m_nTargetpos = { x = bulletPos.x , y = bulletPos.y}
end

--@brief	屏幕抖动
--@return	#1 bool, true表示抖动结束,false则下一帧还要继续调用
--@note		第一次抖动要调用setSpring
function BattleScreen:screenSpring()
	if self.m_nTargetpos and self.m_nSpringTime > 0 then

		if self.m_nSpringUpDown < self.m_nSpringFrequency then
			BattleMapManager:getFrontControl():updatePosition({x = self.m_nSpringPos.x,y=self.m_nSpringPos.y - self.m_nSpringDistance})
			if WBattleGlobal:getCurrent():isFog() then
				BattleMapManager:getFogControl():updatePosition({x = self.m_nSpringPos.x,y=self.m_nSpringPos.y - self.m_nSpringDistance})
			end
		else
			BattleMapManager:getFrontControl():updatePosition({x = self.m_nSpringPos.x,y=self.m_nSpringPos.y + self.m_nSpringDistance})
			if WBattleGlobal:getCurrent():isFog() then
				BattleMapManager:getFogControl():updatePosition({x = self.m_nSpringPos.x,y=self.m_nSpringPos.y + self.m_nSpringDistance})
			end
		end
		self.m_nSpringUpDown = self.m_nSpringUpDown + self.m_nSpringFrequency

        local dt = BattleScreen:getBattle():getBattleLoop():getBattleDeltaTime()
        self.m_nSpringTime = self.m_nSpringTime - dt

        WZLog("BattleScreen:screenSpring one",self.m_nSpringUpDown, self.m_nSpringDistance, self.m_nSpringFrequency,self.m_nSpringTime, dt)
		if self.m_nSpringUpDown >= self.m_nSpringFrequency * 2 then
			self.m_nSpringUpDown = 0
		end


		if self.m_nSpringTime <= 0 then
            WZLog("BattleScreen:screenSpring two")
			BattleMapManager:getFrontControl():updatePosition({x = self.m_nSpringPos.x , y=self.m_nSpringPos.y})
			if WBattleGlobal:getCurrent():isFog() then
				BattleMapManager:getFogControl():updatePosition({x = self.m_nSpringPos.x , y=self.m_nSpringPos.y})
			end
			return true
		else
			return false
		end
	end
	return true
end


--@brief	重置镜头放缩转移到英雄
--@note
function BattleScreen:resetZoomToHero()
	self.m_nScreenLockTime = 0
end

--@brief	镜头放缩转移到英雄
--@return	#1 bool, true表示结束,false则下一帧还要继续调用
--@note		第一次要调用resetZoomToHero。发射后/下一回合/刚进入战斗
function BattleScreen:zoomToHero(playerId,heroPos,isFollow, scaleOffset,speedOffset)
	scaleOffset = scaleOffset
	speedOffset = speedOffset or 2
	local dt = BattleScreen:getBattle():getBattleLoop():getBattleDeltaTime()
	self.m_nScreenLockTime = self.m_nScreenLockTime + dt
	if self.m_nScreenLockTime > 0.75 then
		if isFollow then
			local hero = WBattleGlobal:getCurrent():getCharacterWithId(playerId)
			if hero and not hero:isDead() then 
				heroPos = hero:getPosition()
			end
		end
		local zoomScale
		if scaleOffset then
			zoomScale = scaleOffset
		elseif GlobalGame.g_tPlayerInfo and playerId == WBattleGlobal:getCurrent():getMyBattleId() then
			--zoomScale = WBattleGlobal:getCurrent().m_nPreZoomSize or self.m_nLastScale or  BattleMapManager:getFrontControl():getZoomOutInit()
            zoomScale = self.m_nLastScale or  BattleMapManager:getFrontControl():getZoomOutInit()
            --print("BattleScreen:zoomToHero two", tostring(zoomScale), tostring(self.m_nLastScale), tostring(WBattleGlobal:getCurrent().m_nPreZoomSize), tostring(BattleScreen.m_nLastScale))
            self.m_nLastScale = nil

		else
			zoomScale = self.m_nNormalScale
		end

		local scale = BattleScreen:getBattle():getFrontLayer():getScale()
		local scaleTo = scale+(zoomScale-scale)*dt*1.25*speedOffset
		BattleScreen:getBattle():getFrontLayer():setScale(scaleTo)
        WZLog("BattleScreen:setScale 2")

        if false and GlobalGame.g_tPlayerInfo and playerId == WBattleGlobal:getCurrent():getMyBattleId() and WBattleGlobal:getCurrent().m_nPreZoomPosMyself then
            local x = heroPos.x - WBattleGlobal:getCurrent().m_nPreZoomPosMyself.x + WBattleGlobal:getCurrent().m_nPreZoomPosCenter.x
            local y = heroPos.y - WBattleGlobal:getCurrent().m_nPreZoomPosMyself.y + WBattleGlobal:getCurrent().m_nPreZoomPosCenter.y


            WZLog("BattleScreenControl:moveZoom two",WBattleGlobal:getCurrent().m_nPreZoomPosCenter.x,WBattleGlobal:getCurrent().m_nPreZoomPosCenter.y, WBattleGlobal:getCurrent().m_nPreZoomPosMyself.x, WBattleGlobal:getCurrent().m_nPreZoomPosMyself.y, heroPos.x, heroPos.y)

            heroPos = BattleCommon:getPointTable(x,y)
        end
		local isCenter = BattleMapManager:getFrontControl():centerOnPoint(heroPos,dt*10)
        local aPos = WBattleGlobal:getCurrent():getCurrentCharacter():getAnimation():getPosition()
		WZLog("BattleScreen:zoomToHero one",zoomScale,scale,scaleTo, heroPos.x, heroPos.y,aPos.x,aPos.y)
		local flag = 0
		if isCenter == true then
			flag = flag + 1
		end

		if BattleScreen:getBattle():getFrontLayer():getScale() - zoomScale < 0.1 and BattleScreen:getBattle():getFrontLayer():getScale() - zoomScale > -0.1 then
			flag = flag + 1
		end

		if flag == 2 then
			WndBattleHud:setHudBtnOpacity()
			return true
		end
	end
	return false
end

--@brief	重置镜头镜头最小化(尽可能全景)
function BattleScreen:resetZoomOut()
	self.m_nScreenLockTime = 0
end

--@brief	镜头最小化(尽可能全景)
--@param	centerPos,镜头对准的中心位置，默认场景中间(nil时)
--@param	tOffset,偏移位置(nil则默认无偏移)
--@return	#1 bool, true表示结束,false则下一帧还要继续调用
--@note		第一次要调用resetZoomOut
function BattleScreen:zoomOut(centerPos,tOffset)
	--centerPos = centerPos or {x = BattleScreen:getBattle():getFrontLayer():getContentSize().width/2 , y = 480 - BattleMapManager:getFrontControl().m_tWinBottomLeft.y }
	centerPos = centerPos or {x = BattleScreen:getBattle():getFrontLayer():getContentSize().width/2 , y = 640 - BattleMapManager:getFrontControl().m_tWinBottomLeft.y * 2 }
	tOffset = tOffset or {x=0,y=0}
	centerPos.x = centerPos.x + tOffset.x
	centerPos.y = centerPos.y + tOffset.y

	local dt = BattleScreen:getBattle():getBattleLoop():getBattleDeltaTime()
	self.m_nScreenLockTime = self.m_nScreenLockTime + dt
	if self.m_nScreenLockTime > 0.1 then
		local zoomScale =  BattleMapManager:getFrontControl():getZoomOutInit()

		local scale = BattleScreen:getBattle():getFrontLayer():getScale()
		BattleScreen:getBattle():getFrontLayer():setScale(scale+(zoomScale-scale)*dt*2)
        WZLog("BattleScreen:setScale 3")
        --do return true end
		local flag = 0
		if WBattleGlobal:getCurrent():isFog() then
			BattleMapManager:getFogControl():centerOnPoint(centerPos,dt*10)
		end
		if BattleMapManager:getFrontControl():centerOnPoint(centerPos,dt*10) == true then
			flag = flag + 1
		end

		if BattleScreen:getBattle():getFrontLayer():getScale() - zoomScale < 0.1 and BattleScreen:getBattle():getFrontLayer():getScale() - zoomScale > -0.1 then
			flag = flag + 1
		end
		if flag == 2 then
			WndBattleHud:setHudBtnOpacity()
			return true
		end
	end
	return false
end

--@brief	设置背景是否变暗
--@param	isDark,背景层是否变暗
--@param	nDarkDegree,黑的程度,255为全黑(isDark为true时该参数才有效，默认100)
function BattleScreen:setBgDarken(isDark,nDarkDegree)
	local bg = BattleScreen:getBattle():getBgLayer()
	local dark = bg:getChildElement("imgDarkBg_SceneBattle")
	if isDark then
		if dark == nil then
			dark = WZUIImage:create()
			dark:setName("imgDarkBg_SceneBattle")
			dark:setFile("ui/common/common_black_bg.png")
			dark:setOpacity(nDarkDegree or 100)
			dark:setZOrder(1)
			dark:setTouchEnable(false)
			bg:addChild(dark)
		end
	else
		if dark then
			dark:removeFromParentAndCleanup(true)
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------




