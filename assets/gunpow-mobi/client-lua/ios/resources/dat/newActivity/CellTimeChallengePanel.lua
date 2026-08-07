--CellTimeChallengePanel.lua
--@brief	CellTimeChallengePanel的UI模块
--@date		2017/08/24
--@author	Tianxiang_Xu
--@note		开服活动-限时挑战


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTimeChallengePanel:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTimeChallengePanel:onExit(element)
	self:_unInit()
end

--@brief    点击前往按钮回调
function CellTimeChallengePanel:onClickGoto(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    JumpByUIId(12 , self.m_tRewardList[1].section, nil, 3)
end

--@brief    点击领取按钮回调
function CellTimeChallengePanel:onClickReceive(tData, activityId)
    -- body
    --发送领取奖励协议
    CellTimeChallengePanel.m_current.m_nloadingId = MsgBoxManager:showLoadingBox()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(activityId, tData.rewardId)
end

--@brief    显示界面
function CellTimeChallengePanel:showWindow()
    -- body
    GetElement(self.m_root, "imgBK_CellTimeChallengePanel", WZUIImage):setFile("ui/gameActivity/activity_pic_lsyjsz.png")
    self:_showTime()
    self:_showRewardList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    显示活动时间
function CellTimeChallengePanel:_showTime()
    -- body
    local txtActivityWord = GetElement(self.m_root,"txtActivityWord_CellTimeChallengePanel",WZUILabelTTF)
    if txtActivityWord then 
        txtActivityWord:setText(LocalStrings.ACTIVITY_TIME_KEY..":")
    end 

    local DayStartTab = os.date("*t",self.startTime)
    local DayEndTab = os.date("*t",self.endTime)
    local format_txt_value = nil 
    format_txt_value = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtLastDay = GetElement(self.m_root, "txtLastDay_CellTimeChallengePanel", WZUILabelTTF)
    if txtLastDay then 
        txtLastDay:setText(format_txt_value)
    end 
end

--@brief    显示奖励列表
function CellTimeChallengePanel:_showRewardList()
    -- body
    local tableRewardList = GetElement(self.m_root, "tableRewardList_CellTimeChallengePanel", WZUITableContainer)
    if tableRewardList then 
        tableRewardList:cleanTable()
    end

    for i = 1, #self.m_tRewardList do
        local element, tNewObj = CellTimeChallengeItem:createElement()
        if element and tNewObj then 
            tNewObj:setData(self.m_tRewardList[i], self.m_nActivityId)
            element:setTag(i - 1)
            tableRewardList:setCellElement(element)
        end
    end
end


-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function CellTimeChallengePanel:_adaptLanguage_vn(  )
    GetElement(self.m_root, "txtLastDay_CellTimeChallengePanel", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end
---------------------------------------语言适配End------------------------------------------