--CellRechargePacksData.lua
--@brief	CellRechargePacks的数据模块
--@date		2017/05/28
--@author	 
--@note		充值礼包

CellRechargePacks = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellRechargePacks:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData= nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRechargePacks:_unInit()
	self.m_root = nil
	self.m_tData= nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellRechargePacks:createElement()
	if CellRechargePacks.m_root ~= nil then
		WindowManager:removeWindow(CellRechargePacks.m_root, CellRechargePacks, true)
	end
	local element = WZUISystem:getInstance():createElement("CellRechargePacks")
	assert(element, "CellRechargePacks create element failed!")
	self:_init()
	return element
end



function CellRechargePacks:setData(tData)
	WZLog("CellRechargePacks:setData")
	self.m_tData=tData
end

function CellRechargePacks:initDataForSDK()
	WZLog("CellRechargePacks:initDataForSDK")
	local itemInfo = GDatatab_item["id_"..self.data.itemId]
	local productName = itemInfo.name
	local productDesc = self.data.name
	local quantifier = LocalStrings.SHOP_IND
	local number = self.data.number
	if self.data.itemId == 50 or self.data.itemId == 51 or self.data.itemId == 52 or self.data.itemId == 55 or self.data.itemId == 56 then
		quantifier = LocalStrings.Expand
		number = 1
	end
	self.sdkData = {
		id = self.data.ids,
		price = self.data.price,
		payCode = self.data.payCodeId,
		productName = productName,
		productDesc = productDesc,
		quantifier = quantifier,
		number = math.max(1,number),
		giftNumber = self.data.giftNumber,
	}
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
