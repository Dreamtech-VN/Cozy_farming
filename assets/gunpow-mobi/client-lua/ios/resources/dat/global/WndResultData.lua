--WndResultData.lua
--@brief	WndResult的数据模块
--@date		2015/09/22
--@author	zsq
--@note		操作结果的图片动画

WndResult = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndResult:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tMsgData = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndResult:_unInit()
	self.m_root = nil
	self.m_tMsgData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndResult:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "WndResult table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("WndResult")
	assert(element, "WndResult element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置确认框的消息数据表
--@param	tMsg，消息数据表，定义见MsgBoxManager.lua中MsgData相关定义
--@note		设置确认框的消息数据表
function WndResult:setMsgData(tMsg)
	self.m_tMsgData = tMsg
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndResult:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
