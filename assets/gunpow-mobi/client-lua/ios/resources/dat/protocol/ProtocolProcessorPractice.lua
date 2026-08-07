--ProtocolProcessorPractice.lua
--@brief	修炼系统相关协议
--@date  	2014/08/25
--@author 	jiaming_liu
--@note 	修炼系统相关协议


ProtocolProcessorPractice = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorPractice:regAll()
	--服务器到客户端协议注册
	--@brief	获取修炼图列表等信息成功
	self:regProtocolCallbackFunction( Protocol.MAIN_PRACTICE, Protocol.PRACTICE_GetPracticeOk, "ProtocolProcessorPractice:parse_PRACTICE_GetPracticeOk", "vsviiviviviiiiiiiii")
	--@brief	点亮下一个星点成功
	self:regProtocolCallbackFunction( Protocol.MAIN_PRACTICE, Protocol.PRACTICE_LightNextPracticeOk, "ProtocolProcessorPractice:parse_PRACTICE_LightNextPracticeOk", "iiiib")
	--@brief	激活
	self:regProtocolCallbackFunction( Protocol.MAIN_PRACTICE, Protocol.PRACTICE_ActivatePracticeOk, "ProtocolProcessorPractice:parse_PRACTICE_ActivatePracticeOk", "ii")

	--协议错误处理	
	--@brief	获取修炼图列表等信息成功错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PRACTICE, Protocol.PRACTICE_GetPractice, "ProtocolProcessorPractice:send_PRACTICE_GetPractice_ErrorProcess", "is" )
	--@brief	点亮下一个星点错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PRACTICE, Protocol.PRACTICE_LightNextPractice, "ProtocolProcessorPractice:send_PRACTICE_LightNextPractice_ErrorProcess", "is" )
	--@brief	激活错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PRACTICE, Protocol.PRACTICE_ActivatePractice, "ProtocolProcessorPractice:send_PRACTICE_ActivatePractice_ErrorProcess", "is" )

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorPractice:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	获取修炼图列表等信息
function ProtocolProcessorPractice:send_PRACTICE_GetPractice( playerId )
	WZLog("ProtocolProcessorPractice:send_PRACTICE_GetPractice")
	local sender = Protocol:getSender( Protocol.MAIN_PRACTICE, Protocol.PRACTICE_GetPractice )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )
	SendProtocol(sender,true) --true:showLoading
end

--@brief	点亮下一个星点成功
function ProtocolProcessorPractice:send_PRACTICE_LightNextPractice(bonusAttribute, itemId, useNumber)
	-- bonusAttribute : 修炼的属性key
	-- itemId : 消耗勋章id
	-- useNumber : 使用个数
	WZLog("ProtocolProcessorPractice:send_PRACTICE_LightNextPractice",bonusAttribute, itemId, useNumber)
	local sender = Protocol:getSender( Protocol.MAIN_PRACTICE, Protocol.PRACTICE_LightNextPractice )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( bonusAttribute )
	sender:writeInt( itemId )
	sender:writeInt( useNumber )
	SendProtocol(sender,true) --true:showLoading
end

--@brief	激活
function ProtocolProcessorPractice:send_PRACTICE_ActivatePractice( )
	WZLog("ProtocolProcessorPractice:send_PRACTICE_ActivatePractice")
	local sender = Protocol:getSender( Protocol.MAIN_PRACTICE, Protocol.PRACTICE_ActivatePractice )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,true) --true:showLoading
end




-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------
--@brief	获取修炼图列表等信息成功
function ProtocolProcessorPractice:parse_PRACTICE_GetPracticeOk(bonusAttribute, bonusIndex, bonusLeve, playerBonusExp, playerBonus, bonusValue, playerLeve, canLightLeve, needExp, lowMedalnumber, seniorMedlNumber, useLimitNumber, useTodayNumber, consumeMedalNumber)
	-- bonusAttribute : 修炼显示的加成属性（服务端传key，客户端显示value）
	-- bonusIndex : 属性索引
	-- bonusLeve : 玩家修炼属性对应的等级
	-- playerBonusExp : 玩家自身属性exp
	-- playerBonus : 玩家自身属性exp
	-- bonusValue : 属性下一级别等级加成值
	-- playerLeve : 玩家所需等级
	-- canLightLeve : 玩家可以点亮最高等级
	-- needExp : 当前等级需要总的经验（进度条中的总数）
	-- lowMedalnumber : 玩家拥有的低级勋章总数
	-- seniorMedlNumber : 玩家拥有的高级勋章总数
	-- useLimitNumber : 使用勋章上限数
	-- useTodayNumber : 今日还可以使用勋章数
	-- state : 是否激活
	-- consumeMedalNumber : 当前等级激活每日扣除勋章数
	WZLog("ProtocolProcessorPractice:parse_PRACTICE_GetPracticeOk")
	WndPractice:getPracticeOk(bonusAttribute, bonusIndex, bonusLeve, playerBonusExp, playerBonus, bonusValue, playerLeve, canLightLeve, needExp, lowMedalnumber, seniorMedlNumber, useLimitNumber, useTodayNumber, true--[[state,协议屏蔽]], consumeMedalNumber)
end


--@brief	点亮下一个星点成功
function ProtocolProcessorPractice:parse_PRACTICE_LightNextPracticeOk(lowMedalnumber, seniorMedlNumber, useTodayNumber, playerBonusExp, upgrade, status)
	-- lowMedalnumber	玩家拥有的第级勋章总数
	-- seniorMedlNumber	玩家拥有的高级勋章总数
	-- useTodayNumber	今日还可以使用勋章数
	-- playerBonusExp	玩家自身属性exp
	-- upgrade	是否升级
	WZLog("ProtocolProcessorPractice:parse_PRACTICE_LightNextPracticeOk")
	WndPractice:lightNextPracticeOk(lowMedalnumber, seniorMedlNumber, useTodayNumber, playerBonusExp, upgrade, true)--status)
end


--@brief	激活
function ProtocolProcessorPractice:parse_PRACTICE_ActivatePracticeOk(lowMedalnumber, seniorMedlNumber, state)
	-- lowMedalnumber	: 玩家拥有的低级勋章总数
	-- seniorMedlNumber : 玩家拥有的高级勋章总数
	WZLog("ProtocolProcessorPractice:parse_PRACTICE_ActivatePracticeOk")
	WndPractice:activatePracticeOk(lowMedalnumber, seniorMedlNumber, true)--state)
end


-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------

--@brief	获取修炼图列表等信息成功错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPractice:send_PRACTICE_GetPractice_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPractice:send_PRACTICE_GetPractice_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PRACTICE, Protocol.PRACTICE_GetPractice, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	点亮下一个星点错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPractice:send_PRACTICE_LightNextPractice_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPractice:send_PRACTICE_LightNextPractice_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PRACTICE, Protocol.PRACTICE_LightNextPractice, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	激活错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPractice:send_PRACTICE_ActivatePractice_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPractice:send_PRACTICE_ActivatePractice_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PRACTICE, Protocol.PRACTICE_ActivatePractice, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------





