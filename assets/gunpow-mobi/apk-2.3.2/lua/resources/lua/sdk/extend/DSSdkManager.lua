--PushSdkManager.lua
--@brief    推送管理类
--@date     2014/03/21
--@author   yanggaoshan
--@note     推送管理类

DSSdkManager = {
    m_tSdkNameList = nil, --渠道类sdk名称表
    m_tCurSdkObj = nil, --当前使用的sdk表对象
    m_nChannelId = nil, --包渠道号
}

-------------------------------------公有方法模块Begin--------------------------------------
--@brief    从配置文件中获得sdk列表
--@return   #1,sdk名称表
function DSSdkManager:getSdkList()
    self.m_tSdkNameList = SDK_Util:getSDKsByTypeFromConfigFile("DS") or {}
    return self.m_tSdkNameList
end

--@brief    根据sdk名称初始化sdk
--@param    sSdkName,sdk名称
--@note     sSdkName为空时默认使用sdk列表中的第一个初始化
function DSSdkManager:initSdkWithName(sSdkName)
    if sSdkName == nil then
        if self.m_tSdkNameList == nil then
            self:getSdkList()
        end
        sSdkName = self.m_tSdkNameList[1]
    end
    if sSdkName == nil then
        CCLuaLog("DSSdkManager:initSdkWithName sdk name is nil!")
        return
    end

    CCLuaLog("DSSdkManager:initSdkWithName" .. sSdkName)
    local tSdkLuaObj = SDK_DS:create(sSdkName)
    if tSdkLuaObj == nil then
        CCLuaLog("DSSdkManager:initSdkWithName create "..sSdkName.." sdk lua object fail!")
        return
    end
    tSdkLuaObj:initSDK()
    return tSdkLuaObj
end

--@brief    设置当前使用的sdk表对象
--@param    tSdkLuaObj,sdk表对象
function DSSdkManager:setCurSdkObj(tSdkLuaObj)
    self.m_tCurSdkObj = tSdkLuaObj
end

--@brief    获取当前使用的sdk表对象
--@return   #1,sdk表对象
function DSSdkManager:getCurSdkObj()
    return self.m_tCurSdkObj
end

--@brief    获取包的渠道号
--@return   #1,渠道号
function DSSdkManager:getChannelId()
     self.m_nChannelId = WZFileUtil:getNodeValueFromXml("ChannelId")
     CCLuaLog("DSSdkManager:getChannelId" .. self.m_nChannelId)
     return tonumber(self.m_nChannelId) or 0
end

--@brief    根据渠道号构建sdk
function DSSdkManager:initSdk()
    CCLuaLog("DSSdkManager:initSdk")
    self:getChannelId()
    self.m_tCurSdkObj = self:initSdkWithName()
end

function DSSdkManager:setAccountId(accountId)
    if self.m_tCurSdkObj ~= nil and self.m_tCurSdkObj.setAccountId ~= nil then
        self.m_tCurSdkObj:setAccountId(accountId)
    end
end

function DSSdkManager:setLevel(level)
    if self.m_tCurSdkObj ~= nil and self.m_tCurSdkObj.setLevel ~= nil then
        self.m_tCurSdkObj:setLevel(level)
    end
end

function DSSdkManager:setGameServer(gameServer)
    if self.m_tCurSdkObj ~= nil and self.m_tCurSdkObj.setGameServer ~= nil then
        self.m_tCurSdkObj:setGameServer(gameServer)
    end
end

function DSSdkManager:onLogin(accountId)
    if self.m_tCurSdkObj ~= nil and self.m_tCurSdkObj.onLogin ~= nil then
        self.m_tCurSdkObj:onLogin(accountId)
    end
end

function DSSdkManager:onRegister(accountId)
    if self.m_tCurSdkObj ~= nil and self.m_tCurSdkObj.onRegister ~= nil then
        self.m_tCurSdkObj:onRegister(accountId)
    end
end

function DSSdkManager:onPay(sJson)
    if self.m_tCurSdkObj ~= nil and self.m_tCurSdkObj.onPay ~= nil then
        self.m_tCurSdkObj:onPay(sJson)
    end
end

function DSSdkManager:createBucket(sJson)
    if self.m_tCurSdkObj ~= nil then
        self.m_tCurSdkObj:createBucket(sJson)
    end
end

function DSSdkManager:putFile(sJson, callFunc, luaTable)
    if self.m_tCurSdkObj ~= nil then
        self.m_tCurSdkObj:putFile(sJson, callFunc, luaTable)
    end
end

function DSSdkManager:downFile(sJson, callFunc, luaTable)
	WZLog("DSSdkManager:downFile",sJson)
    if self.m_tCurSdkObj ~= nil then
        self.m_tCurSdkObj:downFile(sJson, callFunc, luaTable)
    end
end

-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
