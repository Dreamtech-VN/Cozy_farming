--WndSweep.lua
--@brief	WndSweep2的UI模块
--@date		2014/08/21
--@author	hugozheng
--@note		购买活力面板


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSweep:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end
--@brief onEnter函数执行完成回调
function WndSweep:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndSweep:actionCallback(element, data)
    self.m_root:enableSchedule("scheduleLoadUI", 0)
end

--@brief    加载界面元素定时器
function WndSweep:scheduleLoadUI()
    self.m_root:disableSchedule()
end
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSweep:onExit(element)
	self:_unInit()
end

--@brief	刷新扫荡画面调用的函数
--@param
--@note
function WndSweep:initSweepPanel()
    self.m_stepTime = 2
    self.m_timeCounter = 0
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtBtnSure_WndSweep")):setText(LocalStrings.CONFIRM)
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtBtnView_WndSweep")):setText(LocalStrings.CHECK_REWARD)
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtBtnStart1_WndSweep")):setText(LocalStrings.START)

    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtBtnStart1_WndSweep")):setStrokeColor(ccc3(29,121,1))
    
    local btnComfirm = self.m_root:getChildElement("btnComfirm_WndSweep")
    local btnView = self.m_root:getChildElement("btnView_WndSweep")
    local btnStart = self.m_root:getChildElement("btnStart_WndSweep")
    WZUIButton:luaTo(btnComfirm):setVisible(false)
    WZUIButton:luaTo(btnView):setVisible(false)
    WZUIButton:luaTo(btnView):setTouchEnable(false)
    WZUIButton:luaTo(btnStart):setVisible(true)
    WZUIButton:luaTo(btnStart):setTouchEnable(true)
    WZUIContainer:luaTo(self.m_root:getChildElement("settingBg_WndSweep")):setVisible(true)
    WZUIContainer:luaTo(self.m_root:getChildElement("setting_WndSweep")):setVisible(true)
    WZUIContainer:luaTo(self.m_root:getChildElement("doing_WndSweep")):setVisible(false)
    WZUIContainer:luaTo(self.m_root:getChildElement("done_WndSweep")):setVisible(false)
    WZUIFreeTextBox:luaTo(self.m_root:getChildElement("txtTimer_WndSweep")):setVisible(false)
       --清空扫荡信息列表
    local freelistcon = self.m_root:getChildElement("freelistcon_WndSweep")
    if freelistcon==nil then
		return
	end
    freelistcon = WZUIFreeListContainer:luaTo(freelistcon)
    
    if freelistcon:size() >= 1 then
		freelistcon:removeAt(0)
	end
end
--@brief	刷新扫荡画面调用的函数
--@param	
--@note		
function WndSweep:updateSweepPanel()

	if self.m_data.useVigor == nil or self.m_data.vigor == nil or self.m_data.maxVigor == nil then
		return
	end

	local txtCurNum = self.m_root:getChildElement("txtCurNum_WndSweep")
	local txtCurActivity = self.m_root:getChildElement("txtCurActivity_WndSweep")
    local txtNeedActivity = self.m_root:getChildElement("txtNeedActivity_WndSweep")
    local txtDesc = self.m_root:getChildElement("txtDesc_WndSweep")
    local txtCS = self.m_root:getChildElement("txtCS_WndSweep")
    local txtName = self.m_root:getChildElement("txtName_WndSweep")
    
    local txtNeedAc = self.m_root:getChildElement("txtNeedAc_WndSweep")
    local txtLeftAc = self.m_root:getChildElement("txtLeftAc_WndSweep")

    WZUILabelTTF:luaTo(txtDesc):setText(LocalStrings.SWEEP_DESC)
	WZUILabelTTF:luaTo(txtNeedAc):setText(LocalStrings.NEED_ACTIVITY)
    WZUILabelTTF:luaTo(txtLeftAc):setText(LocalStrings.LEFT_ACTIVITY)
    WZUILabelTTF:luaTo(txtCS):setText(LocalStrings.SWEEP_TIME)
    if self.m_data.totalTime >0 then
        WZUILabelTTF:luaTo(txtCurNum):setText(self.m_currentTime.." / "..self.m_data.totalTime)
    else
        WZUILabelTTF:luaTo(txtCurNum):setText(self.m_currentTime.." / "..LocalStrings.UNLIMITE)
    end
    
    WZUILabelTTF:luaTo(txtCurActivity):setText((self.m_data.vigor))
    WZUILabelTTF:luaTo(txtNeedActivity):setText(self.m_needActivity)
    WZUILabelTTF:luaTo(txtName):setText(self.m_data.name)
end
--@brief	刷新扫荡画面调用的函数
--@param
--@note
function WndSweep:updateVigor(nVigor, nCanBuyTimes)
    
    self.m_data.vigor = nVigor
    --self.m_nCanBuyTimes = nCanBuyTimes
	local txtCurActivity = self.m_root:getChildElement("txtCurActivity_WndSweep")
    WZUILabelTTF:luaTo(txtCurActivity):setText((self.m_data.vigor))
    
end
--@brief	增加扫荡次数调用的函数
--@param
--@note
function WndSweep:addSweepCount(element)
    if self.m_currentTime >= self.m_data.totalTime and self.m_data.totalTime ~= -1 then
        self.m_currentTime = self.m_data.totalTime
        MsgBoxManager:showTipBox(LocalStrings.OVER_SWEEP_COUNT, nil, nil, nil, nil)
       return
    end
    local _count = self.m_currentTime +1
    local _needActivity = _count*self.m_data.useVigor
    --当所需活力大于现有活力时执行程序
    if _needActivity > self.m_data.vigor then
        MsgBoxManager:showTipBox(LocalStrings.NONE_ACTIVITY, nil, nil, nil, nil)
        return
    end
    self.m_currentTime = _count
    self.m_needActivity = _needActivity
    --成功添加次数，刷新画面
    WndSweep:updateSweepPanel()
end

--@brief	减少扫荡次数调用的函数
--@param
--@note
function WndSweep:reduceSweepCount(element)
    --当扫荡次数不足执行
    if self.m_currentTime <= 1 then
        MsgBoxManager:showTipBox(LocalStrings.NO_LESS_ONE, nil, nil, nil, nil)
        self.m_currentTime = 1
        return
    end
    local _count = self.m_currentTime - 1
    local _needActivity = _count*self.m_data.useVigor
 
    self.m_currentTime = _count
    self.m_needActivity = _needActivity
    --成功添加次数，刷新画面
    WndSweep:updateSweepPanel()
end

--@brief	增加活力调用的函数
--@param	
--@note		
function WndSweep:addActivity(element)
	
end
--@brief	确认结束扫荡调用的函数
--@param
--@note
function WndSweep:onOK(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --ProtocolProcessorSingleMap:send_SINGLEMAP_GetBigPointList()
    WindowManager:removeWindow(self.m_root, self, true)
end
--@brief	查看扫荡结果调用的函数
--@param
--@note
function WndSweep:onViewResult(element)
    local btnComfirm = self.m_root:getChildElement("btnComfirm_WndSweep")
    local btnView = self.m_root:getChildElement("btnView_WndSweep")
    local btnStart = self.m_root:getChildElement("btnStart_WndSweep")
    WZUIButton:luaTo(btnComfirm):setVisible(true)
    WZUIButton:luaTo(btnView):setVisible(false)
    WZUIButton:luaTo(btnView):setTouchEnable(false)
    WZUIButton:luaTo(btnStart):setVisible(false)
    WZUIContainer:luaTo(self.m_root:getChildElement("doing_WndSweep")):setVisible(false)
    WZUIContainer:luaTo(self.m_root:getChildElement("done_WndSweep")):setVisible(true)

    local sRemainTime = ""
    if self.m_data.totalTime == -1 then
        sRemainTime = LocalStrings.UNLIMITE
    else
        sRemainTime = tostring(self.m_data.totalTime - self.m_currentTime)
    end
    local words1 = string.format(LocalStrings.SWEEP_MAPNAME ,self.m_data.name)
    local words2 = string.format(LocalStrings.SWEEP_TIMES ,tostring(sRemainTime))
    local words3 = string.format(LocalStrings.SWEEP_USEDACT , self.m_needActivity)
    local exps = 0
    for i=1,#self.m_exp do
        exps = exps +self.m_exp[i]
    end
    local words4 = string.format(LocalStrings.SWEEP_WINEXP , exps)
    
    local golds = 0
    for i=1,#self.m_reeardGolds do
        golds = golds +self.m_reeardGolds[i]
    end
    local words5 = string.format(LocalStrings.SWEEP_WINGOLDS , golds)
    WndSweep:updateEndingPanel(words1)
    WndSweep:updateEndingPanel(words2)
    WndSweep:updateEndingPanel(words3)
    WndSweep:updateEndingPanel(words4)
    WndSweep:updateEndingPanel(words5)
    for i=1,#self.m_reward do
        local rewards =string.format(LocalStrings.SWEEP_GET_SWARD,self.m_reward[i])
        WndSweep:updateEndingPanel(rewards)
    end
end
--@brief 开始扫荡调用的函数
--@param
--@note
function WndSweep:onStart(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if (self.m_data.vigor-self.m_needActivity)< 0 then
        MsgBoxManager:showTipBox(LocalStrings.NONE_ACTIVITY, nil, nil, nil, nil)
        return
    end
    if self.m_currentTime > self.m_data.totalTime and self.m_data.totalTime ~= -1 then
        MsgBoxManager:showTipBox(LocalStrings.OVER_SWEEP_COUNT, nil, nil, nil, nil)
        return
    end
    self.m_starting = true
    local btnStart = self.m_root:getChildElement("btnStart_WndSweep")
    WZUIButton:luaTo(btnStart):setTouchEnable(false)
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtBtnStart1_WndSweep")):setStrokeColor(ccc3(0,0,0))
    WZUIContainer:luaTo(self.m_root:getChildElement("settingBg_WndSweep")):setVisible(false)
    WZUIContainer:luaTo(self.m_root:getChildElement("setting_WndSweep")):setVisible(false)
    WZUIContainer:luaTo(self.m_root:getChildElement("doing_WndSweep")):setVisible(true)
   
    local txtTimer = self.m_root:getChildElement("txtTimer_WndSweep")
    WZUIFreeTextBox:luaTo(txtTimer):setVisible(true)
	ProtocolProcessorSingleMap:send_SINGLEMAP_StartRaids(self.m_data.pointId,self.m_currentTime)
  
end
--@brief 开始扫荡协议回调用的函数
--@param rewardName:掉落物品
--@param rewardName:掉落经验
--@note
function WndSweep:onStartSweepCallBack(rewardName,rewardExp,rewardGolds)
    self.m_exp = {}
    self.m_reward = {}
    self.m_starting = true
    self.m_exp = rewardExp
    self.m_reward = rewardName
    self.m_count=#rewardName
    --更新挑战次数
    --WndSingleMap:updateSweepTime(self.m_count)
    self.m_reeardGolds = rewardGolds
    local words=LocalStrings.SWEEPING_NOW
    WndSweep:updateResultPanel(words)
    self.m_timeCounter = self.m_count*self.m_stepTime
    local timerMsg = self.m_root:getChildElement("txtTimer_WndSweep")
    local timeM  = returnToTimeFormat(self.m_timeCounter)
    local timerNum = string.format(LocalStrings.SWEEP_TIMMING ,timeM)
    WZUIFreeTextBox:luaTo(timerMsg):setVisible(true)
    WZUIFreeTextBox:luaTo(timerMsg):setShowText(timerNum)
    if self.m_count>0 then
        self.m_root:enableSchedule("updateSchedule",1)
    end
end
--@brief 开始扫荡协议回调用的函数
--@param
--@note
function WndSweep:updateSchedule()
    self.m_timeCounter = self.m_timeCounter -1
    local timerMsg = self.m_root:getChildElement("txtTimer_WndSweep")
    local timeM  = returnToTimeFormat(self.m_timeCounter)
    local timerNum = string.format(LocalStrings.SWEEP_TIMMING ,timeM)
    
    if self.m_timeCounter <= 0 then
        self.m_starting = false
        self.m_root:disableSchedule()
        WZUIFreeTextBox:luaTo(timerMsg):setShowText(LocalStrings.SWEEP_ENDIND)
        local btnView = self.m_root:getChildElement("btnView_WndSweep")
        local btnStart = self.m_root:getChildElement("btnStart_WndSweep")
        WZUIButton:luaTo(btnView):setVisible(true)
        WZUIButton:luaTo(btnView):setTouchEnable(true)
        WZUIButton:luaTo(btnStart):setVisible(false)
    else
        WZUIFreeTextBox:luaTo(timerMsg):setShowText(timerNum)     
    end
    if self.m_timeCounter%self.m_stepTime>0 then
       return
    end
    
    if self.m_count > 0 then
        self.m_count  = self.m_count - 1
    else
        self.m_count  = 0
        self.m_starting = false
        self.m_root:disableSchedule()
        return
    end   
    local maxCount = #self.m_exp
    local curCount = maxCount - self.m_count
    local exp = string.format( LocalStrings.SWEEPTIME_EXP , tostring(curCount) ,self.m_exp[curCount])
    local reword = string.format(LocalStrings.SWEEP_GET_SWARD ,self.m_reward[curCount])
    local golds = string.format(LocalStrings.GETREWARD_GOLDS ,self.m_reeardGolds[curCount])
    local words = exp .. golds .. reword
    WndSweep:updateResultPanel(words)
end

--@brief 更新扫荡结果画面调用的函数
--@param
--@note
function WndSweep:updateResultPanel(words)
    local freelistcon = self.m_root:getChildElement("freelistcon_WndSweep")
    if freelistcon==nil then
		return
	end
    freelistcon = WZUIFreeListContainer:luaTo(freelistcon)
	local pItem = nil
    pItem = self:_createPrivateItem(freelistcon, words)

end
--@brief 更新结算面板
function WndSweep:updateBalancePanel()
    
    
end
--@brief 更新扫荡结果画面调用的函数
--@param
--@note
function WndSweep:updateEndingPanel(words)
    local sweepEndingInfo = self.m_root:getChildElement("sweepEndingInfo_WndSweep")
    if sweepEndingInfo==nil then
		return
	end
    sweepEndingInfo = WZUIFreeListContainer:luaTo(sweepEndingInfo)
	local pItem = nil
    pItem = self:_createPrivateItem(sweepEndingInfo, words)
    
end
--@brief 打开购买活力面板
--@param
function WndSweep:onBuyAcitivity(element)
    WZLog("WndSweep:onBuyAcitivity")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    local nMaxVigor = 999 --self.m_data.maxVigor
    
    if self.m_data.vigor >= nMaxVigor then
        MsgBoxManager:showConfirmBox(LocalStrings.CANNOT_BUY_VIGOR, self, self.clickSureBack, nil, nil, true)
        return
    end

    WndBuyActivity:showBuyInterface(1056)
    
end
--@brief 关闭扫荡调用的函数
--@param
--@note
function WndSweep:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    if self.m_starting == true then
        MsgBoxManager:showTipBox(LocalStrings.SWEEPING_NOT_SHUT, nil, nil, nil, nil)
        return
    end
	
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end
--@brief	退出场景时被调用的函数
function WndSweep:onCloseActionCallback(elem,data)
    WZLog("SceneCarton:onCloseActionCallback",elem,data)
    WindowManager:removeWindow(self.m_root, self, true)
    
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建显示私聊频道
--@param	tbl:私聊频道的freelist
--@param	nodeData:一条信息
function WndSweep:_createPrivateItem(tbl, words)
	--创建UI
    local parentSize,pItem, pLblWords = self:_createOneItem(tbl, words)
	local sz1 = pLblWords:getContentSize()

	local itemH = sz1.height
	local itemW = parentSize.width

	local ContentY = itemH
	pItem:setRelativeSize(CCSize(itemW/parentSize.width, itemH/parentSize.height ))
	--内容
	pLblWords:setPosition(ccp(0.07, ContentY))
	tbl:update()
	return pItem
end

--@brief	创建一条信息UI
--@param	tbl:全部频道的freelist
--@param	nodeData:一条信息
function WndSweep:_createOneItem(tbl, words)
	local parentSize = tbl:getContentSize()
	local pItem = WZUIContainer:create()
	--内容
	local pLblWords = WZUIFreeTextBox:create()

    pLblWords:setMaxWidth(676)
	pLblWords:setShowText(words)
    pLblWords:setUseAbsSize(true)
    pLblWords:setAbsContentSize(CCSize(676, 35))
    pLblWords:setAnchorPoint(ccp(0,0.5))
    pLblWords:setRelativePosition(ccp(0,0.5))
	pItem:addChild(pLblWords)
	tbl:pushBack(pItem)
	return parentSize,pItem,pLblWords
end
--@brief	英文适配函数
--@note		英文适配函数
function WndSweep:_adaptLanguage_en()
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCS_WndSweep")):setRelativePosition(ccp(0.228516,0.456894))
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtNeedAc_WndSweep")):setRelativePosition(ccp(0.177,0.366721))
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtLeftAc_WndSweep")):setRelativePosition(ccp(0.256,0.264422))
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDesc_WndSweep")):setFontSize(23)
    local btnImg
    local sName
    for i = 1, 3 do
        sName = "img%dBtnView_WndSweep"
        sName = string.format(sName,i)
        btnImg = self.m_root:getChildElement(sName)
        if btnImg ~= nil then
            btnImg = WZUI9Image:luaTo(btnImg)
            btnImg:setScaleX(1.44)
        end
    end
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtBtnView_WndSweep")):setFontSize(25)
end
--@brief	葡语适配函数
--@note		葡语适配函数
function WndSweep:_adaptLanguage_pt()
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCS_WndSweep")):setRelativePosition(ccp(0.24,0.456894))
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtNeedAc_WndSweep")):setRelativePosition(ccp(0.096,0.366721))
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtLeftAc_WndSweep")):setRelativePosition(ccp(0.13,0.264422))
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDesc_WndSweep")):setFontSize(23)
    local btnImg
    local sName
    for i = 1, 3 do
        sName = "img%dBtnView_WndSweep"
        sName = string.format(sName,i)
        btnImg = self.m_root:getChildElement(sName)
        if btnImg ~= nil then
            btnImg = WZUI9Image:luaTo(btnImg)
            btnImg:setScaleX(1.3)
        end
    end
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtBtnSure_WndSweep")):setFontSize(24)
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtBtnStart1_WndSweep")):setFontSize(24)
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtBtnView_WndSweep")):setFontSize(24)
end
--@brief	越南语适配函数
--@note		越南语适配函数
function WndSweep:_adaptLanguage_vn()
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCS_WndSweep")):setRelativePosition(ccp(0.228516,0.456894))
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtNeedAc_WndSweep")):setRelativePosition(ccp(0.177,0.366721))
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtLeftAc_WndSweep")):setRelativePosition(ccp(0.256,0.264422))
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDesc_WndSweep")):setFontSize(23)
    local btnImg
    local sName
    for i = 1, 3 do
        sName = "img%dBtnView_WndSweep"
        sName = string.format(sName,i)
        btnImg = self.m_root:getChildElement(sName)
        if btnImg ~= nil then
            btnImg = WZUI9Image:luaTo(btnImg)
            btnImg:setScaleX(1.44)
        end
    end
    
    
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtBtnView_WndSweep")):setFontSize(24)
end
-------------------------------------私有方法模块End----------------------------------------
