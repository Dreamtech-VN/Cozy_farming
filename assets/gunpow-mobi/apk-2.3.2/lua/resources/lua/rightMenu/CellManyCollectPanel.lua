--CellManyCollectPanel.lua
--@brief	CellManyCollectPanel的UI模块
--@date		2017/09/26
--@author	Tianxiang_Xu
--@note		全民众筹活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellManyCollectPanel:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    self.m_root:enableSchedule("_caculateTime", 1)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellManyCollectPanel:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief    点击规则按钮回调
function CellManyCollectPanel:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.MANYCOLLECT_TEXT6) 
end

--@brief    点击获奖名单按钮回调
function CellManyCollectPanel:onClickMember(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCollectRewardList:showInterface()
end

--@brief    展示界面信息
function CellManyCollectPanel:showWindow()
    -- body
    self:_showActivityTime()
    self:createList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    显示活动时间
function CellManyCollectPanel:_showActivityTime()
    -- body
    local txtActivityWord = GetElement(self.m_root, "txtActivityWord_CellManyCollectPanel", WZUILabelTTF)
    if txtActivityWord then 
        txtActivityWord:setText(LocalStrings.ACTIVE_TIME .. ":")
    end
    local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    local format_txt_value = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtLastDay = GetElement(self.m_root,"txtLastDay_CellManyCollectPanel",WZUILabelTTF)
    if txtLastDay ~= nil then 
        txtLastDay:setText(format_txt_value)
    end
end

--@brief    显示众筹列表
function CellManyCollectPanel:createList()
    -- body
    local conflListview = GetElement(self.m_root, "conflListview_CellManyCollectPanel", WZUIFreeListContainer)
    conflListview:removeAll()
    WZLog("CellManyCollectPanel:createList", #self.m_tCollectList)
    for i = 1, #self.m_tCollectList do
        local element, tNewObj = CellManyCollectItem:createElement()
        if element and tNewObj then 
            tNewObj:setData(self.m_tCollectList[i])

            element = WZUIContainer:luaTo(element)
            element:setTag(i - 1)
            element:setContentSize(GlobalMethod:CCSize(626,142))
            element:setRelativeSize(GlobalMethod:CCSize(1, 0.43))
            conflListview:pushBack(element)
        end
    end

    conflListview:getMoveElement():setPositionY(conflListview:getMinPosition().y)
end

--@brief    定时刷新
function CellManyCollectPanel:_caculateTime()
    -- body
    self.m_nCulateTime = self.m_nCulateTime + 1 
    if self.m_nCulateTime >= 15 then 
        self.m_nCulateTime = 0 
        WndGameActivity:refreshActivityContext()
    end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------私有方法模块End----------------------------------------
function CellManyCollectPanel:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtLastDay_CellManyCollectPanel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.412,0.5))
end

function CellManyCollectPanel:_adaptLanguage_pt(  )
    GetElement(self.m_root,"btnMember_CellManyCollectPanel",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.972028,0.204167))
end

function CellManyCollectPanel:_adaptLanguage_es(  )
    GetElement(self.m_root,"btnMember_CellManyCollectPanel",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.972028,0.204167))
end

function CellManyCollectPanel:_adaptLanguage_en(  )
    GetElement(self.m_root,"btnMember_CellManyCollectPanel",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.972028,0.204167))
end
-------------------------------------私有方法模块End----------------------------------------
