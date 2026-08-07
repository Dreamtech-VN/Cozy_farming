--CellCommunityFight.lua
--@brief	CellCommunityFight的UI模块
--@date		2016/09/21
--@author	Tianxiang_Xu
--@note		公会战入口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityFight:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityFight:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief    点击进入比赛界面
function CellCommunityFight:onGotoEvent(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if CheckButtonOpen(56) then
        SceneCommunityWar:showInterface()
    end
end

--@brief    
function CellCommunityFight:show()
    -- body
    local txtTime = GetElement(self.m_root, "txtTime_CellCommunityFight", WZUILabelTTF)
    local txtWords = GetElement(self.m_root, "txtWords_CellCommunityFight", WZUILabelTTF)
    if self.m_nCommunityState == 0 then --未开启
        sWordContent = LocalStrings.CLOSE_SCRIPT
        txtTime:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        txtWords:setVisible(false)
        txtTime:setText(sWordContent)
        return 
    end
    if ProjConfig.LANGUAGE ~= "cn" then
        txtWords:setFontSize(18)
    end
    if txtWords then
        local sWordContent
        local nCurDay = SceneCommunityWar:getCurDay(self.m_sCommunityTime)
        local sTime = "20:00-21:00"
        local nCurTime = SystemTime:getServerTime()
        local bIsSectionOver = false --赛段是否结束
        if nCurDay >= 1 and nCurDay <= 7 then
            sWordContent = LocalStrings.COMMUNITYWAR_TEXT25
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "th" or 
                ProjConfig.LANGUAGE == "vn" then 
                if self.m_nNextStartTime <= nCurTime and self.m_nNextStartTime + 3600 > nCurTime then 
                    self.m_nLeftSeconds = self.m_nNextStartTime + 3600 - nCurTime
                    sTime = LocalStrings.ACTIVITY_END_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                else
                    self.m_nLeftSeconds = self.m_nNextStartTime - nCurTime
                    sTime = LocalStrings.ACTIVITY_START_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                    if self.m_nNextStartTime + 3600 <= nCurTime then 
                        bIsSectionOver = true
                        sTime = LocalStrings.GUILDWAR_NEWTEXT1
                    end
                end
            else
                if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1043 or ProjConfig.CHANNEL_ID == 1044 then
                    sTime = "20:00-21:00"
                else
                    sTime = CacheCenter:getGameParam()["warOutTime"]
                end
                sTime = LocalStrings.COMMUNITYWAR_TEXT30 .. sTime
            end
        elseif nCurDay >= 8 and nCurDay <= 14 then
            sWordContent = LocalStrings.COMMUNITYWAR_TEXT26
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "th" or 
                ProjConfig.LANGUAGE == "vn" then 
                if self.m_nNextStartTime <= nCurTime and self.m_nNextStartTime + 3600 > nCurTime then 
                    self.m_nLeftSeconds = self.m_nNextStartTime + 3600 - nCurTime
                    sTime = LocalStrings.ACTIVITY_END_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                else
                    self.m_nLeftSeconds = self.m_nNextStartTime - nCurTime
                    sTime = LocalStrings.ACTIVITY_START_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                    if self.m_nNextStartTime + 3600 <= nCurTime then 
                        bIsSectionOver = true
                        sTime = LocalStrings.GUILDWAR_NEWTEXT1
                    end
                end
            else
                if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1043 or ProjConfig.CHANNEL_ID == 1044 then
                    sTime = "20:00-21:00"
                else
                    sTime = CacheCenter:getGameParam()["warFinalistTime"]
                end
                sTime = LocalStrings.COMMUNITYWAR_TEXT30 .. sTime
            end
        elseif nCurDay >= 15 and nCurDay <= 17 then
            sWordContent = LocalStrings.COMMUNITYWAR_TEXT27
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "th" or 
                ProjConfig.LANGUAGE == "vn" then 
                if self.m_nNextStartTime - 15 * 60 <= nCurTime and self.m_nNextStartTime - 15 * 60 + 1800 > nCurTime then 
                    self.m_nLeftSeconds = self.m_nNextStartTime - 15 * 60 + 1800 - nCurTime
                    sTime = LocalStrings.ACTIVITY_END_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                else
                    self.m_nLeftSeconds = self.m_nNextStartTime - 15 * 60 - nCurTime
                    sTime = LocalStrings.ACTIVITY_START_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                    if self.m_nNextStartTime + 15 * 60 <= nCurTime then
                        bIsSectionOver = true
                        sTime = LocalStrings.GUILDWAR_NEWTEXT1
                    end
                end
            else
                if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1043 or ProjConfig.CHANNEL_ID == 1044 then
                    sTime = "21:00-21:30"
                else
                    sTime = "20:00-20:30"
                end
                sTime = LocalStrings.COMMUNITYWAR_TEXT30 .. sTime
            end
        elseif nCurDay >= 18 and nCurDay <= 20 then
            sWordContent = LocalStrings.COMMUNITYWAR_TEXT28
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "th" or 
                ProjConfig.LANGUAGE == "vn" then 
                if self.m_nNextStartTime - 15 * 60 <= nCurTime and self.m_nNextStartTime - 15 * 60 + 1800 > nCurTime then 
                    self.m_nLeftSeconds = self.m_nNextStartTime - 15 * 60 + 1800 - nCurTime
                    sTime = LocalStrings.ACTIVITY_END_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                else
                    self.m_nLeftSeconds = self.m_nNextStartTime - 15 * 60 - nCurTime
                    sTime = LocalStrings.ACTIVITY_START_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                    if self.m_nNextStartTime + 15 * 60 <= nCurTime then
                        bIsSectionOver = true
                        sTime = LocalStrings.GUILDWAR_NEWTEXT1
                    end
                end
            else
                if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1043 or ProjConfig.CHANNEL_ID == 1044 then
                    sTime = "21:00-21:30"
                else
                    sTime = "20:00-20:30"
                end
                sTime = LocalStrings.COMMUNITYWAR_TEXT30 .. sTime
            end
        else
            self.m_nLeftSeconds = 0 
            sWordContent = LocalStrings.COMMUNITYWAR_TEXT29
            txtTime:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
            txtWords:setVisible(false)
        end

        txtWords:setText(sTime)
        if txtTime then
            txtTime:setText(sWordContent)
        end
    end

    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "th" or 
        ProjConfig.LANGUAGE == "vn" then 
        if not bIsSectionOver then 
            if self.m_nLeftSeconds > 0 then 
                self.m_root:enableSchedule("_caculateTime", 1)
            end
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    倒计时
function CellCommunityFight:_caculateTime()
    -- body
    self.m_nCurDaySeconds = self.m_nCurDaySeconds + 1
    if self.m_nCurDaySeconds >= 24 * 3600 then
        WndWelfare:onClickLeftMenu(110)
    end
    if self.m_nLeftSeconds > 0 then 
        self.m_nLeftSeconds = self.m_nLeftSeconds - 1
        self:updateLeftTime()
    else
        self.m_root:disableSchedule()
        WndWelfare:onClickLeftMenu(110)
    end
end

--@brief    刷新时间
function CellCommunityFight:updateLeftTime()
    -- body
    local txtTime = GetElement(self.m_root, "txtTime_CellCommunityFight", WZUILabelTTF)
    local txtWords = GetElement(self.m_root, "txtWords_CellCommunityFight", WZUILabelTTF)

    if txtWords then
        local sWordContent
        local nCurDay = SceneCommunityWar:getCurDay(self.m_sCommunityTime)
        local nCurTime = SystemTime:getServerTime()
        if nCurDay >= 1 and nCurDay <= 7 then
            sWordContent = LocalStrings.COMMUNITYWAR_TEXT25
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "th" or 
                ProjConfig.LANGUAGE == "vn" then 
                if self.m_nNextStartTime <= nCurTime and self.m_nNextStartTime + 3600 > nCurTime then 
                    self.m_nLeftSeconds = self.m_nNextStartTime + 3600 - nCurTime
                    sTime = LocalStrings.ACTIVITY_END_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                else
                    self.m_nLeftSeconds = self.m_nNextStartTime - nCurTime
                    sTime = LocalStrings.ACTIVITY_START_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                end
            end
        elseif nCurDay >= 8 and nCurDay <= 14 then
            sWordContent = LocalStrings.COMMUNITYWAR_TEXT26
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "th" or 
                ProjConfig.LANGUAGE == "vn" then 
                if self.m_nNextStartTime <= nCurTime and self.m_nNextStartTime + 3600 > nCurTime then 
                    self.m_nLeftSeconds = self.m_nNextStartTime + 3600 - nCurTime
                    sTime = LocalStrings.ACTIVITY_END_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                else
                    self.m_nLeftSeconds = self.m_nNextStartTime - nCurTime
                    sTime = LocalStrings.ACTIVITY_START_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                end
            end
        elseif nCurDay >= 15 and nCurDay <= 17 then
            sWordContent = LocalStrings.COMMUNITYWAR_TEXT27
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "th" or 
                ProjConfig.LANGUAGE == "vn" then 
                if self.m_nNextStartTime - 15 * 60 <= nCurTime and self.m_nNextStartTime - 15 * 60 + 1800 > nCurTime then 
                    self.m_nLeftSeconds = self.m_nNextStartTime - 15 * 60 + 1800 - nCurTime
                    sTime = LocalStrings.ACTIVITY_END_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                else
                    self.m_nLeftSeconds = self.m_nNextStartTime - 15 * 60 - nCurTime
                    sTime = LocalStrings.ACTIVITY_START_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                end
            end
        elseif nCurDay >= 18 and nCurDay <= 20 then
            sWordContent = LocalStrings.COMMUNITYWAR_TEXT28
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "th" or 
                ProjConfig.LANGUAGE == "vn" then 
                if self.m_nNextStartTime - 15 * 60 <= nCurTime and self.m_nNextStartTime - 15 * 60 + 1800 > nCurTime then 
                    self.m_nLeftSeconds = self.m_nNextStartTime - 15 * 60 + 1800 - nCurTime
                    sTime = LocalStrings.ACTIVITY_END_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                else
                    self.m_nLeftSeconds = self.m_nNextStartTime - 15 * 60 - nCurTime
                    sTime = LocalStrings.ACTIVITY_START_COUNTDOWN .. ":" .. returnToTimeFormat(self.m_nLeftSeconds)
                end
            end
        else
            self.m_nLeftSeconds = 0 
            sWordContent = LocalStrings.COMMUNITYWAR_TEXT29
            txtTime:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
            txtWords:setVisible(false)
        end

        txtWords:setText(sTime)
        if txtTime then
            txtTime:setText(sWordContent)
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配Begin--------------------------------------------
function CellCommunityFight:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtWords_CellCommunityFight",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(0,0))
end

function CellCommunityFight:_adaptLanguage_en(  )
    local txtTime = GetElement(self.m_root,"txtTime_CellCommunityFight",WZUILabelTTF)
    --txtTime:setDimensions(GlobalMethod:CCSize(600,0))
    txtTime:setFontSize(12)
end
-------------------------------------语言适配End--------------------------------------------