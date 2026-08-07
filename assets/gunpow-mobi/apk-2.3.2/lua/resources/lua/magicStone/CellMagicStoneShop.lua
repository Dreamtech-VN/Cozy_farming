--CellMagicStoneShop.lua
--@brief	CellMagicStoneShop的UI模块
--@date		2019/10/24
--@author	Tianxiang_Xu
--@note		幻石系统-商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMagicStoneShop:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMagicStoneShop:onExit(element)
	self:_unInit()
end

--@brief 点击物品图标弹出信息框
function CellMagicStoneShop:onIconClick(luaTable,tag)
    local other = {interface = 2,tcell = self}
    WndItemInfo:showInfo(luaTable.m_root,WndMagicStone.m_root,1,self.tData,false,nil,nil,other)
end

function CellMagicStoneShop:OnBtnBuy()
    WZLog("---------CellMagicStoneShop:OnBtnBuy------------", self.tData.marketNum)
	if WndItemInfo.m_root ~= nil then return end
	if self.tData.open_level > WndMagicStone:getMagicStoneLevel() then return end 

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if g_cityExtenInfo.magicStoneStatus == 0 then 
        MsgBoxManager:showTipBox(LocalStrings.MAGIC_STONE_TEXT23)
        return 
    end

    if self.tData.marketNum == 0 then return end

    local tItem = self.tData.store_boy
    if CacheCenter:getPlayerInfo().sex == 1 then 
    	tItem = self.tData.store_girl
    end
    local basicInfo = GDatatab_item["id_" .. tItem[1][1]]
    local showtype = 3
	local limitNum = self.tData.marketNum
	if limitNum == -1 then 
		limitNum = 100
	end
    local num = tItem[1][2]
    if tItem[1][2] == -1 then
        num = 1
    end
    WndBuyMultipleItem:show(tItem[1][1], num, self.tData.cost[1][1], self.tData.cost[1][2], self.tData.id, self, self.onClickbuyBtn, showtype, limitNum, self.tData.limit_num[1])
end

--@brief	点击购买回调
function CellMagicStoneShop:onClickbuyBtn(nitemId, nNum, nStoreId)
    WZLog("CellMagicStoneShop:onClickbuyBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------cost info----------------",self.tData.cost[1][1],self.tData.cost[1][2])
    self.m_nBuyNum = nNum
    self.m_nStoreId = nStoreId
    CellMagicStoneShop.m_current = self

    if JudgeMoneyIsEnough(self.tData.cost[1][1], self.tData.cost[1][2] * nNum, nil, nil, 8, nil, nil, nil, nil, CellMagicStoneShop.m_current, CellMagicStoneShop.m_current.sureUseDiamondInstead) then
        CellMagicStoneShop.m_current:sureUseDiamondInstead()
    end
end

--@brief    确认用钻石代替礼券购买
function CellMagicStoneShop:sureUseDiamondInstead()
    -- body
    WZLog("CellMagicStoneShop:sureUseDiamondInstead")
    ProtocolProcessorWndMagicStone:send_MAGICSTONE_Buy(CellMagicStoneShop.m_current.m_nStoreId, CellMagicStoneShop.m_current.m_nBuyNum)
    WndBuyMultipleItem:closeWin()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellMagicStoneShop:_update()
    self:_createOnePropUI()
end

-- 更新商品的信息
function CellMagicStoneShop:_createOnePropUI()
    -- 商品名字
    local tItem = self.tData.store_boy
    if CacheCenter:getPlayerInfo().sex == 1 then 
    	tItem = self.tData.store_girl
    end
    local basicInfo = GDatatab_item["id_" .. tItem[1][1]]

    local txtName = GetElement(self.m_root,"txtPropName_CellMagicStoneShop",WZUILabelTTF)
    local name = basicInfo.name
    txtName:setText(name)
    txtName:setColor(QUALITYCOLOR[basicInfo.quality])
    --品质
    GetElement(self.m_root, "imgQuality_CellMagicStoneShop", WZUIImage):setFile(g_tShopItemQuality[basicInfo.quality+1])
    --限购
    local conLimit = GetElement(self.m_root, "conLimit_CellMagicStoneShop", WZUIContainer)
    if self.tData.limit_num[1][1] == 1 then 
    	conLimit:setVisible(true)
    	GetElement(self.m_root, "txtLimitNum_CellMagicStoneShop", WZUILabelTTF):setText(LocalStrings.SHOP_LIMIT_TITLE .. self.tData.marketNum .. "/" .. self.tData.limit_num[1][2])
    elseif self.tData.limit_num[1][1] == 2 then 
    	conLimit:setVisible(true)
    	GetElement(self.m_root, "txtLimitNum_CellMagicStoneShop", WZUILabelTTF):setText(LocalStrings.SHOP_DAY_LIMIT .. self.tData.marketNum .. "/" .. self.tData.limit_num[1][2])
    end
    --锁
    if self.tData.open_level > WndMagicStone:getMagicStoneLevel() then 
    	GetElement(self.m_root, "conNotLimitTxt_CellMagicStoneShop", WZUIContainer):setVisible(false)

    	GetElement(self.m_root, "conLock_CellMagicStoneShop", WZUIContainer):setVisible(true)
    	GetElement(self.m_root, "txtLock_CellMagicStoneShop", WZUILabelTTF):setText(string.format(LocalStrings.MAGIC_STONE_TEXT15, self.tData.open_level))
    end

    -- 货币类型和价格
    local imgMoney = GetElement(self.m_root,"imgMoney_CellMagicStoneShop",WZUIImage)
    local imgFile = GDatatab_item["id_"..self.tData.cost[1][1]].icon
    imgMoney:setFile(imgFile)
    local txtPrice = GetElement(self.m_root,"txtPrice_CellMagicStoneShop",WZUILabelTTF)
    txtPrice:setText(self.tData.cost[1][2])

    -- 商品图标
    local conP = GetElement(self.m_root,"conProp_CellMagicStoneShop",WZUIContainer)
    local cell,tcell = CellGoodItem:createElement()
    conP:addChild(cell)
    tcell:setCellGoodLocalId(tItem[1][1], tItem[1][2], 5)
    tcell:_showItemNum()

    -- 是否售罄
    local conS = GetElement(self.m_root,"conSell_CellMagicStoneShop",WZUIContainer)
    conS:setVisible(self.tData.marketNum == 0)
end

function CellMagicStoneShop:updateSellStatus()
    WZLog("CellMagicStoneShop:updateSellStatus")
    self.tData.marketNum = 0
    local conS = GetElement(self.m_root,"conSell_CellMagicStoneShop",WZUIContainer)
    conS:setVisible(true)
end




-------------------------------------私有方法模块End----------------------------------------
--@brief    越南语包适配函数
function CellMagicStoneShop:_adaptLanguage_vn()
    local conLock_CellMagicStoneShop =GetElement(self.m_root, "conLock_CellMagicStoneShop", WZUIContainer)
    if conLock_CellMagicStoneShop then
        conLock_CellMagicStoneShop:setRelativePosition(GlobalMethod:ccp(0.38,0.5))
        local txtLock_CellMagicStoneShop = GetElement(self.m_root, "txtLock_CellMagicStoneShop", WZUILabelTTF)
        txtLock_CellMagicStoneShop:setFontSize(16)
    end

    GetElement(self.m_root,"txtPropName_CellMagicStoneShop",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtLimitNum_CellMagicStoneShop",WZUILabelTTF):setFontSize(16)
end