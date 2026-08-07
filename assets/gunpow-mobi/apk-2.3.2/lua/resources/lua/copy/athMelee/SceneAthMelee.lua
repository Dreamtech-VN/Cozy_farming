--SceneAthMelee.lua
--@brief	SceneAthMelee的UI模块
--@date		2016-10-27
--@author	binshao
--@note		大乱斗


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneAthMelee:onEnter(element)
	self.m_root = element
    ChangeChatChannel(Chat_Channel_Ath_Melee)
    self:_addTop()

    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    WndChat:addChatWindowToCurScene()

    CacheCenter:registerUpdateDecorationObserver(self)
    CacheCenter:registerUpatePlayerInfoObserver(self)

    local conInfo = GetElement(self.m_root,"conPlayerInfo_SceneAthMelee",WZUIContainer)
    conInfo:enableSchedule("playRoleAni", 0)

    --ProtocolProcessorSceneAthWelee:regAll()
    GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change",'state_hall')
    if self.m_nType == 2 then 
        ProtocolProcessorGlobal:send_ROOM_GetGreatEscapeStatus( )
    end
    WZLog("SceneAthMelee:onEnter")
end

--@brief onEnter函数执行完成回调
function SceneAthMelee:onEnterTransitionDidFinish(element)

    -- 如果有竞技等级有变化，播放升级动画
    WndAthUpgrade:Show()
    self:_updatePlayerInfo()
    --延时显示成就特效
    ShowDelayAchie()
    if RANK_OVER_REWARD_COUNT and RANK_OVER_REWARD_ID and RANK_OVER_REWARD_ID ~= "" then
        local id, num = SplitItemString(RANK_OVER_REWARD_ID)
        WndRewardShow:showById(id, num, nil, nil, nil, nil, nil, 2)
        RANK_OVER_REWARD_ID = nil
        RANK_OVER_REWARD_COUNT = nil
    end
    AdaptLanguage(self)
end

function SceneAthMelee:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    local img = "ui/common/common_icon_dld.png"
    if self.m_nType == 2 then
        img = "ui/common/common_icon_jdmx.png"
    elseif self.m_nType == 3 then
        img = "ui/common/common_icon_gsms.png"
    end
    tcell:setTopData(img,SceneAthMelee,SceneAthMelee.OnReturn,true,true,true,"SceneAthMelee")
    tcell:setTopType()
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneAthMelee:onExit(element)
    WZLog("SceneAthMelee:onExit")
    CacheCenter:unregisterUpateDecorationObserver(self)
    CacheCenter:unregisterUpatePlayerInfoObserver(self)
    --ProtocolProcessorSceneAthWelee:unregAll()
    local conInfo = GetElement(self.m_root,"conPlayerInfo_SceneAthMelee",WZUIContainer)
    conInfo:disableSchedule()
	self:_unInit()
end

-- 加载loading
function SceneAthMelee:createLoadingBox()
    if not self.loadingId then  self.loadingId = MsgBoxManager:showLoadingBox(20) end
end

--关闭loading
function SceneAthMelee:closeLoadingBox()
    if self.loadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
end

-- 返回
function SceneAthMelee:OnReturn()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- if self.m_nType == 2 then
    --     replaceScene(SceneCity:createElement())
    --     return
    -- end
	ScenePvpAmuse:showScene()
end

-- 每日奖励
function SceneAthMelee:onDayReward()
    WZLog("----------------onDayReward--------------",Serialize(self.reward),Serialize(self.fightData))
    WndAthMeleeReward:showWndUI(self.reward,self.fightData)
end

-- 查看宠物信息
function SceneAthMelee:OnPet()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("-------------------click pet--------------------")
    local petInfo = CacheCenter:getPlayerInfo().petInfo
    if not petInfo then return end
    local conPet = GetElement(self.m_root,"conPet_SceneAthMelee",WZUIContainer)
    local con =  GetElement(self.m_root,"conMain_SceneAthMelee",WZUIContainer)
    WndTips:show(conPet,con,13,petInfo,GlobalMethod:ccp(300,0))
end

-- 获取玩家的武器
function SceneAthMelee:onWeapon()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local conEquip= GetElement(self.m_root,"conWeapon_SceneAthMelee",WZUIContainer)
    local weaponInfo = {}
    local equip = CacheCenter:getEquipmentList()
    for k,v in pairs(equip) do
        if v.maintype == 4 and (v.subtype == 1 or v.subtype == 0) then
            weaponInfo = v
            break
        end
    end
    local con = GetElement(self.m_root,"conTips_SceneAthMelee",WZUIContainer)
    WndItemInfo:showInfo(conEquip,con,1,weaponInfo,false,nil,false)
end

-- 动画播完后调用
function SceneAthMelee:playRoleAni()
    if self.conPlayer and self.conPlayer:isCurrentAnimationDone() then
        self.conPlayer:play("wait0", true)
    end
end

-- 点击人物动画
function SceneAthMelee:onRole()
    if self.conPlayer then self.conPlayer:play(g_tRoleAnitionName[2], false) end
end

function SceneAthMelee:onClickStore(element)
    -- body
    WZLog("SceneAthMelee:onClickStore")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndStore:showStoreByType(9)
end

-- 开始战斗
function SceneAthMelee:OnFight()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("----------OnFight---------------")
    local time,status = GlobalGame:getEscapeInfo()
    if self.m_nType == 2 then
        if status == 1 and time > 0 then
            local openLevel = tonumber(CacheCenter:getGameParam().greatEscapeLevel)
            local playerLevel = CacheCenter:getPlayerInfo().level
            if playerLevel >= openLevel then
                ProtocolProcessorSceneHall:send_ROOM_QuickGame(11,3,0)
            else
                local tip = string.format(LocalStrings.CHANGE_OPEN_TIP,openLevel)
                MsgBoxManager:showTipBox(tip)
                return
            end
        else
            MsgBoxManager:showTipBox(LocalStrings.JEDI_ADVENTURE_OVER)
            return
        end
    elseif self.m_nType == 3 then
        ProtocolProcessorSceneHall:send_ROOM_QuickGame(GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL, GlobalGame.g_tBattleMode.BATTLE_MODE_GS, 0)
    else
        ProtocolProcessorSceneHall:send_ROOM_QuickGame(GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL, GlobalGame.g_tBattleMode.BATTLE_MODE_LD, 0)
    end
    
    self:_initMarkTime()
end


-- 查看人物属性
function SceneAthMelee:onCheckInfo(element)
    WZLog("SceneAthMelee:onCheckInfo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local con = GetElement(self.m_root,"conTips_ScenePvpRank",WZUIContainer)
    local tData = {attrType = 3}
    if self.m_nType == 1 then 
        tData.attrType = 8
    elseif self.m_nType == 2 then 
        tData.attrType = 3
    elseif self.m_nType == 3 then 
        tData.attrType = 4
    end
    WndTips:show(element,self.m_root,27,tData,GlobalMethod:ccp(205,-135),true)
    TeachGroup1:endTeachStep({48,3})
end

-- 取消匹配
function SceneAthMelee:onCancelMatch()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("----------onCancelMatch---------------")
	ProtocolProcessorSceneRoom:send_ROOM_EndPair(0)
    local con = GetElement(self.m_root,"conMark_SceneAthMelee",WZUIContainer)
    con:setVisible(false)
    local conMain = GetElement(self.m_root,"conMain_SceneAthMelee",WZUIContainer)
    conMain:disableSchedule()
end

--@brief 	查看段位按钮
function SceneAthMelee:onCheckAthLv( element )
    WZLog("--------onAthLv----------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tipCon = GetElement(self.m_root,"conTips_SceneAthMelee",WZUIContainer)
    local tData = json.decode(CacheCenter:getPlayerInfo().ylJsonInfo)
    tData.winType = 2

    WndTips:show(element,tipCon,4, tData, GlobalMethod:ccp(300,-160))
end

-- 更新玩家个人信息
function SceneAthMelee:_updatePlayerInfo()
    local tInfo = CacheCenter:getPlayerInfo()
    local conMain = GetElement(self.m_root,"conMain_SceneAthMelee",WZUIContainer)
    local conStore = GetElement(conMain,"conStore_SceneAthMelee",WZUIContainer)
    conStore:setVisible(false)
    local btnPro = GetElement(conMain,"btnPro_SceneAthMelee",WZUIButton)
    btnPro:setVisible(false)
    if self.m_nType == 2 then
        conStore:setVisible(true)
    end
    btnPro:setVisible(true)

    local conMove = GetElement(self.m_root,"conMove_SceneAthMelee",WZUIMoveContaienr)
    conMove:setTouchEnable(true)
    local txtPlayTip = GetElement(conMain,"txtPlayTip_SceneAthMelee",WZUILabelTTF)
    if self.m_nType == 2 then
        txtPlayTip:setText(LocalStrings.ADVENTURE_DESC1)
    elseif self.m_nType == 3 then
        txtPlayTip:setText(LocalStrings.MELEE_DESC13)
    else
        conMove:setTouchEnable(false)
        txtPlayTip:setText(LocalStrings.MELEE_DESC1)
    end

    -- 等级图标以及经验
    local tEntertainmentData = json.decode(tInfo.ylJsonInfo)
    local hallInfo = GDatatab_entertainment_level["id_"..tEntertainmentData.level]
    local txtExp = GetElement(self.m_root,"txtExp_SceneAthMelee", WZUILabelTTF)
    local curExp, AllExp = tEntertainmentData.exp, hallInfo.upgrade_integral
    txtExp:setText(curExp.."/"..AllExp)

    local proExp =  GetElement(self.m_root,"processLv_SceneAthMelee",WZUIProgress)
    proExp:setPercentage(curExp/AllExp*100)

    local hallLv = GetElement(self.m_root,"txtAthLv_SceneAthMelee",WZUILabelAtlasFont)
    local LvNum = tEntertainmentData.level 
    hallLv:setText(LvNum)

    local lvDi =  GetElement(self.m_root,"imgAthLevel_SceneAthMelee", WZUIImage)
    lvDi:setFile("ui/common/"..hallInfo.iocn..".png")

    --设置玩家称号
    local txtTitle = GetElement(self.m_root, "txtPlayerTitle_SceneAthMelee", WZUILabelTTF)
    local conTitle = GetElement(self.m_root, "conTitle_SceneAthMelee", WZUIContainer)
    local sTitleContent = tInfo.title
    if tInfo.title == nil or tInfo.title == "" then
        sTitleContent = LocalStrings.SHOP_NOCHENGHAO 
    end
    local tempPoint = GlobalMethod:ccp(0.5,1.95)
    CreateDesiSpine(conTitle, txtTitle, sTitleContent, tempPoint, true)

    -- 名字和等级
    local txtNameAndLv = GetElement(self.m_root, "txtPlayerLevel_SceneAthMelee", WZUIFreeTextBox)
    txtNameAndLv:setShowText(string.format(LocalStrings.SHOP_NAME_AND_LEVEL1,tInfo.level,tInfo.name))

    -- 战斗力
    local ftbFight = GetElement(self.m_root,"ftbFight_SceneAthMelee",WZUIFreeTextBox)
    ftbFight:setShowText(string.format(LocalStrings.FIGHT_POWER,tInfo.fighting))

    -- 人物形象
    self:updatePlayerDress()

    -- 宠物
    local petInfo = CacheCenter:getPlayerInfo().petInfo
    local conPet = GetElement(self.m_root,"conPet_SceneAthMelee",WZUIContainer)
    if petInfo then
        local aniPet,par = CreatePetAni(conPet,petInfo.itemId,petInfo.animation,petInfo.advancedLevel, petInfo.petSkinItemId)
        aniPet:getAnimNode():setScale(0.8)
        if par then par:setScale(0.8) end
    else
        conPet:removeAllChildrenWithCleanup(true)
    end

    -- 武器
    local imgWeapon = GetElement(self.m_root,"imgWeapon_SceneAthMelee", WZUIImage)
    local spineWeapon = GetElement(self.m_root,"spineWeapon_SceneAthMelee", WZUISpine)
    setPlayerCurWeapon(imgWeapon,spineWeapon)

    local leftTime , status =  GlobalGame:getEscapeInfo()
    if leftTime > 0 then
         self.timeDown = leftTime
         self:_updateLeftTime()
    end
end

-- 修改时间显示
function SceneAthMelee:_initTime(time)
    local h = 60*60
    local m = 60
    local hour = math.floor(time/h)
    local min = math.floor((time-hour*h)/m)
    local sec = time - hour*h - min*m
    if hour < 10 then hour = "0"..hour end
    if min < 10 then min = "0"..min end
    if sec < 10 then sec = "0"..sec end
    return hour..":"..min..":"..sec
end

-- 更新玩家信息
function SceneAthMelee:updatePlayerDress()
	WZLog("SceneAthMelee:updatePlayerDress")
    local con = GetElement(self.m_root,"conPlayer_SceneAthMelee",WZUIContainer)
    if con:getChildByTag(88) then
        con:getChildByTag(88):removeFromParentAndCleanup(true)
    end
    local conAni = CreateSelfAni()
    self.conPlayer = conAni
    local node = conAni:getAnimNode()
    con:addChild(node,0,88)
end

-- 更新活动剩余时间
function SceneAthMelee:_updateLeftTime()
    if self.timeDown == 0 then
        self.m_root:disableSchedule()
        return
    end
    self.timeDown = self.timeDown - 1
    WZLog("-------------------time------------------",self.timeDown)
    local time = self:_initTime(self.timeDown)
    local txtFight = GetElement(self.m_root,"txtFightTime_SceneAthMelee", WZUILabelTTF)
    txtFight:setText(time)
    
end

-- 初始化匹配时间
function SceneAthMelee:_initMarkTime()
    self.markTime = 1

    local con = GetElement(self.m_root,"conMark_SceneAthMelee",WZUIContainer)
    con:setVisible(true)

    local lafTime = GetElement(self.m_root,"lafTime_SceneAthMelee",WZUILabelAtlasFont)
    lafTime:setText(self.markTime)

    self:updateDescTips()

    local conMain = GetElement(self.m_root,"conMain_SceneAthMelee",WZUIContainer)
    conMain:enableSchedule("_updateMarkTime",1)
end

-- 更新匹配时间
function SceneAthMelee:_updateMarkTime()
    self.markTime = self.markTime + 1
    local lafTime = GetElement(self.m_root,"lafTime_SceneAthMelee",WZUILabelAtlasFont)
    lafTime:setText(self.markTime)

    if self.markTime%5 == 0 then
        self:updateDescTips()
    end

    if self.markTime == 60 then
        local con = GetElement(self.m_root,"conMark_SceneAthMelee",WZUIContainer)
        con:setVisible(false)
        local conMain = GetElement(self.m_root,"conMain_SceneAthMelee",WZUIContainer)
        conMain:disableSchedule()
        MsgBoxManager:showTipBox(LocalStrings.MATCHFAIL, nil, nil, nil, nil)
        local imgBtn = GetElement(self.m_root,"imgFightBtn_SceneAthMelee", WZUIImage)
        imgBtn:setFile("ui/common/common_icon_tiaozhan.png")
        self.fightBtnIndex = 0
    end
end

-- 初始化每日奖励
function SceneAthMelee:updateFightData()
    local curCnt = {self.fightData.joinCnt,self.fightData.winCnt,self.fightData.killCnt }
    for i = 1, 3 do
        local ftb = GetElement(self.m_root,"ftbCnt"..i.."_SceneAthMelee", WZUIFreeTextBox)
        local cnt = self.descCnt[i]
        if cnt == 0 then
            ftb:setShowText(string.format(LocalStrings.MELEE_DESC7,curCnt[i]))
        elseif cnt <= curCnt[i] then
            ftb:setShowText(string.format(LocalStrings.MELEE_DESC6,curCnt[i],curCnt[i],cnt))
        else
            ftb:setShowText(string.format(LocalStrings.MELEE_DESC5,curCnt[i],curCnt[i],cnt))
        end
    end

    -- 更新红点
    self:updateRedPoint()
end

-- 更新红点信息
function SceneAthMelee:updateRedPoint()
    -- 每日目标红点
    local flag = false
    for k,v in pairs(self.reward) do
        if v.status == 0 then
            flag = true
            break
        end
    end

    local imgRed = GetElement(self.m_root,"imgRed1_SceneAthMelee", WZUIImage)
    imgRed:setVisible(flag)
    WZLog("--------------red info-----------",flag)
end

-- 监听时装改变
function SceneAthMelee:updateDecorationData()
    local sex = CacheCenter:getPlayerInfo().sex
    local tEquip = CacheCenter:getEquipmentList()
    if self.conPlayer then
        UpdatePlayerFigure(self.conPlayer:getAnimNode(),tEquip,sex)
    end
end

-- 监听玩家信息改变
function SceneAthMelee:updatePlayerInfoData()
    self:_updatePlayerInfo()
end

-- 更新小提示
function SceneAthMelee:updateDescTips()
    local ttfDesc = GetElement(self.m_root,"txtTimeDownTip_SceneAthMelee",WZUILabelTTF)
    local nIndex = math.random(1, #LocalStrings.HALL_DESC2)
    if ttfDesc:getText() == LocalStrings.HALL_DESC2[nIndex] then
        nIndex = nIndex+1
        if nIndex > #LocalStrings.HALL_DESC2 then nIndex = 1 end
    end
    ttfDesc:setText(LocalStrings.TIPS..":"..LocalStrings.HALL_DESC2[nIndex])
end

---------------------------------------语言适配Begin----------------------------------
function SceneAthMelee:_adaptLanguage_en(  )
    local txtTimeT = GetElement(self.m_root,"txtTimeDownTip_SceneAthMelee",WZUILabelTTF)
    txtTimeT:setScale(0.8)
    txtTimeT:setDimensions(GlobalMethod:CCSize(400,0))

    local txtPlayTip = GetElement(self.m_root,"txtPlayTip_SceneAthMelee",WZUILabelTTF)
    txtPlayTip:setScale(0.8)
    txtPlayTip:setDimensions(GlobalMethod:CCSize(460))
end

function SceneAthMelee:_adaptLanguage_th(  )
    local txtTimeT = GetElement(self.m_root,"txtTimeDownTip_SceneAthMelee",WZUILabelTTF)
    txtTimeT:setScale(0.8)
    txtTimeT:setDimensions(GlobalMethod:CCSize(400,0))
end

function SceneAthMelee:_adaptLanguage_pt(  )
    local txtPlayTip = GetElement(self.m_root,"txtPlayTip_SceneAthMelee",WZUILabelTTF)
    txtPlayTip:setScale(0.8)
    txtPlayTip:setDimensions(GlobalMethod:CCSize(460))
    
    local txtTimeT = GetElement(self.m_root,"txtTimeDownTip_SceneAthMelee",WZUILabelTTF)
    txtTimeT:setScale(0.8)
    txtTimeT:setDimensions(GlobalMethod:CCSize(400,0))
end

function SceneAthMelee:_adaptLanguage_vn(  )
    local txtTimeT = GetElement(self.m_root,"txtTimeDownTip_SceneAthMelee",WZUILabelTTF)
    txtTimeT:setScale(0.8)
    txtTimeT:setDimensions(GlobalMethod:CCSize(400,0))

    GetElement(self.m_root,"txtPlayTip_SceneAthMelee",WZUILabelTTF):setScale(0.8)
end

function SceneAthMelee:_adaptLanguage_tr(  )
    local txtTimeT = GetElement(self.m_root,"txtTimeDownTip_SceneAthMelee",WZUILabelTTF)
    txtTimeT:setScale(0.8)
    txtTimeT:setDimensions(GlobalMethod:CCSize(400,0))

    local txtPlayTip = GetElement(self.m_root,"txtPlayTip_SceneAthMelee",WZUILabelTTF)
    txtPlayTip:setScale(0.7)
    txtPlayTip:setDimensions(GlobalMethod:CCSize(460))
end

function SceneAthMelee:_adaptLanguage_es(  )
    local txtPlayTip = GetElement(self.m_root,"txtPlayTip_SceneAthMelee",WZUILabelTTF)
    txtPlayTip:setScale(0.7)
    txtPlayTip:setDimensions(GlobalMethod:CCSize(530))
end
---------------------------------------语言适配End-------------------------------------