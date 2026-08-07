--WndMountStone.lua
--@brief	WndMountStone的UI模块
--@date		2021/04/28
--@author	hyx
--@note		坐骑灵石


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMountStone:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMountStone:onExit(element)
	self:_unInit()
	self:unregister()
	if WZFileUtil:isFileExist("pack/mountstone/pack_mountstone_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/mountstone/pack_mountstone_0.plist")
    end
end
function WndMountStone:register()
	GlobalGame:getGameEventDispathcer():Add(PetMountEvent.PetMountEvent_EquipSlaveStoneInfo,self._onPetMountBaseInfo,self)
	GlobalGame:getGameEventDispathcer():Add(PetMountEvent.PetMountEvent_StonePutonResult,self._onStonePutOnResult,self)
	GlobalGame:getGameEventDispathcer():Add(PetMountEvent.PetMountEvent_EquipMasterStoneResult,self._onStoneMainSlotResult,self)
	GlobalGame:getGameEventDispathcer():Add(PetMountEvent.PetMountEvent_StoneSourceAssResult,self._onStoneSourceAssResult,self)
	GlobalGame:getGameEventDispathcer():Add(PetMountEvent.PetMountEvent_StoneUpgradeResult,self._onStoneUpgradeResult,self)
	GlobalGame:getGameEventDispathcer():Add(PetMountEvent.PetMountEvent_StoneSlotPutonResult,self._onStoneSlotPutonResult,self)
	GlobalGame:getGameEventDispathcer():Add(PetMountEvent.PetMountEvent_StoneSlotRemoveResult,self._onStoneSlotRemoveResult,self)
end
function WndMountStone:unregister()
	GlobalGame:getGameEventDispathcer():Remove(PetMountEvent.PetMountEvent_EquipSlaveStoneInfo,self._onPetMountBaseInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(PetMountEvent.PetMountEvent_StonePutonResult,self._onStonePutOnResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PetMountEvent.PetMountEvent_EquipMasterStoneResult,self._onStoneMainSlotResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PetMountEvent.PetMountEvent_StoneSourceAssResult,self._onStoneSourceAssResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PetMountEvent.PetMountEvent_StoneUpgradeResult,self._onStoneUpgradeResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PetMountEvent.PetMountEvent_StoneSlotPutonResult,self._onStoneSlotPutonResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PetMountEvent.PetMountEvent_StoneSlotRemoveResult,self._onStoneSlotRemoveResult,self)
end
function WndMountStone:onEnterTransitionDidFinish(element)
	self:initShowUI()
	ProtocolProcessorScenePets:regAll1()
	ProtocolProcessorScenePets:send_MOUNTS_GetSpriteStoneData()
end
local nMaxStoneNum = 8 --灵石最大数量

function WndMountStone:initShowUI()
	self.m_tStoneBagData = CacheCenter:getMountStoneList()

	self.m_sRightContainer = GetElement(self.m_root,"right_con",WZUIContainer)
	self.m_sStoneContainer1 = GetElement(self.m_root,"stoneContainer1",WZUIContainer)
	self.m_sStoneContainer1:setVisible(false)
	self.m_StoneContainer2 = GetElement(self.m_root,"stoneContainer2",WZUIContainer)
	self.m_StoneContainer2:setVisible(true)	
	local attrContainer = GetElement(self.m_sStoneContainer1,"attrContainer",WZUIContainer)
	for i=1,8 do
		self.m_tTxtAttrRich[i] = GetElement(attrContainer,"txtFreeRich"..i,WZUIFreeTextBox)
	end
	for i=1,2 do
		local tab = {}
		local btn = GetElement(self.m_sRightContainer,"btn"..i,WZUIButton)
        tab.normal = GetElement(btn,"normal",WZUI9Image)
        tab.select = GetElement(btn,"select",WZUI9Image)
        tab.name = GetElement(btn,"name",WZUILabelTTF)
		self.m_tBagItemTitle[i] = tab
	end
	self.m_n_BagItemIndex = 1
	self.m_tBagItemTitle[self.m_n_BagItemIndex].normal:setVisible(false)
	self.m_tBagItemTitle[self.m_n_BagItemIndex].select:setVisible(true)
	self.m_tBagItemTitle[self.m_n_BagItemIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
	self.m_tBagItemTitle[self.m_n_BagItemIndex].name:setEnableStroke(true)
	self.m_tBagItemTitle[self.m_n_BagItemIndex].name:setStrokeSize(4)
	self.m_tBagItemTitle[self.m_n_BagItemIndex].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))

	self:setShowItemList(self.m_n_BagItemIndex)
	for i=1, nMaxStoneNum do
		self.m_tStoneQualityChip[i] = GetElement(self.m_StoneContainer2,"chip"..i,WZUIImage)
		self.m_tStoneQualityChip[i]:setGrayRender(true)
		self.m_tImgPosStone[i] = GetElement(self.m_StoneContainer2,"imgPosStone"..i,WZUIImage)
		self.m_tCellMainStoneRedPoint[i] = GetElement(self.m_StoneContainer2,"stoneRedPoint"..i,WZUIImage)
		local btnTest = GetElement(self.m_StoneContainer2, "btn"..i, WZUIButton)
	    local act = CCSkewTo:create(0.05, 22, 22)
	    btnTest:runAction(act)
	end
	--副石的信息
	local goods_con = GetElement(self.m_sStoneContainer1,"goods_con",WZUIContainer)
	for i=1,5 do
		local tab = {}
		tab.item = GetElement(goods_con,"item_"..i,WZUIContainer)
		tab.choose_quality = GetElement(tab.item,"choose_quality",WZUIContainer)
		tab.imgAccStoneRedpoint = GetElement(tab.choose_quality,"imgAccStone",WZUIImage)
		tab.txtAttrType = GetElement(tab.item,"txtAttrType",WZUILabelTTF)
		tab.goods_con = GetElement(tab.item,"goods_con",WZUIContainer)
		tab.txtQuality = GetElement(tab.item,"txtQuality",WZUILabelTTF)
		self.m_tStonePutOnTypeItem[i] = tab
	end
end
--碎片资源 的切换或激活
--[[
pos   1~8
quality 1-4
]]
-- 1=绿色品质，2=蓝色品质，3=紫色，4=橙色
function WndMountStone:setChangeChipStatus(status, pos, quality)
	pos = pos or 1
	quality = quality or 1
	if not self.m_tStoneQualityChip[pos] then return end
	
	local str_name = {"zq_lv_0","zq_lan_0","zq_zi_0","zq_huang_0"}
	local str = string.format("ui/mountstone/%s%d.png",str_name[quality], pos)
	self.m_tStoneQualityChip[pos]:setFile(str)
	self.m_tStoneQualityChip[pos]:setGrayRender(status)
end
--右边的信息切换
function WndMountStone:onBtnBagItemChange(element)
	local tag = element:getTag()
	if self.m_n_BagItemIndex == tag then return end

	self:setShowItemList(tag)
end
function WndMountStone:setShowItemList(index)
	if self.m_tBagItemTitle[self.m_n_BagItemIndex] then
		self.m_tBagItemTitle[self.m_n_BagItemIndex].normal:setVisible(true)
		self.m_tBagItemTitle[self.m_n_BagItemIndex].select:setVisible(false)
		self.m_tBagItemTitle[self.m_n_BagItemIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
		self.m_tBagItemTitle[self.m_n_BagItemIndex].name:setEnableStroke(false)
	end
	if self.m_tBagItemTitle[index] then
		self.m_tBagItemTitle[index].normal:setVisible(false)
		self.m_tBagItemTitle[index].select:setVisible(true)
		self.m_tBagItemTitle[index].name:setColor(GlobalMethod:ccc3(255,236,193))
		self.m_tBagItemTitle[index].name:setEnableStroke(true)
		self.m_tBagItemTitle[index].name:setStrokeSize(4)
		self.m_tBagItemTitle[index].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
	end
	GetElement(self.m_sRightContainer,"itemTableContainer1",WZUITableContainer):setVisible(index == 1)
	GetElement(self.m_sRightContainer,"itemTableContainer2",WZUITableContainer):setVisible(index == 2)

	self.m_n_BagItemIndex = index
	if self.m_tOpenView[index] == true then return end
	self.m_tOpenView[index] = true

	local itemTableContainer = GetElement(self.m_root,"itemTableContainer"..index, WZUITableContainer)
	itemTableContainer:cleanTable()

	if index == 1 then
		self:setAllMainStone(itemTableContainer)
	elseif index == 2 then
		if next(self.m_tStoneSourceBagData) == nil then
			ShowPanelNullTip( itemTableContainer, LocalStrings.FRIENDS_SEND_TIP_3, ccc3(127,70,26))
		else
			self:setShowSourceStoneList()
		end
	end
end
--显示灵石之源的时候
function WndMountStone:setShowSourceStoneList()
	if not self.m_sRightContainer then return end

	local itemTableContainer2 = GetElement(self.m_sRightContainer,"itemTableContainer2",WZUITableContainer)
	itemTableContainer2:cleanTable()
	self.m_tStoneSourceBagData = self:getSourceStoneData()
	if next(self.m_tStoneSourceBagData) == nil then
		ShowPanelNullTip( itemTableContainer2, LocalStrings.FRIENDS_SEND_TIP_3, ccc3(127,70,26))
	else
		function sortFunc(a, b)
			if a.extraInfo.spriteStoneQuality and b.extraInfo.spriteStoneQuality then
				if a.id == b.id then
					return a.extraInfo.spriteStoneQuality > b.extraInfo.spriteStoneQuality
				else
					return a.id < b.id
				end
			else
				return a.id < b.id
			end
		end
		table.sort(self.m_tStoneSourceBagData, sortFunc)
		self.m_tCellSourceStone = {}
		for i=1, #self.m_tStoneSourceBagData do
			local cellElement,tCell = CellGoodItem:createElement()
			cellElement:setTag(i-1)
			itemTableContainer2:setCellElement(cellElement)
			tCell:setCellGoodItem(self.m_tStoneSourceBagData[i], 2)
			if self.m_tStoneSourceBagData[i].subtype ~= 14 then
				tCell:setVisibleItemCount(self.m_tStoneSourceBagData[i].extraInfo.spriteStoneQuality)
				tCell:clearItemQualityPic(nil, self.m_tStoneSourceBagData[i].extraInfo.spriteStoneQuality)
			end
			tCell:setItemClickFun(self,self.onItemClick1)
			self.m_tCellSourceStone[self.m_tStoneSourceBagData[i].playerItemId] = tCell
		end
	end
end
--@brief	查看属性按钮回调
function WndMountStone:onBtnStoneAttr(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local conTips = GetElement(WndPets.m_root,"conTips_WndPets",WZUIContainer)
	WndTips:show(element,conTips,71,{mountStone = 1},GlobalMethod:ccp(0,-140),true)
end
--显示主石的全部item
function WndMountStone:setAllMainStone(node)
	if not node then return end

	removeShowPanelNullTip(node)
	if next(self.m_tStoneBagData) == nil then
		ShowPanelNullTip( node, LocalStrings.FRIENDS_SEND_TIP_3, ccc3(127,70,26))
	else
		function sortFunc(a, b)
			if a.isUse == false and b.isUse == true then
				return false
			elseif a.isUse == true and b.isUse == false then
				return true
			elseif a.isUse == true and b.isUse == true then
				if a.basicInfo.quality and b.basicInfo.quality then
					return a.basicInfo.quality > b.basicInfo.quality
				end
			elseif a.isUse == false and b.isUse == false then
				if a.basicInfo.quality and b.basicInfo.quality then
					if a.basicInfo.quality == b.basicInfo.quality then
						return a.basicInfo.id < b.basicInfo.id
					else
						return a.basicInfo.quality > b.basicInfo.quality
					end
				end
			else
				return a.subtype < b.subtype
			end
		end
		table.sort(self.m_tStoneBagData, sortFunc)
		for i=1, #self.m_tStoneBagData do
			local cellElement,tCell = CellGoodItem:createElement()
			cellElement:setTag(i-1)
			node:setCellElement(cellElement)
			tCell:setCellGoodItem(self.m_tStoneBagData[i], 1)
			self.m_tMainStoneCellItem[self.m_tStoneBagData[i].playerItemId] = tCell
			tCell:setWear(self.m_tStoneBagData[i].isUse)
			tCell:setItemClickFun(self,self.onItemClick)
		end
	end
	self:setShowItemList(1)
end
function WndMountStone:onItemClick(tCell,tag,tData)
	local itemTableContainer = GetElement(self.m_sRightContainer,"itemTableContainer1",WZUITableContainer)
	if not tData then return end
 	WndTips:show(itemTableContainer,WndMountStone.m_root,72,tData,ccp(-45,0), false)
end
function WndMountStone:onItemClick1(tCell,tag,tData)
	if tData == nil then
		return
	end
	WndItemInfo:onCloseClick()
	local conTips = GetElement(WndPets.m_root,"conTips_WndPets",WZUIContainer)
	WndItemInfo:showInfo(tCell.m_root,conTips,1,tData,true,nil,true)
end
--点击的方位
function WndMountStone:onBtnOperate(element)
	local tag = element:getTag()
	local status,level1,level2 = self:setUnLockTips(tag)
	if status == true then
		MsgBoxManager:showTipBox(string.format(LocalStrings.MOUNTSTONE_TEXT21,level1,level2))
		return
	end
	self.m_sStoneContainer1:setVisible(true)
	self.m_StoneContainer2:setVisible(false)

	self.m_nCurTouchStoneIndex = tag
	self:setChangeStoneMessage(self.m_nCurTouchStoneIndex)

	self:setSourceStoneRedPoint(tag)
end
--等级解锁提示
function WndMountStone:setUnLockTips(index)
	local data = CacheCenter:getMountStoneList()
	local totle_level = 0
	for i,v in pairs(data) do
		if v.isUse == true then
			totle_level = totle_level + v.extraInfo.strongLevel
		end
	end
	local spriteStoneUnlock = CacheCenter:getGameParam().spriteStoneUnlock
	if spriteStoneUnlock then
		local pos, level = SplitItemString(spriteStoneUnlock)
		local unLockLevel = {}
		for i=1, #pos do
			unLockLevel[tonumber(pos[i])] = tonumber(level[i])
		end
		if totle_level >= unLockLevel[index] then
			return false,0,0
		else
			return true,unLockLevel[index], totle_level
		end
	else
		return false,0,0
	end
end

function WndMountStone:btnClickLeft()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurTouchStoneIndex <= 1 then
		GetElement(self.m_root,"btnLeft",WZUIButton):setVisible(false)
		return
	end
	self.m_nCurTouchStoneIndex = self.m_nCurTouchStoneIndex - 1
	local data = self.m_tMountStoneBaseData[self.m_nCurTouchStoneIndex]
	if not data then return end
	local status,level1,level2 = self:setUnLockTips(self.m_nCurTouchStoneIndex)
	if status == true then
		MsgBoxManager:showTipBox(string.format(LocalStrings.MOUNTSTONE_TEXT21,level1,level2))
		self.m_nCurTouchStoneIndex = self.m_nCurTouchStoneIndex + 1
		return
	end
	
	self:setChangeStoneMessage(self.m_nCurTouchStoneIndex)
end
function WndMountStone:btnClickRight()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurTouchStoneIndex >= nMaxStoneNum then
		GetElement(self.m_root,"btnRight",WZUIButton):setVisible(false)
		return
	end
	self.m_nCurTouchStoneIndex = self.m_nCurTouchStoneIndex + 1
	local data = self.m_tMountStoneBaseData[self.m_nCurTouchStoneIndex]
	if not data then return end
	local status,level1,level2 = self:setUnLockTips(self.m_nCurTouchStoneIndex)
	if status == true then
		MsgBoxManager:showTipBox(string.format(LocalStrings.MOUNTSTONE_TEXT21,level1,level2))
		self.m_nCurTouchStoneIndex = self.m_nCurTouchStoneIndex - 1
		return
	end
	
	self:setChangeStoneMessage(self.m_nCurTouchStoneIndex)
end
--主石的品质底部颜色
function WndMountStone:setMainStoneQuality(data)
	local imgMainStoneQuality = GetElement(self.m_sStoneContainer1,"imgMainStoneQuality",WZUIImage)
	if data.item_id then
		local info = GDatatab_item["id_"..data.item_id]
		if info then
			imgMainStoneQuality:setFile(g_tShopItemQuality[info.quality])
		end
	end
end
--is_dir 是否是点击左右的时候
function WndMountStone:setChangeStoneMessage(index)
	for i=1,8 do
		self.m_tTxtAttrRich[i]:setVisible(false)
	end
	GetElement(self.m_sStoneContainer1,"txtSpecialDesc",WZUILabelTTF):setVisible(false)
	local btnLeft = GetElement(self.m_root,"btnLeft",WZUIButton)
	btnLeft:setVisible(true)
	local btnRight = GetElement(self.m_root,"btnRight",WZUIButton)
	btnRight:setVisible(true)
	if index >= 8 then
		btnRight:setVisible(false)
	elseif index <= 1 then
		btnLeft:setVisible(false)
	end
	local imgStone = GetElement(self.m_sStoneContainer1,"imgStone",WZUIImage)
	imgStone:setVisible(false)

	self:setStoneBagData(index)
	local data = self.m_tMountStoneBaseData[index]
	if not data then return end
	--未开启主石的提示
	local txtNotPutStone = GetElement(self.m_sStoneContainer1,"txtNotPutStone",WZUILabelTTF)
	txtNotPutStone:setVisible(false)

	self:setMainStoneStoneRedPoint()
	if next(data.ass_message) ~= nil then
		table.sort( data.ass_message, function(a,b) return a.propertyType < b.propertyType end)
		self:setShowItemList(2)
	else
		self:setShowItemList(1)
	end
	for i=1,5 do
		if data.ass_message[i] then
			self.m_tStonePutOnTypeItem[i].item:setVisible(true)
			self.m_tStonePutOnTypeItem[i].choose_quality:setVisible(true)
			self.m_tStonePutOnTypeItem[i].goods_con:setVisible(false)
			if data.ass_message[i].propertyType == 0 then
				self.m_tStonePutOnTypeItem[i].txtAttrType:setText(LocalStrings.MOUNTSTONE_TEXT27)
			else
				self.m_tStonePutOnTypeItem[i].txtAttrType:setText(ATTR_TITLE[tonumber(data.ass_message[i].propertyType)])
			end
			local quality = 0
			local source_data = CacheCenter:getMountStoneSourceList()
			for m,v in pairs(source_data) do
				if v.playerItemId == data.ass_message[i].playerItemId then
					quality = v.extraInfo.spriteStoneQuality
					break
				end
			end			
			self:setSlotStonePutRemove(i, data.ass_message[i].itemId, quality, data.ass_message[i].playerItemId)
		else
			self.m_tStonePutOnTypeItem[i].item:setVisible(false)
		end
	end
	--副石的红点
	self:setCheckAccRedPoint(data)

	if data.is_open == true then
		txtNotPutStone:setVisible(true)
		return
	end
	self:_getPropertyData(data, data.playerItemId)
	if data.item_id then
		local info = GDatatab_item["id_"..data.item_id]
		if info then
			imgStone:setVisible(true)
			imgStone:setFile(info.icon)
		end
	end
	self:setMainStoneQuality(data)
end
--主石的显示
function WndMountStone:setStoneBagData(index)
	index = index or 1
	local itemTableContainer = GetElement(self.m_sRightContainer,"itemTableContainer1",WZUITableContainer)
	itemTableContainer:cleanTable()
	local table_insert = table.insert

	local bag_data = {}
	for i,v in pairs(self.m_tStoneBagData) do
		if v.subtype == index then
			table_insert(bag_data, v)
		end
	end

	if next(bag_data) == nil then
		ShowPanelNullTip( itemTableContainer, LocalStrings.FRIENDS_SEND_TIP_3, ccc3(127,70,26))
	else
		function sortFunc(a, b)
			if a.isUse == false and b.isUse == true then
				return false
			elseif a.isUse == true and b.isUse == false then
				return true
			elseif a.isUse == true and b.isUse == true then
				if a.basicInfo.quality and b.basicInfo.quality then
					return a.basicInfo.quality > b.basicInfo.quality
				end
			elseif a.isUse == false and b.isUse == false then
				if a.basicInfo.quality and b.basicInfo.quality then
					if a.basicInfo.quality == b.basicInfo.quality then
						return a.basicInfo.id < b.basicInfo.id
					else
						return a.basicInfo.quality > b.basicInfo.quality
					end
				end
			else
				return a.subtype < b.subtype
			end
		end
		table.sort(bag_data, sortFunc)
		for i=1, #bag_data do
			local cellElement,tCell = CellGoodItem:createElement()
			cellElement:setTag(i-1)
			itemTableContainer:setCellElement(cellElement)
			tCell:setCellGoodItem(bag_data[i], 1)
			self.m_tMainStoneCellItem[bag_data[i].playerItemId] = tCell
			tCell:setWear(bag_data[i].isUse)
			tCell:setItemClickFun(self,self.onItemClick)
		end
	end
end

--拆除
function WndMountStone:onBtnRemove()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local data = self.m_tMountStoneBaseData[self.m_nCurTouchStoneIndex]
	if not data then return end
	if next(data.ass_message) == nil then
		MsgBoxManager:showTipBox(LocalStrings.MOUNTSTONE_TEXT16)
		return
	end

	ProtocolProcessorScenePets:send_MOUNTS_EquipMasterStone(data.playerItemId, self.m_nCurTouchStoneIndex, 2)
end
--强化
function WndMountStone:onBtnStong()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local data = self.m_tMountStoneBaseData[self.m_nCurTouchStoneIndex]
	if next(data.ass_message) == nil then 
		MsgBoxManager:showTipBox(LocalStrings.MOUNTSTONE_TEXT19)
		return 
	end
	WndMountStoneStong:showInterface(data.item_id, data.playerItemId)
end
--主界面
function WndMountStone:onBtnStongMain()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_sStoneContainer1:setVisible(false)
	self.m_StoneContainer2:setVisible(true)

	local itemTableContainer = GetElement(self.m_root,"itemTableContainer1", WZUITableContainer)
	itemTableContainer:cleanTable()
	self:setAllMainStone(itemTableContainer)

	self.m_nCurTouchStoneIndex = nil
	for i,v in pairs(self.m_tStonePutOnTypeItem) do
		if v and v.item then
			v.item:setVisible(false)
		end
	end
end

--副石选择
function WndMountStone:onBtnChooseStone( element )
	self:setShowItemList(2)

	local tag = element:getTag()
	local data = self.m_tMountStoneBaseData[self.m_nCurTouchStoneIndex]
	if not data then return end
	local playerItemId = nil
	if data.ass_message[tag].propertyType == 0 then
		local temp_quality = 0
		for i,v in pairs(self.m_tStoneSourceBagData) do
			if v.subtype ~= 14 then
				if v.basicInfo.quality > temp_quality then
					temp_quality = v.basicInfo.quality
					playerItemId = v.playerItemId
				end
			end
		end
	else
		playerItemId = self:getAutoInlayStone(data.ass_message[tag].propertyType)
	end
	if next(self.m_tStoneSourceBagData) == nil or playerItemId == nil then
		MsgBoxManager:showTipBox(LocalStrings.MOUNTSTONE_TEXT15)
		return
	end
	if playerItemId then
		if self.m_tUseAccStoneData[playerItemId] == true then
			MsgBoxManager:showTipBox(LocalStrings.MOUNTSTONE_TEXT28)
		else
			self.m_tUseAccStoneData[playerItemId] = true
			ProtocolProcessorScenePets:send_MOUNTS_EquipSlaveStone(playerItemId, data.ass_message[tag].slot, self.m_nCurTouchStoneIndex, 1)
		end
	end
end
-- 自动镶嵌符合属性类型的最高品质的灵石之源
function WndMountStone:getAutoInlayStone(_type)
	local data = {}
	for i,v in pairs(self.m_tStoneSourceBagData) do
		if v and v.basicInfo and v.basicInfo.property[1][1] == _type then
			local tab = {}
			tab.quality = v.basicInfo.quality
			tab.playerItemId = v.playerItemId
			table.insert(data, tab)
		end
	end
	local playerItemId = nil
	if next(data) ~= nil then
		table.sort(data, function(a,b) return a.quality > b.quality end)
		playerItemId = data[1].playerItemId
	end
	return playerItemId
end

--点击tips时候装备副石
function WndMountStone:_onStoneSlotPutonResult(slot_data)
	if not self.m_nCurTouchStoneIndex then
		MsgBoxManager:showTipBox(LocalStrings.MOUNTSTONE_TEXT23)
		return
	end
	--灵石无对应的属性词条
	local data = self.m_tMountStoneBaseData[self.m_nCurTouchStoneIndex]
	if not data then return end
	if next(data.ass_message) == nil then
		MsgBoxManager:showTipBox(LocalStrings.MOUNTSTONE_TEXT14)
		return
	end
	local match_pos = nil --匹配的位置(此位置唯一的,因为每一个灵石之源只存在一个方位可镶嵌)
	for i,v in pairs(slot_data.extraInfo) do
		if type(tonumber(i)) == "number" then
			match_pos = tonumber(i)
			break
		end
	end
	--当前主石是否有这个位置
	local slot_pos = nil
	local match_status = false
	if match_pos ~= nil then
		for i=1,#data.ass_message do
			if data.ass_message[i].itemId == 0 then --只寻找空的位置
				if data.ass_message[i].propertyType == 0 then --如果存在任意石头的时候
					match_status = true
				end
				if data.ass_message[i].propertyType == match_pos then --从副石中寻找匹配
					slot_pos = data.ass_message[i].slot
					break
				end
			end
		end
		if slot_pos == nil and match_status == true then --只能去任意框的时候
			local random_pos = nil
			for i=1,#data.ass_message do
				if data.ass_message[i].itemId == 0 and data.ass_message[i].propertyType == 0 then
					random_pos = data.ass_message[i].slot
					break
				end
			end
			ProtocolProcessorScenePets:send_MOUNTS_EquipSlaveStone(slot_data.playerItemId, random_pos, self.m_nCurTouchStoneIndex, 1)
			return
		end
	end
	if slot_pos == nil then
		--如果全部装满的时候，就有可能存在替换的情况
		--先寻找相同的类型石头,没有的话就去弄任意的，都没有就提示
		local ass_slot = nil
		local put_pos = nil
		for i=1,#data.ass_message do
			if data.ass_message[i].propertyType == 0 then
				put_pos = data.ass_message[i].slot
			end
			if data.ass_message[i].propertyType == match_pos then
				ass_slot = data.ass_message[i].slot
				break
			end
		end
		if ass_slot == nil then --没有的时候寻找任意的
			if put_pos then
				ProtocolProcessorScenePets:send_MOUNTS_EquipSlaveStone(slot_data.playerItemId, put_pos, self.m_nCurTouchStoneIndex, 1)
				return
			end
		else
			ProtocolProcessorScenePets:send_MOUNTS_EquipSlaveStone(slot_data.playerItemId, ass_slot, self.m_nCurTouchStoneIndex, 1)
			return
		end

		local str = ""
		for i=1,#data.ass_message do
			local temp_str = ATTR_TITLE[data.ass_message[i].propertyType]
			if data.ass_message[i].propertyType == 0 then
				temp_str = LocalStrings.MOUNTSTONE_TEXT27
			end
			str = str .. temp_str .." "
		end
		MsgBoxManager:showTipBox(string.format(LocalStrings.MOUNTSTONE_TEXT24, str))
		return
	end
	
	ProtocolProcessorScenePets:send_MOUNTS_EquipSlaveStone(slot_data.playerItemId, slot_pos, self.m_nCurTouchStoneIndex, 1)
end
--副石的装嵌处理 playerItemId 副石的id
function WndMountStone:setSlotStonePutRemove(pos, ass_itemId, quality, playerItemId)
	if self.m_tStonePutOnTypeItem[pos] then
		if ass_itemId ~= 0 then
			self.m_tStonePutOnTypeItem[pos].txtQuality:setText(quality)
			local info = GDatatab_item["id_"..ass_itemId]
			if info then
				self.m_tStonePutOnTypeItem[pos].choose_quality:setVisible(false)
				self.m_tStonePutOnTypeItem[pos].goods_con:setVisible(true)
				
				if self.m_tSlotCellItem[pos] == nil then
					local celElement,tLuaObj = CellGoodItem:createElement()
					celElement:setTag(pos-1)
					self.m_tStonePutOnTypeItem[pos].goods_con:addChild(celElement)
					self.m_tSlotCellItem[pos] = tLuaObj
				end
				local index = nil
				local source_data = CacheCenter:getMountStoneSourceList()
				for i, v in pairs(source_data) do
					if v.playerItemId == playerItemId then
						index = i
						break
					end
				end
				if index then
					self.m_tSlotCellItem[pos]:setItemClickFun(self,self.onSlotItemClick)
					self.m_tSlotCellItem[pos]:setCellGoodItem(source_data[index], 2)
					self.m_tSlotCellItem[pos]:clearItemQualityPic(nil, source_data[index].extraInfo.spriteStoneQuality)
				end
			end
		end
	end
end

function WndMountStone:onSlotItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    local conTips = GetElement(WndPets.m_root,"conTips_WndPets",WZUIContainer)
	WndItemInfo:showInfo(tCell.m_root,conTips,1,tData,true,nil,true,{mountStone = true})
end
--拆除灵石
function WndMountStone:_onStoneSlotRemoveResult(slot_data)
	self:setShowItemList(2)
	local data = self.m_tMountStoneBaseData[self.m_nCurTouchStoneIndex]
	if not data then return end
    local index = nil
    for i=1,#data.ass_message do
    	if data.ass_message[i].playerItemId == slot_data.playerItemId then
    		index = data.ass_message[i].slot
    		break
    	end
    end
    if index then
		ProtocolProcessorScenePets:send_MOUNTS_EquipSlaveStone(slot_data.playerItemId, index, self.m_nCurTouchStoneIndex, 2)
	end
end
function WndMountStone:onBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  	WndSingleMapDesc:showInterface(LocalStrings.MOUNTSTONE_TEXT26)
end
function WndMountStone:onBtnJumpSummon()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSummonEntrance:showInterface(5)
	WndPets:onClose()
end

--=========== 处理红点 start ====================
--主石的红点
function WndMountStone:setMainStoneStoneRedPoint()
	local status = false
	for i=1, #self.m_tMainStoneRedpointData do
		if self.m_tMainStoneRedpointData[i] == true then
			status = true
			break
		end
	end
	GetElement(self.m_root,"imgAllStoneRedPoint",WZUIImage):setVisible(status)
	local btnMountStone = GetElement(WndPets.m_root,"btnMountStone2_WndPets",WZUIButton)
    SceneCity:setRedPoint(btnMountStone, status, GlobalMethod:ccp(135,55))
    GlobalGame.g_tRedPointList.mountstone_redpoint = status
end
--副石的红点会计算出外面主石的红点
function WndMountStone:setAccStoneRedPoint(data, pos)
	if next(data) == nil then return end

	local main_redpoint = false
	local source_data = self:getSourceStoneData()

	for i=1, #data.ass_message do
		local _type = tonumber(data.ass_message[i].propertyType)
		if data.ass_message[i].itemId == 0 then
			for m,v in pairs(source_data) do
				if v.subtype ~= 14 and (v.subtype >= 8 and v.subtype <= 13) then
					if _type == 0 then
						main_redpoint = true
						break
					elseif tonumber(v.basicInfo.property[1][1]) == _type then
						main_redpoint = true
						break
					end
				end
			end
		end
	end
	self.m_tMainStoneRedpointData[pos] = main_redpoint
	self.m_tCellMainStoneRedPoint[pos]:setVisible(main_redpoint)
end
--查看主石里面的副石红点的时候
function WndMountStone:setCheckAccRedPoint(data)
	if not data or next(data) == nil then return end
	table.sort( data.ass_message, function(a,b) return a.propertyType < b.propertyType end)
	
	local source_data = self:getSourceStoneData()
	for i=1, #data.ass_message do
		local redpoint_status = false
		local _type = tonumber(data.ass_message[i].propertyType)
		if data.ass_message[i].itemId == 0 then
			for m,v in pairs(source_data) do
				if v.subtype ~= 14 and (v.subtype >= 8 and v.subtype <= 13) then
					if _type == 0 then
						redpoint_status = true
						break
					elseif tonumber(v.basicInfo.property[1][1]) == _type then
						redpoint_status = true
						break
					end
				end
			end
		end
		self.m_tStonePutOnTypeItem[i].imgAccStoneRedpoint:setVisible(redpoint_status)
	end
end
--灵石之源红点
function WndMountStone:setSourceStoneRedPoint(index)
	-- local imgSourceStoneRedPoint = GetElement(self.m_root,"imgSourceStoneRedPoint",WZUIImage)
	-- --先判断进入主石的位置
	-- --self.m_nCurTouchStoneIndex
	-- local stone_data = self.m_tMountStoneBaseData[index]
	-- if next(stone_data.ass_message) == nil then return end

	-- for i,v in pairs(self.m_tCellSourceStone) do
	-- 	if v then
	-- 		v:setItemRedPoint(false)
	-- 	end
	-- end
	-- local source_data = self:getSourceStoneData()
	-- for i=1,#stone_data.ass_message do
	-- 	for k,v in pairs(source_data) do
	-- 		if stone_data.ass_message[i].itemId == 0 then
	-- 			local propertyType = stone_data.ass_message[i].propertyType
	-- 			if v.subtype >= 9 and v.subtype <= 13 then
	-- 				local _status = false
	-- 				for _m, _v in pairs(v.extraInfo) do
	-- 					if type(tonumber(_m)) == "number" and tonumber(_m) == propertyType then
	-- 						_status = true
	-- 						break
	-- 					end
	-- 				end
	-- 				self.m_tCellSourceStone[v.playerItemId]:setItemRedPoint(_status)
	-- 			end
	-- 		else
				
	-- 		end
			
	-- 	end
	-- end
	-- self:getSourceStoneData()

end
	
--=========== 处理红点 end ====================
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndMountStone:_onPetMountBaseInfo(masterSlot, masterItemId, slaveStoneData)
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
		if tab.item_id and tab.item_id ~= 1 then
			self.m_tImgPosStone[masterSlot[i]]:setVisible(true)
			local info = GDatatab_item["id_"..tab.item_id]
			if info then
				self.m_tImgPosStone[masterSlot[i]]:setFile(info.icon)
			end
		end
		self.m_tMountStoneBaseData[masterSlot[i]] = tab
	end
	self.m_tStoneSourceBagData = self:getSourceStoneData()
	for i=1, nMaxStoneNum do
		self:setAccStoneRedPoint(self.m_tMountStoneBaseData[i], i)
		self:setChangeChipStatus(self.m_tMountStoneBaseData[i].is_open, i, self.m_tMountStoneBaseData[i].quality)
	end
	self:setMainStoneStoneRedPoint()
end
-- 根据playerid获取品质
function WndMountStone:_getQuality(itemId)
	if itemId == 0 then
		return 1
	end
	for i,v in pairs(self.m_tStoneBagData) do
		if v.playerItemId == itemId then
			return v.basicInfo.quality
		end
	end
end
-- 根据playerid获取物品id
function WndMountStone:_getItemId(itemId)
	if itemId == 0 then
		return 1
	end
	for i,v in pairs(self.m_tStoneBagData) do
		if v.playerItemId == itemId then
			return v.basicInfo.id
		end
	end
end
--根据物品属性取副本id
function WndMountStone:_getAssistId( propertyType )
	local item_id = 0
	for i,v in pairs(self.m_tStoneBagData) do
		if v.basicInfo.property[1][1] == propertyType then
			return v.basicInfo.id
		end
	end
	return item_id
end
--镶嵌和移除
-- 1、镶嵌，2、拆卸
function WndMountStone:_onStonePutOnResult(_type, data)
	if data.isUse == true then
		MsgBoxManager:showTipBox(LocalStrings.IN_USE)
		return
	end
	local status,level1,_ = self:setUnLockTips(data.subtype)
	if status == true then
		MsgBoxManager:showTipBox(string.format(LocalStrings.MOUNTSTONE_TEXT22,level1))
		return
	end
	ProtocolProcessorScenePets:send_MOUNTS_EquipMasterStone(data.playerItemId, data.subtype, 1)
end
--装备和拆卸 主石
function WndMountStone:_onStoneMainSlotResult(playerItemId, slot, slaveSlot, slaveItemId, propertyType, onOff)
	WndItemInfo:_onCloseClick()
	local txtNotPutStone = GetElement(self.m_sStoneContainer1,"txtNotPutStone",WZUILabelTTF)
	local imgStone = GetElement(self.m_sStoneContainer1,"imgStone",WZUIImage)
	imgStone:setVisible(false)
	local temp_data = self.m_tMountStoneBaseData[self.m_nCurTouchStoneIndex]
	--如果存在镶嵌副石的时候切换，就要把副石先拆下来
	if temp_data then
		for i=1,#temp_data.ass_message do
			self.m_tUseAccStoneData[temp_data.ass_message[i].playerItemId] = nil
		end
	end
	for i=1, 5 do
		self.m_tStonePutOnTypeItem[i].item:setVisible(false)
	end
	if onOff == 1 then --安装成功
		MsgBoxManager:showTipBox(LocalStrings.MOUNTSTONE_TEXT17)
		txtNotPutStone:setVisible(false)
		if self.m_tStoneQualityChip[slot] then
			self.m_tStoneQualityChip[slot]:setGrayRender(false)
		end
		local tab = {}
		tab.playerItemId = playerItemId
		tab.quality = self:_getQuality(playerItemId)
		tab.item_id = self:_getItemId(playerItemId)
		--副槽类型
		local temp_tab = {}
		for i=1,#slaveSlot do
			local tab1 = {}
			tab1.itemId = 0
			tab1.propertyType = propertyType[i]
			tab1.playerItemId = slaveItemId[i]
			tab1.slot = slaveSlot[i]
			temp_tab[slaveSlot[i]+1] = tab1
		end
		tab.ass_message = temp_tab
		self.m_tMountStoneBaseData[slot] = tab

		local info = GDatatab_item["id_"..tab.item_id]
		if info then
			imgStone:setVisible(true)
			imgStone:setFile(info.icon)
			self.m_tImgPosStone[slot]:setVisible(true)
			self.m_tImgPosStone[slot]:setFile(info.icon)
		end
		self:setMainStoneQuality(self.m_tMountStoneBaseData[slot])
		if next(self.m_tMountStoneBaseData[slot].ass_message) ~= nil then
			table.sort( self.m_tMountStoneBaseData[slot].ass_message, function(a,b) return a.propertyType < b.propertyType end)
		end
		for i=1,#slaveSlot do
			if self.m_tStonePutOnTypeItem[i] then
				self.m_tStonePutOnTypeItem[i].item:setVisible(true)
				local slot_data = self.m_tMountStoneBaseData[slot].ass_message[i]
				if slot_data then
					if slot_data.itemId == 0 then
						self.m_tStonePutOnTypeItem[i].choose_quality:setVisible(true)
						self.m_tStonePutOnTypeItem[i].goods_con:setVisible(false)
						if slot_data.propertyType == 0 then
							self.m_tStonePutOnTypeItem[i].txtAttrType:setText(LocalStrings.MOUNTSTONE_TEXT27)
						else
							self.m_tStonePutOnTypeItem[i].txtAttrType:setText(ATTR_TITLE[tonumber(slot_data.propertyType)])
						end
					end
				end
			end
		end
		self:setChangeChipStatus(false, slot, tab.quality)
	elseif onOff == 2 then --拆卸
		MsgBoxManager:showTipBox(LocalStrings.MOUNTSTONE_TEXT18)
		txtNotPutStone:setVisible(true)
		for i=1,8 do
			self.m_tTxtAttrRich[i]:setVisible(false)
		end
		self.m_tMountStoneBaseData[slot].ass_message = {}
		if self.m_tStoneQualityChip[slot] then
			self.m_tStoneQualityChip[slot]:setGrayRender(true)
		end
	elseif onOff == 3 then --升级之后副石的变化
		self.m_tMountStoneBaseData[slot].ass_message = {}
		local temp_tab = {}
		for i=1,#slaveSlot do
			local tab1 = {}
			tab1.itemId = 0
			tab1.propertyType = propertyType[i]
			tab1.playerItemId = slaveItemId[i]
			tab1.slot = slaveSlot[i]
			temp_tab[slaveSlot[i]+1] = tab1
		end
		self.m_tMountStoneBaseData[slot].ass_message = temp_tab
		
		if next(self.m_tMountStoneBaseData[slot].ass_message) ~= nil then
			table.sort( self.m_tMountStoneBaseData[slot].ass_message, function(a,b) return a.propertyType < b.propertyType end)
		end
		for i=1,#slaveSlot do
			if self.m_tStonePutOnTypeItem[i] then
				self.m_tStonePutOnTypeItem[i].item:setVisible(true)
				local slot_data = self.m_tMountStoneBaseData[slot].ass_message[i]
				if slot_data then
					if slot_data.itemId == 0 then
						self.m_tStonePutOnTypeItem[i].choose_quality:setVisible(true)
						self.m_tStonePutOnTypeItem[i].goods_con:setVisible(false)
						if slot_data.propertyType == 0 then
							self.m_tStonePutOnTypeItem[i].txtAttrType:setText(LocalStrings.MOUNTSTONE_TEXT27)
						else
							self.m_tStonePutOnTypeItem[i].txtAttrType:setText(ATTR_TITLE[tonumber(slot_data.propertyType)])
						end
					end
				end
			end
		end
		imgStone:setVisible(true)
		local item_id = self:_getItemId(playerItemId)
		local info = GDatatab_item["id_"..item_id]
		if info then
			imgStone:setVisible(true)
			imgStone:setFile(info.icon)
		end
		self:setMainStoneQuality(self.m_tMountStoneBaseData[slot])
	end
	self.m_tStoneBagData = CacheCenter:getMountStoneList()
	for i,v in pairs(self.m_tStoneBagData) do
		if self.m_tMainStoneCellItem[v.playerItemId] then
			self.m_tMainStoneCellItem[v.playerItemId]:setCellGoodItem(self.m_tStoneBagData[i], 1)
			self.m_tMainStoneCellItem[v.playerItemId]:setItemClickFun(self,self.onItemClick)
			self.m_tMainStoneCellItem[v.playerItemId]:setWear(self.m_tStoneBagData[i].isUse)
		end
	end
	--刷新灵石之源
	self:setShowSourceStoneList()	
	local data = self.m_tMountStoneBaseData[self.m_nCurTouchStoneIndex]
	self:_getPropertyData(data, playerItemId)

	--红点
	self:setCheckAccRedPoint(data)
	for i=1,8 do
		self:setAccStoneRedPoint(self.m_tMountStoneBaseData[i], i)
	end
	self:setMainStoneStoneRedPoint()
end

--装备和拆卸副石
function WndMountStone:_onStoneSourceAssResult(slaveItemId, slaveSlot, masterItemId, onOff)
	if not self.m_sStoneContainer1 then return end
	local item_id = nil
	local quality = 0
	for i,v in pairs(self.m_tStoneSourceBagData) do
		if v.playerItemId == slaveItemId then
			item_id = v.basicInfo.id
			quality = v.extraInfo.spriteStoneQuality
			break
		end
	end
	local data = self.m_tMountStoneBaseData[self.m_nCurTouchStoneIndex]
	if next(data.ass_message) ~= nil then
		table.sort( data.ass_message, function(a,b) return a.propertyType < b.propertyType end)
	end
	local pos = 1
	for i=1,#data.ass_message do
		if data.ass_message[i].slot == slaveSlot then
			pos = i
			break
		end
	end
	--如果存在的时候然后替换，先把当前的置空
	if data.ass_message[pos] then
		self.m_tUseAccStoneData[data.ass_message[pos].playerItemId] = nil
	end

	if onOff == 1 then --装
		self.m_tUseAccStoneData[slaveItemId] = true
		MsgBoxManager:showTipBox(LocalStrings.MOUNTSTONE_TEXT29)
		self:setSlotStonePutRemove(pos, item_id, quality, slaveItemId)
		data.ass_message[pos].itemId = item_id
		data.ass_message[pos].playerItemId = slaveItemId
	elseif onOff == 2 then --卸
		self.m_tUseAccStoneData[slaveItemId] = nil
		MsgBoxManager:showTipBox(LocalStrings.MOUNTSTONE_TEXT18)
		self.m_tStonePutOnTypeItem[pos].choose_quality:setVisible(true)
		self.m_tStonePutOnTypeItem[pos].goods_con:setVisible(false)
		data.ass_message[pos].itemId = 0
		data.ass_message[pos].playerItemId = 0
	end
	self.m_tStoneBagData = CacheCenter:getMountStoneList()
	for i,v in pairs(self.m_tStoneBagData) do
		if self.m_tMainStoneCellItem[v.playerItemId] then
			self.m_tMainStoneCellItem[v.playerItemId]:setCellGoodItem(self.m_tStoneBagData[i], 1)
			self.m_tMainStoneCellItem[v.playerItemId]:setItemClickFun(self,self.onItemClick)
			self.m_tMainStoneCellItem[v.playerItemId]:setWear(self.m_tStoneBagData[i].isUse)
		end
	end

	self:_getPropertyData(data, masterItemId)
	self:setShowSourceStoneList()
	--红点
	self:setCheckAccRedPoint(data)
	for i=1,8 do
		self:setAccStoneRedPoint(self.m_tMountStoneBaseData[i], i)
	end
	self:setMainStoneStoneRedPoint()
end
--根据物品 data 数据
--[[
data: 副石镶嵌的id，存在多少个就会有几个id过来
]]
function WndMountStone:_getPropertyData(data, playerItemId)
	data = data or {}
	local lev = 0
	local stoneEffect = 0
	for _i2, _v2 in pairs(self.m_tStoneBagData) do
		if playerItemId and _v2.playerItemId == playerItemId then
			lev = _v2.extraInfo.strongLevel
			if _v2.extraInfo.spriteStoneEffect then
				stoneEffect = _v2.extraInfo.spriteStoneEffect
			end
			break
		end
	end
	local txtSpecialDesc = GetElement(self.m_sStoneContainer1,"txtSpecialDesc",WZUILabelTTF)
	txtSpecialDesc:setVisible(true)
	local extra_add = -1 --额外增加
	local info = GDatatab_sprite_stone_effect["id_"..stoneEffect]
	if stoneEffect and stoneEffect ~= 0 then
		if info then
			txtSpecialDesc:setText(info.des)
			if info.value[1][1] ~= 0 and info.type == 1 then
				extra_add = info.value[1][1]
			end
		end
	else
		txtSpecialDesc:setText(LocalStrings.MOUNTSTONE_TEXT10)
	end
	for i=1,8 do
		self.m_tTxtAttrRich[i]:setVisible(false)
	end
	local str = string.format([[<T C="255,236,193" S="20" P="1">%s</T> <T C="229,105,22" S="20" P="1"> %d</T>]],LocalStrings.MOUNT_LEVEL1,lev)
	self.m_tTxtAttrRich[1]:setVisible(true)
	self.m_tTxtAttrRich[1]:setShowText(str)

	data.ass_message = data.ass_message or {}
	if next(data.ass_message) == nil then
	else
		table.sort( data.ass_message, function(a,b) return a.propertyType < b.propertyType end)
		local index = 2
		for i=1, #data.ass_message do
			local str1 = ""
			local source_id = nil
			local source_data = CacheCenter:getMountStoneSourceList()
			for _i1, _v1 in pairs(source_data) do
				if data.ass_message[i].itemId ~= 0 and _v1.playerItemId == data.ass_message[i].playerItemId then
					source_id = _v1.extraInfo.spriteStoneConfigId
					break
				end
			end
			if source_id then
				local source_info = GDatatab_sprite_stone_source["id_"..source_id]
				if source_info then
					--初始属性+成长属性*等级
					local num = source_info.attribute_initial + source_info.attribute_grow * lev
					local str_attr = ATTR_TITLE[tonumber(data.ass_message[i].propertyType)]
					if tonumber(data.ass_message[i].propertyType) == 0 then
						local info = GDatatab_item["id_"..data.ass_message[i].itemId]
						if info and info.property[1] then
							str_attr = ATTR_TITLE[tonumber(info.property[1][1])]
						end
					end
					local extra_str = ""
					local _size = 20
					if extra_add == tonumber(data.ass_message[i].propertyType) then
						extra_str = string.format([[<T C="229,105,22" S="16" P="1">(+%d)</T>]],math.ceil(info.value[1][2]/100*num))
						_size = 16
					end
					str1 = string.format([[<T C="255,236,193" S="20" P="1">%s:</T> <T C="229,105,22" S="%d" P="1">%d</T>%s]], str_attr, _size, num, extra_str)
					self.m_tTxtAttrRich[index]:setVisible(true)
					self.m_tTxtAttrRich[index]:setShowText(str1)
					index = index + 1
				end
			end
		end
	end
end

--灵石升级的显示
function WndMountStone:_onStoneUpgradeResult(playerItemId, lv, exp, consumeItemId, consumeNum)
	if not self.m_sRightContainer then return end
	local itemTableContainer1 = GetElement(self.m_sRightContainer,"itemTableContainer1",WZUITableContainer)
	itemTableContainer1:cleanTable()

	self.m_tStoneBagData = CacheCenter:getMountStoneList()
	self:setStoneBagData(self.m_nCurTouchStoneIndex)

	--灵石之源
	self:setShowSourceStoneList()
	if self.m_nCurTouchStoneIndex then
		local data = self.m_tMountStoneBaseData[self.m_nCurTouchStoneIndex]
		self:_getPropertyData(data, playerItemId)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块begin--------------------------------------
function WndMountStone:_adaptLanguage_vn()
	local right_con = GetElement(self.m_root,"right_con",WZUIContainer)
	local btn1 = GetElement(right_con,"btn1",WZUIButton)
	local name = GetElement(btn1,"name",WZUILabelTTF)
	name:setScale(0.75)
	name:setDimensions(GlobalMethod:CCSize(140,0))
	local btn2 = GetElement(right_con,"btn2",WZUIButton)
	local name = GetElement(btn2,"name",WZUILabelTTF)
	name:setScale(0.75)
	name:setDimensions(GlobalMethod:CCSize(140,0))

	for i=1,8 do
		local txtFreeRich = GetElement(self.m_root,"txtFreeRich"..i,WZUIFreeTextBox)
		txtFreeRich:setScale(0.8)
	end
end
-------------------------------------语言适配模块end--------------------------------------
