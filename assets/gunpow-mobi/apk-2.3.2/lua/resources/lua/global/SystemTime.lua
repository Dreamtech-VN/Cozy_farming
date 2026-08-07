--SystemTime.lua
--@brief    系统时间接口
--@date     2015/09/11
SystemTime =
{
}

--------------------------------------公有方法Begin-----------------------------------

--@brief 获取服务器时间
--@return #1 服务器时间戳（单位s)
function SystemTime:getServerTime()
    if NetManager.m_nServerCurTime then
        return NetManager.m_nServerCurTime 
    end
    return os.time()
end

--服务器时区(默认为东八区)
function SystemTime:getServerTimeZone()
    if ProjConfig.LANGUAGE == "vn" then
        return 7
    end
    return 8
end

--@brief 将服务端时间戳转化为本地时区的时间戳 (假设服务端时区为 8)
function SystemTime:convertToLocalTimestamp(serverTimestamp)
    local localTimeZone = os.date("*t", 0).hour
    local serverTimeZone = SystemTime:getServerTimeZone()
    if localTimeZone == serverTimeZone then --如果时区一样直接返回
        return serverTimestamp
    end
    local zeroTimestamp = serverTimestamp - serverTimeZone * 3600 --去掉时区的时间戳
    local localTimestamp = zeroTimestamp + localTimeZone * 3600--转为本地时区

    return localTimestamp
end

--@brief 传入服务端时间戳返回 本地日期的table {day = xxx, month=x, day=x, hour=x, min=x, sec=x}
function SystemTime:getTimeTabelByServerTimestamp(serverTimestamp)
    local localTimestamp = SystemTime:convertToLocalTimestamp(serverTimestamp)
    return os.date("*t", localTimestamp)
end

--@brief 获取本地时间
--@return #1 本地时间戳（单位s)
function SystemTime:getClientTime()
    return os.time()
end

--传入时间戳  xx年xx月xx日
function SystemTime:getTimeConverLocal(time)
    if type(time) ~= "number" then return end
    local y = os.date("%Y", time) 
    local m = os.date("%m", time) 
    local d = os.date("%d", time)
    if ProjConfig.LANGUAGE == "vn" then
        return d.."."..m.."."..y
    end
    return y..LocalStrings.SPACE30..m..LocalStrings.SPACE31..d..LocalStrings.SPACE32
end
--传入时间戳  xx月xx日
function SystemTime:getTimeConverLocal1(time)
    local m = os.date("%m", time) 
    local d = os.date("%d", time)
    if ProjConfig.LANGUAGE == "vn" then
        return d.."."..m
    end
    return m..LocalStrings.SPACE31..d..LocalStrings.SPACE32
end
--传入时间戳  xx:xx:xx 时分秒
function SystemTime:getTimeConverLocal2(time)
    time = tonumber(time) or 0
    local hour = math.floor(time / 3600)
    local min = math.floor((time % 3600) / 60)
    local sec = time % 3600 % 60
    return string.format("%02d:%02d:%02d",hour,min,sec)
end
--传入时间戳  xx日
function SystemTime:getTimeConverLocal3(time)
    local d = os.date("%d", time)
    local s = os.date("%X", time)
    return d..LocalStrings.SPACE32 .. s
end
--传入时间戳   模式 xx.xx 00:00
function SystemTime:getTimeConverLocal4(time)
    local m = os.date("%m", time) 
    local d = os.date("%d", time)
    local h = os.date("%H", time)
    local min = os.date("%M", time)
    if ProjConfig.LANGUAGE == "vn" then
        return d.."."..m.." "..h..":"..min
    end
    return m.."."..d.." "..h..":"..min
end
--传入时间戳  xx天xx小时xx分
function SystemTime:getTimeConverLocal5(time)
    local d = os.date("%d", time)
    local h = os.date("%H", time)
    local min = os.date("%M", time)
    return d..LocalStrings.DAY .. h .. LocalStrings.HOUR1 .. min .. LocalStrings.MINUTE
end
--传入时间戳   模式 xx.xx.xx 00:00
function SystemTime:getTimeConverLocal6(time)
    if not time then
        return 0
    end
    local y = os.date("%Y", time) 
    local m = os.date("%m", time) 
    local d = os.date("%d", time)
    local h = os.date("%H", time)
    local min = os.date("%M", time)
    if ProjConfig.LANGUAGE == "vn" then
        return d.."."..m.."."..y.." "..h..":"..min
    end
    return y.."."..m.."."..d.." "..h..":"..min
end
--传入时间戳  xx:xx 分秒
function SystemTime:getTimeConverLocal7(time)
    time = tonumber(time) or 0
    local min = math.floor((time % 3600) / 60)
    local sec = time % 3600 % 60
    return string.format("%02d:%02d",min,sec)
end
--传入时间戳  xx.xx.xx  年月日
function SystemTime:getTimeConverLocal8(time)
    if type(time) ~= "number" then return end
    local y = os.date("%Y", time) 
    local m = os.date("%m", time) 
    local d = os.date("%d", time)
    if ProjConfig.LANGUAGE == "vn" then
        return d.."."..m.."."..y
    end
    return string.format("%d.%d.%d",y,m,d)
end
--传入时间戳  xx.xx  月日
function SystemTime:getTimeConverLocal9(time)
    if type(time) ~= "number" then return end
    local m = os.date("%m", time) 
    local d = os.date("%d", time)
    if ProjConfig.LANGUAGE == "vn" then
        return d.."."..m
    end
    return string.format("%d.%d",m,d)
end
--传入时间戳   模式 xx月xx日 00:00
function SystemTime:getTimeConverLocal11(time)
    if not time then
        return 0
    end 
    local m = os.date("%m", time) 
    local d = os.date("%d", time)
    local h = os.date("%H", time)
    local min = os.date("%M", time)
    if ProjConfig.LANGUAGE == "vn" then
        return string.format("%d.%d %02d:%02d",d,m,h,min)
    end
    return string.format("%d%s%d%s%02d:%02d",m,LocalStrings.SPACE31,d,LocalStrings.SPACE32,h,min)
end
--传入时间戳  xx:xx 时分
function SystemTime:getTimeConverLocal10(time)
    time = tonumber(time) or 0
    local hour = math.floor(time / 3600)
    local min = math.floor((time % 3600) / 60)
    return string.format("%02d:%02d",hour,min)
end
function SystemTime:getTimeConverLocal13(time)
    time = tonumber(time) or 0
    local hour = math.floor(time / 3600)
    local min = math.floor((time % 3600) / 60)
    return string.format("%02d%s:%02d%s",hour,LocalStrings.HOUR,min,LocalStrings.MINUTE)
end
--------------------------------------公有方法End-----------------------------------

--------------------------------------私有方法Begin-----------------------------------

--------------------------------------公有方法End-----------------------------------
