--下载管理器
DownloadManager =
{
	m_tDownloadObservers == {},
    downloading_list = {}, 			--下载列表
    xmlDoc = nil,
    xmlDoc_all = nil,
    m_nTouchBeginTime = 0,
    m_nDownloadedCount = 0,			--下载完成计数
    m_nScheduleID = -1,
    m_nTotalSize = nil, 				--下载的总大小
    m_nDownloadSize = nil, 			--已下载的大小
}

--@brief	注册下载资源观察者
--@param  tObserver：被注册观察者表对象
function DownloadManager:registerDownloadObserver(tObserver)
	if self.m_tDownloadObservers == nil then self.m_tDownloadObservers = {} end
	--已经注册,直接返回
	--for i=1,#self.m_tDownloadObservers do
	--	if self.m_tDownloadObservers[i] == tObserver then
	--		do return end
	--	end
	--end
	table.insert(self.m_tDownloadObservers, tObserver)
	WZLog("DownloadManager:registerDownloadObserver_1")
end

--@brief	取消注册下载资源观察者
--@param  tObserver：被注册观察者表对象
--function DownloadManager:unregisterDownloadObserver(tObserver)
--	if self.m_tDownloadObservers ~= nil then
--		for i=1,#self.m_tDownloadObservers do
--			if self.m_tDownloadObservers[i] == tObserver then
--				table.remove(self.m_tDownloadObservers, i)
--				do return end
--			end
--		end
--	end
--end

--调用所有观察者注册的方法
--更新下载完成时装对应的人物
function DownloadManager:_updateDownloadFinish(taskId, extraData, failed)
	WZLog("DownloadManager:_updateDownloadFinish", #self.m_tDownloadObservers)
	if self.m_tDownloadObservers ~= nil then
		for k,v in pairs(self.m_tDownloadObservers) do
			--WZLog("DownloadManager:_updateDownloadFinish_1", #self.m_tDownloadObservers, k, v.taskId, v.funName)
			local t = v.tTable
			local funName = v.funName
			if v.taskId == taskId then
				--更新显示
				if t[funName] ~= nil then
					WZLog("DownloadManager:_updateDownloadFinish_2", v.taskId, funName)
					t[funName](t, taskId, extraData, failed)
				end
				table.remove(self.m_tDownloadObservers, k)
			end
		end
	end
end

--create(int taskId, const char* url,const char* md5,const char* extraData, int luaCallbackHandle, int luaCallbackTableHandle = 0);
function DownloadManager:addDownloadTask(taskId, url, md5, extraData, funName, tTable)
	WZLog("DownloadManager:addDownloadTask", taskId, funName)
	if self.downloading_list == nil then self.downloading_list = {} end
	if utilsValueInTableKey(tostring(taskId), self.downloading_list) then
		WZLog("DownloadManager:addDownloadTask_1", taskId)
		--正在下载，注册一个观察者
		local tObserver = {}
		tObserver.taskId = taskId
		tObserver.funName = funName
		tObserver.tTable = tTable
		self:registerDownloadObserver(tObserver)
	else
		WZLog("DownloadManager:addDownloadTask_2", taskId)
		--还没下载，开始下载
		local tObserver = {}
		tObserver.taskId = taskId
		tObserver.funName = funName
		tObserver.tTable = tTable
		self:registerDownloadObserver(tObserver)

		local tData = {}
		tData.taskId = taskId
		tData.funName = funName
		tData.tTable = tTable

		self.downloading_list[tostring(taskId)] = tData

		WZLog("DownloadManager:addDownloadTask_start")
    	local task = WZDownloadPackTask:create(taskId, url, md5, extraData, self.downloadFinish, self)
    	--task:setLevel(taskId)
    	WZUISystem:getInstance():getMultiThreadSystem():addDownloadTask(task);
	end
end

function DownloadManager:downloadFinish(taskId, extraData, failed)
	CCLog("DownloadManager:downloadFinish", taskId, extraData, failed)
    if failed == 0 then 
		--下载成功
		DownloadManager.m_nDownloadedCount = DownloadManager.m_nDownloadedCount + 1
		local count1 = WZThread:getTickCount()
        --WZUpdateManager:getInstance():forceGenUpdateDirFileList()
        local delta = WZThread:getTickCount() - count1
        CCLog("DownloadManager:downloadFinish forceGenUpdateDirFileList ", delta)
		local tData = CopyTable(self.downloading_list[tostring(taskId)])
		self.downloading_list[tostring(taskId)] = nil
		self:_updateDownloadFinish(tData.taskId, extraData, failed)
	else
		self.downloading_list[tostring(taskId)] = nil
    end
end

--@brief 	检测下载资源
function DownloadManager:downloadResCheck()
	--检测皮肤boss
	WZLog("DownloadManager:downloadResCheck")
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."DressAniDownloadConfig.xml"
    local ConfigExist = WZDataFile:getInstance():checkFileExist(path)
	self.m_nTouchBeginTime = WZThread:getTickCount()
	if not self.xmlDoc and ConfigExist then
		--创建一次大概需要150ms
		self.xmlDoc = WZDataFile:getInstance():createXmlDocument(path)
		self.xmlDoc:retain()
	end
    local sAnimName = aninName 
	-- if ConfigExist then
	-- 	local xmlDoc = WZDataFile:getInstance():createXmlDocument(path)
	-- 	--没有下载配置文件成功，直接返回
	-- 	if not xmlDoc then return nil end
 --    	local rootElement = xmlDoc:getRootElement()
 --    	local xmlName = "File"
 --    	local element = rootElement:findChildElement(xmlName)
	-- 	while element do
 --    	    local index = element:attributeString("index")
 --    	    local sex = element:attributeString("sex")
 --    	    if sex == "boss" and tonumber(index) ~= nil then 
 --    	    	local spinePath = "battle/monster/boss_" .. index
	-- 			local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	-- 			if not existSpine then 
	-- 				local downloadInfo = {}
	--     	        downloadInfo.url = element:attributeString("url")
	--     	        downloadInfo.md5 = element:attributeString("md5")
	-- 				DownloadManager:addDownloadTask(10000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
	-- 				return 
	-- 			end
	-- 		elseif sex == "monster" and tonumber(index) ~= nil then 
	-- 			local spinePath = "battle/monster/monster_" .. index
	-- 			local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	-- 			if not existSpine then 
	-- 				local downloadInfo = {}
	--     	        downloadInfo.url = element:attributeString("url")
	--     	        downloadInfo.md5 = element:attributeString("md5")
	-- 				DownloadManager:addDownloadTask(10000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
	-- 				return 
	-- 			end
	-- 		end
 --    	    element = element:nextSiblingElement(xmlName)
 --    	end
	-- end

	-- --下载宠物
	-- if ConfigExist then
	-- 	local xmlDoc = WZDataFile:getInstance():createXmlDocument(path)
	-- 	--没有下载配置文件成功，直接返回
	-- 	if not xmlDoc then return nil end
 --    	local rootElement = xmlDoc:getRootElement()
 --    	local xmlName = "File"
 --    	local element = rootElement:findChildElement(xmlName)
	-- 	while element do
 --    	    local index = element:attributeString("index")
 --    	    local sex = element:attributeString("sex")
 --    	    if sex == "pet" then 
 --    	    	local spinePath = "armatures/pet/pet_" .. index
	-- 			local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
	-- 			if not existSpine then 
	-- 				local downloadInfo = {}
	--     	        downloadInfo.url = element:attributeString("url")
	--     	        downloadInfo.md5 = element:attributeString("md5")
	-- 				DownloadManager:addDownloadTask(8000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
	-- 				return 
	-- 			end
	-- 		end
 --    	    element = element:nextSiblingElement(xmlName)
 --    	end
	-- end
	self.m_nTouchBeginTime = WZThread:getTickCount()
	--下载称号
	if ConfigExist then
		--local xmlDoc = WZDataFile:getInstance():createXmlDocument(path)
		--没有下载配置文件成功，直接返回
		if not self.xmlDoc then return nil end
    	local rootElement = self.xmlDoc:getRootElement()
    	local xmlName = "File"
    	local element = rootElement:findChildElement(xmlName)
		while element do
    	    local index = element:attributeString("index")
    	    local sex = element:attributeString("sex")
			if sex == "titleFrame" then 
    	    	local spinePath = "armatures/ui/common_titleframe_" .. tonumber(index)
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(5000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "boss" and tonumber(index) ~= nil then 
    	    	local spinePath = "battle/monster/boss_" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")

					DownloadManager:addDownloadTask(10000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "monster" and tonumber(index) ~= nil then 
				local spinePath = "battle/monster/monster_" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(10000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "pet" then 
    	    	local spinePath = "armatures/pet/pet_" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
	    	        local hhh = WZThread:getTickCount()
	    	        WZLog("Pet Time Cost one", hhh - self.m_nTouchBeginTime)
	    	        self.m_nTouchBeginTime = hhh
					DownloadManager:addDownloadTask(8000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "wing" then 
				local spinePath = "armatures/player/wing/wing_" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(2000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "wuqi" then 
				local spinePath = "armatures/player/wuqi/wuqi" .. tonumber(index)
				if index == "0000" then 
					spinePath = "armatures/player/wuqi/wuqi"
				end
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(12000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "uiEffect" then 
				local spinePath = "armatures/ui/" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".png")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(14200,downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "runeDraw" then 
				local spinePath = "armatures/ui/otherUI/rune_draw_" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(14007,downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "playerhead_effect" then 
				local spinePath = "armatures/checkother/ui_playerhead_effect" .. tonumber(index)
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(7000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "mount" then 
				local spinePath = "armatures/player/mount/mount_" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(9000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "activityEffect" then 
				local spinePath = "armatures/activity/" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(14000,downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "boy" then 
				local spinePath = "armatures/baby/boy/" .. index .. "/babyboy_body_" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(3000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "girl" then 
				local spinePath = "armatures/baby/girl/" .. index .. "/babygirl_body_" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(3000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "combatboy" then 
				local spinePath = "armatures/player/combatboy/" .. index .. "/combatboy_body_" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
				if not existSpine then
					spinePath = "armatures/player/combatboy/" .. index .. "/combatboy_head_" .. index 
					existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
					if not existSpine then 
						spinePath = "armatures/player/combatboy/" .. index .. "/combatboy_face_" .. index 
						existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
					end
				end
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "combatboy_effect" then 
				local spinePath = "armatures/player/combatboy/effect/combatboy_body_" .. index .. "_effect"
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(1000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "combatgirl" then 
				local spinePath = "armatures/player/combatgirl/" .. index .. "/combatgirl_body_" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
				if not existSpine then
					spinePath = "armatures/player/combatgirl/" .. index .. "/combatgirl_head_" .. index
					existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
					if not existSpine then 
						spinePath = "armatures/player/combatgirl/" .. index .. "/combatgirl_face_" .. index
						existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
					end
				end
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "combatgirl_effect" then 
				local spinePath = "armatures/player/combatgirl/effect/combatgirl_body_" .. index .. "_effect"
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".xml")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
	    	        local hhh = WZThread:getTickCount()
	    	        WZLog("Pet Time Cost Three", hhh - self.m_nTouchBeginTime)
	    	        self.m_nTouchBeginTime = hhh
					DownloadManager:addDownloadTask(1000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "combat_lizi" then 
				local spinePath = "armatures/player/particle/combat_" .. index .. "_lizi"
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".plist")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(11000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "dkzj" then 
				local sIndex = string.gsub(index, "dkzj", "")
				local spinePath = "armatures/checkother/ui" .. sIndex .. "_1"
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(13000,downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "footprint" then 
				local spinePath = "armatures/footprint/city_footprints_" .. tonumber(index)
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(6000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			elseif sex == "petParticle" then 
				local spinePath = "armatures/pet_particle/particle_pet_" .. index
				local existSpine = WZDataFile:getInstance():checkFileExist(spinePath .. ".json")
				if not existSpine then 
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(4000 + tonumber(index),downloadInfo.url,downloadInfo.md5,index,"downloadCallback",self)
					return 
				end
			end
    	    element = element:nextSiblingElement(xmlName)
    	end
	end
end

function DownloadManager:scheduleDownloadResFinish(element,t)
    CCLog("DownloadManager:scheduleDownloadResFinish", DownloadManager.m_nDownloadedCount)
    if DownloadManager.m_nDownloadedCount > 0 then
        CCLog("DownloadManager:scheduleDownloadResFinish --- go to update WZFileList.xml")
        local count1 = WZThread:getTickCount()
        WZUpdateManager:getInstance():forceGenUpdateDirFileList()
        local delta = WZThread:getTickCount() - count1
        DownloadManager.m_nDownloadedCount = 0
        CCLog("DownloadManager:scheduleDownloadResFinish forceGenUpdateDirFileList ", delta, DownloadManager.m_nDownloadedCount)
    else        
        CCLog("DownloadManager:downloadFinish not need go to update WZFileList.xml ")
    end
end

--@brief 	检测下载资源
function DownloadManager:downloadResCheckAll()
	--检测皮肤boss
	CCLog("DownloadManager:downloadResCheckAll")
	--先刷新一次，防止资源下载途中关闭客户端导致的WZFileList.xml未完全刷新
	WZUpdateManager:getInstance():forceGenUpdateDirFileList()
	if DownloadManager.m_nScheduleID <= 0 then
		DownloadManager.m_nScheduleID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(DownloadManager.scheduleDownloadResFinish, 90, false)
	end
	self.m_nTouchBeginTime = WZThread:getTickCount()
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."DressAniDownloadConfig_All.xml"
    local ConfigExist = WZDataFile:getInstance():checkFileExist(path)
	if not self.xmlDoc_all and ConfigExist then
		self.xmlDoc_all = WZDataFile:getInstance():createXmlDocument(path)
		self.xmlDoc_all:retain()
	end
    --local sAnimName = aninName 
	local hhh = WZThread:getTickCount()
	CCLog("Pet Time Cost downloadResCheckAll-One-one", hhh - self.m_nTouchBeginTime)
	self.m_nTouchBeginTime = WZThread:getTickCount()
	local showTips = false
	--记录已下载的更新资源名称缓存，防止重复下载
	local userData = WZDataFile:getInstance():getUserData()
	--下载称号
	if ConfigExist and userData then
		--local xmlDoc = WZDataFile:getInstance():createXmlDocument(path)
		--没有下载配置文件成功，直接返回
		if not self.xmlDoc_all then return nil end

    	local rootElement = self.xmlDoc_all:getRootElement()
    	local xmlName = "File"
    	local element = rootElement:findChildElement(xmlName)
		while element do
    	    local index = element:attributeString("index")
    	    local sex = element:attributeString("sex")
    	    local md5 = element:attributeString("md5")
    	    local size = element:attributeString("size") or "70"
			local downloadCache = userData:getStringValue("DownloadCache_"..ProjConfig.INSTALLVERSION, sex..'_'..index)
			if downloadCache == nil or downloadCache ~= md5 then
				CCLog("DownloadManager:downloadResCheckAll ---- ", sex, index)
				if not showTips and LocalStrings.DOWNLOAD_RESOURCE_TIPS and tonumber(index) ~= 0 and sex ~= "all_title_frame" then
					MsgBoxManager:showTipBox(LocalStrings.DOWNLOAD_RESOURCE_TIPS, 5)
					showTips = true
				end

				local downloadInfo = {}
				local strExtraData = sex..'_'..index.. '#'..md5..'#'..size
    	        downloadInfo.url = element:attributeString("url")
    	        downloadInfo.md5 = element:attributeString("md5")
				if sex == "all_title_frame" and tonumber(index) ~= 0 then
					DownloadManager:addDownloadTask(2300 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)				
				elseif sex == "all_title_frame_resources" then
					DownloadManager:addDownloadTask(2400 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_title_frame_resources_cn" then
					DownloadManager:addDownloadTask(2500 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_combat_lizi" then
					DownloadManager:addDownloadTask(3400 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_footprint" then
					DownloadManager:addDownloadTask(3600 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_petparticle" then
					DownloadManager:addDownloadTask(3800 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_boss" and tonumber(index) ~= 0 then 
					DownloadManager:addDownloadTask(4000 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_monster" and tonumber(index) ~= 0 then 
					DownloadManager:addDownloadTask(4200 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_pet" and tonumber(index) ~= 0 then 
					DownloadManager:addDownloadTask(4400 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_wing" and tonumber(index) ~= 0 then
					DownloadManager:addDownloadTask(4600 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_mount" and tonumber(index) ~= 0  then 
					DownloadManager:addDownloadTask(4800 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_babyboy" then 
					DownloadManager:addDownloadTask(5000 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_babygirl" then 
					DownloadManager:addDownloadTask(5200 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_combatboy" then 
					DownloadManager:addDownloadTask(100 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_combatboy_effect" then 
					DownloadManager:addDownloadTask(1000 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_combatgirl" then 
					DownloadManager:addDownloadTask(500 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_combatgirl_effect" then 
					DownloadManager:addDownloadTask(2000 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_armatures_battle" and tonumber(index) ~= 0 then 
					DownloadManager:addDownloadTask(5400 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_armatures_ui" and tonumber(index) ~= 0 then 
					DownloadManager:addDownloadTask(5500 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_armatures_ui_cn" and tonumber(index) ~= 0 then 
					DownloadManager:addDownloadTask(5600 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_armatures_others" and tonumber(index) ~= 0 then 
					DownloadManager:addDownloadTask(5700 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_image" and tonumber(index) ~= 0 then 
					DownloadManager:addDownloadTask(5800 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_image_cn" and tonumber(index) ~= 0 then 
					DownloadManager:addDownloadTask(5900 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_zip_update" and tonumber(index) ~= 0 then 
					DownloadManager:addDownloadTask(6000 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)				
				elseif sex == "all_atkEffect" and tonumber(index) ~= 0  then 
					DownloadManager:addDownloadTask(6100 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_otherUI" and tonumber(index) ~= 0  then 
					DownloadManager:addDownloadTask(6200 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_sp_mount" and tonumber(index) ~= 0  then 
					DownloadManager:addDownloadTask(6300 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_sp_wing" and tonumber(index) ~= 0  then 
					DownloadManager:addDownloadTask(6400 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_uiZls" and tonumber(index) ~= 0  then 
					DownloadManager:addDownloadTask(6500 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_cn_otherUI" and tonumber(index) ~= 0  then 
					DownloadManager:addDownloadTask(6600 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				elseif sex == "all_uiYanhua" and tonumber(index) ~= 0  then 
					DownloadManager:addDownloadTask(6700 + tonumber(index),downloadInfo.url,downloadInfo.md5,strExtraData,"downloadCallbackForAll",self)
				end
			else				
				WZLog("DownloadManager:downloadResCheckAll ---- downloaded -> ", sex..'_'..index..'_' .. '#'..md5..'#'..size)
			end
			
    	    element = element:nextSiblingElement(xmlName)
    	end
		local hhh = WZThread:getTickCount()
		CCLog("Pet Time Cost downloadResCheckAll-One-one", hhh - self.m_nTouchBeginTime)
		self.m_nTouchBeginTime = WZThread:getTickCount()
	end
end

--@brief 	检测下载指定资源分段包(多个资源放进一个包里)
--@param typeName 资源种类
--@param taskNum 设置一个任务id前缀
--@param isZeroRes 是否下载资源编号为0的资源
function DownloadManager:downloadResCheckForTypeAll(typeName, taskNum, isZeroRes)
	--检测皮肤boss
	WZLog("DownloadManager:downloadResCheckForTypeAll", typeName, taskNum, isZeroRes)
	--self.m_nTouchBeginTime = WZThread:getTickCount()
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."DressAniDownloadConfig_All.xml"
    local ConfigExist = WZDataFile:getInstance():checkFileExist(path)
	if not self.xmlDoc_all and ConfigExist then
		self.xmlDoc_all = WZDataFile:getInstance():createXmlDocument(path)
		self.xmlDoc_all:retain()
	end
	self.m_nTouchBeginTime = WZThread:getTickCount()
	--记录已下载的更新资源名称缓存，防止重复下载
	local userData = WZDataFile:getInstance():getUserData()
	--下载
	if ConfigExist and userData then
		--没有下载配置文件成功，直接返回
		if not self.xmlDoc_all then return nil end
    	local rootElement = self.xmlDoc_all:getRootElement()
    	local xmlName = "File"
    	local element = rootElement:findChildElement(xmlName)
		while element do
    	    local index = element:attributeString("index")
    	    local sex = element:attributeString("sex")
    	    local md5 = element:attributeString("md5")
    	    local size = element:attributeString("size") or "70"
    	    local downloadCache = userData:getStringValue("DownloadCache_"..ProjConfig.INSTALLVERSION, sex..'_'..index)
			if downloadCache == nil or downloadCache ~= md5 then
				WZLog("DownloadManager:downloadResCheckForTypeAll ---- ", sex, index)
	    	    if sex == typeName and (isZeroRes or (not isZeroRes and tonumber(index) ~= 0)) then
					local downloadInfo = {}
	    	        downloadInfo.url = element:attributeString("url")
	    	        downloadInfo.md5 = element:attributeString("md5")
					DownloadManager:addDownloadTask(taskNum + tonumber(index),downloadInfo.url,downloadInfo.md5,sex..'_'..index..'#'..downloadInfo.md5..'#'..size,"downloadCallbackForAll",self)
					--local hhh = WZThread:getTickCount()
					--WZLog("Pet Time Cost downloadResCheckForTypeAll-Two", hhh - self.m_nTouchBeginTime)
					--return 
				end
			else				
				WZLog("DownloadManager:downloadResCheckForTypeAll ---- downloaded -> ", sex.."_"..index..'#'..md5)
			end
    	    element = element:nextSiblingElement(xmlName)
    	end
	end
end

--@brief 	下载完成回调
function DownloadManager:downloadCallback(taskId, extraData, failed)
	WZLog("DownloadManager:downloadCallback", taskId, extraData, failed)
	
end

--@brief 	下载完成回调
function DownloadManager:downloadCallbackForAll(taskId, extraData, failed)
	WZLog("DownloadManager:downloadCallbackForAll", taskId, extraData, failed)
	if failed == 0 then 
		--下载成功
		if extraData then
			local strs = SplitStringWithSeparator(extraData,"#")
			if strs and #strs > 1 then
				local resName = strs[1]
				local resMd5 = strs[2]
				local resSize = strs[3]
				WZLog("DownloadManager:downloadCallbackForAll-1", resName, resMd5)
				local userData = WZDataFile:getInstance():getUserData()
				if userData then
					userData:setStringValue("DownloadCache_"..ProjConfig.INSTALLVERSION, resName, resMd5)
					userData:flush()
				end
				if self.m_nDownLoadSize == nil then self.m_nDownLoadSize = 0 end
				self.m_nDownLoadSize = self.m_nDownLoadSize + tonumber(resSize)
				--资源成功下载后根据需要刷新对应的UI界面
				if string.find(resName, "all_title_frame") then
					if WndDesignationMain then
						WZLog("DownloadManager:downloadCallbackForAll-2 ---> WndDesignationMain:updateAchieUI()")
						WndDesignationMain:updateAchieUI()
					end
				end
				GlobalGame:getGameEventDispathcer():Dispatch(DownloadEvent.DownloadFinish)
			end
		end
	end
end

--@brief 	获取需要下载的资源的总大小和已经下载的资源大小
function DownloadManager:getTotalResSize()
	--检测皮肤boss
	CCLog("DownloadManager:getTotalResSize")
	if self.m_nTotalSize and self.m_nDownLoadSize then 
		return self.m_nTotalSize, self.m_nDownLoadSize
	end
	--先刷新一次，防止资源下载途中关闭客户端导致的WZFileList.xml未完全刷新
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."DressAniDownloadConfig_All.xml"
    local ConfigExist = WZDataFile:getInstance():checkFileExist(path)
	if not self.xmlDoc_all and ConfigExist then
		self.xmlDoc_all = WZDataFile:getInstance():createXmlDocument(path)
		self.xmlDoc_all:retain()
	end

	--记录已下载的更新资源名称缓存，防止重复下载
	local userData = WZDataFile:getInstance():getUserData()
	--下载称号
	if ConfigExist and userData then
		--没有下载配置文件成功，直接返回
		if self.m_nTotalSize == nil then 
			self.m_nTotalSize = 0 
			self.m_nDownLoadSize = 0
			if self.xmlDoc_all then 
		    	local rootElement = self.xmlDoc_all:getRootElement()
		    	local xmlName = "File"
		    	local element = rootElement:findChildElement(xmlName)
				while element do
		    	    local index = element:attributeString("index")
		    	    local sex = element:attributeString("sex")
		    	    local md5 = element:attributeString("md5")
		    	    local size = element:attributeString("size") or "70"
					local downloadCache = userData:getStringValue("DownloadCache_"..ProjConfig.INSTALLVERSION, sex..'_'..index)
					if downloadCache == nil or downloadCache ~= md5 then
						CCLog("DownloadManager:getTotalResSize ---- ", sex, index, size)
						
					else				
						WZLog("DownloadManager:getTotalResSize ---- downloaded -> ", sex.."_"..index..'#'..md5, size)
						self.m_nDownLoadSize = self.m_nDownLoadSize + tonumber(size)
					end

					self.m_nTotalSize = self.m_nTotalSize + tonumber(size)
					
		    	    element = element:nextSiblingElement(xmlName)
		    	end
			end
		end
	end

	return self.m_nTotalSize, self.m_nDownLoadSize
end