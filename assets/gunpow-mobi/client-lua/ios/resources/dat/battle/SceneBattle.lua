--SceneBattle.lua
--@brief	SceneBattle的UI模块
--@date		2013/12/31
--@author	Zjh
--@note		战斗界面
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneBattle:onEnter(element)
    --WZLog = doNone

	local NDEBUG = false
	--NDEBUG = true
	if NDEBUG then
		WZLog = function() end
	end
	
	self:reloadAnimation()
	collectgarbage("collect")
	collectgarbage("stop")


	
	self:playBgm()
	
	self.m_root = element
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    CCDirector:sharedDirector():setAnimationInterval(1.0/30)

    local channel = Chat_Channel_Fighting_Normal

    if WBattleGlobal:getCurrent():isAudience() then
        WBattleGlobal:getCurrent().m_tFirstPos = {x=BattleMapManager.m_nWidth/2,y=BattleMapManager.m_nHeight/2}
        ProtocolProcessorGlobal:send_PLAYER_SynchronousWatch(WBattleGlobal:getCurrent().m_tMakePairOk.battleId)
    elseif WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        if WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZ then
            channel = Chat_Channel_Fighting_Normal
        elseif WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LS then
            channel = Chat_Channel_Fighting_League
        elseif WBattleGlobal:getCurrent():isHeroTowerStage() then
            channel = Chat_Channel_Fighting_HeroTower
        else
            channel = Chat_Channel_Fighting_Rank
        end
        
    elseif WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        if WBattleGlobal:getCurrent():isSingleStage() then
            if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) then
                channel = Chat_Channel_Fighting_Single
            elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_DAILY) then
                channel = Chat_Channel_Fighting_Daily
            elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) then
                channel = Chat_Channel_Fighting_Tower
            -- elseif WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_HEROTOWER) then
            --     channel = Chat_Channel_Fighting_HeroTower
            end
        else
            if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
                channel = Chat_Channel_Fighting_World_Boss
            else
                channel = Chat_Channel_Fighting_Team_Boss
            end

        end
    end

    WZLog("SceneBattle:onEnter one", channel, BattleMapManager.m_nWidth, BattleMapManager.m_nHeight)
	ChangeChatChannel(channel)
    
    --是否隐藏箭头
    WBattleGlobal.m_bHideArrow = nil
    if not WBattleGlobal:getCurrent():isReplayGame() and not (WBattleGlobal:getCurrent():isSingleStage()) then
        --注册战斗协议
        ProtocolProcessorBattleInterface:regAll()
        Protocol:unreg( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoomOk, "ProtocolProcessorBossMap:parse_BOSSMAPROOM_EnterRoomOk", "issiiiivbvivivsvivbvivivivivsvivivivivsvsvivissssssvivivivivivivivivivi")
        Protocol:unreg( Protocol.MAIN_ROOM, Protocol.ROOM_EnterRoomOk, "ProtocolProcessorGlobal:parse_ROOM_EnterRoomOk", "iiiiiiiiiivbvivivsvivbvivivivivsssvivsvivivivsvivsvivsvivissssssvivivivivi")
    end

	SceneBattle:startSchedule()	--开启循环定时器

	WBattleGlobal:getCurrent():setWaitNextRound(true,1)

    if  WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 9999 then
        local msg = MsgManager:createMsg(BattleMsgZoomOut)
        msg.m_nPlayerId = WBattleGlobal:getCurrent().m_nCurrentPlayerId
        msg.m_nPlayerPos = WBattleGlobal:getCurrent():getCurrentCharacter():getAnimation():getPosition()
        --MsgManager:pushBlockMsg(msg)


    end

    WBattleGlobal:getCurrent():addFirstBuff()
    if WBattleGlobal:getCurrent():isSingleStage() and not WBattleGlobal:getCurrent():isReplayGame() then
        local msg = MsgManager:createMsg(BattleMsgShowCtbTime)
        msg.m_tBattleRand = WBattleGlobal:getCurrent().m_tBattleRand
        MsgManager:pushBlockMsg(msg)
        
        ---[[
        local msg = MsgManager:createMsg(BattleMsgZoomToHero)
        msg.m_nPlayerId = WBattleGlobal:getCurrent().m_nCurrentPlayerId
        local hero = WBattleGlobal:getCurrent():getCharacterWithId(msg.m_nPlayerId)
        msg.m_nPlayerPos = WBattleGlobal:getCurrent().m_tFirstPos --hero:getAnimation():getPosition()
        MsgManager:pushBlockMsg(msg)
        --]]

        local msg = MsgManager:createMsg(BattleMsgReadyStartRound)
        MsgManager:pushBlockMsg(msg)

        local msg = MsgManager:createMsg(BattleMsgCanStartCurRound)
        msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
        msg.m_nPlayerId = WBattleGlobal:getCurrent().m_nCurrentPlayerId
        msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent().m_nCurrentPlayerId
        msg.m_nPlayerOrGuai = WBattleGlobal:getCurrent().m_nPlayerOrGuai
        msg.m_nWind = WBattleGlobal:getCurrent().m_tWind.x
        msg.m_bIsCrit = WBattleGlobal:getCurrent().m_nIsCriticalHit
        msg.m_tAttackRate = WBattleGlobal:getCurrent().m_tAttackRate
        msg.m_nIsNewRound = false--WBattleGlobal:getCurrent().m_nIsNewRound
        msg.m_tBattleRand = WBattleGlobal:getCurrent().m_tBattleRand
        MsgManager:pushBlockMsg(msg)

        --录像记录
        if WBattleGlobal:getCurrent():canRecordGame() then
            local replayParam = {}
            replayParam.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
            replayParam.m_nPlayerId = WBattleGlobal:getCurrent().m_nCurrentPlayerId
            replayParam.m_nCurrentPlayerId = WBattleGlobal:getCurrent().m_nCurrentPlayerId
            replayParam.m_nPlayerOrGuai = WBattleGlobal:getCurrent().m_nPlayerOrGuai
            replayParam.m_nWind = WBattleGlobal:getCurrent().m_tWind.x
            replayParam.m_bIsCrit = WBattleGlobal:getCurrent().m_nIsCriticalHit
            replayParam.m_tAttackRate = WBattleGlobal:getCurrent().m_tAttackRate
            replayParam.m_nIsNewRound = false--WBattleGlobal:getCurrent().m_nIsNewRound
            replayParam.m_tBattleRand = WBattleGlobal:getCurrent().m_tBattleRand
            
            BattleMsgReplayGameRecord:setStartRound(replayParam)
        end

    elseif not WBattleGlobal:getCurrent():isAudience() then
        if WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_GS then
            for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
                local nCamp = hero:getCamp()
                if nCamp == 1 then 
                    if WBattleGlobal:getCurrent().m_tTouchCircle and hero:getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() then 
                        WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setVisible(false)
                    end
                    SceneBattle:getInfoLayer2():enableSchedule("_heroBlink", 0)
                    break 
                end
            end
        else
            WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),99,nil,nil,true)
        end
        --[[
        local msg = MsgManager:createMsg(BattleMsgZoomToHero)
        msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyHero():getBattleId()
        local hero = WBattleGlobal:getCurrent():getMyHero()
        msg.m_nPlayerPos = WBattleGlobal:getCurrent().m_tFirstPos --hero:getAnimation():getPosition()
        MsgManager:pushBlockMsg(msg)
        --]]
    end

    --保存排位积分加成
    if WBattleGlobal:getCurrent():isArenaPWStage() then 
        local data = CacheCenter:getArenaAddInfo()
        g_PvpRankAddPercent = 0
        if data and data.addValue then 
            for i=1,#data.addValue do
                local addType = data.timeType[i]
                if addType == 2 then
                    g_PvpRankAddPercent = tonumber(data.addValue[i])
                    break 
                end
            end
        end
    end
    
    --初始化副本信息
    WBattleGlobal:getCurrent():initCopyData()

	self.m_root:getChildElement("multiTouchPanel_SceneBattle"):addChild(WndBattleHud:createElement())

	self:_initShowFront()

	WndBattleHud:setWindLevel(WBattleGlobal:getCurrent():getWindLevel())

	WndBattleHud:setWindVisible(true)

	WndBattleHud:setMyHero(WBattleGlobal:getCurrent():getMyHero())

	--WBattleGlobal:getCurrent():addBigSkillAnim()

	--怪物动画播放(为了迎合骨骼动画)
	for i,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
        WZLog("SceneBattle:onEnter ten", i, tostring(guai.m_bIsGuaiWithSuit))
        if guai.m_bIsGuaiWithSuit == nil or guai.m_bIsGuaiWithSuit == false then
            guai:setAppearAttribute()
        end

        if (guai.m_bIsOldAnim == nil or guai.m_bIsOldAnim == true) and (guai.m_bIsGuaiWithSuit == nil or guai.m_bIsGuaiWithSuit == false) then
            WZLog("guai:getAnimation():play one")
            guai:getAnimation():play(guai:getNormalAnimationName(),true)
        else
            WZLog("guai:getAnimation():play two")
            guai:getAnimation():play(guai:getNormalAnimationName() or "0",true)
        end

	end

	--英雄动画播放(为了迎合骨骼动画)
	for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
		hero:getAnimation():play(hero:getActionName(23),true)
	end

    for i,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
        if (guai.m_bIsGuaiWithSuit ~= nil and guai.m_bIsGuaiWithSuit == true) then
            guai:getAnimation():play(guai:getActionName(23),true)
        end
    end
    
    WndChat:addChatWindowToCurScene()
end

GDatatab_battle_bgm_test = 
{
    id_1 = { id = 1,mapId = {{68,69}}, musicName = "battlebg_1,battlebg_2"},

}
function SceneBattle:playBgm()
    WZLog("SceneBattle:playBgm zero")

    -- if GDatatab_battle_bgm == nil then
    --     GDatatab_battle_bgm = GDatatab_battle_bgm_test
    -- end

    local isAssign =  false
    local name = ""
    local mapId = tonumber(WBattleGlobal:getCurrent().m_tMakePairOk.battleMap:match("%d+"))
    if GDatatab_battle_bgm then
        
        for i,v in pairs(GDatatab_battle_bgm) do
            for j,u in pairs (v.mapId[1]) do
                if mapId == u then
                    local musicName = string.gsub(v.musicName, " ", "")
                    local idList = SplitStringWithSeparator(musicName, ",")
                    local index = #idList > 1 and math.random(1,#idList) or 1
                    name = (idList[index] or idList[index-1] or "") .. ".mp3"
                    isAssign = true
                    break
                end
            end
            if isAssign then
                break
            end
        end

        
    end

    WZLog("SceneBattle:playBgm one", tostring(isAssign), name, mapId, tostring(GDatatab_battle_bgm))
    if isAssign then
        SoundManager:playBgMusic(name)
    else
        local seed = math.random(10000)
        if seed % 7 == 1 then
            SoundManager:playBgMusic(SoundDefine.E_MUSIC_BATTLE_1)
        elseif  seed % 7 == 2 then
            SoundManager:playBgMusic(SoundDefine.E_MUSIC_BATTLE_2)
        elseif  seed % 7 == 3 then
            SoundManager:playBgMusic(SoundDefine.E_MUSIC_BATTLE_3)
        elseif  seed % 7 == 4 then
            SoundManager:playBgMusic(SoundDefine.E_MUSIC_BATTLE_5)
        elseif  seed % 7 == 5 then
            SoundManager:playBgMusic("battlebg_6.mp3")
        elseif  seed % 7 == 6 then
            SoundManager:playBgMusic("battlebg_7.mp3")
        elseif  seed % 7 == 0 then
            SoundManager:playBgMusic("battlebg_8.mp3")
        end
    end
end

function SceneBattle:startSchedule()
    WZLog("SceneBattle:startSchedule")
    WBattleGlobal:getCurrent().m_bIsSchedule = true
    self.m_root:enableSchedule("loop",0)
end

function SceneBattle:disableSchedule()
    WZLog("SceneBattle:disableSchedule")
    WBattleGlobal:getCurrent().m_bIsSchedule = false
    self.m_root:disableSchedule()
end

--@brief	删除多余的资源 给战斗腾空间
function SceneBattle:onEnterTransitionDidFinish(element)
	--创建角色指示圈

	local size = WBattleGlobal:getCurrent():getMyHero():getAnimation():getAnimNode():getContentSize()

    CCTextureCache:sharedTextureCache():removeUnusedTextures()

    --缓存纹理
    self:addTextureCache()

	local path = "battleweapon/"
	for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
		hero:getAnimation():getAnimNode():setAnchorPointLuaTo(0.5,0.15)
        local heroMonster = WBattleGlobal:getCurrent():getHeroMonster()
        if heroMonster and heroMonster:getId() == hero:getId() then 
            heroMonster:getAnimation():getAnimNode():setAnchorPointLuaTo(0.5,0.15)
        end
	end
    SceneBattleEffect:initMapEffect()

    WZLog("SceneBattle:onEnterTransitionDidFinish end")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneBattle:onExit(element)
    WZLog("SceneBattle:onExit")
    --足迹
    FootEffectManager:getInstance():destroy()

    self:clearClipLayer()

    --WZDataFile:getInstance():unloadTexturePackFile("battle/hud/battle_hud.plist","battle/hud/battle_hud.png")
	--反注册战斗协议
	ProtocolProcessorBattleInterface:unregAll()
    ProtocolProcessorSingleMap:unregAll()

    if self.m_tTextureCache ~= nil then
        for i, v in pairs(self.m_tTextureCache) do
            if v ~= nil and v.release ~= nil then
                v:release()
            end
        end
    end

    Protocol:reg( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoomOk, "ProtocolProcessorBossMap:parse_BOSSMAPROOM_EnterRoomOk", "issiiiivbvivivsvivbvivivivivsvivivivivsvsvivissssssvivivivivivivivivivi")
    Protocol:reg( Protocol.MAIN_ROOM, Protocol.ROOM_EnterRoomOk, "ProtocolProcessorGlobal:parse_ROOM_EnterRoomOk", "iiiiiiiiiivbvivivsvivbvivivivivsssvivsvivivivsvivsvivsvivissssssvivivivivi")
    Protocol:reg( Protocol.MAIN_HERO, Protocol.HERO_ReadyFightOK, "ProtocolProcessorWndLeague:parse_HERO_ReadyFightOK", "isssviviviviviiiiiviviivivsvissvivsivivsiviisviii")
    
    --地图事件
    if WBattleGlobal:getCurrent().m_tMapEvents ~= nil and #WBattleGlobal:getCurrent().m_tMapEvents > 0  then
        for i, event in pairs(WBattleGlobal:getCurrent().m_tMapEvents) do
            event:destroy()
        end
    end

    if SceneBattle.m_bIsLostNetSingleMap ~= 0 then
        WZLog("SceneBattle:onExit lostNet2", SceneBattle.m_bIsLostNetSingleMap, self.m_bIsConnect)
        SceneBattle.m_bIsLostNetSingleMap = 0
        BattleMsgGameOver.m_bIsConnect = 0
        SceneLogin:connectCallbackByToken(CONNECTSERVER_DISCONNECT, true)
    end
    
	self:_unInit()
    Teach:isStartTeach("SceneBattle:onExit")
	--CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
	CCArmatureDataManager:sharedArmatureDataManager():removeAll()

    --停止语音聊天
    VoiceChat:StopVoice()

	collectgarbage("collect")
	collectgarbage("restart")
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    CCDirector:sharedDirector():setAnimationInterval(1.0/30)
	
	SoundManager:playBgMusic(SoundDefine.E_MUSIC_ISLAND)
	
	WDExplodeHole:deleteInstance()

    if TeachGroup1.SCHEDULE then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(TeachGroup1.SCHEDULE)
    end
	
end

--@brief	缓存纹理
--@note		缓存纹理,降低战斗中的纹理加载操作
function SceneBattle:addTextureCache()
    WZLog("SceneBattle:addTextureCache zero")

    self.m_tTextureCache = {}
    local path = "armatures/battle/ui/ui_jishatishi.png"
    self:createTextureCache(path)

end

--@brief	缓存纹理
--@note		缓存纹理,减少纹理加载操作
function SceneBattle:createTextureCache(path)
    --local fullPath = CCFileUtils:sharedFileUtils():fullPathForFilename(path)
    local isFileExist = WZFileUtil:isFileExist(path)
    WZLog("SceneBattle:createTextureCache", isFileExist, path)
    if isFileExist ~= true then
        return
    end

    local textureCacheElement = CCSprite:create(path)
    if textureCacheElement ~= nil then
        textureCacheElement:retain()
        table.insert(self.m_tTextureCache, textureCacheElement)
    end
end

--@brief	初始化
--@note		进入战斗界面前的所有初始化
function SceneBattle:init()
    --足迹
    FootEffectManager:getInstance():setFootLayer(SceneBattle:getFrontLayer())

    --检测是否使用粒子效果
    WBattleGlobal:getCurrent():isHighEndMachine()

	self:_initMap()							--加载地图

	--移动管理
	WBattleGlobal:getCurrent().m_battleManager = WDBattleManager:create(Vector2:create(BattleConstants.g_nGravity.x,BattleConstants.g_nGravity.y),Vector2:create(BattleConstants.g_nFlyGravity.x,BattleConstants.g_nFlyGravity.y),BattleMapManager:getPixelByte())
	WBattleGlobal:getCurrent().m_battleManager:retain()
	WBattleGlobal:getCurrent().m_battleManager:setWind(WBattleGlobal:getCurrent():getWind().x, WBattleGlobal:getCurrent():getWind().y)

    local heroPos = nil
    local tmpHero = nil
    for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        heroPos = hero:getPosition()
        tmpHero = hero
    end

	--加载场景怪物
	for i,guai in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
        if guai.m_bHighLayer == nil then
            SceneBattle:getFrontLayer():addChild(guai:getAnimation():getAnimNode())
        else
            SceneBattle:getFrontLayer():addChild(guai:getAnimation():getAnimNode(),4)
        end
        if (guai.m_bIsGuaiWithSuit ~= nil and guai.m_bIsGuaiWithSuit == true) or (guai.m_nAiType ~= nil and guai.m_nAiType ~= MonsterAiType.AI_MELEE_SKY) or  guai:getId() == 16 then
            if guai:getMover() then
                WBattleGlobal:getCurrent().m_battleManager:addEntity(guai:getMover())
            end
        end
        if not guai.m_bIsGuaiWithSuit then
            guai:getAnimation():getAnimNode():setAnchorPoint(guai:getSceneAnchorPoint())
        end

        if guai.m_bIsGuaiWithSuit then
            guai:getAnimation():getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.15))
            WZLog("SceneBattleLoading:_getCharacterPos three-0")
        end
        WZLog("SceneBattleLoading:_getCharacterPos three", heroPos.x, guai:getPosition().x)
        if heroPos.x > guai:getPosition().x then
            for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
                hero:getAnimation():setFlipX(true)
            end

            if not guai.m_bIsGuaiWithSuit then
                guai:getAnimation():setFlipX(true)
                guai.m_bIsFilpX = true
            end
        else
            if guai.m_bIsGuaiWithSuit then
                guai:getAnimation():setFlipX(true)
                guai.m_bIsFilpX = true
            end
        end
        if WBattleGlobal:getCurrent():isCopperCopy() then
            guai:getAnimation():setFlipX(false)
            guai.m_bIsFilpX = false
            tmpHero:getAnimation():setFlipX(false)
        end
	end

    --加载场景道具
    for i,machine in pairs(WBattleGlobal:getCurrent():getMachinesList()) do
        local zOrder = 4
        if machine:getAniFileIndex() == "machine_1001" then
            zOrder = -100
        elseif machine:getAniFileIndex() == "machine_8001" or machine:getAniFileIndex() == "machine_9001" then
            zOrder = 100
        end
        SceneBattle:getFrontLayer():addChild(machine:getAnimation():getAnimNode(),zOrder)
        if machine:getMover() then
            WBattleGlobal:getCurrent().m_battleManager:addEntity(machine:getMover())
        end
    end
	--加载场景角色
    local heroZOrder = 0
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        heroZOrder = 5
    end
	for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
		SceneBattle:getFrontLayer():addChild(hero:getAnimation():getAnimNode(),heroZOrder)
        if not WBattleGlobal:getCurrent():isAudience() then
		    WBattleGlobal:getCurrent().m_battleManager:addEntity(hero:getMover())
        else
            hero:setPosition(Vector2:create(0,-90))
        end
        local heroMonster = WBattleGlobal:getCurrent():getHeroMonster()
        if heroMonster and heroMonster:getId() == hero:getId() then 
            SceneBattle:getFrontLayer():addChild(heroMonster:getAnimation():getAnimNode(),heroZOrder)
            if heroMonster:getAnimation():getAnimNode() then
                heroMonster:getAnimation():getAnimNode():setVisible(false)
            end
            if not WBattleGlobal:getCurrent():isAudience() then
                WBattleGlobal:getCurrent().m_battleManager:addEntity(heroMonster:getMover())
            else
                heroMonster:setPosition(Vector2:create(0,-90))
            end
        end
        --hero:addAppearAnimation()
	end
    -- if not WBattleGlobal:getCurrent():isReplayGame() then
    -- 	--创建角色指示光圈
    --     local myhero = WBattleGlobal:getCurrent():getMyHero()
    --     local anim = BattleAnimation:createAnimation("battle_hud",false, "battle/ui")
    --     anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))

    --     if myhero.m_bIsMonster then
    --         --anim:getAnimNode():setPosition(300,75)
    --         if myhero.m_nMonsterId == 4 then
    --             anim:getAnimNode():setRelativePositionLuaTo(0.2,0.5)
    --         else
    --             anim:getAnimNode():setRelativePositionLuaTo(0.4,0.5)
    --         end
    --     else
    --         anim:getAnimNode():setRelativePositionLuaTo(0.5,0.7)
    --     end
    --     anim:getAnimNode():setAnimationName("animation")
    --     anim:getAnimNode():setLoop(true)
    --     myhero:getAnimation():getAnimNode():addChild(anim:getAnimNode())
    --     anim:setScale(300/680)
    --     WBattleGlobal:getCurrent().m_tTouchCircle = anim
    -- end

	--创建角色指示箭头
	local sp = CCSprite:create("ui/combat/common_icon_xuanzhong.png")
	local action =  CCRepeatForever:create(CCJumpBy:create(1,GlobalMethod:ccp(0,0),30,1))
	local arrowLayer = CCLayer:create()
    sp:setPosition(0,-50)
	WBattleGlobal:getCurrent().m_CurrentPlayerArrow = arrowLayer
	self:getFrontLayer():addChild(arrowLayer,5)
	sp:runAction(action)
	arrowLayer:addChild(sp)

	--创建角色名字
    for k,v in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        local bSameCamp = WBattleGlobal:getCurrent():isMyTeam(v:getBattleId())
        local playerName = BattleHeroName:create(v,self:getInfoLayer(),bSameCamp)
        v:setPlayerNameIcon(playerName)
        playerName:update()
    end

    --创建穿套装的怪物名字
    for k,v in pairs(WBattleGlobal:getCurrent():getGuaiList()) do
        if v.m_bIsGuaiWithSuit == true then
            local bSameCamp = WBattleGlobal:getCurrent():isMyTeam(v:getBattleId())
            local playerName = BattleHeroName:create(v,self:getInfoLayer(),bSameCamp)
            v:setPlayerNameIcon(playerName)
            playerName:update()
        end
    end

	self.m_loop = BattleLoop:create()		--生成循环功能

	self.m_touch = BattleTouch:create()		--生成触摸管理功能


    ---[[
    local isEndTeach1, step1 = TeachGroup1:isTeachFinish(7)
    local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
    if ((TeachGroup1:isTeach() and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) and ( isEndTeach1 == false and CacheCenter:getPlayerInfo().level <= 3))) and (mapId == 10101 or mapId == 10103 ) then
        TeachGroup1.ISBATTLE = true
    else
        TeachGroup1.ISBATTLE = nil
    end

    if not TeachGroup1:isTeach() then
        TeachGroup1.ISBATTLE = nil
    end

    if TeachGroup1.ISTEACHMODE then
        TeachGroup1.ISBATTLE = true
    end

    if WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 9999 then
        TeachGroup1.ISBATTLE = true
        TeachGroup1.ISFIRSTBATTLE = true
    else
        TeachGroup1.ISFIRSTBATTLE = nil
    end
    --]]

    WZLog("SceneBattle:init one", TeachGroup1.ISBATTLE)
    if false and (WBattleGlobal:getCurrent():isWindTeach() or WBattleGlobal:getCurrent():isChapterOneTeach() or TeachGroup1.ISBATTLE) then
        self.m_pointsLine = BattlePointsLine:create(self:getFrontLayer(), 20)
    else
        self.m_pointsLine = BattlePointsLine:create(self:getTopInfoLayer(), 20, nil, nil, nil, nil, nil, 99)
    end

	BattleHeroUse:clear()

    WBattleGlobal:getCurrent():enableAllHeroFallDown()
end

--@brief	每帧循环处理函数
--@param	element:定时器绑定对象
--@param	dt:定时器间隔
--@note		定时器回调
function SceneBattle:loop(element,dt)
    ---[[
    local isConfirmActive = false --WindowManager:ifActiveWindow(WndConfirmBox)
    --WZLog("SceneBattle:loop one", tostring(isConfirmActive), tostring(self.m_bIsLostNet))
    if isConfirmActive ~= true and self.m_bIsLostNet == nil then
        local sender = (GlobalGame.g_tSysConfig.connectState == CONNECTSERVER_DISCONNECT) or (GlobalGame.g_tSysConfig.connectState == CONNECTSERVER_FAILED)
        --WZLog("SceneBattle:loop two",tostring(sender))
        if sender==true then
            self.m_bIsLostNet = true
            if WBattleGlobal:getCurrent():isSingleStage() then
                self.m_bIsLostNetSingleMap = 1
            end
            --MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, SceneLogin, SceneLogin.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
        end
    end
    --]]
	if self.m_loop ~= nil then
		self.m_loop:update(dt)
	end

    if true and self.m_count == 0 then
        if WBattleGlobal:getCurrent():isFog() then
            WZLog("SceneBattle:loop one")
            BattleMapManager:addFogMap(self:getFogLayer())
            BattleMapManager:getFogControl():centerOnPoint({x = WBattleGlobal:getCurrent().m_tFirstPos.x , y = WBattleGlobal:getCurrent().m_tFirstPos.y })
            self:getInfoLayerBlack():setVisible(false)
        end
        self.m_count =  self.m_count + 1
    end
    
end

--@brief	清除没用的动画和加载需要的动画
function SceneBattle:reloadAnimation()
	--CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
	CCArmatureDataManager:sharedArmatureDataManager():removeAll()
end

--@brief	离开战斗
function SceneBattle:leftBattle()
	--提前保存变量，下面战斗场景有可能会被销毁
    local nBattleType = WBattleGlobal:getCurrent().m_nBattleType
    local nBattleModeLocal = WBattleGlobal:getCurrent().battleMode --本地
    local nBattleMode = WBattleGlobal:getCurrent().m_tMakePairOk.battleMode --服务器
    local bIsSingleStage = WBattleGlobal:getCurrent():isSingleStage()
    local nBattleChannle = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
    local schedule = WBattleGlobal:getCurrent().m_tMakePairOk.schedule

    WZLog("SceneBattle:leftBattle1", tostring(nBattleType),tostring(nBattleMode), tostring(nBattleChannle), tostring(bIsSingleStage))
    WndBattleHud:quitVoice()
    if self.m_root == nil then
		WBattleGlobal:getCurrent():destroy()
	end

    local element
	if nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
		if nBattleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
			element = ScenePvpRank:createElement()
        elseif nBattleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZ then
            element = SceneHall:createElement()
        elseif nBattleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ then
            SceneCommunityWar:showInterface()
        elseif nBattleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_QS then
            SceneAthMelee:showInterface(2)
        elseif nBattleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD then
            if nBattleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_QS then
                SceneAthMelee:showInterface(2)
            else
                SceneAthMelee:showInterface(1)
            end
        elseif nBattleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then
            element = ScenePvpAmuse:createElement()
		elseif nBattleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LS then
			SceneLeagueMain:showInterface(2)
        elseif nBattleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX then
            ScenePvp:showScene()
        elseif nBattleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YXT then
            SceneCopy:showScene(4, 1)
        else
            element = SceneHall:createElement()
		end
	elseif nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then

		if nBattleModeLocal == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then
            element = SceneWorldBoss:createElement()
        elseif nBattleModeLocal == BattleConstants.g_tBossBattleMode.MODE_LOVE_STAGE then
            ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo()
            WndMarryManager:createLoading()
        elseif nBattleModeLocal == BattleConstants.g_tBossBattleMode.MODE_WORLDTEAMBOSS then
			element = SceneWorldTeamBoss:createElement()
        elseif bIsSingleStage then
            if WBattleGlobal:getCurrent():getBattleMode() == BattleConstants.g_tBossBattleMode.MODE_NORMAL_TABOO then
                WZLog("SceneBattle:leftBattle-1")
                 SceneTabooBattle:show(-1)
            else
                local nMapType = WBattleGlobal:getCurrent().m_tMakePairOk.mapType
                local nMapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
                if nMapType == COPYTYPE_SINGLE then
                    if GlobalGame.g_nSingleCopyType == 3 then 
                        SceneCopy:showScene(1, nMapId)
                    else
                        SceneCopy:showScene(1, nMapId,GlobalGame.g_nSingleCopyType)
                    end
                elseif nMapType == COPYTYPE_DAILY then
                    SceneCopy:showScene(3)
                elseif nMapType == COPYTYPE_TOWER then
                    SceneCopy:showScene(4)
                elseif nMapType == COPYTYPE_TRAIN then
                    local index = 1
                    if WBattleGlobal:getCurrent():isFlyCopy() then
                        index = 1
                    elseif WBattleGlobal:getCurrent():isWindCopy() then
                        index = 2
                    elseif WBattleGlobal:getCurrent():isHoleCopy() then
                        index = 3
                    elseif WBattleGlobal:getCurrent():isThrowCopy() then
                        index = 4
                    end
                    ScenePvp:showScene(index)
                    WZLog("SceneBattle:leftBattle2")
                end
            end
        elseif nBattleModeLocal == BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_2 then
             WZLog("SceneBattle:leftBattle3")
            SceneCopy:showScene(2)
        elseif nBattleModeLocal == BattleConstants.g_tBossBattleMode.MODEL_GUILD_STATE then
            element = SceneCommunityBossInfo:createElement()
		else
			--element = SceneIsland:createElement()
             WZLog("SceneBattle:leftBattle4")
            SceneCopy:showScene(2)
		end
	end

    if element then
        replaceScene(element)
    end

    if SceneBattle.m_bIsLostNetSingleMap ~= 0 then
        WZLog("SceneBattle:leftBattle3 lostNet2", SceneBattle.m_bIsLostNetSingleMap, self.m_bIsConnect)
        SceneBattle.m_bIsLostNetSingleMap = 0
        BattleMsgGameOver.m_bIsConnect = 0
        SceneLogin:connectCallbackByToken(CONNECTSERVER_DISCONNECT, true)
    end

end
------获取元素

--@brief	获取背景Layer
--@return	背景Layer
--@note
function SceneBattle:getBgLayer()
	if self.m_root then
		return GetElement(self.m_root,"conBgLayer_SceneBattle",WZUIContainer)
	end
end

--@brief	获取中景Layer
--@return	中景Layer
--@note
function SceneBattle:getMidLayer()
	if self.m_root then
		return GetElement(self.m_root,"conMidLayer_SceneBattle",WZUIContainer)
	end
end

--@brief	获取前景Layer
--@return	前景Layer
--@note
function SceneBattle:getFrontLayer()
	if self.m_root then
		return GetElement(self.m_root,"conFrontLayer_SceneBattle",WZUIContainer)
	end
end

--@brief    获取雾Layer
--@return   雾Layer
--@note
function SceneBattle:getFogLayer()
    if self.m_root then
        return GetElement(self.m_root,"conFogLayer_SceneBattle",WZUIContainer)
    end
end

--@brief    获取雾Layer
--@return   雾Layer
--@note
function SceneBattle:getFogLayer2()
    if self.m_root then
        return GetElement(self.m_root,"conFogLayer2_SceneBattle",WZUIContainer)
    end
end

--@brief    获取毒雾
--@return   雾Layer
--@note
function SceneBattle:getPoisonFog()
    if self.m_root then
        return GetElement(self.m_root,"conPoisonFog_SceneBattle",WZUIContainer)
    end
end

--@brief    获取毒雾
--@return   雾Layer
--@note
function SceneBattle:getPoisonFog2()
    if self.m_root then
        return GetElement(self.m_root,"conPoisonFog2_SceneBattle",WZUIContainer)
    end
end

--@brief    获取取消拉线
function SceneBattle:getImgCancel()
    if self.m_root then
        return GetElement(self.m_root,"imgCancel_SceneBattle",WZUIImage)
    end
end


function SceneBattle:clearClipLayer()
    if self.m_clipCon then
        WZLog("SceneBattle:clearClipLayer")
        self.m_clipCon:removeFromParentAndCleanup(true)
        self.m_clipCon = nil
    end
end

function SceneBattle:getClipLayer()
    if not self.m_clipCon then
        WZLog("SceneBattle:getClipLayer create")
        self.m_clipCon = WZUIClippingContainer:create()
        self.m_clipCon:setInverted(true)
        self:getInfoLayer():addChild(self.m_clipCon,1000)
    end
    return self.m_clipCon
end

--@brief	获取信息层Layer
--@return	信息层Layer
--@note		存放一些不会变化位置的信息内容
function SceneBattle:getInfoLayer()
	if self.m_root then
		return GetElement(self.m_root,"conInfoLayer_SceneBattle",WZUIContainer)
	end
end

--@brief    获取信息层Layer2
--@return   信息层Layer
--@note     存放一些不会变化位置的信息内容
function SceneBattle:getInfoLayer2()
    if self.m_root then
        return GetElement(self.m_root,"conInfoLayer2_SceneBattle",WZUIContainer)
    end
end

--@brief    获取信息层Layer2
--@return   信息层Layer
--@note     存放一些不会变化位置的信息内容
function SceneBattle:getInfoLayerBlack()
    if self.m_root then
        return GetElement(self.m_root,"imgInfoLayer2_SceneBattle",WZUIImage)
    end
end

--@brief	获取动态信息层Layer
--@return	动态信息层Layer
--@note		存放一些变化位置的信息内容
function SceneBattle:getInfoDynamicLayer()
    if self.m_root then
        return GetElement(self.m_root,"conInfoLayer_SceneBattle",WZUIContainer)
    end
end

--@brief	获取Top信息层Layer
--@return	Top信息层Layer
--@note		存放一些信息在整个场景的最上层
function SceneBattle:getTopInfoLayer()
	if self.m_root then
		return GetElement(self.m_root,"conTopInfoLayer_SceneBattle",WZUIContainer)
	end
end

function SceneBattle:getBigSkillLayer()
	if self.m_root then
		return GetElement(WndBattleHud.m_root,"conBigSkill2Anim_SceneBattle",WZUIContainer)
	end
end

--@brief	获取BattleLoop
--@return	BattleLoop
--@note
function SceneBattle:getBattleLoop()
	return self.m_loop
end

--@brief	获取BattleTouch
--@return	BattleTouch
--@note
function SceneBattle:getBattleTouch()
	return self.m_touch
end

--@brief	获取BattlePointsLine
--@return	BattlePointsLine
--@note		抛物线
function SceneBattle:getBattlePointsLine()
	return self.m_pointsLine
end


--@brief	获取前景Layer大小
--@return	table,前景Layer大小
--@note
function SceneBattle:getFrontLayerSize()
	if self.m_nFrontLayerWidth == nil or self.m_nFrontLayerHeight == nil then
		if self:getFrontLayer() then
			local size = self:getFrontLayer():getContentSize()
			self.m_nFrontLayerWidth = size.width
			self.m_nFrontLayerHeight = size.height
		end
	end
	return {width = self.m_nFrontLayerWidth , height = self.m_nFrontLayerHeight }
end

--@brief	检测是否超出屏幕
--@param    mover,移动控制对象
--@return	#1:是否超出屏幕
--@return	#2:是否纵向超出屏幕
function SceneBattle:checkIsOutOfScene(mover)
    if mover == nil then
        return false, false
    end
	if self:getFrontLayer() then
		local sceneSize = self:getFrontLayerSize()
        local a = mover:getMoverPosition()
        a = {x = a.x,y = a.y}
        
        --纵向超出屏幕
		if a.y < -100 then
			return true, true
            --横向超出屏幕
        elseif a.x < -100 or a.x > sceneSize.width + 100 then
            return true, false
		end
	end
	return false, false
end
------触摸回调

--@brief	触摸面板Began回调
--@param	element:回调绑定的UI节点引用
--@param	point：触摸点
--@param	nIdx：触摸点id
--@note
function SceneBattle:onTouchBegan(element, point,nIdx)
    WZLog("SceneBattle:onTouchBegan", nIdx, self.m_touch, point.x, point.y)
	if self.m_touch then
		self.m_touch:onTouchBegan(element, point,nIdx)
	end
    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
    if WndTips.m_root and not WndTips:checkPointInBtn(pt) then
        WndTips:_onCloseClick()
    end
end

--@brief	触摸面板Moved回调
--@param	element:回调绑定的UI节点引用
--@param	point：触摸点
--@param	nIdx：触摸点id
--@note
function SceneBattle:onTouchMoved(element, point,nIdx)
    WZLog("SceneBattle:onTouchMoved", nIdx, self.m_touch, point.x, point.y)
	if self.m_touch then
		self.m_touch:onTouchMoved(element, point,nIdx)
	end
end

--@brief	触摸面板End回调
--@param	element:回调绑定的UI节点引用
--@param	point：触摸点
--@param	nIdx：触摸点id
--@note
function SceneBattle:onTouchEnd(element, point,nIdx)
    WZLog("SceneBattle:onTouchEnd", nIdx, self.m_touch, point.x, point.y)
	if self.m_touch then
		self.m_touch:onTouchEnd(element, point,nIdx)
	end
end

------回合动画TurnShow

--@brief	显示回合动画
--@param	bNextTurn:是否是下一回合
--@param	bMyTurn:是否是自己回合
--@note
function SceneBattle:playTurnShow(bNextTurn,bMyTurn)
    if WBattleGlobal:getCurrent():isReplayGame() then
        return
    end
    
	if bNextTurn==false and bMyTurn==false then
		self.m_bRunTurnShow = false
		return
	end
	local turnShow = GetElement(self.m_root,"conTurnShow_SceneBattle",WZUIContainer)

	if true then	 --newUI
		GetElement(turnShow,"imgMyTurn_SceneBattle"):setVisible(false)
		GetElement(turnShow,"conTurnTimes_SceneBattle"):setVisible(false)
		GetElement(turnShow,"conWinMission_SceneBattle"):setVisible(false)
		if bMyTurn then
			if turnShow:getChildElement("imgNewMyTurn_SceneBattle") == nil then
                local container = WZUIContainer:create()
                container:setUseAbsSize(true)
                container:setAbsContentSize(GlobalMethod:CCSize(702,102)) 

				local bg = WZUI9Image:create()
				--bg:setUseOriginSize(true)
				bg:setFile("ui/combat/common_scale9_lundaonichushou_bg.png")
                container:addChild(bg)

				local img = WZUIImage:create()
				img:setUseOriginSize(true)
				img:setName("imgNewMyTurn_SceneBattle")
				img:setFile("ui/combat/common_icon_lundaonichushou.png")
				container:addChild(img)

                local fileName = ""
                if WBattleGlobal:getCurrent():isExpCopy() then
                    fileName = "ui/combat/common_icon_zzgwtlhdjy.png"
                elseif WBattleGlobal:getCurrent():isCopperCopy() then
                    fileName = "ui/combat/common_icon_gjbxghdjb.png"
                elseif WBattleGlobal:getCurrent():isFlyCopy() then
                    fileName = "ui/combat/common_icon_fzzddwcrw.png"
                elseif WBattleGlobal:getCurrent():isWindCopy() then
                    fileName = "ui/combat/common_icon_zyflgjgw.png"
                elseif WBattleGlobal:getCurrent():isHoleCopy() then
                    fileName = "ui/combat/common_icon_bpdtgjgw.png"
                elseif WBattleGlobal:getCurrent():isThrowCopy() then
                    fileName = "ui/combat/common_icon_gpsjzyfx.png"
                end

                if fileName ~= "" then
                    container:setAbsContentSize(GlobalMethod:CCSize(702,162))
                    img:setRelativePositionLuaTo(0.5,0.6)

                    local imgLab = WZUIImage:create()
                    imgLab:setUseOriginSize(true)
                    imgLab:setFile(fileName)
                    imgLab:setRelativePositionLuaTo(0.5,0.3)
                    container:addChild(imgLab)
                end


                turnShow:addChild(container)
			end
		end
	end

	WZUILabelAtlasFont:luaTo(GetElement(turnShow,"txtTurnTimes_SceneBattle")):setText(WBattleGlobal:getCurrent():getTurnTimes())

	self.m_bRunTurnShow = true
	turnShow:setRelativePositionLuaTo(1.5,0.5)

	local moveTo1 = WZUIActionMoveTo:create()
	moveTo1:setMoveX(0.5)
	moveTo1:setMoveY(0.5)
	moveTo1:setDuration(0.2)

	local delay = WZUIActionDelayTime:create()
	delay:setDuration(0.8)

	local moveTo2 = WZUIActionMoveTo:create()
	moveTo2:setMoveX(-0.5)
	moveTo2:setMoveY(0.5)
	moveTo2:setDuration(0.2)
	moveTo2:setFinishLuaFunction("endTurnShow")
	moveTo2:setFinishLuaTable(self)

	local sequence = WZUIActionSequence:create()
	sequence:setChildAction(moveTo1)
	sequence:setChildAction(delay)
	sequence:setChildAction(moveTo2)

	turnShow:setVisible(true)
	turnShow:runUIAction(sequence)

	SoundManager:playEffectSound(SoundDefine.E_S_ROUND)
end

--@brief	显示陨石攻击提示动画
--@note
function SceneBattle:mapEvenShow(index)
    WZLog("SceneBattle:mapEvenShow", index)
    SceneBattle.m_nMapEventShow = 0

    self.m_nMapEventIndex = index
    local conName,imgName,resName = "conMapEventShow_SceneBattle","imgMapEventShow_SceneBattle",""
    if index >= 1 and index <= 4 then
        resName = "target_trigger_0"..index..".png"
    elseif index == 5 then
        conName = "conMapEventAttackShow_SceneBattle"
        imgName = "imgMapEventAttackShow_SceneBattle"
        resName = "target_trigger.png"
    end

	local turnShow = GetElement(self.m_root,conName,WZUIContainer)

    local myTurn = GetElement(turnShow,imgName,WZUIImage)
    myTurn:setFile("common/text/"..resName)

    myTurn:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    myTurn:setRelativePositionLuaTo(0.5,0.5)
    myTurn:setVisible(true)

	turnShow:setRelativePositionLuaTo(1.5,0.5)

    local moveTo0 = WZUIActionMoveTo:create()
    moveTo0:setMoveX(1)
    moveTo0:setMoveY(0.5)
    moveTo0:setDuration(0)

	local moveTo1 = WZUIActionMoveTo:create()
	moveTo1:setMoveX(0.5)
	moveTo1:setMoveY(0.5)
	moveTo1:setDuration(0.4)

	local delay = WZUIActionDelayTime:create()
	delay:setDuration(1)

	local moveTo2 = WZUIActionMoveTo:create()
	moveTo2:setMoveX(-0.5)
	moveTo2:setMoveY(0.5)
	moveTo2:setDuration(0.4)
	moveTo2:setFinishLuaFunction("endMapEventShow")
	moveTo2:setFinishLuaTable(self)

	local sequence = WZUIActionSequence:create()
    sequence:setChildAction(moveTo0)
	sequence:setChildAction(moveTo1)
	sequence:setChildAction(delay)
	sequence:setChildAction(moveTo2)

	turnShow:setVisible(true)
	turnShow:runUIAction(sequence)

	SoundManager:playEffectSound(SoundDefine.E_S_ROUND)
end

--@brief	显示地图事件动画的结束回调
--@param	sender:回调元素
--@note
function SceneBattle:endMapEventShow(sender)
    SceneBattle.m_nMapEventShow = 0

    local index = self.m_nMapEventIndex
    local conName,imgName,resName = "conMapEventShow_SceneBattle","imgMapEventShow_SceneBattle",""
    if index >= 1 and index <= 4 then
        resName = "target_trigger_0"..index..".png"
    elseif index == 5 then
        conName = "conMapEventAttackShow_SceneBattle"
        imgName = "imgMapEventAttackShow_SceneBattle"
        resName = "target_trigger.png"
    end

    local turnShow = GetElement(self.m_root,conName,WZUIContainer)
    GetElement(turnShow,imgName):setVisible(false)
    turnShow:setVisible(false)
end

--@brief	显示回合动画的结束回调
--@param	sender:回调元素
--@note
function SceneBattle:endTurnShow(sender)
	self.m_bRunTurnShow = false

    local turnShow = GetElement(self.m_root,"conTurnShow_SceneBattle",WZUIContainer)
    turnShow:setVisible(false)
end

--@brief	判断是否正在播放回合动画
--@return	是否正在播放回合动画
--@note
function SceneBattle:isRunningTurnShow()
	return self.m_bRunTurnShow
end

--@brief	往场景根节点添加元素的方法
--@param	element:要添加的界面元素引用
--@note		这里会修改showAll属性，为了适配不同分辨率，保证界面元素不会变形
--          注: 对于主场景showAll属性已经是true的时候不用修改元素的showAll
--          小岛界面有特殊需求，所以showAll属性为false，需要修改里面元素的showAll属性
function SceneBattle:addChild(element)
    if self.m_root == nil or element == nil then
        return
    end
    if element.getLuaObjectIndex == nil or element:getLuaObjectIndex() ~= WndTeachTalk then
        element:setShowAll(true)
    end
    self.m_root:addChild(element)
end

--@brief    添加宝箱
function SceneBattle:addNewGhostBox(x, y, skillId, uniqueId)
    -- body
    WZLog("SceneBattle:addNewGhostBox", x, y, skillId, uniqueId)
    --新的幽灵宝箱刷新提示
    local hero = WBattleGlobal:getCurrent():getMyHero()

    local PosX = x/100
    local PosY = y/100

    local spineBox = WZUISpine:create()
    spineBox:setTouchEnable(false)
    spineBox:setFileJson("battle/ui/ui_box.json")
    spineBox:setFileAtlas("battle/ui/ui_box.atlas")
    spineBox:play("ui_box", true) 
    spineBox:setUseOriginSize(true)
    spineBox:setScale(0.6)
    spineBox:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    spineBox:setRelativePosition(GlobalMethod:ccp(PosX, PosY))
    spineBox:setTag(10000 + uniqueId)

    if hero:isDead() then 
        local actBlink = CCBlink:create(0.8, 3)
        spineBox:runAction(actBlink)

        MsgBoxManager:showTipBox(LocalStrings.GHOSTBATTLE_TEXT6)
    else
        spineBox:setOpacity(125)
    end
    WndBattleHud:setGhostSkillData(x, y, skillId, uniqueId, spineBox)

--    BattleAnimation:addCircle({x = 74,y = 0}, 0.6 * 148 * 2/5, {r = 1,g = 1,b = 1,a = 1}, spineBox)
    SceneBattle:getFrontLayer():addChild(spineBox)
end

--@brief   拾取或销毁后，移除宝箱
--@param   status : 状态. 1成功 2非幽灵 3数量超过上限，摧毁宝箱 4没找到对应的幽灵技能
function SceneBattle:removeGhostBox(status, uniqueId, skillId, playerId)
    --body
    local hero = WBattleGlobal:getCurrent():getMyHero()
    if hero.m_nPlayerId == playerId then 
        if hero.m_bIsDead then 
            if status == 1 then
                --移除保存的地图幽灵宝箱
                WndBattleHud:removeGhostSkillData(uniqueId)

                if SceneBattle:getFrontLayer():getChildByTag(10000 + uniqueId) then 
                    SceneBattle:getFrontLayer():removeChildByTag(10000 + uniqueId, true)
                end
                --技能个添加拾取的宝箱
                if WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.id == nil then
                    local id={}
                    local name={}
                    local icon={}
                    local lv={}
                    local priceCostGold={}
                    local desc={}
                    local itemMainType={}
                    local itemSubType={}
                    local param1={}
                    local param2={}
                    local tireValue={}
                    local consumePower={}
                    local specialAttackType={}
                    local specialAttackParam={}
                    local effectId={}
                    local coolSkillTime = {}
                    local startCoolSkillTime = {}
                    local skillUniqueId = {}
                    local choose = {}

                    table.insert(id, skillId)
                    local itemInfo = {name = 0, icon = 0, lv = 0, desc = 0, type = 0, subType = 0, parm1 = 0, parm2 = 0, consume = 0, specialAttackType = 0, specialAttackParam = 0, effect_id = {{-1}},cooling_time = 0,start_time=0,}
                    if skillId > 0 and GDatatab_skill["id_"..skillId] then
                        itemInfo = GDatatab_skill["id_"..skillId]
                    end
                    table.insert(name,itemInfo.name)
                    table.insert(icon,itemInfo.icon == -1 and "battleitems/pound.png" or itemInfo.icon)
                    table.insert(lv,itemInfo.lv_icon == -1 and "battleitems/battle_icon_jnl1.png" or itemInfo.lv_icon)
                    table.insert(priceCostGold,0)
                    table.insert(consumePower,itemInfo.consume)
                    table.insert(specialAttackType,itemInfo.specialAttackType)
                    table.insert(specialAttackParam,itemInfo.specialAttackParam)
                    table.insert(effectId,itemInfo.effect_id[1][1])
                    table.insert(itemSubType,itemInfo.sub_type)
                    table.insert(skillUniqueId, uniqueId)
                    table.insert(choose, itemInfo.choose)

                    WndBattleHud:setGhostSkillSign(1, 1)
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning = {count=3, id=id, name=name, icon=icon,lv=lv, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam, effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime, skillUniqueId = skillUniqueId, choose = choose}
                else
                    local nIndex = 1
                    for i = 1, 3 do
                        if WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.id[i] == nil or WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.id[i] <= 0 then
                            nIndex = i
                            break 
                        end
                    end
                    local skill = GDatatab_skill["id_"..skillId]

                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.id[nIndex] = skillId
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.name[nIndex] = skill.name
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.icon[nIndex] = skill.icon == -1 and "battleitems/pound.png" or skill.icon
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.lv[nIndex] = skill.lv_icon == -1 and "battleitems/battle_icon_jnl1.png" or skill.lv_icon
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.priceCostGold[nIndex] = 0
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.desc[nIndex] = 0
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.itemMainType[nIndex] = skill.skill_type
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.itemSubType[nIndex] = skill.sub_type
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.consumePower[nIndex] = skill.consume
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.specialAttackType[nIndex] = skill.specialAttackType
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.specialAttackParam[nIndex] = skill.specialAttackParam
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.effectId[nIndex] = skill.effect_id[1][1]
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.coolSkillTime[nIndex] = skill.cooling_time
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.startCoolSkillTime[nIndex] = skill.start_time
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.skillUniqueId[nIndex] = uniqueId
                    WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.choose[nIndex] = skill.choose

                    WndBattleHud:setGhostSkillSign(nIndex, 1)
                end
                WZLog("SceneBattle:removeGhostBox", Serialize(WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning))
                WndBattleHud:resetGhostSkill()
            elseif status == 3 then --销毁宝箱
                --移除保存的地图幽灵宝箱
                WndBattleHud:removeGhostSkillData(uniqueId)
                if SceneBattle:getFrontLayer():getChildByTag(10000 + uniqueId) then 
                    SceneBattle:getFrontLayer():removeChildByTag(10000 + uniqueId, true)
                end 
            elseif status == 4 then 
                MsgBoxManager:showTipBox(LocalStrings.GHOSTBATTLE_TEXT5)
                WndBattleHud:removeGhostSkillData(uniqueId)
                if SceneBattle:getFrontLayer():getChildByTag(10000 + uniqueId) then 
                    SceneBattle:getFrontLayer():removeChildByTag(10000 + uniqueId, true)
                end 
            else
                WndBattleHud:removeGhostSkillData(uniqueId)
                if SceneBattle:getFrontLayer():getChildByTag(10000 + uniqueId) then 
                    SceneBattle:getFrontLayer():removeChildByTag(10000 + uniqueId, true)
                end 
            end
        end
    else
        if status == 1 or status == 3 then 
            --移除保存的地图幽灵宝箱
            WndBattleHud:removeGhostSkillData(uniqueId)

            if SceneBattle:getFrontLayer():getChildByTag(10000 + uniqueId) then 
                SceneBattle:getFrontLayer():removeChildByTag(10000 + uniqueId, true)
            end 
        else
            WndBattleHud:removeGhostSkillData(uniqueId)
            if SceneBattle:getFrontLayer():getChildByTag(10000 + uniqueId) then 
                SceneBattle:getFrontLayer():removeChildByTag(10000 + uniqueId, true)
            end 
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	初始化地图
--@note		加载地图，设置地图界面
function SceneBattle:_initMap()
    WZLog("SceneBattle:_initMap 1")
	BattleMapManager:addBgMap(self:getBgLayer())
    WZLog("SceneBattle:_initMap BattleMapManager:addBgMap")
	BattleMapManager:addMidMap(self:getMidLayer())
    WZLog("SceneBattle:_initMap BattleMapManager:addMidMap")
	BattleMapManager:addFrontMap(self:getFrontLayer())
    WZLog("SceneBattle:_initMap BattleMapManager:addFrontMap")
    if WBattleGlobal:getCurrent():isFog() then
    --     BattleMapManager:addFogMap(self:getFogLayer())
            self:getInfoLayerBlack():setVisible(true)
    end

    WBattleGlobal:getCurrent():initCleanFog()
end

--@brief	进入战斗后的前景调整
--@note
function SceneBattle:_initShowFront()

	--镜头参数初始化

	local dZoom = BattleMapManager:getFrontControl():getZoomInInit() - BattleMapManager:getFrontControl():getZoomOutInit()
	BattleScreen.m_nFollowBulletScale = (dZoom * 0.25 + BattleMapManager:getFrontControl():getZoomOutInit()) - 0.1
	BattleScreen.m_nNormalScale = BattleMapManager:getFrontControl():getZoomInInit() - 0.2
	BattleScreen.m_nLastScale = BattleScreen.m_nZoomOutInit
	BattleScreen.m_nLastScreenPos = WBattleGlobal:getCurrent():getMyHero():getAnimation():getPosition()
	WZLog("SceneBattle:_initShowFront",BattleMapManager:getFrontControl():getZoomOutInit(),BattleMapManager:getFrontControl():getZoomInInit(), BattleScreen.m_nFollowBulletScale,BattleScreen.m_nNormalScale, BattleScreen.m_nLastScale)
	self:getFrontLayer():setScale(BattleMapManager:getFrontControl():getZoomOutInit())
    WZLog("BattleScreen:setScale 6", WBattleGlobal:getCurrent().m_tFirstPos.y)
	BattleMapManager:getFrontControl():centerOnPoint({x = WBattleGlobal:getCurrent().m_tFirstPos.x , y = WBattleGlobal:getCurrent().m_tFirstPos.y })
    -- if WBattleGlobal:getCurrent():isFog() then
    --     BattleMapManager:getFogControl():centerOnPoint({x = WBattleGlobal:getCurrent().m_tFirstPos.x , y = WBattleGlobal:getCurrent().m_tFirstPos.y })
    -- end
end

--@brief    角色闪烁
function SceneBattle:_heroBlink(element)
    -- body
    element:disableSchedule()

    for i, hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        local nCamp = hero:getCamp()
        if nCamp == 1 then 
            local actBlink = CCBlink:create(1.2, 3)
            hero:getAnimation():getAnimNode():runAction(actBlink)
            break
        end
    end

    SceneBattle:getInfoLayer2():enableSchedule("_doEndCurRound", 1.21)
end

--@brief    执行结束回合步骤
function SceneBattle:_doEndCurRound(element)
    -- body
    WZLog("SceneBattle:_doEndCurRound")
    element:disableSchedule()
    --设置怪物形象
    local heroTemp 
    local heroMonster = WBattleGlobal:getCurrent():getHeroMonster()
    for i, hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
        local nCamp = hero:getCamp()
        if nCamp == 1 then 
            local x = WBattleGlobal:getCurrent().m_tPlayerBornPt[hero:getBattleId()].x
            local y = WBattleGlobal:getCurrent().m_tPlayerBornPt[hero:getBattleId()].y
            if hero.m_bCanControl == true then 
                heroMonster.m_bCanControl = true
                heroMonster.m_nAiCtrlId = 1
                heroMonster:buildAiCombination()
            end
            if hero:getAnimation():getAnimNode() then
                hero:getAnimation():getAnimNode():setVisible(false)
                hero:getAnimation():getAnimNode():removeFromParentAndCleanup(true)
            end
            if hero:getPlayerNameIcon() then                
                hero:getPlayerNameIcon():destroy()
                hero:setPlayerNameIcon(nil)
            end
            if hero:getPet() then
                if hero:getPet():getAnimation() then
                    hero:getPet():getAnimation():getAnimNode():setVisible(false)
                end
                hero:setPet(nil)
            end
        --    hero:destroy()

            WBattleGlobal:getCurrent():setHeroWithId(i, heroMonster)
            heroMonster.m_anim:getAnimNode():retain()
        --    heroMonster.m_anim:getAnimNode():setScale(1)
            heroMonster.m_anim:play("wait0", true)
            if heroMonster:getAnimation():getAnimNode() then
                heroMonster:getAnimation():getAnimNode():setVisible(true)
            end
            local bSameCamp = WBattleGlobal:getCurrent():isMyTeam(heroMonster:getBattleId())
            local playerName = BattleHeroName:create(heroMonster, self:getInfoLayer(), bSameCamp)
            heroMonster:setPlayerNameIcon(playerName)
            playerName:update()

            if WBattleGlobal:getCurrent().m_tTouchCircle and heroMonster:getBattleId() == WBattleGlobal:getCurrent():getMyBattleId() then 
                WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode():setVisible(true)
                heroMonster:getAnimation():getAnimNode():addChild(WBattleGlobal:getCurrent().m_tTouchCircle:getAnimNode())
            end

            heroMonster:showAttWord({x = x, y = y + 210})

            WndBattleHud:setMyHero(WBattleGlobal:getCurrent():getMyHero())
            SceneBattle:getInfoLayer2():enableSchedule("_doSendEndCurRound", 3)
            break 
        end
    end
end

--@brief    执行结束回合步骤
function SceneBattle:_doSendEndCurRound(element)
    --body
    element:disableSchedule()

    WBattleGlobal:getCurrent():endCurRound(WBattleGlobal:getCurrent():getMyBattleId(),99,nil,nil,true)
end
-------------------------------------私有方法模块End----------------------------------------
