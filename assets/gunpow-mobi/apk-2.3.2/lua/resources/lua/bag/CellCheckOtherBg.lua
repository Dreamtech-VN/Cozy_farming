--CellCheckOtherBg.lua
--@brief	CellCheckOtherBg的UI模块
--@date		2018/05/02
--@author	Tianxiang_Xu
--@note		玩家信息中的背景cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOtherBg:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOtherBg:onExit(element)
	self:_unInit()
end

--@brief 	点击回调
function CellCheckOtherBg:onClickCell(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nType == 0 then 
		WndCheckOther:clickBgCellCallBack(element, self, self.m_tData)
	elseif self.m_nType == 1 then 
		WndChallengeLevel:clickBgCellCallBack(element, self, self.m_tData)
	end
end

--@brief 	加载
function CellCheckOtherBg:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellCheckOtherBg")
	self.m_root:addChild(celElement)

	self.m_bIsLoaded = true
	self:_update()
	AdaptLanguage(self)
end

--@brief 	设置选中状态
function CellCheckOtherBg:setSelState(bVisible)
	-- body
	self.m_bIsSel = bVisible 
	if not self.m_bIsLoaded then return end 

	local conSel = GetElement(self.m_root, "conSel_CellCheckOtherBg", WZUIContainer)
	if conSel then
		conSel:setVisible(bVisible)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	
function CellCheckOtherBg:_update()
	-- body
	local imgBg = GetElement(self.m_root, "imgBg_CellCheckOtherBg", WZUIImage)
	if imgBg then
		imgBg:setFile(self.m_tData.icon)
	end
	local ftxtPrice = GetElement(self.m_root, "ftxtPrice_CellCheckOtherBg", WZUIFreeTextBox)
	local state = -1 
	local nTempItemId = self.m_tData.id
	local nNum = 0
	if self.m_nType == 0 then   --资料卡背景
		nNum = CacheCenter:getPlayerItemCountById(nTempItemId)
	elseif self.m_nType == 1 then  --
		if nTempItemId == 0 then 
			state = 0
		else
			nNum = CacheCenter:getPlayerItemCountById(nTempItemId)
		end
	end
	if nNum > 0 then
		state = 0 
	end

	if (self.m_nType == 0 and nTempItemId == 830) or (self.m_nType == 1 and nTempItemId == 0) then
		GetElement(self.m_root, "txtDefault_CellCheckOtherBg", WZUILabelTTF):setVisible(true)
		state = 0 
	else
		GetElement(self.m_root, "txtDefault_CellCheckOtherBg", WZUILabelTTF):setVisible(false)
	end

	local nTempUsingId = CacheCenter:getPlayerInfo().background
	if self.m_nType == 1 then 
		nTempUsingId = WndChallengeLevel:getUsingSkinId()
	end
	if nTempUsingId and nTempUsingId == nTempItemId then
		state = 1
	end

	if ftxtPrice then
		if state == -1 then
			local sFormat = [[<I Z="0.5">%s</I><T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
			if self.m_tData.property[1][1] == -1 then 
				sFormat = [[<T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
				local contentTemp = string.format(LocalStrings.BACKGROUND_ONLYFOR_VIP, self.m_tData.property[1][2])
				ftxtPrice:setVisible(true)
				ftxtPrice:setShowText(string.format(sFormat, contentTemp))
			elseif self.m_tData.property[1][1] == -2 then 
				sFormat = [[<T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
				local contentTemp = string.format(LocalStrings.BACKGROUND_MEDAL2, self.m_tData.property[1][2])
				ftxtPrice:setVisible(true)
				ftxtPrice:setShowText(string.format(sFormat, contentTemp))
			elseif self.m_tData.property[1][1] == -3 then 
				sFormat = [[<T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
				ftxtPrice:setVisible(true)
				ftxtPrice:setShowText(string.format(sFormat, LocalStrings.BACKGROUND_MEDAL4[self.m_tData.property[1][2]]))
			elseif self.m_tData.property[1][1] == 0 and nTempItemId ~= 830 then 
				sFormat = [[<T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
				ftxtPrice:setVisible(true)
				ftxtPrice:setShowText(string.format(sFormat, LocalStrings.BACKGROUND_VIP_TEXT3))
			else
				local tCostData = GDatatab_item["id_" .. self.m_tData.property[1][1]] 
				ftxtPrice:setVisible(true)
				WZLog("CellCheckOtherBg:_update", self.m_tData.property[1][1])
				if tCostData then
					ftxtPrice:setShowText(string.format(sFormat, tCostData.icon, self.m_tData.property[1][2]))
				end
			end
		elseif state == 0 then
			local sFormat 
			if self.m_tData.property and self.m_tData.property[1][1] == -1 then 
				sFormat = [[<T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
				local contentTemp = string.format(LocalStrings.BACKGROUND_ONLYFOR_VIP, self.m_tData.property[1][2])
				ftxtPrice:setVisible(true)
				ftxtPrice:setShowText(string.format(sFormat, contentTemp))
			elseif self.m_tData.property and self.m_tData.property[1][1] == -2 then 
				sFormat = [[<T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
				local contentTemp = string.format(LocalStrings.BACKGROUND_MEDAL2, self.m_tData.property[1][2])
				ftxtPrice:setVisible(true)
				ftxtPrice:setShowText(string.format(sFormat, contentTemp))
			elseif self.m_tData.property and self.m_tData.property[1][1] == -3 then 
				sFormat = [[<T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
				ftxtPrice:setVisible(true)
				ftxtPrice:setShowText(string.format(sFormat, LocalStrings.BACKGROUND_MEDAL4[self.m_tData.property[1][2]]))
			elseif self.m_tData.property and self.m_tData.property[1][1] == 0 and nTempItemId ~= 830 then 
				sFormat = [[<T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
				ftxtPrice:setVisible(true)
				ftxtPrice:setShowText(string.format(sFormat, LocalStrings.BACKGROUND_VIP_TEXT3))
			else
				ftxtPrice:setVisible(false)
				sFormat = [[<T C="255,227,116" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
				ftxtPrice:setShowText(string.format(sFormat, LocalStrings.IN_USE))
			end
		else
			ftxtPrice:setVisible(true)
			local sFormat = [[<T C="255,227,116" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
			ftxtPrice:setShowText(string.format(sFormat, LocalStrings.IN_USE))
		end
	end

	-- 背景卡打折倒计时
	local itemDiscount = json.decode(CacheCenter:getGameParam()["itemDiscount"])
	local ftxtDiscount = GetElement(self.m_root, "ftxtDiscount_CellCheckOtherBg", WZUIFreeTextBox)
	local imgDiscount = GetElement(self.m_root, "imgDiscount_CellCheckOtherBg", WZUIImage)
	imgDiscount:setVisible(false)
	ftxtDiscount:setShowText("")
	if self.m_nType == 1 then 
		itemDiscount = nil 
	end
	if itemDiscount then 
		local strEndTime = itemDiscount.endDate .. " 23:59:59"
		local pattern = "(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)"
		local xyear,xmonth,xday,xhour,xminute,xseconds = strEndTime:match(pattern)
		local nEndTimestamp = os.time({year = xyear,month = xmonth,day = xday,hour = xhour,min = xminute,sec = xseconds})
		local nServerTime = SystemTime:getServerTime()

		local ids, nums = SplitItemString(itemDiscount.reward)
		for i=1,#ids do
			if tonumber(ids[i]) == nTempItemId and state == -1 and nServerTime <= nEndTimestamp then
				local sFormat = [[<I Z="0.5">%s</I><T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
				local tCostData = GDatatab_item["id_" .. self.m_tData.property[1][1]]
				if tCostData then
					local price = math.ceil(self.m_tData.property[1][2]*tonumber(nums[i])/100)
					ftxtDiscount:setShowText(string.format(sFormat, tCostData.icon, price))
					imgDiscount:setVisible(true)
				end
			end
		end
	end

	self:setSelState(self.m_bIsSel)
end

function CellCheckOtherBg:setUseingVisible(bVisible)
	-- body
	local ftxtPrice = GetElement(self.m_root, "ftxtPrice_CellCheckOtherBg", WZUIFreeTextBox)
	if ftxtPrice then
		ftxtPrice:setVisible(bVisible)
	end

	self:_update()
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function CellCheckOtherBg:_adaptLanguage_vn()
	local ftxtPrice = GetElement(self.m_root, "ftxtPrice_CellCheckOtherBg", WZUIFreeTextBox)
	ftxtPrice:setMaxWidth(200)
	ftxtPrice:setScale(0.8)
end
-------------------------------------语言适配end----------------------------------------
