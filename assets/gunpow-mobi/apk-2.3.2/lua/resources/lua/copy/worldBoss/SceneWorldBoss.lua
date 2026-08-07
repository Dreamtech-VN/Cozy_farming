--SceneWorldBoss.lua
--@brief	SceneWorldBoss的UI模块
--@date		2015-9-16
--@author	binshao
--@note		世界BOSS模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneWorldBoss:onEnter(element)
	SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)
	ChangeChatChannel(Chat_Channel_World_Boss)
	self.m_root = element
    AdaptLanguage(self)
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
	--注册协议组所有协议
	ProtocolProcessorSceneWorldBoss:regAll()
    CacheCenter:registerUpatePlayerInfoObserver(self)
    CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
    -- 初始化奖励信息
    self:initRewardRankInfo()
    self:_initInspireState()
    self:_addTop()

    WndChat:addChatWindowToCurScene()
end

--@brief	打开加载动画
function SceneWorldBoss:onEnterTransitionDidFinish(element)
    self:createLoading()
    if self.selBossId ~= 1  and self.selBossId ~= 2 then self.selBossId = 1  end
    WZLog("---------------555------------------",self.selBossId)
    WZLog("---------------555------------------",GDatatab_world_boss_map["id_"..self.selBossId].id)
    ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_GetRoomState(GDatatab_world_boss_map["id_"..self.selBossId].id )

	if WndGangsterInn.m_bShouldClose == true then
		WndGangsterInn.m_bShouldClose = false
		MsgBoxManager:showTipBox(LocalStrings.INN12)
	end
    self:adaptIphoneX()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneWorldBoss:onExit(element)
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","WndShop")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","WndShop")
    
    CacheCenter:unregisterUpatePlayerInfoObserver(self)
    CacheCenter:unregisterUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorSceneWorldBoss:unregAll()
	self:_unInit()
end

--@brief   外部接口
function SceneWorldBoss:showInterface(bossId,openTime)
    local scene = SceneWorldBoss:createElement()
    replaceScene( scene )
    self.selBossId = bossId
    g_selectWorldBossId = bossId
end

-- 关闭按钮回调函数
function SceneWorldBoss:onReturn()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    local sceneIsland = SceneIsland:createElement()
    replaceScene(sceneIsland)
    if self.m_tReturnCallBack then
        self.m_tReturnCallBack[2](self.m_tReturnCallBack[1])
    end
end

--@brief    点击规则按钮回调
function SceneWorldBoss:onClickRule(element)
    -- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.WORLD_BOSS_DESC)
end

-- 创建加载框
function SceneWorldBoss:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox(15)
end

-- 关闭加载框
function SceneWorldBoss:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end


-- 游戏顶部
function SceneWorldBoss:_addTop()
    local cell,tcell = CellTopHandle:createElement()

    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_sjboss.png",SceneWorldBoss,SceneWorldBoss.onReturn,false,true,true,"SceneWorldBoss")
    tcell:setImageBgVisible(true)
    -- tcell:setWifiSignalVisible(false)
    -- tcell:setTopBGVisible(false)
    -- tcell.goldCellInfo.cell:setVisible(false)
    -- tcell:setTopTitleVisible(false)
    -- tcell:resetTitleSize()
end
-----------------------------------------------回调start----------------------------------------------------------------

function SceneWorldBoss:onCloseTips(element,pt)
    local point = self.m_root:convertToNodeSpace(pt)
    local bPoint = WndItemInfo:checkPoint(pt)
    if not bPoint then  WndItemInfo:onCloseClick() end
end

--@brief  钻石鼓舞回调
function SceneWorldBoss:onDiamondInspire( element )
    WZLog("------diamondInspire----------------", self.bossRoomInfo.bossLevel)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- 鼓舞满
    if self.bossRoomInfo.inspire >= 10000 then
        MsgBoxManager:showTipBox(LocalStrings.WOLRD_BOSS_INSPIRE_FULL)
        return
    end

    -- boss存活 boss死亡2 boss逃跑3 不能鼓舞
    if self.bossRoomInfo.bossState == 1 and self.bossRoomInfo.openTime > 0 then
        MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_INSPIRE_NO)
        return
    elseif self.bossRoomInfo.bossState == 2 then
        MsgBoxManager:showTipBox(LocalStrings.WOLRD_BOSS_DEAD_NOT_INSPIRE)
        return
    elseif self.bossRoomInfo.bossState == 3 then
        MsgBoxManager:showTipBox(LocalStrings.WOLRD_BOSS_LEFT_NOT_INSPIRE)
        return
    end

    if self.bossRoomInfo.bossLevel == 0 then
        MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_INSPIRE_NO)
    else
        local data =  GDatatab_world_boss_encouraging["id_1"]
        if JudgeMoneyIsEnough(data.type,data.cost,nil,nil,Chat_Channel_World_Boss, nil, nil, nil, nil, self, self.sureInspire) then
            self:sureInspire()
        end
    end
end

--@brief    确定鼓舞
function SceneWorldBoss:sureInspire()
    -- body
    self.inspireData.bFlag = true
    local data =  GDatatab_world_boss_encouraging["id_1"]
    ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_Inspire(GDatatab_world_boss_map["id_"..self.selBossId].id, data.type)
end

--@brief  金币鼓舞回调
function SceneWorldBoss:onGoldInspire( element )
    WZLog("------goldInspire----------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.bossRoomInfo.inspire >= 10000 then
        MsgBoxManager:showTipBox(LocalStrings.WOLRD_BOSS_INSPIRE_FULL)
        return
    end

    -- boss存活 boss死亡2 boss逃跑3 不能鼓舞
    if self.bossRoomInfo.bossState == 1 and self.bossRoomInfo.openTime > 0 then
        MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_INSPIRE_NO)
        return
    elseif self.bossRoomInfo.bossState == 2 then
        MsgBoxManager:showTipBox(LocalStrings.WOLRD_BOSS_DEAD_NOT_INSPIRE)
        return
    elseif self.bossRoomInfo.bossState == 3 then
        MsgBoxManager:showTipBox(LocalStrings.WOLRD_BOSS_LEFT_NOT_INSPIRE)
        return
    end

    if self.bossRoomInfo.goldCDTime > 0 then
        MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_GOLD_LAST)
        return
    end

    if self.bossRoomInfo.bossLevel == 0 then
        MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_INSPIRE_NO)
    else
        local data =  GDatatab_world_boss_encouraging["id_2"]
        if JudgeMoneyIsEnough(data.type,data.cost,nil,nil,Chat_Channel_World_Boss) then
            self.inspireData.bFlag = true
            ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_Inspire(GDatatab_world_boss_map["id_"..self.selBossId].id, 2 )
        end
    end
end

-- 挑战世界boss
function SceneWorldBoss:onFightBoss( element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self.bossRoomInfo then return end

    if self.m_root == nil then return end
    -- 时间未到，为开启
    if self.bossRoomInfo.openTime > 0 then
        MsgBoxManager:showTipBox(LocalStrings.WORLD_BOSS_NO_OPEN)
        return
    end

    -- boss死亡2 boss逃跑3 不能挑战
    if self.bossRoomInfo.bossState ~= 1 then
        if self.bossRoomInfo.bossState == 2 then
            MsgBoxManager:showTipBox(LocalStrings.WORLD_BOSS_DEAD)
            return
        elseif self.bossRoomInfo.bossState == 3 then
            MsgBoxManager:showTipBox(LocalStrings.WORLD_BOSS_DEAD1)
            return
        end
    end

    local mapId = self.bossRoomInfo.mapId--GDatatab_world_boss_map["id_"..self.selBossId].id
    -- WZLog("SceneWorldBoss:onFightBoss", mapId)

    -- 清除战斗冷却CD
    if self.bossRoomInfo.cdTime > 0 then
        if CacheCenter:getGameParam().isUseTicket == "0" then
            if JudgeMoneyIsEnough(70,self.bossRoomInfo.accelerateCost,nil,nil,Chat_Channel_World_Boss, nil, nil, nil, nil, self, self.sureCleanCDTime) then
                self:sureCleanCDTime()
            end
        else
            if JudgeMoneyIsEnough(1,self.bossRoomInfo.accelerateCost,nil,nil,Chat_Channel_World_Boss, nil, nil, nil, nil, self, self.sureCleanCDTime) then
                self:sureCleanCDTime()
            end
        end
    else
        ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_MakePair(mapId)
        self:createLoading()
    end
end

--@brief    确定消除冷却时间
function SceneWorldBoss:sureCleanCDTime()
    -- body
    local mapId = GDatatab_world_boss_map["id_"..self.selBossId].id
    WZLog("SceneWorldBoss:onFightBoss", mapId)

    ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_Accelerate(mapId)
    ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_MakePair(mapId)
    self:createLoading()
end

--@brief    点击奖励预览按钮回调
function SceneWorldBoss:onClickRewardView(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("onClickRewardView", self.selBossId)
    local data = self.rankInfo[self.selBossId]

    WndRewardViewTip:showInterface(data, 1)
end

--@brief    点击浏览排名按钮回调
function SceneWorldBoss:onCheckRank(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndTowerRank:showWindow(4)
end

--@brief    点击第一玩家，查看玩家信息
function SceneWorldBoss:onCheckFirst(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    if self.bossRoomInfo.rankPlayerId[1] then 
        WndCheckOther:show(self.bossRoomInfo.rankPlayerId[1])
    end
end

--@brief  显示宠物tip
function SceneWorldBoss:onClickPet(element)
    WZLog("SceneWorldBoss:onClickPet")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tag = element:getTag()
    local petInfo = CacheCenter:getPlayerInfo().petInfo
    if petInfo and petInfo.itemId ~= nil then
        if tag <= 3 then
            WndTips:show(element,self.m_root,13,petInfo,GlobalMethod:ccp(340,-40),true)
        else
            WndTips:show(element,self.m_root,13,petInfo,GlobalMethod:ccp(340,20),true)
        end
    end
end

--@brief 查看玩家武器信息
function SceneWorldBoss:onClickWeapon(element)
    WZLog("SceneWorldBoss:onClickWeapon")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local pNode = WZUIContainer:luaTo(element:getParent())
    local tag = pNode:getTag()
    local weapId = CacheCenter:getWeapon().id
    if weapId <= 0 then
        return
    end
    local weaponInfo = {}
    weaponInfo.id = weapId
    weaponInfo.basicInfo = GDatatab_item["id_"..weapId]
    weaponInfo.extraInfo = CacheCenter:getWeapon().extraInfo
    weaponInfo.maintype = weaponInfo.basicInfo.main_type
    weaponInfo.subtype = weaponInfo.basicInfo.sub_type
    weaponInfo.isUse = true
    
    WndItemInfo:showInfo(element,self.m_root,1,weaponInfo,false,GlobalMethod:ccp(20,0),true)
end
-----------------------------------------------回调end------------------------------------------------------------------


---------------------------------------------私有方法模块start----------------------------------------------------------

-- 倒计时格式转换
function SceneWorldBoss:_timeChangeStyle(time,type)
    local h,m = 3600,60
    local hour = math.floor(time/h)
    local min = math.floor((time - hour*h)/m)
    local sec = math.floor(time-hour*h-min*60)
    if hour < 10 then hour = "0"..hour end
    if min < 10 then min = "0"..min end
    if sec < 10 then sec = "0"..sec end
    local str = {min..":"..sec,hour..":"..min..":"..sec}
    return str[type]
end

---------------------------------------------私有方法模块End------------------------------------------------------------

-- checkbox回调
function SceneWorldBoss:onCheckBox( element )
    WZLog("SceneWorldBoss:event_hurtRankFunc")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local  tag = element:getTag()
    self.checkIndex = tag
    self:_updateRankInfo(tag)
end

-- 更新排行榜显示模块
function SceneWorldBoss:_updateRankInfo(tag)
    local conT = {"conHurtRank_SceneWorldBoss","conRewardRank_SceneWorldBoss" }
    for i = 1, 2 do
        local conRank = GetElement(self.m_root,conT[i],WZUIContainer)
        conRank:setVisible(i == tag)
    end

    -- 显示对于的伤害排行榜
    if tag == 1 then
        self:_createHurtRank()
    else
        self:_createRewardRank()
    end
end

-- 更新世界boss的roomInfo
function SceneWorldBoss:_updateRoomInfo()
    if not self.m_root then return end
    local roomInfo = self.bossRoomInfo
    local data = GDatatab_world_boss_map["id_"..self.selBossId]
    local imgPath = {"ui/world_boss/common_pic_xebl.png","ui/world_boss/common_pic_wkqzt.png" }
    WZLog("-----------------8520---------------",self.selBossId)

    local txtBossName = GetElement(self.m_root,"txtBossName_SceneWorldBoss",WZUILabelTTF)
    if txtBossName then 
        txtBossName:setText(data.boss_name)
    end

    local txtLv = GetElement(self.m_root,"txtLv_SceneWorldBoss",WZUILabelTTF)
    if roomInfo.bossLevel <= 0 then
        roomInfo.bossLevel = 0
    end
    txtLv:setText("Lv"..roomInfo.bossLevel)

    --CD消耗图标
    local imgFightCDCostIcon = GetElement(self.m_root, "imgFightCDCostIcon_SceneWorldBoss", WZUIImage)
    if imgFightCDCostIcon then
        if CacheCenter:getGameParam().isUseTicket == "0" then
            imgFightCDCostIcon:setFile(GDatatab_item["id_70"].icon)
        else
            imgFightCDCostIcon:setFile(GDatatab_item["id_1"].icon)
        end
        imgFightCDCostIcon:setScale(0.5)
    end

    -- 血量条
    local pro = GetElement(self.m_root,"progBossBlood_SceneWorldBoss",WZUIProgress)
    local per = math.floor(roomInfo.bossBloodCurrent/roomInfo.bossBloodMax*100)
    pro:setPercentage(per)
    local txt = GetElement(self.m_root,"txtBossBlood_SceneWorldBoss",WZUILabelTTF)
    txt:setText(roomInfo.bossBloodCurrent.." / "..roomInfo.bossBloodMax)

    -- 鼓舞
    local txtAdd = GetElement(self.m_root,"txtFightAdd_SceneWorldBoss",WZUIFreeTextBox)
    local insp = roomInfo.inspire/10000*100
    WZLog("-----------------inspire------------------",insp)
    local str = insp.."%"
    txtAdd:setShowText(string.format(LocalStrings.WORLD_INSPIRE_ADD,str))

    local inspireInfo = self.inspireData
    if inspireInfo.bFlag then
        WZLog("--------------inspire info-------------------",inspireInfo.startP,inspireInfo.endP)
        if inspireInfo.startP < inspireInfo.endP then
            MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_ADD_SUCCESS)
        elseif inspireInfo.startP == inspireInfo.endP then
            MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_ADD_Fail)
        end
        inspireInfo.bFlag = false
        inspireInfo.startP = inspireInfo.endP
    end

    self:_initBtnInfo()
    self:updateMiddleInfo()
    self:_createPlayer()
    --怪物形象
    self:_buildGuai()
end
--@brief    创建怪物形象
function SceneWorldBoss:_buildGuai()
    if not self.bossRoomInfo then return end

    -- body
    local conMoster = GetElement(self.m_root, "conMonster_SceneWorldBoss", WZUIContainer)
    if conMoster:getChildByTag(44) then
        conMoster:removeChildByTag(44, true)
    end
    local mapId = self.bossRoomInfo.mapId
    local bossData = GDatatab_world_boss_map["id_" .. mapId]
    if not bossData then return end
    local guaiTable = WMonster
    guai = (guaiTable and guaiTable:buildGuai(bossData.monster[1][1],GDatatab_monster["id_"..bossData.monster[1][1]].scale,false))
    guai:getShopAnimation():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    guai:getShopAnimation():setUseAbsCoordinate(true)

    guai:getShopAnimation():setAbsPosition(GlobalMethod:ccp(350,0))
    guai:getShopAnimation():play("wait", true)
    local scale = 70--GDatatab_monster["id_"..bossData.monster[1][1]].scale or 30
    guai:getShopAnimation():setScale(scale/100)
    conMoster:addChild(guai:getShopAnimation(), 0, 44)
    guai:getShopAnimation():runAction(CCMoveTo:create(1.0, GlobalMethod:ccp(-50,0)))

    -- local txtMonsterName = GetElement(self.m_root, "txtMonsterName_SceneWorldTeamBossRoom", WZUILabelTTF)
    -- if txtMonsterName then
    --     txtMonsterName:setText(bossData.map_name)
    -- end
end
function SceneWorldBoss:onBtnWorldBossJumpMain()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local scene = SceneCity:createElement()
    replaceScene(scene)
end
-- 创建伤害排行
function SceneWorldBoss:_createHurtRank()
    self:_initHurtRankInfo()
    local data = self.hurtInfo
    for i = 1, #data do
        WZLog("---------------rankInfo---------------",data[i].name,data[i].rank,data[i].hurt)
    end
    local tab = GetElement(self.m_root,"tabHurt_SceneWorldBoss",WZUITableContainer)
    tab:cleanTable()
    for i = 1, #data do
        local cell,tcell = CellRankItemWorldBoss:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(data[i])
    end
end

-- 创建奖励排行(静态排行榜，只需创建一次即可)
function SceneWorldBoss:_createRewardRank()
    if not self.bRewardRank then
        local data = self.rankInfo[self.selBossId]
        local tab = GetElement(self.m_root,"tabReward_SceneWorldBoss",WZUITableContainer)
        tab:cleanTable()
        for i = 1, #data do
            local cell,tcell = CellWorldBossRankRewardItem:createElement()
            cell:setTag(i-1)
            tab:setCellElement(cell)
            tcell:setData(data[i])
        end
        self.bRewardRank = true
    end
end

-- 更新倒计时
function SceneWorldBoss:_updateCDTime(element,time)
    -- 钻石鼓舞倒计时
    local txtCdDiamond = GetElement(self.m_root,"txtCDDiamond_SceneWorldBoss",WZUILabelTTF)
    if self.bossRoomInfo.diamondCDTime > 0 then
        self.bossRoomInfo.diamondCDTime = self.bossRoomInfo.diamondCDTime - 1
    elseif self.bossRoomInfo.diamondCDTime == 0 then
        self.bossRoomInfo.diamondCDTime = -1
    end
    self:_updateDiamondBtn()

    -- 金币鼓舞倒计时
    if self.bossRoomInfo.goldCDTime > 0 then
        self.bossRoomInfo.goldCDTime = self.bossRoomInfo.goldCDTime - 1
    elseif self.bossRoomInfo.goldCDTime == 0 then
        self.bossRoomInfo.goldCDTime = -1
    end
    self:_updateGoldBtn()

    -- 挑战倒计时
    if self.bossRoomInfo.cdTime > 0 then
        self.bossRoomInfo.cdTime = self.bossRoomInfo.cdTime - 1
    elseif self.bossRoomInfo.cdTime == 0 then
        self.bossRoomInfo.cdTime = -1
    end
    self:_updateFightBtn()

    if self.bossRoomInfo.goldCDTime == -1 and self.bossRoomInfo.diamondCDTime == -1 and self.bossRoomInfo.cdTime == -1 then
        self.m_root:disableSchedule()
    end
end

-- 初始化按键的信息（金币鼓舞按键，钻石鼓舞按键，挑战按键）
function SceneWorldBoss:_initBtnInfo()
    self:_updateFightBtn()
    self:_updateGoldBtn()
    self:_updateDiamondBtn()
    -- 注册更新倒计时
    self.m_root:enableSchedule("_updateCDTime",1)
    self:_initOpenTime()
end

-- 更新战斗按键
function SceneWorldBoss:_updateFightBtn()
    local ftbCdFight = GetElement(self.m_root,"ftbCDFight_SceneWorldBoss",WZUIFreeTextBox)
    local conCd = GetElement(self.m_root,"conFightCD_SceneWorldBoss",WZUIContainer)
    local conNoCd = GetElement(self.m_root,"conFightNoCD_SceneWorldBoss",WZUIContainer)
    local state = self.bossRoomInfo.cdTime > 0 and true or false
    conCd:setVisible(state)
    conNoCd:setVisible(not state)
    ftbCdFight:setVisible(state)
    if self.bossRoomInfo.cdTime > 0 then
        WZLog("--------------8528-----------------",self.bossRoomInfo.cdTime)
        local timeStr = self:_timeChangeStyle(self.bossRoomInfo.cdTime,1)
        ftbCdFight:setShowText(string.format(LocalStrings.WORLD_BOSS_TIME_DOWN2,timeStr))

        local txtCost = GetElement(self.m_root,"txtFightCost_SceneWorldBoss",WZUILabelTTF)
        txtCost:setText(string.format(LocalStrings.WORLD_BOSS_SUB_TIME,self.bossRoomInfo.accelerateCost))
    end
    WZLog("------------fight down time---------------",self.bossRoomInfo.cdTime)
end

-- 更新金币鼓舞按键
function SceneWorldBoss:_updateGoldBtn()
    -- 金币鼓舞按键
--    local btnState = true
--    if self.bossRoomInfo.inspire >= 10000 or self.bossRoomInfo.bossState then btnState = false end
--    local btnGold = GetElement(self.m_root,"btnGold_SceneWorldBoss",WZUIButton)
--    btnGold:setTouchEnable(btnState)

    local ftbCdGold = GetElement(self.m_root,"ftbCDGold_SceneWorldBoss",WZUIFreeTextBox)
    local txtCdGold = GetElement(self.m_root,"txtCDGold_SceneWorldBoss",WZUILabelTTF)
    local bVisible = self.bossRoomInfo.goldCDTime > 0 and true or false
    ftbCdGold:setVisible(bVisible)
    txtCdGold:setVisible(not bVisible)
    if self.bossRoomInfo.goldCDTime > 0 then
        local timeStr = self:_timeChangeStyle(self.bossRoomInfo.goldCDTime,1)
        ftbCdGold:setShowText(string.format(LocalStrings.WORLD_BOSS_TIME_DOWN1,timeStr))
    else
        txtCdGold:setText(LocalStrings.MAYBE_SUCCESS_SCENEWORLDBOSS)
    end

    local txtCost = GetElement(self.m_root,"ftxtGoldCost_SceneWorldBoss",WZUIFreeTextBox)
    local data =  GDatatab_world_boss_encouraging["id_2"]
    local costFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="128,54,13" SS="4" SE="1">%d</T>]]
    txtCost:setShowText(string.format(costFormat, GDatatab_item["id_" .. data.type].icon, data.cost))
    WZLog("------------gold down time---------------",self.bossRoomInfo.goldCDTime)
end

-- 更新钻石鼓舞按键
function SceneWorldBoss:_updateDiamondBtn()
    -- 钻石鼓舞按键
    local txtCost = GetElement(self.m_root,"ftxtDiaCost_SceneWorldBoss",WZUIFreeTextBox)
    local data =  GDatatab_world_boss_encouraging["id_1"]
    local costFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="128,54,13" SS="4" SE="1">%d</T>]]
    txtCost:setShowText(string.format(costFormat, GDatatab_item["id_" .. data.type].icon, data.cost))
    WZLog("------------diamond down time---------------",self.bossRoomInfo.diamondCDTime)
end

-- 初始化开启倒计时
function SceneWorldBoss:_initOpenTime()
    local ttf = GetElement(self.m_root,"txtOpenTime_SceneWorldBoss",WZUILabelTTF)
    if self.bossRoomInfo.openTime > 0 then
        ttf:setVisible(true)
        local str = self:_timeChangeStyle(self.bossRoomInfo.openTime,2)
        ttf:setText(LocalStrings.WORLD_BOSS_OPEN_TIME_DOWN..str)
        ttf:enableSchedule("_updateOpenTime",1)
    else
        ttf:setVisible(false)
    end
end

-- 开启倒计时显示
function SceneWorldBoss:_updateOpenTime(element,time)
    local ttf = GetElement(self.m_root,"txtOpenTime_SceneWorldBoss",WZUILabelTTF)
    if self.bossRoomInfo.openTime > 0 then
        self.bossRoomInfo.openTime = self.bossRoomInfo.openTime - 1
        WZLog("------------open time-----------",self.bossRoomInfo.openTime)
        local str = self:_timeChangeStyle(self.bossRoomInfo.openTime,2)
        ttf:setText(LocalStrings.WORLD_BOSS_OPEN_TIME_DOWN..str)
    else
        element:disableSchedule()
        ProtocolProcessorSceneWorldBoss:send_WORLDBOSS_GetRoomState(GDatatab_world_boss_map["id_"..self.selBossId].id )
    end

    local txtCost = GetElement(self.m_root,"txtFightCost_SceneWorldBoss",WZUILabelTTF)
    txtCost:setFontSize(18)
end

--@brief  更新房间基本信息
function SceneWorldBoss:updateMiddleInfo()
    WZLog("SceneWorldBoss:updateMiddleInfo", self.bossRoomInfo.myRank, self.bossRoomInfo.hurt)
    local txtRoomName = GetElement(self.m_root, "txtRoomName_SceneWorldBoss", WZUILabelTTF)
    local txtRoomId = GetElement(self.m_root, "txtRoomId_SceneWorldBoss", WZUILabelTTF)
    --我的排名
    if txtRoomName then 
        if self.bossRoomInfo.hurt <= 0 then 
            txtRoomName:setText(LocalStrings.COMMUNITY_COMPETE_TEXT43)
        else
            txtRoomName:setText(self.bossRoomInfo.myRank)
        end
    end
    --我的伤害
    if txtRoomId then 
        if self.bossRoomInfo.hurt <= 0 then 
            txtRoomId:setText(LocalStrings.COMMUNITY_COMPETE_TEXT43)
        else
            local hurtPercent = self.bossRoomInfo.hurt/self.bossRoomInfo.bossBloodMax * 100
            local nPercent = string.format("%0.2f", hurtPercent)
            txtRoomId:setText(nPercent .. "%")
        end
    end

    --显示榜单第一名的信息
    WZLog("SceneWorldBoss:updateMiddleInfo", self.bossRoomInfo.myRank, self.bossRoomInfo.hurt)
    if self.bossRoomInfo.rankPlayerId == nil or #self.bossRoomInfo.rankPlayerId == 0 then 
        GetElement(self.m_root, "conFirstRank_SceneWorldBoss", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "txtNoRank_SceneWorldBoss", WZUILabelTTF):setVisible(true)
        GetElement(self.m_root, "txtNoRank_SceneWorldBoss1", WZUILabelTTF):setVisible(true)
        return 
    end
    GetElement(self.m_root, "conFirstRank_SceneWorldBoss", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "txtNoRank_SceneWorldBoss", WZUILabelTTF):setVisible(true)
    GetElement(self.m_root, "txtNoRank_SceneWorldBoss1", WZUILabelTTF):setVisible(false)

    for i=1,5 do
        local tData = self.hurtInfo[i]
        if tData then
            local head_con = GetElement(self.m_root,"worldboss_con"..i,WZUIContainer)
            head_con:setVisible(true)
            CellHead:show(head_con, tData.headId, tData.faceId, tData.sex, false, nil, tData.vipLevel, tData.headColor)
        end
    end

    --名字
    --[[local txtPlayerNames = GetElement(self.m_root, "txtPlayerNames_SceneWorldBoss", WZUILabelTTF)
    if txtPlayerNames then 
        txtPlayerNames:setText(self.bossRoomInfo.rankPlayerName[1])
    end
    --伤害
    local txtPlayerHurts = GetElement(self.m_root, "txtPlayerHurts_SceneWorldBoss", WZUILabelTTF)
    if txtPlayerHurts then 
        txtPlayerHurts:setText(self.bossRoomInfo.rankHurt[1])
    end
    --]]
end
function SceneWorldBoss:adaptIphoneX()
    if IsIphoneX() then
        local conRank_SceneWorldBoss = GetElement(self.m_root,"conRank_SceneWorldBoss",WZUIContainer)
        conRank_SceneWorldBoss:setRelativePosition(GlobalMethod:ccp(0.85,0.5))
    end
end
function SceneWorldBoss:onBtnClickWorldBoss(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local index = tonumber(element:getTag())
    
    if self.hurtInfo and self.hurtInfo[index] then
        WndCheckOther:show(self.hurtInfo[index].id)
    end
end
--@brief    创建玩家形象
function SceneWorldBoss:_createPlayer()
    --body
    self:showPlayerFigureAndPet()
end

--@brief 显示玩家形象与宠物
function SceneWorldBoss:showPlayerFigureAndPet()
    WZLog("SceneWorldBoss:showPlayerFigureAndPet")
    local playerEquipment = CacheCenter:getEquipedDecorationList()

    local conSeat = GetElement(self.m_root, "conSeat_SceneWorldBoss", WZUIContainer)
    local conPlayer = GetElement(conSeat,"conPlayer_SceneWorldBoss",WZUIContainer)
    conPlayer:removeAllChildrenWithCleanup(true)

    local playerInfo = CacheCenter:getPlayerInfo()
    
    local playerId = playerInfo.id
    local animAtionName = nil
    local scalePlayer = 0.8
    local headColor, bodyColor = CacheCenter:getHeadAndBodyColor()
    local playerFigure = self:createAPlayer(playerInfo.sex, playerEquipment, headColor, bodyColor, animAtionName)
    playerFigure:getAnimNode():setTag(playerId)
    playerFigure:setScale(scalePlayer)
    local playerAnimNode = playerFigure:getAnimNode()
    playerAnimNode:setScale(1.5)
    conPlayer:addChild(playerAnimNode)

    local conPet = GetElement(conSeat,"conPet_SceneWorldBoss",WZUIContainer)
    
    local petInfo = playerInfo.petInfo
    
    if petInfo ~= nil and petInfo.itemId ~= nil then
        local petTag = playerId+10
        local petFigure = conPet:getChildByTag(petTag)
        if petFigure == nil then
            conPet:removeAllChildrenWithCleanup(true)
            local petId = petInfo.itemId
            local animation = petInfo.animation
            local petAnimation,par = CreatePetAni(conPet,petId,animation,petInfo.advancedLevel, petInfo.petSkinItemId)
            petAnimation:setScale(0.65)
            if par then par:setScale(0.65) end
            petAnimation:getAnimNode():setTouchEnable(false)

            GetElement(self.m_root, "btnPlayerPet_SceneWorldBoss", WZUIButton):setVisible(true)
        end
    else
        GetElement(self.m_root, "btnPlayerPet_SceneWorldBoss", WZUIButton):setVisible(false)
        local petTag = playerId+10
        local petFigure = conPet:getChildByTag(petTag)
        if petFigure == nil then
            conPet:removeAllChildrenWithCleanup(true)
        end
    end
    --名字和称号
    local conForNameAndTitle = GetElement(conSeat, "conForNameAndTitle_SceneWorldBoss", WZUIContainer)
    if conForNameAndTitle then
        local txtPlayerName = GetElement(conSeat, "txtPlayerName_SceneWorldBoss", WZUILabelTTF)
        txtPlayerName:setText(playerInfo.name)
        local txtPlayerLv = GetElement(conSeat, "txtPlayerLv_SceneWorldBoss", WZUILabelTTF)
        txtPlayerLv:setText("Lv" .. playerInfo.level)
        if playerId == CacheCenter:getPlayerInfo().id then
            txtPlayerName:setColor(GlobalMethod:ccc3(99,255,95))
        else
            txtPlayerName:setColor(GlobalMethod:ccc3(255,255,255))
        end
        local conTitle = GetElement(conSeat, "conTitle_SceneWorldBoss", WZUIContainer)
        local txtPlayerTitle = GetElement(conSeat, "txtPlayerTitle_SceneWorldBoss", WZUILabelTTF)
        local tempPoint = GlobalMethod:ccp(0.5, 1.9)
        if playerInfo.title and playerInfo.title ~= "" then
            -- CreateDesiSpine(conTitle, txtPlayerTitle, playerInfo.title, tempPoint, nil, 0.9)
        end
    end
end

--@brief    创建一个角色动画
function SceneWorldBoss:createAPlayer(playerSex, equipment, headColor, bodyColor, animName)
    WZLog("SceneWorldBoss:createAPlayer")
    return CreatePlayerFigure(playerSex, equipment, animName, nil, nil, nil, nil, nil, nil, nil, headColor, bodyColor)
end
-------------------------------------------------语言适配Begin-----------------------------
function SceneWorldBoss:_adaptLanguage_vn()
    local txtCDGold = GetElement(self.m_root,"txtCDGold_SceneWorldBoss",WZUILabelTTF)
    txtCDGold:setScale(0.6)
    txtCDGold:setDimensions(GlobalMethod:CCSize(120))
    local txtCDDiamond = GetElement(self.m_root,"txtCDDiamond_SceneWorldBoss",WZUILabelTTF)
    txtCDDiamond:setScale(0.6)
    txtCDDiamond:setDimensions(GlobalMethod:CCSize(120))

    local ftxtGoldCost = GetElement(self.m_root,"ftxtGoldCost_SceneWorldBoss",WZUIFreeTextBox)
    ftxtGoldCost:setScale(0.7)
    ftxtGoldCost:setRelativePosition(GlobalMethod:ccp(0.5,-0.32))
    local ftxtDiaCost = GetElement(self.m_root,"ftxtDiaCost_SceneWorldBoss",WZUIFreeTextBox)
    ftxtDiaCost:setScale(0.7)
    ftxtDiaCost:setRelativePosition(GlobalMethod:ccp(0.5,-0.32))

    GetElement(self.m_root,"txtFightAdd_SceneWorldBoss",WZUIFreeTextBox):setScale(0.9)
    -- local txtCheckBox1 = GetElement(self.m_root,"txtCheck1_SceneWorldBoss",WZUILabelTTF)
    -- txtCheckBox1:setFontSize(18)
    -- GetElement(self.m_root,"txtCheckSel1_SceneWorldBoss",WZUILabelTTF):setScale(0.7)

    -- local txtCheckBox2 = GetElement(self.m_root,"txtCheck2_SceneWorldBoss",WZUILabelTTF)
    -- txtCheckBox2:setFontSize(18)

    local txtGoldCost = GetElement(self.m_root,"txtCDGold_SceneWorldBoss",WZUILabelTTF)
    txtGoldCost:setFontSize(18)
    
    local txtNoRank = GetElement(self.m_root, "txtNoRank_SceneWorldBoss1", WZUILabelTTF)
    txtNoRank:setRotation(90)

end

function SceneWorldBoss:_adaptLanguage_en(  )    
    GetElement(self.m_root,"ftxtGoldCost_SceneWorldBoss",WZUIFreeTextBox):setScale(0.7)
    GetElement(self.m_root,"ftxtDiaCost_SceneWorldBoss",WZUIFreeTextBox):setScale(0.7)

    local txtFightCost = GetElement(self.m_root,"txtFightCost_SceneWorldBoss",WZUILabelTTF)
    txtFightCost:setFontSize(18)
    txtFightCost:setRelativePosition(GlobalMethod:ccp(0.384305,0.5))

    local ftbCdGold = GetElement(self.m_root,"ftbCDGold_SceneWorldBoss",WZUIFreeTextBox)
    ftbCdGold:setScale(0.8)
    GetElement(self.m_root,"txtCheck1_SceneWorldBoss",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtCheckSel1_SceneWorldBoss",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtCheck2_SceneWorldBoss",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtCheckSel2_SceneWorldBoss",WZUILabelTTF):setFontSize(22)

    GetElement(self.m_root,"txtBossBlood_SceneWorldBoss",WZUILabelTTF):setScale(0.8)
end

function SceneWorldBoss:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtFightCost_SceneWorldBoss",WZUILabelTTF):setFontSize(20)
    
    local txtCDGold = GetElement(self.m_root,"txtCDGold_SceneWorldBoss",WZUILabelTTF)
    txtCDGold:setFontSize(18)

    local txtCDDiamond = GetElement(self.m_root,"txtCDDiamond_SceneWorldBoss",WZUILabelTTF)
    txtCDDiamond:setFontSize(18)

    GetElement(self.m_root,"txtCheck1_SceneWorldBoss",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCheckSel1_SceneWorldBoss",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCheck2_SceneWorldBoss",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCheckSel2_SceneWorldBoss",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"ftxtGoldCost_SceneWorldBoss",WZUIFreeTextBox):setScale(0.6)
    GetElement(self.m_root,"ftxtDiaCost_SceneWorldBoss",WZUIFreeTextBox):setScale(0.6)

    GetElement(self.m_root,"txtBossBlood_SceneWorldBoss",WZUILabelTTF):setScale(0.8)
end

function SceneWorldBoss:_adaptLanguage_tr(  )
    local ftxtGoldCost = GetElement(self.m_root,"ftxtGoldCost_SceneWorldBoss",WZUIFreeTextBox)
    ftxtGoldCost:setScale(0.9)
    
    --GetElement(self.m_root,"imgDiamond_SceneWorldBoss",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.187821,0.552632))
    local txtFightCost = GetElement(self.m_root,"txtFightCost_SceneWorldBoss",WZUILabelTTF)
    txtFightCost:setScale(0.9)
    txtFightCost:setRelativePosition(GlobalMethod:ccp(0.308834,0.552632))
    txtFightCost:setDimensions(GlobalMethod:CCSize(140))

end
function SceneWorldBoss:_adaptLanguage_es(  )
    GetElement(self.m_root,"ftxtGoldCost_SceneWorldBoss",WZUIFreeTextBox):setScale(0.8)
    GetElement(self.m_root,"ftxtDiaCost_SceneWorldBoss",WZUIFreeTextBox):setScale(0.8)

    GetElement(self.m_root,"txtFightAdd_SceneWorldBoss",WZUIFreeTextBox):setScale(0.7)

    GetElement(self.m_root,"txtBossBlood_SceneWorldBoss",WZUILabelTTF):setScale(0.8)
end

function SceneWorldBoss:_adaptLanguage_th(  )
    GetElement(self.m_root,"ftxtGoldCost_SceneWorldBoss",WZUIFreeTextBox):setScale(0.6)
    GetElement(self.m_root,"ftxtDiaCost_SceneWorldBoss",WZUIFreeTextBox):setScale(0.6)
end

function SceneWorldBoss:_adaptLanguage_ug(  )
    GetElement(self.m_root,"txtCheck1_SceneWorldBoss",WZUILabelTTF):setScale(0.45)
    GetElement(self.m_root,"txtCheckSel1_SceneWorldBoss",WZUILabelTTF):setScale(0.45)
    GetElement(self.m_root,"txtCheck2_SceneWorldBoss",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCheckSel2_SceneWorldBoss",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"ftxtGoldCost_SceneWorldBoss",WZUIFreeTextBox):setScale(0.5)
    GetElement(self.m_root,"ftxtDiaCost_SceneWorldBoss",WZUIFreeTextBox):setScale(0.5)

    GetElement(self.m_root,"txtFightAdd_SceneWorldBoss",WZUIFreeTextBox):setScale(0.7)

    local txtCDGold = GetElement(self.m_root,"txtCDGold_SceneWorldBoss",WZUILabelTTF)
    txtCDGold:setScale(0.7)
    txtCDGold:setDimensions(GlobalMethod:CCSize(200))
    local txtCDDiamond = GetElement(self.m_root,"txtCDDiamond_SceneWorldBoss",WZUILabelTTF)
    txtCDDiamond:setScale(0.7)
    txtCDDiamond:setDimensions(GlobalMethod:CCSize(260))
end
---------------------------------语言适配End----------------------------------------------