--WndCopyPetInfoViewData.lua
--@brief	WndCopyPetInfoView的数据模块
--@date		2015/09/09
--@author	mbq
--@note		爬塔 or 普通副本

WndCopyPetInfoView = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCopyPetInfoView:_init()
	self.m_root = nil	 	  			--场景根节点

    self.m_tMapInfo = CopyTable(GDatatab_daily_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_tower_map["id_1001"])
    self.m_nScore = 0
                

end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCopyPetInfoView:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCopyPetInfoView:createElement()
	local element = WZUISystem:getInstance():createElement("WndCopyPetInfoView")
	assert(element, "WndCopyPetInfoView create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------
--@brief 监听事件
function WndCopyPetInfoView:_initEvent()
    WZLog("WndCopyPetInfoView:_initEvent")
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP, self._characterHurtHandler,self)
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.PALYER_ATT_ROUND_UPDATE,self._playerAttRoundUpdateHandler,self)
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.PET_COPY_ADD_SCORE, self._petCopyAddScoreHandler,self)
end
--@brief 移除事件
function WndCopyPetInfoView:_removeEvent()
    WZLog("WndCopyPetInfoView:_removeEvent")
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP,self._characterHurtHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.PALYER_ATT_ROUND_UPDATE,self._playerAttRoundUpdateHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.PET_COPY_ADD_SCORE, self._petCopyAddScoreHandler,self)
end

--@brief 伤害回调
function WndCopyPetInfoView:_characterHurtHandler(hurter)
    local hero  = WBattleGlobal:getCurrent():getMyHero()
    WZLog("WndCopyPetInfoView:_characterHurtHandler",hero:getHp(),hero:getBattleId(),hurter:getBattleId())
    if hero:getBattleId() ~= hurter:getBattleId() then
        local curHp = hurter:getHp()
        local maxHp = hurter:getMaxHp()
        local prec = math.floor(curHp/maxHp * 100)
        self:_updatePlayerHpView(100 - prec)
    end
end

--@brief 攻击回合回调
function WndCopyPetInfoView:_playerAttRoundUpdateHandler()

    local hero  = WBattleGlobal:getCurrent():getMyHero()
    local attRound = hero:getAttackRound()
    WZLog("WndCopyPetInfoView:_playerAttRoundUpdateHandler", tostring(TeachGroup1.attackRound), attRound)
    self:_updatePlayerAttRoundView(attRound)
end


--@brief 攻击回合回调
function WndCopyPetInfoView:_petCopyAddScoreHandler(score)
    self.m_nScore = self.m_nScore + score 
    if self.m_nScore > self.m_tMapInfo.parameter4 then
        self.m_nScore = self.m_tMapInfo.parameter4
    end
    self:_updatePetScoreView(self.m_nScore)
end
-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
