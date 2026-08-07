--WndUnionList.lua
--@brief	WndUnionList的UI模块
--@date		2024/01/09
--@author	XTX
--@note		联盟列表

local EACH_PAGE_NUM = 20
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndUnionList:onEnter(element)
	self.m_root = element

	--注册协议
	ProtocolProcessorUnion:regAll()
	--初始化UI静态文本
	self:_initStaticUiText()
	--多语言版本界面适配
    AdaptLanguage(self)

	CacheCenter:registerUpatePlayerInfoObserver(self)

	self:_addTop()

	WZLog("我的联盟id")

	--玩家不是公会成员
	local unionInfo = CacheCenter:getPlayerInfo().unionInfo
	if unionInfo == nil or (unionInfo.id and unionInfo.id < 1) then
    	ChangeChatChannel(Chat_Channel_Union_Rank_N)
	else
    	ChangeChatChannel(Chat_Channel_Union_Rank)
	end

	self:_showLeftList()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndUnionList:onExit(element)
	if self.m_root then 
		local btnFresh = GetElement(self.m_root, "btnFresh_WndUnionList", WZUIButton)
		if btnFresh then 
			btnFresh:disableSchedule()
		end
	end
	self:_unInit()
end

function WndUnionList:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_lm.png",WndUnionList,WndUnionList.onClose,true,true,false,"WndUnionList")

    self.m_tCellTop = tcell
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndUnionList:onExit(element)
	self:_unInit()
	--add by wuweidong
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","WndUnionList")
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
end

--@brief	关闭按钮
function WndUnionList:onClose()
	WZLog("WndUnionList:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    if self.m_root == nil then return end

	local unionInfo = CacheCenter:getPlayerInfo().unionInfo
	--玩家不是公会成员
	if unionInfo == nil or (unionInfo.id and unionInfo.id < 1) then
        WindowManager:removeWindow(self.m_root, self, true)
	else
        WindowManager:removeWindow(self.m_root, self, true)
	end
end

--@brief	点击窗口
function WndUnionList:onTouchBegan(element, pt)
	WZLog("WndUnionList:onTouchBegan")
	if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

--@brief	点击创建公会按钮时
function WndUnionList:onClickCreateCommunity(element)
	WZLog("WndUnionList:onClickCreateCommunity(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--等级未达到15级不能建造公会(判断玩家等级是否满足创建等级)
	local leagueCreateLevel = tonumber(CacheCenter:getGameParam().leagueCreateLevel)
	local leagueCreateVipLv = tonumber(CacheCenter:getGameParam().leagueCreateVipLv)
	local leagueCreateFight = tonumber(CacheCenter:getGameParam().leagueCreateFight)
	if CacheCenter:getPlayerInfo().level < leagueCreateLevel then  
		--创建失败，淡入淡出提示
		MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT1[32], leagueCreateLevel))
		return 
	end 
	if CacheCenter:getPlayerInfo().vipLevel < leagueCreateVipLv then  
		--创建失败，淡入淡出提示
		MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT1[33], leagueCreateVipLv))
		return 
	end 
	if CacheCenter:getPlayerInfo().fighting < leagueCreateFight then  
		--创建失败，淡入淡出提示
		MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT1[34], leagueCreateFight))
		return 
	end 

	--弹出创建联盟的窗口
	WndCreateCommunity:onJumpToWndCreateCommunity(self.createUnionBtn,self, 1)
end 

--@brief	点击创建联盟的回调函数 
--@param #sInputName  输入名字
function WndUnionList:createUnionBtn(sInputName)
	WZLog("WndUnionList:createUnionBtn")
	if sInputName == "" or sInputName == nil then 
		--请输入联盟名字
		MsgBoxManager:showTipBox(LocalStrings.UNION_TEXT1[3]) 
		return 
	end 
	--local strLen = ChineseStringLen(sInputName)
	--检测联盟名字合法性
	local m_nUseType = 6 	
	result = JudgeResultInClientForInputText(m_nUseType, sInputName)
	if result ~= 0 then 
		DisplayResult(result)
		return
	end

	self.m_sInputContent = sInputName
	local guildCreateCost = CacheCenter:getGameParam().leagueCreateCost
	local ids,nums = SplitItemString(guildCreateCost)
	for i = 1, #ids do
		if not JudgeMoneyIsEnough(ids[i], nums[i], nil, nil, nil, nil, nil, nil, nil, self, self.clickSureMoney) then
			return 
		end
	end
	self:clickSureMoney()
end 

--@brief	点击确定充值回调
function WndUnionList:clickSureMoney()
    --创建公会
	ProtocolProcessorUnion:send_LEAGUE_CreateLeague(self.m_sInputContent)
end

--@brief	点击我的公会按钮时
function WndUnionList:onClickMyCommunityBtn(element)
	WZLog("WndUnionList:onClickMyCommunityBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_bSendGetPlayerInfo = true

	--进入公会场景
	self.m_tCellLeft["hall"]:setSelState(true)
   	self:onClickLeftBtnCallBack("hall", self.m_tCellLeft["hall"])
end 

--@brief	点击查找公会ID按钮时
function WndUnionList:onClickFindCommunityId(element)
	WZLog(" WndUnionList:onClickFindCommunityId(element)")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local inputText = nil 
	local editInputId  = self.m_root:getChildElement("editInputId_WndUnionList")
	if editInputId ~= nil then 
		editInputId = WZUIEditBox:luaTo(editInputId)
		if editInputId ~= nil then 
			inputText = editInputId:getText()
		end 
	end 
	if tonumber(inputText) ~= nil then     --输入全是数字
		--加载圆圈
		self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
		--获取并显示公会信息
		g_bIsGetUnionInfo = true
		ProtocolProcessorUnion:send_LEAGUE_GetLeagueInfo(tonumber(inputText))
	elseif inputText == LocalStrings.UNION_TEXT1[37] or inputText == "" then 
		MsgBoxManager:showTipBox(LocalStrings.UNION_TEXT1[37])
	else  
		MsgBoxManager:showTipBox(LocalStrings.UNION_TEXT1[38])
	end 
end 

--@brief	点击表格中相应容器（CELL）时的触发函数
--@param #1 element 容器本身铵钮表对象
--@param  #2 sId   公会ID
function WndUnionList:onBtnClickEventByCellCommunitList(element,sId)
	WZLog("WndUnionList:onBtnClickEventByCellCommunitList")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCellCommunityId = sId
	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
	--获取并显示公会信息
	g_bIsGetUnionInfo = true
	ProtocolProcessorUnion:send_LEAGUE_GetLeagueInfo(tonumber(sId))

	self:_setFindCommunityEditBoxIsTouchEnable(false)
end 

--@brief	未加入公会的玩家跳转到公会列表的函数
function WndUnionList:onJumpToCommunity()
	local unionInfo = CacheCenter:getPlayerInfo().unionInfo

	if unionInfo == nil or (unionInfo.id and unionInfo.id < 1) then
		if WndUnionList.m_root == nil then
			local wndUnionList = WndUnionList:createElement()
			WindowManager:addWindow(wndUnionList,WndUnionList)
			self:onTab1()
		end
        WZLog("WndUnionList:onJumpToCommunity 1")
		WndUnionList:_setBtnCreateOrMyCommunistyVisable(0)
	else
        WZLog("WndUnionList:onJumpToCommunity 2")
		WndUnionList:_setBtnCreateOrMyCommunistyVisable(1)

		WndUnionList:showInterface("hall")
        ChangeChatChannel(Chat_Channel_Union_Rank)
	end
end 

--@brief	已经加入公会的玩家跳转到公会列表的函数
function WndUnionList:openCommunityList()
	local wndUnionList = WndUnionList:createElement()
	WindowManager:addWindow(wndUnionList,WndUnionList)
	self:onTab1()
end 

--@brief	跳转到周榜
function WndUnionList:openCommunityList1()
	local wndUnionList = WndUnionList:createElement()
	WindowManager:addWindow(wndUnionList,WndUnionList)
	self:onTab2()
	GetElement(self.m_root, "checkGroup", WZUICheckBoxGroup):setCheckIndex(1)
end 

--@brief	跳转到历史榜
function WndUnionList:openCommunityList2()
	local wndUnionList = WndUnionList:createElement()
	WindowManager:addWindow(wndUnionList,WndUnionList)
	self:onTab3()
	GetElement(self.m_root, "checkGroup", WZUICheckBoxGroup):setCheckIndex(2)
end 

--@brief	跳转到公会大厅
function WndUnionList:jumpToHall()
	local unionInfo = CacheCenter:getPlayerInfo().unionInfo
	if unionInfo == nil or (unionInfo.id and unionInfo.id < 1) then
        WZLog("WndUnionList:jumpToHall 1")
        if WndUnionList.m_root == nil then
	        local winUnion = WndUnionList:createElement()
	        WindowManager:addWindow(winUnion,WndUnionList)
			self:onTab1()
	    end
        self:_setBtnCreateOrMyCommunistyVisable(0)
		return false
	else
        WZLog("WndUnionList:jumpToHall 2")
		WndUnionList:_setBtnCreateOrMyCommunistyVisable(1)
   		replaceScene(SceneCommunityMain:createElement())
        ChangeChatChannel(Chat_Channel_Guild_Rank)
		WndUnionHall.jumpTo = "hall"
	end
end

--@brief	往场景根节点添加元素的方法
--@param	element:要添加的界面元素引用
--@note		这里会修改showAll属性，为了适配不同分辨率，保证界面元素不会变形
--          注: 对于主场景showAll属性已经是true的时候不用修改元素的showAll
--          小岛界面有特殊需求，所以showAll属性为false，需要修改里面元素的showAll属性
function WndUnionList:addChild(element)
    if self.m_root == nil or element == nil then
        return
    end
    element:setShowAll(true)
    self.m_root:addChild(element)
end

--@brief 	点击左边列表按钮回调
function WndUnionList:onClickLeftBtnCallBack(mark, tCell)
	--body
	local conRank = GetElement(self.m_root, "conRank_WndUnionList", WZUIContainer)
	local conOther = GetElement(self.m_root, "conOther_WndUnionList", WZUIContainer)
	conRank:setVisible(false)
	conOther:setVisible(false)
	if tCell and self.m_tCellSel then 
		self.m_tCellSel:setSelState(false)
		self.m_tCellSel = tCell
	end
	if mark == "hall" then 
		conOther:setVisible(true)
		if WndUnionHall.m_root == nil then 
			conOther:removeAllChildrenWithCleanup(true)
			local wndHall =  WndUnionHall:createElement()
			conOther:addChild(wndHall)
			self:resetTopTitle("ui/common/common_icon_lm.png", self, self.onClose)
		else
			if GetElement(WndUnionHall.m_root,"conMain3",WZUIContainer):isVisible() then 
				self:resetTopTitle("ui/common/common_icon_lmgl.png", WndUnionHall, WndUnionHall.onNormal)
			else
				self:resetTopTitle("ui/common/common_icon_lm.png", self, self.onClose)
			end
		end
	elseif mark == "totem" then 
		conOther:setVisible(true)
		if SceneCommunityTotem.m_root == nil then 
			conOther:removeAllChildrenWithCleanup(true)

			local sceneCommunityTotem = SceneCommunityTotem:createElement()
			conOther:addChild(sceneCommunityTotem)
		end
		self:resetTopTitle("ui/community/common_icon_ghtt.png", self, self.onClose)
	elseif mark == "skill" then 
		conOther:setVisible(true)
		if SceneCommunitySkill.m_root == nil then 
			conOther:removeAllChildrenWithCleanup(true)

			local sceneCommunitySkill = SceneCommunitySkill:createElement()
			conOther:addChild(sceneCommunitySkill)
		end
		self:resetTopTitle("ui/common/common_icon_jjxt.png", self, self.onClose)
	elseif mark == "task" then 
		conOther:setVisible(true)
		if WndCommunityTask.m_root == nil then 
			conOther:removeAllChildrenWithCleanup(true)
			local wndTask = WndCommunityTask:createElement()
			conOther:addChild(wndTask)
		end
		self:resetTopTitle("ui/community/common_icon_ghrw.png", self, self.onClose)
	elseif mark == "rank" then 
		conRank:setVisible(true)
		self:resetTopTitle("ui/common/common_icon_lm.png", self, self.onClose)
	elseif mark == "copy" then 
		conOther:setVisible(true)
		conOther:removeAllChildrenWithCleanup(true)
		local wndCopy = SceneCommunityCopy:createElement()
		conOther:addChild(wndCopy)
		self:resetTopTitle("ui/community/common_icon_ghfb.png", self, self.onClose)
	end
end

--@brief 	重新设置界面标题
function WndUnionList:resetTopTitle(filePath, tCell, func)
	--body
	if self.m_tCellTop then 
		self.m_tCellTop:setTitleFile(filePath)
		if tCell and func then 
			self.m_tCellTop:setCallBackFunc(tCell, func)
		end
	end
end

--@brief 	刷新联盟列表
function WndUnionList:onClickFresh(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nFreshCd > 0 then 
		return
	end
	self.m_nFreshCd = 3
	ProtocolProcessorUnion:send_LEAGUE_GetLeagueList()
	local btnFresh = GetElement(self.m_root, "btnFresh_WndUnionList", WZUIButton)
	btnFresh:setTouchEnable(false)
	local txtFresh = GetElement(self.m_root, "txtFresh_WndUnionList", WZUILabelTTF)
	if txtFresh then 
		txtFresh:setText(LocalStrings.MASTERINFO71 .. self.m_nFreshCd .. LocalStrings.SECOND)
	end
	btnFresh:enableSchedule("freshCDTime", 1)
end

--@brief 	点击规则按钮回调
function WndUnionList:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local leagueCreateLevel = tonumber(CacheCenter:getGameParam().leagueCreateLevel)
	local leagueCreateVipLv = tonumber(CacheCenter:getGameParam().leagueCreateVipLv)
	local leagueCreateFight = tonumber(CacheCenter:getGameParam().leagueCreateFight)
	local strContent = string.format(LocalStrings.UNION_TEXT3, leagueCreateVipLv, leagueCreateLevel, leagueCreateFight)
	WndSingleMapDesc:showInterface(strContent)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新场景时内容调用的函数（公会排名，公会ID，公会名称，公会等级，公会威望，胜利次数，胜率）
function WndUnionList:_update()
	if self.m_root == nil then return end 
	
	--设置创建按钮可见还是我的公会按钮可见
	local unionInfo = CacheCenter:getPlayerInfo().unionInfo
	if unionInfo == nil or (unionInfo.id and unionInfo.id < 1) then 
		self:_setBtnCreateOrMyCommunistyVisable(0)     --我的公会可见 
	else 
		self:_setBtnCreateOrMyCommunistyVisable(1)     ---0为创建公会
	end 

	--根据表格和数据表去设置内容
	local tableContainer = self:_getTableContainer()

	local index = 1
	local startIndex, endIndex
	if self.pageNumber == 1 then 
		startIndex = 1 
		endIndex = 31 
	else 
		startIndex = (self.pageNumber - 1)*20 - 8 
		endIndex = self.pageNumber * 20 + 1
	end

	local showList = {}
	for i=startIndex,endIndex do
		showList[index] = self.m_tAllCommunityList[i]
		index = index + 1
	end
	self.m_tShowList = showList
	WZLog("WndUnionList:_update",Serialize(showList))
	self:_setTableContainerContent(tableContainer,showList)
end 


--@brief	点击上一页触发函数
--@param	element:表绑定的UI节点引用
function WndUnionList:onPageUp(element)
	WZLog("WndUnionList:onPageUp",self.pageNumber,self.totalNumber)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_bUpPageShowLastPosition = true
	if self.m_tCommunityList and self:_getUpPage() then 
		self.pageNumber = self.pageNumber - 1
		local nPageNum = self.pageNumber - 1
		--删除本页前10和后10个Cell
		local tableCon = self:_getTableContainer()
		if self.pageNumber == 1 then
    		for i = 20, 29 do
				if tableCon:getCellElement(i) then
    				tableCon:removeCellElement(i)
				end
    		end
    		for i = 19, 0, -1 do
    		    local celTemp = tableCon:getCellElement(i)
    		    if celTemp then 
    		        local nNewTag = i + 11
    		        local child = celTemp:getChildByTag(i)
    		        celTemp:setTag(nNewTag)
    		        child:setTag(nNewTag)
    		    end
    		end
		else
    		for i = 10, 29 do
				if tableCon:getCellElement(i) then
    				tableCon:removeCellElement(i)
				end
    		end
    		for i = 9, 0, -1 do
    		    local celTemp = tableCon:getCellElement(i)
    		    if celTemp then 
    		        local nNewTag = i + 20
    		        local child = celTemp:getChildByTag(i)
    		        celTemp:setTag(nNewTag)
    		        child:setTag(nNewTag)
    		    end
    		end
		end
		if #self.m_tShowList >=20 then
			self.m_nOffsetNum = 10
		else
			self.m_nOffsetNum = #self.m_tShowList - 10
		end
		--取得公会列表
		self.m_tCommunityList = {}
		self.m_tShowList = {}
		self:getGuildList(nPageNum)
	end
	self.turnPage = "up"
end

--@brief	点击下一页触发函数
--@param	element:表绑定的UI节点引用
function WndUnionList:onPageDown(element)
	WZLog("WndUnionList:onPageDown",self.pageNumber,self.totalNumber)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tCommunityList and self:_getDownPage() then 
		self.pageNumber = self.pageNumber + 1
		local nPageNum = self.pageNumber - 1
		self.m_bFirstTurnPage = false
		--删除tableCon前面的cell
		local tableCon = self:_getTableContainer()
		local delNum
		if self.pageNumber == 2 then delNum = 11 else delNum = 20 end
    	for i =1, delNum do
    		tableCon:removeCellElementByReset(0)
    	end
		if self.m_bFirstTurnPage == true then
			self.m_nOffsetNum = 0
		else
			self.m_nOffsetNum = #self.m_tShowList - 20
		end
		--取得公会列表
		self.m_tCommunityList = {}
		self.m_tShowList = {}
		self:getGuildList(nPageNum)
	end
	self.turnPage = "down"
end

--@brief	根据从表中的内容来设置表格里内容的函数
--@param #1 tbconContainer  表格对象
--@param #2 tCellList		存取数据的表
function WndUnionList:_setTableContainerContent(tbconContainer,tCellList)
	WZLog("WndUnionList:setTableContainerContent(tbconContainer,tCellList)")
	if tbconContainer == nil or tCellList == nil then 
		return 
	end 
	--tbconContainer:cleanTable()
	removeShowPanelNullTip(GetElement(self.m_root,"conRank_WndUnionList",WZUIContainer))
	self.m_nCurrentCellIndex = 1 
	self.m_tCurrentList = tCellList

	--上下拉触发分页
	if self:_getUpPage() then
		--Begin:翻页效果2
		tbconContainer:setEnableDropRefresh(false)
		local ttf = WZUILabelTTF:create()
		ttf:setText(LocalStrings.FRONT_PAGE)
		ttf:setFontSize(22)
		ttf:setUseOriginSize(true)
		ttf:setColor(GlobalMethod:ccc3(255,236,193))
		tbconContainer:setTopNotice(LocalStrings.FRONT_PAGE, LocalStrings.FRONT_PAGE_TIP)
		tbconContainer:setTopElementFunction("onPageUp")--设置TopElement的Lua回调函数
		tbconContainer:setEnableTopElement(true)--设置TopElement是否可用
		tbconContainer:setVisibleHeight(30)
		tbconContainer:setHideTopElement(false)--设置topElement是否隐藏
		tbconContainer:setTopElement(ttf)--设置容器的TopElement对象
	else
		tbconContainer:setEnableDropRefresh(false)
		tbconContainer:setEnableTopElement(false)
		tbconContainer:setHideTopElement(true)
	end
	if self:_getDownPage() then
		--Begin:翻页效果2
		tbconContainer:setEnableDagLoading(false)
		local ttf = WZUILabelTTF:create()
		ttf:setText(LocalStrings.NEXT_PAGE)
		ttf:setFontSize(22)
		ttf:setColor(GlobalMethod:ccc3(255,236,193))
		ttf:setUseOriginSize(true)
		tbconContainer:setBottomNotice(LocalStrings.NEXT_PAGE, LocalStrings.NEXT_PAGE_TIP)
		tbconContainer:setBottomElementFunction("onPageDown")--设置BottomElement的Lua回调函数
		tbconContainer:setVisibleHeight(30)
		tbconContainer:setEnableBottomElement(true)--设置BottomElement是否可用
		tbconContainer:setHideBottomElement(false)--设置bottomElement是否隐藏
		tbconContainer:setBottomElement(ttf)--设置容器的BottomElement对象
	else 
		tbconContainer:setEnableDagLoading(false)
		tbconContainer:setEnableBottomElement(false)
		tbconContainer:setHideBottomElement(true)
	end
	--开启逐帧加载tbconContainer每个单元格的定时器
	tbconContainer:enableSchedule("scheduleCreateCell")
end 

--@brief	逐帧加载tbconContainer每个单元格的定时器回调方法
--@param	element:定时器绑定的UI节点引用
--@param	delta:定时器回调间隔
--@note		采用定时器逐帧加载tbconContainer的每一项(或几项)，防止在同一帧中加载太多数据导致的卡顿以及瞬间的内存脉冲
function WndUnionList:scheduleCreateCell(element, delta)
	local element = self:_getTableContainer()
	
	if self.m_tCurrentList == nil then 
		element:disableSchedule()
		return 
	end  
	if #self.m_tCurrentList == 0 then
		ShowPanelNullTip( GetElement(self.m_root,"conRank_WndUnionList",WZUIContainer))
		element:disableSchedule()
	end
	--WZLog("m_nCurrentCellIndex :::",m_nCurrentCellIndex)
	if self.m_nCurrentCellIndex > #self.m_tCurrentList or self.m_nCurrentCellIndex < 1 then 
		element:disableSchedule()
		--重设滚动位置
		if self.turnPage == "down" then
        	local tableCon = WZUITableContainer:luaTo(element)
        	if tableCon ~= nil and self.pageNumber ~= 1 then
        		WZLog("执行到这里:::1",element:getMinPosition().y,element:getMoveElement():getPositionY())
        	end 
		end
		if self.turnPage == "up" then
			local tableCon = WZUITableContainer:luaTo(element)
			if tableCon ~= nil then
				WZLog("执行到这里:::2",element:getMaxPosition().y)
			end
		end
		--element:updateTopDownPosition()
	end 

	local tableContainer = element
	for var = 1,1 do 
		if self.m_nCurrentCellIndex >  #self.m_tCurrentList then    
			return
		end 
		local celElement,tCell
		--如果已经有cell，不创建，直接设置数据
		if tableContainer:getCellElement(self.m_nCurrentCellIndex-1) == nil then
			celElement,tCell = CellUnionList:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement:setTag(self.m_nCurrentCellIndex-1)    --从0开始设置Tag值
				tableContainer:setCellElement(celElement)
			end 
			if self.turnPage == "down" then
				if self.pageNumber == 2 then
       				tableContainer:getMoveElement():setPositionY(tableContainer:getMinPosition().y+41.0638*2*(5.6 + self.m_nOffsetNum))
				elseif self.pageNumber > 2 then
       				tableContainer:getMoveElement():setPositionY(tableContainer:getMinPosition().y+41.0638*2*(self.m_nOffsetNum - 3.4))
				end
			end
			if self.turnPage == "up" then
				if self.pageNumber == 1 then
       				tableContainer:getMoveElement():setPositionY(tableContainer:getMaxPosition().y-41.0638*2*(6.6 + self.m_nOffsetNum))
				elseif self.pageNumber > 1 then
       				tableContainer:getMoveElement():setPositionY(tableContainer:getMaxPosition().y-41.0638*2*(6.6))
				end
			end
			if self.m_bSwitchTab == true then
				self.m_bSwitchTab = false
       			tableContainer:getMoveElement():setPositionY(tableContainer:getMinPosition().y)
			end
			local tTempData = self.m_tCurrentList[self.m_nCurrentCellIndex]
			tCell:setCommunity1Context(tostring(tTempData.communityId), tTempData.communityName, tostring(tTempData.level), tTempData.presidentName, tTempData.setting, tTempData.vipLevel, tTempData.members, tTempData.fighting)
		else

		end
		self.m_nCurrentCellIndex = self.m_nCurrentCellIndex + 1 
	end 
end 

function WndUnionList:updatePlayerInfoData()

end

--@brief	取得表格本身引用的函数
function WndUnionList:_getTableContainer()
	if self.m_root == nil then WZLog("193:WndUnionList:_getTableContainer() is self.m is nil ") return end 
	local tbconContent = self.m_root:getChildElement("tbconContent_WndUnionList")
	if tbconContent ~= nil then 
		tbconContent = WZUITableContainer:luaTo(tbconContent)
		if tbconContent ~= nil then 
			return tbconContent
		end 
	end 
end 

--@brief	设置查找公会ID编辑框控件状态的函数
--@param 	#sString 要默认显示的内容
function WndUnionList:_setFindCommunityEditBoxPlaceHolder(sString)
	if self.m_root == nil then
		WZLog("WndFriend:setFindFriendEditBoxIsTouchEnable() self.m_root is nil ")
		return 
	end 
	local editInputId  = self.m_root:getChildElement("editInputId_WndUnionList")
	if editInputId ~= nil then 
		editInputId = WZUIEditBox:luaTo(editInputId)
		if editInputId ~= nil then 
			editInputId:setPlaceHolder(sString)
			if ProjConfig.LANGUAGE == "pt" then
				editInputId:setScale(0.8)
				editInputId:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			end
		end 
	end 
end 

--@brief	默认显示那个按钮可见的函数
--@param 	nTag 0为创建公会，1为我的公会可见
function WndUnionList:_setBtnCreateOrMyCommunistyVisable(nTag)
	WZLog("WndUnionList:_setBtnCreateOrMyCommunistyVisable(nTag)")
	if self.m_root == nil then 
		WZLog(" WndUnionList:setBtnCreateOrMyCommunistyVisable(nTag) self.m_root is nil ")
		return 
	end 
	--我的公会按钮
	local btnMyCommunity = self.m_root:getChildElement("btnMyCommunity_WndUnionList")
	if btnMyCommunity ~= nil then 
		btnMyCommunity = WZUIButton:luaTo(btnMyCommunity)
		if btnMyCommunity ~= nil then 
			if nTag == 1 then 
				WZLog("	btnMyCommunity:setVisible(true)")
				btnMyCommunity:setVisible(true)
			else 
				btnMyCommunity:setVisible(false)
			end 
		end 
	end 
	
	--创建公会按钮
	local btnCreateCommunity = self.m_root:getChildElement("btnCreateCommunity_WndUnionList")
	if btnCreateCommunity ~= nil then 
		btnCreateCommunity = WZUIButton:luaTo(btnCreateCommunity)
		if btnCreateCommunity ~= nil then 
			if nTag == 0 then 
				WZLog("btnCreateCommunity:setVisible(true)123")
				btnCreateCommunity:setVisible(true)
			else 
				btnCreateCommunity:setVisible(false)
			end 
		end 
	end 
end 

--@brief	设置查找公会EDITBOX控件是否可触摸的函数
--@param 	#bTag 如果为true为可触摸，如果为false则不可触摸
function WndUnionList:_setFindCommunityEditBoxIsTouchEnable(bTag)
	if self.m_root == nil then
		WZLog("WndUnionList:_setFindCommunityIdEditBoxIsTouchEnable(bTag) self.m_root is nil ")
		return 
	end 
	local editInputId  = self.m_root:getChildElement("editInputId_WndUnionList")
	if editInputId ~= nil then 
		editInputId = WZUIEditBox:luaTo(editInputId)
		if editInputId ~= nil then 
			editInputId:setTouchEnable(bTag)
		end 
	end 
end 

--@brief 	检测输入文字的长度
function WndUnionList:_checkInputTxtLen(txt)
	local nInputTxtLen, nSpaceCnt = WndBag:_checkInputTxtLen(txt)
	return nInputTxtLen, nSpaceCnt
end

--@brief	根据是否加入公会设置控件位置
--@param	inCommunity:是否加入公会
function WndUnionList:setElementPosition(inCommunity)
	local inCommunity = inCommunity or false
	if inCommunity == true then
		GetElement(self.m_root, "txtFirst_WndUnionList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.085,0.5))
		GetElement(self.m_root, "txtSecond_WndUnionList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.316,0.5))
		local txtThird = GetElement(self.m_root, "txtThird_WndUnionList", WZUILabelTTF)
		txtThird:setRelativePosition(GlobalMethod:ccp(0.635,0.5))
		local txtFouth = GetElement(self.m_root, "txtFouth_WndUnionList", WZUILabelTTF)
		GetElement(self.m_root, "txtFouth_WndUnionList", WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO196)
		txtFouth:setRelativePosition(GlobalMethod:ccp(0.696,0.5))
		-- local txtFive = GetElement(self.m_root, "txtFive_WndUnionList", WZUILabelTTF)
		-- txtFive:setRelativePosition(GlobalMethod:ccp(0.843,0.5))
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "cn" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "hk" then
			txtThird:setRelativePosition(GlobalMethod:ccp(0.635,0.5))
			txtFouth:setRelativePosition(GlobalMethod:ccp(0.86,0.5))
		end
	else
		GetElement(self.m_root, "txtFirst_WndUnionList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.085,0.5))
		GetElement(self.m_root, "txtSecond_WndUnionList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.32,0.5))
		local txtThird = GetElement(self.m_root, "txtThird_WndUnionList", WZUILabelTTF)
		txtThird:setRelativePosition(GlobalMethod:ccp(0.56,0.5))
		local txtFouth = GetElement(self.m_root, "txtFouth_WndUnionList", WZUILabelTTF)
		txtFouth:setRelativePosition(GlobalMethod:ccp(0.76,0.5))
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "cn" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "hk" then
			txtThird:setRelativePosition(GlobalMethod:ccp(0.52,0.5))
			txtFouth:setRelativePosition(GlobalMethod:ccp(0.71,0.5))
		end
	end
end

--@brief 初始化UI静态文本
function WndUnionList:_initStaticUiText()
	WZLog("WndUnionList:_initStaticUiText")
	if self.m_root == nil then WZLog("WndUnionList:_initStaticUiText() self.m_root is nil") return end 
	
	--请输入公会ID
	self:_setFindCommunityEditBoxPlaceHolder(LocalStrings.UNION_TEXT1[37])
	--排名
	local txtFirst = self.m_root:getChildElement("txtFirst_WndUnionList")
	if txtFirst ~= nil  then 
		WZUILabelTTF:luaTo(txtFirst):setText(LocalStrings.UNION_TEXT1[14])
	end 
	--名称
	local txtSecond = self.m_root:getChildElement("txtSecond_WndUnionList")
	if txtSecond ~= nil  then 
		WZUILabelTTF:luaTo(txtSecond):setText(LocalStrings.UNION_TEXT1[15])
	end 
	--ID
	local txtThird = self.m_root:getChildElement("txtThird_WndUnionList")
	if txtThird ~= nil  then 
		WZUILabelTTF:luaTo(txtThird):setText(LocalStrings.UNION_TEXT1[16])
	end 
	--等级
	local four = self.m_root:getChildElement("txtFouth_WndUnionList")
	if four ~= nil  then 
		local strTemp = string.gsub(LocalStrings.COMMUNITYINFO180, ":", "")
		WZUILabelTTF:luaTo(four):setText(strTemp)
	end 
	--我的公会
	local txtMyCommunity = self.m_root:getChildElement("txtMyCommunity_WndUnionList")
	if txtMyCommunity then
		txtMyCommunity = WZUILabelTTF:luaTo(txtMyCommunity)
		txtMyCommunity:setText(LocalStrings.UNION_TEXT1[44])
		txtMyCommunity:setVisible(true)
	end
	--创建公会
	local txtCreateCommunity = self.m_root:getChildElement("txtCreateCommunity_WndUnionList")
	if txtCreateCommunity then
		txtCreateCommunity = WZUILabelTTF:luaTo(txtCreateCommunity)
		txtCreateCommunity:setText(LocalStrings.UNION_TEXT1[2])
		txtCreateCommunity:setVisible(true)
	end

	local txtFresh = GetElement(self.m_root, "txtFresh_WndUnionList", WZUILabelTTF)
	if txtFresh then 
		txtFresh:setText(LocalStrings.CHARM_REFRESH)
	end
end 

--@brief	总排名
function WndUnionList:onTab1()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nTab == 1 then return end
	
	self:showDefaultList()
end

--@brief	通过协议获得公会列表
function WndUnionList:getGuildList(nPageNum)
	if self.m_nTab == 1 then
		self.m_nEachPageNum = EACH_PAGE_NUM
		ProtocolProcessorUnion:send_LEAGUE_GetLeagueList()
	elseif self.m_nTab == 2 then
		self.m_nEachPageNum = EACH_PAGE_NUM
		ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWeekRank(EACH_PAGE_NUM, nPageNum, 0 )
	elseif self.m_nTab == 3 then
		self.m_nEachPageNum = 50
		ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWeekRank(50, nPageNum, 1 )
	end
end

--@brief 	显示左边列表
function WndUnionList:_showLeftList()
	-- body
	local unionInfo = CacheCenter:getPlayerInfo().unionInfo

	if self.m_tRealItemList == nil then 
		self.m_tRealItemList = {}
		if unionInfo == nil or (unionInfo.id and unionInfo.id < 1) then
			self.m_tRealItemList = {{title = LocalStrings.UNION_TEXT1[31], uiId = 308, functionId = 230, mark = "rank"}}
		else
			local guildInfo = CacheCenter:getUnionInfo()
			local guildLevel
			if guildInfo == nil then
				guildLevel = WndUnionHall.m_nGuildLevel
			else
				guildLevel = guildInfo.guildLevel
			end
			for i = 1, #self.m_tLocalItemList do
				if CheckButtonOpen(self.m_tLocalItemList[i].functionId, true) then 
					if self.m_tLocalItemList[i].mark == "skill" then 
						if guildLevel and guildLevel >= 3 then 
							table.insert(self.m_tRealItemList, self.m_tLocalItemList[i])
						end
					elseif self.m_tLocalItemList[i].mark == "copy" then
						local open_level = 1
						for k,v in pairs(GDatatab_guild_building) do
							if v.type == 5 then
								open_level = v.open_level
							end
						end

						if guildLevel and guildLevel >= open_level then 
							table.insert(self.m_tRealItemList, self.m_tLocalItemList[i])
						end
					else
						table.insert(self.m_tRealItemList, self.m_tLocalItemList[i])
					end
				end
			end
		end
	end

	local tableItemList = GetElement(self.m_root, "tableItemList_WndUnionList", WZUITableContainer)
	tableItemList:cleanTable()
	self.m_tCellLeft = {}
	WZLog("WndUnionList:_showLeftList", #self.m_tRealItemList)
	for i = 1, #self.m_tRealItemList do
		local element, tNewObj = CellLeftUnionItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tRealItemList[i])

			tableItemList:setCellElement(element)

			if self.m_sSelMark == nil then 
				if self.m_tRealItemList[i].mark == "rank" then 
					tNewObj:setSelState(true)
					self.m_tCellSel = tNewObj
					self:onClickLeftBtnCallBack(self.m_tRealItemList[i].mark)
				end
			elseif self.m_sSelMark == self.m_tRealItemList[i].mark then 
				tNewObj:setSelState(true)
				self.m_tCellSel = tNewObj
				self:onClickLeftBtnCallBack(self.m_tRealItemList[i].mark)
			end

			self.m_tCellLeft[self.m_tRealItemList[i].mark] = tNewObj
		end
	end
end

--@brief 	显示默认榜
function WndUnionList:showDefaultList()
	--body
	self.m_nTab = 1 
	local con = self:_getTableContainer()
	con:disableSchedule()
	con:cleanTable()
	self.m_tAllCommunityList = {}
	self.pageNumber = 1 
	self.m_nOffsetNum = 0
	self.m_bSwitchTab = true


	self:getGuildList(0)
	GetElement(self.m_root, "txtThird_WndUnionList", WZUILabelTTF):setText(LocalStrings.UNION_TEXT1[16])
end

--@brief 	刷新冷却时间
function WndUnionList:freshCDTime(element)
	local txtFresh = GetElement(self.m_root, "txtFresh_WndUnionList", WZUILabelTTF)
	if txtFresh then 
		if self.m_nFreshCd > 0 then 
			self.m_nFreshCd = self.m_nFreshCd - 1
			txtFresh:setText(LocalStrings.MASTERINFO71 .. self.m_nFreshCd .. LocalStrings.SECOND)
		else
			element = WZUIButton:luaTo(element)
			element:setTouchEnable(true)
			element:disableSchedule()
			txtFresh:setText(LocalStrings.CHARM_REFRESH)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------


---------------------------------------------语言适配Begin-----------------------------------

function WndUnionList:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtCreateCommunity_WndUnionList",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtMyCommunity_WndUnionList",WZUILabelTTF):setScale(0.6)
end

---------------------------------------------语言适配End--------------------------------------
