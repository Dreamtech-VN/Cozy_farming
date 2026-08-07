--CellCircleBottomLine.lua
--@brief	CellCircleBottomLine的UI模块
--@date		2020/07/10
--@author	XTX
--@note		朋友圈的分割线


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCircleBottomLine:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCircleBottomLine:onExit(element)
	self:_unInit()
end

--@brief 	加载
function CellCircleBottomLine:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellCircleBottomLine")
	self.m_root:addChild(celElement)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
