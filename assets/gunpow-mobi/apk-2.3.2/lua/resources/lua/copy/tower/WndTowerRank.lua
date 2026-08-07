--WndTowerRank.lua
--@brief	WndTowerRank的UI模块
--@date		2015/04/28
--@author	xiaoyu_wu
-- modify   2015-7-3 binshao
--@note		爬塔副本排名窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTowerRank:onEnter(element)
	self.m_root = element
    self.m_bEnterAnimation = true
    AdaptLanguage(self)
end

----@brief onEnter函数执行完成回调
function WndTowerRank:onEnterTransitionDidFinish(element)
    self.m_oRankTableList = GetElement(self.m_root,"tbconList_WndTowerRank",WZUITableContainer)
   
    --WindowManagerAni:createAppearAction(self.m_root, true, "actionCallback", self)
    self:actionCallback()
    self:_initUIText()
end

----@brief    弹窗动画完成后的回调
function WndTowerRank:actionCallback(element, data)
	--初始化界面
    WZLog("WndTowerRank:actionCallback", self.m_nTowerType)
    if self.m_nTowerType == 2 then 
        ProtocolProcessorSingleMap:send_BOSSMAPROOM_GetTwoTowerRank()
    elseif self.m_nTowerType == 1 then
        ProtocolProcessorSingleMap:send_MAP_CrossGetTodayHeroTowerRank(0)
    elseif self.m_nTowerType == 3 then
        ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetHurtRank()
    elseif self.m_nTowerType == 4 then
        self.m_bEnterAnimation = false
        self:updateWorldBossRankData()
    elseif self.m_nTowerType == 5 then
        ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetHurtRank()
    elseif self.m_nTowerType == 6 then
        self.m_bEnterAnimation = false
        ProtocolProcessorWndSamllGame:send_SMALLGAME_GetRankingList(1000, 0)
    else
        ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerRank()
    end
    self.m_bEnterAnimation = false
end

--@brief  查看爬塔排行榜
function WndTowerRank:onTowerRankClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local conForReward = GetElement(self.m_root, "conForReward_WndTowerRank", WZUIContainer)
    local conForRank = GetElement(self.m_root, "conForRank_WndTowerRank", WZUIContainer)
    if self.m_nTag == element:getTag() then return end 

    self.m_nTag = element:getTag() 
    self:_setTabSel()

    if conForRank:isVisible() then
        if self.m_tSaveData[self.m_nTag] == nil then 
            if self.m_nTowerType == 1 then
                ProtocolProcessorSingleMap:send_MAP_CrossGetTodayHeroTowerRank(0)
            elseif self.m_nTowerType == 2 then
                ProtocolProcessorSingleMap:send_BOSSMAPROOM_GetTwoTowerRank()
            elseif self.m_nTowerType == 3 then
                ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetHurtRank()
            elseif self.m_nTowerType == 4 then
                self:updateWorldBossRankData()
            elseif self.m_nTowerType == 5 then
                ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetHurtRank()
            else
                ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerRank()
            end
        else
            self:_update(self.m_tSaveData[self.m_nTag])
        end
        return
    else
        conForRank:setVisible(true)
        conForReward:setVisible(false)
        if self.m_tSaveData[self.m_nTag] == nil then 
            if self.m_nTowerType == 1 then
                ProtocolProcessorSingleMap:send_MAP_CrossGetTodayHeroTowerRank(0)
            elseif self.m_nTowerType == 2 then
                ProtocolProcessorSingleMap:send_BOSSMAPROOM_GetTwoTowerRank()
            elseif self.m_nTowerType == 3 then
                ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_GetHurtRank()
            elseif self.m_nTowerType == 4 then
                self:updateWorldBossRankData()
            elseif self.m_nTowerType == 5 then
                ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetHurtRank()
            else
                ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerRank()
            end
        else
            self:_update(self.m_tSaveData[self.m_nTag])
        end
    end
end

--@brief  查看爬塔历史排行榜
function WndTowerRank:onTowerRankHistoryClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local conForReward = GetElement(self.m_root, "conForReward_WndTowerRank", WZUIContainer)
    local conForRank = GetElement(self.m_root, "conForRank_WndTowerRank", WZUIContainer)
    if self.m_nTag == element:getTag() then return end 

    self.m_nTag = element:getTag() 
    self:_setTabSel()

    if conForRank:isVisible() then
        if self.m_tSaveData[self.m_nTag] == nil then 
            if self.m_nTowerType == 1 then
                ProtocolProcessorSingleMap:send_MAP_CrossGetTodayHeroTowerRank(1)
            elseif self.m_nTowerType == 5 then
                ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetHistoryRank()
            else
                ProtocolProcessorSingleMap:send_MAP_CrossGetTowerRank()
            end
        else
            self:_update(self.m_tSaveData[self.m_nTag])
        end
        return
    else
        conForRank:setVisible(true)
        conForReward:setVisible(false)
        if self.m_tSaveData[self.m_nTag] == nil then 
            if self.m_nTowerType == 1 then
                ProtocolProcessorSingleMap:send_MAP_CrossGetTodayHeroTowerRank(1)
            elseif self.m_nTowerType == 5 then
                ProtocolProcessorWndCoupleHegemonyRoom:send_COUPLEFIGHTBOSS_GetHistoryRank()
            else
                ProtocolProcessorSingleMap:send_MAP_CrossGetTowerRank()
            end
        else
            self:_update(self.m_tSaveData[self.m_nTag])
        end
    end
end

--@brief 查看每日奖励
function WndTowerRank:onDailyReward(element)
    WZLog("WndTowerRank:onDailyReward")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local conForReward = GetElement(self.m_root, "conForReward_WndTowerRank", WZUIContainer)
    local conForRank = GetElement(self.m_root, "conForRank_WndTowerRank", WZUIContainer)
    self.m_nTag = element:getTag() 
    self:_setTabSel()

    if conForRank:isVisible() then
        conForReward:setVisible(true)
        WndTowerPreview:showWindow(self.m_nTowerType, conForReward)
        conForRank:setVisible(false)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTowerRank:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndTowerRank:onClose(element)
    WZLog("WndTowerRank:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManagerAni:createDisappearAction(self.m_root, "onActionCallBack", self)
end

--@brief	动画播完后的回调
function WndTowerRank:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief  加载爬塔副本列表
function WndTowerRank:loadRankListItem(tData)
    WZLog("WndTowerRank:loadRankListItem")
    self:createTenListInfo(tData)
end

--@brief    每次创建10个表项
function WndTowerRank:createTenListInfo(tData)
    WZLog("********* WndTowerRank:createTenListInfo **************")
    local count = #tData.playerInfo
    local nCurIndex = 0

    for i=1,count do
        nCurIndex = nCurIndex + 1
        local tempListItem = tData.playerInfo[i]
        local eCell,tCell = CellTowerRank:createElement()
        eCell:setTag(i-1)
        tCell:setData(tempListItem, nCurIndex,self.m_nTowerType,self.m_nTag)
        self.m_oRankTableList:setCellElement(eCell)
    end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    初始化界面
function WndTowerRank:_update(tData)
    if self.m_root == nil or tData == nil or self.m_bEnterAnimation == true then
        return
    end

    if self.m_nTowerType == 3 or self.m_nTowerType == 4 then
        GetElement(self.m_root,"txtTitleCommunity_WndTowerRank",WZUILabelTTF):setVisible(false)
        GetElement(self.m_root,"txtTitlePlayer_WndTowerRank",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.5))
        GetElement(self.m_root,"txtRankWord_WndTowerRank",WZUILabelTTF):setTextKey("TEAMBOSS_TEXT16")
        GetElement(self.m_root,"txtTitleTower_WndTowerRank",WZUILabelTTF):setTextKey("SETTLMENT_DAMAGE")
    elseif self.m_nTowerType == 5 then
        if self.m_nTag == 1 then
            GetElement(self.m_root,"txtTitleCommunity_WndTowerRank",WZUILabelTTF):setVisible(false)
            GetElement(self.m_root,"txtTitlePlayer_WndTowerRank",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.5))
            GetElement(self.m_root,"txtRankWord_WndTowerRank",WZUILabelTTF):setTextKey("TEAMBOSS_TEXT16")
            GetElement(self.m_root,"txtTitleTower_WndTowerRank",WZUILabelTTF):setTextKey("SETTLMENT_DAMAGE")
        elseif self.m_nTag == 2 then
            GetElement(self.m_root,"txtTitleCommunity_WndTowerRank",WZUILabelTTF):setVisible(false)
            GetElement(self.m_root,"txtTitlePlayer_WndTowerRank",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.5))
            GetElement(self.m_root,"txtRankWord_WndTowerRank",WZUILabelTTF):setTextKey("")
            GetElement(self.m_root,"txtRankWord_WndTowerRank",WZUILabelTTF):setText("")
            GetElement(self.m_root,"txtTitleTower_WndTowerRank",WZUILabelTTF):setTextKey("SETTLMENT_DAMAGE")
        end
    elseif self.m_nTowerType == 6 then
        GetElement(self.m_root,"txtTitleRank_WndTowerRank",WZUILabelTTF):setTextKey("RANK")
        GetElement(self.m_root,"txtTitlePlayer_WndTowerRank",WZUILabelTTF):setTextKey("PLAYER")
        GetElement(self.m_root,"txtTitleCommunity_WndTowerRank",WZUILabelTTF):setTextKey("COMMUNITY")
        GetElement(self.m_root,"txtTitleTower_WndTowerRank",WZUILabelTTF):setTextKey("LEVEL_TEXT1")
    else
        GetElement(self.m_root,"txtRankWord_WndTowerRank",WZUILabelTTF):setTextKey("TOWER_MY_RECORD")
    end
    
    local sName = ""
    local sTime = ""
    if self.m_nTowerType == 3 then
        local hurtPercent = tData.myHurt/SceneWorldTeamBossRoom.bossRoomInfo.bossBloodMax * 100
        local nPercent = string.format("%0.2f", hurtPercent)
        sName = tData.myHurt .. "(" .. nPercent .. "%" .. ")"
    elseif self.m_nTowerType == 4 then
        local hurtPercent = tData.myHurt/SceneWorldBoss.bossRoomInfo.bossBloodMax * 100
        local nPercent = string.format("%0.2f", hurtPercent)
        sName = tData.myHurt .. "(" .. nPercent .. "%" .. ")"
    elseif self.m_nTowerType == 5 then
        local strFormat = [[<T C="229,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1">%s</T>]]

        local coupleFightBossConfig = json.decode(CacheCenter:getGameParam().coupleFightBossConfig)
        local nEndDay = (coupleFightBossConfig.day)
        local nMonth = tonumber(os.date("%m"))
        local nDay = tonumber(os.date("%d"))
        if nEndDay < nDay then
            nMonth = nMonth + 1
        end
        if nMonth > 12 then
            nMonth = 1
        end
        local tempEndTime = string.format(LocalStrings.COUPLE_HEGEMONY_TEXT17,nMonth,nEndDay)


        local txtLevel1 = GetElement(self.m_root, "txtLevel1_WndTowerRank", WZUILabelTTF)
        if self.m_nTag == 1 then
            txtLevel1:setTextKey("PLAYER_RANK_SCENEWORLDBOSS")
            sName = tData.myHurt
            sTime = string.format(strFormat, LocalStrings.COUPLE_HEGEMONY_TEXT16..":", tempEndTime)
        elseif self.m_nTag == 2 then
            txtLevel1:setTextKey("")
            txtLevel1:setText("")

            sTime = string.format(strFormat, LocalStrings.COUPLE_HEGEMONY_TEXT16..":", tempEndTime)
        end
    elseif self.m_nTowerType == 6 then
        sName = string.format(LocalStrings.LEVEL_TEXT2,tData.myPoint)
    else
        sName = tData.topFloor .. LocalStrings.TOWER_LEVEL2
    end

    local sRank = LocalStrings.NONE
    if self.m_nTowerType == 5 and self.m_nTag == 2 then
        sRank = ""
    else
        if tData.myRank > 0 then
            sRank = tData.myRank
        end
    end

    local txtLevel = GetElement(self.m_root, "txtLevel_WndTowerRank", WZUILabelTTF)
    local txtRank = GetElement(self.m_root, "txtRank_WndTowerRank", WZUILabelTTF)
    txtRank:setText(sName)
    txtLevel:setText(sRank)

    local ftbTime = GetElement(self.m_root,"ftbTime_WndTowerRank",WZUIFreeTextBox)
    ftbTime:setShowText(sTime)

    local conNoMes= GetElement(self.m_root,"conNoMes_WndTowerRank",WZUIContainer)
    self.m_oRankTableList:cleanTable()
    
    if #tData.playerInfo > 0 then
        conNoMes:setVisible(false)
        self:loadRankListItem(tData)
    else
        conNoMes:setVisible(true)
        ShowPanelNullTip(conNoMes,nil,nil,nil, 30, nil)
    end
end

--@brief    设置标签选中状态
function WndTowerRank:_setTabSel()
    -- body
    for i = 1, 3 do
        if i == self.m_nTag then 
            GetElement(self.m_root, "conGroup" .. i .. "_WndTowerRank", WZUIContainer):setVisible(true)
        else
            GetElement(self.m_root, "conGroup" .. i .. "_WndTowerRank", WZUIContainer):setVisible(false)
        end
    end
    if self.m_nTag == 1 then 
        if self.m_nTowerType == 5 then
            GetElement(self.m_root, "txtTitle_WndTowerRank", WZUILabelTTF):setTextKey("COUPLE_HEGEMONY_TEXT18")
        elseif self.m_nTowerType == 6 then
            GetElement(self.m_root, "txtTitle_WndTowerRank", WZUILabelTTF):setTextKey("RANK")
        else
            GetElement(self.m_root, "txtTitle_WndTowerRank", WZUILabelTTF):setTextKey("TOWER_DAILY_RANKING")
        end
    elseif self.m_nTag == 2 then 
        if self.m_nTowerType == 1 then
            GetElement(self.m_root, "txtTitle_WndTowerRank", WZUILabelTTF):setTextKey("TOWER_DAILY_RANKING")
        elseif self.m_nTowerType == 3 then
            GetElement(self.m_root, "txtTitle_WndTowerRank", WZUILabelTTF):setTextKey("COUPLE_HEGEMONY_TEXT14")
        else
            GetElement(self.m_root, "txtTitle_WndTowerRank", WZUILabelTTF):setTextKey("ATH_DESC_3")
        end
    else
        GetElement(self.m_root, "txtTitle_WndTowerRank", WZUILabelTTF):setTextKey("ATH_DESC_10")
    end
end

--@brief    设置静态文本
function WndTowerRank:_initUIText()
    -- body
    if self.m_nTowerType == 1 then 
        GetElement(self.m_root, "conCheckBoxGroup_WndTowerRank", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conCheckBoxGroupSel_WndTowerRank", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "checkHistory_WndTowerRank", WZUICheckBox):setVisible(true)
        GetElement(self.m_root, "conGroup2_WndTowerRank", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "checkReward_WndTowerRank", WZUICheckBox):setVisible(false)
        GetElement(self.m_root, "conGroup3_WndTowerRank", WZUIContainer):setVisible(false)
    elseif self.m_nTowerType == 2 or self.m_nTowerType == 3 or self.m_nTowerType == 4 then 
        GetElement(self.m_root, "conCheckBoxGroup_WndTowerRank", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conCheckBoxGroupSel_WndTowerRank", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "checkHistory_WndTowerRank", WZUICheckBox):setVisible(false)
        GetElement(self.m_root, "conGroup2_WndTowerRank", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "checkReward_WndTowerRank", WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        GetElement(self.m_root, "conGroup3_WndTowerRank", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    elseif self.m_nTowerType == 5 then 
        GetElement(self.m_root, "conCheckBoxGroup_WndTowerRank", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conCheckBoxGroupSel_WndTowerRank", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "checkHistory_WndTowerRank", WZUICheckBox):setVisible(true)
        GetElement(self.m_root, "conGroup2_WndTowerRank", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "checkReward_WndTowerRank", WZUICheckBox):setVisible(true)
        GetElement(self.m_root, "conGroup3_WndTowerRank", WZUIContainer):setVisible(true)

        GetElement(self.m_root, "checkReward_WndTowerRank", WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        GetElement(self.m_root, "conGroup3_WndTowerRank", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        GetElement(self.m_root, "checkHistory_WndTowerRank", WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.17))
        GetElement(self.m_root, "conGroup2_WndTowerRank", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.17))

        GetElement(self.m_root, "txtArmsNor2_WndTowerRank", WZUILabelTTF):setTextKey("COUPLE_HEGEMONY_TEXT14")
        GetElement(self.m_root, "txtArms2_WndTowerRank", WZUILabelTTF):setTextKey("COUPLE_HEGEMONY_TEXT14")
    elseif self.m_nTowerType == 6 then
        GetElement(self.m_root, "conCheckBoxGroup_WndTowerRank", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conCheckBoxGroupSel_WndTowerRank", WZUIContainer):setVisible(false)

    else
        GetElement(self.m_root, "conCheckBoxGroup_WndTowerRank", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conCheckBoxGroupSel_WndTowerRank", WZUIContainer):setVisible(true)
    end

    self:_setTabSel()
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Star--------------------------------------
function WndTowerRank:_adaptLanguage_en()
end

function WndTowerRank:_adaptLanguage_pt()
    GetElement(self.m_root, "txtLevel1_WndTowerRank", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.74,0.5))
end

function WndTowerRank:_adaptLanguage_vn()
end

function WndTowerRank:_adaptLanguage_tr(  )
end

function WndTowerRank:_adaptLanguage_es(  )
end

function WndTowerRank:_adaptLanguage_ug()
    local txtReward22 = GetElement(self.m_root,"txtReward22_WndTowerRank",WZUILabelTTF)
    txtReward22:setScale(0.7)
    txtReward22:setDimensions(GlobalMethod:CCSize(110))
    local txtArms22 = GetElement(self.m_root,"txtArms22_WndTowerRank",WZUILabelTTF)
    txtArms22:setScale(0.7)
    txtArms22:setDimensions(GlobalMethod:CCSize(110))

    local txtRank = GetElement(self.m_root, "txtRank_WndTowerRank", WZUILabelTTF)
    txtRank:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRank:setRelativePosition(GlobalMethod:ccp(0.195,0.5))
    local txtLevel = GetElement(self.m_root, "txtLevel_WndTowerRank", WZUILabelTTF)
    txtLevel:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtLevel:setRelativePosition(GlobalMethod:ccp(0.65,0.5))
    local txtRank1 = GetElement(self.m_root, "txtRank1_WndTowerRank", WZUILabelTTF)
    txtRank1:setRelativePosition(GlobalMethod:ccp(0.3,0.5))
end

-------------------------------------语言适配模块End--------------------------------------