--WndVSRecord.lua
--@brief	WndVSRecord的UI模块
--@date		2017/02/22
--@author	Tianxiang_Xu
--@note		比赛回顾界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndVSRecord:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndVSRecord:onExit(element)
	self:_unInit()
end

--@brief    点击下一组按钮回调
function WndVSRecord:onNextPage(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nRecordType == 1 then
        if self.m_nGroupSelIndex < 4 then
            self.m_nGroupSelIndex = self.m_nGroupSelIndex + 1 
            self:_update()
        end
    end
end

--@brief    点击上一组按钮回调
function WndVSRecord:onLastPage(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nRecordType == 1 then
        if self.m_nGroupSelIndex > 1 then
            self.m_nGroupSelIndex = self.m_nGroupSelIndex - 1 
            self:_update()
        end
    end
end

--@brief    点击关闭按钮回调
function WndVSRecord:onBtnReturn(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function WndVSRecord:_update()
    -- body
    local tData = self.m_tData 
    local conGroupMark = GetElement(self.m_root, "conGroupMark_WndVSRecord", WZUIContainer)
    local btnNext = GetElement(self.m_root, "btnNext_WndVSRecord", WZUIButton)
    local btnLast = GetElement(self.m_root, "btnLast_WndVSRecord", WZUIButton)
    local txtGroupMark = GetElement(self.m_root, "txtGroupMark_WndVSRecord", WZUILabelTTF)

    if self.m_nRecordType == 1 then
        conGroupMark:setVisible(true)
        if self.m_nGroupSelIndex == 1 then
            btnLast:setVisible(false)
            btnNext:setVisible(true)
            txtGroupMark:setText("A" .. LocalStrings.COMMUNITY_COMPETE_TEXT22)
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
                txtGroupMark:setText(LocalStrings.COMMUNITY_COMPETE_TEXT22.." A")
            end
        elseif self.m_nGroupSelIndex == 2 then
            btnLast:setVisible(true)
            btnNext:setVisible(true)
            txtGroupMark:setText("B" .. LocalStrings.COMMUNITY_COMPETE_TEXT22)
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
                txtGroupMark:setText(LocalStrings.COMMUNITY_COMPETE_TEXT22.." B")
            end
        elseif self.m_nGroupSelIndex == 3 then
            btnLast:setVisible(true)
            btnNext:setVisible(true)
            txtGroupMark:setText("C" .. LocalStrings.COMMUNITY_COMPETE_TEXT22)
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
                txtGroupMark:setText(LocalStrings.COMMUNITY_COMPETE_TEXT22.." C")
            end
        elseif self.m_nGroupSelIndex == 4 then
            btnLast:setVisible(true)
            btnNext:setVisible(false)
            txtGroupMark:setText("D" .. LocalStrings.COMMUNITY_COMPETE_TEXT22)
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
                txtGroupMark:setText(LocalStrings.COMMUNITY_COMPETE_TEXT22.." D")
            end
        end

        self:_createGroupVSList()
    else
        conGroupMark:setVisible(false)

        self:_createFinalVSList()
    end
end

--@brief    创建小组赛记录列表
function WndVSRecord:_createGroupVSList()
    -- body
    local tGroupData = self.m_tData[self.m_nGroupSelIndex]
    local tabVideo = GetElement(self.m_root, "tabVideo_WndVSRecord", WZUITableContainer)
    tabVideo:cleanTable()

    local nCurDay = SceneCommunityWar:getCurDay(SceneCommunityWar.m_sCommunityTime)
    local nTag = 0 
    if nCurDay >= 15 then
        for i = 1, #tGroupData, 2 do
            if tGroupData[i].guildResult > 1 or tGroupData[i + 1].guildResult > 1 then
                local celElement, tNewObj = CellGuildVSRecord:createElement()
                if celElement and tNewObj then
                    tNewObj:setData(tGroupData[i], tGroupData[i + 1], self.m_nGroupSelIndex, self.m_nGroupSelIndex, 1)
                    tNewObj:setCallBackFunc(SceneCommunityWar, SceneCommunityWar.onCheckCommunityInfo, SceneCommunityWar.onClickCheck)
                    celElement:setTag(nTag)
                    tabVideo:setCellElement(celElement)

                    nTag = nTag + 1
                end
            end
        end
        local conForList = GetElement(self.m_root, "conForList_WndVSRecord", WZUIContainer)
        if nTag == 0 then
            ShowPanelNullTip(conForList)
            return 
        end
        removeShowPanelNullTip(conForList)
    end
    if nCurDay >= 16 then
        local tTempData = {}
        --前4个公会中晋级的两个
        for i = 1, #tGroupData / 2 do
            if #tTempData < 2 then
                if tGroupData[i].guildId ~= -1 and tGroupData[i].guildResult > 1 then
                    table.insert(tTempData, tGroupData[i])
                elseif tGroupData[i].guildId == -1 then
                    table.insert(tTempData, tGroupData[i])
                end
            else
                break
            end
        end
        if (tTempData[1] and tTempData[1].guildResult > 2) or (tTempData[2] and tTempData[2].guildResult > 2) then
            local celElement, tNewObj = CellGuildVSRecord:createElement()
            if celElement and tNewObj then
                tNewObj:setData(tTempData[1], tTempData[2], self.m_nGroupSelIndex, self.m_nGroupSelIndex, 2)
                tNewObj:setCallBackFunc(SceneCommunityWar, SceneCommunityWar.onCheckCommunityInfo, SceneCommunityWar.onClickCheck)
                celElement:setTag(nTag)
                tabVideo:setCellElement(celElement)

                nTag = nTag + 1
            end
        end
        --后4个公会中晋级的两个
        tTempData = {}
        for i = 5, #tGroupData do
            if #tTempData < 2 then
                if tGroupData[i].guildId ~= -1 and tGroupData[i].guildResult > 1 then
                    table.insert(tTempData, tGroupData[i])
                elseif tGroupData[i].guildId == -1 then
                    table.insert(tTempData, tGroupData[i])
                end
            else
                break
            end
        end
        if (tTempData[1] and tTempData[1].guildResult > 2) or (tTempData[2] and tTempData[2].guildResult > 2) then
            local celElement, tNewObj = CellGuildVSRecord:createElement()
            if celElement and tNewObj then
                tNewObj:setData(tTempData[1], tTempData[2], self.m_nGroupSelIndex, self.m_nGroupSelIndex, 2)
                tNewObj:setCallBackFunc(SceneCommunityWar, SceneCommunityWar.onCheckCommunityInfo, SceneCommunityWar.onClickCheck)
                celElement:setTag(nTag)
                tabVideo:setCellElement(celElement)

                nTag = nTag + 1
            end
        end
    end
    if nCurDay >= 17 then
        local tTempData = {}
        --前4个公会中晋级的一个
        for i = 1, #tGroupData / 2 do
            if #tTempData == 0 then
                if tGroupData[i].guildId ~= -1 and tGroupData[i].guildResult > 2 then
                    table.insert(tTempData, tGroupData[i])
                elseif tGroupData[i].guildId == -1 then
                    table.insert(tTempData, tGroupData[i])
                end
            else
                break
            end
        end
        --后4个公会中晋级的一个
        for i = 5, #tGroupData do
            if #tTempData == 1 then
                if tGroupData[i].guildId ~= -1 and tGroupData[i].guildResult > 2 then
                    table.insert(tTempData, tGroupData[i])
                elseif tGroupData[i].guildId == -1 then
                    table.insert(tTempData, tGroupData[i])
                end
            else
                break
            end
        end
        if (tTempData[1] and tTempData[1].guildResult > 3) or (tTempData[2] and tTempData[2].guildResult > 3) then
            local celElement, tNewObj = CellGuildVSRecord:createElement()
            if celElement and tNewObj then
                tNewObj:setData(tTempData[1], tTempData[2], self.m_nGroupSelIndex, self.m_nGroupSelIndex, 3)
                tNewObj:setCallBackFunc(SceneCommunityWar, SceneCommunityWar.onCheckCommunityInfo, SceneCommunityWar.onClickCheck)
                celElement:setTag(nTag)
                tabVideo:setCellElement(celElement)
            end
        end
    end
end

--@brief    创建决赛回顾列表
function WndVSRecord:_createFinalVSList()
    -- body
    local tFinalData = self.m_tData
    local tabVideo = GetElement(self.m_root, "tabVideo_WndVSRecord", WZUITableContainer)
    tabVideo:cleanTable()

    local nCurDay = SceneCommunityWar:getCurDay(SceneCommunityWar.m_sCommunityTime)
    local nTag = 0 
    if nCurDay >= 18 then
        for i = 1, #tFinalData, 2 do
            if tFinalData[i].guildResult > 4 or tFinalData[i + 1].guildResult > 4 then
                local celElement, tNewObj = CellGuildVSRecord:createElement()
                if celElement and tNewObj then
                    tNewObj:setData(tFinalData[i], tFinalData[i + 1], i, i + 1, 4)
                    tNewObj:setCallBackFunc(SceneCommunityWar, SceneCommunityWar.onCheckCommunityInfo, SceneCommunityWar.onClickCheck)
                    celElement:setTag(nTag)
                    tabVideo:setCellElement(celElement)

                    nTag = nTag + 1
                end
            end
        end
        local conForList = GetElement(self.m_root, "conForList_WndVSRecord", WZUIContainer)
        if nTag == 0 then
            ShowPanelNullTip(conForList)
            return 
        end
        removeShowPanelNullTip(conForList)
    end
    if nCurDay >= 19 then
        local tTempData = {}
        local tGroupIndex = {}
        --前4个公会中晋级的一个
        for i = 1, #tFinalData do
            if #tTempData < 2 then
                if tFinalData[i].guildResult == 5 or tFinalData[i].guildResult == 7 or tFinalData[i].guildResult == 8 then
                    table.insert(tTempData, tFinalData[i])
                    table.insert(tGroupIndex, i)
                end
            else
                break
            end
        end
        if (tTempData[1] and tTempData[1].guildResult > 5) or (tTempData[2] and tTempData[2].guildResult > 5) then
            local celElement, tNewObj = CellGuildVSRecord:createElement()
            if celElement and tNewObj then
                tNewObj:setData(tTempData[1], tTempData[2], tGroupIndex[1], tGroupIndex[2], 5)
                tNewObj:setCallBackFunc(SceneCommunityWar, SceneCommunityWar.onCheckCommunityInfo, SceneCommunityWar.onClickCheck)
                celElement:setTag(nTag)
                tabVideo:setCellElement(celElement)

                nTag = nTag + 1
            end
        end
    end
    if nCurDay >= 20 then
        local tTempData = {}
        local tGroupIndex = {}
        --前4个公会中晋级的一个
        for i = 1, #tFinalData do
            if #tTempData < 2 then
                if tFinalData[i].guildResult == 6 or tFinalData[i].guildResult == 9 or tFinalData[i].guildResult == 10 then
                    table.insert(tTempData, tFinalData[i])
                    table.insert(tGroupIndex, i)
                end
            else
                break
            end
        end
        if (tTempData[1] and tTempData[1].guildResult > 6) or (tTempData[2] and tTempData[2].guildResult > 6) then
            local celElement, tNewObj = CellGuildVSRecord:createElement()
            if celElement and tNewObj then
                tNewObj:setData(tTempData[1], tTempData[2], tGroupIndex[1], tGroupIndex[2], 6)
                tNewObj:setCallBackFunc(SceneCommunityWar, SceneCommunityWar.onCheckCommunityInfo, SceneCommunityWar.onClickCheck)
                celElement:setTag(nTag)
                tabVideo:setCellElement(celElement)

                nTag = nTag + 1
            end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
