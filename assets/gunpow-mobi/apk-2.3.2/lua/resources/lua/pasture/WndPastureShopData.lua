--WndPastureShopData.lua
--@brief	WndPastureShop的数据模块
--@date		2021/04/17
--@author	hyx
--@note		牧场商店

WndPastureShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPastureShop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tShopData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPastureShop:_unInit()
	self.m_root = nil
	self.m_tShopData = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPastureShop:createElement()
	if WndPastureShop.m_root ~= nil then
		WindowManager:removeWindow(WndPastureShop.m_root, WndPastureShop, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPastureShop")
	assert(element, "WndPastureShop create element failed!")
	self:_init()
	return element
end

function WndPastureShop:setPastureShopData()
	if GDatatab_pasture_mounts then
		for i,v in pairs(GDatatab_pasture_mounts) do
			local tab = {}
			tab.id = v.id
			tab.level = v.level
			tab.name = v.name
			tab.animal_id = v.animation_index_code
			tab.reward = v.output[1]
			tab.price = v.price[1]
			self.m_tShopData[v.id] = tab
		end
		table.sort( self.m_tShopData, function(a,b) 
			return a.level < b.level
		end)
	end
end
--==============商店子项===================
PastureShopItem = {}
function PastureShopItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function PastureShopItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function PastureShopItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(226,236))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function PastureShopItem:setCellShopData(data)
	self.m_sCellShopData = data
end

--@brief 	开始加载
function PastureShopItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("PastureShopItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()
end

function PastureShopItem:setData()
	if not self.m_sCellShopData then return end

	local mark_con = GetElement(self.m_root,"mark_con",WZUIContainer)
	local pastureLev = WndPastureBusiness:getCurPastureMountMaxLevel()
	if (pastureLev - 3) <= 1 then
		pastureLev = 1
	else
		pastureLev = pastureLev - 3
	end
	if pastureLev >= self.m_sCellShopData.level then
		mark_con:setVisible(false)
	else
		mark_con:setVisible(true)
	end

	GetElement(self.m_root,"txtName",WZUILabelTTF):setText(self.m_sCellShopData.name)
	GetElement(self.m_root,"txtLev",WZUILabelTTF):setText("Lv."..self.m_sCellShopData.level)
	local ani_con = GetElement(self.m_root,"ani_con",WZUIContainer)
	local ani = CreateRunMountNoPlayer(self.m_sCellShopData.animal_id, "wait")
    ani:getAnimNode():setScale(0.4)
    ani_con:addChild(ani:getAnimNode())

	local get_icon = GetElement(self.m_root,"get_icon",WZUIImage)
	local info = GDatatab_item["id_"..self.m_sCellShopData.reward[1]]
	if info then
		get_icon:setFile(info.icon)
	end
	GetElement(self.m_root,"txtProduceExp",WZUILabelTTF):setText(self.m_sCellShopData.reward[2].."/10"..LocalStrings.SECOND)
	local imgPriceIcon = GetElement(self.m_root,"imgPriceIcon",WZUIImage)
	local info = GDatatab_item["id_"..self.m_sCellShopData.price[1]]
	if info then
		imgPriceIcon:setFile(info.icon)
	end
	GetElement(self.m_root,"txtBuyPrice",WZUILabelTTF):setText(self.m_sCellShopData.price[2])
end

function PastureShopItem:onBtnBuy()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local level = WndPastureBusiness:getPastureLevel()
	local lev_info = WndPastureBusiness:getPastureLevelExp(level)
	local cur_num = WndPastureBusiness:getHasMountNum()
	if lev_info then
		if cur_num >= lev_info.num then
			MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT17)
			return
		end
	end
	if self.m_sCellShopData then
		local itemCount = WndPastureBusiness:getCoinNumber()
		if itemCount >= self.m_sCellShopData.price[2] then
			ProtocolProcessorFamily:send_MOUNTSPASTURE_PurchasePastureMounts(self.m_sCellShopData.id)
		else
			WndFastGetItems:show(self.m_sCellShopData.price[1], self.m_sCellShopData.price[2])
		end
	end
end

function PastureShopItem:onBtnClickLock(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local info = GDatatab_pasture_mounts["id_"..(self.m_sCellShopData.id+3)]
	if info then
		MsgBoxManager:showTipBox(string.format(LocalStrings.PASTURE_TEXT53, info.level, info.name))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@return	新建的表实例对象
function PastureShopItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
