--BattleMsgShowCtbTime.lua
--@date		2015/4/17
--@author	zjh

--@brief	消息数据表
BattleMsgShowCtbTime = {
    m_sName = "BattleMsgShowCtbTime",
	m_nCommonCtb = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgShowCtbTime:init()
	WZLog("BattleMsgShowCtbTime:init", self.m_tBattleRand)
	self.m_nCommonCtb = 0
	self:syncBattleInfo()
	BattleCtbManager:showCtbTime()

    WBattleGlobal:getCurrent().m_tBattleRand = self.m_tBattleRand or WBattleGlobal:getCurrent().m_tBattleRand
    WBattleGlobal:getCurrent().m_bSendCurRoundInfo = -1
    WBattleGlobal:getCurrent().m_nSendCurRoundInfoTimer = -1
    WBattleGlobal:getCurrent().m_bSendCurRoundInfoOk = -1
    WBattleGlobal:getCurrent().m_bSendCurRoundInfoLisk = {}
    WBattleGlobal:getCurrent().m_nShowNetTipType = -1
    WBattleGlobal:getCurrent().m_nShowNetTipId = -1
    
    if WBattleGlobal:getCurrent().m_nNetLoading ~= -1 then
        MsgBoxManager:stopLoadingBoxByMsgId(WBattleGlobal:getCurrent().m_nNetLoading)
        WBattleGlobal:getCurrent().m_nNetLoading = -1
    end

	if WBattleGlobal:getCurrent().m_bIsShowStart == nil then
        WBattleGlobal:getCurrent().m_bIsShowStart = true
        SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_START)
        GetElement(WndBattleHud.m_root,"conStart_SceneBattle",WZUIContainer):setVisible(true)
        if WBattleGlobal:getCurrent() and WBattleGlobal:getCurrent().m_tFirstPos then
            local pos = WBattleGlobal:getCurrent().m_tFirstPos
            BattleScreen:followHero({x = pos.x,y = pos.y + 120})
        end
        ---[[
        local actionSequence = WZUIActionSequence:create()
        actionSequence:setIsLoop( false )
        local actionFadeTo1 = WZUIActionFadeTo:create()
        actionFadeTo1:setDuration( 0.5 )
        actionFadeTo1:setOpacity( 255 )
        actionSequence:setChildAction( actionFadeTo1 )
        local actionDelay = WZUIActionDelayTime:create()
        actionDelay:setDuration(0.8)
        actionSequence:setChildAction( actionDelay )
        local actionFadeTo2 = WZUIActionFadeTo:create()
        actionFadeTo2:setDuration( 0.5 )
        actionFadeTo2:setOpacity( 0 )
        actionSequence:setFinishLuaTable(self)
        actionSequence:setFinishLuaFunction("hide")
        actionSequence:setChildAction( actionFadeTo2 )

        --]]

        local img = GetElement(SceneBattle.m_root,"imgStart2_SceneBattle",WZUIImage)
        img:setOpacity(0)

        ---[[
        local con = GetElement(SceneBattle.m_root,"conStart_SceneBattle",WZUIContainer)
        local name = "boundary"
        local animName = "zhan1"
        if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == BattleConstants.g_tBattleChannel.MODE_GUILD then
            name = "gonghuizhan"
            animName = "gonghuizhan"
        end
        local anim = BattleAnimation:createAnimation(name,false,"battle/ui")
        self.anim = anim
        anim:getAnimNode():setOpacity(100)
        con:addChild(anim:getAnimNode(),1)
        anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
        anim:getAnimNode():setRelativePositionLuaTo(0.5,0.45)
        anim:play(animName,false)
        anim:setScale(1)
        anim:getAnimNode():runUIAction( actionSequence )
        --]]
    end
end

--同步战斗数据
function BattleMsgShowCtbTime:syncBattleInfo()
    if WBattleGlobal:getCurrent():isSingleStage() ~= true then
        if WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList then
            WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound zero-1", WBattleGlobal:getCurrent().m_nTurnTimes)

            for i, buffPlayer in pairs (WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList) do
                WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound one-1", i, Serialize(buffPlayer))

                local hero = WBattleGlobal:getCurrent():getCharacterWithId(buffPlayer.playerId)

                if hero and hero:isServerDead() ~= true and hero:getHp() > 0 and buffPlayer.isMapBuff ~= true then
                    if WBattleGlobal:getCurrent().m_tBuffAddPlayerList then
                        local isAdd
                        for j, buffPlayer2 in pairs (WBattleGlobal:getCurrent().m_tBuffAddPlayerList) do
                            if buffPlayer.round == buffPlayer2.round and buffPlayer.playerId == buffPlayer2.playerId and buffPlayer.buffId == buffPlayer2.buffId then
                                isAdd = true
                                break
                            end
                        end

                        if isAdd == nil then
                            for id,buff in pairs (hero.m_tBuffChangeStateList) do
                                if buff.m_nID == buffPlayer.buffId then
                                    hero:removeBuffSpecialInfluence(buff)
                                    buff:removeAnime()
                                    hero.m_tBuffChangeStateList[id] = nil
                                    WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound one-2",buff.m_nID)
                                    break
                                end
                            end
                        end
                    else
                        
                        for id,buff in pairs (hero.m_tBuffChangeStateList) do
                            if buff.m_nID == buffPlayer.buffId then
                                hero:removeBuffSpecialInfluence(buff)
                                buff:removeAnime()
                                hero.m_tBuffChangeStateList[id] = nil
                                WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound one-3",buff.m_nID)
                                break
                            end
                        end
                    end
                end
            end
        end

        if WBattleGlobal:getCurrent().m_tBuffAddPlayerList then
            WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound zero-0", WBattleGlobal:getCurrent().m_nTurnTimes,WBattleGlobal:getCurrent().m_nBuffAddRound, WBattleGlobal:getCurrent().m_nBuffAddId)

            for i, buffPlayer in pairs (WBattleGlobal:getCurrent().m_tBuffAddPlayerList) do
                WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound one-0", i, Serialize(buffPlayer))

                if WBattleGlobal:getCurrent().m_nTurnTimes == buffPlayer.round then

                    local hero = WBattleGlobal:getCurrent():getCharacterWithId(buffPlayer.playerId)
                    if hero and hero:isDead() ~= true and hero:getHp() > 0 and hero.m_nDeadRound ~= WBattleGlobal:getCurrent().m_nTurnTimes then
                        if WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList then
                            local isAdd
                            for j, buffPlayer2 in pairs (WBattleGlobal:getCurrent().m_tBuffAddSkillPlayerList) do
                                if buffPlayer.round == buffPlayer2.round and buffPlayer.playerId == buffPlayer2.playerId and buffPlayer.buffId == buffPlayer2.buffId then
                                    isAdd = true
                                    break
                                end
                            end
                            if isAdd == nil then
                                WBattleGlobal:addBuff({hero},buffPlayer.buffId,buffPlayer.userId)
                            end
                        else
                            WBattleGlobal:addBuff({hero},buffPlayer.buffId,buffPlayer.userId)
                        end
                    end
                end
            end
        end
    end

    if self.m_tPlayerId then
        local list = WBattleGlobal:getCurrent():getCharacterList()
        local tPlayerId = self.m_tPlayerId
        local tNowHP = self.m_tNowHP
        local tNowSP = self.m_tNowSP
        for i, combat in pairs (list) do
            for id, playerId in pairs (tPlayerId) do
                if combat:getBattleId() == playerId then
                    WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound synchronize", combat:getBattleId(), tostring(combat:isDead()), combat:getHp(), tNowHP[id], combat:getSp() ,tNowSP[id] )
                    
                    if tNowHP[id] > 0 and combat:isDead() == true then
                        combat:setDead(false)
                    end
                    if tNowHP[id] ~= combat:getHp() then
                        WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_CanStartCurRound synchronize two", combat:getBattleId(), tostring(combat:isDead()), combat:getHp(), tNowHP[id], combat:getSp() ,tNowSP[id])
                        combat:setHp(tNowHP[id])
                    end
                    combat:setSp(tNowSP[id], true)

                    if tNowHP[id] == 0 and combat:isDead() ~= true then
                        combat:setDead(true)
                        combat:setServerDead(true)
                    end
                    break
                end
            end
        end
    end
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgShowCtbTime:process(dt)
	if self.m_nCommonCtb then
		self.m_nCommonCtb = self.m_nCommonCtb + BattleCtbManager.SECOND_PER_CTB * dt

		WZLog("BattleMsgShowCtbTime:process",self.m_nCommonCtb, BattleCtbManager.m_nUpdateCTB_time)

		if BattleCtbManager.m_nUpdateCTB_time > 0 then
			for id, chara in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
                chara:updateBuffByCTB(dt, self.m_nCommonCtb * chara:getCTBSpeed() / 1000 )
			end
            if WBattleGlobal:getCurrent().m_tMapEvents ~= nil then
                for i, v in pairs (WBattleGlobal:getCurrent().m_tMapEvents) do
                    local event = WBattleGlobal:getCurrent().m_tMapEvents[i]
                    event:updateByCTBProcess(dt,self.m_nCommonCtb)
                end
            end
		end
		if self.m_nCommonCtb >= BattleCtbManager.m_nUpdateCTB_time then
			self.m_nCommonCtb = nil
		end
	end
	return not BattleCtbManager:checkHasProgAction()
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgShowCtbTime:done()
	WZLog("BattleMsgShowCtbTime:done")
    if BattleCtbManager.m_nUpdateCTB_time > 0 then
        for id, chara in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
            chara:updateBuffByCTB()
        end

        if WBattleGlobal:getCurrent().m_tMapEvents ~= nil then
            for i, v in pairs (WBattleGlobal:getCurrent().m_tMapEvents) do
                local event = WBattleGlobal:getCurrent().m_tMapEvents[i]
                event:updateByCTBProcess()
            end
        end
    end
end

-------------------------------------私有方法模块--------------------------------------

