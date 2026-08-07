--cellChristmasSonData.lua
--@brief	cellChristmasSon的数据模块
--@date		2020/12/08
--@author	hyc
--@note		圣诞狂欢子item

cellChristmasSon = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function cellChristmasSon:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_activityId = 0	--活动id
	self.m_rewardId = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function cellChristmasSon:_unInit()
	self.m_root = nil
	self.m_activityId = nil	--活动id
	self.m_rewardId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function cellChristmasSon:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "cellChristmasSon table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("cellChristmasSon")
	assert(element, "cellChristmasSon element create failed")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj

end

function cellChristmasSon:setMessage(activityId,rewarid)
	self.m_activityId = activityId
	self.m_rewardId = rewarid
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function cellChristmasSon:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end