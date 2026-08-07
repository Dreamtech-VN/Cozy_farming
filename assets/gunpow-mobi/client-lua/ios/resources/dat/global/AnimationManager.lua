--AnimationManager.lua
--@brief	动画管理表对象
--@date  	2013/12/24
--@author 	xiaoyu_wu
--@note 	动画管理表对象

AnimationManager = {
	m_tIWcoList = {		--所有IWCO文件列表
		--IWCO_BATTLEBOY,
		--IWCO_BATTLEGIRL,
		-- IWCO_BATTLEEFFECT,
		-- IWCO_BATTLEFACE,
		-- IWCO_BATTLEEFFICIENTS,
		-- IWCO_SHOPEFFICIENTS,
		--IWCO_SHOPBOY,
		--IWCO_SHOPGIRL,
		--IWCO_ISLAND,
		--IWCO_TEACH,
		--IWCO_NEWTEACH,
		-- IWCO_EGG,
		-- IWCO_STRENGTHEN,
		--IWCO_WING,
		--IWCO_BAPTIZE,
        -- IWCO_BOSS,
        -- IWCO_MONSTER1,
        -- IWCO_MONSTER2,
        -- IWCO_BOSS21,
        -- IWCO_BOSS22,
        -- IWCO_BOSS31,
        -- IWCO_BOSS32,
        -- IWCO_BOSS4,
        --IWCO_BOSS4_TORNADO,
        -- IWCO_MONSTER3,
        -- IWCO_MONSTEREFFICIENTS,
        -- IWCO_BOSS5,
        -- IWCO_MONSTER5,
        -- IWCO_BOSS6,
        --[[IWCO_PET1,
        IWCO_PET2,
        IWCO_PET3,
        IWCO_PET4,
        IWCO_PET5,
        IWCO_PET6,
        IWCO_PET7,
        IWCO_PET8,
        IWCO_PET9,
        IWCO_PET10,
        IWCO_PET11,
        IWCO_PET12,
        IWCO_PET13,
        IWCO_PET14,
        IWCO_PET15,
        IWCO_PET16,
        IWCO_PET17,
        IWCO_PET18,]]
        -- IWCO_PETEFFECTS,
        -- IWCO_PETUI,
        -- WANI_IWCO_WORLDBOSS1,
        -- IWCO_FIRST,
        -- IWCO_FIGURE_BOY,
        -- IWCO_FIGURE_GIRL,
	}
}

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	初始化方法
--@note		游戏开始运行时调用，统一加载IWCO文件
function AnimationManager:init()
	local aniPool = cwSngAnimationPool:sharedAnimationPool()
	for i,v in ipairs(self.m_tIWcoList) do
		aniPool:loadIWCO("image/animations/sng_animation/", v)
	end
end

--@brief	创建一个播放动画的精灵
--@param	sIWcoName，IWCO文件名
--@param	sAnimationName，动作名称
--@param	tEquip，装备表，key和value都为字符串，如果没有可赋空
--@param	bDefault，是否过滤？可赋空，默认为false
--@return	#1，创建的精灵，其中播放的动作id为0
--@note		根据指定的文件和动作创建一个精灵
function AnimationManager:createSpriteWithAnimation(sIWcoName, sAnimationName, tEquip, bDefault)

	local aniPool=cwSngAnimationPool:sharedAnimationPool()
    local desc = TableToMap(tEquip or {})
	if bDefault == nil then
		bDefault = true
	end
    WZLog("AnimationManager:createSpriteWithAnimation sIWcoName ",sIWcoName,"sAnimationName",sAnimationName,"desc",desc,"bDefault",bDefault)
    local ani = aniPool:animation(sIWcoName, sAnimationName, desc, bDefault)

	if ani ~= nil then
        local sprite = cwSngSprite:create()
        sprite:addAnimationToDict(0,ani)
        sprite:setAnimation(0)
        return sprite
    end
    return nil
end

--@brief	创建一个主角动画
--@param	nSex，主角性别，0:男，1:女
--@param	tEquip，装备表，key和value都为字符串，例如:
--			{bhead = "bhead8", bbody = "bbody8", bface = "bface8", weapon = "weapon15a", wing="wing1"}
--@param	sAnimationName，动作名称，可赋空，默认为"room"
--@return	#1，包含主角动画的Container
--@note		创建一个主角动画，用于商城等非战斗模块
function AnimationManager:createRoleForShop(nSex, tEquip, sAnimationName)

	local sIWcoName = IWCO_SHOPBOY
	if nSex == 1 then
		sIWcoName = IWCO_SHOPGIRL
	end

	local role = self:createSpriteWithAnimation(sIWcoName, sAnimationName or "room", tEquip,false)
	if role == nil then
		WZLog("AnimationManager:createRoleForShop create role fail")
		return
	end
	role:setPosition(CCPointMake(53, 0))
	role:playRepeat()
	local conRole = WZUIContainer:create()
	conRole:setUseAbsSize(true)
	conRole:setAbsContentSize(CCSize(106, 230))
	conRole:addChild(role)

	if tEquip.wing ~= nil then
        local armatureDataManager = CCArmatureDataManager:sharedArmatureDataManager()
        if armatureDataManager:getTextureData(tEquip.wing) == nil then
            armatureDataManager:addArmatureFileInfo("armatures/wing.png", "armatures/wing.plist", "armatures/wing.xml")
        end
        
        local armWing = nil
        WZLog("AnimationManager wing:",tEquip.wing)
        if tEquip.wing == "wing6" then
            armWing = WZUISystem:getInstance():createElement("ArmWing6")
        else
            armWing = WZUISystem:getInstance():createElement("ArmWing")
            armWing = WZArmature:luaTo(armWing)
            if armWing ~= nil then
                armWing:setArmatureName(tEquip.wing)
            end
        end
        if armWing ~= nil then
            conRole:addChild(armWing)
            if sAnimationName ~= nil and sAnimationName == "lose" then
                local posX, posY
                armWing:setRelativePosition(ccp(armWing:getRelativePosition().x,armWing:getRelativePosition().y - 0.13))
            end
        end
	end

	return conRole
end

--@brief    创建一个主角头像
--@param    nSex，主角性别，0:男，1:女
--@param    tEquip，装备表，key和value都为字符串，例如:
--          {bhead = "bhead8", bbody = "bbody8", bface = "bface8", weapon = "weapon15a", wing="wing1"}
--@param    sAnimationName，动作名称，可赋空，默认为"room"
--@return   #1，包含主角动画的Container
--@note     创建一个主角动画，用于商城等非战斗模块
function AnimationManager:createRoleHeadForShop(nSex, tEquip, sAnimationName)

    local sIWcoName = IWCO_SHOPBOY
    if nSex == 1 then
        sIWcoName = IWCO_SHOPGIRL
    end

    local role = self:createSpriteWithAnimation(sIWcoName, sAnimationName or "room", tEquip,false)
    if role == nil then
        WZLog("AnimationManager:createRoleForShop create role fail")
        return
    end
    role:setAnchorPoint(ccp(0.5,0.5))

    local conRole = WZUIContainer:create()
    conRole:setUseAbsSize(true)
    conRole:setAbsContentSize(CCSize(60,60))
    conRole:setAnchorPoint(ccp(0,0))
    conRole:setRelativePosition(ccp(0,0))
    role:setScale(0.5)
    role:setPosition(ccp(15,30))
    conRole:addChild(role)

    return conRole
end

--@brief    创建一个主角头像
--@param    nSex，主角性别，0:男，1:女
--@param    tEquip，装备表，key和value都为字符串，例如:
--          {bhead = "bhead8", bbody = "bbody8", bface = "bface8", weapon = "weapon15a", wing="wing1"}
--@param    sAnimationName，动作名称，可赋空，默认为"room"
--@return   #1，包含主角动画的Container
--@note     创建一个主角动画，用于商城等非战斗模块
function AnimationManager:createRoleHead(nSex, tEquip, sAnimationName)
    local sIWcoName = IWCO_SHOPBOY
    if nSex == 1 then
        sIWcoName = IWCO_SHOPGIRL
    end

    local role = self:createSpriteWithAnimation(sIWcoName, sAnimationName or "room", tEquip,false)
    if role == nil then
        WZLog("AnimationManager:createRoleForShop create role fail")
        return
    end
    return role
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------

