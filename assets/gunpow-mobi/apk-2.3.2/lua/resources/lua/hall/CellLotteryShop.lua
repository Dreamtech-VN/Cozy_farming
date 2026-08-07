--CellLotteryShop.lua
--@brief	CellLotteryShop的UI模块
--@date		2021/05/21
--@author	hyc
--@note		召唤商店物品格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLotteryShop:onEnter(element)
	self.m_root = element

    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLotteryShop:onExit(element)
	self:_unInit()
end

--@brief 点击物品图标弹出信息框
function CellLotteryShop:onIconClick(luaTable,tag)
    local other = {interface = 2,tcell = self}
    WndItemInfo:showInfo(luaTable.m_root,WndStore.m_root,1,self.tData,false,nil,nil,other)
end

function CellLotteryShop:OnBtnBuy()
    WZLog("---------CellLotteryShop:OnBtnBuy------------")
	if WndItemInfo.m_root ~= nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.tData.status == 1 then  return  end
    local other = {interface = 2,tcell = self }
	WndItemInfo:showInfo(self.m_root,WndStore.m_root,1,self.tData,true,nil,nil,other)
end

--@brief	点击购买回调
function CellLotteryShop:onClickbuyBtn()
    WZLog("CellLotteryShop:onClickbuyBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------cost info----------------",self.tData.costId,self.tData.costNum)
    CellLotteryShop.m_current = self
    local haveNum = CacheCenter:getPlayerItemCountById(self.tData.costId)
    if haveNum < self.tData.costNum then
        MsgBoxManager:showTipBox(LocalStrings.LOTTERY_SHOP_COIN)
        
        WndFastGetItems:show(self.tData.costId)
        return
    end
    if JudgeMoneyIsEnough(self.tData.costId,self.tData.costNum,nil,nil,8, nil, nil, nil, nil, CellLotteryShop.m_current, CellLotteryShop.m_current.sureUseDiamondInstead) then
        CellLotteryShop.m_current:sureUseDiamondInstead()
    end
end

--@brief    确认用钻石代替礼券购买
function CellLotteryShop:sureUseDiamondInstead()
    -- body
    WZLog("CellACellLotteryShopthShop:sureUseDiamondInstead")
    WndStore:showLoadingB()
    WndStore:setItemTag(CellLotteryShop.m_current.m_root:getTag())
    if WndStore.m_nStoreType == 12 then 
        ProtocolProcessorStore:send_PLAYER2_BuyDrawStore(CellLotteryShop.m_current.tData.storeId)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellLotteryShop:_update()
    self:_createOnePropUI()
end

-- 更新商品的信息
function CellLotteryShop:_createOnePropUI()
    -- 商品名字
    local txtName = GetElement(self.m_root,"txtPropName_CellLotteryShop",WZUILabelTTF)
    local name = self.tData.basicInfo.name
    txtName:setText(name)
    txtName:setColor(QUALITYCOLOR[self.tData.basicInfo.quality])

    -- 货币类型和价格
    local imgMoney = GetElement(self.m_root,"imgMoney_CellLotteryShop",WZUIImage)
    local imgFile = GDatatab_item["id_"..self.tData.costId].icon
    imgMoney:setFile(imgFile)
    local txtPrice = GetElement(self.m_root,"txtPrice_CellLotteryShop",WZUILabelTTF)
    txtPrice:setText(self.tData.costNum)

    -- 商品图标
    local conP = GetElement(self.m_root,"conProp_CellLotteryShop",WZUIContainer)
    local cell,tcell = CellGoodItem:createElement()
    conP:addChild(cell)
    if self.tData.propNum > 1 then self.tData.lastNum = self.tData.propNum  end
    tcell:setCellGoodItem(self.tData,5)
    tcell:_showItemNum()

    -- 是否售罄
    local conS = GetElement(self.m_root,"conSell_CellLotteryShop",WZUIContainer)
    conS:setVisible(self.tData.status == 1)

end

function CellLotteryShop:updateSellStatus()
    WZLog("CellAthShop:updateSellStatus")
    self.tData.status = 1
    local conS = GetElement(self.m_root,"conSell_CellLotteryShop",WZUIContainer)
    conS:setVisible(true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------



-------------------------------------语言适配Begin----------------------------------------

function CellLotteryShop:_adaptLanguage_vn(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellLotteryShop",WZUILabelTTF)
    txtPropName:setDimensions(GlobalMethod:CCSize(150))
    txtPropName:setFontSize(14)
end

-------------------------------------语言适配End----------------------------------------