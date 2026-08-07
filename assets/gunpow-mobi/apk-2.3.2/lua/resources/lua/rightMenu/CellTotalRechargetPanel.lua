--CellTotalRechargetPanel.lua
--@brief	CellTotalRechargetPanel的UI模块
--@date		2014/12/02
--@author	wuweidong
--@note		累计充值面板


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTotalRechargetPanel:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTotalRechargetPanel:onExit(element) 
    GetElement(self.m_root,"confl_listview_rechargePanel",WZUIFreeListContainer):disableSchedule()
    GetElement(self.m_root,"confl_cy_listview_rechargePanel",WZUIFreeListContainer):disableSchedule()
    self:unregister()
    
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function CellTotalRechargetPanel:onEnterTransitionDidFinish(element)
    WZLog("CellTotalRechargetPanel:onEnterTransitionDidFinish", self.index)
    if self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST then 
        ProtocolProcessorFestivalActivity:regAll6()
        GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
        GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)

        ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.activityId, 1)
    end
end

function CellTotalRechargetPanel:unregister()
    if self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST then 
        ProtocolProcessorFestivalActivity:unregAll6()
        GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
        GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
    elseif self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then 
        ProtocolProcessorFestivalActivity:unregAll6()
        GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetTaskResultTwe,self)
    end
end

--@brief    显示窗口
function CellTotalRechargetPanel:showWindow( )
    if self.m_root == nil then return end 
    if self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then 
        ProtocolProcessorFestivalActivity:regAll6()
        GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetTaskResultTwe,self)
    end
    local bNPCVisible = true
    self:_caculateTime()
    local NpcImageContainer = GetElement(self.m_root, "NpcImageContainer_CellTotalRechargetPanel", WZUIContainer)
    if NpcImageContainer ~= nil  then 
        if self.index == 18 or self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY or self.index == g_tGameActivityTypes.ACTIVITY_EQUIP_STAR or self.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY or self.index == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE or self.index == g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE then 
            bNPCVisible = false 
        end 
    end 
    if self.index ~= g_tGameActivityTypes.ACTIVITY_DIAMOND_COST and self.index ~= g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then 
        self:_setTabList()
    end
    self:_setRewardList()
    self:_initStaticTxt()
    
    local totleRechargeBanner = GetElement(self.m_root,"totleRechargeBanner",WZUIImage)
    local btn_Recharge_event8 = GetElement(self.m_root,"btn_Recharge_event8",WZUIButton)
    local btnRule = GetElement(self.m_root,"btnRule",WZUIButton)
    btnRule:setVisible(false)
    if self.index == 4 or self.index == g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE or self.index == g_tGameActivityTypes.ACTIVITY_TYPE_NOVICE_ACCUMULATIVE 
        or self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TOTALRECHARGE or self.index == g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND 
        or self.index == g_tGameActivityTypes.ACTIVITY_FIVETIMES_DIAMOND or self.index == g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE 
        or self.index == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT or self.index == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT2 
        or self.index == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE  then    --累计充值,连续充值类型  （500,280）（0.5,0.361）
        bNPCVisible = false 
        
        GetElement(self.m_root, "img9BKOther_CellTotalRechargetPanel", WZUI9Image):setVisible(false)
        if self.index == g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE  then
            GetElement(self.m_root, "imgRechargeBK_CellRocalRechargePanel", WZUI9Image):setVisible(true)
            totleRechargeBanner:setFile("ui/newActivity/activity_pic_hd_12.png")
            btn_Recharge_event8:setVisible(false)
        else
            GetElement(self.m_root, "imgRechargeBK_CellRocalRechargePanel", WZUI9Image):setVisible(false)
        end
        GetElement(self.m_root, "conTotalRecharge_CellTotalRechargetPanel", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conLeijicc_CellRotalRechargePanel", WZUIContainer):setVisible(true)
        local ActivityProgressContainer = GetElement(self.m_root, "ActivityProgressContainer_CellTotalRechargetPanel", WZUIContainer)
        GetElement(self.m_root, "img_bg_progress_CellTotalRechargePanel", WZUIImage):setOpacity(255)
        
        if self.index == g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND then 
            GetElement(self.m_root, "txt_tip_recharge_reward", WZUILabelTTF):setVisible(false)
            GetElement(self.m_root, "conPrgRecharge_CellTatalRechargetPanel", WZUIContainer):setVisible(false)
            totleRechargeBanner:setFile("ui/newActivity/activity_pic_hd_10.png")
            btn_Recharge_event8:setVisible(true)
        elseif self.index == g_tGameActivityTypes.ACTIVITY_FIVETIMES_DIAMOND then 
            GetElement(self.m_root, "txt_tip_recharge_reward", WZUILabelTTF):setVisible(true)
        elseif self.index == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT or self.index == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT2 then 
            GetElement(self.m_root, "imgWords_CellTotalRechargetPanel", WZUIImage):setVisible(false)
        end

        GetElement(self.m_root, "imgLJBK_CellTotalRechargetPanel", WZUIImage):setVisible(false)
        local bChangeBG = false 
        if self.m_content then
            local nStart, nEnd = string.find(self.m_content, ".png")
            if nStart then
                bChangeBG = true
                GetElement(self.m_root, "imgLJBK_CellTotalRechargetPanel", WZUIImage):setFile(self.m_content)
            end
        end
        if not bChangeBG then 
            local imgLJBK = GetElement(self.m_root, "imgLJBK_CellTotalRechargetPanel", WZUIImage)
            if self.index == g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND then 
                imgLJBK:setFile("ui/gameActivity/activity_pic_czzs3.png")
            elseif self.index == g_tGameActivityTypes.ACTIVITY_FIVETIMES_DIAMOND then 
                imgLJBK:setFile("ui/gameActivity/activity_pic_zuanshi.png")
            end
        end
    elseif self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY or self.index == g_tGameActivityTypes.ACTIVITY_EQUIP_STAR or self.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY or self.index == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE then
        GetElement(self.m_root, "conLeijicc_CellRotalRechargePanel", WZUIContainer):setVisible(true)
        bNPCVisible = false 
        --前往按钮
        if self.index ~= g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY and self.index ~= g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE then 
            if self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY then
                self:_createBtn(GlobalMethod:ccp(0.85,0.7))
            else
                self:_createBtn()
            end            
        end
        local bChangeBG = false 
        if self.m_content then
            local nStart, nEnd = string.find(self.m_content, ".png")
            if nStart then
                bChangeBG = true
                GetElement(self.m_root, "imgLJBK_CellTotalRechargetPanel", WZUIImage):setFile(self.m_content)
            end
        end
        GetElement(self.m_root,"btn_Recharge_event8",WZUIButton):setVisible(false)
        if not bChangeBG then 
            local imgLJBK = GetElement(self.m_root, "imgLJBK_CellTotalRechargetPanel", WZUIImage)
            if self.index == g_tGameActivityTypes.ACTIVITY_EQUIP_STAR then
                imgLJBK:setFile("ui/gameActivity/activity_pic_sxshf.png")
            elseif self.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY then
                imgLJBK:setFile("ui/newActivity/activity_pic_hd_18.png")                
            else
                imgLJBK:setFile("ui/gameActivity/activity_pic_yjdx.png")
            end
        end
    elseif self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST or self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then 
        totleRechargeBanner:setFile("ui/gameActivity/activity_pic_hd_27.png")
    elseif self.index == g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST then
        local totleRechargeBanner = GetElement(self.m_root,"totleRechargeBanner",WZUIImage)
        totleRechargeBanner:setFile("ui/newActivity/activity_pic_hd_04.png")
    else
        local conTotalRecharge_CellTotalRechargetPanel = GetElement(self.m_root, "conTotalRecharge_CellTotalRechargetPanel", WZUIContainer)
        if conTotalRecharge_CellTotalRechargetPanel then
            conTotalRecharge_CellTotalRechargetPanel:setVisible(false)
            GetElement(self.m_root, "img9BKOther_CellTotalRechargetPanel", WZUI9Image):setVisible(true)
        end
    end 

    --hyx 显示充值进度条和充值跳转按钮
    local ActivityProgressContainer = GetElement(self.m_root, "ActivityProgressContainer_CellTotalRechargetPanel", WZUIContainer)
    if ActivityProgressContainer then
        GetElement(self.m_root,"img9BKOther_CellTotalRechargetPanel", WZUI9Image):setVisible(false)
        GetElement(self.m_root,"imgRechargeBK_CellRocalRechargePanel", WZUI9Image):setVisible(false)
        local txt_tip = GetElement(self.m_root,"txt_tip_recharge_reward",WZUILabelTTF)
        if self.index == 4 or self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TOTALRECHARGE or self.index == g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST_TICKET or 
           self.index == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT or self.index == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT2 or self.index == g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE or 
           self.index == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE or
           self.index == g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST or self.index == g_tGameActivityTypes.ACTIVITY_CONTINUOUS_LOGIN or
           self.index == g_tGameActivityTypes.ACTIVITY_RANKING_VICTORY or self.index == g_tGameActivityTypes.ACTIVITY_PET_UPGRADE or
           self.index == g_tGameActivityTypes.ACTIVITY_EQUIPMENT_CALL or self.index == g_tGameActivityTypes.ACTIVITY_ATHLETIC_VICTORY then
            if self.index == g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST_TICKET  then
                totleRechargeBanner:setFile("ui/newActivity/activity_pic_hd_09.png")
            elseif self.index == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT or self.index == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT2 then
                totleRechargeBanner:setFile("ui/newActivity/activity_pic_hd_12.png")
                local conPrgRecharge_CellTatalRechargetPanel = GetElement(self.m_root,"conPrgRecharge_CellTatalRechargetPanel", WZUIContainer)
                conPrgRecharge_CellTatalRechargetPanel:setRelativePosition(GlobalMethod:ccp(0.491042,0.6))

                txt_tip:setRelativePosition(GlobalMethod:ccp(0.0145435,0.6))
            elseif self.index == g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE then
                local conPrgRecharge_CellTatalRechargetPanel = GetElement(self.m_root,"conPrgRecharge_CellTatalRechargetPanel", WZUIContainer)
                conPrgRecharge_CellTatalRechargetPanel:setRelativePosition(GlobalMethod:ccp(0.491042,0.62))

                txt_tip:setRelativePosition(GlobalMethod:ccp(0.0145435,0.65))
            end
            ActivityProgressContainer:setVisible(true)
            if ProjConfig.LANGUAGE == "vn" then
                self:setProgress(self.index)
            end
        elseif self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST or self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then 
            GetElement(self.m_root, "conTotalRecharge_CellTotalRechargetPanel", WZUIContainer):setVisible(false)
            ActivityProgressContainer:setVisible(true)
            txt_tip:setText(LocalStrings.ACTIVITY_CURRENT_CONSUMPTION .. ":")
        end
    end

    local txtCurCostValue = GetElement(self.m_root,"txtCurCostValue_CellTotal",WZUILabelTTF)
    if not txtCurCostValue then
        return
    end
    local progCostProgress = GetElement(self.m_root,"progCostProgress_CellTotal",WZUIProgress)

    -- 适配回归活动界面
    if self.index == g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE then
        txtCurCostValue = GetElement(self.m_root,"txtCurCostValue2_CellTotal",WZUILabelTTF)
        progCostProgress = GetElement(self.m_root,"progCostProgress2_CellTotal",WZUIProgress)
    end

    if self.index == 18 or self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY or self.index == g_tGameActivityTypes.ACTIVITY_EQUIP_STAR or self.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY or self.index == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE then 
        local ActivityPrgContainer = GetElement(self.m_root,"ActivityProgressContainer_CellTotalRechargetPanel",WZUIContainer)
        if ActivityPrgContainer ~= nil then 
            ActivityPrgContainer:setVisible(false)
        end
        if totleRechargeBanner then
            totleRechargeBanner:setVisible(false)
        end
    elseif self.index == g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND then 
        --什么也不用做
    else 
        local nCurNum = 0
        local nTotalNum 

        if self.index == g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE then
            nCurNum = self.maxCount
            nTotalNum = self.target[self.count + 1]
        elseif self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST or self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then 
            if #self.m_tRewardList.m_tDoingList > 0 then 
                for i = 1, #self.m_tRewardList.m_tDoingList do
                    if self.m_tRewardList.m_tDoingList[i].curTarget > nCurNum then 
                        nCurNum = self.m_tRewardList.m_tDoingList[i].curTarget
                    end
                end
            else
                nCurNum = self.maxCount
            end
            nTotalNum = self.maxCount
        else
            nCurNum = self.count
            nTotalNum = self.maxCount
        end
        local stringValue = string.format("%d/%d",nCurNum,nTotalNum)

        if ProjConfig.LANGUAGE == "vn" then
            if self.index == g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE then
                stringValue = nCurNum
            end
        end

        txtCurCostValue:setText(stringValue)
        local PercentValue = 0.0
        if nTotalNum > 0 then 
            PercentValue = nCurNum/nTotalNum
            if PercentValue > 1.0 then 
                PercentValue = 1.0
            end 
            PercentValue = PercentValue * 100 
        end
        progCostProgress:setPercentage(PercentValue)
    end

    if self.index == g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL or self.index == g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL3 then --充值檔位
        GetElement(self.m_root, "conTotalRecharge_CellTotalRechargetPanel", WZUIContainer):setVisible(true)
        GetElement(self.m_root,"img9BKOther_CellTotalRechargetPanel", WZUI9Image):setVisible(false)
        GetElement(self.m_root,"imgRechargeBK_CellRocalRechargePanel", WZUI9Image):setVisible(false)
        GetElement(self.m_root,"conPrgRecharge_CellTatalRechargetPanel", WZUIContainer):setVisible(false)
        GetElement(self.m_root,"txt_tip_recharge_reward", WZUILabelTTF):setVisible(false)
        GetElement(self.m_root, "btn_Recharge_event", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.97,0.9))
        bNPCVisible = false 
        GetElement(self.m_root, "imgLJBK_CellTotalRechargetPanel", WZUIImage):setVisible(false)
        local conLeij = GetElement(self.m_root, "conLeijicc_CellRotalRechargePanel", WZUIContainer)
        conLeij:setVisible(true)
        local txt_info 
        if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
            txt_info = self:createTTF(LocalStrings.ACTIVITY_RECHARGELEVEL_DESC,GlobalMethod:ccp(0.025,-0.15),GlobalMethod:ccp(0,0.5),16,nil,GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(105,65,46))
        else
            txt_info = self:createTTF(LocalStrings.ACTIVITY_RECHARGELEVEL_DESC,GlobalMethod:ccp(0.025,0.7),GlobalMethod:ccp(0,0.5),22,nil,GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(105,65,46),GlobalMethod:CCSize(550,0))
        end
        conLeij:addChild(txt_info,0,94)
    end 

    if NpcImageContainer then 
        NpcImageContainer:setVisible(bNPCVisible)
    end


    -- 适配回归活动界面
    if self.index == g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE then
        self.m_root:setAbsContentSize(GlobalMethod:CCSize(620,390))
        self.m_root:updateRelativeSize()
        GetElement(self.m_root,"conLeijicc_CellRotalRechargePanel",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"img9BKOther_CellTotalRechargetPanel",WZUI9Image):setVisible(false)
        local ActivityProgressContainer = GetElement(self.m_root,"ActivityProgressContainer_CellTotalRechargetPanel",WZUIContainer)
        ActivityProgressContainer:setVisible(true)
        GetElement(self.m_root,"img9TimeBg_CellTotalRechargetPanel",WZUI9Image):setVisible(false)
        local CellTotal_Time_Key = GetElement(self.m_root,"CellTotal_Time_Key",WZUILabelTTF)
        CellTotal_Time_Key:setFontSize(22)
        CellTotal_Time_Key:setColor(ccc3(255,255,255))
        CellTotal_Time_Key:setStrokeColor(ccc3(40,60,140))
        CellTotal_Time_Key:setRelativePosition(GlobalMethod:ccp(0.038,2.47))
        local CellTotal_day_value = GetElement(self.m_root,"CellTotal_day_value",WZUILabelTTF)
        CellTotal_day_value:setFontSize(22)
        CellTotal_day_value:setColor(ccc3(99,255,96))
        CellTotal_day_value:setStrokeColor(ccc3(40,60,140))
        local txt_tip_recharge_reward = GetElement(self.m_root,"txt_tip_recharge_reward",WZUILabelTTF)
        txt_tip_recharge_reward:setColor(ccc3(255,255,255))
        txt_tip_recharge_reward:setStrokeColor(ccc3(40,60,140))
        GetElement(self.m_root,"TabParentContainer_Obj",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"conPrgRecharge_CellTatalRechargetPanel",WZUIContainer):setVisible(false)
        local conPrgRecharge2 = GetElement(self.m_root,"conPrgRecharge2_CellTatalRechargetPanel",WZUIContainer)
        conPrgRecharge2:setVisible(true)
        conPrgRecharge2:setRelativePosition(GlobalMethod:ccp(0.445,0.83))
        local btn_Recharge_event = GetElement(self.m_root,"btn_Recharge_event",WZUIButton)
        btn_Recharge_event:setRelativePosition(GlobalMethod:ccp(0.946,1.078))
        GetElement(self.m_root,"img9Bg_CellTotalRechargetPanel",WZUI9Image):setVisible(false)

        local flconBack = GetElement(self.m_root,"flconBack_CellTotalRechargetPanel",WZUIFreeListContainer)
        flconBack:update()
        flconBack:getMoveElement():setPositionY(flconBack:getMinPosition().y)
    end
end
function CellTotalRechargetPanel:setProgress(activity)
    local txt_tip_recharge_reward = GetElement(self.m_root,"txt_tip_recharge_reward",WZUILabelTTF)
    if activity == g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST then
        txt_tip_recharge_reward:setText("Đã tiêu:")
        GetElement(self.m_root,"btn_Recharge_event",WZUIButton):setVisible(false)
    elseif activity == g_tGameActivityTypes.ACTIVITY_CONTINUOUS_LOGIN or activity == g_tGameActivityTypes.ACTIVITY_RANKING_VICTORY or
           activity == g_tGameActivityTypes.ACTIVITY_PET_UPGRADE or activity == g_tGameActivityTypes.ACTIVITY_EQUIPMENT_CALL or
           activity == g_tGameActivityTypes.ACTIVITY_ATHLETIC_VICTORY then
        txt_tip_recharge_reward:setText("Tiến độ:")
    end
end

function CellTotalRechargetPanel:createTTF(desc,pt,anchor,font,Align,color,sclolor,dimensions)
    desc = desc or ""
    font = font or 22
    color = color or GlobalMethod:ccc3(105,65,46)
    sclolor = sclolor or GlobalMethod:ccc3(105,65,46)
    Align = Align or kCCTextAlignmentLeft
    anchor = anchor or GlobalMethod:ccp(0,0.5)
    pt = pt or GlobalMethod:ccp(0,0.5)
    dimensions = dimensions or GlobalMethod:CCSize(350,0)
    local txt = WZUILabelTTF:create()
    txt:setFontSize(font)
    txt:setColor(color)
    txt:setText(desc)
    txt:setBoldFont(false)
    txt:setEnableStroke(true)
    txt:setStrokeColor(sclolor)
    txt:setStrokeSize(4)
    txt:setTouchEnable(false)
    txt:setAlignment(Align)
    txt:setDimensions(dimensions)
    txt:setAnchorPoint(anchor)
    txt:setRelativePosition(pt)
    return txt
end

--@brief    点击规则按钮回调
function CellTotalRechargetPanel:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.index == g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND then
        WndSingleMapDesc:showInterface1(LocalStrings.GAMEACTIVITY_TIPTEXT10) 
    elseif self.index == g_tGameActivityTypes.ACTIVITY_FIVETIMES_DIAMOND then 
        WndSingleMapDesc:showInterface1(LocalStrings.GAMEACTIVITY_NEWRECHARGEBACK) 
    elseif self.index == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE then 
        WndSingleMapDesc:showInterface1(LocalStrings.GAMEACTIVITY_TIPTEXT6) 
    else
        WndSingleMapDesc:showInterface1(LocalStrings.NEWUSER_WEAFARE_RETURN_RULE) 
    end
end

--@brief    点击前往按钮回调
function CellTotalRechargetPanel:onClickGoto(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.index == g_tGameActivityTypes.ACTIVITY_EQUIP_STAR then 
        WndGameActivity:closeGameActivity()
        JumpByUIId(72)
    elseif self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY then
        JumpByUIId(12)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 初始化静态文本
function CellTotalRechargetPanel:_initStaticTxt(  )
    if self.m_root == nil then return end 

    local Time_Key = GetElement(self.m_root,"CellTotal_Time_Key",WZUILabelTTF)
    if not Time_Key then return end

    Time_Key:setText(LocalStrings.ACTIVE_TIME..":")

    if self.index == g_tGameActivityTypes.ACTIVITY_TYPE_NOVICE_ACCUMULATIVE then
        Time_Key:setText(LocalStrings.COUNTDOWN)
        GetElement(self.m_root, "btnRule_CellTotalRechargetPanel", WZUIButton):setVisible(true)
    elseif self.index == g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND or self.index == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE or self.index == g_tGameActivityTypes.ACTIVITY_FIVETIMES_DIAMOND then
        GetElement(self.m_root, "btnRule_CellTotalRechargetPanel", WZUIButton):setVisible(true)
    end
    
    local txt_tip = GetElement(self.m_root,"txt_tip_recharge_reward",WZUILabelTTF)
    if self.index == 18 or self.index == g_tGameActivityTypes.ACTIVITY_EQUIP_STAR or self.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY or self.index == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE then  --装备强化
    elseif self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY then --累计副本
    else 
        if self.index == 4 
            or self.index == g_tGameActivityTypes.ACTIVITY_TYPE_NOVICE_ACCUMULATIVE 
            or self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TOTALRECHARGE 
            or self.index == g_tGameActivityTypes.ACTIVITY_FIVETIMES_DIAMOND
            or self.index == g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE 
			or self.index == g_tGameActivityTypes.ACTIVITY_CHANNEL_RECHARGE 
            or self.index == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT 
            or self.index == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT2
            or self.index == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE then --累计充值
            txt_tip:setText(LocalStrings.ACTIVITY_PREPAID_PHONE .. ":")
            if ProjConfig.LANGUAGE == "es" then
                txt_tip:setFontSize(16)
                txt_tip:setRelativePosition(GlobalMethod:ccp(0,0.5))
            end
        elseif self.index == 6 or self.index == g_tGameActivityTypes.ACTIVITY_COST_ONLYDIAMOND then  --累计消费
            txt_tip:setText(LocalStrings.ACTIVITY_CURRENT_CONSUMPTION .. ":")
        elseif self.index == g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST_TICKET or self.index == g_tGameActivityTypes.ACTIVITY_COST_ONLYTICKET then 
            --累积消费礼券
            txt_tip:setText(LocalStrings.ACTIVITY_CURRENT_CONSUMPTION .. ":")
        elseif self.index == g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE then  --连续充值
            txt_tip:setText(LocalStrings.CONTINUE_RECHARGE_WORD .. ":")
            txt_tip:setFontSize(16)
        elseif self.index == g_tGameActivityTypes.ACTIVITY_ATHLETIC_VICTORY or self.index == g_tGameActivityTypes.ACTIVITY_RANKING_VICTORY or self.index == g_tGameActivityTypes.ACTIVITY_PET_UPGRADE or self.index == g_tGameActivityTypes.ACTIVITY_MOUNT_UPGRADE or self.index == g_tGameActivityTypes.ACTIVITY_EQUIPMENT_CALL or self.index == g_tGameActivityTypes.ACTIVITY_PET_QUAIL or self.index == g_tGameActivityTypes.ACTIVITY_CONTINUOUS_LOGIN then
            txt_tip:setText(LocalStrings.TOTAL_PROGRESS)
        elseif self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST or self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then 
            txt_tip:setText(LocalStrings.ACTIVITY_CURRENT_CONSUMPTION .. ":")
            txt_tip:setColor(GlobalMethod:ccc3(255,236,193))
            txt_tip:setStrokeColor(GlobalMethod:ccc3(132,66,29))
        end 
    end 
end

--@brief 定时器
function CellTotalRechargetPanel:_scheduleUpdateTime(element, data)
    self.reduceTime = self.reduceTime + data
    if self.reduceTime > 1.0 then
        self.reduceTime = 0.0
        if self.now_time <= 0 and self.b_scheduleState then
            self.b_scheduleState = false
            self.m_root:disableSchedule()
        elseif self.now_time>0 and self.b_scheduleState then
            self.now_time = self.now_time - 1 
            local n_hour = self.now_time / 3600
            n_hour = math.floor(n_hour)
            local n_min = (self.now_time - n_hour*3600)/60
            n_min = math.floor(n_min)
            local n_sec = self.now_time%60
            local txt_string = string.format("%02d:%02d:%02d",n_hour,n_min,n_sec)
            local txt_time_value = GetElement(self.m_root,"CellTotal_Time_Value",WZUILabelTTF)
            txt_time_value:setText(txt_string)
        end
    end 
end

--@brief 计算倒计时时间
function CellTotalRechargetPanel:_caculateTime(  )
    if self.m_root == nil then return end 

    local CellTotal_day_value = GetElement(self.m_root,"CellTotal_day_value",WZUILabelTTF)
    if not CellTotal_day_value then return end
    if not self.startTime then return end

    local DayStartTab = os.date("*t",self.startTime)
    local DayEndTab = os.date("*t",self.endTime)

    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)

    if self.index == g_tGameActivityTypes.ACTIVITY_TYPE_NOVICE_ACCUMULATIVE then
        if ProjConfig.LANGUAGE == "vn" then
        elseif  ProjConfig.LANGUAGE == "pt" then
            CellTotal_day_value:setRelativePositionLuaTo(0.4,0.5)
        elseif  ProjConfig.LANGUAGE == "th" then
            CellTotal_day_value:setRelativePositionLuaTo(0.62,0.5)
        elseif ProjConfig.LANGUAGE == "es" then
            CellTotal_day_value:setRelativePositionLuaTo(0.7,0.5)
        elseif ProjConfig.LANGUAGE == "en" then
            CellTotal_day_value:setRelativePositionLuaTo(0.4,0.5)
        elseif ProjConfig.LANGUAGE == "tr" then
            CellTotal_day_value:setRelativePositionLuaTo(0.558,0.5)
        else
            CellTotal_day_value:setRelativePositionLuaTo(0.31,0.5)
        end
        local timeCur = os.date("*t",SystemTime:getServerTime())
        WZLog("CellTotalRechargetPanel:_caculateTime", self.endTime, timeCur.yday, timeCur.year, timeCur.month, timeCur.day, DayEndTab.yday, DayEndTab.year, DayEndTab.month, DayEndTab.day)
        local time = 0
        if timeCur.year > DayEndTab.year then
            time = 0
        elseif timeCur.yday <= DayEndTab.yday then
            time = DayEndTab.yday - timeCur.yday
        elseif timeCur.month > DayEndTab.month and timeCur.year < DayEndTab.year then
            local year = timeCur.year
            local isRN = (year%4==0 and year%100 ~=0 ) or (year%400==0)
            local day = isRN and 366 or 365
            time = day - timeCur.yday + DayEndTab.yday
        end
        needDay_str = string.format(LocalStrings.SHOP_DAY,time)
    end
    
    
    CellTotal_day_value:setText(needDay_str)
end


--@brief 设置奖励列表
function CellTotalRechargetPanel:_setRewardList(  )
    if self.m_root == nil then return end 
    
    local confl_listview = nil 
    local tabFreelist = nil 
    if self.index == 18 then  --装备强化
        GetElement(self.m_root, "conTime_CellTocalRechargetPanel", WZUIContainer):setVisible(false)
        tabFreelist = GetElement(self.m_root,"confl_listview_rechargePanel",WZUIFreeListContainer)
        tabFreelist:setVisible(false)
        GetElement(self.m_root,"conflConsume_CellTotalRechargePanel",WZUIFreeListContainer):setVisible(false)
        confl_listview = GetElement(self.m_root,"confl_cy_listview_rechargePanel",WZUIFreeListContainer)
    elseif self.index == 6 or self.index == g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST_TICKET or self.index == g_tGameActivityTypes.ACTIVITY_COST_ONLYTICKET or self.index == g_tGameActivityTypes.ACTIVITY_COST_ONLYDIAMOND 
         or self.index == g_tGameActivityTypes.ACTIVITY_ATHLETIC_VICTORY or self.index == g_tGameActivityTypes.ACTIVITY_RANKING_VICTORY or self.index == g_tGameActivityTypes.ACTIVITY_PET_UPGRADE or self.index == g_tGameActivityTypes.ACTIVITY_MOUNT_UPGRADE or self.index == g_tGameActivityTypes.ACTIVITY_EQUIPMENT_CALL or self.index == g_tGameActivityTypes.ACTIVITY_PET_QUAIL or self.index == g_tGameActivityTypes.ACTIVITY_CONTINUOUS_LOGIN or self.index == g_tGameActivityTypes.ACTIVITY_CHANNEL_RECHARGE or self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST or self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then
        tabFreelist = GetElement(self.m_root,"confl_cy_listview_rechargePanel",WZUIFreeListContainer)
        tabFreelist:setVisible(false)
        GetElement(self.m_root,"confl_listview_rechargePanel",WZUIFreeListContainer):setVisible(false)
        confl_listview = GetElement(self.m_root, "conflConsume_CellTotalRechargePanel", WZUIFreeListContainer)
    elseif self.index == g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE then
        tabFreelist = GetElement(self.m_root,"confl_cy_listview_rechargePanel",WZUIFreeListContainer)
        tabFreelist:setVisible(false)
        GetElement(self.m_root, "conflConsume_CellTotalRechargePanel", WZUIFreeListContainer):setVisible(false)
        confl_listview = GetElement(self.m_root,"flconBack_CellTotalRechargetPanel",WZUIFreeListContainer)
        confl_listview:setVisible(true)
    else 
        if self.index == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE then
            GetElement(self.m_root, "conTime_CellTocalRechargetPanel", WZUIContainer):setVisible(false)
        end
        tabFreelist = GetElement(self.m_root,"confl_cy_listview_rechargePanel",WZUIFreeListContainer)
        if tabFreelist then
            tabFreelist:setVisible(false)
            GetElement(self.m_root, "conflConsume_CellTotalRechargePanel", WZUIFreeListContainer):setVisible(false)
            confl_listview = GetElement(self.m_root,"confl_listview_rechargePanel",WZUIFreeListContainer)
        end
    end 
    if confl_listview == nil then
        return
    end
    if tabFreelist == nil then
        return
    end
    if confl_listview:size() > 0 then 
        confl_listview:removeAll()
    end 
    self.cellItemIndex = 1 
    self.m_currentIndex = 1
    self:_loadItemByFrame(confl_listview)
end

function CellTotalRechargetPanel:_loadItemByFrame(element)
    if element == nil then 
        return 
    end 
    element = WZUIFreeListContainer:luaTo(element)
    local listCount = #self.m_tRewardList.m_tDoingList + #self.m_tRewardList.m_tDoneList
    if listCount == 0 then 
        return 
    end 
    for i = 1, listCount do
        local ItemTab = nil 
        if self.m_currentIndex > #self.m_tRewardList.m_tDoingList then 
            ItemTab = self.m_tRewardList.m_tDoneList[self.cellItemIndex]
            self.cellItemIndex = self.cellItemIndex + 1
        else 
            ItemTab = self.m_tRewardList.m_tDoingList[self.cellItemIndex]
            if self.m_currentIndex == #self.m_tRewardList.m_tDoingList then 
                self.cellItemIndex = 1 
            else 
                self.cellItemIndex = self.cellItemIndex + 1
            end 
        end

        local cellElement,newLuaObj = CellTotalRechargeItem:createElement()
        cellElement = WZUIContainer:luaTo(cellElement)
        if self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY or self.index == g_tGameActivityTypes.ACTIVITY_EQUIP_STAR or self.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY then 
            newLuaObj:setIndex(self.index,ItemTab.target, ItemTab.curTarget)
        elseif self.index == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE then 
            newLuaObj:setIndex(self.index, ItemTab.tip, ItemTab.rechargeId)
        else
            newLuaObj:setIndex(self.index, ItemTab.target)
        end
        newLuaObj:setMessage(self.m_currentIndex, ItemTab.rewardId, ItemTab.m_tData, ItemTab.tip, ItemTab.status, self.activityId)
        cellElement:setTag(self.m_currentIndex-1)
        cellElement:setContentSize(GlobalMethod:CCSize(626,122))
        
        if self.index == 18 then 
            cellElement:setRelativeSize(GlobalMethod:CCSize(1,138/374))
            newLuaObj:setGradeIndex(ItemTab.GradeIndex)
        elseif self.index == 6 or self.index == g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST_TICKET or self.index == g_tGameActivityTypes.ACTIVITY_COST_ONLYTICKET or self.index == g_tGameActivityTypes.ACTIVITY_COST_ONLYDIAMOND 
             or self.index == g_tGameActivityTypes.ACTIVITY_ATHLETIC_VICTORY or self.index == g_tGameActivityTypes.ACTIVITY_RANKING_VICTORY or self.index == g_tGameActivityTypes.ACTIVITY_PET_UPGRADE or self.index == g_tGameActivityTypes.ACTIVITY_MOUNT_UPGRADE or self.index == g_tGameActivityTypes.ACTIVITY_EQUIPMENT_CALL or self.index == g_tGameActivityTypes.ACTIVITY_PET_QUAIL or self.index == g_tGameActivityTypes.ACTIVITY_CONTINUOUS_LOGIN or self.index == g_tGameActivityTypes.ACTIVITY_CHANNEL_RECHARGE or self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST or self.index == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then
            cellElement:setRelativeSize(GlobalMethod:CCSize(1,0.36))
        else 
            if self.index == g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE then
                newLuaObj:setRechargeDay(self:getFinishDays())
            elseif self.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY then
                newLuaObj:setGradeIndex(ItemTab.GradeIndex)
            end
            if self.index == g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE or self.index == g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL or self.index == g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL3 or
               self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TOTALRECHARGE or self.index == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT or self.index == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT2 or
               self.index == g_tGameActivityTypes.ACTIVITY_TOTALFIRSTRECHARGE or self.index == g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND or 
               self.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY or self.index == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE or
               self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY or self.index == g_tGameActivityTypes.ACTIVITY_CHARGE30_REBATE or self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_BIGSEND then
                cellElement:setRelativeSize(GlobalMethod:CCSize(1,0.38))
            else
                cellElement:setRelativeSize(GlobalMethod:CCSize(1,0.5))
            end
        end 
        newLuaObj:setFunc(self.sortItemByIndex,CellTotalRechargetPanel)

        element:pushBack(cellElement)
        self.m_currentIndex = self.m_currentIndex + 1
    end

    element:update()
    element:getMoveElement():setPositionY(element:getMinPosition().y)
end


--@brief 前往充值
function CellTotalRechargetPanel:RechargeEvent(  )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.index == g_tGameActivityTypes.ACTIVITY_TOTALFIRSTRECHARGE then 
        SendBusinessCode(BUSINESSCODE_STATICVALUE + self.index, 1, true)
    end
    PassportSdkManager:gotoPaymentPage()
end
function CellTotalRechargetPanel:RechargeEvent8(  )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    PassportSdkManager:gotoPaymentPage()
end

function CellTotalRechargetPanel:_setTabList(  )
	if not self.rewardId then return end
    self.m_tRewardList = {}
    self.m_tRewardList.m_tDoingList = {}
    self.m_tRewardList.m_tDoneList = {}
    local ItemCount = 1
    local DoneIdx = 1
    local DoingIdx = 1
    local itemIndex = 1
    local listCount = #self.rewardId
    if self.index == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE then 
        for i = 1, listCount do
            local Items = self.m_tRewardList.m_tDoneList
            Items[DoneIdx] = {}
            Items[DoneIdx].rewardId = self.rewardId[i]

            local sex = CacheCenter:getPlayerInfo().sex
            local giftList = {}
            local sexIndex = {"man_item_id","woman_item_id"}

            for k,v in pairs(GDatatab_gifts) do
                if v.item_id == self.rewardItems[i] then
                    local temp = {}
                    temp.id = v[sexIndex[sex+1]]
                    temp.num = v["count"]
                    table.insert(giftList,temp)
                end
            end

            Items[DoneIdx].m_tData = giftList 
            Items[DoneIdx].tip = self.tips[i]
            Items[DoneIdx].status = self.status[i]
            Items[DoneIdx].rechargeId = self.rewardCounts[i]

            DoneIdx = DoneIdx +1
        end
        table.sort(self.m_tRewardList.m_tDoneList, sortReward)
    else
        for i=1, listCount do
            local Items
            local bIsOutDate = false 
            --已过期
            if self.index == g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND or self.index == g_tGameActivityTypes.ACTIVITY_FIVETIMES_DIAMOND then 
                if self.status[i] == 2 then 
                    bIsOutDate = true 
                end
            end
            if self.status[i] == 1 or bIsOutDate then 
                Items = self.m_tRewardList.m_tDoneList
                Items[DoneIdx] = {}
                Items[DoneIdx].rewardId = self.rewardId[i]
                local tData = {}
                local itemCount = self.rewardCounts[i]
                for i=1,itemCount do
                    local t_item = {id=self.rewardItems[itemIndex],num=self.rewardItemsParamCount[itemIndex]}
                    table.insert(tData,t_item)
                    itemIndex = itemIndex + 1
                end
                Items[DoneIdx].m_tData = tData 
                if self.index == g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE then
                    Items[DoneIdx].tip = tostring(self.rewardId[i] + 1)
                else
                    Items[DoneIdx].tip = self.tips[i]
                end
                Items[DoneIdx].status = self.status[i]
                if self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY then 
                    Items[DoneIdx].target = self.target[i]
                    Items[DoneIdx].curTarget = self.target[2 * listCount + i]
                elseif self.index == g_tGameActivityTypes.ACTIVITY_EQUIP_STAR or self.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY then 
                    Items[DoneIdx].target = self.target[i]      --目标次数
                    Items[DoneIdx].curTarget = self.target[listCount + i] --界面Id
                else
                    Items[DoneIdx].target = self.target[i]
                end
                if self.index == 18 then 
                    Items[DoneIdx].GradeIndex = self.target[listCount + i]
                elseif self.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY then
                    Items[DoneIdx].GradeIndex = self.target[2 * listCount + i]   --当前进度
                end 
                DoneIdx = DoneIdx +1
            else 
                Items = self.m_tRewardList.m_tDoingList 
                Items[DoingIdx] = {}
                Items[DoingIdx].rewardId = self.rewardId[i]
                local tData = {}
                local itemCount = self.rewardCounts[i]
                for i=1,itemCount do
                    local t_item = {id=self.rewardItems[itemIndex],num=self.rewardItemsParamCount[itemIndex]}
                    table.insert(tData,t_item)
                    itemIndex = itemIndex + 1
                end
                Items[DoingIdx].m_tData = tData
                if self.index == g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE then
                    Items[DoingIdx].tip = tostring(self.rewardId[i] + 1)
                else
                    Items[DoingIdx].tip = self.tips[i]
                end
                Items[DoingIdx].status = self.status[i]
                if self.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY then 
                    Items[DoingIdx].target = self.target[i]
                    Items[DoingIdx].curTarget = self.target[2 * listCount + i]
                elseif self.index == g_tGameActivityTypes.ACTIVITY_EQUIP_STAR or self.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY then 
                    Items[DoingIdx].target = self.target[i]
                    Items[DoingIdx].curTarget = self.target[listCount + i]
                else
                    Items[DoingIdx].target = self.target[i]
                end

                if self.index == 18 then 
                    Items[DoingIdx].GradeIndex = self.target[listCount + i]
                elseif self.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY then
                    Items[DoingIdx].GradeIndex = self.target[2 * listCount + i]
                end
                DoingIdx = DoingIdx +1
            end 
        end
        table.sort(self.m_tRewardList.m_tDoingList, sortReward)
    end

    WZLog("CellTotalRechargetPanel:_setTabList", Serialize(self.m_tRewardList.m_tDoingList), Serialize(self.m_tRewardList.m_tDoneList))
end

function sortReward(a, b)
    -- body
    if a.status ~= b.status then
        return a.status > b.status
    else
        return a.rewardId < b.rewardId
    end
end

--@brief    
function CellTotalRechargetPanel:sortItemByIndex( nIndex )
    WZLog("CellTotalRechargetPanel:removeItemByIndex index="..nIndex)
    local size =  #CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoingList
    local removePos = 0
    for i=1, size do
        if nIndex == CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoingList[i].rewardId then 
            local len = #CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoneList
            CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoneList[len+1] = {}
            CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoneList[len+1].rewardId = CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoingList[i].rewardId
            CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoneList[len+1].m_tData = CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoingList[i].m_tData
            CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoneList[len+1].status=1
            CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoneList[len+1].tip=CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoingList[i].tip
            CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoneList[len+1].target = CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoingList[i].target
            if  CellTotalRechargetPanel.m_current.index == 18 then 
                CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoneList[len+1].GradeIndex = CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoingList[i].GradeIndex
            elseif CellTotalRechargetPanel.m_current.index == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY then 
                CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoneList[len+1].GradeIndex = CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoingList[i].GradeIndex
                CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoneList[len+1].curTarget = CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoingList[i].curTarget
            elseif CellTotalRechargetPanel.m_current.index == g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY or CellTotalRechargetPanel.m_current.index == g_tGameActivityTypes.ACTIVITY_EQUIP_STAR then 
                CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoneList[len+1].curTarget = CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoingList[i].curTarget
            end 
            removePos = i
        end 
    end
    table.remove(CellTotalRechargetPanel.m_current.m_tRewardList.m_tDoingList,removePos)
    CellTotalRechargetPanel.m_current:_setRewardList()
end

--@brief    创建前往按钮
function CellTotalRechargetPanel:_createBtn(pos)
    pos = pos or GlobalMethod:ccp(0.85,-0.1)
    -- body
    local conLeijicc = GetElement(self.m_root, "conLeijicc_CellRotalRechargePanel", WZUIContainer)

    local btnGoto = WZUIButton:create()
    btnGoto:setName("btnGoto_CellFamilyBuilding")
    btnGoto:setUseAbsSize(true)
    btnGoto:setAbsContentSize(GlobalMethod:CCSize(124,54))
    
	btnGoto:setRelativePosition(pos)
    local imgNor = WZUIImage:create()
    imgNor:setUseOriginSize(true)
    imgNor:setFile("ui/common/common_btn_05.png")
    local imgSel = WZUIImage:create()
    imgSel:setUseOriginSize(true)
    imgSel:setFile("ui/common/common_btn_05.png")
    local imgNot = WZUIImage:create()
    imgNot:setUseOriginSize(true)
    imgNot:setGrayRender(true)
    imgNot:setFile("ui/common/common_btn_05.png")
    btnGoto:setNormalElement(imgNor)
    btnGoto:setSelectElement(imgSel)
    btnGoto:setDisableElement(imgNot)
    btnGoto:setLuaDoneFunctionName("onClickGoto")
    btnGoto:setLuaActionName("Normal")

    local txtBtn = WZUILabelTTF:create()
    txtBtn:setText(LocalStrings.ACTIVE_BTN_GO)
    txtBtn:setColor(GlobalMethod:ccc3(255,250,236))
    txtBtn:setStrokeColor(GlobalMethod:ccc3(163,70,20))
    txtBtn:setFontSize(26)
    txtBtn:setEnableStroke(true)
    txtBtn:setStrokeSize(4)
    btnGoto:addChild(txtBtn)

    conLeijicc:addChild(btnGoto)
end

function CellTotalRechargetPanel:onBtnRule()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.OPTIMIZE_TEXT53)
end

function CellTotalRechargetPanel:_adaptLanguage_en(  )
    local txt_tip_recharge_reward = GetElement(self.m_root,"txt_tip_recharge_reward",WZUILabelTTF)
    txt_tip_recharge_reward:setFontSize(16)
    txt_tip_recharge_reward:setDimensions(GlobalMethod:CCSize(110))

    local CellTotal_day_value = GetElement(self.m_root,"CellTotal_day_value",WZUILabelTTF)
    CellTotal_day_value:setRelativePosition(GlobalMethod:ccp(0.16,0.5))

    GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF):setScale(0.75)
    
end

function CellTotalRechargetPanel:_adaptLanguage_pt(  )
    local txt_tip_recharge_reward = GetElement(self.m_root,"txt_tip_recharge_reward",WZUILabelTTF)
    txt_tip_recharge_reward:setScale(0.8)
    txt_tip_recharge_reward:setDimensions(GlobalMethod:CCSize(130))

    local txt = GetElement(self.m_root,"CellTotal_day_value",WZUILabelTTF)
    txt:setRelativePosition(GlobalMethod:ccp(0.16,0.5))
end

function CellTotalRechargetPanel:_adaptLanguage_es(  )
    local txt = GetElement(self.m_root,"CellTotal_Time_Key",WZUILabelTTF)
    txt:setFontSize(18)
    local txt_tip_recharge_reward = GetElement(self.m_root,"txt_tip_recharge_reward",WZUILabelTTF)
    txt_tip_recharge_reward:setScale(0.8)
    txt_tip_recharge_reward:setDimensions(GlobalMethod:CCSize(130,0))
end

function CellTotalRechargetPanel:_adaptLanguage_tr(  )
    local txt_tip_recharge_reward = GetElement(self.m_root,"txt_tip_recharge_reward",WZUILabelTTF)
    txt_tip_recharge_reward:setFontSize(16)
    txt_tip_recharge_reward:setRelativePosition(GlobalMethod:ccp(-0.02,0.5))
end

function CellTotalRechargetPanel:_adaptLanguage_ug(  )
    GetElement(self.m_root,"CellTotal_day_value",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0,0.5))
    GetElement(self.m_root,"CellTotal_Time_Key",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.54,0.5))

    local txt_tip_recharge_reward = GetElement(self.m_root,"txt_tip_recharge_reward",WZUILabelTTF)
    txt_tip_recharge_reward:setScale(0.55)
    txt_tip_recharge_reward:setDimensions(GlobalMethod:CCSize(200))
    local txt_gotoButton = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txt_gotoButton:setScale(0.5)
    txt_gotoButton:setDimensions(GlobalMethod:CCSize(200))
end

-------------------------------------私有方法模块End----------------------------------------
