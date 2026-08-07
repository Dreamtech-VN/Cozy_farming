--CellSpaceChoose.lua
--@brief	CellSpaceChoose的UI模块
--@date		2016/01/18
--@author	zsq
--@note		选择cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSpaceChoose:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSpaceChoose:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置数字
function CellSpaceChoose:setDisplay(text)
	if self.m_root == nil then return end
	GetElement(self.m_root,"txt_CellSpaceChoose",WZUILabelTTF):setText(text)
end




-------------------------------------私有方法模块End----------------------------------------
