--CellCheckOther8.lua
--@brief	CellCheckOther8的UI模块
--@date		2015/07/06
--@author	zsq
--@note		玩家信息栏2


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOther8:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOther8:onExit(element)
	self:_unInit()
end

--@brief 	开始加载
function CellCheckOther8:onLoadData(element)
	-- body
	local cellElement = WZUISystem:getInstance():createElement("CellCheckOther8")

	self.m_root:addChild(cellElement)

	self:update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新标题
function CellCheckOther8:update()
	if self.m_root == nil then return end

	GetElement(self.m_root, "txtTitle_CellCheckOther8", WZUILabelTTF):setText(self.m_sTitle)
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function CellCheckOther8:_adaptLanguage_vn(  )
	local txtTitle = GetElement(self.m_root, "txtTitle_CellCheckOther8", WZUILabelTTF)
	if txtTitle then
		txtTitle:setScale(0.7)
		txtTitle:setRelativePosition(GlobalMethod:ccp(0.0129268,0.846429))
	end
end

function CellCheckOther8:_adaptLanguage_tr(  )
	local txtTitle = GetElement(self.m_root, "txtTitle_CellCheckOther8", WZUILabelTTF)
	if txtTitle then
		txtTitle:setRelativePosition(GlobalMethod:ccp(0.01,0.8))
	end
end

-------------------------------------语言适配End----------------------------------------
