--BattleMsgPass.lua
--@brief	战斗相关消息
--@date		2013/12/31
--@author	李俊鸿
--@note		跳过本轮操作

--@brief	消息数据表
BattleMsgPass = {
    m_sName = "BattleMsgPass",
	m_nBattleId = 0, --战斗id
	m_nPlayerId = 0, --角色id
	m_nPlayerOrGuai = nil, --英雄还是怪物(0:player,1:guai)
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgPass:init()
	WZLog("BattleMsgPass:init",self.m_nPlayerId)

    local hero = WBattleGlobal:getCurrent():getCharacterWithId(self.m_nPlayerId)
    
    if not hero then
        return
    end

    if hero and hero.m_bIsReadyShoot == true then
        hero.m_bIsReadyShoot = nil
        --添加个条件，死了的话，会改变幽灵动画
        if not hero:isDead() then 
            WZLog("BattleMsgPass:init 00000")
            hero:playEndShootAnim()
        end
    end

    local isCanControl = false

    if hero:isCanControl() == true and hero:getBattleId() ~= WBattleGlobal:getCurrent():getMyHero():getBattleId() then
        isCanControl = true
        WZLog("BattleMsgPass:init one")
    end


    if (hero == nil or hero.m_bIsUseSkill == nil) then
        WZLog("BattleMsgPass:init two",self.m_nPlayerId)
        if isCanControl == true or self.m_nPlayerId == WBattleGlobal:getCurrent():getMyBattleId() then
            ProtocolProcessorBattleInterface:send_BATTLE_SkillEquip(WBattleGlobal:getCurrent():getBattleId(), self.m_nPlayerId, 1002)
        end
        BattleCtbManager:addCtb(self.m_nPlayerId,BattleCtbManager.PASS_CTB)
    end

    if WBattleGlobal:getCurrent():getCurrentCharacter():getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() and not WBattleGlobal:getCurrent():isAudience() then
        BattleScreen.m_nLastScale = SceneBattle:getFrontLayer():getScale()
        WBattleGlobal:getCurrent().m_nPreZoomSize = BattleMapManager:getFrontControl().m_tNode:getScaleX()
        WBattleGlobal:getCurrent().m_nPreZoomPosCenter = SceneBattle:getFrontLayer():convertToNodeSpace(GlobalMethod:ccp(480,320))
        WBattleGlobal:getCurrent().m_nPreZoomPosMyself = WBattleGlobal:getCurrent():getCurrentCharacter():getAnimation():getPosition()
        --print("BattleScreenControl:moveZoom four",WBattleGlobal:getCurrent().m_nPreZoomPosCenter.x,WBattleGlobal:getCurrent().m_nPreZoomPosCenter.y, WBattleGlobal:getCurrent().m_nPreZoomPosMyself.x, WBattleGlobal:getCurrent().m_nPreZoomPosMyself.y)
    end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgPass:process()
	WZLog("BattleMsgPass:process")
	if not WBattleGlobal:getCurrent():isSingleStage() then
        
        ProtocolProcessorBattleInterface:send_BATTLE_Pass(self.m_nBattleId, self.m_nPlayerId)
    end
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgPass:done()
	WZLog("BattleMsgPass:done")
end

-------------------------------------私有方法模块--------------------------------------
