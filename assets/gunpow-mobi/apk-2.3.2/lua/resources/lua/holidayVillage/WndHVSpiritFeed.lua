--WndHVSpiritFeed.lua
--@brief	WndHVSpiritFeed的UI模块
--@date		2023/01/04
--@author	yrd
--@note		度假村-精灵喂养


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVSpiritFeed:onEnter(element)
	self.m_root = element

	self:_initStaticText()
	self:getFoodList()
	self:_updateUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVSpiritFeed:onExit(element)
	self:_unInit()
end

--@brief	关闭
function WndHVSpiritFeed:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	初始化静态文本
function WndHVSpiritFeed:_initStaticText()
	GetElement(self.m_root,"txtTitle_WndHVSpiritFeed",WZUILabelTTF):setText(LocalStrings.KID_TEXT4)
	GetElement(self.m_root,"txtFeed1_WndHVSpiritFeed",WZUILabelTTF):setText(LocalStrings.DIGGEM_TEXT46)
	GetElement(self.m_root,"txtFeed2_WndHVSpiritFeed",WZUILabelTTF):setText(LocalStrings.DIGGEM_TEXT46)
	GetElement(self.m_root,"txtFeed3_WndHVSpiritFeed",WZUILabelTTF):setText(LocalStrings.DIGGEM_TEXT46)
end

function WndHVSpiritFeed:_updateUI()
	self:setGrowValue()
	self:_createFoodsList()
	self:setAddValue()
	self:showCanUseMaxNum()
end

--@brief 	创建食物列表
function WndHVSpiritFeed:_createFoodsList()
	-- body
	local tbForFood = GetElement(self.m_root, "tbForFood_WndHVSpiritFeed", WZUITableContainer)
	local conForLimitFood = GetElement(self.m_root, "conForLimitFood_WndHVSpiritFeed", WZUIContainer)
	tbForFood:cleanTable()

	if #self.m_tFoodsList > 3 then
		tbForFood:setVisible(true)
		conForLimitFood:setVisible(false)
		for i = 1, #self.m_tFoodsList do
			local element, tNewObj = CellGoodItem:createElement()
			if element and tNewObj then
				element:setTag(i - 1)
				local number = WndHVSpirit:getItemCountByItemId(self.m_tFoodsList[i].id)
				tNewObj:setCellGoodLocalId(self.m_tFoodsList[i].id, number, 4, true)
				tNewObj:setItemClickFun(self, self.chooseFood)
				if self.m_tData == nil then
					self.m_tData = {}
					self.m_tData.basicInfo = self.m_tFoodsList[i]
					tNewObj:setItemSelState(true, "ui/common/common_scale9_beibaodi_sel.png")
					self.m_tClickCell = tNewObj
				elseif self.m_tData and self.m_tData.basicInfo.id == self.m_tFoodsList[i].id then
					tNewObj:setItemSelState(true, "ui/common/common_scale9_beibaodi_sel.png")
					self.m_tClickCell = tNewObj
				end
				tNewObj:setItemCount(number)
				tNewObj:_setItemVisible(true)
				tbForFood:setCellElement(element)
			end
		end
	else
		tbForFood:setVisible(false)
		conForLimitFood:setVisible(true)

		for i = 1, #self.m_tFoodsList do
			local element, tNewObj = CellGoodItem:createElement()
			local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndHVSpiritFeed", WZUIContainer)
			conItem:setVisible(true)
			conItem:removeAllChildrenWithCleanup(true)
			if element and tNewObj then
				local number = WndHVSpirit:getItemCountByItemId(self.m_tFoodsList[i].id)
				tNewObj:setCellGoodLocalId(self.m_tFoodsList[i].id, number, 4, true)
				tNewObj:setItemClickFun(self, self.chooseFood)
				if self.m_tData == nil then
					self.m_tData = {}
					self.m_tData.basicInfo = self.m_tFoodsList[i]
					tNewObj:setItemSelState(true, "ui/common/common_scale9_beibaodi_sel.png")
					self.m_tClickCell = tNewObj
				elseif self.m_tData and self.m_tData.basicInfo.id == self.m_tFoodsList[i].id then
					tNewObj:setItemSelState(true, "ui/common/common_scale9_beibaodi_sel.png")
					self.m_tClickCell = tNewObj
				end
				tNewObj:setItemCount(number)
				tNewObj:_setItemVisible(true)
				conItem:addChild(element)
			end
		end

		if #self.m_tFoodsList == 1 then
			GetElement(self.m_root, "conItem1_WndHVSpiritFeed", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		elseif #self.m_tFoodsList == 2 then
			GetElement(self.m_root, "conItem1_WndHVSpiritFeed", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.35,0.5))
			GetElement(self.m_root, "conItem2_WndHVSpiritFeed", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.65,0.5))
		end
	end
end

--@brief 	设置可以增长的愉悦值
function WndHVSpiritFeed:setAddValue()
	local txtFoodDesc = GetElement(self.m_root, "txtFoodDesc_WndHVSpiritFeed", WZUILabelTTF)
	if txtFoodDesc then
		if self.m_nNum and self.m_nNum > 0 then
			local nValue = self.m_tData.basicInfo.value * self.m_nNum
			txtFoodDesc:setText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT4[7], self.m_tData.basicInfo.name, nValue))
		else
			txtFoodDesc:setText("")
		end
	end
end

--@brief 	选中某一食物
function WndHVSpiritFeed:chooseFood(tCell, tag, tData)
	-- body
	if self.m_tData and self.m_tData.basicInfo.id == tData.basicInfo.id then return end 
	WZLog("WndHVSpiritFeed:chooseFood")
	if self.m_tClickCell then
		self.m_tClickCell:setItemSelState(false)
	end
	self.m_tData = tData
	self.m_tClickCell = tCell
	self.m_tClickCell:setItemSelState(true, "ui/common/common_scale9_beibaodi_sel.png")

	--切换食物，重置数量
	self.m_nNum = 1
	GetElement(self.m_root,"useNum_WndHVSpiritFeed",WZUILabelTTF):setText(self.m_nNum)
	self:setAddValue()

	self:showCanUseMaxNum()
end

--@brief 	显示可使用最大数量
function WndHVSpiritFeed:showCanUseMaxNum()
	local nCanUseMaxNum = self:getCanUseMaxNum()
	GetElement(self.m_root,"txtExplanation_WndHVSpiritFeed",WZUILabelTTF):setText(string.format(LocalStrings.EXCHANGE2, nCanUseMaxNum))
end

--@brief	点击喂食按钮回调
function WndHVSpiritFeed:onClickConfirm(element)
	WZLog("WndHVSpiritFeed:onClickConfirm")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT5)
		return
	end

	if self.m_tTargetData.satiety >= self.m_nMaxGrowValue then
		MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[25])
		return 
	end

	local tData = self.m_tData
	local level = CacheCenter:getPlayerInfo().level
	--判断是否达到等级
	if tonumber(level) < tonumber(tData.basicInfo.use_level) then
		MsgBoxManager:showTipBox(LocalStrings.OPENGIFTLEVEL)
		return
	end
	local nOwnNum = WndHVSpirit:getItemCountByItemId(self.m_tData.basicInfo.id)
	if nOwnNum == 0 then
		--购买界面，快速购买
		checkIsOnSale(self.m_tData.basicInfo.id)
		return 
	end

	self.m_tCallBack[2](self.m_tCallBack[1],self.m_tTargetData,self.m_tData,self.m_nNum)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	成长值
function WndHVSpiritFeed:setGrowValue()
	local ftxtGrowValue = GetElement(self.m_root, "ftxtGrowValue_WndHVSpiritFeed", WZUIFreeTextBox)
	ftxtGrowValue:setShowText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT5, self.m_tTargetData.satiety, self.m_nMaxGrowValue))
end

--@brief	减少10个
function WndHVSpiritFeed:onMutiReduce(element)
	WZLog("WndHVSpiritFeed:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum > 10 then
		self.m_nNum = self.m_nNum - 10
	else
		self.m_nNum = 1
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndHVSpiritFeed",WZUILabelTTF):setText(self.m_nNum)
	self:setAddValue()
end

--@brief	减少1个
function WndHVSpiritFeed:onReduce(element)
	WZLog("WndHVSpiritFeed:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndHVSpiritFeed",WZUILabelTTF):setText(self.m_nNum)
	self:setAddValue()
end

--@brief	增加10个
function WndHVSpiritFeed:onMutiAdd(element)
	WZLog("WndHVSpiritFeed:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = self.m_tData
	local number = WndHVSpirit:getItemCountByItemId(self.m_tData.basicInfo.id)
	self.m_nMaxNum = math.min(100, number)
	if self.m_nNum < self.m_nMaxNum - 10 then
		local bCanAdd = self:getGrowValueAfterUse()
		if bCanAdd then
			local nLeftNum = self:getExdAddNum()
			if nLeftNum >= 10 then
				self.m_nNum = self.m_nNum + 10
			else
				self.m_nNum = self.m_nNum + nLeftNum
			end
		else
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[26])
			return 
		end
	else
		local bCanAdd = self:getGrowValueAfterUse()
		if bCanAdd then
			local nLeftNum = self:getExdAddNum()
			if nLeftNum >= self.m_nMaxNum - self.m_nNum then
				self.m_nNum = self.m_nMaxNum
				MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
			else
				self.m_nNum = self.m_nNum + nLeftNum
			end
		else
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[26])
			return 
		end
	end
	if self.m_nNum == 0 then self.m_nNum = 1 end
	GetElement(self.m_root,"useNum_WndHVSpiritFeed",WZUILabelTTF):setText(self.m_nNum)
	self:setAddValue()
end

--@brief	增加1个
function WndHVSpiritFeed:onAdd(element)
	WZLog("WndHVSpiritFeed:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--使用加体力物品，要判断是否达到上限
	local tData = self.m_tData
	local number = WndHVSpirit:getItemCountByItemId(self.m_tData.basicInfo.id)
	self.m_nMaxNum = math.min(100, number)
	if self.m_nNum + 1 <= self.m_nMaxNum then
		local bCanAdd = self:getGrowValueAfterUse()
		if bCanAdd then
			self.m_nNum = self.m_nNum + 1
		else
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[26])
		end
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	if self.m_nNum == 0 then self.m_nNum = 1 end
	GetElement(self.m_root,"useNum_WndHVSpiritFeed",WZUILabelTTF):setText(self.m_nNum)
	self:setAddValue()
end



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
