--CellAboutData.lua
--@brief	CellAbout的数据模块
--@date		2014/03/25
--@author	liangguang_long
--@note		微博模块

CellAbout = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellAbout:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tAbout = nil 		--关于列表
	self.m_tCell = nil 			--回调节点
	self.m_sBackFun = nil 	 	--回调函数
	self.m_sURL = nil 			--微博URL
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellAbout:_unInit()
	self.m_root = nil
	self.m_tAbout = nil 		--关于列表
	self.m_tCell = nil 			--回调节点
	self.m_sBackFun = nil 	 	--回调函数
	self.m_sURL = nil 			--微博URL
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellAbout:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellAbout table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellAbout")
	assert(element, "CellAbout element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置关于基本数据
--@param	tCell：回调节点
--@param	backFun：回调函数名
--@param	norIcon：正常状态图片路径
--@param	selIcon：选择状态图片路径
--@param	url：url微博网址路径
function CellAbout:setAboutData(tCell , backFun , norIcon , selIcon , url)
	self.m_tAbout = {}
	table.insert(self.m_tAbout , norIcon)
	table.insert(self.m_tAbout , selIcon)
	self.m_tCell = tCell			--回调节点
	self.m_sBackFun = backFun	 	--回调函数
	self.m_sURL = url     
	--更新函数
	self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellAbout:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
