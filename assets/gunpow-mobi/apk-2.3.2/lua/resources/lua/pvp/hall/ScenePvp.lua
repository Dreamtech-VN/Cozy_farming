--ScenePvp.lua
--@brief	ScenePvp的UI模块
--@date		2016/11/21
--@author	binshao
--@note		pvp模式竞技


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function ScenePvp:onEnter(element)

	self.m_root = element
    ChangeChatChannel(Chat_Channel_Hall)
    self:controlBtnShow()
	self:_addCommonBtn()
	self:_addTop()
    self:_initStaticText()

	--周末显示活动未开启
	local open2_ScenePvp = GetElement(self.m_root,"open2_ScenePvp",WZUILabelTTF)
	local imgopen2_ScenePvp = GetElement(self.m_root,"imgopen2_ScenePvp",WZUIImage)
	local day = os.date("%w", SystemTime:getServerTime())
	if tonumber(day) == 6 or tonumber(day) == 0 or tonumber(day) == 7 then
		open2_ScenePvp:setText(LocalStrings.ACTIVITYCLOSE)
		imgopen2_ScenePvp:setScaleX(1.2)
	else
		open2_ScenePvp:setText(LocalStrings.PVP_HALL_24)
		imgopen2_ScenePvp:setScaleX(1)
	end
	SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)
    TeachGroup1:startGroup({20,2,self.m_root})
    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(48)
    WZLog("ScenePvp:onEnter two", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 23 then
        TeachGroup1:startGroup({48,2,self.m_root})
    end
end

function ScenePvp:onEnterTransitionDidFinish(element)
    WZLog("ScenePvp:onEnterTransitionDidFinish", ScenePvp.m_bIsOpenTrain)
    if self.m_bIsOpenTrain ~= nil then
        WndTrainingCamp:showInterface(self.m_bIsOpenTrain)
    end

	self:initOpenState()
    WndChat:addChatWindowToCurScene()

    --延时显示成就特效
    ShowDelayAchie()

    AdaptLanguage(self)

    -- --这几个渠道号屏蔽排位赛
    -- if ProjConfig.CHANNEL_ID == 1016 or ProjConfig.CHANNEL_ID == 1009 or ProjConfig.CHANNEL_ID == 1038 or ProjConfig.CHANNEL_ID == 1046 then
    --     local conPVP1 = GetElement(self.m_root,"conPVP1_ScenePVP",WZUIContainer)
    --     local conPVP2 = GetElement(self.m_root,"conPVP2_ScenePVP",WZUIContainer)
    --     local conPVP3 = GetElement(self.m_root,"conPVP3_ScenePVP",WZUIContainer)
    --     conPVP1:setRelativePosition(GlobalMethod:ccp(0.148351,0.5))
    --     conPVP2:setRelativePosition(GlobalMethod:ccp(0.703429,0.5))
    --     conPVP3:setVisible(false)

    -- end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function ScenePvp:onExit(element)
	self:_unInit()
end

function ScenePvp:showScene(isTrain)
    WZLog("ScenePvp:showScene", isTrain)
	local scene = ScenePvp:createElement()
    ScenePvp.m_bIsOpenTrain = isTrain
	replaceScene(scene)
end

-- 返回
function ScenePvp:onTempClose()
	WZLog("----------ScenePvp:onReturn------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	local scene = SceneCity:createElement()
	replaceScene(scene)
end

-- 选择比赛模式
function ScenePvp:onSelectMatch(element)
	WZLog("----------ScenePvp:onSelectMatch------------")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()

	--if self.openState[tag] == false then
	--	MsgBoxManager:showTipBox(LocalStrings.PVP_HALL_34)
	--	return
	--end

	if tag == 1 then
            
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
                    return
                end
            end
        end

        TeachGroup1:endTeachStep({20,2})
        PostPlayerEvent:postEvent(PostPlayerEvent.event_eightLvClickFightTab)
        replaceScene(SceneHall:createElement())
	elseif tag == 2 then
		--SceneAthMelee:showInterface()
    	if CheckButtonOpen(98) then
			ScenePvpAmuse:showScene()
		end
	elseif tag == 3 then
		-- MsgBoxManager:showTipBox(LocalStrings.PVPRANK_MODIFYING)
		-- do return end
	
        --屏蔽排位赛用的
		-- local language = ProjConfig.LANGUAGE
		-- if language == "hk" then
		-- 	MsgBoxManager:showTipBox(LocalStrings.SPACE100)
  --           TeachGroup1:setTeachFinish(48,-1)
  --           TeachGroup1:removeTeach()
		-- 	return
		-- end

		if GlobalMethod:crossServiceOpen() == 0 then
			MsgBoxManager:showTipBox(LocalStrings.CROSS_SERVICE_TIP3)
            TeachGroup1:setTeachFinish(48,-1)
            TeachGroup1:removeTeach()
			return
		end
		
		if CheckButtonOpen(23) == false then return end

		if CacheCenter:getGameParam().trioRankMatchConfig == nil or CacheCenter:getGameParam().trioRankMatchConfig == "" then return end
		local trioRankMatchConfig = json.decode(CacheCenter:getGameParam().trioRankMatchConfig)
		GetElement(self.m_root,"time32",WZUILabelTTF):setText(trioRankMatchConfig.startDay..LocalStrings.MAP_EVENT_ON)

		local year = tonumber(string.sub(trioRankMatchConfig.startDay,1,4))
		local month = tonumber(string.sub(trioRankMatchConfig.startDay,6,7))
		local day = tonumber(string.sub(trioRankMatchConfig.startDay,9,10))
		local openTime = os.time{year=year, month=month, day=day, hour=0}
		local curTime = SystemTime:getServerTime()
		WZLog("ScenePvp:initOpenState",year,month,day,os.time{year=year, month=month, day=day, hour=0},os.time())
		--print(os.time{year=year, month=month, day=day, hour=0})
		if curTime > openTime then
            local scene = ScenePvpRank:createElement()
            replaceScene(scene)
            ScenePvpRank:setReturnCallBack(ScenePvp, self.showScene)
		else
			MsgBoxManager:showTipBox(LocalStrings.WELFARE_COMPETE_TEXT1)
            TeachGroup1:setTeachFinish(48,-1)
            TeachGroup1:removeTeach()
		end

		--if CheckButtonOpen(ISLAND_UP_QUALIFYING) then
        --end

    elseif tag == 4 then
        if CheckButtonOpen(56) ~= true then return end

        local guildId = CacheCenter:getPlayerInfo().guildId
        if guildId == nil or guildId < 1 then
            MsgBoxManager:showTipBox(LocalStrings.SHOP_NOGONGHUI)
            return
        end

        SceneCommunityWar:showInterface()
        SceneCommunityWar:setCallBackFunc(SceneCommunityMain, SceneCommunityMain.showInterface)

    elseif tag == 5 then --战略赛
        if CheckButtonOpen(229) ~= true then return end
        ScenePvpStrategic:showInterface()
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function ScenePvp:setTime(tData)
	WZLog("ScenePvp:setTime")
	if self.m_root == nil then return end
	if tData == nil then return end
	self.m_tData = tData
    local txtTime = GetElement(self.m_root, "time31", WZUILabelTTF)
    local txtWords = GetElement(self.m_root, "time32", WZUILabelTTF)

        --日期
        if txtTime then
            if self.m_tData.seasonStatus == 0 then
                txtTime:setText(self.m_tData.startDay .. "-" .. self.m_tData.endDay)
            else
                if self.m_tData.startDay == self.m_tData.nextSTime and self.m_tData.endDay == self.m_tData.nextETime then
                    txtTime:setText(self.m_tData.startDay .. "-" .. self.m_tData.endDay)
                else
                    txtTime:setText(self.m_tData.nextSTime .. "-" .. self.m_tData.nextETime)
                    --txtSeason:setText(self.m_nSeason + 1)
                end 
            end
        end
        --时间段
        if txtWords then
            txtWords:setText(self.m_tData.startTime .. "-" .. self.m_tData.endTime .. " " .. LocalStrings.MAP_EVENT_ON)
        end

	    local sWeekDay = CacheCenter:getGameParam()["meleeOpenDayOfWeek"]
        local tWeekDay = SplitStringWithSeparator(sWeekDay, ",")
        local sContent = nil 
        for i = 1, #tWeekDay do
            if tonumber(tWeekDay[i]) == 0 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE2
                else
                    sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE2
                end
            elseif tonumber(tWeekDay[i]) == 1 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE3
                else
                    sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE3
                end
            elseif tonumber(tWeekDay[i]) == 2 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE4
                else
                    sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE4
                end
            elseif tonumber(tWeekDay[i]) == 3 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE5
                else
                    sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE5
                end
            elseif tonumber(tWeekDay[i]) == 4 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE6
                else
                    sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE6
                end
            elseif tonumber(tWeekDay[i]) == 5 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE7
                else
                    sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE7
                end
            elseif tonumber(tWeekDay[i]) == 6 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE8
                else
                    sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE8
                end
            end
        end
        local sTime = CacheCenter:getGameParam()["meleeOpenTime"]
        --时间段
		local text = [[<T C="255,255,255" S="20" P="0" SC="79,60,48" SE="1" SS="4">%s</T><BR></BR><T C="255,255,255" S="20" P="0" SC="79,60,48" SE="1" SS="4">%s</T>]]
		GetElement(self.m_root,"time21",WZUIFreeTextBox):setShowText(string.format(text,sContent,sTime.." "..LocalStrings.MAP_EVENT_ON))
end

function ScenePvp:_addTop()
	local cell,tcell = CellTopHandle:createElement()
	self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_jjc.png",ScenePvp,ScenePvp.onTempClose,false,true,true,"ScenePvp")
    tcell:setTopType()
    self.topCell = {cell = cell, tcell = tcell}
end

function ScenePvp:_addCommonBtn()
	local cell,tcell = CellArenaCommonBtn:createElement()
	self.m_root:addChild(cell,0,8989898)
end

function ScenePvp:initOpenState()
	WZLog("ScenePvp:initOpenState",CacheCenter:getGameParam().trioRankMatchConfig)
	--local open = self.openState
	--local time = {LocalStrings.PVP_HALL_35,LocalStrings.PVP_HALL_35,LocalStrings.PVP_HALL_35 }
	--for i = 1, 5 do
	--	local conO = GetElement(self.m_root,"conStateOpen"..i.."_ScenePvpAmuse",WZUIContainer)
	--	local conC = GetElement(self.m_root,"conStateClose"..i.."_ScenePvpAmuse",WZUIContainer)
	--	local ftb = GetElement(self.m_root,"ftbOpenTime"..i.."_ScenePvpAmuse",WZUIFreeTextBox)
	--	conO:setVisible(open[i])
	--	conC:setVisible(not open[i])
	--	ftb:setShowText(string.format(LocalStrings.PVP_HALL_35,9))
	--end
	
	if CacheCenter:getGameParam().trioRankMatchConfig == nil or CacheCenter:getGameParam().trioRankMatchConfig == "" then return end
	local trioRankMatchConfig = json.decode(CacheCenter:getGameParam().trioRankMatchConfig)
	GetElement(self.m_root,"time32",WZUILabelTTF):setText(trioRankMatchConfig.startDay..LocalStrings.MAP_EVENT_ON)

	local year = tonumber(string.sub(trioRankMatchConfig.startDay,1,4))
	local month = tonumber(string.sub(trioRankMatchConfig.startDay,6,7))
	local day = tonumber(string.sub(trioRankMatchConfig.startDay,9,10))
	local openTime = os.time{year=year, month=month, day=day, hour=0}
	local curTime = SystemTime:getServerTime()
	WZLog("ScenePvp:initOpenState",year,month,day,os.time{year=year, month=month, day=day, hour=0},os.time())
	--print(os.time{year=year, month=month, day=day, hour=0})
	if curTime > openTime then
		GetElement(self.m_root,"conStateClose3_ScenePvp",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"time31",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"time32",WZUILabelTTF):setVisible(false)
	else
		GetElement(self.m_root,"conStateClose3_ScenePvp",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"time31",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"time32",WZUILabelTTF):setVisible(true)
	end

	if GlobalMethod:crossServiceOpen() == 0 then
		GetElement(self.m_root,"conStateClose3_ScenePvp",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"time31",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"time32",WZUILabelTTF):setVisible(false)
	end
end


--按照功能开放等级进行显示
function ScenePvp:controlBtnShow()
    -- body
    WZLog("ScenePvp:controlBtnShow")
    local GDatatab_button_info = GDatatab_button_info
    local GetElement = GetElement
    local btnList = {5,98,23,56,229}
    
    local conList = GetElement(self.m_root,"conList_ScenePvp",WZUIContainer)
    local playerLevel = CacheCenter:getPlayerInfo().level
    for i,v in ipairs(btnList) do
        local con = GetElement(conList,"con" .. i .. "_ScenePvp",WZUIContainer)
        if con then
            if playerLevel >= GDatatab_button_info["id_"..v].open_level  then 
                con:setVisible(false)
            else
                con:setVisible(true)
            end
        end
    end
end

--@brief    设置静态文本
function ScenePvp:_initStaticText()
    local txtT5 = GetElement(self.m_root,"txtT5_ScenePvp",WZUILabelTTF)
    if txtT5 then
        txtT5:setText(LocalStrings.PVP_STRATEGIC_TEXT1[1])
    end
    local txtE5 = GetElement(self.m_root,"txtE5_ScenePvp",WZUILabelTTF)
    if txtE5 then
        txtE5:setText(LocalStrings.PVP_STRATEGIC_TEXT1[2])
    end
    local txtStateOpen5 = GetElement(self.m_root,"txtStateOpen5_ScenePvp",WZUILabelTTF)
    if txtStateOpen5 then
        txtStateOpen5:setText(LocalStrings.PVP_STRATEGIC_TEXT1[3])
    end
end

-------------------------------------私有方法模块End----------------------------------------

function ScenePvp:_adaptLanguage_hk()
	WZLog("ScenePvp:_adaptLanguage_hk")
	local con1 = GetElement(self.m_root,"con1_ScenePvp",WZUIContainer)
	local con2 = GetElement(self.m_root,"con2_ScenePvp",WZUIContainer)
	local con3 = GetElement(self.m_root,"con3_ScenePvp",WZUIContainer)
	-- con3:setVisible(false)
	-- con1:setRelativePosition(GlobalMethod:ccp(0.19576,0.5))
	-- con2:setRelativePosition(GlobalMethod:ccp(0.683512,0.5))
end

-------------------------------------语言适配Begin------------------------------------------
function ScenePvp:_adaptLanguage_en( )
    local txtStateOpen1 = GetElement(self.m_root,"txtStateOpen1_ScenePvp",WZUILabelTTF)
    txtStateOpen1:setScale(0.9)
    --txtStateOpen1:setRelativePosition(GlobalMethod:ccp(0.477778,0.5))

    local txtStateOpen2 = GetElement(self.m_root,"open2_ScenePvp",WZUILabelTTF)
    txtStateOpen2:setScale(0.85)
    -- local txtStateOpen2 = GetElement(self.m_root,"txtStateOpen2_ScenePvp",WZUILabelTTF)
    -- txtStateOpen2:setScale(0.85)
    -- txtStateOpen2:setRelativePosition(GlobalMethod:ccp(0.477778,0.5))
end

function ScenePvp:_adaptLanguage_th( )
    local txtStateOpen2 = GetElement(self.m_root,"open2_ScenePvp",WZUILabelTTF)
    txtStateOpen2:setScale(0.9)
    -- txtStateOpen2:setRelativePosition(GlobalMethod:ccp(0.477778,0.5))

    local imgStateOpen3 = GetElement(self.m_root,"imgStateOpen3_ScenePvp",WZUIImage)
    imgStateOpen3:setScaleX(1.9)
end

function ScenePvp:_adaptLanguage_vn( )
    local txtStateOpen1 = GetElement(self.m_root,"txtStateOpen1_ScenePvp",WZUILabelTTF)
    txtStateOpen1:setScale(0.8)

    local txtStateOpen2 = GetElement(self.m_root,"open2_ScenePvp",WZUILabelTTF)
    txtStateOpen2:setScale(0.8)

    local txtStateOpen3 = GetElement(self.m_root,"txtStateOpen3_ScenePvp",WZUILabelTTF)
    txtStateOpen3:setScale(0.8)

    local txtE1 = GetElement(self.m_root,"txtE1_ScenePvp",WZUILabelTTF)
    txtE1:setDimensions(GlobalMethod:CCSize(240))
    local txtE2 = GetElement(self.m_root,"txtE2_ScenePvp",WZUILabelTTF)
    txtE2:setDimensions(GlobalMethod:CCSize(240))
    local txtE3 = GetElement(self.m_root,"txtE3_ScenePvp",WZUILabelTTF)
    txtE3:setDimensions(GlobalMethod:CCSize(240))

    for i = 1, 3 do
        GetElement(self.m_root,"txtE"..i.."_ScenePvp",WZUILabelTTF):setScale(0.8)
    end
    GetElement(self.m_root,"imgopen2_ScenePvp",WZUIImage):setScaleX(1.4)
    GetElement(self.m_root,"imgStateOpen1_ScenePvp",WZUIImage):setScaleX(1.4)
    GetElement(self.m_root,"imgStateOpen3_ScenePvp",WZUIImage):setScaleX(1.4)
end

function ScenePvp:_adaptLanguage_pt( )
    local imgStateOpen1 = GetElement(self.m_root,"imgStateOpen1_ScenePvp",WZUIImage)
    imgStateOpen1:setScaleX(1.3)
    --imgStateOpen1:setRelativePosition(GlobalMethod:ccp(0.644444,0.5))
    local txtStateOpen1 = GetElement(self.m_root,"txtStateOpen1_ScenePvp",WZUILabelTTF)
    --txtStateOpen1:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
    txtStateOpen1:setScale(0.8)

    local imgStateOpen2 = GetElement(self.m_root,"imgopen2_ScenePvp",WZUIImage)
    imgStateOpen2:setScaleX(1.8)
    --imgStateOpen2:setRelativePosition(GlobalMethod:ccp(1.12222,0.5))

    local txtStateOpen2 = GetElement(self.m_root,"open2_ScenePvp",WZUILabelTTF)
    txtStateOpen2:setScale(0.8)

    local imgStateOpen3 = GetElement(self.m_root,"imgStateOpen3_ScenePvp",WZUIImage)
    imgStateOpen3:setScaleX(1.8)
    --imgStateOpen3:setRelativePosition(GlobalMethod:ccp(1.11111,0.5))
    local txtStateOpen3 = GetElement(self.m_root,"txtStateOpen3_ScenePvp",WZUILabelTTF)
    --txtStateOpen3:setRelativePosition(GlobalMethod:ccp(1.02222,0.5))
    txtStateOpen3:setScale(0.8)

    for i = 1, 3 do
        local txtE = GetElement(self.m_root,"txtE"..i.."_ScenePvp",WZUILabelTTF)
        txtE:setScale(0.8)
        txtE:setDimensions(GlobalMethod:CCSize(300))
    end
end

function ScenePvp:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtE1_ScenePvp",WZUILabelTTF):setScale(0.8)
    local imgStateOpen2 = GetElement(self.m_root,"imgopen2_ScenePvp",WZUIImage)
    imgStateOpen2:setScaleX(1.8)
    --imgStateOpen2:setRelativePosition(GlobalMethod:ccp(1.12222,0.5))

    local txtStateOpen2 = GetElement(self.m_root,"open2_ScenePvp",WZUILabelTTF)
    txtStateOpen2:setScale(0.8)

    local txtStateOpen3 = GetElement(self.m_root,"txtStateOpen3_ScenePvp",WZUILabelTTF)
    txtStateOpen3:setDimensions(GlobalMethod:CCSize(100,0))
    txtStateOpen3:setScale(0.7)

    GetElement(self.m_root,"txtET2_ScenePvp",WZUILabelTTF):setScale(0.66)
    GetElement(self.m_root,"txtStateOpen1_ScenePvp",WZUILabelTTF):setScale(0.7)
end

function ScenePvp:_adaptLanguage_tr( )
    local txtStateOpen1 = GetElement(self.m_root,"txtStateOpen1_ScenePvp",WZUILabelTTF)
    txtStateOpen1:setScale(0.7)
    local open2 = GetElement(self.m_root,"open2_ScenePvp",WZUILabelTTF)
    open2:setScale(0.65)
    local txtStateOpen3 = GetElement(self.m_root,"txtStateOpen3_ScenePvp",WZUILabelTTF)
    txtStateOpen3:setScale(0.6)
end

function ScenePvp:_adaptLanguage_ug( )
    local txtET1 = GetElement(self.m_root,"txtET1_ScenePvp",WZUILabelTTF)
    txtET1:setScale(0.7)
    txtET1:setRelativePosition(GlobalMethod:ccp(0.5,0.8))
    local txtET2 = GetElement(self.m_root,"txtET2_ScenePvp",WZUILabelTTF)
    txtET2:setScale(0.7)
    txtET2:setRelativePosition(GlobalMethod:ccp(0.5,0.8))
    local txtET3 = GetElement(self.m_root,"txtET3_ScenePvp",WZUILabelTTF)
    txtET3:setScale(0.7)
    txtET3:setRelativePosition(GlobalMethod:ccp(0.5,0.8))
    local txtE1 = GetElement(self.m_root,"txtE1_ScenePvp",WZUILabelTTF)
    txtE1:setDimensions(GlobalMethod:CCSize(240))
    local txtE2 = GetElement(self.m_root,"txtE2_ScenePvp",WZUILabelTTF)
    txtE2:setDimensions(GlobalMethod:CCSize(240))
    local txtE3 = GetElement(self.m_root,"txtE3_ScenePvp",WZUILabelTTF)
    txtE3:setDimensions(GlobalMethod:CCSize(300))

    local txtStateOpen1 = GetElement(self.m_root,"txtStateOpen1_ScenePvp",WZUILabelTTF)
    txtStateOpen1:setScale(0.5)
    txtStateOpen1:setDimensions(GlobalMethod:CCSize(160))
    local txtStateOpen2 = GetElement(self.m_root,"open2_ScenePvp",WZUILabelTTF)
    txtStateOpen2:setScale(0.5)
    txtStateOpen2:setDimensions(GlobalMethod:CCSize(160))
    local txtStateOpen3 = GetElement(self.m_root,"txtStateOpen3_ScenePvp",WZUILabelTTF)
    txtStateOpen3:setScale(0.5)
    txtStateOpen3:setDimensions(GlobalMethod:CCSize(160))

end
-------------------------------------语言适配End--------------------------------------------