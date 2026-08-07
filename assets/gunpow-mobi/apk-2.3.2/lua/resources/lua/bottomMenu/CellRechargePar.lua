--CellRechargePar.lua
--@brief	CellRechargePar的UI模块
--@date		2014/08/13
--@author	liangguang_long
--@note		liangguang_long


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRechargePar:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRechargePar:onExit(element)
	self:_unInit()
end

--@brief	复选框回调函数
function CellRechargePar:onCheckClick(element)
	local tag = self.m_root:getTag()
	element = WZUICheckBox:luaTo(element)
	element:setCheckIndex(0)
	if self.m_backFun then
		self.m_backFun[2](self.m_backFun[1],element,tag,self.m_nDesc)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function CellRechargePar:_update()
	if self.m_root == nil then
		return
	end
	self:_setPay(self.m_nDesc.."元")
end

--@brief	设置面值
function CellRechargePar:_setPay(txt)
	local txtPar = self.m_root:getChildElement("txtPar_CellRechargePar")
	if txtPar then
		txtPar = WZUILabelTTF:luaTo(txtPar)
		txtPar:setText(txt)
	end
end



-------------------------------------私有方法模块End----------------------------------------
