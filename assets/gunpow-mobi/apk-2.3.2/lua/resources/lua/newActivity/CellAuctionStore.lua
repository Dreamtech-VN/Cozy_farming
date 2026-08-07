--CellAuctionStore.lua
--@brief	CellAuctionStore的UI模块
--@date		2020/09/03
--@author	yrd
--@note		拍卖行商店商品


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAuctionStore:onEnter(element)
	self.m_root = element

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAuctionStore:onExit(element)
	self:_unInit()
end

--@brief	刷新界面
function CellAuctionStore:update()
	local qualityPath = {"ui/common/common_pz_lv.png","ui/common/common_pz_lan.png","ui/common/common_pz_zi.png","ui/common/common_pz_cheng.png","ui/common/common_pz_hong.png"}
	local tItem = SplitStringToTable(self.m_tData.item)
	local itemInfo = GDatatab_item["id_"..tItem[1]]
    local nNum = tItem[2]
    if itemInfo then
	    if itemInfo.main_type == 5 or itemInfo.main_type == 31 then
	    	if tItem[2] == -1 then
	    		nNum = LocalStrings.YJ
	    	else
	    		nNum = tItem[2]..LocalStrings.DAY
	    	end
	    end
	   
		local imgQuality = GetElement(self.m_root,"imgQuality_CellAuctionStore",WZUIImage)
		imgQuality:setFile(qualityPath[itemInfo.quality])
		local imgItemIcon = GetElement(self.m_root,"imgItemIcon_CellAuctionStore",WZUIImage)
		imgItemIcon:setFile(itemInfo.icon)
		local txtName = GetElement(self.m_root,"txtName_CellAuctionStore",WZUILabelTTF)
		txtName:setColor(QUALITYCOLOR[itemInfo.quality])
		txtName:setText(itemInfo.name)
		local txtItemNum = GetElement(self.m_root,"txtItemNum_CellAuctionStore",WZUILabelTTF)
		txtItemNum:setText(nNum)
	end


	local str = ""
	if self.m_tData.mType == 1 then
		str = LocalStrings.AUCTION_HOUSE_TEXT32
	elseif self.m_tData.mType == 2 then
		str = LocalStrings.SHOP_DAY_LIMIT..":"
	end
	local str1 = self.m_tData.exchange-self.m_tData.exchangeNum.."/"..self.m_tData.exchange
	local txtLimitNumFree = GetElement(self.m_root,"txtLimitNumFree",WZUIFreeTextBox)
	txtLimitNumFree:setShowText(string.format([[<T C="127,70,26" S="18" P="1">%s</T><T C="229,105,22" S="18" P="1">%s</T>]],str,str1))

	local imgCostIcon = GetElement(self.m_root,"imgCostIcon_CellAuctionStore",WZUIImage)
	local tCost = SplitStringToTable(self.m_tData.price)
	local costInfo = GDatatab_item["id_"..tCost[1]]
	imgCostIcon:setFile(costInfo.icon)
	local txtCostNum = GetElement(self.m_root,"txtCostNum_CellAuctionStore",WZUILabelTTF)
	txtCostNum:setText(tCost[2])
	
	local btnBuy = GetElement(self.m_root,"btnBuy_CellAuctionStore",WZUIButton)
	btnBuy:setLuaActionName("Normal")

	--告罄状态
	local conSell = GetElement(self.m_root,"conSell_CellAuctionStore",WZUIContainer)
	if self.m_tData.exchange-self.m_tData.exchangeNum <= 0 then
		conSell:setVisible(true)
	else
		conSell:setVisible(false)
	end
end

--@brief	点击购买
function CellAuctionStore:onClickBuy(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tItem = SplitStringToTable(self.m_tData.item)
    local tCost = SplitStringToTable(self.m_tData.price)
    itemId = tItem[1]
    itemCount = tItem[2]
    costId = tCost[1]
    costCount = tCost[2]
    storeId = self.m_tData.mallId
    buyCallbackLua = self
    buyCallbackFun = self.onBuyCallback
    limitNum = self.m_tData.exchange-self.m_tData.exchangeNum

	--检测兑换次数是否足够
	if self.m_tData.exchange-self.m_tData.exchangeNum <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.CUR_TURN_COUNT_NOT)
		return
	end

    --检测竞拍币是否足够
    local myCostCoin = CacheCenter:getPlayerItemCountById(costId)
	local name = GDatatab_item["id_"..costId].name
	if costCount > myCostCoin then
		MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1,name))
		return
	end

    WndAuctionBuy:show(itemId,itemCount,costId,costCount,storeId,buyCallbackLua,buyCallbackFun,limitNum)
end

--@brief	设置回调方法
function CellAuctionStore:onBuyCallback(itemId,itemNum,storeId)
	--背包已满
	if CacheCenter:getRemainAmount() <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end

	ProtocolProcessorNewActivity:send_ACTIVITY2_ExchangeAuctionItem(storeId, itemNum )
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

function CellAuctionStore:_adaptLanguage_vn()
	local txtLimitNumFree = GetElement(self.m_root,"txtLimitNumFree",WZUIFreeTextBox)
	txtLimitNumFree:setMaxWidth(400)
	txtLimitNumFree:setScale(0.7)
end