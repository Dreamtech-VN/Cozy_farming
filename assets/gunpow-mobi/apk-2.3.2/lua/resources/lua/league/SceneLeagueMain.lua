--SceneLeagueMain.lua
--@brief	SceneLeagueMain的UI模块
--@date		2016/06/12
--@author	zsq
--@note		英雄联赛主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneLeagueMain:onEnter(element)
	self.m_root = element
	WndChat:addChatWindowToCurScene()
	GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change","state_scene")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneLeagueMain:onExit(element)
	self:_unInit()
	
end

--@brief	加载动画
function SceneLeagueMain:onEnterTransitionDidFinish(element)
	self.m_root:setVisible(true)
	self:AdaptResolution()
	self:_addTop()
	--开启下载检测
	GetElement(self.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer):enableSchedule("downloadFile",0.3)
	
	ProtocolProcessorWndLeague:send_HERO_HeroStartTime( )
	WZLog("SceneLeagueMain:showInterface", type(self.m_nJumpToTab), self.m_nJumpToTab)
	if self.m_nJumpToTab then
		local checkbox1 = GetElement(self.m_root, "checkbox1_SceneLeagueMain", WZUICheckBox)
		checkbox1:setCheckIndex(0)
		local checkbox2 = GetElement(self.m_root, "checkbox2_SceneLeagueMain", WZUICheckBox)
		checkbox2:setCheckIndex(1)
		SceneLeagueMain:onTab2()
	else
		self.m_nTab = 1
		WndLeagueMatch:show(GetElement(self.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer))
		ChangeChatChannel(Chat_Channel_League_Compete)
	end
	--延时显示成就特效
    ShowDelayAchie()
end

function SceneLeagueMain:onTouchBegan(element, pt)
	if not WndTips:checkPointInBtn(pt) then
		WndTips:onCloseClick()
	end
	if WndLeagueMatch and WndLeagueMatch.m_root ~= nil then
		WndLeagueMatch:updateBtnStatus()
	end

	if WndItemInfo.m_root then
		WndItemInfo:onCloseClick()
	end

	if WndTeamTips.m_root ~= nil and not WndTeamTips:checkPointInBtn(pt) then
		WndTeamTips:onCloseClick()
	end
	local bFlag = WndPopupMenu:ifPointInMenu( pt )--关闭菜单
	if bFlag == false then 
		WndPopupMenu:disappear()
	end 
end

function SceneLeagueMain:onTouchEnd()
	WndLeagueMatch:updateBtnStatus()
	--if WndPopupMenu.m_root ~= nil then
	--	WndPopupMenu:disappear()
	--end
	self:updateCheckBox()
end

function SceneLeagueMain:_addTop()
    local cell,tcell = CellTopHandle:createElement()
   self.m_root:addChild(cell,10)
   tcell:setTopData("ui/hero/common_icon_yxls.png",SceneLeagueMain,SceneLeagueMain.onCloseClick,true,1,false,"SceneLeagueMain")
	self.m_tTop = tcell
end

function SceneLeagueMain:onCloseClick()
	WZLog("SceneLeagueMain:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if WndLeagueTeamDetail.m_tData ~= nil and WndLeagueTeamDetail:idInTable(CacheCenter:getPlayerInfo().id,WndLeagueTeamDetail.m_tData.readyed) then
		MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
		return
	end
	--退出战队界面
	ProtocolProcessorWndLeague:send_HERO_OutHeroRoom()
    --WindowManager:removeWindow(self.m_root , self , true)
	replaceScene(SceneCity:createElement())
end

function SceneLeagueMain:hideAllSubWnd()
	if WndLeagueMatch.m_root ~= nil then WndLeagueMatch.m_root:setVisible(false) end
	if WndLeagueTeamList.m_root ~= nil then WndLeagueTeamList.m_root:setVisible(false) end
	if WndLeagueTeamDetail.m_root ~= nil then WndLeagueTeamDetail.m_root:setVisible(false) end
	if WndLeagueHPR.m_root ~= nil then WndLeagueHPR.m_root:removeFromParentAndCleanup(true) end
	self.m_tTop:setChatShow(true)
end

function SceneLeagueMain:updateCheckBox()
	for i=1,5 do
		GetElement(self.m_root, "checkbox"..i.."_SceneLeagueMain", WZUICheckBox):setCheckIndex(0)
	end
	if self.m_nTab ~= nil then
		GetElement(self.m_root, "checkbox"..self.m_nTab.."_SceneLeagueMain", WZUICheckBox):setCheckIndex(1)
	end
end
-------------------------------------公有方法模块End----------------------------------------

function SceneLeagueMain:onTab1(element)
	WZLog("SceneLeagueMain:onTab1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nTab == 1 then return end 
	if WndLeagueTeamDetail.m_tData ~= nil and WndLeagueTeamDetail:idInTable(CacheCenter:getPlayerInfo().id,WndLeagueTeamDetail.m_tData.readyed) then
		MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
		return
	end
	self.m_nTab = 1
	self:hideAllSubWnd()
	WndLeagueMatch:show(GetElement(self.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer))
	self.m_tTop:setChatShow(false)
	--退出战队界面
	ProtocolProcessorWndLeague:send_HERO_OutHeroRoom()
	if self.m_root:getChildElement("WndCurrentChat") then
		self.m_root:removeChild(self.m_root:getChildElement("WndCurrentChat"),true)
	end
end

function SceneLeagueMain:onTab2(element)
	WZLog("SceneLeagueMain:onTab2",CacheCenter:getPlayerInfo().teamId,type(CacheCenter:getPlayerInfo().teamId))
	
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nTab == 2 then return end 
	--if WndLeagueTeamDetail.m_tData ~= nil and WndLeagueTeamDetail:idInTable(CacheCenter:getPlayerInfo().id,WndLeagueTeamDetail.m_tData.readyed) then
	--	MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
	--	return
	--end
	self.m_nTab = 2
	self:hideAllSubWnd()

	if CacheCenter:getPlayerInfo().teamId == 0 then
		WndLeagueTeamList:show(GetElement(self.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer))
		WndLeagueTeamDetail.m_tData = nil
	else
		WndLeagueTeamDetail:show(GetElement(self.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer))
	end
	AddButtomChatToRoot(self.m_root:getLuaObjectName(),self.m_root)
end

function SceneLeagueMain:onTab3(element)
	WZLog("SceneLeagueMain:onTab3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nTab == 3 then return end 
	if WndLeagueTeamDetail.m_tData ~= nil and WndLeagueTeamDetail:idInTable(CacheCenter:getPlayerInfo().id,WndLeagueTeamDetail.m_tData.readyed) then
		MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
		return
	end
	self.m_nTab = 3
	self:hideAllSubWnd()
	WndLeagueHPR:showInterface(GetElement(self.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer), 3)
	self.m_tTop:setChatShow(false)
	--退出战队界面
	ProtocolProcessorWndLeague:send_HERO_OutHeroRoom()
	if self.m_root:getChildElement("WndCurrentChat") then
		self.m_root:removeChild(self.m_root:getChildElement("WndCurrentChat"),true)
	end
end

function SceneLeagueMain:onTab4(element)
	WZLog("SceneLeagueMain:onTab4")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nTab == 4 then return end 
	if WndLeagueTeamDetail.m_tData ~= nil and WndLeagueTeamDetail:idInTable(CacheCenter:getPlayerInfo().id,WndLeagueTeamDetail.m_tData.readyed) then
		MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
		return
	end
	self.m_nTab = 4
	self:hideAllSubWnd()
	WndLeagueHPR:showInterface(GetElement(self.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer), 4)
	self.m_tTop:setChatShow(false)
	--退出战队界面
	ProtocolProcessorWndLeague:send_HERO_OutHeroRoom()
	if self.m_root:getChildElement("WndCurrentChat") then
		self.m_root:removeChild(self.m_root:getChildElement("WndCurrentChat"),true)
	end
end

function SceneLeagueMain:onTab5(element)
	WZLog("SceneLeagueMain:onTab5")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nTab == 5 then return end 
	if WndLeagueTeamDetail.m_tData ~= nil and WndLeagueTeamDetail:idInTable(CacheCenter:getPlayerInfo().id,WndLeagueTeamDetail.m_tData.readyed) then
		MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
		return
	end
	self.m_nTab = 5
	self:hideAllSubWnd()
	WndLeagueHPR:showInterface(GetElement(self.m_root,"conCurWindow_SceneLeagueMain",WZUIContainer), 5)
	self.m_tTop:setChatShow(false)
	--退出战队界面
	ProtocolProcessorWndLeague:send_HERO_OutHeroRoom()
	if self.m_root:getChildElement("WndCurrentChat") then
		self.m_root:removeChild(self.m_root:getChildElement("WndCurrentChat"),true)
	end
end

--@brief 	获取联赛时间
function SceneLeagueMain:getLeagueTime()
	-- body
	return self.m_tTime
end
-------------------------------------私有方法模块Begin--------------------------------------
--@brief	显示接口
function SceneLeagueMain:show()
	WZLog("SceneLeagueMain:show")
	if self.m_root == nil then 
		replaceScene(SceneLeagueMain:createElement())
	end
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------下载文件管理Begin----------------------------------------
--@brief 	新增下载文件任务
--@param	fileName文件名,tCell1设置图片的Cell
function SceneLeagueMain:addDownloadFileList(fileName, tCell1, noUse, size)
	WZLog("WndSpaceMain:addDownloadFileList",fileName)
	if fileName == nil or fileName == "" then WZLog("文件名参数为nil") return end
	self.m_nSize = size
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..fileName
	--如果文件存在，不下载，直接使用
	local bExist = WZFileUtil:isFileExist(path)
	if bExist then
		WZLog("文件存在",tCell1)
		local fileError = false
		if tCell1 ~= nil then 
			tCell1:setFile(path) 
			if self.m_nSize ~= nil then
				local imgSize = tCell1:getContentSize()
				local x = self.m_nSize/imgSize.width 
				local y = self.m_nSize/imgSize.height
				WZLog("缩放比例",self.m_nSize,imgSize.width,imgSize.height,math.max(x,y))
				tCell1:setScale(math.max(x,y))
				if imgSize.width < 10 or imgSize.width > 1000 then fileError = true end
				if imgSize.height < 10 or imgSize.height > 1000 then fileError = true end
			end
		end
	else
		--在下载列表中新增记录
		if self.m_tDownloadFileList == nil then self.m_tDownloadFileList = {} end
		--检测是否是重复任务
		for i=1,#self.m_tDownloadFileList do
			if fileName == self.m_tDownloadFileList[i].fileName then
				WZLog("重复下载",fileName)
				return
			end
		end
		local tempTable = {fileName=fileName,tCell1=tCell1,status="init"}
		table.insert(self.m_tDownloadFileList,tempTable)
		WZLog("添加下载任务",Serialize(self.m_tDownloadFileList))
	end
end

--@brief	下载文件
function SceneLeagueMain:downloadFile(element,t)
	--WZLog("SceneLeagueMain:downloadFile")
	--列表中没有任务，返回
	if self.m_tDownloadFileList == nil or #self.m_tDownloadFileList == 0 then return end
	--有文件正在下载，返回
	for i=1,#self.m_tDownloadFileList do
		if self.m_tDownloadFileList[i].status=="downloading" then return end
	end
	--没有文件正在下载，开始下载第一个任务
	local fileName = self.m_tDownloadFileList[1].fileName
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..fileName
	local s = {}
	s.filePath = path
	s.objName = fileName
	DSSdkManager:downFile(json.encode(s),self.downloadFileFinish, self)
	WZLog("调用sdk下载文件",fileName)
	self.m_tDownloadFileList[1].status="downloading"
end

--@brief	下载成功回调
function SceneLeagueMain:downloadFileFinish(result)
	WZLog("WndSpaceMain:downloadFileFinish",result)
	if self.m_tDownloadFileList == nil or #self.m_tDownloadFileList == 0 then return end
	local result = json.decode(result)
	local fileName = result.objName
	--如果下载失败，把任务清出队列，返回
	WZLog("下载结果",result["return"])
	if result["return"] == "fail" then
		for i=1,#self.m_tDownloadFileList do
			if self.m_tDownloadFileList[i].status == "downloading" then
				table.remove(self.m_tDownloadFileList,i)
				return
			end
		end
	end 
	if fileName == nil then return end
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..result.objName
	WZLog("下载完成",path)

	for i=1,#self.m_tDownloadFileList do
		WZLog(i,self.m_tDownloadFileList[i],self.m_tDownloadFileList[i].fileName,fileName)
		if self.m_tDownloadFileList[i].fileName == fileName and self.m_tDownloadFileList[i].status == "downloading" then
			local x,y
			if self.m_tDownloadFileList[i].tCell1 ~= nil then
				local imgPhoto = self.m_tDownloadFileList[i].tCell1
				imgPhoto:setFile(path)
				local size = imgPhoto:getContentSize()
				local hh = 236
				if self.m_nSize ~= nil then hh = self.m_nSize end
				x = hh/size.width 
				y = hh/size.height
				imgPhoto:setScale(math.max(x,y))
			end
			--一次只下载一个文件,从列表中找到即可返回
			table.remove(self.m_tDownloadFileList,i)
			self.m_nSize = nil
			return
		end
	end
end
-------------------------------------下载文件管理End----------------------------------------
