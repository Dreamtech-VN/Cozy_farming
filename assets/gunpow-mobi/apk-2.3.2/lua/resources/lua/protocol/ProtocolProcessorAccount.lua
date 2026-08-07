--ProtocolProcessorAccount.lua
--@brief	账号相关协议
--@date  	2013/12/09
--@author 	SuYuan
--@note 	账号相关协议


ProtocolProcessorAccount = ProtocolProcessorBase:new()

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorAccount:regAll()
	--帐号登录成功(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_LoginOk, "ProtocolProcessorAccount:parse_ACCOUNT_LoginOk", "bb")
	--帐号登录失败(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_LoginFail, "ProtocolProcessorAccount:parse_ACCOUNT_LoginFail", "s")
	--@brief	发送角色列表（ACCOUNT_SendRoleActorList = 13）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SendRoleActorList, "ProtocolProcessorAccount:parse_ACCOUNT_SendRoleActorList", "iivivsvs")

	--@brief	角色登录成功（ACCOUNT_RoleActorLoginOk = 23）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_RoleActorLoginOk, "ProtocolProcessorAccount:parse_ACCOUNT_RoleActorLoginOk", "isiiiisiisvsiiibiiiiiiiistis")
	--返回随机名称(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetRandomNameOk, "ProtocolProcessorAccount:parse_ACCOUNT_GetRandomNameOk", "s")
	--设置token成功(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SetTokenOk, "ProtocolProcessorAccount:parse_ACCOUNT_SetTokenOk", "")
	--渠道登录结果(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_ChannelLoginResult, "ProtocolProcessorAccount:parse_ACCOUNT_ChannelLoginResult", "ss")
	--帐号注册成功(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_RegisterOk, "ProtocolProcessorAccount:parse_ACCOUNT_RegisterOk", "b")
	--快速帐号注册成功(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_QuickRegisterOk, "ProtocolProcessorAccount:parse_ACCOUNT_QuickRegisterOk", "")
	--帐号注册失败(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_RegisterFail, "ProtocolProcessorAccount:parse_ACCOUNT_RegisterFail", "s")
	--修改密码成功(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_ModifyPasswordOk, "ProtocolProcessorAccount:parse_ACCOUNT_ModifyPasswordOk", "")
	--修改密码失败(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_ModifyPasswordFail, "ProtocolProcessorAccount:parse_ACCOUNT_ModifyPasswordFail", "s")
	--找回密码成功(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_FindPasswordOk, "ProtocolProcessorAccount:parse_ACCOUNT_FindPasswordOk", "s")
	--帐号密码验证结果(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_VerificationResult, "ProtocolProcessorAccount:parse_ACCOUNT_VerificationResult", "i")
	--用户重复登录账号(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_RepeatLogin, "ProtocolProcessorAccount:parse_ACCOUNT_RepeatLogin", "s")
    --@brief	获取小岛节日状态成功
    self:regProtocolCallbackFunction( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_GetIslandStateOk, "ProtocolProcessorAccount:parse_SYSTEM_GetIslandStateOk", "ibbibb")
    --@brief	推送玩家的按钮信息
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_PlayerButtonInfo, "ProtocolProcessorAccount:parse_PLAYER_PlayerButtonInfo", "vivtvivb")
    --@brief	获取下载奖励列表成功(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetDownloadRewardListOK, "ProtocolProcessorAccount:parse_ACCOUNT_GetDownloadRewardListOK", "vivii")
	--协议错误处理	
	--帐号登录协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_Login, "ProtocolProcessorAccount:send_ACCOUNT_Login_ErrorProcess", "is" )
	--创建角色协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_CreateRoleActor, "ProtocolProcessorAccount:send_ACCOUNT_CreateRoleActor_ErrorProcess", "isss")
	--获取角色列表协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetRoleActorList, "ProtocolProcessorAccount:send_ACCOUNT_GetRoleActorList_ErrorProcess", "is" )
	--角色登录协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_RoleActorLogin, "ProtocolProcessorAccount:send_ACCOUNT_RoleActorLogin_ErrorProcess", "is" )
	--帐号重新登录协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_LoginAgain, "ProtocolProcessorAccount:send_ACCOUNT_LoginAgain_ErrorProcess", "is" )
	--获取随机名称协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetRandomName, "ProtocolProcessorAccount:send_ACCOUNT_GetRandomName_ErrorProcess", "is" )
	--设置帐号关联的token协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SetToken, "ProtocolProcessorAccount:send_ACCOUNT_SetToken_ErrorProcess", "is" )
	--渠道登录验证协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_ChannelLogin, "ProtocolProcessorAccount:send_ACCOUNT_ChannelLogin_ErrorProcess", "is" )
	--客户端退到后台协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_ToBackGround, "ProtocolProcessorAccount:send_ACCOUNT_ToBackGround_ErrorProcess", "is" )
	--客户端回到前台协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_FromBackGround, "ProtocolProcessorAccount:send_ACCOUNT_FromBackGround_ErrorProcess", "is" )
	--帐号注册协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_Register, "ProtocolProcessorAccount:send_ACCOUNT_Register_ErrorProcess", "is" )
	--修改密码协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_ModifyPassword, "ProtocolProcessorAccount:send_ACCOUNT_ModifyPassword_ErrorProcess", "is" )
	--找回密码协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_FindPassword, "ProtocolProcessorAccount:send_ACCOUNT_FindPassword_ErrorProcess", "is" )
	--帐号密码验证协议错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_Verification, "ProtocolProcessorAccount:send_ACCOUNT_Verification_ErrorProcess", "is" )
	--获取小岛节日状态错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_GetIslandState, "ProtocolProcessorAccount:send_SYSTEM_GetIslandState_ErrorProcess", "is" )
	--@brief	发送玩家微博ID（PLAYER_SetPlayerWeiboId = 45）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_SetPlayerWeiboId, "ProtocolProcessorAccount:send_PLAYER_SetPlayerWeiboId_ErrorProcess", "is" )

    --@brief	获取下载奖励列表错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetDownloadRewardList, "ProtocolProcessorAccount:parse_ACCOUNT_GetDownloadRewardList_ErrorProcess", "is")
    
    --弃用
	--@brief	同步玩家帐号绑定状态（ACCOUNT_SynAccountState = 65）错误处理(S->C)
	--self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SynAccountState, "ProtocolProcessorAccount:send_ACCOUNT_SynAccountState_ErrorProcess", "is" )

    --@brief	设置邮箱（ACCOUNT_SetEMail = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SetEMail, "ProtocolProcessorAccount:send_ACCOUNT_SetEMail_ErrorProcess", "is" )

    --@brief	设置邮箱（ACCOUNT_SetEMailOk = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SetEMailOk, "ProtocolProcessorAccount:parse_ACCOUNT_SetEMailOk", "i")

    --@brief	同步按钮状态协议（SYSTEM_SynButtonInfo = 26）
    self:regProtocolCallbackFunction( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_SynButtonInfo, "ProtocolProcessorAccount:parse_SYSTEM_SynButtonInfo", "vivivivi")

    --@brief	返回关于游戏信息
    self:regProtocolCallbackFunction( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_GetRankMatchOk, "ProtocolProcessorAccount:parse_SYSTEM_GetRankMatchOk", "i")

	--@brief	登陆下发服务器及服务器名称（SYSTEM_GetRankMatchOk = 28）
	self:regProtocolCallbackFunction( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_GetServerInfo, "ProtocolProcessorAccount:parse_SYSTEM_GetServerInfo", "vsvsvs")

	--@brief	获取角色信息列表（ACCOUNT_GetRoleActorInfo = 40）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetRoleActorInfo, "ProtocolProcessorAccount:send_ACCOUNT_GetRoleActorInfo_ErrorProcess", "is" )

	--@brief	发送角色信息列表（ACCOUNT_GetRoleActorInfoOk = 41）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetRoleActorInfoOk, "ProtocolProcessorAccount:parse_ACCOUNT_GetRoleActorInfoOk", "vivsvivsvivsvivivivivivsvtvivivi")

	--@brief	同步广告信息协议（SYSTEM_SynAdMessage = 29）
	self:regProtocolCallbackFunction( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_SynAdMessage, "ProtocolProcessorAccount:parse_SYSTEM_SynAdMessage", "vsvsvivi")

    --@brief	查看玩家是否在线（PLAYER_CheckOnline = 90）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_CheckOnline, "ProtocolProcessorAccount:send_PLAYER_CheckOnline_ErrorProcess", "is" )

    --@brief	查看玩家是否在线（PLAYER_CheckOnlineOk = 91）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_CheckOnlineOk, "ProtocolProcessorAccount:parse_PLAYER_CheckOnlineOk", "vivi")

    --@brief	查看玩家是否在线（PLAYER_CheckFirstWeChat = 92）
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_CheckFirstWeChat, "ProtocolProcessorAccount:parse_PLAYER_CheckFirstWeChat", "s")
    --@brief	用户注销（ACCOUNT_Unregister = 65）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_Unregister, "ProtocolProcessorAccount:send_ACCOUNT_Unregister_ErrorProcess", "is")
	--@brief	用户注销（ACCOUNT_UnregisterOk = 66）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_UnregisterOk, "ProtocolProcessorAccount:parse_ACCOUNT_UnregisterOk", "ii")
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorAccount:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------

--@brief	帐号登录(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_Login(token,deviceInfo)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_Login")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_Login )
	if sender==nil then WZLog("sender == nil") return end
     WZLog("token1",token,type(token))

	sender:writeString(token)	-- token验证
	sender:writeString(deviceInfo)	-- token验证

    local versionFileUrl = ""
    local clentVersion = "0.0.0"
    if true and tonumber(ProjConfig.USE_DOWNLOAD) == 1 then
        versionFileUrl = ProjConfig.UPDATE_URL
        clentVersion = WZUpdateManager:getUpdateVersion()
    end

    sender:writeString(versionFileUrl)	--版本文件地址
    sender:writeString(clentVersion)	--版本号

	WZLog("ProtocolProcessorAccount:send_ACCOUNT_Login--------end-----",versionFileUrl, clentVersion)
	SendProtocol(sender,false, true) --true:showLoadding
end

--@brief	创建角色(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_CreateRoleActor(playerName, playerSex, area )
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_CreateRoleActor )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( playerName )	-- 角色名称
	sender:writeByte( playerSex )	-- 角色性别
	sender:writeString(GlobalGame.g_oppo_channel) 	--oppo渠道买量渠道
	sender:writeString(GlobalGame.g_oppo_adId)	--oppo渠道买量广告id
	sender:writeString( area )	-- "含手机信息：
	SendProtocol(sender,false) --true:showLoadding
    
end

--@brief	获取角色列表(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_GetRoleActorList( )
	WZLog("Send_ACCOUNT_GetRoleActorList")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetRoleActorList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoadding
end

--@brief	角色登录(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_RoleActorLogin(playerName)
	WZLog("Send_ACCOUNT_RoleActorLogin")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_RoleActorLogin )
	if sender==nil then WZLog("sender == nil") return end
	PostPlayerEvent:postEvent(PostPlayerEvent.event_roleActorLogin)
	WZLog("playerName: ", KLuaSocket:utfToGBK(playerName))
	sender:writeString( playerName )	-- 角色名称
	SendProtocol(sender,false) --true:showLoadding
end

--@brief	帐号重新登录(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_LoginAgain(udid, accountName, passWord, version, channel, playerName )
	WZLog("Send_ACCOUNT_LoginAgain")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_LoginAgain )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeStringEncrypt( udid )	-- ios设备id
	sender:writeStringEncrypt( accountName )	-- 帐号（暂时和udid一样）
	sender:writeStringEncrypt( passWord )	-- udid加密后的字符串
	sender:writeString( version )	-- 版本信息
	sender:writeInt( channel )	-- 渠道号
	sender:writeString( playerName )	-- 角色名称
	SendProtocol(sender,false,true) --true:showLoadding
end

--@brief	返回关于游戏信息
function ProtocolProcessorAccount:parse_SYSTEM_GetRankMatchOk(openDay)
    -- openDay : 距离开放排位赛的天数
    WZLog("ProtocolProcessorAccount:parse_SYSTEM_GetRankMatchOk", openDay)
    GlobalGame.g_nRankOpenDay = openDay
end

--@brief	获取随机名称(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_GetRandomName(sex )
	WZLog("Send_ACCOUNT_GetRandomName")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetRandomName )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( sex )	-- 角色性别（0男，1女）
	SendProtocol(sender,false) --true:showLoadding
end

--@brief	设置帐号关联的token(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_SetToken(udid, token )
	WZLog("Send_ACCOUNT_SetToken")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SetToken )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( udid )	-- ios设备id
	sender:writeString( token )	-- 设备的token
	SendProtocol(sender,false) --true:showLoadding
end

--@brief	渠道登录验证(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_ChannelLogin(channel, parameter )
	WZLog("Send_ACCOUNT_ChannelLogin")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_ChannelLogin )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( channel )	-- 渠道号
	sender:writeStrings( parameter )	-- 渠道登录验证参数
	SendProtocol(sender,false) --true:showLoadding
end

--@brief	客户端退到后台(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_ToBackGround( datet )
	WZLog("Send_ACCOUNT_ToBackGround")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_ToBackGround )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( datet )	-- 退到后台的日期时间
	SendProtocol(sender,false) --true:showLoadding
    KLuaMutiRegSocket:getInstance():breath()
end

--@brief	客户端回到前台(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_FromBackGround( datet )
	WZLog("Send_ACCOUNT_FromBackGround")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_FromBackGround )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( datet )	-- 回到前台的日期时间
	SendProtocol(sender,false) --true:showLoadding
end

--@brief	帐号注册(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_Register(accountName, passWord,email )
	WZLog("Send_ACCOUNT_Register")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_Register )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( accountName )	-- 帐号（加密后的字符串）
	sender:writeString( passWord )	-- 密码（加密后的字符串）
	sender:writeString( email )	-- 邮箱地址（加密后的字符串）
	
	SendProtocol(sender,false) --true:showLoadding
end

--@brief	修改密码(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_ModifyPassword(oldPassword, newPassword )
	WZLog("Send_ACCOUNT_ModifyPassword")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_ModifyPassword )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( oldPassword )	-- 旧密码
	sender:writeString( newPassword )	-- 新密码
	SendProtocol(sender,false) --true:showLoadding
end

--@brief	找回密码(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_FindPassword(Email )
	WZLog("Send_ACCOUNT_FindPassword")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_FindPassword )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( Email )	-- 邮箱
	SendProtocol(sender,false) --true:showLoadding
end

--@brief	帐号密码验证(C->S)
function ProtocolProcessorAccount:send_ACCOUNT_Verification(accountName, passWord )
	WZLog("Send_ACCOUNT_Verification")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_Verification )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeStringEncrypt( accountName )	-- 帐号（加密后的字符串）
	sender:writeStringEncrypt( passWord )	-- 密码（加密后的字符串）
	SendProtocol(sender,false) --true:showLoadding
end

--@brief	获取小岛节日状态(C->S)
function ProtocolProcessorAccount:send_SYSTEM_GetIslandState( )
	WZLog("send_SYSTEM_GetIslandState")
	local sender = Protocol:getSender( Protocol.MAIN_SYSTEM, Protocol.SYSTEM_GetIslandState )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	发送玩家微博ID（PLAYER_SetPlayerWeiboId = 45）
function ProtocolProcessorAccount:send_PLAYER_SetPlayerWeiboId(weiboType, weiboID, weiboIcon )
	WZLog("send_PLAYER_SetPlayerWeiboId",weiboType,weiboID,weiboIcon)
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_SetPlayerWeiboId )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( weiboType )	-- 微博： 索引0：新浪微博  索引1：腾讯微博…
	sender:writeString( weiboID )	-- 微博id
	sender:writeString( weiboIcon )	-- 微博头像URL
	SendProtocol(sender,false) --true:showLoading
end

--@bridf  发送推送所需token及平台类型
function ProtocolProcessorAccount:send_Push_TokenAndPlaType(udid,token,deviceType)
	WZLog("send_Push_TokenAndPlaType")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SetNewToken)
	if sender==nil then WZLog("sender == nil") return end
    sender:writeString( udid )	-- 设配id(备用)
	sender:writeString( token )	-- token值
	sender:writeInt( deviceType )	-- 平台类型（0为IOS，1为Android）
	SendProtocol(sender,false) --true:showLoading
end

--@bridf  请求本地推送信息列表
function ProtocolProcessorAccount:send_request_PushMessageList(version)
	WZLog("send_request_PushMessageListqqqq",version)
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetPushList)
	if sender==nil then WZLog("sender == nil") return end
	sender:writeString( version )	-- 本地推送列表版本号
	SendProtocol(sender,false) --true:showLoading
end
--@bridf  请求下载奖励列表（适用于需要进行增量下载的渠道）
function ProtocolProcessorAccount:send_ACCOUNT_GetDownloadRewardList(level,state)
	WZLog("send_ACCOUNT_GetDownloadRewardList",level,state)
	local sender = Protocol:getSender(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetDownloadRewardList)
	if sender==nil then WZLog("sender==nil") return end
	sender:writeInt(level)  --拓展包下载等级
    sender:writeInt(state)  --下载奖励领取状态（0没领取 1已领取）
	SendProtocol(sender,false)
end

--弃用
--@brief	同步玩家帐号绑定状态（ACCOUNT_SynAccountState = 65）
-- function ProtocolProcessorAccount:send_ACCOUNT_SynAccountState(bind )
-- 	WZLog("send_ACCOUNT_SynAccountState")
-- 	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SynAccountState )
-- 	if sender==nil then WZLog("sender == nil") return end

-- 	sender:writeBoolean( bind )	-- 是否绑定
-- 	SendProtocol(sender,false) --true:showLoading
-- end

--@brief	获取角色信息列表（ACCOUNT_GetRoleActorInfo = 40）
function ProtocolProcessorAccount:send_ACCOUNT_GetRoleActorInfo( )
	WZLog("send_ACCOUNT_GetRoleActorInfo")
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetRoleActorInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	查看玩家是否在线（PLAYER_CheckOnline = 90）
function ProtocolProcessorAccount:send_PLAYER_CheckOnline(pid )
	WZLog("send_PLAYER_CheckOnline")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_CheckOnline )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( pid )	-- 玩家Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	用户注销（ACCOUNT_Unregister = 65）
function ProtocolProcessorAccount:send_ACCOUNT_Unregister(id, optType)
	WZLog("send_ACCOUNT_Unregister", id, optType)
	local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_Unregister )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(tonumber(id))	-- 角色id
	sender:writeInt(tonumber(optType))	-- 0、注销，1、取消注销
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------

--@brief	帐号登录成功(S->C)"
function ProtocolProcessorAccount:parse_ACCOUNT_LoginOk(register,bind)
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_LoginOk")
    GlobalGame.g_bisLogined = true

	self:send_ACCOUNT_GetRoleActorList()

    --记录idfa和idfv
    WZLog("ProtocolProcessorAccount:parse_ACCOUNT_LoginOk记录idfa和idfv")
    local data = WZDataFile:getInstance():getUserData()
    local macAddr = ""
    if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_IOS then
        local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("DandandaoUtils")
        if adapter then
            macAddr = adapter:callMethodByNameReturn("getIDFA","")
            WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())
        end
    end
    if macAddr == "" then
        macAddr = WGameCmUtil:GetUDID()
    end
    data:setStringValue("DeviceData", "idfa", macAddr)
            
    data:setStringValue("DeviceData", "idfv", WGameCmUtil:GetUDID())
    data:flush()
    --添加talkingdata登陆事件
    local  account = data:getStringValue("AccountData", "account")
    g_isRegist = register
    g_isBindMail = bind
end

--@brief	帐号登录失败(S->C)
function ProtocolProcessorAccount:parse_ACCOUNT_LoginFail(errContent)
	-- errContent : 失败原因
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_LoginFail")
	
	WndExistAccount:cbExistAccountLoginFailed(errContent)
end

--@brief	成功获取角色列表（ACCOUNT_SendRoleActorList = 13）
function ProtocolProcessorAccount:parse_ACCOUNT_SendRoleActorList(playerCount, defaultSex,playerId, playerName,loginTime)
	-- playerCount : 角色数量
    --defaultSex: 角色默认性别
    -- playerId: 玩家ID
	-- playerName : 角色名称数组
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_SendRoleActorList",playerCount,defaultSex,loginTime)
	--关闭创建角色界面加载框
	if WindowManager:ifSceneActive(SceneCreateActor) then
		SceneCreateActor:finishedLoading()
	end

	if 0 == playerCount then
         WZLog("playerCount:",playerCount)
         WZLog("playerCount:",WndLoadLuaResources.m_root) 
		if WndLoadLuaResources.m_root then
			WZLog("-----------defaultSex------------1",defaultSex)
            SceneCreateActor:showSceneUI(defaultSex)
   		else
    		WndExistAccount:closeWindow()
			WZLog("-----------defaultSex------------2",defaultSex)
            SceneCreateActor:showSceneUI(defaultSex)
    	end
        PassportSdkManager.b_createRole = true
	elseif 1 == playerCount then
         WZLog("playerCount:",playerCount)
		 if loginTime and loginTime:size() > 0 then
		 	PassportSdkManager.s_roleCreateTime = loginTime:get(0)
		 end

		 -- 洗练提示
		 WZLog("playerId:get(0)----",playerId:get(0),SceneCreateActor.m_root)
		 if SceneCreateActor.m_root then
		 	if PassportSdkManager.postGameInfoHK then
            	PassportSdkManager:postGameInfoHK("createRole_hk")
            end
			WZLog("------------------enter create role success--------------")
			PostPlayerEvent:postEvent(PostPlayerEvent.event_createActorSuccess,playerId:get(0))
            PassportSdkManager:postGameInfoHK("createRole_hk")
            if PassportSdkManager.postGameInfoBeiMei then
            	PassportSdkManager:postGameInfoBeiMei("createRole","success")
            end
			PostPlayerEvent:postEvent(PostPlayerEvent.event_selectCharaCreatSuccess,{playerId=playerId:get(0)})
			SaveSophisticAttVisible(playerId:get(0), true)
		 end
		 ProtocolProcessorAccount:send_ACCOUNT_RoleActorLogin(playerName:get(0))
	elseif playerCount > 1 then
		WZLog("-----cur role cnt--------------",playerCount)
		local hasPlayerId = false
        if g_selectPlayerId ~= nil then
			for i = 0,playerCount -1 do
				if g_selectPlayerId == playerId:get(i) then
					ProtocolProcessorAccount:send_ACCOUNT_RoleActorLogin(playerName:get(i))
					hasPlayerId = true
                    break
				end
			end			
		end
        if hasPlayerId ~= true then 
            ProtocolProcessorAccount:send_ACCOUNT_GetRoleActorInfo()
        end
--		--进入合并过的服务器
--         WZLog("进入合并过的服务器playerCount:",playerCount)
--		local data = WZDataFile:getInstance():getUserData()
--		local serverRoleStatus = data:getStringValue("AccountData", "ServerRoleStatus")
--		serverRoleStatus = tonumber(serverRoleStatus)
--		local loginPlayerName = data:getStringValue("AccountData", "PlayerName")
--		local bSelectRole = true
--
--		for i=0,playerName:size()-1,1 do
--			if playerName:get(i) == loginPlayerName then
--				bSelectRole = false
--				break
--			end
--		end
--
--		if bSelectRole or (serverRoleStatus ~= playerCount) then
--			local sceneCombinedServerSelectRole = SceneCombinedServerSelectRole:createElement()
--			SceneCombinedServerSelectRole:setRoleListData(playerCount, playerName, playerLevel,playerSex,zsLevel,doubleCard,vipLevel,playerRank,headMessage,faceMessage,bodyMessage,weapMessage,wingMessage,petMessage,weapLevel,weapSkillType)
--			replaceScene(sceneCombinedServerSelectRole)
--		else
--			ProtocolProcessorAccount:send_ACCOUNT_RoleActorLogin(loginPlayerName)
--		end
	end
	
	--保存服务器角色状态（合并服务器选择角色时需要用到的数据）
	local data = WZDataFile:getInstance():getUserData()
	if data ~= nil then
		data:setStringValue("AccountData", "ServerRoleStatus", playerCount)
		data:flush()
	end
	
	--注册全局协议
	if (not g_isGlobalProtocolReged) then
		ProtocolProcessorGlobal:regAll()
        ProtocolProcessorTeach:regAll()
        g_isGlobalProtocolReged = true
	end
end



--@brief	角色登录成功（ACCOUNT_RoleActorLoginOk = 23）
function ProtocolProcessorAccount:parse_ACCOUNT_RoleActorLoginOk(playerId, playerName, maxLevel, playerSex, level, exp, guildName, upgradeexp, vipLevel, player_title, wbUserId, zsleve, qualifyingLevel, honor, doubleCard, fighting, guildId, steps, vipMark, vipLastDay, guideLevel, blastLevel, guideLevel2, property, status, cancleTime, ip)
	-- playerId : 角色id
	-- playerName : 角色名称
	-- maxLevel : 最高等级
	-- playerSex : 性别
	-- level : 角色等级
	-- exp : 角色当前经验
	-- guildName : 公会名称
	-- upgradeexp : 角色当前升级所需经验
	-- vipLevel : vip等级，非vip返回0
	-- player_title : 称号
	-- wbUserId : 玩家微博id
	-- zsleve : 转生等级
	-- qualifyingLevel : 排位赛等级
	-- honor : 荣誉值
	-- doubleCard : 是否有双倍经验卡（true表示有）
	-- fighting : 战斗力
	-- guildId : 公会ID
	-- steps : 新手教程步骤
	-- vipMark : 是否vip
	-- vipLastDay : vip剩余数量
	-- guideLevel : 攻击自动制导最高等级
	-- blastLevel : 爆破地图最低等级
	-- guideLevel2 : 战斗技能引导最高等级
	-- property : 属性值 json 结构｛"1":400, "2":200｝
	-- status : 角色状态,0、禁言,1、正常,2、注销
	-- cancleTime : 注销时间,单位:秒
	-- ip : 客户端玩家ip
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_RoleActorLoginOk", playerId,playerName,level, status, cancleTime) 
	--重置:是否在主城已经显示了删除角色弹窗
	GlobalGame.g_bIsShowDelRoleTipsInMainCity = false
	g_selectPlayerId = playerId
	GlobalGame.g_bIfLoginOk = true
	GlobalGame.g_tPlayerInfo.nPlayerId = playerId
	GlobalGame.g_tPlayerInfo.sPlayerName = playerName
	GlobalGame.g_tPlayerInfo.nMaxLevel = maxLevel
	GlobalGame.g_tPlayerInfo.nPlayerSex = playerSex
    GlobalGame.g_tPlayerInfo.nLevel = level
    GlobalGame.g_tPlayerInfo.exp = exp
	GlobalGame.g_tPlayerInfo.sGuildName = guildName
	GlobalGame.g_tPlayerInfo.nUpgradeexp = upgradeexp
	GlobalGame.g_tPlayerInfo.nVipLevel = vipLevel
	GlobalGame.g_tPlayerInfo.sPlayer_title = player_title
	GlobalGame.g_tPlayerInfo.vsWbUserId = wbUserId
	GlobalGame.g_tPlayerInfo.nZsleve = zsleve
	GlobalGame.g_tPlayerInfo.nQualifyingLevel = qualifyingLevel 
	GlobalGame.g_tPlayerInfo.honor = honor 
	GlobalGame.g_tPlayerInfo.bDoubleCard = doubleCard 
	GlobalGame.g_tPlayerInfo.nFighting = fighting 
	GlobalGame.g_tPlayerInfo.nGuildId = guildId 
	GlobalGame.g_tPlayerInfo.nSteps = steps 
	GlobalGame.g_tPlayerInfo.nVipMark = vipMark 
	GlobalGame.g_tPlayerInfo.nVipLastDay = vipLastDay 
	GlobalGame.g_tPlayerInfo.nGuideLevel = guideLevel
	GlobalGame.g_tPlayerInfo.nBlastLevel = blastLevel 
	GlobalGame.g_tPlayerInfo.guideLevel2 = guideLevel2 
	GlobalGame.g_tPlayerInfo.property = property
	GlobalGame.g_tPlayerInfo.nPlayerStatus = status--2
	GlobalGame.g_tPlayerInfo.nUnregisterTime = cancleTime--1638272529
	if type(ip) == "string" then
		WZLog("ProtocolProcessorAccount:parse_ACCOUNT_RoleActorLoginOk", ip) 
		GlobalGame.g_tPlayerInfo.sClientIp = ip
	end
    g_canInvite = true
    GlobalGame:putSecretData("player_level","" .. level)
    --WZLog("GlobalGame:getSecretNumberData",GlobalGame:getSecretNumberData("player_level"))
    --统计玩家信息
    local packageName = WGameCmUtil:GetBundleIdentifier()
    if ProjConfig.LANGUAGE == "vn" then
    	if PassportSdkManager and PassportSdkManager.setGameContextVN then 
    		PassportSdkManager:setGameContextVN("setGameContext", playerId)
    	end
    	--if WZUISystem:getInstance():getPlatformInfo() and WZUISystem:getInstance():getPlatformInfo() == 2 then
    		--DSSdkManager:createBucket("wyd-vn-ddd2");
    	--end
    elseif packageName=="com.wyd.gplay.bombheroes" or packageName=="com.wyd.appstore.bombheroes" or packageName=="com.wyd.brgp.bombheroes" 
    	or packageName=="com.bombman.omgEU" or packageName=="com.bombman.omg" or packageName=="com.bombmaster.mg"  or 
    	packageName=="com.tutu.chibibomberios" or packageName=="com.tutu.chibibomberandroid" or packageName=="com.ios.rwt.bombcrash" 
    	or packageName  == "com.ios.jt.bombboombang" or packageName  == "com.wyd.samsung.bombheroes" or packageName  == "com.wyd.samsungbr.bombheroes" 
    	or packageName  == "com.letui.doombomb" or packageName  == "com.ios.jt.bombgala" or packageName=="com.wyd.gplay.bombheroesen" 
    	or packageName=="com.wyd.gplay.heroibomba" or packageName=="com.ios.edo.bomb" or packageName=="com.ios.rwt.bomberclash" 
    	or packageName=="com.edo.ios.Ihabombom" or packageName=="com.ios.jt.bombmonster" or packageName=="com.ios.jt.bouncelegends" 
    	or packageName=="com.ios.jt.bouncingchurch" or packageName=="com.ios.jt.bombcyclone" or packageName=="com.sfrz.ddd" 
    	or packageName=="com.ios.jt.shootertribe" or packageName=="com.DDBom.b" or packageName=="com.mh.jl" 
    	or packageName=="com.ios.jt.secrettreasure" or packageName=="dd.pd.cr" or packageName=="com.ios.jt.projectilefiring" 
    	 or packageName=="com.ios.jt.mysteriousland" or packageName=="com.ios.jt.galgun" then
    	DSSdkManager:createBucket("wyd-ddd2-ea"); --北美包单独出来
    else
    	DSSdkManager:createBucket("wyd-ddd2");
    end
	--保存登录的玩家名称（合并服务器选择角色时需要用到的数据）
	local data = WZDataFile:getInstance():getUserData()
	if data ~= nil then
		data:setStringValue("AccountData", "PlayerName", playerName)
		data:flush()
	end
	
    PostPlayerEvent:postEvent(PostPlayerEvent.event_roleActorLoginSuccess)
    if WndLoadLuaResources.m_root then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
        --获取新手教学状态..完成新手指引（TASK_TiroTask = 9）
        --ProtocolProcessorTeach:send_TASK_TiroTask( )
        --获取小岛节日状态
    --    self:send_SYSTEM_GetIslandState()
    else
        --获取新手教学状态..完成新手指引（TASK_TiroTask = 9）
        --ProtocolProcessorTeach:send_TASK_TiroTask( )
        --获取小岛节日状态
    --    self:send_SYSTEM_GetIslandState()
    end
    
    local isDataWithSDK = false
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    local config = nil
    if curSdkObj then
        config = curSdkObj.m_tConfig
        if config.SDKOtherConfig.isShowPlatFormWithLogin == "true" then
            isDataWithSDK = true
        end
    end

    if isDataWithSDK == true then
        local tshowPlatFormParams = {}
        tshowPlatFormParams.funType = "showPlatForm"
        tshowPlatFormParams.othersType = "showPlatForm"
        local data = WZDataFile:getInstance():getUserData()
        if nil == data then
            tshowPlatFormParams.userID = ""
            tshowPlatFormParams.serverCode = ""
        else
            tshowPlatFormParams.userID = data:getStringValue("AccountData", "account")
            tshowPlatFormParams.serverCode = data:getStringValue("IPDParam", "ServerId")
        end
        tshowPlatFormParams.uid = tostring(GlobalGame.g_tPlayerInfo.nPlayerId)
        tshowPlatFormParams.level = tostring(GlobalGame.g_tPlayerInfo.nLevel)
        tshowPlatFormParams.playerName = GlobalGame.g_tPlayerInfo.sPlayerName
        tshowPlatFormParams.gameName = "Bomb Me"
        tshowPlatFormParams.serverName = IPDhttpServer:getCurServerName()

        local sJsonArg = json.encode(tshowPlatFormParams)
        WZLog("WndRightMenu:onClickFacebookInvite sJsonArg", sJsonArg)
        curSdkObj:accountOthers(sJsonArg, nil, NIL)

    end
     --CW SDK
    if curSdkObj and curSdkObj.m_tConfig then
        if curSdkObj.m_tConfig.SDKOtherConfig.isCW == "true" then
            local tData = {}
			tData.funType = "cw_collect"
			tData.extend = ""
			tData.dataType = 1
			tData.serverId = 0
			local data = WZDataFile:getInstance():getUserData()
			if data then
				tData.serverId = tonumber(data:getStringValue("IPDParam", "ServerId"))
			end
			tData.roleName = playerName
			tData.roleLevel = level
            local sJsonArg = json.encode(tData)
            WZLog("WndRightMenu:onClickFacebookInvite sJsonArg", sJsonArg)
            curSdkObj:accountOthers(sJsonArg, nil, NIL)
        end
        if curSdkObj.m_tConfig.SDKOtherConfig.isNeedFastLogin == "true" then
            local tData = {}
			tData.funType = "getPaymentValue"
            local sJsonArg = json.encode(tData)
            WZLog("获取越南语充值方式", sJsonArg)
            curSdkObj:accountOthers(sJsonArg, PassportDefaultCallback.accountOthersCallback, PassportDefaultCallback)
        end
    end
    --支付，先请求充值列表
    RegisterProtolRecharge()
    bIsLoadInIsland = true
    --获取扩展包奖励
    if CCUserDefault:sharedUserDefault():getBoolForKey("isGetDownloadReward") == true then
        self:send_ACCOUNT_GetDownloadRewardList(tonumber(ProjConfig.EXTEND_LEVEL),1)
    else
        self:send_ACCOUNT_GetDownloadRewardList(tonumber(ProjConfig.EXTEND_LEVEL),0)
    end
    
    --添加本地推送
    g_TimePlayerLogin = os.time()
    WZLog("qqqqqqqq_登录时间",g_TimePlayerLogin)
    if g_checkPushNeedList ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_checkPushNeedList)
        g_checkPushNeedList = -1
    end
    g_checkPushNeedList = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(scheduleCheckIsNeedPushList, 0, false)
    
    local jesonOrder = readLastOrder()
    if jesonOrder ~= nil and jesonOrder ~= "" then
        local tResult = json.decode(jesonOrder)
        WZLog("readLastOrder()",tResult.m_orderNumber,tResult.m_orderkey)
        if tResult then
            if tResult.m_orderNumber ~=nil and tResult.m_orderkey ~= nil then
                ProtocolProcessorRecharge:send_PURCHASE_IOSSendProductCheckInfo(tResult.m_orderNumber, tonumber(tResult.m_playerId), tResult.m_orderkey ,tonumber(tResult.m_channelId))
            end
        end
    end
    
    WZLog("登录时间")
	--获取坐骑信息
	CacheCenter:getAllMountsData()
	if GlobalGame.g_isMounts == false then 
		--GlobalGame.g_isMounts = true
		ProtocolProcessorWndMounts:send_MOUNTS_GetAllMountsList()
	end
    --获取单人副本信息
    --ProtocolProcessorGlobal:send_SINGLEMAP_GetPoints(0)
--    CacheCenter:getSingleCopyData()
    --获取多人副本信息
    ProtocolProcessorGlobal:send_BOSSMAPROOM_GetBossMapList()
    --获取日常副本信息
    --ProtocolProcessorGlobal:send_SINGLEMAP_GetDailyMap()
    --获取足迹信息
    ProtocolProcessorFootMark:regAll()
    ProtocolProcessorFootMark:send_FOOTMARK_GetFootmark()
    

    -- 获取商城的信息
    ProtocolProcessorWndShop:send_MALL_GetMallList()

    -- 获取充值列表
    ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList(ProjConfig:getChannelId())

--    ProtocolProcessorRecharge:send_PURCHASE_GetGiftIdList(ProjConfig:getChannelId())

--    ProtocolProcessorWndVip:send_VIP_GetVipRebateInfo( )
    if SceneTabooBattle.m_root then
    	ProtocolProcessorTaboo:send_ZONE_GetZoneInfo(-1)
    end
end

--@brief	返回随机名称(S->C)
function ProtocolProcessorAccount:parse_ACCOUNT_GetRandomNameOk(name)
	-- name : 角色名称
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_GetRandomNameOk")
	SceneCreateActor:setEditInputNameText(name)
end

--@brief	设置token成功(S->C)
function ProtocolProcessorAccount:parse_ACCOUNT_SetTokenOk()
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_SetTokenOk")
end

--@brief	渠道登录结果(S->C)
function ProtocolProcessorAccount:parse_ACCOUNT_ChannelLoginResult(code, message)
	-- code : 渠道登录验证返回编码
	-- message : 渠道登录验证返回信息
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_ChannelLoginResult")
end

--@brief	帐号注册成功(S->C)
function ProtocolProcessorAccount:parse_ACCOUNT_RegisterOk(bSuc)
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_RegisterOk")
	--注册成功，将注册的账号信息保存在本地
	if bSuc then
    	WndBindAccount:registOK()
    else
    	MsgBoxManager:showTipBox(LocalStrings.FB_ACCOUNT_TIP2)
    end
end

--@brief	快速帐号注册成功(S->C)
function ProtocolProcessorAccount:parse_ACCOUNT_QuickRegisterOk()
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_QuickRegisterOk")
end

--@brief	帐号注册失败(S->C)
function ProtocolProcessorAccount:parse_ACCOUNT_RegisterFail(errContent)
	-- errContent : 失败原因
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_RegisterFail")

	--WndRegister:stopLoading()
	MsgBoxManager:showTipBox(errContent, nil, nil, nil, nil)
end

--@brief	修改密码成功(S->C)
function ProtocolProcessorAccount:parse_ACCOUNT_ModifyPasswordOk()
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_ModifyPasswordOk")
	
end

--@brief	修改密码失败(S->C)
function ProtocolProcessorAccount:parse_ACCOUNT_ModifyPasswordFail(errContent)
	-- errContent : 失败原因
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_ModifyPasswordFail")
	
end

--@brief	找回密码成功(S->C)
function ProtocolProcessorAccount:parse_ACCOUNT_FindPasswordOk(retContent)
	-- retContent : 说明
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_FindPasswordOk")
	
	WndFindbackPsw:cbFindbackPswSuccess()
end

--@brief	帐号密码验证结果(S->C)
function ProtocolProcessorAccount:parse_ACCOUNT_VerificationResult(status)
	-- status : 0验证成功，1验证失败
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_VerificationResult")
	
    WndChangeAccount:cbVerificationResult(status)
end

--@brief	用户重复登录账号(S->C)
function ProtocolProcessorAccount:parse_ACCOUNT_RepeatLogin(message)
	-- message : 客户端提示的信息
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_RepeatLogin")
	MsgBoxManager:showConfirmBox(message,SceneLogin,SceneLogin.accountRepeatLoginCallback,MSGBOXLEVEL_HIGH,nil,true,nil,true)

	NetManager.g_bIsRepeatLogin = true
    KLuaMutiRegSocket:getInstance():closeSocket()
end

--@brief	获取小岛节日状态成功（SYSTEM_GetIslandStateOk = 8）
function ProtocolProcessorAccount:parse_SYSTEM_GetIslandStateOk(islandState, openNewTeach, popNotice, openTipLevel, showItemsRemainimgDays, downloadRewardSwitch)
    -- islandState : 0：非节日，1：春节，2：圣诞节
    -- openNewTeach : true:打开新手教学，false：关闭
    -- popNotice : 是否自动弹出信息公告开关
    -- openTipLevel : 显示tip的级别
    -- showItemsRemainimgDays : 物品剩余天数状态显示 0表示关闭，1显示打开
    -- downloadRewardSwitch : 安卓分包下载奖励开关
    --WZLog("ProtocolProcessorAccount:parse_SYSTEM_GetIslandStateOk")
    --苹果渠道的补单支付
    PassportSdkManager:payAppstoreCheck()
    if checkIsOpenIOSAutoRenewalSubscription() == true then
	    --获取是否订阅过苹果自动续订月卡，订阅是否到期
	  	ProtocolProcessorRecharge:send_PURCHASE_IOSSubscrip()
	    --苹果渠道的补单支付-自动续订
	    --PassportSdkManager:payAppstoreCheckForAutoRenewal()
	end
    --谷歌兑换码补单
    if PassportSdkManager.payGooglePromotionCheck then
    	PassportSdkManager:payGooglePromotionCheck()
	end
    --分享功能的补单
    if PassportSdkManager.hasShare then
        PassportSdkManager.hasShare = false
        ProtocolProcessorPrefetchCache:send_TASK_AddFaceBookNum(3,"")
    end
    --渠道的扩展数据推送
    --local curSdkObj = PassportSdkManager:getCurSdkObj()
    if PassportSdkManager.b_createRole then
    	PassportSdkManager:postGameInfo("true","register")
    	if PassportSdkManager.postGameInfoVn then
    		PassportSdkManager:postGameInfoVn("register_vn", "create_role")
    		PassportSdkManager:postGameInfoVn("create_role", "")--角色创建成功
    	end
    	PostPlayerEvent:postEvent(PostPlayerEvent.event_playerregister)
    	PassportSdkManager.b_createRole = false
    end
    --上传玩家信息
    PassportSdkManager:postGameInfo("false","login")
	if PassportSdkManager.postGameInfoVn then
		PassportSdkManager:postGameInfoVn("login_suc", "")--成功登录角色
	end
    PostPlayerEvent:postEvent(PostPlayerEvent.event_deviceactive)
     --英雄官方助手传输数据
    if PassportSdkManager.postHeroData then
    	PassportSdkManager:postHeroData()
    end
    --mtp登入信息
    local adapter = nil
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	if platForm == 2 then --android
		adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("org/cocos2dx/hellolua/DandandaoUtils")
	elseif platForm == 1 then -- ios
		adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("DandandaoUtils")
	end
	if adapter then
		local params = {}
		params.roleId = CacheCenter:getPlayerInfo().id
		params.serverId = IPDhttpServer:getCurServerId()
		local sJson = json.encode(params)
		adapter:callMethodByName("loginMTP",nil,sJson)
		--setDebugState
        WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())
	end
    --mtp登入结束
    GlobalGame.g_tSysConfig.islandState 		= islandState
	GlobalGame.g_tSysConfig.openNewTeach 		= openNewTeach
	GlobalGame.g_tSysConfig.popNotice 			= popNotice
	GlobalGame.g_tSysConfig.openTipLevel 		= openTipLevel
	GlobalGame.g_bShowItemIndefinite = showItemsRemainimgDays
    --GlobalGame.g_tSysConfig.downloadRewardSwitch = downloadRewardSwitch
    GlobalGame:setButtonState()
    WZLog(Serialize(GlobalGame.g_tSysConfig))
    GlobalGame:resetBtnRedPointEvent()

    --初始化动画管理器
    AnimationManager:init()
    --初始语言sdk
    WGCloudVoiceNotify:init(GlobalGame.g_tPlayerInfo.nPlayerId)
    --连接成功，关闭断线重连加载框
    if g_nReconnectLoadingBoxID ~= -1 then
        MsgBoxManager:stopLoadingBoxByMsgId(g_nReconnectLoadingBoxID)
        g_nReconnectLoadingBoxID = -1
    end
    g_nReconnectBeginTime = -1

    if g_nLinkokToLoginokScheduleID ~= nil and g_nLinkokToLoginokScheduleID ~= -1 then
        WZLog("ProtocolProcessorAccount:parse_SYSTEM_GetIslandStateOk zero1",g_nLinkokToLoginokScheduleID)
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_nLinkokToLoginokScheduleID)
        g_nLinkokToLoginokScheduleID = -1
    end

    if -1 ~= g_nLinkokToLoginokTimer then
        g_nLinkokToLoginokTimer = -1
    end

    GlobalGame.g_bIsDisconnectToLoginOk = nil

    SceneBattle.m_bIsLostNet = nil
    if SceneBattle.m_bIsLostNetSingleMap then
        SceneBattle.m_bIsLostNetSingleMap = 0
        BattleMsgGameOver.m_bIsConnect = 0
        WZLog("ProtocolProcessorAccount:parse_SYSTEM_GetIslandStateOk zero2")
    end

    local isTeach = false
    local isEndTeach1, step1 = TeachGroup1:isTeachFinish(7)
    if (TeachGroup1:isTeach() and ( isEndTeach1 == false and CacheCenter:getPlayerInfo().level <= 3)) then
    	isTeach = true
    end
    local teach = false
    CCEGLView:sharedOpenGLView():setDesignResolutionSize(1136,640,0)
    if g_bIsFirstBattleEnd == nil and WBattleGlobal:getCurrent():getBattleMode() == nil then
		if isYLGYLoginChannel() and CacheCenter:getPlayerInfo().level < 7 then
			teach = TeachGroup1:isFirstBattleTeach()
			SceneYangLeGeYang:showInterface()
		else
			teach = TeachGroup1:startFirstBattleTeach()
		end
    elseif g_bIsFirstBattleEnd == true then
    	TeachGroup1:setTeachFinish(25,-1)
    end

    if GlobalGame.g_nCurrentUIChannelId and GlobalGame.g_nCurrentUIChannelId ~= -1 then
        local lastMain = GlobalGame.g_nLastMainChannelId
        local uiChannelId = GlobalGame.g_nCurrentUIChannelId
        ChangeChatChannel(lastMain)
        ChangeChatChannel(uiChannelId)
    end

    --FigureSceneManager:getInstance():deleteOtherFigure()
    GlobalGame.m_bIsUpgrade = nil
    GlobalGame.g_nLoginInCityTime = SystemTime:getServerTime()
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
	--黑龙教学
	WZLog("ProtocolProcessorAccount:parse_SYSTEM_GetIslandStateOk one", tostring(GlobalGame.m_bIsLostNetSettlement), GlobalGame.g_nCurrentUIChannelId, tostring(teach), tostring(isTeach), TeachGroup1.GROUP, TeachGroup1.STEP, tostring(TeachGroup1.LOST_NET), tostring(WBattleGlobal:getCurrent():getBattleMode()))
    if teach then
		
	elseif ((GlobalGame.g_nCurrentUIChannelId == -1 or GlobalGame.g_nCurrentUIChannelId == 1) and SceneCity.m_root and (TeachGroup1.GROUP == -1 and TeachGroup1.STEP == -1) and TeachGroup1.LOST_NET ~= true and isTeach ~= true) and WBattleGlobal:getCurrent():getBattleMode() == nil and (GlobalGame.m_bIsLostNetSettlement == nil) then
    	WZLog("ProtocolProcessorAccount:parse_SYSTEM_GetIslandStateOk two")
    elseif false and CacheCenter:getPlayerInfo().level == 1 and SceneCity:getMovieRecord() == false and (platForm ~= 2 or WZDeviceInfo:getTotalMemory()/(1024*1024) > 1024) then
    	SceneCity:playMovie()
	elseif (GlobalGame.g_nCurrentUIChannelId == -1 or (TeachGroup1.GROUP ~= -1 and TeachGroup1.STEP ~= -1) or TeachGroup1.LOST_NET == true or isTeach) and WBattleGlobal:getCurrent():getBattleMode() == nil and (GlobalGame.m_bIsLostNetSettlement == nil) then
        TeachGroup1.LOST_NET = nil
        GlobalGame.m_bIsLostNetSettlement = nil
		if true then
            Teach.OPEN_MODULE_MARK = true

			--初始化语音聊天
            --VoiceChat:setOpenVoice(soundRoomOpen)
            --VoiceChat:setChatWithAll(soundHostile)
            --VoiceChat:init()W
            WZLog("-------------------init VoiceChat SDK")
            SDK_Talk:initSDK(tostring(GlobalGame.g_tPlayerInfo.nPlayerId),WndChat.recRecordCallback,WndChat)

            --WZLog("ProtocolProcessorAccount:parse_SYSTEM_GetIslandStateOk two",tBtnsInfo,GlobalGame.g_nCurrentUIChannelId)
			--断线重连
		    if NET_FLAG_4 == IPDConnector.g_nNetConnectFlag or NET_FLAG_2 == IPDConnector.g_nNetConnectFlag or NET_FLAG_3 == IPDConnector.g_nNetConnectFlag or NET_FLAG_7 == IPDConnector.g_nNetConnectFlag then
		    	if GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Island then
			    	local bNeedToUpLevel = false
			    	for _,v in pairs(T_G_UI_NEEDTOUPLEVEL) do
			    		if v == GlobalGame.g_nCurrentUIChannelId then
		    				GlobalGame.g_nUIChannelIdBeforeReconnect = GlobalGame.g_nCurrentUIChannelId
		    				bNeedToUpLevel = true
		    				break
			    		end
			    	end
			    	--断线重连后，特定界面跳转到上一级页面
			    	if false and bNeedToUpLevel then
						TurnToUpLevelAfterReconnect()
                    else
                        if SceneCity.m_root == nil then
							WZLog("replaceScene sceneIsland four-1")
			                replaceScene(SceneCity:createElement())
			            else
			                WZLog("replaceScene sceneIsland four-2")
			                SceneCity.m_bIsNoRelease = true
			                replaceScene(SceneCity:createElement(true))
			            end
                        WZLog("replaceScene sceneIsland ")
			    	end

			    	IPDConnector.g_nNetConnectFlag = NET_FLAG_2
			    	return
		    	end
		    end
            WZLog("replaceScene(sceneIsland)1-2")

			if isYLGYLoginChannel() and CacheCenter:getPlayerInfo().level < 7 then
				SceneYangLeGeYang:showInterface()
				return
			end
			if SceneCity.m_root == nil then
				WZLog("replaceScene sceneIsland four-3")
                replaceScene(SceneCity:createElement())
            else
                WZLog("replaceScene sceneIsland four-4")
                SceneCity.m_bIsNoRelease = true
                replaceScene(SceneCity:createElement(true))
            end
		end
	else
		GlobalGame.m_bIsLostNetSettlement = nil
		WZLog("ProtocolProcessorAccount:parse_SYSTEM_GetIslandStateOk three", GlobalGame.g_nUIChannelIdBeforeReconnect, RECONNECT_BATTLE_MODE, GlobalGame.g_nCurrentUIChannelId)
		ProtocolProcessorWndSkillProp:send_PLAYER2_GetPlayerAssist()
		if GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Island then
	    	local bNeedToUpLevel = false
	    	for _,v in pairs(T_G_UI_NEEDTOUPLEVEL) do
	    		if v == GlobalGame.g_nCurrentUIChannelId then
					GlobalGame.g_nUIChannelIdBeforeReconnect = GlobalGame.g_nCurrentUIChannelId
					bNeedToUpLevel = true
					break
	    		end
	    	end
	    	if SceneHall.m_root or (SceneRoom.m_root and SceneRoom.m_tData.roomChannel and (SceneRoom.m_tData.roomChannel == 1)) then 
	    		replaceScene(SceneHall:createElement())
	    		return 
	    	end
	    	if ScenePvpAmuse.m_root or (SceneRoom.m_root and SceneRoom.m_tData.roomChannel and (SceneRoom.m_tData.roomChannel == 26 or SceneRoom.m_tData.roomChannel >= 28 and SceneRoom.m_tData.roomChannel <= 31)) then
	    		ScenePvpAmuse:showScene()
	    		return
	    	end
	    	if ScenePvpRank.m_root or (SceneRoom.m_root and SceneRoom.m_tData.roomChannel and (SceneRoom.m_tData.roomChannel == 27)) then
	    		local scene = ScenePvpRank:createElement()
    			replaceScene(scene)
	    		return
	    	end
	    	if SceneLeagueRoom.m_root then
	    		SceneLeagueMain:showInterface(2)
	    		return
	    	end
	    	if WndLeagueTeamDetail.m_root then
	    		GetElement(WndLeagueTeamDetail.m_root,"conCountDown",WZUIContainer):setVisible(false)
	    		ProtocolProcessorWndLeague:send_HERO_ReadyFight()
	    		return
	    	end
	    	if SceneCommunityWar.m_root or SceneGuildWarRoom.m_root or SceneCommunityKnockout.m_root then
	    		SceneCommunityWar:showInterface()
	    		return 
	    	end
	    	if SceneKidHome.m_root then
	    		SceneKidHome:showInterface()
	    		return 
	    	end
	    	if SceneWorldTeamBossRoom.m_root then
	    		SceneWorldTeamBossRoom:showEnter()
	    		return 
	    	end
	    	if SceneCoupleHegemonyRoom.m_root then
	    		SceneCoupleHegemonyRoom:showEnter()
	    		return 
	    	end
	    	if WndDoubleTowerRoom.m_root then 
	    		SceneCopy:showScene(4, 2)
	    		return 
	    	end
	    	--断线重连后，特定界面跳转到上一级页面
	    	if bNeedToUpLevel then
				TurnToUpLevelAfterReconnect()
			elseif WndSingleCopy.m_root then
				ProtocolProcessorSingleMap:unregAll()
				ProtocolProcessorSingleMap:regAll()
				WndSingleCopy:teachStart()
			end
			if SceneCity and SceneCity.m_root then 
				SceneCity:updateCityTask()
			end
		else
			if SceneCity and SceneCity.m_root then 
				SceneCity:updateCityTask()
			end
		end
	end
end

--@brief	推送玩家的按钮信息
function ProtocolProcessorAccount:parse_PLAYER_PlayerButtonInfo(buttonId, buttonType, buttonSort, IsHighlight)
	-- buttonId : 按钮id
	-- buttonType : 按钮类型 0主界面建筑按钮，1主界面左侧按钮，2主界面中部按钮，3主界面右侧按钮。
	-- buttonSort : 按钮的排序值
	-- IsHighlight : 按钮是否高亮
	WZLog("ProtocolProcessorAccount:parse_PLAYER_PlayerButtonInfo")
    do return end
	if buttonId:size() > 0 then
		GlobalGame.g_tButtonInfo.buttonId 	    = VectorToTable(buttonId)
		GlobalGame.g_tButtonInfo.buttonType     = VectorToTable(buttonType)
		GlobalGame.g_tButtonInfo.buttonSort     = VectorToTable(buttonSort)
		GlobalGame.g_tButtonInfo.IsHighlight    = VectorToTable(IsHighlight)
	end
end

--@brief	设置邮箱（ACCOUNT_SetEMailOk = 8）
function ProtocolProcessorAccount:parse_ACCOUNT_SetEMailOk(result)
    -- result : 0成功，-1密码错误
    WZLog("ProtocolProcessorAccount:parse_ACCOUNT_SetEMailOk")
    WndBindMail:bindCallBack(result)
end

--@bridf  获取下载奖励列表成功
function ProtocolProcessorAccount:parse_ACCOUNT_GetDownloadRewardListOK(ItemsId,ItensNum,status)
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_GetDownloadRewardListOK")
	GlobalGame.g_tDownloadReward.rewardItemsId = VectorToTable(ItemsId)
	GlobalGame.g_tDownloadReward.rewardItemsNum = VectorToTable(ItensNum)
    GlobalGame.g_tDownloadReward.status = status
	for i=1,#GlobalGame.g_tDownloadReward.rewardItemsId do
		local idname = "id_"..GlobalGame.g_tDownloadReward.rewardItemsId[i]
        WZLog("奖励物品Id",idname)
        if ShopItems and ShopItems[idname] ~= nil then
            table.insert(GlobalGame.g_tDownloadReward.rewardItemsIcon,ShopItems[idname].icon)
            table.insert(GlobalGame.g_tDownloadReward.rewardItemsName,ShopItems[idname].name)
        end
	end
    local sJson = json.encode(GlobalGame.g_tDownloadReward)
    WZLog("获取下载奖励列表成功", sJson)
end

--@bridf 同步按钮状态协议
function ProtocolProcessorAccount:parse_SYSTEM_SynButtonInfo(id,showLevel,openLevel,hideLevel)
	WZLog("ProtocolProcessorAccount:parse_SYSTEM_SynButtonInfo")
	for i=0,id:size()-1 do
		local idKey = id:get(i)
		if GDatatab_button_info["id_"..idKey] ~= nil then
			WZLog("ProtocolProcessorAccount:parse_SYSTEM_SynButtonInfo2", idKey, showLevel:get(i), openLevel:get(i), hideLevel:get(i))
			GDatatab_button_info["id_"..idKey].show_level = showLevel:get(i)
			GDatatab_button_info["id_"..idKey].open_level = openLevel:get(i)
			GDatatab_button_info["id_"..idKey].hide_lv = hideLevel:get(i)
		end
	end

	--~~~```

			GDatatab_button_info["id_"..231].show_level = 1
			GDatatab_button_info["id_"..231].open_level = 1
			GDatatab_button_info["id_"..231].hide_lv = 1
end


--@brief	登陆下发服务器及服务器名称（SYSTEM_GetRankMatchOk = 28）
function ProtocolProcessorAccount:parse_SYSTEM_GetServerInfo(serverId, serverName,serverStatus)
	-- serverId : 服务器id
	-- serverName : 服务器名称
	-- serverSatus : 服务器状态（根据状态可以判断玩家是否支持跨服玩法）
	WZLog("ProtocolProcessorAccount:parse_SYSTEM_GetServerInfo")
	CacheCenter:setServerInfo(serverName,serverId,serverStatus)
end

--@brief	同步广告信息协议（SYSTEM_SynAdMessage = 29）
function ProtocolProcessorAccount:parse_SYSTEM_SynAdMessage(imgUrl, params, sort, ad_type)
	-- imgUrl : 广告图地址
	-- params : 广告配置参数
	WZLog("ProtocolProcessorAccount:parse_SYSTEM_SynAdMessage")
	CacheCenter:setAdMessage(VectorToTable(imgUrl), VectorToTable(params), VectorToTable(sort), VectorToTable(ad_type))
end




--@brief	发送角色信息列表（ACCOUNT_GetRoleActorInfoOk = 41）
function ProtocolProcessorAccount:parse_ACCOUNT_GetRoleActorInfoOk(playerId, name, level, title, fighting, weaponInfo, weaponId, headId, faceId, bodyId, wingId, petMessage, sex, colour, bodycolour, vipLevel)
	-- playerId : 玩家id
	-- name : 名称
	-- level : 玩家等级
	-- title : 称号
	-- fighting : 战力
	-- weaponInfo : 武器信息
	-- headId : 头
	-- faceId : 脸
	-- bodyId : 身
	-- wingId : 翅膀
	-- petMessage : 宠物信息json
	-- sex : 性别0男，1女
	-- colour : 头部颜色
	-- bodycolour : 身颜色
	-- vipLevel : VIP等级
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_GetRoleActorInfoOk")
	if SceneSelectActor.m_root == nil then
		SceneSelectActor:showSceneUI()
	end
	SceneSelectActor:setActorList(VectorToTable(playerId), VectorToTable(name), VectorToTable(level), VectorToTable(title),
		VectorToTable(fighting), VectorToTable(weaponInfo),VectorToTable(weaponId), VectorToTable(headId), VectorToTable(faceId),
		VectorToTable(bodyId), VectorToTable(wingId), VectorToTable(petMessage), VectorToTable(sex), VectorToTable(colour),
		VectorToTable(bodycolour), VectorToTable(vipLevel))
end


--@brief	查看玩家是否在线（PLAYER_CheckOnlineOk = 91）
function ProtocolProcessorAccount:parse_PLAYER_CheckOnlineOk(pid, online)
	-- pid : 玩家Id
	-- online : 是否在线（1代表在线）
	WZLog("ProtocolProcessorAccount:parse_PLAYER_CheckOnlineOk")
	local playerIds = VectorToTable(pid)
	local playerOnlineStats = VectorToTable(online)
	local temp = {}
	for i,v in ipairs(playerIds) do
		local t = {}
		t.playerId = v
		t.isOnLine = playerOnlineStats[i]
		table.insert(temp,t)
	end
	WndChat:_updateLatelyPriChatPlayerList(temp)
end

--@brief	查看玩家是否在线（PLAYER_CheckFirstWeChat = 92）
function ProtocolProcessorAccount:parse_PLAYER_CheckFirstWeChat(sReward)
	WZLog("ProtocolProcessorAccount:parse_PLAYER_CheckFirstWeChat:",sReward)
	gWeChatShareReward = sReward
end

--@brief	用户注销（ACCOUNT_UnregisterOk = 66）
function ProtocolProcessorAccount:parse_ACCOUNT_UnregisterOk(success, cancelTime)
	-- success : 0注销成功,1取消注销成功，2失败,3超过7天不能取消注销
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_UnregisterOk", success, cancelTime)
	--改变界面ui
	if success == 0 then
		GlobalGame.g_tPlayerInfo.nPlayerStatus = 2
	elseif success == 1 then
		GlobalGame.g_tPlayerInfo.nPlayerStatus = 1
	end
	if success == 0 or success == 1 then
		GlobalGame.g_tPlayerInfo.nUnregisterTime = cancelTime
		if SceneCity and SceneCity.m_tWndBottomBarObj then
			SceneCity.m_tWndBottomBarObj:showBtnDelRole()
		end
	end
end

-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------

--@brief	设置邮箱（ACCOUNT_SetEMail = 7）
function ProtocolProcessorAccount:send_ACCOUNT_SetEMail(password, email )
    WZLog("send_ACCOUNT_SetEMail")
    local sender = Protocol:getSender( Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SetEMail )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeString( password )	-- 密码
    sender:writeString( email )	-- email
    SendProtocol(sender,false) --true:showLoading
end


--@brief	帐号登录错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note		在此对协议错误进行相应处理
function ProtocolProcessorAccount:send_ACCOUNT_Login_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_Login_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_Login, nflag)

	--sMessage = "3"
	if sMessage == "1" then
    	MsgBoxManager:showConfirmBox(LocalStrings.SERVER_PLAYER_FULL or "", self, self.reconectipd, MSGBOXLEVEL_HIGH, nil,true)
	elseif sMessage == "2" then
    	MsgBoxManager:showConfirmBox(LocalStrings.SERVER_MAINTAINING or "", self, self.reconectipd, MSGBOXLEVEL_HIGH, nil,true)
	elseif sMessage == "3" then
    	MsgBoxManager:showConfirmBox(LocalStrings.VERSION_LOW or "", self, self.reconectipd, MSGBOXLEVEL_HIGH, nil,true)
	else
    	MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_CONNECTION_FAILURE, self, self.reconectipd, MSGBOXLEVEL_HIGH, nil,true)
	end

end

function ProtocolProcessorAccount:reconectipd()
	GlobalGame:reset()
    CacheCenter:reset()
    PrefetchCache:reset()

    MsgBoxManager:clear()
    local frame = WZUISystem:getInstance():createElement("splash")
    replaceScene(frame)

    --[[    
    local data = WZDataFile:getInstance():getUserData()
    if nil == data then
        return
    end
    local accountName = data:getStringValue("AccountData", "account")
    local passWord = data:getStringValue("AccountData", "password")

    if accountName == "" or passWord == "" then
    	accountName = WGameCmUtil:GetUDID()
    	passWord = WGameCmUtil:GetUDID()
    end
    WZLog("fdasf41234124123",accountName,accountName)
    IPDConnector:connectIPDServer(accountName,accountName,true)
    --]]
end

--@brief	创建角色协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_CreateRoleActor_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_CreateRoleActor_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_CreateRoleActor, nFlag, sMessage)
	
	--MsgBoxManager:showTipBox(sMessage, nil, nil, nil, nil, nil)
	--关闭创建角色界面加载框
	--SceneCreateActor:finishedLoading()
    SceneCreateActor:enterGameFail()
end

--@brief	获取角色列表协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_GetRoleActorList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_GetRoleActorList_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetRoleActorList, nflag, sMessage)
end

--@brief	角色登录协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_RoleActorLogin_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_RoleActorLogin_ErrorProcess")
	PostPlayerEvent:postEvent(PostPlayerEvent.event_roleActorLoginFail)
	local function enterSplash()
		local sceneSplashElement = WZUISystem:getInstance():createElement("splash")
		if sceneSplashElement then
			replaceScene(sceneSplashElement)
		end
	end
	MsgBoxManager:showConfirmBox(sMessage, nil, function() enterSplash() end, MSGBOXLEVEL_HIGH, nil,true)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_RoleActorLogin, nFlag)
end

--@brief	帐号重新登录协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_LoginAgain_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_LoginAgain_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_LoginAgain, nflag, sMessage)
end

--@brief	获取随机名称协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_GetRandomName_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_GetRandomName_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetRandomName, nflag, sMessage)
end

--@brief	设置帐号关联的token协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_SetToken_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_SetToken_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SetToken, nflag, sMessage)
end

--@brief	渠道登录验证协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_ChannelLogin_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_ChannelLogin_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_ChannelLogin, nflag, sMessage)
end

--@brief	客户端退到后台协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_ToBackGround_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_ToBackGround_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_ToBackGround, nflag, sMessage)
end

--@brief	客户端回到前台协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_FromBackGround_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_FromBackGround_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_FromBackGround, nflag, sMessage)
end

--@brief	帐号注册协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_Register_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_Register_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_Register, nflag, sMessage)
end

--@brief	修改密码协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_ModifyPassword_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_ModifyPassword_ErrorProcess")
	
	--ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_ModifyPassword, nflag, sMessage)
end

--@brief	找回密码协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_FindPassword_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_FindPassword_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_FindPassword, nflag, sMessage)
end

--@brief	帐号密码验证协议错误处理(S->C)
function ProtocolProcessorAccount:send_ACCOUNT_Verification_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_Verification_ErrorProcess")
	
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_Verification, nflag, sMessage)
end

--@brief	获取小岛节日状态错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note		在此对协议错误进行相应处理
function ProtocolProcessorAccount:send_SYSTEM_GetIslandState_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_SYSTEM_GetIslandState_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SYSTEM, Protocol.SYSTEM_GetIslandState, nflag, sMessage)
end

--@brief	发送玩家微博ID（PLAYER_SetPlayerWeiboId = 45）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorAccount:send_PLAYER_SetPlayerWeiboId_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_PLAYER_SetPlayerWeiboId_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_SetPlayerWeiboId, nflag, sMessage)
end

--@brief	获取下载奖励列表错误处理(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorAccount:parse_ACCOUNT_GetDownloadRewardList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_GetDownloadRewardList_ErrorProcess")
	MsgBoxManager:showTipBox(sMessage)
	--ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetDownloadRewardList, nflag, sMessage)
end

--弃用
--@brief	同步玩家帐号绑定状态（ACCOUNT_SynAccountState = 65）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
-- function ProtocolProcessorAccount:send_ACCOUNT_SynAccountState_ErrorProcess(nFlag, sMessage)
-- 	WZLog("ProtocolProcessorAccount:send_ACCOUNT_SynAccountState_ErrorProcess")
-- 	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SynAccountState, nflag, sMessage)
-- end

--@brief	设置邮箱（ACCOUNT_SetEMail = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorAccount:send_ACCOUNT_SetEMail_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorAccount:send_ACCOUNT_SetEMail_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_SetEMail, nflag, sMessage)
end

--@brief	获取角色信息列表（ACCOUNT_GetRoleActorInfo = 40）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorAccount:send_ACCOUNT_GetRoleActorInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_ACCOUNT_GetRoleActorInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_GetRoleActorInfo, nflag, sMessage)
end

--@brief	查看玩家是否在线（PLAYER_CheckOnline = 90）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorAccount:send_PLAYER_CheckOnline_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:send_PLAYER_CheckOnline_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_CheckOnline, nflag, sMessage)
end

--@brief	用户注销（ACCOUNT_Unregister = 65）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorAccount:send_ACCOUNT_Unregister_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorAccount:parse_ACCOUNT_Unregister_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACCOUNT, Protocol.ACCOUNT_Unregister, nflag, sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------




