--ProtocolProcessorWndMarriage.lua
--@brief	姻缘相关协议
--@date  	2022/7/21
--@author 	yrd
--@note 	姻缘相关协议


ProtocolProcessorWndMarriage = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndMarriage:regAll()
	--@brief	姻缘升级（COUPLE_MarriageUpgrade = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLE, Protocol.COUPLE_MarriageUpgrade, "ProtocolProcessorWndMarriage:send_COUPLE_MarriageUpgrade_ErrorProcess", "is")
	--@brief	姻缘升级（COUPLE_MarriageUpgradeOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLE, Protocol.COUPLE_MarriageUpgradeOk, "ProtocolProcessorWndMarriage:parse_COUPLE_MarriageUpgradeOk", "iivivivivi")
	--@brief	婚姻突破（COUPLE_MarriageBreakOk = 5）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLE, Protocol.COUPLE_MarriageBreakOk, "ProtocolProcessorWndMarriage:parse_COUPLE_MarriageBreakOk", "bi")

	--@brief	姻缘数据（COUPLE_MarriageInfo = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLE, Protocol.COUPLE_MarriageInfo, "ProtocolProcessorWndMarriage:send_COUPLE_MarriageInfo_ErrorProcess", "is")
	--@brief	姻缘数据（COUPLE_MarriageInfoOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_COUPLE, Protocol.COUPLE_MarriageInfoOk, "ProtocolProcessorWndMarriage:parse_COUPLE_MarriageInfoOk", "iiii")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndMarriage:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	姻缘升级（COUPLE_MarriageUpgrade = 1）
function ProtocolProcessorWndMarriage:send_COUPLE_MarriageUpgrade(opType, itemId, num)
	WZLog("send_COUPLE_MarriageUpgrade", opType, itemId, num)
	local sender = Protocol:getSender( Protocol.MAIN_COUPLE, Protocol.COUPLE_MarriageUpgrade )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte(opType)	-- 1-升级，2-突破
	sender:writeInt(itemId)	-- 使用的道具id
	sender:writeInt(num)	-- 使用数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	姻缘数据（COUPLE_MarriageInfo = 3）
function ProtocolProcessorWndMarriage:send_COUPLE_MarriageInfo()
	WZLog("send_COUPLE_MarriageInfo")
	local sender = Protocol:getSender( Protocol.MAIN_COUPLE, Protocol.COUPLE_MarriageInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	姻缘升级（COUPLE_MarriageUpgradeOk = 2）
function ProtocolProcessorWndMarriage:parse_COUPLE_MarriageUpgradeOk(currentLevel, currentExp, baseExp, multiple, preLevel, level)
	-- currentLevel : 当前等级
	-- currentExp : 当前经验
	-- baseExp : 获取基础经验
	-- multiple : 倍数
	-- preLevel : 培养前等级
	-- level : 培养后等级
	WZLog("ProtocolProcessorWndMarriage:parse_COUPLE_MarriageUpgradeOk", 
		"\n currentLevel =",Serialize(VectorToTable(currentLevel)), 
		"\n currentExp =",Serialize(VectorToTable(currentExp)), 
		"\n baseExp =",Serialize(VectorToTable(baseExp)), 
		"\n multiple =",Serialize(VectorToTable(multiple)), 
		"\n preLevel =",Serialize(VectorToTable(preLevel)), 
		"\n level =",Serialize(VectorToTable(level)))
	WndMarriage:getMarriageUpgradeOk(currentLevel, currentExp, VectorToTable(baseExp), VectorToTable(multiple), VectorToTable(preLevel), VectorToTable(level))
end

--@brief	婚姻突破（COUPLE_MarriageBreakOk = 5）
function ProtocolProcessorWndMarriage:parse_COUPLE_MarriageBreakOk(succ, luckyValue)
	-- succ : 是否成功
	-- luckyValue : 幸运值
	WZLog("ProtocolProcessorWndMarriage:parse_COUPLE_MarriageBreakOk", succ, luckyValue)
	WndMarriage:getMarriageBreakOk(succ, luckyValue)
end

--@brief	姻缘数据（COUPLE_MarriageInfoOk = 4）
function ProtocolProcessorWndMarriage:parse_COUPLE_MarriageInfoOk(lvl, exp, luckyValue, coupleLvl)
	-- lvl : 婚姻等级数据
	-- exp : 婚姻值
	-- luckyValue : 幸运值
	-- coupleLvl : 伴侣的姻缘等级
	WZLog("ProtocolProcessorWndMarriage:parse_COUPLE_MarriageInfoOk", lvl, exp, luckyValue, coupleLvl)
	WndMarryManager:closeLoading()
	WndMarriage:getMarriageInfoOk(lvl, exp, luckyValue, coupleLvl)
end


-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	姻缘升级（COUPLE_MarriageUpgrade = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarriage:send_COUPLE_MarriageUpgrade_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarriage:parse_COUPLE_MarriageUpgrade_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLE, Protocol.COUPLE_MarriageUpgrade, nflag, sMessage)
end

--@brief	姻缘数据（COUPLE_MarriageInfo = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarriage:send_COUPLE_MarriageInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarriage:parse_COUPLE_MarriageInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_COUPLE, Protocol.COUPLE_MarriageInfo, nflag, sMessage)
end


-------------------------------------公有方法模块End----------------------------------------


