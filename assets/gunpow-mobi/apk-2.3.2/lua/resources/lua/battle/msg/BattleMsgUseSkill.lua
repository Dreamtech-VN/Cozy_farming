--BattleMsgUseSkill.lua
--@brief	战斗相关消息
--@date		2016/6/30
--@author	莫剑峰
--@note		使用技能

--@brief	消息数据表
BattleMsgUseSkill = {
    m_sName = "BattleMsgUseSkill",

    m_tData = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgUseSkill:init()
	WZLog("BattleMsgUseSkill:init")

    local hero = WBattleGlobal:getCurrent():getCurrentHero()
    WZLog("BattleMsgUseSkill:init two",self.m_tData.playerId , self.m_tData.itemId, tostring(hero and hero:isCanControl()), tostring(WBattleGlobal:getCurrent():isAudience()))
    if self.m_tData.itemId then 
        local config = CopyTable(GDatatab_skill["id_"..self.m_tData.itemId])
        if config and config.isNotSync == 1 then
            return
        end
        if config.skill_type == 9 then 
            hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tData.playerId)
            if hero then 
                BattleHeroUse:heroUse(self.m_tData.playerId, self.m_tData.type, self.m_tData.itemId, self.m_tData.isShow, true, true, self.m_tData.targetId, nil, self.m_tData.ownPlayerId)
            end
            return 
        end
        if self.m_tData.bIsChess then --棋圣皮肤大招-白分身
            hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_tData.playerId)
            if hero:getSubType() == CharacterSubType.SUBTYPE_WCHESS then 
                BattleHeroUse:heroUse(self.m_tData.playerId, self.m_tData.type, self.m_tData.itemId, self.m_tData.isShow, true, true, self.m_tData.targetId, nil, self.m_tData.ownPlayerId, true)
            elseif hero:getSubType() == CharacterSubType.SUBTYPE_BCHESS then 
                BattleHeroUse:heroUse(self.m_tData.playerId, self.m_tData.type, self.m_tData.itemId, self.m_tData.isShow, self.m_tData.isTreasure, true, nil, nil)
            end
            return 
        end

        --保存当前使用的技能id，用于判断攻击是否使用皮肤近身攻击
        if hero and hero.setUseSkillId then 
            hero:setUseSkillId(self.m_tData.itemId)
        end
    end
    if hero and hero:isCanControl() == false then
        BattleHeroUse:heroUse(self.m_tData.playerId, self.m_tData.type, self.m_tData.itemId, self.m_tData.isShow, self.m_tData.isTreasure, true, nil, nil, nil)
    end

end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgUseSkill:process()
	WZLog("BattleMsgUseSkill:process")
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgUseSkill:done()
	WZLog("BattleMsgUseSkill:done")
end

-------------------------------------私有方法模块--------------------------------------