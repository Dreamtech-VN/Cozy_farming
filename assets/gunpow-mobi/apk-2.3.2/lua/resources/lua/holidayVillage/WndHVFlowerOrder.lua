--WndHVFlowerOrder.lua
--@brief	WndHVFlowerOrder的UI模块
--@date		2023/01/03
--@author	XTX
--@note		鲜花订单界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVFlowerOrder:onEnter(element)
	self.m_root = element

	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerOrder(0, -1)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVFlowerOrder:onExit(element)
	self:_unInit()
end

--@brief 	加载完成回调
function WndHVFlowerOrder:onEnterTransitionDidFinish(element)
	WZLog("WndHVFlowerOrder:onEnterTransitionDidFinish")
	self:_initStaticText()
	self.m_root:enableSchedule("caculateTime", 1)
end

--@brief 	点击关闭按钮回调
function WndHVFlowerOrder:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, WndHVFlowerOrder , true)
end

--@brief 	点击切换订单回调
function WndHVFlowerOrder:onOrderCallBack(tData, tCell)
	if self.m_tSelOrder.orderId == tData.orderId then return end 

	if self.m_tCellSel then 
		self.m_tCellSel:setSelState(false)
	end
	self.m_tCellSel = tCell
	self.m_tSelOrder = tData
	self.m_tCellSel:setSelState(true)
	self:_showOrderContent()
end

--@brief    点击奖励回调
function WndHVFlowerOrder:onClickItem(tCell, nTag, tData)
    WZLog("WndHVFlowerOrder:onClickItem ")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root, self.m_root, 1, tData, false, nil, true)
end

--@brief 	点击榜单按钮回调
function WndHVFlowerOrder:onClickRank(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		WndShopRank:showInterface(38, 0)
	elseif nTag == 2 then 
		WndHVOrderFirst:showInterface()
	end
end

--@brief 	点击确认按钮回调
function WndHVFlowerOrder:onClickSure(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then --接受订单
		ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerOrder(1, self.m_tSelOrder.orderId)
	elseif nTag == 2 then --收入囊中
		pushEquipInList()
		g_bIsShowWndDressUp = true
    	g_tTempItemForLaterShow = {}
		GetElement(self.m_root, "conSubmit_WndHVFlowerOrder", WZUIContainer):setVisible(false)
		self:_setBlackBkVisible(true)
	elseif nTag == 3 then --接受订单
		ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerOrder(1, -1)
	end
end

--@brief 	点击接受/提交订单按钮回调
function WndHVFlowerOrder:onClickOp(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tSelOrder.status <= 0 then 
		self:_setBlackBkVisible(false)
		GetElement(self.m_root, "btnAskSure_WndHVFlowerOrder", WZUIButton):setTag(1)
		GetElement(self.m_root, "conSecondAsk_WndHVFlowerOrder", WZUIContainer):setVisible(true)
	elseif self.m_tSelOrder.status == 2 then 
		g_bIsShowWndDressUp = false
    	g_tTempItemForLaterShow = {}
		ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerOrder(2, self.m_tSelOrder.orderId)
	end
end

--@brief 	点击一键接受按钮回调
function WndHVFlowerOrder:onClickAcceptAll(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self:_setBlackBkVisible(false)
	GetElement(self.m_root, "btnAskSure_WndHVFlowerOrder", WZUIButton):setTag(3)
	GetElement(self.m_root, "conSecondAsk_WndHVFlowerOrder", WZUIContainer):setVisible(true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置静态文本
function WndHVFlowerOrder:_initStaticText()
	GetElement(self.m_root, "txtOrderReward_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[11] .. ":")
	GetElement(self.m_root, "txtBtnRank1_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[3])
	GetElement(self.m_root, "txtBtnRank2_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[4])
	GetElement(self.m_root, "txtAsk_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[10])
	GetElement(self.m_root, "txtAsk1_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[13])
	GetElement(self.m_root, "txtSubmitTitle_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[7])
	GetElement(self.m_root, "txtNullTip_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[18])
	GetElement(self.m_root, "txtGetIn_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[13])
	GetElement(self.m_root, "txtBtnOneKey1_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[18])
	GetElement(self.m_root, "txtBtnOneKey2_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[18])
	GetElement(self.m_root, "txtBtnOneKey3_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[18])
	GetElement(self.m_root, "txtSeedNumW_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[19])

	self:_setBallAni()
end

--@brief 	设置动态文本
function WndHVFlowerOrder:_initDynamicText()
	GetElement(self.m_root, "txtPeriod_WndHVFlowerOrder", WZUILabelTTF):setText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT3[14], self.m_nPeriods))
	local nSeconds = self.m_nEndTimes - SystemTime:getServerTime()
	if nSeconds > 0 then 
		local strTime = returnToTimeFormat_Day(nSeconds)
		GetElement(self.m_root, "txtEndTime_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.MAGIC_STONE_TEXT24 .. ":" .. strTime)
	else
		GetElement(self.m_root, "conRight_WndHVFlowerOrder", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conNull_WndHVFlowerOrder", WZUIContainer):setVisible(true)
	end
end

--@brief 	刷新
function WndHVFlowerOrder:_update()
	self:_initDynamicText()
	self:_createOrderList()
end

--@brief 	创建鲜花订单列表
function WndHVFlowerOrder:_createOrderList()
	local tbOrderList = GetElement(self.m_root, "tbOrderList_WndHVFlowerOrder", WZUITableContainer)
	tbOrderList:cleanTable()
	local bHaveNoAcceptOrder = false 
	self.m_tLeftCell = {}

	for i = 1, #self.m_tOrderList do
		local element, tNewObj = CellOrderItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tOrderList[i])
			if self.m_tSelOrder == nil then 
				self.m_tSelOrder = self.m_tOrderList[i]
				self.m_tCellSel = tNewObj
				tNewObj:setSelState(true)
				self:_showOrderContent()
			elseif self.m_tSelOrder.orderId == self.m_tOrderList[i].orderId then 
				self.m_tCellSel = tNewObj
				tNewObj:setSelState(true)
				self:_showOrderContent()
			end

			tbOrderList:setCellElement(element)

			table.insert(self.m_tLeftCell, tNewObj)
		end
		if self.m_tOrderList[i].status == 0 and not bHaveNoAcceptOrder then 
			bHaveNoAcceptOrder = true 
		end
	end
	if not bHaveNoAcceptOrder then 
		GetElement(self.m_root, "btnOneKeyOp_WndHVFlowerOrder", WZUIButton):setTouchEnable(false)
	end
end

--@brief 	显示选中的订单的内容
function WndHVFlowerOrder:_showOrderContent()
	if self.m_tSelOrder == nil then return end 

	--鲜花名字
	local txtFlowerName = GetElement(self.m_root, "txtFlowerName_WndHVFlowerOrder", WZUILabelTTF)
	local seedData = GDatatab_holiday_seed["id_" .. self.m_tSelOrder.basicInfo.plant_id]
	local basicData = GDatatab_item["id_" .. seedData.item_id]
	if txtFlowerName then 
		txtFlowerName:setText(basicData.name)
	end
	--花语
	local txtFlowerWords = GetElement(self.m_root, "txtFlowerWords_WndHVFlowerOrder", WZUILabelTTF)
	if txtFlowerWords then 
		txtFlowerWords:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[15] .. ":" .. self.m_tSelOrder.basicInfo.desc1)
	end
	--详情
	local txtFlowerDesc = GetElement(self.m_root, "txtFlowerDesc_WndHVFlowerOrder", WZUILabelTTF)
	if txtFlowerDesc then 
		txtFlowerDesc:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[12] .. ":" .. self.m_tSelOrder.basicInfo.desc2)
	end
	--收益
	local txtIncome = GetElement(self.m_root, "txtIncome_WndHVFlowerOrder", WZUILabelTTF)
	if txtIncome then 
		txtIncome:setText("")
	end
	--图标
	local imgFlowerIcon = GetElement(self.m_root, "imgFlowerIcon_WndHVFlowerOrder", WZUIImage)
	if imgFlowerIcon then 
		imgFlowerIcon:setFile(basicData.icon)
	end
	--奖励
	local tbRewards = GetElement(self.m_root, "tbRewards_WndHVFlowerOrder", WZUITableContainer)
	tbRewards:cleanTable()
	for i = 1, #self.m_tSelOrder.basicInfo.reward do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			element:setScale(0.7)
			tNewObj:setCellGoodLocalId(self.m_tSelOrder.basicInfo.reward[i][1], self.m_tSelOrder.basicInfo.reward[i][2], 17)
			tNewObj:setItemClickFun(self, self.onClickItem)

			tbRewards:setCellElement(element)
		end
	end
	--种子数量
	local ftxtSeedNum = GetElement(self.m_root, "ftxtSeedNum_WndHVFlowerOrder", WZUIFreeTextBox)
	local seedNumFormat = [[<I Z="0.6" P="1">%s</I><T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
	local seedIcon = string.gsub(basicData.icon, ".png", "_zz.png")
	local strSeedNum = string.format(seedNumFormat, seedIcon, self.m_tSelOrder.seedNum)
	if ftxtSeedNum then 
		ftxtSeedNum:setShowText(strSeedNum)
	end

	self:_showProgressAndStatus()
end

--@brief 	显示进度和按钮状态
function WndHVFlowerOrder:_showProgressAndStatus()
	--进度
	local txtProgress = GetElement(self.m_root, "txtProgress_WndHVFlowerOrder", WZUILabelTTF)
	if txtProgress then 
		txtProgress:setText(self.m_tSelOrder.progress .. "/" .. self.m_tSelOrder.basicInfo.num)
	end
	--状态
	local btnOrderOp = GetElement(self.m_root, "btnOrderOp_WndHVFlowerOrder", WZUIButton)
	local txtBtnOrder1 = GetElement(self.m_root, "txtBtnOrder1_WndHVFlowerOrder", WZUILabelTTF)
	local txtBtnOrder2 = GetElement(self.m_root, "txtBtnOrder2_WndHVFlowerOrder", WZUILabelTTF)
	local txtBtnOrder3 = GetElement(self.m_root, "txtBtnOrder3_WndHVFlowerOrder", WZUILabelTTF)
	if self.m_tSelOrder.status == 0 then --未接单
		btnOrderOp:setTouchEnable(true)
		txtBtnOrder1:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[8])
		txtBtnOrder2:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[8])
		txtBtnOrder3:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[8])
	elseif self.m_tSelOrder.status == 1 then --已接单
		btnOrderOp:setTouchEnable(false)
		txtBtnOrder1:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[7])
		txtBtnOrder2:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[7])
		txtBtnOrder3:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[7])
	elseif self.m_tSelOrder.status == 2 then --可领取
		btnOrderOp:setTouchEnable(true)
		txtBtnOrder1:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[7])
		txtBtnOrder2:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[7])
		txtBtnOrder3:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[7])
	elseif self.m_tSelOrder.status == 3 then --已领取
		btnOrderOp:setTouchEnable(false)
		txtBtnOrder1:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[16])
		txtBtnOrder2:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[16])
		txtBtnOrder3:setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[16])
	end
	if self.m_nEndTimes <= SystemTime:getServerTime() then 
		btnOrderOp:setTouchEnable(false)
	end

end

--brief 	计时器
function WndHVFlowerOrder:caculateTime(element, delta)
	if self.m_nEndTimes == nil then return end 

	local nSeconds = self.m_nEndTimes - SystemTime:getServerTime()
	if nSeconds > 0 then 
		local strTime = returnToTimeFormat_Day(nSeconds)
		GetElement(self.m_root, "txtEndTime_WndHVFlowerOrder", WZUILabelTTF):setText(LocalStrings.MAGIC_STONE_TEXT24 .. ":" .. strTime)
	else
		--只请求一次
		if self.m_bIsFirstTimeEnd then 
			self.m_bIsFirstTimeEnd = false 
			ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerOrder(0, -1)
		end
	end
end

--@brief 	设置界面半透明遮罩是否可见
function WndHVFlowerOrder:_setBlackBkVisible(bVisible)
	local elem = self.m_root:getChildElement("wnd_black_bg___")
    if elem ~= nil then 
        elem:setVisible(bVisible)
    end
end

--@brief 	提交订单奖励界面
function WndHVFlowerOrder:showSubmitReward()
	-- body
	self:_setBlackBkVisible(false)
	GetElement(self.m_root, "conSubmit_WndHVFlowerOrder", WZUIContainer):setVisible(true)

	local tbRewardsGet = GetElement(self.m_root, "tbRewardsGet_WndHVFlowerOrder", WZUITableContainer)
	tbRewardsGet:cleanTable()
	for i = 1, #self.m_tSelOrder.basicInfo.reward do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			element:setScale(0.7)
			tNewObj:setCellGoodLocalId(self.m_tSelOrder.basicInfo.reward[i][1], self.m_tSelOrder.basicInfo.reward[i][2], 17)
			tNewObj:setItemClickFun(self, self.onClickItem)

			tbRewardsGet:setCellElement(element)
		end
	end
end

--@brief 	显示开启动画
function WndHVFlowerOrder:showOpenAction()
	-- body
	--创建选中特效
	local spinePath = "ui/holidayVillage/ui_xhjm"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "ui_xhjm"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(10000, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndHVFlowerOrder", WZUISpine)
	if spineOpen then 
		if existSpine then 
			spineOpen:setVisible(true)
			self:_setBowlingPlayAni(false)
			spineOpen:enableSchedule("showShootReward", 1)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndHVFlowerOrder:showShootReward()
	-- body
	local spineOpen = GetElement(self.m_root, "spineOpen_WndHVFlowerOrder", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:setVisible(false)

	self:showSubmitReward()
end

--@brief 	设置待机特效
function WndHVFlowerOrder:_setBallAni()
	local spinePath = "ui/holidayVillage/ui_xhjm"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndHVFlowerOrder", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
		end
	else
		local _sIndex = "ui_xhjm"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(10000, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndHVFlowerOrder)
        end
	end
end

function WndHVFlowerOrder:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndHVFlowerOrder:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndHVFlowerOrder:_setBowlingPlayAni(bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndHVFlowerOrder", WZUISpine)
	WZLog("WndHVFlowerOrder:_setBowlingPlayAni", bLoop)
	if spineOpen then 
		spineOpen:play("wait", bLoop ~= nil and bLoop or true)
	end
end
-------------------------------------私有方法模块End----------------------------------------


----------------------------------------语言适配Begin---------------------------------------

function WndHVFlowerOrder:_adaptLanguage_vn(  )
	local txtBtnRank1 = GetElement(self.m_root, "txtBtnRank1_WndHVFlowerOrder", WZUILabelTTF)
	txtBtnRank1:setDimensions(GlobalMethod:CCSize(140,0))
	txtBtnRank1:setScale(0.6)
	local txtBtnRank2 = GetElement(self.m_root, "txtBtnRank2_WndHVFlowerOrder", WZUILabelTTF)
	txtBtnRank2:setDimensions(GlobalMethod:CCSize(140,0))
	txtBtnRank2:setScale(0.6)

	GetElement(self.m_root,"txtOrderReward_WndHVFlowerOrder",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,0))
	GetElement(self.m_root, "txtAsk1_WndHVFlowerOrder", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(400,0))
	GetElement(self.m_root, "txtGetIn_WndHVFlowerOrder", WZUILabelTTF):setFontSize(18)

	local txtBtnOrder1 = GetElement(self.m_root, "txtBtnOrder1_WndHVFlowerOrder", WZUILabelTTF)
	txtBtnOrder1:setDimensions(GlobalMethod:CCSize(140,0))
	txtBtnOrder1:setRelativePosition(GlobalMethod:ccp(0.5,0.535))
	txtBtnOrder1:setScale(0.8)
	local txtBtnOrder2 = GetElement(self.m_root, "txtBtnOrder2_WndHVFlowerOrder", WZUILabelTTF)
	txtBtnOrder2:setDimensions(GlobalMethod:CCSize(140,0))
	txtBtnOrder2:setRelativePosition(GlobalMethod:ccp(0.5,0.535))
	txtBtnOrder2:setScale(0.8)
	local txtBtnOrder3 = GetElement(self.m_root, "txtBtnOrder3_WndHVFlowerOrder", WZUILabelTTF)
	txtBtnOrder3:setDimensions(GlobalMethod:CCSize(140,0))
	txtBtnOrder3:setRelativePosition(GlobalMethod:ccp(0.5,0.535))
	txtBtnOrder3:setScale(0.8)

	local txtFlowerWords = GetElement(self.m_root, "txtFlowerWords_WndHVFlowerOrder", WZUILabelTTF)
	txtFlowerWords:setFontSize(14)
	txtFlowerWords:setDimensions(GlobalMethod:CCSize(560,0))

	GetElement(self.m_root, "txtSeedNumW_WndHVFlowerOrder", WZUILabelTTF):setScale(0.8)
end

---------------------------------------语言适配End-----------------------------------------
