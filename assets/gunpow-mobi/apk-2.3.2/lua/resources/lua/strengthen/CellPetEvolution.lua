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

function CellPetEvolution:getPetInfo()
    return self.t_PetInfo
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief  设置cell中的内容
--@param  tPetInfo:设置宠物的属性
function CellPetEvolution:onLoadData(element)
    WZLog("CellPetList:setCellAllElement")
    local tPetInfo = self.t_PetInfo

    local icon = string.gsub(tPetInfo.icon, ".png", "_1.png")
    GetElement(self.m_root,"imgIconBg_CellPetList",WZUIImage):setFile(icon)
    local imgQualityRect =  GetElement(self.m_root,"imgQualityRect_CellPetEvolution",WZUI9Image)
    local imgNameBg =  GetElement(self.m_root,"imgNameBg_CellPetEvolution",WZUI9Image)
    local quality = GDatatab_item["id_"..tPetInfo.itemId].quality
    imgQualityRect:setFile(g_tQualityBG[quality])
    imgNameBg:setFile(g_tQualityNameBG[quality])
    --等级
    local txtLv = GetElement(self.m_root, "txtLv_CellPetEvolution", WZUILabelTTF)
    if tPetInfo.upgradeLevel > 0 then 
        txtLv:setText(LocalStrings.LV .. tPetInfo.upgradeLevel)
    else
        txtLv:setText("")
    end
    local name = tPetInfo.name
    
    local lv = "+"..tPetInfo.advancedLevel
    if tPetInfo.advancedLevel < 1 then
        lv = ""
    end
    if WndPets:isExpPet(tPetInfo.itemId) then
        lv = ""
    end
    local txtAdvanceLv = GetElement(self.m_root, "txtAdvanceLv_CellPetEvolution", WZUILabelTTF)
    if txtAdvanceLv then 
        txtAdvanceLv:setText(lv)
    end

    local s0 = WndPets:getTypeById(tPetInfo.itemId)
    local sLevel = string.format([[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]],name)
    if ProjConfig.LANGUAGE == "hk" then
        sLevel = string.format([[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]],name)
    end
    local nameText = GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox)
    if nameText ~= nil then
        nameText:setShowText(sLevel)
    end

    local imgType = GetElement(self.m_root,"imgType_CellPetEvolution", WZUIImage)
    imgType:setFile(s0)

    if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
        nameText:setScale(0.6)
        nameText:setMaxWidth(500)
    end
    --self:_setWarState(self.t_PetInfo.isInUsed)

    local aptitude = WndPets:getAptitude(self.t_PetInfo.giftSkill)
    GetElement(self.m_root,"txtStarLv_CellPetEvolution", WZUILabelTTF):setText(aptitude)

    if self.choiceState ~= nil then
        self:setState(self.choiceState)
    end
    AdaptLanguage(self)

    self.m_bLoadFinish = true
end

function CellPetEvolution:setState(bState)
    WZLog("CellPetEvolution:setState", bState)
    -- local element =  GetElement(self.m_root,"conSel_CellPetList",WZUIContainer)
    -- if element == nil then
    --     self.choiceState = bState
    --     return
    -- end
    -- element:setVisible(bState)
    if self.m_bLoadFinish == true then
        GetElement(self.m_root,"conSel_CellPetList",WZUIContainer):setVisible(bState)
    else
        self.choiceState = bState
    end
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

function CellPetEvolution:_adaptLanguage_ug(  )
    GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox):setScale(0.6)
end
-------------------------------------语言适配End---------------------------------------------