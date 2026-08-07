--PlugSDKManager.lua
--@brief	外挂检测管理类
--@date		2014/03/21
--@author	yueqi_guo
--@note		外挂检测管理类

PlugSDKManager = {
	m_tSdkNameList = nil, --渠道类sdk名称表
    m_tCurSdkObj = nil, --当前使用的sdk表对象
    m_nChannelId = nil, --包渠道号
}

-------------------------------------公有方法模块Begin--------------------------------------
--@brief    从配置文件中获得sdk列表
--@return   #1,sdk名称表
function PlugSDKManager:getSdkList()
    self.m_tSdkNameList = SDK_Util:getSDKsByTypeFromConfigFile("plug") or {}
    return self.m_tSdkNameList
end

--@brief    根据sdk名称初始化sdk
--@param    sSdkName,sdk名称
--@note     sSdkName为空时默认使用sdk列表中的第一个初始化
function PlugSDKManager:initSdkWithName(sSdkName)
    if sSdkName == nil then
        if self.m_tSdkNameList == nil then
            self:getSdkList()
        end
        sSdkName = self.m_tSdkNameList[1]
    end
    if sSdkName == nil then
        CCLuaLog("PlugdkManager:initSdkWithName sdk name is nil!")
        return
    end

    CCLuaLog("PlugdkManager:initSdkWithName" .. sSdkName)
    local tSdkLuaObj = SDK_Plug:create(sSdkName)
    if tSdkLuaObj == nil then
        CCLuaLog("PlugdkManager:initSdkWithName create "..sSdkName.." sdk lua object fail!")
        return
    end
    tSdkLuaObj:initSDK()
    return tSdkLuaObj
end

--@brief    设置当前使用的sdk表对象
--@param    tSdkLuaObj,sdk表对象
function PlugSDKManager:setCurSdkObj(tSdkLuaObj)
    self.m_tCurSdkObj = tSdkLuaObj
end

--@brief    获取当前使用的sdk表对象
--@return   #1,sdk表对象
function PlugSDKManager:getCurSdkObj()
    return self.m_tCurSdkObj
end

--@brief    获取包的渠道号
--@return   #1,渠道号
function PlugSDKManager:getChannelId()
     self.m_nChannelId = WZFileUtil:getNodeValueFromXml("ChannelId")
     CCLuaLog("PlugSDKManager:getChannelId" .. self.m_nChannelId)
     return tonumber(self.m_nChannelId) or 0
end

--@brief    根据渠道号构建sdk
function PlugSDKManager:initSdk()
    CCLuaLog("PlugdkManager:initSdk")
    self:getChannelId()
    self.m_tCurSdkObj = self:initSdkWithName()


end





-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
