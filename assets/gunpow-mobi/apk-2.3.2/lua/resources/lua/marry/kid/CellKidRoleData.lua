--CellKidRoleData.lua
--@brief	CellKidRole的数据模块
--@date		2017/07/26
--@author	Tianxiang_Xu
--@note		家园打工宠物、守卫兽形象节点

CellKidRole = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellKidRole:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_nType = nil 			--1:佣人，2：夫妻, 3:小孩, 4:拜访者, 5:度假村访问者, 6度假村精灵
	self.m_tBackFun = nil 
	self.m_conOutSide = nil 
	self.m_conKidRole = nil 
	self.m_tGridData = nil 		--保存孩子位置的格子
	self.m_tCellCar = nil 		--使用中的骑马
	self.m_sKidActionName = "wait" 	--小孩的动作 
	self.m_bIsPlayCar = false 	--是否在骑马
	self.m_conPlayer = nil 		--玩家形象
	self.m_sPlayerActionName = "wait0"

	self.m_conVisitorRole = nil 			--拜访者形象
	self.m_sVisitorActionName = "wait0"		--拜访者动画

	self.m_conSpiritRole = nil 				--精灵形象
	self.m_sSpiritActionName = "wait"		--精灵动画

	self.m_bIsVisible = true 				--是否可见
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellKidRole:_unInit()
	self.m_root = nil
	self.m_tData = nil  
	self.m_tBackFun = nil 
	self.m_conOutSide = nil 
	self.m_conKidRole = nil 
	self.m_tCellCar = nil 
	self.m_sKidActionName = nil 
	self.m_bIsPlayCar = nil 
	self.m_conPlayer = nil
	self.m_sPlayerActionName = nil 
	
	self.m_conVisitorRole = nil 			--拜访者形象
	self.m_sVisitorActionName = nil			--拜访者动画

	self.m_conSpiritRole = nil 				--精灵形象
	self.m_sSpiritActionName = nil			--精灵动画

	self.m_bIsVisible = nil 				--是否可见
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellKidRole:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellKidRole table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(65,70))
	element:setName("__CellKidRole")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellKidRole:setData(tData, nType)
	-- body
	self.m_tData = tData
	self.m_nType = nType

	self:_update()
end

--@brief 	获取数据
function CellKidRole:getData()
	-- body
	return self.m_tData
end

--@brief 	重新设置数据
function CellKidRole:resetData(tData)
	-- body
	self.m_tData = tData
end

--@brief	item点击回调
--@param tCell:父节点
--@param backFun：回调函数
function CellKidRole:setItemClickFun(tCell, backFun)
	if tCell and backFun then
		self.m_tBackFun = {}  --回调函数列表
		table.insert(self.m_tBackFun,tCell)
		table.insert(self.m_tBackFun,backFun)
	end
end

--@brief 	设置数据
function CellKidRole:setRoleGridData(tGridData)
	-- body
	self.m_tGridData = tGridData
end

--@brief 	设置形象可见与否
function CellKidRole:setRoleVisible(bVisible)
	self.m_bIsVisible = bVisible
	self.m_root:setVisible(bVisible)
end

--@brief 	获取形象可见与否
function CellKidRole:getRoleVisible()
	return self.m_bIsVisible
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellKidRole:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
