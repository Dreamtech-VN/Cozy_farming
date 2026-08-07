--WGameHelperFlash.lua
--@brief    语言实现类
--@date     2017/03/22
--@author   zhangming
--@note     语言实现类

WGameHelperFlash = {
    msgBoxElement = nil,
    msgBoxLuaObj = nil,
    m_tMsg = nil,
    m_tMsgId = nil,
    m_nScheduleID = -1,
    m_nScheduleID_1 = -1,
    m_nTimeout = -1,
    m_nLoginTime = 0,

    gkey = "ddd2",--游戏缩写，对接时双方商定
    winid = "",--int游戏大厅的窗口句柄, 后续和游戏大厅交互时需用到
    token = "",--string用户登录token
    source = "",--string安装来源
    serverid = "",--string游戏区服
    fcext = "",--string扩展参数

    uid = "",--用户id
    platform = "",--平台ID 固定值 fc
    server_id = "",--区服ID    
    vip_level = "",--ip等级   
    is_adult = "",--实名信息    0: 用户未填写实名制信息  1: 用户填写过实名制信息，且大于18岁  2: 用户填写过实名制信息，但是小于18岁
    callback_info = "",--回调参数    游戏调起充值页面时需要回调给充值页面

    loginUrl = "https://game.flash.cn/client/fc-token-login",
}

--@brief    initSDK函数
--@param  appkey, appid组成的json
function WGameHelperFlash:init(jsonArg)
    if not GameHelper_Flash then return end
    print("WGameHelperFlash:init", jsonArg)
    local params = {}
    if jsonArg then
        params = json.decode(jsonArg)
    end    
    local sJson = json.encode(params)
    --print("WGameHelperFlash:init", sJson)
    GameHelper_Flash:getInstance():init(sJson)
    --WGameHelperFlash:initData()
    WGameHelperFlash:set_game_cursor("mou_cur")
    if WZResourceManager then
        --WZResourceManager:getInstance():executeLuaFile("global/WndConfirmBoxWithOtherWidgetData.lua")
        --WZResourceManager:getInstance():executeLuaFile("global/WndConfirmBoxWithOtherWidget.lua")
        print("WGameHelperFlash:init executeLuaFile")
        WZResourceManager:getInstance():executeLuaFile("bossMap/WndKingEndTipData.lua")
        WZResourceManager:getInstance():executeLuaFile("bossMap/WndKingEndTip.lua")
        if not MsgBoxManager then
            WZResourceManager:getInstance():executeLuaFile("global/MsgBoxManager.lua")
        end
        if not WGameHelperUtil then
            WZResourceManager:getInstance():executeLuaFile("global/WGameHelperUtil.lua")
        end
    end
end

--@brief    initCallback函数
--@param  游戏启动参数组成的json
function WGameHelperFlash:initCallback(jsonArg)
    print("WGameHelperFlash:initCallback", jsonArg)
    if not GameHelper_Flash then return end
    local tResult = json.decode(jsonArg)
    if not tResult then return end
    WGameHelperFlash.m_nLoginTime = os.time()
    WGameHelperFlash.winid = tResult["winid"] or ""--int游戏大厅的窗口句柄, 后续和游戏大厅交互时需用到
    WGameHelperFlash.token = tResult["token"] or ""--string用户登录token
    WGameHelperFlash.source = tResult["source"] or ""--string安装来源
    WGameHelperFlash.serverid = tResult["serverid"] or ""--string游戏区服
    WGameHelperFlash.fcext = tResult["fcext"] or ""--string扩展参数
    return true
end

--@brief    将openId等信息保存到userdata函数
function WGameHelperFlash:record_cmd_to_userData()
    if not GameHelper_Flash then return end
    print("WGameHelperFlash:record_cmd_to_userData")
    GameHelper_Flash:getInstance():record_cmd_to_userData()
end

--@brief    确认退出游戏函数 - 用于退出游戏二次确认框点击确定
function WGameHelperFlash:on_ready_to_exit_game()
    if not GameHelper_Flash then return end
    CCLuaLog("WGameHelperFlash:on_ready_to_exit_game")
    -- if g_bisloadingres then
    --     if WGameHelperFlash.m_nScheduleID > 0 then 
    --         CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelperFlash.m_nScheduleID)
    --         WGameHelperFlash.m_nScheduleID = 0
    --     end 
    --     if WGameHelperFlash.msgBoxElement and WGameHelperFlash.msgBoxLuaObj then
    --         WGameHelperFlash.msgBoxLuaObj:onConfirm()--再玩一会
    --     end
    --     --WGameHelperFlash:on_sure_to_exit_game()
    --     return
    -- end
    if CacheCenter and CacheCenter:getPlayerInfo() then
        CCLuaLog("WGameHelperFlash:on_ready_to_exit_game 1")
        if WndKingEndTip and WndKingEndTip.showInterface then
            WndKingEndTip:showInterface()
        end
    else        
        CCLuaLog("WGameHelperFlash:on_ready_to_exit_game 2")
        if WGameHelperFlash.m_nTimeout > 0 then
            return
        end
        if MsgBoxManager then
            --WGameHelperFlash.m_nTimeout = 5
            local tMsgId, tMsg = MsgBoxManager:showConfirmCancelBox("", WGameHelperFlash, WGameHelperFlash.on_sure_to_exit_game, MSGBOXLEVEL_HIGH,nil)
            if tMsg and tMsgId then
                --tMsg.nTimeout = 5
                CCLuaLog("WGameHelperFlash:on_ready_to_exit_game 2-1")
                WGameHelperFlash.m_tMsg = tMsg
                WGameHelperFlash.m_tMsgId = tMsgId

                WGameHelperFlash.m_nTimeout = 5
                WGameHelperFlash.msgBoxElement = nil
                WGameHelperFlash.msgBoxLuaObj = nil
                if WGameHelperFlash.m_nScheduleID > 0 then 
                    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelperFlash.m_nScheduleID)
                    WGameHelperFlash.m_nScheduleID = 0
                end 
                WGameHelperFlash.m_nScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WGameHelperFlash.scheduleFunc, 0, false)
            end
        end
    end
end

--@brief
function WGameHelperFlash:scheduleFunc()    
    print("WGameHelperFlash:scheduleFunc", WGameHelperFlash.m_nTimeout)
    WGameHelperFlash.msgBoxElement = MsgBoxManager.m_tMsgBoxElementList[WGameHelperFlash.m_tMsg]
    WGameHelperFlash.msgBoxLuaObj = MsgBoxManager.m_tMsgBoxLuaObjList[WGameHelperFlash.m_tMsg]
    if WGameHelperFlash.msgBoxElement and WGameHelperFlash.msgBoxLuaObj then
        print("WGameHelperFlash:scheduleFunc.....ok")
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelperFlash.m_nScheduleID)

        local txtCancel = GetElement(WGameHelperFlash.msgBoxElement, "txtCancel_WndConfirmCancelBox", WZUILabelTTF)
        local txtConfirm = GetElement(WGameHelperFlash.msgBoxElement, "txtConfirm_WndConfirmCancelBox", WZUILabelTTF)
        if txtCancel then
            print("WGameHelperFlash:scheduleFunc.....ook 1", txtCancel:getText())
            txtCancel:setTextKey("")
            txtCancel:setText(LocalStrings.LZTQ_TEXT1[12])
        end
        if txtConfirm then
            print("WGameHelperFlash:scheduleFunc.....ook 2", txtConfirm:getText())
            txtConfirm:setTextKey("")
            txtConfirm:setText(LocalStrings.LZTQ_TEXT1[11])
        end
        local txtContent = GetElement(WGameHelperFlash.msgBoxElement, "txtContent_WndConfirmCancelBox", WZUILabelTTF)        
        if txtContent then
            print("WGameHelperFlash:scheduleFunc.....ook 2", txtContent:getText())
            --txtContent:setTextKey("")
            txtContent:setText(string.format(LocalStrings.LZTQ_TEXT1[14], WGameHelperFlash.m_nTimeout))
        end
        WGameHelperFlash.m_nScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WGameHelperFlash.scheduleFunc_1, 1, false)
        -- if WGameHelperFlash.m_nTimeout <= 0 then
        --     WGameHelperFlash.msgBoxLuaObj:onCancel()
        --     CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nScheduleID)
        -- end
    end
    --WGameHelperFlash.m_nTimeout = WGameHelperFlash.m_nTimeout - 1
end

function WGameHelperFlash:scheduleFunc_1()    
    print("WGameHelperFlash:scheduleFunc_1", WGameHelperFlash.m_nTimeout)
    WGameHelperFlash.m_nTimeout = WGameHelperFlash.m_nTimeout - 1
    local txtContent = GetElement(WGameHelperFlash.msgBoxElement, "txtContent_WndConfirmCancelBox", WZUILabelTTF)        
    if txtContent then
        print("WGameHelperFlash:scheduleFunc_1.....ook 2", txtContent:getText())
        --txtContent:setTextKey("")
        txtContent:setText(string.format(LocalStrings.LZTQ_TEXT1[14], WGameHelperFlash.m_nTimeout))
    end
    if WGameHelperFlash.m_nTimeout <= 0 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelperFlash.m_nScheduleID)
        WGameHelperFlash.msgBoxLuaObj:onConfirm()--再玩一会
    end
end

function WGameHelperFlash:_unInit()
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelperFlash.m_nScheduleID)
    WGameHelperFlash.m_tMsg = nil
    WGameHelperFlash.m_tMsgId = nil    
    WGameHelperFlash.msgBoxElement = nil
    WGameHelperFlash.msgBoxLuaObj = nil
    WGameHelperFlash.m_nTimeout = -1
    WGameHelperFlash.m_nScheduleID = 0
    if WGameHelperFlash.m_nScheduleID_1 > 0 then 
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelperFlash.m_nScheduleID_1)
        WGameHelperFlash.m_nScheduleID_1 = 0
    end
end

--@brief    确认退出游戏函数 - 用于退出游戏二次确认框点击确定
function WGameHelperFlash:on_sure_to_exit_game(nId, nResType)
    if not GameHelper_Flash then return end
    print("WGameHelperFlash:on_sure_to_exit_game", nId, nResType)
    --销毁资源更新进程
    --print("WGameHelperFlash:on_sure_to_exit_game 111")
    --WZUpdateManager:getInstance():update("",WndDownLoad)
    --WZUpdateManager:getInstance():extend("",WndDownLoad)
    --print("WGameHelperFlash:on_sure_to_exit_game 222")
    WGameHelperFlash:_unInit()
    --清除音频
    -- if  AudioManager then
    --     print("WGameHelperFlash:_unInit ==> AudioManager:destoryAll()")
    --     AudioManager:destoryAll()
    -- end
    if nResType and nResType == MSGBOXRESTYPE_CONFIRM then
        print("WGameHelperFlash:on_sure_to_exit_game 1")
        return
    end
    if GameHelper_Flash and GameHelper_Flash.getInstance and GameHelper_Flash.on_sure_to_exit_game then
        if WGameHelperFlash.m_nScheduleID > 0 then 
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelperFlash.m_nScheduleID)
            WGameHelperFlash.m_nScheduleID = 0
        end 
        WGameHelperFlash.m_nScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WGameHelperFlash.on_sure_to_exit_game_delay, 1, false)
        --GameHelper_Flash:getInstance():on_sure_to_exit_game()
    end
end

--@brief    确认退出游戏函数 - 用于退出游戏二次确认框点击确定
function WGameHelperFlash:on_sure_to_exit_game_delay()
    if not GameHelper_Flash then return end
    print("WGameHelperFlash:on_sure_to_exit_game_delay")
    if WGameHelperFlash.m_nScheduleID > 0 then 
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelperFlash.m_nScheduleID)
        WGameHelperFlash.m_nScheduleID = 0
    end 
    if WZUpdateManager and WZUpdateManager.forceClose then
        print("WGameHelperFlash:on_sure_to_exit_game WZUpdateManager forceClose")
        WZUpdateManager:getInstance():forceClose()
    end
    --local bExist = WZFileUtil:isFileExist(path)
    local sWritablePath = CCFileUtils:sharedFileUtils():getWritablePath()--.. "ddd2_main.exe"
    if sWritablePath then
        print("WGameHelperFlash:on_sure_to_exit_game_delay fileUtils:getWritablePath()")
        local cmd = sWritablePath .. "ddd2_main.exe"
        local param = "{\\\"type\\\":1}"
        print("WGameHelperFlash:on_sure_to_exit_game_delay", cmd, param)
        if not WGameHelperUtil then
            WZResourceManager:getInstance():executeLuaFile("global/WGameHelperUtil.lua")
        end
        if WGameHelperUtil and WGameHelperUtil.executeCommand then
            print("WGameHelperFlash -> WGameHelperUtil.executeCommand")
            WGameHelperUtil:executeCommand(cmd, param, 0, 1)
        end
    end
    GameHelper_Flash:getInstance():on_sure_to_exit_game()
end

--@brief    qq大厅发起支付函数
--@param  玩家信息包括订单token
function WGameHelperFlash:on_start_purchase(jsonArg)
    if not GameHelper_Flash then return end
    print("WGameHelperFlash:on_start_purchase", jsonArg)
    --GameHelper_Flash:getInstance():on_start_purchase(jsonArg)
    --去下载二维码图片显示给玩家扫码付费
    local sJson = json.decode(jsonArg)
    if not sJson then return end
    local url_qrCode = sJson["orderNum"]
    if not url_qrCode or url_qrCode == "" then return end    
    print("WGameHelperFlash:on_start_purchase orderNum=", url_qrCode)
    local url = url_qrCode--;"https://game.flash.cn/order/qrcode?gkey=ddd2&server_id=888&uid=1000235170&callback_info=640afb2dec043f00494eb0c0&sign=b253c651baf4e9b16b37bfc88d023ca2&money=0&size=200&type=1"--url_qrCode
    local path = "qrcode_flash.png"--CCFileUtils:sharedFileUtils():getTmpWritablePath().."qrcode_flash.png"

    if WZUISystem and WZUISystem.getSecondMultiThreadSystem then
        print("WGameHelperFlash:on_start_purchase exist secondMultiThreadSystem")
        local sec_multiThread = WZUISystem:getInstance():getSecondMultiThreadSystem()
        local sec_downloadTask = WZHTTPFileLuaTask:create(10, url, path, WGameHelperFlash.downloadQrcodePNGCallback, WGameHelperFlash)
        sec_downloadTask:setLevel(10)
        sec_multiThread:addDownloadTaskInFront(sec_downloadTask)
        return
    end
    local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
    local downloadTask = WZHTTPFileLuaTask:create(10, url, path, WGameHelperFlash.downloadQrcodePNGCallback, WGameHelperFlash)
    downloadTask:setLevel(10)
    multiThread:addDownloadTaskInFront(downloadTask)
end

function WGameHelperFlash:downloadQrcodePNGCallback(taskId, path, totalSize, nowSize, finish, failed)
    print("WGameHelperFlash:downloadQrcodePNGCallback", taskId, path, totalSize, nowSize, finish, failed)
    if finish then
        print("WGameHelperFlash:downloadQrcodePNGCallback success:", path)
        if WndImageTips then
            WndImageTips:show(path, [[<T C="127,70,26" S="18">请使用手机支付宝或微信扫描二维码支付</T>]])
        end
    end
    WndVip:closeLoadingUI()
end

--@brief    qq大厅发起支付函数
--@param  玩家信息包括订单token
function WGameHelperFlash:on_start_buy_vip(jsonArg)
    if not GameHelper_Flash then return end
    print("WGameHelperFlash:on_start_buy_vip", jsonArg)
    --GameHelper_Flash:getInstance():on_start_buy_vip(json.encode(_payParam))
end

--@brief    qq大厅设置鼠标
--@param  文件名
function WGameHelperFlash:set_game_cursor(fileName)
    if not GameHelper_Flash then return end
    print("WGameHelperFlash:set_game_cursor", fileName)
    GameHelper_Flash:getInstance():set_game_cursor(fileName)
end

--@brief    qq大厅游戏前台显示
function WGameHelperFlash:char_To_UTF8(strSrc)
    if not GameHelper_Flash then return end
    print("WGameHelperFlash:char_To_UTF8", strSrc)
    local val = GameHelper_Flash:getInstance():char_To_UTF8(strSrc)
    print("WGameHelperFlash:char_To_UTF8-1", val)
    return val
end

--@brief    Flash游戏 - token登录 - 进游戏前请求https://game.flash.cn/client/fc-token-login
function WGameHelperFlash:ChannelLoginVerify()
    print("WGameHelperFlash:ChannelLoginVerify:")
    local data = {}
    local channelId = ProjConfig:getChannelId()
    local sPostData = ""
    if WGameHelperFlash.gkey and WGameHelperFlash.gkey ~= "" then
        sPostData = sPostData.."gkey="..WGameHelperFlash.gkey
    end
    if WGameHelperFlash.token and WGameHelperFlash.token ~= "" then
        sPostData = sPostData.."&token="..WGameHelperFlash.token
    end
    if WGameHelperFlash.source and WGameHelperFlash.source ~= "" then
        sPostData = sPostData.."&source="..WGameHelperFlash.source
    end
    if WGameHelperFlash.fcext and WGameHelperFlash.fcext ~= "" then
        sPostData = sPostData.."&fcext="..WGameHelperFlash.fcext
    end
    print("WGameHelperFlash:ChannelLoginVerify sPostData:", sPostData)
    --GET
    local url = WGameHelperFlash.loginUrl .. "?" .. sPostData
    local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
    local downLoadInfoTask = WZHTTPInfoLuaTask:create(1, url, WGameHelperFlash.loginCallback_GET, WGameHelperFlash)    
    downLoadInfoTask:setLevel(10)
    mulThreadSystem:addDownloadTask(downLoadInfoTask)
end

function WGameHelperFlash:loginCallback_GET(nTaskId, sData, bFinished, bFailed)
    print("WGameHelperFlash:loginCallback_GET sResponse:", nTaskId,sData,bFinished,bFailed)
    if bFinished then --成功
        print("WGameHelperFlash:loginCallback1111 sResponse:", sData)
        local strArray = SplitStringWithSeparator(sData,"\n")
        local sResponse  = json.decode(strArray[#strArray])
        print("WGameHelperFlash:loginCallback2222 sResponse:", Serialize(sResponse))
        if not sResponse or sResponse == "" then return end
        local status = tonumber(sResponse["status"]) or 0
        local message = sResponse["message"]
        local data = sResponse["data"]
        if status ~= 200 then
            print("WGameHelperFlash:loginCallback2222 status:", status)
            MsgBoxManager:showTipBox(message, 5)
            --return
        end
        if data then 
            print("WGameHelperFlash:loginCallback2222 data:", data)
            WGameHelperFlash.uid = sResponse["data"]["uid"]
            WGameHelperFlash.platform = sResponse["data"]["platform"]
            WGameHelperFlash.server_id = sResponse["data"]["server_id"]
            WGameHelperFlash.is_adult = sResponse["data"]["is_adult"]
            WGameHelperFlash.vip_level = sResponse["data"]["vip_level"]
            WGameHelperFlash.callback_info = sResponse["data"]["callback_info"]
        end
        if WndLoginSelect.m_root and WndLoginSelect.FlashHallLogin then
            WndLoginSelect:FlashHallLogin()
        end
    elseif bFailed then --失败
         print("WGameHelperFlash:loginCallback4444:",sData)
    end
end

--罗盘日志上报
function WGameHelperFlash:postEventLuopan(actionId)
    print("WGameHelperFlash:postEventLuopan:", actionId)
    local playerInfo = CacheCenter:getPlayerInfo()
    if not playerInfo then return end
    local onlineTime = NetManager.m_nServerCurTime - WGameHelperFlash.m_nLoginTime
    print("WGameHelperFlash:postEventLuopan onlineTime:", onlineTime)
    local postData = {}
    local sPostData = json.encode(postData)
    print("WGameHelperFlash:postEventLuopan sPostData:", sPostData)

    local url = WGameHelperFlash.url_luopan
    local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
    local downLoadInfoTask = nil
    downLoadInfoTask = WZHTTPPostDataLuaTask:create(10, url,sPostData,WGameHelperFlash.luopanCallback, WGameHelperFlash)
    if downLoadInfoTask.setHeader then
        -- signature为（消息+密钥）然后MD5后的字符串（+为连接的意思，字符串直接拼接在一起，消息指的是body的整个
        -- json串），后台也会做这个操作去验证字符串是否一致，不一致会丢弃。其中密钥会私下提供，正式环境和测试环境
        -- 密钥不同。
        --local signature = WZDeviceInfo:md5Generate(sPostData..WGameHelperFlash.key_luopan)
        print("WGameHelperFlash:postEventLuopan signature:", signature)
        mulThreadSystem:addDownloadTask(downLoadInfoTask)
    else
        print("NNNNNNNNNNNNNN")
    end 
end

function WGameHelperFlash:luopanCallback(nTaskId, sResponse, nTotalSize, nNowSize, bFinished, bFailed)
    --print("WGameHelperFlash:luopanCallback sResponse:", nTaskId,sResponse,nTotalSize,nNowSize,bFinished,bFailed)
    if bFinished then --成功
        print("WGameHelperFlash:luopanCallback1111 sResponse:", sResponse)
        local strArray = SplitStringWithSeparator(sResponse,"\n")
        local str1 = strArray[#strArray]
        if #strArray <= 2 then
            return
        end
        print("WGameHelperFlash:luopanCallback2222 str1:", str1)
    elseif bFailed then --失败
         print("WGameHelperFlash:luopanCallback4444:",sResponse)
    end
end