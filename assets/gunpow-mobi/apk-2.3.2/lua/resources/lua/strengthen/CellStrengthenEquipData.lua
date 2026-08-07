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
    self.m_bIsLoaded = false 
    self.m_nFuncIndex = 0               --
    self.m_bIsHightLight = false 
    self.m_bIsShowRed = false 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellStrengthenEquip:_unInit()
	self.m_root = nil
    self.m_tEquipItem = nil
    self.m_bIsLoaded = nil 
    self.m_nFuncIndex = nil               --
    self.m_bIsHightLight = nil 
    self.m_bIsShowRed = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellStrengthenEquip:createElement()
    local tNewObj = self:_new()
    assert(tNewObj, "CellStrengthenEquip table create failed!")
    tNewObj:_init()

    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellStrengthenEquip")
    element:setAbsContentSize(GlobalMethod:CCSize(124, 178))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end


--@brief    初始化cell
--@param	tEquip:数据
function CellStrengthenEquip:initCellData(tEquip, nFuncIndex)
    self.m_tEquipItem = {}
    self.m_tEquipItem = tEquip
    self.m_nFuncIndex = nFuncIndex or 0
    if self.m_bIsLoaded == false then return end
    WZLog("CellStrengthenEquip:initCellData", Serialize(tEquip))
    
    self:_update()
end

--@brief    重新设置cell
--@param    tEquip:数据
function CellStrengthenEquip:resetCellData(tEquip)
    self.m_tEquipItem = {}
    self.m_tEquipItem = tEquip
    if self.m_bIsLoaded == false then return end

    --装备icon
    local conEquipNode = GetElement(self.m_root,"conEquipIcon_CellStrengthenEquip",WZUIContainer)
    local equipElement = conEquipNode:getChildByTag(88)
    if not equipElement then return end
    local equipObj = equipElement:getLuaObjectIndex()
    if equipObj == nil then return end
    equipObj:setCellGoodItem(tEquip,1)
    equipObj:_setBgImgVisible(false)
    equipObj:clearItemQualityPic(false)
    equipObj:setStarLevelVisible(false, false, false, false, false)
    equipObj:_showStone(-0.22, -0.31)
    --装备名
    local imgQualityRect = GetElement(self.m_root, "imgQualityRect_CellStrengthenEquip", WZUI9Image)
    local imgNameBg = GetElement(self.m_root, "imgNameBg_CellStrengthenEquip", WZUI9Image)
    imgQualityRect:setFile(g_tQualityBG[tEquip.basicInfo.quality])
    imgNameBg:setFile(g_tQualityNameBG[tEquip.basicInfo.quality])
    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setText(tEquip.basicInfo.name)
    --星级
    local txtStarLv = GetElement(self.m_root, "txtStarLv_CellStrengthenEquip", WZUILabelTTF)
    if txtStarLv then 
        txtStarLv:setText(tEquip.extraInfo.starLevel)
    end
    local imgStar = GetElement(self.m_root, "imgStar_CellStrengthenEquip", WZUIImage)
    if tEquip.extraInfo.starLevel >= 13 then 
        imgStar:setFile("ui/common/common_icon_xingxing2_h.png")
    end
    --强化等级
    local txtEquipLv = GetElement(self.m_root, "txtEquipLv_CellStrengthenEquip", WZUILabelTTF)
    if txtEquipLv then 
        if tEquip.extraInfo.strongLevel > 0 then 
            txtEquipLv:setText("+" .. tEquip.extraInfo.strongLevel)
        else
            txtEquipLv:setText("")
        end
    end
    -- local property = tEquip.basicInfo.property
    -- local attrName = ATTR_TITLE[property[1][1]]
    -- local totalAttr = tEquip.extraInfo[tostring(property[1][1])]
    -- local text = [[<T C="127,70,26" S="22" P="0">%s</T><T C="229,105,22" S="22" P="0"> +%d</T>]]
    -- if ProjConfig.LANGUAGE == "vn" then
    --     text = [[<T C="127,70,26" S="16" P="0">%s</T><T C="229,105,22" S="16" P="0"> +%d</T>]]
    -- elseif ProjConfig.LANGUAGE == "th"  then
    --     text = [[<T C="127,70,26" S="18" P="0">%s</T><T C="229,105,22" S="16" P="0"> +%d</T>]]
    -- elseif ProjConfig.LANGUAGE == "en" then
    --     text = [[<T C="127,70,26" S="16" P="0">%s</T><T C="229,105,22" S="16" P="0"> +%d</T>]]
    -- end
    -- local attrString = string.format(text,attrName,totalAttr)
    -- local txtEquipAttrAdd = GetElement(self.m_root,"txtEquipAdd_CellStrengthenEquip",WZUIFreeTextBox)
    -- txtEquipAttrAdd:setShowText(attrString)
	--橙装显示平级
	-- GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF):setText("")
	-- if tEquip.basicInfo.quality == 4 then
	-- 	local value2 = GDatatab_item_orange_equi_grade["id_1"].name
	-- 	if tEquip.extraInfo ~= nil and tEquip.extraInfo.orangeEquiGrade ~= nil then
	-- 		local grade = SplitStringWithSeparator(tEquip.extraInfo.orangeEquiGrade,"|")
	-- 		if grade[1] ~= nil and GDatatab_item_orange_equi_grade["id_"..grade[1]] ~= nil then
	-- 			value2 = GDatatab_item_orange_equi_grade["id_"..grade[1]].name
	-- 		end
	-- 	end
	-- 	GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF):setVisible(true)
	-- 	GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF):setText(value2)
	-- end


    if tEquip.hightlight == true or self.m_bIsHightLight == true then
        GetElement(self.m_root,"imgHighlight_CellStrengthenEquip",WZUI9Image):setVisible(true)
    else
        GetElement(self.m_root,"imgHighlight_CellStrengthenEquip",WZUI9Image):setVisible(false)
    end
end

--@brief	设置是否高亮
function CellStrengthenEquip:setHighLight(bool)
    self.m_bIsHightLight = bool
	if self.m_bIsLoaded == false then return end
    if self.m_root == nil then return end

    GetElement(self.m_root,"imgHighlight_CellStrengthenEquip",WZUI9Image):setVisible(bool)
	self.m_tEquipItem.hightlight = bool
end

--@brief    获得装备数据
function CellStrengthenEquip:getEquipItem()
    return self.m_tEquipItem
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
