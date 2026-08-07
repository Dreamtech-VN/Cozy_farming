--CellEnterServersData.lua
--@brief	CellEnterServers的数据模块
--@date		2015/04/29
--@author	binshao
--@note		单个服务器模块

CellEnterServers = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellEnterServers:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tCallbackFunc = nil 			--回调函数
	self.tData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellEnterServers:_unInit()
	self.m_root = nil  			--Cell的根节点
	self.m_tCallbackFunc = nil 			--回调函数
	self.tData = nil
end

-- 设置回调
function CellEnterServers:setCallBackFunc(element,callBackFunc)
	self.m_tCallbackFunc = {}
	if element and callBackFunc then
		self.m_tCallbackFunc[1] = element 
		self.m_tCallbackFunc[2] = callBackFunc
	end
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellEnterServers:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellEnterServers table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellEnterServers")
	assert(element, "CellEnterServers element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	获取表参数
--@param	tData:服务器数据
-- m_tData.nServerId 服务器Id
-- m_tData.sName 服务器名称
-- m_tData.areaCord 服务器code
-- m_tData.bFlog 是否为当前选中的服务器
function CellEnterServers:SetServerInfo( tData )
	if not self.m_root then return end
	self.tData = tData
	--更新界面数据
	self:_update()	
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellEnterServers:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
