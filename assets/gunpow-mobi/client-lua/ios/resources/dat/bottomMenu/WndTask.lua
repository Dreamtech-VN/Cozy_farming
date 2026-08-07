--WndTask.lua
--@brief	WndTask的UI模块
--@date		2014/09/05
--@author	SuYuan
--@note		任务模块

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTask:onEnter(element)
	self.m_root = element

    self:teachOnRefresh()

    GlobalGame.m_bIsShowEquipDressUp = nil
    CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	self:_setStaticText()
	
    --多语言版本界面适配
    AdaptLanguage(self)
end

--@brief 刷新教学
function WndTask:teachOnRefresh()
    local isFinish3, finishStep3 = TeachGroup1:isTeachFinish(3)
    local isFinish5, finishStep5 = TeachGroup1:isTeachFinish(5)
    local isFinish7, finishStep7 = TeachGroup1:isTeachFinish(7)
    local isFinish8, finishStep8 = TeachGroup1:isTeachFinish(8)
    local isFinish9, finishStep9 = TeachGroup1:isTeachFinish(9)
    local isFinish20, finishStep20 = TeachGroup1:isTeachFinish(20)
    local isFinish31, finishStep31 = TeachGroup1:isTeachFinish(31)
    local isFinish32, finishStep32 = TeachGroup1:isTeachFinish(32)
    local isFinish33, finishStep33 = TeachGroup1:isTeachFinish(33)
    local isFinish34, finishStep34 = TeachGroup1:isTeachFinish(34)
    local isFinish35, finishStep35 = TeachGroup1:isTeachFinish(35)
    local isFinish36, finishStep36 = TeachGroup1:isTeachFinish(36)
    local isFinish39, finishStep39 = TeachGroup1:isTeachFinish(39)
    local isFinish40, finishStep40 = TeachGroup1:isTeachFinish(40)
    local isFinish41, finishStep41 = TeachGroup1:isTeachFinish(41)
    WZLog("WndTask:teachOnRefresh", "fin3", isFinish3, finishStep3, "fin5", isFinish5, finishStep5,
     "fin7", isFinish7, finishStep7, "fin8", isFinish8, finishStep8, "fin9", isFinish9, finishStep9, 
     "fin20", isFinish20, finishStep20, "fin31", isFinish31, finishStep31, "fin32", isFinish32, finishStep32, 
     "fin33", isFinish33, finishStep33, "fin34", isFinish34, finishStep34, "fin35", isFinish35, finishStep35, 
     "fin36", isFinish36, finishStep36, "fin39", isFinish39, finishStep39, "fin40", isFinish40, finishStep40, "fin41", isFinish41, finishStep41)
    if (isFinish3 ~= true and finishStep3 > 0) or (isFinish5 ~= true and finishStep5 > 0) or 
        (isFinish7 ~= true and finishStep7 > 0) or (isFinish8 ~= true and finishStep8 > 0) or 
        (isFinish9 ~= true and finishStep9 > 0) or (isFinish20 ~= true and finishStep20 > 0) or 
        (isFinish31 ~= true and finishStep31 > 0) or (isFinish32 ~= true and finishStep32 > 0) or 
        (isFinish33 ~= true and finishStep33 > 0) or (isFinish34 ~= true and finishStep34 > 0) or 
        (isFinish35 ~= true and finishStep35 > 0) or (isFinish36 ~= true and finishStep36 > 0) or 
        (isFinish39 ~= true and finishStep39 > 0) or (isFinish40 ~= true and finishStep40 > 0) or (isFinish41 ~= true and finishStep41 > 0) then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
        self.m_bIsTeach = true
    end
end

--@brief onEnter函数执行完成回调
function WndTask:onEnterTransitionDidFinish(element)
    ChangeChatChannel(Chat_Channel_Task_Main)
    WZLog("WndTask:onEnterTransitionDidFinish-MainTask->"..GlobalGame.g_nMainTaskCount)
    WZLog("WndTask:onEnterTransitionDidFinish-BranchTask->"..GlobalGame.g_nBranchTaskCount)
    WZLog("WndTask:onEnterTransitionDidFinish-DailyTask->"..GlobalGame.g_nDailyTaskCount)
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)

    --判断是否可以点击每日任务
    local bRet,msg_daily = self:_ifTaskOpen(38)
    local checkBoxDaily_WndTask = GetElement(self.m_root,"checkBoxDaily_WndTask",WZUIContainer)
    if checkBoxDaily_WndTask == nil then
       return
    end
    if not bRet then
        checkBoxDaily_WndTask:setTouchEnable(false)
    else
        checkBoxDaily_WndTask:setTouchEnable(true)
    end
    --判断支线任务是否可以点击
    local bRet_branch,msg_branch = self:_ifTaskOpen(37)
    local checkBoxBranch_WndTask = GetElement(self.m_root,"checkBoxBranch_WndTask",WZUIContainer)
    if checkBoxBranch_WndTask == nil then
        return
    end
    if not bRet_branch then
        checkBoxBranch_WndTask:setTouchEnable(false)
    else
        checkBoxBranch_WndTask:setTouchEnable(true)
    end
    --判断竞技是否可以点击
    local bRet_athletics,msg_athletics = self:_ifTaskOpen(5)
    local checkBoxAthletics = GetElement(self.m_root,"checkBoxAthletics_WndTask",WZUIContainer)
    if checkBoxAthletics == nil then
        return
    end
    if not bRet_athletics then
        checkBoxAthletics:setTouchEnable(false)
    else
        checkBoxAthletics:setTouchEnable(true)
    end

    self:_setTaskCount()
    --获取月卡时间
    self:_getMonthCardTime()
end

--@brief   触摸回调 add by wuweidong
function WndTask:onTouchBegan(element,pt) 
    local point = self.m_root:getParentElement():convertToNodeSpace(pt)
    local bPoint = WndItemInfo:checkPoint(pt,dir)
    if bPoint == true then
    else 
        WndItemInfo:onCloseClick()
    end

    --日常任务开启判断
    local checkBoxDaily_WndTask = GetElement(self.m_root,"checkBoxDaily_WndTask",WZUICheckBox)
    if checkBoxDaily_WndTask == nil then
        return
    end
    local bRet,msg_daily = self:_ifTaskOpen(38)
    if bRet then
        checkBoxDaily_WndTask:setTouchEnable(true)
    end
    if not bRet then
        local size = checkBoxDaily_WndTask:getAbsContentSize()
        local pt1 = checkBoxDaily_WndTask:convertToNodeSpace(GlobalMethod:ccp(pt.x,pt.y))
        if pt1.x > 0 and pt1.x < (size.width) then
            if pt1.y > 0 and pt1.y < (size.height) then
                SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
                MsgBoxManager:showTipBox(msg_daily)
            end
        end
    end
    --支线的开启判断
    local checkBoxBranch_WndTask = GetElement(self.m_root,"checkBoxBranch_WndTask",WZUICheckBox)
    if checkBoxBranch_WndTask == nil then
        return
    end
    local bRet_branch,msg_branch = self:_ifTaskOpen(37)
    if bRet_branch then
        checkBoxBranch_WndTask:setTouchEnable(true)
    end
    if not bRet_branch then
        local size = checkBoxBranch_WndTask:getAbsContentSize()
        local pt1 = checkBoxBranch_WndTask:convertToNodeSpace(GlobalMethod:ccp(pt.x,pt.y))
        if pt1.x > 0 and pt1.x < (size.width) then
            if pt1.y > 0 and pt1.y < (size.height) then
                SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
                MsgBoxManager:showTipBox(msg_branch)
            end
        end
    end
    --竞技开启判断
    local bRet_athletics,msg_athletics = self:_ifTaskOpen(5)
    local checkBoxAthletics = GetElement(self.m_root,"checkBoxAthletics_WndTask",WZUIContainer)
    if checkBoxAthletics == nil then
        return
    end
    if bRet_athletics then
        checkBoxAthletics:setTouchEnable(true)
    else
        local size = checkBoxAthletics:getAbsContentSize()
        local pt1 = checkBoxAthletics:convertToNodeSpace(GlobalMethod:ccp(pt.x,pt.y))
        if pt1.x > 0 and pt1.x < (size.width) then
            if pt1.y > 0 and pt1.y < (size.height) then
                SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
                MsgBoxManager:showTipBox(msg_athletics)
            end
        end
    end
end

--@brief    弹窗动画完成后的回调
function WndTask:actionCallback(element, data)
    self:scheduleLoadUI()
end

--@brief
function WndTask:unVisibleCallBack()
    -- body
    if self.m_root == nil then return end
    GetElement(self.m_root, "conTop_WndTask", WZUIContainer):setVisible(false)
    self:actionCallback_close()
end

--@brief    弹窗动画完成后的回调
function WndTask:actionCallback_close(element,data)
    if self.m_root == nil then return end
    self.m_root.m_sName = "WndTask"
    WindowManager:removeWindow(self.m_root , WndTask , true)
end
--@brief    加载界面元素定时器
function WndTask:scheduleLoadUI()
    if PrefetchCache:hasTaskList() then
        self:_loadPrefetchCacheData()
    else
        --发送获取任务列表的协议
        --ProtocolProcessorWndTask:send_TASK_GetTaskList()
        self.m_tTaskList = {}
        self.m_tTaskList.tMainTask = {}
        self.m_tTaskList.tBranchTask = {}
        self:_initTaskPanel()
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTask:onExit(element)
    CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
end

--@brief	点击关闭按钮的响应方法
--@param	element:关闭按钮绑定的UI节点引用
--@note		点击关闭按钮的响应方法
function WndTask:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	--WindowManager:removeWindow(self.m_root, self, true)
    self:onCloseAnim()
end

--关闭界面动作
function WndTask:onCloseAnim()
    self.m_root.m_sName = "WndTask"
    WindowManagerAni:createDisappearAction(self.m_root,"actionCallback_close",self)

end


--@brief	点击主线按钮的响应方法
--@param	element:主线按钮绑定的UI节点引用
--@note		点击主线按钮的响应方法
function WndTask:onMainTaskSelected(element)
    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 18 and TeachGroup1.STEP == 3
    if 0 == self.m_nCurIndex or isTeach then
        return
    end
    self:_setCheckBoxSel(true, false, false, false)
    self.m_nCurIndex = 0
    WZLog("WndTask:onMainTaskSelected")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    ChangeChatChannel(Chat_Channel_Task_Main)

    GetElement(self.m_root, "flconTaskList_WndTask", WZUITableContainer):setVisible(true)
    GetElement(self.m_root, "flconDailyList_WndTask", WZUIFreeListContainer):setVisible(false)

    self:_updateMainTask()
end

--@brief	点击每日按钮的响应方法
--@param	element:每日按钮绑定的UI节点引用
--@note		点击每日按钮的响应方法
function WndTask:onDailyTaskSelected(element)
    WZLog("WndTask:onDailyTaskSelected")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    ChangeChatChannel(Chat_Channel_Task_Daily)
    Teach:removeTeachElement("WndTask:onDailyTaskSelected")

    self:_setCheckBoxSel(false, false, true, false)

    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 18 and TeachGroup1.STEP == 3
    WZLog("************ WndTask:onDailyTaskSelected ************", self.m_nCurIndex, isTeach)
    if 1 == self.m_nCurIndex or isTeach then
        return
    end

    local conTaskContent_WndTask = GetElement(self.m_root,"conTaskContent_WndTask",WZUIContainer)
    removeShowPanelNullTip(conTaskContent_WndTask)

    self.m_nCurIndex = 1
    GetElement(self.m_root, "flconTaskList_WndTask", WZUITableContainer):setVisible(false)
    GetElement(self.m_root, "flconDailyList_WndTask", WZUIFreeListContainer):setVisible(true)

    if self.bDailyTaskFirstLoad then
        self:DailyTaskTableCellUpdate()
        self.bDailyTaskFirstLoad = false
    end
end


--@brief    点击支线任务按钮的响应方法
function WndTask:onBranchTaskSelected( element )
    WZLog("WndTask:onBranchTaskSelected")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    ChangeChatChannel(Chat_Channel_Task_Sub)

    self:_setCheckBoxSel(false, true, false, false)

    TeachGroup1:endTeachStep({18,3})
    if 2 == self.m_nCurIndex then
        return
    end
    
    self.m_nCurIndex = 2
    GetElement(self.m_root, "flconTaskList_WndTask", WZUITableContainer):setVisible(true)
    GetElement(self.m_root, "flconDailyList_WndTask", WZUIFreeListContainer):setVisible(false)

    self:_updateBranchTask()
end

--@brief    点击竞技标签回调
function WndTask:onAthleticsSelected(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:_setCheckBoxSel(false, false, false, true)

    if 3 == self.m_nCurIndex then
        return
    end
    
    self.m_nCurIndex = 3
    GetElement(self.m_root, "flconTaskList_WndTask", WZUITableContainer):setVisible(true)
    GetElement(self.m_root, "flconDailyList_WndTask", WZUIFreeListContainer):setVisible(false)

    self:_updateAthleticsTask()
end

--@brief    点击宝箱回调
function WndTask:onClickBox(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    local nTag = element:getTag()
    local tData = self.m_tDailyActivityData[nTag]

    if tData.status == 1 then 
        ProtocolProcessorWndTask:send_TASK_ReceiveDailyReward(nTag - 1)
    else
        local rewardData = {}
        rewardData.coinId = tData.coinId
        rewardData.nType = 5
        rewardData.strartNum = CacheCenter:getPlayerItemCountById(tData.coinId)
        rewardData.endNum = tData.target
        rewardData.icon = {}
        rewardData.num = {}
        for i = 1, #tData.reward do
            local icon = GDatatab_item["id_" .. tData.reward[i][1]].icon
            table.insert(rewardData.icon, icon)
            table.insert(rewardData.num, tData.reward[i][2])
        end
        WndTips:show(element, self.m_root, 3, rewardData, GlobalMethod:ccp(160,130))
        WndTips.m_root:setShowAll(true)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置界面上的静态文本
function WndTask:_setStaticText()
    --local TASK_BRANCH = "支线任务"
	for i=1,1 do
		GetElement(self.m_root, "txtMainTask_"..i.."_WndTask", WZUILabelTTF):setText(LocalStrings.TASK_JUQING)
		GetElement(self.m_root, "txtDailyTask_"..i.."_WndTask", WZUILabelTTF):setText(LocalStrings.TASK_MEIRI)
        GetElement(self.m_root, "txtBranchTask_"..i.."_WndTask",WZUILabelTTF):setText(LocalStrings.TASK_BRANCH)
        GetElement(self.m_root, "txtAthleticsTask_"..i.."_WndTask",WZUILabelTTF):setText(LocalStrings.ATGHLETICS)
	end

    GetElement(self.m_root,"txtWndTitleName_WndTask",WZUILabelTTF):setText(LocalStrings.TASK_UINAME)
end

--@brief    更新支线任务
function WndTask:_updateBranchTask( )
    if #self.m_tTaskList.tBranchTask <= 0  then 
        local confl_commondListView = GetElement(self.m_root,"flconTaskList_WndTask",WZUITableContainer)
        if confl_commondListView == nil then
            return
        end
        confl_commondListView:cleanTable()
        
        self:_showEmptyTip()
        return 
    end
    local conTaskContent_WndTask = GetElement(self.m_root,"conTaskContent_WndTask",WZUIContainer)
    removeShowPanelNullTip(conTaskContent_WndTask)
    self:_sortBranchTaskList()
    self:_setTaskList(self.m_tTaskList.tBranchTask)
end

--@brief    更新主线任务
function WndTask:_updateMainTask()
    WZLog("WndTask:_updateMainTask", #self.m_tTaskList.tMainTask)
    if #self.m_tTaskList.tMainTask <= 0  then 
        WndTask:teach()
        local confl_commondListView = GetElement(self.m_root,"flconTaskList_WndTask",WZUITableContainer)
        if confl_commondListView == nil then
            return
        end
        confl_commondListView:cleanTable()

        self:_showEmptyTip()
        return 
    end 
    local conTaskContent_WndTask = GetElement(self.m_root,"conTaskContent_WndTask",WZUIContainer)
    removeShowPanelNullTip(conTaskContent_WndTask)
    self:_sortMainTaskList()
    self:_setTaskList(self.m_tTaskList.tMainTask)
end

--@brief    更新支线任务
function WndTask:_updateAthleticsTask()
    local tAthleticsList = {}
    local tToSubmit = self.m_tTaskList.tAthleticsTask.tToSubmit
    for i = 1, #tToSubmit do
        table.insert(tAthleticsList, tToSubmit[i])
    end
    local tDoing = self.m_tTaskList.tAthleticsTask.tDoing
    for i = 1, #tDoing do
        table.insert(tAthleticsList, tDoing[i])
    end
    local tCompleted = self.m_tTaskList.tAthleticsTask.tCompleted
    for i = 1, #tCompleted do
        table.insert(tAthleticsList, tCompleted[i])
    end

    if #tAthleticsList <= 0  then 
        local confl_commondListView = GetElement(self.m_root,"flconTaskList_WndTask",WZUITableContainer)
        if confl_commondListView == nil then
            return
        end
        confl_commondListView:cleanTable()
        
        self:_showEmptyTip()
        return 
    end
    local conTaskContent_WndTask = GetElement(self.m_root,"conTaskContent_WndTask",WZUIContainer)
    removeShowPanelNullTip(conTaskContent_WndTask)

    self:_setTaskList(tAthleticsList)
end

--@brief    定时器更新每日任务
function WndTask:teach()

    WZLog("WndTask:teach zero00", WndTask.m_tListItem)
    if WndTask.m_tListItem and self.m_tTaskList.tMainTask and #self.m_tTaskList.tMainTask > 0 then
    --    WZLog("WndTask:teach zero",self.m_tTaskList.tMainTask[1].nId, self.m_tTaskList.tMainTask[1].nTaskStatus, Serialize(self.m_tTaskList.tMainTask), tostring(WndTask.m_tListItem))
        local isEndTeach3, teachStep3 = TeachGroup1:isTeachFinish(3)
        local isEndTeach5, teachStep5 = TeachGroup1:isTeachFinish(5)
        local isEndTeach7, teachStep7 = TeachGroup1:isTeachFinish(7)
        local isEndTeach8, teachStep8 = TeachGroup1:isTeachFinish(8)
        local isEndTeach9, teachStep9 = TeachGroup1:isTeachFinish(9)
        local isEndTeach20, teachStep20 = TeachGroup1:isTeachFinish(20)
        local isEndTeach31, teachStep31 = TeachGroup1:isTeachFinish(31)
        local isEndTeach32, teachStep32 = TeachGroup1:isTeachFinish(32)
        local isEndTeach33, teachStep33 = TeachGroup1:isTeachFinish(33)
        local isEndTeach34, teachStep34 = TeachGroup1:isTeachFinish(34)
        local isEndTeach35, teachStep35 = TeachGroup1:isTeachFinish(35)
        local isEndTeach36, teachStep36 = TeachGroup1:isTeachFinish(36)
        local isEndTeach39, teachStep39 = TeachGroup1:isTeachFinish(39)
        local isEndTeach40, teachStep40 = TeachGroup1:isTeachFinish(40)
        local isEndTeach41, teachStep41 = TeachGroup1:isTeachFinish(41)

    --    WZLog("WndTask:teach one",self.m_tTaskList.tMainTask[1].nId, self.m_tTaskList.tMainTask[1].nTaskStatus, tostring(isEndTeach3), teachStep3, tostring(isEndTeach5), teachStep5, tostring(isEndTeach7), teachStep7, tostring(isEndTeach8), teachStep8, tostring(isEndTeach9), teachStep9, tostring(isEndTeach32), teachStep32)

        local btn = GetElement(WndTask.m_tListItem.m_root, "btnUISwitch_CellTaskListItem", WZUIButton)

        WZLog("WndTask:teach four", btn:getTouchEnable())

        local isTeach = true
        local tryTeach = nil
        if self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_1 and self.m_tTaskList.tMainTask[1].nTaskStatus == 0 then
            TeachGroup1:setTeachFinish(1, 2, true)
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({3,5,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(3, -1)
            end
        end

        if self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_1 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({3,4,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(3, -1)
            end
        end
        if self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_2 and self.m_tTaskList.tMainTask[1].nTaskStatus == 0 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({3,5,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(3, -1)
            end
        end
        if self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_2 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({5,11,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(5, -1)
            end
        end
        if self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_3 and self.m_tTaskList.tMainTask[1].nTaskStatus == 0 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({5,12,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(5, -1)
            end
        end
        if self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_3 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({7,5,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(7, -1)
            end
        end
        if self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_4 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({8,8,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(8, -1)
            end
        end
        if isEndTeach8 ~= true and teachStep8 > 0 and self.m_tTaskList.tMainTask[1].nTaskStatus == 0 then

            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({8,9,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(8, -1)
            end
        end

        if self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_6 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({20,8,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(20, -1)
            end
        end

        if isEndTeach20 ~= true and teachStep20 > 0 and self.m_tTaskList.tMainTask[1].nTaskStatus == 0 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({20,9,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(20, -1)
            end
        end

        if isEndTeach9 ~= true and teachStep9 > 0 and self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_8 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({9,8,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(9, -1)
            end
        end
        if isEndTeach9 ~= true and teachStep9 > 0 and self.m_tTaskList.tMainTask[1].nTaskStatus == 0 and (TeachGroup1.GROUP ~= 9 or (TeachGroup1.GROUP == 9 and TeachGroup1.STEP ~= 9)) then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({9,9,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(9, -1)
            end
        end

        if isEndTeach31 ~= true and teachStep31 > 0 and self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_5 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({31,3,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(31, -1)
            end
        elseif isEndTeach31 ~= true and teachStep31 > 0 then
            isTeach = false
        end

        if isEndTeach32 ~= true and teachStep32 > 0 and self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_9 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({32,4,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(32, -1)
            end
        elseif isEndTeach32 ~= true and teachStep32 > 0 and self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_10 and self.m_tTaskList.tMainTask[1].nTaskStatus == 0 and GlobalGame.m_bIsShowEquipDressUp == nil then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({32,6,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(32, -1)
            end
        elseif isEndTeach32 ~= true and teachStep32 > 0 then
            isTeach = false
        end

        if isEndTeach33 ~= true and teachStep33 > 0 and self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_10 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({33,3,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(33, -1)
            end
        elseif isEndTeach33 ~= true and teachStep33 > 0 then
            isTeach = false
        end

        if isEndTeach34 ~= true and teachStep34 > 0 and self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_11 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({34,3,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(34, -1)
            end
        elseif isEndTeach34 ~= true and teachStep34 > 0 then
            isTeach = false
        end

        if isEndTeach35 ~= true and teachStep35 > 0 and self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_12 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({35,3,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(35, -1)
            end
        elseif isEndTeach35 ~= true and teachStep35 > 0 then
            isTeach = false
        end

        if isEndTeach36 ~= true and teachStep36 > 0 and self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_13 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({36,3,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(36, -1)
            end
        elseif isEndTeach36 ~= true and teachStep36 > 0 then
            isTeach = false
        end

        if isEndTeach39 ~= true and teachStep39 > 0 and self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_16 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({39,3,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(39, -1)
            end
        elseif isEndTeach39 ~= true and teachStep39 > 0 then
            isTeach = false
        end

        if isEndTeach40 ~= true and teachStep40 > 0 and self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_17 and self.m_tTaskList.tMainTask[1].nTaskStatus == 1 then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({40,3,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(40, -1)
            end
        elseif isEndTeach40 ~= true and teachStep40 > 0 then
            isTeach = false
        end

        if isEndTeach41 ~= true and teachStep41 > 0 and self.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_18 and WndEquipmentLottery.m_root == nil then
            
            if btn:getTouchEnable() == true then
                isTeach = TeachGroup1:startGroup({41,9,WndTask.m_tListItem.m_root})
                tryTeach = true
            else
                TeachGroup1:setTeachFinish(41, -1)
            end
        elseif isEndTeach41 ~= true and teachStep41 > 0 then
            isTeach = false
        end

        WZLog("WndTask:teach two", tostring(isTeach), tostring(tryTeach))
        if isTeach == false or tryTeach == nil then
            if isEndTeach31 ~= true and teachStep31 > 0 then
                TeachGroup1:setTeachFinish(31, -1)
                WZLog("WndTask:teach three-0")
            elseif isEndTeach33 ~= true and teachStep33 > 0 then
                TeachGroup1:setTeachFinish(33, -1)
                WZLog("WndTask:teach three-1")
            elseif isEndTeach34 ~= true and teachStep34 > 0 then
                TeachGroup1:setTeachFinish(34, -1)
                WZLog("WndTask:teach three-2")
            elseif isEndTeach35 ~= true and teachStep35 > 0 then
                TeachGroup1:setTeachFinish(35, -1)
                WZLog("WndTask:teach three-3")
            elseif isEndTeach36 ~= true and teachStep36 > 0 then
                TeachGroup1:setTeachFinish(36, -1)
                WZLog("WndTask:teach three-4")
            elseif isEndTeach39 ~= true and teachStep39 > 0 then
                TeachGroup1:setTeachFinish(39, -1)
                WZLog("WndTask:teach three-5")
            elseif isEndTeach40 ~= true and teachStep40 > 0 then
                TeachGroup1:setTeachFinish(40, -1)
                WZLog("WndTask:teach three-6")
            elseif isEndTeach41 ~= true and teachStep41 > 0 and WndEquipmentLottery.m_root == nil then
                TeachGroup1:setTeachFinish(41, -1)
                WZLog("WndTask:teach three-7")
            end
            WindowManager:removeTeachShelterLayer()
            TeachGroup1:removeTeach()
        end
    else
        WindowManager:removeTeachShelterLayer()
        TeachGroup1:removeTeach()
    end


    local isEndTask = TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_3)
    local isEndTeach, teachStep = TeachGroup1:isTeachFinish(8)
    if isEndTask == true and isEndTeach ~= true and teachStep == 0 then
        TeachGroup1:startGroup({8,1,WndTask.m_root})
        --TeachGroup1:startGroupLevelUp(false, false, true, {8,1,WndTask.m_root})
    end
end

--@brief    日常任务列表更新
function WndTask:DailyTaskTableCellUpdate()
    WZLog("WndTask:DailyTaskTableCellUpdate")
    local tbconDailyList = GetElement(self.m_root, "flconDailyList_WndTask", WZUIFreeListContainer)
    if tbconDailyList:size() > 0 then
        tbconDailyList:removeAll()
    end
    self.m_tDailyLoadIndex = 1
    if #self.m_tTaskList.tDailyTask.tToSubmit > 0 then 
        self:_setDailyTaskItem(self.m_tTaskList.tDailyTask.tToSubmit,tbconDailyList)
    end
    if #self.m_tTaskList.tDailyTask.tDoing > 0 then 
        self.m_tDailyLoadIndex = 2
        self:_setDailyTaskItem(self.m_tTaskList.tDailyTask.tDoing,tbconDailyList)
    end
    if #self.m_tTaskList.tDailyTask.tCompleted > 0 then 
        self.m_tDailyLoadIndex = 3
        self:_setDailyTaskItem(self.m_tTaskList.tDailyTask.tCompleted,tbconDailyList)
    end 
end

function WndTask:_setDailyTaskItem(tTaskList,tbconDailyList )
    WZLog("*********** WndTask:_setDailyTaskItem *************")
    if tTaskList == nil or tTaskList == {} then
        WZLog("*********** WndTask:_setDailyTaskItem 11111*************")
    end
    if tTaskList == nil then 
        return 
    end 
    local count = #tTaskList
    self.m_tDailyCacheTaskList = tTaskList
    self.m_nCurrentCellIndex = 1
    
    if count > 0 then
        self:_loadDailyTaskItem(tbconDailyList)
    end 
end


--@brief    分帧加载日常任务
function WndTask:_loadDailyTaskItem( element ,delate )
    element = WZUIFreeListContainer:luaTo(element)
    if self.m_nCurrentCellIndex > #self.m_tDailyCacheTaskList then 
        WZLog("******** WndTask:_loadDailyTaskItem *******", self.m_tDailyLoadIndex)
        return 
    end 
    WZLog("日常任务状态值:"..self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus)
    if not (self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus == TASKSTATUS_STALE) then
        for i = 1, #self.m_tDailyCacheTaskList do
            local dailyElement, tLuaObj = CellTaskListItem:createElement()
            element:pushBack(WZUIContainer:luaTo(dailyElement))
            dailyElement:setContentSize(GlobalMethod:CCSize(713,117))
            dailyElement:setRelativeSize(GlobalMethod:CCSize(1,117/440))
            local tTaskDesc = GDatatab_task["id_"..self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nId].desc
            local nMainUIId = GDatatab_task["id_"..self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nId].script[1][1]
            if tTaskDesc == nil then
                return
            end
            --Add By Tianxiang_Xu 
            --日常任务中月卡任务的剩余天数
            local nTask_sub_type = GDatatab_task["id_"..self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nId].sub_type 
            if nTask_sub_type == 30014 then
                WZLog("日常任务中的月卡任务状态值"..self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus)
                local nStatus = self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus
                tLuaObj:setMonthCardLastTimes(self.m_nDailyMonthCardTime, nStatus)
            elseif nTask_sub_type ==  30030 then
                WZLog("日常任务中的周卡任务状态值"..self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus)
                local nStatus = self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus
                tLuaObj:setMonthCardLastTimes(self.m_nWeekCardTime, nStatus)
            end
            --End Add 
            WZLog("TaskDesc==0>"..tTaskDesc.."|"..self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus)
            m_tTaskDesc = tTaskDesc
            local _sTaskGoals = string.format("%d/%d",self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTargetStatus,self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTargetValue)

            local tTaskData = GDatatab_task["id_"..self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nId]
            if tTaskData == nil then 
                return 
            end
            m_tTaskTitle = tTaskData.name
            local tReward = {}
            local _itemQuality = {}
            tLuaObj:setBtnJumpID(-1, -1)
            tLuaObj:setTaskID(self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nId)
            tLuaObj:setTaskType(self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskType)
            if self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus == TASKSTATUS_DOING then
                tLuaObj:setCartorNeedId(self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nId)
                tLuaObj:setBtnJumpID(tTaskData.script[1][1], tTaskData.script[1][2])
                if 0==tTaskData.script[1][1] and 0==tTaskData.script[1][2] then
                    tLuaObj:setBtnText(tTaskData.buttonName)
                else
                    tLuaObj:setBtnText(tTaskData.buttonName)
                end
            elseif self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus == TASKSTATUS_TOSUBMIT then
                tLuaObj:setTaskID(self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nId)
                tLuaObj:setBtnText(LocalStrings.COMPLETE_TASK)
            end
            local m_tRewardData={}       --物品奖励表
            local RewardCount = #tTaskData.reward
            for i=1,RewardCount do
                local cell_item = {}
                local ItemId = tTaskData.reward[i][1]
                cell_item.ItemNum = tTaskData.reward[i][2]
                local m_tItemData = GDatatab_item["id_"..ItemId]
                if m_tItemData == nil then 
                    break 
                end 
                cell_item.icon = m_tItemData.icon
                table.insert(m_tRewardData,cell_item)
            end
            m_imgIconType = tTaskData.icon
        --    if nMainUIId == 75 then
                tLuaObj:setFuncCallBack(self,self.unVisibleCallBack)
            -- else
            --     tLuaObj:setFuncCallBack(self,self.onCloseAnim)
            -- end
            tLuaObj:initMessageInfo(m_imgIconType,m_tRewardData,m_tTaskTitle,m_tTaskDesc,self.m_tDailyCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus,self.m_nCurrentCellIndex,_sTaskGoals, tTaskData.script)
            element:getMoveElement():setPositionY(element:getMinPosition().y)
            self.m_nCurrentCellIndex = self.m_nCurrentCellIndex + 1
        end
    end
end


--@brief    加载每日任务
function WndTask:scheduleLoadDailyTask()
    self:DailyTaskTableCellUpdate()
end

--@brief    加载缓存信息
function WndTask:_loadPrefetchCacheData()
    self.m_tTaskList = PrefetchCache:getTaskList()
    self:_initTaskPanel()
end

--@brief    获取主线任务总目标值
--@brief    sTarget:主线任务完成条件字段
function WndTask:_getMainTaskGoals(sTarget)
    local nTarget = -1
    local nIndex = string.find(sTarget, "=")
    nTarget = tonumber(string.sub(sTarget, nIndex+1))
    return nTarget
end

--@brief    缓存提示更新内容
-- function WndTask:refreshTopWindow(  )
--     WZLog("******* updateUIFunc 0000000 ********")
--     self:updateUIFunc()
-- end


--@brief 分割字符串   在别处使用了该函数 勿删
function WndTask:Split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

-------------------------------------私有方法模块End----------------------------------------
function WndTask:_getCellElement(tag)
    local tbcon = GetElement(self.m_root,"flconTaskList_WndTask",WZUITableContainer)
    local celElement = tbcon:getCellElement(tag)
    if celElement == nil then return nil end
    local childElement = celElement:getChildElement("__CellTaskListItem")
    if not childElement then
        return nil 
    end 
    return celElement, childElement:getLuaObjectIndex()
end

--@brief 设置主支线任务列表
function WndTask:_setTaskList( m_tTaskList )
    WZLog("************ WndTask:_setTaskList ************")
    local confl_commondListView = GetElement(self.m_root,"flconTaskList_WndTask",WZUITableContainer)
    if confl_commondListView == nil then
        return
    end
    confl_commondListView:cleanTable()

    if m_tTaskList == nil then 
        m_tTaskList = {}
    end
    local list_count = #m_tTaskList
    WZLog("WndTask:_setTaskList=="..list_count)

    self.m_tCacheTaskList = m_tTaskList 
    self.m_nCurrentCellIndex = 1 
    if  list_count == 0 then  --没有任务
        WndTask:teach()
    elseif list_count > 0 then
        self:_LoadTaskFrame(confl_commondListView)
        self:teachOnRefresh()
    end
end


--@brief  分帧加载任务
function WndTask:_LoadTaskFrame( element ,delta )
    if not (self.m_tCacheTaskList[self.m_nCurrentCellIndex].nTaskStatus == TASKSTATUS_STALE) then
        element = WZUITableContainer:luaTo(element)
        for i = 1, #self.m_tCacheTaskList do
            local cellElement,luaObj = CellTaskListItem:createElement()
            local tMainTaskData = GDatatab_task["id_"..self.m_tCacheTaskList[self.m_nCurrentCellIndex].nId]
            local nMainUIId = GDatatab_task["id_"..self.m_tCacheTaskList[self.m_nCurrentCellIndex].nId].script[1][1]
            self:_setTaskContext(self.m_tCacheTaskList,self.m_nCurrentCellIndex,luaObj,tMainTaskData)
            cellElement = WZUIContainer:luaTo(cellElement)
            if cellElement == nil then 
                WZLog("WndTask:_LoadTaskFrame===>cellElement is nil ")
            end 
            if element == nil then 
                WZLog("WndTask:_LoadTaskFrame===>element is nil ")
            end 
            
            cellElement:setTag(self.m_nCurrentCellIndex - 1)
            element:setCellElement(cellElement)
        --    if nMainUIId == 75 then
                luaObj:setFuncCallBack(self,self.unVisibleCallBack)
            -- else
            --     luaObj:setFuncCallBack(self,self.onCloseAnim)
            -- end
            if self.m_nCurrentCellIndex == 1 then
                self.m_tListItem = luaObj
                luaObj.m_bIsTeach = true
                WZLog("WndTask:_LoadTaskFrame one")
            end
            self.m_nCurrentCellIndex = self.m_nCurrentCellIndex + 1
        end
    end

    if self.m_nCurrentCellIndex >= #self.m_tCacheTaskList then
        WZLog("WndTask:_LoadTaskFrame two")
        if GlobalGame.g_tWndBottomBarObj then
            CacheCenter:updateRedPoint("right",GlobalGame.g_tWndBottomBarObj.m_root,nil,15)
        end
        return
    end

end

--@brief 设置高亮状态
function WndTask:_setHightStates(m_tlistobj,m_tListData,nTag )
    for i=1,#m_tListData do
        local pos = i-1
        local cellItem = m_tlistobj:getAt(pos)
        if cellItem ~= nil then
            cellItem = WZUIContainer:luaTo(cellItem)
        else
            return
        end

        if i==nTag then
            local cellItem_obj = cellItem:getLuaObjectIndex()
            cellItem_obj:isItemHighLighted(true)
        else
            local cellItem_obj = cellItem:getLuaObjectIndex()
            cellItem_obj:isItemHighLighted(false)
        end
    end
end

--@brief 初始化任务详细内容面板
function WndTask:_initTaskPanel()
    if self.m_nSpecifyIndex ~= nil then 
        if self.m_nSpecifyIndex == 0 then
            self.m_bIsTeach = nil

            self:_setCheckBoxSel(true, false, false, false)
            self.m_nCurIndex = 0
            WZLog("WndTask:onMainTaskSelected")
            ChangeChatChannel(Chat_Channel_Task_Main)

            self:_updateMainTask()
        elseif self.m_nSpecifyIndex == 1 then
            ChangeChatChannel(Chat_Channel_Task_Sub)

            self:_setCheckBoxSel(false, true, false, false)

            self.m_nCurIndex = 2
            GetElement(self.m_root, "flconTaskList_WndTask", WZUITableContainer):setVisible(true)
            GetElement(self.m_root, "flconDailyList_WndTask", WZUIFreeListContainer):setVisible(false)

            self:_updateBranchTask()
        elseif self.m_nSpecifyIndex == 2 then
            ChangeChatChannel(Chat_Channel_Task_Daily)
            self:_setCheckBoxSel(false, false, true, false)

            local conTaskContent_WndTask = GetElement(self.m_root,"conTaskContent_WndTask",WZUIContainer)
            removeShowPanelNullTip(conTaskContent_WndTask)

            self.m_nCurIndex = 1
            GetElement(self.m_root, "flconTaskList_WndTask", WZUITableContainer):setVisible(false)
            GetElement(self.m_root, "flconDailyList_WndTask", WZUIFreeListContainer):setVisible(true)

            if self.bDailyTaskFirstLoad then
                self:DailyTaskTableCellUpdate()
                self.bDailyTaskFirstLoad = false
            end
        elseif self.m_nSpecifyIndex == 3 then 
            self:_setCheckBoxSel(false, false, false, true)
            
            self.m_nCurIndex = 3
            GetElement(self.m_root, "flconTaskList_WndTask", WZUITableContainer):setVisible(true)
            GetElement(self.m_root, "flconDailyList_WndTask", WZUIFreeListContainer):setVisible(false)

            self:_updateAthleticsTask()
        end
        return 
    end

    if self.m_bIsTeach or GlobalGame.g_nMainTaskCount > 0 then
        self.m_bIsTeach = nil

        self:_setCheckBoxSel(true, false, false, false)
        self.m_nCurIndex = 0
        WZLog("WndTask:onMainTaskSelected")
        ChangeChatChannel(Chat_Channel_Task_Main)

        self:_updateMainTask()
    elseif GlobalGame.g_nBranchTaskCount > 0 then
        WZLog("WndTask:onBranchTaskSelected")
        ChangeChatChannel(Chat_Channel_Task_Sub)

        self:_setCheckBoxSel(false, true, false, false)

        self.m_nCurIndex = 2
        GetElement(self.m_root, "flconTaskList_WndTask", WZUITableContainer):setVisible(true)
        GetElement(self.m_root, "flconDailyList_WndTask", WZUIFreeListContainer):setVisible(false)

        self:_updateBranchTask()
    elseif GlobalGame.g_nDailyTaskCount > 0 or PrefetchCache:whetherHaveBoxActive()then 
        WZLog("WndTask:onDailyTaskSelected")
        ChangeChatChannel(Chat_Channel_Task_Daily)
        
        self:_setCheckBoxSel(false, false, true, false)

        local conTaskContent_WndTask = GetElement(self.m_root,"conTaskContent_WndTask",WZUIContainer)
        removeShowPanelNullTip(conTaskContent_WndTask)

        self.m_nCurIndex = 1

        GetElement(self.m_root, "flconTaskList_WndTask", WZUITableContainer):setVisible(false)
        GetElement(self.m_root, "flconDailyList_WndTask", WZUIFreeListContainer):setVisible(true)

        if self.bDailyTaskFirstLoad then
            self:DailyTaskTableCellUpdate()
            self.bDailyTaskFirstLoad = false
        end
    elseif GlobalGame.g_nAthleticsTaskCount > 0 then
        self:_setCheckBoxSel(false, false, false, true)

        self.m_nCurIndex = 3
        GetElement(self.m_root, "flconTaskList_WndTask", WZUITableContainer):setVisible(true)
        GetElement(self.m_root, "flconDailyList_WndTask", WZUIFreeListContainer):setVisible(false)

        self:_updateAthleticsTask()
    else
        self:_setCheckBoxSel(true, false, false, false)
        self.m_nCurIndex = 0
        WZLog("WndTask:onMainTaskSelected")
        ChangeChatChannel(Chat_Channel_Task_Main)

        self:_updateMainTask()
    end   
end

--@brief 设置任务详细内容面板
function WndTask:_setTaskContext(m_listData, nIndex ,tLuaObj,tMainTaskData)
       
        local list_count = #m_listData
        --list_count = 0 --测试数据
        --moveElement:removeAllChildrenWithCleanup(true)
        local m_imgIconType = ""      --Item图标
        local m_tRewardData={}       --物品奖励表
        local m_tTaskTitle = nil     --任务标题
        local m_tTaskDesc = nil      --任务描述
        local m_tTaskState = 0       --任务状态
        
        WZLog("WndTask:_setTaskContext::=============================index="..m_listData[nIndex].nId)
        local tTaskDesc = GDatatab_task["id_"..m_listData[nIndex].nId].desc
        if tTaskDesc == nil then
            return
        end
        WZLog("TaskDesc==>"..tTaskDesc)
        m_tTaskDesc = tTaskDesc
      
        local _sTaskGoals = ""
         _sTaskGoals = string.format("%d/%d",m_listData[nIndex].nTargetStatus,m_listData[nIndex].nTargetValue)
        --m_tTaskDesc = m_tTaskDesc

        local tTaskData = tMainTaskData
        if tTaskData == nil then 
            return 
        end
        m_tTaskTitle = tTaskData.name
           
        local tReward = {}
        local _itemQuality = {}
       
        
        tLuaObj:setBtnJumpID(-1, -1)
        tLuaObj:setTaskID(m_listData[nIndex].nId)
        tLuaObj:setTaskType(m_listData[nIndex].nTaskType)
        if m_listData[nIndex].nTaskStatus == TASKSTATUS_DOING then
            tLuaObj:setCartorNeedId(m_listData[nIndex].nId)
            tLuaObj:setBtnJumpID(tTaskData.script[1][1], tTaskData.script[1][2])
            if 0==tTaskData.script[1][1] and 0==tTaskData.script[1][2] then
                tLuaObj:setBtnText(tTaskData.buttonName)
            else
                tLuaObj:setBtnText(tTaskData.buttonName)
            end
        elseif m_listData[nIndex].nTaskStatus == TASKSTATUS_TOSUBMIT then
            tLuaObj:setTaskID(m_listData[nIndex].nId)
            tLuaObj:setBtnText(LocalStrings.COMPLETE_TASK)
        end
        
    local RewardCount = #tTaskData.reward
    for i=1,RewardCount do
        local cell_item = {}
        local ItemId = tTaskData.reward[i][1]
        cell_item.ItemNum = tTaskData.reward[i][2]
        local m_tItemData = GDatatab_item["id_"..ItemId]
        if m_tItemData == nil then 
            break 
        end 
        cell_item.icon = m_tItemData.icon
        table.insert(m_tRewardData,cell_item)
    end
   
    m_imgIconType = tTaskData.icon
    WZLog("==========================>"..nIndex)
    tLuaObj:initMessageInfo(m_imgIconType,m_tRewardData,m_tTaskTitle,m_tTaskDesc,m_listData[nIndex].nTaskStatus,nIndex,_sTaskGoals, tTaskData.script)
end

--@breif 支线日常开启条件
function WndTask:_ifTaskOpen( nButtonId )
    
    local tBtnsInfo = GDatatab_button_info["id_"..nButtonId]
    if tBtnsInfo == nil then
        return false,""
    end

    if CacheCenter:getPlayerInfo().level >= tBtnsInfo.open_level then   
        return true,""
    end
    
    return false,tBtnsInfo.feedback_info
end

--@breif 对主线任务进行排序
function WndTask:_sortMainTaskList()
    --WZLog(debug.traceback())
    local taskCount = #self.m_tTaskList.tMainTask
    local tTaskFinish = {}
    local tTaskNew = {}
    local tTaskDoing = {}
    for i=1,taskCount do
        local b_isNewItem = CellTaskListItem:checkItemIsClickedById(1,self.m_tTaskList.tMainTask[i].nId)

        if self.m_tTaskList.tMainTask[i].nTaskStatus == TASKSTATUS_TOSUBMIT then
            table.insert(tTaskFinish,self.m_tTaskList.tMainTask[i])
        elseif (not b_isNewItem) and self.m_tTaskList.tMainTask[i].nTaskStatus == TASKSTATUS_DOING then
            table.insert(tTaskNew,self.m_tTaskList.tMainTask[i])
        else 
            table.insert(tTaskDoing,self.m_tTaskList.tMainTask[i])
        end 
    end

    self.m_tTaskList.tMainTask = {}
    table.sort(tTaskFinish, function(a, b) return a.nId < b.nId end)
    for j=1,#tTaskFinish do
        table.insert(self.m_tTaskList.tMainTask,tTaskFinish[j])
    end
    table.sort(tTaskNew, function(a, b) return a.nId < b.nId end)
    for i=1,#tTaskNew do
        WZLog("WndTask:_sortMainTaskList()===>new")
        table.insert(self.m_tTaskList.tMainTask,tTaskNew[i])
    end
    table.sort(tTaskDoing, function(a, b) return a.nId < b.nId end)
    for k=1,#tTaskDoing do
        table.insert(self.m_tTaskList.tMainTask,tTaskDoing[k])   
    end
end
--@breif 对支线任务进行排序
function WndTask:_sortBranchTaskList(  )
    local taskCount = #self.m_tTaskList.tBranchTask
    local tTaskFinish = {}
    local tTaskNew = {}
    local tTaskDoing = {}
    for i=1,taskCount do
        local b_isNewItem =  CellTaskListItem:checkItemIsClickedById(2,self.m_tTaskList.tBranchTask[i].nId)
        if self.m_tTaskList.tBranchTask[i].nTaskStatus == TASKSTATUS_TOSUBMIT then
            table.insert(tTaskFinish,self.m_tTaskList.tBranchTask[i])
        elseif (not b_isNewItem) and self.m_tTaskList.tBranchTask[i].nTaskStatus == TASKSTATUS_DOING then
            table.insert(tTaskNew,self.m_tTaskList.tBranchTask[i])
        else 
            table.insert(tTaskDoing,self.m_tTaskList.tBranchTask[i])
        end 
    end

    self.m_tTaskList.tBranchTask = {}
    table.sort(tTaskFinish, function(a, b) return a.nId < b.nId end)
    for j=1,#tTaskFinish do
        table.insert(self.m_tTaskList.tBranchTask,tTaskFinish[j])
    end
    table.sort(tTaskNew, function(a, b) return a.nId < b.nId end)
    for i=1,#tTaskNew do
        table.insert(self.m_tTaskList.tBranchTask,tTaskNew[i])
    end
    table.sort(tTaskDoing, function(a, b) return a.nId < b.nId end)
    for k=1,#tTaskDoing do
        table.insert(self.m_tTaskList.tBranchTask,tTaskDoing[k])   
    end
end

--@breif 设置任务当前完成数量
function WndTask:_setTaskCount()
    local con_MainTaskIconNum = GetElement(self.m_root,"con_MainTaskIconNum",WZUIContainer)
    if con_MainTaskIconNum == nil then
        return
    end

    if GlobalGame.g_nMainTaskCount > 0 then
        con_MainTaskIconNum:setVisible(true)
    else
        con_MainTaskIconNum:setVisible(false)
    end

    local con_BranchTaskIconNum = GetElement(self.m_root,"con_BranchTaskIconNum",WZUIContainer)
    if con_BranchTaskIconNum == nil then
        return
    end
    
    if GlobalGame.g_nBranchTaskCount >0 then
        con_BranchTaskIconNum:setVisible(true)
    else
        con_BranchTaskIconNum:setVisible(false)
    end

    local con_DailyTaskIconNum = GetElement(self.m_root,"con_DailyTaskIconNum",WZUIContainer)
    if con_DailyTaskIconNum == nil then
        return
    end    
    
    if GlobalGame.g_nDailyTaskCount > 0 or PrefetchCache:whetherHaveBoxActive() then
        con_DailyTaskIconNum:setVisible(true)
    else
        con_DailyTaskIconNum:setVisible(false)
    end

    --竞技红点
    local con_AthleticsTaskIconNum = GetElement(self.m_root,"con_AthleticsTaskIconNum",WZUIContainer)
    if con_AthleticsTaskIconNum == nil then
        return
    end    
    
    if GlobalGame.g_nAthleticsTaskCount >0 then
        con_AthleticsTaskIconNum:setVisible(true)
    else
        con_AthleticsTaskIconNum:setVisible(false)
    end
end

--@brief    设置选中的选项卡高亮图片可见，其余不可见
--@param    bMainVisible 主线任务高亮是否显示
--@param    bBranchVisible 支线任务高亮是否显示
--@param    bDailyVisible 日常任务是否高亮显示
--@param    bAthleticsVisible 竞技任务是否高亮显示
function WndTask:_setCheckBoxSel(bMainVisible, bBranchVisible, bDailyVisible, bAthleticsVisible)
    -- body
    GetElement(self.m_root, "conCheckBoxMainSel_WndTask", WZUIContainer):setVisible(bMainVisible)
    GetElement(self.m_root, "conCheckBoxBranchSel_WndTask", WZUIContainer):setVisible(bBranchVisible)
    GetElement(self.m_root, "conCheckBoxDailySel_WndTask", WZUIContainer):setVisible(bDailyVisible)
    GetElement(self.m_root, "conCheckBoxAthleticsSel_WndTask", WZUIContainer):setVisible(bAthleticsVisible)

    GetElement(self.m_root, "conForActivity_WndTask", WZUIContainer):setVisible(bDailyVisible)
    if bDailyVisible then 
        self:setDailyBoxData()
    end
end


--@brief    显示日常任务活跃度
function WndTask:_showDailyActivity()
    -- body
    local nCurNum = CacheCenter:getPlayerItemCountById(80)
    local nMaxNum = self.m_tDailyActivityData[5].target
    --进度条
    local prgActivity = GetElement(self.m_root, "prgActivity_WndTask", WZUIProgress)
    if prgActivity then 
        if nCurNum <= self.m_tDailyActivityData[1].target then 
            prgActivity:setPercentage(math.floor(nCurNum * 20/self.m_tDailyActivityData[1].target))
        elseif nCurNum <= self.m_tDailyActivityData[2].target then 
            local nTempNum = self.m_tDailyActivityData[2].target - self.m_tDailyActivityData[1].target
            prgActivity:setPercentage(20 + math.floor((nCurNum - self.m_tDailyActivityData[1].target) * 20/nTempNum))
        elseif nCurNum <= self.m_tDailyActivityData[3].target then 
            local nTempNum = self.m_tDailyActivityData[3].target - self.m_tDailyActivityData[2].target
            prgActivity:setPercentage(40 + math.floor((nCurNum - self.m_tDailyActivityData[2].target) * 20/nTempNum))
        elseif nCurNum <= self.m_tDailyActivityData[4].target then 
            local nTempNum = self.m_tDailyActivityData[4].target - self.m_tDailyActivityData[3].target
            prgActivity:setPercentage(60 + math.floor((nCurNum - self.m_tDailyActivityData[3].target) * 20/nTempNum))
        elseif nCurNum <= self.m_tDailyActivityData[5].target then 
            local nTempNum = self.m_tDailyActivityData[5].target - self.m_tDailyActivityData[4].target
            prgActivity:setPercentage(80 + math.floor((nCurNum - self.m_tDailyActivityData[4].target) * 20/nTempNum))
        else
            prgActivity:setPercentage(100)
        end
    end
    --当前活跃度
    GetElement(self.m_root, "txtCurActivityNum_WndTask", WZUILabelTTF):setText(nCurNum)
    --宝箱数据
    local closeBox = {"ui/task/task_activity_close1.png","ui/task/task_activity_close2.png","ui/task/task_activity_close3.png","ui/task/task_activity_close4.png","ui/task/task_activity_close5.png"}
    local openBox = {"ui/task/task_activity_close1.png","ui/task/task_activity_close2.png","ui/task/task_activity_close3.png","ui/task/task_activity_close4.png","ui/task/task_activity_close5.png"}
    local nullBox = {"ui/task/task_activity_empty1.png","ui/task/task_activity_empty2.png","ui/task/task_activity_empty3.png","ui/task/task_activity_empty4.png","ui/task/task_activity_empty5.png"}
    local activityIcon = GDatatab_item["id_80"].icon
    for i = 1, 5 do
        local imgBox = GetElement(self.m_root, "imgBox" .. i .. "_WndTask", WZUIImage)
        local txtTargetNum = GetElement(self.m_root, "txtTargetNum" .. i .. "_WndTask", WZUILabelTTF)
        local imgActivityIcon = GetElement(self.m_root, "imgActivityIcon" .. i .. "_WndTask", WZUIImage)
        local armBox = GetElement(self.m_root, "armBox" .. i .. "_WndTask", WZUISpine)

        local tData = self.m_tDailyActivityData[i]
        if tData.status == 0 and nCurNum >= tData.target then 
            tData.status = 1 
            PrefetchCache:updateActivityBoxStatus(i, 1)
        end
        if tData.status == 0 then 
            imgBox:setFile(closeBox[i])
            armBox:setVisible(false)
        elseif tData.status == 1 then 
            imgBox:setFile(openBox[i])
            armBox:setVisible(true)
        elseif tData.status == 2 then 
            imgBox:setFile(nullBox[i])
            armBox:setVisible(false)
        end
        txtTargetNum:setText(tData.target)
        imgActivityIcon:setFile(activityIcon)
    end
end
-------------------------------------语言适配模块Begin----------------------------------------

--@brief	英文适配函数
--@note		英文适配函数
function WndTask:_adaptLanguage_en()
    self.m_bIsadaptLanguage_en = true
end

--@brief  越南语适配函数
--@note   越南语适配
function WndTask:_adaptLanguage_vn()
    self.m_bIsadaptLanguage_en = true

    GetElement(self.m_root, "txtMainTask_1_WndTask", WZUILabelTTF):setFontSize(18)
    local txtDailyTask_1 = GetElement(self.m_root, "txtDailyTask_1_WndTask", WZUILabelTTF)
    txtDailyTask_1:setFontSize(18)
    txtDailyTask_1:setDimensions(GlobalMethod:CCSize(80))
    GetElement(self.m_root, "txtBranchTask_1_WndTask",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root, "txtAthleticsTask_1_WndTask",WZUILabelTTF):setFontSize(18)

    GetElement(self.m_root, "txtMainTask_WndTask", WZUILabelTTF):setFontSize(18)
    local txtDailyTask = GetElement(self.m_root, "txtDailyTask_WndTask", WZUILabelTTF)
    txtDailyTask:setFontSize(18)
    txtDailyTask:setDimensions(GlobalMethod:CCSize(80))
    GetElement(self.m_root, "txtBranchTask_WndTask",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root, "txtAthleticsTask_WndTask",WZUILabelTTF):setFontSize(18)
end

function WndTask:_adaptLanguage_pt(  )
    self.m_bIsadaptLanguage_en = true

    GetElement(self.m_root, "txtMainTask_1_WndTask", WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root, "txtDailyTask_1_WndTask", WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root, "txtBranchTask_1_WndTask",WZUILabelTTF):setFontSize(18)

    GetElement(self.m_root, "txtMainTask_WndTask", WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root, "txtDailyTask_WndTask", WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root, "txtBranchTask_WndTask",WZUILabelTTF):setFontSize(18)

end

function WndTask:_adaptLanguage_tr(  )
    GetElement(self.m_root, "txtDailyTask_WndTask", WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root, "txtDailyTask_1_WndTask", WZUILabelTTF):setFontSize(18)
end

function WndTask:_adaptLanguage_es(  )
    local txtMainTask = GetElement(self.m_root,"txtMainTask_WndTask",WZUILabelTTF)
    txtMainTask:setDimensions(GlobalMethod:CCSize(100,0))
    txtMainTask:setFontSize(18)

    local txtMainTask1 = GetElement(self.m_root,"txtMainTask_1_WndTask",WZUILabelTTF)
    txtMainTask1:setDimensions(GlobalMethod:CCSize(100,0))
    txtMainTask1:setFontSize(18)

    local txtBranchTask = GetElement(self.m_root,"txtBranchTask_WndTask",WZUILabelTTF)
    txtBranchTask:setDimensions(GlobalMethod:CCSize(100,0))
    txtBranchTask:setFontSize(18)

    local txtBranchTask1 = GetElement(self.m_root,"txtBranchTask_1_WndTask",WZUILabelTTF)
    txtBranchTask1:setDimensions(GlobalMethod:CCSize(100,0))
    txtBranchTask1:setFontSize(18)

    local txtDailyTask = GetElement(self.m_root,"txtDailyTask_WndTask",WZUILabelTTF)
    txtDailyTask:setDimensions(GlobalMethod:CCSize(100,0))
    txtDailyTask:setFontSize(18)

    local txtDailyTask1 = GetElement(self.m_root,"txtDailyTask_1_WndTask",WZUILabelTTF)
    txtDailyTask1:setDimensions(GlobalMethod:CCSize(100,0))
    txtDailyTask1:setFontSize(18)
end

function WndTask:_stopLoading()
    -- body
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nloadingId)
end
-------------------------------------语言适配模块End----------------------------------------



