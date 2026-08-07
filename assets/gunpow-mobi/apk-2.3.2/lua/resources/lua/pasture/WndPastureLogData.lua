--WndPastureLogData.lua
--@brief	WndPastureLog的数据模块
--@date		2021/04/17
--@author	hyx
--@note		牧场日记

WndPastureLog = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPastureLog:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPastureLog:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPastureLog:createElement()
	if WndPastureLog.m_root ~= nil then
		WindowManager:removeWindow(WndPastureLog.m_root, WndPastureLog, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPastureLog")
	assert(element, "WndPastureLog create element failed!")
	self:_init()
	return element
end
function WndPastureLog:setCellLogData(optType,operateTime,operatorName,mountsLevel,mountsId)
	local data= {}
	for i=1,#optType do
		local tab = {}
		tab._type = optType[i]
		tab.time = operateTime[i]
		tab.name = operatorName[i]
		tab.level = mountsLevel[i]
		tab.mount_name = ""
		local info = GDatatab_pasture_mounts["id_"..mountsId[i]]
		if info then
			tab.mount_name = info.name
		end
		data[i] = tab
	end
	return data
end

--==============日记子项===================
PastureLogItem = {}
function PastureLogItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function PastureLogItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function PastureLogItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(720,30))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function PastureLogItem:setLogsData(data)
	self.m_tLogData = data
end

--@brief 	开始加载
function PastureLogItem:onLoadData(element)
	if not self.m_tLogData then return end

	local data = self.m_tLogData

	local log_str = WZUIFreeTextBox:create()
    log_str:setMaxWidth(700)
    log_str:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
    log_str:setRelativePosition(GlobalMethod:ccp(0, 0.5))
    self.m_root:addChild(log_str)
    
    local hour = math.floor(data.time / 3600)
    local temp_str = LocalStrings.PASTURE_TEXT44
    local time_str = LocalStrings.PASTURE_TEXT42
    if data._type == 2 then
    	temp_str = LocalStrings.PASTURE_TEXT45
    end
    if hour <= 0 then
		hour = math.floor((data.time % 3600) / 60)
		time_str = LocalStrings.PASTURE_TEXT43
	else
		if hour > 24 and hour <= 720 then
			hour = math.floor(hour / 24)
			time_str = LocalStrings.PASTURE_TEXT60
		elseif hour > 720 then
			hour = math.ceil(hour / 720)
			time_str = LocalStrings.PASTURE_TEXT61
		end
	end
    if data.level <= 0 then
    	log_str:setShowText(string.format(LocalStrings.PASTURE_TEXT55, hour, time_str, data.name))
    else
	    log_str:setShowText(string.format(temp_str, hour, time_str, data.name, data.level, data.mount_name))
	end
end

--@return	新建的表实例对象
function PastureLogItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
