--PassportSdkManager.lua
--@brief	第三方渠道管理类
--@date		2014/03/21
--@author	xiaoyu_wu
--@note		第三方渠道管理类

PassportSdkManager = {
      m_tSdkNameList = nil, --渠道类sdk名称表
      m_tCurSdkObj = nil, --当前使用的sdk表对
      m_payParam = nil,--支付参数
      isNeedLogout = false, -- 是哦否需要登出
      b_hasCheckPay = false, --是否有验证过苹果皮补单
      b_hasCheckPayForAutoRenewal = false, --是否有验证过苹果皮补单(自动续订)
      b_hasResetPayDatasAuto = false, --是否有设置过苹果订单本地保存数据(自动续订)
      b_createRole = false, --是否创建角色，用于传送数据 
      s_roleCreateTime = "", --创建角色的时间
      n_orderTime = nil,
      s_paymentId = nil,
      s_paymentEmail = nil,
      hasShare = false,
      m_bBindAccount = false,
      s_googleAdvertiseId = "unknown",
      t_appStoreAutoDatas = nil,
      m_sPurchaseType = "purchase",--越南事件统计需求记录支付痕迹 所有充值操作:"purchase",首次充值:"purchase_new",购买战令:"purchase_bpass",每日必购:"purchase_dailygift"
}

-------------------------------------公有方法模块Begin--------------------------------------
--@brief    从配置文件中获得sdk列表
--@return   #1,sdk名称表
function PassportSdkManager:getSdkList()
    self.m_tSdkNameList = SDK_Util:getSDKsByTypeFromConfigFile("passport") or {}
    return self.m_tSdkNameList
end


--设置isNeedLogout状态
function PassportSdkManager:setLogoutState(bLogout)
  self.isNeedLogout = bLogout
end

--获得isNeedLogout状态
function PassportSdkManager:getLogoutState()
  return self.isNeedLogout
end

--@brief    根据sdk名称初始化sdk
--@param    sSdkName,sdk名称
--@note     sSdkName为空时默认使用sdk列表中的第一个初始化
function PassportSdkManager:initSdkWithName(sSdkName)
    if sSdkName == nil then
        if self.m_tSdkNameList == nil then
            self:getSdkList()
        end
        sSdkName = self.m_tSdkNameList[1]
    end
    if sSdkName == nil then
        CCLuaLog("PassportSdkManager:initSdkWithName sdk name is nil!")
        return
    end
    CCLuaLog("PassportSdkManager:initSdkWithName" .. sSdkName)
    local tSdkLuaObj = SDK_Passport:create(sSdkName)
    if tSdkLuaObj == nil then
        CCLuaLog("PassportSdkManager:initSdkWithName create "..sSdkName.." sdk lua object fail!")
        return
    end
    tSdkLuaObj:initSDK()
    return tSdkLuaObj
end

--@brief  判断是否需要调用第三方渠道登入
--@return true为需要，false为不需要
function PassportSdkManager:needLogin()
  local curSdkObj = self:getCurSdkObj()
  if curSdkObj then
    local config = curSdkObj.m_tConfig
    if config.SDKOtherConfig.isChannelLogin ~= "true" then --动态自定义支付界面
      return false
    end
  else
    return false
  end
  return true
end

--@brief    调用第三方SDK登出接口
--@param    callBack:回调方法
--@param    tSdkLuaObj,sdk表对象
--@param    params:扩展参数
function PassportSdkManager:logout()
  local curSdkObj = self:getCurSdkObj()
  if curSdkObj then
    curSdkObj:logout(PassportDefaultCallback.logoutCallback, PassportDefaultCallback)
  end
  WZLog("PassportSdkManager:logout") 
end

--@brief    调用第三方SDK登入接口
--@param    callBack:回调方法
--@param    tSdkLuaObj,sdk表对象
--@param    params:扩展参数
function PassportSdkManager:doLogin(callBack, luaTable, params)
  --self:getGoogleAdId()
  local curSdkObj = self:getCurSdkObj()
  curSdkObj:login(params or "", callBack, luaTable)
  PostPlayerEvent:postEvent(PostPlayerEvent.event_startSDKLogin)
  WZLog("PassportSdkManager:doLogin", config)
  --self:getGoogleAdId()
end

--@brief    设置当前使用的sdk表对象
--@param    tSdkLuaObj,sdk表对象
function PassportSdkManager:setCurSdkObj(tSdkLuaObj)
    self.m_tCurSdkObj = tSdkLuaObj
end


--@brief    获取当前使用的sdk表对象
--@return   #1,sdk表对象
function PassportSdkManager:getCurSdkObj()
    return self.m_tCurSdkObj
end

--@brief    获取包的渠道号
--@return   #1,渠道号
function PassportSdkManager:getChannelId()
     self.m_nChannelId = WZFileUtil:getNodeValueFromXml("ChannelId")
     CCLuaLog("PassportSdkManager:getChannelId" .. self.m_nChannelId)
     return tonumber(self.m_nChannelId) or 0
end

--@brief    根据渠道号构建sdk
function PassportSdkManager:initSdk()
    CCLuaLog("PassportSdkManager:initSdk")
    self:getChannelId()
    self.m_tCurSdkObj = self:initSdkWithName()
    self:getGoogleAdId()
    -- if self.setInAppMessageListenerVN then 
    --     self:setInAppMessageListenerVN()
    -- end
end


--@brief	跳转到充值页面的接口
--@param    tag
function PassportSdkManager:gotoPaymentPage(tag, bNeedUpdate)
    CCLuaLog("PassportSdkManager:gotoPaymentPage 0")
	if CacheCenter:getPlayerInfo().level < GDatatab_button_info["id_34"].open_level then
        MsgBoxManager:showTipBox(GDatatab_button_info["id_34"].feedback_info)
		return
	end
	local nTag = 0
	if tag ~= nil then nTag = tag end 
    WndVip:showWndUI(nTag, bNeedUpdate)
end

--@brief sdk支付调用

--@param callBack:支付回调
--@param backTable:回调表
function PassportSdkManager:pay()
    WZLog("PassportSdkManager:pay")
    local _payParam = {}
    --支付基本参数
    _payParam.price = self.m_payParam.price                --商品价格
    _payParam.productName = self.m_payParam.productName    --商品名称
    _payParam.payCode = self.m_payParam.payCode            --商品序列号
    _payParam.itemId = self.m_payParam.payCode            --商品序列号
    _payParam.orderNum = self.m_payParam.orderNum          --订单号
    _payParam.productDesc = self.m_payParam.productDesc    --商品描述
    _payParam.quantifier = self.m_payParam.quantifier      --商品单位
    _payParam.number = self.m_payParam.number              --商品数量
    _payParam.payType = self.s_paymentId or "google"
    _payParam.email = self.s_paymentEmail or "no email"
    _payParam.unit = tonumber(_payParam.price)/tonumber(_payParam.number)   --商品单价
    --支付扩展参数
    local playInfo = CacheCenter:getPlayerInfo()
    _payParam.id = playInfo.id              --角色id
    _payParam.name = Filter_spec_chars(playInfo.name)          --角色名称
    _payParam.level = playInfo.level        --角色等级
    _payParam.vipLevel = playInfo.vipLevel  --vip等级
    _payParam.guildName = Filter_spec_chars(playInfo.guildName) --公会名称
    local moneyList = CacheCenter:getMoneyList()
    _payParam.balance = moneyList.blueDiamond
    --服务器,游戏相关参数
    _payParam.serverId = IPDhttpServer:getCurServerId()     --服务器id
    _payParam.serverName = IPDhttpServer:getCurServerName() --服务器名称
    -- _payParam.gameName = IPDhttpServer:getCurServerName() --游戏名称
    self.n_orderTime = os.date("%Y")..os.date("%m")..os.date("%d")..os.date("%H")..os.date("%M")..os.date("%S")
    self:postHeroOrder(-1)
    WZLog("PassportSdkManager:pay:",tonumber(ProjConfig.ChannelId))
    local heroProductName = "".._payParam.number.._payParam.productName
    -- if tostring(ProjConfig:getChannelId()) == "57" then
    --   self:payWebHero(_payParam.orderNum,heroProductName,_payParam.price,_payParam.serverId,_payParam.serverName,_payParam.id,playInfo.name )
    --   return
    -- end
        --越南语包的修改
    local packName = WGameCmUtil:GetBundleIdentifier()
    --英雄包的网页支付
    if WZUISystem:getInstance():getPlatformInfo() ~= 1 and packName == "com.wyd.dandandao.hero" then
      local url = "https://wp1.0sdk.com/wbp/index.html?vType=1&productId=D10210A&clientId=eae9ktibcbjtpi2ca52p&projectId=P33093A&loginName=%s&serverID=M1195A&propId=%s&propName=%s&amount=%s&selfDefine=%s"
      url = string.format(url,gChannelUid.."@cp_ddd",_payParam.payCode,URLEscape(_payParam.productName),_payParam.price,_payParam.orderNum)
      WZLog(url)
      WZPush:openURL(url)
      return
    end
    if ProjConfig.LANGUAGE == "vn" or packName == "com.wyd.gunpow" then
       _payParam.id = string.sub(g_tAccountData.accountName, 4, string.len(g_tAccountData.accountName))
       WZLog("JJJJJJJJJ3:", g_tAccountData.accountName, _payParam.id) 
      if _payParam.payCode == "com.wyd.gunpow.item15" then
        _payParam.price = "15000"
      elseif _payParam.payCode == "com.wyd.gunpow.item200" then
        _payParam.price = "20000"
      elseif _payParam.payCode == "com.wyd.gunpow.item500" then
        _payParam.price = "50000"
      elseif _payParam.payCode == "com.wyd.gunpow.item1000" then
        _payParam.price = "100000"
      elseif _payParam.payCode == "com.wyd.gunpow.item2000" then
        _payParam.price = "200000"
      elseif _payParam.payCode == "com.wyd.gunpow.item5000" then
        _payParam.price = "500000"
      elseif _payParam.payCode == "com.wyd.gunpow.item10000" then
        _payParam.price = "1000000"
      elseif _payParam.payCode == "com.wyd.gunpow.monthly50" then
        _payParam.price = "50000"
      elseif _payParam.payCode == "com.wyd.gunpow.monthlyguild50" then
        _payParam.price = "50000"
      elseif _payParam.payCode == "com.wyd.gunpow.battlepass2000" then
        _payParam.price = "200000"
      --越南新包的
      elseif _payParam.payCode == "com.gp.mobi.item200" then
        _payParam.price = "20000"
      elseif _payParam.payCode == "com.gp.mobi.item500" then
        _payParam.price = "50000"
      elseif _payParam.payCode == "com.gp.mobi.item1000" then
        _payParam.price = "100000"
      elseif _payParam.payCode == "com.gp.mobi.item2000" then
        _payParam.price = "200000"
      elseif _payParam.payCode == "com.gp.mobi.item5000" then
        _payParam.price = "500000"
      elseif _payParam.payCode == "com.gp.mobi.item10000" then
        _payParam.price = "1000000"
      elseif _payParam.payCode == "com.gp.mobi.monthly50" then
        _payParam.price = "50000"
      elseif _payParam.payCode == "com.gp.mobi.monthlyguild50" then
        _payParam.price = "50000"
      end
    end
    WZLog("PassportSdkManager:pay id :",_payParam.id)
    local sJson = json.encode(_payParam)

    --qq大厅支付
    if isChannelQQHall() and WQQGameHelper then
      WZLog("PassportSdkManager:qqhall pay")
      _payParam.cmd = "pay"
      _payParam.action = "buy"
      _payParam.sandbox = WQQGameHelper.sandbox
      _payParam.appId = WQQGameHelper.appId
      _payParam.appKey = WQQGameHelper.appKey
      _payParam.openId = WQQGameHelper.openId
      _payParam.openKey = WQQGameHelper.openKey
      _payParam.pf = WQQGameHelper.pf
      _payParam.pfKey = WQQGameHelper.pfKey
      _payParam.zoneId = WQQGameHelper.zoneId
      sJson = json.encode(_payParam)
      WQQGameHelper:on_start_purchase(sJson)
      return
    end

    --flash大厅支付
    if isChannelFlashHall() and WGameHelperFlash then
        local tempJson = json.decode(_payParam.orderNum)
        _payParam.orderNum = tempJson["url"] or ""
        sJson = json.encode(_payParam)
        WGameHelperFlash:on_start_purchase(sJson)
        return
    end
    
    --360大厅支付
    if isChannel360Hall() and WGameHelper360 then
        print("PassportSdkManager:pay === 360", sJson)
        WGameHelper360:on_start_purchase(sJson)
        WndVip:closeLoadingUI()
        return
    end

    WZLog("PassportSdkManager:pay:",sJson)
    local curSdkObj = self:getCurSdkObj()
    if curSdkObj then
      PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep6,g_payEventId)
      self.n_orderTime = os.date("%Y")..os.date("%m")..os.date("%d")..os.date("%H")..os.date("%M")..os.date("%S")
      self:postHeroOrder(-1)
      WZLog("PassportSdkManager:pay:",sJson)
      PostPlayerEvent:postEvent(PostPlayerEvent.event_starPaySDK)
      curSdkObj:doPay(sJson, PassportDefaultCallback.payCallback, PassportDefaultCallback)
    end
end

--@param state:-1支付，0成功，1失败
function PassportSdkManager:postHeroOrder(_state)
  if self.m_payParam == nil then return end
  local data = {}
  data.orderId = self.m_payParam.orderNum
  data.thirdOrderId = self.m_payParam.orderNum
  data.state = _state
  data.orderTime = self.n_orderTime
  data.orderAmount =  self.m_payParam.price * 100
  data.charge = self.m_payParam.number
  data.donate = self.m_payParam.giftNumber
  data.goldType = 0
  data.orderType  = self.m_payParam.id
  data.roleName = CacheCenter:getPlayerInfo().name
  data.level = CacheCenter:getPlayerInfo().level
  data.vipLevel = CacheCenter:getPlayerInfo().vipLevel
  PostPlayerEvent:postEvent(PostPlayerEvent.event_playerorder,data)
end

--@brief 获取订单号
--@param tData：支付锁需传参数，必带。id：产品id，price:价格；productName:商品名称；payCode:商品号
function PassportSdkManager:getOrderNum(tData,payChannel)
  WZLog("PassportSdkManager:getOrderNum",tData.payCode, tData.id);
  if whetherCloseRecharge() then
      return 
  end
  --苹果支付就不去请求订单号了，直接支付
  if self:payAppStore(tData.payCode) then
    return
  end
  self.m_payParam = {}
  self.m_payParam.id = tData.id
  self.m_payParam.giftNumber = tData.giftNumber
  self.m_payParam.quantifier = tData.quantifier
  self.m_payParam.price = tData.price
  self.m_payParam.number = tData.number
  self.m_payParam.giftNumber = tData.giftNumber
  self.m_payParam.productName = tData.productName
  self.m_payParam.payCode = tData.payCode
  self.m_payParam.productDesc = tData.productDesc
  local channelId =  payChannel or ProjConfig:getChannelId()
  local payChannelId = payChannel or ProjConfig:getChannelId()
  --qq大厅支付
  if isChannelQQHall() then
    local openid = WQQGameHelper.openId
    local openkey = WQQGameHelper.openKey
    local pf= WQQGameHelper.pf
    local pfkey = WQQGameHelper.pfKey
    local zoneid = WQQGameHelper.zoneId
    ProtocolProcessorRecharge:send_PURCHASE_QQGameHallBuyCheckInfo(channelId, tData.id, openid, openkey, pf, pfkey, zoneid)
    return
  end

  if isChannelFlashHall() then
      local gkey = WGameHelperFlash.gkey
      local serverId = IPDhttpServer:getCurServerId()
      local uid = WGameHelperFlash.uid
      local money = math.floor(tonumber(tData.price)) .. ""
      local productName = tData.productName
      local ext = tData.id
      local callbackInfo = WGameHelperFlash.callback_info
      local sign = ""
      local pageType = "1"
      local size = "200"
      ProtocolProcessorRecharge:send_PURCHASE_FlashBuyCheckInfo(channelId, gkey, serverId, uid, money, productName, ext, callbackInfo, sign, pageType, size)
      return
  end

  if isChannel360Hall() then
  end

  local curSdkObj = self:getCurSdkObj()
  ProtocolProcessorRecharge:send_PURCHASE_RequestSmsCodeSerialid(tData.id,channelId,payChannelId)
end

--@brief 是否为苹果支付
function PassportSdkManager:bAppStorePay()
  local curSdkObj = self:getCurSdkObj()
  if curSdkObj then
    local config = curSdkObj.m_tConfig
    if config.SDKOtherConfig.isNeedListToAppStore == "true" then --动态自定义支付界面
      return true
    end
  end
  return false
end

--@brief 苹果渠道支付
--@param bRepair:是否需要补单
--@param paycode:商品号
function PassportSdkManager:payAppStore(paycode, bRepair)
  if self:bAppStorePay() then
      local _payParam = {}
      _payParam.payCode = paycode             --商品序列号
      if bRepair then
        _payParam.action = "restoreCompletedTransactions"  
      end
      local sJson = json.encode(_payParam)
      local curSdkObj = self:getCurSdkObj()
      PostPlayerEvent:postEvent(PostPlayerEvent.event_starPaySDK)
      curSdkObj:doPay(sJson, PassportDefaultCallback.payCallback, PassportDefaultCallback)
      return true
  end
  return false
end

--@brief 存储苹果支付key-自动续订
--@param key:appStore支付返回来的key
function PassportSdkManager:saveAppstoreKeyForAutoRenewal1(key,orderId)
  CCLuaLog("PassportSdkManager:saveAppstoreKeyForAutoRenewal:=====\n" .. key .. "-" .. orderId)
  local data = WZDataFile:getInstance():getUserData()
  if data then
      local orderIds = data:getStringValue("payDataForAutoRenewal", "appStoreOrdersAuto")
      if orderIds and orderIds ~= "" then
          orderIds = orderIds.."#"..orderId
      else
          orderIds = orderId
      end
      CCLuaLog("PassportSdkManager:saveAppstoreKeyForAutoRenewal-orderIds\n" .. orderIds)
      data:setStringValue("payDataForAutoRenewal", "appStoreKeyAuto_"..orderId, key)
      data:setStringValue("payDataForAutoRenewal", "appStoreOrdersAuto", orderIds)
      data:flush()
  end

end

--@brief 获取本地缓存的苹果自动续订的验证数据
function PassportSdkManager:resetAppStorePayDataForAutoRenewal()
    CCLuaLog("PassportSdkManager:resetAppStorePayDataForAutoRenewal")
    self.b_hasResetPayDatasAuto = false
    local data = WZDataFile:getInstance():getUserData()
    self.t_appStoreAutoDatas = {}
    if data then      
        self.b_hasResetPayDatasAuto = false
        local orderIds = data:getStringValue("payDataForAutoRenewal", "appStoreOrdersAuto") or ""
        CCLuaLog("PassportSdkManager:resetAppStorePayDataForAutoRenewal-orderIds\n" .. orderIds)
        local tab = SplitStringWithSeparator(orderIds, "#") or {}
        if #tab > 0 then
            for i= 1,#tab do
                local mykey = data:getStringValue("payDataForAutoRenewal", "appStoreKeyAuto_"..tab[i])
                CCLuaLog("PassportSdkManager:resetAppStorePayDataForAutoRenewal-key-order")
                if tab[i] ~= nil and tab[i] ~= "" and mykey ~= nil and mykey ~= "" then
                    CCLuaLog("" .. tab[i] .. "-" .. mykey)
                    local payData = {}
                    payData.key = mykey
                    payData.orderId = tab[i]
                    table.insert(self.t_appStoreAutoDatas, payData)
                end
                if i == #tab then
                    self.b_hasResetPayDatasAuto = true
                end
            end
        else
            self.b_hasResetPayDatasAuto = true
        end
    else
        self.b_hasResetPayDatasAuto = true
    end
    return self.t_appStoreAutoDatas
end

--@brief 获取苹果自动续订的验证数据-变量
function PassportSdkManager:getAppStorePayDataForAutoRenewal()
    CCLuaLog("PassportSdkManager:getAppStorePayDataForAutoRenewal")
    return self.t_appStoreAutoDatas
end

--@brief 苹果自动续订检查漏单-每次发送一条订阅协议发送订阅协议后置空本地保存的当条报文数据
function PassportSdkManager:checkAppStorePayDataForAutoRenewal()
    CCLuaLog("PassportSdkManager:checkAppStorePayDataForAutoRenewal")
    local curSdkObj = self:getCurSdkObj()
    if not curSdkObj then
        return false
    end
    if self.b_hasResetPayDatasAuto == false then
        return true
    end
    if self.t_appStoreAutoDatas ~= nil and #self.t_appStoreAutoDatas > 0 then
        local payData = self.t_appStoreAutoDatas[1]
        local key = payData.key
        local orderId = payData.orderId
        if key ~= nil and key ~= "" and orderId ~= nil and orderId ~= "" then
            CCLuaLog("PassportSdkManager:checkAppStorePayDataForAutoRenewal ========= orderId:" .. orderId)
            local channelId = ProjConfig:getChannelId()
            local packageName = WGameCmUtil:GetBundleIdentifier()
            --发送支付验证协议
            ProtocolProcessorRecharge:send_PURCHASE_IOSSubscription(orderId,key,channelId,packageName)
            table.remove(self.t_appStoreAutoDatas, 1)
            local data = WZDataFile:getInstance():getUserData()
            if data then
                local orderIds = data:getStringValue("payDataForAutoRenewal", "appStoreOrdersAuto") or ""
                CCLuaLog("PassportSdkManager:checkAppStorePayDataForAutoRenewal-orderIds1\n" .. orderIds)
                local tab = SplitStringWithSeparator(orderIds, "#") or {}
                orderIds = ""
                for i= 1,#tab do
                    CCLuaLog("PassportSdkManager:checkAppStorePayDataForAutoRenewal-key-order")
                    if tab[i] ~= nil and tab[i] ~= "" and tab[i] ~= orderId then
                        CCLuaLog("" .. tab[i])                        
                        if orderIds and orderIds ~= "" then
                            orderIds = orderIds.."#"..tab[i]
                        else
                            orderIds = tab[i]
                        end
                    end
                end
                CCLuaLog("PassportSdkManager:checkAppStorePayDataForAutoRenewal-orderIds2\n" .. orderIds)
                data:setStringValue("payDataForAutoRenewal", "appStoreKeyAuto_"..orderId, "")
                data:setStringValue("payDataForAutoRenewal", "appStoreOrdersAuto", orderIds)
                data:flush()
            end
        end
        return true
    else  
        return false
    end    
end


--@brief 存储苹果支付key--自动续订
--@param key:appStore支付返回来的key
function PassportSdkManager:saveAppstoreKeyForAutoRenewal(key,orderId)
  WZLog("PassportSdkManager:saveAppstoreKeyForAutoRenewal:",key, orderId)
  local data = WZDataFile:getInstance():getUserData()
  if data then
        data:setStringValue("payDataForAutoRenewal", "appStoreKeyAuto", key)
        data:setStringValue("payDataForAutoRenewal", "appStoreOrderAuto", orderId)
        data:flush()
  end
end

--@brief 苹果支付验证漏单支付--自动续订
function PassportSdkManager:payAppstoreCheckForAutoRenewal()
  WZLog("PassportSdkManager:payAppstoreCheckForAutoRenewal")
  --ProtocolProcessorRecharge:send_PURCHASE_IOSSubscrip()
  if self.b_hasCheckPayForAutoRenewal then
    return
  end
  self.b_hasCheckPayForAutoRenewal = true
  local data = WZDataFile:getInstance():getUserData()
  if data then
        local key = data:getStringValue("payDataForAutoRenewal", "appStoreKeyAuto")
        local orderId = data:getStringValue("payDataForAutoRenewal", "appStoreOrderAuto")
        if key ~= nil and key ~= "" and orderId ~= nil and orderId ~= nil then
            local channelId = ProjConfig:getChannelId()
            local packageName = WGameCmUtil:GetBundleIdentifier()
            --发送支付验证协议
            ProtocolProcessorRecharge:send_PURCHASE_IOSSubscription(orderId,key,channelId,packageName)
        end
  end
end

--@brief 判断是否开启苹果自动续订订阅
function PassportSdkManager:checkIsOpenIOSAutoRenewalSubscription()
    WZLog("PassportSdkManager:checkIsOpenIOSAutoRenewalSubscription")
    local channelid = tonumber(ProjConfig:getChannelId())
    if channelid == 1102 then
        return true
    end
    return false
end

--@brief 存储苹果支付key
--@param key:appStore支付返回来的key
function PassportSdkManager:saveAppstoreKey(key,orderId)
  WZLog("PassportSdkManager:saveAppstoreKey:",key, orderId)
  local data = WZDataFile:getInstance():getUserData()
  if data then
        local playId = CacheCenter:getPlayerInfo().id
        data:setStringValue("payData"..playId, "appStoreKey", key)
        data:setStringValue("payData"..playId, "appStoreOrder", orderId)
        data:flush()
  end
end

--@brief 苹果支付验证漏单支付
function PassportSdkManager:payAppstoreCheck()
  WZLog("PassportSdkManager:payAppstoreCheck")
  if self.b_hasCheckPay then
    return
  end
  self.b_hasCheckPay = true
  local data = WZDataFile:getInstance():getUserData()
  if data then
        local playId = CacheCenter:getPlayerInfo().id
        local key = data:getStringValue("payData"..playId, "appStoreKey")
        local orderId = data:getStringValue("payData"..playId, "appStoreOrder")
        if key ~= nil and key ~= "" and orderId ~= nil and orderId ~= nil then
          local channelId = ProjConfig:getChannelId()
          ProtocolProcessorRecharge:send_PURCHASE_IOSSendProductCheckInfo(orderId, key ,channelId)
        end
  end
end

--brief 谷歌支付-兑换码检测
function PassportSdkManager:payGooglePromotionCheck()
  local platForm =  WZUISystem:getInstance():getPlatformInfo()
  WZLog("PassportSdkManager:payGooglePromotionCheck:", platForm)
  if platForm == 2 then
    local curSdkObj = self:getCurSdkObj()
      if curSdkObj then
          local data ={}
          data.funType = "getGPPromotionData"
          local sJsonArg = json.encode(data)
          if PassportDefaultCallback then
            WZLog("PassportSdkManager:payGooglePromotionCheck:1")
            if PassportDefaultCallback.accountOthersCallback then

            WZLog("PassportSdkManager:payGooglePromotionCheck:2")
            end
          end
          curSdkObj:setCallbackByName("others",PassportDefaultCallback.accountOthersCallback, PassportDefaultCallback)
          curSdkObj:accountOthers(sJsonArg, PassportDefaultCallback.accountOthersCallback,PassportDefaultCallback)
          --curSdkObj:accountOthers(sJsonArg, PassportSdkManager.getGoogleAdIdCallback,PassportSdkManager)
      end
  end
end

--@brief 获取订单号
--@param orderNum:订单号
function PassportSdkManager:getOrderNumOK(orderNum)
  WZLog("PassportSdkManager:getOrderNumOK", orderNum);
  self.m_payParam.orderNum = orderNum
  PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep5,g_payEventId)
  self:pay()
end

--@brief 英雄网页内嵌支付
--@param 支付需要参数
function PassportSdkManager:payWebHero(orderId,propName,amount,serverId,serverName,roleId,roleName)
  -- if true then
  --   return
  -- end
  local sPostData = json.encode({})
  local url = string.format(
    "http://other.yingxiong.com/sdkext/ext/pay/ddd?attr.orderId=%s&attr.propName=%s&attr.amount=%s&attr.serverId=%s&attr.serverName=%s&attr.roleId=%s&attr.roleName=%s"
    ,orderId,URLEscape(propName),amount,serverId,URLEscape(serverName),roleId,URLEscape(roleName))
  print("HHHHHHHHHHH:"..url)
  WZPush:openURL(url)
  -- local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
  -- local downLoadInfoTask = nil
  -- downLoadInfoTask = WZHTTPPostDataLuaTask:create(1, url,sPostData,PassportSdkManager.payCallback, PassportSdkManager)
end

function PassportSdkManager:payCallback(nTaskId, sResponse, nTotalSize, nNowSize, bFinished, bFailed)
    if bFinished then --成功
    WZLog("PassportSdkManager:payCallback success", sResponse)
    elseif bFailed then --失败
        WZLog("PassportSdkManager:payCallback failed")
    end
end

--@brief 苹果正版渠道去申请序列号
--@param productId:产品Id列表
function PassportSdkManager:QequestFromAppStore(_productId)
  WZLog("PassportSdkManager:QequestFromAppStore:",_productId)
  local curSdkObj = self:getCurSdkObj()
  if curSdkObj then
    local config = curSdkObj.m_tConfig
    if config.SDKOtherConfig.isNeedListToAppStore == "true" then --动态自定义支付界面
      local tProductList = {ProductId = _productId}
      local sJsonArg = json.encode(tProductList)
       curSdkObj:purchaseOthers(sJsonArg, PassportDefaultCallback.purchaseOthersCallback, PassportDefaultCallback)
    end
  end
end

--@brief 调用sdk的其它方法
--@param    callBack:回调方法
--@param    tSdkLuaObj,sdk表对象
--@param    params:扩展参数
function PassportSdkManager:Others(params)
  WZLog("PassportSdkManager:Others:",params)
  local curSdkObj = self:getCurSdkObj()
  if curSdkObj then
      local sJsonArg = json.encode(params)
      WZLog("PassportSdkManager:Others: One", sJsonArg)
      curSdkObj:accountOthers(sJsonArg, PassportDefaultCallback.accountOthersCallback, PassportDefaultCallback)
  end
end

--@brief 英雄助手上传数据
function PassportSdkManager:postHeroData()
  WZLog("PassportSdkManager:postHeroData")
  local curSdkObj = self:getCurSdkObj()
  if curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.needPost == "true" then
     WZLog("PassportSdkManager:postHeroData222")
      local postData = {}
      postData.funType = "postData"
      local playInfo = CacheCenter:getPlayerInfo()
      postData.vipLevel = playInfo.vipLevel
      postData.roleName = playInfo.name
      postData.roleId = playInfo.id 
      postData.roleLevel = playInfo.level
      postData.channel = ProjConfig:getChannelId()
      postData.serverName = IPDhttpServer:getCurServerName()
      postData.serverId = IPDhttpServer:getCurServerId()
      postData.balance = CacheCenter:getMoneyList().blueDiamond
      postData.gold = CacheCenter:getMoneyList().gold
      postData.vipExp = playInfo.vipExp
      postData.levelExp = playInfo.exp
      postData.rankLevel = playInfo.tournamentLevel
      postData.rankExp = playInfo.tournamentIntegral
      postData.channelUid = gChannelUid
      local sJsonArg = json.encode(postData)
      -- body
      local platForm =  WZUISystem:getInstance():getPlatformInfo()
      if platForm == 2 then
        SNSSdkManager:postData("com/wyd/heroHelp/AsynSns",sJsonArg)
      elseif platForm == 1 then
          WZLog("PassportSdkManager:postHeroData333")
          curSdkObj:accountOthers(sJsonArg, nil,nil)
      end
  end
end

--brief 英雄助手显示攻略界面
function PassportSdkManager:showHeoShare()
  if ProjConfig.SDK_CODE and ProjConfig.SDK_CODE >= 3 then
  else
    MsgBoxManager:showTipBox(LocalStrings.NEED_UPDATE_VERSION)
    return
  end
  local platForm =  WZUISystem:getInstance():getPlatformInfo()
  WZLog("PassportSdkManager:showHeoShare:", platForm)
  local curSdkObj = self:getCurSdkObj()
  local config = curSdkObj.m_tConfig.SDKOtherConfig
  if config.herU and config.herU == "true" then
    platForm = 1
  end
  if platForm == 2 then
    SNSSdkManager:heroOthers("com/wyd/heroHelp/AsynSns") 
  elseif platForm == 1 then
      if curSdkObj then
          local data ={}
          data.funType = "showHeroShare"
          local sJsonArg = json.encode(data)
          curSdkObj:accountOthers(sJsonArg, nil,nil)
      end
  end
end

--brief 英雄助手显示攻略界面
function PassportSdkManager:showHeroPray()
  if ProjConfig.SDK_CODE and ProjConfig.SDK_CODE >= 4 then
  else
    MsgBoxManager:showTipBox(LocalStrings.NEED_UPDATE_VERSION)
    return
  end
  local platForm =  WZUISystem:getInstance():getPlatformInfo()
  WZLog("PassportSdkManager:showHeroPray:", platForm)
  local curSdkObj = self:getCurSdkObj()
  local config = curSdkObj.m_tConfig.SDKOtherConfig
  if config.herU and config.herU == "true" then
    platForm = 1
  end
  if platForm == 2 then
    SNSSdkManager:heroOthers("com/wyd/heroHelp/AsynSns","showPray") 
  elseif platForm == 1 then
      if curSdkObj then
          local data ={}
          data.funType = "showPray"
          local sJsonArg = json.encode(data)
          curSdkObj:accountOthers(sJsonArg, nil,nil)
      end
  end
end


--brief 英雄助手显示攻略界面
function PassportSdkManager:showHeoTactic()
  local platForm =  WZUISystem:getInstance():getPlatformInfo()
  WZLog("PassportSdkManager:showHeoTactic:", platForm)
  local curSdkObj = self:getCurSdkObj()
  local config = curSdkObj.m_tConfig.SDKOtherConfig
  if config.herU and config.herU == "true" then
    platForm = 1
  end
  if platForm == 2 then
    SNSSdkManager:showTactic("com/wyd/heroHelp/AsynSns") 
  elseif platForm == 1 then
      if curSdkObj then
           --打开英雄攻略时的助手
          if ProjConfig.SDK_CODE and ProjConfig.SDK_CODE >= 1 then
              SoundManager:pauseBackgroundMusic()
          end
          local data ={}
          data.funType = "showTactic"
          local sJsonArg = json.encode(data)
          curSdkObj:accountOthers(sJsonArg, nil,nil)
      end
  end
end

--brief 英雄助手显示俱乐部界面
function PassportSdkManager:showHeoClub()
  local platForm =  WZUISystem:getInstance():getPlatformInfo()
  WZLog("PassportSdkManager:showHeoClub:", platForm)
  local curSdkObj = self:getCurSdkObj()
  local config = curSdkObj.m_tConfig.SDKOtherConfig
  if config.herU and config.herU == "true" then
    platForm = 1
  end
  if platForm == 2 then
    SNSSdkManager:showClub("com/wyd/heroHelp/AsynSns") 
  elseif platForm == 1 then
      if curSdkObj then
          local data ={}
          data.funType = "showClub"
          local sJsonArg = json.encode(data)
          curSdkObj:accountOthers(sJsonArg, nil,nil)
      end
  end
end

--brief 英雄助手显示商城界面
function PassportSdkManager:showHeoShop()
  local platForm =  WZUISystem:getInstance():getPlatformInfo()
  WZLog("PassportSdkManager:showHeoShop:", platForm)
  local curSdkObj = self:getCurSdkObj()
  local config = curSdkObj.m_tConfig.SDKOtherConfig
  if config.herU and config.herU == "true" then
    platForm = 1
  end
  if platForm == 2 then
    SNSSdkManager:showShop("com/wyd/heroHelp/AsynSns") 
  elseif platForm == 1 then 
      if curSdkObj then
          local data ={}
          data.funType = "showShop"
          local sJsonArg = json.encode(data)
          curSdkObj:accountOthers(sJsonArg, PassportDefaultCallback.accountOthersCallback,PassportDefaultCallback)
      end
  end
end

--@brief SDK数据的相关提交
--@param    bCreateRole:是否为新建角色
function PassportSdkManager:postGameInfo(bCreateRole,extendedParam) 
  --判断是否为android的quick包
  WZLog("PassportSdkManager:postGameInfo",self.s_roleCreateTime)
  local curSdkObj = self:getCurSdkObj()
  if curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.needPost == "true" then
      --android上传玩家信息
      local postData = {}
      postData.funType = "postGameInfo"
      postData.extendedParam = extendedParam or "extendedParam"
      postData.roleCreateTime = string.sub(self.s_roleCreateTime,1,10)
      local playInfo = CacheCenter:getPlayerInfo()
      postData.serverName = IPDhttpServer:getCurServerName()
      postData.serverId = "" .. IPDhttpServer:getCurServerId()     --服务器id
      if playInfo  then
        postData.guildName = playInfo.guildName
        postData.vipLevel = playInfo.vipLevel
        postData.roleName = playInfo.name
        postData.roleId = playInfo.id 
        postData.roleLevel = playInfo.level
        postData.partyId = playInfo.guildId
        if playInfo.sex == 0 then
          postData.gender = LocalStrings.CHARM_BOY
        else
          postData.gender = LocalStrings.CHARM_GIRL
        end
        postData.rolePower = playInfo.fighting
      end
      if bCreateRole == "true" then
        postData.createRole = "true"
        self.b_createRole = false
      end
      WZLog("postGameInfo333:"..postData.serverId)
      local moneyList = CacheCenter:getMoneyList()
      if moneyList  then
        postData.balance = moneyList.blueDiamond
        postData.goldNum = moneyList.gold
      end
      self:Others(postData)  
  end
    if isChannelQQHall() and WQQGameHelper and WQQGameHelper.postEventLuopan then
        --@param actionId:1-登录 9-登出 12-创角 2-主动注册(首次登录注册)
        if extendedParam == "register" then
            WQQGameHelper:postEventLuopan(2)
            WQQGameHelper:postEventLuopan(12)
        elseif extendedParam == "login" then
            WQQGameHelper:postEventLuopan(1)
            WQQGameHelper.m_nLoginTime = NetManager.m_nServerCurTime
        end
    end

    if isChannel360Hall() and WGameHelper360 and WGameHelper360.postEvent360 then
        --@param actionId:1-登录 9-登出 12-创角 2-主动注册(首次登录注册)
        local playerInfo = CacheCenter:getPlayerInfo()
        if not playerInfo then return end
        if extendedParam == "register" then
            WGameHelper360:postEvent360(0)
        elseif extendedParam == "login" then
            WGameHelper360:postEvent360(1)
        elseif extendedParam == "finshLevel" then
            --等级推送
            -- local gkey = WGameHelper360.gkey
            -- local server_id = IPDhttpServer:getCurServerId()
            -- local qid = WGameHelper360.uid
            -- local name = playerInfo.name
            -- local level = playerInfo.level
            -- local key = ""
            --ProtocolProcessorRecharge:send_PURCHASE_FlashBuyCheckInfo(channelId, gkey, serverId, uid, money, productName, ext, callbackInfo, sign, pageType, size)
        end
    end
end

--@brief 美洲包需要获取google广告id(com.wyd.gplay.bombheroes)
--@param    
function PassportSdkManager:getGoogleAdId()
  --判断是否为android的quick包
  CCLuaLog("PassportSdkManager:getGoogleAdId")
  local curSdkObj = self:getCurSdkObj()
  if curSdkObj then
    local config = curSdkObj.m_tConfig
    if config then
      if config.SDKOtherConfig.isGoogleAdId == "true" then
        --android
        CCLuaLog("PassportSdkManager:getGoogleAdId-2")
        curSdkObj:setCallbackByName("others",PassportSdkManager.getGoogleAdIdCallback, PassportSdkManager)
        local postData = {}
        postData.funType = "getAdId"
        local sJsonArg = json.encode(postData)
        curSdkObj:accountOthers(sJsonArg, PassportSdkManager.getGoogleAdIdCallback, PassportSdkManager)
        --self:Others(postData)  
      end 
    end
  end  
end

--@brief other交互回调
--@brief 美洲包需要获取google广告id(com.wyd.gplay.bombheroes)-回调
--@brief 后因增加苹果自动订阅
--@param    
function PassportSdkManager:getGoogleAdIdCallback(jsonArg)
  --判断是否为android的quick包
  CCLuaLog("PassportSdkManager:getGoogleAdIdCallback")
  local tResult = json.decode(jsonArg)
  --美洲包获取google广告id
  if tResult["return"] ~= nil then
      if tResult["return"] == "getAdId" then
          CCLuaLog("google ad id:")
          if tResult["data"] ~= nil then
              PassportSdkManager.s_googleAdvertiseId = tResult["data"]
              CCLuaLog("google ad id1:" .. tResult["data"] .. "--id2:" .. PassportSdkManager.s_googleAdvertiseId)
          end
      elseif tResult["return"] == "iphoneSuccess" then
          local key = tResult["key"]
          local orderId = tResult["order"]
          local channelId = ProjConfig:getChannelId()
          local packageName = WGameCmUtil:GetBundleIdentifier()
          if tResult["productId"] ~= nil then            
              CCLuaLog("PassportSdkManager:getGoogleAdIdCallback.iphoneSuccess_auto:")
              local productId = tResult["productId"]
              if channelId == 1102 then
                  if productId == "yido_item_1399" then
                      CCLuaLog("PassportSdkManager:getGoogleAdIdCallback:iphoneSuccess_auto saveAppstoreKeyForAutoRenewal")
                      PassportSdkManager:saveAppstoreKeyForAutoRenewal(key,orderId)
                      if ProtocolProcessorRecharge then
                          CCLuaLog("PassportSdkManager:getGoogleAdIdCallback:iphoneSuccess_auto send_PURCHASE_IOSSubscription")
                          ProtocolProcessorRecharge:send_PURCHASE_IOSSubscription(orderId, key ,channelId,packageName)
                      end
                  end
              end
          end
      end 
   end
end

--@brief SDK数据的相关提交
--@param    bCreateRole:是否为新建角色
function PassportSdkManager:postGameInfoHK(funName,valueString)
  --判断是否为android的quick包
  local curSdkObj = self:getCurSdkObj()
  if curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.needPostHK == "true" then
      --android上传玩家信息
      local postData = {}
      postData.funType = funName
      postData.value = valueString or ""
      postData.level = valueString or ""
      self:Others(postData)  
  end 
end
--@brief 越南语数据的相关提交
--@param    bCreateRole:是否为新建角色
function PassportSdkManager:postGameInfoVn(funName,extendedParam)
    --判断是否为android的quick包
    local curSdkObj = self:getCurSdkObj()
    if curSdkObj and ProjConfig.LANGUAGE == "vn" then
        local postData = {}
        postData.funType = "postGameInfoVn"
        if funName == "register_vn" or funName == "level_vn" or funName == "setGameContext" then
            postData.funType = funName
        elseif funName == "pulse" then 
          local platForm =  WZUISystem:getInstance():getPlatformInfo()
          if platForm == 1 and ProjConfig.INSTALLVERSION < "1.9.7" then --ios
            return 
          end
        else
            if not PostPlayerEvent:_checkVN(funName) then return end 
            PostPlayerEvent:_record(funName)
        end
        postData.subFunType = funName
        postData.value = extendedParam or ""
        postData.extendedParam = extendedParam or ""
        postData.roleCreateTime = string.sub(self.s_roleCreateTime,1,10)
        local playInfo = CacheCenter:getPlayerInfo()
        if IPDhttpServer:getCurServer() then
          postData.serverName = IPDhttpServer:getCurServerName() or ""
          postData.serverId = "" .. IPDhttpServer:getCurServerId()  or ""   --服务器id
          postData.serverID = "" .. IPDhttpServer:getCurServerId()  or ""   --服务器id
          --WZLog("postGameInfoVn333:"..postData.serverId)
        end
        if playInfo  then
          postData.guildName = playInfo.guildName
          postData.vipLevel = playInfo.vipLevel
          postData.roleName = playInfo.name
          postData.roleId = playInfo.id 
          postData.roleLevel = playInfo.level
          postData.partyId = playInfo.guildId
          if playInfo.sex == 0 then
            postData.gender = LocalStrings.CHARM_BOY
          else
            postData.gender = LocalStrings.CHARM_GIRL
          end
          postData.rolePower = playInfo.fighting
        end
        local moneyList = CacheCenter:getMoneyList()
        if moneyList  then
          postData.balance = moneyList.blueDiamond
          postData.goldNum = moneyList.gold
        end

        local deviceInfo = {}
        if WGameCmUtil and WGameCmUtil.GetBundleIdentifier and WZUISystem and WZDeviceInfo then
          deviceInfo["packageName"] = WGameCmUtil:GetBundleIdentifier() or "unknown"
          --游戏平台
          local platformId = WZUISystem:getInstance():getPlatformInfo() or "unknown"
          if platformId == 2 then
            deviceInfo["osname"] = "android"
          elseif platformId == 1 then
            deviceInfo["osname"] = "ios"
          else
            deviceInfo["osname"] = tostring(platformId)
          end
          --设备名称
          deviceInfo["product"] = WZDeviceInfo:systemName() or "unknown"
          --设备版本
          deviceInfo["osversion"] = WZDeviceInfo:systemVersion() or "unknown"
        end
        postData.deviceInfo = json.encode(deviceInfo)
        if SystemTime then 
            postData.timestamp = SystemTime:getServerTime()
        end

        self:Others(postData)  
    end
end

--@brief SDK数据的相关提交
--@param    bCreateRole:是否为新建角色
function PassportSdkManager:postGameInfoHK(funName,valueString)
  --判断是否为android的quick包
  local curSdkObj = self:getCurSdkObj()
  if curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.needPostHK == "true" then
      --android上传玩家信息
      local postData = {}
      postData.funType = funName
      postData.value = valueString or ""
      postData.level = valueString or ""
      self:Others(postData)  
  end 
end

--@brief SDK数据的相关提交
--@param    bCreateRole:是否为新建角色
function PassportSdkManager:postGameInfoBeiMei(funName,valueString)
  --判断是否为android的quick包
  local curSdkObj = self:getCurSdkObj()
  if curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.needPostBeiMei == "true" then
      --android上传玩家信息
      local postData = {}
      postData.funType = funName
      postData.value = valueString or ""
      postData.level = valueString or ""
      if CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().id then
         postData.roleId = CacheCenter:getPlayerInfo().id
      end
      if self.m_payParam and self.m_payParam.payCode then
        postData.payCode = self.m_payParam.payCode
      end
      self:Others(postData)  
  end 
end

--@brief  fb任务的相关处理
--@param  funName:"bindFacebook","shareFacebook","inviteFacebook"
function PassportSdkManager:facebookTask(funName,_tData)
  --判断是否为android的quick包
  local tData = _tData or {}
  if funName == "clickFacebook" then
    WZLog("rrrrrrrrrr:",url)
    WndActivities:showView()
    WndActivities:_setActivityUrl("http://www.baidu.com/","clickFacebook")
    return
  end
  local curSdkObj = self:getCurSdkObj() 
  if curSdkObj  then
      --android上传玩家信息
      local postData = {}
      postData.funType = funName
      if funName == "inviteFacebook" then
        postData.linkUrl = "https://fb.me/1792721057657626"
        postData.imgUrl = "https://goo.gl/ES4DLr"
        ProtocolProcessorPrefetchCache:send_TASK_AddFaceBookNum(4,"")
      elseif funName == "shareFacebook" then
        local fbDesc = {"Aim-shoot-bomb, challenge me in Bomb Heroes!","Send you a bomb! Come to play with me in Bomb Heroes!","Cute is deadly! Come to play with me and be the legend shooter!"}
        local tag = math.random(1,3)
        postData.title = tData.title or "Bomb Me Now!"
        postData.desc = tData.desc or fbDesc[tag]
        postData.shareUrl = "https://www.facebook.com/bombheroes/ "
        postData.imgUrl = tData.imgUrl or "https://goo.gl/ES4DLr"
      end
      self:Others(postData)  
  end
end

function PassportSdkManager:doAnzhiOthers(funName)
   WZLog("PassportSdkManager::doAnzhiOthers"..funName)
  if WZUISystem:getInstance():getPlatformInfo() == 2 then
    local packName = WGameCmUtil:GetBundleIdentifier()
    if packName == "com.wyd.hero.dandandao.anzhi" or packName == "com.wyd.hero.dandandao.shunwang" then
      WZLog("PassportSdkManager::doAnzhiOthers22")
      local date ={}
      date.funType = funName
      self:Others(date)
    end
  end
end

--@brief    越南评分功能
function PassportSdkManager:doStoreRatingVN()
    local curSdkObj = self:getCurSdkObj()
    if curSdkObj then
        local date ={}
        date.funType = "storeRating"
        self:Others(date)
    end
end

--@brief    越南设置游戏内消息监听
function PassportSdkManager:setInAppMessageListenerVN()
    local curSdkObj = self:getCurSdkObj()
    if curSdkObj then
        local date ={}
        date.funType = "setInAppMessageDeepLinkListener"
        self:Others(date)
    end
end
------------------------------------------充值回调验证结束---------------------------
--@brief	付费完成后回调给ui页面
function PassportSdkManager:paymentCallback(...)
    if self.m_tPaymentCallback == nil then
        return
    end
    if self.m_tPaymentCallback.m_funcCallback then
        if self.m_tPaymentCallback.m_tCallbackObj then
            self.m_tPaymentCallback.m_funcCallback(self.m_tPaymentCallback.m_tCallbackObj, unpack(arg))
        else
            self.m_tPaymentCallback.m_funcCallback(unpack(arg))
        end
    end
end

--@brief  付费完成后回调给ui页面
function PassportSdkManager:othersCallback(jsonArg)    
  CCLuaLog("PassportSdkManager:othersCallback" .. jsonArg)
  local tResult = json.decode(jsonArg)
  if not tResult then return end
  if tResult["return"] == "exit_game" then
      print("PassportSdkManager:othersCallback exit_game")
      local channelId = self:getChannelId()
      print("PassportSdkManager:othersCallback exit_game channelId = ", channelId)
      if channelId == 1118 then
          if WQQGameHelper then
              print("PassportSdkManager:othersCallback WQQGameHelper:on_ready_to_exit_game()")
              WQQGameHelper:on_ready_to_exit_game()
              return
          end
      end
      if channelId == 1119 then
          if WGameHelperFlash then
              print("PassportSdkManager:othersCallback WGameHelperFlash:on_ready_to_exit_game()")
              if g_bisloadingres then
                  return
              end
              WGameHelperFlash:on_ready_to_exit_game()
              return
          else
              if splash.m_root then
                  print("PassportSdkManager:othersCallback in splash")
                  splash:onClickWin32CloseGame(channelId)
                  return
              end
              if GameHelper_Flash and GameHelper_Flash.getInstance then
                  GameHelper_Flash:getInstance():on_sure_to_exit_game()
              end
              return
          end
      end      
      if channelId == 1120 then
          if WGameHelper360 then
              print("PassportSdkManager:othersCallback WGameHelper360:on_ready_to_exit_game()")
              if g_bisloadingres then
                  return
              end
              WGameHelper360:on_ready_to_exit_game()
              return
          else
              if splash.m_root then
                  print("PassportSdkManager:othersCallback in splash")
                  splash:onClickWin32CloseGame(channelId)
                  return
              end
              if GameHelper_360 and GameHelper_360.getInstance then
                  GameHelper_360:getInstance():on_sure_to_exit_game()
              end
              return
          end
      end
      -- if GameHelper_QQ then
      --     GameHelper_QQ:getInstance():on_sure_to_exit_game()
      -- end
      if CCDirector then
          print("PassportSdkManager:othersCallback CCDirector:sharedDirector():endToLua()")
          CCDirector:sharedDirector():endToLua()
          return
      end
      return
  elseif tResult["return"] == "buy_vip_close" then
      WndVip:closeLoadingUI()
      return
  elseif tResult["return"] == "pay_close" then
      WndVip:closeLoadingUI()
      return      
  elseif tResult["return"] == "init_flash" then      
      print("PassportSdkManager:othersCallback init_flash")
      if WGameHelperFlash and WGameHelperFlash.initCallback then
          WGameHelperFlash:initCallback(jsonArg)
      end
      return
  elseif tResult["return"] == "init_360" then      
      print("PassportSdkManager:othersCallback init_360")
      if WGameHelper360 and WGameHelper360.initCallback then
          WGameHelper360:initCallback(jsonArg)
      end
      return
  end
end




-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
