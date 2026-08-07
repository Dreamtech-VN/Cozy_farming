--WHero.lua
--@brief	角色数据表
--@date		2013/12/24
--@author	李俊鸿
--@note		角色相关属性及操作


--@brief	角色数据表
WHero = {
	m_bLoseNet = false, 				--玩家已经掉线
	m_nDt = 0, 							--时间保存，方便读取
	m_bIsInit = false, 					--是否已初始化

	--@brief 基本属性
	m_nRoomId = 0, 						--原来房间id
	m_nPlayerId = 0, 					--当前角色id
	m_nBattleId = 0, 					--对战id
	m_sPlayerName = "", 				--角色名称
	m_nLevel = 0, 						--角色等级
	m_nBoyOrGirl = 0, 					--男还是女  1:男，0:女
	m_nCamp = 0, 						--属于哪一方
	m_nCampPosition = 0,				--队伍排列
	m_nMaxHP = 0, 						--最大生命值
	m_nMaxPF = 0, 						--最大体力
	m_nMaxSP = 0, 						--最大怒气值
	m_nCtrlType = 0, 					--控制类型 0:自己 1:别人 2:AI
	m_sTitle = "", 						--称号
	m_sCommunity = "", 					--公会名称
	m_nZSLevel = 0,						--转生等级
	m_nSkillfull = 0,					--武器熟练度

	--@brief 武力属性
	m_nAttack = 0, 						--普通攻击力
	m_nBigSkillAttack = 0, 				--大招攻击力
	m_nCriticalhitAttackRate = 0, 		--爆击攻击倍率
	m_nDefence = 0, 					--防御力

	m_nWreckDefense = 0,				--破防值
	m_nInjuryFree = 0,					--免伤
	m_nReduceCrit = 0,					--免暴
	m_nReduceBury = 0,					--免坑
	m_nBigSkillType = 0, 				--大招类型

	m_fAttPercent = nil,				--攻击威力比例值,正常为100
	m_bCanFrozen = nil,					--是否带冰冻效果
	m_bCanFollow = nil,					--是否带追踪功能

	--@brief 基本动态属性
	m_nHP = 0, 							--生命值
	m_nSP = 0, 							--怒气值
	m_nPF = 0, 							--体力
	m_bIsDead = false, 					--死了吗
	m_bIsOutOfScene = false,			--是否在屏幕之外

	--@brief 宠物信息
	--[[{
		petId=nil,						--宠物ID(0:没有宠物)
		petProbability=nil, 			--宠物攻击概率
		petParam1=nil,      			--宠物参数1
		petParam2=nil,      			--宠物参数2
		petEffect=nil,					--宠物攻击特效名称
		petIcon=nil,					--宠物图标
		petType=nil,					--宠物类型
		petSkillId=nil,					--宠物技能ID
	}]]
	m_tPet = nil,						--宠物信息

	--@brief 状态控制
	m_nRunStatus = 0, 					--运行状态
	m_bIsMoved = false, 				--是否发生移动

	--@brief 道具技能状态相关
	m_bUseBigSkill = false, 			--是否使用大招
	m_nHideTurn = 0,					--隐藏回合
	m_nWaitFlyTime = 0,					--飞行禁用回合数
	m_bUseFly = false,					--是否使用了飞行（包括道具）
	m_bUseItemFly = false,				--是否使用了道具飞行
	m_bIsStopAnim = false,              --是否暂停所有人物动画（被冰冻）
	
	m_nReduceHurt = 1,					--减伤
	m_nFrozenId = nil,					--冰冻技能Id
	m_nReduceHurtCTB = 0,
	m_nUseSkillTime = 0,
	m_nUseItemTime = 0,
	
	m_bHurt = false,					
	

	--@brief 界面控制属性
	m_mover = nil, 						--移动控制对象
	m_anim = nil,					 	--动画控制对象
	m_shopAnim = nil, 					--商城形象
	m_wingElement = nil,				--翅膀
	m_headAnim = nil, 					--头像形象
	m_followAnim = nil,					--跟踪动画
	m_frozenAnim = nil,					--冰冻动画
	m_angerAnim = nil,					--怒气动画
	m_faceAnim = nil,					--表情动画
	m_firstBloodAnim = nil,				--首杀动画
	m_tPlayerNameInfoIcon = nil, 		--人物信息图标

	--@brief 子弹相关
	m_nWeaponType = nil,				--武器类型
	m_sWeaponName = nil,				--武器名字
	m_bulletCilcle = nil, 				--子弹碰撞、爆炸相关
	m_fRadiusForBulletCollision = nil,	--英雄与子弹碰撞半径
	m_fRadiusForHurt = nil,				--受伤半径
	m_tCollisionTable = nil,			--碰撞范围

	--@brief 机器人相关
	m_nAiCtrlId = 0,					--使用的AI策略
	m_bCanControl = false,				--是否可控制
	m_tSkills = nil,					--技能列表
	m_tItems = nil,						--道具列表
	m_tAI = nil,						--AI
    m_tAiScript = nil,                  -- ai策略

	--@brief 被动技能相关
	m_tWeaponSkillName=nil,				--被动技能名字
	m_tWeaponSkillType=nil,  			--被动技能类型
	m_tWeaponSkillChance=nil,			--被动技能触发概率
	m_tWeaponSkillParam1=nil,			--被动技能参数1
	m_tWeaponSkillParam2=nil,			--被动技能参数2
	m_tWeaponUpdate=nil,				--武器被动重置表([1]:回合数,[2]:回合重置值,[3]:改变的变量,[4]:变量重置值,[5]:受伤动画的名字)

	------------------------------------------------
	------------@brief 各种武器特效------------------
	------------------------------------------------
	m_sHurtAnimName = nil,				--受伤时显示的动画名字
	m_nWeaponHurt = nil,				--受伤害(毒素，冰冻，灼伤等)
	m_nWeaponHurtRound = nil,			--受伤害回合
	m_nWeaponTired = nil,				--体力上限降低
	m_nWeaponTiredRound = nil,			--体力上限降低回合
	m_nWeaponAttack = nil,				--攻击力降低
	m_nWeaponAttackRound = nil,			--攻击力降低回合
	m_nWeaponDefence = nil,				--防御力减低
	m_nWeaponDefenceRound = nil,		--防御力减低回合
	m_nWeaponSealRound = nil,			--封印回合(不能使用技能道具)
	m_nWeaponFlyLockRound = nil,		--飞行锁定回合
	m_nWeaponMoveLockRound = nil,		--移动锁定回合
	m_nWeaponFrozenRound = nil,			--被冰冻回合数
	m_nWeaponVertigoRound = nil,		--眩晕回合数

	m_nWeaponRepulseDis = nil,			--击退距离
	m_bWeaponAtomicBomb = nil,			--原子弹

	m_nAddAttackValue = 0,				--最终伤害增加值
	m_nAddCriticalHitProbability = 0,	--增加暴击率
	m_nRepulseDis = nil,				--是否被击退
	
	--加密检验字段
	m_nHP_Encrypt = nil,
	m_nSP_Encrypt = nil,
	m_nPF_Encrypt = nil,
	
	m_nAttack_Encrypt = nil,
	m_nBigSkillAttack_Encrypt = nil,
	m_nCriticalhitAttackRate_Encrypt = nil,
	m_nDefence_Encrypt = nil,
	
	m_fAttPercent_Encrypt = nil,
	m_nAttTimes_Encrypt = nil,
	m_nAttScatterNum_Encrypt = nil,
	
	m_nAddAttackValue_Encrypt = nil,
	m_fRadiusForBulletExplode_Encrypt = nil,
	m_nHideTurn_Encrypt = nil,
	m_nSkillfull_Encrypt = nil,
	
	m_nWreckDefense_Encrypt = nil,
	m_nInjuryFree_Encrypt = nil,
	m_nReduceCrit_Encrypt = nil,
	m_nReduceBury_Encrypt = nil,
    m_tPlayerBodyInfo = nil,

    m_nTreatAddition = 0 , --公会技能治疗加成
    m_nMoveRate = 100,  --公会技能兴奋剂
    m_nHPPre = 0,
    m_nHPNow = 0,
    m_nSoundForHurtTurn = -1,
    m_tBigSkillShootAnim = nil,
    m_bIsMonster = false,	--是否幻化
    m_nMonsterId = 0,		--幻化ID
    m_tPospre = nil,

}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个角色
--@param	tStrList:动画穿着描述表
--@param	nBoyOrGirl:男还是女，1:男，0:女
--@param	suit_info:装备信息
--@return	#1:角色数据表
function WHero:buildHero(tStrList, nBoyOrGirl, suit_info)
    WZLog("WHero:buildHero zero",suit_info.head,suit_info.face,suit_info.body)
	local hero = WHero:new()
	hero.m_nBoyOrGirl = nBoyOrGirl
    hero.m_tPlayerBodyInfo = tStrList
    hero.m_tSuitInfo = suit_info
	hero.m_bIsMonster = suit_info.monster and suit_info.monster < 0

	WZLog("WHero:buildHero zero", tostring(hero.m_bIsMonster), suit_info.monster)
	if hero.m_bIsMonster ~= true then
		hero.m_anim = YDPlayerAnimation:createAnimation(nBoyOrGirl == 0, false)
	    hero.m_anim:setGhost()
		hero.m_anim:getAnimNode():retain()
		hero.m_anim:setHead(GDatatab_item[suit_info.head].animation_index_code, suit_info.colour or 0)
		hero.m_anim:setFace(GDatatab_item[suit_info.face].animation_index_code)
		hero.m_anim:setBody(GDatatab_item[suit_info.body].animation_index_code)
		hero.m_anim:setBodyRanSe(suit_info.bodyColour or 0)
		if suit_info.wing ~= "" then 
			hero.m_anim:setWing(GDatatab_item[suit_info.wing].animation_index_code)
		end

	    WZLog("WHero:buildHero one", suit_info.colour, suit_info.bodyColour, suit_info.weapon, GDatatab_item[suit_info.weapon].animation_index_code)
		if GDatatab_item[suit_info.weapon].sub_type == 0 then 
			hero.m_anim:setWeaponBomb(GDatatab_item[suit_info.weapon].animation_index_code)
		else 
			hero.m_anim:setWeaponGun(GDatatab_item[suit_info.weapon].animation_index_code)
		end 
	else
		hero.m_nMonsterId = 0 - suit_info.monster
		hero.m_anim = YDPlayerAnimation:createAnimation(nBoyOrGirl == 0,false,true)
		hero.m_anim:setMonsterId(hero.m_nMonsterId)
		hero.m_anim:getAnimNode():retain()
	end

	local quality = 0
	quality = GDatatab_item[suit_info.head].quality > quality and GDatatab_item[suit_info.head].quality or quality
	quality = GDatatab_item[suit_info.face].quality > quality and GDatatab_item[suit_info.face].quality or quality
	quality = GDatatab_item[suit_info.body].quality > quality and GDatatab_item[suit_info.head].quality or quality
	hero.m_nQuality = 5 - quality
    --hero.m_anim:setWeaponGun(weapon.animation_index_code)
	
	if tStrList["wing"] == nil then
		tStrList["effects"] = "fly1"
	end
	--hero.m_anim:addAnimation("fly",tStrList, 0.1, false)
	tStrList["effects"] = nil

	local tShopList = CopyTable(tStrList)

	--商城形象
	if hero.m_bIsMonster ~= true then
	    hero.m_shopAnim = YDPlayerAnimation:createAnimation(nBoyOrGirl == 0, false)

		hero.m_shopAnim:getAnimNode():retain()
		hero.m_shopAnim:setHead(GDatatab_item[suit_info.head].animation_index_code, suit_info.colour or 0)
		hero.m_shopAnim:setFace(GDatatab_item[suit_info.face].animation_index_code)
		hero.m_shopAnim:setBody(GDatatab_item[suit_info.body].animation_index_code)
		hero.m_shopAnim:setBodyRanSe(suit_info.bodyColour or 0)
		if suit_info.wing ~= "" then 
			hero.m_shopAnim:setWing(GDatatab_item[suit_info.wing].animation_index_code)
		end 
		if GDatatab_item[suit_info.weapon].sub_type == 0 then 
			hero.m_shopAnim:setWeaponBomb(GDatatab_item[suit_info.weapon].animation_index_code)
		else 
			hero.m_shopAnim:setWeaponGun(GDatatab_item[suit_info.weapon].animation_index_code)
		end

	else
		hero.m_shopAnim = YDPlayerAnimation:createAnimation(nBoyOrGirl == 0,false,true)
		hero.m_shopAnim:setMonsterId(hero.m_nMonsterId)
		hero.m_shopAnim:getAnimNode():retain()
	end

	--头像形象
	local tHeadA = {}
	tHeadA.bhead = tStrList.bhead
	tHeadA.bface = tStrList.bface
	--[[
	if hero.m_nBoyOrGirl == 0 then
		hero.m_headAnim = YDPlayerHeadAnimation:createAnimation(true)
	else
		hero.m_headAnim = YDPlayerHeadAnimation:createAnimation(false)
	end
    hero.m_headAnim:getAnimNode():setTouchEnable(false)
	hero.m_headAnim:getAnimNode():retain()
	
	hero.m_headAnim:setHead(GDatatab_item[suit_info.head].animation_index_code)
	hero.m_headAnim:setFace(GDatatab_item[suit_info.face].animation_index_code)
	
	hero.m_headAnim:play("avatar",false)
	--]]
	--hero.m_headAnim = CellHead:show(nil,GDatatab_item[suit_info.head].id,GDatatab_item[suit_info.face].id,hero.m_nBoyOrGirl,nil,GlobalMethod:ccp(0.5, 0.3))
	--hero.m_headAnim:setScale(0.8)

    local anim
    if hero.m_nBoyOrGirl == 0 then
        anim = YDPlayerHeadAnimation:createAnimation(true)
    else
        anim = YDPlayerHeadAnimation:createAnimation(false)
    end
    anim:getAnimNode():setTouchEnable(false)
    anim:getAnimNode():retain()
	
	anim:setHead(GDatatab_item[suit_info.head].animation_index_code, suit_info.colour or 0)
	anim:setFace(GDatatab_item[suit_info.face].animation_index_code)
	
    anim:play("avatar",false)

    hero.m_headAnim2 = anim


	hero.m_mover = WDMoveEntity:create(hero.m_anim:getAnimNode())
    --hero.m_mover:setAdjustChild(true)
	hero.m_mover:retain()

	local center = Vector2:create(0,20)
	hero.m_mover:setMoverCenter(center)
	hero.m_mover:setMoverRadius(10)

	--子弹
    hero.m_nWeaponId = suit_info.weapon
	hero.m_nWeaponType = GDatatab_item[suit_info.weapon].sub_type
	hero.m_sWeaponName = GDatatab_item[suit_info.weapon].animation_index_code

	local sExplode = tStrList.weapon
	if hero.m_bIsMonster then
		-- local weaponTable = {}
		-- StringIntsertToTable(weaponTable,GDatatab_shape_skins["id_" .. hero.m_nMonsterId].explode)
		-- sExplode = weaponTable.weapon

		hero.m_nWeaponType = GDatatab_shape_skins["id_" .. hero.m_nMonsterId].attack_type
		hero.m_sWeaponName = GDatatab_shape_skins["id_" .. hero.m_nMonsterId].bullet
	end
    local img = WeaponExplodeTexture[sExplode] or string.format("%sb",string.sub(sExplode,0,sExplode:len()-1))

	sExplode = RESOURCE_BULLET_EXPLODE..img..".png"
	hero.m_bulletCilcle = BattleUtil:getCircleImg(sExplode)
	hero.m_bulletCilcle:retain()

    --碰撞半径
    local radius = 32
    if suit_info.bMonsterMode then 
    	radius = 60
    end
    hero.m_fRadiusForBulletCollision = radius
    hero.m_fRadiusForHurt = radius

    WZLog("WHero:buildHero two", hero.m_fRadiusForBulletCollision, hero.m_fRadiusForHurt, tStrList.weapon, sExplode, hero.m_sWeaponName)
    if ProjConfig.DEBUG == 1 then
        hero:addCircleCollision(hero.m_fRadiusForBulletCollision,radius/2)
        hero.m_bIsShowRang = true
    end
	--初始化子弹相关
	self:setHideTurn(0)
	hero:updateByTurn()

	--初始化被动技能
	hero.m_tWeaponSkillName = {}
	hero.m_tWeaponSkillType = {}
	hero.m_tWeaponSkillChance = {}
	hero.m_tWeaponSkillParam1 = {}
	hero.m_tWeaponSkillParam2 = {}
    
    if WBattleGlobal:getCurrent():isSingleStage() then
        hero.m_nDebuffFrozenRound = 0
    end
    
    hero.m_anim:setScale(BattleConstants.g_heroScale)
    if suit_info.bMonsterMode then 
    	hero.m_anim:setScale(BattleConstants.g_heroScale * 2)
    end

    hero.m_tActiveSkillList = {}

    local bombInfo = GDatatab_skill.id_1001.boom_scope[1]
    hero.m_fRectForBulletExplodeBomb = {x=bombInfo[1],y=bombInfo[2]}
    hero.m_fRadiusForBulletExplode = GDatatab_skill.id_1001.scope

    self.m_tAiScript = -1 --AiConfig["id_".."1001"] and AiConfig["id_".."1001"].peizhi or -1

	hero.m_bIsStopAnim = false

	hero:setSound()

	--足迹
	hero.m_tOldFootPos = nil
	hero.m_nFootId = suit_info.footId

	hero.m_nDt = 0
	return hero
end

--@brief	添加出场动画
function WHero:addAppearAnimation()
	--self.m_nQuality = 2
	if self.m_bIsGuaiWithSuit == true or self:isDead() == true then
		return
	end

    WZLog("WHero:addAppearAnimation", self.m_appearAnim == nil, "wait" .. self.m_nQuality)
    if self.m_appearAnim == nil then
		self.m_appearAnim = BattleAnimation:createAnimation("scene_appear",false)
		local size = self.m_anim:getAnimNode():getContentSize()
        self.m_appearAnim:getAnimNode():setUseAbsCoordinate(true)
        self.m_appearAnim:setScale(1)
        self.m_appearAnim:getAnimNode():setAbsPosition(GlobalMethod:ccp(90,0))
        
        self.m_anim:getAnimNode():addChild(self.m_appearAnim:getAnimNode(),4)
	end
	self.m_appearAnim:getAnimNode():setAnimationName("wait" .. self.m_nQuality)
    self.m_appearAnim:getAnimNode():setLoop(false)

	self.m_appearAnim:getAnimNode():setOpacity(self:getAnimation():getAnimNode():getOpacity())

    if self:isHide() == true then
        if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(self:getId()) then
            self.m_appearAnim:getAnimNode():setOpacity(128)
        else
            self.m_appearAnim:getAnimNode():setOpacity(0)
        end
    end
end

--@brief	移除出场动画
function WHero:removeAppearAnimation()
    WZLog("WHero:removeAppearAnimation", tostring(self.m_appearAnim))
	if self.m_appearAnim ~= nil then
		self.m_appearAnim:getAnimNode():removeFromParentAndCleanup(true)
		self.m_appearAnim = nil
	end
end

GDatatab_weapon_sound_test = 
{
    id_1 = { id = 1,weaponId = {{1,18}}, shootName = "sheji_fashe", explodeName = "sheji_baopo"},

}

function WHero:setSound()
    local weaponId = GDatatab_item[self.m_nWeaponId].icon
    local weaponId2 = string.find(weaponId, '.png')
    local weaponId3 = string.sub(weaponId, weaponId2-3, weaponId2-1)
    local weaponIndex = tonumber(weaponId3)

    if self.m_bIsMonster then
    	weaponIndex = 0 - tonumber(self.m_nMonsterId)
    end
    WZLog("WHero:setSound zero", tostring(self.m_bIsMonster), "weaponId", weaponId, "weaponId2", weaponId2, "weaponId3", weaponId3, weaponIndex)

    -- if GDatatab_weapon_sound == nil then
    --     GDatatab_weapon_sound = GDatatab_weapon_sound_test
    -- end

    local isAssign =  false
    local shootName = nil
    local explodeName = nil
    if GDatatab_weapon_sound then
        for i,v in pairs(GDatatab_weapon_sound) do
            for j,u in pairs (v.weaponId[1]) do
                if weaponIndex == u then
                    shootName = v.shootName .. ".mp3"
                    explodeName = v.explodeName .. ".mp3"
                    isAssign = true
                    break
                end
            end
            if isAssign then
                break
            end
        end

        
    end

    WZLog("WHero:setSound one", tostring(isAssign), shootName, explodeName)

    self:setShootSoundName(shootName)
    self:setExplodeSoundName(explodeName)

end

--@brief	获得是否超暴击
--@return	#1:true,false
function WHero:getCanSuperHit()
	return self.m_nSkillfull == 10000
end

function WHero:getBigSkillType()
    local typeBigSkill = 0
    if self.m_nBigSkillType >= BattleHeroUse.BIG_SKILL_TYPE_I_ID_START and self.m_nBigSkillType < BattleHeroUse.BIG_SKILL_TYPE_II_ID_START then
        typeBigSkill = 1
    elseif self.m_nBigSkillType >= BattleHeroUse.BIG_SKILL_TYPE_III_ID_START and self.m_nBigSkillType < BattleHeroUse.BIG_SKILL_TYPE_IV_ID_START then
        typeBigSkill = 2
    else
        typeBigSkill = 0
    end

    -- WZLog("WHero:getBigSkillType", self.m_nBigSkillType, typeBigSkill)
    return typeBigSkill
end

--@brief 足迹刷新
function WHero:updateFootEffect()
    if  self.m_nHideOpecity and self.m_nHideOpecity == 0 then
    	return
    end
    if self.m_nFootId and self.m_nFootId > 0 then
    	if not self.m_tOldFootPos then
        	self.m_tOldFootPos = self:getPosition()
    	end
        local pos = self:getPosition()
        local distance = GDatatab_footmark["id_" .. self.m_nFootId] and GDatatab_footmark["id_" .. self.m_nFootId].distance or 40
        if  BattleCommon:pointDis(self.m_tOldFootPos,pos) > distance then
            self.m_tOldFootPos = pos
            FootEffectManager:getInstance():addEffect(self.m_nFootId,pos,20,self.m_anim:getAnimNode():getScaleX(),self.m_anim:getAnimNode():getScaleY())
        end
    end
end


--@brief	定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function WHero:update(dt)
	WCharacter.update(self,dt)
	--足迹刷新
	self:updateFootEffect()

	self:randomFaceAction(dt)

    if self.m_bIsSetBigGun == nil then
        self.m_bIsSetBigGun = true
        --[[
        WZLog("WHero:update zero", self.m_nBigSkillType, self:getBigSkillType())
        if self:getBigSkillType() == 2 then
            self:getAnimation():setWeaponBigSkill(3)
        elseif self:getBigSkillType() == 0 then
            self:getAnimation():setWeaponBigSkill(2)
        else
            self:getAnimation():setGunBigSkill()
        end
        --]]
        WZLog("WCharacter:playReadyShootAnim zero")
    end

	--碰撞和受伤范围
	if false then
		local charaPos = self:getCenterPos()
		if self.m_tCollisionTable == nil then
			self.m_tCollisionTable = {}
    		self.m_tCollisionTable[1] = BattleAnimation:addCircle(BattleCommon:getPointTable(0,0) ,self.m_fRadiusForBulletCollision, {r = 1,g = 1,b = 1,a = 1},SceneBattle:getFrontLayer())

    		self.m_tCollisionTable[2] = BattleAnimation:addCircle(BattleCommon:getPointTable(0,0) ,self.m_fRadiusForHurt, {r = 1,g = 0,b = 0,a = 1},SceneBattle:getFrontLayer())
		end

		self.m_tCollisionTable[1]:setPosition(charaPos.x, charaPos.y)
		self.m_tCollisionTable[2]:setPosition(charaPos.x, charaPos.y)
	end
    if not self:isDead() then
	    local isOutOfScene,_ = self:checkIsOutOfScene()
    	if isOutOfScene then
    		local isSend = WBattleGlobal:getCurrent():inSendOutSceneRecord(self:getBattleId())
    		if self:isOutOfScene()==false or isSend == false then
                local currentPlayer = WBattleGlobal:getCurrent():getCharacterWithId(WBattleGlobal:getCurrent().m_nStartRoundPlayerId) or WBattleGlobal:getCurrent():getCurrentCharacter()
                local isRobot = true --self:isRobot() or (WBattleGlobal:getCurrent():isHostControl() and self.m_bLoseNet)
    			WZLog("WHero:update outofscene one", tostring(self:isRobot()), tostring(WBattleGlobal:getCurrent():isHostControl()), tostring(self.m_bLoseNet))
    		--	if self:getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() or isRobot then
    			if isRobot then
    				if not self:isDead() and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_FLY then
                    --    if self:getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() or isRobot then
                        if isRobot then
                        	WZLog("WHero:update outofscene two")
                        	ProtocolProcessorBattleInterface:send_BATTLE_OutOfScene(WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self:getBattleId() ,WBattleGlobal:getCurrent():getCurrentCharacterId(), self:getType(), WBattleGlobal:getCurrent():getCurrentCharacter():getType() )
                        	if self:getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() then 
                        		WBattleGlobal:getCurrent():addSendOutSceneRecord(self:getBattleId())
                        	end
                        end

    					if SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_SHOOT then
                        --    if self:getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() or isRobot then
                            if isRobot then
                                local curRoundAction = WBattleGlobal:getCurrent().m_tCurRoundAction
                                if currentPlayer == self and (curRoundAction == nil or curRoundAction.round ~= WBattleGlobal:getCurrent().m_nTurnTimes or curRoundAction.round ~= WBattleGlobal:getCurrent().m_nStartRoundTimes) then
                                    WZLog("WHero:update outofscene three", currentPlayer:getBattleId(), tostring(WBattleGlobal:getCurrent().m_nStartRoundPlayerId))
                                    WndBattleHud:setPassTurnBtnEnable(false)
                                    WndBattleHud:endTurn()
                                end
                            end
    					end
                        if self:isDead() ~= true then
                            self:setDead(true, 16)
                        end
    				end
    			end
    		end
    	end
    	self.m_bIsOutOfScene = isOutOfScene
    end
	
	if self.m_tPlayerNameInfoIcon ~= nil then
		--self.m_tPlayerNameInfoIcon:updateHp()
	end
    
	self:updateFaceAnimation()
	self:updateTalkPos()
	local pet = self:getPet()
	if pet ~= nil then
		pet:update()
	end
	
	--self:updateFrozenAnimation()
	
    if self:getNormalAnimationName() ~= nil and self:getAnimation() ~= nil and self.m_bIsReadyShoot == nil then
        if self.m_bIsDead ~= true and self:getAnimation():isPlaying(self:getNormalAnimationName()) == false then
            if self:getAnimation():isCurrentAnimationDone() == true then
                --WZLog("WHero:update three", self.m_nHP)
                self:getAnimation():play(self:getNormalAnimationName(), true)
            end
        end
        --WZLog("WHero:update two_1", tostring(self.m_bIsDead), tostring(self:getAnimation():isPlaying(self:getActionName(15))), self:getAnimation():isCurrentAnimationDone())
        if self.m_bIsDead == true and self:getAnimation():isPlaying(self:getActionName(15)) == true and self:getAnimation():isCurrentAnimationDone() == true then
            self:getAnimation():play(self:getActionName(16), true)
            --WZLog("WHero:update two_2")
        end
    end

    if self.m_tBigSkillShootAnim then
        if self.m_tBigSkillShootAnim:isPlaying("p1") == true and self.m_tBigSkillShootAnim:isCurrentAnimationDone() == true then
            WZLog("WHero:update one")
            self.m_tBigSkillShootAnim:play("loop", true)
        end
    end

	self:setRunStatus(RunStatus.DEF_ST_NORMAL)
	self.m_bIsMoved = false

	--调整玩家身上的动画位置
	self:adjustAnimPos()
    
    if self:getAI() ~= nil and self:getType() == 1 and self.m_bIsGuaiWithSuit == true  then
        self:getAI():run(dt)
    end

    local x, y = self:getPosition().x, self:getPosition().y
    if self.m_bIsAppear == nil then
    	if self.m_tPospre and self.m_tPospre.x == x and self.m_tPospre.y == y then
	    	self.m_bIsAppear = true
	    	self:addAppearAnimation()
	    	WBattleGlobal:getCurrent():cleanMyFog(self, nil, nil, nil, true)
	    end
	    self.m_tPospre = {x=x, y=y}
    end
    WBattleGlobal:getCurrent():cleanMyFog(self)
end

--@brief	销毁一个角色
function WHero:destroy()
    WZLog("WHero:destroy")
	WCharacter.destroy(self)

	if WBattleGlobal:getCurrent().m_battleManager ~= nil then
		WBattleGlobal:getCurrent().m_battleManager:removeEntity(self:getMover())
	end
	self.m_mover:release()
	self.m_mover = nil

	if self.m_wingElement ~= nil then
		if self.m_wingElement:getParent() ~= nil then
			self.m_wingElement:removeFromParentAndCleanup(true)
		end
		self.m_wingElement:release()
		self.m_wingElement = nil
	end

	self.m_bulletCilcle:release()
	self.m_bulletCilcle = nil

	if self.m_tPlayerNameInfoIcon ~= nil then
		self.m_tPlayerNameInfoIcon:destroy()
		self.m_tPlayerNameInfoIcon = nil
	end

	--碰撞范围
    if self.m_tCollisionTable ~= nil then
    	for i,collisionTable in pairs(self.m_tCollisionTable) do
    		collisionTable:removeFromParentAndCleanup(true)
    	end
    	self.m_tCollisionTable = nil
    end
    
    if self:getPet() then
    	self:getPet():destroy()
    end

    self:removeAppearAnimation()

    if self.m_anim then
        self.m_anim:getAnimNode():release()
        self.m_anim = nil
    end
    
    if self.m_shopAnim then
        self.m_shopAnim:getAnimNode():release()
        self.m_shopAnim = nil
    end
    
    if self.m_headAnim then
        self.m_headAnim:getAnimNode():release()
        self.m_headAnim = nil
    end
    
    if self.m_headAnim2 then
        self.m_headAnim2:getAnimNode():release()
        self.m_headAnim2 = nil
    end
    
    self.m_nHP_Encrypt = nil
	self.m_nSP_Encrypt = nil
	self.m_nPF_Encrypt = nil
	
	self.m_nAttack_Encrypt = nil
	self.m_nBigSkillAttack_Encrypt = nil
	self.m_nCriticalhitAttackRate_Encrypt = nil
	self.m_nDefence_Encrypt = nil
	
	self.m_fAttPercent_Encrypt = nil
	self.m_nAttTimes_Encrypt = nil
	self.m_nAttScatterNum_Encrypt = nil
	
	self.m_nAddAttackValue_Encrypt = nil
	self.m_fRadiusForBulletExplode_Encrypt = nil
	self.m_nHideTurn_Encrypt = nil
	self.m_nSkillfull_Encrypt = nil
	
	self.m_nWreckDefense_Encrypt = nil
	self.m_nInjuryFree_Encrypt = nil
	self.m_nReduceCrit_Encrypt = nil
	self.m_nReduceBury_Encrypt = nil
    
    if self:getAI() ~= nil then
        self:getAI():destroy()
    end
end

--@brief	标记显示受伤
--@param	nHurtValue:受伤的值
--@param	tShootHero:攻击的英雄
--@note		tShootHero:主要用于重写此接口的函数的扩展
function WHero:markHurt(nHurtValue,tShootHero,isSkillHurt,isPetHurt,isBuffHurt,hurtRatio)



    local hurt = 0
    if self.m_tHurtValue then
        for i, v in pairs (self.m_tHurtValue) do
            if type(v) == "number" then
                hurt = hurt + v
            end
        end
    end
    WZLog("WHero:markHurt one", WBattleGlobal:getCurrent().m_nTurnTimes, self.m_nSoundForHurtTurn, hurt, nHurtValue, self:getHp())

    if self:getId() == WBattleGlobal:getCurrent():getMyHero():getId() and nHurtValue >0 and self:getHp() - (nHurtValue + hurt) > 0 and WBattleGlobal:getCurrent().m_nTurnTimes ~= self.m_nSoundForHurtTurn and WBattleGlobal:getCurrent():isMyTurn() ~= true then
        WZLog("WHero:markHurt two")
		if self.m_bHurt == false and math.random(1,12) >=10 then
			if self.m_nBoyOrGirl == 0 then
				SoundManager:playEffectSound(getSoundByType(11))
			else
				SoundManager:playEffectSound(getSoundByType(6))
			end
        elseif self.m_bHurt == false and math.random(1,12) >= 8 then
            if self.m_nBoyOrGirl == 0 then
                SoundManager:playEffectSound(getSoundByType(11))
            else
                SoundManager:playEffectSound(getSoundByType(6))
            end
        elseif self.m_bHurt == false and math.random(1,12) >= 4 then
            if self.m_nBoyOrGirl == 0 then
                SoundManager:playEffectSound(getSoundByType(11))
            else
                SoundManager:playEffectSound(getSoundByType(6))
            end
		end
        self.m_nSoundForHurtTurn = WBattleGlobal:getCurrent().m_nTurnTimes
		self.m_bHurt = true
	end
	WCharacter.markHurt(self,nHurtValue,tShootHero,isSkillHurt,isPetHurt,isBuffHurt,hurtRatio)
end

--@brief	调整动画位置
function WHero:adjustAnimPos()

	--[[local anchor = self:getAnimation():getAnimNode():getAnchorPoint()
	local size = self:getAnimation():getAnimNode():getContentSize()
	local heroCenter = CCPointMake(anchor.x*size.width,anchor.y*size.height)
	local ccArray = self:getAnimation():getAnimNode():getChildren()
	if ccArray and ccArray:count() > 0 then
		for i=0,ccArray:count()-1 do
			tolua.cast(ccArray:objectAtIndex(i),"CCNode"):setPosition(heroCenter.x,heroCenter.y)
		end
	end]]
end

--@brief	设置击退
--@param	repulse:击退距离(正右负左)
--[[
function WHero:setRepulse(repulse)
	self.m_nRepulseDis = repulse
end
]]
--@brief	获取大招攻击力
--@return	#1:大招攻击力
function WHero:getBigSkillAttack()
	return self.m_nBigSkillAttack
end

--@brief	获取爆击攻击倍数
--@return	#1:爆击攻击倍数
function WHero:getCriticalhitAttackRate()
	return self.m_nCriticalhitAttackRate
end

--@brief	获取破防值
--@return	#1:破防值
function WHero:getWreckDefense()
	return self.m_nWreckDefense
end

--@brief	获取免伤
--@return	#1:免伤
function WHero:getInjuryFree()
	return self.m_nInjuryFree
end

--@brief	获取免暴
--@return	#1:免暴
function WHero:getReduceCrit()
	return self.m_nReduceCrit
end

--@brief	获取免坑
--@return	#1:免坑
function WHero:getReduceBury()
	return self.m_nReduceBury
end

--@brief	获取英雄id
--@return	#1:武器类型
function WHero:getId()
	return self.m_nPlayerId
end

--@brief	使用武器技能
--@param	nRandNum:随记数字
function WHero:useWeaponSkill(nRandIndex)
    WZLog("WHero:useWeaponSkill one", WBattleGlobal:getCurrent().m_nBattleType, BattleConstants.g_nBATTLE_TYPE_BOSS, WBattleGlobal:getCurrent().battleMode,  WBattleGlobal:getCurrent().battleMode ~= BattleConstants.g_tBossBattleMode.MODE_SINGLE_STAGE)
    if (WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS and WBattleGlobal:getCurrent().battleMode ~= BattleConstants.g_tBossBattleMode.MODE_SINGLE_STAGE) then
        return
    end

    local nRandNum
	local tWhichOne = {}
	for i,chance in pairs(self.m_tWeaponSkillChance) do
        if self.m_tWeaponSkillType[i] ~= 17 and self.m_tWeaponSkillType[i] ~= 18 and self.m_tWeaponSkillType[i] ~= 19 then

            if nRandIndex == nil then
                nRandNum = WBattleGlobal:getCurrent():getCurRandNum(i)

            else
                nRandNum = WBattleGlobal:getCurrent():getCurRandNum(i)
            end

            table.insert(WBattleGlobal:getCurrent().m_tAttackRandomList, {[1]=self:getBattleId(), [2]=self.m_tWeaponSkillType[i], [3]=WBattleGlobal:getCurrent().m_nRandNumIndex})

            WZLog("WHero:useWeaponSkill", i,chance, nRandNum, WBattleGlobal:getCurrent().m_nRandNumIndex)
            if nRandNum < chance then
                table.insert(tWhichOne,self.m_tWeaponSkillType[i])
            end
        end
	end
	
	WBattleGlobal:getCurrent():checkIsCheat(self.m_nAttack,self.m_nAttack_Encrypt,7)
	WBattleGlobal:getCurrent():checkIsCheat(self.m_nAttTimes,self.m_nAttTimes_Encrypt,8)
	WBattleGlobal:getCurrent():checkIsCheat(self.m_nAddAttackValue,self.m_nAddAttackValue_Encrypt,9)
	WBattleGlobal:getCurrent():checkIsCheat(self.m_fRadiusForBulletExplode,self.m_fRadiusForBulletExplode_Encrypt,10)

    if nRandIndex ~= nil then
        return
    end

	if #tWhichOne > 0 then
		local i = tWhichOne[1]

        ---[[
        for j,v in pairs(self.m_tWeaponSkillType) do
            if v ~= 17 and v ~= 18 and v ~= 19 and i == v then
                i = j
                break
            end
        end
        --]]
		if self.m_tWeaponUpdate == nil then
			self.m_tWeaponUpdate = {}
		end
		self.m_sHurtAnimName=nil
		--攻击 1
		if self.m_tWeaponSkillType[i] == 1 then
            WZLog("WHero:useWeaponSkill two", self.m_nAttack, (1+self.m_tWeaponSkillParam1[i]/10000))
			table.insert(self.m_tWeaponUpdate,{"m_nAttack",self.m_nAttack})
			--self.m_nAttack = self.m_nAttack * (1+self.m_tWeaponSkillParam1[i]/10000)
            self:setAttPercent(self:getAttPercent() * (1+self.m_tWeaponSkillParam1[i]/10000))
		--伤害 2
		elseif self.m_tWeaponSkillType[i] == 2 then
			table.insert(self.m_tWeaponUpdate,{"m_nAddAttackValue",0})
			self.m_nAddAttackValue=self.m_tWeaponSkillParam1[i]
		--暴击 3
		elseif self.m_tWeaponSkillType[i] == 3 then
			table.insert(self.m_tWeaponUpdate,{"m_nAddCriticalHitProbability",0})
			self.m_nAddCriticalHitProbability = self.m_tWeaponSkillParam1[i]
		--灼伤 4
		elseif self.m_tWeaponSkillType[i] == 4 then
			table.insert(self.m_tWeaponUpdate,{"m_nWeaponHurtRound",nil,"m_nWeaponHurt",nil})
			self.m_nWeaponHurt=self.m_tWeaponSkillParam1[i]
			self.m_nWeaponHurtRound=self.m_tWeaponSkillParam2[i]
			self.m_sHurtAnimName="butn"
		--疲劳 5
		elseif self.m_tWeaponSkillType[i] == 5 then
			table.insert(self.m_tWeaponUpdate,{"m_nWeaponTiredRound",nil,"m_nWeaponTired",nil})
			self.m_nWeaponTired=self.m_tWeaponSkillParam1[i]
			self.m_nWeaponTiredRound=self.m_tWeaponSkillParam2[i]
			self.m_sHurtAnimName="fatigue"
		--重力 6
		elseif self.m_tWeaponSkillType[i] == 6 then
			table.insert(self.m_tWeaponUpdate,{"m_nWeaponFlyLockRound",nil})
			self.m_nWeaponFlyLockRound=self.m_tWeaponSkillParam1[i]
			self.m_sHurtAnimName="gravity"
		--吸血 7
		elseif self.m_tWeaponSkillType[i] == 7 then
			table.insert(self.m_tWeaponUpdate,{"m_nBloodsuckingRate",0})
			self.m_nBloodsuckingRate=self.m_tWeaponSkillParam1[i]
		--封印 8
		elseif self.m_tWeaponSkillType[i] == 8 then
			table.insert(self.m_tWeaponUpdate,{"m_nWeaponSealRound",nil})
			self.m_nWeaponSealRound=self.m_tWeaponSkillParam1[i]
			self.m_sHurtAnimName="seal"
		--连击 9
		elseif self.m_tWeaponSkillType[i] == 9 then
			--table.insert(self.m_tWeaponUpdate,{"m_nAttTimes",self.m_nAttTimes,"m_nAttack",self.m_nAttack})
            WZLog("WHero:useWeaponSkill three", self.m_nAttTimes, self.m_tWeaponSkillParam2[i])
			self.m_nAttTimes = self.m_nAttTimes + self.m_tWeaponSkillParam2[i]
			--self.m_nAttack = self.m_nAttack * (self.m_tWeaponSkillParam2[i]/10000)
            self:setAttPercent(self:getAttPercent() * (self.m_tWeaponSkillParam1[i]/10000))
		--引导 10
		elseif self.m_tWeaponSkillType[i] == 10 then
			table.insert(self.m_tWeaponUpdate,{"m_bCanFollow",false,"m_nAttack",self.m_nAttack})
			self.m_bCanFollow = true
			--self.m_nAttack = self.m_nAttack * (self.m_tWeaponSkillParam1[i]/10000)
            self:setAttPercent(self:getAttPercent() * (self.m_tWeaponSkillParam1[i]/10000))
		--核弹 11
		elseif self.m_tWeaponSkillType[i] == 11 then
			table.insert(self.m_tWeaponUpdate,{"m_bWeaponAtomicBomb",nil,"m_nAttack",self.m_nAttack,"m_fRadiusForBulletExplode",self.m_fRadiusForBulletExplode})
			self.m_bWeaponAtomicBomb = true
			--self.m_nAttack = self.m_nAttack * (self.m_tWeaponSkillParam1[i]/10000)
			self.m_fRadiusForBulletExplode = 100
            self:setAttPercent(self:getAttPercent() * (self.m_tWeaponSkillParam1[i]/10000))
		--毒素 12
		elseif self.m_tWeaponSkillType[i] == 12 then
			table.insert(self.m_tWeaponUpdate,{"m_nWeaponHurtRound",nil,"m_nWeaponHurt",nil})
			self.m_nWeaponHurt=self.m_tWeaponSkillParam1[i]
			self.m_nWeaponHurtRound=self.m_tWeaponSkillParam2[i]
			self.m_sHurtAnimName="poison"
		--寒冰 13
		elseif self.m_tWeaponSkillType[i] == 13 then
			table.insert(self.m_tWeaponUpdate,{"m_nWeaponHurtRound",nil,"m_nWeaponHurt",nil})
			self.m_nWeaponHurt=self.m_tWeaponSkillParam1[i]
			self.m_nWeaponHurtRound=self.m_tWeaponSkillParam2[i]
			self.m_sHurtAnimName="ice"
		--锁足 14
		elseif self.m_tWeaponSkillType[i] == 14 then
			table.insert(self.m_tWeaponUpdate,{"m_nWeaponMoveLockRound",nil})
			self.m_nWeaponMoveLockRound = self.m_tWeaponSkillParam1[i]
			self.m_sHurtAnimName="tree"
		--眩晕 15
		elseif self.m_tWeaponSkillType[i] == 15 then
			table.insert(self.m_tWeaponUpdate,{"m_nWeaponVertigoRound",nil})
			self.m_nWeaponVertigoRound = self.m_tWeaponSkillParam1[i]
			self.m_sHurtAnimName="dizzy"
		--击退 16
		elseif self.m_tWeaponSkillType[i] == 16 then
			table.insert(self.m_tWeaponUpdate,{"m_nWeaponRepulseDis",nil})
			self.m_nWeaponRepulseDis = self.m_tWeaponSkillParam1[i]
		--免坑 17
		elseif self.m_tWeaponSkillType[i] == 17 then
			return
		--吸收 18
		elseif self.m_tWeaponSkillType[i] == 18 then
			return
		--免疫 19
		elseif self.m_tWeaponSkillType[i] == 19 then
			return
		end

		if nRandIndex == nil then
            BattleShowHeroUse:showUseName(self:getPosition(),self.m_tWeaponSkillName[i],self)
        end
	end
	
	self.m_nAttack_Encrypt = BattleCommon:intEncrypt(self.m_nAttack)
	self.m_nAttTimes_Encrypt = BattleCommon:intEncrypt(self.m_nAttTimes)
	self.m_nAddAttackValue_Encrypt = BattleCommon:intEncrypt(self.m_nAddAttackValue)
	self.m_fRadiusForBulletExplode_Encrypt = BattleCommon:intEncrypt(self.m_fRadiusForBulletExplode)
end

--@brief	武器被动更新
function WHero:updateWeaponSkill()

	if self.m_tWeaponUpdate ~= nil then
		
		WBattleGlobal:getCurrent():checkIsCheat(self.m_nAttack,self.m_nAttack_Encrypt,11)
		WBattleGlobal:getCurrent():checkIsCheat(self.m_nAttTimes,self.m_nAttTimes_Encrypt,12)
		WBattleGlobal:getCurrent():checkIsCheat(self.m_nAddAttackValue,self.m_nAddAttackValue_Encrypt,13)
		WBattleGlobal:getCurrent():checkIsCheat(self.m_fRadiusForBulletExplode,self.m_fRadiusForBulletExplode_Encrypt,14)
		
		for i,weaponSkill in pairs(self.m_tWeaponUpdate) do
			local j=1
			while true do
				if weaponSkill[j] == nil then
					break
				end
				if self[weaponSkill[j]] ~= weaponSkill[j+1] then
					self[weaponSkill[j]] = weaponSkill[j+1]
				end
				j = j + 2
			end
		end
		
		self.m_nAttack_Encrypt = BattleCommon:intEncrypt(self.m_nAttack)
		self.m_nAttTimes_Encrypt = BattleCommon:intEncrypt(self.m_nAttTimes)
		self.m_nAddAttackValue_Encrypt = BattleCommon:intEncrypt(self.m_nAddAttackValue)
		self.m_fRadiusForBulletExplode_Encrypt = BattleCommon:intEncrypt(self.m_fRadiusForBulletExplode)
		
	end
	self.m_tWeaponUpdate = nil
end

--@brief	获取武器类型
--@return	#1:武器类型
function WHero:getWeaponType()
	return self.m_nWeaponType
end

--@brief	获取武器名字
--@return	#1:武器名字
function WHero:getWeaponName()
	return self.m_sWeaponName
end

--@brief	设置转生等级
--@param	zsLevel:转生等级
function WHero:setZSLevel(zsLevel)
	self.m_nZSLevel = zsLevel
end

--@brief	获取转生等级
--@return	#1:转生等级
function WHero:getZSLevel()
	return self.m_nZSLevel
end

--@brief	获取子弹碰撞半径
--@return	#1:子弹碰撞半径
function WHero:getRadiusForBulletCollision()
	return self.m_fRadiusForBulletCollision
end

--@brief	获取受伤半径
--@return	#1:受伤半径
function WHero:getRadiusForHurt()
	return self.m_fRadiusForHurt
end

--@brief	设置AI
--@param	tAI:AI
function WHero:setAI(tAI)
	self.m_tAI = tAI
end

--@brief	获取AI
--@return	table:AI
function WHero:getAI()
	return self.m_tAI
end

--@brief    获取ai配置
--@return   ai配置
function WHero:getAiScript()
    return self.m_tAiScript
end


--@brief	生成AI控制组合
function WHero:buildAiCombination()
    do return end
	self.m_tSkills = {}
	self.m_tItems = {}

    --[[
    table.insert(self.m_tSkills, BattleHeroUse.SKILL_ATTACKUP_FOUR)
		table.insert(self.m_tSkills, BattleHeroUse.SKILL_ADDTIMES_TWO)
		table.insert(self.m_tSkills, BattleHeroUse.SKILL_DIVIDE_TWO)
		--table.insert(self.m_tItems, BattleHeroUse.ITEM_BLOOD)
		table.insert(self.m_tItems, BattleHeroUse.ITEM_FOLLOW)
		table.insert(self.m_tItems, BattleHeroUse.ITEM_ANGER)
    --]]

    --[[
	if self.m_nAiCtrlId == 1 then
		table.insert(self.m_tSkills, BattleHeroUse.SKILL_ATTACKUP_FOUR)
		table.insert(self.m_tSkills, BattleHeroUse.SKILL_ADDTIMES_TWO)
		table.insert(self.m_tSkills, BattleHeroUse.SKILL_DIVIDE_TWO)
		--table.insert(self.m_tItems, BattleHeroUse.ITEM_BLOOD)
		--table.insert(self.m_tItems, BattleHeroUse.ITEM_BLOODT)
		table.insert(self.m_tItems, BattleHeroUse.ITEM_FOLLOW)
	elseif self.m_nAiCtrlId == 2 then
		table.insert(self.m_tSkills, BattleHeroUse.SKILL_ATTACKUP_FIVE)
		table.insert(self.m_tSkills, BattleHeroUse.SKILL_ATTACKUP_FOUR)
		table.insert(self.m_tSkills, BattleHeroUse.SKILL_ATTACKUP_THREE)
		--table.insert(self.m_tItems, BattleHeroUse.ITEM_BLOOD)
		--table.insert(self.m_tItems, BattleHeroUse.ITEM_BLOOD)
		--table.insert(self.m_tItems, BattleHeroUse.ITEM_BLOOD)
	else
		table.insert(self.m_tSkills, BattleHeroUse.SKILL_ADDTIMES_ONE)
		table.insert(self.m_tSkills, BattleHeroUse.SKILL_ADDTIMES_TWO)
		table.insert(self.m_tSkills, BattleHeroUse.SKILL_DIVIDE_THREE)
		--table.insert(self.m_tItems, BattleHeroUse.ITEM_BLOOD)
		--table.insert(self.m_tItems, BattleHeroUse.ITEM_BLOOD)
		table.insert(self.m_tItems, BattleHeroUse.ITEM_ANGER)
	end
    --]]
end

--@brief 生成AI控制组合
function WHero:buildGuaidAiCombination(skills,items)
    WZLog("WHero:buildGuaidAiCombination")
    self.m_tSkills = {}
    self.m_tItems = {}
    for i,sv in pairs(skills) do
        if sv ~= -1 then
            table.insert(self.m_tSkills,sv)
        end
    end
    for k,iv in pairs(items) do
        if iv ~= -1 then
            table.insert(self.m_tItems,iv)
        end
    end
end

--@brief	设置宠物
--@param	tPet:Pet表
function WHero:setPet(tPet)
	self.m_tPet = tPet
end

--@brief	获取宠物
--@return	#1:宠物表
function WHero:getPet()
	return self.m_tPet
end

--@brief	获取子弹爆破
--@return	#1:子弹爆破
function WHero:getBulletCilcle()
	return self.m_bulletCilcle
end

--@brief	获取运行状态
--@return	运行状态
function WHero:getRunStatus()
	return self.m_nRunStatus
end

--@brief	设置运行状态
--@param	nRunStatus:运行状态
function WHero:setRunStatus(nRunStatus)
	self.m_nRunStatus = nRunStatus
end

--@brief	获取移动控制对象
--@return	#1:WDMove移动控制对象
function WHero:getMover()
	return self.m_mover
end

--@brief	移除子弹跟踪动画
function WHero:removeFollowAnimation()
	if self.m_followAnim ~= nil then
		self.m_followAnim:getAnimNode():removeFromParentAndCleanup(true)
		self.m_followAnim = nil
	end
end

--@brief	添加冰冻动画
function WHero:addFrozenAnimation()
	if self.m_frozenAnim == nil then
	end
end

--@brief	添加怒气动画
function WHero:addAngerAnimation()
    WZLog("WHero:addAngerAnimation")
    if self.m_bIsGuaiWithSuit ~= true and self.m_angerAnim == nil and self:isDead() ~= true then
		self.m_angerAnim = BattleAnimation:createAnimation("skill_nh_sd",false)
		local size = self.m_anim:getAnimNode():getContentSize()
		self.m_angerAnim:getAnimNode():setOpacity(self:getAnimation():getAnimNode():getOpacity())
        self.m_angerAnim:getAnimNode():setUseAbsCoordinate(true)
        self.m_angerAnim:setScale(1)
        self.m_angerAnim:getAnimNode():setAbsPosition(GlobalMethod:ccp(90,230))
        self.m_angerAnim:getAnimNode():setAnimationName("chixu")
        self.m_angerAnim:getAnimNode():setLoop(true)
        self.m_anim:getAnimNode():addChild(self.m_angerAnim:getAnimNode(),4)


        if self:isHide() == true then
            if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(self:getId()) then
                self.m_angerAnim:getAnimNode():setOpacity(128)
            else
                self.m_angerAnim:getAnimNode():setOpacity(0)
            end
        end
	end
end

--@brief	移除怒气动画
function WHero:removeAngerAnimation()
    WZLog("WHero:removeAngerAnimation", tostring(self.m_angerAnim))
	if self.m_angerAnim ~= nil then
		self.m_angerAnim:getAnimNode():removeFromParentAndCleanup(true)
		self.m_angerAnim = nil
	end
end

--@brief	播放表情动画
--@param	nFaceId:表情Id
function WHero:playFaceAnimation(nFaceId)
	if self.m_faceAnim then
		self.m_faceAnim:getAnimNode():removeFromParentAndCleanup(true)
		self.m_faceAnim = nil
	end

	self.m_faceAnim = BattleAnimation:createAnimation(WndBattleHud.FACE_INDEX[nFaceId],true)

	self:updateFaceAnimation()

	local node = self.m_faceAnim:getAnimNode()
	--because need to higher than the name layer and ttf layer 
	node:setZOrder(3)
	SceneBattle:getInfoLayer():addChild(node)

	self.m_faceAnim:play("0",true)
	node:setScale(0)
	node:setTag(self:getId())

	local act1=CCScaleTo:create(0.2,1)
    local act2=CCDelayTime:create(2.1)
	local act3=CCScaleTo:create(0.2,0.2)
	local act4=CCCallFuncN:create(_playFaceAnimationEnd_WHero)
	local array = CCArray:create()
	if self:isRobot() then
		array:addObject(CCDelayTime:create(2.1))
	end
	array:addObject(act1)
	array:addObject(act2)
	array:addObject(act3)
    array:addObject(act4)
	node:runAction(CCSequence:create(array))
end

--@brief	更新表情动画位置
--@note
function WHero:updateFaceAnimation()
	if self.m_faceAnim then
		local heroPos = self:getAnimation():getPosition()

		local point = SceneBattle:getFrontLayer():convertToWorldSpace(GlobalMethod:ccp(heroPos.x,heroPos.y + 80))

		local size = self.m_faceAnim:getAnimNode():getContentSize()
		if point.x < size.width/2 then
			point.x = size.width/2
		end
		if point.x > 960 - size.width/2 then
			point.x = 960 - size.width/2
		end
		--new UI
		if point.y < 0 then
			point.y = 0
		end
		if point.y > 640 - size.height then
			point.y = 640 - size.height
		end
		point = SceneBattle:getInfoLayer():convertToNodeSpace(point)

		self.m_faceAnim:setPosition(BattleCommon:getPointTable(point.x,point.y))
	end
end

--@brief	播放对话
function WHero:talk(text, bubbleId)
	if self:getAnimation() == nil or self:getAnimation():getAnimNode() == nil then
		return
	end

	if self.m_tTalkElement then
		self.m_tTalkElement:removeFromParentAndCleanup(true)
		self.m_tTalkElement = nil
		self.m_tTalkObj = nil
	end

	local dir = CellDialog.DIR_UP
	local posOffset = BattleCommon:getPointTable(0, 0)

	self.m_tTalkElement, self.m_tTalkObj = CellBattleDialog:addDialog(self:getAnimation():getAnimNode(), 
		SceneBattle:getInfoLayer(), text, dir, 10, nil, nil, posOffset.x, posOffset.y, 280, 1, nil, nil, 
		false, nil,100,nil,nil,nil,nil,nil,true,nil,bubbleId, self:getBattleId())

	local point = self:updateTalkPos()
	self.m_tTalkObj:updateTalkPos({x=self:getAnimation():getPosition().x,y=self:getAnimation():getPosition().y}, point)

	local node = self.m_tTalkElement
	--because need to higher than the name layer and ttf layer 
	node:setZOrder(3)
	--SceneBattle:getInfoLayer():addChild(node)

	local time = 3
	node:setScale(0.2)
	node:setTag(self:getBattleId())
	local act1=CCScaleTo:create(0.2,1)
    local act2=CCDelayTime:create(time)
	local act3=CCScaleTo:create(0.1,0.2)
	local act4=CCCallFuncN:create(_talkEnd_WHero)
	local array = CCArray:create()
	array:addObject(act1)
	array:addObject(act2)
	array:addObject(act3)
    array:addObject(act4)
	node:runAction(CCSequence:create(array))
end

--@brief	更新对话位置
function WHero:updateTalkPos()
	if self.m_tTalkElement then
		local heroPos = self:getAnimation():getPosition()

		local size = self.m_tTalkElement:getContentSize()

		local offset = {x=0, y=80}

		local point = SceneBattle:getFrontLayer():convertToWorldSpace(GlobalMethod:ccp(heroPos.x+offset.x,heroPos.y+offset.y))

		--WZLog("WHero:updateTalkPos",heroPos.x, heroPos.y, point.x, point.y, size.width, size.height)
		if point.x < size.width/2 + 20 then
			point.x = size.width/2 + 20
		end
		if point.x > 960 - (size.width/2) - 20 then
			point.x = 960 - (size.width/2) - 20
		end

		if point.y < 20 then
			point.y = 20
		end
		if point.y > 640 - size.height - 20 then
			point.y = 640 - size.height - 20
		end
		point = SceneBattle:getInfoLayer():convertToNodeSpace(point)

		self.m_tTalkElement:setPosition(point.x,point.y)

		return point
	end
end

--@brief	对话结束回调
function _talkEnd_WHero(sender)
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(sender:getTag())
	if hero and hero.m_tTalkElement then
		hero.m_tTalkElement:removeFromParentAndCleanup(true)
		hero.m_tTalkElement = nil
		hero.m_tTalkObj = nil
	end
end

--@brief	子弹攻击后的表情动画
--@param	isVaild:攻击是否有效
--@note
function WHero:showAttackFace(isVaild)
	-- do return end
	if not self:isRobot() or not WBattleGlobal:getCurrent():isArenaPWStage() then
		return
	end

    if self.m_bIsGuaiWithSuit == true or self:isHide() == true then
        return
    end
	if isVaild == nil then
		WZLog("isVaild is nil")
		return
	end
	--发送表情概率过滤 
	local random = math.random(1,100)
	if isVaild and random < 80 then
		return
	end
	if not isVaild and random < 85 then
		return
	end
	
	local faceId
	if isVaild then
		faceId = {24,22,21,16,8,13}
	else
		faceId = {3,4,11,10,9,1}
	end
    
	local idx
	if WBattleGlobal:getCurrent().m_tAttackRate then
		if type(WBattleGlobal:getCurrent().m_tAttackRate)=="table" then
			if WBattleGlobal:getCurrent().m_tAttackRate[1] then
				idx = 1 + WBattleGlobal:getCurrent().m_tAttackRate[1] % #faceId
			end
		end
	end
	if idx == nil then
		--math.randomseed(tostring(os.time()):reverse():sub(1, 6))
		--idx = math.random(1,#faceId)
        --随机数
    local nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes()
    local randNumIndex = nTurnTimes % 10 + 1
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand

    idx = randNumList[randNumIndex] % #faceId + 1
	end

	self:playFaceAnimation(faceId[idx])
end

function WHero:randomFaceAction(dt)
	if not self:isRobot() or not WBattleGlobal:getCurrent():isArenaPWStage() then
		return
	end
	if not self.m_nAiMaxTime then
		self.m_nAiMaxTime = self.m_nBattleId % 30 + 10
		self.m_nAiFaceRate = self.m_nBattleId % 10 + 4
	end
	if self.m_nDt > self.m_nAiMaxTime then
		self.m_nDt = 0
		if math.random(1,100) < self.m_nAiFaceRate then
			faceId = {5,6,8,13,2,4,9,17}
	      --随机数
		    local nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes()
		    local randNumIndex =  (self.m_nAiFaceRate + nTurnTimes) % 10 + 1
		    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand

		    local idx = randNumList[randNumIndex] % #faceId + 1

		    self:playFaceAnimation(faceId[idx])
		end
	else
		self.m_nDt = self.m_nDt + dt
	end
	
end


--@brief	播放表情动画结束回调
--@param	sender:动画对象
--@note		原生回调只能回调全局函数，暂用
function _playFaceAnimationEnd_WHero(sender)
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(sender:getTag())
	if hero and hero.m_faceAnim then
		hero.m_faceAnim:getAnimNode():removeFromParentAndCleanup(true)
		hero.m_faceAnim = nil
	end
end

--@brief	播放首杀动画
--@param
function WHero:playFirstBloodAnim()
    do return end
	self:removeFirstBloodAnim()

	local heroPos = self:getAnimation():getPosition()
	local anim = BattleAnimation:createAnimation(IWCO_FIRST)
	local animName = "first"

	anim:addAnimation(animName,{}, 0.1, true)
	anim:playTimes(animName,1)

	local point = SceneBattle:getFrontLayer():convertToWorldSpace(GlobalMethod:ccp(heroPos.x,heroPos.y + 130))
	point = SceneBattle:getInfoLayer():convertToNodeSpace(point)
	anim:setPosition(BattleCommon:getPointTable(point.x,point.y))
	SceneBattle:getInfoLayer():addChild(anim:getAnimNode())

	self.m_firstBloodAnim = anim
end

--@brief	判断首杀动画是否播完
--@return	bool,是否播放完
function WHero:isFirstBloodDone()
	if self.m_firstBloodAnim then
		return self.m_firstBloodAnim:isCurrentAnimationDone()
	end
	return true
end

--@brief	获取是否带追踪功能
--@return	#1:true:是，false:否
function WHero:getCanFollow()
    if self.m_bIsGuaiWithSuit then
        return false
    end
    return self.m_bCanFollow or (self.m_nLevel <= 7 and WBattleGlobal:getCurrent().m_tMakePairOk.mapId ~= 10104)
end

--@brief	移除首杀动画
function WHero:removeFirstBloodAnim()
	if self.m_firstBloodAnim then
		self.m_firstBloodAnim:getAnimNode():removeFromParentAndCleanup(true)
		self.m_firstBloodAnim = nil
	end
end

--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function WHero:getAnimation()
	return self.m_anim
end

--@brief	获取头像控制对象
--@return	#1:Animation动画控制对象
function WHero:getHeadAnimation(isNew)
    if isNew == true then
        return self.m_headAnim2
    else
        return self.m_headAnim
    end
end

--@brief 首杀头像
function WHero:getKillHeadAnimation()
    local anim
    if self.m_nBoyOrGirl == 0 then
        anim = YDPlayerHeadAnimation:createAnimation(true)
    else
        anim = YDPlayerHeadAnimation:createAnimation(false)
    end
    anim:getAnimNode():setTouchEnable(false)

    local suit_info = self.m_tSuitInfo
    anim:setHead(GDatatab_item[suit_info.head].animation_index_code, suit_info.colour or 0)
    anim:setFace(GDatatab_item[suit_info.face].animation_index_code)

    anim:play("avatar",false)
    return anim
end

--@brief	获取商城动画控制对象
--@return	#1:Animation动画控制对象
function WHero:getShopAnimation()
	return self.m_shopAnim:getAnimNode()
end
--@brief	获取对象
--@return	#1:对象性别，#1:对象信息
function WHero:getHeroInfo()
    return self.m_nBoyOrGirl,self.m_tPlayerBodyInfo
end
--@brief	获取胜利动画控制对象
--@return	#1:Animation动画控制对象
function WHero:getWinAnimation()
	self.m_shopAnim:playTimes("room",0)
	if self.m_wingElement ~= nil then
		if CCArmatureDataManager:sharedArmatureDataManager():getTextureData("wing1") == nil then
	  		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("armatures/wing.png","armatures/wing.plist","armatures/wing.xml")
            CCArmatureDataManager:sharedArmatureDataManager():addSpriteFrameFromFile("armatures/wing.plist", "armatures/wing.png")
		end
		self.m_wingElement:setVisible(true)
        local shopAnim = self.m_shopAnim:getAnimNode():getContentSize()
        local _nWidth = 77
        local _nHeight = -30

        self.m_wingElement:setUseAbsCoordinate(true)
        if self.m_nBoyOrGirl == 0 then
            _nWidth = 53
        else
            if self.m_tPlayerBodyInfo.bhead == "bhead99" then
                _nWidth = 103
            else
                _nWidth = 73
            end
        end
        self.m_wingElement:setAbsPosition(GlobalMethod:ccp(_nWidth, _nHeight))
        self.m_wingElement:setFlipX(self:getAnimation():getAnimNode():isFlipX())

	end
	return self.m_shopAnim:getAnimNode()
end
--@brief	设置翅膀方向
--@return	
function WHero:setwingFlipX(bFlip)
	if self.m_wingElement ~= nil then
		self.m_wingElement:setFlipX(bFlip)
    else
        return
	end
end

--@brief	获取失败动画控制对象
--@return	#1:Animation动画控制对象
function WHero:getLoseAnimation()
	--self.m_wingElement:setAbsPosition(GlobalMethod:ccp(0,0))
	self.m_shopAnim:playTimes("lose",0)
	if self.m_wingElement ~= nil then
		self.m_wingElement:setVisible(false)
	end
	return self.m_shopAnim:getAnimNode()
end

--@brief	移动角色
--@param	nSpeedX:X速度
--@param	nSpeedY:Y速度
--@param	nAccX:X加速度
--@param	nAccY:Y加速度
--@return	#1:移动过程中是否与地图发生碰撞
function WHero:move(tSpeed, tAcceleration)
	--WZLog("WHero:move")
	--设置初始速度及加速度
	if tSpeed ~= nil then
		--WZLog("WHero:move speed", tSpeed.x,tSpeed.y)
		self.m_mover:setMoverSpeed(Vector2:create(tSpeed.x,tSpeed.y))
	end
	if tAcceleration ~= nil then
		--WZLog("WHero:move acceleration", tAcceleration.x,tAcceleration.y)
		self.m_mover:setMoverAcceleration(Vector2:create(tAcceleration.x,tAcceleration.y))
	end

	--WZLog("WHero:move updatePostion", self.m_mover:getMoverAcceleration().x, self.m_mover:getMoverAcceleration().y)
	--更新角色位置
	self.m_mover:updatePostion()

	--判断碰撞并校正角色位置
	local isCollision,newPos,tangent = BattleMapManager:checkCollision(self.m_mover)
	if isCollision == true then
		self.m_mover:setMoverPosition(newPos)
		self.m_mover:setMoverRotate(BattleCommon:pointToAngle(tangent))
		self.m_mover:setMoverSpeed(Vector2:create(0,0))
	end

	--将位置信息同步到角色动画
	local posX,posY = self.m_anim:getAnimNode():getPosition()
	if BattleCommon:pointDis(self.m_mover:getMoverPosition(),{x = posX,y = posY}) > 1 then
		local vec2 = self.m_mover:getMoverPosition()
		self:setPosition(vec2)
		self.m_anim:getAnimNode():setRotation(BattleCommon:radiansToDegress(self.m_mover:getMoverRotate()))
	end

	self.m_bIsMoved = true
	return isCollision
end

--@brief	是否死亡
function WHero:isDead()
	return self.m_bIsDead
end

--@brief	设置是否死亡
function WHero:setDead(bDead, note)
    WZLog("WHero:setDead one", tostring(bDead), tostring(note))
    
    if self.m_bIsDead == bDead then
        return
    end

    if bDead and WBattleGlobal:getCurrent():getMyHero() == self then
        WndBattleHud:setMyHudShow(false)
        WndBattleHud:setMyHudSwitchEnable(false)
    end

	self.m_bIsDead = bDead
	
	BattleCtbManager:setDead(self:getBattleId(),bDead)


	if bDead then

        self.m_nDeadRound = WBattleGlobal:getCurrent().m_nTurnTimes

        self.m_bIsStopAnim = false
        if self:getAnimation().m_bIsStopFaceAndWindAnim then
            self:getAnimation():resume()
        end

		self:setHp(0)
        ---[[
        if self:getAnimation():isPlaying(self:getActionName(15)) == false then
			self:getAnimation():play(self:getActionName(15),false)
		end
		self:removeAngerAnimation()
		--幽灵模式
        if WBattleGlobal:getCurrent():isGhostStage() then
			--幽灵模式添加天使光圈
			self:addAngelAura()
			self:setGhostAnchorPoint()
        	--隐藏血量
        	if self:getPlayerNameIcon() then 
        		self:getPlayerNameIcon():setHpVisible(false)
        	end
        	if WndBattleHud.m_nGhostTargetId then 
        		--如果当前选中的角色已死，则重新随机一个活着的角色
        		if WndBattleHud.m_nGhostTargetId == self:getId() then 
        			self:setTargetMark(false)
        			WndBattleHud.m_nGhostTargetId = nil 
        			WndBattleHud:chooseOnePlayer()
        		end
        	else
				if self.m_nPlayerId == WBattleGlobal:getCurrent():getMyBattleId() then
					WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setVisible(false)
					WndBattleHud:_showGhostSkill()
					WndBattleHud:setGhostBoxOpacity()
					WndBattleHud:chooseOnePlayer()
				end
			end
		end
        --self:setSp(0)
        --]]

		if self:getPet() then
			self:getPet():getAnimation():getAnimNode():setVisible(false)
		end
	        if self.m_nDebuffFrozenRound ~= nil then
	            self.m_nDebuffFrozenRound = nil
	        end
		WCharacter.clearAllBuff(self)
		self:getMover():setUpdatable(true)
        
	        if self.m_bIsGuaiWithSuit ~= nil and self.m_bIsGuaiWithSuit == true then
	            --WBattleGlobal:getCurrent().m_tGuais[self:getBattleId()] = nil
	        end
	        if WBattleGlobal:getCurrent().m_battleManager ~= nil then
	            WBattleGlobal:getCurrent().m_battleManager:removeEntity(self:getMover())
	        end

	        if WBattleGlobal:getCurrent():isSingleStage() then
	            local memberList = WBattleGlobal:getCurrent().m_tSingleActivityMemberList
	            for id, hero in pairs (memberList) do
	                if self:getBattleId() == hero:getBattleId() then
	                    WBattleGlobal:getCurrent().m_nDeadHeroId = self:getBattleId()
	                    table.remove(memberList, id)
	                    break
	                end
	            end
	        end

        if  WBattleGlobal:getCurrent().m_nTurnTimes ~= self.m_nSoundForHurtTurn then
            self.m_nSoundForHurtTurn = WBattleGlobal:getCurrent().m_nTurnTimes
            if WBattleGlobal:getCurrent():isSameTeam(self.m_nBattleId,WBattleGlobal:getCurrent():getCurrentCharacter().m_nBattleId) == true and self.m_nBattleId ~= WBattleGlobal:getCurrent():getCurrentCharacter().m_nBattleId then
                if WBattleGlobal:getCurrent():getCurrentCharacter().m_nBoyOrGirl == 0 then
                    SoundManager:playEffectSound(getSoundByType(16))
                else
                    SoundManager:playEffectSound(getSoundByType(15))
                end
            else
                if self.m_nBoyOrGirl == 0 then
                    SoundManager:playEffectSound(getSoundByType(14))
                else
                    SoundManager:playEffectSound(getSoundByType(9))
                end
            end
        end
        self:addDeadAnimation()
	else
        self.m_nRevivalTime = WBattleGlobal:getCurrent().m_nTurnTimes
        --移除添加的光环
        self:addAngelAura(true)
        self:setGhostAnchorPoint(true)
        --显示隐藏的血量
        if self:getPlayerNameIcon() then 
        	self:getPlayerNameIcon():setHpVisible(true)
        end
        self:removeDeadAnimation()
        self:setHp(self:getMaxHp(), true)
		self.m_bIsDeadHurt = nil
		self:getAnimation():play(self:getActionName(23),true)
        WZLog("WHero:setDead two", self:getSp())
        self:setSp(self:getSp())
		if self:getPet() then
			self:getPet():getAnimation():getAnimNode():setVisible(true)
		end
        if WBattleGlobal:getCurrent().m_battleManager ~= nil then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(self:getMover())
        end
		self:getMover():setUpdatable(true)

		WBattleGlobal:getCurrent():removeSendOutSceneRecord(self:getBattleId())
	end
end

--@brief	判断是否超出屏幕
function WHero:isOutOfScene()
	return self.m_bIsOutOfScene
end

--@brief	检测是否超出屏幕
--@return	#1:是否超出屏幕
--@return	#2:是否纵向超出屏幕
function WHero:checkIsOutOfScene()
    if self:getMover() == nil then
        return false, false
    end
	if SceneBattle:getFrontLayer() then
		local sceneSize = SceneBattle:getFrontLayerSize()
        local a = self:getMover():getMoverPosition()
        a = {x = a.x,y = a.y}
        
        --纵向超出屏幕
		if a.y < -100 then
            WZLog("WHero:checkIsOutOfScene one", self:getBattleId(), a.y)
			return true, true
            --横向超出屏幕
        elseif a.x < -100 or a.x > sceneSize.width + 100 then
            WZLog("WHero:checkIsOutOfScene two", a.x)
            return true, false
		end
	end
	return false, false
end

--@brief 	设置人物等级
--@param 	level:等级
function WHero:setLevel(level)
	self.m_nLevel = level
end

--@brief 	获得人物等级
--@return 	#1, 返回人物当前等级
function WHero:getLevel()
	return self.m_nLevel
end

--@brief 	设置人物名称
--@param 	name:人物名称
function WHero:setPlayerName(name)
	self.m_sPlayerName = name
end

--@brief 	获得人物名称
--@return 	#1, 返回人物名称
function WHero:getPlayerName()
	return self.m_sPlayerName
end

--@brief 	设置英雄属于那一方
--@param 	camp:那一方
function WHero:setCamp(camp)
	self.m_nCamp = camp
end

--@brief 	获得英雄属于那一方
--@return 	返回英雄属于那一方
function WHero:getCamp()
	return self.m_nCamp
end

--@brief 	设置英雄排列
--@param 	campPos:排列
function WHero:setCampPosition(campPos)
	self.m_nCampPosition = campPos
end

--@brief 	获得英雄排列
--@return 	#1:返回英雄排列
function WHero:getCampPosition()
	return self.m_nCampPosition
end

--@brief 	获得英雄当前的位置
--@return 	#1, 返回当前的位置
function WHero:getPosition()
	return self.m_anim:getPosition()
end

--@brief 	设置人物当前的位置
--@param 	tPos 当前位置
function WHero:setPosition(tPos)
    WZLog("WHero:setPosition",tPos,x,tPos.y)
	self.m_mover:setMoverPosition(Vector2:create(tPos.x,tPos.y))
	self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
	if self.m_tPlayerNameInfoIcon ~= nil then
		self.m_tPlayerNameInfoIcon:updatePosition()
	end
end

--@brief	返回当前用户的称号
--@return 	#1,当前用户的称号
function WHero:getTitle()
	return self.m_sTitle
end

--@brief 	设置人物名称信息的显示
--@param 	tIcon 人物名称信息的显示
function WHero:setPlayerNameIcon(tIcon)
	self.m_tPlayerNameInfoIcon = tIcon
    if false and self.m_tPlayerNameInfoIcon ~= nil then

        local node = TrackNode:create(self.m_tPlayerNameInfoIcon:getNameNode())
        node:setPreAdd(Vector2:create(0,-40))
        self.m_mover:addTrackNode(node)

    end
    WZLog("self.m_mover:addTrackNode(node)")
end

--@brief 	获得人物名称信息的显示
--@retrun 	#1, 人物名称信息的显示
function WHero:getPlayerNameIcon()
	return self.m_tPlayerNameInfoIcon
end

--@brief 	获得人物最大血量
--@return 	#1,人物最大血量
function WHero:getMaxHp()
	return self.m_nMaxHP
end

--@brief 	获得人物当前血量
--@return 	#1,人物当前血量
function WHero:getHp()
	return self.m_nHP
end

--@brief 	获得人物最大体力
--@return 	#1,人物最大体力
function WHero:getMaxPF()
	return self.m_nMaxPF
end

--@brief 	获得人物当前体力
--@return 	#1,人物当前体力
function WHero:getPF()
	return self.m_nPF
end

--@brief 	获得怒气
--@return 	当前怒气
function WHero:getSp()
	return self.m_nSP
end

--@brief 	设置血量
--@param 	nHp 当前血量
function WHero:setHp(nHp, isReborn)
    nHp = tonumber(nHp)
    if self.m_nHP == nHp then
        return
    end
    WZLog("WHero:setHp one",self:getId(), self.m_nHP, nHp, tostring(isReborn))
    if self:getPlayerNameIcon() and isReborn == nil then
        self:getPlayerNameIcon().m_bIsHpActionDone = false
    end
    
    self.m_nHPPre = self.m_nHP
	self.m_nHP = nHp
	self.m_nHP_Encrypt = BattleCommon:intEncrypt(self.m_nHP)
	self.m_nMarkHp = self.m_nHP

	if self:getPlayerNameIcon() and isReborn then
    	self:getPlayerNameIcon().m_bisReborn = true
        WZLog("WHero:setHp two")
    end

	if self.m_tPlayerNameInfoIcon ~= nil then
		--self.m_tPlayerNameInfoIcon:updateHp()
	end
	
    if self.m_bIsGuaiWithSuit ~= nil and self.m_bIsGuaiWithSuit == true then
        WndBattleHud:updatePlayerHP(self:getBattleId())
    else
        WndBattleHud:updatePlayerHP(self:getBattleId())
    end

    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP,self)
end

--@brief	根据hurtlist设置剩余hp
function WHero:_setRemainHP()
    local remainHP = self:getHp()

    local oldHp = remainHP
    --for i,value in pairs(self.m_tHurtValue) do
    for i = 1, #self.m_tHurtValue do
        value = self.m_tHurtValue[i]
        remainHP = remainHP - value
    end

    remainHP = remainHP > self:getMaxHp() and self:getMaxHp() or remainHP
    WZLog("WHero:_setRemainHP two", oldHp, remainHP, tostring(self.m_tHurtValue.isPetHurt))

    -- if true and self.m_tHurtValue.isPetHurt == nil and self.m_tHurtValue.isBuffHurt == nil and self:getIsFrozen() then
    --     for id,buff in pairs (self.m_tBuffChangeStateList) do
    --         if buff.m_nType == BuffType.FROZEN --[[and buff.m_nAddInCTBTime ~= BattleCtbManager.m_nTotalCTB_time]] then

    --             --判断是否是当前攻击导致冰冻的
    --             local isCurAttackToFrozen = false
    --             if WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList then
    --                 for i, info in pairs (WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList) do
    --                 	if 
    --                     if info.round == WBattleGlobal:getCurrent().m_nTurnTimes and info.playerId == self:getBattleId() and info.buffId == buff.m_nID and info.userId == WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId() then
    --                         if info.actionTimes == WBattleGlobal:getCurrent():getCurrentCharacter().m_nActionTimes then
    --                             isCurAttackToFrozen = true
    --                         end
    --                     end
    --                 end
    --             end

    --             WZLog("WHero:_setRemainHP removeAnime",tostring(isCurAttackToFrozen))

    --             if isCurAttackToFrozen == false then
    --                 buff:removeAnime()
    --                 self.m_tBuffChangeStateList[id] = nil
    --             end
    --         end
    --     end
    -- end

    if self.m_tHurtValue.isPetHurt then
        self.m_tHurtValue.isPetHurt = nil
    end

    if oldHp <= 0 then
        return
    end

    if remainHP <= 0 then
        if WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId() == self:getBattleId() and (not self.m_tHurtValue.isBuffHurt) then
            remainHP = 1
        else
            remainHP = 0
        end
    end

    self:setHp(remainHP)
    if remainHP <= 0 and self:isDead() ~= true and WBattleGlobal:getCurrent():isSingleStage() then
        self:setDead(true,6)
    end

    if remainHP <= 0 and self:isDead() ~= true then
        local currentPlayer = WBattleGlobal:getCurrent():getCharacterWithId(WBattleGlobal:getCurrent().m_nStartRoundPlayerId) or WBattleGlobal:getCurrent():getCurrentCharacter()
        WZLog("WCharacter:_setRemainHP three-1", self:getBattleId(), tostring(WBattleGlobal:getCurrent().m_nStartRoundPlayerId), tostring(currentPlayer and currentPlayer:getBattleId()), tostring(WBattleGlobal:getCurrent().m_bIsStartBattle), tostring(self.m_tHurtValue.isBuffHurt))

        if currentPlayer and currentPlayer:getBattleId() == self:getBattleId() and WBattleGlobal:getCurrent().m_bIsStartBattle and self.m_tHurtValue.isBuffHurt then
            local curRoundAction = WBattleGlobal:getCurrent().m_tCurRoundAction
            WZLog("WCharacter:_setRemainHP three-2", self:getBattleId(), tostring(curRoundAction and curRoundAction.round))

            --[[
            if curRoundAction then
                if curRoundAction.round ~= WBattleGlobal:getCurrent().m_nStartRoundTimes then
                    WZLog("WCharacter:_setRemainHP four", self:getBattleId(), WndBattleHud.m_tMyHero:getBattleId())
                    if self:getBattleId() == WndBattleHud.m_tMyHero:getBattleId() then
                        WndBattleHud:setPassTurnBtnEnable(false)
                        WndBattleHud:endTurn()
                        WBattleGlobal:getCurrent():endCurRound(self:getBattleId(),18.0)
                    else
                    	WndBattleHud:setPassTurnBtnEnable(false)
                        WndBattleHud:endTurn()
                        WBattleGlobal:getCurrent():endCurRound(self:getBattleId(),18.1)
                    end
                end
            else
                WZLog("WCharacter:_setRemainHP five")
                if self:getBattleId() == WndBattleHud.m_tMyHero:getBattleId() then
                    WndBattleHud:setPassTurnBtnEnable(false)
                    WndBattleHud:endTurn()
                else
                    WBattleGlobal:getCurrent():endCurRound(self:getBattleId(),19)
                end
            end
            --]]
        end
    end
    if WBattleGlobal:getCurrent():isSingleStage() then
        if remainHP == 0 then
            local pos = self:getPosition()
            WBattleGlobal:getCurrent():killMonster(self:getId(),self:getBattleId(),BattleCommon:getPointTable(pos.x,pos.y))
            --self:setDead(true)
        end
    end
    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.CHARACTER_HURT,self,oldHp - remainHP)
    --WZLog("WCharacter:_setRemainHP three", remainHP)

end

--@brief 	设置怒气
--@param 	nSp 当前怒气
function WHero:setSp(nSp, isRemoveAni)
	nSp = nSp < 0 and 0 or nSp
	WBattleGlobal:getCurrent():checkIsCheat(self.m_nSP,self.m_nSP_Encrypt,16)
	self.m_nSP = nSp
	self.m_nSP_Encrypt = BattleCommon:intEncrypt(self.m_nSP)
	
	WndBattleHud:updatePlayerSp(self:getBattleId())
	if nSp >= 100 then
		self:addAngerAnimation()
	elseif isRemoveAni then
		self:removeAngerAnimation()
	end
end

--@brief 	设置体力
--@param 	nPF 当前体力
function WHero:setPF(nPF)
	WBattleGlobal:getCurrent():checkIsCheat(self.m_nPF,self.m_nPF_Encrypt,17)
	self.m_nPF = nPF < 0 and 0 or nPF
	self.m_nPF_Encrypt = BattleCommon:intEncrypt(self.m_nPF)

	WndBattleHud:updatePlayerPF(self:getBattleId())
end

--@brief 	设置英雄是否用大招
--@param 	bUseBigSkill 是否使用大招
function WHero:setUseBigSkill(bUseBigSkill)
	self.m_bUseBigSkill = bUseBigSkill
end

--@brief 	判断英雄是否用大招
--@return 	英雄是否使用大招
function WHero:getUseBigSkill()
	return self.m_bUseBigSkill ,self.m_nBigSkillNumber
end

--@brief	结束隐藏
function WHero:endHide()
	self:setHideTurn(0)
    self.m_nHideOpecity = nil
	if self:getType() == 1 and self.m_bIsGuaiWithSuit == true  then
        BattleHeroUse:endHide(self:getBattleId())
    else
        BattleHeroUse:endHide(self:getId())
    end
end

--@brief	改变隐藏回合
--@param 	nChangeTurnTime 增加或减少的隐藏回合数
function WHero:changeHideTurn(nChangeTurnTime)
	self:setHideTurn( math.max(self.m_nHideTurn + nChangeTurnTime,0) )
end

--@brief	重新设置隐藏回合
--@param 	nTurnTime 隐藏回合数
function WHero:setNewHideTurn(nTurnTime)
	self:setHideTurn( math.max(self.m_nHideTurn,nTurnTime) )
end

--@brief	设置隐藏回合
--@param 	nTurnTime 隐藏回合数
function WHero:setHideTurn(nTurnTime)
    WZLog("WHero:setHideTurn", nTurnTime, WBattleGlobal:getCurrent().m_tMakePairOk.battleId, self.m_nHideTurn, self.m_nHideTurn_Encrypt)
	WBattleGlobal:getCurrent():checkIsCheat(self.m_nHideTurn,self.m_nHideTurn_Encrypt,18)
	self.m_nHideTurn = nTurnTime
	self.m_nHideTurn_Encrypt = BattleCommon:intEncrypt(self.m_nHideTurn)
end

--@brief	经过一回合后的英雄状态和属性更新
function WHero:updateByTurn()
	WCharacter.updateByTurn(self)

	self:updateWeaponSkill()
    self.m_nAttTimes = 1
	
	self.m_nUseSkillTime = 0
	self.m_nUseItemTime = 0
	self.m_bHurt = false
	--[[
	--金币副本
	if WBattleGlobal:getCurrent():isCopperCopy() then 
        self.m_bUseFly = true
    end
    ]]
end

--@brief	设置攻击威力比例值
--@param	fAttPercent,攻击威力比例值
function WHero:setAttPercent(fAttPercent)
    WZLog("WHero:setAttPercent",self.m_fAttPercent,fAttPercent)
	WBattleGlobal:getCurrent():checkIsCheat(self.m_fAttPercent,self.m_fAttPercent_Encrypt,19)
	self.m_fAttPercent = fAttPercent
	self.m_fAttPercent_Encrypt = BattleCommon:intEncrypt(self.m_fAttPercent)
end

--@brief	获取攻击威力比例值
--@return	攻击威力比例值
function WHero:getAttPercent()
	return self.m_fAttPercent
end

--@brief	设置攻击次数
--@param	nAttTimes,攻击次数
function WHero:setAttTimes(nAttTimes,note)
    if nAttTimes ~= 1 then
        WZLog("WHero:setAttTimes", nAttTimes,tostring(note), self:getId())
    end
    WBattleGlobal:getCurrent():checkIsCheat(self.m_nAttTimes,self.m_nAttTimes_Encrypt,20)
	self.m_nAttTimes = nAttTimes
	self.m_nAttTimes_Encrypt = BattleCommon:intEncrypt(self.m_nAttTimes)
end

--@brief	设置散射子弹数
--@param	nAttScatterNum,散射子弹数
function WHero:setAttScatterNum(nAttScatterNum)
	WBattleGlobal:getCurrent():checkIsCheat(self.m_nAttScatterNum,self.m_nAttScatterNum_Encrypt,21)
	self.m_nAttScatterNum = nAttScatterNum
	self.m_nAttScatterNum_Encrypt = BattleCommon:intEncrypt(self.m_nAttScatterNum)
end

--@brief	设置是否带冰冻效果
--@param	bCanFrozen,是否带冰冻效果
function WHero:setCanFrozen(bCanFrozen)
	self.m_bCanFrozen = bCanFrozen
end

--@brief	获取是否带冰冻效果
--@return	#1:true:是，false:否
function WHero:getCanFrozen()
	return self.m_bCanFrozen
end

--@brief	添加子弹跟踪动画
function WHero:addFollowAnimation()
    if self.m_followAnim == nil then
        self.m_followAnim = BattleAnimation:createAnimation("skills_zzd_sd",true)
        self.m_anim:getAnimNode():addChild(self.m_followAnim:getAnimNode())
        self.m_followAnim:play("0",true)
        local size = self.m_anim:getAnimNode():getContentSize()
        self.m_followAnim:getAnimNode():setPositionX(size.width*0.7)
            self.m_followAnim:getAnimNode():setPositionY(size.height*0.0)

    end
end

--@brief	添加大招蓄力动画
function WHero:addBigSkillShootAnimation(type)
    WZLog("WHero:addBigSkillShootAnimation", type)

    if type == 1 then
        self.m_tBigSkillShootAnim = BattleAnimation:createAnimation("skill_power_shoulei", false)
        local size = self.m_anim:getAnimNode():getContentSize()

        self.m_anim:getAnimNode():addChild(self.m_tBigSkillShootAnim:getAnimNode(),100)

        self.m_tBigSkillShootAnim:play("p1", false)
        self.m_tBigSkillShootAnim:getAnimNode():setPosition(GlobalMethod:ccp(size.width - 70,size.height + 8))

    else
        self.m_tBigSkillShootAnim = BattleAnimation:createAnimation("skill_power_qiangpao", false)
        local size = self.m_anim:getAnimNode():getContentSize()

        self.m_anim:getAnimNode():addChild(self.m_tBigSkillShootAnim:getAnimNode(),100)

        self.m_tBigSkillShootAnim:play("p1", false)
        self.m_tBigSkillShootAnim:getAnimNode():setPosition(GlobalMethod:ccp(size.width + 10,size.height + 35))
    end

    if self:isHide() ~= true or WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(self:getBattleId()) then
        self.m_tBigSkillShootAnim:getAnimNode():setVisible(true)
    else
        self.m_tBigSkillShootAnim:getAnimNode():setVisible(false)
    end

end

--@brief 		播放准备射击动画
function WHero:playReadyShootAnim()
    WZLog("WCharacter:playReadyShootAnim one", self:getBattleId() , self.m_nWeaponType, self:getBigSkillType())
	if self:getUseBigSkill() then
		if self.m_nWeaponType == 0 --[[self:getBigSkillType() == 0 or self:getBigSkillType() == 2]] then
			self:getAnimation():play(self:getActionName(9),false)
            WZLog("WCharacter:playReadyShootAnim three-1")
            self:addBigSkillShootAnimation(1)
		else
			self:getAnimation():play(self:getActionName(11),false)
            WZLog("WCharacter:playReadyShootAnim three-2")
            self:addBigSkillShootAnimation(2)
		end


	else
		if self.m_nWeaponType == 0 then
			self:getAnimation():play(self:getActionName(6),false)
		else
			self:getAnimation():play(self:getActionName(4),false)
		end
	end
end

--@brief 	播放正在射击动画
--@param	repeatTimes:重复次数(nil,0:不重复)
function WHero:playRepeatShootAnim(RepeatTimes)
	repeatTimes = repeatTimes or 0
    WZLog("WHero:playRepeatShootAnim", repeatTimes, self:getUseBigSkill())
	if self:getUseBigSkill() then
		if self.m_nWeaponType == 0 --[[self:getBigSkillType() == 0 or self:getBigSkillType() == 2]] then
			self:getAnimation():play(self:getActionName(10),false)
		else
			self:getAnimation():play(self:getActionName(8),false)
		end

        if self.m_tBigSkillShootAnim then
            if self:isHide() ~= true or WBattleGlobal:getCurrent():isMyTeam(self:getId()) or WBattleGlobal:getCurrent():isReplayGame() then
                self.m_tBigSkillShootAnim:getAnimNode():setVisible(true)
            else
                self.m_tBigSkillShootAnim:getAnimNode():setVisible(false)
            end
            self.m_tBigSkillShootAnim:play("p2", false)
            WZLog("WHero:playRepeatShootAnim zero")
        end
	else
		if self.m_nWeaponType == 0 then
			self:getAnimation():play(self:getActionName(7),false)
		else
			self:getAnimation():play(self:getActionName(5),false)
		end
	end
end

function WHero:playBigSkillShootAnim()
	if self.m_nWeaponType == 0 --[[self:getBigSkillType() == 0 or self:getBigSkillType() == 2]]  then
		self:getAnimation():play(self:getActionName(10),false)
	else
		self:getAnimation():play(self:getActionName(8),false)
	end
end

--@brief 	播放射击完毕动画
function WHero:playEndShootAnim()
	if self.m_bIsDead then return end 
	WZLog("WHero:playEndShootAnim")
	if self:getUseBigSkill() then
		if self.m_nWeaponType == 0 then
			self:getAnimation():play(self:getActionName(3),false)
		else
			self:getAnimation():play(self:getActionName(1),false)
		end
	else
		if self.m_nWeaponType == 0 then
			self:getAnimation():play(self:getActionName(2),false)
		else
			self:getAnimation():play(self:getActionName(1),false)
		end
	end
end

--@brief	检测移动碰撞
function WHero:checkCollision()
	local vec2 = Vector2:create(self:getMover():getMoverAcceleration().x,self:getMover():getMoverAcceleration().y+BattleConstants.g_nGravity.y)
	self:getMover():setMoverAcceleration(vec2)
	local bIsCollision = self:move()
	self.m_mover:setMoverSpeed(Vector2:create(0,self.m_mover:getMoverSpeed().y))
	vec2 = Vector2:create(self:getMover():getMoverAcceleration().x,self:getMover():getMoverAcceleration().y-BattleConstants.g_nGravity.y)
	self:getMover():setMoverAcceleration(vec2)
	return bIsCollision
end

--@brief	检测飞行碰撞
function WHero:checkCollisionInFly()
	--WZLog("WHero:checkCollisionInFly", self:getMover():getMoverSpeed().x, self:getMover():getMoverSpeed().y)
	local vec2 = Vector2:create(self:getMover():getMoverAcceleration().x + WBattleGlobal:getCurrent():getWind().x,self:getMover():getMoverAcceleration().y+BattleConstants.g_nFlyGravity.y + WBattleGlobal:getCurrent():getWind().y)
	self:getMover():setMoverAcceleration(vec2)
	local bIsCollision = self:move()
	vec2 = Vector2:create(self:getMover():getMoverAcceleration().x - WBattleGlobal:getCurrent():getWind().x,self:getMover():getMoverAcceleration().y-BattleConstants.g_nFlyGravity.y - WBattleGlobal:getCurrent():getWind().y)
	self:getMover():setMoverAcceleration(vec2)
	--WZLog("WHero:checkCollisionInFly2", self:getMover():getMoverSpeed().x, self:getMover():getMoverSpeed().y)
	return bIsCollision
end

--@brief	设置是否使用飞行
--@param	bUseFly,是否使用飞行
function WHero:setUseFly(bUseFly)
	self.m_bUseFly = bUseFly
end

--@brief	判断是否使用飞行
--@return	是否使用飞行
function WHero:isUseFly()
	return self.m_bUseFly
end

--@brief	设置是否使用道具飞行
--@param	bUseItemFly,是否使用道具飞行
function WHero:setUseItemFly(bUseItemFly)
	self.m_bUseItemFly = bUseItemFly
end

--@brief	判断是否使用了飞行道具
--@return	是否使用了飞行道具
function WHero:isUseItemFly()
	return self.m_bUseItemFly
end

--@brief	
--@return	
function WHero:getReduceHurt()
	return self.m_nReduceHurt
end

--@brief	
--@return	
function WHero:setReduceHurt(nReduceHurt)
	self.m_nReduceHurt = nReduceHurt
end

function WHero:addUseSkillTime(nTime)
	self.m_nUseSkillTime = self.m_nUseSkillTime + nTime
	WndBattleHud:updateSkillItem(self:getBattleId())
end

function WHero:getUseSkillTime()
	if WBattleGlobal:getCurrent():isReplayGame() then
		return 0
	end
    WZLog("WHero:getUseSkillTime", tostring(TeachGroup1.ISBATTLE))
	return self.m_nUseSkillTime
end

function WHero:addUseItemTime(nTime)
	self.m_nUseItemTime = self.m_nUseItemTime + nTime
	WndBattleHud:updateSkillItem(self:getBattleId())
end

function WHero:getUseItemTime()
	if WBattleGlobal:getCurrent():isReplayGame() then
		return 0
	end
	return self.m_nUseItemTime
end
	
--@brief	设置飞行禁用回合数
--@param	nWaitTime,飞行禁用回合数
function WHero:setWaitFlyTime(nWaitTime)
	self.m_nWaitFlyTime = math.max(self.m_nWaitFlyTime,nWaitTime)
end

--@brief	判断是否允许使用飞行
--@return	是否允许使用飞行
function WHero:canUseFly()
	return self.m_nWaitFlyTime <=0
end

--@brief        创建小怪
--@param        guaiCount:小怪数量
--@param        guaiBattleId:小怪战斗id
--@param        guaiId:小怪数据库id
--@param        guaiPositionX:小怪x位置
--@param        guaiPositionY:小怪y位置
--@note         提供boss重载
function WHero:receiveBuildXiaoGuai(guaiBattleId, guaiId, guaiPositionX, guaiPositionY)
    self.guaiBattleId = guaiBattleId
    self.guaiId = guaiId
    self.guaiPositionX = guaiPositionX
    self.guaiPositionY = guaiPositionY
    WZLog("WHero:receiveBuildXiaoGuai one", Serialize(guaiBattleId), Serialize(guaiId), Serialize(guaiPositionX), Serialize(guaiPositionY))
end

--@brief	以本表为模版，WCharacter表为父表创建一个新的表实例对象
--@return	新建的表实例对象
function WHero:new()
	setmetatable(WHero,{__index = WCharacter})
	local tNewObj = {}
	setmetatable(tNewObj, {__index = WHero})
	tNewObj:setType(CharacterType.TYPE_HERO)
	tNewObj:_init()
	return tNewObj
end

--@brief 	死亡玩家添加天使光环
--@param 	bRemove : 是否移除光环
function WHero:addAngelAura(bRemove)
	-- body
	if bRemove then
		if self:getAnimation():getAnimNode():getChildByTag(1010) then 
			self:getAnimation():getAnimNode():removeChildByTag(1010, true)
		end
		return 
	end

	if self:getAnimation():getAnimNode():getChildByTag(1010) then 
		return 
	end 
	
	local imgAngelAura = WZUIImage:create()
	imgAngelAura:setUseOriginSize(true)
	imgAngelAura:setFile("ui/combat/combatboy_ghost_effect_00000.png")
	imgAngelAura:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
	if self.m_nBoyOrGirl == 1 then
		imgAngelAura:setRelativePosition(GlobalMethod:ccp(1.1, 1.5))
	else
		imgAngelAura:setRelativePosition(GlobalMethod:ccp(1, 1.4))
	end
	imgAngelAura:setTag(1010)
	self:getAnimation():getAnimNode():addChild(imgAngelAura)
end

--@brief 	设置幽魂锚点
function WHero:setGhostAnchorPoint(bCenter)
	-- body
	if not WBattleGlobal:getCurrent():isGhostStage() then return end 
	
	if bCenter then 
		self:getAnimation():getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
	else
		self:getAnimation():getAnimNode():setAnchorPoint(GlobalMethod:ccp(1.1, 0.5))
	end
end

--@brief 	怪兽模式，展示一句对话
function WHero:showAttWord(tPs)
	-- body
	local cellChatBubblenode,luaObject  = CellChatBubble:showChatBubble(SceneBattle:getFrontLayer(), tPs, true)
	cellChatBubblenode:setScale(1.2)

    luaObject:addMsgToList(LocalStrings.PVP_HALL_41, self.m_nPlayerId)
end

--@brief	获得随机的一个对方阵营玩家
function WHero:getRandomEnemyPlayer(curHero)
    WZLog("WHero:getRandomEnemyPlayer")
	--随机数
    local nTurnTimes = WBattleGlobal:getCurrent():getTurnTimes()
    local randNumIndex = nTurnTimes % 10 + 1
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
    
    --目标英雄
    local tHeroList = WBattleGlobal:getCurrent():getHeroSortList()
	local nPlayerCount = 0
    local tPlayerIds = {}
    for i ,v in ipairs(tHeroList) do
        if not v:isDead() and v:getHp() > 0 and WBattleGlobal:getCurrent():isSameTeam(v:getBattleId(), curHero:getBattleId()) ~= true then
            nPlayerCount = nPlayerCount + 1        
            tPlayerIds[nPlayerCount] = v.m_nPlayerId
        end
    end
    
    local targetHeroId = tPlayerIds[randNumList[randNumIndex] % #tPlayerIds + 1]
    self.m_tTargetPlayer = WBattleGlobal:getCurrent():getHeroWithId(targetHeroId)
    return self.m_tTargetPlayer
end
-------------------------------------私有方法模块--------------------------------------
