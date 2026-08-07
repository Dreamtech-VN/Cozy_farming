--WndPvpRankLogData.lua
--@brief	WndPvpRankLog的数据模块
--@date		2015-11-13
--@author	binshao
--@note		排位赛战绩日志

WndPvpRankLog = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPvpRankLog:_init()
	self.m_root = nil	 	  			--场景根节点
    self.data = nil                  --数据表，日志列表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPvpRankLog:_unInit()
	self.m_root = nil
    self.data = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPvpRankLog:createElement()
	local element = WZUISystem:getInstance():createElement("WndPvpRankLog")
	assert(element, "WndPvpRankLog create element failed!")
	self:_init()
	return element
end

--@brief    显示窗口
function WndPvpRankLog:showWindow()
    local wnd = self:createElement()
    WindowManager:addWindow(wnd, self)
end

-- 设置日志数据
function WndPvpRankLog:setData(data)
    WZLog("-------------setData--------------",#data.logType)
    self.data = {}
    for i = 1, #data.logType do
        local info = {logType = data.logType[i], createDate = data.createDate[i], score = data.score[i], segmentLevel = data.segmentLevel[i], opponentName = data.opponentName[i] }
        table.insert(self.data,info)
    end
    local function sort(d1,d2)
        return d1.createDate < d2.createDate
    end
    table.sort(self.data,sort)

    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------
