--WndPurchaseData.lua
--@brief	WndPurchase的数据模块
--@date		2015-10-12
--@author	binshao
--@note		商城购买接口

WndPurchase = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPurchase:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sender = nil                 --调用当前界面的发送方
	self.m_callFunction = nil           --关闭后回调函数
	self.m_nLoadingId = nil               --加载id
	self.m_nGoodsID = 0                 --购买物品id
	self.m_nPriceID = 0                 --选中的物品价格id
	self.m_bBuyResult = false           --是否购买成功
	self.m_nBuyNum = 0                  --购买数量（用于强化回调参数）
	self.m_tBuyNum = {}                 --价格协议里购买数量表
	self.m_tPrice = {}                  --购买物品的价格表
	self.m_nPrice = 0					--购买价格
	self.m_nIsDaZhe = false          	--商品是否已打折
	self.nZorder = 0                  	--设置zorder，战斗中用
	self.m_sOther = nil 				--showBuyInterface 附加参数
	self.m_nBuyType = 0 				--购买类型
	self.m_tGoodsDesc = nil 			--物品说明列表
	self.m_nOtherNum = 1 				--购买其他物品数量
	self.tShopItemList = nil
	self.m_bCommunityItem = nil
	self.m_nStoreID = nil

    self.curCellData = {}
    self.buyFlag = nil
	self.costId = 1
	self.buyType = 1		-- 1 表示赠送， 2表示索要  3表示购买
	self.selData = nil
	self.specialOffer = nil
	self.m_nOwnerId = 0					--购买的物品属于那个玩家Id
end 


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPurchase:_unInit()
	self.m_root = nil
	self.m_sender = nil                  
	self.m_callFunction = nil            
	self.m_nLoadingId = nil
	self.m_nGoodsID = nil
	self.m_nPriceID = nil
	self.m_bBuyResult = nil
	self.m_nBuyNum = nil
	self.m_tBuyNum = nil
	self.m_tPrice = nil
	self.m_nPrice = nil
	self.m_nIsDaZhe = nil  
	self.nZorder = nil
	self.m_sOther = nil 
	self.m_nBuyType = nil 
	self.m_nOtherNum = nil 	
	self.tShopItemList = nil
	self.m_bCommunityItem = nil
	self.m_nStoreID = nil

    self.curCellData = nil
    self.buyFlag = nil
	self.costId = 1
	self.buyType = 1
	self.selData = nil
	self.specialOffer = nil
	self.m_nOwnerId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPurchase:createElement()
	local element = WZUISystem:getInstance():createElement("WndPurchase")
	assert(element, "WndPurchase create element failed!")
	self:_init()
	return element
end

--------------------------------------关于错误协议回调处理----------------------------------
--@brief	错误处理函数
--@param	sMessage:错误信息
function WndPurchase:getErrorProcess(sMessage)
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
	WindowManager:removeWindow(self.m_root, self, true)
	MsgBoxManager:showTipBox(sMessage)	
end

--@brief	葡萄语包适配函数
function WndPurchase:_adaptLanguage_pt()
	local txtBuy = self.m_root:getChildElement("txtBuy_WndPurchase")
	if txtBuy then
		txtBuy = WZUILabelTTF:luaTo(txtBuy)
		txtBuy:setFontSize(24)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndPurchase:_addCurCellData(cell,tcell)
    self.curCellData.cell = cell
    self.curCellData.tcell = tcell
end



-------------------------------------私有方法模块End----------------------------------------
