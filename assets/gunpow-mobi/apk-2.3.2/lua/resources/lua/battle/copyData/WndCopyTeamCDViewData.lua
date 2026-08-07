--WndCopyTeamCDViewData.lua
--@brief	WndCopyTeamCDView的数据模块
--@date		2015/09/09
--@author	mbq
--@note		爬塔

WndCopyTeamCDView = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCopyTeamCDView:_init()
	self.m_root = nil	 	  			--场景根节点

    if WBattleGlobal:getCurrent():isEscapeBattle() then
        WZLog("WndCopyTeamCDView:_init", CacheCenter:getGameParam().greatEscapeBattleTime)
        self.m_nEndTime = SystemTime:getServerTime() + tonumber(CacheCenter:getGameParam().greatEscapeBattleTime) * 60
    else
        self.m_tMapInfo =  CopyTable(GDatatab_team_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_team_map["id_20101"])
        self.m_nEndTime = SystemTime:getServerTime() + self.m_tMapInfo.complete_time * 60
    end
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCopyTeamCDView:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCopyTeamCDView:createElement()
	local element = WZUISystem:getInstance():createElement("WndCopyTeamCDView")
	assert(element, "WndCopyTeamCDView create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 监听事件
function WndCopyTeamCDView:_initEvent()
    WZLog("WndCopyTeamCDView:_initEvent")
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.MONSTER_DEAD, self._monsterDeadHandler,self)
end
--@brief 移除事件
function WndCopyTeamCDView:_removeEvent()
    WZLog("WndCopyTeamCDView:_removeEvent")
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.MONSTER_DEAD,self._monsterDeadHandler,self)
end

--@brief 攻击回合回调
function WndCopyTeamCDView:_monsterDeadHandler()
	WZLog("WndCopyTeamCDView:_monsterDeadHandler",WBattleGlobal:getCurrent().m_tMakePairOk.mapId)
    if math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 204 then
        local monster = WBattleGlobal:getCurrent():getBossArray()[1]
        if monster and not monster:isDead() then
            local list = monster:getChildCharaList()
            if not list or #list == 0 then
				-- monster:setMaxHp(monster.m_nMaxHP_bak)
    --             monster.m_nMaxHP_bak = nil
				monster:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 10308}},nil,nil,nil,nil,nil,true)
                return
            end


            local deadCount = 0
            for k,v in pairs(list) do
                if v:isDead() then
                    deadCount = deadCount + 1
                end
            end
            if deadCount == #list then
				-- monster:setMaxHp(monster.m_nMaxHP_bak)
                monster:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 10308}},nil,nil,nil,nil,nil,true)
            end
        end
    end

    if math.floor(WBattleGlobal:getCurrent().m_tMakePairOk.mapId / 100) == 209 then
        local monster = WBattleGlobal:getCurrent():getBossArray()[1]
        if monster and not monster:isDead() then
            local list = monster:getChildCharaList()
            if not list or #list == 0 then
                -- monster:setMaxHp(monster.m_nMaxHP_bak)
    --             monster.m_nMaxHP_bak = nil
                monster:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 10308}},nil,nil,nil,nil,nil,true)
                return
            end


            local deadCount = 0
            for k,v in pairs(list) do
                if v:isDead() then
                    deadCount = deadCount + 1
                end
            end
            if deadCount == #list then
                -- monster:setMaxHp(monster.m_nMaxHP_bak)
                monster:getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = 10308}},nil,nil,nil,nil,nil,true)
            end
        end
    end
end



-------------------------------------私有方法模块End----------------------------------------
