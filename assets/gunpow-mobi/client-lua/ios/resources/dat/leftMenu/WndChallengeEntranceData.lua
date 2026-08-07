--WndChallengeEntranceData.lua
--@brief	WndChallengeEntrance的数据模块
--@date		2016/12/26
--@author	Tianxiang_Xu
--@note		爬塔和世界BOSS的入口

WndChallengeEntrance = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndChallengeEntrance:_init()
	self.m_root = nil	 	  			--场景根节点
    self.openInfo = {}                 -- 开启信息
    self.m_nLoadingId = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndChallengeEntrance:_unInit()
	self.m_root = nil
    self.openInfo = nil                 -- 开启信息
    self.m_nLoadingId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndChallengeEntrance:createElement()
	local element = WZUISystem:getInstance():createElement("WndChallengeEntrance")
	assert(element, "WndChallengeEntrance create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function WndChallengeEntrance:showInterface()
    -- body
    if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    end

    local wndChallenge = WndChallengeEntrance:createElement()
    if wndChallenge then
        WindowManager:addWindow(wndChallenge, WndChallengeEntrance,nil,nil,nil,true)
    end
end

--@brief    获得房间状态成功
function WndChallengeEntrance:setRoomOpenState( mapId, state, time, overTime )
    WZLog("WndChallengeEntrance:setRoomOpenState",#mapId)
    self.openInfo = {}
    for i = 1, #mapId do
        self.openInfo[i] = {mapId = mapId[i], state = state[i], time = time[i], overTime = overTime[i] }
        WZLog("------------WndChallengeEntrance OpenState----------------",mapId[i],state[i],time[i],overTime[i])
    end
    local function sort(info1,info2)
        return info1.mapId < info2.mapId
    end
    table.sort(self.openInfo, sort)
    self:_initOpenDesc()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 创建加载框
function WndChallengeEntrance:createLoading()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox(10)
end

-- 关闭加载框
function WndChallengeEntrance:closeLoading()
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end




-------------------------------------私有方法模块End----------------------------------------
