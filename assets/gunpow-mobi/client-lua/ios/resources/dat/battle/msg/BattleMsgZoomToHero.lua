--BattleMsgZoomToHero.lua
--@brief	屏幕放缩移动到英雄消息
--@date		2013/1/8
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgZoomToHero = {
    m_sName = "BattleMsgZoomToHero",
	--m_nPlayerId,
	--m_nPlayerPos,
	m_bDoNot = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgZoomToHero:init()
    WBattleGlobal:getCurrent().m_bIsZoomToHero = true
	WZLog("BattleMsgZoomToHero:init", self.m_nPlayerId)
    self.m_hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nPlayerId)
	local loop = SceneBattle:getBattleLoop()

	if loop:getBattleStatus() == BattleLoop.S_NORMAL then
		loop:setBattleStatus(BattleLoop.S_ZOOM_TO_HERO)
		BattleScreen:resetZoomToHero()
	end

    if self.m_nPlayerPos ~= nil then 
        self.m_nPlayerPos = {x = self.m_nPlayerPos.x,y = self.m_nPlayerPos.y + 120}
    end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgZoomToHero:process()
	--WZLog("BattleMsgZoomToHero:process", tostring(self.m_hero), tostring(self.m_hero and self.m_hero:isDead()), tostring(self.m_hero and self.m_hero:getHp()), tostring(self.m_nPlayerPos.y))
	if self.m_bDoNot then
		return true
	end
	if not WBattleGlobal:getCurrent():isMyTeam(self.m_nPlayerId) then
		return true
	end

    if (not self.m_hero) or self.m_hero:isDead() or self.m_hero:isHide() or self.m_hero:getHp() <= 0 or self.m_nPlayerPos == nil or self.m_nPlayerPos.y < 0  then
        return true
    end
    
	local loop = SceneBattle:getBattleLoop()
	if loop:getBattleStatus() == BattleLoop.S_ZOOM_TO_HERO then
		--return BattleScreen:zoomToHero(self.m_nPlayerId, self.m_nPlayerPos,false)
        WZLog("BattleScreen:followHero 10")
        return BattleScreen:followHero(self.m_nPlayerPos)
	end

	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgZoomToHero:done()
    WBattleGlobal:getCurrent().m_bIsZoomToHero = nil
	WZLog("BattleMsgZoomToHero:done")
	local loop = SceneBattle:getBattleLoop()

	if loop:getBattleStatus() == BattleLoop.S_ZOOM_TO_HERO then
		loop:setBattleStatus(BattleLoop.S_NORMAL)
	end
end

-------------------------------------私有方法模块--------------------------------------
