--CellFightingRankPanel.lua
--@brief	CellFightingRankPanel的UI模块
--@date		2017/08/23
--@author	Tianxiang_Xu
--@note		战力月榜之王活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFightingRankPanel:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFightingRankPanel:onExit(element)
	self:_unInit()
end

--@brief    点击排名按钮回调
function CellFightingRankPanel:onClickRank(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndMonthFighting:showWndUI(1,self.activityId,self.rewardRank,self.reward, self.nFlowerListIndex)
end

--@brief    点击规则按钮回调
function CellFightingRankPanel:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.activityId == g_tGameActivityTypes.ACTIVITY_NEWSERVER_FIGHTINGRANK then
        WndSingleMapDesc:showInterface1(LocalStrings.NEWACTIVITY_FIGHTINGLIST_RULE)
    elseif self.activityId == g_tGameActivityTypes.ACIVIITY_RECHARGERANK then
        WndSingleMapDesc:showInterface1(LocalStrings.NEWACTIVITY_THE_SERVICE_RECHARGE_RULE)
    elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK then
        WndSingleMapDesc:showInterface1(LocalStrings.NEWACTIVITY_CROSS_SERVICE_RECHARGE_RULE)
    elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CONSUMERANK then
        WndSingleMapDesc:showInterface1(LocalStrings.NEWACTIVITY_THE_SERVICE_CONSUMPTION_RULE)
    elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK then
        WndSingleMapDesc:showInterface1(LocalStrings.NEWACTIVITY_CROSS_SERVICE_CONSUMPTION_RULE)
    elseif self.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
        WndSingleMapDesc:showInterface1(LocalStrings.FLOWER_LIST_RULE)
    end
end

--@brief    显示
function CellFightingRankPanel:showWindow()
    -- body
    if self.activityId == g_tGameActivityTypes.ACTIVITY_NEWSERVER_FIGHTINGRANK then
        self.m_nStartTime, self.m_nEndTime = WndWelfare:getActivityTime(g_tGameActivityTypes.ACTIVITY_NEWSERVER_FIGHTINGRANK)
    elseif self.activityId == g_tGameActivityTypes.ACIVIITY_RECHARGERANK then
        self.m_nStartTime, self.m_nEndTime = WndGameActivity:getActivityTime(g_tGameActivityTypes.ACIVIITY_RECHARGERANK)
    elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK then
        self.m_nStartTime, self.m_nEndTime = WndGameActivity:getActivityTime(g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK)
    elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CONSUMERANK then
        self.m_nStartTime, self.m_nEndTime = WndGameActivity:getActivityTime(g_tGameActivityTypes.ACIVIITY_CONSUMERANK)
    elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK then
        self.m_nStartTime, self.m_nEndTime = WndGameActivity:getActivityTime(g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK)
    elseif self.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
        self.m_nStartTime, self.m_nEndTime = WndGameActivity:getActivityTime(g_tGameActivityTypes.ACTIVITY_FLOWER_LIST)
    end

    self:_showFlowerBtn()
    self:_showBK()
    self:_showTime()
    self:_showTenRankList()
end

--@brief    鲜花榜
function CellFightingRankPanel:onSwitchGender(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()

    if nTag == 0 then
        self.nFlowerListIndex = 0
    elseif nTag == 1 then
        self.nFlowerListIndex = 1
    elseif nTag == 2 then
        self.nFlowerListIndex = 2
    end

    self:_showFlowerBtn()
    self:_showTenRankList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief    鲜花榜按钮
function CellFightingRankPanel:_showFlowerBtn()
    GetElement(self.m_root, "conFlowerBtn_CellFightingRankPanel", WZUIContainer):setVisible(false)
    if self.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
        GetElement(self.m_root, "conFlowerBtn_CellFightingRankPanel", WZUIContainer):setVisible(true)
        if self.nFlowerListIndex == 0 then
            GetElement(self.m_root, "btnRank_CellFightingRankPanel", WZUIButton):setVisible(true)
        elseif self.nFlowerListIndex == 1 then
            GetElement(self.m_root, "btnRank_CellFightingRankPanel", WZUIButton):setVisible(true)
        else
            GetElement(self.m_root, "btnRank_CellFightingRankPanel", WZUIButton):setVisible(false)
        end
    end
end

--@显示背景展示图
function CellFightingRankPanel:_showBK()
    -- body
    local imgBK = GetElement(self.m_root, "imgBK_CellFightingRankPanel", WZUIImage)
    if imgBK then 
        if self.activityId == g_tGameActivityTypes.ACTIVITY_NEWSERVER_FIGHTINGRANK then
            imgBK:setFile("ui/newActivity/activity_pic_hd_16.png")
        elseif self.activityId == g_tGameActivityTypes.ACIVIITY_RECHARGERANK then
            imgBK:setFile("ui/gameActivity/activity_pic_dyjbfcz.png")
        elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK then
            imgBK:setFile("ui/gameActivity/activity_pic_dyjkfcz.png")
        elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CONSUMERANK then
            imgBK:setFile("ui/gameActivity/activity_pic_dyjbfxf.png")
        elseif self.activityId == g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK then
            imgBK:setFile("ui/gameActivity/activity_pic_dyjkfxf.png")
        elseif self.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
            imgBK:setFile("ui/gameActivity/activity_pic_mlxhb.png")
        end
    end
end

--@brief    显示活动时间
function CellFightingRankPanel:_showTime()
    -- body
    GetElement(self.m_root, "conForTime_CellFightingRankPanel", WZUIContainer):setVisible(true)
    
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellFightingRankPanel", WZUILabelTTF)
    if txtTimeWord then 
        txtTimeWord:setText(LocalStrings.ACTIVE_TIME .. ":")
    end
    local txtTime = GetElement(self.m_root, "txtTime_CellFightingRankPanel", WZUILabelTTF)
    if txtTime then 
        local sStartDate = os.date("*t", self.m_nStartTime)
        local sEndDate = os.date("*t", self.m_nEndTime)
        txtTime:setText(string.format(LocalStrings.ACTIVITYTIME_FORMAT, sStartDate.month, sStartDate.day, sStartDate.hour, sStartDate.min, sEndDate.month, sEndDate.day, sEndDate.hour, sEndDate.min))
    end
    if ProjConfig.LANGUAGE == "vn" and self.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
        local conFlowerBtn = GetElement(self.m_root, "conFlowerBtn_CellFightingRankPanel", WZUIContainer)
        conFlowerBtn:setRelativePosition(GlobalMethod:ccp(0.8,0.965))
        conFlowerBtn:setScale(0.85)
    end
end

--@brief    显示前十
function CellFightingRankPanel:_showTenRankList()
    -- body
    local tableRankList = GetElement(self.m_root, "tableRankList_CellFightingRankPanel", WZUITableContainer)
    tableRankList:cleanTable()

    if self.nFlowerListIndex == 0 then
        if self.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
            for i = 1, #self.m_tDataListMale do
                local element, tNewObj = CellFightingRankItem:createElement()
                if element and tNewObj then 
                    tNewObj:setData(self.m_tDataListMale[i])
                    element:setTag(i - 1)
                    tableRankList:setCellElement(element)
                end
            end
        end
    elseif self.nFlowerListIndex == 1 then
        if self.activityId == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
            for i = 1, #self.m_tDataListFemale do
                local element, tNewObj = CellFightingRankItem:createElement()
                if element and tNewObj then 
                    tNewObj:setData(self.m_tDataListFemale[i])
                    element:setTag(i - 1)
                    tableRankList:setCellElement(element)
                end
            end
        end
    else
        self.m_tRankCell = {}
        for i = 1, #self.m_tDataList do
            local element, tNewObj = CellFightingRankItem:createElement()
            if element and tNewObj then 
                tNewObj:setData(self.m_tDataList[i])
                element:setTag(i - 1)

                tableRankList:setCellElement(element)
                self.m_tRankCell[i] = tNewObj
            end
        end
    end

end
-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function CellFightingRankPanel:_adaptLanguage_vn(  )
    GetElement(self.m_root, "txtTime_CellFightingRankPanel", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.27,0.5))
    GetElement(self.m_root, "btnRank_CellFightingRankPanel", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.9,0.600))
end

function CellFightingRankPanel:_adaptLanguage_ug(  )
    GetElement(self.m_root, "txtTime_CellFightingRankPanel", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.05,0.5))
    GetElement(self.m_root, "txtTimeWord_CellFightingRankPanel", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.54,0.5))
end
---------------------------------------语言适配End------------------------------------------