--CellAdventure.lua
--@brief	CellAdventure的UI模块
--@date		2017/11/13
--@author	qixiang
--@note		冒险商店cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAdventure:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAdventure:onExit(element)
	self:_unInit()
end

--@brief 点击物品图标弹出信息框
function CellAdventure:onIconClick(luaTable,tag)
    local other = {interface = 2,tcell = self}
    WndItemInfo:showInfo(luaTable.m_root,WndStore.m_root,1,self.tData,false,nil,nil,other)
end

function CellAdventure:OnBtnBuy()
    WZLog("---------CellAdventure:OnBtnBuy------------")
	if WndItemInfo.m_root ~= nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.tData.status == 1 then  return  end
    local other = {interface = 2,tcell = self }
	WndItemInfo:showInfo(self.m_root,WndStore.m_root,1,self.tData,true,nil,nil,other)
end

--@brief	点击购买回调
function CellAdventure:onClickbuyBtn()
    WZLog("CellAdventure:onClickbuyBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------cost info----------------",self.tData.costId,self.tData.costNum)
    CellAdventure.m_current = self

    if JudgeMoneyIsEnough(self.tData.costId,self.tData.costNum,nil,nil,8, nil, nil, nil, nil, CellAdventure.m_current, CellAdventure.m_current.sureUseDiamondInstead) then
        CellAdventure.m_current:sureUseDiamondInstead()
    end
end

--@brief    确认用钻石代替礼券购买
function CellAdventure:sureUseDiamondInstead()
    -- body
    WZLog("CellAdventure:sureUseDiamondInstead")
    WndStore:showLoadingB()
    WndStore:setItemTag(CellAdventure.m_current.m_root:getTag())
    ProtocolProcessorStore:send_MALL_BuyArenaStore(CellAdventure.m_current.tData.storeId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellAdventure:_update()
    self:_createOnePropUI()
end

-- 更新商品的信息
function CellAdventure:_createOnePropUI()
    -- 商品名字
    local txtName = GetElement(self.m_root,"txtPropName_CellAdventure",WZUILabelTTF)
    local name = self.tData.basicInfo.name
    txtName:setText(name)
    txtName:setColor(QUALITYCOLOR[self.tData.basicInfo.quality])

    -- 货币类型和价格
    local imgMoney = GetElement(self.m_root,"imgMoney_CellAdventure",WZUIImage)
    local imgFile = GDatatab_item["id_"..self.tData.costId].icon
    imgMoney:setFile(imgFile)
    local txtPrice = GetElement(self.m_root,"txtPrice_CellAdventure",WZUILabelTTF)
    txtPrice:setText(self.tData.costNum)

    -- 商品图标
    local conP = GetElement(self.m_root,"conProp_CellAdventure",WZUIContainer)
    local cell,tcell = CellGoodItem:createElement()
    conP:addChild(cell)
    if self.tData.propNum > 1 then self.tData.lastNum = self.tData.propNum  end
    tcell:setCellGoodItem(self.tData,5)
    tcell:_showItemNum()

    -- 是否售罄
    local conS = GetElement(self.m_root,"conSell_CellAdventure",WZUIContainer)
    conS:setVisible(self.tData.status == 1)

end

function CellAdventure:updateSellStatus()
    WZLog("CellAdventure:updateSellStatus")
    self.tData.status = 1
    local conS = GetElement(self.m_root,"conSell_CellAdventure",WZUIContainer)
    conS:setVisible(true)
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellAdventure:_adaptLanguage_en(  )
    local txt = GetElement(self.m_root,"txtPropName_CellAdventure",WZUILabelTTF)
    txt:setFontSize(15)
end

function CellAdventure:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtPropName_CellAdventure",WZUILabelTTF):setFontSize(20)
end

function CellAdventure:_adaptLanguage_vn(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellAdventure",WZUILabelTTF)
    txtPropName:setDimensions(GlobalMethod:CCSize(150))
    txtPropName:setFontSize(14)
end

function CellAdventure:_adaptLanguage_pt(  )
    local txt = GetElement(self.m_root,"txtPropName_CellAdventure",WZUILabelTTF)
    txt:setScale(0.6)
    txt:setDimensions(GlobalMethod:CCSize(260,0))
    txt:setRelativePosition(GlobalMethod:ccp(0.5,0.427141))
end


function CellAdventure:_adaptLanguage_tr()
    local txtPropName = GetElement(self.m_root,"txtPropName_CellAdventure",WZUILabelTTF)
    txtPropName:setFontSize(17)
    txtPropName:setDimensions(GlobalMethod:CCSize(155))
    txtPropName:setRelativePosition(GlobalMethod:ccp(0.5,0.317851))
end

function CellAdventure:_adaptLanguage_es(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellAdventure",WZUILabelTTF)
    txtPropName:setDimensions(GlobalMethod:CCSize(150,0))
    txtPropName:setFontSize(14)
end