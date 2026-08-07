--CellListPanel.lua
--@brief	CellListPanel的UI模块
--@date		2016/06/02
--@author	Tianxiang_Xu
--@note		冲榜类活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellListPanel:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellListPanel:onExit(element)
	self:_unInit()
end

--@brief    点击详细信息按钮回调
function CellListPanel:onClickInfo(element)
    -- body
    WZLog("CellListPanel:onClickInfo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(self.content)
end

--@brief    点击排行详情回调
function CellListPanel:onClickList(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndActivityRankList:showInterface(self.index)
end
--@brief    设置数据
function CellListPanel:setMessage(index,tips,startTime,endTime,serverTime,rewardId,rewardItems,rewardItemsParamCount,rewardCounts ,activityId,content)
    -- body
    self.startTime = startTime
    self.endTime = endTime
    self.serverTime = serverTime
    self.rewardItems = rewardItems
    self.rewardId = rewardId
    self.rewardItemsParamCount = rewardItemsParamCount
    self.rewardCounts = rewardCounts
    self.index = index
    self.tips = tips
    self.content = content
    self.m_nActivityId = activityId 
end

--@brief    显示信息数据
function CellListPanel:showWindow()
    -- body
    self:_activityTime()
    self:_createRewardList()
    AdaptLanguage(self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置活动时间
function CellListPanel:_activityTime()
    -- body
    local imgContent = GetElement(self.m_root, "imgContent_CellListPanel", WZUIImage)
    local btnList = GetElement(self.m_root, "btnList_CellListPanel", WZUIButton)
    if self.index == g_tGameActivityTypes.ACTIVITY_LEVELLIST then 
        imgContent:setFile("ui/gameActivity/activity_pic_djcb.png")
        btnList:setVisible(false)
    elseif self.index == g_tGameActivityTypes.ACTIVITY_ATHLETICSLIST then
        imgContent:setFile("ui/gameActivity/activity_pic_jjcb.png")
        btnList:setVisible(false)
    elseif self.index == g_tGameActivityTypes.ACTIVITY_FIGHTINGLIST then
        imgContent:setFile("ui/gameActivity/activity_pic_zlcb.png")
        btnList:setVisible(false)
    elseif self.index == g_tGameActivityTypes.ACTIVITY_COUPLEFIGHTING then
        imgContent:setFile("ui/gameActivity/activity_pic_fqtxz.png")
        btnList:setVisible(true)
    elseif self.index == g_tGameActivityTypes.ACTIVITY_COMMUNITYFIGHTING then
        imgContent:setFile("ui/gameActivity/activity_pic_ghdzz.png")
        btnList:setVisible(true)
    end
    
    local  txtTimeWord = GetElement(self.m_root, "txt_activity_day_key", WZUILabelTTF)
    if ProjConfig.LANGUAGE == "vn" then
        txtTimeWord:setRelativePosition(GlobalMethod:ccp(0.05,0.55))
    end
    txtTimeWord:setText(LocalStrings.ACTIVE_TIME .. ":")
    local txtTimeValue = GetElement(self.m_root, "txt_activity_day_value", WZUILabelTTF)
    local startDay = os.date("*t", self.startTime)
    local endDay = os.date("*t", self.endTime)
    txtTimeValue:setText(string.format(LocalStrings.ACTIVITYTIME_FORMAT, startDay.month, startDay.day, startDay.hour, startDay.min, endDay.month, endDay.day, endDay.hour, endDay.min))
end

--@brief    奖励项
function CellListPanel:_createRewardList()
    -- body
    WZLog("CellListPanel:_createRewardList", #self.rewardId, self.content)
    local flconRewardList = GetElement(self.m_root, "flconRewardList", WZUIFreeListContainer)

    if flconRewardList:size() > 0 then 
        flconRewardList:removeAll()
    end

    if self.m_tRewardList == nil then
        self.m_tRewardList = {}
    end
    --[[<T C="255,227,116" P="1" S="22" SC="105,65,46" SE="1" SS="4">第一名</T><T C="255,236,193" P="1" S="22" SC="105,65,46" SE="1" SS="4">专属称号</T><T C="99,255,95" P="1" S="22" SC="0,72,3" SE="1" SS="4">天下第一</T>]]
    local itemIndex = 1
    for i = 1, #self.rewardId do
        local item_data = {}
        item_data.tips = self.tips[i]
        WZLog("CellListPanel:_createRewardList",item_data.tips)
        item_data.rewardId = self.rewardId[i]
        local itemCount = self.rewardCounts[i]
        local tData = {}
        for j = 1, itemCount do
            local t_item = {id = self.rewardItems[itemIndex], num = self.rewardItemsParamCount[itemIndex]}
            table.insert(tData, t_item)
            itemIndex = itemIndex + 1
        end
        item_data.m_tData = tData
        table.insert(self.m_tRewardList, item_data)
    end

    for i = 1, #self.m_tRewardList do
        local cellElement,newLuaObj = CellListPanelItem:createElement()
        cellElement = WZUIContainer:luaTo(cellElement)
        newLuaObj:setData(self.m_tRewardList[i])
        cellElement:setTag(i-1)
        cellElement:setContentSize(GlobalMethod:CCSize(640,138))
        cellElement:setRelativeSize(GlobalMethod:CCSize(1,138/220))
        flconRewardList:pushBack(cellElement)
    end
    flconRewardList:getMoveElement():setPositionY(flconRewardList:getMinPosition().y)
end


-------------------------------------私有方法模块End----------------------------------------
--------------------------------------语言适配Begin-----------------------------------------
function CellListPanel:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txt_activity_day_value",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.412,0.5))
end

function CellListPanel:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txt_activity_day_value",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.5))
end
--------------------------------------语言适配End---------------------------------------------