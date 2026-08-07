--WndDownLoad.lua
--@brief	WndDownLoad的UI模块
--@date		2015-8-17
--@author	binshao
--@note		登陆加载


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDownLoad:onEnter(element)
    CCLuaLog("WndDownLoad:onEnter")
    self.m_root = element
    if WZDeviceHelper:sharedDeviceHelper().stopDeviceMotionUpdate then
        WZDeviceHelper:sharedDeviceHelper():stopDeviceMotionUpdate()
    end
     CCLuaLog("WndDownLoad:onEnter222")
    SceneLoginMgr.m_bIsCloseGravity = true
    g_isconnect = false
    self:_registerLogout() -- SDK处理
     CCLuaLog("WndDownLoad:onEnter333")
    self.m_root:enableSchedule("ScheduleTime",0)
    self:initUI()
    self:getIsOpenSound() --渠道方要求对声音的控制
    PostPlayerEvent:postEvent(PostPlayerEvent.event_enterDownUI)
     CCLuaLog("WndDownLoad:onEnter444")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDownLoad:onExit(element)
	self:_unInit()
    --CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
    CCArmatureDataManager:sharedArmatureDataManager():removeAll()
    WZUpdateManager:getInstance():checkAndGenFileList()
end

-- 初始化UI显示
function WndDownLoad:initUI()
    local proTips = GetElement(self.m_root, "progDesTTF_WndDownLoad", WZUILabelTTF)
    proTips:setText(LocalStrings.CHECK_VESION)
    proTips:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
    proTips:setColor(GlobalMethod:ccc3(255,255,255))
    proTips:setStrokeColor(GlobalMethod:ccc3(79,60,48))
end

function WndDownLoad:ScheduleTime(element,dt)
     WZLog("WndDownLoad:ScheduleTime:",ProjConfig.USE_DOWNLOAD)
    if not self.scheduleTime then self.scheduleTime = 0 end
    self.scheduleTime = self.scheduleTime  + dt
    -- 如果检查不需要更新，那么等待2秒
    if ProjConfig.USE_DOWNLOAD == 0 and self.scheduleTime >= 1 then
        WZLog("----------------------not need download----------------")
        self:_updateSuccess()
    elseif ProjConfig.USE_DOWNLOAD == 1 and self.checkUpdate == false then
        self.checkUpdate = true
        self:_checkUpdate()
    end
end

-------------------------------------公有方法模块End----------------------------------------

-- 检查更新
function WndDownLoad:checkIsNeedUpdate()
	WZLog("WndDownLoad:checkIsNeedUpdate()")

    local updateUrl0 = ProjConfig.UPDATE_URL
    local updateUrl1 = ProjConfig.UPDATE_URL1
    local updateUrl
    local upUrl = {updateUrl0,updateUrl1}
    if updateUrl0 and updateUrl1 then
        local upUrlLen0 = string.len(updateUrl0)
        local upUrlLen1 = string.len(updateUrl1)
        if upUrlLen0 > 0 and upUrlLen1 > 0 then
            local rand = math.random(1,2)
            updateUrl =  upUrl[rand]
        elseif upUrlLen0 > 0 then
            updateUrl = updateUrl0
        elseif upUrlLen01 > 0 then
            updateUrl = updateUrl1
        end
    else
        if updateUrl0 then
            local upUrlLen0 = string.len(updateUrl0)
            if upUrlLen0 > 0 then updateUrl = updateUrl0 end
        end
        if updateUrl1 then
            local upUrlLen1 = string.len(updateUrl1)
            if upUrlLen1 > 0 then updateUrl = updateUrl1 end
        end
    end

    if not updateUrl then  return end
    self.m_bIsHaveNormalUpdate = true
	WZUpdateManager:getInstance():update(updateUrl,self)
end

-- 检查拓展包更新
function WndDownLoad:checkIsNeedExtendUpdate(curLevel)
    self.downloadFlag = self.DownloadFlag["DOWNLOADFLAG_EXTENDUPDATE"]
	local updateExtendUrl = self:getExtendUpdateUrl(curLevel) --配置文件下载地址
	WZLog("checkIsNeedExtendUpdategyq=",ProjConfig.ISOPEN_EXTEND,updateExtendUrl)
	if not updateExtendUrl or ProjConfig.ISOPEN_EXTEND == 0  then
        WZLog("checkIsNeedExtendUpdategyq",LoadPlayerLevel())
        self.downloadFlag = self.DownloadFlag["DOWNLOADFLAG_NORUPDATE"]
        self:checkIsNeedUpdate()
    else
    	WZLog("WndDownLoad:checkIsNeedExtendUpdate self ", self,updateExtendUrl)
        self.m_bIsHaveExtendUpdate = true
	    WZUpdateManager:getInstance():extend(updateExtendUrl,self)
	end
end

-- 根据玩家等级，获取更新拓展包地址
function WndDownLoad:getExtendUpdateUrl(curLevel)
	local updateExtendUrl
    local extendLastestVer = WZUpdateManager:getInstance():getExtendUpdateVersion()  --当前更新到的增量包版本
	if curLevel >= tonumber(ProjConfig.EXTEND_LEVEL) and extendLastestVer < "1.0.1" then
	      updateExtendUrl = ProjConfig.EXTEND_URL
	end
	WZLog("extend download","need level",curLevel,"curVer",extendLastestVer,"updateUrl",updateExtendUrl)
	return updateExtendUrl
end

--@brief	更新检查后的回调
--@param1	isNeedUpdate 底层判断是否需要更新 true 需要更新，false 不需要更新
--@parma2	url 配置文件里面配置好的更新地址 url == nil 不需要更新应用 url ~= nil 需要进行应用更新
--@parma3	count 更新包的数量
--@parma4   totalSize(MB) 更新包总大小
function WndDownLoad:checkUpdateCallback(isNeedUpdate,url,count,totalSize)
	WZLog("checkIsNeedUpdateCallback value",isNeedUpdate,url,count,totalSize)
	self.sumSize = totalSize * 1024 * 1024  ---MB-->Byte
	if isNeedUpdate then
        self.curDownCnt = 0
        self.maxDownCnt = count
        WZLog("-------------max cnt---------------",self.maxDownCnt)
        local progBar = GetElement(self.m_root,"progBar_WndDownLoad",WZUIProgress)
        progBar:setPercentage(0)
        WZLog("-----------------1-------------------------",progBar:getPercentage())
        local conDutiao = GetElement(self.m_root, "conDutiao_WndDownLoad")
        conDutiao:setRelativePosition(GlobalMethod:ccp(0/100, 0.57))
        local conScissor = GetElement(self.m_root, "conScissor_WndDownLoad", WZUIScissorContainer)
        conScissor:setRelativeSize(GlobalMethod:CCSize(0, 1))
        if self.downloadFlag == self.DownloadFlag.DOWNLOADFLAG_EXTENDUPDATE then
            self:_downloadWarningTips(totalSize)            --弹出是否进行更新面板
            self.isEverShowTipDialog  = true    --已经弹出过下载提示框，当检测到有更新资源下载时不再进行提示
        elseif self.downloadFlag == self.DownloadFlag.DOWNLOADFLAG_NORUPDATE then
            if self.isEverShowTipDialog then
                WZUpdateManager:getInstance():doUpdateDownload(true)  --第二次检测到有资源下载不弹出确认面板直接开始下载
            else
                self:_downloadWarningTips(totalSize) 	--弹出是否进行更新面板
            end
        end
	else
		if url and url ~= "" then
			self:_updateApp() 		--需要更新应用
		else
            if self.downloadFlag == self.DownloadFlag.DOWNLOADFLAG_EXTENDUPDATE then
                self.downloadFlag = self.DownloadFlag.DOWNLOADFLAG_NORUPDATE
                self:checkIsNeedUpdate()   --增量包下载完成之后检查是否有更新包需要下载
            elseif self.downloadFlag == self.DownloadFlag.DOWNLOADFLAG_NORUPDATE then
                if self.isEverDownloadFile then
					WZUpdateManager:getInstance():setUserData(1)
                    KEngineReloadAll() 				--所有资源下载完毕重新加载游戏
				else
					self:_updateSuccess() 	 --不需要进行正常更新
				end
            end
		end
	end 
end

--@brief	下载过程中的回调
--@param1	resVersion 当前更新到的资源版本
--@parma2	totalSize 更新包总大小 
--@parma3	nowSize  当前已下载大小
function WndDownLoad:updateVersionCallback(resVersion, totalSize, nowSize)
	WZLog("WndDownLoad:updateVersionCallback",resVersion, totalSize, nowSize)
    GetElement(self.m_root, "conForBG_WndDownLoad", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "conProgress_WndDownLoad", WZUIContainer):setVisible(true)
    if resVersion ~= self.lastestVersion then
        self.lastestVersion = resVersion
        self.m_nDownLoadSize = totalSize
        self.finishDownloadSize = 0
        self.lastPackageSize = totalSize
        self.curDownCnt = self.curDownCnt + 1
        WZLog("-------------cur cnt---------------",self.curDownCnt)

        local progBar = GetElement(self.m_root,"progBar_WndDownLoad",WZUIProgress)
        WZLog("-----------------2-------------------------",progBar:getPercentage())
        progBar:setPercentage(0)
        local conDutiao = GetElement(self.m_root, "conDutiao_WndDownLoad")
        conDutiao:setRelativePosition(GlobalMethod:ccp(0/100, 0.57))
        local conScissor = GetElement(self.m_root, "conScissor_WndDownLoad", WZUIScissorContainer)
        conScissor:setRelativeSize(GlobalMethod:CCSize(0, 1))
        local conDown = GetElement(self.m_root,"conDownTips_WndDownLoad",WZUIContainer)
        conDown:setVisible(true)
    end

	local currentDownloadSize = self.finishDownloadSize + nowSize
	if totalSize ~= 0 then
        local per = nowSize/totalSize * 100
        self.progBar_percentage = per
        self:_updateProgressBar()
        --local currentnPerString = string.format("%s%s(%d%s%d)",LocalStrings.DOWNLOAD_RESOURCE,"   ",self.curDownCnt,"/",self.maxDownCnt)
        local currentnPerString = LocalStrings.DOWNLOAD_RESOURCE.."   "..self.curDownCnt.."/"..self.maxDownCnt
        local progDesTTF = GetElement(self.m_root, "progDesTTF_WndDownLoad", WZUILabelTTF)
        progDesTTF:setText(currentnPerString)
        progDesTTF:setRelativePosition(GlobalMethod:ccp(0.915,0.5))
        progDesTTF:setColor(GlobalMethod:ccc3(99,255,95))
        progDesTTF:setStrokeColor(GlobalMethod:ccc3(79,60,48))
        local txtDown = GetElement(self.m_root,"txtDownTips_WndDownLoad",WZUILabelTTF)
        if nowSize == totalSize then
            local txtDecompression = LocalStrings.DECOMPRESSION
            txtDown:setText(txtDecompression)
        else
            local perDesc = string.format("%0.2f%s",per,"%")
            txtDown:setText(string.format(LocalStrings.DOWN_LOADING_PRO,nowSize/1024,totalSize/1024,perDesc))
        end
	end
end

--@brief	下载开始后的回调
--@param1	hasError 
--@parma2	errorCode 错误代码 1、2、
function WndDownLoad:updateFinishCallback(hasError,errorCode)
	WZLog("WndDownLoad:updateFinishCallback",hasError,errorCode)
	if hasError then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_updateFail,errorCode)
		self:_updateFailed(errorCode)
	else
        if self.downloadFlag == self.DownloadFlag.DOWNLOADFLAG_NORUPDATE then
            PostPlayerEvent:postEvent(PostPlayerEvent.event_updateSuccess)
            WZUpdateManager:getInstance():setUserData(1)
            KEngineReloadAll()--所有资源下载完毕重新加载游戏
        elseif self.downloadFlag == self.DownloadFlag.DOWNLOADFLAG_EXTENDUPDATE then
            self.finishDownloadSize = 0
            self.downloadFlag = self.DownloadFlag.DOWNLOADFLAG_NORUPDATE
            self.m_bIsHaveExtendUpdate = false --增量包下载完
			self.isEverDownloadFile = true --是否曾经下载过资源
            self:checkIsNeedUpdate()   --增量包下载完成之后检查是否有更新包需要下载
		end
	end
end

-- 声音控制
function WndDownLoad:getIsOpenSound()
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
        local config = curSdkObj.m_tConfig
        if config.SDKOtherConfig.isNeedVoiceControl == "true" then
            local tOthersParams = {}
            tOthersParams.othersType = "VoiceControl"
            local curSdkObj = PassportSdkManager:getCurSdkObj()
            local sJsonArg = json.encode(tOthersParams)
            WZLog("WndDownLoad:getIsOpenSound() sJsonArg", sJsonArg)
            curSdkObj:setCallbackByName("login",WndDownLoad.VoiceControlCallback,WndDownLoad)
            curSdkObj:accountOthers(sJsonArg, nil,nil )
        end
    end
 end 

 --声音控制返回
 function WndDownLoad:VoiceControlCallback(sIsOpen)
     if sIsOpen == "false" then
         --设置背景静音状态
        SoundManager:setBgMusicMute(0,true)
         --设置按钮静音状态
        SoundManager:setEffectSoundMute(0,true)
     else
        --设置背景静音状态
        SoundManager:setBgMusicMute(1,true)
         --设置按钮静音状态
        SoundManager:setEffectSoundMute(1,true)
     end
 end
-------------------------------------私有方法模块Begin--------------------------------------

--@brief	处理进度条状态的更新
--@param1	currentDownloadSize 当前下载好的文件大小
function WndDownLoad:_processProgressBarUpdate(currentDownloadSize)
	local per = currentDownloadSize/self.sumSize * 100
	if per - self.progBar_percentage > 0.01 then  		--差值大于某个值（如0.01）才更新进度条,百分比
		self.progBar_percentage = per
		self:_updateProgressBar()
	end
end


-- 下载资源提示wifi
function WndDownLoad:_downloadWarningTips(totalSize)
    WZLog("WndDownLoad:_downloadWarningTips")
    self.m_root:disableSchedule()
    PostPlayerEvent:postEvent(PostPlayerEvent.event_showUpdateTips)
    if totalSize <= 0.01 then totalSize = 0.01 end
    self.downloadSize = totalSize
    self:_NeedUpdateResource()
end

-- 更新资源提示
function WndDownLoad:_NeedUpdateResource( )
    local progBar = GetElement(self.m_root,"progBar_WndDownLoad",WZUIProgress)
    WZLog("-----------------6-------------------------",progBar:getPercentage())
    progBar:setPercentage(0)
    local conDutiao = GetElement(self.m_root, "conDutiao_WndDownLoad")
    conDutiao:setRelativePosition(GlobalMethod:ccp(0/100, 0.57))
    local conScissor = GetElement(self.m_root, "conScissor_WndDownLoad", WZUIScissorContainer)
    conScissor:setRelativeSize(GlobalMethod:CCSize(0,1))
    if not self.isShowDownloadTips then
        local txtTips = string.format(LocalStrings.NEED_DOWNLOAD_TIPS,self.downloadSize)
        MsgBoxManager:showConfirmBox(txtTips, self, self._startDownloadCallback, MSGBOXLEVEL_NORMAL, nil,true)
    else
        WZUpdateManager:getInstance():doUpdateDownload(true)
    end
end

-- 弹框提示的操作回调
function WndDownLoad:_startDownloadCallback(nId,nType)
    WZLog("WndDownLoad:_startDownloadCallback")
	if nType == MSGBOXRESTYPE_CONFIRM then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_clickStartUpdate)
		WZUpdateManager:getInstance():doUpdateDownload(true)
    else
        PostPlayerEvent:postEvent(PostPlayerEvent.event_clickCancelUpdate)
        local txtTips = string.format(LocalStrings.NEED_DOWNLOAD_TIPS,self.downloadSize)
		MsgBoxManager:showConfirmBox(txtTips, self, self._startDownloadCallback, MSGBOXLEVEL_NORMAL, nil,true)
	end
end


-- 弹出需要更新的对话框按钮回调
function WndDownLoad:_onSureUpdate()
	--调用doUpdateDownload函数下载更新
	WZUpdateManager:getInstance():doUpdateDownload(true)
end



-- 下载成功回调，进入登陆账号界面
function WndDownLoad:_updateSuccess()
    self.m_bIsHaveExtendUpdate = false   --是否有增量资源要更新
    self.m_bIsHaveNormalUpdate = false   --是否有动态更新的资源
    self.m_root:disableSchedule()
    self:playLogo()
    -- WindowManager:removeWindow(self.m_root, self, true)
    -- SceneLoginMgr:showScene(2)
end

function WndDownLoad:playLogo()
     local platForm =  WZUISystem:getInstance():getPlatformInfo()
     if platForm == 2 then --android
            --SceneLoginMgr:showScene(1)
        self.t_utilsAdapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("org/cocos2dx/hellolua/DandandaoUtils")
     elseif platForm == 1 then -- ios
        self.t_utilsAdapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("DandandaoUtils")
     end
     if self.t_utilsAdapter then
        if ProjConfig.DEBUG == 1 then   --开启debug，设置debug状态
              self.t_utilsAdapter:callMethodByName("setDebugState",nil,"")
        end
        if platForm == 2 and WZDeviceInfo:getTotalMemory()/(1024*1024) <= 1024 then
            self:changScene()
            return
        end
        if not g_playLogo and ProjConfig.PLAY_LOGO == 1 then
            g_playLogo = true
            SoundManager:pauseBackgroundMusic()
            PostPlayerEvent:postEvent(PostPlayerEvent.event_playCG)
            self.m_cgStartTime = os.time()
            local filePath = "vedio/wydLogo.mp4"
            filePath = CCFileUtils:sharedFileUtils():fullPathForFilename(filePath)
            local bExist = WZFileUtil:isFileExist(filePath)
            if bExist then
                local callback = WZAdapterCallback:create(WndDownLoad.logoOver, WndDownLoad)
                self.t_utilsAdapter:callMethodByName("playLogo",callback,filePath)
            else
                self:logoOver()
            end
        else
            self:changScene()
            -- WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(self.t_utilsAdapter:getId())
            -- self.t_utilsAdapter = nil
        end
    else --没什么是做，就去登入界面
        self:changScene()
     end
end

function WndDownLoad:logoOver()
    print("this logo over")
    SoundManager:resumeBackgroundMusic()
    local useTime = os.time() - self.m_cgStartTime
    WZLog("WndDownLoad:logoOver:",useTime)
    if tonumber(useTime) < 24 then
          WZLog("WndDownLoad:logoOver222:",useTime)
        PostPlayerEvent:postEvent(PostPlayerEvent.event_playCGStop)
    else
          WZLog("WndDownLoad:logoOver333:",useTime)
        PostPlayerEvent:postEvent(PostPlayerEvent.event_playCGEnd)
    end
    
    --SceneLoginMgr:showScene(1)
    WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(self.t_utilsAdapter:getId())
    self.t_utilsAdapter = nil
    self:changScene()
   
end

function WndDownLoad:changScene()
    WindowManager:removeWindow(self.m_root, self, true)
    SceneLoginMgr:showScene(2)
end

--	下载失败
function WndDownLoad:_updateFailed(errorCode)
    self.m_root:disableSchedule()

    PostPlayerEvent:postEvent(PostPlayerEvent.event_checkUpdateFail, errorCode)
	if errorCode == "1" then
         WZLog("WndDownLoad:_updateFailedyyyyyy")    
        MsgBoxManager:showConfirmBox(LocalStrings.NO_SPACE_TO_DOWNLOAD_TIPS, self, self.downloadResFailCallback, MSGBOXLEVEL_NORMAL, nil,true)
	else 
        WndDownLoad.isShowDownloadTips = true
        WZLog("WndDownLoad:_updateFailedUUUUUU")
        MsgBoxManager:showConfirmBox(LocalStrings.DOWNLOAD_RES_FAIL_TIPS, self, self.downloadResFailCallback, MSGBOXLEVEL_NORMAL, nil,true)
	end
end

-- 资源更新失败回调
function WndDownLoad:downloadResFailCallback()
    WZLog("WndDownLoad:downloadResFailCallback")
    WindowManager:removeWindow(self.m_root, self, true)
    SceneLoginMgr:showScene(1)
end

--@brief	应用版本与配置文件版本不一致需要进行应用版本升级
function WndDownLoad:_updateApp()
	
end

--@brief	更新进度条
function WndDownLoad:_updateProgressBar()
	WZLog("WndDownLoad:updateProgressBar-----------------------88",self.progBar_percentage)
    if self.m_root == nil then return end
    local progBar = GetElement(self.m_root,"progBar_WndDownLoad",WZUIProgress)
    progBar:setPercentage(self.progBar_percentage)

    local conDutiao = GetElement(self.m_root, "conDutiao_WndDownLoad")
    conDutiao:setRelativePosition(GlobalMethod:ccp(self.progBar_percentage/100, 0.57))

    local conScissor = GetElement(self.m_root, "conScissor_WndDownLoad", WZUIScissorContainer)
    conScissor:setRelativeSize(GlobalMethod:CCSize(self.progBar_percentage/100,1))
end

------------------------------------------------------obb start-------------------------------------------------------
--  检车是否有资源更新
function WndDownLoad:_checkUpdate()
    if ProjConfig.USE_DOWNLOAD == 1 then
        WZLog("IsCanDownload","true")
        if ProjConfig.USE_DOWNLOAD_OBB  and ProjConfig.USE_DOWNLOAD_OBB > 0 and ProjConfig.OBB_URL and ProjConfig.OBB_URL ~= "" and  not self.m_bIsDownloadObbOk then
            WZLog("checkIsNeedDownloadObb")
            self:_checkIsNeedDownloadObb()
        elseif  LoadPlayerLevel() and ProjConfig.EXTEND_LEVEL and tonumber(LoadPlayerLevel()) >= tonumber(ProjConfig.EXTEND_LEVEL) and tonumber(ProjConfig.ISOPEN_EXTEND) == 1 then
            WZLog("checkIsNeedExtendUpdate",LoadPlayerLevel())
			self:checkIsNeedExtendUpdate(ProjConfig.EXTEND_LEVEL)
        else
            self.downloadFlag = self.DownloadFlag["DOWNLOADFLAG_NORUPDATE"]
            self:checkIsNeedUpdate()
		end
        --self:loadPreFiles()
	end
end

--@brief	检查是否需要进行下载obb
function WndDownLoad:_checkIsNeedDownloadObb()
    local isObbExist = WZFileUtil:isFileExist(WZDeviceInfo:getExpansionFileName())
    WZLog("WndDownLoad:_checkIsNeedDownloadObb 1", tostring(isObbExist), WZDeviceInfo:getExpansionFileName())

    local downSize = math.floor(ProjConfig.USE_DOWNLOAD_OBB*100/1024/1024)/100
    if isObbExist == false then
        --self:_downLoadObb()
        local txtTips = string.format(LocalStrings.NEED_DOWNLOAD_TIPS,downSize)
        MsgBoxManager:showConfirmBox(txtTips, self, self._downLoadObb, MSGBOXLEVEL_NORMAL, nil,true)
    else
        local fileSize = WZFileUtil:getFileSize(WZDeviceInfo:getExpansionFileName())
        WZLog("WndDownLoad:_checkIsNeedDownloadObb 2", tostring(fileSize), downSize)

        if fileSize < ProjConfig.USE_DOWNLOAD_OBB then
            --self:_downLoadObb()
            local txtTips = string.format(LocalStrings.NEED_DOWNLOAD_TIPS,downSize)
            MsgBoxManager:showConfirmBox(txtTips, self, self._downLoadObb, MSGBOXLEVEL_NORMAL, nil,true)
        else
            WZLog("WndDownLoad:_checkIsNeedDownloadObb 3", tostring(fileSize))
            self.m_bIsDownloadObbOk = true
            CCFileUtils:sharedFileUtils():setObbResourcePath(WZDeviceInfo:getExpansionFileName())
            self:_checkUpdate()
        end
    end
end

--@brief	下载obb
function WndDownLoad:_downLoadObb()
    local makeDownloadPath = self:_makeDirectory(WZDeviceInfo:getExpansionFileName())
	if makeDownloadPath == false then
		return false
	end
    WZLog("WndDownLoad:_downLoadObb one:",ProjConfig.OBB_URL,tostring(WZDeviceInfo:getExpansionFileName()), tostring(self))
    
	GetElement(self.m_root, "conForBG_WndDownLoad", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "conProgress_WndDownLoad", WZUIContainer):setVisible(true)

    local tag = self.m_root:getTag()
    local fileName = WZDeviceInfo:getExpansionFileName()
    local downURL = ProjConfig.OBB_URL
    downURL = downURL:gsub("\n","")
    downURL = downURL:gsub("\r","")
    local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
    local downloadTask = WZHTTPFileLuaTask:createResumeDownload(tag, downURL, fileName, self.downLoadObbBackFun, self)
    multiThread:addDownloadTaskInFront(downloadTask)
end

--@brief 	下载obb回调函数
function WndDownLoad:downLoadObbBackFun(taskId, path, totalSize, nowSize, finish, failed)
    if self.m_root == nil then
        return
    end

    WZLog("WndDownLoad:downLoadObbBackFun one",taskId, finish, self.finishDownloadSize, self.lastPackageSize, nowSize, totalSize, tostring(failed))

    if failed == true then
        local freeSpace = WZFileUtil:getFreeSpace(WZDeviceInfo:getExpansionFileName())
        -- local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("org/cocos2dx/hellolua/DandandaoUtils")
        -- if adapter == nil then
            -- return
        -- end
        -- freeSpace = adapter:callMethodByNameReturn("getFreeSpase",WZDeviceInfo:getExpansionFileName())
        -- WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())
		WZLog("WndDownLoad:downLoadObbBackFun two",taskId, finish, self.finishDownloadSize, self.lastPackageSize, nowSize, totalSize, freeSpace,ProjConfig.USE_DOWNLOAD_OBB)

        if tonumber(freeSpace) <= ProjConfig.USE_DOWNLOAD_OBB then
        --if tonumber(freeSpace) <= totalSize then
            WndDownLoad.isShowDownloadTips = true
            MsgBoxManager:showConfirmBox(LocalStrings.NO_SPACE_TO_DOWNLOAD_TIPS, self, self.downloadResFailCallback, MSGBOXLEVEL_NORMAL, nil,true)
        else
            WndDownLoad.isShowDownloadTips = true
            MsgBoxManager:showConfirmBox(LocalStrings.DOWNLOAD_RES_FAIL_TIPS, self, self.downloadResFailCallback, MSGBOXLEVEL_NORMAL, nil,true)
        end
    end

    self.sumSize = totalSize
    self.finishDownloadSize = nowSize
    self.lastPackageSize = totalSize
    local currentDownloadSize = nowSize
    if totalSize ~= 0 then
        self:_processProgressBarUpdate(currentDownloadSize)
        if self.m_root  then
            local progDesTTF = GetElement(self.m_root, "progDesTTF_WndDownLoad", WZUILabelTTF)
            if progDesTTF then
                local totalStr = GetMemoryStringOfSize(totalSize)
                local nowStr = GetMemoryStringOfSize(nowSize)
                local str = tostring(nowStr).."/"..tostring(totalStr)
                progDesTTF:setText(str)
                progDesTTF:setRelativePosition(GlobalMethod:ccp(0.915,0.5))
                progDesTTF:setColor(GlobalMethod:ccc3(99,255,95))
                progDesTTF:setStrokeColor(GlobalMethod:ccc3(79,60,48))
            end
        end
    end

    if finish then
        WZLog("WndDownLoad:downLoadObbBackFun 2:",path)
        self.m_bIsDownloadObbOk = true
		CCFileUtils:sharedFileUtils():setObbResourcePath(WZDeviceInfo:getExpansionFileName())
        self:_checkUpdate()
    else
        --WZLog("WndDownLoad:downLoadObbBackFun 3",taskId)
    end
end

--@brief	创建目录
function WndDownLoad:_makeDirectory(fullPath)
    local nFindLastIndex = 2
    while true do
        nFindLastIndex  = string.find(fullPath, "/", nFindLastIndex + 1)

        if not nFindLastIndex then
            break
        end

        local path = string.sub(fullPath, 1, nFindLastIndex - 1)
        WZLog("WndDownLoad:_makeDirectory 1",tostring(nFindLastIndex), path)
        local isDirectoryExist =  WZFileUtil:isDirectoryExist(path)
        if isDirectoryExist == false then
            local makeDownloadPath = WZFileUtil:makeDirectory(path)
			if makeDownloadPath ~= true then
				WZLog("WndDownLoad:_makeDirectory 3", tostring(fullPath))
				MsgBoxManager:showConfirmBox(LocalStrings.DOWNROAD_REQUIRE_SD_CARD, self, self.downloadResFailCallback, MSGBOXLEVEL_NORMAL, nil,true)
				return false
			end
        end
    end

    WZLog("WndDownLoad:_makeDirectory 2", tostring(fullPath))
    return true
end

------------------------------------------------------obb end-------------------------------------------------------

-- 得到账号函数回调
function WndDownLoad:__getAccountInfo(acc,passwd)
    IPDConnector:connectIPDServer(acc,passwd)
end

--@brief 得到账号函数回调
function WndDownLoad:__getAccountInfoChangeAcount(acc,passwd)
    WZLog("WndDownLoad:__getAccountInfoChangeAcount")
    IPDConnector:connectIPDServer(acc,passwd,true)
end

---- 登陆成功
--function WndDownLoad:LoginSuccess( )
--    -- 进度条提示,检测版本
--    local progDesTTF = GetElement(self.m_root, "progDesTTF_WndDownLoad", WZUILabelTTF)
--    progDesTTF:setText(LocalStrings.CHECK_VESION)
--
--    local progBar = GetElement(self.m_root,"progBar_WndDownLoad",WZUIProgress)
--    WZLog("-----------------8-------------------------",progBar:getPercentage())
--    self:_checkUpdate()
--    if ProjConfig.USE_DOWNLOAD == 0 then
--        WZLog("--------------notDataNeedToDownLoad-----------------")
--        self:_updateSuccess()
--    end
--end

----@breif 获得游戏账号密码"
----@return 返回类型 1 从文件中读取账号密码 ，2 uID登陆
--function WndDownLoad:GetCountAndPassport(fCallback,fcalltable)
--    CCLuaLog("WndDownLoad:GetCountAndPassport one")
--    --等到账号密码类型 logintype == 1 从WZDataFile
--    --               logintype == 2 用UID登陆
--    local logintype, account, passport = "" ,"",""
--    self.m_callback  = fCallback
--    self.m_callbacktable = fcalltable
--    --如果有SDK WZDataFile 重新SET
--    --
--    local data = WZDataFile:getInstance():getUserData()
--    local tServerInfo = {}
--    tServerInfo.serverCode = data and data:getStringValue("IPDParam", "ServerId") or ""
--
--    local isNeedSDK = PassportSdkManager:getCurSdkObj()
--    local bIsChannelLogin,bIsFreeRegist = false,false
--    if isNeedSDK then
--        local config = isNeedSDK.m_tConfig
--        CCLuaLog(Serialize(config))
--
--        WZLog("WndDownLoad:GetCountAndPassport two", tostring(config.SDKOtherConfig.isFreeRegist), tostring(self:isRegistered()))
--        if config.SDKOtherConfig.isFreeRegist == "true" and  self:isRegistered() == false then  bIsFreeRegist = true  end
--        if config.SDKOtherConfig.checkUserData == "true" and params == nil
--            and config.SDKOtherConfig.hasAccountBtnParam then
--                local data = WZDataFile:getInstance():getUserData()
--                if data then
--                    local freeLogin = data:getStringValue("AccountData", "accountFreeLogin")
--                    if freeLogin == "false" then params = config.SDKOtherConfig.hasAccountBtnParam end
--                end
--        end
--        if config.SDKOtherConfig.isChannelLogin == "true" then  --渠道sdk包含登录模块
--            WZLog("WndDownLoad:GetCountAndPassport three", tostring(bIsFreeRegist), tostring(ProjConfig.IS_FREE_REGISTER))
--            local accountInfo = ""
--            accountInfo = CCUserDefault:sharedUserDefault():getStringForKey("AccountInfo_Vn")
--            if config.SDKOtherConfig.isNeedFastLogin == "true" and accountInfo~=nil and accountInfo~="" then
--                account,passport = self:_getLoginAccountData(3)
--                WZLog("WndDownLoad:GetCountAndPassport nine",account,passport)
--                tServerInfo.isHasAccount = "YES"
--                tServerInfo.accountInfo = accountInfo
--                local sJsonArg = json.encode(tServerInfo)
--                isNeedSDK:login( sJsonArg,WndDownLoad.LoginCallBackForAccount, self)
--                --self.m_callback(self.m_callbacktable,account,passport)
--                return
--            end
--              if bIsFreeRegist  then
--                if ProjConfig.IS_FREE_REGISTER ~= nil and ProjConfig.IS_FREE_REGISTER == 2 then
--                      WZLog("WndDownLoad:GetCountAndPassport four")
--                      isNeedSDK:login(params or "",WndDownLoad.LoginCallBackForAccount, self)
--                else
--                    ---[[
--                    WndDownLoad.m_nInfoTask = 10001
--                    WndDownLoad.m_nInfoTaskForId = 11001
--                    WndDownLoad.m_nInfoChangeTask = 12001
--                    WZLog("WndDownLoad:GetCountAndPassport five-1", WndDownLoad.m_nInfoTask, WndDownLoad.m_nInfoTaskForId, WndDownLoad.m_nInfoChangeTask)
--                    local udid = WGameCmUtil:GetUDID()
--                    local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
--                    local playerInfoTask = WZHTTPInfoLuaTask:create(WndDownLoad.m_nInfoTask, "http://bm1.vsplay.com:80/Account/Get?udid="..udid, self.playerInfoCallback, self)
--                    mulThreadSystem:addDownloadTask(playerInfoTask)
--                    WZLog("WndDownLoad:GetCountAndPassport five-2")
--                    do return end
--                    --]]
--                    --self.m_loginType = 0
--                    account,passport = self:_getLoginAccountData(2)
--                    -- read acc passwd
--                    WZLog("WndDownLoad:GetCountAndPassport six",account,passport)
--                    self.m_callback(self.m_callbacktable,account,passport)
--                end
--              else
--                WZLog("WndDownLoad:GetCountAndPassport seven")
--                tServerInfo.isHasAccount = "NO"
--                local sJsonArg = json.encode(tServerInfo)
--                isNeedSDK:login( params or sJsonArg,WndDownLoad.LoginCallBackForAccount, self)
--              end
--            bIsChannelLogin = true
--        end
--    end
--
--    --如果不走SDK    判断类型
--    if bIsChannelLogin == false then----渠道sdk不包含登录模块，使用游戏自有的账号系统
--        if self:isRegistered() then
--           -- self:loginByAccount()
--            account,passport = self:_getLoginAccountData(1)
--            WZLog("WndDownLoad:GetCountAndPassport eight",account,passport)
--            self.m_callback(self.m_callbacktable,account,passport)
--            self:LoginSuccess()
--        else
--            logintype = 2
--            account,passport = self:_getLoginAccountData(2)
--            WZLog("WndDownLoad:GetCountAndPassport nine",account,passport)
--            self.m_callback(self.m_callbacktable,account,passport)
--        end
--    end
--
--    return logintype
--end

--@brief	回调函数
--@param	nTaskID:任务ID，为固定值：IPDConnector.IPD_TASK
--@param	sData:IPD服务器返回的数据
--@param	bFinish:数据获取是否完成，true：IPD服务器访问完成
--@param	bFailed:数据获取是否失败，false：获取IPD数据成功
--@note		在这里判断IPD链接结果并做相应的操作
function WndDownLoad:playerInfoCallback(nTaskID, sData, bFinish, bFailed)
    WZLog("WndDownLoad:playerInfoCallback one", nTaskID, bFinish, bFailed, sData,
        self.m_nAccountInfo, self.m_nUdidRole,self.m_nInfoTask,self.m_nInfoTaskForId,self.m_nInfoChangeTask)

    if bFinish == false or bFailed == true then
        WZLog("WndDownLoad:playerInfoCallback five")
        MsgBoxManager:showConfirmBox(LocalStrings.LOGIN_FAILD, nil, self.reLogin, MSGBOXLEVEL_HIGH, nil,true)
        return
    end

    local data
    if sData and sData ~= "" then
        data = json.decode(sData)
    end
    if type(data) == "number" then
        MsgBoxManager:showConfirmBox(LocalStrings.SERVER_MAINTAINING, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
        return
    end

    if nTaskID == WndDownLoad.m_nInfoTask and bFinish == true and bFailed == false and data ~= nil then
        WZLog("WndDownLoad:playerInfoCallback two", data.id)

        local curSdkObj = PassportSdkManager:getCurSdkObj()
        if curSdkObj then
            local config = curSdkObj.m_tConfig
        end

        if data.id == 0 then
            curSdkObj:login("",WndDownLoad.ActionCallBackForAccount, self)
        else
            WndDownLoad.m_nUdidRole = data.id
            curSdkObj:login("",WndDownLoad.ActionCallBackForAccount, self)
        end
    end

    if nTaskID == WndDownLoad.m_nInfoTaskForId and bFinish == true and bFailed == false and data ~= nil and WndDownLoad.m_nAccountInfo ~= nil then
        WZLog("WndDownLoad:playerInfoCallback three", data.id, WndDownLoad.m_nAccountInfo, tostring(WndDownLoad.m_nUdidRole))
        if data.id == 0 and WndDownLoad.m_nUdidRole ~= nil and WndDownLoad.m_nUdidRole ~= 0 then

            local role = WndDownLoad.m_nUdidRole
            local udid = WGameCmUtil:GetUDID()
            local account = WndDownLoad.m_nAccountInfo
            local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
            local playerInfoTask = WZHTTPInfoLuaTask:create(WndDownLoad.m_nInfoChangeTask, "http://bm1.vsplay.com:80/Account/Update?id="..role.."&username="..udid.."&password="..udid.."&username2="..account.."&password2="..account, self.playerInfoCallback, self)
            mulThreadSystem:addDownloadTask(playerInfoTask)
        else
            self.m_callback(self.m_callbacktable,WndDownLoad.m_nAccountInfo,WndDownLoad.m_nAccountInfo)
        end
    end

    if nTaskID == WndDownLoad.m_nInfoChangeTask and bFinish == true and bFailed == false then
        WZLog("WndDownLoad:playerInfoCallback four", WndDownLoad.m_nAccountInfo)
        self.m_callback(self.m_callbacktable,WndDownLoad.m_nAccountInfo,WndDownLoad.m_nAccountInfo)
    end
end

--@brief	网络连接断开提示对话框回调
--@param	nId:消息ID
--@param	nType:响应类型
--@note		网络连接断开提示对话框回调
function WndDownLoad:networkUnavailableTipCallback()
    WZLog("WndDownLoad:networkUnavailableTipCallback")

    WndDownLoad.m_nInfoTask = 10001
    WndDownLoad.m_nInfoTaskForId = 11001
    WndDownLoad.m_nInfoChangeTask = 12001
    WZLog("WndDownLoad:networkUnavailableTipCallback five-1", self.m_nInfoTask, self.m_nInfoTaskForId, self.m_nInfoChangeTask)
    local udid = WGameCmUtil:GetUDID()
    local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
    local playerInfoTask = WZHTTPInfoLuaTask:create(self.m_nInfoTask, "http://bm1.vsplay.com:80/Account/Get?udid="..udid, self.playerInfoCallback, self)
    mulThreadSystem:addDownloadTask(playerInfoTask)
    WZLog("WndDownLoad:networkUnavailableTipCallback five-2")
end

--@note SDK  在第一链接IPD前得到账号 密码
function WndDownLoad:ActionCallBackForAccount(jsonArg)
    WZLog("WndDownLoad:ActionCallBackForAccount one",jsonArg)
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    local config = nil
    
    local t_jsonArg = SDK_Util:decodeFromJson(jsonArg);
    CCLuaLog("WndDownLoad:ActionCallBackForAccount  ------")
    if t_jsonArg["return"] == "fail" then
        CCLuaLog("uid, token , nil ");

        if not (GlobalGame.g_nCurrentUIChannelId == Chat_Channel_Setting and ProjConfig.IS_FREE_REGISTER == 2) then
            MsgBoxManager:showConfirmBox(LocalStrings.LOGIN_FAILD, nil, self.reLogin, MSGBOXLEVEL_HIGH, nil,true)
        end

        return
    end
    CCLuaLog(t_jsonArg.uid);
    WZLog("账号前缀",t_jsonArg.prefix)
    if curSdkObj then
        config = curSdkObj.m_tConfig
         if config.SDKOtherConfig.isNeedFastLogin == "true" and tostring(t_jsonArg.prefix)=="vi_" then
            CCUserDefault:sharedUserDefault():setStringForKey("AccountInfo_Vn", jsonArg)
         end
     end

    local account = t_jsonArg.prefix .. t_jsonArg.uid

    CCLuaLog("account:" .. account);

    local data = WZDataFile:getInstance():getUserData()

    if data ~= nil then
        data:setStringValue("AccountData", "account", account)

        data:setStringValue("AccountData", "password", account)

        data:flush()
    end

    WZLog("WndDownLoad:ActionCallBackForAccount two",account)

    WndDownLoad.m_nAccountInfo = account
    local udid = account
    local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
    local playerInfoTask = WZHTTPInfoLuaTask:create(WndDownLoad.m_nInfoTaskForId, "http://bm1.vsplay.com:80/Account/Get?udid="..udid, self.playerInfoCallback, self)
    mulThreadSystem:addDownloadTask(playerInfoTask)

end

--@brief    是否已经注册过
--@note     判断用户是否已经注册过
function WndDownLoad:isRegistered()
    local data = WZDataFile:getInstance():getUserData()
    WZLog("WndDownLoad:isRegistered one", tostring(data))
    if not data then  return end
    local accountName = data:getStringValue("AccountData", "account")
    local passWord = data:getStringValue("AccountData", "password")
    WZLog("WndDownLoad:isRegistered two", tostring(accountName), tostring(passWord))
    if accountName ~= nil and accountName ~= "" and passWord ~= nil and passWord ~= "" then
        return true
    end
    return false
end


--@note SDK  在第一链接IPD前得到账号 密码
function WndDownLoad:LoginCallBackForAccount(jsonArg)
    WZLog("WndDownLoad:LoginCallBackForAccount one",jsonArg)
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    local config = nil
    
    local t_jsonArg = SDK_Util:decodeFromJson(jsonArg);
    CCLuaLog("WndDownLoad:loginCallBack  ------")
    if t_jsonArg["return"] == "fail" then
        CCLuaLog("uid, token , nil ");

        if not (GlobalGame.g_nCurrentUIChannelId == Chat_Channel_Setting and ProjConfig.IS_FREE_REGISTER == 2) then
            MsgBoxManager:showConfirmBox(LocalStrings.LOGIN_FAILD, nil, self.reLogin, MSGBOXLEVEL_HIGH, nil,true)
        end

        return
    end
    CCLuaLog(t_jsonArg.uid);
    WZLog("账号前缀",t_jsonArg.prefix)
    if curSdkObj then
        config = curSdkObj.m_tConfig
         if config.SDKOtherConfig.isNeedFastLogin == "true" and tostring(t_jsonArg.prefix)=="vi_" then
            CCUserDefault:sharedUserDefault():setStringForKey("AccountInfo_Vn", jsonArg)
         end
     end

    local account = t_jsonArg.prefix .. t_jsonArg.uid

    CCLuaLog("account:" .. account);

    local data = WZDataFile:getInstance():getUserData()

    if data ~= nil then
        if  t_jsonArg.FreeLogin then
            data:setStringValue("AccountData", "accountFreeLogin", t_jsonArg.FreeLogin)
        end
        data:setStringValue("AccountData", "account", account)

        data:setStringValue("AccountData", "password", account)

        data:flush()
    end
    WZLog("WndDownLoad:LoginCallBackForAccount two",account)
    self.m_callback(self.m_callbacktable,account,account)
end

function WndDownLoad:reLogin()
    local params = ""
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    local config = curSdkObj.m_tConfig
    if config.SDKOtherConfig.checkUserData == "true" and config.SDKOtherConfig.hasAccountBtnParam then 
        local data = WZDataFile:getInstance():getUserData() if nil ~= data then
            local freeLogin = data:getStringValue("AccountData", "accountFreeLogin")
            if freeLogin == "false" then
                params = config.SDKOtherConfig.hasAccountBtnParam
            else
                local data = WZDataFile:getInstance():getUserData()
                local tServerInfo = {}
                if nil == data then
                    tServerInfo.serverCode = ""
                else
                    tServerInfo.serverCode = data:getStringValue("IPDParam", "ServerId")
                    params = json.encode(tServerInfo)
                end
            end
        end
    end 
    curSdkObj:login(params ,WndDownLoad.LoginCallBackForAccount, WndDownLoad)
end

-- 获取账号和密码
-- 1 表示自己游戏的账号信息
-- 2 表示手机地址作为账号信息
-- 3 sdk登陆信息(越南语)
function  WndDownLoad:_getLoginAccountData(nType)
    local accountName,passWord = "",""
    if nType == 1 then
        local data = WZDataFile:getInstance():getUserData()
        if not data then return end
        accountName = data:getStringValue("AccountData", "account")
        passWord = data:getStringValue("AccountData", "password")
    elseif nType == 2 then
        accountName = WGameCmUtil:GetUDID()
        passWord = WGameCmUtil:GetUDID()
    elseif  nType == 3 then
        local  jsonArg = CCUserDefault:sharedUserDefault():getStringForKey("AccountInfo_Vn")
        local t_jsonArg = SDK_Util:decodeFromJson(jsonArg);
        accountName = t_jsonArg.prefix .. t_jsonArg.uid
        passWord = t_jsonArg.prefix .. t_jsonArg.uid
    end
    WZLog("WndDownLoad:_getLoginAccountData",nType,accountName,passWord)
    return accountName,passWord
end

function WndDownLoad:_registerLogout()
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
        local config = curSdkObj.m_tConfig
        curSdkObj:setCallbackByName("logout",PassportDefaultCallback.logoutCallback,PassportDefaultCallback)
    end
end

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------私有方法模块End----------------------------------------