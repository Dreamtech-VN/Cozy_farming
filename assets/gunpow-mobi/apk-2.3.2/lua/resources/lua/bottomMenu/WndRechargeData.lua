
--WndRechargeData.lua
--@brief	WndRecharge的数据模块
--@date		2014/01/20
--@author	林庆凯
--@note		充值窗口

WndRecharge = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRecharge:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tProductList = nil           --产品列表
    self.m_tRuleList = nil              --货币钻石转换列表
    self.m_nLoadingBoxId = 0            --加载框的id
	self.m_nRech = nil 					--充值容器容差
	self.m_oldSize = nil 				--充值容器的原来大小
	self.m_nIndex = 0					--索引
	self.m_nCrit = nil 
    self.m_currOrder = nil
    self.m_archiveData = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRecharge:_unInit()
	self.m_root = nil
    self.m_tProductList = nil
    self.m_tRuleList = nil
    self.m_nLoadingBoxId = 0
	self.m_nRech = nil 					--充值容器容差
	self.m_oldSize = nil 				--充值容器的原来大小
	self.m_nIndex = nil					--索引
	self.m_nCrit = nil 
    self.m_currOrder = nil
    self.m_archiveData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRecharge:createElement()
	local element = WZUISystem:getInstance():createElement("WndRecharge")
	assert(element, "WndRecharge create element failed!")
	self:_init()
	return element
end

function WndRecharge:showUpdate()
	if self.m_root == nil then
		return
	end
	self:setTotalDiamond()
end

--@brief	获取产品道具id列表成功的函数
function WndRecharge:getProductIdListOk(ids, icons, pices,discount)
    -- ids : 产品id列表
	-- icons : 产品图片(选中效果在后面加“_sel”)
	-- pices : 产品价格
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    local config = curSdkObj.m_tConfig 
    if curSdkObj then
        if config.SDKOtherConfig.isNeedListToAppStore == "true"then
            getProductIdFromGameServerOk(ids, icons, pices,discount)
        else
           self.m_tProductList = {}
           self.m_tProductList.ids = ids
           self.m_tProductList.icons = icons
           self.m_tProductList.pices = pices
           self.m_tProductList.discount = discount
           self.m_tProductList.productPrice = {}
           WZLog(Serialize(self.m_tProductList), self:_getTicketsByIcon(self.m_tProductList.icons[2]))
         local count = 0
          for i,v in ipairs(self.m_tProductList.ids) do
               count = count + 1
               WZLog("self.m_tProductList.ids",self.m_tProductList.ids[count])
               WZLog("self.m_tProductList.icons",self.m_tProductList.icons[count])
               WZLog("self.m_tProductList.pices",self.m_tProductList.pices[count])
               WZLog("self.m_tProductList.discount",self.m_tProductList.discount[count])
           end
           self:_getProductListFromAppSevice()
        end
    else
        self.m_tProductList = {}
        self.m_tProductList.ids = ids
        self.m_tProductList.icons = icons
        self.m_tProductList.pices = pices
        self.m_tProductList.discount = discount
        self.m_tProductList.productPrice = {}
        WZLog(Serialize(self.m_tProductList), self:_getTicketsByIcon(self.m_tProductList.icons[2]))
        self:_getProductListFromAppSevice()
    end
end

--@brief	获取货币钻石转换列表成功的函数
function WndRecharge:getRuleListOk(price, ratio)
    -- price : 价格列表
	-- ratio : 比率（100倍）
    self.m_tRuleList = {}
    self.m_tRuleList.price = price
    self.m_tRuleList.ratio = ratio
    WZLog(Serialize(self.m_tRuleList))
end

--@brief	取得玩家信息成功的函数
function WndRecharge:getPlayerInfoOk()
	if self.m_root == nil then 
		WZLog("WndRecharge:getPlayerInfoOk() self.m_root is nil")
		return 
	end 
	
end

--@brief	付费完成后的回调
--@param    sJsonArg，以json格式返回的回调参数
function WndRecharge:doPayCallBack(sJsonArg)
    WZLog("WndRecharge:doPayCallBack:",sJsonArg)
    
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingBoxId)
    if sJsonArg == nil then
        MsgBoxManager:showTipBox(LocalStrings.RECHARGE_FAIL)
        return
    end
    local tResult = json.decode(sJsonArg)
    WZLog("tResult[ReturnType]:",tResult["ReturnType"])
   -- if tResult["ReturnType"] == "failed"  then
    --    WZLog("MsgBoxManager.showTipBox LocalStrings.RECHARGE_FAIL");
    --    MsgBoxManager:showTipBox(LocalStrings.RECHARGE_FAIL)
  -- else
        if tResult["ReturnType"] == "Cancel"  then
            return
        end
        local sOrder = tResult["order"]
        local sKey = tResult["key"]
        local stransactionId = tResult["order"]--tResult["transactionId"]
        local nChannelId = PassportSdkManager:getChannelId();
        WZLog("send_PURCHASE_IOSSendProductCheckInfo key:",sOrder,sKey,stransactionId);
        WZLog(" sOrder:",tostring(sOrder),nChannelId,GlobalGame.g_tPlayerInfo.nPlayerId);
 
        if sKey ~= nil and sOrder ~= nil and sKey ~= "" and sOrder ~= "" then
            ProtocolProcessorRecharge:send_PURCHASE_IOSSendProductCheckInfo(sOrder, GlobalGame.g_tPlayerInfo.nPlayerId, sKey,nChannelId)
            local data = WZDataFile:getInstance():getUserData()
            self.m_archiveData = {}
            self.m_archiveData.m_orderNumber = sOrder
            self.m_archiveData.m_orderkey = sKey
            self.m_archiveData.m_transactionId = stransactionId
            self.m_archiveData.m_serverId = data:getStringValue("IPDParam", "ServerId")
            self.m_archiveData.m_area = ProjConfig.AREACODE
            self.m_archiveData.m_playerId =GlobalGame.g_tPlayerInfo.nPlayerId
            self.m_archiveData.m_channelId =ProjConfig.CHANNEL_ID
            local currOrderJeson = json.encode(self.m_archiveData)
            WZLog("================================",currOrderJeson)
            saveCurrentOrder(currOrderJeson)
            
        end
        self.m_nLoadingBoxId = MsgBoxManager:showLoadingBox()
-- end
end


--@brief    获取产品道具id列表成功的函数
function WndRecharge:getProductIdListFromAppStoreOk()
    -- ids : 产品id列表
    -- icons : 产品图片(选中效果在后面加“_sel”)

    -- pices : 产品价格
    self.m_tProductList = {}
    self.m_tProductList.ids = {}--GlobalGame.g_tProducteList.ids
    self.m_tProductList.icons = {}--GlobalGame.g_tProducteList.icons
    self.m_tProductList.pices = {}--GlobalGame.g_tProducteList.pices
    self.m_tProductList.discount = {}--GlobalGame.g_tProducteList.discount
    self.m_tProductList.productPrice = {}--GlobalGame.g_tProducteList.productPrice

    for i=1,  #GlobalGame.g_tProducteList.ids do
        WZLog("self.m_tProductList.pices[i]",self.m_tProductList.pices[i],i)
        if GlobalGame.g_tProducteList.pices[i] > 0 then
            table.insert(self.m_tProductList.ids,GlobalGame.g_tProducteList.ids[i])
            table.insert(self.m_tProductList.icons,GlobalGame.g_tProducteList.icons[i])
            table.insert(self.m_tProductList.pices,GlobalGame.g_tProducteList.pices[i])
            table.insert(self.m_tProductList.discount,GlobalGame.g_tProducteList.discount[i])
            table.insert(self.m_tProductList.productPrice,GlobalGame.g_tProducteList.productPrice[i])
        end
        -- if self.m_tProductList.pices[i] < 0 then
        --     WZLog("self.m_tProductList.pices[i]wwwwww",self.m_tProductList.pices[i],i)
        --     table.remove(self.m_tProductList.ids, i)
        --     table.remove(self.m_tProductList.icons, i)
        --     table.remove(self.m_tProductList.pices, i)
        --     table.remove(self.m_tProductList.discount, i)
        --     table.remove(self.m_tProductList.productPrice, i)
        -- end
    end

    local tProductList = {ProductId = GlobalGame.g_tProducteList.ids,ProductIcon = GlobalGame.g_tProducteList.icons,
    ProductNum = GlobalGame.g_tProducteList.pices,ProductDiscount = GlobalGame.g_tProducteList.discount,ProductPrice = GlobalGame.g_tProducteList.productPrice}
    local tCurSdkObj = PassportSdkManager:getCurSdkObj()
     WZLog("WndRecharge:getProductIdListFromAppStoreOk:::::::::::",tCurSdkObj,tProductList)
    if tCurSdkObj == nil then
        return
    end
    local sJsonArg = json.encode(tProductList)
    WZLog("sJsonArg:::::::productedList",sJsonArg)
    self:_getProductListFromAppSevice()
    --self:_update()
end

-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------
--@brief	根据icon获取钻石数量
--@param    sIcon,icon路径
--@return   #1,钻石数量
function WndRecharge:_getTicketsByIcon(sIcon)
    local sPrefix = "ticket_Price_"
    local tIconMap = {
        ["1"] = 60,
        ["2"] = 135,
        ["3"] = 300,
        ["4"] = 600,
        ["5"] = 1400,
        ["6"] = 3000,
        ["10"] = 320,
        ["11"] = 750,
        ["12"] = 1500,
        ["13"] = 4000,
        ["14"] = 8100,
        ["15"] = 315,
        ["16"] = 660,
        ["17"] = 1380,
        ["18"] = 3600,
        ["19"] = 7500,
        ["20"] = 60,
        ["21"] = 300,
        ["22"] = 600,
        ["23"] = 1200,
        ["24"] = 3050,
        ["25"] = 6300,
        ["26"] = 30,
        ["27"] = 150,
        ["28"] = 270,
        ["29"] = 660,
        ["30"] = 1725,
        ["31"] = 3750,
        ["32"] = 20,
        ["33"] = 100,
        ["34"] = 200,
        ["35"] = 440,
        ["36"] = 1150,
        ["37"] = 2500,
        ["38"] = 60,
        ["39"] = 300,
        ["40"] = 600,
        ["41"] = 1200,
        ["42"] = 3000,
        ["43"] = 6000,
        ["44"] = 50,
        ["45"] = 315,
        ["46"] = 550,
        ["47"] = 1150,
        ["48"] = 3600,
        ["49"] = 6250,
    }
    for i,v in pairs(tIconMap) do
        if sPrefix..i == sIcon then
            return v
        end
    end
end

--@brief	从苹果服务器获取产品列表信息
function WndRecharge:_getProductListFromAppSevice()
    WZLog("WndRecharge:_getProductListFromAppSevice",self.m_tProductList,self.m_tProductList.ids)
    if self.m_tProductList == nil or self.m_tProductList.ids == nil then
        return
    end
    
    local tProductList = {ProductId = self.m_tProductList.ids}
    local tCurSdkObj = PassportSdkManager:getCurSdkObj()
	 WZLog("tCurSdkObj:::::::::::",tCurSdkObj,tProductList)
    if tCurSdkObj == nil then
        return
    end
    local sJsonArg = json.encode(tProductList)
    WZLog("sJsonArg:::::::",sJsonArg)
    
    self.getProductListFromAppSeviceCallBack = function (t, sJsonArg)
	--WZLog("sJsonArg:::::::",sJsonArg)
	--WZLog("WndRecharge:getProductListFromAppSeviceCallBack", sJsonArg)
	local tResult = json.decode(sJsonArg)

    local isDataWithSDK = false
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
        local config = curSdkObj.m_tConfig
        if config.SDKOtherConfig.isProductListWithSDK == "true" then
           isDataWithSDK = true
        end
    end

	if isDataWithSDK == true then
        local config = curSdkObj.m_tConfig
		self.m_tProductList = {}
		self.m_tProductList.ids = {}
		self.m_tProductList.icons = {}
		self.m_tProductList.pices = {}
        self.m_tProductList.localizedTitle = {}
        self.m_tProductList.discount = {}
        self.m_tProductList.productPrice = {}

		local count = 0
		for i,v in ipairs(tResult) do
			if v.price ~= nil then
				count = count + 1
				self.m_tProductList.ids[count] = v.productIdentifier
                self.m_tProductList.productPrice[count] = v.price
				self.m_tProductList.pices[count] = v.GameCurrencyCount
                self.m_tProductList.localizedTitle[count] = v.productIdentifier

                if config.SDKOtherConfig.ProductIcon ~= nil then
                    local iconsPath = config.SDKOtherConfig.ProductIcon[count].Path
                    self.m_tProductList.icons[count] = iconsPath
                end

                if config.SDKOtherConfig.ProductDiscount ~= nil then
                    local discount = config.SDKOtherConfig.ProductDiscount[count].Discount
                    self.m_tProductList.discount[count] = discount
                else
                    self.m_tProductList.discount[count] = 0
                end
			end
		end
		if self.m_root then
			self:_update()
		end
	else
		for i1,v1 in ipairs(self.m_tProductList.ids) do
			for i2,v2 in ipairs(tResult) do
				if v1 == v2.ProductId then
					self.m_tProductList.productPrice[i1] = tResult[i2].ProductPrice
				end
			end
		end
		self:_update()
		end
	end

    local curSdkObj = PassportSdkManager:getCurSdkObj()
     if curSdkObj then
         local config = curSdkObj.m_tConfig
         if config.SDKOtherConfig.isProductListWithLocal == "true" then

            CCLog("config.SDKOtherConfig.isProductListWithLocal == true")
		    local config = curSdkObj.m_tConfig
		    local count = 0
		    for i = 1 , 6 do
			   count = count + 1

			   local prices =  config.SDKOtherConfig.ProductPrices[count].price
               local pricess = prices.."币"
			   self.m_tProductList.productPrice[count] = pricess
                --self.m_tProductList.productPrice = self.m_tProductList.ids
             --  WZLog("self.m_tProductList.productPrice[count]",self.m_tProductList.productPrice[count])
			-- local diamonds =  config.SDKOtherConfig.ProductDiamonds[count].Diamonds
			-- self.m_tProductList.pices[count]  = diamonds
               -- WZLog("self.m_tProductList.pices[count]",self.m_tProductList.pices[count])

			   --local iconsPath = config.SDKOtherConfig.ProductIcon[count].Path
			   --self.m_tProductList.icons[count] = iconsPath

                --WZLog("self.m_tProductList.icons[count]",self.m_tProductList.icons[count])

		    end
         end
        if self.m_root then
           self:_update()
        end
     end
	
    self:_update()
    tCurSdkObj:purchaseOthers(sJsonArg, self.getProductListFromAppSeviceCallBack, self)
end

--@brief	购买完成后的回调
--@param    nCode，错误码:-1成功，0订单验证失败，1服务器增加点卷失败，2订单正在处理中
--@param    nTickets，点卷数量
function WndRecharge:buyCallBack(nCode, nTickets,orderNumber)
	WZLog("购买完成后的回调::::",nCode,nTickets)
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingBoxId)
    if self.m_archiveData == nil then
        self.m_archiveData = {}
    end
    self.m_archiveData.m_orderNumber = orderNumber
    self.m_archiveData.m_playerId =GlobalGame.g_tPlayerInfo.nPlayerId
    self.m_archiveData.m_channelId =ProjConfig.CHANNEL_ID
    local jesonOrder = json.encode(self.m_archiveData)
    saveCurrentOrder(jesonOrder)
    if nCode == -1 then
        GlobalGame.g_tPlayerInfo.nTickets = nTickets or GlobalGame.g_tPlayerInfo.nTickets
        self:setTotalDiamond()
        MsgBoxManager:showTipBox(LocalStrings.RECHARGE_SUCCESS,nil,self,self.onPaySucc)
    elseif nCode == 0 then
        --MsgBoxManager:showTipBox(LocalStrings.RECHARGE_ORDER_FAIL)--"订单验证失败"
    elseif nCode == 1 then
        MsgBoxManager:showTipBox(LocalStrings.RECHARGE_FAIL)--"充值失败"
    elseif nCode == 2 then
        MsgBoxManager:showTipBox(LocalStrings.RECHARGE__IN_PROCESS)--"订单正在处理中"
    else
         MsgBoxManager:showTipBox(LocalStrings.RECHARGE_FAIL)--"充值失败"
    end
end

--@brief	提示购买成功提示框消失后回调
function WndRecharge:onPaySucc()
	self:_showPayTip()
end
-------------------------------------私有方法模块End----------------------------------------
