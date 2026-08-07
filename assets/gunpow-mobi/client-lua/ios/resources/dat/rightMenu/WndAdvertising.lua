--WndAdvertising.lua
--@brief	WndAdvertising的UI模块
--@date		2016/09/12
--@author	zsq
--@note		登录广告


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAdvertising:onEnter(element)
	self.m_root = element
end

function WndAdvertising:onEnterTransitionDidFinish(element)
	self.m_root:setVisible(true)
	if CacheCenter:getGameParam().isAdvertising == "true" then
		GetElement(self.m_root,"setAd",WZUICheckBox):setVisible(true)
		GetElement(self.m_root,"txtAd",WZUILabelTTF):setVisible(true)
	else
		GetElement(self.m_root,"setAd",WZUICheckBox):setVisible(false)
		GetElement(self.m_root,"txtAd",WZUILabelTTF):setVisible(false)
	end
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndAdvertising:actionCallback(element, data)
	local adMessage = CacheCenter:getAdMessage()
	if adMessage ~= nil and #adMessage > 0 then
    	self:downLoadPhoto()
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAdvertising:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
--@param 	element:触发事件的控件引用
function WndAdvertising:onClose(element)
    WZLog("WndAdvertising:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:nextAd()
end

function WndAdvertising:nextAd()
	local adMessage = CacheCenter:getAdMessage()
	if adMessage ~= nil and #adMessage > 0 and adMessage[#adMessage].sort < ADINDEX then
    	self:downLoadPhoto()
	else
		WindowManager:removeWindow(self.m_root, self, true)
		if GlobalGame.g_checkLoginActivities == false then return end
		GlobalGame.g_checkLoginActivities = false
	    if CacheCenter.m_tWelfareItemRedDotList ~= nil and #CacheCenter.m_tWelfareItemRedDotList > 0 and CheckButtonShow(69) then
            if WndWelfare.m_root == nil then
                MsgBoxManager:showWelfare()
            end
        elseif GlobalGame.g_autoGameActivity then
            WZLog("***** 进主城，获取活动信息 *****")
            if CheckButtonShow(21) then
                if WndGameActivity.m_root == nil then
                    MsgBoxManager:showGameActivity()
                end
            else
                GlobalGame.g_autoGameActivity = false
            end
        elseif GlobalGame.g_autoNewActivity then
        	WZLog("--****showNewActivity****--")
        	if CheckButtonShow(122) then
            	if WndNewActivity.m_root == nil then
                	MsgBoxManager:showNewActivity()
            	end
            else
            	GlobalGame.g_autoNewActivity = false
        	end
    	end
	end
end

--@brief	跳转
function WndAdvertising:onJump()
	WZLog("跳转id",self.m_nJumpId)
	local adMessage = CacheCenter:getAdMessage()
	if adMessage ~= nil and #adMessage > 0 and adMessage[#adMessage].sort > ADINDEX then
		self:nextAd()
	end
	if adMessage ~= nil and #adMessage > 0 and adMessage[#adMessage].sort == ADINDEX then
		local jumpResult
		if self.ad_type == 1 then
			jumpResult = WndGameActivity:showInterface(tonumber(self.m_nJumpId))
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
		ADINDEX = ADINDEX - 1
		if jumpResult ~= true then
			self:nextAd()
		end
	end
	if adMessage ~= nil and #adMessage > 0 and adMessage[#adMessage].sort < ADINDEX then
		if self.ad_type == 1 then
			WndGameActivity:showInterface(tonumber(self.m_nJumpId))
		elseif self.ad_type == 2 then
			WZPush:openURL(self.m_nJumpId)
		else
			if tonumber(self.m_nJumpId) == 222 then
				if tostring(ProjConfig:getChannelId()) ~= "53" and tostring(ProjConfig:getChannelId()) ~= "75" and tostring(ProjConfig:getChannelId()) ~= "275" and tostring(ProjConfig:getChannelId()) ~= "68" then
					JumpByUIId(self.m_nJumpId)
				end
			else
				JumpByUIId(self.m_nJumpId)
			end
		end
    	self:downLoadPhoto()
	end
end

--@brief	设置今日不再提示
function WndAdvertising:setAd()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local checkBox = GetElement(self.m_root,"setAd",WZUICheckBox)
	local data = WZDataFile:getInstance():getUserData()
	local id = CacheCenter:getPlayerInfo().id

	if checkBox:getCheckIndex() == 1 then
    	if data ~= nil then
    	    data:setStringValue("AdData", "Display"..id, "1")
    	    data:flush()
    	end
	else
    	if data ~= nil then
    	    data:setStringValue("AdData", "Display"..id, os.date("%x", os.time()))
    	    data:flush()
    	end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	下载图片
function WndAdvertising:downLoadPhoto()
	local imgPhoto = GetElement(self.m_root,"img_WndAdvertising",WZUIImage)
	GetElement(self.m_root,"conCover",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conInfo",WZUIContainer):setVisible(false)
	imgPhoto:setVisible(false)

	local photoName = "imgAdvertising"
	local adMessage = CacheCenter:getAdMessage()
	WZLog("WndAdvertising:downLoadPhoto",ADINDEX,Serialize(adMessage))
	local downURL = ""
	for i=1,#adMessage do
		if adMessage[i].sort < ADINDEX then
			downURL = adMessage[i].imgUrl
			self.m_nJumpId = adMessage[i].params
			self.ad_type = adMessage[i].ad_type
			ADINDEX = adMessage[i].sort
			photoName = self:getFileName(downURL)
			break
		end
		if i == #adMessage and adMessage[i].sort == ADINDEX then
			downURL = adMessage[i].imgUrl
			self.m_nJumpId = adMessage[i].params
			self.ad_type = adMessage[i].ad_type
			ADINDEX = adMessage[i].sort
			photoName = self:getFileName(downURL)
		end
	end
	downURL = downURL:gsub("\n","")
	downURL = downURL:gsub("\r","")
	--如果文件存在，不下载，直接使用
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..photoName
	local bExist = WZFileUtil:isFileExist(path)
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	WZLog("判断文件是否存在",path,photoName)
	if bExist then
		imgPhoto:setVisible(true)
		imgPhoto:setUseOriginSize(true)
		imgPhoto:setFile("")
		imgPhoto:setFile(path)
		GetElement(self.m_root,"conCover",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conInfo",WZUIContainer):setVisible(true)
	elseif downURL ~= "" then
		if platForm == 3 then
			path = photoName
		end
		local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
		local downloadTask = WZHTTPFileLuaTask:create(CacheCenter:getPlayerInfo().id, downURL, path, self.downLoadPhotoBackFun, self)
		multiThread:addDownloadTaskInFront(downloadTask)
		self.m_root:enableSchedule("showBtn", 7)
	end
end

--@brief	下载广告太久就显示按钮
function WndAdvertising:showBtn()
	self.m_root:disableSchedule()
	GetElement(self.m_root,"conInfo",WZUIContainer):setVisible(true)
end

function WndAdvertising:getFileName(filename)
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
function WndAdvertising:downLoadPhotoBackFun(taskId, path, totalSize, nowSize, finish, failed)
	WZLog("WndAdvertising:downLoadPhotoBackFun",taskId,finish,path,failed)
	if taskId ~= CacheCenter:getPlayerInfo().id then
		return
	end
	if self.m_root == nil then
		return
	elseif finish then
		WZLog("pathxxxxxxxqWWWWWWWWWWWW:::",path)
		self.m_root:disableSchedule()
		local imgPhoto = GetElement(self.m_root,"img_WndAdvertising",WZUIImage)
		imgPhoto:setVisible(true)
		imgPhoto:setUseOriginSize(true)
		imgPhoto:setFile("")
		imgPhoto:setFile(path)
		--local size = imgPhoto:getContentSize()
		--local hh = 68
		--local x = hh/size.width 
		--local y = hh/size.height
		--imgPhoto:setScale(math.min(x,y))
		GetElement(self.m_root,"conCover",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conInfo",WZUIContainer):setVisible(true)
	else
		WZLog("taskId:::::::::::::::::::::::::::::::",taskId)
	end
end


-------------------------------------私有方法模块End----------------------------------------
