--BattleMsgPlayerMoveCtrl.lua
--@brief	玩家移动控制消息
--@date		2013/1/8
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgPlayerMoveCtrl = {
    m_sName = "BattleMsgPlayerMoveCtrl",
	MIN_ENABLEMOVE_DISTANCE = 35,	--可移动的最小距离
    m_nCurPositionX = nil,
    m_nCurPositionX = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgPlayerMoveCtrl:init()
	WZLog("BattleMsgPlayerMoveCtrl:init")
    BattleMsgPlayerMoveCtrl.isRun = true
	local loop = SceneBattle:getBattleLoop()

	if loop:getBattleStatus() == BattleLoop.S_NORMAL then
		local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
		if WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() then
			if hero.m_nDebuffMoveLockRound == nil then
				loop:setBattleStatus(BattleLoop.S_PLAYER_MOVE)
			end
		end


	end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgPlayerMoveCtrl:process()
	WZLog("BattleMsgPlayerMoveCtrl:process")
	local touch = SceneBattle:getBattleTouch()
	local loop = SceneBattle:getBattleLoop()

	if loop:getBattleStatus() ~= BattleLoop.S_PLAYER_MOVE then
		WZLog("BattleMsgPlayerMoveCtrl:process 00000")
		return true
	end

	hero = WBattleGlobal:getCurrent():getCurrentCharacter()
	if hero.m_bIsDead == true then
		WZLog("BattleMsgPlayerMoveCtrl:process 11111")
		return true
	end

    if BattleMsgPlayerMoveCtrl.m_nCurPositionX and (BattleMsgPlayerMoveCtrl.m_bIsCollision) and hero:getMover():isCollision() then
	    local posPre = BattleCommon:getPointTable(BattleMsgPlayerMoveCtrl.m_nCurPositionX, BattleMsgPlayerMoveCtrl.m_nCurPositionY)
	    local pos = BattleCommon:getPointTable(hero:getMover():getMoverPosition().x, hero:getMover():getMoverPosition().y)
	    local dis = BattleCommon:pointDis(posPre, pos)
	    WZLog("BattleMsgPlayerMoveCtrl:process one 1", hero:getMover():isCollision(), dis, posPre.x, posPre.y, pos.x, pos.y)

	    if dis > 1 then
	        if TeachGroup1.ISBATTLE_MYTURN ~= true then
                local pf, offset = hero:getPF(), 0.3
                if WBattleGlobal:getCurrent():isEscapeBattle() then
                	offset = 0.1
                end
	            hero:setPF(math.floor(hero:getPF() - dis * offset) )
                WZLog("BattleMsgPlayerMoveCtrl:process one 2", pf, hero:getPF(), dis)
	        end
	    end
	end
	if hero:getMover() then
		BattleMsgPlayerMoveCtrl.m_nCurPositionX = hero:getMover():getMoverPosition().x
		BattleMsgPlayerMoveCtrl.m_nCurPositionY = hero:getMover():getMoverPosition().y
	    BattleMsgPlayerMoveCtrl.m_bIsCollision = hero:getMover():isCollision()
	else
		WZLog("BattleMsgPlayerMoveCtrl:process 22222")
		return true
	end

	WZLog("BattleMsgPlayerMoveCtrl:process one 3", tostring(BattleMsgPlayerMoveCtrl.m_bIsCollision), tostring(hero:getMover():isCollision()), tostring(BattleMsgPlayerMoveCtrl.m_nCurPositionX), tostring(BattleMsgPlayerMoveCtrl.m_nCurPositionY), 
		hero:getMover():getMoverPosition().x, hero:getMover():getMoverPosition().y)

	if hero:getMover():isCollision() then
		BattleMsgPlayerMoveCtrl.m_nCurPositionX = hero:getMover():getMoverPosition().x
		BattleMsgPlayerMoveCtrl.m_nCurPositionY = hero:getMover():getMoverPosition().y
	    BattleMsgPlayerMoveCtrl.m_bIsCollision = hero:getMover():isCollision()
	else
		BattleMsgPlayerMoveCtrl.m_nCurPositionX = nil
		BattleMsgPlayerMoveCtrl.m_nCurPositionY = nil
		BattleMsgPlayerMoveCtrl.m_bIsCollision = hero:getMover():isCollision()
	end

    if TeachGroup1.ISBATTLE_MYTURN and TeachGroup1.ISMOVING ~= true then
    	WZLog("BattleMsgPlayerMoveCtrl:process 33333")
        return true
    end

    local hasMsg = MsgManager:hasNewBlockMsg()
    local touch1 = touch and touch:getTouchPoint(1) and GlobalMethod:ccp(touch:getTouchPoint(1).x, touch:getTouchPoint(1).y)
	if ((hasMsg and TeachGroup1.ISBATTLE_MYTURN ~= true) or touch1 == nil or touch:getTouchPoint(1) == nil) then
        WZLog("BattleMsgPlayerMoveCtrl:process 1")
		return true
	end

	if TeachGroup1.ISBATTLE_MYTURN or loop:getBattleStatus() == BattleLoop.S_PLAYER_MOVE then
		if TeachGroup1.ISBATTLE_MYTURN or touch:getTouchStatus(1) == BattleTouch.TOUCH_HOLD or touch:getTouchStatus(1) == BattleTouch.TOUCH_END then
			
			if hero:getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() then

				local step
				local anim = WBattleGlobal:getCurrent():getCurrentCharacter():getAnimation()
				local touchPoint = GlobalMethod:ccp( touch:getTouchPoint(1).x,touch:getTouchPoint(1).y )
				touchPoint = touch:pointWorldToNode( anim:getAnimNode() , touchPoint )
				if hero:getPF() - 1 * hero.m_nMoveRate / 100 <0 then
                    WZLog("BattleMsgPlayerMoveCtrl:process 2")
					return true
				end
				if math.abs(anim:getPosition().x - touchPoint.x ) >= self.MIN_ENABLEMOVE_DISTANCE then
					if anim:getPosition().x < touchPoint.x then
						step = 0
					else
						step = 1
					end
                    if TeachGroup1.ISBATTLE_MYTURN and ((anim:getPosition().x > 870) or anim:getPosition().x < 470 and step == 1) then
                        WZLog("BattleMsgPlayerMoveCtrl:process 3")
                        return false
                    end

					local msg = MsgManager:createMsg(BattleMsgPlayerMove)
					msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
					msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
					msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
					msg.m_nMovecount = 1
					msg.m_tMovestep = {}
					table.insert(msg.m_tMovestep, step)
					msg.m_nCurPositionX = anim:getPosition().x
					msg.m_nCurPositionY = anim:getPosition().y
					MsgManager:pushNonBlockMsg(msg)
				end
                WZLog("BattleMsgPlayerMoveCtrl:process 4")
				return false
			end
		end
	end

    WZLog("BattleMsgPlayerMoveCtrl:process 5")
	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgPlayerMoveCtrl:done()
	WZLog("BattleMsgPlayerMoveCtrl:done")
    BattleMsgPlayerMoveCtrl.isRun = nil
	local loop = SceneBattle:getBattleLoop()
	if loop:getBattleStatus() == BattleLoop.S_PLAYER_MOVE then
		if WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() then
			loop:setBattleStatus(BattleLoop.S_NORMAL)
			local curHero = WBattleGlobal:getCurrent():getCurrentCharacter()
			WZLog("BattleMsgPlayerMoveCtrl:done  11111")
			if not curHero:isDead() then 
				curHero:getAnimation():play(curHero:getNormalAnimationName(), true)
			end
		end
		WndBattleHud:setHudBtnOpacity()
	end
	
end

-------------------------------------私有方法模块--------------------------------------
