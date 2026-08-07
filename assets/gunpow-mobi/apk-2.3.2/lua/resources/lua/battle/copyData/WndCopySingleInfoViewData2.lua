--WndCopySingleInfoViewData2.lua
--@brief	WndCopySingleInfoView2的数据模块
--@date		2015/11/09
--@author	mbq
--@note		单人副本战斗UI

WndCopySingleInfoView2 = {
	--请不要在这里定义变量
}

--@brief    定义并初始化表的成员变量
--@note     变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCopySingleInfoView2:_init()
    self.m_root = nil                   --场景根节点

    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        if WBattleGlobal:getCurrent():isSingleStage() then
            if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_TOWER_STAGE then
                self.m_tMapInfo = CopyTable(GDatatab_tower_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_tower_map["id_1001"])
                
            else
                self.m_tMapInfo =  CopyTable(GDatatab_single_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_single_map["id_10101"])
            end
        end
    end

end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndCopySingleInfoView2:_unInit()
    self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    创建场景
--@return   #1，场景element的引用
--@note     请仅用此方法创建场景
function WndCopySingleInfoView2:createElement()
    local element = WZUISystem:getInstance():createElement("WndCopySingleInfoView2")
    assert(element, "WndCopySingleInfoView2 create element failed!")
    self:_init()
    return element
end

-------------------------------------公有方法模块End----------------------------------------
--@brief 监听事件
function WndCopySingleInfoView2:_initEvent()
    WZLog("WndCopySingleInfoView2:_initEvent")
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP, self._characterHurtHandler,self)
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.PALYER_ATT_ROUND_UPDATE,self._playerAttRoundUpdateHandler,self)
end
--@brief 移除事件
function WndCopySingleInfoView2:_removeEvent()
    WZLog("WndCopySingleInfoView2:_removeEvent")
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP,self._characterHurtHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.PALYER_ATT_ROUND_UPDATE,self._playerAttRoundUpdateHandler,self)
end

--@brief 伤害回调
function WndCopySingleInfoView2:_characterHurtHandler(hurter)
    local hero  = WBattleGlobal:getCurrent():getMyHero()
    WZLog("WndCopySingleInfoView2:_characterHurtHandler",hero:getHp(),hero:getBattleId(),hurter:getBattleId())
    if hero:getBattleId() == hurter:getBattleId() then
        local curHp = hero:getHp()
        local maxHp = hero:getMaxHp()
        local prec = math.ceil(curHp * 100/maxHp)
        self:_updatePlayerHpView(prec)
    end
end

--@brief 攻击回合回调
function WndCopySingleInfoView2:_playerAttRoundUpdateHandler()

    local hero  = WBattleGlobal:getCurrent():getMyHero()
    local attRound = hero:getAttackRound()
    WZLog("WndCopySingleInfoView2:_playerAttRoundUpdateHandler", tostring(TeachGroup1.attackRound), attRound)
    self:_updatePlayerAttRoundView(attRound)
end

-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

