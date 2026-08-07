--WndConfirmBoxWithOtherWidgetData.lua
--@brief	WndConfirmBoxWithOtherWidget的数据模块
--@date		2021/11/29
--@author	nijinlin
--@note		一个弹框提示，可以添加其他控件

WndConfirmBoxWithOtherWidget = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndConfirmBoxWithOtherWidget:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tMsgData = nil		--确认框的消息数据表
    self.m_action = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndConfirmBoxWithOtherWidget:_unInit()
	self.m_root = nil
	self.m_tMsgData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndConfirmBoxWithOtherWidget:createElement()
	-- local tNewObj = self:_new()
	-- assert(tNewObj, "WndConfirmBoxWithOtherWidget table create failed!")
	-- tNewObj:_init()
	-- local element = WZUISystem:getInstance():createElement("WndConfirmBoxWithOtherWidget")
	-- assert(element, "WndConfirmBoxWithOtherWidget element create failed!")
	-- element:setLuaObjectIndex(tNewObj)
	-- tNewObj.m_root = element
	-- return element,tNewObj

	local element = WZUISystem:getInstance():createElement("WndConfirmBoxWithOtherWidget")
	assert(element, "WndConfirmBoxWithOtherWidget create element failed!")
	self:_init()
	return element
end

--@brief	设置确认框的消息数据表
--@param	tMsg，消息数据表，定义见MsgBoxManager.lua中MsgData相关定义
--@note		设置确认框的消息数据表
function WndConfirmBoxWithOtherWidget:setMsgData(tMsg)
	WZLog("WndConfirmBoxWithOtherWidget:setMsgData",type(tMsg.fCallbackCancel),tMsg.fCallbackCancel)
	self.m_tMsgData = tMsg
	self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
-- function WndConfirmBoxWithOtherWidget:_new( )
-- 	local tNewObj = {}
-- 	setmetatable(tNewObj, self)
-- 	self.__index = self
-- 	return tNewObj
-- end

--@brief	回调给消息数据里的回调方法
--@param	nResType,响应状态，包括超时、确定、取消，具体定义参见定义参见GlobalDefine中消息组件管理相关定义部分
function WndConfirmBoxWithOtherWidget:_msgCallBack(nResType)
	if self.m_tMsgData == nil then
		return
	end
	if self.m_tMsgData.fCallbackFunc then
		if self.m_tMsgData.tCallbackLuaObj then
			self.m_tMsgData.fCallbackFunc(self.m_tMsgData.tCallbackLuaObj, self.m_tMsgData.nId, nResType)
		else
			self.m_tMsgData.fCallbackFunc(self.m_tMsgData.nId, nResType)
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------
