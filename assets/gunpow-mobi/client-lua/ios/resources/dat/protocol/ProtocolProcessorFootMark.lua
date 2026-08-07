--ProtocolProcessorFootMark.lua
--@brief    成长基金相关协议
--@date     2016/4/14
--@author   Tianxiang_Xu
--@note     成长基金相关协议


ProtocolProcessorFootMark = ProtocolProcessorBase:new()


--@brief    注册协议组所有协议
--@note     注册协议组所有协议
function ProtocolProcessorFootMark:regAll()
    --@brief	获取足迹列表（FOOTMARK_GetFootmark = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootmark, "ProtocolProcessorFootMark:send_FOOTMARK_GetFootmark_ErrorProcess", "is" )
	--@brief	使用足迹物品（FOOTMARK_UseFootmark = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UseFootmark, "ProtocolProcessorFootMark:send_FOOTMARK_UseFootmark_ErrorProcess", "is" )
	--@brief	足迹升级（FOOTMARK_UpgradeFootmark = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UpgradeFootmark, "ProtocolProcessorFootMark:send_FOOTMARK_UpgradeFootmark_ErrorProcess", "is" )
	--@brief	足迹进阶（FOOTMARK_AdvancedFootmark = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_AdvancedFootmark, "ProtocolProcessorFootMark:send_FOOTMARK_AdvancedFootmark_ErrorProcess", "is" )
	--@brief	足迹改变状态（FOOTMARK_ChangeState = 8）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_ChangeState, "ProtocolProcessorFootMark:send_FOOTMARK_ChangeState_ErrorProcess", "is" )

	--@brief	获取足迹列表成功（FOOTMARK_GetFootmarkOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootmarkOk, "ProtocolProcessorFootMark:parse_FOOTMARK_GetFootmarkOk", "vivivivivsvivivii")
	--@brief	使用足迹物品（FOOTMARK_UseFootmarkOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UseFootmarkOk, "ProtocolProcessorFootMark:parse_FOOTMARK_UseFootmarkOk", "vivi")
	--@brief	足迹更新（FOOTMARK_UpdataFootmark = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UpdataFootmark, "ProtocolProcessorFootMark:parse_FOOTMARK_UpdataFootmark", "iiiisiiiii")
	--@brief	足迹改变状态成功信息（FOOTMARK_ChangeStateOK = 9）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_ChangeStateOK, "ProtocolProcessorFootMark:parse_FOOTMARK_ChangeStateOK", "i")
	--@brief	坐骑升级成功信息（FOOTMARK_UpgradeRecordOk = 10）
	self:regProtocolCallbackFunction( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UpgradeRecordOk, "ProtocolProcessorFootMark:parse_FOOTMARK_UpgradeRecordOk", "vivsvtviviivi")
end



--@brief    反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorFootMark:unregAll()
    self:clearReg()
end


---------------------------------客户端到服务器协议发送方法模块----------------------------------
--@brief	获取足迹列表（FOOTMARK_GetFootmark=1）
function ProtocolProcessorFootMark:send_FOOTMARK_GetFootmark( )
	WZLog("send_FOOTMARK_GetFootmark")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootmark )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	使用足迹物品（FOOTMARK_UseFootmark=3）
function ProtocolProcessorFootMark:send_FOOTMARK_UseFootmark(itemId )
	WZLog("send_FOOTMARK_UseFootmark:",itemId)
	g_curbuy_footmark = itemId
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UseFootmark )
	if sender==nil then WZLog("sender == nil") return end
  
	sender:writeInt( itemId )	-- 物品id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	足迹升级（FOOTMARK_UpgradeFootmark=5）
function ProtocolProcessorFootMark:send_FOOTMARK_UpgradeFootmark(footmarkId, num )
	WZLog("send_FOOTMARK_UpgradeFootmark")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_UpgradeFootmark )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( footmarkId )	-- 足迹id
	sender:writeInt( num )	-- 次数
	SendProtocol(sender,false) --true:showLoading
end

--@brief	足迹进阶（FOOTMARK_AdvancedFootmark=7）
function ProtocolProcessorFootMark:send_FOOTMARK_AdvancedFootmark(footmarkId )
	WZLog("send_FOOTMARK_AdvancedFootmark")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_AdvancedFootmark )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( footmarkId )	-- 足迹id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	足迹改变状态（FOOTMARK_ChangeState=8）
function ProtocolProcessorFootMark:send_FOOTMARK_ChangeState(footmarkId )
	WZLog("send_FOOTMARK_ChangeState")
	local sender = Protocol:getSender( Protocol.MAIN_Footmark, Protocol.FOOTMARK_ChangeState )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( footmarkId )	-- 足迹id
	SendProtocol(sender,false) --true:showLoading
end

---------------------------------服务器到客户端协议回调方法模块----------------------------------
--@brief	获取足迹列表成功（FOOTMARK_GetFootmarkOk=2）
function ProtocolProcessorFootMark:parse_FOOTMARK_GetFootmarkOk(footmarkId, upgradeLevel, advancedLevel, fighting, extMap, upgradeBlessingValue, advancedBlessingValue, remainingTime, useFootmark)
	-- footmarkId : 足迹id
	-- upgradeLevel : 足迹等级
	-- advancedLevel : 进阶等级
	-- fighting : 战斗力
	-- extMap : 属性,json格式{"1":200, "2":500}
	-- upgradeBlessingValue : 升级幸运值
	-- advancedBlessingValue : 进阶幸运值
	-- remainingTime : 剩余时间秒（-1为永久）
	-- useFootmark : 使用中足迹
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_GetFootmarkOk")

	CacheCenter:setFootMarkData(VectorToTable(footmarkId), VectorToTable(upgradeLevel), VectorToTable(advancedLevel), VectorToTable(advancedBlessingValue), VectorToTable(extMap), VectorToTable(upgradeBlessingValue), VectorToTable(fighting), VectorToTable(remainingTime), useFootmark)
end

--@brief	使用足迹物品（FOOTMARK_UseFootmarkOk=4）
function ProtocolProcessorFootMark:parse_FOOTMARK_UseFootmarkOk(itemId, num)
	-- itemId : 转换后的物品Id
	-- num : 物品数量
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_UseFootmarkOk")

	local tItemId = {}
	tItemId[1] = g_nUseFootMarkId
	local tItemNum = {}
	tItemNum[1] = 1
	WndRewardShow:showById(tItemId, tItemNum, nil, nil, true)
end

--@brief	足迹更新（FOOTMARK_UpdataFootmark=6）
function ProtocolProcessorFootMark:parse_FOOTMARK_UpdataFootmark(footmarkId, upgradeLevel, advancedLevel, fighting, extMap, upgradeBlessingValue, advancedBlessingValue, remainingTime, originType, result)
	-- footmarkId : 足迹id
	-- upgradeLevel : 足迹等级
	-- advancedLevel : 进阶等级
	-- fighting : 战斗力
	-- extMap : 属性,json格式{"1":200, "2":500}
	-- upgradeBlessingValue : 升级幸运值
	-- advancedBlessingValue : 精炼幸运值
	-- remainingTime : 剩余时间秒（-1为永久）
	-- originType : 状态（1、新增【新获得足迹或时效改变】，2、升级，3、进阶）
	-- result : 结果：1->成功；0->失败
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_UpdataFootmark", footmarkId, remainingTime)

	CacheCenter:updateFootMarkInfoOK(footmarkId, upgradeLevel, advancedLevel, advancedBlessingValue, extMap, fighting, originType, remainingTime, upgradeBlessingValue)
	WndFootMark:updateNewFootMarkData(footmarkId, originType, result)
end

--@brief	足迹改变状态成功信息（FOOTMARK_ChangeStateOK=9）
function ProtocolProcessorFootMark:parse_FOOTMARK_ChangeStateOK(useFootmark)
	-- useFootmark : 使用中足迹id
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_ChangeStateOK")

	CacheCenter:resetFootMarkState(useFootmark)
end

--@brief	坐骑升级成功信息（FOOTMARK_UpgradeRecordOk = 10）
function ProtocolProcessorFootMark:parse_FOOTMARK_UpgradeRecordOk(level, cost, result, item, num, uplevel, rate)
	-- level : 升级前等级
	-- cost : 消耗
	-- result : 是否成功（0为失败1为成功）
	-- item : 总消耗物品Id
	-- num : 总消耗物品数量
	-- uplevel : 升级的等级
	-- rate : 概率
	WZLog("ProtocolProcessorFootMark:parse_FOOTMARK_UpgradeRecordOk")

	local level = VectorToTable(level)
	local cost = VectorToTable(cost)
	local result = VectorToTable(result)
	local item = VectorToTable(item)
	local num = VectorToTable(num)
	local rate = VectorToTable(rate)
	WZLog("parse_FOOTMARK_UpgradeRecordOk ",#rate,#cost,#item,#num)
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
		WZLog("parse_FOOTMARK_UpgradeRecordOk HHH ",item[i],num[i])
		local cost = {costId = item[i], costNum = num[i]}
		table.insert(info.cost,cost)
	end
	WndFootMarkUpgrade:updateUpLog(info)
end
---------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取足迹列表（FOOTMARK_GetFootmark=1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_GetFootmark_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:send_FOOTMARK_GetFootmark_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_GetFootmark, nflag, sMessage)
end

--@brief	使用足迹物品（FOOTMARK_UseFootmark=3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_UseFootmark_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:send_FOOTMARK_UseFootmark_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_UseFootmark, nflag, sMessage)
end

--@brief	足迹升级（FOOTMARK_UpgradeFootmark=5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_UpgradeFootmark_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:send_FOOTMARK_UpgradeFootmark_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_UpgradeFootmark, nflag, sMessage)
end

--@brief	足迹进阶（FOOTMARK_AdvancedFootmark=7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_AdvancedFootmark_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:send_FOOTMARK_AdvancedFootmark_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_AdvancedFootmark, nflag, sMessage)
end

--@brief	足迹改变状态（FOOTMARK_ChangeState=8）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFootMark:send_FOOTMARK_ChangeState_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFootMark:send_FOOTMARK_ChangeState_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_Footmark, Protocol.FOOTMARK_ChangeState, nflag, sMessage)
end