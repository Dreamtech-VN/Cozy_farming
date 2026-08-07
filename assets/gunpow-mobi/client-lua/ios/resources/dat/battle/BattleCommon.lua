--BattleCommon.lua
--@brief	战斗中使用到的一些基础方法
--@date  	2014/01/06
--@author 	TaoYinqing
--@note 	战斗中使用到的一些基础方法


BattleCommon = {}

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	计算点的斜率对应的弧度
--@param	tPoint 点 可以通过tPoint.x tPoint.y访问其x,y的值
--@return	#1,弧度
--@note		计算点的斜率对应的角度
function BattleCommon:pointToAngle(tPoint)
	return math.atan2(tPoint.y,tPoint.x)
end

--brief     计算弧度对应的斜率
--@param    fRadius 弧度
--@return   #1,向量
function BattleCommon:angleToPoint(fRadius)
    local pos = {}
    pos.x = math.cos(fRadius)
    pos.y = math.sin(fRadius)
    return pos
end

--@brief	弧度到角度的转换
--@param	fRadians 弧度值
--@return	#1,角度值
--@note		弧度到角度的转换
function BattleCommon:radiansToDegress(fRadians)
	return fRadians*180/math.pi
end

--@brief    角度转弧度
--@param    fDegress 角度值
--@return   #1,弧度值
function BattleCommon:degressToRadius(fDegress)
    return fDegress*math.pi/180
end

--@brief	两点距离
--@param	tPoint1，第一个点
--@param	tPoint2，第二个点
--@return	#1,距离值
--@note
function BattleCommon:pointDis(tPoint1,tPoint2)
    if tPoint1 == nil or tPoint2 == nil then
        return nil
    end
	return math.sqrt( (tPoint1.x - tPoint2.x) * (tPoint1.x - tPoint2.x ) + (tPoint1.y - tPoint2.y) * (tPoint1.y - tPoint2.y ) )
end

--@brief	向量长度
--@param	tPoint，向量
--@return	向量长度
--@note
function BattleCommon:pointLen(tPoint)
	return math.sqrt(tPoint.x * tPoint.x + tPoint.y * tPoint.y)
end




--@brief    计算点乘以一个常量
--@param    tPoint 点
--@param    fFactor 数值
--@return   #1, 乘后的结果
function BattleCommon:pointMult(tPoint,fFactor)
    return {x = tPoint.x*fFactor,y = tPoint.y * fFactor}
end


--@brief    求两个点相加的结果
--@param    tPoint1 点1
--@param    tPoint2 点2
--@return   #1, 两个点相加后的结果 
function  BattleCommon:pointAdd(tPoint1,tPoint2)
    return {x = tPoint1.x + tPoint2.x,y = tPoint1.y + tPoint2.y}
end

--@brief    求两个点相减的结果
--@param    tPoint1 点1
--@param    tPoint2 点2
--@return   #1, 两个点相减后的结果  
function BattleCommon:pointSub(tPoint1,tPoint2)
    return {x = tPoint1.x - tPoint2.x,y = tPoint1.y - tPoint2.y}
end


--@brief    求两个点的中间点
--@param    tPoint1 点1
--@param    tPoint2 点2
--@return   #1, 两个点的中间点 
function BattleCommon:midPoint(tPoint1,tPoint2)
    return {x = (tPoint1.x + tPoint2.x)/2,y = (tPoint1.y + tPoint2.y)/2}
end

--@brief    判断两个点是否相等
--@param    tPoint1 点1
--@param    tPoint2 点2
--@return   #1, true 两个点相等 false 两个点不相等 
function BattleCommon:pointEqual(tPoint1,tPoint2)
    if tPoint1.x == tPoint2.x and tPoint1.y == tPoint2.y then
        return true
    end
    return false
end


--@brief    判断两个圆是否相交
--@param    tCenter1 圆1的中心点
--@param    nRadius1 圆1的半径
--@param    tCenter2 圆2的中心点
--@param    nRadius2 圆2的半径
--@return   #1, true 相交 false 不相交
function BattleCommon:checkCircleCollosion(tCenter1,nRadius1,tCenter2,nRadius2)
    local dis = BattleCommon:pointDis(tCenter1,tCenter2)
    dis = dis - nRadius1 - nRadius2
    return dis <= 0
end

--@brief    拷贝一个点相关的x,y到新的点
--@param    tPos 要拷贝的点
--@return   #1, 返回一个新的点
function BattleCommon:pointCopy(tPos)
    return {x = tPos.x,y = tPos.y}
end

--@brief    获得点结构
--@param    x,y
--@return   #1, 返回一个新的点的tabe表
function BattleCommon:getPointTable(tx,ty)
    tx = tx or 0
    ty = ty or 0
    return {x = tx,y = ty}
end


--@brief    判断两个点是否相等
--@param    tPos1  点
--@param    tPos2  点
--@return   #1,true 相等 false 不想等
function BattleCommon:pointEqual(tPos1,tPos2)
    if tPos1 == nil or tPos2 == nil then
        return false
    end
    if tPos1.x == tPos2.x and tPos1.y == tPos2.y then
        return true
    end
    return false
end

--@brief    风力等级转风力加速度
--@param    tWindLevel:风力等级表
--@return   #1:风力加速度
function BattleCommon:windLevelToAcceleration(tWindLevel)
	return {x=tWindLevel.x*0.01*BattleConstants.g_nFlySpeed,y=tWindLevel.y*0.01* BattleConstants.g_nFlySpeed}
end

--@brief    Perform the dot product on two vectors.
--@param    v1 the first vector
--@param    v2 the second vector
--@return   #1, the result
function BattleCommon:vectorDot(v1,v2)
    return v1.x*v2.x + v1.y*v2.y
end

--@brief    Perform the cross product on two vectors. In 2D this produces a scalar.
--@param    v1 the first vector
--@param    v2 the second vector
--@return   #1, the result
function BattleCommon:vectorCross(v1,v2)
    return v1.x*v2.y - v2.x*v1.y
end

--@brief    获得与v1长度相等，夹角为fAngle的向量
--@param    v1:原向量
--@param    fAngle:夹角
--@return   #1, 转换后向量
function BattleCommon:vectorWithAngle(v1,fAngle)
    local radius = BattleCommon:pointToAngle(v1)
    radius = radius + BattleCommon:degressToRadius(fAngle)
    local vec = BattleCommon:angleToPoint(radius)
    return BattleCommon:pointMult(BattleCommon:angleToPoint(radius),BattleCommon:pointLen(v1))
end

--@brief    获得v1的单位向量
--@param    v1 向量
--@return   #1, 向量v1的长度
--@return   #2, v1的单位向量
function BattleCommon:vectorNormalize(v1)
    local length = BattleCommon:pointLen(v1)
    if length <= 0 then
        return length,v1
    end
    local v = {x = v1.x/length,y = v1.y/length}
    return length,v
end

--@brief    判断点是否在矩形上面
--@param    tPos 点坐标 {x = 0,y=0}
--@param    tRect 矩形信息{x = 0,y = 0,w = 1,h=1}
--@return   #1, true 相交 false 不相交
function BattleCommon:pointInRect(tPos,tRect)
    if tPos.x < tRect.x then
        return false
    end
    if tPos.x > tRect.x + tRect.w then
        return false
    end
    if tPos.y < tRect.y then
        return false
    end
    if tPos.y > tRect.y + tRect.h then
        return false
    end
    return true
end

--@brief    判断矩形和圆是否重叠
--@param    rect 矩形信息{x = 0,y = 0,w = 1,h=1}
--@param    circle 圆的信息 {x = 0,y=0,r = 1}
--@return   #1, true 相交 false 不相交
function BattleCommon:rectCircleOverLap(rect,circle)
    local rectCenter = {x = rect.x + rect.w*0.5 , y = rect.y + rect.h*0.5}
    local v = BattleCommon:pointSub(rectCenter,circle)
    local l = BattleCommon:pointLen(v)
    local width = rect.w    

    if width > rect.h then
        width = rect.h
    end
    
    if l < circle.r + width*0.5 then
       return true
    end
    
    if l > circle.r + rect.h + rect.w then
        return false
    end
    _ , v = BattleCommon:vectorNormalize(v)
    v = BattleCommon:pointMult(v,circle.r)
    v = BattleCommon:pointAdd(v,circle)
    return BattleCommon:pointInRect(v,rect)
end


--@brief    获得一个table里面又多少元素
--@param    tTable 表
--@return   #1,表种元素的个数
function BattleCommon:tableLen(tTable)
	if tTable == nil then return 0 end
    local len = 0
    for _,_ in pairs(tTable) do
        len = len + 1
    end
    return len
end

--@brief    判断一个点是否在椭圆内
--@param    tPos {x = 0, y = 0} 点的坐标
--@param    tEllipse {x = 0,y = 0,a = 1,b = 1} 椭圆信息
--@return   #1,true 在椭圆内部 false 在椭圆外部
function BattleCommon:isInEllipse(tPos,tEllipse)
    local value = math.pow(tEllipse.x - tPos.x,2)/math.pow(tEllipse.a,2) + math.pow(tEllipse.y - tPos.y,2)/math.pow(tEllipse.b,2)
    return value <= 1
end

--@brief    get start speed power with speed
--@param    tSpeedNormal 速度的单位向量
--@param    tStartPos 起始位置
--@param    tEndPos 结束位置
--@param    tAcceleration 加速度
--@return   #1, true 成功 false 失败
--@return   #2, power值
function BattleCommon:getStartSpeedPowerWithSpeed(tSpeedNormal,tStartPos,tEndPos,fPower, acceleration)
    --WZLog("BattleCommon:getStartSpeedPowerWithSpeed 1")
    local power = fPower
    local a = acceleration or {x=BattleConstants.g_nFlyGravity.x+WBattleGlobal:getCurrent():getWind().x, y=BattleConstants.g_nFlyGravity.y+WBattleGlobal:getCurrent():getWind().y}
    local reAcc = {x = -a.x,y = -a.y}
    local dis = {x = tEndPos.x - tStartPos.x,y = tEndPos.y - tStartPos.y}
    local disLen,disNormal = BattleCommon:vectorNormalize(dis)
    if disLen <= 0 then
        power = 0
        --WZLog("BattleCommon:getStartSpeedPowerWithSpeed 2", power)
        return true,power
    end
    local reAccLen,reAccNormal = BattleCommon:vectorNormalize(reAcc)
    --外部作用力向量为0 只考虑 开始向量 位置逆向量
    if reAccLen <= 0 then
        local dot = BattleCommon:vectorDot(tSpeedNormal,disNormal)
        --（点积求投影 cosa）两个非零向量 a 和b 平行，当且仅当a×b=0
        if dot <= 0 then
            power = 3.0
            --WZLog("BattleCommon:getStartSpeedPowerWithSpeed 3", power)
            return true,power
        else
            --WZLog("BattleCommon:getStartSpeedPowerWithSpeed 3.5", power)
            return false,power
        end
    end
    local E_S = BattleCommon:vectorCross(tSpeedNormal,disNormal)
    local E_A = BattleCommon:vectorCross(tSpeedNormal,reAccNormal)
    --叉积求法线（垂直于两个向量） sina 0-90 == 0-1
    --E_S == 0 出手向量垂直于 目标，重力，风力的合力向量
    -- 二维得出sinA

    -- if E_S == 0 or E_A == 0 then
    --     WZLog("BattleCommon:getStartSpeedPowerWithSpeed 3.7", power)
    --     return false,power
    -- end

    --E_A * E_S < 0 不同方向角度 可以连成抛物线
    if E_A*E_S < 0 then
        -- 由 竖直距离 h = gt^2/2 得出t^2 = 2h/g
        local dt = math.sqrt(2.0*(dis.y*tSpeedNormal.x - dis.x*tSpeedNormal.y)/(a.y*tSpeedNormal.x-a.x*tSpeedNormal.y))
        if dt <= 0 then
            --WZLog("BattleCommon:getStartSpeedPowerWithSpeed 3.9", power)
            return false,power
        end
        power = (dis.x-0.5*a.x*dt*dt)/(tSpeedNormal.x*dt)
        --WZLog("BattleCommon:getStartSpeedPowerWithSpeed 4", power)
        return true,power
    else
        --WZLog("BattleCommon:getStartSpeedPowerWithSpeed 4.5", power)
        return false,power
    end
    --WZLog("BattleCommon:getStartSpeedPowerWithSpeed 5", power)
    return true, power
end


function BattleCommon:getShootPos(isLeft,hero,offset)
    local anim = nil
    if hero == nil then
        hero = WBattleGlobal:getCurrent():getCurrentCharacter()
	    anim = WBattleGlobal:getCurrent():getCurrentCharacter():getAnimation()
    else
        anim = hero:getAnimation()
    end

    
	local animNode = anim:getAnimNode()
	local animPos = anim:getPosition()
	local point = CCAutoPoint:create(0,0)
    offset = offset or {x = 0, y = 0}

    isLeft = false          --FlipX didnt concern the left or right
    local height = anim:getAnimNode():getContentSize().height
    if height > 200 and offset.y == 0 then
        offset.y = height * 0.4
    end

    if hero.m_bIsMonster then
        offset.x = GDatatab_shape_skins["id_" .. hero.m_nMonsterId].gun_point[1][1]
        offset.y = GDatatab_shape_skins["id_" .. hero.m_nMonsterId].gun_point[1][2]
        WZLog("BattleCommon:getShootPos", offset.x, offset.y, tostring(hero.m_bIsMonster), hero.m_nMonsterId, offset.x, offset.y)
    end
    
	if isLeft then
		point.x = point.x - BattleMsgPlayerReadyShoot.SHOOT_X_OFFSET - offset.x
	else
		point.x = point.x + BattleMsgPlayerReadyShoot.SHOOT_X_OFFSET + offset.x
	end
	point.y = point.y + BattleMsgPlayerReadyShoot.SHOOT_Y_OFFSET + offset.y
	local toParentTranf=animNode:nodeToParentTransformAuto()
	point.x = point.x + animNode:getContentSize().width * animNode:getAnchorPoint().x
	point.y = point.y + animNode:getContentSize().height * animNode:getAnchorPoint().y
	point = CCPointApplyAffineTransformAuto(point,toParentTranf)
	return { x = point.x , y= point.y }
end

function BattleCommon:getMonsterShootPos(isLeft,hero,offset)
    local anim = nil
    if hero == nil then
       anim = WBattleGlobal:getCurrent():getCurrentCharacter():getAnimation()
    else
        anim = hero:getAnimation()
    end

    isLeft = false          --FlipX didnt concern the left or right
    local animNode = anim:getAnimNode()
    local animPos = anim:getPosition()
    local point = CCAutoPoint:create(0,0)
    offset = offset or {x = 0, y = 0}
    local height = anim:getAnimNode():getContentSize().height
    local width = anim:getAnimNode():getContentSize().width
    WZLog("BattleCommon:getMonsterShootPos", offset.x, offset.y)
    if isLeft then
        point.x = point.x - offset.x 
    else
        point.x = point.x + offset.x
    end
    point.y = point.y + offset.y
    local toParentTranf=animNode:nodeToParentTransformAuto()
    point.x = point.x + width * animNode:getAnchorPoint().x
    point.y = point.y + height * animNode:getAnchorPoint().y
    point = CCPointApplyAffineTransformAuto(point,toParentTranf)
    return { x = point.x , y= point.y }
end

function BattleCommon:intEncrypt(nVal)
	if nVal and type(nVal) == "number" then
		local aFactor = {15091,17011,20107}
		local bFactor = {63689,65599,378551}
		local cFactor = {8,10,4}
		
        local encrypt = 100
        if WBattleGlobal:getCurrent().m_tMakePairOk.battleId ~= nil then
            encrypt = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        end
		local nIdx = encrypt % 3 + 1
        --WZLog("BattleCommon:intEncrypt", WBattleGlobal:getCurrent().m_tMakePairOk.battleId)
		local res = bFactor[nIdx]
		while nVal and nVal > 0 do
			local val = nVal % cFactor[nIdx]
			res = (res * bFactor[nIdx] + val ) % aFactor[nIdx]
			nVal = (nVal - val)/cFactor[nIdx]
		end
		return res % aFactor[nIdx]
	end
	return nil
end

--@brief    设置数据作弊检测值
--@param    sKey key
--@param    nVal 数值
function BattleCommon:setDataCheck(sKey,nVal)
    if WBattleGlobal:getCurrent().m_tDataCheckList == nil then
        WBattleGlobal:getCurrent().m_tDataCheckList = {}
    end
    WBattleGlobal:getCurrent().m_tDataCheckList[sKey] = BattleCommon:intEncrypt(nVal)
end

--@brief    检测数据作弊
--@param    sKey key
--@param    nVal 数值
--@return   #1, true 作弊, false 没有作弊, nil 没记录
function BattleCommon:getDataCheck(sKey,nVal)
    if WBattleGlobal:getCurrent().m_tDataCheckList ~= nil and WBattleGlobal:getCurrent().m_tDataCheckList[sKey] ~= nil then
        return not (WBattleGlobal:getCurrent().m_tDataCheckList[sKey] == BattleCommon:intEncrypt(nVal))
    end
    
    return nil
end

--@brief    检查飞到目标点是否有障碍 并且返回障碍的坐标 这个只是初步的检查不一定十分的准确
--@param    tStartPos 起始位置
--@param    tEndPos   目标位置
--@param    tSpeed    起始速度
--@param    tAcceleration 加速度
--@param    uByteData 物理检测数据
--@param    nCollisionType 碰撞类型
--@param    isCheckEndPos 教学用
--@return   #1 true 有障碍物 false 没有障碍物
--@return   #2  障碍物的坐标
function BattleCommon:checkHasCollision(tStartPos,tEndPos, tSpeed, tAcceleration,uByteData,nCollisionType, isCheckEndPos)
    --ccArray = self.m_pixelByte:checkCollision(mover,isNormal)
    local mover = WDMover:create()
    mover:setMoverPosition(Vector2:create(tStartPos.x,tStartPos.y))
    mover:setMoverSpeed(Vector2:create(tSpeed.x,tSpeed.y))
    mover:setMoverAcceleration(Vector2:create(tAcceleration.x,tAcceleration.y))
    mover:setMoverCollisionType(nCollisionType)

    if nCollisionType == BattleConstants.g_nE_COLLISION_CIRCLE then
        mover:setMoverRadius(18)
    end

    --[[
    if WBattleGlobal:getCurrent().m_tcheckHasCollisionLine ~= nil then
        SceneBattle:getFrontLayer():removeChild(WBattleGlobal:getCurrent().m_tcheckHasCollisionLine.m_uBatchNode, true)
        WBattleGlobal:getCurrent().m_tcheckHasCollisionLine = nil
    end

    local line = {}
    line.m_uBatchNode = CCSpriteBatchNode:create("battle/hud/hud_point_1.png")
    --]]

    local count = 50
    if isCheckEndPos then
        count = 30
    end
    for i = 0,count,1 do
        mover:updatePostion()
        --[[
        local px,py = mover:getMoverPosition().x, mover:getMoverPosition().y
        local ccs = CCSprite:createWithTexture(line.m_uBatchNode:getTexture())
        ccs:setPosition(px, py)
        line.m_uBatchNode:addChild(ccs)
        --]]

        local ccArray = uByteData:checkCollision(mover,false)
        local isCollision = tolua.cast( ccArray:objectAtIndex(0) ,"CCBool"):getValue()

        if isCheckEndPos then
            local p = {x=mover:getMoverPosition():getX(),y=mover:getMoverPosition():getY()}
            local isHeroCollision,charaList = BattleCommon:checkCharacterCollision(p, {{isCheckEndPos}})
            if isHeroCollision then
                return true, p, p
            end
        end

        if isCollision == true then
            --[[
            SceneBattle:getFrontLayer():addChild(line.m_uBatchNode)
            WBattleGlobal:getCurrent().m_tcheckHasCollisionLine = line
            --]]
            local newPos = tolua.cast( ccArray:objectAtIndex(1) ,"Vector2")
            return true,{x = newPos:getX(),y = newPos:getY()},{x = newPos:getX(),y = newPos:getY()}
        end
    end
    --[[
    SceneBattle:getFrontLayer():addChild(line.m_uBatchNode)
    WBattleGlobal:getCurrent().m_tcheckHasCollisionLine = line
    --]]
    return false,{x = 0, y = 0 },{x=mover:getMoverPosition():getX(),y=mover:getMoverPosition():getY()}
end

--@brief    检测人物碰撞
--@return   #1:true:撞了,false:没撞
--@return   #2:碰撞的人物列表
function BattleCommon:checkCharacterCollision(curPos, collisionCharacters)
    --WZLog("WBullet:checkHeroCollision")
    --local curPos = self:getMover():getMoverPosition()
    local posList = {}
    local prePos = nil
    if curPos then
        prePos =  {x = curPos.x,y = curPos.y}
        --起点不可能为0
        if prePos.x == 0 or prePos.y == 0 then
            prePos = nil
        end
    end
    
    while prePos and math.abs(curPos.x - prePos.x) > 30 do
        local dir = 1
        if curPos.x < prePos.x then
            dir = -1
        end
        local tx = prePos.x + 30*dir
        local ty = prePos.y + math.abs(30/(curPos.x - prePos.x))*(curPos.y - prePos.y)
        local midPos = Vector2:create(tx,ty)
        table.insert(posList,midPos)

        prePos = {x = tx, y = ty}
    end
    table.insert(posList,curPos)

    local tmpCharas = {}
    local isCollision = false
    for k,checkPos in ipairs(posList) do
        for i,charaList in ipairs(collisionCharacters) do

            local isCollisionInList,collisionCharas,isReflect = BattleCommon:checkCollisionWithCharacterList(checkPos,4,charaList)
            WZLog("BattleCommon:checkCollision three", tostring(isReflect))

            if not isCollision then
                isCollision = isCollisionInList
            end

            AddTableToTable(tmpCharas,collisionCharas)
        end

        if isCollision then
           return isCollision,tmpCharas
        end
    end
    return false,{}
end

--@brief    检查人物碰撞
--@param    pos:子弹位置
--@param    raduis:子弹半径
--@param    charaList:人物列表
--@return   #1:true:撞了,false:没撞
--@return   #2:碰撞的人物列表
function BattleCommon:checkCollisionWithCharacterList(pos,raduis,charaList)
    local tmpCharas = {}
    local isCollision = false
    local isReflect = false
    for id,chara in ipairs(charaList) do
        WZLog("BattleCommon:checkCollisionWithCharacterList one", id, tostring(chara:isDead()))
        if not chara:isDead() and not chara.m_bOffCollision then
            if true--[[chara:getBattleId() ~= self:getOwnerChara():getBattleId()]] then
                local charaPos = chara:getCenterPos()
                local charaRaidus = chara:getRadiusForBulletCollision()
                local collisionRang = chara:getCollisionRang()
                if chara:getType() == 1 and collisionRang ~= nil and not chara.m_bIsGuaiWithSuit then
                    charaPos = chara:getPosition()
                end

                WZLog("BattleCommon:checkCollisionWithCharacterList two", id, chara:getBattleId(), tostring(chara:isDead()), charaPos.x, charaPos.y, charaRaidus)
                local _isCollision = BattleCommon:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang,true)

                if _isCollision then
                    WZLog("BattleCommon:checkCollisionWithCharacterList four", isNoHole)
                    tmpCharas[chara:getBattleId()] = chara
                    isCollision = true
                end
            end
        end
    end
    return isCollision,tmpCharas,isReflect
end

--@brief    检查区域碰撞
--@param    rang:区域
--@param    isOnlyCheck:只检查圆与矩形相交
--@return   #1:true:撞了,false:没撞
function BattleCommon:checkCollisionWithRang(pos,raduis,charaPos,charaRaidus,collisionRang,isOnlyCheck)
    local dis = nil
    if collisionRang ~= nil then
        for i,rang in pairs(collisionRang) do
            if rang.m_nType == 0 then
                -- local tmpCharaPos = Vector2:create(charaPos.x + rang.m_fXOffset,charaPos.y + rang.m_fYOffset)
                local isColl = BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus)
                WZLog("BattleCommon:checkCollisionWithRang one", i, tostring(isColl), pos.x, pos.y, charaPos.x, charaPos.y, raduis, charaRaidus)
                if isColl then
                    return true, dis
                end
            elseif rang.m_nType == 1 then
                local rect = {x = charaPos.x+rang.m_fXOffset - rang.m_fWidth*0.5,y = charaPos.y+rang.m_fYOffset,w = rang.m_fWidth,h=rang.m_fHeight}
                local circle = {x = pos.x,y=pos.y,r = raduis}
                local curdis = BattleCommon:distanceWithCircleAndRect(circle,rect)
                dis = 9999
                dis = math.min(curdis, dis)
                WZLog("BattleCommon:checkCollisionWithRang two", i, curdis, dis,raduis)
                if isOnlyCheck then
                    if BattleCommon:rectCircleOverLap(rect,circle) then
                        return true ,dis
                    end
                else
                    if dis <= raduis then
                       return true, dis
                    end
                end
            end
        end
    else
        local isColl = BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus)
        WZLog("BattleCommon:checkCollisionWithRang three", tostring(isColl), dis)
        return isColl, dis
    end

    WZLog("BattleCommon:checkCollisionWithRang four")
    return false, dis
end

--@计算圆与矩形的距离
--@ 矩形四边区域 绝对值
--@ 矩形四角位置，点与角点距离
function BattleCommon:distanceWithCircleAndRect(circle, rect)
    local dis = 0
    local x=circle.x
    local y=circle.y
    local x1=rect.x
    local x2=rect.x+rect.w
    local y1=rect.y
    local y2=rect.y+rect.h

    if x>=x1 and x<=x2 and y>=y1 and y<=y2 then
        dis = 0
    elseif x>=x1 and x<=x2 and y>=y2 then
        dis = y-y2
    elseif x>=x1 and x<=x2 and y<=y1 then
        dis = y1-y
    elseif y>=y1 and y<=y2 and x<=x1 then
        dis = x1-x
    elseif y>=y1 and y<=y2 and x>=x2 then
        dis = x-x2
    elseif x<=x1 and y>=y2 then
        dis = BattleCommon:pointDis({x = x,y = y},{x = x1, y = y2})-- math.min(x1-x,y-y2)
    elseif x<=x1 and y<=y1 then
        dis = BattleCommon:pointDis({x = x,y = y},{x = x1, y = y1})-- math.min(x1-x,y1-y)
    elseif x>=x2 and y>=y2 then
        dis = BattleCommon:pointDis({x = x,y = y},{x = x2, y = y2})-- math.min(x-x2,y-y2)
    elseif x>=x2 and y<=y1 then
        dis = BattleCommon:pointDis({x = x,y = y},{x = x2, y = y1})-- math.min(x-x2,y1-y)
    end
    WZLog("BattleCommon:distanceWithCircleAndRect",dis,x,y,x1,x2,y1,y2)
    return dis
end

--@breif    检查移动是否可以到达目标点
--@param    tStartPos    初始位置
--@param    nCount       移动次数
--@param    tSpeed       移动加速度
--@param    tGravity     重力加速度
--@param    uByteData    物理碰撞层
--@return   #1 是否可以移动
--@return   #2 目标位置
function BattleCommon:checkMoveCollision(tStartPos,nCount,tSpeed,tGravity,uByteData)
    if nCount <= 0 then
        return true,tStartPos
    end
    local mover = WDMover:create()
    mover:setMoverPosition(Vector2:create(tStartPos.x,tStartPos.y))
    mover:setMoverSpeed(Vector2:create(0,0))
    --mover:setMoverAcceleration(Vector2:create(tAcceleration.x,tAcceleration.y))
    mover:setMoverCollisionType(BattleConstants.g_nE_COLLISION_POINT)
    local dir = tSpeed.x > 0 and 0 or 1
    local isCollision = false
    for i = 0,nCount do
        mover:setMoverAcceleration(Vector2:create(tSpeed.x+tGravity.x,tSpeed.y+tGravity.y))
        mover:updatePostion()
        --是否碰墙
        local inWall = true
        if uByteData.isEmptyPixel == nil or (uByteData:isEmptyPixel(mover:getMoverPosition():getX() - 50 * dir,mover:getMoverPosition():getY() + 50,50,50,5)) then
            inWall = false
        end
        if inWall then
            return false,tStartPos
        end

        local ccArray = uByteData:checkCollision(mover,false)
        isCollision = tolua.cast( ccArray:objectAtIndex(0) ,"CCBool"):getValue()

        if isCollision == true then
            local tangent = tolua.cast( ccArray:objectAtIndex(2) ,"Vector2")
            local newPos = tolua.cast( ccArray:objectAtIndex(1) ,"Vector2")
            mover:setMoverPosition(newPos)
            mover:setMoverPrePosition(newPos)
            mover:setMoverSpeed(Vector2:create(0,0))
            local angle = BattleCommon:pointToAngle({x = tangent:getX(),y = tangent:getY()})
            mover:setMoverRotate(angle)
        end
        mover:setMoverSpeed(Vector2:create(0,mover:getMoverSpeed().y))
    end

    local endPos = {x=mover:getMoverPosition():getX(),y=mover:getMoverPosition():getY()}
    if isCollision == true then
        return true,endPos
    end
    for i = 0,10 do
        mover:setMoverAcceleration(Vector2:create(tGravity.x,tGravity.y))
        mover:updatePostion()
        local ccArray = uByteData:checkCollision(mover,false)
        isCollision = tolua.cast( ccArray:objectAtIndex(0) ,"CCBool"):getValue()
        if isCollision == true then
            local tangent = tolua.cast( ccArray:objectAtIndex(2) ,"Vector2")
            local newPos = tolua.cast( ccArray:objectAtIndex(1) ,"Vector2")
            mover:setMoverPosition(newPos)
            mover:setMoverPrePosition(newPos)
            mover:setMoverSpeed(Vector2:create(0,0))
            local angle = BattleCommon:pointToAngle({x = tangent:getX(),y = tangent:getY()})
            mover:setMoverRotate(angle)
        end
        mover:setMoverSpeed(Vector2:create(0,mover:getMoverSpeed().y))
    end
    return isCollision,endPos
end

--@breif    检查直线射击
--@param    tStartPos    初始位置
--@param    nCount       移动次数
--@param    uByteData    物理碰撞层
--@return   #1 有障碍
function BattleCommon:checkShootLineCollision(tStartPos,tEndPos,uByteData)
    local nCount = math.floor(BattleCommon:pointDis(tStartPos,tEndPos) / 50)
    local mover = WDMover:create()
    mover:setMoverCollisionType(BattleConstants.g_nE_COLLISION_CIRCLE)
    mover:setMoverRadius(18)
    local pos = tStartPos
    local dx = (tEndPos.x - tStartPos.x)/nCount
    local dy = (tEndPos.y - tStartPos.y)/nCount
    --WZLog("BattleCommon:checkShootLineCollision",tStartPos.x,tStartPos.y,tEndPos.x,tEndPos.y)
    local isCollision = false
    for i = 1,nCount do
        mover:setMoverPosition(Vector2:create(pos.x,pos.y))
        mover:updatePostion()
        local ccArray = uByteData:checkCollision(mover,false)
        isCollision = tolua.cast( ccArray:objectAtIndex(0) ,"CCBool"):getValue()
        --WZLog("BattleCommon:checkShootLineCollision",nCount,isCollision)
        if isCollision == true then
        --WZLog("BattleCommon:checkShootLineCollision II",mover:getMoverPosition().x,mover:getMoverPosition().y)
           return true
        end

        pos.x = pos.x + dx
        pos.y = pos.y + dy
    end
    return false
end

--@brief 点碰撞
function BattleCommon:checkPosCollision(pos,uByteData)
    local mover = WDMover:create()
    mover:setMoverCollisionType(BattleConstants.g_nE_COLLISION_CIRCLE)
    mover:setMoverRadius(1)
    mover:setMoverPosition(Vector2:create(pos.x,pos.y))
    mover:updatePostion()
    local ccArray = uByteData:checkCollision(mover,false)
    isCollision = tolua.cast( ccArray:objectAtIndex(0) ,"CCBool"):getValue()
    --WZLog("BattleCommon:checkShootLineCollision",nCount,isCollision)
    if isCollision == true then
    --WZLog("BattleCommon:checkShootLineCollision II",mover:getMoverPosition().x,mover:getMoverPosition().y)
       return true
    end
       
    return false
end

--@brief    精确到几位小数取值
--@param    nDigit 小数位数
--@param    nValue 数值
function BattleCommon:reserveDecimal(nDigit,nValue)
    local result = 0
    result = tonumber(string.format("%."..nDigit.."f", nValue))

    return result
end

--@brief    四舍五入
function BattleCommon:round(number)
    --do return number end
    local floor = math.floor(number)
    local ceil = math.ceil(number)

    return ceil - number < number - floor and ceil or floor
end

--@brief	反射向量
function BattleCommon:reflectVector(charaPos,bulletPos,bulletSpeed)

    local bulletSpeedLength,i = BattleCommon:vectorNormalize(bulletSpeed)
    local _,n = BattleCommon:vectorNormalize(BattleCommon:getPointTable(bulletPos.x-charaPos.x, bulletPos.y-charaPos.y))

    local r = BattleCommon:pointSub(bulletSpeed, BattleCommon:pointMult(n,2*BattleCommon:vectorDot(bulletSpeed,n)))

    WZLog("BattleCommon:reflectVector = ",r.x,r.y," ,bulletSpeed = ",bulletSpeed.x,bulletSpeed.y, " ,charaPos = ", charaPos.x,charaPos.y," ,bulletPos = ",bulletPos.x,bulletPos.y, " ,bulletSpeedLength = ",bulletSpeedLength)
    return r
end

--@brief   读取武器的爆破范围
--@param   nWeaponId 武器id
--@return  #1 爆破范围的宽度  #2爆破范围的高度
function BattleCommon:readWeaponExplodeScale(nWeaponId)
    if nWeaponId == nil then return nil,nil end
    local xmlDoc = WZDataFile:getInstance():createXmlDocument("ddd_bw.data")
    if xmlDoc then
        local rootElement = xmlDoc:getRootElement()
        local xmlName = "item"
        local element = rootElement:findChildElement(xmlName)
        while element do
            local id = element:attributeString("id")
            local explodeScaleWidth = element:attributeString("explodeScaleWidth")
            local explodeScaleHeight = element:attributeString("explodeScaleHeight")
            if tonumber(id) == tonumber(nWeaponId) then
                --WZLog("BattleCommon:readWeaponExplodeScale",explodeScaleWidth,explodeScaleHeight)
                return tonumber(explodeScaleWidth),tonumber(explodeScaleHeight)
            end
            element = element:nextSiblingElement(xmlName)
        end
    end
    local sWeaponId = "id_" .. nWeaponId
    if GDatatab_item[sWeaponId] then 
        local scaleInfo = GDatatab_item[sWeaponId].explodeScale
        if scaleInfo and scaleInfo ~= -1 then
            return scaleInfo[1][1],scaleInfo[1][2]
        end
    end
    return nil,nil
end

--@brief   是否nan
function BattleCommon:isnan(x) 
    if (x ~= x) then
        --print(string.format("NaN: %s ~= %s", x, x));
        return true; --only NaNs will have the property of not being equal to themselves
    end;

    --but not all NaN's will have the property of not being equal to themselves

    --only a number can not be a number
    if type(x) ~= "number" then
       return false; 
    end;

    --fails in cultures other than en-US, and sometimes fails in enUS depending on the compiler
--  if tostring(x) == "-1.#IND" then

    --Slower, but works around the three above bugs in LUA
    if tostring(x) == tostring((-1)^0.5) then
        --print("NaN: x = sqrt(-1)");
        return true; 
    end;

    --i really can't help you anymore. 
    --You're just going to have to live with the exception

    return false;
end

--brief     浮点数转整数再转浮点数(因lua的number为8位,c++的float为4位而要转换)
function BattleCommon:float2int2float(float0)
    local int0 = BattleUtil:float2int(float0)
    local float1 = BattleUtil:int2float(int0)
    return float0
end