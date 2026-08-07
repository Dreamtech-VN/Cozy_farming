--WndOpenChestData.lua
--@brief	WndOpenChest的数据模块
--@date		2015/09/17
--@author	zsq
--@note		开启宝箱

WndOpenChest = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndOpenChest:_init()
	self.m_root = nil	 	  			--场景根节点
	self.playerItemId = nil
	self.m_nNum = 0
	self.m_tData = nil
	self.m_nMaxNum = nil 				--一次最大开启数量
	self.m_tChest = nil 				--宝箱数据
	self.m_tKey = nil					--钥匙数据
	self.m_tGift = nil					--礼包数据
	self.m_nChestNum = nil				--宝箱数量
	self.m_nKeyNum = nil 				--钥匙数量
	self.m_nGiftNum = nil 				--礼包数量
	self.m_tGrid = nil
	self.m_nGridNum = nil
	self.tag = nil
	self.m_tCellGrid = nil 				--点击的格子
	self.exchange = false
	self.m_nWinType = 0 				--1=度假村使用能量药水; 2=祈福； 3=宠物；
	self.m_tLuaTable = nil 			
	self.m_tSelItem = nil 
	self.m_tCallBackFun = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndOpenChest:_unInit()
	self.m_root = nil
	self.playerItemId = nil
	self.m_nNum = nil
	self.m_tData = nil
	self.m_nMaxNum = nil 				--一次最大开启数量
	self.m_tChest = nil 				--宝箱数据
	self.m_tKey = nil					--钥匙数据
	self.m_tGift = nil					--礼包数据
	self.m_nChestNum = nil				--宝箱数量
	self.m_nKeyNum = nil 				--钥匙数量
	self.m_nGiftNum = nil 				--礼包数量
	self.m_tGrid = nil
	self.m_nGridNum = nil
	self.tag = nil
	self.m_tCellGrid = nil 
	self.exchange = nil 
	self.m_nWinType = nil 
	self.m_tLuaTable = nil 
	self.m_tSelItem = nil 
	self.m_tCallBackFun = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndOpenChest:createElement()
	local element = WZUISystem:getInstance():createElement("WndOpenChest")
	assert(element, "WndOpenChest create element failed!")
	self:_init()
	return element
end

--@brief 	外部调用接口，使用甜甜圈
function WndOpenChest:showUseInterface(nId,nType, itemId)
	-- body
	if nType == MSGBOXRESTYPE_CONFIRM then
		local wndOpenChest = WndOpenChest:createElement()
		WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
		local tData = CacheCenter:getPlayerItemById(itemId)
		WndOpenChest:setData(tData)
	end
end

--@brief 	外部调用接口
function WndOpenChest:showInterface(nId)
	-- body
	local wndOpenChest = WndOpenChest:createElement()
	WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
	local tData = CacheCenter:getPlayerItemById(nId)
	WndOpenChest:setData(tData)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	购买宝箱/钥匙后刷新数量
function WndOpenChest:updatePlayerItemData()
	self:update()
end




-------------------------------------私有方法模块End----------------------------------------
