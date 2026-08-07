--WndPetPhantom.lua
--@brief	WndPetPhantom的UI模块
--@date		2018/03/06
--@author	Tianxiang_Xu
--@note		宠物幻型


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetPhantom:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetPhantom:onExit(element)
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function WndPetPhantom:onEnterTransitionDidFinish(element)
    --body
    self.m_tCurData = WndPets.m_tCurPetsInfo

    self:showLoading()
    ProtocolProcessorScenePets:send_PET_GetPetSkinList(self.m_tCurData.playerPetId)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
function WndPetPhantom:onCloseClick(element)
	WZLog("WndPetPhantom:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	-- WindowManager:removeWindow(self.m_root, self, true)
	WndPetPhantom.m_root:removeFromParentAndCleanup(true)
	WndPets:playAttackAni()
end

--@brief 	点击幻型按钮回调
function WndPetPhantom:onPetPhantom(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tClickData == nil then 
		MsgBoxManager:showTipBox(LocalStrings.PET_TEXT5)
		return 
	end
	if (self.m_tCurData.petSkinItemId == 0 and self.m_tClickData.itemId == self.m_tCurData.itemId) or (self.m_tCurData.petSkinItemId == self.m_tClickData.itemId)then
		MsgBoxManager:showTipBox(LocalStrings.PET_TEXT8)
		return 
	end
	
	--是否是还原形象;还原免费
	if self.m_tClickData.itemId ~= self.m_tCurData.itemId then
		if not JudgeMoneyIsEnough(810, 1, nil, nil, GlobalGame.g_nCurrentUIChannelId) then
			return 
		end
	end

	local strMsg = LocalStrings.PHANTOM33
	if self.m_tClickData.itemId ~= self.m_tCurData.itemId then
		strMsg = LocalStrings.PHANTOM32
	end 

	MsgBoxManager:showConfirmCancelBox(strMsg,self,self._clickcallback)
end

function WndPetPhantom:_clickcallback(nId, nResType) 
	WZLog("WndPetPhantom:onPetPhantom", self.m_tCurData.playerPetId, self.m_tClickData.itemId)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		ProtocolProcessorScenePets:send_PET_ChangePetSkin(self.m_tCurData.playerPetId, self.m_tClickData.itemId)
	end
end

--@brief 	点击右边宠物头像回调
function WndPetPhantom:onClickPetHead(tCell, tData)
	-- body
	if self.m_tClickData.itemId == tData.itemId then return end 
	self.m_tClickPetCell:setItemSelState(false)

	self.m_tClickData = tData 		--选中的宠物数据
	self.m_tClickPetCell = tCell 
	self.m_nPetSelId = tData.itemId

	tCell:setItemSelState(true)
	self:_showPetAniRight()
	self:_showCost()
end

--@brief 	点击规则按钮回调
function WndPetPhantom:onClickRule(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndSingleMapDesc:showInterface1(LocalStrings.PET_TEXT13)   
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndPetPhantom:_update()
	-- body
	self:_showPetList()

	self:_showPetAniLeft()
	self:_showPetAniRight()
	self:_showCost()
end
--@brief 	显示消耗
function WndPetPhantom:_showCost()
	-- body
	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndPetPhantom", WZUIFreeTextBox)
	if self.m_tClickData and self.m_tClickData.itemId == self.m_tCurData.itemId then
		local sFormat = [[<T C="255,236,193" S="20" P="1" SC="105,65,46" SS="4" SE="1">%s</T>]]
		ftxtCost:setShowText(string.format(sFormat, LocalStrings.PETFREE2))
		self:_setPhantomBtnText(LocalStrings.NEW_SHOP_2)
	else
		if ftxtCost then
			local sFormat = [[<T C="255,236,193" S="20" P="1" SC="105,65,46" SS="4" SE="1">%s</T><I Z ="0.45">%s</I><T C="255,236,193" S="20" P="1" SC="105,65,46" SS="4" SE="1">X%d</T>]]
			local tBasicData = GDatatab_item["id_810"]
			ftxtCost:setShowText(string.format(sFormat, LocalStrings.CONSUME, tBasicData.icon, 1))
		end
		self:_setPhantomBtnText(LocalStrings.PET_TEXT1)
	end
end

--@brief 	显示可幻型的宠物列表
function WndPetPhantom:_showPetList()
	-- body
	local tbPetList = GetElement(self.m_root, "tbPetList_WndPetPhantom", WZUITableContainer)
	tbPetList:cleanTable()
	tbPetList:setLoadCountPerFrame(4)

	local conRight = GetElement(self.m_root, "conRight_WndPetPhantom", WZUIContainer)
	if self.m_tPetData == nil or #self.m_tPetData == 0 then
		ShowPanelNullTip(conRight, LocalStrings.PET_TEXT5)
		return
	end
	removeShowPanelNullTip(conRight)

	for i = 1, #self.m_tPetData do
		local cellElement, tcell = CellFamilyPetHead:createElement()
        if cellElement then
            cellElement = WZUIContainer:luaTo(cellElement)
            tcell:setData(self.m_tPetData[i])
            tcell:setItemClickFun(self, self.onClickPetHead)
            cellElement:setTag(i - 1)
            tbPetList:setCellElement(cellElement)
            if self.m_nPetSelId and self.m_nPetSelId == self.m_tPetData[i].itemId then
            	tcell:setItemSelState(true)
            	self.m_tClickPetCell = tcell
            	self.m_tClickData = self.m_tPetData[i]
            end
        end
	end
end

--@brief 	显示幻型前后宠物形象
function WndPetPhantom:_showPetAniLeft()
	-- body
	--名字
	local txtName1 = GetElement(self.m_root, "txtName1_WndPetPhantom", WZUILabelTTF)
	if txtName1 then
		local tBasicData = GDatatab_item["id_" .. self.m_tCurData.itemId]
		txtName1:setColor(QUALITYCOLOR[tBasicData.quality])
		txtName1:setText(self.m_tCurData.name)
	end
	--幻型前形象
	local conPet1 = GetElement(self.m_root, "conPet1_WndPetPhantom", WZUIContainer)
	conPet1:removeAllChildrenWithCleanup(true)
	local petAni = CreatePetAni(conPet1, nil, self.m_tCurData.animation, self.m_tCurData.advancedLevel, self.m_tCurData.petSkinItemId)
    local animNode = petAni:getAnimNode()
    animNode:setScale(0.7)
end

--@brief 	显示幻型前后宠物形象
function WndPetPhantom:_showPetAniRight()
	-- body
	if self.m_tClickData == nil then return end 
	--名字
	local txtName2 = GetElement(self.m_root, "txtName2_WndPetPhantom", WZUILabelTTF)
	if txtName2 then
		local tBasicData = GDatatab_item["id_" .. self.m_tClickData.itemId]
		txtName2:setColor(QUALITYCOLOR[tBasicData.quality])
		txtName2:setText(self.m_tClickData.name)
	end

    --幻型后形象
	local conPet2 = GetElement(self.m_root, "conPet2_WndPetPhantom", WZUIContainer)
	conPet2:removeAllChildrenWithCleanup(true)
	local petAni2 = CreatePetAni(conPet2, nil, self.m_tClickData.animation, self.m_tClickData.advancedLevel)
    local animNode2 = petAni2:getAnimNode()
    animNode2:setScale(0.7)
end

--@brief 	设置按钮文字
function WndPetPhantom:_setPhantomBtnText(text)
	-- body
	local txtPetBtnPhantom = GetElement(self.m_root, "txtPetBtnPhantom_WndPetsUpgrade", WZUILabelTTF)
	if txtPetBtnPhantom then
		txtPetBtnPhantom:setText(text)
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function WndPetPhantom:_adaptLanguage_es( )
	local txtName1 = GetElement(self.m_root, "txtName1_WndPetPhantom", WZUILabelTTF)
	txtName1:setDimensions(GlobalMethod:CCSize(160))
	local txtName2 = GetElement(self.m_root, "txtName2_WndPetPhantom", WZUILabelTTF)
	txtName2:setDimensions(GlobalMethod:CCSize(160))
end

function WndPetPhantom:_adaptLanguage_pt( )
	local txtName1 = GetElement(self.m_root, "txtName1_WndPetPhantom", WZUILabelTTF)
	txtName1:setDimensions(GlobalMethod:CCSize(160))
	local txtName2 = GetElement(self.m_root, "txtName2_WndPetPhantom", WZUILabelTTF)
	txtName2:setDimensions(GlobalMethod:CCSize(160))
end

function WndPetPhantom:_adaptLanguage_en( )
	local txtName1 = GetElement(self.m_root, "txtName1_WndPetPhantom", WZUILabelTTF)
	txtName1:setDimensions(GlobalMethod:CCSize(160))
	local txtName2 = GetElement(self.m_root, "txtName2_WndPetPhantom", WZUILabelTTF)
	txtName2:setDimensions(GlobalMethod:CCSize(160))
end

function WndPetPhantom:_adaptLanguage_vn( )
	local txtName1 = GetElement(self.m_root, "txtName1_WndPetPhantom", WZUILabelTTF)
	txtName1:setDimensions(GlobalMethod:CCSize(160))
	local txtName2 = GetElement(self.m_root, "txtName2_WndPetPhantom", WZUILabelTTF)
	txtName2:setDimensions(GlobalMethod:CCSize(160))
end
-------------------------------------语言适配End----------------------------------------
function WndPetPhantom:_adaptLanguage_ug( )
	local txtPetBtnPhantom = GetElement(self.m_root, "txtPetBtnPhantom_WndPetsUpgrade", WZUILabelTTF)
	txtPetBtnPhantom:setScale(0.7)
	txtPetBtnPhantom:setDimensions(GlobalMethod:CCSize(160))

	GetElement(self.m_root, "txtTip_WndPetPhantom", WZUILabelTTF):setScale(0.85)

	local txtName1 = GetElement(self.m_root, "txtName1_WndPetPhantom", WZUILabelTTF)
	txtName1:setDimensions(GlobalMethod:CCSize(160))
	local txtName2 = GetElement(self.m_root, "txtName2_WndPetPhantom", WZUILabelTTF)
	txtName2:setDimensions(GlobalMethod:CCSize(160))
end
-------------------------------------语言适配End----------------------------------------