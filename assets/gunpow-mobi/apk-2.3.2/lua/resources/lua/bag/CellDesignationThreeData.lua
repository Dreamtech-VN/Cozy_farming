--CellDesignationThreeData.lua
--@brief	CellDesignationThree的数据模块
--@date		2015/03/27
--@author	clc
--@note		成就系统-称号面板-称号cell

CellDesignationThree = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellDesignationThree:_init()
	self.m_root         = nil   --Cell的根节点
	self.n_JobId      = -1      --子成就Id
	self.n_CellType   = -1      --1为主分类，2为之分类。此Cell中永远是2
	self.m_bIsLoad  = false   --是否已加载
	self.m_tData = nil 			--cell中数据
	self.m_bGouVisible = nil 
	self.m_bRedDotVisible = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDesignationThree:_unInit()
	self.m_root         = nil
	self.n_JobId      = nil      --子成就Id
	self.n_CellType   = nil      --1为主分类，2为之分类。此Cell中永远是2
	self.m_bIsLoad  = nil   --是否已加载
	self.m_tData = nil 			--cell中数据
	self.m_bGouVisible = nil 
	self.m_bRedDotVisible = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellDesignationThree:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellDesignationThree table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellDesignationThree")
    element:setAbsContentSize(GlobalMethod:CCSize(170,214))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

--@brief 	设置特殊称号数据
function CellDesignationThree:setDesiData(tData)
	-- body
	if self.m_tData == nil then
        self.m_tData = {}
    end

    self.m_tData.id = tData.id
    self.m_tData.desc = tData.desc
    self.m_tData.status = tData.status
    self.m_tData.title = tData.name
    self.m_tData.remain = tData.remain
    self.m_tData.sort = tData.sort
end

--@brief  设置子成就Cell的UI
function  CellDesignationThree:setCellUI(title ,desc, status, reward, nComplete, nTarget)
	-- body
    WZLog("CellDesignationThree:setCellUI",title,status)
    if self.m_tData == nil then
        self.m_tData = {}
    end

    self.m_tData.title = title
    self.m_tData.desc = desc
    self.m_tData.status = status
    self.m_tData.reward = reward
    self.m_tData.nComplete = nComplete
    self.m_tData.nTarget = nTarget
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellDesignationThree:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
