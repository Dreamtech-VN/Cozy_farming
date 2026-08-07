--WndSellList.lua
--@brief	WndSellList的UI模块
--@date		2015/07/03
--@author	zsq
--@note		出售物品列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSellList:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)

	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_initStaticText()
	self:showMakeWasteProfitable()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSellList:onExit(element)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	doStopAllActions(self.m_sResertContainer)
	self:_unInit()
end

function WndSellList:onEnterTransitionDidFinish(element)
	self:setSpineAni()
	self.m_sResertContainer = GetElement(self.m_root,"con",WZUIContainer)
end

--@brief	进入装备商店
function WndSellList:onStore(element)
	WZLog("WndSellList:onStore")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndStore:showStoreByType(8)
end

--@brief	出售按钮
function WndSellList:onSale(element)
	WZLog("WndSellList:onSale")
	if self:getOpenState() then
		return
	end

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tLeft == nil or #self.m_tLeft == 0 then
		MsgBoxManager:showTipBox(LocalStrings.PUT_SELL_MATERIAL)
		return 
	end
	--有时限装备时，要至少保留一件同类型装备
	for i=1,#self.m_tLeft do
		local itemId = self.m_tLeft[i].basicInfo.id
		if self.m_tLeft[i].basicInfo.main_type == 4 and WndSellList:getOwnLimitNum(itemId) >= 1 and
		(WndSellList:getInSaleNum(itemId) + WndSellList:getOwnLimitNum(itemId)) >= WndSellList:getOwnNum(itemId) then
			MsgBoxManager:showTipBox(LocalStrings.LIMITEQUIP2)
			return 
		end
	end

	local warn = false
    
    self.m_vItemID = WZLuaVector_int_:create()
    self.m_vItemNum = WZLuaVector_int_:create()
    self.m_vItemID:retain()
    self.m_vItemNum:retain()

    self.m_vItemID_Huanhua = WZLuaVector_int_:create()
    self.m_vItemNum_Huanhua = WZLuaVector_int_:create()
    self.m_vItemID_Huanhua:retain()
    self.m_vItemNum_Huanhua:retain()

	self.m_tRewards["items"] = {}
	self.m_tRewards["nums"] = {}
	--初始化回收协议接收计数
	self.m_nRecvRecycleProtoNums = 0
    
    local bSale = false
    for i,data in pairs(self.m_tLeft) do 
        if data == nil then
            break
        else
            bSale = true
            if data.isHuanhua and data.isHuanhua == true then
				WZLog("WndSellList:onSale: Huanhua", data.basicInfo.name)
	            self.m_vItemID_Huanhua:push(data.playerItemId)
	            self.m_vItemNum_Huanhua:push(data.lastNum)
			else
				WZLog("WndSellList:onSale: not Huanhua", data.basicInfo.name)
	            self.m_vItemID:push(data.playerItemId)
	            self.m_vItemNum:push(data.lastNum)

            end
			WZLog("WndSellList:onSale:",data.playerItemId,data.lastNum)
			if data.basicInfo.quality >= 3 then warn = true end
			if data.extraInfo ~= nil and data.extraInfo.strongLevel ~= nil and data.extraInfo.strongLevel >= 20 then warn = true end
        end

    end

	if #VectorToTable(self.m_vItemID) > 0 and #VectorToTable(self.m_vItemID_Huanhua) > 0 then
		WZLog("WndSellList:onSale: m_bIsIncludeHuanhua", #VectorToTable(self.m_vItemID), #VectorToTable(self.m_vItemID_Huanhua))
		self.m_bIsIncludeHuanhua = true
	end
	WZLog("WndSellList:onSale: m_bIsIncludeHuanhua", self.m_bIsIncludeHuanhua)
	
	if warn then
		local msg1 = LocalStrings.SELL_CONFIRM	
		MsgBoxManager:showConfirmBoxWithBg(msg1, self, self.sellConfirm, MSGBOXLEVEL_HIGH, {[MSGBOXUICFG_USEFREETXT] = true})
		return
	end
    
    if bSale == false then
        return
    end

	if self:isActivityOpenTime() then
		if self.m_nExchangeType == 1 then
			local nCostNum = self.m_tActivityData.rewardCounts[2] * self:getResetCount()
			if not JudgeMoneyIsEnough(self.m_tActivityData.rewardCounts[1], nCostNum, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiaInstead, nil, nil) then 
				return 
			end
		end
		self:sureUseDiaInstead()
	else
		self:startLoading()
		--普通物品和幻化装备需要分开单独回收
		ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem(self.m_vItemID, self.m_vItemNum, self.m_nExchangeType)
		ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem(self.m_vItemID_Huanhua, self.m_vItemNum_Huanhua, self.m_nExchangeType, 1)

		self:reduceRef()

		self.m_tGetResetIdsList = nil
		self.m_tGetResetNumsList = nil
		self.m_tLeft = {}
		WndSell.m_tSellList = {}
	end
end

function WndSellList:sureUseDiaInstead()
	self:setOpenState(true)
	local conFurnace = GetElement(self.m_root, "conFurnace_WndSellList", WZUIContainer)
	conFurnace:enableSchedule("closeExchangeAnim", 1)	
	WndSell:showExchangeAnim()
end

function WndSellList:sellConfirm()
	if self:isActivityOpenTime() then
		if self.m_nExchangeType == 1 then
			local nCostNum = self.m_tActivityData.rewardCounts[2] * self:getResetCount()
			if not JudgeMoneyIsEnough(self.m_tActivityData.rewardCounts[1], nCostNum, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiaInstead, nil, nil) then 
				return 
			end
		end
		self:sureUseDiaInstead()
	else
	    self:startLoading()
		--普通物品和幻化装备需要分开单独回收
		ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem(self.m_vItemID, self.m_vItemNum, self.m_nExchangeType)
		ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem(self.m_vItemID_Huanhua, self.m_vItemNum_Huanhua, self.m_nExchangeType, 1)
    
        WZLog(Serialize(VectorToTable(self.m_vItemID)),Serialize(VectorToTable(self.m_vItemNum)))
        WZLog(Serialize(VectorToTable(self.m_vItemID_Huanhua)),Serialize(VectorToTable(self.m_vItemNum_Huanhua)))
        self:reduceRef()

	    self.m_tLeft = {}
	    WndSell.m_tSellList = {}
	end
end

--@brief　变量m_vItemID和m_vItemNum相应的引用计数-1
function WndSellList:reduceRef()
	if self.m_vItemID == nil or self.m_vItemNum == nil then return end
    self.m_vItemID:release()
    self.m_vItemNum:release()
    self.m_vItemID = nil
    self.m_vItemNum = nil
    if self.m_vItemID_Huanhua == nil or self.m_vItemNum_Huanhua == nil then return end
    self.m_vItemID_Huanhua:release()
    self.m_vItemNum_Huanhua:release()
    self.m_vItemID_Huanhua = nil
    self.m_vItemNum_Huanhua = nil
end

--@brief	返回按钮
function WndSellList:onReturn(element)
	WZLog("WndSellList:onReturn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:clearAll()
	
	doStopAllActions(self.m_sResertContainer)
	WndBagRole.m_tWndSellList.m_root:setVisible(false)
	WndBagRole.m_tWndSell.m_root:setVisible(false)
	GetElement(WndBagRole.m_root,"conLeft_WndBag",WZUIContainer):setVisible(true)
	GetElement(WndBagRole.m_root,"conRight_WndBag",WZUIContainer):setVisible(true)
end

--@brief    开始加载
--@note     开始协议信息的加载，显示加载框
function WndSellList:startLoading()
    -- body
    self.m_nLoadingID = MsgBoxManager:showLoadingBox(10)
end

--@brief    加载完成
--@note     加载完成，关闭加载框
function WndSellList:finishedLoading()
    -- body
    local nId = self.m_nLoadingID
    MsgBoxManager:stopLoadingBoxByMsgId(nId)
end

--@brief	因为添加了皮肤装备回收，由原先只发送一条回收协议变成发送两条回收协议，每秒检测self.m_tRewards显示奖励内容
function WndSellList:recycleSucc2ShowReward()	
	local tableConLeft = GetElement(self.m_root,"tableConLeft_WndSellList",WZUITableContainer)
	if tableConLeft then
		tableConLeft:disableSchedule()
		if self.m_bIsIncludeHuanhua == true and self.m_nRecvRecycleProtoNums > 1 then
			self:schedule2ShowReward()
			return
		end
   		--tableConLeft:enableSchedule("schedule2ShowReward", 1)
	end
end

--@brief	因为添加了皮肤装备回收，由原先只发送一条回收协议变成发送两条回收协议，每秒检测self.m_tRewards显示奖励内容
function WndSellList:schedule2ShowReward()
	WZLog("WndSellList:schedule2ShowReward")
	local tableConLeft = GetElement(self.m_root,"tableConLeft_WndSellList",WZUITableContainer)
	if tableConLeft then
		tableConLeft:disableSchedule()
	end
	self.m_bIsIncludeHuanhua = false
	self.m_nRecvRecycleProtoNums = 0
	if self.m_tRewards["items"] and #(self.m_tRewards["items"]) > 0 then
		WZLog("WndSellList:schedule2ShowReward 1", Serialize(self.m_tRewards))
		if #(self.m_tRewards["items"]) > 0 then
			WndRewardShow:showById(CopyTable(self.m_tRewards["items"]),CopyTable(self.m_tRewards["nums"]))
			self.m_tRewards["items"] = {}
			self.m_tRewards["nums"] = {}
		end 
	end
end

--@brief	出售成功,清空列表
function WndSellList:recycleSucc()
    self:finishedLoading()
    --播放效果音效
    SoundManager:playEffectSound(SoundDefine.E_S_SELL)
	if self.m_root == nil then return end

	self.m_tLeft = {}
    WndSell.m_tSellList = {}
	GetElement(self.m_root,"tableConLeft_WndSellList",WZUITableContainer):cleanTable()

	self.m_tGetResetIdsList = nil
    self.m_tGetResetNumsList = nil

	self:updateActProgress()
end

--@brief	清空出售列表
function WndSellList:clearAll()
	if self.m_root == nil then return end
	self.m_tLeft = {}
    WndSell.m_tSellList = {}
	GetElement(self.m_root,"tableConLeft_WndSellList",WZUITableContainer):cleanTable()

	self.m_tGetResetIdsList = nil
    self.m_tGetResetNumsList = nil
	WndSell:cleanBag()
	WndSell.m_tData = WndSell:getCurData()
	WndSell:_update(false)

	self:updateActProgress()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief　刷新出售列表
-- bool:目前主要用于背包回收的时候出现卡顿的情况的优化
function WndSellList:_update()
	local getList = {{},{}}
	self.m_tLeft = WndSell.m_tSellList
	--刷新回收列表
	-- self:setShowResetData(getList, self.m_tLeft)

	self:updateActProgress()
end

--快速选择的物品进入回收框
function WndSellList:setQuickChooseReset(data)

end
--显示回收列表的数据
function WndSellList:setShowResetData(data)
	--WZLog("WndSellList:setShowResetData", data.basicInfo.name, Serialize(data.basicInfo.recycleMess))
	if self.m_tGetResetIdsList == nil then
		self.m_tGetResetIdsList = {}
	end
	if self.m_tGetResetNumsList == nil then
		self.m_tGetResetNumsList = {}
	end
	if type(data.basicInfo.recycleMess) == "table" and data.basicInfo.recycleMess[1] ~= nil then
		for k=1,#data.basicInfo.recycleMess do
			local added = false
			--之前列表中已有,增加数量
			for j=1,#self.m_tGetResetIdsList do
				if self.m_tGetResetIdsList[j] == data.basicInfo.recycleMess[k][1] then
					self.m_tGetResetNumsList[j] = self.m_tGetResetNumsList[j] + data.basicInfo.recycleMess[k][2] * data.lastNum
					added = true
				end
			end
			--之前列表中没有,加入列表
			if added == false then
				table.insert(self.m_tGetResetIdsList,data.basicInfo.recycleMess[k][1])
				table.insert(self.m_tGetResetNumsList,data.basicInfo.recycleMess[k][2] * data.lastNum)
			end
		end
	end
	--列出回收物品中的宝石
	local gemList = {"attackStone","defendStone","hpStone","gongmingStone"}
	for k=1,4 do
		if data.extraInfo and data.extraInfo[gemList[k]] ~= nil and data.extraInfo[gemList[k]] ~= 0 then
			local added = false
			--之前列表中已有,增加数量
			for j=1,#self.m_tGetResetIdsList do
				if self.m_tGetResetIdsList[j] == data.extraInfo[gemList[k]] then
					self.m_tGetResetNumsList[j] = self.m_tGetResetNumsList[j] + 1
					added = true
				end
			end
			--之前列表中没有,加入列表
			if added == false then
				table.insert(self.m_tGetResetIdsList,data.extraInfo[gemList[k]])
				table.insert(self.m_tGetResetNumsList,1)
			end
		end
	end
end

function WndSellList:setShowResetItem()
	WZLog("WndSellList:setShowResetItem")

	--清空获得列表
	local tableConLeft = WZUITableContainer:luaTo(self.m_root:getChildElement("tableConLeft_WndSellList"))
	tableConLeft:cleanTable()
	tableConLeft:setEnableGlScissor(false)

	local list1 = self.m_tGetResetIdsList
	local list2 = self.m_tGetResetNumsList
	if not list1 or next(list1) == nil then return end

	doStopAllActions(self.m_sResertContainer)
	--刷新获得列表
	for i=1, #list1 do
 		delayRun(self.m_sResertContainer, i / DEFAULT_FPS,function ()
 			local key = "id_"..list1[i]
	        if GDatatab_item[key] ~= nil then
	            local name = GDatatab_item[key].name
	            local path = GDatatab_item[key].icon
	            local num = list2[i]
	            local quality = GDatatab_item[key].quality
	            local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
				local cellElement,tCell = CellGoodItem:createElement()
				tCell:setCellGoodItem(itemInfo,10)
	    		tCell:setItemClickFun(self,self.onClickCallback2)
				cellElement:setTag(i-1)
				tableConLeft:setCellElement(cellElement)
	        end
 		end)
 	end

	self:updateActProgress()
end

--@brief	待回收物品点击回调,取消出售
function WndSellList:onClickCallback1(tCell,tag,tData)
	WZLog("WndSellList:onClickCallback1")
	for i=1,#self.m_tLeft do
		if tData.playerItemId == self.m_tLeft[i].playerItemId then
			--出售列表删除该物品
			table.remove(self.m_tLeft,i)
			break
		end
	end
	--把右边列表里对应物品的状态改为未出售
	for i=1,#WndSell.m_tData do
		if WndSell.m_tData[i].playerItemId == tData.playerItemId then
			WndSell.m_tData[i].sellHook = false
			break
		end
	end
	WndSell.m_tData = WndSell:getCurData()
	WndSell:_update(true)
	-- WndSellList:_update()

	self:updateActProgress()
end

--@brief	点击回收获得物品，显示tips
function WndSellList:onClickCallback2(tCell,tag,tData)
	WZLog("WndSellList:onClickCallback2")
   	WndItemInfo:showInfo(tCell.m_root,WndSell.m_root,1,tData, false)
end

--@brief	显示变废为宝活动
function WndSellList:showMakeWasteProfitable()
    if g_cityExtenInfo and g_cityExtenInfo.activity7066 and g_cityExtenInfo.activity7066 > 0 then --开启
		ProtocolProcessorWndActivityOnLine:regAll()
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7066, 7066)
    end
end

--@brief	显示变废为宝活动
function WndSellList:updateMakeWasteProfitable()
	local conProgress = GetElement(self.m_root,"conProgress_WndSellList",WZUIContainer)
	local conFurnace = GetElement(self.m_root,"conFurnace_WndSellList",WZUIContainer)
	local conExchangeMode = GetElement(self.m_root,"conExchangeMode_WndSellList",WZUIContainer)
	local conActivityRule = GetElement(self.m_root,"conActivityRule_WndSellList",WZUIContainer)
	local conClipping = GetElement(self.m_root,"conClipping",WZUIClippingContainer)


	local checkExchangeType = GetElement(self.m_root,"checkExchangeType_WndSellList",WZUICheckBox)

	if self:isActivityOpenTime() then --开启
        conProgress:setVisible(true)
		conFurnace:setVisible(true)
		conExchangeMode:setVisible(true)
		conActivityRule:setVisible(true)
		conClipping:setVisible(false)

		checkExchangeType:setCheckIndex(0)
	else
        conProgress:setVisible(false)
		conFurnace:setVisible(false)
		conExchangeMode:setVisible(false)
		conActivityRule:setVisible(false)
		conClipping:setVisible(true)
	end


	local txtExchangeTips3 = GetElement(self.m_root,"txtExchangeTips3_WndSellList",WZUILabelTTF)
	txtExchangeTips3:setText(string.format(LocalStrings.ACT_MAKE_WASTE_PROFITABLE[11],self.m_tActivityData.rewardCounts[2]))
end

--@brief	显示变废为宝活动
function WndSellList:updateActProgress()
	if self.m_tActivityData and #self.m_tActivityData then
		local progValue = GetElement(self.m_root,"progValue_WndSellList",WZUIProgress)
		progValue:setPercentage(self.m_tActivityData.count/self.m_tActivityData.maxCount*100)

		local nSellListNum = self:getResetCount()
		local progNextValue = GetElement(self.m_root,"progNextValue_WndSellList",WZUIProgress)
		local nMultiple = 1
		if self.m_nExchangeType == 0 then
			nMultiple = 1
		elseif self.m_nExchangeType == 1 then
			nMultiple = 2
		end
		local nAddValue = nSellListNum*nMultiple
		progNextValue:setPercentage((self.m_tActivityData.count+nAddValue)/self.m_tActivityData.maxCount*100)

		local tmpStrProg = self.m_tActivityData.count.."/"..self.m_tActivityData.maxCount
		if nAddValue > 0 then
			tmpStrProg = self.m_tActivityData.count.."(+"..nAddValue..")/"..self.m_tActivityData.maxCount
		end
		local txtProgressValue = GetElement(self.m_root,"txtProgressValue_WndSellList",WZUILabelTTF)
		txtProgressValue:setText(tmpStrProg)
	end
end

--@brief	显示变废为宝活动
function WndSellList:_initStaticText()
	local txtProgressWord = GetElement(self.m_root,"txtProgressWord_WndSellList",WZUILabelTTF)
	local txtRewardPreview = GetElement(self.m_root,"txtRewardPreview_WndSellList",WZUILabelTTF)
	local txtExchangeWord = GetElement(self.m_root,"txtExchangeWord_WndSellList",WZUILabelTTF)
	local txtExchangeTips2 = GetElement(self.m_root,"txtExchangeTips2_WndSellList",WZUILabelTTF)
	txtProgressWord:setText(LocalStrings.ACT_MAKE_WASTE_PROFITABLE[5])
	txtRewardPreview:setText(LocalStrings.ACT_MAKE_WASTE_PROFITABLE[6])
	txtExchangeWord:setText(LocalStrings.ACT_MAKE_WASTE_PROFITABLE[7])
	txtExchangeTips2:setText(LocalStrings.ACT_MAKE_WASTE_PROFITABLE[8])
end

--@brief	勾选粉钻兑换
function WndSellList:onClickCheckExchenge(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local checkExchangeType = GetElement(self.m_root,"checkExchangeType_WndSellList",WZUICheckBox)
	local conExchangeTips = GetElement(self.m_root,"conExchangeTips_WndSellList",WZUIContainer)
	local checkIndex = checkExchangeType:getCheckIndex()
	if checkIndex == 0 then
		self.m_nExchangeType = 0
		conExchangeTips:setVisible(false)
	else
		self.m_nExchangeType = 1
		conExchangeTips:setVisible(true)
	end
	self:updateActProgress()
end

--@brief	点击活动规则按钮
function WndSellList:onClickActivityRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.ACT_MAKE_WASTE_PROFITABLE2)
end

--@brief	点击大奖预览按钮回调
function WndSellList:onClickBigReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndJoinReward:showInterface("", self.m_tBigRewardList[1], self.m_tBigRewardList[2], LocalStrings.ACT_MAKE_WASTE_PROFITABLE[6], nil, 2)
end


--@brief 	显示开启动画
function WndSellList:showOpenAction()
	if WndRewardShow.m_root then
		WndRewardShow:closeCallBack(self, self._afterCloseReward)
	else
		self:_afterCloseReward()
	end
end

--@brief 	关闭抽奖奖励展示界面回调
function WndSellList:_afterCloseReward()
	if self.m_root == nil then return end

	if self.m_tOpenResult and self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards)
	end
end


--@brief 	变废为宝动画结束
function WndSellList:closeExchangeAnim()
	local conFurnace = GetElement(self.m_root, "conFurnace_WndSellList", WZUIContainer)
	conFurnace:disableSchedule()

	self:startLoading()
	--普通物品和幻化装备需要分开单独回收
	ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem(self.m_vItemID, self.m_vItemNum, self.m_nExchangeType)
	ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem(self.m_vItemID_Huanhua, self.m_vItemNum_Huanhua, self.m_nExchangeType, 1)

	self:reduceRef()

	self.m_tGetResetIdsList = nil
	self.m_tGetResetNumsList = nil
	self.m_tLeft = {}
	WndSell.m_tSellList = {}

	self:setOpenState(false)
end

--@brief    设置开箱特效
function WndSellList:setSpineAni()
    local spineFurnace = GetElement(self.m_root,"spineFurnace_WndSellList",WZUISpine)
    local spinePath = "ui/otherUI/hd_pic_beibaohuis"
    local bIsExist = WZFileUtil:isFileExist(spinePath .. ".json")
    if bIsExist then 
        bIsExist = WZFileUtil:isFileExist(spinePath .. ".atlas")
    end

    if bIsExist then 
        spineFurnace:setFileJson(spinePath .. ".json")
        spineFurnace:setFileAtlas(spinePath .. ".atlas")
        spineFurnace:play("wait", true)
    end
end
-------------------------------------私有方法模块End----------------------------------------

----------------------------------------语言适配Begin---------------------------------------
function WndSellList:_adaptLanguage_tr(  )
	local txtSale = GetElement(self.m_root,"txtSale_WndRecover",WZUILabelTTF)
	txtSale:setDimensions(GlobalMethod:CCSize(130,0))
	txtSale:setScale(0.8)
end

function WndSellList:_adaptLanguage_vn(  )
	local txtT = GetElement(self.m_root,"txtT_WndSellList",WZUILabelTTF)
	if txtT then
		txtT:setScale(0.9)
	end
	GetElement(self.m_root,"txtExchangeTips2_WndSellList",WZUILabelTTF):setFontSize(15)
	GetElement(self.m_root,"txtRewardPreview_WndSellList",WZUILabelTTF):setFontSize(14)
end

function WndSellList:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtT_WndSellList",WZUILabelTTF):setScale(0.7)
end

function WndSellList:_adaptLanguage_ug(  )
	GetElement(self.m_root,"txtSale_WndRecover",WZUILabelTTF):setScale(0.7)
end
---------------------------------------语言适配End-----------------------------------------
