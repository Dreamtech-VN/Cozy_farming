--SDK_DS.lua
--@brief	数据统计类sdk接口
--@date  	2013/01/22
--@author 	xiaoyu_wu
--@note 	所有第三方数据统计类sdk接口都从这里生成

SDK_DS = {
	
}

--@brief	定义并初始化表的实例成员变量
--@param	sSDKName:使用的特定SDK的名称
--@note		表的实例变量必须在这里定义和初始化
function SDK_DS:_init(sSDKName)
    SDK_Util:initSDKTable(self,sSDKName)
end

--@brief	反初始化表的成员变量
function SDK_DS:_unInit()
    SDK_Util:unInitSDKTable(self) 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	新建一个指定sdk的lua对象
--@param	sSDKName:使用的特定SDK的名称
--@return   #1:绑定了相应sdk的lua table
function SDK_DS:create(sSDKName)
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
function SDK_DS:destroy()
	self:_unInit()
end

--@brief    获取第三方sdk的版本号
--@return   #1:返回包含结果的json字符串
function SDK_DS:getVersion()
    return self:extraInterfaceAccessReturn("getVersion", "")
end

--@brief    初始化sdk
--@param	funcCallBack:回调方法
--@param	tCallBackTableObj:回调的lua表对象
--@note 回调字段解释 ["Return"]:"success"--成功 or "fail"--失败
function SDK_DS:initSDK(funcCallBack,tCallBackTableObj)
    local sConfigJson=SDK_Util:encodeToJson(self.m_tConfig)
    self:extraInterfaceAccess("initSDK",sConfigJson,funcCallBack,tCallBackTableObj)
end

--@brief	程序开始运行时调用的接口
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:onStart(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("onStart",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	自定义事件
--@param    sJsonArg:自定义事件时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:onEvent(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("onEvent",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	设置经纬度
--@param    sJsonArg:设置经纬度时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:setLatitude(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("setLatitude",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief    获取设备ID
--@param    sJsonArg:获取设备ID时提供给Sdk的参数集
--@return   #1:返回包含结果的json字符串
function SDK_DS:getDeviceId(sJsonArg)
    return self:extraInterfaceAccessReturn("getDeviceId",sJsonArg)
end

--@brief	程序被杀时调用的接口
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:onKill(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("onKill",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	程序被切到后台时调用的接口
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:onPause(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("onPause",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	程序被切到前台时调用的接口
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:onResume(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("onResume",sJsonArg,funcCallBack,tCallBackTableObj)
end


--@brief	设置账号
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:setAccountId(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("setAccountId",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	设置等级
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:setLevel(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("setLevel",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	设置服务器
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:setGameServer(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("setGameServer",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	登陆事件
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:onLogin(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("onlogin",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	注册事件
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:onRegister(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("onregister",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	付费事件
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:onPay(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("onpay",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	上传数据
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:putFile(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("putFile",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	下载数据
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:downFile(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("downFile",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	创建bucket
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_DS:createBucket(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("createBucket",sJsonArg,funcCallBack,tCallBackTableObj)
end

-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
