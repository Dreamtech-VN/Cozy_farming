--CellPvpCompete.lua
--@brief	CellPvpCompete的UI模块
--@date		2016/05/16
--@author	Tianxiang_Xu
--@note		比赛-排位赛入口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpCompete:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpCompete:onExit(element)
	self:_unInit()
end

function CellPvpCompete:show(tData, ui_id)
    -- body
    self.m_tData = tData
    if ui_id == 118 then
        self.m_nSeason = tData.season
    end
    self.m_nCurUIId = ui_id 

    self:_update()
end

--@brief    点击进入排位赛按钮回调
function CellPvpCompete:onGotoEvent(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- body
    if self.m_nCurUIId == 118 then --调用进入排位赛的入口方法
        if self.m_nSeason == -1 then
            MsgBoxManager:showTipBox(LocalStrings.WELFARE_COMPETE_TEXT1)
        else
            ScenePvpRank:showInterface()
        end
    elseif self.m_nCurUIId == 181 then --大乱斗
        SceneAthMelee:showInterface()
    end
end

-- 倒计时格式转换
function CellPvpCompete:_timeChangeStyle(time)
    WZLog("--******1212--",time)
    local h,m = 3600,60
    local hour = math.floor(time/h)
    local min = math.floor((time - hour*h)/m)
    --local sec = math.floor(time-hour*h-min*60)
    if hour < 10 then hour = "0"..hour end
    if min < 10 then min = "0"..min end
    --if sec < 10 then sec = "0"..sec end
    local str = hour..":"..min
    return str
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新界面显示信息
function CellPvpCompete:_update()
    --body
    --赛季
    local txtSeason = GetElement(self.m_root, "txtSeason_CellPvpCompete", WZUILabelAtlasFont)
    local imgBtnText = GetElement(self.m_root, "imgBtnText_CellPvpCompete", WZUIImage)
    local imgBK = GetElement(self.m_root, "imgBK_CellPvpCompete", WZUIImage)
    local txtTime = GetElement(self.m_root, "txtTime_CellPvpCompete", WZUILabelTTF)
    local txtWords = GetElement(self.m_root, "txtWords_CellPvpCompete", WZUILabelTTF)
    if self.m_nCurUIId == 118 then
        txtSeason:setVisible(true)
        if self.m_nSeason == -1 then
            txtSeason:setText(1)
        else
            txtSeason:setText(self.m_nSeason)
        end
        imgBtnText:setFile("ui/welfare/common_icon_jrpws.png")
        imgBK:setFile("ui/welfare/common_pic_pws.png")
        --GetElement(self.m_root, "con3_CellPvpCompete", WZUIContainer):setVisible(false)

    --    GetElement(self.m_root, "btnGoto_CellPvpCompete", WZUIButton):setVisible(false)

        -- local conTime = GetElement(self.m_root, "conTime_CellPvpCompete", WZUIContainer)
        -- if conTime then
        --     conTime:setRelativePosition(GlobalMethod:ccp(0.74,0.17))
        --     conTime:setAbsContentSize(GlobalMethod:CCSize(300,107))
        --     conTime:updateRelativeSize()

        --     txtTime:setText(LocalStrings.PVPRANK_MODIFYING)
        --     txtTime:setRelativePosition(GlobalMethod:ccp(0.5,0.56))

        --     txtWords:setText(LocalStrings.ASCENDING33)
        --     txtWords:setFontSize(24)
        --     txtWords:setRelativePosition(GlobalMethod:ccp(0.5,0.44))
        -- end
        --日期
        if txtTime then
            txtTime:setText(self.m_tData.startYear .. LocalStrings.SPACE30 .. self.m_tData.startMonth .. LocalStrings.SPACE31 .. self.m_tData.startDay .. LocalStrings.SPACE32 .. "-" .. self.m_tData.endDay .. LocalStrings.SPACE32)
            if ProjConfig.LANGUAGE == "vn" then
                txtTime:setText(self.m_tData.startDay .. "/" .. self.m_tData.startMonth .. "-" .. self.m_tData.endDay .. "/" .. self.m_tData.startMonth .. "/" .. self.m_tData.startYear)
            end
        end
        --时间段
        if txtWords then
            txtWords:setAnchorPoint(GlobalMethod:ccp(0.5,1))
            WZLog("--********---",self.m_tData.start_Time,self.m_tData.end_Time)
            --if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or 
                --ProjConfig.LANGUAGE == "en" then
                if self.m_tData.start_Time > 0 then
                    local str1 = self:_timeChangeStyle(self.m_tData.start_Time)
                    txtWords:setText(LocalStrings.WORLD_BOSS_OPEN_TIME_DOWN .. str1)
                    txtWords:enableSchedule("_updateOpenTime",1)
                elseif self.m_tData.start_Time <= 0 and self.m_tData.end_Time > 0 then
                    local str2 = self:_timeChangeStyle(self.m_tData.end_Time)
                    txtWords:setText(LocalStrings.ACTIVITY_END_COUNTDOWN..": "..str2)
                    --WZLog("--*********--1111",txtWords:getText())
                    txtWords:enableSchedule("_updateEndTime",1)
                end
            -- else
            --     txtWords:setText(LocalStrings.EVERYDAY .. self.m_tData.startTime .. "-" .. self.m_tData.endTime .. LocalStrings.MAP_EVENT_ON)
            -- end
        end
    elseif self.m_nCurUIId == 181 then
        txtSeason:setVisible(false)
        imgBtnText:setFile("ui/welfare/common_icon_dld.png")
        imgBK:setFile("ui/welfare/activity_pic_dld.png")
        --GetElement(self.m_root, "con3_CellPvpCompete", WZUIContainer):setVisible(true)
        GetElement(self.m_root,"con2_CellPvpCompete",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.78,0.114))

        local sWeekDay = CacheCenter:getGameParam()["meleeOpenDayOfWeek"]
        local tWeekDay = SplitStringWithSeparator(sWeekDay, ",")
        local sContent = nil 
        for i = 1, #tWeekDay do
            if tonumber(tWeekDay[i]) == 0 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE2
                else
                    if ProjConfig.LANGUAGE == "tr" then
                        sContent = sContent .. "-" .. LocalStrings.WELFARE_COMPETE2
                    else
                        sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE2
                    end
                end
            elseif tonumber(tWeekDay[i]) == 1 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE3
                else
                    if ProjConfig.LANGUAGE == "tr" then
                        sContent = sContent .. "-" .. LocalStrings.WELFARE_COMPETE3
                    else
                        sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE3
                    end
                end
            elseif tonumber(tWeekDay[i]) == 2 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE4
                else
                    if ProjConfig.LANGUAGE == "tr" then
                        sContent = sContent .. "-" .. LocalStrings.WELFARE_COMPETE4
                    else
                        sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE4
                    end
                end
            elseif tonumber(tWeekDay[i]) == 3 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE5
                else
                    if ProjConfig.LANGUAGE == "tr" then
                        sContent = sContent .. "-" .. LocalStrings.WELFARE_COMPETE5
                    else
                        sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE5
                    end
                end
            elseif tonumber(tWeekDay[i]) == 4 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE6
                else
                    if ProjConfig.LANGUAGE == "tr" then
                        sContent = sContent .. "-" .. LocalStrings.WELFARE_COMPETE6
                    else
                        sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE6
                    end
                end
            elseif tonumber(tWeekDay[i]) == 5 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE7
                else
                    if ProjConfig.LANGUAGE == "tr" then
                        sContent = sContent .. "-" .. LocalStrings.WELFARE_COMPETE7
                    else
                        sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE7
                    end
                end
            elseif tonumber(tWeekDay[i]) == 6 then
                if sContent == nil then
                    sContent = LocalStrings.WELFARE_COMPETE8
                else
                    if ProjConfig.LANGUAGE == "tr" then
                        sContent = sContent .. "-" .. LocalStrings.WELFARE_COMPETE8
                    else
                        sContent = sContent .. "," .. LocalStrings.WELFARE_COMPETE8
                    end
                end
            end
        end
        if txtTime then
            txtTime:setText(sContent)
        end
        local sTime = CacheCenter:getGameParam()["meleeOpenTime"]
        
        --时间段
        if txtWords then
            txtWords:setText(sTime .. " " .. LocalStrings.MAP_EVENT_ON)
        end
        if ProjConfig.LANGUAGE == "en" then
            txtWords:setText("Unlock at " .. sTime .. "(GMT+0)")
        elseif ProjConfig.LANGUAGE == "tr" then
            txtWords:setText("günleri saat " .. sTime .. "(GMT+0) arası açılır")
        end
    end
    
end


--@brief    开启倒计时
function CellPvpCompete:_updateOpenTime( element,time )
    local txtWords = GetElement(self.m_root, "txtWords_CellPvpCompete", WZUILabelTTF)
    if self.m_tData.start_Time > 0 then
        self.m_tData.start_Time = self.m_tData.start_Time - 1
        local str = self:_timeChangeStyle(self.m_tData.start_Time)
        txtWords:setText(LocalStrings.WORLD_BOSS_OPEN_TIME_DOWN..str)
    else
        element:disableSchedule()
    end
end

--@brief    结束倒计时
function CellPvpCompete:_updateEndTime( element,time )
    local txtWords = GetElement(self.m_root, "txtWords_CellPvpCompete", WZUILabelTTF)
    if self.m_tData.end_Time > 0 then
        self.m_tData.end_Time = self.m_tData.end_Time - 1
        local str = self:_timeChangeStyle(self.m_tData.end_Time)
        txtWords:setText(LocalStrings.ACTIVITY_END_COUNTDOWN..": "..str)
    else
        element:disableSchedule()
    end
end

-------------------------------------私有方法模块End----------------------------------------

---------------------------------------------语言适配Begin---------------------------------------
function CellPvpCompete:_adaptLanguage_en(  )
    --GetElement(self.m_root,"conTime_CellPvpCompete",WZUIContainer):setVisible(false)

    GetElement(self.m_root,"con1_CellPvpCompete",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.86,0.847534))

    local btnGoto = GetElement(self.m_root,"btnGoto_CellPvpCompete",WZUIContainer)
    btnGoto:setRelativePosition(GlobalMethod:ccp(0.63,0.16))
    btnGoto:setScale(0.65)
end

function  CellPvpCompete:_adaptLanguage_pt ( )
    --GetElement(self.m_root,"conTime_CellPvpCompete",WZUIContainer):setVisible(false)

    local con2 = GetElement(self.m_root,"con2_CellPvpCompete",WZUIContainer)
    con2:setRelativePosition(GlobalMethod:ccp(0.801593,0.09493))
    con2:setScale(0.9)
    GetElement(self.m_root,"con1_CellPvpCompete",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.68,0.855))
    
--    GetElement(self.m_root, "con3_CellPvpCompete", WZUIContainer):setVisible(false)
    --GetElement(self.m_root, "txtWords_CellPvpCompete", WZUILabelTTF):setVisible(false)

    --local txtSeason = GetElement(self.m_root, "txtSeason_CellPvpCompete", WZUILabelAtlasFont)
    --txtSeason:setRelativePosition(GlobalMethod:ccp(0.8,0.6))
    --txtSeason:setRotation(5)
    
    local btnGoto = GetElement(self.m_root,"btnGoto_CellPvpCompete",WZUIContainer)
    btnGoto:setRelativePosition(GlobalMethod:ccp(0.55,0.25))
    btnGoto:setScale(0.9)
end

function CellPvpCompete:_adaptLanguage_th(  )
    GetElement(self.m_root,"con1_CellPvpCompete",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.88,0.847534))

    local btnGoto = GetElement(self.m_root,"btnGoto_CellPvpCompete",WZUIContainer)
    btnGoto:setRelativePosition(GlobalMethod:ccp(0.75,0.26))
    btnGoto:setScale(0.8)
end

function CellPvpCompete:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtSeason_CellPvpCompete",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(1.2,0.6))
end

function  CellPvpCompete:_adaptLanguage_es( )
    local con2 = GetElement(self.m_root,"con2_CellPvpCompete",WZUIContainer)
    con2:setRelativePosition(GlobalMethod:ccp(0.829482,0.0551954))
    con2:setScale(0.75)
    GetElement(self.m_root,"con1_CellPvpCompete",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.68,0.855))
end
function CellPvpCompete:_adaptLanguage_tr(  )
    GetElement(self.m_root,"conTime_CellPvpCompete",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.29))

    local con1 = GetElement(self.m_root,"con1_CellPvpCompete",WZUIContainer)
    con1:setScale(0.7)
    con1:setRelativePosition(GlobalMethod:ccp(0.388685,0.904929))
    con1:setRotation(-3)
    local btnGoto = GetElement(self.m_root,"btnGoto_CellPvpCompete",WZUIContainer)
    btnGoto:setRelativePosition(GlobalMethod:ccp(0.7,0.16))
    btnGoto:setScale(0.65)
    --GetElement(self.m_root,"con3_CellPvpCompete",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.29))
end
---------------------------------------------语言适配End------------------------------------------