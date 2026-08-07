--WndBuyMultipleItem.lua
--@brief	WndBuyMultipleItem的UI模块
--@date		2017/02/16
--@author	qixiang
--@note		用于购买多个物品


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBuyMultipleItem:onEnter(element)
	self.m_root = element
	self:initUI()
	self:_moreLanguage()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBuyMultipleItem:onExit(element)
	self:_unInit()
end

function WndBuyMultipleItem:_moreLanguage()
	GetElement(self.m_root,"txtTitle_WndBuyMultipleItem",WZUILabelTTF):setText(LocalStrings.BUY)	
end

--@brief	开始点击窗口后的回调
--@param	element:窗口绑定的lua表
--@param    pt:坐标点
function WndBuyMultipleItem:onTouchBegan(element, pt)
    WndItemInfo:onCloseClick()
    WndTips:onCloseClick()
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndBuyMultipleItem:onClickListItem(tItem, nTag, tData)
    WZLog("WndBuyMultipleItem:onClickListItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,false)
end

function WndBuyMultipleItem:initUI()
	-- body
	WZLog("WndBuyMultipleItem:initUI")
	local imgCostItem = GetElement(self.m_root,"imgCostItem_WndBuyMultipleItem",WZUIImage)
	local itemInfo = GDatatab_item["id_" .. self.m_ncostId]
	local icon = itemInfo.icon
	imgCostItem:setFile(icon)

	local txtCostNum = GetElement(self.m_root,"txtCostNum_WndBuyMultipeItem",WZUILabelTTF)
	txtCostNum:setText(self.m_ncostCount)

	local txtOwn = GetElement(self.m_root,"txtOwn_WndBuyMultipleItem",WZUILabelTTF)
	local diamondCount = CacheCenter:getPlayerItemCountById(self.m_ncostId)
	local temp = string.format(LocalStrings.PETHASNUM,diamondCount)
	txtOwn:setText(temp)	

	local conChest = GetElement(self.m_root,"conChest_WndBuyMultipleItem",WZUIContainer)
	local eItem, tItem = CellGoodItem:createElement()
    tItem:setItemClickFun(self, self.onClickListItem)
    local tData = nil
    tData = {
        id = self.m_nitemId,
        lastNum = self.m_nitemCount,
        lastTime = self.m_nitemCount,
        isUse = false,
        data = "",
        playerItemId = -1,
        isZero = true,
        basicInfo = GetItemLocalData(self.m_nitemId)
    }
    tItem:setCellGoodItem(tData,4)
    conChest:addChild(eItem)
end

--更新购买价格
function WndBuyMultipleItem:updateCostCount()
	WZLog("WndBuyMultipleItem:updateCostCount")
	local useNum = GetElement(self.m_root,"useNum_WndBuyMultipleItem",WZUILabelTTF)
	local num = tonumber(useNum:getText())
	local txtCostNum = GetElement(self.m_root,"txtCostNum_WndBuyMultipeItem",WZUILabelTTF)
	local costCount = num * self.m_ncostCount
	txtCostNum:setText(costCount)
end

function WndBuyMultipleItem:onClose(element)
	-- body
	WZLog("WndBuyMultipleItem:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--购买
function WndBuyMultipleItem:onClickBuy(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndBuyMultipleItem:onClickBuy")
	if self.m_nitemCount <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_SHOP_OWN_COUNT)
		return
	end
	
	local txtCostNum = GetElement(self.m_root,"txtCostNum_WndBuyMultipeItem",WZUILabelTTF)
	local costNum = tonumber(txtCostNum:getText())
	local diamondCount = CacheCenter:getPlayerItemCountById(self.m_ncostId)
	local name = GDatatab_item["id_" .. self.m_ncostId].name
	if costNum > diamondCount then
		MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1,name))
		return
	end
	
	if self.m_buyCallbackLua and self.m_buyCallbackFun then
		self.m_buyCallbackFun(self.m_buyCallbackLua,self.m_nitemId,self.m_nNum,self.m_nStoreId)
		WindowManager:removeWindow(self.m_root, self, true)
	end
end

--一次减十个
function WndBuyMultipleItem:onMutiReduce(element)
	WZLog("WndBuyMultipleItem:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum > 1 then
		self.m_nNum = 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndBuyMultipleItem",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end

--一次减一个
function WndBuyMultipleItem:onReduce(element)
	WZLog("WndBuyMultipleItem:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndBuyMultipleItem",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end

--一次加一个
function WndBuyMultipleItem:onAdd(element)
	WZLog("WndBuyMultipleItem:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local max = math.min(self.m_nitemCount, 100)
	if self.m_nNum + 1 <= max then
		self.m_nNum = self.m_nNum + 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	GetElement(self.m_root,"useNum_WndBuyMultipleItem",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end

--@brief	增加10个
function WndBuyMultipleItem:onMutiAdd(element)
	WZLog("WndBuyMultipleItem:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local max = math.min(self.m_nitemCount, 100)
	if self.m_nNum + 10 <= max then
		self.m_nNum = self.m_nNum + 10
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	GetElement(self.m_root,"useNum_WndBuyMultipleItem",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndBuyMultipleItem:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtCost_WndBuyMultipleItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.114308,0.5))
	GetElement(self.m_root,"imgCostItem_WndBuyMultipleItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.260157,0.5))
	GetElement(self.m_root,"txtOwn_WndBuyMultipleItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.642858,0.5))
	GetElement(self.m_root,"txtTips_WndBuyMultipleItem",WZUILabelTTF):setScale(0.7)
end

function WndBuyMultipleItem:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtCost_WndBuyMultipleItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.114308,0.5))
	GetElement(self.m_root,"imgCostItem_WndBuyMultipleItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.260157,0.5))
	GetElement(self.m_root,"txtOwn_WndBuyMultipleItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.642858,0.5))
end

function WndBuyMultipleItem:_adaptLanguage_es(  )
	local txtCost = GetElement(self.m_root,"txtCost_WndBuyMultipleItem",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.145,0.5))
	local txtOwn = GetElement(self.m_root,"txtOwn_WndBuyMultipleItem",WZUILabelTTF)
	txtOwn:setRelativePosition(GlobalMethod:ccp(0.634,0.5))
	GetElement(self.m_root,"txtTips_WndBuyMultipleItem",WZUILabelTTF):setScale(0.7)
end

function WndBuyMultipleItem:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtCost_WndBuyMultipleItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.171451,0.5))
end
-------------------------------------私有方法模块End----------------------------------------
