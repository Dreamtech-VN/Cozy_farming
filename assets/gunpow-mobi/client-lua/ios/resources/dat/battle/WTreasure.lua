--WTreasure.lua
--@brief	宝物数据表
--@date		2015/11/12
--@author	莫剑峰
--@note		宝物相关属性及操作

--@brief	宝物数据表
WTreasure = {
    m_nCatchId = 0, --缓存ID
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
}

WTreasureType = {
    TYPE_NOTHING = -1,   --无
    TYPE_ATK = 0,   --攻击加成
    TYPE_HP = 1,   --血量增加
    TYPE_INVINCIBLE = 2,   --无敌
    TYPE_GOLD = 3,   --金币增加
    TYPE_FREEZE = 4,   --冰冻
    TYPE_ANGER = 5,   --怒气增加
    
}

-------------------------------------公有方法模块--------------------------------------

--@brief	生成一个宝物
--@return	#1:宝箱对象
function WTreasure:buildTreasure(sIcon, sLv)
    
	local treasure = WTreasure:new()

    treasure.m_sIcon = sIcon
    treasure.m_sLv = sLv
    treasure.m_tSprite = WZUIImage:create()
    treasure.m_tSprite:setFile("ui/common/common_icon_jinengkuang.png")
    treasure.m_tSprite:setUseOriginSize(true)

    

    treasure.m_tCollisionCharacters = {}
    treasure:addCollisionCharas(WBattleGlobal:getCurrent():getHeroList())
    SceneBattle:getFrontLayer():addChild(treasure.m_tSprite)

    if WBattleGlobal:getCurrent():isEscapeBattle() then
        treasure.m_tSprite:setFile("shopitems/gj_box.png")
        treasure.m_nCount = 1
    else
        local sprite = WZUIImage:create()
        sprite:setFile("image/"..sIcon)
        sprite:setUseOriginSize(true)
        treasure.m_tSprite:addChild(sprite,1,1)

        local lvIcon = treasure.m_sLv
        if lvIcon and lvIcon ~= "" then
            local x,y = 0.7,0.2

            local lv = WZUIImage:create()
            lv:setUseOriginSize(true)
            lv:setFile(lvIcon)
            lv:setRelativePositionLuaTo(x,y)
            treasure.m_tSprite:addChild(lv,2,2)
        end

    end
    WZLog("WTreasure:buildTreasure",tostring(lvIcon) , treasure.m_tSprite:getContentSize().width, treasure.m_tSprite:getContentSize().height)
    
    return treasure
end

--@brief	定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function WTreasure:update(dt)
    --WZLog("WTreasure:update zero", self.m_nCatchId)
    if self.m_bIsCollision == nil and self.m_tSprite then
        local isCollision, heroList = self:checkCollision()
        if isCollision == true then
            self.m_bIsCollision = true
            local nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
            for i,v in pairs(heroList) do
                self.m_nPlayerId = v.m_nPlayerId
            end
            local taget = WZLuaVector_int_:create()
            WZLog("WTreasure:update one")
            if WBattleGlobal:getCurrent():isEscapeBattle() then
                if self.m_nPlayerId == WBattleGlobal:getCurrent():getMyHero():getBattleId() or WBattleGlobal:getCurrent():getCharacterWithId(self.m_nPlayerId):isCanControl() then
                    ProtocolProcessorSceneBattle:send_BATTLE_HitProp(self.m_nCatchId, nBattleId, self.m_nPlayerId, taget)
                end
                self:showUseName(BattleCommon:getPointTable(self.m_nPosX,self.m_nPosY - 55),self.m_sName)
                self:showImage(self.m_tSprite)
            else
                if self.m_nPlayerId == WBattleGlobal:getCurrent():getMyHero():getBattleId() or WBattleGlobal:getCurrent():getCharacterWithId(self.m_nPlayerId):isCanControl() then
                    ProtocolProcessorSceneBattle:send_BATTLE_HitProp(self.m_nCatchId, nBattleId, self.m_nPlayerId, taget)
                end
                BattleHeroUse:heroUse(self.m_nPlayerId,BattleHeroUse.USE_SKILL_OR_ITEM,self.m_nType,false, true)
                self:showUseName(BattleCommon:getPointTable(self.m_nPosX,self.m_nPosY - 55),self.m_sName)
                self:showImage(self.m_tSprite)
                self:showImage(self.m_tSprite:getChildByTag(1))
                self:showImage(self.m_tSprite:getChildByTag(2))
            end
        end
    end
end

--@brief    道具闪现
--@note
function WTreasure:showImage(sprite)

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

function WTreasure:actionEnd(element)
    WZLog("WTreasure:actionEnd", self.m_nCount)
    self.m_nCount = self.m_nCount - 1
    if self.m_nCount <= 0 then
        self:destroy()
    end
end

--@brief    显示使用道具技能的名字
--@param    heroPos:英雄位置
--@param    useName:显示名字
--@note
function WTreasure:showUseName(heroPos,useName,hero)

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

function WTreasure:actionPlayEffect(element)
    element:removeFromParentAndCleanup(true)
    WZLog("WTreasure:actionPlayEffect", self.m_nPlayerId)

    if WBattleGlobal:getCurrent():getHeroWithId(self.m_nPlayerId).m_nBoyOrGirl == 0 then
        SoundManager:playEffectSound(getSoundByType(10))
    else
        SoundManager:playEffectSound(getSoundByType(5))
    end


end

--@brief	检测碰撞
--@param	hero:英雄
--@return	#1:true:撞了,false:没撞
--@return	#2:英雄
function WTreasure:checkCollision()
    --WZLog("WTreasure:checkCollision")
    
	local tmpCharas = {}
	local isCollision = false

    local x,y = self.m_tSprite:getPosition()

    local posV2 = Vector2:create(x,y)
    local raduis = self.m_tSprite:getContentSize().width * 3 / 5
            
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
function WTreasure:checkCollisionWithCharacterList(pos,raduis,charaList)
	--WZLog("WTreasure:checkCollisionWithCharacterList")
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
function WTreasure:addCollisionCharas(tCharas)
	table.insert(self.m_tCollisionCharacters,tCharas)
end

--@brief	销毁一个宝物
function WTreasure:destroy()
    WZLog("WTreasure:destroy", tostring(self.m_nId), tostring(self.m_sName))
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
function WTreasure:setPosition(tPos)
	self.m_tSprite:setPositionX(tPos.x)
    self.m_tSprite:setPositionY(tPos.y)
    self.m_nPosX = tPos.x
    self.m_nPosY = tPos.y
end

--@brief 	获取宝物当前的位置
--@return 	tPos 当前位置
function WTreasure:getPosition()
	return self.m_tSprite:getPosition()
end

--@brief	以本表为模版，WCharacter表为父表创建一个新的表实例对象
--@return	新建的表实例对象
function WTreasure:new()
	setmetatable(WTreasure,{__index = WCharacter})
	local tNewObj = {}
	setmetatable(tNewObj, {__index = WTreasure})
	tNewObj:setType(CharacterType.TYPE_GUAI)
    	tNewObj:_init()
	return tNewObj
end

-------------------------------------私有方法模块--------------------------------------
