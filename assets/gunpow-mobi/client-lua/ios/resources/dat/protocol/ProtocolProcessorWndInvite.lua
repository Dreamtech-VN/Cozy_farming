--ProtocolProcessorWndInvite.lua
--@brief	邀请码相关协议
--@date  	2013/12/25
--@author 	liangguang_long
--@note 	邀请码相关协议


ProtocolProcessorWndInvite = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndInvite:regAll()

	--@brief	获取当前玩家邀请码的信息（INVITE_GetInviteInfoOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteInfoOk, "ProtocolProcessorWndInvite:parse_INVITE_GetInviteInfoOk", "siivsvsvisbs")
	--@brief	获取成功邀请玩家的信息（INVITE_GetInviteListOk = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteListOk, "ProtocolProcessorWndInvite:parse_INVITE_GetInviteListOk", "vsvsii")
	--@brief	玩家领取邀请奖励（INVITE_GetInviteRewardOk = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteRewardOk, "ProtocolProcessorWndInvite:parse_INVITE_GetInviteRewardOk", "")
	--@brief	绑定结果（INVITE_BindInviteResult = 8）
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_BindInviteResult, "ProtocolProcessorWndInvite:parse_INVITE_BindInviteResult", "i")


	--协议错误注册
	--获取当前玩家邀请码的信息（INVITE_GetInviteInfo = 1） 失败
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteInfo , "ProtocolProcessorWndInvite:parse_INVITE_GetInviteInfoErrorMessage", "is" )
	--获取成功邀请玩家的信息（INVITE_GetInviteList = 3） 失败
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteList , "ProtocolProcessorWndInvite:parse_INVITE_GetInviteListErrorMessage", "is" )
	--玩家领取邀请奖励（INVITE_GetInviteReward = 5） 失败
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteReward , "ProtocolProcessorWndInvite:parse_INVITE_GetInviteRewardErrorMessage", "is" )
	--绑定邀请码（INVITE_BindInvite = 7） 失败
	self:regProtocolCallbackFunction( Protocol.MAIN_INVITE, Protocol.INVITE_BindInvite , "ProtocolProcessorWndInvite:parse_INVITE_BindInviteErrorMessage", "is" )
	
	
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndInvite:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief	获取当前玩家邀请码的信息（INVITE_GetInviteInfo = 1）
function ProtocolProcessorWndInvite:send_INVITE_GetInviteInfo( )
	WZLog("send_INVITE_GetInviteInfo1")
	local sender = Protocol:getSender( Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取成功邀请玩家的信息（INVITE_GetInviteList = 3）
function ProtocolProcessorWndInvite:send_INVITE_GetInviteList( pageIndex )
	WZLog("send_INVITE_GetInviteList")
	local sender = Protocol:getSender( Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( pageIndex )	-- 当前显示的页数
	SendProtocol(sender,false) 		--true:showLoading
end

--@brief	玩家领取邀请奖励（INVITE_GetInviteReward = 5）
function ProtocolProcessorWndInvite:send_INVITE_GetInviteReward( )
	WZLog("send_INVITE_GetInviteReward")
	local sender = Protocol:getSender( Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteReward )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	绑定邀请码（INVITE_BindInvite = 7）
function ProtocolProcessorWndInvite:send_INVITE_BindInvite( inviteCode )
	WZLog("send_INVITE_BindInvite")
	local sender = Protocol:getSender( Protocol.MAIN_INVITE, Protocol.INVITE_BindInvite )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( inviteCode )	-- 绑定的邀请码
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	获取当前玩家邀请码的信息（INVITE_GetInviteInfoOk = 2）
function ProtocolProcessorWndInvite:parse_INVITE_GetInviteInfoOk(inviteCode, total, amount, names, rewards, counts, remark, canReward, bindInviteCode)
	-- inviteCode : 玩家的邀请码
	-- total : 当前奖励级别需要邀请的玩家数量
	-- amount : 已邀请的玩家数量
	-- names : 奖励物品的名称
	-- rewards : 奖励物品的图标
	-- counts : 奖励物品的数量
	-- remark : 奖励说明
	-- canReward : 是否可以获取奖励
	-- bindInviteCode : 玩家绑定的邀请码（未绑定为空字符串）
	WZLog("ProtocolProcessorWndInvite:parse_INVITE_GetInviteInfoOk" , inviteCode , total , amount)
	WndInvite:setInviteList( inviteCode, total, amount, names, rewards, counts, remark, canReward, bindInviteCode )
end

--@brief	获取成功邀请玩家的信息（INVITE_GetInviteListOk = 4）
function ProtocolProcessorWndInvite:parse_INVITE_GetInviteListOk(serviceName, playerName, pageIndex, pageCount)
	-- serviceName : 服务器名称
	-- playerName : 角色名称
	-- pageIndex : 当前显示的页数
	-- pageCount : 总页数
	WZLog("ProtocolProcessorWndInvite:parse_INVITE_GetInviteListOk1")
	WndInviteSuccess:setInviteList( serviceName, playerName, pageIndex, pageCount )
end

--@brief	玩家领取邀请奖励（INVITE_GetInviteRewardOk = 6）
function ProtocolProcessorWndInvite:parse_INVITE_GetInviteRewardOk()
	WZLog("ProtocolProcessorWndInvite:parse_INVITE_GetInviteRewardOk")
	WndInvite:inviteRewardSuccess()
	--@brief   关闭加载框
	WndInvite:closeLoading()
end

--@brief	绑定结果（INVITE_BindInviteResult = 8）
function ProtocolProcessorWndInvite:parse_INVITE_BindInviteResult(status)
	-- status : 0绑定成功，1绑定失败
	WZLog("ProtocolProcessorWndInvite:parse_INVITE_BindInviteResult" , status )
	if status == 0 then
		WndInvite:bindInviteCodeSuccess()
	end
end

-------------------------------------协议错误处理方法模块--------------------------------------

--@brief  	获取当前玩家邀请码的信息（INVITE_GetInviteInfo = 1） 失败
function ProtocolProcessorWndInvite:parse_INVITE_GetInviteInfoErrorMessage(isexit , message)
	WZLog( "RebirthErrorMessage::2 ",KLuaSocket:utfToGBK(message) )
	--MsgBoxManager:showTipBox( LocalStrings.VIP_INFOFAIL ) --获取获取当前玩家邀请码的信息失败
	--@brief   关闭加载框
	WndInvite:closeLoading()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteInfo, isexit, message)
end

--@brief	获取成功邀请玩家的信息（INVITE_GetInviteList = 3） 失败
function ProtocolProcessorWndInvite:parse_INVITE_GetInviteListErrorMessage(isexit , message)
	WZLog( "RebirthErrorMessage::2 ",KLuaSocket:utfToGBK(message) )
	--MsgBoxManager:showTipBox( LocalStrings.VIP_INFOFAIL ) --获取邀请玩家的信息失败
	--@brief   关闭加载框
	WndInvite:closeLoading()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteList, isexit, message)
end

--@brief	玩家领取邀请奖励（INVITE_GetInviteReward = 5）  失败
function ProtocolProcessorWndInvite:parse_INVITE_GetInviteRewardErrorMessage(isexit , message)
	WZLog( "RebirthErrorMessage::2 ",KLuaSocket:utfToGBK(message) )
	--MsgBoxManager:showTipBox( LocalStrings.VIP_INFOFAIL ) --获取玩家领取邀请奖励失败
	--@brief   关闭加载框
	WndInvite:closeLoading()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_INVITE, Protocol.INVITE_GetInviteReward, isexit, message)
end

--@brief	绑定邀请码（INVITE_BindInvite = 7）  失败
function ProtocolProcessorWndInvite:parse_INVITE_BindInviteErrorMessage(isexit , message)
	WZLog( "RebirthErrorMessage::2 ",KLuaSocket:utfToGBK( message ) )
	--MsgBoxManager:showTipBox( LocalStrings.VIP_INFOFAIL ) --绑定邀请码失败
	--@brief   关闭加载框
	WndInvite:closeLoading()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_INVITE, Protocol.INVITE_BindInvite, isexit, message)
end
-------------------------------------公有方法模块End----------------------------------------


