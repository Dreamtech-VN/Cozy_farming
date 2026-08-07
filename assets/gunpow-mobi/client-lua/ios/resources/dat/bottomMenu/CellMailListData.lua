--CellMailListData.lua
--@brief	CellMailList的数据模块
--@date		2013/12/06
--@author	liangguang_long
--@note     邮件模块

CellMailList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMailList:init()
	self.m_root = nil  			--Cell的根节点
    self.m_tCellData = {}
    self.m_checkState = 0       --被选择状态
    self.b_checkstate = true
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMailList:unInit()
	self.m_root = nil
    self.m_tCellData = nil
    self.m_checkState = nil
    self.b_checkstate =  nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@param	#1，控件element的引用
--@param	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMailList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMailList table create failed!")
	tNewObj:init()
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("CellMailList")          --”√”⁄‘⁄±ÌµƒÕ‚√Ê£¨Õ®π˝√˚◊÷ªÒ»°∂‘”¶µƒ±ÌΩ·ππ
    element:setAbsContentSize(GlobalMethod:CCSize(310,80))
	assert(element, "CellMailList element create failed!")
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	获取表参数
--@param	#1, tCellData:邮件信息
function CellMailList:onLoadData(element)
	WZLog("CellMailList:onLoadData")
	local cellElement = WZUISystem:getInstance():createElement("CellMailList")
    self.m_root:addChild(cellElement)
	self:_update()
	
end

--@brief	获取表参数
--@param	#1, tCellData:邮件信息
function CellMailList:setMailCellAllElement(tCellData, state)
    WZLog("CellMailList:setMailCellAllElement(tCellData)",tCellData)
    if self.m_root == nil then
		return 
	end
    self.m_tCellData = tCellData
    self.m_tCellData.choiceState = false
    if state ~= nil then
    	self.m_tCellData.choiceState = state
    end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@param	新建的表实例对象
function CellMailList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------私有方法模块End----------------------------------------


