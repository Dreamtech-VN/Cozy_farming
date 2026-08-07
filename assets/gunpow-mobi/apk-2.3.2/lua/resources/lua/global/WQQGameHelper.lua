--WQQGameHelper.lua
--@brief    语言实现类
--@date     2017/03/22
--@author   zhangming
--@note     语言实现类

WQQGameHelper = {
    appId = "1112111547", 
    appName = "弹弹岛2",
    appKey = "eVx1IL0FCYZjVpTo",
    --loginUrl = "http://123.207.87.19:16889/ChannelLogin",--"http://qch.ddd2.zhuoyuechenxing.com:80/ChannelLogin",
    -- loginUrl = "http://192.168.3.239:16888/ChannelLogin?channelid=1118",
    --loginUrl = "http://192.168.3.239:16888/ChannelLogin",
    openId = "",
    openKey = "",
    pf = "qqgame",
    pfKey = "",
    port = "",
    msgBoxElement = nil,
    msgBoxLuaObj = nil,
    m_tMsg = nil,
    m_tMsgId = nil,
    m_nScheduleID = -1,
    m_nScheduleID_1 = -1,
    m_nTimeout = -1,
    m_nLoginTime = 0,
    --沙箱环境
    -- loginUrl = "http://123.207.87.19:16889/ChannelLogin",
    -- zoneId = "3", 
    -- url_openApi = "https://api-sandbox.urlshare.cn",--"https://openapi.minigame.qq.com",
    -- sandbox = "1",--"0"正式 "1"沙箱
    -- url_luopan = "https://tglog.datamore.qq.com/testdev/report/",--罗盘事件上传-测试环境
    -- key_luopan = "SignKey@2019AclieDEV786",
    --正式环境
    loginUrl = "http://qch.ddd2.zhuoyuechenxing.com:80/ChannelLogin",
    zoneId = "4", 
    url_openApi = "https://openapi.minigame.qq.com",--"https://openapi.minigame.qq.com",
    sandbox = "0",--"0"正式 "1"沙箱
    url_luopan = "https://tglogsz.datamore.qq.com/webgame/report/",--罗盘事件上传-正式环境
    key_luopan = "webgame@2019J5v6ByRT", 
    loginVerifyUrl = "http://qch.ddd2.zhuoyuechenxing.com:80/ChannelLoginVerify",
}

--@brief    initSDK函数
--@param  appkey, appid组成的json
function WQQGameHelper:init(jsonArg)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:init", jsonArg)
    local params = {}
    if jsonArg then
        params = json.decode(jsonArg)
    end
    params.appId = WQQGameHelper.appId
    params.appKey = WQQGameHelper.appKey
    params.pf = WQQGameHelper.pf
    params.url_openApi = WQQGameHelper.url_openApi
    local sJson = json.encode(params)
    --WZLog("WQQGameHelper:init", sJson)
    GameHelper_QQ:getInstance():init(sJson)
    WQQGameHelper:initData()
    WQQGameHelper:set_game_cursor("mou_cur")
    if WZResourceManager then
        --WZResourceManager:getInstance():executeLuaFile("global/WndConfirmBoxWithOtherWidgetData.lua")
        --WZResourceManager:getInstance():executeLuaFile("global/WndConfirmBoxWithOtherWidget.lua")

        WZLog("WQQGameHelper:init executeLuaFile")
        WZResourceManager:getInstance():executeLuaFile("bossMap/WndKingEndTipData.lua")
        WZResourceManager:getInstance():executeLuaFile("bossMap/WndKingEndTip.lua")
    end
    local url = "ws://localhost:" .. WQQGameHelper.port .."/websocket/" .. WQQGameHelper.openId
    local isConnect = WQQGameHelper:get_is_connect_ws()
    if GlobalGame and GlobalGame.g_bIsConnectQQHallWebSocket == false and isConnect == false then
        print("WQQGameHelper:init connect_ws")
        WQQGameHelper:connect_ws(url)
        GlobalGame.g_bIsConnectQQHallWebSocket = true
    end
end

--@brief    initSDK函数
--@param  appkey, appid组成的json
function WQQGameHelper:initData()
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:initData")
    WQQGameHelper.m_nLoginTime = os.time()
    local data = WZDataFile:getInstance():getUserData()
    if not data then return false end
    local openId = data:getStringValue("GAME_HALL_DATA", "OPENID")
    local openKey = data:getStringValue("GAME_HALL_DATA", "OPENKEY")
    local pf = data:getStringValue("GAME_HALL_DATA", "PF")
    local pfKey = data:getStringValue("GAME_HALL_DATA", "PFKEY")
    local port = data:getStringValue("GAME_HALL_DATA", "PORT")
    if not openId or openId == "" 
        or not openKey or openKey == "" 
        or not pf or pf == "" 
        or not pfKey or pfKey == ""
        or not port or port == ""  then 
        WZLog("---------------WQQGameHelper:initData-----------------", "openId is empty")
        WQQGameHelper:record_cmd_to_userData()
        return false
    end
    WQQGameHelper.openId = WQQGameHelper:get_decode_base64(openId)
    WQQGameHelper.openKey = WQQGameHelper:get_decode_base64(openKey)
    WQQGameHelper.pf = WQQGameHelper:get_decode_base64(pf)
    WQQGameHelper.pfKey = WQQGameHelper:get_decode_base64(pfKey)
    WQQGameHelper.port = WQQGameHelper:get_decode_base64(port)
    -----WQQGameHelper.zoneId = WQQGameHelper.zoneId
    --WZLog("---------------WQQGameHelper:initData-----------------", Serialize(WQQGameHelper))
    --定时续期openkey
    WQQGameHelper:updateOpenKey()
    return true
end

--@brief    将openId等信息保存到userdata函数
function WQQGameHelper:get_is_connect_ws()
    print("WQQGameHelper:get_is_connect_ws")
    local isConnect = false
    if GameHelper_QQ and GameHelper_QQ.get_is_connect_ws then 
        print("WQQGameHelper:get_is_connect_ws 111")
        isConnect = GameHelper_QQ:getInstance():get_is_connect_ws()
    end
    print("WQQGameHelper:get_is_connect_ws", isConnect)
    return isConnect
end

--@brief    将openId等信息保存到userdata函数
function WQQGameHelper:record_cmd_to_userData()
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:record_cmd_to_userData")
    GameHelper_QQ:getInstance():record_cmd_to_userData()
end

--@brief    http请求用例函数-无用
--@param  玩家信息json
function WQQGameHelper:qq_request_sample(jsonArg)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:qq_request_sample", jsonArg)
    GameHelper_QQ:getInstance():qq_request_sample()
end

--@brief    qq大厅下单请求用例函数-暂时无用
--@param  订单信息的json
function WQQGameHelper:qq_request_v3_pay_buy_goods(jsonArg)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:qq_request_v3_pay_buy_goods", jsonArg)
    GameHelper_QQ:getInstance():qq_request_v3_pay_buy_goods()
end

--@brief    qq大厅用户信息请求用例函数-暂时无用
--@param  玩家信息的json
function WQQGameHelper:qq_request_v3_user_get_info(jsonArg)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:qq_request_v3_user_get_info", jsonArg)
    GameHelper_QQ:getInstance():qq_request_v3_user_get_info()
end

--@brief    确认退出游戏函数 - 用于退出游戏二次确认框点击确定
function WQQGameHelper:on_ready_to_exit_game()
    if not GameHelper_QQ then return end
    CCLuaLog("WQQGameHelper:on_ready_to_exit_game")
    if g_bisloadingres then
        if WQQGameHelper.m_nScheduleID > 0 then 
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WQQGameHelper.m_nScheduleID)
            WQQGameHelper.m_nScheduleID = 0
        end 
        if WQQGameHelper.msgBoxElement and WQQGameHelper.msgBoxLuaObj then
            WQQGameHelper.msgBoxLuaObj:onConfirm()--再玩一会
        end
        return
    end
    if CacheCenter and CacheCenter:getPlayerInfo() then
        CCLuaLog("WQQGameHelper:on_ready_to_exit_game 1")
        if WndKingEndTip and WndKingEndTip.showInterface then
            WndKingEndTip:showInterface()
        end
    else        
        CCLuaLog("WQQGameHelper:on_ready_to_exit_game 2")
        if WQQGameHelper.m_nTimeout > 0 then
            return
        end
        if MsgBoxManager then
            --WQQGameHelper.m_nTimeout = 5
            local tMsgId, tMsg = MsgBoxManager:showConfirmCancelBox("", WQQGameHelper, WQQGameHelper.on_sure_to_exit_game, MSGBOXLEVEL_HIGH,nil)
            if tMsg and tMsgId then
                --tMsg.nTimeout = 5
                CCLuaLog("WQQGameHelper:on_ready_to_exit_game 2-1")
                WQQGameHelper.m_tMsg = tMsg
                WQQGameHelper.m_tMsgId = tMsgId

                WQQGameHelper.m_nTimeout = 5
                WQQGameHelper.msgBoxElement = nil
                WQQGameHelper.msgBoxLuaObj = nil
                if WQQGameHelper.m_nScheduleID > 0 then 
                    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WQQGameHelper.m_nScheduleID)
                    WQQGameHelper.m_nScheduleID = 0
                end 
                WQQGameHelper.m_nScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WQQGameHelper.scheduleFunc, 0, false)
            end
        end
    end
end

--@brief
function WQQGameHelper:scheduleFunc()    
    WZLog("WQQGameHelper:scheduleFunc", WQQGameHelper.m_nTimeout)
    WQQGameHelper.msgBoxElement = MsgBoxManager.m_tMsgBoxElementList[WQQGameHelper.m_tMsg]
    WQQGameHelper.msgBoxLuaObj = MsgBoxManager.m_tMsgBoxLuaObjList[WQQGameHelper.m_tMsg]
    if WQQGameHelper.msgBoxElement and WQQGameHelper.msgBoxLuaObj then
        WZLog("WQQGameHelper:scheduleFunc.....ok")
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WQQGameHelper.m_nScheduleID)

        local txtCancel = GetElement(WQQGameHelper.msgBoxElement, "txtCancel_WndConfirmCancelBox", WZUILabelTTF)
        local txtConfirm = GetElement(WQQGameHelper.msgBoxElement, "txtConfirm_WndConfirmCancelBox", WZUILabelTTF)
        if txtCancel then
            WZLog("WQQGameHelper:scheduleFunc.....ook 1", txtCancel:getText())
            txtCancel:setTextKey("")
            txtCancel:setText(LocalStrings.LZTQ_TEXT1[12])
        end
        if txtConfirm then
            WZLog("WQQGameHelper:scheduleFunc.....ook 2", txtConfirm:getText())
            txtConfirm:setTextKey("")
            txtConfirm:setText(LocalStrings.LZTQ_TEXT1[11])
        end
        local txtContent = GetElement(WQQGameHelper.msgBoxElement, "txtContent_WndConfirmCancelBox", WZUILabelTTF)        
        if txtContent then
            WZLog("WQQGameHelper:scheduleFunc.....ook 2", txtContent:getText())
            --txtContent:setTextKey("")
            txtContent:setText(string.format(LocalStrings.LZTQ_TEXT1[14], WQQGameHelper.m_nTimeout))
        end
        WQQGameHelper.m_nScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WQQGameHelper.scheduleFunc_1, 1, false)
        -- if WQQGameHelper.m_nTimeout <= 0 then
        --     WQQGameHelper.msgBoxLuaObj:onCancel()
        --     CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nScheduleID)
        -- end
    end
    --WQQGameHelper.m_nTimeout = WQQGameHelper.m_nTimeout - 1
end

function WQQGameHelper:scheduleFunc_1()    
    WZLog("WQQGameHelper:scheduleFunc_1", WQQGameHelper.m_nTimeout)
    WQQGameHelper.m_nTimeout = WQQGameHelper.m_nTimeout - 1
    local txtContent = GetElement(WQQGameHelper.msgBoxElement, "txtContent_WndConfirmCancelBox", WZUILabelTTF)        
    if txtContent then
        WZLog("WQQGameHelper:scheduleFunc_1.....ook 2", txtContent:getText())
        --txtContent:setTextKey("")
        txtContent:setText(string.format(LocalStrings.LZTQ_TEXT1[14], WQQGameHelper.m_nTimeout))
    end
    if WQQGameHelper.m_nTimeout <= 0 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WQQGameHelper.m_nScheduleID)
        WQQGameHelper.msgBoxLuaObj:onConfirm()--再玩一会
    end
end

function WQQGameHelper:_unInit()
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WQQGameHelper.m_nScheduleID)
    WQQGameHelper.m_tMsg = nil
    WQQGameHelper.m_tMsgId = nil    
    WQQGameHelper.msgBoxElement = nil
    WQQGameHelper.msgBoxLuaObj = nil
    WQQGameHelper.m_nTimeout = -1
    WQQGameHelper.m_nScheduleID = 0
    if WQQGameHelper.m_nScheduleID_1 > 0 then 
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WQQGameHelper.m_nScheduleID_1)
        WQQGameHelper.m_nScheduleID_1 = 0
    end 
end

--@brief    确认退出游戏函数 - 用于退出游戏二次确认框点击确定
function WQQGameHelper:on_sure_to_exit_game(nId, nResType)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:on_sure_to_exit_game", nId, nResType)
    WQQGameHelper:_unInit()
    if nResType and nResType == MSGBOXRESTYPE_CONFIRM then
        WZLog("WQQGameHelper:on_sure_to_exit_game 1")
        return
    end
    if GameHelper_QQ and GameHelper_QQ.getInstance and GameHelper_QQ.on_sure_to_exit_game then        
        if WQQGameHelper.m_nScheduleID > 0 then 
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WQQGameHelper.m_nScheduleID)
            WQQGameHelper.m_nScheduleID = 0
        end 
        WQQGameHelper:postEventLuopan(9)
        WQQGameHelper.m_nScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WQQGameHelper.on_sure_to_exit_game_delay, 2, false)
    end
end

--@brief    确认退出游戏函数 - 用于退出游戏二次确认框点击确定
function WQQGameHelper:on_sure_to_exit_game_delay()
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:on_sure_to_exit_game_delay")
    if WQQGameHelper.m_nScheduleID > 0 then 
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WQQGameHelper.m_nScheduleID)
        WQQGameHelper.m_nScheduleID = 0
    end 
    GameHelper_QQ:getInstance():on_sure_to_exit_game()
end

--@brief    qq大厅发起支付函数
--@param  玩家信息包括订单token
function WQQGameHelper:on_start_purchase(jsonArg)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:on_start_purchase", jsonArg)
    GameHelper_QQ:getInstance():on_start_purchase(jsonArg)
end

--@brief    qq大厅发起支付函数
--@param  玩家信息包括订单token
function WQQGameHelper:on_start_buy_vip(jsonArg)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:on_start_buy_vip", jsonArg)
    local _payParam = {}
    _payParam.cmd = "buy_vip"
    _payParam.action = "openVip"
    _payParam.appId = WQQGameHelper.appId
    _payParam.appKey = WQQGameHelper.appKey
    _payParam.openId = WQQGameHelper.openId
    _payParam.openKey = WQQGameHelper.openKey
    _payParam.pf = WQQGameHelper.pf
    _payParam.pfKey = WQQGameHelper.pfKey
    _payParam.zoneId = WQQGameHelper.zoneId
    GameHelper_QQ:getInstance():on_start_buy_vip(json.encode(_payParam))
end

--@brief    qq大厅设置鼠标
--@param  文件名
function WQQGameHelper:set_game_cursor(fileName)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:set_game_cursor", fileName)
    GameHelper_QQ:getInstance():set_game_cursor(fileName)
end

--@brief    qq大厅socket通信函数
--@param  json:{"cmd":"xxx","param":"xxx"}
function WQQGameHelper:ws_send_data(jsonArg)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:ws_send_data", jsonArg)
    GameHelper_QQ:getInstance():ws_send_data()
end

--@brief    qq大厅socket通信函数
--@param  cmdStr,paramStr-参考WQQGameHelper:ws_send_data
function WQQGameHelper:ws_send_data_withCMD(cmdStr, paramStr)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:ws_send_data_withCMD", cmdStr, paramStr)
    GameHelper_QQ:getInstance():ws_send_data_withCMD(cmdStr, paramStr)
end

--@brief    qq大厅socket通信-断开
function WQQGameHelper:disconnect_ws()
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:disconnect_ws")
    GameHelper_QQ:getInstance():disconnect_ws()
end

--@brief    qq大厅socket通信-连接
function WQQGameHelper:connect_ws(url)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:connect_ws")
    GameHelper_QQ:getInstance():connect_ws(url)
end

--@brief    退出游戏前发送socket到qq大厅
function WQQGameHelper:ws_send_data_exit()
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:ws_send_data_exit")
    GameHelper_QQ:getInstance():ws_send_data_exit()
end

--@brief    qq大厅老板键
--@param  isShow(bool)：1:显示 0:隐藏 (true,false)
function WQQGameHelper:ws_receive_data_bosskey(isShow)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:ws_receive_data_bosskey", isShow)
    GameHelper_QQ:getInstance():ws_receive_data_bosskey(isShow)
end

--@brief    qq大厅游戏前台显示
function WQQGameHelper:ws_receive_data_bringtotop()
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:ws_receive_data_bringtotop")
    GameHelper_QQ:getInstance():ws_receive_data_bringtotop()
end

--@brief    qq大厅游戏前台显示
function WQQGameHelper:char_To_UTF8(strSrc)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:char_To_UTF8", strSrc)
    local val = GameHelper_QQ:getInstance():char_To_UTF8(strSrc)
    WZLog("WQQGameHelper:char_To_UTF8-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WQQGameHelper:get_url_encode(encode)
    if not GameHelper_QQ then return end
    --WZLog("WQQGameHelper:get_url_encode", encode)
    local val = GameHelper_QQ:getInstance():get_url_encode(encode)
    --WZLog("WQQGameHelper:get_url_encode-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WQQGameHelper:get_url_encode_bigcase(encode)
    if not GameHelper_QQ then return end
    --WZLog("WQQGameHelper:get_url_encode_bigcase", encode)
    local val = GameHelper_QQ:getInstance():get_url_encode_bigcase(encode)
    --WZLog("WQQGameHelper:get_url_encode_bigcase-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WQQGameHelper:get_qq_encode_bigcase(encode)
    if not GameHelper_QQ then return end
    --WZLog("WQQGameHelper:get_qq_encode_bigcase", encode)
    local val = GameHelper_QQ:getInstance():get_qq_encode_bigcase(encode)
    --WZLog("WQQGameHelper:get_qq_encode_bigcase-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WQQGameHelper:get_hmac_sha1(key, value)
    if not GameHelper_QQ then return end
    --WZLog("WQQGameHelper:get_hmac_sha1", key, value)
    local val = GameHelper_QQ:getInstance():get_hmac_sha1(key, value)
    --WZLog("WQQGameHelper:get_hmac_sha1-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WQQGameHelper:get_encode_base64_for_hmac_sha1(key, value)
    if not GameHelper_QQ then return end
    --WZLog("WQQGameHelper:get_encode_base64_for_hmac_sha1", key, value)
    local val = GameHelper_QQ:getInstance():get_encode_base64_for_hmac_sha1(key, value)
    --WZLog("WQQGameHelper:get_encode_base64_for_hmac_sha1-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WQQGameHelper:get_encode_base64(encode)
    if not GameHelper_QQ then return end
    --WZLog("WQQGameHelper:get_encode_base64", encode)
    local val = GameHelper_QQ:getInstance():get_encode_base64(encode)
    --WZLog("WQQGameHelper:get_encode_base64-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WQQGameHelper:get_decode_base64(decode)
    if not GameHelper_QQ then return end
    WZLog("WQQGameHelper:get_decode_base64", decode)
    local val = GameHelper_QQ:getInstance():get_decode_base64(decode)
    WZLog("WQQGameHelper:get_decode_base64-1", val)
    return val
end

function WQQGameHelper:ChannelLoginVerify()
   WZLog("WQQGameHelper:ChannelLoginVerify:")
   local data = {}
   data["openid"] = WQQGameHelper.openId
   data["openkey"] = WQQGameHelper.openKey
   data["pf"] = WQQGameHelper.pf
   data["accountName"] = WQQGameHelper.pf.."-"..WQQGameHelper.openId
   data["pfKey"] = WQQGameHelper.pfKey
   data["zoneId"] = WQQGameHelper.zoneId
   local channelId = ProjConfig:getChannelId()
  local sPostData = "channelid="..channelId.."&data="..json.encode(data).."&data="..json.encode(data)
   WZLog("WQQGameHelper:ChannelLoginVerify sPostData:", sPostData)
  local url = WQQGameHelper.loginUrl
  local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
  local downLoadInfoTask = nil
  downLoadInfoTask = WZHTTPPostDataLuaTask:create(1, url,sPostData,WQQGameHelper.loginCallback, WQQGameHelper)
  downLoadInfoTask:setLevel(11)
  mulThreadSystem:addDownloadTask(downLoadInfoTask)
end

function WQQGameHelper:loginCallback(nTaskId, sResponse, nTotalSize, nNowSize, bFinished, bFailed)
    --WZLog("WQQGameHelper:loginCallback sResponse:", nTaskId,sResponse,nTotalSize,nNowSize,bFinished,bFailed)
    if bFinished then --成功
        WZLog("WQQGameHelper:loginCallback1111 sResponse:", sResponse)
        if WndLoginSelect.m_root and WndLoginSelect.QQHallLogin then
            WndLoginSelect:QQHallLogin()
        end
        local strArray = SplitStringWithSeparator(sResponse,"\n")
        local str1 = strArray[#strArray]
        if #strArray <= 2 then
            return
        end
        WZLog("WQQGameHelper:loginCallback2222 str1:", str1)
    elseif bFailed then --失败
         WZLog("WQQGameHelper:loginCallback4444:",sResponse)
    end
end

--罗盘日志上报
--@param actionId:1-登录 9-登出 12-创角 2-主动注册(首次登录注册)
function WQQGameHelper:postEventLuopan(actionId)
    WZLog("WQQGameHelper:postEventLuopan:", actionId)
    -- 注意：log_fields中是kv的形式，由于&和=是特殊的字符，|是传输特殊用途字符，所以如果日志内容包括这些字符
    -- 需要做转义。需要转义字符如下：
    -- 将 | 替换为 %7C
    -- 将 & 替换为 %26
    -- 将 = 替换为 %3D
    --Content-Type:application/json signature:MD5的字符串 version:1.0
    -- { "title":{参见消息头描述}, "data":[{log1},{log2},...] }
    -- { "app_id":"xxx", "app_name":"yyy", "timestamp":"1542013120", "seq_id":"123456", "retry_times":"0", ... }
    --{"title":
    -- {"app_id":"1104323232","app_name":"","timestamp":"1546308000","seq_id":"123456789","retry_times":"0"},"da
    -- ta":[{"log_name":"log_common","log_fields":"dtEventTime=2011-9-11
    -- 00:00:00&iversion=1.0.0&appid=1104323232&userip=10.10.32.1&svrip=196.168.1.10&action_time=15463080
    -- 00&domain=10&optype=3&actionid=1&iworldid=12&opuid=123456789&opopenid=000000000000000000000
    -- 00000000001&level=1&touid=1234567809&toopenid=00000000000000000000000000000002&source=qqga
    -- me_index"}]}
    local playerInfo = CacheCenter:getPlayerInfo()
    if not playerInfo then return end
    local onlineTime = NetManager.m_nServerCurTime - WQQGameHelper.m_nLoginTime
    WZLog("WQQGameHelper:postEventLuopan onlineTime:", onlineTime)
    local title = {}
    title["app_id"] = WQQGameHelper.appId
    title["app_name"] = WQQGameHelper.appName
    title["timestamp"] = os.time()
    title["seq_id"] = IPDhttpServer:getCurServerId() .. '-' .. playerInfo.id .. '-' .. os.time()--序列号 唯一
    title["retry_times"] = "0"
    local data = {}
    local logData = {}
    logData["log_name"] = "log_common"
    logData["log_fields"] = "dtEventTime="..os.date("%Y-%m-%d %H:%M:%S")..
                        "&iversion="..ProjConfig.INSTALLVERSION..
                        "&appid="..WQQGameHelper.appId..
                        "&opopenid="..WQQGameHelper.openId..
                        "&domain=10"..
                        "&actionid="..actionId..
                        "&action_time="..title["timestamp"]..
                        "&time="..title["timestamp"]..
                        "&iworldid=1"..
                        "&optype=3"..
                        "&opuid="..IPDhttpServer:getCurServerId() .. '-' .. playerInfo.id..
                        --"&touid="..""..
                        --"&toopenid="..""..
                        "&level="..playerInfo.level..
                        "&source=qqgame_index"
                        --.."&userip="..""..
                        --"&svrip="..""
    if actionId == 9 then
        logData["log_fields"] = logData["log_fields"] .. "&onlinetime="..onlineTime
    end
                        
    data[1] = logData
    local postData = {}
    postData["title"] = title
    postData["data"] = data
    local sPostData = json.encode(postData)
    WZLog("WQQGameHelper:postEventLuopan sPostData:", sPostData)

    local url = WQQGameHelper.url_luopan
    local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
    local downLoadInfoTask = nil
    downLoadInfoTask = WZHTTPPostDataLuaTask:create(10, url,sPostData,WQQGameHelper.luopanCallback, WQQGameHelper)
    if downLoadInfoTask.setHeader then
        -- signature为（消息+密钥）然后MD5后的字符串（+为连接的意思，字符串直接拼接在一起，消息指的是body的整个
        -- json串），后台也会做这个操作去验证字符串是否一致，不一致会丢弃。其中密钥会私下提供，正式环境和测试环境
        -- 密钥不同。
        local signature = WZDeviceInfo:md5Generate(sPostData..WQQGameHelper.key_luopan)
        WZLog("WQQGameHelper:postEventLuopan signature:", signature)
        downLoadInfoTask:setHeader("Content-Type","application/json")
        downLoadInfoTask:setHeader("signature", signature)
        downLoadInfoTask:setHeader("version", "1.0")
        mulThreadSystem:addDownloadTask(downLoadInfoTask)
    else
        WZLog("NNNNNNNNNNNNNN")
    end 
end

function WQQGameHelper:luopanCallback(nTaskId, sResponse, nTotalSize, nNowSize, bFinished, bFailed)
    --WZLog("WQQGameHelper:luopanCallback sResponse:", nTaskId,sResponse,nTotalSize,nNowSize,bFinished,bFailed)
    if bFinished then --成功
        WZLog("WQQGameHelper:luopanCallback1111 sResponse:", sResponse)
        local strArray = SplitStringWithSeparator(sResponse,"\n")
        local str1 = strArray[#strArray]
        if #strArray <= 2 then
            return
        end
        WZLog("WQQGameHelper:luopanCallback2222 str1:", str1)
    elseif bFailed then --失败
         WZLog("WQQGameHelper:luopanCallback4444:",sResponse)
    end
end

--每半个小时续期openkey，否则失效，每次调用is_login接口续期2小时
function WQQGameHelper:updateOpenKeyOld()
    WZLog("WQQGameHelper:updateOpenKeyOld:")
    --将所有参数存到升序map中
    local data = {}
    data["appid"] = WQQGameHelper.appId
    data["openid"] = WQQGameHelper.openId
    data["openkey"] = WQQGameHelper.openKey
    data["pf"] = WQQGameHelper.pf
    local data_bigcase = {}
    data_bigcase["appid"] =  WQQGameHelper:get_url_encode_bigcase(WQQGameHelper.appId)
    data_bigcase["openid"] =  WQQGameHelper:get_url_encode_bigcase(WQQGameHelper.openId)
    data_bigcase["openkey"] =  WQQGameHelper:get_url_encode_bigcase(WQQGameHelper.openKey)
    data_bigcase["pf"] =  WQQGameHelper:get_url_encode_bigcase(WQQGameHelper.pf)
    --data["format"] = "json"
    --=&连接每个参数
    local params1 = "appid".."="..data["appid"].."&"..
                    "openid".."="..data["openid"].."&"..
                    "openkey".."="..data["openkey"].."&"..
                    "pf".."="..data["pf"]
    local params1_bigcase = WQQGameHelper:get_url_encode_bigcase(params1)

    local params2 = "appid".."="..data_bigcase["appid"].."&"..
                    "openid".."="..data_bigcase["openid"].."&"..
                    "openkey".."="..data_bigcase["openkey"].."&"..
                    "pf".."="..data_bigcase["pf"]
    --对uri进行urlencode
    local uri = "/v3/user/is_login"
    local uri_bigcase = WQQGameHelper:get_url_encode_bigcase(uri)
    local key = WQQGameHelper.appKey .. "&"

    local params1_final = "POST&" .. uri_bigcase .. "&" .. params1_bigcase
    --hmac_sha1后base64即可获取签名串
    local sig_base64 = WQQGameHelper:get_encode_base64_for_hmac_sha1(key, params1_final)
    local sig_base64_bigcase = WQQGameHelper:get_url_encode_bigcase(sig_base64)

    local params = params2 .. "&" .. "sig=" .. sig_base64_bigcase
    data_bigcase["sig"] = sig_base64_bigcase

    local sPostData = json.encode(data_bigcase)
    --WZLog("WQQGameHelper:updateOpenKey sPostData:", params)
    --https://openapi.minigame.qq.com/v3/user/is_login
    local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
    local downLoadInfoTask = nil
    --POST
    -- local url = WQQGameHelper.url_openApi .. uri
    local url = WQQGameHelper.url_openApi .. uri
    downLoadInfoTask = WZHTTPPostDataLuaTask:create(1, url, params, WQQGameHelper.updateOpenKeyCallback_POST, WQQGameHelper)
    --GET
    -- local url = WQQGameHelper.url_openApi .. uri .. "?" .. params
    -- downLoadInfoTask = WZHTTPInfoLuaTask:create(1, url, WQQGameHelper.updateOpenKeyCallback_GET, self)
    
    downLoadInfoTask:setLevel(10)
    mulThreadSystem:addDownloadTask(downLoadInfoTask)
end
--@brief    回调函数
--@param    nTaskID:任务ID，为固定值：IPDConnector.IPD_TASK
--@param    sData:IPD服务器返回的数据
--@param    bFinish:数据获取是否完成，true：IPD服务器访问完成
--@param    bFailed:数据获取是否失败，false：获取IPD数据成功
--@note     在这里判断IPD链接结果并做相应的操作
function WQQGameHelper:updateOpenKeyCallback_GET(nTaskID, sData, bFinish, bFailed)
    --WZLog("WQQGameHelper:updateOpenKeyCallback sResponse:",nTaskID, sData, bFinish, bFailed)
    if bFinish then --成功
        WZLog("WQQGameHelper:updateOpenKeyCallback_GET 111", sData)
    end
end
function WQQGameHelper:updateOpenKeyCallback_POST(nTaskId, sResponse, nTotalSize, nNowSize, bFinished, bFailed)
    --WZLog("WQQGameHelper:updateOpenKeyCallback sResponse:", nTaskId,sResponse,nTotalSize,nNowSize,bFinished,bFailed)
    if bFinished then --成功
        WZLog("WQQGameHelper:updateOpenKeyCallback_POST sResponse:", sResponse)
    elseif bFailed then --失败
         WZLog("WQQGameHelper:updateOpenKeyCallback_POST 333:",sResponse)
    end
end

--@brief    定时续期openkey
function WQQGameHelper:updateOpenKey()
    print("WQQGameHelper:updateOpenKey")
    --定时续期openkey
    if GameHelper_QQ and GameHelper_QQ.getInstance then        
        if WQQGameHelper.m_nScheduleID_1 > 0 then 
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WQQGameHelper.m_nScheduleID_1)
            WQQGameHelper.m_nScheduleID_1 = 0
        end 
        print("WQQGameHelper:updateOpenKey updateOpenKey_1")
        WQQGameHelper.m_nScheduleID_1 = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WQQGameHelper.updateOpenKey_1, 30*60, false)
    end
end

function WQQGameHelper:updateOpenKey_1()
   WZLog("WQQGameHelper:updateOpenKey_1:")
   local data = {}
   data["openid"] = WQQGameHelper.openId
   data["openkey"] = WQQGameHelper.openKey
   data["openId"] = WQQGameHelper.openId
   data["openKey"] = WQQGameHelper.openKey
   data["pf"] = WQQGameHelper.pf
   data["accountName"] = WQQGameHelper.pf.."-"..WQQGameHelper.openId
   data["pfKey"] = WQQGameHelper.pfKey
   data["pfkey"] = WQQGameHelper.pfKey
   data["zoneId"] = WQQGameHelper.zoneId
   local channelId = ProjConfig:getChannelId()
  local sPostData = "channelid="..channelId.."&data="..json.encode(data).."&data="..json.encode(data)
   WZLog("WQQGameHelper:updateOpenKey_1 sPostData:", sPostData)
  local url = WQQGameHelper.loginVerifyUrl
  local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
  local downLoadInfoTask = nil
  downLoadInfoTask = WZHTTPPostDataLuaTask:create(1, url,sPostData,WQQGameHelper.updateOpenKeyCallback_1, WQQGameHelper)
  downLoadInfoTask:setLevel(11)
  mulThreadSystem:addDownloadTask(downLoadInfoTask)
end

function WQQGameHelper:updateOpenKeyCallback_1(nTaskId, sResponse, nTotalSize, nNowSize, bFinished, bFailed)
    --WZLog("WQQGameHelper:loginCallback sResponse:", nTaskId,sResponse,nTotalSize,nNowSize,bFinished,bFailed)
    if bFinished then --成功
        WZLog("WQQGameHelper:updateOpenKeyCallback_1 sResponse:", sResponse)
        -- if WndLoginSelect.m_root and WndLoginSelect.QQHallLogin then
        --     WndLoginSelect:QQHallLogin()
        -- end
        local strArray = SplitStringWithSeparator(sResponse,"\n")
        local str1 = strArray[#strArray]
        if #strArray <= 2 then
            return
        end
        WZLog("WQQGameHelper:updateOpenKeyCallback_1 str1:", str1)
    elseif bFailed then --失败
         WZLog("WQQGameHelper:updateOpenKeyCallback_1:",sResponse)
    end
end