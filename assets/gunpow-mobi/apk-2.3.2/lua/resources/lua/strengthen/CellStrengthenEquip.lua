--CellStrengthenEquip.lua
--@brief	CellStrengthenEquip的UI模块
--@date		2015/06/02
--@author	zsq
--@note		锻造系统装备cell


-------------------------------------公有方法模块Begin--------------------------------------
    
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellStrengthenEquip:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellStrengthenEquip:onExit(element)
	self:_unInit()
end

--@brief    cell点击时被调用
--@param	element:表绑定的UI节点引用
function CellStrengthenEquip:onCellClicked(element)
    WZLog("CellStrengthenEquip:onCellClicked", WndGradeStrengthen.m_bRunning)
    if self.m_nFuncIndex == 1 then 
        self:onCellClickedAscending()
        return 
    end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if WndStrengthen.m_nCurIndex == 4 and WndGradeStrengthen.m_bRunning == true then return end
  --   --选中了的，重复点击无效
  --   if self.m_tEquipItem.hightlight == true then
		-- WZLog("点击选中项")
  --       return 
  --   end
    TeachGroup1:endTeachStep({11,4})
    WndStrengthen:equipListCellClicked(self.m_tEquipItem)
--    WZLog("CellStrengthenEquip:onCellClicked", Serialize(self.m_tEquipItem))
    if self.m_tEquipItem and self.m_tEquipItem.extraInfo and self.m_tEquipItem.extraInfo.starLevel and self.m_tEquipItem.extraInfo.starLevel > 0 then
        TeachGroup1:setTeachFinish(10,-1)
    -- else
    --     TeachGroup1:startGroup({10,5,WndImproveStrengthen.m_root})
    end 
    TeachGroup1:startGroup({11,5,WndGemMountingStrengthen.m_root})

    if TeachGroup1.TASK_GO_ID == TeachGroup1.TASK_ID_15 then
        TeachGroup1:endTeachStep({38,1})
        TeachGroup1:startGroup({38,2,WndTransferStrengthen.m_root})
    end
end

--@brief	在升阶系统中点击Cell
function CellStrengthenEquip:onCellClickedAscending()
	WZLog("CellStrengthenEquip:onCellClickedAscending")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if WndAscending.m_bRunning == true then return end
    --选中了的，重复点击无效
    if self.m_tEquipItem.hightlight == true then
		WZLog("点击选中项")
        return 
    end
	self.m_tEquipItem.hightlight = true
	WndAscending:equipListCellClicked(self.m_tEquipItem, self)
end

--@brief	在武器洗练中点击Cell
function CellStrengthenEquip:onCellClickedSophistic() 
	WZLog("CellStrengthenEquip:onCellClickedSophistic")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --选中了的，重复点击无效
    if self.m_tEquipItem.hightlight == true then WZLog("点击选中项") return end
	if WndSophistic.m_tSelectedCell ~= nil then
		WndSophistic.m_tSelectedCell:setHighLight(false)
	end
	WndSophistic.m_tSelectedCell = self
	self:setHighLight(true)

	WndSophistic:addEquipToCell(self.m_tEquipItem)
end

--@brief    获取装备的玩家物品ID
function CellStrengthenEquip:getPlayerItemId()
    -- body
    return self.m_tEquipItem.playerItemId
end

--@brief    设置红点
function CellStrengthenEquip:setRedDot(bShow)
    if self.m_root == nil then return end
    self.m_bIsShowRed = bShow
    if not self.m_bIsLoaded then return end 
    GetElement(self.m_root,"imgRedDot_CellStrengthenEquip",WZUIImage):setVisible(bShow)
end

--@brief    加载
function CellStrengthenEquip:onLoadData(element)
    local celElement = WZUISystem:getInstance():createElement("CellStrengthenEquip")
    self.m_root:addChild(celElement)
    --更新函数
    self.m_bIsLoaded = true

    self:_update()
    AdaptLanguage(self)
end

--@brief    刷新
function CellStrengthenEquip:_update()
    tEquip = self.m_tEquipItem 
    --装备icon
    local conEquipNode = GetElement(self.m_root,"conEquipIcon_CellStrengthenEquip",WZUIContainer)
    local equipElement,equipObj = CellGoodItem:createElement()
    if equipObj == nil or equipElement == nil then return end
    equipElement:setTag(88)
    conEquipNode:addChild(equipElement)
    equipElement:setScale(1)
    equipObj:setCellGoodItem(tEquip,1)
    equipObj:setItemClickFun(self,self.onCellClicked)--设置装备点击回调
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
 --    local property = tEquip.basicInfo.property
 --    local attrName = ATTR_TITLE[property[1][1]]
 --    local totalAttr = tEquip.extraInfo[tostring(property[1][1])]
    -- local text = [[<T C="79,60,48" S="22" P="0">%s</T><T C="158,0,0" S="22" P="0"> +%d</T>]]
 --    if ProjConfig.LANGUAGE == "vn" then
 --        text = [[<T C="79,60,48" S="16" P="0">%s</T><T C="158,0,0" S="16" P="0"> +%d</T>]]
 --    elseif ProjConfig.LANGUAGE == "th"  then
 --         text = [[<T C="79,60,48" S="18" P="0">%s</T><T C="158,0,0" S="16" P="0"> +%d</T>]]
 --    elseif ProjConfig.LANGUAGE == "en" then
 --         text = [[<T C="79,60,48" S="16" P="0">%s</T><T C="158,0,0" S="16" P="0"> +%d</T>]]
 --    end
 --    local attrString = string.format(text,attrName,totalAttr)
 --    local txtEquipAttrAdd = GetElement(self.m_root,"txtEquipAdd_CellStrengthenEquip",WZUIFreeTextBox)
 --    txtEquipAttrAdd:setShowText(attrString)

    --橙装显示平级
    -- GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF):setVisible(false)
    -- if tEquip.basicInfo.quality == 4 then
    --  local value2 = GDatatab_item_orange_equi_grade["id_1"].name
    --  if tEquip.extraInfo ~= nil and tEquip.extraInfo.orangeEquiGrade ~= nil then
    --      local grade = SplitStringWithSeparator(tEquip.extraInfo.orangeEquiGrade,"|")
    --      if grade[1] ~= nil and GDatatab_item_orange_equi_grade["id_"..grade[1]] ~= nil then
    --          value2 = GDatatab_item_orange_equi_grade["id_"..grade[1]].name
    --      end
    --  end
    --  GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF):setVisible(true)
    --  GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF):setText(value2)
    -- end


    if tEquip.hightlight == true or self.m_bIsHightLight == true then
        GetElement(self.m_root,"imgHighlight_CellStrengthenEquip",WZUI9Image):setVisible(true)
    else
        GetElement(self.m_root,"imgHighlight_CellStrengthenEquip",WZUI9Image):setVisible(false)
    end

    self:setRedDot(self.m_bIsShowRed)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellStrengthenEquip:_adaptLanguage_vn()
    WZLog("CellStrengthenEquip:_adaptLanguage_vn ")
    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.6)
    txtEquipName:setDimensions(GlobalMethod:CCSize(230))
end

function CellStrengthenEquip:_adaptLanguage_pt(  )
    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.7)
    txtEquipName:setDimensions(GlobalMethod:CCSize(180))
end

function CellStrengthenEquip:_adaptLanguage_en(  )
    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.6)
    txtEquipName:setDimensions(GlobalMethod:CCSize(180,0))
end

function CellStrengthenEquip:_adaptLanguage_th()
    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.7)
end

function CellStrengthenEquip:_adaptLanguage_tr()
    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.6)
    txtEquipName:setDimensions(GlobalMethod:CCSize(100,0))
end

function CellStrengthenEquip:_adaptLanguage_es()
    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.7)
    txtEquipName:setDimensions(GlobalMethod:CCSize(160,0))
end

function CellStrengthenEquip:_adaptLanguage_hk()
end

function CellStrengthenEquip:_adaptLanguage_ug()
    local txtEquipState = GetElement(self.m_root,"txtEquipState_CellStrengthenEquip",WZUILabelTTF)
    txtEquipState:setScale(0.55)
    local txtEquipAdd = GetElement(self.m_root,"txtEquipAdd_CellStrengthenEquip",WZUIFreeTextBox)
    txtEquipAdd:setScale(0.55)
    txtEquipAdd:setMaxWidth(200)
    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.55)
    txtEquipName:setDimensions(GlobalMethod:CCSize(220,0))
    local txtPin = GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF)
    txtPin:setRelativePosition(GlobalMethod:ccp(0.77,0.68))
    txtPin:setScale(0.5)
    txtPin:setDimensions(GlobalMethod:CCSize(110))
end
-------------------------------------语言适配模块End----------------------------------------
