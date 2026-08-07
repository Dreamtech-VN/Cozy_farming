--PlatformInfo.lua
--@brief	运行平台信息定义
--@date		2013/12/19
--@author	叶威
--@note     可获取当前运行的平台环境


PlatformInfo = {
	platformType = 0,        --平台类型
    platformDsc = "unknow",
}

PlatformInfo.type = {
    PLATFORM_UNKNOW = 0,    --未知平台
    PLATFORM_IOS = 1,		--ios平台
    PLATFORM_ANDROID = 2,	--android平台
    PLATFORM_WIN32 = 3,		--win32平台
	PLATFORM_WP8 = 13,		--win phone平台
}

--@brief	设置当前运行平台类型
--@note     在main方法中调用该方法，且该文件应该在main.lua前面进行编译
function PlatformInfo:setCurrentPlatform()
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	self.platformType = platForm
	local des = "unknow"
	if self.platformType == 1 then
		des = "ios"
	elseif self.platformType == 2 then
		des = "android"
	elseif self.platformType == 3 then
		des = "win32"
	elseif self.platformType == 13 then
		des = "wp8"
	end
--    WZLog("*********************current platform is "..des.."********************")
    if des == "android" then
        CCLuaLog("*********************current platform is "..des.."********************")
    end
    
    self.platformDsc = des
end

--@brief	获取当前运行平台类型
--@return   #1:平台类型变量
function PlatformInfo:getCurrentPlatform()
    return  self.platformType
end