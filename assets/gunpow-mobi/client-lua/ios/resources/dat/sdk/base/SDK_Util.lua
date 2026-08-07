--SDK_Util.lua
--@brief	使用SDK时,所使用的工具包
--@date  	2013/12/31
--@author 	xiaoyu_wu
--@note 	所有在使用SDK需要经常使用的通用功能

SDK_Util = {
	--以下是与底层交互的接口名称定义
}


-------------------------------------公有方法模块Begin--------------------------------------
--@brief 从配置文件中根据SDK类型获取所有对应类型的SDK名称
--@param sType:SDK的类型，"passport","sns","ad","ds"
--@return #1:包括所有对应类型的SDK名称表
function SDK_Util:getSDKsByTypeFromConfigFile(sType)
    local sSDKConfig = WZFileUtil:getFileContent("SDK.conf")
    if sSDKConfig == "" then
        return
    end
    local tSDKConfig = self:decodeFromJson(sSDKConfig)
    if tSDKConfig == nil or tSDKConfig.SDKConfig == nil then
        return
    end
    
    local tSDKs = {}
    for i,v in ipairs(tSDKConfig.SDKConfig) do
        if v.SDKType == sType then
            table.insert(tSDKs, v.SDKName)
        end
    end
    return tSDKs
end

--@brief 加载SDK配置
--@param sSDKName:SDK的名称
--@return #1:包括所有配置字段的table
function SDK_Util:loadConfigFile(sSDKName)
    --在配置文件中加载相应sdk的配置内容的到sConfigJson
    local sSDKConfig = WZFileUtil:getFileContent("SDK.conf")
    if sSDKConfig == "" then
        return
    end
    local tSDKConfig = self:decodeFromJson(sSDKConfig)
    if tSDKConfig == nil or tSDKConfig.SDKConfig == nil then
        return
    end
    
    --返回相应的table对象
    for i,v in ipairs(tSDKConfig.SDKConfig) do
        if v.SDKName == sSDKName then
            return v
        end
    end
end

--@brief lua对象转换为json格式
--@param luaOjbect:lua对象
--@return #1:json字符串
function SDK_Util:encodeToJson(luaOjbect)
    return json.encode(luaOjbect)
end

--@brief json格式转换为lua对象
--@param sJson:json字符串
--@return #1:lua对象
function SDK_Util:decodeFromJson(sJson)
    return json.decode(tostring(sJson))
end

--@brief 对SDK的表实例进行初始化
--@param sSDKName:SDK的名称
function SDK_Util:initSDKTable(t,sSDKName)
    --在配置文件中加载应用信息
    t.m_tConfig = self:loadConfigFile(sSDKName)
    
    --这里要打印m_tConfig的内容
    CCLuaLog("if t.m_tConfig then 111"..sSDKName)
    if t.m_tConfig then
        CCLuaLog("if t.m_tConfig then 222")
        t.m_cppPlAdapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter(sSDKName) --根据sdk名称在引擎生成的WydPlAdapter对象
    end
    
    --@brief 获取配置信息
    t.getConfig = function(tt) 
        return tt.m_tConfig
    end
    
    --@brief	调用SDK的其它接口
    --@param	sFuncName:接口名称
    --@param	jsonArg:接口所需参数生成的json格式字符串
    --@param	funcCallBack:回调方法
    --@param	tCallBackTableObj:回调的lua表对象
    t.extraInterfaceAccess = function(tt,sFuncName, jsonArg, funcCallBack, tCallBackTableObj)
        local callback = nil
        if funcCallBack and tCallBackTableObj then
            callback = WZAdapterCallback:create(funcCallBack, tCallBackTableObj)
        elseif funcCallBack then
            callback = WZAdapterCallback:create(funcCallBack)
        end
        tt.m_cppPlAdapter:callMethodByName(sFuncName, callback, jsonArg)
    end
     --@brief	调用SDK的其它接口
    --@param	sFuncName:接口名称
    --@param	jsonArg:接口所需参数生成的json格式字符串
    --@param	funcCallBack:回调方法
    --@param	tCallBackTableObj:回调的lua表对象
    t.setCallbackByName = function(tt,sFuncName, funcCallBack, tCallBackTableObj)
        local callback = nil
        if funcCallBack and tCallBackTableObj then
            callback = WZAdapterCallback:create(funcCallBack, tCallBackTableObj)
        elseif funcCallBack then
            callback = WZAdapterCallback:create(funcCallBack)
        end
        tt.m_cppPlAdapter:setCallbackByName(sFuncName, callback)
    end
    --@brief	调用SDK的其它接口并且立即返回结果
    --@param	sFuncName:接口名称
    --@param	jsonArg:接口所需参数生成的json格式字符串
    --@return   #1,接口返回的json字符串
    t.extraInterfaceAccessReturn = function(tt,sFuncName, jsonArg)
        return tt.m_cppPlAdapter:callMethodByNameReturn(sFuncName,jsonArg)
    end
end

--@brief 对SDK的表实例进行反初始化
function SDK_Util:unInitSDKTable(t)
     if t.m_cppPlAdapter then
        local nId = t.m_cppPlAdapter:getId()
        WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(nId)
        t.m_cppPlAdapter     = nil
    end
    
    t.m_tConfig = nil
    t.getConfig = nil
    t.extraInterfaceAccess = nil
    t.extraInterfaceAccessReturn = nil
end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
