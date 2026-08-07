--CellTopHandle.lua
--@brief	CellTopHandle的UI模块
--@date		2015-12-15
--@author	binshao
--@note		顶部菜单栏


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTopHandle:onEnter(element)
	self.m_root = element

    if not GlobalGame.g_bSendEventPerMinite then 
        self.m_bIsDoSendEvent = true 
        GlobalGame.g_bSendEventPerMinite = true 
    end
    self.m_root:enableSchedule("sendVNPulseEvent", 1)
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTopHandle:onExit(element)
    WZLog("CellTopHandle:onExit", #g_tCellTopHandleObj)
    for i = #g_tCellTopHandleObj, 1, -1 do
        if g_tCellTopHandleObj[i] == self then
            table.remove(g_tCellTopHandleObj, i)
            if self.m_bIsDoSendEvent then 
                GlobalGame.g_bSendEventPerMinite = false
            end
            break 
        end
    end
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief    获取金币图标节点
function CellTopHandle:getGoldNode()
    -- body
    local goldNode = self.goldCellInfo.tcell:getGoldNode()

    return goldNode
end

--@brief    设置返回按钮的触摸区域
function CellTopHandle:resetTitleSize()
    -- body
    if self.m_root == nil then return end 

    local conTitle = GetElement(self.m_root, "conTitle_CellTopHandle", WZUIContainer)
    conTitle:setAbsContentSize(GlobalMethod:CCSize(128, 62))
    conTitle:updateRelativeSize()

    GetElement(self.m_root, "imgBack_CellTopHandle", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.35, 0.5))
    GetElement(self.m_root, "imgBackSel_CellTopHandle", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.35, 0.5))
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellTopHandle:onReturn()
    if self.m_bIsMatching then
        MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
        return 
    end
    if self.shieldClick then
        MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
        return
    end
    local data = self.data
    if data.luaObj and data.cbFunc then
        data.cbFunc(data.luaObj)
    elseif data.cbFunc then
        data.cbFunc()
    else
        WZLog("------------------parament error-------------")
    end
end

function CellTopHandle:_update()
    self:_initUI()
    self:_addGold()
    self:addBottomBar()
    self:_setNetSignal()
end

-- 初始化UI
function CellTopHandle:_initUI()
    local img = GetElement(self.m_root,"imgTitle_CellTopHandle", WZUIImage)
    if self.data.imgPath then 
        img:setFile(self.data.imgPath) 
        local scale = 1
        if self.data.tOther and self.data.tOther.scale then
           scale = self.data.tOther.scale
        end
        img:setScale(scale)
    end
end

-- 添加货币快捷键
function CellTopHandle:_addGold()
	local celElement,tCell
    if self.data.coinFlag then
        local conGold = GetElement(self.m_root,"conGold_CellTopHandle", WZUIContainer)
        if conGold then
            if self.goldCellInfo == nil then 
                celElement,tCell = CellGold:createElement()
                tCell:setCellType(0)
                if celElement and tCell then
                    conGold:addChild(celElement)
                    self.goldCellInfo = {cell = celElement, tcell = tCell }
                end
            else
                celElement = self.goldCellInfo.cell
                tCell = self.goldCellInfo.tcell
            end
        end
    end
	if self.data.tOther == nil then 
        if tCell then 
            tCell:showCoin({1,177,2,6},{1,1,1,1})
        end
        return 
    end
	--设置货币栏类型
	if self.data.tOther.goldType == 1 then
		tCell:showCoin({1,177,2},{1,1,1})
	elseif self.data.tOther.goldType == 2 then --宠物
        tCell:showCoin({1,177,107,163},{1,1,1,1})
    elseif self.data.tOther.goldType == 3 then --祈福
        tCell:showCoin({1,177,23,22},{1,1,1,1})
    elseif self.data.tOther.goldType == 4 then --召唤
        local equipLotteryPrice =  CacheCenter:getGameParam().equipLotteryPrice
        local m_tIds,m_tNums = SplitItemString(equipLotteryPrice)
        local keyId =  tonumber(m_tIds[4])
        local keyId2 =  tonumber(m_tIds[1])
        local tItemId = {}
        tItemId[1] = 1
        tItemId[2] = 177
        tItemId[3] = keyId
        tItemId[4] = keyId2
		tCell:showCoin(tItemId,{1,1,1,1})
    elseif self.data.tOther.goldType == 5 then --卡牌
        tCell:showCoin({1,177,26,79},{1,1,1,1})
    elseif self.data.tOther.goldType == 6 then --商城
        tCell:showCoin({1,177,2,57},{1,1,1,0})
    elseif self.data.tOther.goldType == 7 then--矿晶
        tCell:showCoin({1,177,2,58},{1,1,1,1})
    elseif self.data.tOther.goldType == 8 then --符文购买币
        tCell:showCoin({1,177,2,59},{1,1,1,1})
    elseif self.data.tOther.goldType == 9 then --幻化购买币
        tCell:showCoin({1,177,2,61},{1,1,1,1})
    elseif self.data.tOther.goldType == 10 then --骰子
        tCell:showCoin({1,177,2,60},{1,1,1,1})
    elseif self.data.tOther.goldType == 11 then --家园系统
        tCell:showCoin({1,177,66,67},{1,1,1,1})
    elseif self.data.tOther.goldType == 12 then --觉醒系统
        tCell:showCoin({1,177,62},{1,1,0})
        GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.75, 0.5))
    elseif self.data.tOther.goldType == 13 then --小家（小孩）系统
        tCell:showCoin({1,177,2},{1,1,1})
    elseif self.data.tOther.goldType == 14 then --职业系统
        if ProjConfig.LANGUAGE == "vn" then
            tCell:showCoin({1,177,2,86},{1,1,1,1})
            GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.85, 0.5))
        else
            tCell:showCoin({1,177,2,85},{1,1,1,1})
            GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.75, 0.5))
        end
    elseif self.data.tOther.goldType == 15 then --职业系统
        tCell:showCoin({1,177,2,95},{1,1,1,1})
        GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.85, 0.5))
    elseif self.data.tOther.goldType == 16 then--抽奖
        tCell:showCoin({1,177,2,96},{1,1,1,1})
        GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.75, 0.5))
    elseif self.data.tOther.goldType == 17 then--度假村
        tCell:showCoin({1,70,161045},{1,1,0})
        GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.75, 0.5))
    elseif self.data.tOther.goldType == 18 then--神树系统
        tCell:showCoin({1,70},{1,1})
        GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.75, 0.5))
	end
end

-- 添加下拉菜单
function CellTopHandle:addBottomBar()
    if self.data.bottomBarFlag == 1 then
        local con = GetElement(self.m_root,"conBottomBar_CellTopHandle", WZUIContainer)
        local wndBottomBar,wndBottomBarObj = WndBottomBar:createElement()
        con:addChild(wndBottomBar)
        self.bottomCell = wndBottomBar
        self.bottomTcell = wndBottomBarObj
        wndBottomBarObj:setNeedMoveVerticalBar(true)
        CacheCenter:updateRedPoint("right",wndBottomBar,nil,7)

        if self.data.bottomBarFlag == 1 then
            self.bottomTcell:setNeedMoveVerticalBar(false)
        end

        -- 处理红点
        if self.data.redPointObj and self.data.chatFlag then
            GlobalGame:getBtnRedPointEvent():regListenerBottomBar(self.data.redPointObj,wndBottomBarObj,"right")
        end

        -- 屏蔽聊天
        if not self.data.chatFlag then
            self.bottomTcell:setNeedChat(false)
            WndCurrentChat:hideButtomChat()
        end

        local conNetSignal = GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer)
        CellNetSignal:showInterface(conNetSignal)
        return 
    end

    if self.data.bottomBarFlag then
        local con = GetElement(self.m_root,"conBottomBar_CellTopHandle", WZUIContainer)
        local wndBottomBar,wndBottomBarObj = WndBottomBar:createElement()
        con:addChild(wndBottomBar)
        self.bottomCell = wndBottomBar
        self.bottomTcell = wndBottomBarObj
        wndBottomBarObj:setNeedMoveVerticalBar(true)
        CacheCenter:updateRedPoint("right",wndBottomBar,nil,7)

        -- 处理红点
        if self.data.redPointObj then
            GlobalGame:getBtnRedPointEvent():regListenerBottomBar(self.data.redPointObj,wndBottomBarObj,"right")
        end

        -- 屏蔽聊天
        if not self.data.chatFlag then
            self.bottomTcell:setNeedChat(false)
            WndCurrentChat:hideButtomChat()
        end
    end
end

--@brief	设置聊天
function CellTopHandle:setChatShow(stat)
	if stat then
		WZLog("显示聊天")
        self.bottomTcell:setNeedChat(true)
        WndCurrentChat:showButtomChat()
	else
		WZLog("隐藏聊天")
        self.bottomTcell:setNeedChat(false)
        WndCurrentChat:hideButtomChat()
	end
end

--@brief  设置标题
function CellTopHandle:setTitleFile(titlePath)
    GetElement(self.m_root,"imgTitle_CellTopHandle",WZUIImage):setFile(titlePath)
end

--@brief  设置标题富文本
function CellTopHandle:setTitleFtb(titleFtb)
    GetElement(self.m_root,"ftbTitle_CellTopHandle",WZUIFreeTextBox):setShowText(titleFtb)
end

--@brief  设置返回按钮是否可点
function CellTopHandle:setBackStats(stats)
    WZLog("CellTopHandle:setBackStats")
    GetElement(self.m_root,"btnBack_CellTopHandle",WZUIButton):setTouchEnable(stats)
end

--@brief 设置顶部导航栏是否可点
function CellTopHandle:setTopTouchEnable(status)
    WZLog("CellTopHandle:setTopTouchEnable")
    GetElement(self.m_root,"conTop_CellTopHandle",WZUIContainer):setTouchEnable(status)
end

--@brief    设置显示网络延迟信号
function CellTopHandle:_setNetSignal()
    -- body
    if not self.data.bottomBarFlag then
        local conNetSignal = GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer)
        CellNetSignal:showInterface(conNetSignal)

        conNetSignal:setRelativePosition(GlobalMethod:ccp(0.3, 0.5))
        if self.data and self.data.tOther and (self.data.tOther.goldType == 14 or self.data.tOther.goldType == 15) then
            conNetSignal:setRelativePosition(GlobalMethod:ccp(0.85, 0.5))
        end
    end
end

--@brief    设置聊天按钮大小
--@param    nScale: 缩放倍数
--@param    rPt: 相对位置
function CellTopHandle:setChatBtnSize(nScale, rPt)
    -- body
    if self.bottomTcell then 
        self.bottomTcell:setChatBtnScale(nScale, rPt)
    end
end

--@brief    设置wifi信号图标的可见与否
function CellTopHandle:setWifiSignalVisible(bVisible)
    -- body
    GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer):setVisible(bVisible)
    if self.bottomTcell then
        self.bottomTcell:setWifiSignalVisible(false)
    end
end

--@brief    设置背景条可见与否
function CellTopHandle:setTopBGVisible(bVisible)
    -- body
    GetElement(self.m_root, "conForBg_CellTopHandle", WZUIContainer):setVisible(bVisible)
end

--@brief    设置标题可见与否
function CellTopHandle:setTopTitleVisible(bVisible)
    -- body
    GetElement(self.m_root,"imgTitle_CellTopHandle",WZUIImage):setVisible(bVisible)
end

--@brief    设置下拉菜单不可见
function CellTopHandle:setBottomBarVisible(bVisible)
    -- body
    GetElement(self.m_root, "conBottomBar_CellTopHandle", WZUIContainer):setVisible(bVisible)
end

--@brief    设置越南12+图片显示
function CellTopHandle:setImgVnVisible(bVisible)
    local imgVN = GetElement(self.m_root, "imgVN_CellTopHandle",WZUIImage)
    if imgVN then
        imgVN:setVisible(bVisible)
    end
end--@brief    设置白色背景条是否显示
function CellTopHandle:setImageBgVisible(bVisible)
    -- body
    GetElement(self.m_root,"imgBg2_2_CellTopHandle",WZUIImage):setVisible(bVisible)
end--@brief    改变菜单栏类型
function CellTopHandle:setTopType()    
    local conTitle = GetElement(self.m_root, "conTitle_CellTopHandle", WZUIContainer)
    conTitle:setAbsContentSize(GlobalMethod:CCSize(125, 60))
    conTitle:updateRelativeSize()
    local imgBg1 = GetElement(self.m_root,"imgBg1_CellTopHandle",WZUI9Image)
    imgBg1:setVisible(false)
    local imgBg2_1 = GetElement(self.m_root,"imgBg2_1_CellTopHandle",WZUIImage)
    imgBg2_1:setVisible(true)
    local imgBack = GetElement(self.m_root,"imgBack_CellTopHandle",WZUIImage)
    imgBack:setFile("ui/common/common_top_btn_fanhui.png")
    imgBack:setRelativePosition(GlobalMethod:ccp(0.46,0.58))
    local imgBackSel = GetElement(self.m_root,"imgBackSel_CellTopHandle",WZUIImage)
    imgBackSel:setFile("ui/common/common_top_btn_fanhui.png")
    imgBackSel:setRelativePosition(GlobalMethod:ccp(0.46,0.58))
    local imgTitle = GetElement(self.m_root,"imgTitle_CellTopHandle", WZUIImage)
    -- imgTitle:setRelativePosition(GlobalMethod:ccp(1.056,0.58))
    imgTitle:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    imgTitle:setRelativePosition(GlobalMethod:ccp(0.173,0.675))
    GetElement(self.m_root,"conGold_CellTopHandle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.62,0.6125))

    local btnCity = GetElement(self.m_root, "btnCity_CellTopHandle", WZUIButton)
    if self.data.bShowhouse == false then
        btnCity:setVisible(false)
    else
        btnCity:setVisible(true)
    end

    local btnTask = GetElement(self.m_root, "btnTask_CellTopHandle", WZUIButton)
    if self.data.bShowTask == false then
        btnTask:setVisible(false)
    else
        self:showCurTask()
        btnTask:setVisible(true)
    end

    local imgBg2_2 = GetElement(self.m_root,"imgBg2_2_CellTopHandle",WZUIImage)
    if self.data.coinFlag then
        imgBg2_2:setVisible(true)
    end
    
    self:setRulePosition()
end

function CellTopHandle:setRulePosition(pos, scale)
    pos = pos or GlobalMethod:ccp(0.33,0.6525)
    scale = scale or 0.25
    local imgVN = GetElement(self.m_root, "imgVN_CellTopHandle",WZUIImage)
    if imgVN then
        imgVN:setVisible(true)
        imgVN:setRelativePosition(pos)
        imgVN:setFile("ui/common/12-plus-detail.png")
        imgVN:setScale(scale)
        --ios审核不显示12+防沉迷图片
        if CacheCenter:getGameParam().gameStatus == "1" then
            imgVN:setVisible(false)
        end
    end
end
--@brief    跳转主城按钮回调
function CellTopHandle:onJumpCity(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- if SceneCity.m_root ~= nil then
    --     WindowManager:removeAllWindow()
    --     SceneCity:visibleWithoutFullScreenWnd()
    -- else
    --     local scene = SceneCity:createElement()
    --     replaceScene(scene)
    -- end
    
    if self.m_bIsMatching then
        MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
        return 
    end
    if self.shieldClick then
        MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
        return
    end

    if self.m_tCallBack[1] and self.m_tCallBack[2] then
        self.m_tCallBack[2](self.m_tCallBack[1])
    end
    
    if SceneCity.m_root ~= nil then
        WindowManager:removeAllWindow()
        SceneCity:visibleWithoutFullScreenWnd()
    else
        local scene = SceneCity:createElement()
        replaceScene(scene)
    end
end


function CellTopHandle:updateTask()
    if self.m_root == nil then
        return
    end

    self:showCurTask()
end

--@brief    展示当前的任务
function CellTopHandle:showCurTask()
    -- body
    if self.m_root == nil then return end
    local imgTask = GetElement(self.m_root,"imgTask_CellTopHandle",WZUIImage)

    self.m_curTaskData = nil
    local taskList = PrefetchCache:getCityTask()
    if taskList and taskList[1] then 
        local nComplete = taskList[1].nTargetStatus
        local taskData = GDatatab_task["id_" .. taskList[1].nId]
        self.m_curTaskData = taskList[1]
        if taskList[1].nTaskStatus == TASKSTATUS_TOSUBMIT then
            --已完成
            imgTask:setFile("ui/common/common_icon_rw1.png")
            return
        end
        --进行中
        imgTask:setFile("ui/common/common_icon_rw.png")
    else
        --今日的任务都完成了
        imgTask:setFile("ui/common/common_icon_rw.png")
    end
end

function CellTopHandle:onClickTask(element)
    if self.m_bIsMatching then
        MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
        return 
    end
    if self.shieldClick then
        MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
        return
    end

    local wndTaskElement = WndTask:createElement()
    WindowManager:addWindow(wndTaskElement, WndTask,nil,nil,nil)
end

--@brief    点击任务跳转或领取任务奖励
function CellTopHandle:onJumpTask(element)    
    local status, score = GlobalMethod:HonorPointStatus(1)
    if status == false then
        WndHonorPoint:showInterface(score)
        return
    end
    
    CellTopHandle.m_current = self
    -- body
    if self.m_curTaskData == nil then
        self:onClickTask(element)
        return
    end

    local nTaskId = self.m_curTaskData.nId
    local taskData = GDatatab_task["id_" .. nTaskId]
    if self.m_curTaskData.nTaskStatus == TASKSTATUS_DOING then
        self:onClickTask(element)
        return
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("CellTopHandle:onJumpTask", nTaskId)

    TeachGroup1.TASK_GO_ID = nTaskId

    TeachGroup1:endTeachStep({3,3},{3,4},{5,9},{5,10},{7,5},{8,6},{9,1},{20,8},{20,9},{9,5},{9,6},{31,1},{32,2},{32,3},{33,1},{34,1},{35,1},{36,1},{39,1},{40,1},{41,9})


    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self:weatherInGetReward() then return end 

    self:setGetRewardLimit(true)
    local tData = {}
    tData.taskType = taskData.type
    tData.taskId = tostring(nTaskId)
    tData.subTaskId = "1"
    tData.taskProgr = "1_1"
    PostPlayerEvent:postEvent(PostPlayerEvent.event_task, tData)

    local tData = {}
    tData.taskType = taskData.type
    tData.taskId = tostring(nTaskId)
    tData.subTaskId = "1"
    tData.taskProgr = "1_1"
    PostPlayerEvent:postEvent(PostPlayerEvent.event_task, tData)

    WZLog("CellTopHandle:onCommitEvent GetReward", nTaskId)
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    postGetTaskRewardEvent(nTaskId)
    ProtocolProcessorWndTask:send_TASK_GetTaskReward(nTaskId)

end


--@brief    领取奖励收到错误协议，去掉领取状态限制
function CellTopHandle:setGetRewardLimit(bBool)
    -- body
    if self.m_root == nil then return end 

    self.m_bIsGettingReward = bBool
end

--@brief    获取是否在领取奖励
function CellTopHandle:weatherInGetReward()
    -- body
    return self.m_bIsGettingReward
end

--@brief    副本界面领取任务后，刷新新任务
function CellTopHandle:updateTaskAfterReward(nTaskId, nTaskType, nTaskStatus, reward)
    -- body
    if self.m_root == nil then return end 
    if self.m_nLoadingId then 
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
        self.m_nLoadingId = nil 
    end
    local tRewardsNum
    local tRewardsItemId
    if reward then 
        tRewardsItemId, tRewardsNum = SplitItemString(reward)
    else
        tRewardsNum,tRewardsItemId = WndTask:_getTaskRewards(nTaskType, nTaskId)
    end
    WndRewardShow:showById(tRewardsItemId,tRewardsNum,nil,nTaskId)
    
    self:setGetRewardLimit(false)
end

--@brief    计时器
function CellTopHandle:sendVNPulseEvent()
    if ProjConfig.LANGUAGE ~= "vn" then return end 

    if not GlobalGame.g_bSendEventPerMinite then 
        if not self.m_bIsDoSendEvent then 
            self.m_bIsDoSendEvent = true 
            GlobalGame.g_bSendEventPerMinite = true 
        end
    end

    if self.m_bIsDoSendEvent and GlobalGame.g_bSendEventPerMinite then 
        local nCurTime = SystemTime:getServerTime()
        if nCurTime - GlobalGame.g_nLoginInCityTime >= 60 then 
            GlobalGame.g_nLoginInCityTime = nCurTime 
            if PassportSdkManager.postGameInfoVn then
                PassportSdkManager:postGameInfoVn("pulse", "")
            end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-------------------------------------------
function CellTopHandle:_adaptLanguage_pt(  )
    GetElement(self.m_root,"conGold_CellTopHandle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6,0.6125))
end

function CellTopHandle:_adaptLanguage_es(  )
    GetElement(self.m_root,"conGold_CellTopHandle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6,0.6125))
end

function CellTopHandle:_adaptLanguage_en(  )
    GetElement(self.m_root,"conGold_CellTopHandle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6,0.6125))
end

function CellTopHandle:_adaptLanguage_vn(  )
    GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.85, 0.6125))

    local conGold = GetElement(self.m_root,"conGold_CellTopHandle",WZUIContainer)
    conGold:setRelativePosition(GlobalMethod:ccp(0.58,0.6525))
    conGold:setScale(0.9)

    -- 越南12+防沉迷图片
    local imgVN = GetElement(self.m_root, "imgVN_CellTopHandle",WZUIImage)
    imgVN:setVisible(true)
    imgVN:setFile("ui/common/12-plus-detail.png")
    --ios审核不显示12+防沉迷图片
    if CacheCenter:getGameParam().gameStatus == "1" then
        imgVN:setVisible(false)
    end
end
--------------------------------------语言适配End----------------------------------------------