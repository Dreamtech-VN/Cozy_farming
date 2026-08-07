--CellBattleCtbData.lua
--@brief	CellBattleCtb的数据模块
--@date		2015/04/17
--@author	Zjh

CellBattleCtb = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBattleCtb:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tCharacter = nil		--绑定的WCharacter/WHero引用
	
	self.m_bProgAction = false
	self.m_nCTB = 0
	self.m_nUpdateCTB = 0		--
	
	self.m_nCTB_Rate = 0

	self.m_bFrozen = false
	self.m_nDt = 0
    self.m_tHeadAnim = nil
    self.m_nSpeakerState = 0
    self.m_nVoiceId = -1
    self.m_bIsVoice = true
    self.m_nVoiceState = 0
    self.m_nMicState = 0
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBattleCtb:_unInit()
	self.m_root = nil
	self.m_tCharacter = nil		--绑定的WCharacter/WHero引用
	
	self.m_bProgAction = false
	self.m_nCTB = 0
	self.m_nUpdateCTB = 0		--
	
	self.m_nCTB_Rate = 0
	
	self.m_bFrozen = false
	self.m_nDt = 0
    self.m_tHeadAnim = nil
    self.m_nSpeakerState = 0
    self.m_nVoiceId = -1
    self.m_bIsVoice = true
    self.m_nVoiceState = 0
    self.m_nMicState = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellBattleCtb:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellBattleCtb table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellBattleCtb")
	assert(element, "CellBattleCtb element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBattleCtb:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------




CellBigBattleCtb = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBigBattleCtb:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tCharacter = nil		--绑定的WCharacter/WHero引用
	self.m_nSpeakerState = 0
	self.m_nVoiceId = -1
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBigBattleCtb:_unInit()
	self.m_root = nil
	self.m_tCharacter = nil		--绑定的WCharacter/WHero引用
	self.m_nSpeakerState = 0
	self.m_nVoiceId = -1
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellBigBattleCtb:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellBigBattleCtb table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellBigBattleCtb")
	assert(element, "CellBigBattleCtb element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBigBattleCtb:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
