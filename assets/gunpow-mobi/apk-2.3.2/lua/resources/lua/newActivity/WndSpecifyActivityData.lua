--WndSpecifyActivityData.lua
--@brief	WndSpecifyActivity的数据模块
--@date		2017/08/21
--@author	Tianxiang_Xu
--@note		定向推送活动

WndSpecifyActivity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSpecifyActivity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tListItem = nil
	self.m_nCurItemId = nil 
	self.m_tCommonPanelElement = nil 
	self.m_tCommonPanelLuaObj = nil 
	self.m_nLoadingId = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSpecifyActivity:_unInit()
	self.m_root = nil
	self.m_tListItem = nil
	self.m_nCurItemId = nil 
	self.m_tCommonPanelElement = nil 
	self.m_tCommonPanelLuaObj = nil 
	self.m_nLoadingId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSpecifyActivity:createElement()
	if WndSpecifyActivity.m_root ~= nil then
		WindowManager:removeWindow(WndSpecifyActivity.m_root, WndSpecifyActivity, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSpecifyActivity")
	assert(element, "WndSpecifyActivity create element failed!")
	self:_init()
	return element
end

--@brief 	设置礼包数据
function WndSpecifyActivity:setGiftData(pushInfo, count, originPrice)
	-- body
	self.m_tListItem = {}
	WZLog("WndSpecifyActivity:setGiftData", Serialize(pushInfo))
	local item_id = {}
	local giftType = {}
	for i=1, #pushInfo do
		local string = string.sub(pushInfo[i],2,-2) 
		local gType = SplitStringWithSeparator(string,",")[1]
		local id = SplitStringWithSeparator(string,",")[2]
		table.insert(giftType, tonumber(gType))
		table.insert(item_id, tonumber(id))
	end

	for i = 1, #item_id do
		local tItem = {}
		tItem.item_id = item_id[i]
		tItem.count = count[i]
		tItem.giftType = giftType[i]
		if originPrice then
			tItem.originPrice = originPrice[i]
		end
		if giftType[i] == 1 then 
			local vipData = GDatatab_recharge["id_" .. item_id[i]]
			tItem.name = GDatatab_item["id_" .. vipData.item_id].name 
			table.insert(self.m_tListItem, tItem)	
		else
			local tShopData = CacheCenter:getShopGoodData(item_id[i])
			tItem.name = GDatatab_item["id_" .. tShopData.shopItemId].name 
			table.insert(self.m_tListItem, tItem)
		end
	end

	self:_update()
end

--@brief 	外部接口 (originPrice是物品打折前原价,没有可忽略)
function WndSpecifyActivity:showInterface(pushInfo, lastNum, originPrice)
	-- body
	local wndSpecifyActivity = WndSpecifyActivity:createElement()
	if wndSpecifyActivity then
		WindowManager:addWindow(wndSpecifyActivity, WndSpecifyActivity, false, nil, nil, true)
		WndSpecifyActivity:setGiftData(pushInfo, lastNum, originPrice)
	end
end

--@brief 	购买礼包成功、
function WndSpecifyActivity:buyResult(itemId, count)
	-- body
	--重新获取登录定向数据
	if tostring(ProjConfig:getChannelId()) ~= "53" and tostring(ProjConfig:getChannelId()) ~= "75" and tostring(ProjConfig:getChannelId()) ~= "275" then
		ProtocolProcessorCommonPush:send_COMMONPUSH_LoginDirectionalPush( )
	end
	self:_stopLoading()
	if self.m_tCommonPanelLuaObj then 
		local item_id = self.m_tCommonPanelLuaObj:getKeyId()
		local vipData = GDatatab_recharge["id_" .. item_id]
		--更新剩余次数
		for i = 1, #self.m_tListItem do
			local tTempData = GDatatab_recharge["id_" .. self.m_tListItem[i].item_id]
	        if tTempData and tTempData.item_id == itemId then
	        	if self.m_tListItem[i].count ~= -1 and self.m_tListItem[i].count >= count then 
	        		self.m_tListItem[i].count = self.m_tListItem[i].count - count
	        	end
	            break
	        end
	    end

	    if vipData.item_id == itemId then 
	    	for i = 1, count do
				self.m_tCommonPanelLuaObj:resetLeftCount()
			end
		end
	end
end

--@brief 	购买礼包成功、
function WndSpecifyActivity:buyResultType2()
	-- body
	self:_stopLoading()
	if self.m_tCommonPanelLuaObj then 
		local item_id = self.m_tCommonPanelLuaObj:getKeyId()
		--更新剩余次数
		for i = 1, #self.m_tListItem do
	        if self.m_tListItem[i].item_id == item_id then
	        	if self.m_tListItem[i].count ~= -1 and self.m_tListItem[i].count > 0 then 
	        		self.m_tListItem[i].count = self.m_tListItem[i].count - 1
	        	end
	            break
	        end
	    end

		self.m_tCommonPanelLuaObj:resetLeftCount()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    数据加载动画
function WndSpecifyActivity:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndSpecifyActivity:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end





-------------------------------------私有方法模块End----------------------------------------
