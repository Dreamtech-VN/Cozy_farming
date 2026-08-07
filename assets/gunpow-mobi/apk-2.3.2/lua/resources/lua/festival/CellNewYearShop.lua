--CellNewYearShop.lua
--@brief	CellNewYearShop的UI模块
--@date		2020/12/24
--@author	hyx
--@note		新年商城


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewYearShop:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewYearShop:onExit(element)
	self:unregister()
	self:_unInit()
end

function CellNewYearShop:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetShopInfo,self)
end
function CellNewYearShop:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetShopInfo,self)
end

function CellNewYearShop:onEnterTransitionDidFinish(element)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 0, "")
	self.m_sShopItemTableContainer = GetElement(self.m_root,"shopItemTableContainer",WZUITableContainer)
end

function CellNewYearShop:onBtnClickRefresh()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not JudgeMoneyIsEnough(1, self.m_nRefreshPrice, nil, nil, GlobalGame.g_nCurrentUIChannelId) then 
		return
	end
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
end
function CellNewYearShop:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewYearShop:_onGetShopInfo(activityId, doType, result, msg)
	if self.m_nActivityId == activityId then
		if self.m_sShopItemTableContainer and msg then
			msg = json.decode(msg)
			if doType == 0 or doType == 2 then --获取列表/刷新
				local str = msg.refreshCount .."/"..msg.refreshLimit
				GetElement(self.m_root,"remainRefreshCount",WZUILabelTTF):setText(str)
				GetElement(self.m_root,"consumeDiamondCount",WZUILabelTTF):setText(msg.refreshPrice)
				self.m_nRefreshPrice = msg.refreshPrice
				self.m_sShopItemTableContainer:cleanTable()
				self:setShopItemData(msg)
				for i=1, #self.m_tShopItemCellData do
					local celElement,tCell = CellNewYearShopItem:createElement()
					self.m_tShopItemCell[i] = tCell
					celElement:setTag(i-1)
					self.m_sShopItemTableContainer:setCellElement(celElement)
					tCell:setNewYearShopItemMessage(i-1, self.m_tShopItemCellData[i])
				end
			elseif doType == 1 then --购买
				WndRewardShow:showById(msg.itemIds,msg.itemNums)
				if self.m_tShopItemCell[msg.id] then
					self.m_tShopItemCell[msg.id]:setItemNumText(msg.num)
				end
			end
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function CellNewYearShop:_adaptLanguage_vn(bool)
	GetElement(self.m_root,"txtRemainRefreshCount_CellNewYearShop",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.59,0.87))
	GetElement(self.m_root,"txtConsumeDiamondCount_CellNewYearShop",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.76,0.87))
end
-------------------------------------语言适配end----------------------------------------
