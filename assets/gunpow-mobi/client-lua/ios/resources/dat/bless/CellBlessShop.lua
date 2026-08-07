--CellBlessShop.lua
--@brief	CellBlessShop的UI模块
--@date		2016/04/12
--@author	Tianxiang_Xu
--@note		祈福商店格子

QUALITY_RECT_BACKlIGHT = {"ui/common/common_icon_lg.png",
                    "ui/common/common_icon_ng.png",
                    "ui/common/common_icon_zg.png",
                    "ui/common/common_icon_hg.png"}
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBlessShop:onEnter(element)
    WZLog("CellBlessShop:onEnter")
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBlessShop:onExit(element)
	self:_unInit()
end

--@brief    点击商品回调
function CellBlessShop:OnBtnBuy(element)
    -- body
    WZLog("CellBlessShop:OnBtnBuy")
	if WndItemInfo.m_root ~= nil then return end
	if WndTips.m_root ~= nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tData = self.m_tData
    tData.tCallBack = self.m_tCallBack

    WndTips:show(element,self.m_tTipParentNode,25,tData,GlobalMethod:ccp(200,50))
end

--@brief    加载cell数据信息
function CellBlessShop:onLoadData(element)
    WZLog("CellBlessShop:onLoadData")
    local cellElement = WZUISystem:getInstance():createElement("CellBlessShop")
    self.m_root:addChild(cellElement)
    self:_update()
    AdaptLanguage(self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新节点数据
function CellBlessShop:_update()
    WZLog("CellBlessShop:_update")

    local tData = self.m_tData
    local QUALITY_COLOR = {GlobalMethod:ccc3(255,255,255),GlobalMethod:ccc3(99,255,95), GlobalMethod:ccc3(93,222,254), GlobalMethod:ccc3(198,130,255), GlobalMethod:ccc3(255,227,116)}
    --名字
    local txtPropName = GetElement(self.m_root, "txtPropName_CellBlessShop", WZUILabelTTF)
    txtPropName:setText(tData.basicInfo.name)
    txtPropName:setColor(QUALITY_COLOR[tData.basicInfo.quality + 1])
    --花费
    local txtPrice = GetElement(self.m_root, "txtPrice_CellBlessShop", WZUILabelTTF)
    txtPrice:setText(tData.cost[2])
    --品质底
    local imgQuality = GetElement(self.m_root, "imgQuality_CellBlessShop", WZUIImage)
    imgQuality:setFile(QUALITY_RECT_BACKlIGHT[tData.basicInfo.quality])
    --物品
    local conProp = GetElement(self.m_root, "conProp_CellBlessShop", WZUIContainer)
    local cellElement,tCell = CellBlessItem:createElement()
    conProp:addChild(cellElement)
    tCell:setData(tData,8,self.m_tTipParentNode)
    --花费的图标
    local imgMoney = GetElement(self.m_root, "imgMoney_CellBlessShop", WZUIImage)
    --一次可购买的数量
    local txtBuyNum = GetElement(self.m_root, "txtBuyNum_CellBlessShop", WZUILabelTTF)
    if tData.itemid_num[2] > 1 then
        txtBuyNum:setText(tData.itemid_num[2])
    else
        txtBuyNum:setVisible(false)
    end

    local itemData = GDatatab_item["id_"..tData.cost[1]]
    if itemData then
        imgMoney:setFile(itemData.icon)
    end
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellBlessShop:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtPropName_CellBlessShop",WZUILabelTTF):setFontSize(16)
end
-------------------------------------语言适配Begin------------------------------------------
function CellBlessShop:_adaptLanguage_tr(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellBlessShop",WZUILabelTTF)
    txtPropName:setFontSize(20)
end

function CellBlessShop:_adaptLanguage_en(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellBlessShop",WZUILabelTTF)
    txtPropName:setFontSize(20)
end
