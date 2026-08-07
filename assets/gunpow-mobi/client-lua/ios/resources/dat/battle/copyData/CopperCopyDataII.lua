--CopperCopyDataII.lua
--@brief    金币副本II
--@date     2015/08/26
--@note     金币副本显示信息与胜利条件控制

CopperCopyDataII = {}

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function CopperCopyDataII:new()
    setmetatable(CopperCopyDataII,{__index = BaseCopyData})
    local tNewObj = {}
    setmetatable(tNewObj, { __index = CopperCopyDataII })
    tNewObj:_init()
    tNewObj.m_nRoundNum = 0
    tNewObj.m_nMaxRound = 10

    tNewObj.m_nTotalCoppeBig = 0
    tNewObj.m_nTotalCoppeMiddle = 0
    tNewObj.m_nTotalCoppeMini = 0
    tNewObj.m_nTotalHpHurt = 0
    tNewObj.m_nMonsterMaxHp = 0

    tNewObj.m_tCopperLab = nil
    tNewObj.m_nCopperNum = 0
    tNewObj.m_sHurt = nil
    tNewObj.m_nLeftCopperHp = 0

    tNewObj.m_nCopperActionCount = 0

    tNewObj.m_fightData = {fightData = {}}
    tNewObj.m_fightData.mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    tNewObj.m_fightData.fightId = 1
    tNewObj.m_tMapInfo = CopyTable(GDatatab_daily_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId])
    return tNewObj
end

--@brief 销毁
function CopperCopyDataII:destroy()
    WZLog("CopperCopyDataII:destroy")
    self:_removeEvent()
    if self.m_viewNode and self.m_viewNode:getParent() then
        self.m_viewNode:removeFromParentAndCleanup(true)
    end
    self.m_viewNode = nil
    self.m_tCopperLab = nil
    self.m_sHurt = nil
    self.m_fightData = nil
end

--@brief 创建显示信息
--@return 显示面板
function CopperCopyDataII:getInfoView()
    WZLog("CopperCopyDataII:getInfoView")
    if not self.m_viewNode then
        self.m_viewNode = WndCopperInfoView:createElement()

        self.m_viewNode:setRelativePositionLuaTo(0.96,1)

        self.m_tCopperLab = GetElement(self.m_viewNode, "copperNum_WndCopperInfoView", WZUILabelTTF)
        self.m_tCopperLab:setText("0")
        self.m_sHurt = GetElement(self.m_viewNode, "ftbHurt_WndCopperInfoView", WZUIFreeTextBox)

        self:_setBoss()
        self:_updateCopperLabView()
    end
    return self.m_viewNode
end

--@brief 新回合开始
function CopperCopyDataII:updateByTurn()
    self.m_nRoundNum = self.m_nRoundNum + 1
    if self:checkIsEnd() ~= 0 then
        self:copyEnd()
        return
    end
end

--@brief 结束条件判断
--@return 1 胜利 2 失败
function CopperCopyDataII:checkIsEnd()
    if not self.m_tBoss then
        return 0
    end
    --WZLog("CopperCopyDataII:checkIsEnd",self.m_tBoss:isDead(),self.m_tBoss:getPosition().x)
    if self.m_tBoss:isDead() then
        return 1
    --boss到达目标点 不能作为胜利条件判断
    elseif WBattleGlobal:getCurrent():checkIsHeroDead() or self.m_tBoss:getPosition().x >= 1700 then
        return 2
    end
    return 0
end

--@brief 副本结束处理
function CopperCopyDataII:copyEnd()
    --已经处理过
    if self.m_bIsEnd then
        return
    end
    WBattleGlobal:getCurrent():setGameOver(true)
    -- MsgManager:clear()

    local isWin = (self.m_nTotalHpHurt / self.m_nMonsterMaxHp)*100 >= self.m_tMapInfo.parameter6 and true or false
    self.m_fightData.isWin = isWin
    local isDead = self.m_tBoss:isDead() and 1 or 0
    table.insert(self.m_fightData.fightData,self.m_nTotalHpHurt)
    table.insert(self.m_fightData.fightData,self.m_nTotalCoppeBig)
    table.insert(self.m_fightData.fightData,self.m_nTotalCoppeMiddle)
    table.insert(self.m_fightData.fightData,isDead)
    table.insert(self.m_fightData.fightData,self.m_nMonsterMaxHp)
    --WZLog("CopperCopyDataII:copyEnd",Serialize(self.m_fightData))
    -- WndDailyCopySettlement:showWindow(self.m_fightData)
    BaseCopyData.copyEnd(self)
    
    local msg = MsgManager:createMsg(BattleMsgGameOver)
    msg.m_bWin = isWin
    msg.m_tSettlementData = self.m_fightData
    msg.m_bWin = isWin
    MsgManager:pushNonBlockMsg(msg)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块End----------------------------------------
--@brief    初始化对象
function CopperCopyDataII:_init()
    BaseCopyData._init(self)
    self:_initEvent()
end

function CopperCopyDataII:_setBoss()
    if not self.m_tBoss then
        for i,boss in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
            WZLog("CopperCopyDataII:_setBoss")
            self.m_tBoss = boss
            self.m_nMonsterMaxHp = boss:getMaxHp()
            break
        end
    end
end

--@brief 监听事件
function CopperCopyDataII:_initEvent()
    WZLog("CopperCopyDataII:_initEvent")
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_HURT, self._characterHurtHandler,self)
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.COPPER_COPY_ADD_COPPER, self._addCopyHandler,self)
end
--@brief 移除事件
function CopperCopyDataII:_removeEvent()
    WZLog("CopperCopyDataII:_removeEvent")
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_HURT,self._characterHurtHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.COPPER_COPY_ADD_COPPER,self._addCopyHandler,self)
end


function CopperCopyDataII:_addCopyHandler(flag)
    self.m_nCopperActionCount = self.m_nCopperActionCount - 1
    if self.m_nCopperActionCount == 0 then
        local count = math.ceil(self.m_nTotalHpHurt * self.m_tMapInfo.parameter1)
        self.m_tCopperLab:setText(tostring(count))
        return
    end
    
    local hp = 1000
    if flag == 1 then
        hp = 100
    end
    --WZLog("CopperCopyDataII:_addCopyHandler",flag,hp)
    -- if self.m_nLeftCopperHp ~= 0 then 
    --     hp = hp + self.m_nLeftCopperHp
    --     self.m_nLeftCopperHp = 0
    -- end
    --WZLog("CopperCopyDataII:_addCopyHandler II",hp)
    local count = math.ceil(hp * self.m_tMapInfo.parameter1)
    local oldCopper = tonumber(self.m_tCopperLab:getText())
    self.m_tCopperLab:setText(tostring(oldCopper + count))
    --WZLog("CopperCopyDataII:_addCopyHandler II",count,oldCopper)
end

--@brief 伤害回调
function CopperCopyDataII:_characterHurtHandler(hurter,hurthp)
    --[[
    ²   每100金币掉落一个mini金币
²   每1000金币掉落一个小金币
²   每1W金币掉落一个大金币
²   获得金币公式：金币=受伤的血量*10
    ]]
    if hurter:getType() == 1 then
        local copperNum = hurthp + self.m_nLeftCopperHp
        local bigCopperNum = math.floor(copperNum/1000)

        copperNum = copperNum - bigCopperNum * 1000
        local midCopperNum = math.floor(copperNum/100)
        self.m_nLeftCopperHp =  copperNum - midCopperNum * 100
        --copperNum = copperNum - midCopperNum * 1000
        local miniCopperNum = 0--math.floor(copperNum/100)

        self.m_nCopperActionCount = self.m_nCopperActionCount + bigCopperNum + midCopperNum + miniCopperNum
        local msg = MsgManager:createMsg(BattleMsgCopperEffect)
        msg.m_tStartPos = BattleCommon:getPointTable(self.m_tBoss:getPosition().x,self.m_tBoss:getPosition().y + 100)
        msg.m_nBigCopper = bigCopperNum
        msg.m_nMidCopper = midCopperNum
        msg.m_nMiniCopper = miniCopperNum

        MsgManager:pushNonBlockMsg(msg)

        self.m_nTotalCoppeBig = self.m_nTotalCoppeBig + bigCopperNum
        self.m_nTotalCoppeMiddle = self.m_nTotalCoppeMiddle + midCopperNum
        self.m_nTotalCoppeMini = self.m_nTotalCoppeMini + miniCopperNum
        self.m_nTotalHpHurt = self.m_nTotalHpHurt + hurthp
        --WZLog("CopperCopyDataII:_characterHurtHandler",bigCopperNum,midCopperNum,miniCopper)

        self:_updateCopperLabView()
        
        SoundManager:playEffectSound(SoundDefine.E_S_COPPER_DROP)
    end
end

--@brief 设置金币显示
function CopperCopyDataII:_updateCopperLabView()
    local count = self.m_nTotalHpHurt * self.m_tMapInfo.parameter1
    --count = self.m_nTotalCoppeBig * 1000
    --count = count + self.m_nTotalCoppeMiddle * 100
    --self.m_tCopperLab:setText(tostring(count))
    local targetHp = math.floor(self.m_tMapInfo.parameter6/100 * self.m_nMonsterMaxHp)
    self.m_sHurt:setShowText(string.format(LocalStrings.DAILY_LOSE_DESC4,tostring(self.m_nTotalHpHurt).."/"..tostring(targetHp)))
end

-------------------------------------私有方法模块End----------------------------------------