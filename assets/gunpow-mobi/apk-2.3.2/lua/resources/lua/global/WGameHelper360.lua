--WGameHelper360.lua
--@brief    语言实现类
--@date     2017/03/22
--@author   zhangming
--@note     语言实现类

WGameHelper360 = {
    msgBoxElement = nil,
    msgBoxLuaObj = nil,
    m_tMsg = nil,
    m_tMsgId = nil,
    m_nScheduleID = -1,
    m_nScheduleID_1 = -1,
    m_nTimeout = -1,
    m_nLoginTime = 0,

    gkey = "ddd2pc",--游戏缩写，对接时双方商定
    gmurl = "http://open.svc.360-game.net/index.php?do=login&platform=wan",
    link ="0fb90de8838463d642cbfc4e9cf26e333U7qihU62VCXsueG4DvZyrk9kIjcOdhY",--3U
    appid = "200000017",
    gid = "1333",

    uid = "",--360用户登录的唯一标识
    auth_key = "",--登录请求返回的由CP方产生的验证key
    extraInfo = "",--登录请求返回的extraInfo值，客户端会在后面追加,360GameContext=OpenClientGameContext,ver=5
    auth_result = "",--[[实名验证信息回调结果//返回值说明
                        //0：未实名(包括没有记录,未填写实名信息并关闭弹窗)
                        //1：已实名但未成年
                        //2：已实名并已成年
                        //3：已实名未成年不可玩,国家法规限制时长,sdk会弹框提示到时长关闭弹框后返回值
                        //返回0和3的时候游戏不可玩,需要cp关闭游戏窗口并退出游戏]]

    platform = "",--平台ID 固定值 fc
    server_id = "",--区服ID    
    vip_level = "",--ip等级

    loginUrl = "",
    payUrl = "http://pay.wan.360.cn/mg_order.html?",
    --payUrl = "http://pay.wan.360.cn?",
    checkPlayerIsExistUrl = "http://123.207.87.19:8111/GetPlayerIsExitsServlet?",
    login_key = "UBskO1CWYLpAn73RPUX24LNbZB4AyUo73U7qihU62VCXsueG4DvZyrk9kIjcOdhY",--73
    logUrl = "http://dd.mgame.360.cn/t/gameinfo/log?",
}

--@brief    initSDK函数
--@param  appkey, appid组成的json
function WGameHelper360:init(jsonArg)
    if not GameHelper_360 then return end
    print("WGameHelper360:init", jsonArg)
    local params = {}
    if jsonArg then
        params = json.decode(jsonArg)
    end    
    local sJson = json.encode(params)
    --print("WGameHelper360:init", sJson)
    GameHelper_360:getInstance():init(sJson)
    --WGameHelper360:initData()
    WGameHelper360:set_game_cursor("mou_cur")
    if WZResourceManager then
        print("WGameHelper360:init executeLuaFile")
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
function WGameHelper360:initCallback(jsonArg)
    print("WGameHelper360:initCallback", jsonArg)
    if not GameHelper_360 then return end
    local tResult = json.decode(jsonArg)
    if not tResult then return end
    WGameHelper360.m_nLoginTime = os.time()
    WGameHelper360.uid = tResult["uid"] or ""--360用户登录的唯一标识
    WGameHelper360.auth_key = tResult["auth_key"] or ""--登录请求返回的由CP方产生的验证key
    WGameHelper360.auth_result = tResult["auth_result"] or ""--[[实名验证信息回调结果//返回值说明
                        //0：未实名(包括没有记录,未填写实名信息并关闭弹窗)
                        //1：已实名但未成年
                        //2：已实名并已成年
                        //3：已实名未成年不可玩,国家法规限制时长,sdk会弹框提示到时长关闭弹框后返回值
                        //返回0和3的时候游戏不可玩,需要cp关闭游戏窗口并退出游戏]]
    WGameHelper360.extraInfo = tResult["extraInfo"] or ""--登录请求返回的extraInfo值，客户端会在后面追加,360GameContext=OpenClientGameContext,ver=5
    --print("WGameHelper360:initCallback", Serialize(WGameHelper360))
    local n_adult = tonumber(WGameHelper360.auth_result)
    print("WGameHelper360:initCallback n_adult=", n_adult)
    if n_adult == 0 or n_adult == 3 then
        print("WGameHelper360:initCallback ==> is not adult, will close game.")
        WGameHelper360:on_sure_to_exit_game_delay()
    end
    return true
end

--@brief    将openId等信息保存到userdata函数
function WGameHelper360:record_cmd_to_userData()
    if not GameHelper_360 then return end
    print("WGameHelper360:record_cmd_to_userData")
    GameHelper_360:getInstance():record_cmd_to_userData()
end

--@brief    确认退出游戏函数 - 用于退出游戏二次确认框点击确定
function WGameHelper360:on_ready_to_exit_game()
    if not GameHelper_360 then return end
    CCLuaLog("WGameHelper360:on_ready_to_exit_game")
    -- if g_bisloadingres then
    --     if WGameHelper360.m_nScheduleID > 0 then 
    --         CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelper360.m_nScheduleID)
    --         WGameHelper360.m_nScheduleID = 0
    --     end 
    --     if WGameHelper360.msgBoxElement and WGameHelper360.msgBoxLuaObj then
    --         WGameHelper360.msgBoxLuaObj:onConfirm()--再玩一会
    --     end
    --     --WGameHelper360:on_sure_to_exit_game()
    --     return
    -- end
    if CacheCenter and CacheCenter:getPlayerInfo() then
        CCLuaLog("WGameHelper360:on_ready_to_exit_game 1")
        if WndKingEndTip and WndKingEndTip.showInterface then
            WndKingEndTip:showInterface()
        end
    else        
        CCLuaLog("WGameHelper360:on_ready_to_exit_game 2")
        if WGameHelper360.m_nTimeout > 0 then
            return
        end
        if MsgBoxManager then
            --WGameHelper360.m_nTimeout = 5
            local tMsgId, tMsg = MsgBoxManager:showConfirmCancelBox("", WGameHelper360, WGameHelper360.on_sure_to_exit_game, MSGBOXLEVEL_HIGH,nil)
            if tMsg and tMsgId then
                --tMsg.nTimeout = 5
                CCLuaLog("WGameHelper360:on_ready_to_exit_game 2-1")
                WGameHelper360.m_tMsg = tMsg
                WGameHelper360.m_tMsgId = tMsgId

                WGameHelper360.m_nTimeout = 5
                WGameHelper360.msgBoxElement = nil
                WGameHelper360.msgBoxLuaObj = nil
                if WGameHelper360.m_nScheduleID > 0 then 
                    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelper360.m_nScheduleID)
                    WGameHelper360.m_nScheduleID = 0
                end 
                WGameHelper360.m_nScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WGameHelper360.scheduleFunc, 0, false)
            end
        end
    end
end

--@brief
function WGameHelper360:scheduleFunc()    
    print("WGameHelper360:scheduleFunc", WGameHelper360.m_nTimeout)
    WGameHelper360.msgBoxElement = MsgBoxManager.m_tMsgBoxElementList[WGameHelper360.m_tMsg]
    WGameHelper360.msgBoxLuaObj = MsgBoxManager.m_tMsgBoxLuaObjList[WGameHelper360.m_tMsg]
    if WGameHelper360.msgBoxElement and WGameHelper360.msgBoxLuaObj then
        print("WGameHelper360:scheduleFunc.....ok")
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelper360.m_nScheduleID)

        local txtCancel = GetElement(WGameHelper360.msgBoxElement, "txtCancel_WndConfirmCancelBox", WZUILabelTTF)
        local txtConfirm = GetElement(WGameHelper360.msgBoxElement, "txtConfirm_WndConfirmCancelBox", WZUILabelTTF)
        if txtCancel then
            print("WGameHelper360:scheduleFunc.....ook 1", txtCancel:getText())
            txtCancel:setTextKey("")
            txtCancel:setText(LocalStrings.LZTQ_TEXT1[12])
        end
        if txtConfirm then
            print("WGameHelper360:scheduleFunc.....ook 2", txtConfirm:getText())
            txtConfirm:setTextKey("")
            txtConfirm:setText(LocalStrings.LZTQ_TEXT1[11])
        end
        local txtContent = GetElement(WGameHelper360.msgBoxElement, "txtContent_WndConfirmCancelBox", WZUILabelTTF)        
        if txtContent then
            print("WGameHelper360:scheduleFunc.....ook 2", txtContent:getText())
            --txtContent:setTextKey("")
            txtContent:setText(string.format(LocalStrings.LZTQ_TEXT1[14], WGameHelper360.m_nTimeout))
        end
        WGameHelper360.m_nScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WGameHelper360.scheduleFunc_1, 1, false)
        -- if WGameHelper360.m_nTimeout <= 0 then
        --     WGameHelper360.msgBoxLuaObj:onCancel()
        --     CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nScheduleID)
        -- end
    end
    --WGameHelper360.m_nTimeout = WGameHelper360.m_nTimeout - 1
end

function WGameHelper360:scheduleFunc_1()    
    print("WGameHelper360:scheduleFunc_1", WGameHelper360.m_nTimeout)
    WGameHelper360.m_nTimeout = WGameHelper360.m_nTimeout - 1
    local txtContent = GetElement(WGameHelper360.msgBoxElement, "txtContent_WndConfirmCancelBox", WZUILabelTTF)        
    if txtContent then
        print("WGameHelper360:scheduleFunc_1.....ook 2", txtContent:getText())
        --txtContent:setTextKey("")
        txtContent:setText(string.format(LocalStrings.LZTQ_TEXT1[14], WGameHelper360.m_nTimeout))
    end
    if WGameHelper360.m_nTimeout <= 0 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelper360.m_nScheduleID)
        WGameHelper360.msgBoxLuaObj:onConfirm()--再玩一会
    end
end

function WGameHelper360:_unInit()
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelper360.m_nScheduleID)
    WGameHelper360.m_tMsg = nil
    WGameHelper360.m_tMsgId = nil    
    WGameHelper360.msgBoxElement = nil
    WGameHelper360.msgBoxLuaObj = nil
    WGameHelper360.m_nTimeout = -1
    WGameHelper360.m_nScheduleID = 0
    if WGameHelper360.m_nScheduleID_1 > 0 then 
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelper360.m_nScheduleID_1)
        WGameHelper360.m_nScheduleID_1 = 0
    end
end

--@brief    确认退出游戏函数 - 用于退出游戏二次确认框点击确定
function WGameHelper360:on_sure_to_exit_game(nId, nResType)
    if not GameHelper_360 then return end
    print("WGameHelper360:on_sure_to_exit_game", nId, nResType)
    --销毁资源更新进程
    --print("WGameHelper360:on_sure_to_exit_game 111")
    --WZUpdateManager:getInstance():update("",WndDownLoad)
    --WZUpdateManager:getInstance():extend("",WndDownLoad)
    --print("WGameHelper360:on_sure_to_exit_game 222")
    WGameHelper360:_unInit()
    --清除音频
    -- if  AudioManager then
    --     print("WGameHelper360:_unInit ==> AudioManager:destoryAll()")
    --     AudioManager:destoryAll()
    -- end
    if nResType and nResType == MSGBOXRESTYPE_CONFIRM then
        print("WGameHelper360:on_sure_to_exit_game 1")
        return
    end
    if GameHelper_360 and GameHelper_360.getInstance and GameHelper_360.on_sure_to_exit_game then        
        if WGameHelper360.m_nScheduleID > 0 then 
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelper360.m_nScheduleID)
            WGameHelper360.m_nScheduleID = 0
        end 
        WGameHelper360.m_nScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WGameHelper360.on_sure_to_exit_game_delay, 2, false)
        --GameHelper_360:getInstance():on_sure_to_exit_game()
    end
end

--@brief    确认退出游戏函数 - 用于退出游戏二次确认框点击确定
function WGameHelper360:on_sure_to_exit_game_delay()
    if not GameHelper_360 then return end
    print("WGameHelper360:on_sure_to_exit_game_delay")
    if WGameHelper360.m_nScheduleID > 0 then 
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGameHelper360.m_nScheduleID)
        WGameHelper360.m_nScheduleID = 0
    end 
    if WZUpdateManager and WZUpdateManager.forceClose then
        print("WGameHelper360:on_sure_to_exit_game WZUpdateManager forceClose")
        WZUpdateManager:getInstance():forceClose()
    end
    GameHelper_360:getInstance():on_sure_to_exit_game()
end

--@brief    qq大厅发起支付函数
--@param  玩家信息包括订单token
function WGameHelper360:on_start_purchase(jsonArg)
    if not GameHelper_360 then return end
    if not WGameHelper360.uid or WGameHelper360.uid == "" then 
        print("WGameHelper360:on_start_purchase  => uid nil.")
        return 
    end
    print("WGameHelper360:on_start_purchase", jsonArg)
    --GameHelper_360:getInstance():on_start_purchase(jsonArg)
    --去下载二维码图片显示给玩家扫码付费
    local sJson = json.decode(jsonArg)
    if not sJson then return end
    local qid = WGameHelper360.uid
    local gkey = WGameHelper360.gkey   
    local skey = "S"..sJson["serverId"] 
    local item_id = sJson["payCode"]
    local amount = math.ceil(tonumber(sJson["price"]))
    local md5 = item_id..amount..qid
    local sign = string.lower(WZDeviceInfo:md5Generate(md5))
    local orderToken = sJson["orderNum"]
    --[[
        exts = base_encode(json_encode($payinfo))
        payinfo = array("item_id":"abc","amount":88,"sign":"md5($item_id.$amount.$qid)","xxx":"yyy") //php语法.是拼接符, abc.88.123456=abc88123456

        //item_id：为本次支付的唯一标识，由游戏内生成，支付成功后，此信息会通过回调接口传回游戏，游戏内凭借item_id为玩家发放对应商品,  不能为空或0
        //amount：本次支付金额，正整数单位元
        //sign：签名（小写32位md5值），用于校验当前支付URL合法性。$item_id和$amount即为以上两个参数，$qid为用户在360平台登录的uid，由登录接口传入游戏内
        //
        //base_encode和base_decode函数源码如下：
        static function base_encode($str) {
                $src  = array("/","+","=");
                $dist = array("_a","_b","_c");
                $old  = base64_encode($str);
                $new  = str_replace($src,$dist,$old);
                return $new;
        }

        static function base_decode($str) {
                $src = array("_a","_b","_c");
                $dist  = array("/","+","=");
                $old  = str_replace($src,$dist,$str);
                $new = base64_decode($old);
                return $new;
        }

        //payinfo json格式化后正确例子：
        //假设 item_id="abc", amount=6, qid="123456"
        //sign=md5("abc6123456")=8572aa5b96ed855fe477ad5e2b06ee59
        payinfo={"amount":6,"item_id":"abc","sign":"8572aa5b96ed855fe477ad5e2b06ee59"} //qid假设是123456，实际计算以登录用户uid为准//amount=6 json整数类型，无引号
        //exts计算
        //exts = base_encode(payinfo) = eyJhbW91bnQiOjYsIml0ZW1faWQiOiJhYmMiLCJzaWduIjoiODU3MmFhNWI5NmVkODU1ZmU0NzdhZDVlMmIwNmVlNTkifQ_c_c
    ]]
    --测试数据
    -- local md5_temp = "abc".."6".."123456"
    -- local sign_temp = string.lower(WZDeviceInfo:md5Generate(md5_temp))
    --  local exts_temp = {}
    -- exts_temp["amount"] = 6
    -- exts_temp["item_id"] = "abc"
    -- exts_temp["sign"] = sign_temp
    -- exts_temp = '{"amount":6,"item_id":"abc","sign":"8572aa5b96ed855fe477ad5e2b06ee59"}'
    -- --exts_temp = json.encode(exts_temp)
    -- exts_temp = WGameHelperUtil:get_encode_base64_nolimit(exts_temp)    
    -- exts_temp = string.gsub(exts_temp, "/", "_a")
    -- exts_temp = string.gsub(exts_temp, "+", "_b")
    -- exts_temp = string.gsub(exts_temp, "=", "_c")
    -- print("WGameHelper360:on_start_purchase exts_temp=", exts_temp)
    -- local url_temp = WGameHelper360.payUrl.."gkey="..gkey.."&skey="..skey.."&exts="..exts_temp
    -- print("WGameHelper360:on_start_purchase url_temp=", url_temp)
    -- local exts_temp_1 = ""
    -- exts_temp_1 = "{\"amount\":6,\"item_id\":\"abc\",\"sign\":\"8572aa5b96ed855fe477ad5e2b06ee59\"}"
    -- exts_temp_1 = WGameHelperUtil:get_encode_base64(exts_temp_1)
    -- exts_temp_1 = string.gsub(exts_temp_1, "/", "_a")
    -- exts_temp_1 = string.gsub(exts_temp_1, "+", "_b")
    -- exts_temp_1 = string.gsub(exts_temp_1, "=", "_c")
    -- print("WGameHelper360:on_start_purchase exts_temp=", exts_temp_1)
    -- local url_temp = WGameHelper360.payUrl.."gkey="..gkey.."&skey="..skey.."&exts="..exts_temp_1
    -- print("WGameHelper360:on_start_purchase url_temp=", exts_temp_1)
    --正式数据
    local exts = {}
    exts["item_id"] = item_id
    exts["amount"] = amount
    exts["sign"] = sign
    exts["orderToken"] = orderToken
    exts = json.encode(exts)
    --exts = [["{"amount":6,"item_id":"abc","sign":"8572aa5b96ed855fe477ad5e2b06ee59"}"]]
    --exts = '{"amount":' .. amount .. ',"item_id":"' .. item_id .. '","orderToken":"' .. orderToken .. '","sign":"' .. sign .. '"}'
    --exts = '{"amount":' .. amount .. ',"item_id":"' .. item_id .. '","sign":"' .. sign .. '"}'
    print("WGameHelper360:on_start_purchase exts=", exts)
    exts = WGameHelperUtil:get_encode_base64_nolimit(exts)
    exts = string.gsub(exts, "/", "_a")
    exts = string.gsub(exts, "+", "_b")
    exts = string.gsub(exts, "=", "_c")
    print("WGameHelper360:on_start_purchase exts=1", exts)

    local url = WGameHelper360.payUrl.."gkey="..gkey.."&skey="..skey.."&exts="..exts
    --local url_encode = WGameHelperUtil:get_url_encode(url)
    print("WGameHelper360:on_start_purchase url=", url)
    if GameHelper_360.on_start_purchase_360Url then
        --WGameHelper360:postEventLuopan()
        GameHelper_360:getInstance():on_start_purchase_360Url(url)
    end
end

--@brief    qq大厅发起支付函数
--@param  玩家信息包括订单token
function WGameHelper360:on_start_buy_vip(jsonArg)
    if not GameHelper_360 then return end
    print("WGameHelper360:on_start_buy_vip", jsonArg)
    --GameHelper_360:getInstance():on_start_buy_vip(json.encode(_payParam))
end

--@brief    qq大厅设置鼠标
--@param  文件名
function WGameHelper360:set_game_cursor(fileName)
    if not GameHelper_360 then return end
    print("WGameHelper360:set_game_cursor", fileName)
    GameHelper_360:getInstance():set_game_cursor(fileName)
end

--@brief    qq大厅游戏前台显示
function WGameHelper360:char_To_UTF8(strSrc)
    if not GameHelper_360 then return end
    print("WGameHelper360:char_To_UTF8", strSrc)
    local val = GameHelper_360:getInstance():char_To_UTF8(strSrc)
    print("WGameHelper360:char_To_UTF8-1", val)
    return val
end

--@brief    Flash游戏 - token登录 - 进游戏前请求https://game.flash.cn/client/fc-token-login
function WGameHelper360:ChannelLoginVerify()
    print("WGameHelper360:ChannelLoginVerify:")
    local data = {}
    local channelId = ProjConfig:getChannelId()
    local sPostData = ""
    print("WGameHelper360:ChannelLoginVerify sPostData:", sPostData)
    --GET
    -- local url = WGameHelper360.loginUrl .. "?" .. sPostData
    -- local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
    -- local downLoadInfoTask = WZHTTPInfoLuaTask:create(1, url, WGameHelper360.loginCallback_GET, WGameHelper360)    
    -- downLoadInfoTask:setLevel(10)
    -- mulThreadSystem:addDownloadTask(downLoadInfoTask)
    if not WGameHelper360.uid or WGameHelper360.uid == "" then 
        print("WGameHelper360:ChannelLoginVerify ERROR:uid is null.")
        return 
    end
    if not WGameHelper360.auth_key or WGameHelper360.auth_key == "" then 
        print("WGameHelper360:ChannelLoginVerify ERROR:auth_key is null.")
        --return
    end
    if WndLoginSelect.m_root and WndLoginSelect.Qihoo360HallLogin then
        WndLoginSelect:Qihoo360HallLogin()
    end
end

function WGameHelper360:loginCallback_GET(nTaskId, sData, bFinished, bFailed)
    print("WGameHelper360:loginCallback_GET sResponse:", nTaskId,sData,bFinished,bFailed)
    if bFinished then --成功
        print("WGameHelper360:loginCallback1111 sResponse:", sData)
        local strArray = SplitStringWithSeparator(sData,"\n")
        local sResponse  = json.decode(strArray[#strArray])
        print("WGameHelper360:loginCallback2222 sResponse:", Serialize(sResponse))
        if not sResponse or sResponse == "" then return end
        if WndLoginSelect.m_root and WndLoginSelect.Qihoo360HallLogin then
            WndLoginSelect:Qihoo360HallLogin()
        end
    elseif bFailed then --失败
         print("WGameHelper360:loginCallback4444:",sData)
    end
end

--罗盘日志上报
function WGameHelper360:postEventLuopan(actionId)
    print("WGameHelper360:postEventLuopan:", actionId)
    local playerInfo = CacheCenter:getPlayerInfo()
    if not playerInfo then return end
    -- local postData = {}
    -- local sPostData = json.encode(postData)
    -- print("WGameHelperFlash:postEventLuopan sPostData:", sPostData)
    local url = WGameHelper360.checkPlayerIsExistUrl
    local qid = WGameHelper360.uid
    local server_id = "S" .. IPDhttpServer:getCurServerId()--WGameHelper360.server_id
    local login_key = WGameHelper360.login_key
    local md5 = qid..server_id..login_key
    local sign = string.lower(WZDeviceInfo:md5Generate(md5))
    
    url = url .. "qid=" .. qid .. "&server_id=" .. server_id .. "&sign=" .. sign
    print("WGameHelper360:postEventLuopan sPostData:", qid, server_id, login_key, md5, sign, url)

    local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
    local downLoadInfoTask = WZHTTPInfoLuaTask:create(1, url, WGameHelper360.luopanCallback_GET, WGameHelper360)    
    downLoadInfoTask:setLevel(10)
    mulThreadSystem:addDownloadTask(downLoadInfoTask)
end

function WGameHelper360:luopanCallback_GET(nTaskId, sResponse, bFinished, bFailed)
    print("WGameHelper360:luopanCallback_GET sResponse:", nTaskId,sResponse,bFinished,bFailed)
    if bFinished then --成功
        print("WGameHelper360:luopanCallback1111 sResponse:", sResponse)
        local strArray = SplitStringWithSeparator(sResponse,"\n")
        local str1 = strArray[#strArray]
        if #strArray <= 2 then
            return
        end
        print("WGameHelper360:luopanCallback2222 str1:", str1)
    elseif bFailed then --失败
         print("WGameHelper360:luopanCallback4444:",sResponse)
    end
end

--日志上报
function WGameHelper360:postEvent360(actionId)
    print("WGameHelper360:postEvent360:", actionId)--0:创角 1:登录
    local playerInfo = CacheCenter:getPlayerInfo()
    if not playerInfo then return end
    -- local postData = {}
    -- local sPostData = json.encode(postData)
    -- print("WGameHelperFlash:postEvent360 sPostData:", sPostData)
    --[[
        登录日志:
        interface   varchar(255)    是   值为login
        gname   varchar(255)    是   平台gkey，询问运营人员
        gid int 是   分配给游戏方的游戏id，平台方运营提供
        sid varchar(255)    是   区服id，必须有前缀大写S
        oldsid  varchar(255)    是   第一次合服前用户所处的原始服务器id（如没有合服，oldsid记录当前的服务器id，等同于sid必须填写）
        user    varchar(255)    是   360平台的QID
        roleid  varchar(255)    是   玩家在游戏中创建的角色id，单个平台下roleid唯一
        level   int 是   当前角色等级
        dept    int 是   运营平台id，默认为38
        time    int 是   接口动作发生UTC时间戳，为 1970 年 1 月 1 日 00:00:00到当前时间的秒数
        ip  varchar(255)    是   用户登录ip，ip支持固定IP.若IP比较多，仅支持后一段可为*

        创角日志:
        interface   varchar(255)    是   值为create_role
        gname   varchar(255)    是   平台gkey，询问运营人员
        gid int 是   分配给游戏方的游戏id，平台方运营提供
        sid varchar(255)    是   区服id，必须有前缀大写S
        oldsid  varchar(255)    是   第一次合服前用户所处的原始服务器id（如没有合服，oldsid记录当前的服务器id，等同于sid必须填写）
        user    varchar(255)    是   360平台的QID
        roleid  varchar(255)    是   玩家在游戏中创建的角色id，单个平台下roleid唯一
        rolename    varchar(255)    是   玩家在游戏中创建角色名称
        dept    int 是   运营平台id，默认为38
        time    int 是   接口动作发生UTC时间戳，为 1970 年 1 月 1 日 00:00:00到当前时间的秒数
        channel varchar(255)    是   0
        poster  varchar(255)    是   0
        site    varchar(255)    是   0
        prof    varchar(255)    是   玩家职业数值为职业对应的id标示
        ip  varchar(255)    是   用户登录ip，ip支持固定IP.若IP比较多，仅支持后一段可为*
    ]]
    local url = WGameHelper360.logUrl
    
    --公用
    local interface = "login"
    local gname = WGameHelper360.gkey
    local gid = tonumber(WGameHelper360.gid)
    local sid = "S" .. IPDhttpServer:getCurServerId()
    local oldsid = sid
    local user = WGameHelper360.uid
    local roleid = playerInfo.id
    local dept = 38
    local time = os.time()
    local ip = "0"
    if GlobalGame.g_tPlayerInfo.sClientIp and type(GlobalGame.g_tPlayerInfo.sClientIp) == "string" then
        local nStart, nEnd = string.find(GlobalGame.g_tPlayerInfo.sClientIp, '%.')
        if nStart and nEnd then
            ip = GlobalGame.g_tPlayerInfo.sClientIp
            print("WGameHelper360:postEvent360 sClientIp:", ip, string.find(GlobalGame.g_tPlayerInfo.sClientIp, '%.'))
        end
    end
    --登录日志
    local level = tonumber(playerInfo.level)
    --创角日志
    local rolename = playerInfo.name
    local channel = "0"
    local poster = "0"
    local site = "0"
    local prof = ""..playerInfo.sex

    --gname = WGameHelperUtil:get_url_encode(gname)
    --gid = WGameHelperUtil:get_url_encode(gid)
    --sid = WGameHelperUtil:get_url_encode(sid)
    --oldsid = WGameHelperUtil:get_url_encode(oldsid)
    --user = WGameHelperUtil:get_url_encode(user)
    --roleid = WGameHelperUtil:get_url_encode(roleid)
    --dept = WGameHelperUtil:get_url_encode(dept)
    --time = WGameHelperUtil:get_url_encode(time)
    --ip = WGameHelperUtil:get_url_encode(ip)
    --level = WGameHelperUtil:get_url_encode(level)
    --rolename = WGameHelperUtil:get_url_encode(rolename)
    --channel = WGameHelperUtil:get_url_encode(channel)
    --poster = WGameHelperUtil:get_url_encode(poster)
    --site = WGameHelperUtil:get_url_encode(site)
    --prof = WGameHelperUtil:get_url_encode(prof)

    if actionId == 0 then
        --创角
        interface = "create_role"
        --http://dd.mgame.360.cn/t/gameinfo/log?interface=create_role&gname=xianjie&gid=73&sid=S87&oldsid=S87&user=123456&roleid=0&rolename=aa&dept=38&time=1411468560&ip=127.0.0.1&channel=0&poster=0&site=0&prof=3
        url = url .. 
        "interface=" .. interface .. 
        "&gname=" .. gname .. 
        "&gid=" .. gid .. 
        "&sid=" .. sid .. 
        "&oldsid=" .. oldsid .. 
        "&user=" .. user .. 
        "&roleid=" .. roleid .. 
        "&rolename=" .. rolename .. 
        "&dept=" .. dept .. 
        "&time=" .. time .. 
        "&ip=" .. ip .. 
        "&channel=" .. channel .. 
        "&poster=" .. poster .. 
        "&site=" .. site .. 
        "&prof=" .. prof
    else
        --登录
        interface = "login"
        --http://dd.mgame.360.cn/t/gameinfo/log?interface=login&gname=xianjie&gid=73&sid=S87&oldsid=S87&user=&roleid=0&level=0&dept=38&time=1411468560&ip=127.0.0.1
        url = url .. 
        "interface=" .. interface .. 
        "&gname=" .. gname .. 
        "&gid=" .. gid .. 
        "&sid=" .. sid .. 
        "&oldsid=" .. oldsid .. 
        "&user=" .. user .. 
        "&roleid=" .. roleid .. 
        "&level=" .. level .. 
        "&dept=" .. dept .. 
        "&time=" .. time .. 
        "&ip=" .. ip
    end
    print("WGameHelper360:postEvent360 sPostData:", url)
    if WZLog then
        WZLog("WGameHelper360:postEvent360 sPostData:", url)
    end

    local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
    local downLoadInfoTask = WZHTTPInfoLuaTask:create(1, url, WGameHelper360.postEvent360Callback_GET, WGameHelper360)    
    downLoadInfoTask:setLevel(10)
    mulThreadSystem:addDownloadTask(downLoadInfoTask)
end

function WGameHelper360:postEvent360Callback_GET(nTaskId, sResponse, bFinished, bFailed)
    print("WGameHelper360:postEvent360Callback_GET sResponse:", nTaskId,sResponse,bFinished,bFailed)
    if bFinished then --成功
        print("WGameHelper360:postEvent360Callback_GET1 sResponse:", sResponse)
        if WZLog and WGameHelperUtil and WGameHelperUtil.get_url_decode then
            WZLog("WGameHelper360:postEvent360Callback_GET1 sResponse:", sResponse)
            WZLog("WGameHelper360:postEvent360Callback_GET1 sResponse:", WGameHelperUtil:get_url_decode(sResponse))
        end
        local strArray = SplitStringWithSeparator(sResponse,"\n")
        local str1 = strArray[#strArray]
        if #strArray <= 2 then
            return
        end
        print("WGameHelper360:postEvent360Callback_GET2 str1:", str1)
    elseif bFailed then --失败
         print("WGameHelper360:postEvent360Callback_GET4:",sResponse)
    end
end