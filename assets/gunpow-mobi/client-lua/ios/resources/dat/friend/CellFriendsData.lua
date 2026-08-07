--CellFriendsData.lua
--@brief	CellFriends的数据模块
--@date		2014/03/26
--@author	liangguang_long
--@note		附近好友模块

CellFriends = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellFriends:_init()
    WZLog("CellFriends:_init()")
	self.m_root = nil  			--Cell的根节点
	self.m_tFriend = nil 		--好友数据列表
	self.m_tBackFun = nil 		--回调列表
	self.m_nType = nil 
	self.m_nBtnIndex = nil 		--点击右边按钮的索引1：赠送活力；2：赠送礼物；3：私聊；4：空间
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFriends:_unInit()
	self.m_root = nil
	self.m_tFriend = nil 		--好友数据列表
	self.m_tBackFun = nil 		--回调列表
	self.m_nType = nil 
	self.m_nBtnIndex = nil 		--点击右边四个按钮的索引
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellFriends:createElement()
    local obj = {}
    setmetatable(obj, {__index = CellFriends})
    obj:_init()
    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellFriends")
    element:setAbsContentSize(GlobalMethod:CCSize(752,106))
    element:setLuaObjectIndex(obj)
    return element,obj
end

--@brief	获取好友列表数据
function CellFriends:setCellData(tFriend,nType,nServerIndex)
    WZLog("")
	self.m_tFriend = {}
	self.m_tFriend = tFriend
	self.m_nType = nType
end

--@brief	设置获得函数
--@param	tCell:表名
--@param	backFun:回调函数
function CellFriends:setBackFun(tCell , backFun,recvBackFun)
	if tCell == nil or backFun == nil then
		return
	end
	self.m_tBackFun = {}
	self.m_tBackFun[1] = tCell
	self.m_tBackFun[2] = backFun
	self.m_tBackFun[3] = recvBackFun
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFriends:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------



