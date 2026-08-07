--CellChoosePet.lua
--@brief	CellChoosePet的UI模块
--@date		2016/11/15
--@author	zsq
--@note		选择宠物进化


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellChoosePet:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellChoosePet:onExit(element)
	self:_unInit()
end

function CellChoosePet:onClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("CellChoosePet:onClick",self.b_isClick)
	local position = -1
	for i=1,4 do
		if WndChoosePet["m_tPet"..i] == nil then
			position = i
			break
		end
	end
	if position == -1 and (self.b_isClick == false or self.b_isClick == nil) then
		MsgBoxManager:showTipBox(LocalStrings.PETENOUGHNUM)
		return
	end
	--设置选中状态
    if self.b_isClick then
        self:_setButtonState(false)
		WZLog("点击",self.m_nPosition)
		for i=1,4 do
			if WndChoosePet["m_tPet"..i] ~= nil and self.t_PetInfo.playerPetId == WndChoosePet["m_tPet"..i].playerPetId then
				WndChoosePet["m_tPet"..i] = nil
				break
			end
		end
    else
        self:_setButtonState(true)
		WndChoosePet["m_tPet"..position] = self.t_PetInfo
    end
	WndChoosePet:refreshSelectedPet()
end

function CellChoosePet:setData(tData)
	self.t_PetInfo = tData
	self:update()
	AdaptLanguage(self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--升级界面的初始化
function CellChoosePet:update()
    --GetElement(self.m_root,"conBg_CellPetChoiceList",WZUIContainer):setAbsContentSize(GlobalMethod:CCSize(610,120))
    GetElement(self.m_root,"imgIconBg_CellPetChoiceList",WZUIImage):setFile(self.t_PetInfo.icon)
    local element =  GetElement(self.m_root,"imgIconBgQuality_CellPetChoiceList",WZUIImage)
    local quality = GDatatab_item["id_"..self.t_PetInfo.itemId].quality
    WndPets:setIconQuality(element, quality)
    local name = "Lv"..self.t_PetInfo.upgradeLevel.." "..self.t_PetInfo.name--.."  ".."Lv."..self.t_PetInfo.upgradeLevel
    local nameText = GetElement(self.m_root,"txtName_CellPetChoiceList",WZUILabelTTF)
    nameText:setText(name)
    WndPets:setTextColor(GDatatab_item["id_"..self.t_PetInfo.itemId].quality, nameText)
   
   local aptitude = WndPets:getAptitude(self.t_PetInfo.giftSkill)
    for i =1 ,5 do
    	GetElement(self.m_root,"imgAptitude"..i.."_CellPetChoiceList",WZUIImage):setVisible(i <= aptitude)
    end

	self:_setButtonState(WndChoosePet:checkIsUsed(self.t_PetInfo))
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------私有方法模块End----------------------------------------
function CellChoosePet:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtName_CellPetChoiceList",WZUILabelTTF):setScale(0.7)
end

function CellChoosePet:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtName_CellPetChoiceList",WZUILabelTTF):setScale(0.7)
end
-------------------------------------私有方法模块End----------------------------------------
