--CellAthShop.lua
--@brief	CellAthShop的UI模块
--@date		2015-6-8
--@author	binshao
--@note		竞技场商店Cell

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAthShop:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAthShop:onExit(element)
	self:_unInit()
end

--@brief 点击物品图标弹出信息框
function CellAthShop:onIconClick(luaTable,tag)
    local other = {interface = 2,tcell = self}
    WndItemInfo:showInfo(luaTable.m_root,WndStore.m_root,1,self.tData,false,nil,nil,other)
end

function CellAthShop:OnBtnBuy()
    WZLog("---------CellAthShop:OnBtnBuy------------")
	if WndItemInfo.m_root ~= nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.tData.status == 1 then  return  end
    local other = {interface = 2,tcell = self }
	WndItemInfo:showInfo(self.m_root,WndStore.m_root,1,self.tData,true,nil,nil,other)
end

--@brief	点击购买回调
function CellAthShop:onClickbuyBtn()
    WZLog("CellAthShop:onClickbuyBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------cost info----------------",self.tData.costId,self.tData.costNum)
    CellAthShop.m_current = self

    if JudgeMoneyIsEnough(self.tData.costId,self.tData.costNum,nil,nil,8, nil, nil, nil, nil, CellAthShop.m_current, CellAthShop.m_current.sureUseDiamondInstead) then
        CellAthShop.m_current:sureUseDiamondInstead()
    end
end

--@brief    确认用钻石代替礼券购买
function CellAthShop:sureUseDiamondInstead()
    -- body
    WZLog("CellAthShop:sureUseDiamondInstead")
    WndStore:showLoadingB()
    WndStore:setItemTag(CellAthShop.m_current.m_root:getTag())
    if WndStore.m_nStoreType == 11 then 
        ProtocolProcessorStore:send_ROOM_BuyAssistStore(CellAthShop.m_current.tData.storeId)
    else
        ProtocolProcessorStore:send_ROOM_BuyArenaStore(CellAthShop.m_current.tData.storeId)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellAthShop:_update()
    self:_createOnePropUI()
end

-- 更新商品的信息
function CellAthShop:_createOnePropUI()
    -- 商品名字
    local txtName = GetElement(self.m_root,"txtPropName_CellAthShop",WZUILabelTTF)
    local name = self.tData.basicInfo.name
    txtName:setText(name)
    txtName:setColor(QUALITYCOLOR[self.tData.basicInfo.quality])

    -- 货币类型和价格
    local imgMoney = GetElement(self.m_root,"imgMoney_CellAthShop",WZUIImage)
    local imgFile = GDatatab_item["id_"..self.tData.costId].icon
    imgMoney:setFile(imgFile)
    local txtPrice = GetElement(self.m_root,"txtPrice_CellAthShop",WZUILabelTTF)
    txtPrice:setText(self.tData.costNum)

    -- 商品图标
    local conP = GetElement(self.m_root,"conProp_CellAthShop",WZUIContainer)
    local cell,tcell = CellGoodItem:createElement()
    conP:addChild(cell)
    if self.tData.propNum > 1 then self.tData.lastNum = self.tData.propNum  end
    tcell:setCellGoodItem(self.tData,5)
    tcell:_showItemNum()

    -- 是否售罄
    local conS = GetElement(self.m_root,"conSell_CellAthShop",WZUIContainer)
    conS:setVisible(self.tData.status == 1)

end

function CellAthShop:updateSellStatus()
    WZLog("CellAthShop:updateSellStatus")
    self.tData.status = 1
    local conS = GetElement(self.m_root,"conSell_CellAthShop",WZUIContainer)
    conS:setVisible(true)
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellAthShop:_adaptLanguage_en(  )
    local txt = GetElement(self.m_root,"txtPropName_CellAthShop",WZUILabelTTF)
    txt:setFontSize(15)
end

function CellAthShop:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtPropName_CellAthShop",WZUILabelTTF):setFontSize(20)
end

function CellAthShop:_adaptLanguage_vn(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellAthShop",WZUILabelTTF)
    txtPropName:setDimensions(GlobalMethod:CCSize(150))
    txtPropName:setFontSize(14)
end

function CellAthShop:_adaptLanguage_pt(  )
    local txt = GetElement(self.m_root,"txtPropName_CellAthShop",WZUILabelTTF)
    txt:setScale(0.8)
    txt:setDimensions(GlobalMethod:CCSize(190,0))
    txt:setRelativePosition(GlobalMethod:ccp(0.5,0.2))
end


function CellAthShop:_adaptLanguage_tr()
    local txtPropName = GetElement(self.m_root,"txtPropName_CellAthShop",WZUILabelTTF)
    txtPropName:setFontSize(17)
    txtPropName:setDimensions(GlobalMethod:CCSize(155))
    txtPropName:setRelativePosition(GlobalMethod:ccp(0.5,0.317851))
end

function CellAthShop:_adaptLanguage_es(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellAthShop",WZUILabelTTF)
    txtPropName:setDimensions(GlobalMethod:CCSize(150,0))
    txtPropName:setFontSize(14)
end

function CellAthShop:_adaptLanguage_ug()
    local txtPropName = GetElement(self.m_root,"txtPropName_CellAthShop",WZUILabelTTF)
    txtPropName:setScale(0.7)
    txtPropName:setDimensions(GlobalMethod:CCSize(220,0))
    txtPropName:setRelativePosition(GlobalMethod:ccp(0.5,0.208561))
end
-------------------------------------语言适配End----------------------------------------