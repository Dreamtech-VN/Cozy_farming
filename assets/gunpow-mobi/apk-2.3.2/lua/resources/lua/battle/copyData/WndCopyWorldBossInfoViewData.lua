--WndCopyWorldBossInfoViewData.lua
--@brief	WndCopyWorldBossInfoView的数据模块
--@date		2015/11/09
--@author	mbq
--@note		世界副本战斗UI

WndCopyWorldBossInfoView = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCopyWorldBossInfoView:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCopyWorldBossInfoView:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCopyWorldBossInfoView:createElement()
	local element = WZUISystem:getInstance():createElement("WndCopyWorldBossInfoView")
	assert(element, "WndCopyWorldBossInfoView create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------
--@brief 监听事件
function WndCopyWorldBossInfoView:_initEvent()
    WZLog("WndCopyWorldBossInfoView:_initEvent")
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP, self._characterHurtHandler,self)
end
--@brief 移除事件
function WndCopyWorldBossInfoView:_removeEvent()
    WZLog("WndCopyWorldBossInfoView:_removeEvent")
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP,self._characterHurtHandler,self)
end

-------------------------------------私有方法模块Begin--------------------------------------

--@brief 伤害回调
function WndCopyWorldBossInfoView:_characterHurtHandler(hurter)
    local hero  = WBattleGlobal:getCurrent():getMyHero()
    WZLog("WndCopyWorldBossInfoView:_characterHurtHandler",hero:getHp(),hero:getBattleId(),hurter:getBattleId())
    if hero:getBattleId() ~= hurter:getBattleId() then
        local curHp = hurter:getHp()
        self:_updatePlayerHpView(curHp)
    end
end



-------------------------------------私有方法模块End----------------------------------------
