--WndCopyGuildInfoViewData.lua
--@brief	WndCopyGuildInfoView的数据模块
--@date		2018/10/26
--@author	yrd
--@note		公会副本ui

WndCopyGuildInfoView = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndCopyGuildInfoView:_init()
	self.m_root = nil  			--Cell的根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCopyGuildInfoView:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndCopyGuildInfoView:createElement()
	local element = WZUISystem:getInstance():createElement("WndCopyGuildInfoView")
	assert(element, "WndCopyGuildInfoView element create failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 监听事件
function WndCopyGuildInfoView:_initEvent()
    WZLog("WndCopyGuildInfoView:_initEvent")
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP, self._characterHurtHandler,self)
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.PALYER_ATT_ROUND_UPDATE,self._playerAttRoundUpdateHandler,self)
end

--@brief 移除事件
function WndCopyGuildInfoView:_removeEvent()
    WZLog("WndCopyGuildInfoView:_removeEvent")
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP,self._characterHurtHandler,self)
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.PALYER_ATT_ROUND_UPDATE,self._playerAttRoundUpdateHandler,self)
end

--@brief 伤害回调
function WndCopyGuildInfoView:_characterHurtHandler(hurter)
    local hero  = WBattleGlobal:getCurrent():getMyHero()

    GetElement(self.m_root, "txt2_WndCopyGuildInfoView", WZUILabelTTF):setText(hero.m_nShootHurtTotal)
end

-- --@brief 攻击回合回调
function WndCopyGuildInfoView:_playerAttRoundUpdateHandler()
    local boss  = WBattleGlobal:getCurrent():getBossArray()
    if #boss == 0 then return end 
    local bossAttackRound = boss[1].m_tAI.m_nAttackRound	--boss攻击了几次
    local bossBigSkillRound = boss[1].m_tAiScript[1][3].condition[1].conditionParm1	--boss第几次会放高伤害子弹
    local lastNum = math.max(bossBigSkillRound-bossAttackRound-1, 0)

    GetElement(self.m_root, "txt4_WndCopyGuildInfoView", WZUILabelTTF):setText(lastNum)
end

-------------------------------------私有方法模块End----------------------------------------
