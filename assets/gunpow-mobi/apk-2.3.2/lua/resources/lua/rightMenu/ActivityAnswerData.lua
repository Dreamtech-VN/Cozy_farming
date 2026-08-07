--ActivityAnswerData.lua
--@brief	ActivityAnswer的数据模块
--@date		2020/09/22
--@author	hyx
--@note		活动界面-趣味答题

ActivityAnswer = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function ActivityAnswer:_init()
	self.m_root = nil	 	  			--场景根节点
	self.startTime = nil
	self.endTime = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function ActivityAnswer:_unInit()
	self.m_root = nil
	self.startTime = nil
	self.endTime = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function ActivityAnswer:createElement()
	if ActivityAnswer.m_root ~= nil then
		WindowManager:removeWindow(ActivityAnswer.m_root, ActivityAnswer, true)
	end
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("ActivityAnswer")
	assert(element, "ActivityAnswer create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end
--@brief    初始化信息
function ActivityAnswer:setMessage(startTime, endTime)
	self.startTime = startTime
	self.endTime = endTime
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function ActivityAnswer:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end



-------------------------------------私有方法模块End----------------------------------------
