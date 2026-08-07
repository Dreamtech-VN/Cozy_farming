--CellPageListData.lua
--@brief	CellPageList的数据模块
--@date		2013/12/22
--@author	林庆凯
--@note		用来显示好友列表上一页，下一页的控件

CellPageList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPageList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_sTxtContent = nil    --存储上一页还是下一页的变量
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPageList:_unInit()
	self.m_root = nil
	self.m_sTxtContent = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPageList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPageList table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPageList")
	assert(element, "CellPageList element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置上一页还是下一页的函数 
--@param  sTxtContent  上一页还是下页的内容
function CellPageList:setTxtPageContent(sTxtContent)
	self.m_sTxtContent = sTxtContent
	self:_update()
end 

--@brief	返回是上一页还是下一页的函数 
--@param  sTxtContent  返回是上一页还是下一页的内容
function CellPageList:getTxtPageContent(sTxtContent)
	return self.m_sTxtContent 
end 

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPageList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
