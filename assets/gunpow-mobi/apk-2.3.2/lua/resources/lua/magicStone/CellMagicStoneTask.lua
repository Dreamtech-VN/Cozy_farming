--CellMagicStoneTask.lua
--@brief	CellMagicStoneTask的UI模块
--@date		2019/10/24
--@author	Tianxiang_Xu
--@note		幻石系统-任务


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMagicStoneTask:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMagicStoneTask:onExit(element)
	self:_unInit()
end

--@brief    加载任务信息
function CellMagicStoneTask:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellMagicStoneTask")
    self.m_root:addChild(cellElement,0,1)
    self.m_bIsLoad = true

    self:_update()
	AdaptLanguage(self)
end

--@brief 	监听按钮	
function CellMagicStoneTask:onCommitEvent( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WZLog("CellMagicStoneTask:onCommitEvent")
    local tag = element:getTag()
	if tag == 1 then
		if self.m_nMainID == 27 then --公会
        	SceneCommunity:onJumpToCommunity()
		elseif self.m_nMainID > -1 and self.m_nSubID > -1 then
			JumpByUIId(self.m_nMainID, self.m_nSubID)
		end
        
        WndMagicStone:closeWin()
	else 
        --背包已满提示
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        
        WZLog("CellMagicStoneTask:onCommitEvent GetReward")
		ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetReward(3, self.m_nTaskId)
	end
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function CellMagicStoneTask:onClickListItem(tItem, nTag, tData)
    WZLog("CellMagicStoneTask:onClickListItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root, WndMagicStone.m_root, 1, tData, false)
end

--@brief 	设置按钮文本
--@param 	sText:要显示的按钮文本
function CellMagicStoneTask:setBtnText(sText)
	self.sText = sText
    if self.m_bIsLoad == false then return end

	for i=1,3 do
		local txtBtn = "txtCommit_"..i.."_CellMagicStoneTask"
		local txtGetRewardBtn = GetElement(self.m_root, txtBtn, WZUILabelTTF)
		txtGetRewardBtn:setText(sText)
	end
end

--@brief    设置任务状态
function CellMagicStoneTask:setTaskStatus( nState, txtTaskTarget)
    --@brief    设置任务状态
    if txtTaskTarget then
        self.m_txtTaskTarget = txtTaskTarget
    end
    self.m_txtTempTarget = txtTaskTarget
    self.m_nTempState = nState
    if self.m_bIsLoad == false then return end

    self.m_tTaskState = nState
    self:_setTaskState( nState )
    local txtTaskTargetNode = GetElement(self.m_root,"txtTaskTarget_CellMagicStoneTask",WZUILabelTTF)
    txtTaskTargetNode:setText(self.m_txtTaskTarget)
end

--@brief 	设置按钮跳转界面ID
--@param 	nMainID:界面主ID
--@param 	nSubID:界面子ID
function CellMagicStoneTask:setBtnJumpID(nMainID, nSubID)
	self.m_nMainID = nMainID
	self.m_nSubID = nSubID
    if self.m_bIsLoad == false then return end

    local btnUISwitch = GetElement(self.m_root, "btnUISwitch_CellMagicStoneTask", WZUIButton)
    if btnUISwitch ~= nil then
        if 0 == nMainID and 0 == nSubID then
            btnUISwitch:setTouchEnable(false)
        else
            btnUISwitch:setTouchEnable(true)
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新界面 
function CellMagicStoneTask:_update()
	--设置显示的图标
	self:_CheckIconImg()
	--设置任务的标题
	local txtTaskTitle = GetElement(self.m_root,"txtTaskTitle_CellMagicStoneTask",WZUILabelTTF)
	if txtTaskTitle ~= nil then 
		txtTaskTitle:setText(self.m_tTaskTitle)
	end 

	--设置任务描述
	local txtTaskDesc = GetElement(self.m_root, "txtTaskDesc_CellMagicStoneTask", WZUILabelTTF)
	if txtTaskDesc ~= nil then 
		txtTaskDesc:setText(self.m_tTaskDesc)
	end 

	--达成次数
	local txtTaskAchieTime = GetElement(self.m_root, "txtTaskAchieTime_CellMagicStoneTask", WZUILabelTTF)
	if txtTaskAchieTime then 
		txtTaskAchieTime:setText(string.format(LocalStrings.MAGIC_STONE_TEXT20, self.m_nAchieTimes, self.m_nMaxAchieTimes))
	end

	--设置任务状态
	self:_setTaskState(self.m_tTaskState)

    self:_callOtherFunc()
end

--@brief    
function CellMagicStoneTask:_callOtherFunc()
    -- body
    self:setBtnJumpID(self.m_nMainID, self.m_nSubID)
    self:setBtnText(self.sText)
end


--@brief 	判断显示的图标
function CellMagicStoneTask:_CheckIconImg( icon )
	local conItemIcon1 = GetElement(self.m_root, "conItemIcon1_CellMagicStoneTask", WZUIContainer)
	conItemIcon1:removeAllChildrenWithCleanup(true)
	local element, tCell = CellGoodItem:createElement()
	if element and tCell then 
		tCell:setCellGoodLocalId(self.m_tRewardData[1][1], self.m_tRewardData[1][2], 4)
		tCell:setItemClickFun(self, self.onClickListItem)
		conItemIcon1:addChild(element)
	end

	local conItemIcon2 = GetElement(self.m_root, "conItemIcon2_CellMagicStoneTask", WZUIContainer)
	conItemIcon2:removeAllChildrenWithCleanup(true)
	conItemIcon2:setVisible(false)
	local txtTaskTitle = GetElement(self.m_root,"txtTaskTitle_CellMagicStoneTask",WZUILabelTTF)
	local txtTaskDesc = GetElement(self.m_root,"txtTaskDesc_CellMagicStoneTask",WZUILabelTTF)
	txtTaskTitle:setRelativePosition(GlobalMethod:ccp(0.16,0.64))
	txtTaskDesc:setRelativePosition(GlobalMethod:ccp(0.16,0.44))
	if self.m_tRewardData[2] and self.m_tRewardData[2][1] and self.m_tRewardData[2][2] then
		conItemIcon2:setVisible(true)
		local element, tCell = CellGoodItem:createElement()
		tCell:setCellGoodLocalId(self.m_tRewardData[2][1], self.m_tRewardData[2][2], 4)
		tCell:setItemClickFun(self, self.onClickListItem)
		conItemIcon2:addChild(element)

		txtTaskTitle:setRelativePosition(GlobalMethod:ccp(0.29,0.64))
		txtTaskDesc:setRelativePosition(GlobalMethod:ccp(0.29,0.44))
	end
end

--@brief  	设置任务状态
function CellMagicStoneTask:_setTaskState( nState )
	if nState == TASKSTATUS_DOING then 
		local conUITaskBtn = GetElement(self.m_root,"conUITaskBtn_CellMagicStoneTask",WZUIContainer)
		conUITaskBtn:setVisible(true)
		local conBtnTaskState = GetElement(self.m_root,"conBtnTaskState_CellMagicStoneTask",WZUIContainer)
		conBtnTaskState:setVisible(false)
		local txtTaskFinish = GetElement(self.m_root,"txtTaskFinish_CellMagicStoneTask",WZUILabelTTF)
		if txtTaskFinish ~= nil then 
			txtTaskFinish:setVisible(false)
		end 
		local btnUISwitch = GetElement(self.m_root,"btnUISwitch_CellMagicStoneTask",WZUIButton)
		if btnUISwitch ~= nil then 
			btnUISwitch:setVisible(true)
			for i=1,3 do
				local txtBtn = "txtUISwitch_"..i.."_CellMagicStoneTask"
				local txtDoTaskBtn = GetElement(self.m_root,txtBtn,WZUILabelTTF)
				txtDoTaskBtn:setText(self.sText)
				if i==3 then 
					txtDoTaskBtn:setStrokeSize(4)
                    txtDoTaskBtn:setEnableStroke(true)
                    txtDoTaskBtn:setStrokeColor(GlobalMethod:ccc3(163,74,20))
					txtDoTaskBtn:setColor(GlobalMethod:ccc3(255,250,236))
				end 
				if txtDoTaskBtn:getText() == LocalStrings.LEAGUE_REWARD_TEXT9 then
					txtDoTaskBtn:setScale(0.8)
				end
			end
		end 
		local txtTaskTarget = GetElement(self.m_root,"txtTaskTarget_CellMagicStoneTask",WZUILabelTTF)
		txtTaskTarget:setVisible(true)
		txtTaskTarget:setText(self.m_txtTaskTarget)
	elseif nState == TASKSTATUS_TOSUBMIT then 
		local conBtnTaskState = GetElement(self.m_root,"conBtnTaskState_CellMagicStoneTask",WZUIContainer)
		conBtnTaskState:setVisible(true)
		local txtTaskTarget = GetElement(self.m_root,"txtTaskTarget_CellMagicStoneTask",WZUILabelTTF)
		txtTaskTarget:setVisible(true)
		txtTaskTarget:setText(self.m_txtTaskTarget)
		local conUITaskBtn = GetElement(self.m_root,"conUITaskBtn_CellMagicStoneTask",WZUIContainer)
		conUITaskBtn:setVisible(false)
		local txtTaskFinish = GetElement(self.m_root,"txtTaskFinish_CellMagicStoneTask",WZUILabelTTF)
		if txtTaskFinish ~= nil then 
			txtTaskFinish:setVisible(false)
		end 
		local btnCommit = GetElement(self.m_root,"btnCommit_CellMagicStoneTask",WZUIButton)
		if btnCommit ~= nil then 
			btnCommit:setVisible(true)
			for i=1,3 do
				local txtBtn = "txtCommit_"..i.."_CellMagicStoneTask"
				local txtGetRewardBtn = GetElement(self.m_root,txtBtn,WZUILabelTTF)
				txtGetRewardBtn:setText(LocalStrings.GET_REWARD)
			end
		end 
	elseif nState == TASKSTATUS_COMPLETED then 
		local txtTaskFinish = GetElement(self.m_root,"txtTaskFinish_CellMagicStoneTask",WZUILabelTTF)
		if txtTaskFinish ~= nil then 
			-- txtTaskFinish_CellMagicStoneTask:setVisible(true)
			-- txtTaskFinish_CellMagicStoneTask:setText(LocalStrings.ACTIVE_FINISH)
			GetElement(self.m_root,"imgTaskFinish_CellMagicStoneTask",WZUIImage):setVisible(true)
		end 
		local btnCommit = GetElement(self.m_root,"btnCommit_CellMagicStoneTask",WZUIButton)
		if btnCommit ~= nil then 
			btnCommit:setVisible(false)
		end 
		local txtTaskTarget = GetElement(self.m_root,"txtTaskTarget_CellMagicStoneTask",WZUILabelTTF)
		txtTaskTarget:setVisible(true)
		txtTaskTarget:setText(self.m_txtTaskTarget)

		local conUITaskBtn = GetElement(self.m_root,"conUITaskBtn_CellMagicStoneTask",WZUIContainer)
		conUITaskBtn:setVisible(false)
	end 
end

-------------------------------------私有方法模块End----------------------------------------

function CellMagicStoneTask:_adaptLanguage_vn()
	GetElement(self.m_root,"txtTaskTitle_CellMagicStoneTask",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtTaskDesc_CellMagicStoneTask",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtTaskAchieTime_CellMagicStoneTask",WZUILabelTTF):setFontSize(20)
end