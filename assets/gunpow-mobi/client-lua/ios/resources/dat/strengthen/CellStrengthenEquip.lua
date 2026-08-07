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
    AdaptLanguage(self)
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
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if WndStrengthen.m_nCurIndex == 4 and WndGradeStrengthen.m_bRunning == true then return end
    --选中了的，重复点击无效
    if self.m_tEquipItem.hightlight == true then
		WZLog("点击选中项")
        return 
    end
    TeachGroup1:endTeachStep({9,3},{10,4},{11,4},{37,4})
    WndStrengthen:equipListCellClicked(self.m_tEquipItem)
    TeachGroup1:startGroup({9,5,WndIntensifyStrengthen.m_root})
    TeachGroup1:startGroup({10,5,WndImproveStrengthen.m_root})
    TeachGroup1:startGroup({11,5,WndGemMountingStrengthen.m_root})
    --TeachGroup1:startGroup({37,5,WndSophisticStrengthen.m_root})

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
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellStrengthenEquip:_adaptLanguage_vn()
    WZLog("CellStrengthenEquip:_adaptLanguage_vn ")
    local txtEquipState = GetElement(self.m_root,"txtEquipState_CellStrengthenEquip",WZUILabelTTF)
    txtEquipState:setFontSize(14)
    txtEquipState:setRelativePosition(GlobalMethod:ccp(0.72,0.265))

    local txtPin = GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF)
    txtPin:setRelativePosition(GlobalMethod:ccp(0.82,0.68))
    txtPin:setScale(0.6)

    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.6)
    txtEquipName:setDimensions(GlobalMethod:CCSize(230))
    GetElement(self.m_root,"txtEquipAdd_CellStrengthenEquip",WZUIFreeTextBox):setScale(0.8)
end

function CellStrengthenEquip:_adaptLanguage_pt(  )
    local txtEquipState = GetElement(self.m_root,"txtEquipState_CellStrengthenEquip",WZUILabelTTF)
    txtEquipState:setFontSize(12)
    txtEquipState:setRelativePosition(GlobalMethod:ccp(0.77,0.265))
    local txtEquipAdd = GetElement(self.m_root,"txtEquipAdd_CellStrengthenEquip",WZUIFreeTextBox)
    txtEquipAdd:setRelativePosition(GlobalMethod:ccp(0.33,0.26))
    txtEquipAdd:setScale(0.7)

    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.7)
    txtEquipName:setDimensions(GlobalMethod:CCSize(180))
    local txtPin = GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF)
    txtPin:setRelativePosition(GlobalMethod:ccp(0.773955,0.68))
    txtPin:setScale(0.7)
    txtPin:setDimensions(GlobalMethod:CCSize(80))
end

function CellStrengthenEquip:_adaptLanguage_en(  )
    local txtEquipAdd = GetElement(self.m_root,"txtEquipAdd_CellStrengthenEquip",WZUIFreeTextBox)
    txtEquipAdd:setScale(0.8)
    
    local txtEquipState = GetElement(self.m_root,"txtEquipState_CellStrengthenEquip",WZUILabelTTF)
    txtEquipState:setScale(0.6)
    txtEquipState:setRelativePosition(GlobalMethod:ccp(0.835454,0.265))

    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.6)
    txtEquipName:setDimensions(GlobalMethod:CCSize(180,0))
    local txtPin = GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF)
    txtPin:setRelativePosition(GlobalMethod:ccp(0.74,0.68))
    txtPin:setScale(0.56)
    txtPin:setDimensions(GlobalMethod:CCSize(80))

    local txtEquipState = GetElement(self.m_root,"txtEquipState_CellStrengthenEquip",WZUILabelTTF)
    txtEquipState:setRelativePosition(GlobalMethod:ccp(0.78,0.265))
    txtEquipState:setScale(0.6)

end

function CellStrengthenEquip:_adaptLanguage_th()
    local txtEquipState = GetElement(self.m_root,"txtEquipState_CellStrengthenEquip",WZUILabelTTF)
    txtEquipState:setFontSize(12)
    txtEquipState:setRelativePosition(GlobalMethod:ccp(0.78,0.265))

    local txtPin = GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF)
    txtPin:setScale(0.7)
    txtPin:setRelativePosition(GlobalMethod:ccp(0.78,0.68))
    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.7)
end

function CellStrengthenEquip:_adaptLanguage_tr()
    local txtEquipState = GetElement(self.m_root,"txtEquipState_CellStrengthenEquip",WZUILabelTTF)
    txtEquipState:setFontSize(16)
    txtEquipState:setRelativePosition(GlobalMethod:ccp(0.78,0.265))

    local txtEquipAdd = GetElement(self.m_root,"txtEquipAdd_CellStrengthenEquip",WZUIFreeTextBox)
    txtEquipAdd:setScale(0.7)


    local txtPin = GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF)
    txtPin:setScale(0.6)
    txtPin:setDimensions(GlobalMethod:CCSize(90,0))
    txtPin:setRelativePosition(GlobalMethod:ccp(0.77,0.68))

    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.6)
    txtEquipName:setDimensions(GlobalMethod:CCSize(100,0))
end

function CellStrengthenEquip:_adaptLanguage_es()
    local txtEquipState = GetElement(self.m_root,"txtEquipState_CellStrengthenEquip",WZUILabelTTF)
    txtEquipState:setScale(0.6)
    txtEquipState:setRelativePosition(GlobalMethod:ccp(0.815454,0.265))

    local txtEquipAdd = GetElement(self.m_root,"txtEquipAdd_CellStrengthenEquip",WZUIFreeTextBox)
    txtEquipAdd:setScale(0.6)

    local txtEquipName = GetElement(self.m_root,"txtEquipName_CellStrengthenEquip",WZUILabelTTF)
    txtEquipName:setScale(0.7)
    txtEquipName:setDimensions(GlobalMethod:CCSize(160,0))

    local txtPin = GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF)
    txtPin:setScale(0.7)
    txtPin:setDimensions(GlobalMethod:CCSize(90,0))
    txtPin:setRelativePosition(GlobalMethod:ccp(0.732154,0.68))
end

function CellStrengthenEquip:_adaptLanguage_hk()
    local txtPin = GetElement(self.m_root,"txtPin_CellStrengthenEquip",WZUILabelTTF)
    txtPin:setRelativePosition(GlobalMethod:ccp(0.78,0.68))
    txtPin:setScale(0.8)
end
-------------------------------------语言适配模块End----------------------------------------
