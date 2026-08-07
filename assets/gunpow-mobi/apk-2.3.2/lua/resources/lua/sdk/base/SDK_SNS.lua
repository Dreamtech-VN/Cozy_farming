--SDK_SNS.lua
--@brief	社交类sdk接口
--@date  	2013/01/20
--@author 	xiaoyu_wu
--@note 	所有第三方社交类sdk接口都从这里生成

SDK_SNS = {
	
}

--@brief	定义并初始化表的实例成员变量
--@param	sSDKName:使用的特定SDK的名称
--@note		表的实例变量必须在这里定义和初始化
function SDK_SNS:_init(sSDKName)
    SDK_Util:initSDKTable(self,sSDKName)
end

--@brief	反初始化表的成员变量
function SDK_SNS:_unInit()
    SDK_Util:unInitSDKTable(self) 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	新建一个指定sdk的lua对象
--@param	sSDKName:使用的特定SDK的名称
--@return   #1:绑定了相应sdk的lua table
function SDK_SNS:create(sSDKName)
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
function SDK_SNS:destroy()
	self:_unInit()
end


--@brief	英雄传送数据
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:postData(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("postData",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	英雄打开攻略
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:showTactic(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("showTactic","",funcCallBack,tCallBackTableObj)
end

--@brief	英雄打开俱乐部
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:showClub(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("showClub","",funcCallBack,tCallBackTableObj)
end

--@brief	英雄打开商城
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:showShop(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("showShop","",funcCallBack,tCallBackTableObj)
end

--@brief	英雄sdk其它方法
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:heroOthers(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("heroOthers",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	分享微信文字
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:shareWeChatText(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("shareWeChatText",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	
--@brief	分享微信图片
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:shareWeChatImage(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("shareWeChatImage",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief    初始化sdk
--@param	funcCallBack:回调方法
--@param	tCallBackTableObj:回调的lua表对象
--@note 回调字段解释 ["Return"]:"success"--成功 or "fail"--失败
function SDK_SNS:initSDK(funcCallBack,tCallBackTableObj)
    local sConfigJson=SDK_Util:encodeToJson(self.m_tConfig)
    self:extraInterfaceAccess("initSDK",sConfigJson,funcCallBack,tCallBackTableObj)
end

--@brief    第三方登录接口
--@param    sJsonArg:登录时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:login(sJsonArg,funcCallBack,tCallBackTableObj)
    self:extraInterfaceAccess("login",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	登陆事件
--@param    sJsonArg:提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:onLogin(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("onlogin",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	第三方登出接口
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:logout(funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("logout","",funcCallBack,tCallBackTableObj)
end


--@brief	第三方分享接口
--@param    sJsonArg:分享提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:share(sJsonArg,funcCallBack,tCallBackTableObj)
	WZLog("开始微博分享，分享内容是：",sJsonArg)
	self:extraInterfaceAccess("share",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	第三方邀请接口
--@param    sJsonArg:邀请提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:invite(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("invite",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	第三方获取用户信息接口
--@param    sJsonArg:获取用户信息时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:getUserInfo(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("getUserInfo",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	第三方获取鉴权信息接口
--@param    sJsonArg:获取鉴权信息时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:getTokenInfo(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("getTokenInfo",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	第三方获取关注列表接口
--@param    sJsonArg:获取关注列表时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:getFriends(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("getFriends",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	第三方获取粉丝列表接口
--@param    sJsonArg:获取粉丝列表时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:getFollowers(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("getFollowers",sJsonArg,funcCallBack,tCallBackTableObj)
end

--@brief	第三方获取互粉列表接口
--@param    sJsonArg:获取互粉列表时提供给Sdk的参数集
--@param	funcCallBack:回调函数
--@param	tCallBackTableObj:回调的表对象
function SDK_SNS:getBilateral(sJsonArg,funcCallBack,tCallBackTableObj)
	self:extraInterfaceAccess("getBilateral",sJsonArg,funcCallBack,tCallBackTableObj)
end



-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
