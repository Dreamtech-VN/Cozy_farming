-- 公会战奖励列表内容 数据部分
-- @brief:
-- @date: 2017-02-22 16:45:40
-- @author: zhenwei_jian
-- @note:公会战奖励列表内容

local CellCompeteGift = {}


--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellCompeteGift:_init()
	self.m_root = nil	 	  			--根节点
	self.m_tData = nil 					--奖励数据

end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCompeteGift:_unInit()
	self.m_root = nil
	self.m_tData = nil 					--奖励数据
	self.m_tRankNameMap = nil
end


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellCompeteGift:createElement()
	local tInstance = self:_new()
	tInstance:_init()
	local element = WZUISystem:getInstance():createElement("CellCompeteGift")
	element:setLuaObjectIndex(tInstance)
	return element, tInstance
end

function CellCompeteGift:setData(tData)
	self.m_tData = tData
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCompeteGift:_new( )
	local tInstance = {}
	setmetatable(tInstance, {__index = CellCompeteGift})
	return tInstance
end

-------------------------------------私有方法模块End----------------------------------------


rawset(_G, "CellCompeteGift", CellCompeteGift)

