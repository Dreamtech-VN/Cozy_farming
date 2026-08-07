--CellGangsterInn.lua
--@brief	CellGangsterInn的UI模块
--@date		2016/10/11
--@author	zsq
--@note		黑店商品


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGangsterInn:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGangsterInn:onExit(element)
	self:_unInit()
end

--@brief	点击购买
function CellGangsterInn:onClick()
	WZLog("CellGangsterInn:onClick", self.m_tData.id)
	if WndItemInfo.m_root ~= nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local tData = self.m_tSellData
   	tData.tBtnList = {LocalStrings.BUY}
   	WndItemInfo:showInfo(self.m_root,WndStore.m_root,1,tData)
   	WndItemInfo:setClickButtonCallback(self,self.buyCall)
end

function CellGangsterInn:buyCall()
	WZLog("CellGangsterInn:buyCall")
    CellGangsterInn.m_currentClick = self
	--判断货币是否足够
    if not JudgeMoneyIsEnough(self.m_tData.costItemId, self.m_tData.costCount, nil, nil, Chat_Channel_Black_Shopper, nil, nil, nil, nil, CellGangsterInn.m_currentClick, CellGangsterInn.m_currentClick.sureUseDiamondInstead) then
        return 
    end
	
    CellGangsterInn.m_currentClick:sureUseDiamondInstead()
end

function CellGangsterInn:sureUseDiamondInstead()
	WndStore:showLoadingB()
	ProtocolProcessorStore:send_MALL_PurchaseBlackMarket(CellGangsterInn.m_currentClick.m_tData.id )
	GetElement(CellGangsterInn.m_currentClick.m_root,"conSellUp_CellGangsterInn",WZUIContainer):setVisible(true)
	WndItemInfo:onCloseClick()
end

--@brief    购买金币框
--@param    nResType:响应类型(超时，确定，取消)
function CellGangsterInn:buyGold(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(26)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellGangsterInn:setData(tData)
	if self.m_root == nil then return end
	WZLog("aabbccdd = ",tData.itemId)
	local basicInfo = GDatatab_item["id_"..tData.itemId]
    local name = basicInfo.name
    local path = basicInfo.icon
    local num =  tData.gainCount
    local quality = basicInfo.quality
    local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(basicInfo)}
	local cellData = itemInfo
	self.m_tData = tData
	self.m_tSellData = itemInfo

    --商品名字描述
    local txtDescript = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDescript_CellGangsterInn"))
    txtDescript:setText(cellData.basicInfo.name)
    txtDescript:setColor(QUALITYCOLOR[cellData.basicInfo.quality])

    --商品图标
	local conItemIcon = GetElement(self.m_root, "conItemIcon_CellGangsterInn", WZUIContainer)
	local cell,tcell = CellGoodItem:createElement()
    if cell then
        cell = WZUIContainer:luaTo(cell)
        tcell:setCellGoodItem(cellData,5)
        conItemIcon:addChild(cell)
    end

	--购买消耗货币
	local nameTemplate = [[<I Z="0.45" P="1">%s</I><T C="99,255,95" S="22" P="1">%s</T>]]
	local img = GDatatab_item["id_"..tData.costItemId].icon
	GetElement(self.m_root,"txtCost",WZUIFreeTextBox):setShowText(string.format(nameTemplate,img,tData.costCount))

	--数量
	if tData.gainCount > 1 then
		GetElement(self.m_root,"txtCount_CellGangsterInn",WZUILabelTTF):setText(tData.gainCount)
	end

	--是否售罄
	if tData.leftBuyTime == 0 then
		GetElement(self.m_root,"conSellUp_CellGangsterInn",WZUIContainer):setVisible(true)
	else
		GetElement(self.m_root,"conSellUp_CellGangsterInn",WZUIContainer):setVisible(false)
	end
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellGangsterInn:_adaptLanguage_en()
    local txtDescript = GetElement(self.m_root,"txtDescript_CellGangsterInn",WZUILabelTTF)
    txtDescript:setFontSize(16)
end

-------------------------------------语言适配End--------------------------------------------
