--WndBuyGoodsData.lua
--@brief	WndBuyGoods的数据模块
--@date		2014/04/28
--@author	林庆凯
--@note		购买红包/礼炮的窗口

WndBuyGoods = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBuyGoods:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nPrice = nil                 --商品单价
	self.m_nCostType = nil            --消耗类型(2钻石\1金币)
	self.m_lpBackButtonCallback = nil
	self.m_tCallBackLuaObjMap = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBuyGoods:_unInit()
	self.m_root = nil
	self.m_nPrice = nil                 
	self.m_nCostType = nil      
	self.m_lpBackButtonCallback = nil
	self.m_tCallBackLuaObjMap =  nil       
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBuyGoods:createElement()
	local element = WZUISystem:getInstance():createElement("WndBuyGoods")
	assert(element, "WndBuyGoods create element failed!")
	self:_init()
	return element
end

--@brief	设置返回按钮点击回调(可置空)
--@param	callback:回调函数引用
--@param	tLuaObj:回调函数所属表对象
--@note		主要用于退出场景时回调
function WndBuyGoods:setBackButtonCallback(callback, tLuaObj)
	WZLog("WndBuyGoods:setBackButtonCallback")
    self.m_lpBackButtonCallback = callback
	self.m_tCallBackLuaObjMap[callback] = tLuaObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
