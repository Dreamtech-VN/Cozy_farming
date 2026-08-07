--WndFootShopData.lua
--@brief	WndFootShop的数据模块
--@date		2021/11/02
--@author	XTX
--@note		足迹城市商店

WndFootShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFootShop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurPosY = nil  
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFootShop:_unInit()
	self.m_root = nil
	self.m_nCurPosY = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFootShop:createElement()
	if WndFootShop.m_root ~= nil then
		WindowManager:removeWindow(WndFootShop.m_root, WndFootShop, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFootShop")
	assert(element, "WndFootShop create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndFootShop:showInterface(tCoinList)
	local wndFoot = WndFootShop:createElement()
	if wndFoot then 
		self.m_tCoinList = tCoinList
		WindowManager:addWindow(wndFoot, WndFootShop, false, nil, nil, true)
	end
end

--@brief   设置商店数据
function WndFootShop:setShopItemData(ids, itemIds, nums, dayLimits, canBuys, costItemIds, costNums)
	self.m_tShopList = {}

	for i = 1, #ids do
		local tItem = {}

		tItem.id = ids[i] 
		tItem.itemId = itemIds[i]
		tItem.itemNum = nums[i]
		tItem.limitNum = dayLimits[i]
		tItem.canBuys = canBuys[i]
		tItem.costId = costItemIds[i]
		tItem.costNum = costNums[i]

		table.insert(self.m_tShopList, tItem)
	end

	self:update()
end

function WndFootShop:buySuccess(status, itemId, itemNum)
	if self.m_root == nil then return end 
	
	if status == 1 then  
		WndRewardShow:showById(itemId, itemNum)
		local tabList = GetElement(self.m_root, "tabList_WndFootShop", WZUITableContainer)
		self.m_nCurPosY = tabList:getMoveElement():getPositionY()
		ProtocolProcessorFootMark:send_FOOTMARK_GetFootMarkCityShop()
	elseif status == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT31)
	elseif status == 4 then 
		MsgBoxManager:showTipBox(LocalStrings.SHOP_DAY_LIMITED)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
