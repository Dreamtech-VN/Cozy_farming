--CellPetEvolution.lua
--@brief	CellPetEvolution的UI模块
--@date		2016/11/14
--@author	zsq
--@note		宠物进化Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPetEvolution:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPetEvolution:onExit(element)
	self:_unInit()
end

function CellPetEvolution:setData(tData)
	self.t_PetInfo = tData
	self:onLoadData()
end

function CellPetEvolution:onClick(element)
	WZLog("CellPetEvolution:onClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.t_PetInfo == nil then return end
	GetElement(WndAscending.m_root,"conPet1_WndAscending",WZUIContainer):setVisible(true)
	GetElement(WndAscending.m_root,"conPet2_WndAscending",WZUIContainer):setVisible(true)
	GetElement(WndAscending.m_root,"arrowTab4",WZUIImage):setVisible(true)
	WndAscending:updateLeftPet(self.t_PetInfo)
	WndAscending:updateRightPet(self.t_PetInfo)
	for i=1,4 do
		WndAscending:setChoosePet(i, false, GDatatab_item["id_"..self.t_PetInfo.itemId].icon)
	end

	for i=1,4 do
		WndAscending["m_tPet"..i] = nil
	end
	WndAscending:setPetCost()
	
	if WndAscending.m_tSelectedPet ~= nil then
		WndAscending.m_tSelectedPet:setState(false)
	end
	self:setState(true)
	WndAscending.m_tSelectedPet = self
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief  设置cell中的内容
--@param  tPetInfo:设置宠物的属性
function CellPetEvolution:onLoadData(element)
    WZLog("CellPetList:setCellAllElement")
    --local cellElement = WZUISystem:getInstance():createElement("CellPetList")
    --self.m_root:addChild(cellElement)
    local tPetInfo = self.t_PetInfo

    GetElement(self.m_root,"imgIconBg_CellPetList",WZUIImage):setFile(tPetInfo.icon)
    local cellElement =  GetElement(self.m_root,"imgIconBgQuality_CellPetList",WZUIImage)
    local quality = GDatatab_item["id_"..tPetInfo.itemId].quality
    WndPets:setIconQuality(cellElement, quality)
    local name = "Lv"..tPetInfo.upgradeLevel.." "..tPetInfo.name
    
    local txtColor = {[["99,255,95"]],[["93,222,254"]],[["198,130,255"]],[["233,166,62"]]}
    local color = txtColor[quality]
    local lv = "+"..tPetInfo.advancedLevel
     if tPetInfo.advancedLevel < 1 then
        lv = ""
    end
    if WndPets:isExpPet(tPetInfo.itemId) then
        lv = ""
    end
    local s0 = WndPets:getTypeById(tPetInfo.itemId)
    local sLevel = string.format([[<I>%s</I><T C=%s S="22" P="1">%s</T><T C="0,255,0" S="22" P="1">%s</T>]],s0, color, name, lv)
    if ProjConfig.LANGUAGE == "hk" then
        sLevel = string.format([[<I>%s</I><T C=%s S="18" P="1">%s</T><T C="0,255,0" S="18" P="1">%s</T>]],s0, color, name, lv)
    end
    local nameText = GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox)
    if nameText ~= nil then
        nameText:setShowText(sLevel)
    end
    if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
        nameText:setScale(0.6)
        nameText:setMaxWidth(500)
    end
    --self:_setWarState(self.t_PetInfo.isInUsed)

    local aptitude = WndPets:getAptitude(self.t_PetInfo.giftSkill)
    for i =1 ,5 do
    	GetElement(self.m_root,"imgAptitude"..i.."_CellPetList",WZUIImage):setVisible(i <= aptitude)
    end
    self:setState(self.choiceState)
    AdaptLanguage(self)
end

function CellPetEvolution:setState(bState)
    WZLog("CellPetEvolution:setState", bState)
    local element =  GetElement(self.m_root,"conSel_CellPetList",WZUIContainer)
    if element == nil then
        self.choiceState = bState
        return
    end
    element:setVisible(bState)
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-----------------------------------------
function CellPetEvolution:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox):setScale(0.7)
end

function CellPetEvolution:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox):setScale(0.6)
end

function CellPetEvolution:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox):setScale(0.7)
end

function CellPetEvolution:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox):setScale(0.65)
end

function CellPetEvolution:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox):setScale(0.65)
end
-------------------------------------语言适配End---------------------------------------------