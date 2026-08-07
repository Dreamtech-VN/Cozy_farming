--IPDhttpServer.lua
--@brief	IPDhttpServer的模块
--@date		2015-6-23
--@modify   binshao
--@note		服务器列表模块

IPDhttpServer = 
{
	IpdServerList = nil ,        -- 通过IPD获取的服务器列表
    IpdCurServer = nil,          -- 保存当前的服务器信息，方便修改和查询
    IpdToken = nil,              -- token
    updateUrl = nil,
    appraisalUrl = nil,
    version = nil,
    logined = nil,              -- 是否登录过
    IpdServerInfo = nil,        -- 当前的服务器信息
    IpdAccountCreateDays = nil, --账号创建的时间（秒）
    IpdCurTime = nil, --当前时间（秒）
}

-------------------------------------公有方法模块Begin--------------------------------------

-- 获取默认服务器和公告
function IPDhttpServer:getHttpServerData( url )
    WZLog("-----------------getHttpServerData--------------",url)
    if url then
		local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
		local downLoadInfoTask = WZHTTPInfoLuaTask:createWithTimeout( 1 , url,10,30, self.ipdCallback, self)
		downLoadInfoTask:setLevel(15)
		mulThreadSystem:addDownloadTask(downLoadInfoTask)
	end
end

-- 获取注册地址
function IPDhttpServer:getRegistData(url)
    WZLog("-----------------getRegistData--------------",url)
    if url then
        local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
        local downLoadInfoTask = WZHTTPInfoLuaTask:createWithTimeout( 1 , url,10,30, self.registCallBack, self)
        downLoadInfoTask:setLevel(15)
        mulThreadSystem:addDownloadTask(downLoadInfoTask)
    end
end

--@brief    换区获取服务器列表
function IPDhttpServer:getHttpServerList(url)
    -- body
    WZLog("-----------------getHttpServerList--------------",url)
    if url then
        local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
        local downLoadInfoTask = WZHTTPInfoLuaTask:createWithTimeout( 1 , url,10,30, self.serverListCallback, self)
        downLoadInfoTask:setLevel(15)
        mulThreadSystem:addDownloadTask(downLoadInfoTask)
    end
end


-- 判断账号是否可以用
function IPDhttpServer:getAccountNameIsUsed(url)
    if url then
        local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
        local downLoadInfoTask = WZHTTPInfoLuaTask:createWithTimeout( 1 , url,10,30, self.NameUsedCallBack, self)
        downLoadInfoTask:setLevel(15)
        mulThreadSystem:addDownloadTask(downLoadInfoTask)
    end
end


-- 判断是否需要排队
function IPDhttpServer:getNeedQueue(url)
    if url then
        local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
        local downLoadInfoTask = WZHTTPInfoLuaTask:createWithTimeout( 1 , url,10,30, self.needQueueCallBack, self)
        downLoadInfoTask:setLevel(15)
        mulThreadSystem:addDownloadTask(downLoadInfoTask)
    end
end

-- 取消排队
function IPDhttpServer:cancelQueue(url)
    if url then
        local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
        local downLoadInfoTask = WZHTTPInfoLuaTask:createWithTimeout( 1 , url,10,30, self.cancelQueueCallBack, self)
        downLoadInfoTask:setLevel(15)
        mulThreadSystem:addDownloadTask(downLoadInfoTask)
    end
end


--@brief	IPD链接回调函数
--@param	nTaskID:任务ID，为固定值：IPDConnector.IPD_TASK
--@param	sData:IPD服务器返回的数据
--@param	bFinish:数据获取是否完成，true：IPD服务器访问完成
--@param	bFailed:数据获取是否失败，false：获取IPD数据成功
--@note		在这里判断IPD链接结果并做相应的操作
--sData = {
-- "serverInfo":[
-- {"name":"祥超服","serverId":1,"tips":0,"status":1}],
-- "token":"25cd57e3-e356-466b-8248-e503d4a641f5",
-- "updateurl":"itms-apps://itunes.apple.com/hk/app/id525216500",
-- "appraisal":"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=525216500",
-- "version":"200"
-- isNew 1表示第一次连接}
function IPDhttpServer:ipdCallback(nTaskID, sData, bFinish, bFailed)
    WZLog("-------------ipdCallback-------------nTaskID",nTaskID)
    WZLog("-------------ipdCallback-------------bFailed",bFailed)
    WndServersSel:closeLoadingBox()
    WndLoginSelect:_closeLoadingBox()
    -- 网络不可用
    if bFailed then
        WZLog("IpdHttpCallBackFail")
        PostPlayerEvent:postEvent(PostPlayerEvent.event_requestServerListFail)
        WndLoginSelect:getServerListSuccess(false)
        return
    end

	local tData = json.decode(sData)
    WZLog("IPDhttpServer:ipdCallback", Serialize(tData))
    -- 获取服务器列表OK
    self.IpdToken = tData.token
    self.updateUrl = tData.updateurl
    self.appraisalUrl = tData.appraisal
    self.version = tData.version
    
    
    -- 需要更新整个包
    if tData.version == "999.999.999" then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_requestServerListFail)
        MsgBoxManager:showConfirmBox(LocalStrings.NEED_UPDATE_VERSION, self, self.updateMainVersionCallback, MSGBOXLEVEL_HIGH, nil,true)
        return
    end

    -- 状态1 正常， -1 没有服务可用 400 账号不存在， 500 密码错误, 600设备封禁
    if tData.state ~= 1 then
        if tData.state == 400 or tData.state == 500 then
            WndLoginSelect:accountOrPasswordError(tData.state)
        elseif tData.state == 403 then
            WndLoginSelect:channelNotOpen()
        elseif tData.state == -1 then
            WndLoginSelect:serverMaintain()
        elseif tData.state == 600 then 
            MsgBoxManager:showConfirmBox(LocalStrings.LIMIT_EQUIP_ATT, nil, nil, nil, nil, true)
        end
        PostPlayerEvent:postEvent(PostPlayerEvent.event_requestServerListFail)
        return
    end
    self:initGameNotice(tData.bullitenList)

    -- 设置服务器列表，按登陆时间排序，最近登陆的时间大
    if tData.serverList then
    	self.IpdServerList = CopyTable(tData.serverList)

        -- 服务器列表为空
        if #self.IpdServerList == 0 then
            WndLoginSelect:serverMaintain()
            return
        end

        local function sort(s1,s2)
            return s1.loginTime > s2.loginTime
        end
        table.sort(self.IpdServerList,sort)
        self:initLogined()

        local localId = self:getCurServerId()
        local localName = self:getLocalServerName()
        self.IpdCurServer = CopyTable(self:_findServerByServerId(localId, localName))
        self:_saveServerId(self.IpdCurServer.serverId)
        self:_saveServerName(self.IpdCurServer.name)
    elseif tData.serverInfo then
        -- 设置当前的服务器信息
        self.IpdServerInfo = CopyTable(tData.serverInfo) 
        self.IpdCurServer = CopyTable(tData.serverInfo) 
    end

    --第三方SDK注册成功
    if tData.isNew == 1 then
        local tData = {}
        tData.funType = "finshRegister"
        PassportSdkManager:Others(tData)
    end

    -- 进入选服
    PostPlayerEvent:postEvent(PostPlayerEvent.event_requestServerListSuccess)
    WndLoginSelect:getServerListSuccess(true)
    if WndServersSel.m_root then
        WZLog("---------------WndServersSel-------------------")
        if tData.serverList then
            WndServersSel:initServersInfo()
            WndServersSel:_update()
        end
    end

    GlobalGame:getGameEventDispathcer():Dispatch("Get_Server_List")
end

-- 注册回到 200 表示成功注册 400 表示账户名重复，其他的表示注册失败
function IPDhttpServer:registCallBack(nTaskID, sData, bFinish, bFailed)
    WZLog("----------------------registCallBack---------------------")
    if bFailed then
        WndLoginSelect:_closeLoadingBox()
        MsgBoxManager:showConfirmBox(LocalStrings.DOWNLOAD_RES_FAIL_TIPS, nil, nil, MSGBOXLEVEL_NORMAL, nil,true)
        return
    end
    local tData = json.decode(sData)
    WndLoginSelect:registCallBack(tData)
end


-- 注册回到 200 账号未注册 400表示账户名重复
function IPDhttpServer:NameUsedCallBack(nTaskID, sData, bFinish, bFailed)
    WZLog("----------------------NameUsedCallBack---------------------")
    if bFailed then
        WndBindAccount:_closeLoadingBox()
        MsgBoxManager:showConfirmBox(LocalStrings.DOWNLOAD_RES_FAIL_TIPS, nil, nil, MSGBOXLEVEL_NORMAL, nil,true)
        return
    end
    local tData = json.decode(sData)
    WndBindAccount:nameJudgeCallBack(tData)
end

--@brief    获取服务器列表回调
function IPDhttpServer:serverListCallback(nTaskID, sData, bFinish, bFailed)
    -- body
    WndServersSel:closeLoadingBox()
    if bFailed then
        WZLog("serverListCallback Fail")
        WndLoginSelect:getServerListSuccess(false)
        return
    end

    local tData = json.decode(sData)
    WZLog("IPDhttpServer:serverListCallback", type(tData), Serialize(tData))
    -- 状态1 正常， 0 token过期
    if tData.state ~= 1 then
        MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, IPDConnector, IPDConnector.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
        return
    end

    -- 设置服务器列表，按登陆时间排序，最近登陆的时间大
    self.IpdServerList = CopyTable(tData.serverList)
    self.IpdAccountCreateDays = tonumber(tData.createDate)
    self.IpdCurTime = tonumber(tData.now)
    -- 服务器列表为空
    if #self.IpdServerList == 0 then
        WndLoginSelect:serverMaintain()
        return
    end

    local function sort(s1,s2)
        return s1.loginTime > s2.loginTime
    end
    table.sort(self.IpdServerList,sort)
    self:initLogined()

    -- 进入选服
    WndLoginSelect:getServerListSuccess(true)
    if WndServersSel.m_root then
        WZLog("---------------WndServersSel-------------------")
        WndServersSel:initServersInfo()
        WndServersSel:_update()
    end
end

-- 获取游戏公告回调
function IPDhttpServer:initGameNotice(data)
    WZLog("------------notice data-------------------",data)
    if not data then return end
    if #data == 0 then return end 
    local title = {}
    local content = {}
    for i = 1, #data do
        local data = data[i]
        table.insert(title,data.title)
        table.insert(content,data.content)
    end
    WZLog("------------------notice--------------",#title,#content,#g_gameNoticeInfo,g_gameNotice)
    g_gameNoticeInfo = {title = title, content = content}
    if not g_gameNotice then
        g_gameNotice = true
        WndAnnouncement:show()
    end
end

-- 获取当前的服务器
function IPDhttpServer:_findServerByServerId(id, name)
    -- 优先获取对应的id
    if name then
        for i = 1 , #self.IpdServerList do
            if self.IpdServerList[i].name == name then
                return self.IpdServerList[i]
            end
        end
    end

    if id then
        for i = 1 , #self.IpdServerList do
            if self.IpdServerList[i].name == tostring(name) then
                return self.IpdServerList[i]
            end
        end
    end

    -- 获取登录时间最大的服务器
    if self.IpdServerList[1].loginTime > 0 then
        return self.IpdServerList[1]
    end

    -- 假如id为空，,且都没有登陆过，则寻找推荐服务器
    for i = 1 , #self.IpdServerList do
        if self.IpdServerList[i].default == 1 then
            return self.IpdServerList[i]
        end
    end
    return self.IpdServerList[1]
end

-- 设置当前的服务器
function IPDhttpServer:setCurServer(serverId, serverName)
    self.IpdCurServer = self:_findServerByServerId(serverId, serverName)
    self:_saveServerId( serverId )
    self:_saveServerName( serverName)
end

-- 获得本地存储的服务器ID
function IPDhttpServer:getCurServerId()
    local localId
    if self.IpdCurServer then 
        localId = self.IpdCurServer.serverId
    else
        local data = WZDataFile:getInstance():getUserData()
        if data then localId = data:getStringValue("IPDParam", "ServerId") end
    end 
    if localId == nil then 
        localId = ""
    end
    return "" .. localId
end

-- 获得本地存储的服务器ID
function IPDhttpServer:getLocalServerName()
    local localId
    local data = WZDataFile:getInstance():getUserData()

    if data then localName = data:getStringValue("IPDParam", "ServerName") end

    return localName
end

-- 设置token
function IPDhttpServer:setIpdToken(token)
    self.IpdToken = token
end

-- 获取token
function IPDhttpServer:getIpdToken()
    return self.IpdToken
end

-- 获取游戏的版本号
function  IPDhttpServer:getIpdVersion()
    return self.version
end

-- 获取更新地址
function IPDhttpServer:getIpdUpdateUrl()
    return self.updateUrl
end

-- 获取评论地址
function IPDhttpServer:getIpdAppraisalUrl()
    return self.appraisalUrl
end

-- 获取所有服务器列表
function IPDhttpServer:getServerList()
	return self.IpdServerList
end

-- 获取当前服务器
function IPDhttpServer:getCurServer()
    return self.IpdCurServer
end

-- 获取当前服务器名称
-- nIndex : 专为从游戏里面退出游戏时候添加的条件限制
function IPDhttpServer:getCurServerName(nIndex)
    if nIndex == 1 then
        return self.IpdCurServer.name,self.IpdCurServer.serverId
    end
    local name = CacheCenter:getServerNameByServerId(self.IpdCurServer.serverId)
    if name ~= "" then
        return name,self.IpdCurServer.serverId
    end
    return self.IpdCurServer.name,self.IpdCurServer.serverId
end

-- 判断玩家是否登录过
function IPDhttpServer:initLogined()
    self.logined = false
    for i = 1 , #self.IpdServerList do
        if self.IpdServerList[i].loginTime > 0 then
            self.logined = true
        end
    end
    return self.logined
end

-- 获取玩家是否登录过
function IPDhttpServer:getLogined()
    return self.logined
end

function IPDhttpServer:getNameById(serverId)
    local name = CacheCenter:getServerNameByServerId(serverId)
    if name == "" then
        for k,v in pairs(self.IpdServerList) do
            if tonumber(v.serverId)  == tonumber(serverId) then
                return v.name
            end
        end
    end

    -- 当前服务器没有的话，就去访问所有的服务器列表
    return name
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

-- 保存服务器ID
function IPDhttpServer:_saveServerId( serverId)
    local data = WZDataFile:getInstance():getUserData()
    if not data then return end
    local curServerId = data:getStringValue("IPDParam", "ServerId")
    if curServerId ~= serverId then
        data:setStringValue("IPDParam", "ServerId", serverId)
        data:flush()
    end
end

-- 保存服务器名字
function IPDhttpServer:_saveServerName( serverName)
    local data = WZDataFile:getInstance():getUserData()
    if not data then return end
    local curServerName = data:getStringValue("IPDParam", "ServerName")
    if curServerName ~= serverName then
        data:setStringValue("IPDParam", "ServerName", serverName)
        data:flush()
    end
end

--@brief	游戏主版本强制更新提示对话框回调
--@param	nId:消息ID
--@param	nType:响应类型
--@note		游戏主版本强制更新提示对话框回调
function IPDhttpServer:updateMainVersionCallback(nId, nType)
    WZLog("IPDhttpServer:updateMainVersionCallback", nId, nType,self.updateUrl,type(self.updateUrl))
    if type(self.updateUrl) ~= "string" then return end
    WZPush:openURL(self.updateUrl)
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if platForm == 13  then
        MsgBoxManager:showConfirmBox(LocalStrings.NEED_UPDATE_VERSION, self, self.updateMainVersionCallback, MSGBOXLEVEL_HIGH, nil,true)
    end
end


-- -------------------------------------------------修改密码------------------------------------------------------------
-- 修改密码
function IPDhttpServer:modifyPassword(url)
    if url then
        local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
        local downLoadInfoTask = WZHTTPInfoLuaTask:createWithTimeout( 1 , url,10,30, self.modifyPasswordCallBack, self)
        downLoadInfoTask:setLevel(15)
        mulThreadSystem:addDownloadTask(downLoadInfoTask)
    end
end

function IPDhttpServer:modifyPasswordCallBack(nTaskID, sData, bFinish, bFailed)
    WZLog("----------------------modifyPasswordCallBack---------------------")
    if bFailed then
        WndModifyPassword:_closeLoadingBox()
        MsgBoxManager:showConfirmBox(LocalStrings.DOWNLOAD_RES_FAIL_TIPS, nil, nil, MSGBOXLEVEL_NORMAL, nil,true)
        return
    end
    local data = json.decode(sData)
    WndModifyPassword:modifyPasswordCallBack(data)
end


-- -------------------------------------------------找回密码------------------------------------------------------------
-- 找回密码
function IPDhttpServer:findPassword(url)
    if url then
        local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
        local downLoadInfoTask = WZHTTPInfoLuaTask:createWithTimeout( 1 , url,10,30, self.findPasswordCallBack, self)
        downLoadInfoTask:setLevel(15)
        mulThreadSystem:addDownloadTask(downLoadInfoTask)
    end
end

--
function IPDhttpServer:findPasswordCallBack(nTaskID, sData, bFinish, bFailed)
    WZLog("----------------------findPasswordCallBack---------------------")
    if bFailed then
        WndLoginSelect:_closeLoadingBox()
        MsgBoxManager:showConfirmBox(LocalStrings.DOWNLOAD_RES_FAIL_TIPS, nil, nil, MSGBOXLEVEL_NORMAL, nil,true)
        return
    end
    local data = json.decode(sData)
    WndLoginSelect:findPasswordCallBack(data)
end

-- ---------------------------------------------------绑定账号----------------------------------------------------------
function IPDhttpServer:bindAccount(url)
    if url then
        local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
        local downLoadInfoTask = WZHTTPInfoLuaTask:createWithTimeout( 1 , url,10,30, self.bindAccountCallBack, self)
        downLoadInfoTask:setLevel(15)
        mulThreadSystem:addDownloadTask(downLoadInfoTask)
    end
end

function IPDhttpServer:bindAccountCallBack(nTaskID, sData, bFinish, bFailed)
    WZLog("----------------------bindAccountCallBack---------------------")
    if bFailed then
        WndBindAccount:_closeLoadingBox()
        MsgBoxManager:showConfirmBox(LocalStrings.DOWNLOAD_RES_FAIL_TIPS, nil, nil, MSGBOXLEVEL_NORMAL, nil,true)
        return
    end
    local data = json.decode(sData)
    WndBindAccount:bindAccountCallBack(data)
end


-------------------------------------------------进入游戏排队------------------------------------------------
-- 返还0表示可以进入游戏，不需要排队，否则需要排队
function IPDhttpServer:needQueueCallBack(nTaskID, sData, bFinish, bFailed)
    if bFailed or sData == nil then
        WndLoginSelect:_closeLoadingBox()
        MsgBoxManager:showConfirmBox(LocalStrings.DOWNLOAD_RES_FAIL_TIPS, nil, nil, MSGBOXLEVEL_NORMAL, nil,true)
        return
    end
    
    WndLoginSelect:needQueueCallBack(sData)
end

-- 返还0表示可以取消排队成功
function IPDhttpServer:cancelQueueCallBack(nTaskID, sData, bFinish, bFailed)
    if bFailed then
        WndLoginSelect:_closeLoadingBox()
        MsgBoxManager:showConfirmBox(LocalStrings.LOGIN_QUEUE5, nil, nil, MSGBOXLEVEL_NORMAL, nil,true)
        return
    end
    WndLoginSelect:cancelQueueCallBack(sData)
end

-------------------------------------私有方法模块End----------------------------------------