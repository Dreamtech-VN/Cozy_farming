--ProtocolProcessorPrefetchCache.lua
--@brief	客户端预获取缓存中心相关协议
--@date  	2014/9/10
--@author 	刘凑贵
--@note 	关于相关协议


ProtocolProcessorPrefetchCache = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorPrefetchCache:regAll()
	WZLog("ProtocolProcessorPrefetchCache:regAll")
	--@brief	获取任务列表成功
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetTaskListOk, "ProtocolProcessorPrefetchCache:parse_TASK_GetTaskListOk", "vivivivivi")
	--返回房间列表
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GetRoomListOk, "ProtocolProcessorPrefetchCache:parse_ROOM_GetRoomListOk", "ivivsvivivivsvivivb")
	--@brief	获取任务列表成功
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_UpdateTask, "ProtocolProcessorPrefetchCache:parse_TASK_UpdateTask", "vivivivi")
	--奖励提升成功
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_QuickUpExpOk, "ProtocolProcessorPrefetchCache:parse_TASK_QuickUpExpOk", "i")

    --@brief    微信分享（TASK_WeChatShare = 24）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_WeChatShare, "ProtocolProcessorPrefetchCache:send_TASK_WeChatShare_ErrorProcess", "is" )
    --@brief    微信分享成功（TASK_WeChatShareOk = 25）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_WeChatShareOk, "ProtocolProcessorPrefetchCache:parse_TASK_WeChatShareOk", "s")
	--@brief   苹果评论（PLAYER_AppStoreCommentStatus = 93）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_AppStoreCommentStatus, "ProtocolProcessorPrefetchCache:parse_PLAYER_AppStoreCommentStatusOk", "t")
     --@brief   增加Facebook内容次数
    self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_AddFaceBookNum, "ProtocolProcessorPrefetchCache:send_TASK_AddFaceBookNum_ErrorProcess", "is" )
     --@brief 推送广告奖励次数（TASK_SendADRewardInfo = 15）
    self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_SendADRewardInfo, "ProtocolProcessorPrefetchCache:parse_TASK_SendADRewardInfo", "ivivivi" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorPrefetchCache:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief    微信分享（TASK_WeChatShare = 24）
function ProtocolProcessorPrefetchCache:send_TASK_WeChatShare( )
    WZLog("send_TASK_WeChatShare")
    local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_WeChatShare )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end



-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取任务列表成功
function ProtocolProcessorPrefetchCache:parse_TASK_GetTaskListOk(id, status, target, complete, boxStatus)
	-- id : 任务ID
	-- status : 状态0新增，1完成但未领取，2完成
	-- target : 目标数量
	-- complete : 完成数量
	-- boxStatus : 日常活跃度宝箱状态：0为达成，1可领取，2已领取
	WZLog("ProtocolProcessorPrefetchCache:parse_TASK_GetTaskListOk")
	PrefetchCache:setTaskList(VectorToTable(id),VectorToTable(status),VectorToTable(target),VectorToTable(complete), VectorToTable(boxStatus))
end

--@brief	返回房间列表
function ProtocolProcessorPrefetchCache:parse_ROOM_GetRoomListOk(roomCount, roomId, roomName, battleStatus, battleMode, playerNumMode, passWord, playerNum, startMode, roomStaus)
	-- roomCount : 房间数量
	-- roomId : 房间Id数组
	-- roomName : 房间名称数组
	-- battleStatus : 房间状态数组
	-- battleMode : 房间战斗模式数组
	-- playerNumMode : 房间对战人数模式数组
	-- passWord : 房间密码数组
	-- playerNum : 房间当前人数数组
	-- startMode : 房间撮合方式数组
	-- roomStaus : 房间是否已满
	WZLog("ProtocolProcessorPrefetchCache:parse_ROOM_GetRoomListOk")

	PrefetchCache:setHallRoomList(roomCount, roomId, roomName, battleStatus, battleMode, playerNumMode, passWord, playerNum, startMode, roomStaus)
	--SceneHall:receiveRoomList(VectorToTable(roomCount), VectorToTable(roomId), VectorToTable(roomName), VectorToTable(battleStatus), VectorToTable(battleMode), VectorToTable(playerNumMode), VectorToTable(passWord), VectorToTable(playerNum), VectorToTable(startMode), VectorToTable(roomStaus))
end

--@brief	任务状态变更协议
function ProtocolProcessorPrefetchCache:parse_TASK_UpdateTask(id, status, target, complete)
	-- id : 任务ID
	-- status : 状态0新增，1完成但未领取，2完成
	-- target : 目标数量
	-- complete : 完成数量
	WZLog("ProtocolProcessorPrefetchCache:parse_TASK_UpdateTask")
	PrefetchCache:updateTaskStatus(VectorToTable(id),VectorToTable(status),VectorToTable(target),VectorToTable(complete))
    if SceneCity.m_tWndBottomBarObj then SceneCity.m_tWndBottomBarObj:updateTask() end
    if WndSingleCopy.m_root then WndSingleCopy:updateTask() end

    for i=#g_tCellTopHandleObj,1,-1 do
    	if g_tCellTopHandleObj[i] and g_tCellTopHandleObj[i].m_root then
    		g_tCellTopHandleObj[i]:updateTask()
	    end
    end
end

--@brief	奖励提升成功
function ProtocolProcessorPrefetchCache:parse_TASK_QuickUpExpOk(taskId)
	-- taskId : 任务id
	WZLog("ProtocolProcessorPrefetchCache:parse_TASK_QuickUpExpOk")

	PrefetchCache:updateTaskRewards(taskId)
end

--@brief	微信分享首次奖励获取成功
function ProtocolProcessorPrefetchCache:parse_TASK_WeChatShareOk(reward)
	WZLog("ProtocolProcessorPrefetchCache:parse_TASK_WeChatShareOk")
	gWeChatShareReward = ""
	if string.len(reward) >= 1 then
	   local id,num = SplitItemString(reward)
	   WndRewardShow:showById(id,num)
    end
end

--@brief	微信分享首次奖励获取成功
function ProtocolProcessorPrefetchCache:parse_PLAYER_AppStoreCommentStatusOk(state)
	WZLog("ProtocolProcessorPrefetchCache:parse_PLAYER_AppStoreCommentStatusOk")
	gAppStoreCommentStatus = state
end

--@brief    推送广告奖励次数（TASK_SendADRewardInfo = 15）
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorPrefetchCache:parse_TASK_SendADRewardInfo(createDays, adId, rewardCount, lastTime)
    WZLog("ProtocolProcessorPrefetchCache:parse_TASK_SendADRewardInfo")
    CacheCenter.m_fyberInfo = {}
    CacheCenter.m_fyberInfo.createDays = createDays
    CacheCenter.m_fyberInfo.tData = {}
    for i = 0 , adId:size() - 1 do
		local tab = {}
		tab.adId = adId:get(i)
		tab.rewardCount = rewardCount:get(i)
		tab.lastTime = lastTime:get(i)
		table.insert(CacheCenter.m_fyberInfo.tData, tab)
	end
    local serverTime = SystemTime:getServerTime()
    WZLog("parse_TASK_SendADRewardInfo Time:", serverTime)
    --时间的重新计算秒速
    for i=1,#CacheCenter.m_fyberInfo.tData do
    	WZLog("parse_TASK_SendADRewardInfo lastTime:", CacheCenter.m_fyberInfo.tData[i].lastTime)
    	CacheCenter.m_fyberInfo.tData[i].lastTime = serverTime - CacheCenter.m_fyberInfo.tData[i].lastTime
    end
    if WndFyber and WndFyber.m_root then
		WndFyber:setFyberTime()
	end
end

--@brief    等级验证操作
function ProtocolProcessorPrefetchCache:send_ACTIVITY_RankVerification( )
    WZLog("send_ACTIVITY_RankVerification")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_RankVerification )
    if sender==nil then WZLog("sender == nil") return end
end

--------------------------------协议错误处理方法模块--------------------------------------
--@brief    微信分享（TASK_WeChatShare = 24）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorPrefetchCache:send_TASK_WeChatShare_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorPrefetchCache:send_TASK_WeChatShare_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_WeChatShare, nflag, sMessage)
end
--@brief    增加Facebook内容次数
function ProtocolProcessorPrefetchCache:send_TASK_AddFaceBookNum(id,email)
    WZLog("send_TASK_AddFaceBookNum:",id)
    local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_AddFaceBookNum )
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt( id )	-- 玩家教程ID
	sender:writeString( email )	-- 教程步骤
    SendProtocol(sender,false) --true:showLoading
end

--@brief    等级验证成功
function ProtocolProcessorPrefetchCache:parse_ACTIVITY_RankVerificationOk()
    WZLog("ProtocolProcessorPrefetchCache:parse_ACTIVITY_RankVerificationOk")
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief    等级验证操作错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorPrefetchCache:send_ACTIVITY_RankVerification_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorPrefetchCache:send_ACTIVITY_RankVerification_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_RankVerification, nflag, sMessage)
end

--@brief    增加Facebook内容次数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorPrefetchCache:send_TASK_AddFaceBookNum_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorPrefetchCache:send_ACTIVITY_RankVerification_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_AddFaceBookNum, nflag, sMessage)
end


-------------------------------------公有方法模块End----------------------------------------







