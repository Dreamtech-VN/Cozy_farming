--WndLeagueTeamList.lua
--@brief	WndLeagueTeamList的UI模块
--@date		2016/06/12
--@author	zsq
--@note		战队列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLeagueTeamList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLeagueTeamList:onExit(element)
	self:_unInit()
end

--@brief	加载完成
function WndLeagueTeamList:onEnterTransitionDidFinish(element)
	--显示创建按钮
	GetElement(self.m_root,"btnCreate",WZUIButton):setVisible(true)
	GetElement(self.m_root,"editInput",WZUIEditBox):setPlaceHolder(LocalStrings.LEAGUE108)

	ProtocolProcessorWndLeague:send_HERO_GetHeroTeamList()
	--self:setData()
end

--@brief	显示接口
function WndLeagueTeamList:show(parent)
	WZLog("WndLeagueTeamList:show")
	ChangeChatChannel(Chat_Channel_League_Compete)
	if parent == nil then return end
	if self.m_root == nil then 
		local wnd = WndLeagueTeamList:createElement()
		parent:addChild(wnd)
	else
		self.m_root:setVisible(true)
		ProtocolProcessorWndLeague:send_HERO_GetHeroTeamList()
	end
end

--@brief	创建战队
function WndLeagueTeamList:onCreate()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndLeagueCreate:show()
end

--@brief	显示战队列表
function WndLeagueTeamList:showList()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--显示创建按钮
	GetElement(self.m_root,"btnCreate",WZUIButton):setVisible(true)
	ProtocolProcessorWndLeague:send_HERO_GetHeroTeamList()
end

--@brief	搜索战队
function WndLeagueTeamList:searchTeam()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = GetElement(self.m_root,"editInput",WZUIEditBox):getText()
	--是否包含特殊符号
	if string.find(id, "%p") then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE42)
		return
	end
	if tonumber(id) == nil then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE42)
		return
	end
	SceneLeagueMain.m_nCheckType = 2
	ProtocolProcessorWndLeague:send_HERO_SearchTeam(id )
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndLeagueTeamList:update()
	WZLog("WndLeagueTeamList:update")
	if self.m_root == nil then return end 
	if self.m_tDataList == nil then return end
	local freeListContainer = GetElement(self.m_root,"freeCon_WndLeagueTeamList",WZUIFreeListContainer)
	freeListContainer:removeAll()

	--没有数据时显示提示
	if self.m_tDataList == nil or #self.m_tDataList == 0 then 
		ShowPanelNullTip(freeListContainer,nil,GlobalMethod:ccc3(255,236,193))
	else
		removeShowPanelNullTip(freeListContainer)
	end

	--上一页
	if self.m_tDataList ~= nil and #self.m_tDataList > 48 then 
		freeListContainer:setEnableDropRefresh(false)
		local ttf = WZUILabelTTF:create()
		ttf:setText(LocalStrings.LEAGUE60)
		ttf:setFontSize(22)
		ttf:setUseOriginSize(true)
		ttf:setColor(GlobalMethod:ccc3(255,236,193))
		freeListContainer:setTopNotice(LocalStrings.LEAGUE60, LocalStrings.LEAGUE60)
		freeListContainer:setTopElementFunction("onFrontPageBtn")--设置TopElement的Lua回调函数
		freeListContainer:setEnableTopElement(true)--设置TopElement是否可用
		freeListContainer:setVisibleHeight(30)
		freeListContainer:setHideTopElement(false)--设置topElement是否隐藏
		freeListContainer:setTopElement(ttf)--设置容器的TopElement对象
	--下一页
		freeListContainer:setEnableDagLoading(false)
		local ttf = WZUILabelTTF:create()
		ttf:setText(LocalStrings.LEAGUE60)
		ttf:setFontSize(22)
		ttf:setUseOriginSize(true)
		ttf:setColor(GlobalMethod:ccc3(255,236,193))
		freeListContainer:setBottomNotice(LocalStrings.LEAGUE60, LocalStrings.LEAGUE60)
		freeListContainer:setBottomElementFunction("onNextPageBtn")--设置BottomElement的Lua回调函数
		freeListContainer:setVisibleHeight(30)
		freeListContainer:setEnableBottomElement(true)--设置BottomElement是否可用
		freeListContainer:setHideBottomElement(false)--设置bottomElement是否隐藏
		freeListContainer:setBottomElement(ttf)--设置容器的BottomElement对象
	end

	for i=1,#self.m_tDataList do
		local celElement,tCell = CellLeagueTeam:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tDataList[i])
			freeListContainer:pushBack(celElement)
			
		end 
	end
	freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
end

function WndLeagueTeamList:onFrontPageBtn()
	WZLog("WndLeagueTeamList:onFrontPageBtn")
	ProtocolProcessorWndLeague:send_HERO_GetHeroTeamList()
end

function WndLeagueTeamList:onNextPageBtn()
	WZLog("WndLeagueTeamList:onNextPageBtn")
	ProtocolProcessorWndLeague:send_HERO_GetHeroTeamList()
end
-------------------------------------私有方法模块End----------------------------------------
