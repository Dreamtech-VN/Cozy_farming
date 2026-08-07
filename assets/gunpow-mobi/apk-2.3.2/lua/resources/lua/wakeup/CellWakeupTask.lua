--CellWakeupTask.lua
--@brief	CellWakeupTask的UI模块
--@date		2017/05/20
--@author	Tianxiang_Xu
--@note		觉醒模块-任务界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWakeupTask:onEnter(element)
	self.m_root = element
    CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWakeupTask:onExit(element)
    CacheCenter:unregisterUpatePlayerItemObserver(self)
    
	self:_unInit()
end

--@brief    界面加载完成回调
function CellWakeupTask:onEnterTransitionDidFinish(element)
    -- body
    self:_setStaticText()
    self:_update()
    AdaptLanguage(self)
end

--@brief    点击觉醒或前往按钮回调
function CellWakeupTask:onClickWakeup(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nState = self.m_tData.status 
    if nState <= 1 or nState == 3 then
        --发送协议，觉醒
        local tipContent = self:_judgeWakeupCondition()
        if tipContent then
            MsgBoxManager:showTipBox(tipContent)
            return 
        end
            
        local bIsEnough = self:_judgeWakeupCostEnough()
        if bIsEnough then
            WndWakeup:_createLoading()
            ProtocolProcessorWakeup:send_AWAKE_Awake(self.m_tData.id)
        end
    else
        --前往觉醒之魂界面
        WndWakeup:onClickLeftCallBack(self.m_nTopSelIndex)
    end
end

function CellWakeupTask:onClickItem(luaTable,tag,tData)
    if tData == nil then
       return
    end
    
    if tData.basicInfo and tData.basicInfo.id == 500 then --觉醒之晶
        WndFastGetItems:show(tData.basicInfo.id,luaTable.m_nNeedCount)
    else
        WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
    end
    
end

--@brief    点击顶部标签回调
function CellWakeupTask:onClickCheck(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    if self.m_nTopSelIndex == nTag then return end 

    local tNextTaskData = WndWakeup:getTaskData(nTag)
    if tNextTaskData.status == 0 then
        self:_resetCheckBoxState()
        MsgBoxManager:showTipBox(LocalStrings.WELFARE_COMPETE_TEXT1)
        return 
    end

    self.m_nTopSelIndex = nTag 
    WndWakeup:setTopSelIndex(nTag)

    self:showInterface(nil, nTag, self.m_nCurProgress)
end

--@brief    点击详情按钮回调
function CellWakeupTask:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings[self.m_tData.basicInfo.awake_introduce])
end

--@brief    任务点击前往按钮回调
function CellWakeupTask:onClickGoto(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    local tTaskData = self.m_tData.taskData[nTag]

    if tTaskData then
        JumpByUIId(tTaskData.basicInfo.script[1][1], tTaskData.basicInfo.script[1][2], nil, 3)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新信息
function CellWakeupTask:_update()
    -- body
    self.m_tData = WndWakeup:getTaskData(self.m_nTopSelIndex)
    if self.m_tData == nil then return end 

    self:_setTaskDetail()
    self:_setCheckBoxState()
    self:_createBaseProperty()
end

--@brief    设置静态文本
function CellWakeupTask:_setStaticText()
    -- body
    for i = 1, 5 do
        local txtCheck11 = GetElement(self.m_root, "txtCheck" .. i .. "_1_CellWakeupTask", WZUILabelTTF)
        if txtCheck11 then
            txtCheck11:setText(LocalStrings.WAKEUP_TEXT2[i])
        end
        local txtCheck12 = GetElement(self.m_root, "txtCheck" .. i .. "_2_CellWakeupTask", WZUILabelTTF)
        if txtCheck12 then
            txtCheck12:setText(LocalStrings.WAKEUP_TEXT2[i])
        end
    end
end

--@brief    设置具体的信息显示
function CellWakeupTask:_setTaskDetail()
    -- body
    local tData = self.m_tData.basicInfo
    local tFinishPoint = {GlobalMethod:ccp(0.98,0.65), GlobalMethod:ccp(0.98,0.4), GlobalMethod:ccp(0.98,0.13)}
    local tUnFinishPoint = {GlobalMethod:ccp(0.88,0.65), GlobalMethod:ccp(0.88,0.4), GlobalMethod:ccp(0.88,0.13)}
    --展示图
    local imgTask = GetElement(self.m_root, "imgTask_CellWakeupTask", WZUIImage)
    if imgTask then
        imgTask:setFile(tData.awake_img)
    end
    --条件
    local tTaskList = self.m_tData.taskData
    WZLog("CellWakeupTask:_setTaskDetail", Serialize(tTaskList))
    for i = 1, #tTaskList do
        local txtCondition = GetElement(self.m_root, "txtCondition" .. i .. "_CellWakeupTask", WZUILabelTTF)
        if txtCondition then
            txtCondition:setText(string.format(LocalStrings.WAKEUP_TEXT16 .. ":", i) .. tTaskList[i].basicInfo.desc)
        end
        local txtTarget = GetElement(self.m_root, "txtTarget" .. i .. "_CellWakeupTask", WZUILabelTTF)
        local bIsFinish = false
        if txtTarget then
            if tTaskList[i].target == 1 then
                if tonumber(tTaskList[i].complete) == 0 then
                    txtTarget:setText(LocalStrings.LEAGUE_REWARD_TEXT9)
                    txtTarget:setColor(GlobalMethod:ccc3(255,89,74))
                    if tTaskList[i].basicInfo.script[1][1] == 0 then
                        txtTarget:setRelativePosition(tFinishPoint[i])
                    else
                        txtTarget:setRelativePosition(tUnFinishPoint[i])
                    end
                elseif tonumber(tTaskList[i].complete) > 0 then
                    txtTarget:setText(LocalStrings.WAKEUP_TEXT8)
                    txtTarget:setColor(GlobalMethod:ccc3(99,255,95))
                    txtTarget:setRelativePosition(tFinishPoint[i])
                    bIsFinish = true
                end
            else
                if tonumber(tTaskList[i].target) <= tonumber(tTaskList[i].complete) then
                    txtTarget:setText(LocalStrings.WAKEUP_TEXT8)
                    txtTarget:setColor(GlobalMethod:ccc3(99,255,95))
                    txtTarget:setRelativePosition(tFinishPoint[i])
                    bIsFinish = true
                else
                    txtTarget:setText(tTaskList[i].complete .. "/" .. tTaskList[i].target)
                    txtTarget:setColor(GlobalMethod:ccc3(255,227,116))
                    if tTaskList[i].basicInfo.script[1][1] == 0 then
                        txtTarget:setRelativePosition(tFinishPoint[i])
                    else
                        txtTarget:setRelativePosition(tUnFinishPoint[i])
                    end
                end
            end
        end
        --按钮
        local btnGoto = GetElement(self.m_root, "btnGoto" .. i .. "_CellWakeupTask", WZUIButton)
        if btnGoto then
            if tTaskList[i].basicInfo.script[1][1] == 0 then 
                btnGoto:setVisible(false)
            else
                if not bIsFinish then
                    btnGoto:setVisible(true)
                    local txtBtnGoto = GetElement(self.m_root, "txtBtnGoto" .. i .. "_CellWakeupTask", WZUILabelTTF)
                    if txtBtnGoto then
                        txtBtnGoto:setText(tTaskList[i].basicInfo.buttonName)
                        if ProjConfig.LANGUAGE == "th" then
                            txtBtnGoto:setScale(0.55)
                        end
                    end
                else
                    btnGoto:setVisible(false)
                end
            end
        end
    end

    self:_setBtnState()
    self:_createCostList()
end

--@brief    设置按钮的状态
function CellWakeupTask:_setBtnState()
    -- body
    local nState = self.m_tData.status

    local txtAfterWakeup = GetElement(self.m_root, "txtAfterWakeup_CellWakeupTask", WZUILabelTTF)
    local btnWakeup = GetElement(self.m_root, "btnWakeup_CellWakeupTask", WZUIButton)

    if txtAfterWakeup then
        if nState <= 1 or nState == 3 then
            btnWakeup:setVisible(true)
            txtAfterWakeup:setText(LocalStrings.WAKEUP_TEXT6[self.m_nTopSelIndex])
            txtAfterWakeup:setRelativePosition(GlobalMethod:ccp(0.88, 0.56))
        else
            btnWakeup:setVisible(false)
            txtAfterWakeup:setText(LocalStrings.WAKEUP_TEXT7[self.m_nTopSelIndex])
            txtAfterWakeup:setRelativePosition(GlobalMethod:ccp(0.88, 0.25))
        end
    end
    --
    local txtWakeup = GetElement(self.m_root, "txtWakeup_CellWakeupTask", WZUILabelTTF)
    if txtWakeup then
        if nState <= 1 or nState == 3 then
            btnWakeup:setVisible(true)
            txtWakeup:setText(LocalStrings.WAKEUP_TEXT5)
        else
            btnWakeup:setVisible(false)
            txtWakeup:setText(LocalStrings.ACTIVE_BTN_GO)
        end
    end
end

--@brief    消耗列表
function CellWakeupTask:_createCostList()
    -- body
    local tableCostList = GetElement(self.m_root, "tableCostList_CellWakeupTask", WZUITableContainer)
    tableCostList:cleanTable()
    local tCostList = self.m_tData.basicInfo.awake_cost
    for i = 1, #tCostList do
        local element, objNew = CellGoodItem:createElement()
        local tBasicInfo = GDatatab_item["id_" .. tCostList[i][1]]
        if tBasicInfo then
            if element and objNew then
                objNew:setCellGoodLocalId(tCostList[i][1], tCostList[i][2], 4)
                objNew:setItemClickFun(self, self.onClickItem)
                objNew:setBackImgFile("ui/common/common_scale9_beibaodi.png", true)
                element:setTag(i - 1)
                local nHaveNum = CacheCenter:getPlayerItemCountById(tCostList[i][1])
                objNew:_setItemCountText(nHaveNum, tonumber(tCostList[i][2]))
                tableCostList:setCellElement(element)
            end
        end
    end
end

--@brief    设置顶部复选框可见以及选中状态
function CellWakeupTask:_setCheckBoxState()
    -- body
    WZLog("CellWakeupTask:_setCheckBoxState", self.m_nCurProgress)
    for i = 1, self.m_nCurProgress do
        GetElement(self.m_root, "checkTop" .. i .. "_CellWakeupTask", WZUICheckBox):setVisible(true)
        if i == self.m_nTopSelIndex then
            GetElement(self.m_root, "checkGroup_CellWakeupTask", WZUICheckBoxGroup):setCheckIndex(self.m_nTopSelIndex - 1)
        end
    end
end

--@brief    重置复选框状态
function CellWakeupTask:_resetCheckBoxState()
    -- body
    GetElement(self.m_root, "checkGroup_CellWakeupTask", WZUICheckBoxGroup):setCheckIndex(self.m_nTopSelIndex - 1)
end

--@brief    创建基础属性
function CellWakeupTask:_createBaseProperty()
    -- body
    local conForProperty = GetElement(self.m_root, "conForProperty_CellWakeupTask", WZUIContainer)
    conForProperty:removeAllChildrenWithCleanup(true)
    local sPropertyFormat = [[<T C="99,255,95" S="20" P="1">%s: </T><T C="99,255,95" S="20" P="1">+%d</T>]]
    if ProjConfig.LANGUAGE == "ug" then
        sPropertyFormat = [[<T C="99,255,95" S="20" P="1">+%d</T><T C="195,171,148" S="20" P="1">%s: </T>]]
    end
    local tPropertyList = self.m_tData.basicInfo.property
    for i = 1, #tPropertyList do
        local nTempDisY = (1 - 0.14 * 2)/(#tPropertyList - 1)
        local ftxtProperty = WZUIFreeTextBox:create()
        ftxtProperty:setMaxWidth(240)
        ftxtProperty:setRelativePosition(GlobalMethod:ccp(0.18, 0.86 - (i - 1)* nTempDisY))
        ftxtProperty:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
        if tPropertyList[i][1] == 63 or tPropertyList[i][1] == 62 then 
            local txtContent
            if ProjConfig.LANGUAGE == "ug" then
                txtContent = string.format(sPropertyFormat, tPropertyList[i][2], GDatatab_item["id_" .. tPropertyList[i][1]].name)
            else
                txtContent = string.format(sPropertyFormat, GDatatab_item["id_" .. tPropertyList[i][1]].name, tPropertyList[i][2])
            end
            ftxtProperty:setShowText(txtContent)
        else
            local txtContent
            if ProjConfig.LANGUAGE == "ug" then
                txtContent = string.format(sPropertyFormat, tPropertyList[i][2], ATTR_TITLE[tPropertyList[i][1]])
            else
                txtContent = string.format(sPropertyFormat, ATTR_TITLE[tPropertyList[i][1]], tPropertyList[i][2])
            end
            ftxtProperty:setShowText(txtContent)
        end
        conForProperty:addChild(ftxtProperty)
        if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
            ftxtProperty:setMaxWidth(400)
        elseif ProjConfig.LANGUAGE == "ug" then
            ftxtProperty:setAnchorPoint(GlobalMethod:ccp(1, 0.5))
            ftxtProperty:setRelativePosition(GlobalMethod:ccp(1, 0.86 - (i - 1)* nTempDisY))
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellWakeupTask:_adaptLanguage_vn(  )

    local txtAfterWakeup = GetElement(self.m_root,"txtAfterWakeup_CellWakeupTask",WZUILabelTTF)
    txtAfterWakeup:setScale(0.7)
    txtAfterWakeup:setDimensions(GlobalMethod:CCSize(180))
    --txtAfterWakeup:setDimensions(GlobalMethod:CCSize(160,0))
    for i=1,3 do
        local txtCondition = GetElement(self.m_root,"txtCondition"..i.."_CellWakeupTask",WZUILabelTTF)
        txtCondition:setFontSize(16)
        txtCondition:setDimensions(GlobalMethod:CCSize(540,0))
    end
end

function CellWakeupTask:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtCheck1_1_CellWakeupTask",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtCheck1_2_CellWakeupTask",WZUILabelTTF):setFontSize(20)

    GetElement(self.m_root,"txtCheck2_1_CellWakeupTask",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtCheck2_2_CellWakeupTask",WZUILabelTTF):setFontSize(20)

    GetElement(self.m_root,"txtCheck3_1_CellWakeupTask",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtCheck3_2_CellWakeupTask",WZUILabelTTF):setFontSize(16)

    local txtAfterWakeup = GetElement(self.m_root,"txtAfterWakeup_CellWakeupTask",WZUILabelTTF)
    txtAfterWakeup:setFontSize(16)
    txtAfterWakeup:setRelativePosition(GlobalMethod:ccp(0.88,0.590675))
    txtAfterWakeup:setDimensions(GlobalMethod:CCSize(160))

    for i=1,3 do
        local txtCondition = GetElement(self.m_root,"txtCondition"..i.."_CellWakeupTask",WZUILabelTTF)
        txtCondition:setFontSize(16)
        txtCondition:setDimensions(GlobalMethod:CCSize(540,0))
        txtCondition:setRelativePosition(GlobalMethod:ccp(0.02,0.93-i*0.26))

        local txtBtnGoto = GetElement(self.m_root, "txtBtnGoto" .. i .. "_CellWakeupTask", WZUILabelTTF)
        if txtBtnGoto then
            txtBtnGoto:setScale(0.45)
        end
    end
    
end

function CellWakeupTask:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtCheck1_1_CellWakeupTask",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtCheck1_2_CellWakeupTask",WZUILabelTTF):setFontSize(18)

    GetElement(self.m_root,"txtCheck2_1_CellWakeupTask",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtCheck2_2_CellWakeupTask",WZUILabelTTF):setFontSize(18)

    GetElement(self.m_root,"txtCheck3_1_CellWakeupTask",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtCheck3_2_CellWakeupTask",WZUILabelTTF):setFontSize(16)

    local txtAfterWakeup = GetElement(self.m_root,"txtAfterWakeup_CellWakeupTask",WZUILabelTTF)
    txtAfterWakeup:setFontSize(18)
    txtAfterWakeup:setRelativePosition(GlobalMethod:ccp(0.86,0.56))

    local txtForDesc = GetElement(self.m_root,"txtForDesc_CellWakeupTask",WZUILabelTTF)
    txtForDesc:setRelativePosition(GlobalMethod:ccp(0.65,0.866666))

end

function CellWakeupTask:_adaptLanguage_pt(  )
    local txtAfterWakeup = GetElement(self.m_root,"txtAfterWakeup_CellWakeupTask",WZUILabelTTF)
    txtAfterWakeup:setFontSize(16)
    txtAfterWakeup:setRelativePosition(GlobalMethod:ccp(0.88,0.590675))
    txtAfterWakeup:setDimensions(GlobalMethod:CCSize(160))

    local txtForDesc = GetElement(self.m_root,"txtForDesc_CellWakeupTask",WZUILabelTTF)
    txtForDesc:setRelativePosition(GlobalMethod:ccp(0.65,0.866666))

    for i=1,3 do
        local txtCondition = GetElement(self.m_root,"txtCondition"..i.."_CellWakeupTask",WZUILabelTTF)
        txtCondition:setFontSize(16)
        txtCondition:setDimensions(GlobalMethod:CCSize(540,0))
        txtCondition:setRelativePosition(GlobalMethod:ccp(0.02,0.93-i*0.26))
    end

    for i = 1, 5 do
        local txtCheck11 = GetElement(self.m_root, "txtCheck" .. i .. "_1_CellWakeupTask", WZUILabelTTF)
        if txtCheck11 then
            txtCheck11:setScale(0.8)
        end
        local txtCheck12 = GetElement(self.m_root, "txtCheck" .. i .. "_2_CellWakeupTask", WZUILabelTTF)
        if txtCheck12 then
            txtCheck12:setScale(0.8)
        end
    end
end

function CellWakeupTask:_adaptLanguage_es(  )
    local txtAfterWakeup = GetElement(self.m_root,"txtAfterWakeup_CellWakeupTask",WZUILabelTTF)
    txtAfterWakeup:setFontSize(16)
    txtAfterWakeup:setRelativePosition(GlobalMethod:ccp(0.88,0.590675))
    txtAfterWakeup:setDimensions(GlobalMethod:CCSize(160))

    local txtForDesc = GetElement(self.m_root,"txtForDesc_CellWakeupTask",WZUILabelTTF)
    txtForDesc:setRelativePosition(GlobalMethod:ccp(0.65,0.866666))

    for i=1,3 do
        local txtCondition = GetElement(self.m_root,"txtCondition"..i.."_CellWakeupTask",WZUILabelTTF)
        txtCondition:setFontSize(16)
        txtCondition:setDimensions(GlobalMethod:CCSize(540,0))
        txtCondition:setRelativePosition(GlobalMethod:ccp(0.02,0.93-i*0.26))
    end

    for i = 1, 5 do
        local txtCheck11 = GetElement(self.m_root, "txtCheck" .. i .. "_1_CellWakeupTask", WZUILabelTTF)
        if txtCheck11 then
            txtCheck11:setScale(0.8)
        end
        local txtCheck12 = GetElement(self.m_root, "txtCheck" .. i .. "_2_CellWakeupTask", WZUILabelTTF)
        if txtCheck12 then
            txtCheck12:setScale(0.8)
        end
    end
end

function CellWakeupTask:_adaptLanguage_tr(  )
    local txtAfterWakeup = GetElement(self.m_root,"txtAfterWakeup_CellWakeupTask",WZUILabelTTF)
    txtAfterWakeup:setScale(0.7)
    txtAfterWakeup:setDimensions(GlobalMethod:CCSize(180))

    local txtForDesc = GetElement(self.m_root,"txtForDesc_CellWakeupTask",WZUILabelTTF)
    txtForDesc:setRelativePosition(GlobalMethod:ccp(0.65,0.866666))

    for i=1,3 do
        GetElement(self.m_root,"txtCondition"..i.."_CellWakeupTask",WZUILabelTTF):setScale(0.8)

        local txtBtnGoto = GetElement(self.m_root, "txtBtnGoto" .. i .. "_CellWakeupTask", WZUILabelTTF)
        if txtBtnGoto then
            txtBtnGoto:setScale(0.45)
        end
    end
    for i = 1, 5 do
        local txtCheck11 = GetElement(self.m_root, "txtCheck" .. i .. "_1_CellWakeupTask", WZUILabelTTF)
        if txtCheck11 then
            txtCheck11:setScale(0.8)
        end
        local txtCheck12 = GetElement(self.m_root, "txtCheck" .. i .. "_2_CellWakeupTask", WZUILabelTTF)
        if txtCheck12 then
            txtCheck12:setScale(0.8)
        end
    end
end

function CellWakeupTask:_adaptLanguage_ug(  )
    for i = 1, 4 do
        local txtCheck11 = GetElement(self.m_root, "txtCheck" .. i .. "_1_CellWakeupTask", WZUILabelTTF)
        if txtCheck11 then
            txtCheck11:setScale(0.6)
            txtCheck11:setDimensions(GlobalMethod:CCSize(180))
        end
        local txtCheck12 = GetElement(self.m_root, "txtCheck" .. i .. "_2_CellWakeupTask", WZUILabelTTF)
        if txtCheck12 then
            txtCheck12:setScale(0.6)
            txtCheck12:setDimensions(GlobalMethod:CCSize(180))
        end
    end

    local txtForDesc = GetElement(self.m_root,"txtForDesc_CellWakeupTask",WZUILabelTTF)
    txtForDesc:setRelativePosition(GlobalMethod:ccp(0.94,0.866666))

    for i=1,3 do
        local txtCondition = GetElement(self.m_root,"txtCondition"..i.."_CellWakeupTask",WZUILabelTTF)
        txtCondition:setFontSize(16)
        txtCondition:setDimensions(GlobalMethod:CCSize(540,0))
    end
    
    local txtAfterWakeup = GetElement(self.m_root,"txtAfterWakeup_CellWakeupTask",WZUILabelTTF)
    txtAfterWakeup:setScale(0.7)
    txtAfterWakeup:setDimensions(GlobalMethod:CCSize(180))
end
-------------------------------------语言适配End--------------------------------------------