--WndLeagueMatchData.lua
--@brief	WndLeagueMatch的数据模块
--@date		2016/06/12
--@author	zsq
--@note		比赛界面

	local GAMENAME = {LocalStrings.LEAGUE_REPLAY_TEXT7,LocalStrings.LEAGUE_REPLAY_TEXT8..LocalStrings.LEAGUE19,LocalStrings.LEAGUE_REPLAY_TEXT8..LocalStrings.LEAGUE20,LocalStrings.LEAGUE_REPLAY_TEXT8..LocalStrings.LEAGUE21,LocalStrings.LEAGUE_REPLAY_TEXT9..LocalStrings.LEAGUE19,LocalStrings.LEAGUE_REPLAY_TEXT9..LocalStrings.LEAGUE20,LocalStrings.LEAGUE_REPLAY_TEXT9..LocalStrings.LEAGUE21,LocalStrings.LEAGUE_REPLAY_TEXT10..LocalStrings.LEAGUE19,LocalStrings.LEAGUE_REPLAY_TEXT10..LocalStrings.LEAGUE20,LocalStrings.LEAGUE_REPLAY_TEXT10..LocalStrings.LEAGUE21,LocalStrings.LEAGUE_REPLAY_TEXT11..LocalStrings.LEAGUE19,LocalStrings.LEAGUE_REPLAY_TEXT11..LocalStrings.LEAGUE20,LocalStrings.LEAGUE_REPLAY_TEXT11..LocalStrings.LEAGUE21,LocalStrings.LEAGUE_REPLAY_TEXT12..LocalStrings.LEAGUE19,LocalStrings.LEAGUE_REPLAY_TEXT12..LocalStrings.LEAGUE20,LocalStrings.LEAGUE_REPLAY_TEXT12..LocalStrings.LEAGUE21}

WndLeagueMatch = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLeagueMatch:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nWndIndex = nil
	self.m_tDataList1 = nil
	self.m_tDataList2 = nil
	self.m_tDataList3 = nil
	self.m_tDataList4 = nil
	self.myScore = nil
	self.myRank = nil
	self.title1 = nil
	self.m_tData2 = nil
	self.m_tData3 = nil
	self.m_tData4 = nil
	self.m_tIdList = nil
	self.m_nCurAddPage = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLeagueMatch:_unInit()
	self.m_root = nil
	self.m_nWndIndex = nil
	self.m_tDataList1 = nil
	self.m_tDataList2 = nil
	self.m_tDataList3 = nil
	self.m_tDataList4 = nil
	self.myScore = nil
	self.myRank = nil
	self.title1 = nil
	self.m_tData2 = nil
	self.m_tData3 = nil
	self.m_tData4 = nil
	self.m_tIdList = nil
	self.m_nCurAddPage = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLeagueMatch:createElement()
	local element = WZUISystem:getInstance():createElement("WndLeagueMatch")
	assert(element, "WndLeagueMatch create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	接收海选赛数据，更新界面
function WndLeagueMatch:setData1(myTeamId, myTeamScore, myTeamRank, startTime, endTime, teamIds, ranks, names, scores, successCount, totalCount, url)
	WZLog("WndLeagueMatch:setData1")
	self.m_tDataList1 = {}
	for i=1,#teamIds do
		local tempList = {}
		tempList.id = teamIds[i]
		tempList.rank = ranks[i]
		tempList.name = names[i]
		tempList.score = scores[i]
		tempList.url = url[i]
		tempList.winNum = successCount[i]
		tempList.totalCount = totalCount[i]
		if totalCount[i] == 0 then
			tempList.winRate = 0
		else
			tempList.winRate = math.floor(successCount[i]/totalCount[i]*100)
		end
		table.insert(self.m_tDataList1,tempList)
	end
	WZLog("WndLeagueMatch:setData1",Serialize(self.m_tDataList1))
	--self.m_tDataList1 = {{id=0,rank=1,name="hehe",score=99,url="",winNum=22,totalCount=32,winRate=77}}
	self.myScore = myTeamScore
	self.myRank = myTeamRank
	if self.myScore == nil then
		self.myScore = 0
	end
	if self.myRank == nil or self.myRank == 0 or self.myRank == -1 then
		self.myRank = LocalStrings.NONE
	end
	if SceneLeagueMain.m_tTime ~= nil then
		self.title1 = LocalStrings.LEAGUE18..":"..SceneLeagueMain.m_tTime.startDateAll.."-"..SceneLeagueMain.m_tTime.endDateAll
	end
	WZLog("海选赛时间",self.title1,myTeamScore,myTeamRank)
	
	self:update1()
end

--@brief	接收小组赛数据，更新界面
function WndLeagueMatch:setData2(firstStartTime, firstEndTime, secondStartTime, secondEndTime, thirdStartTime, thirdEndTime, teamId, successStatus, url)
	WZLog("WndLeagueMatch:setData2  小组赛",#teamId,Serialize(successStatus))
	self.m_tDataList2 = {}
	self.m_tData2 = {pageNumber=1}

	--测试数据
	--teamId = {}
	--successStatus = {}
	--url = {}
	--for i=1,32 do
	--	teamId[i] = 1000400
	--	successStatus[i] = "000"
	--	url[i] = "1060_13154_1468293569_photo1.png"
	--end
	--url[i] = "1002_13270_1468147578_teamIcon.png"

	for i=1,#teamId do
		local tempList = {}
		tempList.id = teamId[i]
		tempList.icon = url[i]
		tempList.position = i
		--successStatus[i] = "0"
		tempList.successStatus = successStatus[i]
		local length = string.len(successStatus[i])
		if length - 1 > self.m_tData2.pageNumber then
			if self.m_tData2.pageNumber ~= 4 then
				self.m_tData2.pageNumber = length - 1
			end
		end
		if length == 1 then
			tempList.round1 = ""
			tempList.round2 = ""
			tempList.round3 = ""
			tempList.round4 = ""
		elseif length == 2 then
			tempList.round1 = string.sub(successStatus[i],1,1)
			tempList.round2 = ""
			tempList.round3 = ""
			tempList.round4 = ""
		elseif length == 3 then
			tempList.round1 = string.sub(successStatus[i],1,1)
			tempList.round2 = string.sub(successStatus[i],2,2)
			tempList.round3 = ""
			tempList.round4 = ""
		elseif length == 4 then
			tempList.round1 = string.sub(successStatus[i],1,1)
			tempList.round2 = string.sub(successStatus[i],2,2)
			tempList.round3 = string.sub(successStatus[i],3,3)
			tempList.round4 = ""
			if string.sub(successStatus[i],4,4) == "1" then
				self.m_tData2.pageNumber = 4
				tempList.round4 = 3
			end
		end
		table.insert(self.m_tDataList2,tempList)
	end
	WZLog("WndLeagueMatch:setData2",Serialize(self.m_tDataList2))
	self.m_tData2.groupMatchTitle1 = SceneLeagueMain.m_tTimeList[3].."-"..string.sub(SceneLeagueMain.m_tTimeList[4],12,16).." "..LocalStrings.LEAGUE19
	self.m_tData2.groupMatchTitle2 = SceneLeagueMain.m_tTimeList[5].."-"..string.sub(SceneLeagueMain.m_tTimeList[6],12,16).." "..LocalStrings.LEAGUE20
	self.m_tData2.groupMatchTitle3 = SceneLeagueMain.m_tTimeList[7].."-"..string.sub(SceneLeagueMain.m_tTimeList[8],12,16).." "..LocalStrings.LEAGUE21
	self.m_tData2.groupMatchTitle4 = LocalStrings.BATTLE_RESULT
	
	self:update2()
end

--@brief	接收十六强数据，更新界面
function WndLeagueMatch:setData3(firstStartTime, firstEndTime, secondStartTime, secondEndTime, thirdStartTime, thirdEndTime, teamId, name, url, successStatus)
	WZLog("WndLeagueMatch:setData3")
	self.m_tDataList3 = {}
	self.m_tData3 = {pageNumber=1}

	--测试数据
	--teamId = {}
	--successStatus = {}
	--url = {}
	--name = {}
	--for i=1,16 do
	--	teamId[i] = 1000400
	--	name[i] = "teamName"..i..i
	--	successStatus[i] = "000"
	--	url[i] = "1060_13154_1468293569_photo1.png"
	--end

	for i=1,#teamId do
		local tempList = {}
		tempList.id = teamId[i]
		tempList.icon = url[i]
		tempList.name = name[i]
		tempList.position = i
		--successStatus[i] = "0"
		tempList.successStatus = successStatus[i]
		local length = string.len(successStatus[i])
		if length - 1 > self.m_tData3.pageNumber then
			if self.m_tData3.pageNumber ~= 4 then
				self.m_tData3.pageNumber = length - 1
			end
		end
		if length == 1 then
			tempList.round1 = ""
			tempList.round2 = ""
			tempList.round3 = ""
			tempList.round4 = ""
		elseif length == 2 then
			tempList.round1 = string.sub(successStatus[i],1,1)
			tempList.round2 = ""
			tempList.round3 = ""
			tempList.round4 = ""
		elseif length == 3 then
			tempList.round1 = string.sub(successStatus[i],1,1)
			tempList.round2 = string.sub(successStatus[i],2,2)
			tempList.round3 = ""
			tempList.round4 = ""
		elseif length == 4 then
			tempList.round1 = string.sub(successStatus[i],1,1)
			tempList.round2 = string.sub(successStatus[i],2,2)
			tempList.round3 = string.sub(successStatus[i],3,3)
			tempList.round4 = ""
			if string.sub(successStatus[i],4,4) == "1" then
				self.m_tData3.pageNumber = 4
				tempList.round4 = 3
			end
		end
		tempList.winNum = math.random(0,3)
		table.insert(self.m_tDataList3,tempList)
	end
	WZLog("WndLeagueMatch:setData3",Serialize(self.m_tDataList3))
	self.m_tData3.top16MatcheTitle1 = SceneLeagueMain.m_tTimeList[9].."-"..string.sub(SceneLeagueMain.m_tTimeList[10],12,16).." "..LocalStrings.LEAGUE19
	self.m_tData3.top16MatcheTitle2 = SceneLeagueMain.m_tTimeList[11].."-"..string.sub(SceneLeagueMain.m_tTimeList[12],12,16).." "..LocalStrings.LEAGUE20
	self.m_tData3.top16MatcheTitle3 = SceneLeagueMain.m_tTimeList[13].."-"..string.sub(SceneLeagueMain.m_tTimeList[14],12,16).." "..LocalStrings.LEAGUE21
	self.m_tData3.top16MatcheTitle4 = LocalStrings.BATTLE_RESULT
	
	self:update3()
end


--@brief	接收八强赛数据，更新界面
function WndLeagueMatch:setData4(firstStartTime8, firstEndTime8, secondStartTime8, secondEndTime, thirdStartTime8, thirdEndTime8, firstStartTime4, firstEndTime4, secondStartTime4, secondEndTime4, thirdStartTime4, thirdEndTime4, firstStartTime2, firstEndTime2, secondStartTime2, secondEndTime2, thirdStartTime2, thirdEndTime2, teamId8, name8, url8, teamId4, name4, url4, teamId2, name2, url2, teamIdFirst, namefirst, urlfirst, teamIdSecond, nameSecond, urlSecond, teamIdThird, nameThird, urlThird, version)
	WZLog("WndLeagueMatch:setData4")
	self.m_tDataList4 = {}

	--测试数据
	--teamId8 = {}
	--url8 = {}
	--name8 = {}
	--teamId4 = {}
	--url4 = {}
	--name4 = {}
	--teamId2 = {1000254,1000258}
	--url2 = {"1060_13154_1468293569_photo1.png","1060_13154_1468293569_photo1.png"}
	--name2 = {"name4","name8"}
	--teamId = 1000258
	--url = "1060_13154_1468293569_photo1.png"
	--name = "name8"
	--for i=1,8 do
	--	teamId8[i] = 1000250+i
	--	name8[i] = "name"..i
	--	url8[i] = "1060_13154_1468293569_photo1.png"
	--end
	--for i=1,4 do
	--	teamId4[i] = 1000250+i*2
	--	--teamId4[i] = 0
	--	name4[i] = "name"..i*2
	--	url4[i] = "1060_13154_1468293569_photo1.png"
	--end
	--teamIdFirst = 1000258
	--teamIdSecond = 1000256
	--teamIdThird = 1000254
	
	if self.m_nWndIndex ~= 4 then return end
	GetElement(self.m_root,"conRight4",WZUIContainer):setVisible(true)

	--重置线的状态
	for i=1,8 do
		GetElement(self.m_root,"line1"..i,WZUIImage):setFile("ui/hero/hero_icon_xiank1.png")
	end
	for i=1,4 do
		GetElement(self.m_root,"line2"..i,WZUIImage):setFile("ui/hero/hero_icon_xiank2.png")
	end

	GetElement(self.m_root,"img31",WZUIImage):setVisible(false)
	GetElement(self.m_root,"img32",WZUIImage):setVisible(false)
	GetElement(self.m_root,"img30",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.5,0.55))

	if name8 == nil or #name8 == 0 then 
		GetElement(self.m_root, "txt1Right4", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txt2Right4", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txt3Right4", WZUILabelTTF):setText("")
		return 
	end

	self.m_tIdList = {}
	for i=1,8 do
		self.m_tIdList[i] = teamId8[i]
	end
	for i=1,4 do
		self.m_tIdList[8+i] = teamId4[i]
	end
	self.m_tIdList[13] = teamIdThird
	self.m_tIdList[14] = teamIdSecond
	self.m_tIdList[15] = teamIdFirst

	--冠亚季军没出现之前不显示特效
	if teamIdThird == nil or teamIdThird == 0 then
		GetElement(self.m_root,"aniThird",WZUISpine):setVisible(false)
	else
		GetElement(self.m_root,"aniThird",WZUISpine):setVisible(true)
	end
	if teamIdSecond == nil or teamIdSecond == 0 then
		GetElement(self.m_root,"aniSecond",WZUISpine):setVisible(false)
	else
		GetElement(self.m_root,"aniSecond",WZUISpine):setVisible(true)
	end
	if teamIdFirst == nil or teamIdFirst == 0 then
		GetElement(self.m_root,"aniFirst1",WZUISpine):setVisible(false)
		GetElement(self.m_root,"aniFirst2",WZUISpine):setVisible(false)
		GetElement(self.m_root,"aniFirst3",WZUISpine):setVisible(false)
	else
		GetElement(self.m_root,"aniFirst1",WZUISpine):setVisible(true)
		GetElement(self.m_root,"aniFirst2",WZUISpine):setVisible(true)
		GetElement(self.m_root,"aniFirst3",WZUISpine):setVisible(true)
	end

	for i=1,#name8 do
		GetElement(self.m_root,"name"..i,WZUILabelTTF):setText(name8[i])
		GetElement(self.m_root,"name"..i,WZUILabelTTF):setColor(GlobalMethod:ccc3(229,105,22))
		if teamId8[i] == CacheCenter:getPlayerInfo().teamId then
		--if teamId8[i] == 1000269 then
			GetElement(self.m_root,"name"..i,WZUILabelTTF):setColor(GlobalMethod:ccc3(5,180,0))
		end
	end

	--设置线的状态
	if teamId4 ~= nil and #teamId4 ~= 0 and teamId8 ~= nil and #teamId8 ~= 0 then 
		for i=1,4 do
			if teamId4[i] == teamId8[i*2-1] then
				GetElement(self.m_root,"line1"..(i*2-1),WZUIImage):setFile("ui/hero/hero_icon_xiank1_sel.png")
			elseif teamId4[i] == teamId8[i*2] then
				GetElement(self.m_root,"line1"..(i*2),WZUIImage):setFile("ui/hero/hero_icon_xiank1_sel.png")
			end
		end
	end
	if teamId4 ~= nil and #teamId4 ~= 0 and teamId2 ~= nil and #teamId2 ~= 0 then 
		for i=1,2 do
			if teamId2[i] == teamId4[i*2-1] then
				GetElement(self.m_root,"line2"..(i*2-1),WZUIImage):setFile("ui/hero/hero_icon_xiank2_sel.png")
			elseif teamId2[i] == teamId4[i*2] then
				GetElement(self.m_root,"line2"..(i*2),WZUIImage):setFile("ui/hero/hero_icon_xiank2_sel.png")
			end
		end
	end
	--冠军亚军位置
	if self.m_tIdList[9] == teamIdSecond or self.m_tIdList[10] == teamIdSecond then
		GetElement(self.m_root,"btnSecond",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.43,0.385))
		GetElement(self.m_root,"btnThird",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.56,0.385))
	elseif self.m_tIdList[11] == teamIdSecond or self.m_tIdList[12] == teamIdSecond then
		GetElement(self.m_root,"btnSecond",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.56,0.385))
		GetElement(self.m_root,"btnThird",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.43,0.385))
	end
	--冠军线
	if self.m_tIdList[9] == teamIdFirst or self.m_tIdList[10] == teamIdFirst then
		GetElement(self.m_root,"img30",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.5,0.55))
		GetElement(self.m_root,"img31",WZUIImage):setVisible(true)
	elseif self.m_tIdList[11] == teamIdFirst or self.m_tIdList[12] == teamIdFirst then
		GetElement(self.m_root,"img30",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.495,0.55))
		GetElement(self.m_root,"img32",WZUIImage):setVisible(true)
	end
	--设置头像
	for i=1,8 do
		self:showIcon("conHead1"..i, url8[i], 55)
	end
	for i=1,4 do
		self:showIcon("conHead2"..i, url4[i], 55)
	end
	WZLog("WndLeagueMatch:setData40", urlThird, urlSecond, urlfirst)
	self:showIcon("conHead31", urlThird, 55)
	self:showIcon("conHead32", urlSecond, 55)
	self:showIcon("conHead33", urlfirst, 85)
	
	--显示比赛阶段
	local gameState = WndLeagueTeamDetail.m_nGameStage
	if gameState == nil then 
		GetElement(self.m_root, "txt1Right4", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txt2Right4", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txt3Right4", WZUILabelTTF):setText("")
		return 
	end
	local timeList = SceneLeagueMain.m_tTimeList
	local nowTime = SceneLeagueMain.m_tTime.nowTime
	if gameState <= 16 then
		GetElement(self.m_root,"txt1Right4",WZUILabelTTF):setText(GAMENAME[gameState])
		if WndLeagueTeamDetail.m_bGameStart == true then
			GetElement(self.m_root, "txt2Right4", WZUILabelTTF):setText("")
			GetElement(self.m_root, "txt3Right4", WZUILabelTTF):setText(LocalStrings.TASK_DOING)
			GetElement(self.m_root, "txt3Right4", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.045))
		else
			GetElement(self.m_root, "txt2Right4", WZUILabelTTF):setText(string.sub(timeList[gameState*2-1],12,16))
			GetElement(self.m_root, "txt3Right4", WZUILabelTTF):setText(LocalStrings.START)
			GetElement(self.m_root, "txt3Right4", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.51,0.045))
		end
	end
	--决赛结束后，不显示比赛阶段
	WZLog("决赛结束时间",SceneLeagueMain:transformStringToTime(timeList[32]),nowTime)
	if gameState > 16 then
		GetElement(self.m_root, "txt1Right4", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txt2Right4", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txt3Right4", WZUILabelTTF):setText("")
	end

	local version1 = version
	if version1 == nil or version1 == -1 then
		version1 = 1
	end
	GetElement(self.m_root,"page4Title",WZUILabelTTF):setText(string.format(LocalStrings.LEAGUE_HONOUR_TITLE1,tostring(version1)))
	GetElement(self.m_root,"name9",WZUILabelTTF):setText(namefirst)
	GetElement(self.m_root,"name9",WZUILabelTTF):setColor(GlobalMethod:ccc3(229,105,22))
end

--@brief	下载图片
function WndLeagueMatch:showIcon(conName, icon, size)
	--战队图标
	local con = GetElement(self.m_root,conName,WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	if icon ~= "" then 
		--添加下载图片Cell
		local celElement,tCell = CellDownloadImg:createElement()
		con:addChild(celElement)

		SceneLeagueMain:addDownloadFileList(icon, tCell, nil, size)
	end
end
-------------------------------------私有方法模块End----------------------------------------
