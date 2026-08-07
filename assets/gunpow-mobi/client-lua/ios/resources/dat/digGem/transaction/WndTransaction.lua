--WndTransaction.lua
--@brief	WndTransaction的UI模块
--@date		2017/03/15
--@author	zsq
--@note		交易行窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTransaction:onEnter(element)
	self.m_root = element
	ProtocolProcessorTransaction:regAll()
end

function WndTransaction:onEnterTransitionDidFinish(element)
	self.m_nRightTag = 1
	self.m_nLogType = 10

	if WndTransaction.m_nCurType == nil then WndTransaction.m_nCurType = 1 end
	if WndTransaction.m_nCurQuality == nil then WndTransaction.m_nCurQuality = 1 end
    local ids = WZLuaVector_int_:create()

	--取商品列表
	ProtocolProcessorTransaction:send_TRANSACTION_GetCommodityList(self.m_nCurType, self.m_nCurQuality, ids)
	self:setDisplayCon(1)

    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)

	local con = GetElement(self.m_root,"conMid_WndTrainingCamp",WZUIContainer)
	con:enableSchedule("refreshGems", 10)
	local con2 = GetElement(self.m_root,"conRight2_WndTransaction",WZUIContainer)
	con2:enableSchedule("refreshSales", 60)

	--是否显示小红点
	if GlobalGame.g_tRedPointList.transaction == true then
		GetElement(self.m_root,"imgRedPoint",WZUIImage):setVisible(true)
	else
		GetElement(self.m_root,"imgRedPoint",WZUIImage):setVisible(false)
	end
	AdaptLanguage(self)
end

function WndTransaction:onQuick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nRightTag ~= 3 then return end
	if WndTransaction.m_tDataList3 == nil then WndTransaction.m_tDataList3 = {} end
	if #WndTransaction.m_tDataList3 >= 10 then MsgBoxManager:showTipBox(LocalStrings.TRANSACTION52) return end

	--快速回收,遍历背包，把符合条件的放入回收栏
	local sendNum = 0
	for i=1,#WndTransaction.m_tDataList do
		local tList = WndTransaction.m_tDataList[i]
		if #WndTransaction.m_tDataList3 < 10 and tList.isCover ~= true and (tList.itemIds >= 400 and tList.itemIds <= 406) then
			--回收商品显示遮罩
			tList.isCover = true
			local itemIds = tList.itemIds
			local itemTag = tList.itemTag
			--回收商品刷新界面
			local tData = CopyTable(tList)
			tData.quantitys = tList.num
			table.insert(WndTransaction.m_tDataList3, tData)
			sendNum = sendNum + 1
		end
	end
	WndTransaction:updateRight3()
	WndTransaction:updateBag()
	if sendNum == 0 then
		MsgBoxManager:showTipBox(LocalStrings.QUICKSELECT2)
	end
end

function WndTransaction:refreshGems()
	WZLog("WndTransaction:refreshGems")
	--取商品列表
	if self.m_nRightTag == 1 then
    	local ids = WZLuaVector_int_:create()
		if self.m_tDataList1 ~= nil then
			for i=1,#self.m_tDataList1 do
				ids:push(self.m_tDataList1[i].commodityIds)
			end
		end
		WZLog("刷新当前商品",self.m_nCurType, self.m_nCurQuality,Serialize(VectorToTable(ids)))
		ProtocolProcessorTransaction:send_TRANSACTION_GetCommodityList(self.m_nCurType, self.m_nCurQuality, ids)
	end
end

function WndTransaction:refreshSales()
	WZLog("WndTransaction:refreshSales")
	--是否显示小红点
	if GlobalGame.g_tRedPointList.transaction == true then
		GetElement(self.m_root,"imgRedPoint",WZUIImage):setVisible(true)
	else
		GetElement(self.m_root,"imgRedPoint",WZUIImage):setVisible(false)
	end
	if self.m_nRightTag == 2 then
		--获取宝物背包
		ProtocolProcessorDigGem:send_MINING_GetMiningBag( )
		--获取上架商品
		ProtocolProcessorTransaction:send_TRANSACTION_GetSaleList( )
	end
end

function WndTransaction:actionCallback(element, data)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTransaction:onExit(element)
	self:_unInit()
	ProtocolProcessorTransaction:unregAll()
end

function WndTransaction:onClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)

    WndDigGem:sendGetDem(7)
end

function WndTransaction:show()
	local wnd = WndTransaction:createElement()
	WindowManager:addWindow(wnd, WndTransaction, nil, nil, true)
end

function WndTransaction:showTab(tag)
	WZLog("WndTransaction:showTab", tag)
	local wnd = WndTransaction:createElement()
	WindowManager:addWindow(wnd, WndTransaction, nil, nil, true)
	
	local tag = tag or 1
	self:onTab(tag)
end

--刷新商品
function WndTransaction:onRefresh(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--取商品列表
    local ids = WZLuaVector_int_:create()
	ProtocolProcessorTransaction:send_TRANSACTION_GetCommodityList(self.m_nCurType, self.m_nCurQuality, ids)

	element:setTouchEnable(false)
	self.m_nCountDown = 3
	GetElement(self.m_root,"txtRefresh",WZUILabelTTF):setText(self.m_nCountDown.."s")
	self.m_root:enableSchedule("refreshCountDown",1)
end

function WndTransaction:refreshCountDown()
	self.m_nCountDown = self.m_nCountDown - 1
	GetElement(self.m_root,"txtRefresh",WZUILabelTTF):setText(self.m_nCountDown.."s")
	if self.m_nCountDown <= 0 then
		GetElement(self.m_root,"btnRefresh",WZUIButton):setTouchEnable(true)
		self.m_root:disableSchedule()
	end
end

--回收
function WndTransaction:onRecycle()
	WZLog("WndTransaction:onRecycle", Serialize(self.m_tDataList3))
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tDataList3 == nil or #self.m_tDataList3 <= 0 then 
		MsgBoxManager:showTipBox(LocalStrings.PUT_SELL_MATERIAL)
		return
	end
    local item = WZLuaVector_int_:create()
    local num = WZLuaVector_int_:create()
	for i=1,#self.m_tDataList3 do
        item:push(self.m_tDataList3[i].itemIds)
        num:push(self.m_tDataList3[i].quantitys)
	end
	ProtocolProcessorDigGem:send_MINING_RecyclingMining(item, num )
end

--选择日志类型
function WndTransaction:onLog(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = tonumber(element:getTag())
	self.m_nLogType = tag
	WndTransaction:updateRight4()
end

function WndTransaction:onTab(element)
	WZLog("WndTransaction:onTab0")
	local tag
	if type(element) == "number" then
		tag = element
	else
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
		tag = tonumber(element:getTag())
	end
	if self.m_nRightTag == tag then return end
	WZLog("WndTransaction:onTab",tag)

	self.m_nRightTag = tag
	self:setDisplayCon(tag)

	GetElement(self.m_root,"btnQuickSelect",WZUIButton):setVisible(false)
	if tag == 1 then
		--取商品列表
    	local ids = WZLuaVector_int_:create()
		ProtocolProcessorTransaction:send_TRANSACTION_GetCommodityList(self.m_nCurType, self.m_nCurQuality, ids)
	elseif tag == 2 then
		--获取宝物背包
		ProtocolProcessorDigGem:send_MINING_GetMiningBag( )
		--获取上架商品
		ProtocolProcessorTransaction:send_TRANSACTION_GetSaleList( )
	elseif tag == 3 then
		--切换标签清空回收列表
		self.m_tDataList3 = {}
		--获取宝物背包
		ProtocolProcessorDigGem:send_MINING_GetMiningBag( )
		GetElement(self.m_root,"btnQuickSelect",WZUIButton):setVisible(true)
	elseif tag == 4 then
		GetElement(self.m_root,"imgRedPoint",WZUIImage):setVisible(false)
		ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(200 )
		GlobalGame.g_tRedPointList.transaction = false
		WndDigGem:showRedDot(false)
		ProtocolProcessorTransaction:send_TRANSACTION_GetTransactionLogList( )
	end
end

function WndTransaction:setDisplayCon(tag)
	if tag == 4 then
		GetElement(self.m_root,"conLeft_WndTransaction",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conRight_WndTransaction",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"con4_WndTransaction",WZUIContainer):setVisible(true)
	else
		GetElement(self.m_root,"conLeft_WndTransaction",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conRight_WndTransaction",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"con4_WndTransaction",WZUIContainer):setVisible(false)
	end

	for i=1,3 do
		GetElement(self.m_root,"conRight"..i.."_WndTransaction",WZUIContainer):setVisible(false)
	end
	if tag < 4 then
		GetElement(self.m_root,"conRight"..tag.."_WndTransaction",WZUIContainer):setVisible(true)
	end

	for i=1,4 do
		GetElement(self.m_root,"imgTab"..i.."_WndTransaction",WZUI9Image):setVisible(false)
		GetElement(self.m_root,"txtTab"..i.."_WndTransaction",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txtTab"..i.."Sel_WndTransaction",WZUILabelTTF):setVisible(false)
	end

		GetElement(self.m_root,"imgTab"..tag.."_WndTransaction",WZUI9Image):setVisible(true)
		GetElement(self.m_root,"txtTab"..tag.."_WndTransaction",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txtTab"..tag.."Sel_WndTransaction",WZUILabelTTF):setVisible(true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndTransaction:update()
	local rightTag = self.m_nRightTag or 1


	leftTitles = {LocalStrings.TRANSACTION12,LocalStrings.DIGGEM_TEXT1,LocalStrings.DIGGEM_TEXT1,LocalStrings.DIGGEM_TEXT1}
	rightTitles = {LocalStrings.TRANSACTION13,LocalStrings.TRANSACTION13,LocalStrings.BAGTIP3,LocalStrings.TRANSACTION13}

	GetElement(self.m_root,"leftSubTitle",WZUILabelTTF):setText(leftTitles[rightTag])
	GetElement(self.m_root,"rightSubTitle",WZUILabelTTF):setText(rightTitles[rightTag])

	if self["updateLeft"..rightTag] ~= nil then
		self["updateLeft"..rightTag](self)
	end

	if self["updateRight"..rightTag] ~= nil then
		self["updateRight"..rightTag](self)
	end

end

function WndTransaction:updateBag()
    local freeCon = GetElement(self.m_root, "freeConLeft_WndTransaction", WZUIFreeListContainer)
	freeCon:setAbsContentSize(GlobalMethod:CCSize(200,395))
	if self.m_nRightTag == 3 then
		freeCon:setAbsContentSize(GlobalMethod:CCSize(200,320))
	end
	freeCon:updateRelativeSize()
    local nCurPositionY = freeCon:getMoveElement():getPositionY()
    local tLastSize = freeCon:getMoveElement():getContentSize()
    freeCon:removeAll()
	removeShowPanelNullTip(freeCon)
	if self.m_tDataList == nil or #self.m_tDataList == 0 then
		ShowPanelNullTip( freeCon)
	end

	if self.m_nRightTag == 2 then
		for i=1,#self.m_tDataList do
			local tItem = GDatatab_item["id_"..self.m_tDataList[i].itemIds]
			if tItem.can_sale == 1 then
    		local element, tNewObj = CellTransactionBagItem:createElement()
    		if element and tNewObj then
    		    tNewObj:setData(self.m_tDataList[i], nType)
				element = WZUIContainer:luaTo(element)
    		    freeCon:pushBack(element)
    		end
			end
		end
	elseif self.m_nRightTag == 3 then
		self.m_tCellList3 = {}
		for i=1,#self.m_tDataList do
    		local element, tNewObj = CellTransactionBagItem:createElement()
    		if element and tNewObj then
    		    tNewObj:setData(self.m_tDataList[i], nType)
				element = WZUIContainer:luaTo(element)
    		    freeCon:pushBack(element)
				self.m_tCellList3[i] = tNewObj
    		end
		end
	end

	--freeCon:getMoveElement():setPositionY(freeCon:getMinPosition().y)
    --重新设置列表的位置
    local tCurSize = freeCon:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > freeCon:getMaxPosition().y then
        nTempPositionY = freeCon:getMaxPosition().y
    end
    freeCon:getMoveElement():setPositionY(nTempPositionY)
end

function WndTransaction:updateLeft1()
	WZLog("WndTransaction:updateLeft1",self.m_nCurType)
    local freeCon = GetElement(self.m_root, "freeConLeft_WndTransaction", WZUIFreeListContainer)
	freeCon:setAbsContentSize(GlobalMethod:CCSize(200,395))
	freeCon:updateRelativeSize()
    freeCon:removeAll()
	removeShowPanelNullTip(freeCon)

	if WndTransaction.m_nCurType == nil then WndTransaction.m_nCurType = 1 end
	if WndTransaction.m_nCurQuality == nil then WndTransaction.m_nCurQuality = 1 end
	WZLog("WndTransaction:updateLeft10",self.m_nCurType)
	for i=1,4 do
		local tData = {}
		tData.m_nTag = i
		if i==self.m_nCurType then
    	    local element, tNewObj 
			if i==4 then
				element, tNewObj = CellTransactionTab3:createElement()
				--GetElement(element,"imgArrow",WZUIImage):setVisible(false)
			else
				element, tNewObj = CellTransactionTab2:createElement()
			end
    	    if element and tNewObj then
    	        tNewObj:setData(tData, nType)
				element = WZUIContainer:luaTo(element)
    	        freeCon:pushBack(element)
    	    end
		else
    	    local element, tNewObj = CellTransactionTab1:createElement()
    	    if element and tNewObj then
    	        tNewObj:setData(tData, nType)
				element = WZUIContainer:luaTo(element)
    	        freeCon:pushBack(element)
    	    end
			if i==4 then
				--GetElement(element,"imgArrow",WZUIImage):setVisible(false)
			end
		end
	end
end

function WndTransaction:updateLeft2()

end

function WndTransaction:updateLeft3()

end

function WndTransaction:updateRight1()
	WZLog("WndTransaction:updateRight1")
	local tableCon = self.m_root:getChildElement("tbCon1_WndTransaction")
	tableCon = WZUITableContainer:luaTo(tableCon)
	tableCon:cleanTable()

	removeShowPanelNullTip(tableCon)
	if self.m_tDataList1 == nil or #self.m_tDataList1 == 0 then
		WZLog("WndTransaction:updateRight1k")
		ShowPanelNullTip( tableCon)
	end

	for i=1,#self.m_tDataList1 do
        local element, tNewObj = CellTransactionItem:createElement()
        if element and tNewObj then
            tNewObj:setData(self.m_tDataList1[i], nType)
			element = WZUIContainer:luaTo(element)
			element:setTag(i-1)
            tableCon:setCellElement(element)
        end
	end
end

function WndTransaction:updateRight2()
	local tableCon = self.m_root:getChildElement("tbCon2_WndTransaction")
	tableCon = WZUITableContainer:luaTo(tableCon)
    local nCurPositionY = tableCon:getMoveElement():getPositionY()
    local tLastSize = tableCon:getMoveElement():getContentSize()
	tableCon:cleanTable()
	removeShowPanelNullTip(tableCon)
	if self.m_tDataList2 == nil or #self.m_tDataList2 == 0 then
		ShowPanelNullTip( tableCon)
	end

	for i=1,#self.m_tDataList2 do
        local element, tNewObj = CellTransactionOnSaleItem:createElement()
        if element and tNewObj then
            tNewObj:setData(self.m_tDataList2[i], nType)
			element = WZUIContainer:luaTo(element)
			element:setTag(i-1)
            tableCon:setCellElement(element)
        end
	end

	GetElement(self.m_root,"rightSubTitle",WZUILabelTTF):setText(LocalStrings.TRANSACTION16.."("..#self.m_tDataList2.."/10)")

    --重新设置列表的位置
    local tCurSize = tableCon:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > tableCon:getMaxPosition().y then
        nTempPositionY = tableCon:getMaxPosition().y
    end
    tableCon:getMoveElement():setPositionY(nTempPositionY)


	if self.added == true then
		self.added = false
		tableCon:getMoveElement():setPositionY(tableCon:getMaxPosition().y)
	end
end

function WndTransaction:updateRight3()
	local tableCon = self.m_root:getChildElement("tbCon3_WndTransaction")
	tableCon = WZUITableContainer:luaTo(tableCon)
    local nCurPositionY = tableCon:getMoveElement():getPositionY()
    local tLastSize = tableCon:getMoveElement():getContentSize()
	tableCon:cleanTable()

	removeShowPanelNullTip(tableCon)
	if self.m_tDataList3 == nil then self.m_tDataList3 = {} end
	if self.m_tDataList3 == nil or #self.m_tDataList3 == 0 then
		ShowPanelNullTip( tableCon)
	end

	local sum = 0
	local itemNum = 0
	for i=1,#self.m_tDataList3 do
        local element, tNewObj = CellTransactionOnSaleItem:createElement()
        if element and tNewObj then
            tNewObj:setData(self.m_tDataList3[i], nType)
			element = WZUIContainer:luaTo(element)
			element:setTag(i-1)
            tableCon:setCellElement(element)
        end
		local itemId = self.m_tDataList3[i].basicInfo.id
		local t = GDatatab_treasure["id_"..itemId]
		sum = sum + self.m_tDataList3[i].lastNum*t.recovery_price[1][2]
		itemNum = itemNum + self.m_tDataList3[i].lastNum
	end
	GetElement(self.m_root,"txtRecycle",WZUIFreeTextBox):setShowText(string.format(LocalStrings.TRANSACTION26, tostring(itemNum), tostring(sum)))
	GetElement(self.m_root,"rightSubTitle",WZUILabelTTF):setText(LocalStrings.BAGTIP3)

    --重新设置列表的位置
    local tCurSize = tableCon:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > tableCon:getMaxPosition().y then
        nTempPositionY = tableCon:getMaxPosition().y
    end
    tableCon:getMoveElement():setPositionY(nTempPositionY)
end

function WndTransaction:updateRight4()
	WZLog("WndTransaction:updateRight4")
    local freeCon = GetElement(self.m_root, "freeCon4_WndTransaction", WZUIFreeListContainer)
    freeCon:removeAll()
	removeShowPanelNullTip(freeCon)
	if self.m_tDataList4 == nil or #self.m_tDataList4 == 0 then
		ShowPanelNullTip( freeCon)
	end

	if self.m_nLogType == 10 then
		for i=1,#self.m_tDataList4 do
    		local element, tNewObj = CellTransactionLog:createElement()
    		if element and tNewObj then
    		    tNewObj:setData(self.m_tDataList4[i], nType)
				element = WZUIContainer:luaTo(element)
    		    freeCon:pushBack(element)
    		end
		end
	else
		for i=1,#self.m_tDataList4 do
			if self.m_tDataList4[i].logType == self.m_nLogType then
    		local element, tNewObj = CellTransactionLog:createElement()
    		if element and tNewObj then
    		    tNewObj:setData(self.m_tDataList4[i], nType)
				element = WZUIContainer:luaTo(element)
    		    freeCon:pushBack(element)
    		end
			end
		end
	end

	freeCon:getMoveElement():setPositionY(freeCon:getMinPosition().y)
end

function WndTransaction:clickDesc()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.TRANSACTION_DESC)
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function WndTransaction:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtTab3_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab3Sel_WndTransaction",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txtTab4_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab4Sel_WndTransaction",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txtRecycle",WZUIFreeTextBox):setScale(0.85)
end

function WndTransaction:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtCon4_WndTransaction",WZUILabelTTF):setScale(0.8)
end

function WndTransaction:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtTab1_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab1Sel_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab2_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab2Sel_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab3_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab3Sel_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab4_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab4Sel_WndTransaction",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txtC4T2_WndTransaction",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.765455,0.475))
	GetElement(self.m_root,"txtC4T3_WndTransaction",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.810909,0.475))
	
	GetElement(self.m_root,"txtQuickSelect1_WndTransaction",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtQuickSelect2_WndTransaction",WZUILabelTTF):setScale(0.7)
	
end

function WndTransaction:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtTab1_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab1Sel_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab2_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab2Sel_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab3_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab3Sel_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab4_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab4Sel_WndTransaction",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txtC4T2_WndTransaction",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.765455,0.475))
	GetElement(self.m_root,"txtC4T3_WndTransaction",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.810909,0.475))
	
	GetElement(self.m_root,"leftSubTitle",WZUILabelTTF):setScale(0.8)
	
	GetElement(self.m_root,"txtRecycle",WZUIFreeTextBox):setScale(0.85)

	GetElement(self.m_root,"txtQuickSelect1_WndTransaction",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtQuickSelect2_WndTransaction",WZUILabelTTF):setScale(0.7)
	
end

function WndTransaction:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtTab1_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab1Sel_WndTransaction",WZUILabelTTF):setScale(0.8)
	local txtTab3 = GetElement(self.m_root,"txtTab3_WndTransaction",WZUILabelTTF)
	txtTab3:setScale(0.8)
	txtTab3:setDimensions(GlobalMethod:CCSize(110,0))

	local txtTab3Sel = GetElement(self.m_root,"txtTab3Sel_WndTransaction",WZUILabelTTF)
	txtTab3Sel:setScale(0.8)
	txtTab3Sel:setDimensions(GlobalMethod:CCSize(110,0))

	GetElement(self.m_root,"txtTab4_WndTransaction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab4Sel_WndTransaction",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txtC4T2_WndTransaction",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.765455,0.475))
	GetElement(self.m_root,"txtC4T3_WndTransaction",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.9,0.475))
	
	GetElement(self.m_root,"leftSubTitle",WZUILabelTTF):setScale(0.8)
	
	local txtRecycle = GetElement(self.m_root,"txtRecycle",WZUIFreeTextBox)
	txtRecycle:setScale(0.8)
	txtRecycle:setRelativePosition(GlobalMethod:ccp(0.05,0.515603))

	local txtRight3 = GetElement(self.m_root,"txtRight3_WndTransaction",WZUILabelTTF)
	txtRight3:setScale(0.8)
	txtRight3:setDimensions(GlobalMethod:CCSize(110,0))

	GetElement(self.m_root,"txtCon4_WndTransaction",WZUILabelTTF):setScale(0.8)
end
---------------------------------------语言适配End------------------------------------------