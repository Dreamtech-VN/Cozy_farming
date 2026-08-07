--PrefetchCache.lua
--@brief	客户端预获取缓存，即提前获取缓存数据
--@date		2014/9/10
--@author	刘凑贵
--@note     定义客户端预获取缓存方法

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	判断缓存中是否公会列表数据
--return    true:已有数据，false: 没有数据
function PrefetchCache:hasCommunityList()
	if self.m_tCommunityList == nil then
		return false
	else
		return true
	end
end

--@brief	判断缓存中是否有公会列表数据
--return    true:已有数据，false: 没有数据
function PrefetchCache:hasQualifyList()
	if self.m_tQualifyList == nil then
		return false
	else
		return true
	end
end

--@brief	判断缓存中是否有任务列表数据
--return    true:已有数据，false: 没有数据
function PrefetchCache:hasTaskList()
	if self.m_tTaskList == nil then
		return false
	else
		return true
	end
end

--@brief	判断缓存中是否有大厅房间列表数据
--return    true:已有数据，false: 没有数据
function PrefetchCache:hasHallRoomList()
	if self.m_tHallRoomList == nil then
		return false
	else
		return true
	end
end

--@brief	判断缓存中是否有公告列表数据
--return    true:已有数据，false: 没有数据
function PrefetchCache:hasBulletinList(  )
	if self.m_tNoticeList == nil then
		return false
	else
		return true
	end
end

--@brief	判断缓存中是否有活动列表数据
--return    true:已有数据，false: 没有数据
function PrefetchCache:hasActivityList(  )
	if self.m_tActivityList == nil then
		return false
	else
		return true
	end
end



--@brief	获取公会列表缓存信息
function PrefetchCache:getCommunityList()
	return self.m_tCommunityList
end

--@brief	获取公会列表缓存信息
function PrefetchCache:has(str)
	str = str or ""
	return self[str]
end

--@brief	获取排位赛列表缓存信息
function PrefetchCache:getmQualifyList()
	return self.m_tQualifyList
end

--@brief	获取任务列表缓存信息
function PrefetchCache:getTaskList()
	return self.m_tTaskList
end

--@brief	获取大厅房间列表缓存信息
function PrefetchCache:getHallRoomList()
	return self.m_tHallRoomList
end

--@brief	获取公告缓存信息	--add by wuweidong
function PrefetchCache:getBulletinList()
	return self.m_tNoticeList
end

--@brief	获取活动缓存信息	--add by wuweidong
function PrefetchCache:getActivityList()
	return self.m_tActivityList
end

--@brief 	是否添加分享和邀请任务
--@brief 	m_tTaskData:任务表中该任务的数据
function PrefetchCache:whetherAddShareTask(m_tTaskData)
	-- body
	local bIsAdd = true 
	WZLog("PrefetchCache:whetherAddShareTask",  m_tTaskData.id, m_tTaskData.script[1][1], type(g_loginType))
	if ProjConfig.LANGUAGE == "vn" then
		if m_tTaskData.script[1][1] == 996 or m_tTaskData.script[1][1] == 997 then 
			if g_loginType == nil or g_loginType == "" then
				bIsAdd = false
			elseif g_loginType == "facebook" then
				if m_tTaskData.id ~= 1340000000 and m_tTaskData.id ~= 1350000000 then
					bIsAdd = false
				end
			else
				-- if m_tTaskData.id ~= 1340001024 and m_tTaskData.id ~= 1350001024 then --zalo
				if m_tTaskData.id ~= 1340000000 and m_tTaskData.id ~= 1350000000 then --facebook
					bIsAdd = false
				end
			end
		end
	end

	return bIsAdd 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------































