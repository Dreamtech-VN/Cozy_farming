--WndCopyFlyInfoViewData.lua
--@brief	WndCopyFlyInfoView的数据模块
--@date     2017/2/15
--@author   jianfeng_mo
--@note     训练营战斗UI

WndCopyFlyInfoView = {
	--请不要在这里定义变量
}

--@brief    定义并初始化表的成员变量
--@note     变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCopyFlyInfoView:_init()
    self.m_root = nil                   --场景根节点
    self.m_tMapInfo = CopyTable(GDatatab_train_map["id_"..WBattleGlobal:getCurrent().m_tMakePairOk.mapId] or GDatatab_train_map["id_1011"])
    self.m_nCount = 0
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndCopyFlyInfoView:_unInit()
    self.m_root = nil
    self.m_nCount = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    创建场景
--@return   #1，场景element的引用
--@note     请仅用此方法创建场景
function WndCopyFlyInfoView:createElement()
    local element = WZUISystem:getInstance():createElement("WndCopyFlyInfoView")
    assert(element, "WndCopyFlyInfoView create element failed!")
    self:_init()
    return element
end

-------------------------------------公有方法模块End----------------------------------------
--@brief 监听事件
function WndCopyFlyInfoView:_initEvent()
    WZLog("WndCopyFlyInfoView:_initEvent")
    if WBattleGlobal:getCurrent():isFlyCopy() then
        GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.TRAIN_COPY_FLY, self._characterFlyHandler,self)
    elseif WBattleGlobal:getCurrent():isWindCopy() or WBattleGlobal:getCurrent():isHoleCopy() or WBattleGlobal:getCurrent():isThrowCopy() then
        GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.MONSTER_DEAD, self._characterDeadHandler,self)
    end
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.PALYER_ATT_ROUND_UPDATE,self._playerAttRoundUpdateHandler,self)
end
--@brief 移除事件
function WndCopyFlyInfoView:_removeEvent()
    WZLog("WndCopyFlyInfoView:_removeEvent")
    if WBattleGlobal:getCurrent():isFlyCopy() then
        GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.TRAIN_COPY_FLY,self._characterFlyHandler,self)
    elseif WBattleGlobal:getCurrent():isWindCopy() or WBattleGlobal:getCurrent():isHoleCopy() or WBattleGlobal:getCurrent():isThrowCopy() then
        GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.MONSTER_DEAD,self._characterDeadHandler,self)
    end
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.PALYER_ATT_ROUND_UPDATE,self._playerAttRoundUpdateHandler,self)
end

--@brief 飞行回调
function WndCopyFlyInfoView:_characterFlyHandler()
    
    local count = self.m_tMapInfo.pass_count
    self.m_nCount = self.m_nCount + 1
    self:_updatePlayerFlyView()
    WZLog("WndCopyFlyInfoView:_characterFlyHandler", count, self.m_nCount)
    if count == self.m_nCount then
        WBattleGlobal:getCurrent().m_bIsSingleChallengeGameOver = true
        WBattleGlobal:getCurrent():singleStageEnd(true)
    end
end

--@brief 死亡回调
function WndCopyFlyInfoView:_characterDeadHandler()
    
    local count = self.m_tMapInfo.pass_count
    self.m_nCount = self.m_nCount + 1
    self:_updatePlayerFlyView()
    WZLog("WndCopyFlyInfoView:_characterDeadHandler", count, self.m_nCount)
    if count == self.m_nCount then
        WBattleGlobal:getCurrent().m_bIsSingleChallengeGameOver = true
        WBattleGlobal:getCurrent():singleStageEnd(true)
    end
end

--@brief HP回调
function WndCopyFlyInfoView:_characterHpHandler(chara)
    if chara ~= WBattleGlobal:getCurrent():getMyHero() then
        local count = self.m_tMapInfo.pass_count
        self.m_nCount = self.m_nCount + 1
        self:_updatePlayerFlyView()
        WZLog("WndCopyFlyInfoView:_characterHpHandler", count, self.m_nCount)
        if count == self.m_nCount then
            WBattleGlobal:getCurrent().m_bIsSingleChallengeGameOver = true
            WBattleGlobal:getCurrent():singleStageEnd(true)
        end
    end
end

--@brief 攻击回合回调
function WndCopyFlyInfoView:_playerAttRoundUpdateHandler()

    local hero  = WBattleGlobal:getCurrent():getMyHero()
    local attRound = hero:getAttackRound()
    WZLog("WndCopyFlyInfoView:_playerAttRoundUpdateHandler", tostring(TeachGroup1.attackRound), attRound)
    self:_updatePlayerAttRoundView(attRound)
    -- if attRound > self.m_tMapInfo.pass_round then
    --     WBattleGlobal:getCurrent().m_bIsSingleChallengeGameOver = true
    --     WBattleGlobal:getCurrent():singleStageEnd(false)
    -- end
end

-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

