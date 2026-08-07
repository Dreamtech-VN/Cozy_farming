--ProtocolProcessorSceneCity.lua
--@brief	主城相关协议
--@date  	2015/3/26
--@author 	莫剑峰
--@note 	主城相关协议


ProtocolProcessorSceneCity = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorSceneCity:regAll()

    --@brief    进入主界面协议成功(RANKMATCH_GetRankInfoOK = 4）

    --@brief    英雄联赛开始时间（HERO_HeroStartTimeOk = 86）
    self:regProtocolCallbackFunction( Protocol.MAIN_HERO, Protocol.HERO_HeroStartTimeOk, "ProtocolProcessorSceneCity:parse_HERO_HeroStartTimeOk", "ssssssssssssssssssssssssssssssissssssiiii")

	--@brief	返回玩家场景显示信息（PLAYER_PlayerSceneInfo = 67）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_PlayerSceneInfo , "ProtocolProcessorSceneCity:parse_PLAYER_PlayerSceneInfo", "vivtvivsvsvivivivivsvsvbivnvivivivivsvivivs")

    --@brief	更新小红点（PLAYER_UpdateRedDot = 62）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpdateRedDot, "ProtocolProcessorSceneCity:parse_PLAYER_UpdateRedDot", "vivnvivivivivi")

    --@brief	取消小红点（PLAYER_CancelRedDotOK = 64）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_CancelRedDotOK, "ProtocolProcessorSceneCity:parse_PLAYER_CancelRedDotOK", "")

    --@brief	获取活跃值信息成功（GetActiveInfoOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVE, Protocol.GetActiveInfoOk, "ProtocolProcessorSceneCity:parse_GetActiveInfoOk", "vsvsivsvssvsvs")

	--错误处理(S->C)
    --@brief	获得小红点（PLAYER_GetUpdateRedDot = 70）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetUpdateRedDot, "ProtocolProcessorSceneCity:send_PLAYER_GetUpdateRedDot_ErrorProcess", "is" )

    --@brief	取消小红点（PLAYER_CancelRedDot = 63）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_CancelRedDot, "ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot_ErrorProcess", "is" )

    --@brief    请求玩家额外信息（PLAYER_GetPlayerExtInfo = 117）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerExtInfo, "ProtocolProcessorSceneCity:send_PLAYER_GetPlayerExtInfo_ErrorProcess", "is" )

    self:regProtocolCallbackFunction( Protocol.MAIN_EQUIP, Protocol.EQUIP_GetFreeTimeOK, "ProtocolProcessorSceneCity:parse_EQUIP_GetFreeTimeOK", "ii")

    self:regProtocolCallbackFunction( Protocol.MAIN_CARD, Protocol.CARD_GetCardSetListOk, "ProtocolProcessorSceneCity:parse_CARD_GetCardSetListOk", "viviii")

    --@brief    玩家登录主场景额外信息返回（PLAYER_GetPlayerExtInfoOk = 118）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerExtInfoOk, "ProtocolProcessorSceneCity:parse_PLAYER_GetPlayerExtInfoOk", "s")
    --@brief    获取弹弹宝典信息错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerAnswerInfo, "ProtocolProcessorSceneCity:send_PLAYER_GetPlayerAnswerInfo_ErrorProcess", "is" )
    --@brief    获取弹弹宝典信息
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerAnswerInfoOk, "ProtocolProcessorSceneCity:parse_PLAYER_GetPlayerAnswerInfoOk", "vi")
    --@brief    提交弹弹宝典答案错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_SubmitPlayerAnswer, "ProtocolProcessorSceneCity:send_PLAYER_SubmitPlayerAnswer_ErrorProcess", "is" )
    --@brief    提交弹弹宝典答案
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_SubmitPlayerAnswerOk, "ProtocolProcessorSceneCity:parse_PLAYER_SubmitPlayerAnswerOk", "iivivivi")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSceneCity:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	获取技能列表（PLAYER_GetSkillList = 73）
function ProtocolProcessorSceneCity:send_PLAYER_GetSkillList()
    WZLog("send_PLAYER_GetSkillList ")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillList  )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物免费抽取成功（PET_DeletePet = 15）
function ProtocolProcessorSceneCity:parse_PET_GetFreeTimeOK(type, time)
    -- type : 抽奖类型
    -- time : 抽奖时间
    WZLog("ProtocolProcessorScenePets:parse_PET_GetFreeTimeOK")
    WndBottomBar:getTime(VectorToTable(type), VectorToTable(time))
end

--@brief	获得小红点（PLAYER_GetUpdateRedDot = 70）
function ProtocolProcessorSceneCity:send_PLAYER_GetUpdateRedDot( )
    WZLog("send_PLAYER_GetUpdateRedDot")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetUpdateRedDot )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief	取消小红点（PLAYER_CancelRedDot = 63）
function ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(redDotType )
    WZLog("send_PLAYER_CancelRedDot", redDotType)
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_CancelRedDot )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( redDotType )	-- 小红点类型
    SendProtocol(sender,false) --true:showLoading
end

--@brief    请求玩家额外信息（PLAYER_GetPlayerExtInfo = 117）
function ProtocolProcessorSceneCity:send_PLAYER_GetPlayerExtInfo()
    WZLog("send_PLAYER_GetPlayerExtInfo")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerExtInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end
--@brief    获取弹弹宝典信息
function ProtocolProcessorSceneCity:send_PLAYER_GetPlayerAnswerInfo( )
    WZLog("send_PLAYER_GetPlayerAnswerInfo")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerAnswerInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end
--@brief    提交弹弹宝典答案
function ProtocolProcessorSceneCity:send_PLAYER_SubmitPlayerAnswer(answerType, selects )
    WZLog("send_PLAYER_SubmitPlayerAnswer")
    local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_SubmitPlayerAnswer )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( answerType )   -- 1、2、3|初、中、高
    sender:writeInts( selects ) -- 选择的答案[1,2,1,3] 1开始 1、2、3、4
    SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief    英雄联赛开始时间（HERO_HeroStartTimeOk = 86）
function ProtocolProcessorSceneCity:parse_HERO_HeroStartTimeOk(startTime32One, endTime32One, startTime32Two, endTime32Two, startTime32Three, endTime32Three, startTime16One, endTime16One, startTime16Two, endTime16Two, startTime16Three, endTime16Three, startTime8One, endTime8One, startTime8Two, endTime8Two, startTime8Three, endTime8Three, startTime4One, endTime4One, startTime4Two, endTime4Two, startTime4Three, endTime4Three, startTimeFOne, endTimeFOne, startTimeFTwo, endTimeFTwo, startTimeFThree, endTimeFThree, nowTime, startDateAll, endDateAll, startTimeAll, endTimeAll, startSignTime, endSignTime, winScore, failScore, applyPunish, makePairPunish)
    -- nowTime : 服务器当前时间戳
    -- startDateAll : 海选赛开始日期（格式 yyyy.MM.dd）
    -- endDateAll : 海选赛结束日期（格式 yyyy.MM.dd）
    -- startTimeAll : 海选赛开始时间（格式 HH:mm）
    -- endTimeAll : 海选赛结束时间（格式 HH:mm）

    -- startTime32One : 32强第一轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTime32One : 32强第一轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTime32Two : 32强第二轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTime32Two : 32强第二轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTime32Three : 32强第三轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTime32Three : 32强第三轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTime16One : 16强第一轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTime16One : 16强第一轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTime16Two : 16强第二轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTime16Two : 16强第二轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTime16Three : 16强第三轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTime16Three : 16强第三轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTime8One : 8强第一轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTime8One : 8强第一轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTime8Two : 8强第二轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTime8Two : 8强第二轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTime8Three : 8强第三轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTime8Three : 8强第三轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTime4One : 4强第一轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTime4One : 4强第一轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTime4Two : 4强第二轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTime4Two : 4强第二轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTime4Three : 4强第三轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTime4Three : 4强第三轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTimeFOne : 决赛第一轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTimeFOne : 决赛第一轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTimeFTwo : 决赛第二轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTimeFTwo : 决赛第二轮结束时间（格式 yyyy.MM.dd HH:mm）
    -- startTimeFThree : 决赛第三轮开始时间（格式 yyyy.MM.dd HH:mm）
    -- endTimeFThree : 决赛第三轮结束时间（格式 yyyy.MM.dd HH:mm）

    if startDateAll == "" or endDateAll == "" then
        return
    end

    local tab = os.date("*t", nowTime)
    tab.osTime = os.time()
    tab.serverTime = nowTime

    if startDateAll == "" or endDateAll == "" then
        return
    end

    local startDateAll1 = SplitStringWithSeparator(startDateAll, "%.", nil, true)
    local endDateAll1 = SplitStringWithSeparator(endDateAll, "%.", nil, true)
    local startTimeAll1 = SplitStringWithSeparator(startTimeAll, ":", nil, true)
    local endTimeAll1 = SplitStringWithSeparator(endTimeAll, ":", nil, true)
    local tabStart = {year=startDateAll1[1], month=startDateAll1[2], day=startDateAll1[3], hour=startTimeAll1[1], min=startTimeAll1[2]}
    local tabEnd = {year=endDateAll1[1], month=endDateAll1[2], day=endDateAll1[3], hour=endTimeAll1[1], min=endTimeAll1[2]}
    

    --tabStart = {year=2016, month=9, day=2, hour=15, min=26}
    --tabEnd = {year=2016, month=10, day=1, hour=18, min=0}
    
    SceneCity.startDateAll = startDateAll
    SceneCity.endTimeFThree = endTimeFThree
    SceneCity.tabStartHero = tabStart
    SceneCity.tabEndHero = tabEnd
    SceneCity.tabCur = tab
    WZLog("ProtocolProcessorSceneCity:parse_HERO_HeroStartTimeOk0", os.time(), nowTime, startDateAll, endDateAll, 
        "startTimeAll ", startTimeAll, endTimeAll, "tabStart ", Serialize(tabStart), 
        "tabEnd ", Serialize(tabEnd), 
        "startTime32One", startTime32One, endTime32One, startTime32Two, endTime32Two, startTime32Three, endTime32Three,
        "startTime16One", startTime16One, endTime16One, startTime16Two, endTime16Two, startTime16Three, endTime16Three,
        "startTime8One", startTime8One, endTime8One, startTime8Two, endTime8Two, startTime8Three, endTime8Three,
        "startTime4One", startTime4One, endTime4One, startTime4Two, endTime4Two, startTime4Three, endTime4Three,
        "startTimeFOne", startTimeFOne, endTimeFOne, startTimeFTwo, endTimeFTwo, startTimeFThree, endTimeFThree
        )

    local startTime32One1 = SplitStringWithSeparator(startTime32One, " ")
    local startTime32OneData = SplitStringWithSeparator(startTime32One1[1], "%.", nil, true)
    local startTime32Two1 = SplitStringWithSeparator(startTime32Two, " ")
    local startTime32TwoData = SplitStringWithSeparator(startTime32Two1[1], "%.", nil, true)
    local startTime32Three1 = SplitStringWithSeparator(startTime32Three, " ")
    local startTime32ThreeData = SplitStringWithSeparator(startTime32Three1[1], "%.", nil, true)
    SceneCity.startTime32TwoData = startTime32TwoData
    SceneCity.startTime32ThreeData = startTime32ThreeData
    local startTime32OneTime = SplitStringWithSeparator(SplitStringWithSeparator(startTime32One, " ")[2], ":", nil, true)
    local endTime32OneTime = SplitStringWithSeparator(SplitStringWithSeparator(endTime32One, " ")[2], ":", nil, true)
    local startTime32TwoTime = SplitStringWithSeparator(SplitStringWithSeparator(startTime32Two, " ")[2], ":", nil, true)
    local endTime32TwoTime = SplitStringWithSeparator(SplitStringWithSeparator(endTime32Two, " ")[2], ":", nil, true)
    local startTime32ThreeTime = SplitStringWithSeparator(SplitStringWithSeparator(startTime32Three, " ")[2], ":", nil, true)
    local endTime32ThreeTime = SplitStringWithSeparator(SplitStringWithSeparator(endTime32Three, " ")[2], ":", nil, true)
    SceneCity.startTime32OneData = startTime32OneData
    SceneCity.startTime32OneTime = startTime32OneTime
    SceneCity.endTime32OneTime = endTime32OneTime
    SceneCity.startTime32TwoTime = startTime32TwoTime
    SceneCity.endTime32TwoTime = endTime32TwoTime
    SceneCity.startTime32ThreeTime = startTime32ThreeTime
    SceneCity.endTime32ThreeTime = endTime32ThreeTime
    if SceneCity.startTime32OneTime[2] < 10 then
        SceneCity.startTime32OneTime[1] = SceneCity.startTime32OneTime[1] - 1
        SceneCity.startTime32OneTime[2] = 60 - (10 - SceneCity.startTime32OneTime[2])
    else
        SceneCity.startTime32OneTime[2] = SceneCity.startTime32OneTime[2] - 10
    end
    if SceneCity.startTime32TwoTime[2] < 10 then
        SceneCity.startTime32TwoTime[1] = SceneCity.startTime32TwoTime[1] - 1
        SceneCity.startTime32TwoTime[2] = 60 - (10 - SceneCity.startTime32TwoTime[2])
    else
        SceneCity.startTime32TwoTime[2] = SceneCity.startTime32TwoTime[2] - 10
    end
    if SceneCity.startTime32ThreeTime[2] < 10 then
        SceneCity.startTime32ThreeTime[1] = SceneCity.startTime32ThreeTime[1] - 1
        SceneCity.startTime32ThreeTime[2] = 60 - (10 - SceneCity.startTime32ThreeTime[2])
    else
        SceneCity.startTime32ThreeTime[2] = SceneCity.startTime32ThreeTime[2] - 10
    end
    WZLog("ProtocolProcessorSceneCity:parse_HERO_HeroStartTimeOk1_1", "startTime32OneData", Serialize(startTime32OneData), 
        "startTime32OneTime", Serialize(startTime32OneTime), "endTime32OneTime", Serialize(endTime32OneTime), 
        "startTime32TwoTime", Serialize(startTime32TwoTime), "endTime32TwoTime", Serialize(endTime32TwoTime), 
        "startTime32ThreeTime", Serialize(startTime32ThreeTime), "endTime32ThreeTime", Serialize(endTime32ThreeTime))

    local startTime16One1 = SplitStringWithSeparator(startTime16One, " ")
    local startTime16OneData = SplitStringWithSeparator(startTime16One1[1], "%.", nil, true)
    local startTime16Two1 = SplitStringWithSeparator(startTime16Two, " ")
    local startTime16TwoData = SplitStringWithSeparator(startTime16Two1[1], "%.", nil, true)
    local startTime16Three1 = SplitStringWithSeparator(startTime16Three, " ")
    local startTime16ThreeData = SplitStringWithSeparator(startTime16Three1[1], "%.", nil, true)
    SceneCity.startTime16TwoData = startTime16TwoData
    SceneCity.startTime16ThreeData = startTime16ThreeData
    local startTime16OneTime = SplitStringWithSeparator(SplitStringWithSeparator(startTime16One, " ")[2], ":", nil, true)
    local endTime16OneTime = SplitStringWithSeparator(SplitStringWithSeparator(endTime16One, " ")[2], ":", nil, true)
    local startTime16TwoTime = SplitStringWithSeparator(SplitStringWithSeparator(startTime16Two, " ")[2], ":", nil, true)
    local endTime16TwoTime = SplitStringWithSeparator(SplitStringWithSeparator(endTime16Two, " ")[2], ":", nil, true)
    local startTime16ThreeTime = SplitStringWithSeparator(SplitStringWithSeparator(startTime16Three, " ")[2], ":", nil, true)
    local endTime16ThreeTime = SplitStringWithSeparator(SplitStringWithSeparator(endTime16Three, " ")[2], ":", nil, true)
    SceneCity.startTime16OneData = startTime16OneData
    SceneCity.startTime16OneTime = startTime16OneTime
    SceneCity.endTime16OneTime = endTime16OneTime
    SceneCity.startTime16TwoTime = startTime16TwoTime
    SceneCity.endTime16TwoTime = endTime16TwoTime
    SceneCity.startTime16ThreeTime = startTime16ThreeTime
    SceneCity.endTime16ThreeTime = endTime16ThreeTime
    if SceneCity.startTime16OneTime[2] < 10 then
        SceneCity.startTime16OneTime[1] = SceneCity.startTime16OneTime[1] - 1
        SceneCity.startTime16OneTime[2] = 60 - (10 - SceneCity.startTime16OneTime[2])
    else
        SceneCity.startTime16OneTime[2] = SceneCity.startTime16OneTime[2] - 10
    end
    if SceneCity.startTime16TwoTime[2] < 10 then
        SceneCity.startTime16TwoTime[1] = SceneCity.startTime16TwoTime[1] - 1
        SceneCity.startTime16TwoTime[2] = 60 - (10 - SceneCity.startTime16TwoTime[2])
    else
        SceneCity.startTime16TwoTime[2] = SceneCity.startTime16TwoTime[2] - 10
    end
    if SceneCity.startTime16ThreeTime[2] < 10 then
        SceneCity.startTime16ThreeTime[1] = SceneCity.startTime16ThreeTime[1] - 1
        SceneCity.startTime16ThreeTime[2] = 60 - (10 - SceneCity.startTime16ThreeTime[2])
    else
        SceneCity.startTime16ThreeTime[2] = SceneCity.startTime16ThreeTime[2] - 10
    end
    WZLog("ProtocolProcessorSceneCity:parse_HERO_HeroStartTimeOk1_2", "startTime16OneData", Serialize(startTime16OneData), 
        "startTime16OneTime", Serialize(startTime16OneTime), "endTime16OneTime", Serialize(endTime16OneTime), 
        "startTime16TwoTime", Serialize(startTime16TwoTime), "endTime16TwoTime", Serialize(endTime16TwoTime), 
        "startTime16ThreeTime", Serialize(startTime16ThreeTime), "endTime16ThreeTime", Serialize(endTime16ThreeTime))

    local startTime8One1 = SplitStringWithSeparator(startTime8One, " ")
    local startTime8OneData = SplitStringWithSeparator(startTime8One1[1], "%.", nil, true)
    local startTime8Two1 = SplitStringWithSeparator(startTime8Two, " ")
    local startTime8TwoData = SplitStringWithSeparator(startTime8Two1[1], "%.", nil, true)
    local startTime8Three1 = SplitStringWithSeparator(startTime8Three, " ")
    local startTime8ThreeData = SplitStringWithSeparator(startTime8Three1[1], "%.", nil, true)
    SceneCity.startTime8TwoData = startTime8TwoData
    SceneCity.startTime8ThreeData = startTime8ThreeData
    local startTime8OneTime = SplitStringWithSeparator(SplitStringWithSeparator(startTime8One, " ")[2], ":", nil, true)
    local endTime8OneTime = SplitStringWithSeparator(SplitStringWithSeparator(endTime8One, " ")[2], ":", nil, true)
    local startTime8TwoTime = SplitStringWithSeparator(SplitStringWithSeparator(startTime8Two, " ")[2], ":", nil, true)
    local endTime8TwoTime = SplitStringWithSeparator(SplitStringWithSeparator(endTime8Two, " ")[2], ":", nil, true)
    local startTime8ThreeTime = SplitStringWithSeparator(SplitStringWithSeparator(startTime8Three, " ")[2], ":", nil, true)
    local endTime8ThreeTime = SplitStringWithSeparator(SplitStringWithSeparator(endTime8Three, " ")[2], ":", nil, true)
    SceneCity.startTime8OneData = startTime8OneData
    SceneCity.startTime8OneTime = startTime8OneTime
    SceneCity.endTime8OneTime = endTime8OneTime
    SceneCity.startTime8TwoTime = startTime8TwoTime
    SceneCity.endTime8TwoTime = endTime8TwoTime
    SceneCity.startTime8ThreeTime = startTime8ThreeTime
    SceneCity.endTime8ThreeTime = endTime8ThreeTime
    if SceneCity.startTime8OneTime[2] < 10 then
        SceneCity.startTime8OneTime[1] = SceneCity.startTime8OneTime[1] - 1
        SceneCity.startTime8OneTime[2] = 60 - (10 - SceneCity.startTime8OneTime[2])
    else
        SceneCity.startTime8OneTime[2] = SceneCity.startTime8OneTime[2] - 10
    end
    if SceneCity.startTime8TwoTime[2] < 10 then
        SceneCity.startTime8TwoTime[1] = SceneCity.startTime8TwoTime[1] - 1
        SceneCity.startTime8TwoTime[2] = 60 - (10 - SceneCity.startTime8TwoTime[2])
    else
        SceneCity.startTime8TwoTime[2] = SceneCity.startTime8TwoTime[2] - 10
    end
    if SceneCity.startTime8ThreeTime[2] < 10 then
        SceneCity.startTime8ThreeTime[1] = SceneCity.startTime8ThreeTime[1] - 1
        SceneCity.startTime8ThreeTime[2] = 60 - (10 - SceneCity.startTime8ThreeTime[2])
    else
        SceneCity.startTime8ThreeTime[2] = SceneCity.startTime8ThreeTime[2] - 10
    end
    WZLog("ProtocolProcessorSceneCity:parse_HERO_HeroStartTimeOk1_3", "startTime8OneData", Serialize(startTime8OneData), 
        "startTime8OneTime", Serialize(startTime8OneTime), "endTime8OneTime", Serialize(endTime8OneTime), 
        "startTime8TwoTime", Serialize(startTime8TwoTime), "endTime8TwoTime", Serialize(endTime8TwoTime), 
        "startTime8ThreeTime", Serialize(startTime8ThreeTime), "endTime8ThreeTime", Serialize(endTime8ThreeTime))

    local startTime4One1 = SplitStringWithSeparator(startTime4One, " ")
    local startTime4OneData = SplitStringWithSeparator(startTime4One1[1], "%.", nil, true)
    local startTime4Two1 = SplitStringWithSeparator(startTime4Two, " ")
    local startTime4TwoData = SplitStringWithSeparator(startTime4Two1[1], "%.", nil, true)
    local startTime4Three1 = SplitStringWithSeparator(startTime4Three, " ")
    local startTime4ThreeData = SplitStringWithSeparator(startTime4Three1[1], "%.", nil, true)
    SceneCity.startTime4TwoData = startTime4TwoData
    SceneCity.startTime4ThreeData = startTime4ThreeData
    local startTime4OneTime = SplitStringWithSeparator(SplitStringWithSeparator(startTime4One, " ")[2], ":", nil, true)
    local endTime4OneTime = SplitStringWithSeparator(SplitStringWithSeparator(endTime4One, " ")[2], ":", nil, true)
    local startTime4TwoTime = SplitStringWithSeparator(SplitStringWithSeparator(startTime4Two, " ")[2], ":", nil, true)
    local endTime4TwoTime = SplitStringWithSeparator(SplitStringWithSeparator(endTime4Two, " ")[2], ":", nil, true)
    local startTime4ThreeTime = SplitStringWithSeparator(SplitStringWithSeparator(startTime4Three, " ")[2], ":", nil, true)
    local endTime4ThreeTime = SplitStringWithSeparator(SplitStringWithSeparator(endTime4Three, " ")[2], ":", nil, true)
    SceneCity.startTime4OneData = startTime4OneData
    SceneCity.startTime4OneTime = startTime4OneTime
    SceneCity.endTime4OneTime = endTime4OneTime
    SceneCity.startTime4TwoTime = startTime4TwoTime
    SceneCity.endTime4TwoTime = endTime4TwoTime
    SceneCity.startTime4ThreeTime = startTime4ThreeTime
    SceneCity.endTime4ThreeTime = endTime4ThreeTime
    if SceneCity.startTime4OneTime[2] < 10 then
        SceneCity.startTime4OneTime[1] = SceneCity.startTime4OneTime[1] - 1
        SceneCity.startTime4OneTime[2] = 60 - (10 - SceneCity.startTime4OneTime[2])
    else
        SceneCity.startTime4OneTime[2] = SceneCity.startTime4OneTime[2] - 10
    end
    if SceneCity.startTime4TwoTime[2] < 10 then
        SceneCity.startTime4TwoTime[1] = SceneCity.startTime4TwoTime[1] - 1
        SceneCity.startTime4TwoTime[2] = 60 - (10 - SceneCity.startTime4TwoTime[2])
    else
        SceneCity.startTime4TwoTime[2] = SceneCity.startTime4TwoTime[2] - 10
    end
    if SceneCity.startTime4ThreeTime[2] < 10 then
        SceneCity.startTime4ThreeTime[1] = SceneCity.startTime4ThreeTime[1] - 1
        SceneCity.startTime4ThreeTime[2] = 60 - (10 - SceneCity.startTime4ThreeTime[2])
    else
        SceneCity.startTime4ThreeTime[2] = SceneCity.startTime4ThreeTime[2] - 10
    end
    WZLog("ProtocolProcessorSceneCity:parse_HERO_HeroStartTimeOk1_4", "startTime4OneData", Serialize(startTime4OneData), 
        "startTime4OneTime", Serialize(startTime4OneTime), "endTime4OneTime", Serialize(endTime4OneTime), 
        "startTime4TwoTime", Serialize(startTime4TwoTime), "endTime4TwoTime", Serialize(endTime4TwoTime), 
        "startTime4ThreeTime", Serialize(startTime4ThreeTime), "endTime4ThreeTime", Serialize(endTime4ThreeTime))

    local startTimeFOne1 = SplitStringWithSeparator(startTimeFOne, " ")
    local startTimeFOneData = SplitStringWithSeparator(startTimeFOne1[1], "%.", nil, true)
    local startTimeFTwo1 = SplitStringWithSeparator(startTimeFTwo, " ")
    local startTimeFTwoData = SplitStringWithSeparator(startTimeFTwo1[1], "%.", nil, true)
    local startTimeFThree1 = SplitStringWithSeparator(startTimeFThree, " ")
    local startTimeFThreeData = SplitStringWithSeparator(startTimeFThree1[1], "%.", nil, true)
    SceneCity.startTimeFTwoData = startTimeFTwoData
    SceneCity.startTimeFThreeData = startTimeFThreeData
    local startTimeFOneTime = SplitStringWithSeparator(SplitStringWithSeparator(startTimeFOne, " ")[2], ":", nil, true)
    local endTimeFOneTime = SplitStringWithSeparator(SplitStringWithSeparator(endTimeFOne, " ")[2], ":", nil, true)
    local startTimeFTwoTime = SplitStringWithSeparator(SplitStringWithSeparator(startTimeFTwo, " ")[2], ":", nil, true)
    local endTimeFTwoTime = SplitStringWithSeparator(SplitStringWithSeparator(endTimeFTwo, " ")[2], ":", nil, true)
    local startTimeFThreeTime = SplitStringWithSeparator(SplitStringWithSeparator(startTimeFThree, " ")[2], ":", nil, true)
    local endTimeFThreeTime = SplitStringWithSeparator(SplitStringWithSeparator(endTimeFThree, " ")[2], ":", nil, true)
    SceneCity.startTimeFOneData = startTimeFOneData
    SceneCity.startTimeFOneTime = startTimeFOneTime
    SceneCity.endTimeFOneTime = endTimeFOneTime
    SceneCity.startTimeFTwoTime = startTimeFTwoTime
    SceneCity.endTimeFTwoTime = endTimeFTwoTime
    SceneCity.startTimeFThreeTime = startTimeFThreeTime
    SceneCity.endTimeFThreeTime = endTimeFThreeTime
    if SceneCity.startTimeFOneTime[2] < 10 then
        SceneCity.startTimeFOneTime[1] = SceneCity.startTimeFOneTime[1] - 1
        SceneCity.startTimeFOneTime[2] = 60 - (10 - SceneCity.startTimeFOneTime[2])
    else
        SceneCity.startTimeFOneTime[2] = SceneCity.startTimeFOneTime[2] - 10
    end
    if SceneCity.startTimeFTwoTime[2] < 10 then
        SceneCity.startTimeFTwoTime[1] = SceneCity.startTimeFTwoTime[1] - 1
        SceneCity.startTimeFTwoTime[2] = 60 - (10 - SceneCity.startTimeFTwoTime[2])
    else
        SceneCity.startTimeFTwoTime[2] = SceneCity.startTimeFTwoTime[2] - 10
    end
    if SceneCity.startTimeFThreeTime[2] < 10 then
        SceneCity.startTimeFThreeTime[1] = SceneCity.startTimeFThreeTime[1] - 1
        SceneCity.startTimeFThreeTime[2] = 60 - (10 - SceneCity.startTimeFThreeTime[2])
    else
        SceneCity.startTimeFThreeTime[2] = SceneCity.startTimeFThreeTime[2] - 10
    end
    WZLog("ProtocolProcessorSceneCity:parse_HERO_HeroStartTimeOk1_5", "startTimeFOneData", Serialize(startTimeFOneData), "startTimeFThreeData", Serialize(startTimeFThreeData), 
        "startTimeFOneTime", Serialize(startTimeFOneTime), "endTimeFOneTime", Serialize(endTimeFOneTime), 
        "startTimeFTwoTime", Serialize(startTimeFTwoTime), "endTimeFTwoTime", Serialize(endTimeFTwoTime), 
        "startTimeFThreeTime", Serialize(startTimeFThreeTime), "endTimeFThreeTime", Serialize(endTimeFThreeTime))

    WZLog("ProtocolProcessorSceneCity:parse_HERO_HeroStartTimeOk2", tab.year, tab.month, tab.day, tab.hour, tab.min, tab.sec)
    WZLog("ProtocolProcessorSceneCity:parse_HERO_HeroStartTimeOk3", tabStart.year, tabStart.month, tabStart.day, tabStart.hour, tabStart.min, tabStart.sec)
    WZLog("ProtocolProcessorSceneCity:parse_HERO_HeroStartTimeOk4", tabEnd.year, tabEnd.month, tabEnd.day, tabEnd.hour, tabEnd.min, tabEnd.sec)
    WndOwnCity:openLeague()
end

--@brief    获取宝箱列表（CARD_GetCardSetListOk = 10）
function ProtocolProcessorSceneCity:parse_CARD_GetCardSetListOk(cardSetId, count, cdTime, openNum)
    -- cardSetId : 宝箱id
    -- count : 宝箱数量
    -- cdTime : 宝箱CD（秒）
    -- openNum : 可开启数量
    
    cardSetId = VectorToTable(cardSetId)
    count = VectorToTable(count)
    WZLog("ProtocolProcessorSceneCity:parse_CARD_GetCardSetListOk", cdTime, #cardSetId, openNum, Serialize(count))
    local card = false
    if cdTime == 0 and #cardSetId > 0 and CheckButtonOpen(ISLAND_EXTEND_CARD,false) then
        for k,v in pairs(count) do
            if v > 0 then
                card = true
                break
            end
        end
    end
    CacheCenter:setRedState("btnCard_ExtendUp",card,56)
    GlobalGame:getBtnRedPointEvent():dispatcher()
end

--@brief	装备免费抽奖剩余时间（EQUIP_GetFreeTimeOK = 15）
function ProtocolProcessorSceneCity:parse_EQUIP_GetFreeTimeOK(leaveTime, lotteryTime)
    -- leaveTime : 剩余时间
    -- lotteryTime : 剩余次数比抽中紫装
    local isShowRed = WndEquipmentLottery:isShowRed()
    WZLog("ProtocolProcessorSceneCity:parse_EQUIP_GetFreeTimeOK", leaveTime, tostring(isShowRed))

    -- SceneCity:updateRedDotBuilding("EquipLove", isShowRed or leaveTime == 0, GlobalMethod:ccp(100,40))
    -- WndSummonEntrance:updateRedPoint(isShowRed or leaveTime == 0)
end

--@brief	获取活跃值信息成功（GetActiveInfoOk = 2）
function ProtocolProcessorSceneCity:parse_GetActiveInfoOk(activityId, complStatus, activeNum, awardId, awardStatus,serverTime,standard,progress)
    -- activityId : 活动编号
    -- complStatus : 完成状态 1：未开启(等级不够) 2：未开启(时间未达到) 3：未完成  4：已完成
    -- activeNum : 总活跃值
    -- awardId : 奖励编号
    -- awardStatus : 奖励状态 -1：不可领取 0：可以领取  1：已领取
    -- serverTime : 服务端时间
    -- standard : 完成标准
    -- progress : 完成进度
    WZLog("ProtocolProcessorSceneCity:parse_GetActiveInfoOk", Serialize(VectorToTable(awardId)), Serialize(VectorToTable((awardStatus))))
    WndOwnCity:getActiveInfo(VectorToTable(awardId),VectorToTable(awardStatus))
end

--@brief	更新小红点（PLAYER_UpdateRedDot = 62）
function ProtocolProcessorSceneCity:parse_PLAYER_UpdateRedDot(redDotType, redDotValue, activityType, welfareType, yearActivityType, spokeManActivityType, wonderfulActivityType)
    -- redDotType : 对应tab_interface
    -- redDotValue : 小红点的值，0、不用显示，大于0显示小红点
    -- welfareType : 福利小红点
    -- yearActivityType : 周年庆活动红点
    -- spokeManActivityType : 代言人活动红点
    WZLog("ProtocolProcessorSceneCity:parse_PLAYER_UpdateRedDot", redDotType:size(), redDotValue:size())
    CacheCenter.m_tActivityItemRedDotList = {}
    CacheCenter.m_tBackActivityRedDotList = {}
    GlobalGame.g_tRedPointList.investRebate = false
    GlobalGame.g_tRedPointList.oneYuanRecharge = false
    GlobalGame.g_tRedPointList.qixiActivity = false
    GlobalGame.g_tRedPointList.crazyDoubling = false
    GlobalGame.g_tRedPointList.FestivalLoginActivity = false
    GlobalGame.g_tRedPointList.FestivalAnswerActivity = false
    GlobalGame.g_tRedPointList.PeopleShopActivity = false
    GlobalGame.g_tRedPointList.treasureMainRedPoint = false
    GlobalGame.g_tRedPointList.everyDayBuyRedPoint = false
    GlobalGame.g_tRedPointList.newyearRedPoint = false
    GlobalGame.g_tRedPointList.fourStarRedPoint = false
    GlobalGame.g_tRedPointList.blindRedPoint = false
    GlobalGame.g_tRedPointList.dollMachineRedPoint = false
    GlobalGame.g_tRedPointList.limitLoginRedPoint = false
    GlobalGame.g_tRedPointList.firstRedPoint = false
    CacheCenter.m_tFreecaRedDotList = {}
    CacheCenter.m_tActivityBluePriRedDotList = {}
    CacheCenter.m_tActivityHallPriRedDotList = {}
    for i = 0, activityType:size() - 1 do
        if activityType:get(i) == 5016 or activityType:get(i) == 5017 or activityType:get(i) == 5018 
            or activityType:get(i) == 5020 or activityType:get(i) == 5021 or activityType:get(i) == 5022 or activityType:get(i) == 5023 
            or activityType:get(i) == 5024 or activityType:get(i) == 5025 or activityType:get(i) == 5026 then 
            table.insert(CacheCenter.m_tBackActivityRedDotList, activityType:get(i))
        elseif activityType:get(i) == g_tGameActivityTypes.ACTIVITY_INVESTREBATE then 
            GlobalGame.g_tRedPointList.investRebate = true
        elseif activityType:get(i) == g_tGameActivityTypes.ACTIVITY_HAPPYSHAKE then 
            GlobalGame.g_tRedPointList.happyShake = true
        elseif activityType:get(i) == g_tGameActivityTypes.ACTIVITY_ONE_RECHARGE then --一元冲活动
            GlobalGame.g_tRedPointList.oneYuanRecharge = true
        elseif activityType:get(i) == g_tGameActivityTypes.ACTIVITY_QIXI then --七夕活动
            GlobalGame.g_tRedPointList.qixiActivity = true
        elseif activityType:get(i) == 6110 then
            GlobalGame.g_tRedPointList.FestivalLoginActivity = true
        elseif activityType:get(i) == 6111 then
            GlobalGame.g_tRedPointList.FestivalAnswerActivity = true
        elseif activityType:get(i) == 6116 then
            GlobalGame.g_tRedPointList.PeopleShopActivity = true
        elseif activityType:get(i) == 6118 then
            GlobalGame.g_tRedPointList.treasureMainRedPoint = true
        elseif activityType:get(i) == 6119 then
            GlobalGame.g_tRedPointList.everyDayBuyRedPoint = true
        elseif activityType:get(i) == 6120 then
            GlobalGame.g_tRedPointList.newyearRedPoint = true
        elseif activityType:get(i) == g_tGameActivityTypes.ACTIVITY_MONDAY_PLAN_CARD then --周一计划卡
            table.insert(CacheCenter.m_tFreecaRedDotList, activityType:get(i))
        elseif activityType:get(i) == g_tGameActivityTypes.ACTIVITY_CRAZY_DOUBLING then 
            GlobalGame.g_tRedPointList.crazyDoubling = true
        elseif activityType:get(i) == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_WELFARE or activityType:get(i) == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_SIGNIN or 
            activityType:get(i) == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE then 
            if GlobalMethod:getIsShowOVAmberPlayer() then
                table.insert(CacheCenter.m_tActivityItemRedDotList, activityType:get(i))
            end
        elseif activityType:get(i) == 7004 or activityType:get(i) == 7005 or activityType:get(i) == 7006 or activityType:get(i) == 7007 or activityType:get(i) == 7011 then
            WndNewYearActivityMain:setRedPointStatus(activityType:get(i), true)
        elseif activityType:get(i) == 7008 then
            GlobalGame.g_tRedPointList.fourStarRedPoint = true   
        elseif activityType:get(i) == 7009 then
            GlobalGame.g_tRedPointList.blindRedPoint = true 
        elseif activityType:get(i) == 7010 then
            GlobalGame.g_tRedPointList.dollMachineRedPoint = true
        elseif activityType:get(i) == 7013 then
            GlobalGame.g_tRedPointList.limitLoginRedPoint = true
        elseif activityType:get(i) == 7012 then
            GlobalGame.g_tRedPointList.firstRedPoint = true
        elseif activityType:get(i) == 7014 or activityType:get(i) == 7015 or activityType:get(i) == 7016 then
            WndReturnActivityMain:setReturnRedPointStatus(activityType:get(i), true)
        elseif activityType:get(i) == 7018 then
        elseif activityType:get(i) == 7020 then
            GlobalGame.g_tRedPointList["redDot_" .. activityType:get(i)] = true
        elseif (activityType:get(i) >= 7023 and activityType:get(i) <= 7037 and activityType:get(i) ~= 7032) or (activityType:get(i) >= 7046 and activityType:get(i) <= 7052) or (activityType:get(i) >= 7054 and activityType:get(i) <= 7063) or activityType:get(i) == 7065 or activityType:get(i) == 7067 or activityType:get(i) == 7068 or (activityType:get(i) >= 7070 and activityType:get(i) <= 7108 and activityType:get(i) ~= 7085) then 
        elseif activityType:get(i) == 7038 or activityType:get(i) == 7039 or activityType:get(i) == 7040 then 
            table.insert(CacheCenter.m_tActivityBluePriRedDotList, activityType:get(i))
        elseif activityType:get(i) == 7041 or activityType:get(i) == 7042 or activityType:get(i) == 7043 then 
            table.insert(CacheCenter.m_tActivityHallPriRedDotList, activityType:get(i))
        else
            table.insert(CacheCenter.m_tActivityItemRedDotList, activityType:get(i))
        end
    end
    CacheCenter.m_tYearActivityItemRedDotList = yearActivityType and VectorToTable(yearActivityType) or {}
    CacheCenter.m_tApartmentRedDotList = spokeManActivityType and VectorToTable(spokeManActivityType) or {}
    WZLog("==============活动红点信息===="..#CacheCenter.m_tActivityItemRedDotList, Serialize(CacheCenter.m_tActivityItemRedDotList),Serialize(VectorToTable(activityType)), Serialize(VectorToTable(redDotType)))

    local tWelfareType = VectorToTable(welfareType)
    for i = 1, #tWelfareType do
        if tWelfareType[i] == 7013 then
            GlobalGame.g_tRedPointList.limitLoginRedPoint = true
            table.remove(tWelfareType, i)
            break
        end
    end
    
    CacheCenter.m_tWelfareItemRedDotList = tWelfareType
    CacheCenter.m_tWonderfulRedDotList = VectorToTable(wonderfulActivityType) --精彩推荐红点列表

    WZLog("==============福利红点信息===="..#CacheCenter.m_tWelfareItemRedDotList,Serialize(VectorToTable(welfareType)))
    if #CacheCenter.m_tActivityItemRedDotList > 0 or #CacheCenter.m_tWelfareItemRedDotList > 0 or #CacheCenter.m_tFreecaRedDotList > 0 or #CacheCenter.m_tWonderfulRedDotList > 0 then 
        GlobalGame:getBtnRedPointEvent():dispatcher("GameActivity",true)
        WZLog("CacheCenter.m_tActivityItemRedDotList 1")
    else 
        GlobalGame:getBtnRedPointEvent():dispatcher("GameActivity",false)
        WZLog("CacheCenter.m_tActivityItemRedDotList 3")
    end

    -- 保存红点的状态
    CacheCenter.m_tRedPointInfo = {}
    local redType = VectorToTable(redDotType)
    local redState = VectorToTable(redDotValue)
    for i = 1, #redType do
        if redType[i] == 17008 or redType[i] == 27008 then
            WndFourStar:setFourStarRedPoint(redType[i],redState[i])
        else
            local info = {type = redType[i], state = redState[i]}
            table.insert(CacheCenter.m_tRedPointInfo,info)
        end
    end
    SceneCity:updateRedDot(VectorToTable(redDotType), VectorToTable(redDotValue) , VectorToTable(activityType), VectorToTable(welfareType))
end

--@brief	取消小红点（PLAYER_CancelRedDotOK = 64）
function ProtocolProcessorSceneCity:parse_PLAYER_CancelRedDotOK()
    WZLog("ProtocolProcessorSceneCity:parse_PLAYER_CancelRedDotOK")
end

--@brief	返回玩家场景显示信息（PLAYER_PlayerSceneInfo = 67）
function ProtocolProcessorSceneCity:parse_PLAYER_PlayerSceneInfo(playerId, playerSex,  playerLevel, playerName , playerTitle, headId, faceId, bodyId, wingId, petId, mountsId, isMate, sceneId, petLevel, colour, bodyColour,footmark, petSkinItemId, childMes, professionId, openStatus, qqHallInfo)
	-- playerId : 角色id                                                 
	-- playerLevel : 角色等级                                               
	-- playerName  : 角色名称                                               
	-- playerTitle : 角色称号                                               
	-- headId : 角色头部装备id                                         
	-- faceId : 角色脸部装备Id                                         
	-- bodyId : 角色身体装备id                                         
	-- wingId : 角色翅膀装备id                                         
	-- petId : 角色宠物id                                             
	-- mountsId : 角色坐骑id
    -- footmark : 足迹
    -- petSkinItemId : 宠物幻型物品Id, 没有幻型为0
    -- childMes : 小孩数据
    -- professionId : 玩家职业Id
    -- openStatus : 0未开启，1职业一转，2职业二转
	WZLog("ProtocolProcessorSceneCity:parse_PLAYER_PlayerSceneInfo one", GlobalGame.g_nCurrentUIChannelId)

    if FigureSceneManager:getInstance().m_bIsCreateOtherFigure then
        return
    end

    playerId = VectorToTable(playerId)
    playerSex = VectorToTable(playerSex)
    playerLevel = VectorToTable(playerLevel)
    playerName = VectorToTable(playerName)
    playerTitle = VectorToTable(playerTitle)
    headId = VectorToTable(headId)
    faceId = VectorToTable(faceId)
    bodyId = VectorToTable(bodyId)
    wingId = VectorToTable(wingId)
    petId = VectorToTable(petId)
    mountsId = VectorToTable(mountsId)
    isMate = VectorToTable(isMate)
    sceneId =  sceneId and VectorToTable(sceneId)
    petLevel = VectorToTable(petLevel)
    colour = VectorToTable(colour)
    bodyColour = VectorToTable(bodyColour)
    footmark = VectorToTable(footmark)
    petSkinItemId = VectorToTable(petSkinItemId)
    childMes = VectorToTable(childMes)
    professionId = VectorToTable(professionId)
    openStatus = VectorToTable(openStatus)
    qqHallInfo = VectorToTable(qqHallInfo)

    if playerSex == nil then
        playerSex = {}
    end

    local sceneFigureInfoList = {}
    for i = 1, #playerId do
        local _sceneId = sceneId or -1
        local qqHallData = nil 
        if qqHallInfo and qqHallInfo[i] ~= "" then 
            qqHallData = json.decode(qqHallInfo[i])
        end
        table.insert(sceneFigureInfoList,{
            playerId=playerId[i], playerSex=playerSex[i],playerLevel=playerLevel[i],
            playerName=playerName[i], playerTitle=playerTitle[i],
            headId=headId[i], faceId=faceId[i],
            bodyId=bodyId[i], wingId=wingId[i],
            petId=petId[i], mountsId=mountsId[i]~="" and tonumber(mountsId[i]) or 0, 
            isMate=isMate[i], sceneId=_sceneId, petLevel=petLevel[i],
            colour=colour[i], bodyColour=bodyColour[i] , footmark = footmark[i], petSkinItemId = petSkinItemId[i], childMes = childMes[i], professionId = professionId[i], openStatus = openStatus[i], qqHallData = qqHallData})
--        WZLog("ProtocolProcessorSceneCity:parse_PLAYER_PlayerSceneInfo two", playerName[i],professionId[i],openStatus[i],childMes[i])
    end

    FigureSceneManager:getInstance():saveOtherFigures(sceneFigureInfoList)
end

--@brief   请求玩家额外信息返回（PLAYER_GetPlayerExtInfoOk = 118）
function ProtocolProcessorSceneCity:parse_PLAYER_GetPlayerExtInfoOk(extInfo)
    --body
    --extInfo : json类型，包含字段：magicStoneStatus 0:关闭 1：开启;IRStatus:0->关闭，其他（活动Id）打开;activityPokerStatus:
    g_cityExtenInfo = json.decode(extInfo)
    WZLog("parse_PLAYER_GetPlayerExtInfoOk",extInfo)
    if WndOwnCity.m_root then 
        WndOwnCity:setExtraInfoForBtn()
    end
    if WndActivityIntegrate.m_root then
        WndActivityIntegrate:updateUI()
    end
    local status = g_cityExtenInfo.DiscountStoreStatus
    GlobalGame.g_isSterious = status
    SceneCity:openSterious(status == 1)

    local state = g_cityExtenInfo.ActivityWorldCup
    GlobalGame.g_autoFootballActivity = state
    if WndOwnCity.openFootball then
        WndOwnCity:openFootball(state == 1)
    end

    state = g_cityExtenInfo.ActivitySpokesman
    GlobalGame.g_autoLouraActivity = state
    SceneCity:openLouyixiao(state == 1)
    SceneCity:delayCheckLoginWnd()
end
--@brief    获取弹弹宝典信息
function ProtocolProcessorSceneCity:parse_PLAYER_GetPlayerAnswerInfoOk(status)
    -- status : 初\中\高级的答题状态  0未答题 1已答题
    WZLog("ProtocolProcessorSceneCity:parse_PLAYER_GetPlayerAnswerInfoOk")
    GlobalGame:getBattleEventDispatcher():Dispatch("STRONG_NOVICE_ANSWER", VectorToTable(status))
end
--@brief    提交弹弹宝典答案
function ProtocolProcessorSceneCity:parse_PLAYER_SubmitPlayerAnswerOk(answerType, result, rewardNum, rewardId, rewardCount)
    -- result : 1成功 | 2失败
    -- rewardNum : 奖励物品种类
    -- rewardId : 奖励物品id
    -- rewardCount : 奖励物品数量
    WZLog("ProtocolProcessorSceneCity:parse_PLAYER_SubmitPlayerAnswerOk",answerType, result)
    if result == 1 then
        GlobalGame:getBattleEventDispatcher():Dispatch("STRONG_SBUMIT_ANSWER", VectorToTable(rewardId),VectorToTable(rewardCount), answerType)
    elseif result == 2 then
        
    end
end

-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	获得小红点（PLAYER_GetUpdateRedDot = 70）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCity:send_PLAYER_GetUpdateRedDot_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneCity:send_PLAYER_GetUpdateRedDot_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetUpdateRedDot, nflag, sMessage)
end

--@brief	取消小红点（PLAYER_CancelRedDot = 63）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_CancelRedDot, nflag, sMessage)
end

--@brief    请求玩家额外信息（PLAYER_GetPlayerExtInfo = 117）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSceneCity:send_PLAYER_GetPlayerExtInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneCity:send_PLAYER_GetPlayerExtInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerExtInfo, nflag, sMessage)
end
--@brief    获取弹弹宝典信息错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSceneCity:send_PLAYER_GetPlayerAnswerInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneCity:send_PLAYER_GetPlayerAnswerInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerAnswerInfo, nflag, sMessage)
end
--@brief    提交弹弹宝典答案错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorSceneCity:send_PLAYER_SubmitPlayerAnswer_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneCity:send_PLAYER_SubmitPlayerAnswer_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_SubmitPlayerAnswer, nflag, sMessage)
end
-------------------------------------公有方法模块End----------------------------------------


