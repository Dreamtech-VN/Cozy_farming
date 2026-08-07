--WndFootballGuessList.lua
--@brief	WndFootballGuessList的UI模块
--@date		2018/06/01
--@author	Tianxiang_Xu
--@note		足球精彩列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFootballGuessList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFootballGuessList:onExit(element)
	self:_unInit()
end

--@brief    onenter函数已执行
function WndFootballGuessList:onEnterTransitionDidFinish(element)
    WZLog("WndFootballGuessList:onEnterTransitionDidFinish")
    
    if self.m_nType == 1 then
    	ProtocolProcessorWndRankList:send_RANK_GetFireworkRank(3)
    elseif self.m_nType == 2 then
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetBetOnMatchInfo()
    elseif self.m_nType == 3 then
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFootballQuizStore()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	更新
function WndFootballGuessList:_update()
	-- body
	for i = 1, 3 do
		GetElement(self.m_root, "tbContent" .. i .. "_WndFootballGuessList", WZUITableContainer):setVisible(false)
	end

	local tbContent = GetElement(self.m_root, "tbContent" .. self.m_nType .. "_WndFootballGuessList", WZUITableContainer)
	tbContent:setVisible(true)
	tbContent:cleanTable()

	local conForList = GetElement(self.m_root, "conForList_WndFootballGuessList", WZUIContainer)
	if self.m_tDataList == nil or #self.m_tDataList == 0 then
		ShowPanelNullTip(conForList)
		return 
	end

	removeShowPanelNullTip(conForList)

	if self.m_nType == 1 then
		self:_createRankList()
	elseif self.m_nType == 2 then
		self:_createResultList()
	elseif self.m_nType == 3 then
		self:_createShopList()
	end

	local txtAtt = GetElement(self.m_root, "txtAtt_WndFootballGuessList", WZUILabelTTF)
	if self.m_nType ~= 3 then
		txtAtt:setVisible(true)
		txtAtt:setText(LocalStrings.QUIZZES_ISSUED_VIA_EMAIL)
	else
		txtAtt:setVisible(false)
	end
end

--@brief 	创建排名列表
function WndFootballGuessList:_createRankList()
	-- body
	local tbContent = GetElement(self.m_root, "tbContent" .. self.m_nType .. "_WndFootballGuessList", WZUITableContainer)

	for i = 1, #self.m_tDataList do
		local element, tNewObj = CellFootballGuessRank:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tDataList[i])
			tbContent:setCellElement(element)
		end
	end
end

--@brief 	创建排名列表
function WndFootballGuessList:_createResultList()
	-- body
	local tbContent = GetElement(self.m_root, "tbContent" .. self.m_nType .. "_WndFootballGuessList", WZUITableContainer)

	for i = 1, #self.m_tDataList do
		local element, tNewObj = CellFootballGuessResult:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tDataList[i])
			tbContent:setCellElement(element)
		end
	end
end

--@brief 	创建排名列表
function WndFootballGuessList:_createShopList()
	-- body
	local tbContent = GetElement(self.m_root, "tbContent" .. self.m_nType .. "_WndFootballGuessList", WZUITableContainer)

	for i = 1, #self.m_tDataList do
		local element, tNewObj = CellFootballGuessShop:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tDataList[i])
			tbContent:setCellElement(element)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
