--CellProfessionCrystalLibraryData.lua
--@brief	CellProfessionCrystalLibrary的数据模块
--@date		2021/02/07
--@author	XTX
--@note		职业水晶图鉴-Cell

CellProfessionCrystalLibrary = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellProfessionCrystalLibrary:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil 
	self.m_bIsLoaded = false 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellProfessionCrystalLibrary:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_bIsLoaded = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellProfessionCrystalLibrary:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPhantomItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setName("__CellProfessionCrystalLibrary")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(734, 100))
	element:setLuaObjectIndex(tNewObj)

	return element, tNewObj
end

--@brief 	设置数据
function CellProfessionCrystalLibrary:setData(tData)
	-- body
	self.m_tData = tData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellProfessionCrystalLibrary:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
