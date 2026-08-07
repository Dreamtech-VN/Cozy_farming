--WndCopyTowerInfoViewData.lua
--@brief	WndCopyTowerInfoView的数据模块
--@date		2015/09/09
--@author	mbq
--@note		爬塔 or 普通副本

WndCopyTowerInfoView = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCopyTowerInfoView:_init()
	self.m_root = nil	 	  			--场景根节点

    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        if WBattleGlobal:getCurrent():isSingleStage() then
            if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_TOWER_STAGE then
                self.m_tMapInfo = CopyTable(GDatatab_tower_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_tower_map["id_40001"])
            else
                self.m_tMapInfo =  CopyTable(GDatatab_single_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_single_map["id_10101"])
            end
        else
            if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_DOUBLETOWER_STAGE then
                self.m_tMapInfo = CopyTable(GDatatab_grouptower_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_grouptower_map["id_90001"])
            end
        end
    end
    self.m_tOriginValue = {"100%", 0, 0, "100%", 0, 0, 0, 0, 0, 1, 0}

    self.m_nWinType = 0 
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndCopyTowerInfoView:_unInit()
    self.m_root = nil
    self.m_tOriginValue = nil 
    self.m_nWinType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCopyTowerInfoView:createElement()
	local element = WZUISystem:getInstance():createElement("WndCopyTowerInfoView")
	assert(element, "WndCopyTowerInfoView create element failed!")
	self:_init()
	return element
end

--@brief    设置类型
--@param    0默认；1双人爬塔
function WndCopyTowerInfoView:setType(nType)
    -- body
    self.m_nWinType = nType or 0
end

--@brief    回合更新通关条件
function WndCopyTowerInfoView:updateAllCondition(passType, value)
    -- body
    if self.m_root == nil then return end 
    WZLog("WndCopyTowerInfoView:updateAllCondition", Serialize(passType), Serialize(value))
    for i = 1, #passType do
        local txtValue 
        if i == 1 then 
            txtValue = self.m_tAttRoundLab
        elseif i == 2 then 
            txtValue = self.m_tRemainHpLab
        elseif i == 3 then 
            txtValue = self.m_tOtherValue
        end

        txtValue:setText(value[i])
    end
end

-------------------------------------公有方法模块End----------------------------------------
--@brief 监听事件
function WndCopyTowerInfoView:_initEvent()
    WZLog("WndCopyTowerInfoView:_initEvent")
    for i = 1, 3 do
        if type(self.m_tMapInfo["pass" .. i]) == "table" then 
            local tPass = self.m_tMapInfo["pass" .. i][1]
            if tPass[1] == 1 then 
                GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP, self._characterHurtHandler,self)
            elseif tPass[1] == 2 then 
                GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.PALYER_ATT_ROUND_UPDATE,self._playerAttRoundUpdateHandler,self)
            elseif tPass[1] == 3 then 
                GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_MAX_HURT,self._playerMaxHurtUpdateHandler,self)
            elseif tPass[1] == 4 then 
                GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_HIT_RATE,self._playerHitRateUpdateHandler,self)
            elseif tPass[1] == 5 then 
                GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_USEITEM_TIMES,self._playerUseItemTimesUpdateHandler,self)
            elseif tPass[1] == 6 then 
                GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_NOTUSE,self._playerNotUseUpdateHandler,self)
            elseif tPass[1] == 7 then 
            elseif tPass[1] == 8 then 
                GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_USE_KILL,self._playerUseKillUpdateHandler,self)
            elseif tPass[1] == 9 then 
                GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.ROUND_KILL_MONSTERNUM,self._roundKillNumUpdateHandler,self)
            elseif tPass[1] == 10 then 
                GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.WIND_CHANGE,self._windUpdateHandler,self)
            elseif tPass[1] == 11 then 
                GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_USEKID_KILL,self._kidKillUpdateHandler,self)
            end

        end
    end
end
--@brief 移除事件
function WndCopyTowerInfoView:_removeEvent()
    WZLog("WndCopyTowerInfoView:_removeEvent")
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP,self._characterHurtHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.PALYER_ATT_ROUND_UPDATE,self._playerAttRoundUpdateHandler,self)

    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_MAX_HURT,self._playerMaxHurtUpdateHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_HIT_RATE,self._playerHitRateUpdateHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_USEITEM_TIMES,self._playerUseItemTimesUpdateHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_NOTUSE,self._playerNotUseUpdateHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_USE_KILL,self._playerUseKillUpdateHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.ROUND_KILL_MONSTERNUM,self._roundKillNumUpdateHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.WIND_CHANGE,self._windUpdateHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_USEKID_KILL,self._kidKillUpdateHandler,self)
end

--@brief 伤害回调
function WndCopyTowerInfoView:_characterHurtHandler(hurter)
    local hero  = WBattleGlobal:getCurrent():getMyHero()
    WZLog("WndCopyTowerInfoView:_characterHurtHandler",hero:getHp(),hero:getBattleId(),hurter:getBattleId())
    if hero:getBattleId() == hurter:getBattleId() then
        local curHp = hero:getHp()
        local maxHp = hero:getMaxHp()
        local prec = math.floor(curHp * 100/maxHp)
        self:updateCondition(1, prec)
    end
end

--@brief 攻击回合回调
function WndCopyTowerInfoView:_playerAttRoundUpdateHandler()

    local hero  = WBattleGlobal:getCurrent():getMyHero()
    local attRound = hero:getAttackRound()
    WZLog("WndCopyTowerInfoView:_playerAttRoundUpdateHandler", tostring(TeachGroup1.attackRound), attRound)
    self:updateCondition(2, attRound)
end

--@brief    最大伤害
function WndCopyTowerInfoView:_playerMaxHurtUpdateHandler()
    local hero  = WBattleGlobal:getCurrent():getMyHero()
    local maxHurt = hero:getMaxHurt()
    WZLog("WndCopyTowerInfoView:_playerMaxHurtUpdateHandler", maxHurt)
    
    self:updateCondition(3, maxHurt)
end

--@brief    命中率
function WndCopyTowerInfoView:_playerHitRateUpdateHandler()
    local hero  = WBattleGlobal:getCurrent():getMyHero()
    local hitRate = hero:getHitRate()
    WZLog("WndCopyTowerInfoView:_playerHitRateUpdateHandler", hitRate)
    
    self:updateCondition(4, hitRate)
end

--@brief    使用道具次数
function WndCopyTowerInfoView:_playerUseItemTimesUpdateHandler()
    local hero  = WBattleGlobal:getCurrent():getMyHero()
    local times = hero:getUseItemTimes()
    WZLog("WndCopyTowerInfoView:_playerUseItemTimesUpdateHandler", times)
    
    self:updateCondition(5, times)
end

--@brief    不使用某技能或道具
function WndCopyTowerInfoView:_playerNotUseUpdateHandler()
    local hero  = WBattleGlobal:getCurrent():getMyHero()
    local useSkillAndItemList = hero:getUseSkillAndItemList()
    WZLog("WndCopyTowerInfoView:_playerNotUseUpdateHandler", Serialize(useSkillAndItemList))
    
    self:updateCondition(6, useSkillAndItemList)
end

--@brief    使用技能杀死怪物
function WndCopyTowerInfoView:_playerUseKillUpdateHandler()
    local hero  = WBattleGlobal:getCurrent():getMyHero()
    local killEnemySkills = hero:getKillEnemySkills()
    WZLog("WndCopyTowerInfoView:_playerUseKillUpdateHandler", Serialize(killEnemySkills))
    
    self:updateCondition(8, killEnemySkills)
end

--@brief    回合杀人数（同时击杀数）
function WndCopyTowerInfoView:_roundKillNumUpdateHandler()
    local hero  = WBattleGlobal:getCurrent():getMyHero()
    local killNum = hero:getMaxKillMonsterNum()
    self:updateCondition(9, killNum)
end

--@brief    风速改变
function WndCopyTowerInfoView:_windUpdateHandler()
    local tWindLevel = WBattleGlobal:getCurrent():getWindLevel()
    nWindLevel = math.abs(tWindLevel.x)
    self:updateCondition(10, nWindLevel)
end

--@brief    使用小孩技能杀死怪物
function WndCopyTowerInfoView:_kidKillUpdateHandler()
    local hero  = WBattleGlobal:getCurrent():getMyHero()
    local killEnemyKidSkills = hero:getKillEnemyKidSkills()
    WZLog("WndCopyTowerInfoView:_kidKillUpdateHandler", Serialize(killEnemyKidSkills))
    
    self:updateCondition(11, killEnemyKidSkills)
end
-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
