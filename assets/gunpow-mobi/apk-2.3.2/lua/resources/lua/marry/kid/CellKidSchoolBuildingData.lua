--CellKidSchoolBuildingData.lua
--@brief	CellKidSchoolBuilding的数据模块
--@date		2021/5/10
--@author	yrd
--@note		家园建筑节点

CellKidSchoolBuilding = {
	-- -- 请在这里定义和初始化全局成员变量
	-- m_tTargetPoint1 = {{70,140},{105,155},{140,175},},
	-- m_tTargetPoint2 = {{315,20},{350,35},{385,50},},
    -- m_tSecondPoint = {{250,120}},
    -- m_tThirdPoint = {{270,70}},
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellKidSchoolBuilding:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_tStudyAreaPos = {{0.5,0.96},{0.25,0.7},{0.75,0.7},{0.5,0.44}} --运动区中小孩位置
	self.m_tRestAreaPos = {{0.205,0.612},{0.48,0.34},{0.755,0.068}} --休息区中小孩位置
	self.m_tTechnologyAreaPos = {{0.16,0.62},{0.84,0.62},{0.25,0.42},{0.75,0.42},{0.4,0.3},{0.6,0.3}} --科技区中小孩位置
	self.m_tTargetPoint1 = {{70,140},{105,155},{140,175}} --运动区中小孩起点位置
	self.m_tTargetPoint2 = {{315,20},{350,35},{385,50}} --运动区中小孩终点位置
	self.m_nMaxKidCount = 20				--最大孩子数

	self.m_tAreaData = {} 		--区域数据
	self.m_tKidsData = {} 		--小孩数据
	self.m_tKidObjList = {} 	--小孩对象列表
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellKidSchoolBuilding:_unInit()
	self.m_root = nil
	self.m_tData = nil  
	self.m_tStudyAreaPos = nil
	self.m_tRestAreaPos = nil 
	self.m_tTechnologyAreaPos = nil
	self.m_tSportsAreaPos = nil
	self.m_nMaxKidCount = nil

	self.m_tAreaData = nil 		--区域数据
	self.m_tKidsData = nil 		--小孩数据
	self.m_tKidObjList = nil 	--小孩对象列表
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellKidSchoolBuilding:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellKidSchoolBuilding table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellKidSchoolBuilding")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置建筑数据
function CellKidSchoolBuilding:setBuildingData(tData)
	-- body
	self.m_tData = tData

	self:_update()
end

--@brief 	重置建筑数据
function CellKidSchoolBuilding:resetBuildingData(tData)
	-- body
	WZLog("CellKidSchoolBuilding:resetBuildingData", Serialize(self.m_tData))
	self.m_tData = tData
end

--@brief 	获取建筑数据
function CellKidSchoolBuilding:getData()
	-- body
	return self.m_tData
end

--@brief 	设置区域数据
function CellKidSchoolBuilding:setAreaData(tAreaData)
	self.m_tAreaData = tAreaData
end

--@brief 	设置小孩数据
function CellKidSchoolBuilding:setKidData(tKidsData)
	self.m_tKidsData = tKidsData
	self:updateKidsRole()
end

--@brief 	获取建筑中小孩对象列表
function CellKidSchoolBuilding:getKidObjList()
	return self.m_tKidObjList
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellKidSchoolBuilding:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
