--CellCheckOther3.lua
--@brief	CellCheckOther3的UI模块
--@date		2015/07/06
--@author	zsq
--@note		玩家信息栏3


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
	--信息位置
	GetElement(self.m_root,"conInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.71,0.36))
	--ID
	GetElement(self.m_root,"ttfID",WZUILabelTTF):setText(WndCheckOther.m_tPlayerInfo.id)
	--公会
	GetElement(self.m_root,"ttfCommunity",WZUILabelTTF):setText(WndCheckOther.m_tPlayerInfo.guildName)
	--伴侣
	if WndCheckOther.m_tPlayerInfo.mateName == nil or WndCheckOther.m_tPlayerInfo.mateName == "" then
		GetElement(self.m_root,"ttfBN",WZUILabelTTF):setText(LocalStrings.NONE)
	else
		GetElement(self.m_root,"ttfBN",WZUILabelTTF):setText(WndCheckOther.m_tPlayerInfo.mateName)
	end
	--师傅
	local master = json.decode(WndCheckOther.m_tPlayerInfo.masterName)[1]
	if master ~= nil then
		GetElement(self.m_root,"ttfMaster",WZUILabelTTF):setText(master)
		GetElement(self.m_root,"title4",WZUILabelTTF):setText(LocalStrings.MASTER..":")
	else
		GetElement(self.m_root,"ttfMaster",WZUILabelTTF):setText(LocalStrings.NONE)
		GetElement(self.m_root,"title4",WZUILabelTTF):setText(LocalStrings.MASTER..":")
	end
	GetElement(self.m_root,"ttfMaster",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"title4",WZUILabelTTF):setVisible(false)
	--服务器
	local serverName = CacheCenter:getServerNameByServerId(WndCheckOther.m_tPlayerInfo.serverId)
	if serverName == nil or serverName == "" then
		serverName = IPDhttpServer:getNameById(WndCheckOther.m_tPlayerInfo.serverId)
	end
	GetElement(self.m_root,"ttfServer",WZUILabelTTF):setText(serverName)
	GetElement(self.m_root,"title5",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.32,0.11))
	GetElement(self.m_root,"ttfServer",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.54,0.11))
	--下载头像
	WZLog("WndCheckOther.m_tPlayerInfo.headScul",WndCheckOther.m_tPlayerInfo.headScul)
	self:setPhoteWords()
	self:showPhotoHead()
	self:_showPlayerHead()
end

--@brief 	显示上传的头像
function CellCheckOther3:showPhotoHead()
	--根据性别设置默认头像
	local imgHead = {"ui/space/common_icon_renxiangnan.png","ui/space/common_icon_renxiangnv.png"}
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
	local imgHead = {"ui/space/common_icon_renxiangnan.png","ui/space/common_icon_renxiangnv.png"}
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
	if self.m_sHeadPath ~= nil and self.m_sHeadPath ~= "" then
		local path = self.m_sHeadPath
		--如果文件存在，不下载，直接使用
		local bExist = WZFileUtil:isFileExist(path)
		if bExist then
			GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile(path)
		else
			GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile(imgShow)
		end
	else
		GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile(imgShow)
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
		table.insert(tPopupMenuItems,POPUPMENU_SPACE4)
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
	WZLog("_showPlayerHead", Serialize(WndCheckOther.m_tPlayerInfo.item))
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
		GetElement(self.m_root, "imgDiTuHead_CellCheckOther3", WZUIImage):setFile("ui/space/common_icon_renxiangnv.png")
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
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellCheckOther3:_adaptLanguage_vn(  )
	for i = 1, 5 do
		GetElement(self.m_root,"title"..i,WZUILabelTTF):setScale(0.8)
	end
	local ttfID = GetElement(self.m_root,"ttfID",WZUILabelTTF)
	ttfID:setRelativePosition(GlobalMethod:ccp(0.62,0.95))
	ttfID:setScale(0.8)
	local ttfCommunity = GetElement(self.m_root,"ttfCommunity",WZUILabelTTF)
	ttfCommunity:setRelativePosition(GlobalMethod:ccp(0.534849,0.67))
	ttfCommunity:setScale(0.8)
	local ttfBN = GetElement(self.m_root,"ttfBN",WZUILabelTTF)
	ttfBN:setRelativePosition(GlobalMethod:ccp(0.49697,0.39))
	ttfBN:setScale(0.8)
	local ttfServer = GetElement(self.m_root,"ttfServer",WZUILabelTTF)
	ttfServer:setRelativePosition(GlobalMethod:ccp(0.511515,0.11))
	ttfServer:setScale(0.8)
end

function CellCheckOther3:_adaptLanguage_en(  )
	for i = 1, 5 do
		GetElement(self.m_root,"title"..i,WZUILabelTTF):setScale(0.8)
	end

	local ttfID = GetElement(self.m_root,"ttfID",WZUILabelTTF)
	ttfID:setRelativePosition(GlobalMethod:ccp(0.556894,0.95))
	ttfID:setScale(0.8)
	local ttfCommunity = GetElement(self.m_root,"ttfCommunity",WZUILabelTTF)
	ttfCommunity:setRelativePosition(GlobalMethod:ccp(0.459242,0.67))
	ttfCommunity:setScale(0.8)
	local ttfBN = GetElement(self.m_root,"ttfBN",WZUILabelTTF)
	ttfBN:setRelativePosition(GlobalMethod:ccp(0.517803,0.39))
	ttfBN:setScale(0.8)
	local ttfServer = GetElement(self.m_root,"ttfServer",WZUILabelTTF)
	ttfServer:setRelativePosition(GlobalMethod:ccp(0.465,0.11))
	ttfServer:setScale(0.8)
end

function CellCheckOther3:_adaptLanguage_pt(  )
	for i = 1, 5 do
		GetElement(self.m_root,"title"..i,WZUILabelTTF):setScale(0.75)
	end

	local ttfID = GetElement(self.m_root,"ttfID",WZUILabelTTF)
	ttfID:setRelativePosition(GlobalMethod:ccp(0.652045,0.95))
	ttfID:setScale(0.75)
	local ttfCommunity = GetElement(self.m_root,"ttfCommunity",WZUILabelTTF)
	ttfCommunity:setRelativePosition(GlobalMethod:ccp(0.477879,0.762593))
	ttfCommunity:setScale(0.75)	
	ttfCommunity:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	ttfCommunity:setDimensions(GlobalMethod:CCSize(300))
	local ttfBN = GetElement(self.m_root,"ttfBN",WZUILabelTTF)
	ttfBN:setRelativePosition(GlobalMethod:ccp(0.520303,0.39))
	ttfBN:setScale(0.75)
	local ttfServer = GetElement(self.m_root,"ttfServer",WZUILabelTTF)
	ttfServer:setRelativePosition(GlobalMethod:ccp(0.526667,0.11))
	ttfServer:setScale(0.75)
	
end

function CellCheckOther3:_adaptLanguage_tr(  )
	local ttfID = GetElement(self.m_root,"ttfID",WZUILabelTTF)
	if ttfID then
		ttfID:setRelativePosition(GlobalMethod:ccp(0.775,0.95))
	end
	local ttfServer = GetElement(self.m_root,"ttfServer",WZUILabelTTF)
	ttfServer:setRelativePosition(GlobalMethod:ccp(0.565,0.11))
end

function CellCheckOther3:_adaptLanguage_es(  )
	for i = 1, 5 do
		GetElement(self.m_root,"title"..i,WZUILabelTTF):setScale(0.75)
	end

	local ttfID = GetElement(self.m_root,"ttfID",WZUILabelTTF)
	ttfID:setRelativePosition(GlobalMethod:ccp(0.652045,0.95))
	ttfID:setScale(0.75)
	local ttfCommunity = GetElement(self.m_root,"ttfCommunity",WZUILabelTTF)
	ttfCommunity:setRelativePosition(GlobalMethod:ccp(0.477879,0.762593))
	ttfCommunity:setScale(0.75)	
	ttfCommunity:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	ttfCommunity:setDimensions(GlobalMethod:CCSize(300))
	local ttfBN = GetElement(self.m_root,"ttfBN",WZUILabelTTF)
	ttfBN:setRelativePosition(GlobalMethod:ccp(0.520303,0.39))
	ttfBN:setScale(0.75)
	local ttfServer = GetElement(self.m_root,"ttfServer",WZUILabelTTF)
	ttfServer:setRelativePosition(GlobalMethod:ccp(0.526667,0.11))
	ttfServer:setScale(0.75)
end
-------------------------------------语言适配End--------------------------------------------