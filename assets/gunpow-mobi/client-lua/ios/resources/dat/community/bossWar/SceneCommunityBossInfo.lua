--SceneCommunityBossInfo.lua
--@brief	SceneCommunityBossInfo的UI模块
--@date		2017/01/21
--@note		公会boss信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCommunityBossInfo:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    self:addTop()

    ProtocolProcessorCommunityBossRoom:regAll()
    ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildBossInfo()
    self:createLoading()

    pushEquipInList()
    g_bIsShowWndDressUp = true
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCommunityBossInfo:onExit(element)
	--add by wuweidong
	ProtocolProcessorCommunityBossRoom:unregAll()
	self:_unInit()
end


function SceneCommunityBossInfo:onCloseClick()
    WZLog("SceneCommunityBossInfo:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    replaceScene(SceneCommunityCopy:createElement())
end

-- 点击物品后的回调
function SceneCommunityBossInfo:onClickListItem(tItem, nTag, tData)
    WZLog("SceneCommunityBossInfo:onClickListItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false, nil,true)
end

--公会副本伤害排行
function SceneCommunityBossInfo:onRank(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCommunityCopyRank:show(SceneCommunityBossInfo.m_nCopyId) 
end

--@brief 鼓舞
function SceneCommunityBossInfo:onInspireBtn()
    WZLog("SceneCommunityBossInfo:onInspireBtn")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local addOnceHurt = tonumber(CacheCenter:getGameParam().guildBossInspireAdd)

    self.m_nLeftInspire = (tonumber(CacheCenter:getGameParam().guildBossMaxHurtAdd) - self.m_tData.hurtAdd)/addOnceHurt
    if self.m_nLeftInspire <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.GUILD_BOSS_INSPIRE_FULL)
        return
    end
    WndCommunityBossInspire:showWnd(self.m_tData.hurtAdd,self.m_nCopyId)
end

--@brief   是否补充活力值回调
function SceneCommunityBossInfo:needMoreEnergy(id,nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(1056) 
    end
end

--@brief 挑战
function SceneCommunityBossInfo:onFightBtn()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self.m_nCopyId then
        return
    end
    local gampeParam = CacheCenter:getGameParam()
    if self.m_tData.playTimes >= tonumber(gampeParam.guildBossDareTimes)  then
        MsgBoxManager:showTipBox(LocalStrings.CHALLEGE_OVER)
        return
    end
    if self.m_nFightCost and CacheCenter:getPlayerInfo().vigor < self.m_nFightCost then
        judgeNotEnoughJump(self, self.needMoreEnergy)
        return
    end
    self:createLoading()
    ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildMakePair(self.m_nCopyId)
end

-- 开始挑战
function SceneCommunityBossInfo:receiveMakePairOk(battleId, mapId, playerCount, 
    playerId, playerName, playerTitle, playerGuild, playerLevel, playerSex,
    maxHP, maxPF, maxSP, attack, critRate, defence, 
    injuryFree, wreckDefense, reduceCrit, power, armor,constitution, 
    agility, lucky, inspire, headId, faceId, bodyId, 
    weaponId, wingId, item_id, playerBuffCount,buffId, petId, 
    petSkill, petParam, guaiBattleId, guaiId, guaiMaxHP, guaiNowHP,
    guaiAtk,weaponSkill,petLevel, colour, bodyColour)
    self:closeLoading()

    WZLog("SceneCommunityBossInfo:receiveMakePairOk")

  
    WBattleGlobal:getCurrent():destroy()
    WBattleGlobal:getCurrent().m_tMakePairOk ={
        battleId=battleId,battleMode=BattleConstants.g_tBossBattleMode.MODEL_GUILD_STATE, battleMull=false, battleChannle=-1,
        mapId=mapId,playerCount=playerCount,playerId=playerId,playerName=playerName,playerTitle=playerTitle,playerCommunity=playerGuild,
        playerLevel=playerLevel,playerSex=playerSex,maxHP=maxHP,maxPF=maxPF,maxSP=maxSP,attack=attack,critRate=critRate,defence=defence,
        injuryFree=injuryFree,wreckDefense=wreckDefense,reduceCrit=reduceCrit,power=power,armor=armor,constitution=constitution,agility=agility,
        lucky=lucky,inspire=inspire,headId=headId,faceId=faceId,bodyId=bodyId,weaponId=weaponId,wingId=wingId,item_id=item_id,playerBuffCount,
        buffId=buffId,petId=petId,petSkill = petSkill,petLevel=petLevel,petSkillId=petId,petParam=petParam,guaiBattleId=guaiBattleId,guaiId=guaiId,guaiMaxHP=guaiMaxHP,guaiNowHP=guaiNowHP,guaiAtk=guaiAtk,weaponSkill=weaponSkill, colour=colour, bodyColour=bodyColour
    }
    WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_BOSS
    WBattleGlobal:getCurrent().battleMode = BattleConstants.g_tBossBattleMode.MODEL_GUILD_STATE

    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    replaceScene(SceneBattleLoading:createElement())
    --@brief   关闭加载框
    self:closeLoading()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@breif 创建界面
function SceneCommunityBossInfo:_initView()
	local template = GDatatab_guild_boss_map["id_"..self.m_nCopyId]
    if not template then
        return
    end
    local monsterId = template.monster[1][1]
    local monsterTmp = GDatatab_monster["id_"..monsterId]
	self.m_nBossMaxHp = monsterTmp.hp

    if self.m_tMonster then
        self.m_tMonster:getAnimNode():removeFromParentAndCleanup()
        self.m_tMonster = nil
    end
    self.m_tMonster = BattleAnimation:createAnimation(monsterTmp.AniFileId, false, "battle/monster")
    self.m_tMonster:play("wait",true)
    self.m_tMonster:setScale(template.scale/100)
	GetElement(self.m_root, "conBossAni_SceneCommunityBossInfo", WZUIContainer):addChild(self.m_tMonster:getAnimNode())

	local bossName = GetElement(self.m_root, "labBossName_SceneCommunityBossInfo",WZUILabelTTF)
	bossName:setText(monsterTmp.name)

    GetElement(self.m_root, "labBossDes_SceneCommunityBossInfo",WZUILabelTTF):setText(monsterTmp.script)

	local fightCost = GetElement(self.m_root,"labFightCost_SceneCommunityBossInfo",WZUILabelTTF)
	fightCost:setText(string.format(LocalStrings.GUILD_BOSS_FIGHT_COST,template.cost))
    self.m_nFightCost = template.cost

    local conTabItem = GetElement(self.m_root, "conTabItem_WndCommunityBossWarRank", WZUITableContainer)
    conTabItem:cleanTable()

    local tDropData = template.reward[1]

    
    if tDropData then
        local list = {}
        for i = 1 ,#tDropData do
            local info = {}
            info.id = tDropData[i]
            local tmp = GDatatab_item["id_"..info.id]
            info.quality = tmp and tmp.quality or 1
            table.insert(list,info)
        end
        local sortFunc = function(a, b) return a.quality > b.quality end
        table.sort(list , sortFunc)
       
        for i = 1 ,#list do
            local eItem, tItem = self:_createCellGoodItem(list[i].id)
            eItem:setTag(i-1)
            conTabItem:setCellElement(eItem)
        end
    end
end

--@brief 更新界面
	-- sectionId : 挑战中章节ID
	-- bossId : 关卡Id
	-- bossHp : Boss当前血量
	-- hurtAdd : 当前伤害加成
	-- cheerId : 鼓舞玩家ID
	-- cheerName : 鼓舞玩家名称
	-- cheerCost : 鼓舞花费钻石数
	-- playTimes : 今日挑战次数
	-- todayGain : 公会货币今日收获数量
	-- weekHurt : 本周伤害输出
	-- reward : 已领取的周奖励ID
	-- fighterNum:正在挑战玩家数
function SceneCommunityBossInfo:_updateView(data)
    self.m_tData = data
	local prg = GetElement(self.m_root, "proHp_SceneCommunityBossInfo", WZUIProgress)
    prg:setPercentage(math.min(data.bossHp*100/self.m_nBossMaxHp, 100))

    local txtExp = GetElement(self.m_root, "labProHp_SceneCommunityBossInfo", WZUILabelTTF)
    txtExp:setText(math.floor(data.bossHp).."/"..self.m_nBossMaxHp)
    --挑战人数
    GetElement(self.m_root, "labFighterNum_WndCommunityBossWarRank", WZUILabelTTF):setText(string.format(LocalStrings.GUILD_BOSS_FIGHTER,data.fighterNum))
    --攻击加成
    GetElement(self.m_root, "labHurtPerc_SceneCommunityBossInfo", WZUILabelTTF):setText(string.format(LocalStrings.GUILD_BOSS_HURT_PRE,data.hurtAdd))

    local conTabPlayer = GetElement(self.m_root, "conTabPlayer_WndCommunityBossWarRank", WZUITableContainer)
    conTabPlayer:cleanTable()

    local conForPlayer = GetElement(self.m_root, "conForPlayer_WndCommunityBossWarRank", WZUIContainer)
    if data.cheerId == nil or #data.cheerId == 0 then
        ShowPanelNullTip(conForPlayer)
    else
        removeShowPanelNullTip(conForPlayer)
        for i = 1 ,#data.cheerId do
            local eItem, tItem = CellCommunityBossInspire:createElement()
            eItem:setTag(i-1)
            conTabPlayer:setCellElement(eItem)
            tItem:setData({name = data.cheerName[i],cost = data.cheerCost[i]})
        end
    end
end

-- 创建一个掉落物品
function SceneCommunityBossInfo:_createCellGoodItem(nItemId)
    WZLog("SceneCommunityBossInfo:_createCellGoodItem",nItemId)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setScale(0.8)
    --tItem:setFromTag(nIndex-1)
    tItem:setItemClickFun(self, self.onClickListItem)
    local tData = {
        id = nItemId,
        isUse = false,
        data = "",
        playerItemId = -1,
        basicInfo = GetItemLocalData(nItemId)
    }
    tItem:setCellGoodItem(tData, 2)
    return eItem, tItem
end

--------------------------------------------语言适配Begin------------------------------
function SceneCommunityBossInfo:_adaptLanguage_en(  )
    local txtItem = GetElement(self.m_root,"txtItem_SceneCommunityBossInfo",WZUILabelTTF)
    txtItem:setRelativePosition(GlobalMethod:ccp(0.23,0.597627))
    local txtDescHurt = GetElement(self.m_root,"txtDescHurt_SceneCommunityBossInfo",WZUILabelTTF)
    txtDescHurt:setFontSize(15)
end

function SceneCommunityBossInfo:_adaptLanguage_vn(  )
    local labBossName = GetElement(self.m_root,"labBossName_SceneCommunityBossInfo",WZUILabelTTF)
    labBossName:setScale(0.8)
    local labFightCost = GetElement(self.m_root,"labFightCost_SceneCommunityBossInfo",WZUILabelTTF)
    labFightCost:setScale(0.8)
    local txtDescHurt = GetElement(self.m_root,"txtDescHurt_SceneCommunityBossInfo",WZUILabelTTF)
    txtDescHurt:setFontSize(15)
end

function SceneCommunityBossInfo:_adaptLanguage_pt(  )
    local txtDescHurt = GetElement(self.m_root,"txtDescHurt_SceneCommunityBossInfo",WZUILabelTTF)
    txtDescHurt:setScale(0.8)

    GetElement(self.m_root,"txtBtn1_SceneCommunityBossInfo",WZUILabelTTF):setScale(0.6)
    GetElement(self.m_root,"txtBtn2_SceneCommunityBossInfo",WZUILabelTTF):setScale(0.6)
    
    local txtItem = GetElement(self.m_root,"txtItem_SceneCommunityBossInfo",WZUILabelTTF)
    txtItem:setScale(0.8)
    txtItem:setRelativePosition(GlobalMethod:ccp(0.259764,0.597627))
    local labFighterNum = GetElement(self.m_root, "labFighterNum_WndCommunityBossWarRank", WZUILabelTTF)
    labFighterNum:setScale(0.8)
    labFighterNum:setRelativePosition(GlobalMethod:ccp(0.708396,0.596203))

    local labBossName = GetElement(self.m_root,"labBossName_SceneCommunityBossInfo",WZUILabelTTF)
    labBossName:setScale(0.8)
    labBossName:setDimensions(GlobalMethod:CCSize(150))
    local labFightCost = GetElement(self.m_root,"labFightCost_SceneCommunityBossInfo",WZUILabelTTF)
    labFightCost:setScale(0.8)
end

function SceneCommunityBossInfo:_adaptLanguage_es(  )
    local txtItem = GetElement(self.m_root,"txtItem_SceneCommunityBossInfo",WZUILabelTTF)
    txtItem:setScale(0.7)
    txtItem:setRelativePosition(GlobalMethod:ccp(0.25,0.597627))

    local labFighterNum = GetElement(self.m_root, "labFighterNum_WndCommunityBossWarRank", WZUILabelTTF)
    labFighterNum:setScale(0.7)

    local labBossName = GetElement(self.m_root,"labBossName_SceneCommunityBossInfo",WZUILabelTTF)
    labBossName:setScale(0.6)

    local labFightCost = GetElement(self.m_root,"labFightCost_SceneCommunityBossInfo",WZUILabelTTF)
    labFightCost:setScale(0.6)

    GetElement(self.m_root,"labHurtPerc_SceneCommunityBossInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtDescHurt_SceneCommunityBossInfo",WZUILabelTTF):setFontSize(10)

    for i=1,2 do
        local txtBtn = GetElement(self.m_root,"txtBtn"..i.."_SceneCommunityBossInfo",WZUILabelTTF)
        txtBtn:setDimensions(GlobalMethod:CCSize(130,0))
        txtBtn:setScale(0.8)
    end
end

function SceneCommunityBossInfo:_adaptLanguage_tr(  )
    -- local txtItem = GetElement(self.m_root,"txtItem_SceneCommunityBossInfo",WZUILabelTTF)
    -- txtItem:setScale(0.7)
    -- txtItem:setRelativePosition(GlobalMethod:ccp(0.25,0.597627))

    -- local labFighterNum = GetElement(self.m_root, "labFighterNum_WndCommunityBossWarRank", WZUILabelTTF)
    -- labFighterNum:setScale(0.7)

    local labBossName = GetElement(self.m_root,"labBossName_SceneCommunityBossInfo",WZUILabelTTF)
    labBossName:setScale(0.7)

    local labFightCost = GetElement(self.m_root,"labFightCost_SceneCommunityBossInfo",WZUILabelTTF)
    labFightCost:setScale(0.63)

    for i=1,2 do
        local txtBtn = GetElement(self.m_root,"txtBtn"..i.."_SceneCommunityBossInfo",WZUILabelTTF)
        txtBtn:setDimensions(GlobalMethod:CCSize(130,0))
        txtBtn:setScale(0.8)
    end
end
--------------------------------------------语言适配End-------------------------------