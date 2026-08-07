--CellRechargeAndroid.lua
--@brief	CellRechargeAndroid的UI模块
--@date		2014/08/13
--@author	Android充值模块
--@note		Android充值模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRechargeAndroid:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRechargeAndroid:onExit(element)
	self:_unInit()
end

--@brief	复选框点击回调函数
function CellRechargeAndroid:onCheckClick(element)
	element = WZUICheckBox:luaTo(element)
	local checkIndex = element:getCheckIndex()
	local tag = self.m_root:getTag()
	WZLog("checkIndex::::",checkIndex,tag)
	element:setCheckIndex(0)
	if self.m_tBackFun and #self.m_tBackFun ~= 0 then
		self.m_tBackFun[2](self.m_tBackFun[1],element,checkIndex,tag)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数函数
function CellRechargeAndroid:_update()
	if self.m_root == nil then
		return
	end
	self:_showBtnDesc()--显示文本内容
end

--@brief	显示文本内容
function CellRechargeAndroid:_showBtnDesc()
	local txtName = self.m_root:getChildElement("txtName_CellRechargeAndroid")
	self:_setTxtProperty(txtName,self.m_nDesc)
end


-------------------------------------私有方法模块End----------------------------------------
