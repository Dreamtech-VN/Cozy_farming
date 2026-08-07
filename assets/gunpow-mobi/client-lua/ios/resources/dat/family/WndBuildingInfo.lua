--WndBuildingInfo.lua
--@brief	WndBuildingInfo的UI模块
--@date		2017/07/30
--@author	Tianxiang_Xu
--@note		建筑信息界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBuildingInfo:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBuildingInfo:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndBuildingInfo:onEnterTransitionDidFinish(element)
    -- body
    if self.m_nType == 2 then
        self:_update2()
    else
        self:_update()
    end
    AdaptLanguage(self)
end

--@brief    点击关闭按钮回调
function WndBuildingInfo:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    if self.m_nType == 2 then
        WndKidOperate.m_bIsClickFunc = false
    else
        WndFamilyOperate.m_bIsClickFunc = false
    end
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function WndBuildingInfo:_update()
    -- body
    local tData = self.m_tBuildingData 
    local txtTitle = GetElement(self.m_root, "txtTitle_WndBuildingInfo", WZUILabelTTF)
    if txtTitle then 
        txtTitle:setText(tData.basicInfo.name .. "(" .. tData.basicData.level .. LocalStrings.LEVEL1 .. ")")
    end
    local conForBuilding = GetElement(self.m_root, "conForBuilding_WndBuildingInfo", WZUIContainer)
    if conForBuilding then
        local celElement, tNewObj = CellFamilyBuilding:createElement()
        if celElement and tNewObj then
            tNewObj:setBuildingData(tData, 1)
            tNewObj:setBuildingBG()
            tNewObj:setBuildingTouch(false)
            if tData.basicData.type == 0 and tData.basicData.sub_type == 0 then 
                celElement:setScale(0.7)
            elseif tData.basicData.type == 1 and tData.basicData.sub_type == 7 then 
                celElement:setScale(0.31)
            end
            conForBuilding:addChild(celElement)
        end
    end
    if tData.basicData.type == 1 and (tData.basicData.sub_type == 1 or tData.basicData.sub_type == 2 or tData.basicData.sub_type == 3)then 
        GetElement(self.m_root, "conForInfo_WndBuildingInfo", WZUIContainer):setVisible(true)
    else
        GetElement(self.m_root, "conForInfo_WndBuildingInfo", WZUIContainer):setVisible(false)
    end
    --名字
    local sFormat = [[<T C="255,255,255" S="16" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,255,255" S="16" P="1" SC="79,60,48" SE="1" SS="4">%s</T>]]
    --
    local ftxtSpeed = GetElement(self.m_root, "ftxtSpeed_WndBuildingInfo", WZUIFreeTextBox)
    local imgTypeIcon1 = GetElement(self.m_root, "imgTypeIcon1_WndBuildingInfo", WZUIImage)
    local prgCurrent1 = GetElement(self.m_root, "prgCurrent1_WndBuildingInfo", WZUIProgress)
    local waterNum, stoneNum = 0, 0
    if tData.basicData.type == 1 and tData.basicData.sub_type == 3 then 
        waterNum, stoneNum = SceneFamily:getWarehouseTotalNum()
    end
    if ftxtSpeed then
        if tData.basicData.type == 1 and (tData.basicData.sub_type == 1 or tData.basicData.sub_type == 2) then 
            imgTypeIcon1:setFile(GDatatab_item["id_" .. tData.basicData.functions[1][2]].icon)
            imgTypeIcon1:setScale(0.6)
            prgCurrent1:setPercentage(math.floor(100 * tData.currentNum / tData.basicData.functions[1][4]))
            ftxtSpeed:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT12, tData.currentNum .. "/" .. tData.basicData.functions[1][4]))
        elseif tData.basicData.type == 1 and tData.basicData.sub_type == 3 then 
            local coinInfo = GDatatab_item["id_" .. tData.basicData.functions[2][2]]
            imgTypeIcon1:setFile(coinInfo.icon)
            imgTypeIcon1:setScale(0.6)
            local coinNum1 = CacheCenter:getPlayerItemCountById(tData.basicData.functions[2][2])
            local nTotalNum = waterNum
            local sName = LocalStrings.FAMILY_TEXT25
            if tData.basicData.functions[2][2] == 67 then 
                nTotalNum = stoneNum
                sName = LocalStrings.FAMILY_TEXT26
            end
            prgCurrent1:setPercentage(math.floor(100 * coinNum1 / nTotalNum))
            ftxtSpeed:setShowText(string.format(sFormat, sName .. ":", coinNum1 .. "/" .. nTotalNum))
        end
    end
    local ftxtMaxNum = GetElement(self.m_root, "ftxtMaxNum_WndBuildingInfo", WZUIFreeTextBox)
    local imgTypeIcon2 = GetElement(self.m_root, "imgTypeIcon2_WndBuildingInfo", WZUIImage)
    local prgCurrent2 = GetElement(self.m_root, "prgCurrent2_WndBuildingInfo", WZUIProgress)
    if ftxtMaxNum then
        if tData.basicData.type == 1 and (tData.basicData.sub_type == 1 or tData.basicData.sub_type == 2) then 
            imgTypeIcon2:setFile(GDatatab_item["id_" .. tData.basicData.functions[1][2]].icon)
            imgTypeIcon2:setScale(0.6)
            ftxtMaxNum:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT13, tData.basicData.functions[1][3] .. "/" .. LocalStrings.HOUR1))
        elseif tData.basicData.type == 1 and tData.basicData.sub_type == 3 then 
            local coinInfo = GDatatab_item["id_" .. tData.basicData.functions[1][2]]
            imgTypeIcon2:setFile(coinInfo.icon)
            imgTypeIcon2:setScale(0.6)
            local coinNum2 = CacheCenter:getPlayerItemCountById(tData.basicData.functions[1][2])
            local nTotalNum = waterNum
            local sName = LocalStrings.FAMILY_TEXT25
            if tData.basicData.functions[1][2] == 67 then 
                nTotalNum = stoneNum
                sName = LocalStrings.FAMILY_TEXT26
            end
            prgCurrent2:setPercentage(math.floor(100 * coinNum2 / nTotalNum))
            ftxtMaxNum:setShowText(string.format(sFormat, sName .. ":", coinNum2 .. "/" .. nTotalNum))
        end
    end
    --描述
    local txtDesc = GetElement(self.m_root, "txtDesc_WndBuildingInfo", WZUILabelTTF)
    if txtDesc then
        txtDesc:setText(tData.basicInfo.desc)
    end
end

--@brief    刷新小家建筑
function WndBuildingInfo:_update2()
    -- body
    local tData = self.m_tBuildingData 
    local txtTitle = GetElement(self.m_root, "txtTitle_WndBuildingInfo", WZUILabelTTF)
    if txtTitle then 
        txtTitle:setText(tData.basicInfo.name)
    end
    local conForBuilding = GetElement(self.m_root, "conForBuilding_WndBuildingInfo", WZUIContainer)
    if conForBuilding then
        local celElement, tNewObj = CellKidBuilding:createElement()
        if celElement and tNewObj then
            tNewObj:setBuildingData(tData, 1)
            tNewObj:setBuildingBG()
            tNewObj:setBuildingTouch(false)
            if tData.basicData.type == 2 then
                celElement:setRelativePosition(GlobalMethod:ccp(0.5, 0.35))
            else
                celElement:setRelativePosition(GlobalMethod:ccp(0.5, 0.4))
            end
            conForBuilding:addChild(celElement)
        end
    end
    
    GetElement(self.m_root, "conForInfo_WndBuildingInfo", WZUIContainer):setVisible(false)
    --描述
    local txtDesc = GetElement(self.m_root, "txtDesc_WndBuildingInfo", WZUILabelTTF)
    if txtDesc then
        txtDesc:setText(tData.basicInfo.desc)
    end
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndBuildingInfo:_adaptLanguage_pt(  )
    GetElement(self.m_root, "txtTitle_WndBuildingInfo", WZUILabelTTF):setScale(0.7)

    local ftxtSpeed = GetElement(self.m_root, "ftxtSpeed_WndBuildingInfo", WZUIFreeTextBox)
    ftxtSpeed:setScale(0.8)
    local ftxtMaxNum = GetElement(self.m_root, "ftxtMaxNum_WndBuildingInfo", WZUIFreeTextBox)
    ftxtMaxNum:setScale(0.8)

    local txtDesc = GetElement(self.m_root, "txtDesc_WndBuildingInfo", WZUILabelTTF)
    txtDesc:setScale(0.8)
    txtDesc:setDimensions(GlobalMethod:CCSize(530))
end

function WndBuildingInfo:_adaptLanguage_es(  )
    GetElement(self.m_root, "txtTitle_WndBuildingInfo", WZUILabelTTF):setScale(0.7)

    local ftxtSpeed = GetElement(self.m_root, "ftxtSpeed_WndBuildingInfo", WZUIFreeTextBox)
    ftxtSpeed:setScale(0.8)
    local ftxtMaxNum = GetElement(self.m_root, "ftxtMaxNum_WndBuildingInfo", WZUIFreeTextBox)
    ftxtMaxNum:setScale(0.8)

    local txtDesc = GetElement(self.m_root, "txtDesc_WndBuildingInfo", WZUILabelTTF)
    txtDesc:setScale(0.8)
    txtDesc:setDimensions(GlobalMethod:CCSize(530))
end

function WndBuildingInfo:_adaptLanguage_tr(  )
    GetElement(self.m_root, "txtTitle_WndBuildingInfo", WZUILabelTTF):setScale(0.7)

    local ftxtSpeed = GetElement(self.m_root, "ftxtSpeed_WndBuildingInfo", WZUIFreeTextBox)
    ftxtSpeed:setScale(0.8)
    local ftxtMaxNum = GetElement(self.m_root, "ftxtMaxNum_WndBuildingInfo", WZUIFreeTextBox)
    ftxtMaxNum:setScale(0.8)

    local txtDesc = GetElement(self.m_root, "txtDesc_WndBuildingInfo", WZUILabelTTF)
    txtDesc:setScale(0.8)
    txtDesc:setDimensions(GlobalMethod:CCSize(530))
end

function WndBuildingInfo:_adaptLanguage_en(  )
    GetElement(self.m_root, "txtTitle_WndBuildingInfo", WZUILabelTTF):setScale(0.7)

    local ftxtSpeed = GetElement(self.m_root, "ftxtSpeed_WndBuildingInfo", WZUIFreeTextBox)
    ftxtSpeed:setScale(0.8)
    local ftxtMaxNum = GetElement(self.m_root, "ftxtMaxNum_WndBuildingInfo", WZUIFreeTextBox)
    ftxtMaxNum:setScale(0.8)

    local txtDesc = GetElement(self.m_root, "txtDesc_WndBuildingInfo", WZUILabelTTF)
    txtDesc:setScale(0.8)
    txtDesc:setDimensions(GlobalMethod:CCSize(530))
end
--------------------------------------语言适配End-----------------------------------------