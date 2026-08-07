--CellAdvertising.lua
--@brief	CellAdvertising的UI模块
--@date		2016/09/24
--@author	zsq
--@note		广告cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAdvertising:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAdvertising:onExit(element)
	self:_unInit()
end

--@brief	跳转
function CellAdvertising:onJump()
	WZLog("WndAdvertising1:onJump", self.m_nJumpId, type(self.m_nJumpId), ProjConfig:getChannelId())
	--JumpByUIId(self.m_nJumpId)
		if self.ad_type == 1 then
			-- jumpResult = WndGameActivity:showInterface(tonumber(self.m_nJumpId))
			WndActivityIntegrate:showInterface(2, tonumber(self.m_nJumpId))
		elseif self.ad_type == 2 then
			WZPush:openURL(self.m_nJumpId)
		else
			if tonumber(self.m_nJumpId) == 222 then
				if tostring(ProjConfig:getChannelId()) ~= "53" and tostring(ProjConfig:getChannelId()) ~= "75" and tostring(ProjConfig:getChannelId()) ~= "275" and tostring(ProjConfig:getChannelId()) ~= "68" then
					jumpResult = JumpByUIId(self.m_nJumpId)
				end
			else
				jumpResult = JumpByUIId(self.m_nJumpId)
			end
		end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellAdvertising:setData(imgUrl, jumpTo, index, ad_type)
	self.m_nIndex = index or 0
	self.m_nJumpId = jumpTo
	self.ad_type = ad_type
	self:downLoadPhoto(imgUrl)
end

--@brief	下载图片
function CellAdvertising:downLoadPhoto(imgUrl)
	local imgPhoto = GetElement(self.m_root,"img_WndAdvertising",WZUIImage)
	GetElement(self.m_root,"conCover",WZUIContainer):setVisible(true)
	imgPhoto:setVisible(false)

	local photoName = "imgAdvertising"
	local downURL = imgUrl
	photoName = self:getFileName(downURL)

	downURL = downURL:gsub("\n","")
	downURL = downURL:gsub("\r","")
	--如果文件存在，不下载，直接使用
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..photoName
	local bExist = WZFileUtil:isFileExist(path)
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	WZLog("判断文件是否存在Cell",bExist,path)
	if bExist then
		imgPhoto:setVisible(true)
		imgPhoto:setUseOriginSize(true)
		imgPhoto:setFile("")
		imgPhoto:setFile(path)
		GetElement(self.m_root,"conCover",WZUIContainer):setVisible(false)
	elseif downURL ~= "" then
		if platForm == 3 then
			path = photoName
		end
		local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
		local downloadTask = WZHTTPFileLuaTask:create(CacheCenter:getPlayerInfo().id+self.m_nIndex, downURL, path, self.downLoadPhotoBackFun, self)
		multiThread:addDownloadTaskInFront(downloadTask)
		self.m_nDownLoading = true
	end
end

function CellAdvertising:getFileName(filename)
	local dest_filename = ""
	fn_flag = string.find(filename, "\\")
	if fn_flag then
		dest_filename = string.match(filename, ".+\\([^\\]*%.%w+)$")
	end
	
	fn_flag = string.find(filename, "/")
	if fn_flag then
		dest_filename = string.match(filename, ".+/([^/]*%.%w+)$")
	end
	return dest_filename
end

--@brief 	下载图片回调函数
function CellAdvertising:downLoadPhotoBackFun(taskId, path, totalSize, nowSize, finish, failed)
	WZLog("CellAdvertising:downLoadPhotoBackFun",taskId,finish,path,failed)
	if taskId ~= CacheCenter:getPlayerInfo().id then
		return
	end
	if self.m_root == nil then
		return
	elseif finish then
		WZLog("pathxxxxxxxqWWWWWWWWWWWW:::",path)
		local imgPhoto = GetElement(self.m_root,"img_WndAdvertising",WZUIImage)
		imgPhoto:setVisible(true)
		imgPhoto:setUseOriginSize(true)
		imgPhoto:setFile("")
		imgPhoto:setFile(path)
		GetElement(self.m_root,"conCover",WZUIContainer):setVisible(false)
		self.m_nDownLoading = false
	else
		WZLog("taskId:::::::::::::::::::::::::::::::",taskId)
	end
end


-------------------------------------私有方法模块End----------------------------------------
