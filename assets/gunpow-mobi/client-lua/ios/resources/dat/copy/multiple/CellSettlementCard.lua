--CellSettlementCard.lua
--@brief	CellSettlementCard的UI模块
--@date		2015/04/16
--@author	xiaoyu_wu
--@note		翻牌奖励单张牌


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSettlementCard:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSettlementCard:onExit(element)
	self:_unInit()
end

--@brief	设置类型
--@param    nType:翻牌类型 1:免费，2:VIP免费，3:付费
function CellSettlementCard:setType(nType)
    if self.m_root == nil then
        return
    end
    self.m_nType = nType
    if nType == 2 then
        local imgVIP = GetElement(self.m_root, "imgVIP_CellSettlementCard")
        imgVIP:setVisible(true)
    elseif nType == 3 then
        local conDiamond = GetElement(self.m_root, "conDiamond_CellSettlementCard")
        conDiamond:setVisible(true)
        local imgCostIcon = GetElement(self.m_root,"imgCostIcon_CellSettlementCard",WZUIImage)
        if CacheCenter:getGameParam().isUseTicket == "1" then
            imgCostIcon:setFile("ui/common/common_icon_zuanshi.png")
        end
        if self.m_nFlopRebate < 100 then 
            GetElement(self.m_root, "imgRedLine_CellSettlementCard", WZUIImage):setVisible(true)
            conDiamond:setRelativePosition(GlobalMethod:ccp(0.5, 0.58))
            GetElement(self.m_root, "conCurDiamond_CellSettlementCard", WZUIContainer):setVisible(true)
            local txtCurCostWord = GetElement(self.m_root, "txtCurCostWord_CellSettlementCard", WZUILabelTTF)
            local nMod = math.mod(self.m_nFlopRebate, 10)
            local nDiscount 
            if nMod == 0 then 
                nDiscount = self.m_nFlopRebate/10
            else
                nDiscount = self.m_nFlopRebate
            end
            txtCurCostWord:setText(string.format(LocalStrings.LUCKYGIFT3 .. ":", nDiscount))

            local imgCurCostIcon = GetElement(self.m_root,"imgCurCostIcon_CellSettlementCard",WZUIImage)
            if CacheCenter:getGameParam().isUseTicket == "1" then
                imgCurCostIcon:setFile("ui/common/common_icon_zuanshi.png")
            end
            local txtCurCost = GetElement(self.m_root, "txtCurCost_CellSettlementCard", WZUILabelTTF)
            txtCurCost:setText(math.ceil(20 * self.m_nFlopRebate/100))
        end
    else
        local imgFree = GetElement(self.m_root, "imgFree_CellSettlementCard")
        imgFree:setVisible(true)
    end
end

--@brief	点击按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function CellSettlementCard:onClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("CellSettlementCard:onClick")
    if self.m_nState == 1 then
        WZLog("-------------------cur card is flip---------------")
        return
    end

    if self.m_tcallbackLua then
        self.m_fClickCallback(self.m_tcallbackLua,self)
        return
    end

    if self.m_fClickCallback then
        self.m_fClickCallback(self)
    end
end

--@brief	旋转卡片
function CellSettlementCard:flipCard()
    if self.m_root == nil then
        return
    end
    self.m_nState = 1
    self:setTouchEnable(false)
    
    local conFront = GetElement(self.m_root, "conFront_CellSettlementCard")
    local conBack = GetElement(self.m_root, "conBack_CellSettlementCard")
    conFront:setVisible(true)
    conBack:setVisible(false)
    
    local aniflip = CCOrbitCamera:create(0.2, 1.0, 0.0, 0.0, -180, 0.0, 0.0)
    self.m_root:runAction(aniflip)
end

--@brief	设置卡牌是否可触摸
--@param    bEnable,是否可触摸
function CellSettlementCard:setTouchEnable(bEnable)
    if self.m_root == nil then
        return
    end
    local conBtn = GetElement(self.m_root, "conCardBtn_CellSettlementCard")
    conBtn:setTouchEnable(bEnable)
    WZLog("-------------------set touch enabled----------------",self,bEnable)
end

--@brief    获取卡牌的按钮容器节点
function CellSettlementCard:getCardBtnCon()
    -- body
    local conCardBtn = GetElement(self.m_root, "conCardBtn_CellSettlementCard", WZUIContainer)

    return conCardBtn 
end

--@brief    点击空白地方回调
function CellSettlementCard:onClickSkip(element)
    -- body
    WZLog("CellSettlementCard:onClickSkip")
    SceneFlopCard:onClickSkip(element)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
local tColorList = {
    GlobalMethod:ccc3(131,255,0),
    GlobalMethod:ccc3(0,176,240),
    GlobalMethod:ccc3(255,0,174),
    GlobalMethod:ccc3(255,204,0),
}
--@brief	更新界面
function CellSettlementCard:_update()
    if self.m_root == nil or self.m_tData == nil then
        return
    end
    
    local txtPlayerName = GetElement(self.m_root, "txtPlayerName_CellSettlementCard", WZUILabelTTF)
    txtPlayerName:setText(self.m_tData.name)
    local txtLevel = GetElement(self.m_root, "txtLevel_CellSettlementCard", WZUILabelTTF)
    txtLevel:setText(self.m_tData.level)
    --txtPlayerName:setShowText(string.format([[<T S="20" C="255,227,116">Lv.%d </T><T S="20" C="255,121,31">%s</T>]], self.m_tData.level, self.m_tData.name))
    
    local tItemData = GetItemLocalData(self.m_tData.flop[self.m_nType].flopId)
	local nCount
    local conItem = GetElement(self.m_root, "conItem_CellSettlementCard")
    if tItemData then
        local txtCardName = GetElement(self.m_root, "txtCardName_CellSettlementCard", WZUILabelTTF)
		txtCardName:setVisible(true)
        txtCardName:setText(tItemData.name)
        txtCardName:setColor(QUALITYCOLOR[tItemData.quality])
        
        nCount = self.m_tData.flop[self.m_nType].flopCount or 0
        local eItem = self:_createCellGoodItem(nCount, tItemData.id)
		conItem:setRelativePosition(ccp(0.5,0.511))
		conItem:setScale(1)
        conItem:addChild(eItem)
    end

	--获得时装，已经有永久时，显示转化为礼钻
	GetElement(self.m_root,"conConversion",WZUIContainer):setVisible(false)
	if CacheCenter:getPlayerItemCountById(tItemData.id) == -1 then
		local dressQualityModulus = CacheCenter:getGameParam().dressQualityModulus
		local dressUnlimitedModulus = CacheCenter:getGameParam().dressUnlimitedModulus
		WZLog("转化参数", dressQualityModulus, dressUnlimitedModulus)
		if dressQualityModulus == nil or dressQualityModulus == "" then dressQualityModulus = "[2,3]&[3,4]&[4,5]" end
		if dressUnlimitedModulus == nil or dressUnlimitedModulus == "" then dressUnlimitedModulus = [[100]] end
		GetElement(self.m_root, "txtCardName_CellSettlementCard", WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"conConversion",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"txtConversion",WZUILabelTTF):setText(1)

		local multiple = 1
		if nCount == -1 then nCount = tonumber(dressUnlimitedModulus) end
		local quality, modulus = SplitItemString(dressQualityModulus)
		for i=1,#quality do
			if tonumber(quality[i]) == GDatatab_item["id_"..tItemData.id].quality then
				multiple = modulus[i]
				break
			end
		end
		GetElement(self.m_root,"txtConversion",WZUILabelTTF):setText(nCount*multiple)
		conItem:setRelativePosition(ccp(0.5,0.565))
		conItem:setScale(0.9)

        if CacheCenter:getGameParam().isUseTicket == "1" then
            GetElement(self.m_root,"imgCostIcon2_CellSettlementCard",WZUIImage):setFile("ui/common/common_icon_zuanshi.png")
        end
	end

    -- 特效
    local conSpine = GetElement(self.m_root, "spine_CellSettlementCard", WZUIContainer)
    local idSame = CacheCenter:getPlayerInfo().id == self.m_tData.id
    conSpine:setVisible(idSame)
    if idSame then
        txtPlayerName:setColor(GlobalMethod:ccc3(99,255,95))
    end
end

--@brief    创建一个物品格子
--@param    nIndex, 序号
--@param    nItemId, 物品id
function CellSettlementCard:_createCellGoodItem(nCount, nItemId)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setScale(0.94)
    local tData = {
        id = nItemId,
        lastNum = nCount,
        lastTime = nCount,
        isUse = false,
        data = "",
        playerItemId = -1,
        basicInfo = GetItemLocalData(nItemId)
    }
    tItem:setCellGoodItem(tData, 16)
    return eItem, tItem
end

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配Begin-----------------------------------------
function CellSettlementCard:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtCardName_CellSettlementCard",WZUILabelTTF):setFontSize(16)
end

function CellSettlementCard:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtCardName_CellSettlementCard",WZUILabelTTF):setFontSize(16)
end

function CellSettlementCard:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtCardName_CellSettlementCard",WZUILabelTTF):setFontSize(14)
end

function CellSettlementCard:_adaptLanguage_vn(  )
    local txtCardName = GetElement(self.m_root,"txtCardName_CellSettlementCard",WZUILabelTTF)
    txtCardName:setScale(0.56)
    txtCardName:setDimensions(GlobalMethod:CCSize(310))
    txtCardName:setRelativePosition(GlobalMethod:ccp(0.5,0.188882))

    GetElement(self.m_root,"txtConvert_CellSettlementCard",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.371831,0.165))
    GetElement(self.m_root,"imgCostIcon2_CellSettlementCard",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.579859,0.165))
    GetElement(self.m_root,"txtConversion",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.636901,0.165))
    
end
--------------------------------------语言适配End------------------------------------------
