--CellActivityRedEnvelope.lua
--@brief	CellActivityRedEnvelope的UI模块
--@date		2016/08/11
--@author	Zsq
--@note		红包雨活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellActivityRedEnvelope:onEnter(element)
	self.m_root = element
	--self:update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellActivityRedEnvelope:onExit(element)
	self:_unInit()
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellActivityRedEnvelope:showWindow()

end

function CellActivityRedEnvelope:update()
	WZLog("CellActivityRedEnvelope:update")
	--local text = GetElement(self.m_root,"text_CellActivityRedEnvelope",WZUIFreeTextBox)
	--text:setShowText(string.format(LocalStrings.NEWYEARTIP7,"","",tostring(self.maxCount)))
end


-------------------------------------私有方法模块End----------------------------------------
