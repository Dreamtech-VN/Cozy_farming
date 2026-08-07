--WndPvpRankResultData.lua
--@brief	WndPvpRankResult的数据模块
--@date		2015-12-10
--@note		排位赛结算

WndPvpRankResult = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPvpRankResult:_init()
	self.m_root = nil	 	  			--场景根节点
    self.data = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPvpRankResult:_unInit()
	self.m_root = nil
    self.data = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPvpRankResult:createElement()
	local element = WZUISystem:getInstance():createElement("WndPvpRankResult")
	assert(element, "WndPvpRankResult create element failed!")
	self:_init()
	return element
end

function WndPvpRankResult:setData(data)
    self.data = {}
    for i = 1, #data do
        if data[i].playerId == CacheCenter:getPlayerInfo().id then
            table.insert(self.data,1,data[i])
        else
            table.insert(self.data,data[i])
        end
    end
    self:_update()
end

function WndPvpRankResult:judgeWinOrLose()
    local data = self.data
    for i = 1, #data do
        if data[i].playerId == CacheCenter:getPlayerInfo().id and data[i].result == 1 then
            return true
        end
    end
    return false
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------