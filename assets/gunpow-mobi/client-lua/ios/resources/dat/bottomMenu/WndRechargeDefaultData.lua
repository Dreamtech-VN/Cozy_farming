--WndRechargeDefaultDefaultData.lua
--@brief	WndRechargeDefault的数据模块
--@date		2014/01/20
--@author	林庆凯
--@note		充值窗口

WndRechargeDefault = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRechargeDefault:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tProductList = nil           --产品列表
    self.m_tRuleList = nil              --货币钻石转换列表
    self.m_nLoadingBoxId = 0            --加载框的id
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRechargeDefault:_unInit()
	self.m_root = nil
    self.m_tProductList = nil
    self.m_tRuleList = nil
    self.m_nLoadingBoxId = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRechargeDefault:createElement()
	local element = WZUISystem:getInstance():createElement("WndRechargeDefault")
	assert(element, "WndRechargeDefault create element failed!")
	self:_init()
	return element
end

--@brief	获取产品道具id列表成功的函数
function WndRechargeDefault:getProductIdListOk(ids, icons, pices)
    -- ids : 产品id列表
	-- icons : 产品图片(选中效果在后面加“_sel”)
	-- pices : 产品价格
    self.m_tProductList = {}
    self.m_tProductList.ids = ids
    self.m_tProductList.icons = icons
    self.m_tProductList.pices = pices
    WZLog(Serialize(self.m_tProductList))
    self:_getProductListFromAppSevice()
    --self:_update()
end

--@brief	获取货币钻石转换列表成功的函数
function WndRechargeDefault:getRuleListOk(price, ratio)
    -- price : 价格列表
	-- ratio : 比率（100倍）
    self.m_tRuleList = {}
    self.m_tRuleList.price = price
    self.m_tRuleList.ratio = ratio
    WZLog(Serialize(self.m_tRuleList))
end

--@brief	取得玩家信息成功的函数
function WndRechargeDefault:getPlayerInfoOk()
	if self.m_root == nil then 
		WZLog("WndRechargeDefault:getPlayerInfoOk() self.m_root is nil")
		return 
	end 
	
end

--@brief	付费完成后的回调
--@param    sJsonArg，以json格式返回的回调参数
function WndRechargeDefault:doPayCallBack(sJsonArg)
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingBoxId)
    if sJsonArg == nil then
        MsgBoxManager.showTipBox(LocalStrings.RECHARGE_FAIL)
        return
    end
    local tResult = json.decode(sJsonArg)
    if tResult["return"] == "fail" then
        MsgBoxManager.showTipBox(LocalStrings.RECHARGE_FAIL)
    end

    --为了屏蔽百度多酷SDK多次点击充值，多次弹出多酷SDK充值界面
    if ProjConfig.CHANNEL_ID == USE_BD_SDK then
        if "BaiduDuoku" == tResult["return"] then
            WndBottomMenu.m_bCanRechargeDuoku = true
        end
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	从苹果服务器获取产品列表信息
function WndRechargeDefault:_getProductListFromAppSevice()
    WZLog("WndRechargeDefault:_getProductListFromAppSevice")
    if self.m_tProductList == nil or self.m_tProductList.ids == nil then
        return
    end
    
    local tProductList = {ProductId = self.m_tProductList.ids}
    local tCurSdkObj = PassportSdkManager:getCurSdkObj()
    if tCurSdkObj == nil then
        return
    end
    local sJsonArg = json.encode(tProductList)
    WZLog(sJsonArg)
    
    self.getProductListFromAppSeviceCallBack = function (t, sJsonArg)
        WZLog("WndRechargeDefault:getProductListFromAppSeviceCallBack", sJsonArg)
        local tResult = json.decode(sJsonArg)
        for i1,v1 in ipairs(self.m_tProductList.ids) do
            for i2,v2 in ipairs(tResult.ProductId) do
                if v1 == v2 then
                    self.m_tProductList.pices[i1] = tResult.ProductPrice[i2]
                end
            end
        end
        self:_update()
    end
    
    tCurSdkObj:purchaseOthers(sJsonArg, self.getProductListFromAppSeviceCallBack, self)
end

--@brief	获取价格对应的钻石数量
--@param	nPrice,价格
--@return   #1,钻石数量
function WndRechargeDefault:_getTicketsForPrice(nPrice)
    if self.m_tRuleList == nil or self.m_tRuleList.price == nil then
        return nPrice*10 --没数据使用默认值
    end
    local nLastPrice = 0
    for i = 1, #self.m_tRuleList.price do
        if nPrice <= self.m_tRuleList.price[i] then
            return nPrice*self.m_tRuleList.ratio[i]/100
        else
            nLastPrice = self.m_tRuleList.price[i]
        end
    end
    return nPrice*self.m_tRuleList.ratio[#self.m_tRuleList.ratio]/100
end




-------------------------------------私有方法模块End----------------------------------------
