--WndMonthFighting.lua
--@brief	WndMonthFighting的UI模块
--@date		2017/08/30
--@author	Tianxiang_Xu
--@note		开服活动-月战力榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMonthFighting:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMonthFighting:onExit(element)
	self:_unInit()
end

--@brief    点击关闭按钮时被调用的函数
--@param    element:按钮绑定的UI节点引用
function WndMonthFighting:OnClose(element)
    WZLog("WndMonthFighting:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

-- 查看段位奖励
function WndMonthFighting:onRank1()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:setCheckBoxAndCon(1)
    self:createMatchRank1()
end

-- 查看排名奖励
function WndMonthFighting:onRank2()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:setCheckBoxAndCon(2)
    self:createMatchRank2()
end

-- 查看鲜花榜记录
function WndMonthFighting:onRank3()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:setCheckBoxAndCon(3)
    self:createMatchRank3()
end

function WndMonthFighting:onClickRewardItem(luaObject,data)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndItemInfo:showInfo(luaObject.m_root,self.m_root,1,data,false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 设置checkbox的状态以及显示的容器
function WndMonthFighting:setCheckBoxAndCon(tag)
    self.titleIndex = tag
    for i = 1, 3 do
        local conCheck = GetElement(self.m_root,"conCheck"..i.."_WndMonthFighting",WZUIContainer)
        conCheck:setVisible(i==tag)
    end

    if tag == 3 then
        GetElement(self.m_root,"tabFlower_WndMonthFighting",WZUITableContainer):setVisible(true)
        GetElement(self.m_root,"tabReward_WndMonthFighting",WZUITableContainer):setVisible(false)
    else
        GetElement(self.m_root,"tabFlower_WndMonthFighting",WZUITableContainer):setVisible(false)
        GetElement(self.m_root,"tabReward_WndMonthFighting",WZUITableContainer):setVisible(true)
    end

    local str = {LocalStrings.RANK,LocalStrings.COMMUNITYWARGIFT_TEXT4,LocalStrings.SPACE3}
    local txtTitle = GetElement(self.m_root,"txtTitle_WndMonthFighting",WZUILabelTTF)
    txtTitle:setText(str[tag])
end

--@brief    创建排名列表
function WndMonthFighting:createMatchRank1()
    -- body
    if self.m_tRankList == nil then 
        self:_createLoading()
        if self.activityId then
            if self.activityId == g_tGameActivityTypes.ACIVIITY_RECHARGERANK then
                ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord(38) --38为本服充值榜
                return
            elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK then
                ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord(39) --39为跨服充值榜
                return
            elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CONSUMERANK then
                ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord(40) --40为本服消费榜
                return
            elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK then
                ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord(41) --41为跨服消费榜
                return
            elseif self.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
                if self.nFlowerSex == 0 or self.nFlowerSex == nil then
                    ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord(46)  --46为鲜花榜男
                elseif self.nFlowerSex == 1 then
                    ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord(47)  --47为鲜花榜女
                end
                return
            else
                ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord(1) --1为战力榜
                return
            end
        end 
    end
    if self.m_nMyRank == nil then 
        self:_createLoading()
        if self.activityId then
            if self.activityId == g_tGameActivityTypes.ACIVIITY_RECHARGERANK then
                ProtocolProcessorWndActivityOnLine:send_RANK_GetPlayerRank(38) --38为本服充值榜
                return
            elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK then
                ProtocolProcessorWndActivityOnLine:send_RANK_GetPlayerRank(39) --39为跨服充值榜
                return
            elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CONSUMERANK then
                ProtocolProcessorWndActivityOnLine:send_RANK_GetPlayerRank(40) --40为本服消费榜
                return
            elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK then
                ProtocolProcessorWndActivityOnLine:send_RANK_GetPlayerRank(41) --41为跨服消费榜
                return
            elseif self.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
                ProtocolProcessorWndActivityOnLine:send_RANK_GetPlayerRank(42)  --46为鲜花榜男
                return
            else
                ProtocolProcessorWndActivityOnLine:send_RANK_GetPlayerRank(1) --1为战力榜
                return
            end
        end
    end

    --
    local tab = GetElement(self.m_root,"tabReward_WndMonthFighting",WZUITableContainer)
    tab:cleanTable()
    local conList = GetElement(self.m_root, "conList_WndMonthFighting", WZUIContainer)
    if #self.m_tRankList == 0 then 
        ShowPanelNullTip( conList, LocalStrings.CHARM_RESULT)
        return 
    end
    removeShowPanelNullTip(conList)

    tab:setCellElementHeight(0.215)
    for i = 1, #self.m_tRankList do
        local t = self.m_tRankList[i]
        --创建cell
        local cellElement, tCell= CellRankFighting:createElement()
        cellElement:setScale(1.1)
        --设置Cell标志
        cellElement:setTag(i - 1)
        --Cell添加到table
        tab:setCellElement(cellElement)
        --初始化cell
        if self.activityId == g_tGameActivityTypes.ACIVIITY_RECHARGERANK then
            tCell:setData(t.ranking, t.playerId, t.name, t.faceId, t.headId, t.sex, t.level, t.param1, t.param2, t.param3, t.param4, t.param5, t.param6, t.param7, 38, t.trendRank, t.vipLevel, t.param8, t.headColor, t.param9)
        elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK then
            tCell:setData(t.ranking, t.playerId, t.name, t.faceId, t.headId, t.sex, t.level, t.param1, t.param2, t.param3, t.param4, t.param5, t.param6, t.param7, 39, t.trendRank, t.vipLevel, t.param8, t.headColor, t.param9)
        elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CONSUMERANK then
            tCell:setData(t.ranking, t.playerId, t.name, t.faceId, t.headId, t.sex, t.level, t.param1, t.param2, t.param3, t.param4, t.param5, t.param6, t.param7, 40, t.trendRank, t.vipLevel, t.param8, t.headColor, t.param9)
        elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK then
            tCell:setData(t.ranking, t.playerId, t.name, t.faceId, t.headId, t.sex, t.level, t.param1, t.param2, t.param3, t.param4, t.param5, t.param6, t.param7, 41, t.trendRank, t.vipLevel, t.param8, t.headColor, t.param9)
        elseif self.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
            if self.nFlowerSex == 0 or self.nFlowerSex == nil then
                tCell:setData(t.ranking, t.playerId, t.name, t.faceId, t.headId, t.sex, t.level, t.param1, t.param2, t.param3, t.param4, t.param5, t.param6, t.param7, 46, t.trendRank, t.vipLevel, t.param8, t.headColor, t.param9)
            elseif self.nFlowerSex == 1 then
                tCell:setData(t.ranking, t.playerId, t.name, t.faceId, t.headId, t.sex, t.level, t.param1, t.param2, t.param3, t.param4, t.param5, t.param6, t.param7, 47, t.trendRank, t.vipLevel, t.param8, t.headColor, t.param9)
            end
        else
            tCell:setData(t.ranking, t.playerId, t.name, t.faceId, t.headId, t.sex, t.level, t.param1, t.param2, t.param3, t.param4, t.param5, t.param6, t.param7, 1, t.trendRank, t.vipLevel, t.param8, t.headColor, t.param9)
        end
    end

    --我的排名
    GetElement(self.m_root,"ftxtEndTime_WndMonthFighting",WZUIFreeTextBox):setVisible(false)
    local sContent = string.format(LocalStrings.MY_PVPRANK, tostring(self.m_nMyRank))
    if self.m_nMyRank == -1 then
        sContent = string.format(LocalStrings.MY_PVPRANK, LocalStrings.NOT_IN_RANKLIST)
    end
    local ftxtMyRank = GetElement(self.m_root,"ftxtMyRank_WndMonthFighting",WZUIFreeTextBox)
    ftxtMyRank:setVisible(true)
    ftxtMyRank:setShowText(sContent)
end

-- 创建排名奖励
function WndMonthFighting:createMatchRank2()
    if self.activityId == g_tGameActivityTypes.ACIVIITY_RECHARGERANK or self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK or 
        self.activityId == g_tGameActivityTypes.ACIVIITY_CONSUMERANK or self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK or
        self.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
        self:initRankReward1()
    else
        self:initRankReward()
    end

    local conList = GetElement(self.m_root, "conList_WndMonthFighting", WZUIContainer)
    removeShowPanelNullTip(conList)

    local tab = GetElement(self.m_root,"tabReward_WndMonthFighting",WZUITableContainer)
    tab:cleanTable()
    tab:setCellElementHeight(0.25)

    for i = 1, #self.m_tRankReward do
        local cell,tcell = CellPvpRankList:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(self.m_tRankReward[i])
        tcell:setCallFunc(self,self.onClickRewardItem)
    end

    GetElement(self.m_root,"ftxtMyRank_WndMonthFighting",WZUIFreeTextBox):setVisible(false)
    local ftxtEndTime = GetElement(self.m_root,"ftxtEndTime_WndMonthFighting",WZUIFreeTextBox)
    local sFormat = [[<T C="79,60,48" S="18" P="1">%s</T>]]
    ftxtEndTime:setVisible(true)
    ftxtEndTime:setShowText(string.format(sFormat, LocalStrings.NEWACTIVITY_TEXT13))
end

--@brief    创建鲜花榜记录
function WndMonthFighting:createMatchRank3()
    if not self.tabFlowerRecord then
        if self.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
            ProtocolProcessorBase:send_ACTIVITY_GetFlowerActivityInfo()
            return
        end
    end

    local tabFlower = GetElement(self.m_root,"tabFlower_WndMonthFighting",WZUITableContainer)
    tabFlower:cleanTable()
    local conList = GetElement(self.m_root, "conList_WndMonthFighting", WZUIContainer)
    if #self.tabFlowerRecord.playerData == 0 then 
        ShowPanelNullTip( conList, LocalStrings.CHARM_RESULT)
        return 
    end
    removeShowPanelNullTip(conList)

    local playerNum = math.min(#self.tabFlowerRecord.playerData,20)
    for i=1, playerNum do
        local cell,tcell = CellSpaceRecord:createElement()
        cell:setTag(i-1)
        tabFlower:setCellElement(cell)
        tcell["setFlowerRecord"](tcell,self.tabFlowerRecord.playerData[i])
    end

    local stringFormat = [[<T C="62,34,8" S="20" P="0">%s:</T><T C="128,54,13" S="20" P="0">%d</T>]]
    local ftxtMyRank = GetElement(self.m_root,"ftxtMyRank_WndMonthFighting",WZUIFreeTextBox)
    ftxtMyRank:setVisible(true)
    ftxtMyRank:setShowText(string.format(stringFormat,LocalStrings.SPACE11,self.tabFlowerRecord.time))
    local ftxtEndTime = GetElement(self.m_root,"ftxtEndTime_WndMonthFighting",WZUIFreeTextBox)
    ftxtEndTime:setVisible(true)
    ftxtEndTime:setShowText(string.format(stringFormat,LocalStrings.NUMBER_OF_FLOWERS_RECEIVED,self.tabFlowerRecord.time))
end

-------------------------------------私有方法模块End----------------------------------------
