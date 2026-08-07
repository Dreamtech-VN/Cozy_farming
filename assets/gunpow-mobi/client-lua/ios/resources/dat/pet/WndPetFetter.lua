--WndPetFetter.lua
--@brief	WndPetFetter的UI模块
--@date		2019/01/26
--@author	Tianxiang_Xu
--@note		宠物羁绊窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetFetter:onEnter(element)
	self.m_root = element

	if GlobalGame.g_tRedPointList.petFetter then 
		ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(246)
		GlobalGame.g_tRedPointList.petFetter = false 
		WndPets:setFetterRedDot()
		if SceneCity.m_tWndBottomBar then 
			CacheCenter:updateRedPoint("right", SceneCity.m_tWndBottomBar, "btnPet")
		end
	end
	self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetFetter:onExit(element)
	self:_unInit()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
function WndPetFetter:onCloseClick(element)
	WZLog("WndPetFetter:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WndPets.n_refreshState = 0
	
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndPetFetter:_update()
	-- body
	self:showCurPetInfo()
	self:showUsingPet()

	local fetterConfig = self:_getFetterConfig(self.m_nFightPetData.itemId)
	local conRight = GetElement(self.m_root, "conRight_WndPetFetter", WZUIContainer)
	if fetterConfig == nil then 
		ShowPanelNullTip(conRight, LocalStrings.PET_FETTER4)
		return 
	end
	removeShowPanelNullTip(conRight)

	local tbFetterList = GetElement(self.m_root, "tbFetterList_WndPetFetter", WZUITableContainer)
	tbFetterList:cleanTable()
	local tFetterState = SplitStringWithSeparator(self.m_nFightPetData.fetterStatus, "|", nil, true) --
	for i = 1, 4 do
		if type(fetterConfig["fetters" .. i]) == "table" then 
			local element, tNewObj = CellPetFetterItem:createElement()
			if element and tNewObj then 
				local tItem = {}
				tItem.name = fetterConfig["name"]
				tItem.fetters = fetterConfig["fetters" .. i]
				tItem.attribute = fetterConfig["attribute" .. i]
				tItem.state = tFetterState[i]

				element:setTag(i - 1)
				tNewObj:setData(tItem)
				tbFetterList:setCellElement(element)
			end
		end
	end
end

--@breif  展示当前宠物属性
function WndPetFetter:showCurPetInfo()
   	--名字
	local name = self.m_nFightPetData.name
	local advancedLevel = self.m_nFightPetData.advancedLevel
	local nameText = GetElement(self.m_root, "txtName_WndPetFetter", WZUIFreeTextBox)
	WndPets:setPetName(self.m_nFightPetData.itemId, nameText, name, advancedLevel, false)

	--等级
	local lvtext = GetElement(self.m_root, "txtLv_WndPetFetter", WZUILabelTTF)
	lvtext:setText("Lv"..self.m_nFightPetData.upgradeLevel)
	WndPets:setTextColor(GDatatab_item["id_"..self.m_nFightPetData.itemId].quality, lvtext)

	--星星品质
	local aptitude = WndPets:getAptitude(self.m_nFightPetData.giftSkill)
	for i =1 ,5 do
	  GetElement(self.m_root,"imgAptitude"..i.."_WndPetFetter",WZUIImage):setVisible(i <= aptitude)
	end

	GetElement(self.m_root, "txtLevelAtt_WndPetFetter", WZUILabelTTF):setText(string.format(LocalStrings.PET_FETTER2, GDatatab_button_info["id_150"].open_level))
end

--@brief  展示当前使用的宠物
function WndPetFetter:showUsingPet()
   --动物动画
  local petImage = GetElement(self.m_root, "conPet1_WndPetFetter", WZUIContainer)
  petImage:removeAllChildrenWithCleanup(true)
  local petAni = CreatePetAni(petImage, nil, self.m_nFightPetData.animation, self.m_nFightPetData.advancedLevel)
  --petAni:getAnimNode():setScale(1.5)    
end
-------------------------------------私有方法模块End----------------------------------------
