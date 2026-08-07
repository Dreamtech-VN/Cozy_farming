--CellHVBuildingData.lua
--@brief	CellHVBuilding的数据模块
--@date		2022/06/04
--@author	XTX
--@note		度假村-建筑、土地块

CellHVBuilding = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellHVBuilding:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_bIsChoose = false 	--是否被选中
	self.m_DecorationId = 0 	--装饰物Id
	self.m_tLuaTable = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellHVBuilding:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_bIsChoose = nil 
	self.m_DecorationId = nil 
	self.m_tLuaTable = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellHVBuilding:createElement(nType)
	local tNewObj = self:_new()
	assert(tNewObj, "CellHVBuilding table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellHVBuilding")
	element:setLuaObjectIndex(tNewObj)
	if nType == 0 then 
		tNewObj.m_tLuaTable = SceneHolidayVillage
	elseif nType == 1 then 
		tNewObj.m_tLuaTable = SceneHVTree
	end
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置建筑数据
function CellHVBuilding:setBuildingData(tData)
	-- body
	self.m_tData = tData

	self:_update()
end

--@brief 	重置建筑数据
function CellHVBuilding:resetBuildingData(tData)
	-- body
	WZLog("CellHVBuilding:resetBuildingData", Serialize(self.m_tData))
	self.m_tData = tData
end

--@brief 	获取建筑数据
function CellHVBuilding:getData()
	-- body
	return self.m_tData
end

--@brief 	重新设置一些建筑的图标状态（白天-傍晚）
function CellHVBuilding:resetBuildingImg(itemId)
	if self.m_root == nil then return end 

	if itemId then 
		self.m_DecorationId = itemId
		local conForBuilding = self:_createConForBuilding()
    	local imgBuilding = conForBuilding:getChildByTag(98) 
    	if imgBuilding then 
    		imgBuilding:removeFromParentAndCleanup(true)
    	end
    	WZLog("CellHVBuilding:resetBuildingImg", self.m_DecorationId)
	end
	self:_drawBuilding()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellHVBuilding:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
