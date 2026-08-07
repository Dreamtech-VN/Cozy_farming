--CellStrengthenSelectTipsData.lua
--@brief	CellStrengthenSelectTips的数据模块
--@date		2015/06/09
--@author	zsq
--@note		要选择的装备或宝石cell

CellStrengthenSelectTips = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellStrengthenSelectTips:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tItem = nil

end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellStrengthenSelectTips:_unInit()
	self.m_root = nil
    self.m_tItem = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellStrengthenSelectTips:createElement()
    local tNewObj = self:_new()
    assert(tNewObj, "CellStrengthenSelectTips table create failed!")
    tNewObj:_init()
    local element = WZUISystem:getInstance():createElement("CellStrengthenSelectTips")
    assert(element, "CellStrengthenSelectTips element create failed!")
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

--@brief    初始化cell
function CellStrengthenSelectTips:initCellDataWithType(type,t)
    self.m_tItem = {}
    self.m_tItem = t
    if type == 1 then
        self:_initStoneCellData()
    elseif type == 2 then
        self:_initEquipCellData()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@param	新建的表实例对象
function CellStrengthenSelectTips:_new( )
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
