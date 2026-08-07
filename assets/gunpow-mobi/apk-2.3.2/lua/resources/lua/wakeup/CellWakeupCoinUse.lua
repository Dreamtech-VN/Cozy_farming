--CellWakeupCoinUse.lua
--@brief	CellWakeupCoinUse的UI模块
--@date		2017/05/24
--@author	Tianxiang_Xu
--@note		觉醒之晶的使用


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWakeupCoinUse:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWakeupCoinUse:onExit(element)
	self:_unInit()
end

--@brief    点击使用按钮回调
function CellWakeupCoinUse:onClickUse(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = self.m_root:getTag()

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], nTag)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellWakeupCoinUse:_update()
    -- body
    local basicInfo = GDatatab_item["id_" .. self.m_nItemId]
    if basicInfo == nil then return end 
    --图标
    local conIcon = GetElement(self.m_root, "conIcon_CellWakeupCoinUse", WZUIContainer)
    conIcon:removeAllChildrenWithCleanup(true)
    if conIcon then
        local element, objNew = CellGoodItem:createElement()
        if element and objNew then
            local nTempNum = CacheCenter:getPlayerItemCountById(self.m_nItemId)
            objNew:setCellGoodLocalId(self.m_nItemId, nTempNum, 4)
            objNew:setBackImgFile("ui/common/common_scale9_beibaodi.png", true)
            conIcon:addChild(element)
        end
		WZLog("设置高亮")
    end
    --名字
    local txtName = GetElement(self.m_root, "txtName_CellWakeupCoinUse", WZUILabelTTF)
    if txtName then
        txtName:setText(basicInfo.name)
        txtName:setColor(QUALITYCOLOR[basicInfo.quality])
    end

    --经验
    local nBasicExp = self:getBasicExp(self.m_nItemId)
    local ftxtExp = GetElement(self.m_root, "ftxtExp_CellWakeupCoinUse", WZUIFreeTextBox)
    if ftxtExp then
        local sContent = string.format([[<T S="20" C="255,236,193" P="1">%s</T><T S="20" C="99,255,95" P="1">+%d</T>]], LocalStrings.EXP, nBasicExp)
        ftxtExp:setShowText(sContent)
    end
end

--@brief    返回相应的基础经验
function CellWakeupCoinUse:getBasicExp(id)
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

function CellWakeupCoinUse:setLight(bool) 
	GetElement(self.m_root,"ImgLight",WZUI9Image):setVisible(bool)
end

function CellWakeupCoinUse:onClick(element) 
	WZLog("CellWakeupCoinUse:onClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if CellWakeupDetail.m_tSelected ~= nil then
		CellWakeupDetail.m_tSelected:setLight(false)
	end
	CellWakeupDetail.m_tSelected = self
	CellWakeupDetail.m_nSelM = self.m_nTag
	self:setLight(true)
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellWakeupCoinUse:_adaptLanguage_en(  )
    local txtName = GetElement(self.m_root, "txtName_CellWakeupCoinUse", WZUILabelTTF)
    txtName:setScale(0.6)
    txtName:setDimensions(GlobalMethod:CCSize(250))
end

function CellWakeupCoinUse:_adaptLanguage_pt(  )
    local txtName = GetElement(self.m_root, "txtName_CellWakeupCoinUse", WZUILabelTTF)
    txtName:setScale(0.6)
    txtName:setDimensions(GlobalMethod:CCSize(250))
end

function CellWakeupCoinUse:_adaptLanguage_es(  )
    local txtName = GetElement(self.m_root, "txtName_CellWakeupCoinUse", WZUILabelTTF)
    txtName:setScale(0.6)
    txtName:setDimensions(GlobalMethod:CCSize(250))
end

function CellWakeupCoinUse:_adaptLanguage_tr(  )
    local txtName = GetElement(self.m_root, "txtName_CellWakeupCoinUse", WZUILabelTTF)
    txtName:setScale(0.6)
    txtName:setDimensions(GlobalMethod:CCSize(250))
end
---------------------------------------语言适配End------------------------------------------
