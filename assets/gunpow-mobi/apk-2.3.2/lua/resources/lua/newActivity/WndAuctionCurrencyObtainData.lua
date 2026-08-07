--WndAuctionCurrencyObtainData.lua
--@brief	WndAuctionCurrencyObtain的数据模块
--@date		2020/08/04
--@author	yrd
--@note		竞拍币获取途径

WndAuctionCurrencyObtain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAuctionCurrencyObtain:_init()
	self.m_root = nil	 	  			--场景根节点

	self.m_nType = nil					--1竞拍币获取途径 2拍卖规则
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAuctionCurrencyObtain:_unInit()
	self.m_root = nil

	self.m_nType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAuctionCurrencyObtain:createElement()
	if WndAuctionCurrencyObtain.m_root ~= nil then
		WindowManager:removeWindow(WndAuctionCurrencyObtain.m_root, WndAuctionCurrencyObtain, true)
	end
	local element = WZUISystem:getInstance():createElement("WndAuctionCurrencyObtain")
	assert(element, "WndAuctionCurrencyObtain create element failed!")
	self:_init()
	return element
end

function WndAuctionCurrencyObtain:showInterface(nType)
	local wndAuctionCurrencyObtain = WndAuctionCurrencyObtain:createElement()
	WindowManager:addWindow(wndAuctionCurrencyObtain, WndAuctionCurrencyObtain, nil, nil, nil, true)

	self.m_nType = nType
	self:updateUI()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
