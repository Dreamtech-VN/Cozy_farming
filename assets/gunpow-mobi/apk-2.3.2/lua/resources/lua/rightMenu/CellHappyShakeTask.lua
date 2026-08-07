--CellHappyShakeTask.lua
--@brief	CellHappyShakeTask的UI模块
--@date		2020/05/28
--@author	XTX
--@note		全民摇摇乐任务Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellHappyShakeTask:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellHappyShakeTask:onExit(element)
	self:_unInit()
end

--@brief    加载任务信息
function CellHappyShakeTask:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellHappyShakeTask")
    self.m_root:addChild(cellElement,0,1)
    self.m_bIsLoad = true

    self:_update()
end

--@brief 	监听按钮	
function CellHappyShakeTask:onCommitEvent( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WZLog("CellHappyShakeTask:onCommitEvent", self.m_nTaskID)
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    
    ProtocolProcessorNewActivity:send_ACTIVITY2_PokerTaskRewardReward(self.m_nTaskID)
end

--@brief 	设置任务ID
--@param 	nTaskID:界面主ID
function CellHappyShakeTask:setTaskID(nTaskID)
	self.m_nTaskID = nTaskID
end

--@brief    获取任务ID
function CellHappyShakeTask:getTaskID()
    return self.m_nTaskID
end

--@brief 	设置按钮文本
--@param 	sText:要显示的按钮文本
function CellHappyShakeTask:setBtnText(sText)
	self.sText = sText
    if self.m_bIsLoad == false then return end

	for i=1,3 do
		local txtBtn = "txtCommit_"..i.."_CellHappyShakeTask"
		local txtGetRewardBtn_CellHappyShakeTask = GetElement(self.m_root,txtBtn,WZUILabelTTF)
		txtGetRewardBtn_CellHappyShakeTask:setText(sText)
	end
end

--@brief 	设置跳转后的窗口关闭回调
function CellHappyShakeTask:setFuncCallBack(tCell ,backFun  )
	if tCell and backFun then
		self.m_tBack = {}
		self.m_tBack[1] = tCell
		self.m_tBack[2] = backFun
	end
end

--@brief    设置任务状态
function CellHappyShakeTask:setTaskStatus( nState, txtTaskTarget)
    --@brief    设置任务状态
    if txtTaskTarget then
        self.m_txtTaskTarget = txtTaskTarget
    end
    self.m_txtTempTarget = txtTaskTarget
    self.m_nTempState = nState
    if self.m_bIsLoad == false then return end

    self.m_tTaskState = nState
    self:_setTaskState( nState )
    local txtTaskTarget_CellHappyShakeTask = GetElement(self.m_root,"txtTaskTarget_CellHappyShakeTask",WZUILabelTTF)
    txtTaskTarget_CellHappyShakeTask:setText(self.m_txtTaskTarget)
end

--@brief 	点击奖励图标回调
function CellHappyShakeTask:onClickItem(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local nTag = element:getTag()
	WZLog("CellHappyShakeTask:onClickItem", nTag)
	local rewardData = self.m_tRewardData[nTag]
	local key = "id_" .. rewardData.id
	local itemInfo = {id = rewardData.id, name=GDatatab_item[key].name, icon=GDatatab_item[key].icon, lastTime = rewardData.ItemNum, quality=GDatatab_item[key].quality, basicInfo=CopyTable(GDatatab_item[key])}
	WndItemInfo:showInfo(element, WndHappyShakeTask.m_root, 1, itemInfo, false, nil, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新界面 
function CellHappyShakeTask:_update(  )
	--设置任务的标题
	local txtTaskTitle = GetElement(self.m_root,"txtTaskTitle_CellHappyShakeTask",WZUILabelTTF)
	if txtTaskTitle ~= nil then 
		txtTaskTitle:setText(self.m_tTaskTitle)
	end 

	--设置任务描述
	local DescArrays = SplitStringWithSeparator(self.m_tTaskDesc,"#")
	local pos_x = 0
	local wordCount = 0
	local txtTaskDesc = GetElement(self.m_root,"txtTaskDesc_CellHappyShakeTask",WZUILabelTTF)
	local ftxtTaskDesc = GetElement(self.m_root,"ftxtTaskDesc_CellHappyShakeTask", WZUIFreeTextBox)
	if #DescArrays > 1 then 
		local point = txtTaskDesc:getRelativePosition()
		--WZLog("======",point.x,point.y)
		for i = 1, #DescArrays do
			if string.find(DescArrays[i],"(.*)=(.*)") ~= nil then 
				local start_pos,end_pos,ColorLabel,Color = string.find(DescArrays[i],"(.*)=(.*)")
				pos_x = point.x+((20*wordCount)/713)
				local colorArrays = SplitStringWithSeparator(Color,",")
				local count = self:_setDescRichText(ColorLabel,GlobalMethod:ccc3(tonumber(colorArrays[1]),tonumber(colorArrays[2]),tonumber(colorArrays[3])),GlobalMethod:ccp(pos_x,point.y))
				wordCount = wordCount + count
			else 
				pos_x = point.x+((20*wordCount)/713)
				local count = self:_setDescRichText(DescArrays[i],GlobalMethod:ccc3(132,66,29),GlobalMethod:ccp(pos_x,point.y))
				wordCount = wordCount + count
			end 
		end
	else 
		if string.find(self.m_tTaskDesc,"<T") == nil then
			if txtTaskDesc ~= nil then 
				txtTaskDesc:setText(self.m_tTaskDesc)
			end 
		else
			if ftxtTaskDesc ~= nil then 
				ftxtTaskDesc:setShowText(self.m_tTaskDesc)
			end 
		end
	end 

	--设置任务奖励信息
	for i = 1, #self.m_tRewardData do
		local conRewardItem = GetElement(self.m_root,"conRewardItem_"..i.."_CellHappyShakeTask",WZUIContainer)
		if conRewardItem == nil then
			break
		end
		conRewardItem:setVisible(true)
		local txtItemNum = GetElement(self.m_root,"txtItemNum_"..i.."_CellHappyShakeTask",WZUILabelTTF)
		txtItemNum:setText(self.m_tRewardData[i].ItemNum)

		local ItemIcon = GetElement(self.m_root,"ItemIcon_"..i.."_CellHappyShakeTask",WZUIImage)
		ItemIcon:setFile(self.m_tRewardData[i].icon)
	end
	--设置任务状态
	self:_setTaskState(self.m_tTaskState)

    self:_callOtherFunc()
end

--@brief    
function CellHappyShakeTask:_callOtherFunc()
    -- body
    self:setBtnText(self.sText)
end

--@brief  	设置任务状态
function CellHappyShakeTask:_setTaskState( nState )
	local txtTaskFinish = GetElement(self.m_root,"txtTaskFinish_CellHappyShakeTask",WZUILabelTTF)
	local txtTaskTarget = GetElement(self.m_root,"txtTaskTarget_CellHappyShakeTask",WZUILabelTTF)
	local btnCommit = GetElement(self.m_root,"btnCommit_CellHappyShakeTask",WZUIButton)
	local conBtnTaskState = GetElement(self.m_root,"conBtnTaskState_CellHappyShakeTask",WZUIContainer)

	if nState == TASKSTATUS_DOING then 
		local conUITaskBtn_CellHappyShakeTask = GetElement(self.m_root,"conUITaskBtn_CellHappyShakeTask",WZUIContainer)
		conUITaskBtn_CellHappyShakeTask:setVisible(true)
		conBtnTaskState:setVisible(false)
		if txtTaskFinish ~= nil then 
			txtTaskFinish:setVisible(false)
		end 
		local btnUISwitch = GetElement(self.m_root,"btnUISwitch_CellHappyShakeTask",WZUIButton)
		if btnUISwitch ~= nil then 
			btnUISwitch:setVisible(true)
			btnUISwitch:setTouchEnable(false)
			for i=1,3 do
				local txtBtn = "txtUISwitch_"..i.."_CellHappyShakeTask"
				local txtDoTaskBtn = GetElement(self.m_root,txtBtn,WZUILabelTTF)
				txtDoTaskBtn:setText(self.sText)
				if i==3 then 
					txtDoTaskBtn:setStrokeSize(4)
                    txtDoTaskBtn:setEnableStroke(true)
                    txtDoTaskBtn:setStrokeColor(GlobalMethod:ccc3(79,60,48))
					txtDoTaskBtn:setColor(GlobalMethod:ccc3(255,255,255))
				end 
				if txtDoTaskBtn:getText() == LocalStrings.LEAGUE_REWARD_TEXT9 then
					txtDoTaskBtn:setScale(0.8)
				end
			end
		end 
		txtTaskTarget:setVisible(true)
		txtTaskTarget:setText(self.m_txtTaskTarget)
	elseif nState == TASKSTATUS_TOSUBMIT then 
		conBtnTaskState:setVisible(true)
		txtTaskTarget:setVisible(false)
		local conUITaskBtn_CellHappyShakeTask = GetElement(self.m_root,"conUITaskBtn_CellHappyShakeTask",WZUIContainer)
		conUITaskBtn_CellHappyShakeTask:setVisible(false)
		if txtTaskFinish ~= nil then 
			txtTaskFinish:setVisible(false)
		end 
		
		if btnCommit ~= nil then 
			btnCommit:setVisible(true)
			for i=1,3 do
				local txtBtn = "txtCommit_"..i.."_CellHappyShakeTask"
				local txtGetRewardBtn_CellHappyShakeTask = GetElement(self.m_root,txtBtn,WZUILabelTTF)
				txtGetRewardBtn_CellHappyShakeTask:setText(LocalStrings.GET_REWARD)
			end
		end 
	elseif nState == TASKSTATUS_COMPLETED then 
		if txtTaskFinish ~= nil then 
			txtTaskFinish:setVisible(true)
			txtTaskFinish:setText(LocalStrings.ACTIVE_FINISH)
		end 
		if btnCommit ~= nil then 
			btnCommit:setVisible(false)
		end 
		txtTaskTarget:setVisible(false)
		local conUITaskBtn_CellHappyShakeTask = GetElement(self.m_root,"conUITaskBtn_CellHappyShakeTask",WZUIContainer)
		conUITaskBtn_CellHappyShakeTask:setVisible(false)
	end 
end

--@note 	任务富文本描述
function CellHappyShakeTask:_setDescRichText( str,color,pos)
	local txt_label = WZUILabelTTF:create()
	--txt_label = WZUILabelTTF:luaTo(txt_label)
	txt_label:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txt_label:setFontSize(20)
	txt_label:setColor(color)
	txt_label:setText(str)
	txt_label:setRelativePosition(pos)
	local TaskDescContainer_Obj = GetElement(self.m_root,"TaskDescContainer_Obj",WZUIContainer)
	TaskDescContainer_Obj:addChild(txt_label)
	return txt_label:getWordCount()
end

-------------------------------------私有方法模块End----------------------------------------
