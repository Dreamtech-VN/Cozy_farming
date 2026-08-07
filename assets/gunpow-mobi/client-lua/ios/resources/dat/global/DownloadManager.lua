--下载管理器
DownloadManager =
{
	m_tDownloadObservers == {},
    downloading_list = {}, 			--下载列表
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
function DownloadManager:_updateDownloadFinish(taskId)
	WZLog("DownloadManager:_updateDownloadFinish", #self.m_tDownloadObservers)
	if self.m_tDownloadObservers ~= nil then
		for k,v in pairs(self.m_tDownloadObservers) do
			WZLog("DownloadManager:_updateDownloadFinish_1", #self.m_tDownloadObservers, k, v.taskId, v.funName)
			local t = v.tTable
			local funName = v.funName
			if v.taskId == taskId then
				--更新显示
				if t[funName] ~= nil then
					WZLog("DownloadManager:_updateDownloadFinish_2", v.taskId, funName)
					t[funName](t, nil, nil, 0)
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
    	WZUISystem:getInstance():getMultiThreadSystem():addDownloadTask(task);
	end
end

function DownloadManager:downloadFinish(taskId, extraData, failed)
	WZLog("DownloadManager:downloadFinish", taskId, extraData, failed)
    if failed == 0 then 
		--下载成功
        WZUpdateManager:getInstance():forceGenUpdateDirFileList()
		local tData = self.downloading_list[tostring(taskId)]
		self:_updateDownloadFinish(tData.taskId)
		self.downloading_list[tostring(taskId)] = nil
	else
		self.downloading_list[tostring(taskId)] = nil
    end
end
