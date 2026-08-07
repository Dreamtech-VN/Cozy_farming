--PassportDefaultCallback.lua
--@brief	第三方渠道登录返回默认实现类
--@date		2014/04/17
--@author	杨高山
--@note		第三方渠道登录返回默认实现类

PassportDefaultCallback = {
	paymentType = nil,
	pay_productedId = nil,
	pay_nNeedMony = nil,
	pay_idsms = nil,
	pay_sBuyShopName = nil,
	pay_shopNum = nil,
	pay_funcCallback = nil  ,
	pay_tCallbackObj = nil,
	isOpenedPaySelect = false,
	isNeedLogout = false,
}

-------------------------------------公有方法模块Begin--------------------------------------
--@brief    initSDK回调函数
--@return
function PassportDefaultCallback:initSDKCallback()

end

--@brief    initSDK回调函数
--@return
function PassportDefaultCallback:loginCallback()

end

--@brief    logout回调函数
--@return
function PassportDefaultCallback:logoutCallback(jsonArg)
    CCLuaLog("PassportDefaultCallback:logoutCallback" .. jsonArg)
    --SceneLogin:startLogin()
    if string.len(jsonArg)>1 then
	    local tResult = json.decode(jsonArg)
		if tResult["return"] == "gonglvspot" then --英雄论坛
			SceneCity:updateRedDotBuilding("help", true)
			return
		elseif tResult["return"] == "exitTactic" then --退出攻略
			--恢复音乐的播放
			SoundManager:resumeBackgroundMusic()
			return
		elseif tResult["return"] == "clubpot" then --英雄俱乐部
			WndCheckOther:showRed5()
			return
		elseif tResult["return"] == "shoppot" then --英雄商城
			SceneCity:updateRedDotBuilding("eliteShop", true)
			return
		elseif tResult["return"] == "spreadpot" then --英雄分享
        	SceneCity:updateRedDotBuilding("share", true)
        	return
        elseif tResult["return"] == "praypot" then --英雄分享
        	SceneCity:updateRedDotBuilding("pray", true)
        	return
		elseif tResult["return"] == "blocState" then --英雄商城
			g_bloc_tactic = tResult["tacticState"] --攻略
    		g_bloc_club = tResult["clubState"]--俱乐部
    		g_bloc_shop = tResult["shopState"]--精英商城
    		g_bloc_spread = "false" --分享按钮,由于是中途版本添加的方法，所以需要先判断是否有该执行函数
    		if PassportSdkManager.showHeoShare then
    			g_bloc_spread = tResult["spreadState"] 
    		end
    		g_bloc_pray = "false"
    		if PassportSdkManager.showHeroPray then
    			g_bloc_pray = tResult["prayState"]--祈愿
    		end
    		WndOwnCity:updateEliteShopAndHelpAndShare()
			return
		end
	end
    --PassportDefaultCallback:logoutCallback{"email":"william19880524@gmail.com","return":"fbBindSuccess"}
    if jsonArg then 
    	local tResult = json.decode(jsonArg)
    	WZLog("PassportDefaultCallback:logoutCallback",tResult)
    	if tResult["return"] == "fbBindSuccess" then
			ProtocolProcessorPrefetchCache:send_TASK_AddFaceBookNum(1,tResult["email"])
			return
		elseif tResult["return"] == "finsh_fyberVideo" then
			WndFyber:finsdhTask()
			return
		elseif tResult["return"] == "fail_fyberVideo" then
			WndFyber:failTask()
			return
		elseif tResult["return"] == "fbShareSuccess" then
			ProtocolProcessorPrefetchCache:send_TASK_AddFaceBookNum(3,"")
			PassportSdkManager.hasShare = true;
			return
		elseif tResult["return"] == "fbLinkSuccessVn" then
			CellTaskListItem:onFaceBookCallBack(4, "")
			return
		elseif tResult["return"] == "fbShareSuccessVn" then
			CellTaskListItem:onFaceBookCallBack(3, "")
			return
		elseif tResult["return"] == "fbBindAccountSuccess" then
			g_bindAccount = tResult["uid"]
			ProtocolProcessorAccount:send_ACCOUNT_Register(g_bindAccount,g_bindAccount,"")
			PassportSdkManager.m_bBindAccount = true;
			return
		elseif tResult["return"] == "deleteAccountVN" then
			if tResult["result"] and tResult["result"] == "1" then
				WZLog("PassportDefaultCallback:logoutCallback  deleteAccountVN success")
				MsgBoxManager:showTipBox(LocalStrings.DELETE_ACCOUNT_TEXT2, nil, nil, nil, nil)
				if PassportSdkManager.logout then
					PassportSdkManager:logout()
				end
			else
				WZLog("PassportDefaultCallback:logoutCallback  deleteAccountVN fail")
				MsgBoxManager:showTipBox(LocalStrings.DELETE_ACCOUNT_TEXT3, nil, nil, nil, nil)
			end
			return
		elseif tResult["return"] == "deleteAccountEnableVN" then
			local deleteAccountEnable = false
			if tResult["result"] and tResult["result"] == "1" then
				WZLog("PassportDefaultCallback:logoutCallback  deleteAccountEnableVN true")
				GlobalGame.g_bIsShowDelAccount = true
				deleteAccountEnable = true
			else
				WZLog("PassportDefaultCallback:logoutCallback  deleteAccountEnableVN false")
				GlobalGame.g_bIsShowDelAccount = false
				deleteAccountEnable = false
			end
			if WndSetting and WndSetting.m_root ~= nil then
				WndSetting:refreshDelAccountBtnState(deleteAccountEnable)
			end
			return
		end
    end 
    if WndLoadLuaResources.m_root ~= nil then
    	CCLuaLog("PassportDefaultCallback:logoutCallback22222")
    	PassportSdkManager:setLogoutState(true)
    	return
    end
    WndLoginSelect:loginOutGame()
end

--@brief    appVerUdate回调函数
--@return
function PassportDefaultCallback:appVerUdateCallback()

end

--@brief    enterPlatform回调函数
--@return
function PassportDefaultCallback:enterPlatformCallback()

end

--@brief    accountOthers回调函数
--@return
function PassportDefaultCallback:accountOthersCallback(jsonArg)
	CCLuaLog("PassportDefaultCallback:accountOthersCallback" .. jsonArg)
	local tResult = json.decode(jsonArg)
	WZLog("越南语返回信息",tResult.payment)
	if tResult["return"] == "showShop" then
		WndVip:showWndUI(0)
		return
	elseif tResult["return"] == "gonglvspot" then --英雄论坛
		SceneCity:updateRedDotBuilding("help", true)
		return
	elseif tResult["return"] == "clubpot" then --英雄俱乐部
		WndCheckOther:showRed5()
		return
	elseif tResult["return"] == "exitTactic" then --退出攻略
		--回复音乐的播放
		SoundManager:resumeBackgroundMusic()
		return
	elseif tResult["return"] == "shoppot" then --英雄商城
		SceneCity:updateRedDotBuilding("eliteShop", true)
		return
	elseif tResult["return"] == "spreadpot" then --英雄分享
        	SceneCity:updateRedDotBuilding("share", true)
	end
	if tResult["return"] == "fbBindSuccess" then
		ProtocolProcessorPrefetchCache:send_TASK_AddFaceBookNum(1,tResult["email"])
	elseif tResult["return"] == "finsh_fyberVideo" then
		WndFyber:finsdhTask()
	elseif tResult["return"] == "fail_fyberVideo" then
		WndFyber:failTask()
	elseif tResult["return"] == "fbShareSuccess" then
		ProtocolProcessorPrefetchCache:send_TASK_AddFaceBookNum(3,"")
	elseif tResult["return"] == "fbLinkSuccessVn" then
		CellTaskListItem:onFaceBookCallBack(4, "")
	elseif tResult["return"] == "fbShareSuccessVn" then
		CellTaskListItem:onFaceBookCallBack(3, "")
	elseif tResult["return"] == "fbBindAccountSuccess" then
		local account = tResult["uid"]
		ProtocolProcessorAccount:send_ACCOUNT_Register(account,account,"")
		PassportSdkManager.m_bBindAccount = true;
		return
	elseif tResult["return"] == "gp_success_promotion" then
		CCLuaLog("PassportDefaultCallback:accountOthersCallback gp_success_promotion")
		PassportDefaultCallback:payCallback(jsonArg)
  	elseif tResult["return"] == "iphoneSuccess" then
  		local key = tResult["key"]
  		local orderId = tResult["order"]
  		local channelId = ProjConfig:getChannelId()
  		local packageName = WGameCmUtil:GetBundleIdentifier()
  		if checkIsOpenIOSAutoRenewalSubscription() == true then 			
  			if tResult["productId"] ~= nil then
  				local productId = tResult["productId"] 
  				if productId == "yido_item_1399" then
	  				--WZLog("PassportDefaultCallback:accountOthersCallback:iphoneSuccess_auto",key,orderId,channelId,packageName)
	  				--PassportSdkManager:saveAppstoreKeyForAutoRenewal(key,orderId)
	  				ProtocolProcessorRecharge:send_PURCHASE_IOSSubscription(orderId, key ,channelId,packageName)
	  				return
  				end
  			end
  		end
  		--WZLog("PassportDefaultCallback:accountOthersCallback:iphoneSuccess",key,orderId,channelId)
  		PassportSdkManager:saveAppstoreKey(key,orderId)
  		ProtocolProcessorRecharge:send_PURCHASE_IOSSendProductCheckInfo(orderId, key ,channelId)
  	elseif tResult["return"] == "checkPermission_exist" then
  		WZLog("PassportDefaultCallback:accountOthersCallback:checkPermission_exist")
  		local result = tResult["result"]
  		local message = tResult["message"]
  		local funType = tResult["funType"]
  		WZLog("PassportDefaultCallback:accountOthersCallback:checkPermission_exist", result, message, funType)
  		if result ~= nil then
  			checkPermission_exist_callback(result, message, funType)
  		end
  	
	elseif tResult["return"] == "deleteAccountVN" then
		if tResult["result"] and tResult["result"] == "1" then
			WZLog("PassportDefaultCallback:accountOthersCallback  deleteAccountVN success")
			MsgBoxManager:showTipBox(LocalStrings.DELETE_ACCOUNT_TEXT2, nil, nil, nil, nil)
			if PassportSdkManager.logout then
				PassportSdkManager:logout()
			end
		else
			WZLog("PassportDefaultCallback:accountOthersCallback  deleteAccountVN fail")
			MsgBoxManager:showTipBox(LocalStrings.DELETE_ACCOUNT_TEXT3, nil, nil, nil, nil)
		end
		return
	elseif tResult["return"] == "deleteAccountEnableVN" then
		local deleteAccountEnable = false
		if tResult["result"] and tResult["result"] == "1" then
			WZLog("PassportDefaultCallback:accountOthersCallback  deleteAccountEnableVN true")
			GlobalGame.g_bIsShowDelAccount = true
			deleteAccountEnable = true
		else
			WZLog("PassportDefaultCallback:accountOthersCallback  deleteAccountEnableVN false")
			GlobalGame.g_bIsShowDelAccount = false
			deleteAccountEnable = false
		end
		if WndSetting and WndSetting.m_root ~= nil then
			WndSetting:refreshDelAccountBtnState(deleteAccountEnable)
		end
		return
	end
	if tResult.payment == "3" then
		PassportDefaultCallback.paymentType = 3
		PassportDefaultCallback.isOpenedPaySelect = true
	else
		if tResult.isPaying~=nil and tResult.isPaying == "YES" then
			WZLog("越南语开始支付信息",PassportDefaultCallback.pay_productedId,PassportDefaultCallback.pay_nNeedMony)
			MonthCardBuy(PassportDefaultCallback.pay_productedId,PassportDefaultCallback.pay_nNeedMony,PassportDefaultCallback.pay_idsms,PassportDefaultCallback.pay_sBuyShopName,PassportDefaultCallback.pay_shopNum,PassportDefaultCallback.pay_funcCallback, PassportDefaultCallback.pay_tCallbackObj)
		else
			return
		end
   end
end

--@brief    支付回调函数
--@return
function PassportDefaultCallback:payCallback(jsonArg)
  WZLog("PassportDefaultCallback:payCallback:",jsonArg)
  local tResult = json.decode(jsonArg)
  --支付取消或者失败
  if tResult["return"] == "fail" or tResult["return"] == "cancel" then
  	PassportSdkManager:postHeroOrder(1)
  	PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep7,g_payEventId)
  	WndVip:closeLoadingUI()

  	--add by qixiang
  	if (WndNewActivity and WndNewActivity.m_root) or (WndSumVacAct and WndSumVacAct.m_root) then --周年活动界面存在说明在周年活动界面进行充值
  		WndNewActivity:resetLocalRechargeInfo()
  	end
  	if (WndApartmentAct and WndApartmentAct.m_root) then --小推车进行充值
  		WndNewActivity:resetLocalRechargeInfo()
  	end
  elseif tResult["return"] == "gp_success" then --google支付成功
  	local tData = {}
  	tData.productId = tResult["productId"]
  	tData.token = tResult["payToken"]
  	tData.payMessage = tResult["payMessage"]
  	if CacheCenter:getPlayerInfo() then
  		tData.playerId = CacheCenter:getPlayerInfo().id 
  	else
  		tData.playerId = ""
  	end
  	local sPackageName = WGameCmUtil:GetBundleIdentifier()
  	tData.packageName = sPackageName
  	local url = "http://47.91.79.220:80/wydpay/GooglePlayNotifyServlet"
  	if sPackageName == "com.wyd.gplay.bombheroes" or sPackageName == "com.wyd.brgp.bombheroes" then
  		url = "http://eat.ddd2.bombheroes.com/wydpay/GooglePlayNotifyServlet"
  	elseif sPackageName == "com.bombmaster.mg" then
  		url = "http://eut.ddd2.bombomg.com/wydpay/GooglePlayNewNotifyServlet"
  	elseif sPackageName == "com.wyd.gplay.bombheroesen" then
  		--47.91.79.220
  		url = "http://eut.ddd2.bombomg.com/wydpay/GooglePlayEuropeNotifyServlet"
  	elseif sPackageName == "com.wyd.gplay.heroibomba" then
  		--47.91.79.220
  		url = "http://eut.ddd2.bombomg.com/wydpay/GooglePlayEUPTNotifyServlet"
  	end
  	local sPostData = json.encode(tData)
  	WZLog("PassportDefaultCallback:payCallback:",sPackageName,url,sPostData)
	local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
	local downLoadInfoTask = nil
	downLoadInfoTask = WZHTTPPostDataLuaTask:createWithTimeout(1, url, "data="..sPostData, 60, 60)--create(1, url,sPostData,nil, nil)
	mulThreadSystem:addDownloadTask(downLoadInfoTask) 
	elseif tResult["return"] == "gp_success_promotion" then
		CCLuaLog("PassportDefaultCallback:payCallback gp_success_promotion")
		local tData = {}
	  	tData.productId = tResult["productId"]
	  	tData.token = tResult["payToken"]
	  	tData.payMessage = tResult["payMessage"]
	  	if CacheCenter:getPlayerInfo() then
	  		tData.playerId = CacheCenter:getPlayerInfo().id 
	  	else
	  		tData.playerId = ""
	  	end
	  	local sPackageName = WGameCmUtil:GetBundleIdentifier()
	  	tData.packageName = sPackageName
	  	local sPostData = json.encode(tData)
	  	WZLog("PassportDefaultCallback:payCallback gp_success_promotion:",sPackageName,sPostData)
	  	if ProtocolProcessorRecharge ~= nil then
	  		ProtocolProcessorRecharge:send_PURCHASE_GoogleSendProductCheckInfo(tData.packageName, tData.productId, tData.token, tonumber(ProjConfig:getChannelId()))
	  	end
  	elseif tResult["return"] == "iphoneSuccess" then
  		local key = tResult["key"]
  		local orderId = tResult["order"]
  		local channelId = ProjConfig:getChannelId()
  		local packageName = WGameCmUtil:GetBundleIdentifier()
  		if checkIsOpenIOSAutoRenewalSubscription() == true then 			
  			if tResult["productId"] ~= nil then
  				local productId = tResult["productId"] 
  				if productId == "yido_item_1399" then
	  				--WZLog("PassportDefaultCallback:payCallback:iphoneSuccess_auto",key,orderId,channelId,packageName)
	  				PassportSdkManager:saveAppstoreKeyForAutoRenewal(key,orderId)
	  				ProtocolProcessorRecharge:send_PURCHASE_IOSSubscription(orderId, key ,channelId,packageName)
	  				return
  				end
  			end
  		end
  		--WZLog("PassportDefaultCallback:payCallback:iphoneSuccess",key,orderId,channelId)
  		PassportSdkManager:saveAppstoreKey(key,orderId)
  		ProtocolProcessorRecharge:send_PURCHASE_IOSSendProductCheckInfo(orderId, key ,channelId)  		
  	elseif tResult["return"] == "iphoneSuccess_auto" then
  		local key = tResult["key"]
  		local orderId = tResult["order"]
  		local channelId = ProjConfig:getChannelId()
  		local packageName = WGameCmUtil:GetBundleIdentifier()
  		WZLog("PassportDefaultCallback:payCallback:iphoneSuccess_auto",key,orderId,channelId,packageName)
  		PassportSdkManager:saveAppstoreKeyForAutoRenewal(key,orderId)
  		ProtocolProcessorRecharge:send_PURCHASE_IOSSubscription(orderId, key ,channelId,packageName)
  	end
end

--@brief    purchaseOthers回调函数
function PassportDefaultCallback:purchaseOthersCallback(jsonArg)
	WZLog("PassportDefaultCallback:purchaseOthersCallback" .. jsonArg)
	local tResult = json.decode(jsonArg)
	local vipList = CacheCenter:getVipList()
	for i1,v1 in pairs(vipList) do
		for i2,v2 in ipairs(tResult) do
		 	if v1.payCodeId == v2.ProductId then
		 		vipList[i1].showPrice = v2.ProductPrice
			end
		end
	end
	WndVip:showWndUIRecharge()
end

--@brief    getPurchaseInfo获取支付信息
--@param   productedId  月卡类型（1 初级月卡，2 高级月卡，3 至尊月卡）
--@param   nNeedMony  月卡所需金额
--@param   idsms      商品ID
--@param   sBuyShopName  商品名称
--@param   shopNum       商品数量
--@param   funcCallback 回调对象方法
--@param   tCallbackObj  回调方法所在lua表
--@return
function PassportDefaultCallback:getPurchaseInfo(productedId,nNeedMony,idsms,sBuyShopName,shopNum,funcCallback, tCallbackObj)
	PassportDefaultCallback.pay_productedId = productedId
	PassportDefaultCallback.pay_nNeedMony = nNeedMony
	PassportDefaultCallback.pay_idsms = idsms
	PassportDefaultCallback.pay_sBuyShopName = sBuyShopName
	PassportDefaultCallback.pay_shopNum = shopNum
	PassportDefaultCallback.pay_funcCallback = funcCallback  
	PassportDefaultCallback.pay_tCallbackObj = tCallbackObj
	WZLog("PassportDefaultCallback:getPurchaseInfo",PassportDefaultCallback.productedId)
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
