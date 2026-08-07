--WndLoadingBoxData.lua
--@brief	WndLoadingBox的数据模块
--@date		2013/12/19
--@author	xiaoyu_wu
--@note		加载框模块

WndLoadingBox = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndLoadingBox:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tClose = nil			--关闭回调函数
    self.m_nShowNetLostTime = -1 --战斗掉线Mark
    self.m_nShowNetLost = nil   --战斗掉线Mark
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLoadingBox:_unInit()
	self.m_root = nil
	self.m_tClose = nil			--关闭回调函数
    self.m_nShowNetLostTime = -1 --战斗掉线Mark
    self.m_nShowNetLost = nil   --战斗掉线Mark
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndLoadingBox:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "WndLoadingBox table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("WndLoadingBox")
	assert(element, "WndLoadingBox element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置加载框的消息数据表
--@param	tMsg，消息数据表，定义见MsgBoxManager.lua中MsgData相关定义
--@note		设置加载框的消息数据表
function WndLoadingBox:setMsgData(tMsg)
	self.m_tMsgData = tMsg
end

--@brief	设置加载框关闭回调函数
function WndLoadingBox:setCloseBackFun(tCell,backFun)
	if tCell and backFun then
		self.m_tClose = {}--关闭回调函数
		self.m_tClose[1] = tCell
		self.m_tClose[2] = backFun
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndLoadingBox:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	回调给消息数据里的回调方法
--@param	nResType,响应状态，包括超时、确定、取消，具体定义参见定义参见GlobalDefine中消息组件管理相关定义部分
function WndLoadingBox:_msgCallBack(nResType)
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
