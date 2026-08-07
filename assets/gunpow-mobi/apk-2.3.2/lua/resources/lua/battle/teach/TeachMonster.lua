--TeachMonster.lua
--@brief	怪物数据表
--@date		2014/11/5
--@author	莫剑峰
--@note		怪物相关属性及操作

--@brief	怪物数据表
TeachMonster = {
    m_tBossName = nil,              --怪物的名称与血条
    m_tDialog = nil ,               --剧情对话框
    
    m_nAiType = 0,                  --攻击类型 0:会远近攻 1:只会远攻 2:只会近攻 3:不会攻击不会移动 4:着装
    m_sAniFileId = nil,             --动画ID
    m_nCurDirect = nil, 			--当前方向（0：左，1：右）
	m_tPosition = nil,				--怪的位置
	m_tMoveSpeed = nil, 			--小怪速度
	m_tGuaiName = nil, 				--boss的名称与血条
	m_bActFinished = nil, 			--行动是否完成
	m_bMovePlayed = nil, 			--移动动画是否已经播放
	m_bAttackPlayed = nil, 			--攻击动画是否已经播放
	m_bIsAddedInScene = nil, 		--是否被添加进当前场景
	m_tTargetPlayer = nil,			--目标玩家
	m_bPlayerHurt = nil, 			--是否有玩家受伤
	m_nHurtValue = nil, 			--玩家所受伤害
    m_nAttackArea = 0,               --小怪攻击范围
    m_bIsAtkAfterMove = false,      --是否移动完会攻击
    m_tCollisionCharacters = nil,   --需要检测攻击的角色
    m_bIsOutOfScene = false,		--是否在屏幕之外
    
    m_tAiScript = nil,              --怪物的AI
    m_tDialogue = nil,              --对话文本
    m_bIsOldAnim = false,           --是否旧动画
    m_bIsFilpX = false,             --是否翻转
    m_nAttTimes = 1,					--攻击次数,正常为1
	m_nAttScatterNum = 1,				--散射子弹数,正常为1
}

--@brief	AI类型
MonsterAiType = {
    AI_RANGED_MELEE = 0,            --远程攻击和近身攻击
    AI_RANGED = 1,                  --远程攻击
    AI_MELEE = 2,                   --近身攻击
	AI_NO_ACTION = 3,               --没有动作
    AI_MELEE_SKY = 4,               --近身攻击_空中型
    AI_ROBOT = 5,                   --机器人远程
}

--@brief	AI动作类型
MonsterAiAction = {
	ACTION_MOVE = 1,                --移动
	ACTION_RAND = 2,                --随机动作
	ACTION_SHOOT = 3,               --射击
	ACTION_FLY = 4,                 --飞行
	ACTION_SKILL = 5,               --使用技能
	ACTION_ITEM = 6,                --使用道具
    ACTION_MOVE_MOSTER = 7,         --移动
    ACTION_SHOOT_MOSTER = 8,        --射击
    ACTION_MELEE_MOSTER = 9,        --近身攻击
}
-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个怪物
--@return	#1:怪物数据表
function TeachMonster:buildGuai(nIndex)
    WZLog("TeachMonster:buildGuai", nIndex)
	local boss = TeachMonster:new()
    
    boss.m_nAttackArea = 80
    
	--怪ai类型
	boss.m_nAiType = 1
    boss.m_sAniFileId = "monster1"
    WZLog("TeachMonster:buildGuai", boss.m_nAiType, boss.m_sAniFileId)
    
    --初始化动画
    boss.m_bIsOldAnim = false
    local animOldList = {}
    table.insert(animOldList, "monster1")
    table.insert(animOldList, "monster2")
    table.insert(animOldList, "monster3")
    table.insert(animOldList, "monster4")
    table.insert(animOldList, "monster5")
    table.insert(animOldList, "boss")
    table.insert(animOldList, "boss2-1")
    table.insert(animOldList, "boss2-2")
    table.insert(animOldList, "boss3-1")
    table.insert(animOldList, "boss3-2")
    table.insert(animOldList, "boss4")
    table.insert(animOldList, "boss5")
    table.insert(animOldList, "boss6")
    table.insert(animOldList, "worldboss")
    for i, v in pairs (animOldList) do
        if boss.m_sAniFileId == v then
            boss.m_bIsOldAnim = true
            break
        end
    end
    if boss.m_bIsOldAnim == true then
        boss:initAnim()
    else
        boss:initAnim2()
    end
    
    --添加头像
    local iconName = boss.m_sAniFileId
    boss.m_headAnim = CCSprite:create("image/ui/main/bossMap/guaiicon/"..iconName..".png")
	boss.m_headAnim:retain()
    
    --小怪Mover
    boss.m_mover = WDMoveEntity:create(boss.m_anim:getAnimNode())
    boss.m_mover:setAdjustChild(true)
	boss.m_mover:retain()
    
    --添加碰撞矩形范围
    if boss.m_bIsOldAnim == true then
        local size = boss.m_anim:getAnimNode():getContentSize()
        local centerPos = boss:getCenterPos()
        
        if boss.m_sAniFileId == "monster2" then
            --boss:addRectCollision(size.width * 0.85,size.height * 0.55,centerPos.x,centerPos.y)
        else
            --boss:addRectCollision(size.width * 2,size.height * 2,centerPos.x,centerPos.y)
        end
        
        boss:showCollisionRang(true)
    end
    
    local center = Vector2:create(0,50)
	boss.m_mover:setMoverCenter(center)
	boss.m_mover:setMoverRadius(10)
    
    --受伤半径
    boss.m_fRadiusForBulletCollision = boss.m_anim:getAnimNode():getContentSize().width * 0.25
	boss.m_fRadiusForHurt = boss.m_anim:getAnimNode():getContentSize().width * 0.4

	boss:setRadiusForBulletExplode(8)
    
    --设置当前方向向左
	boss.m_nCurDirect = 0
	--设置默认移动速度
	boss.m_tMoveSpeed = {x=-3.1, y=-1}
    
	--设置小怪信息
	--WBattleGlobal:getCurrent():setGuaiInfo(boss, boss.m_sAniFileId)
    
    boss:addCollisionCharas(WBattleGlobal:getCurrent():getHeroList())
    
    --绑定AI
	boss:setAI(TeachMonsterAI:new(boss:getBattleId()))
    boss:getAI():setBoss(boss)
    
    --子弹
	boss.m_nWeaponType = 0
	boss.m_sWeaponName = "weapon17a"

	local sExplode = boss.m_sWeaponName
	sExplode = string.format("%sb",string.sub(sExplode,0,sExplode:len()-1))
	sExplode = RESOURCE_BULLET_EXPLODE..sExplode..".png"
	boss.m_bulletCilcle = BattleUtil:getCircleImg(sExplode)
	boss.m_bulletCilcle:retain()

    boss.m_nDebuffFrozenRound = 0
	return boss
end

--@brief	初始化基础动画
function TeachMonster:initAnim()
    WZLog("TeachMonster:initAnim", tostring(self.m_sAniFileId))
    --动画控制对象
	self.m_anim = BattleAnimation:createAnimation(self.m_sAniFileId)
	self.m_anim:getAnimNode():retain()
	self.m_anim:addAnimation("stand",{}, 0.2, true)
    self.m_anim:getAnimNode():setFlipX(true)

    if self.m_sAniFileId == "monster1" then
        self.m_anim:setScale(0.6)
    else
        self.m_anim:setScale(1.0)
    end
    
    --按照攻击类型添加动画
    if self.m_nAiType == MonsterAiType.AI_MELEE or self.m_nAiType == MonsterAiType.AI_MELEE_SKY then
        self.m_anim:addAnimation("move", {}, 0.2, true)
        self.m_anim:addAnimation("melee_attack1", {}, 0.1, true)
    elseif  self.m_nAiType == MonsterAiType.AI_RANGED then
        self.m_anim:addAnimation("ranged_attack1", {}, 0.1, true)
        self.m_anim:addAnimation("ranged_attack2", {}, 0.1, true)
        self.m_anim:addAnimation("ranged_attack3", {}, 0.1, true)
    end
    
    self.m_anim:addAnimation("injured", {}, 0.1, true)
    self.m_anim:addAnimation("die1", {}, 0.1, true)
    
    --商城形象
	self.m_shopAnim = BattleAnimation:createAnimation(self.m_sAniFileId)
	self.m_shopAnim:getAnimNode():retain()
	self.m_shopAnim:addAnimation("stand",{}, 0.2, true)
	self.m_shopAnim:playTimes("stand",0)
    self.m_shopAnim:getAnimNode():setFlipX(true)
    
end

--@brief	初始化骨骼基础动画
function TeachMonster:initAnim2()
    WZLog("TeachMonster:initAnim2", tostring(self.m_sAniFileId))
    --动画控制对象
	self.m_anim = BattleAnimation:createAnimation(self.m_sAniFileId, true)
	self.m_anim:getAnimNode():retain()
    self.m_anim:setScale(1.0)
    self.m_anim:getAnimNode():setFlipX(true)
    
    --商城形象
	self.m_shopAnim = BattleAnimation:createAnimation(self.m_sAniFileId, true)
	self.m_shopAnim:getAnimNode():retain()
    self.m_shopAnim:setScale(1.25)
	--self.m_shopAnim:play("0",true)
    self.m_shopAnim:getAnimNode():setFlipX(true)
    
end

--@brief	添加冰冻动画
function TeachMonster:addFrozenAnimation()
    WZLog("TeachMonster:addFrozenAnimation")
    if self.m_frozenAnim == nil then
        self.m_nDebuffFrozenRound = 3
        self.m_frozenAnim = BattleAnimation:createAnimation(WANI_IWCO_WORLDBOSS1)
        self.m_frozenAnim:addAnimation("freeze",{},0.1,true)
        self.m_frozenAnim:play("freeze",true)
        local size = self.m_anim:getAnimNode():getContentSize()
    self.m_frozenAnim:getAnimNode():setPosition(GlobalMethod:ccp(size.width*0.50,size.height*0.00))
        self.m_frozenAnim:getAnimNode():setScale(1.1)
        self.m_anim:getAnimNode():addChild(self.m_frozenAnim:getAnimNode(), 10)
    end
end

--@brief	移除冰冻动画
function TeachMonster:removeFrozenAnimation()
    if self.m_frozenAnim ~= nil then
        self.m_frozenAnim:getAnimNode():removeFromParentAndCleanup(true)
        self.m_frozenAnim = nil
    end
end

--@brief	设置是否死亡
function TeachMonster:setDead(bDead)
    WZLog("TeachMonster:setDead")
        self.m_bIsDead = bDead
        --self:setHp(0)
        if self.m_bIsOldAnim == true then
            self:getAnimation():playTimes("die1",1)
        else
            self:getAnimation():play("4",false)
        end

end

--@brief 	设置人物名称
--@param 	name:人物名称
function TeachMonster:setName(name)
    self.m_sName = name
end

--@brief 	获得人物名称
--@return 	#1, 返回人物名称
function TeachMonster:getName()
	return self.m_sName
end

--@brief 	获取头像路径
--@return 	头像路径
function TeachMonster:getHeadPath()
    return "image/ui/main/bossMap/guaiicon/monster1.png"
end

--@brief	获取头像控制对象
--@return	#1:Animation动画控制对象
function TeachMonster:getHeadAnimation()
	return self.m_headAnim
end

--@brief	普通动画名字
function TeachMonster:getNormalAnimationName()
    --WZLog("TeachMonster:getNormalAnimationName")
    if self.m_bIsOldAnim == true then
        return "stand"
    else
        return "0"
    end
	
end

--@brief	受伤动画名字
function TeachMonster:getHurtAnimationName()
    --WZLog("TeachMonster:getHurtAnimationName")
    if self.m_bIsOldAnim == true then
        return "injured"
    else
        return "3"
    end
	
end

--@brief	死亡动画名字
function TeachMonster:getDeadAnimationName()
    --WZLog("TeachMonster:getDeadAnimationName")
    if self.m_bIsOldAnim == true then
        return "ghost"
    else
        return "4"
    end
	
end

--@brief	添加人物碰撞列表
--@param	tCharas:人物碰撞列表
function TeachMonster:addCollisionCharas(tCharas)
    if self.m_tCollisionCharacters == nil then
        self.m_tCollisionCharacters = {}
    end
    
	table.insert(self.m_tCollisionCharacters,tCharas)
end

--@brief	开始行动
function TeachMonster:startRound()

    if self.m_nDebuffFrozenRound == nil or self.m_nDebuffFrozenRound <= 0 then
        --移除冰冻动画
        self:removeFrozenAnimation()
    end

	if WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId() == self:getBattleId() then
		self:getAI():startRound()
        
	end

end

--@brief	结束行动
function TeachMonster:endRound()
	self:getAI():endRound()
end

--@brief	经过一回合后的英雄状态和属性更新
function TeachMonster:updateByTurn()

    WCharacter.updateByTurn(self)

    if self.m_nDebuffFrozenRound ~= nil and self.m_nDebuffFrozenRound > 0 then
        self.m_nDebuffFrozenRound = self.m_nDebuffFrozenRound - 1
    end
end

--@brief	定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function TeachMonster:update(dt)    
    if self:getAnimation() == nil then
        return nil
    end
    
    WCharacter.update(self,dt)
    self:_addBossName()
    
    --小怪血条和姓名
	if self.m_bIsAddedInScene then
		self:_addGuaiName()
	end
    
	--死亡处理
	if self:isDead() then
        WZLog("TeachMonster:update three")
		if self:getAnimation():isCurrentAnimationDone() then
			self:_removeDeadGuai()
		end
        return nil
	end
    
    local isOutOfScene = self:checkIsOutOfScene()
	if isOutOfScene then
		if self:isOutOfScene()==false then
			if self:isCanControl() == true then
				if not self:isDead() and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_FLY then
					ProtocolProcessorBattleInterface:send_BATTLE_OutOfScene(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self:getBattleId() ,WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId())
					if SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_SHOOT then
						WndBattleHud:setPassTurnBtnEnable(false)
						WndBattleHud:endTurn()
					end
				end
			end
		end
	end
	self.m_bIsOutOfScene = isOutOfScene
    
    ---[[
    
    if self:getHp() > 0 and self:getAnimation():isPlaying(self:getNormalAnimationName()) == false then
        if self:getAnimation():isCurrentAnimationDone() == true then
            self:getAnimation():play(self:getNormalAnimationName(), true)
        end
    end
    --]]
    self:updateFaceAnimation()
    self:getAI():run(dt)
end

--@brief	销毁一个角色
function TeachMonster:destroy()
    --WBattleGlobal:getCurrent().m_battleManager:removeEntity(self:getMover())
	WCharacter.destroy(self)
    self:getAI():destroy()

    if self.m_shopAnim ~= nil then
        self:getShopAnimation():release()
        self.m_shopAnim = nil
    end
    --self.m_headAnim:release()
    if self.m_mover ~= nil then
        self.m_mover:release()
    end
    
    if self.m_headAnim then
        self.m_headAnim:release()
        self.m_headAnim = nil
    end
    
    if self.m_anim then
        self.m_anim:getAnimNode():release()
        self.m_anim = nil
    end
	
	self.m_anim = nil
    --self.m_headAnim = nil
    self.m_mover = nil
    self.m_tSkills = nil
    self.m_tItems = nil
    
    if self.m_tGuaiName ~= nil then
        self.m_tGuaiName:destroy()
    end
    
    if self.m_bulletCilcle ~= nil then
        self.m_bulletCilcle:release()
        self.m_bulletCilcle = nil
    end
end

--@brief	获取武器名字
--@return	#1:武器名字
function TeachMonster:getWeaponName()
    WZLog("TeachMonster:getWeaponName", self.m_sWeaponName)
    if self.m_sWeaponName ~= nil and self.m_sWeaponName ~= "-1" then
        return self.m_sWeaponName
    else
        WZLog("TeachMonster:getWeaponName", "weapon17a")
        return "weapon17a"
    end
end

--@brief	判断是否超出屏幕
function TeachMonster:isOutOfScene()
	return self.m_bIsOutOfScene
end

--@brief	检测是否超出屏幕
--@return	#1:是否超出屏幕
--@return	#2:是否纵向超出屏幕
function TeachMonster:checkIsOutOfScene()
    if self:getMover() == nil then
        return false, false
    end
	if SceneBattle:getFrontLayer() then
		local sceneSize = SceneBattle:getFrontLayerSize()
        local a = self:getMover():getMoverPosition()
        a = {x = a.x,y = a.y}
        
        --纵向超出屏幕
		if a.y < -100 then
			return true, true
            --横向超出屏幕
            elseif a.x < -100 or a.x > sceneSize.width + 100 then
            return true, false
		end
	end
	return false, false
end

--@brief 	设置人物当前的位置
--@param 	tPos 当前位置
function TeachMonster:setPosition(tPos)
	self.m_tPosition = tPos
	self.m_mover:setMoverPosition(Vector2:create(tPos.x,tPos.y))
	self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
end

--@brief	经过一回合后的英雄状态和属性更新
function TeachMonster:updateByTurn()
	WCharacter.updateByTurn(self)

	if self:isHide() then
		self:changeHideTurn(-1)
		if self:isHide()==false then
			self:endHide()
		end
	end
end

--@brief 		小怪移动
--@param		nMoveCount:移动次数
--@param 		vnMoveStep:每次移动的方向
--@note			提供boss重载
function TeachMonster:receiveMove(nMoveCount, vnMoveStep, curPositionX, curPositionY)
    WZLog("TeachMonster:receiveMove")
	self:getAI():move()
    
end

--@brief 		boss远距离射击
--@param  		参数与parse_BOSSMAPBATTLE_OtherShoot返回相同
--@note			提供boss重载
function TeachMonster:receiveShoot(speedx, speedy, leftRight, startX, startY, playerCount, playerIds, curPositionX, curPositionY, guaiCount, guaiBattleIds, guaiCurPositionX, guaiCurPositionY)
	WZLog("TeachMonster:receiveShoot")

end

--@brief 		创建小怪
--@param		guaiCount:小怪数量
--@param 		guaiBattleId:小怪战斗id
--@param		guaiId:小怪数据库id
--@param		guaiPositionX:小怪x位置
--@param		guaiPositionY:小怪y位置
--@note			提供boss重载
function TeachMonster:receiveBuildXiaoGuai(guaiCount, guaiBattleId, guaiId, guaiPositionX, guaiPositionY)

end

--@brief 		游戏结束
--@param  		参数与parse_BOSSMAPBATTLE_GameOver返回相同
--@note			提供boss重载
function TeachMonster:receiveGameOver(firstHurtPlayerId, winCamp, playerCount, playerIds, shootRate, totalHurt, killCount, beKilledCount, addExp, Exp, upgradeExp, nextUpgradeExp, star, eggCount, egg_playeId, egg_Item_Name, egg_item_icon, egg_ItemNum, pices)
    
end

--@brief 		某个英雄死了
--@param  		参数与parse_BOSSMAPBATTLE_SomeOneDead返回相同
--@note			提供boss重载
function TeachMonster:receiveSomeOneDead(deadPlayerCount, PlayerIds, deadGuaiCount, guaiBattleIds)
    if deadPlayerCount >= 1 then

    end
    
    if deadGuaiCount >= 1 then

    end
end

--@brief	以本表为模版，WCharacter表为父表创建一个新的表实例对象
--@return	新建的表实例对象
function TeachMonster:new()
	setmetatable(TeachMonster,{__index = WCharacter})
	local tNewObj = {}
	setmetatable(tNewObj, {__index = TeachMonster})
	tNewObj:setType(CharacterType.TYPE_GUAI)
	tNewObj:_init()
	return tNewObj
end

--@brief 添加boss名称与血条
function TeachMonster:_addBossName()
    do return end
	if self.m_tBossName == nil then
		self.m_tBossName = BattleHeroName:create(self,SceneTeachBattle:getInfoLayer(),false)
        else
		self.m_tBossName:update()
	end
end

--@brief 	获得人物名称信息的显示
--@retrun 	#1, 人物名称信息的显示
function TeachMonster:getPlayerNameIcon()
	return self.m_tBossName
end

--@brief	获取横向方向距离BOSS足够近的玩家
--@param	nDistance:距离
--@return   #1:距离内是否有玩家,#2,玩家数组
function TeachMonster:getHeroNearBoss(nDistance)
    WZLog("TeachMonster:getHeroNearBoss")
    local bIsHeroNearBoss = false
    local heroNearBossList = {}
    local tHeroList = WBattleGlobal:getCurrent():getHeroList()
    for i ,v in pairs(tHeroList) do
        local heroPos = v:getPosition()
        local bossPos = self:getPosition()
        if math.abs(heroPos.x - bossPos.x) <= nDistance then
            bIsHeroNearBoss = true
            table.insert(heroNearBossList,v)
        end
    end
    
	return bIsHeroNearBoss, heroNearBossList
    
end

--@brief	获得距离最近的玩家
function TeachMonster:getNearestPlayer()
    WZLog("TeachMonster:getNearestPlayer")
	local guaiPos = self:getAnimation():getPosition()
	local tPlayerList = WBattleGlobal:getCurrent():getHeroList()
	local nNearestIndex = GlobalGame.g_tPlayerInfo.nPlayerId
	local nNearestDis = 99999
	for i,player in pairs(tPlayerList) do
		local nDisToPlayer = math.abs(player:getAnimation():getPosition().x - guaiPos.x)
		if (not player:isDead()) and nDisToPlayer < nNearestDis then
			nNearestDis = nDisToPlayer
			nNearestIndex = i
		end
	end
	self.m_tTargetPlayer = tPlayerList[nNearestIndex]
	return tPlayerList[nNearestIndex]
end

--@brief	获得距离最远的玩家
function TeachMonster:getFarestPlayer()
    WZLog("TeachMonster:getFarestPlayer")
	local guaiPos = self:getAnimation():getPosition()
	local tPlayerList = WBattleGlobal:getCurrent():getHeroList()
	local nFarestIndex = GlobalGame.g_tPlayerInfo.nPlayerId
	local nFarestDis = 0
	for i,player in pairs(tPlayerList) do
		local nDisToPlayer = math.abs(player:getAnimation():getPosition().x - guaiPos.x)
		if (not player:isDead()) and nDisToPlayer > nFarestDis then
			nFarestDis = nDisToPlayer
			nFarestIndex = i
		end
	end
	self.m_tTargetPlayer = tPlayerList[nFarestIndex]
	return tPlayerList[nFarestIndex]
end

--@brief	获得随机的一个玩家
function TeachMonster:getRandomPlayer()
    WZLog("TeachMonster:getRandomPlayer")
	--随机数
    local nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes()
    local randNumIndex = nTurnTimes % 10 + 1
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
    
    --目标英雄
    local tHeroList = WBattleGlobal:getCurrent():getHeroList()
	local nPlayerCount = 0
    local tPlayerIds = {}
    for i ,v in pairs(tHeroList) do
        if not v:isDead() and WBattleGlobal:getCurrent():isSameTeam(v:getBattleId(),WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId()) ~= true then
            nPlayerCount = nPlayerCount + 1        
            tPlayerIds[nPlayerCount] = v.m_nPlayerId
        end
    end
    
    local targetHeroId = tPlayerIds[randNumList[randNumIndex] % #tPlayerIds + 1]
    self.m_tTargetPlayer = WBattleGlobal:getCurrent():getHeroWithId(targetHeroId)
    return self.m_tTargetPlayer
end

--@brief	获得HP最多的一个玩家
function TeachMonster:getHpMaxPlayer()
    WZLog("TeachMonster:getHpMaxPlayer")
    local tHeroList = WBattleGlobal:getCurrent():getHeroList()
    local hpMaxPlayer = nil
    for i ,v in pairs(tHeroList) do
        if (not v:isDead()) and (hpMaxPlayer == nil or v:getHp() > hpMaxPlayer:getHp()) then
            hpMaxPlayer = v
        end
    end
    
    return hpMaxPlayer
end

--@brief	获得HP最少的一个玩家
function TeachMonster:getHpMinPlayer()
    WZLog("TeachMonster:getHpMinPlayer")
    local tHeroList = WBattleGlobal:getCurrent():getHeroList()
    local hpMinPlayer = nil
    for i ,v in pairs(tHeroList) do
        if (not v:isDead()) and (hpMinPlayer == nil or v:getHp() < hpMinPlayer:getHp()) then
            hpMinPlayer = v
        end
    end
    
    return hpMinPlayer
end

--@brief	获得某区域是否存在玩家
--@return	#1:是否存在
--@return	#2:玩家列表
function TeachMonster:getPlayerWithArea(nLeftPointX, nRightPointX, nUpPointY, nDownPointY)
    if nLeftPointX == nil or nRightPointX == nil then
        return
    end
    
    local tHeroList = WBattleGlobal:getCurrent():getHeroList()
    local nPlayerCount = 0
    local tPlayerIds = {}
    local isHavePlayer = false
    
    for i ,v in pairs(tHeroList) do
        WZLog("TeachMonster:getPlayerWithArea ", v:getPosition().x, nLeftPointX, nRightPointX)
        if not v:isDead() and
            ((v:getPosition().x > nLeftPointX and v:getPosition().x < nRightPointX) or
             (v:getPosition().x < nLeftPointX and v:getPosition().x > nRightPointX) and
            (nUpPointY == nil or
             (v:getPosition().y > nUpPointY and v:getPosition().y < nDownPointY) or
             (v:getPosition().y < nUpPointY and v:getPosition().y > nDownPointY))) then
            isHavePlayer = true
            nPlayerCount = nPlayerCount + 1
            tPlayerIds[nPlayerCount] = v.m_nPlayerId
        end
    end
    return isHavePlayer, tPlayerIds
end

--[[
--@brief        剧情对话
--@param		对话的内容
function TeachMonster:storyTalk(text, needZoomToBoss)
    
    local msg = MsgManager:createMsg(BattleMsgStoryTalk)
    msg.m_sTalkText = text          --文本内容
    msg.m_tPosOffset = GlobalMethod:ccp(20, 200) --位置偏移量
    msg.m_nMaxWidth = 300           --最大宽度
    msg.m_nScale = 1.5              --缩放大小
    msg.m_bNeedZoomToBoss = needZoomToBoss   --是否需要把屏幕移向boss
    msg.m_tOwner = self
    msg.m_tFollowObj = self:getAnimation():getAnimNode()
    msg.m_bIsUpdatePos = true
    WZLog("TeachMonster:storyTalk", tostring( msg.m_bIsUpdatePos))
    MsgManager:pushBlockMsg(msg)
end
--]]

--@brief	设置小怪移动速度
--@param 	tSpeed:下怪移动速度
function TeachMonster:setMoveSpeed(tSpeed)
	self.m_tMoveSpeed = tSpeed
end

--@brief	设置本回合行动是否完成标志
--@param	bActFinished:本回合行动是否完成的标志
function TeachMonster:setActFinished(bActFinished)
	self.m_bActFinished = bActFinished
end

--@brief	小怪是否已经行动完成
function TeachMonster:isActFinished()
	return self.m_bActFinished
end

--@brief 	设置小怪是否被添加进场景标识
--@param	bIsAddedInScene:小怪是否被添加进场景
function TeachMonster:setIsAddedInScene(bIsAddedInScene)
	self.m_bIsAddedInScene = bIsAddedInScene
end

--@brief	初始化小怪血条和名字
function TeachMonster:initGuaiName()
    do return end
	self.m_tGuaiName = BattleHeroName:create(self,SceneTeachBattle:getInfoLayer(),false)
	self.m_tGuaiName:update()
end

--@brief	调整移动方向
function TeachMonster:adjustDirect(tPos)
	if self:_shouldMoveLeft(tPos) then
		self.m_nCurDirect = 0
		self:getAnimation():setFlipX(true)
        self.m_bIsFilpX = true
        if self.m_nAiType == MonsterAiType.AI_MELEE_SKY then
            self.m_tMoveSpeed = {x=-2.1, y=-1}
        else
            self.m_tMoveSpeed = {x=-3.1, y=-1}
        end
    else
		self.m_nCurDirect = 1
		self:getAnimation():setFlipX(false)
        self.m_bIsFilpX = false
        if self.m_nAiType == MonsterAiType.AI_MELEE_SKY then
            self.m_tMoveSpeed = {x=2.1, y=-1}
        else
            self.m_tMoveSpeed = {x=3.1, y=-1}
        end
	end
end


--@brief	同步所有客户端
--@param	aiCtrlId:怪物所使用的策略识别码
function TeachMonster:sendAiProcol(aiCtrlId)
    WZLog("TeachMonsterAI:sendAiProcol")
    
    local battleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
    local playerOrGuai = 1
    local currentId = self:getBattleId()
    ProtocolProcessorSceneBossBattle:send_BOSSMAPBATTLE_NearAttack(battleId, playerOrGuai, currentId, aiCtrlId )
end

--@brief	发送移动协议
function TeachMonster:sendMoveProtocol()
    WZLog("TeachMonster:sendMoveProtocol")
	local battleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId		-- 战斗id
	local playerOrGuai = 1													-- 0:player 1:guai
	local currentId = self:getBattleId()									-- 角色id
	local movecount = 1														-- 移动的次数
	local movestep = {0} 													-- 每一次移动的方向（0：左，1：右）
	local curPositionX = self:getAnimation():getPosition().x				-- 没移动前的x坐标
	local curPositionY = self:getAnimation():getPosition().y				-- 没移动前的y坐标
    
	ProtocolProcessorBattleInterface:send_BATTLE_PlayerMove(battleId, currentId, movecount, movestep, curPositionX, curPositionY)
end

--@brief	播放表情动画
--@param	nFaceId:表情Id
function TeachMonster:playFaceAnimation(nFaceId)
    if nFaceId == -1 then
        return
    end
    
    if nFaceId == 23 then
        nFaceId = 25
    end

	if self.m_faceAnim then
		self.m_faceAnim:getAnimNode():removeFromParentAndCleanup(true)
		self.m_faceAnim = nil
	end

	self.m_faceAnim = BattleAnimation:createAnimation(IWCO_BATTLEFACE)
	self.m_faceAnim:addAnimation("face"..nFaceId,{}, 0.2, true)
	self.m_faceAnim:play("face"..nFaceId,true)

	self:updateFaceAnimation()

	local node = self.m_faceAnim:getAnimNode()
	SceneTeachBattle:getInfoLayer():addChild(node)

	node:setScale(0.2)
	node:setTag(self:getId())
	local act1=CCScaleTo:create(0.2,1)
    local act2=CCDelayTime:create(2.1)
	local act3=CCScaleTo:create(0.2,0.2)
	local act4=CCCallFuncN:create(_playFaceAnimationEnd_TeachMonster)
	local array = CCArray:create()
	array:addObject(act1)
	array:addObject(act2)
	array:addObject(act3)
    array:addObject(act4)
	node:runAction(CCSequence:create(array))
end

--@brief	更新表情动画位置
--@note
function TeachMonster:updateFaceAnimation()
	if self.m_faceAnim then
		local heroPos = self:getAnimation():getPosition()

		local point = SceneTeachBattle:getFrontLayer():convertToWorldSpace(GlobalMethod:ccp(heroPos.x + 100,heroPos.y + 100))

		local size = self.m_faceAnim:getAnimNode():getContentSize()
		if point.x < size.width/2 then
			point.x = size.width/2
		end
		if point.x > 1136 - size.width/2 then
			point.x = 1136 - size.width/2
		end
		if point.y < size.height/2 then
			point.y = size.height/2
		end
		if point.y > 640 - size.height/2 then
			point.y = 640 - size.height/2
		end

		point = SceneTeachBattle:getInfoLayer():convertToNodeSpace(point)

		self.m_faceAnim:setPosition(GlobalMethod:ccp(point.x,point.y))
	end
end

--@brief	播放表情动画结束回调
--@param	sender:动画对象
--@note		原生回调只能回调全局函数，暂用
function _playFaceAnimationEnd_TeachMonster(sender)
	local hero = TeachBattle:getBoss()
	if hero and hero.m_faceAnim then
		hero.m_faceAnim:getAnimNode():removeFromParentAndCleanup(true)
		hero.m_faceAnim = nil
	end
end

--@brief 	获取BossId
function TeachMonster:getId()
	return self.m_nId
end

--@brief 	设置血量
--@param 	nHp 当前血量
function TeachMonster:setHp(nHp)
    WZLog("TeachMonster:setHp", nHp)
	self.m_nHP = nHp
    WndTeachBattleHud:updateBossHP()

    if self.m_nHP <= 0 then
        self:setDead(true)
    end

end

--@brief	根据hurtlist设置剩余hp
function TeachMonster:_setRemainHP()
    WZLog("TeachMonster:_setRemainHP", self:getHp())

	local remainHP = self:getHp()
	for i,value in pairs(self.m_tHurtValue) do
		remainHP = remainHP - value
	end
	if remainHP < 0 then
		remainHP = 0
	end

    self.m_nSkillHurt = 0

    self:setHp(remainHP)
end

--@brief	获取攻击力
--@param	nAttack:攻击力
function TeachMonster:setAttack(nAttack)
	self.m_nAttack = nAttack
end

--@brief	设置攻击次数
--@param	nAttTimes,攻击次数
function TeachMonster:setAttTimes(nAttTimes)
	self.m_nAttTimes = nAttTimes
end

--@brief 	播放准备射击动画
function TeachMonster:playReadyShootAnim()
    self:getAnimation():play("ranged_attack1",false)
end

--@brief 	播放正在射击动画
--@param	repeatTimes:重复次数(nil,0:不重复)
function TeachMonster:playRepeatShootAnim(RepeatTimes)
	RepeatTimes = RepeatTimes or 0
    self:getAnimation():playTimes("ranged_attack2",RepeatTimes)
end

--@brief 	播放射击完毕动画
function TeachMonster:playEndShootAnim()
    self:getAnimation():play("ranged_attack3",false)
end

-------------------------------------私有方法模块--------------------------------------
--@brief	移除死亡小怪
function TeachMonster:_removeDeadGuai()
	self:getAnimation():getAnimNode():removeFromParentAndCleanup(false)
	self:destroy()
end

--@brief	是否向左移动
function TeachMonster:_shouldMoveLeft(tPos)
	local player = self:getNearestPlayer()
	local playerPos = player:getAnimation():getPosition()
    if tPos ~= nil then
        playerPos = tPos
    end
	local guaiPos = self:getAnimation():getPosition()
	if guaiPos.x - playerPos.x >= 0 then
		return true
	end
    
	return false
end

--@brief	是否进行攻击
function TeachMonster:_shouldAttack()
	local player = self:getNearestPlayer()
	local playerPos = player:getAnimation():getPosition()
	local guaiPos = self:getAnimation():getPosition()
	if math.abs(guaiPos.x - playerPos.x) < self. m_nAttackArea then
        WZLog("TeachMonster:_shouldAttack = true")
		return true
	end
    
    WZLog("TeachMonster:_shouldAttack = false")
	return false
end

--@brief 添加小怪名称与血条
function TeachMonster:_addGuaiName()
    do return end
	if self.m_tGuaiName == nil then
		self.m_tGuaiName = BattleHeroName:create(self,SceneTeachBattle:getInfoLayer(),false)
    else
		self.m_tGuaiName:update()
	end
end

--@brief	添加受伤的数字
function TeachMonster:_addHurtValue()
    WZLog("WCharacter:_addHurtValue")
    --do return end
	local vPos = self:getAnimation():getPosition()
	for i,value in pairs(self.m_tHurtValue) do
		self.m_nFlyingNum = self.m_nFlyingNum + 1

		local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",self.m_nHurtType))
		element:setLuaObjectIndex(self)
		if element ~= nil then
			GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText(value)
			local conHurt = WZUIContainer:luaTo(element)
			local pos = {x=vPos.x + math.random(50) - 25,y=vPos.y + 12}
			conHurt:setAbsPosition(GlobalMethod:ccp(pos.x,pos.y))
			SceneTeachBattle:getFrontLayer():addChild(conHurt)
		end
	end
end