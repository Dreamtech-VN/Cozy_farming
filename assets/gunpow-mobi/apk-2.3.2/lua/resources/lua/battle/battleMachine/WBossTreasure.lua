--WBossTreasure.lua
--@brief	宝物数据表
--@date		2016/10/12
--@note		boss道具

--@brief	宝物数据表
WBossTreasure = {
    m_nId = 0,      --id
    m_nType = 0,    --类型
    m_sName = "",   --名称
    m_sIcon = "",   --ICON
    m_sLv = "",     --lv
    m_nPosX = 0,        --X坐标
    m_nPosY = 0,        --Y坐标
    
    m_tSprite = nil,    --图片
    m_tCollisionCharacters = nil,   --需要碰撞的人物列表
    m_bIsCollision = nil,
    m_nPlayerId = 0,
    m_nCount = 2,

    m_bIsDailyItem = false,
}

WBossTreasureType = {
    BOSS7_RED_GUN = 10001,  --红色触发机关
    BOSS7_BULE_GUN = 10002, --蓝色触发机关
    BOSS7_GREEN_GUN = 10003, --绿色触发机关
    BOSS7_YELLOW_GUN = 10004,   --黄色触发机关

    DAILY_ITEM = 20000, -- 日常道具
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个宝物
--@return	#1:宝箱对象
function WBossTreasure:buildTreasure(treasureId)
    WZLog("WBossTreasure:buildTreasure",treasureId)
	local treasure = WBossTreasure:new()
    treasure.m_nId = treasureId
    local config = GDatatab_boss_props["id_"..treasureId] or GDatatab_boss_props["id_1"]
    if treasureId > WBossTreasureType.DAILY_ITEM then
        local mapInfo = CopyTable(GDatatab_daily_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_tower_map["id_1001"])

        treasure.m_nType = treasureId
        treasure.m_sIcon = config.icon
        treasure.m_nScore = config.relation_id * mapInfo.parameter7
        treasure.m_nScale = config.precent/100
        treasure.m_bIsDailyItem = true
    else
        local skillConfig = GDatatab_skill["id_"..config.relation_id]
        treasure.m_nType = skillConfig.id
        treasure.m_sIcon = skillConfig.icon
        treasure.m_sLv = skillConfig.lv_icon
    end
    
    treasure.m_tSprite = WZUIImage:create()
    if not treasure.m_bIsDailyItem then
        treasure.m_tSprite:setFile("ui/common/common_icon_jinengkuang.png")
        treasure.m_tSprite:setUseOriginSize(true)
    end

    --碰撞范围
    treasure.m_nRaduis = 70 * 3/5

    local sprite = WZUIImage:create()
    sprite:setFile("image/"..treasure.m_sIcon)
    sprite:setUseOriginSize(true)

    if treasure.m_bIsDailyItem then
        sprite:setScale(treasure.m_nScale)
        treasure.m_nRaduis = treasure.m_nRaduis * treasure.m_nScale
    end

    treasure.m_tCollisionCharacters = {}
    treasure:addCollisionCharas(WBattleGlobal:getCurrent():getHeroList())
    
    SceneBattle:getFrontLayer():addChild(treasure.m_tSprite)
    treasure.m_tSprite:addChild(sprite,1,1)

    -- local lvIcon = treasure.m_sLv
    -- if lvIcon and lvIcon ~= "" then
    --     local x,y = 0.7,0.2

    --     local lv = WZUIImage:create()
    --     lv:setUseOriginSize(true)
    --     lv:setFile(lvIcon)
    --     lv:setRelativePositionLuaTo(x,y)
    --     treasure.m_tSprite:addChild(lv,2,2)
    -- end

    WZLog("WBossTreasure:buildTreasure",tostring(lvIcon) , treasure.m_tSprite:getContentSize().width, treasure.m_tSprite:getContentSize().height)
	return treasure
end

--@brief	定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function WBossTreasure:update(dt)
    --WZLog("WBossTreasure:update")
    --非玩家行动回合 屏蔽
    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    if self.m_bIsCollision or (hero and hero:getType() ~= 0) then
        return
    end

    if self.m_bIsCollision == nil then
        local isCollision, heroList = self:checkCollision()
        if isCollision == true then
            self.m_bIsCollision = true
            WZLog("WBossTreasure:collision====",self.m_nId)
            if self.m_bIsDailyItem then
                self:addPetScore()
            elseif self.m_nId >= WBossTreasureType.BOSS7_RED_GUN then
                self:setBossGunReady()
            else
                self:useSkillItem({hero})
            end
        end
    end
end

function WBossTreasure:addPetScore()
    self:doItemAction()
    self:showNumAction(self.m_nScore)
    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.PET_COPY_ADD_SCORE,self.m_nScore)
end

--@brief boss7 机关激活
function WBossTreasure:setBossGunReady()
    WZLog("WBossTreasure:setBossGunReady")
    local laserType = WBattleMachineLaserGunStateType.RED
    if self.m_nId == WBossTreasureType.BOSS7_RED_GUN then
        laserType = WBattleMachineLaserGunStateType.RED
    elseif self.m_nId == WBossTreasureType.BOSS7_BULE_GUN then
        laserType = WBattleMachineLaserGunStateType.BLUE
    elseif self.m_nId == WBossTreasureType.BOSS7_GREEN_GUN then
        laserType = WBattleMachineLaserGunStateType.GREEN
    elseif self.m_nId == WBossTreasureType.BOSS7_YELLOW_GUN then
        laserType = WBattleMachineLaserGunStateType.YELLOW
    end

    local laserGun = nil
    for i,v in pairs(WBattleGlobal:getCurrent():getMachinesList()) do
        if v.m_nMonsterType == MonsterType.BOSS_LASER then
            if v.m_nLaserType == laserType then
                laserGun = v
                break
            end
        end
    end

    if laserGun then
        laserGun:setReady()
    end
   
    self:doItemAction()
end
--@brief 道具使用
function WBossTreasure:useSkillItem(charaList)
    for i,v in pairs(charaList) do
        local playerId = v:getBattleId()
        WZLog("WBossTreasure:useSkillItem",self.m_nType)

        if playerId == WBattleGlobal:getCurrent():getMyHero():getBattleId() then
            local taget = WZLuaVector_int_:create()
            local nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
            ProtocolProcessorSceneBattle:send_BATTLE_HitProp(self.m_nType, nBattleId, playerId, taget)
        end
        BattleHeroUse:heroUse(playerId,BattleHeroUse.USE_SKILL_OR_ITEM,self.m_nType,false, true)
    end
    self:doItemAction()
end

--@brief 道具获取动画
function WBossTreasure:doItemAction()
    self:showUseName(BattleCommon:getPointTable(self.m_nPosX,self.m_nPosY - 55),self.m_sName)
    self:showImage(self.m_tSprite)
    self:showImage(self.m_tSprite:getChildByTag(1))
    -- self:showImage(self.m_tSprite:getChildByTag(2))
end

--@brief    道具闪现
--@note
function WBossTreasure:showImage(sprite)
    local delayTime = 0.2
    local fadeTime = 0.1
    local action = WZUIActionSequence:create()
    action:setIsLoop(false)

    local actionDelay1 = WZUIActionDelayTime:create()
    actionDelay1:setDuration(delayTime)

    local actionFadeTo1 = WZUIActionFadeTo:create()
    actionFadeTo1:setOpacity(0)
    actionFadeTo1:setDuration(fadeTime)

    local actionDelay2 = WZUIActionDelayTime:create()
    actionDelay2:setDuration(delayTime)

    local actionFadeTo2 = WZUIActionFadeTo:create()
    actionFadeTo2:setOpacity(255)
    actionFadeTo2:setDuration(fadeTime)

    local actionDelay3 = WZUIActionDelayTime:create()
    actionDelay3:setDuration(delayTime)

    local actionFadeTo3 = WZUIActionFadeTo:create()
    actionFadeTo3:setOpacity(0)
    actionFadeTo3:setDuration(fadeTime)

    local actionDelay4 = WZUIActionDelayTime:create()
    actionDelay4:setDuration(delayTime)

    local actionFadeTo4 = WZUIActionFadeTo:create()
    actionFadeTo4:setOpacity(255)
    actionFadeTo4:setDuration(fadeTime)

    actionFadeTo4:setFinishLuaFunction("actionEnd")
    actionFadeTo4:setFinishLuaTable(self)

    action:setChildAction(actionDelay1)
    action:setChildAction(actionFadeTo1)
    action:setChildAction(actionDelay2)
    action:setChildAction(actionFadeTo2)
    action:setChildAction(actionDelay3)
    action:setChildAction(actionFadeTo3)
    action:setChildAction(actionDelay4)
    action:setChildAction(actionFadeTo4)

    WZUIImage:luaTo(sprite):runUIAction(action)
end

function WBossTreasure:actionEnd(element)
    WZLog("WBossTreasure:actionEnd", self.m_nCount)
    self.m_nCount = self.m_nCount - 1
    if self.m_nCount <= 0 then
        self:destroy()
    end
end

--@brief    显示使用道具技能的名字
--@param    heroPos:英雄位置
--@param    useName:显示名字
--@note
function WBossTreasure:showUseName(heroPos,useName,hero)

    local ttf = WZUILabelTTF:create()
    ttf:setColor(GlobalMethod:ccc3(255,227,116))
    ttf:setFontSize(40)
    ttf:setText(useName)
    ttf:setBoldFont(true)
    ttf:setTouchEnable(false)
    ttf:setEnableStroke(true)
    ttf:setStrokeSize(3)
    ttf:setStrokeColor(GlobalMethod:ccc3(128, 54, 13))

    ---[[
    local action = WZUIActionSequence:create()
    action:setIsLoop(true)

    local actionScale = WZUIActionScaleTo:create()
    actionScale:setDuration(0)
    actionScale:setScaleX(0.5)
    actionScale:setScaleY(0.5)

    local actionScale1 = WZUIActionScaleTo:create()
    actionScale1:setDuration(0.1)
    actionScale1:setScaleX(1.5)
    actionScale1:setScaleY(1.5)

    local actionScale2 = WZUIActionScaleTo:create()
    actionScale2:setDuration(0.1)
    actionScale2:setScaleX(1)
    actionScale2:setScaleY(1)

    local actionDelay = WZUIActionDelayTime:create()
    actionDelay:setDuration(1)


    local dis = 0
    local actionSp = WZUIActionSpawn:create()
    local actionMoveTo = WZUIActionMoveToPosition:create()
    actionMoveTo:setPosition(GlobalMethod:ccp(heroPos.x,heroPos.y + dis+150))
    actionMoveTo:setDuration(1)

    local actionFadeTo = WZUIActionFadeTo:create()
    actionFadeTo:setOpacity(0)
    actionFadeTo:setDuration(1)
    actionFadeTo:setFinishLuaFunction("actionPlayEffect")
    actionFadeTo:setFinishLuaTable(self)

    actionSp:setChildAction(actionMoveTo)
    actionSp:setChildAction(actionFadeTo)

    action:setChildAction(actionScale)
    action:setChildAction(actionScale1)
    action:setChildAction(actionScale2)
    action:setChildAction(actionDelay)
    action:setChildAction(actionSp)
    --]]
    SceneBattle:getFrontLayer():addChild(ttf,6)

    ttf:setPosition(heroPos.x,heroPos.y+ dis)
    ttf:runUIAction(action)

    return ttf
end

-- function WBossTreasure:showNumAction(value)
--     local result = "+" .. tostring(value)
--     local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",3))
--     element:setLuaObjectIndex(self)
--     if element ~= nil then
--         GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText(result)
--         local conHurt = WZUIContainer:luaTo(element)
--         local x,y = self.m_tSprite:getPosition()
--         conHurt:setAbsPosition(GlobalMethod:ccp(x ,y + 120))
--         SceneBattle:getFrontLayer():addChild(conHurt,6)
--     end
-- end

--@brief    显示名字
--@param    value:显示名字
--@note
function WBossTreasure:showNumAction(value)
    local x,y = self.m_tSprite:getPosition()

    local ttf = WZUILabelTTF:create()
    ttf:setColor(GlobalMethod:ccc3(255,227,116))
    ttf:setFontSize(40)
    ttf:setText("+" .. tostring(value))
    ttf:setBoldFont(true)
    ttf:setTouchEnable(false)
    ttf:setEnableStroke(true)
    ttf:setStrokeSize(3)
    ttf:setStrokeColor(GlobalMethod:ccc3(128, 54, 13))

    ---[[
    local action = WZUIActionSequence:create()
    action:setIsLoop(true)

    local actionScale = WZUIActionScaleTo:create()
    actionScale:setDuration(0)
    actionScale:setScaleX(0.5)
    actionScale:setScaleY(0.5)

    local actionScale1 = WZUIActionScaleTo:create()
    actionScale1:setDuration(0.1)
    actionScale1:setScaleX(1.5)
    actionScale1:setScaleY(1.5)

    local actionScale2 = WZUIActionScaleTo:create()
    actionScale2:setDuration(0.1)
    actionScale2:setScaleX(1)
    actionScale2:setScaleY(1)

    local actionDelay = WZUIActionDelayTime:create()
    actionDelay:setDuration(0.5)

    local dis = 0
    local actionSp = WZUIActionSpawn:create()
    local actionMoveTo = WZUIActionMoveToPosition:create()
    actionMoveTo:setPosition(GlobalMethod:ccp(x,y+300))
    actionMoveTo:setDuration(0.5)

    local actionFadeTo = WZUIActionFadeTo:create()
    actionFadeTo:setOpacity(0)
    actionFadeTo:setDuration(0.5)
    
    actionFadeTo:setFinishLuaFunction("actionPlayEffectEnd")
    
    actionFadeTo:setFinishLuaTable(self)

    actionSp:setChildAction(actionMoveTo)
    actionSp:setChildAction(actionFadeTo)

    action:setChildAction(actionScale)
    action:setChildAction(actionScale1)
    action:setChildAction(actionScale2)
    action:setChildAction(actionDelay)
    action:setChildAction(actionSp)
    --]]
    SceneBattle:getFrontLayer():addChild(ttf,6)

    ttf:setPosition(x,y+100)
    ttf:runUIAction(action)

    return ttf
end

--@brief    道具出现文字回调
function WBossTreasure:actionPlayEffectEnd(element)
    element:removeFromParentAndCleanup(true)
    WZLog("WBossTreasure:actionPlayEffectEnd")
end

--@brief    伤害数字显示完成的回调
function WBossTreasure:_finishFlyingNum(element)
    WZLog("WBossTreasure:_finishFlyingNum", tostring(element))

    element:removeFromParentAndCleanup(true)
end


function WBossTreasure:actionPlayEffect(element)
    element:removeFromParentAndCleanup(true)
    WZLog("WBossTreasure:actionPlayEffect")
end

--@brief	检测碰撞
--@param	hero:英雄
--@return	#1:true:撞了,false:没撞
--@return	#2:英雄
function WBossTreasure:checkCollision()
    --WZLog("WBossTreasure:checkCollision")
    
	local tmpCharas = {}
	local isCollision = false

    local x,y = self.m_tSprite:getPosition()

    local posV2 = Vector2:create(x,y)
    local raduis = self.m_nRaduis
            
	for i,charaList in pairs(self.m_tCollisionCharacters) do
		local isCollisionInList,collisionCharas = self:checkCollisionWithCharacterList(posV2, raduis, charaList)        
        
		if not isCollision then
			isCollision = isCollisionInList
		end
        
		AddTableToTable(tmpCharas,collisionCharas)
	end
    
	return isCollision,tmpCharas
end

--@brief	检查碰撞
--@param	pos:位置
--@param	raduis:半径
--@param	charaList:列表
--@return	#1:true:撞了,false:没撞
--@return	#2:碰撞的人物列表
function WBossTreasure:checkCollisionWithCharacterList(pos,raduis,charaList)
	--WZLog("WBossTreasure:checkCollisionWithCharacterList")
    local tmpCharas = {}
	local isCollision = false
    
    --检测与人物的碰撞
    ---[[
	for id,chara in pairs(charaList) do
		if not chara:isDead() then
            
			local charaPos = chara:getCenterPos()
			local charaRaidus = chara:getRadiusForBulletCollision()
			local collisionRang = chara:getCollisionRang()
			if  BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus) then
				WZLog("hero chara collosion")
				isCollision = true
				tmpCharas[id] = chara
			end
		end
	end
    --]]
    --检测与子弹的碰撞
    local bullets = WBattleGlobal:getCurrent():getBulletsList()
    for id,chara in pairs(bullets) do
		if true then
            
			local charaPos = chara.m_mover:getMoverPosition()
			local charaRaidus = 2
			if  BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus) then
				WZLog("bullet chara collosion")
				isCollision = true
				tmpCharas[id] = chara.m_ownerChara
			end
		end
	end
    
    
	return isCollision,tmpCharas
end

--@brief	添加碰撞列表
--@param	tCharas:碰撞列表
function WBossTreasure:addCollisionCharas(tCharas)
	table.insert(self.m_tCollisionCharacters,tCharas)
end

--@brief	销毁一个宝物
function WBossTreasure:destroy()
    WZLog("WBossTreasure:destroy", tostring(self.m_nId), tostring(self.m_sName))
    if self.m_tSprite ~= nil and self.m_tSprite.removeFromParentAndCleanup ~= nil then
        WCharacter.destroy(self)
        self.m_tSprite:removeFromParentAndCleanup(true)
    end

    self.m_nId = 0
    self.m_nGroup = 0
    self.m_nType = 0
    self.m_sName = ""
    self.m_sIcon = ""
    self.m_nEffect1 = 0
    self.m_nEffect2 = 0
    self.m_nTurn = 0
    self.m_nProbbility = 0
    self.m_nPosX = 0
    self.m_nPosY = 0
    
	self.m_tSprite = nil
    self.m_tCollisionCharacters = nil
end

--@brief 	设置宝物当前的位置
--@param 	tPos 当前位置
function WBossTreasure:setPosition(tPos)
	self.m_tSprite:setPositionX(tPos.x)
    self.m_tSprite:setPositionY(tPos.y)
    self.m_nPosX = tPos.x
    self.m_nPosY = tPos.y
end

--@brief 	获取宝物当前的位置
--@return 	tPos 当前位置
function WBossTreasure:getPosition()
	return self.m_tSprite:getPosition()
end

--@brief	以本表为模版，WCharacter表为父表创建一个新的表实例对象
--@return	新建的表实例对象
function WBossTreasure:new()
	setmetatable(WBossTreasure,{__index = WCharacter})
	local tNewObj = {}
	setmetatable(tNewObj, {__index = WBossTreasure})
	tNewObj:setType(CharacterType.TYPE_GUAI)
    	tNewObj:_init()
	return tNewObj
end

-------------------------------------私有方法模块--------------------------------------
