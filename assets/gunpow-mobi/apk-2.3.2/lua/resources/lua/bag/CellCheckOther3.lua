--CellCheckOther3.lua
--@brief	CellCheckOther3的UI模块
--@date		2015/07/06
--@author	zsq
--@note		玩家信息栏3

local CONSTELLATION = {LocalStrings.SPACE79,LocalStrings.SPACE80,LocalStrings.SPACE81,LocalStrings.SPACE82,
			LocalStrings.SPACE83,LocalStrings.SPACE84,LocalStrings.SPACE85,LocalStrings.SPACE86,
			LocalStrings.SPACE87,LocalStrings.SPACE88,LocalStrings.SPACE89,LocalStrings.SPACE90}
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOther3:onEnter(element)
	self.m_root = element
end

--@brief	加载动画
function CellCheckOther3:onEnterTransitionDidFinish(element)
	AdaptLanguage(self)
	self:showBirthdayAndCity()
    self:update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOther3:onExit(element)
	self:_unInit()
end

--@brief 	点击头像回调
function CellCheckOther3:onCheckSpace(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if WndCheckOther.m_tPlayerInfo == nil then return end
	if nTag == 2 and (WndCheckOther.m_tPlayerInfo.mateName == nil or WndCheckOther.m_tPlayerInfo.mateName == "") then return end  
	--跨服不能看空间
	--if WndCheckOther.m_tPlayerInfo.serverId ~= CacheCenter:getPlayerInfo().serverId then
	--	MsgBoxManager:showTipBox(LocalStrings.SPACE104)
	--	return
	--end

	if SceneCommunityKnockout.m_root ~= nil then
		MsgBoxManager:showTipBox(LocalStrings.SPACE97)
		return
	end
	if SceneCommunityWar.m_root ~= nil then
		MsgBoxManager:showTipBox(LocalStrings.SPACE97)
		return
	end

	if GlobalGame.g_bIfInBattle == true then
		MsgBoxManager:showTipBox(LocalStrings.SPACE96)
		return
	end
	local playerId = WndCheckOther.m_nPlayerId
	if nTag == 2 then 
		playerId = nil 
		local tIdList = SplitStringWithSeparator(WndCheckOther.m_tPlayerInfo.coupleMes, "|", nil, true)
		if tIdList and tIdList[7] then
			playerId = tIdList[7]
		end
	end
	if playerId == nil then
		WZLog("保存的玩家id为nil")
		return 
	end
	if WndCheckOther.m_nChecFromMsg then
		WndCheckOther.m_nChecFromMsg = false
		WndSpaceMain:showOther(playerId)
		WindowManager:removeWindow(WndCheckOther.m_root, WndCheckOther, true)
	else
		WndSpaceMain:show(playerId)
	end
end

--@brief 跳转到小屋
function CellCheckOther3:onClickKid(element)
	-- body
	if SceneCommunityKnockout.m_root ~= nil then
		MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_NEWTEXT6)
		return
	end
	if SceneCommunityWar.m_root ~= nil then
		MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_NEWTEXT6)
		return
	end

	if GlobalGame.g_bIfInBattle == true then
		MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_NEWTEXT5)
		return
	end
	local nTag = element:getTag()
	local imgDiTuHead1 = GetElement(self.m_root, "imgDiTuHead1_CellCheckOther3", WZUIImage)
	local imgDiTuHead = GetElement(self.m_root, "imgDiTuHead_CellCheckOther3", WZUIImage)
	if nTag == 1 and imgDiTuHead1:isVisible() then return end 
	if nTag == 2 and imgDiTuHead:isVisible() then return end 
	if not CheckButtonOpen(145) then return end

	SceneKidHome:showInterface(WndCheckOther.m_nPlayerId)
end

--@brief 	保存按钮回调
function CellCheckOther3:onClickSave(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	for i = 1, 5 do
		GetElement(self.m_root, "img9Line" .. i .. "_CellCheckOther3", WZUI9Image):setVisible(true)
		GetElement(self.m_root, "img9White" .. i .. "_CellCheckOther3", WZUI9Image):setVisible(false)
		GetElement(self.m_root, "imgArrow" .. i .. "_CellCheckOther3", WZUIImage):setVisible(false)
		GetElement(self.m_root, "txtContent" .. i .. "_CellCheckOther3", WZUILabelTTF):setVisible(false)
	end
	GetElement(self.m_root, "ttfCity_CellCheckOther3", WZUILabelTTF):setVisible(true)
	GetElement(self.m_root, "ttfAge_CellCheckOther3", WZUILabelTTF):setVisible(true)
	GetElement(self.m_root, "ttfStarSeat_CellCheckOther3", WZUILabelTTF):setVisible(true)
	GetElement(self.m_root, "btnSave_CellCheckOther3", WZUIButton):setVisible(false)

	--刷新选择
	self:resetData()
	WndCheckOther:sendProtocol()
end

--@brief 	点击设置
function CellCheckOther3:onClickSetting(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 5 and self.m_nCityId == nil then 
		MsgBoxManager:showTipBox(LocalStrings.SPACE_CITY3)
		return
	end

	for i = 1, 5 do
		WZLog("CellCheckOther3:onClickSetting", i)
		GetElement(self.m_root, "img9Line" .. i .. "_CellCheckOther3", WZUI9Image):setVisible(false)
		GetElement(self.m_root, "img9White" .. i .. "_CellCheckOther3", WZUI9Image):setVisible(true)
		GetElement(self.m_root, "imgArrow" .. i .. "_CellCheckOther3", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtContent" .. i .. "_CellCheckOther3", WZUILabelTTF):setVisible(true)
	end
	GetElement(self.m_root, "ttfCity_CellCheckOther3", WZUILabelTTF):setVisible(false)
	GetElement(self.m_root, "ttfAge_CellCheckOther3", WZUILabelTTF):setVisible(false)
	GetElement(self.m_root, "ttfStarSeat_CellCheckOther3", WZUILabelTTF):setVisible(false)
	GetElement(self.m_root, "btnSave_CellCheckOther3", WZUIButton):setVisible(true)

	local tData = {}
	tData.type = nTag
	WZLog("CellCheckOther3:onClickSetting", nTag)
	local pt = GlobalMethod:ccp(27,-35)
	if nTag == 1 then 
		tData.playerAge = WndCheckOther.m_tData.playerAge
	elseif nTag == 2 then 
		local month = 0
		if self.m_nMonth then 
			month = self.m_nMonth
		end
		tData.month = month
	elseif nTag == 3 then 
		local day = 0
		if self.m_nDay then 
			day = self.m_nDay
		end
		tData.day = day
	elseif nTag == 4 then 
		tData.province = self.m_nCityId 
	elseif nTag == 5 then 
		pt = GlobalMethod:ccp(35,-35)
		tData.province = self.m_nCityId 
		tData.city = self.m_nCityIndex
	end
	WndTips:show(element, WndCheckOther.m_root, 75, tData, pt, true)
end

--@brief 	显示信息框特效
function CellCheckOther3:showInfoRectEffect()
	local itemId = WndCheckOther.m_tPlayerInfo.infoBarItemId
	local spineFrame = GetElement(self.m_root, "spineFrame_CellCheckOther3", WZUISpine)
	if itemId > 0 then 
		local basicInfo = GDatatab_item["id_" .. itemId]
		if basicInfo then 
			local effectFile = "ui_checkother_info" .. basicInfo.value

			GetElement(self.m_root, "conSpineAction_CellCheckOther3", WZUIContainer):setVisible(true)
			local existSpine = CheckEffectFile("checkother/" .. effectFile)
			if existSpine then 
				if spineFrame then 
					spineFrame:setFileJson("")
					spineFrame:setFileAtlas("")
					spineFrame:setFileJson("checkother/" .. effectFile .. ".json")
					spineFrame:setFileAtlas("checkother/" .. effectFile .. ".atlas")

					spineFrame:play("wait1", true)

					local nScale = 1
					local nPosX = 0.5
					local nPosY = 0.5
					if basicInfo.power_skill ~= -1 then
						nScale = basicInfo.power_skill[1][1]
						nPosX = basicInfo.power_skill[1][2]
						nPosY = basicInfo.power_skill[1][3]
					end
					spineFrame:setScale(nScale)
					spineFrame:setRelativePosition(GlobalMethod:ccp(nPosX,nPosY))
				end

				local nScale = 1
				local nPosX = 0.5
				local nPosY = 0.5
				if basicInfo.power_skill ~= -1 then
					nScale = basicInfo.power_skill[1][1]
					nPosX = basicInfo.power_skill[1][2]
					nPosY = basicInfo.power_skill[1][3]
				end
				spineFrame:setScale(nScale)
				spineFrame:setRelativePosition(GlobalMethod:ccp(nPosX,nPosY))
			end
		end
	else
		spineFrame:setFileJson("")
		spineFrame:setFileAtlas("")
	end
	--头像特效框
	local headEffectId = WndCheckOther.m_tPlayerInfo.headEffectId
	local spineHeadEffect = GetElement(self.m_root, "spineHeadEffect_CellCheckOther3", WZUISpine)
	if headEffectId and headEffectId > 0 then 
		local basicInfo = GDatatab_item["id_" .. headEffectId]
		if basicInfo then 
			local effectFile = "checkother/ui_playerhead_effect" .. basicInfo.value

			local existSpine = CheckEffectFile(effectFile)
			if existSpine then 
				if spineHeadEffect then 
					spineHeadEffect:setFileJson("")
					spineHeadEffect:setFileAtlas("")
					spineHeadEffect:setFileJson(effectFile .. ".json")
					spineHeadEffect:setFileAtlas(effectFile .. ".atlas")

					spineHeadEffect:play("wait_2", true)

					--调整头像特效框大小位置
					local conHeadEffect = GetElement(self.m_root,"conHeadEffect_CellCheckOther3",WZUIContainer)
					local nScale = 1
					local nPosX = 0.5
					local nPosY = 0.5
					if basicInfo.power_skill ~= -1 then
						nScale = basicInfo.power_skill[1][4]
						nPosX = basicInfo.power_skill[1][5]
						nPosY = basicInfo.power_skill[1][6]
					end
					conHeadEffect:setScale(nScale)
					conHeadEffect:setRelativePosition(GlobalMethod:ccp(nPosX,nPosY))
				end
			else
				local sIndex = string.format("%04d", basicInfo.value)
	            local downloadInfo = GetDownloadInfo(sIndex, "playerhead_effect")
	            if downloadInfo == nil then return end 

	            DownloadManager:addDownloadTask(7000 + tonumber(sIndex),downloadInfo.url,downloadInfo.md5,sIndex,"DownloadResourceCallback", _G)
			end
		end
	else
		spineHeadEffect:setFileJson("")
		spineHeadEffect:setFileAtlas("")
	end

	--小孩头像框
	self:showKidHeadEffect()
end

--@brief 	显示小孩头像框
function CellCheckOther3:showKidHeadEffect()
	local tKidData = json.decode(WndCheckOther.m_tPlayerInfo.childMes)
	local nKidNum = #tKidData 

	for i = 1, nKidNum do
		local conHead = GetElement(self.m_root, "conMyHead_CellCheckOther3", WZUIContainer)
		if i == 2 then 
			conHead = GetElement(self.m_root, "conMateHead_CellCheckOther3", WZUIContainer)
		end

		--头像特效框
		local headEffectId = tKidData[i].headFrameId
		local spineHeadEffect = GetElement(conHead, "spineKidHeadEffect_CellCheckOther3", WZUISpine)
		if headEffectId and headEffectId > 0 then 
			local basicInfo = GDatatab_item["id_" .. headEffectId]
			if basicInfo then 
				local sIndex = string.format("%04d", basicInfo.value)
				local effectFile = "checkother/ui_babyhead_effect" .. sIndex

				local existSpine = CheckEffectFile(effectFile)
				if existSpine then 
					if spineHeadEffect then 
						spineHeadEffect:setFileJson("")
						spineHeadEffect:setFileAtlas("")
						spineHeadEffect:setFileJson(effectFile .. ".json")
						spineHeadEffect:setFileAtlas(effectFile .. ".atlas")
						spineHeadEffect:setScale(0.5)

						spineHeadEffect:play("wait_2", true)
						
						--调整头像特效框大小位置
						local conKidHeadEffect = GetElement(conHead,"conKidHeadEffect_CellCheckOther3",WZUIContainer)
						local nScale = 1
						local nPosX = 0.5
						local nPosY = 0.5
						if basicInfo.power_skill ~= -1 then
							nScale = basicInfo.power_skill[1][4]
							nPosX = basicInfo.power_skill[1][5]
							nPosY = basicInfo.power_skill[1][6]
						end
						conKidHeadEffect:setScale(nScale)
						conKidHeadEffect:setRelativePosition(GlobalMethod:ccp(nPosX,nPosY))
					end
				else
		            local downloadInfo = GetDownloadInfo(sIndex, "babyhead_effect")
		            if downloadInfo == nil then return end 

		            DownloadManager:addDownloadTask(7000 + tonumber(sIndex),downloadInfo.url,downloadInfo.md5,sIndex,"DownloadResourceCallback", _G)
				end
			end
		else
			spineHeadEffect:setFileJson("")
			spineHeadEffect:setFileAtlas("")
		end
	    
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	显示space信息
function CellCheckOther3:update()
	if CheckButtonShow(63) ~= true then
		GetElement(self.m_root,"conTouxiang1_CellCheckOther3",WZUIClippingContainer):setVisible(false)
		GetElement(self.m_root,"conTouxiang2_CellCheckOther3",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conTouxiang3_CellCheckOther3",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"imgSexSpace",WZUIImage):setVisible(false)
		GetElement(self.m_root,"btnTouxiang_CellCheckOther3",WZUIButton):setVisible(false)
	end
	if WndCheckOther.m_tPlayerInfo.id ~= CacheCenter:getPlayerInfo().id then 
		for i = 1, 5 do
			GetElement(self.m_root, "btnSet" .. i .. "_CellCheckOther3", WZUIButton):setVisible(false)
		end
	end
	--信息位置
	GetElement(self.m_root,"conInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.7325,0.32))
	--ID
	GetElement(self.m_root,"ttfID",WZUILabelTTF):setText(WndCheckOther.m_tPlayerInfo.id)
	--城市年龄星座
	self:_showCityAndAge()
	--服务器
	local serverName = CacheCenter:getServerNameByServerId(WndCheckOther.m_tPlayerInfo.serverId)
	if serverName == nil or serverName == "" then
		serverName = IPDhttpServer:getNameById(WndCheckOther.m_tPlayerInfo.serverId)
	end
	GetElement(self.m_root,"ttfServer",WZUILabelTTF):setText(serverName)
	GetElement(self.m_root,"title5",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.32,0.15))
	--下载头像
	WZLog("WndCheckOther.m_tPlayerInfo.headScul",WndCheckOther.m_tPlayerInfo.headScul)
	self:setPhoteWords()
	self:showPhotoHead()
	self:_showKidHead()
	self:showInfoRectEffect()
end

--@brief 	显示城市、年龄、星座
function CellCheckOther3:_showCityAndAge()
	--城市
	if WndCheckOther.m_tData == nil then return end 
	local city = LocalStrings.SPACE_CITY2
	if WndCheckOther.m_tData.cityCode > 0 then 
		local nId = math.floor(WndCheckOther.m_tData.cityCode/100)
		self.m_nCityId = nId 
		local nCityIndex = WndCheckOther.m_tData.cityCode%100
		WZLog("CellCheckOther3:update", nId, nCityIndex)
		local configData = GDatatab_city["id_" .. nId]
		city = configData.province
		if configData.city ~= 0 then 
			local cityList = SplitStringWithSeparator(configData.city, "|")
			if cityList[nCityIndex] then 
				self.m_nCityIndex = nCityIndex 
				city = city .. cityList[nCityIndex]
			end
		end
	end
	GetElement(self.m_root,"ttfCity_CellCheckOther3",WZUILabelTTF):setText(city)
	--星座
	if WndCheckOther.m_tData.playerCon == 0 then 
		GetElement(self.m_root,"ttfStarSeat_CellCheckOther3",WZUILabelTTF):setText(LocalStrings.SPACE_CITY2)
	else
		GetElement(self.m_root,"ttfStarSeat_CellCheckOther3",WZUILabelTTF):setText(CONSTELLATION[WndCheckOther.m_tData.playerCon])
	end
	--年龄
	if WndCheckOther.m_tData.playerAge == 0 then 
		GetElement(self.m_root,"ttfAge_CellCheckOther3",WZUILabelTTF):setText(LocalStrings.SPACE_CITY2)
	else
		GetElement(self.m_root,"ttfAge_CellCheckOther3",WZUILabelTTF):setText(WndCheckOther.m_tData.playerAge .. LocalStrings.SPACE91)
	end
end

--@brief 	显示上传的头像
function CellCheckOther3:showPhotoHead()
	--根据性别设置默认头像
	local imgHead = {"ui/space/common_rx_nan.png","ui/space/common_rx_nv.png"}
	local sex = WndCheckOther.m_tPlayerInfo.spaceSex
	local headSex = WndCheckOther.m_tPlayerInfo.sex
	local headSpace = GetElement(self.m_root,"headSpace",WZUIImage)
	headSpace:setScale(0.8)
    if sex == 0 then
		headSpace:setFile(imgHead[1])
		GetElement(self.m_root,"imgSexSpace",WZUIImage):setFile("ui/space/common_icon_hanzi2.png")
	elseif sex == 1 then
		headSpace:setFile(imgHead[2])
		GetElement(self.m_root,"imgSexSpace",WZUIImage):setFile("ui/space/common_icon_meizhi2.png")
	else
		GetElement(self.m_root,"imgSexSpace",WZUIImage):setVisible(false)

		if headSex == 0 then
			headSpace:setFile(imgHead[1])
		elseif headSex == 1 then
			headSpace:setFile(imgHead[2])
		end
	end
	WZLog("CellCheckOther3:showPhotoHead 00000")
	if WndCheckOther.m_tPlayerInfo.headScul == nil then return end
	if WndCheckOther.m_tPlayerInfo.headScul == "" then return end
	WZLog("CellCheckOther3:showPhotoHead",WndCheckOther.m_tPlayerInfo.headScul)
	local fileName = WndCheckOther.m_tPlayerInfo.headScul
	--如果有设置默认头像
	if string.find(fileName, [[http]]) ~= nil then
		local downURL = fileName
		local photoName = WndAdvertising:getFileName(fileName)
		--如果文件存在，不下载，直接使用
		local imgPhoto = GetElement(self.m_root,"headSpace",WZUIImage)
		local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..photoName
		local bExist = WZFileUtil:isFileExist(path)
		local platForm =  WZUISystem:getInstance():getPlatformInfo()
		WZLog("判断baidu文件是否存在",path,photoName,bExist)
		downURL = downURL:gsub("\n","")
		downURL = downURL:gsub("\r","")
		if bExist then
			imgPhoto:setVisible(true)
			imgPhoto:setUseOriginSize(true)
			imgPhoto:setFile(path)
			local size = imgPhoto:getContentSize()
			local hh = 125
			local x = hh/size.width 
			local y = hh/size.height
			imgPhoto:setScale(math.min(x,y))
		elseif downURL ~= "" then
			if platForm == 3 then
				path = photoName
			end
			local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
			local downloadTask = WZHTTPFileLuaTask:create(CacheCenter:getPlayerInfo().id, downURL, path, self.httpDownloadFinish, self)
			multiThread:addDownloadTaskInFront(downloadTask)
		end
		return
	end
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..fileName
	local bExist = WZFileUtil:isFileExist(path)
	self.m_sHeadPath = path
	WZLog("CellCheckOther3:showPhotoHead 11111", bExist, path)
	if bExist then
		local imgPhoto = GetElement(self.m_root,"headSpace",WZUIImage)
		imgPhoto:setFile(path)
		local size = imgPhoto:getContentSize()
		local hh = 128
		local x = hh/size.width 
		local y = hh/size.height
		imgPhoto:setScale(math.max(x,y))
	else
		local s = {}
		s.filePath = path
		s.objName = fileName
		DSSdkManager:downFile(json.encode(s),self.downloadFileFinish, self)
	end
end
--@brief	http下载回调
function CellCheckOther3:httpDownloadFinish(taskId, path, totalSize, nowSize, finish, failed)
	WZLog("CellCheckOther3:httpDownloadFinish",taskId,finish,path,failed)
	if taskId ~= CacheCenter:getPlayerInfo().id then
		return
	end
	if self.m_root == nil then
		return
	elseif finish then
		WZLog("pathxxxxxxxqWWWWWWWWWWWW:::",path)
		local imgPhoto = GetElement(self.m_root,"headSpace",WZUIImage)
		imgPhoto:setVisible(true)
		imgPhoto:setUseOriginSize(true)
		imgPhoto:setFile(path)
		local size = imgPhoto:getContentSize()
		local hh = 125
		local x = hh/size.width 
		local y = hh/size.height
		imgPhoto:setScale(math.min(x,y))
	else
		WZLog("taskId:::::::::::::::::::::::::::::::",taskId)
	end
end

--@brief	下载成功回调
function CellCheckOther3:downloadFileFinish(result)
	if self.m_root == nil then return end
	local result = json.decode(result)
	local fileName = result.objName
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..result.objName
	WZLog("CellCheckOther3:downloadFileFinish 下载完成",path)

	local imgPhoto = GetElement(self.m_root,"headSpace",WZUIImage)
	imgPhoto:setFile(path)
	local size = imgPhoto:getContentSize()
	local hh = 128
	local x = hh/size.width 
	local y = hh/size.height
	imgPhoto:setScale(math.max(x,y))
end

--@brief	查看大图
function CellCheckOther3:onCheck()
	WZLog("CellCheckOther3:onCheck",self.m_sHeadPath)
	--没上传照片的玩家点击无效
	if self.m_sHeadPath == nil or self.m_sHeadPath == "" or WndCheckOther.m_tPlayerInfo.headSculStatus == 2 then
		if WndCheckOther.m_tPlayerInfo.id == CacheCenter:getPlayerInfo().id then 
			self:popMenu()
		end 
		return
	end

	local wnd = WndSpaceView:createElement()
	WindowManager:addWindow(wnd, WndSpaceView, true, nil, nil, true)
	
	--根据性别设置默认头像
	local imgHead = {"ui/space/common_rx_nan.png","ui/space/common_rx_nv.png"}
	local sex = WndCheckOther.m_tPlayerInfo.spaceSex
	local headSex = WndCheckOther.m_tPlayerInfo.sex
	local imgShow
    if sex == 0 then
		imgShow = imgHead[1]
	elseif sex == 1 then
		imgShow = imgHead[2]
	else
		if headSex == 0 then
			imgShow = imgHead[1]
		elseif headSex == 1 then
			imgShow = imgHead[2]
		end
	end

	--如果已经下载头像
	local imgSpaceView = GetElement(wnd,"imgWndSpaceView",WZUIImage)
	if self.m_sHeadPath ~= nil and self.m_sHeadPath ~= "" then
		local path = self.m_sHeadPath
		--如果文件存在，不下载，直接使用
		local bExist = WZFileUtil:isFileExist(path)
		if bExist then
			imgSpaceView:setFile(path)
			adaptPhoto(imgSpaceView)
		else
			imgSpaceView:setFile(imgShow)
		end
	else
		imgSpaceView:setFile(imgShow)
	end
end

--@brief	拍照上传
function CellCheckOther3:onUpload1(element)
    WZLog("CellCheckOther3:onBtn1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--上传照片等级限制
	if CheckButtonOpen(63) ~= true then return end

	local deviceHelper = WZDeviceHelper:sharedDeviceHelper()
	deviceHelper:setPickerIndex(0)
	deviceHelper:imageCropper(CellCheckOther3.onPhotoBack , CellCheckOther3)

	WndCheckOther.m_nUploadType = 0
	WndCheckOther.m_tUploadCell = self
end

--@brief	本地上传
function CellCheckOther3:onUpload2(element)
    WZLog("CellCheckOther3:onBtn2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--上传照片等级限制
	if CheckButtonOpen(63) ~= true then return end

	local deviceHelper = WZDeviceHelper:sharedDeviceHelper()
	deviceHelper:setPickerIndex(1)
	deviceHelper:imageCropper(CellCheckOther3.onPhotoBack , CellCheckOther3)

	WndCheckOther.m_nUploadType = 1
	WndCheckOther.m_tUploadCell = self
end

--@brief	打开图片回调函数
function CellCheckOther3:onPhotoBack(file)
    local tCell = self
	WZLog("file::::::::",file,WZFileUtil:getFileSize(file),math.floor(WZFileUtil:getFileSize(file)/1000000) )
	--文件路径
	if WZFileUtil:isFullPathExist(file) == false then
        CCLuaLog("------upload file not exist!")
        return
    end
	if math.floor(WZFileUtil:getFileSize(file)/1000000) > 5 then
		WZLog("文件大于1M:::")
		return
	end

	local wnd = WndSpaceUploadConfirm:showInterface(2)

	local imgPhoto = GetElement(wnd,"imgHead1",WZUI9Image)
	imgPhoto:setUseOriginSize(true)
	imgPhoto:setFile(file)
	local size = imgPhoto:getContentSize()
	local hh = 100
	local x = hh/size.width 
	local y = hh/size.height
	imgPhoto:setScale(math.min(x,y))
	local imgPhoto1 = GetElement(wnd,"imgHead2",WZUI9Image)
	imgPhoto1:setUseOriginSize(true)
	imgPhoto1:setFile(file)
	imgPhoto1:setScale(math.min(x,y))
end

--@brief	上传菜单
function CellCheckOther3:setUploadMenuItems()
	local tPopupMenuItems = {}

	--显示拍照上传按钮
    if getTotalMemory() > 900 then
    	if not isChannelPC() then 
			table.insert(tPopupMenuItems,POPUPMENU_SPACE4)
		end
	end

	--显示本地上传按钮
	table.insert(tPopupMenuItems,POPUPMENU_SPACE5)

	return tPopupMenuItems
end

--@brief 	弹出上传照片菜单
function CellCheckOther3:popMenu()
	-- body
	local conInfo = GetElement(WndCheckOther.m_root, "conInfo_WndCheckOther", WZUIContainer)
	local sizeCon = conInfo:getAbsContentSize()
	
	local popupMenu = WndPopupMenu:createElement()
	conInfo:addChild(popupMenu)	
	popupMenu:setVisible(true)

	WndPopupMenu:disappear()

	local menuList = self:setUploadMenuItems()
	WndPopupMenu:setPopupMenuItem(menuList,nil)
	WndPopupMenu:setCallBackFunc(self, self.onClickPopup)

	if self.m_root ~= nil then
		WndPopupMenu:popUpAtPoint(conInfo, ccp((sizeCon.width - 190)/2, 320))
	end 
	--调用全局方法检查权限
	requestPermission()
end

--@brief  按钮回调函数
function CellCheckOther3:onClickPopup(element,nId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPopupMenu:disappear()
	if nId == POPUPMENU_SPACE1 then 	
		self:onView()
	elseif nId == POPUPMENU_SPACE2 then   
		self:setHead()
	elseif nId == POPUPMENU_SPACE3 then
		self:onDelete()
	elseif nId == POPUPMENU_SPACE4 then
		self:onUpload1()
	elseif nId == POPUPMENU_SPACE5 then
		self:onUpload2()
	end
end

--@brief 	設置上传照片文字提示
function CellCheckOther3:setPhoteWords()
	-- body
	if self.m_root == nil then return end 
	if WndCheckOther.m_tPlayerInfo.id ~= CacheCenter:getPlayerInfo().id then return end 
	local txtPhotoWord = GetElement(self.m_root, "txtPhotoWord_CellCheckOther3", WZUILabelTTF)
	local fileName = WndCheckOther.m_tPlayerInfo.headScul
	if txtPhotoWord then
		if fileName == nil or fileName == "" or WndCheckOther.m_tPlayerInfo.headSculStatus == 2 then
			txtPhotoWord:setText(LocalStrings.SPACE73)
		elseif WndCheckOther.m_tPlayerInfo.headSculStatus == 3 then
			txtPhotoWord:setText(LocalStrings.SPACE99)
		else
			txtPhotoWord:setText("")
		end
	end
end

--@brief 	显示玩家头像
function CellCheckOther3:_showPlayerHead()
	-- body
	local conMyHead = GetElement(self.m_root, "conMyHead_CellCheckOther3", WZUIContainer)
	-- WZLog("_showPlayerHead", Serialize(WndCheckOther.m_tPlayerInfo.item))
	local headId, faceId = nil, nil 
	for i = 1, #WndCheckOther.m_tPlayerInfo.item do
		if WndCheckOther.m_tPlayerInfo.item[i].maintype == 5 and WndCheckOther.m_tPlayerInfo.item[i].subtype == 0 and WndCheckOther.m_tPlayerInfo.item[i].isUse == true then 
			headId = WndCheckOther.m_tPlayerInfo.item[i].basicInfo.id
		elseif WndCheckOther.m_tPlayerInfo.item[i].maintype == 5 and WndCheckOther.m_tPlayerInfo.item[i].subtype == 1 and WndCheckOther.m_tPlayerInfo.item[i].isUse == true then 
			faceId = WndCheckOther.m_tPlayerInfo.item[i].basicInfo.id
		end
		if headId and faceId then 
			break 
		end
	end
	local gameParam = CacheCenter:getGameParam()
	if sex == 1 then
		if headId == nil or headId == 0 then
			headId = gameParam.defaultWomanHeadId or 4906
		end

		if faceId == nil or faceId == 0 then
			faceId = gameParam.defaultWomanFaceId or 4905
		end
		
	else
		if headId == nil or headId == 0 then
			headId = gameParam.defaultManHeadId or 4903
		end

		if faceId == nil or faceId == 0 then
			faceId = gameParam.defaultManFaceId or 4902
		end
	end
	WZLog("_showPlayerHead hhhhh", headId, faceId, WndCheckOther.m_tPlayerInfo.sex)
	local celHead = CellHead:show(conMyHead, headId, faceId, WndCheckOther.m_tPlayerInfo.sex, false, nil, nil, WndCheckOther.m_tPlayerInfo.headColor,"ui/common/common_scale9_zhezhao1.png", 1.15)
	celHead:setScale(0.9)
	if WndCheckOther.m_tPlayerInfo.sex == 0 then 
		GetElement(self.m_root, "imgDiTuHead_CellCheckOther3", WZUIImage):setFile("ui/space/common_rx_nv.png")
	end
	if WndCheckOther.m_tPlayerInfo.mateName and WndCheckOther.m_tPlayerInfo.mateName ~= "" then 
		local conMateHead = GetElement(self.m_root, "conMateHead_CellCheckOther3", WZUIContainer)
		if WndCheckOther.m_tPlayerInfo.coupleMes and WndCheckOther.m_tPlayerInfo.coupleMes ~= "" then 
			local tIdList = SplitStringWithSeparator(WndCheckOther.m_tPlayerInfo.coupleMes, "|", nil, true)
			celHead = CellHead:show(conMateHead, tIdList[2], tIdList[1], WndCheckOther.m_tPlayerInfo.sex == 0 and 1 or 0, false, nil, nil, tIdList[3],"ui/common/common_scale9_zhezhao1.png", 1.15)
			celHead:setScale(0.9)

			GetElement(self.m_root, "imgDiTuHead_CellCheckOther3", WZUIImage):setVisible(false)
		end
	end
end

--@brief 	显示小孩头像
function CellCheckOther3:_showKidHead()
	-- body
	local tKidData = json.decode(WndCheckOther.m_tPlayerInfo.childMes)
	local nKidNum = #tKidData 

	for i = 1, nKidNum do
		local tEquip = {}
		local conHead = GetElement(self.m_root, "conMyHead_CellCheckOther3", WZUIContainer)
		GetElement(self.m_root, "imgDiTuHead1_CellCheckOther3", WZUIImage):setVisible(false)
		if i == 2 then 
			conHead = GetElement(self.m_root, "conMateHead_CellCheckOther3", WZUIContainer)
			GetElement(self.m_root, "imgDiTuHead_CellCheckOther3", WZUIImage):setVisible(false)
		end

	    table.insert(tEquip,tKidData[i].headId)
	    table.insert(tEquip,tKidData[i].faceId)
	    table.insert(tEquip,tKidData[i].bodyId)

	    local kidHead, tCell = CellHead:show(conHead, tKidData[i].headId, tKidData[i].faceId, tKidData[i].sex, nil, nil, nil, nil, nil, nil, nil, true)
	    kidHead:setScale(1)
	    tCell:setHideBg()
	end

end

--@brief 	显示玩家的年月日和城市
function CellCheckOther3:showBirthdayAndCity()
	if WndCheckOther.m_tData == nil then return end 
	local txtContent1 = GetElement(self.m_root, "txtContent1_CellCheckOther3", WZUILabelTTF)
	local txtContent2 = GetElement(self.m_root, "txtContent2_CellCheckOther3", WZUILabelTTF)
	local txtContent3 = GetElement(self.m_root, "txtContent3_CellCheckOther3", WZUILabelTTF)
	local txtContent4 = GetElement(self.m_root, "txtContent4_CellCheckOther3", WZUILabelTTF)
	local txtContent5 = GetElement(self.m_root, "txtContent5_CellCheckOther3", WZUILabelTTF)

	txtContent1:setText(LocalStrings.SPACE_CITY2)
	txtContent2:setText(LocalStrings.SPACE_CITY2)
	txtContent3:setText(LocalStrings.SPACE_CITY2)
	txtContent4:setText(LocalStrings.SPACE_CITY2)
	txtContent5:setText(LocalStrings.SPACE_CITY2)
	if WndCheckOther.m_tData.birthday and WndCheckOther.m_tData.birthday ~= "" then 
		local birthday = json.decode(WndCheckOther.m_tData.birthday)

		if birthday.year and tonumber(birthday.year) and tonumber(birthday.year) > 0 then 
			self.m_nYear = tonumber(birthday.year) 
			txtContent1:setText(birthday.year .. LocalStrings.SPACE30)
		end
		if birthday.month and tonumber(birthday.month) and tonumber(birthday.month) > 0 then 
			self.m_nMonth = tonumber(birthday.month) 
			txtContent2:setText(birthday.month .. LocalStrings.SPACE31)
		end
		if birthday.day and tonumber(birthday.day) and tonumber(birthday.day) > 0 then 
			self.m_nDay = tonumber(birthday.day)
			txtContent3:setText(birthday.day .. LocalStrings.SPACE32)
		end
	end
	if WndCheckOther.m_tData.cityCode > 0 then 
		local nId = math.floor(WndCheckOther.m_tData.cityCode/100)
		self.m_nCityId = nId 
		local nCityIndex = WndCheckOther.m_tData.cityCode%100
		WZLog("CellCheckOther3:showBirthdayAndCity", nId, nCityIndex)
		local configData = GDatatab_city["id_" .. nId]
		txtContent4:setText(configData.province)
		if configData.city ~= 0 then 
			GetElement(self.m_root, "btnSet5_CellCheckOther3", WZUIButton):setVisible(true)
			local cityList = SplitStringWithSeparator(configData.city, "|")
			if cityList[nCityIndex] then 
				self.m_nCityIndex = nCityIndex 
				txtContent5:setText(cityList[nCityIndex])
			end
		else
			GetElement(self.m_root, "btnSet5_CellCheckOther3", WZUIButton):setVisible(false)
		end
	else
		GetElement(self.m_root, "btnSet5_CellCheckOther3", WZUIButton):setVisible(false)
	end
end

--@brief	设置数据
function CellCheckOther3:resetData()
	--计算出生日期
	if WndCheckOther.m_tData == nil then return end 
	if self.m_root == nil then return end 

	local nCurSelYear = self.m_nYear or os.date("%Y")
	local age = os.date("%Y") - nCurSelYear
	local month = self.m_nMonth or 0
	local day = self.m_nDay or 0

	WndCheckOther.m_tData.birthday = json.encode({year=nCurSelYear,month=month,day=day})

	WndCheckOther.m_tData.playerAge = age

	--计算星座
	local constellation = LocalStrings.SPACE_CITY2
	local city = LocalStrings.SPACE_CITY2
	if day > 0 then 
		if month == 1 then
			if day <= 19 then
				constellation = LocalStrings.SPACE88
				WndCheckOther.m_tData.playerCon = 10
			else
				constellation = LocalStrings.SPACE89
				WndCheckOther.m_tData.playerCon = 11
			end
		elseif month == 2 then
			if day <= 18 then
				constellation = LocalStrings.SPACE89
				WndCheckOther.m_tData.playerCon = 11
			else
				constellation = LocalStrings.SPACE90
				WndCheckOther.m_tData.playerCon = 12
			end
		elseif month == 3 then
			if day <= 20 then
				constellation = LocalStrings.SPACE90
				WndCheckOther.m_tData.playerCon = 12
			else
				constellation = LocalStrings.SPACE79
				WndCheckOther.m_tData.playerCon = 1
			end
		elseif month == 4 then
			if day <= 19 then
				constellation = LocalStrings.SPACE79
				WndCheckOther.m_tData.playerCon = 1
			else
				constellation = LocalStrings.SPACE80
				WndCheckOther.m_tData.playerCon = 2
			end
		elseif month == 5 then
			if day <= 20 then
				constellation = LocalStrings.SPACE80
				WndCheckOther.m_tData.playerCon = 2
			else
				constellation = LocalStrings.SPACE81
				WndCheckOther.m_tData.playerCon = 3
			end
		elseif month == 6 then
			if day <= 21 then
				constellation = LocalStrings.SPACE81
				WndCheckOther.m_tData.playerCon = 3
			else
				constellation = LocalStrings.SPACE82
				WndCheckOther.m_tData.playerCon = 4
			end
		elseif month == 7 then
			if day <= 22 then
				constellation = LocalStrings.SPACE82
				WndCheckOther.m_tData.playerCon = 4
			else
				constellation = LocalStrings.SPACE83
				WndCheckOther.m_tData.playerCon = 5
			end
		elseif month == 8 then
			if day <= 22 then
				constellation = LocalStrings.SPACE83
				WndCheckOther.m_tData.playerCon = 5
			else
				constellation = LocalStrings.SPACE84
				WndCheckOther.m_tData.playerCon = 6
			end
		elseif month == 9 then
			if day <= 22 then
				constellation = LocalStrings.SPACE84
				WndCheckOther.m_tData.playerCon = 6
			else
				constellation = LocalStrings.SPACE85
				WndCheckOther.m_tData.playerCon = 7
			end
		elseif month == 10 then
			if day <= 23 then
				constellation = LocalStrings.SPACE85
				WndCheckOther.m_tData.playerCon = 7
			else
				constellation = LocalStrings.SPACE86
				WndCheckOther.m_tData.playerCon = 8
			end
		elseif month == 11 then
			if day <= 22 then
				constellation = LocalStrings.SPACE86
				WndCheckOther.m_tData.playerCon = 8
			else
				constellation = LocalStrings.SPACE87
				WndCheckOther.m_tData.playerCon = 9
			end
		elseif month == 12 then
			if day <= 21 then
				constellation = LocalStrings.SPACE87
				WndCheckOther.m_tData.playerCon = 9
			else
				constellation = LocalStrings.SPACE88
				WndCheckOther.m_tData.playerCon = 10
			end
		end
	end

	if self.m_nCityId and self.m_nCityId > 0 then 
		local configData = GDatatab_city["id_" .. self.m_nCityId]
		city = configData.province
		WndCheckOther.m_tData.cityCode = self.m_nCityId * 100
		if configData.city ~= 0 and self.m_nCityIndex and self.m_nCityIndex > 0 then 
			local cityList = SplitStringWithSeparator(configData.city, "|")
			if cityList[self.m_nCityIndex] then 
				city = city .. cityList[self.m_nCityIndex]
			end
			WndCheckOther.m_tData.cityCode = WndCheckOther.m_tData.cityCode + self.m_nCityIndex
		end
	end

	--设置年龄星座
	GetElement(self.m_root,"ttfAge_CellCheckOther3",WZUILabelTTF):setText(age..LocalStrings.SPACE91)
	GetElement(self.m_root,"ttfStarSeat_CellCheckOther3",WZUILabelTTF):setText(constellation)
	GetElement(self.m_root,"ttfCity_CellCheckOther3",WZUILabelTTF):setText(city)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellCheckOther3:_adaptLanguage_vn(  )
	local title1 = GetElement(self.m_root, "title1", WZUILabelTTF)
	title1:setScale(0.7)
	local title2 = GetElement(self.m_root, "title2", WZUILabelTTF)
	title2:setScale(0.7)
	local title3 = GetElement(self.m_root, "title3", WZUILabelTTF)
	title3:setScale(0.7)
	local title4 = GetElement(self.m_root, "title4", WZUILabelTTF)
	title4:setScale(0.7)
	local title5 = GetElement(self.m_root, "title5", WZUILabelTTF)
	title5:setScale(0.55)

	local ttfID = GetElement(self.m_root,"ttfID",WZUILabelTTF)
	ttfID:setRelativePosition(GlobalMethod:ccp(0.62,0.95))
	ttfID:setScale(0.7)
	local ttfServer = GetElement(self.m_root,"ttfServer",WZUILabelTTF)
	ttfServer:setScale(0.7)
	local ttfAge = GetElement(self.m_root,"ttfAge_CellCheckOther3",WZUILabelTTF)
	ttfAge:setScale(0.7)
	local ttfStarSeat = GetElement(self.m_root,"ttfStarSeat_CellCheckOther3",WZUILabelTTF)
	ttfStarSeat:setScale(0.7)
	local ttfCity = GetElement(self.m_root,"ttfCity_CellCheckOther3",WZUILabelTTF)
	ttfCity:setScale(0.7)

	local txtContent1 = GetElement(self.m_root, "txtContent1_CellCheckOther3", WZUILabelTTF)
	local txtContent2 = GetElement(self.m_root, "txtContent2_CellCheckOther3", WZUILabelTTF)
	local txtContent3 = GetElement(self.m_root, "txtContent3_CellCheckOther3", WZUILabelTTF)
	local txtContent4 = GetElement(self.m_root, "txtContent4_CellCheckOther3", WZUILabelTTF)
	local txtContent5 = GetElement(self.m_root, "txtContent5_CellCheckOther3", WZUILabelTTF)
	txtContent1:setScale(0.7)
	txtContent2:setScale(0.7)
	txtContent3:setScale(0.7)
	txtContent4:setScale(0.7)
	txtContent5:setScale(0.7)
end

function CellCheckOther3:_adaptLanguage_en(  )
	for i = 1, 5 do
		GetElement(self.m_root,"title"..i,WZUILabelTTF):setScale(0.8)
	end

	local ttfID = GetElement(self.m_root,"ttfID",WZUILabelTTF)
	ttfID:setRelativePosition(GlobalMethod:ccp(0.556894,0.95))
	ttfID:setScale(0.8)
	local ttfCity = GetElement(self.m_root,"ttfCity_CellCheckOther3",WZUILabelTTF)
	ttfCity:setRelativePosition(GlobalMethod:ccp(0.459242,0.15))
	ttfCity:setScale(0.8)
	local ttfServer = GetElement(self.m_root,"ttfServer",WZUILabelTTF)
	ttfServer:setScale(0.8)
end

function CellCheckOther3:_adaptLanguage_pt(  )
	for i = 1, 5 do
		GetElement(self.m_root,"title"..i,WZUILabelTTF):setScale(0.75)
	end

	local ttfID = GetElement(self.m_root,"ttfID",WZUILabelTTF)
	ttfID:setRelativePosition(GlobalMethod:ccp(0.652045,0.95))
	ttfID:setScale(0.75)
	local ttfCity = GetElement(self.m_root,"ttfCity_CellCheckOther3",WZUILabelTTF)
	ttfCity:setRelativePosition(GlobalMethod:ccp(0.477879,0.15))
	ttfCity:setScale(0.75)	
	ttfCity:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	ttfCity:setDimensions(GlobalMethod:CCSize(300))
	local ttfServer = GetElement(self.m_root,"ttfServer",WZUILabelTTF)
	ttfServer:setScale(0.75)
	
end

function CellCheckOther3:_adaptLanguage_tr(  )
	local ttfID = GetElement(self.m_root,"ttfID",WZUILabelTTF)
	if ttfID then
		ttfID:setRelativePosition(GlobalMethod:ccp(0.775,0.95))
	end
end

function CellCheckOther3:_adaptLanguage_es(  )
	for i = 1, 5 do
		GetElement(self.m_root,"title"..i,WZUILabelTTF):setScale(0.75)
	end

	local ttfID = GetElement(self.m_root,"ttfID",WZUILabelTTF)
	ttfID:setRelativePosition(GlobalMethod:ccp(0.652045,0.95))
	ttfID:setScale(0.75)
	local ttfCity = GetElement(self.m_root,"ttfCity_CellCheckOther3",WZUILabelTTF)
	ttfCity:setRelativePosition(GlobalMethod:ccp(0.477879,0.15))
	ttfCity:setScale(0.75)	
	ttfCity:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	ttfCity:setDimensions(GlobalMethod:CCSize(300))
	local ttfServer = GetElement(self.m_root,"ttfServer",WZUILabelTTF)
	ttfServer:setScale(0.75)
end

function CellCheckOther3:_adaptLanguage_ug(  )
	local title1 = GetElement(self.m_root,"title1",WZUILabelTTF)
	title1:setScale(0.8)
	title1:setAlignment(kCCTextAlignmentRight)
	title1:setAnchorPoint(GlobalMethod:ccp(1,0))
	title1:setRelativePosition(GlobalMethod:ccp(1.1,0.95))
	local title2 = GetElement(self.m_root,"title2",WZUILabelTTF)
	title2:setScale(0.8)
	title2:setAlignment(kCCTextAlignmentRight)
	title2:setAnchorPoint(GlobalMethod:ccp(1,0))
	title2:setRelativePosition(GlobalMethod:ccp(1.1,0.67))
	local title3 = GetElement(self.m_root,"title3",WZUILabelTTF)
	title3:setScale(0.8)
	title3:setAlignment(kCCTextAlignmentRight)
	title3:setAnchorPoint(GlobalMethod:ccp(1,0))
	title3:setRelativePosition(GlobalMethod:ccp(1.1,0.39))
	local title5 = GetElement(self.m_root,"title5",WZUILabelTTF)
	title5:setScale(0.8)
	title5:setAlignment(kCCTextAlignmentRight)
	title5:setAnchorPoint(GlobalMethod:ccp(1,0))
	title5:setRelativePosition(GlobalMethod:ccp(1.1,0.11))

	local ttfID = GetElement(self.m_root,"ttfID",WZUILabelTTF)
	ttfID:setRelativePosition(GlobalMethod:ccp(0.749696,0.95))
	ttfID:setScale(0.8)
	ttfID:setAlignment(kCCTextAlignmentRight)
	ttfID:setAnchorPoint(GlobalMethod:ccp(1,0))
	local ttfCommunity = GetElement(self.m_root,"ttfCommunity",WZUILabelTTF)
	ttfCommunity:setRelativePosition(GlobalMethod:ccp(0.877878,0.67))
	ttfCommunity:setScale(0.8)
	ttfCommunity:setAlignment(kCCTextAlignmentRight)
	ttfCommunity:setAnchorPoint(GlobalMethod:ccp(1,0))
	ttfCommunity:setDimensions(GlobalMethod:CCSize(240))
	local ttfBN = GetElement(self.m_root,"ttfBN",WZUILabelTTF)
	ttfBN:setRelativePosition(GlobalMethod:ccp(0.905151,0.39))
	ttfBN:setScale(0.8)
	ttfBN:setAlignment(kCCTextAlignmentRight)
	ttfBN:setAnchorPoint(GlobalMethod:ccp(1,0))
	local ttfServer = GetElement(self.m_root,"ttfServer",WZUILabelTTF)
	ttfServer:setRelativePosition(GlobalMethod:ccp(0.787272,0.193333))
	ttfServer:setScale(0.8)
	ttfServer:setAlignment(kCCTextAlignmentRight)
	ttfServer:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	ttfServer:setDimensions(GlobalMethod:CCSize(200))
end
-------------------------------------语言适配End--------------------------------------------