--CellPetExchange.lua
--@brief	CellPetExchange的UI模块
--@date		2016/11/14
--@author	zhangming
--@note		宠物积分兑换cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPetExchange:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPetExchange:onExit(element)
	self:_unInit()
end

--@brief 点击物品图标弹出信息框
function CellPetExchange:onIconClick(luaTable,tag)
    local other = {interface = 2,tcell = self}
    local tabItem = GDatatab_item["id_"..self.tData.itemId]
    WndItemInfo:showInfo(luaTable.m_root,WndStore.m_root,1,tabItem,false,nil,nil,other)
end

function CellPetExchange:OnBtnBuy()
    WZLog("---------CellPetExchange:OnBtnBuy------------")
	if WndItemInfo.m_root ~= nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.tData.status == 1 then  return  end
    local other = {interface = 2,tcell = self }
    local tabItem = GDatatab_item["id_"..self.tData.itemId]
	WndItemInfo:showInfo(self.m_root,WndStore.m_root,1,tabItem,true,nil,nil,other)
end

--@brief	点击购买回调
function CellPetExchange:onClickbuyBtn()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------cost info----------------",self.tData.costId,self.tData.price)
    if JudgeMoneyIsEnough(self.tData.costId,self.tData.price,LocalStrings.PETNOENOUGHITEM,2,59) then
        WndStore:showLoadingB()
        WndStore:setItemTag(self.m_root:getTag())
        ProtocolProcessorStore:send_PET_PurchasePet(self.tData.id)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPetExchange:_update()
    self:_createOnePropUI()
end

-- 更新商品的信息
function CellPetExchange:_createOnePropUI()
    -- 商品名字
    local txtName = GetElement(self.m_root,"txtPropName_CellPetExchange",WZUILabelTTF)
    WZLog("ellPetExchange:_createOnePropUI:", self.tData.itemId)
    local tabItem = GDatatab_item["id_"..self.tData.itemId]
    local name = tabItem.name
    WZLog("CellPetExchange:_createOnePropUI:",tabItem.quality)
    txtName:setText(name)
    txtName:setColor(QUALITYCOLOR[tabItem.quality])

    -- 货币类型和价格
    local imgMoney = GetElement(self.m_root,"imgMoney_CellPetExchange",WZUIImage)
    local imgFile = GDatatab_item["id_"..self.tData.costId].icon
    imgMoney:setFile(imgFile)
    local txtPrice = GetElement(self.m_root,"txtPrice_CellPetExchange",WZUILabelTTF)
    txtPrice:setText(self.tData.price)

    -- 商品图标
    local qualityPic5 = {"ui/common/common_icon_lg.png",
                    "ui/common/common_icon_ng.png",
                    "ui/common/common_icon_zg.png",
                    "ui/common/common_icon_hg.png"}
    local conP = GetElement(self.m_root,"conProp_CellPetExchange",WZUIContainer)
    if tabItem.main_type == 10 then
        local bgElement = GetElement(self.m_root,"imgBg_CellPetExchange",WZUIImage)
        bgElement:setFile(qualityPic5[tabItem.quality])
        bgElement:setVisible(true)
    	local petAni = CreatePetAni(conP, self.tData.itemId, nil)
    	petAni:setScale(0.5)
        if self.tData.gainNum > 1 then 
            local txtNum = WZUILabelTTF:create()
            txtNum:setLabelStyleKey("C18_F22_S1_C5")
            txtNum:setText(self.tData.gainNum)
            txtNum:setRelativePosition(GlobalMethod:ccp(0.85, 0.2))
            conP:addChild(txtNum)
        end
    else
	    local cell,tcell = CellGoodItem:createElement()
	    conP:addChild(cell)
	    local goodItemTab = {}
	    goodItemTab.basicInfo = tabItem
	    if self.tData.gainNum > 1 then goodItemTab.lastNum = self.tData.gainNum  end
	    tcell:setCellGoodItem(goodItemTab,5)
	    tcell:_showItemNum()
	end

    -- 是否售罄
    local conS = GetElement(self.m_root,"conSell_CellPetExchange",WZUIContainer)
    conS:setVisible(self.tData.status == 1)

end

function CellPetExchange:updateSellStatus()
	WZLog("CellPetExchange:updateSellStatus")
    self.tData.status = 1
    local conS = GetElement(self.m_root,"conSell_CellPetExchange",WZUIContainer)
    conS:setVisible(true)
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellPetExchange:_adaptLanguage_pt(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellPetExchange",WZUILabelTTF)
    txtPropName:setDimensions(GlobalMethod:CCSize(190))
    txtPropName:setScale(0.8)
    txtPropName:setRelativePosition(GlobalMethod:ccp(0.5,0.354281))
end

function CellPetExchange:_adaptLanguage_es(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellPetExchange",WZUILabelTTF)
    txtPropName:setDimensions(GlobalMethod:CCSize(190))
    txtPropName:setFontSize(16)
    txtPropName:setRelativePosition(GlobalMethod:ccp(0.5,0.355))
end
-------------------------------------语言适配End--------------------------------------------