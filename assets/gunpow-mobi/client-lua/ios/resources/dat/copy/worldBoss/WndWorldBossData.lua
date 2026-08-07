--WndWorldBossData.lua
--@brief	WndWorldBoss的数据模块
--@date		2015-9-24
--@author	binshao
--@note		世界BOSS窗口模块

WndWorldBoss = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWorldBoss:_init()
	self.m_root = nil	 	  			--场景根节点
    self.openInfo = {}                 -- 开启信息
    self.aniAction = true
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWorldBoss:_unInit()
	self.m_root = nil
    self.openInfo = nil
    self.aniAction = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWorldBoss:createElement()
	local element = WZUISystem:getInstance():createElement("WndWorldBoss")
	assert(element, "WndWorldBoss create element failed!")
	self:_init()
	return element
end

--@brief 	获得房间状态成功
function WndWorldBoss:setRoomOpenState( mapId, state, time )
	WZLog("WndWorldBoss:setRoomOpenState",#mapId)
    self.openInfo = {}
    for i = 1, #mapId do
        self.openInfo[i] = {mapId = mapId[i], state = state[i], time = time[i] }
        WZLog("------------WndWorldBossOpenState----------------",mapId[i],state[i],time[i])
    end
    local function sort(info1,info2)
        return info1.mapId < info2.mapId
    end
    table.sort(self.openInfo, sort)
	self:_initOpenDesc()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------