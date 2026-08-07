--WndBuyMultipleItemData.lua
--@brief	WndBuyMultipleItem的数据模块
--@date		2017/02/16
--@author	qixiang
--@note		用于购买多个物品

WndBuyMultipleItem = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBuyMultipleItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nitemId = nil 
	self.m_nitemCount = nil 
	self.m_ncostId = nil
	self.m_ncostCount = nil
	self.m_nStoreId = nil
	self.m_nNum = 1
	self.m_buyCallbackLua = nil
	self.m_buyCallbackFun = nil
	self.m_tLimitConfig = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBuyMultipleItem:_unInit()
	self.m_root = nil
	self.m_nitemId = nil 
	self.m_nitemCount = nil 
	self.m_ncostId = nil
	self.m_nNum = nil
	self.m_nStoreId = nil
	self.m_buyCallbackLua = nil
	self.m_buyCallbackFun = nil
	self.m_tLimitConfig = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBuyMultipleItem:createElement()
	local element = WZUISystem:getInstance():createElement("WndBuyMultipleItem")
	assert(element, "WndBuyMultipleItem create element failed!")
	self:_init()
	return element
end

-- itemId : 物品ID
-- itemCount : 可以购买的数量
-- costId : 花费的物品ID
-- costCount : 花费的价格
-- storeId : 商品ID
-- showtype : 1表示去掉+10-10按钮   可为nil
-- limitNum : 显示最大购买数 		可为nil
-- limitConfig : 配置的限购数量 		可为nil
function WndBuyMultipleItem:show(itemId,itemCount,costId,costCount,storeId,buyCallbackLua,buyCallbackFun,showtype,limitNum, limitConfig)
	WZLog("WndBuyMultipleItem:show =",costId)
	local element = WndBuyMultipleItem:createElement()
	self.m_nitemId = itemId 
	self.m_nitemCount = itemCount 
	self.m_ncostId = costId
	self.m_ncostCount = costCount
	self.m_nStoreId = storeId
	self.m_buyCallbackLua = buyCallbackLua
	self.m_buyCallbackFun = buyCallbackFun
	self.m_showtype = showtype
	self.m_limitNum = limitNum
	self.m_tLimitConfig = limitConfig
	WindowManager:addWindow(element,WndBuyMultipleItem,nil,nil,nil,true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
