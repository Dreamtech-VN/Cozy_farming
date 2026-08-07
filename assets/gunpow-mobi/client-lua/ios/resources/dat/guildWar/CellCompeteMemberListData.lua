--CellCompeteMemberListData.lua
--@brief	CellCompeteMemberList的数据模块
--@date		2016/08/22
--@author	Tianxiang_Xu
--@note		公会战房间成员列表子节点

CellCompeteMemberList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCompeteMemberList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_tCallBack = nil 
	self.m_bIsLoaded = false 	--是否已经加载
	self.m_nCommunityPosition = nil 	--玩家在公会中的职位
	self.m_nJoinLevel = nil 	--参加公会战的等级限制
	self.m_nJoinTimeLimit = nil 	--参加公会战入会时间限制
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCompeteMemberList:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_tCallBack = nil 
	self.m_bIsLoaded = nil 	--是否已经加载
	self.m_nCommunityPosition = nil 	--玩家在公会中的职位
	self.m_nJoinLevel = nil 	--参加公会战的等级限制
	self.m_nJoinTimeLimit = nil 	--参加公会战入会时间限制
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCompeteMemberList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCompeteMemberList table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
	element:setName("__CellCompeteMemberList")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(745,85))
	element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief 	设置数据
function CellCompeteMemberList:setData(tData)
	-- body
	self.m_tData = tData
	self.m_nJoinLevel = 25 	--参加公会战的等级限制
	self.m_nJoinTimeLimit = 172800 	--参加公会战入会时间限制
	self.m_nCommunityPosition = tonumber(CacheCenter:getPlayerInfo().position)
end

--@brief 	设置点击列表回调方法
function CellCompeteMemberList:setCallBackFun(tCell, func, func2)
	-- body
	if self.m_tCallBack == nil then
		self.m_tCallBack = {}
	end

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func 
	self.m_tCallBack[3] = func2 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCompeteMemberList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
