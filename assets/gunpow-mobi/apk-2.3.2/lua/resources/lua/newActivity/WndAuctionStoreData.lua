--WndAuctionStoreData.lua
--@brief	WndAuctionStore的数据模块
--@date		2020/09/03
--@author	yrd
--@note		拍卖行商店

WndAuctionStore = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAuctionStore:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_currencyId = 163024 			--竞拍币id
	self.m_nResetNum = nil 				--刷新次数
	self.m_tCommodityData = nil			--商品数据

end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAuctionStore:_unInit()
	self.m_root = nil
	self.m_currencyId = nil
	self.m_nResetNum = nil
	self.m_tCommodityData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAuctionStore:createElement()
	if WndAuctionStore.m_root ~= nil then
		WindowManager:removeWindow(WndAuctionStore.m_root, WndAuctionStore, true)
	end
	local element = WZUISystem:getInstance():createElement("WndAuctionStore")
	assert(element, "WndAuctionStore create element failed!")
	self:_init()
	return element
end

--@brief	外部接口
function WndAuctionStore:showInterface()
	local wnd = WndAuctionStore:createElement()
	WindowManager:addWindow(wnd,WndAuctionStore,nil,nil,nil,true)
end

--@brief	接收数据
function WndAuctionStore:getAuctionMallInfoOk(mallId, item, exchange, price, exchangeNum, resetNum, mType, time)

	self.m_nResetNum = resetNum
	self.m_nTime = time
	self.m_tCommodityData = {}
	for i=1,#mallId do
		local tempTab = {}
		tempTab.mallId = mallId[i]
		tempTab.item = item[i]
		tempTab.exchange = exchange[i]
		tempTab.price = price[i]
		tempTab.exchangeNum = exchangeNum[i]
		tempTab.mType = mType[i]
		table.insert(self.m_tCommodityData, tempTab)
	end


	self:update()
end


--@brief	兑换成功提示
function WndAuctionStore:getExchangeAuctionItemOk()
	MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT35)
	CellAuctionHouse:updateCoinNum()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
