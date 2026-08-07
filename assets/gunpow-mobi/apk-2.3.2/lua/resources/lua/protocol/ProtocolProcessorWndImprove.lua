--ProtocolProcessorWndImprove.lua
--@brief	装备升星相关协议
--@date  	2014/1/10
--@author 	SuYuan
--@note 	装备升星相关协议


ProtocolProcessorWndImprove = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndImprove:regAll()
	--服务器到客户端协议注册
	--获取升星信息成功(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_STAR, Protocol.STAR_UpgradeOk, "ProtocolProcessorWndImprove:parse_STAR_UpgradeOk", "")
	
	--协议错误处理
	--获取升星信息错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_STAR, Protocol.STAR_Upgrade, "ProtocolProcessorWndImprove:send_STAR_Upgrade_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndImprove:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------

--@brief	升星(C->S)
--@note		向服务器发送升星协议
function ProtocolProcessorWndImprove:send_STAR_Upgrade(itemdId, stoneId)
	WZLog("send_STAR_Upgrade")
	local sender = Protocol:getSender( Protocol.MAIN_STAR, Protocol.STAR_Upgrade )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( itemdId )	-- 物品id
	sender:writeInts( stoneId )	-- 升星石id
	SendProtocol(sender,false) --true:showLoading
    
end

-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------

--@brief	升星结果(S->C)
--@note		服务器返回升星结果时的回调函数
function ProtocolProcessorWndImprove:parse_STAR_UpgradeOk()
	WZLog("ProtocolProcessorWndImprove:parse_STAR_UpgradeOk")
	
	WndImproveStrengthen:onImproveSuccess()
end

-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------

--@brief	升星错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note		在此对协议错误进行相应处理
function ProtocolProcessorWndImprove:send_STAR_Upgrade_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndImprove:send_STAR_Upgrade_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_STAR, Protocol.STAR_Upgrade, nflag, sMessage)

	if WndImproveStrengthen ~= nil then
		WndImproveStrengthen:onImproveError(sMessage)
	end
end

-------------------------------------协议错误处理方法模块End--------------------------------------





