--SDK_Talk.lua
--@brief	广告类sdk接口
--@date  	2015/10/9
--@author 	zhangming
--@note 	语音sdk

SDK_Talk = {
	b_support = false,
	b_hasSdk = false,
	m_callBack =  {},
	m_sdkConfig = nil,
}
--@brief	定义并初始化表的实例成员变量
--@param	sSDKName:使用的特定SDK的名称
--@note		表的实例变量必须在这里定义和初始化
function SDK_Talk:init()
	local nameList = SDK_Util:getSDKsByTypeFromConfigFile("talk") or {}
	for i = 1, #nameList do
		CCLuaLog("tSDK_Talk:init:"..nameList[i])
		if 	nameList[i] == "com/wyd/Talk/AsynSns" or nameList[i] == "wyd_talk" then
			local platForm =  WZUISystem:getInstance():getPlatformInfo()
			if  platForm == 2 then --2为安卓系统		
				if WZDeviceInfo.getCPUArch ~= nil then
					CCLuaLog("--uuuuuu-----:"..WZDeviceInfo:getCPUArch())
					if WZDeviceInfo:getCPUArch() == "x86" then
						return
					end
				end
			end
			self.m_cppPlAdapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter(nameList[i])
			if self.m_cppPlAdapter == nil then
				return
			end
			m_sdkConfig = SDK_Util:loadConfigFile(nameList[i])
			local sJson = SDK_Util:encodeToJson(m_sdkConfig)
			local callback = WZAdapterCallback:create(SDK_Talk.initCallBack, SDK_Talk)
    		self.m_cppPlAdapter:callMethodByName("init",callback,sJson)
			self.b_hasSdk = true
			return
		end
	end
    self.m_cppPlAdapter = nil
end

--@brief	反初始化表的成员变量
function SDK_Talk:_unInit()
    self.m_cppPlAdapter = nil
    b_support = nil
	b_hasSdk = nil
	m_callBack =  nil
	m_sdkConfig = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	新建一个指定sdk的lua对象
--@param	sSDKName:使用的特定SDK的名称
--@return   #1:绑定了相应sdk的lua table
function SDK_Talk:create(sSDKName)
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
function SDK_Talk:destroy()
	self:_unInit()
end


function SDK_Talk:getAppKey()
	if self.m_cppPlAdapter == nil then
		return ""
	end
	WZLog("getAppKey:",m_sdkConfig.SDKInitConfig.AppKey)
	return m_sdkConfig.SDKInitConfig.AppKey
end

--@brief    初始化sdk
--@param    id:角色的唯一id
--@param    playerName:玩家的名称
--@param	funcCallBack:回调方法
--@param	tCallBackTableObj:回调的lua表对象
--@note 回调字段解释 ["Return"]:"success"--成功 or "fail"--失败
function SDK_Talk:initSDK(id,funcCallBack, tCallBackTableObj)
	WZLog("SDK_Talk:initSDK")
	if self.m_cppPlAdapter == nil then
		return
	end
	--没有开启语音
	if GetPlayTalk() == 1 then
		return
	end
	local playInfo = CacheCenter:getPlayerInfo()
	if playInfo  then
		if playInfo.level < 20 then
			WZLog("SDK_Talk:initSDK doLogin: < 20")
	    	return
	    end
	    WZLog("SDK_Talk:initSDK doLogin: > 20")
	    if id == nil or id == "" then
	    	WZLog("SDK_Talk:initSDK doLogin: > 20 not id:") 
			id = playInfo.id
		end
		WZLog("SDK_Talk:initSDK doLogin: > 20 22:",id) 
	else
		return
	end
	WZLog("SDK_Talk:initSDK playInfo.level: > 20")
	local params = {}
	params.id = id
	local sJson = json.encode(params)
	local callback = WZAdapterCallback:create(SDK_Talk.addMessageCallBack, SDK_Talk)
    self.m_cppPlAdapter:callMethodByName("initSDK",callback,sJson)
    self.m_callBack = {}
    table.insert(self.m_callBack, tCallBackTableObj)
    table.insert(self.m_callBack, funcCallBack)
end

function SDK_Talk:supportTalk()
	return self.b_support
end

function SDK_Talk:hasSdkTalk()
	return self.b_hasSdk
end

--@brief 语言系统开始说话
--@param _type:聊天类型,”room“为群聊，否则为”uid“私聊
--@param id:当为群聊时为房间id,否则为私聊玩家的uid
function SDK_Talk:starTalk(_type,  id)
	if self.m_cppPlAdapter == nil then
		return
	end
	local params = {}
	if _type == "room" then
		params.room = id
	else
		params.id = id
	end

	local sJson = json.encode(params)
	local callback = WZAdapterCallback:create(SDK_Talk.callback, SDK_Talk)
    self.m_cppPlAdapter:callMethodByName("starTalk",callback, sJson) 
end

--@brief 语言系统停止说话
--@param id:为语音d
function SDK_Talk:stopPlayTalk(id)
	if self.m_cppPlAdapter == nil then
		return
	end
	local params = {}
	params.id = id
	local sJson = json.encode(params)
	local callback = WZAdapterCallback:create(SDK_Talk.callback, SDK_Talk)
    self.m_cppPlAdapter:callMethodByName("stopPlayTalk",callback, sJson) 
end

--@brief 语言系统开始说话
--@param state:聊天类型,”enter“为进入，”exit“为推出
--@param id:为要操作的房间id
function SDK_Talk:setRoomState(state,  id,funcCallBack, tCallBackTableObj)
    WZLog("SDK_Talk:setRoomState:",state,id)
	if self.m_cppPlAdapter == nil then
		return
	end
	local params = {}
	params.state = state
	params.id = id
	local sJson = json.encode(params)
	local callback = WZAdapterCallback:create(funcCallBack, tCallBackTableObj)
    self.m_cppPlAdapter:callMethodByName("setRoomState",callback, sJson)
end

--@brief 语言系统结束通话
--@brief result当为取消发送时,该值必须为：“cancel”
function SDK_Talk:stopTalk(result)
	if self.m_cppPlAdapter == nil then
		return
	end
	local callback = WZAdapterCallback:create(SDK_Talk.callback, SDK_Talk)
    self.m_cppPlAdapter:callMethodByName("stopTalk",callback, result)
end

--@brief 语言系统开始播放语言
--@brief id:语言消息的对应唯一id
function SDK_Talk:playTalk(id,funcCallBack,tCallBackTableObj)
	if self.m_cppPlAdapter == nil then
		return
	end
	local callback = WZAdapterCallback:create(funcCallBack, tCallBackTableObj)
     self.m_cppPlAdapter:callMethodByName("playTalk",callback, id)
end

--@brief 语言系统删除语音
--@brief id:语言消息的对应唯一id
function SDK_Talk:removeTalk(id)
	if self.m_cppPlAdapter == nil then
		return
	end
	local callback = WZAdapterCallback:create(SDK_Talk.callback, SDK_Talk)
     self.m_cppPlAdapter:callMethodByName("removeTalk",callback, id)
end

--@brief 语言系统的相关回调
function SDK_Talk:addMessageCallBack(sjson)
  if self.m_callBack ~= nil then
  	WZLog("SDK_Talk:addMessageCallBack = ",sjson)
  	self.m_callBack[2](self.m_callBack[1],sjson)
  end
end

--@brief 语言系统的相关回调
function SDK_Talk:initCallBack(sjson)
  CCLuaLog("SDK_Talk:initCallBack:"..sjson)
  local t_jsonArg = SDK_Util:decodeFromJson(sjson);
  if t_jsonArg["return"] == "success" then
		SDK_Talk.b_support = true
        LoginTalkSDKCallback()
		--ProtocolProcessorGlobal:send_CHAT_GetRoomList()  --获取语音聊天室列
		return
  end
end

--@brief 语言系统的相关回调
function SDK_Talk:callback(sjson)
	-- local t_jsonArg = SDK_Util:decodeFromJson(sjson);
 --    if t_jsonArg["funType"] == "setRoomState" then
 --    	local id = t_jsonArg["id"]
 --    	if t_jsonArg["return"] == "success" then
 --    	elseif t_jsonArg["return"] == "fail" then
 --    	end
 --    end
end


-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
