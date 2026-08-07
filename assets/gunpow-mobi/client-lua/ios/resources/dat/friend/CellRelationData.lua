--CellRelationData.lua
--@brief	CellRelation的数据模块
--@date		2016/11/16
--@author	Tianxiang_Xu
--@note		关系子节点

CellRelation = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellRelation:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nType = nil 
	self.m_tData = nil 
	self.m_parentNode = nil 
	self.m_tPlayerInfo = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRelation:_unInit()
	self.m_root = nil
	self.m_nType = nil 
	self.m_tData = nil 
	self.m_parentNode = nil 
	self.m_tPlayerInfo = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellRelation:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellRelation table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellRelation")
	assert(element, "CellRelation element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
--@param 	nType: 1->蜜友；2->夫妻；3->师傅；4->徒弟
--@param 	whoInfo:XX和该人的关系
function CellRelation:setData(nType, tData, parentNode, whoInfo)
	-- body
	self.m_nType = nType
	self.m_tData = tData
	self.m_parentNode = parentNode 
	self.m_tPlayerInfo = whoInfo 
	WZLog("CellRelation:setData", Serialize(self.m_tData))
	self:_update()
end

--@brief 	获取恩爱等级和当前恩爱值成功
function CellRelation:getLoveLevelAndValueOK(value, level)
	-- body
	if CellRelation.m_CurClick.m_root == nil then return end
	WZLog("CellRelation:getLoveLevelAndValueOK", value, level)
	local tData = {}
	tData[1] = {}
    tData[2] = {}
    local tTempInfo = CellRelation.m_CurClick:getRelationName(CellRelation.m_CurClick.m_nType, level)
    local nValue = CaculateAllValue(CellRelation.m_CurClick.m_nType, level) + value
	tData[1][1] = CellRelation.m_CurClick.m_tPlayerInfo.name .. tTempInfo.title
    tData[2][1] = LocalStrings.COUPLE_LOVE .. ":" .. nValue

    WndTips:show(CellRelation.m_CurClick.m_Element,CellRelation.m_CurClick.m_parentNode,31,tData, GlobalMethod:ccp(150,30), not CellRelation.m_CurClick.m_parentNode:getShowAll())
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellRelation:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
