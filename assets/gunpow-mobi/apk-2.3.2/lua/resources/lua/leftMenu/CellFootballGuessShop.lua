--CellFootballGuessShop.lua
--@brief	CellFootballGuessShop的UI模块
--@date		2018/06/01
--@author	Tianxiang_Xu
--@note		足球精彩商店列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFootballGuessShop:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFootballGuessShop:onExit(element)
	self:_unInit()
end

--@brief 	点击物品回调
function CellFootballGuessShop:onClickItem(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tData.leftNum <= 0 then return end 
    
	local other = {interface = 2, tcell = self}
	local string = string.sub(self.m_tData.item, 2, -2) 
	local id = SplitStringWithSeparator(string,",")[1]
	local num = SplitStringWithSeparator(string,",")[2]

	local tData = {}
	tData.id = tonumber(id)
	tData.lastNum = tonumber(num)

	WndItemInfo:showInfo(self.m_root, WndFootballActivity.m_root, 1, tData, true, nil, nil, other)
end

--@brief	点击购买回调
function CellFootballGuessShop:onClickbuyBtn()
    WZLog("CellFootballGuessShop:onClickbuyBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------cost info----------------",self.m_tData.cost)
    CellFootballGuessShop.m_current = self

    local string = string.sub(self.m_tData.cost, 2, -2) 
	local id = SplitStringWithSeparator(string,",")[1]
	local num = SplitStringWithSeparator(string,",")[2]
    if JudgeMoneyIsEnough(tonumber(id), tonumber(num), nil, nil, 8, nil, nil, nil, nil, CellFootballGuessShop.m_current, CellFootballGuessShop.m_current.sureUseDiamondInstead) then
        CellFootballGuessShop.m_current:sureUseDiamondInstead()
    end
end

--@brief    确认用钻石代替礼券购买
function CellFootballGuessShop:sureUseDiamondInstead()
    -- body
    WZLog("CellFootballGuessShop:sureUseDiamondInstead")
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_PurchaseFootballQuizStore(CellFootballGuessShop.m_current.m_tData.id)
end

--@brief    加载cell数据信息
function CellFootballGuessShop:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellFootballGuessShop")
    self.m_root:addChild(cellElement)
    self.m_bIsLoad = true

    self:_update()
    AdaptLanguage(self)
end

--@brief    设置剩余购买次数
function CellFootballGuessShop:setLeftTimes(leftNum)
    -- body
    self.m_tData.leftNum = leftNum
    if self.m_bIsLoad == false then return end 

    local txtBuyTimes = GetElement(self.m_root, "txtBuyTimes_CellFootballGuessShop", WZUILabelTTF)
    if txtBuyTimes then
        txtBuyTimes:setText(LocalStrings.SHOP_DAY_LIMIT .. ":" .. self.m_tData.leftNum)
    end
    if self.m_tData.leftNum <= 0 then
        GetElement(self.m_root, "conSellOut_CellFootBallGuessShop", WZUIContainer):setVisible(true)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellFootballGuessShop:_update()
	-- body
	local tData = self.m_tData 
    --自己显示绿色
    -- if playerId == CacheCenter:getPlayerInfo().id then
    --     local imgBK = GetElement(self.m_root, "imgBK_CellRankLevel", WZUI9Image)
    --     imgBK:setFile("ui/common/common_scale9_di38.png")
    -- end
    local conItem = GetElement(self.m_root, "conItem_CellFootballGuessShop", WZUIContainer)
    local string = string.sub(tData.item, 2, -2) 
	local id = SplitStringWithSeparator(string,",")[1]
	local num = SplitStringWithSeparator(string,",")[2]
    if conItem then
    	local element, tNewObj = CellGoodItem:createElement()
    	if element and tNewObj then
    		tNewObj:setCellGoodLocalId(tonumber(id), tonumber(num), 20)
			GetElement(tNewObj.m_root,"btnImg_CellGoodItem",WZUI9Image):setVisible(false)
			GetElement(tNewObj.m_root,"btnImg1_CellGoodItem",WZUI9Image):setFile("")
			GetElement(tNewObj.m_root,"btnImg2_CellGoodItem",WZUI9Image):setFile("")

			conItem:addChild(element)
    	end
    end
    
    local name = GDatatab_item["id_" .. id].name
    GetElement(self.m_root, "txtName_CellFootballGuessShop", WZUILabelTTF):setText(name)
    local strNum = num
    if tonumber(num) == -1 then
        strNum = LocalStrings.YJ
    end
    GetElement(self.m_root, "txtNum_CellFootballGuessShop", WZUILabelTTF):setText(strNum)
    local ftxtCost = GetElement(self.m_root, "ftxtCost_CellFootballGuessShop", WZUIFreeTextBox)
    if ftxtCost then
    	local string = string.sub(tData.cost, 2, -2) 
		local id = SplitStringWithSeparator(string,",")[1]
		local num = SplitStringWithSeparator(string,",")[2]
		local tBasicData = GDatatab_item["id_" .. id]
    	local sFormat = [[<I Z="0.5" P="1">%s</I><T C="38,96,174" S="22" P="1" SC="127,70,26" SS="4" SE="0">%d</T>]]
    	ftxtCost:setShowText(string.format(sFormat, tBasicData.icon, tonumber(num)))
    end

    --剩余购买次数
    self:setLeftTimes(self.m_tData.leftNum)
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------私有方法模块End----------------------------------------
function CellFootballGuessShop:_adaptLanguage_vn(  )
    GetElement(self.m_root, "txtBuyTimes_CellFootballGuessShop", WZUILabelTTF):setScale(0.7)
    local txtName = GetElement(self.m_root, "txtName_CellFootballGuessShop", WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(240))
end
-------------------------------------私有方法模块End----------------------------------------