--*************************
--自定义头像
--hyx
--*************************
WndCustomHead = {}
--
function WndCustomHead:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sImgCustomHead = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCustomHead:_unInit()
	self.m_root = nil
	self.m_sImgCustomHead = nil
end
function WndCustomHead:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()

	self.size = GlobalMethod:CCSize(110,110)
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(110,110))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	
	local clipCon = WZUIClippingContainer:create()
    local subCon = WZUIContainer:create()
    subCon:setUseAbsSize(true)
    subCon:setAbsContentSize(self.size)
    local img1 = WZUIImage:create()
    img1:setFile("ui/common/frame_tx_dadi.png")
    clipCon:setStencil(subCon)
    subCon:addChild(img1)
    element:addChild(clipCon)
    tNewObj.m_sImgCustomHead = WZUIImage:create()
    clipCon:addChild(tNewObj.m_sImgCustomHead)

	return element,tNewObj
end
--[[
headurl: 头像的url
sex: 性别
]]
function WndCustomHead:setHead(headurl, sex)
	sex = sex or 1
	--根据性别设置默认头像
	local imgHead = {"ui/space/common_icon_renxiangnan.png","ui/space/common_icon_renxiangnv.png"}
	self.m_sImgCustomHead:setFile(imgHead[sex+1])
	self.m_sImgCustomHead:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
	self:showPhotoHead(headurl)
end

--显示自定义头像
function WndCustomHead:showPhotoHead(headurl)
	if not headurl or headurl == "" then return end
	local fileName = headurl
	--如果有设置默认头像
	if string.find(fileName, [[http]]) ~= nil then
		local downURL = fileName
		local photoName = WndAdvertising:getFileName(fileName)
		--如果文件存在，不下载，直接使用
		local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..photoName
		local bExist = WZFileUtil:isFileExist(path)
		local platForm =  WZUISystem:getInstance():getPlatformInfo()
		downURL = downURL:gsub("\n","")
		downURL = downURL:gsub("\r","")
		if bExist then
			self.m_sImgCustomHead:setFile(path)
			local size = self.size
			local hh = 110
			local x = hh/size.width 
			local y = hh/size.height
			self.m_sImgCustomHead:setScale(math.min(x,y))
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
	WZLog("WndCustomHead:showPhotoHead 11111", bExist, path, self.m_sImgCustomHead)
	if bExist then
		if self.m_sImgCustomHead then
			self.m_sImgCustomHead:setFile(path)
			local size = self.size
			local hh = 110
			local x = hh/size.width 
			local y = hh/size.height
			self.m_sImgCustomHead:setScale(math.max(x,y))
		end
	else
		local s = {}
		s.filePath = path
		s.objName = fileName
		DSSdkManager:downFile(json.encode(s),self.downloadFileFinish, self)
	end
end
--@brief	http下载回调
function WndCustomHead:httpDownloadFinish(taskId, path, totalSize, nowSize, finish, failed)
	WZLog("WndCustomHead:httpDownloadFinish",taskId,finish,path,failed)
	if taskId ~= CacheCenter:getPlayerInfo().id then
		return
	end
	if finish then
		WZLog("pathxxxxxxxqWWWWWWWWWWWW:::",path, self.m_sImgCustomHead)
		if self.m_sImgCustomHead then
			self.m_sImgCustomHead:setFile(path)
			local size = self.size
			local hh = 110
			local x = hh/size.width 
			local y = hh/size.height
			self.m_sImgCustomHead:setScale(math.min(x,y))
		end
	else
		WZLog("taskId:::::::::::::::::::::::::::::::",taskId)
	end
end
--@brief	下载成功回调
function WndCustomHead:downloadFileFinish(result)
	local result = json.decode(result)
	local fileName = result.objName
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..result.objName
	WZLog("CellCheckOther3:downloadFileFinish 下载完成",path)

	if self.m_sImgCustomHead then
		self.m_sImgCustomHead:setFile(path)
		local size = self.size
		local hh = 110
		local x = hh/size.width 
		local y = hh/size.height
		self.m_sImgCustomHead:setScale(math.max(x,y))
	end
end

function WndCustomHead:setScale(scale)
	scale = scale or 1
	if self.con_element then
		self.con_element:setScale(scale)
	end
end

function WndCustomHead:DeleteMe()
	self.m_root:removeFromParentAndCleanup(true)
end

--@return	新建的表实例对象
function WndCustomHead:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end