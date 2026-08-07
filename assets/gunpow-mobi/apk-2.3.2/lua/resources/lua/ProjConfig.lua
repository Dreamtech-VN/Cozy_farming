--ProjConfig.lua
--@brief	项目配置文件
--@date		2013/12/02
--@author	叶威
--@note		配置项目的debug属性以及多语言，渠道等。需要放在wydengine.conf最上面，优先其他文件加载

ProjConfig =
{
	DEBUG = 1,  		--是否debug模式，1为debug，0为release，默认为1
	LANGUAGE = "en", 	--语言版本，为资源文件夹名字的后缀，如resource_cn，则为cn
	AREACODE = "EN",	--区域码
	VERSION_MARK = 0, 	--版本标识（0是普通版本，1是外放包版本）
	USE_DOWNLOAD = 1, 	--是否打开下载，0关闭，1打开 
	CHANNEL_ID = 1059, 	--渠道ID
	IPD_DDR = nil,	 	--ipd地址 域名
    IPD_IP = nil,       --ipd地址 ip
	UPDATE_URL = nil,	--动态更新url
    UPDATE_URL1 = nil,	--动态更新url
	EXTEND_URL = nil,	--扩展包url
	ISOPEN_EXTEND = 0,  --是否具有拓展包下载
	EXTEND_LEVEL  = 0,  --拓展包下载等级
    IS_FREE_REGISTER = 0,--SDK的登录方式是否是免注册的, 不接入SDK也为0, 1是免注册, 2是免注册用户去进行注册
	PHONESERVERURL = nil,
    ABOUT_SHOWTYPE = 0,
    APP_KEY = nil,
    APP_ID = 0,
	USE_DOWNLOAD_OBB = 0,--是否具有obb下载
    OBB_URL = nil,      --Obb下载url
    ICON_URL_FIRST = nil,     --关于界面图片显示连接地址 
    ICON_URL_SECOND = nil,	--关于界面图片显示连接地址
	PAYMENT = "WndRecharge", --冲值界面类型
    INSTALLVERSION = nil, --版本号
    POST_EVENT_URL = nil, --上传关键节点记录的url
	LANGUAGE_CHANGE = 0, --开启语言切换
	userAgreement = nil, --用户协议
    m_ipdCurIndex = nil, --ipd地址控制
    USE_HTTPS = 0,  --是否使用https协议
    PLAY_LOGO = 0, --是否播放动画
    GCLOUDVOICE_ID = "1333081299", --语言的Id
    GCLOUDVOICE_KEY = "q12345q6789q", --语言的Key
    SDK_CODE = 0, --针对sdk版本方法判断的引入:1.ios英雄助手攻略退出回调的引入，2.添加英雄按钮的开关控制，5.添加应用宝BBS
    IPHONEX_TEST = 0,   --iphoneX测试
    CloseTeach = 0,   --关闭新手
    AndroidBack = 0,--是否需要处理android返回键
}

--@brief 初始化项目配置，由project.conf读取配置项的值
function ProjConfig:init()
	CCLuaLog("---------------------------------------projConfig-----------------------------------------")
	local sDebug = WZFileUtil:getNodeValueFromXml("Debug")
	CCLuaLog("Debug = "..sDebug)
	self.DEBUG = tonumber(sDebug)

	local sLanguage = WZFileUtil:getNodeValueFromXml("Language")
	CCLuaLog("Language = "..sLanguage)
	self.LANGUAGE = sLanguage
	
	local sAreaCode = WZFileUtil:getNodeValueFromXml("AreaCode")
	CCLuaLog("AreaCode = "..sAreaCode)
	self.AREACODE = sAreaCode

	local sVesionMask = WZFileUtil:getNodeValueFromXml("VesionMask")
	CCLuaLog("VesionMask = "..sVesionMask)
	self.VERSION_MARK = tonumber(sVesionMask)

	local sDownLoad = WZFileUtil:getNodeValueFromXml("UseDownLoad")
	CCLuaLog("UseDownLoad = "..sDownLoad)
	self.USE_DOWNLOAD = tonumber(sDownLoad)

	local sChannelId = WZFileUtil:getNodeValueFromXml("ChannelId")
	CCLuaLog("ChannelId = "..sChannelId)
	self.CHANNEL_ID = tonumber(sChannelId)

	local sIpd = WZFileUtil:getNodeValueFromXml("IpdAddr")
	CCLuaLog("IpdAddr = "..sIpd)
	self.IPD_DDR = sIpd

    local sIpdIp = WZFileUtil:getNodeValueFromXml("IpdIp")
    CCLuaLog("IpdIp = "..sIpdIp)
    self.IPD_IP = sIpdIp

    if isChannelQQHall() then 
        self.IPD_DDR = "qcn.ddd2.zhuoyuechenxing.com:80"
    end


	local sUpdate = WZFileUtil:getNodeValueFromXml("UpdateUrl")
	CCLuaLog("UpdateUrl = "..sUpdate)
	self.UPDATE_URL = sUpdate
    if self.CHANNEL_ID == 2060 then
        self.UPDATE_URL = "http://qch.ddd2.zhuoyuechenxing.com:8080/ddd2/list/dddCN_updateNormal_1.0.7_1710191536_tnmNEW.xml"
    end
    sUpdate = WZFileUtil:getNodeValueFromXml("UpdateUrl_1")
	CCLuaLog("UpdateUrl_1 = "..sUpdate)
    self.UPDATE_URL1 = sUpdate
	local sExtend = WZFileUtil:getNodeValueFromXml("ExtendUrl")
	CCLuaLog("ExtendUrl = "..sExtend)
	self.EXTEND_URL = sExtend

	local sOpenExtend = WZFileUtil:getNodeValueFromXml("IsOpenExtendUpdate")
	CCLuaLog("OpenExtend = "..sOpenExtend)
	self.ISOPEN_EXTEND = tonumber(sOpenExtend)

    local sExtendLevel = WZFileUtil:getNodeValueFromXml("ExtendLevel")
	CCLuaLog("ExtendLevel = "..sExtendLevel)
	self.EXTEND_LEVEL = tonumber(sExtendLevel)

    local sIsFreeRegister = WZFileUtil:getNodeValueFromXml("IsFreeRegister")
    CCLuaLog("IsFreeRegister = "..sIsFreeRegister)
    self.IS_FREE_REGISTER = tonumber(sIsFreeRegister)
	
	--图片服务器地址
	local sPhoneServerUrl = WZFileUtil:getNodeValueFromXml("PhoneServerUrl")
	self.PHONESERVERURL = tostring(sPhoneServerUrl)
    
    local sAboutShowType =  WZFileUtil:getNodeValueFromXml("AboutShowType")
    self.ABOUT_SHOWTYPE = tonumber(sAboutShowType)
    
    local sPushAppkey =  WZFileUtil:getNodeValueFromXml("PushAppKey")
    self.APP_KEY = sPushAppkey
    
    local sPushAppid =  WZFileUtil:getNodeValueFromXml("PushAppId")
    self.APP_ID = sPushAppid
    --self.APP_ID = tonumber(sPushAppid)
	
	local sDownLoadObb = WZFileUtil:getNodeValueFromXml("UseDownLoadObb")
    CCLuaLog("UseDownLoadObb = "..sDownLoadObb)
    self.USE_DOWNLOAD_OBB = tonumber(sDownLoadObb)

    local sObbUrl = WZFileUtil:getNodeValueFromXml("ObbUrl")
    CCLuaLog("ObbUrl = "..sObbUrl)
    self.OBB_URL = sObbUrl

    --关于界面图片显示连接地址
    local sShowIconUrlfir = WZFileUtil:getNodeValueFromXml("ShowIconUrlFirst")
    CCLuaLog("sShowIconUrlf = "..sShowIconUrlfir)
    self.ICON_URL_FIRST = sShowIconUrlfir
    --关于界面图片显示连接地址
    local sShowIconUrlsec = WZFileUtil:getNodeValueFromXml("ShowIconUrlSecond")
    CCLuaLog("sShowIconUrlsec = "..sShowIconUrlsec)
    self.ICON_URL_SECOND = sShowIconUrlsec
	
	--充值界面类型
    local sParType = WZFileUtil:getNodeValueFromXml("Payment")
    CCLuaLog("sShowIconUrlsec = "..sShowIconUrlsec)
    self.PAYMENT = sParType
	
	--充值界面类型
    local sAgreement = WZFileUtil:getNodeValueFromXml("UserAgreement")
    CCLuaLog("sShowIconUrlsec = "..sAgreement)
    self.userAgreement = sAgreement
    
    local sInstallVersion = WZFileUtil:getNodeValueFromXml("InstallVersion")
    CCLuaLog("sInstallVersion = "..sInstallVersion)
    self.INSTALLVERSION = sInstallVersion
    
    local sPostEventUrl = WZFileUtil:getNodeValueFromXml("PostEventUrl")
    CCLuaLog("sPostEventUrl = "..sPostEventUrl)
    self.POST_EVENT_URL = sPostEventUrl
	
	local sLanguageChange = WZFileUtil:getNodeValueFromXml("LanguageChange")
    CCLuaLog("sLanguageChange = "..sLanguageChange)
    self.LANGUAGE_CHANGE = tonumber(sLanguageChange)
	if self.LANGUAGE_CHANGE == 1 then
		self:setCurrentLanguage()
	end
	
    if self.DEBUG == 1 then 
        CCDirector:sharedDirector():setDisplayStats(true)
    end
    local useHttps = WZFileUtil:getNodeValueFromXml("UseHTTPS")
    if useHttps ~= nil and useHttps ~= "" then 
        self.USE_HTTPS = tonumber(useHttps)
    end

    local sPlayLogo = WZFileUtil:getNodeValueFromXml("PlayLogo")
    CCLuaLog("sPlayLogo = "..sPlayLogo)
    self.PLAY_LOGO = tonumber(sPlayLogo)

    local sGCloudVoiceId = WZFileUtil:getNodeValueFromXml("GCloudVoiceId")
    CCLuaLog("sGCloudVoiceId = "..sGCloudVoiceId)
    self.GCLOUDVOICE_ID = tostring(sGCloudVoiceId)

    local sGCloudVoiceKey = WZFileUtil:getNodeValueFromXml("GCloudVoiceKey")
    CCLuaLog("sGCloudVoiceKey = "..sGCloudVoiceKey)
    self.GCLOUDVOICE_KEY = tostring(sGCloudVoiceKey)
    local sSdkCode = WZFileUtil:getNodeValueFromXml("SDKCode")
    CCLuaLog("sSdkCode = "..sSdkCode)
    self.SDK_CODE = tonumber(sSdkCode)

    local iphonex = WZFileUtil:getNodeValueFromXml("IphonexTest")
    CCLuaLog("IphonexTest = "..iphonex)
    self.IPHONEX_TEST = tonumber(iphonex)

    local closeTeach = WZFileUtil:getNodeValueFromXml("CloseTeach")
    CCLuaLog("CloseTeach = "..closeTeach)
    self.CloseTeach = tonumber(closeTeach)

    local androidBack = WZFileUtil:getNodeValueFromXml("AndroidBack")
    CCLuaLog("AndroidBack = "..androidBack)
    self.AndroidBack = tonumber(androidBack)
        
    local DressAniDownloadConfig = WZFileUtil:getNodeValueFromXml("DressAniDownloadConfig")
    if self.CHANNEL_ID == 1118 or self.CHANNEL_ID == 1119 or self.CHANNEL_ID == 1120 then
        DressAniDownloadConfig = "http://ddd2cdn.youwanplay.com/qqandroid/1976/DressAniDownloadConfig.xml"
    end
    CCLuaLog("DressAniDownloadConfig = "..DressAniDownloadConfig)
    self.DressAniDownloadConfig = DressAniDownloadConfig

    local DressAniDownloadConfig_All = WZFileUtil:getNodeValueFromXml("DressAniDownloadConfigAll")
    if self.CHANNEL_ID == 1118 or self.CHANNEL_ID == 1119 or self.CHANNEL_ID == 1120 then
        DressAniDownloadConfig_All = "http://ddd2cdn.youwanplay.com/qqandroid/1976/DressAniDownloadConfig_All.xml"
    end
    CCLuaLog("DressAniDownloadConfig_All = "..DressAniDownloadConfig_All)
    self.DressAniDownloadConfig_All = DressAniDownloadConfig_All
	CCLuaLog("---------------------------------------projConfig-----------------------------------------")
    if self.LANGUAGE == "vn" then 
        self.IPD_DDR = string.gsub(self.IPD_DDR, "zhuoyuechenxing", "youwanplay")
        self.UPDATE_URL = string.gsub(self.UPDATE_URL, "zhuoyuechenxing", "youwanplay")
        self.POST_EVENT_URL = string.gsub(self.POST_EVENT_URL, "zhuoyuechenxing", "youwanplay")
    end
end

function ProjConfig:getIpdAddr()
    if self.m_ipdCurIndex == 1 and self.IPD_IP ~= nil then
        return self.IPD_IP
    end
    return self.IPD_DDR
end

function ProjConfig:setIpdAddrFlag()
    if self.m_ipdCurIndex == 1 then
        self.m_ipdCurIndex = 0
    else
        self.m_ipdCurIndex = 1
    end
end

function ProjConfig:getChannelId()
    return self.CHANNEL_ID
end

--@brief 根据包名来判断有哪些语言开启
function ProjConfig:getLanguageOpen()
	local packageName = WGameCmUtil:GetBundleIdentifier()
	if packageName	== "com.herogame.gplay.dddsea" then
		return {"en","th"}
	elseif packageName	== "com.herogame.bombleadsa" then
		return {"en","th"}
	elseif packageName	== "com.herogame.gplay.dddglo" then
		return {"en","th", "zh"}
    elseif packageName	== "com.wyd.gplay.bombheroes" then
    	return {"pt","en","es"}
    elseif packageName  == "com.wyd.gplay.bombheroesen" then
        return {"en"}
    elseif packageName  == "com.wyd.gplay.heroibomba" then
        return {"pt"}
    elseif packageName  == "com.wyd.gplay.bombheroesen" then
        return {"en"}
    elseif packageName  == "com.wyd.gplay.heroibomba" then
        return {"pt"}
    elseif packageName  == "com.wyd.gplay.bombheroesen" then
        return {"en"}
    elseif packageName  == "com.wyd.gplay.heroibomba" then
        return {"pt"}
    elseif packageName  == "com.wyd.gplay.bombheroesen" then
        return {"en"}
    elseif packageName  == "com.wyd.gplay.heroibomba" then
        return {"pt"}
    elseif packageName	== "com.wyd.tcl.bombheroes" then
    	return {"pt","en","es"}
    elseif packageName  == "com.wyd.samsung.bombheroes" then
        return {"pt","en","es"}
    elseif packageName  == "com.wyd.samsungbr.bombheroes" then
        return {"pt","en","es"}
    elseif packageName	== "com.wyd.appstore.bombheroes" then
    	return {"pt","en","es"}
    elseif packageName  == "com.edo.ios.Ihabombom" then
        return {"pt","en","es"}
    elseif packageName  == "com.ios.jt.bombboombang" then
        return {"pt","en","es"}
    elseif packageName  == "com.ios.edo.bomb" then
        return {"en"}
    elseif packageName  == "com.ios.jt.bombgala" then
        return {"en"}
    elseif packageName  == "com.ios.rwt.bomberclash" then
        return {"en"}
    elseif packageName  == "com.ios.jt.bombmonster" then
        return {"en"}
    elseif packageName  == "com.ios.jt.bouncelegends" then
        return {"en"}
    elseif packageName  == "com.ios.jt.bouncingchurch" then
        return {"en"}
    elseif packageName  == "com.ios.jt.bombcyclone" then
        return {"en"}
    elseif packageName  == "com.ios.jt.shootertribe" then
        return {"en"}
    elseif packageName  == "com.ios.jt.projectilefiring" then
        return {"en"}
    elseif packageName  == "com.ios.jt.secrettreasure" then
        return {"en"}
    elseif packageName  == "com.ios.jt.mysteriousland" then
        return {"en"}
    elseif packageName  == "com.ios.jt.galgun" then
        return {"en"}
    elseif packageName  == "com.DDBom.b" then
        return {"pt","en","es"}
    elseif packageName  == "com.mh.jl" then
        return {"pt","en","es","hk"}
    elseif packageName  == "dd.pd.cr" then
        return {"pt","en","es","hk"}
    elseif packageName	== "com.wyd.brgp.bombheroes" then
    	return {"pt","en","es"}
    elseif packageName  == "com.ios.rwt.bombcrash" then
        return {"pt","en","es"}
    elseif packageName  == "com.letui.doombomb" then
        return {"en"}
    elseif packageName	== "com.bombman.omg" then
    	return {"tr","en"}
    elseif packageName	== "com.bombman.omgEU" then
    	return {"tr","en"}
    elseif packageName	== "com.herogame.gplay.dddgone" then
		return {"en","th", "zh"}	
    elseif packageName	== "com.bombmaster.mg" then
    	return {"tr","en"}
    elseif packageName  == "com.sao.ios.bmmj" then
        return {"tr","en"}
    elseif packageName  == "com.sfrz.ddd" then
        return {"tr","en"}
    elseif packageName  == "com.ddd.haiwai" then
        return {"tr","en"}
    elseif packageName  == "com.overseas.dan" then
        return {"tr","en"}
    elseif packageName	== "com.tutu.chibibomberios" then
    	return {"tr","en"}
    elseif packageName	== "com.tutu.chibibomberandroid" then
    	return {"tr","en"}  	
    elseif packageName  == "com.ddd.tjyw" or packageName == "com.dddlxj.ubw" then
        return {"zh"} 
    end
    return {"en","zh"}
end

--@brief 获取得到当前设置的语言类型
--@return 语言类型
function ProjConfig:setCurrentLanguage()
	local data = WZDataFile:getInstance():getUserData()
	if data then
        local key = data:getStringValue("LanguageData", "language")
        if key ~= nil and key ~= "" then
		  CCLuaLog("GetCurrentLanguage by key:"..key)
		  self.LANGUAGE = key
		  return key
        end
	end
	--根据设备语言去
	local language = WZDeviceInfo:localeLanguageCode()
	CCLuaLog("GetCurrentLanguage by device:"..language)
	local supportLanguage = self:getLanguageOpen()
	for k,v in pairs(supportLanguage) do
		if language == v then
			if language == "zh" then --中文的特殊转换
				language = "cn"
			end
			if language ~= self.LANGUAGE then
				--存储语言
				local data = WZDataFile:getInstance():getUserData()
				if data then		
					data:setStringValue("LanguageData", "language", language)
					data:flush()
					splash.b_needReload = true
					--KEngineReloadAll()
				end
			end
			break
		end
	end
end
