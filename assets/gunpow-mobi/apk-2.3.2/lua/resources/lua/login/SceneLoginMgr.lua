--SceneLoginMgr.lua
--@brief	SceneLoginMgr的UI模块
--@date		2016-5-20
--@author	binshao
--@note		登录模块


-------------------------------------公有方法模块Begin--------------------------------------

function SceneLoginMgr:onEnter(element)
	WZLog("SceneLoginMgr:onEnter")
	self.m_root = element
	KLuaMutiRegSocket:getInstance():closeSocket()
	NetManager:disableBreathNotifyDisconnect()
	AdaptLanguage(self)
	if AutoRunBattleConst.AUTO_RUN_BATTLE then
		NetManager:closeConnect()
    	AutoRunBattle:init()
	end
	local packageName = WGameCmUtil:GetBundleIdentifier()
	if packageName == "com.dino.bh" then
		local conLogo = WZUIContainer:luaTo(self.m_root:getChildElement("conLogo_SceneLoginMgr"))
		conLogo:setVisible(false)
	end

	local spineSplash = GetElement(self.m_root, "spineSplash_SceneLoginMgr", WZUISpine)
	WZLog("2222222222222", type(spineSplash))
	if spineSplash then
		WZLog("77777777777777777")
		local nOffsetY = SplashSpineOffset()
		spineSplash:setRelativePosition(GlobalMethod:ccp(0.48125,0.86 + nOffsetY))
	end
	--登录界面重力感应
    SceneLoginMgr:adaptSize()

    
	local packageName = WGameCmUtil:GetBundleIdentifier()
	--遮挡动画界面
	if packageName == "com.dzzs.wangquan"  then
		local conSplash = WZUIContainer:luaTo(self.m_root:getChildElement("conSplash_SceneLoginMgr"))
		if conSplash then 
			conSplash:setVisible(true)
		end
	end
	--屏蔽logo
	if packageName == "com.wyd.brgp.bombheroes" or packageName == "com.herogames.gplay.ddduc" 
		or packageName == "com.herogames.gplay.dddsx" or packageName == "com.herogame.gplay.dddsea" 
		or packageName == "com.herogame.bombleadsa" or packageName == "com.xmqqls.ddlm" or packageName == "com.mldmx.junyi" 
		or packageName == "com.herogame.bombleadsa" or packageName == "com.xmqqls.ddlm" 
		or packageName == "com.xxmxj1.junyi" or packageName == "com.ddlaj.ios" 
		or packageName == "com.sfrz.ddd" or packageName == "com.ddd.haiwai" or packageName == "com.overseas.dan" 
		or packageName == "com.bombmaster.mg" or packageName == "com.ios.jt.projectilefiring" 
		or packageName == "com.ios.jt.mysteriousland" or packageName == "com.ios.jt.galgun" then
		local conLogo = WZUIContainer:luaTo(self.m_root:getChildElement("conLogo_SceneLoginMgr"))
		conLogo:setVisible(false)
		print(" SceneLoginMgr:onEnter packageName:333",packageName)
	end

	-- LOGO
    local packageName = WGameCmUtil:GetBundleIdentifier()
    if packageName == "com.ios.jt.bombgala" then
    	local imgLogo = WZUIImage:luaTo(self.m_root:getChildElement("imgLogo_SceneLoginMgr"))
    	if imgLogo ~= nil then
        	imgLogo:setFile("ui/login/logo_icon_bombgala.png")
        end
    end

    --根据包名修改登录页背景
    --ios正版包
    -- if WZUISystem:getInstance():getPlatformInfo() == 1 and packageName == "com.wyd.dandandao.hero" then
    --     local conBGPicture = WZUIContainer:luaTo(self.m_root:getChildElement("conBGPicture_SceneLoginMgr"))
    -- 	if conBGPicture ~= nil then
    --     	conBGPicture:setVisible(true)
    --     end
    -- end 
    if packageName == "com.ddd.tjyw" or packageName == "com.dddlxj.ubw" then
    	local conBGPicture = WZUIContainer:luaTo(self.m_root:getChildElement("conBGPicture_SceneLoginMgr"))
    	if conBGPicture ~= nil then
        	conBGPicture:setVisible(true)
        end
    end
    if isChannelQQHall() then
    	WZResourceManager:getInstance():executeLuaFile("global/WQQGameHelper.lua")
		--先刷新一次，防止资源下载途中关闭客户端导致的WZFileList.xml未完全刷新
		WZUpdateManager:getInstance():forceGenUpdateDirFileList()
        WQQGameHelper:init()
    end
    if isChannelFlashHall() then
    	WZResourceManager:getInstance():executeLuaFile("global/WGameHelperFlash.lua")
		--先刷新一次，防止资源下载途中关闭客户端导致的WZFileList.xml未完全刷新
		WZUpdateManager:getInstance():forceGenUpdateDirFileList()
        WGameHelperFlash:init()
    end
    if isChannel360Hall() then
    	WZResourceManager:getInstance():executeLuaFile("global/WGameHelper360.lua")
		--先刷新一次，防止资源下载途中关闭客户端导致的WZFileList.xml未完全刷新
		WZUpdateManager:getInstance():forceGenUpdateDirFileList()
        WGameHelper360:init()
    end
    local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."DressAniDownloadConfig.xml"
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    WZLog("SceneLoginMgr:onEnter path", path)
    if platForm == 3 then
     path = "DressAniDownloadConfig.xml"
    end
    if isChannelPC() then
    	if ProjConfig.DressAniDownloadConfig_All and ProjConfig.DressAniDownloadConfig_All ~= "" and string.find(ProjConfig.DressAniDownloadConfig_All, "192.168") == nil then 
	     	local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
	     	local downloadTask = WZHTTPFileLuaTask:create(200, ProjConfig.DressAniDownloadConfig, path, self.downloadAniConfigCall, self)
	     	multiThread:addDownloadTaskInFront(downloadTask)
	        path = "DressAniDownloadConfig_All.xml"
	        downloadTask = WZHTTPFileLuaTask:create(201, ProjConfig.DressAniDownloadConfig_All, path, self.downloadAniConfigCall_All, self)
	        multiThread:addDownloadTaskInFront(downloadTask)
    	end
    else 
    	if platForm ~= 3 and ProjConfig.DressAniDownloadConfig_All and ProjConfig.DressAniDownloadConfig_All ~= "" and string.find(ProjConfig.DressAniDownloadConfig_All, "192.168") == nil then 
	    	path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."DressAniDownloadConfig_All.xml"   	
	     	local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
	        local downloadTask = WZHTTPFileLuaTask:create(201, ProjConfig.DressAniDownloadConfig_All, path, self.downloadAniConfigCall_All, self)
	        multiThread:addDownloadTaskInFront(downloadTask)
    	end
    end
    setAllNodeGrayRender(self.m_root)
end

function SceneLoginMgr:downloadAniConfigCall(taskId, path, totalSize, nowSize, finish, failed)
    WZLog("SceneLoginMgr:downloadAniConfigCall", taskId, path, totalSize, nowSize, finish, failed)
end

function SceneLoginMgr:downloadAniConfigCall_All(taskId, path, totalSize, nowSize, finish, failed)
    WZLog("SceneLoginMgr:downloadAniConfigCall_All", taskId, path, totalSize, nowSize, finish, failed)
    --检测资源下载
end

--根据渠道号获取闪屏图片文件名
function SceneLoginMgr:GetSplashImgName()
    local sChannelId = WZFileUtil:getNodeValueFromXml("ChannelId")
    CCLuaLog("SceneLoginMgr:GetSplashImgName ChannelId = "..sChannelId)
    print("SceneLoginMgr:GetSplashImgName ChannelId = "..sChannelId)
    local channelID = tonumber(sChannelId)
    local imgName = "ui/login/login_pic_bg1"
    if channelID ~= nil and channelId ~= "" then
        imgName = imgName .. "_" .. channelID
    end
    imgName = imgName .. ".png"
    CCLuaLog("splash:GetSplashImgName imgName = "..imgName)
    print("splash:GetSplashImgName imgName = "..imgName)
    return imgName
end

--根据渠道号获取logo图片文件名
function SceneLoginMgr:GetLogoImgName()
    local sChannelId = WZFileUtil:getNodeValueFromXml("ChannelId")
    CCLuaLog("SceneLoginMgr:GetLogoImgName ChannelId = "..sChannelId)
    local channelID = tonumber(sChannelId)
    local imgName = "ui/login/login_icon_logo"
    if channelID ~= nil and channelId ~= "" then
        imgName = imgName .. "_" .. channelID
    end
    imgName = imgName .. ".png"
    CCLuaLog("SceneLoginMgr:GetLogoImgName imgName = "..imgName)
    return imgName
end

function SceneLoginMgr:onExit(element)
	self:_unInit()
end

-- tag 对应不同的wnd
-- isChangeServer 是否需要切换服务器
-- isEnterSplash -- 是否需要进入闪屏
function SceneLoginMgr:showScene(tag,isChangeServer,isEnterSplash)
	WZLog("SceneLoginMgr:showScene----tag,specialHandle",tag,specialHandle)
	WZLog("SceneLoginMgr:showScene----self.m_root",self.m_root)
	if self.m_root == nil then
		WZLog("------------------sceneLoginMgr---------------SceneLogin")
		local sceneMgr = SceneLoginMgr:createElement()
		replaceScene(sceneMgr)
	else
		if isEnterSplash then
			-- 跳闪屏
			WZLog("SceneLoginMgr:showScene----enterSplash")
			local frame = WZUISystem:getInstance():createElement("splash")
			replaceScene(frame)
			return
		end
	end
	if not tag then tag = 1 end
	if tag == 1 then
		-- 检查更新wnd
		WZLog("------------------sceneLoginMgr---------------WndDown")
		if PassportSdkManager and PassportSdkManager.postGameInfoVn then
			PassportSdkManager:postGameInfoVn("game_startup","")--成功打开游戏
		end
		if WndDownLoad.m_root == nil then
			local WndDown = WndDownLoad:createElement()
			WindowManager:addWindow( WndDown , WndDownLoad)
		end
	elseif tag == 2 then
		-- 登录wnd
		WZLog("------------------sceneLoginMgr---------------WndLogin")
		if PassportSdkManager.postGameInfoBeiMei then
			PassportSdkManager:postGameInfoBeiMei("startLogin","success")
		end
		if WndLoginSelect.m_root == nil then
			WndLoginSelect:showWnd(isChangeServer)
			if SceneLoginMgr.m_bIsCloseGravity then
				SceneLoginMgr:adaptSize()
			end
		end
		GlobalGame:getGameEventDispathcer():Dispatch("Enter_Login_Scene")
	elseif tag == 3 then
		-- 加载资源wnd
		WZLog("------------------sceneLoginMgr---------------WndLoad")
		if WndLoadLuaResources.m_root == nil then
			--根据包名判断，更改加载页背景
			local packageName = WGameCmUtil:GetBundleIdentifier()
		    if packageName == "com.ddd.tjyw" or packageName == "com.dddlxj.ubw" then
		    	local imgBGPicture = WZUIImage:luaTo(self.m_root:getChildElement("imgBGPicture_SceneLoginMgr"))
		    	local isExist = WZFileUtil:isFileExist("ui/login/login_pic_bg1_loading.png")
		    	if imgBGPicture ~= nil and isExist then
					WZLog("------------------sceneLoginMgr---------------change loading BGImage")
		        	imgBGPicture:setFile("ui/login/login_pic_bg1_loading.png")
		    	end
		    end
			local WndLoad = WndLoadLuaResources:createElement()
			WindowManager:addWindow( WndLoad , WndLoadLuaResources)
		end
	end
	setAllNodeGrayRender(self.m_root)
end

--@brief 设置屏幕的大小
function SceneLoginMgr:adaptSize(element)
	if true then
		return
	end
	self.m_bIsCloseGravity = false
	local imgTree = GetElement(self.m_root, "imgTree_SceneLoginMgr", WZUIImage)
	local spineBG = GetElement(self.m_root, "imgBG_SceneLoginMgr", WZUIImage)
	local spineRMountain = GetElement(self.m_root, "imgRightMountain_SceneLoginMgr", WZUIImage)
	local spineBMountain = GetElement(self.m_root, "imgBottomMountain_SceneLoginMgr", WZUIImage)

	self.t_position.x8,self.t_position.y8  = spineRMountain:getPosition()
	self.t_position.x7,self.t_position.y7  = spineBMountain:getPosition()
	self.t_position.x6,self.t_position.y6  = spineBG:getPosition()
	self.t_position.x5,self.t_position.y5  = imgTree:getPosition()
	self.t_position.x4,self.t_position.y4  =  GetElement(self.m_root, "conForSpine4_SceneLoginMgr", WZUIContainer):getPosition()
	self.t_position.x3,self.t_position.y3  =  GetElement(self.m_root, "conForSpine3_SceneLoginMgr", WZUIContainer):getPosition()
	self.t_position.x2,self.t_position.y2  =  GetElement(self.m_root, "conForSpine2_SceneLoginMgr", WZUIContainer):getPosition()
	self.t_position.x1,self.t_position.y1  =  GetElement(self.m_root, "conForSpine1_SceneLoginMgr", WZUIContainer):getPosition()

	self.t_position.lastX = 0
	self.t_position.lastY = 0

    if WZDeviceHelper:sharedDeviceHelper().startDeviceMotionUpdate then
        WZDeviceHelper:sharedDeviceHelper():startDeviceMotionUpdate(SceneLoginMgr.upPosition, SceneLoginMgr)
    end
	WZLog("SceneLoginMgr:adaptSize:", self.t_position)
end

--@brief 更新屏幕的坐标位置
function SceneLoginMgr:upPosition(moveValue)
	local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
	local tMoveValue = json.decode(moveValue)

	if tMoveValue.orientation == nil then
		return
	end
	
	tMoveValue.x, tMoveValue.y = -tMoveValue.y, tMoveValue.x

	if tMoveValue.orientation ~= 3 then
		tMoveValue.x, tMoveValue.y = -tMoveValue.x, -tMoveValue.y
	end

--	WZLog("SceneLoginMgr:upPosition: one", Serialize(tMoveValue))
	if WZUISystem:getInstance():getPlatformInfo() == 2 then --2为安卓系统
		tMoveValue.y = tMoveValue.y*0.1
		tMoveValue.x = tMoveValue.x*0.1
	end	

	tMoveValue.y = tMoveValue.y >= 1 and 1 or tMoveValue.y
	tMoveValue.y = tMoveValue.y <= -1 and -1 or tMoveValue.y
	tMoveValue.x = tMoveValue.x >= 1 and 1 or tMoveValue.x
	tMoveValue.x = tMoveValue.x <= -1 and -1 or tMoveValue.x

	local maxMove = 5/100
	if tMoveValue.y - self.t_position.lastY > maxMove then --每次移动不能超过5像素
		tMoveValue.y = self.t_position.lastY + maxMove
	end
	if tMoveValue.y - self.t_position.lastY < -maxMove then --每次移动不能超过5像素
		tMoveValue.y = self.t_position.lastY - maxMove
	end
	self.t_position.lastY = tMoveValue.y
	if tMoveValue.x - self.t_position.lastX > maxMove then --每次移动不能超过5像素
		tMoveValue.x = self.t_position.lastX + maxMove
	end
	if tMoveValue.x - self.t_position.lastX < -maxMove then --每次移动不能超过5像素
		tMoveValue.x = self.t_position.lastX - maxMove
	end
	self.t_position.lastX = tMoveValue.x

	local posX1 = self.t_position.x1 + tMoveValue.x*95
	local posY1 = self.t_position.y1 + tMoveValue.y*86
	local posX2 = self.t_position.x2 + tMoveValue.x*80
	local posY2 = self.t_position.y2 + tMoveValue.y*72
	local posX3 = self.t_position.x3 + tMoveValue.x*65
	local posY3 = self.t_position.y3 + tMoveValue.y*57
	local posX4 = self.t_position.x4 + tMoveValue.x*50
	local posY4 = self.t_position.y4 + tMoveValue.y*40

	local posX5 = self.t_position.x5 + tMoveValue.x*50
	local posY5 = self.t_position.y5 + tMoveValue.y*80
	local posX6 = self.t_position.x6 + tMoveValue.x*57
	local posY6 = self.t_position.y6 + tMoveValue.y*110

	local posX7 = self.t_position.x7 + tMoveValue.x*50
	local posY7 = self.t_position.y7 + tMoveValue.y*60
	local posX8 = self.t_position.x8 + tMoveValue.x*30
	local posY8 = self.t_position.y8 + tMoveValue.y*80

--	WZLog("SceneLoginMgr:upPosition MOVE:",tMoveValue.y, tMoveValue.x, posX, posY)
	local element4 =  GetElement(self.m_root, "conForSpine4_SceneLoginMgr", WZUIContainer)
	local element3 =  GetElement(self.m_root, "conForSpine3_SceneLoginMgr", WZUIContainer)
	local element2 =  GetElement(self.m_root, "conForSpine2_SceneLoginMgr", WZUIContainer)
	local element1 =  GetElement(self.m_root, "conForSpine1_SceneLoginMgr", WZUIContainer)

	local imgTree =  GetElement(self.m_root, "imgTree_SceneLoginMgr", WZUIImage)
	local spineBG = GetElement(self.m_root, "imgBG_SceneLoginMgr", WZUIImage)
	local spineRMountain = GetElement(self.m_root, "imgRightMountain_SceneLoginMgr", WZUIImage)
	local spineBMountain = GetElement(self.m_root, "imgBottomMountain_SceneLoginMgr", WZUIImage)

	element4:setPosition(GlobalMethod:ccp(posX4,  posY4))
	element3:setPosition(GlobalMethod:ccp(posX3,  posY3))
	element2:setPosition(GlobalMethod:ccp(posX2,  posY2))
	element1:setPosition(GlobalMethod:ccp(posX1,  posY1))
	imgTree:setPosition(GlobalMethod:ccp(posX5,  posY5))
	spineBG:setPosition(GlobalMethod:ccp(posX6,  posY6))
	spineRMountain:setPosition(GlobalMethod:ccp(posX8,  posY8))
	spineBMountain:setPosition(GlobalMethod:ccp(posX7,  posY7))
end
function SceneLoginMgr:_adaptLanguage_vn()
    WZLog("SceneLoginMgr:_adaptLanguage_vn")

    -- 越南12+防沉迷图片
    local imgVN = GetElement(self.m_root, "imgVN_SceneLoginMgr",WZUIImage)
    imgVN:setVisible(true)
    imgVN:setFile("ui/common/12-plus-detail.png")
    --ios设备不显示12+防沉迷图片
    if WZUISystem:getInstance():getPlatformInfo() == 1 then
        imgVN:setVisible(false)
    end
end

--@brief 	创建扔雪球动画
function SceneLoginMgr:createSnowBallAni()
	-- body
	if self.m_root == nil then return end 

	local conForSpine = GetElement(self.m_root, "conForSpine_SceneLoginMgr", WZUIContainer)

	if conForSpine then
		local spineSnowBall = WZUISpine:create()
		spineSnowBall:setLoop(false)
	    spineSnowBall:setVisible(true)
	    spineSnowBall:setTouchEnable(false)
	    spineSnowBall:setFileJson("role/christmas/xueqiu.json")
	    spineSnowBall:setFileAtlas("role/christmas/xueqiu.atlas")
	    spineSnowBall:setAnimationName("animation")
	    spineSnowBall:setRelativePosition(GlobalMethod:ccp(-0.001,0.685))

	    conForSpine:addChild(spineSnowBall, 1, 99)

	    conForSpine:enableSchedule("continueLoginIn", 0.8)
	end
end

--@brief 	登陆界面点击继续回调
function SceneLoginMgr:continueLoginIn()
	-- body
	local conForSpine = GetElement(self.m_root, "conForSpine_SceneLoginMgr", WZUIContainer)
	conForSpine:disableSchedule()
	if conForSpine:getChildByTag(99) then 
		conForSpine:removeChildByTag(99, true)
	end
	WndLoginSelect:doBtnSDKLogin()
end