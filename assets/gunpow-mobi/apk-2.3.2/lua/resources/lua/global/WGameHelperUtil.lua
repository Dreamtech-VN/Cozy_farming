--WGameHelperUtil.lua
--@brief    语言实现类
--@date     2017/03/22
--@author   zhangming
--@note     语言实现类

WGameHelperUtil = {
}

--@brief    initSDK函数
--@param  appkey, appid组成的json
function WGameHelperUtil:init(jsonArg)
    if not GameHelperUtil then return end
    print("WGameHelperUtil:init", jsonArg)
end

--@brief    initCallback函数
--@param  游戏启动参数组成的json
function WGameHelperUtil:initCallback(jsonArg)
    print("WGameHelperUtil:initCallback", jsonArg)
    if not GameHelperUtil then return end
    return true
end

--@brief    确认退出游戏函数 - 用于退出游戏二次确认框点击确定
function WGameHelperUtil:on_ready_to_exit_game()
    if not GameHelperUtil then return end
    print("WGameHelperUtil:on_ready_to_exit_game")
end

function WGameHelperUtil:_unInit()
end

--@brief    确认退出游戏函数 - 用于退出游戏二次确认框点击确定
function WGameHelperUtil:on_sure_to_exit_game(nId, nResType)
    if not GameHelperUtil then return end
    print("WGameHelperUtil:on_sure_to_exit_game", nId, nResType)
end

--@brief    确认退出游戏函数 - 用于退出游戏二次确认框点击确定
function WGameHelperUtil:on_sure_to_exit_game_delay()
    if not GameHelperUtil then return end
    print("WGameHelperUtil:on_sure_to_exit_game_delay")
    GameHelperUtil:getInstance():on_sure_to_exit_game()
end

--@brief    qq大厅发起支付函数
--@param  玩家信息包括订单token
function WGameHelperUtil:on_start_purchase(jsonArg)
    if not GameHelperUtil then return end
    print("WGameHelperUtil:on_start_purchase", jsonArg)
end

--@brief    qq大厅设置鼠标
--@param  文件名
function WGameHelperUtil:set_game_cursor(fileName)
    if not GameHelperUtil then return end
    print("WGameHelperUtil:set_game_cursor", fileName)
    GameHelperUtil:getInstance():set_game_cursor(fileName)
end

--@brief    qq大厅游戏前台显示
function WGameHelperUtil:char_To_UTF8(strSrc)
    if not GameHelperUtil then return end
    print("WGameHelperUtil:char_To_UTF8", strSrc)
    local val = GameHelperUtil:getInstance():char_To_UTF8(strSrc)
    print("WGameHelperUtil:char_To_UTF8-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WGameHelperUtil:get_url_encode(encode)
    if not GameHelperUtil then return end
    print("WGameHelperUtil:get_url_encode", encode)
    local val = GameHelperUtil:get_url_encode(encode)
    print("WGameHelperUtil:get_url_encode-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WGameHelperUtil:get_url_decode(decode)
    if not GameHelperUtil then return end
    print("WGameHelperUtil:get_url_decode", decode)
    local val = GameHelperUtil:get_url_decode(decode)
    print("WGameHelperUtil:get_url_decode-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WGameHelperUtil:get_url_encode_bigcase(encode)
    if not GameHelperUtil then return end
    --print("WGameHelperUtil:get_url_encode_bigcase", encode)
    local val = GameHelperUtil:get_url_encode_bigcase(encode)
    --print("WGameHelperUtil:get_url_encode_bigcase-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WGameHelperUtil:get_encode_base64(encode)
    if not GameHelperUtil then return end
    print("WGameHelperUtil:get_encode_base64", encode)
    local val = GameHelperUtil:get_encode_base64(encode)
    print("WGameHelperUtil:get_encode_base64-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WGameHelperUtil:get_decode_base64(decode)
    if not GameHelperUtil then return end
    print("WGameHelperUtil:get_decode_base64", decode)
    local val = GameHelperUtil:get_decode_base64(decode)
    print("WGameHelperUtil:get_decode_base64-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WGameHelperUtil:get_encode_base64_nolimit(encode)
    if not GameHelperUtil then return end
    print("WGameHelperUtil:get_encode_base64_nolimit", encode)
    local val = GameHelperUtil:get_encode_base64_nolimit(encode)
    print("WGameHelperUtil:get_encode_base64_nolimit-1", val)
    return val
end

--@brief    qq大厅游戏前台显示
function WGameHelperUtil:get_decode_base64_nolimit(decode)
    if not GameHelperUtil then return end
    print("WGameHelperUtil:get_decode_base64_nolimit", decode)
    local val = GameHelperUtil:get_decode_base64_nolimit(decode)
    print("WGameHelperUtil:get_decode_base64_nolimit-1", val)
    return val
end

--@brief    最小化win32程序窗口
function WGameHelperUtil:minimizeWindow(hwnd)
    if not GameHelperUtil or not hwnd then return end
    print("WGameHelperUtil:minimizeWindow", hwnd)
    GameHelperUtil:minimizeWindow(hwnd)
end

--@brief    还原win32程序窗口
function WGameHelperUtil:restoreWindow(hwnd)
    if not GameHelperUtil or not hwnd then return end
    print("WGameHelperUtil:restoreWindow", hwnd)
    GameHelperUtil:restoreWindow(hwnd)
end

--@brief    GameHelperUtil::executeCommand(const char*cmd = NULL, const char* param = NULL, int type = 0, int sw_type = 1);
--@brief    执行带参命令行
function WGameHelperUtil:executeCommand(cmd, param, type, sw_type)
    if not GameHelperUtil or not GameHelperUtil.executeCommand then return end
    print("WGameHelperUtil:executeCommand",cmd, param, type, sw_type)
    GameHelperUtil:executeCommand(cmd, param, type, sw_type)
end

--@brief    Flash游戏 - token登录 - 进游戏前请求https://game.flash.cn/client/fc-token-login
function WGameHelperUtil:ChannelLoginVerify()
    print("WGameHelperUtil:ChannelLoginVerify:")
end

function WGameHelperUtil:loginCallback_GET(nTaskId, sData, bFinished, bFailed)
    print("WGameHelperUtil:loginCallback_GET sResponse:", nTaskId,sData,bFinished,bFailed)
    if bFinished then --成功
        print("WGameHelperUtil:loginCallback1111 sResponse:", sData)
    elseif bFailed then --失败
         print("WGameHelperUtil:loginCallback4444:",sData)
    end
end