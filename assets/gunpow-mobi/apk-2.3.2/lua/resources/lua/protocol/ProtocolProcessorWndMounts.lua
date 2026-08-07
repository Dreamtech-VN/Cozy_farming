--ProtocolProcessorWndMounts.lua
--@brief	坐骑相关协议
--@date  	2015/3/26
--@author 	llg
--@note 	关于相关协议


ProtocolProcessorWndMounts = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndMounts:regAll()
	--@brief	获取所有坐骑列表成功（MOUNTS_GetAllMountsListOK = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_GetAllMountsListOK, "ProtocolProcessorWndMounts:parse_MOUNTS_GetAllMountsListOK", "vivnvnvnvsvbvbvnvi")
	--@brief	坐骑成功信息（激活、升级、进阶）（MOUNTS_MountsInfoOK=4）
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_MountsInfoOK, "ProtocolProcessorWndMounts:parse_MOUNTS_MountsInfoOK", "innnsbtbbini")
	--@brief	坐骑改变状态成功信息（MOUNTS_ChangeStateOK=8）
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_ChangeStateOK, "ProtocolProcessorWndMounts:parse_MOUNTS_ChangeStateOK", "vivb")
	--@brief	坐骑升级成功信息（MOUNTS_UpgradeRecordOk=9）
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_UpgradeRecordOk, "ProtocolProcessorWndMounts:parse_MOUNTS_UpgradeRecordOk", "vivsvtviviivi")
	    --@brief   领取图鉴奖励成功 (PLAYER_ReceiveCollectRewardOK = 127)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ReceiveCollectRewardOk, "ProtocolProcessorWndMounts:parse_PLAYER_ReceiveCollectRewardOk", "viviii") 

	--@brief	获取所有坐骑列表（MOUNTS_GetAllMountsList=1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_GetAllMountsList, "ProtocolProcessorWndMounts:send_MOUNTS_GetAllMountsList_ErrorProcess", "is" )
	--@brief	坐骑激活（MOUNTS_Activation=3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_Activation, "ProtocolProcessorWndMounts:send_MOUNTS_Activation_ErrorProcess", "is" )
	--@brief	坐骑升级（MOUNTS_Upgrade=5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_Upgrade, "ProtocolProcessorWndMounts:send_MOUNTS_Upgrade_ErrorProcess", "is" )
	--@brief	坐骑进阶（MOUNTS_Advanced=6）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_Advanced, "ProtocolProcessorWndMounts:send_MOUNTS_Advanced_ErrorProcess", "is" )
	--@brief	坐骑改变状态（MOUNTS_ChangeState=7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_ChangeState, "ProtocolProcessorWndMounts:send_MOUNTS_ChangeState_ErrorProcess", "is" )

	    --@brief   领取图鉴奖励 (PLAYER_ReceiveCollectReward = 126) 错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ReceiveCollectReward, "ProtocolProcessorWndMounts:send_PLAYER_ReceiveCollectReward_ErrorProcess", "is")


end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndMounts:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	获取所有坐骑列表（MOUNTS_GetAllMountsList=1）
function ProtocolProcessorWndMounts:send_MOUNTS_GetAllMountsList( )
	WZLog("send_MOUNTS_GetAllMountsList")
	local sender = Protocol:getSender( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_GetAllMountsList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	坐骑激活（MOUNTS_Activation=3）
function ProtocolProcessorWndMounts:send_MOUNTS_Activation(mountsId )
	WZLog("send_MOUNTS_Activation")
	local sender = Protocol:getSender( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_Activation )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( mountsId )	-- 坐骑id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	坐骑升级（MOUNTS_Upgrade=5）
function ProtocolProcessorWndMounts:send_MOUNTS_Upgrade(mountsId,num)
	WZLog("send_MOUNTS_Upgrade")
	local sender = Protocol:getSender( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_Upgrade )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( mountsId )	-- 坐骑id
	sender:writeInt( num )	-- 数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	坐骑进阶（MOUNTS_Advanced=6）
function ProtocolProcessorWndMounts:send_MOUNTS_Advanced(mountsId )
	WZLog("send_MOUNTS_Advanced")
	local sender = Protocol:getSender( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_Advanced )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( mountsId )	-- 坐骑id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	坐骑改变状态（MOUNTS_ChangeState=7）
function ProtocolProcessorWndMounts:send_MOUNTS_ChangeState(mountsId )
	WZLog("send_MOUNTS_ChangeState")
	local sender = Protocol:getSender( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_ChangeState )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( mountsId )	-- 坐骑id
	SendProtocol(sender,false) --true:showLoading
end

--@brief 	领取收集奖励 (PLAYER_ReceiveCollectReward = 126)
function ProtocolProcessorWndMounts:send_PLAYER_ReceiveCollectReward(rType, rId)
	-- body
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_ReceiveCollectReward)
	if sender == nil then WZLog("sender == nil") return end

	sender:writeInt( rType )--1,坐骑，2，皮肤，3.足迹
	sender:writeInt( rId )
	SendProtocol(sender,false)
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------


--@brief	获取所有坐骑列表成功（MOUNTS_GetAllMountsListOK = 2）
function ProtocolProcessorWndMounts:parse_MOUNTS_GetAllMountsListOK(mountsId, upgradeLevel, advancedLevel, blessingValue, property, isInUsed, state,upgradeBlessingValue, collectStatus)
	-- mountsId : 坐骑id
	-- upgradeLevel : 坐骑等级
	-- exp : 坐骑经验
	-- advancedLevel : 进阶等级
	-- blessingValue : 祝福值
	-- property : "坐骑属性,json格式{""1"":200, ""2"":500}"
	-- isInUsed : 是否使用
--	WZLog("获取坐骑协议id",Serialize(VectorToTable(mountsId)))
--	WZLog("获取坐骑协议状态",Serialize(VectorToTable(collectStatus)))
--    WZLog("ProtocolProcessorWndMounts:parse_MOUNTS_GetAllMountsListOK" ,Serialize(VectorToTable(upgradeBlessingValue)))
    GlobalGame.g_isMounts = true
	CacheCenter:setMountsData(mountsId, upgradeLevel,advancedLevel, blessingValue, property, isInUsed, state,upgradeBlessingValue, collectStatus)
end

--@brief	坐骑成功信息（激活、升级、进阶）（MOUNTS_MountsInfoOK=4）
function ProtocolProcessorWndMounts:parse_MOUNTS_MountsInfoOK(mountsId, upgradeLevel, advancedLevel, blessingValue, property, isInUsed,originType,isResult,state,fighting,upgradeBlessingValue,collectStatus)
	-- mountsId : 坐骑id
	-- upgradeLevel : 坐骑等级
	-- exp : 坐骑经验
	-- advancedLevel : 进阶等级
	-- blessingValue : 祝福值
	-- property : "坐骑属性，json格式{""1"":200, ""2"":500}"
	-- isInUsed : 是否使用
    local exp = 0
    WZLog("坐骑激活成功",mountsId,collectStatus)
	WZLog("ProtocolProcessorWndMounts:parse_MOUNTS_MountsInfoOK ",upgradeBlessingValue)
	WZLog("parse_MOUNTS_MountsInfoOK:", mountsId, upgradeLevel, advancedLevel, blessingValue, property, isInUsed, originType,isResult,state)
	CacheCenter:updateMountsInfoOK(mountsId, upgradeLevel, advancedLevel, blessingValue, property, isInUsed,originType,isResult,state,upgradeBlessingValue,collectStatus)
    WndMounts:updateNewMountsData(mountsId,originType,isResult)
end

--@brief	坐骑改变状态成功信息（MOUNTS_ChangeStateOK=8）
function ProtocolProcessorWndMounts:parse_MOUNTS_ChangeStateOK(mountsId, isInUsed)
	-- mountsId : 坐骑id
	-- isInUsed : 坐骑状态
	WZLog("ProtocolProcessorWndMounts:parse_MOUNTS_ChangeStateOK",mountsId:size())
	CacheCenter:setAlterMountsStatus(mountsId,isInUsed)
    WndMounts:changeMountsState(mountsId)
end

--@brief	坐骑升级成功信息（MOUNTS_UpgradeRecordOk=9）
function ProtocolProcessorWndMounts:parse_MOUNTS_UpgradeRecordOk(level, cost, result, item, num, uplevel, rate)
	-- level : 升级前等级
	-- cost : 消耗
	-- result : 是否成功（0为失败1为成功）
	-- item : 总消耗物品Id
	-- num : 总消耗物品数量
	-- uplevel : 升级的等级
	-- rate : 概率
	WZLog("ProtocolProcessorWndMounts:parse_MOUNTS_UpgradeRecordOk")

	local level = VectorToTable(level)
	local cost = VectorToTable(cost)
	local result = VectorToTable(result)
	local item = VectorToTable(item)
	local num = VectorToTable(num)
	local rate = VectorToTable(rate)
	WZLog("----------------rate-------------",#rate,#cost,#item,#num)
	local info = {}
	info.uplevel = uplevel
	info.log = {}
	info.cost = {}
	for i = 1, #level do
		local costInfo = json.decode(cost[i])
		local data = {level = level[i],cost = costInfo[2], result = result[i], rate = rate[i]}
		table.insert(info.log ,data)
	end
	for i = 1, #item do
		WZLog("----------item costNum-----------",item[i],num[i])
		local cost = {costId = item[i], costNum = num[i]}
		table.insert(info.cost,cost)
	end
	WndMountsCenter:updateUpLog(info)
end

--@brief 领取收集奖励 (PLAYER_ReceiveCollectRewardOk = 127)
function ProtocolProcessorWndMounts:parse_PLAYER_ReceiveCollectRewardOk(itemId, num, rtype, id)
    -- body
    WZLog("领取收集奖励",rtype,id)
    local itemId = VectorToTable(itemId)
    local num = VectorToTable(num)
    -- if rtype == 1 then
    	CacheCenter:updateBookStates(rtype,id)
    -- elseif rtype == 2 then
    -- 	CacheCenter:updatePhanStates(id)
    -- else 
    -- 	CacheCenter:updateFootStates(id)
    -- end
    WndHandBook:GetRewardResult(itemId,num,rtype,id)
    -- CellBookItem:updateStatus()
end
-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	获取所有坐骑列表（MOUNTS_GetAllMountsList=1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMounts:send_MOUNTS_GetAllMountsList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMounts:send_MOUNTS_GetAllMountsList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MOUNTS, Protocol.MOUNTS_GetAllMountsList, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	坐骑激活（MOUNTS_Activation=3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMounts:send_MOUNTS_Activation_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMounts:send_MOUNTS_Activation_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MOUNTS, Protocol.MOUNTS_Activation, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	坐骑升级（MOUNTS_Upgrade=5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMounts:send_MOUNTS_Upgrade_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMounts:send_MOUNTS_Upgrade_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MOUNTS, Protocol.MOUNTS_Upgrade, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	坐骑进阶（MOUNTS_Advanced=6）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMounts:send_MOUNTS_Advanced_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMounts:send_MOUNTS_Advanced_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MOUNTS, Protocol.MOUNTS_Advanced, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	坐骑改变状态（MOUNTS_ChangeState=7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMounts:send_MOUNTS_ChangeState_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMounts:send_MOUNTS_ChangeState_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MOUNTS, Protocol.MOUNTS_ChangeState, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

-------------------------------------公有方法模块End----------------------------------------

--@brief    领取收集奖励（PLAYER_ReceiveCollectReward = 126）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndMounts:send_PLAYER_ReceiveCollectReward_ErrorProcess(nFlag, sMessage)
    -- body
    WZLog("ProtocolProcessorWndMounts:send_PLAYER_ReceiveCollectReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_ReceiveCollectReward, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end





