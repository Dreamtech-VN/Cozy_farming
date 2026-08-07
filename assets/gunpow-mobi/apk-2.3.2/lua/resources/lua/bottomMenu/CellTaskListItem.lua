--CellTaskListItem.lua
--@brief	CellTaskListItem的UI模块
--@date		2015/03/31
--@author	weidong_wu
--@note		任务列表项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTaskListItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTaskListItem:onExit(element)
	self:_unInit()
end
	
--@brief    加载任务信息
function CellTaskListItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellTaskListItem")
    self.m_root:addChild(cellElement,0,1)
    self.m_bIsLoad = true

    self:_update()
    if self.m_bIsTeach then
        WndTask:teach()
    end
    AdaptLanguage(self)
end

--@brief    邀请，分享完成回调
function CellTaskListItem:onFaceBookCallBack(index, mail)
    -- body
    ProtocolProcessorPrefetchCache:send_TASK_AddFaceBookNum(index,mail)
end

--@brief 	监听按钮	
function CellTaskListItem:onCommitEvent( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
    WZLog("CellTaskListItem:onCommitEvent", self.m_nTaskID)

    TeachGroup1.TASK_GO_ID = self.m_nTaskID

    TeachGroup1:endTeachStep({3,3},{3,4},{5,11},{5,12},{7,5},{8,6},{9,1},{20,8},{20,9},{9,5},{9,6},{31,3},{32,2},{32,3},{33,3},{34,3},{35,3},{36,3},{39,3},{40,3},{41,9})

    --do return end
    local tag = element:getTag()
    WZLog("CellTaskListItem:onCommitEvent one", tag)
    if tonumber(tag) == -1 then
    	local status, score = GlobalMethod:HonorPointStatus(1)
	    if status == false then
	        WndHonorPoint:showInterface(score)
	        return
	    end
    end
	if tag == 1 then
		if WndTask:weatherInGetReward() then return end 
        if self.m_tScript then
            if self.m_tScript[1][1] == 999 then
                PassportSdkManager:facebookTask("clickFacebook")
                return 
            elseif self.m_tScript[1][1] == 998 then
                PassportSdkManager:facebookTask("bindFacebook")
                return 
            elseif self.m_tScript[1][1] == 997 then
                if ProjConfig.LANGUAGE == "vn" then
                    DoShareVn()
                else
                    PassportSdkManager:facebookTask("shareFacebook")
                end
                return 
            elseif self.m_tScript[1][1] == 996 then
                if ProjConfig.LANGUAGE == "vn" then
                    DoLinkVn()
                else
                    PassportSdkManager:facebookTask("inviteFacebook")
                end
                return 
            end
        end
        postGotoTaskEvent(self.m_nTaskID)
		if self.m_nMainID == 27 then --公会
        	SceneCommunity:onJumpToCommunity()
		elseif self.m_nMainID == 192 and CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().guildId == 0 then --公会副本
			SceneCommunity:onJumpToCommunity()
		elseif self.m_nMainID > -1 and self.m_nSubID > -1 then
			if self.m_nTaskID == 1120000037 then 
				WndFastGetItems.m_nShopTipItemId = self.m_nSubID
			else
				WndFastGetItems.m_nShopTipItemId = nil 
			end
			JumpByUIId(self.m_nMainID, self.m_nSubID, self.m_nTaskID, 1)
		end
        if self.m_tBack then
            self.m_tBack[2](self.m_tBack[1])
        end
	else 
        --背包已满提示
        WZLog("CellTaskListItem:onCommitEvent GetReward", self.m_nTaskID)
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end

        if WndTask:weatherInGetReward() then return end 
        WndTask:setGetRewardLimit(true)
        
        local tData = {}
        tData.taskType = self.m_nTaskType
        tData.taskId = tostring(self.m_nTaskID)
        tData.subTaskId = "1"
        tData.taskProgr = "1_1"
        PostPlayerEvent:postEvent(PostPlayerEvent.event_task, tData)

        local tData = {}
        tData.taskType = self.m_nTaskType
        tData.taskId = tostring(self.m_nTaskID)
        tData.subTaskId = "1"
        tData.taskProgr = "1_1"
        PostPlayerEvent:postEvent(PostPlayerEvent.event_task, tData)

		local _loadingId = MsgBoxManager:showLoadingBox(nil,WndTask,nil,nil,nil)
		WndTask:setLoadingId(_loadingId)
		postGetTaskRewardEvent(self.m_nTaskID)
		ProtocolProcessorWndTask:send_TASK_GetTaskReward(self.m_nTaskID)
	end
end

--@breif    设置任务类型
function CellTaskListItem:setTaskType( nTaskType )
    self.m_nTaskType = nTaskType
end

--@brief 	设置任务ID
--@param 	nTaskID:界面主ID
function CellTaskListItem:setTaskID(nTaskID)
	self.m_nTaskID = nTaskID
end

--@brief    获取任务ID
function CellTaskListItem:getTaskID()
    return self.m_nTaskID
end

--@brief    当任务是月卡任务时，设置月卡剩余时间
--@param    nLastDays 月卡任务的剩余天数
--@param    nStatus 任务的状态
function CellTaskListItem:setMonthCardLastTimes(nLastDays, nStatus)
    -- body
    if nLastDays == nil or nLastDays == 0 then return end
    local nActualyLeftDay = nLastDays 
    -- if nStatus >= TASKSTATUS_COMPLETED then
    --     nActualyLeftDay = nLastDays - 1
    -- end

    self.m_nActualyLeftDay = nActualyLeftDay    --实际剩余天使

    if self.m_bIsLoad == false then return end

    self:_updateMonthCardLastTimes(nActualyLeftDay)
end


function CellTaskListItem:setCartorNeedId( NID )
    self.CartorNeedId = NID
end
--@brief 	设置按钮文本
--@param 	sText:要显示的按钮文本
function CellTaskListItem:setBtnText(sText)
	self.sText = sText
    if self.m_bIsLoad == false then return end

	for i=1,3 do
		local txtBtn = "txtCommit_"..i.."_CellTaskListItem"
		local txtGetRewardBtn_CellTaskListItem = GetElement(self.m_root,txtBtn,WZUILabelTTF)
		txtGetRewardBtn_CellTaskListItem:setText(sText)
	end
end
--@brief 	设置按钮跳转界面ID
--@param 	nMainID:界面主ID
--@param 	nSubID:界面子ID
function CellTaskListItem:setBtnJumpID(nMainID, nSubID)
	self.m_nMainID = nMainID
	self.m_nSubID = nSubID
    if self.m_bIsLoad == false then return end

    local btnUISwitch_CellTaskListItem = GetElement(self.m_root,"btnUISwitch_CellTaskListItem",WZUIButton)
    if btnUISwitch_CellTaskListItem ~= nil then
        if 0==nMainID and 0 == nSubID then
            btnUISwitch_CellTaskListItem:setTouchEnable(false)
        else
            btnUISwitch_CellTaskListItem:setTouchEnable(true)
        end
    end
end


--@brief    添加点击事件的id
function CellTaskListItem:addCellItemId(n_subIndex, nCellId )
    local _KeyString = ""
    if 1 == n_subIndex then
        _KeyString = "MainTask_subItem_Key_"..CacheCenter:getPlayerInfo().id
    elseif 2 == n_subIndex then
        _KeyString = "BranchTask_subItem_Key_"..CacheCenter:getPlayerInfo().id
    elseif 3 == n_subIndex then 
    	_KeyString = "DailyTask_subItem_key_"..CacheCenter:getPlayerInfo().id
    end

    local cellId_stringArray =  CCUserDefault:sharedUserDefault():getStringForKey(_KeyString)
    if cellId_stringArray == nil or cellId_stringArray == "" then
        local idString = string.format("%d-",nCellId)
        CCUserDefault:sharedUserDefault():setStringForKey(_KeyString,idString)
        CCUserDefault:sharedUserDefault():flush()
    else 
        local idString = string.format("%s%d-",cellId_stringArray,nCellId)
        CCUserDefault:sharedUserDefault():setStringForKey(_KeyString,idString)
        CCUserDefault:sharedUserDefault():flush()
    end
end

--@brief    检测id是否在点击过
function CellTaskListItem:checkItemIsClickedById( nSubIndex,nTaskId )
    local idString = ""
    if 1 == nSubIndex then
        idString =  CCUserDefault:sharedUserDefault():getStringForKey("MainTask_subItem_Key_"..CacheCenter:getPlayerInfo().id)
    elseif 2 == nSubIndex then
        idString =  CCUserDefault:sharedUserDefault():getStringForKey("BranchTask_subItem_Key_"..CacheCenter:getPlayerInfo().id)
    elseif 3 == nSubIndex then 
    	idString =  CCUserDefault:sharedUserDefault():getStringForKey("DailyTask_subItem_key_"..CacheCenter:getPlayerInfo().id)
    end
    --WZLog("CellTaskItemPanel:checkItemIsClickedById = "..idString)
    local bRet = false
    if idString == nil or idString == "" then
        return bRet
    end

    local IdMap = WndTask:Split(idString,"-")
    
    local count = #IdMap

    for i=1,count do
        if nTaskId == tonumber(IdMap[i]) then
            bRet = true
            break
        end
    end
    return bRet
end


--@brief 	设置跳转后的窗口关闭回调
function CellTaskListItem:setFuncCallBack(tCell ,backFun  )
	if tCell and backFun then
		self.m_tBack = {}
		self.m_tBack[1] = tCell
		self.m_tBack[2] = backFun
	end
end

--@brief    设置任务状态
function CellTaskListItem:setTaskStatus( nState, txtTaskTarget)
    --@brief    设置任务状态
    if txtTaskTarget then
        self.m_txtTaskTarget = txtTaskTarget
    end
    self.m_txtTempTarget = txtTaskTarget
    self.m_nTempState = nState
    if self.m_bIsLoad == false then return end

    self.m_tTaskState = nState
    self:_setTaskState( nState )
    local txtTaskTarget_CellTaskListItem = GetElement(self.m_root,"txtTaskTarget_CellTaskListItem",WZUILabelTTF)
    txtTaskTarget_CellTaskListItem:setText(self.m_txtTaskTarget)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新界面 
function CellTaskListItem:_update(  )
	if self.m_nTaskID >0 then 
		local IsClick = self:checkItemIsClickedById(self.m_nTaskType,self.m_nTaskID)
		if not IsClick then 
			self:addCellItemId(self.m_nTaskType,self.m_nTaskID) 
		end 
	end
	--设置显示的图标
	self:_CheckIconImg(self.m_imgIconType)
	--设置任务的标题
	local txtTaskTitle_CellTaskListItem = GetElement(self.m_root,"txtTaskTitle_CellTaskListItem",WZUILabelTTF)
	if txtTaskTitle_CellTaskListItem ~= nil then 
		txtTaskTitle_CellTaskListItem:setText(self.m_tTaskTitle)
	end 

	--设置任务描述
	local DescArrays = SplitStringWithSeparator(self.m_tTaskDesc,"#")
	local pos_x = 0
	local wordCount = 0
	local txtTaskDesc_CellTaskListItem = GetElement(self.m_root,"txtTaskDesc_CellTaskListItem",WZUILabelTTF)
	if #DescArrays > 1 then 
		local point = txtTaskDesc_CellTaskListItem:getRelativePosition()
		--WZLog("======",point.x,point.y)
		for i=1,#DescArrays do
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
		if txtTaskDesc_CellTaskListItem ~= nil then 
			txtTaskDesc_CellTaskListItem:setText(self.m_tTaskDesc)
		end 
	end 

	--设置任务奖励信息
	for i=1,#self.m_tRewardData do
		local conRewardItem_TaskListItem = GetElement(self.m_root,"conRewardItem_"..i.."_TaskListItem",WZUIContainer)
		if conRewardItem_TaskListItem == nil then
			break
		end
		conRewardItem_TaskListItem:setVisible(true)
		local txtItemNum_CellTaskListItem = GetElement(self.m_root,"txtItemNum_"..i.."_CellTaskListItem",WZUILabelTTF)
		txtItemNum_CellTaskListItem:setText(self.m_tRewardData[i].ItemNum)
		local ItemIcon_TaskListItem = GetElement(self.m_root,"ItemIcon_"..i.."_TaskListItem",WZUIImage)
		ItemIcon_TaskListItem:setFile(self.m_tRewardData[i].icon)
	end
	--设置任务状态
	self:_setTaskState(self.m_tTaskState)

    self:_callOtherFunc()
end

function CellTaskListItem:onClickTips(element)
	-- body
	WZLog("点击item出现弹窗")
	if self.m_tRewardData == nil then return end
	local tag = element:getTag()
	WZLog("点击item",tag,#self.m_tRewardData)
	if tag > #self.m_tRewardData then return end

	local key = "id_"..self.m_tRewardData[tag].id
	local tData = CopyTable(GDatatab_item[key])
    -- WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(element,WndTask.m_root,1,tData,false)
end

--@brief    
function CellTaskListItem:_callOtherFunc()
    -- body
    self:setBtnJumpID(self.m_nMainID, self.m_nSubID)
    self:setBtnText(self.sText)
    self:_updateMonthCardLastTimes(self.m_nActualyLeftDay)
end


--@brief 	判断显示的图标
function CellTaskListItem:_CheckIconImg( icon )
	local imgItemIcon_CellTaskListItem = GetElement(self.m_root,"imgItemIcon_CellTaskListItem",WZUIImage)
	imgItemIcon_CellTaskListItem:setFile("ui/"..icon)	
end

--@brief  	设置任务状态
--[[
TASKSTATUS_DOING = 0 --进行中
TASKSTATUS_TOSUBMIT = 1 --已完成，待提交
TASKSTATUS_COMPLETED = 2 --已提交完成
TASKSTATUS_STALE = 3 --已过期的任务
]]
function CellTaskListItem:_setTaskState( nState )
	if nState == TASKSTATUS_DOING then 
		local conUITaskBtn_CellTaskListItem = GetElement(self.m_root,"conUITaskBtn_CellTaskListItem",WZUIContainer)
		conUITaskBtn_CellTaskListItem:setVisible(true)
		local conBtnTaskState_CellTaskListItem = GetElement(self.m_root,"conBtnTaskState_CellTaskListItem",WZUIContainer)
		conBtnTaskState_CellTaskListItem:setVisible(false)
		local txtTaskFinish_CellTaskListItem = GetElement(self.m_root,"txtTaskFinish_CellTaskListItem",WZUILabelTTF)
		if txtTaskFinish_CellTaskListItem ~= nil then 
			txtTaskFinish_CellTaskListItem:setVisible(false)
		end 
		local btnUISwitch_CellTaskListItem = GetElement(self.m_root,"btnUISwitch_CellTaskListItem",WZUIButton)
		if btnUISwitch_CellTaskListItem ~= nil then 
			btnUISwitch_CellTaskListItem:setVisible(true)
			for i=1,3 do
				local txtBtn = "txtUISwitch_"..i.."_CellTaskListItem"
				local txtDoTaskBtn_CellTaskListItem = GetElement(self.m_root,txtBtn,WZUILabelTTF)
				txtDoTaskBtn_CellTaskListItem:setText(self.sText)
				if i==3 then 
					txtDoTaskBtn_CellTaskListItem:setStrokeSize(4)
                    txtDoTaskBtn_CellTaskListItem:setEnableStroke(true)
                    txtDoTaskBtn_CellTaskListItem:setStrokeColor(GlobalMethod:ccc3(79,60,48))
					txtDoTaskBtn_CellTaskListItem:setColor(GlobalMethod:ccc3(255,255,255))
				end 
				if txtDoTaskBtn_CellTaskListItem:getText() == LocalStrings.LEAGUE_REWARD_TEXT9 then
					txtDoTaskBtn_CellTaskListItem:setScale(0.8)
				end
			end
		end 
		local txtTaskTarget_CellTaskListItem = GetElement(self.m_root,"txtTaskTarget_CellTaskListItem",WZUILabelTTF)
		txtTaskTarget_CellTaskListItem:setVisible(true)
		txtTaskTarget_CellTaskListItem:setText(self.m_txtTaskTarget)
	elseif nState == TASKSTATUS_TOSUBMIT then 
		local conBtnTaskState_CellTaskListItem = GetElement(self.m_root,"conBtnTaskState_CellTaskListItem",WZUIContainer)
		conBtnTaskState_CellTaskListItem:setVisible(true)
		local txtTaskTarget_CellTaskListItem = GetElement(self.m_root,"txtTaskTarget_CellTaskListItem",WZUILabelTTF)
		txtTaskTarget_CellTaskListItem:setVisible(false)
		local conUITaskBtn_CellTaskListItem = GetElement(self.m_root,"conUITaskBtn_CellTaskListItem",WZUIContainer)
		conUITaskBtn_CellTaskListItem:setVisible(false)
		local txtTaskFinish_CellTaskListItem = GetElement(self.m_root,"txtTaskFinish_CellTaskListItem",WZUILabelTTF)
		if txtTaskFinish_CellTaskListItem ~= nil then 
			txtTaskFinish_CellTaskListItem:setVisible(false)
		end 
		local btnCommit_CellTaskListItem = GetElement(self.m_root,"btnCommit_CellTaskListItem",WZUIButton)
		if btnCommit_CellTaskListItem ~= nil then 
			btnCommit_CellTaskListItem:setVisible(true)
			for i=1,3 do
				local txtBtn = "txtCommit_"..i.."_CellTaskListItem"
				local txtGetRewardBtn_CellTaskListItem = GetElement(self.m_root,txtBtn,WZUILabelTTF)
				txtGetRewardBtn_CellTaskListItem:setText(LocalStrings.GET_REWARD)
			end
		end 
	elseif nState == TASKSTATUS_COMPLETED then 
		local txtTaskFinish_CellTaskListItem = GetElement(self.m_root,"txtTaskFinish_CellTaskListItem",WZUILabelTTF)
		if txtTaskFinish_CellTaskListItem ~= nil then 
			txtTaskFinish_CellTaskListItem:setVisible(true)
			txtTaskFinish_CellTaskListItem:setText(LocalStrings.ACTIVE_FINISH)
		end 
		local btnCommit_CellTaskListItem = GetElement(self.m_root,"btnCommit_CellTaskListItem",WZUIButton)
		if btnCommit_CellTaskListItem ~= nil then 
			btnCommit_CellTaskListItem:setVisible(false)
		end 
		local txtTaskTarget_CellTaskListItem = GetElement(self.m_root,"txtTaskTarget_CellTaskListItem",WZUILabelTTF)
		txtTaskTarget_CellTaskListItem:setVisible(false)
		local conUITaskBtn_CellTaskListItem = GetElement(self.m_root,"conUITaskBtn_CellTaskListItem",WZUIContainer)
		conUITaskBtn_CellTaskListItem:setVisible(false)
	end 
end

--@note 	任务富文本描述
function CellTaskListItem:_setDescRichText( str,color,pos)
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

--@note     显示剩余时间
function CellTaskListItem:_updateMonthCardLastTimes(nLastDays)
    -- body
    if nLastDays == nil or nLastDays == 0 then return end

    if nLastDays == nil or nLastDays == 0 then 
        WZLog("******* 剩余月卡天数为 0000 *******")
        local txtLastDay = GetElement(self.m_root, "txtLastDay_CellTaskListItem", WZUILabelTTF)
        txtLastDay:setVisible(false)
        return 
    end

    if nLastDays > 0 then
        local txtLastDay = GetElement(self.m_root, "txtLastDay_CellTaskListItem", WZUILabelTTF)
        txtLastDay:setVisible(true)
        txtLastDay:setText("(" .. LocalStrings.SHOP_GOODSSHEGN .. ":" .. tostring(nLastDays) .. LocalStrings.DAY .. ")")
        --日常任务中月卡
        local nTask_sub_type = GDatatab_task["id_"..self.m_nTaskID].sub_type
        if nTask_sub_type == 30014 then
            WZLog("日常任务中的月卡")
	    	--开放订阅月卡功能后，状态为已订阅且订阅在有效期之内的，仅显示订阅中，不显示实际剩余时间；订阅月卡每天加一天不是一次加30天
	    	local isCanBuy = checkIsCanBuyIOSAutoRenewalSubscription()
		    local txtSubscription = ""
		    if LocalStrings.SUBSCRIPTIONING then
		        txtSubscription = LocalStrings.SUBSCRIPTIONING
		    end
		    if isCanBuy == -1 then
		    	txtLastDay:setText("(" .. txtSubscription .. ")")
		    end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Start--------------------------------------
--@brief 英文适配函数
--@note  英文适配
function CellTaskListItem:_adaptLanguage_en()
	WZLog("CellTaskListItem:_adaptLanguage_en")
    for i=1,3 do
		local txtUISwitch = GetElement(self.m_root, "txtUISwitch_"..i.."_CellTaskListItem", WZUILabelTTF)
    	if txtUISwitch then
        	txtUISwitch:setScale(0.78)
    	end
	end

    GetElement(self.m_root, "txtTaskTitle_CellTaskListItem", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.18,0.81))
    local txtTaskDesc = GetElement(self.m_root, "txtTaskDesc_CellTaskListItem", WZUILabelTTF)
    if txtTaskDesc then
    	txtTaskDesc:setRelativePosition(GlobalMethod:ccp(0.18,0.57))
    	txtTaskDesc:setDimensions(GlobalMethod:CCSize(440,0))
    	txtTaskDesc:setScale(0.8)
    end
    local txtLastDay = GetElement(self.m_root,"txtLastDay_CellTaskListItem",WZUILabelTTF)
    txtLastDay:setFontSize(16)
    txtLastDay:setRelativePosition(GlobalMethod:ccp(0.78,0.552673))

    for i=1,3 do
		local txtCommit = GetElement(self.m_root,"txtCommit_"..i.."_CellTaskListItem", WZUILabelTTF)
    	if txtCommit then
        	txtCommit:setScale(0.8)
    	end
	end
end

function CellTaskListItem:_adaptLanguage_pt(  )
	for i=1,3 do
		local txtUISwitch = GetElement(self.m_root, "txtUISwitch_"..i.."_CellTaskListItem", WZUILabelTTF)
    	if txtUISwitch then
        	txtUISwitch:setScale(0.8)
    	end
	end

    GetElement(self.m_root, "txtTaskTitle_CellTaskListItem", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.18,0.81))
    local txtTaskDesc = GetElement(self.m_root, "txtTaskDesc_CellTaskListItem", WZUILabelTTF)
    if txtTaskDesc then
    	txtTaskDesc:setRelativePosition(GlobalMethod:ccp(0.18,0.57))
    	txtTaskDesc:setDimensions(GlobalMethod:CCSize(400,0))
    	txtTaskDesc:setScale(0.8)
    end
    local txtLastDay = GetElement(self.m_root, "txtLastDay_CellTaskListItem", WZUILabelTTF)
    txtLastDay:setScale(0.7)
    txtLastDay:setRelativePosition(GlobalMethod:ccp(0.797321,0.552673))
end

--@brief 越南适配函数
function CellTaskListItem:_adaptLanguage_vn()
    WZLog("CellTaskListItem:_adaptLanguage_vn")
    -- local txtTaskDesc = GetElement(self.m_root, "txtTaskDesc_CellTaskListItem", WZUILabelTTF)
    -- if txtTaskDesc then
        -- txtTaskDesc:setScale(0.8)
        -- txtTaskDesc:setRelativePosition(GlobalMethod:ccp(0.18,0.57))
    	--txtTaskDesc:setDimensions(GlobalMethod:CCSize(380,0))
    -- end
    GetElement(self.m_root, "txtTaskTitle_CellTaskListItem", WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root, "txtCommit_1_CellTaskListItem", WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root, "txtCommit_2_CellTaskListItem", WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root, "txtCommit_3_CellTaskListItem", WZUILabelTTF):setScale(0.8)
end

function CellTaskListItem:_adaptLanguage_es(  )
	for i=1,3 do
		local txtUISwitch = GetElement(self.m_root, "txtUISwitch_"..i.."_CellTaskListItem", WZUILabelTTF)
    	if txtUISwitch then
        	txtUISwitch:setScale(0.7)
    	end
	end

	for i=1,3 do
		local txtCommit = GetElement(self.m_root,"txtCommit_"..i.."_CellTaskListItem", WZUILabelTTF)
    	if txtCommit then
        	txtCommit:setScale(0.8)
    	end
	end

    GetElement(self.m_root, "txtTaskTitle_CellTaskListItem", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.18,0.81))
    local txtTaskDesc = GetElement(self.m_root, "txtTaskDesc_CellTaskListItem", WZUILabelTTF)
    if txtTaskDesc then
    	txtTaskDesc:setRelativePosition(GlobalMethod:ccp(0.18,0.57))
    	txtTaskDesc:setDimensions(GlobalMethod:CCSize(440,0))
    	txtTaskDesc:setScale(0.8)
    end

    local txtLastDay = GetElement(self.m_root, "txtLastDay_CellTaskListItem", WZUILabelTTF)
    txtLastDay:setScale(0.7)
    txtLastDay:setRelativePosition(GlobalMethod:ccp(0.797321,0.552673))
    GetElement(self.m_root,"txtTaskFinish_CellTaskListItem",WZUILabelTTF):setScale(0.7)
end

function CellTaskListItem:_adaptLanguage_tr(  )
    for i=1,3 do
        local txtUISwitch = GetElement(self.m_root, "txtUISwitch_"..i.."_CellTaskListItem", WZUILabelTTF)
        if txtUISwitch then
            txtUISwitch:setScale(0.9)
            txtUISwitch:setDimensions(GlobalMethod:CCSize(130,0))
        end
    end
    
    local txtLastDay = GetElement(self.m_root,"txtLastDay_CellTaskListItem",WZUILabelTTF)
    txtLastDay:setFontSize(16)
    txtLastDay:setRelativePosition(GlobalMethod:ccp(0.78,0.552673))

    local txtTaskDesc = GetElement(self.m_root, "txtTaskDesc_CellTaskListItem", WZUILabelTTF)
    if txtTaskDesc then
    	txtTaskDesc:setRelativePosition(GlobalMethod:ccp(0.18,0.57))
    	txtTaskDesc:setDimensions(GlobalMethod:CCSize(440,0))
    	txtTaskDesc:setScale(0.8)
    end
end

function CellTaskListItem:_adaptLanguage_th()
    GetElement(self.m_root, "txtTaskTitle_CellTaskListItem", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.18,0.81))
    local txtTaskDesc = GetElement(self.m_root, "txtTaskDesc_CellTaskListItem", WZUILabelTTF)
    if txtTaskDesc then
    	txtTaskDesc:setRelativePosition(GlobalMethod:ccp(0.18,0.57))
    	txtTaskDesc:setDimensions(GlobalMethod:CCSize(440,0))
    	txtTaskDesc:setScale(0.8)
    end
end
-------------------------------------语言适配模块End----------------------------------------