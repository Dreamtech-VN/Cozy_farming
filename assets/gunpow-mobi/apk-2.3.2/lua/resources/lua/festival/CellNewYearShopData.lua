--CellNewYearShopData.lua
--@brief	CellNewYearShop的数据模块
--@date		2020/12/24
--@author	hyx
--@note		新年商城

CellNewYearShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewYearShop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sShopItemTableContainer = nil
	self.m_tShopItemCell = {}
	self.m_tShopItemCellData = {}
	self.m_nRefreshPrice = 0 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearShop:_unInit()
	self.m_root = nil
	self.m_sShopItemTableContainer = nil
	self.m_tShopItemCell = {}
	self.m_tShopItemCellData = {}
	self.m_nRefreshPrice = 0 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewYearShop:createElement()
	if CellNewYearShop.m_root ~= nil then
		WindowManager:removeWindow(CellNewYearShop.m_root, CellNewYearShop, true)
	end

	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellNewYearShop")
	assert(element, "CellNewYearShop create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

function CellNewYearShop:setActivityIdORType(activityId, _type)
	self.m_nActivityId = activityId
	self.m_nActivityType = _type
end

function CellNewYearShop:setShopItemData(data)
	if not data then return end
	for i=1, #data.ids do
		local tab = {}
		tab.activityid = self.m_nActivityId
		tab.version = data.version
		tab.id = data.ids[i]
		tab.item_id = data.itemIds[i]
		tab.item_num = data.itemNums[i]
		tab.price = data.prices[i]
		tab.num = data.nums[i]
		self.m_tShopItemCellData[data.ids[i]] = tab
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewYearShop:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellNewYearShop.m_current = tNewObj
	return tNewObj
end


-------------------------------------私有方法模块End----------------------------------------

CellNewYearShopItem = {}
function CellNewYearShopItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearShopItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellNewYearShopItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	--春节狂欢
	--element:setAbsContentSize(GlobalMethod:CCSize(178,174))
	--周年庆典
	element:setAbsContentSize(GlobalMethod:CCSize(156,168))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellNewYearShopItem:setNewYearShopItemMessage(index, data)
	self.m_nIndex = index
	self.m_sShopItemData = data
end

--@brief 	开始加载
function CellNewYearShopItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("newYearShopItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setShopItemDataItem()
end

function CellNewYearShopItem:setShopItemDataItem()
	if not self.m_sShopItemData then return end

	local data = self.m_sShopItemData
	GetElement(self.m_root,"buyConsumeDiamond",WZUILabelTTF):setText(data.price)
	if data.item_num == -1 then 
		GetElement(self.m_root,"icon_num",WZUILabelTTF):setText(LocalStrings.NOLIMIT)
	else
		GetElement(self.m_root,"icon_num",WZUILabelTTF):setText(data.item_num)
	end
	self:setItemNumText(data.num)

	local good_item = GetElement(self.m_root,"good_item",WZUIContainer)
	local item = GDatatab_item["id_"..data.item_id]
	local itemInfo = {id = item.id, name=item.name,icon=item.icon,lastTime=data.item_num,quality=item.quality,basicInfo=CopyTable(item)}
	local celElement,tCell = CellGoodItem:createElement()
	if celElement and tCell ~= nil then
		celElement:setTag(self.m_nIndex)
		tCell:setCellGoodItem(itemInfo,5)
		good_item:addChild(celElement)
	end
end
function CellNewYearShopItem:setItemNumText(num)
	local buyCount = GetElement(self.m_root,"buyCount",WZUILabelTTF)
	if buyCount then
		buyCount:setText(num)
	end
	if num <= 0 then 
		GetElement(self.m_root, "conSellout_CellNewYearShop", WZUIContainer):setVisible(true)
	end
end

function CellNewYearShopItem:onBtnClickBuy(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_sShopItemData then
		local tData = GDatatab_item["id_"..self.m_sShopItemData.item_id]
		WndItemInfo:showInfo(element, WndNewYearActivityMain.m_root,1,tData,true,nil,true,{interface = 2, tcell = self})
	end
end
function CellNewYearShopItem:onClickbuyBtn()
	if self.m_sShopItemData then
		if not JudgeMoneyIsEnough(1, self.m_sShopItemData.price, nil, nil, GlobalGame.g_nCurrentUIChannelId) then 
			return
		end
		local tab = {}
		tab.buyId = self.m_sShopItemData.id
		tab.version = self.m_sShopItemData.version
		tab = json.encode(tab)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_sShopItemData.activityid, 1, tab)
	end
end
--@return	新建的表实例对象
function CellNewYearShopItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end