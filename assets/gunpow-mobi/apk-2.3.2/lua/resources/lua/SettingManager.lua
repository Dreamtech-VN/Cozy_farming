--SettingManager.lua
--@brief	设置SDK管理
--@date		2014/03/25
--@author	liangguang_long
--@note		

SettingManager = {}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	打开文件获取SDK数据
function SettingManager:openFile()
	local sSDKConfig = WZFileUtil:getFileContent("SettingSDK.conf")
	WZLog("d:::::::::::::::::::::::::",sSDKConfig)	
	if sSDKConfig and sSDKConfig ~= "" then
		local tSDKConfig = self:toJsonCode(sSDKConfig)
		WZLog("b:::::::::::::::::::::::::",tSDKConfig,tSDKConfig.SDKConfig)	
		if tSDKConfig and tSDKConfig.SDKConfig then
			return tSDKConfig.SDKConfig
		end
	 end
end

--@brief	获取Vip SDK数据
function SettingManager:getVIPSdkData()
	local sSDKConfig = WZFileUtil:getFileContent("SettingSDK.conf")
	if sSDKConfig and sSDKConfig ~= "" then
		local tSDKConfig = self:toJsonCode(sSDKConfig)
		if tSDKConfig and tSDKConfig.VIPConfig then
			return tSDKConfig.VIPConfig
		end
	 end
end

--@brief	获取注册按钮数据(是否显示)
function SettingManager:getAcountData()
	local sSDKConfig = WZFileUtil:getFileContent("SettingSDK.conf")
	if sSDKConfig and sSDKConfig ~= "" then
		local tSDKConfig = self:toJsonCode(sSDKConfig)
		if tSDKConfig and tSDKConfig.setAConfig then
			return tSDKConfig.setAConfig
		end
	 end
end

--@brief	转成json格式
--@param	sJsonCode:字符串内容
function SettingManager:toJsonCode(sJsonCode)
	return json.decode(tostring(sJsonCode))
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------回调函数模块模块Begin--------------------------------------

--@brief	账号按钮回调函数
function SettingManager:onSignOut(element)
	local tData = {}
	tData.funType = "onSingnOut"
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	local sJsonArg = json.encode(tData)
	if curSdkObj then
		curSdkObj:setCallbackByName("logout",PassportDefaultCallback.logoutCallback,PassportDefaultCallback)
		curSdkObj:accountOthers(sJsonArg, nil, NIL)
	end
end

--@brief	社区按钮回调函数
function SettingManager:onBBS(element)
	local tData = {}
	tData.funType = "91_BBS"
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	local sJsonArg = json.encode(tData)
	if curSdkObj then
		curSdkObj:accountOthers(sJsonArg, nil, NIL)
	end
end

--@brief	社区按钮回调函数
function SettingManager:onFeedback(element)
	local tData = {}
	tData.funType = "91_Feedback"
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	local sJsonArg = json.encode(tData)
	if curSdkObj then
		curSdkObj:accountOthers(sJsonArg, nil, NIL)
	end
end

--@brief	绑定账号按钮回调函数
function SettingManager:onBindAccount(element)
	local tData = {}
	tData.funType = "QFT_BindAccount"
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	local sJsonArg = json.encode(tData)
	if curSdkObj then
		curSdkObj:accountOthers(sJsonArg, nil, NIL)
	end
end

--@brief	社区按钮回调函数
function SettingManager:onCommunity(element)
	local tData = {}
	tData.funType = "JY_Community"
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	local sJsonArg = json.encode(tData)
	if curSdkObj then
		curSdkObj:accountOthers(sJsonArg, nil, NIL)
	end
end

--@brief	服务器按钮回调函数
function SettingManager:onServerClick(element)
	local wndSelectServerElement = WndSelectServer:createElement()
	if wndSelectServerElement then
		WindowManager:addWindow( wndSelectServerElement , WndSelectServer )
	end
end

--@brief	注册账号按钮回调函数
function SettingManager:onRegisterClick(element)
	local winRegister = WndRegister:createElement()
	if winRegister then
		WindowManager:addWindow(winRegister, WndRegister)
	end
end

--@brief	帮助按钮回调函数
function SettingManager:onHelpClick(element)
	local wndHelpElement = WndHelp:createElement()
	if wndHelpElement then
		WindowManager:addWindow( wndHelpElement , WndHelp )
	end
end

--@brief	意见箱按钮回调函数
function SettingManager:onSuggestionBoxClick(element)
	local curSdkObj =  PassportSdkManager:getCurSdkObj()
	if curSdkObj == nil then
		local wndwndSuggestionElement = WndSuggestion:createElement()
		if wndwndSuggestionElement then
			WindowManager:addWindow( wndwndSuggestionElement , WndSuggestion )
		end
	else
		local config = curSdkObj.m_tConfig
	    if config  then
		   if config.SDKOtherConfig.isGotoEFUNFeedBook == "true" then
			   WZLog("test isGotoEFUNFeedBook")
			  self.m_gotoEFUNFeedBook = {}
			  self.m_gotoEFUNFeedBook.gotoFeedBook = "gotoFeedBook"
			  local data = WZDataFile:getInstance():getUserData()
			  if data == nil then
				self.m_gotoEFUNFeedBook.serverCode = nil
			  else
				self.m_gotoEFUNFeedBook.serverCode = data:getStringValue("IPDParam", "ServerId")
			  end
			  self.m_gotoEFUNFeedBook.PlayerID = GlobalGame.g_tPlayerInfo.nPlayerId
			  self.m_gotoEFUNFeedBook.playerName = GlobalGame.g_tPlayerInfo.sPlayerName
			  curSdkObj:accountOthers(json.encode(self.m_gotoEFUNFeedBook),nil)
		    else
			  local wndwndSuggestionElement = WndSuggestion:createElement()
			  if wndwndSuggestionElement then
				 WindowManager:addWindow( wndwndSuggestionElement , WndSuggestion )
			  end
		   end
		 end
	end
end

--@brief 机锋完善账号
function  SettingManager:onCompleteAccount(element)
	CCLog("onCompleteAccount")
	local tshowPlatFormParams = {}
    tshowPlatFormParams.funType = "CompleteAccount"
    local sJsonArg = json.encode(tshowPlatFormParams)
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	if nil ~= curSdkObj then
		 CCLog("sJsonArg",sJsonArg)
		 curSdkObj:accountOthers(sJsonArg,nil)
	end	
end

--@brief 360防沉迷
function  SettingManager:onCheck(element)
	local tshowPlatFormParams = {}
    tshowPlatFormParams.funType = "check"
    local sJsonArg = json.encode(tshowPlatFormParams)
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	if nil ~= curSdkObj then
		 CCLog("sJsonArg",sJsonArg)
		 curSdkObj:accountOthers(sJsonArg,nil)
	end	
end

--@brief	360实名
function  SettingManager:onName(element)
	local tshowPlatFormParams = {}
    tshowPlatFormParams.funType = "trueName"
    local sJsonArg = json.encode(tshowPlatFormParams)
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	if nil ~= curSdkObj then
		 CCLog("sJsonArg",sJsonArg)
		 curSdkObj:accountOthers(sJsonArg,nil)
	end	
end


--@brief	跳转平台回调函数
function  SettingManager:onEnterPlatform(element)

    WZLog("test........")
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    local config = curSdkObj.m_tConfig
    if curSdkObj then
        curSdkObj:setCallbackByName("logout",PassportDefaultCallback.logoutCallback,PassportDefaultCallback)
       if config.SDKOtherConfig.isOnEnterPlatform == "true" then
       WZLog("test........1")
       curSdkObj:enterPlatform(onEnterPlatform,nil)
    end
      end
end

--@brief	切换账号
--@note		针对某些没有自带切换账号功能的奇葩渠道（例如豌豆荚）做的账号切换
function SettingManager:onChangeAccount()
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	if curSdkObj then
        --curSdkObj:setCallbackByName("logout",PassportDefaultCallback.logoutCallback,PassportDefaultCallback)
		local sJSONData = {}
		sJSONData.funType = "logout"
		curSdkObj:accountOthers(json.encode(sJSONData),nil,nil)
	end
end

--@brief	注销按钮回调函数
function SettingManager:onLogOff()
	local tshowPlatFormParams = {}
    tshowPlatFormParams.funType = "onLogOff"
    local sJsonArg = json.encode(tshowPlatFormParams)
	local curSdkObj = PassportSdkManager:getCurSdkObj()
	if nil ~= curSdkObj then
	     curSdkObj:setCallbackByName("others",PassportDefaultCallback.logoutCallback,PassportDefaultCallback)
		 CCLog("sJsonArg",sJsonArg)
		 curSdkObj:accountOthers(sJsonArg,nil)
	end	
end

--@brief   越南语切换账号
function SettingManager:onAccount_vn_Click()
    CCUserDefault:sharedUserDefault():setStringForKey("AccountInfo_Vn", "")
    gotoFirstScene()
    --local curSdkObj = PassportSdkManager:getCurSdkObj()
	--if curSdkObj then
	--	local sJSONData = {}
	--	sJSONData.funType = "changeAccount"
	--	curSdkObj:accountOthers(json.encode(sJSONData),nil,nil)
	--end
end

-------------------------------------回调函数模块模块End----------------------------------------


-------------------------------------VIP回调函数模块模块Begin--------------------------------------

--@brief	VIP界面购买按钮回调函数
function SettingManager:onBuyClick(element)
	local vipType = g_tBuyType.TYPE_OTHER
	local vipId = 8
	local vipIconPath = "shopitems/expansioncard.png"
	WndPurchase:showBuyInterface( vipType , vipId , vipIconPath , WndVip , WndVip.buyVipCardSuccess, nil, "onBuyShowCallback" )	
end

-------------------------------------VIP回调函数模块模块End----------------------------------------




-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------







