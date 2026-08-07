--BattleMsgSynchronousBattleInfo.lua
--@brief    掉线重连同步信息
--@date     2016/04/19
--@note     掉线重连同步信息

--@brief    消息数据表
BattleMsgSynchronousBattleInfo = {
    m_sName = "BattleMsgSynchronousBattleInfo",
    m_tData = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgSynchronousBattleInfo:init()
    WZLog("BattleMsgSynchronousBattleInfo:init")

    if self.m_tData then
    	WBattleGlobal:getCurrent().m_nHostBattleId = nil

        for id, hero in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
            hero.m_bCanControl = false
        end
    	WBattleGlobal:getCurrent():synchronousBattleInfo(
		self.m_tData.playerIds, self.m_tData.dataIds, self.m_tData.masterIds, self.m_tData.camp, self.m_tData.hp, self.m_tData.sp, self.m_tData.CTB, self.m_tData.propIds, self.m_tData.postionX, self.m_tData.postionY
		, self.m_tData.angle, self.m_tData.face, self.m_tData.buffCount, self.m_tData.buffId, self.m_tData.buffPassCtb, self.m_tData.buffUserId
		, self.m_tData.explodePlayerId, self.m_tData.explodeSkillId, self.m_tData.explodePosNum, self.m_tData.explodePosX, self.m_tData.explodePosY, self.m_tData.finishPercent, self.m_tData.roundNum, self.m_tData.killCount, self.m_tData.onlineStatus, self.m_tData.battleInfo, self.m_tData.explodeDirection, self.m_tData.extraHP)
    end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgSynchronousBattleInfo:process()
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgSynchronousBattleInfo:done()
    WZLog("BattleMsgSynchronousBattleInfo:done")
end

-------------------------------------私有方法模块--------------------------------------
