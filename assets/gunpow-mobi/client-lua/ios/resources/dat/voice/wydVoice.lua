--[[
功能说明：调用wydVoice的lua接口
创建时间：2014年03月13日
使用说明：
备    注：
--]]


--********************************************************
--内部定义
--********************************************************
--自定义打印函数，不需要输出时，Log*赋值为printNone
function printNone()
end
LogD = CCLuaLog --printNone
LogE = CCLuaLog --printNone
LogI = CCLuaLog --printNone


--wydVoice对象表
WydVoice = 
{
    m_bInitialized = false,   --初始化标识

    m_obj_Adapter = nil,      --WydPlAdapter对象

    m_cb_Msg  = nil,          --语音服务器返回消息

    m_cb_Init          = nil, --0 初始化
    m_cb_ConnectServer = nil, --1 连接服务器
    m_cb_ResetServer   = nil, --2 重置服务器
    m_cb_LoginServer   = nil, --3 登录服务器
    m_cb_LoginOut      = nil, --4 登出服务器
    m_cb_CreaetRoom    = nil, --5 创建房间
    m_cb_GetRoomList   = nil, --6 获取房间列表
    m_cb_EnterRoom     = nil, --7 进入房间
    m_cb_LeaveRoom     = nil, --8 离开房间
    m_cb_GetMemberList = nil, --9 获取房间内人员列表

    m_cb_StartRecord   = nil, --10 开始录音
    m_cb_StopRecord    = nil, --11 停止录音
    m_cb_StartPlay     = nil, --12 开始播放
    m_cb_StopPlay      = nil, --13 停止播放
    m_cb_SetAudioRecv  = nil, --14 设置接收语音玩家
}


--********************************************************
--外部调用接口
--********************************************************
--类的实例化
function WydVoice:new()
    local wydVoice = {}
    setmetatable(wydVoice, self)
    self.__index = self

    return wydVoice
end

--初始化
function WydVoice:initialize()
    LogD("~~~~~~~~~~~~ WydVoice:initialize ~~~~~~~~~~~~")

    if true == self.m_bInitialized then
    LogD("~~~~~~~~~~~~ Initialized Already ~~~~~~~~~~~~")
        return true
    end

    LogD("Step 1 - create adapter object")
    self.m_obj_Adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("WydVoice")


    LogD("Step 2 - create callback object")
    if nil == self.m_obj_Adapter then
        return false
    end

--对应的回调函数列表
--[[
    self.m_cb_Init          = WZAdapterCallback:create(self.callback_Init, self)          --0 初始化
    self.m_cb_ConnectServer = WZAdapterCallback:create(self.callback_ConnectServer, self) --1 连接服务器
    self.m_cb_ResetServer   = WZAdapterCallback:create(self.callback_ResetServer, self)   --2 重置服务器
    self.m_cb_LoginServer   = WZAdapterCallback:create(self.callback_LoginServer, self)   --3 登录服务器
    self.m_cb_LoginOut      = WZAdapterCallback:create(self.callback_LoginOut, self)      --4 登出服务器
    self.m_cb_CreaetRoom    = WZAdapterCallback:create(self.callback_CreaetRoom, self)    --5 创建房间
    self.m_cb_GetRoomList   = WZAdapterCallback:create(self.callback_GetRoomList, self)   --6 获取房间列表
    self.m_cb_EnterRoom     = WZAdapterCallback:create(self.callback_EnterRoom, self)     --7 进入房间
    self.m_cb_LeaveRoom     = WZAdapterCallback:create(self.callback_LeaveRoom, self)     --8 离开房间
    self.m_cb_GetMemberList = WZAdapterCallback:create(self.callback_GetMemberList, self) --9 获取房间内人员列表

    self.m_cb_StartRecord   = WZAdapterCallback:create(self.callback_StartRecord, self)   --10 开始录音
    self.m_cb_StopRecord    = WZAdapterCallback:create(self.callback_StopRecord, self)    --11 停止录音
    self.m_cb_StartPlay     = WZAdapterCallback:create(self.callback_StartPlay, self)     --12 开始播放
    self.m_cb_StopPlay      = WZAdapterCallback:create(self.callback_StopPlay, self)      --13 停止播放
--]]

    self.m_bInitialized = true

    return true
end

----------------------------------------------------------
--调用内部接口函数

--@brief    注册服务端回调消息接收者
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:RegisterServerMsgReceiver(funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:RegisterServerMsgReceiver ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = ""
    if nil == self.m_cb_Msg then
        self.m_cb_Msg = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("RegisterServerMsgReceiver", self.m_cb_Msg, strJson)
end

--0
--@brief    初始化
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:init(funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:init ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = ""
    if nil == self.m_cb_Init then
        self.m_cb_Init = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("init", self.m_cb_Init, strJson)
end

--1
--@brief    连接服务器
--@param    serverAddress: 服务器地址
--@param    port: 端口
--@param    timeout: 超时时长（秒）
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:connectServer(serverAddress, port, timeout, funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:connectServer ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = "{\"serverAddress\": \"" .. serverAddress .. "\", \"port\": \"" .. port .. "\", \"timeout\": \"" .. timeout .. "\"}"
    LogD("strJson = " .. strJson)
    if nil == self.m_cb_ConnectServer then
        self.m_cb_ConnectServer = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("connectServer", self.m_cb_ConnectServer, strJson)
end

--2
--@brief    重置服务器
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:resetServer(funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:resetServer ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = ""
    if nil == self.m_cb_ResetServer then
        self.m_cb_ResetServer = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("resetServer", self.m_cb_ResetServer, strJson)
end

--3
--@brief    登录服务器
--@param    playerId: 玩家ID
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:loginServer(playerId, funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:loginServer ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = "{\"playerId\": \"" .. playerId .. "\"}"
    LogD("playerId = " .. strJson)
    if nil == self.m_cb_LoginServer then
        self.m_cb_LoginServer = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("loginServer", self.m_cb_LoginServer, strJson)
end

--4
--@brief    登出服务器
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:loginOut(funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:loginOut ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = ""
    if nil == self.m_cb_LoginOut then
        self.m_cb_LoginOut = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("loginOut", self.m_cb_LoginOut, strJson)
end

--5
--@brief    创建房间
--@param    roomId: 房间ID
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:creaetRoom(roomId, funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:creaetRoom ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = "{\"roomId\": \"" .. roomId .. "\"}"
    LogD("roomId = " .. strJson)
    if nil == self.m_cb_CreaetRoom then
        self.m_cb_CreaetRoom = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("creaetRoom", self.m_cb_CreaetRoom, strJson)
end

--6
--@brief    获取房间列表
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y","RetList":["Z1","Z2","Z3"]}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
--                Zn为房间号
function WydVoice:getRoomList(funcCallBack, tableObject)
   

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = ""
    if nil == self.m_cb_GetRoomList then
        self.m_cb_GetRoomList = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("getRoomList", self.m_cb_GetRoomList, strJson)
end

--7
--@brief    进入房间
--@param    roomId: 房间ID
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:enterRoom(roomId, funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:enterRoom ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = "{\"roomId\": \"" .. roomId .. "\"}"
    LogD("roomId = " .. strJson)
    if nil == self.m_cb_EnterRoom then
        self.m_cb_EnterRoom = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("enterRoom", self.m_cb_EnterRoom, strJson)
end

--8
--@brief    离开房间
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:leaveRoom(funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:leaveRoom ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = ""
    if nil == self.m_cb_LeaveRoom then
        self.m_cb_LeaveRoom = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("leaveRoom", self.m_cb_LeaveRoom, strJson)
end

--9
--@brief    获取房间内人员列表
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y","RetList":["Z1","Z2","Z3"]}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
--                Zn为人员ID
function WydVoice:getMemberList(roomId, funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:getMemberList ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = "{\"roomId\": \"" .. roomId .. "\"}"
    LogD("roomId = " .. strJson)
    if nil == self.m_cb_GetMemberList then
        self.m_cb_GetMemberList = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("getMemberList", self.m_cb_GetMemberList, strJson)
end

--10
--@brief    开始录音
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:startRecord(funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:startRecord ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = ""
    if nil == self.m_cb_StartRecord then
        self.m_cb_StartRecord = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("startRecord", self.m_cb_StartRecord, strJson)
end

--11
--@brief    停止录音
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:stopRecord(funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:stopRecord ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = ""
    if nil == self.m_cb_StopRecord then
        self.m_cb_StopRecord = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("stopRecord", self.m_cb_StopRecord, strJson)
end

--12
--@brief    开始播放
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:startPlay(funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:startPlay ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = ""
    if nil == self.m_cb_StartPlay then
        self.m_cb_StartPlay = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("startPlay", self.m_cb_StartPlay, strJson)
end

--13
--@brief    停止播放
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:stopPlay(funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:stopPlay ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = ""
    if nil == self.m_cb_StopPlay then
        self.m_cb_StopPlay = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("stopPlay", self.m_cb_StopPlay, strJson)
end

--14
--@brief    设置接收语音玩家（playerId=0，则收听房间内所有玩家）
--@param    playerId: 玩家ID
--@param    isRecv: 是否收听（1=收听，0=不收听）
--@param    funcCallBack: 回调方法
--@param    tableObject: （回调的）lua表对象
--@note     回调字段: {"RetCode":"X","RetMsg":"Y"}
--          解释：X为0表示成功，否则为失败原因码
--                Y为具体的错误信息
function WydVoice:setAudioRecv(playerId, isRecv, funcCallBack, tableObject)
    LogD("~~~~~~~~~~~~ WydVoice:setAudioRecv ~~~~~~~~~~~~")

    if false == self.m_bInitialized then
        LogE("~~~~~~~~~~~~ Not initialize ~~~~~~~~~~~~")
        return
    end

    local strJson = "{\"playerId\": \"" .. playerId .. "\", \"isRecv\": \"" .. isRecv .. "\"}"
    LogD("strJson = " .. strJson)
    if nil == self.m_cb_SetAudioRecv then
        self.m_cb_SetAudioRecv = WZAdapterCallback:create(funcCallBack, tableObject)
    end
    self.m_obj_Adapter:callMethodByName("setAudioRecv", self.m_cb_SetAudioRecv, strJson)
end



--********************************************************
--回调函数
--********************************************************
--[[
function WydVoice:callback_Msg(strJson)
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--0 初始化
function WydVoice:callback_Init(strJson)

 LogD("~~~~~~~~~~~~ WydVoice:callback_Init ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--1 连接服务器
function WydVoice:callback_ConnectServer(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_ConnectServer ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--2 重置服务器
function WydVoice:callback_ResetServer(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_ResetServer ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--3 登录服务器
function WydVoice:callback_LoginServer(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_LoginServer ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--4 登出服务器
function WydVoice:callback_LoginOut(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_LoginOut ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--5 创建房间
function WydVoice:callback_CreaetRoom(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_CreaetRoom ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--6 获取房间列表
function WydVoice:callback_GetRoomList(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_GetRoomList ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--7 进入房间
function WydVoice:callback_EnterRoom(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_EnterRoom ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--8 离开房间
function WydVoice:callback_LeaveRoom(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_LeaveRoom ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--9 获取房间内人员列表
function WydVoice:callback_GetMemberList(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_GetMemberList ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--10 开始录音
function WydVoice:callback_StartRecord(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_StartRecord ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--11 停止录音
function WydVoice:callback_StopRecord(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_StopRecord ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--12 开始播放
function WydVoice:callback_StartPlay(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_StartPlay ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--13 停止播放
function WydVoice:callback_StopPlay(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_StopPlay ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end

--14 设置接收语音玩家
function WydVoice:callback_SetAudioRecv(strJson)
    LogD("~~~~~~~~~~~~ WydVoice:callback_SetAudioRecv ~~~~~~~~~~~~")
    if "" == strJson then
        LogI("Empty String")
    end

    LogD("Lua Print: " .. strJson)
end
--]]


