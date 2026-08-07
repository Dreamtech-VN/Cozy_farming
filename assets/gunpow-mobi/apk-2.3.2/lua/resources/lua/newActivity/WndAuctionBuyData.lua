--WndAuctionBuyData.lua
--@brief	WndAuctionBuy的数据模块
--@date		2020/09/03
--@author	yrd
--@note		拍卖行商店购买

WndAuctionBuy = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAuctionBuy:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nitemId = nil
	self.m_nitemCount = nil
	self.m_ncostId = nil
	self.m_ncostCount = nil
	self.m_nStoreId = nil
	self.m_buyCallbackLua = nil
	self.m_buyCallbackFun = nil
	self.m_nlimitNum = nil
	self.m_nMaxAddNUm = 10 				--一次最多增加数
	self.m_nMaxSubtractNUm = 10 		--一次减少增加数
	self.m_nCurNum = 1 					--当前数量
	self.m_nWinType = 0 				--默认=0，小岛果园=1，保龄球俱乐部=2，度假村商店=3
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAuctionBuy:_unInit()
	self.m_root = nil
	self.m_nitemId = nil
	self.m_nitemCount = nil
	self.m_ncostId = nil
	self.m_ncostCount = nil
	self.m_nStoreId = nil
	self.m_buyCallbackLua = nil
	self.m_buyCallbackFun = nil
	self.m_nlimitNum = nil
	self.m_nMaxAddNUm = nil 					--一次最多增加数
	self.m_nMaxSubtractNUm = nil 				--一次减少增加数
	self.m_nCurNum = nil 						--当前数量
	self.m_nWinType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAuctionBuy:createElement()
	if WndAuctionBuy.m_root ~= nil then
		WindowManager:removeWindow(WndAuctionBuy.m_root, WndAuctionBuy, true)
	end
	local element = WZUISystem:getInstance():createElement("WndAuctionBuy")
	assert(element, "WndAuctionBuy create element failed!")
	self:_init()
	return element
end

-- itemId : 物品ID
-- itemCount : 可以购买的数量
-- costId : 花费的物品ID
-- costCount : 花费的数量
-- storeId : 商品ID
-- limitNum : 上限
function WndAuctionBuy:show(itemId,itemCount,costId,costCount,storeId,buyCallbackLua,buyCallbackFun,limitNum, nWinType)
	local wnd = WndAuctionBuy:createElement()
	self.m_nitemId = itemId
	self.m_nitemCount = itemCount
	self.m_ncostId = costId
	self.m_ncostCount = costCount
	self.m_nStoreId = storeId
	self.m_buyCallbackLua = buyCallbackLua
	self.m_buyCallbackFun = buyCallbackFun
	self.m_nlimitNum = limitNum
	self.m_nWinType = nWinType or 0 
	WindowManager:addWindow(wnd,WndAuctionBuy,nil,nil,nil,true)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
