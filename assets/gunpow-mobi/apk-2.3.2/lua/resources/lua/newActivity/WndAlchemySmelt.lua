--WndAlchemySmelt.lua
--@brief	WndAlchemySmelt的UI模块
--@date		2022/02/08
--@author	XTX
--@note		丹道修真活动-聚炼界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAlchemySmelt:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAlchemySmelt:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
end

--@brief    onenter函数已执行
function WndAlchemySmelt:onEnterTransitionDidFinish(element)
    WZLog("WndAlchemySmelt:onEnterTransitionDidFinish")
    self:setSmeltData()
	self:_initStaticText()
end

function WndAlchemySmelt:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击自选奖励按钮回调
function WndAlchemySmelt:onClickSort(element)
    WZLog("WndAlchemySmelt:onClickSort", element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if WndAlchemy and WndAlchemy.m_root then 
    	WZLog("WndAlchemySmelt:goto WndAlchemy", element:getTag())
		WndAlchemy:onClickBigReward(element)
	end
end

--@brief 	点击聚炼榜按钮回调
function WndAlchemySmelt:onClickRank(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndShopRank:showInterface(18, self.m_nActivityId, nil, 2) 
end

--@brief	切换聚炼的丹药类型
function WndAlchemySmelt:onClickSelect(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_nSelIndex == nTag then return end 
	for i = 1, 2 do 
		local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndAlchemySmelt", WZUIContainer)
		local img9Sel = GetElement(conItem, "img9Sel_WndAlchemySmelt", WZUI9Image)
		if i == nTag then 
			img9Sel:setVisible(true)
		else
			img9Sel:setVisible(false)
		end
	end
	self.m_nSelIndex = nTag
	local tCurData = self.m_tActList[self.m_nSelIndex]
	self:setGridVisible()
	self:_initGrid()
end

--@brief 	点击一键放入按钮回调
function WndAlchemySmelt:onClickPut(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	for i = 1, 2 do 
		local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndAlchemySmelt", WZUIContainer)
		local img9Sel = GetElement(conItem, "img9Sel_WndAlchemySmelt", WZUI9Image)
		if i == nTag then 
			img9Sel:setVisible(true)
		else
			img9Sel:setVisible(false)
		end
	end
	if self.m_nSelIndex ~= nTag then 
		self:_initGrid()
	end
	self.m_nSelIndex = nTag
	local tCurData = self.m_tActList[self.m_nSelIndex]
	self:setGridVisible()
	if self.m_nEquipNum >= tCurData[2] then 
		MsgBoxManager:showTipBox(LocalStrings.ALCHEMY_TEXT1[25])
	end 
	if tCurData[3] <= 0 or tCurData[3] - self.m_nEquipNum <= 0 then 
		MsgBoxManager:showTipBox(LocalStrings.ALCHEMY_TEXT1[15])
		return 
	end
	for i = 1, tCurData[2] do
		local conGrid = GetElement(self.m_root, "conGrid" .. i .. "_WndAlchemySmelt", WZUIContainer)
		local imgAdd = GetElement(conGrid, "imgAdd_WndAlchemySmelt", WZUIImage)
		local imgIcon = GetElement(conGrid, "imgIcon_WndAlchemySmelt", WZUIImage)
		if imgAdd:isVisible() then 
			if tCurData and tCurData[3] - self.m_nEquipNum > 0 then 
				local basicData = GDatatab_item["id_" .. tCurData[1]]
				imgIcon:setFile(basicData.icon)
				imgAdd:setVisible(false)
				self.m_nEquipNum = self.m_nEquipNum + 1
			else
				break
			end
		end
	end

	self:updateUseElixirNum()
end

--@brief 	点击+号按钮回调
function WndAlchemySmelt:onClickAdd(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if #self.m_tActList == 0 or self.m_nSelIndex == nil then 
		MsgBoxManager:showTipBox(LocalStrings.ALCHEMY_TEXT1[15])
		return 
	end
	local nTag = element:getTag()
	local tCurData = self.m_tActList[self.m_nSelIndex]
	if tCurData == nil then 
		MsgBoxManager:showTipBox(LocalStrings.ALCHEMY_TEXT1[15])
		return 
	end
	local conGrid = GetElement(self.m_root, "conGrid" .. nTag .. "_WndAlchemySmelt", WZUIContainer)
	local imgAdd = GetElement(conGrid, "imgAdd_WndAlchemySmelt", WZUIImage)
	local imgIcon = GetElement(conGrid, "imgIcon_WndAlchemySmelt", WZUIImage)
	if imgAdd:isVisible() then 
		if tCurData and tCurData[3] - self.m_nEquipNum > 0 then 
			local basicData = GDatatab_item["id_" .. tCurData[1]]
			imgIcon:setFile(basicData.icon)
			imgAdd:setVisible(false)
			self.m_nEquipNum = self.m_nEquipNum + 1
		else
			MsgBoxManager:showTipBox(LocalStrings.ALCHEMY_TEXT1[15])
		end
	else
		self.m_nEquipNum = self.m_nEquipNum - 1
		imgIcon:setFile("")
		imgAdd:setVisible(true)
	end

	self:updateUseElixirNum()
end

--@brief 	点击规则按钮回调
function WndAlchemySmelt:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndSingleMapDesc:showInterface1(LocalStrings.ALCHEMY_TEXT3) 
end

--@brief 	点击聚炼按钮回调
function WndAlchemySmelt:onClickSmelt(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nChooseReward == 0 then 
    	WndAlchemy:onClickBigReward(2)

		self.m_nChooseReward = 1
		SaveOperateTimes("ALCHEMYACTIVITYID_TWO", self.m_nActivityId)
    	return 
    end
	local tData = {}
	local tCurData = self.m_tActList[self.m_nSelIndex]
	if tCurData[1] == 160203 then 
		tData.optType = 0
	else
		tData.optType = 1
	end

	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化静态文本
function WndAlchemySmelt:_initStaticText()
	GetElement(self.m_root, "txtTitleName_WndAlchemySmelt", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[12])
	GetElement(self.m_root, "txtRank_WndAlchemySmelt", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[8])
	GetElement(self.m_root, "txtNoData_WndAlchemySmelt", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[15])

	GetElement(self.m_root, "txtSmelt1_WndAlchemySmelt", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[14])
	GetElement(self.m_root, "txtSmelt2_WndAlchemySmelt", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[14])
	GetElement(self.m_root, "txtSmelt3_WndAlchemySmelt", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[14])
	GetElement(self.m_root, "txtPut1_WndAlchemySmelt", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[13])
	GetElement(self.m_root, "txtPut2_WndAlchemySmelt", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[13])

	GetElement(self.m_root, "txtBtn7_WndAlchemySmelt", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])
end

--@brief 	显示丹药列表
function WndAlchemySmelt:showElixirList()
	GetElement(self.m_root, "conItem1_WndAlchemySmelt", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conItem2_WndAlchemySmelt", WZUIContainer):setVisible(false)
	local txtNoData = GetElement(self.m_root, "txtNoData_WndAlchemySmelt", WZUILabelTTF)
	if #self.m_tActList == 0 then 
		txtNoData:setVisible(true)
		return 
	end
	txtNoData:setVisible(false)
	for i = 1, #self.m_tActList do
		local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndAlchemySmelt", WZUIContainer)
		conItem:setVisible(true)
		local basicData = GDatatab_item["id_" .. self.m_tActList[i][1]]
		local imgIcon = GetElement(conItem, "imgIcon_WndAlchemySmelt", WZUIImage)
		imgIcon:setFile(basicData.icon)
		local imgQuality = GetElement(conItem, "imgQuality_WndAlchemySmelt", WZUIImage)
		imgQuality:setFile(g_tQualityRect[basicData.quality])
		local txtItemName = GetElement(conItem, "txtItemName_WndAlchemySmelt", WZUILabelTTF)
		txtItemName:setText(basicData.name)
		local txtItemNum = GetElement(conItem, "txtItemNum_WndAlchemySmelt", WZUILabelTTF)
		txtItemNum:setText(self.m_tActList[i][3])
		if self.m_nSelIndex == nil then 
			self.m_nSelIndex = 1
			GetElement(conItem, "img9Sel_WndAlchemySmelt", WZUI9Image):setVisible(true)
			self:setGridVisible()
		end
	end
end

--@brief 	初始化格子
function WndAlchemySmelt:_initGrid()
	if self.m_nEquipNum ~= 0 then 
		self:updateSmeltData()
	end
	self.m_nEquipNum = 0
	for i = 1, 5 do
		local conGrid = GetElement(self.m_root, "conGrid" .. i .. "_WndAlchemySmelt", WZUIContainer)
		local imgAdd = GetElement(conGrid, "imgAdd_WndAlchemySmelt", WZUIImage)
		local imgIcon = GetElement(conGrid, "imgIcon_WndAlchemySmelt", WZUIImage)
		imgIcon:setFile("")
		imgAdd:setVisible(true)
	end
end

--@brief 	刷新丹药剩余数量
function WndAlchemySmelt:updateUseElixirNum()
	local conItem = GetElement(self.m_root, "conItem" .. self.m_nSelIndex .. "_WndAlchemySmelt", WZUIContainer)
	local txtItemNum = GetElement(conItem, "txtItemNum_WndAlchemySmelt", WZUILabelTTF)
	txtItemNum:setText(self.m_tActList[self.m_nSelIndex][3] - self.m_nEquipNum)

	if self.m_nEquipNum == self.m_tActList[self.m_nSelIndex][2] then 
		GetElement(self.m_root, "btnSmelt_WndAlchemySmelt", WZUIButton):setTouchEnable(true)
	else
		GetElement(self.m_root, "btnSmelt_WndAlchemySmelt", WZUIButton):setTouchEnable(false)
	end
end

--@brief 	显示开启动画
function WndAlchemySmelt:showOpenAction()
	-- body
	local spineSmelt = GetElement(self.m_root, "spineSmelt_WndAlchemySmelt", WZUISpine)
	spineSmelt:setVisible(true)
	if spineSmelt then 
		local spinePath = "activity/ui_julian"
		local existSpine = CheckEffectFile(spinePath)
		if existSpine then 
			spineSmelt:setFileAtlas(spinePath .. ".atlas")
			spineSmelt:setFileJson(spinePath .. ".json")
			spineSmelt:play("animation", false)
		else
			local _sIndex = "ui_julian"
	        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(14210,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
	        end
		end
		spineSmelt:enableSchedule("showShootReward", 0.4)
	end
end

--@brief 	显示开启奖励
function WndAlchemySmelt:showShootReward()
	-- body
	local spineSmelt = GetElement(self.m_root, "spineSmelt_WndAlchemySmelt", WZUISpine)
	spineSmelt:disableSchedule()
	spineSmelt:setVisible(false)

	self:_afterCloseReward()
end

--@brief 	这是格子显示与否
function WndAlchemySmelt:setGridVisible()
	local tCurData = self.m_tActList[self.m_nSelIndex]
	for i = 1, 5 do 
		if i <= tCurData[2] then 
			GetElement(self.m_root, "conGrid" .. i .. "_WndAlchemySmelt", WZUIContainer):setVisible(true)
		else 
			GetElement(self.m_root, "conGrid" .. i .. "_WndAlchemySmelt", WZUIContainer):setVisible(false)
		end
	end

	if tCurData[2] == 2 then 
		GetElement(self.m_root, "conGrid2_WndAlchemySmelt", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.12))
	else
		GetElement(self.m_root, "conGrid2_WndAlchemySmelt", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.28,0.18))
	end
end
-------------------------------------私有方法模块End----------------------------------------
