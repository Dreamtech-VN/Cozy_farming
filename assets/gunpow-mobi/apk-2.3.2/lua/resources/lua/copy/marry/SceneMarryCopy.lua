--SceneMarryCopy.lua
--@brief	SceneMarryCopy的UI模块
--@date		2016-7-17
--@author	binshao
--@note		夫妻副本房间


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneMarryCopy:onEnter(element)
    WZLog("SceneMarryCopy:onEnter")
    
	self.m_root = element
    IPDConnector.g_nNetConnectFlag = NET_FLAG_7
    self.m_toBattleLoadingScene = nil
    ChangeChatChannel(Chat_Channel_Team_Copy_Room)
    --CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
    --CacheCenter:registerUpdateDecorationObserver(self) --注册监听玩家装备更换
    --CacheCenter:registerUpatePlayerPetInfoObserver(self) --注册监听玩家宠物更新
    CacheCenter:registerUpateSkillSuitObserver(self)
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    ProtocolProcessorSingleMap:regAll()
    ProtocolProcessorSceneBossRoom:regAll()
    self:_addTop()
    self:_update()
    self:_initCopyData()
    self.m_root:enableSchedule("_updateHeartBeat",1)

    pushEquipInList()
    g_bIsShowWndDressUp = true
    SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)

    --发送结婚信息协议
    ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo()
end

-- UI加载完毕
function SceneMarryCopy:onEnterTransitionDidFinish()
    local ftxtSweep = GetElement(self.m_root, "ftxtSweep_SceneMarryCopy", WZUIFreeTextBox)
    local sweepConfig = CacheCenter:getGameParam().spouseClear
    local string = string.sub(sweepConfig, 2, -2) 
    local id = SplitStringWithSeparator(string,",")[1]
    local num = SplitStringWithSeparator(string,",")[2]
    self.m_tSweepCost = {tonumber(id), tonumber(num)}
    local sweepFormat = [[<I Z="0.5">%s</I><T S="18" C="255,250,236" P="1" SE="1" SS="4" SC="163,74,20">X%d %s</T>]]
    ftxtSweep:setShowText(string.format(sweepFormat, GDatatab_item["id_" .. id].icon, tonumber(num), LocalStrings.WIPE_OUT))

    popSceneEnd()
    AdaptLanguage(self)
    self:setSkillSuitName()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneMarryCopy:onExit(element)
    WZLog("SceneMarryCopy:onExit")
    self:exitRoom()
    IPDConnector.g_nNetConnectFlag = NET_FLAG_2
    ProtocolProcessorSingleMap:unregAll()
    ProtocolProcessorSceneBossRoom:unregAll()
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","SceneMarryCopy")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","SceneMarryCopy")
    --CacheCenter:unregisterUpatePlayerInfoObserver(self)
    --CacheCenter:unregisterUpateDecorationObserver(self)
    --CacheCenter:unregisterUpatePlayerPetInfoObserver(self)
    CacheCenter:unregisterUpateSkillSuitObserver(self)
    -- 弹框
    WZLog("SceneMarryCopy:onExit", tostring(g_bIsPushScene), tostring(g_bIsPopScene))
    if g_bIsPushScene == true then  return end
    if self.m_root then self.m_root:disableSchedule() end
    self:_unInit()
end

-- 房间心跳
function SceneMarryCopy:_updateHeartBeat(element,dt)
    if self.heartBeat == nil then self.heartBeat = 0 end
    if os.time() - self.heartBeat > BattleConstants.g_fShakeHandsTime and NetManager.g_bConnectFailed ~= true then
        self.heartBeat = os.time()
        ProtocolProcessorBattleInterface:send_SYSTEM_BattleShakeHands(0)
    end
    GlobalGame:getGameEventDispathcer():Dispatch(
        "GameState_Change",'state_room_boss',
        self.roomData.roomId,self:_getPlayerNum(),
        self:_getPlayerSeat(),self:_allPlayersReady())
end

-- 显示窗口
function SceneMarryCopy:showScene()
    if self.m_root == nil then
        local scene = SceneMarryCopy:createElement()
        replaceScene(scene)
    end
end

-- 退出房间
function SceneMarryCopy:exitRoom()
	if self.m_root == nil  then return end
	if  self.roomData == nil  then return end

    if self.m_toBattleLoadingScene ~= true then
        if WBattleGlobal:getCurrent().m_tMakePairOk and WBattleGlobal:getCurrent().m_tMakePairOk.battleId then
            WBattleGlobal:getCurrent().m_tMakePairOk.battleId = 0
        end
    end
end

-- 添加TOP ui
function SceneMarryCopy:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.topCell = {}
    self.topCell = {cell = cell, tcell = tcell }
    WZLog("-----------addTop-----------",self.topCell.cell,self.topCell.tcell)
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_fqfb.png",SceneMarryCopy,SceneMarryCopy.onClose,true,true,true,"SceneMarryCopy")
end

-- 点击退出房间回调
function SceneMarryCopy:onClose()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    -- local scene = SceneCity:createElement()
    -- replaceScene(scene)
	WZLog("SceneMarryCopy:onBackSceneCallback",self.roomData.roomId,self:_getPlayerSeat())
    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_QuitRoom(self.roomData.roomId, self:_getPlayerSeat())
end

-- 难度选择
function SceneMarryCopy:onCheckBoxDifficult(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    self:changeDifficult(tag)
    self:_setDifCheckBox()
end

--  刷新结婚信息界面
function SceneMarryCopy:updateInfo()
    local tCopyData = GDatatab_team_map["id_"..self.roomData.mapId]
    
    --恩爱经验等级
    local nMaxExp = GDatatab_marry_love["id_"..self.m_nLoveLevel].exp
    local petExptV = GetElement(self.m_root,"txtExpV_SceneMarryCopy",WZUILabelTTF)
    petExptV:setText(self.m_nLoveExp.."/"..nMaxExp)
    local proExp = GetElement(self.m_root,"proMarryExp_SceneMarryCopy",WZUIProgress)
    proExp:setPercentage(self.m_nLoveExp/nMaxExp*100)
    local txtLoveLevel = GetElement(self.m_root,"txtLoveLevel_SceneMarryCopy",WZUILabelTTF)
    txtLoveLevel:setText(self.m_nLoveLevel)
    --奖励
    local strDif = {LocalStrings.COPY_DIFFICULTY_1,LocalStrings.COPY_DIFFICULTY_2,LocalStrings.COPY_DIFFICULTY_3}
    local txtDifficulty = GetElement(self.m_root,"txtDifficulty_SceneMarryCopy",WZUILabelTTF)
    txtDifficulty:setText(string.format(LocalStrings.MARRY_DESC_1,strDif[self.selDiff]))
    --boss
    if tCopyData.map_target ~= -1 then
        local imgBossIcon = GetElement(self.m_root,"imgBossIcon_SceneMarryCopy",WZUIImage)
        imgBossIcon:setFile(tCopyData.map_target)
    end
    --技能
    self:showSkillList1()
    self:showSkillList2()


    --夫妻技能失效时间
    local conSkillTime = GetElement(self.m_root,"conSkillTime_SceneMarryCopy",WZUIContainer)
    local txtSkillTime2 = GetElement(self.m_root,"txtSkillTime2_SceneMarryCopy",WZUILabelTTF)

    local nMyEndTime = 0
    if CacheCenter:getPlayerInfo().sex == 0 then
        nMyEndTime = self.m_nManSkillEndTime
    else
        nMyEndTime = self.m_nWomanSkillEndTime
    end
    local nLeftTime = nMyEndTime - SystemTime:getServerTime()
    if nLeftTime > 0 then
        conSkillTime:enableSchedule("_scheduleSkill",1)
        local s = nLeftTime % 60
        local m = math.floor(nLeftTime / 60 % 60)
        local h = math.floor(nLeftTime / 3600)
        local strFormat = "%02d:%02d:%02d"
        txtSkillTime2:setText(string.format(strFormat,h,m,s))
    else
        txtSkillTime2:setText("00:00:00")
    end
end

function SceneMarryCopy:_scheduleSkill(element)
    local conSkillTime = GetElement(self.m_root,"conSkillTime_SceneMarryCopy",WZUIContainer)
    local txtSkillTime2 = GetElement(self.m_root,"txtSkillTime2_SceneMarryCopy",WZUILabelTTF)

    local nMyEndTime = 0
    if CacheCenter:getPlayerInfo().sex == 0 then
        nMyEndTime = self.m_nManSkillEndTime
    else
        nMyEndTime = self.m_nWomanSkillEndTime
    end
    local nLeftTime = nMyEndTime - SystemTime:getServerTime()
    if nLeftTime > 0 then
        local s = nLeftTime % 60
        local m = math.floor(nLeftTime / 60 % 60)
        local h = math.floor(nLeftTime / 3600)
        local strFormat = "%02d:%02d:%02d"
        txtSkillTime2:setText(string.format(strFormat,h,m,s))
    else
        conSkillTime:disableSchedule()
        txtSkillTime2:setText("00:00:00")
    end
end

--@brief  显示技能列表信息
function SceneMarryCopy:showSkillList1()
    WZLog("SceneMarryCopy:showSkillList1")
    local tconSkill1 = WZUITableContainer:luaTo(self.m_root:getChildElement("tconSkill1_SceneMarryCopy"))
    tconSkill1:cleanTable()
    local index = 0
    local canShowSkill = {}
    for k,v in pairs(GDatatab_marry_skill) do
        if v.camp_type == 0 then
            table.insert(canShowSkill,v.id)
        end
    end
    table.sort(canShowSkill,function(a,b)
        return a<b
    end)
    local visibleSkills = self:_canShowSkill(canShowSkill)

    for k,v in ipairs(canShowSkill) do
        local skillInfo = GDatatab_marry_skill["id_"..v]

        local conSkillInfo = WZUISystem:getInstance():createElement("conCellSkill1_SceneMarryCopy")
       
        local skillImage =  WZUIImage:luaTo(GetElement(conSkillInfo,"imgCellSkill1_SceneMarryCopy"))
        skillImage:setFile(skillInfo.icon)

        -- local btnSkill = WZUIButton:luaTo(GetElement(conSkillInfo,"btnSkill_CellCoupleSkill"))
        -- btnSkill:setTag(skillInfo.id)

        if self.m_nLoveLevel >= skillInfo.need_love_level then
            if visibleSkills["" .. skillInfo.camp_type][1] == v then
                conSkillInfo:setTag(index)
                conSkillInfo:setVisible(true)
                tconSkill1:setCellElement(conSkillInfo)
                index = index + 1
            end
        end
    end
end

--@brief  显示技能列表信息
function SceneMarryCopy:showSkillList2()
    WZLog("SceneMarryCopy:showSkillList2")
    local tconSkill2 = WZUITableContainer:luaTo(self.m_root:getChildElement("tconSkill2_SceneMarryCopy"))
    tconSkill2:cleanTable()
    local index = 0
    local canShowSkill = {}
    for k,v in pairs(GDatatab_marry_skill) do
        if v.camp_type == 0 then
            table.insert(canShowSkill,v.id)
        end
    end
    table.sort(canShowSkill,function(a,b)
        return a<b
    end)
    local visibleSkills = self:_canShowSkill(canShowSkill)

    local isContainer = false
    for k,v in ipairs(canShowSkill) do
        local skillInfo = GDatatab_marry_skill["id_"..v]

        local conSkillInfo = WZUISystem:getInstance():createElement("conCellSkill2_SceneMarryCopy")
       
        local skillImage =  WZUIImage:luaTo(GetElement(conSkillInfo,"imgSkillImage_SceneMarryCopy"))
        
        skillImage:setFile(skillInfo.icon)
   
        local imageLock = WZUIImage:luaTo(GetElement(conSkillInfo,"imgSkillLock_SceneMarryCopy"))
        local skillName =  WZUILabelTTF:luaTo(GetElement(conSkillInfo,"txtSkilName_SceneMarryCopy"))
        skillName:setText(skillInfo.name)

        local skillExplain = WZUILabelTTF:luaTo(GetElement(conSkillInfo,"txtSkillDesc_SceneMarryCopy"))
        local skillCond = WZUILabelTTF:luaTo(GetElement(conSkillInfo,"txtSkillCond_SceneMarryCopy"))
        local btnSkill = WZUIButton:luaTo(GetElement(conSkillInfo,"btnSkill_SceneMarryCopy"))
        btnSkill:setTag(skillInfo.id)
        if self.m_nLoveLevel >= skillInfo.need_love_level then
            if visibleSkills["" .. skillInfo.camp_type][1] == v then
                conSkillInfo:setTag(index)
                index = index + 1
                imageLock:setVisible(false)
                skillExplain:setText(skillInfo.desc)
                skillCond:setText("")
                conSkillInfo:setVisible(true)
                tconSkill2:setCellElement(conSkillInfo)
            end
        else
            conSkillInfo:setTag(index)
            index = index + 1
            imageLock:setVisible(true)
            skillImage:setGrayRender(true)
            skillExplain:setText("")
            skillCond:setText(LocalStrings.LOVING_LEVEL..skillInfo.need_love_level)
            conSkillInfo:setVisible(true)
            tconSkill2:setCellElement(conSkillInfo)
        end
    end
end

-- 点击规则按钮回调
function SceneMarryCopy:onClickRule(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface1(LocalStrings.CONJUGAL_RELATION_TIP)
end

-- 点击技能箭头按钮回调
function SceneMarryCopy:onClickSkillInfo(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    GetElement(self.m_root,"conSkillInfo1_SceneMarryCopy",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"conSkillInfo2_SceneMarryCopy",WZUIContainer):setVisible(true)
end

-- 点击背景回调
function SceneMarryCopy:onClickBG(element)
    local conSkillInfo1 = GetElement(self.m_root,"conSkillInfo1_SceneMarryCopy",WZUIContainer)
    local conSkillInfo2 = GetElement(self.m_root,"conSkillInfo2_SceneMarryCopy",WZUIContainer)

    if conSkillInfo1:isVisible() == false then
        conSkillInfo1:setVisible(true)
        conSkillInfo2:setVisible(false)
    end
end

--@brief  点击夫妻技能响应的方法
function SceneMarryCopy:onClickSkill2(element)
    WZLog("SceneMarryCopy:onClickSkill ",element:getParent():getTag(),element:getTag())
    local desc = GDatatab_marry_skill["id_"..element:getTag()].desc
    MsgBoxManager:showTipBox(desc)
end

--显示换技能功能
function SceneMarryCopy:onClickSkill(element)
    -- body
    WZLog("SceneMarryCopy:onClickSkill")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local seatNum = self:_getPlayerSeat()
    if self.roomData.playerReady[seatNum + 1] and not self:_isRoomOwner() then
        MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
        return
    end
    WndSkillContainer:showById(1)
end

-- 切换难度
-- 1. 只有房主才能切换难度
-- 2. 只有当前玩家都符合该难度时才能切换
function SceneMarryCopy:changeDifficult(nDifficult)
    WZLog("SceneMarryCopy:changeDifficult", nDifficult)

    -- 只有房主才能选难度
    if (not self:_isRoomOwner()) then
		MsgBoxManager:showTipBox(LocalStrings.ONLY_ROOMOWNER_CAN_SELECT)
		return
    end

    -- 避免重复点击
    if nDifficult == self:_getDifficult() then  return end

    --检查房主星级
    local selfIndex = self:_getPlayerDataIndex()
	if nDifficult-1 > self.roomData.playerStar[selfIndex] then
		if nDifficult == 2 then
			MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_SWITCH_DIFFICULTY_TIPS1)
        elseif nDifficult == 3 then
            MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_SWITCH_DIFFICULTY_TIPS2)
        elseif nDifficult == 4 then
            MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_SWITCH_DIFFICULTY_TIPS_DIYU)
		end
		return
	end

	--检查所有玩家星级
	for i=1, #self.roomData.playerStar do
		if nDifficult-1 > self.roomData.playerStar[i] and self.roomData.playerId[i] > 0 then
			MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_SWITCH_DIFFICULTY_TIPS3)
			return
		end
	end

    self.selDiff = nDifficult
    local nMapId = self:_getMapIdByDifficult(nDifficult)
    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateRoom(
        self.roomData.roomId, self.roomData.playerNumMode,
        self.roomData.passWord, nMapId,
        self.roomData.wnersId, self.roomData.roomName)
end

-- 开始游戏
function SceneMarryCopy:onStartGameButtonClick()
	WZLog("SceneMarryCopy:onStartGameButtonClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- 房主在大家都准备的情况下可以开始游戏，房客则准备或者取消准备
	if self:_isRoomOwner() then
        if self:getLeftFightTimes() <= 0 then 
            MsgBoxManager:showTipBox(LocalStrings.CHALLENGE_NOT_ENOUGH)
            return 
        end
		if self:_allPlayersReady() then
            ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_MakePair(self.roomData.roomId)
        else
            MsgBoxManager:showTipBox(LocalStrings.ROOM_HAVE_NOT_READY)
		end
	else
		--准备或取消游戏,这里没有等服务器回调
		local seatNum = self:_getPlayerSeat()
		if self.roomData.playerReady[seatNum + 1] == true then
            ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_GameReady(self.roomData.roomId, seatNum, false )
		else
            ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_GameReady(self.roomData.roomId, seatNum, true )
		end
	end
end

-- 点击物品后的回调
function SceneMarryCopy:onClickListItem(tItem, nTag, tData)
    WZLog("SceneMarryCopy:onClickListItem")
    WndItemInfo:onCloseClick()
    local con = GetElement(self.m_root,"conTips_SceneMarryCopy",WZUIContainer)
    WndItemInfo:showInfo(tItem.m_root,con,1,tData, false, nil)
end

--@brief    点击扫荡按钮回调
function SceneMarryCopy:onSweepClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local seatNum = self:_getPlayerSeat()
    if self.roomData.playerReady[seatNum + 1] and not self:_isRoomOwner() then
        MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
        return
    end

    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    -- 默认选择当前难度的下一个难度等级
    local nMaxDif = 0
    for k,v in pairs(GDatatab_team_map) do
        if tonumber(v.map_num) == 0 and nMaxDif < 4 then
            nMaxDif = nMaxDif + 1
        end
    end

    local selfIndex = self:_getPlayerDataIndex()
    local starCnt = self.roomData.playerStar[selfIndex]
    WZLog("SceneMarryCopy:onSweepClick starCnt:", starCnt)
    local roomData = self.roomData
   
    local tempMapInfo = GDatatab_team_map["id_" .. roomData.mapId]
    if tempMapInfo.quickly_sweep <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.SWEEP_COPY_NOT_TIP)
        return
    end

    local playerInfo = CacheCenter:getPlayerInfo()

    if playerInfo.level < tempMapInfo.sweep_level then
        local tip = string.format(LocalStrings.SWEEP_COPY_LEVEL_OPEN_TIP, tempMapInfo.sweep_level)
        MsgBoxManager:showTipBox(tip)
        return
    end

    if playerInfo.fighting < tempMapInfo.sweep_fight then
        local tip = string.format(LocalStrings.CARD_COUNT1,LocalStrings.BATTLE)
        MsgBoxManager:showTipBox(tip)
        return
    end

    if starCnt < nMaxDif then
        MsgBoxManager:showTipBox(LocalStrings.PASS_HARD_COPY_TIP)
        return
    end

    local allPower = tempMapInfo.pass_consume + tempMapInfo.play_consume

    if CacheCenter:getPlayerInfo().vigor < allPower then
        judgeNotEnoughJump(self, self.buyVigors)
        return
    end

    if not JudgeMoneyIsEnough(self.m_tSweepCost[1], self.m_tSweepCost[2], nil, nil, Chat_Channel_Team_Copy_Room) then
        return
    end

    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    ProtocolProcessorSingleMap:send_MAP_StartRaidsTeam(tempMapInfo.id, 1)
end

function SceneMarryCopy:buyVigors(nId, nType)
    if nType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(1056)
    end
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
--@brief	scene更新函数
--@note 	实际上的初始化函数

-- 创建一个掉落物品
function SceneMarryCopy:_createCellGoodItem(nItemId)
    local eItem, tItem = CellGoodItem:createElement()
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

-- 更新副本信息
function SceneMarryCopy:_updateMapInfo()
    local roomData = self.roomData
    local tCopyData = GDatatab_team_map["id_"..roomData.mapId]

    -- 副本名字
    local sDif = {LocalStrings.NORMAL, LocalStrings.DIFFICULTY, LocalStrings.HELL}
    local txtMapName = GetElement(self.m_root, "txtCopyName_SceneMarryCopy", WZUILabelTTF)
    txtMapName:setText(roomData.mapName)

    -- 房间信息
    local txt = GetElement(self.m_root, "txtCopyDesc_SceneMarryCopy", WZUILabelTTF)
    txt:setText(tCopyData.map_desc)

    -- 掉落物品
    local tbconDrop = GetElement(self.m_root, "tbconDrop_SceneMarryCopy", WZUITableContainer)
    tbconDrop:cleanTable()
    local tDropData = tCopyData.reward_boy[1]
    if CacheCenter:getPlayerInfo().sex == 1 then tDropData = tCopyData.reward_girl[1] end
    if tDropData then
        for i = 1 ,#tDropData do
            local eItem, tItem = self:_createCellGoodItem(tDropData[i])
            eItem:setTag(i-1)
            tbconDrop:setCellElement(eItem)
        end
    end

    -- 更新难度
    self.selDiff = tCopyData.difficulty
    self:_setDifCheckBox()
end


-- 更新开始(也是准备、取消)游戏按钮
function SceneMarryCopy:_updateGameButton()
	WZLog("SceneMarryCopy:_updateGameButton")
	-- if not self:_isRoomOwner() then
 --        --房客
 --        local seatNum = self:_getPlayerSeat()
 --        local imgPath = {"ui/common/common_icon_zhunbei2.png","ui/common/common_icon_qxzb.png"}
 --        local imgBtn = GetElement(self.m_root, "imgBtnDesc_SceneMarryCopy", WZUIImage)
 --        local needImg = self.roomData.playerReady[seatNum+1] and imgPath[2] or imgPath[1]
 --        imgBtn:setFile(needImg)
	-- end

    if not self:_isRoomOwner() then
        local seatNum = self:_getPlayerSeat()
        local str = {LocalStrings.READY_GAME,LocalStrings.CANCEL_READY_GAME}
        local txtStartGame = GetElement(self.m_root,"txtStartGame_SceneMarryCopy",WZUILabelTTF)
        local needStr = self.roomData.playerReady[seatNum+1] and str[2] or str[1]
        txtStartGame:setText(needStr)
    end
end



--@brief    获取玩家座位号
function SceneMarryCopy:_getPlayerSeat()
	WZLog("SceneMarryCopy:_getPlayerSeat")
	for k,v in ipairs(self.roomData.playerId) do
		if v == GlobalGame.g_tPlayerInfo.nPlayerId then
			return k-1
		end
	end
	return -1
end

--@brief    房间是否满人
function SceneMarryCopy:_roomIsFull()
	WZLog("SceneMarryCopy:_roomIsFull")
    local isFull = self:_getPlayerNum() == 3 and true or false
	return isFull
end

--@brief    获取房间玩家的个数
function SceneMarryCopy:_getPlayerNum()
	WZLog("SceneMarryCopy:_seatIsFull")
	local num = 0
	for i=1 , #self.roomData.playerId do
		if self.roomData.playerId[i] > 0 then num = num + 1 end
	end
	return num
end

-- 是否所有玩家已准备
function SceneMarryCopy:_allPlayersReady()
	for i=1, self.roomData.playerNum do
		if self.roomData.playerId[i] > 0  and not self.roomData.playerReady[i] then
			return false
		end
	end
	return true
end


-- 获取玩家数据在数据列表里面的下标
function SceneMarryCopy:_getPlayerDataIndex()
	for i=1, #self.roomData.playerId do
		if self.roomData.playerId[i] == GlobalGame.g_tPlayerInfo.nPlayerId then
			return i
		end
	end
end

-- 设置选择难度的checkbox
function SceneMarryCopy:_setDifCheckBox()
    --最大4个
    local nMaxDif = 0
    for k,v in pairs(GDatatab_team_map) do
        if tonumber(v.map_num) == 0 and nMaxDif < 4 then
            nMaxDif = nMaxDif + 1
        end
    end
    WZLog("SceneMarryCopy:_setDifCheckBox() nMaxDif:",nMaxDif)

    for i = 1, nMaxDif do
        local state = self.selDiff == i and 1 or 0
        local check = GetElement(self.m_root, "checkBox"..i.."_SceneMarryCopy", WZUICheckBox)
        check:setCheckIndex(state)
        if nMaxDif == 4 then
            check:setScale(0.7)
            check:setVisible(true)
        end
    end

    --检查房主星级,不够星级的星星灰色
    local selfIndex = self:_getPlayerDataIndex()
    local starCnt = self.roomData.playerStar[selfIndex]
    WZLog("SceneMarryCopy:_setDifCheckBox() starCnt:", starCnt)
    -- for i = 1, nMaxDif do
    --     if starCnt < i then
    --         local imgCheck = GetElement(self.m_root, "imgCheckStar"..i.."_SceneMarryCopy", WZUIImage)
    --         local imgCheckSel = GetElement(self.m_root, "imgCheckStarSel"..i.."_SceneMarryCopy", WZUIImage)
    --         imgCheck:setGrayRender(true)
    --         imgCheckSel:setGrayRender(true)
    --     end
    -- end
    for i = 1, nMaxDif do
        if starCnt >= i and i <= 3 then
            local imgxingxing = GetElement(self.m_root, "imgxingxing"..i.."_SceneMarryCopy", WZUIImage)
            imgxingxing:setFile("ui/common/common_icon_xingxing5.png")
        end
    end
end

--@brief  玩家装备更改回调函数
function SceneMarryCopy:updateDecorationData()
    WZLog("SceneRoom:updateDecorationData ---- ")
    if self.m_root == nil then  return end
    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateRoom(
        self.roomData.roomId,
        self.roomData.playerNumMode,
        self.roomData.passWord,
        self.roomData.mapId,
        self.roomData.wnersId,
        self.roomData.roomName)
end

--@brief   玩家宠物信息更新回调函数
function SceneMarryCopy:updatePlayerPetInfoData()
    WZLog("SceneRoom:updatePlayerPetInfoData")
    if self.m_root == nil then  return end
    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateRoom(
        self.roomData.roomId,
        self.roomData.playerNumMode,
        self.roomData.passWord,
        self.roomData.mapId,
        self.roomData.wnersId,
        self.roomData.roomName)
end

-- 监听玩家信息改变
function SceneMarryCopy:updatePlayerInfoData()
    WZLog("SceneRoom:updatePlayerInfoData")
    if self.m_root == nil then  return end
    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateRoom(
        self.roomData.roomId,
        self.roomData.playerNumMode,
        self.roomData.passWord,
        self.roomData.mapId,
        self.roomData.wnersId,
        self.roomData.roomName)
end



function SceneMarryCopy:_shieldClick()
    if self.m_root == nil then return end

    local playerId = self.roomData.playerId
    local wnersId = self.roomData.wnersId
    local ready = self.roomData.playerReady
    local selfId = CacheCenter:getPlayerInfo().id

    -- 自己是房主，返回一直可以点击
    if selfId == wnersId then
--        if self.topCell and self.topCell.tcell then
--            self.topCell.tcell:setShieldClick(false)
--            return
--        end

        self.topCell.tcell:setShieldClick(false)
        return
    end

    -- 否则准备就不能点击
    for i = 1, #playerId do
        if playerId[i] == selfId then
--            if self.topCell and self.topCell.tcell then
--                self.topCell.tcell:setShieldClick(ready[i])
--                return
--            end
            self.topCell.tcell:setShieldClick(ready[i])
            return
        end
    end
end


-- 聊天冒泡
function SceneMarryCopy:showChat(txtMsg,playerId,bubbleId)
    WZLog("---------------SceneMarryCopy:showChat-----------",txtMsg,playerId)
    local cell = self:getPlayerPosById(playerId)
    local cellChatBubble = cell:getChildByTag(999)
    if not cellChatBubble then
        local ps = cell:convertToWorldSpace(GlobalMethod:ccp(0,0))
        local size = cell:getContentSize()
        WZLog("---------------size----------------",ps.x,ps.y,size.width,size.height)
        ps = self.m_root:convertToNodeSpace(ps)
        ps.x = ps.x + size.width*3/4
        ps.y = ps.y + size.height
        local cellChatBubblenode,luaObject  = CellChatBubble:showChatBubble(self.m_root,ps)
        cellChatBubblenode:setTag(999)
        luaObject:addMsgToList(txtMsg,playerId,bubbleId)
    else
        cellChatBubble = WZUIContainer:luaTo(cellChatBubble)
        local luaObject = cellChatBubble:getLuaObjectIndex()
        luaObject:addMsgToList(txtMsg,playerId,bubbleId)
    end
end

-- 获取对于的说话玩家的座位信息
function SceneMarryCopy:getPlayerPosById(playerId)
    for i = 1, 2 do
        local cell,tcell = self.seatCell[i].cell,self.seatCell[i].tcell
        local pId = tcell:getPlayerId()
        WZLog("------------seat playerId ------------",pId)
        if pId == playerId then
            return cell
        end
    end
end

-- 更新开始游戏按键的描述
function SceneMarryCopy:_updateStartBtnDesc()
    -- local imgPath = {"ui/common/common_icon_ksyx.png","ui/common/common_icon_zhunbei2.png","ui/common/common_icon_qxzb.png"}
    -- local imgBtn = GetElement(self.m_root, "imgBtnDesc_SceneMarryCopy", WZUIImage)
    -- if self:_isRoomOwner() then
    --     imgBtn:setFile(imgPath[1])
    -- else
    --     imgBtn:setFile(imgPath[2])
    -- end

    local str = {LocalStrings.START_GAME,LocalStrings.READY_GAME,LocalStrings.CANCEL_READY_GAME}
    local txtStartGame = GetElement(self.m_root,"txtStartGame_SceneMarryCopy",WZUILabelTTF)
    if self:_isRoomOwner() then
        txtStartGame:setText(str[1])
    else
        txtStartGame:setText(str[2])
    end
end
-------------------------------------私有方法模块End----------------------------------------
function SceneMarryCopy:_update()
    if not self.m_root then return end

    -- 更新游戏开始
    self:_updateStartBtnDesc()

    --更新按钮点击状态
    self:_updateGameButton()

    -- -- 更新队伍战斗力
    -- self:_updateCurTeamFight()

    -- 创建人物信息
    self:_createPlayer()

    --更新副本信息
    self:_updateMapInfo()
end


--@brief    是否为房主
function SceneMarryCopy:_isRoomOwner()
    WZLog("SceneMarryCopy:_isRoomOwner")
    local isOwner = self.roomData.wnersId == GlobalGame.g_tPlayerInfo.nPlayerId and true or false
    return isOwner
end

-- 更新玩家战斗力
function SceneMarryCopy:_updateCurTeamFight()
    --fight
    local curFight = GDatatab_team_map["id_"..self.roomData.mapId].fight
    local txtFight = GetElement(self.m_root, "txtSugFight_SceneMarryCopy", WZUIFreeTextBox)
    WZLog("-----------------curFight-------------------",curFight,self.allFight)
    if tonumber(curFight) <= tonumber(self.allFight) then
        local str = [[<T C="233,166,62" S="24" P="0">%s</T><T C="255,89,74" S="22" P="0">%d</T>]]
        local text = string.format(str,LocalStrings.ADVISE_FIGHT,curFight)
        txtFight:setShowText(text)
    else
        local str = [[<T C="233,166,62" S="24" P="0">%s</T><T C="255,89,74" S="22" P="0">%d</T>]]
        local text = string.format(str,LocalStrings.ADVISE_FIGHT,curFight)
        txtFight:setShowText(text)
    end
end

-- 更新副本次数和消耗体力
function SceneMarryCopy:initPlayCntAndPower()
    local copyData = self.copyData[1]
    local localData = copyData[1]
    -- 今日剩余挑战次数
    local str = [[<T C="127,70,26" S="20" P="0">%s</T><T C="229,105,22" S="20" P="0"> %d</T>]]
    local passTime = copyData.userData.passTime
    local totalTime = localData.challenge_num
    local leftTime = totalTime - passTime
    WZLog("------------leftCnt-------------",passTime,totalTime)
    local text = string.format(str,LocalStrings.TODAY_REST_COUNT,leftTime)
    local ftbCnt = GetElement(self.m_root, "ftbCnt_SceneMarryCopy", WZUIFreeTextBox)
    ftbCnt:setShowText(text)

    local str = [[<T C="127,70,26" S="20" P="0">%s</T><T C="229,105,22" S="20" P="0"> %d</T><I Z="0.6" P = "1">ui/common/common_icon_huoli.png</I>]]
    local allPower = localData.pass_consume+localData.play_consume
    WZLog("-----------all power--------------",allPower)
    local text = string.format(str,LocalStrings.SINGLE_MAP_USEVIGOR,allPower)
    local ftbPower = GetElement(self.m_root, "ftbPower_SceneMarryCopy", WZUIFreeTextBox)
    ftbPower:setShowText(text)
end

-- 创建玩家
function SceneMarryCopy:_createPlayer()
    WZLog("--------------create player--------------")
    local roomData = self.roomData
    for i = 1, 2 do
        local conP = GetElement(self.m_root, "conPlayer"..i.."_SceneMarryCopy", WZUIContainer)
        if conP:getChildByTag(99) then conP:removeChildByTag(99,true) end

        local pId = roomData.playerId[i]
        local cell,tcell = CellMarryCopySeat:createElement()
        conP:addChild(cell,0,99)
        local seatCell = {cell = cell,tcell = tcell }
        self.seatCell[i] = seatCell

        if pId and pId ~= 0 then
            local data = {}
            data.wnersId = roomData.wnersId
            data.roomId = roomData.roomId
            data.playerId = roomData.playerId[i]
            data.playerName = roomData.playerName[i]
            data.playerLevel = roomData.playerLevel[i]
            data.playerReady = roomData.playerReady[i]
            data.playerSex = roomData.playerSex[i]
            data.headColor = roomData.headColor[i]
            data.bodyColor = roomData.bodyColor[i]
            data.pet = json.decode(roomData.pet[i])
            data.extranInfo = json.decode(roomData.extranInfo[i])
            data.serverId = roomData.serverId[i]
            data.pos = i

            local equip = {}-- 装备特殊处理
            for k = 1, 5 do
                local info = roomData.playerEquipment[(i-1)*5 + k]
                table.insert(equip,info)
            end
            data.playerEquipment = equip
            tcell:setData(data)
        else
            tcell:setData(nil)
        end
    end

    self:showCoupleAnimation()
end

-- 获取弹框TIPS容器
function SceneMarryCopy:getConTips()
    local con = GetElement(self.m_root,"conTips_SceneMarryCopy",WZUIContainer)
    return con
end

--@brief    设置技能方案的名字
function SceneMarryCopy:setSkillSuitName()
    -- body
    if not CheckButtonOpen(172, false) then return end 
    local tSkillSuit = CacheCenter:getSkillSuit()
    if tSkillSuit == nil then 
        ProtocolProcessorRecycling:send_PLAYERITEM_GetSuit(8)
        return 
    end

    local txtSkillSuitName = GetElement(self.m_root, "txtSkillSuitName_SceneMarryCopy", WZUILabelTTF)
    for i = 1, #tSkillSuit do
        if tSkillSuit[i].bIsUsed then 
            txtSkillSuitName:setText(tSkillSuit[i].name .. LocalStrings.SKILLSUIT_TAIL)
            break 
        end
    end
end


--@brief    显示伴侣互动动画
function SceneMarryCopy:showCoupleAnimation()
    local bShow = true
    for i=1,2 do
        local pId = self.roomData.playerId[i]
        if pId and pId ~= 0 then
        else
            bShow = false
            break
        end
    end
    for i=1,2 do
        if self.roomData.playerId[i] ~= 0 and self.seatCell and self.seatCell[i] and self.seatCell[i].cell and self.seatCell[i].tcell then
            ShowCoupleAni(self.seatCell[i].cell, true, GlobalMethod:ccp(0.5,0.74), 1)
        else
            ShowCoupleAni(self.seatCell[i].cell, false, GlobalMethod:ccp(0.5,0.74), 1)
        end
    end
end

-------------------------------------语言适配Begin------------------------------------------
function SceneMarryCopy:_adaptLanguage_pt(  )
    local txtReward = GetElement(self.m_root,"txtReward_SceneMarryCopy",WZUILabelTTF)
    txtReward:setDimensions(GlobalMethod:CCSize(80))
    txtReward:setScale(0.8)
end
function SceneMarryCopy:_adaptLanguage_es(  )
    local txtReward = GetElement(self.m_root,"txtReward_SceneMarryCopy",WZUILabelTTF)
    txtReward:setDimensions(GlobalMethod:CCSize(120))
    txtReward:setScale(0.5)
end
function SceneMarryCopy:_adaptLanguage_en(  )
    local txtReward = GetElement(self.m_root,"txtReward_SceneMarryCopy",WZUILabelTTF)
    txtReward:setScale(0.8)
end
function SceneMarryCopy:_adaptLanguage_tr(  )
    local txtReward = GetElement(self.m_root,"txtReward_SceneMarryCopy",WZUILabelTTF)
    txtReward:setFontSize(16)
end
function SceneMarryCopy:_adaptLanguage_en(  )
    local txtCopyDesc = GetElement(self.m_root, "txtCopyDesc_SceneMarryCopy", WZUILabelTTF)
    txtCopyDesc:setScale(0.8)
    txtCopyDesc:setDimensions(GlobalMethod:CCSize(450))
    GetElement(self.m_root, "ftbPower_SceneMarryCopy", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.819684,0.5))
    local txtReward = GetElement(self.m_root,"txtReward_SceneMarryCopy",WZUILabelTTF)
    txtReward:setDimensions(GlobalMethod:CCSize(80))
    txtReward:setScale(0.8)
end

function SceneMarryCopy:_adaptLanguage_vn(  )
    local ftxtSweep = GetElement(self.m_root, "ftxtSweep_SceneMarryCopy", WZUIFreeTextBox)
    ftxtSweep:setMaxWidth(200)
    ftxtSweep:setScale(0.8)
end
-------------------------------------语言适配End--------------------------------------------
