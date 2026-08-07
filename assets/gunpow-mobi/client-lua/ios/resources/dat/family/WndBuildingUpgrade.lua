--WndBuildingUpgrade.lua
--@brief	WndBuildingUpgrade的UI模块
--@date		2017/07/25
--@author	Tianxiang_Xu
--@note		家园建筑升级窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBuildingUpgrade:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBuildingUpgrade:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndBuildingUpgrade:onEnterTransitionDidFinish(element)
    -- body
    self:_update()
end

--@brief    点击升级按钮回调
function WndBuildingUpgrade:onUpgrade(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nFreeButlerNum = SceneFamily:getFreeButlerNum()
    local nTotalButlerNum = SceneFamily:getButlerNum()

    if nFreeButlerNum == 0 then
        if nTotalButlerNum == 0 then 
            MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT19)
            return 
        else
            MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT28)
            -- local tTempData = SceneFamily:getMinCDTimeBuildingData()
            -- local nCostValue = tTempData.basicData.speedup_price[1][2] * math.ceil(tTempData.countdown/60)
            -- local tCostBasicData = GDatatab_item["id_" .. tTempData.basicData.speedup_price[1][1]]

            -- MsgBoxManager:showConfirmBox(string.format(LocalStrings.FAMILY_TEXT8, nCostValue, tCostBasicData.name), self, self.sureToFreeOneButler)
            -- --关闭升级界面
            -- WindowManager:removeWindow(self.m_root, self, true)
            return 
        end
    end

    local tData = self.m_tBuildingData
    --判断消耗的货币是否充足
    if not JudgeMoneyIsEnough(tData.basicData.upgrade_cost[1][1], tData.basicData.upgrade_cost[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamond) then 
        return 
    end

    self:sureToUseDiamond()
end

--@brief    确定用钻石代替粉钻升级
function WndBuildingUpgrade:sureToUseDiamond()
    -- body
    --发送升级协议升级
    SceneFamily:_toUpgrade(self.m_tBuildingData)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击关闭按钮回调
function WndBuildingUpgrade:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WndFamilyOperate.m_bIsClickFunc = false
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    佣人不够确认用货币消除一个时间，空出佣人
function WndBuildingUpgrade:sureToFreeOneButler()
    -- body
    local tTempData = SceneFamily:getMinCDTimeBuildingData()
    local nCostValue = tTempData.basicData.speedup_price[1][2] * math.ceil(tTempData.countdown/60)
    if not JudgeMoneyIsEnough(tTempData.basicData.speedup_price[1][1], nCostValue, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamondToFreeButler) then
        return 
    end

    self:sureToUseDiamondToFreeButler()
end

--@brief    确定用钻石代替礼钻释放一个佣人
function WndBuildingUpgrade:sureToUseDiamondToFreeButler()
    -- body
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新信息
function WndBuildingUpgrade:_update()
    -- body
    local tData = self.m_tBuildingData
    local conBuilding1 = GetElement(self.m_root, "conBuilding1_WndBuildingUpgrade", WZUIContainer)
    if conBuilding1 then
        local celElement, tNewObj = CellFamilyBuilding:createElement()
        if celElement and tNewObj then
            tNewObj:setBuildingData(tData, 1)
            tNewObj:setBuildingBG()
            tNewObj:setBuildingTouch(false)
            if tData.basicData.type == 1 and tData.basicData.sub_type == 7 then
                celElement:setScale(0.41)
            end
            conBuilding1:addChild(celElement)
        end
    end
    local txtLevel1 = GetElement(self.m_root, "txtLevel1_WndBuildingUpgrade", WZUILabelTTF)
    if txtLevel1 then
        txtLevel1:setText("Lv" .. tData.basicData.level)
    end
    --下一等级建筑
    local tNextData = {}
    tNextData.configId = tData.configId
    tNextData.buildingStatus = tData.buildingStatus
    tNextData.countdown = tData.countdown
    tNextData.productItemId = 0 
    tNextData.currentNum = 0 
    tNextData.flipStatus = 0 
    tNextData.basicData = GDatatab_home_building["id_" .. tData.basicData.post_id]
    tNextData.basicInfo = GDatatab_item["id_" .. tData.basicData.post_id]
    tNextData.indexX = 1 
    tNextData.indexY = 1
    tNextData.tempIndexX = 1
    tNextData.tempIndexY = 1

    local conBuilding2 = GetElement(self.m_root, "conBuilding2_WndBuildingUpgrade", WZUIContainer)
    if conBuilding2 then
        local celElement, tNewObj = CellFamilyBuilding:createElement()
        if celElement and tNewObj then
            tNewObj:setBuildingData(tNextData, 1)
            tNewObj:setBuildingBG()
            tNewObj:setBuildingTouch(false)
            if tData.basicData.type == 1 and tData.basicData.sub_type == 7 then
                celElement:setScale(0.41)
            end
            conBuilding2:addChild(celElement)
        end
    end
    local txtLevel2 = GetElement(self.m_root, "txtLevel2_WndBuildingUpgrade", WZUILabelTTF)
    if txtLevel2 then
        txtLevel2:setText("Lv" .. tNextData.basicData.level)
    end

    self:_showDifferentProperty(tData, tNextData)
    --设置按钮状态
    self:_setBtnState(tData)
end

--@brief    显示变化的数据
function WndBuildingUpgrade:_showDifferentProperty(tData, tNextData)
    -- body
    local sFormat = [[<T C="255,255,255" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,255,255" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T>]]
 
    local ftxtProperty11 = GetElement(self.m_root, "ftxtProperty11_WndBuildingUpgrade", WZUIFreeTextBox)
    if ftxtProperty11 then 
        if tData.basicData.type == 1 and (tData.basicData.sub_type == 1 or tData.basicData.sub_type == 2) then 
            ftxtProperty11:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT12, tData.basicData.functions[1][4]))
        elseif tData.basicData.type == 1 and tData.basicData.sub_type == 3 then 
            ftxtProperty11:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT15, tData.basicData.functions[2][3]))
        elseif tData.basicData.type == 1 and (tData.basicData.sub_type == 5 or tData.basicData.sub_type == 6 or tData.basicData.sub_type == 7) then 
            ftxtProperty11:setRelativePosition(GlobalMethod:ccp(0.03,0.16))
            ftxtProperty11:setShowText(string.format(sFormat, tData.basicData.desc, ""))
        end
    end

    local ftxtProperty12 = GetElement(self.m_root, "ftxtProperty12_WndBuildingUpgrade", WZUIFreeTextBox)
    if ftxtProperty12 then 
        if tData.basicData.type == 1 and (tData.basicData.sub_type == 1 or tData.basicData.sub_type == 2) then 
            ftxtProperty12:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT13, tData.basicData.functions[1][3] .. "/" .. LocalStrings.HOUR1))
        elseif tData.basicData.type == 1 and tData.basicData.sub_type == 3 then 
            ftxtProperty12:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT14, tData.basicData.functions[1][3]))
        end
    end
    --下一级属性
    local ftxtProperty21 = GetElement(self.m_root, "ftxtProperty21_WndBuildingUpgrade", WZUIFreeTextBox)
    if ftxtProperty21 then 
        if tNextData.basicData.type == 0 and tNextData.basicData.sub_type == 0 then
            ftxtProperty21:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT22, ""))
        elseif tNextData.basicData.type == 1 and (tNextData.basicData.sub_type == 1 or tNextData.basicData.sub_type == 2) then 
            ftxtProperty21:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT12, tNextData.basicData.functions[1][4]))
        elseif tNextData.basicData.type == 1 and tNextData.basicData.sub_type == 3 then 
            ftxtProperty21:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT15, tNextData.basicData.functions[2][3]))
        elseif tNextData.basicData.type == 1 and (tNextData.basicData.sub_type == 5 or tNextData.basicData.sub_type == 6 or tData.basicData.sub_type == 7) then 
            ftxtProperty21:setRelativePosition(GlobalMethod:ccp(0.03,0.16))
            ftxtProperty21:setShowText(string.format(sFormat, tNextData.basicData.desc, ""))
        end
    end

    local ftxtProperty22 = GetElement(self.m_root, "ftxtProperty22_WndBuildingUpgrade", WZUIFreeTextBox)
    if ftxtProperty22 then 
        if tNextData.basicData.type == 0 and tNextData.basicData.sub_type == 0 then
            ftxtProperty22:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT23, ""))
        elseif tNextData.basicData.type == 1 and (tNextData.basicData.sub_type == 1 or tNextData.basicData.sub_type == 2) then 
            ftxtProperty22:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT13, tNextData.basicData.functions[1][3] .. "/" .. LocalStrings.HOUR1))
        elseif tNextData.basicData.type == 1 and tNextData.basicData.sub_type == 3 then 
            ftxtProperty22:setShowText(string.format(sFormat, LocalStrings.FAMILY_TEXT14, tNextData.basicData.functions[1][3]))
        end
    end
end

--@brief    按钮的状态，不满足的条件提示语
--@param    tData:要升级的建筑的数据
function WndBuildingUpgrade:_setBtnState(tData)
    -- body
    local btnUpgrade = GetElement(self.m_root, "btnUpgrade_WndBuildingUpgrade", WZUIButton)
    btnUpgrade:setVisible(true)
    local txtCondition = GetElement(self.m_root, "txtCondition_WndBuildingUpgrade", WZUILabelTTF)
    local txtTime = GetElement(self.m_root, "txtTime_WndBuildingUpgrade", WZUILabelTTF)
    local ftxtCost = GetElement(self.m_root, "ftxtCost_WndBuildingUpgrade", WZUIFreeTextBox)
    local sCostFormat = [[<T S="18" C="79,60,48" P="1" SC="127,70,26" SS="2" SE="0">%s</T><I Z="0.45" P="1">%s</I><T S="18" C="158,0,0" P="1" SC="127,70,26" SS="2" SE="0">%d</T>]]
    local tCostBasicData = GDatatab_item["id_" .. tData.basicData.upgrade_cost[1][1]]
    if ftxtCost then
        ftxtCost:setShowText(string.format(sCostFormat, LocalStrings.PETUSE, tCostBasicData.icon, tData.basicData.upgrade_cost[1][2]))
    end
    if txtTime then 
        local sTimeContent  
        local nDay = math.floor(tData.basicData.upgrade_time/(3600 * 24))
        local nHour = math.floor(tData.basicData.upgrade_time/3600)
        local nMinute = math.floor((tData.basicData.upgrade_time - nHour * 3600)/60)
        local nSecond = tData.basicData.upgrade_time - nHour * 60 - nMinute * 60
        if tData.basicData.upgrade_time < 60 then 
            sTimeContent = tData.basicData.upgrade_time .. LocalStrings.SECOND
        elseif tData.basicData.upgrade_time < 3600 then 
            sTimeContent = nMinute .. LocalStrings.MINUTE1 .. nSecond .. LocalStrings.SECOND
        elseif tData.basicData.upgrade_time < 3600 * 24 then 
            sTimeContent = nHour .. LocalStrings.HOUR1 .. nMinute .. LocalStrings.MINUTE1
        else
            sTimeContent = nDay .. LocalStrings.DAY .. nHour .. LocalStrings.HOUR1
        end
        txtTime:setText(sTimeContent)
    end
    local nState = self:_upgradeConditionState(tData)
    if nState == 0 then 
        btnUpgrade:setTouchEnable(true)
        txtCondition:setVisible(false)
        txtTime:setColor(GlobalMethod:ccc3(255,236,193))
        txtTime:setStrokeColor(GlobalMethod:ccc3(0,72,3))
    elseif nState == 1 then
        btnUpgrade:setTouchEnable(false)
        txtCondition:setVisible(true)
        txtCondition:setText(string.format(LocalStrings.FAMILY_TEXT17, tData.basicData.upgrade_condition[1][2]))
        txtTime:setColor(GlobalMethod:ccc3(255,255,255))
        txtTime:setStrokeColor(GlobalMethod:ccc3(79,60,48))
    elseif nState == 2 then
        btnUpgrade:setTouchEnable(false)
        txtCondition:setVisible(true)
        local tNeedBuildingData = GDatatab_home_building["id_" .. tData.basicData.upgrade_condition[2][1]]
        local tNeedBuildingInfo = GDatatab_item["id_" .. tData.basicData.upgrade_condition[2][1]]
        txtCondition:setText(string.format(LocalStrings.FAMILY_TEXT18, tNeedBuildingData.level, tNeedBuildingInfo.name, tData.basicData.upgrade_condition[2][2]))
        txtTime:setColor(GlobalMethod:ccc3(255,255,255))
        txtTime:setStrokeColor(GlobalMethod:ccc3(79,60,48))
    end
end

--@brief    返回升级的条件状态
--@return   0：瞒足升级条件；1：家园等级不够；2：另一个条件不满足
function WndBuildingUpgrade:_upgradeConditionState(tData)
    -- body
    --获取升级所需某类建筑的数量
    local nBuildingNum = 0
    local nState = 0 
    if type(tData.basicData.upgrade_condition) == "table" then 
        for i = 1, #tData.basicData.upgrade_condition do
            local tTempData = tData.basicData.upgrade_condition[i]
            if i == 1 then 
                if tTempData[1] == -1 and tTempData[2] then
                    if tTempData[2] > SceneFamily.m_nFamilyLevel then
                        nState = 1 
                        break 
                    end
                end
            end
            if i == 2 then 
                if tTempData[1] ~= -1 and tTempData[2] then
                    nBuildingNum = SceneFamily:getBuildingNumById(tTempData[1])
                    if nBuildingNum < tTempData[2] then 
                        nState = 2 
                        break 
                    end
                end
            end
        end
    end

    return nState 
end
-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function WndBuildingUpgrade:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtBtnUpgrade1_WndBuildingUpgrade",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtBtnUpgrade2_WndBuildingUpgrade",WZUILabelTTF):setScale(0.8)

    local ftxtProperty11 = GetElement(self.m_root, "ftxtProperty11_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty11:setScale(0.7)
    ftxtProperty11:setMaxWidth(300)
    local ftxtProperty12 = GetElement(self.m_root, "ftxtProperty12_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty12:setScale(0.7)
    ftxtProperty12:setMaxWidth(300)
    local ftxtProperty21 = GetElement(self.m_root, "ftxtProperty21_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty21:setScale(0.7)
    ftxtProperty21:setMaxWidth(300)
    local ftxtProperty22 = GetElement(self.m_root, "ftxtProperty22_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty22:setScale(0.7)
    ftxtProperty22:setMaxWidth(300)
end

function WndBuildingUpgrade:_adaptLanguage_th(  )
    local ftxtProperty11 = GetElement(self.m_root, "ftxtProperty11_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty11:setScale(0.7)
    ftxtProperty11:setMaxWidth(260)
    local ftxtProperty12 = GetElement(self.m_root, "ftxtProperty12_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty12:setScale(0.7)
    ftxtProperty12:setMaxWidth(260)
    local ftxtProperty21 = GetElement(self.m_root, "ftxtProperty21_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty21:setScale(0.7)
    ftxtProperty21:setMaxWidth(260)
    local ftxtProperty22 = GetElement(self.m_root, "ftxtProperty22_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty22:setScale(0.7)
    ftxtProperty22:setMaxWidth(260)
end

function WndBuildingUpgrade:_adaptLanguage_en(  )
    local ftxtProperty11 = GetElement(self.m_root, "ftxtProperty11_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty11:setScale(0.7)
    ftxtProperty11:setRelativePosition(GlobalMethod:ccp(0.045,0.222727))
    ftxtProperty11:setMaxWidth(400)
    local ftxtProperty12 = GetElement(self.m_root, "ftxtProperty12_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty12:setScale(0.7)
    ftxtProperty12:setRelativePosition(GlobalMethod:ccp(0.045,0.0812986))
    ftxtProperty12:setMaxWidth(400)
    local ftxtProperty21 = GetElement(self.m_root, "ftxtProperty21_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty21:setScale(0.7)
    ftxtProperty21:setRelativePosition(GlobalMethod:ccp(0.045,0.222727))
    ftxtProperty21:setMaxWidth(400)
    local ftxtProperty22 = GetElement(self.m_root, "ftxtProperty22_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty22:setScale(0.7)
    ftxtProperty22:setRelativePosition(GlobalMethod:ccp(0.045,0.0812986))
    ftxtProperty22:setMaxWidth(400)
end

function WndBuildingUpgrade:_adaptLanguage_es(  )
    local ftxtProperty11 = GetElement(self.m_root, "ftxtProperty11_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty11:setScale(0.7)
    ftxtProperty11:setMaxWidth(400)
    ftxtProperty11:setRelativePosition(GlobalMethod:ccp(0.03,0.222727))

    local ftxtProperty12 = GetElement(self.m_root, "ftxtProperty12_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty12:setScale(0.7)
    ftxtProperty12:setMaxWidth(400)
    ftxtProperty12:setRelativePosition(GlobalMethod:ccp(0.03,0.0812986))

    local ftxtProperty21 = GetElement(self.m_root, "ftxtProperty21_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty21:setScale(0.7)
    ftxtProperty21:setMaxWidth(400)
    ftxtProperty21:setRelativePosition(GlobalMethod:ccp(0.03,0.222727))

    local ftxtProperty22 = GetElement(self.m_root, "ftxtProperty22_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty22:setScale(0.7)
    ftxtProperty22:setMaxWidth(400)
    ftxtProperty22:setRelativePosition(GlobalMethod:ccp(0.03,0.0812986))
end

function WndBuildingUpgrade:_adaptLanguage_pt(  )
    local ftxtProperty11 = GetElement(self.m_root, "ftxtProperty11_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty11:setScale(0.7)
    ftxtProperty11:setMaxWidth(400)
    ftxtProperty11:setRelativePosition(GlobalMethod:ccp(0.03,0.222727))

    local ftxtProperty12 = GetElement(self.m_root, "ftxtProperty12_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty12:setScale(0.7)
    ftxtProperty12:setMaxWidth(400)
    ftxtProperty12:setRelativePosition(GlobalMethod:ccp(0.03,0.0812986))

    local ftxtProperty21 = GetElement(self.m_root, "ftxtProperty21_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty21:setScale(0.7)
    ftxtProperty21:setMaxWidth(400)
    ftxtProperty21:setRelativePosition(GlobalMethod:ccp(0.03,0.222727))

    local ftxtProperty22 = GetElement(self.m_root, "ftxtProperty22_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty22:setScale(0.7)
    ftxtProperty22:setMaxWidth(400)
    ftxtProperty22:setRelativePosition(GlobalMethod:ccp(0.03,0.0812986))
end

function WndBuildingUpgrade:_adaptLanguage_tr(  )
    local ftxtProperty11 = GetElement(self.m_root, "ftxtProperty11_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty11:setScale(0.7)
    ftxtProperty11:setMaxWidth(400)
    ftxtProperty11:setRelativePosition(GlobalMethod:ccp(0.03,0.222727))

    local ftxtProperty12 = GetElement(self.m_root, "ftxtProperty12_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty12:setScale(0.7)
    ftxtProperty12:setMaxWidth(400)
    ftxtProperty12:setRelativePosition(GlobalMethod:ccp(0.03,0.0812986))

    local ftxtProperty21 = GetElement(self.m_root, "ftxtProperty21_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty21:setScale(0.7)
    ftxtProperty21:setMaxWidth(400)
    ftxtProperty21:setRelativePosition(GlobalMethod:ccp(0.03,0.222727))

    local ftxtProperty22 = GetElement(self.m_root, "ftxtProperty22_WndBuildingUpgrade", WZUIFreeTextBox)
    ftxtProperty22:setScale(0.7)
    ftxtProperty22:setMaxWidth(400)
    ftxtProperty22:setRelativePosition(GlobalMethod:ccp(0.03,0.0812986))
end
---------------------------------------语言适配End------------------------------------------