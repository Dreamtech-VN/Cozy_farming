--CellWorldTeamBossInviteData.lua
--@brief	CellWorldTeamBossInvite的数据模块
--@date		2020/05/11
--@author	XTX
--@note		世界组队boss邀请列表Cell

CellWorldTeamBossInvite = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellWorldTeamBossInvite:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tFriend = nil 
	self.m_tBackFun = nil 
	self.m_selectIndex = 0 
	self.m_nInterface = 0
	self.IsStranger = false     --是否是模式人
	self.m_bIsLoad = false 		--是否已加载
	self.m_bInvited = nil 		--是否被邀请
	self.m_nSelect = nil 		--1：本服好友；2：公会好友；3：大厅；4：跨服好友
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellWorldTeamBossInvite:_unInit()
	self.m_root = nil
	self.m_tFriend = nil 
	self.m_tBackFun = nil 
	self.m_selectIndex = nil 
	self.m_nInterface = nil 
	self.IsStranger = false 
	self.m_bIsLoad = nil 		--是否已加载
	self.m_bInvited = nil 		--是否被邀请
	self.m_nSelect = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellWorldTeamBossInvite:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellWorldTeamBossInvite table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellWorldTeamBossInvite")
    element:setAbsContentSize(GlobalMethod:CCSize(470,80))
    element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	获取好友列表数据
--@param 	nSelect:右边标签的索引
function CellWorldTeamBossInvite:setCellData(tFriend, nSelect)
	self.m_tFriend = {}
	self.m_tFriend = tFriend
	self.m_nSelect = nSelect
end

--@brief	设置获得函数
--@param	tCell:表名
--@param	backFun:回调函数
function CellWorldTeamBossInvite:setBackFun(tCell , backFun)
	if tCell == nil or backFun == nil then
		return
	end
	self.m_tBackFun = {}
	self.m_tBackFun[1] = tCell
	self.m_tBackFun[2] = backFun
end

--@brief 	界面类型
function CellWorldTeamBossInvite:setUIIndex( index )
	self.m_nInterface = index
end

--@brief 	设置是否为陌生人
function CellWorldTeamBossInvite:setIsStranger( isStranger )
	self.IsStranger = isStranger
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellWorldTeamBossInvite:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
