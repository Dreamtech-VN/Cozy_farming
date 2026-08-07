--WndWakeup.lua
--@brief	WndWakeup的UI模块
--@date		2017/05/20
--@author	Tianxiang_Xu
--@note		觉醒模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWakeup:onEnter(element)
	self.m_root = element
    ProtocolProcessorWakeup:regAll()
    self:_AdaptationIphoneX()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWakeup:onExit(element)
    ProtocolProcessorWakeup:unregAll()
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------
--@brief    界面加载完成回调
function WndWakeup:onEnterTransitionDidFinish(element)
    -- body
    --金币栏
    self:setSpineAni()
    self:_addTop()
    self:_createLoading()
    ProtocolProcessorWakeup:send_AWAKE_GetAwakeInfo()
end

--@brief    触摸开始回调
function WndWakeup:onTouchBegin(element)
    -- body
    if CellWakeupDetail.m_root then
        if CellWakeupDetail.m_root:getChildByTag(999) then
            CellWakeupDetail.m_root:removeChildByTag(999, true)
        end
    end
    if WndItemInfo.m_root then 
        WZLog("WndWakeup:onTouchBegin")
        WndItemInfo:_onCloseClick()
    end

    if self.m_topCellLua then
        self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
end

--@brief    关闭按钮回调
function WndWakeup:onCloseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击详情按钮回调
function WndWakeup:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
--    local tRuleList = {LocalStrings.WAKEUP_TEXT15, LocalStrings.WAKEUP_TEXT24, LocalStrings.WAKEUP_TEXT25, LocalStrings.WAKEUP_TEXT26, LocalStrings.WAKEUP_TEXT27}
    local sRuleList = LocalStrings.WAKEUP_TEXT15 .. LocalStrings.WAKEUP_TEXT24 .. LocalStrings.WAKEUP_TEXT25 .. LocalStrings.WAKEUP_TEXT26 .. LocalStrings.WAKEUP_TEXT27 .. LocalStrings.WAKEUP_TEXT47
    WndSingleMapDesc:showInterface1(sRuleList)
end

--@brief    点击左边栏菜单回调
function WndWakeup:onClickLeftCallBack(nTag)
    -- body
    if self.m_nLeftSelIndex == nTag then return end 
    --设置新的选中状态
    self.m_nLeftSelIndex = nTag 
    for i = 1, #self.m_tLeftCell do
        self.m_tLeftCell[i]:setSelVisible(false)
        if self.m_nLeftSelIndex == i - 1 then
            self.m_tLeftCell[i]:setSelVisible(true)
        end
    end
    --展示相应的界面内容
    if nTag == 0 then       --进阶
        self:_createLoading()
        ProtocolProcessorWakeup:send_AWAKE_GetAwakeInfo()
    elseif nTag == 1 then   --魂
        self:_createWakeupDetail(nTag)
    elseif nTag == 2 then   --体
        self:_createWakeupDetail(nTag)
    elseif nTag == 3 then   --力
        self:_createWakeupDetail(nTag)
    elseif nTag == 4 then   --技
        self:_createWakeupDetail(nTag)
    elseif nTag == 5 then   --进化
        self:_createWakeupDetail(nTag)
    end
end

--@brief    点击重置按钮回调
function WndWakeup:onClickReset()
    -- body
    WZLog("WndWakeup:onClickReset")
    local bNeedReset = self:_judgeNeedReset()
    if not bNeedReset then
        MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT46)
        return
    end
    MsgBoxManager:showConfirmBox(LocalStrings.WAKEUP_TEXT44, self, self.sureToReset)
end

--@brief    确认重置天赋点
function WndWakeup:sureToReset()
    -- body
    if not JudgeMoneyIsEnough(809, 1, nil, nil, GlobalGame.g_nCurrentUIChannelId) then
        return 
    end

    self:_createLoading()
    ProtocolProcessorWakeup:send_AWAKE_ResetTalentNum()
end
-------------------------------------私有方法模块Begin--------------------------------------
--@brief    金币栏
function WndWakeup:_addTop()
    -- body
    local conTop = GetElement(self.m_root, "conTop_WndWakeup", WZUIContainer)
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/bag_icon_jx.png", WndWakeup, WndWakeup.onCloseClick, true, false, false, nil, {goldType = 12})
    self.m_root:addChild(celElement)
    self.m_topCellLua = tNewObj
end

--@brief    刷新界面
function WndWakeup:_update()
    -- body
    self:_createLeftMenuList()
end

--@brief    创建左边栏菜单项
function WndWakeup:_createLeftMenuList()
    -- body
    local tableLeftItem = GetElement(self.m_root, "tableLeftItem_WndWakeup", WZUITableContainer)
    tableLeftItem:cleanTable()
    self.m_tLeftCell = {}
    WZLog("WndWakeup:_createLeftMenuList", #self.m_tLeftList)
    for i = 1, #self.m_tLeftList do
        local element, objNew = CellWakeupLeftItem:createElement()
        if element and objNew then
            objNew:setData(self.m_tLeftList[i])
            objNew:setCallBackFun(self, self.onClickLeftCallBack)
            if self.m_nLeftSelIndex == i - 1 then
                objNew:setSelVisible(true)
            end
            table.insert(self.m_tLeftCell, objNew)
            element:setTag(i - 1)
            tableLeftItem:setCellElement(element)
        end
    end
end

--@brief    创建觉醒进阶界面
function WndWakeup:_createWakeup()
    -- body
    local conRight = GetElement(self.m_root, "conRight_WndWakeup", WZUIContainer)
    if CellWakeupDetail.m_root then
        CellWakeupDetail.m_root:removeFromParentAndCleanup(true)
    end
    if conRight then
        local nCurSection = self:_getActiveNum()
        local nMaxTaskNum = GetTableLen(GDatatab_awake_base)
        if nMaxTaskNum == nCurSection then 
            nCurSection = nCurSection - 1
        end
        CellWakeupTask:showInterface(conRight, self.m_nTopSelIndex, nCurSection + 1)
    end
end

--@brief    创建觉醒之魂、体、力、技界面
--@param    nIndex:1->魂；2->体；3->力；4->技；5->进化
function WndWakeup:_createWakeupDetail(nIndex)
    -- body
    local conRight = GetElement(self.m_root, "conRight_WndWakeup", WZUIContainer)
    if CellWakeupTask.m_root then
        CellWakeupTask.m_root:removeFromParentAndCleanup(true)
    end
    if conRight then
        CellWakeupDetail:showInterface(conRight, nIndex)
    end
end

--@brief	打开萃取合成窗口
function WndWakeup:onSubWin() 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndExtraction:showInterface()
end

--适配iphoneX
function WndWakeup:_AdaptationIphoneX()
    -- body
    WZLog("WndWakeup:_AdaptationIphoneX")
    if IsIphoneX() then
        local conLeftPart = GetElement(self.m_root,"conLeftPart",WZUIContainer)
        conLeftPart:setAbsContentSize(GlobalMethod:CCSize(180,470))
        conLeftPart:updateRelativeSize()
    end
end

--@brief    设置开箱特效
function WndWakeup:setSpineAni()
    local spineOpen = GetElement(self.m_root, "spineOpen_WndWakeup", WZUISpine)
    local spinePath = "ui/otherUI/ui_juexingzhihun_lingqu"
    local bIsExist = CheckEffectFile(spinePath)

    if bIsExist then 
        spineOpen:setFileJson(spinePath .. ".json")
        spineOpen:setFileAtlas(spinePath .. ".atlas")
    end
end
-------------------------------------私有方法模块End----------------------------------------
