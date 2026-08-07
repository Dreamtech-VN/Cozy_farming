--CellFamilyWorkerData.lua
--@brief	CellFamilyWorker的数据模块
--@date		2017/07/26
--@author	Tianxiang_Xu
--@note		家园打工宠物、守卫兽形象节点

CellFamilyWorker = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellFamilyWorker:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_nType = nil 			--1:宠物，2：坐骑
	self.m_tBackFun = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFamilyWorker:_unInit()
	self.m_root = nil
	self.m_tData = nil  
	self.m_tBackFun = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellFamilyWorker:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFamilyWorker table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(65,70))
	element:setName("__CellFamilyWorker")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellFamilyWorker:setData(tData, nType)
	-- body
	self.m_tData = tData
	self.m_nType = nType

	self:_update()
end

--@brief 	获取数据
function CellFamilyWorker:getData()
	-- body
	return self.m_tData
end

--@brief	item点击回调
--@param tCell:父节点
--@param backFun：回调函数
function CellFamilyWorker:setItemClickFun(tCell, backFun)
	if tCell and backFun then
		self.m_tBackFun = {}  --回调函数列表
		table.insert(self.m_tBackFun,tCell)
		table.insert(self.m_tBackFun,backFun)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFamilyWorker:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
