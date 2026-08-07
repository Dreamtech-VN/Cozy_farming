--ProtocolProcessorWndChest.lua
--@brief	背包模块协议
--@date  	2014/02/18
--@author 	xiaoyu_wu
--@note 	背包模块所使用协议


ProtocolProcessorWndChest = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndChest:regAll()
	--@brief	开启宝箱（SPREE_OpenBox = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SPREE, Protocol.SPREE_OpenBox, "ProtocolProcessorWndChest:send_SPREE_OpenBox_ErrorProcess", "is" )

	--@brief	获得宝箱物品列表（SPREE_OpenBoxOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_SPREE, Protocol.SPREE_OpenBoxOk, "ProtocolProcessorWndChest:parse_SPREE_OpenBoxOk", "vsvsvi")

end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndChest:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	开启宝箱（SPREE_OpenBox = 3）
function ProtocolProcessorWndChest:send_SPREE_OpenBox(itemId, num )
	WZLog("send_SPREE_OpenBox")
	local sender = Protocol:getSender( Protocol.MAIN_SPREE, Protocol.SPREE_OpenBox )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( itemId )	-- 宝箱ID（宝箱可以对应钥匙）
	sender:writeInt( num )	-- 物品数量
	SendProtocol(sender,false) --true:showLoading
end



-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	获得宝箱物品列表（SPREE_OpenBoxOk = 4）
function ProtocolProcessorWndChest:parse_SPREE_OpenBoxOk(itemName, itemIcon, itemNum)
	-- itemName : 物品名称
	-- itemIcon : 物品图标
	-- itemNum : 物品对应数量
	WZLog("ProtocolProcessorWndChest:parse_SPREE_OpenBoxOk")
	local vsName = VectorToTable(itemName)
	local vsPath = VectorToTable(itemIcon)
	local vnNum = VectorToTable(itemNum)
	WndChest:onOpenBoxSuccess(itemName,itemIcon,itemNum)
    WndRewardShow:showInterface(vsName,vsPath,vnNum)
	
end


-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	开启宝箱（SPREE_OpenBox = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndChest:send_SPREE_OpenBox_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndChest:send_SPREE_OpenBox_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPREE, Protocol.SPREE_OpenBox, nflag, sMessage)
	MsgBoxManager:showTipBox( sMessage )
end


