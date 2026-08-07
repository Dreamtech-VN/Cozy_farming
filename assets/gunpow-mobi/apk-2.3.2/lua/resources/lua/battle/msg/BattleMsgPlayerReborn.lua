--BattleMsgPlayerReborn.lua
--@brief	人物重生消息
--@date		2013/4/3
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgPlayerReborn = {
    m_sName = "BattleMsgPlayerReborn",
	m_nBattleId = 0, --战斗id
	m_nPlayerId = 0, --角色id
	m_nPlayercount = 0,
	m_tPlayerIds = nil,
	m_tPostionX = nil,
	m_tPostionY = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgPlayerReborn:init()
	WZLog("BattleMsgPlayerReborn:init")
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgPlayerReborn:process()
	WZLog("BattleMsgPlayerReborn:process")
	for i=1, self.m_nPlayercount do
		local hero = WBattleGlobal:getCurrent():getHeroWithId(self.m_tPlayerIds[i])
		if hero then
			local tPos = Vector2:create( self.m_tPostionX[i] , self.m_tPostionY[i] )
			hero:setDead(false)
			hero:setHp(hero:getMaxHp())
			hero:setSp(hero:getSp())
			hero:setPosition(tPos)
			hero:getMover():setMoverPosition(tPos)
            hero.m_nRebornTurn = WBattleGlobal:getCurrent():getTurnTimes()
		end
	end
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgPlayerReborn:done()
	WZLog("BattleMsgPlayerReborn:done")
end

-------------------------------------私有方法模块--------------------------------------
