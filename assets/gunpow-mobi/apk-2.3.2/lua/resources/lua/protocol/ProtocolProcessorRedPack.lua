--ProtocolProcessorRedPack.lua
--@brief    红包协议
--@date     2017/01/20
--@author   Tianxiang_Xu


ProtocolProcessorRedPack = ProtocolProcessorBase:new()
-------------------------------------公有方法模块--------------------------------------
--@brief    注册协议组所有协议
function ProtocolProcessorRedPack:regAll()
    --@brief    收到口令红包（ACTIVITY_ReceiveCommandRedPacket = 9）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_ReceiveCommandRedPacket, "ProtocolProcessorRedPack:parse_ACTIVITY_ReceiveCommandRedPacket", "vi")
    --@brief    领取口令红包-结果（ACTIVITY_DrawCommandeRedPacketOk = 11）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawCommandeRedPacketOk, "ProtocolProcessorRedPack:parse_ACTIVITY_DrawCommandeRedPacketOk", "is")
    --@brief    推送定时红包（ACTIVITY_PushScheduledRedPacket = 13)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_PushScheduledRedPacket, "ProtocolProcessorRedPack:parse_ACTIVITY_PushScheduledRedPacket", "vit")
    --@brief    领取定时红包-结果（ACTIVITY_DrawScheduledRedPacketOk = 15）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawScheduledRedPacketOk, "ProtocolProcessorRedPack:parse_ACTIVITY_DrawScheduledRedPacketOk", "is")
    --@brief    使用烟花-结果（ACTIVITY_UseFireworkOk = 17）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_UseFireworkOk, "ProtocolProcessorRedPack:parse_ACTIVITY_UseFireworkOk", "")
    --@brief    推送烟花（ACTIVITY_PushFirework = 18）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_PushFirework, "ProtocolProcessorRedPack:parse_ACTIVITY_PushFirework", "ti")
    --@brief    活动通用操作协议（ACTIVITY2_ActivityDoOk = 108）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ActivityDoOk, "ProtocolProcessorRedPack:parse_ACTIVITY2_ActivityDoOk", "iiiis")

    --@brief    领取口令红包（ACTIVITY_DrawCommandeRedPacket = 10）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawCommandeRedPacket, "ProtocolProcessorRedPack:send_ACTIVITY_DrawCommandeRedPacket_ErrorProcess", "is" )
    --@brief    领取定时红包（ACTIVITY_DrawScheduledRedPacket = 14）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawScheduledRedPacket, "ProtocolProcessorRedPack:send_ACTIVITY_DrawScheduledRedPacket_ErrorProcess", "is" )
    --@brief    使用烟花（ACTIVITY_UseFirework = 16）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_UseFirework, "ProtocolProcessorRedPack:send_ACTIVITY_UseFirework_ErrorProcess", "is" )

end


--@brief    反注册协议组所有协议
function ProtocolProcessorRedPack:unregAll()
    self:clearReg()
end


-------------------------------------客户端到服务器协议发送方法模块------------------------
--@brief    领取口令红包（ACTIVITY_DrawCommandeRedPacket = 10）
function ProtocolProcessorRedPack:send_ACTIVITY_DrawCommandeRedPacket(id )
    WZLog("send_ACTIVITY_DrawCommandeRedPacket")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawCommandeRedPacket )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( id )   -- 目标红包id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取定时红包（ACTIVITY_DrawScheduledRedPacket = 14）
function ProtocolProcessorRedPack:send_ACTIVITY_DrawScheduledRedPacket(id )
    WZLog("send_ACTIVITY_DrawScheduledRedPacket")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawScheduledRedPacket )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( id )   -- 红包id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    使用烟花（ACTIVITY_UseFirework = 16）
function ProtocolProcessorRedPack:send_ACTIVITY_UseFirework(size )
    WZLog("send_ACTIVITY_UseFirework")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_UseFirework )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( size )    -- 烟花类型(1:小,2:中,3:大)
    SendProtocol(sender,false) --true:showLoading
end

------------------------------协议接收处理方法模块--------------------------------------
--@brief    收到口令红包（ACTIVITY_ReceiveCommandRedPacket = 9）
function ProtocolProcessorRedPack:parse_ACTIVITY_ReceiveCommandRedPacket(id)
    -- id : id
    WZLog("ProtocolProcessorRedPack:parse_ACTIVITY_ReceiveCommandRedPacket")
    for i = 0, id:size() - 1 do
        table.insert(g_tRedPackList, id:get(i))
    end
    WZLog("parse_ACTIVITY_ReceiveCommandRedPacket", Serialize(g_tRedPackList))
    if SceneCity.m_root then
        ShowRedEnvelopesRain(2)
    end
end

--@brief    领取口令红包-结果（ACTIVITY_DrawCommandeRedPacketOk = 11）
function ProtocolProcessorRedPack:parse_ACTIVITY_DrawCommandeRedPacketOk(id, reward)
    -- id : 红包id
    -- reward : 奖励
    WZLog("ProtocolProcessorRedPack:parse_ACTIVITY_DrawCommandeRedPacketOk")
    for i = 1, #g_tRedPackList do
        if g_tRedPackList[i] == id then
            table.remove(g_tRedPackList, i)
            break 
        end
    end

    local vnId, vnNum = SplitItemString(reward)
    WndRewardShow:showById(vnId,vnNum)
    --WndRewardShow:closeCallBack(WndGameActivity,WndGameActivity.getRedPackOKClose) 
    WndRewardShow:closeCallBack(WndNewActivity,WndNewActivity.getRedPackOKClose)
end

--@brief    推送定时红包（ACTIVITY_PushScheduledRedPacket = 13)
function ProtocolProcessorRedPack:parse_ACTIVITY_PushScheduledRedPacket(id, pushType)
    -- id : 红包id
    -- pushType : 推送类型,0:新红包,1:登录存在未领取红包
    WZLog("ProtocolProcessorRedPack:parse_ACTIVITY_PushScheduledRedPacket", pushType, Serialize(VectorToTable(id)))
	ENVELOPES = VectorToTable(id)
	ShowRedEnvelopesRain()
end

--@brief    领取定时红包-结果（ACTIVITY_DrawScheduledRedPacketOk = 15）
function ProtocolProcessorRedPack:parse_ACTIVITY_DrawScheduledRedPacketOk(id, reward)
    -- id : 红包id
    -- reward : 奖励内容
    WZLog("ProtocolProcessorRedPack:parse_ACTIVITY_DrawScheduledRedPacketOk", reward)
	if id == nil then return end
	if reward == nil or reward == "" then return end
	table.remove(ENVELOPES, 1)
	local ids, nums = SplitItemString(reward)
	if ids ~= nil and #ids ~= 0 then
		WndRewardShow:showById(ids, nums)
        --WndRewardShow:closeCallBack(WndGameActivity,WndGameActivity.getRedPackOKClose)
        WndRewardShow:closeCallBack(WndNewActivity,WndNewActivity.getRedPackOKClose)
	end
end

--@brief    使用烟花-结果（ACTIVITY_UseFireworkOk = 17）
function ProtocolProcessorRedPack:parse_ACTIVITY_UseFireworkOk()
    WZLog("ProtocolProcessorRedPack:parse_ACTIVITY_UseFireworkOk")
	--WndGameActivity:refreshActivityContext()
    --WndNewActivity:refreshActivityContext()	
end

--@brief    推送烟花（ACTIVITY_PushFirework = 18）
function ProtocolProcessorRedPack:parse_ACTIVITY_PushFirework(size, playerId)
    -- size : 烟花类型(1:小,2:中,3:大)
    -- playerId : 使用玩家id
    WZLog("ProtocolProcessorRedPack:parse_ACTIVITY_PushFirework", size,playerId)
	if (SETSHOWFIREWORK == 0 and CacheCenter:getPlayerInfo().id ~= playerId) or (SceneBattle and SceneBattle.m_root ~= nil) then return end
	
    --老烟花
    if size == 1 then
		table.insert(FIREWORKS, size)
		if #FIREWORKS == 1 and FIREWORKTIME <= 0 then
		FIREWORKTIME = 40
		FIREWORKINTERVAL = 0.1
		ShowFirework(1)
		end
	elseif size == 2 then
		table.insert(FIREWORKS, size)
		if #FIREWORKS == 1 and FIREWORKTIME <= 0 then
		FIREWORKTIME = 80
		FIREWORKINTERVAL = 0.1
		ShowFirework(2)
		end
	elseif size == 3 then
		table.insert(FIREWORKS, size)
		if #FIREWORKS == 1 and FIREWORKTIME <= 0 then
		FIREWORKTIME = 80
		FIREWORKINTERVAL = 0.15
		ShowFirework(3)
		end
	end

    -- --7周年烟花
    -- --添加一个背景图片遮罩，注意order <= 后面烟花容器的order(99999)
    -- WindowManager:addBackgroundImg(99998, 150)
    -- if size == 1 then
    --     table.insert(FIREWORKS, size)
    --     if #FIREWORKS == 1 and FIREWORKTIME <= 0 then
    --         FIREWORKTIME = 4
    --         FIREWORKINTERVAL = 1
    --         ShowFirework_7zn(1)
    --     end
    -- elseif size == 2 then
    --     table.insert(FIREWORKS, size)
    --     if #FIREWORKS == 1 and FIREWORKTIME <= 0 then
    --         FIREWORKTIME = 10
    --         FIREWORKINTERVAL = 1
    --         ShowFirework_7zn(2)
    --     end
    -- elseif size == 3 then
    --     table.insert(FIREWORKS, size)
    --     if #FIREWORKS == 1 and FIREWORKTIME <= 0 then
    --         FIREWORKTIME = 12
    --         FIREWORKINTERVAL = 1
    --         ShowFirework_7zn(3)
    --     end
    -- end
end

--@brief    活动通用操作协议（ACTIVITY2_ActivityDoOk = 108）
function ProtocolProcessorRedPack:parse_ACTIVITY2_ActivityDoOk(activityId, activityType, doType, result, strJson)
    -- activityId : 活动id
    -- activityType : 活动类型
    -- doType : 操作类型
    -- result : 操作结果
    -- json : json格式内容{}
--    WZLog("ProtocolProcessorRedPack:parse_ACTIVITY2_ActivityDoOk", doType, result, strJson)
    if activityType == 7062 then 
        if doType == 10 then 
            if SceneBattle.m_root or SceneBattleLoading.m_root then return end 
            local tResult = json.decode(strJson)
            if SETSHOWREDPACKRAIN == 1 and tResult.playerId ~= CacheCenter:getPlayerInfo().id then return end 
            
            local tItem = {activityId, tResult.redPacketId}
            table.insert(WORSHIPGOD_ENVELOPES, tItem)
            ShowRedEnvelopesRain()
        elseif doType == 11 then 
            table.remove(WORSHIPGOD_ENVELOPES, 1)
            if result == 1 then 
                local tResult = json.decode(strJson)
                local resultData = {}
                resultData.playerId = tResult.playerId
                resultData.itemId = 70
                resultData.itemNum = tResult.money
                resultData.headId = tResult.headId
                resultData.faceId = tResult.faceId
                resultData.sex = tResult.sex
                resultData.vipLevel = tResult.vipLevel
                resultData.headColor = tResult.headColor
                resultData.headEffectId = tResult.profileFrame
                resultData.playerName = tResult.playerName
                resultData.wishWorldsId = tResult.wishWorldsId
                
                WndChallengeLevel:showInterface(4, 0, 0, resultData)
            elseif result == 2 then --已经抢过了
                MsgBoxManager:showTipBox(LocalStrings.RED_PACK7)
                ShowRedEnvelopesRain()
            elseif result == 3 then --手慢了，已经被抢光了
                MsgBoxManager:showTipBox(LocalStrings.RED_PACK5[1])
                ShowRedEnvelopesRain()
            else
                ShowRedEnvelopesRain()
            end
        end
    elseif activityType == 7068 then
        if doType == 6 then
            local tResult = json.decode(strJson)
            WndRewardShow:showById(tResult.itemId, tResult.itemNum)
        end
    end
end
-------------------------------协议错误处理方法模块--------------------------------------
--@brief    领取口令红包（ACTIVITY_DrawCommandeRedPacket = 10）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorRedPack:send_ACTIVITY_DrawCommandeRedPacket_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRedPack:send_ACTIVITY_DrawCommandeRedPacket_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawCommandeRedPacket, nflag, sMessage)
end

--@brief    领取定时红包（ACTIVITY_DrawScheduledRedPacket = 14）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorRedPack:send_ACTIVITY_DrawScheduledRedPacket_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRedPack:send_ACTIVITY_DrawScheduledRedPacket_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_DrawScheduledRedPacket, nflag, sMessage)
end

--@brief    使用烟花（ACTIVITY_UseFirework = 16）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorRedPack:send_ACTIVITY_UseFirework_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorRedPack:send_ACTIVITY_UseFirework_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_UseFirework, nflag, sMessage)
end
