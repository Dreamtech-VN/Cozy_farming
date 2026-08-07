--WndWatermelonShake.lua
--@brief	WndWatermelonShake的UI模块
--@date		2022/06/27
--@author	XTX
--@note		夏日西瓜摇摇乐


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWatermelonShake:onEnter(element)
	self.m_root = element

	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品

	self:_initStaticText()
	local tData = {}
	tData.shopType = self.m_nPoolIndex - 1
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, strJson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, "")

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWatermelonShake:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)

	self:_unInit()
end

--@brief    关闭窗口
function WndWatermelonShake:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击开启按钮回调
function WndWatermelonShake:onClickShake(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nArrowNum
	local nTimes = nTag
	if nTag == 10 then 
		nTimes = nTempTimes >= self.m_nMaxLimit and self.m_nMaxLimit or nTempTimes > 0 and nTempTimes or self.m_nMaxLimit 
	end
	local nCostNum = nTimes
	if nCostNum > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicData.name))
		return 
	end
    local tData = {}
	tData.times = nTimes

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 9, stringData)
end

--@brief 	点击奖池标签回调
function WndWatermelonShake:onClickPool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_nPoolIndex == nTag then return end 

	self.m_nPoolIndex = nTag
	if self.m_tRewardPool[self.m_nPoolIndex] == nil then 
		local tData = {}
		tData.shopType = self.m_nPoolIndex - 1
		local strJson = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, strJson)	
		return 
	end

	local tRewardData = self.m_tRewardPool[self.m_nPoolIndex]
	self.m_nTransBaseNum = tRewardData[1].price
	self:createRewardList()
	self:updateChooseNum()
end

--@brief    点击奖励回调
function WndWatermelonShake:onClickItem(tCell, tData)
    WZLog("WndWatermelonShake:onClickItem ")
    
    if self.m_tSelItem == nil then self.m_tSelItem = {} end 

    local bIsChoose = false 
    for i = 1, #self.m_tSelItem do
    	if self.m_tSelItem[i] == tData.id then
    		bIsChoose = true 
    		table.remove(self.m_tSelItem, i)
    		break 
    	end
    end

    local nTotalShakeTimes = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
    if self.m_nPoolIndex == 2 then 
    	nTotalShakeTimes = CacheCenter:getPlayerItemCountById(self.m_nCoinId3)
    end
    local nCanChooseNum = math.floor(nTotalShakeTimes/self.m_nTransBaseNum)
    if bIsChoose then 
    	tCell:setItemSelState(false)
    else
    	if #self.m_tSelItem >= nCanChooseNum then 
    		MsgBoxManager:showTipBox(LocalStrings.WATERMELON_TEXT1[24])
    		return 
    	end
    	table.insert(self.m_tSelItem, tData.id)
    	tCell:setItemSelState(true)
    end

    self:updateChooseNum()
end

--@brief    点击奖励回调
function WndWatermelonShake:onClickItem2(tCell, nTag, tData)
    WZLog("WndWatermelonShake:onClickItem2 ", Serialize(tData))
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData, false, nil, false)
end

--@brief 	点击领取按钮回调
function WndWatermelonShake:onClickGet(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tSelItem == nil or #self.m_tSelItem == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.FOURYEAR_TEXT12)
		return 
	end

	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 or CacheCenter:getRemainAmount() - #self.m_tSelItem < 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

	local tData = {}
	tData.id = CopyTable(self.m_tSelItem)
	tData.num = {}
	for i = 1, #self.m_tSelItem do
		tData.num[i] = 1
	end
	tData.shopType = self.m_nPoolIndex - 1

	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, strJson)
end

--@brief 	点击刷新按钮回调
function WndWatermelonShake:onClickRefresh(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nCost = self.m_nFirstRefreshCost + self.m_nRefreshAddStep * self.m_nRefreshCount
	if nCost > nLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicData.name))
		return 
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 8, "")
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndWatermelonShake:_update()
	-- body
	self:_setFreeBtnText()
	self:createRewardList()
	self:updateChooseNum()
	self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndWatermelonShake:_initStaticText()
	GetElement(self.m_root, "txtSPool1_WndWatermelonShake", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[17])
	GetElement(self.m_root, "txtSPool2_WndWatermelonShake", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[17])
	GetElement(self.m_root, "txtAPool1_WndWatermelonShake", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[18])
	GetElement(self.m_root, "txtAPool2_WndWatermelonShake", WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[18])

	self:_setSpineEffect()
end

--@brief 	设置免费丢
function WndWatermelonShake:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOne_WndWatermelonShake", WZUILabelTTF)
	local txtBtnOpenFive = GetElement(self.m_root, "txtBtnTen_WndWatermelonShake", WZUILabelTTF)
	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nLightNum
	local nTimes = nTempTimes >= self.m_nMaxLimit and self.m_nMaxLimit or nTempTimes > 0 and nTempTimes or self.m_nMaxLimit 
	
	txtBtnOpenOne:setText(string.format(LocalStrings.WATERMELON_TEXT1[16], 1))
	txtBtnOpenFive:setText(string.format(LocalStrings.WATERMELON_TEXT1[16], nTimes))
end

--@brief 	创建奖励列表
function WndWatermelonShake:createRewardList()
	local tbReward = GetElement(self.m_root, "tbReward_WndWatermelonShake", WZUITableContainer)
	tbReward:cleanTable()
	self.m_tSelItem = nil
	self.m_tCellPool = {}
	local tRewardData = self.m_tRewardPool[self.m_nPoolIndex]

	for i = 1, #tRewardData do
		local element, tNewObj = CellMelonShakeItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setChipShopItemData(tRewardData[i])
			element:setScale(0.95)

			tbReward:setCellElement(element)
			table.insert(self.m_tCellPool, tNewObj)
		end
	end
end

--@brief 	更新选择奖励数量显示
function WndWatermelonShake:updateChooseNum()
	local ftxtChooseNum = GetElement(self.m_root, "ftxtChooseNum_WndWatermelonShake", WZUIFreeTextBox)

	local nSelNum = self.m_tSelItem == nil and 0 or #self.m_tSelItem
	local nTotalShakeTimes = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	if self.m_nPoolIndex == 2 then 
		nTotalShakeTimes = CacheCenter:getPlayerItemCountById(self.m_nCoinId3)
	end
	local nCanChooseNum = math.floor(nTotalShakeTimes/self.m_nTransBaseNum)

	local strContent = string.format(LocalStrings.WATERMELON_TEXT1[23], nTotalShakeTimes, self.m_nTransBaseNum, nSelNum, nCanChooseNum)
	ftxtChooseNum:setShowText(strContent)

	local btnGet = GetElement(self.m_root, "btnGet_WndWatermelonShake", WZUIButton)
	if nSelNum > 0 then 
		btnGet:setTouchEnable(true)
	else
		btnGet:setTouchEnable(false)
	end
end

--@brief 	更新西瓜块的数量
function WndWatermelonShake:_updateLightNum()
	-- body
	local txtOwnNum = GetElement(self.m_root, "txtOwnNum_WndWatermelonShake", WZUILabelTTF)
	local imgCoinIcon = GetElement(self.m_root, "imgCoinIcon_WndWatermelonShake", WZUIImage)
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	if txtOwnNum then 
		imgCoinIcon:setFile(basicData.icon)
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		txtOwnNum:setText(nLightNum)
	end

	--刷新消耗
	local ftxtRefreshCost = GetElement(self.m_root, "ftxtRefreshCost_WndWatermelonShake", WZUIFreeTextBox)

	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,250,236" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	local nCost = self.m_nFirstRefreshCost + self.m_nRefreshAddStep * self.m_nRefreshCount
	local strContent = string.format(sFormat, basicData.icon, nCost)
	ftxtRefreshCost:setShowText(strContent)
end

--@brief 	显示摇摇乐奖励
function WndWatermelonShake:_showShakeRewards()
	for i = 1, #self.m_tShakeReward do
		local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndWatermelonShake", WZUIContainer)
		if conItem:getChildByTag(99) then 
			conItem:removeChildByTag(99, true)
		end

		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			local tabItem = GDatatab_item["id_" .. self.m_tShakeReward[i].itemId]
			local itemInfo = {lastTime=self.m_tShakeReward[i].itemNum,lastNum=self.m_tShakeReward[i].itemNum,basicInfo=CopyTable(tabItem), origin = 837051}
			tNewObj:setCellGoodItem(itemInfo, 5)
			tNewObj:setItemClickFun(self, self.onClickItem2)
			tNewObj:setItemCount(self.m_tShakeReward[i].itemNum)
			element:setTag(99)

			conItem:addChild(element)
		end
	end
end

--@brief 	设置待机特效
function WndWatermelonShake:_setSpineEffect()
	local spinePath = "activity/ui_xigua_yyl"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineRect = GetElement(self.m_root, "spineRect_WndWatermelonShake", WZUISpine)
		if spineRect then 
			spineRect:setFileJson(spinePath .. ".json")
			spineRect:setFileAtlas(spinePath .. ".atlas")
			spineRect:setAnimationName("wait1")
		end
	else
		local _sIndex = "ui_xigua_yyl"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7051, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndWatermelonShake)
        end
	end
end

function WndWatermelonShake:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndWatermelonShake:downloadEffectCallback",taskId,extraData,failed)
    self:_setSpineEffect()
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------

function WndWatermelonShake:_adaptLanguage_vn()
	local ftxtChooseNum = GetElement(self.m_root, "ftxtChooseNum_WndWatermelonShake", WZUIFreeTextBox)
	ftxtChooseNum:setMaxWidth(280)
end

-------------------------------------语言适配End----------------------------------------
