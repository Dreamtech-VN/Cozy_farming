--CellCharmRecommendData.lua
--@brief	CellCharmRecommend的数据模块
--@date		2016/08/24
--@author	mpt
--@note		魅力空间推荐

CellCharmRecommend = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCharmRecommend:_init()
	self.m_root = nil  			--Cell的根节点
	self.playerName = nil
	self.photoUrl = nil
	self.sex = nil
	self.cross = nil
	self.level = nil
	self.playerId = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCharmRecommend:_unInit()
	self.m_root = nil
	self.playerName = nil
	self.photoUrl = nil
	self.sex = nil
	self.cross = nil
	self.level = nil
	self.playerId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCharmRecommend:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCharmRecommend table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCharmRecommend")
	assert(element, "CellCharmRecommend element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellCharmRecommend:setData( playerId,playerName,photoUrl,sex,cross,level )
	self.playerId = playerId
	self.playerName = playerName
	self.photoUrl = photoUrl
	self.sex = sex
	self.cross = cross
	self.level = level
	--WZLog("--CellCharmRecommend--",photoUrl)
	self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCharmRecommend:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
