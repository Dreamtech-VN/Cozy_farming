--WndPetSkillTransfer.lua
--@brief	WndPetSkillTransfer的UI模块
--@date		2019/12/17
--@author	Tianxiang_Xu
--@note		宠物技能转移界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetSkillTransfer:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetSkillTransfer:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)

	self:_unInit()
end

function WndPetSkillTransfer:onEnterTransitionDidFinish(element)
	--body
	CacheCenter:registerUpatePlayerItemObserver(self)

	local sConfig = CacheCenter:getGameParam().petShift
	self.m_tSystemConfig = json.decode(sConfig)
	WZLog("WndPetSkillTransfer:_showTransferCost", Serialize(self.m_tSystemConfig))

	self:showCurPetInfo()
	self:_update()
	self:showFight()
end

--@brief  退出场景时被调用的函数
--@param  element:表绑定的UI节点引用
function WndPetSkillTransfer:onCloseClick(element)
  	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

--  	WndPets:doRefresh()
  	-- WindowManager:removeWindow(self.m_root, self, true)
  	WndPetSkillTransfer.m_root:removeFromParentAndCleanup(true)
  	if WndPetsSkill.m_root then
	    WndPetsSkill:playAttackAni()
    	WndPetsSkill:showPetsSkillMainUI(true)
	end
end

--@breif 显示宠物战力
function WndPetSkillTransfer:showFight()
  local fight = WndPets:getCurPetFight()
  local qualification = WndPets:getCurPetQualification()

  local txtFight = GetElement(self.m_root,"txtFight_WndPetSkillTransfer",WZUILabelTTF)
  CCNodePropertySetter:setValue(txtFight, "skewX", 10)
  local ftbFight = GetElement(self.m_root,"ftbFight_WndPetSkillTransfer",WZUIFreeTextBox)
  ftbFight:setShowText(string.format(LocalStrings.FIGHT_POWER1,fight))
  if ProjConfig.LANGUAGE == "vn" then
	  ftbFight:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
	  ftbFight:setScale(0.8)
	end
  local txtPetQualification = GetElement(self.m_root,"txtPetQualification_WndPetSkillTransfer",WZUILabelTTF)
  txtPetQualification:setText(LocalStrings.PETINTELLIGENCE..qualification)
end

--查看宠物属性
function WndPetSkillTransfer:onShowAttribute(element)
  WndPets:showAttributeTips(element,self.m_root,1)
end

--@brief 	点击选中宠物按钮回调
function WndPetSkillTransfer:onChoosePet(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nInterfaceIndex = 2
	self:_update()
end

--@brief 	选中被转移的宠物回调
function WndPetSkillTransfer:clickPetForTransferCallback(tData)
	-- body
	self.m_rightPetInfo = tData
	self.n_tRightSkillId = {}

	self.m_nInterfaceIndex = 3
	self:_update()
end

--@brief 	点击右边宠物技能回调
function WndPetSkillTransfer:onClickRightSkill(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local tData = self.n_tRightSkillId[nTag]
	if tData then 
		WndTips:show(element, self.m_root, 59, tData, GlobalMethod:ccp(25,100))
	end
end

--@brief 	点击转移按钮回调
function WndPetSkillTransfer:onSkillTransfer(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nRightSkillNum = #self.n_tRightSkillId
	local nSkillNum = #self.n_tCurSkillId
	if nRightSkillNum > nSkillNum then 
		MsgBoxManager:showTipBox(LocalStrings.PETSKILL_TEXT4)
		return 
	end 
	local ids, num = SplitItemString(self.m_tSystemConfig[tostring(nSkillNum)])
	for i = 1, #ids do
		if not JudgeMoneyIsEnough(tonumber(ids[i]), tonumber(num[i]), nil, nil, GlobalGame.g_nCurrentUIChannelId) then 
			return 
		end
	end
	if nSkillNum > nRightSkillNum then 
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.PETSKILL_TEXT5, nRightSkillNum), self, self.continueToTransfer)
	else
		MsgBoxManager:showConfirmBox(LocalStrings.PETSKILL_TEXT7, self, self.continueToTransfer)
	end
end

--@BRIEF 	继续转移
function WndPetSkillTransfer:continueToTransfer()
	-- body
	ProtocolProcessorScenePets:send_PET_PetSkillChange(self.m_curPetInfo.playerPetId, self.m_rightPetInfo.playerPetId)
end

--@brief 	点击右边宠物技能回调
function WndPetSkillTransfer:onClickCurSkill(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local tData = self.n_tCurSkillId[nTag]
	if tData then 
		WndTips:show(element, self.m_root, 59, tData, GlobalMethod:ccp(250, 100))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndPetSkillTransfer:_update()
	-- body
	GetElement(self.m_root, "conPetOne_WndPetSkillTransfer", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conPetTwo_WndPetSkillTransfer", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conPetThree_WndPetSkillTransfer", WZUIContainer):setVisible(false)

	if self.m_nInterfaceIndex == 1 then 
		self:showInterfaceOne()
	elseif self.m_nInterfaceIndex == 2 then 
		self:showInterfaceTwo()
	else
		self:showInterfaceThree()
	end
end

--@brief 	显示当前宠物信息
function WndPetSkillTransfer:showCurPetInfo()
	-- body
	--名字
    local name = self.m_curPetInfo.name
    local advancedLevel = self.m_curPetInfo.advancedLevel
    local nameText = GetElement(self.m_root,"txtName_WndPetSkillTransfer",WZUIFreeTextBox)
    WndPets:setPetName(self.m_curPetInfo.itemId, nameText, name, advancedLevel, false)
   
    -- --等级
    -- local lvtext = GetElement(self.m_root,"txtLv_WndPetSkillTransfer",WZUILabelTTF)
    -- lvtext:setText("Lv"..self.m_curPetInfo.upgradeLevel)
    -- WndPets:setTextColor(GDatatab_item["id_"..self.m_curPetInfo.itemId].quality, lvtext)
    
     --星星品质
    local aptitude = WndPets:getAptitude(self.m_curPetInfo.giftSkill)
    for i = 1, 7 do
        GetElement(self.m_root,"imgAptitude"..i.."_WndPetSkillTransfer",WZUIImage):setVisible(i <= aptitude)
    end
    WndPets:setAptitudePost(self.m_root, "conAptitude_WndPetSkillTransfer", aptitude)
    
    --动物动画
    local petImage = GetElement(self.m_root,"conPet1_WndPetSkillTransfer",WZUIContainer)
    petImage:removeAllChildrenWithCleanup(true)
    self.petAni = CreatePetAni(petImage, nil, self.m_curPetInfo.animation, advancedLevel)
    self:playAttackAni()

    --宠物技能
    self:setSkillInfo()
end

function WndPetSkillTransfer:playAttackAni()
  local conPet = GetElement(self.m_root,"conPet1_WndPetSkillTransfer",WZUIContainer)
  conPet:disableSchedule()
  
  self.petAni:play("attack",false)
  conPet:enableSchedule("_updateWaitAni")
end

function WndPetSkillTransfer:_updateWaitAni(element)
  local isEnd = self.petAni:isCurrentAnimationDone()
  if isEnd then
    local conPet = GetElement(self.m_root,"conPet1_WndPetSkillTransfer",WZUIContainer)
    conPet:disableSchedule()
    self.petAni:play("wait",true)
  end
end

--@brief 设置技能洗练
function WndPetSkillTransfer:setSkillInfo()
    WZLog("WndPetSkillTransfer:setSkillInfo:",self.m_curPetInfo.skill)
    local skillId = {}
    skillId = SplitStringWithSeparator(self.m_curPetInfo.skill,"|")
    if #self.n_tCurSkillId < 1 then
        for i = 1, #skillId do
            local tab = GDatatab_skill["id_"..skillId[i]]
            tab.btnType = 1
            tab.uiTag = i
            table.insert(self.n_tCurSkillId, tab)
        end
    else
        for i =1, #self.n_tCurSkillId do
            WZLog("WndPetSkillTransfer:setSkillInfo222:",self.n_tCurSkillId[i].id, skillId[i])
            if self.n_tCurSkillId[i].id ~= tonumber(skillId[i]) then
                local tab = GDatatab_skill["id_"..skillId[i]]
                tab.btnType = 1
                tab.uiTag = i
                self.n_tCurSkillId[i] = tab
            end
        end
    end

    for i = 1, 5 do
        if i <= #self.n_tCurSkillId then
            GetElement(self.m_root,"imgCurSkillIcon" .. i .. "_WndPetSkillTransfer",WZUIImage):setFile(self.n_tCurSkillId[i].icon)
            GetElement(self.m_root,"imgCurLevel" .. i .. "_WndPetSkillTransfer",WZUIImage):setFile(self.n_tCurSkillId[i].lv_icon)
            GetElement(self.m_root,"imgCurLock" .. i .. "_WndPetSkillTransfer",WZUIImage):setVisible(false)
        else
            GetElement(self.m_root,"imgCurLock" .. i .. "_WndPetSkillTransfer",WZUIImage):setVisible(true)
        end
    end
end

--@brief 	显示说明界面
function WndPetSkillTransfer:showInterfaceOne()
	-- body
	GetElement(self.m_root, "conPetOne_WndPetSkillTransfer", WZUIContainer):setVisible(true)

	GetElement(self.m_root, "ftxtDesc_WndPetSkillTransfer", WZUIFreeTextBox):setShowText(LocalStrings.PETSKILL_TEXT3)
	--	更新滚动容器内部布局函数
	self:_upMoveContainerLayer1()
end

--@brief  	更新滚动容器内部布局函数
function WndPetSkillTransfer:_upMoveContainerLayer1()
	WZLog("self:_upMoveContainerLayer1()")
	if self.m_root == nil then
		return
	end
	--获取规则说明内容文本的大小
	local txtExplanation = GetElement(self.m_root, "ftxtDesc_WndPetSkillTransfer", WZUIFreeTextBox)
	local txtSize = txtExplanation:getContentSize()	
	txtExplanation:setAnchorPoint(ccp(0,1))
	txtExplanation:setPositionY(txtSize.height-5)
	WZLog("富文本框尺寸是",txtSize.width,txtSize.height)
--
	
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndPetSkillTransfer")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize(1 , txtSize.height / rollSize.height ) )
	--moveElement:setContentSize(txtSize)
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
	WZLog("滚动容器大小",rollSize.width,rollSize.height)
end

--@brief 	显示宠物选择界面
function WndPetSkillTransfer:showInterfaceTwo()
	-- body
	GetElement(self.m_root, "conPetTwo_WndPetSkillTransfer", WZUIContainer):setVisible(true)

	local tbPetList = GetElement(self.m_root, "tbPetList_WndPetSkillTransfer", WZUITableContainer)
	tbPetList:cleanTable()

	local tPetList = self:getTransferPetList()
	for i = 1, #tPetList do
		local celElement, tCell = CellPetChoiceList:createElement()
		if celElement and tCell then 
			celElement:setTag(i - 1)
			tCell:setCellAllElement(tPetList[i], 4)

			tbPetList:setCellElement(celElement)
		end
	end
end

--@brief 	显示宠物选中后界面
function WndPetSkillTransfer:showInterfaceThree()
	-- body
	GetElement(self.m_root, "conPetThree_WndPetSkillTransfer", WZUIContainer):setVisible(true)

	self:showRightPetInfo()
	self:_showTransferCost()
end

--@brief 	显示被转移宠物信息
function WndPetSkillTransfer:showRightPetInfo()
	-- body
	--名字
    local name = self.m_rightPetInfo.name
    local advancedLevel = self.m_rightPetInfo.advancedLevel
    local nameText = GetElement(self.m_root,"txtNameR_WndPetSkillTransfer",WZUIFreeTextBox)
    WndPets:setPetName(self.m_rightPetInfo.itemId, nameText, name, advancedLevel, false)
   
    --等级
    local lvtext = GetElement(self.m_root,"txtLvR_WndPetSkillTransfer",WZUILabelTTF)
    lvtext:setText("Lv"..self.m_rightPetInfo.upgradeLevel)
    WndPets:setTextColor(GDatatab_item["id_"..self.m_rightPetInfo.itemId].quality, lvtext)
    
     --星星品质
    local aptitude = WndPets:getAptitude(self.m_rightPetInfo.giftSkill)
    for i = 1, 7 do
        GetElement(self.m_root,"imgAptitudeR"..i.."_WndPetSkillTransfer",WZUIImage):setVisible(i <= aptitude)
    end
    WndPets:setAptitudePost(self.m_root, "conAptitudeR_WndPetSkillTransfer", aptitude)
    
    --动物动画
    local petImage = GetElement(self.m_root,"conPetR1_WndPetSkillTransfer",WZUIContainer)
    petImage:removeAllChildrenWithCleanup(true)
    local petAni = CreatePetAni(petImage, nil, self.m_rightPetInfo.animation, advancedLevel)

    --宠物技能
    self:setRightSkillInfo()
end

--@brief 设置技能洗练
function WndPetSkillTransfer:setRightSkillInfo()
    WZLog("WndPetSkillTransfer:setRightSkillInfo:",self.m_rightPetInfo.skill)
    local skillId = {}
    skillId = SplitStringWithSeparator(self.m_rightPetInfo.skill,"|")
    if #self.n_tRightSkillId < 1 then
        for i = 1, #skillId do
            local tab = GDatatab_skill["id_"..skillId[i]]
            tab.btnType = 1
            tab.uiTag = i
            table.insert(self.n_tRightSkillId, tab)
        end
    else
        for i =1, #self.n_tRightSkillId do
            WZLog("WndPetSkillTransfer:setSkillInfo222:",self.n_tRightSkillId[i].id, skillId[i])
            if self.n_tRightSkillId[i].id ~= tonumber(skillId[i]) then
                local tab = GDatatab_skill["id_"..skillId[i]]
                tab.btnType = 1
                tab.uiTag = i
                self.n_tRightSkillId[i] = tab
            end
        end
    end

    for i = 1, 5 do
        if i <= #self.n_tRightSkillId then
            GetElement(self.m_root,"imgRSkillIcon" .. i .. "_WndPetSkillTransfer",WZUIImage):setFile(self.n_tRightSkillId[i].icon)
            GetElement(self.m_root,"imgRLevel" .. i .. "_WndPetSkillTransfer",WZUIImage):setFile(self.n_tRightSkillId[i].lv_icon)
            GetElement(self.m_root,"imgRLock" .. i .. "_WndPetSkillTransfer",WZUIImage):setVisible(false)
        else
        	GetElement(self.m_root,"imgRSkillIcon" .. i .. "_WndPetSkillTransfer",WZUIImage):setFile("")
            GetElement(self.m_root,"imgRLevel" .. i .. "_WndPetSkillTransfer",WZUIImage):setFile("")
            GetElement(self.m_root,"imgRLock" .. i .. "_WndPetSkillTransfer",WZUIImage):setVisible(true)
        end
    end
end

--@brief 	转移消耗
function WndPetSkillTransfer:_showTransferCost()
	-- body
	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndPetSkillTransfer", WZUIFreeTextBox)
	local sFormat1 = [[<T S="20" C="255,236,193" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
	local sFormat2 = [[<I Z="0.5" P="1">%s</I><T S="20" C="255,236,193" P="1" SC="132,66,29" SS="4" SE="1">%d</T><T S="20" C="233,166,62" P="1" SC="132,66,29" SS="4" SE="1">(%s%d)</T>]]
	
	local nSkillNum = #self.n_tCurSkillId
	local ids, num = SplitItemString(self.m_tSystemConfig[tostring(nSkillNum)])
	if ftxtCost then 
		local sCostContent = string.format(sFormat1, LocalStrings.ATH_SHOP_COST)
		for i = 1, #ids do
			local tBasicData = GDatatab_item["id_" .. ids[i]]
			local nOwnCount = CacheCenter:getPlayerItemCountById(tonumber(ids[i]))
			local sCostTemp = string.format(sFormat2, tBasicData.icon, tonumber(num[i]), LocalStrings.OWN, nOwnCount)
			
			sCostContent = sCostContent .. sCostTemp
		end

		ftxtCost:setShowText(sCostContent)
	end
end
-------------------------------------私有方法模块End----------------------------------------
