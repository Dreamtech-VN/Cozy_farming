--CellLibraryGoodsGetPathData.lua
--@brief	CellLibraryGoodsGetPath的数据模块
--@date		2016/05/06
--@author	maopeiting
--@note		图鉴物品获得路径

CellLibraryGoodsGetPath = {
	--请不要在这里定义变量
}


--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellLibraryGoodsGetPath:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = {}			--物品途径表
	self.battelType = 0  		--战斗类型
	self.id = 0 				--id号
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLibraryGoodsGetPath:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.battelType = nil
	self.id = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellLibraryGoodsGetPath:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellLibraryGoodsGetPath table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	assert(element, "CellLibraryGoodsGetPath element create failed!")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(300,90)) 
	element:setLuaObjectIndex(tNewObj)
	--tNewObj.m_root = element
	return element,tNewObj
end

function CellLibraryGoodsGetPath:onLoadData( element )
	local cellElement = WZUISystem:getInstance():createElement("CellLibraryGoodsGetPath")     
    self.m_root:addChild(cellElement)
    self:_update()
    AdaptLanguage(self)
end

--@brief    设置table表格数据
function CellLibraryGoodsGetPath:setData( data )
	self.m_tData = data
	self.battelType = self.m_tData[1]
	self.id = self.m_tData[2]
	
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellLibraryGoodsGetPath:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
