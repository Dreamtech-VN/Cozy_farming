--WndHVFlowerOrderData.lua
--@brief	WndHVFlowerOrder的数据模块
--@date		2023/01/03
--@author	XTX
--@note		鲜花订单界面

WndHVFlowerOrder = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHVFlowerOrder:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tOrderList = nil 
	self.m_nPeriods = 1 				--期数
	self.m_nEndTimes = nil 				--结束时间戳
	self.m_tSelOrder = nil 				--选中的订单
	self.m_tCellSel = nil 				--选中的订单
	self.m_tLeftCell = nil 				--左侧订单列表Cell
	self.m_nLeftWorshipTimes = 0 		--剩余膜拜次数
	self.m_bIsFirstTimeEnd = true 		--是否首次结束
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHVFlowerOrder:_unInit()
	self.m_root = nil
	self.m_tOrderList = nil 
	self.m_nPeriods = nil				--期数
	self.m_nEndTimes = nil 
	self.m_tSelOrder = nil 
	self.m_tCellSel = nil 				--选中的订单
	self.m_tLeftCell = nil 
	self.m_nLeftWorshipTimes = nil 		--剩余膜拜次数
	self.m_bIsFirstTimeEnd = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHVFlowerOrder:createElement()
	if WndHVFlowerOrder.m_root ~= nil then
		WindowManager:removeWindow(WndHVFlowerOrder.m_root, WndHVFlowerOrder, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHVFlowerOrder")
	assert(element, "WndHVFlowerOrder create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndHVFlowerOrder:showInterface()
	local wndWater = WndHVFlowerOrder:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndHVFlowerOrder, false, nil, nil, true)
	end
end


--@brief 	获取鲜花订单
function WndHVFlowerOrder:setFlowerOrderList(synType, orderIds, processes, seedNums, status, season, endTime, leftWorshipTimes, opType)
	if self.m_root == nil then return end 
	WZLog("WndHVFlowerOrder:setFlowerOrderList", synType, Serialize(orderIds), Serialize(processes), Serialize(status), Serialize(seedNums), season, endTime, SystemTime:getServerTime(), leftWorshipTimes, opType)
	self.m_nLeftWorshipTimes = leftWorshipTimes
	if synType == 0 then 
		self.m_nPeriods = season 				--期数
		self.m_nEndTimes = endTime 				--结束时间戳
		self.m_tOrderList = {}
		
		for i = 1, #orderIds do
			local tItem = {}

			tItem.orderId = orderIds[i]
			tItem.progress = processes[i]
			tItem.seedNum = seedNums[i]
			tItem.status = status[i]
			local basicInfo = GDatatab_holiday_order["id_" .. tItem.orderId]
			if basicInfo and basicInfo.season == season then 
				tItem.basicInfo = CopyTable(basicInfo)
				table.insert(tItem.basicInfo.reward, {160401, basicInfo.harvest})
			end

			table.insert(self.m_tOrderList, tItem)
		end

		local function sortOrder(a, b)
			local statueA = a.status < 3 and 1 or a.status
			local statueB = b.status < 3 and 1 or b.status
			if statueA ~= statueB then
				return statueA < statueB
			else
				if a.basicInfo.daily ~= b.basicInfo.daily then
					return a.basicInfo.daily > b.basicInfo.daily
				else
					return a.orderId < b.orderId 
				end
			end
		end
		table.sort(self.m_tOrderList, sortOrder)

		self:_update()
		if opType == 1 then 
			GetElement(self.m_root, "conSecondAsk_WndHVFlowerOrder", WZUIContainer):setVisible(false)
			self:_setBlackBkVisible(true)
		end
	else
		for i = 1, #orderIds do
			for j = 1, #self.m_tOrderList do
				if self.m_tOrderList[j].orderId == orderIds[i] then 
					self.m_tOrderList[j].progress = processes[i]
					self.m_tOrderList[j].seedNum = seedNums[i]
					self.m_tOrderList[j].status = status[i]
					self.m_tLeftCell[j]:resetData(self.m_tOrderList[j])
					if self.m_tOrderList[j].orderId == self.m_tSelOrder.orderId then 
						self.m_tSelOrder = self.m_tOrderList[j]
						self:_showProgressAndStatus()
					end
					break 
				end
			end
		end

		local bIsReddot = false 
		local bHaveNoAcceptOrder = false 
		for i = 1, #self.m_tOrderList do
			if self.m_tOrderList[i].status == 2 and not bIsReddot then 
				bIsReddot = true 
			elseif self.m_tOrderList[i].status == 0 and not bHaveNoAcceptOrder then 
				bHaveNoAcceptOrder = true 
			end
		end
		WndHVOperate:_setFlowerOrderBtnVisible(nil, bIsReddot)
		if opType == 1 then 
			GetElement(self.m_root, "conSecondAsk_WndHVFlowerOrder", WZUIContainer):setVisible(false)
			self:_setBlackBkVisible(true)
		elseif opType == 2 then 
			self:showOpenAction()
		end

		if not bHaveNoAcceptOrder then 
			GetElement(self.m_root, "btnOneKeyOp_WndHVFlowerOrder", WZUIButton):setTouchEnable(false)
		end
	end
end

--@brief 	获取剩余膜拜次数
function WndHVFlowerOrder:getLeftWorshipTimes()
	return self.m_nLeftWorshipTimes
end

--@brief 	设置剩余膜拜次数
function WndHVFlowerOrder:setLeftWorshipTimes(nTimes)
	self.m_nLeftWorshipTimes = nTimes
end

--@brief 	获取期数
function WndHVFlowerOrder:getPeriods()
	return self.m_nPeriods
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
CellOrderItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellOrderItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_bIsLoaded = false
	self.m_bChoose = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellOrderItem:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil 
	self.m_bChoose = nil 
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellOrderItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellOrderItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellOrderItem")
	element:setAbsContentSize(GlobalMethod:CCSize(202,120))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	 设置数据
function CellOrderItem:setData(tData)
	-- body
	self.m_tData = tData
end

--@brief 	 设置数据
function CellOrderItem:resetData(tData)
	-- body
	self.m_tData = tData
	if self.m_bIsLoaded then
		self:_update()
	end
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellOrderItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellOrderItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellOrderItem:onExit(element)
	self:_unInit()
end

--@brief 加载
function CellOrderItem:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellOrderItem")
	celElement:setVisible(true)
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true 
    self:_update()
end

--@brief 	点击下拉按钮回调
function CellOrderItem:onClickOrder(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndHVFlowerOrder:onOrderCallBack(self.m_tData, self)
end

--@brief    刷新
function CellOrderItem:_update()
	WZLog("CellOrderItem:_update")
	--body
	local imgBk = GetElement(self.m_root, "imgBk_CellOrderItem", WZUIImage)
	if imgBk then 
		if self.m_tData.status <= 0 then 
			imgBk:setFile("ui/holidayVillage/otherImg/frame_xhdd_01.png")
		else
			imgBk:setFile("ui/holidayVillage/otherImg/frame_xhdd_02.png")
		end
	end
	local imgFlowerIcon = GetElement(self.m_root, "imgFlowerIcon_CellOrderItem", WZUIImage)
	local seedData = GDatatab_holiday_seed["id_" .. self.m_tData.basicInfo.plant_id]
	local basicData = GDatatab_item["id_" .. seedData.item_id]
	if imgFlowerIcon then 
		imgFlowerIcon:setFile(basicData.icon)
	end
	local txtOrderState = GetElement(self.m_root, "txtOrderState_CellOrderItem", WZUILabelTTF)
	
	local imgRedDot = GetElement(self.m_root, "imgRedDot_CellOrderItem", WZUIImage)
	if self.m_tData.status <= 0 then 
		txtOrderState:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[5])
	elseif self.m_tData.status == 3 then 
		txtOrderState:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[16])
	else
		txtOrderState:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[6])
	end
	if imgRedDot then 
		if self.m_tData.status == 2 then 
			imgRedDot:setVisible(true)
		else
			imgRedDot:setVisible(false)
		end
	end

	self:setSelState(self.m_bChoose)

	--每日和长期页签
	local imgTaskTab = GetElement(self.m_root, "imgTaskTab_CellOrderItem", WZUIImage)
	local txtTaskTab = GetElement(self.m_root, "txtTaskTab_CellOrderItem", WZUILabelTTF)
	if self.m_tData.basicInfo.daily == 0 then
		imgTaskTab:setFile("ui/common/common_bq_cq.png")
		txtTaskTab:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[20])
	elseif self.m_tData.basicInfo.daily == 1 then
		imgTaskTab:setFile("ui/common/common_bq_mr.png")
		txtTaskTab:setText(LocalStrings.EVERYDAY)
	end

end

function CellOrderItem:setSelState(bVisible)
	self.m_bChoose = bVisible
	if not self.m_bIsLoaded then
       return
    end
    GetElement(self.m_root, "conSel_CellOrderItem", WZUIContainer):setVisible(bVisible)
end