--CellMarryFriendData.lua
--@brief	CellMarryFriend的数据模块
--@date		2014/03/26
--@author	liangguang_long
--@note		附近好友模块

CellMarryFriend = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMarryFriend:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tFriend = nil 
	self.m_tBackFun = nil 
	self.m_tLevelAndNameFormat = LocalStrings.LevelAndNameFormat
	self.m_nInterface = nil 	--1、发请柬,2、婚礼邀请,3、战斗邀请,4、邮件邀请,5、异性单身
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMarryFriend:_unInit()
	self.m_root = nil
	self.m_tFriend = nil 
	self.m_tBackFun = nil 
	self.m_nInterface = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMarryFriend:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMarryFriend table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellMarryFriend")
    element:setAbsContentSize(GlobalMethod:CCSize(430,106))
    element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	获取好友列表数据
function CellMarryFriend:setCellData(tFriend, nIndex)
	self.m_tFriend = {}
	self.m_tFriend = tFriend
	self.m_nInterface = nIndex
	WZLog("CellMarryFriend:setCellData", Serialize(self.m_tFriend))
end

--@brief	设置获得函数
--@param	tCell:表名
--@param	backFun:回调函数
function CellMarryFriend:setBackFun(tCell , backFun,selectItem)
	if tCell == nil or backFun == nil then
		return
	end
	self.m_tBackFun = {}
	self.m_tBackFun[1] = tCell
	self.m_tBackFun[2] = backFun
	self.m_tBackFun[3] = selectItem
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMarryFriend:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------



