--CellEquipStore.lua
--@brief	CellEquipStore的UI模块
--@date		2015-6-8
--@author	binshao
--@note		竞技场商店Cell

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellEquipStore:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellEquipStore:onExit(element)
	self:_unInit()
end

--@brief 点击物品图标弹出信息框
function CellEquipStore:onIconClick(luaTable,tag)
    local other = {interface = 2,tcell = self}
    WndItemInfo:showInfo(luaTable.m_root,WndStore.m_root,1,self.tData,false,nil,nil,other)
end

function CellEquipStore:OnBtnBuy()
    WZLog("---------CellEquipStore:OnBtnBuy------------")
	if WndItemInfo.m_root ~= nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.tData.status == 1 then  return  end
    local other = {interface = 2,tcell = self }
	WndItemInfo:showInfo(self.m_root,WndStore.m_root,1,self.tData,true,nil,nil,other)
end

--@brief	点击购买回调
function CellEquipStore:onClickbuyBtn()
    WZLog("CellEquipStore:onClickbuyBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------cost info----------------",self.tData.costId,self.tData.costNum)
    CellEquipStore.m_current = self
    if JudgeMoneyIsEnough(self.tData[4],self.tData[5],nil,nil,8, nil, nil, nil, nil, CellEquipStore.m_current, CellEquipStore.m_current.sureUseDiamondInstead) then
        CellEquipStore.m_current:sureUseDiamondInstead()
    end
end

--@brief    确认用钻石代替礼券购买
function CellEquipStore:sureUseDiamondInstead()
    -- body
    WZLog("CellEquipStore:sureUseDiamondInstead")
    WndStore:showLoadingB()
    WndStore:setItemTag(CellEquipStore.m_current.m_root:getTag())
    if self.m_nStoreType == 8 then
        ProtocolProcessorStore:send_EQUIP_Purchase(CellEquipStore.m_current.tData[1])
    elseif self.m_nStoreType == 10 then
        ProtocolProcessorStore:send_PLAYER_BuyTrioRankMatch(CellEquipStore.m_current.tData[1])
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellEquipStore:_update()
    self:_createOnePropUI()
    AdaptLanguage(self)
end

-- 更新商品的信息
function CellEquipStore:_createOnePropUI()
    -- 商品名字
    local txtName = GetElement(self.m_root,"txtPropName_CellEquipStore",WZUILabelTTF)
    local itemInfo = GDatatab_item["id_" .. self.tData[3]]
    local name = itemInfo.name
    txtName:setText(name)
    txtName:setColor(QUALITYCOLOR[itemInfo.quality])

    -- 货币类型和价格
    local imgMoney = GetElement(self.m_root,"imgMoney_CellEquipStore",WZUIImage)
    local imgFile = GDatatab_item["id_"..self.tData[4]].icon
    imgMoney:setFile(imgFile)
    local txtPrice = GetElement(self.m_root,"txtPrice_CellEquipStore",WZUILabelTTF)
    txtPrice:setText(self.tData[5])

    -- 商品图标
    local conP = GetElement(self.m_root,"conProp_CellEquipStore",WZUIContainer)
    local cell,tcell = CellGoodItem:createElement()
    conP:addChild(cell)

    local prop = {}
    prop.storeId = self.tData[1]
    prop.propId = self.tData[3]
    prop.propNum = self.tData[2]
    prop.costId = self.tData[4]
    prop.costNum = self.tData[5]

    prop.basicInfo = GDatatab_item["id_" ..self.tData[3] ]

    if prop.propNum > 1 then prop.lastNum = prop.propNum  end
    tcell:setCellGoodItem(prop,5)
    tcell:_showItemNum()

    -- 是否售罄
    local conS = GetElement(self.m_root,"conSell_CellEquipStore",WZUIContainer)
    conS:setVisible(self.tData[6] <= 0)

end

function CellEquipStore:OnBtnBuy(element)
    WZLog("---------CellEquipStore:OnBtnBuy------------")
    if WndItemInfo.m_root ~= nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.tData[6] <= 0 then  return  end
    local other = {interface = 2,tcell = self }
    local prop = {}
    prop.storeId = self.tData[1]
    prop.propId = self.tData[3]
    prop.propNum = self.tData[2]
    prop.costId = self.tData[4]
    prop.costNum = self.tData[5]
    prop.id = self.tData[3]
    if prop.propNum > 1 then prop.lastNum = prop.propNum  end

    prop.basicInfo = GDatatab_item["id_" ..self.tData[3] ]
    WndItemInfo:showInfo(self.m_root,WndStore.m_root,1,prop,true,nil,nil,other)
end

function CellEquipStore:updateSellStatus()
    WZLog("CellEquipStore:updateSellStatus")
    if self.tData[6] > 0 then
        self.tData[6]  = self.tData[6] - 1
    end
    
    if self.tData[6] <= 0 then
        local conS = GetElement(self.m_root,"conSell_CellEquipStore",WZUIContainer)
        conS:setVisible(true)
    end
end

-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellEquipStore:_adaptLanguage_vn(  )
    local txtName = GetElement(self.m_root,"txtPropName_CellEquipStore",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(220,0))
    txtName:setRelativePosition(GlobalMethod:ccp(0.5,0.208561))
end

function CellEquipStore:_adaptLanguage_en(  )
    local txtName = GetElement(self.m_root,"txtPropName_CellEquipStore",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(220,0))
    txtName:setRelativePosition(GlobalMethod:ccp(0.5,0.208561))
end

function CellEquipStore:_adaptLanguage_th(  )
    local txtName = GetElement(self.m_root,"txtPropName_CellEquipStore",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(220,0))
    txtName:setRelativePosition(GlobalMethod:ccp(0.5,0.208561))
end

function CellEquipStore:_adaptLanguage_pt(  )
    local txtName = GetElement(self.m_root,"txtPropName_CellEquipStore",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(220,0))
    txtName:setRelativePosition(GlobalMethod:ccp(0.5,0.208561))
end

function CellEquipStore:_adaptLanguage_es(  )
    local txtName = GetElement(self.m_root,"txtPropName_CellEquipStore",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(220,0))
    txtName:setRelativePosition(GlobalMethod:ccp(0.5,0.208561))
end

function CellEquipStore:_adaptLanguage_tr(  )
    local txtName = GetElement(self.m_root,"txtPropName_CellEquipStore",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(220,0))
    txtName:setRelativePosition(GlobalMethod:ccp(0.5,0.208561))
end
---------------------------------------语言适配End------------------------------------------