--SceneHall.lua
--@brief	SceneHall的UI模块
--@date		2015-6-11
--@author	binshao 2015-6-11
--@note		游戏大厅模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneHall:onEnter(element)
    WZLog("SceneHall:onEnter")

	self.m_root = element
    AdaptLanguage(self)
    ChangeChatChannel(Chat_Channel_Hall)
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    
    self:_addTop()
	CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
    CacheCenter:registerUpdateDecorationObserver(self)
   
    WZLog("------------------------5555---------------updatePlayer")
    self:_updatePlayerInfo()

    local isEndTeach20, teachStep20 = TeachGroup1:isTeachFinish(20)
    if isEndTeach20 ~= true and teachStep20 >= 5 then
        TeachGroup1:startGroup({20,6,GlobalGame.g_tWndBottomBarObj.m_root})
    else
        TeachGroup1:startGroup({20,3,self.m_root})
    end
    self:_initCheckBoxMatchIndex()

    GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change",'state_hall')
    
    WndChat:addChatWindowToCurScene()
    SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)
    g_SceneHallCallback = self.onReturn
end

function SceneHall:onEnterTransitionDidFinish()
    WZLog("SceneHall:onEnterTransitionDidFinish")
--    ProtocolProcessorSceneHall:send_ROOM_GetTournamentAim(0)
    ProtocolProcessorSceneHall:send_ROOM_GetRoomList(self.matchType)

    -- 刚计入的时候播放人物的背景动画
    self:playRoleAni()

    -- 如果有竞技等级有变化，播放升级动画
    WndAthUpgrade:Show()

	if WndGangsterInn.m_bShouldClose == true then
		WndGangsterInn.m_bShouldClose = false
		MsgBoxManager:showTipBox(LocalStrings.INN12)
	end

    --延时显示成就特效
    ShowDelayAchie()
end


function SceneHall:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_jingjidating.png",SceneHall,SceneHall.onReturn,true,true,true,"SceneHall")
    self.topCell = {cell = cell, tcell = tcell}
end


--@brief 关闭界面
function SceneHall:onReturn()
    WZLog("SceneHall:onReturn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    g_areaIndex = 1
    --local scene = SceneCity:createElement()
    --replaceScene(scene)

	ScenePvp:showScene()
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneHall:onExit(element)
    WZLog("SceneHall:onExit")
    CacheCenter:unregisterUpateDecorationObserver(self)
    CacheCenter:unregisterUpatePlayerInfoObserver(self)
    CacheCenter:unregisterUpatePlayerItemObserver(self)

    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","SceneHall")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","SceneHall")

	self:_unInit()
end

--@brief	创建房间
function SceneHall:createRoom(roomName, passWord)
	WZLog("SceneHall:createRoom ")
    self:createLoadingBox()
    local startMode = 1
    if self.m_nRoomChannel == 10 then
        startMode = 2
    end

    ProtocolProcessorSceneHall:send_ROOM_CreateRoom(roomName, 1, self.personCnt, passWord, startMode,self.m_nRoomChannel,0)
end

-- 查看说明
function SceneHall:onCheckDesc()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.ATH_DESC12)
end

--@brief	查找回调
function SceneHall:onSearchButtonClick(element)
	WZLog("SceneHall:onSearchButtonClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wndFindRoom = WndFindRoom:createElement()
    if wndFindRoom ~= nil then
        WindowManager:addWindow(wndFindRoom,WndFindRoom,true,nil,nil)
        WndFindRoom:setFindBtnCallBack(self.searchRoom,self)
    end
end

function SceneHall:onPet()
    WZLog("-------------------click pet--------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local petInfo = CacheCenter:getPlayerInfo().petInfo
    if not petInfo then return end
    local conPet = GetElement(self.m_root,"conPet_SceneHall",WZUIContainer)
    local con = GetElement(self.m_root,"conTips_SceneHall",WZUIContainer)
    WndTips:show(conPet,con,13,petInfo,GlobalMethod:ccp(400,-20))
end

--@brief	查找房间
--@param 	入参与创建房间的协议发送方法参数相同
--@return	true:关闭WndEditBox，false:反之
--@note     调用这个函数发送查找房间协议,起到代理的作用
function SceneHall:searchRoom(roomId,password)
	WZLog("SceneHall:searchRoom =",self.matchType)
    WZLog("room id",roomId)
	local id = tonumber(roomId)
	if id == nil then
        --WZUIEditBox:luaTo(GetElement(WndEditBox.m_root,"editRoomId_WndEditBox")):setText("")
        MsgBoxManager:showTipBox(LocalStrings.ROOM_FIND_TIPS)
		return false
    else
		--假房间直接提示，返回
		for k,v in pairs(self.roomData) do
			--WZLog("查找假房间", tostring(v.roomId), string.format("%04d",id))
			if tostring(v.roomId) == string.format("%04d",id) and v.fake == true then
				MsgBoxManager:showTipBox(LocalStrings.FAKEROOM)
				return
			end
		end

    	if password == nil  then 
    		WZLog("SceneHall:searchRoom password == nil ")
			ProtocolProcessorSceneHall:send_ROOM_SelectRoom(id,self.matchType,"-1")
		else
			WZLog("SceneHall:searchRoom password ~= nil ")
			if password == "" then 
				ProtocolProcessorSceneHall:send_ROOM_SelectRoom(id,self.matchType,"-1")
			else 
				ProtocolProcessorSceneHall:send_ROOM_SelectRoom(id,self.matchType,password) 
			end 
		end
        self:createLoadingBox()
		return true
	end
end

--@brief	输入房间密码
--@param 	入参与创建房间的协议发送方法参数相同
--@note     当房间需要密码时，弹出窗口
function SceneHall:enterRoomPassword()
	WZLog("SceneHall:enterRoomPassword")
	local element = WndEditBox:createElement()
    WZLog("WndEditBox:createElement", element)
    if nil ~= element then
    	local tNewObj= element:getLuaObjectIndex()
        WndEditBox:setData(LocalStrings.ROOM_PASSWORD,LocalStrings.CLICK_TO_INPUT_PASSWORD)
        WndEditBox:setEditType(2)
        WndEditBox:setOkCallBack(self.enterRoomPasswordOk,SceneHall)
        WindowManager:addWindow(element, WndEditBox,true,nil,nil)
    end
end

--@brief	输入房间密码完毕
--@note     当房间需要密码时，弹出窗口
function SceneHall:enterRoomPasswordOk(password)
	WZLog("SceneHall:enterRoomPassword")
	if password ~= self.m_tSearchRoomData.password then
		MsgBoxManager:showTipBox(LocalStrings.PASSWORD_NOT_MATCH)
		return false
	else
		self:searchRoom(self.m_tSearchRoomData.roomId,self.m_tSearchRoomData.password)
		return true
	end
end

function SceneHall:scheduleReplace(element)
    element:disableSchedule()
    local sceneCity = SceneCity:createElement()
    if sceneCity ~= nil then 
        replaceScene(sceneCity)
    end 
end

-- 快速游戏按钮点击回调
function SceneHall:onFastGameButtonClick(element)
	WZLog("SceneHall:onFastGameButtonClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --竞技开放时间判断
    function split(s, delim)
        if type(delim) ~= "string" or string.len(delim) <= 0 then
            return
        end
        local start = 1
        local t = {}
        while true do
            local pos = string.find (s, delim, start, true) -- plain find
                if not pos then
                break
            end
            table.insert (t, string.sub (s, start, pos - 1))
            start = pos + string.len (delim)
        end
        table.insert (t, string.sub (s, start))
        return t
    end
    if CacheCenter:getGameParam()["arenaOpenTime"] then
        local tabArenaOpenTime = json.decode(CacheCenter:getGameParam()["arenaOpenTime"])
        local tabOpenDay = split( tabArenaOpenTime["openDay"],",")
        if tabArenaOpenTime then
            local startTime = tabArenaOpenTime["startTime"]
            local endTime = tabArenaOpenTime["endTime"]
            local curTime = SystemTime:getTimeTabelByServerTimestamp(SystemTime:getServerTime())
            local h1,m1 = string.match(startTime,"(%d+):(%d+)")
            local h2,m2 = string.match(endTime,"(%d+):(%d+)")
            local time1 = curTime["hour"] * 3600 + curTime["min"] * 60
            local time2 = h1 * 3600 + m1 * 60
            local time3 = h2 * 3600 + m2 * 60
            for k,v in ipairs(tabOpenDay) do
                if tonumber(tabOpenDay[k]) == 7 then
                    tabOpenDay[k] = 0
                end
            end
            local inTime = false
            local wday = tonumber(curTime["wday"] - 1)
            for k,v in ipairs(tabOpenDay) do
                if tonumber(v) == wday then
                    inTime = true
                end
            end
            local isout = false
            if inTime == true and time1 > time2 and time1 < time3 then
                isout = true                    
            end
            local week = nil
            if isout == false then
                if inTime and time1 < time2 then
                    if week == nil then
                        week = wday
                    end
                elseif inTime and time1 > time3 or not inTime then
                    for i = 1, 7 do
                        for k,v in ipairs(tabOpenDay) do
                            if (wday + i) % 7 == tonumber(v) then
                                if week == nil then
                                    week = tonumber(v)
                                end
                            end
                        end
                    end
                end
                MsgBoxManager:showTipBox(string.format(LocalStrings.THE_NEXT_OPENING_TIME,LocalStrings.DAY_OF_THE_WEEK[week+1],startTime,endTime))
                element:enableSchedule("scheduleReplace",1)
                return
            end
        end
    end
    
    if self.m_nCount == 0 then
        self.m_nCount = 1
        element:enableSchedule("scheduleCalculate",1)
    else
        return
    end
    if self.matchType == 1 then
        local con = GetElement(self.m_root,"conMark_SceneHall",WZUIContainer)
        con:setVisible(true)
        local ttf = GetElement(self.m_root,"lafTime_SceneHall",WZUILabelAtlasFont)
        ttf:setText(self.matchTime)
        self:updateDesc2()
        con:enableSchedule("_scheduleMatchTime",1)
        self.topCell.tcell:setShieldClick(true)
        self.matchState = true
        WZLog("----------------shield top-----------------1")
    elseif self.matchType == 2 then
        self:createLoadingBox()
    end
    WZTempLog("--------------channle--------------",self.matchType)
    ProtocolProcessorSceneHall:send_ROOM_QuickGame(1,1,0)
end

function SceneHall:scheduleCalculate(element)
    WZLog("SceneHall:scheduleCalculate")
    element:disableSchedule()
    self.m_nCount = 0
end

-- 取消匹配
function SceneHall:onCancelFight()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:createLoadingBox()
    WZLog("----------------cancel fight-----------------")
    ProtocolProcessorSceneHall:send_ROOM_EndPair(0)
end

-- 匹配结果
function SceneHall:matchResulet()
    if not self.m_root then return end
    self:closeLoadingBox()
    local con = GetElement(self.m_root,"conMark_SceneHall",WZUIContainer)
    con:setVisible(false)
    con:disableSchedule()
    self.matchTime = 1
    local ttfLong = GetElement(self.m_root,"txtTimeLong_SceneHall",WZUILabelTTF)
    ttfLong:setVisible(false)
    self.topCell.tcell:setShieldClick(false)
    self.matchState = false
    WZLog("----------------shield top-----------------2")
end


-- 匹配结果
function SceneHall:matchFail()
    WZLog("SceneHall:matchFail")
    if not self.m_root then return end
    self:closeLoadingBox()
    local con = GetElement(self.m_root,"conMark_SceneHall",WZUIContainer)
    con:setVisible(false)
    con:disableSchedule()
    self.matchTime = 1
    local ttfLong = GetElement(self.m_root,"txtTimeLong_SceneHall",WZUILabelTTF)
    ttfLong:setVisible(false)
    self.topCell.tcell:setShieldClick(false)
    self.matchState = false
    MsgBoxManager:showTipBox(LocalStrings.MATCHFAIL)
end

-- 匹配倒计时
function SceneHall:_scheduleMatchTime(element,time)
    self.matchTime = self.matchTime + 1
    local ttf = GetElement(self.m_root,"lafTime_SceneHall",WZUILabelAtlasFont)
    ttf:setText(self.matchTime)
    if self.matchTime >= 60 then
        element:disableSchedule()
        MsgBoxManager:showConfirmBox(LocalStrings.MATCHES_TIMEOUT, self, self.matchResulet, MSGBOXLEVEL_NORMAL, nil,true)
    end
    if self.matchTime%5 == 0 then
        self:updateDesc2()
    end
    if self.matchTime == 20 then
        local ttfLong = GetElement(self.m_root,"txtTimeLong_SceneHall",WZUILabelTTF)
        ttfLong:setVisible(true)
    end
end

-- 更新小提示
function SceneHall:updateDesc2()
    local ttfDesc = GetElement(self.m_root,"ttfMatchDesc_SceneHall",WZUILabelTTF)
    local nIndex = math.random(1, #LocalStrings.HALL_DESC2)
    if ttfDesc:getText() == LocalStrings.HALL_DESC2[nIndex] then
        nIndex = nIndex+1
        if nIndex > #LocalStrings.HALL_DESC2 then nIndex = 1 end
    end
    ttfDesc:setText(LocalStrings.TIPS..":"..LocalStrings.HALL_DESC2[nIndex])
end

-- 创建一个玩家形象
function SceneHall:_initPlayerDress()
    WZLog("-----------------_initPlayerDress--------------starting")
    local sex = CacheCenter:getPlayerInfo().sex
    local tEquip = CacheCenter:getEquipmentList()
    local conP = GetElement(self.m_root,"conPlayer_SceneHall",WZUIContainer)
    local childNode = conP:getChildByTag(250)
    if childNode then
        childNode:removeFromParentAndCleanup(true)
    end
    local head,body = CacheCenter:getHeadAndBodyColor()
    local conPlayer = CreatePlayerFigure(sex, tEquip,nil,nil,nil,nil,nil,nil,nil,nil,head,body)
    conP:addChild(conPlayer:getAnimNode(),0,250)
    WZLog("----------create conP---------------",conPlayer,conPlayer:getAnimNode())
    self.m_root:disableSchedule()
end

function SceneHall:_getConPlayer()
    local conP = GetElement(self.m_root,"conPlayer_SceneHall",WZUIContainer)
    local node = conP:getChildByTag(250)
    WZLog("----------get conP---------------",node)
    if node then
        local con = WZUIElement:luaTo(node)
        local conPlayer = con:getLuaObjectIndex()
        WZLog("----------get conP---------------1",conPlayer)
        return conPlayer
    end
    return nil
end


function SceneHall:_updatePlayerInfo()
    local tInfo = CacheCenter:getPlayerInfo()
    local tOther = CacheCenter:getOtherItemList()
    WZLog("-----------------------5555-------------------------",self.m_root,tInfo)
	if self.m_root and tInfo then
        self:setPlayerData(tInfo)

        WZLog("-----------------_initPlayerDress--------------start")
        self.m_root:enableSchedule("_initPlayerDress",0.1)

        local txtTitle = GetElement(self.m_root,"txtPlayerTitle_SceneHall",WZUILabelTTF)
        local conTitle = GetElement(self.m_root, "conTitle_SceneHall", WZUIContainer)
        local nScale = 1 
        local tempPoint = GlobalMethod:ccp(0.5,2.3)
        local sTitleContent = self.m_tPlayer.title
        if self.m_tPlayer.title and self.m_tPlayer.title ~= "" then
            local sTitleName = SplitStringWithSeparator(sTitleContent,"&")
            if sTitleName[2] ~= nil and sTitleName[2] ~= "" then
                GetElement(self.m_root, "conTitleName_SceneHall", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.45))
                tempPoint = GlobalMethod:ccp(0.5,2.08)
                nScale = 0.85
                txtTitle:setFontSize(20)
            else
                GetElement(self.m_root, "conTitleName_SceneHall", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
                txtTitle:setFontSize(22)
            end
        else
            txtTitle:setFontSize(22)
            GetElement(self.m_root, "conTitleName_SceneHall", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
            sTitleContent = LocalStrings.SHOP_NOCHENGHAO
        end
        CreateDesiSpine(conTitle, txtTitle, sTitleContent, tempPoint, true, nScale)

        local txtName = GetElement(self.m_root, "txtPlayerLevel_SceneHall", WZUIFreeTextBox)
        txtName:setShowText(string.format(LocalStrings.SHOP_NAME_AND_LEVEL1,self.m_tPlayer.level,self.m_tPlayer.name))

        local hallInfo = GDatatab_integral["id_"..self.m_tPlayer.tournamentLevel]
        local txtExp = GetElement(self.m_root,"txtExp_SceneHall", WZUILabelTTF)
        local curExp,AllExp = self.m_tPlayer.tournamentIntegral,hallInfo.upgrade_integral
        txtExp:setText(curExp.."/"..AllExp)

        local proExp =  GetElement(self.m_root,"processLv_SceneHall",WZUIProgress)
        proExp:setPercentage(curExp/AllExp*100)

        local hallLv = GetElement(self.m_root,"txtAthLv_SceneHall",WZUILabelAtlasFont)
        local LvNum = (self.m_tPlayer.tournamentLevel-1)%10+1
        hallLv:setText(LvNum)

        local lvDi =  GetElement(self.m_root,"imgAthLevel_SceneHall", WZUIImage)
        lvDi:setFile("ui/common/"..hallInfo.iocn..".png")

		GetElement(self.m_root,"txtDuan_SceneHall",WZUILabelTTF):setText(hallInfo.dan)
    end

    -- 宠物
    local conPet = GetElement(self.m_root,"conPet_SceneHall",WZUIContainer)
    WZLog("-------------------create pet-------------------",tInfo.petInfo)
    if tInfo.petInfo then
        local aniPet,par =  CreatePetAni(conPet,tInfo.petInfo.itemId,tInfo.petInfo.animation,tInfo.petInfo.advancedLevel, tInfo.petInfo.petSkinItemId)
        aniPet:getAnimNode():setScale(0.8)
        if par then par:setScale(0.8) end
    else
        conPet:removeAllChildrenWithCleanup(true)
    end

    local imgWeapon = GetElement(self.m_root,"imgWeapon_SceneHall", WZUIImage)
    local spineWeapon = GetElement(self.m_root,"spineWeapon_SceneHall", WZUISpine)
    setPlayerCurWeapon(imgWeapon,spineWeapon)

    -- 商店红点
    --local imgRed1 = GetElement(self.m_root,"imgAthRed_SceneHall",WZUIImage)
    local imgRed2 = GetElement(self.m_root,"imgAthRed1_SceneHall",WZUIImage)
    local red1,red2 = self:_checkAthShopRedPoint()
    WZLog("------------change red----------------red",red1,red2)
    --imgRed1:setVisible(red1)
    imgRed2:setVisible(red2)
end

--@brief	房间列表项点击回调
--@param 	element:cellRoomItem的引用
--@note		由cellRoomItem回调
function SceneHall:onRoomListClick(element)
	assert(element.m_tData.roomId,"room id is nil")
	--假房间直接提示，返回
	if element.m_tData.fake == true then
		MsgBoxManager:showTipBox(LocalStrings.FAKEROOM)
		return
	end

	if element.m_tData.battleStatus ~= 0 then --战斗中
		MsgBoxManager:showTipBox(LocalStrings.ROOM_BATTLEING)
	elseif element.m_tData.playerNum == element.m_tData.maxNum then --房间已满
		MsgBoxManager:showTipBox(LocalStrings.ROOM_FULL)
	else
		if element.m_tData.passWord ~= "-1" then
			--需要输入密码
        	self.m_tSearchRoomData = {roomId=element.m_tData.roomId, password=element.m_tData.passWord}
        	self:enterRoomPassword()
        else 
        	self:searchRoom(element.m_tData.roomId)
    	end
	end
end

--@brief	在线玩家列表项点击回调
--@param 	element:触发事件的控件引用
function SceneHall:onPlayerListClick(element)
	WZLog("SceneHall:onPlayerListClick")
    if element.m_tData.id == CacheCenter:getPlayerInfo().id then
        WndCheckOther:show(CacheCenter:getPlayerInfo().id)
    else
    	WndCheckOther:show(element.m_tData.id)
    end
end

--@brief	更新房间列表
function SceneHall:updateRoomList(emptyRoomId)
    if emptyRoomId then
        GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change",'state_room_arean_update',emptyRoomId)
    end
    self:initRoomListOnce()
end

--@brief	更新玩家着装
function SceneHall:updatePlayerDress()
	WZLog("SceneHall:updatePlayerDress")
	
	if self.m_tEquipmentData == nil then
		WZLog("SceneHall:updatePlayerDress m_tEquipmentData is nil")
		return
	end
	
	local tEquip = {}
	--遍历每个装备
	for k,equip in pairs(self.m_tEquipmentData.animationIndexCode) do
		if equip ~= "" then
			table.insert(tEquip,equip)
		end
	end

	WZUIContainer:luaTo(GetElement(self.m_root,"conPlayer_SceneHall")):removeAllChildrenWithCleanup(true)
	local con,equipArmature = CreataAPlayerAnimation(CacheCenter:getPlayerInfo().sex, tEquip, nil,{proficiency=self.m_tEquipmentData.m_proficiency[g_tEquipmentIndex.EQUIP_WEAPON],level=self.m_tEquipmentData.level[g_tEquipmentIndex.EQUIP_WEAPON],nSkillType = self.m_tEquipmentData.skillType[1]},nil,{nRankLevel= self.m_tEquipmentData.nQualifyingLevel ,bVipMark=GlobalGame.g_tPlayerInfo.nVipMark,nVipLevel=CacheCenter:getPlayerInfo().vipLevel ,bDoubleExp=GlobalGame.g_tPlayerInfo.bDoubleCard})
	GetElement(self.m_root,"conPlayer_SceneHall", WZUIContainer):addChild(con)
	if equipArmature~= nil then
		equipArmature:play(0)
	end
end

--@brief 	房间状态选择
function SceneHall:onRoomTypeClick( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:updateRoomList()
end

--@brief 	查看段位按钮
function SceneHall:onEventSection( element )
    WZLog("------------888-----------------------88")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local leftCon = GetElement(self.m_root,"conPlayerInfo_SceneHall",WZUIContainer)
	WndTips:show(element,leftCon,4,CacheCenter:getPlayerInfo(),GlobalMethod:ccp(335,100))
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 点击创建房间回调
function SceneHall:onCreateRoomOK(element)
    WZLog("SceneHall:onCreateRoomOK one")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --竞技开放时间判断
    function split(s, delim)
        if type(delim) ~= "string" or string.len(delim) <= 0 then
            return
        end
        local start = 1
        local t = {}
        while true do
            local pos = string.find (s, delim, start, true) -- plain find
                if not pos then
                break
            end
            table.insert (t, string.sub (s, start, pos - 1))
            start = pos + string.len (delim)
        end
        table.insert (t, string.sub (s, start))
        return t
    end
    if CacheCenter:getGameParam()["arenaOpenTime"] then
        local tabArenaOpenTime = json.decode(CacheCenter:getGameParam()["arenaOpenTime"])
        local tabOpenDay = split( tabArenaOpenTime["openDay"],",")
        if tabArenaOpenTime then
            local startTime = tabArenaOpenTime["startTime"]
            local endTime = tabArenaOpenTime["endTime"]
            local curTime = SystemTime:getTimeTabelByServerTimestamp(SystemTime:getServerTime())
            local h1,m1 = string.match(startTime,"(%d+):(%d+)")
            local h2,m2 = string.match(endTime,"(%d+):(%d+)")
            local time1 = curTime["hour"] * 3600 + curTime["min"] * 60
            local time2 = h1 * 3600 + m1 * 60
            local time3 = h2 * 3600 + m2 * 60
            for k,v in ipairs(tabOpenDay) do
                if tonumber(tabOpenDay[k]) == 7 then
                    tabOpenDay[k] = 0
                end
            end
            local inTime = false
            local wday = tonumber(curTime["wday"] - 1)
            for k,v in ipairs(tabOpenDay) do
                if tonumber(v) == wday then
                    inTime = true
                end
            end
            local isout = false
            if inTime == true and time1 > time2 and time1 < time3 then
                isout = true                    
            end
            local week = nil
            if isout == false then
                if inTime and time1 < time2 then
                    if week == nil then
                        week = wday
                    end
                elseif inTime and time1 > time3 or not inTime then
                    for i = 1, 7 do
                        for k,v in ipairs(tabOpenDay) do
                            if (wday + i) % 7 == tonumber(v) then
                                if week == nil then
                                    week = tonumber(v)
                                end
                            end
                        end
                    end
                end
                MsgBoxManager:showTipBox(string.format(LocalStrings.THE_NEXT_OPENING_TIME,LocalStrings.DAY_OF_THE_WEEK[week+1],startTime,endTime))
                element:enableSchedule("scheduleReplace",1)
                return
            end
        end
    end

    self.personCnt = 2
    self.m_nRoomChannel = 1
    local name = LocalStrings.ROOM_NAME_RANDOM
    local random = math.random(#name)
    self:createRoom(name[random],"-1")
end



-- 文字初始化
function SceneHall:_setUIStaticText()
    --描边字
    WZLog("SceneHall:_setUIStaticText")
    local txtPrimar1 = self.m_root:getChildElement("txt_primar1_SceneHall")
    if txtPrimar1 ~= nil then
        WZUILabelTTF:luaTo(txtPrimar1):setText(LocalStrings.PRIMARY)
    end

    local txtPrimar2 = self.m_root:getChildElement("txt_primar2_SceneHall")
    if txtPrimar2 ~= nil then
        WZUILabelTTF:luaTo(txtPrimar2):setText(LocalStrings.PRIMARY)
    end

    local txtAdvance1 = self.m_root:getChildElement("txt_advance1_SceneHall")
    if txtAdvance1 ~= nil then
        WZUILabelTTF:luaTo(txtAdvance1):setText(LocalStrings.ADVANCE)
    end

    local txtAdvance2 = self.m_root:getChildElement("txt_advance2_SceneHall")
    if txtAdvance2 ~= nil then
        WZUILabelTTF:luaTo(txtAdvance2):setText(LocalStrings.ADVANCE)
    end
end

--@brief 	奖励查询按钮
function SceneHall:onReward( element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndWelfare:showInterface(1, g_tGameActivityTypes.ACTIVITY_TARGETREWARD_2, tMsg)
    --local wnd =  WndAthReward:createElement()
    --WindowManager:addWindow(wnd, WndAthReward,true,nil,nil)
end

-- 查看录像
function SceneHall:onVideo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wnd =  WndAthVideo:createElement()
    WindowManager:addWindow(wnd, WndAthVideo,true,nil,nil)
end

--@brief 	竞技商店按钮
function SceneHall:onShop(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:_cancelAthShopRedPoint()
    local wnd =  WndAthShop:createElement()
    WindowManager:addWindow(wnd, WndAthShop,true,true,nil)
end


--@brief 	聊天按钮
function SceneHall:onEventChat(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndChat:showChatWindowForFightingByOrder(nil)
end
-------------------------------------私有方法模块End----------------------------------------


-- 更新选择房间人数，当目前除以混战的战斗类型，那么人数是不可点击的
function SceneHall:_updateCheckBoxRoomNum()
    local checkG = GetElement(self.m_root,"checkGroupRoomNum_SceneHall",WZUICheckBoxGroup)
    checkG:setVisible(true)
    checkG:setCheckIndex(self.personCnt-1)
end


-- 初始化多语言版本
function SceneHall:_initRoomMoreLanguage()
    -- 房间名字随机出现
    local name = LocalStrings.ROOM_NAME_RANDOM
    local random = math.random(#name)
    local editName = GetElement(self.m_root,"editRoomName_SceneHall",WZUIEditBox)
    editName:setPlaceHolder(name[random])

    local editPass = GetElement(self.m_root,"editRoomPassword_SceneHall",WZUIEditBox)
    editPass:setPlaceHolder(LocalStrings.CLICK_INPUT_PASSWORD)
end


-- 点击创建房间回调
-- function SceneHall:onCreateRoomOK(element)
--     WZLog("SceneHall:onCreateRoomOK one")
--     SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
--     TeachGroup1:endTeachStep({20,4})
--     local roomName = self:_getRoomName()
--     local roomPass = self:_getRoomPassword()

--     -- 判断房间的密码和账号是否符合要求
--     if roomName ~= "" then
--         local roomNameLen = 0
--         local isSpace = string.match(roomName," ")
--         if isSpace  then  roomNameLen = ChineseStringLen(isSpace) end

--         local language = ProjConfig.LANGUAGE
--         if "en" ~= language and "th" ~= language and "vn" ~= language and "pt" ~= language 
--             and "tr" ~= language and "es" ~= language then
--             if roomNameLen > 0 then
--                 MsgBoxManager:showTipBox(LocalStrings.ROOM_NAME_ERROR2)
--                 return
--             end

--             local nameLength = ChineseStringLen(roomName)
--             if nameLength > 8 then
--                 MsgBoxManager:showTipBox(LocalStrings.ROOM_NAME_ERROR)
--                 return
--             end
--         end
--     end

--     if roomPass ~= "-1" then
--         if "en" ~= language then
--             local passLength = ChineseStringLen(roomPass)
--             local matchPass = string.match(roomPass, "%w+")
--             local matchLength =0
--             if matchPass then matchLength = ChineseStringLen(matchPass) end
--             if passLength ~= matchLength then
--                 MsgBoxManager:showTipBox(LocalStrings.ROOM_PASS_ERROR)
--                 return
--             end
--             if matchLength > 8 then
--                 MsgBoxManager:showTipBox(LocalStrings.ROOM_PASS_ERROR2)
--                 return
--             end
--         end
--     end

--     WZLog("-----------create info-------------------",roomName,roomPass,self.matchMode,self.personCnt)
--     if self.matchMode == 3 then self.personCnt = 6 end
--     --self:createRoom(roomName,1,self.personCnt,roomPass,self.matchMode)
--     self:createRoom(roomName,1,2,roomPass,1)
-- end

-- 取消创建房间
function SceneHall:onCloseClick(element)
    WZLog("SceneHall:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local conList = GetElement(self.m_root,"conRoomList_SceneHall",WZUIContainer)
    local conRoom = GetElement(self.m_root,"conCreateRoom_SceneHall",WZUIContainer)
    conList:setVisible(true)
    conRoom:setVisible(false)
end

-- 播放角色等待动画
function SceneHall:playRoleAni()
    local conPlayer = self:_getConPlayer()
    if conPlayer and conPlayer:isCurrentAnimationDone() then
        conPlayer:play("wait0", true)
    end
end

-- 点击角色回调
function SceneHall:onClickRole()
    local conPlayer = self:_getConPlayer()
    if conPlayer then conPlayer:play(g_tRoleAnitionName[2], false) end
    self.m_root:enableSchedule("judgeAniFinish",0)
end

function SceneHall:judgeAniFinish()
    local conPlayer = self:_getConPlayer()
    if conPlayer and conPlayer:isCurrentAnimationDone() then
        conPlayer:play("wait0",true)
        self.m_root:disableSchedule()
    end
end

-- 监听时装改变，改变玩家装扮
function SceneHall:updateDecorationData()
    local sex = CacheCenter:getPlayerInfo().sex
    local tEquip = CacheCenter:getEquipmentList()
    local conPlayer = self:_getConPlayer()
    if conPlayer then
        UpdatePlayerFigure(conPlayer:getAnimNode(),tEquip,sex)
    end
end

-- 监听玩家信息改变，改变玩家信息
function SceneHall:updatePlayerInfoData()
    self:_updatePlayerInfo()
end

function SceneHall:createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(10,self,self.closeLoadingBox)
    end
end

function SceneHall:closeLoadingBox()
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
end

-- 竞技排行回调
function SceneHall:onRank()
    WZLog("-------------onRank-----------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wnd = WndAthRank:createElement()
    WindowManager:addWindow(wnd, WndAthRank,true,true,nil)
end

-- 每日目标红点更新
function SceneHall:goalRedPointUpdate()
    -- 商店红点
    local imgRed2 = GetElement(self.m_root,"imgAthRed1_SceneHall",WZUIImage)
    local red1,red2 = self:_checkAthShopRedPoint()
    WZLog("--------------update goal red point-----------------",red1,red2)
    imgRed2:setVisible(red2)
end

-- 查看武器
function SceneHall:onWeapon()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local conEquip= GetElement(self.m_root,"conWeapon_SceneHall",WZUIContainer)
    local weaponInfo = {}
    local equip = CacheCenter:getEquipmentList()
    for k,v in pairs(equip) do
        if v.maintype == 4 and (v.subtype == 1 or v.subtype == 0) then
            weaponInfo = v
            break
        end
    end
    local con = GetElement(self.m_root,"conTips_SceneHall",WZUIContainer)
    WndItemInfo:showInfo(conEquip,con,1,weaponInfo,false,nil,false)
end

------------------------------------------------------------------------------------------------------------------------

-- 创建房间列表
function SceneHall:initRoomListOnce()
    local tab = GetElement(self.m_root,"tabRoomList_SceneHall",WZUITableContainer)
    tab:cleanTable()
    for i = 1, #self.roomData do
        local cell,tcell = CellRoomItem:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(self.roomData[i])
        tcell:setClickCallback(self.onRoomListClick,SceneHall)
        self:_saveCurCell(i,cell,tcell)
    end
end

-- 选择比赛类型，积分赛1，练习赛2
function SceneHall:onSelMatch(element,param1,param2,param3)
    local tag = param3 or element:getTag()
    if self.matchType == tag then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.matchType = tag
    g_areaIndex = tag
    self.roomPageIndex = 1
    self.tabFlag = false
    self.moveDirection = 1
    WZLog("SceneHall:onSelMatch",self.matchType,self.roomPageIndex)
    -- 更换比赛类型，重新获取比赛房间列表
    ProtocolProcessorSceneHall:send_ROOM_GetRoomList(self.matchType)
    self:_changeBtnDesc()
end

-- 初始化比赛类型的checkbox
function SceneHall:_initCheckBoxMatchIndex()
    WZLog("---------------g_areaIndex--------------",g_areaIndex)
    self.matchType = g_areaIndex
    for i = 1, 2 do
        local check = GetElement(self.m_root, "checkMatch"..i.."_SceneHall", WZUICheckBox)
        local index = g_areaIndex == i and 1 or 0
        check:setCheckIndex(index)
    end
    self:_changeBtnDesc()
end

-- 修改进入游戏按键的文字说明（快速开始，快速加入）
function SceneHall:_changeBtnDesc()
    local ttfBtn = GetElement(self.m_root,"txtQuickBtnDesc_SceneHall",WZUILabelTTF)
    if self.matchType == 1 then
        ttfBtn:setText(LocalStrings.QUICK_JOIN1)
        if ProjConfig.LANGUAGE == "pt" then
            ttfBtn:setScale(0.8)
        end
    elseif self.matchType == 2 then
        ttfBtn:setText(LocalStrings.QUICK_JOIN)
        if ProjConfig.LANGUAGE == "pt" then
            ttfBtn:setScale(0.8)
            ttfBtn:setDimensions(GlobalMethod:CCSize(150,0))
        end
    end

    -- 模式说明
    -- local desc = GetElement(self.m_root,"txtHallDesc_SceneHall",WZUILabelTTF)
    -- desc:setFontSize(16)
end

------------------------------------------语言适配Begin-----------------------------------------------
function SceneHall:_adaptLanguage_th()
    -- local ttfBtn = GetElement(self.m_root,"txtHallDesc_SceneHall",WZUILabelTTF)
    -- ttfBtn:setFontSize(18)

    -- local txt3 = GetElement(self.m_root,"txtRoomPassword_SceneHall",WZUILabelTTF)
    -- txt3:setRelativePosition(GlobalMethod:ccp(-0.05,0.5))

    local ttfMatchDesc = GetElement(self.m_root, "ttfMatchDesc_SceneHall", WZUILabelTTF)
    ttfMatchDesc:setScale(0.8)
    ttfMatchDesc:setDimensions(GlobalMethod:CCSize(400))
end

function SceneHall:_adaptLanguage_en()
    -- local txt3 = GetElement(self.m_root,"txtRoomPassword_SceneHall",WZUILabelTTF)
    -- txt3:setRelativePosition(GlobalMethod:ccp(-0.1,0.5))

    local ttfMatchDesc = GetElement(self.m_root, "ttfMatchDesc_SceneHall", WZUILabelTTF)
    ttfMatchDesc:setScale(0.8)
    ttfMatchDesc:setDimensions(GlobalMethod:CCSize(400))
    
    local txtQuickBtnDesc = GetElement(self.m_root,"txtQuickBtnDesc_SceneHall",WZUILabelTTF)
    txtQuickBtnDesc:setScale(0.9)
    txtQuickBtnDesc:setRelativePosition(GlobalMethod:ccp(0.47,0.5))
    
    GetElement(self.m_root,"txtCreateRoom1_SceneHall",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCreateRoom2_SceneHall",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root, "txtTimeLong_SceneHall", WZUILabelTTF):setScale(0.8)
end

function SceneHall:_adaptLanguage_pt()
    local ttfMatchDesc = GetElement(self.m_root, "ttfMatchDesc_SceneHall", WZUILabelTTF)
    ttfMatchDesc:setScale(0.9)
    ttfMatchDesc:setDimensions(GlobalMethod:CCSize(350))

    GetElement(self.m_root, "txtTimeLong_SceneHall", WZUILabelTTF):setScale(0.66)
    
end

function SceneHall:_adaptLanguage_tr()
    GetElement(self.m_root,"txtQuickBtnDesc_SceneHall",WZUILabelTTF):setScale(0.8)

    local ttfMatchDesc = GetElement(self.m_root, "ttfMatchDesc_SceneHall", WZUILabelTTF)
    ttfMatchDesc:setScale(0.8)
    ttfMatchDesc:setDimensions(GlobalMethod:CCSize(350))

    GetElement(self.m_root, "txtTimeLong_SceneHall", WZUILabelTTF):setScale(0.7)
end

function SceneHall:_adaptLanguage_vn()
    local ttfMatchDesc = GetElement(self.m_root, "ttfMatchDesc_SceneHall", WZUILabelTTF)
    ttfMatchDesc:setScale(0.8)
    ttfMatchDesc:setDimensions(GlobalMethod:CCSize(405))
end

function SceneHall:_adaptLanguage_es(  )
    local txtQuickBtn = GetElement(self.m_root,"txtQuickBtnDesc_SceneHall",WZUILabelTTF)
    txtQuickBtn:setDimensions(GlobalMethod:CCSize(130,0))
    txtQuickBtn:setScale(0.8)

    for i=1,2 do
        local txtFindRoom = GetElement(self.m_root,"txtFindRoom"..i.."_SceneHall",WZUILabelTTF)
        txtFindRoom:setDimensions(GlobalMethod:CCSize(130,0))
        txtFindRoom:setScale(0.8)
        local txtCreateRoom = GetElement(self.m_root,"txtCreateRoom"..i.."_SceneHall",WZUILabelTTF)
        txtCreateRoom:setDimensions(GlobalMethod:CCSize(130,0))
        txtCreateRoom:setScale(0.8)
        local txtFindRoom = GetElement(self.m_root,"txtFindRoom"..i.."_SceneHall",WZUILabelTTF)
        txtFindRoom:setDimensions(GlobalMethod:CCSize(130,0))
        txtFindRoom:setScale(0.8)
    end

    local ttfMatchDesc = GetElement(self.m_root, "ttfMatchDesc_SceneHall", WZUILabelTTF)
    ttfMatchDesc:setScale(0.8)
    ttfMatchDesc:setDimensions(GlobalMethod:CCSize(350))
end
----------------------------------------语言适配End---------------------------------------------