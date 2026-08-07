--WndTransactionOperate.lua
--@brief	WndTransactionOperate的UI模块
--@date		2017/03/15
--@author	zsq
--@note		交易行操作


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTransactionOperate:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTransactionOperate:onExit(element)
	self:_unInit()
end

function WndTransactionOperate:onClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndTransactionOperate:onClickItem(tItem, nTag, tData)
    WZLog("WndTransactionOperate:onClickItem ")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData1 = CopyTable(tData)
	tData1.tBtnList = nil
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData1, false)
end

function WndTransactionOperate:show(tData)
	local wnd = WndTransactionOperate:createElement()
	WindowManager:addWindow(wnd,WndTransactionOperate,nil,nil,nil,true)
	self.m_tData = tData
	self.m_nNum = 1
	if tData.winType ~= 1 then
		self.m_nNum = tData.lastNum
	end
	self.m_nMaxNum = tData.lastNum
	self:update()
end

function WndTransactionOperate:onClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData.winType == 1 then
		WZLog("购买",self.m_tData.commodityIds, self.m_tData.itemIds, self.m_tData.quantitys)
		--判断晶石是否足够
		if JudgeMoneyIsEnough(58, self.m_nCost,nil,nil,194) then
			ProtocolProcessorTransaction:send_TRANSACTION_BuyCommodity(self.m_tData.commodityIds, self.m_tData.itemIds, self.m_nNum )
		end
	elseif self.m_tData.winType == 2 then
		--上架商品
		WZLog("上架商品", self.m_tData.itemIds, self.m_nNum)
		ProtocolProcessorTransaction:send_TRANSACTION_Sales(self.m_tData.itemIds, self.m_nNum )
	elseif self.m_tData.winType == 3 then
		if WndTransaction.m_tDataList3 == nil then WndTransaction.m_tDataList3 = {} end
		if #WndTransaction.m_tDataList3 >= 10 then MsgBoxManager:showTipBox(LocalStrings.TRANSACTION52) return end
		--回收商品显示遮罩
		for i=1,#WndTransaction.m_tDataList do
        	if WndTransaction.m_tDataList[i].itemIds == self.m_tData.itemIds 
				and WndTransaction.m_tDataList[i].itemTag == self.m_tData.itemTag then
				WndTransaction.m_tDataList[i].isCover = true
			end
		end
		WndTransaction:updateBag()
		--回收商品刷新界面
		local tData = CopyTable(self.m_tData)
		tData.quantitys = self.m_nNum
		table.insert(WndTransaction.m_tDataList3, tData)
		WndTransaction:updateRight3()
		local tableCon =  GetElement(WndTransaction.m_root,"tbCon3_WndTransaction",WZUITableContainer)
		tableCon:getMoveElement():setPositionY(tableCon:getMaxPosition().y)
	elseif self.m_tData.winType == 4 then
		WZLog("鉴定物品", self.m_tData.itemIds, self.m_nNum)
		WndGemAppraise:clickPutIn(self.m_tData.itemIds, self.m_nNum)
	elseif self.m_tData.winType == 5 then
		WndExtraction:clickPutIn(self.m_tData.keyId, self.m_tData.itemIds, self.m_nNum, self.m_tData.otherKey)
	end

	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndTransactionOperate:update()
	titles = {LocalStrings.TRANSACTION14,LocalStrings.TRANSACTION19,LocalStrings.BAGTIP47,LocalStrings.DIGGEM_TEXT36}
	btnWords = {LocalStrings.BUY,LocalStrings.TRANSACTION20,LocalStrings.BAGTIP48,LocalStrings.BAGTIP48,LocalStrings.BAGTIP48}
	GetElement(self.m_root,"title_WndTransactionOperate",WZUILabelTTF):setText(titles[self.m_tData.winType])
	GetElement(self.m_root,"txtBtn_WndTransactionOperate",WZUILabelTTF):setText(btnWords[self.m_tData.winType])

	for i=1,5 do
		GetElement(self.m_root,"conType"..i,WZUIContainer):setVisible(false)
	end
	GetElement(self.m_root,"conType"..self.m_tData.winType,WZUIContainer):setVisible(true)

	if self.m_tData.winType == 5 then
		local img1Type5 = GetElement(self.m_root, "img1Type5_WndTransationOperate", WZUIImage)
		local basicInfo = GDatatab_item["id_" .. self.m_tData.cost[1][1]]
		if img1Type5 then
			img1Type5:setFile(basicInfo.icon)
			img1Type5:setScale(0.45)
		end

		local img2Type5 = GetElement(self.m_root, "img2Type5_WndTransationOperate", WZUIImage)
		if img2Type5 then
			img2Type5:setFile(basicInfo.icon)
			img2Type5:setScale(0.45)
		end
	end

    local conImage = GetElement(self.m_root,"con_WndTransactionOperate",WZUIContainer)
    local cell,tcell = CellGoodItem:createElement()
    if cell then
        cell = WZUIContainer:luaTo(cell)
       	tcell:setCellGoodItem(self.m_tData, 4)
        tcell:setItemClickFun(self, self.onClickItem)
        conImage:addChild(cell)
    end

	self:refresh()
end

function WndTransactionOperate:refresh()
	local id = self.m_tData.itemIds
	local t = GDatatab_treasure["id_"..id]
	local list = {"sell_price","sell_price","recovery_price","appraisal_price","cost"}
	local price 
	if self.m_tData.winType == 5 then
		price = self.m_tData.cost[1][2]
	else
		price = t[list[self.m_tData.winType]][1][2]
	end
	GetElement(self.m_root,"txt1Type"..self.m_tData.winType,WZUILabelTTF):setText(price)
	GetElement(self.m_root,"txt2Type"..self.m_tData.winType,WZUILabelTTF):setText(price*self.m_nNum)
	self.m_nCost = price*self.m_nNum

	GetElement(self.m_root,"useNum_WndTransactionOperate",WZUILabelTTF):setText(self.m_nNum)
end

--@brief	减少10个
function WndTransactionOperate:onMutiReduce(element)
	WZLog("WndTransactionOperate:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum > 1 then
		if self.m_nNum <= 10 then
			self.m_nNum = 1
		else
			self.m_nNum = self.m_nNum - 10
		end
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	self:refresh()
end

--@brief	减少1个
function WndTransactionOperate:onReduce(element)
	WZLog("WndTransactionOperate:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	self:refresh()
end

--@brief	增加10个
function WndTransactionOperate:onMutiAdd(element)
	WZLog("WndTransactionOperate:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum < self.m_nMaxNum then
		if self.m_nNum + 10 <= self.m_nMaxNum then
			 self.m_nNum = self.m_nNum + 10
		else
			 self.m_nNum = self.m_nMaxNum
		end
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	self:refresh()
end

--@brief	增加1个
function WndTransactionOperate:onAdd(element)
	WZLog("WndTransactionOperate:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum + 1 <= self.m_nMaxNum then
		self.m_nNum = self.m_nNum + 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	self:refresh()
end

-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function WndTransactionOperate:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtType1T1_WndTransactionOperate",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.26,0.328))
	GetElement(self.m_root,"txtType1T2_WndTransactionOperate",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.26,0.245))
	GetElement(self.m_root,"txtType2T1_WndTransactionOperate",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.26,0.328))
	GetElement(self.m_root,"txtType2T2_WndTransactionOperate",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.26,0.245))
	GetElement(self.m_root,"txtType3T1_WndTransactionOperate",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.26,0.328))
	GetElement(self.m_root,"txtType3T2_WndTransactionOperate",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.26,0.245))
	GetElement(self.m_root,"txtType4T1_WndTransactionOperate",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.26,0.328))
	GetElement(self.m_root,"txtType4T2_WndTransactionOperate",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.26,0.245))
	
end

function WndTransactionOperate:_adaptLanguage_en(  )
	local txtType2T3 = GetElement(self.m_root,"txtType2T3_WndTransactionOperate",WZUILabelTTF)
	txtType2T3:setScale(0.55)
	txtType2T3:setRelativePosition(GlobalMethod:ccp(0.5,0.202))
end

function WndTransactionOperate:_adaptLanguage_pt(  )
	local txtType1T1 = GetElement(self.m_root,"txtType1T1_WndTransactionOperate",WZUILabelTTF)
	txtType1T1:setScale(0.8)
	txtType1T1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType1T1:setRelativePosition(GlobalMethod:ccp(0.44,0.328))
	local txtType1T2 = GetElement(self.m_root,"txtType1T2_WndTransactionOperate",WZUILabelTTF)
	txtType1T2:setScale(0.8)
	txtType1T2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType1T2:setRelativePosition(GlobalMethod:ccp(0.44,0.245))
	local txtType2T1 = GetElement(self.m_root,"txtType2T1_WndTransactionOperate",WZUILabelTTF)
	txtType2T1:setScale(0.8)
	txtType2T1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType2T1:setRelativePosition(GlobalMethod:ccp(0.44,0.328))
	local txtType2T2 = GetElement(self.m_root,"txtType2T2_WndTransactionOperate",WZUILabelTTF)
	txtType2T2:setScale(0.8)
	txtType2T2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType2T2:setRelativePosition(GlobalMethod:ccp(0.44,0.245))
	local txtType3T1 = GetElement(self.m_root,"txtType3T1_WndTransactionOperate",WZUILabelTTF)
	txtType3T1:setScale(0.8)
	txtType3T1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType3T1:setRelativePosition(GlobalMethod:ccp(0.44,0.328))
	local txtType3T2 = GetElement(self.m_root,"txtType3T2_WndTransactionOperate",WZUILabelTTF)
	txtType3T2:setScale(0.8)
	txtType3T2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType3T2:setRelativePosition(GlobalMethod:ccp(0.44,0.245))
	local txtType4T1 = GetElement(self.m_root,"txtType4T1_WndTransactionOperate",WZUILabelTTF)
	txtType4T1:setScale(0.8)
	txtType4T1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType4T1:setRelativePosition(GlobalMethod:ccp(0.44,0.328))
	local txtType4T2 = GetElement(self.m_root,"txtType4T2_WndTransactionOperate",WZUILabelTTF)
	txtType4T2:setScale(0.8)
	txtType4T2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType4T2:setRelativePosition(GlobalMethod:ccp(0.44,0.245))

	GetElement(self.m_root,"txtType2T3_WndTransactionOperate",WZUILabelTTF):setScale(0.8)
end

function WndTransactionOperate:_adaptLanguage_es(  )
	local txtType1T1 = GetElement(self.m_root,"txtType1T1_WndTransactionOperate",WZUILabelTTF)
	txtType1T1:setScale(0.8)
	txtType1T1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType1T1:setRelativePosition(GlobalMethod:ccp(0.44,0.328))
	local txtType1T2 = GetElement(self.m_root,"txtType1T2_WndTransactionOperate",WZUILabelTTF)
	txtType1T2:setScale(0.8)
	txtType1T2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType1T2:setRelativePosition(GlobalMethod:ccp(0.44,0.245))
	local txtType2T1 = GetElement(self.m_root,"txtType2T1_WndTransactionOperate",WZUILabelTTF)
	txtType2T1:setScale(0.8)
	txtType2T1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType2T1:setRelativePosition(GlobalMethod:ccp(0.44,0.328))
	local txtType2T2 = GetElement(self.m_root,"txtType2T2_WndTransactionOperate",WZUILabelTTF)
	txtType2T2:setScale(0.8)
	txtType2T2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType2T2:setRelativePosition(GlobalMethod:ccp(0.44,0.245))
	local txtType3T1 = GetElement(self.m_root,"txtType3T1_WndTransactionOperate",WZUILabelTTF)
	txtType3T1:setScale(0.8)
	txtType3T1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType3T1:setRelativePosition(GlobalMethod:ccp(0.44,0.328))
	local txtType3T2 = GetElement(self.m_root,"txtType3T2_WndTransactionOperate",WZUILabelTTF)
	txtType3T2:setScale(0.8)
	txtType3T2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType3T2:setRelativePosition(GlobalMethod:ccp(0.44,0.245))
	local txtType4T1 = GetElement(self.m_root,"txtType4T1_WndTransactionOperate",WZUILabelTTF)
	txtType4T1:setScale(0.8)
	txtType4T1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType4T1:setRelativePosition(GlobalMethod:ccp(0.44,0.328))
	local txtType4T2 = GetElement(self.m_root,"txtType4T2_WndTransactionOperate",WZUILabelTTF)
	txtType4T2:setScale(0.8)
	txtType4T2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType4T2:setRelativePosition(GlobalMethod:ccp(0.44,0.245))

	GetElement(self.m_root,"txtType2T3_WndTransactionOperate",WZUILabelTTF):setScale(0.8)
end

function WndTransactionOperate:_adaptLanguage_tr(  )
	local txtType3T1 = GetElement(self.m_root,"txtType3T1_WndTransactionOperate",WZUILabelTTF)
	txtType3T1:setScale(0.8)
	txtType3T1:setRelativePosition(GlobalMethod:ccp(0.28,0.328))

	local txtType3T2 = GetElement(self.m_root,"txtType3T2_WndTransactionOperate",WZUILabelTTF)
	txtType3T2:setScale(0.8)
	txtType3T2:setRelativePosition(GlobalMethod:ccp(0.28,0.245))

	local txtBtn = GetElement(self.m_root,"txtBtn_WndTransactionOperate",WZUILabelTTF)
	txtBtn:setScale(0.8)
	txtBtn:setDimensions(GlobalMethod:CCSize(100,0))

	GetElement(self.m_root,"conType3_1_WndTransactionOperate",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.7,0.328))
	GetElement(self.m_root,"conType3_2_WndTransactionOperate",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.7,0.245))
end

function WndTransactionOperate:_adaptLanguage_ug(  )
	local txtType1T1 = GetElement(self.m_root,"txtType1T1_WndTransactionOperate",WZUILabelTTF)
	txtType1T1:setScale(0.6)
	txtType1T1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType1T1:setRelativePosition(GlobalMethod:ccp(0.465,0.328))
	local txtType1T2 = GetElement(self.m_root,"txtType1T2_WndTransactionOperate",WZUILabelTTF)
	txtType1T2:setScale(0.6)
	txtType1T2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType1T2:setRelativePosition(GlobalMethod:ccp(0.465,0.245))
	local txtType2T1 = GetElement(self.m_root,"txtType2T1_WndTransactionOperate",WZUILabelTTF)
	txtType2T1:setScale(0.6)
	txtType2T1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType2T1:setRelativePosition(GlobalMethod:ccp(0.465,0.328))
	local txtType2T2 = GetElement(self.m_root,"txtType2T2_WndTransactionOperate",WZUILabelTTF)
	txtType2T2:setScale(0.6)
	txtType2T2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType2T2:setRelativePosition(GlobalMethod:ccp(0.465,0.245))
	local txtType3T1 = GetElement(self.m_root,"txtType3T1_WndTransactionOperate",WZUILabelTTF)
	txtType3T1:setScale(0.6)
	txtType3T1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType3T1:setRelativePosition(GlobalMethod:ccp(0.465,0.328))
	local txtType3T2 = GetElement(self.m_root,"txtType3T2_WndTransactionOperate",WZUILabelTTF)
	txtType3T2:setScale(0.6)
	txtType3T2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType3T2:setRelativePosition(GlobalMethod:ccp(0.465,0.245))
	local txtType4T1 = GetElement(self.m_root,"txtType4T1_WndTransactionOperate",WZUILabelTTF)
	txtType4T1:setScale(0.6)
	txtType4T1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType4T1:setRelativePosition(GlobalMethod:ccp(0.465,0.328))
	local txtType4T2 = GetElement(self.m_root,"txtType4T2_WndTransactionOperate",WZUILabelTTF)
	txtType4T2:setScale(0.6)
	txtType4T2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtType4T2:setRelativePosition(GlobalMethod:ccp(0.465,0.245))
end
---------------------------------------语言适配End------------------------------------------