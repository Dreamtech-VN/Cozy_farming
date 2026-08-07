--SDK_Push.lua
--@brief	推送类sdk接口
--@date  	2013/01/22
--@author 	yanggaoshan
--@note 	所有第三方推送类sdk接口都从这里生成

SDK_Push = {
	
}

--@brief	定义并初始化表的实例成员变量
--@param	sSDKName:使用的特定SDK的名称
--@note		表的实例变量必须在这里定义和初始化
function SDK_Push:_init(sSDKName)
    SDK_Util:initSDKTable(self,sSDKName)
end

--@brief	反初始化表的成员变量
function SDK_Push:_unInit()
    SDK_Util:unInitSDKTable(self) 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	新建一个指定sdk的lua对象
--@param	sSDKName:使用的特定SDK的名称
--@return   #1:绑定了相应sdk的lua table
function SDK_Push:create(sSDKName)
	local tNewSDKObj = {}
	
    setmetatable(tNewSDKObj, self)
    self.__index = self
	
    tNewSDKObj:_init(sSDKName)
    if tNewSDKObj.m_cppPlAdapter == nil then
        return
    end
	
    return tNewSDKObj
end

--@brief	释放推送类Lua表对象
function SDK_Push:destroy()
	self:_unInit()
end

--@brief    获取第三方sdk的版本号
--@return   #1:返回包含结果的json字符串
function SDK_Push:getVersion()
    return self:extraInterfaceAccessReturn("getVersion", "")
end

--@brief    初始化sdk
--@param	funcCallBack:回调方法
--@param	tCallBackTableObj:回调的lua表对象
--@note 回调字段解释 ["Return"]:"success"--成功 or "fail"--失败
function SDK_Push:initSDK(funcCallBack,tCallBackTableObj)
    local sConfigJson=SDK_Util:encodeToJson(self.m_tConfig)
    self:extraInterfaceAccess("initSDK",sConfigJson,funcCallBack,tCallBackTableObj)
end

--@brief	注册消息监听的接口
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Push:register(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("register",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	停止消息监听
--@param    sJsonArg:自定义事件时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Push:unregister(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("unregister",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	设置分组
--@param    sJsonArg:提供给Sdk的json参数集，必须包含"tagName"字段
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Push:setTag(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("setTag",sJsonArg,funcCallBack,tCallBackTableObj)
end
--@brief	删除分组
--@param    sJsonArg:提供给Sdk的json参数集，必须包含"tagName"字段
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Push:deleteTag(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("deleteTag",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief    获取设备Token
--@param    sJsonArg:获取设备ID时提供给Sdk的参数集
--@return   #1:返回包含结果的json字符串
function SDK_Push:getToken(sJsonArg)
    return self:extraInterfaceAccessReturn("getToken",sJsonArg)
end

--@brief	扩展接口，用于sdk扩展自定义的功能
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Push:others(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("others",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief    本地推送接口
--@param    sAccount:设置别名
function SDK_Push:setAccount(sAccount)
     self:extraInterfaceAccess("setAccount",sAccount,self.callback, self)
end

function SDK_Push:callback(mjson)
    
end

--@brief	本地推送接口
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Push:localPush(sJsonArg,funcCallBack,tCallBackTableObj)
self:extraInterfaceAccess("localPush",sJsonArg,funcCallBack,tCallBackTableObj)
end



-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
