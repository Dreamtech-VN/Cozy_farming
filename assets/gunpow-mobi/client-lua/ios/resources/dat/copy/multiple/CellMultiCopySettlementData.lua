--CellMultiCopySettlementData.lua
--@brief	CellMultiCopySettlement的数据模块
--@date		2015/05/22
--@author	xiaoyu_wu
--@note		多人副本结算单元格

CellMultiCopySettlement = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMultiCopySettlement:_init()
	self.m_root = nil  			--Cell的根节点
    
    self.m_tData = nil          --数据表
    
    self.m_nAddExp = 0                  --增加的总经验            
    self.m_nCurAddExp = 0               --当前显示的已经增加的经验，动画用
    self.m_nCurLevel = 0                --当前显示的等级，动画用
    self.m_nCurExp = 0                  --当前显示的经验，动画用
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMultiCopySettlement:_unInit()
	self.m_root = nil
    
    self.m_tData = nil 
    
    self.m_nAddExp = 0                         
    self.m_nCurAddExp = 0  
    self.m_nAddExpStep = 0     
    self.m_nCurLevel = 0              
    self.m_nCurExp = 0 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMultiCopySettlement:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMultiCopySettlement table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellMultiCopySettlement")
	assert(element, "CellMultiCopySettlement element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置数据表
--@param    tData, 数据表
function CellMultiCopySettlement:setData(tData)
	WZLog("CellMultiCopySettlement:setData:",Serialize(tData))
    self.m_tData = tData
    self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMultiCopySettlement:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
