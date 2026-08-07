--WndEditBoxData.lua
--@brief	WndEditBox的数据模块
--@date		2015-7-31
--@author	binshao
--@note		EditBox输入窗口

WndEditBox = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndEditBox:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_lpOkCallBack = nil			--查找房间回调
	self.m_tCallbackTable = nil			--回调表
    self.m_tCallbackArg = nil           --回调透传的参数
	self.m_tData = nil 					--数据
	self.m_tOther = nil
    self.editType = 1
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndEditBox:_unInit()
	self.m_root = nil
	self.m_lpOkCallBack = nil
	self.m_tCallbackTable = nil
	self.m_sTitle = nil
	self.m_tData = nil
	self.m_tOther = nil
    self.editType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndEditBox:createElement()
	local element = WZUISystem:getInstance():createElement("WndEditBox")
	assert(element, "WndEditBox create element failed!")
	self:_init()
	return element
end

--@brief	设置完成回调函数
--@param	callback:回调函数的引用
--@param	tLuaObj:回调函数所属表对象
--@param	...:需要透传的其他参数
--@note		主要用于外部回调之用
function WndEditBox:setOkCallBack(callback,tLuaObj, ...)
	self.m_lpOkCallBack = callback
	self.m_tCallbackTable = tLuaObj
    self.m_tCallbackArg = {...}
end

--@brief	设置数据
--@param	title:输入框标题
--@param	editStr:输入框内部文字
--@param	strPs:提示文字
function WndEditBox:setData(editStr,placeHolder,title, strPs)
    self.m_tData = {}
    self.m_tData.title = title or ""
    self.m_tData.editStr = editStr or ""
    self.m_tData.placeHolder = placeHolder or ""
    self.m_tData.strPs = strPs
    self:_update()
end

--@brief	设置其它数据，用于回调使用
function WndEditBox:setOtherData(tData)
	self.m_tOther = tData
end

function WndEditBox:setEditType(_type)
    self.editType = _type or 1
end

--@brief 	外部接口
function WndEditBox:showInterface(_type, editStr, placeHolder, title, otherData, callback, tLuaObj, ...)
	-- body
	if self.m_root == nil then 
		local element = WndEditBox:createElement()
		if element then 
			self:setEditType(_type)
			self:setOkCallBack(callback, tLuaObj, ...)
			self:setOtherData(otherData)
			self:setData(editStr, placeHolder, title)
			WindowManager:addWindow(element, WndEditBox)
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndEditBox:_policy()
	local tCell
	tCell = self.m_root:getChildElement("editRoomId_WndEditBox")
	self:_setPolicyProperty(tCell)
	tCell = nil 
end

--中文策略属性
function WndEditBox:_setPolicyProperty(tCell,bPolicy)
	if self.m_root == nil or tCell == nil then
		return
	end
	bPolicy = bPolicy or false
	tCell = WZUIEditBox:luaTo(tCell)
	tCell:setSupportMultiChar(bPolicy)
end



-------------------------------------私有方法模块End----------------------------------------
