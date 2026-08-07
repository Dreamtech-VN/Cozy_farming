--WndLeagueMatch.lua
--@brief	WndLeagueMatch的UI模块
--@date		2016/06/12
--@author	zsq
--@note		比赛界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLeagueMatch:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	加载完成
function WndLeagueMatch:onEnterTransitionDidFinish(element)
	self.m_nWndIndex = 1
	self:_setSpineAni()
	self:updateBtnStatus()
	self:update()
	self:setGameStartTag()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLeagueMatch:onExit(element)
	self:_unInit()
end

--@brief	显示接口
function WndLeagueMatch:show(parent)
	WZLog("WndLeagueMatch:show")
	if self.m_root == nil then 
		local wnd = WndLeagueMatch:createElement()
		parent:addChild(wnd)
	else
		self.m_root:setVisible(true)
		self:updateBtnStatus()
		self:update()
	end
end

function WndLeagueMatch:onWnd(element)
	WZLog("WndLeagueMatch:onWnd",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	--重复点击不响应
	if tag == self.m_nWndIndex then return end

	local timer = SceneLeagueMain.m_tTime
	if timer == nil then return end
	if tonumber(tag) == 2 then
		--小组赛
		if timer.nowTime <= SceneLeagueMain:transformStringToTime(timer.startTime32,false,true) then	
			MsgBoxManager:showTipBox(LocalStrings.LEAGUE41)	
			self:updateBtnStatus()
			return
		end
	elseif tonumber(tag) == 3 then
		--十六强
		if timer.nowTime <= SceneLeagueMain:transformStringToTime(timer.startTime16,false,true) then	
			MsgBoxManager:showTipBox(LocalStrings.LEAGUE41)	
			self:updateBtnStatus()
			return
		end
	elseif tonumber(tag) == 4 then
		--八强
		if timer.nowTime <= SceneLeagueMain:transformStringToTime(timer.startTime8,false,true) then	
			MsgBoxManager:showTipBox(LocalStrings.LEAGUE41)	
			self:updateBtnStatus()
			return
		end
	end

	self.m_nWndIndex = tag
	self:updateBtnStatus()
	self:update()
end

--@brief	更新按钮状态
function WndLeagueMatch:updateBtnStatus()
	if self.m_nWndIndex == nil then return end
	if self.m_root == nil then return end
	for i=1,5 do
		GetElement(self.m_root,"leftBtn"..i,WZUIButton):setButtonStatus(0)
	end
	GetElement(self.m_root,"leftBtn"..self.m_nWndIndex,WZUIButton):setButtonStatus(1)
end

function WndLeagueMatch:hideAllWnd()
	for i=1,5 do
		GetElement(self.m_root,"conRight"..i,WZUIContainer):setVisible(false)
	end
    local conPagination = GetElement(self.m_root, "conPagination", WZUIContainer)
	conPagination:removeAllChildrenWithCleanup(true)
end

--@brief	查看战队
function WndLeagueMatch:onCheck(element)
	WZLog("WndLeagueMatch:onCheck")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = self.m_tIdList[element:getTag()]
	if id ~= nil and id ~= 0 then
		SceneLeagueMain.m_nCheckType = 4
		SceneLeagueMain.m_tCheckWnd = WndLeagueMatch
		SceneLeagueMain.m_tCheckElement = GetElement(self.m_root,"btnFour",WZUIButton)
		SceneLeagueMain.m_tCheckPoint = ccp(100,100)
		ProtocolProcessorWndLeague:send_HERO_SearchTeam(id)
	end
end

--@brief	报名参赛
function WndLeagueMatch:onSignUp(element)
	WZLog("WndLeagueMatch:onSighUp")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--有战队,从服务器取队长id
	if CacheCenter:getPlayerInfo().teamId ~= 0 then
		SceneLeagueMain.m_nCheckType = 3
		ProtocolProcessorWndLeague:send_HERO_SearchTeam(CacheCenter:getPlayerInfo().teamId )
	end

	WndLeagueApply:show()
end

--@brief	前往比赛
function WndLeagueMatch:onMatch(element)
	WZLog("WndLeagueMatch:onMatch")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local checkbox1 = GetElement(SceneLeagueMain.m_root, "checkbox1_SceneLeagueMain", WZUICheckBox)
	checkbox1:setCheckIndex(0)
	local checkbox2 = GetElement(SceneLeagueMain.m_root, "checkbox2_SceneLeagueMain", WZUICheckBox)
	checkbox2:setCheckIndex(1)
	SceneLeagueMain:onTab2()
end

--@brief	设置比赛开始角标
function WndLeagueMatch:setGameStartTag()
	if self.m_root == nil then return end
	--显示进行中角标
	for i=1,4 do GetElement(self.m_root,"imgTag"..i,WZUI9Image):setVisible(false) end
	local timer = SceneLeagueMain.m_tTime
	if timer == nil then return end 
	WZLog("WndLeagueMatch:setGameStartTag", timer.nowTime)
	if timer.nowTime > SceneLeagueMain:transformStringToTime(timer.endTimeFThree,false,false) then 
		--赛季结束
	elseif timer.nowTime > SceneLeagueMain:transformStringToTime(timer.startTime8,false,true) then
		self.m_nWndIndex = 4
		GetElement(self.m_root,"imgTag4",WZUI9Image):setVisible(true)
	elseif timer.nowTime > SceneLeagueMain:transformStringToTime(timer.startTime16,false,true) then
		self.m_nWndIndex = 3
		GetElement(self.m_root,"imgTag3",WZUI9Image):setVisible(true)
	elseif timer.nowTime > SceneLeagueMain:transformStringToTime(timer.startTime32,false,true) then
		self.m_nWndIndex = 2
		GetElement(self.m_root,"imgTag2",WZUI9Image):setVisible(true)
	elseif timer.nowTime > SceneLeagueMain:transformStringToTime(timer.startTimeAll) then
		self.m_nWndIndex = 1
		GetElement(self.m_root,"imgTag1",WZUI9Image):setVisible(true)
	end

	--是否显示报名按钮 
	WZLog("报名开始时间",timer.startSignTime)
	if timer.nowTime > SceneLeagueMain:transformStringToTime(timer.startSignTime.." 00:00") and 
		timer.nowTime < SceneLeagueMain:transformStringToTime(timer.endSignTime.." 24:00") then
		GetElement(self.m_root,"btn2_WndLeagueMatch",WZUIButton):setVisible(true)
	else
		GetElement(self.m_root,"btn2_WndLeagueMatch",WZUIButton):setVisible(false)
		--GetElement(self.m_root,"btn2_WndLeagueMatch",WZUIButton):setVisible(true)
	end

	--跳转到当前比赛
	if self.m_nWndIndex ~= nil then
		self:hideAllWnd()
		self["updateWnd"..self.m_nWndIndex](self)
		self:updateBtnStatus()
	end
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
function WndLeagueMatch:update()
	WZLog("WndLeagueMatch:update")
	if self.m_nWndIndex == nil then return end

	self:hideAllWnd()
	self["updateWnd"..self.m_nWndIndex](self)
end

function WndLeagueMatch:updateWnd1()
	WZLog("WndLeagueMatch:updateWnd1")
	ProtocolProcessorWndLeague:send_HERO_FirstSelectRank()
end

function WndLeagueMatch:update1()
	if self.m_tDataList1 == nil then return end
	if 	self.m_nWndIndex ~= 1 then return end
	GetElement(self.m_root,"conRight1",WZUIContainer):setVisible(true)


	local freeListContainer = GetElement(self.m_root,"freeCon1_WndLeagueMatch",WZUIFreeListContainer)
	freeListContainer:removeAll()

	--没有数据时显示提示
	if self.m_tDataList1 == nil or #self.m_tDataList1 == 0 then 
		ShowPanelNullTip(freeListContainer,nil,GlobalMethod:ccc3(255,236,193))
	else
		removeShowPanelNullTip(freeListContainer)
	end

	for i=1,#self.m_tDataList1 do
		local celElement,tCell = CellLeagueRank:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tDataList1[i])
			freeListContainer:pushBack(celElement)
			freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
		end 
	end
	--标题
	GetElement(self.m_root,"ttfTitle1",WZUILabelTTF):setText(self.title1)
	--我的排名
	GetElement(self.m_root,"ttfMyRank",WZUILabelTTF):setText(self.myRank)
	--我的积分
	GetElement(self.m_root,"ttfMyScore",WZUILabelTTF):setText(self.myScore)
end

function WndLeagueMatch:updateWnd2()
	WZLog("WndLeagueMatch:updateWnd2")
	ProtocolProcessorWndLeague:send_HERO_TeamSelectRank()	
end

function WndLeagueMatch:update2()
	if self.m_tDataList2 == nil then return end
	if self.m_nWndIndex ~= 2 then return end
	GetElement(self.m_root,"conRight2",WZUIContainer):setVisible(true)

    local pgconCopy = GetElement(self.m_root, "pgCon2_WndLeagueMatch", WZUIPageContainer)
	pgconCopy:removeAll()
    pgconCopy:setMoveActionFinishCallback("onPageChanged2")
	--每帧加载一页
	self.m_nCurAddPage = 0
	pgconCopy:enableSchedule("_addPage2",0)
	self:onPageChanged2()
	self:_initPagination2(self.m_tData2.pageNumber-1)
end

--@brief	每帧加载一页
function WndLeagueMatch:_addPage2()
    local pgconCopy = GetElement(self.m_root, "pgCon2_WndLeagueMatch", WZUIPageContainer)
	local i = self.m_tData2.pageNumber - self.m_nCurAddPage
	--for i=self.m_tData2.pageNumber,1,-1 do
	if i >= 1 then
		local celElement,tCell = CellLeagueMatch1:createElement()
		if celElement ~= nil and tCell ~= nil then 
			WZLog("填充页面1",i)
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tDataList2,i)
			pgconCopy:setPageElement(self.m_nCurAddPage,celElement)
			self.m_nCurAddPage = self.m_nCurAddPage + 1
		end 
		if i == 1 then
			pgconCopy:disableSchedule()
		end
	end
	pgconCopy:setDefaultCenterPage(0)
end

--@brief	翻页时被调用的函数
function WndLeagueMatch:onPageChanged2()
    local pgconCopy = GetElement(self.m_root, "pgCon2_WndLeagueMatch", WZUIPageContainer)
	local pageNum = self.m_tData2.pageNumber - pgconCopy:getCurrentPageIndex()
	GetElement(self.m_root,"page2Title",WZUILabelTTF):setText(self.m_tData2["groupMatchTitle"..pageNum])
	WZLog("WndLeagueMatch:onPageChanged2",pgconCopy:getCurrentPageIndex(), self.m_tData2.pageNumber)
	self:_updatePagination(pgconCopy:getCurrentPageIndex(), self.m_tData2.pageNumber)
end

function WndLeagueMatch:updateWnd3()
	WZLog("WndLeagueMatch:updateWnd3")
	ProtocolProcessorWndLeague:send_HERO_Team16SelectStatus()
end

function WndLeagueMatch:update3()
	if self.m_tDataList3 == nil then return end
	if self.m_nWndIndex ~= 3 then return end
	GetElement(self.m_root,"conRight3",WZUIContainer):setVisible(true)

    local pgconCopy = GetElement(self.m_root, "pgCon3_WndLeagueMatch", WZUIPageContainer)
	pgconCopy:removeAll()
    pgconCopy:setMoveActionFinishCallback("onPageChanged3")
	--每帧加载一页
	self.m_nCurAddPage = 0
	pgconCopy:enableSchedule("_addPage3",0)
	self:onPageChanged3()
	self:_initPagination2(self.m_tData3.pageNumber-1)
end

--@brief	每帧加载一页
function WndLeagueMatch:_addPage3()
    local pgconCopy = GetElement(self.m_root, "pgCon3_WndLeagueMatch", WZUIPageContainer)
	local i = self.m_tData3.pageNumber - self.m_nCurAddPage
	--for i=self.m_tData3.pageNumber,1,-1 do
	if i >= 1 then
		local celElement,tCell = CellLeagueMatch2:createElement()
		if celElement ~= nil and tCell ~= nil then 
			WZLog("填充页面",i)
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tDataList3,i)
			pgconCopy:setPageElement(self.m_nCurAddPage,celElement)
			self.m_nCurAddPage = self.m_nCurAddPage + 1
		end 
		if i == 1 then
			pgconCopy:disableSchedule()
		end
	end
	pgconCopy:setDefaultCenterPage(0)
end

--@brief	翻页时被调用的函数
function WndLeagueMatch:onPageChanged3()
    local pgconCopy = GetElement(self.m_root, "pgCon3_WndLeagueMatch", WZUIPageContainer)
	local pageNum = self.m_tData3.pageNumber - pgconCopy:getCurrentPageIndex()
	GetElement(self.m_root,"page3Title",WZUILabelTTF):setText(self.m_tData3["top16MatcheTitle"..pageNum])
	self:_updatePagination(pgconCopy:getCurrentPageIndex(), self.m_tData3.pageNumber)
end

function WndLeagueMatch:updateWnd4()
	WZLog("WndLeagueMatch:updateWnd4")
	ProtocolProcessorWndLeague:send_HERO_Team8SelectStatus()
end

function WndLeagueMatch:updateWnd5()
	WZLog("WndLeagueMatch:updateWnd5")
	GetElement(self.m_root,"conRight5",WZUIContainer):setVisible(true)

    GetElement(self.m_root, "txtDesc", WZUIFreeTextBox):setShowText(LocalStrings.LEAGUE11)
	self:_upMoveContainerLayer()
end

--@brief  	更新滚动容器内部布局函数
function WndLeagueMatch:_upMoveContainerLayer()
	WZLog("self:_upMoveContainerLayer()")
	if self.m_root == nil then return end
	--获取规则说明内容文本的大小
	local txtExplanation = GetElement(self.m_root, "txtDesc", WZUIFreeTextBox)
	local txtSize = txtExplanation:getContentSize()	
	txtExplanation:setAnchorPoint(ccp(0,1))
	txtExplanation:setPositionY(txtSize.height)
	WZLog("富文本框尺寸是",txtSize.width,txtSize.height)
	
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize(1 , txtSize.height / rollSize.height ) )
	--moveElement:setContentSize(txtSize)
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
	WZLog("滚动容器大小",rollSize.width,rollSize.height)
end

--@brief	初始化页数标记
function WndLeagueMatch:_initPagination2(pageNum)
	WZLog("WndLeagueMatch:_initPagination2")
	if pageNum == nil then pageNum = 1 end
    local conPagination = GetElement(self.m_root, "conPagination", WZUIContainer)
    local conPagination2 = GetElement(self.m_root, "conPagination2", WZUIContainer)
	conPagination:removeAllChildrenWithCleanup(true)
    local nOffset = 5
    local size = GetElement(self.m_root, "imgPagination2"):getContentSize()
    local nX = 0
    local nY = 15
    for i = 0,pageNum do
        local img = CreateElement("imgPagination2")
        img:setVisible(true)
        nX = i*(size.width+nOffset)
        img:setAbsPosition(GlobalMethod:ccp(nX,nY))
        img:setName("imgPagination"..i.."_WndLeagueMatch")
        conPagination:addChild(img)
    end
    conPagination:setContentSize(GlobalMethod:CCSize(size.width*pageNum + nOffset*(pageNum-1),nY*2))
    local firstImg = GetElementWithoutAssert(conPagination, "imgPagination0_WndLeagueMatch", WZUIImage)
    if firstImg then
        firstImg:setFile("ui/common/common_icon_diandian2.png")
	end
end

--@brief	更新页数标记
--@param    nCurPageIndex:当前页数
function WndLeagueMatch:_updatePagination(nCurPageIndex, pageNum)
    local conPagination = GetElement(self.m_root, "conPagination", WZUIContainer)
    for i = 0,pageNum do
        local img = GetElementWithoutAssert(conPagination, "imgPagination"..i.."_WndLeagueMatch", WZUIImage)
        if img then
            if i == nCurPageIndex then
                img:setFile("ui/common/common_icon_diandian2.png")
            else
                img:setFile("ui/common/common_icon_diandian3.png")
            end
        end
    end
end

--@brief 	设置待机特效
function WndLeagueMatch:_setSpineAni()
	local spinePath = "ui/otherUI/ls_guanjun_01"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local aniFirst1 = GetElement(self.m_root, "aniFirst1", WZUISpine)
		local aniFirst2 = GetElement(self.m_root, "aniFirst2", WZUISpine)
		local aniFirst3 = GetElement(self.m_root, "aniFirst3", WZUISpine)
		if aniFirst1 then 
			aniFirst1:setFileJson(spinePath .. ".json")
			aniFirst1:setFileAtlas(spinePath .. ".atlas")
			aniFirst1:play("effects", true)
		end
		if aniFirst2 then 
			aniFirst2:setFileJson(spinePath .. ".json")
			aniFirst2:setFileAtlas(spinePath .. ".atlas")
			aniFirst2:play("wait", true)
		end
		if aniFirst3 then 
			aniFirst3:setFileJson(spinePath .. ".json")
			aniFirst3:setFileAtlas(spinePath .. ".atlas")
			aniFirst3:play("wait01", true)
		end
	end

	local spinePath2 = "ui/otherUI/ls_jijun"
	local existSpine2 = CheckEffectFile(spinePath2)
	if existSpine2 then 
		local aniSecond = GetElement(self.m_root, "aniSecond", WZUISpine)
		if aniSecond then 
			aniSecond:setFileJson(spinePath2 .. ".json")
			aniSecond:setFileAtlas(spinePath2 .. ".atlas")
			aniSecond:play("wait", true)
		end
	end

	local spinePath3 = "ui/otherUI/ls_yajun_01"
	local existSpine3 = CheckEffectFile(spinePath3)
	if existSpine3 then 
		local aniThird = GetElement(self.m_root, "aniThird", WZUISpine)
		if aniThird then 
			aniThird:setFileJson(spinePath3 .. ".json")
			aniThird:setFileAtlas(spinePath3 .. ".atlas")
			aniThird:play("wait", true)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
--------------------------------------语言适配Begin---------------------------------
function WndLeagueMatch:_adaptLanguage_vn(  )
	for i=1,3 do
		local txtLeft = GetElement(self.m_root,"txtLeft"..i.."_WndLeagueMathc",WZUILabelTTF)
		if txtLeft then
			txtLeft:setScale(0.8)
		end
	end
	local txtSignIn = GetElement(self.m_root,"txtSignIn_WndLeagueMatch",WZUILabelTTF)
	txtSignIn:setDimensions(GlobalMethod:CCSize(160,0))
	txtSignIn:setScale(0.65)
end
--------------------------------------语言适配End-----------------------------------