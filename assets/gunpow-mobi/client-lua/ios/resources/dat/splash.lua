--splash.lua
--@brief	闪屏界面
--@date		2015/9/15
--@author	system
--@note		闪屏界面，名字不能修改，引擎加载必须

splash = {
	m_root = nil,
    m_tUtilsAdapter = nil,
	b_hasDelayHero = true,
	b_needReload = false,
}

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function splash:onEnter(element)
	self.m_root = element	
    g_enterCityIsland = false
    g_canReset = false
    g_needPlayMove = true
    --是否需要闪屏
    if self:needSplash() then
        local conSpalsh = WZUIContainer:luaTo(self.m_root:getChildElement("conSplash_splash"))
        if conSpalsh ~= nil then
            conSpalsh:setVisible(true)
        end
    end
    local packName = WGameCmUtil:GetBundleIdentifier()
    if g_needPlayMove and packName == "com.wyd.dandandao.hero" then
        local platForm =  WZUISystem:getInstance():getPlatformInfo()
        if platForm == 2 then --android
            self.m_tUtilsAdapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("org/cocos2dx/hellolua/DandandaoUtils")
        elseif platForm == 1 then -- ios
            self.m_tUtilsAdapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("DandandaoUtils")
        end
        if self.m_tUtilsAdapter then
            self.m_cgTime = os.time()
            local callback = WZAdapterCallback:create(splash.moviesOver,splash)
            self.m_tUtilsAdapter:callMethodByName("playMovies",callback,"")
            self.m_root:enableSchedule("scheduleHeroLogo", 0)
            return
        end
    end
    self.m_root:enableSchedule("scheduleTime", 0)

    -- 闪屏图
    --local img1 = WZUIImage:luaTo(self.m_root:getChildElement("img1_splash"))
    --local isExist = WZFileUtil:isFileExist("common/splash/splash_2.png")
    --if not isExist then
        --img1:setFile("ui/login/login_pic_bg1.png")
        -- local nOffsetY = self:splashSpineOffset()
        -- img1:setRelativePosition(ccp(0.5, 0.5 + nOffsetY))
    --else
        --img1:setFile("common/splash/splash_2.png")
    --end
    -- LOGO
    local packageName = WGameCmUtil:GetBundleIdentifier()
    if packageName == "com.xmqqls.ddlm" or packageName == "com.ddlaj.ios" then
        local conLogo = WZUIContainer:luaTo(self.m_root:getChildElement("conLogo_splash"))
        conLogo:setVisible(false)
    end

    local packageName = WGameCmUtil:GetBundleIdentifier()
    if packageName == "com.baiji.ddmxd.a" or packageName == "com.baiji.dnm.a" or packageName == "com.letui.ddd.a" or packageName == "com.caohua.ddqs" 
        or packageName == "com.lyddd.ddd2001.qianliu" or packageName == "com.mldmx.junyi" or packageName == "com.mhzdr.ddd2002.sancaitang" 
        or packageName == "com.xxmxj1.junyi" or packageName == "com.dzzs.wangquan" or packageName == "com.dandao.qiusheng" or 
        packageName == "com.dandaocs.ddqs" or packageName == "com.bzdd.wdl" or packageName == "com.jsddd.ios" or packageName == "juezhan.dandan.daoyx" or packageName == "com.ddlm.wj" 
        or packageName == "com.ctdds.xz"  or packageName == "com.ddgs.wdddd" or packageName == "com.ddjt.lucky" then
        local conLogo = WZUIContainer:luaTo(self.m_root:getChildElement("conSplash_splash"))
        conLogo:setVisible(true)
    end
	if WZUISpine.setOldSpine ~= nil then 
		WZUISpine:setOldSpine(true)
	end

    if packageName == "com.ios.jt.bombgala" then
        local imgLogo = WZUIImage:luaTo(self.m_root:getChildElement("imgLogo_splash"))
        imgLogo:setFile("ui/login/logo_icon_bombgala.png")
    end

    local packageName = WGameCmUtil:GetBundleIdentifier()
    if packageName == "com.dino.bh" then
        local conLogo = WZUIContainer:luaTo(self.m_root:getChildElement("conLogo_splash"))
        conLogo:setVisible(false)
    end
    
    local sLanguage = WZFileUtil:getNodeValueFromXml("Language")
    if sLanguage == "vn" then
        local con = WZUIContainer:luaTo(self.m_root:getChildElement("conLogo_splash"))
        con:setVisible(false)
    end
    local packageName = WGameCmUtil:GetBundleIdentifier()
    print(" splash:onEnter packageName:111",packageName)
    if packageName == "com.bombmaster.mg" then
        print(" splash:onEnter packageName:222",packageName)
        local conLogo = WZUIContainer:luaTo(self.m_root:getChildElement("conLogo_splash"))
        conLogo:setVisible(false)
    end

    local packageName = WGameCmUtil:GetBundleIdentifier()
    if packageName == "com.wyd.brgp.bombheroes" or packageName == "com.herogames.gplay.ddduc" 
        or packageName == "com.herogames.gplay.dddsx"  or packageName == "com.herogame.gplay.dddsea" 
        or packageName == "com.herogame.bombleadsa" or packageName == "com.ios.jt.mysteriousland" 
        or packageName == "com.ios.jt.galgun" then
        local conLogo = WZUIContainer:luaTo(self.m_root:getChildElement("conLogo_splash"))
        conLogo:setVisible(false)
    end
end

--判断是否需要显示渠道的单独闪屏
function splash:needSplash()
  --韩国包需要
  --美洲的需要闪屏
  --越南备份2需要闪屏
    local packageName = WGameCmUtil:GetBundleIdentifier()
    if packageName == "com.wyd.gplay.bombheroes" or packageName == "com.wyd.appstore.bombheroes" or 
        packageName == "com.wyd.samsung.bombheroes" or packageName == "com.wyd.samsungbr.bombheroes" or packageName == "com.ios.edo.bomb" or 
        packageName == "com.edo.ios.Ihabombom" or packageName == "com.ios.jt.bombmonster" or 
        packageName == "com.ios.jt.bouncelegends" or packageName == "com.ios.jt.projectilefiring" or 
        packageName == "com.ios.jt.bouncingchurch" or packageName == "com.ios.jt.bombcyclone" or 
        packageName == "com.sfrz.ddd" or packageName == "com.ios.jt.shootertribe" or packageName == "com.DDBom.b" or 
        packageName == "com.mh.jl" or packageName == "com.ios.jt.secrettreasure" or packageName == "dd.pd.cr" or 
        packageName == "com.ios.jt.mysteriousland" or packageName == "com.ios.jt.galgun"  or packageName == "com.mfzg.fx"  or 
        packageName == "com.qytt" or packageName == "com.lattt" or packageName == "qytd.db.game" then
        return true
    end
    return false
end

function splash:onEnterTransitionDidFinish(element)
    CCDirector:sharedDirector():getScheduler():unscheduleAllScriptEntry()
end

--@brief    
function splash:splashSpineOffset() 
    -- body
    local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
    local designSize = CCEGLView:sharedOpenGLView():getDesignResolutionSize()

    local nScaleX = screenSize.width / designSize.width
    local nScaleY = screenSize.height / designSize.height

    if nScaleX > nScaleY then
        local cutYHeight = (nScaleX - nScaleY) * designSize.height / (2 * nScaleX)
        if cutYHeight > 20 then
            return (cutYHeight - 20) / designSize.height
        end
    end

    return 0
end

--@brief    初始化全局表
--@note     调用顺序不能随意调换
function splash:initGlobalTable()
    KEngine:getInstance():loadUIAndLuaFiles()
    if WZLanguageManager:shareLanguageManager().reload ~= nil then 
        WZLanguageManager:shareLanguageManager():reload()
    end
    ProjConfig:init()
    --设置当前平台类型
	PlatformInfo:setCurrentPlatform()
	LogInit()
    SoundManager:init()
	MsgBoxManager:init()
	WndPhantom:init()
    WindowManager:setSceneRoot(self.m_root)
    PostPlayerEvent:init()
    PostPlayerEvent:postEvent(PostPlayerEvent.event_startgame)
    if CCFileUtils:sharedFileUtils().clearCacheFilePath ~= nil then 
        CCFileUtils:sharedFileUtils():clearCacheFilePath()
    end
    if ProjConfig.LANGUAGE == "th" and CCLabelTTF.setLineBreakWithoutSpaces ~= nil then 
        CCLabelTTF:setLineBreakWithoutSpaces(true)
    end
    GlobalGame:load_plist_pack()
    --设置按钮点击间隔,0.6秒
    --WZUIButton:setGlobalInterval(50)
    math.randomseed(os.time())
    math.random(1, 100)    
end

--@brief	定时器回调方法
--@param	element:表绑定的UI节点引用
--@param	delta:定时器间隔
--@note		加载所有资源文件
function splash:scheduleTime(element, delta)
	self.m_root:disableSchedule()
    self:scheduleTime2()
    -- 第一次闪屏后进入第二次闪屏(1,Ios系统，2包名)
    -- if WZUISystem:getInstance():getPlatformInfo() == 1 and WGameCmUtil:GetBundleIdentifier() == "com.wyd.dandandao.hero" 
    -- 	and not g_hasDelayHero then
    -- 	g_hasDelayHero = false
    -- 	--DelayCallFunction(self.scheduleTime2, self, 20)
    --     self.m_startTime = os.time()
    --    self.m_root:enableSchedule("scheduleHeroLogo", 0)
    -- else
    --     self:scheduleTime2()
    -- end
end

function splash:moviesOver() 
    WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(self.m_tUtilsAdapter:getId())
    self.m_tUtilsAdapter = nil
    if g_needPlayMove then
        g_needPlayMove = false
        self.m_root:disableSchedule()
        self.m_root:enableSchedule("scheduleTime", 0)
    end
end

function splash:scheduleHeroLogo()
    if os.time() - self.m_cgTime >= 5 then
        if g_needPlayMove then
            g_needPlayMove = false
            self.m_root:disableSchedule()
            self.m_root:enableSchedule("scheduleTime", 0)
        end
    end
end

function splash:scheduleTime2()
--  local splashStudio = splashStudio:createElement()
--    replaceScene(splashStudio)
    --初始化
    self:initGlobalTable()
    if WGameCmUtil:GetBundleIdentifier() == "com.wyd.dandandao2.xy" then
    --    local img1 = WZUIImage:luaTo(self.m_root:getChildElement("img1_splash"))
    --    GetElement(self.m_root, "imgLogo_splash", WZUIImage):setVisible(false)
        -- if img1 then
        --     img1:setAnchorPoint(ccp(0.5,0))
        --     img1:setRelativePosition(ccp(0.5, 0))
        --     img1:setFile("common/splash/splash_zizhi.png")
        -- end
        self.m_startTime = os.time()
        self.m_root:enableSchedule("scheduleTime3", 0)
    else
        --self:playLogo()
        SceneLoginMgr:showScene(1)
        --DelayCallFunction(self.scheduleTime3, self, 10)    
    end
end

function splash:playLogo()
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
            SceneLoginMgr:showScene(1)
            return
        end
        if not g_playLogo and ProjConfig.PLAY_LOGO == 1 then
            g_playLogo = true
            local filePath = "vedio/wydLogo.mp4"
            filePath = CCFileUtils:sharedFileUtils():fullPathForFilename(filePath)
            local callback = WZAdapterCallback:create(splash.logoOver, splash)
            self.t_utilsAdapter:callMethodByName("playLogo",callback,filePath)
        else
            SceneLoginMgr:showScene(1)
        end
     else --没什么是做，就去登入界面
        SceneLoginMgr:showScene(1)
     end
end

function splash:scheduleTime3()
    if os.time() - self.m_startTime >= 3 then
        self.m_root:disableSchedule()
        SceneLoginMgr:showScene(1)
        --self:playLogo()
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function splash:onExit(element)
	self.m_root = nil
	SoundManager:playBgMusic(SoundDefine.E_MUSIC_JIA_ZAI)

	--本地推送消息 总共不超过60条
	--PushSdkManager:localPush([[ [{"date":"201511032051","msg":"test test","action":"confirm"}] ]])
	local msgCount = 0
	local tMsg = {}
	local pushInfo = {}
	--只推送一次的消息
	for k,v in pairs(GDatatab_xinge) do
		if v.islocal == 1 and v.everyday_push == 0 then
			tMsg = {}
			tMsg.date = self:transformTime(v.time_point,v.intervalday)
			tMsg.msg = v.msg
			tMsg.action = v.action
			if tMsg.date ~= "" then
				table.insert(pushInfo,tMsg)
			end
			msgCount = msgCount + 1
		end
	end
	--每天推送的消息
	for k,v in pairs(GDatatab_xinge) do
		if v.islocal == 1 and v.everyday_push == 1 then
			for i=1,7 do
				if msgCount < 40 then
					tMsg = {}
					tMsg.date = self:transformTime(v.time_point,i-1)
					tMsg.msg = v.msg
					tMsg.action = v.action
					if tMsg.date ~= "" then
						table.insert(pushInfo,tMsg)
					end
					msgCount = msgCount + 1
				end
			end
		end
	end

	--WZLog("本地推送消息 ",json.encode(pushInfo))
    WZLog("本地推送消息 ",Serialize(pushInfo))
	PushSdkManager:localPush(json.encode(pushInfo))
    NetManager:disableBreathNotifyDisconnect()
end

--@brief	把推送消息时间转化成字符串
--@param	time_point:推送时间点
--@param	day:从今天起推迟的天数
function splash:transformTime(time_point,day)
	local temp = os.date("*t", os.time()+86400*day)
	local date = ""
	date = date..temp.year
	if temp.month < 10 then
		date = date.."0"..temp.month
	else
		date = date..temp.month
	end
	if temp.day < 10 then
		date = date.."0"..temp.day
	else
		date = date..temp.day
	end
	local timePoint = SplitStringWithSeparator(time_point,":")
	date = date..timePoint[1]
	date = date..timePoint[2]

	return date
end

--function splash:delayCallFunction(func, tLuaObj, nTime, ... )
--    local arg = {...}
--    local nId = 0
--    local scheduleFunc = function ()
--        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nId)
--        if tLuaObj then
--            func(tLuaObj, unpack(arg))
--        else
--            func(unpack(arg))
--        end
--    end
--    nId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(scheduleFunc, nTime, false)
--end

