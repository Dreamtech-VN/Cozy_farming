--CellMarryLetterData.lua
--@brief	CellMarryLetter的数据模块
--@date		2014/01/15
--@author	叶威
--@note		求婚信列表项

CellMarryLetter = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMarryLetter:_init()
	self.m_root = nil  			--Cell的根节点
    self.m_sText = ""           --信的简述文本
    self.m_nLetterId = 0        --当前求婚信id
    self.m_sLetterT = nil       --求婚信信息
    self.m_sPlayerLevel = nil   --玩家等级
    self.m_sPlayerName = nil    --玩家名字
    self.m_nHeadId = nil
    self.m_nFaceId = nil
    self.m_nPlayerId = nil
    self.m_sLetterName  = nil
    self.m_nHeadColor = nil
    self.m_nServerId = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMarryLetter:_unInit()
	self.m_root = nil
    self.m_sText = ""
    self.m_nLetterId = 0
    self.m_sLetterT = nil       --求婚信信息
    self.m_sPlayerLevel = nil   --玩家等级
    self.m_sPlayerName = nil    --玩家名字
    self.m_nHeadId = nil
    self.m_nFaceId = nil
    self.m_nPlayerId = nil
    self.m_sLetterName  = nil
    self.m_nHeadColor = nil
    self.m_nServerId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMarryLetter:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMarryLetter table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellMarryLetter")
	assert(element, "CellMarryLetter element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@breif  设置求婚信信息
function CellMarryLetter:setLetterInfo(playerName,playerLevel,letterT,letterName,playerHead,playerFace,playerId,headColor, serverId)
	self.m_sPlayerName = playerName
	self.m_sPlayerLevel = playerLevel
	self.m_sLetterT = letterT
	self.m_nFaceId = playerHead
	self.m_nHeadId = playerHead
	self.m_nPlayerId = playerId
	self.m_sLetterName = letterName
	self.m_nHeadColor = headColor
	self.m_nServerId = serverId
end

--@brief  设置当前求婚信ID
--@param  id:求婚信id
function CellMarryLetter:setLetterId(id)
    self.m_nLetterId = id
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMarryLetter:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
