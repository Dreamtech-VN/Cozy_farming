--WndCopyRelicViewData.lua
--@brief	WndCopyRelicView的数据模块
--@date		2019/07/26
--@author	yrd
--@note		遗迹副本战斗信息界面

WndCopyRelicView = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCopyRelicView:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCopyRelicView:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCopyRelicView:createElement()
	if WndCopyRelicView.m_root ~= nil then
		WindowManager:removeWindow(WndCopyRelicView.m_root, WndCopyRelicView, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCopyRelicView")
	assert(element, "WndCopyRelicView create element failed!")
	self:_init()
	return element
end

--@brief 监听事件
function WndCopyRelicView:_initEvent()
    WZLog("WndCopyRelicView:_initEvent")
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP, self._characterHurtHandler,self)
end

--@brief 移除事件
function WndCopyRelicView:_removeEvent()
    WZLog("WndCopyRelicView:_removeEvent")
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.CHARACTER_CHANGE_HP,self._characterHurtHandler,self)
end

--@brief 伤害回调
function WndCopyRelicView:_characterHurtHandler(hurter)
    local hero  = WBattleGlobal:getCurrent():getMyHero()
	local nMaxBlood = WBattleGlobal:getCurrent().m_tMakePairOk.guaiMaxHP[1]
	local nHurtProportion = string.format("%0.2f", hero.m_nShootHurtTotal/nMaxBlood*100)

    GetElement(self.m_root, "txt2_WndCopyRelicView", WZUILabelTTF):setText(hero.m_nShootHurtTotal.."("..nHurtProportion.."%)")
end

-- boss攻击回合
function WndCopyRelicView:setRoundNum(bossTurnCount)
	if self.m_root == nil then return end 
    local lastNum = 0
    local maxNum = 0
    maxNum = CacheCenter:getGameParam().digdungeonRound
    lastNum = math.max(maxNum-bossTurnCount, 0)
    GetElement(self.m_root, "txt4_WndCopyRelicView", WZUILabelTTF):setText(lastNum.."/"..maxNum)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
