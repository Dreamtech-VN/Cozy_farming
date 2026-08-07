--WndBossRoomSettingData.lua
--@brief	WndBossRoomSetting的数据模块
--@date		2015/06/23
--@author	xiaoyu_wu
--@note		副本房间设置窗口

WndBossRoomSetting = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBossRoomSetting:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_sRoomName = nil              --房间名字
	self.m_sRoomPass = nil              --房间密码
    self.m_tBack = nil
    self.m_nWinType = 0 				--窗口类型0->组队boss,世界组队boss；1->竞技房间，可设置人数;2->竞技房间，不可设置人数

    self.m_iRoomMap = nil
	self.m_iRoomChannel = nil
	self.m_iMapChannel = nil
	self.m_iBattleMode = nil
	self.m_iStartMode = nil
	self.m_nPlayerNumMode = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBossRoomSetting:_unInit()
	self.m_root = nil
    self.m_sRoomName = nil             
	self.m_sRoomPass = nil
    self.m_tBack = nil
    self.m_nWinType = nil 				--窗口类型

    self.m_iRoomMap = nil
	self.m_iRoomChannel = nil
	self.m_iMapChannel = nil
	self.m_iBattleMode = nil
	self.m_iStartMode = nil
	self.m_nPlayerNumMode = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBossRoomSetting:createElement()
	local element = WZUISystem:getInstance():createElement("WndBossRoomSetting")
	assert(element, "WndBossRoomSetting create element failed!")
	self:_init()
	return element
end

--@brief  初始化boss房间信息
function WndBossRoomSetting:initRoomInfo(roomName,roomPass)
	WZLog("WndBossRoomSetting:initRoomInfo")
	self.m_sRoomPass = roomPass
	self.m_sRoomName = roomName
	self:_updateRoomInfo()
end

--@brief	设置返回按钮点击回调(可置空)
--@param	callback:回调函数引用
--@param	tLuaObj:回调函数所属表对象
--@note		主要用于退出场景时回调
function WndBossRoomSetting:setBackButtonCallback(tLuaObj,callback)
	WZLog("WndBossRoomSetting:setBackButtonCallback")
    self.m_tBack = {}
	self.m_tBack[1] = tLuaObj
	self.m_tBack[2] = callback
end

--@brief 	外部接口
function WndBossRoomSetting:showInterface(nWinType)
	-- body
	local wndSetting = WndBossRoomSetting:createElement()
	if wndSetting then 
		self.m_nWinType = nWinType or 0 
		WindowManager:addWindow(wndSetting, WndBossRoomSetting, true, nil, nil)
	end
end

--@brief  竞技房间信息
function WndBossRoomSetting:initRoomInfo2(mapId, roomName, roomPass, channel, mapChannel, battleMode, startMode, nPlayerNumMode)
	WZLog("WndBossRoomSetting:initRoomInfo2", roomPass)
	self.m_iRoomMap = mapId
	self.m_sRoomPass = roomPass
	self.m_sRoomName = roomName
	self.m_iRoomChannel = channel
	self.m_iMapChannel = mapChannel
	self.m_iBattleMode = battleMode
	self.m_iStartMode = startMode
	self.m_nPlayerNumMode = nPlayerNumMode


	self:_updateRoomInfo()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
