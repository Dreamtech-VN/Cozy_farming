--CellRebate.lua
--@brief	CellRebate的UI模块
--@date		2015-6-8
--@author	binshao
--@note		竞技场商店Cell

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRebate:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRebate:onExit(element)
	self:_unInit()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 更新商品的信息
function CellRebate:_update()
	WZLog("CellRebate:_update", Serialize(self.tData))
	local basicInfo = GDatatab_item["id_"..self.tData.itemId]
    local name = basicInfo.name
    local path = basicInfo.icon
    local num =  self.tData.gainNum
    local quality = basicInfo.quality
    local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(basicInfo)}
	
    -- 商品名字
    local txtName = GetElement(self.m_root,"txtPropName_CellRebate",WZUILabelTTF)
    local name = itemInfo.name
    txtName:setText(name)
    txtName:setColor(QUALITYCOLOR[itemInfo.quality])

	--折扣
	GetElement(self.m_root,"conDiscount",WZUIContainer):setVisible(not (self.tData.discount==0))
	GetElement(self.m_root,"discount",WZUILabelTTF):setText((self.tData.discount)..LocalStrings.NEWSHOP12)

    -- 货币类型和价格
    local imgMoney = GetElement(self.m_root,"imgMoney_CellRebate",WZUIImage)
    local imgFile = GDatatab_item["id_"..self.tData.costId].icon
    imgMoney:setFile(imgFile)
    local txtPrice = GetElement(self.m_root,"txtPrice_CellRebate",WZUILabelTTF)
	if self.tData.discount ~= 0 then
    	txtPrice:setText(math.ceil(self.tData.price*self.tData.discount/10))
	else
    	txtPrice:setText(self.tData.price)
	end

    -- 商品图标
    local conP = GetElement(self.m_root,"conProp_CellRebate",WZUIContainer)
    local cell,tcell = CellGoodItem:createElement()
    conP:addChild(cell)


    tcell:setCellGoodItem(itemInfo,5)
    tcell:_showItemNum()

    -- 是否售罄
    local conS = GetElement(self.m_root,"conSell_CellRebate",WZUIContainer)
    conS:setVisible(self.tData.leftNum <= 0)
end

function CellRebate:OnBtnBuy(element)
    WZLog("---------CellRebate:OnBtnBuy------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.tData.leftNum <= 0 then  return  end
	local basicInfo = GDatatab_item["id_"..self.tData.itemId]
    local name = basicInfo.name
    local path = basicInfo.icon
    local num =  self.tData.gainNum
    local quality = basicInfo.quality
    local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(basicInfo)}

	itemInfo.tBtnList = {LocalStrings.BUY}
    WndItemInfo:showInfo(self.m_root,WndRebate.m_root,1,itemInfo,true,nil,nil,other)
	WndItemInfo:setClickButtonCallback(self,self.onClickbuyBtn)
end

--@brief	点击购买回调
function CellRebate:onClickbuyBtn()
    
	--判断是否够钱
	local cost = math.ceil(self.tData.price*self.tData.discount/10)
	if self.tData.discount == 0 then
		cost = self.tData.price
	end
	WndRebate.buyId = self.tData.id
	WZLog("CellRebate:onClickbuyBtn",self.tData.costId,cost)
	if not JudgeMoneyIsEnough(self.tData.costId, cost, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, WndRebate, WndRebate.clickSureMoney) then 
		WZLog("钻石不足",self.tData.costId,cost)
		return 
	end
	ProtocolProcessorWndShop:send_MALL_DiscountStorePurchase(self.tData.id )
end

-------------------------------------私有方法模块End----------------------------------------

