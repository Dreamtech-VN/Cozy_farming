--CellDailyTaskData.lua
--@brief	CellDailyTask的数据模块
--@date		2014/09/05
--@author	SuYuan
--@note		每日任务Cell

CellDailyTask = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellDailyTask:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTaskData = {}				--任务数据
	--self.n_nowTaskLevel = 1
	self.tData = {}
	self.m_parentelement = nil
	self.b_adaptLanguage_en = false
	self.b_adaptLanguage_vn = false
	self.b_adaptLanguage_pt = false
	self.b_CanToUI = false  --可以界面跳转
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDailyTask:_unInit()
	self.m_root = nil
	self.m_tTaskData = nil
	--self.n_nowTaskLevel = nil
	self.tData = nil
	self.m_parentelement = nil
	self.b_adaptLanguage_en = false
	self.b_adaptLanguage_vn = false
	self.b_adaptLanguage_pt = false
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellDailyTask:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellDailyTask table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellDailyTask")
	assert(element, "CellDailyTask create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellDailyTask:_new()
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------



