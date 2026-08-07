--CellWakeupSy.lua
--@brief	CellWakeupSy的UI模块
--@date		2017/05/24
--@author	Tianxiang_Xu
--@note		觉醒之晶的使用


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWakeupSy:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWakeupSy:onExit(element)
	self:_unInit()
end

function CellWakeupSy:onClick(element) 
	WZLog("CellWakeupSy:onClick", self.myName)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndExtraction:onClickListItem(self, self.m_root:getTag(), self.m_tItem)
end

function CellWakeupSy:setItemNumber(nNumber)
	WZLog("CellWakeupSy:setItemNumber", nNumber)
	self.m_tCell:setItemNumber(nNumber)
	if self.m_tCell.m_txtCount ~= nil then
		self.m_tCell.m_txtCount:setVisible(true)
	end
end

function CellWakeupSy:removeAllChild()
	WZLog("CellWakeupSy:removeAllChild")
	if self.m_tCell.m_txtCount ~= nil then
		self.m_tCell.m_txtCount:setVisible(false)
	end
end

function CellWakeupSy:setFromTag(tag)
	self.m_tCell.m_nFromTag = tag
end

function CellWakeupSy:setQuality()

end

function CellWakeupSy:setConItemVisible()
	
end

function CellWakeupSy:setHighLight(bool) 
	WZLog("CellWakeupSy:setHighLight", self.myName)
	GetElement(self.m_root,"ImgLight",WZUI9Image):setVisible(bool)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellWakeupSy:_update()
    -- body
    local basicInfo = self.m_tItem.basicInfo
    if basicInfo == nil then return end 
    --图标
    local conIcon = GetElement(self.m_root, "conIcon_CellWakeupSy", WZUIContainer)
    conIcon:removeAllChildrenWithCleanup(true)
    if conIcon then
        local element, objNew = CellGoodItem:createElement()
        if element and objNew then
            local nTempNum = CacheCenter:getPlayerItemCountById(basicInfo.id)
            objNew:setCellGoodLocalId(basicInfo.id, nTempNum, 4)

            conIcon:addChild(element)
        end
		self.m_tCell = objNew
    end
    --名字
    local txtName = GetElement(self.m_root, "txtName_CellWakeupSy", WZUILabelTTF)
    if txtName then
        txtName:setText(basicInfo.name)
        txtName:setColor(QUALITYCOLOR[basicInfo.quality])
    end

    --经验
    local nBasicExp = self:getBasicExp(basicInfo.id)
    local ftxtExp = GetElement(self.m_root, "ftxtExp_CellWakeupSy", WZUIFreeTextBox)
    if ftxtExp then
        local sContent = string.format([[<T S="22" C="79,60,48" P="1">%s</T><T S="22" C="5,180,0" P="1">+%d</T>]], LocalStrings.EXP, nBasicExp)
        ftxtExp:setShowText(sContent)
    end
end

--@brief    返回相应的基础经验
function CellWakeupSy:getBasicExp(id)
    -- body
    local nBasicExp = 0 
    if id == 500 then
        local sTempExp = string.sub(CacheCenter:getGameParam()["awakeCrystal0"],2,-2)
        local tTempExp = SplitStringWithSeparator(sTempExp, ",")
        nBasicExp = tonumber(tTempExp[2])
    elseif id == 501 then
        local sTempExp = string.sub(CacheCenter:getGameParam()["awakeCrystal1"],2,-2)
        local tTempExp = SplitStringWithSeparator(sTempExp, ",")
        nBasicExp = tonumber(tTempExp[2])
    elseif id == 502 then
        local sTempExp = string.sub(CacheCenter:getGameParam()["awakeCrystal2"],2,-2)
        local tTempExp = SplitStringWithSeparator(sTempExp, ",")
        nBasicExp = tonumber(tTempExp[2])
    elseif id == 503 then
        local sTempExp = string.sub(CacheCenter:getGameParam()["awakeCrystal3"],2,-2)
        local tTempExp = SplitStringWithSeparator(sTempExp, ",")
        nBasicExp = tonumber(tTempExp[2])
    end

    return nBasicExp 
end

-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function CellWakeupSy:_adaptLanguage_th(  )
    GetElement(self.m_root, "txtName_CellWakeupSy", WZUILabelTTF):setScale(0.7)
end

function CellWakeupSy:_adaptLanguage_en(  )
    local txtName = GetElement(self.m_root, "txtName_CellWakeupSy", WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(200))
end

function CellWakeupSy:_adaptLanguage_pt(  )
    local txtName = GetElement(self.m_root, "txtName_CellWakeupSy", WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(200))
end

function CellWakeupSy:_adaptLanguage_es(  )
    local txtName = GetElement(self.m_root, "txtName_CellWakeupSy", WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(200))
end

function CellWakeupSy:_adaptLanguage_tr(  )
    local txtName = GetElement(self.m_root, "txtName_CellWakeupSy", WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(200))
end
---------------------------------------语言适配End------------------------------------------