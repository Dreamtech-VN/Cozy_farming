--WndRoomSettingData.lua
--@brief	WndRoomSetting的数据模块
--@date		2015/06/03
--@author	qixiang_xie
--@note		竞技房间设置

WndRoomSetting = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRoomSetting:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sRoomName = nil              --房间名字
	self.m_sRoomPass = nil              --房间密码
	self.m_iRoomMap = nil               --房间地图ID
	self.m_iRoomChannel = nil           --房间频道类型
	self.m_iMapChannel = nil 
	self.m_fImageMap = nil
	self.m_tBack = nil
	self.m_tSelectMap = nil
	self.m_iBattleMode = nil
	self.m_iStartMode = nil
	self.m_tDefaultCell = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRoomSetting:_unInit()
	self.m_root = nil
	self.m_sRoomName = nil             
	self.m_sRoomPass = nil
	self.m_iRoomMap = nil
	self.m_iRoomChannel = nil 
	self.m_fImageMap = nil
	self.m_tBack = nil
	self.m_tSelectMap = nil
	self.m_iMapChannel = nil 
	self.m_iBattleMode = nil
	self.m_iStartMode = nil
	self.m_tDefaultCell = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRoomSetting:createElement()
	local element = WZUISystem:getInstance():createElement("WndRoomSetting")
	assert(element, "WndRoomSetting create element failed!")
	self:_init()
	return element
end

--@brief  初始化房间信息
function WndRoomSetting:initRooInfo(mapId,roomName,roomPass,channel,mapChannel,battleMode,startMode)
	WZLog("WndRoomSetting:initRooInfo")
	self.m_iRoomMap = mapId
	self.m_sRoomPass = roomPass
	self.m_sRoomName = roomName
	self.m_iRoomChannel = channel
	self.m_iMapChannel = mapChannel
	self.m_iBattleMode = battleMode
	self.m_iStartMode = startMode
	self:updateRoomInfo()
end


--@brief	设置返回按钮点击回调(可置空)
--@param	callback:回调函数引用
--@param	tLuaObj:回调函数所属表对象
--@note		主要用于退出场景时回调
function WndRoomSetting:setBackButtonCallback(tLuaObj,callback)
	WZLog("WndRoomSetting:setBackButtonCallback")
    self.m_tBack = {}
	self.m_tBack[1] = tLuaObj
	self.m_tBack[2] = callback
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
