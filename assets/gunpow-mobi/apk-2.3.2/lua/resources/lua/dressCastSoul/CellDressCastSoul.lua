--CellDressCastSoul.lua
--@brief	CellDressCastSoul的UI模块
--@date		2020/05/20
--@author	XTX
--@note		时装铸魂Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDressCastSoul:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDressCastSoul:onExit(element)
	self:_unInit()
end

--@brief 	加载
function CellDressCastSoul:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellDressCastSoul")
    self.m_root:addChild(celElement)
    self.m_bIsLoaded = true 

    self:_update()

	AdaptLanguage(self)
end

--@brief 	点击套装回调
function CellDressCastSoul:onClickSuit(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndDressCastSoul:changeSuitSelState(self)
end

--@brief 	设置选中状态
function CellDressCastSoul:setSelState(bSel)
	-- body
	self.m_bIsSelState = bSel 
	if self.m_bIsLoaded == false then return end 

	if bSel then 
		GetElement(self.m_root, "img9Sel_CellDressCastSoul", WZUI9Image):setVisible(self.m_bIsSelState)
		GetElement(self.m_root, "img9BK_CellDressCastSoul", WZUI9Image):setFile("ui/common/frame_lieb_02.png")
		local txtName = GetElement(self.m_root, "txtName_CellDressCastSoul", WZUILabelTTF)
		if self.m_nType == 3 then 
			txtName:setFontSize(18)
		else
			txtName:setFontSize(20)
		end
		txtName:setColor(GlobalMethod:ccc3(255,236,193))
		txtName:setEnableStroke(true)
		txtName:setStrokeColor(GlobalMethod:ccc3(132,66,29))
		txtName:setStrokeSize(2)
	else
		GetElement(self.m_root, "img9Sel_CellDressCastSoul", WZUI9Image):setVisible(self.m_bIsSelState)
		GetElement(self.m_root, "img9BK_CellDressCastSoul", WZUI9Image):setFile("ui/common/frame_lieb.png")
		local txtName = GetElement(self.m_root, "txtName_CellDressCastSoul", WZUILabelTTF)
		txtName:setFontSize(18)
		txtName:setColor(GlobalMethod:ccc3(127,70,26))
		txtName:setEnableStroke(false)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellDressCastSoul:_update()
	-- body
	local tData = self.m_tData
	if tData == nil then return end 

	local basicInfo 
	local quality = nil 
	if self.m_nType == 1 then 
		for i = 1, #tData.suitId do
			basicInfo = GDatatab_item["id_" .. tData.suitId[i]]
			if basicInfo and basicInfo.sub_type == 2 then 
				local _, _, bIsAdvance = GetDressAdvanceData(tData.suitId[i])
			    if bIsAdvance then 
			    	quality = basicInfo.quality + 1
			    end
				break 
			end
		end
	elseif self.m_nType == 2 then 
		basicInfo = GDatatab_item["id_" .. tData.suitId]
		local _, _, bIsAdvance = GetDressAdvanceData(tData.suitId)
	    if bIsAdvance then 
	    	quality = basicInfo.quality + 1
	    end
	elseif self.m_nType == 3 then 
		basicInfo = GDatatab_item["id_" .. tData.suitId]
	end
	if basicInfo == nil then return end 
	--套装品质
	local imgQuality = GetElement(self.m_root, "imgQuality_CellDressCastSoul", WZUIImage)
	if imgQuality then 
		if quality then 
			imgQuality:setFile(g_tShopItemQuality[quality + 1])
		else
			imgQuality:setFile(g_tShopItemQuality[basicInfo.quality + 1])
		end
	end
	--套装图标
	local imgSuitIcon = GetElement(self.m_root, "imgSuitIcon_CellDressCastSoul", WZUIImage)
	if imgSuitIcon then 
		imgSuitIcon:setFile(basicInfo.icon)
	end
	--套装名字
	local txtName = GetElement(self.m_root, "txtName_CellDressCastSoul", WZUILabelTTF)
	if txtName then 
		txtName:setText(basicInfo.name)
	end
	--收集进度
	if self.m_nType == 1 then 
		local prgCollect = GetElement(self.m_root, "prgCollect_CellDressCastSoul", WZUIProgress)
		if prgCollect then 
			local nPercentage = math.floor(tData.count * 100 / GetTableLen(tData.suitId))
			prgCollect:setPercentage(nPercentage > 100 and 100 or nPercentage)
		end
		local txtProgress = GetElement(self.m_root, "txtProgress_CellDressCastSoul", WZUILabelTTF)
		if txtProgress then 
			txtProgress:setText(tData.count .. "/" .. GetTableLen(tData.suitId))
		end

		if tData.count >= GetTableLen(tData.suitId) then 
			GetElement(self.m_root, "conCollectPrg_CellDressCastSoul", WZUIContainer):setVisible(false)
			GetElement(self.m_root, "imgCorner_CellDressCastSoul", WZUIImage):setVisible(true)
		else
			GetElement(self.m_root, "imgCorner_CellDressCastSoul", WZUIImage):setVisible(false)
			GetElement(self.m_root, "conCollectPrg_CellDressCastSoul", WZUIContainer):setVisible(true)
		end
	elseif self.m_nType == 2 then 
		GetElement(self.m_root, "conCollectPrg_CellDressCastSoul", WZUIContainer):setVisible(false)
		if tData.count >= 1 then 
			GetElement(self.m_root, "imgCorner_CellDressCastSoul", WZUIImage):setVisible(true)
		else
			GetElement(self.m_root, "imgCorner_CellDressCastSoul", WZUIImage):setVisible(false)
		end
	elseif self.m_nType == 3 then 
		imgSuitIcon:setVisible(false)
		GetElement(self.m_root, "conCollectPrg_CellDressCastSoul", WZUIContainer):setVisible(false)
		local conTitle = GetElement(self.m_root, "conTitle_CellDressCastSoul", WZUIContainer)
		conTitle:setVisible(true)
		local tempPoint = GlobalMethod:ccp(0.5,1)
		local txtTitle = GetElement(self.m_root, "txtTitle_CellDressCastSoul", WZUILabelTTF)
		local strTitle = tData.name
    	CreateDesiSpine(conTitle, txtTitle, strTitle, tempPoint, true, 0.5)
		if tData.count >= 1 then 
			GetElement(self.m_root, "imgCorner_CellDressCastSoul", WZUIImage):setVisible(true)
		else
			GetElement(self.m_root, "imgCorner_CellDressCastSoul", WZUIImage):setVisible(false)
		end
	end

	self:setSelState(self.m_bIsSelState)
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function CellDressCastSoul:_adaptLanguage_vn()
	local txtName = GetElement(self.m_root,"txtName_CellDressCastSoul",WZUILabelTTF)
	txtName:setScale(0.65)
	txtName:setDimensions(GlobalMethod:CCSize(180))
end
-------------------------------------语言适配end----------------------------------------
