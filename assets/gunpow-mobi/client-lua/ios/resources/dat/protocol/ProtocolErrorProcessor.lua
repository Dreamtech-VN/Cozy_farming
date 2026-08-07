--ProtocolErrorProcessor.lua
--@brief	协议错误处理器
--@date  	2013/12/11
--@author 	SuYuan
--@note 	如有需要可在这里进行一些统一的协议处理


ProtocolErrorProcessor = {}


--@brief	协议错误处理枢纽函数
--@param 	nMainType:主协议号
--@param 	nSubType:子协议号
--@param 	nflag:标识
--@param 	sMessage:错误信息
--@note		如有需要在这里统一处理所有的协议错误
function ProtocolErrorProcessor:errorProcess(nMainType, nSubType, nflag, sMessage)
    WZLog("-----------------ProtocolErrorProcessor:errorProcess---------------")
    WZLog("mainType:")
    WZLog(nMainType)
    WZLog("nSubType:")
    WZLog(nSubType)
    WZLog("nflag:")
    WZLog(nflag)
    WZLog("sMessage:")
    WZLog(sMessage)
--    if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_WIN32 then
--            WZLog(KLuaSocket:utfToGBK(sMessage))
--            WZLog(sMessage)
--    else
--        WZLog(sMessage)
--    end
    WZLog("----------------------------------------------------------------------")
 
    if  sMessage ~= nil and sMessage ~= "" then
         MsgBoxManager:showTipBox(sMessage)
    end
end






