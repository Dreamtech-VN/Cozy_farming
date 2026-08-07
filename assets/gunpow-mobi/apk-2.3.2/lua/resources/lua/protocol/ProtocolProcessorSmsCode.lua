--ProtocolProcessorSmsCode.lua
--@brief	短代付费相关协议
--@date  	2014/8/18
--@author 	郭月奇
--@note 	短代付费相关协议


ProtocolProcessorSmsCode = ProtocolProcessorBase:new()


-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorSmsCode:regAll()
    --WZLog("ProtocolProcessorSmsCode:regAll")
    --@brief	返回短代项目列表
    self:regProtocolCallbackFunction( Protocol.MAIN_ERRORCODE, Protocol.ERRORCODE_GetSmsCodeNewListOk, "ProtocolProcessorSmsCode:parse_ERRORCODE_GetSmsCodeNewListOk", "vivivsvivsvsvivivsvs")
end 


--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSmsCode:unregAll()
    WZLog("ProtocolProcessorSmsCode:unregAll")
	self:clearReg()
end



-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	获取短代信息列表
function ProtocolProcessorSmsCode:send_GetSmsCodeNewList(chinnelId)
	WZLog("ProtocolProcessorSmsCode:send_StarSoul_GetStarSoul")
	local sender = Protocol:getSender( Protocol.MAIN_ERRORCODE, Protocol.ERRORCODE_GetSmsCodeNewList)
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( chinnelId )	-- 渠道号
	SendProtocol(sender,true) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	获取关卡信息成功
function ProtocolProcessorSmsCode:parse_ERRORCODE_GetSmsCodeNewListOk(id,price,sms_code, itemId, itemName, ItemIcon,type,count,remark1,remark2)
	--id : id 
	--price:短代价格
	--sms_code :短代号
	--itemId :物品Id
	--itemName:物品名称
	--ItemIcon ：物品Icon
	--type :数量类型 （0：天数  1：个数）
	--count: 物品数量
	--remark1 :短代支付说明
	--remark2 :非短代支付说明
	WZLog("ProtocolProcessorSmsCode:parse_ERRORCODE_GetSmsCodeNewListOk")
	
	SaveSmsCodeListInfo(VectorToTable(id), VectorToTable(price), VectorToTable(sms_code),VectorToTable(itemId),VectorToTable(itemName),VectorToTable(ItemIcon),VectorToTable(type),VectorToTable(count))

end









