--WndCharmSpaceData.lua
--@brief	WndCharmSpace的数据模块
--@date		2016/08/19
--@author	maopeiting
--@note		魅力空间

WndCharmSpace = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCharmSpace:_init()
	self.m_root = nil	 	  			--场景根节点
	self.preTag = 1 	--记录前面点击的标签
	self.time = 2 		--记录冷却的时间
	self.preCel = nil 	--记录前面点击的Cell
	self.playerId = nil		--玩家ID
	self.playerName = nil	--玩家名称
	self.photoUrl = nil		--照片链接
	self.sex = nil			--性别
	self.cross = nil		--跨服
	self.level = nil		--等级
	self.searchID = nil		--玩家搜索的ID
	self.rank = nil 		--玩家排名
	self.flowerNum = nil 	--鲜花数
	self.partner = nil 		--伴侣名
	self.community = nil 	--公会名
	self.server = nil 		--区服名
	self.tag = 1
	--self.pre = 0
	self.currentTag = 1
	self.currentCross = nil
	self.currentPlayerId = nil
	self.currentPhoto = nil

	self.loadingId = nil
	self.m_tDownloadFileList = nil
	self.m_nSize = nil

	self.m_tCellDressSuit = nil 
	self.m_nInterfaceType = 0 --界面类型：0->魅力空间；1->魅力时装
	self.m_tMyFashionData = nil --我的时装信息
	self.m_fashionRecommendCost = nil --推荐消耗
	self.m_nFashionRecommendConfigTime = 0 --配置的推荐时长
	self.m_tMyRole = {}
	self.m_tFashionRecommendData = nil --魅力时装推荐数据
	self.m_nLeftOperateTimes = 0 --剩餘点赞次数
	self.m_tCellRecommendList = nil 	--推荐玩家Cell
	self.m_tFashionPeriodData = nil 	--历届冠军数据
	self.m_bIsFirstIn = true 			--是否首次进入界面
	self.m_nFashionTag = 1
	self.m_nSpaceTag = 1
	self.m_nFootTag = 1
	self.m_nKingTag = 1
	self.m_nUglyTag = 1
	self.m_tCellSelRecommendPlayer = nil 	--当前显示点赞按钮的玩家
	self.m_tOtherInfo = nil 
	self.m_tRankRoleInfo = nil 			--排行榜显示的玩家形象的玩家信息
	self.m_nWeekListPositionY = nil 
	self.m_nBeGoodPlayerId = nil 
	self.m_nRankType = nil 						--历届排行榜 1魅力时装 2魅力空间 3魅力人气 4魅力之王
	self.m_nTotalTimes = nil 		--总点赞数（丑人秀使用）
	self.m_oType = nil 				--获取推荐列表，区分魅力时装还是丑人秀（1魅力时装，2丑人秀）
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCharmSpace:_unInit()
	self.m_root = nil
	self.preTag = nil
	self.time = nil
	self.preCel = nil
	self.playerId = nil	
	self.playerName = nil
	self.photoUrl = nil
	self.sex = nil
	self.cross = nil
	self.level = nil
	self.searchID = nil
	self.rank = nil 		
	self.flowerNum = nil 	
	self.partner = nil 		
	self.community = nil 	
	self.server = nil 	
	self.tag = nil	
	--self.pre = nil
	self.currentTag = nil
	self.currentCross = nil
	self.currentPlayerId = nil
	self.currentPhoto = nil

	self.loadingId = nil
	self.m_tDownloadFileList = nil
	self.m_nSize = nil

	self.m_tCellDressSuit = nil 
	self.m_nInterfaceType = nil
	self.m_tMyFashionData = nil
	self.m_fashionRecommendCost = nil --推荐消耗
	self.m_nFashionRecommendConfigTime = nil --配置的推荐时长
	self.m_tMyRole = nil 
	self.m_tFashionRecommendData = nil
	self.m_nLeftOperateTimes = nil
	self.m_tCellRecommendList = nil 	--推荐玩家Cell
	self.m_tFashionPeriodData = nil 
	self.m_bIsFirstIn = nil
	self.m_nFashionTag = nil 
	self.m_nSpaceTag = nil 
	self.m_nFootTag = nil 
	self.m_nKingTag = nil
	self.m_nUglyTag = nil
	self.m_tCellSelRecommendPlayer = nil
	self.m_tOtherInfo = nil 
	self.m_tRankRoleInfo = nil
	self.m_nWeekListPositionY = nil 
	self.m_nBeGoodPlayerId = nil 
	self.m_nRankType = nil
	self.m_nTotalTimes = nil 		--总点赞数（丑人秀使用）
end

--@brief	接收随机推荐列表数据
function WndCharmSpace:setData1( playerIds, playerNames, photoUrl, sexs, cross, level )
	self.playerId = playerIds
	self.playerName = playerNames
	self.photoUrl = photoUrl
	self.sex = sexs
	self.cross = cross
	self.level = level

	--WZLog("---WndCharmSpace:setData1:photoUrl---",Serialize(photoUrl))
	--WZLog("---WndCharmSpace:setData1:sexs---",Serialize(cross))

	local conRecommend = GetElement(self.m_root, "conRecommend_WndCharmSpace", WZUIContainer)
	removeShowPanelNullTip(conRecommend)
	if #self.playerId <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.CHARM_NO_PLAYER)
		ShowPanelNullTip(conRecommend, LocalStrings.CHARM_NO_PLAYER)

		local tab = GetElement(self.m_root,"tab3_WndCharmSpace",WZUITableContainer)
	
		tab:cleanTable()
		self:_update(self.tag)
	else
		--WZLog("--WndCharmSpace:cleanTable---")
		local tab = GetElement(self.m_root,"tab3_WndCharmSpace",WZUITableContainer)
	
		tab:cleanTable()
		self:_update(self.tag)
	end
end 

--@brief	接收玩家搜索数据
function WndCharmSpace:setData2( playerId, playerName, photoUrl, sex, cross, level )
	--WZLog("--WndCharmSpace:setData2--",playerId,playerName,photoUrl,sex,cross,level)
	self.playerId = playerId
	self.playerName = playerName
	self.photoUrl = photoUrl
	self.sex = sex
	self.cross = cross
	self.level = level

	if self.playerId == 0 then
		MsgBoxManager:showTipBox(LocalStrings.CHARM_RESULT)
	else
		local tab = GetElement(self.m_root,"tab3_WndCharmSpace",WZUITableContainer)
		GetElement(self.m_root,"conRecommend_WndCharmSpace",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conRank_WndCharmSpace",WZUIContainer):setVisible(false)
		tab:cleanTable()

		local celElement,tCell = CellCharmRecommend:createElement()
		if celElement and tCell then
			tCell:setData(self.playerId,self.playerName,self.photoUrl,self.sex,self.cross,self.level)
			tab:setCellElement(celElement)
		end
	end
end

--@brief	接收鲜花榜的总排行榜数据
function WndCharmSpace:setData3(ranking,playerId,name,sex,level,param1,param2,param3,param4,param5,param6, qqHallInfo)
	self.rank = ranking
	self.flowerNum = param1
	self.partner = param2
	self.community = param3
	self.server = param4
	self.playerId = playerId
	self.playerName = name
	self.photoUrl = param5
	self.sex = sex
	self.level = level
	self.cross = param6
	self.qqHallInfo = qqHallInfo


	--WZLog("----WndCharmSpace:setData3:ranking---",Serialize(ranking),Serialize(playerId))
	--WZLog("----WndCharmSpace:setData3---")

	self:_update(self.tag)
end

--@brief	接收点赞榜的总排行榜数据
function WndCharmSpace:setDataFashion(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, vipLevel, param8, headColor, param9, qqHallInfo)
	self.rank = ranking
	self.flowerNum = param1
	self.partner = param2
	self.community = param3
	self.server = param4
	self.playerId = playerId
	self.playerName = name
	self.photoUrl = param5
	self.sex = sex
	self.level = level
	self.cross = param6
	WZLog("总点赞数",Serialize(self.flowerNum))
	self.m_tOtherInfo = {}
	for i = 1, #playerId do
		local tItem = {}

		tItem.id = playerId[i]
		tItem.playerName = name[i]
		tItem.faceId = faceId[i]
		tItem.headId = headId[i]
		tItem.sex = sex[i]
		tItem.bodyId = tonumber(param7[i])
		tItem.bodyColor = tonumber(param8[i])
		tItem.headColor = headColor[i]
		tItem.wingId = tonumber(param9[i])
		if qqHallInfo and qqHallInfo[i] and qqHallInfo[i] ~= "" then 
			tItem.qqHallData = json.decode(qqHallInfo[i])
		end

		table.insert(self.m_tOtherInfo, tItem)
	end

	self:_update(self.tag)
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCharmSpace:createElement()
	local element = WZUISystem:getInstance():createElement("WndCharmSpace")
	assert(element, "WndCharmSpace create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndCharmSpace:showInterface(nType)
	-- body
	local wndCharm = WndCharmSpace:createElement()
	if wndCharm then 
		self.m_nInterfaceType = nType or 0
		WindowManager:addWindow(wndCharm, WndCharmSpace, false)
	end
end

--@brief 	获取玩家报名信息数据成功
function WndCharmSpace:getPlayerFashionInfoOK(oType, playerId, playerName, level, headId, faceId, bodyId, wingId, colour, bodyColor, sex, like, isApply, time, isRecomm)
	-- body
	if self.m_root == nil then return end 
	
	self.m_oType = oType
	self.m_tMyFashionData = {}
	self.m_tMyFashionData.oType = oType
	self.m_tMyFashionData.id = playerId
	self.m_tMyFashionData.playerName = playerName
	self.m_tMyFashionData.level = level
	self.m_tMyFashionData.headId = headId
	self.m_tMyFashionData.faceId = faceId
	self.m_tMyFashionData.bodyId = bodyId
	self.m_tMyFashionData.wingId = wingId
	self.m_tMyFashionData.headColor = colour
	self.m_tMyFashionData.bodyColor = bodyColor
	self.m_tMyFashionData.sex = sex
	self.m_tMyFashionData.goodNum = like
	self.m_tMyFashionData.applyState = isApply
	self.m_tMyFashionData.recommendTime = time
	self.m_tMyFashionData.recommendState = isRecomm
	WZLog("WndCharmSpace:getPlayerFashionInfoOK",oType, isApply, time, isRecomm)
	WZLog("玩家时装的数据",self.m_tMyFashionData.headId,self.m_tMyFashionData.faceId,self.m_tMyFashionData.bodyId,self.m_tMyFashionData.wingId,self.m_tMyFashionData.headColor,self.m_tMyFashionData.bodyColor)
	if isApply == 1 then --已报名
		if self.m_bIsFirstIn then 
			self.m_bIsFirstIn = false 
			self.tag = 1 
			GetElement(self.m_root, "boxGroupFashion_WndCharmSpace", WZUICheckBoxGroup):setCheckIndex(self.tag - 1)

			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(oType,2)
		else
			self:_showMyFashionInfo()
		end
	else --未报名
		self.tag = 5
		GetElement(self.m_root, "boxGroupFashion_WndCharmSpace", WZUICheckBoxGroup):setCheckIndex(self.tag - 1)
		self:_showMyFashionInfo()
	end
	
	self:showTitleList(self.m_nInterfaceType+1,self.tag)
end

--@brief 	报名、推荐成功
function WndCharmSpace:applyOrRecommendSuccess(oType, result, time, operationType)
	-- body
	WZLog("WndCharmSpace:applyOrRecommendSuccess",oType, result, time, operationType)
	if operationType == 1 then --报名
		if result == 0 then
			MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT17)
			self.m_tMyFashionData.applyState = 1
			--报名成功，移除切换时装功能
			local conForDressSuit = GetElement(self.m_root, "conForDressSuit_WndCharmSpace", WZUIContainer)
			if conForDressSuit then
				conForDressSuit:removeAllChildrenWithCleanup(true)
				self.m_tCellDressSuit = nil 
			end
		else
			MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT18)
		end
	elseif operationType == 2 then --推荐
		if result == 0 then
			MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT19)
			self.m_tMyFashionData.recommendTime = time
			self.m_tMyFashionData.recommendState = 1
			self:_showLeftRecommendTime()
			if self.m_tMyFashionData.recommendTime > 0 then 
				GetElement(self.m_root, "conSignupBottom_WndCharmSpace", WZUIContainer):enableSchedule("_setTimeCaculate", 1)
			end
			--显示推荐标记
			if self.m_tMyRole[2] then 
				self.m_tMyRole[2]:_setRecommendIconVisible(self.m_tMyFashionData.recommendState)
			end
		elseif result == 3 then
			MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT22)
		elseif result == 4 then
			MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT34)
		end	
	end
end

--@brief 	获取推荐数据成功
function WndCharmSpace:getFashionRecommendDataOK(oType, playerId, name, level, headId, faceId, bodyId, wingId, headColor, bodyColor, cross, sex, like, isRecomm, likeNum, totalLikeNum)
	-- body
	WZLog("WndCharmSpace:getFashionRecommendDataOK")
	self.m_nLeftOperateTimes = likeNum
	self.m_nTotalTimes = totalLikeNum 		--总点赞数（丑人秀使用）
	self.m_oType = oType
	self.m_tFashionRecommendData = {}

	for i = 1, #playerId do
		local tItem = {}
		tItem.id = playerId[i]
		tItem.playerName = name[i]
		tItem.level = level[i]
		tItem.headId = headId[i]
		tItem.faceId = faceId[i]
		tItem.bodyId = bodyId[i]
		tItem.wingId = wingId[i]
		tItem.headColor = headColor[i]
		tItem.bodyColor = bodyColor[i]
		tItem.cross = cross[i]
		tItem.sex = sex[i]
		tItem.goodNum = like[i]
		tItem.recommendState = isRecomm[i]

		table.insert(self.m_tFashionRecommendData, tItem)
	end
	self:_showFashionRecommendList()
end

--@brief 	搜索玩家成功
function WndCharmSpace:searchFashionPlayerOK(oType, playerId, name, level, headId, faceId, bodyId, wingId, headColor, bodyColor, cross, sex, like, isRecomm)
	-- body
	WZLog("WndCharmSpace:getFashionRecommendDataOK")
	self.m_tFashionRecommendData = {}
	self.m_oType = oType
	local tItem = {}
	tItem.id = playerId
	tItem.playerName = name
	tItem.level = level
	tItem.headId = headId
	tItem.faceId = faceId
	tItem.bodyId = bodyId
	tItem.wingId = wingId
	tItem.headColor = headColor
	tItem.bodyColor = bodyColor
	tItem.cross = cross
	tItem.sex = sex
	tItem.goodNum = like
	tItem.recommendState = isRecomm

	table.insert(self.m_tFashionRecommendData, tItem)

	self:_showFashionRecommendList()
end

--@brief 	获取历届数据成功
function WndCharmSpace:getFashionPeriodDataOK(playerId, name, level, headId, faceId, bodyId, wingId, headColor, bodyColor, cross, sex, periodNum, rankType)
	-- body
	self.m_nRankType = rankType
	self.m_tFashionPeriodData = {}
	for i = 1, #playerId do
		local tItem = {}
		tItem.id = playerId[i]
		tItem.playerName = name[i]
		tItem.level = level[i]
		tItem.headId = headId[i]
		tItem.faceId = faceId[i]
		tItem.bodyId = bodyId[i]
		tItem.wingId = wingId[i]
		tItem.headColor = headColor[i]
		tItem.bodyColor = bodyColor[i]
		tItem.cross = cross[i]
		tItem.sex = sex[i]
		tItem.periodNum = periodNum[i]

		table.insert(self.m_tFashionPeriodData, tItem)
	end
	table.sort(self.m_tFashionPeriodData, function (a,b)
		-- body
		return a.periodNum > b.periodNum
	end)

	self:_showFashionPeriodList()
end

--@brief 	获取可点赞剩余次数
function WndCharmSpace:getOperateTimes()
	-- body
	return self.m_nLeftOperateTimes
end

--@brief	1魅力时装2丑人秀
function WndCharmSpace:getCurrentView( )
	-- body
	return self.m_oType
end

--@brief 	设置可点赞剩余次数
function WndCharmSpace:setOperateTimes(nTimes)
	-- body
	self.m_nLeftOperateTimes = nTimes
end

--@brief 	点赞成功
--@param 	result : 1点赞成功，2点赞次数超限,3该玩家已点赞
function WndCharmSpace:giveGoodOK(oType, result, playerId)
	--body
	WZLog("WndCharmSpace:giveGoodOK", result, playerId)
	if result == 1 then 
		MsgBoxManager:showTipBox(string.format(LocalStrings.CHARM_LIFT7, CacheCenter:getGameParam().glamourfashionUpsecond))
		if self.tag == 1 then 
			self.m_nLeftOperateTimes = self.m_nLeftOperateTimes - 1
			self:_showLeftGoodNum()
			--更新玩家点赞次数
			for i = 1, #self.m_tFashionRecommendData do
				if self.m_tFashionRecommendData[i].id == playerId then 
					self.m_tFashionRecommendData[i].goodNum = self.m_tFashionRecommendData[i].goodNum + 1
					break 
				end
			end
			self:_updatePlayerGoodNum(playerId)
		elseif self.tag == 2 then 
			local tab = GetElement(self.m_root,"tab2_WndCharmSpace",WZUITableContainer)
			self.m_nWeekListPositionY = tab:getMoveElement():getPositionY()
			self.m_nBeGoodPlayerId = playerId
			if self.m_nInterfaceType == 1 then
				ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord(48) --点赞周榜的总排行榜
				ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank(48) --点赞周榜的个人排行榜
			elseif self.m_nInterfaceType == 4 then
				ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord(57) --点赞周榜的总排行榜
				ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank(58) --点赞周榜的个人排行榜	
			end 			
		end
	elseif result == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT6)
	elseif result == 3 then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT5)
	elseif result == 4 then
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT12)
	elseif result == 5 then
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT35)
	end
end

--@brief    更新多套时装数据
function WndCharmSpace:updateDressSuitData(nType)
    -- body
    WZLog("WndCharmSpace:updateDressSuitData",self.m_oType,self.m_nInterfaceType)
    if self.m_tCellDressSuit == nil then return end 
    if nType == 1 then
        self.m_tCellDressSuit:changeDressSuitOK()
    else
        self.m_tCellDressSuit:setSuitData()
    end           
    if self.m_nInterfaceType == 4 then
     	ProtocolProcessorWndSpace:send_SPACE_GetCharmFashionInfo(2)   
     elseif
     	self.m_nInterfaceType == 1 then
     	ProtocolProcessorWndSpace:send_SPACE_GetCharmFashionInfo(1)
     end           
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	新增下载文件任务
--@param	fileName文件名,tCell1设置图片的Cell
function WndCharmSpace:addDownloadFileList(fileName, tCell1, noUse, size)
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
				if imgSize.width < 10 or imgSize.width > 2000 then fileError = true end
				if imgSize.height < 10 or imgSize.height > 2000 then fileError = true end
			end
		end
	else
		--在下载列表中新增记录
		if self.m_tDownloadFileList == nil then self.m_tDownloadFileList = {} end
		--检测是否是重复任务
		for i=1,#self.m_tDownloadFileList do
			if fileName == self.m_tDownloadFileList[i].fileName then
				--WZLog("重复下载",fileName)
				return
			end
		end
		local tempTable = {fileName=fileName,tCell1=tCell1,status="init"}
		table.insert(self.m_tDownloadFileList,tempTable)
		--WZLog("添加下载任务",Serialize(self.m_tDownloadFileList))
	end
end

--@brief	下载文件
function WndCharmSpace:downloadFile(element,t)
	--WZLog("WndCharmSpace:downloadFile")
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
	--WZLog("WndCharmSpace调用sdk下载文件",fileName)
	self.m_tDownloadFileList[1].status="downloading"
end

--@brief	下载成功回调
function WndCharmSpace:downloadFileFinish(result)
	WZLog("WndSpaceMain:downloadFileFinish",result)
	if self.m_tDownloadFileList == nil or #self.m_tDownloadFileList == 0 then return end
	local result = json.decode(result)
	local fileName = result.objName
	--如果下载失败，把任务清出队列，返回
	--WZLog("下载结果",result["return"])
	if result["return"] == "fail" then
		for i=1,#self.m_tDownloadFileList do
			if self.m_tDownloadFileList[i].status == "downloading" then
				local x,y
				if self.m_tDownloadFileList[i].tCell1 ~= nil then
					local imgPhoto = self.m_tDownloadFileList[i].tCell1
					imgPhoto:setFile("ui/space/common_icon_renxiangnan.png")
					local size = imgPhoto:getContentSize()
					local hh = 236
					if self.m_nSize ~= nil then hh = self.m_nSize end
					x = hh/size.width 
					y = hh/size.height
					imgPhoto:setScale(math.max(x,y))
				end
				self.m_nSize = nil
				table.remove(self.m_tDownloadFileList,i)
				return
			end
		end
	end 
	if fileName == nil then return end
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..result.objName
	--WZLog("下载完成",path)

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




-------------------------------------私有方法模块End----------------------------------------
