--ProtocolProcessorWndRedemptionCode.lua
--@brief	礼包兑换模块
--@date  	2013/12/25
--@author 	liangguang_long
--@note 	礼包兑换模块


ProtocolProcessorWndRedemptionCode = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndRedemptionCode:regAll()
	--@brief	发送兑换码成功（EXCHANGECODE_SendExchangeCodeOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_EXCHANGECODE, Protocol.EXCHANGECODE_SendExchangeCodeOk, "ProtocolProcessorWndRedemptionCode:parse_EXCHANGECODE_SendExchangeCodeOk", "vivii")

	--协议错误注册
	--@brief	弹弹岛礼包码兑换(MAIN_EXCHANGECODE = 82)
	self:regProtocolCallbackFunction( Protocol.MAIN_EXCHANGECODE, Protocol.EXCHANGECODE_SendExchangeCode , "ProtocolProcessorWndRedemptionCode:parse_EXCHANGECODE_SendExchangeCodeErrorMessage", "is" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndRedemptionCode:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	弹弹岛礼包码兑换(MAIN_EXCHANGECODE = 82)
function ProtocolProcessorWndRedemptionCode:send_EXCHANGECODE_SendExchangeCode(code )
	WZLog("send_EXCHANGECODE_SendExchangeCode")
	local sender = Protocol:getSender( Protocol.MAIN_EXCHANGECODE, Protocol.EXCHANGECODE_SendExchangeCode )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( code )	-- 兑换码23位字符包括三个'-'
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	发送兑换码成功（EXCHANGECODE_SendExchangeCodeOk = 2）
function ProtocolProcessorWndRedemptionCode:parse_EXCHANGECODE_SendExchangeCodeOk(itemId, itemCount, msgCode)
	-- itemId : 物品id
	-- itemCount : 物品数量
	-- msgCode : 信息编号
	--0、兑换成功，
	--2、该激活码已经兑换过
	-- -1、你已经使用过兑换码了
	--其它、提示网络连接问题稍后再试
	WZLog("ProtocolProcessorWndRedemptionCode:parse_EXCHANGECODE_SendExchangeCodeOk",msgCode,Serialize(VectorToTable(itemId)),Serialize(VectorToTable(itemCount)))
	if msgCode == 0 then
		WndRewardShow:showById(VectorToTable(itemId),VectorToTable(itemCount))
		WndGameGift:normalClose()
	elseif msgCode == 2 then
		MsgBoxManager:showTipBox(LocalStrings.SETTING_EXCHANGEWORD1)
	elseif msgCode == -1 then
		MsgBoxManager:showTipBox(LocalStrings.SETTING_EXCHANGEWORD2)
	else
		MsgBoxManager:showTipBox(LocalStrings.SETTING_EXCHANGEWORD3)
	end
end

-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	弹弹岛礼包码兑换(MAIN_EXCHANGECODE = 82)失败
function ProtocolProcessorWndRedemptionCode:parse_EXCHANGECODE_SendExchangeCodeErrorMessage(isexit , message)
	WZLog( "RebirthErrorMessage::2 ",KLuaSocket:utfToGBK(message) )
	--MsgBoxManager:showTipBox( LocalStrings.VIP_INFOFAIL ) 
end

-------------------------------------公有方法模块End----------------------------------------


