--BattleMsgUpdatePlayerHP.lua
--@brief	血量更新消息
--@date		2013/12/31
--@author	李光森
--@note		同步血量

--@brief	消息数据表
BattleMsgUpdatePlayerHP = {
    m_sName = "BattleMsgUpdatePlayerHP",
	m_nBattleId = nil,  		--战斗id
	m_nPlayerId = nil,  		--角色id
	m_nPlayercount = nil, 		--人数
	m_tPlayerIds = nil,  		--所有人id
	m_tHp = nil, 				--所有人的当前血量
	m_nGuaicount = nil,
	m_tGuaiBattleIds = nil,
	m_tGuaiHp = nil,
	m_bReborn = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgUpdatePlayerHP:init()
	WZLog("BattleMsgUpdatePlayerHP:init")
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgUpdatePlayerHP:process()
	WZLog("BattleMsgUpdatePlayerHP:process")
	if self.m_nBattleId == WBattleGlobal:getCurrent().m_tMakePairOk.battleId then
		for i=1, self.m_nPlayercount do
            local hero = WBattleGlobal:getCurrent():getHeroWithId(self.m_tPlayerIds[i])
			WZLog("update player hp,id:,hurtValue:,RemainHp:",self.m_tPlayerIds[i],self.m_tHp[i])
            --[[
            if hero.m_bIsSyncHp == 0 or hero.m_bIsSyncHp == 2 then
                hero.m_bIsSyncHp = 2
            elseif hero.m_bIsSyncHp == 1 then
                hero.m_bIsSyncHp = 3
            end
            --]]

            hero:setHp(self.m_tHp[i], self.m_bReborn)
			if self.m_bReborn and self.m_tHp[i] > 0 then
				hero:setDead(false,12)
			end
		end
		if self.m_nGuaicount then
			for i=1, self.m_nGuaicount do
                local guai = WBattleGlobal:getCurrent():getGuaiWithId(self.m_tGuaiBattleIds[i])
				WZLog("update guai hp,id:,hurtValue:,RemainHp:",self.m_tGuaiBattleIds[i],self.m_tGuaiHp[i])
				if guai ~= nil then
                    --[[
                    if guai.m_bIsSyncHp == 0 or guai.m_bIsSyncHp == 2 then
                        guai.m_bIsSyncHp = 2
                    elseif guai.m_bIsSyncHp == 1 then
                        guai.m_bIsSyncHp = 3
                    end
                    --]]
                    guai:setHp(self.m_tGuaiHp[i])
				end
			end
		end
	end
	return true
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgUpdatePlayerHP:done()
	WZLog("BattleMsgUpdatePlayerHP:done")
	self.m_bReborn = nil
end

-------------------------------------私有方法模块--------------------------------------
