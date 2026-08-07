--BattleMsgTeamBattle7Round.lua
--@brief    副本7逻辑
--@date     2016/10/26
--@note     

--@brief    消息数据表
BattleMsgTeamBattle7Round = {
    m_sName = "BattleMsgTeamBattle7Round",
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgTeamBattle7Round:init()
    WZLog("BattleMsgTeamBattle7Round:init")
    --刷新道具
    if WBattleGlobal:getCurrent():getCurrentCharacter():getType() == 0 then
        --判断是否需要刷新道具
        local inBuff = false
        for i,v in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
            if v.m_nMonsterType == MonsterType.BOSS then
                for index, buff in pairs (v.m_tBuffChangeStateList) do 
                    if 7006 == buff.m_nID or 7007 == buff.m_nID then
                        inBuff = true
                        break
                    end
                end
            end
        end
        if inBuff then
            WBattleGlobal:getCurrent():buildBossTreasure(self:getTreasureList())
        end
    end

    --机关触发
    local isDoSkill = false
    local npcHero = nil
    for i,v in pairs(WBattleGlobal:getCurrent():getMachinesList()) do
        if v.m_nMonsterType == MonsterType.BOSS_LASER and v.m_nLaserState == 1 then
           isDoSkill = true
        end
    end
    self.m_tStepList = {}
    if isDoSkill then
        self:initStep()
    end

    --npc对白
    self:initDialog()
end

function BattleMsgTeamBattle7Round:getTreasureList()
    local totalIdList = {1,2,3,10001,10002,10003,10004}
    local weightList = {}
    local idList = {}
    local totalWeight = 0
    for i = 1,#totalIdList do
        local treasureId = totalIdList[i]
        local config = GDatatab_boss_props["id_"..treasureId] or GDatatab_boss_props["id_1"]
        table.insert(weightList,config.weight)
        totalWeight = totalWeight + config.weight
    end

    local randomIndex = 1
    local removeIndex = 1
    while #totalIdList > 3 do
        local randomWeight = (WBattleGlobal:getCurrent():getCurRandNum(randomIndex) % 10 + 1)/10 * totalWeight
        local curWeight = 0
        local insertId = 1
        for i = 1,#weightList do
            curWeight = curWeight + weightList[i]
            if curWeight >= randomWeight then
                removeIndex = i
                totalWeight = totalWeight - weightList[i]
                insertId = totalIdList[i]
                break
            end
        end
        table.remove(totalIdList,removeIndex)
        table.remove(weightList,removeIndex)
        table.insert(idList,insertId)
        randomIndex = randomIndex + 1
    end
    return idList
end


function BattleMsgTeamBattle7Round:initStep()
    table.insert(self.m_tStepList,{self.cameraMove})
    table.insert(self.m_tStepList,{self.doSkill})
    table.insert(self.m_tStepList,{self.delay})
    table.insert(self.m_tStepList,{self.randomLaser})
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgTeamBattle7Round:process(dt)
    if self.m_nDelayTime then
         self.m_nDelayTime = self.m_nDelayTime + dt
        if self.m_nDelayTime > self.m_nDelayTotal then
            self.m_nDelayTime = nil
        end
        WZLog("BattleMsgTeamBattle7Round:process",self.m_nDelayTime)
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

function BattleMsgTeamBattle7Round:doSkill()
    for i,v in pairs(WBattleGlobal:getCurrent():getMachinesList()) do
        if v.m_nMonsterType == MonsterType.BOSS_LASER and v.m_nLaserState == 1 then
           v:doSkill()
        end
    end
end

function BattleMsgTeamBattle7Round:cameraMove()
    return BattleScreen:followHero(GlobalMethod:ccp(880,900))
end

function BattleMsgTeamBattle7Round:delay()
    if not self.m_bIsDelay then
        self.m_nDelayTime = 0
        self.m_nDelayTotal = 2
        self.m_bIsDelay = true
    end
    if self.m_nDelayTime then
        return false
    end
    return true
end

function BattleMsgTeamBattle7Round:randomLaser()
    WZLog("BattleMsgTeamBattle7Round:randomLaser")
    local list = {GlobalMethod:ccp(115,890+ 250),GlobalMethod:ccp(115,722+ 250),GlobalMethod:ccp(115,534+ 250),GlobalMethod:ccp(115,351+ 250)}
    local index = 1
    local gunList = {}
    for i,v in pairs(WBattleGlobal:getCurrent():getMachinesList()) do
        if v.m_nMonsterType == MonsterType.BOSS_LASER then
           table.insert(gunList,v)
        end
    end
    local sortFunc = function(a, b) return b:getBattleId() < a:getBattleId() end
    table.sort(gunList,sortFunc)
    
    while #list > 0 do
        local random = WBattleGlobal:getCurrent():getCurRandNum() % #list + 1
        gunList[index]:setPosition(list[random])
        table.remove(list,random)
        index = index + 1
    end
end

--@brief    初始化对话框
function BattleMsgTeamBattle7Round:initDialog()
    WZLog("BattleMsgTeamBattle7Round:initDialog")
    local hero = nil
    for i,v in pairs(WBattleGlobal:getCurrent():getCharacterList(true)) do
        if v.m_nMonsterType == MonsterType.TEAM_WAR_NPC then
           hero = v
           break
        end
    end
    if not hero then
        return
    end
    local talkIdList = {2036,2037,2038}
    local index = WBattleGlobal:getCurrent():getCurRandNum() % #talkIdList + 1
    local talkId = talkIdList[index]
    local text = nil
    if GDatatab_talk ~= nil and GDatatab_talk["id_"..talkId] ~= nil then
        text = GDatatab_talk["id_"..talkId].talk          --文本内容
    else
        return 
    end

    local maxWidth = 280           --最大宽度
    local scale = 1.0              --缩放大小
    local isUpdatePos = true
    local time = 3
    local direct = CellDialog.DIR_RIGHT
    local offsetPos = nil
    
    local pos = hero:getAnimDialogPos()
    local height = pos.x
    local width = pos.y
    
    if hero.m_tCollisionRang ~= nil then
        height = hero.m_tCollisionRang[1].m_fHeight * 0.7 + 30
        width = hero.m_tCollisionRang[1].m_fWidth * 0.4 + 30
    end

    if hero.m_bIsFilpX == false then
        direct = CellDialog.DIR_LEFT
        offsetPos = BattleCommon:getPointTable(-width, height)   --位置偏移量
    else
        direct = CellDialog.DIR_RIGHT
        offsetPos = BattleCommon:getPointTable(width, height)   --位置偏移量
    end
   
    if hero.m_tDialog ~= nil then
        hero.m_tDialog:removeDialog()
        hero.m_tDialog = nil
    end

    self:showDialog(hero,text,direct,offsetPos,maxWidth,scale,isUpdatePos,time)
end

--@brief    初始化对话框
function BattleMsgTeamBattle7Round:showDialog(hero,text,direct,offsetPos,maxWidth,scale,isUpdatePos,time)
    WZLog("BattleMsgTeamBattle7Round:showDialog")
    local boss = hero

    local nameInfo = nil
    if self.m_bIsRelyNameInfo ~= nil and self.m_bIsRelyNameInfo == false then
        nameInfo = boss:getAnimation():getAnimNode()
    elseif boss:getPlayerNameIcon() ~= nil then
        nameInfo = boss:getPlayerNameIcon().m_tNameLayer
    elseif boss.m_tGuaiName ~= nil then
        nameInfo = boss.m_tGuaiName.m_tNameLayer
    elseif boss.m_tBossName ~= nil then
        nameInfo = boss.m_tBossName.m_tNameLayer
    elseif boss.m_tBossNameAndHP ~= nil then
        nameInfo = boss.m_tBossNameAndHP.m_tNameLayer
    end

    boss.m_tDialogElement,boss.m_tDialog = CellDialog:addDialog(nameInfo, SceneBattle:getInfoLayer(),
        text, direct, time, nil, nil, 
        0, 0, maxWidth, scale, nil, nil, isUpdatePos, boss,100,nil,nil,nil,nil,true)
    ---[[
    if boss.m_mover ~= nil and (boss.m_nAiType == nil or boss.m_nAiType ~= MonsterAiType.AI_MELEE_SKY ) then
        local node = TrackNode:create(boss.m_tDialogElement)
        node:setPreAdd(Vector2:create(offsetPos.x,offsetPos.y))
        boss.m_mover:addTrackNode(node)
    end
end


--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgTeamBattle7Round:done()
	WZLog("BattleMsgTeamBattle7Round:done")
    
end

-------------------------------------私有方法模块--------------------------------------
