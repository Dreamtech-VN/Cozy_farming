--WndCommunityTask.lua
--@brief	WndCommunityTask的UI模块
--@date		2016/06/17
--@author	zsq
--@note		公会任务主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityTask:onEnter(element)
	self.m_root = element
end

--@brief	加载完成
function WndCommunityTask:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"txtBtm",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO128)
	if ProjConfig.LANGUAGE == "pt" then
		GetElement(self.m_root,"txtBtm",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(680,0))
	end
	GetElement(self.m_root,"edit_WndCommunityTask",WZUIEditBox):setPlaceHolder(LocalStrings.COMMUNITYINFO129)
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true, "sendProtocol", self)
    AdaptLanguage(self)
end

function WndCommunityTask:sendProtocol()
	ProtocolProcessorSceneCommunity:send_GUILD_RequestGuildTask()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityTask:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮
function WndCommunityTask:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityTask, true)
	end 
end

--@brief	开始按下回调函数
function WndCommunityTask:onTouchBegan(element,pt)
	WZLog("WndCommunityTask:onTouchBegan",pt.x,pt.y)
	if WndItemInfo.m_root ~= nil then
		WndItemInfo:onCloseClick()
	end
	--设置奖励高亮按钮
	if self.m_nRewardTag ~= nil then
		GetElement(self.m_root,"rightBtn"..self.m_nRewardTag,WZUIButton):setButtonStatus(1)
	end
end

--@brief	点击右侧标签
function WndCommunityTask:onCheck(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = tonumber(element:getTag())
	if tag == 1 then
		self:updateState()
	elseif tag == 2 then
		self.m_nState = 2
		ProtocolProcessorSceneCommunity:send_GUILD_RequestFundReward( )
	end
end

--@brief	查看不同等级奖励
function WndCommunityTask:onReward(element)
	WZLog("WndCommunityTask:onReward",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nRewardTag = element:getTag()
	for i=1,4 do
		GetElement(self.m_root,"rightBtn"..i,WZUIButton):setButtonStatus(0)
	end
	element:setButtonStatus(1)
	self:showTaskReward(element:getTag())
end

--@brief	发送留言
function WndCommunityTask:onSendMessage(element)
	WZLog("WndCommunityTask:onSendMessage")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local msg = GetElement(self.m_root,"edit_WndCommunityTask",WZUIEditBox):getText()
	if msg == "" or msg == nil then
		MsgBoxManager:showTipBox(LocalStrings.SPACE21)
	else
		ProtocolProcessorSceneCommunity:send_GUILD_LeaveMsg(msg )
	end
end

--@break	前往发布
function WndCommunityTask:onPublish(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_bPublishing = true
	self:showTaskRease()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndCommunityTask:update()
	if self.m_nState == 1 then
		self:showTaskRease()
	elseif self.m_nState == 2 then
		--self:showTaskReward()
	elseif self.m_nState == 3 then
		self:showBeforeRelease()
	elseif self.m_nState == 4 then
		self:showSendMsg()
	end
end

function WndCommunityTask:updateReward()
	self:showTaskReward(1)
end

function WndCommunityTask:showSendMsg()
	WZLog("WndCommunityTask:showSendMsg")
	if self.m_root == nil then return end
	GetElement(self.m_root,"conBg",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"txtBtm",WZUILabelTTF):setVisible(true)
	GetElement(self.m_root,"conBtm",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conMessage",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conReward",WZUIContainer):setVisible(false)
	if WndCommunityTaskRelease.m_root ~= nil then
		WndCommunityTaskRelease.m_root:setVisible(false)
	end
end

function WndCommunityTask:showTaskRease()
	self.m_nState = 1
	if self.m_root == nil then return end
	GetElement(self.m_root,"conBg",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"txtBtm",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"conBtm",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conReward",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conMessage",WZUIContainer):setVisible(false)
	WndCommunityTaskRelease:show(GetElement(self.m_root,"conTaskRelease",WZUIContainer))
end

function WndCommunityTask:showTaskReward(level)
	if self.m_root == nil then return end
	GetElement(self.m_root,"conBg",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"txtBtm",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"conBtm",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conMessage",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conReward",WZUIContainer):setVisible(true)
	if WndCommunityTaskRelease.m_root ~= nil then
		WndCommunityTaskRelease.m_root:setVisible(false)
	end
	--默认选择第一个
	GetElement(self.m_root,"rightBtn"..level,WZUIButton):setButtonStatus(1)
	--需要基金量
	GetElement(self.m_root,"txtNeedScore",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO112,self.m_tReward.nums[level]))
	--当前基金量
	GetElement(self.m_root,"curScore",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO113,self.m_tReward.currFund))
	--显示奖励
	local freeListContainer = GetElement(self.m_root,"freeCon_ConReward",WZUIFreeListContainer)
	freeListContainer:removeAll()

	local positionList = {5,4,3,2,1}
	for i=1,5 do
		for k,v in pairs(GDatatab_guild_task_fund) do
			if v.level == level and v.job == positionList[i] then
				local celElement,tCell = CellCommunityTaskReward:createElement()
				if celElement ~= nil and tCell ~= nil then 
					celElement = WZUIContainer:luaTo(celElement)
					tCell:setData(CopyTable(v))
					freeListContainer:pushBack(celElement)
					freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
				end 
				break
			end
		end
	end
end

function WndCommunityTask:showBeforeRelease()
	if self.m_root == nil then return end
	GetElement(self.m_root,"conBg",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"txtBtm",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"conBtm",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conMessage",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conReward",WZUIContainer):setVisible(false)
	if WndCommunityTaskRelease.m_root ~= nil then
		WndCommunityTaskRelease.m_root:setVisible(false)
	end

	--显示留言列表
	local freeListContainer = GetElement(self.m_root,"freeCon_ConMessage",WZUIFreeListContainer)
	freeListContainer:removeAll()

	local conMsg = GetElement(self.m_root,"conMessage",WZUIContainer)
	local conMsgBg = GetElement(self.m_root,"conMsgBg",WZUIContainer)
	if self.m_tDataList1 == nil or #self.m_tDataList1 == 0 then 
		ShowPanelNullTip(conMsg,nil,GlobalMethod:ccc3(79,60,48))
		conMsgBg:setVisible(false)
		return 
	end
	conMsgBg:setVisible(true)
	removeShowPanelNullTip(conMsg)

	for i=#self.m_tDataList1,1,-1 do
		local celElement,tCell = CellCommunityTask:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tDataList1[i])
			freeListContainer:pushBack(celElement)
			freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
		end 
	end
end

function WndCommunityTask:_adaptLanguage_th()
    WZLog("WndCommunityTask:_adaptLanguage_th")
    
end

function WndCommunityTask:_adaptLanguage_en()
	WZLog("WndCommunityTask:_adaptLanguage_en")
	GetElement(self.m_root,"txtRewardDes_WndCommunityTask",WZUILabelTTF):setScale(0.75)

	local txt = GetElement(self.m_root,"txtCheck_WndCommunityTask",WZUILabelTTF)
	txt:setFontSize(20)
	txt:setDimensions(GlobalMethod:CCSize(100,0))
	GetElement(self.m_root,"txtMsg_WndCommunityTask",WZUILabelTTF):setScale(0.8)
end

function WndCommunityTask:_adaptLanguage_pt(  )
	local txtRewardDes = GetElement(self.m_root,"txtRewardDes_WndCommunityTask",WZUILabelTTF)
	txtRewardDes:setScale(0.75)
	txtRewardDes:setDimensions(GlobalMethod:CCSize(600))

	local txt = GetElement(self.m_root,"txtCheck_WndCommunityTask",WZUILabelTTF)
	txt:setFontSize(20)
	txt:setDimensions(GlobalMethod:CCSize(100,0))
	GetElement(self.m_root,"txtMsgInfo_WndCommunityTask",WZUILabelTTF):setScale(0.8)
end

function WndCommunityTask:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtRewardDes_WndCommunityTask",WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root,"txtText1_WndCommunityTask",WZUILabelTTF):setScale(0.8)
end

function WndCommunityTask:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtRewardDes_WndCommunityTask",WZUILabelTTF):setScale(0.7)

	local txt = GetElement(self.m_root,"txtCheck_WndCommunityTask",WZUILabelTTF)
	txt:setFontSize(20)
	txt:setDimensions(GlobalMethod:CCSize(100,0))
	GetElement(self.m_root,"txtMsg_WndCommunityTask",WZUILabelTTF):setScale(0.8)
	-- GetElement(self.m_root,"txtMsgInfo_WndCommunityTask",WZUILabelTTF):setScale(0.8)
end

function WndCommunityTask:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtRewardDes_WndCommunityTask",WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root,"curScore",WZUILabelTTF):setScale(0.6)
end
-------------------------------------私有方法模块End----------------------------------------
