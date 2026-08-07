--WndSynthesisLeft.lua
--@brief	WndSynthesisLeft的UI模块
--@date		2015/07/17
--@author	zsq
--@note		合成系统左侧窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSynthesisLeft:onEnter(element)
	self.m_root = element
    if ProjConfig.CHANNEl_ID == 1048 or ProjConfig.CHANNEl_ID == 1051 
        or ProjConfig.CHANNEL_ID == 1053 then
        GetElement(self.m_root,"conQuickSyn_WndSynthesisLeft",WZUIContainer):setVisible(false)
    end
end

--@brief	加载完成
function WndSynthesisLeft:onEnterTransitionDidFinish(element)

	local txtQuickCraft = GetElement(self.m_root,"txtQuickCraft_WndSynthesisLeft",WZUILabelTTF)
    local nButtonId = 181   --功能开放表对应id
    local tBtnsInfo = GDatatab_button_info["id_"..nButtonId]
    if CacheCenter:getPlayerInfo().vipLevel < 3 and not whetherHaveWelfareCard() and CacheCenter:getPlayerInfo().level < tBtnsInfo.open_level then
    	txtQuickCraft:setVisible(true)
    else
    	txtQuickCraft:setVisible(false)
	end

    local selQuick = GetElement(self.m_root, "selCheckBox_WndSynthesis", WZUICheckBox)
	if self.m_bQuick then
    	selQuick:setCheckIndex(1)
	else
    	selQuick:setCheckIndex(0)
	end
	
	self:initBtn()

    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSynthesisLeft:onExit(element)
	self:_unInit()
end

--@brief	设置按钮
function WndSynthesisLeft:initBtn()
	GetElement(self.m_root,"mutiReduce_WndOpenChest",WZUIButton):setLuaActionName("Normal")
	GetElement(self.m_root,"mutiAdd_WndOpenChest",WZUIButton):setLuaActionName("Normal")
	GetElement(self.m_root,"reduce_WndOpenChest",WZUIButton):setLuaActionName("Normal")
	GetElement(self.m_root,"add_WndOpenChest",WZUIButton):setLuaActionName("Normal")
end

--@brief	返回按钮
function WndSynthesisLeft:onReturn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    g_bIsShowWndDressUp = true

	-- WindowManagerAni:createMoveOut(WndBagRole.m_tWndSynthesisList.m_root,0,true,GetElement(WndBagRole.m_root,"conLeft_WndBag",WZUIContainer))
	-- WindowManagerAni:createMoveOut(WndBagRole.m_tWndSynthesis.m_root,1,true,GetElement(WndBagRole.m_root,"conRight_WndBag",WZUIContainer))
	WndBagRole.m_tWndSynthesisList.m_root:setVisible(false)
	WndBagRole.m_tWndSynthesis.m_root:setVisible(false)
	GetElement(WndBagRole.m_root,"conLeft_WndBag",WZUIContainer):setVisible(true)
	GetElement(WndBagRole.m_root,"conRight_WndBag",WZUIContainer):setVisible(true)
end

--@brief	点击快速合成按钮后的回调
--@param	element:按钮绑定的UI节点引用
--@note		刷新右边界面,放上最多的材料
function WndSynthesisLeft:onQuick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --检查VIP等级
    local cb = WZUICheckBox:luaTo(element)

    local nButtonId = 181   --功能开放表对应id
    local tBtnsInfo = GDatatab_button_info["id_"..nButtonId]
    if CacheCenter:getPlayerInfo().vipLevel < 3 and not whetherHaveWelfareCard() and CacheCenter:getPlayerInfo().level < tBtnsInfo.open_level then
    	local sMsg = string.format(LocalStrings.WELFARECARD_VIP_TIP, tBtnsInfo.open_level, 3)
        MsgBoxManager:showConfirmCancelBox(sMsg, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
    	cb:setCheckIndex(0)
		self.m_bQuick = false
		return
	end

    if self.m_tPutItem == nil then
        --提示错误信息:请放置材料
        MsgBoxManager:showTipBox(LocalStrings.PUT_SYNTHESIS_MATERIAL)
        --cb:setCheckIndex(0)
		--self.m_bQuick = false
        return
    end
	
	if self.m_bQuick == nil then self.m_bQuick = false end

	self.m_bQuick = not self.m_bQuick

    local nTag = self.m_tPutItem:getFromTag()
	--刷新右边界面
	WndSynthesisRight:updateRightList()
	--获得快速合成的物品数据
	local tData = WndSynthesisRight:_getItemByPlayerItemId(self.m_tPutItem.m_tItem.playerItemId)
    --local tData = WndSynthesisRight:_getItemByTag(nTag).m_tItem
	if self.m_bQuick then
		--localData表数据
    	local tMerge = self:_getMergeInfo(tData.id)

		--获得快速合成的物品数据
		local tDataCell = WndSynthesisRight:_getItemByPlayerItemId(tData.playerItemId)
    	local nScrapCount =  tMerge.scrap[1][2]
    
		self.m_nMergeMax = math.floor(tDataCell.lastNum/nScrapCount)
		self.m_nMergeNum = self.m_nMergeMax
	end
	--放置材料
    self:_putItem(nTag, tData, self.m_bQuick)
end

--@brief	提示充值框的回调
--@param	nId:消息id
--@param	nResType:响应类型(超时，确定，取消)
function WndSynthesisLeft:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
    end
end

function WndSynthesisLeft:onTouchEnd()
    --重置快速合成
    local selQuick = GetElement(self.m_root, "selCheckBox_WndSynthesis", WZUICheckBox)
	if self.m_bQuick then
    	selQuick:setCheckIndex(1)
	else
    	selQuick:setCheckIndex(0)
	end
end

--@brief    摆放物品
--@param    nTag:序号   用来取右侧的格子
--@param    tData:物品数据表
--@param    bQuick:是否是快速合成
--@param    clearItem:是否需要返回物品
--@param    reset:是否是重新放置的物品
function WndSynthesisLeft:_putItem(nTag, tData, bQuick, clearItem, reset)
	--WZLog("WndSynthesisLeft:_putItem",nTag,bQuick)
	bQuick = self.m_bQuick
	self.m_nTag = nTag
	self.m_tData = tData
    local tItem = WndSynthesisRight:_getItemByTag(nTag)
	if tItem == nil then return end
	if tData == nil then return end
	if tItem.m_tItem == nil then return end
	if self.m_root == nil then return end
	if self.m_root:isVisible() == false then return end
	--WZLog("右侧格子里的数据是",Serialize(tItem.m_tItem))
	--上次合成的物品和这次放置的物品不是同样的，返回
	if tItem.m_tItem.playerItemId ~= tData.playerItemId then
   		self:_clearPutItem()
		return
	end
	local reset = reset or false
	local clearItem = clearItem or true
	--清空左侧，还原右侧
   	self:_clearPutItem()

	--localData表数据
    self.m_tMergeInfo = self:_getMergeInfo(tData.id)
    if self.m_tMergeInfo == nil then
        --提示错误信息:查找合成数据失败
        MsgBoxManager:showTipBox(LocalStrings.CANNOT_FIND_SYNTHESIS_DATA)
        return
    end

	--获得快速合成的物品数据
	local tDataCell = WndSynthesisRight:_getItemByPlayerItemId(tData.playerItemId)
    local nScrapCount =  self.m_tMergeInfo.scrap[1][2]
	--WZLog("wtf******",Serialize(tDataCell))
    if tDataCell == nil or nScrapCount > tDataCell.lastNum then
        --提示错误信息:合成材料不足
		if reset == false then
        	MsgBoxManager:showTipBox(LocalStrings.CAN_NOT_MATERIALS)
			WndFastGetItems:show(tDataCell.basicInfo.id)
		end
        return
    end
    
    local n = 1 --合成次数，不开启快速合成时为1
    local tPutItemData = CopyTable(tDataCell)
    if bQuick == true then
		self.m_nMergeMax = math.floor(tDataCell.lastNum/nScrapCount)
		if self.m_nMergeNum == nil then self.m_nMergeNum = self.m_nMergeMax end
	--	self.m_nMergeNum = self.m_nMergeMax
        n = self.m_nMergeNum
    end
    
	WZLog("快速合成数量",n)
	--MsgBoxManager:showTipBox(tostring(self.m_nMergeNum).."_"..tostring(self.m_nMergeMax))
	--设置右侧物品减去材料后的数量
    local tItem = WndSynthesisRight:_getItemByTag(nTag)
	if tItem.m_tItem.lastNum-nScrapCount*n == 0 then
		tItem:removeAllChild()
	else
    	self:_updateGoodItemWithNumber(tItem, tItem.m_tItem.lastNum-nScrapCount*n)
	end
    
	--显示放置的材料
    tPutItemData.lastNum = self.m_tMergeInfo.scrap[1][2]*n
    local tTypeArray = {10, 10, 10, 10, 10 ,10, 10}
    local ePutItem, tPutItem = self:_createCellGoodItem(nTag)
    tPutItem:setCellGoodItem(tPutItemData, tTypeArray[WndSynthesisRight.m_nSelectedIndex])
    tPutItem:setItemClickFun(self, self.onClickPutItem)
    local conMix1 = GetElement(self.m_root, "conMix1_WndSynthesis")
    conMix1:addChild(ePutItem)
    --Add By Tianxiang_Xu
    --当选中快速合成时，显示合成消耗的数量
    if bQuick == true then 
        self:_updateGoodItemWithNumber(tPutItem, nScrapCount*n)
    end
    --End Add 
    self.m_tPutItem = tPutItem

    local tResultInfo = self.m_tMergeInfo.items[1]
    local tResultItemData = {
        id = tResultInfo[1],
        lastNum = tResultInfo[2]*n,
        lastTime = tResultInfo[2]*n,
        isUse = false,
        data = "",
        playerItemId = -1,
        basicInfo = GetItemLocalData(tResultInfo[1])
    }
	--显示合成后的物品
    local eResultItem, tResultItem = self:_createCellGoodItem(9999)
    tResultItem:setCellGoodItem(tResultItemData, 10)
    tResultItem:setItemClickFun(self, self.onClickResultItem)
    local conMix2 = GetElement(self.m_root, "conMix2_WndSynthesis")
    conMix2:addChild(eResultItem)
    self.m_tResultItem = tResultItem
    
    self:_updateCurrency(n) --显示合成货币消耗信息
	GetElement(self.m_root,"useNum_WndSynthesisLeft",WZUILabelTTF):setText(n)

	--合成皮肤特殊处理，判断是否转化
	NOTRECYCLESKINIDS = {}
	if tResultItemData.basicInfo.main_type == 20 then
		local show = true
		if WndPhantom.m_tDataList ~= nil then  
			local sId = tResultItemData.basicInfo.property[1][1]
			for i=1,#WndPhantom.m_tDataList do
				if WndPhantom.m_tDataList[i].shapeId == sId then
					if WndPhantom.m_tDataList[i].remainTime == -1 then
						show = false
					end
				end
			end
		end
	WZLog("NOTRECYCLEIDS_0", show)
		
		if show == true and (not utilsValueInTable(tResultItemData.basicInfo.id, NOTRECYCLESKINIDS)) then
			table.insert(NOTRECYCLESKINIDS, tResultItemData.basicInfo.id)
		end
	end
	WZLog("NOTRECYCLEIDS_1", Serialize(NOTRECYCLESKINIDS))
    
	--显示特效
	GetElement(self.m_root,"armature_WndSynthesisLeft",WZArmature):setVisible(true)
end

--@brief    清除已摆放的物品,刷新右侧物品
--@param    bQuick:快速合成是否开启
function WndSynthesisLeft:_clearPutItem(bQuick)
	--WZLog("WndSynthesisLeft:_clearPutItem",bQuick)
    if self.m_root == nil then return end
    --删除碎片材料节点
    if self.m_tPutItem ~= nil then
        self.m_tPutItem.m_root:removeFromParentAndCleanup(true)
        self.m_tPutItem = nil
    end

    --删除合成结果节点
    if self.m_tResultItem ~= nil then
        self.m_tResultItem.m_root:removeFromParentAndCleanup(true)
        self.m_tResultItem = nil
    end

    --清除货币信息
    local ftbCost = GetElement(self.m_root, "ftbCost_WndSynthesisLeft", WZUIFreeTextBox)
    ftbCost:setShowText("")
	GetElement(self.m_root,"useNum_WndSynthesisLeft",WZUILabelTTF):setText("1")

    self.m_tMergeInfo = nil

	--隐藏特效
	GetElement(self.m_root,"armature_WndSynthesisLeft",WZArmature):setVisible(false)

	--刷新右边界面
	WndSynthesisRight:updateRightList()
end

--@brief    创建一个物品格子
--@param    nTag，序号
--@param    tData，物品数据表
function WndSynthesisLeft:_createCellGoodItem(nTag)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setTag(nTag)
    tItem:setFromTag(nTag)
    return eItem, tItem
end

--@brief    更新物品数量信息
--@param    tItem:物品绑定的lua对象
--@param    nNumber:数量
function WndSynthesisLeft:_updateGoodItemWithNumber(tItem, nNumber)
    if tItem == nil then
        return
    end
    --WZLog("WndSynthesisLeft:_updateGoodItemWithNumber", nNumber)
    local tData = tItem.m_tItem
    if tData ~= nil and tData.lastNum == 0 and  nNumber > 0 then
        tItem:setQuality(tData.basicInfo.quality)
        tItem:setConItemVisible(true)
        tItem.m_root:setTouchEnable(true)
    end
    tItem:setItemNumber(nNumber)
    if nNumber == 0 then
        tItem:setQuality(0)
        tItem:setConItemVisible(false)
        tItem.m_root:setTouchEnable(false)
    end
end

--@brief    更新货币信息
--@param    倍数
function WndSynthesisLeft:_updateCurrency(nMultiple)
    if self.m_tMergeInfo == nil then
        return
    end

    local strTitleformat = [[<T C="255,236,193" S="22" P="1" SC="132,66,29" SE="1" SS="4">%s</T>]]
    local strImgformat = [[<I Z="0.5">%s</I>]]
    local strValueformat = [[<T C="255,236,193" S="22" P="1" SC="132,66,29" SE="1" SS="4">%s</T>]]
    local strCost = string.format(strTitleformat,LocalStrings.BAGTIP15)
    for i=1,#self.m_tMergeInfo.cost do
    	local nCurrencyId = self.m_tMergeInfo.cost[i][1]
	    local nCurrencyCount = self.m_tMergeInfo.cost[i][2]*nMultiple
	    local tCurrency = GetItemLocalData(nCurrencyId)

	    if tCurrency then
	    	strCost = strCost .. string.format(strImgformat, tCurrency.icon)
	    	strCost = strCost .. string.format(strValueformat, nCurrencyCount)
	    end
    end

    local ftbCost = GetElement(self.m_root, "ftbCost_WndSynthesisLeft", WZUIFreeTextBox)
    ftbCost:setShowText(strCost)

end

--@brief	合成成功后的回调
--@note     由协议层回调
function WndSynthesisLeft:synthesisSuccess()
	if self.m_root == nil then return end
	--MsgBoxManager:showTipBox("协议返回花费时间"..(WZThread:getUTickCount()-self.startTime))
	WndSynthesisRight:_showSuccessAnimation()
	GetElement(self.m_root,"armature1_WndSynthesisLeft",WZArmature):setVisible(true)
	GetElement(self.m_root,"armature1_WndSynthesisLeft",WZArmature):play("0")
	WZLog("合成结果",Serialize(self.m_tSuccessItemInfo))
	if self.m_tSuccessItemInfo ~= nil then
		if WndSynthesisRight.m_nSelectedIndex == 5 then
			if self.m_bHasSkin == false then
				if self.m_tSuccessItemInfo.count == 1 then
					WndRewardShow:showById({self.m_tSuccessItemInfo.id},{self.m_tSuccessItemInfo.count})
				elseif self.m_tSuccessItemInfo.count > 1 then
					local tItem = GDatatab_item["id_"..self.m_tSuccessItemInfo.id]
					local getId = tItem.recycleMess[1][1]
					local getNum = tItem.recycleMess[1][2]*(self.m_tSuccessItemInfo.count-1)
					WndRewardShow:showById({self.m_tSuccessItemInfo.id,getId},{1,getNum})
				end
			else
				local tItem = GDatatab_item["id_"..self.m_tSuccessItemInfo.id]
				local getId = tItem.recycleMess[1][1]
				local getNum = tItem.recycleMess[1][2]*self.m_tSuccessItemInfo.count
				WndRewardShow:showById({getId},{getNum})
			end
		else
			WndRewardShow:showById({self.m_tSuccessItemInfo.id},{self.m_tSuccessItemInfo.count})
		end
		--合成前没有该皮肤，弹出获得皮肤窗口
		if WndSynthesisRight.m_nSelectedIndex == 5 and self.m_bHasSkin == false then
			WndRewardShow:closeCallBack(self,self.synthesisSuccessCall)
		end
	end
    pushEquipInList()
    g_bIsShowWndDressUp = true

	--清除左侧界面
	self:_clearPutItem()

    --重置快速合成
	--self.m_bQuick = false
    --local selQuick = GetElement(self.m_root, "selCheckBox_WndSynthesis", WZUICheckBox)
    --selQuick:setCheckIndex(0)
end

function WndSynthesisLeft:synthesisSuccessCall() 
		local tItem = GDatatab_item["id_"..self.m_tSuccessItemInfo.id] 

		local t = {}
		t.shapeId = tItem.property[1][1]
		t.remainTime = -1
		t.changeItemId = {}
		t.changeNum = {}
	WndPhantomShow:show(t)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	点击合成按钮后的回调
--@param	element:按钮绑定的UI节点引用
function WndSynthesisLeft:onSynthesis(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tPutItem == nil then
		MsgBoxManager:showTipBox(LocalStrings.PUT_SYNTHESIS_MATERIAL)
		return
    end
	--记录合成结果
    if self.m_tResultItem then
        self.m_tSuccessItemInfo = {}
        self.m_tSuccessItemInfo.id = self.m_tResultItem.m_tItem.id
        self.m_tSuccessItemInfo.count = self.m_tResultItem.m_tItem.lastNum
    end

    local nTag = self.m_tPutItem:getFromTag()
    local tData = self.m_tPutItem.m_tItem
	--合成前的数量
    self.m_tItemIdNum = {}
    self.m_tItemIdNum.id = self.m_tMergeInfo.items[1][1]
    self.m_tItemIdNum.num = CacheCenter:getPlayerItemCountById(self.m_tMergeInfo.items[1][1])

    --判断金币是否足够
    local tCost = self.m_tMergeInfo.cost
    local playerGold = CacheCenter:getMoneyList().gold
    for i=1,#tCost do
		if tCost[i][1] == 2 then
	    	if tCost[i][2] > playerGold then
	    	    MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil, nil)
	    	    return
	    	end
		else
			if tCost[i][2] > CacheCenter:getPlayerItemCountById(tCost[i][1]) then
					local limitLeave = -1
					--判断物品是否限购
					CacheCenter:getShopItems(function(t,shopItemList)
						for k,v in pairs(shopItemList)	do
							if v.shopItemId == tCost[i][1] and v.isOnSale == true then
								limitLeave = v.limitLeave
								break
							end
						end
					end)
					WZLog("限购数"..limitLeave)
					if limitLeave == -1 then
						--不限购
						checkIsOnSale(tCost[i][1])	
					--elseif limitLeave == 0 then
						--限购且购买次数已经用完
						--MsgBoxManager:showTipBox(LocalStrings.PETNOGOODS)
					else
						--限购且购买次数没有用完
						checkIsOnSale(tCost[i][1])	
					end
				return
			end
		end
    end
    
    local selCheckBox = GetElement(self.m_root, "selCheckBox_WndSynthesis", WZUICheckBox)
    local bIsFast = false
    if selCheckBox:getCheckIndex() == 1 then
        bIsFast = true
    end

    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}

	local mergeType = {1,2,0,0,4} 
	--self.startTime = WZThread:getUTickCount()
	WZLog("发送合成协议",tData.playerItemId, bIsFast, mergeType[WndSynthesisRight.m_nSelectedIndex], self.m_nMergeNum)
	if WndSynthesisRight.m_nSelectedIndex == 5 then
		self.m_bHasSkin = false
		local tItem = GDatatab_item["id_"..self.m_tResultItem.m_tItem.id] 
		for i=1,#WndPhantom.m_tDataList do
			if WndPhantom.m_tDataList[i].remainTime == -1 and WndPhantom.m_tDataList[i].shapeId == tItem.property[1][1] then
				self.m_bHasSkin = true
				break
			end
		end
	else
		self.m_bHasSkin = false
	end

	if bIsFast == true then
    	ProtocolProcessorMerge:send_MERGE_MergeItem(tData.playerItemId, bIsFast, mergeType[WndSynthesisRight.m_nSelectedIndex], self.m_nMergeNum)
	else
    	ProtocolProcessorMerge:send_MERGE_MergeItem(tData.playerItemId, bIsFast, mergeType[WndSynthesisRight.m_nSelectedIndex], 1)
	end
end

--@brief    快速购买金币框
--@param    nResType:响应类型(超时，确定，取消)
function WndSynthesisLeft:buyGold(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(26)
    end
end


--@brief	点击按钮后的回调
--@param	element:按钮绑定的UI节点引用
--@note     没放置材料时点击相关按钮的回调
function WndSynthesisLeft:onEmpty(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --提示错误信息:请放置材料
    --MsgBoxManager:showTipBox(LocalStrings.PUT_SYNTHESIS_MATERIAL)
end

--@brief	点击已摆放物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndSynthesisLeft:onClickPutItem(tItem, nTag, tData)
    WndItemInfo:onCloseClick()
	WndSynthesisRight:_showDisboardItemTipWindow(tItem, nTag, tData)
end

--@brief	点击合成结果物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndSynthesisLeft:onClickResultItem(tItem, nTag, tData)
    WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tItem.m_root,WndSynthesisRight.m_root,1,tData, false)
end

function WndSynthesisLeft:onMutiAdd()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self:checkQuick() then return end
	self.m_nMergeNum = math.min(self.m_nMergeMax, self.m_nMergeNum + 10)
	self:putQuickItem()
end

function WndSynthesisLeft:onMutiReduce()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self:checkQuick() then return end
	self.m_nMergeNum = math.max(1, self.m_nMergeNum - 10)
	self:putQuickItem()
end

function WndSynthesisLeft:onAdd()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self:checkQuick() then return end
	self.m_nMergeNum = math.min(self.m_nMergeMax, self.m_nMergeNum + 1)
	self:putQuickItem()
end

function WndSynthesisLeft:onReduce()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self:checkQuick() then return end
	self.m_nMergeNum = math.max(1, self.m_nMergeNum - 1)
	self:putQuickItem()
end

function WndSynthesisLeft:putQuickItem()
	WZLog("WndSynthesisLeft:putQuickItem")
    local nTag = self.m_tPutItem:getFromTag()
	--刷新右边界面
	WndSynthesisRight:updateRightList()
	--获得快速合成的物品数据
	local tData = WndSynthesisRight:_getItemByPlayerItemId(self.m_tPutItem.m_tItem.playerItemId)
	--放置材料
    self:_putItem(nTag, tData, self.m_bQuick)
end

function WndSynthesisLeft:checkQuick()
	WZLog("WndSynthesisLeft:checkQuick")

    local nButtonId = 181   --功能开放表对应id
    local tBtnsInfo = GDatatab_button_info["id_"..nButtonId]
    if CacheCenter:getPlayerInfo().vipLevel < 3 and not whetherHaveWelfareCard() and CacheCenter:getPlayerInfo().level < tBtnsInfo.open_level then
    	-- local sMsg = string.format(LocalStrings.MULTI_SWEEP_TIP, 3)
    	local sMsg = string.format(LocalStrings.WELFARECARD_VIP_TIP, tBtnsInfo.open_level, 3)
        MsgBoxManager:showConfirmCancelBox(sMsg, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
		self.m_bQuick = false
		return false
	end

    if self.m_tPutItem == nil then
        --提示错误信息:请放置材料
        MsgBoxManager:showTipBox(LocalStrings.PUT_SYNTHESIS_MATERIAL)
        return false
    end

	if self.m_bQuick ~= true then
        --提示勾选快速合成
        MsgBoxManager:showTipBox(LocalStrings.BAGTIP46)
		return false
	end

	if self.m_nMergeNum == nil or self.m_nMergeMax == nil then
		WZLog("WndSynthesisLeft:checkQuick  初始化失败")
		return false
	end

	return true
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------

function WndSynthesisLeft:_adaptLanguage_ug(  )
    GetElement(self.m_root,"cost_WndSynthesisLeft",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.64,0.5))
    GetElement(self.m_root,"imgCost_WndSynthesisLeft",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.234324,0.5))
    local txtValue = GetElement(self.m_root,"txtValue_WndSynthesisLeft",WZUILabelTTF)
    txtValue:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtValue:setRelativePosition(GlobalMethod:ccp(0.18,0.5))

    GetElement(self.m_root,"txtQuickCraft_WndSynthesisLeft",WZUILabelTTF):setScale(0.68)

    local txtRapid = GetElement(self.m_root,"txtRapid_WndSynthesis",WZUILabelTTF)
    txtRapid:setScale(0.7)
    txtRapid:setDimensions(GlobalMethod:CCSize(160))
end
--------------------------------------语言适配End-------------------------------------------
