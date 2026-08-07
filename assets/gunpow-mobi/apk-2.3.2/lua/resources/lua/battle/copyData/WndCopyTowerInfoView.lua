--WndCopyTowerInfoView.lua
--@brief	WndCopyTowerInfoView的UI模块
--@date		2015/09/09
--@author	mbq
--@note		爬塔


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCopyTowerInfoView:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndCopyTowerInfoView:onExit(element)
    self:_unInit()
    self:_removeEvent()
end

----@brief onEnter函数执行完成回调
function WndCopyTowerInfoView:onEnterTransitionDidFinish(element)
    --body
    self:_initUI()
    self:_updateLabelPos()
    self:initAllInfo()
    if self.m_nWinType == 1 then 
    else
        self:_initEvent()
        -- self:_updatePlayerHpView(100)
        -- self:_updatePlayerAttRoundView(0)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 初始化ui
function WndCopyTowerInfoView:_initUI()
    self.m_tRemainHpTitleLab = GetElement(self.m_root, "remainHpTitle_WndCopyTowerInfoView", WZUILabelTTF)
    self.m_tAttRoundTitleLab = GetElement(self.m_root, "attRoundTitle_WndCopyTowerInfoView", WZUILabelTTF)
    self.m_tOtherTitleLab = GetElement(self.m_root, "otherTitle_WndCopyTowerInfoView", WZUILabelTTF)

    self.m_tRemainHpLab = GetElement(self.m_root, "remainHp_WndCopyTowerInfoView", WZUILabelTTF)
    self.m_tAttRoundLab = GetElement(self.m_root, "attRound_WndCopyTowerInfoView", WZUILabelTTF)
    self.m_tOtherValue = GetElement(self.m_root, "otherValue_WndCopyTowerInfoView", WZUILabelTTF)

    local txtTowerDesc = GetElement(self.m_root, "txtTowerDesc_WndCopyTowerInfoView", WZUILabelTTF)
    txtTowerDesc:setText(LocalStrings.BATTLE_PASS)
    local conBg = GetElement(self.m_root, "conBg_WndCopyTowerInfoView", WZUIContainer)
    conBg:setAbsContentSize(GlobalMethod:CCSize(220,150))
    conBg:updateRelativeSize()
    self.m_tOtherTitleLab:setVisible(true)
    GetElement(self.m_root, "conLineThree_WndCopyTowerInfoView", WZUIContainer):setVisible(true)
    if self.m_nWinType == 1 then 
        txtTowerDesc:setText(LocalStrings.DOUBLETOWER_TEXT2 .. ":")
    end
end

--@brief 刷新位置
function WndCopyTowerInfoView:_updateLabelPos()
    if self.m_nWinType == 1 then 
    else
        -- local hpTile = tostring(self.m_tMapInfo.pass_hp)..LocalStrings.BATTLE_LEFT_HP
        -- self.m_tRemainHpTitleLab:setText(hpTile)
        
        -- local attTile = tostring(self.m_tMapInfo.pass_round)..LocalStrings.BATTLE_ATT_TIME
        -- self.m_tAttRoundTitleLab:setText(attTile)
    end
end

--@brief 刷新hp信息
function WndCopyTowerInfoView:_updatePlayerHpView(hpPrec)
    for i = 1, 3 do
        if type(self.m_tMapInfo["pass" .. i]) == "table" then 
            local tPass = self.m_tMapInfo["pass" .. i][1]
            local txtLabel
            local txtValue 
        
            if i == 1 then 
                txtLabel = self.m_tAttRoundTitleLab
                txtValue = self.m_tAttRoundLab
            elseif i == 2 then 
                txtLabel = self.m_tRemainHpTitleLab
                txtValue = self.m_tRemainHpLab
            elseif i == 3 then 
                txtLabel = self.m_tOtherTitleLab
                txtValue = self.m_tOtherValue
            end

            if tPass[1] == 1 then 
                local result = tostring(hpPrec)
                txtValue:setText(result)
                break 
            end
        end
    end
    
end

--@brief 刷新攻击回合
function WndCopyTowerInfoView:_updatePlayerAttRoundView(attRound)
    for i = 1, 3 do
        if type(self.m_tMapInfo["pass" .. i]) == "table" then 
            local tPass = self.m_tMapInfo["pass" .. i][1]
            local txtLabel
            local txtValue 
        
            if i == 1 then 
                txtLabel = self.m_tAttRoundTitleLab
                txtValue = self.m_tAttRoundLab
            elseif i == 2 then 
                txtLabel = self.m_tRemainHpTitleLab
                txtValue = self.m_tRemainHpLab
            elseif i == 3 then 
                txtLabel = self.m_tOtherTitleLab
                txtValue = self.m_tOtherValue
            end

            if tPass[1] == 2 then 
                local result = tostring(attRound)
                txtValue:setText(result)
                break 
            end
        end
    end
end

--@brief    初始化条件
function WndCopyTowerInfoView:initAllInfo()
    --body
    for i = 1, 3 do
        if type(self.m_tMapInfo["pass" .. i]) == "table" then 
            local tPass = self.m_tMapInfo["pass" .. i][1]
            local txtLabel
            local txtValue 
        
            if i == 1 then 
                txtLabel = self.m_tAttRoundTitleLab
                txtValue = self.m_tAttRoundLab
            elseif i == 2 then 
                txtLabel = self.m_tRemainHpTitleLab
                txtValue = self.m_tRemainHpLab
            elseif i == 3 then 
                txtLabel = self.m_tOtherTitleLab
                txtValue = self.m_tOtherValue
            end

            if tPass[1] == 6 or tPass[1] == 8 then 
                local skillName = WndDoubleTowerRoom:getSkillName(tPass[2])
                content = string.format(LocalStrings.DOUBLETOWER_TEXT6[tPass[1]], skillName)
            elseif tPass[1] == 11 then 
                content = LocalStrings.DOUBLETOWER_TEXT6[tPass[1]]
            else
                content = string.format(LocalStrings.DOUBLETOWER_TEXT6[tPass[1]], tPass[2])
            end
            if tPass[1] ~= 10 then 
                content = content .. ":"
                txtValue:setText(self.m_tOriginValue[tPass[1]])
            else
                txtValue:setText("")
            end
            txtLabel:setText(content)
        end
    end
end

--@brief    爬塔副本回合更新通关条件
--@param    conditionType:通关条件类型
function WndCopyTowerInfoView:updateCondition(conditionType, value)
    -- body
    if self.m_root == nil then return end 

    for i = 1, 3 do
        local txtValue 
        if i == 1 then 
            txtValue = self.m_tAttRoundLab
        elseif i == 2 then 
            txtValue = self.m_tRemainHpLab
        elseif i == 3 then 
            txtValue = self.m_tOtherValue
        end
        if type(self.m_tMapInfo["pass" .. i]) == "table" then 
            local tPass = self.m_tMapInfo["pass" .. i][1]
            if tPass[1] == conditionType then 
                if conditionType <= 5 then 
                    if conditionType == 1 or conditionType == 4 then 
                        txtValue:setText(value .. "%")
                    else
                        txtValue:setText(value)
                    end
                else
                    if conditionType == 6 then
                        local tempValue = 0 
                        if value ~= nil then 
                            for j = 1, #value do
                                local skillData = GDatatab_skill["id_" .. value[j]]
                                if skillData and skillData.skill_type ~= 6 and skillData.skill_type ~= 7 then 
                                    for k = 1, #self.m_tMapInfo["pass" .. i] do
                                        if skillData.sub_type == self.m_tMapInfo["pass" .. i][k][2] then
                                            tempValue = 1 
                                            break 
                                        end
                                    end
                                end
                                if tempValue == 1 then 
                                    break 
                                end
                            end
                        end

                        txtValue:setText(tempValue)
                    elseif conditionType == 8 then 
                        local tempValue = 0 
                        if value ~= nil then 
                            for j = 1, #value do
                                local skillData = GDatatab_skill["id_" .. value[j]]
                                if skillData and skillData.skill_type ~= 6 and skillData.skill_type ~= 7 then 
                                    for k = 1, #self.m_tMapInfo["pass" .. i] do
                                        if skillData.sub_type == self.m_tMapInfo["pass" .. i][k][2] then
                                            tempValue = 1 
                                            break 
                                        end
                                    end
                                end
                                if tempValue == 1 then 
                                    break 
                                end
                            end
                        end
                        
                        txtValue:setText(tempValue)
                    elseif conditionType == 9 then 
                        local tempValue = 0
                        if value ~= nil then 
                            for k = 1, #self.m_tMapInfo["pass" .. i] do
                                if value >= self.m_tMapInfo["pass" .. i][k][2] then
                                    tempValue = 1
                                    break 
                                end
                            end
                        end
                        txtValue:setText(tempValue)
                    elseif conditionType == 10 then 
                        -- local tempValue = 1
                        -- if value ~= nil then 
                        --     for k = 1, #self.m_tMapInfo["pass" .. i] do
                        --         if value < self.m_tMapInfo["pass" .. i][k][2] then
                        --             tempValue = 0 
                        --             txtValue:setText(tempValue)
                        --             break 
                        --         end
                        --     end
                        -- end
                    elseif conditionType == 11 then 
                        local tempValue = 0 
                        if value ~= nil then 
                            for j = 1, #value do
                                local skillData = GDatatab_skill["id_" .. value[j]]
                                if skillData and skillData.skill_type == 6 then 
                                    tempValue = 1 
                                    break 
                                end
                            end
                        end
                        
                        txtValue:setText(tempValue)
                    end
                end
            end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function WndCopyTowerInfoView:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtTowerDesc_WndCopyTowerInfoView",WZUILabelTTF):setFontSize(12)
end

function WndCopyTowerInfoView:_adaptLanguage_ug(  )
    local txtTowerDesc = GetElement(self.m_root,"txtTowerDesc_WndCopyTowerInfoView",WZUILabelTTF)
    txtTowerDesc:setScale(0.7)
    txtTowerDesc:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtTowerDesc:setRelativePosition(GlobalMethod:ccp(0.95,0.85))
    local attRoundTitle = GetElement(self.m_root,"attRoundTitle_WndCopyTowerInfoView",WZUILabelTTF)
    attRoundTitle:setScale(0.7)
    attRoundTitle:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    attRoundTitle:setRelativePosition(GlobalMethod:ccp(0.95,0.5))
    local remainHpTitle = GetElement(self.m_root,"remainHpTitle_WndCopyTowerInfoView",WZUILabelTTF)
    remainHpTitle:setScale(0.7)
    remainHpTitle:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    remainHpTitle:setRelativePosition(GlobalMethod:ccp(0.95,0.15))
    local attRound = GetElement(self.m_root,"attRound_WndCopyTowerInfoView",WZUILabelTTF)
    attRound:setScale(0.7)
    attRound:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    attRound:setRelativePosition(GlobalMethod:ccp(0.25,0.5))
    local remainHp = GetElement(self.m_root,"remainHp_WndCopyTowerInfoView",WZUILabelTTF)
    remainHp:setScale(0.7)
    remainHp:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    remainHp:setRelativePosition(GlobalMethod:ccp(0.17,0.15))
end

function WndCopyTowerInfoView:_adaptLanguage_vn(  )
    local txtTowerDesc = GetElement(self.m_root,"txtTowerDesc_WndCopyTowerInfoView",WZUILabelTTF)
    txtTowerDesc:setScale(0.7)
    local attRoundTitle = GetElement(self.m_root,"attRoundTitle_WndCopyTowerInfoView",WZUILabelTTF)
    attRoundTitle:setScale(0.7)
    local remainHpTitle = GetElement(self.m_root,"remainHpTitle_WndCopyTowerInfoView",WZUILabelTTF)
    remainHpTitle:setScale(0.7)
    local otherTitle = GetElement(self.m_root,"otherTitle_WndCopyTowerInfoView",WZUILabelTTF)
    otherTitle:setScale(0.7)
end
--------------------------------------语言适配End-------------------------------------------