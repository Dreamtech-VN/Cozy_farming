--WndHeroCDViewData.lua
--@brief	WndHeroCDView的数据模块
--@date		2016/07/10
--@author	莫剑峰
--@note		英雄联赛

WndHeroCDView = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHeroCDView:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tMapInfo =  nil
    self.m_nEndTime = SystemTime:getServerTime() + 15 * 60
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHeroCDView:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHeroCDView:createElement()
	local element = WZUISystem:getInstance():createElement("WndHeroCDView")
	assert(element, "WndHeroCDView create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 监听事件
function WndHeroCDView:_initEvent()
    WZLog("WndHeroCDView:_initEvent")
    GlobalGame:getBattleEventDispatcher():Add(BATTLE_EVENT_TYPE.MONSTER_DEAD, self._monsterDeadHandler,self)
end
--@brief 移除事件
function WndHeroCDView:_removeEvent()
    WZLog("WndHeroCDView:_removeEvent")
    GlobalGame:getBattleEventDispatcher():Remove(BATTLE_EVENT_TYPE.MONSTER_DEAD,self._monsterDeadHandler,self)
end

--@brief 攻击回合回调
function WndHeroCDView:_monsterDeadHandler()
	WZLog("WndHeroCDView:_monsterDeadHandler",WBattleGlobal:getCurrent().m_tMakePairOk.mapId)

end



-------------------------------------私有方法模块End----------------------------------------
