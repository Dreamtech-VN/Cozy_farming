--CellFootMark1Data.lua
--@brief	CellFootMark1的数据模块
--@date		2021/03/04
--@author	hyc
--@note		足迹item

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
CellFootMark1 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellFootMark1:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil 
	self.loadEnd = false	-- 是否加载完成
	self.selState = false	-- 设置选中状态
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFootMark1:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.loadEnd = nil		-- 是否加载完成
	self.selState = nil		-- 设置选中状态
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellFootMark1:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFootMark1 table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(450,100))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

-- 设置cell中的内容
function CellFootMark1:setCellAllElement(tInfo)
    self.m_tData = tInfo
end

function CellFootMark1:updateData(tInfo)
	self.m_tData = tInfo
	if self.loadEnd then 
		self:_update()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFootMark1:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end


-------------------------------------私有方法模块End----------------------------------------
