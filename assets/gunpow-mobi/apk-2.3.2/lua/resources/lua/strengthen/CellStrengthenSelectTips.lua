--CellStrengthenSelectTips.lua
--@brief	CellStrengthenSelectTips的UI模块
--@date		2015/06/09
--@author	zsq
--@note		要选择的装备或宝石cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellStrengthenSelectTips:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellStrengthenSelectTips:onExit(element)
	self:_unInit()
end


--@brief    cell被点击时调用
function CellStrengthenSelectTips:onCellClicked(element)

end

--@brief    checkbox被点击时调用
function CellStrengthenSelectTips:onCheckBoxClick(element)
    local cellTag = self.m_root:getTag()
    local checkbox = GetElement(self.m_root,"checkboxSelect_CellStrengthenSelectTips",WZUICheckBox)
    WndSelectTipsStrengthen:cellSelected(cellTag,self.m_tItem)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    初始化宝石cell
function CellStrengthenSelectTips:_initStoneCellData()
    local tStone = self.m_tItem
    if self.m_root == nil then return end

    --宝石icon
    local conEquipNode = GetElement(self.m_root,"conIcon_CellStrengthenSelectTips",WZUIContainer)
    local equipElement,equipObj = CellGoodItem:createElement()
    if equipObj == nil or equipElement == nil then return end
    conEquipNode:addChild(equipElement)
    equipElement:setScale(0.9)
    equipObj:setCellGoodItem(tStone,4)
    --宝石名
    local txtEquipName = GetElement(self.m_root,"txtName_CellStrengthenSelectTips",WZUILabelTTF)
    txtEquipName:setText(tStone.basicInfo.name)
   	txtEquipName:setColor(QUALITYCOLOR[tStone.basicInfo.quality])
    --属性加成
    local property = tStone.basicInfo.property
    local attrName = ATTR_TITLE[property[1][1]]
    local baseAttr = property[1][2]
	if property[1][1] == 0 then
		baseAttr = baseAttr.."%"
		WZLog("共鸣宝石属性", totalAttr)
	end
    if tStone.basicInfo.main_type == 35 and tStone.basicInfo.sub_type == 4 then 
        attrName = LocalStrings.SPIRIT_ATTR
        if property[1][1] == 0 then
            baseAttr = (property[1][2] * 100 / 10000).."%"
        end
    end
    local attrString = string.format("%s+%s",attrName,baseAttr)
    if tStone.basicInfo.main_type == 35 and tStone.basicInfo.sub_type == 5 then 
        attrString = ""
        for i = 1, #property do
            if i > 1 then 
                attrString = attrString .. " "
            end            
            local strTemp = string.format("%s+%s", ATTR_TITLE[property[i][1]], property[i][2])
            attrString = attrString .. strTemp
        end
    elseif tStone.basicInfo.main_type == 46 then 
        attrString = ""
        for i = 1, #property do
            if i > 1 then 
                attrString = attrString .. " "
            end
            baseAttr = (property[i][2] * 100 / 10000).."%"            
            local strTemp = string.format("%s+%s", HVATTR_TITLE[property[i][1]], baseAttr)
            attrString = attrString .. strTemp
        end
    end
    local txtEquipAttrAdd = GetElement(self.m_root,"txtAttr_CellStrengthenSelectTips",WZUILabelTTF)
    txtEquipAttrAdd:setText(attrString)
    --显示数量
    local stoneNum = 1
    if tStone.lastNum ~= nil then
        stoneNum = tStone.lastNum
    end
    if stoneNum <= 0 then stoneNum = 1 end
    GetElement(self.m_root,"conNum_CellStrengthenSelectTips",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"txtNumWord_CellStrengthenSelectTips",WZUILabelTTF):setText(LocalStrings.NUM1 .. ":")
    GetElement(self.m_root,"txtNum_CellStrengthenSelectTips",WZUILabelTTF):setText(stoneNum)
end

--@brief    初始化装备cell
function CellStrengthenSelectTips:_initEquipCellData()
    local tEquip = self.m_tItem
    if self.m_root == nil then return end

    --装备icon
    local conEquipNode = GetElement(self.m_root,"conIcon_CellStrengthenSelectTips",WZUIContainer)
    local equipElement,equipObj = CellGoodItem:createElement()
    equipObj:setItemClickFun(self,self.onWeaponClicked)
    if equipObj == nil or equipElement == nil then return end
    conEquipNode:addChild(equipElement)
    equipElement:setScale(0.9)
    equipObj:setCellGoodItem(tEquip,1)
    equipObj:setBackImgFile("ui/common/common_scale9_beibaodi.png")
    --装备名
    local txtEquipName = GetElement(self.m_root,"txtName_CellStrengthenSelectTips",WZUILabelTTF)
    txtEquipName:setText(tEquip.basicInfo.name)
    txtEquipName:setColor(QUALITYCOLOR[tEquip.basicInfo.quality])

    local property = tEquip.basicInfo.property
    local attrName = ATTR_TITLE[property[1][1]]

    local totalAttr = tEquip.extraInfo[tostring(property[1][1])]
    local attrString = string.format("%s+%d",attrName,totalAttr)
    local txtEquipAttrAdd = GetElement(self.m_root,"txtAttr_CellStrengthenSelectTips",WZUILabelTTF)
    txtEquipAttrAdd:setText(attrString)

    --不显示数量
    GetElement(self.m_root,"conNum_CellStrengthenSelectTips",WZUIContainer):setVisible(false)
end

--@brief    初始化装备cell
function CellStrengthenSelectTips:_initSpiritCellData()
    local tEquip = self.m_tItem
    if self.m_root == nil then return end

    --装备icon
    local conEquipNode = GetElement(self.m_root,"conIcon_CellStrengthenSelectTips",WZUIContainer)
    local equipElement,equipObj = CellGoodItem:createElement()
    -- equipObj:setItemClickFun(self,self.onWeaponClicked)
    if equipObj == nil or equipElement == nil then return end
    conEquipNode:addChild(equipElement)
    equipElement:setScale(0.9)
    equipObj:setCellGoodItem(tEquip,1)
    equipObj:setBackImgFile("ui/common/common_scale9_beibaodi.png")
    --装备名
    local txtEquipName = GetElement(self.m_root,"txtName_CellStrengthenSelectTips",WZUILabelTTF)
    txtEquipName:setText(tEquip.basicInfo.name)
    txtEquipName:setColor(QUALITYCOLOR[tEquip.basicInfo.quality])

    local strDesc = ""
    for k,v in pairs(GDatatab_holiday_spirit) do
        if v.item_id == tEquip.basicInfo.id then
            local tSpiritEffect = GDatatab_holiday_spirit_effect["id_"..v.effect_id]
            strDesc = tSpiritEffect.desc
            break
        end
    end
    local txtEquipAttrAdd = GetElement(self.m_root,"txtAttr_CellStrengthenSelectTips",WZUILabelTTF)
    txtEquipAttrAdd:setText(strDesc)
    txtEquipAttrAdd:setFontSize(18)
    txtEquipAttrAdd:setDimensions(GlobalMethod:CCSize(220,0))

    --不显示数量
    GetElement(self.m_root,"conNum_CellStrengthenSelectTips",WZUIContainer):setVisible(false)
    
    AdaptLanguage(self)
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellStrengthenSelectTips:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtName_CellStrengthenSelectTips",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAttr_CellStrengthenSelectTips",WZUILabelTTF):setScale(0.8)
end

function CellStrengthenSelectTips:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtName_CellStrengthenSelectTips",WZUILabelTTF):setScale(0.8)
    local txtAttr = GetElement(self.m_root,"txtAttr_CellStrengthenSelectTips",WZUILabelTTF)
    txtAttr:setScale(0.8)
    txtAttr:setRelativePosition(GlobalMethod:ccp(0.31,0.25))
end

function CellStrengthenSelectTips:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtName_CellStrengthenSelectTips",WZUILabelTTF):setScale(0.8)
    local txtAttr = GetElement(self.m_root,"txtAttr_CellStrengthenSelectTips",WZUILabelTTF)
    txtAttr:setScale(0.75)
    txtAttr:setRelativePosition(GlobalMethod:ccp(0.31,0.25))
end

function CellStrengthenSelectTips:_adaptLanguage_vn(  )
    local txtName = GetElement(self.m_root,"txtName_CellStrengthenSelectTips",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(260,0))

    local txtAttr = GetElement(self.m_root,"txtAttr_CellStrengthenSelectTips",WZUILabelTTF)
    txtAttr:setScale(0.7)
    txtAttr:setDimensions(GlobalMethod:CCSize(320,0))
    txtAttr:setRelativePosition(GlobalMethod:ccp(0.33,0.25))
end

function CellStrengthenSelectTips:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtAttr_CellStrengthenSelectTips",WZUILabelTTF):setScale(0.8)
end

function CellStrengthenSelectTips:_adaptLanguage_ug(  )
    GetElement(self.m_root,"txtName_CellStrengthenSelectTips",WZUILabelTTF):setScale(0.8)
    local txtAttr = GetElement(self.m_root,"txtAttr_CellStrengthenSelectTips",WZUILabelTTF)
    txtAttr:setScale(0.8)
    txtAttr:setDimensions(GlobalMethod:CCSize(240))
end

function CellStrengthenSelectTips:_adaptLanguage_tr(  )
    local txtName = GetElement(self.m_root,"txtName_CellStrengthenSelectTips",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(260,0))

    GetElement(self.m_root,"txtAttr_CellStrengthenSelectTips",WZUILabelTTF):setScale(0.8)
end
------------------------------------语言适配End----------------------------------------------