--WndFamilyProtectLogData.lua
--@brief	WndFamilyProtectLog的数据模块
--@date		2018/02/06
--@author	Tianxiang_Xu
--@note		家园偷盗日志

WndFamilyProtectLog = {
	--请不要在这里定义变量
}

CellFamilyProtectLog = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFamilyProtectLog:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tLogData = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFamilyProtectLog:_unInit()
	self.m_root = nil
	self.m_tLogData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFamilyProtectLog:createElement()
	if WndFamilyProtectLog.m_root ~= nil then
		WindowManager:removeWindow(WndFamilyProtectLog.m_root, WndFamilyProtectLog, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFamilyProtectLog")
	assert(element, "WndFamilyProtectLog create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndFamilyProtectLog:showInterface()
	-- body
	local wndLog = WndFamilyProtectLog:createElement()
	if wndLog then
		WindowManager:addWindow(wndLog, WndFamilyProtectLog, nil, nil, nil, true)
	end
end


--@brief 	设置日志数据
function WndFamilyProtectLog:setLogData(logType, time, playerId, playerName, petName, guardromonId, hurt, defend)
	-- body
	SceneFamily:_stopLoading()

	self.m_tLogData = {}
	local nCurServerTime = SystemTime:getServerTime()
	for i = 1, #playerId do
		local tItem = {}
		tItem.playerId = playerId[i]
		tItem.time = nCurServerTime - time[i]
		tItem.type = logType[i]
		tItem.playerName = playerName[i]

		tItem.petName = petName[i]
		tItem.protectItemId = guardromonId[i]
		tItem.hurt = hurt[i]
		tItem.defend = defend[i]

		table.insert(self.m_tLogData, tItem)
	end
	table.sort(self.m_tLogData, function (a,b)
		-- body
		return a.time < b.time 
	end)

	WZLog("WndFamilyProtectLog:setLogData", Serialize(self.m_tLogData))
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
function CellFamilyProtectLog:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFamilyProtectLog table create failed!")

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(480,80))
	element:setName("__CellFamilyProtectLog")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellFamilyProtectLog:setData(tData)
	-- body
	self.m_tData = tData 
end

--@brief 	返回时间端
function CellFamilyProtectLog:rtnTimeString()
	if not self.m_tData then return end
	
	-- body
	if self.m_tData.time < 60 then
		return LocalStrings.JUST_NOW
	elseif self.m_tData.time < 3600 then
		return string.format(LocalStrings.MINUTE_BEFORE, math.floor(self.m_tData.time/60))
	elseif self.m_tData.time < 24 * 3600 then
		return string.format(LocalStrings.HOUR_BEFORE, math.floor(self.m_tData.time/3600))
	elseif self.m_tData.time < 7 * 24 * 3600 then
		return string.format(LocalStrings.DAY_BEFORE, math.floor(self.m_tData.time/3600/24))
	else
		return string.format(LocalStrings.WEEK_BEFORE, 1)
	end
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFamilyProtectLog:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end