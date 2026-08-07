--CopperCopyData.lua
--@brief    金币副本
--@date     2015/06/30
--@note     金币副本显示信息与胜利条件控制

CopperCopyData = {}

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function CopperCopyData:new()
    setmetatable(CopperCopyData,{__index = BaseCopyData})
    local tNewObj = {}
    setmetatable(tNewObj, { __index = CopperCopyData })
    tNewObj:_init()
    tNewObj.m_nRoundNum = 0
    tNewObj.m_tRoundNumLab = nil
    tNewObj.m_nKillNum = 0       --杀死怪物数量
    tNewObj.m_tKillNumLab = nil
    tNewObj.m_monsterTable = {} --怪物链表
    tNewObj.m_tBornPos = BattleMapManager.m_tPositions  --宝箱怪出生点
    tNewObj.m_nMaxRound = #tNewObj.m_tBornPos
    tNewObj.m_nMaxMonster = #tNewObj.m_tBornPos

    tNewObj.m_fightData = {fightData = {}}
    tNewObj.m_fightData.mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    tNewObj.m_fightData.fightId = 1
    
    return tNewObj
end

--@brief 销毁
function CopperCopyData:destroy()
    WZLog("CopperCopyData:destroy")
    if self.m_viewNode and self.m_viewNode:getParent() then
        self.m_viewNode:removeFromParentAndCleanup(true)
    end
    self.m_viewNode = nil
    self.m_tRoundNumLab = nil  
    self.m_nKillNum = nil 
    self.m_tKillNumLab = nil      
    self.m_fightData = nil
    self.m_monsterTable = nil
    self.m_tBornPos = nil
end

--@brief 创建显示信息
--@return 显示面板
function CopperCopyData:getInfoView()
    WZLog("CopperCopyData:getInfoView")
    if not self.m_viewNode then
        self.m_viewNode = WndCopperInfoView:createElement()

        self.m_viewNode:setRelativePositionLuaTo(0.1,0.88)

        self.m_tKillNumLab = GetElement(self.m_viewNode, "chestNum_WndCopperInfoView", WZUILabelTTF)

        self.m_tRoundNumLab = GetElement(self.m_viewNode, "roundNum_WndCopperInfoView", WZUILabelTTF)
    end

    self:_updateKillLabel()
    self:_updateRoundLabel()

    return self.m_viewNode
end


--@brief 杀死怪物
function CopperCopyData:killMonster(monsterId,battleId,pos)
    for i,v in pairs(self.m_monsterTable) do
        if v == battleId then
            self.m_monsterTable[i] = nil
        end
    end

    self.m_nKillNum = self.m_nKillNum + 1
    self:_updateKillLabel()
    self:recordKill()

    --DelayCallFunction(self.createKillMonsterEffect, self,2,pos)
end

--@brief 杀怪纪录
function CopperCopyData:recordKill()
    --self.m_fightData.fightData.allInfo = self.m_fightData.fightData.allInfo + 1
    table.insert(self.m_fightData.fightData,WBattleGlobal:getCurrent():getTurnTimes())
end

--@breif 创建杀怪特效
function CopperCopyData:createKillMonsterEffect(pos)
    pos = pos or BattleCommon:getPointTable(0,0)
    local element = WZUISystem:getInstance():createElement(string.format("conHurtType%d_HurtNumber",0))
    element:setLuaObjectIndex(self)
    if element ~= nil then
        GetElement(element,"txtHurtValue_HurtNumber",WZUILabelAtlasFont):setText("copper+100")
        local conHurt = WZUIContainer:luaTo(element)
        conHurt:setAbsPosition(GlobalMethod:ccp(pos.x - 100,pos.y + 120))
        SceneBattle:getFrontLayer():addChild(conHurt,6)
    end
end

--@brief    伤害数字显示完成的回调
function CopperCopyData:_finishFlyingNum(element)
    element:removeFromParentAndCleanup(true)
end

function CopperCopyData:_updateRoundLabel()
    local roundStr = tostring(self.m_nMaxRound - self.m_nRoundNum).."/"..tostring(self.m_nMaxRound)
    self.m_tRoundNumLab:setText(roundStr)
end

function CopperCopyData:_updateKillLabel()
    local killStr = tostring(self.m_nKillNum).."/"..tostring(self.m_nMaxMonster)
    self.m_tKillNumLab:setText(killStr)
end

--@brief 回合开始前准备
function CopperCopyData:readyStartRound()
    self.m_nRoundNum = self.m_nRoundNum + 1
    if self:checkIsEnd() ~= 0 then
        MsgManager:clear()
        self:copyEnd()
        return
    end

    local random = self:getMonsterBornIndex()
    if self.m_monsterTable[random] then
        return
    end
    local bornPos = BattleCommon:getPointTable(self.m_tBornPos[random].nPosX,self.m_tBornPos[random].nPosY)
    local battleId = self:getBuildGuaiIndex()
    self:addBuildGuaiIndex()
    local guaiTable = WMonster
    monster = (guaiTable and guaiTable:buildGuai(1001,1,false,battleId)) or nil
    if monster then
        monster:setPosition(bornPos)
        WBattleGlobal:getCurrent().m_tGuais[battleId] = monster
        SceneBattle:getFrontLayer():addChild(monster:getAnimation():getAnimNode())
        if monster:getMover() then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(monster:getMover())
        end

        monster:setAppearAttribute()
        monster:getAnimation():play(monster:getAnimationName("standby"), true)

        --if battleId > 0 then
            --BattleCtbManager:addCellBattleCtb(battleId)
        --end
        self:zoomTo(monster)

        self.m_monsterTable[random] = monster:getBattleId()
        monster.m_bIsInCtb = false
    end

    self:zoomTo(WBattleGlobal:getCurrent():getMyHero(),true)

end

--@brief 获得可以生成怪物的下标
function CopperCopyData:getMonsterBornIndex()
    local random = math.random(1, #self.m_tBornPos)
    if self.m_monsterTable[random] then
        local tmpIndex = nil
        
        for i = random + 1 ,#self.m_tBornPos do
            if not self.m_monsterTable[i] and not self:isNearHero(i) then
                tmpIndex = i
                break
            end
        end

        if not tmpIndex then
            for i = 1 ,random - 1 do
                if not self.m_monsterTable[i] and self:isNearHero(i)then
                    tmpIndex = i
                    break
                end
            end
        end

        if tmpIndex then
            random = tmpIndex
        end
    end
    --WZLog("CopperCopyData:getMonsterBornIndex",random)
    return random
end

--@brief 在人物附近 错误出生点
function CopperCopyData:isNearHero(index)
    local pos = WBattleGlobal:getCurrent():getMyHero():getPosition()
    local bornPos = GlobalMethod:ccp(self.m_tBornPos[index].nPosX,self.m_tBornPos[index].nPosY)
    --WZLog("CopperCopyData:isNearHero",index,BattleCommon:pointDis(bornPos, pos))
    if BattleCommon:pointDis(bornPos, pos) < 200 then
        return true
    end
    return false
end

--@brief 新回合开始
function CopperCopyData:updateByTurn()
    --WZLog("CopperCopyData:updateByTurn",WBattleGlobal:getCurrent():getTurnTimes())
    if self:checkIsEnd() ~= 0 then
        return
    end

    self:_updateRoundLabel()
   
end

--@brief 结束条件判断
--@return 1 胜利 2 失败
function CopperCopyData:checkIsEnd()
    if self.m_nRoundNum > self.m_nMaxRound then
        return 1
    elseif WBattleGlobal:getCurrent():checkIsHeroDead() then
        return 2
    end
    return 0
end

--@brief 副本结束处理
function CopperCopyData:copyEnd()
    --已经处理过
    if self.m_bIsEnd then
        return
    end

    self.m_fightData.isWin = self:checkIsEnd() == 1 and true or false
    --WZLog("CopperCopyData:copyEnd",Serialize(self.m_fightData))
    WndDailyCopySettlement:showWindow(self.m_fightData)
    BaseCopyData.copyEnd(self)
    WBattleGlobal:getCurrent():setGameOver(true)
end