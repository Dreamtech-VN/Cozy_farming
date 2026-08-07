--RolePhoto.lua
--@brief	设置SDK管理
--@date		2014/03/25
--@author	liangguang_long
--@note		

RolePhoto = {
	FileUrl = nil ,				--图片网络路径
	file = nil, 				--当前图片路径
	tag = nil ,					--图片tag
	sDelPhoto = nil ,
	m_nLoadingId = nil,
	suffix = nil,
	nIndex = 1,
	tOpenBackFun = nil,	--打开图片回调函数
	tStartUpload = nil,--开始上传回调
	tSuccdUpload = nil,--下载成功回调
	tFailUpload = nil,--下载成功回调
	bAdd = nil,		--添加图片
}

-------------------------------------公有方法模块Begin--------------------------------------

-------------------------------------公有方法模块End----------------------------------------

--@brief	打开图片
function RolePhoto:openPhoto(tag,pIndex,sDelPhoto,bAddPhoto)
	WZLog("打开图片tag::",tag,pIndex)
	WZLog("sDelPhoto:",bAddPhoto,":",sDelPhoto)
	local deviceHelper = WZDeviceHelper:sharedDeviceHelper()
	pIndex = pIndex or 1
	deviceHelper:setPickerIndex(pIndex)
	deviceHelper:imageCropper(RolePhoto.onPhotoBackFun , RolePhoto)
	RolePhoto.tag = tag
	RolePhoto.FileUrl = nil 
	RolePhoto.sDelPhoto = sDelPhoto
	RolePhoto.bAdd = bAddPhoto
end

--@brief	打开图片回调函数
function RolePhoto:onPhotoBackFun(file)
    local tCell = self
	WZLog("file::::::::",WZFileUtil:getFileSize(file),math.floor(WZFileUtil:getFileSize(file)/1000000) )
	--文件路径
	if WZFileUtil:isFullPathExist(file) == false then
        CCLuaLog("------upload file not exist!")
        return
    end
	if math.floor(WZFileUtil:getFileSize(file)/1000000) > 5 then
		WZLog("文件大于1M:::")
		return
	end
	--取文件的后缀名
	RolePhoto.file = file
    RolePhoto.suffix = self:pathToSuffix(file)
    CCLuaLog("suffix:"..RolePhoto.suffix)
	
    local PId = tonumber(RolePhoto:getPid())
	WZLog("PId::::::",PId)
	local AppId = tostring(RolePhoto:getAppID())
	WZLog("AppId::::::",AppId)
	local url = ProjConfig.PHONESERVERURL
	--local url = "http://175.41.140.148:8089/upload/upload.action?appId=%s&pId=%d&imgFormat=%s&fileUrl=%s"
	local uploadPath = string.format(url,AppId,PId,RolePhoto.suffix,"")
	WZLog("url::",uploadPath)
	if RolePhoto.tOpenBackFun then
		RolePhoto.tOpenBackFun[2](RolePhoto.tOpenBackFun[1],file,uploadPath,RolePhoto.tag)
		RolePhoto.tOpenBackFun = nil 
	end
	RolePhoto:uploadPhoto(file,uploadPath)
end

--获取渠道号ID
function RolePhoto:getPid()
	return PassportSdkManager:getChannelId() --pid
end

--获取应用ID
function RolePhoto:getAppID()
	return WGameCmUtil:GetBundleIdentifier()
end

function RolePhoto:pathToSuffix(path)
	local plen= string.len(path)
    for i=plen,1,-1 do
        if string.sub(path,i,i)=='.' then
            return string.sub(path,i)
        end
    end
    return path
end

--@biref 创建上传
--@param sfilePath:文件本地路径
--@param sDest:上传目标路径（如：http://aaa/bb/c.png  必须以http://开头）
function RolePhoto:uploadPhoto(file,uploadPath)
	--删除已经存在的图片
	WZLog("删除已经存在的图片::",RolePhoto.sDelPhoto)
	if RolePhoto.sDelPhoto and RolePhoto.sDelPhoto ~= "" then		
		WZFileUtil:removeFile(RolePhoto:checkFileName(RolePhoto.sDelPhoto))
		RolePhoto.sDelPhoto = nil
	end
	--开始上传图片
	if RolePhoto.tStartUpload then--设置开始上传回调函数
		RolePhoto.tStartUpload[2](RolePhoto.tStartUpload[1],true,RolePhoto.tag)
		RolePhoto.tStartUpload = nil 
	end
    local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
    local task = WZHTTPUpLoadLuaTask:create(RolePhoto.tag, uploadPath, file, RolePhoto.uploadBackFun, RolePhoto)
    mulThreadSystem:addDownloadTask(task)
end

--@brief 上传回调函数
--@param taskId:任务id，由于只有一个上传任务，这里为0
--@param totalSize:文件大小
--@param nowSize:当前已上传大小
--@param finish:是否成功
--@param successPath:上传成功后返回的文件保存的网络地址
function RolePhoto:uploadBackFun(taskId, totalSize, nowSize, finish,successWebPath)
	WZLog("uploadPhoto begin::::::::::::::::::::::",RolePhoto.tag)
	WZLog("RolePhoto:uploadBackFun()",RolePhoto.file)
	CCLuaLog("-------------fileUploadCallBack-----------------------")
    CCLuaLog("totalSize:"..tostring(totalSize))
    CCLuaLog("nowSize:"..tostring(nowSize))
    CCLuaLog("finish:"..tostring(finish))
	if finish == false then
        --失败
        CCLuaLog("fileUpload failed!")
		RolePhoto.FileUrl = nil 
		MsgBoxManager:showTipBox( LocalStrings.UPPHOTOFAIL )
		if RolePhoto.tFailUpload then
			RolePhoto.tFailUpload[2](RolePhoto.tFailUpload[1],RolePhoto.tag)
			RolePhoto.tFailUpload = nil 
		end
	elseif finish == true and nowSize >= totalSize then
         --上传完成
        CCLuaLog("fileUpload success!")
        CCLuaLog("successWebPath:"..tostring(successWebPath))
		successWebPath = successWebPath:gsub("\n","")
		successWebPath = successWebPath:gsub("\r","")
		 CCLuaLog("successWebPath1:"..tostring(successWebPath))
		if string.find(successWebPath,"<") == nil then
			RolePhoto.FileUrl = tostring(successWebPath)
			if RolePhoto.tSuccdUpload then--成功下载回调函数
				RolePhoto.tSuccdUpload[2](RolePhoto.tSuccdUpload[1],RolePhoto.tag,tostring(RolePhoto.file),tostring(successWebPath),RolePhoto.bAdd)
				RolePhoto.tSuccdUpload = nil 
			end
		end
		
    end
	RolePhoto.sDelPhoto = nil
	RolePhoto.suffix = nil
    CCLuaLog("-------------fileUploadCallBack-----------------------")
end

--@brief 获取图片网络地址
function RolePhoto:getPhotoAddress()
	return RolePhoto.FileUrl
end

--@brief 设置图片网络地址
function RolePhoto:setPhotoAddress(file)
	RolePhoto.FileUrl = file
end

--@brief 	lua对象转换为json格式
--@param 	luaOjbect:lua对象
--@return 	#1:json字符串
function RolePhoto:tableTojson(tData)
    return json.encode(tData)
end

--@brief 	json格式转换为lua对象
--@param 	sJson:json字符串
--@return 	#1:lua对象
function RolePhoto:jsonToTable(sString)
    return json.decode(tostring(sString))
end

--@brief	设置打开回调函数
function RolePhoto:setOpenBackFun(tCell,backFun)
	if tCell and backFun then
		RolePhoto.tOpenBackFun = {}
		table.insert(RolePhoto.tOpenBackFun,tCell)
		table.insert(RolePhoto.tOpenBackFun,backFun)
	end
end

--@brief	设置开始上传回调函数
function RolePhoto:setStartUploadingBackFun(tCell,backFun)
	if tCell and backFun then
		RolePhoto.tStartUpload = {}
		table.insert(RolePhoto.tStartUpload,tCell)
		table.insert(RolePhoto.tStartUpload,backFun)
	end
end

--@brief	成功下载回调函数
function RolePhoto:setSuccUploadBackFun(tCell,backFun)
	if tCell and backFun then
		RolePhoto.tSuccdUpload = {}
		table.insert(RolePhoto.tSuccdUpload,tCell)
		table.insert(RolePhoto.tSuccdUpload,backFun)
	end
end

--@brief	失败下载回调函数
function RolePhoto:setFailUploadBackFun(tCell,backFun)
	if tCell and backFun then
		RolePhoto.tFailUpload = {}
		table.insert(RolePhoto.tFailUpload,tCell)
		table.insert(RolePhoto.tFailUpload,backFun)
	end
end

-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	创建上传文件
function RolePhoto:_createUpFile(file)
	local pFile = WZFile:new_local()
	local fileName = CCFileUtils:sharedFileUtils():getWritablePath() .. "downFile.conf"
	local bExist = WZFileUtil:isFileExist(fileName)
	local bResult = false
	if bExist == false then
		bResult = pFile:OpenWriter(fileName)
	end
	file = file or ""
	local pFile = WZFile:new_local()
	local fileLen = string.len(file)
	bResult = pFile:Write(file,fileLen)
	pFile:CloseWriter()
end

--@brief 	打开上传文件,获取文件内容
function RolePhoto:_openUpFile()
	local fileName = CCFileUtils:sharedFileUtils():getWritablePath() .. "downFile.conf"
	local bExist = WZFileUtil:isFileExist(fileName)
	if bExist == false then
		self:_createUpFile()
	end
	local file = WZFileUtil:getFileContent(fileName)
	return file
end

--@brief 	写入文件
function RolePhoto:_writeFile(file)
	local fileName = CCFileUtils:sharedFileUtils():getWritablePath() .. "downFile.conf"
	local pFile = WZFile:new_local()
	local bResult = pFile:OpenWriter(fileName,false)
	if bResult then
        local iLength = string.len(file)
        print("file::Length:: ",file,iLength)
        bResult = pFile:Write(file,iLength)
        print("Write Result: " .. tostring(bResult))
    end
    pFile:CloseWriter()
end

--@brief 	检查上传路径，用于删除图片
function RolePhoto:_checkUpFile(file)
	WZLog("上传图片路径:::file::",file)
	local temp = "="
	local tempLen = string.len(temp)
	local pos = string.find(file,temp)
	if pos then
		file = string.sub(file,pos+tempLen+1)
	end
	WZLog("删除上传图片路径:::file::",file)
	return file
end



--@brief   转换下载图片路径为图片名称
function RolePhoto:checkFileName(fileName)
	if fileName == nil or fileName == "" then
		return
	end
	fileName = RolePhoto:changeName(fileName)
	WZLog("end:::7:::",fileName)
	return fileName
end

--@brief	检查图片是否存在
function RolePhoto:checkIconExsit(fileName)
	WZLog("检查图片是否存在",fileName)
	return WZFileUtil:isFileExist(fileName)
end

function RolePhoto:changeName(fileName)
	local plen= string.len(fileName)
    for i=plen,1,-1 do
        if string.sub(fileName,i,i)=='/' then
          return string.sub(fileName,i+1)
        end
    end
	return fileName
end

--@brief   创建加载框
function RolePhoto:createLoading()
	RolePhoto.m_nLoadingId = MsgBoxManager:showLoadingBox(40)
end

--@brief   关闭加载框
function RolePhoto:closeLoading()
	local nId = RolePhoto.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId(nId)
end
-------------------------------------私有方法模块End----------------------------------------





