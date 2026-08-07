--CellPetList.lua
--@brief	CellPetList的UI模块
--@date		2014/01/06
--@author	孙珊珊
--@note		宠物列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPetList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPetList:onExit(element)
	self:_unInit()
end

--@brief    获取表参数
--@param    #1, tCellData:邮件信息
function CellPetList:setCellAllElement(tPetInfo)
    WZLog("CellMailList:setCellAllElement")
    self.t_PetInfo = tPetInfo
    
end

--@brief  设置cell中的内容
--@param  tPetInfo:设置宠物的属性
function CellPetList:onLoadData(element)
    WZLog("CellPetList:setCellAllElement")
    local cellElementPetList = WZUISystem:getInstance():createElement("CellPetList")
    self.m_root:addChild(cellElementPetList)
    AdaptLanguage(self)
    local tPetInfo = self.t_PetInfo

    GetElement(self.m_root,"imgIconBg_CellPetList",WZUIImage):setFile(tPetInfo.icon)
    local cellElementImgIcon =  GetElement(self.m_root,"imgIconBgQuality_CellPetList",WZUIImage)
    local quality = GDatatab_item["id_"..tPetInfo.itemId].quality
    WndPets:setIconQuality(cellElementImgIcon, quality)
    local name = "Lv"..tPetInfo.upgradeLevel.." "..tPetInfo.name
    
    local txtColor = g_sFtxtQualityColor
    local color = txtColor[quality]
    local lv = "+"..tPetInfo.advancedLevel
     if tPetInfo.advancedLevel < 1 then
        lv = ""
    end
    if WndPets:isExpPet(tPetInfo.itemId) then
        lv = ""
    end
    local s0 = WndPets:getTypeById(tPetInfo.itemId)
    local sLevel = string.format([[<I>%s</I><T C=%s S="20" P="1">%s</T><T C="0,255,0" S="20" P="1">%s</T>]],s0, color, name, lv)
    local nameText = GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox)
    if nameText ~= nil then
        nameText:setShowText(sLevel)
    end

    self:_setWarState(self.t_PetInfo.isInUsed)

    local aptitude = WndPets:getAptitude(self.t_PetInfo.giftSkill)
    for i = 1, 7 do
    	GetElement(self.m_root,"imgAptitude"..i.."_CellPetList",WZUIImage):setVisible(i <= aptitude)
    end
    --经验宝宝
    if WndPets:isExpPet(tPetInfo.itemId) then
        GetElement(self.m_root,"conWar_CellPetList",WZUIContainer):setVisible(false)
    	GetElement(self.m_root,"txtNum_CellPetList",WZUILabelTTF):setVisible(true)
        GetElement(self.m_root,"txtNum_CellPetList",WZUILabelTTF):setText(string.format(LocalStrings.PETHASNUM,self.t_PetInfo.num))
    end
    self:setState(self.choiceState)
end

function CellPetList:getPetId()
    return self.t_PetInfo.playerPetId
end

function CellPetList:onSiClick(element, table)
    WZLog("CellPetList:onSiClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:setState(true)
    WndPets:setPetInfo(self.t_PetInfo, self)
end

function CellPetList:setState(bState)
    WZLog("CellPetList:setState", bState)
    local element =  GetElement(self.m_root,"conSel_CellPetList",WZUIContainer)
    if element == nil then
        self.choiceState = bState
        return
    end
    element:setVisible(bState)
end

function CellPetList:onFighting()
    WZLog("---------------------fighting----------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    TeachGroup1:endTeachStep({12,7})
    self:setState(true)
    WndPets:setPetInfo(self.t_PetInfo, self)
    WndPets:onToWar()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPetList:_setWarState(isWar)
    WZLog("CellPetList:_setWarState:",isWar)
    self.t_PetInfo.isInUsed = isWar
	if isWar then
		GetElement(self.m_root,"txtWarState_CellPetList",WZUILabelTTF):setText(LocalStrings.PETREST)
	else
		GetElement(self.m_root,"txtWarState_CellPetList",WZUILabelTTF):setText(LocalStrings.PETATWAR)
	end
    local war = GetElement(self.m_root,"imgWar_CellPetList",WZUIImage)
    war:setVisible(isWar)
end

-------------------------------------私有方法模块End----------------------------------------

------------------------------------------语言适配Begin---------------------------------------
function CellPetList:_adaptLanguage_th(  )
    local txtName = GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox)
    txtName:setMaxWidth(500)
    txtName:setScale(0.8)
end

function CellPetList:_adaptLanguage_en(  )
    local txtName = GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox)
    txtName:setMaxWidth(500)
    txtName:setScale(0.6)
end

function CellPetList:_adaptLanguage_pt(  )
    local txtName = GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox)
    txtName:setMaxWidth(500)
    txtName:setScale(0.6)
end

function CellPetList:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox):setScale(0.7)
end

function CellPetList:_adaptLanguage_es(  )
    local txtName = GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox)
    txtName:setMaxWidth(500)
    txtName:setScale(0.6)
    GetElement(self.m_root,"txtWarState_CellPetList",WZUILabelTTF):setFontSize(10)
end

function CellPetList:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtWarState_CellPetList",WZUILabelTTF):setScale(0.8)
    
    GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox):setScale(0.7)
end

function CellPetList:_adaptLanguage_ug(  )
    local txtName = GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox)
    txtName:setMaxWidth(500)
    txtName:setScale(0.7)

    local txtWarState = GetElement(self.m_root,"txtWarState_CellPetList",WZUILabelTTF)
    txtWarState:setScale(0.6)
    txtWarState:setDimensions(GlobalMethod:CCSize(110))
end
------------------------------------------语言适配End-----------------------------------------