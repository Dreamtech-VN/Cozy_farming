--WndShopDiscount.lua
--@brief	WndShopDiscount的UI模块
--@date		2020/09/28
--@author	hyx
--@note		购物界面的优惠券


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndShopDiscount:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndShopDiscount:onExit(element)
	self:_unInit()
	self:unregister()
end

function WndShopDiscount:register()
	GlobalGame:getGameEventDispathcer():Add(WndPeopleShopEvent.WndPeopleShopEvent_DiscountInfo,self._onDiscountInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onDiscountGetResult,self) --领取后的按钮状态
end
function WndShopDiscount:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndPeopleShopEvent.WndPeopleShopEvent_DiscountInfo,self._onDiscountInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onDiscountGetResult,self)
end

function WndShopDiscount:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndShopDiscount:actionCallback()
	self:initShow()
end
function WndShopDiscount:initShow()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetShoppingCoupon( )
end

function WndShopDiscount:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndShopDiscount:_onDiscountInfo(rewardIds, status, process, targets, tips1, tips2, fulls, subs)
	if next(rewardIds) == nil then return end

	local data = {}
	for i,v in ipairs(rewardIds) do
		local temp = {}
		temp.id = rewardIds[i]
		temp.status = status[i] --任务领取状态 -1不可领取| 0 可领取 | 1已领取 | 2 已使用
		temp.process = process[i]
		temp.target = targets[i]
		temp.tips1 = tips1[i]
		temp.tips2 = tips2[i]
		temp.full = fulls[i]
		temp.sub = subs[i]
		data[i] = temp
		self.m_tDiscoungRedStatus[rewardIds[i]] = status[i]
	end
	self:taskSort(data)

	local discountFreeList = GetElement(self.m_root,"discountFreeListContainer",WZUIFreeListContainer)
	if discountFreeList:size() > 0 then 
		discountFreeList:removeAll()
	end
	for i = 1, #data do
		local element, tLuaObj = CellShopDiscountItem:createElement()
		discountFreeList:pushBack(WZUIContainer:luaTo(element))
		discountFreeList:getMoveElement():setPositionX(discountFreeList:getMaxPosition().x)
		tLuaObj:setShopDiscountMessage(i, data[i])
		tLuaObj:setDiscountFuncCall(function(id)
			self.m_nTouchButtonIndex = id
		end)
		self.m_tButtonData[data[i].id] = tLuaObj
	end
end
--排序
function WndShopDiscount:taskSort(data_sort)
	local temp = {
		[0] = 0, --可领取
		[-1] = 1, --不可领取
		[1] = 2, --已领取
		[2] = 3, --已使用
	}
	local function testFunc(a,b)
		if a.status ~= b.status then
			if temp[a.status] and temp[b.status] then
				return temp[a.status] < temp[b.status]
			else
				return false
			end
		else
			return a.id < b.id
		end
	end
	table.sort(data_sort, testFunc)
end
function WndShopDiscount:_onDiscountGetResult(itemsId, count,_type, rewardId)
	if next(itemsId) == nil then --成功
		if self.m_nTouchButtonIndex and next(self.m_tButtonData) ~= nil then
			self.m_tButtonData[self.m_nTouchButtonIndex]:setGetButtonStatus(true) --改变领取按钮的状态
			self.m_tDiscoungRedStatus[self.m_nTouchButtonIndex] = 1
		end
		local red_status = false
		for i,v in pairs(self.m_tDiscoungRedStatus) do
			if v == 0 then
				red_status = true
				break
			end
		end
		WndPeopleShop:setDiscountRedPointStatus(red_status)
	end
end

-------------------------------------私有方法模块End----------------------------------------
