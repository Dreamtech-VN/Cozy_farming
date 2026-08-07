--SDK_Passport.lua
--@brief	通行证及其付费接口
--@date  	2013/12/31
--@author 	xiaoyu_wu
--@note 	所有第三方登录,以及第三方付费接口都从这里生成

SDK_Passport = {
	
}

--@brief	定义并初始化表的实例成员变量
--@param	sSDKName:使用的特定SDK的名称
--@note		表的实例变量必须在这里定义和初始化
function SDK_Passport:_init(sSDKName)
    SDK_Util:initSDKTable(self,sSDKName)
end

--@brief	反初始化表的成员变量
function SDK_Passport:_unInit()
    SDK_Util:unInitSDKTable(self) 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	新建一个指定sdk的lua对象
--@param	sSDKName:使用的特定SDK的名称
--@return   #1:绑定了相应sdk的lua table
function SDK_Passport:create(sSDKName)
	local tNewSDKObj = {}
	
    setmetatable(tNewSDKObj, self)
    self.__index = self
	
    tNewSDKObj:_init(sSDKName)
    if tNewSDKObj.m_cppPlAdapter == nil then
        return
    end
	
    return tNewSDKObj
end

--@brief	释放渠道类Lua表对象
function SDK_Passport:destroy()
	self:_unInit()
end


--@brief    初始化sdk
--@param	funcCallBack:回调方法
--@param	tCallBackTableObj:回调的lua表对象
--@note 回调字段解释 ["Return"]:"success"--成功 or "fail"--失败
function SDK_Passport:initSDK(funcCallBack,tCallBackTableObj)
    local sConfigJson=SDK_Util:encodeToJson(self.m_tConfig)
    self:extraInterfaceAccess("initSDK",sConfigJson,funcCallBack,tCallBackTableObj)
end

--@brief    第三方登录接口
--@param    sJsonArg:登录时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Passport:login(sJsonArg,funcCallBack,tCallBackTableObj)
    self:extraInterfaceAccess("login",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	第三方登出接口
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Passport:logout(funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("logout","",funcCallBack,tCallBackTableObj)
end

--@brief    检测更新
--@param    funcCallBack:回调函数
--@param    tCallBackTableObj:回调的表对象
function SDK_Passport:appVersionUdate(funcCallBack,tCallBackTableObj)
    self:extraInterfaceAccess("appVerUdate","",funcCallBack,tCallBackTableObj)
end

--@brief    第三对方进入社区平台
--@param    funcCallBack:回调函数
--@param    tCallBackTableObj:回调的表对象
function SDK_Passport:enterPlatform(funcCallBack,tCallBackTableObj)
    self:extraInterfaceAccess("enterPlatform","",funcCallBack,tCallBackTableObj)
end

--@brief    第三对方登陆有关的扩展接口
--@param    funcCallBack:回调函数
--@param    tCallBackTableObj:回调的表对象
function SDK_Passport:accountOthers(sJsonArg,funcCallBack,tCallBackTableObj)
    self:extraInterfaceAccess("accountOthers",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief    第三方付费接口
--@param    sJsonArg:登录时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Passport:doPay(sJsonArg,funcCallBack,tCallBackTableObj)
    NetManager:disableBreathNotifyDisconnect() 
    self:extraInterfaceAccess("startPurchase",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief    第三对方登陆有关的扩展接口
--@param    sJsonArg:提供给Sdk的参数集
--@param    funcCallBack:回调函数
--@param    tCallBackTableObj:回调的表对象
function SDK_Passport:purchaseOthers(sJsonArg,funcCallBack,tCallBackTableObj)
    self:extraInterfaceAccess("purchaseOthers",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief    获取sdk版本有关的扩展接口
--@param    sJsonArg:提供给Sdk的参数集
--@param    funcCallBack:回调函数
--@param    tCallBackTableObj:回调的表对象
function SDK_Passport:getVersion()
    return self:extraInterfaceAccess("getVersion")
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
