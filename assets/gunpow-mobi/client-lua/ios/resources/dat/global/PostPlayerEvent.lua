--PostPlayerEvent.lua
--@brief 从打开游戏到完成新手的过程中，在每个关键节点向服务器发送事件信息
--@date  2014/12/22
--@author linshubin
local RECORDFILENAME = "ddd2_event52352351.db"

PostPlayerEvent=
{
	--事件列表
	event_startgame 	     = 10001, --开始游戏，启动闪屏
	event_playCG             = 10002, --播放视频
	event_playCGEnd          = 10003, --播放CG结束
	event_playCGStop         = 10101, --手动停止CG

	event_enterDownUI        = 10004, --进入下载更新界面
	event_checkUpdateFail    = 10102, --检查更新失败
	event_showUpdateTips     = 10005, --提示下载框
	event_clickStartUpdate   = 10006, --点击下载
	event_clickCancelUpdate  = 10007, --点击取消下载
	event_updateSuccess      = 10008, --更新成功
	event_updateFail         = 10009, --更新失败

	event_enterLoginUI       = 10010, --进入登入界面
	event_clickStartLogin    = 10011, --点击开始游戏
	event_startSDKLogin      = 10012, --开始sdk登入
	event_loginSuccess       = 10013, --登入成功
	event_loginFail          = 10014, --登入失败

	event_requestServerList  = 10015, --请求服务器列表
	event_requestServerListSuccess       = 10016, --请求列表成功
	event_requestServerListFail          = 10017, --请求列表失败
	event_enterServerUI      = 10018, --进入服务器界面
	event_openServerList     = 10019, --打开服务器列表
	event_chooiceServer      = 10020, --点击选服

	event_clickEnterGame     = 10021, --点击进入游戏
	event_checkNeedQueue     = 10022, --检查是否需要排队
	event_openQueueUI        = 10023, --打开排队信息界面
	event_finshQueue         = 10024, --完成排队
	event_cancelQueue        = 10025, --取消排队
	event_starLoadRes        = 10026, --加载资源
	event_loadResSuccess     = 10027, --加载资源成功
	event_connectIPD         = 10028, --链接Ipd
	event_connectIPDSuccess  = 10029, --链接Ipd成功
	event_connectIPDFail     = 10030, --链接Ipd失败

	event_enterCreateActorUI = 10031, --打开创建角色界面
	event_clickCreateActor   = 10032, --点击创建角色
	event_createActorSuccess = 10033, --创建角色成功
	event_createActorFail    = 10034, --创建角色失败
	event_roleActorLogin     = 10035, --角色登陆
	event_roleActorLoginSuccess          = 10036, --角色登陆成功
	event_roleActorLoginFail             = 10037, --角色登陆失败

	--越南的特殊埋点
	event_payVnWeb           = 11000, --越南网页支付埋点

	--充值模块(会重复发送)
	event_payStep1           = 80001, --弹出充值提示所在界面
	event_payStep2           = 80002, --打开充值界面(主城和上拉栏)
	event_payStep3           = 80003, --跳转到充值界面
	event_payStep4           = 80004, --选择档次
	event_payStep5           = 80005, --获得订单
	event_payStep6           = 80006, --拉起sdk
	event_payStep7           = 80007, --sdk支付失败
	event_payStep8           = 80008, --充值成功


	--英雄相关埋点
	event_playerregister     = 90001, 
	event_sdkLoginSuccess    = 90002, 
	event_deviceactive       = 90003,
	event_task    			 = 90003,
	event_playerorder    	 = 90003,
	event_playerstage    	 = 90003,
	event_playerfight    	 = 90003,

    
    event_luaErrorLog      = 9999, --lua错误日志
    --服务器名称
    m_sServiceName = nil,
    
    --错误log发送限制，最多20条
    m_nTotalErrorLogNum = 0,
    m_nErrorLogMax = 20,

    --不限制发送次数
    m_bPostNoLimit = false,

    --发送记录
    m_tPostRecord = nil,
    
    m_nTaskIndex = 10000
}


--@brief    初始化
function PostPlayerEvent:init()
	self.m_tBasisData = {}
	--游戏包名
	self.m_tBasisData.packageName = WGameCmUtil:GetBundleIdentifier()
	--游戏平台
	local platformId = WZUISystem:getInstance():getPlatformInfo()
	if platformId == 2 then
		self.m_tBasisData.platformInfo = "android"
	elseif platformId == 1 then
		self.m_tBasisData.platformInfo = "ios"
	else
		self.m_tBasisData.platformInfo = tostring(platformId)
	end
	--设备名称
	self.m_tBasisData.deviceName = WZDeviceInfo:systemName()
	--设备版本
	self.m_tBasisData.deviceVersion = WZDeviceInfo:systemVersion()
	--网络类型
	self.m_tBasisData.networkType ="unknown"
	--idfa
	self.m_tBasisData.idfa = WGameCmUtil:GetUDID()
	--当前时间
	self.m_nCurTime = os.time() 
	--WZLog("PostPlayerEvent:init m_tBasisData", Serialize(self.m_tBasisData))
	--埋点地址
	self.m_sAddress = ProjConfig.POST_EVENT_URL
	--版本号
	self.m_tBasisData.gameVersion = ProjConfig.INSTALLVERSION
	self.m_tPostRecord = ReadFileToTable(RECORDFILENAME, "ddd2", false)
   -- WZLog("PostPlayerEvent:init", Serialize(self.m_tPostRecord))
	if self.m_tPostRecord == nil or type(self.m_tPostRecord) ~= "table" then
		self.m_tPostRecord = {}
	end
	self.gameId,self.gameKey = self:getHeroIdAndKey()
end

--@brief    设置服务器名称
function PostPlayerEvent:setServiceName(sName)
	if sName~= nil then
		self.m_sServiceName="service"..sName
	end
end

function PostPlayerEvent:getHeroIdAndKey()
	local packName = WGameCmUtil:GetBundleIdentifier()
	if packName == "com.herogame.bombleadsa" or packName == "com.herogame.gplay.dddsea" or packName == "com.herogame.gplay.dddglo" then
		--东南亚
		return 10010,"0abfa2f17cbb4f7d"
	elseif packName == "com.herogame.bombleadtw" or packName == "com.herogame.gplay.bombleadtw" then
		--ios海外
		return 10011,"8383e27f8c374e09"
	end
	if ProjConfig.LANGUAGE == "cn" then
		return 109,"9d409206ecee428a"
	end
	return 0,""
end

function PostPlayerEvent:dealHeroData(eventId,_tData)
	--英雄的埋点 
	if not eventId then
		return
	end
	WZLog("PostPlayerEvent:dealHeroData:", eventId,self.gameId) 
	local nEventId = eventId
	if self.gameId ~= 0 then
		WZLog("PostPlayerEvent:dealHeroData2222")
		if nEventId == self.event_playerregister then
			--注册成功
			local tData = {}
			tData.gameUserId = CacheCenter:getPlayerInfo().id
			tData.roleName = CacheCenter:getPlayerInfo().name
			self:postHeroData(nEventId,"playerregister",tData)
		elseif nEventId == self.event_sdkLoginSuccess then
			--新增设备
			WZLog("PostPlayerEvent:dealHeroData333")
			local data = WZDataFile:getInstance():getUserData()
  			if data then
  				local isNew = data:getStringValue("postData", "isNew")
  				WZLog("PostPlayerEvent:dealHeroData444:",isNew)
        		if isNew == nil or isNew == "" then
        			WZLog("PostPlayerEvent:dealHeroData555")
					local tData = {}
					tData.phoneMode = WZDeviceInfo:systemName()
					tData.os = WZDeviceInfo:systemVersion()
					tData.netMode = 1
					self:postHeroData(nEventId,"deviceregister",tData)
					data:setStringValue("postData", "isNew", "false")
        			data:flush()
				end
			end
		elseif nEventId == self.event_deviceactive then
			--设备激活
			local data = WZDataFile:getInstance():getUserData()
  			if data then
  				local isNew = data:getStringValue("postData", "isFirstLogin")
        		if isNew == nil or isNew == "" then
					local tData = {}
					tData.phoneMode = WZDeviceInfo:systemName()
					tData.os = WZDeviceInfo:systemVersion()
					tData.netMode = 1
					self:postHeroData(nEventId,"deviceactive",tData)
					data:setStringValue("postData", "isFirstLogin", "false")
        			data:flush()
				end
			end
			--玩家登陆
			WZLog("PostPlayerEvent:dealHeroData1043")
			local loginData = {}
			local playInfo = CacheCenter:getPlayerInfo()
			loginData.gameUserId = playInfo.id
			loginData.roleName = playInfo.name
			loginData.level = playInfo.level
			loginData.vipLevel = playInfo.vipLevel
			loginData.netMode = 1
			self:postHeroData(nEventId,"playerlogin",loginData)
		elseif nEventId == self.event_task then
			--任务追踪
			self:postHeroData(nEventId,"playertask",_tData)
		elseif nEventId == self.event_playerorder then
			--任务追踪
			self:postHeroData(nEventId,"playerorder",_tData)
		elseif nEventId == self.event_playerstage then
			--任务追踪
			self:postHeroData(nEventId,"playerstage",_tData)
		elseif nEventId == self.event_playerfight then
			--任务追踪
			self:postHeroData(nEventId,"playerfight",_tData)
		end
	end

end

function PostPlayerEvent:postHeroData(eventId,eventName,tData)
	WZLog("PostPlayerEvent:postHeroData:",eventId, eventName)
	tData.roleId = eventName
	if eventId ~=  self.event_sdkLoginSuccess then
		tData.gameServerId = IPDhttpServer:getCurServerId() 
		tData.roleId = CacheCenter:getPlayerInfo().id
		if eventId == self.event_playerorder then
			if self.gameId == 10010 then
				--东南亚
			    tData.currency = "USD"
			elseif self.gameId == 10011 then
				--繁体
				tData.currency = "NTD"
			else
				tData.currency = "CNY"
			end
		end
	end
  local sign = WZDeviceInfo:md5Generate("HDC"..self.gameId..self.gameKey)
  tData.sign = sign
  tData.eventId = eventId..os.time()
  tData.channelId = ProjConfig:getChannelId()
  tData.platformId = WZUISystem:getInstance():getPlatformInfo()-1
  tData.vCode = WZDeviceInfo:appVersion()
  tData.actionId = tData.roleId..os.time()
  tData.opTime = os.date("%Y")..os.date("%m")..os.date("%d")..os.date("%H")..os.date("%M")..os.date("%S")
  tData.deviceId = WGameCmUtil:GetUDID()
  tData.eventName  = eventName
  tData.gameId = self.gameId
  --tData.appkey = self.gameKey
  local sPostData = json.encode(tData)
  local sPostData = "["..sPostData.."]"
  local sign = WZDeviceInfo:md5Generate("HDC"..sPostData..self.gameKey)
  print("hhh:"..sPostData.."---"..sign)
  local url = ""
  if ProjConfig.DEBUG == 1 then
  	url = "https://sandbox-data.yingxiong.com/server/data/"..self.gameId
  else
  	url = "https://data.0sdk.com/server/data/"..self.gameId
  	if self.gameId == 109 then
  		url = "https://data.yingxiong.com/server/data/"..self.gameId
  	end
  end
  local fullUrl = url .. "?data=" ..sPostData
  print("HHHHHHHHHHH:"..fullUrl)
  local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
  local downLoadInfoTask = nil
  downLoadInfoTask = WZHTTPPostDataLuaTask:create(1, url,sPostData,PostPlayerEvent.postCallback, PostPlayerEvent)
  if downLoadInfoTask.setHeader then
	  downLoadInfoTask:setHeader("token","wyd5")
	  downLoadInfoTask:setHeader("gameid",""..self.gameId)
	  downLoadInfoTask:setHeader("sign",string.lower(sign))
	  mulThreadSystem:addDownloadTask(downLoadInfoTask)
  else
  	WZLog("NNNNNNNNNNNNNN")
  end 

end

--@brief 向服务器post信息
--@param nEventId 事件id
--@param tExInf 额外信息
function PostPlayerEvent:postEvent(nEventId,tExInf)
    WZLog("PostPlayerEvent:postEvent")
	if not nEventId then
		return
	end
	if nEventId >= 90000 then
		self:dealHeroData(nEventId,tExInf)
		return
	end
	if not self:_check(nEventId)  then 
		return
	end
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if nEventId ~= event_openPay and nEventId ~= event_clickPay and nEventId ~= event_starPaySDK and nEventId ~= event_finshPaySDK then 
        if platForm == 2 then  -- android 不处理埋点
            --return 
        end
    end 
    
	--下载时post有时会导致线程问题，闪退，现在屏蔽
	--[[if nEventId==PostPlayerEvent.event_downloadFail or
		nEventId==PostPlayerEvent.event_downloadTipOpen	or
		nEventId==PostPlayerEvent.event_downloadClickConfirm  then
		return
	end]]
    if self.m_sAddress == nil or self.m_sAddress == "" then
        WZLog("PostPlayerEvent:postEvent m_sAddress invalid")
        return
    end
	local tPostData = self:_stuffPostData(nEventId,tExInf)
	WZLog("PostPlayerEvent:postEvent:", Serialize(tPostData))
    local sPostData = json.encode(tPostData)
    local vBytes = WGameCmUtil:EnCrypt(sPostData, "d8w3jfd2s2")
    local sData = WGameCmUtil:transformBytesToString(vBytes)
	local request = WZHTTPPostDataLuaTask:createWithTimeout(1, self.m_sAddress, "data="..sData, 3, 5)
	WZUISystem:getInstance():getMultiThreadSystem():addDownloadTask(request)
    
    self.m_nTaskIndex = self.m_nTaskIndex + 1
    self:_record(nEventId)
end

function PostPlayerEvent:postCallback(nTaskId, sResponse, nTotalSize, nNowSize, bFinished, bFailed)
    if nTaskId > self.m_nTaskIndex or nTaskId < 10000 then
        return
    end
    if bFinished then --成功
		WZLog("PostPlayerEvent:postCallback success", sResponse)
    elseif bFailed then --失败
        WZLog("PostPlayerEvent:postCallback failed")
    end
end

--@breif 获取发送的参数
function PostPlayerEvent:_stuffPostData(nEventId, tExInf)
	local tData = self.m_tBasisData or {}
	--耗时
	local time = os.time()
	tData.useTime = time - self.m_nCurTime
	self.m_nCurTime = time
	--事件点
	tData.eventid = tostring(nEventId)
	--渠道号，qucik子包会改变所以要在这里设置
	tData.channelId = tostring(ProjConfig.CHANNEL_ID)
	--角色id 
	tData.playerId = self:_getPlayerId()
	--服务器ID
	tData.gameServerId = self:_getServerId()
	--网络状态
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	if platForm == 2 then
		--美洲android需要上传google advertising id
  		WZLog("PostPlayerEvent:_stuffPostData:googleadid:", PassportSdkManager.s_googleAdvertiseId)
  		tData.googleAdId = PassportSdkManager.s_googleAdvertiseId	
    end

	if WZDeviceInfo.networkType then
		--self.m_tBasisData.networkType = WZDeviceInfo:networkType()
	end

	if tExInf then
		tData.dict = tExInf
	end 
	--tData.dict = self:_getExtraData(nEventId, tExInf)
	
	return tData
end

--服务器名称
function PostPlayerEvent:_getServerId()
	if IPDhttpServer.IpdCurServer and IPDhttpServer.getCurServerId then
		return IPDhttpServer:getCurServerId() 
	else
		return "-1"
	end
end

function PostPlayerEvent:_getChannelId()
	return tostring(ProjConfig.CHANNEL_ID) 
end

function PostPlayerEvent:_getPlayerId()
	local tPlayerInfo = CacheCenter:getPlayerInfo()
    if tPlayerInfo then
        return tostring(tPlayerInfo.id)
    else
        return "-1"
    end
end

--@brief 检测是否需要post
function PostPlayerEvent:_check(nEventId)
	if self.m_tPostRecord == nil or type(self.m_tPostRecord) ~= "table" then 
		self.m_tPostRecord = {}
		return true
	end
	if nEventId == self.event_errorlog then
		if self.m_nTotalErrorLogNum >= self.m_nErrorLogMax then
			print("##### error log out of range")
			return false
		end
		self.m_nTotalErrorLogNum = self.m_nTotalErrorLogNum + 1
		return true
	end
	if nEventId > 80000 and nEventId < 90000 then
		return true
	end
	return self.m_tPostRecord[tostring(nEventId)] == nil
end

--@brief 记录发送的次数
function PostPlayerEvent:_record(nEventId)
    WZLog("PostPlayerEvent:_record", nEventId)
	--if self:_isEveryEvent(nEventId) then return end

	if nEventId then
		self.m_tPostRecord[tostring(nEventId)] = 1
        WriteTableToFile(self.m_tPostRecord, RECORDFILENAME, "ddd2", false)
        WZLog("PostPlayerEvent:_record finished", Serialize(self.m_tPostRecord))
	end
end

--@brief新手教程埋点
--@param tag步骤标识 比如“25-1”
function PostPlayerEvent:postTeach(teachTag)
	local tagTab =SplitStringWithSeparator(teachTag,"-") or {}
	local teachEventId = 20000
	if tagTab[1] then
		teachEventId = teachEventId + tonumber(tagTab[1]) * 100
	end
	if tagTab[2] then
		teachEventId = teachEventId + tonumber(tagTab[2])
	end
    WZLog("HHHHHH:",teachEventId)
    self:postEvent(teachEventId)
    WZLog("PostPlayerEvent:postTeach", tag)
end

function PostPlayerEvent:_getClockTime()
	local nTime, nClockTime = WZUISystem:getTimeOfDay()
	return tostring(nTime)
end

