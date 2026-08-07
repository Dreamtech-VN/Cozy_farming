--CellMatchMaking.lua
--@brief	CellMatchMaking的UI模块
--@date		2018/06/20
--@author	Tianxiang_Xu
--@note		征婚中心-个人展示


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMatchMaking:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMatchMaking:onExit(element)
	self:_unInit()
end

--@brief    查看空间按钮回调
function CellMatchMaking:onCheckSpace(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSpaceMain:show(self.m_tData.id)
end

--@brief    点击私聊按钮回调
function CellMatchMaking:onChat(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndChat:showChatWindowForPrivateWithIdAndName(self.m_tData.id,self.m_tData.name, self.m_tData.sex, self.m_tData.level, self.m_tData.vipLevel, self.m_tData.headId, self.m_tData.faceId, self.m_tData.headColor)
end

--@brief    查看玩家信息
function CellMatchMaking:onCheckPlayerInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tData.id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	显示space信息
function CellMatchMaking:_update()
	--名字等级
	GetElement(self.m_root, "txtName_CellMatchMaking", WZUILabelTTF):setText(LocalStrings.LV .. self.m_tData.level .. " " .. self.m_tData.name)
	--公会名字
	if self.m_tData.communityName == nil or self.m_tData.communityName == "" then
		GetElement(self.m_root, "txtCommunityName_CellMatchMaking", WZUILabelTTF):setText(LocalStrings.COMMUNITY_COMPETE_TEXT44)
	else
		GetElement(self.m_root, "txtCommunityName_CellMatchMaking", WZUILabelTTF):setText(self.m_tData.communityName)
	end
	--战力
	GetElement(self.m_root, "aftxtFighting_CellMatchMaking", WZUILabelAtlasFont):setText(self.m_tData.fighting)
	--加油宣言
	GetElement(self.m_root, "txtDeclare_CellMatchMaking", WZUILabelTTF):setText(self.m_tData.declare)
	--vip头像
	self:setVipLevel()
	--推荐状态
	self:setRecommendState()

	--根据性别设置默认头像
	local imgHead = {"ui/space/common_icon_renxiangnan.png","ui/space/common_icon_renxiangnv.png"}
	local sex = self.m_tData.sex
    if sex == 0 then
		GetElement(self.m_root, "headSpace_CellMatchMaking", WZUIImage):setFile(imgHead[1])
	elseif sex == 1 then
		GetElement(self.m_root, "headSpace_CellMatchMaking", WZUIImage):setFile(imgHead[2])
	end
	--下载头像
	WZLog("self.m_tData.headScul", self.m_tData.headScul)
	if self.m_tData.headScul == nil then return end
	if self.m_tData.headScul == "" then return end
	WZLog("self.m_tData.headScul",self.m_tData.headScul)
	local fileName = self.m_tData.headScul
	--如果有设置默认头像
	if string.find(fileName, [[http]]) ~= nil then
		local downURL = fileName
		local photoName = WndAdvertising:getFileName(fileName)
		--如果文件存在，不下载，直接使用
		local imgPhoto = GetElement(self.m_root, "headSpace_CellMatchMaking", WZUIImage)
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
	WZLog("self.m_tData.headScul 11111", self.m_sHeadPath, bExist)
	if bExist then
		local headSpace = GetElement(self.m_root, "headSpace_CellMatchMaking", WZUIImage)
		headSpace:setFile(self.m_sHeadPath)
		local size = headSpace:getContentSize()
		local hh = 128
		local x = hh/size.width 
		local y = hh/size.height
		headSpace:setScale(math.max(x,y))
	else
		local s = {}
		s.filePath = path
		s.objName = fileName
		DSSdkManager:downFile(json.encode(s),self.downloadFileFinish, self)
	end
end

--@brief	http下载回调
function CellMatchMaking:httpDownloadFinish(taskId, path, totalSize, nowSize, finish, failed)
	WZLog("CellMatchMaking:httpDownloadFinish",taskId,finish,path,failed)
	if taskId ~= CacheCenter:getPlayerInfo().id then
		return
	end
	if self.m_root == nil then
		return
	elseif finish then
		WZLog("pathxxxxxxxqWWWWWWWWWWWW:::",path)
		local imgPhoto = GetElement(self.m_root, "headSpace_CellMatchMaking", WZUIImage)
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
function CellMatchMaking:downloadFileFinish(result)
	if self.m_root == nil then return end
	local result = json.decode(result)
	local fileName = result.objName
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..result.objName
	WZLog("下载完成",path)

	local imgPhoto = GetElement(self.m_root, "headSpace_CellMatchMaking", WZUIImage)
	imgPhoto:setFile(path)
	local size = imgPhoto:getContentSize()
	local hh = 128
	local x = hh/size.width 
	local y = hh/size.height
	imgPhoto:setScale(math.max(x,y))
end

--@brief	查看大图
function CellMatchMaking:onCheck()
	WZLog("CellMatchMaking:onCheck",self.m_sHeadPath)
	--没上传照片的玩家点击无效
	if self.m_sHeadPath == nil or self.m_sHeadPath == "" then
		return
	end

	local wnd = WndSpaceView:createElement()
	WindowManager:addWindow(wnd, WndSpaceView, true, nil, nil, true)
	
	--根据性别设置默认头像
	local imgHead = {"ui/space/common_icon_renxiangnan.png","ui/space/common_icon_renxiangnv.png"}
	local headSex = self.m_tData.sex
	local imgShow
	if headSex == 0 then
		imgShow = imgHead[1]
	elseif headSex == 1 then
		imgShow = imgHead[2]
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

--@brief 	设置vip等级
function CellMatchMaking:setVipLevel()
	-- body
	if self.m_tData.vipLevel > 0 then
		GetElement(self.m_root, "conVipLevel_CellMatchMaking", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "aftxtVipLevel_CellMatchMaking", WZUILabelAtlasFont):setText(self.m_tData.vipLevel)
	end
end

--@brief 	设置推荐状态
function CellMatchMaking:setRecommendState(bRecommendState)
	-- body
	if bRecommendState then
		self.m_tData.recommendState = bRecommendState
	end
	local imgRecommendIcon = GetElement(self.m_root, "imgRecommendIcon_CellMatchMaking", WZUIImage)
	if imgRecommendIcon then
		imgRecommendIcon:setVisible(self.m_tData.recommendState)
	end
end
-------------------------------------私有方法模块End----------------------------------------
