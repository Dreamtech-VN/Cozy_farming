--WndDevour.lua
--@brief	WndDevour的UI模块
--@date		2016/03/25
--@author	Tianxiang_Xu
--@note		吞噬


-------------------------------------公有方法模块Begin--------------------------------------
QUALITY_RECT_DEVOUR = {"ui/common/common_scale9_lv.png", "ui/common/common_scale9_lan.png", "ui/common/common_scale9_zi.png", "ui/common/common_scale9_cheng.png", "ui/common/common_scale9_wuse.png"}


--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDevour:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDevour:onExit(element)
	self:_unInit()
end

function WndDevour:onEnterTransitionDidFinish(element)
    -- body
    WZLog("****** WndBless:onEnterTransitionDidFinish ******")
    WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end

--@brief    窗口动画完成回调
function WndDevour:actionCallback(elem,data)
    ChangeChatChannel(Chat_Channel_BlessDevour)
    self.m_nMaxGrids = tonumber(CacheCenter:getGameParam()["prayBagSize"]) or 20
end


--@brief    关闭界面按钮点击相应
function WndDevour:onCloseClick(element)
    -- body
    --播放点击音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
    
end

--@brief    关闭窗口动画完成回调
function WndDevour:onCloseActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击+号按钮回调
function WndDevour:onClickAdd(element)
    -- body
    --播放音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --判断是否为最高等级，已经最高，则不能再吞噬升级
    local tData = self.m_tData
    local nMaxLevel = self:_getMaxLevel(tData.item_id)
    if tData.level >= nMaxLevel then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_LEVEL_MAX)
        return
    end

    self.m_nInterfaceIndex = 2
    GetElement(self.m_root, "conDevour_WndDevour", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conDevourChoose_WndDevour", WZUIContainer):setVisible(true)
    local txtRightBtn = GetElement(self.m_root, "txtRightBtn_WndDevour", WZUILabelTTF)
    txtRightBtn:setText(LocalStrings.SURE_CHOOSE)
    local conListForChoose = GetElement(self.m_root, "conListForChoose_WndDevour", WZUITableContainer)
    --清掉列表，重新生成
    conListForChoose:cleanTable()
    self.m_tCellGrids = nil
    self.m_nGridsIndex = 1
    self.m_tSureDevourList = self:_generalDevourList()
    if self.m_tCellGrids == nil then
        self.m_tCellGrids = {}
        conListForChoose:enableSchedule("onShowGrids")
    end
    --
    self:_updateTheChangeInfo()
end

--@brief    点击快速选择按钮回调
function WndDevour:onClickQuickChoose(element)
    -- body
    --播放音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nInterfaceIndex == 1 then
        self:_quickChoose()
        self:_createBlessItemListForDevour()
        --预览升级后的数据变化
        local nRiseLevel = self:_caculateUpgradeLv(self.m_nTotalExp)
        self:_updateProperty(self.m_tData, nRiseLevel)
    elseif self.m_nInterfaceIndex == 2 then
        self:_quickChoose()
        --刷新可获得经验和已选数量
        self:_updateTheChangeInfo()
    end
end

--@brief    点击确定选择或确定吞噬按钮回调
function WndDevour:onClickSureChoose(element)
    -- body
    --播放音效
    WZLog("WndDevour:onClickSureChoose")
    if self.m_nType == 1 then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

        if self.m_nInterfaceIndex == 1 then
            if self.m_tChooseList == nil or #self.m_tChooseList == 0 then
                MsgBoxManager:showTipBox(LocalStrings.BLESS_CHOOSE_NIL)
                return
            end
            WZLog("WndDevour:onClickSureChoose 11111", #self.m_tChooseList)
            --发送吞噬协议吞噬选中的祝福
            local vBeDevourId = WZLuaVector_int_:create()
            for i = 1, #self.m_tChooseList do
                vBeDevourId:push(self.m_tChooseList[i].blessId)
            end
            WZLog("WndDevour:onClickSureChoose 22222")
            self:_createLoading()
            ProtocolProcessorBless:send_PRAY_Devour(self.m_tData.userType, self.m_tData.blessId, vBeDevourId)
        elseif self.m_nInterfaceIndex == 2 then
            self.m_nInterfaceIndex = 1
            GetElement(self.m_root, "conDevour_WndDevour", WZUIContainer):setVisible(true)
            GetElement(self.m_root, "conDevourChoose_WndDevour", WZUIContainer):setVisible(false)
            local txtRightBtn = GetElement(self.m_root, "txtRightBtn_WndDevour", WZUILabelTTF)
            txtRightBtn:setText(LocalStrings.SURE_DEVOUR)
            --根据选中的祝福，创建待吞噬祝福列表
            WZLog("WndDevour:onClickSureChoose", #self.m_tChooseList, self.m_nTotalExp)
            self:_createBlessItemListForDevour()
            --预览升级后的数据变化
            local nRiseLevel = self:_caculateUpgradeLv(self.m_nTotalExp)
            self:_updateProperty(self.m_tData, nRiseLevel)
        end
    elseif self.m_nType == 2 then
        --选择装备祝福
        if self.m_tEquipItem == nil then
            SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
            MsgBoxManager:showTipBox(LocalStrings.CHOOSE_EQUIP_BLESSITEM)
            return 
        else
            if self.m_tCallBack then
                self.m_tCallBack[2](self.m_tCallBack[1], self.m_tEquipItem, self.m_nEquipRectIndex)
                --关掉选中界面
                WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
            end
        end
    end
end

--@brief    点击吞噬界面上的祝福
--@param    tData:祝福节点数据
--@param    tCell:祝福节点表
function WndDevour:onClickBlessItem(tData, tCell)
    -- body
    WZLog("WndDevour:onClickBlessItem")
    if self.m_nType == 1 then
        if self.m_tChooseList == nil then
            self.m_tChooseList = {}
        end

        if tData.bIsChoose == true then
            local nPreLevel = self.m_tData.level + self:_caculateUpgradeLv(self.m_nTotalExp)
            if nPreLevel >= self:_getMaxLevel(self.m_tData.item_id) then
                tCell:setConGouVisible(false) 
                MsgBoxManager:showTipBox(LocalStrings.ENOUGH_TO_DEVOUR)
            else
                if #self.m_tChooseList >= self.m_nTotalMaxNum then
                    tCell:setConGouVisible(false) 
                    MsgBoxManager:showTipBox(LocalStrings.DEVOUR_MOST)
                else
                    tCell:setConGouVisible(tData.bIsChoose) 
                    table.insert(self.m_tChooseList, tData)
                    self.m_nTotalExp = self.m_nTotalExp + self:_getUseExp(tData)
                end
            end
        elseif tData.bIsChoose == false then
            for i = 1, #self.m_tChooseList do
                if self.m_tChooseList[i].blessId == tData.blessId then
                    tCell:setConGouVisible(tData.bIsChoose) 
                    self.m_nTotalExp = self.m_nTotalExp - self:_getUseExp(self.m_tChooseList[i])
                    table.remove(self.m_tChooseList, i)
                    break
                end
            end
        end

        --更新可获得经验和已选择数量
        self:_updateTheChangeInfo()
    elseif self.m_nType == 2 then
        --选择要装备到装备框的祝福
        if tData.bIsChoose == true then
            if self.m_tLastEquipCell then
                self.m_tLastEquipCell:setConGouVisible(false)
            end
            self.m_tLastEquipCell = tCell 
            self.m_tEquipItem = tData
            tCell:setConGouVisible(tData.bIsChoose) 
        elseif tData.bIsChoose == false then
            if self.m_tLastEquipCell then
                self.m_tLastEquipCell:setConGouVisible(false)
            end
            self.m_tLastEquipCell = nil 
            self.m_tEquipItem = nil
            tCell:setConGouVisible(tData.bIsChoose) 
        end
    end
end

--@brief    创建格子以及设置格子数据
function WndDevour:onShowGrids(element)
    -- body
    if self.m_nGridsIndex > self.m_nMaxGrids then
        element:disableSchedule()
        return 
    end

    element = WZUITableContainer:luaTo(element)
    local cellElement, tCell = CellBlessItem:createElement()
    if cellElement and tCell then
        table.insert(self.m_tCellGrids, tCell)
        cellElement:setTag(self.m_nGridsIndex - 1)
        element:setCellElement(cellElement)
        tCell:setDevourCallBackFun(self, self.onClickBlessItem)
        if self.m_tSureDevourList[self.m_nGridsIndex] then
            tCell:setData(self.m_tSureDevourList[self.m_nGridsIndex], 6)
        else
            tCell:setData(nil, 5)
        end
    end

    self.m_nGridsIndex = self.m_nGridsIndex + 1
end

--@brief    吞噬成功后的处理
function WndDevour:onceDevourOk(devourId, exp, prayId, ids, fighting)
    --body
    --清理掉已经被吞噬掉的祝福（包括当前界面和来源界面（祈福屋或背包））
    WZLog("WndDevour:onceDevourOk")
    self.m_tChooseList = {}
    self.m_nTotalExp = 0
    self:_createBlessItemListForDevour()
    --清掉被吞噬的祝福
    self:_cleanBeDevourBless(ids)
    --更新吞噬的祝福的信息数据（包括当前和来源）
    self:_updateTheBlessItemInfo(devourId, exp, prayId)
    --如果操作的是装备栏的祝福
    if self.m_tData.userType == 3 then
        WndBlessBag:updateRoleFighting(fighting)
    end
    
    self:_stopLoading()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新祝福信息显示
function WndDevour:_update()
    --body
    local txtRightBtn = GetElement(self.m_root, "txtRightBtn_WndDevour", WZUILabelTTF)
    if self.m_nType == 1 then
        local tData = self.m_tData
        GetElement(self.m_root, "txtTitle_WndDevour", WZUILabelTTF):setText(LocalStrings.DEVOUR_WORDS)
        
        --图标品质框
        local imgQualityRect = GetElement(self.m_root, "imgQualityRect_WndDevour", WZUIImage)
        imgQualityRect:setFile(QUALITY_RECT_DEVOUR[tData.basicInfo.quality])
        --图标
        local spineItem = GetElement(self.m_root, "spineItem_WndDevour", WZUISpine)
        spineItem:setAnimationName(tData.basicInfo.icon)

        local nMaxLevel = self:_getMaxLevel(tData.item_id)
        local nCurExp = tData.curExp
        if tData.level == nMaxLevel then
            nCurExp = tData.total_exp
        end
        --经验
        local txtExp = GetElement(self.m_root, "txtExp_WndDevour", WZUILabelTTF)
        txtExp:setText(nCurExp .. "/" .. tData.total_exp)
        --经验条
        local progExp = GetElement(self.m_root, "progExp_WndDevour", WZUIProgress)
        local nPercent = math.floor(100 * nCurExp/tData.total_exp)
        progExp:setPercentage(nPercent)

        if self.m_nInterfaceIndex == 1 then
            GetElement(self.m_root, "conDevour_WndDevour", WZUIContainer):setVisible(true)
            GetElement(self.m_root, "conDevourChoose_WndDevour", WZUIContainer):setVisible(false)
            txtRightBtn:setText(LocalStrings.SURE_DEVOUR)

            self:_updateProperty(tData, 0)
        else
            GetElement(self.m_root, "conDevour_WndDevour", WZUIContainer):setVisible(false)
            GetElement(self.m_root, "conDevourChoose_WndDevour", WZUIContainer):setVisible(true)
            txtRightBtn:setText(LocalStrings.SURE_CHOOSE)
        end
    elseif self.m_nType == 2 then
        GetElement(self.m_root, "txtTitle_WndDevour", WZUILabelTTF):setText(LocalStrings.CHOOSE_BLESSITEM)
        GetElement(self.m_root, "conDevour_WndDevour", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conDevourChoose_WndDevour", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "btnQuickChoose_WndDevour", WZUIButton):setVisible(false)
        local btnRight = GetElement(self.m_root, "btnRight_WndDevour", WZUIButton)
        btnRight:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        txtRightBtn:setText(LocalStrings.EQUIPMENT)

        --可供选择装备的祝福
        local conListForChoose = GetElement(self.m_root, "conListForChoose_WndDevour", WZUITableContainer)
        --清掉列表，重新生成
        conListForChoose:cleanTable()
        self.m_tCellGrids = nil
        self.m_nGridsIndex = 1
        self.m_tSureDevourList = self.m_tDevourList
        if self.m_tCellGrids == nil then
            self.m_tCellGrids = {}
            conListForChoose:enableSchedule("onShowGrids")
        end
    end
end

--@brief    获取当前类型的祝福最高等级
function WndDevour:_getMaxLevel(itemId)
    -- body
    local nLevel = 0

    for i, value in pairs(GDatatab_pray) do
        if value.item_id == itemId and value.level > nLevel then
            nLevel = value.level
        end
    end

    return nLevel
end

--@brief     更新一些会随时变化的信息数据
function WndDevour:_updateTheChangeInfo()
    -- body
    local tData = self.m_tData

    --可获得经验
    local sCanGetExp = string.format(LocalStrings.DEVOUR_GET_EXP, self.m_nTotalExp)
    local txtTotalExp = GetElement(self.m_root, "txtTotalExp_WndDevour", WZUIFreeTextBox)
    txtTotalExp:setShowText(sCanGetExp)
    --已选择数量和上限
    local txtLeftNum = GetElement(self.m_root, "txtLeftNum_WndDevour", WZUILabelTTF)
    local nUseNum = #self.m_tChooseList
    txtLeftNum:setText(nUseNum .. "/" .. self.m_nTotalMaxNum)
end

--@brief     二次筛选可用于吞噬掉的祝福
function WndDevour:_generalDevourList()
    -- body
    local tData = self.m_tData

    local tTemp = {}
    for i = 1, #self.m_tDevourList do
        if self.m_tDevourList[i].basicInfo.sub_type == 32 or tData.quality >= self.m_tDevourList[i].quality then
            table.insert(tTemp, self.m_tDevourList[i])
        end
    end

    return tTemp
end

--@brief    创建待吞噬的祝福
function WndDevour:_createBlessItemListForDevour()
    -- body
    local tChooseList = self.m_tChooseList
    --移除掉之前添加的
    for i = 1, 8 do
        local conBlessItem = GetElement(self.m_root, string.format("conBlessItem%d_WndDevour", i), WZUIContainer)
        if conBlessItem and conBlessItem:getChildByTag(99) then
            conBlessItem:removeChildByTag(99, true)
            GetElement(self.m_root, string.format("imgAdd%d_WndDevour",i), WZUIImage):setVisible(true)
        end
    end

    WZLog("WndDevour:_createBlessItemListForDevour", #tChooseList)

    if tChooseList == nil or #tChooseList == 0 then return end

    for i = 1, #tChooseList do
        local conBlessItem = GetElement(self.m_root, string.format("conBlessItem%d_WndDevour", i), WZUIContainer)
        if tChooseList[i] then
            local cellElement, tCell = CellBlessItem:createElement()
            if cellElement and tCell then
                tCell:setData(tChooseList[i], 7)
                cellElement:setTag(99)
                conBlessItem:addChild(cellElement)
                GetElement(self.m_root, string.format("imgAdd%d_WndDevour",i), WZUIImage):setVisible(false)
            end
        end
    end
end

--@brief    获取某个祝福可用于吞噬的经验
function WndDevour:_getUseExp(tData)
    -- body
    local nTempExp = 0 
    local tTempList = {}
    for i, value in pairs(GDatatab_pray) do
        if value.item_id == tData.item_id then
            table.insert(tTempList, value)
        end
    end

    table.sort(tTempList, function (a, b) return a.level < b.level end )

    for i = 1, #tTempList do
        if tTempList[i].level < tData.level then
            nTempExp = nTempExp + tTempList[i].total_exp
        elseif tTempList[i].level == tData.level then
            nTempExp = nTempExp + tTempList[i].exp + tData.curExp
        else
            break
        end
    end

    return nTempExp
end

--@brief    获取同一类型的祝福下一等级的数据
--@param    tData: 当前等级数据
--@param    nRiseLevel : 当前等级+nRiseLevel
function WndDevour:_getNextData(tData, nRiseLevel)
    -- body
    if tData.level >= self:_getMaxLevel(tData.item_id) then
        return nil
    end

    for i, value in pairs(GDatatab_pray) do
        if value.item_id == tData.item_id and value.level == tData.level + nRiseLevel then
            return value
        end
    end

    return nil
end

--@brief    根据总可用经验，计算可以提升的等级
--@param    可用于升级的经验
function WndDevour:_caculateUpgradeLv(nCanUseExp)
    -- body
    local tData = self.m_tData
    local nRiseLevel = 0 
    local nTotalExp = nCanUseExp + tData.curExp
    --获取下一等级的数据
    local tDataNext = self:_getNextData(tData, 1)
    WZLog("WndDevour:_caculateUpgradeLv", nCanUseExp, tData.curExp, Serialize(tDataNext))
    if tDataNext == nil then return end

    local nNeedExp = tData.total_exp

    while nTotalExp >= nNeedExp do
        nRiseLevel = nRiseLevel + 1
        nTotalExp = nTotalExp - nNeedExp

        nNeedExp = tDataNext.total_exp
        tDataNext = self:_getNextData(tDataNext, 1)
        if tDataNext == nil then 
            break 
        end
    end

    return nRiseLevel
end

--@brief    更新属性变化
function WndDevour:_updateProperty(tData, nRiseLevel)
    -- body
    --等级
    local txtNextLv = GetElement(self.m_root, "txtNextLv_WndDevour", WZUILabelTTF)
    txtNextLv:setText("Lv"..tData.level)

    local tNextData = self:_getNextData(tData, nRiseLevel)
    if tNextData == nil then
        tNextData = tData
    end
    --提升等级
    local txtUpgradeNum = GetElement(self.m_root, "txtUpgradeNum_WndDevour", WZUILabelTTF)
    txtUpgradeNum:setText(nRiseLevel)
    --属性
    local nPropertyNum = #tData.property
    if nPropertyNum == 1 then
        local conProperty1 = GetElement(self.m_root, "conProperty1_WndDevour", WZUIContainer)
        conProperty1:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        conProperty1:setVisible(true)
        local txtPropertyCur1 = GetElement(self.m_root, "txtPropertyCur1_WndDevour", WZUIFreeTextBox)
        local sPropertyCur = [[<T C = "127,70,26" S="22" P="1">%s</T><BL>16</BL><T C="158,0,0" S="22" P="1">%d</T>]]
        txtPropertyCur1:setShowText(string.format(sPropertyCur, ATTR_TITLE[tData.property[1][1]], tData.property[1][2]))
        local txtPropertyNext1 = GetElement(self.m_root, "txtPropertyNext1_WndDevour", WZUIFreeTextBox)
        local sPropertyNext = [[<T C = "127,70,26" S="22" P="1">%s</T><BL>16</BL><T C="5,180,0" S="22" P="1">%d</T>]]
        txtPropertyNext1:setShowText(string.format(sPropertyNext, ATTR_TITLE[tNextData.property[1][1]], tNextData.property[1][2]))
    elseif nPropertyNum == 2 then
        local conProperty1 = GetElement(self.m_root, "conProperty1_WndDevour", WZUIContainer)
        conProperty1:setVisible(true)
        local conProperty2 = GetElement(self.m_root, "conProperty2_WndDevour", WZUIContainer)
        conProperty2:setVisible(true)
        local txtPropertyCur1 = GetElement(self.m_root, "txtPropertyCur1_WndDevour", WZUIFreeTextBox)
        local sPropertyCur = [[<T C = "127,70,26" S="22" P="1">%s</T><BL>16</BL><T C="158,0,0" S="22" P="1">%d</T>]]
        txtPropertyCur1:setShowText(string.format(sPropertyCur, ATTR_TITLE[tData.property[1][1]], tData.property[1][2]))
        local txtPropertyNext1 = GetElement(self.m_root, "txtPropertyNext1_WndDevour", WZUIFreeTextBox)
        local sPropertyNext = [[<T C = "127,70,26" S="22" P="1">%s</T><BL>16</BL><T C="5,180,0" S="22" P="1">%d</T>]]
        txtPropertyNext1:setShowText(string.format(sPropertyNext, ATTR_TITLE[tNextData.property[1][1]], tNextData.property[1][2]))
        --属性2
        local txtPropertyCur2 = GetElement(self.m_root, "txtPropertyCur2_WndDevour", WZUIFreeTextBox)
        txtPropertyCur2:setShowText(string.format(sPropertyCur, ATTR_TITLE[tData.property[2][1]], tData.property[2][2]))
        local txtPropertyNext2 = GetElement(self.m_root, "txtPropertyNext2_WndDevour", WZUIFreeTextBox)
        txtPropertyNext2:setShowText(string.format(sPropertyNext, ATTR_TITLE[tNextData.property[2][1]], tNextData.property[2][2]))
    end
end

--@brie     快速选择
function WndDevour:_quickChoose()
    -- body
    local tData = self.m_tData
    local tDevourList = self:_generalDevourList()
    if self.m_tChooseList == nil then
        self.m_nTotalExp = 0
        self.m_tChooseList = {}
    end

    --没有可吞噬的祝福
    if #tDevourList == 0 then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLESS_TO_DEVOUR)
        return
    end
    --已经是最高级，不能再吞噬了
    if tData.level >= self:_getMaxLevel(tData.item_id) then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_LEVEL_MAX)
        return
    end

    for i = 1, #tDevourList do
        --屏蔽掉那些已经选择的
        if tDevourList[i].bIsChoose == false and (tDevourList[i].basicInfo.sub_type == 32 or (tDevourList[i].basicInfo.sub_type ~= 32 and tDevourList[i].basicInfo.quality < 3)) then
            local nPreLevel = tData.level + self:_caculateUpgradeLv(self.m_nTotalExp)
            if nPreLevel >= self:_getMaxLevel(tData.item_id) then
                break
            else
                if #self.m_tChooseList >= self.m_nTotalMaxNum then
                    break
                else
                    self.m_tDevourList[i].bIsChoose = true
                    tDevourList[i].bIsChoose = true
                    table.insert(self.m_tChooseList, tDevourList[i])
                    self.m_nTotalExp = self.m_nTotalExp + self:_getUseExp(tDevourList[i])
                end
            end
        end
    end

    --快速选择时，在吞噬选择界面，设置选中的祝福点打钩
    if self.m_nInterfaceIndex == 2 then
        for k = 1, #self.m_tChooseList do
            for j = 1, #self.m_tCellGrids do
                local tCellData = self.m_tCellGrids[j]:getData()
                if tCellData then
                    if self.m_tChooseList[k].blessId == tCellData.blessId then
                        self.m_tCellGrids[j]:setConGouVisible(self.m_tChooseList[k].bIsChoose)
                        break
                    end
                end
            end
        end
    end
end

--@brief    清除掉被吞噬的祝福
--param     tBeDevourBless: 被吞噬掉的祝福的Id
function WndDevour:_cleanBeDevourBless(tBeDevourIds)
    -- body
    --移除可吞噬列表中已经被吞噬的祝福
    for i = 1, #tBeDevourIds do
        for j = 1, #self.m_tDevourList do
            if self.m_tDevourList[j].blessId == tBeDevourIds[i] then
                table.remove(self.m_tDevourList, j)
                break
            end
        end
    end
    --移除来源处的相应祝福
    if self.m_tData.userType == 1 then
        WndBless:cleanBeDevourBless(tBeDevourIds)
    elseif self.m_tData.userType == 2 or self.m_tData.userType == 3 then
        WndBlessBag:cleanBeDevourBless(tBeDevourIds)
    end
end

--@brief    更新吞噬后，节点的数据更新显示
function WndDevour:_updateTheBlessItemInfo(devourId, exp, prayId)
    -- body
    if self.m_tData.blessId == devourId then
        local tData =  CopyTable(GDatatab_pray["id_"..prayId])
        tData.basicInfo = self.m_tData.basicInfo
        tData.userType = self.m_tData.userType
        tData.blessId = self.m_tData.blessId
        tData.curExp = exp
		tData.name = tData.basicInfo.name

        self.m_tData = tData

        self:_updateProperty(tData, 0)
        local nMaxLevel = self:_getMaxLevel(tData.item_id)
        local nCurExp = tData.curExp
        local nTotalExp = tData.total_exp
        if tData.level == nMaxLevel then
            local nTempId = self:_getSecondMaxLevel(nMaxLevel, tData.item_id)
            local tTempData = GDatatab_pray["id_"..nTempId]
            nCurExp = tTempData.total_exp
            nTotalExp = tTempData.total_exp
        end
        --经验
        local txtExp = GetElement(self.m_root, "txtExp_WndDevour", WZUILabelTTF)
        txtExp:setText(nCurExp .. "/" .. nTotalExp)
        --经验条
        local progExp = GetElement(self.m_root, "progExp_WndDevour", WZUIProgress)
        local nPercent = math.floor(100 * nCurExp/nTotalExp)
        progExp:setPercentage(nPercent)
        --更新来源处的相应祝福
        if self.m_tData.userType == 1 then
            WndBless:updateTheBlessItemInfo(tData)
        elseif self.m_tData.userType == 2 or self.m_tData.userType == 3 then
            WndBlessBag:updateTheBlessItemInfo(tData)
        end
    end

end

--@brief    获取当前类型的祝福的第二高等级的id
function WndDevour:_getSecondMaxLevel(nMaxLevel, itemId)
    -- body
    local id = 0

    for i, value in pairs(GDatatab_pray) do
        if value.item_id == itemId and value.level == nMaxLevel - 1 then
            id = value.id
        end
    end

    return id
end

--@brief    数据加载动画
function WndDevour:_createLoading()
    -- body
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief    加载动画停止
function WndDevour:_stopLoading()
    -- body
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    self.m_nLoadingId = nil 
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------多语言适配 Start----------------------------------------
function WndDevour:_adaptLanguage_en()
    -- body
    local txtFastChoose = GetElement(self.m_root, "txtFastChoose_WndDevour", WZUILabelTTF)
    if txtFastChoose then
        txtFastChoose:setFontSize(22)
    end


end

function WndDevour:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtFastChoose_WndDevour",WZUILabelTTF):setScale(0.76)
    GetElement(self.m_root,"txtRightBtn_WndDevour",WZUILabelTTF):setScale(0.8)
end

function WndDevour:_adaptLanguage_es(  )
    local txtFastC = GetElement(self.m_root,"txtFastChoose_WndDevour",WZUILabelTTF)
    txtFastC:setDimensions(GlobalMethod:CCSize(120,0))
    txtFastC:setFontSize(20)
end
-------------------------------------多语言适配 End----------------------------------------
