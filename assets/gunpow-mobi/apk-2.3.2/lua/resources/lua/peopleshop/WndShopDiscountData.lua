--WndShopDiscountData.lua
--@brief	WndShopDiscount的数据模块
--@date		2020/09/28
--@author	hyx
--@note		购物界面的优惠券

WndShopDiscount = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndShopDiscount:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tButtonData = {}
	self.m_nTouchButtonIndex = nil --点击的按钮
	self.m_tDiscoungRedStatus = {} --优惠券的红点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndShopDiscount:_unInit()
	self.m_root = nil
	self.m_tButtonData = {}
	self.m_nTouchButtonIndex = nil
	self.m_tDiscoungRedStatus = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndShopDiscount:createElement()
	if WndShopDiscount.m_root ~= nil then
		WindowManager:removeWindow(WndShopDiscount.m_root, WndShopDiscount, true)
	end
	local element = WZUISystem:getInstance():createElement("WndShopDiscount")
	assert(element, "WndShopDiscount create element failed!")
	self:_init()
	return element
end

--************** 优惠券item *******************
CellShopDiscountItem = {}
function CellShopDiscountItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellShopDiscountItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellShopDiscountItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(214,434))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellShopDiscountItem:setShopDiscountMessage(index, data)
	self.index = index
	self.m_sShopDiscountData = data
end
--@brief 	开始加载
function CellShopDiscountItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("discount_item")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setShopDiscountData()
end

function CellShopDiscountItem:setShopDiscountData()
	if not self.m_sShopDiscountData then return end

	GetElement(self.m_root,"disCountPrice",WZUILabelTTF):setText(self.m_sShopDiscountData.sub)
	local disTask1 = GetElement(self.m_root,"disTask1",WZUILabelTTF)
	local str1 = string.format(self.m_sShopDiscountData.tips1, self.m_sShopDiscountData.process, self.m_sShopDiscountData.target)
	disTask1:setText(str1)
	
	local str2 = string.format(self.m_sShopDiscountData.tips2, self.m_sShopDiscountData.full)
	local disTask2 = GetElement(self.m_root,"disTask2",WZUILabelTTF)
	disTask2:setText(str2)

	GetElement(self.m_root,"discountIsGet",WZUIImage):setVisible(self.m_sShopDiscountData.status == 1)
	GetElement(self.m_root,"discountIsUse",WZUIImage):setVisible(self.m_sShopDiscountData.status == 2)

	local discountBtnGet = GetElement(self.m_root,"discountBtnGet",WZUIButton)
	discountBtnGet:setVisible(false)
	if self.m_sShopDiscountData.status == 0 then
		discountBtnGet:setVisible(true)
		discountBtnGet:setTouchEnable(true)
	elseif self.m_sShopDiscountData.status == -1 then
		discountBtnGet:setVisible(true)
		discountBtnGet:setTouchEnable(false)
	end
end
function CellShopDiscountItem:setGetButtonStatus(status)
	local discountBtnGet = GetElement(self.m_root,"discountBtnGet",WZUIButton)
	local discountIsGet = GetElement(self.m_root,"discountIsGet",WZUIImage)
	if status == true then
		discountBtnGet:setVisible(false)
		discountIsGet:setVisible(true)
	end
end

function CellShopDiscountItem:setDiscountFuncCall(func)
	self.discountFunc = func
end

function CellShopDiscountItem:onBtnClickGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_sShopDiscountData then return end
	if self.discountFunc then
		self.discountFunc(self.m_sShopDiscountData.id)
	end
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(tonumber(g_cityExtenInfo.shoppingActivity), self.m_sShopDiscountData.id)
end
--@return	新建的表实例对象
function CellShopDiscountItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
