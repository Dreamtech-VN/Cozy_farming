--CellKidSchoolRoleData.lua
--@brief	CellKidSchoolRole的数据模块
--@date		2021/5/10
--@author	yrd
--@note		家园打工宠物、守卫兽形象节点

CellKidSchoolRole = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellKidSchoolRole:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_tBackFun = nil 
	self.m_conOutSide = nil 
	self.m_conKidRole = nil 
	self.m_tGridData = nil 		--保存孩子位置的格子
	self.m_sKidActionName = "wait" 	--小孩的动作 
	self.m_conPlayer = nil 		--玩家形象
	self.m_sPlayerActionName = "wait0"

end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellKidSchoolRole:_unInit()
	self.m_root = nil
	self.m_tData = nil  
	self.m_tBackFun = nil 
	self.m_conOutSide = nil 
	self.m_conKidRole = nil 
	self.m_tGridData = nil
	self.m_sKidActionName = nil 
	self.m_conPlayer = nil
	self.m_sPlayerActionName = nil 
	
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellKidSchoolRole:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellKidSchoolRole table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(65,70))
	element:setName("__CellKidSchoolRole")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellKidSchoolRole:setData(tData)
	-- body
	self.m_tData = tData

	self:update()
end

--@brief 	获取数据
function CellKidSchoolRole:getData()
	-- body
	return self.m_tData
end

--@brief 	重新设置数据
function CellKidSchoolRole:resetData(tData)
	-- body
	self.m_tData = tData
end

--@brief	item点击回调
--@param tCell:父节点
--@param backFun：回调函数
function CellKidSchoolRole:setItemClickFun(tCell, backFun)
	if tCell and backFun then
		self.m_tBackFun = {}  --回调函数列表
		table.insert(self.m_tBackFun,tCell)
		table.insert(self.m_tBackFun,backFun)
	end
end

--@brief 	设置数据
function CellKidSchoolRole:setRoleGridData(tGridData)
	-- body
	self.m_tGridData = tGridData
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellKidSchoolRole:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
