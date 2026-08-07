---main.lua---
function replaceScene(frame, noShowFirstRechange)
    print("replaceScene", frame:getName())
    --切换场景
    CCArmatureDataManager:sharedArmatureDataManager():removeAll()
    --CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
    --CCTextureCache:sharedTextureCache():removeUnusedTextures();
    print("replaceScene::::::R:::", frame:getName())
    if frame:getName() == "splash" then 
        if WZUIFrame.setTouchAnimInfo ~= nil then 
            WZUIFrame:setTouchAnimInfo("","")
        end 
    end
    if WndChat ~= nil and WndChat.m_root ~= nil then
        WndChat:removeFreelistAllCell()
    end
	local scene = CCScene:create()
	scene:setContentSize(CCDirector:sharedDirector():getWinSize())

	if frame then
		scene:addChild(frame)
		--针对特殊分辨率屏幕将界面拉伸
		ScaleToAdjustSpecialScreen(frame)
		if WindowManager then
			WindowManager:setSceneRoot(frame)
		end
        if MsgBoxManager then
            MsgBoxManager:clear()
        end

		if CCDirector:sharedDirector():getRunningScene() then
            CCDirector:sharedDirector():replaceScene(scene)
            CCTextureCache:sharedTextureCache():removeUnusedTextures()
		else
			CCDirector:sharedDirector():runWithScene(scene)
		end
		--if PushWeibo then
		--	PushWeibo:showWeibo(frame)
		--end
		    --清除音频
 --[[   if  AudioManager then
        AudioManager:destoryAll()
    end]]

        
        iphonexTest(scene)
        if noShowFirstRechange == nil then
            showFirstRechange()
        end
        
        if WndGm then
            if ProjConfig.DEBUG == 1 and not WndServersSel.m_root then
                WndGm:showInter(frame)
            end
        end
		return true
	end

	return false
end

--@brief    iphonex测试
function iphonexTest(scene)
    if ProjConfig and ProjConfig.DEBUG == 1 and ProjConfig.IPHONEX_TEST == 1 and WndIphonexTest then
        local platForm =  WZUISystem:getInstance():getPlatformInfo()
        local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
        local screenRate = screenSize.width / screenSize.height
        CCLuaLog("iphonexTest " .. platForm .. " screenRate: " .. screenRate)
        if platForm == 3 and screenRate >= 1.9 and screenRate <= 2.2 then
            local wndIphonexTest = WndIphonexTest:createElement()
            scene:addChild(wndIphonexTest, TOP_LAYER_ZORDER)
        end
    end
end

--@brief    展示首冲
function showFirstRechange()
    if TeachGroup1 then
        local isToShowFirstRechange, isEndShowFirstRechange = TeachGroup1:isFirstRechangePushFinish("1_1"), TeachGroup1:isFirstRechangePushFinish("1_2")
        local isToShowFirstRechange2, isEndShowFirstRechange2 = TeachGroup1:isFirstRechangePushFinish("2_1"), TeachGroup1:isFirstRechangePushFinish("2_2")
        CCLuaLog("showFirstRechange one " .. " SceneBossRoom " .. tostring(SceneBossRoom.m_bIsCreate) .. 
            " isToShowFirstRechange " .. tostring(isToShowFirstRechange) .. " isEndShowFirstRechange " .. 
            tostring(isEndShowFirstRechange) .. 
            " isToShowFirstRechange2 " .. tostring(isToShowFirstRechange2) .. " isEndShowFirstRechange2 " .. 
            tostring(isEndShowFirstRechange2) .. " GlobalGame.g_bIsGetFirstRecharge " .. 
            tostring(GlobalGame.g_bIsGetFirstRecharge))

        if (isToShowFirstRechange and isEndShowFirstRechange == false) and GlobalGame.g_bIsGetFirstRecharge and 
            CacheCenter:getPlayerInfo() and SceneBossRoom.m_bIsCreate == nil and SceneBattle.m_bIsCreate == nil and SceneLoginMgr.m_bIsCreate == nil and 
            SceneBattleLoading.m_bIsCreate == nil and CacheCenter:getPlayerInfo().level <= 30 and 
            (not WindowManager:getTeachShelterLayer()) and WndTeachTalk.m_root == nil then
            CCLuaLog("showFirstRechange two")
            TeachGroup1:setFirstRechangePushFinish("1_2")
            local wnd = CellRechargePanelActivity:createElement()
            WindowManager:addWindow(wnd, CellRechargePanelActivity, true)

        elseif (isToShowFirstRechange2 and isEndShowFirstRechange2 == false) and GlobalGame.g_bIsGetFirstRecharge and 
            CacheCenter:getPlayerInfo() and SceneBattle.m_bIsCreate == nil and SceneLoginMgr.m_bIsCreate == nil and 
            SceneBattleLoading.m_bIsCreate == nil and SceneCity.m_bIsCreate == nil and
            (not WindowManager:getTeachShelterLayer()) and WndTeachTalk.m_root == nil then
            CCLuaLog("showFirstRechange three")
            TeachGroup1:setFirstRechangePushFinish("2_2")
            local wnd = CellRechargePanelActivity:createElement()
            CellRechargePanelActivity.m_bIsText = true
            WindowManager:addWindow(wnd, CellRechargePanelActivity, true)
        end
    end
end

--@brief	针对特殊分辨率屏幕将界面拉伸
function ScaleToAdjustSpecialScreen(element)
	local limitRate = 1136 / 640
	local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
	local screenRate = screenSize.width / screenSize.height
    CCLuaLog("ScaleToAdjustSpecialScreen one ".."element = "..tostring(element).." screenSize = "..screenSize.width..","..screenSize.height.." screenRate = "..screenRate.." limitRate = "..limitRate)
	if screenRate > limitRate then
        CCLuaLog("ScaleToAdjustSpecialScreen two ".."element = "..tostring(element).." screenSize = "..screenSize.width..","..screenSize.height.." screenRate = "..screenRate.." limitRate = "..limitRate)
		local nOriginalWidth = screenSize.height / 640 * 1136
		local nScale = screenSize.width / nOriginalWidth
		--element:setScaleX(element:getScaleX()*nScale)
	end
end

function check()
	KEngine:getInstance():checkReloadFiles()
end

function applicationDidFinishLaunching()
    CCLuaLog("applicationDidFinishLaunching")
    WZResourceManager:getInstance():executeLuaFile("json.lua")
    WZResourceManager:getInstance():executeLuaFile("json.dat")
    local sSdklualist = WZFileUtil:getFileContent("sdk_lua.list")
    CCLuaLog(sSdklualist)
    local tSdklualist = json.decode(tostring(sSdklualist))
    for i,v in ipairs(tSdklualist) do
        CCLuaLog(v)
        WZResourceManager:getInstance():executeLuaFile(v)
    end

    --限制游戏帧率为30帧
    CCDirector:sharedDirector():setAnimationInterval(1.0/60)

    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if platForm == 13 then
        print("Windows phone 8 device ......")
        return
    end
    --初始化登录付费sdk
    PassportSdkManager:initSdk()
    --初始化推送sdk
    PushSdkManager:initSdk()

    --初始化防外挂sdk
    PlugSDKManager:initSdk()
    
    --初始化数据统计sdk
    DSSdkManager:initSdk()

    --初始化社交sdk
    SNSSdkManager:initSdk()

    -- --语言聊天的修改
    -- SDK_Talk:init()
end

function applicationDidEnterBackground()
	if SoundManager ~= nil then
		SoundManager:enterBackGround()
	end
    if ToBackGround ~= nil then 
        ToBackGround()
    end
    if WGCloudVoiceNotify ~= nil then
        WGCloudVoiceNotify:Pause()
    end
end

function applicationWillEnterForeground()
    if WGCloudVoiceNotify ~= nil then
        WGCloudVoiceNotify:Resume()
    end
	if SoundManager ~= nil then
		SoundManager:enterForeGround()
	end
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
	if platForm == 2 or  platForm == 13  then
        if getRunningFrame ~= nil and getRunningFrame() and _updateTexture_BattleMapManager ~= nil and SceneBattle ~= nil and SceneBattle.m_root ~= nil then
            --战斗地图纹理更新
            getRunningFrame():runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.6),CCCallFuncN:create(_updateTexture_BattleMapManager)))
        end
    end
    if FromBackGround ~= nil then 
        FromBackGround()
    end
end

function main()
  --package.path = package.path .. ";Z:/macdata/tyq_work/dandandao_new/dandandao_new/program/client/trunk/dandandao/ZeroBraneStudio/lualibs/mobdebug/?.lua;";
  --require("mobdebug").start()
    --CCDirector:enableVBO(false)
    CCLuaLog("ddd main start")
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if platForm == 2 then --android
        CCDirector:setSupportETC(true)
    end

    if platForm == 1 then -- ios
        local systemName = WZDeviceInfo:systemName()
        CCLuaLog("systemName " .. systemName)
        local unUseParticileList = {}
        table.insert(unUseParticileList,"iPhone1,1")
        table.insert(unUseParticileList,"iPhone1,2")
        table.insert(unUseParticileList,"iPhone2,1")
        --table.insert(unUseParticileList,"iPhone3,1")
        --table.insert(unUseParticileList,"iPhone3,3")
        table.insert(unUseParticileList,"iPod1,1")
        table.insert(unUseParticileList,"iPod2,1")
        --table.insert(unUseParticileList,"iPod3,1")
        --table.insert(unUseParticileList,"iPod4,1")
        --table.insert(unUseParticileList,"x86_64")
        local lowDevice = false;
        for i, sysName in pairs(unUseParticileList) do
            if systemName == sysName then
                lowDevice = true
                break
            end
        end
        if lowDevice == true then
            CCLuaLog("Use kTexture2DPixelFormat_RGBA4444")
            CCTexture2D:setDefaultAlphaPixelFormat(kTexture2DPixelFormat_RGBA4444)
        end
    end
    CCDirector:sharedDirector():setEnableRenderer(true)
    if platForm == 13 then
        CCDirector:sharedDirector():setEnableRenderer(false)
       local totalMemory = WZDeviceInfo:getTotalMemory()
        totalMemory = totalMemory/(1024*1024)
        CCLuaLog("totalMemory " ..totalMemory)
        if totalMemory <= 1024 then
            CCTexture2D:setDefaultAlphaPixelFormat(kTexture2DPixelFormat_RGBA4444)
        end 
    end
	if CCLabelTTF.setFontMapInfo ~= nil then 
        --CCLabelTTF:setFontMapInfo("font/font_map.xml")
    end

    --lua使用渐进式垃圾回收器
    --渐进的节奏与内存分配的速度成比例
    --collectgarbage("setpause",100)设置暂停时间，控制回收器在完成一次回收之后和开始下次回收之前要等待多久
    print("main()::  collectgarbage 200")
    collectgarbage("setpause", 200)
    --collectgarbage("setstepmul",5000)设置步进系数，控制回收器每个步进回收多少内容。
    collectgarbage("setstepmul", 5000)
    --暂停时间越小，步进系数越大，垃圾回收越快
	if WZUISpine.setOldSpine ~= nil then 
		WZUISpine:setOldSpine(true)
	end
    CCEGLView:sharedOpenGLView():setDesignResolutionSize(1136,640,0)
	local frame = WZUISystem:getInstance():createElement("splash")
	replaceScene(frame)

    G_WINDOW_SIZE = {}
    G_WINDOW_SIZE.WIDTH = CCEGLView:sharedOpenGLView():getFrameSize().width
    G_WINDOW_SIZE.HEIGHT = CCEGLView:sharedOpenGLView():getFrameSize().height
    CCLuaLog("start3")
end

