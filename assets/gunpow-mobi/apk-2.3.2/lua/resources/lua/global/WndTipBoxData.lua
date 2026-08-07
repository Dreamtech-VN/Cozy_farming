--WndTipBoxData.lua
--@brief	WndTipBox的数据模块
--@date		2013/12/18
--@author	xiaoyu_wu
--@note		提示框模块

WndTipBox = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndTipBox:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tMsgData = nil		--提示框的消息数据表
    self.m_bIsRemoveOne = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTipBox:_unInit()
	self.m_root = nil
	self.m_tMsgData = nil
    self.m_bIsRemoveOne = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndTipBox:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "WndTipBox table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("WndTipBox")
	assert(element, "WndTipBox element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndTipBox:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	设置提示框的消息数据表
--@param	tMsg，消息数据表，定义见MsgBoxManager.lua中MsgData相关定义
--@note		设置提示框的消息数据表
function WndTipBox:setMsgData(tMsg)
    if self.m_root ~= nil then
        self.m_root:removeFromParentAndCleanup(true)
    end
	local nOrder = 20000
	nOrder = tMsg.order or nOrder
    --local element = self:createElement()
    --WindowManager:getSceneRoot():addChild(element,nOrder)

	if tMsg.GrayRender == true then
		GetElement(self.m_root,"imgBg_WndTipBox",WZUI9Image):setGrayRender(true)
	else
		GetElement(self.m_root,"imgBg_WndTipBox",WZUI9Image):setGrayRender(false)
	end
	
--	local view = CCEGLView:sharedOpenGLView()
--	local x = view:getScaleX()
--	local y = view:getScaleY()
--	local minScale = math.min(x,y)
--	x = minScale/x
--	y = minScale/y
--	local tRoot = WZUIElementContainer:luaTo(self.m_root)
--	tRoot:setScaleX(x)
--	tRoot:setScaleY(y)

    self.m_bIsRemoveOne = tMsg.isRemoveOne
	self.m_tMsgData = tMsg
	self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndTipBox:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	回调给消息数据里的回调方法
--@param	nResType,响应状态(超时、确定、取消)，具体定义参见定义参见GlobalDefine中消息组件管理相关定义部分
function WndTipBox:_msgCallBack(nResType)
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

--@brief	中文语包适配函数
function WndTipBox:_adaptLanguage_cn()
	if self.m_root == nil then return end
	local txtTip = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtTip_WndTipBox"))
	--txtTip:setMaxLength(30)
end

--@brief	越南语包适配函数
function WndTipBox:_adaptLanguage_vn()
	if self.m_root == nil then return end
	local txtTip = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtTip_WndTipBox"))
	txtTip:setMaxLength(72)
end

--@brief	葡语包适配函数
function WndTipBox:_adaptLanguage_pt()
	if self.m_root == nil then return end
	local txtTip = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtTip_WndTipBox"))
	txtTip:setMaxLength(64)
end
-------------------------------------私有方法模块End----------------------------------------
