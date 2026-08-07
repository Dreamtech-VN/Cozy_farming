--CellPrivateChatHeadData.lua
--@brief	CellPrivateChatHead的数据模块
--@date		2017/02/24
--@author	qixiang
--@note		私聊头像

CellPrivateChatHead = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPrivateChatHead:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = {}          --保存玩家信息
	self.m_bOnline = true       --玩家是否在线
	self.m_bSelect = false
	self.m_luaCallback = nil
	self.m_luaCallfun = nil
	self.m_luaRemoveCallback = nil
	self.m_luaRemoveCallbackFun = nil
	self.m_bShowRedPoint = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPrivateChatHead:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bSelect = nil
	self.m_bOnline = nil
	self.m_luaCallback = nil
	self.m_luaCallfun = nil
	self.m_bShowRedPoint = nil
	self.m_luaRemoveCallback = nil
	self.m_luaRemoveCallbackFun = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPrivateChatHead:createElement()
	tNewObj = self:_new()
	assert(tNewObj, "CellPrivateChatHead table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPrivateChatHead")
	assert(element, "CellPrivateChatHead element create failed!")
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

function CellPrivateChatHead:setData(id,name,sex,playerLevel,vipLevel,head,face,headColor,bGM)
	WZLog("CellPrivateChatHead:setData")
	self.m_tData = {}
	self.m_tData.id = id
	self.m_tData.name = name
	self.m_tData.sex = sex
	self.m_tData.vipLevel = vipLevel
	self.m_tData.head = head
	self.m_tData.face = face
	self.m_tData.headColor = headColor
	self.m_tData.playerLevel = playerLevel
	self.m_tData.bGM = bGM
end

--bOnline  是否在线
function CellPrivateChatHead:setOnlineStats(bOnline)
	WZLog("CellPrivateChatHead:setOnlineStats ",bOnline)
	self.m_bOnline = bOnline
	self:updateOnlineStats()
end

--bSelect  设置是否选中
function CellPrivateChatHead:setBSelect(bSelect)
	-- body
	WZLog("CellPrivateChatHead:setBSelect ",bSelect)
	self.m_bSelect = bSelect
	self:updateSelectStats()
end

function CellPrivateChatHead:setRedPoint(bShowRedPoint)
	-- body
	WZLog("CellPrivateChatHead:setRedPoint")
	self.m_bShowRedPoint = bShowRedPoint
	self:updateRedPointStats()
end

function CellPrivateChatHead:setClickCallback(lua,luaFun)
	-- body
	WZLog("CellPrivateChatHead:setClickCallback")
	self.m_luaCallback = lua
	self.m_luaCallfun = luaFun
end

function CellPrivateChatHead:setClickRemoveCallback(lua,luaFun)
	-- body
	WZLog("CellPrivateChatHead:setClickRemoveCallback")
	self.m_luaRemoveCallback = lua
	self.m_luaRemoveCallbackFun = luaFun
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPrivateChatHead:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
