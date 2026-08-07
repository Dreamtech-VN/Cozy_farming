--CellRoomInviteListData.lua
--@brief	CellRoomInviteList的数据模块
--@date		2019/03/12
--@author	Tianxiang_Xu
--@note		房间邀请界面-列表

CellRoomInviteList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellRoomInviteList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tFriend = nil 
	self.m_tBackFun = nil 
	self.m_selectIndex = 0 
	self.m_nInterface = 0
	self.IsStranger = false     --是否是模式人
	self.m_bIsLoad = false 		--是否已加载
	self.m_bInvited = false 		--是否被邀请
	self.m_nSelect = nil 		--1：本服好友；2：公会好友；3：大厅；4：跨服好友
	self.m_nIconIndex = 0 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRoomInviteList:_unInit()
	self.m_root = nil
	self.m_tFriend = nil 
	self.m_tBackFun = nil 
	self.m_selectIndex = nil 
	self.m_nInterface = nil
	self.IsStranger = nil     --是否是模式人
	self.m_bIsLoad = nil 		--是否已加载
	self.m_bInvited = nil 		--是否被邀请
	self.m_nSelect = nil 		--1：本服好友；2：公会好友；3：大厅；4：跨服好友
	self.m_nIconIndex = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellRoomInviteList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellRoomInviteList table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellRoomInviteList")
    element:setAbsContentSize(GlobalMethod:CCSize(376,90))
    element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	获取好友列表数据
--@param 	nSelect:右边标签的索引
function CellRoomInviteList:setCellData(tFriend, nSelect)
	self.m_tFriend = {}
	self.m_tFriend = tFriend
	self.m_nSelect = nSelect
end

--@brief	设置获得函数
--@param	tCell:表名
--@param	backFun:回调函数
function CellRoomInviteList:setBackFun(tCell , backFun)
	if tCell == nil or backFun == nil then
		return
	end
	self.m_tBackFun = {}
	self.m_tBackFun[1] = tCell
	self.m_tBackFun[2] = backFun
end

--@brief 	界面类型
function CellRoomInviteList:setUIIndex( index )
	self.m_nInterface = index
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellRoomInviteList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
