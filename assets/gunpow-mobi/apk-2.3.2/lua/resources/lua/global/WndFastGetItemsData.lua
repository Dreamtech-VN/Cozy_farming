--WndFastGetItemsData.lua
--@brief	WndFastGetItems的数据模块
--@date		2016/01/21
--@author	qixiang_xie
--@note		快速跳转到相应场景获取相应物品

WndFastGetItems = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFastGetItems:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_itemId = nil             
	self.m_itemInfo = nil   
	self.m_nPossessCount = nil          --拥有的数量
	self.m_nNeedCount = nil             --需要的数量
	self.m_tTempTable = nil
	self.m_sCellChaptersName = {}
	self.m_nResetVipData = nil
	self.m_nTotleDiamond = 0
	self.m_tResetLevelID = {}
	self.m_nLoadingId = nil
	self.m_nShopTipItemId = nil         --打开商城时弹出的tip
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFastGetItems:_unInit()
	self.m_root = nil
	self.m_itemId = nil
	self.m_itemInfo = nil   
	self.m_nPossessCount = nil          
	self.m_nNeedCount = nil        
	self.m_tTempTable = nil     
	self.m_sCellChaptersName = {}
	self.m_nResetVipData = nil
	self.m_nTotleDiamond = 0
	self.m_tResetLevelID = {}
	self.m_nLoadingId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFastGetItems:createElement()
	if WndFastGetItems.m_root ~= nil then
		WindowManager:removeWindow(WndFastGetItems.m_root, WndFastGetItems, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFastGetItems")
	assert(element, "WndFastGetItems create element failed!")
	self:_init()
	return element
end

--@brief  设置物品ID
--@param  itemId:物品ID
function WndFastGetItems:setGetItemId(itemId)
	WZLog("WndFastGetItems:setGetItemId")
	if itemId ~= nil then
		self.m_itemInfo = GDatatab_item["id_" .. itemId]
	end
end

--@brief   设置物品拥有的数量与需要的数量
--@param   possessCount : 拥有数量
--@param   needCount：需要的数量
function WndFastGetItems:setItemCount(possessCount,needCount)
	WZLog("WndFastGetItems:setItemCount")
	self.m_nPossessCount = possessCount          
	self.m_nNeedCount = needCount             
end

--@brief	打开入口
function WndFastGetItems:show(itemId,needCount)
	WZLog("WndFastGetItems:show ",itemId)
	if itemId then
		local itemInfo = GDatatab_item["id_" .. itemId ]
		local channel = itemInfo.channel
		if type(channel) == "number" and channel <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.FAST_GET_ITEM)
			return
		end
		local wndFastGetItems = WndFastGetItems:createElement()
		WndFastGetItems:setGetItemId(itemId)
		local itemCount = CacheCenter:getPlayerItemCountById(itemId) 
		if (itemCount == -1 and itemInfo.main_type == 5) or (itemCount > 1 and itemInfo.main_type == 5 ) then
			itemCount = 1
		end
		if itemId == 97 then --牧场币的时候
			itemCount = WndPastureBusiness:getCoinNumber()
		elseif itemId == 99 then
			itemCount = WndPastureBusiness:getWorkerNumber()
		end
		local needCou = 1
		if needCount ~= nil then
			needCou = needCount
		end
		WndFastGetItems:setItemCount(itemCount,needCou)
		WindowManager:addWindow(wndFastGetItems,WndFastGetItems,nil,nil,nil,true)
	end
end

--@brief   创建加载框
function WndFastGetItems:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndFastGetItems:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
