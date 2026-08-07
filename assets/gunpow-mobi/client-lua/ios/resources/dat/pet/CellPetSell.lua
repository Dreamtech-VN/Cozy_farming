--CellPetSell.lua
--@brief	CellPetSell的UI模块
--@date		2018/01/25
--@author	zsq
--@note		回收宠物cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPetSell:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPetSell:onExit(element)
	self:_unInit()
end

function CellPetSell:setData(tData)
    self.m_tData = tData
end

function CellPetSell:onClickBegan(element)
	WZLog("CellPetSell:onClickBegan")
	--self.selected = not self.selected
	--GetElement(self.m_root,"conSelect",WZUIContainer):setVisible(self.selected)
	self.onTouch = true
	self.m_root:enableSchedule("showTip",0.5)
end

function CellPetSell:showTip()
	WZLog("CellPetSell:showTip")
    self.m_root:disableSchedule()
	local tData = {}
	setmetatable(tData, {__index = self.m_tData})
	local tItem = GDatatab_item["id_"..tData.itemId]
	tData.quality = tItem.quality
	tData.gift = self.m_tData.giftSkill
	local tProperty = json.decode(self.m_tData.property)
	for i=1,20 do
		tData[tostring(i)] = tProperty[tostring(i)]
	end
	if self.onTouch then
		WndTips:show(self.m_root,WndPetRecover.m_root,13,tData,GlobalMethod:ccp(430,-10))
	end
end

function CellPetSell:onMoveOut(element)
	WZLog("CellPetSell:onMoveOut")
	
end

function CellPetSell:onClickEnd(element)
	WZLog("CellPetSell:onClickEnd")
	self.onTouch = false
	
    if self.selected then
        self:setSelected(false)
        WndPetRecover:addChoicePet(false, self.m_tData)
    else
        local bool,nTag = WndPetRecover:checkPetSpill()
        if bool then
            self.n_Tag = nTag
            WndPetRecover:addChoicePet(true, self.m_tData)
            self:setSelected(true)
        end
    end
end

function CellPetSell:getPetInfo()
    return self.m_tData
end

function CellPetSell:setSelected(bool)
	self.selected = bool
	GetElement(self.m_root,"conSelect",WZUIContainer):setVisible(bool)
end

function CellPetSell:doQuickRecover()
		if self.selected then return end
        if GDatatab_item["id_"..self.m_tData.itemId].quality >= 3 then --不能选择紫宠以上的
            return
        end
        local bool,nTag = WndPetRecover:checkPetSpill()
        if bool then
            self.n_Tag = nTag
            WndPetRecover:addChoicePet(true, self.m_tData)
            self:setSelected(true)
			return true
        end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPetSell:onLoadData(element)
	local cellElement = WZUISystem:getInstance():createElement("CellPetSell")
	assert(cellElement, "CellPetSell cellElement create failed!")
    self.m_root:addChild(cellElement)
	cellElement:setLuaObjectIndex(self)

    GetElement(self.m_root,"imgIconBg_CellPetChoiceList",WZUIImage):setFile(self.m_tData.icon)
    local bg = GetElement(self.m_root,"imgIconBgQuality_CellPetChoiceList",WZUIImage)
    local quality = GDatatab_item["id_"..self.m_tData.itemId].quality
  	local qualtyFile = {"frame_green.png","frame_bule.png","frame_violet.png","frame_orange.png"}
  	local file = "ui/common/"..qualtyFile[quality]
  	bg:setFile(file)
	--宠物星级
   local aptitude = WndPets:getAptitude(self.m_tData.giftSkill)
   GetElement(self.m_root,"star",WZUILabelTTF):setText(aptitude)
   --宠物等级
   GetElement(self.m_root,"lv",WZUILabelTTF):setText(LocalStrings.LV..self.m_tData.upgradeLevel)
end




-------------------------------------私有方法模块End----------------------------------------
