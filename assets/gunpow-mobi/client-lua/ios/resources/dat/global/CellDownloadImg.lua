--CellDownloadImg.lua
--@brief	CellDownloadImg的UI模块
--@date		2016/06/21
--@author	zsq
--@note		下载图片的容器


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDownloadImg:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDownloadImg:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellDownloadImg:setFile(file)
	if self.m_root == nil then return end
	if file == nil then return end
	WZLog("CellDownloadImg:setFile")
	GetElement(self.m_root,"img_CellDownloadImg",WZUIImage):setFile(file)
end

function CellDownloadImg:getContentSize()
	if self.m_root == nil then 
		return GlobalMethod:CCSize(1,1) 
	end
	return GetElement(self.m_root,"img_CellDownloadImg",WZUIImage):getContentSize()
end

function CellDownloadImg:setScale(scale)
	if self.m_root == nil then return end
	if scale == nil then return end
	GetElement(self.m_root,"img_CellDownloadImg",WZUIImage):setScale(scale)
end

--@brief	下载成功回调
function CellDownloadImg:downloadFileFinish(result)
	WZLog("CellDownloadImg:downloadFileFinish",result)
	if tDownloadFileList == nil or #tDownloadFileList == 0 then return end
	local result = json.decode(result)
	local fileName = result.objName
	--如果下载失败，把任务清出队列，返回
	WZLog("下载结果",result["return"])
	if result["return"] == "fail" then
		for i=1,#tDownloadFileList do
			if tDownloadFileList[i].status == "downloading" then
				table.remove(tDownloadFileList,i)
				return
			end
		end
	end 
	if fileName == nil then return end
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..result.objName
	WZLog("下载完成",path)

	for i=1,#tDownloadFileList do
		WZLog(i,tDownloadFileList[i],tDownloadFileList[i].fileName,fileName)
		if tDownloadFileList[i].fileName == fileName and tDownloadFileList[i].status == "downloading" then
			local x,y
			if tDownloadFileList[i].tCell ~= nil then
				local imgPhoto = tDownloadFileList[i].tCell
				imgPhoto:setFile(path)
				local size = imgPhoto:getContentSize()
				local hh = 100
				if tDownloadFileList[i].size ~= nil then hh = tDownloadFileList[i].size end
				x = hh/size.width 
				y = hh/size.height
				imgPhoto:setScale(math.max(x,y))
			end
			--一次只下载一个文件,从列表中找到即可返回
			table.remove(tDownloadFileList,i)
			return
		end
	end
	downloadFile()
end
-------------------------------------私有方法模块End----------------------------------------
