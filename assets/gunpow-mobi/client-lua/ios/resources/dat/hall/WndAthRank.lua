--WndAthRank.lua
--@brief	WndAthRank的UI模块
--@date		2015-6-6
--@author	binshao
--@note		竞技场奖励

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAthRank:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    ProtocolProcessorWndRankList:regAll()
    self:initRankLvLimit()
end

--@brief    弹窗动画完成后的回调
function WndAthRank:actionCallback()
    WZLog("WndAthRank:actionCallback")

    self:_sendRankRecordBytype()

    ProtocolProcessorSceneHall:send_ROOM_GetTournamentAim(1)
end

--@brief onEnter函数执行完成回调
function WndAthRank:onEnterTransitionDidFinish(element)
   self:actionCallback()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAthRank:onExit(element)
    ProtocolProcessorWndRankList:unregAll()
    self:_unInit()
end

--@brief	关闭整个窗口的动画效果
function WndAthRank:onReturnActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , WndAthRank , true)
end

--@brief	关闭设置界面btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndAthRank:onBtnReturn( element )
	WZLog("sun---WndAthRank:onBtnCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManagerAni:createCloseAction(self.m_root,"onReturnActionCallback",self)
end

-- 点击checkBox
function WndAthRank:onCheckBox(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local  tag = element:getTag()
    self.checkIndex = tag
    self:update(tag)
end

function WndAthRank:onSelRank(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local  tag = element:getTag()
    if self.topIndex == tag then return end
    self.topIndex = tag
    self:update(self.checkIndex)
end

function WndAthRank:onCheckServiceType(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local  tag = element:getTag()
    WZLog("WndAthRank:onCheckServiceType ",tag)
    if self.rankType == tag then return end
    self.rankType = tag
    -- if tag == 2 then
    --     ProtocolProcessorWndRankList:send_RANK_GetRankRecord(24)
    --     ProtocolProcessorWndRankList:send_RANK_GetRankRecord(25)
    --     ProtocolProcessorWndRankList:send_RANK_GetRankRecord(28)
    --     ProtocolProcessorWndRankList:send_RANK_GetRankRecord(42)

    --     ProtocolProcessorWndRankList:send_RANK_GetRankRecord(29)
    --     ProtocolProcessorWndRankList:send_RANK_GetRankRecord(30)
    --     ProtocolProcessorWndRankList:send_RANK_GetRankRecord(31)
    --     ProtocolProcessorWndRankList:send_RANK_GetRankRecord(43)
    -- else
        self:update()
    -- end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin-------------------------------------

function WndAthRank:_sendRankRecordBytype( )
    if self.rankType == 1 then
        if self.checkIndex == 1 then
            if not self.tab_SendRecord[1] then
                self.tab_SendRecord[1] = true
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(32)
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(33)
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(34)
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(44)
            end
        elseif self.checkIndex == 3 then
            if not self.tab_SendRecord[2] then
                self.tab_SendRecord[2] = true
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(35)
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(36)
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(37)
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(45)
            end
        end
    elseif self.rankType == 2 then
        if self.checkIndex == 1 then
            if not self.tab_SendRecord[3] then
                self.tab_SendRecord[3] = true
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(24)
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(29)
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(28)
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(42)
            end
        elseif self.checkIndex == 3 then
            if not self.tab_SendRecord[4] then
                self.tab_SendRecord[4] = true
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(25)
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(30)
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(31)
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(43)
            end
        end
    end
end

function WndAthRank:update(tag)
    if tag == nil then
        tag = self.checkIndex
    end
    WZLog("WndAthRank:update = ",tag)
    -- 右边标签页处理
    for i = 1, 3 do
        local conCheck = GetElement(self.m_root,"conCheck"..i.."_WndAthRank",WZUIContainer)
        conCheck:setVisible(i == tag)
    end

    self:_sendRankRecordBytype( )

    for i = 1, 4 do
            -- 上面的标签默认自己的排行区间
        local index = i == self.topIndex and 1 or 0
        local check = GetElement(self.m_root,"checkRank"..i.."_WndAthRank",WZUICheckBox)
        check:setCheckIndex(index)
    end

    self:changeConVisible(tag)

    -- 显示对于的伤害排行榜
    if tag == 1 then
        self:initRankTab()
    elseif tag == 2 then
        self:initReward()
    elseif tag == 3 then
        self:initLastRankTab()
    else
    end
end

-- checkbox的点击设置
function WndAthRank:changeConVisible(tag)
    WZLog("WndAthRank:changeConVisible",tag)
    -- 控制容器显示
    for i = 1, 3 do
        local con = GetElement(self.m_root,"conTab"..i.."_WndAthRank",WZUIContainer)
        con:setVisible(tag == i)
    end

    -- 控制底部和标题显示
    self:updateBottomInfo(tag)
end

-- 底部显示语更新
function WndAthRank:updateBottomInfo(tag)
    WZLog("WndAthRank:updateBottomInfo = ",tag)
    -- 标题
    local title = {LocalStrings.ATH_DESC_1,LocalStrings.ATH_DESC_2,LocalStrings.ATH_DESC_4 }
    local txtTitle = GetElement(self.m_root,"txtTitle_WndAthRank",WZUILabelTTF)
    txtTitle:setText(title[tag])

    -- 底部可见性
    for i = 1, 3 do
        local conRank = GetElement(self.m_root,"conRank"..i.."_WndAthRank",WZUIContainer)
        conRank:setVisible(i == tag)
    end

    -- 排行榜等级区间
    local Index = (self.topIndex-1)*2 + 1
    local startLv = tonumber(self.rankLvLimit[Index])
    local endLv = tonumber(self.rankLvLimit[Index+1])
    local desc = {LocalStrings.ATH_DESC13,LocalStrings.ATH_DESC14,LocalStrings.ATH_DESC15 }
    -- 说明
    if tag == 1 then
        -- 周日刷新提示
        local txtDesc = GetElement(self.m_root,"ftbRankDesc_WndAthRank",WZUIFreeTextBox)
        txtDesc:setShowText(LocalStrings.ATH_DESC_8)

        -- 我的排名
        local ftbMyRank = GetElement(self.m_root,"ftbMyRank_WndAthRank",WZUIFreeTextBox)
        if self.myRank == nil or self.myRank.rank == 0 then
            ftbMyRank:setShowText(LocalStrings.ATH_DESC19)
        else
            if self.myRankIndex == self.topIndex then
                ftbMyRank:setShowText(string.format(LocalStrings.ATH_DESC20,tostring(self.myRank.rank)))
            else
                local str = {LocalStrings.ATH_DESC21,LocalStrings.ATH_DESC22,LocalStrings.ATH_DESC23 }
                ftbMyRank:setShowText(str[self.myRankIndex])
            end
        end

        -- 排行榜等级区间
        local txtRankLv = GetElement(self.m_root,"txtRankLv_WndAthRank",WZUILabelTTF)
        if self.topIndex <= 3 then
            txtRankLv:setText(string.format(desc[self.topIndex],startLv,endLv))
            txtRankLv:setVisible(true)
        else
            txtRankLv:setVisible(false)
        end
    elseif tag == 2 then
        local txtSend = GetElement(self.m_root,"ftbReward_WndAthRank",WZUIFreeTextBox)
        txtSend:setShowText(LocalStrings.ATH_REWARD_SEND1)

        local txtRankLv = GetElement(self.m_root,"txtRankLv2_WndAthRank",WZUILabelTTF)
        if self.topIndex <= 3 then
            txtRankLv:setText(string.format(desc[self.topIndex],startLv,endLv))
            txtRankLv:setVisible(true)
        else
            txtRankLv:setVisible(false)
        end
    elseif tag == 3 then
        local ftbLast = GetElement(self.m_root,"ftbLast_WndAthRank",WZUIFreeTextBox)
        ftbLast:setShowText(LocalStrings.ATH_DESC_5)

        local txtRankLv = GetElement(self.m_root,"txtRankLv3_WndAthRank",WZUILabelTTF)
        if self.topIndex <= 3 then
            txtRankLv:setText(string.format(desc[self.topIndex],startLv,endLv))
            txtRankLv:setVisible(true)
        else
            txtRankLv:setVisible(false)
        end
    end
end

------------------------------------动态滑动公共接口---------------------------------------

-- 判断列表是否为空，空列表显示空的提示语
function WndAthRank:_judgeTabEmpty(dataTab,descTxt)
    local state = true
    if dataTab and #dataTab > 0 then
        state = false
    end
    if descTxt then
        descTxt:setVisible(state)
    end

    return state
end


---------------------------------------今日排行-----------------------------------------------

-- 初始化tab
function WndAthRank:initRankTab()
	WZLog("WndAthRank:initRankTab")
    local txt = GetElement(self.m_root,"txtEmpty1_WndAthRank",WZUILabelTTF)
    local indexx = self.topIndex 
    if self.rankType == 1 then
        indexx = indexx + 4
    end
    local rankInfoList = self.rankInfo[indexx]
    local empty = self:_judgeTabEmpty(rankInfoList,txt)
    self:createRank()
end


-- 创建排行
function WndAthRank:createRank()
    WZLog("WndAthRank:createRank")
    local tabR = GetElement(self.m_root,"tabRank_WndAthRank",WZUITableContainer)
    tabR:cleanTable()
    local indexx = self.topIndex
    if self.rankType == 1 then
        WZLog("self.rankType",self.rankType)
        indexx = indexx + 4
    end
    local data = self.rankInfo[indexx]
    WZLog("adklsjfl = ",indexx,Serialize(data))
    if data == nil or #data == 0 then return end
    for i = 1, #data do
        local info = data[i]
        if info then
            local cell,tcell = CellAthRank:createElement()
            cell:setTag(i-1)
            tabR:setCellElement(cell)
            tcell:setData(info)
        end
    end
end

---------------------------------------昨日排行-----------------------------------------------

-- 初始化历史排行榜
function WndAthRank:initLastRankTab()
    local txt = GetElement(self.m_root,"txtEmpty2_WndAthRank",WZUILabelTTF)
    local indexx = self.topIndex
    if self.rankType == 1 then
        indexx = indexx+ 4
    end
    local data = self.lastInfo[indexx]
    local empty = self:_judgeTabEmpty(data,txt)
    self:createLastRank()
end


-- 创建历史排行榜
function WndAthRank:createLastRank()
    local tabLast = GetElement(self.m_root,"tabLast_WndAthRank",WZUITableContainer)
    tabLast:cleanTable()
    local indexx = self.topIndex
    if self.rankType == 1 then
        indexx = indexx + 4
    end
    local data = self.lastInfo[indexx]
    if data == nil or #data == 0 then return end
    for i = 1, #data do
        local info = data[i]
        if info then
            local cell,tcell = CellAthRank:createElement()
            cell:setTag(i-1)
            tabLast:setCellElement(cell)
            tcell:setData(info)
        end
    end
end

-----------------------------------------排行奖励--------------------------------------------

-- 动态创建奖励信息
function WndAthRank:initReward()
    self:initRewardData()
    self:createReward()
end


-- 奖励列表
function WndAthRank:createReward()
    local tabR = GetElement(self.m_root,"tabReward_WndAthRank",WZUITableContainer)
    tabR:cleanTable()
    local indexx = self.topIndex
    if self.rankType == 1 then
        indexx = indexx + 4
    end
    if indexx >= 5 and indexx <=7 then
        indexx = indexx - 1
    elseif indexx == 8 then
        indexx = 7
    elseif indexx == 4 then
        indexx = 8
    end
    WZLog("indexxx = ",indexx)
    local reward = self.rewardInfo[indexx]
    for i = 1, #reward do
        local data = reward[i]
        if data then
            local cell,tcell = CellAthRankReward:createElement()
            cell:setTag(i-1)
            tabR:setCellElement(cell)
            tcell:setData(data)
        end
    end
end

------------------------------------------我的排行-----------------------------------------

-- 更新我的排名
function WndAthRank:updateMyRank()
    -- 我的排名
    local ftbMyRank = GetElement(self.m_root,"ftbMyRank_WndAthRank",WZUIFreeTextBox)
    if self.myRank == nil or self.myRank.rank == 0 then
        ftbMyRank:setShowText(LocalStrings.ATH_DESC19)
    else
        if self.myRankIndex == self.topIndex then
            ftbMyRank:setShowText(string.format(LocalStrings.ATH_DESC20,tostring(self.myRank.rank)))
        else
            if self.myRankIndex == self.topIndex then
                ftbMyRank:setShowText(string.format(LocalStrings.ATH_DESC20,tostring(self.myRank.rank)))
            else
                local str = {LocalStrings.ATH_DESC21,LocalStrings.ATH_DESC22,LocalStrings.ATH_DESC23 }
                ftbMyRank:setShowText(str[self.myRankIndex])
            end
        end
    end
        
    -- 排行榜等级区间
    local Index = (self.topIndex-1)*2 + 1
    local startLv = tonumber(self.rankLvLimit[Index])
    local endLv = tonumber(self.rankLvLimit[Index+1])
    local desc = {LocalStrings.ATH_DESC13,LocalStrings.ATH_DESC14,LocalStrings.ATH_DESC15}
    local txtRankLv = GetElement(self.m_root,"txtRankLv_WndAthRank",WZUILabelTTF)
    if self.topIndex >= 1 and self.topIndex <= 3 then
        txtRankLv:setText(string.format(desc[self.topIndex],startLv,endLv))
        txtRankLv:setVisible(false)
    else
        txtRankLv:setVisible(true)
    end
end

-------------------------------------------------------语言适配Begin------------------------------------
function WndAthRank:_adaptLanguage_th(  )
    local txtRankLv2 = GetElement(self.m_root,"txtRankLv2_WndAthRank",WZUILabelTTF)
    txtRankLv2:setRelativePosition(GlobalMethod:ccp(0.025,0.5))
    GetElement(self.m_root,"txtRank2_WndAthRank",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtRankSel2_WndAthRank",WZUILabelTTF):setFontSize(20)
    local txt2 = GetElement(self.m_root,"txtRankLv2_WndAthRank",WZUILabelTTF)
    txt2:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    txt2:setFontSize(18)

    local txt3 = GetElement(self.m_root,"ftbReward_WndAthRank",WZUIFreeTextBox)
    txt3:setRelativePosition(GlobalMethod:ccp(0.99,0.5))
    txt3:setScale(0.8)

    local ftbLast = GetElement(self.m_root,"ftbLast_WndAthRank",WZUIFreeTextBox)
    ftbLast:setRelativePosition(GlobalMethod:ccp(0.99,0.5))
    ftbLast:setMaxWidth(500)
    ftbLast:setScale(0.7)

    GetElement(self.m_root,"txtAth2_WndAthRank",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.08,0.5))
    GetElement(self.m_root,"txtAthSel2_WndAthRank",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.08,0.5))

    local txtRank4 = GetElement(self.m_root,"txtRank4_WndAthRank",WZUILabelTTF)
    txtRank4:setScale(0.9)
    local txtRankSel4 = GetElement(self.m_root,"txtRankSel4_WndAthRank",WZUILabelTTF)
    txtRankSel4:setScale(0.9)
end

function WndAthRank:_adaptLanguage_en(  )
    WZLog("--WndAthRank:_adaptLanguage_en--")
    local txt1 = GetElement(self.m_root,"txtRankLv_WndAthRank",WZUILabelTTF)
    txt1:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    txt1:setScale(0.7)

    local ftbMyRank = GetElement(self.m_root,"ftbMyRank_WndAthRank",WZUIFreeTextBox)
    ftbMyRank:setScale(0.7)

    local ftbRankDesc = GetElement(self.m_root,"ftbRankDesc_WndAthRank",WZUIFreeTextBox)
    ftbRankDesc:setScale(0.7)


    local txt2 = GetElement(self.m_root,"txtRankLv2_WndAthRank",WZUILabelTTF)
    txt2:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    txt2:setScale(0.7)

    local txt3 = GetElement(self.m_root,"ftbReward_WndAthRank",WZUIFreeTextBox)
    txt3:setScale(0.7)
    txt3:setMaxWidth(500)

    local txt4 = GetElement(self.m_root,"txtRankLv3_WndAthRank",WZUILabelTTF)
    txt4:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    txt4:setScale(0.7)
    local txt5 = GetElement(self.m_root,"ftbLast_WndAthRank",WZUIFreeTextBox)
    txt5:setRelativePosition(GlobalMethod:ccp(0.99,0.5))
    txt5:setMaxWidth(500)
    txt5:setScale(0.7)

    local txtRank1 = GetElement(self.m_root,"txtRank1_WndAthRank",WZUILabelTTF)
    txtRank1:setScale(0.8)
    txtRank1:setDimensions(GlobalMethod:CCSize(80))
    local txtRankSel1 = GetElement(self.m_root,"txtRankSel1_WndAthRank",WZUILabelTTF)
    txtRankSel1:setScale(0.8)
    txtRankSel1:setDimensions(GlobalMethod:CCSize(80))
    local txtRank2 = GetElement(self.m_root,"txtRank2_WndAthRank",WZUILabelTTF)
    txtRank2:setScale(0.8)
    txtRank2:setDimensions(GlobalMethod:CCSize(80))
    local txtRankSel2 = GetElement(self.m_root,"txtRankSel2_WndAthRank",WZUILabelTTF)
    txtRankSel2:setScale(0.8)
    txtRankSel2:setDimensions(GlobalMethod:CCSize(80))
    local txtRank3 = GetElement(self.m_root,"txtRank3_WndAthRank",WZUILabelTTF)
    txtRank3:setScale(0.8)
    txtRank3:setDimensions(GlobalMethod:CCSize(80))
    local txtRankSel3 = GetElement(self.m_root,"txtRankSel3_WndAthRank",WZUILabelTTF)
    txtRankSel3:setScale(0.8)
    txtRankSel3:setDimensions(GlobalMethod:CCSize(80))
    local txtRank4 = GetElement(self.m_root,"txtRank4_WndAthRank",WZUILabelTTF)
    txtRank4:setScale(0.8)
    txtRank4:setDimensions(GlobalMethod:CCSize(80))
    local txtRankSel4 = GetElement(self.m_root,"txtRankSel4_WndAthRank",WZUILabelTTF)
    txtRankSel4:setScale(0.8)
    txtRankSel4:setDimensions(GlobalMethod:CCSize(80))

    
    local txtAth1 = GetElement(self.m_root,"txtAth1_WndAthRank",WZUILabelTTF)
    txtAth1:setScale(0.8)
    txtAth1:setDimensions(GlobalMethod:CCSize(80))
    local txtAthSel1 = GetElement(self.m_root,"txtAthSel1_WndAthRank",WZUILabelTTF)
    txtAthSel1:setScale(0.8)
    txtAthSel1:setDimensions(GlobalMethod:CCSize(80))
    local txtAth2 = GetElement(self.m_root,"txtAth2_WndAthRank",WZUILabelTTF)
    txtAth2:setScale(0.8)
    txtAth2:setDimensions(GlobalMethod:CCSize(80))
    local txtAthSel2 = GetElement(self.m_root,"txtAthSel2_WndAthRank",WZUILabelTTF)
    txtAthSel2:setScale(0.8)
    txtAthSel2:setDimensions(GlobalMethod:CCSize(80))
    -- local txtAth3 = GetElement(self.m_root,"txtAth3_WndAthRank",WZUILabelTTF)
    -- txtAth3:setScale(0.8)
    -- txtAth3:setDimensions(GlobalMethod:CCSize(80))
    -- local txtAthSel3 = GetElement(self.m_root,"txtAthSel3_WndAthRank",WZUILabelTTF)
    -- txtAthSel3:setScale(0.8)
    -- txtAthSel3:setDimensions(GlobalMethod:CCSize(80))
    
    local ftbMyRank = GetElement(self.m_root,"ftbMyRank_WndAthRank",WZUIFreeTextBox)
    ftbMyRank:setScale(0.75)
    ftbMyRank:setMaxWidth(500)

end

function WndAthRank:_adaptLanguage_vn( )
    for i = 1, 4 do
        GetElement(self.m_root,"txtRank"..i.."_WndAthRank",WZUILabelTTF):setFontSize(20)
        GetElement(self.m_root,"txtRankSel"..i.."_WndAthRank",WZUILabelTTF):setFontSize(20)
    end
    GetElement(self.m_root,"txtRankLv2_WndAthRank",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    GetElement(self.m_root,"txtRankLv3_WndAthRank",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    local ftbReward = GetElement(self.m_root,"ftbReward_WndAthRank",WZUIFreeTextBox)
    ftbReward:setRelativePosition(GlobalMethod:ccp(0.98,0.5))
    ftbReward:setScale(0.88)
    GetElement(self.m_root,"ftbLast_WndAthRank",WZUIFreeTextBox):setMaxWidth(400)
    GetElement(self.m_root,"txtRankLv_WndAthRank",WZUILabelTTF):setScale(0.9)

    local txtAth1 = GetElement(self.m_root,"txtAth1_WndAthRank",WZUILabelTTF)
    txtAth1:setRelativePosition(GlobalMethod:ccp(1.13,0.5))
    local txtAthSel1 = GetElement(self.m_root,"txtAthSel1_WndAthRank",WZUILabelTTF)
    txtAthSel1:setRelativePosition(GlobalMethod:ccp(1.13,0.5))
    local txtAth2 = GetElement(self.m_root,"txtAth2_WndAthRank",WZUILabelTTF)
    txtAth2:setRelativePosition(GlobalMethod:ccp(1.13,0.5))
    local txtAthSel2 = GetElement(self.m_root,"txtAthSel2_WndAthRank",WZUILabelTTF)
    txtAthSel2:setRelativePosition(GlobalMethod:ccp(1.13,0.5))
end

function WndAthRank:_adaptLanguage_pt(  )
    WZLog("WndAthRank:_adaptLanguage_pt")

    local txtRank1 = GetElement(self.m_root,"txtRank1_WndAthRank",WZUILabelTTF)
    txtRank1:setDimensions(GlobalMethod:CCSize(140,0))
    txtRank1:setScale(0.65)
    local txtRankSel1 = GetElement(self.m_root,"txtRankSel1_WndAthRank",WZUILabelTTF)
    txtRankSel1:setDimensions(GlobalMethod:CCSize(140,0))
    txtRankSel1:setScale(0.65)
    local txtRank2 = GetElement(self.m_root,"txtRank2_WndAthRank",WZUILabelTTF)
    txtRank2:setDimensions(GlobalMethod:CCSize(140,0))
    txtRank2:setScale(0.65)
    local txtRankSel2 = GetElement(self.m_root,"txtRankSel2_WndAthRank",WZUILabelTTF)
    txtRankSel2:setDimensions(GlobalMethod:CCSize(140,0))
    txtRankSel2:setScale(0.65)
    local txtRank3 = GetElement(self.m_root,"txtRank3_WndAthRank",WZUILabelTTF)
    txtRank3:setDimensions(GlobalMethod:CCSize(140,0))
    txtRank3:setScale(0.65)
    local txtRankSel3 = GetElement(self.m_root,"txtRankSel3_WndAthRank",WZUILabelTTF)
    txtRankSel3:setDimensions(GlobalMethod:CCSize(140,0))
    txtRankSel3:setScale(0.65)
    local txtRank4 = GetElement(self.m_root,"txtRank4_WndAthRank",WZUILabelTTF)
    txtRank4:setDimensions(GlobalMethod:CCSize(140,0))
    txtRank4:setScale(0.65)
    local txtRankSel4 = GetElement(self.m_root,"txtRankSel4_WndAthRank",WZUILabelTTF)
    txtRankSel4:setDimensions(GlobalMethod:CCSize(140,0))
    txtRankSel4:setScale(0.65)

    local txt1 = GetElement(self.m_root,"txtRankLv_WndAthRank",WZUILabelTTF)
    txt1:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    txt1:setScale(0.7)
    local ftbMyRank = GetElement(self.m_root,"ftbMyRank_WndAthRank",WZUIFreeTextBox)
    ftbMyRank:setScale(0.7)
    local ftbRankDesc = GetElement(self.m_root,"ftbRankDesc_WndAthRank",WZUIFreeTextBox)
    ftbRankDesc:setScale(0.7)
    local txt2 = GetElement(self.m_root,"txtRankLv2_WndAthRank",WZUILabelTTF)
    txt2:setRelativePosition(GlobalMethod:ccp(0.05,0.5))
    txt2:setScale(0.7)
    local txt3 = GetElement(self.m_root,"ftbReward_WndAthRank",WZUIFreeTextBox)
    txt3:setRelativePosition(GlobalMethod:ccp(0.98,0.5))
    txt3:setScale(0.7)
    local txt4 = GetElement(self.m_root,"txtRankLv3_WndAthRank",WZUILabelTTF)
    txt4:setRelativePosition(GlobalMethod:ccp(0.05,0.5))
    txt4:setScale(0.7)
    local txt5 = GetElement(self.m_root,"ftbLast_WndAthRank",WZUIFreeTextBox)
    txt5:setRelativePosition(GlobalMethod:ccp(0.98,0.5))
    txt5:setScale(0.7)

    local txtAth1 = GetElement(self.m_root,"txtAth1_WndAthRank",WZUILabelTTF)
    txtAth1:setRelativePosition(GlobalMethod:ccp(1.1,0.5))
    txtAth1:setDimensions(GlobalMethod:CCSize(80))
    local txtAthSel1 = GetElement(self.m_root,"txtAthSel1_WndAthRank",WZUILabelTTF)
    txtAthSel1:setRelativePosition(GlobalMethod:ccp(1.1,0.5))
    txtAthSel1:setDimensions(GlobalMethod:CCSize(80))
    local txtAth2 = GetElement(self.m_root,"txtAth2_WndAthRank",WZUILabelTTF)
    txtAth2:setRelativePosition(GlobalMethod:ccp(1.1,0.5))
    txtAth2:setDimensions(GlobalMethod:CCSize(80))
    local txtAthSel2 = GetElement(self.m_root,"txtAthSel2_WndAthRank",WZUILabelTTF)
    txtAthSel2:setRelativePosition(GlobalMethod:ccp(1.1,0.5))
    txtAthSel2:setDimensions(GlobalMethod:CCSize(80))
end

function WndAthRank:_adaptLanguage_tr(  )
    local txtAth1 = GetElement(self.m_root,"txtAth1_WndAthRank",WZUILabelTTF)
    txtAth1:setScale(0.8)
    txtAth1:setDimensions(GlobalMethod:CCSize(80))
    local txtAthSel1 = GetElement(self.m_root,"txtAthSel1_WndAthRank",WZUILabelTTF)
    txtAthSel1:setScale(0.8)
    txtAthSel1:setDimensions(GlobalMethod:CCSize(80))
    local txtAth2 = GetElement(self.m_root,"txtAth2_WndAthRank",WZUILabelTTF)
    txtAth2:setScale(0.8)
    txtAth2:setDimensions(GlobalMethod:CCSize(80))
    local txtAthSel2 = GetElement(self.m_root,"txtAthSel2_WndAthRank",WZUILabelTTF)
    txtAthSel2:setScale(0.8)
    txtAthSel2:setDimensions(GlobalMethod:CCSize(80))
    local txtAth3 = GetElement(self.m_root,"txtAth3_WndAthRank",WZUILabelTTF)
    txtAth3:setScale(0.8)
    txtAth3:setDimensions(GlobalMethod:CCSize(80))
    local txtAthSel3 = GetElement(self.m_root,"txtAthSel3_WndAthRank",WZUILabelTTF)
    txtAthSel3:setScale(0.8)
    txtAthSel3:setDimensions(GlobalMethod:CCSize(80))

    local txtRank1 = GetElement(self.m_root,"txtRank1_WndAthRank",WZUILabelTTF)
    txtRank1:setScale(0.8)
    txtRank1:setDimensions(GlobalMethod:CCSize(80))
    local txtRankSel1 = GetElement(self.m_root,"txtRankSel1_WndAthRank",WZUILabelTTF)
    txtRankSel1:setScale(0.8)
    txtRankSel1:setDimensions(GlobalMethod:CCSize(80))
    local txtRank2 = GetElement(self.m_root,"txtRank2_WndAthRank",WZUILabelTTF)
    txtRank2:setScale(0.8)
    txtRank2:setDimensions(GlobalMethod:CCSize(80))
    local txtRankSel2 = GetElement(self.m_root,"txtRankSel2_WndAthRank",WZUILabelTTF)
    txtRankSel2:setScale(0.8)
    txtRankSel2:setDimensions(GlobalMethod:CCSize(80))
    local txtRank3 = GetElement(self.m_root,"txtRank3_WndAthRank",WZUILabelTTF)
    txtRank3:setScale(0.8)
    txtRank3:setDimensions(GlobalMethod:CCSize(80))
    local txtRankSel3 = GetElement(self.m_root,"txtRankSel3_WndAthRank",WZUILabelTTF)
    txtRankSel3:setScale(0.8)
    txtRankSel3:setDimensions(GlobalMethod:CCSize(80))
    
    local ftbMyRank = GetElement(self.m_root,"ftbMyRank_WndAthRank",WZUIFreeTextBox)
    ftbMyRank:setScale(0.75)
    ftbMyRank:setMaxWidth(500)
    GetElement(self.m_root,"txtRankLv_WndAthRank",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"ftbRankDesc_WndAthRank",WZUIFreeTextBox):setScale(0.75)

    GetElement(self.m_root,"txtRankLv2_WndAthRank",WZUILabelTTF):setScale(0.75)
    local ftbReward = GetElement(self.m_root, "ftbReward_WndAthRank", WZUIFreeTextBox)
    ftbReward:setScale(0.75)
    ftbReward:setMaxWidth(500)

    GetElement(self.m_root,"txtRankLv3_WndAthRank",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"ftbLast_WndAthRank",WZUIFreeTextBox):setScale(0.75)
end

function WndAthRank:_adaptLanguage_es(  )
    local txt1 = GetElement(self.m_root,"txtRankLv_WndAthRank",WZUILabelTTF)
    txt1:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    txt1:setScale(0.6)
    local ftbMyRank = GetElement(self.m_root,"ftbMyRank_WndAthRank",WZUIFreeTextBox)
    ftbMyRank:setScale(0.6)
    local ftbRankDesc = GetElement(self.m_root,"ftbRankDesc_WndAthRank",WZUIFreeTextBox)
    ftbRankDesc:setScale(0.6)
    local txt2 = GetElement(self.m_root,"txtRankLv2_WndAthRank",WZUILabelTTF)
    --txt2:setRelativePosition(GlobalMethod:ccp(0,0.5))
    txt2:setScale(0.6)
    local txt3 = GetElement(self.m_root,"ftbReward_WndAthRank",WZUIFreeTextBox)
    txt3:setRelativePosition(GlobalMethod:ccp(1,0.5))
    txt3:setScale(0.6)
    txt3:setMaxWidth(500)
    local txt4 = GetElement(self.m_root,"txtRankLv3_WndAthRank",WZUILabelTTF)
    --txt4:setRelativePosition(GlobalMethod:ccp(0,0.5))
    txt4:setScale(0.6)
    local txt5 = GetElement(self.m_root,"ftbLast_WndAthRank",WZUIFreeTextBox)
    txt5:setRelativePosition(GlobalMethod:ccp(1,0.5))
    txt5:setScale(0.6)
    txt5:setMaxWidth(500)

    for i=1,3 do
        local txtCheck = GetElement(self.m_root,"txtCheck"..i.."_WndAthRank",WZUILabelTTF)
        local txtCheckSel = GetElement(self.m_root,"txtCheck"..i.."Sel_WndAthRank",WZUILabelTTF)
        txtCheck:setDimensions(GlobalMethod:CCSize(100,0))
        txtCheckSel:setDimensions(GlobalMethod:CCSize(100,0))
        txtCheck:setScale(0.8)
        txtCheckSel:setScale(0.8)
    end

    for i=1,4 do
        local txtRank = GetElement(self.m_root,"txtRank"..i.."_WndAthRank",WZUILabelTTF)
        local txtRankSel = GetElement(self.m_root,"txtRankSel"..i.."_WndAthRank",WZUILabelTTF)
        txtRank:setDimensions(GlobalMethod:CCSize(140,0))
        txtRank:setScale(0.65)
        txtRankSel:setDimensions(GlobalMethod:CCSize(140,0))
        txtRankSel:setScale(0.65)
    end


    local txtAth1 = GetElement(self.m_root,"txtAth1_WndAthRank",WZUILabelTTF)
    txtAth1:setRelativePosition(GlobalMethod:ccp(1.1,0.5))
    txtAth1:setDimensions(GlobalMethod:CCSize(80))
    local txtAthSel1 = GetElement(self.m_root,"txtAthSel1_WndAthRank",WZUILabelTTF)
    txtAthSel1:setRelativePosition(GlobalMethod:ccp(1.1,0.5))
    txtAthSel1:setDimensions(GlobalMethod:CCSize(80))
    local txtAth2 = GetElement(self.m_root,"txtAth2_WndAthRank",WZUILabelTTF)
    txtAth2:setRelativePosition(GlobalMethod:ccp(1.1,0.5))
    txtAth2:setDimensions(GlobalMethod:CCSize(80))
    local txtAthSel2 = GetElement(self.m_root,"txtAthSel2_WndAthRank",WZUILabelTTF)
    txtAthSel2:setRelativePosition(GlobalMethod:ccp(1.1,0.5))
    txtAthSel2:setDimensions(GlobalMethod:CCSize(80))
end
-------------------------------------------------------语言适配End--------------------------------------