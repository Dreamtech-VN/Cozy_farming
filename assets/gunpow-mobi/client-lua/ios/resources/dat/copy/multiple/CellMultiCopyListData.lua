--CellMultiCopyListData.lua
--@brief	CellMultiCopyList的数据模块
--@date		2015-7-29
--@author	binshao
--@note		组队副本列表单元格

CellMultiCopyList = {
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMultiCopyList:_init()
	self.m_root = nil  			--Cell的根节点
    self.m_tData = nil          --数据表 key:[1][2][3]存放的value为3个难度的本地数据表，key:[userData]存放的value为用户进度数据表（星星数、已通过次数）
    self.callBack = nil --点击后的回调
	self.loadEnd = false
	self.selState = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMultiCopyList:_unInit()
	self.m_root = nil
    self.m_tData = nil
    self.callBack = nil
	self.loadEnd = false
	self.selState = false
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMultiCopyList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMultiCopyList table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(418,184))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj

--	local tNewObj = self:_new()
--	assert(tNewObj, "CellMultiCopyList table create failed!")
--	tNewObj:_init()
--	local element = WZUISystem:getInstance():createElement("CellMultiCopyList")
--	assert(element, "CellMultiCopyList element create failed!")
--	element:setLuaObjectIndex(tNewObj)
--	tNewObj.m_root = element
--	return element,tNewObj
end

--@brief	设置数据
function CellMultiCopyList:setData(tData)
    self.m_tData = tData
    self:_update()
end

--@brief	设置点击回调方法
--@param    fCallback,回调方法
function CellMultiCopyList:setClickCallback(element,backFunc)
    self.callBack = {}
    self.callBack[1] = element
    self.callBack[2] = backFunc
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMultiCopyList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------私有方法模块End----------------------------------------