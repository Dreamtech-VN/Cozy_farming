--CellPastureWorker.lua
--@brief	CellPastureWorker的UI模块
--@date		2021/05/14
--@author	hyx
--@note		牧场工坊


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPastureWorker:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPastureWorker:onExit(element)
	if self.m_sMakeScheduleId then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sMakeScheduleId)
		self.m_sMakeScheduleId = nil
	end
	self:unregister()
	self:_unInit()
end
function CellPastureWorker:register()
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_WorkShopBagInfo,self._onGetWorkShopBagInfo,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_WorkShopInfo,self._onGetWorkShopBaseInfo,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_WorkShopMakeSureId,self._onGetWorkShopMakeIdResult,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_WorkShopMakeingSureId,self._onGetWorkShopMakeingResult,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_UnlockWorkShopPosition,self._onGetUnlockPosResult,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_ComposeAccelerate,self._onGetComposeAccResult,self)

end
function CellPastureWorker:unregister()
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_WorkShopBagInfo,self._onGetWorkShopBagInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_WorkShopInfo,self._onGetWorkShopBaseInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_WorkShopMakeSureId,self._onGetWorkShopMakeIdResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_WorkShopMakeingSureId,self._onGetWorkShopMakeingResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_UnlockWorkShopPosition,self._onGetUnlockPosResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_ComposeAccelerate,self._onGetComposeAccResult,self)
end
function CellPastureWorker:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function CellPastureWorker:actionCallback()
	self:initShow()
	ProtocolProcessorFamily:send_MOUNTSPASTURE_GetPastureCraftingProps()
	ProtocolProcessorFamily:send_MOUNTSPASTURE_GetPastureCraftingTable()
end
function CellPastureWorker:initShow( )
	self.m_sBagTableContainer = GetElement(self.m_root,"bagTableContainer",WZUITableContainer)
	GetElement(self.m_root,"txtWorkerTitle",WZUILabelTTF):setText(LocalStrings.PASTURE_TEXT6[2])

	self:setWorkerBaseInfo( )
	local num = WndPastureBusiness:getWorkerNumber()
	self:setWorkerCreamNum(num)

	for i=1,4 do
		local businessItem = GetElement(self.m_root,"businessItem"..i,WZUIContainer)
		local tab = {}
		tab.txtFreeTime = GetElement(businessItem,"txtFreeTime",WZUIFreeTextBox)
		--物品
		tab.goods_con = GetElement(businessItem,"goods_con",WZUIContainer)
		local item, itemObj = WndPastureGoodsItem:createElement()
		tab.skillItemItem = item
		tab.skillItemObj = itemObj
		tab.goods_con:addChild(item)

		tab.img_lock = GetElement(businessItem,"img_lock",WZUIImage)
		tab.btnLock = GetElement(businessItem,"btnLock",WZUIButton)
		tab.txtFreeLockPrice = GetElement(businessItem,"txtFreeLockPrice",WZUIFreeTextBox)
		tab.btnMake = GetElement(businessItem,"btnMake",WZUIButton)
		tab.txtFreeMakePrice = GetElement(businessItem,"txtFreeMakePrice",WZUIFreeTextBox)
		tab.makeChangeNum = GetElement(businessItem,"makeChangeNum",WZUIContainer)
		tab.btnAdd = GetElement(businessItem,"btnAdd",WZUIButton)
		tab.btnMinus = GetElement(businessItem,"btnMinus",WZUIButton)
		tab.txtMakeNum = GetElement(businessItem,"txtMakeNum",WZUILabelTTF)
		tab.makeIngCon = GetElement(businessItem,"makeIngCon",WZUIContainer)
		tab.txtMakeTimeing = GetElement(businessItem,"txtMakeTimeing",WZUILabelTTF)
		self.m_tCellMakeItem[i] = tab
	end
end
function CellPastureWorker:setWorkerBaseInfo( )
	if not self.m_root then return end

	local left = GetElement(self.m_root,"left",WZUIContainer)
	local progress = GetElement(left,"workerLevProgress",WZUIProgress)
	local txtPasture = GetElement(left,"txtPastureProgress",WZUILabelTTF)
	local txtPastureLev = GetElement(left,"txtPastureLev",WZUILabelTTF)
	local txtPastureName = GetElement(left,"txtPastureName",WZUILabelTTF)
	
	local info = WndPastureBusiness:getBasePastureInfo()
	if info then
		txtPastureLev:setText("Lv."..info.level)
		txtPastureName:setText(info.name)
		local lev_info = WndPastureBusiness:getPastureLevelExp(info.level+1)
		if lev_info then
			txtPasture:setText(info.cur_exp.."/"..lev_info.exp)
			progress:setPercentage(info.cur_exp / lev_info.exp * 100)
		else --最大等级
			txtPasture:setText("Max")
			progress:setPercentage(100)
		end
	end
end
--设置牧场的精华
function CellPastureWorker:setWorkerCreamNum(num)
	if not self.m_root then return end

	local left = GetElement(self.m_root,"left",WZUIContainer)
	local txtWorkShopItemNum = GetElement(left,"txtWorkShopItemNum",WZUIFreeTextBox)
	local tabItem = GDatatab_item["id_99"]
	if tabItem then
		txtWorkShopItemNum:setShowText(string.format([[<I Z="0.5">%s</I><T C="127,70,26" S="20" P="1">%d</T>]],tabItem.icon, num))
	end
end
function CellPastureWorker:setWorkShopData()
	--工坊解锁价格
	local workshopprice = CacheCenter:getGameParam().Workshopprice
	local ids,nums = SplitItemString(workshopprice)
	local tabLock = {}
	for i = 1, #ids do
		local tItem = {}
		tItem[1] = tonumber(ids[i])
		tItem[2] = tonumber(nums[i])
		tabLock[i] = tItem
	end
	self.m_UnLockData = tabLock
	--工坊加速价格与加成
	local workshopquickprice = CacheCenter:getGameParam().Workshopquickprice
	local ids,nums1,nums2 = self:workSplitItemString(workshopquickprice)
	local tabMake = {}
	for i = 1, #ids do
		local tItem = {}
		tItem[1] = tonumber(ids[i])
		tItem[2] = tonumber(nums1[i])
		tItem[3] = tonumber(nums2[i])
		tabMake[i] = tItem
	end
	self.m_tMakePriceData = tabMake
	-- status，0、未开启 1、已解锁,2、正在合成,3、合成完毕
	for i=1,4 do
		local data = self.m_tMakeWorkShopData[i]
		self.m_tCellMakeItem[i].img_lock:setVisible(data.status == 0)
		self.m_tCellMakeItem[i].btnLock:setVisible(data.status == 0)
		if data.skill ~= 0 then
			self.m_tCellMakeItem[i].btnMake:setVisible(data.status == 1)
		end

		self.m_tCellMakeItem[i].makeIngCon:setVisible(data.status == 2)
		self.m_tCellMakeItem[i].skillItemObj:setData(data.skill, 1, false, data.status == 1)

		self.m_tMakeScheduleTime[i] = data.endTime or 0
		--加速时间
		local accTime_str = [[<I Z="0.5">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SE="1" SS="4">%d</T>]]
		if data.status == 0 then
			local info = GDatatab_item["id_"..tabLock[i][1]]
			local str = [[<T C="255,255,255" S="20" P="1" SC="132,66,29" SE="1" SS="4">%d</T><I Z="0.5">%s</I>]]
			self.m_tCellMakeItem[i].txtFreeLockPrice:setShowText(string.format(str,tabLock[i][2],info.icon))

			local info = GDatatab_item["id_"..tabMake[i][1]]
			self.m_tCellMakeItem[i].txtFreeTime:setShowText(string.format(accTime_str,info.icon,tabMake[i][2]))
		elseif data.status == 1 then
			--如果存在加速的情况
			if data.sandglassCD > 0 then
				self.m_tAccScheduleTime[i] = data.sandglassCD
				local str = [[<T C="127,70,26" S="18" P="1">%s</T>]]
				self.m_tCellMakeItem[i].txtFreeTime:setShowText(string.format(str,SystemTime:getTimeConverLocal2(self.m_tAccScheduleTime[i])))
			else
				local info = GDatatab_item["id_"..tabMake[i][1]]
				self.m_tCellMakeItem[i].txtFreeTime:setShowText(string.format(accTime_str,info.icon,tabMake[i][2]))
			end
			local function func(tableid)
				WndPastureMake:showInterface(tableid)
			end
			self.m_tCellMakeItem[i].skillItemObj:setCallFunc(func)
			self.m_tCellMakeItem[i].skillItemItem:setTag(i)
		elseif data.status == 2 then
			if data.sandglassCD > 0 then
				self.m_tAccScheduleTime[i] = data.sandglassCD
				local str = [[<T C="127,70,26" S="18" P="1">%s</T>]]
				self.m_tCellMakeItem[i].txtFreeTime:setShowText(string.format(str,SystemTime:getTimeConverLocal2(self.m_tAccScheduleTime[i])))
			else
				local info = GDatatab_item["id_"..tabMake[i][1]]
				self.m_tCellMakeItem[i].txtFreeTime:setShowText(string.format(accTime_str,info.icon,tabMake[i][2]))
			end
			self.m_tCellMakeItem[i].txtMakeTimeing:setText(SystemTime:getTimeConverLocal2(data.endTime))
			self.m_tCellMakeItem[i].btnAdd:setVisible(false)
			self.m_tCellMakeItem[i].btnMinus:setVisible(false)
		elseif data.status == 3 then

		end
		if data.make_num > 0 then --制作的数量
			self.m_tCellMakeItem[i].makeChangeNum:setVisible(true)
			self.m_tCellMakeItem[i].txtMakeNum:setText(data.make_num)
		end
	end
	if not self.m_sMakeScheduleId then
		self.m_sMakeScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
			if self.m_sMakeScheduleId then
				self:setMakeShowTime()
				self:setAccShowTime()
			end
	    end, 1, false)
	end
end
--@brief	拆分物品字符串
--@return	id数组和num数组
function CellPastureWorker:workSplitItemString(s)
	if s == nil then
		return
	end
	local array = SplitStringWithSeparator(s,"&")
	local ids = {}
	local prices1 = {}
	local prices2 = {}
	for i=1,#array do
		local _string = string.sub(array[i],2,-2) 
		local id = SplitStringWithSeparator(_string,",")[1]
		local num1 = SplitStringWithSeparator(_string,",")[2]
		local num2 = SplitStringWithSeparator(_string,",")[3]
		table.insert(ids,id)
		table.insert(prices1,num1)
		table.insert(prices2,num2)
	end
	return ids, prices1, prices2
end
--时间加速
function CellPastureWorker:onBtnAccTime(element)
	local tag = element:getTag()
	if self.m_tCellMakeItem[tag] and not self.m_tCellMakeItem[tag].skillItemObj:getData() then
		MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT23)
		return
	end
	local function func()
		if self.m_tMakeWorkShopData[tag] then
			ProtocolProcessorFamily:send_MOUNTSPASTURE_PastureFactorySpeedup(self.m_tMakeWorkShopData[tag].id, tag)
		end
	end
	local str = string.format(LocalStrings.PASTURE_TEXT29, self.m_tMakePriceData[tag][2], self.m_tMakePriceData[tag][3])
	MsgBoxManager:showConfirmBox(str, self, func)
end
--解锁
function CellPastureWorker:onBtnLock(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if CacheCenter:getPlayerItemCountById(self.m_UnLockData[tag][1]) < self.m_UnLockData[tag][2] then
		local function clickSureMoney()
			if self.m_tMakeWorkShopData[tag] then
				ProtocolProcessorFamily:send_MOUNTSPASTURE_UnlockPastureCraftingTable(self.m_tMakeWorkShopData[tag].id)
			end
		end
		if not JudgeMoneyIsEnough(self.m_UnLockData[tag][1], tonumber(self.m_UnLockData[tag][2]), nil, nil, nil, nil, nil, nil, nil, self, clickSureMoney) then
	        return 
	    end
	else
		local function func()
			if self.m_tMakeWorkShopData[tag] then
				ProtocolProcessorFamily:send_MOUNTSPASTURE_UnlockPastureCraftingTable(self.m_tMakeWorkShopData[tag].id)
			end
		end
		MsgBoxManager:showConfirmBox(LocalStrings.PASTURE_TEXT28, self, func)
	end
end
--制作
function CellPastureWorker:onBtnMake(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_bIsMake then
		MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT23)
		return
	end
	local tag = element:getTag()
	local totle_num = WndPastureBusiness:getWorkerNumber()
	if self.m_tConsumeDaimand[tag].price*tonumber(self.m_nMakeNumber[tag]) > totle_num then
		WndFastGetItems:show(99, self.m_tConsumeDaimand[tag].price*tonumber(self.m_nMakeNumber[tag]))
	else
		if self.m_tChooseMakeItemData[tag] then
			ProtocolProcessorFamily:send_MOUNTSPASTURE_PastureFactoryCraft(self.m_tChooseMakeItemData[tag].id, tag, self.m_nMakeNumber[tag])
		end
	end
end

function CellPastureWorker:onBtnAdd(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	--计算总数
	local tager_data = self.m_tChooseMakeItemData[tag]
	if not tager_data then return end
	local tSkill = GDatatab_skill["id_"..tager_data.skillid]
	if tSkill then
		local total = tSkill.param3
		local cur_index = 0
		--背包的数量
	    if self.m_tMakeBagData[tager_data.skillid] then
	    	cur_index = self.m_tMakeBagData[tager_data.skillid].num
	    end
	    --目前选择的数量
	    local choose_num = 0
	    for i,v in pairs(self.m_tChooseMakeItemData) do
	    	if v.skillid == tager_data.skillid then
		    	choose_num = choose_num + self.m_nMakeNumber[i]
		    end
	    end
		if (cur_index+choose_num) >= total then
			MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT30)	
			return
		end

		self.m_nMakeNumber[tag] = self.m_nMakeNumber[tag] + 1
		self:setChooseMakeNum(tag)
	end
end
function CellPastureWorker:onBtnMinus(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	
	if self.m_nMakeNumber[tag] <= 1 then
		MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT26)
		return
	end
	self.m_nMakeNumber[tag] = self.m_nMakeNumber[tag] - 1
	self:setChooseMakeNum(tag)
end
function CellPastureWorker:setChooseMakeNum(index)
	if self.m_tCellMakeItem[index] then
		self.m_tCellMakeItem[index].txtMakeNum:setText(self.m_nMakeNumber[index])
		if self.m_tConsumeDaimand[index] then
			local info = GDatatab_item["id_"..self.m_tConsumeDaimand[index].consumeId]
			local str = [[<T C="255,255,255" S="20" P="1" SC="132,66,29" SE="1" SS="4">%d</T><I Z="0.5">%s</I>]]
			self.m_tCellMakeItem[index].txtFreeMakePrice:setShowText(string.format(str, self.m_tConsumeDaimand[index].price*tonumber(self.m_nMakeNumber[index]), info.icon))
		end
	end
end
--制作定时器
function CellPastureWorker:setMakeShowTime()
	for i=1,4 do
		if self.m_tMakeScheduleTime[i] and self.m_tCellMakeItem[i] then
			local bStatus, nTime = WndPastureBusiness:getCollectTime()
			if bStatus == true then
				self.m_tMakeScheduleTime[i] = self.m_tMakeScheduleTime[i] - nTime
			end
			if self.m_tMakeScheduleTime[i] >= 0 then
				self.m_tMakeScheduleTime[i] = self.m_tMakeScheduleTime[i] - 1
				if self.m_tMakeScheduleTime[i] <= 0 then
					self.m_tMakeScheduleTime[i] = -1
					self.m_tCellMakeItem[i].makeIngCon:setVisible(false)
					self.m_tCellMakeItem[i].makeChangeNum:setVisible(false)
					self.m_tCellMakeItem[i].skillItemObj:setData(0, 1, true, true)
					self.m_nMakeNumber[i] = 0
					local function func(tableid)
						WndPastureMake:showInterface(tableid)
					end
					self.m_tCellMakeItem[i].skillItemObj:setCallFunc(func)
					self.m_tCellMakeItem[i].skillItemItem:setTag(i)
				else
					if self.m_tCellMakeItem[i] then
						self.m_tCellMakeItem[i].txtMakeTimeing:setText(SystemTime:getTimeConverLocal2(self.m_tMakeScheduleTime[i]))
					end
				end
			end
		end
	end
end
--加速定时器
function CellPastureWorker:setAccShowTime()
	for i=1,4 do
		if self.m_tAccScheduleTime[i] and self.m_tAccScheduleTime[i] >= 0 and self.m_tCellMakeItem[i] then
			self.m_tAccScheduleTime[i] = self.m_tAccScheduleTime[i] - 1
			if self.m_tAccScheduleTime[i] <= 0 then
				self.m_tAccScheduleTime[i] = -1

				if self.m_tCellMakeItem[i] and self.m_tMakePriceData[i] then
					local accTime_str = [[<I Z="0.5">%s</I><T C="255,255,255" S="20" P="1" SC="132,66,29" SE="1" SS="4">%d</T>]]
					local info = GDatatab_item["id_"..self.m_tMakePriceData[i][1]]
					self.m_tCellMakeItem[i].txtFreeTime:setShowText(string.format(accTime_str,info.icon,self.m_tMakePriceData[i][2]))
				end
				if self.m_tMakeScheduleTime[i] then
					self.m_tMakeScheduleTime[i] = self.m_tMakeScheduleTime[i] / (1-(self.m_tMakePriceData[i][3]/100))
				end
			else
				if self.m_tCellMakeItem[i] then
					local str = [[<T C="127,70,26" S="18" P="1">%s</T>]]
					self.m_tCellMakeItem[i].txtFreeTime:setShowText(string.format(str,SystemTime:getTimeConverLocal2(self.m_tAccScheduleTime[i])))
				end
			end
		end
	end
end
function CellPastureWorker:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root then
		self.m_root:removeFromParentAndCleanup(true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--背包
-- isPart 是否部分道具变化,1、是，0、否
function CellPastureWorker:_onGetWorkShopBagInfo(skillid, num, isPart)
	if not self.m_sBagTableContainer then return end
	if isPart == 0 then
		self.m_sBagTableContainer:cleanTable()
		local bag_data = {}
	    for i=1, #skillid do
	    	local tab = {}
	    	tab.id = skillid[i]
	    	tab.num = num[i]
	    	tab.index = i
	    	self.m_tMakeBagData[tab.id] = tab
	    	bag_data[i] = tab
	    end
	    for i=1, #bag_data do
			local item, itemObj = WndPastureGoodsItem:createElement()
			self.m_tBagCellItemObj[i] = itemObj
			local info = GDatatab_skill["id_"..bag_data[i].id]
			if info then
				itemObj:setHasNum(bag_data[i].num.."/"..info.param3)	
			end
			itemObj:setData(bag_data[i].id, 0.8)
			item:setTag(i-1)
			self.m_nBagIndex = i-1
			self.m_sBagTableContainer:setCellElement(item)
			itemObj:setDefaultTip(true)
		end
	else
		--如果数量存在变化时候
		if skillid[1] then
			if self.m_tMakeBagData[skillid[1]] then
				self.m_tMakeBagData[skillid[1]].num = self.m_tMakeBagData[skillid[1]].num + num[1]
				local info = GDatatab_skill["id_"..skillid[1]]
				local index = 0
				for i,v in pairs(self.m_tMakeBagData) do
					if v.id == skillid[1] then
						index = v.index
						break
					end 
				end
				if info and self.m_tBagCellItemObj[index] then
					self.m_tBagCellItemObj[index]:setHasNum(self.m_tMakeBagData[skillid[1]].num.."/"..info.param3)	
				end
			else
				if next(self.m_tMakeBagData) == nil then
					self.m_nBagIndex = 0
				else
					self.m_nBagIndex = self.m_nBagIndex + 1
				end
				local cellElement,tCell = WndPastureGoodsItem:createElement()
				self.m_tBagCellItemObj[self.m_nBagIndex+1] = tCell
				local info = GDatatab_skill["id_"..skillid[1]]
				if info then
					tCell:setHasNum(num[1].."/"..info.param3)	
				end
				tCell:setData(skillid[1], 0.8)
				cellElement:setTag(self.m_nBagIndex)
				self.m_sBagTableContainer:setCellElement(cellElement)
				tCell:setDefaultTip(true)
				local tab = {}
		    	tab.id = skillid[1]
		    	tab.num = num[1]
		    	tab.index = self.m_nBagIndex + 1
		    	self.m_tMakeBagData[tab.id] = tab
			end
		end
	end
end
function CellPastureWorker:_onGetWorkShopBaseInfo(id, skillId, status, sandglassCD, endTime, num)
	for i=1,4 do
		local tab = {}
		tab.id = id[i] or i
		tab.skill = skillId[i] or 0
		tab.status = status[i] or 0
		tab.sandglassCD = sandglassCD[i] or 0
		tab.endTime = endTime[i] or 0
		tab.make_num = num[i] or 0
		self.m_tMakeWorkShopData[i] = tab
	end
	self:setWorkShopData()
end
function CellPastureWorker:_onGetUnlockPosResult(id)
	MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT24)
	local index = nil
	for i=1, #self.m_tMakeWorkShopData do
		if self.m_tMakeWorkShopData[i].id == id then
			index = i
			break
		end
	end
	if index then
		self.m_tCellMakeItem[index].btnLock:setVisible(false)
		self.m_tCellMakeItem[index].img_lock:setVisible(false)
		self.m_tCellMakeItem[index].skillItemObj:setData(0, 1, false, true)
		self.m_tCellMakeItem[index].skillItemItem:setTag(index)
		--工坊的位置
		local function func(tableid)
			WndPastureMake:showInterface(tableid)
		end
		self.m_tCellMakeItem[index].skillItemObj:setCallFunc(func)
	end
end
--选择制作的物品
function CellPastureWorker:_onGetWorkShopMakeIdResult(index, data)
	if self.m_tChooseMakeItemData[index] == nil then
		self.m_tChooseMakeItemData[index] = {}
	end
	self.m_tChooseMakeItemData[index] = data
	self.m_bIsMake = true
	if self.m_tCellMakeItem[index] then
		self.m_nMakeNumber[index] = 1
		self.m_tCellMakeItem[index].txtMakeNum:setText(self.m_nMakeNumber[index])

		self.m_tCellMakeItem[index].btnMake:setVisible(true)
		self.m_tCellMakeItem[index].btnAdd:setVisible(true)
		self.m_tCellMakeItem[index].btnMinus:setVisible(true)
		--保存制作消耗的id和数量
		local tab = {}
		tab.consumeId = data.use[1][1]
		tab.price = data.use[1][2]
		self.m_tConsumeDaimand[index] = tab
		local info = GDatatab_item["id_"..data.use[1][1]]
		local str = [[<T C="255,255,255" S="20" P="1" SC="132,66,29" SE="1" SS="4">%d</T><I Z="0.5">%s</I>]]
		self.m_tCellMakeItem[index].txtFreeMakePrice:setShowText(string.format(str,data.use[1][2],info.icon))
		local make_data = self.m_tMakePriceData[index]
		if make_data and self.m_tAccScheduleTime[index] and self.m_tAccScheduleTime[index] <= 0 then
			local info1 = GDatatab_item["id_"..make_data[1]]
			local str = [[<I Z="0.5">%s</I><T C="255,255,255" S="18" P="1" SC="132,66,29" SE="1" SS="4">%d</T>]]
			self.m_tCellMakeItem[index].txtFreeTime:setShowText(string.format(str,info1.icon,make_data[2]))
		end
		self.m_tCellMakeItem[index].skillItemObj:setData(data.skillid, 1, false, false)
		self.m_tCellMakeItem[index].skillItemObj:setDefaultTip(true)
		local function func(tableid)
			self.m_tCellMakeItem[tableid].skillItemObj:setData(0, 1, true, true)
			self.m_tCellMakeItem[tableid].makeChangeNum:setVisible(false)
			self.m_tCellMakeItem[tableid].btnMake:setVisible(false)
		end
		self.m_tCellMakeItem[index].skillItemObj:setOtherCallFunc(func)
		self.m_tCellMakeItem[index].makeChangeNum:setVisible(true)
	end
end
--制作结果
function CellPastureWorker:_onGetWorkShopMakeingResult(id, num, endTime, sandglassCD, tableid)
	if self.m_tCellMakeItem[tableid] then
		self.m_tCellMakeItem[tableid].btnMake:setVisible(false)
		self.m_tCellMakeItem[tableid].makeIngCon:setVisible(true)
		self.m_tCellMakeItem[tableid].txtMakeTimeing:setText(SystemTime:getTimeConverLocal2(endTime))

		self.m_tMakeScheduleTime[tableid] = endTime
		self.m_tCellMakeItem[tableid].btnAdd:setVisible(false)
		self.m_tCellMakeItem[tableid].btnMinus:setVisible(false)
		
		self.m_tCellMakeItem[tableid].skillItemObj:setDefaultTip(false)
		local make_data = self.m_tMakePriceData[tableid]
		if make_data and self.m_tAccScheduleTime[tableid] and self.m_tAccScheduleTime[tableid] <= 0 then
			local info1 = GDatatab_item["id_"..make_data[1]]
			local str = [[<I Z="0.5">%s</I><T C="255,255,255" S="18" P="1" SC="132,66,29" SE="1" SS="4">%d</T>]]
			self.m_tCellMakeItem[tableid].txtFreeTime:setShowText(string.format(str,info1.icon,make_data[2]))
		end
	end
end
--加速合成
function CellPastureWorker:_onGetComposeAccResult( index, cdTime, endTime )
	if self.m_tCellMakeItem[index] then
		self.m_tAccScheduleTime[index] = cdTime
		--剩余制作时间
		self.m_tCellMakeItem[index].txtMakeTimeing:setText(SystemTime:getTimeConverLocal2(endTime))
		self.m_tMakeScheduleTime[index] = endTime
	end
end
-------------------------------------私有方法模块End----------------------------------------
