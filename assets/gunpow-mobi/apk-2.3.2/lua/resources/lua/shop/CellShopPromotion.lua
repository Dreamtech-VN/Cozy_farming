--CellShopPromotion.lua
--@brief	CellShopPromotion的UI模块
--@date		2017/08/24
--@author	zsq
--@note		商城促销Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellShopPromotion:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellShopPromotion:onExit(element)
	self:_unInit()
end

function CellShopPromotion:setData(tData) 
	self.cellData = tData
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief  更新cell界面元素
function CellShopPromotion:_update()
	if self.m_root == nil then return end
	local cellData = self.cellData.initData

    --商品名字描述
    local txtDescript = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDescript_CellShopPromotion"))
    txtDescript:setText(cellData.basicInfo.name)
    txtDescript:setColor(QUALITYCOLOR[cellData.basicInfo.quality])
	WZLog("CellShopPromotion:_update", cellData.basicInfo.name, cellData.discount)

    --商品图标
	local conItemIcon = GetElement(self.m_root, "conItem_CellShopPromotion", WZUIContainer)
	local cell,tcell = CellGoodItem:createElement()
    if cell then
        cell = WZUIContainer:luaTo(cell)
        tcell:setCellGoodItem(cellData,5)
        conItemIcon:addChild(cell)
    end

	--价格图标
	GetElement(self.m_root,"img1_CellShopPromotion",WZUIImage):setFile(GDatatab_item["id_"..cellData.moneyId].icon)
	--商品价格
	GetElement(self.m_root,"txt2",WZUIFreeTextBox):setShowText(string.format(LocalStrings.NEWSHOP11, tostring(cellData.floorPrice)))
	local price = math.ceil(cellData.floorPrice*cellData.discount/10000)
	if price == cellData.floorPrice then
		price = price - 1
	end
	GetElement(self.m_root,"txt1_CellShopPromotion",WZUILabelTTF):setText(price)
	
	if tonumber(cellData.floorPrice) < 10 then
		GetElement(self.m_root,"imgLine",WZUIImage):setScaleX(0.1)
	elseif tonumber(cellData.floorPrice) < 100 then
		GetElement(self.m_root,"imgLine",WZUIImage):setScaleX(0.2)
	elseif tonumber(cellData.floorPrice) < 1000 then
		GetElement(self.m_root,"imgLine",WZUIImage):setScaleX(0.3)
	elseif tonumber(cellData.floorPrice) < 10000 then
		GetElement(self.m_root,"imgLine",WZUIImage):setScaleX(0.4)
	end

	--折扣
	local discount = math.floor(cellData.discount/100)/10
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
		discount = 100 - discount * 10
	end
	GetElement(self.m_root,"discount",WZUILabelTTF):setText(discount..LocalStrings.NEWSHOP12)
end

-- 点击回调
function CellShopPromotion:onBtnClickGoods(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("CellShopPromotion:onBtnClickGoods",Serialize(self.cellData))

    local other = {interface = 2,tcell = self }
    local con = GetElement(WndShop.m_root,"conTips_WndShop",WZUIContainer)
   	WndItemInfo:showInfo(element,con,1,self.cellData.initData,true,nil,nil,other)
end

function CellShopPromotion:onClickbuyBtn()
    WZLog("------------CellShopPromotion:onClickbuyBtn--------------")
    local cellData = self.cellData
    local itemId = cellData.initData.shopItemId
    if cellData.initData.limitLeave == -1 or cellData.initData.limitLeave > 0 then
		WZLog("购买商品k",cellData.initData.id)
        WndShop:showShopInterfaceByTag(itemId,3,cellData.initData.id)
    else
        MsgBoxManager:showTipBox(LocalStrings.SHOP_DAY_LIMITED )
    end
end



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellShopPromotion:_adaptLanguage_vn(  )
	local txtDescript = GetElement(self.m_root,"txtDescript_CellShopPromotion",WZUILabelTTF)
	txtDescript:setScale(0.6)
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.69,0.8))
	txtDescript:setDimensions(GlobalMethod:CCSize(260,0))
	GetElement(self.m_root,"discount",WZUILabelTTF):setScale(0.6)
end

function CellShopPromotion:_adaptLanguage_en(  )
	GetElement(self.m_root,"con_CellShopPromotion",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.65,0.37))
	local txtDescript = GetElement(self.m_root,"txtDescript_CellShopPromotion",WZUILabelTTF)
	txtDescript:setScale(0.7)
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.69,0.8))
	txtDescript:setDimensions(GlobalMethod:CCSize(260,0))

	GetElement(self.m_root,"discount",WZUILabelTTF):setScale(0.6)
end

function CellShopPromotion:_adaptLanguage_th(  )
	GetElement(self.m_root,"con_CellShopPromotion",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.65,0.37))
	local txtDescript = GetElement(self.m_root,"txtDescript_CellShopPromotion",WZUILabelTTF)
	txtDescript:setScale(0.7)
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.69,0.8))
	txtDescript:setDimensions(GlobalMethod:CCSize(260,0))
end

function CellShopPromotion:_adaptLanguage_pt(  )
	GetElement(self.m_root,"con_CellShopPromotion",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.65,0.37))
	local txtDescript = GetElement(self.m_root,"txtDescript_CellShopPromotion",WZUILabelTTF)
	txtDescript:setScale(0.6)
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.69,0.78))
	txtDescript:setDimensions(GlobalMethod:CCSize(260,0))

	GetElement(self.m_root,"txt2",WZUIFreeTextBox):setScale(0.7)
end

function CellShopPromotion:_adaptLanguage_es(  )
	GetElement(self.m_root,"con_CellShopPromotion",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.65,0.37))
	local txtDescript = GetElement(self.m_root,"txtDescript_CellShopPromotion",WZUILabelTTF)
	txtDescript:setScale(0.6)
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.69,0.78))
	txtDescript:setDimensions(GlobalMethod:CCSize(260,0))
	
	GetElement(self.m_root,"txt2",WZUIFreeTextBox):setScale(0.7)
end

function CellShopPromotion:_adaptLanguage_tr(  )
	local txtDescript = GetElement(self.m_root,"txtDescript_CellShopPromotion",WZUILabelTTF)
	txtDescript:setScale(0.6)
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.69,0.8))
	txtDescript:setDimensions(GlobalMethod:CCSize(260,0))
	GetElement(self.m_root,"discount",WZUILabelTTF):setScale(0.6)

	local txt2 = GetElement(self.m_root,"txt2",WZUIFreeTextBox)
	txt2:setScale(0.7)
	txt2:setRelativePosition(GlobalMethod:ccp(-0.2,0.31))
end

function CellShopPromotion:_adaptLanguage_ug(  )
	local txtDescript = GetElement(self.m_root,"txtDescript_CellShopPromotion",WZUILabelTTF)
	txtDescript:setScale(0.6)
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.69,0.78))
	txtDescript:setDimensions(GlobalMethod:CCSize(260,0))
	GetElement(self.m_root,"discount",WZUILabelTTF):setScale(0.6)

	local txt2 = GetElement(self.m_root,"txt2",WZUIFreeTextBox)
	txt2:setScale(0.7)
	txt2:setRelativePosition(GlobalMethod:ccp(-0.2,0.31))
end
-------------------------------------语言适配End----------------------------------------