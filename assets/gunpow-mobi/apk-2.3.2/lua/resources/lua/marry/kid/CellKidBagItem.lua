--CellKidBagItem.lua
--@brief	CellKidBagItem的UI模块
--@date		2018/05/16
--@author	Tianxiang_Xu
--@note		小家商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellKidBagItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellKidBagItem:onExit(element)
	self:_unInit()
end

--@brief 	点击回调
function CellKidBagItem:onClickBuild(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nInterfaceType == 1 then -- 家具商店
		if self.m_tData.buyNum >= self.m_tData.limitNum then
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT61)
			return
		end

		local string = string.sub(self.m_tData.cost, 2, -2) 
		local id = SplitStringWithSeparator(string, ",")[1]
		local num = SplitStringWithSeparator(string, ",")[2]

		if not JudgeMoneyIsEnough(tonumber(id), tonumber(num), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToBuild) then
			return
		end
		
		self:sureToBuild()
	elseif self.m_nInterfaceType == 2 then -- 饰品商店
		if self.m_tData.buyNum >= self.m_tData.limitNum then
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT61)
			return
		end

		local string = string.sub(self.m_tData.cost, 2, -2) 
		local id = SplitStringWithSeparator(string, ",")[1]
		local num = SplitStringWithSeparator(string, ",")[2]

		if not JudgeMoneyIsEnough(tonumber(id), tonumber(num), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToBuild) then
			return
		end

		self:sureToBuild()
	elseif self.m_nInterfaceType == 5 then -- 食品商店
		WndPurchase:showBuyInterface(self.m_tData.mainType, self.m_tData.initData.shopItemId, nil, nil, nil, nil, nil, 3, nil, self.m_tData.initData.id)
	elseif self.m_nInterfaceType == 7 then -- 背包
		if self.m_tData.maintype == 30 then
			self:sureToBuild()
		else
			if self.m_tData.maintype == 32 and self.m_tData.subtype == 1 then
				if #SceneKidHome.m_tKidData > 0 then
					WndKidFeed:showInterface(SceneKidHome.m_tKidData[1], 1)
				else
					MsgBoxManager:showTipBox(LocalStrings.KID_TEXT62)
				end
			elseif self.m_tData.maintype == 32 and self.m_tData.subtype == 2 then
				if #SceneKidHome.m_tKidData > 0 then
					WndKidFeed:showInterface(SceneKidHome.m_tKidData[1], 2)
				else
					MsgBoxManager:showTipBox(LocalStrings.KID_TEXT62)
				end
			elseif self.m_tData.maintype == 32 and self.m_tData.subtype == 3 then
				if #SceneKidHome.m_tKidData > 0 then
					WndKidFeed:showInterface(SceneKidHome.m_tKidData[1], 3)
				else
					MsgBoxManager:showTipBox(LocalStrings.KID_TEXT62)
				end
			elseif self.m_tData.maintype == 32 and self.m_tData.subtype == 7 then
				if #SceneKidHome.m_tKidData > 0 then
					WndKidFeed:showInterface(SceneKidHome.m_tKidData[1], 4)
				else
					MsgBoxManager:showTipBox(LocalStrings.KID_TEXT62)
				end
			elseif self.m_tData.maintype == 32 and self.m_tData.subtype == 8 then
				if #SceneKidHome.m_tKidData > 0 then
					WndKidFeed:showInterface(SceneKidHome.m_tKidData[1], 5)
				else
					MsgBoxManager:showTipBox(LocalStrings.KID_TEXT62)
				end
			end
		end
	else

	end
end

--@brief 	确定回调
function CellKidBagItem:sureToBuild()
	-- body
	if self.m_nInterfaceType == 7 then
		local bIsExist = SceneKidHome:bIsExistTheSameOrnaments(self.m_tData.id)
		if bIsExist then
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT116)
			return 
		end
		SceneKidHome:buildNewBuilding(self.m_tData.id, 2)
	else
		local bIsExist = SceneKidHome:bIsExistTheSameOrnaments(self.m_tData.itemId)
		-- if bIsExist then
		-- 	MsgBoxManager:showTipBox(LocalStrings.KID_TEXT116)
		-- 	return 
		-- end
		SceneKidHome:buildNewBuilding(self.m_tData.itemId, 1)
	end
	WndKidManager:closeWindow()
end

--@brief	加载
function CellKidBagItem:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellKidBagItem")
	self.m_root:addChild(celElement)

	self:_update()

	AdaptLanguage(self)
end

--@brief 	设置数量上限
function CellKidBagItem:setBuildingNum()
	-- body
	local buildNum = GetElement(self.m_root, "buildNum_CellKidBagItem", WZUILabelTTF)
	if buildNum then
		buildNum:setText(self.m_tData.buyNum .. "/" .. self.m_tData.limitNum)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellKidBagItem:_update()
	-- body
	--物品名字
	local buildName = GetElement(self.m_root, "buildName_CellKidBagItem", WZUILabelTTF)
	if buildName then
		if self.m_nInterfaceType == 5 then
			local basicInfo = GDatatab_item["id_" .. self.m_tData.initData.shopItemId]
			buildName:setText(basicInfo.name)
		elseif self.m_nInterfaceType == 1 or self.m_nInterfaceType == 2 then
			local basicInfo = GDatatab_item["id_" .. self.m_tData.itemId]
			buildName:setText(basicInfo.name)
		elseif self.m_nInterfaceType == 7 then
			buildName:setText(self.m_tData.basicInfo.name)
		else
			buildName:setText(self.m_tData.name)
		end
	end
	--草地
	local img9GoodBk = GetElement(self.m_root, "img9GoodBk_CellKidBagItem", WZUI9Image)
	--数量
	local conBtm = GetElement(self.m_root, "conBtm_CellKidBagItem", WZUIContainer)
	if self.m_nType == 1 and (self.m_nInterfaceType == 1 or self.m_nInterfaceType == 2) then
		img9GoodBk:setVisible(false)
		conBtm:setVisible(true)
		buildName:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
		buildName:setRelativePosition(GlobalMethod:ccp(0.043,0.92))
		self:setBuildingNum()
	else
		img9GoodBk:setVisible(false)
		conBtm:setVisible(false)
		buildName:setRelativePosition(GlobalMethod:ccp(0.4, 0.9))
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "vn" then
			buildName:setRelativePosition(GlobalMethod:ccp(0.5, 0.9))
			buildName:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
		end
	end
	--图标
	local imgBuild = GetElement(self.m_root, "imgBuild_CellKidBagItem", WZUIImage)
	if imgBuild then
		if self.m_nInterfaceType == 5 then
			local tTempData = GDatatab_item["id_" .. self.m_tData.initData.shopItemId]
			imgBuild:setFile(tTempData.icon)
		elseif self.m_nInterfaceType == 1 or self.m_nInterfaceType == 2 then
			if self.m_tData.buildingData.type == 3 then
				imgBuild:setScale(1.5)
			elseif self.m_tData.buildingData.type == 5 or self.m_tData.buildingData.type == 4 then 
				imgBuild:setScale(0.35)
			elseif self.m_tData.buildingData.type == 6 then
				imgBuild:setScale(2)
			else
				imgBuild:setScale(0.7)
			end
			imgBuild:setFile(self.m_tData.buildingData.animation)
		else
			imgBuild:setFile(self.m_tData.basicInfo.icon)
			if self.m_nInterfaceType == 7 then
				if self.m_tData.basicInfo.main_type == 30 then
					if self.m_tData.basicInfo.sub_type == 4 then
						imgBuild:setScale(1.5)
					elseif self.m_tData.basicInfo.sub_type == 5 or self.m_tData.basicInfo.sub_type == 6 then
						imgBuild:setScale(0.35)
					elseif self.m_tData.basicInfo.sub_type == 7 then
						imgBuild:setScale(2)
					else
						imgBuild:setScale(0.7)
					end
				end
			end
		end
	end
	--拥有或消耗
	local ftxtCost = GetElement(self.m_root, "ftxtCost_CellKidBagItem", WZUIFreeTextBox)
	if ftxtCost then
		if self.m_nInterfaceType == 5 then
			
			local sFormat = [[<I Z="0.4">%s</I><T C="255,227,116" S="22" P="1">%d</T>]]
			local basicData = GDatatab_item["id_" .. self.m_tData.initData.moneyId]
			ftxtCost:setShowText(string.format(sFormat, basicData.icon, self.m_tData.initData.floorPrice))
		elseif self.m_nInterfaceType == 1 or self.m_nInterfaceType == 2 then
			
			local sFormat = [[<I Z="0.4">%s</I><T C="255,227,116" S="22" P="1">%d</T>]]
			local string = string.sub(self.m_tData.cost, 2, -2) 
			local id = SplitStringWithSeparator(string, ",")[1]
			local num = SplitStringWithSeparator(string, ",")[2]

			local basicData = GDatatab_item["id_" .. id]
			ftxtCost:setShowText(string.format(sFormat, basicData.icon, tonumber(num)))
		else
			
			local sFormat = [[<T C="255,227,116" S="22" P="1">%s%d</T>]]
			ftxtCost:setShowText(string.format(sFormat, LocalStrings.PETHAS, self.m_tData.lastNum))
		end
	end
	--物品描述
	self:_showDesc()
end

--@brief 	物品描述
function CellKidBagItem:_showDesc()
	-- body
	
	local ftbDesc = GetElement(self.m_root, "ftbDesc_CellKidBagItem", WZUIFreeTextBox)
	
	local strFormat1 = [[<T C="127,70,26" S="18" P="1">%s</T>]]
	local strFormat2 = [[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">%s</T>]]
	if ftbDesc then
		if self.m_nInterfaceType == 1 or self.m_nInterfaceType == 2 then
			local tTempData = GDatatab_item["id_" .. self.m_tData.itemId]
			if tTempData then
				
				ftbDesc:setShowText(string.format(strFormat2,LocalStrings.KID_TEXT53..":",tTempData.value))
				ftbDesc:setRelativePosition(GlobalMethod:ccp(0.04,0.265))
			end
		elseif self.m_nInterfaceType == 7 then
			if self.m_tData.basicInfo.main_type == 30 then
				local tBuildData = GDatatab_house_building["id_" .. self.m_tData.basicInfo.id]
				if tBuildData and tBuildData.type == 1 then
					
					ftbDesc:setShowText(string.format(strFormat2,LocalStrings.KID_TEXT53..":",self.m_tData.basicInfo.value))
					ftbDesc:setRelativePosition(GlobalMethod:ccp(0.04,0.265))
				end
			elseif self.m_tData.basicInfo.main_type == 32 then
				local tempFormat = [[<T C="127,70,26" S="16" P="1">%s</T>]]
				ftbDesc:setShowText(string.format(tempFormat,self.m_tData.basicInfo.desc))
			end
		elseif self.m_nInterfaceType == 5 then
			local tTempData = GDatatab_item["id_" .. self.m_tData.initData.shopItemId]
			if tTempData then
				
				ftbDesc:setShowText(string.format(strFormat1,tTempData.desc))
			end
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function CellKidBagItem:_adaptLanguage_tr( )
	local txtOwn = GetElement(self.m_root, "txtOwn_CellKidBagItem", WZUILabelTTF)
	txtOwn:setScale(0.7)
	txtOwn:setRelativePosition(GlobalMethod:ccp(0.855,1.032))
	
	local txtDesc = GetElement(self.m_root, "txtDesc_CellKidBagItem", WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(260))
	txtDesc:setAnchorPoint(GlobalMethod:ccp(0,0))
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.05,0.15))
end

function CellKidBagItem:_adaptLanguage_en( )
	local txtOwn = GetElement(self.m_root, "txtOwn_CellKidBagItem", WZUILabelTTF)
	txtOwn:setRelativePosition(GlobalMethod:ccp(0.85,1.032))
	
	local txtDesc = GetElement(self.m_root, "txtDesc_CellKidBagItem", WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(260))
	txtDesc:setAnchorPoint(GlobalMethod:ccp(0,0))
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.05,0.15))
end

function CellKidBagItem:_adaptLanguage_ug( )	
	local txtDesc = GetElement(self.m_root, "txtDesc_CellKidBagItem", WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(260))
	txtDesc:setAnchorPoint(GlobalMethod:ccp(0,0))
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.05,0.15))
end

function CellKidBagItem:_adaptLanguage_pt( )
	local txtOwn = GetElement(self.m_root, "txtOwn_CellKidBagItem", WZUILabelTTF)
	txtOwn:setRelativePosition(GlobalMethod:ccp(0.87,1.032))

	local txtDesc = GetElement(self.m_root, "txtDesc_CellKidBagItem", WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(260))
	
	txtDesc:setAnchorPoint(GlobalMethod:ccp(0,0))
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.05,0.15))
end

function CellKidBagItem:_adaptLanguage_es( )
	local txtOwn = GetElement(self.m_root, "txtOwn_CellKidBagItem", WZUILabelTTF)
	txtOwn:setRelativePosition(GlobalMethod:ccp(0.87,1.032))

	local txtDesc = GetElement(self.m_root, "txtDesc_CellKidBagItem", WZUILabelTTF)
	txtDesc:setScale(0.7)
	txtDesc:setDimensions(GlobalMethod:CCSize(300))
	
	txtDesc:setAnchorPoint(GlobalMethod:ccp(0,0))
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.05,0.15))
end

function CellKidBagItem:_adaptLanguage_vn( )
	local ftbDesc = GetElement(self.m_root, "ftbDesc_CellKidBagItem", WZUIFreeTextBox)
	ftbDesc:setMaxWidth(330)
	ftbDesc:setScale(0.65)
end
-------------------------------------语言适配End----------------------------------------