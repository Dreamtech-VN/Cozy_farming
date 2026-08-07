--SceneWorldTeamBoss.lua
--@brief	SceneWorldTeamBoss的UI模块
--@date		2018/07/10
--@author	Tianxiang_Xu
--@note		世界组队boss界面


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneWorldTeamBoss:onEnter(element)
	SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)
	ChangeChatChannel(Chat_Channel_WorldTeam_Boss)
	self.m_root = element
    AdaptLanguage(self)
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
	--注册协议组所有协议
	ProtocolProcessorWorldTeamBossRoom:regAll()
    -- 初始化奖励信息
    self:initRewardRankInfo()
    self:_initInspireState()
    self:_addTop()

    WndChat:addChatWindowToCurScene()
end

--@brief	打开加载动画
function SceneWorldTeamBoss:onEnterTransitionDidFinish(element)
	local tConfig = CacheCenter:getGameParam().teamWorldBossConfig
	self.m_tSysConfig = json.decode(tConfig)
	WZLog("SceneWorldTeamBoss:onEnterTransitionDidFinish", Serialize(self.m_tSysConfig))
	self:_setBoxPosition()
    self:createLoading()
    ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetRoomState()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneWorldTeamBoss:onExit(element)
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","WndShop")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","WndShop")
    
	ProtocolProcessorWorldTeamBossRoom:unregAll()
	self:_unInit()
end

-- 关闭按钮回调函数
function SceneWorldTeamBoss:onReturn()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    local sceneIsland = SceneIsland:createElement()
    replaceScene(sceneIsland)
    if self.m_tReturnCallBack then
        self.m_tReturnCallBack[2](self.m_tReturnCallBack[1])
    end
end

--@brief    点击规则按钮回调
function SceneWorldTeamBoss:onClickRule(element)
    -- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.TEAMBOSS_TEXT2)
end

-- 创建加载框
function SceneWorldTeamBoss:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox(15)
end

-- 关闭加载框
function SceneWorldTeamBoss:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end


-- 游戏顶部
function SceneWorldTeamBoss:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_sylz.png",SceneWorldTeamBoss,SceneWorldTeamBoss.onReturn,true,true,true,"SceneWorldTeamBoss")
end
-----------------------------------------------回调start----------------------------------------------------------------

function SceneWorldTeamBoss:onCloseTips(element,pt)
    local point = self.m_root:convertToNodeSpace(pt)
    local bPoint = WndItemInfo:checkPoint(pt)
    if not bPoint then  WndItemInfo:onCloseClick() end
end

--@brief  钻石鼓舞回调
function SceneWorldTeamBoss:onDiamondInspire( element )
    WZLog("------diamondInspire----------------", self.bossRoomInfo.bossLevel)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- 鼓舞满
    if self.bossRoomInfo.inspire >= 10000 then
        MsgBoxManager:showTipBox(LocalStrings.WOLRD_BOSS_INSPIRE_FULL)
        return
    end

    -- boss存活 boss死亡2 boss逃跑3 不能鼓舞
    if self.bossRoomInfo.bossState == 1 and self.bossRoomInfo.openTime > 0 then
        MsgBoxManager:showTipBox(LocalStrings.TEAMBOSS_TEXT18)
        return
    elseif self.bossRoomInfo.bossState == 2 then
        MsgBoxManager:showTipBox(LocalStrings.WOLRD_BOSS_DEAD_NOT_INSPIRE)
        return
    elseif self.bossRoomInfo.bossState == 3 then
        MsgBoxManager:showTipBox(LocalStrings.TEAMBOSS_TEXT19)
        return
    end

    if self.bossRoomInfo.bossLevel == 0 then
        MsgBoxManager:showTipBox(LocalStrings.TEAMBOSS_TEXT18)
    else
        local data =  GDatatab_team_world_boss_encouraging["id_1"]
        if JudgeMoneyIsEnough(data.type, data.cost, nil, nil, Chat_Channel_WorldTeam_Boss, nil, nil, nil, nil, self, self.sureInspire) then
            self:sureInspire()
        end
    end
end

--@brief    确定鼓舞
function SceneWorldTeamBoss:sureInspire()
    -- body
    self.inspireData.bFlag = true
    local data =  GDatatab_team_world_boss_encouraging["id_1"]
    ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Inspire(data.type)
end

--@brief  金币鼓舞回调
function SceneWorldTeamBoss:onGoldInspire( element )
    WZLog("------goldInspire----------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.bossRoomInfo.inspire >= 10000 then
        MsgBoxManager:showTipBox(LocalStrings.WOLRD_BOSS_INSPIRE_FULL)
        return
    end

    -- boss存活 boss死亡2 boss逃跑3 不能鼓舞
    if self.bossRoomInfo.bossState == 1 and self.bossRoomInfo.openTime > 0 then
        MsgBoxManager:showTipBox(LocalStrings.TEAMBOSS_TEXT18)
        return
    elseif self.bossRoomInfo.bossState == 2 then
        MsgBoxManager:showTipBox(LocalStrings.WOLRD_BOSS_DEAD_NOT_INSPIRE)
        return
    elseif self.bossRoomInfo.bossState == 3 then
        MsgBoxManager:showTipBox(LocalStrings.TEAMBOSS_TEXT19)
        return
    end

    if self.bossRoomInfo.goldCDTime > 0 then
        MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_GOLD_LAST)
        return
    end

    if self.bossRoomInfo.bossLevel == 0 then
        MsgBoxManager:showTipBox(LocalStrings.TEAMBOSS_TEXT18)
    else
        local data =  GDatatab_team_world_boss_encouraging["id_2"]
        if JudgeMoneyIsEnough(data.type, data.cost, nil, nil, Chat_Channel_WorldTeam_Boss) then
            self.inspireData.bFlag = true
            ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_Inspire(data.type)
        end
    end
end

--@brief	查找回调
function SceneWorldTeamBoss:onSearchButtonClick(element)
	WZLog("SceneWorldTeamBoss:onSearchButtonClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if not self:_challengeStateJudge() then return end 
    if not self:_challengeTimesJudge() then return end 

    local wndFindRoom = WndFindRoom:createElement()
    if wndFindRoom ~= nil then
        WindowManager:addWindow(wndFindRoom,WndFindRoom,true,nil,nil)
        WndFindRoom:setFindBtnCallBack(self.searchRoom,self)
    end
end

-- 点击创建房间回调
function SceneWorldTeamBoss:onCreateRoomOK(element)
    WZLog("SceneWorldTeamBoss:onCreateRoomOK one")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if not self:_challengeStateJudge() then return end 
    if not self:_challengeTimesJudge() then return end 

    local name = string.format(LocalStrings.ROOMS, CacheCenter:getPlayerInfo().name)
    self:createRoom(name, "-1")
end

--@brief	创建房间
function SceneWorldTeamBoss:createRoom(roomName, passWord)
	WZLog("SceneWorldTeamBoss:createRoom ")
    self:createLoadingBox()
    ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_CreateRoom(roomName, passWord)
end

-- 快速游戏按钮点击回调
function SceneWorldTeamBoss:onFastGameButtonClick(element)
	WZLog("SceneWorldTeamBoss:onFastGameButtonClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if not self:_challengeStateJudge() then return end 
    if not self:_challengeTimesJudge() then return end 

    if self.m_nCount == 0 then
        self.m_nCount = 1
        element:enableSchedule("scheduleCalculate",1)
    else
        return
    end

    self:createLoadingBox()
    ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_QuickGame( )
end

function SceneWorldTeamBoss:scheduleCalculate(element)
    WZLog("SceneWorldTeamBoss:scheduleCalculate")
    element:disableSchedule()
    self.m_nCount = 0
end

--@brief	查找房间
--@param 	入参与创建房间的协议发送方法参数相同
--@return	true:关闭WndEditBox，false:反之
--@note     调用这个函数发送查找房间协议,起到代理的作用
function SceneWorldTeamBoss:searchRoom(roomId, password)
	WZLog("SceneWorldTeamBoss:searchRoom =", password)
    WZLog("room id",roomId)
	local id = tonumber(roomId)
	if id == nil then
        MsgBoxManager:showTipBox(LocalStrings.ROOM_FIND_TIPS)
		return false
    else
    	if password == nil  then 
    		WZLog("SceneWorldTeamBoss:searchRoom password == nil ")
    		ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_SelectRoom(roomId, "-1")
		else
			WZLog("SceneWorldTeamBoss:searchRoom password ~= nil ")
			if password == "" then
                WZLog("SceneWorldTeamBoss:searchRoom 11111") 
                ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_SelectRoom(roomId, "")
            else 
                WZLog("SceneWorldTeamBoss:searchRoom 22222") 
				ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_SelectRoom(roomId, password) 
			end 
		end
        self:createLoadingBox()
		return true
	end
end

function SceneWorldTeamBoss:onClickRewardBox(element)
    -- body
    WZLog("SceneWorldTeamBoss:onClickRewardBox")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    local bossData = GDatatab_team_world_boss_map["id_" .. self.bossRoomInfo.mapId]
    local rewardList = {}
    rewardList.strartNum = nil
    rewardList.icon = {}   
    rewardList.num = {}
    rewardList.nType = 4
    rewardList.strartNum = math.floor((self.bossRoomInfo.bossBloodMax - self.bossRoomInfo.bossBloodCurrent)/self.bossRoomInfo.bossBloodMax * 100) 
   
    rewardList.endNum = self.m_tSysConfig["stage" .. tag]
    rewardList.curNum = self.bossRoomInfo.hurt
    rewardList.targetNum = bossData.min_hurt
    local reward = bossData["fixed_reward" .. tag]
    if reward then
        for i = 1, #reward do
            table.insert(rewardList.icon, GDatatab_item["id_" .. reward[i][1]].icon)
            table.insert(rewardList.num, reward[i][2])
        end
    end

    WndTips:show(element, SceneWorldTeamBoss.m_root, 3, rewardList, GlobalMethod:ccp(220,100), true)
end

--@brief	房间列表项点击回调
--@param 	element:cellRoomItem的引用
--@note		由cellRoomItem回调
function SceneWorldTeamBoss:onRoomListClick(tCell)
	assert(tCell.m_tData.roomId, "room id is nil")

    if not self:_challengeStateJudge() then return end 
    if not self:_challengeTimesJudge() then return end 

	if tCell.m_tData.state ~= 0 then --战斗中
		MsgBoxManager:showTipBox(LocalStrings.ROOM_BATTLEING)
	elseif tCell.m_tData.count == tCell.m_tData.maxNum then --房间已满
		MsgBoxManager:showTipBox(LocalStrings.ROOM_FULL)
	else
		if tCell.m_tData.passWord ~= "-1" and tCell.m_tData.passWord ~= "" then
			--需要输入密码
        	self.m_tSearchRoomData = {roomId = tCell.m_tData.roomId, password = tCell.m_tData.passWord}
        	self:enterRoomPassword()
        elseif tCell.m_tData.passWord == "" then
        	self:searchRoom(tCell.m_tData.roomId, tCell.m_tData.passWord)
        else 
            self:searchRoom(tCell.m_tData.roomId)
    	end
	end
end

--@brief	输入房间密码
--@param 	入参与创建房间的协议发送方法参数相同
--@note     当房间需要密码时，弹出窗口
function SceneWorldTeamBoss:enterRoomPassword()
	WZLog("SceneWorldTeamBoss:enterRoomPassword")
	local element = WndEditBox:createElement()
    WZLog("WndEditBox:createElement", element)
    if nil ~= element then
    	local tNewObj= element:getLuaObjectIndex()
        WndEditBox:setData(LocalStrings.ROOM_PASSWORD, LocalStrings.CLICK_TO_INPUT_PASSWORD)
        WndEditBox:setEditType(2)
        WndEditBox:setOkCallBack(self.enterRoomPasswordOk, SceneWorldTeamBoss)
        WindowManager:addWindow(element, WndEditBox,true,nil,nil)
    end
end

--@brief	输入房间密码完毕
--@note     当房间需要密码时，弹出窗口
function SceneWorldTeamBoss:enterRoomPasswordOk(password)
	WZLog("SceneWorldTeamBoss:enterRoomPasswordOk")
	if password ~= self.m_tSearchRoomData.password then
		MsgBoxManager:showTipBox(LocalStrings.PASSWORD_NOT_MATCH)
		return false
	else
		self:searchRoom(self.m_tSearchRoomData.roomId, self.m_tSearchRoomData.password)
		return true
	end
end
-----------------------------------------------回调end------------------------------------------------------------------


---------------------------------------------私有方法模块start----------------------------------------------------------

-- 倒计时格式转换
function SceneWorldTeamBoss:_timeChangeStyle(time,type)
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
function SceneWorldTeamBoss:onCheckBox( element )
    WZLog("SceneWorldTeamBoss:event_hurtRankFunc")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    
    local  tag = element:getTag()
    self.checkIndex = tag
    self:_updateRankInfo(tag)
end

-- 更新排行榜显示模块
function SceneWorldTeamBoss:_updateRankInfo(tag)
    if tag == 1 then
        GetElement(self.m_root, "conHurtList_SceneWorldTeamBoss", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conList_SceneWorldTeamBoss", WZUIContainer):setVisible(false)
    else
        GetElement(self.m_root, "conHurtList_SceneWorldTeamBoss", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conList_SceneWorldTeamBoss", WZUIContainer):setVisible(true)
    end
	self:_setRankTitle(tag)
	for i = 1, 3 do
		if i == tag then
			GetElement(self.m_root, "conCheck" .. i .. "_SceneWorldTeamBoss", WZUIContainer):setVisible(true)
		else
			GetElement(self.m_root, "conCheck" .. i .. "_SceneWorldTeamBoss", WZUIContainer):setVisible(false)
		end
	end
    -- 显示对于的伤害排行榜
    if tag == 1 then
    	if self.hurtInfo == nil then
    		self:createLoading()
    		ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetHurtRank()
    	else
        	self:_createHurtRank()
        end
    elseif tag == 2 then 	--房间
    	self:createLoading()
    	ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetRoomList( )
    else
        self:_createRewardRank()
    end
end

-- 更新世界boss的roomInfo
function SceneWorldTeamBoss:_updateRoomInfo(bInspire)
    if not self.m_root then return end
    local roomInfo = self.bossRoomInfo

    local txtLv = GetElement(self.m_root,"txtLv_SceneWorldTeamBoss",WZUILabelTTF)
    txtLv:setText("Lv"..roomInfo.bossLevel)

    -- 血量条
    local pro = GetElement(self.m_root,"progBossBlood_SceneWorldTeamBoss",WZUIProgress)
    local per = math.floor(roomInfo.bossBloodCurrent/roomInfo.bossBloodMax*100)
    pro:setPercentage(per)
    local txt = GetElement(self.m_root,"txtBossBlood_SceneWorldTeamBoss",WZUILabelTTF)
    txt:setText(roomInfo.bossBloodCurrent.."/"..roomInfo.bossBloodMax)

    -- 鼓舞
    local txtAdd = GetElement(self.m_root,"txtFightAdd_SceneWorldTeamBoss",WZUIFreeTextBox)
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

    --更新鼓舞值调用时候，只刷新鼓舞值
    if bInspire then return end 

    self:_setLeftTimes()
    self:_initBtnInfo()
    if self.checkIndex == nil then self.checkIndex = 1 end
    self:_updateRankInfo(self.checkIndex)

    self:_buildGuai()
end

-- 创建伤害排行
function SceneWorldTeamBoss:_createHurtRank()
    local data = self.hurtInfo
    
    local tab = GetElement(self.m_root, "tabHurtList_SceneWorldTeamBoss", WZUITableContainer)
    tab:cleanTable()

    local conList = GetElement(self.m_root, "conHurtList_SceneWorldTeamBoss", WZUIContainer)
    if data == nil or #data == 0 then
    	ShowPanelNullTip(conList)
    	return
    end
    removeShowPanelNullTip(conList)

    for i = 1, #data do
        local cell,tcell = CellWorldTeamBossList:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(data[i], 1)
    end

    --我的排名和伤害
    self:showMyRankAndHurt()
end

-- 创建奖励排行(静态排行榜，只需创建一次即可)
function SceneWorldTeamBoss:_createRewardRank()
    local data = self.rankInfo[self.bossRoomInfo.mapId]
    local tab = GetElement(self.m_root, "tabList_SceneWorldTeamBoss", WZUITableContainer)
    tab:cleanTable()

    local conList = GetElement(self.m_root, "conList_SceneWorldTeamBoss", WZUIContainer)
    if data == nil or #data == 0 then
    	ShowPanelNullTip(conList)
    	return
    end
    removeShowPanelNullTip(conList)

    for i = 1, #data do
        local cell,tcell = CellWorldTeamBossList:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(data[i], 3)
    end
end

-- 创建伤害排行
function SceneWorldTeamBoss:_createRoomList()
    local data = self.m_tRoomList
    
    local tab = GetElement(self.m_root, "tabList_SceneWorldTeamBoss", WZUITableContainer)
    tab:cleanTable()

    local conList = GetElement(self.m_root, "conList_SceneWorldTeamBoss", WZUIContainer)
    if data == nil or #data == 0 then
    	ShowPanelNullTip(conList)
    	return
    end
    removeShowPanelNullTip(conList)

    for i = 1, #data do
        local cell,tcell = CellWorldTeamBossList:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(data[i], 2)
    end
end

-- 更新倒计时
function SceneWorldTeamBoss:_updateCDTime(element,time)
    -- 钻石鼓舞倒计时
    local txtCdDiamond = GetElement(self.m_root,"txtCDDiamond_SceneWorldTeamBoss",WZUILabelTTF)
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

    if self.bossRoomInfo.goldCDTime == -1 and self.bossRoomInfo.diamondCDTime == -1 then
        self.m_root:disableSchedule()
    end
end

-- 初始化按键的信息（金币鼓舞按键，钻石鼓舞按键，挑战按键）
function SceneWorldTeamBoss:_initBtnInfo()
    self:_updateGoldBtn()
    self:_updateDiamondBtn()
    -- 注册更新倒计时
    self.m_root:enableSchedule("_updateCDTime",1)
    self:_initOpenTime()
end

-- 更新金币鼓舞按键
function SceneWorldTeamBoss:_updateGoldBtn()
    -- 金币鼓舞按键

    local ftbCdGold = GetElement(self.m_root,"ftbCDGold_SceneWorldTeamBoss",WZUIFreeTextBox)
    local txtCdGold = GetElement(self.m_root,"txtCDGold_SceneWorldTeamBoss",WZUILabelTTF)
    local bVisible = self.bossRoomInfo.goldCDTime > 0 and true or false
    ftbCdGold:setVisible(bVisible)
    txtCdGold:setVisible(not bVisible)
    if self.bossRoomInfo.goldCDTime > 0 then
        local timeStr = self:_timeChangeStyle(self.bossRoomInfo.goldCDTime,1)
        ftbCdGold:setShowText(string.format(LocalStrings.WORLD_BOSS_TIME_DOWN1,timeStr))
    else
        txtCdGold:setText(LocalStrings.MAYBE_SUCCESS_SCENEWORLDBOSS)
    end

    local txtCost = GetElement(self.m_root,"ftxtGoldCost_SceneWorldTeamBoss",WZUIFreeTextBox)
    local data =  GDatatab_team_world_boss_encouraging["id_2"]
    txtCost:setShowText(string.format(LocalStrings.WORLD_BOSS_INSPIRE,GDatatab_item["id_" .. data.type].icon,data.cost))
    WZLog("------------gold down time---------------",self.bossRoomInfo.goldCDTime)
end

-- 更新钻石鼓舞按键
function SceneWorldTeamBoss:_updateDiamondBtn()
    -- 钻石鼓舞按键
    local txtCost = GetElement(self.m_root,"ftxtDiaCost_SceneWorldTeamBoss",WZUIFreeTextBox)
    local data =  GDatatab_team_world_boss_encouraging["id_1"]
    txtCost:setShowText(string.format(LocalStrings.WORLD_BOSS_INSPIRE, GDatatab_item["id_" .. data.type].icon, data.cost))
    WZLog("------------diamond down time---------------",self.bossRoomInfo.diamondCDTime)
end

-- 初始化开启倒计时
function SceneWorldTeamBoss:_initOpenTime()
    local ttf = GetElement(self.m_root,"txtOpenTime_SceneWorldTeamBoss",WZUILabelTTF)
    if self.bossRoomInfo.openTime > 0 then
        ttf:setVisible(false)
        local str = self:_timeChangeStyle(self.bossRoomInfo.openTime,2)
        ttf:setText(LocalStrings.WORLD_BOSS_OPEN_TIME_DOWN..str)
        ttf:enableSchedule("_updateOpenTime",1)
    else
        ttf:setVisible(false)
    end
end

-- 开启倒计时显示
function SceneWorldTeamBoss:_updateOpenTime(element,time)
    local ttf = GetElement(self.m_root,"txtOpenTime_SceneWorldTeamBoss",WZUILabelTTF)
    if self.bossRoomInfo.openTime > 0 then
        self.bossRoomInfo.openTime = self.bossRoomInfo.openTime - 1
        WZLog("------------open time-----------",self.bossRoomInfo.openTime)
        local str = self:_timeChangeStyle(self.bossRoomInfo.openTime,2)
        ttf:setText(LocalStrings.WORLD_BOSS_OPEN_TIME_DOWN..str)
    else
        element:disableSchedule()
        ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetRoomState()
    end
end

--@brief 	设置榜单文字
function SceneWorldTeamBoss:_setRankTitle(nTag)
	-- body
	local txtTitle1 = GetElement(self.m_root, "txtTitle1_SceneWorldTeamBoss", WZUILabelTTF)
	local txtTitle2 = GetElement(self.m_root, "txtTitle2_SceneWorldTeamBoss", WZUILabelTTF)
	local txtTitle3 = GetElement(self.m_root, "txtTitle3_SceneWorldTeamBoss", WZUILabelTTF)
	txtTitle1:setVisible(true)
	txtTitle2:setVisible(true)
	txtTitle3:setVisible(true)
	txtTitle3:setRelativePosition(GlobalMethod:ccp(0.754,0.5))
	if nTag == 1 then
		txtTitle1:setText(LocalStrings.RANK)
		txtTitle2:setText(LocalStrings.PLAYER)
		txtTitle3:setText(LocalStrings.SETTLMENT_DAMAGE)
		txtTitle3:setRelativePosition(GlobalMethod:ccp(0.87,0.5))
	elseif nTag == 2 then
		txtTitle1:setVisible(false)
		txtTitle2:setText(LocalStrings.ROOM1)
		txtTitle3:setText(LocalStrings.COMMUNITY_COMPETE_TEXT4)
		txtTitle3:setRelativePosition(GlobalMethod:ccp(0.87,0.5))
	elseif nTag == 3 then
		txtTitle1:setText(LocalStrings.RANK)
		txtTitle2:setText(LocalStrings.ATH_REWARD_CHECK)
		txtTitle3:setVisible(false)
	end
end

--@brief 	剩余挑战次数
function SceneWorldTeamBoss:_setLeftTimes()
	-- body
	local txtLeftTimes = GetElement(self.m_root, "txtLeftTimes_SceneWorldTeamBoss", WZUILabelTTF)
	if txtLeftTimes then
		txtLeftTimes:setText(LocalStrings.CHALLENGE_SURPLUS_COUNT .. self.bossRoomInfo.leftNum .. "/" .. self.m_tSysConfig.freeNum)
	end
end

--@brief 	创建怪物形象
function SceneWorldTeamBoss:_buildGuai()
	-- body
	local conMoster = GetElement(self.m_root, "conMoster_SceneWorldTeamBoss", WZUIContainer)
	if conMoster:getChildByTag(44) then
		conMoster:removeChildByTag(44, true)
	end

	local mapId = self.bossRoomInfo.mapId
	local bossData = GDatatab_team_world_boss_map["id_" .. mapId]
	local guaiTable = WMonster
    guai = (guaiTable and guaiTable:buildGuai(bossData.monster[1][1],GDatatab_monster["id_"..bossData.monster[1][1]].scale,false))
    guai:getShopAnimation():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    guai:getShopAnimation():setRelativePosition(GlobalMethod:ccp(0.5, 0))
    if mapId == 10007 or mapId == 10008 or mapId == 10009 or mapId == 10010 then
        guai:getShopAnimation():play("wait_1", true)
    else
        guai:getShopAnimation():play("wait", true)
    end
    guai:getShopAnimation():setScale(bossData.scale/100)
    conMoster:addChild(guai:getShopAnimation(), 0, 44)
--    self.m_nMonsterAniIndex = 1

    local txtMonsterName = GetElement(self.m_root, "txtMonsterName_SceneWorldTeamBoss", WZUILabelTTF)
    if txtMonsterName then
    	txtMonsterName:setText(bossData.map_name)
    end

--    conMoster:enableSchedule("_changeMonsterAni", 3)
end

--@brief    改变怪的动作
-- function SceneWorldTeamBoss:_changeMonsterAni(element)
--     -- body
--     local guaiAni = element:getChildByTag(44)
--     if guaiAni then
--         element:disableSchedule()
--         if self.m_nMonsterAniIndex == 2 then
--             guaiAni:play("wait", true)

--             self.m_nMonsterAniIndex = 1
--             element:enableSchedule("_changeMonsterAni", 3)
--         else
--             guaiAni:play("attack", false)
--             element:enableSchedule("_changeMonsterAni", 2)
--             self.m_nMonsterAniIndex = 2
--         end
--     end
-- end

--@brief    设置宝箱位置
function SceneWorldTeamBoss:_setBoxPosition()
    -- body
    for i = 1, 3 do
        local conRewardBox = GetElement(self.m_root, "conRewardBox" .. i .. "_SceneWorldTeamBoss", WZUIContainer)
        if conRewardBox then
            conRewardBox:setRelativePosition(GlobalMethod:ccp(1 - self.m_tSysConfig["stage" .. i]/100, 1.9))
        end
    end
end


--@brief    显示我的排名和伤害
function SceneWorldTeamBoss:showMyRankAndHurt()
    -- body
    local ftxtMyRank = GetElement(self.m_root, "ftxtMyRank_SceneWorldTeamBoss", WZUIFreeTextBox)
    local ftxtMyHurt = GetElement(self.m_root, "ftxtMyHurt_SceneWorldTeamBoss", WZUIFreeTextBox)
    local sFormat = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T>]]
    if ftxtMyHurt then
        if self.bossRoomInfo.myRank == -1 then
            ftxtMyRank:setShowText(string.format(sFormat, LocalStrings.PLAYER_RANK_SCENEWORLDBOSS, LocalStrings.COMMUNITY_COMPETE_TEXT43))
            ftxtMyHurt:setShowText(string.format(sFormat, LocalStrings.TEAMBOSS_TEXT16, LocalStrings.COMMUNITY_COMPETE_TEXT43))
        else
            local myPercent = string.format("%0.2f", (self.bossRoomInfo.hurt/self.bossRoomInfo.bossBloodMax*100))
            myPercent = self.bossRoomInfo.hurt .. "(" .. myPercent .. "%" .. ")"
            ftxtMyRank:setShowText(string.format(sFormat, LocalStrings.PLAYER_RANK_SCENEWORLDBOSS, tostring(self.bossRoomInfo.myRank)))
            ftxtMyHurt:setShowText(string.format(sFormat, LocalStrings.TEAMBOSS_TEXT16, myPercent))
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function SceneWorldTeamBoss:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtCDGold_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCDDiamond_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"ftxtGoldCost_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.9)
    GetElement(self.m_root,"ftxtDiaCost_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.9)

    GetElement(self.m_root,"txtCheck1_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckSel1_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.7)
end

function SceneWorldTeamBoss:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtCDGold_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCDDiamond_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"ftxtGoldCost_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.7)
    GetElement(self.m_root,"ftxtDiaCost_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.7)

    GetElement(self.m_root,"txtFightAdd_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.7)

    local txtBtnFindRoom1 = GetElement(self.m_root,"txtBtnFindRoom1_SceneWorldTeamBoss",WZUILabelTTF)
    txtBtnFindRoom1:setScale(0.8)
    txtBtnFindRoom1:setDimensions(GlobalMethod:CCSize(150))
    local txtBtnFindRoom2 = GetElement(self.m_root,"txtBtnFindRoom2_SceneWorldTeamBoss",WZUILabelTTF)
    txtBtnFindRoom2:setScale(0.8)
    txtBtnFindRoom2:setDimensions(GlobalMethod:CCSize(150))
    local txtBtnCreate1 = GetElement(self.m_root,"txtBtnCreate1_SceneWorldTeamBoss",WZUILabelTTF)
    txtBtnCreate1:setScale(0.8)
    txtBtnCreate1:setDimensions(GlobalMethod:CCSize(150))
    local txtBtnCreate2 = GetElement(self.m_root,"txtBtnCreate2_SceneWorldTeamBoss",WZUILabelTTF)
    txtBtnCreate2:setScale(0.8)
    txtBtnCreate2:setDimensions(GlobalMethod:CCSize(150))
    local txtQuickBtnDesc = GetElement(self.m_root,"txtQuickBtnDesc_SceneWorldTeamBoss",WZUILabelTTF)
    txtQuickBtnDesc:setScale(0.8)
    txtQuickBtnDesc:setDimensions(GlobalMethod:CCSize(150))
end

function SceneWorldTeamBoss:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtCDGold_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCDDiamond_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"ftxtGoldCost_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.7)
    GetElement(self.m_root,"ftxtDiaCost_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.7)

    GetElement(self.m_root,"txtCheck2_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.67)
    GetElement(self.m_root,"txtCheckSel2_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.67)

    GetElement(self.m_root,"txtFightAdd_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.7)

    local txtBtnFindRoom1 = GetElement(self.m_root,"txtBtnFindRoom1_SceneWorldTeamBoss",WZUILabelTTF)
    txtBtnFindRoom1:setScale(0.8)
    txtBtnFindRoom1:setDimensions(GlobalMethod:CCSize(150))
    local txtBtnFindRoom2 = GetElement(self.m_root,"txtBtnFindRoom2_SceneWorldTeamBoss",WZUILabelTTF)
    txtBtnFindRoom2:setScale(0.8)
    txtBtnFindRoom2:setDimensions(GlobalMethod:CCSize(150))
    local txtBtnCreate1 = GetElement(self.m_root,"txtBtnCreate1_SceneWorldTeamBoss",WZUILabelTTF)
    txtBtnCreate1:setScale(0.8)
    txtBtnCreate1:setDimensions(GlobalMethod:CCSize(150))
    local txtBtnCreate2 = GetElement(self.m_root,"txtBtnCreate2_SceneWorldTeamBoss",WZUILabelTTF)
    txtBtnCreate2:setScale(0.8)
    txtBtnCreate2:setDimensions(GlobalMethod:CCSize(150))
    local txtQuickBtnDesc = GetElement(self.m_root,"txtQuickBtnDesc_SceneWorldTeamBoss",WZUILabelTTF)
    txtQuickBtnDesc:setScale(0.8)
    txtQuickBtnDesc:setDimensions(GlobalMethod:CCSize(150))
end

function SceneWorldTeamBoss:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtCDGold_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCDDiamond_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"ftxtGoldCost_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.7)
    GetElement(self.m_root,"ftxtDiaCost_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.7)

    GetElement(self.m_root,"txtCheck1_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCheckSel1_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCheck2_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCheckSel2_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCheck3_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCheckSel3_SceneWorldTeamBoss",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtFightAdd_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.7)

    local txtBtnFindRoom1 = GetElement(self.m_root,"txtBtnFindRoom1_SceneWorldTeamBoss",WZUILabelTTF)
    txtBtnFindRoom1:setScale(0.8)
    txtBtnFindRoom1:setDimensions(GlobalMethod:CCSize(150))
    local txtBtnFindRoom2 = GetElement(self.m_root,"txtBtnFindRoom2_SceneWorldTeamBoss",WZUILabelTTF)
    txtBtnFindRoom2:setScale(0.8)
    txtBtnFindRoom2:setDimensions(GlobalMethod:CCSize(150))
    local txtBtnCreate1 = GetElement(self.m_root,"txtBtnCreate1_SceneWorldTeamBoss",WZUILabelTTF)
    txtBtnCreate1:setScale(0.8)
    txtBtnCreate1:setDimensions(GlobalMethod:CCSize(150))
    local txtBtnCreate2 = GetElement(self.m_root,"txtBtnCreate2_SceneWorldTeamBoss",WZUILabelTTF)
    txtBtnCreate2:setScale(0.8)
    txtBtnCreate2:setDimensions(GlobalMethod:CCSize(150))
    local txtQuickBtnDesc = GetElement(self.m_root,"txtQuickBtnDesc_SceneWorldTeamBoss",WZUILabelTTF)
    txtQuickBtnDesc:setScale(0.8)
    txtQuickBtnDesc:setDimensions(GlobalMethod:CCSize(150))
end

function SceneWorldTeamBoss:_adaptLanguage_th(  )
    GetElement(self.m_root,"ftxtGoldCost_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.6)
    GetElement(self.m_root,"ftxtDiaCost_SceneWorldTeamBoss",WZUIFreeTextBox):setScale(0.6)
end


-------------------------------------语言适配End----------------------------------------
