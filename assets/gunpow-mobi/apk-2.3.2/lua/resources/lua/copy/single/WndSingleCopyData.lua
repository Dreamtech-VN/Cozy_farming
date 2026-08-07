--WndSingleCopyData.lua
--@brief	WndSingleCopy的数据模块
--@date		2015/04/09
--@author	xiaoyu_wu
--@note		单人副本

WndSingleCopy = {
	--请不要在这里定义变量
}

WndSingleCopy.__index = WndSingleCopy

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSingleCopy:_init()
	self.m_root = nil	 	  			--场景根节点
    
    self.m_tCopyData = nil              --副本数据，key为副本序号，value为副本里所有关卡信息列表
    self.m_tCommonCopyData = nil        --普通副本模式
    self.m_tEliteCopyData = nil         --精英副本模式
    self.m_tDevilCopyData = nil
    self.m_nCopyType =1             --单人副本打开默认是普通模式
    self.m_nCurCopyId = 0               --玩家当前副本进度关卡id       
    self.m_nCurCopyIndex = 0            --玩家当前副本序号
    self.m_nCurLevelIndex = 0           --玩家当前关卡序号
    
    self.m_nCurPageIndex = -1           --当前页数 从0开始，每页有10个关卡
    self.m_nInitPageIndex = nil         --初始页数  

    self.m_tSectionReward = nil         --章节奖励表
    self.m_tSectionStarNum = nil        --章节星星数量表
    self.m_tSectionStarNum1 = nil        --普通章节星星数量表
    self.m_tSectionStarNum2 = nil        --精英章节星星数量表
    self.m_tSectionStarNum3 = nil        --地狱章节星星数量表
    
    self.m_tLevelObjList = nil          --关卡列表，key为副本序号，value为副本里所有关卡对象列表
    self.m_bLoadFinish = true          
    self.m_nTotalStar = 0
    self.m_nCurStar = 0
    self.m_tEquipArmatures = {}
    self.m_nLoadCountPage = 0
    self.m_oPageCon = nil
    self.m_nLoadingId = nil
    self.m_nHashLoadMap = 0
    self.m_bInitFinish = false
    self.m_oCurPage = nil
    self.m_tCopyCellT = {}
    self.m_tAllCopyCell = {}       --存放小关卡的table
    self.m_nTaskCellId = nil
    self.m_bGetRewardItems = false
--    self.m_nJumpPageIndex = nil
    self.m_tFirstCellTreasureBox = nil
    self.m_tCellArmList = {}
    self.m_bShowCopyLevelInfo = nil  --加载完地图后是否需要可以显示关卡信息
    self.m_luaCell = nil
    self.m_nIndex = 0
    self.m_nPlaySoundeId = nil
    self.m_tIslandHostId = nil  --已占岛Id
    self.m_tIslandAssistId = nil    --助战岛id

    self.m_tSectionListData = nil  --可以打的副本章节
    self.m_tCellSectionSel = nil 
    self.m_bIsGettingReward = false 
    self.m_tCellSectionItem = nil 

    self.m_tButtonTipsAnim1 = nil  --按钮引导1
    self.m_tButtonTipsDialog1 = nil --按钮引导1
    self.m_tButtonTipsAnim2 = nil  --按钮引导2
    self.m_tButtonTipsDialog2 = nil --按钮引导2
    self.checkTag = 1
    
    self.m_nJumpIsland = nil        --打开岛主挑战界面
end 


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSingleCopy:_unInit()
	self.m_root = nil
    
    self.m_tCopyData = nil
    self.m_nCopyType = nil
    self.m_tEliteCopyData = nil
    self.m_tDevilCopyData = nil
    self.m_nCurCopyId = 0
    self.m_nCurLevelIndex = 0
    
    self.m_nCurPageIndex = nil
    self.m_nInitPageIndex = nil
    
    self.m_tSectionReward = nil
    self.m_tSectionStarNum = nil
    self.m_tSectionStarNum1 = nil
    self.m_tSectionStarNum2 = nil
    self.m_tSectionStarNum3 = nil
    self.m_nCurCopyIndex = nil
    self.m_tLevelObjList = nil
    self.m_tEquipArmatures = nil
    self.m_nTotalStar = nil
    self.m_nCurStar = nil
    self.m_bLoadFinish = nil  
    self.m_nLoadCountPage = nil   
    self.m_oPageCon = nil
    self.m_nLoadingId = nil
    self.m_nHashLoadMap = nil
    self.m_bInitFinish = nil
    self.m_oCurPage = nil
    self.m_tCopyCellT = nil
    self.m_tAllCopyCell = nil
    self.m_bGetRewardItems = nil
    self.m_bLoadMapFinish = nil
    self.m_nJumpPageIndex = nil
    self.m_nTaskCellId = nil
    self.m_tFirstCellTreasureBox = nil
    self.m_tCellArmList = nil
    self.m_bShowCopyLevelInfo = nil
    self.m_luaCell = nil
    self.m_nIndex = nil
    self.m_nPlaySoundeId = nil
    self.m_tIslandHostId = nil  --已占岛Id
    self.m_tIslandAssistId = nil    --助战岛id

    self.m_tSectionListData = nil 
    self.m_tCellSectionSel = nil 
    self.m_bIsGettingReward = nil 
    self.m_tCellSectionItem = nil 

    self.m_tButtonTipsAnim1 = nil
    self.m_tButtonTipsDialog1 = nil
    self.m_tButtonTipsAnim2 = nil
    self.m_tButtonTipsDialog2 = nil
    self.checkTag = nil

    self.m_nJumpIsland = nil        --打开岛主挑战界面
end


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSingleCopy:createElement()
	local element = WZUISystem:getInstance():createElement("WndSingleCopy")
	assert(element, "WndSingleCopy create element failed!")
	self:_init()
	return element
end

--@brief	设置初始显示哪个副本
--@param	nMapGroup,副本序号
function WndSingleCopy:setInitPageIndex(nMapGroup)
    WZLog("WndSingleCopy:setInitPageIndex")
    if nMapGroup then
        self.m_nInitPageIndex = nMapGroup-1
    end
end

--@brief 设置任务跳转的章节
function WndSingleCopy:setJumpPageIndex(pageIndex)
    WZLog("WndSingleCopy:setJumpPageIndex = ",pageIndex)
    if pageIndex ~= nil then
        self.m_nJumpPageIndex = GDatatab_single_map["id_" .. pageIndex].section
        pageIndex = tonumber(pageIndex)
        self.m_nTaskCellId = pageIndex
    end
end

--设置章节ID
function WndSingleCopy:setCurChapterID(chapterID,bShowTip)
    -- body
    WZLog("WndSingleCopy:setCurChapterIndex ",chapterID)
    if CopyManager:bJumpToSingleCopyByChapter(chapterID) then
        self.m_nJumpPageIndex = chapterID
    else
        if bShowTip then
            MsgBoxManager:showTipBox(LocalStrings.COPY_CHAPTER_NOT_OPEN_TIP)
        end
        self.m_nJumpPageIndex = nil
    end
end

--@brief	根据副本id获取星星数
--@param	nId,副本id
--@return   #1,星星数
--@return   #2,条件状态数组
function WndSingleCopy:getStarNumById(nId)
    WZLog("WndSingleCopy:getStarNumById")
    local nStarNum = 0
    local tSingleCopyData = CacheCenter:getSingleCopyData() or {}
    local tBits = {}
    local temp = nil
    local bTemp = false
    local factor = 0
    temp = GDatatab_single_map["id_" .. nId]
    if temp.map_type == 3 then --地獄副本特殊處理
        bTemp = true
    end
    if bTemp == false then
        for i=1,#tSingleCopyData do
            if tSingleCopyData[i].pointId == nId then
                tBits = NumberToBits(tSingleCopyData[i].factor, 3)
                break
            end
        end
    else
        for i=1,#tSingleCopyData do
            local tempInfo = tSingleCopyData[i].pointId
            WZLog("tempInfo=",tempInfo)
            if tempInfo > 0 then
                local tempp =  GDatatab_single_map["id_" .. tempInfo]
                if tempp ~= nil and  tempp.idgroup == temp.idgroup and tempp.section == temp.section  then
                    factor = factor + 1
                end
            end
        end

        if factor == 3 then
            factor = 7
        elseif factor == 2 then
            factor = 3
        elseif factor > 0 then
            factor = 1
        end
        tBits = NumberToBits(factor, 3)
    end
    
    nStarNum = (tBits[1] or 0) + (tBits[2] or 0) + (tBits[3] or 0)
    
    return nStarNum, {tBits[1] or 0, tBits[2] or 0, tBits[3] or 0}
end

--@brief	领取章节奖励成功
--@param    sectionId : 章节ID
--@param    rewardNum : 领取的奖励数1位奖励一，2位奖励二，3位奖励三
--@param    rewardId : 奖励物品id
--@param    rewardCount : 奖励物品数量
function WndSingleCopy:getSectionRewardOK(sectionId, rewardNum, rewardId, rewardCount)
    WZLog("WndSingleCopy:getSectionRewardOK")
    if self.m_root == nil then return end
    self:_postGetBoxRewardEvent()
    
    WndRewardShow:showById(rewardId,rewardCount)
    self.m_bGetRewardItems = false
    self:_updateBoxReward(self.m_nCurPageIndex+1)
    --领取宝箱后，刷新章节列表红点
    self:afterBoxUpdateReDot(sectionId)
end

--@brief	跳转到单人副本战斗
--@note		获取所有信息
function WndSingleCopy:receiveStartChallengeOk(mapId, mapType, itemId)
    WZLog("WndSingleCopy:receiveStartChallengeOk id:", tostring(mapId), "type:", tostring(mapType))

    local battleId, playerCount, playerId, playerName, playerTitle, playerCommunity, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, reduceBury, power, armor, constitution, agility, lucky, headId, faceId, bodyId, weaponId, wingId, item_id, playerBuffCount, buffId, petId, petSkillId, petParam, guaiBattleId, guaiId ,item_id

    local battleMode = BattleConstants.g_tBossBattleMode.MODE_SINGLE_STAGE

    local tempFetterType = mapType
    if mapType == COPYTYPE_SINGLE then
        battleMode = BattleConstants.g_tBossBattleMode.MODE_SINGLE_STAGE
        if GlobalGame.g_nSingleCopyType == BattleConstants.g_tBossBattleMode.MODE_NORMAL_HARD then
            battleMode = BattleConstants.g_tBossBattleMode.MODE_NORMAL_HARD
        end
        
        if GlobalGame.g_nSingleCopyType == BattleConstants.g_tBossBattleMode.MODE_NORMAL_TABOO then
            battleMode = BattleConstants.g_tBossBattleMode.MODE_NORMAL_TABOO
        end
    elseif mapType == COPYTYPE_DAILY then
        tempFetterType = COPYTYPE_SINGLE
        battleMode = BattleConstants.g_tBossBattleMode.MODE_DAILY_STAGE
    elseif mapType == COPYTYPE_TOWER then
        tempFetterType = 2
        battleMode = BattleConstants.g_tBossBattleMode.MODE_TOWER_STAGE
    elseif mapType == COPYTYPE_TRAIN then
        battleMode = BattleConstants.g_tBossBattleMode.MODE_TRAIN_STAGE
    end

    WZLog("WndSingleCopy:receiveStartChallengeOk four", battleMode)
    local mapData = nil
    if battleMode == BattleConstants.g_tBossBattleMode.MODE_SINGLE_STAGE then
        mapData = GDatatab_single_map["id_"..mapId] or GDatatab_single_map["id_10101"]
    elseif battleMode == BattleConstants.g_tBossBattleMode.MODE_DAILY_STAGE then
        mapData = GDatatab_daily_map["id_"..mapId] or GDatatab_daily_map["id_1001"]
    elseif battleMode == BattleConstants.g_tBossBattleMode.MODE_TOWER_STAGE then
        mapData = GDatatab_tower_map["id_"..mapId] or GDatatab_tower_map["id_40001"]
    elseif battleMode == BattleConstants.g_tBossBattleMode.MODE_TRAIN_STAGE then
        mapData = GDatatab_train_map["id_"..mapId] or GDatatab_train_map["id_1011"]
    else
        mapData = GDatatab_single_map["id_"..mapId] or GDatatab_single_map["id_10101"]
    end

    local battleMap = mapData.resources
    local monster_data = mapData.monster

    local guai_name = {}
    local guaiBattleId = {}
    local guaiId = {}
    local guai_camp = {}
    local guaiSex = {}
    local guaiWeaponType = {}

    local count = 1
    for index,guaiInfo in pairs(monster_data) do
        table.insert(guai_name, BossData["id_"..guaiInfo[1]].name)
        table.insert(guaiSex, BossData["id_"..guaiInfo[1]].sex)
        table.insert(guaiWeaponType, BossData["id_"..guaiInfo[1]].weapon_type)
        table.insert(guaiBattleId, -1 - count)
        table.insert(guaiId, BossData["id_"..guaiInfo[1]].id)
        table.insert(guai_camp, 1)
        count = count + 1
    end

    WBattleGlobal:getCurrent():destroy()

    local equipList = CacheCenter:getEquipmentList()

    for i,v in pairs (equipList) do
        if v.maintype == 5 and v.subtype == 0 then
            headId = v.id
        elseif v.maintype == 5 and v.subtype == 1 then
            faceId = v.id
        elseif v.maintype == 5 and v.subtype == 2 then
            bodyId = v.id
        elseif v.maintype == 5 and v.subtype == 3 then
            wingId = v.id
        elseif v.maintype == 4 and (v.subtype == 0 or v.subtype == 1) then
            weaponId = v.id
        end
    end

    headId = headId or 0
    faceId = faceId or 0
    bodyId = bodyId or 0

    WZLog("WndSingleCopy:receiveStartChallengeOk five", tostring(CacheCenter:getPlayerInfo().shapeId), bodyId)
    wingId = wingId or 0
    weaponId = weaponId or 4900

    if mapId == 9999 then
        weaponId = 4912
    end

    item_id = itemId
    item_name = {[1]=0}
    item_img = {[1]=0}
    item_ConsumePower = {[1]=0}
    item_desc = {[1]=0}
    item_type = {[1]=0}
    item_subType = {[1]=0}
    item_param1 = {[1]=0}
    item_param2 = {[1]=0}
    specialAttackType = {[1]=0}
    specialAttackParam = {[1]=0}

    local weaponSkill = ""
    if CacheCenter.m_tSkill then
        for k,v in pairs(CacheCenter.m_tSkill.useSkill) do
            if weaponSkill == "" then
                weaponSkill = weaponSkill .. v
            else
                weaponSkill = weaponSkill .. "|" .. v
            end
        end
    end

    if mapId == 9999 then
        weaponSkill = ""
    end

    if CacheCenter:getPlayerInfo().shapeId > 0 then
        if WndPhantom.show == 1 then
            bodyId = 0 - CacheCenter:getPlayerInfo().shapeId
        end
    end
    if CacheCenter:getPlayerInfo().shapeSkillId > 0 then 
        weaponSkill = weaponSkill .. "|" .. CacheCenter:getPlayerInfo().shapeSkillId
    end
    --皮肤大招
    if CacheCenter:getPlayerInfo().shapeBigSkillId ~= "" then
        local tShapeBigSkill = SplitStringWithSeparator(CacheCenter:getPlayerInfo().shapeBigSkillId, ",", nil ,true)
        for i=#tShapeBigSkill, 1, -1 do
            if tShapeBigSkill[i] ~= -1 then
                weaponSkill = weaponSkill .. "|" .. tShapeBigSkill[i]
            end
        end
    end

    local nBuffIndex = 1
    local buffId = {[1]=0}
    local hp,atk,power = CacheCenter.m_tPlayerInfo.hp, math.floor(CacheCenter.m_tPlayerInfo.attack), CacheCenter.m_tPlayerInfo.force
    if mapType == COPYTYPE_TRAIN then
        nBuffIndex = nBuffIndex + 1
        buffId = {[nBuffIndex]=mapData.buffid}
        if type(mapData.attribute) == "table" then
            for i,v in pairs(mapData.attribute) do
                if v[1] == 1 then
                    hp = v[2]
                elseif v[1] == 3 then
                    atk = v[2]
                elseif v[1] == 12 then
                    power = v[2]
                end
            end
        end
    end

    if CacheCenter.m_tPlayerInfo.levelBreachId > 0 then 
        local tCurBreakData = GDatatab_level_breach["id_" .. CacheCenter.m_tPlayerInfo.levelBreachId]
        if tCurBreakData and tCurBreakData.buff_ids then 
            for i = 1, #tCurBreakData.buff_ids[1] do
                if tCurBreakData.buff_ids[1][i] ~= -1 then 
                    nBuffIndex = nBuffIndex + 1
                    buffId[nBuffIndex] = tCurBreakData.buff_ids[1][i]
                end
            end
        end
    end
    buffId[1] = nBuffIndex - 1
    WZLog("WndSingleCopy:receiveStartChallengeOk_two2",hp,atk,power, weaponSkill)

    WBattleGlobal:getCurrent():destroy()
    local colour,bodyColour = CacheCenter:getHeadAndBodyColor()
    local petAnim = CacheCenter.m_tPlayerInfo.petInfo and CacheCenter.m_tPlayerInfo.petInfo.animation or ""
    if CacheCenter.m_tPlayerInfo.petInfo and CacheCenter.m_tPlayerInfo.petInfo.petSkinItemId and CacheCenter.m_tPlayerInfo.petInfo.petSkinItemId > 0 then
        petAnim = GetPetAnimation(CacheCenter.m_tPlayerInfo.petInfo.petSkinItemId, CacheCenter.m_tPlayerInfo.petInfo.advancedLevel or 0)
    end
    local tProfessionData = CacheCenter:getProfessionData()
    local localPF = 100 
    local professionSkill = {}
    if tProfessionData and tProfessionData.professionId > 0 then 
        local sProSkill = ""
        --一转天赋
        for i = 1, #tProfessionData.talentSkill do
            local tempData = GDatatab_mage_Skill["id_" .. tProfessionData.talentSkill[i]]
            if tempData and tempData.type == 5 then 
                localPF = localPF + tempData.attribute
            end
            if i == 1 then 
                sProSkill = tostring(tProfessionData.talentSkill[i])
            else
                sProSkill = sProSkill .. "|" .. tProfessionData.talentSkill[i]
            end
        end
        --二转角色技能
        local professionSkillCount = #tProfessionData.talentSkill
        for i = 1, #tProfessionData.secondRoleTalentSkill do
            local tempData = GDatatab_mage_Skill["id_" .. tProfessionData.secondRoleTalentSkill[i]]
            if i == 1 and professionSkillCount == 0 then 
                sProSkill = tostring(tProfessionData.secondRoleTalentSkill[i])
            else
                sProSkill = sProSkill .. "|" .. tProfessionData.secondRoleTalentSkill[i]
            end
        end
        --二转宠物技能
        professionSkillCount = professionSkillCount + #tProfessionData.secondRoleTalentSkill
        for i = 1, #tProfessionData.petTalentSkill do
            local tempData = GDatatab_mage_Skill["id_" .. tProfessionData.petTalentSkill[i]]
            if i == 1 and professionSkillCount == 0 then 
                sProSkill = tostring(tProfessionData.petTalentSkill[i])
            else
                sProSkill = sProSkill .. "|" .. tProfessionData.petTalentSkill[i]
            end
        end

        professionSkill[1] = sProSkill
    end
    --玩家出战的坐骑和孩子信息
    local kidInfo = CacheCenter:getKidAssistSkillData()
    local mountInfo = CacheCenter:getMountAssistSkillData()
    local assistSkill = ""
    local childImage = ""
    if kidInfo and kidInfo.skillId and kidInfo.kidId > 0 then 
        for i, v in pairs(kidInfo.skillId) do
            if i == 1 then 
                assistSkill = assistSkill .. v
            else
                assistSkill = assistSkill .. "|" .. v
            end
        end

        childImage = kidInfo.kidHeadId .. "," .. kidInfo.kidFaceId .. "," .. kidInfo.kidBodyId
    else
        assistSkill = "-1|-1|-1"
        childImage = "0|0|0"
    end
    if mountInfo and mountInfo.skillId and mountInfo.mountId > 0 then 
        for i, v in pairs(mountInfo.skillId) do
            assistSkill = assistSkill .. "|" .. v
        end
    else
        assistSkill = assistSkill .. "|-1|-1|-1"
    end
    local m_tAddAttrNumber = self:suitAddAttr(tempFetterType)

    --拥有的主动皮肤大招
    local strShapeBigSkill = ""
    for i=1,#CacheCenter.m_tShapeBigSkillList do
        if i ~= 1 then
            strShapeBigSkill = strShapeBigSkill .. "|"
        end
        strShapeBigSkill = strShapeBigSkill .. CacheCenter.m_tShapeBigSkillList[i]
    end

    --拥有的普攻技能
    local strAttackSkill = ""
    local useShapeGroupId = CacheCenter:getPlayerInfo().useShapeGroupId
    local useShapeGroupAdvanceLevel = CacheCenter:getPlayerInfo().useShapeGroupAdvanceLevel
    local tShapeGroupInfo = GDatatab_shape_group["id_"..useShapeGroupId]
    if tShapeGroupInfo and useShapeGroupAdvanceLevel > 0 then
        local attackSkillId = tShapeGroupInfo.skill_id
        local offsetLevel = useShapeGroupAdvanceLevel - 1
        while offsetLevel > 0 do
            offsetLevel = offsetLevel - 1
            attackSkillId = GDatatab_skill["id_"..attackSkillId].upgrade_id
        end
        if attackSkillId > 0 then
            strAttackSkill = attackSkillId
        end
    end

    --攻击特效
    local tExplosionItemList = CacheCenter:getExplosionItemList()
    local blastEffect = 0
    for i=1,#tExplosionItemList do
        if tExplosionItemList[i].isUse == true then
            blastEffect = tExplosionItemList[i].id
            break
        end
    end

    --宠物装备随机属性
    local extPropertyKey = {}
    local extPropertyValue = {}
    local extPropertyCount = {}
    local tUsingPetsEquip = CacheCenter:getUsingPetsEquipList()
    local nPropertyCount = 0

    local tempProp = {}
    if CacheCenter.m_tPlayerInfo.petInfo then
        for i=1,#tUsingPetsEquip do
            for k,v in pairs(tUsingPetsEquip[i].extraInfo.randAttr) do
                if tempProp[k] == nil then
                    tempProp[k] = 0
                end
                tempProp[k] = tempProp[k] + v
            end
        end
    end
    for k,v in pairs(tempProp) do
        table.insert(extPropertyKey,tonumber(k))
        table.insert(extPropertyValue,tonumber(v))
    end
    table.insert(extPropertyCount,#extPropertyKey)

    WBattleGlobal:getCurrent().m_tMakePairOk = {
        battleMull=false,
        battleChannle=-1,
        guaiSex = guaiSex,
        guaiWeaponType = guaiWeaponType,
        battleId=1,
        battleMode=battleMode,
        mapType=mapType,

        mapId=mapId,
        playerCount=1,
        playerCamp={[1]=0},
        playerId={[1]=GlobalGame.g_tPlayerInfo.nPlayerId},
        playerName={[1]=CacheCenter.m_tPlayerInfo.name},
        playerTitle={[1]=CacheCenter.m_tPlayerInfo.title},
        playerCommunity={[1]=CacheCenter.m_tPlayerInfo.guildName},
        playerLevel={[1]=CacheCenter.m_tPlayerInfo.level},
        playerSex={[1]=CacheCenter.m_tPlayerInfo.sex},

        maxHP={[1] = math.ceil(m_tAddAttrNumber[1])},
        attack={[1] = math.ceil(m_tAddAttrNumber[3])},
        defence={[1] = math.ceil(m_tAddAttrNumber[4])},
        critRate={[1] = math.ceil(m_tAddAttrNumber[5])},
        reduceCrit={[1] = math.ceil(m_tAddAttrNumber[7])},
        constitution={[1] = math.ceil(m_tAddAttrNumber[9])},
        power={[1] = math.ceil(m_tAddAttrNumber[10])},
        armor={[1] = math.ceil(m_tAddAttrNumber[11])},
        agility={[1] = math.ceil(m_tAddAttrNumber[12])},
        lucky={[1] = math.ceil(m_tAddAttrNumber[13])},
        wreckDefense={[1] = math.ceil(m_tAddAttrNumber[19])},
        injuryFree={[1] = math.ceil(m_tAddAttrNumber[20])},     
    
        maxPF={[1]=localPF},
        maxSP={[1]=0},
        reduceBury={[1]=0},
        fighting ={[1]=CacheCenter.m_tPlayerInfo.fighting},
        winRate = {[1]=CacheCenter.m_tPlayerInfo.winNum / CacheCenter.m_tPlayerInfo.playNum},

        headId={[1]=headId},
        faceId={[1]=faceId},
        bodyId={[1]=bodyId},
        wingId={[1]=wingId},
        weaponId={[1]=weaponId},

        item_id= item_id,
        playerBuffCount = {[1]=0},
        buffId = buffId,

        petId={[1]=petAnim},
        petSkill={[1]=weaponSkill .. "|" .. (CacheCenter.m_tPlayerInfo.petInfo and CacheCenter.m_tPlayerInfo.petInfo.skill or "") .. "|" .. (CacheCenter.m_tPlayerInfo.awakeSkillId or "") .. "|" .. (strShapeBigSkill) .. "|" .. (strAttackSkill)},
        petSkillId={[1]=0},
        petParam={[1]=CacheCenter.m_tPlayerInfo.petInfo and CacheCenter.m_tPlayerInfo.petInfo.gift or 0},
        petLevel={[1]=CacheCenter.m_tPlayerInfo.petInfo and CacheCenter.m_tPlayerInfo.petInfo.advancedLevel or 0},
        guaiBattleId=guaiBattleId,
        guaiId=guaiId,
        section = mapData.section,
        colour={[1]=colour}, 
        bodyColour={[1]=bodyColour},
        footmark = {[1] = CacheCenter:getUsingFootMarkId()}, 
        professionId = {[1] = CacheCenter:getPlayerInfo().professionId},
        professionSkill = professionSkill,
        mountId = {[1] = mountInfo and mountInfo.mountId or 0}, 
        childId = {[1] = kidInfo and kidInfo.kidId or 0}, 
        childName = {[1] = kidInfo and kidInfo.kidName or ""}, 
        childSex = {[1] = kidInfo and kidInfo.kidSex or 0}, 
        childImage = {[1] = childImage}, 
        assistSkillIds = {[1] = assistSkill },
        defaultShapeBigSkill = {[1] = CacheCenter.m_tDefaultShapeBigSkill},
        blastEffect = {[1] = blastEffect},
        extPropertyKey = extPropertyKey,
        extPropertyValue = extPropertyValue,
        extPropertyCount = extPropertyCount
    }

    WZLog("WndSingleCopy:receiveStartChallengeOk two", WBattleGlobal:getCurrent().m_tMakePairOk.childImage[1])
    SceneBattleLoading:receiveGetSkillListOk(#item_id, item_id, item_name, item_img, item_ConsumePower, item_desc, item_type, item_subType, item_param1, item_param2, item_ConsumePower, item_ConsumePower, specialAttackType, specialAttackParam)
    
    SceneBattleLoading:receiveGetPropListOk(#item_id, item_id, item_name, item_img, item_ConsumePower, item_desc, item_type, item_subType, item_param1, item_param2, item_ConsumePower, item_ConsumePower, specialAttackType, specialAttackParam)
    
    WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_BOSS
    WBattleGlobal:getCurrent().battleMode = battleMode
    if self.m_nCopyType == 1 then
        GlobalGame.g_nSingleMapPage = self:getCurPage()
    elseif  self.m_nCopyType == 2 then
        GlobalGame.g_nEliteSingleMapPage = self:getCurPage()
    elseif self.m_nCopyType == 3 then
        GlobalGame.g_nDevilSingleMapPage = self:getCurPage()
    end

    if mapId == 9999 then
        GlobalGame.g_singleCopyData = WBattleGlobal:getCurrent().m_tMakePairOk
    end
    -- Add By Tianxiang_Xu 
    -- 标记如果单人副本获得装备，等返回副本界面时才弹穿上提示
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    -- End Add


    -- guaiSex,guaiWeaponType,battleMode,mapType,playerId,
    if WBattleGlobal:getCurrent():canRecordGame() then
        --录像记录
        local replayParam = {}
        -- guaiSex,guaiWeaponType,battleMode,mapType,mapId,playerId,
        replayParam.guaiSex = guaiSex
        replayParam.guaiWeaponType = guaiWeaponType
        replayParam.battleMode = battleMode
        replayParam.mapType = mapType
        replayParam.mapId = mapId
        replayParam.playerId = GlobalGame.g_tPlayerInfo.nPlayerId
        -- name,title,guildName,level,sex,hp,attack,critRate,defend,injuryFree,wreckDefense,reduceCrit,force,
        replayParam.name = CacheCenter.m_tPlayerInfo.name
        replayParam.title = CacheCenter.m_tPlayerInfo.title
        replayParam.guildName = CacheCenter.m_tPlayerInfo.guildName
        replayParam.level = CacheCenter.m_tPlayerInfo.level
        replayParam.sex = CacheCenter.m_tPlayerInfo.sex
        replayParam.hp = CacheCenter.m_tPlayerInfo.hp
        replayParam.attack = math.floor(CacheCenter.m_tPlayerInfo.attack)
        replayParam.critRate = CacheCenter.m_tPlayerInfo.critRate
        replayParam.defend = CacheCenter.m_tPlayerInfo.defend
        replayParam.injuryFree = CacheCenter.m_tPlayerInfo.injuryFree
        replayParam.wreckDefense = CacheCenter.m_tPlayerInfo.wreckDefense
        replayParam.reduceCrit = CacheCenter.m_tPlayerInfo.reduceCrit
        replayParam.force = CacheCenter.m_tPlayerInfo.force
        -- armor,physical,agility,lucky,fighting,winRate,headId,faceId,bodyId,wingId,weaponId,item_id,petId,
        replayParam.armor = CacheCenter.m_tPlayerInfo.armor
        replayParam.physical = CacheCenter.m_tPlayerInfo.physical
        replayParam.agility = CacheCenter.m_tPlayerInfo.agility
        replayParam.lucky = CacheCenter.m_tPlayerInfo.luck
        replayParam.fighting = CacheCenter.m_tPlayerInfo.fighting
        replayParam.winRate = CacheCenter.m_tPlayerInfo.winNum / CacheCenter.m_tPlayerInfo.playNum
        replayParam.headId = headId
        replayParam.faceId = faceId
        replayParam.bodyId = bodyId
        replayParam.wingId = wingId
        replayParam.weaponId = weaponId
        replayParam.item_id = item_id
        replayParam.petId = {[1]=petAnim}
        replayParam.petSkill={[1]=CacheCenter.m_tPlayerInfo.petInfo and CacheCenter.m_tPlayerInfo.petInfo.skill or ""}
        replayParam.petSkillId={[1]=0}
        -- petParam,guaiBattleId,guaiId,section,weaponSkill
        replayParam.petParam = {[1]=CacheCenter.m_tPlayerInfo.petInfo and CacheCenter.m_tPlayerInfo.petInfo.gift or 0}
        replayParam.guaiBattleId = guaiBattleId
        replayParam.guaiId = guaiId
        replayParam.section = mapData.section
        replayParam.weaponSkill = weaponSkill
        replayParam.exp = CacheCenter.m_tPlayerInfo.exp
        replayParam.petLevel ={[1]=CacheCenter.m_tPlayerInfo.petInfo and CacheCenter.m_tPlayerInfo.petInfo.advancedLevel or 0}
        replayParam.colour={[1]=colour}
        replayParam.bodyColour={[1]=bodyColour}
        replayParam.footmark = {[1] = CacheCenter:getUsingFootMarkId()}
        BattleMsgReplayGameRecord:setSingleMakePairOkRecord(replayParam)
    end
    WBattleGlobal:getCurrent().m_tMakePairOk.m_tPlayerInfo = {colour = {[1]=colour},bodyColour = {[1]=bodyColour},sex =CacheCenter.m_tPlayerInfo.sex,level = CacheCenter.m_tPlayerInfo.level,exp = CacheCenter.m_tPlayerInfo.exp,equip = {faceId,headId,bodyId,wingId,weaponId}}

    replaceScene(SceneBattleLoading:createElement())
   
end

--@brief  设置单人副本类型
function WndSingleCopy:setCopyType(copyType)
    if type(copyType)  == "number" then
        self.m_nCopyType = copyType
        self.checkTag = copyType
        GlobalGame.g_nSingleCopyType = copyType
    end
end

--@brief  属性加成
function WndSingleCopy:suitAddAttr(mapType)
    --生命、攻击力、防爆力、暴击、免暴、体质、力量、护甲、速度、幸运、破防、免伤
    local addSuitAttr = {}
    addSuitAttr[1] = CacheCenter.m_tPlayerInfo.hp
    addSuitAttr[3] = CacheCenter.m_tPlayerInfo.attack
    addSuitAttr[4] = CacheCenter.m_tPlayerInfo.defend
    addSuitAttr[5] = CacheCenter.m_tPlayerInfo.critRate
    addSuitAttr[7] = CacheCenter.m_tPlayerInfo.reduceCrit
    addSuitAttr[9] = CacheCenter.m_tPlayerInfo.physique
    addSuitAttr[10] = CacheCenter.m_tPlayerInfo.force
    addSuitAttr[11] = CacheCenter.m_tPlayerInfo.armor
    addSuitAttr[12] = CacheCenter.m_tPlayerInfo.agility
    addSuitAttr[13] = CacheCenter.m_tPlayerInfo.luck
    addSuitAttr[19] = CacheCenter.m_tPlayerInfo.wreckDefense
    addSuitAttr[20] = CacheCenter.m_tPlayerInfo.injuryFree

    --单人副本[1]
    --试练塔[3]、
    if WndLibrary then
        local data = WndLibrary:setFetterData()
        local m_tFetterTitle, m_tCollectFinishId = WndLibrary:setHasFetterAttr(data)
        local attr, attr1 = {},{}
        for i=1, #m_tFetterTitle do
            if m_tFetterTitle[i] == 0 or m_tFetterTitle[i] == mapType then
                local temp_attr, temp_attr1 = WndLibrary:getFetterNum(m_tFetterTitle[i], m_tCollectFinishId, data, true)
                for i, v in pairs(temp_attr) do
                    if attr[i] == nil then
                        attr[i] = v
                    else
                        attr[i] = attr[i] + v
                    end
                end
                for i, v in pairs(temp_attr1) do
                    if attr1[i] == nil then
                        attr1[i] = v
                    else
                        attr1[i] = attr1[i] + v
                    end
                end
            end
        end
        --先计算定值，后计算万分比的时候
        for i,v in pairs(attr) do
            addSuitAttr[i] = addSuitAttr[i] + v
        end
        --如果存在全属性的情况下
        local isAllAttr = nil
        for i,v in pairs(attr1) do
            if i == -1 then
                isAllAttr = v
            else
                addSuitAttr[i] = addSuitAttr[i] + (addSuitAttr[i] * (v / 10000))
            end
        end
        if isAllAttr then
            for i, v in pairs(addSuitAttr) do
               addSuitAttr[i] = addSuitAttr[i] + (addSuitAttr[i] * (isAllAttr / 10000)) 
            end
        end
    end
    return addSuitAttr
end

--@brief  获取当前所在页
function WndSingleCopy:getCurPage()
    return self.m_nCurPageIndex
end

--@brief  根据单人副本类型获取相应的章节奖励
function WndSingleCopy:getChapterReward(chapterId, copyType)
--    WZLog("WndSingleCopy:getChapterReward ")
    copyType = copyType or self.m_nCopyType
    for k,v in pairs(GDatatab_section) do
        if v.map_type == copyType and v.section_id == chapterId then
            return v
        end
    end
end

--@brief 清空所有小关卡
function WndSingleCopy:removeAllCell()
    for i,v in ipairs(self.m_tAllCopyCell) do
        v.m_root:removeFromParentAndCleanup(true)
    end
    self.m_tAllCopyCell = {}
    self.m_tCopyCellT = {}
end

--@brief  更新单人副本小关卡箭头显示
--@param sectionCellId : 小关卡ID
function WndSingleCopy:updateCellStats(sectionCellId)
    WZLog("WndSingleCopy:updateCellStats ")
    if self.m_nCopyType == 3 and sectionCellId then
        sectionCellId = tonumber(sectionCellId)
        local temp = GDatatab_single_map["id_" .. sectionCellId]
        if temp.map_num > 1 then
            sectionCellId = sectionCellId - (temp.map_num -1)
        end
    end
    if sectionCellId ~= nil then
        sectionCellId = tonumber(sectionCellId)
        for i,v in ipairs(self.m_tAllCopyCell) do
            local arromAction = v:getArromRoot()
            if arromAction then
                if v:getData().id ~= sectionCellId then
                    v:setArromActionVisibleStatus(false)
                else
                    if v:getData().id == sectionCellId then
                        v:setArromActionVisibleStatus(true)
                        self.m_luaCell = v
                    end
                end
            else
                if v:getData().id == sectionCellId then
                    v:addArromAction(sectionCellId)
                    self.m_luaCell = v
                end
            end
        end
    end
end

--@brief    岛主判斷當前挑战的关卡的状态
function WndSingleCopy:judgeSectionHostState( mapId )
    local landlordConfig = json.decode(CacheCenter:getGameParam().landlordConfig)
    if self.m_tIslandHostId == nil or #self.m_tIslandHostId < landlordConfig.maxLandlordNum then 
        return 0 
    end

    local bIsAllSmall = true
    local nCurMapType = GDatatab_single_map["id_" .. mapId].map_type
    for i = 1, #self.m_tIslandHostId do
        local nTempType = GDatatab_single_map["id_" .. self.m_tIslandHostId[i]].map_type
        if nTempType < nCurMapType then 
            bIsAllSmall = false
            break 
        end
    end

    if bIsAllSmall then 
        return 2
    else
        return 1
    end
end

--@brief    更新主城显示的快捷任务
function WndSingleCopy:updateCityTask()
    -- body
    if self.m_root == nil then return end 
    if self.m_tWndBottomBarObj == nil then return end 

    self.m_tWndBottomBarObj:showCurTask()
end

--@brief    副本界面领取任务后，刷新新任务
function WndSingleCopy:updateTaskAfterReward(nTaskId, nTaskType, nTaskStatus, reward)
    -- body
    if self.m_root == nil then return end 
    if self.m_nLoadingId then 
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
        self.m_nLoadingId = nil 
    end
    local tRewardsNum
    local tRewardsItemId
    if reward then 
        tRewardsItemId, tRewardsNum = SplitItemString(reward)
    else
        tRewardsNum,tRewardsItemId = WndTask:_getTaskRewards(nTaskType, nTaskId)
    end
    WndRewardShow:showById(tRewardsItemId,tRewardsNum,nil,nTaskId)
    
    self:setGetRewardLimit(false)
end

--@brief    领取奖励收到错误协议，去掉领取状态限制
function WndSingleCopy:setGetRewardLimit(bBool)
    -- body
    if self.m_root == nil then return end 

    self.m_bIsGettingReward = bBool
end

--@brief    获取是否在领取奖励
function WndSingleCopy:weatherInGetReward()
    -- body
    return self.m_bIsGettingReward 
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化数据
function WndSingleCopy:_initData()
    WZLog("WndSingleCopy:_initData")
    --从LocalData加载副本数据
    if self.m_nCopyType == nil then
        self.m_nCopyType = 1
    end
    self.m_tCommonCopyData = {} --普通副本
    self.m_tEliteCopyData = {}  --精英副本
    self.m_tDevilCopyData = {} --恶魔副本
    for i,v in pairs(GDatatab_single_map) do
        if v.map_type == 1 then --普通副本模式
            local nCopyIndex = v.section
            self.m_tCommonCopyData[nCopyIndex] = self.m_tCommonCopyData[nCopyIndex] or {}
            local nLevelIndex = v.map_num
            self.m_tCommonCopyData[nCopyIndex][nLevelIndex] = v
        elseif v.map_type == 2 then --精英副本模式
            local nCopyIndex = v.section
            self.m_tEliteCopyData[nCopyIndex] = self.m_tEliteCopyData[nCopyIndex] or {}
            local nLevelIndex = v.map_num
            self.m_tEliteCopyData[nCopyIndex][nLevelIndex] = v
        elseif v.map_type == 3 then --地獄副本模式
            local nCopyIndex = v.section
            self.m_tDevilCopyData[nCopyIndex] = self.m_tDevilCopyData[nCopyIndex] or {}
            local nLevelIndex = v.idgroup
            if  v.map_num == 1 then
                self.m_tDevilCopyData[nCopyIndex][nLevelIndex] = v
            end
        end
    end

    if self.m_nCopyType == 1  then
        self.m_tCopyData = self.m_tCommonCopyData
        GlobalGame.g_nSingleCopyType = BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_1
    elseif self.m_nCopyType == 2 then
        self.m_tCopyData = self.m_tEliteCopyData
        GlobalGame.g_nSingleCopyType = BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_2
    else
        self.m_tCopyData = self.m_tDevilCopyData
        GlobalGame.g_nSingleCopyType = BattleConstants.g_tBossBattleMode.MODE_NORMAL_HARD
    end

    self:setCopyData()
end

--@brief  设置玩家当前单人副本信息
function WndSingleCopy:setCopyData()
    --设置玩家当前进度
    local tSingleCopyData = CacheCenter:getSingleCopyData() or {}
   
    self.m_nCurCopyId = 0
    self.m_nCurCopyIndex = 1
    self.m_nCurLevelIndex = 0
    self.m_tSectionStarNum = {}
    self.m_tSectionStarNum1 = {}
    self.m_tSectionStarNum2 = {}
    self.m_tSectionStarNum3 = {}

    local bIsNull = true
    for i,v in ipairs(tSingleCopyData) do
        local tLevelData = GDatatab_single_map["id_"..v.pointId]
        if tLevelData then
            if self.m_nCopyType == tLevelData.map_type then
                local nLevelIndex = nil
                if self.m_nCopyType == 3 then
                    nLevelIndex= tLevelData.idgroup
                else
                    nLevelIndex= tLevelData.map_num
                end
                if tLevelData.section ~= 99 and tLevelData.section*100 + nLevelIndex > self.m_nCurCopyIndex*100 + self.m_nCurLevelIndex then
                    self.m_nCurCopyId = v.pointId
                    self.m_nCurCopyIndex = tLevelData.section
                    self.m_nCurLevelIndex = nLevelIndex
                end
                local factor = v.factor
                if self.m_nCopyType == 3 then
                    if v.factor > 0 then
                        factor = 1
                    end
                end
                
                --计算章节星星数
                local tBits = NumberToBits(factor, 3)
                local nStarNum = (tBits[1] or 0) + (tBits[2] or 0) + (tBits[3] or 0)

                self.m_tSectionStarNum[tLevelData.section] = (self.m_tSectionStarNum[tLevelData.section] or 0) + nStarNum
                bIsNull = false
            end

            if tLevelData.map_type == 1 then
                --计算普通章节星星数
                local tBits = NumberToBits(v.factor, 3)
                local nStarNum = (tBits[1] or 0) + (tBits[2] or 0) + (tBits[3] or 0)

                self.m_tSectionStarNum1[tLevelData.section] = (self.m_tSectionStarNum1[tLevelData.section] or 0) + nStarNum
            elseif tLevelData.map_type == 2 then
                --计算精英章节星星数
                local tBits = NumberToBits(v.factor, 3)
                local nStarNum = (tBits[1] or 0) + (tBits[2] or 0) + (tBits[3] or 0)

                self.m_tSectionStarNum2[tLevelData.section] = (self.m_tSectionStarNum2[tLevelData.section] or 0) + nStarNum
            elseif tLevelData.map_type == 3 then
                 --计算精英章节星星数
                local factor = v.factor
                if factor > 0 then
                        factor = 1
                end
                local tBits = NumberToBits(factor, 3)
                local nStarNum = (tBits[1] or 0) + (tBits[2] or 0) + (tBits[3] or 0)

                self.m_tSectionStarNum3[tLevelData.section] = (self.m_tSectionStarNum3[tLevelData.section] or 0) + nStarNum
            end
        end
    end

    if self.m_nCurCopyId > 0 then
        local tLevelData = GDatatab_single_map["id_" .. self.m_nCurCopyId]
        --如果下一关为下一个副本的时候
        local tNextLevelData = self:_getNextLevel(self.m_nCurCopyId)
        if tNextLevelData and tNextLevelData.section == tLevelData.section + 1 then
            --self.m_nCurCopyIndex = tNextLevelData.section
            self.m_nCurLevelIndex = 0
        end
    end
    
    if self.m_nCopyType == 1 then
        --章节奖励
        self.m_tSectionReward = tSingleCopyData.sectionReward or {}
    elseif self.m_nCopyType == 2 then
        self.m_tSectionReward = tSingleCopyData.sectionReward2 or {}
    elseif self.m_nCopyType == 3 then
        self.m_tSectionReward = tSingleCopyData.sectionReward3 or {}
    end
end

--@brief  判断是否已过普通整个章节
function WndSingleCopy:isPassSectionPage(sectionId)
    WZLog("WndSingleCopy:isPassSectionPage = ",sectionId)
    local sectionCellCount = #self.m_tCommonCopyData[sectionId]
    local lastLevelData = self.m_tCommonCopyData[sectionId][sectionCellCount]

    local lastLevelId = lastLevelData.id
    local lastCommonLevelId = self:getCommonTypeLastLevel()
    if lastCommonLevelId == nil then
        return false
    end
    if lastCommonLevelId >= lastLevelId then
        return true
    end
end

--@brief  判断是否已过精英整个章节
function WndSingleCopy:isPassEliteSectionPage(sectionId)
    WZLog("WndSingleCopy:isPassEliteSectionPage = ",sectionId)
    local sectionCellCount = #self.m_tEliteCopyData[sectionId]
    local lastLevelData = self.m_tEliteCopyData[sectionId][sectionCellCount]

    local lastLevelId = lastLevelData.id
    local lastEliteLevelId = self:getEliteTypeLastLevel()
    if lastEliteLevelId == nil then
        return false
    end
    if lastEliteLevelId >= lastLevelId then
        return true
    end
end

--@brief 获取单人副本普通关卡最后过关的关卡
function WndSingleCopy:getCommonTypeLastLevel()
    local tSingleCopyData = CacheCenter:getSingleCopyData() or {}
    local copyId = nil
    local curCopyIndex = 1
    local curLevelIndex = 0
    for i,v in ipairs(tSingleCopyData) do
        local tLevelData = GDatatab_single_map["id_"..v.pointId]
        if tLevelData then
            if tLevelData.map_type == 1 then
                if tLevelData.section*100 + tLevelData.map_num > curCopyIndex*100 + curLevelIndex then
                    copyId = v.pointId
                    curCopyIndex = tLevelData.section
                    curLevelIndex = tLevelData.map_num
                end
            end
        end
    end
    return copyId
end

--@brief 获取单人副本精英关卡最后过关的关卡
function WndSingleCopy:getEliteTypeLastLevel()
    local tSingleCopyData = CacheCenter:getSingleCopyData() or {}
    local copyId = nil
    local curCopyIndex = 1
    local curLevelIndex = 0
    for i,v in ipairs(tSingleCopyData) do
        local tLevelData = GDatatab_single_map["id_"..v.pointId]
        if tLevelData then
            if tLevelData.map_type == 2 then
                if tLevelData.section*100 + tLevelData.map_num > curCopyIndex*100 + curLevelIndex then
                    copyId = v.pointId
                    curCopyIndex = tLevelData.section
                    curLevelIndex = tLevelData.map_num
                end
            end
        end
    end
    return copyId
end

--@brief  根据精英副本的关卡信息获取当前普通关卡的状态
function WndSingleCopy:getCommonLevelState(cellData)
    WZLog("WndSingleCopy:getCommonLevelState")
    local eliteCopyId = cellData.id
    eliteCopyId = eliteCopyId - 10000
    local tAllCopyData = CacheCenter:getSingleCopyData()
    for i,v in ipairs(tAllCopyData) do
        if v.pointId == eliteCopyId then
            return v
        end
    end
    return nil
end

--@brief   隐藏单人副本类型按钮
function WndSingleCopy:hideCopyType(curPageObject)
    local conCopy2 = GetElement(curPageObject,"conCopy2_WndSingleCopy",WZUIContainer)
    conCopy2:setVisible(false)
    local conCopy1 = GetElement(curPageObject,"conCopy1_WndSingleCopy",WZUIContainer)
    local imgArrow = GetElement(conCopy1,"imgArrow_WndSingleCopy",WZUIImage)
    imgArrow:setRotation(0)
end

--@brief 获取当前节点的page对象
function WndSingleCopy:getCuPageObject()
    local conCopy = GetElement(self.m_root, "conCopy_WndSingleCopy", WZUIContainer)
    local cell = conCopy:getChildByTag(99)
    if cell~= nil then
        cell = WZUIContainer:luaTo(cell)
    end
    return cell
end

--@brief	获取关卡状态
--@param    tLevelData:关卡数据
--@return   #1,关卡状态
function WndSingleCopy:_getLevelState(tLevelData)
    WZLog("WndSingleCopy:_getLevelState")
    local playerInfo = CacheCenter:getPlayerInfo()
    if playerInfo == nil then return end
    local nPlayerLevel = playerInfo.level
    local nLevel = tLevelData.level
    if self.m_nCurCopyId == 0 then --没有通关过任何关卡时
        if tLevelData.parent_id == -1  then --第一关
            if nPlayerLevel>= nLevel then
                if self.m_nCopyType == 1 then
                    return CellSingleCopyLevel.STATE_UNDERWAY
                elseif self.m_nCopyType == 2 then
                    local isPassLastCommonLevel = self:isPassSectionPage(tLevelData.section)
                    if not isPassLastCommonLevel then
                        return CellSingleCopyLevel.STATE_UNPASSEDCOMMON
                    else
                        return CellSingleCopyLevel.STATE_UNDERWAY
                    end
                elseif self.m_nCopyType == 3 then
                    local isPassLastCommonLevel = self:isPassEliteSectionPage(tLevelData.section)
                    if not isPassLastCommonLevel then
                        return CellSingleCopyLevel.STATE_UNPASSEDCOMMON
                    else
                        return CellSingleCopyLevel.STATE_UNDERWAY
                    end
                end
            else
                return CellSingleCopyLevel.STATE_LEVELUNREACHED
            end
        else
            return CellSingleCopyLevel.STATE_LOCKED
        end
    end
    local nLevelGroup = tLevelData.section
    local nLevelIndex = nil
    if self.m_nCopyType == 3 then
        nLevelIndex= tLevelData.idgroup
    else
        nLevelIndex= tLevelData.map_num
    end
    local curCopyTable = GDatatab_single_map["id_"..self.m_nCurCopyId]
    local nCurGroup = curCopyTable.section
    local nCurIndex = curCopyTable.map_num
    if self.m_nCopyType == 3 then
        nCurIndex = curCopyTable.idgroup
    else
        nCurIndex = curCopyTable.map_num
    end
    local nParentId = curCopyTable.parent_id
    WZLog("WndSingleCopy:_getLevelState", tLevelData.id, tLevelData.parent_id, self.m_nCurCopyId )
    if nLevelGroup*100+nLevelIndex <= nCurGroup*100+nCurIndex then --已通过
        return CellSingleCopyLevel.STATE_PASSED
    else --未通关的
        if tLevelData.parent_id <= self.m_nCurCopyId and tLevelData.parent_id ~= -1 then --正在挑战 
            if nPlayerLevel < nLevel then --等级未达到
                return CellSingleCopyLevel.STATE_LEVELUNREACHED
            else
                if self.m_nCopyType == 1 then
                    return CellSingleCopyLevel.STATE_UNDERWAY
                elseif self.m_nCopyType == 2 then
                    local isPassLastCommonLevel = self:isPassSectionPage(tLevelData.section)
                    if not isPassLastCommonLevel then
                        return CellSingleCopyLevel.STATE_UNPASSEDCOMMON
                    else
                        return CellSingleCopyLevel.STATE_UNDERWAY
                    end
                elseif self.m_nCopyType == 3 then
                    local isPassLastCommonLevel = self:isPassEliteSectionPage(tLevelData.section)

                    if not isPassLastCommonLevel then
                        return CellSingleCopyLevel.STATE_UNPASSEDCOMMON
                    else
                        return CellSingleCopyLevel.STATE_UNDERWAY
                    end
                end
            end
        else --还未解锁
            return CellSingleCopyLevel.STATE_LOCKED
        end
    end
end

--@brief	根据关卡id获取下一个关卡
--@param    nLevelId,关卡id
--@return   #1，下一个关卡数据表
function WndSingleCopy:_getNextLevel(nLevelId)
    --WZLog("WndSingleCopy:_getNextLevel", nLevelId)
    for i,v in pairs(GDatatab_single_map) do
        if v.parent_id == nLevelId then
            return v
        end
    end
    return nil
end

--@brief	获取当前章节星星数量
--@param    nSection, 章节id
--@return   #1,星星数量
function WndSingleCopy:_getSectionStarNum(pageIndex, pageData, sectionStarNum)
    WZLog("WndSingleCopy:_getSectionStarNum", pageIndex)
    pageIndex = pageIndex or self.m_nCurPageIndex
    pageData = pageData or self.m_tCopyData
    sectionStarNum = sectionStarNum or self.m_tSectionStarNum

    local nSection = nil
    nSection= pageData[pageIndex+1][1].section

    return sectionStarNum[nSection] or 0
end

--@brief	获取当前章节奖励状态
--@param    nIndex, 箱子序号, pageIndex:章节序号, copyType:普通资料or精英资料
--@return   #1,状态, 0:不能打开，1:已打开，2:可打开
--@return   #2, 1：为普通副本。2：精英副本 3；地獄副本
function WndSingleCopy:_getSectionRewardStateByIndex(nIndex, pageIndex, copyType)
--    WZLog("_getSectionRewardStateByIndex one",nIndex,pageIndex,copyType)
    pageIndex = pageIndex or self.m_nCurPageIndex
    local pageData = self.m_tCopyData
    local sectionReward = self.m_tSectionReward
    local sectionStarNum = self.m_tSectionStarNum
    if copyType then
        local tSingleCopyData = CacheCenter:getSingleCopyData() or {}
        if copyType == 1 then
            pageData = WndSingleCopy.m_tCommonCopyData
            sectionReward = tSingleCopyData.sectionReward
            sectionStarNum = self.m_tSectionStarNum1
        elseif copyType == 2 then
            pageData = WndSingleCopy.m_tEliteCopyData
            sectionReward = tSingleCopyData.sectionReward2
            sectionStarNum = self.m_tSectionStarNum2
        elseif copyType == 3 then
            pageData = WndSingleCopy.m_tDevilCopyData
            sectionReward = tSingleCopyData.sectionReward3
            sectionStarNum = self.m_tSectionStarNum3
        end
    end


    local nState = 0
    local nMapGroup = nil
    if not pageData[pageIndex+1] then
        return nState
    end
    if not pageData[pageIndex+1][1] then
        return nState
    end
    local copyData = pageData[pageIndex+1][1]
    nMapGroup=  copyData.section
    for i = 1, #sectionReward do
        if sectionReward[i].sectionId == nMapGroup then
            local tBits = NumberToBits(sectionReward[i].rewardNum, 3)
            nState = tBits[nIndex] or 0
            --WZLog("_getSectionRewardStateByIndex two", i, nIndex, pageIndex, copyType, nMapGroup, tBits[nIndex] )
        end
    end
    
    if nState == 0 then
        --local tRewardLocalData = GDatatab_section["id_"..nMapGroup]
        local tRewardLocalData = self:getChapterReward(nMapGroup, copyType)
        local nStarNum = self:_getSectionStarNum(pageIndex,pageData,sectionStarNum)
        --WZLog("_getSectionRewardStateByIndex three1",nIndex,pageIndex,copyType,nMapGroup, nStarNum, tRewardLocalData["condition"..nIndex])
        if tRewardLocalData and nStarNum >= tRewardLocalData["condition"..nIndex] then
            nState = 2
            --WZLog("_getSectionRewardStateByIndex three2",nIndex,pageIndex,copyType,nMapGroup, nStarNum, tRewardLocalData["condition"..nIndex])
        end
    end
    
    return nState , copyData.map_type ,nMapGroup
end

--每个章节的宝箱领取状态
--@param :单人副本类型(普通/精英/惡魔)
function WndSingleCopy:getLotterDrawBoxStats(copyType)
    WZLog("WndSingleCopy:getLotterDrawBoxStats = ",copyType)
    local tempInfo = {}
    for i = 0, self.m_nCurCopyIndex do
        for k=1,3 do
            local nState = 0
            local tempCopyType = copyType
            local chapterID = 0
            nState,tempCopyType,chapterID= self:_getSectionRewardStateByIndex(k,i,copyType)
            local temp = {nState,chapterID}
            table.insert(tempInfo,temp)
        end
    end
    return tempInfo
end

--根据当前副本类型判断另外的一个副本是否有宝箱未领取
function WndSingleCopy:isShowRedPoint()
    WZLog("WndSingleCopy:isShowRedPoint")
    local tempInfo = {}
    if self.m_nCopyType == 1 then
        local temp1 = self:getLotterDrawBoxStats(2)
        local temp2 = self:getLotterDrawBoxStats(3)
        table.insert(tempInfo,temp1)
        table.insert(tempInfo,temp2)
    elseif self.m_nCopyType == 2 then
        local temp1 = self:getLotterDrawBoxStats(1)
        local temp2 = self:getLotterDrawBoxStats(3)
        table.insert(tempInfo,temp1)
        table.insert(tempInfo,temp2)
    elseif self.m_nCopyType == 3 then
        local temp1 = self:getLotterDrawBoxStats(1)
        local temp2 = self:getLotterDrawBoxStats(2)
        table.insert(tempInfo,temp1)
        table.insert(tempInfo,temp2)
    end

    local stats1 = nil
    local stats2 = nil
    for i,v in ipairs(tempInfo) do
        for j,k in ipairs(v) do
            stats1 = v[1]
            if i == 1 then
                if stats1 == 2 then
                    stats1 = true
                end
            elseif i == 2 then
                if stats1 == 2 then
                    stats2 = true
                end
            end
        end
    end
    if stats1 ~= true then
        stats1 = false
    end

    if stats2 ~= true then
        stats2 = false
    end
    return stats1 , stats2
end

--获取当前章节的前面章节是否有宝箱未领取
function WndSingleCopy:getFrontChapterBoxStats()
    WZLog("WndSingleCopy:getFrontChapterBoxStats")
    local tempInfo = {}
    tempInfo = self:getLotterDrawBoxStats(self.m_nCopyType)
    local stats = 0
    local chapterID = nil
    for i,v in ipairs(tempInfo) do
        stats = v[1]
        if stats == 2 then
            chapterID = v[2]
            if chapterID < (self.m_nCurPageIndex+1) then
                return true
            end
        end
    end
    return false
end


function WndSingleCopy:setIsShowCopyLevelInfo(bShow)
    WZLog("WndSingleCopy:setIsShowCopyLevelInfo =",bShow)
    self.m_bShowCopyLevelInfo = bShow
end

function WndSingleCopy:setShowIslandOwner(nJumpIsland)
    WZLog("WndSingleCopy:setShowIslandOwner =",nJumpIsland)
    self.m_nJumpIsland = nJumpIsland
end

--获取当前章节的后面章节是否有宝箱未领取
function WndSingleCopy:getBehindChapterBoxStats()
    WZLog("WndSingleCopy:getBehindChapterBoxStats")
    local tempInfo = {}
    tempInfo = self:getLotterDrawBoxStats(self.m_nCopyType)
    local stats = 0
    local chapterID = nil
    for i,v in ipairs(tempInfo) do
        stats = v[1]
        if stats == 2 then
            chapterID = v[2]
            if chapterID > (self.m_nCurPageIndex+1) then
                return true
            end
        end
    end
    return false
end

function WndSingleCopy:_playSoundeffect(bExit)
    WZLog("WndSingleCopy:_playSoundeffect =",self.m_nCurPageIndex)
    if self.m_nCurPageIndex == 0 then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_HAIYANG)
    elseif self.m_nCurPageIndex == 1 then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_SENLIN)
    elseif self.m_nCurPageIndex == 2 then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_SHAMO)
    elseif self.m_nCurPageIndex == 3 then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_XUEDI)
    elseif self.m_nCurPageIndex == 4  then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_MAXI)
    elseif self.m_nCurPageIndex == 5 then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_GUBAO)
    elseif self.m_nCurPageIndex == 6 then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_JIXIE)
    elseif self.m_nCurPageIndex == 7 then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_GUBAO)
    elseif self.m_nCurPageIndex == 8 then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_SENLIN)
    elseif self.m_nCurPageIndex == 9 then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_SHAMO)
    elseif self.m_nCurPageIndex == 10 then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_XUEDI)
    elseif self.m_nCurPageIndex == 11 then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_JIXIE)
    elseif self.m_nCurPageIndex == 12 then
        SoundManager:playBgMusic(SoundDefine.E_MUSIC_MEISHI)
    end
end

--@brief    获取小岛数据成功
function WndSingleCopy:getIslandDataOk(seizeMapId,assistMapId)
    -- body
    self.m_tIslandHostId = seizeMapId  --已占岛Id
    self.m_tIslandAssistId = assistMapId

    self:afterProtocolCallBack()
end

--@brief    设置小岛按钮的显示
function WndSingleCopy:setIslandBtnVisible(element)
    -- body
    if (#self.m_tIslandHostId > 0 or #self.m_tIslandAssistId > 0) and CheckButtonOpen(216,true) then
        GetElement(element, "btnIsland1_WndSingleCopy", WZUIButton):setVisible(true)
    else
        GetElement(element, "btnIsland1_WndSingleCopy", WZUIButton):setVisible(false)
    end
end

--@brief    获取章节列表数据
function WndSingleCopy:setSectionListData()
    -- body
    if self.m_root == nil then return end 

    self.m_tSectionListData = {}  
    for i, value in pairs(GDatatab_section) do
        local bExist = false 
        if self.m_tSectionListData[value.map_type] == nil then 
            self.m_tSectionListData[value.map_type] = {}
        end
        for k = 1, #self.m_tSectionListData[value.map_type] do
            if self.m_tSectionListData[value.map_type][k].section_id == value.section_id then 
                bExist = true
                break 
            end
        end

        if not bExist then 
            local tItem = {}
            tItem.section_id = value.section_id
            tItem.resources = "ui/copy/common_fb_map" .. (value.section_id + 1) .. ".png"
            tItem.map_type = value.map_type
            tItem.sectionName = self:getSectionName(tItem)
            if value.map_type <= 2 then 
                tItem.openState = self:bJumpToSingleCopy(value.map_type * 10000 + value.section_id * 100 + 1, value.map_type)
            else
                tItem.openState = self:bJumpToSingleCopy(value.map_type * 10000 + (value.section_id - 1) * 9 + 1, value.map_type)
            end

            table.insert(self.m_tSectionListData[value.map_type], tItem)
        end
    end

    for i = 1, #self.m_tSectionListData do
        table.sort(self.m_tSectionListData[i], function (a,b)
            -- body
            return a.section_id < b.section_id
        end)
    end

    self:_createSectionList()
end

--@brief    获取章节名字
function WndSingleCopy:getSectionName(tData)
    -- body
    for i, value in pairs(GDatatab_single_map) do
        if value.section == tData.section_id and value.map_type == tData.map_type then 
            return value.section_name
        end
    end

    return ""
end

--@brief  判断是否能跳转到单人副本模块
--@param  copySectionId : 单人副本小关卡ID
--@param  mapType : 难度
--@return true : 可以进行挑战否则不可挑战
function WndSingleCopy:bJumpToSingleCopy(copySectionId, mapType)
    WZLog("WndSingleCopy:bJumpToSingleCopy", copySectionId, mapType)
    local copyData = GDatatab_single_map["id_" .. copySectionId]
    if copyData == nil then return false end 

    local tSingleCopyData = CacheCenter:getSingleCopyData() or {}
    local maxSectionId = 0
    if copyData.map_type == 2 then
        if CheckButtonOpen(ELITE_COPY, false)  then
            for i,v in ipairs(tSingleCopyData) do
                if v.pointId > 0 then
                    local copyInfo= GDatatab_single_map["id_" .. v.pointId]
                    if copyInfo and copyInfo.section > maxSectionId and copyInfo.map_type == 2 then
                        maxSectionId = copyInfo.section
                    end
                end
                
            end
            maxSectionId = maxSectionId + 1
            if maxSectionId >= copyData.section then
                return true
            end
            return false
        else
            return false
        end
    else
        for i,v in ipairs(tSingleCopyData) do
            if v.pointId > 0 then
                local copyInfo= GDatatab_single_map["id_" .. v.pointId]
                if copyInfo and copyInfo.section > maxSectionId and copyInfo.map_type == mapType then
                    maxSectionId = copyInfo.section
                end
            end
        end
        maxSectionId = maxSectionId + 1
        if maxSectionId >= copyData.section then
            return true
        end
    end
    return false
end

--@brief    领取宝箱后，刷新红点
function WndSingleCopy:afterBoxUpdateReDot(sectionId)
    -- body
    if self.m_tCellSectionItem == nil then return end 
    if self.m_tCellSectionItem[sectionId] == nil then return end 

    local nState = 0 
    for k = 1, 3 do
        nState = self:_getSectionRewardStateByIndex(k, sectionId - 1, self.m_nCopyType)
        if nState == 2 then 
            break 
        end
    end
    if nState == 2 then
        self.m_tCellSectionItem[sectionId]:setReDot(true)
    else
        self.m_tCellSectionItem[sectionId]:setReDot(false)
    end
end

--首次进入设置当前副本
function WndSingleCopy:setDefaultMap()
    if WndSingleCopy.m_root == nil then return end
    if self.m_nCurCopyIndex == nil then return end
    if self.m_nJumpPageIndex then 
        self.m_nCurCopyIndex = self.m_nJumpPageIndex
    end
    local chapterId = self.m_nCurCopyIndex
    self.m_nCurPageIndex = chapterId - 1
    WZLog("WndSingleCopy:setDefaultMap_1", chapterId, self.m_nCopyType)

    self:resertCurPage(self.m_nCurPageIndex)
end

-------------------------------------私有方法模块End----------------------------------------
