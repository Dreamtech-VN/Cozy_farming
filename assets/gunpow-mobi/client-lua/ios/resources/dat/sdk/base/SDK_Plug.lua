--SDK_Plug.lua
--@brief	防外挂类sdk接口
--@date  	2013/01/20
--@author 	yueqi_guo
--@note 	防外挂sdk接口都从这里生成

SDK_Plug = {
	
}
--@brief	定义并初始化表的实例成员变量
--@param	sSDKName:使用的特定SDK的名称
--@note		表的实例变量必须在这里定义和初始化
function SDK_Plug:_init(sSDKName)
    SDK_Util:initSDKTable(self,sSDKName)
end

--@brief	反初始化表的成员变量
function SDK_Plug:_unInit()
    SDK_Util:unInitSDKTable(self) 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	新建一个指定sdk的lua对象
--@param	sSDKName:使用的特定SDK的名称
--@return   #1:绑定了相应sdk的lua table
function SDK_Plug:create(sSDKName)
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
function SDK_Plug:destroy()
	self:_unInit()
end


--@brief    初始化sdk
--@param	funcCallBack:回调方法
--@param	tCallBackTableObj:回调的lua表对象
function SDK_Plug:initSDK(funcCallBack,tCallBackTableObj)
    local sConfigJson=SDK_Util:encodeToJson(self.m_tConfig)
    self:extraInterfaceAccess("initSDK",sConfigJson,funcCallBack,tCallBackTableObj)
end

--@brief    初始化sdk
--@param	funcCallBack:回调方法
--@param	tCallBackTableObj:回调的lua表对象
function SDK_Plug:setPlugProcess(sProcessMessage,funcCallBack,tCallBackTableObj)
    self:extraInterfaceAccess("setPlugProcess",sProcessMessage,funcCallBack,tCallBackTableObj)
end
