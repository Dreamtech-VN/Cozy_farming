--BattleShowHeroUse.lua
--@brief    英雄使用道具等显示
--@date     2014/01/22
--@author   Zjh
--@note		包括道具技能等使用的显示

BattleShowHeroUse = {
	CELL_WIDTH = 62,
	CELL_HEIGHT = 62,
	CELL_DIS = 10,
	--
	m_useContainer = nil,
	m_tInfo =
	{
		useType,	--使用类型
		useId,		--道具或技能ID，大招为大招类型
		usePng,		--对应的图片路径
	},
	m_nPlayerId = nil,
	m_tUseAnim = nil,
	m_nUseId = nil, 
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	增加一个英雄使用显示
--@param	playerId:英雄Id
--@param	useType:使用类型
--@param	useId:道具或技能ID，其他则不需要填
--@param	bNotShowCell：是否不显示道具Cell
--@note
function BattleShowHeroUse:addHeroUse(playerId,useType,useId,bNotShowCell)
    WZLog("BattleShowHeroUse:addHeroUse zero",playerId,useType,useId)
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(playerId)
	if hero == nil then
		return
	end
	local heroPos = hero:getAnimation():getPosition()
	local usePng = ""
	local useName
    local lv = ""
    self.m_nUseId = useId
	--配置名字图片等信息
	if useType == BattleHeroUse.USE_BIGSKILL then

        local info = GDatatab_skill["id_"..hero.m_nBigSkillType].name
		useId = 1 --hero.m_nBigSkillType
		usePng = "battleitems/battle_icon_dazhao.png"
		useName = info

	elseif useType == BattleHeroUse.USE_FLY then

		useId = 1
		useName = ""
		usePng = "ui/combat/battle_icon_feixing.png"
	elseif useType == BattleHeroUse.USE_CTB then
		useId = 1
		useName = ""
		usePng = "ui/combat/common_icon_jxjn.png"
	elseif useType == BattleHeroUse.USE_TREASURE then

        --获取要处理的宝箱
        local treasureCurrent = nil
        for id,boss in pairs(WBattleGlobal:getCurrent():getBossList()) do
            for key,treasure in pairs(boss.m_tTreasureList) do
                if useId == treasure.m_nId then
                    treasureCurrent = treasure
                end
            end
        end

        heroPos = {x = treasureCurrent.m_nPosX, y = treasureCurrent.m_nPosY}
        useName = treasureCurrent.m_sName

	else
		if useType == BattleHeroUse.USE_ITEM or useType == BattleHeroUse.USE_SKILL_OR_ITEM or useType == BattleHeroUse.USE_GHOSTSKILL then
			local item = WBattleGlobal:getCurrent():getItemById(useId)
			if useType == BattleHeroUse.USE_GHOSTSKILL and item.target_type == 3 then 
				usePng = item.icon
				useName = item.name
				useType = BattleHeroUse.USE_SKILL

				useType = BattleHeroUse.USE_SKILL_SUB
				useId = item.itemSubType
                lv = item.lv
			else
				if item then
					usePng = item.icon
					useName = item.name
					useType = BattleHeroUse.USE_ITEM

					useType = BattleHeroUse.USE_ITEM_SUB
					useId = item.itemSubType
	                lv = item.lv

				end
			end
		end
		if useType == BattleHeroUse.USE_SKILL or useType == BattleHeroUse.USE_SKILL_OR_ITEM then
			local skill = WBattleGlobal:getCurrent():getSkillById(useId)
			if skill then
				usePng = skill.icon
				useName = skill.name
				useType = BattleHeroUse.USE_SKILL

				useType = BattleHeroUse.USE_SKILL_SUB
				useId = skill.itemSubType
                lv = skill.lv
			end
		end

		if useType == BattleHeroUse.USE_SKILL_OR_ITEM then
			WZLog("no such item/skill")
			return
		end
	end
	WZLog("BattleShowHeroUse:addHeroUse ###", type(self.m_nPlayerId), playerId)
	if self.m_nPlayerId and self.m_nPlayerId ~= playerId then
		self:removeHeroUse()
	end

	self.m_nPlayerId = playerId

	if useType ~= BattleHeroUse.USE_FLY then
		local ttf = self:showUseName(heroPos,useName,hero)
		if useType == BattleHeroUse.USE_SKILL or useType == BattleHeroUse.USE_SKILL_SUB or useType == BattleHeroUse.USE_BIGSKILL then
			ttf:setTag(useType)
		end
	end

    WZLog("such item/skill",usePng, useName, type(bNotShowCell))

	if bNotShowCell == nil or bNotShowCell == false then
		self:addHeroUseCell(heroPos,useType,useId,usePng,lv)
	end
	WZLog("BattleShowHeroUse:addHeroUse *****")
	if useType == BattleHeroUse.USE_ITEM_SUB then
		if useId == BattleHeroUse.BLOODT_SKILL_ID_START or useId == BattleHeroUse.ITEM_SUB_HIDET then
			local sameTeam = WBattleGlobal:getCurrent():isMyTeam(playerId)
            local memberList
            if WBattleGlobal:getCurrent():isSingleStage() then
                memberList = WBattleGlobal:getCurrent().m_tSingleActivityMemberList
            else
                memberList = WBattleGlobal:getCurrent():getHeroList()
            end
			for k,hero in pairs(memberList) do
				if WBattleGlobal:getCurrent():isMyTeam(hero:getId()) == sameTeam and  hero:getHp() > 0 and not hero:isDead() then
					self:playUseAnim(hero:getId(),useType,useId)
				end
			end

		else
			self:playUseAnim(playerId,useType,useId)
		end
	else
		self:playUseAnim(playerId,useType,useId)
	end
end

--@brief	使用显示动画
--@param	playerId:英雄Id
--@param	useType:使用类型
--@param	useId:道具或技能ID，其他则不需要填
function BattleShowHeroUse:playUseAnim(playerId,useType,useId)
	local hero = WBattleGlobal:getCurrent():getCharacterWithId(playerId)
	local animName = "use"
    WZLog("BattleShowHeroUse:playUseAnim",playerId,useType,useId)
	if useId then
		if useType == BattleHeroUse.USE_ITEM_SUB then
			if (useId == BattleHeroUse.BLOOD_SKILL_ID_START or (useId >= BattleHeroUse.BLOOD_SKILL_ID_END and useId <= BattleHeroUse.BLOOD_SKILL_ID_END + 3)) or (useId == BattleHeroUse.BLOODT_SKILL_ID_START or (useId >= BattleHeroUse.BLOODT_SKILL_ID_END and useId <= BattleHeroUse.BLOODT_SKILL_ID_END + 3) ) then
				animName = "blood"
			elseif useId == BattleHeroUse.ANGER_SKILL_ID_START or (useId >= BattleHeroUse.ANGER_SKILL_ID_END and useId <= BattleHeroUse.ANGER_SKILL_ID_END + 3) then
				animName = "anger"
			elseif useId == BattleHeroUse.ITEM_SUB_HIDE or useId == BattleHeroUse.ITEM_SUB_HIDET then
				animName = "hide"
			end
		elseif useType == BattleHeroUse.USE_SKILL_SUB then
			if useId == BattleHeroUse.SKILL_SUB_FROZEN then
				--animName = "frozen2"
			end
		elseif useType == BattleHeroUse.USE_TREASURE then

	            if useId == BattleHeroUse.TREASURE_BLOOD then
					animName = "blood"
	            elseif useId == BattleHeroUse.TREASURE_FROZEN then
					animName = "frozen2"
	            end
		end
	end

	self:runUseAnim(hero,animName,SceneBattle:getFrontLayer())
end

--@brief	播放显示动画
--@param	hero:英雄table
--@param	animName:动画名字
--@param	animParent:动画的父节点
function BattleShowHeroUse:runUseAnim(hero,animName,animParent)
	local heroPos = hero:getAnimation():getPosition()
    WZLog("BattleShowHeroUse:runUseAnim", hero.m_sPlayerName,animName)

	local anim
	if animName == "anger" then
		anim = BattleAnimation:createAnimation("skills_nqhd_01",true)
		anim:setScale(1.3)
		anim:getAnimNode():setUseAbsCoordinate(true)
		hero:getAnimation():getAnimNode():addChild(anim:getAnimNode())
		anim:setPosition({x = 80,y = -35})
		anim:play("0")
	elseif animName == "blood" then
		anim = BattleAnimation:createAnimation("skill_zl_hd",false)
		anim:setScale(1.0)
		anim:getAnimNode():setUseAbsCoordinate(true)
        anim:getAnimNode():setAnimationName("hit")
        anim:getAnimNode():setLoop(false)
        anim:getAnimNode():setAbsPosition(GlobalMethod:ccp(hero:getPosition().x + 20,hero:getPosition().y + 80))
        SceneBattle:getFrontLayer():addChild(anim:getAnimNode(),10)
	else
		anim = BattleAnimation:createAnimation("skill_jineng_dianji",false,"battle/skill")
		anim:getAnimNode():setUseAbsCoordinate(true)
        anim:getAnimNode():setAnimationName("effect")
        anim:getAnimNode():setLoop(false)
        anim:getAnimNode():setAbsPosition(GlobalMethod:ccp(85,225))
		hero:getAnimation():getAnimNode():addChild(anim:getAnimNode())
	end
	local tSkillData = GDatatab_skill["id_" .. self.m_nUseId]
	if tSkillData and tSkillData.skill_type == 9 then 
		WZLog("BattleShowHeroUse UUUUUUUUUUUUUUUUUUUUUU")
	else
		hero:getAnimation():play(hero:getActionName(19),false)
	end
	if hero.isHide ~= nil and hero:isHide() == true then
		if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(hero:getId()) then
		    anim:getAnimNode():setOpacity(128)
		else
		    anim:getAnimNode():setOpacity(0)
		end
	end

	if self.m_tUseAnim ==nil then
		self.m_tUseAnim = {}
	end
	table.insert(self.m_tUseAnim,anim)

end

--@brief	设置英雄使用显示栏位置
--@param	heroPos:英雄位置
function BattleShowHeroUse:setHeroUsePosition(heroPos)

    local point = SceneBattle:getFrontLayer():convertToWorldSpaceAuto(CCAutoPoint:create(heroPos.x,heroPos.y + 145))
    point = SceneBattle:getInfoLayer():convertToNodeSpaceAuto(point)
    self.m_useContainer:setPosition(point.x,point.y)

end

--@brief	增加一个英雄使用显示栏Cell
--@param	heroPos:英雄位置
--@brief	useType:使用类型
--@brief	useId:道具或技能ID，大招为大招类型
--@brief	usePng:对应的图片路径
--@note
function BattleShowHeroUse:addHeroUseCell(heroPos,useType,useId,usePng,lv)

	if self.m_useContainer == nil then
		self.m_useContainer = WZUIContainer:create()

		SceneBattle:getInfoLayer():addChild(self.m_useContainer)
		self.m_useContainer:setContentSize(GlobalMethod:CCSize(BattleShowHeroUse.CELL_WIDTH,BattleShowHeroUse.CELL_HEIGHT))
		self.m_tInfo = {}
	else
		local size = self.m_useContainer:getContentSize()
		self.m_useContainer:setContentSize(GlobalMethod:CCSize(size.width + BattleShowHeroUse.CELL_WIDTH + BattleShowHeroUse.CELL_DIS , BattleShowHeroUse.CELL_HEIGHT))
	end

	table.insert(self.m_tInfo,{useType = useType , useId = useId , usePng = usePng })

    local pic = self:_createCell(usePng,lv, useType)
	self.m_useContainer:addChild(pic)

    local hero = WBattleGlobal:getCurrent():getCurrentCharacter()
    WZLog("BattleShowHeroUse:addHeroUseCell one", tostring(lv))
    if hero:isHide() == true then
        if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(hero:getId()) then
            WndBattleHud:_setContainerOpacity(self.m_useContainer,128)
        else
            WndBattleHud:_setContainerOpacity(self.m_useContainer,0)
        end
    end

	if #self.m_tInfo > 1 then
		self:_resortCell()
		if useType == BattleHeroUse.USE_BIGSKILL then
			self:_changeGrayCell()
		end
	else
		self:setHeroUsePosition(heroPos)
	end
end

--@brief	移除英雄使用显示栏
--@note
function BattleShowHeroUse:removeHeroUse()
	if self.m_useContainer then
        WZLog("BattleShowHeroUse:removeHeroUse")
		self.m_useContainer:removeFromParentAndCleanup(true)
		self.m_useContainer = nil
		self.m_tInfo = nil
		self.m_nPlayerId = nil
		WndBattleHud:setUseAwakeSkillState(false)
	end
end

--@brief	更新英雄使用显示栏
--@note
function BattleShowHeroUse:update()
	if self.m_useContainer then
		if SceneBattle:getBattleLoop():getBattleStatus()==BattleLoop.S_PLAYER_SHOOT or SceneBattle:getBattleLoop():getBattleStatus()==BattleLoop.S_PLAYER_FLY then
			if not WndBattleHud:getUseAwakeSkillState() then
            	self:removeHeroUse()
            else
            	local heroPos = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nPlayerId):getAnimation():getPosition()
				self:setHeroUsePosition(heroPos)
            end
		else
			local heroPos = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nPlayerId):getAnimation():getPosition()
			self:setHeroUsePosition(heroPos)
		end
	end
	if self.m_tUseAnim then
		for i=#self.m_tUseAnim,1,-1 do
			if self.m_tUseAnim[i]:isCurrentAnimationDone() then
				self.m_tUseAnim[i]:getAnimNode():removeFromParentAndCleanup(true)
				table.remove(self.m_tUseAnim,i)
			end
		end
	end
end

--@brief	显示使用道具技能的名字
--@param	heroPos:英雄位置
--@param	useName:显示名字
--@note
function BattleShowHeroUse:showUseName(heroPos,useName,hero)

    local ttf = WZUILabelTTF:create()
    ttf:setColor(GlobalMethod:ccc3(255,227,116))
    ttf:setFontSize(40)
    ttf:setText(useName)
    ttf:setBoldFont(true)
    ttf:setTouchEnable(false)
    ttf:setEnableStroke(true)
    ttf:setStrokeSize(3)
    ttf:setStrokeColor(GlobalMethod:ccc3(128, 54, 13))
    --ttf:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))

    --[[
        local action = WZUIActionSpawn:create()

        local actionMoveTo = WZUIActionMoveToPosition:create()
        actionMoveTo:setPosition(GlobalMethod:ccp(heroPos.x,heroPos.y+180))
        actionMoveTo:setDuration(1.8)
        actionMoveTo:setFinishLuaFunction("showUseNameDone")
        actionMoveTo:setFinishLuaTable(self)

        local actionFadeTo = WZUIActionFadeTo:create()
        actionFadeTo:setOpacity(0)
        actionFadeTo:setDuration(1.8)

        local actionDelay = WZUIActionDelayTime:create()
        actionDelay:setDuration(1)
        actionDelay:setFinishLuaFunction("actionPlayEffect")
        actionDelay:setFinishLuaTable(self)

        action:setChildAction(actionMoveTo)
        action:setChildAction(actionDelay)

    --]]

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


    local dis = 110
    local actionSp = WZUIActionSpawn:create()
    local actionMoveTo = WZUIActionMoveToPosition:create()
    actionMoveTo:setPosition(GlobalMethod:ccp(heroPos.x,heroPos.y + dis+150))
    actionMoveTo:setDuration(1)

    local actionFadeTo = WZUIActionFadeTo:create()
    actionFadeTo:setOpacity(0)
    actionFadeTo:setDuration(1)
    actionFadeTo:setFinishLuaFunction("actionPlayEffect") --("showUseNameDone")
    actionFadeTo:setFinishLuaTable(self)

    actionSp:setChildAction(actionMoveTo)
    actionSp:setChildAction(actionFadeTo)
    --actionSp:setFinishLuaFunction("actionPlayEffect")
    --actionSp:setFinishLuaTable(self)

    action:setChildAction(actionScale)
    action:setChildAction(actionScale1)
    action:setChildAction(actionScale2)
    action:setChildAction(actionDelay)
    action:setChildAction(actionSp)
    --]]
    SceneBattle:getFrontLayer():addChild(ttf,6)
    if hero:isHide() == true then
        if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(hero:getId()) then
            ttf:setOpacity(128)
        else
            ttf:setOpacity(0)
        end
    end

	ttf:setPosition(heroPos.x,heroPos.y+ dis)
	ttf:runUIAction(action)

	return ttf
end

function BattleShowHeroUse:actionPlayEffect(element)
	local tag = element:getTag()
    element:removeFromParentAndCleanup(true)
    WZLog("BattleShowHeroUse:actionPlayEffect", tag, BattleHeroUse.USE_BIGSKILL, tostring(self.m_nPlayerId))
	-- if self.m_nPlayerId and tag then
	-- 	if tag == BattleHeroUse.USE_SKILL or tag == BattleHeroUse.USE_SKILL_SUB then

 --            if math.random(1,10) <= 5 then
 --                if WBattleGlobal:getCurrent():getCharacterWithId(self.m_nPlayerId).m_nBoyOrGirl == 0 then
 --                    SoundManager:playEffectSound(getSoundByType(10))
 --                else
 --                    SoundManager:playEffectSound(getSoundByType(5))
 --                end
 --            end
	-- 	elseif tag == BattleHeroUse.USE_BIGSKILL then

	-- 		if WBattleGlobal:getCurrent():getCharacterWithId(self.m_nPlayerId).m_nBoyOrGirl == 0 then
	-- 			SoundManager:playEffectSound(getSoundByType(13))
	-- 		else
	-- 			SoundManager:playEffectSound(getSoundByType(8))
	-- 		end
	-- 	end
	-- end
end

--@brief	显示名字动画结束回调
--@param	element:回调绑定的UI节点引用
--@note
function BattleShowHeroUse:showUseNameDone(element)
    WZLog("BattleShowHeroUse:showUseNameDone")
	element:removeFromParentAndCleanup(true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	使用显示栏Cell变灰
--@note		使用大招时候使用
function BattleShowHeroUse:_changeGrayCell()
	for i=1,#self.m_tInfo do
		local isNeed = (self.m_tInfo[i].useType == BattleHeroUse.USE_SKILL)
		isNeed = isNeed or (self.m_tInfo[i].useType == BattleHeroUse.USE_FLY)
		isNeed = isNeed or (self.m_tInfo[i].useType == BattleHeroUse.USE_SKILL_SUB)
		if isNeed then
			local img = self.m_useContainer:getChildElement("imgShowHeroUse"..i.."_SceneBattle")
			WZUIImage:luaTo(img):setColor(GlobalMethod:ccc3(100,100,100))
		end
	end
end

--@brief	创建一个显示栏Cell
--@param	usePng:Cell的图片路径
--@note		增加Cell时候使用
function BattleShowHeroUse:_createCell(usePng,lvIcon, useType)
	local cell = WZUIContainer:create()
	cell:setUseAbsSize(true)
	cell:setAbsContentSize(GlobalMethod:CCSize(BattleShowHeroUse.CELL_WIDTH,BattleShowHeroUse.CELL_HEIGHT))

	local bg = WZUIImage:create()
	bg:setFile("ui/common/common_icon_jinengkuang.png")
	local img = WZUIImage:create()
	img:setFile(usePng)
	img:setUseOriginSize(true)
	img:setName("imgShowHeroUse"..(#self.m_tInfo).."_SceneBattle")
	if useType ~= BattleHeroUse.USE_CTB then		
		cell:addChild(bg)
	end
	cell:addChild(img)

    if lvIcon and lvIcon ~= "" then
        local x,y = 0.7,0.2

        local lv = WZUIImage:create()
        lv:setUseOriginSize(true)
        lv:setFile(lvIcon)
        lv:setRelativePositionLuaTo(x,y)
        cell:addChild(lv,10)
    end

	cell:setTag(#self.m_tInfo)
	return cell
end

--@brief	使用显示栏Cell重排
--@note		增加Cell时候使用
function BattleShowHeroUse:_resortCell()
	for i=1,#self.m_tInfo do
		local xPos = (i-0.5)*BattleShowHeroUse.CELL_WIDTH + (i-1)*BattleShowHeroUse.CELL_DIS
		local yPos = BattleShowHeroUse.CELL_HEIGHT / 2
		local size = self.m_useContainer:getContentSize()
		WZUIContainer:luaTo(self.m_useContainer:getChildByTag(i)):setPosition(xPos,yPos)
	end
end

-------------------------------------私有方法模块End----------------------------------------
