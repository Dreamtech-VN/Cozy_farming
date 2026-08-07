--CellFamilyBuildingData.lua
--@brief	CellFamilyBuilding的数据模块
--@date		2017/07/26
--@author	Tianxiang_Xu
--@note		家园建筑节点

CellFamilyBuilding = {
	-- 请在这里定义和初始化全局成员变量
	m_tTargetPoint1 = {{70,205}},
	m_tTargetPoint2 = {{430,210}},
    m_tSecondPoint = {{250,120}},
    m_tThirdPoint = {{270,70}},
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellFamilyBuilding:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_nType = 0 			--0:默认值；1:信息，升级界面标识
	self.m_tPetPosition = {{0.5,0.88},{0.65,0.8},{0.5,0.7},{0.65,0.6},{0.25,0.7},{0.35,0.82}}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFamilyBuilding:_unInit()
	self.m_root = nil
	self.m_tData = nil  
	self.m_nType = nil 
	self.m_tPetPosition = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellFamilyBuilding:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFamilyBuilding table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellFamilyBuilding")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置建筑数据
function CellFamilyBuilding:setBuildingData(tData, nType)
	-- body
	self.m_tData = tData
	self.m_nType = nType or 0

	self:_update()
end

--@brief 	重置建筑数据
function CellFamilyBuilding:resetBuildingData(tData)
	-- body
	WZLog("CellFamilyBuilding:resetBuildingData", Serialize(self.m_tData))
	self.m_tData = tData
end

--@brief 	获取建筑数据
function CellFamilyBuilding:getData()
	-- body
	return self.m_tData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFamilyBuilding:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
