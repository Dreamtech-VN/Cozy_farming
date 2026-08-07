--ScenePvpRank.lua
--@brief	ScenePvpRank的UI模块
--@date		2015-11-11
--@author	binshao
--@note		排位赛大厅


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function ScenePvpRank:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    self:_adaptIphoneX()
    self:_addTop()
    
    self:register()

    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    ChangeChatChannel(Chat_Channel_Pvp_Rank)

    CacheCenter:registerUpdateDecorationObserver(self)
    CacheCenter:registerUpatePlayerInfoObserver(self)

    self:initFootLayer()
    self.m_bIsStartMove = true
    local conInfo = GetElement(self.m_root,"conPlayerInfo_ScenePvpRank",WZUIContainer)
    conInfo:enableSchedule("playRoleAni", 0)

    WndChat:addChatWindowToCurScene()
    SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)
    IsShowPunishTime(false)
end

--@brief onEnter函数执行完成回调
function ScenePvpRank:onEnterTransitionDidFinish(element)
    self.m_tInitDate = json.decode(CacheCenter:getGameParam()["trioRankMatchConfig"]) 
    WZLog("ScenePvpRank:onEnterTransitionDidFinish",Serialize(self.m_tInitDate))
    WndPvpRankUpgrade:Show()
    --buff加成按钮
    CacheCenter:updateArenaAddInfo()
    local info = CacheCenter:getArenaAddInfo()
    local btnArenaAddInfo = GetElement(self.m_root,"btnArenaAddInfo_ScenePvpRank",WZUIButton)
    if #info.addValue > 0 then
        btnArenaAddInfo:setVisible(true)
        if GlobalGame.g_tRedPointList and GlobalGame.g_tRedPointList.pvpBuff then 
            GetElement(self.m_root, "imgARedDot_ScenePvpRank", WZUIImage):setVisible(true)
        end
    else
        btnArenaAddInfo:setVisible(false)
    end
    btnArenaAddInfo:enableSchedule("onSchedule", 10)

    self:_createLoadingBox()
    ProtocolProcessorScenePvpRank:send_TRIO_GetMatchInfo()

    ProtocolProcessorScenePvpRank:send_TRIO_GetMathcRank()

	if WndGangsterInn.m_bShouldClose == true then
		WndGangsterInn.m_bShouldClose = false
		MsgBoxManager:showTipBox(LocalStrings.INN12)
	end

	upPlayerFightingAni()
    WZLog("ScenePvpRank:onEnterTransitionDidFinish", RANK_OVER_REWARD_ID, RANK_OVER_REWARD_COUNT)
    if RANK_OVER_REWARD_COUNT and RANK_OVER_REWARD_ID and RANK_OVER_REWARD_ID ~= "" and RANK_OVER_REWARD_COUNT ~= 0 then
        local id, num = SplitItemString(RANK_OVER_REWARD_ID)
        WndRewardShow:showById(id, num, nil, nil, nil, nil, nil, 1)
        RANK_OVER_REWARD_ID = nil
        RANK_OVER_REWARD_COUNT = nil
    end

    --挂机设置
    GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change",'state_hall')

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(48)
    WZLog("ScenePvpRank:onEnter two", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 23 then
        TeachGroup1:endTeachStep({48,2})
        TeachGroup1:startGroup({48,3,self.m_root})
    end
end

function ScenePvpRank:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_pws.png",ScenePvpRank,ScenePvpRank.OnReturn,false,true,true,"ScenePvpRank")
    tcell:setTopType()
    tcell:setWifiSignalVisible(false)
end

function ScenePvpRank:register()
    GlobalGame:getGameEventDispathcer():Add(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown,self._onScenePvpRankInfoData,self)
end
function ScenePvpRank:unregister()
    GlobalGame:getGameEventDispathcer():Remove(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown,self._onScenePvpRankInfoData,self)
end
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function ScenePvpRank:onExit(element)
    WZLog("ScenePvpRank:onExit")
    if self.m_root then 
        local btnArenaAddInfo = GetElement(self.m_root,"btnArenaAddInfo_ScenePvpRank",WZUIButton)
        btnArenaAddInfo:disableSchedule()
    end
    CacheCenter:unregisterUpateDecorationObserver(self)
    CacheCenter:unregisterUpatePlayerInfoObserver(self)

    FootEffectManager:getInstance():destroy()
    local conInfo = GetElement(self.m_root,"conPlayerInfo_ScenePvpRank",WZUIContainer)
    conInfo:disableSchedule()

	self:_unInit()
    self:unregister()
end

function ScenePvpRank:initFootLayer()
    if not self.m_root then
        return
    end
    local conPlayer = GetElement(self.m_root, "conPlayer_ScenePvpRank", WZUIContainer)
    FootEffectManager:getInstance():setFootLayer(conPlayer)
end

-- 更新个人信息
function ScenePvpRank:update()
    if self.m_root == nil then return end
    self:_updatePlayerInfo()
end

function ScenePvpRank:_createLoadingBox()
    if not self.loadingId then  self.loadingId = MsgBoxManager:showLoadingBox(20) end
end

function ScenePvpRank:_closeLoadingBox()
    MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
    self.loadingId = nil
end

-- 返回
function ScenePvpRank:OnReturn()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1])
    else
        local scene = ScenePvp:createElement()
        replaceScene(scene)
    end
end


-- 查看人物属性
function ScenePvpRank:onCheckInfo(element)
	WZLog("ScenePvpRank:onCheckInfo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local con = GetElement(self.m_root,"conTips_ScenePvpRank",WZUIContainer)
	WndTips:show(element,con,27,nil,GlobalMethod:ccp(-200,-135))
    TeachGroup1:endTeachStep({48,3})
end


-- 说明
function ScenePvpRank:onRuleClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.PVP_RANK_DESC)
end

-- 赛季奖励
function ScenePvpRank:onMatchReward(element)
    WZLog("-----------------onMatchReward------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()

    WndPvpRankList:showWndUI(nTag, self.data)
end

-- 查看宠物信息
function ScenePvpRank:OnPet()
    WZLog("-------------------click pet--------------------")
    local petInfo = CacheCenter:getPlayerInfo().petInfo
    if not petInfo then return end
    local conPet = GetElement(self.m_root,"conPet_ScenePvpRank",WZUIContainer)
    local con =  GetElement(self.m_root,"conMain_ScenePvpRank",WZUIContainer)
    WndTips:show(conPet,con,13,petInfo,GlobalMethod:ccp(400,-40))
end

-- 获取玩家的武器
function ScenePvpRank:onWeapon()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local conEquip= GetElement(self.m_root,"conWeapon_ScenePvpRank",WZUIContainer)
    local weaponInfo = {}
    local equip = CacheCenter:getEquipmentList()
    for k,v in pairs(equip) do
        if v.maintype == 4 and (v.subtype == 1 or v.subtype == 0) then
            weaponInfo = v
            break
        end
    end
    local con = GetElement(self.m_root,"conTips_ScenePvpRank",WZUIContainer)
    WndItemInfo:showInfo(conEquip,con,1,weaponInfo,false,nil,false)
end

-- 动画播完后调用
function ScenePvpRank:playRoleAni()
    if self.m_bIsStartMove == true then
        if self.conPlayer then
            if self.m_bIsMoveAni == nil then
                self.m_bIsMoveAni = true
            end
            if self.m_bIsMoveAni or self.conPlayer:isCurrentAnimationDone() then
                self.m_bIsMoveAni = false
                local nScale = 1.2
                if CacheCenter:getPlayerInfo().shapeId ~= nil and CacheCenter:getPlayerInfo().shapeId > 0 then
                    self.conPlayer:play(g_tRoleAnitionName[3], true)
                    nScale = 1.2
                elseif CacheCenter:getPlayerInfo().mountsId ~= nil then
                    local name
                    if CacheCenter:getPlayerInfo().mountsType and CacheCenter:getPlayerInfo().mountsType == 1 then
                        name = "wait"
                    elseif CacheCenter:getPlayerInfo().mountsType and CacheCenter:getPlayerInfo().mountsType == 2 then
                        name = "walk2"
                    elseif CacheCenter:getPlayerInfo().mountsType and CacheCenter:getPlayerInfo().mountsType == 3 then
                        name = "walk3"
                    elseif CacheCenter:getPlayerInfo().mountsType and CacheCenter:getPlayerInfo().mountsType == 4 then
                        name = "walk4"
                    else
                        name = "walk"
                    end
                    self.conPlayer:play(name, true)
                    nScale = 1.1
                else
                    self.conPlayer:play(g_tRoleAnitionName[3], true)
                    nScale = 1.2
                end

            --    self.conPlayer:getAnimNode():setScale(nScale) --人物大小
            end

            self:playerMove()
        end
    else
        if self.conPlayer and self.conPlayer:isCurrentAnimationDone() then
            self.conPlayer:play("wait0", true)
        --    self.conPlayer:getAnimNode():setScale(1.2) --人物大小
        end
    end
end

-- 人物移动
function ScenePvpRank:playerMove()
    local speed = 4 --移动速度
    -- 玩家位置
    if self.firstPost == nil then
        self.firstPost = self.conPlayer:getPosition()
    end
    if self.curPost == nil then
        self.curPost = self.conPlayer:getPosition()
        self.curPost.x = self.curPost.x-300
    end
    self.curPost.x=self.curPost.x+speed
    -- 宠物位置
    local conPet = GetElement(self.m_root,"conPet_ScenePvpRank",WZUIContainer)
    if self.petFirstPost == nil then
        self.petFirstPost = {}
        self.petFirstPost.x,self.petFirstPost.y = conPet:getPosition()
    end
    if self.petCurPost == nil then
        self.petCurPost = {}
        self.petCurPost.x,self.petCurPost.y = conPet:getPosition()
        self.petCurPost.x = self.petCurPost.x-300
    end
    self.petCurPost.x=self.petCurPost.x+speed


    if self.curPost.x < self.firstPost.x then
        self.conPlayer:setPosition(self.curPost)
        self:updateFootEffect()

        conPet:setPosition(self.petCurPost.x,self.petCurPost.y)
    else
        self.curPost.x = self.firstPost.x
        self.conPlayer:setPosition(self.curPost)

        self.petCurPost.x = self.petFirstPost.x
        conPet:setPosition(self.petCurPost.x,self.petCurPost.y)

        self.m_bIsStartMove = false
        self.firstPost = nil
        self.curPost = nil
        self.petFirstPost = nil
        self.petCurPost = nil

        -- self.conPlayer:play("wait0", true)
        self.conPlayer:play(g_tRoleAnitionName[2], false)
    --    self.conPlayer:getAnimNode():setScale(1.2) --人物大小
    end
end

--@brief 足迹刷新
function ScenePvpRank:updateFootEffect()
    if CacheCenter:getUsingFootMarkId() == nil then return end

    local pos = self.conPlayer:getPosition()
    if not self.m_tOldFootPos then
        self.m_tOldFootPos = pos
    end
    local footId = CacheCenter:getUsingFootMarkId()
    local distance = GDatatab_footmark["id_" .. footId] and GDatatab_footmark["id_" .. footId].distance or 40
    if BattleCommon:pointDis(self.m_tOldFootPos,pos) > distance then
        self.m_tOldFootPos = pos
        FootEffectManager:getInstance():addEffect(footId, pos, 45, self.conPlayer:getAnimNode():getScaleX(),self.conPlayer:getAnimNode():getScaleY())
    end
end

-- 点击人物动画
function ScenePvpRank:onRole()
    if self.conPlayer and self.m_bIsStartMove~=true then self.conPlayer:play(g_tRoleAnitionName[2], false) end
end

-- 查看玩家段位信息
function ScenePvpRank:OnSegment(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("------------------segment--------------------")
    local con = GetElement(self.m_root,"conTips_ScenePvpRank",WZUIContainer)
    
end

-- 开始战斗
function ScenePvpRank:OnFight()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("----------OnFight---------------")
    self:_initMarkTime()
end


function ScenePvpRank:onStartMatch(element)
    WZLog("ScenePvpRank:onStartMatch")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    if not self.data.openFlag then
        MsgBoxManager:showTipBox(LocalStrings.LEAGUE54) -- 未开启
        return
    end

    self.nStartMathIndex = tag
    
    ProtocolProcessorWndTask:send_PLAYER_GetHonourInfo( )

    if self.m_nCount == 0 then
        self.m_nCount = 1
        element:enableSchedule("scheduleCalculate",1)
    else
        return
    end    
end

function ScenePvpRank:_onScenePvpRankInfoData(honourPoint, restoreTime, serverTime)
    local _, score = GlobalMethod:HonorPointStatus(4)
    if tonumber(honourPoint) >= score then
        if IsShowPunishTime(true) then return end
        if self.nStartMathIndex then
            self.nStartMathIndex = tonumber(self.nStartMathIndex)
            if self.nStartMathIndex == 1 then
                local num = math.random(1,5)
                local roomName = LocalStrings.ROOM_NAME_RANDOM[num]
                ProtocolProcessorSceneArena:send_ROOM_CreateRoom(roomName, 1, self.personCnt, "-1", self.matchMode,self.channel,0)
            elseif self.nStartMathIndex == 2 then
                ProtocolProcessorScenePvpRank:send_ROOM_QuickGame(self.channel,1,0)
                self:_initMarkTime()
            end
        end
    else
        local status, score = GlobalMethod:HonorPointStatus(4)
        if status == false then
            WndHonorPoint:showInterface(score, honourPoint, restoreTime, serverTime)
        end
    end
end
--@brief    点击商店回调
function ScenePvpRank:onMatchShop(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndStore:showStoreByType(10)
end

function ScenePvpRank:scheduleCalculate(element)
    WZLog("ScenePvpRank:scheduleCalculate")
    element:disableSchedule()
    self.m_nCount = 0
end

-- 取消匹配
function ScenePvpRank:onCancelMatch()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("----------onCancelMatch---------------")
    self.m_bIsStartMatch = false
    ProtocolProcessorSceneHall:send_ROOM_EndPair(0)
    local con = GetElement(self.m_root,"conMark_ScenePvpRank",WZUIContainer)
    con:setVisible(false)
    local conMain = GetElement(self.m_root,"conMain_ScenePvpRank",WZUIContainer)
    conMain:disableSchedule()
end

-- 加成卡信息
function ScenePvpRank:onArenaAddInfoClick()
    WZLog("----------ScenePvpRank:onArenaAddInfoClick------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if GlobalGame.g_tRedPointList.pvpBuff then 
        GetElement(self.m_root, "imgARedDot_ScenePvpRank", WZUIImage):setVisible(false)
        GlobalGame.g_tRedPointList.pvpBuff = false
        ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(154)
    end

    local conMain = GetElement(self.m_root,"conMain_ScenePvpRank",WZUIContainer)
    if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "vn" then
        WndTips:show(conMain, ScenePvpRank.m_root, 32, {}, GlobalMethod:ccp(650,100))
    else 
        WndTips:show(conMain, ScenePvpRank.m_root, 32, {}, GlobalMethod:ccp(850,100))
    end
end


function ScenePvpRank:onSchedule(element,dt)
    if not self.m_root then
        return
    end
    CacheCenter:updateArenaAddInfo()
    local info = CacheCenter:getArenaAddInfo()
    
    local btnArenaAddInfo = GetElement(self.m_root,"btnArenaAddInfo_ScenePvpRank",WZUIButton)
    if #info.addValue > 0 then
        btnArenaAddInfo:setVisible(true)
    else
        btnArenaAddInfo:setVisible(false)
    end
end

-- 倒计时格式转换
function ScenePvpRank:_timeChangeStyle(time)
    WZLog("--******1212--",time)
    local h,m = 3600,60
    local hour = math.floor(time/h)
    local min = math.floor((time - hour*h)/m)
    --local sec = math.floor(time-hour*h-min*60)
    if hour < 10 then hour = "0"..hour end
    if min < 10 then min = "0"..min end
    --if sec < 10 then sec = "0"..sec end
    local str = hour..":"..min
    return str
end

-- 倒计时格式转换2
function ScenePvpRank:_timeCountDown(time)
    local min = math.floor(time/60)
    local sec = time%60
    local str = min..":"..sec
    return str
end

--@brief    开启倒计时
function ScenePvpRank:_updateOpenTime( element,time )
    local txtWords = GetElement(self.m_root, "txtStartTime_ScenePvpRank", WZUILabelTTF)
    if self.data.startTime > 0 then
        self.data.startTime = self.data.startTime - 1
        local str = self:_timeCountDown(self.data.startTime)
        txtWords:setText(LocalStrings.WORLD_BOSS_OPEN_TIME_DOWN..str)
        --策划要求少于半小时才显示
        if self.data.startTime <= 1800 then
            txtWords:setVisible(true)
        else
            txtWords:setVisible(false)
        end
    else
        element:disableSchedule()
    end
end

--@brief    结束倒计时
function ScenePvpRank:_updateEndTime( element,time )
    local txtWords = GetElement(self.m_root, "txtStartTime_ScenePvpRank", WZUILabelTTF)
    if self.data.endTime > 0 then
        self.data.endTime = self.data.endTime - 1
        local str = self:_timeCountDown(self.data.endTime)
        txtWords:setText(LocalStrings.ACTIVITY_END_COUNTDOWN..": "..str)
        --策划要求少于半小时才显示
        if self.data.endTime <= 1800 then
            txtWords:setVisible(true)
        else
            txtWords:setVisible(false)
        end
    else
        element:disableSchedule()
    end
end

-- 更新玩家个人信息
function ScenePvpRank:_updatePlayerInfo()
    if not self.data then return end
    
    local data = self.data
    local pvpLevel = data.pvpLevel
    local pInfo = CacheCenter:getPlayerInfo()
    local tTempData = GetPvpDataByLevel(pvpLevel)
    WZLog("ScenePvpRank:_updatePlayerInfo", Serialize(tTempData))
    -- 经验进度条和当前的经验值
    local txtPvpLevelExp = GetElement(self.m_root,"txtPvpLevelExp_ScenePvpRank", WZUILabelTTF)
    txtPvpLevelExp:setText(data.pvpScore .. "/" .. tTempData.honor)
    local prgCurExp =  GetElement(self.m_root,"prgCurExp_ScenePvpRank",WZUIProgress)
    prgCurExp:setPercentage(data.pvpScore / tTempData.honor *100)
    --保护标识
    local imgProtectedIcon = GetElement(self.m_root, "imgProtectedIcon_ScenePvpRank", WZUIImage)
    local txtProtectedText = GetElement(self.m_root, "txtProtectedText_ScenePvpRank", WZUILabelTTF)
    if tTempData.protect > 0 then
        imgProtectedIcon:setVisible(true)
        imgProtectedIcon:setRelativePosition(GlobalMethod:ccp(tTempData.protect/tTempData.honor, -0.45))
        --欧洲说屏蔽位置
        if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1043 or ProjConfig.CHANNEL_ID == 1044 
            or ProjConfig.CHANNEL_ID == 1047 or ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1051 or ProjConfig.CHANNEL_ID == 1053 or ProjConfig.CHANNEL_ID == 1061 or ProjConfig.CHANNEL_ID == 1062 then
            imgProtectedIcon:setVisible(false)
        end

        txtProtectedText:setVisible(true)
        if data.pvpScore >= tTempData.protect then
            prgCurExp:setBgPicture("ui/common/common_progress_exp_fore2.png")
            txtProtectedText:setColor(GlobalMethod:ccc3(127,70,26))
            txtProtectedText:setText(LocalStrings.PVPRANK_PROTECTED_ATT2)
        else
            prgCurExp:setBgPicture("ui/common/common_progress_exp_fore.png")
            txtProtectedText:setColor(GlobalMethod:ccc3(158,0,0))
            txtProtectedText:setText(string.format(LocalStrings.PVPRANK_PROTECTED_ATT1, tTempData.protect - data.pvpScore))
        end
    else
        txtProtectedText:setVisible(false)
        prgCurExp:setBgPicture("ui/common/common_progress_exp_fore2.png")
        imgProtectedIcon:setVisible(false)
    end
    --设置玩家称号
    local txtTitle = GetElement(self.m_root, "txtPlayerTitle_ScenePvpRank", WZUILabelTTF)
    local conTitle = GetElement(self.m_root, "conTitle_ScenePvpRank", WZUIContainer)
    local sTitleContent = ""
    if pInfo.title ~= nil and pInfo.title ~= "" then
        sTitleContent = pInfo.title 
    end
    local tempPoint = GlobalMethod:ccp(0.5,2.7)
    CreateDesiSpine(conTitle, txtTitle, sTitleContent, tempPoint, true)

    -- 名字和等级
    local txtNameAndLv = GetElement(self.m_root, "txtPlayerLevel_ScenePvpRank", WZUIFreeTextBox)
    txtNameAndLv:setShowText(string.format(LocalStrings.SHOP_NAME_AND_LEVEL1,pInfo.level,pInfo.name))

    -- 战斗力
    local ftbFight = GetElement(self.m_root,"ftbFight_ScenePvpRank",WZUIFreeTextBox)
    ftbFight:setShowText(string.format(LocalStrings.FIGHT_POWER,pInfo.fighting))

    -- 人物形象
    self:updatePlayerDress()

    -- 宠物
    local petInfo = CacheCenter:getPlayerInfo().petInfo
    local conPet = GetElement(self.m_root,"conPet_ScenePvpRank",WZUIContainer)
    if petInfo then
        local aniPet,par = CreatePetAni(conPet,petInfo.itemId,petInfo.animation,petInfo.advancedLevel, petInfo.petSkinItemId)
        aniPet:getAnimNode():setScale(0.8)
        if par then par:setScale(0.8) end
    else
        conPet:removeAllChildrenWithCleanup(true)
    end

    -- 赛季名字
    local sSeasonFormat = [[<I Z="1" P="1">ui/pvp/sj_s.png</I><A IMG="ui/common_num/common_num_pws.png" P="1" W="38" H="46" CHAR="0">%s</A>]]
    local ftxtSeason = GetElement(self.m_root,"ftxtSeason_ScenePvpRank",WZUIFreeTextBox)
    if data.seasonNum == -1 then
        ftxtSeason:setShowText(string.format(sSeasonFormat, 1))
    else
        ftxtSeason:setShowText(string.format(sSeasonFormat, data.seasonNum))
    end
    --日期和开赛时间
    local txtDate = GetElement(self.m_root, "txtDate_ScenePvpRank", WZUILabelTTF)
    if txtDate then
        txtDate:setText(data.sYear .. LocalStrings.SPACE30 .. data.sMonth .. LocalStrings.SPACE31 .. data.sDay .. LocalStrings.SPACE32 .. "-" .. data.eDay .. LocalStrings.SPACE32)
    end
    if ProjConfig.LANGUAGE == "vn" then
        txtDate:setText(data.sDay.."/"..data.sMonth.."/"..data.sYear.."-"..data.eDay.."/"..data.sMonth.."/"..data.sYear)
    elseif ProjConfig.LANGUAGE == "pt" then
        txtDate:setText(data.sYear.."."..data.sMonth.." "..LocalStrings.SPACE32..data.sDay.."-"..LocalStrings.SPACE32..data.eDay)
    elseif ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
        txtDate:setText(data.sYear.."."..data.sMonth.." "..data.sDay.."-"..data.eDay)
    end
    local txtStartTime = GetElement(self.m_root, "txtStartTime_ScenePvpRank", WZUILabelTTF)
    
    --if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or 
        --ProjConfig.LANGUAGE == "en" then
        --txtStartTime:setText(LocalStrings.MAP_EVENT_ON .." " .. LocalStrings.EVERYDAY .. self.m_tInitDate.startTime .. "-" .. self.m_tInitDate.endTime)
        if self.data.startTime > 0 then
            local str1 = self:_timeCountDown(self.data.startTime)
            txtStartTime:setText(LocalStrings.WORLD_BOSS_OPEN_TIME_DOWN .. str1)
            txtStartTime:enableSchedule("_updateOpenTime",1)
        elseif self.data.startTime <= 0 and self.data.endTime > 0 then
            local str2 = self:_timeCountDown(self.data.endTime)
            txtStartTime:setText(LocalStrings.ACTIVITY_END_COUNTDOWN..": "..str2)
            txtStartTime:enableSchedule("_updateEndTime",1)
        end
    -- else
    --     if txtStartTime then
    --         txtStartTime:setText(LocalStrings.EVERYDAY .. self.m_tInitDate.startTime .. "-" .. self.m_tInitDate.endTime .. LocalStrings.MAP_EVENT_ON)
    --     end
    -- end
    --段位图标
    local conIcon = GetElement(self.m_root, "conIcon_ScenePvpRank", WZUIContainer)
    conIcon:removeAllChildrenWithCleanup(true)
    if conIcon then
        local celElement, tNewObj = CellPvpLevelIcon:createElement()
        if celElement and tNewObj then
            tNewObj:setPvpRankData(CacheCenter:getPlayerInfo().rankMatchMessage, data.pvpScore, CacheCenter:getPlayerInfo().myMaxSegmentLevel)
            tNewObj:setData(tTempData, false, nil, true)
            conIcon:addChild(celElement)
        end
    end
    --段位名字
    local txtPvpLevelName = GetElement(self.m_root, "txtPvpLevelName_ScenePvpRank", WZUILabelTTF)
    if txtPvpLevelName then
        if tTempData.id == 1 or tTempData.id == 999 then
            txtPvpLevelName:setText(tTempData.dan)
        else
            txtPvpLevelName:setText(tTempData.dan .. " " .. tTempData.level2)
        end
    end
    local ftxtPvpIntegral = GetElement(self.m_root, "ftxtPvpIntegral_ScenePvpRank", WZUIFreeTextBox)
    if ftxtPvpIntegral then
        ftxtPvpIntegral:setShowText(string.format(LocalStrings.PVP_HALL_32, tTempData.honor, 1))
    end
    --星星
    local conForStar = GetElement(self.m_root, "conForStar_ScenePvpRank", WZUIContainer)
    conForStar:removeAllChildrenWithCleanup(true)
    if tTempData.id == 999 then
        local sStarFormat = [[<I Z="0.64" P="1">ui/common/common_icon_xingxing5.png</I><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">X %d</T>]]
        local ftxtStar = WZUIFreeTextBox:create()
        ftxtStar:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        ftxtStar:setRelativePosition(GlobalMethod:ccp(0.5,0.836))
        ftxtStar:setMaxWidth(300)
        ftxtStar:setShowText(string.format(sStarFormat, tTempData.level))

        conForStar:addChild(ftxtStar)
    else
        for i = 1, tTempData.leve5 do
            local imgStar = WZUIImage:create()
            imgStar:setUseOriginSize(true)
            imgStar:setScale(0.64)
            imgStar:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
            local starccp = {GlobalMethod:ccp(0.26,0.76),GlobalMethod:ccp(0.37,0.81),GlobalMethod:ccp(0.51,0.83),GlobalMethod:ccp(0.65,0.81),GlobalMethod:ccp(0.76,0.76)}
            if tTempData.leve5 == 4 then
                starccp={GlobalMethod:ccp(0.3,0.79),GlobalMethod:ccp(0.43,0.826),GlobalMethod:ccp(0.57,0.826),GlobalMethod:ccp(0.7,0.79)}
            elseif tTempData.leve5 == 3 then
                starccp = {GlobalMethod:ccp(0.37,0.81),GlobalMethod:ccp(0.51,0.83),GlobalMethod:ccp(0.65,0.81)}
            end
            imgStar:setRelativePosition(starccp[i])
            if tTempData.level >= i then
                imgStar:setFile("ui/common/common_icon_xingxing5.png")
            else
                imgStar:setFile("ui/common/common_icon_xingxing5_sel.png")
            end
            conForStar:addChild(imgStar)
        end
    end
    --排位币今日获得
    local txtDropCoin = GetElement(self.m_root, "txtDropCoin_ScenePvpRank", WZUILabelTTF)
    if txtDropCoin then 
        txtDropCoin:setText(data.dropCoinNum .. "/" .. data.dayLimit)
    end
    --玩家个人掉星保护次数
    local txtProtTimes = GetElement(self.m_root, "txtPlayerProtectTimesCout", WZUILabelTTF)
    if txtProtTimes then
        if data.playerProtectTimes <= 0 then
            txtProtTimes:setText("")
        else
            txtProtTimes:setText(string.format(LocalStrings.COMMUNITY_TEXT4,data.playerProtectTimes))
        end
    end
end

-- 更新玩家信息
function ScenePvpRank:updatePlayerDress()
	WZLog("ScenePvpRank:updatePlayerDress")
    local con = GetElement(self.m_root,"conPlayer_ScenePvpRank",WZUIContainer)
    local childNode = con:getChildByTag(88)
    if childNode then
        childNode:removeFromParentAndCleanup(true)
        --return
    end
    local conAni = CreateSelfAni()
    self.conPlayer = conAni
    if CacheCenter:getPlayerInfo().mountsId then
        self.conPlayer:setMount(CacheCenter:getPlayerInfo().mountsId)
    end
    local node = conAni:getAnimNode()
    con:addChild(node,0,88)
end

-- 初始化匹配时间
function ScenePvpRank:_initMarkTime()
    self.markTime = 1
    self.m_bIsStartMatch = true
    local con = GetElement(self.m_root,"conMark_ScenePvpRank",WZUIContainer)
    con:setVisible(true)

    local lafTime = GetElement(self.m_root,"lafTime_ScenePvpRank",WZUILabelAtlasFont)
    lafTime:setText(self.markTime)

    self:updateDescTips()

    local conMain = GetElement(self.m_root,"conMain_ScenePvpRank",WZUIContainer)
    conMain:enableSchedule("_updateMarkTime",1)
end

-- 更新匹配时间
function ScenePvpRank:_updateMarkTime()
    self.markTime = self.markTime + 1
    local lafTime = GetElement(self.m_root,"lafTime_ScenePvpRank",WZUILabelAtlasFont)
    lafTime:setText(self.markTime)

    if self.markTime%5 == 0 then
        self:updateDescTips()
    end

    if self.markTime == 60 then
        local con = GetElement(self.m_root,"conMark_ScenePvpRank",WZUIContainer)
        con:setVisible(false)
        local conMain = GetElement(self.m_root,"conMain_ScenePvpRank",WZUIContainer)
        conMain:disableSchedule()
        MsgBoxManager:showTipBox(LocalStrings.MATCHFAIL, nil, nil, nil, nil)
        local imgBtn = GetElement(self.m_root,"imgFightBtn_ScenePvpRank", WZUIImage)
        if imgBtn then 
            imgBtn:setFile("ui/common/common_icon_tiaozhan.png")
        end
        self.fightBtnIndex = 0
    end
end

-- 显示获取的奖励
function ScenePvpRank:showReward(isSuccess)
    self:updateRedPoint()
end

-- 更新红点信息
function ScenePvpRank:updateRedPoint()
    -- 每日目标红点
    local visible1 = false
    for i = 1, 4 do
        local state = self.singleInfo.boxStatus[i]
        if state == 2 then
            visible1 = true
            break
        end
    end
    local imgRed = GetElement(self.m_root,"imgRed1_ScenePvpRank", WZUIImage)
    imgRed:setVisible(visible1)

    -- 赛季目标红点
    local visible2 = false
    for i = 1, 4 do
        local state = self.singleInfo.seasonboxStatu[i]
        if state == 2 then
            visible2 = true
            break
        end
    end
    local imgRed = GetElement(self.m_root,"imgRed2_ScenePvpRank", WZUIImage)
    imgRed:setVisible(visible2)
    WZLog("--------------red info-----------",visible1,visible2)
end

-- 监听时装改变
function ScenePvpRank:updateDecorationData()
    local sex = CacheCenter:getPlayerInfo().sex
    local tEquip = CacheCenter:getEquipmentList()
    if self.conPlayer then
        UpdatePlayerFigure(self.conPlayer:getAnimNode(),tEquip,sex)
    end
end

-- 监听玩家信息改变
function ScenePvpRank:updatePlayerInfoData()
    if self.m_root == nil then return end 
    
    self:_updatePlayerInfo()
end

-- 更新小提示
function ScenePvpRank:updateDescTips()
    local ttfDesc = GetElement(self.m_root,"txtTimeDownTip_ScenePvpRank",WZUILabelTTF)
    local nIndex = math.random(1, #LocalStrings.HALL_DESC2)
    if ttfDesc:getText() == LocalStrings.HALL_DESC2[nIndex] then
        nIndex = nIndex+1
        if nIndex > #LocalStrings.HALL_DESC2 then nIndex = 1 end
    end
    ttfDesc:setText(LocalStrings.TIPS..":"..LocalStrings.HALL_DESC2[nIndex])
end

-- 刷新排行榜
function ScenePvpRank:createMatchGoal()
    for i=1,5 do
        local conHead = GetElement(self.m_root,"conHead"..i.."_ScenePvpRank",WZUIContainer)
        local conRank = GetElement(self.m_root,"conRank"..i.."_ScenePvpRank",WZUIContainer)
        if self.matchGoal[i] then
            local m_bIsOffline = false
            CellHead:show(conHead,self.matchGoal[i].headId,self.matchGoal[i].faceId,self.matchGoal[i].sex, m_bIsOffline, nil, nil, self.matchGoal[i].headColor)
            conRank:setVisible(true)
        else
            conRank:setVisible(false)
        end

    end
end

--@brief    点击头像回调
function ScenePvpRank:onClickHead(element)
    local tag = element:getTag()
    if self.matchGoal[tag] == nil then return end

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCheckOther:show(self.matchGoal[tag].id)
end

--@brief    点击排位币
function ScenePvpRank:onClickRankCoin(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local itemId = 10
    local tData = {}
    tData.basicInfo = GDatatab_item["id_"..itemId]
    local conRankCoin = GetElement(self.m_root,"conRankCoin_ScenePvpRank",WZUIContainer)
    WndItemInfo:showInfo(conRankCoin,self.m_root,1,tData, false, nil, true)
end

function ScenePvpRank:refreshMatchInfo()
    ProtocolProcessorScenePvpRank:send_TRIO_GetMatchInfo()
end
------------------------------------------------------语言适配Begin----------------------------------


--@brief    适配iphoneX 
function ScenePvpRank:_adaptIphoneX()
    -- body
    if IsIphoneX() then
        local conRankInfo = GetElement(self.m_root,"conRankInfo_ScenePvpRank",WZUIContainer)
        conRankInfo:setRelativePosition(GlobalMethod:ccp(0.084,0.5))

        local btnStor = GetElement(self.m_root,"btnStore_ScenePvpRank",WZUIButton)
        btnStor:setRelativePosition(GlobalMethod:ccp(0.935,0.845))
        local btnStor = GetElement(self.m_root,"btnPro_ScenePvpRank",WZUIButton)
        btnStor:setRelativePosition(GlobalMethod:ccp(0.935,0.715))
        local btnStor = GetElement(self.m_root,"btnArenaAddInfo_ScenePvpRank",WZUIButton)
        btnStor:setRelativePosition(GlobalMethod:ccp(0.935,0.585))
        local btnStor = GetElement(self.m_root,"btnReward_ScenePvpRank",WZUIButton)
        btnStor:setRelativePosition(GlobalMethod:ccp(0.935,0.455))

    end
end

function ScenePvpRank:_adaptLanguage_en(  )
    local txtPvpIntegral1 = GetElement(self.m_root, "txtPvpIntegral1_ScenePvpRank", WZUILabelTTF)
    txtPvpIntegral1:setScale(0.8)
    txtPvpIntegral1:setDimensions(GlobalMethod:CCSize(140))

    -- GetElement(self.m_root,"txtDes1_ScenePvpRank",WZUILabelTTF):setScale(0.8)
    -- GetElement(self.m_root,"txtDes2_ScenePvpRank",WZUILabelTTF):setScale(0.8)
    -- GetElement(self.m_root,"txtDes3_ScenePvpRank",WZUILabelTTF):setScale(0.8)
    -- GetElement(self.m_root,"txtDes4_ScenePvpRank",WZUILabelTTF):setScale(0.8)
    -- local txt1 = GetElement(self.m_root,"txtData1_ScenePvpRank",WZUILabelTTF)
    -- txt1:setScale(0.75)
    -- txt1:setRelativePosition(GlobalMethod:ccp(0.0578947,0.850161))
    -- local txt2 = GetElement(self.m_root,"txtData2_ScenePvpRank",WZUILabelTTF)
    -- txt2:setScale(0.75)
    -- txt2:setRelativePosition(GlobalMethod:ccp(0,0.617625))
    -- local txt3 = GetElement(self.m_root,"txtData3_ScenePvpRank",WZUILabelTTF)
    -- txt3:setScale(0.75)
    -- txt3:setRelativePosition(GlobalMethod:ccp(0,0.382375))
    -- local txt4 = GetElement(self.m_root,"txtData4_ScenePvpRank",WZUILabelTTF)
    -- txt4:setScale(0.75)
    -- txt4:setRelativePosition(GlobalMethod:ccp(0.0631579,0.163525))

    -- local txtDaily = GetElement(self.m_root,"txtDaily_ScenePvpRank",WZUILabelTTF)
    -- txtDaily:setDimensions(GlobalMethod:CCSize(100))
    -- txtDaily:setRelativePosition(GlobalMethod:ccp(0.5,0))
    -- local txtSeasonal = GetElement(self.m_root,"txtSeasonal_ScenePvpRank",WZUILabelTTF)
    -- txtSeasonal:setDimensions(GlobalMethod:CCSize(100))
    -- txtSeasonal:setRelativePosition(GlobalMethod:ccp(0.5,0))

    -- local txtTip = GetElement(self.m_root,"txtTimeDownTip_ScenePvpRank",WZUILabelTTF)
    -- txtTip:setScale(0.8)
    -- txtTip:setDimensions(GlobalMethod:CCSize(400,0))
    local txtTip = GetElement(self.m_root,"txtTimeDownTip_ScenePvpRank",WZUILabelTTF)
    txtTip:setScale(0.8)    
    txtTip:setDimensions(GlobalMethod:CCSize(400,0))
    
    GetElement(self.m_root, "txtDate_ScenePvpRank", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.23,0.545))
    GetElement(self.m_root, "txtStartTime_ScenePvpRank", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.23,0.443))

    local txtPvpIntegral = GetElement(self.m_root, "txtPvpIntegral2_ScenePvpRank", WZUILabelTTF)
    txtPvpIntegral:setScale(0.9)
    --txtPvpIntegral:setDimensions(GlobalMethod:CCSize(140))

    GetElement(self.m_root, "txtRanking_ScenePvpRank", WZUILabelTTF):setScale(0.65)
    GetElement(self.m_root, "txtReward_ScenePvpRank", WZUILabelTTF):setScale(0.65)

    local txtProtectedText = GetElement(self.m_root, "txtProtectedText_ScenePvpRank", WZUILabelTTF)
    txtProtectedText:setRelativePosition(GlobalMethod:ccp(0.5,-1.55))
    txtProtectedText:setDimensions(GlobalMethod:CCSize(340))
end


function ScenePvpRank:_adaptLanguage_pt(  )
    local txtTip = GetElement(self.m_root,"txtTimeDownTip_ScenePvpRank",WZUILabelTTF)
    txtTip:setScale(0.8)    
    txtTip:setDimensions(GlobalMethod:CCSize(400,0))
    
    GetElement(self.m_root, "txtDate_ScenePvpRank", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.23,0.545))
    GetElement(self.m_root, "txtStartTime_ScenePvpRank", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.23,0.443))

    local txtPvpIntegral = GetElement(self.m_root, "txtPvpIntegral2_ScenePvpRank", WZUILabelTTF)
    txtPvpIntegral:setScale(0.7)
    txtPvpIntegral:setDimensions(GlobalMethod:CCSize(170))

    GetElement(self.m_root, "txtRanking_ScenePvpRank", WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root, "txtReward_ScenePvpRank", WZUILabelTTF):setScale(0.75)

    local txtProtectedText = GetElement(self.m_root, "txtProtectedText_ScenePvpRank", WZUILabelTTF)
    txtProtectedText:setRelativePosition(GlobalMethod:ccp(0.5,-1.55))
    txtProtectedText:setDimensions(GlobalMethod:CCSize(340))
end

function ScenePvpRank:_adaptLanguage_vn(  )
    local txtTip = GetElement(self.m_root,"txtTimeDownTip_ScenePvpRank",WZUILabelTTF)
    txtTip:setScale(0.8)
    txtTip:setDimensions(GlobalMethod:CCSize(400,0))
end

function ScenePvpRank:_adaptLanguage_tr(  )
    -- GetElement(self.m_root,"txtDes1_ScenePvpRank",WZUILabelTTF):setScale(0.7)
    -- GetElement(self.m_root,"txtDes2_ScenePvpRank",WZUILabelTTF):setScale(0.7)
    -- GetElement(self.m_root,"txtDes3_ScenePvpRank",WZUILabelTTF):setScale(0.7)
    -- GetElement(self.m_root,"txtDes4_ScenePvpRank",WZUILabelTTF):setScale(0.7)
    -- local txtData1 = GetElement(self.m_root,"txtData1_ScenePvpRank",WZUILabelTTF)
    -- txtData1:setScale(0.7)
    -- txtData1:setRelativePosition(GlobalMethod:ccp(-0.126316,0.850161))
    -- local txtData2 = GetElement(self.m_root,"txtData2_ScenePvpRank",WZUILabelTTF)
    -- txtData2:setScale(0.7)
    -- txtData2:setRelativePosition(GlobalMethod:ccp(0.263157,0.617625))
    -- local txtData3 = GetElement(self.m_root,"txtData3_ScenePvpRank",WZUILabelTTF)
    -- txtData3:setScale(0.7)
    -- txtData3:setRelativePosition(GlobalMethod:ccp(-0.126316,0.382375))
    -- local txtData4 = GetElement(self.m_root,"txtData4_ScenePvpRank",WZUILabelTTF)
    -- txtData4:setScale(0.7)
    -- txtData4:setRelativePosition(GlobalMethod:ccp(0.0157893,0.163525))

    local txtTip = GetElement(self.m_root,"txtTimeDownTip_ScenePvpRank",WZUILabelTTF)
    txtTip:setScale(0.8)
    txtTip:setDimensions(GlobalMethod:CCSize(400,0))

    local txtProtectedText = GetElement(self.m_root, "txtProtectedText_ScenePvpRank", WZUILabelTTF)
    txtProtectedText:setRelativePosition(GlobalMethod:ccp(0.5,-1.55))
    txtProtectedText:setDimensions(GlobalMethod:CCSize(340))

    GetElement(self.m_root, "txtRanking_ScenePvpRank", WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root, "txtReward_ScenePvpRank", WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root, "txtShop_ScenePvpRank", WZUILabelTTF):setScale(0.7)
end
function ScenePvpRank:_adaptLanguage_th(  )
    local txtTip = GetElement(self.m_root,"txtTimeDownTip_ScenePvpRank",WZUILabelTTF)
    txtTip:setScale(0.8)
    txtTip:setDimensions(GlobalMethod:CCSize(400,0))

end

function ScenePvpRank:_adaptLanguage_es(  )
    local txtPvpIntegral1 = GetElement(self.m_root, "txtPvpIntegral1_ScenePvpRank", WZUILabelTTF)
    txtPvpIntegral1:setScale(0.8)
    txtPvpIntegral1:setDimensions(GlobalMethod:CCSize(140))
    local txtPvpIntegral2 = GetElement(self.m_root, "txtPvpIntegral2_ScenePvpRank", WZUILabelTTF)
    txtPvpIntegral2:setScale(0.7)
    txtPvpIntegral2:setDimensions(GlobalMethod:CCSize(140))

    GetElement(self.m_root, "txtRanking_ScenePvpRank", WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root, "txtReward_ScenePvpRank", WZUILabelTTF):setScale(0.7)

    local txtTip = GetElement(self.m_root,"txtTimeDownTip_ScenePvpRank",WZUILabelTTF)
    txtTip:setScale(0.75)
    txtTip:setDimensions(GlobalMethod:CCSize(420,0))

    local txtProtectedText = GetElement(self.m_root, "txtProtectedText_ScenePvpRank", WZUILabelTTF)
    txtProtectedText:setRelativePosition(GlobalMethod:ccp(0.5,-1.55))
    txtProtectedText:setDimensions(GlobalMethod:CCSize(340))
end

function ScenePvpRank:_adaptLanguage_ug(  )
    GetElement(self.m_root, "txtDate_ScenePvpRank", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.545))
    GetElement(self.m_root, "txtStartTime_ScenePvpRank", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.443))

    GetElement(self.m_root, "ftxtPvpIntegral_ScenePvpRank", WZUIFreeTextBox):setMaxWidth(300)

    local txtPvpIntegral1 = GetElement(self.m_root, "txtPvpIntegral1_ScenePvpRank", WZUILabelTTF)
    txtPvpIntegral1:setScale(0.7)
    txtPvpIntegral1:setDimensions(GlobalMethod:CCSize(170))
    local txtPvpIntegral2 = GetElement(self.m_root, "txtPvpIntegral2_ScenePvpRank", WZUILabelTTF)
    txtPvpIntegral2:setScale(0.7)
    txtPvpIntegral2:setDimensions(GlobalMethod:CCSize(170))


    local txtRanking = GetElement(self.m_root, "txtRanking_ScenePvpRank", WZUILabelTTF)
    txtRanking:setScale(0.7)
    txtRanking:setDimensions(GlobalMethod:CCSize(110))
    local txtReward = GetElement(self.m_root, "txtReward_ScenePvpRank", WZUILabelTTF)
    txtReward:setScale(0.7)
    txtReward:setDimensions(GlobalMethod:CCSize(110))
    local txtShop = GetElement(self.m_root, "txtShop_ScenePvpRank", WZUILabelTTF)
    txtShop:setScale(0.7)
    txtShop:setDimensions(GlobalMethod:CCSize(110))

    local txtTip = GetElement(self.m_root,"txtTimeDownTip_ScenePvpRank",WZUILabelTTF)
    txtTip:setScale(0.6)    
    txtTip:setDimensions(GlobalMethod:CCSize(530,0))
end
------------------------------------------------------语言适配End-------------------------------------
