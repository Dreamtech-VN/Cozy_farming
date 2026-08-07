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
	AdaptLanguage(self)

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
	
	-- WindowManager:removeWindow(self.m_root, self, true)
	WndPetFetter.m_root:removeFromParentAndCleanup(true)
	WndPets:playAttackAni()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndPetFetter:_update()
	-- body
	self:showCurPetInfo()
	self:showUsingPet()
	self:showFight()

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
	WZLog("WndPetFetter:_update", self.m_nFightPetData.fetterStatus)
	for i = 1, 6 do
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

--@breif 显示宠物战力
function WndPetFetter:showFight()
  local fight = WndPets:getCurPetFight()
  local qualification = WndPets:getCurPetQualification()

  local txtFight = GetElement(self.m_root,"txtFight_WndPetFetter",WZUILabelTTF)
  CCNodePropertySetter:setValue(txtFight, "skewX", 10)
  local ftbFight = GetElement(self.m_root,"ftbFight_WndPetFetter",WZUIFreeTextBox)
  local FIGHT_POWER1 = LocalStrings.FIGHT_POWER1
  if ProjConfig.LANGUAGE == "vn" then
	  ftbFight:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
	  ftbFight:setScale(0.8)
	  FIGHT_POWER1 = [[<A IMG = "ui/common_num/common_num_zhandouli.png" Z ="1" W = "16" H = "26" CHAR = "0">%d</A>]]
  end
  ftbFight:setShowText(string.format(FIGHT_POWER1,fight))
  local txtPetQualification = GetElement(self.m_root,"txtPetQualification_WndPetFetter",WZUILabelTTF)
  txtPetQualification:setText(LocalStrings.PETINTELLIGENCE..qualification)
end

--查看宠物属性
function WndPetFetter:onShowAttribute(element)
  WndPets:showAttributeTips(element,self.m_root,2)
end

--@breif  展示当前宠物属性
function WndPetFetter:showCurPetInfo()
   	--名字
	local name = self.m_nFightPetData.name
	local advancedLevel = self.m_nFightPetData.advancedLevel
	local nameText = GetElement(self.m_root, "txtName_WndPetFetter", WZUIFreeTextBox)
	WndPets:setPetName(self.m_nFightPetData.itemId, nameText, name, advancedLevel, false)

	-- --等级
	-- local lvtext = GetElement(self.m_root, "txtLv_WndPetFetter", WZUILabelTTF)
	-- lvtext:setText("Lv"..self.m_nFightPetData.upgradeLevel)
	-- WndPets:setTextColor(GDatatab_item["id_"..self.m_nFightPetData.itemId].quality, lvtext)

	--星星品质
	local aptitude = WndPets:getAptitude(self.m_nFightPetData.giftSkill)
	for i = 1, 7 do
	  GetElement(self.m_root,"imgAptitude"..i.."_WndPetFetter",WZUIImage):setVisible(i <= aptitude)
	end

	-- GetElement(self.m_root, "txtLevelAtt_WndPetFetter", WZUILabelTTF):setText(string.format(LocalStrings.PET_FETTER2, GDatatab_button_info["id_150"].open_level))
end

--@brief  展示当前使用的宠物
function WndPetFetter:showUsingPet()
   --动物动画
  local petImage = GetElement(self.m_root, "conPet1_WndPetFetter", WZUIContainer)
  petImage:removeAllChildrenWithCleanup(true)
  self.petAni = CreatePetAni(petImage, nil, self.m_nFightPetData.animation, self.m_nFightPetData.advancedLevel)
  self:playAttackAni()
  --petAni:getAnimNode():setScale(1.5)    
end

function WndPetFetter:playAttackAni()
  local conPet = GetElement(self.m_root,"conPet1_WndPetFetter",WZUIContainer)
  conPet:disableSchedule()
  
  self.petAni:play("attack",false)
  conPet:enableSchedule("_updateWaitAni")
end

function WndPetFetter:_updateWaitAni(element)
  local isEnd = self.petAni:isCurrentAnimationDone()
  if isEnd then
    local conPet = GetElement(self.m_root,"conPet1_WndPetFetter",WZUIContainer)
    conPet:disableSchedule()
    self.petAni:play("wait",true)
  end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function WndPetFetter:_adaptLanguage_vn()
	GetElement(self.m_root, "txtLevelAtt_WndPetFetter", WZUILabelTTF):setScale(0.7)
end
function WndPetFetter:_adaptLanguage_pt()
	local txtLevelAtt = GetElement(self.m_root, "txtLevelAtt_WndPetFetter", WZUILabelTTF)
	txtLevelAtt:setScale(0.7)
	txtLevelAtt:setDimensions(GlobalMethod:CCSize(400))
end

function WndPetFetter:_adaptLanguage_en()
	local txtLevelAtt = GetElement(self.m_root, "txtLevelAtt_WndPetFetter", WZUILabelTTF)
	txtLevelAtt:setScale(0.7)
	txtLevelAtt:setDimensions(GlobalMethod:CCSize(400))
end

function WndPetFetter:_adaptLanguage_es()
	local txtLevelAtt = GetElement(self.m_root, "txtLevelAtt_WndPetFetter", WZUILabelTTF)
	txtLevelAtt:setScale(0.7)
	txtLevelAtt:setDimensions(GlobalMethod:CCSize(400))
end
-------------------------------------语言适配end----------------------------------------
