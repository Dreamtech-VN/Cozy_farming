-- WndCompeteTask
-- @brief: 公会战目标数据模块
-- @date: 2017-02-23 10:52:47
-- @author: zhenwei_jian
-- @note:目标列表

local WndCompeteTask = {}

-- typeId : 类型（1为参与工会战，2为参与工会战并胜利，3为工会战击杀数）
-- num : 该类型完成数量
-- taskId : 正在进行的任务Id
local mParamsList = {
	"nTypeId",
	"nNum",
	"nTaskId",
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCompeteTask:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCellList 	= {}--cell列表
	self.m_tDataIdMap 	= {}--ID对应配置表数据
	self.m_tDataList  	= {}--列表数据

	local tConfigTab = QuickCopyTable(GDatatab_guild_war_task)
	for k, config in pairs(tConfigTab) do
		self.m_tDataIdMap[tonumber(config.id)] = config
	end

end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCompeteTask:_unInit()
	self.m_root = nil
	self.m_tCellList = nil
	self.m_tDataIdMap  = nil
	self.m_tDataList = nil
	for i, k in ipairs(mParamsList) do
		self[k] = nil
	end
end


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCompeteTask:createElement()
	local element = WZUISystem:getInstance():createElement("WndCompeteTask")
	assert(element, "WndCompeteTask create element failed!")
	self:_init()
	return element
end

-- @brief 服务端消息回调后设置数据
-- nTypeId : 类型（1为参与工会战，2为参与工会战并胜利，3为工会战击杀数）
-- nNum : 该类型完成数量
-- nTaskId : 正在进行的任务Id
function WndCompeteTask:setData(...)
	for i, val in ipairs({...}) do
		local key = mParamsList[i]
		self[key] = val
	end

	if nil == self.nTaskId or nil == self.nNum or nil == self.nTypeId then
		return
	end

	local _typeNumMap = {}
	for i, theType in ipairs(self.nTypeId) do
		_typeNumMap[theType] = self.nNum[i]
	end

	self.m_tDataList = {}
	for i, id in ipairs(self.nTaskId) do
		local config = self.m_tDataIdMap[tonumber(id)]
		config.finishNum = finishNum
		local theType = config.type
		local finishNum = _typeNumMap[theType]
		config.finishNum = finishNum
		table.insert(self.m_tDataList, config)
	end

	self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function _sortById(a, b)
	local idA = a.id
	local idB = b.id
 
	if idA < idB then
		return true
	end
	return false
end

-------------------------------------私有方法模块End--------------------------------------


rawset(_G, "WndCompeteTask", WndCompeteTask)

