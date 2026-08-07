--CellMsgItemData.lua
--@brief	CellMsgItem的数据模块
--@date		2016/05/18
--@author	qixiang_xie
--@note		聊天信息内容

CellMsgItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMsgItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_data = {}
	self.m_Define = {fontsize=20,margin=20}
	self.m_tComCCPoint = ccp(0,0)
	self.m_nRedPackId = nil 
	self.m_nRedpackSkinId = 0
	self.m_nDelSeconds = 0 	
	self.m_strBubble = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMsgItem:_unInit()
	self.m_tComCCPoint = ccp(0,0)
	self.m_nRedPackId = nil 
	self.m_nRedpackSkinId = nil 
	self.m_nDelSeconds = nil 
	self.m_strBubble = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMsgItem:createElement(width,height)
	--if tNewObj == nil then
	local tNewObj = self:_new()
	assert(tNewObj, "CellMsgItem table create failed!")
	tNewObj:_init()
	--end
	
	local element = WZUIContainer:create()
	--element:setUseAbsSize(true)
	element:setRelativeSize(GlobalMethod:CCSize(1,height))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief  设置数据
function CellMsgItem:setData(data)
	if data == nil then
		return
	end
	local countData = #self.m_data
	if countData > 100 then
		self.m_data = {}
	end
	table.insert(self.m_data,data)
end

--@brief  获取数据
function CellMsgItem:getData()
	return self.m_data
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMsgItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	setmetatable(self,WndChat)
	WndChat.__index = WndChat
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
