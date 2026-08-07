--CellPetFetterItem.lua
--@brief	CellPetFetterItem的UI模块
--@date		2019/01/26
--@author	Tianxiang_Xu
--@note		宠物羁绊列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPetFetterItem:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPetFetterItem:onExit(element)
	self:_unInit()
end

--@brief 	点击宠物头像回调
function CellPetFetterItem:onClickPet(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	WZLog("CellPetFetterItem:onClickPet")
	local nTag = element:getTag()
	local basicInfo = GDatatab_item["id_" .. self.m_tData.fetters[nTag][1]]

	local tData = {}
	tData.name = basicInfo.name
	tData.itemId = basicInfo.id
	tData.quality = basicInfo.quality
	tData.icon = basicInfo.icon
	tData.targetLevel = self.m_tData.fetters[nTag][3]

	local tTempPetList = CacheCenter:getPlayerPetByItemId(basicInfo.id)
	WZLog("CellPetFetterItem:onClickPet", #tTempPetList, Serialize(tTempPetList))
	tData.curLevel = 0
	tData.curStar = 0
	tData.curGift = 0
	tData.curAdvanceLevel = 0
	if tTempPetList[1] then 
		tData.curLevel = tTempPetList[1].upgradeLevel
		tData.curGift = tTempPetList[1].giftSkill
		tData.curStar = WndPets:getAptitude(tData.curGift)
		tData.curAdvanceLevel = tTempPetList[1].advancedLevel
	end

	tData.targetStar = self.m_tData.fetters[nTag][2]
	tData.targetAdvanceLevel = 0
	if self.m_tData.fetters[nTag][4] then 
		tData.targetAdvanceLevel = self.m_tData.fetters[nTag][4]
	end

	if ProjConfig.LANGUAGE == "vn" then
		WndTips:show(element, WndPetFetter.m_root, 56, tData, GlobalMethod:ccp(160,60))
	else
		WndTips:show(element, WndPetFetter.m_root, 56, tData, GlobalMethod:ccp(200,60))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellPetFetterItem:_update()
	-- body
	local ftbDesc = GetElement(self.m_root, "ftbDesc_CellPetFetterItem", WZUIFreeTextBox)
	if ftbDesc then 
		if self.m_tData.fetters[1][4] then 
			ftbDesc:setShowText(string.format(LocalStrings.PET_FETTER9, self.m_tData.fetters[1][3], self.m_tData.fetters[1][2], self.m_tData.fetters[1][4]))
		else
			ftbDesc:setShowText(string.format(LocalStrings.PET_FETTER3, self.m_tData.fetters[1][3], self.m_tData.fetters[1][2]))
		end
	end
	--状态
	local txtState = GetElement(self.m_root, "txtState_CellPetFetterItem", WZUILabelTTF)
	if txtState then 
		if self.m_tData.state == 0 then 
			txtState:setText(LocalStrings.STAR_SOUL_NOT_ACTIVE)
			txtState:setColor(GlobalMethod:ccc3(255,89,74))
		else
			txtState:setText(LocalStrings.STAR_SOUL_HAVED_ACTIVE)
			txtState:setColor(GlobalMethod:ccc3(5,180,0))
		end
	end
	--羁绊名字
	-- local txtName = GetElement(self.m_root, "txtName_CellPetFetterItem", WZUILabelTTF)
	-- if txtName then 
	-- 	txtName:setText(self.m_tData.name)
	-- end
	--属性
	for i = 1, #self.m_tData.attribute do
		local ftbProperty = GetElement(self.m_root, "ftbProperty" .. i .. "_CellPetFetterItem", WZUIFreeTextBox)
		local strFormat = [[<T C="127,70,26" S="18" P="0">%s</T><T C="229,105,22" S="18" P="0">%s</T>]]
		if ftbProperty then 
			if self.m_tData.attribute[i][1] == 99 then 
				ftbProperty:setShowText(string.format(strFormat,LocalStrings.INTELLIGENCE , "+" .. self.m_tData.attribute[i][2]))
			else
				ftbProperty:setShowText(string.format(strFormat,ATTR_TITLE[self.m_tData.attribute[i][1]] , "+" .. self.m_tData.attribute[i][2]))
			end
		end
	end
	--宠物头像
	local qualityRect = {"ui/common/frame_green.png", "ui/common/frame_bule.png", "ui/common/frame_violet.png", "ui/common/frame_orange.png"}
	for i = 1, #self.m_tData.fetters do
		GetElement(self.m_root, "conPet" .. i .. "_CellPetFetterItem", WZUIContainer):setVisible(true)
		local imgIconBg = GetElement(self.m_root, "imgIconBg" .. i .. "_CellPetFetterItem", WZUIImage)
		local imgIconBgQuality = GetElement(self.m_root, "imgIconBgQuality" .. i .. "_CellPetFetterItem", WZUIImage)
		local basicInfo = GDatatab_item["id_" .. self.m_tData.fetters[i][1]]

		imgIconBg:setFile(basicInfo.icon)
		imgIconBgQuality:setFile(qualityRect[basicInfo.quality])
		--等级
		local txtLevel = GetElement(self.m_root, "txtLevel" .. i .. "_CellPetFetterItem", WZUILabelTTF)
		local txtStarLevel = GetElement(self.m_root, "txtStarLevel" .. i .. "_CellPetFetterItem", WZUILabelTTF)
		local txtAdvanceLevel = GetElement(self.m_root, "txtAdvanceLevel" .. i .. "_CellPetFetterItem", WZUILabelTTF)
		txtLevel:setText(LocalStrings.LV .. self.m_tData.fetters[i][3])
		txtStarLevel:setText(self.m_tData.fetters[i][2])
		if self.m_tData.fetters[i][4] then 
			txtAdvanceLevel:setText("+" .. self.m_tData.fetters[i][4])
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function CellPetFetterItem:_adaptLanguage_pt( )
	local txtDesc = GetElement(self.m_root, "txtDesc_CellPetFetterItem", WZUILabelTTF)
	txtDesc:setScale(0.7)
	local txtState = GetElement(self.m_root, "txtState_CellPetFetterItem", WZUILabelTTF)
	txtState:setScale(0.7)
end

function CellPetFetterItem:_adaptLanguage_en( )
	local txtDesc = GetElement(self.m_root, "txtDesc_CellPetFetterItem", WZUILabelTTF)
	txtDesc:setScale(0.7)
	local txtState = GetElement(self.m_root, "txtState_CellPetFetterItem", WZUILabelTTF)
	txtState:setScale(0.7)
end

function CellPetFetterItem:_adaptLanguage_es( )
	local txtDesc = GetElement(self.m_root, "txtDesc_CellPetFetterItem", WZUILabelTTF)
	txtDesc:setScale(0.7)
	local txtState = GetElement(self.m_root, "txtState_CellPetFetterItem", WZUILabelTTF)
	txtState:setScale(0.7)
end

function CellPetFetterItem:_adaptLanguage_vn( )
	local txtDesc = GetElement(self.m_root, "txtDesc_CellPetFetterItem", WZUILabelTTF)
	if txtDesc then
		txtDesc:setScale(0.75)
	end
	local txtState = GetElement(self.m_root, "txtState_CellPetFetterItem", WZUILabelTTF)
	if txtState then
		txtState:setScale(0.75)
	end
end
-------------------------------------语言适配end----------------------------------------
