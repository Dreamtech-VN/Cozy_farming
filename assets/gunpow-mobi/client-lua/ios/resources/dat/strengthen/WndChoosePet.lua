--WndChoosePet.lua
--@brief	WndChoosePet的UI模块
--@date		2016/11/15
--@author	zsq
--@note		选择宠物


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChoosePet:onEnter(element)
	self.m_root = element
end

function WndChoosePet:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAction(element,true)
	self:update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndChoosePet:onExit(element)
	self:_unInit()
end

function WndChoosePet:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root , self , true)
end

function WndChoosePet:onClickSureBtn()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	for i=1,4 do
		WndAscending["m_tPet"..i] = self["m_tPet"..i]
	end
	WndAscending:refreshSelectedPet()
    WindowManager:removeWindow(self.m_root , self , true)
end

function WndChoosePet:onGrid(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	--设置选中状态
    if WndChoosePet["m_tPet"..nTag] ~= nil then
		local tCell
		for i=1,#self.m_tCellList do
			if self.m_tCellList[i].t_PetInfo.playerPetId == WndChoosePet["m_tPet"..nTag].playerPetId then
				tCell = self.m_tCellList[i]
			end
		end
        tCell:_setButtonState(false)
		WndChoosePet["m_tPet"..nTag] = nil
    else
		local tCell
		for i=#self.m_tCellList,1,-1 do
			if self.m_tCellList[i].b_isClick == false then
				tCell = self.m_tCellList[i]
			end
		end
        tCell:_setButtonState(true)
		WndChoosePet["m_tPet"..nTag] = tCell.t_PetInfo
    end
	WndChoosePet:refreshSelectedPet()
end

--去获取宠物
function WndChoosePet:onGetPet(element)
	WZLog("WndChoosePet:onGetPet")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndPetRaffle = WndPetRaffle:createElement()
	WindowManager:addWindow(wndPetRaffle, WndPetRaffle)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndChoosePet:update()
	if self.m_root == nil then return end
	if WndAscending.m_tPet == nil then return end
	local tbconEquip = GetElement(self.m_root,"freecon_WndChoosePet",WZUIFreeListContainer)
	tbconEquip:removeAll()
	--removeShowPanelNullTip(tbconEquip)
	GetElement(self.m_root,"conNoPet_WndChoosePet",WZUIContainer):setVisible(false)
	local tData = GDatatab_item["id_"..WndAscending.m_tPet.itemId]
	self.m_tCellList = {}

	local tDataList = CacheCenter:getPlayerPetInfo()
	for i=1,#tDataList do
		if tDataList[i].itemId == WndAscending.m_tPet.itemId and tDataList[i].playerPetId ~= WndAscending.m_tPet.playerPetId and tDataList[i].upgradeLevel <= 1 then
    		local cellElement, tCell = CellChoosePet:createElement()
    		cellElement = WZUIContainer:luaTo(cellElement)
    		tbconEquip:pushBack(cellElement)
			tCell:setData(tDataList[i])
			table.insert(self.m_tCellList, tCell)
		end
	end
 	local moveElement = tbconEquip:getMoveElement()
 	moveElement:setPositionY(tbconEquip:getMinPosition().y)

	if #self.m_tCellList == 0 then
		--ShowPanelNullTip(tbconEquip)
		GetElement(self.m_root,"conNoPet_WndChoosePet",WZUIContainer):setVisible(true)
	end
	for i=1,4 do
		self:setChoosePet(i, false, tData.icon)
	end
	for i=1,4 do
		if self["m_tPet"..i] ~= nil then
			self:setChoosePet(i, true, tData.icon)
		end
	end
end

function WndChoosePet:checkIsUsed(tData)
	local used = false
	for i=1,4 do
		if WndChoosePet["m_tPet"..i] ~= nil and WndChoosePet["m_tPet"..i].playerPetId == tData.playerPetId then 
			used = true
			break
		end
	end
	return used
end

function WndChoosePet:refreshSelectedPet()
	if WndAscending.m_tPet == nil then return end
	local tData = GDatatab_item["id_"..WndAscending.m_tPet.itemId]
	for i=1,4 do
		self:setChoosePet(i, false, tData.icon)
	end
	--local count = 0
	--for i=1,#self.m_tCellList do
	--	if self.m_tCellList[i].b_isClick == true then
	--		count = count + 1
	--	end
	--end
	--for i=1,count do
	--	self:setChoosePet(i, true, tData.icon)
	--end
	for i=1,4 do
		if self["m_tPet"..i] ~= nil then
			self:setChoosePet(i, true, tData.icon)
		end
	end
end

function WndChoosePet:setChoosePet(index, selected, path)
	if GetElement(self.m_root,"petBg"..index,WZUIImage) == nil then return end
	GetElement(self.m_root,"petBg"..index,WZUIImage):setGrayRender(not selected)
	GetElement(self.m_root,"petGrid"..index,WZUIImage):setGrayRender(not selected)
	GetElement(self.m_root,"imgAdd"..index,WZUIImage):setVisible(not selected)
	GetElement(self.m_root,"pet"..index,WZUIImage):setFile(path)
	GetElement(self.m_root,"pet"..index,WZUIImage):setGrayRender(not selected)
end

-------------------------------------私有方法模块End----------------------------------------
