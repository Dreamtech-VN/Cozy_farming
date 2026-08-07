--WndMagicAdvance.lua
--@brief	WndMagicAdvance的UI模块
--@date		2019/10/23
--@author	Tianxiang_Xu
--@note		幻石系统-进阶赠礼界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMagicAdvance:onEnter(element)
	self.m_root = element

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMagicAdvance:onExit(element)
	self:_unInit()
end

--@brief	界面加载完成回调
function WndMagicAdvance:onEnterTransitionDidFinish(element)
	--body
	self:_update()
end

--@brief	开始点击窗口后的回调
--@param	element:窗口绑定的lua表
--@param    pt:坐标点
function WndMagicAdvance:onTouchBegan(element, pt)
    WndItemInfo:onCloseClick()
end

function WndMagicAdvance:onClose(element)
	-- body
	WZLog("WndMagicAdvance:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndMagicAdvance:onClickListItem(tItem, nTag, tData)
    WZLog("WndMagicAdvance:onClickListItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root, self.m_root, 1, tData, false)
end

--@brief 	点击购买按钮回调
function WndMagicAdvance:onClickBuy(element)
	-- body
	if g_cityExtenInfo.magicStoneStatus == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.MAGIC_STONE_TEXT23)
		return 
	end
	
	local tRechargeData = self:getAdvanceRechargeData()

	local sdkData = {}
    sdkData.id = tRechargeData.ids
    sdkData.price = tRechargeData.price
    sdkData.productName = tRechargeData.name
    sdkData.payCode = tRechargeData.payCodeId
    sdkData.quantifier = LocalStrings.SHOP_IND
    sdkData.number = "1"
    sdkData.giftNumber = "0"
    sdkData.productDesc = tRechargeData.name

    PassportSdkManager:getOrderNum(sdkData)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新界面
function WndMagicAdvance:_update()
	-- body
	local ftxtAdvanceAtt = GetElement(self.m_root, "ftxtAdvanceAtt_WndMagicAdvance", WZUIFreeTextBox)
	if ftxtAdvanceAtt then 
		ftxtAdvanceAtt:setShowText(LocalStrings.MAGIC_STONE_TEXT5)
	end
	--激活奖励
	local tbActiveReward = GetElement(self.m_root, "tbActiveReward_WndMagicAdvance", WZUITableContainer)
	tbActiveReward:cleanTable()
	local strConfig = CacheCenter:getGameParam().stoneRewardImmediately
	local tRewardConfig = json.decode(strConfig)
	local nSeason = WndMagicStone:getCurSeasonValue()
	local sActive = tRewardConfig[tostring(nSeason)]
	WZLog("WndMagicAdvance:_update", nSeason, sActive, Serialize(tRewardConfig))
	local ids, num = SplitItemString(sActive)
	for i = 1, #ids do
		local element, tCell = CellGoodItem:createElement()
		if element and tCell then
			tCell:setCellGoodLocalId(tonumber(ids[i]), tonumber(num[i]), 16)
			tCell:setItemClickFun(self, self.onClickListItem)
			element:setTag(i - 1)
			element:setScale(0.9)
			tbActiveReward:setCellElement(element)
		end
	end

	--激活奖励
	local tbAdvanceReward = GetElement(self.m_root, "tbAdvanceReward_WndMagicAdvance", WZUITableContainer)
	tbAdvanceReward:cleanTable()
	local sAdvance = self:getCurAdvanceRewardData()
	
	local ids, num = SplitItemString(sAdvance)
	local nIndex = 1 
	for i = 1, #ids do
		local element, tCell = CellGoodItem:createElement()
		local basicInfo = GDatatab_item["id_" .. ids[i]]
		if basicInfo and element and tCell then
			if basicInfo.sex == 2 or basicInfo.sex == CacheCenter:getPlayerInfo().sex then 
				tCell:setCellGoodLocalId(tonumber(ids[i]), tonumber(num[i]), 16)
				tCell:setItemClickFun(self, self.onClickListItem)
				element:setTag(nIndex - 1)
				element:setScale(0.9)
				tbAdvanceReward:setCellElement(element)

				nIndex = nIndex + 1
			end
		end
	end

	self:_showState()
end

--@brief 	显示购买状态
function WndMagicAdvance:_showState()
	-- body
	local btnBuy = GetElement(self.m_root, "btnBuy_WndMagicAdvance", WZUIButton)
	local imgHavedActive = GetElement(self.m_root, "imgHavedActive_WndMagicAdvance", WZUIImage)
	local txtBuy = GetElement(self.m_root, "txtBuy_WndMagicAdvance", WZUILabelTTF)
	local tRechargeData = self:getAdvanceRechargeData()
	if tRechargeData == nil then 
		btnBuy:setVisible(false)
	else
		if WndMagicStone.m_nOpenState == 0 then
			btnBuy:setVisible(true)
			imgHavedActive:setVisible(false)
			txtBuy:setUseSystemFont(true)
			txtBuy:setText(tRechargeData.showPrice .. LocalStrings.BUY)
		else
			btnBuy:setVisible(false)
			imgHavedActive:setVisible(true)
		end
	end
end

--@brief 	获取升价充值点数据
function WndMagicAdvance:getAdvanceRechargeData()
	-- body
	local sConfig = CacheCenter:getGameParam().stonemoney
	local string = string.sub(sConfig, 2, -2) 
	local nType = SplitStringWithSeparator(string, ",")[1]
	local nSort = SplitStringWithSeparator(string, ",")[2]
	local rechargeData = CopyTable(CacheCenter:getVipList())
	for k, v in pairs(rechargeData) do
		local localData = GDatatab_recharge["id_" .. v.ids]
		if localData then 
			WZLog("WndMagicAdvance:getAdvanceRechargeData", localData.type, tonumber(nType), tonumber(localData.sort), tonumber(nSort))
			if localData.type == tonumber(nType) and tonumber(localData.sort) == tonumber(nSort) then 
				return v
			end
		else
			if tonumber(v.sortId) == tonumber(nSort) then 
				return v
			end
		end
	end

	return nil 
end
-------------------------------------私有方法模块End----------------------------------------

--@brief	越南语包适配函数
function WndMagicAdvance:_adaptLanguage_vn()
	local txtBuy = GetElement(self.m_root, "txtBuy_WndMagicAdvance", WZUILabelTTF)
	if txtBuy then
		txtBuy:setFontSize(22)
	end
	local txtAdcR = GetElement(self.m_root, "txtAdcR_WndMagicAdvance", WZUILabelTTF)
	if txtAdcR then
		txtAdcR:setFontSize(18)
	end
	local ftxtAdvanceAtt = GetElement(self.m_root, "ftxtAdvanceAtt_WndMagicAdvance", WZUIFreeTextBox)
	if ftxtAdvanceAtt then
		ftxtAdvanceAtt:setMaxWidth(780)
		ftxtAdvanceAtt:setScale(0.75)
	end
end