--SceneTempServerListData.lua
--@brief	SceneTempServerList的数据模块
--@date		2013/12/12
--@author	SuYuan
--@note		方便测试的临时服务器选择界面

SceneTempServerList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneTempServerList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tServer = nil 
	self.m_sServerId = nil
	self.m_sServerName = nil
	self.FontListName = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneTempServerList:_unInit()
	self.m_root = nil
	self.m_tServer = nil 
	self.m_sServerId = nil
	self.m_sServerName = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneTempServerList:createElement()
	local element = WZUISystem:getInstance():createElement("SceneTempServerList")
	assert(element, "SceneTempServerList create element failed!")
	self:_init()
	return element
end

function SceneTempServerList:openFileData()
	local fileName = self:getFileName()
	local bExist = WZFileUtil:isFileExist(fileName)
	if bExist == false or WZFileUtil:getFileContent(fileName) == "" then
		self.m_tServer = self:getServerData()
	else
		local file = WZFileUtil:getFileContent(fileName)
		WZLog("file::a:::",file)
		self.m_tServer = json.decode(file)
		WZLog("self.m_tServer:",self.m_tServer)
	end
	self:_update()
end

function SceneTempServerList:getServerData()
	local tServer = {}
	local temp = {}
	temp.id = "ayx.dandandao.com:8088"
	temp.name = "爱游戏审核服"
	table.insert(tServer,temp)
	
	local temp = {}
	temp.id = "42.121.16.236:7101"
	temp.name = "2.2测试服"
	table.insert(tServer,temp)
	
	local temp = {}
	temp.id = "192.168.1.110:6887"
	temp.name = "国求测试服"
	table.insert(tServer,temp)
	
	local temp = {}
	temp.id = "192.168.1.216:6887"
	temp.name = "超哥测试服"
	table.insert(tServer,temp)
	
	local temp = {}
	temp.id = "42.121.16.236:7201"
	temp.name = "2.3测试服"
	table.insert(tServer,temp)
	
	local temp = {}
	temp.id = "192.168.1.11:7101"
	temp.name = "2.0.2测试服"
	table.insert(tServer,temp)
	
	local temp = {}
	temp.id = "192.168.1.188:6887"
	temp.name = "IOS字体测试"
	table.insert(tServer,temp)
	
	local temp = {}
	temp.id = "192.168.1.119:6887"
	temp.name = "谢健测试服"
	table.insert(tServer,temp)

    local temp = {}
    --ddtemp.id = "42.121.16.236:6227"
    --temp.id = "192.168.1.119:6887"
    temp.id = ProjConfig.IPD_DDR
    temp.name = "15期测试服"
    table.insert(tServer,temp)

	self:saveServerFile(json.encode(tServer))
	return tServer
end

function SceneTempServerList:saveServerFile(file)
	local fileName = self:getFileName()
	WZFileUtil:removeFile(fileName)--先删除文件再写入
	local pFile = WZFile:new_local()
	--local bExist = WZFileUtil:isFileExist(fileName)
	local bResult = pFile:OpenWriter(fileName,false)
	file = file or ""
	WZLog("file::save:",file)
	local fileLen = string.len(file)
	bResult = pFile:Write(file,fileLen,true)
	pFile:CloseWriter()
end

function SceneTempServerList:getFileName()
	local fileName = CCFileUtils:sharedFileUtils():getWritablePath() .. "serverName.conf"
	if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID then
		--fileName = "/storage/sdcard1/Android/data/com.wyd.dandandao.egame/files/serverName.conf"
	end
	return fileName
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
