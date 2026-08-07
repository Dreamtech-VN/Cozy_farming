--WndPeopleShopData.lua
--@brief	WndPeopleShop的数据模块
--@date		2020/09/27
--@author	hyx
--@note		全民购物

WndPeopleShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPeopleShop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_refresData = nil --商城刷新日期
	self.m_tChooseItemDelete = {}		--勾选删除的物品
	self.m_tDeleteIitemGoods = nil
	self.m_nTouchCardIndex = 0
	self.m_tChooseItemID = {} 			--保存选中物品的id，方便删除的时候使用或者是避免重复
	self.m_tChooseShopCarMsg = {} --用来保存选中物品的信息(物品id，数量，购买的数量, 单个物品的价格)
	self.m_tCreateShopCarItem = {} --购物车是否创建的物品，如果有的话就只改变数量即可
	self.m_tDiscountMaxPrice = {} --优惠券的优惠最大价格
	self.m_nCurrentCoin = 0 --购物币
	self.m_tIsDeleteTips = {} --用来判断是否有物品删除的提示
	self.m_tContent = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPeopleShop:_unInit()
	self.m_root = nil
	self.m_refresData = nil
	self.m_tChooseItemDelete = {}
	self.m_tDeleteIitemGoods = nil
	self.m_nTouchCardIndex = 0
	self.m_tChooseItemID = {}
	self.m_tChooseShopCarMsg = {}
	self.m_tCreateShopCarItem = {}
	self.m_tDiscountMaxPrice = {}
	self.m_nCurrentCoin = 0
	self.m_tIsDeleteTips = {}
	self.m_tContent = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPeopleShop:createElement()
	if WndPeopleShop.m_root ~= nil then
		WindowManager:removeWindow(WndPeopleShop.m_root, WndPeopleShop, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPeopleShop")
	assert(element, "WndPeopleShop create element failed!")
	self:_init()
	return element
end


--************** 商店的item *******************
CellPeopleShopItem = {}
function CellPeopleShopItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPeopleShopItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellPeopleShopItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(288,165))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellPeopleShopItem:setCallFuncShopItem(callfunc)
	self.peopleShopCallfunc = callfunc
end
function CellPeopleShopItem:setShopItemMessage(index, data)
	self.index = index
	self.m_sShopItemData = data
end
--@brief 	开始加载
function CellPeopleShopItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("shop_item")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setShopItemData()
end

function CellPeopleShopItem:setShopItemData()
	if not self.m_sShopItemData then return end

	self.buy_count = GetElement(self.m_root,"buy_count",WZUILabelTTF)
	self.m_nTouchBuyNum = 1
	self.buy_count:setText(self.m_nTouchBuyNum)

	GetElement(self.m_root,"discount_price",WZUILabelTTF):setText(self.m_sShopItemData.price)
	GetElement(self.m_root,"limit_price",WZUILabelTTF):setText(self.m_sShopItemData.limit_num)
	self.m_nLimitNum = self.m_sShopItemData.limit_num or 0
	local itemMark = GetElement(self.m_root,"itemMark",WZUIImage)
	if self.m_nLimitNum <= 0 then
		itemMark:setVisible(true)
	else
		itemMark:setVisible(false)
	end

	local good_con = GetElement(self.m_root,"good_con",WZUIContainer)
	local key = "id_"..self.m_sShopItemData.id
	local tabItem = GDatatab_item[key]
	local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=self.m_sShopItemData.num,quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
	local celElement,tCell = CellGoodItem:createElement()
	tCell:setCellGoodItem(itemInfo,16)
	tCell:setItemClickFun(WndPeopleShop,self.onItemClick)
	good_con:addChild(celElement)
end

--@brief	点击物品弹出对应的tips
function CellPeopleShopItem:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndPeopleShop.m_root,1,tData,false,nil,true)
end

function CellPeopleShopItem:onBtnClickRedu()
	if not self.buy_count then return end
	if self.m_nTouchBuyNum <= 1 then
		MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT17)
		return
	end
	self.m_nTouchBuyNum = self.m_nTouchBuyNum - 1
	self.buy_count:setText(self.m_nTouchBuyNum)
end
function CellPeopleShopItem:onBtnClickAdd()
	if not self.buy_count then return end
	if self.m_nTouchBuyNum >= self.m_nLimitNum then
		MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT18)
		return
	end
	self.m_nTouchBuyNum = self.m_nTouchBuyNum + 1
	self.buy_count:setText(self.m_nTouchBuyNum)
end
----进入购物车
function CellPeopleShopItem:onBtnClickShopCard()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_sShopItemData then return end

	if self.peopleShopCallfunc then
		--物品id，数量，购买的数量, 单个物品的价格, 商品id
		self.peopleShopCallfunc(self.m_sShopItemData.id, self.m_sShopItemData.num, self.m_nTouchBuyNum, self.m_sShopItemData.price, self.m_sShopItemData.shop_id)
	end
end
--@return	新建的表实例对象
function CellPeopleShopItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
--***********************************
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
