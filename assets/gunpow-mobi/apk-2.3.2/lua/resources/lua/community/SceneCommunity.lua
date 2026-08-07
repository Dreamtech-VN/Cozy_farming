--SceneCommunity.lua
--@brief	SceneCommunity的UI模块
--@date		2013/12/23
--@author	zsq
--@note		公会列表


local CREATE_COMMUNITY_LEVEL = 15
local EACH_PAGE_NUM = 20
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCommunity:onEnter(element)
	self.m_root = element

	--初始化UI静态文本
	self:_initStaticUiText()
	--多语言版本界面适配
    AdaptLanguage(self)

	CacheCenter:registerUpatePlayerInfoObserver(self)

	self:_addTop()

	WZLog("我的公会名",CacheCenter:getPlayerInfo().guildName)
	WZLog("我的公会id",CacheCenter:getPlayerInfo().guildId)

	--玩家不是公会成员
	local guildId = CacheCenter:getPlayerInfo().guildId
	if guildId == nil or guildId < 1 then
    	ChangeChatChannel(Chat_Channel_Guild_Rank_N)
	else
    	ChangeChatChannel(Chat_Channel_Guild_Rank)
	end

	self:_showLeftList()
end

function SceneCommunity:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/community/common_icon_ghph.png",SceneCommunity,SceneCommunity.onClose,true,true,false,"SceneCommunity")
	self.m_tCellTop = tcell
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCommunity:onExit(element)
	self:_unInit()
	--add by wuweidong
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","SceneCommunity")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","SceneCommunity")
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
end

--@brief	关闭按钮
function SceneCommunity:onClose()
	WZLog("SceneCommunity:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    if self.m_root == nil then return end

	local guildId = CacheCenter:getPlayerInfo().guildId
	--玩家不是公会成员
	if guildId == nil or guildId < 1 then
        WindowManager:removeWindow(self.m_root, self, true)
	else
        WindowManager:removeWindow(self.m_root, self, true)
	end
end

--@brief	点击窗口
function SceneCommunity:onTouchBegan(element, pt)
	WZLog("SceneCommunity:onTouchBegan")
	if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end

    --隐藏掉落预览tips
    SceneCommunityCopy:checkWhetherHideRewardDrop(pt)
end

--@brief	点击创建公会按钮时
function SceneCommunity:onClickCreateCommunity(element)
	WZLog("SceneCommunity:onClickCreateCommunity(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--等级未达到15级或未转生不能建造公会(判断玩家等级是否满足创建等级)
	if CacheCenter:getPlayerInfo().level < CREATE_COMMUNITY_LEVEL then  
		--创建失败，淡入淡出提示
		MsgBoxManager:showTipBox(LocalStrings.NOT_REACH_LEVEL_CANNOT_BUILD_GUILD)
		return 
	end 

	--弹出创建公会的窗口
	WndCreateCommunity:onJumpToWndCreateCommunity(self.createCommunityBtn,self)
end 

--@brief	点击创建公会的回调函数 
--@param #sInputName  输入名字
function SceneCommunity:createCommunityBtn(sInputName)
	WZLog("SceneCommunity:createCommunityBtn")
	if sInputName == "" or sInputName == nil then 
		--请输入公会名字
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO2) 
		return 
	end 
	--local strLen = ChineseStringLen(sInputName)
	--检测公会名字合法性
	local m_nUseType = 2 	
	result = JudgeResultInClientForInputText(m_nUseType, sInputName)
	if result ~= 0 then 
		DisplayResult(result)
		return
	end

	self.m_sInputContent = sInputName
	local guildCreateCost = CacheCenter:getGameParam().guildCreateCost or "[70,300]"
	local ids,nums = SplitItemString(guildCreateCost)
	if not JudgeMoneyIsEnough(ids[1], nums[1], nil, nil, Chat_Channel_Guild_Create, nil, nil, nil, nil, self, self.clickSureMoney) then
		return 
	end
	self:clickSureMoney()
end 

--@brief	点击确定充值回调
function SceneCommunity:clickSureMoney()
    --创建公会
	ProtocolProcessorSceneCommunity:send_GUILD_CreateGuild(self.m_sInputContent)
	SceneCommunityMain:createLoading()
end

--@brief	点击我的公会按钮时
function SceneCommunity:onClickMyCommunityBtn(element)
	WZLog("SceneCommunity:onClickMyCommunityBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_bSendGetPlayerInfo = true

	--进入公会场景
   	replaceScene(SceneCommunityMain:createElement())
end 

--@brief	点击查找公会ID按钮时
function SceneCommunity:onClickFindCommunityId(element)
	WZLog(" SceneCommunity:onClickFindCommunityId(element)")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local inputText = nil 
	local editInputId  = self.m_root:getChildElement("editInputId_SceneCommunity")
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
		ProtocolProcessorSceneCommunity:send_GUILD_GetGuild(tonumber(inputText) )
	elseif inputText == LocalStrings.PLEASE_INPUT_COMMUNITY_ID or inputText == "" then 
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_COMMUNITY_ID)
	else  
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_ID_INPUT_MUST_ALL_NUMBER)
	end 
end 

--@brief	点击表格中相应容器（CELL）时的触发函数
--@param #1 element 容器本身铵钮表对象
--@param  #2 sId   公会ID
function SceneCommunity:onBtnClickEventByCellCommunitList(element,sId)
	WZLog("SceneCommunity:onBtnClickEventByCellCommunitList")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCellCommunityId = sId
	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
	--获取并显示公会信息
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuild(tonumber(sId) )

	self:_setFindCommunityEditBoxIsTouchEnable(false)
end 

--@brief	未加入公会的玩家跳转到公会列表的函数
function SceneCommunity:onJumpToCommunity()
	local guildId = CacheCenter:getPlayerInfo().guildId

	if guildId == nil or guildId < 1 then
		if SceneCommunity.m_root == nil then
			local sceneCommunity = SceneCommunity:createElement()
			WindowManager:addWindow(sceneCommunity,SceneCommunity)
			self:onTab1()
		end
        WZLog("SceneCommunity:onJumpToCommunity 1")
		SceneCommunity:_setBtnCreateOrMyCommunistyVisable(0)
	else
        WZLog("SceneCommunity:onJumpToCommunity 2")
		SceneCommunity:_setBtnCreateOrMyCommunistyVisable(1)
		replaceScene(SceneCommunityMain:createElement())
        ChangeChatChannel(Chat_Channel_Guild_Rank)
	end
end 

--@brief	已经加入公会的玩家跳转到公会列表的函数
function SceneCommunity:openCommunityList()
	local sceneCommunity = SceneCommunity:createElement()
	WindowManager:addWindow(sceneCommunity,SceneCommunity)
	self:onTab1()
end 

--@brief	跳转到周榜
function SceneCommunity:openCommunityList1()
	local sceneCommunity = SceneCommunity:createElement()
	WindowManager:addWindow(sceneCommunity,SceneCommunity)
	self:onTab2()
	GetElement(self.m_root, "checkGroup", WZUICheckBoxGroup):setCheckIndex(1)
end 

--@brief	跳转到历史榜
function SceneCommunity:openCommunityList2()
	local sceneCommunity = SceneCommunity:createElement()
	WindowManager:addWindow(sceneCommunity,SceneCommunity)
	self:onTab3()
	GetElement(self.m_root, "checkGroup", WZUICheckBoxGroup):setCheckIndex(2)
end 

--@brief	跳转到公会商城
function SceneCommunity:jumpToShop()
	local guildId = CacheCenter:getPlayerInfo().guildId
	local totemLevel = CacheCenter:getPlayerInfo().totemLevel
	if guildId == nil or guildId < 1 or totemLevel < 2 then
        WZLog("SceneCommunity:jumpToShop 1")
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO43,2))
		return false
	else
        WZLog("SceneCommunity:jumpToShop 2")
		SceneCommunity:_setBtnCreateOrMyCommunistyVisable(1)
   		replaceScene(SceneCommunityMain:createElement())
        ChangeChatChannel(Chat_Channel_Guild_Rank)
		SceneCommunityMain.jumpTo = "shop"
	end
end

--@brief	跳转到公会图腾
function SceneCommunity:jumpToTotem()
	local guildId = CacheCenter:getPlayerInfo().guildId
	if guildId == nil or guildId < 1 then
        WZLog("SceneCommunity:jumpToTotem 1")
		MsgBoxManager:showTipBox(string.format(LocalStrings.YOU_HAVE_NO_COMMUNITY,1))
		return false
	else
        WZLog("SceneCommunity:jumpToTotem 2")
		SceneCommunity:_setBtnCreateOrMyCommunistyVisable(1)
   		replaceScene(SceneCommunityMain:createElement())
        ChangeChatChannel(Chat_Channel_Guild_Rank)
		SceneCommunityMain.jumpTo = "totem"
	end
end

--@brief	跳转到公会大厅
function SceneCommunity:jumpToHall()
	local guildId = CacheCenter:getPlayerInfo().guildId
	if guildId == nil or guildId < 1 then
        WZLog("SceneCommunity:jumpToHall 1")
        if SceneCommunity.m_root == nil then
	        local sceneCommunity = SceneCommunity:createElement()
	        WindowManager:addWindow(sceneCommunity,SceneCommunity)
			self:onTab1()
	    end
        SceneCommunity:_setBtnCreateOrMyCommunistyVisable(0)
	--	MsgBoxManager:showTipBox(string.format(LocalStrings.YOU_HAVE_NO_COMMUNITY,1))
		return false
	else
        WZLog("SceneCommunity:jumpToHall 2")
		SceneCommunity:_setBtnCreateOrMyCommunistyVisable(1)
   		replaceScene(SceneCommunityMain:createElement())
        ChangeChatChannel(Chat_Channel_Guild_Rank)
		SceneCommunityMain.jumpTo = "hall"
	end
end

--@brief	跳转到公会副本
function SceneCommunity:jumpToCopy()
	local guildId = CacheCenter:getPlayerInfo().guildId
	if guildId == nil or guildId < 1 then
        WZLog("SceneCommunity:jumpToCopy 1")
        if SceneCommunity.m_root == nil then
	        local sceneCommunity = SceneCommunity:createElement()
	        WindowManager:addWindow(sceneCommunity,SceneCommunity)
			self:onTab1()
	    end
        SceneCommunity:_setBtnCreateOrMyCommunistyVisable(0)
	--	MsgBoxManager:showTipBox(string.format(LocalStrings.YOU_HAVE_NO_COMMUNITY,1))
		return false
	else
        WZLog("SceneCommunity:jumpToCopy 2")
		SceneCommunity:_setBtnCreateOrMyCommunistyVisable(1)
   		replaceScene(SceneCommunityMain:createElement())
        ChangeChatChannel(Chat_Channel_Guild_Rank)
		SceneCommunityMain.jumpTo = "copy"
	end
end

--@brief	往场景根节点添加元素的方法
--@param	element:要添加的界面元素引用
--@note		这里会修改showAll属性，为了适配不同分辨率，保证界面元素不会变形
--          注: 对于主场景showAll属性已经是true的时候不用修改元素的showAll
--          小岛界面有特殊需求，所以showAll属性为false，需要修改里面元素的showAll属性
function SceneCommunity:addChild(element)
    if self.m_root == nil or element == nil then
        return
    end
    element:setShowAll(true)
    self.m_root:addChild(element)
end

--@brief 	点击左边列表按钮回调
function SceneCommunity:onClickLeftBtnCallBack(mark, tCell)
	--body
	local conRank = GetElement(self.m_root, "conRank_SceneCommunity", WZUIContainer)
	local conOther = GetElement(self.m_root, "conOther_SceneCommunity", WZUIContainer)
	conRank:setVisible(false)
	conOther:setVisible(false)
	if tCell and self.m_tCellSel then 
		self.m_tCellSel:setSelState(false)
		self.m_tCellSel = tCell
	end
	if mark == "hall" then 
		conOther:setVisible(true)
		if SceneMemberList.m_root == nil then 
			conOther:removeAllChildrenWithCleanup(true)
			local sceneMemberList =  SceneMemberList:createElement()
			conOther:addChild(sceneMemberList)
			self:resetTopTitle("ui/community/common_icon_ghdt.png", self, self.onClose)
		else
			if GetElement(SceneMemberList.m_root,"conMain3",WZUIContainer):isVisible() then 
				self:resetTopTitle("ui/community/common_icon_ghgl.png", SceneMemberList, SceneMemberList.onNormal)
			else
				self:resetTopTitle("ui/community/common_icon_ghdt.png", self, self.onClose)
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
		self:resetTopTitle("ui/community/common_icon_ghph.png", self, self.onClose)
	elseif mark == "copy" then 
		conOther:setVisible(true)
		conOther:removeAllChildrenWithCleanup(true)
		local wndCopy = SceneCommunityCopy:createElement()
		conOther:addChild(wndCopy)
		self:resetTopTitle("ui/community/common_icon_ghfb.png", self, self.onClose)
	end
end

--@brief 	重新设置界面标题
function SceneCommunity:resetTopTitle(filePath, tCell, func)
	--body
	if self.m_tCellTop then 
		self.m_tCellTop:setTitleFile(filePath)
		if tCell and func then 
			self.m_tCellTop:setCallBackFunc(tCell, func)
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新场景时内容调用的函数（公会排名，公会ID，公会名称，公会等级，公会威望，胜利次数，胜率）
function SceneCommunity:_update()
	if self.m_root == nil then return end 
	
	--设置创建按钮可见还是我的公会按钮可见
	if CacheCenter:getPlayerInfo().guildId == nil or CacheCenter:getPlayerInfo().guildId < 1 then 
		self:_setBtnCreateOrMyCommunistyVisable(0)     --我的公会可见 
		self:setElementPosition(false)
	else 
		self:_setBtnCreateOrMyCommunistyVisable(1)     ---0为创建公会
		self:setElementPosition(true)
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
	WZLog("显示公会列表",Serialize(showList))
	self:_setTableContainerContent(tableContainer,showList)
end 


--@brief	点击上一页触发函数
--@param	element:表绑定的UI节点引用
function SceneCommunity:onPageUp(element)
	WZLog("SceneCommunity:onPageUp",self.pageNumber,self.totalNumber)
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
		--SceneCommunityMain:createLoading()
	end
	self.turnPage = "up"
end

--@brief	点击下一页触发函数
--@param	element:表绑定的UI节点引用
function SceneCommunity:onPageDown(element)
	WZLog("SceneCommunity:onPageDown",self.pageNumber,self.totalNumber)
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
		--SceneCommunityMain:createLoading()
	end
	self.turnPage = "down"
end

--@brief	根据从表中的内容来设置表格里内容的函数
--@param #1 tbconContainer  表格对象
--@param #2 tCellList		存取数据的表
function SceneCommunity:_setTableContainerContent(tbconContainer,tCellList)
	WZLog("SceneCommunity:setTableContainerContent(tbconContainer,tCellList)")
	if tbconContainer == nil or tCellList == nil then 
		return 
	end 
	--tbconContainer:cleanTable()
	removeShowPanelNullTip(GetElement(self.m_root,"conMain_SceneCommunity",WZUIContainer))
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
function SceneCommunity:scheduleCreateCell(element, delta)
	local element = self:_getTableContainer()
	
	if self.m_tCurrentList == nil then 
		element:disableSchedule()
		return 
	end  
	if #self.m_tCurrentList == 0 then
		ShowPanelNullTip( GetElement(self.m_root,"conMain_SceneCommunity",WZUIContainer))
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
	
	--取得公会名字
	local myCommunityName = CacheCenter:getPlayerInfo().guildName
	for var = 1,1 do 
		if self.m_nCurrentCellIndex >  #self.m_tCurrentList then    
			return
		end 
		local celElement,tCell
		--如果已经有cell，不创建，直接设置数据
		if tableContainer:getCellElement(self.m_nCurrentCellIndex-1) == nil then
			celElement,tCell = CellCommunityList:createElement()
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
			tCell:setCommunity1Context(tostring(self.m_tCurrentList[self.m_nCurrentCellIndex].rank),
									tostring(self.m_tCurrentList[self.m_nCurrentCellIndex].communityId),
									self.m_tCurrentList[self.m_nCurrentCellIndex].communityName,
									tostring(self.m_tCurrentList[self.m_nCurrentCellIndex].level),
									self.m_tCurrentList[self.m_nCurrentCellIndex].prestige,
									self.m_tCurrentList[self.m_nCurrentCellIndex].setting,
									self.m_tCurrentList[self.m_nCurrentCellIndex].vipLevel,
									self.m_tCurrentList[self.m_nCurrentCellIndex].members)
			--自己公会且是第一行字体就设为红色(绿色)	
			if myCommunityName ~= nil and tonumber(self.m_nCurrentCellIndex) == 1 and tostring(self.m_tCurrentList[self.m_nCurrentCellIndex].communityName) == tostring(myCommunityName) and self.pageNumber == 1 then 
				WZLog("tCell:setFontWithRedColor()")
				
				tCell:setGreen()
			end 
		else

		end
		self.m_nCurrentCellIndex = self.m_nCurrentCellIndex + 1 
	end 
end 

function SceneCommunity:updatePlayerInfoData()

end

--@brief	取得表格本身引用的函数
function SceneCommunity:_getTableContainer()
	if self.m_root == nil then WZLog("193:SceneCommunity:_getTableContainer() is self.m is nil ") return end 
	local tbconContent = self.m_root:getChildElement("tbconContent_SceneCommunity")
	if tbconContent ~= nil then 
		tbconContent = WZUITableContainer:luaTo(tbconContent)
		if tbconContent ~= nil then 
			return tbconContent
		end 
	end 
end 

--@brief	设置查找公会ID编辑框控件状态的函数
--@param 	#sString 要默认显示的内容
function SceneCommunity:_setFindCommunityEditBoxPlaceHolder(sString)
	if self.m_root == nil then
		WZLog("WndFriend:setFindFriendEditBoxIsTouchEnable() self.m_root is nil ")
		return 
	end 
	local editInputId  = self.m_root:getChildElement("editInputId_SceneCommunity")
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
function SceneCommunity:_setBtnCreateOrMyCommunistyVisable(nTag)
	WZLog("SceneCommunity:_setBtnCreateOrMyCommunistyVisable(nTag)")
	if self.m_root == nil then 
		WZLog(" SceneCommunity:setBtnCreateOrMyCommunistyVisable(nTag) self.m_root is nil ")
		return 
	end 
	--我的公会按钮
	local btnMyCommunity = self.m_root:getChildElement("btnMyCommunity_SceneCommunity")
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
	local btnCreateCommunity = self.m_root:getChildElement("btnCreateCommunity_SceneCommunity")
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
function SceneCommunity:_setFindCommunityEditBoxIsTouchEnable(bTag)
	if self.m_root == nil then
		WZLog("SceneCommunity:_setFindCommunityIdEditBoxIsTouchEnable(bTag) self.m_root is nil ")
		return 
	end 
	local editInputId  = self.m_root:getChildElement("editInputId_SceneCommunity")
	if editInputId ~= nil then 
		editInputId = WZUIEditBox:luaTo(editInputId)
		if editInputId ~= nil then 
			editInputId:setTouchEnable(bTag)
		end 
	end 
end 

--@brief 	检测输入文字的长度
function SceneCommunity:_checkInputTxtLen(txt)
	local nInputTxtLen, nSpaceCnt = WndBag:_checkInputTxtLen(txt)
	return nInputTxtLen, nSpaceCnt
end

--@brief	根据是否加入公会设置控件位置
--@param	inCommunity:是否加入公会
function SceneCommunity:setElementPosition(inCommunity)
	local inCommunity = inCommunity or false
	if inCommunity == true then
		GetElement(self.m_root, "txtFirst_SceneCommunity", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.085,0.55))
		GetElement(self.m_root, "txtSecond_SceneCommunity", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.316,0.55))
		local txtThird = GetElement(self.m_root, "txtThird_SceneCommunity", WZUILabelTTF)
		txtThird:setRelativePosition(GlobalMethod:ccp(0.635,0.55))
		local txtFouth = GetElement(self.m_root, "txtFouth_SceneCommunity", WZUILabelTTF)
		GetElement(self.m_root, "txtFouth_SceneCommunity", WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO196)
		txtFouth:setRelativePosition(GlobalMethod:ccp(0.696,0.55))
		-- local txtFive = GetElement(self.m_root, "txtFive_SceneCommunity", WZUILabelTTF)
		-- txtFive:setRelativePosition(GlobalMethod:ccp(0.843,0.55))
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "cn" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "hk" then
			txtThird:setRelativePosition(GlobalMethod:ccp(0.635,0.5))
			txtFouth:setRelativePosition(GlobalMethod:ccp(0.86,0.5))
		end
		-- elseif ProjConfig.LANGUAGE == "es" then
		-- 	txtFive:setRelativePosition(GlobalMethod:ccp(0.87,0.55))
		-- 	txtFive:setFontSize(16)
		-- 	txtFive:setDimensions(GlobalMethod:CCSize(150))
		-- end
	else
		GetElement(self.m_root, "txtFirst_SceneCommunity", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.085,0.55))
		GetElement(self.m_root, "txtSecond_SceneCommunity", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.286,0.55))
		local txtThird = GetElement(self.m_root, "txtThird_SceneCommunity", WZUILabelTTF)
		txtThird:setRelativePosition(GlobalMethod:ccp(0.485,0.55))
		local txtFouth = GetElement(self.m_root, "txtFouth_SceneCommunity", WZUILabelTTF)
		txtFouth:setRelativePosition(GlobalMethod:ccp(0.595,0.55))
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "cn" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "hk" then
			txtThird:setRelativePosition(GlobalMethod:ccp(0.52,0.5))
			txtFouth:setRelativePosition(GlobalMethod:ccp(0.71,0.5))
		end
		-- local txtFive = GetElement(self.m_root, "txtFive_SceneCommunity", WZUILabelTTF)
		-- txtFive:setRelativePosition(GlobalMethod:ccp(0.706,0.55))
		-- if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "vn" then
		-- 	if self.m_nTab == 2 or self.m_nTab == 3 then
		-- 		txtFive:setRelativePosition(GlobalMethod:ccp(0.76,0.55))
		-- 	end
		-- elseif ProjConfig.LANGUAGE == "es" then
		-- 	txtFive:setRelativePosition(GlobalMethod:ccp(0.76,0.55))
		-- 	txtFive:setFontSize(16)
		-- 	txtFive:setDimensions(GlobalMethod:CCSize(150))
		-- end
	end
end

--@brief 初始化UI静态文本
function SceneCommunity:_initStaticUiText()
	WZLog("SceneCommunity:_initStaticUiText")
	if self.m_root == nil then WZLog("SceneCommunity:_initStaticUiText() self.m_root is nil") return end 
	
	--请输入公会ID
	self:_setFindCommunityEditBoxPlaceHolder(LocalStrings.PLEASE_INPUT_COMMUNITY_ID)
	--排名
	local txtFirst = self.m_root:getChildElement("txtFirst_SceneCommunity")
	if txtFirst ~= nil  then 
		if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" then
			WZUILabelTTF:luaTo(txtFirst):setText(LocalStrings.RANK)
		else
			WZUILabelTTF:luaTo(txtFirst):setText(LocalStrings.COMMUNITY..LocalStrings.RANK)
		end
	end 
	--名称
	local txtSecond = self.m_root:getChildElement("txtSecond_SceneCommunity")
	if txtSecond ~= nil  then 
		
	    if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" then
			WZUILabelTTF:luaTo(txtSecond):setText(LocalStrings.QUALIFYING_NAME)
		else
			WZUILabelTTF:luaTo(txtSecond):setText(LocalStrings.COMMUNITY..LocalStrings.QUALIFYING_NAME)
		end
	end 
	--ID
	local txtThird = self.m_root:getChildElement("txtThird_SceneCommunity")
	if txtThird ~= nil  then 
		if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" then
			WZUILabelTTF:luaTo(txtThird):setText("ID")
		else
			WZUILabelTTF:luaTo(txtThird):setText(LocalStrings.COMMUNITY.."ID")
		end
		
	end 
	--等级
	local four = self.m_root:getChildElement("txtFouth_SceneCommunity")
	if four ~= nil  then 
		if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" then
			WZUILabelTTF:luaTo(four):setText(LocalStrings.LEVEL)
		else
			WZUILabelTTF:luaTo(four):setText(LocalStrings.COMMUNITY..LocalStrings.LEVEL)
		end
	end 
	--我的公会
	local txtMyCommunity = self.m_root:getChildElement("txtMyCommunity_SceneCommunity")
	if txtMyCommunity then
		txtMyCommunity = WZUILabelTTF:luaTo(txtMyCommunity)
		txtMyCommunity:setText(LocalStrings.MY_COMMUNITY)
		txtMyCommunity:setVisible(true)
	end
	--创建公会
	local txtCreateCommunity = self.m_root:getChildElement("txtCreateCommunity_SceneCommunity")
	if txtCreateCommunity then
		txtCreateCommunity = WZUILabelTTF:luaTo(txtCreateCommunity)
		txtCreateCommunity:setText(LocalStrings.CREATE_COMMUNITY)
		txtCreateCommunity:setVisible(true)
	end
end 

--@brief	总排名
function SceneCommunity:onTab1()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nTab == 1 then return end

	
	
	self:showDefaultList()
end

--@brief	周排名
function SceneCommunity:onTab2()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nTab == 2 then return end
	self.m_nTab = 2 
	local con = self:_getTableContainer()
	con:disableSchedule()
	con:cleanTable()
	self.m_tAllCommunityList = {}
	self.pageNumber = 1 
	self.m_nOffsetNum = 0
	self.m_bSwitchTab = true


	self:getGuildList(0)
	-- local txtFive = GetElement(self.m_root, "txtFive_SceneCommunity", WZUILabelTTF)
	-- txtFive:setText(LocalStrings.COMMUNITYINFO144)
	-- if ProjConfig.LANGUAGE == "pt" then
	-- 	txtFive:setRelativePosition(GlobalMethod:ccp(0.9,0.55))
	-- end
end

--@brief	历史排名
function SceneCommunity:onTab3()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nTab == 3 then return end
	self.m_nTab = 3
	local con = self:_getTableContainer()
	con:disableSchedule()
	con:cleanTable()
	self.m_tAllCommunityList = {}
	self.pageNumber = 1 
	self.m_nOffsetNum = 0
	self.m_bSwitchTab = true


	self:getGuildList(0)
	-- local txtFive = GetElement(self.m_root, "txtFive_SceneCommunity", WZUILabelTTF)
	-- txtFive:setText(LocalStrings.COMMUNITYINFO145)
	-- if ProjConfig.LANGUAGE == "pt" then
	-- 	txtFive:setRelativePosition(GlobalMethod:ccp(0.9,0.55))
	-- end
end

--@brief	通过协议获得公会列表
function SceneCommunity:getGuildList(nPageNum)
	if self.m_nTab == 1 then
		self.m_nEachPageNum = EACH_PAGE_NUM
		ProtocolProcessorSceneCommunity:send_GUILD_GetGuildList(EACH_PAGE_NUM, nPageNum )
	elseif self.m_nTab == 2 then
		self.m_nEachPageNum = EACH_PAGE_NUM
		ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWeekRank(EACH_PAGE_NUM, nPageNum, 0 )
	elseif self.m_nTab == 3 then
		self.m_nEachPageNum = 50
		ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWeekRank(50, nPageNum, 1 )
	end
end

--@brief 	显示左边列表
function SceneCommunity:_showLeftList()
	-- body
	local guildId = CacheCenter:getPlayerInfo().guildId

	if self.m_tRealItemList == nil then 
		self.m_tRealItemList = {}
		if guildId == nil or guildId < 1 then
			self.m_tRealItemList = {{title = LocalStrings.COMMUNITY_TEXT3, uiId = 30, functionId = 9, mark = "rank"}}
		else
			local guildInfo = CacheCenter:getGuildInfo()
			local guildLevel
			if guildInfo == nil then
				guildLevel = SceneMemberList.m_nGuildLevel
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

	local tableItemList = GetElement(self.m_root, "tableItemList_SceneCommunity", WZUITableContainer)
	tableItemList:cleanTable()
	WZLog("SceneCommunity:_showLeftList", #self.m_tRealItemList)
	for i = 1, #self.m_tRealItemList do
		local element, tNewObj = CellLeftBtnItem:createElement()
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
		end
	end
end

--@brief 	显示默认榜
function SceneCommunity:showDefaultList()
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
	GetElement(self.m_root, "txtThird_SceneCommunity", WZUILabelTTF):setText(LocalStrings.COMMUNITY_PRESTIGE)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------
function SceneCommunity:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtFirst_SceneCommunity",WZUILabelTTF):setText(LocalStrings.RANK)
	GetElement(self.m_root,"txtSecond_SceneCommunity",WZUILabelTTF):setText(LocalStrings.QUALIFYING_NAME)
	GetElement(self.m_root,"txtThird_SceneCommunity",WZUILabelTTF):setText("ID")
	GetElement(self.m_root,"txtFouth_SceneCommunity",WZUILabelTTF):setText(LocalStrings.LEVEL)
	--GetElement(self.m_root,"txtFive_SceneCommunity",WZUILabelTTF):setText(LocalStrings.PRESTIGE)
	local txt1 = GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF)
	--txt1:setDimensions(GlobalMethod:CCSize(100,0))
	txt1:setFontSize(18)
	local txt2 = GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF)
	--txt2:setDimensions(GlobalMethod:CCSize(100,0))
	txt2:setFontSize(18)

	local txtCreateCommunity = GetElement(self.m_root,"txtCreateCommunity_SceneCommunity",WZUILabelTTF)
	txtCreateCommunity:setScale(0.8)
end

function SceneCommunity:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtFirst_SceneCommunity",WZUILabelTTF):setScale(0.88)
	GetElement(self.m_root,"txtSecond_SceneCommunity",WZUILabelTTF):setScale(0.88)
	GetElement(self.m_root,"txtThird_SceneCommunity",WZUILabelTTF):setScale(0.88)
	GetElement(self.m_root,"txtFouth_SceneCommunity",WZUILabelTTF):setScale(0.88)
	
	for i=1,2 do
		local txtIntensify = GetElement(self.m_root,"txtIntensify"..i.."_WndStrengthen",WZUILabelTTF)
		txtIntensify:setScale(0.8)
		txtIntensify:setDimensions(GlobalMethod:CCSize(100,0))
	end
	
	for i=1,4 do
		local txtTransfer = GetElement(self.m_root,"txtTransfer"..i.."_WndStrengthen",WZUILabelTTF)
		txtTransfer:setScale(0.8)
		txtTransfer:setDimensions(GlobalMethod:CCSize(100,0))
	end

	local txtCreateCommunity = GetElement(self.m_root,"txtCreateCommunity_SceneCommunity",WZUILabelTTF)
	txtCreateCommunity:setScale(0.8)
end

function SceneCommunity:_adaptLanguage_th(  )
	-- GetElement(self.m_root,"txtFirst_SceneCommunity",WZUILabelTTF):setScale(0.6)
	-- GetElement(self.m_root,"txtSecond_SceneCommunity",WZUILabelTTF):setScale(0.6)
	-- GetElement(self.m_root,"txtThird_SceneCommunity",WZUILabelTTF):setScale(0.6)
	-- GetElement(self.m_root,"txtFouth_SceneCommunity",WZUILabelTTF):setScale(0.6)

	for i=1,2 do
		local txtIntensify = GetElement(self.m_root,"txtIntensify"..i.."_WndStrengthen",WZUILabelTTF)
		txtIntensify:setScale(0.8)
		txtIntensify:setDimensions(GlobalMethod:CCSize(100,0))
	end
	
	for i=1,4 do
		local txtTransfer = GetElement(self.m_root,"txtTransfer"..i.."_WndStrengthen",WZUILabelTTF)
		txtTransfer:setScale(0.8)
		txtTransfer:setDimensions(GlobalMethod:CCSize(100,0))
	end
end

function SceneCommunity:_adaptLanguage_pt(  )
	local txtCreateCommunity = GetElement(self.m_root,"txtCreateCommunity_SceneCommunity",WZUILabelTTF)
	txtCreateCommunity:setScale(0.8)
	local txtMyCommunity = GetElement(self.m_root,"txtMyCommunity_SceneCommunity",WZUILabelTTF)
	txtMyCommunity:setScale(0.8)
	local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
	txtIntensify1:setDimensions(GlobalMethod:CCSize(100,0))
	txtIntensify1:setFontSize(18)
	local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
	txtIntensify2:setDimensions(GlobalMethod:CCSize(100,0))
	txtIntensify2:setFontSize(18)

	local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
	txtTransfer1:setDimensions(GlobalMethod:CCSize(100,0))
	txtTransfer1:setFontSize(18)
	local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
	txtTransfer2:setDimensions(GlobalMethod:CCSize(100,0))
	txtTransfer2:setFontSize(18)

	local txtTransfer3 = GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF)
	txtTransfer3:setDimensions(GlobalMethod:CCSize(100,0))
	txtTransfer3:setFontSize(18)
	local txtTransfer4 = GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF)
	txtTransfer4:setDimensions(GlobalMethod:CCSize(100,0))
	txtTransfer4:setFontSize(18)

	local txtFirst = GetElement(self.m_root,"txtFirst_SceneCommunity",WZUILabelTTF)
	txtFirst:setFontSize(18)
	txtFirst:setDimensions(GlobalMethod:CCSize(110))
	local txtSecond = GetElement(self.m_root,"txtSecond_SceneCommunity",WZUILabelTTF)
	txtSecond:setFontSize(18)
	txtSecond:setDimensions(GlobalMethod:CCSize(110))
	local txtThird = GetElement(self.m_root,"txtThird_SceneCommunity",WZUILabelTTF)
	txtThird:setFontSize(18)
	txtThird:setDimensions(GlobalMethod:CCSize(110))
	local txtFouth = GetElement(self.m_root,"txtFouth_SceneCommunity",WZUILabelTTF)
	txtFouth:setFontSize(18)
	txtFouth:setDimensions(GlobalMethod:CCSize(110))
end

function SceneCommunity:_adaptLanguage_tr(  )
	local txtCreateCommunity = GetElement(self.m_root,"txtCreateCommunity_SceneCommunity",WZUILabelTTF)
	txtCreateCommunity:setScale(0.8)
	
	local txtMyCommunity = GetElement(self.m_root,"txtMyCommunity_SceneCommunity",WZUILabelTTF)
	txtMyCommunity:setScale(0.8)

	local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
	txtIntensify1:setDimensions(GlobalMethod:CCSize(100,0))
	txtIntensify1:setFontSize(18)

	local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
	txtIntensify2:setDimensions(GlobalMethod:CCSize(100,0))
	txtIntensify2:setFontSize(18)

	local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
	txtTransfer1:setDimensions(GlobalMethod:CCSize(100,0))
	txtTransfer1:setFontSize(18)

	local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
	txtTransfer2:setDimensions(GlobalMethod:CCSize(100,0))
	txtTransfer2:setFontSize(18)

	local txtTransfer3 = GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF)
	txtTransfer3:setDimensions(GlobalMethod:CCSize(100,0))
	txtTransfer3:setFontSize(18)

	local txtTransfer4 = GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF)
	txtTransfer4:setDimensions(GlobalMethod:CCSize(100,0))
	txtTransfer4:setFontSize(18)

	local txtFirst = GetElement(self.m_root,"txtFirst_SceneCommunity",WZUILabelTTF)
	txtFirst:setFontSize(18)
	txtFirst:setDimensions(GlobalMethod:CCSize(110))

	local txtSecond = GetElement(self.m_root,"txtSecond_SceneCommunity",WZUILabelTTF)
	txtSecond:setFontSize(18)
	txtSecond:setDimensions(GlobalMethod:CCSize(110))

	local txtThird = GetElement(self.m_root,"txtThird_SceneCommunity",WZUILabelTTF)
	txtThird:setFontSize(18)
	txtThird:setDimensions(GlobalMethod:CCSize(110))

	local txtFouth = GetElement(self.m_root,"txtFouth_SceneCommunity",WZUILabelTTF)
	txtFouth:setFontSize(18)
	txtFouth:setDimensions(GlobalMethod:CCSize(110))
end
function SceneCommunity:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtFirst_SceneCommunity",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtSecond_SceneCommunity",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtThird_SceneCommunity",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtFouth_SceneCommunity",WZUILabelTTF):setFontSize(18)

	-- local txtFive = GetElement(self.m_root,"txtFive_SceneCommunity",WZUILabelTTF)
	-- txtFive:setFontSize(16)
	-- txtFive:setDimensions(GlobalMethod:CCSize(150))
	-- txtFive:setRelativePosition(GlobalMethod:ccp(0.88,0.55))

	local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
	txtIntensify1:setDimensions(GlobalMethod:CCSize(100,0))
	txtIntensify1:setFontSize(18)
	local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
	txtIntensify2:setDimensions(GlobalMethod:CCSize(100,0))
	txtIntensify2:setFontSize(18)

	local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
	txtTransfer1:setDimensions(GlobalMethod:CCSize(100,0))
	txtTransfer1:setFontSize(18)
	local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
	txtTransfer2:setDimensions(GlobalMethod:CCSize(100,0))
	txtTransfer2:setFontSize(18)

	local txtTransfer3 = GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF)
	txtTransfer3:setDimensions(GlobalMethod:CCSize(100,0))
	txtTransfer3:setFontSize(18)
	local txtTransfer4 = GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF)
	txtTransfer4:setDimensions(GlobalMethod:CCSize(100,0))
	txtTransfer4:setFontSize(18)

	local txtCreateCommunity = GetElement(self.m_root,"txtCreateCommunity_SceneCommunity",WZUILabelTTF)
	txtCreateCommunity:setDimensions(GlobalMethod:CCSize(130,0))
	txtCreateCommunity:setScale(0.8)
end

function SceneCommunity:_adaptLanguage_ug(  )
	GetElement(self.m_root,"txtFirst_SceneCommunity",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtSecond_SceneCommunity",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtThird_SceneCommunity",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtFouth_SceneCommunity",WZUILabelTTF):setScale(0.6)

	local txtCreateCommunity = GetElement(self.m_root,"txtCreateCommunity_SceneCommunity",WZUILabelTTF)
	txtCreateCommunity:setScale(0.7)
	txtCreateCommunity:setDimensions(GlobalMethod:CCSize(160))
	local txtMyCommunity = GetElement(self.m_root,"txtMyCommunity_SceneCommunity",WZUILabelTTF)
	txtMyCommunity:setScale(0.7)
	txtMyCommunity:setDimensions(GlobalMethod:CCSize(160))

	local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
	txtIntensify1:setDimensions(GlobalMethod:CCSize(140,0))
	txtIntensify1:setScale(0.7)
	local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
	txtIntensify2:setDimensions(GlobalMethod:CCSize(140,0))
	txtIntensify2:setScale(0.7)
	local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
	txtTransfer1:setDimensions(GlobalMethod:CCSize(140,0))
	txtTransfer1:setScale(0.7)
	local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
	txtTransfer2:setDimensions(GlobalMethod:CCSize(140,0))
	txtTransfer2:setScale(0.7)
	local txtTransfer3 = GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF)
	txtTransfer3:setDimensions(GlobalMethod:CCSize(140,0))
	txtTransfer3:setScale(0.7)
	local txtTransfer4 = GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF)
	txtTransfer4:setDimensions(GlobalMethod:CCSize(140,0))
	txtTransfer4:setScale(0.7)
end
-------------------------------------语言适配模块End----------------------------------------
