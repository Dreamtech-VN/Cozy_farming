--CellGrowupHave.lua
--@brief	CellGrowupHave的UI模块
--@date		2020/11/30
--@author	hyx
--@note		成长必备


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGrowupHave:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGrowupHave:onExit(element)
	if self.m_sBuyResultTicker then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sBuyResultTicker)
		self.m_sBuyResultTicker = nil
	end 
	self:_unInit()
end

--
function CellGrowupHave:onEnterTransitionDidFinish(element)
	-- ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(self.m_nGameActivityId,self.m_nGameActivityType)
end
--@brief    显示窗口
function CellGrowupHave:showWindow( )
	local growupActivityTime = GetElement(self.m_root,"growupActivityTime",WZUILabelTTF)
	if growupActivityTime then
		growupActivityTime:setText(SystemTime:getTimeConverLocal4(self.m_nStartTime).."-"..SystemTime:getTimeConverLocal4(self.m_nEndTime))
	end

	local GrowupFreeList = GetElement(self.m_root,"GrowupFreeListContainer",WZUIFreeListContainer)
	GrowupFreeList:removeAll()
	for i = 1, #self.m_tRewardData do
		local element, tLuaObj = CellGrowupHaveItem:createElement()
		GrowupFreeList:pushBack(WZUIContainer:luaTo(element))
		GrowupFreeList:getMoveElement():setPositionX(GrowupFreeList:getMaxPosition().x)
		tLuaObj:setMessage(i, self.m_tRewardData[i])
		tLuaObj:setBuyFunc(function(change_id, count)
			self:setBuyResult(change_id, count)
		end)
	end
end
function CellGrowupHave:setBuyResult(change_id, count)
	if self.m_sBuyResultTicker then
		MsgBoxManager:showTipBox(LocalStrings.EVERYDAYBUY_TEXT11)
		return
	end
	if tonumber(count) >= tonumber(self.m_nMaxCount) then
		return
	end
	--存在0.5秒的时间冻结，主要是不给连续点击按钮的
	self.m_sBuyResultTicker = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
        if self.m_sBuyResultTicker then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sBuyResultTicker)
			self.m_sBuyResultTicker = nil
		end 
    end, 1, false)
    if change_id then
		local data = GDatatab_recharge["id_" .. change_id]
		--必带。id：产品id，price:价格；productName:商品名称；payCode:商品号
		if data then
			local tab = {}
			tab.id = data.id
			tab.price = data.price
			tab.number = 1
			tab.productName = data.name
			tab.payCode = GetPayCodeIdByChannelId(data)
			PassportSdkManager:getOrderNum(tab)
		end
	end
end
function CellGrowupHave:onBtnClickRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.OPTIMIZE_TEXT27)
end
--先加，后面统一处理方便
function CellGrowupHave:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
