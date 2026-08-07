--BattleMsgPlayerReadyShoot.lua
--@brief	玩家准备射击消息
--@date		2013/1/9
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgPlayerReadyShoot = {
    m_sName = "BattleMsgPlayerReadyShoot",
	SHOOT_LEAST_DIS = 5,
	SHOOT_POWER_MIN = 10,	--最小射击力度
	SHOOT_POWER_MAX = 300,	--最大射击力度
	SHOOT_POWER_BASE = 25,	--射击力度基数
	--m_tPressPoint	--射击瞄准起始点
	SHOOT_X_OFFSET = 40,	--开始射击时的X偏移量
	SHOOT_Y_OFFSET = 60,	--开始射击时的Y偏移量

    m_tSpeedArr = nil,      --速度数组
    m_nPullTime = 0,        --拉动时间
    m_nPullPos = nil,       --拉动地点
    m_tFirstPoint = nil,    --最初的触点
    m_tStartPosLeft = nil,
    m_tStartPosRight = nil,
    isRun = nil,
    m_nOffsetX = 90,
    m_nOffsetY = 70,
    m_bIsCancelDis = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgPlayerReadyShoot:init()
    BattleMsgPlayerReadyShoot.isRun = true
    self.m_cacheLast = {}
    self.m_cacheLast.last_speed = {x = 0,y = 0}
    self.m_cacheLast.last_five_point = {}
	--print("fmj BattleMsgPlayerReadyShoot:init")

	local loop = SceneBattle:getBattleLoop()

	if loop:getBattleStatus() == BattleLoop.S_NORMAL then
		loop:setBattleStatus(BattleLoop.S_PLAYER_READY_SHOOT)

		if BattleMapManager:getFrontControl():isInExpand() == false then
			WndBattleHud:setMyHudSwitchEnable(false)

			WndBattleHud:setMyHudShow(false,true)
		end
	end

    --[[
    local iconImg = CCSprite:create("ui/combat/battle_icon_miaozhun.png")
    local pos = SceneBattle:getFrontLayer():convertToNodeSpace(GlobalMethod:ccp( self.m_tPressPoint.x , self.m_tPressPoint.y ))
    iconImg:setPosition(pos.x,pos.y)
    SceneBattle:getFrontLayer():addChild(iconImg,999,999)
    --]]

end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgPlayerReadyShoot:process(dt)
	local touch = SceneBattle:getBattleTouch()
	local loop = SceneBattle:getBattleLoop()

    local hasMsg = MsgManager:hasNewBlockMsg()
    if hasMsg then
        local count = 0
        for i,msg in pairs(MsgManager.m_tBlockMsgList) do
            if msg.m_sName == "BattleMsgPlayerExit" or msg.m_sName == "BattleMsgComeBackBattleInfoOk" or msg.m_sName == "BattleMsgPlayerAIControl" or msg.m_sName == "BattleMsgAiControlChange" then
                count = count + 1
            end
        end
        hasMsg = hasMsg and (count < #MsgManager.m_tBlockMsgList-1)
    end
    local touch1 = touch and touch:getTouchPoint(1) and GlobalMethod:ccp(touch:getTouchPoint(1).x, touch:getTouchPoint(1).y)
	if ((hasMsg and TeachGroup1.ISBATTLE_MYTURN ~= true) or touch1 == nil or touch:getTouchPoint(1) == nil) then
    --    WZLog("BattleMsgPlayerReadyShoot:process", #MsgManager.m_tBlockMsgList, tostring(hasMsg), tostring(touch1))
        self:endShootAnim()
		return true
	end

    self.m_nPullTime = self.m_nPullTime + dt
    self.m_nPullPos = GlobalMethod:ccp( touch1.x,touch1.y )
    if self.m_tSpeedArr == nil then
        self.m_tSpeedArr = {}
    end
    ----WZLog("BattleMsgPlayerReadyShoot:process 2",loop:getBattleStatus(),BattleLoop.S_PLAYER_READY_SHOOT)
	if TeachGroup1.ISBATTLE_MYTURN == true or loop:getBattleStatus() == BattleLoop.S_PLAYER_READY_SHOOT then
    --    WZLog("BattleMsgPlayerReadyShoot:process 3",WBattleGlobal:getCurrent():getMyHero():getBattleId(),WBattleGlobal:getCurrent():getMyBattleId())
		if TeachGroup1.ISBATTLE_MYTURN == true or WBattleGlobal:getCurrent():getMyHero():getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() then
        --    WZLog("BattleMsgPlayerReadyShoot:process 4",touch:getTouchStatus(1),BattleTouch.TOUCH_NONE,touch:getTouchStatus(2),BattleTouch.TOUCH_NONE)
			if touch:getTouchStatus(1) ~= BattleTouch.TOUCH_NONE and touch:getTouchStatus(2) == BattleTouch.TOUCH_NONE then
		--		WZLog("BattleMsgPlayerReadyShoot:process 5",touch:getTouchStatus(1),BattleTouch.TOUCH_END)
                if touch:getTouchStatus(1) ~= BattleTouch.TOUCH_END then
					--描绘
            --        WZLog("BattleMsgPlayerReadyShoot:process 1",touch:getTouchStatus(1))
					local hero = WBattleGlobal:getCurrent():getMyHero()
					local anim = hero:getAnimation()
					local animPos = anim:getPosition()
					local speedX,speedY = self:calSpeed()

					local startPos = {}
					local offset
					if hero:getUseBigSkill() and TeachGroup1.ISBATTLE_MYTURN ~= true then
                        --WZLog("BattleMsgPlayerReadyShoot:process X1",hero.m_nRotatePre)
						--hero.m_nRotatePre = tonumber(hero:getAnimation():getRotate())
                        --WZLog("BattleMsgPlayerReadyShoot:process X2",hero.m_nRotatePre)
						offset = {x=self.m_nOffsetX,y=self.m_nOffsetY}
					end
					if speedX < 0 then
						if anim:isFlipX() == false then
							hero:getAnimation():setFlipX(true)
                            if hero:getSkinBigSkillAnimation() then 
                                hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(true)
                            end
						end
                        startPos = BattleCommon:getShootPos(true,hero,offset)
					else

						if anim:isFlipX() == true then
							hero:getAnimation():setFlipX(false)
                            if hero:getSkinBigSkillAnimation() then 
                                hero:getSkinBigSkillAnimation():getAnimNode():setFlipX(false)
                            end
						end
                        startPos = BattleCommon:getShootPos(false,hero,offset)
					end
                    if hero.m_bIsReadyShoot ~= true then
                        hero:playReadyShootAnim()
                        hero.m_bIsReadyShoot = true
                    end

                    --[[
                    if speedX < 0 then
                        speedX = -20
                    else
                        speedX = 20
                    end
                    --]]
                    local angle = BattleCommon:pointToAngle(BattleCommon:getPointTable(speedX,speedY)) * -10
                    if speedX < 0 then
                        angle = BattleCommon:pointToAngle(BattleCommon:getPointTable(-speedX,speedY)) * 10
                    end
                    -- --print("BattleMsgPlayerReadyShoot:process 1", angle,speedX,speedY, startPos.x, startPos.y)
					SceneBattle:getBattlePointsLine():setVisible(true)

                    local acceleration = BattleCommon:pointAdd(BattleConstants.g_nFlyGravity,WBattleGlobal:getCurrent():getWind())
                    acceleration = BattleConstants.g_nFlyGravity

                    if hero:getUseBigSkill() and TeachGroup1.ISBATTLE_MYTURN ~= true then
                        --hero:getAnimation():setRotate(angle)
                    end

                    if hero:getUseSkinBigSkill() and (hero:getSkinBigSkill() == 3023 or hero:getSkinBigSkill() == 3029 or hero:getSkinBigSkill() == 3035) then 
                        acceleration = {x = 0, y = -0.05}
                    end
					local needRefresh = SceneBattle:getBattlePointsLine():update(startPos,{x = speedX,y = speedY},acceleration)
					if needRefresh then
						WndBattleHud:setHudBtnOpacity()
					end
					return false
				elseif ((not WBattleGlobal:getCurrent():isBossAndChapterOneTeach()) or SceneBattle.m_pointsLine.m_bisWrong == false or SceneBattle.m_pointsLine.m_bisWrong == nil) and self.m_bIsCancelDis == nil then
					--根据点击坐标计算
					local anim = WBattleGlobal:getCurrent():getMyHero():getAnimation()
					local animPos = anim:getPosition()
					local touchPoint = GlobalMethod:ccp( touch:getTouchPoint(1).x,touch:getTouchPoint(1).y )
					touchPoint = touch:pointWorldToNode( anim:getAnimNode() , touchPoint )
					local pressPoint = GlobalMethod:ccp( self.m_tPressPoint.x , self.m_tPressPoint.y )
					pressPoint = touch:pointWorldToNode( anim:getAnimNode() , pressPoint )
					if BattleCommon:pointDis(pressPoint,touchPoint) > BattleMsgPlayerReadyShoot.SHOOT_LEAST_DIS then

                        --触发普攻技能
                        local hero = WBattleGlobal:getCurrent():getMyHero()
                        BattleAttackSkillManager:triggerInitiativeSkill(hero)

						local speedX,speedY = self:calSpeed()

						local msg = MsgManager:createMsg(BattleMsgPlayerShoot)
						msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
						msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
						msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
						msg.m_nSpeedx = speedX
						msg.m_nSpeedy = speedY
						local startPos
						local offset
						local hero = WBattleGlobal:getCurrent():getMyHero()

                        WBattleGlobal:getCurrent().m_bIsPlayerOperateAlready = true
					
						if hero:getUseBigSkill() then
							offset = {x=self.m_nOffsetX,y=self.m_nOffsetY}
                            -- if hero.m_nBoyOrGirl == 0 then
                            --     SoundManager:playEffectSound(getSoundByType(13))
                            -- else
                            --     SoundManager:playEffectSound(getSoundByType(8))
                            -- end
                        elseif math.random(1,10) <= 5 then
                            if hero.m_nBoyOrGirl == 0 then
                                SoundManager:playEffectSound(getSoundByType(10))
                            else
                                SoundManager:playEffectSound(getSoundByType(5))
                            end
						end
						if speedX < 0 then
							msg.m_nLeftRight = 1
							startPos = BattleCommon:getShootPos(true,hero,offset)
						else
							msg.m_nLeftRight = 0
							startPos = BattleCommon:getShootPos(false,hero,offset)
						end
						msg.m_nStartX = startPos.x
						msg.m_nStartY = startPos.y
                        if  TeachGroup1.ISBATTLE_MYTURN ~= true then
                            MsgManager:pushBlockMsg(msg)
                        end

						WndBattleHud:setMyHudSwitchEnable(false)
						WndBattleHud:setMyHudShow(false)
                        WndBattleHud:endTurnTime()
						return true
					end
				end
			end
		end
	end


    self:endShootAnim()
	return true
end

function BattleMsgPlayerReadyShoot:endShootAnim()
    local hero = WBattleGlobal:getCurrent():getMyHero()
    WZLog("BattleMsgPlayerReadyShoot:endShootAnim")
    if hero.m_bIsReadyShoot == true then
        --WZLog("BattleMsgPlayerReadyShoot:endShootAnim", hero:getUseSkillTime(), hero:getUseItemTime())
        hero.m_bIsReadyShoot = nil
        hero:playEndShootAnim()

        if hero.m_tBigSkillShootAnim then
            hero.m_tBigSkillShootAnim:getAnimNode():removeFromParentAndCleanup(true)
            hero.m_tBigSkillShootAnim = nil
        end

        if hero:getUseSkillTime() <= 0 or hero:getUseItemTime() <= 0 or hero:getUseKMSkillTime() <= 0 then
            WndBattleHud:setMyHudShow(true)
        end
    end
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgPlayerReadyShoot:done()
    --SceneBattle:getFrontLayer():removeChildByTag(999,true)
    BattleMsgPlayerReadyShoot.isRun = nil
	--WZLog("BattleMsgPlayerReadyShoot:done")
	local loop = SceneBattle:getBattleLoop()
	if TeachGroup1.ISBATTLE_MYTURN == true or loop:getBattleStatus() == BattleLoop.S_PLAYER_READY_SHOOT then
		loop:setBattleStatus(BattleLoop.S_NORMAL)
	end

	SceneBattle:getBattlePointsLine():setVisible(false)
	--取消描绘
	WndBattleHud:setHudBtnOpacity()

    self.m_tSpeedArr = nil
    self.m_nPullPos = nil

    if SceneBattle.m_pointsLine.m_bisWrong == true and WBattleGlobal:getCurrent():isBossAndChapterOneTeach() then
        MsgBoxManager:showTipBox(TeachGroup1:getTeachText(191))
        if WndBattleHud.m_tLine then
            WndBattleHud.m_tLine:lingth()
        end
        
        if BattleMsgTeachStep4.m_tLine then
            BattleMsgTeachStep4.m_tLine:lingth()
        end
    end

    SceneBattle:getImgCancel():setVisible(false)
end

--@brief	计算发射时候的速度
--@note		根据Hero位置和触摸位置得到最终的速度
function BattleMsgPlayerReadyShoot:calSpeed()
    ----WZLog("BattleMsgPlayerReadyShoot:calSpeed zero")
    local pressPoint = GlobalMethod:ccp( self.m_tPressPoint.x , self.m_tPressPoint.y )

	local touch = SceneBattle:getBattleTouch()
	local anim = WBattleGlobal:getCurrent():getMyHero():getAnimation()
	local animPos = anim:getPosition()
	local touchPoint = GlobalMethod:ccp( touch:getTouchPoint(1).x,touch:getTouchPoint(1).y )
    animPos.y = animPos.y + anim:getAnimNode():getContentSize().height/2
    animPos = GlobalMethod:ccp(animPos.x,animPos.y)

    local imgCancel = SceneBattle:getImgCancel()
    imgCancel:setVisible(true)
    local pos = SceneBattle:getInfoLayer():convertToNodeSpace(pressPoint)
    
    local length0 = BattleCommon:pointDis(pressPoint, touchPoint)
--    WZLog("BattleMsgPlayerReadyShoot:calSpeed zero", pos.x, pos.y)
    if length0 < 19 then
        self.m_bIsCancelDis = true
        if imgCancel:getFile() ~= "ui/combat/battle_icon_btn01.png" then
            imgCancel:setFile("ui/combat/battle_icon_btn01.png")
        end
    elseif length0 >= 19 then
        self.m_bIsCancelDis = nil
        if imgCancel:getFile() ~= "ui/combat/battle_icon_btn02.png" then
            imgCancel:setFile("ui/combat/battle_icon_btn02.png")
        end
    end
    imgCancel:setAbsPosition(pos)

    local playerSize = {}
    playerSize.width, playerSize.height = anim:getAnimNode():getContentSize().width * 0.7, anim:getAnimNode():getContentSize().height * 0.7
    pressPoint = CCDirector:sharedDirector():convertToUI(pressPoint)
	touchPoint = CCDirector:sharedDirector():convertToUI(touchPoint)

    table.insert(self.m_cacheLast.last_five_point,{x = touch:getTouchPoint(1).x,y = touch:getTouchPoint(1).y})
    if #self.m_cacheLast.last_five_point > 5 then 
        table.remove(self.m_cacheLast.last_five_point,1)
    end

	local pointX,pointY = pressPoint.x - touchPoint.x , -(pressPoint.y - touchPoint.y)

    local length = math.sqrt(pointX * pointX + pointY * pointY)

	pointX = pointX / length
	pointY = pointY / length
	if length < BattleMsgPlayerReadyShoot.SHOOT_POWER_MIN then
		length = BattleMsgPlayerReadyShoot.SHOOT_POWER_MIN
	elseif length > BattleMsgPlayerReadyShoot.SHOOT_POWER_MAX then
		length = BattleMsgPlayerReadyShoot.SHOOT_POWER_MAX
	end
    local myHero = WBattleGlobal:getCurrent():getMyHero()
    if myHero:getUseSkinBigSkill() and (myHero:getSkinBigSkill() == 3023 or myHero:getSkinBigSkill() == 3029 or myHero:getSkinBigSkill() == 3035) then 
        length = BattleMsgPlayerReadyShoot.SHOOT_POWER_MAX/2 
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

    local screenScale = BattleMapManager:getFrontControl().m_tNode:getScale()
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

    local hero = WBattleGlobal:getCurrent():getMyHero()

    local limit = 60
    if speedY >= limit then
        speedY = limit
    elseif speedY <= 0 - limit then
        speedY = 0 - limit
    end

    self.m_cacheLast.last_speed.x = speedX
    self.m_cacheLast.last_speed.y = speedY

--    WZLog("BattleMsgPlayerReadyShoot:calSpeed one","speedX =",speedX,"speedY =",speedY,"pointX =",pointX,"pointY =",pointY,"length =",length,"rate =", rate,"rateX =", rateX, "perX =", perX,"scale =", scale,"shootPowerX =", shootPowerX,"shootPowerY =",shootPowerY,"touchPoint.x =",touchPoint.x,"touchPoint.y =",touchPoint.y,"pressPoint.x =",pressPoint.x,"pressPoint.y =",pressPoint.y)
	return self.m_cacheLast.last_speed.x, self.m_cacheLast.last_speed.y
end

-------------------------------------私有方法模块--------------------------------------
