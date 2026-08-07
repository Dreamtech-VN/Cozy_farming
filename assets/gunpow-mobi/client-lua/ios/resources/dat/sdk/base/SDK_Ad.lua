--SDK_Ad.lua
--@brief	广告类sdk接口
--@date  	2013/01/22
--@author 	xiaoyu_wu
--@note 	所有第三方广告类sdk接口都从这里生成

SDK_Ad = {
	
}

--@brief	定义并初始化表的实例成员变量
--@param	sSDKName:使用的特定SDK的名称
--@note		表的实例变量必须在这里定义和初始化
function SDK_Ad:_init(sSDKName)
    SDK_Util:initSDKTable(self,sSDKName)
end

--@brief	反初始化表的成员变量
function SDK_Ad:_unInit()
    SDK_Util:unInitSDKTable(self) 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	新建一个指定sdk的lua对象
--@param	sSDKName:使用的特定SDK的名称
--@return   #1:绑定了相应sdk的lua table
function SDK_Ad:create(sSDKName)
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
function SDK_Ad:destroy()
	self:_unInit()
end

--@brief    获取第三方sdk的版本号
--@return   #1:返回包含结果的json字符串
function SDK_Ad:getVersion()
    return self:extraInterfaceAccessReturn("getVersion")
end

--@brief    初始化sdk
--@param	funcCallBack:回调方法
--@param	tCallBackTableObj:回调的lua表对象
--@note 回调字段解释 ["Return"]:"success"--成功 or "fail"--失败
function SDK_Ad:initSDK(funcCallBack,tCallBackTableObj)
    local sConfigJson=SDK_Util:encodeToJson(self.m_tConfig)
    self:extraInterfaceAccess("initSDK",sConfigJson,funcCallBack,tCallBackTableObj)
end

--@brief	初始化广告
--@param    sJsonArg:初始化广告时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Ad:initWithAdUnitID(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("initWithAdUnitID",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	显示广告
--@param    sJsonArg:显示广告时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Ad:adShow(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("adShow",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	隐藏广告
--@param    sJsonArg:隐藏广告时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Ad:adHide(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("adHide",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	获取广告ID
--@param    sJsonArg:获取广告ID时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Ad:getUnitID(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("getUnitID",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	查询积分
--@param    sJsonArg:查询积分时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Ad:queryScore(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("queryScore",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	减少积分
--@param    sJsonArg:减少积分时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_Ad:reduceScore(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("reduceScore",sJsonArg,funcCallBack,tCallBackTableObj)
end


-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
