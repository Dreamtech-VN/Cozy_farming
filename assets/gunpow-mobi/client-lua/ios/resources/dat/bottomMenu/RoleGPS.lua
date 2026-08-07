--RoleGPS.lua
--@brief	设置SDK管理
--@date		2014/03/25
--@author	liangguang_long
--@note		

RoleGPS = {
	Longitude  = nil, 		--经度
	Latitude = nil,			--纬度
	BackFun = nil ,			--回调函数列表
	SendOne = nil,			--发一次
}

-------------------------------------公有方法模块Begin--------------------------------------

-------------------------------------公有方法模块End----------------------------------------

--@brief	初始化数据
function RoleGPS:init()
	RoleGPS.Longitude  = nil 		--经度
	RoleGPS.Latitude = nil 			--纬度
	RoleGPS.SendOne = true
end

--@brief	打开GPS
function RoleGPS:openGPS()
	WZLog("RoleGPS:openGPS():",GlobalGame.g_tSysConfig.openGPS)
	if GlobalGame.g_tSysConfig.openGPS == true then
		self:init()
		WZLocation:getInstance():getCoordinate()
		local result = WZLocation:getInstance():getCurrentCoordinate()
		WZLog("result:",result)
		if result ==  nil then
			return
		end
		self:onGPSBackFun(json.decode(result))
		return json.decode(result)
	end
end

--@brief	GPS回调函数
function RoleGPS:onGPSBackFun(result)
	WZLog("GPS回调函数RoleGPS:onGPSBackFun",result)
	if result == nil then
		return
	end
	for i,data in pairs(result) do 
		WZLog("i:data:result:",i,data,type(i),type(data))
		if tostring(data) == "false" then
			return
		elseif tostring(i) == "Longitude" then
			RoleGPS.Longitude = data
		elseif tostring(i) == "Latitude" then
			RoleGPS.Latitude = data
		end
	end
	if RoleGPS.SendOne == true then
		RoleGPS.SendOne = false
		RoleGPS:sendPostion()--发送位置
	end
end

--@brief	检查GPS状态
function RoleGPS:checkGPS()
	WZLog("RoleGPS:checkGPS::",GlobalGame.g_tSysConfig.openGPS,RoleGPS:statusGPS())
	if GlobalGame.g_tSysConfig.openGPS == true then
		if self:statusGPS() == true then
			local result = WZLocation:getInstance():getCurrentCoordinate()
			WZLog("result:",result)
			if result ==  nil then
				return
			end
			self:onGPSBackFun(json.decode(result))
		else
			RoleGPS:openGPS()--打开GPS
		end
	end
end

--@brief	关闭GPS
function RoleGPS:closeGPS()
	WZLog("RoleGPS:closeGPS::",self:statusGPS())
	if self:statusGPS() == true then	
		WZLocation:getInstance():stopLocation()
		RoleGPS.SendOne = nil 
	end
end

--@brief	GPS状态
function RoleGPS:statusGPS()
	return WZLocation:getInstance():isRunning()
end

--@brief	设置回调函数
function RoleGPS:setBackFun(tCell,backFun)
	RoleGPS.BackFun = {}
	table.insert(RoleGPS.BackFun,tCell)
	table.insert(RoleGPS.BackFun,backFun)
end

--@brief	获取角色的位置
--@return	返回经纬度
function RoleGPS:getRolePos()
	return RoleGPS.Longitude,RoleGPS.Latitude
end

--@brief	发送位置
function RoleGPS:sendPostion()
	--返回经纬度
	local longitude,latitude = RoleGPS:getRolePos()
	if longitude then
		WZLog("发送位置:::RoleGPS:sendPostion:::",longitude,latitude)
		local c = 1000000
		longitude = longitude*c
		latitude = latitude*c
		ProtocolProcessorAccount:send_NEARBY_UpdatePlayerLocationInfo(longitude, latitude )
	end
end

-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------







