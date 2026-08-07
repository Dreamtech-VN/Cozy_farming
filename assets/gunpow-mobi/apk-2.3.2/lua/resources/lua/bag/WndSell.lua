--WndSell.lua
--@brief	WndSell的UI模块
--@date		2015/07/03
--@author	zsq
--@note		出售背包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSell:onEnter(element)
	self.m_root = element
	self:register()
	self:_moreLanguage()
	AdaptLanguage(self)
	ProtocolProcessorPhantom:regAll()
	ProtocolProcessorPhantom:send_SHAPE_SendEquipInfo( )
end

function WndSell:onEnterTransitionDidFinish(element)
	-- CacheCenter:registerUpatePlayerItemObserver(self)--注册物品

	self.m_sConGoods_WndEquip = GetElement(self.m_root,"conGoods_WndEquip",WZUIContainer)
	self.m_sNodeContainer = CCNode:create()
	self.m_root:addChild(self.m_sNodeContainer)
	-- GetElement(self.m_root, "btn2", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	self.m_nIndex = 2
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	AdaptLanguage(self)


	ProtocolProcessorScenePets:regAll1()
	ProtocolProcessorScenePets:send_MOUNTS_GetSpriteStoneData()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSell:onExit(element)
	-- CacheCenter:unregisterUpatePlayerItemObserver(self)
	doStopAllActions(self.m_sConGoods_WndEquip)
	doStopAllActions(self.m_sNodeContainer)
	self:unregister()
	self:_unInit()
end

function WndSell:register()
	GlobalGame:getGameEventDispathcer():Add(bottomMeneEvent.WndBottomMeneEvent_UpdataBagResertInfo,self._onUpdataResertInfo,self)
	GlobalGame:getGameEventDispathcer():Add(bottomMeneEvent.WndBottomMeneEvent_UpdataItemCache,self._onUpdataItemCache,self)
	GlobalGame:getGameEventDispathcer():Add(PetMountEvent.PetMountEvent_EquipSlaveStoneInfo,self._onPetMountBaseInfo,self)--灵石和灵石之源
end
function WndSell:unregister()
	GlobalGame:getGameEventDispathcer():Remove(bottomMeneEvent.WndBottomMeneEvent_UpdataBagResertInfo,self._onUpdataResertInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(bottomMeneEvent.WndBottomMeneEvent_UpdataItemCache,self._onUpdataItemCache,self)
	GlobalGame:getGameEventDispathcer():Remove(PetMountEvent.PetMountEvent_EquipSlaveStoneInfo,self._onPetMountBaseInfo,self)--灵石和灵石之源
end

function WndSell:_onPetMountBaseInfo(masterSlot, masterItemId, slaveStoneData)
	--WZLog("WndSell:_onPetMountBaseInfo", Serialize(masterSlot), Serialize(masterItemId), Serialize(slaveStoneData))
	self.m_tUseAccStoneData = {}
	self.m_tMountStoneBaseData = {}
	--self.m_tStoneSourceBagData = {}
	for i=1,#masterSlot do
		local tab = {}
		tab.playerItemId = masterItemId[i]
		tab.quality = self:_getQuality(masterItemId[i])
		tab.item_id = self:_getItemId(masterItemId[i])
		tab.is_open = true -- 槽位是否开启
		tab.ass_message = {} --副槽的信息
		if slaveStoneData[i] ~= "" then
			tab.is_open = false 
			local slaveStoneData = json.decode(slaveStoneData[i])
			local temp_tab = {}
			for i=1,#slaveStoneData do
				local tab1 = {}
				tab1.itemId = slaveStoneData[i].itemId or 0
				tab1.propertyType = slaveStoneData[i].propertyType or 0
				tab1.playerItemId = slaveStoneData[i].playerItemId or 0
				self.m_tUseAccStoneData[tab1.playerItemId] = true
				tab1.slot = slaveStoneData[i].slot
				temp_tab[slaveStoneData[i].slot+1] = tab1
			end
			tab.ass_message = temp_tab
		end
		-- if tab.item_id and tab.item_id ~= 1 then
		-- 	self.m_tImgPosStone[masterSlot[i]]:setVisible(true)
		-- 	local info = GDatatab_item["id_"..tab.item_id]
		-- 	if info then
		-- 		self.m_tImgPosStone[masterSlot[i]]:setFile(info.icon)
		-- 	end
		-- end
		self.m_tMountStoneBaseData[masterSlot[i]] = tab
	end
	self.m_tStoneSourceBagData = self:getSourceStoneData()
	--WZLog("WndSell:_onPetMountBaseInfo self.m_tStoneSourceBagData = ", Serialize(self.m_tStoneSourceBagData))


	self:updateTempPlayerItemData()
end

-- 根据playerid获取品质
function WndSell:_getQuality(itemId)
	if itemId == 0 then
		return 1
	end
	if self.m_tStoneBagData == nil then
		self.m_tStoneBagData = CacheCenter:getMountStoneList()
	end
	for i,v in pairs(self.m_tStoneBagData) do
		if v.playerItemId == itemId then
			return v.basicInfo.quality
		end
	end
end
-- 根据playerid获取物品id
function WndSell:_getItemId(itemId)
	if itemId == 0 then
		return 1
	end
	if self.m_tStoneBagData == nil then
		self.m_tStoneBagData = CacheCenter:getMountStoneList()
	end
	for i,v in pairs(self.m_tStoneBagData) do
		if v.playerItemId == itemId then
			return v.basicInfo.id
		end
	end
end

function WndSell:_moreLanguage()
	
end

function WndSell:onSaleClick() 
	WndEquipNew:onSaleClick()
end

function WndSell:onSynthesis() 
	-- WndEquipNew:onSynthesis()

	--返回
	WndSellList:onReturn()
end

function WndSell:onCloseClick() 
	if self.m_root == nil then return end
	WndBagRole:onCloseClick()
end

--@brief	更新复选框
function WndSell:updateTabIndex(nIndex)
	if self.m_root == nil then return end
	if nIndex == 1 then
		self:onTab1()
	elseif nIndex == 2 then
		self:onTab2()
	elseif nIndex == 3 then
		self:onTab3()
	elseif nIndex == 4 then
		self:onTab4()
	elseif nIndex == 5 then
		self:onTab5()
	elseif nIndex == 6 then
		self:onTab6()
	end
end

--@brief	全部复选框回调
function WndSell:onTab1(element)
	doStopAllActions(self.m_sConGoods_WndEquip)
	doStopAllActions(self.m_sNodeContainer)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("全部复选框回调")
	if self.m_nIndex == 1 then
		return 
	end
	self.m_nIndex = 1
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	GetElement(self.m_root,"btn3",WZUIButton):setVisible(true)
end

--@brief	装备复选框回调
function WndSell:onTab2(element)
	doStopAllActions(self.m_sConGoods_WndEquip)
	doStopAllActions(self.m_sNodeContainer)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("装备复选框回调")
	if self.m_nIndex == 2 then
		return 
	end
	self.m_nIndex = 2
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	GetElement(self.m_root,"btn3",WZUIButton):setVisible(true)
end

--@brief	道具复选框回调
function WndSell:onTab3(element)
	doStopAllActions(self.m_sConGoods_WndEquip)
	doStopAllActions(self.m_sNodeContainer)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("道具复选框回调")
	if self.m_nIndex == 3 then
		return 
	end
	self.m_nIndex = 3
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	GetElement(self.m_root,"btn3",WZUIButton):setVisible(false)
end

--@brief	材料复选框回调
function WndSell:onTab4(element)
	doStopAllActions(self.m_sConGoods_WndEquip)
	doStopAllActions(self.m_sNodeContainer)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("材料复选框回调")
	if self.m_nIndex == 4 then
		return 
	end
	self.m_nIndex = 4
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	GetElement(self.m_root,"btn3",WZUIButton):setVisible(false)
end

--@brief	宝石复选框回调
function WndSell:onTab5(element)
	doStopAllActions(self.m_sConGoods_WndEquip)
	doStopAllActions(self.m_sNodeContainer)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("宝石复选框回调")
	if self.m_nIndex == 5 then
		return 
	end
	self.m_nIndex = 5
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	GetElement(self.m_root,"btn3",WZUIButton):setVisible(false)
end

--@brief	其他复选框回调
function WndSell:onTab6(element)
	doStopAllActions(self.m_sConGoods_WndEquip)
	doStopAllActions(self.m_sNodeContainer)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("WndSell:onTab6 其他复选框回调")
	if self.m_nIndex == 6 then
		return 
	end
	self.m_nIndex = 6
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	GetElement(self.m_root,"btn3",WZUIButton):setVisible(false)
end

function WndSell:onSelect(element)
	WZLog("WndSell:onSelect")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if WndSellList.m_tGetResetIdsList and next(WndSellList.m_tGetResetIdsList) and #WndSellList.m_tGetResetIdsList >= self.m_nMaxCount then
		MsgBoxManager:showTipBox(LocalStrings.BAGTIP4)
		return
	end

	local nums = getnTableCount(self.m_tSellList)
	local sellCount = nums
	local find = false
	local test = {}
	local table_insert = table.insert
	for i=1,#self.m_tData do
		local tData = self.m_tData[i]
		--紫色品质以下的装备
		if tData.basicInfo.main_type == 4 and tData.basicInfo.quality < 3 and tData.sellHook ~= true and sellCount < self.m_nMaxCount then
			local tab = {}
			tab.index = i-1
			tab.data = tData
			test[i] = tab
			WndSellList:setShowResetData(tData)

			sellCount = sellCount + 1
			find = true
		end
	end

	if not find then
		if sellCount == self.m_nMaxCount then
			MsgBoxManager:showTipBox(LocalStrings.BAGTIP4)
		else
			MsgBoxManager:showTipBox(LocalStrings.QUICKSELECT4)
			return
		end
	end
	GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF):setText(sellCount.."/"..self.m_nMaxCount)
	doStopAllActions(self.m_sNodeContainer)
	for i, v in pairs(test) do
 		self:onRightItemClick(nil, v.index, v.data, true)
 	end
	WndSellList:setShowResetItem()
end

--@brief	右边物品点击回调
-- bQuick : 只有存在点击快速选择的时候才会有清理
function WndSell:onRightItemClick(lua,tag,tData, bQuick)
	if self.m_root == nil or tData == nil then
		return
	end
	WZLog("WndSell:onRightItemClick", tData.basicInfo.name)
	if tag == nil then return end
	if tData.isHuanhua and tData.isHuanhua == true then
		WZLog("WndSell:onRightItemClick Huanhua", tData.basicInfo.name)
	end
	--记录出售物品列表
	if self.m_tSellList == nil then self.m_tSellList = {} end
	
	--一次最多回收16类物品
	if (self.m_tData[tag+1].sellHook == nil or self.m_tData[tag+1].sellHook == false) and #self.m_tSellList >= self.m_nMaxCount then 
		MsgBoxManager:showTipBox(LocalStrings.BAGTIP4)
		return
	end

	self.m_nTag = tag
	local tDataList = self.m_tData

	--物品状态为未出售，则选中出售，左边出售列表增加该物品
	if tDataList[tag+1].sellHook == false or tDataList[tag+1].sellHook == nil then
		local tItem = tDataList[tag+1]

		if self:isUseTimeLimit(tDataList[tag+1]) then
		  MsgBoxManager:showConfirmBoxWithBg(LocalStrings.USINGLIMITEQUIP or "", self, self.useLimitCall, MSGBOXLEVEL_HIGH, {[MSGBOXUICFG_USEFREETXT] = true})
			return
		end

		--出售坐骑兑换卡前确认
		if tItem.basicInfo.main_type == 2 and tItem.basicInfo.sub_type == 11 then
			MsgBoxManager:showConfirmCancelBox(LocalStrings.SELLINFO1, self, self.sellhorse, MSGBOXLEVEL_HIGH,nil)
			return
		end
		--WZLog("WndSell:onRightItemClick 2-1", tData.basicInfo.name)
		if tDataList[tag+1].lastNum == 1 then
			tDataList[tag+1].sellHook = true
			local tempData = CopyTable(tDataList[tag+1])
			tempData.sellHook = false
			table.insert(self.m_tSellList,tempData)
			-- self.m_tData = self:getCurData()
			-- self:_update(true)
			if self.m_tGridList and self.m_tGridList[tag+1] then
				self.m_tGridList[tag+1]:showSelectedIcon(20)
			end

			self:setResetItem(self.m_tSellList, bQuick)
		else
			WndSellNum:show(tDataList[tag+1])
		end
	else
		--物品状态为出售，则取消出售，左边出售列表删除该物品
		--WZLog("WndSell:onRightItemClick 3", tData.basicInfo.name)
		tDataList[tag+1].sellHook = false
		for i=1,#self.m_tSellList do
			if self.m_tSellList[i].playerItemId == tDataList[tag+1].playerItemId then
				table.remove(self.m_tSellList,i)
				break
			end
		end
		self.m_tData = self:getCurData()
		self:_update(true)
		if self.m_tGridList and self.m_tGridList[tag+1] then
			self.m_tGridList[tag+1]:removeGouIcon()
		end

		self:setResetItem(self.m_tSellList)
	end
	WndSellList.m_tLeft = self.m_tSellList
	WndSellList:updateActProgress()
	GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF):setText(#self.m_tSellList.."/"..self.m_nMaxCount) 
end

function WndSell:setResetItem(data, bQuick)
	--WZLog("WndSell:setResetItem", Serialize(data))
	if not data then return end
	WndSellList.m_tGetResetIdsList = {}
	WndSellList.m_tGetResetNumsList = {}
	for i=1, #data do
		local tData = data[i]
		--紫色品质以下的装备
		if bQuick == true then
			if tData.basicInfo.main_type == 4 and tData.basicInfo.quality < 3 and tData.sellHook ~= true then
				WndSellList:setShowResetData(tData)
			end
		else
			WndSellList:setShowResetData(tData)
		end
	end
	WndSellList:setShowResetItem()
end

function WndSell:sellhorse(nId, nResType) 
	if nResType ~= MSGBOXRESTYPE_CONFIRM then return end
	self:useLimitCall()
end

function WndSell:useLimitCall(nId, nResType) 
	WZLog("WndSell:useLimitCall")

	local tDataList = self.m_tData
	local tag = self.m_nTag
	--物品状态为未出售，则选中出售，左边出售列表增加该物品
	if tDataList[tag+1].sellHook == false or tDataList[tag+1].sellHook == nil then
		if tDataList[tag+1].lastNum == 1 then
			tDataList[tag+1].sellHook = true
			local tempData = CopyTable(tDataList[tag+1])
			tempData.sellHook = false
			table.insert(self.m_tSellList,tempData)
			self.m_tData = self:getCurData()
			self:_update(true)
			WndSellList:setShowResetData(tempData)
		else
			WndSellNum:show(tDataList[tag+1])
		end
	else
		--物品状态为出售，则取消出售，左边出售列表删除该物品
		tDataList[tag+1].sellHook = false
		for i=1,#self.m_tSellList do
			if self.m_tSellList[i].playerItemId == tDataList[tag+1].playerItemId then
				table.remove(self.m_tSellList,i)
				break
			end
		end
		self.m_tData = self:getCurData()
		self:_update(true)
	end
	WndSellList:setShowResetItem()
	WndSellList.m_tLeft = self.m_tSellList
	WndSellList:updateActProgress()
	GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF):setText(#self.m_tSellList.."/"..self.m_nMaxCount)
end
--WndSellNum点击物品放入的时候
function WndSell:onRightItemClick1(tData)
	tData.sellHook = false
	table.insert(self.m_tSellList,tData)
	self.m_tData = self:getCurData()
	self:_update(true)
	WndSellList:setShowResetData(tData)
	WndSellList:setShowResetItem()
end

--@brief	出售成功,刷新列表
function WndSell:updateTempPlayerItemData()
	WZLog("WndSell:updatePlayerItemData")
	if self.m_root == nil then return end
	 
    local tbconList = GetElement(self.m_root, "tableCon_WndSell", WZUITableContainer)
    local nCurPositionY = tbconList:getMoveElement():getPositionY()
    local tLastSize = tbconList:getMoveElement():getContentSize()

	--首先清空列表
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_update()

    --重新设置列表的位置
    local tCurSize = tbconList:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > tbconList:getMaxPosition().y then
        nTempPositionY = tbconList:getMaxPosition().y
    end
    tbconList:getMoveElement():setPositionY(nTempPositionY)
end

--@brief	是否正在使用限时装备
function WndSell:isUseTimeLimit(tData) 
	if tData.basicInfo.main_type ~= 4 then return false end

	local tDataList = CacheCenter:getEquipedList()
	if tData.basicInfo.main_type == 4 and tData.basicInfo.sub_type == 0 or tData.basicInfo.sub_type == 1 then
		for i=1,#tDataList do
			if tDataList[i].basicInfo.main_type == 4 and (tDataList[i].basicInfo.sub_type == 0 or tDataList[i].basicInfo.sub_type == 1) and tDataList[i].basicInfo.time_limit ~= -1 then
				return true
			end
		end
	end

	for i=1,#tDataList do
		if tDataList[i].basicInfo.main_type == 4 and tDataList[i].basicInfo.sub_type == tData.basicInfo.sub_type and tDataList[i].basicInfo.time_limit ~= -1 then
			return true
		end
	end
	return false
end

--@brief	获得该装备部位拥有几件装备
function WndSell:hasEquipNum(tData) 
	return 1
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新出售物品
--@param 	bResetPosition 为true，则不重置，否则，重新刷新表
function WndSell:_update(bResetPosition)
	WZLog("WndSell:_update")
	if self.m_root == nil then
		return
	end
	local bResetPositionY = bResetPosition or false
	local tableConRight = WZUITableContainer:luaTo(self.m_root:getChildElement("tableCon_WndSell"))
	tableConRight:setLoadCountPerFrame(4)
	local tablePositionY = tableConRight:getMoveElement():getPositionY()

	--如果格子对象列表为nil,初始化为空表格
	if self.m_tGridList == nil then self.m_tGridList = {} end

	-- doStopAllActions(self.m_sConGoods_WndEquip)
	for i=1,#self.m_tData do
		-- delayRun(self.m_sConGoods_WndEquip, i / DEFAULT_FPS,function ()
		    --普通类型
			local gridType = 30
			if self.m_nIndex == 6 and self.m_tData[i].maintype and self.m_tData[i].maintype == 38 and self.m_tData[i].subtype and self.m_tData[i].subtype ~= 14 then
				if self.m_tData[i].subtype < 9 then
					--坐骑灵石
					gridType = 32
				else
					--灵石之源
					gridType = 33
				end
			end
			--WZLog("WndSell:_update gridType =", gridType)
			if self.m_tSellList ~= nil then
				for k=1,#self.m_tSellList do
					if self.m_tSellList[k] and self.m_tData[i] and self.m_tSellList[k].playerItemId == self.m_tData[i].playerItemId then
						self.m_tData[i].sellHook = true
						if gridType == 30 then
							self.m_tData[i].lastNum =  self.m_tData[i].lastNum - self.m_tSellList[k].lastNum
						end
					end
				end
			end
			if self.m_tGridList[i] == nil then
				--格子不够,创建格子
				local celElement,tCell = CellGrid:createElement()
				if celElement and tCell then
					celElement:setTag(i-1)
					tableConRight:setCellElement(celElement)
					tCell:setCellGoodItem(self.m_tData[i], gridType)
					tCell:setItemClickFun(self,self.onRightItemClick)
					if self.m_tData[i].maintype == 38 and self.m_tData[i].subtype ~= 14 and self.m_tData[i].extraInfo then
						--WZLog("WndSell:_update spriteStoneQuality =", self.m_tData[i].extraInfo.spriteStoneQuality)
						tCell:setVisibleItemCount(self.m_tData[i].extraInfo.spriteStoneQuality)
						--tCell:clearItemQualityPic(nil, self.m_tData[i].extraInfo.spriteStoneQuality)
					end
					table.insert(self.m_tGridList,tCell)
				end
			else
				--有格子,直接设置
				self.m_tGridList[i]:setCellGoodItem(self.m_tData[i], gridType)
				self.m_tGridList[i]:setItemClickFun(self,self.onRightItemClick)
				if self.m_tData[i].maintype == 38 and self.m_tData[i].subtype ~= 14 and self.m_tData[i].extraInfo then
					--WZLog("WndSell:_update spriteStoneQuality ==", self.m_tData[i].extraInfo.spriteStoneQuality)
					self.m_tGridList[i]:setVisibleItemCount(self.m_tData[i].extraInfo.spriteStoneQuality)
					--self.m_tGridList[i]:clearItemQualityPic(nil, self.m_tData[i].extraInfo.spriteStoneQuality)
				end
			end 
		-- end)
	end

	self:_createEmptyItem(tableConRight,#self.m_tGridList)--创建空白Item
	--将剩下的格子设置为空
	for i=#self.m_tData+1,#self.m_tGridList do
		self.m_tGridList[i]:removeAllChild()
	end
	--Add By Tianxiang_Xu
	if bResetPositionY then
		tableConRight:getMoveElement():setPositionY(tablePositionY)
	else
		tableConRight:getMoveElement():setPositionY(tableConRight:getMinPosition().y)
	end
	GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF):setText(#self.m_tSellList.."/"..self.m_nMaxCount)
end

--@param	创建空白Item
function WndSell:_createEmptyItem(tableConGoods,num)
	local maxCount = 20
	if num > 20 then
		if num % 4 == 0 then
			maxCount = 0
		else
			maxCount = 4 - num %4
		end
	else
		maxCount = 20-num
	end
	if tableConGoods == nil or maxCount == 0 then
		return 
	end
	for i=1,maxCount do
		local celElement,tCell = CellGrid:createElement()
		if celElement and tCell then
			celElement:setTag(num+i-1)
			tableConGoods:setCellElement(celElement)
			tCell:setItemClickFun(self,self.onRightItemClick)
			table.insert(self.m_tGridList,tCell)
		end
	end
end

--@brief	清空背包
function WndSell:cleanBag()
	local tableConGoods = self.m_root:getChildElement("tableCon_WndSell")
	tableConGoods = WZUITableContainer:luaTo(tableConGoods)
	tableConGoods:cleanTable()
	self.m_tGridList = {}
end

--@brief   设置复选框文本颜色
function WndSell:_setTextColorByTag(tag)
	WZLog("WndSell:_setTextColorByTag",tag)
	for i=1,6 do
		self:_setTextColor(self.m_root:getChildElement("txtTab"..i.."_WndSell"),GlobalMethod:ccc3(127,70,26))
    	GetElement(self.m_root, "imgTab"..i.."_WndSell", WZUI9Image):setVisible(false)
	end
	self:_setTextColor(self.m_root:getChildElement("txtTab"..tag.."_WndSell"),GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(127,70,26))
   	GetElement(self.m_root, "imgTab"..tag.."_WndSell", WZUI9Image):setVisible(true)
end

--@brief   文本颜色和描边颜色
function WndSell:_setTextColor(txt,color,strcolor)
	WZLog("WndRecover:_setTextColor")
	if self.m_root == nil or txt == nil then
		return
	end
	local color = color or GlobalMethod:ccc3(127,70,26)
	txt = WZUILabelTTF:luaTo(txt)
	txt:setColor(color)
	if strcolor then
		txt:setEnableStroke(true)
		txt:setStrokeColor(strcolor)
	else
		txt:setEnableStroke(false)
	end
end

function WndSell:_onUpdataResertInfo()
	--发送协议获取幻化装备列表信息
	self:sendEquipInfoProtocol()
	--发送协议获取坐骑灵石和灵石之源列表信息
	self:sendMountStoneInfoProtocol()
	-- self:updatePlayerItemData()
	self:updateTempPlayerItemData()
	WndPlayer:updatePlayerItemData()
end
function WndSell:_onUpdataItemCache(playerItemId, splitCount, key, value)
	local data = {}
	local index = 1
	for i=1,#playerItemId do
		local tab = {}
		tab.id = playerItemId[i]
		local temp_key = {}
		local temp_value = {}
		for m=1,splitCount[i] do
			table.insert(temp_key, key[index])
			table.insert(temp_value, value[index])
			index = index + 1
		end
		tab.key = temp_key
		tab.value = temp_value
		data[i] = tab
	end

	local bUpdateDecoration, bUpdateItem = false, false 
	for i=1,#data do
		local bUpdateDec, bUpdate = self:updateEachPlayerItems(data[i].id, data[i].key, data[i].value)
		if bUpdateDec then 
			bUpdateDecoration = bUpdateDec
		end
		if bUpdate then 
			bUpdateItem = bUpdate 
		end
	end

	self:callUpdateUIFunc(bUpdateDecoration, bUpdateItem)
end

--@brief   显示变废为宝活动兑换粒子动画
function WndSell:showExchangeAnim()
	if not self.m_root then
		return
	end


	for i=1,#self.m_tData do
		if self.m_tData[i].sellHook == true then

			local nIndex=i
			
		    local tableCon = GetElement(self.m_root, "tableCon_WndSell", WZUITableContainer)
		    local conTableGoods = GetElement(self.m_root, "conTableGoods_WndSell", WZUIContainer)

		    local nColNum = tableCon:getColumnCount()
		    local nRowNum = math.ceil(#self.m_tGridList / nColNum)

		    local tLastSize = tableCon:getMoveElement():getContentSize()

			local nItemPosX = tLastSize.width * (((nIndex - 1) % nColNum) * 2 + 1) / 10
			local nItemPosY = (tableCon:getMoveElement():getPositionY() - tableCon:getMinPosition().y) + (tableCon:getContentSize().height - (tableCon:getMoveElement():getContentSize().height / nRowNum / 2) * (math.ceil(nIndex / nColNum) * 2 - 1))

		    local particleTrain = CCParticleSystemQuad:create("particle/ui_juexingzhihun_tuowei.plist")
		    particleTrain:setDuration(kCCParticleDurationInfinity)
		    particleTrain:setAutoRemoveOnFinish(true)

	        particleTrain:setStartColor(ccc4f(233/255,166/255,62/255,1))
	        particleTrain:setEndColor(ccc4f(0,0,0,0))

		    particleTrain:setPosition(nItemPosX,nItemPosY)

		    conTableGoods:addChild(particleTrain)

		    if particleTrain then
		        particleTrain:setVisible(true)

		        local arrayAni = CCArray:create()

		        local delayAni1 = CCDelayTime:create(0.5)
		        local moveTo = CCMoveTo:create(0.5, ccp(-220, 150))
		        local delayAni2 = CCDelayTime:create(0.5)
		        local functionAni1 = CCCallFuncN:create(function()
		        	particleTrain:removeFromParentAndCleanup(true)
		        end)

		        arrayAni:addObject(delayAni1)
		        arrayAni:addObject(moveTo)
		        arrayAni:addObject(delayAni2)
		        arrayAni:addObject(functionAni1)

		        local sequence = CCSequence:create(arrayAni)
		        particleTrain:runAction(sequence)
		    end
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------

---------------------------------------语言适配Begin-----------------------------------------
function WndSell:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtTab4_WndSell",WZUILabelTTF):setFontSize(22)

	local txtQuickSelect = GetElement(self.m_root,"txtQuickSelect_WndEquipNew",WZUILabelTTF)
	txtQuickSelect:setScale(0.7)
	txtQuickSelect:setDimensions(GlobalMethod:CCSize(160))

	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))
end


function WndSell:_adaptLanguage_th(  )
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.8)
end

function WndSell:_adaptLanguage_pt(  )
	local txtTab1 = GetElement(self.m_root,"txtTab1_WndSell",WZUILabelTTF)
    local txtTab2 = GetElement(self.m_root,"txtTab2_WndSell",WZUILabelTTF)
    local txtTab3 = GetElement(self.m_root,"txtTab3_WndSell",WZUILabelTTF)
    local txtTab4 = GetElement(self.m_root,"txtTab4_WndSell",WZUILabelTTF)

    txtTab1:setFontSize(22)
    txtTab2:setFontSize(22)
    txtTab3:setFontSize(22)
    txtTab4:setFontSize(22)

	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))
	
	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))

	local txtQuickSelect = GetElement(self.m_root,"txtQuickSelect_WndEquipNew",WZUILabelTTF)
	txtQuickSelect:setScale(0.7)
	txtQuickSelect:setDimensions(GlobalMethod:CCSize(160))
    
    -- GetElement(self.m_root,"imgArrow1_WndEquip",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.23,0.945))
    -- GetElement(self.m_root,"imgArrow2_WndEquip",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.77,0.945))
end

function WndSell:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtTab4_WndSell",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtTab5_WndSell",WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"txtSale_WndEquipNew",WZUILabelTTF):setScale(0.7)

	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))
end

function WndSell:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtTab2_WndSell",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"txtTab3_WndSell",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"txtTab4_WndSell",WZUILabelTTF):setFontSize(22)

	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))
	
	local txtQuickSelect = GetElement(self.m_root,"txtQuickSelect_WndEquipNew",WZUILabelTTF)
	txtQuickSelect:setScale(0.7)
	txtQuickSelect:setDimensions(GlobalMethod:CCSize(160))


end

function WndSell:_adaptLanguage_vn(  )
	-- GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF):setScale(0.7)
	
	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))
end

function WndSell:_adaptLanguage_ug(  )
	GetElement(self.m_root,"txtTab4_WndSell",WZUILabelTTF):setScale(0.6)

	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))
	
	local txtQuickSelect = GetElement(self.m_root,"txtQuickSelect_WndEquipNew",WZUILabelTTF)
	txtQuickSelect:setScale(0.7)
	txtQuickSelect:setDimensions(GlobalMethod:CCSize(160))

	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.6)
	txtChoiceNum:setRelativePosition(GlobalMethod:ccp(-0.01,0.98))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.6)
	txtChoice:setDimensions(GlobalMethod:CCSize(350))
	txtChoice:setRelativePosition(GlobalMethod:ccp(0.455,0.98))

	GetElement(self.m_root,"txtSale_WndEquipNew",WZUILabelTTF):setScale(0.7)
	local txtQuickSelect = GetElement(self.m_root,"txtQuickSelect_WndEquipNew",WZUILabelTTF)
	txtQuickSelect:setScale(0.7)
	txtQuickSelect:setDimensions(GlobalMethod:CCSize(180))
end
-------------------------------------语言适配End-------------------------------------------
