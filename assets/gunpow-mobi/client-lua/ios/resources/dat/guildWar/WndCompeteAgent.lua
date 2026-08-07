-- WndCompeteAgent
-- @brief: 公会战设置代理人 UI部分
-- @date: 2017-02-24 10:22:02
-- @author: zhenwei_jian
-- @note: 公会战设置代理人


-------------------------------------公有方法模块Begin--------------------------------------
--@brief 显示该界面
--@param nAgentIndex:设置第几个代理人
--@param tCurrentAgentIdList:当前已经设置的代理人数据
function WndCompeteAgent:showWnd(nAgentIndex, tCurrentAgentIdList)
	local wnd, tObject = self:createElement()
	self.m_nClickPlaceIndex = nAgentIndex
	WindowManager:addWindow( wnd , WndCompeteAgent)

	--转化为Set
	local tAgentIdSet = {}
	for i, agentId in ipairs(tCurrentAgentIdList) do
		tAgentIdSet[agentId] = true
	end

	tObject:addMemberListFilterCondition("playerId", tAgentIdSet)
end

--@brief    onenter函数已执行
function WndCompeteAgent:onEnterTransitionDidFinish(element)
    --弹窗动画
    self:_setBtnText(LocalStrings.BUY_FIVE_AFFIRM)

    WindowManagerAni:createAppearAction(self.m_root, true, "_ready", self)
end


--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCompeteAgent:onEnter(element)
	self.m_root = element

	self.tbconMemberList = GetElement(self.m_root, "tbconMemberList", WZUITableContainer)--成员列表容器

	--注册协议
	ProtocolProcessorSceneCommunity:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCompeteAgent:onExit(element)
	--add by wuweidong
	self:_unInit()
end

--@brief	关闭按钮
function WndCompeteAgent:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	--进入公会场景
    WindowManager:removeWindow(self.m_root, self, true)
end

--@breif 刷新成员列表
function WndCompeteAgent:refresh()
	self:_update()
end

--@breif 设置代理人
function WndCompeteAgent:onSetAgent()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if nil == WndCompeteAgent.PreSelCell then
		return
	end

	if tonumber(CacheCenter:getPlayerInfo().position) ~= COMMUNITY_PRESIDENT then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYWAR_TEXT37)
		return 
	end
	local agentId = WndCompeteAgent.PreSelCell:getPlayerId()
	self.m_nSendingAgentId = agentId
	-- operation: 1为设置为代理人，2为取消代理人
	local nPlaceIndex = self.m_nClickPlaceIndex
	if self.m_nOperateType == 2 then
		nPlaceIndex = self.m_nTempPlaceIndex
	end
	-- WZLog("agentId:::", self.m_nOperateType, agentId, nPlaceIndex)
	ProtocolProcessorCommunityWar:send_GUILDWAR_SetAgent(self.m_nOperateType, agentId, nPlaceIndex)
end
	
--@brief 	点击列表回调
function WndCompeteAgent:onClickCell(playerId)
	-- body
	local nPlaceIndex, bIsCancel = self:_judgeWhetherAgent(playerId)
	self.m_nTempPlaceIndex = nPlaceIndex 
	local sBtnText = LocalStrings.BUY_FIVE_AFFIRM
	if bIsCancel then
		self.m_nOperateType = 2
		sBtnText = LocalStrings.CANCEL
	else
		self.m_nOperateType = 1
	end

	self:_setBtnText(sBtnText)
end
-------------------------------------公有方法模块End----------------------------------------



-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置按钮文字
function WndCompeteAgent:_setBtnText(text)
	-- body
	local txtBtnText = GetElement(self.m_root, "txtBtnText_WndCompeteAgent", WZUILabelTTF)
	if txtBtnText then
		txtBtnText:setText(text)
	end
end
function WndCompeteAgent:_ready()
	--获取公会大厅 
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
	SceneCommunityMain:createLoading()
end

function WndCompeteAgent:_update()
	-- self.tbconMemberList 
	--先把数据清空
	self.tbconMemberList:cleanTable()

	self.m_tCellList = {}
	for i, tData in ipairs(self.m_tMemberList) do
		local celElement, tCell =  CellCompeteAgent:createElement()
		if celElement ~= nil and tCell ~= nil then 
			tCell:setData(tData)
			celElement:setTag(i - 1)
			tCell:setCallBackFunc(self, self.onClickCell)
			self.tbconMemberList:setCellElement(celElement)

			table.insert(self.m_tCellList, tCell)
		end 
	end

	if 0 >= #self.m_tCellList then
		ShowPanelNullTip(self.tbconMemberList)
	else
		removeShowPanelNullTip(self.tbconMemberList)
	end
end

-------------------------------------私有方法模块End----------------------------------------