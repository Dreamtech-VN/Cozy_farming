--WndRiseShopData.lua
--@brief	WndRiseShop的数据模块
--@date		2021/06/25
--@author	hyx
--@note		崛起之路商店

WndRiseShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRiseShop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRiseShopData = {}
	self.m_tShopCellItem = {}
	self.m_nCoinid = 160107
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRiseShop:_unInit()
	self.m_root = nil
	self.m_tRiseShopData = {}
	self.m_tShopCellItem = {}
	self.m_nCoinid = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRiseShop:createElement()
	if WndRiseShop.m_root ~= nil then
		WindowManager:removeWindow(WndRiseShop.m_root, WndRiseShop, true)
	end
	local element = WZUISystem:getInstance():createElement("WndRiseShop")
	assert(element, "WndRiseShop create element failed!")
	self:_init()
	return element
end
function WndRiseShop:setRiseShopData(data)
	local temp = {}
	temp.refreshTime = data.refreshTime
	temp.refreshLimit = data.refreshLimit
	temp.refreshCount = data.refreshCount
	temp.refreshPriceId = data.refreshPriceId
	temp.refreshPriceNum = data.refreshPriceNum
	temp.tab_item = {}
	for i=1,#data.ids do
		local tab = {}
		tab.shop_id = data.ids[i]
		tab.id = data.itemIds[i]
		tab.num = data.itemNums[i]
		tab.price = data.prices[i]
		tab.buyLimit = data.buyLimit[i]
		tab.buyCount = data.buyCount[i]
		temp.tab_item[i] = tab
	end
	self.m_tRiseShopData = temp
end
--================== 崛起之路商店子项 ========================
CellRiseShopItem = {}
function CellRiseShopItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRiseShopItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellRiseShopItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(192,184))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellRiseShopItem:setRiseShopItemData(data, refreshTime)
	self.m_tRiseShopItemData = data
	self.m_nRefreshTime = refreshTime
end
--@brief 	开始加载
function CellRiseShopItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("itemShopCell")
	celElement:setVisible(true)
	element:addChild(celElement)
	self:setData()
end
function CellRiseShopItem:setData()
	if not self.m_tRiseShopItemData then return end
	local data = self.m_tRiseShopItemData
	local tabItem = GDatatab_item["id_"..data.id]
	if tabItem then
		GetElement(self.m_root,"txtTitle",WZUILabelTTF):setText(tabItem.name)
		local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
		local itemInfo = {lastTime=data.num,lastNum=data.num,basicInfo=CopyTable(tabItem)}
		local celElement,tLuaObj = CellGoodItem:createElement()
		celElement:setScale(0.85)
		goods_con:addChild(celElement)
		tLuaObj:setCellGoodItem(itemInfo, 17)
		tLuaObj:setItemClickFun(WndRiseShop,self.onItemClick)
	end
	self:setCellRiseShopItem(data)
end
function CellRiseShopItem:setCellRiseShopItem(data)
	if not data then return end
	local txtRichLimit = GetElement(self.m_root,"txtRichLimit",WZUIFreeTextBox)
	local imgMark = GetElement(self.m_root,"imgMark",WZUI9Image)
	if data.buyLimit == -1 then
		imgMark:setVisible(false)
	else
		if data.buyCount >= data.buyLimit then
			imgMark:setVisible(true)
		else
			imgMark:setVisible(false)
		end
		txtRichLimit:setShowText(string.format([[<T C="127,70,26" S="18" P="1">%s: </T><T C="229,105,22" S="18" P="1">%d/%d</T>]],LocalStrings.ACTIVITY_TEXT14,data.buyCount, data.buyLimit))
	end
	local txtRichConsume = GetElement(self.m_root,"txtRichConsume",WZUIFreeTextBox)
	local info = GDatatab_item["id_160107"]
	if info then
		txtRichConsume:setShowText(string.format([[<I Z="0.35">%s</I><T C="127,70,26" S="20" P="1">%d</T>]],info.icon,data.price))
	end
end

function CellRiseShopItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndRiseShop.m_root,1,tData,false,nil,true)
end
function CellRiseShopItem:onBtnChooseBuy()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tRiseShopItemData then
		if self.m_tRiseShopItemData.buyLimit ~= -1 then
			if self.m_tRiseShopItemData.buyCount >= self.m_tRiseShopItemData.buyLimit then
				MsgBoxManager:showTipBox(LocalStrings.TRANSACTION46)
				return
			end
		end
		WndRiseShopChange:showInterface(self.m_tRiseShopItemData, self.m_nRefreshTime)
	end
end
--@return	新建的表实例对象
function CellRiseShopItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
