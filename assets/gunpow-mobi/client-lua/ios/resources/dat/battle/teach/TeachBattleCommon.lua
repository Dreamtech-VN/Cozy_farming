--TeachBattleCommon.lua
--@brief	TeachBattleCommon
--@date		2013/2/24
--@author	Zjh
--@note		战斗教学公用类

TeachBattleCommon = {

	SHOOT_POWER_MIN = 40,	--最小射击力度
	SHOOT_POWER_MAX = 300,	--最大射击力度
	SHOOT_POWER_BASE = 20,	--射击力度基数

	SHOOT_LEAST_DIS = 5,
}
-------------------------------------公有方法模块Begin--------------------------------------

function TeachBattleCommon:zoomToHero(fScale,nOffsetX,nOffsetY)
    local offsetScale = 1
    if TeachBattle.TEACH_TYPE == 2 then
        offsetScale = 0.7
    end
	fScale = fScale or offsetScale
	nOffsetX = nOffsetX or 0
	nOffsetY = nOffsetY or 0
	return BattleMapManager:getFrontControl():zoomToScaleAndPointQuickly(fScale,{x = WBattleGlobal:getCurrent():getMyHero():getPosition().x + nOffsetX,y = WBattleGlobal:getCurrent():getMyHero():getPosition().y + nOffsetY})
end

function TeachBattleCommon:zoomToBoss(fScale,nOffsetX,nOffsetY)
    local offsetScale, offsetY = 1, 0
    if TeachBattle.TEACH_TYPE == 2 then
        offsetScale = 0.7
        offsetY = -50
    end
    fScale = fScale or offsetScale
	nOffsetX = nOffsetX or 0
	nOffsetY = nOffsetY or offsetY
	return BattleMapManager:getFrontControl():zoomToScaleAndPointQuickly(fScale,{x = WBattleGlobal:getCurrent():getCharacterWithId(-2):getPosition().x + nOffsetX,y = WBattleGlobal:getCurrent():getCharacterWithId(-2):getPosition().y + nOffsetY })
end

--@brief	显示使用道具技能的名字
--@param	heroPos:英雄位置
--@param	useName:显示名字
--@note
function TeachBattleCommon:showUseName(heroPos,useName)
	local ttf = WZUILabelTTF:create()
	ttf:setColor(GlobalMethod:ccc3(255,255,255))
	ttf:setText(useName)
	ttf:setFontSize(36)
	local action = WZUIActionSpawn:create()

	local actionMoveTo = WZUIActionMoveToPosition:create()
	actionMoveTo:setPosition(GlobalMethod:ccp(heroPos.x,heroPos.y+180))
	actionMoveTo:setDuration(1.8)
	actionMoveTo:setFinishLuaFunction("showUseNameDone")
	actionMoveTo:setFinishLuaTable(self)

	local actionFadeTo = WZUIActionFadeTo:create()
	actionFadeTo:setOpacity(0)
	actionFadeTo:setDuration(1.8)

	action:setChildAction(actionMoveTo)
	action:setChildAction(actionFadeTo)
	SceneBattle:getFrontLayer():addChild(ttf)

	ttf:setPosition(GlobalMethod:ccp(heroPos.x,heroPos.y-25))
	ttf:runUIAction(action)

	SoundManager:playEffectSound(SoundDefine.E_S_USE_ITEM)
end

--@brief	显示名字动画结束回调
--@param	element:回调绑定的UI节点引用
--@note
function TeachBattleCommon:showUseNameDone(element)
	element:removeFromParentAndCleanup(true)
end

--@brief	计算发射时候的速度
--@note		根据Hero位置和触摸位置得到最终的速度
function TeachBattleCommon:calSpeed()
	local touch = SceneBattle:getBattleTouch()
	local anim = WBattleGlobal:getCurrent():getMyHero():getAnimation()
	local animPos = anim:getPosition()
	local touchPoint = GlobalMethod:ccp( touch:getTouchPoint(1).x,touch:getTouchPoint(1).y )
	touchPoint = CCDirector:sharedDirector():convertToUI(touchPoint)
	animPos.y = animPos.y + anim:getAnimNode():getContentSize().height/2
	animPos = GlobalMethod:ccp(animPos.x,animPos.y)
	animPos = SceneBattle:getFrontLayer():convertToWorldSpaceAR(animPos)
	animPos = CCDirector:sharedDirector():convertToUI(animPos)

	local pointX,pointY = animPos.x - touchPoint.x , -(animPos.y - touchPoint.y)
	local length = math.sqrt(pointX * pointX + pointY * pointY)
	length = length * SceneBattle:getFrontLayer():getScale() * 1.5
	pointX = pointX / length
	pointY = pointY / length
	if length < TeachBattleCommon.SHOOT_POWER_MIN then
		length = TeachBattleCommon.SHOOT_POWER_MIN
	elseif length > TeachBattleCommon.SHOOT_POWER_MAX then
		length = TeachBattleCommon.SHOOT_POWER_MAX
	end
	local rate = (length - TeachBattleCommon.SHOOT_POWER_MIN) / (TeachBattleCommon.SHOOT_POWER_MAX - TeachBattleCommon.SHOOT_POWER_MIN)
	local shootPower = rate * TeachBattleCommon.SHOOT_POWER_BASE * 1.3
	return pointX * shootPower , pointY * shootPower
end

--@brief	准备发射或射击阶段
function TeachBattleCommon:readyFlyOrShoot()
	local touch = SceneBattle:getBattleTouch()
	local hero = WBattleGlobal:getCurrent():getMyHero()

    --WZLog("TeachBattleCommon:readyFlyOrShoot one",tostring(SceneBattle:getBattleLoop():getPressPoint()))
	if SceneBattle:getBattleLoop():getPressPoint() then
        --WZLog("TeachBattleCommon:readyFlyOrShoot two",touch:getTouchStatus(1),touch:getTouchStatus(2))
		if touch:getTouchStatus(1) ~= BattleTouch.TOUCH_NONE and touch:getTouchStatus(2) == BattleTouch.TOUCH_NONE then
			if touch:getTouchStatus(1) ~= BattleTouch.TOUCH_END then
				--描绘
				local anim = hero:getAnimation()
				local animPos = anim:getPosition()
				local speedX,speedY = self:calSpeed()
				local startPos = {}
				if speedX < 0 then
					startPos.x = animPos.x - 40
					if anim:isFlipX() == false then
						hero:getAnimation():setFlipX(true)
					end
				else
					startPos.x = animPos.x + 40
					if anim:isFlipX() == true then
						hero:getAnimation():setFlipX(false)
					end
				end
				startPos.y = animPos.y + 60
				--SceneBattle:getBattlePointsLine():setVisible(true)
				--SceneBattle:getBattlePointsLine():updateInTeach(startPos,{x = speedX,y = speedY},BattleConstants.g_nFlyGravity)
                --WZLog("TeachBattleCommon:readyFlyOrShoot three",touch:getTouchStatus(1),touch:getTouchStatus(2),startPos.x,startPos.y,speedX,speedY)

				return false
			else
				local anim = hero:getAnimation()
				local animPos = anim:getPosition()
				local touchPoint = GlobalMethod:ccp( touch:getTouchPoint(1).x,touch:getTouchPoint(1).y )
				touchPoint = touch:pointWorldToNode( anim:getAnimNode() , touchPoint )
				local pressPoint = GlobalMethod:ccp( SceneBattle:getBattleLoop():getPressPoint().x , SceneBattle:getBattleLoop():getPressPoint().y )
				pressPoint = touch:pointWorldToNode( anim:getAnimNode() , pressPoint )
				if BattleCommon:pointDis(pressPoint,touchPoint) > TeachBattleCommon.SHOOT_LEAST_DIS then
					--SceneBattle:getBattlePointsLine():setVisible(false)
					return true
				end
			end
		end
	end

	--SceneBattle:getBattlePointsLine():setVisible(false)
	return false

end


--@brief	显示射击指引动画
--@param	parent,要加到的父节点
--@param	tPos,含x,y键值的表,表示显示的位置
--@param	rotation,离45度的偏差值
--@return	生成的动画控件
function TeachBattleCommon:showFingerAnimation(parent,tPos,rotation, zOrder, isFlipX, isRight,isClick)
    if zOrder == nil then
        zOrder = 0
    end
    if isFlipX == nil then
        isFlipX = false
    end

    if isFlipX == true and isRight == nil then
    	isRight = true
    end

    WZLog("TeachBattleCommon:showFingerAnimation one", parent:getScaleX(), parent:getScaleY(), parent, tPos.x, tPos.y, rotation, zOrder, tostring(isFlipX), tostring(isRight))
	local container = WZUIContainer:create()
	container:setAnchorPoint(GlobalMethod:ccp(1,1))
	container:setVisible(false)
	container:setTouchEnable(false)
	container:setUseAbsSize(true)
	container:setAbsContentSize(GlobalMethod:CCSize(300,300))
	container:setRotation(rotation)
	parent:addChild(container,0,zOrder)
	container:setPosition(tPos.x --[[+ tPos.x * (parent:getScaleY() - parent:getScaleX()) * 0.1]],tPos.y)
	container:setScale(0.3/parent:getScaleY())

	for i=1,4 do

		local bg = WZUIImage:create()
		bg:setUseOriginSize(true)
		bg:setScale(2.8)
	    bg:setFile("ui/teach/common_icon_xsyd4.png")
	    container:addChild(bg,0)
	    bg:setRotation(45)
	    bg:setRelativePosition(GlobalMethod:ccp(0.19 * i ,0.2 * i - 0.08 ) )

		WZLog("TeachBattleCommon:showFingerAnimation three", i, 0.2 * i ,0.2 * i - 0.2)
	end

	--[[
	local armature = WZArmature:create()
	armature:setArmatureName("teach003")
	--]]
	local anim = BattleAnimation:createAnimation("finger", false, "teach")

	local armature = anim.m_node
	armature:setUseOriginSize(true)
	armature:setScale(2.5)
    if isFlipX == false then
        armature:setScaleX(-2.5)
    else
    	armature:setRotation(0 - rotation)
    end
	armature:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	armature:setRelativePosition(GlobalMethod:ccp(0.5,0.5) )
	container:addChild(armature,0,5)
	if isClick then
		anim:play("click",true)
	end
	
	local offset = -0.35
    local moveX ,moveY, moveX1 ,moveY1 = 0.05 + offset, -0.25, 0.95 + offset, 0.75
    if isRight == true then
        local offsetX, offsetY = 0.0,0.0
        moveX ,moveY, moveX1 ,moveY1 = -0.25+offsetX, -0.45+offsetY, 0.75+offsetX, 0.55+offsetY
    end
	local moveTo = WZUIActionMoveTo:create()
	moveTo:setMoveX(moveX)
	moveTo:setMoveY(moveY)
	moveTo:setDuration(1)

	local delay = WZUIActionDelayTime:create()
	delay:setDuration(0.5)

	local moveTo1 = WZUIActionMoveTo:create()
	moveTo1:setMoveX(moveX1)
	moveTo1:setMoveY(moveY1)
	moveTo1:setDuration(0)

    local moveTo2 = WZUIActionMoveTo:create()
    moveTo2:setMoveX(moveX1)
    moveTo2:setMoveY(moveY1)
    moveTo2:setDuration(0)

    local actionFadeTo = WZUIActionFadeTo:create()
    actionFadeTo:setOpacity(255)
    actionFadeTo:setDuration(0)
    armature:setOpacity(0)

	local sequence = WZUIActionSequence:create()
    sequence:setChildAction(moveTo2)
    sequence:setChildAction(actionFadeTo)
	sequence:setChildAction(moveTo)
	sequence:setChildAction(delay)
	sequence:setChildAction(moveTo1)
	sequence:setIsLoop(true)

	armature:runUIAction(sequence)
	container:setVisible(true)
	return container, armature
end

--@brief	显示射击指引动画
--@param	parent,要加到的父节点
--@param	tPos,含x,y键值的表,表示显示的位置
--@param	rotation,离45度的偏差值
--@return	生成的动画控件
function TeachBattleCommon:showFinger(parent,tPos,rotation, zOrder, isFlipX, isRight, isClick, layerOrder)
    if zOrder == nil then
        zOrder = 0
    end
    if isFlipX == nil then
        isFlipX = false
    end

    if isFlipX == true and isRight == nil then
    	isRight = true
    end

    WZLog("TeachBattleCommon:showFinger one", parent, tPos.x, tPos.y, rotation, zOrder, tostring(isFlipX), tostring(isRight))
	local container = WZUIContainer:create()
	container:setAnchorPoint(GlobalMethod:ccp(1,1))
	container:setVisible(false)
	container:setTouchEnable(false)
	container:setUseAbsSize(true)
	container:setAbsContentSize(GlobalMethod:CCSize(300,300))
	container:setRotation(rotation)
	parent:addChild(container,layerOrder or 0,zOrder)
	container:setPosition(GlobalMethod:ccp(tPos.x,tPos.y))
	container:setScale(0.3/parent:getScaleY())

	local anim = BattleAnimation:createAnimation("finger", false, "teach")

	local armature = anim.m_node
	armature:setUseOriginSize(true)
	armature:setScale(2.5)
    if isFlipX == false then
        armature:setScaleX(-2.5)
    else
    	armature:setRotation(0 - rotation)
    end
	armature:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	armature:setRelativePosition(GlobalMethod:ccp(0.5,0.5) )
	container:addChild(armature,0,5)
	if isClick then
		anim:play("click",true)
	end
	
	container:setVisible(true)
	return container
end
