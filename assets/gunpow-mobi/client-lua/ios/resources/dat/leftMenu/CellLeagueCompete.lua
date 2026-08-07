--CellLeagueCompete.lua
--@brief	CellLeagueCompete的UI模块
--@date		2016/06/29
--@author	Tianxiang_Xu
--@note		英雄联赛入口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeagueCompete:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeagueCompete:onExit(element)
	self:_unInit()
end

--@brief    点击进入比赛界面
function CellLeagueCompete:onGotoEvent(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if CheckButtonOpen(71) then
        SceneLeagueMain:show()
    end
end

--@brief    
function CellLeagueCompete:show(startTime, endTime, nType)
    -- body
    self.m_nStartTime = startTime
    self.m_nEndTime = endTime
    self.m_nType = nType

    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellLeagueCompete:_update()
    -- body
    local txtTime = GetElement(self.m_root, "txtTime_CellLeagueCompete", WZUILabelTTF)
    local txtWords = GetElement(self.m_root, "txtWords_CellLeagueCompete", WZUILabelTTF)
    local sTimeFormat = "%d.%d.%d-%d.%d.%d"
    local txtContentTime = nil 
    if self.m_nStartTime and self.m_nEndTime then
        local startDate = os.date("*t", self.m_nStartTime)
        local endDate = os.date("*t", self.m_nEndTime)
        if ProjConfig.LANGUAGE == "vn" then
            txtContentTime = string.format(sTimeFormat, startDate.day, startDate.month, startDate.year, endDate.day, endDate.month, endDate.year)
        else
            txtContentTime = string.format(sTimeFormat, startDate.year, startDate.month, startDate.day, endDate.year, endDate.month, endDate.day)
        end
    end
    WZLog("CellLeagueCompete:_update", self.m_nType, self.m_nStartTime, self.m_nEndTime)
    if self.m_nType == 0 then 
        if txtContentTime then
            txtTime:setText(txtContentTime)
        end
        txtWords:setText(LocalStrings.WELFARE_COMPETE_TEXT6)
    elseif self.m_nType == 1 then
        if txtContentTime then
            txtTime:setText(txtContentTime)
        end
        txtWords:setText(LocalStrings.WELFARE_COMPETE_TEXT2)
    elseif self.m_nType == 2 then
        if txtContentTime then
            txtTime:setText(txtContentTime)
        end
        txtWords:setText(LocalStrings.WELFARE_COMPETE_TEXT3)
    elseif self.m_nType == 3 then
        if txtContentTime then
            txtTime:setText(txtContentTime)
        end
        txtWords:setText(LocalStrings.WELFARE_COMPETE_TEXT4)
    elseif self.m_nType == 4 then
        if txtContentTime then
            txtTime:setText(txtContentTime)
        end
        txtWords:setText(LocalStrings.WELFARE_COMPETE_TEXT5)
    elseif self.m_nType == 5 then
        txtTime:setVisible(false)
        txtWords:setText(LocalStrings.WELFARE_COMPETE_TEXT1)
        txtWords:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    elseif self.m_nType == 6 then
        if txtContentTime then
            txtTime:setText(txtContentTime)
        end
        txtWords:setText(LocalStrings.WELFARE_COMPETE_TEXT7)
    elseif self.m_nType == 7 then
        if txtContentTime then
            txtTime:setText(txtContentTime)
        end
        txtWords:setText(LocalStrings.WELFARE_COMPETE_TEXT8)
    elseif self.m_nType == 8 then
        if txtContentTime then
            txtTime:setText(txtContentTime)
        end
        txtWords:setText(LocalStrings.WELFARE_COMPETE_TEXT9)
    end
end




-------------------------------------私有方法模块End----------------------------------------
