--WndHVSpirit.lua
--@brief	WndHVSpirit的UI模块
--@date		2023/01/03
--@author	yrd
--@note		度假村-精灵界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVSpirit:onEnter(element)
	self.m_root = element
	
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetSpiritDetail(0, 0)
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_WarehouseOp(2)

	self:_showStaticText()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVSpirit:onExit(element)
	self:_unInit()
end

--@brief 	点击关闭按钮回调
function WndHVSpirit:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self , true)
end

--@brief 	显示静态文本
function WndHVSpirit:_showStaticText()
	GetElement(self.m_root,"txtTitle_WndHVSpirit",WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[1])
	GetElement(self.m_root,"txtW1Btn1_WndHVSpirit",WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[2])
	GetElement(self.m_root,"txtW1Btn2_WndHVSpirit",WZUILabelTTF):setText(LocalStrings.EVOLUTION)
	GetElement(self.m_root,"txtW1Btn5_WndHVSpirit",WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[5])
	GetElement(self.m_root,"txtW1Btn6_WndHVSpirit",WZUILabelTTF):setText(LocalStrings.TIPSWORD6)
	GetElement(self.m_root,"txtW4CostWord_WndHVSpirit",WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[11])
	GetElement(self.m_root,"txtW3MaxStep_WndHVSpirit",WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[24])
	GetElement(self.m_root,"txtW2QuickUpgrade_WndHVSpirit",WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[29])
	GetElement(self.m_root,"txtW1SpiritHunger_WndHVSpirit",WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[30])
end

--@brief 	显示升级精灵界面
function WndHVSpirit:showWinUI(nWinType)
	self.m_nWinType = nWinType

	local conWin1 = GetElement(self.m_root,"conWin1_WndHVSpirit",WZUIContainer)
	local conWin2 = GetElement(self.m_root,"conWin2_WndHVSpirit",WZUIContainer)
	local conWin3 = GetElement(self.m_root,"conWin3_WndHVSpirit",WZUIContainer)
	for i=1,3 do
		local conWin = GetElement(self.m_root,"conWin"..i.."_WndHVSpirit",WZUIContainer)
		conWin:setVisible(i==nWinType)
	end
	if nWinType == 1 then
		self:updateWin1()
	elseif nWinType == 2 then
		self:updateWin2()
	elseif nWinType == 3 then
		self:updateWin3()
	end
end


--@brief 	显示精灵界面
function WndHVSpirit:updateWin1()
	self:updateWin1SpiritList()
	self:updateWin1SpiritInfo()
end

--@brief 	刷新精灵列表
function WndHVSpirit:updateWin1SpiritList()
	for i=1,self.m_nW1ShowNum do
		local conW1SpiritBar = GetElement(self.m_root,"conW1SpiritBar"..i.."_WndHVSpirit",WZUIContainer)
		local img9W1SpiritBarSel = GetElement(conW1SpiritBar,"img9W1SpiritBarSel_WndHVSpirit",WZUI9Image)
		local imgW1SpiritBarIcon = GetElement(conW1SpiritBar,"imgW1SpiritBarIcon_WndHVSpirit",WZUIImage)
		local imgW1SpiritBarQuality = GetElement(conW1SpiritBar,"imgW1SpiritBarQuality_WndHVSpirit",WZUIImage)
		local imgW1SpiritBarStar = GetElement(conW1SpiritBar,"imgW1SpiritBarStar_WndHVSpirit",WZUIImage)
		local txtW1SpiritBarStar = GetElement(conW1SpiritBar,"txtW1SpiritBarStar_WndHVSpirit",WZUILabelTTF)
		local txtW1SpiritBarLevel = GetElement(conW1SpiritBar,"txtW1SpiritBarLevel_WndHVSpirit",WZUILabelTTF)
		imgW1SpiritBarStar:setVisible(false)
		txtW1SpiritBarLevel:setText("")

		local tempDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + i
		if tempDataIdx <= #self.m_tData then
			conW1SpiritBar:setVisible(true)
			--选中
			if i == self.m_nW1CurSel then
				img9W1SpiritBarSel:setVisible(true)
			else
				img9W1SpiritBarSel:setVisible(false)
			end
			--是否解锁
			if self.m_tData[tempDataIdx].status == 0 then
				imgW1SpiritBarIcon:setScale(0.4)
				imgW1SpiritBarIcon:setFile("ui/common/common_icon_suo.png")
			elseif self.m_tData[tempDataIdx].status == 1 then
				imgW1SpiritBarIcon:setScale(0.8)
				imgW1SpiritBarIcon:setFile("")
				--显示精灵
				if self.m_tData[tempDataIdx].spiritId > 0 then
					local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tData[tempDataIdx].spiritId]
					local tItemInfo = GDatatab_item["id_"..tSpiritInfo.item_id]
					imgW1SpiritBarIcon:setFile(tItemInfo.icon)
					imgW1SpiritBarQuality:setFile(g_tQualityRect[tItemInfo.quality])
					if self.m_tData[tempDataIdx].step > 0 then
						imgW1SpiritBarStar:setVisible(true)
					end
					txtW1SpiritBarStar:setText(self.m_tData[tempDataIdx].step)
					txtW1SpiritBarLevel:setText("Lv"..self.m_tData[tempDataIdx].level)
				end
			end
		else
			conW1SpiritBar:setVisible(false)
		end
	end
end

--@brief 	刷新精灵信息
function WndHVSpirit:updateWin1SpiritInfo()
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel

	--饱食度
	local spiritSatietyStage = CacheCenter:getGameParam().spiritSatietyStage
	local nums1,nums2,nums3 = CellPastureWorker:workSplitItemString(spiritSatietyStage)
	local nSatietyAdd = 0
	for i=#nums3,1,-1 do
		if self.m_tData[nDataIdx].satiety >= tonumber(nums1[i]) and self.m_tData[nDataIdx].satiety <= tonumber(nums2[i]) then
			nSatietyAdd = tonumber(nums3[i])
			break
		end
	end
	local txtWin1AttrRatio = GetElement(self.m_root,"txtWin1AttrRatio_WndHVSpirit",WZUILabelTTF)
	txtWin1AttrRatio:setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[3]..":"..nSatietyAdd.."%")


	local conW1Show = GetElement(self.m_root,"conW1Show_WndHVSpirit",WZUIContainer)
	conW1Show:setVisible(false)

	local btnW1B5 = GetElement(self.m_root,"btnW1B5_WndHVSpirit",WZUIButton)
	btnW1B5:setVisible(false)
	local btnW1B6 = GetElement(self.m_root,"btnW1B6_WndHVSpirit",WZUIButton)
	btnW1B6:setVisible(false)

	local conW1SpiritHunger = GetElement(self.m_root,"conW1SpiritHunger_WndHVSpirit",WZUIContainer)
	conW1SpiritHunger:setVisible(false)
	local txtW1Starvation = GetElement(self.m_root,"txtW1Starvation_WndHVSpirit",WZUILabelTTF)
	txtW1Starvation:setText("")
	local imgW1SpiritIcon = GetElement(self.m_root,"imgW1SpiritIcon_WndHVSpirit",WZUIImage)
	local imgW1SpiritQuality = GetElement(self.m_root,"imgW1SpiritQuality_WndHVSpirit",WZUIImage)
	imgW1SpiritIcon:setFile("")
	imgW1SpiritQuality:setFile("")
	local ftbW1SpiritName = GetElement(self.m_root,"ftbW1SpiritName_WndHVSpirit",WZUIFreeTextBox)
	ftbW1SpiritName:setShowText("")
	local txtW1SpiritEffect = GetElement(self.m_root,"txtW1SpiritEffect_WndHVSpirit",WZUILabelTTF)
	txtW1SpiritEffect:setText("")
	for i=1,5 do
		local ftbW1Property = GetElement(self.m_root,"ftbW1Property"..i.."_WndHVSpirit",WZUIFreeTextBox)
		ftbW1Property:setShowText("")
	end
	for i=1,4 do
		local ftbW1Addition = GetElement(self.m_root,"ftbW1Addition"..i.."_WndHVSpirit",WZUIFreeTextBox)
		ftbW1Addition:setShowText("")
	end
	local spineW1Spirit = GetElement(self.m_root,"spineW1Spirit_WndHVSpirit",WZUISpine)
	spineW1Spirit:setAnimationName("")
	spineW1Spirit:setFileJson("")
	spineW1Spirit:setFileAtlas("")

	local conW1LockCost = GetElement(self.m_root,"conW1LockCost_WndHVSpirit",WZUIContainer)
	conW1LockCost:setVisible(false)

	--消耗
	local activationSpiritSlot = CacheCenter:getGameParam().activationSpiritSlot
    local ids,nums = SplitItemString(activationSpiritSlot)
    local tCostInfo = GDatatab_item["id_"..ids[nDataIdx]]
	local imgW1Cost1 = GetElement(self.m_root,"imgW1Cost1_WndHVSpirit",WZUIImage)
	imgW1Cost1:setFile(tCostInfo.icon)
	local txtW1Cost1 = GetElement(self.m_root,"txtW1Cost1_WndHVSpirit",WZUILabelTTF)
	txtW1Cost1:setText(nums[nDataIdx])



	if self.m_tData[nDataIdx].status == 0 then
		btnW1B6:setVisible(true)
		conW1LockCost:setVisible(true)
	elseif self.m_tData[nDataIdx].status == 1 and self.m_tData[nDataIdx].spiritId == 0 then
		btnW1B5:setVisible(true)
	end

	local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tData[nDataIdx].spiritId]
	if tSpiritInfo then
		conW1Show:setVisible(true)
		--饱食度
		txtW1Starvation:setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[4]..":"..self.m_tData[nDataIdx].satiety)
		--饥饿对话框
		if self.m_tData[nDataIdx].satiety < self.m_nW1SpiritHunger then
			conW1SpiritHunger:setVisible(true)
		end

		--图标
		local tItemInfo = GDatatab_item["id_"..tSpiritInfo.item_id]
		imgW1SpiritIcon:setFile(tItemInfo.icon)
		imgW1SpiritQuality:setFile(g_tQualityRect[tItemInfo.quality])

		--名字等级进阶
		local strFormat1 = [[<T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1">Lv%s </T><T C=%s S="20" P="1" SC="132,66,29" SS="4" SE="1"> %s </T><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1"> +%s</T>]]
		local strName = string.format(strFormat1,self.m_tData[nDataIdx].level,g_sFtxtQualityColor[tItemInfo.quality],tSpiritInfo.name,self.m_tData[nDataIdx].step)
		if self.m_tData[nDataIdx].step == 0 then
			strFormat1 = [[<T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1">Lv%s </T><T C=%s S="20" P="1" SC="132,66,29" SS="4" SE="1"> %s </T>]]
			strName = string.format(strFormat1,self.m_tData[nDataIdx].level,g_sFtxtQualityColor[tItemInfo.quality],tSpiritInfo.name)
		end
		ftbW1SpiritName:setShowText(strName)

		--特效说明
		local tSpiritEffect = GDatatab_holiday_spirit_effect["id_"..tSpiritInfo.effect_id]
		txtW1SpiritEffect:setText(LocalStrings.SKILL_TXT..":"..tSpiritEffect.desc)

		local tSpiritLevel = self:getSpiritLevel(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].level)
		local tSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].step)


		local spiritSatietyStage = CacheCenter:getGameParam().spiritSatietyStage
		local nums1,nums2,nums3 = CellPastureWorker:workSplitItemString(spiritSatietyStage)
		local nSatietyAdd = 0
		for i=#nums3,1,-1 do
			if self.m_tData[nDataIdx].satiety >= tonumber(nums1[i]) and self.m_tData[nDataIdx].satiety <= tonumber(nums2[i]) then
				nSatietyAdd = tonumber(nums3[i])
				break
			end
		end
		--属性值
		local strFormat2 = [[<T C="127,70,26" S="18" P="1">%s:</T><T C="229,105,22" S="18" P="1">%s</T>]]
		local nPropertyNum = math.min(#tSpiritLevel.property, 5)
		for i=1,nPropertyNum do
			local ftbW1Property = GetElement(self.m_root,"ftbW1Property"..i.."_WndHVSpirit",WZUIFreeTextBox)
			local attr = math.floor(tSpiritLevel.property[i][2] * (1 + tSpiritStep.property/10000))
			ftbW1Property:setShowText(string.format(strFormat2, ATTR_TITLE[tSpiritLevel.property[i][1]], attr))
		end

		--其他加成
		local strFormat3 = [[<T C="127,70,26" S="18" P="1">%s:</T><T C="5,180,0" S="18" P="1">%s</T>]]
		local strFormatList = {LocalStrings.HOLIDAYVILLAGE_TEXT1[26], LocalStrings.QUICKEN, LocalStrings.WAKEUP_TEXT19, LocalStrings.HOLIDAYVILLAGE_TEXT1[27]}
		if type(tSpiritLevel.addition) == "table" then
			for i=1,#tSpiritLevel.addition do
				local ftbW1Addition = GetElement(self.m_root,"ftbW1Addition"..i.."_WndHVSpirit",WZUIFreeTextBox)
				if ftbW1Addition then
					ftbW1Addition:setShowText(string.format(strFormat3,strFormatList[tSpiritLevel.addition[i][1]],"+"..(tSpiritLevel.addition[i][2]/100).."%"))
				end
			end
		end

		--精灵动画
		spineW1Spirit:setAnimationName("")
		spineW1Spirit:setFileJson("")
		spineW1Spirit:setFileAtlas("")
		spineW1Spirit:setAnimationName(tSpiritStep.action)
		spineW1Spirit:setFileJson(tSpiritStep.animation..".json")
		spineW1Spirit:setFileAtlas(tSpiritStep.animation..".atlas")
	end
end

--@brief 	点击规则按钮
function WndHVSpirit:onClickRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.HOLIDAYVILLAGE_TEXT6)
end

--@brief 	点击列表精灵栏位
function WndHVSpirit:onClickW1SpiritBar(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nW1CurSel = element:getTag()
	self:updateWin1()
end

--@brief 	点击精灵栏位列表上一页
function WndHVSpirit:onClickW1BtnPrev(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nW1CurPage = self.m_nW1CurPage - 1
	if self.m_nW1CurPage < 1 then
		self.m_nW1CurPage = 1
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT36)
		return
	end
	self.m_nW1CurSel = 1
	self:updateWin1()
end

--@brief 	点击精灵栏位列表下一页
function WndHVSpirit:onClickW1BtnNext(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nW1CurPage = self.m_nW1CurPage + 1
	local nMaxPage = math.ceil(#self.m_tData/self.m_nW1ShowNum)
	if self.m_nW1CurPage > nMaxPage then
		self.m_nW1CurPage = nMaxPage
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT35)
		return
	end
	self.m_nW1CurSel = 1
	self:updateWin1()
end

--@brief 	点击放入精灵按钮
function WndHVSpirit:onClickW1Btn5(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local tData = {}
	tData.gridPos = nDataIdx
	tData.gridId = self.m_tData[nDataIdx].spiritId
	WndSelectTipsStrengthen:showSelectTips(7, tData)
end

--@brief 	点击解锁精灵按钮
function WndHVSpirit:onClickW1Btn6(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local activationSpiritSlot = CacheCenter:getGameParam().activationSpiritSlot
	local ids,nums = SplitItemString(activationSpiritSlot)
	if not JudgeMoneyIsEnough(ids[nDataIdx],nums[nDataIdx],nil,nil,GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureW1UseDiamond) then
		return 
	end
	self:sureW1UseDiamond()
end

function WndHVSpirit:sureW1UseDiamond()
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local index = nDataIdx - 1
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ActivationSpiritSlot(index)
end

--@brief 	点击放入精灵回调
function WndHVSpirit:addStoneToCell(tData, pos)
	WZLog("WndHVSpirit:addStoneToCell",Serialize(tData),Serialize(pos))
	local index = pos - 1
	local spiritId = 0
	for _,v in pairs(GDatatab_holiday_spirit) do
		if v.item_id == tData.id then
			spiritId = v.id
		end
	end
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ActivationSpirit(index, spiritId)
end

--@brief 	点击喂养精灵按钮
function WndHVSpirit:onClickW1Btn3(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	WndHVSpiritFeed:showInterface(self.m_tData[nDataIdx],self,self.onFeedCallBack)
end

--@brief 	点击喂养精灵回调
function WndHVSpirit:onFeedCallBack(tTatgetData,tItemData,nNum)
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritFeed(tTatgetData.spiritId, tItemData.basicInfo.id, nNum)
end

--@brief 	点击打开回收精灵按钮
function WndHVSpirit:onClickW1Btn4(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:showWin4(true)
end

--@brief 	点击关闭回收精灵按钮
function WndHVSpirit:onClickCloseW4(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:showWin4(false)
end

--@brief 	显示回收精灵界面
function WndHVSpirit:showWin4(bShow)
	local conWin4 = GetElement(self.m_root,"conWin4_WndHVSpirit",WZUIContainer)
	conWin4:setVisible(bShow)

	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tData[nDataIdx].spiritId]
	local tItemInfo = GDatatab_item["id_"..tSpiritInfo.item_id]
	if bShow == true then
		--内容
		local txtW4Desc = GetElement(self.m_root,"txtW4Desc_WndHVSpirit",WZUILabelTTF)
		local str1 = "Lv"..self.m_tData[nDataIdx].level..tSpiritInfo.name.."+"..self.m_tData[nDataIdx].step
		if self.m_tData[nDataIdx].step == 0 then
			str1 = "Lv"..self.m_tData[nDataIdx].level..tSpiritInfo.name
		end
		txtW4Desc:setText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT4[8], str1))
		--消耗
		local tItemList = self:getW4RecoveryItem()
		local flbW4Cost = GetElement(self.m_root,"flbW4Cost_WndHVSpirit",WZUIFreeListContainer)
		flbW4Cost:removeAll()
		for i=1,#tItemList do
			local tTempInfo = GDatatab_item["id_"..tItemList[i][1]]
			local newEle = WZUISystem:getInstance():createElement("conW4CostCell_WndHVSpirit")
			newEle = WZUIContainer:luaTo(newEle)
			newEle:setVisible(true)
			local imgW4CostCell = GetElement(newEle,"imgW4CostCell_WndHVSpirit",WZUIImage)
			imgW4CostCell:setFile(tTempInfo.icon)
			local txtW4CostCell = GetElement(newEle,"txtW4CostCell_WndHVSpirit",WZUILabelTTF)
			txtW4CostCell:setText(tItemList[i][2])
			flbW4Cost:pushBack(newEle)
		end
		flbW4Cost:getMoveElement():setPositionX(flbW4Cost:getMaxPosition().x)
	end
end

--@brief 	点击回收精灵界面返回按钮
function WndHVSpirit:onClickW4Btn1(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:showWin4(false)
end

--@brief 	点击回收精灵界面回收按钮
function WndHVSpirit:onClickW4Btn2(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local spiritId = self.m_tData[nDataIdx].spiritId
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_RecoverySpirit(spiritId)
	self:showWin4(false)
end

--@brief 	点击打开训练界面
function WndHVSpirit:onClickW1Btn1(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:showWinUI(2)
end

--@brief 	点击打开训练界面
function WndHVSpirit:onClickW1Btn2(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:showWinUI(3)
end



--@brief 	显示升级精灵界面
function WndHVSpirit:updateWin2()
	self:updateWin2SpiritOperate()
	self:updateWin2SpiritInfo()
end

--@brief 	刷新升级界面精灵信息
function WndHVSpirit:updateWin2SpiritInfo()
	self.m_bW2IsQUpgrading = false

	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tData[nDataIdx].spiritId]

	--图标
	local tItemInfo = GDatatab_item["id_"..tSpiritInfo.item_id]
	local imgW2SpiritIcon = GetElement(self.m_root,"imgW2SpiritIcon_WndHVSpirit",WZUIImage)
	imgW2SpiritIcon:setFile(tItemInfo.icon)
	local imgW2SpiritQuality = GetElement(self.m_root,"imgW2SpiritQuality_WndHVSpirit",WZUIImage)
	imgW2SpiritQuality:setFile(g_tQualityRect[tItemInfo.quality])

	--名字等级进阶
	local ftbW2SpiritName = GetElement(self.m_root,"ftbW2SpiritName_WndHVSpirit",WZUIFreeTextBox)
	local strFormat1 = [[<T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1">Lv%s </T><T C=%s S="20" P="1" SC="132,66,29" SS="4" SE="1"> %s </T><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1"> +%s</T>]]
	local strName = string.format(strFormat1,self.m_tData[nDataIdx].level,g_sFtxtQualityColor[tItemInfo.quality],tSpiritInfo.name,self.m_tData[nDataIdx].step)
	if self.m_tData[nDataIdx].step == 0 then
		strFormat1 = [[<T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1">Lv%s </T><T C=%s S="20" P="1" SC="132,66,29" SS="4" SE="1"> %s </T>]]
		strName = string.format(strFormat1,self.m_tData[nDataIdx].level,g_sFtxtQualityColor[tItemInfo.quality],tSpiritInfo.name)
	end
	ftbW2SpiritName:setShowText(strName)

	--特效说明
	local txtW2SpiritEffect = GetElement(self.m_root,"txtW2SpiritEffect_WndHVSpirit",WZUILabelTTF)
	local tSpiritEffect = GDatatab_holiday_spirit_effect["id_"..tSpiritInfo.effect_id]
	txtW2SpiritEffect:setText(LocalStrings.SKILL_TXT..":"..tSpiritEffect.desc)
	--等级进阶数据
	local tCurSpiritLevel = self:getSpiritLevel(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].level)
	local tCurSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].step)
	local tNextSpiritLevel = self:getSpiritLevel(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].level+1)
	local tNextSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].step+1)
	--饱食度加成信息
	local spiritSatietyStage = CacheCenter:getGameParam().spiritSatietyStage
	local nums1,nums2,nums3 = CellPastureWorker:workSplitItemString(spiritSatietyStage)
	local nSatietyAdd = 0
	for i=#nums3,1,-1 do
		if self.m_tData[nDataIdx].satiety >= tonumber(nums1[i]) and self.m_tData[nDataIdx].satiety <= tonumber(nums2[i]) then
			nSatietyAdd = tonumber(nums3[i])
			break
		end
	end
	--当前等级属性值
	local strFormat2 = [[<T C="127,70,26" S="18" P="1">%s:</T><T C="229,105,22" S="18" P="1">%s</T>]]
	local ftbW2CurProperty0 = GetElement(self.m_root,"ftbW2CurProperty0_WndHVSpirit",WZUIFreeTextBox)
	ftbW2CurProperty0:setShowText(string.format(strFormat2, LocalStrings.LEVEL, self.m_tData[nDataIdx].level))
	local nPropertyNum = math.min(#tCurSpiritLevel.property, 5)
	for i=1,nPropertyNum do
		local ftbW2CurProperty = GetElement(self.m_root,"ftbW2CurProperty"..i.."_WndHVSpirit",WZUIFreeTextBox)
		local attr1 = math.floor(tCurSpiritLevel.property[i][2] * (1 + tCurSpiritStep.property/10000))
		ftbW2CurProperty:setShowText(string.format(strFormat2, ATTR_TITLE[tCurSpiritLevel.property[i][1]], attr1))
	end
	--下一级属性
	for i=0,5 do
		local imgW2ArrowProperty = GetElement(self.m_root,"imgW2ArrowProperty"..i.."_WndHVSpirit",WZUIImage)
		imgW2ArrowProperty:setVisible(false)
		local ftbW2NextProperty = GetElement(self.m_root,"ftbW2NextProperty"..i.."_WndHVSpirit",WZUIFreeTextBox)
		ftbW2NextProperty:setShowText("")
	end
	if tNextSpiritLevel then
		local imgW2ArrowProperty0 = GetElement(self.m_root,"imgW2ArrowProperty0_WndHVSpirit",WZUIImage)
		local ftbW2NextProperty0 = GetElement(self.m_root,"ftbW2NextProperty0_WndHVSpirit",WZUIFreeTextBox)
		imgW2ArrowProperty0:setVisible(true)
		ftbW2NextProperty0:setShowText(string.format(strFormat2, LocalStrings.LEVEL, self.m_tData[nDataIdx].level+1))
		local nPropertyNum = math.min(#tNextSpiritLevel.property, 5)
		for i=1,nPropertyNum do
			local imgW2ArrowProperty = GetElement(self.m_root,"imgW2ArrowProperty"..i.."_WndHVSpirit",WZUIImage)
			imgW2ArrowProperty:setVisible(true)
			local ftbW2NextProperty = GetElement(self.m_root,"ftbW2NextProperty"..i.."_WndHVSpirit",WZUIFreeTextBox)
			local attr1 = math.floor(tNextSpiritLevel.property[i][2] * (1 + tCurSpiritStep.property/10000))
			ftbW2NextProperty:setShowText(string.format(strFormat2, ATTR_TITLE[tNextSpiritLevel.property[i][1]], attr1))
		end
	end
	--其他加成
	local strFormat3 = [[<T C="127,70,26" S="18" P="1">%s:</T><T C="5,180,0" S="18" P="1">%s</T>]]
	local strFormatList = {LocalStrings.HOLIDAYVILLAGE_TEXT1[26], LocalStrings.QUICKEN, LocalStrings.WAKEUP_TEXT19, LocalStrings.HOLIDAYVILLAGE_TEXT1[27]}
	if type(tCurSpiritLevel.addition) == "table" then
		for i=1,#tCurSpiritLevel.addition do
			local ftbW2Addition = GetElement(self.m_root,"ftbW2Addition"..i.."_WndHVSpirit",WZUIFreeTextBox)
			if ftbW2Addition then
				ftbW2Addition:setShowText(string.format(strFormat3,strFormatList[tCurSpiritLevel.addition[i][1]],"+"..(tCurSpiritLevel.addition[i][2]/100).."%"))
			end
		end
	end
end

--@brief 	刷新升级界面精灵操作内容
function WndHVSpirit:updateWin2SpiritOperate()
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tData[nDataIdx].spiritId]
	local tSpiritLevel = self:getSpiritLevel(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].level)
	local tSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].step)

	--精灵动画
	local spineW2Spirit = GetElement(self.m_root,"spineW2Spirit_WndHVSpirit",WZUISpine)
	spineW2Spirit:setAnimationName("")
	spineW2Spirit:setFileJson("")
	spineW2Spirit:setFileAtlas("")
	spineW2Spirit:setAnimationName(tSpiritStep.action)
	spineW2Spirit:setFileJson(tSpiritStep.animation..".json")
	spineW2Spirit:setFileAtlas(tSpiritStep.animation..".atlas")
	--等级和经验
	self:showExpLevel(self.m_tData[nDataIdx].level, tSpiritStep.levelup, self.m_tData[nDataIdx].exp, tSpiritLevel.exp)
	--消耗
	if self.m_tW2CostDataList == nil then
		self:initW2CostData()
	end
	self.m_tW2CostObjList = {}
	for i=1,3 do
		local conCostItem = GetElement(self.m_root,"conW2Item"..i.."_WndHVSpirit",WZUIContainer)
		conCostItem:removeAllChildrenWithCleanup(true)
		if self.m_tW2CostDataList[i] then
			local element, tLuaObj = CellGoodItem:createElement()
			tLuaObj:setCellGoodLocalId(self.m_tW2CostDataList[i].id, self:getItemCountByItemId(self.m_tW2CostDataList[i].id), 17, true)
			tLuaObj:setItemClickFun(self,self.onSelectCostItem)
			element:setScale(0.8)
			element:setTag(i)
			conCostItem:addChild(WZUIContainer:luaTo(element))
			table.insert(self.m_tW2CostObjList,tLuaObj)
		end
	end
	self:updatew2SelectCost()
	--按钮字
	local txtW2Btn2 = GetElement(self.m_root,"txtW2Btn2_WndHVSpirit",WZUILabelTTF)
	txtW2Btn2:setText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT4[9],5))
	local txtW2Btn3 = GetElement(self.m_root,"txtW2Btn3_WndHVSpirit",WZUILabelTTF)
	txtW2Btn3:setText(LocalStrings.USE)
end

--@brief   显示等级和经验
function WndHVSpirit:showExpLevel(curlevel, maxLevel, curExp, maxExp)
	--等级
	local txtW2PLevel = GetElement(self.m_root,"txtW2PLevel_WndHVSpirit",WZUILabelTTF)
	txtW2PLevel:setText("Lv"..curlevel.."/"..maxLevel)
	--经验
	local nExpPercentage = math.min(curExp/maxExp*100, 100)
	if maxExp == -1 then
		nExpPercentage = 100
	end
	local progW2Exp = GetElement(self.m_root,"progW2Exp_WndHVSpirit",WZUIProgress)
	progW2Exp:setPercentage(nExpPercentage)
	local strExp = curExp.."/"..maxExp
	if maxExp == -1 then
		strExp = "MAX"
	end
	local txtW2PExp = GetElement(self.m_root,"txtW2PExp_WndHVSpirit",WZUILabelTTF)
	txtW2PExp:setText(strExp)
end

--@brief   初始化升级消耗物品数据
function WndHVSpirit:initW2CostData()
	self.m_tW2CostDataList = {}
	for i, v in pairs(GDatatab_item) do
		if v.main_type == 45 and v.sub_type == 7 then
			table.insert(self.m_tW2CostDataList, CopyTable(v))
		end
	end
	table.sort(self.m_tW2CostDataList,function(a,b)
		return a.value < b.value
	end)
end

--@brief   更新选中物品
function WndHVSpirit:updatew2SelectCost()
	if self.m_nW2CostSelIdx > #self.m_tW2CostObjList then
		self.m_nW2CostSelIdx = 1
	end

	for i=1,#self.m_tW2CostObjList do
		self.m_tW2CostObjList[i]:setItemSelState2(false)
	end
	self.m_tW2CostObjList[self.m_nW2CostSelIdx]:setItemSelState2(true)

	--更新经验值显示
	local nAddNum = self.m_tW2CostObjList[self.m_nW2CostSelIdx]:getData().basicInfo.value
	local txtW2ItemExp = GetElement(self.m_root,"txtW2ItemExp_WndHVSpirit",WZUILabelTTF)
	txtW2ItemExp:setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[10].."+"..nAddNum)
end

--@brief   点击选择消耗物品
function WndHVSpirit:onSelectCostItem(luaTable,tag,tData)
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false, nil, true)

	self.m_nW2CostSelIdx = tag
	self:updatew2SelectCost()
end

--@brief   点击升5级按钮
function WndHVSpirit:onClickW2Btn2(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tData[nDataIdx].spiritId]
	local tSpiritLevel = self:getSpiritLevel(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].level)
	local tSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].step)
	--当前阶段最大等级
	if self.m_tData[nDataIdx].level >= tSpiritStep.levelup then
		MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[19])
		return
	end
	--等级已满
	if tSpiritLevel.exp == -1 then
		MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[14])
		return
	end

	local spiritId = self.m_tData[nDataIdx].spiritId
	local itemId = self.m_tW2CostDataList[self.m_nW2CostSelIdx].id
	local num = 5

	local nMyNum = self:getItemCountByItemId(itemId)
	if self.m_nW2QuickUpgrade == 1 then
		if nMyNum == 0 then
			MsgBoxManager:showTipBox(LocalStrings.TRANSACTION49)
			return
		end
		--连续点2次快速升级,计算道具时可能不够第2次升级,所以先等升级完才能再次点级
		if self.m_bW2IsQUpgrading == true then
			return
		end
		local tCostInfo = GDatatab_item["id_"..itemId]
		local needExp = (tSpiritLevel.exp - self.m_tData[nDataIdx].exp)
		local needCount = math.ceil(needExp / tCostInfo.value)
		num = math.min(nMyNum, needCount)
		self.m_bW2IsQUpgrading = true
	else
		if nMyNum < num then
			MsgBoxManager:showTipBox(LocalStrings.TRANSACTION49)
			return
		end
	end
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritUpgrade(spiritId, itemId, num)
end

--@brief   点击升1级按钮
function WndHVSpirit:onClickW2Btn3(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tData[nDataIdx].spiritId]
	local tSpiritLevel = self:getSpiritLevel(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].level)
	local tSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].step)
	--当前阶段最大等级
	if self.m_tData[nDataIdx].level >= tSpiritStep.levelup then
		MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[19])
		return
	end
	--等级已满
	if tSpiritLevel.exp == -1 then
		MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[14])
		return
	end

	local spiritId = self.m_tData[nDataIdx].spiritId
	local itemId = self.m_tW2CostDataList[self.m_nW2CostSelIdx].id
	local num = 1

	local nMyNum = self:getItemCountByItemId(itemId)
	if self.m_nW2QuickUpgrade == 1 then
		if nMyNum == 0 then
			MsgBoxManager:showTipBox(LocalStrings.TRANSACTION49)
			return
		end
		--连续点2次快速升级,计算道具时可能不够第2次升级,所以先等升级完才能再次点级
		if self.m_bW2IsQUpgrading == true then
			return
		end
		local tCostInfo = GDatatab_item["id_"..itemId]
		local needExp = (tSpiritLevel.exp - self.m_tData[nDataIdx].exp)
		local needCount = math.ceil(needExp / tCostInfo.value)
		num = math.min(nMyNum, needCount)
		self.m_bW2IsQUpgrading = true
	else
		if nMyNum < num then
			MsgBoxManager:showTipBox(LocalStrings.TRANSACTION49)
			return
		end
	end
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritUpgrade(spiritId, itemId, num)
end

--@brief 	点击"训练至升级"选择框
function WndHVSpirit:onClickW2CBUpgrade(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local cbW2QuickUpgrade = GetElement(self.m_root,"cbW2QuickUpgrade_WndHVSpirit",WZUICheckBox)
	self.m_nW2QuickUpgrade = cbW2QuickUpgrade:getCheckIndex()
end

--@brief    滚动显示消耗进度
function WndHVSpirit:showW2Progress()
	self.m_nW2AddSplitExp = math.ceil(self.m_nW2AddTotalExp / DEFAULT_FPS * 2) --每帧加多少经验
    local conW2Exp = GetElement(self.m_root, "conW2Exp_WndHVSpirit", WZUIContainer)
    if conW2Exp then
        conW2Exp:enableSchedule("displayPrg")
    end
end

--@brief    每帧显示进度
function WndHVSpirit:displayPrg(element,dt)
	-- WZLog("WndHVSpirit:displayPrg",dt)
	if self.m_root == nil then
		return
	end
	
	local conW2Exp = GetElement(self.m_root, "conW2Exp_WndHVSpirit", WZUIContainer)

	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local tCurSpiritLevel = self:getSpiritLevel(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].level)
	local tCurSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId, self.m_tData[nDataIdx].step)
	local nAddOnceExp = math.min(self.m_nW2AddTotalExp,self.m_nW2AddSplitExp)
	self.m_nW2AddTotalExp = self.m_nW2AddTotalExp - nAddOnceExp
	self.m_tData[nDataIdx].exp = self.m_tData[nDataIdx].exp + nAddOnceExp

	if tCurSpiritLevel.exp ~= -1 and self.m_tData[nDataIdx].exp >= tCurSpiritLevel.exp then
		self.m_tData[nDataIdx].exp = self.m_tData[nDataIdx].exp - tCurSpiritLevel.exp
		self.m_tData[nDataIdx].level = self.m_tData[nDataIdx].level + 1
	end

	if self.m_nW2AddTotalExp <= 0 then
		self.m_tData[nDataIdx].exp = self.m_nW2FinalyExp
		self.m_tData[nDataIdx].level = self.m_nW2FinalyLevel
		conW2Exp:disableSchedule()
		self:updateWin2()
	else
		self:showExpLevel(self.m_tData[nDataIdx].level, tCurSpiritStep.levelup, self.m_tData[nDataIdx].exp, tCurSpiritLevel.exp)
	end
end

--@brief 	点击返回精灵主界面
function WndHVSpirit:onClickW2Btn1(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:showWinUI(1)
end



--@brief 	显示进阶精灵界面
function WndHVSpirit:updateWin3()
	self:updateWin3SpiritOperate()
	self:updateWin3SpiritInfo()
end

--@brief 	刷新精灵信息
function WndHVSpirit:updateWin3SpiritInfo()
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tData[nDataIdx].spiritId]

	--图标
	local tItemInfo = GDatatab_item["id_"..tSpiritInfo.item_id]
	local imgW3SpiritIcon = GetElement(self.m_root,"imgW3SpiritIcon_WndHVSpirit",WZUIImage)
	imgW3SpiritIcon:setFile(tItemInfo.icon)
	local imgW3SpiritQuality = GetElement(self.m_root,"imgW3SpiritQuality_WndHVSpirit",WZUIImage)
	imgW3SpiritQuality:setFile(g_tQualityRect[tItemInfo.quality])

	--名字等级进阶
	local ftbW3SpiritName = GetElement(self.m_root,"ftbW3SpiritName_WndHVSpirit",WZUIFreeTextBox)
	local strFormat1 = [[<T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1">Lv%s </T><T C=%s S="20" P="1" SC="132,66,29" SS="4" SE="1"> %s </T><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1"> +%s</T>]]
	local strName = string.format(strFormat1,self.m_tData[nDataIdx].level,g_sFtxtQualityColor[tItemInfo.quality],tSpiritInfo.name,self.m_tData[nDataIdx].step)
	if self.m_tData[nDataIdx].step == 0 then
		strFormat1 = [[<T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1">Lv%s </T><T C=%s S="20" P="1" SC="132,66,29" SS="4" SE="1"> %s </T>]]
		strName = string.format(strFormat1,self.m_tData[nDataIdx].level,g_sFtxtQualityColor[tItemInfo.quality],tSpiritInfo.name)
	end
	ftbW3SpiritName:setShowText(strName)

	--特效说明
	local txtW3SpiritEffect = GetElement(self.m_root,"txtW3SpiritEffect_WndHVSpirit",WZUILabelTTF)
	local tSpiritEffect = GDatatab_holiday_spirit_effect["id_"..tSpiritInfo.effect_id]
	txtW3SpiritEffect:setText(LocalStrings.SKILL_TXT..":"..tSpiritEffect.desc)
	--等级进阶数据
	local tCurSpiritLevel = self:getSpiritLevel(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].level)
	local tCurSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].step)
	local tNextSpiritLevel = self:getSpiritLevel(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].level+1)
	local tNextSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].step+1)
	--饱食度加成信息
	local spiritSatietyStage = CacheCenter:getGameParam().spiritSatietyStage
	local nums1,nums2,nums3 = CellPastureWorker:workSplitItemString(spiritSatietyStage)
	local nSatietyAdd = 0
	for i=#nums3,1,-1 do
		if self.m_tData[nDataIdx].satiety >= tonumber(nums1[i]) and self.m_tData[nDataIdx].satiety <= tonumber(nums2[i]) then
			nSatietyAdd = tonumber(nums3[i])
			break
		end
	end
	--当前等级属性值
	local strFormat2 = [[<T C="127,70,26" S="18" P="1">%s:</T><T C="229,105,22" S="18" P="1">%s</T>]]
	local ftbW3CurProperty0 = GetElement(self.m_root,"ftbW3CurProperty0_WndHVSpirit",WZUIFreeTextBox)
	ftbW3CurProperty0:setShowText(string.format(strFormat2, LocalStrings.EVOLUTION, self.m_tData[nDataIdx].step))
	local nPropertyNum = math.min(#tCurSpiritLevel.property, 4)
	for i=1,nPropertyNum do
		local ftbW3CurProperty = GetElement(self.m_root,"ftbW3CurProperty"..i.."_WndHVSpirit",WZUIFreeTextBox)
		local attr1 = math.floor(tCurSpiritLevel.property[i][2] * (1 + tCurSpiritStep.property/10000))
		ftbW3CurProperty:setShowText(string.format(strFormat2, ATTR_TITLE[tCurSpiritLevel.property[i][1]], attr1))
	end
	local nNextPropertyIndex = nPropertyNum + 1
	local ftbW3CurPropertyN = GetElement(self.m_root,"ftbW3CurProperty"..nNextPropertyIndex.."_WndHVSpirit",WZUIFreeTextBox)
	ftbW3CurPropertyN:setShowText(string.format(strFormat2, LocalStrings.BREAK_TEXT1[3], tCurSpiritStep.levelup))

	--下一阶属性
	for i=0,5 do
		local imgW3ArrowProperty = GetElement(self.m_root,"imgW3ArrowProperty"..i.."_WndHVSpirit",WZUIImage)
		imgW3ArrowProperty:setVisible(false)
		local ftbW3NextProperty = GetElement(self.m_root,"ftbW3NextProperty"..i.."_WndHVSpirit",WZUIFreeTextBox)
		ftbW3NextProperty:setShowText("")
	end
	if tNextSpiritStep then
		local imgW3ArrowProperty0 = GetElement(self.m_root,"imgW3ArrowProperty0_WndHVSpirit",WZUIImage)
		local ftbW3NextProperty0 = GetElement(self.m_root,"ftbW3NextProperty0_WndHVSpirit",WZUIFreeTextBox)
		imgW3ArrowProperty0:setVisible(true)
		ftbW3NextProperty0:setShowText(string.format(strFormat2, LocalStrings.EVOLUTION, self.m_tData[nDataIdx].step+1))
		local nPropertyNum = math.min(#tCurSpiritLevel.property, 4)
		for i=1,nPropertyNum do
			local imgW3ArrowProperty = GetElement(self.m_root,"imgW3ArrowProperty"..i.."_WndHVSpirit",WZUIImage)
			imgW3ArrowProperty:setVisible(true)
			local ftbW3NextProperty = GetElement(self.m_root,"ftbW3NextProperty"..i.."_WndHVSpirit",WZUIFreeTextBox)
			local attr1 = math.floor(tCurSpiritLevel.property[i][2] * (1 + tNextSpiritStep.property/10000))
			ftbW3NextProperty:setShowText(string.format(strFormat2, ATTR_TITLE[tCurSpiritLevel.property[i][1]], attr1))
		end
		local nNextPropertyIndex = nPropertyNum + 1
		local imgW3ArrowPropertyN = GetElement(self.m_root,"imgW3ArrowProperty"..nNextPropertyIndex.."_WndHVSpirit",WZUIImage)
		imgW3ArrowPropertyN:setVisible(true)
		local ftbW3NextPropertyN = GetElement(self.m_root,"ftbW3NextProperty"..nNextPropertyIndex.."_WndHVSpirit",WZUIFreeTextBox)
		ftbW3NextPropertyN:setShowText(string.format(strFormat2, LocalStrings.BREAK_TEXT1[3], tNextSpiritStep.levelup))
	end
	--其他加成
	local strFormat3 = [[<T C="127,70,26" S="18" P="1">%s:</T><T C="5,180,0" S="18" P="1">%s</T>]]
	local strFormatList = {LocalStrings.HOLIDAYVILLAGE_TEXT1[26], LocalStrings.QUICKEN, LocalStrings.WAKEUP_TEXT19, LocalStrings.HOLIDAYVILLAGE_TEXT1[27]}
	if type(tCurSpiritLevel.addition) == "table" then
		for i=1,#tCurSpiritLevel.addition do
			local ftbW3Addition = GetElement(self.m_root,"ftbW3Addition"..i.."_WndHVSpirit",WZUIFreeTextBox)
			if ftbW3Addition then
				ftbW3Addition:setShowText(string.format(strFormat3,strFormatList[tCurSpiritLevel.addition[i][1]],"+"..(tCurSpiritLevel.addition[i][2]/100).."%"))
			end
		end
	end
end

--@brief 	刷新进阶界面精灵操作内容
function WndHVSpirit:updateWin3SpiritOperate()
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tData[nDataIdx].spiritId]
	local tItemInfo = GDatatab_item["id_"..tSpiritInfo.item_id]

	--等级进阶数据
	-- local tCurSpiritLevel = self:getSpiritLevel(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].level)
	local tCurSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].step)
	-- local tNextSpiritLevel = self:getSpiritLevel(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].level+1)
	local tNextSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].step+1)

	--精灵动画
	local conW3CostBar = GetElement(self.m_root,"conW3CostBar_WndHVSpirit",WZUIContainer)
	conW3CostBar:setVisible(false)
	local txtW3MaxStep = GetElement(self.m_root,"txtW3MaxStep_WndHVSpirit",WZUILabelTTF)
	txtW3MaxStep:setVisible(true)
	local conW3Armature1 = GetElement(self.m_root,"conW3Armature1_WndHVSpirit",WZUIContainer)
	conW3Armature1:setRelativePosition(GlobalMethod:ccp(0.5,0.52))
	local imgW3Arrow = GetElement(self.m_root,"imgW3Arrow_WndHVSpirit",WZUIImage)
	imgW3Arrow:setVisible(false)
	-- for i=1,4 do
	-- 	local armature1 = GetElement(self.m_root,"armature1_"..i.."_WndHVSpirit",WZArmature)
	-- 	armature1:setVisible(i==tItemInfo.quality)
	-- 	local armature2 = GetElement(self.m_root,"armature2_"..i.."_WndHVSpirit",WZArmature)
	-- 	armature2:setVisible(false)
	-- end
	local armature1_1 = GetElement(self.m_root,"armature1_1_WndHVSpirit",WZArmature)
	armature1_1:setVisible(true)
	local armature2_1 = GetElement(self.m_root,"armature2_1_WndHVSpirit",WZArmature)
	armature2_1:setVisible(false)
	local spineW3Spirit1 = GetElement(self.m_root,"spineW3Spirit1_WndHVSpirit",WZUISpine)
	spineW3Spirit1:setAnimationName("")
	spineW3Spirit1:setFileJson("")
	spineW3Spirit1:setFileAtlas("")
	spineW3Spirit1:setAnimationName(tCurSpiritStep.action)
	spineW3Spirit1:setFileJson(tCurSpiritStep.animation..".json")
	spineW3Spirit1:setFileAtlas(tCurSpiritStep.animation..".atlas")
	spineW3Spirit1:setRelativePosition(GlobalMethod:ccp(0.5,0.52))
	local spineW3Spirit2 = GetElement(self.m_root,"spineW3Spirit2_WndHVSpirit",WZUISpine)
	spineW3Spirit2:setAnimationName("")
	spineW3Spirit2:setFileJson("")
	spineW3Spirit2:setFileAtlas("")

	if tNextSpiritStep then
		conW3CostBar:setVisible(true)
		txtW3MaxStep:setVisible(false)
		conW3Armature1:setRelativePosition(GlobalMethod:ccp(0.29,0.52))
		spineW3Spirit1:setRelativePosition(GlobalMethod:ccp(0.29,0.52))
		imgW3Arrow:setVisible(true)
		-- for i=1,4 do
		-- 	local armature2 = GetElement(self.m_root,"armature2_"..i.."_WndHVSpirit",WZArmature)
		-- 	armature2:setVisible(i==tItemInfo.quality)
		-- end
		local armature2_1 = GetElement(self.m_root,"armature2_1_WndHVSpirit",WZArmature)
		armature2_1:setVisible(true)
		spineW3Spirit2:setAnimationName(tNextSpiritStep.action)
		spineW3Spirit2:setFileJson(tNextSpiritStep.animation..".json")
		spineW3Spirit2:setFileAtlas(tNextSpiritStep.animation..".atlas")
	end

	--消耗物品
	for i=1,2 do
		local imgW3Cost = GetElement(self.m_root,"imgW3Cost"..i.."_WndHVSpirit",WZUIImage)
		imgW3Cost:setFile("")
		local txtW3Cost = GetElement(self.m_root,"txtW3Cost"..i.."_WndHVSpirit",WZUILabelTTF)
		txtW3Cost:setText("")
		local btnW3Cost = GetElement(self.m_root,"btnW3Cost"..i.."_WndHVSpirit",WZUIButton)
		btnW3Cost:setVisible(false)
	end
	if type(tCurSpiritStep.cost1) == "table" then
		local tempItem = GDatatab_item["id_"..tCurSpiritStep.cost1[1][1]]
		local imgW3Cost1 = GetElement(self.m_root,"imgW3Cost1_WndHVSpirit",WZUIImage)
		imgW3Cost1:setFile(tempItem.icon)
		local txtW3Cost1 = GetElement(self.m_root,"txtW3Cost1_WndHVSpirit",WZUILabelTTF)
		txtW3Cost1:setText(tCurSpiritStep.cost1[1][2].."("..LocalStrings.OWN..CacheCenter:getPlayerItemCountById(tCurSpiritStep.cost1[1][1])..")")
		local btnW3Cost1 = GetElement(self.m_root,"btnW3Cost1_WndHVSpirit",WZUIButton)
		btnW3Cost1:setVisible(true)
	end
	if type(tCurSpiritStep.cost) == "table" then
		local tempItem = GDatatab_item["id_"..tCurSpiritStep.cost[1][1]]
		local imgW3Cost2 = GetElement(self.m_root,"imgW3Cost2_WndHVSpirit",WZUIImage)
		imgW3Cost2:setFile(tempItem.icon)
		local txtW3Cost2 = GetElement(self.m_root,"txtW3Cost2_WndHVSpirit",WZUILabelTTF)
		txtW3Cost2:setText(tCurSpiritStep.cost[1][2].."("..LocalStrings.OWN..self:getItemCountByItemId(tCurSpiritStep.cost[1][1])..")")
		local btnW3Cost2 = GetElement(self.m_root,"btnW3Cost2_WndHVSpirit",WZUIButton)
		btnW3Cost2:setVisible(true)
	end
end

--@brief 	点击返回精灵主界面
function WndHVSpirit:onClickW3Btn1(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:showWinUI(1)
end

--@brief 	点击进阶按钮
function WndHVSpirit:onClickW3Btn2(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tData[nDataIdx].spiritId]
	local tCurSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId,self.m_tData[nDataIdx].step)

	--已达最大进阶
	if tCurSpiritStep.cost == -1 then
		MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[15])
		return
	end

	--消耗物品不足
	if type(tCurSpiritStep.cost1) == "table" then
		for i=1,#tCurSpiritStep.cost1 do
			if CacheCenter:getPlayerItemCountById(tCurSpiritStep.cost1[i][1]) < tCurSpiritStep.cost1[i][2] then
				MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT31)
				return
			end
		end
	end
	if type(tCurSpiritStep.cost) == "table" then
		for i=1,#tCurSpiritStep.cost do
			if self:getItemCountByItemId(tCurSpiritStep.cost[i][1]) < tCurSpiritStep.cost[i][2] then
				MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT31)
				return
			end
		end
	end

	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_SpiritStep(self.m_tData[nDataIdx].spiritId)
end

--@brief 	点击进阶消耗物品按钮
function WndHVSpirit:onClickW3CostItem(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local tCurSpiritStep = self:getSpiritStep(self.m_tData[nDataIdx].spiritId, self.m_tData[nDataIdx].step)
	if tag == 1 then
		if type(tCurSpiritStep.cost1) == "table" then
			local info = GDatatab_item["id_"..tCurSpiritStep.cost1[1][1]]
			local tData = {lastTime=1,lastNum=1,basicInfo=CopyTable(info)}
			WndItemInfo:onCloseClick()
			WndItemInfo:showInfo(element,self.m_root,1,tData,false,nil,true)
		end
	elseif tag == 2 then
		if type(tCurSpiritStep.cost) == "table" then
			local info = GDatatab_item["id_"..tCurSpiritStep.cost[1][1]]
			local tData = {lastTime=1,lastNum=1,basicInfo=CopyTable(info)}
			WndItemInfo:onCloseClick()
			WndItemInfo:showInfo(element,self.m_root,1,tData,false,nil,true)
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function WndHVSpirit:_adaptLanguage_vn()
	GetElement(self.m_root,"txtW1Btn5_WndHVSpirit",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtW1SpiritHunger_WndHVSpirit",WZUILabelTTF):setScale(0.8)
	local txtW2QuickUpgrade = GetElement(self.m_root,"txtW2QuickUpgrade_WndHVSpirit",WZUILabelTTF)
	txtW2QuickUpgrade:setFontSize(16)
	txtW2QuickUpgrade:setDimensions(GlobalMethod:CCSize(100,0))

	local txtW1SpiritEffect = GetElement(self.m_root,"txtW1SpiritEffect_WndHVSpirit",WZUILabelTTF)
	txtW1SpiritEffect:setScale(0.8)
	txtW1SpiritEffect:setDimensions(GlobalMethod:CCSize(210,0))
	local txtW2SpiritEffect = GetElement(self.m_root,"txtW2SpiritEffect_WndHVSpirit",WZUILabelTTF)
	txtW2SpiritEffect:setScale(0.8)
	txtW2SpiritEffect:setDimensions(GlobalMethod:CCSize(210,0))
	local txtW3SpiritEffect = GetElement(self.m_root,"txtW3SpiritEffect_WndHVSpirit",WZUILabelTTF)
	txtW3SpiritEffect:setScale(0.8)
	txtW3SpiritEffect:setDimensions(GlobalMethod:CCSize(210,0))
end

-------------------------------------语言适配End----------------------------------------
