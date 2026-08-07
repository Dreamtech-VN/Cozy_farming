--CellStrengthenEquipData.lua
--@brief	CellStrengthenEquip的数据模块
--@date		2015/06/02
--@author	zsq
--@note		锻造系统装备cell

CellStrengthenEquip = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellStrengthenEquip:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tEquipItem = nil             --装备table
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellStrengthenEquip:_unInit()
	self.m_root = nil
    self.m_tEquipItem = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellStrengthenEquip:createElement()
    local tNewObj = self:_new()
    assert(tNewObj, "CellStrengthenEquip table create failed!")
    tNewObj:_init()
    local element = WZUISystem:getInstance():createElement("CellStrengthenEquip")
    assert(element, "CellStrengthenEquip element create failed!")
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end


--@brief    初始化cell
--@param	tEquip:数据
function CellStrengthenEquip:initCellData(tEquip)
    if self.m_root == nil then return end
    self.m_tEquipItem = {}
    self.m_tEquipItem = tEquip

    --装备icon
    local conEquipNode = GetElement(self.m_root,"conEquipIcon_CellStrengthenEquip",WZUIContainer)
    local equipElement,equipObj = CellGoodItem:createElement()
    if equipObj == nil or equipElement == nil then return end
    equipElement:setTag(88)
    conEquipNode:addChild(equipElement)
    equipElement:setScale(1)
    equipObj:setCellGoodItem(tEquip,1)
    equipObj:setItemClickFun(self,self.onCellClicked)--设置装备点击回调
   	equipObj:_setRewardBg1()
    --装备名
    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setText(tEquip.basicInfo.name)
   	txtEquipName:setColor(QUALITYCOLOR[tEquip.basicInfo.quality])
    local property = tEquip.basicInfo.property
    local attrName = ATTR_TITLE[property[1][1]]
    local totalAttr = tEquip.extraInfo[tostring(property[1][1])]
	local text = [[<T C="79,60,48" S="22" P="0">%s</T><T C="158,0,0" S="22" P="0"> +%d</T>]]
    if ProjConfig.LANGUAGE == "vn" then
        text = [[<T C="79,60,48" S="16" P="0">%s</T><T C="158,0,0" S="16" P="0"> +%d</T>]]
    elseif ProjConfig.LANGUAGE == "th"  then
         text = [[<T C="79,60,48" S="18" P="0">%s</T><T C="158,0,0" S="16" P="0"> +%d</T>]]
    elseif ProjConfig.LANGUAGE == "en" then
         text = [[<T C="79,60,48" S="16" P="0">%s</T><T C="158,0,0" S="16" P="0"> +%d</T>]]
    end
    local attrString = string.format(text,attrName,totalAttr)
    local txtEquipAttrAdd = GetElement(self.m_root,"txtEquipAdd_CellStrengthenEquip",WZUIFreeTextBox)
    txtEquipAttrAdd:setShowText(attrString)
    --装备使用状态
    local txtEquipUseState = GetElement(self.m_root,"txtEquipState_CellStrengthenEquip",WZUILabelTTF)
	txtEquipUseState:setText("("..LocalStrings.EQUIPPED..")")
    if tEquip.isUse then
    	txtEquipUseState:setVisible(true)
	else
    	txtEquipUseState:setVisible(false)
    end
	GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF):setVisible(false)
	--橙装显示平级
	if tEquip.basicInfo.quality == 4 then
		local value2 = GDatatab_item_orange_equi_grade["id_1"].name
		if tEquip.extraInfo ~= nil and tEquip.extraInfo.orangeEquiGrade ~= nil then
			local grade = SplitStringWithSeparator(tEquip.extraInfo.orangeEquiGrade,"|")
			if grade[1] ~= nil and GDatatab_item_orange_equi_grade["id_"..grade[1]] ~= nil then
				value2 = GDatatab_item_orange_equi_grade["id_"..grade[1]].name
			end
		end
		GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF):setText(value2)
	end


	if tEquip.hightlight == true then
    	GetElement(self.m_root,"imgHighlight_CellStrengthenEquip",WZUI9Image):setVisible(true)
	else
    	GetElement(self.m_root,"imgHighlight_CellStrengthenEquip",WZUI9Image):setVisible(false)
	end
	if "en" == language then
		txtEquipUseState:setScale(0.8)
		if property[1][1] == 7 or property[1][1] == 8 then
			txtEquipAttrAdd:setScale(0.7)
		end
	end	
end

--@brief    重新设置cell
--@param    tEquip:数据
function CellStrengthenEquip:resetCellData(tEquip)
    if self.m_root == nil then return end
    self.m_tEquipItem = {}
    self.m_tEquipItem = tEquip

    --装备icon
    local conEquipNode = GetElement(self.m_root,"conEquipIcon_CellStrengthenEquip",WZUIContainer)
    local equipElement = conEquipNode:getChildByTag(88)
    if not equipElement then return end
    local equipObj = equipElement:getLuaObjectIndex()
    if equipObj == nil then return end
    equipObj:setCellGoodItem(tEquip,1)
    --装备名
    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setText(tEquip.basicInfo.name)
   	txtEquipName:setColor(QUALITYCOLOR[tEquip.basicInfo.quality])
    local property = tEquip.basicInfo.property
    local attrName = ATTR_TITLE[property[1][1]]
    local totalAttr = tEquip.extraInfo[tostring(property[1][1])]
    local text = [[<T C="79,60,48" S="22" P="0">%s</T><T C="158,0,0" S="22" P="0"> +%d</T>]]
    if ProjConfig.LANGUAGE == "vn" then
        text = [[<T C="79,60,48" S="16" P="0">%s</T><T C="158,0,0" S="16" P="0"> +%d</T>]]
    elseif ProjConfig.LANGUAGE == "th"  then
        text = [[<T C="79,60,48" S="18" P="0">%s</T><T C="158,0,0" S="16" P="0"> +%d</T>]]
    elseif ProjConfig.LANGUAGE == "en" then
        text = [[<T C="79,60,48" S="16" P="0">%s</T><T C="158,0,0" S="16" P="0"> +%d</T>]]
    end
    local attrString = string.format(text,attrName,totalAttr)
    local txtEquipAttrAdd = GetElement(self.m_root,"txtEquipAdd_CellStrengthenEquip",WZUIFreeTextBox)
    txtEquipAttrAdd:setShowText(attrString)
    --装备使用状态
    local txtEquipUseState = GetElement(self.m_root,"txtEquipState_CellStrengthenEquip",WZUILabelTTF)
    txtEquipUseState:setText("("..LocalStrings.EQUIPPED..")")
    if tEquip.isUse then
        txtEquipUseState:setVisible(true)
    else
        txtEquipUseState:setVisible(false)
    end
	GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF):setText("")
	--橙装显示平级
	if tEquip.basicInfo.quality == 4 then
		local value2 = GDatatab_item_orange_equi_grade["id_1"].name
		if tEquip.extraInfo ~= nil and tEquip.extraInfo.orangeEquiGrade ~= nil then
			local grade = SplitStringWithSeparator(tEquip.extraInfo.orangeEquiGrade,"|")
			if grade[1] ~= nil and GDatatab_item_orange_equi_grade["id_"..grade[1]] ~= nil then
				value2 = GDatatab_item_orange_equi_grade["id_"..grade[1]].name
			end
		end
		GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF):setText(value2)
	end


    if tEquip.hightlight == true then
        GetElement(self.m_root,"imgHighlight_CellStrengthenEquip",WZUI9Image):setVisible(true)
    else
        GetElement(self.m_root,"imgHighlight_CellStrengthenEquip",WZUI9Image):setVisible(false)
    end
end

--@brief	设置是否高亮
function CellStrengthenEquip:setHighLight(bool)
	if self.m_root == nil then return end
    GetElement(self.m_root,"imgHighlight_CellStrengthenEquip",WZUI9Image):setVisible(bool)
	self.m_tEquipItem.hightlight = bool
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@param	新建的表实例对象
function CellStrengthenEquip:_new( )
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
