--WndRebateData.lua
--@brief	WndRebate的数据模块
--@date		2017/09/19
--@author	zsq
--@note		回扣商店

WndRebate = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRebate:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil
	self.startDateStr = nil
	self.endDateStr = nil
	self.buyId = nil
	self.status = nil
	self.leftTime = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRebate:_unInit()
	self.m_root = nil
	self.m_tDataList = nil
	self.startDateStr = nil
	self.endDateStr = nil
	self.buyId = nil
	self.status = nil
	self.leftTime = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRebate:createElement()
	if WndRebate.m_root ~= nil then
		WindowManager:removeWindow(WndRebate.m_root, WndRebate, true)
	end
	local element = WZUISystem:getInstance():createElement("WndRebate")
	assert(element, "WndRebate create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndRebate:setData(status, id, gainNum, itemId, costId, price, discount, leftNum, startDateStr, endDateStr, countdown) 
	if self.m_root == nil then return end

	self.m_tDataList = {}	
	for i=1,#id do
		local data = {}
		data.id = id[i]
		data.gainNum = gainNum[i]
		data.itemId = itemId[i]
		data.costId = costId[i]
		data.price = price[i]
		data.discount = discount[i]
		data.leftNum = leftNum[i]
		table.insert(self.m_tDataList, data)
	end
	self.status = status
	self.startDateStr = startDateStr
	self.endDateStr = endDateStr
	self.leftTime = countdown
	WZLog("WndRebate:setData", Serialize(self.m_tDataList))
	self:_update()
end

function WndRebate:clickSureMoney() 
	WZLog("WndRebate:clickSureMoney", self.buyId)
	ProtocolProcessorWndShop:send_MALL_DiscountStorePurchase(self.buyId )
end


-------------------------------------私有方法模块End----------------------------------------
