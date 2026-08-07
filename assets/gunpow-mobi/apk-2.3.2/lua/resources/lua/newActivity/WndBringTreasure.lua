--WndBringTreasure.lua
--@brief	WndBringTreasure的UI模块
--@date		2022/12/29
--@author	XTX
--@note		拜财神-招财进宝界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBringTreasure:onEnter(element)
	self.m_root = element

	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品

	self:_initStaticText()

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBringTreasure:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)

	self:_unInit()
end

--@brief    关闭窗口
function WndBringTreasure:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击开启按钮回调
function WndBringTreasure:onClickShake(element)
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
	local nTimes = nArrowNum >= self.m_nMaxLimit and self.m_nMaxLimit or nArrowNum > 0 and nArrowNum or 1
	
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
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 8, stringData)
end

--@brief    点击奖励回调
function WndBringTreasure:onClickItem(tCell, tData)
    WZLog("WndBringTreasure:onClickItem ")
    
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
function WndBringTreasure:onClickItem2(tCell, nTag, tData)
    WZLog("WndBringTreasure:onClickItem2 ")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData, false, nil, false)
end

--@brief 	点击领取按钮回调
function WndBringTreasure:onClickGet(element)
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

	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, strJson)
end

--@brief 	点击刷新按钮回调
function WndBringTreasure:onClickRefresh(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nRefreshCostId)
	local nCost = self.m_nFirstRefreshCost + self.m_nRefreshAddStep * self.m_nRefreshCount
	if nCost > nLightNum then 
		local basicData = GDatatab_item["id_" .. self.m_nRefreshCostId]
		MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicData.name))
		return 
	end

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, "")
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndBringTreasure:_update()
	-- body
	self:_setFreeBtnText()
	self:createRewardList()
	self:updateChooseNum()
	self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndBringTreasure:_initStaticText()
	GetElement(self.m_root, "txtPool_WndBringTreasure", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[4])
	GetElement(self.m_root, "txtTitle_WndBringTreasure", WZUILabelTTF):setText(LocalStrings.WORSHIPGOD_TEXT1[2])

	self:_setBallAni()
end

--@brief 	设置免费丢
function WndBringTreasure:_setFreeBtnText()
	local txtBtnOpenOne = GetElement(self.m_root, "txtBtnOne_WndBringTreasure", WZUILabelTTF)
	
	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nLightNum
	local nTimes = nTempTimes >= self.m_nMaxLimit and self.m_nMaxLimit or nTempTimes > 0 and nTempTimes or 1 
	
	txtBtnOpenOne:setText(string.format(LocalStrings.WORSHIPGOD_TEXT1[18], nTimes))
end

--@brief 	创建奖励列表
function WndBringTreasure:createRewardList()
	local tbReward = GetElement(self.m_root, "tbReward_WndBringTreasure", WZUITableContainer)
	tbReward:cleanTable()
	self.m_tSelItem = nil
	self.m_tCellPool = {}
	local tRewardData = self.m_tRewardPool

	for i = 1, #tRewardData do
		local element, tNewObj = CellMelonShakeItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setChipShopItemData(tRewardData[i], 1)
			element:setScale(0.8)

			tbReward:setCellElement(element)
			table.insert(self.m_tCellPool, tNewObj)
		end
	end
end

--@brief 	更新选择奖励数量显示
function WndBringTreasure:updateChooseNum()
	local ftxtChooseNum = GetElement(self.m_root, "ftxtChooseNum_WndBringTreasure", WZUIFreeTextBox)

	local nSelNum = self.m_tSelItem == nil and 0 or #self.m_tSelItem
	local nTotalShakeTimes = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	local nCanChooseNum = math.floor(nTotalShakeTimes/self.m_nTransBaseNum)

	local strContent = string.format(LocalStrings.WATERMELON_TEXT1[23], nTotalShakeTimes, self.m_nTransBaseNum, nSelNum, nCanChooseNum)
	ftxtChooseNum:setShowText(strContent)

	local btnGet = GetElement(self.m_root, "btnGet_WndBringTreasure", WZUIButton)
	if nSelNum > 0 then 
		btnGet:setTouchEnable(true)
	else
		btnGet:setTouchEnable(false)
	end
end

--@brief 	更新西瓜块的数量
function WndBringTreasure:_updateLightNum()
	-- body
	local txtOwnNum = GetElement(self.m_root, "txtOwnNum_WndBringTreasure", WZUILabelTTF)
	local imgCoinIcon = GetElement(self.m_root, "imgCoinIcon_WndBringTreasure", WZUIImage)
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	if txtOwnNum then 
		imgCoinIcon:setFile(basicData.icon)
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		txtOwnNum:setText(nLightNum)
	end

	--刷新消耗
	local ftxtRefreshCost = GetElement(self.m_root, "ftxtRefreshCost_WndBringTreasure", WZUIFreeTextBox)

	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,250,236" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
	local nCost = self.m_nFirstRefreshCost + self.m_nRefreshAddStep * self.m_nRefreshCount
	local strContent = string.format(sFormat, basicData.icon, nCost)
	ftxtRefreshCost:setShowText(strContent)
end

--@brief 	显示摇摇乐奖励
function WndBringTreasure:_showShakeRewards()
	for i = 1, #self.m_tShakeReward do
		local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndBringTreasure", WZUIContainer)
		if conItem:getChildByTag(99) then 
			conItem:removeChildByTag(99, true)
		end

		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			local tabItem = GDatatab_item["id_" .. self.m_tShakeReward[i].itemId]
			local itemInfo = {lastTime=self.m_tShakeReward[i].itemNum,lastNum=self.m_tShakeReward[i].itemNum,basicInfo=CopyTable(tabItem), origin = 8127062}
			tNewObj:setCellGoodItem(itemInfo, 5)
			tNewObj:setItemClickFun(self, self.onClickItem2)
			tNewObj:setItemCount(self.m_tShakeReward[i].itemNum)
			element:setTag(99)

			conItem:addChild(element)
		end
	end
end

--@brief 	设置待机特效
function WndBringTreasure:_setBallAni()
	local spinePath = "activity/ui_caishen_zcjb"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndBringTreasure", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(true)
		end
	else
		local _sIndex = "ui_caishen_zcjb"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7062, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndBringTreasure)
        end
	end
end

function WndBringTreasure:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndBringTreasure:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndBringTreasure:_setBowlingPlayAni(bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndBringTreasure", WZUISpine)
	WZLog("WndBringTreasure:_setBowlingPlayAni", bLoop)
	if spineOpen then 
		spineOpen:play("wait1", bLoop ~= nil and bLoop or true)
	end
end


-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndBringTreasure:_adaptLanguage_vn()
	local ftxtChooseNum = GetElement(self.m_root, "ftxtChooseNum_WndBringTreasure", WZUIFreeTextBox)
	ftxtChooseNum:setMaxWidth(300)
	ftxtChooseNum:setScale(0.7)
end

-------------------------------------语言适配模块End----------------------------------------

