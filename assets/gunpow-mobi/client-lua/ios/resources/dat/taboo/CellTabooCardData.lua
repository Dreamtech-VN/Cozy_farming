--CellTabooCardData.lua
--@brief	CellTabooCard的数据模块
--@date		2017/04/21
--@note		card

CellTabooCard = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellTabooCard:_init()
	self.m_root = nil  			--Cell的根节点
    
    self.m_tData = nil          --数据表
    self.m_bCardFace = true     --是否正面
    self.m_bIsNormal = true     --常规格子
   	self.m_nBack = nil
    self.m_nFront = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellTabooCard:_unInit()
	self.m_root = nil
    
    self.m_tData = nil
    self.m_bCardFace = true
    self.m_bIsNormal = true
    self.m_nBack = nil
    self.m_nFront = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellTabooCard:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellTabooCard table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellTabooCard")
	assert(element, "CellTabooCard element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置数据
--@param    nItemId,道具id
--@param    nCount,道具数量
--@param    nPlayerName,玩家姓名
function CellTabooCard:setData(tData)
    self.m_tData = tData
    self:_update()
end

function CellTabooCard:setDirData(nBack,nFront)
	self.m_nBack = nBack or 2
    self.m_nFront = nFront or 2
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellTabooCard:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
