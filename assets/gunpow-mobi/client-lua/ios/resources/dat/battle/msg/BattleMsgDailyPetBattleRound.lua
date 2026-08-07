--BattleMsgDailyPetBattleRound.lua
--@brief    副本7逻辑
--@date     2016/10/26
--@note     

--@brief    消息数据表
BattleMsgDailyPetBattleRound = {
    m_sName = "BattleMsgDailyPetBattleRound",
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgDailyPetBattleRound:init()
    WZLog("BattleMsgDailyPetBattleRound:init")

    if WBattleGlobal:getCurrent():getCurrentCharacter():getType() == 0 then
        WBattleGlobal:getCurrent():buildBossTreasure(self:getTreasureList(),{x = 300,y = 1700,w = 1700,h = 1200})
    end
   
    self.m_tStepList = {}
    self:initStep()
end

function BattleMsgDailyPetBattleRound:updateSkillCtb()
    WndBattleHud:reset(WndBattleHud.m_tMyHero:getId())
end

function BattleMsgDailyPetBattleRound:initStep()
    -- table.insert(self.m_tStepList,{self.cameraMove})
    -- table.insert(self.m_tStepList,{self.delay})
end

function BattleMsgDailyPetBattleRound:getTreasureList()
    local totalIdList = {20001,20002,20003}
    local weightList = {}
    local idList = {}
    local totalWeight = 0
    for i = 1,#totalIdList do
        local treasureId = totalIdList[i]
        local config = GDatatab_boss_props["id_"..treasureId] or GDatatab_boss_props["id_1"]
        table.insert(weightList,config.weight)
        totalWeight = totalWeight + config.weight
    end

    for i = 1, 50 do
        local weight = math.random(totalWeight)
        WZLog("BattleMsgDailyPetBattleRound:getTreasureList",weight)
        local index = 1
        for k = 1,#weightList do
            if weight < weightList[k] then
                index = k
            end 
        end
        table.insert(idList,totalIdList[index])
    end

    -- local randomIndex = 1
    -- local removeIndex = 1
    -- while #totalIdList > 4 do
    --     local randomWeight = (WBattleGlobal:getCurrent():getCurRandNum(randomIndex) % 10 + 1)/10 * totalWeight
    --     local curWeight = 0
    --     local insertId = 1
    --     for i = 1,#weightList do
    --         curWeight = curWeight + weightList[i]
    --         if curWeight >= randomWeight then
    --             removeIndex = i
    --             totalWeight = totalWeight - weightList[i]
    --             insertId = totalIdList[i]
    --             break
    --         end
    --     end
    --     table.remove(totalIdList,removeIndex)
    --     table.remove(weightList,removeIndex)
    --     table.insert(idList,insertId)
    --     randomIndex = randomIndex + 1
    -- end
    WZLog("BattleMsgDailyPetBattleRound:getTreasureList",#idList)
    return idList
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgDailyPetBattleRound:process(dt)
    if self.m_nDelayTime then
         self.m_nDelayTime = self.m_nDelayTime + dt
        if self.m_nDelayTime > self.m_nDelayTotal then
            self.m_nDelayTime = nil
        end
        WZLog("BattleMsgDailyPetBattleRound:process",self.m_nDelayTime)
    end
    if #self.m_tStepList > 0 then
        local res = self.m_tStepList[1][1](self,self.m_tStepList[1][2],self.m_tStepList[1][3],self.m_tStepList[1][4])
        if res == true or res == nil then
            table.remove(self.m_tStepList,1)
        end
        return false
    end
	return true
end


function BattleMsgDailyPetBattleRound:cameraMove()
    return BattleScreen:followHero(GlobalMethod:ccp(880,900))
end

function BattleMsgDailyPetBattleRound:delay()
    if not self.m_bIsDelay then
        self.m_nDelayTime = 0
        self.m_nDelayTotal = 1
        self.m_bIsDelay = true
    end
    if self.m_nDelayTime then
        return false
    end
    return true
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgDailyPetBattleRound:done()
	WZLog("BattleMsgDailyPetBattleRound:done")
end

-------------------------------------私有方法模块--------------------------------------
