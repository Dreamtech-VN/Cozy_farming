--ProtocolProcessorAttendance.lua
--@brief	每日签到相关协议
--@date  	2013/12/19
--@author 	SuYuan
--@note 	每日签到相关协议


ProtocolProcessorAttendance = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorAttendance:regAll()
	--服务器到客户端协议注册
	
     --@brief	发送签到界面（TASK_SendSignInList = 19）
     self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_SendSignInList, "ProtocolProcessorAttendance:parse_TASK_SendSignInList", "siiiviiiiiviivivivivbvivivi")

	--返回已领取奖励列表(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_AttendanceGetRewardOk, "ProtocolProcessorAttendance:parse_TASK_AttendanceGetRewardOk", "vivi")
	--返回签到说明(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_SendSignInfo, "ProtocolProcessorAttendance:parse_TASK_SendSignInfo", "vivivsvsvsvi")

	--@brief	发送每日奖励列表（TASK_SendEverydayRewardList = 15）
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_SendEverydayRewardList, "ProtocolProcessorAttendance:parse_TASK_SendEverydayRewardList", "ivivivbvivivi")

	--@brief	领取奖励成功（TASK_ReceiveRewardOk = 17）
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_ReceiveRewardOk, "ProtocolProcessorAttendance:parse_TASK_ReceiveRewardOk", "vivi")
	
	--@brief	查询等级奖励列表成功（TASK_GetLevelRewardListOk = 41）
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetLevelRewardListOk, "ProtocolProcessorAttendance:parse_TASK_GetLevelRewardListOk", "ibvivivbvivivi")
	
	--@brief	查询在线奖励列表成功（TASK_GetOnileRewardListOk = 43）
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetOnileRewardListOk, "ProtocolProcessorAttendance:parse_TASK_GetOnileRewardListOk", "iviviivii")
	
	--协议错误处理
	--获得签到界面错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetSignInList, "ProtocolProcessorAttendance:send_TASK_GetSignInList_ErrorProcess", "is" )
	--签到错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_Sign, "ProtocolProcessorAttendance:send_TASK_Sign_ErrorProcess", "is" )
	--领取签到奖励错误处理(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_AttendanceGetReward, "ProtocolProcessorAttendance:send_TASK_AttendanceGetReward_ErrorProcess", "is" )
	--获得签到说明错误处理(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetSignInfo, "ProtocolProcessorAttendance:send_TASK_GetSignInfo_ErrorProcess", "is" )

	--@brief	领取累计签到奖励（TASK_AttendanceGetReward = 21）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_AttendanceGetReward, "ProtocolProcessorAttendance:send_TASK_AttendanceGetReward_ErrorProcess", "is" )
 
    --@brief	补签成功（TASK_SupplSignOk = 28）
    self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_SupplSignOk, "ProtocolProcessorAttendance:parse_TASK_SupplSignOk", "i")

    --@brief	TASK_SupplSign = 27错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_SupplSign, "ProtocolProcessorAttendance:send_TASK_SupplSign_ErrorProcess", "is" )

	--@brief	获得每日奖励列表（TASK_GetEverydayRewardList = 14）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetEverydayRewardList, "ProtocolProcessorAttendance:send_TASK_GetEverydayRewardList_ErrorProcess", "is" )

	--@brief	领取奖励（TASK_ReceiveReward = 16）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_ReceiveReward, "ProtocolProcessorAttendance:send_TASK_ReceiveReward_ErrorProcess", "is" )

	--@brief	查询等级奖励列表（TASK_GetLevelRewardList = 40）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetLevelRewardList, "ProtocolProcessorAttendance:send_TASK_GetLevelRewardList_ErrorProcess", "is" )

	--@brief	查询在线奖励列表（TASK_GetOnileRewardList = 42）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetOnileRewardList, "ProtocolProcessorAttendance:send_TASK_GetOnileRewardList_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorAttendance:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------

--@brief	获得签到界面信息(C->S)
--@note		向服务器发送获得签到界面信息协议
function ProtocolProcessorAttendance:send_TASK_GetSignInList( )
	WZLog("send_TASK_GetSignInList")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_GetSignInList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	签到(C->S)
--@note		向服务器发送签到协议
function ProtocolProcessorAttendance:send_TASK_Sign( )
	WZLog("send_TASK_Sign")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_Sign )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end



--@brief	领取累计签到奖励（TASK_AttendanceGetReward = 21）
function ProtocolProcessorAttendance:send_TASK_AttendanceGetReward(totalDays )
	WZLog("send_TASK_AttendanceGetReward")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_AttendanceGetReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( totalDays )	-- 累计签到奖励所需天数
	SendProtocol(sender,false) --true:showLoading
end


--@brief	补签 TASK_SupplSign = 27
function ProtocolProcessorAttendance:send_TASK_SupplSign( )
	WZLog("send_TASK_SupplSign")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_SupplSign )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获得每日奖励列表（TASK_GetEverydayRewardList = 14）
function ProtocolProcessorAttendance:send_TASK_GetEverydayRewardList( )
	WZLog("send_TASK_GetEverydayRewardList")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_GetEverydayRewardList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取奖励（TASK_ReceiveReward = 16）
function ProtocolProcessorAttendance:send_TASK_ReceiveReward(rewardType, param )
	WZLog("send_TASK_ReceiveReward")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_ReceiveReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( rewardType )	-- 奖励类型0累计签到奖励，1连续签到奖励，2累积登录奖励，3登录目标奖励，4等级奖励，5等级目标奖励,6在线奖励
	sender:writeInt( param )	-- 奖励参数
	SendProtocol(sender,false) --true:showLoading
end

--@brief	查询等级奖励列表（TASK_GetLevelRewardList = 40）
function ProtocolProcessorAttendance:send_TASK_GetLevelRewardList( )
	WZLog("send_TASK_GetLevelRewardList")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_GetLevelRewardList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	查询在线奖励列表（TASK_GetOnileRewardList = 42）
function ProtocolProcessorAttendance:send_TASK_GetOnileRewardList( )
	WZLog("send_TASK_GetOnileRewardList")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_GetOnileRewardList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------

--@brief	服务器发送签到界面信息(S->C)
--@note		服务器返回签到界面信息时的回调函数
--@brief	发送签到界面（TASK_SendSignInList = 19）
function ProtocolProcessorAttendance:parse_TASK_SendSignInList(yearMonth, maxDay, dayToWeek, toDay, signDays, totalSign, arraySign, supplSign, supplTimes, supplPrice, arrayDays, arrayItems, arrayCount, totalDays, totalRewards,rewardCount,totalItems,totalCount)
	-- yearMonth : 年月
	-- maxDay : 本月最大天数
	-- dayToWeek : 本月第一天对应的周数
	-- toDay : 今天日期
	-- signDays : 本月签到日期
	-- totalSign : 累计签到次数
	-- arraySign : 连续签到次数
	-- supplSign : 本月需补签次数
	-- supplTimes : 本月已补签次数
	-- supplPrice : 补签所需价格
	-- arrayDays : 下级连续签到奖励所需天数
	-- arrayItems : 下级连续签到奖励物品ID
	-- arrayCount : 下级连续签到奖励物品数量
	-- totalDays : 累计签到奖励所需天数
	-- totalRewards : 累计签到奖励是否领取
	--rewardCount	int[]	累计签到奖励物品数量
    --totalItems	int[]	累计签到奖励物品ID
    --totalCount	int[]	累计签到奖励物品数量

	WZLog("ProtocolProcessorAttendance:parse_TASK_SendSignInList")
	WndSingInReward:setAttendanceInfo(yearMonth, maxDay, dayToWeek, toDay, signDays, totalSign, arraySign, supplSign, supplTimes, supplPrice, arrayDays, arrayItems, arrayCount, totalDays, totalRewards,rewardCount,totalItems,totalCount)
end




--@brief	返回已领取奖励列表(S->C)
--@note		服务器返回已领取奖励列表时的回调函数
function ProtocolProcessorAttendance:parse_TASK_AttendanceGetRewardOk(rewardName, rewardNum)
	-- rewardName : 奖励ID
	-- rewardIcon : 奖励图标
	WZLog("ProtocolProcessorAttendance:parse_TASK_AttendanceGetRewardOk",rewardName:size(),rewardNum:size())
	
	ProtocolProcessorAttendance:send_TASK_GetSignInList()
    
    if rewardName:size() <= 0 then
       return
    end
	local vnId = {}
    local vnNum = VectorToTable(rewardNum)
	for i=0,2 do
		if rewardName:get(i) ~= nil then
			table.insert(vnId,rewardName:get(i))
		end
	end	
    Teach.REWARD_MARK = 1

    WndRewardShow:showById(vnId,vnNum)
	
end

--@brief	补签成功（TASK_SupplSignOk = 28）
function ProtocolProcessorAttendance:parse_TASK_SupplSignOk(signDay)
	-- signDay : 补签的日期
	WZLog("ProtocolProcessorAttendance:parse_TASK_SupplSignOk")
	WZLog("signDay",signDay)
	ProtocolProcessorAttendance:send_TASK_GetSignInList()
end

--@brief	发送每日奖励列表（TASK_SendEverydayRewardList = 15）
function ProtocolProcessorAttendance:parse_TASK_SendEverydayRewardList(loginDays, types, days, reward, rewardCount, itemIds, itemCount)
	-- loginDays : 玩家当前累积登录天数
	-- types : 奖励类型 2累积登录奖励，3登录目标奖励
	-- days : 累计登录天数
	-- reward : 奖励是否领取
	-- rewardCount : 奖励物品数量
	-- itemIds : 奖励物品id
	-- itemCount : 奖励物品数量
	WZLog("ProtocolProcessorAttendance:parse_TASK_SendEverydayRewardList")
	WZLog("ProtocolProcessorAttendance:parse_TASK_SendEverydayRewardList",loginDays,types:size(),days:size(),reward:size(),rewardCount:size(),itemIds:size(),itemCount:size())
	WndLoginReward:setLoginReward(loginDays, types, days, reward, rewardCount, itemIds, itemCount)
end

--@brief	领取奖励成功（TASK_ReceiveRewardOk = 17）
function ProtocolProcessorAttendance:parse_TASK_ReceiveRewardOk(rewardItems, rewardCount)
	-- rewardItems : 奖励物品id
	-- rewardCount : 奖励数量
	WZLog("ProtocolProcessorAttendance:parse_TASK_ReceiveRewardOk",rewardItems:size())
	local display = WndOnlineRewards:getType()
	WZLog("display::::",display)

	if display == "yaoGan" then
		WndOnlineRewards:setRewardData(rewardItems, rewardCount)
	else
		local vnId = {}
		local vnNum = {}
		for i=0,rewardItems:size()-1 do
			table.insert(vnId,rewardItems:get(i))
			table.insert(vnNum,rewardCount:get(i))
		end
        

		WndRewardShow:showById(vnId,vnNum)
		if display == "OnlineReward" then
			ProtocolProcessorAttendance:send_TASK_GetOnileRewardList()
		end
	end
end

--@brief	查询等级奖励列表成功（TASK_GetLevelRewardListOk = 41）
function ProtocolProcessorAttendance:parse_TASK_GetLevelRewardListOk(playerLevel, playerRebirth, types, levels, reward, rewardCount, itemIds, itemCount)
	-- playerLevel : 玩家当前等级
	-- playerRebirth : 玩家是否转生
	-- types : 奖励类型 4等级奖励，5等级目标奖励
	-- levels : 奖励等级需求
	-- reward : 奖励是否领取
	-- rewardCount : 奖励物品数量
	-- itemIds : 奖励物品id
	-- itemCount : 奖励物品数量
	WZLog("ProtocolProcessorAttendance:parse_TASK_GetLevelRewardListOk")
	WndlevelRewards:setLevelReward(playerLevel, playerRebirth, types, levels, reward, rewardCount, itemIds, itemCount)
end

--@brief	查询在线奖励列表成功（TASK_GetOnileRewardListOk = 43）
function ProtocolProcessorAttendance:parse_TASK_GetOnileRewardListOk(onlineTime, onlineItem, onlineCount, lotteryTime, lotteryItem, lotteryTimes)
	-- onlineTime : 玩家在线多少秒后可以领取在线奖励
	-- onlineItem : 在线奖励的物品id
	-- onlineCount : 在线奖励的物品数量
	-- lotteryTime : 玩家在线多少秒后可以获得抽奖机会
	-- lotteryItem : 抽奖奖励的物品id
	-- lotteryTimes : 玩家可抽奖次数
	WZLog("ProtocolProcessorAttendance:parse_TASK_GetOnileRewardListOk",lotteryTimes)
	WndOnlineRewards:setOnlineReward(onlineTime, onlineItem, onlineCount, lotteryTime, lotteryItem, lotteryTimes)
end
-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------

--@brief	获得签到界面信息错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note		在此对协议错误进行相应处理
function ProtocolProcessorAttendance:send_TASK_GetSignInList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAttendance:send_TASK_GetSignInList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_GetSignInList, nflag, sMessage)
end

--@brief	签到错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note		在此对协议错误进行相应处理
function ProtocolProcessorAttendance:send_TASK_Sign_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAttendance:send_TASK_Sign_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_Sign, nflag, sMessage)
end

--@brief	领取签到奖励错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note		在此对协议错误进行相应处理
function ProtocolProcessorAttendance:send_TASK_AttendanceGetReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAttendance:send_TASK_AttendanceGetReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_AttendanceGetReward, nflag, sMessage)
end


--@brief	领取累计签到奖励（TASK_AttendanceGetReward = 21）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorAttendance:send_TASK_AttendanceGetReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAttendance:send_TASK_AttendanceGetReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_AttendanceGetReward, nflag, sMessage)
end

--@brief	TASK_SupplSign = 27错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorAttendance:send_TASK_SupplSign_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAttendance:send_TASK_SupplSign_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_SupplSign, nflag, sMessage)
end

--@brief	获得每日奖励列表（TASK_GetEverydayRewardList = 14）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorAttendance:send_TASK_GetEverydayRewardList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAttendance:send_TASK_GetEverydayRewardList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_GetEverydayRewardList, nflag, sMessage)
end

--@brief	领取奖励（TASK_ReceiveReward = 16）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorAttendance:send_TASK_ReceiveReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAttendance:send_TASK_ReceiveReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_ReceiveReward, nflag, sMessage)
end

--@brief	查询等级奖励列表（TASK_GetLevelRewardList = 40）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorAttendance:send_TASK_GetLevelRewardList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAttendance:send_TASK_GetLevelRewardList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_GetLevelRewardList, nflag, sMessage)
end

--@brief	查询在线奖励列表（TASK_GetOnileRewardList = 42）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorAttendance:send_TASK_GetOnileRewardList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAttendance:send_TASK_GetOnileRewardList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_GetOnileRewardList, nflag, sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------





