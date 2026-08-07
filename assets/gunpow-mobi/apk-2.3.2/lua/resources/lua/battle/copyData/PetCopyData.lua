--PetCopyData.lua
--@brief    金币副本II
--@date     2015/08/26
--@note     金币副本显示信息与胜利条件控制

PetCopyData = {}

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function PetCopyData:new()
    setmetatable(PetCopyData,{__index = BaseCopyData})
    local tNewObj = {}
    setmetatable(tNewObj, { __index = PetCopyData })
    tNewObj:_init()
		
    tNewObj.m_fightData = {fightData = {}}
    tNewObj.m_fightData.mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    tNewObj.m_fightData.fightId = 3
    tNewObj.m_tMapInfo = CopyTable(GDatatab_daily_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId])
    tNewObj.m_nPetScore = 0
    return tNewObj
end

--@brief 销毁
function PetCopyData:destroy()
    WZLog("PetCopyData:destroy")
    self:_removeEvent()
    if self.m_viewNode and self.m_viewNode:getParent() then
        self.m_viewNode:removeFromParentAndCleanup(true)
    end
    self.m_viewNode = nil
    self.m_sHurt = nil
    self.m_fightData = nil
end

--@brief 创建显示信息
--@return 显示面板
function PetCopyData:getInfoView()
    WZLog("PetCopyData:getInfoView")
    if not self.m_viewNode then
        self.m_viewNode = WndCopyPetInfoView:createElement()

        self.m_viewNode:setRelativePositionLuaTo(0.96,1)

        -- self.m_tCopperLab = GetElement(self.m_viewNode, "copperNum_WndCopperInfoView", WZUILabelTTF)
        -- self.m_tCopperLab:setText("0")
        -- self.m_sHurt = GetElement(self.m_viewNode, "ftbHurt_WndCopperInfoView", WZUIFreeTextBox)

        self:_setBoss()
    end
    return self.m_viewNode
end

--@brief 新回合开始
function PetCopyData:updateByTurn()

    if self:checkIsEnd() ~= 0 then
        self:copyEnd()
        return
    end
end

--@brief 结束条件判断
--@return 1 胜利 2 失败
function PetCopyData:checkIsEnd()
    if not self.m_tBoss then
        return 0
    end
    if WBattleGlobal:getCurrent():checkIsHeroDead() then
        return 2
    end

    if self.m_tBoss:isDead() then
        return 1
    end
    --WZLog("PetCopyData:checkIsEnd",self.m_tBoss:isDead(),self.m_tBoss:getPosition().x)
    local roundEnd = false
    if WBattleGlobal:getCurrent():getMyHero():getAttackRound() > self.m_tMapInfo.parameter5 then
        roundEnd = true
    elseif WBattleGlobal:getCurrent():getMyHero():getAttackRound() == self.m_tMapInfo.parameter5 and not WBattleGlobal:getCurrent():isMyTurn() then
        roundEnd = true
    end
    if roundEnd then
		if self.m_tBoss:getHp()/self.m_nMonsterMaxHp*100 < self.m_tMapInfo.parameter3 then
			return 1
		else
			return 2
		end
	end
    return 0
end

--@brief 副本结束处理
function PetCopyData:copyEnd()
    WZLog("PetCopyData:copyEnd")
    --已经处理过
    if self.m_bIsEnd then
        return
    end
    WBattleGlobal:getCurrent():setGameOver(true)
    -- MsgManager:clear()

    self.m_fightData.isWin = self:checkIsEnd() == 1 and true or false
    local isDead = self.m_tBoss:isDead() and 1 or 0
    if self.m_tBoss:isDead() then
    	self.m_nPetScore = self.m_nPetScore + self.m_tMapInfo.parameter6 * 100
    end
    if self.m_nPetScore > self.m_tMapInfo.parameter4 * 100 then
        self.m_nPetScore = self.m_tMapInfo.parameter4 * 100
    end

    table.insert(self.m_fightData.fightData,self.m_nPetScore/100)
    table.insert(self.m_fightData.fightData,WBattleGlobal:getCurrent():getMyHero():getAttackRound())
    table.insert(self.m_fightData.fightData,isDead)
    table.insert(self.m_fightData.fightData,100 - math.ceil(self.m_tBoss:getHp()/self.m_nMonsterMaxHp*100))
    -- WndDailyCopySettlement:showWindow(self.m_fightData)
    BaseCopyData.copyEnd(self)
    local msg = MsgManager:createMsg(BattleMsgGameOver)
    msg.m_tSettlementData = self.m_fightData
    msg.m_bWin = self.m_fightData.isWin
    MsgManager:pushNonBlockMsg(msg)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块End----------------------------------------
--@brief    初始化对象
function PetCopyData:_init()
    BaseCopyData._init(self)
    self:_initEvent()
end

function PetCopyData:_setBoss()
    if not self.m_tBoss then
        for i,boss in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
            WZLog("PetCopyData:_setBoss")
            self.m_tBoss = boss
            self.m_nMonsterMaxHp = boss:getMaxHp()
            break
        end
    end
end

--@brief 监听事件
function PetCopyData:_initEvent()
    WZLog("PetCopyData:_initEvent")
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.PET_COPY_ADD_SCORE, self._petCopyAddScoreHandler,self)
end
--@brief 移除事件
function PetCopyData:_removeEvent()
    WZLog("PetCopyData:_removeEvent")
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.PET_COPY_ADD_SCORE,self._petCopyAddScoreHandler,self)
end


function PetCopyData:_petCopyAddScoreHandler(score)

    self.m_nPetScore = self.m_nPetScore + score * 100
    if self.m_nPetScore > self.m_tMapInfo.parameter4 * 100 then
    	self.m_nPetScore = self.m_tMapInfo.parameter4 * 100
    end
end


-------------------------------------私有方法模块End----------------------------------------