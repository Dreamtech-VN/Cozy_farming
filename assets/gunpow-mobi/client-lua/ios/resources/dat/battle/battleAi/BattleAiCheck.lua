--BattleAiCheck.lua
--@brief    战斗ai计算
--@date     2015/10/24
--@brief    消息数据表
BattleAiCheck = {
}

function BattleAiCheck:adjustAngle(shootPos,endPos, isCheck)
    --WZLog("BattleAiCheck:adjustAngle zero",shootPos.x,shootPos.y,endPos.x,endPos.y)
    if not shootPos or not endPos then
        return false,BattleCommon:angleToPoint(BattleCommon:degressToRadius(45))
    end

    local sPos = shootPos
    local ePos = endPos
    local angle
    local angleOffset = 5
    local face
    local isAtkSucceed = false
    local acceleration = BattleCommon:pointAdd(BattleConstants.g_nFlyGravity,WBattleGlobal:getCurrent():getWind())
    --风力影响出手角度
    -- local reverseWind = WBattleGlobal:getCurrent():getWind()
    -- reverseWind = {x = -reverseWind.x,y = -reverseWind.y}
    if ePos.x <= sPos.x then
        face = 1
        angle = -45 -90;
        angleOffset = -5
    else
        face = 0
        angle = -45;
    end
    local resultSpeed = nil
    local tmpResultSpeed = nil
    --8 到85 13 到90
    for i=1,13 do
        if i > 8 then
            angle = angle - angleOffset/5
        else
            angle = angle - angleOffset
        end
        --WZLog("BattleAiCheck:adjustAngle one", i,angle,BattleCommon:degressToRadius(-angle))
        local power= (self:getCurRandNum(i) % 4 + 1) * 0.9;
        local speed = BattleCommon:angleToPoint(BattleCommon:degressToRadius(-angle))
        --风力影响出手角度
        -- speed = BattleCommon:pointAdd(speed,reverseWind)
        -- _, speed = BattleCommon:vectorNormalize(speed)
        isAtkSucceed, power = BattleCommon:getStartSpeedPowerWithSpeed(speed, sPos, ePos, power)
        --无法连成抛物线轨迹
        if not resultSpeed and isAtkSucceed then
            resultSpeed = {x=speed.x * power, y=speed.y * power}
        end
        --WZLog("BattleAiCheck:adjustAngle isAtkSucceed two ", i,isAtkSucceed)
        -- --WZLog("BattleAiCheck:adjustAngle two", "i="..i, "sPos.x="..sPos.x, "sPos.y="..sPos.y, "\nePos.x="..ePos.x, "ePos.y="..ePos.y)
        -- --WZLog("BattleAiCheck:adjustAngle three", "i="..i, "speed.x="..speed.x, "speed.y="..speed.y, "\nangle="..angle, "power="..power)
        if isAtkSucceed == true then
            speed.x = speed.x * power
            speed.y = speed.y * power

            local hasCollision, posCollision, posEnd = BattleCommon:checkHasCollision(sPos, ePos, speed, acceleration, BattleMapManager.m_pixelByte, BattleConstants.g_nE_COLLISION_CIRCLE)
            --WZLog("BattleAiCheck:adjustAngle three", i, "hasCol=".. tostring(hasCollision), "posCol.x="..posCollision.x, "posCol.y="..posCollision.y, "posEnd.x="..posEnd.x, "posEnd.y="..posEnd.y, "speed.x="..speed.x, "speed.y="..speed.y)
            if hasCollision ~= true or (hasCollision == true and ((math.abs(posCollision.y - ePos.y) < 35) and (sPos.x >= ePos.x and posCollision.x < ePos.x + 35) or (sPos.x < ePos.x and posCollision.x > ePos.x - 35))) then
                -- --WZLog("BattleAiCheck:adjustAngle five1")
                resultSpeed = { x=speed.x * 1, y=speed.y * 1}
                isAtkSucceed = true
                
                -- 90度垂直
                if i == 13 then
                    resultSpeed = {x = 0,y = 30}
                end

                if isCheck and i == 13 then
                    isAtkSucceed = false
                end
                
                break
            else
                -- --WZLog("BattleAiCheck:adjustAngle five2")
                if resultSpeed == nil then
                    resultSpeed = { x=speed.x * 1, y=speed.y * 1}
                end
                isAtkSucceed = false
            end
        end

        if not tmpResultSpeed then
            tmpResultSpeed = { x=speed.x * 1, y=speed.y * 1}
        end
    end

    if not resultSpeed then
        resultSpeed = tmpResultSpeed
    end
    --WZLog("BattleAiCheck:adjustAngle four", tostring(isAtkSucceed),"\n",resultSpeed.x,resultSpeed.y)
    return isAtkSucceed,resultSpeed
end

--@brief    获取当前随机数
function BattleAiCheck:getCurRandNum(offset)
    if offset == nil then
        offset = WBattleGlobal:getCurrent():getTurnTimes()
    end
    local randNumList = WBattleGlobal:getCurrent().m_tBattleRand
    local randNumIndex = offset % 10 + 1
    local curRandNum = randNumList[randNumIndex]

    return curRandNum
end

--@brief 获取飞行固定点
function BattleAiCheck:getFlyTargetPosList()
    local list = {}
    table.insert(list,BattleCommon:getPointTable(450,1050))
    table.insert(list,BattleCommon:getPointTable(1350,1050))
    table.insert(list,BattleCommon:getPointTable(900,700))
    table.insert(list,BattleCommon:getPointTable(450,350))
    table.insert(list,BattleCommon:getPointTable(1350,350))
    return list
end

