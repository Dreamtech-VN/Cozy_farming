--WndChristmasTree.lua
--@brief	WndChristmasTree的UI模块
--@date		2017/12/05
--@author	Tianxiang_Xu
--@note		圣诞树活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChristmasTree:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndChristmasTree:onExit(element)
	local conForReward = GetElement(self.m_root, "conForReward_WndChristmasTree", WZUIContainer)
	conForReward:disableSchedule()
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief 	界面加载完成回调
function WndChristmasTree:onEnterTransitionDidFinish(element)
	-- body
	self:_setSpineAni()
end

function WndChristmasTree:checkPointInBtn(pt)
	WZLog("WndApartmentAct:checkPoint")
	local btn = WndApartmentAct.m_root:getChildByTag(999)
	if btn == nil then return end
	
	local btnSize = btn:getContentSize()
	--获得btn的世界坐标
	ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
	WZLog("按钮大小",btnSize.width,btnSize.height, pt.x, pt.y, ptA.x, ptA.y)
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		return true
	else
		return false
	end 

end

--@brief    加载cell数据信息
function CellChristmasRankItem:onLoadData(element)
    -- body
    local rankIcon = {"ui/common/common_icon_1st.png", "ui/common/common_icon_2nd.png", "ui/common/common_icon_3rd.png"}
    --排名
    if self.m_tData.rank <= 3 then 
	   	local imgRank = WZUIImage:create()
	   	imgRank:setUseOriginSize(true)
	   	imgRank:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
	   	imgRank:setRelativePosition(GlobalMethod:ccp(0.1, 0.5))
	   	imgRank:setFile(rankIcon[self.m_tData.rank])
	   	imgRank:setScale(0.5)
	   	element:addChild(imgRank)
    else
    	local txtRank = WZUILabelAtlasFont:create()
	    txtRank:setText(self.m_tData.rank)
	    txtRank:setCharMapFileName("ui/common_num/common_num_pmsz.png")
	    txtRank:setHeight(30)
	    txtRank:setWidth(24)
	    txtRank:setStartChar(48)
	    txtRank:setUseOriginSize(true)
	    txtRank:setScale(0.6)
	    txtRank:setRelativePosition(GlobalMethod:ccp(0.1,0.5))
	    element:addChild(txtRank)
    end
    --角色名字
    local playerName = WZUILabelTTF:create()
    playerName:setText(self.m_tData.playerName)
    playerName:setFontSize(18)
    playerName:setColor(GlobalMethod:ccc3(255,255,255))
    playerName:setRelativePosition(GlobalMethod:ccp(0.4,0.5))
    element:addChild(playerName)
    --积分
    local score = WZUILabelTTF:create()
    score:setText(self.m_tData.score)
    score:setFontSize(18)
    score:setColor(GlobalMethod:ccc3(255,255,255))
    score:setRelativePosition(GlobalMethod:ccp(0.81,0.5))
    element:addChild(score)
    --线
    local imgLine = WZUIImage:create()
   	imgLine:setUseOriginSize(true)
   	imgLine:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
   	imgLine:setRelativePosition(GlobalMethod:ccp(0.5, 0))
   	imgLine:setFile("ui/gameActivity/christmas/merrychristmas_fengexian.png")
   	element:addChild(imgLine)
    --按钮
    local btnCheckInfo = WZUIButton:create()
    btnCheckInfo:setLuaDoneFunctionName("onClickCheck")
    element:addChild(btnCheckInfo)
end

--@brief 	查看玩家信息
function CellChristmasRankItem:onClickCheck(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndCheckOther:show(self.m_tData.playerId)
end

--@brief	点击礼物箱按钮回调
function WndChristmasTree:onClickBox(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nState = self:getActivityState()
	if nState == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.CHRISTMASTREE_TEXT16)
		return 
	end
	WndChristmasTreeBag:showInterface(self.m_tBagList, self.m_nBagMaxNum)
end

--@brief	点击免费或单次按钮回调
function WndChristmasTree:onClickFree(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_bIsLotterying then return end 
	--
	local nState = self:getActivityState()
	if nState == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.CHRISTMASTREE_TEXT16)
		return 
	elseif nState == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.CHRISTMASTREE_TEXT17)
		return 
	end
	--判断背包是否已满
	local nCurBagNum = #self.m_tBagList
	if self.m_nBagMaxNum <= nCurBagNum then
		MsgBoxManager:showTipBox(LocalStrings.CHRISTMASTREE_TEXT10)
		return 
	end
	self.m_nLotteryType = 1 
	if self.m_nFreeCount > 0 then 
		self.m_nLotteryType = 0 
	end
	if self.m_nLotteryType == 0 or (self.m_nLotteryType == 1 and JudgeMoneyIsEnough(self.m_tCostList[2].id, self.m_tCostList[2].num, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiamondInstead)) then
		self:sureUseDiamondInstead()
	end
end

--@brief  	确认用钻石代替立钻
function WndChristmasTree:sureUseDiamondInstead()
	-- body
	self.m_bIsLotterying = true
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ChristmasGiftLottery(self.m_nLotteryType)
end

--@brief	点击抽十次按钮回调
function WndChristmasTree:onClickTen(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_bIsLotterying then return end 
	local nState = self:getActivityState()
	if nState == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.CHRISTMASTREE_TEXT16)
		return 
	elseif nState == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.CHRISTMASTREE_TEXT17)
		return 
	end
	--判断背包是否已满
	local nCurBagNum = #self.m_tBagList
	if self.m_nBagMaxNum < nCurBagNum + 10 then
		MsgBoxManager:showTipBox(LocalStrings.CHRISTMASTREE_TEXT10)
		return 
	end

	self.m_nLotteryType = 2
	if not JudgeMoneyIsEnough(self.m_tCostList[3].id, self.m_tCostList[3].num, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then 
		return 
	end
	self:sureUseDiamondInstead()
end

--@brief    其它Item点击回调
function WndChristmasTree:onOthersClick(luaTable, tag, tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,WndApartmentAct.m_root, 1, tData, false)
end

--@brief 	点击预览按钮回调
function WndChristmasTree:onCheckReward(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndChristmasTree:onCheckReward")
	if WndApartmentAct.m_root:getChildByTag(888) then return end
	--屏蔽触摸层
    local img9Black = WZUI9Image:create()
    img9Black:setOpacity(0)
    img9Black:setFile("ui/common/common_black_bg.png")
    WndApartmentAct.m_root:addChild(img9Black, 888, 888)

	self:showRankReward()
end

--@brief 	窗口展示
function WndChristmasTree:showWindow()
	-- body
	local stringConfig = CacheCenter:getGameParam().christmasGiftConfig
	if stringConfig == nil then return end 
	local costConfig = json.decode(stringConfig)
	self.m_nBasicScore = tonumber(costConfig.baseIntegration)
	local id, num = SplitItemString(costConfig.consume)
	self.m_tCostList = {}
	for i = 1, #id do
		local tItem = {}
		tItem.id = tonumber(id[i])
		tItem.num = tonumber(num[i])

		table.insert(self.m_tCostList, tItem)
	end
	table.sort(self.m_tCostList, function (a,b)
		-- body
		return a.num < b.num 
	end)

	self:_update()
end

--@brief 	展示积分排名奖励预览
function WndChristmasTree:showRankReward()
	-- body
	WZLog("WndChristmasTree:showRankReward", Serialize(self.m_tRankRewardsList))
	local element = WZUISystem:getInstance():createElement("conForRankReward_WndChristmasTree")
	element:setVisible(true)
	WndApartmentAct.m_root:addChild(element, 999, 999)

	local tableRewardList = GetElement(element, "tableRewardList_WndChristmasTree", WZUITableContainer)
	tableRewardList:cleanTable()

	for i = 1, #self.m_tRankRewardsList do
		local element, tNewObj = CellChristmasRankRewardList:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tRankRewardsList[i])

			tableRewardList:setCellElement(element)
		end
	end
end

--@brief	加载
function CellChristmasRankRewardList:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("conRewardCell_WndChristmasTree")
	celElement:setVisible(true)
	element:addChild(celElement)

	local imgRankIndex = GetElement(element, "imgRankIndex_ConRewardCell", WZUIImage)
	local txtRankIndex = GetElement(element, "txtRankIndex_ConRewardCell", WZUILabelTTF)
	local rank = tonumber(self.m_tData.rank)
	if rank then
		imgRankIndex:setVisible(true)
		if rank == 1 then
			imgRankIndex:setFile("ui/common/common_icon_1st.png")
		elseif rank == 2 then
			imgRankIndex:setFile("ui/common/common_icon_2nd.png")
		else
			imgRankIndex:setFile("ui/common/common_icon_3rd.png")
		end
	else
		txtRankIndex:setVisible(true)
		local sIndex = string.gsub(self.m_tData.rank, "&", "-")
		txtRankIndex:setText(sIndex)
	end

	local id, num = SplitItemString(self.m_tData.reward)
	for i = 1, #id do
		local tempElement, tNewObj = CellGoodItem:createElement()
		local conReward = GetElement(element, "conReward" .. i .. "_WndChristMasTree", WZUIContainer)
		if tempElement and tNewObj then
			conReward:setVisible(true)
			tempElement:setScale(0.7)
			tNewObj:setCellGoodLocalId(tonumber(id[i]), tonumber(num[i]), 4)
			tNewObj:setItemClickFun(WndChristmasTree,WndChristmasTree.onOthersClick)
			conReward:addChild(tempElement)
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndChristmasTree:_update()
	-- body
	self:_showActiveTime()
	self.m_root:enableSchedule("_showActiveTime", 1)
	self:_createRankList()
	self:_createReward()
	self:_showAtt()
	self:_showCurScore()
	self:_showMyRank()
end

--@brief 	活动时间
function WndChristmasTree:_showActiveTime()
	-- body
	local nCurTime = SystemTime:getServerTime()
	local txtWord = GetElement(self.m_root, "txtWord_WndChristmasTree", WZUILabelTTF)
	local txtTime = GetElement(self.m_root, "txtTime_WndChristmasTree", WZUILabelTTF)
	local imgFreeRedDot = GetElement(self.m_root, "imgFreeRedDot_WndChristmasTree", WZUIImage)
	WZLog("WndChristmasTree:_showActiveTime", self.m_nEndTime, self.m_nDisappearTime, nCurTime)
	local sTimeWord, nLeftTime  
	if nCurTime < self.m_nStartTime then --活动未开始
		sTimeWord = LocalStrings.CHRISTMASTREE_TEXT2
		nLeftTime = self.m_nStartTime - nCurTime
	elseif nCurTime >= self.m_nStartTime and nCurTime < self.m_nEndTime then 
		sTimeWord = LocalStrings.CHRISTMASTREE_TEXT3
		nLeftTime = self.m_nEndTime - nCurTime
		if not imgFreeRedDot:isVisible() then 
			if self.m_nFreeCount > 0 then 
				imgFreeRedDot:setVisible(true)
			end
		end
	elseif nCurTime >= self.m_nEndTime and nCurTime < self.m_nDisappearTime then 
		sTimeWord = LocalStrings.CHRISTMASTREE_TEXT4
		nLeftTime = self.m_nDisappearTime - nCurTime
		if imgFreeRedDot:isVisible() then 
			imgFreeRedDot:setVisible(false)
		end
	elseif nCurTime >= self.m_nDisappearTime then 
		if WndChristmasTreeBag.m_root then 
			WndChristmasTreeBag:closeWindow()
		end
	end

	WZLog("WndChristmasTree:_showActiveTime LeftTime = ", nLeftTime)
	if txtWord then 
		txtWord:setText(sTimeWord)
	end
	if txtTime then 
		local nDays, nHours, nMinutes, nSeconds
		nDays = math.floor(nLeftTime/(24*3600))
		nHours = math.floor((nLeftTime - nDays * 24*3600)/3600)
		nMinutes = math.floor((nLeftTime - nDays * 24*3600 - nHours * 3600)/60)
		nSeconds = nLeftTime - nDays * 24*3600 - nHours * 3600 - nMinutes * 60
		if nLeftTime >= 24*3600 then 
			txtTime:setText(nDays .. LocalStrings.DAY .. nHours .. LocalStrings.HOUR1 .. nMinutes .. LocalStrings.MINUTE1)
		else
			txtTime:setText(nHours .. LocalStrings.HOUR1 .. nMinutes .. LocalStrings.MINUTE1 .. nSeconds .. LocalStrings.SECOND)
		end
	end
end

--@brief 	显示提示语
function WndChristmasTree:_showAtt()
	-- body
	local ftxtFreeAtt = GetElement(self.m_root, "ftxtFreeAtt_WndChristmasTree", WZUIFreeTextBox)
	if ftxtFreeAtt then 
		ftxtFreeAtt:setShowText(string.format(LocalStrings.CHRISTMASTREE_TEXT5, self.m_nBasicScore))
	end
	--
	local ftxtTenBtn = GetElement(self.m_root, "ftxtTenBtn_WndChristmasTree", WZUIFreeTextBox)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="16" P="1">X%d</T>]]
	if ftxtTenBtn then 
		local tBasicData = GDatatab_item["id_" .. self.m_tCostList[3].id]
		ftxtTenBtn:setShowText(string.format(sFormat, tBasicData.icon, self.m_tCostList[3].num))
	end
end

--@brief	显示当前全服积分
function WndChristmasTree:_showCurScore()
	-- body
	local txtCurScore = GetElement(self.m_root, "txtCurScore_WndChristmasTree", WZUILabelTTF)
	if txtCurScore then 
		txtCurScore:setText(self.m_nTotalScore .. "/" .. self.m_nBasicScore)
	end

	local ftxtFreeBtn = GetElement(self.m_root, "ftxtFreeBtn_WndChristmasTree", WZUIFreeTextBox)
	local txtFree = GetElement(self.m_root, "txtFree_WndChristmasTree", WZUILabelTTF)
	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="16" P="1">X%d</T>]]
	if ftxtFreeBtn then 
		local tBasicData = GDatatab_item["id_" .. self.m_tCostList[2].id]
		if self.m_nFreeCount > 0 then
			ftxtFreeBtn:setShowText(string.format(LocalStrings.CHRISTMASTREE_TEXT13, self.m_nFreeCount))
			txtFree:setText(LocalStrings.CHRISTMASTREE_TEXT7)
		else
			ftxtFreeBtn:setShowText(string.format(sFormat, tBasicData.icon, self.m_tCostList[2].num))
			txtFree:setText(LocalStrings.CHRISTMASTREE_TEXT21)
		end
	end
	--免费抽奖按钮红点
	self:showFreeBtnRedDot()
	--礼物箱红点
	self:showBoxRedDot()
end

--@brief 	礼物箱红点的显示与否
function WndChristmasTree:showBoxRedDot()
	-- body
	if self.m_root == nil then return end 
	--宝物箱红点
	local imgBoxRedDot = GetElement(self.m_root, "imgBoxRedDot_WndChristmasTree", WZUIImage)
	if imgBoxRedDot then 
		if #self.m_tBagList > 0 then 
			imgBoxRedDot:setVisible(true)
		else
			imgBoxRedDot:setVisible(false)
		end
	end
end

--@brief 	免费抽按钮红点的显示与否
function WndChristmasTree:showFreeBtnRedDot()
	-- body
	if self.m_root == nil then return end 
	--宝物箱红点
	local imgFreeRedDot = GetElement(self.m_root, "imgFreeRedDot_WndChristmasTree", WZUIImage)
	local nState = WndChristmasTree:getActivityState()
	if imgFreeRedDot then 
		if self.m_nFreeCount > 0 then 
			if nState == 1 then
				imgFreeRedDot:setVisible(true)
			else
				imgFreeRedDot:setVisible(false)
			end
		else
			imgFreeRedDot:setVisible(false)
		end
	end
end

--@brief 	展示我的排名
function WndChristmasTree:_showMyRank()
	-- body
	local ftxtMyRank = GetElement(self.m_root, "ftxtMyRank_WndChristmasTree", WZUIFreeTextBox)
	local sFormat = [[<T C="255,236,193" S="18" P="1">%s%d    %s%s</T>]]
	if ftxtMyRank then 
		if self.m_nMyRank <= 0 or self.m_nMyRank > 100 then 
			ftxtMyRank:setShowText(string.format(sFormat, LocalStrings.KING_RANK_MY_SCORE, self.m_nMyScore, LocalStrings.RANK_SCORE_RANK, LocalStrings.NOT_IN_RANKLIST))
		else
			ftxtMyRank:setShowText(string.format(sFormat, LocalStrings.KING_RANK_MY_SCORE, self.m_nMyScore, LocalStrings.RANK_SCORE_RANK, tostring(self.m_nMyRank)))
		end
	end
end

--@brief 	显示上榜名单
function WndChristmasTree:_createRankList()
	-- body
	local conForRank = GetElement(self.m_root, "conForRank_WndChristmasTree", WZUIContainer)
	local tableRankList = GetElement(self.m_root, "tableRankList_WndChristmasTree", WZUITableContainer)
	tableRankList:cleanTable()

	if self.m_tRankList == nil or #self.m_tRankList == 0 then 
		ShowPanelNullTip( conForRank, LocalStrings.NEWACTIVITY_TEXT6)
		return 
	end

	removeShowPanelNullTip(conForRank)

	--榜单
	for i = 1, #self.m_tRankList do
		local element, tNewObj = CellChristmasRankItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tRankList[i])
			tableRankList:setCellElement(element)
		end
	end
end

--@brief 	创建可获取的奖励物品
function WndChristmasTree:_createReward()
	-- body
	if self.m_tRewardsList == nil or #self.m_tRewardsList == 0 then return end

	for i = 1, #self.m_tRewardsList do
		local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndChristmasTree", WZUIContainer)
		if conItem:getChildByTag(99) then 
			conItem:removeChildByTag(99, true)
		end
		if conItem then 
			local element, tNewObj = CellGoodItem:createElement()
			if element and tNewObj then 
				tNewObj:setCellGoodLocalId(self.m_tRewardsList[i].id, self.m_tRewardsList[i].num, 4)
				tNewObj:setItemClickFun(self,self.onOthersClick)
				element:setScale(0.6)
				element:setTag(99)
				conItem:addChild(element)
			end
		end
	end
end

--@brief 	创建高亮特效框
function WndChristmasTree:_createEffect()
	-- body
	local conForReward = GetElement(self.m_root, "conForReward_WndChristmasTree", WZUIContainer)
	local lightSpine = GetElement(self.m_root, "spineLightRect_WndChristmasTree", WZUISpine)
	lightSpine:setVisible(true)

	local nIndex = self.m_tRandomNum[self.m_nActionIndex]
    if nIndex == 0 then nIndex = 1 end
    if nIndex > 15 then nIndex = 15 end
    if lightSpine then 
    	lightSpine:setRelativePosition(GlobalMethod:ccp(self.m_tGridPosition[nIndex][1], self.m_tGridPosition[nIndex][2]))
    end

    self.m_nActionIndex = self.m_nActionIndex + 1

    if self.m_nActionIndex > #self.m_tRandomNum then 
    	conForReward:disableSchedule() 
    	local btnBox = GetElement(self.m_root, "btnBox_WndChristmasTree", WZUIButton)
    	WndRewardShow:showById(self.m_tLotteryItemId, self.m_tLotteryItemNum, nil, nil, nil, nil, btnBox)
    	WndRewardShow:closeCallBack(self, self.removeSpineEffect)
    end
end

--@brief 	移除高亮特效框
function WndChristmasTree:removeSpineEffect()
	-- body
	GetElement(self.m_root, "spineLightRect_WndChristmasTree", WZUISpine):setVisible(false)
	self:resetLotteryState()
	self:_removeUnableTouchImage()
	
	self:_createRankList()
	self:_showCurScore()
	self:_showMyRank()
end

--@brief    拾取或祈福动画时，屏蔽掉操作
function WndChristmasTree:_createUnvisibleImage()
    -- body
    local img = WZUIImage:create()
    img:setFile("ui/common/common_black_bg.png")
    img:setScaleX(30)
    img:setScaleY(50)
    img:setOpacity(0)
    self.m_root:addChild(img,20,666)
    WZLog("WndChristmasTree:_createUnvisibleImage")
end

--@brief    移除触摸屏蔽
function WndChristmasTree:_removeUnableTouchImage()
    -- body
    WZLog("WndChristmasTree:_removeUnableTouchImage")
    if self.m_root:getChildByTag(666) then
        self.m_root:removeChildByTag(666, true)
    end
end

--@brief 	设置待机特效
function WndChristmasTree:_setSpineAni()
	local spinePath2 = "ui/otherUI/ls_jijun"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		local spineLightRect = GetElement(self.m_root, "spineLightRect_WndChristmasTree", WZUISpine)
		if spineLightRect then 
			spineLightRect:setFileJson(spinePath2 .. ".json")
			spineLightRect:setFileAtlas(spinePath2 .. ".atlas")
			spineLightRect:play("wait", true)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
