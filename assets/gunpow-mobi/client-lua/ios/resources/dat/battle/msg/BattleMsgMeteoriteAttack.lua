--BattleMsgMeteoriteAttack.lua
--@brief	陨石袭击消息
--@date		2014/8/28
--@author	莫剑峰
--@note

--@brief	消息数据表
BattleMsgMeteoriteAttack = {
    m_sName = "BattleMsgMeteoriteAttack",
	m_nBattleId = 0, --战斗id
	m_nPlayerOrGuai = 0, --是玩家还是怪
	m_nCurrentPlayerId = 0, --角色id(当前在操作的角色）
	m_tSpeed = nil, --发射速度
	m_nLeftRight = 0, --1：左 0：右（向左还是向右）
	m_tStartPos = nil, --发射初始位置
	m_nPlayerCount = 0, --同步角色数量
	m_tPlayerIds = nil, --用户id
	m_tCurPositionX = nil, --没飞行前的x坐标
	m_tCurPositionY = nil, --没飞行前的y坐标
    m_nGuaiCount = 0, --同步角色数量
	m_tGuaiBattleIds = nil, --怪物id
	m_tGuaiCurPositionX = nil, --怪没飞行前的x坐标
	m_tGuaiCurPositionY = nil, --怪没飞行前的y坐标

-------------------------------------处理逻辑使用的变量--------------------------------------
	m_nHurtNum = 0,				--伤害数字数量
	m_tStepFunction = nil,		--步骤函数
	m_tScreenSpring = nil,		--屏幕是否在震动
    
    m_status = 0, --状态    
    m_nFollowBulletTime = 0, --子弹跟踪时间
    m_nShootDeltaTime = 0,   --发炮间隔时间
    
    m_tOwner = nil,   --拥有者
    m_sReadyShootAnim = "", --准备射击的动画名称    
    m_nBulletType = 0,  --子弹类型    
    m_nCheckCharacterCollisionRadius = 0,   --与人物碰撞时使用的半径    
    m_bIsPenetrateMap = false, --是否穿透地图    
    m_nAttTimes = 0, --攻击次数
    m_nAttack = 0,  --子弹攻击力               
    m_tAcceleration = nil,--子弹加速度    
    m_tNotCheckCollisionBulletList = nil, --不需要检测碰撞的子弹
    
    --子弹动画属性
    m_sBulletAnimMainName = "", --子弹动画主动画名
    m_sBulletAnimFlyName = "", --子弹动画飞行动画名
    m_sBulletAnimExplodeName = "", --子弹动画爆破动画名
    m_sBulletAnimExplodeWeaponName = "", --子弹动画爆破花纹所属的武器名
    m_nBulletAnimScale = "", --子弹动画放大率

    m_tTargetHero = nil,  --目标玩家
    m_nAttackerId = 0,      --发起者ID

}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgMeteoriteAttack:init()
	WZLog("BattleMsgMeteoriteAttack:init")
	if SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_NORMAL then
		return
	end
	SceneBattle:getBattleLoop():setBattleStatus(BattleLoop.S_PLAYER_SHOOT)
    WBattleGlobal:getCurrent().m_nMeteoriteAttack = self.m_nAttackerId
    local hero = self.m_tOwner
	if hero == nil then
		WZLog("BattleMsgMeteoriteAttack:init", "can't find player:", self.m_nCurrentPlayerId)
		return
    end    

	hero:setRunStatus(RunStatus.DEF_ST_READY_SHOOT)

	if self.m_nLeftRight == 1 then
		hero:getAnimation():setFlipX(true)
	else
		hero:getAnimation():setFlipX(false)
	end

	self:_playReadyShootAnim()

	WndBattleHud:setPassTurnBtnEnable(false)
	WndBattleHud:endTurnTime()

    self.m_tNotCheckCollisionBulletList = {}

	--协议发送
    self.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
	self.m_nPlayerOrGuai = 1
	self.m_nCurrentPlayerId = hero.m_nBattleId
    
    if hero:getAnimation():isFlipX() then
        self.m_nLeftRight = 1
        else
        self.m_nLeftRight = 0
    end
    
    local tHeroList = WBattleGlobal:getCurrent():getHeroList()
	self.m_nPlayerCount = 0
	self.m_tPlayerIds = {}
	self.m_tCurPositionX = {}
	self.m_tCurPositionY = {}
    
    local tGuaiList = WBattleGlobal:getCurrent():getGuaiList()
    self.m_nGuaiCount = 0
	self.m_tGuaiBattleIds = {}
	self.m_tGuaiCurPositionX = {}
	self.m_tGuaiCurPositionY = {}
    
    for i ,v in pairs(tHeroList) do
        self.m_nPlayerCount = self.m_nPlayerCount + 1
        
        self.m_tPlayerIds[self.m_nPlayerCount] = v.m_nPlayerId
        self.m_tCurPositionX[self.m_nPlayerCount] = v:getPosition().x
        self.m_tCurPositionY[self.m_nPlayerCount] = v:getPosition().y
        
    end
    
    for i ,v in pairs(tGuaiList) do
        self.m_nGuaiCount = self.m_nGuaiCount + 1
        
        self.m_tGuaiBattleIds[self.m_nGuaiCount] = v.m_nPlayerId
        self.m_tGuaiCurPositionX[self.m_nGuaiCount] = v:getPosition().x
        self.m_tGuaiCurPositionY[self.m_nGuaiCount] = v:getPosition().y
    end
    
    --ProtocolProcessorBattleInterface:send_BATTLE_Shoot(self.m_nBattleId, self.m_nCurrentPlayerId, self.m_tSpeed.x, self.m_tSpeed.y, self.m_nLeftRight, self.m_tStartPos.x, self.m_tStartPos.y, self.m_nPlayerCount, self.m_tPlayerIds, self.m_tCurPositionX, self.m_tCurPositionY, self.m_nPlayerOrGuai, self.m_nGuaiCount, self.m_tGuaiBattleIds, self.m_tGuaiCurPositionX, self.m_tGuaiCurPositionY)

    --处理步骤
	self.m_tStepFunction = {}
	table.insert(self.m_tStepFunction,self._repeatShoot)
	table.insert(self.m_tStepFunction,self._shooting)
	table.insert(self.m_tStepFunction,self._waitForBulletAndHurt)
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgMeteoriteAttack:process()
	WZLog("BattleMsgMeteoriteAttack:process")
    
	if SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_SHOOT then
		return true
	end

	--更新子弹状态
	self:_updateBullet()

    --子弹跟随
    self:_followBullet()

	--屏幕震动
	self:_updateScene()

	if #self.m_tStepFunction > 0 then
		local res = self.m_tStepFunction[1](self)
		if res == true or res == nil then
			table.remove(self.m_tStepFunction,1)
		end
		return false
	else
		return true
	end

	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgMeteoriteAttack:done()
	WZLog("BattleMsgMeteoriteAttack:done")
	local loop = SceneBattle:getBattleLoop()
	if loop:getBattleStatus() == BattleLoop.S_PLAYER_SHOOT then
		loop:setBattleStatus(BattleLoop.S_NORMAL)
	end
    WBattleGlobal:getCurrent().m_nMeteoriteAttack = 0
    BattleMsgCanStartCurRound.msgDone(self)
end


-------------------------------------私有方法模块--------------------------------------

--@brief	播放准备射击动画
function BattleMsgMeteoriteAttack:_repeatShoot()
    WZLog("BattleMsgMeteoriteAttack:_repeatShoot")

    self.m_nShootDeltaTime = self.m_nShootDeltaTime + SceneBattle:getBattleLoop():getBattleDeltaTime()
    
	local hero = self.m_tOwner
	if self.m_nAttTimes <= 0 then
		hero:setRunStatus(RunStatus.DEF_ST_SHOOT)
        
		return true
	end
	if self.m_nShootDeltaTime >= 0.45 then
        self.m_nShootDeltaTime = 0
		self:_createBullet()
		if self.m_nAttTimes <=  1 then
			hero:setRunStatus(RunStatus.DEF_ST_SHOOT)
                        
			self.m_nAttTimes = self.m_nAttTimes - 1
			return true
		else
			hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
            
			self.m_nAttTimes = self.m_nAttTimes - 1
			return false
		end
	else
		hero:setRunStatus(RunStatus.DEF_ST_REPEAT_SHOOT)
		return false
	end
end

--@brief	播放正在射击动画
function BattleMsgMeteoriteAttack:_shooting()
    WZLog("BattleMsgMeteoriteAttack:_shooting")

	local hero = self.m_tOwner
	--self:_followBullet()
	if hero:getAnimation():isPlaying("stand") or hero:getAnimation():isCurrentAnimationDone() == true or self:_isHaveBullet() == false then
		hero:setRunStatus(RunStatus.DEF_ST_NORMAL)
        
		return true
	else
		hero:setRunStatus(RunStatus.DEF_ST_SHOOT)
		return false
	end
end

--@brief	等待子弹消失和英雄受伤
function BattleMsgMeteoriteAttack:_waitForBulletAndHurt()
    WZLog("BattleMsgMeteoriteAttack:_waitForBulletAndHurt")

	if self:_waitForBullet() and self:_waitForHurtNum() then
		BattleMsgCanStartCurRound.msgProcess(self)
		return true
	else
		return false
	end
end

--@brief	等待子弹消失
function BattleMsgMeteoriteAttack:_waitForBullet()
    WZLog("BattleMsgMeteoriteAttack:_waitForBullet")

	--self:_followBullet()
	if self:_isHaveBullet() == false then
		return true
	else
		return false
	end
end

--@brief	等待受伤数字消失
function BattleMsgMeteoriteAttack:_waitForHurtNum()
    WZLog("BattleMsgMeteoriteAttack:_waitForHurtNum")

	return not WBattleGlobal:getCurrent():IsAnyOneHurt()
end

--@brief	对英雄添加受伤数字
--@param	charas:英雄列表
--@param	hurtValue:受伤数字
function BattleMsgMeteoriteAttack:_charaAddHurtValue(charas,hurtValue)
	local returnChara = {}
	for id,chara in pairs(charas) do
		if hurtValue[id] > 0 then
			returnChara[id] = chara
			chara:markHurt(hurtValue[id])
		end
	end
	return returnChara
end

--@brief	更新子弹状态
function BattleMsgMeteoriteAttack:_updateBullet()
    WZLog("BattleMsgMeteoriteAttack:_updateBullet one")

	local bullets = WBattleGlobal:getCurrent():getBossBulletsList()
    WZLog("BattleMsgMeteoriteAttack:_updateBullet two"..#bullets)
	for i=#bullets,1,-1 do
        bullets[i]:updatePosition()
        
        --碰撞检测
        local isCollision = false
        local notCheckCollision = false
        for j,v in pairs(self.m_tNotCheckCollisionBulletList) do
            if v ~= nil and v == bullets[i] then
                notCheckCollision = true
                WZLog("BattleMsgMeteoriteAttack:_updateBullet three"..tostring(bullets[i]).." v = "..tostring(v))
            end
        end
        
        if notCheckCollision then
            isCollision = false
        else
            if self.m_bIsPenetrateMap == true then
                isCollision,_ = bullets[i]:checkCharacterCollision()
            else
                isCollision = bullets[i]:checkCollision()
            end
        end
        if isCollision then
            SoundManager:playEffectSound(SoundDefine.E_S_EXPLODE)
            WZLog("BattleMsgMeteoriteAttack:_updateBullet four"..tostring(bullets[i]))
            table.insert(self.m_tNotCheckCollisionBulletList, bullets[i])
            local charas,values = self:_checkHurt(bullets[i])
            charas = self:_charaAddHurtValue(charas,values)
             self:_sendHurtProtocol(charas,values)
            if i==1 and self:_getIsSceneSpring() == false then
                self:_setSceneSpring(bullets[i]:getMover():getMoverPosition())
            end

            WBattleGlobal:getCurrent():enableAllHeroFallDown()

            bullets[i]:DigHole()
            bullets[i]:destroy()
            WBattleGlobal:getCurrent():removeBossBulletByIndex(i)
        elseif notCheckCollision and bullets[i]:checkCharacterCollision() then
            WZLog("BattleMsgMeteoriteAttack:_updateBullet five")
            self:_setSceneSpring(BattleCommon:getPointTable(0,0))
        --飞出屏外
        elseif bullets[i]:checkOutOfScene() then
            WZLog("BattleMsgMeteoriteAttack:_updateBullet six")
            bullets[i]:destroy()
            WBattleGlobal:getCurrent():removeBossBulletByIndex(i)
        end
	end
end

--@brief	更新屏幕(主要是屏幕震动)
function BattleMsgMeteoriteAttack:_updateScene()
    WZLog("BattleMsgMeteoriteAttack:_updateScene")

	if self.m_tScreenSpring ~= nil then
		BattleScreen:setSpring(self.m_tScreenSpring)
		if BattleScreen:screenSpring() == true then
			self.m_tScreenSpring = nil
		end
	end
end

--@brief	设置屏幕震动
--@param	tPos:震动时的位置
function BattleMsgMeteoriteAttack:_setSceneSpring(tPos)
	self.m_tScreenSpring = {x=tPos.x,y=tPos.y}
end

--@brief	判断是否屏幕震动
--@return	＃1:true/false
function BattleMsgMeteoriteAttack:_getIsSceneSpring()
	return self.m_tScreenSpring ~= nil
end

--@brief	发送受伤协议
function BattleMsgMeteoriteAttack:_sendHurtProtocol(charas,values)
    WZLog("BattleMsgMeteoriteAttack:_sendHurtProtocol")

    WBattleGlobal:getCurrent():sendHurtProtocol(self.m_nAttackerId,charas,values,nil,nil,nil,-3)
end

--@brief	播放准备射击的动画
function BattleMsgMeteoriteAttack:_playReadyShootAnim()
    self.m_tOwner:getAnimation():play(self.m_sReadyShootAnim,false)
end

--@brief	屏幕跟踪子弹
function BattleMsgMeteoriteAttack:_followBullet()
    WZLog("BattleMsgMeteoriteAttack:_followBullet")

	local bullet = WBattleGlobal:getCurrent():getBossBulletByIndex(1)
	if bullet ~= nil then
		if self._followBullet_time_ == nil then
			self._followBullet_time_ = 0
		else
			self._followBullet_time_ = self._followBullet_time_ + SceneBattle:getBattleLoop():getBattleDeltaTime()
		end
		if self:_getIsSceneSpring() == false then
			--BattleScreen:followBullet(bullet:getMover():getMoverPosition(),self._followBullet_time_)
		end
	end
end

--@brief	是否还有子弹
--@return	#1：true：是，false：否
function BattleMsgMeteoriteAttack:_isHaveBullet()
	local bullet = WBattleGlobal:getCurrent():getBossBulletByIndex(1)
	if bullet ~= nil then
		return true
	end
	return false
end

--@brief	创建子弹
function BattleMsgMeteoriteAttack:_createBullet()
    WZLog("BattleMsgMeteoriteAttack:_createBullet")

    local pos = nil
    if self.m_nAttTimes == 3 then
        pos = BattleCommon:getPointTable(self.m_tStartPos.x - 150,self.m_tStartPos.y)
    elseif self.m_nAttTimes == 2 then
        pos = BattleCommon:getPointTable(self.m_tStartPos.x + 150,self.m_tStartPos.y)
    else
        pos = BattleCommon:getPointTable(self.m_tStartPos.x,self.m_tStartPos.y)
    end

    local anim = self:_createBulletAnim()
    local bullet = WBattleGlobal:getCurrent():buildBossBullet(anim,pos,self:_shootLine(pos),self.m_tAcceleration,self.m_tOwner,self.m_nBulletType)
        
    bullet:setCheckCharacterCollisionRadius(self.m_nCheckCharacterCollisionRadius)
    bullet:setAnimDefaultDirection(1)

    SceneBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode())

    if self.isOldAnim then
        bullet.m_anim:setRotate(270)
    else
        anim:setPosition(BattleCommon:getPointTable(pos.x, pos.y))
        anim:play("1",true)
        anim:play("0",true,"tssj_huomiao")
        anim:play("0",true,"tssj_huoyan")
        bullet.m_bIsNoRotate = true
    end

    
end

--@brief	创建子弹动画
--@return	子弹动画
function BattleMsgMeteoriteAttack:_createBulletAnim()
    local bullet = nil

    self.isOldAnim = true
    if self.isOldAnim then
        bullet = BattleAnimation:createAnimation(self.m_sBulletAnimMainName)
        bullet:addAnimation(self.m_sBulletAnimFlyName,{}, 0.1, true)
        bullet:setScale(self.m_nBulletAnimScale)
        bullet:play(self.m_sBulletAnimFlyName,true)
    else
        bullet = BattleAnimation:createAnimation("tssj_ys", true)
        bullet:setScale(self.m_nBulletAnimScale)
    end
    return bullet
end

--@brief	检查伤害
--@return	#1:受伤的人物列表
--@return	#2:受伤值
function BattleMsgMeteoriteAttack:_checkHurt(bullet)
    WZLog("BattleMsgMeteoriteAttack:_checkHurt")

	local tHurtCharas = {}
	local tHurtValues = {}
    tHurtCharas,_ = bullet:checkHurt()
    for id,chara in pairs(tHurtCharas) do
        local hurtValue = self:_getHurt(chara)
        tHurtValues[id] = hurtValue
    end
	return tHurtCharas,tHurtValues
end

--@brief	计算伤害
--@return	#1：伤害
function BattleMsgMeteoriteAttack:_getHurt(chara)
    local bullet = WBattleGlobal:getCurrent():getBossBulletByIndex(1)
	local bulletPos = bullet:getMover():getMoverPosition()
	local charaPos = chara:getCenterPos()
	
    if chara:getIsInvincible() then
		hurt = 1
    elseif self.m_bIsIgnoreDef == true then
        hurt = self.m_nAttack
    end
    
	return hurt
end

--@brief	计算直线射击
--@return   发射速度
function BattleMsgMeteoriteAttack:_shootLine(startPos)
	local targetHero = self.m_tTargetHero
    
    local eOffset = BattleCommon:getPointTable(targetHero.m_anim:getAnimNode():getContentSize().width * 0, targetHero.m_anim:getAnimNode():getContentSize().height * 0.3)
	local sPos = BattleCommon:getPointTable(self.m_tStartPos.x, self.m_tStartPos.y)

    if startPos ~= nil then
        sPos.x = startPos.x
        sPos.y = startPos.y
    end

	local ePos = BattleCommon:getPointTable(targetHero:getPosition().x + eOffset.x,targetHero:getPosition().y + eOffset.y)
	local angle
	local face
    
    local power = 8
    local scale = 2
    local speed = {}
    
    if ePos.x <= sPos.x then
		face = 1
    else
		face = 0
	end
    
    if face == 1 then
        speed.x = -1 * scale
    else
        speed.x = scale
    end
    
    --斜率公式
    if (ePos.x - sPos.x == 0) then
        speed.x = 0
        speed.y = -10
    elseif (ePos.y - sPos.y == 0) then
        if (ePos.x - sPos.x >= 0) then
            speed.x = 10
        else
            speed.x = -10
        end
        speed.y = 10
    else
        speed.y = (speed.x) / ((ePos.x - sPos.x) / (ePos.y - sPos.y))
    end

    speed.x = speed.x * power * 0.8
    speed.y = speed.y * power * 0.8

    WZLog("BattleMsgBossMapShoot:_shootLine ", speed.x, speed.y, ePos.x, ePos.y, sPos.x, sPos.y, power)
    return speed
end