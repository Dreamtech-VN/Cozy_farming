--ScenePvpStrategicData.lua
--@brief	ScenePvpStrategic的数据模块
--@date		2022/12/07
--@author	yrd
--@note		战略赛

ScenePvpStrategic = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function ScenePvpStrategic:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nPvpMode = 2					--匹配模式 2:2v2 3:3v3
	self.m_bIsStartMatch = false		--正在匹配中
	self.m_nMarkTime = 0                --匹配倒计时

	self.m_nWin2PvpMode = 2				--窗口2匹配模式 2:2v2 3:3v3
	self.m_tWin2DataList = nil			--窗口2赛事信息数据列表
	self.m_tWin2ObjList = nil			--窗口2赛事信息对象列表

	self.m_nWin4PvpMode = 2				--窗口4匹配模式 2:2v2 3:3v3
	self.m_nWin4Type = 1				--窗口4界面类型 1:赛季排行 2:排行奖励
	self.m_tWin4Data1 = nil				--窗口4赛季排名格子数据
	self.m_tWin4Obj1 = nil				--窗口4赛季排名格子对象
	self.m_tWin4Data2 = nil				--窗口4排名奖励格子数据
	self.m_tWin4Obj2 = nil				--窗口4排名奖励格子对象

	self.m_tWin5DataList = nil 			--窗口5赛事奖励格式数据
	self.m_tWin5ObjList = nil 			--窗口5赛事奖励格式对象

	self.loadingId = nil

	self.m_nSkillPropNum = nil 			--技能和道具需要数量

	self.m_bIsFirstAddTop = true 		--是否第一次添加顶部栏
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function ScenePvpStrategic:_unInit()
	self.m_root = nil
	self.m_nPvpMode = nil
	self.m_bIsStartMatch = nil
	self.m_nMarkTime = nil

	self.m_nWin2PvpMode = nil
	self.m_tWin2DataList = nil
	self.m_tWin2ObjList = nil

	self.m_nWin4PvpMode = nil
	self.m_nWin4Type = nil
	self.m_tWin4Data1 = nil
	self.m_tWin4Obj1 = nil
	self.m_tWin4Data2 = nil
	self.m_tWin4Obj2 = nil

	self.m_tWin5DataList = nil
	self.m_tWin5ObjList = nil

	self.loadingId = nil

	self.m_nSkillPropNum = nil 			--技能和道具需要数量

	self.m_bIsFirstAddTop = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function ScenePvpStrategic:createElement()
	if ScenePvpStrategic.m_root ~= nil then
		WindowManager:removeWindow(ScenePvpStrategic.m_root, ScenePvpStrategic, true)
	end
	local element = WZUISystem:getInstance():createElement("ScenePvpStrategic")
	assert(element, "ScenePvpStrategic create element failed!")
	self:_init()
	return element
end


--@brief    判断是否开始快速匹配
function ScenePvpStrategic:getMatchState()
	if self.m_root == nil then return false end
	return self.m_bIsStartMatch 
end


--@brief    获取战略赛信息结果
function ScenePvpStrategic:getZlsBattleInfoOk(season, startDate, dayNum, openTimes, openDay2V2, openDay3V3, mode, level, star, score, skillIds, propIds, level2, star2, score2, skillIds2, propIds2, protectNum)
	if not self.m_root then
		return
	end

	self.season = season
	self.startDate = startDate
	self.dayNum = dayNum
	self.openTimes = openTimes
	self.openDay2V2 = openDay2V2
	self.openDay3V3 = openDay3V3
	self.mode = mode
	self.level = level
	self.star = star
	self.score = score
	self.skillIds = skillIds
	self.propIds = propIds
	self.level2 = level2
	self.star2 = star2
	self.score2 = score2
	self.skillIds2 = skillIds2
	self.propIds2 = propIds2
	self.protectNum = protectNum

	self.endDate = startDate+dayNum*86400-1

	self.m_nPvpMode = self.mode == 0 and 2 or self.mode

	if self:isSeasonOpenTime() and self:isDayOpenTime() then
	else
		if self.bIsFirstTips == nil then
			self.bIsFirstTips = true
			MsgBoxManager:showTipBox(LocalStrings.PVP_HALL_34)
		end
	end

	if self.m_bIsFirstAddTop == true then
		self.m_bIsFirstAddTop = nil
		self:_addTop()
	end
	self:updateZlsBattleInfo()
end


--@brief    获取战略赛技能道具池结果
function ScenePvpStrategic:getZlsSkillListOk(ids, skillIds, propIds, skillIds2, propIds2)
	self.tSkillPropIds = ids
	self.skillIds = skillIds
	self.propIds = propIds
	self.skillIds2 = skillIds2
	self.propIds2 = propIds2
end

--@brief    装备战略赛技能/道具结果
function ScenePvpStrategic:equipZlsSkillOk(result, doType, mode, ids)
	if self.m_root == nil then
		return
	end

	if result == 0 then
		if mode == 2 then
			if doType == 0 then
				self.skillIds = ids				
			elseif doType == 1 then
				self.propIds = ids
			end
		elseif mode == 3 then
			if doType == 0 then
				self.skillIds2 = ids				
			elseif doType == 1 then
				self.propIds2 = ids
			end
		end
		self:updatePlayerSkillProp()
	end
end

--@brief    获取战略赛历届赛季信息结果
function ScenePvpStrategic:getZlsSeasonInfoListOk(season, startDate, endDate, finishLevel, finishStar, maxLevel, maxStar, joinNum, winNum, mvpNum, assists, lianWinMax)
	if self.m_root == nil then
		return
	end
	
	if self.m_tWin2DataList == nil then
		self.m_tWin2DataList = {}
	end
	self.m_tWin2DataList[self.m_nWin2PvpMode] = {}
	for i=1,#season do
		local tempData = {}
		tempData.season = season[i]
		tempData.startDate = startDate[i]
		tempData.endDate = endDate[i]
		tempData.finishLevel = finishLevel[i]
		tempData.finishStar = finishStar[i]
		tempData.maxLevel = maxLevel[i]
		tempData.maxStar = maxStar[i]
		tempData.joinNum = joinNum[i]
		tempData.winNum = winNum[i]
		tempData.mvpNum = mvpNum[i]
		tempData.assists = assists[i]
		tempData.lianWinMax = lianWinMax[i]

		tempData.nType = 1
		table.insert(self.m_tWin2DataList[self.m_nWin2PvpMode],tempData)
	end

	self:updateWin2UI()
end

--@brief    获取排行榜结果
function ScenePvpStrategic:getZlsRankListOk(mode, rank, serverId, playerId, name, faceId, headId, headColour, sex, level, vipLevel, zlsLevel, zlsStar, zlsScore, battleTimes, winTimes, playerRank, playerZlsLevel, playerZlsStar, playerZlsSocre)
	if self.m_root == nil then
		return
	end

	if self.m_tWin4Data1 == nil then
		self.m_tWin4Data1 = {}
	end
	self.m_tWin4Data1[self.m_nWin4PvpMode] = {}
	for i = 1, #rank do
		local tItem = {}
		tItem.rank = rank[i]
		tItem.serverId = serverId[i]
		tItem.playerId = playerId[i]
		tItem.name = name[i]
		tItem.faceId = faceId[i]
		tItem.headId = headId[i]
		tItem.headColour = headColour[i]
		tItem.sex = sex[i]
		tItem.level = level[i]
		tItem.vipLevel = vipLevel[i]
		tItem.zlsLevel = zlsLevel[i]
		tItem.zlsStar = zlsStar[i]
		tItem.zlsScore = zlsScore[i]
		tItem.battleTime = battleTimes[i]
		tItem.winTime = winTimes[i]

		table.insert(self.m_tWin4Data1[self.m_nWin4PvpMode], tItem)
	end
	table.sort(self.m_tWin4Data1[self.m_nWin4PvpMode], function (a,b)
		return a.rank < b.rank 
	end)

	if self.m_tWin4MyData1 == nil then
		self.m_tWin4MyData1 = {}
	end
	self.m_tWin4MyData1[self.m_nWin4PvpMode] = {}
	self.m_tWin4MyData1[self.m_nWin4PvpMode].playerRank = playerRank
	self.m_tWin4MyData1[self.m_nWin4PvpMode].playerZlsLevel = playerZlsLevel
	self.m_tWin4MyData1[self.m_nWin4PvpMode].playerZlsStar = playerZlsStar
	self.m_tWin4MyData1[self.m_nWin4PvpMode].playerZlsSocre = playerZlsSocre

	self:updateWin4Rank1UI()
end



--@brief 	获取任务奖励
--@param 	nTaskID:任务ID
function ScenePvpStrategic:_getTaskRewards(nTaskID)
	local tRewardsNum = {}
	local tRewardsItemId = {}
	local tTaskData = GDatatab_task["id_"..nTaskID]
	for i=1,#tTaskData.reward do
		table.insert(tRewardsNum,tTaskData.reward[i][2])
		table.insert(tRewardsItemId,tTaskData.reward[i][1])
	end
	return tRewardsNum,tRewardsItemId
end

--@brief 	更新任务状态
--@param 	nTaskId:任务ID
--@param 	nTaskType:任务类型
--@param 	nTaskStatus:任务状态
function ScenePvpStrategic:updateTaskStatus(nTaskId, nTaskType, nTaskStatus, reward)
	WZLog("ScenePvpStrategic:updateTaskStatus",nTaskId)

	--更新战略赛任务数据
	if 10 == nTaskType or 11 == nTaskType then
		if self.m_tWin5DataList then
			for i=1,#self.m_tWin5DataList do
				if self.m_tWin5DataList[i].nId == nTaskId then
					local id = {}
					table.insert(id, self.m_tWin5DataList[i].nId)
					local status = {}
					table.insert(status, TASKSTATUS_COMPLETED)
					local target = {}
					table.insert(target, self.m_tWin5DataList[i].nTargetValue)
					local complete = {}
					table.insert(complete, self.m_tWin5DataList[i].nTargetStatus)
					PrefetchCache:updateTaskStatus(id, status, target, complete)
					break
				end
			end
		end
	end

	if self.m_root == nil then
		return
	end
	self:showRedDot()
	if self.m_tWin5DataList == nil then
		return
	end

	if 10 == nTaskType or 11 == nTaskType then
		local tRewardsNum
		local tRewardsItemId
		if reward then 
			tRewardsItemId, tRewardsNum = SplitItemString(reward)
		else
			tRewardsNum,tRewardsItemId = self:_getTaskRewards(nTaskId)
		end
		WndRewardShow:showById(tRewardsItemId,tRewardsNum,nil,nTaskId)
		self:showWin5UI()
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------




-------------------------------------赛事信息格子begin----------------------------------------

CellPvpStrategicWin2Grid = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellPvpStrategicWin2Grid:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil					--数据 nType:1合上状态,2展开状态

	self.m_tSize = {{276,410},{866,410}}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPvpStrategicWin2Grid:_unInit()
	self.m_root = nil
	self.m_tData = nil

	self.m_tSize = nil
end

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellPvpStrategicWin2Grid:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPvpStrategicWin2Grid")
	assert(element, "CellPvpStrategicWin2Grid create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPvpStrategicWin2Grid:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpStrategicWin2Grid:setData(tData)
	self.m_tData = tData
	self:updateUI()
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpStrategicWin2Grid:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpStrategicWin2Grid:onExit(element)
	self:_unInit()
end

--@brief	刷新界面
function CellPvpStrategicWin2Grid:updateUI()
	local con1 = GetElement(self.m_root,"con1_CellPvpStrategicWin2Grid",WZUIContainer)
	local con2 = GetElement(self.m_root,"con2_CellPvpStrategicWin2Grid",WZUIContainer)
	local imgArrow = GetElement(self.m_root,"imgArrow_CellPvpStrategicWin2Grid",WZUIImage)

	self.m_root:setAbsContentSize(GlobalMethod:CCSize(self.m_tSize[self.m_tData.nType][1],self.m_tSize[self.m_tData.nType][2]))
	self.m_root:updateRelativeSize()
	if self.m_tData.nType == 1 then
		con2:setVisible(false)
		imgArrow:setFlipX(false)
	elseif self.m_tData.nType == 2 then
		con2:setVisible(true)
		imgArrow:setFlipX(true)
	end

	local tCurLevelInfo = GetZlsPvpDataByLevel(self.m_tData.finishLevel)
	local spinePath = "ui/zls/" .. tCurLevelInfo.animation
    local existSpine = CheckEffectFile(spinePath)
	local imgIcon = GetElement(self.m_root,"imgIcon_CellPvpStrategicWin2Grid",WZUIImage)
    if existSpine then 
		local spineIcon = GetElement(self.m_root,"spineIcon_CellPvpStrategicWin2Grid",WZUISpine)
		spineIcon:setFileJson(spinePath .. ".json")
		spineIcon:setFileAtlas(spinePath .. ".atlas")
		spineIcon:play(tCurLevelInfo.action,true)
		imgIcon:setVisible(false)
	else
		imgIcon:setFile("ui/common/"..tCurLevelInfo.icon..".png")
		imgIcon:setVisible(true)
	end
	GetElement(self.m_root,"txtName_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(tCurLevelInfo.name)
	GetElement(self.m_root,"txtTime_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(SystemTime:getTimeConverLocal(self.m_tData.startDate).."-"..SystemTime:getTimeConverLocal(self.m_tData.endDate))

	--星星
	local formatStar = [[<I Z="0.6" P="1">ui/common/common_icon_xingxing5.png</I><T C="127,70,26" S="20" P="1">x%d</T>]]
	local ftbStar = GetElement(self.m_root,"ftbStar_CellPvpStrategicWin2Grid",WZUIFreeTextBox)
	ftbStar:setShowText("")
	if tCurLevelInfo.id == 999 and self.m_tData.finishStar > 0 then
		ftbStar:setShowText(string.format(formatStar,self.m_tData.finishStar))
	end

	GetElement(self.m_root,"txtTitleWord1_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[13])
	GetElement(self.m_root,"txtTitleWord2_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[14])
	GetElement(self.m_root,"txtTitleWord3_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(LocalStrings.WIN_RATE)
	GetElement(self.m_root,"txtTitleWord4_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[15])
	GetElement(self.m_root,"txtTitleWord5_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[16])
	GetElement(self.m_root,"txtTitleWord6_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[17])

	GetElement(self.m_root,"txtTitleValue1_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(self.m_tData.joinNum)
	GetElement(self.m_root,"txtTitleValue2_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(self.m_tData.winNum)
	GetElement(self.m_root,"txtTitleValue3_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(string.format("%.2d%%",self.m_tData.winNum/self.m_tData.joinNum*100))
	GetElement(self.m_root,"txtTitleValue4_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(self.m_tData.mvpNum)
	GetElement(self.m_root,"txtTitleValue5_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(self.m_tData.assists)
	GetElement(self.m_root,"txtTitleValue6_CellPvpStrategicWin2Grid",WZUILabelTTF):setText(self.m_tData.lianWinMax)
end

--@brief 	设置按钮回调
function CellPvpStrategicWin2Grid:setCallback(tCell, func)
	self.m_tCallBackFun = {}
	self.m_tCallBackFun[1] = tCell
	self.m_tCallBackFun[2] = func
end

--@brief	点击格子
function CellPvpStrategicWin2Grid:onClickWin2Grid(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tCallBackFun and #self.m_tCallBackFun > 0 then
		self.m_tCallBackFun[2](self.m_tCallBackFun[1], self)
	end
end

-------------------------------------赛事信息格子end----------------------------------------

-------------------------------------段位详情格子begin----------------------------------------

CellPvpStrategicWin3Grid = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellPvpStrategicWin3Grid:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil					--数据
	self.m_nType = nil					--1合上状态,2展开状态
	self.m_nIndex = nil

	self.m_tSize = {{276,410},{866,410}}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPvpStrategicWin3Grid:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_nType = nil
	self.m_nIndex = nil

	self.m_tSize = nil
end

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellPvpStrategicWin3Grid:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPvpStrategicWin3Grid")
	assert(element, "CellPvpStrategicWin3Grid create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPvpStrategicWin3Grid:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpStrategicWin3Grid:setData(tData)
	self.m_tData = tData
	self:updateUI()
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpStrategicWin3Grid:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpStrategicWin3Grid:onExit(element)
	self:_unInit()
end

--@brief	刷新界面
function CellPvpStrategicWin3Grid:updateUI()
	GetElement(self.m_root,"imgIcon_CellPvpStrategicWin3Grid",WZUIImage):setFile("ui/common/"..self.m_tData[1].icon..".png")
	local spineIcon = GetElement(self.m_root,"spineIcon_CellPvpStrategicWin3Grid",WZUISpine)
	spineIcon:setFileJson("ui/zls/"..self.m_tData[1].animation..".json")
	spineIcon:setFileAtlas("ui/zls/"..self.m_tData[1].animation..".atlas")
	spineIcon:play(self.m_tData[1].action,true)
	GetElement(self.m_root,"txtName_CellPvpStrategicWin3Grid",WZUILabelTTF):setText(self.m_tData[1].name)
	GetElement(self.m_root,"txtTime_CellPvpStrategicWin3Grid",WZUILabelTTF):setText(string.format(LocalStrings.PVP_STRATEGIC_TEXT1[18],#self.m_tData))

	GetElement(self.m_root,"txtLevelCondition_CellPvpStrategicWin3Grid",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[19])

	for i=1,#self.m_tData do
		GetElement(self.m_root,"txtTitleValue"..i.."_CellPvpStrategicWin3Grid",WZUILabelTTF):setText(self.m_tData[i].name)
		GetElement(self.m_root,"imgTitleIcon"..i.."_CellPvpStrategicWin3Grid",WZUIImage):setFile("ui/common/"..self.m_tData[i].icon..".png")
		GetElement(self.m_root,"txtScoreValue"..i.."_CellPvpStrategicWin3Grid",WZUILabelTTF):setText(self.m_tData[i].nScoreConditions)
	end
end

--@brief 	设置按钮回调
function CellPvpStrategicWin3Grid:setCallback(tCell, func)
	self.m_tCallBackFun = {}
	self.m_tCallBackFun[1] = tCell
	self.m_tCallBackFun[2] = func
end

--@brief	点击格子
function CellPvpStrategicWin3Grid:onClickWin3Grid(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tCallBackFun and #self.m_tCallBackFun > 0 then
		self.m_tCallBackFun[2](self.m_tCallBackFun[1], self)
	end
end

--@brief 	设置索引
function CellPvpStrategicWin3Grid:setIndex(nIndex)
	self.m_nIndex = nIndex
end

--@brief 	设置开展合上类型
function CellPvpStrategicWin3Grid:setType(nType)
	self.m_nType = nType

	local con1 = GetElement(self.m_root,"con1_CellPvpStrategicWin3Grid",WZUIContainer)
	local con2 = GetElement(self.m_root,"con2_CellPvpStrategicWin3Grid",WZUIContainer)
	local imgArrow = GetElement(self.m_root,"imgArrow_CellPvpStrategicWin3Grid",WZUIImage)

	self.m_root:setAbsContentSize(GlobalMethod:CCSize(self.m_tSize[self.m_nType][1],self.m_tSize[self.m_nType][2]))
	self.m_root:updateRelativeSize()
	if self.m_nType == 1 then
		con2:setVisible(false)
		imgArrow:setFlipX(false)
	elseif self.m_nType == 2 then
		con2:setVisible(true)
		imgArrow:setFlipX(true)
	end
end
-------------------------------------段位详情格子end----------------------------------------


-------------------------------------赛季排名格子begin----------------------------------------

CellPvpStrategicWin4Grid1 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellPvpStrategicWin4Grid1:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil					--数据 rank, serverId, playerId, name, faceId, headId, headColour, sex, level, vipLevel, zlsLevel, zlsStar, zlsScore, battleTime, winTime
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPvpStrategicWin4Grid1:_unInit()
	self.m_root = nil
	self.m_tData = nil
end

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellPvpStrategicWin4Grid1:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	-- local element = WZUISystem:getInstance():createElement("CellPvpStrategicWin4Grid1")
	-- assert(element, "CellPvpStrategicWin4Grid1 create element failed!")
	-- element:setLuaObjectIndex(tNewObj)
	-- tNewObj.m_root = element
	-- return element, tNewObj

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellPvpStrategicWin4Grid1")
    element:setAbsContentSize(GlobalMethod:CCSize(856,80))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPvpStrategicWin4Grid1:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief    加载数据信息
function CellPvpStrategicWin4Grid1:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellPvpStrategicWin4Grid1")
    cellElement:setVisible(true)
    self.m_root:addChild(cellElement)

    self.m_bIsLoad = true
    self:updateUI()
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpStrategicWin4Grid1:setData(tData)
	self.m_tData = tData
	-- self:updateUI()
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpStrategicWin4Grid1:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpStrategicWin4Grid1:onExit(element)
	self:_unInit()
end

--@brief	刷新界面
function CellPvpStrategicWin4Grid1:updateUI()
	--头像
	local conHead = GetElement(self.m_root,"conHead_CellPvpStrategicWin4Grid1",WZUIContainer)
	local cellHeadElement = CellHead:show(conHead, self.m_tData.headId, self.m_tData.faceId, self.m_tData.sex, nil, nil, self.m_tData.vipLevel, self.m_tData.headColour)

	--排名
	local tThreeIcon = {"ui/common/common_icon_1st_1.png", "ui/common/common_icon_2nd_1.png", "ui/common/common_icon_3rd_1.png"}
	local imgWin4Rank1Num = GetElement(self.m_root, "imgWin4Rank1Num_CellPvpStrategicWin4Grid1", WZUIImage)
	local txtWin4Rank1Num = GetElement(self.m_root, "txtWin4Rank1Num_CellPvpStrategicWin4Grid1", WZUILabelTTF)
	imgWin4Rank1Num:setVisible(false)
	txtWin4Rank1Num:setVisible(false)
	if self.m_tData.rank <= 3 then
		imgWin4Rank1Num:setVisible(true)
		imgWin4Rank1Num:setFile(tThreeIcon[self.m_tData.rank])
	else
		txtWin4Rank1Num:setVisible(true)
		txtWin4Rank1Num:setText(self.m_tData.rank)
	end

	--名字
	local txtWin4Rank1Name = GetElement(self.m_root,"txtWin4Rank1Name_CellPvpStrategicWin4Grid1",WZUILabelTTF)
	txtWin4Rank1Name:setText(self.m_tData.name)

	--段位
	local tLevelInfo = GetZlsPvpDataByLevel(self.m_tData.zlsLevel)
	local imgWin4Rank1Icon = GetElement(self.m_root, "imgWin4Rank1Icon_CellPvpStrategicWin4Grid1", WZUIImage)
	local spineWin4Rank1Icon = GetElement(self.m_root, "spineWin4Rank1Icon_CellPvpStrategicWin4Grid1", WZUISpine)
	local txtWin4Rank1Level = GetElement(self.m_root,"txtWin4Rank1Level_CellPvpStrategicWin4Grid1",WZUILabelTTF)
	local ftbWin4Rank1Star = GetElement(self.m_root,"ftbWin4Rank1Star_CellPvpStrategicWin4Grid1",WZUIFreeTextBox)
	imgWin4Rank1Icon:setFile("ui/common/"..tLevelInfo.icon..".png")
	local spinePath = "ui/zls/" .. tLevelInfo.animation
    local existSpine = CheckEffectFile(spinePath)
    if existSpine then 
		imgWin4Rank1Icon:setVisible(false)
		spineWin4Rank1Icon:setFileJson(spinePath .. ".json")
		spineWin4Rank1Icon:setFileAtlas(spinePath .. ".atlas")
		spineWin4Rank1Icon:play(tLevelInfo.action,true)
	else
		imgWin4Rank1Icon:setVisible(true)
	end
	txtWin4Rank1Level:setText(tLevelInfo.name)
	if tLevelInfo.id == 999 then
		local formatStar = [[<I Z="0.6" P="1">ui/common/common_icon_xingxing5.png</I><T C="127,70,26" S="20" P="1">x%d</T>]]
		ftbWin4Rank1Star:setShowText(string.format(formatStar,self.m_tData.zlsStar))
		txtWin4Rank1Level:setRelativePosition(GlobalMethod:ccp(0.65,0.7))
	else
		ftbWin4Rank1Star:setShowText("")
		txtWin4Rank1Level:setRelativePosition(GlobalMethod:ccp(0.65,0.5))
	end

	-- --场次
	-- local txtWin4Rank1BattleTimes = GetElement(self.m_root,"txtWin4Rank1BattleTimes_CellPvpStrategicWin4Grid1",WZUILabelTTF)
	-- txtWin4Rank1BattleTimes:setText(string.format(LocalStrings.COMMUNITYINFO67, self.m_tData.battleTime, self.m_tData.winTime))

	-- --胜率
	-- local ftbWin4Rank1Result = GetElement(self.m_root,"ftbWin4Rank1Result_CellPvpStrategicWin4Grid1",WZUIFreeTextBox)
	-- local nWinPercent = 0
	-- if self.m_tData.battleTime > 0 then
	-- 	nWinPercent = math.floor(100 * self.m_tData.winTime / self.m_tData.battleTime)
	-- end
	-- ftbWin4Rank1Result:setShowText(string.format(LocalStrings.PVP_RANK_TEXT4, nWinPercent))
end

--@brief	点击头像
function CellPvpStrategicWin4Grid1:onClickWin4rank1Head(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tData.playerId)
end

-------------------------------------赛季排名格子end----------------------------------------


-------------------------------------排名奖励格子begin----------------------------------------

CellPvpStrategicWin4Grid2 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellPvpStrategicWin4Grid2:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil					--数据
	self.m_tCallFunc = nil
	self.m_tReward = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPvpStrategicWin4Grid2:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_tCallFunc = nil
	self.m_tReward = nil
end

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellPvpStrategicWin4Grid2:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPvpStrategicWin4Grid2")
	assert(element, "CellPvpStrategicWin4Grid2 create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPvpStrategicWin4Grid2:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpStrategicWin4Grid2:setData(tData)
	self.m_tData = tData
	self:updateUI()
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpStrategicWin4Grid2:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpStrategicWin4Grid2:onExit(element)
	self:_unInit()
end

--@brief	刷新界面
function CellPvpStrategicWin4Grid2:updateUI()
	--排名
	local tThreeIcon = {"ui/common/common_icon_1st_1.png", "ui/common/common_icon_2nd_1.png", "ui/common/common_icon_3rd_1.png"}
	local imgWin4Rank2Num = GetElement(self.m_root, "imgWin4Rank2Num_CellPvpStrategicWin4Grid2", WZUIImage)
	local txtWin4Rank2Num = GetElement(self.m_root, "txtWin4Rank2Num_CellPvpStrategicWin4Grid2", WZUILabelTTF)
	imgWin4Rank2Num:setVisible(false)
	txtWin4Rank2Num:setVisible(false)
	if self.m_tData.rank[1][1] <= 3 then
		imgWin4Rank2Num:setVisible(true)
		imgWin4Rank2Num:setFile(tThreeIcon[self.m_tData.rank[1][1]])
	else
		txtWin4Rank2Num:setVisible(true)
		local strRank = self.m_tData.rank[1][1] .. "-" .. self.m_tData.rank[1][2]
		txtWin4Rank2Num:setText(strRank)
	end

	for i = 1, #self.m_tData.reward do
		local conItem = GetElement(self.m_root, "conWin4Rank2Item" .. i .. "_CellPvpStrategicWin4Grid2", WZUIContainer)
		if conItem then
			local celElement, tNewObj = CellGoodItem:createElement()
			if celElement and tNewObj then
				local shopItems = GDatatab_item["id_"..self.m_tData.reward[i][1]]
				local itemInfo = {id=self.m_tData.reward[i][1], name=shopItems.name,icon=shopItems.icon,lastNum=self.m_tData.reward[i][2],quality=shopItems.quality ,basicInfo=shopItems}
				self.m_tReward[i] = itemInfo
				if shopItems.main_type == 5 then
					tNewObj:setCellGoodItem(itemInfo,17)
				else
					tNewObj:setCellGoodItem(itemInfo,4)
				end
				celElement:setScale(0.8)
				tNewObj:setItemClickFun(self,self.onItemClick)
				conItem:addChild(celElement)
				celElement:setTag(i - 1)
			end
		end
	end
end

--@brief 	设置按钮回调
function CellPvpStrategicWin4Grid2:setCallback(tCell, func)
	self.m_tCallBackFun = {}
	self.m_tCallBackFun[1] = tCell
	self.m_tCallBackFun[2] = func
end

--@brief    其它Item点击回调
function CellPvpStrategicWin4Grid2:onItemClick(luaObject,tag)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_tCallBackFun[2](self.m_tCallBackFun[1],luaObject,self.m_tReward[tag + 1])
end
-------------------------------------排名奖励格子end----------------------------------------

-------------------------------------赛事奖励格子begin----------------------------------------

CellPvpStrategicWin5Grid = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellPvpStrategicWin5Grid:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil					--数据
	self.m_tCallFunc = nil
	self.m_tReward = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPvpStrategicWin5Grid:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_tCallFunc = nil
	self.m_tReward = nil
end

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellPvpStrategicWin5Grid:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPvpStrategicWin5Grid")
	assert(element, "CellPvpStrategicWin5Grid create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPvpStrategicWin5Grid:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpStrategicWin5Grid:setData(tData)
	self.m_tData = tData
	self:updateUI()
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpStrategicWin5Grid:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpStrategicWin5Grid:onExit(element)
	self:_unInit()
end

--@brief	刷新界面
function CellPvpStrategicWin5Grid:updateUI()
	GetElement(self.m_root,"txtW5Receive1_CellPvpStrategicWin4Grid2",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[22])
	GetElement(self.m_root,"txtW5Receive2_CellPvpStrategicWin4Grid2",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[22])
	GetElement(self.m_root,"txtW5Receive3_CellPvpStrategicWin4Grid2",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[22])

	local taskInfo = GDatatab_task["id_"..self.m_tData.nId]

	local txtW5TaskType = GetElement(self.m_root,"txtW5TaskType_CellPvpStrategicWin5Grid",WZUILabelTTF)
	if self.m_tData.nTaskType == 10 then
		txtW5TaskType:setText(LocalStrings.PVP_RANK_17)
	elseif self.m_tData.nTaskType == 11 then
		txtW5TaskType:setText(LocalStrings.PVP_STRATEGIC_TEXT1[23])
	end
	local strFormat = [[<T C="127,70,26" S="20" P="0">%s</T><T C="229,105,22" S="22" P="1">(%s/%s)</T>]]
	local ftbW5TaskDesc = GetElement(self.m_root,"ftbW5TaskDesc_CellPvpStrategicWin5Grid",WZUIFreeTextBox)
	ftbW5TaskDesc:setShowText(string.format(strFormat,taskInfo.desc,self.m_tData.nTargetStatus,self.m_tData.nTargetValue))

	local btnW5Receive = GetElement(self.m_root,"btnW5Receive_CellPvpStrategicWin5Grid",WZUIButton)
	local imgW5Received = GetElement(self.m_root,"imgW5Received_CellPvpStrategicWin5Grid",WZUIImage)
	btnW5Receive:setVisible(false)
	imgW5Received:setVisible(false)
	if self.m_tData.nTaskStatus == 0 then
		btnW5Receive:setVisible(true)
		btnW5Receive:setTouchEnable(false)
	elseif self.m_tData.nTaskStatus == 1 then
		btnW5Receive:setVisible(true)
		btnW5Receive:setTouchEnable(true)
	elseif self.m_tData.nTaskStatus == 2 then
		imgW5Received:setVisible(true)
	end
	for i=1,#taskInfo.reward do
		local conItem = GetElement(self.m_root, "conW5Item" .. i .. "_CellPvpStrategicWin5Grid", WZUIContainer)
		if conItem then
			local celElement, tNewObj = CellGoodItem:createElement()
			if celElement and tNewObj then
				local shopItems = GDatatab_item["id_"..taskInfo.reward[i][1]]
				local itemInfo = {id=taskInfo.reward[i][1], name=shopItems.name,icon=shopItems.icon,lastNum=taskInfo.reward[i][2],quality=shopItems.quality ,basicInfo=shopItems}
				self.m_tReward[i] = itemInfo
				if shopItems.main_type == 5 then
					tNewObj:setCellGoodItem(itemInfo,17)
				else
					tNewObj:setCellGoodItem(itemInfo,4)
				end
				celElement:setScale(0.8)
				tNewObj:setItemClickFun(self,self.onItemClick)
				conItem:addChild(celElement)
				celElement:setTag(i - 1)
			end
		end
	end
end

--@brief 	设置按钮回调
function CellPvpStrategicWin5Grid:setCallback(tCell, func)
	self.m_tCallBackFun = {}
	self.m_tCallBackFun[1] = tCell
	self.m_tCallBackFun[2] = func
end

--@brief    其它Item点击回调
function CellPvpStrategicWin5Grid:onItemClick(luaObject,tag)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_tCallBackFun[2](self.m_tCallBackFun[1],luaObject,self.m_tReward[tag + 1])
end

--@brief    其它Item点击回调
function CellPvpStrategicWin5Grid:onClickW5Receive(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorWndTask:send_TASK_GetTaskReward(self.m_tData.nId)
end


--@brief 是否在赛季开放时间内
function ScenePvpStrategic:isSeasonOpenTime()
	local bIsSeason = false
	local nCurTime = SystemTime:getServerTime()
	if nCurTime > self.startDate and nCurTime < self.endDate then
		bIsSeason = true
	end
	return bIsSeason
end

--@brief 是否在开放日期内
function ScenePvpStrategic:isDayOpenTime()
	local bIsDay = false

	local nCurTime = SystemTime:getServerTime()
	local day = tonumber(os.date("%d", nCurTime))

	local tOpenday = {}
	if self.m_nPvpMode == 2 then
		tOpenday = self.openDay2V2
	elseif self.m_nPvpMode == 3 then
		tOpenday = self.openDay3V3
	end
	for i=1,#tOpenday do
		if tOpenday[i] == day then
			bIsDay = true
			break
		end
	end

	return bIsDay
end

--@brief     获取开放剩余时间
--@return    nLeftTime : 离开放倒计时 -1表示过了开放时间 0表示在一段开放时间内 >0表示距离开放倒计时
function ScenePvpStrategic:getOpenTime()
	local currentTimeStamp = SystemTime:getServerTime() --现在时间戳
    local localTimeZone = os.difftime(currentTimeStamp, os.time(os.date("!*t", currentTimeStamp))) --玩家所在的时区(秒)
	local serverTimeZone = SystemTime:getServerTimeZone() * 3600 --服务器所在的时区(秒)
	local dstTime = (os.date("*t", currentTimeStamp).isdst and -1 or 0) * 3600 --夏令时时差(秒)
	local diffTime = serverTimeZone - localTimeZone

	local nLeftTime = -1
	for i=1,#self.openTimes,2 do
		local year = os.date("%Y", (currentTimeStamp+diffTime+dstTime) )
		local month = os.date("%m", (currentTimeStamp+diffTime+dstTime) )
		local day = os.date("%d", (currentTimeStamp+diffTime+dstTime) )
		local hour = 0
		local min = 0
		local sec = 0

		local tempOpenTimes1 = SplitStringWithSeparator(self.openTimes[i],":")
		hour = tonumber(tempOpenTimes1[1])
		min = tonumber(tempOpenTimes1[2])
		local nTime1 = os.time({year = year,month = month,day = day,hour = hour,min = min,sec = sec}) - diffTime - dstTime

		local tempOpenTimes2 = SplitStringWithSeparator(self.openTimes[i+1],":")
		hour = tonumber(tempOpenTimes2[1])
		min = tonumber(tempOpenTimes2[2])
		local nTime2 = os.time({year = year,month = month,day = day,hour = hour,min = min,sec = sec}) - diffTime - dstTime

		if currentTimeStamp >= nTime1 and currentTimeStamp < nTime2 then
			nLeftTime = 0
			break
		elseif currentTimeStamp < nTime1 then
			if nLeftTime == -1 then
				nLeftTime = nTime1 - currentTimeStamp
			else
				nLeftTime = math.min(nLeftTime, (nTime1 - currentTimeStamp))
			end
		end
	end
	return nLeftTime
end

--@brief     获取开放剩余时间
--@return    nLeftTime : 离开放倒计时 -1表示过了开放时间 0表示在一段开放时间内 >0表示距离开放倒计时
function ScenePvpStrategic:getStrCountdown(nLeftTime)
	local nLeftmin = math.ceil(nLeftTime / 60)
	local min = nLeftmin % 60
	local hour = math.floor(nLeftmin / 60)
	local strTime = ""
	if hour == 0 then
		strTime = LocalStrings.KING_REST_OPEN_TIME .. min .. LocalStrings.MINUTE
	elseif hour > 0 then
		strTime = LocalStrings.KING_REST_OPEN_TIME .. string.format(LocalStrings.TOPGOLD_TEXT2, hour, min)
	end
	return strTime
end

-------------------------------------赛事奖励格子end----------------------------------------
