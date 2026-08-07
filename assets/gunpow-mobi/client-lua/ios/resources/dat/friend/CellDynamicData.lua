--CellFriendsData.lua
--@brief	CellFriends的数据模块
--@date		2014/03/26
--@author	liangguang_long
--@note		附近好友模块

CellDynamic = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellDynamic:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tFriend = nil 		--好友数据列表
	self.m_tBackFun = nil 		--回调列表
	self.m_nType = nil 
	self.level = 0
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDynamic:_unInit()
	self.m_root = nil
	self.m_tFriend = nil 		--好友数据列表
	self.m_tBackFun = nil 		--回调列表
	self.m_nType = nil 
	self.level = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellDynamic:createElement()
	local obj = {}
    setmetatable(obj, {__index = CellDynamic})
    obj:_init()
    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellDynamic")
    element:setAbsContentSize(GlobalMethod:CCSize(752,106))
    element:setLuaObjectIndex(obj)
    return element,obj
end

--@brief	获取好友列表数据
function CellDynamic:setCellData(tFriend)
	for i,data in pairs(tFriend) do 
		WZLog("获取好友列表数据dd",i,data,type(data))
		if type(data) == "table" then
			for k,v in pairs(data) do 
				WZLog("type(data) ==",k,v)
			end
		end
	end
	self.m_tFriend = {}
	self.m_tFriend = tFriend
end

--@brief	设置获得函数
--@param	tCell:表名
--@param	backFun:回调函数
function CellDynamic:setBackFun(tCell , backFun ,backSend, backSure, backRefuse)
	WZLog("CellDynamic:setBackFun")
	if tCell == nil or backFun == nil then
		return
	end
	WZLog("CellDynamic:setBackFun 222")
	self.m_tBackFun = {}
	self.m_tBackFun[1] = tCell
	self.m_tBackFun[2] = backFun
	self.m_tBackFun[3] = backSend
	self.m_tBackFun[4] = backSure
	self.m_tBackFun[5] = backRefuse
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellDynamic:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------



