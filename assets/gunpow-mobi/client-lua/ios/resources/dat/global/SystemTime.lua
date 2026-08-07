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

--@brief 将服务端时间戳转化为本地时区的时间戳 (假设服务端时区为 8)
function SystemTime:convertToLocalTimestamp(serverTimestamp)
	local localTimeZone = os.date("*t", 0).hour
	local serverTimeZone = 8
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

--------------------------------------公有方法End-----------------------------------

--------------------------------------私有方法Begin-----------------------------------

--------------------------------------公有方法End-----------------------------------
