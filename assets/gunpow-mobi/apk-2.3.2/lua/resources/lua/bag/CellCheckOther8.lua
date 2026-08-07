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

function CellCheckOther8:onClickTips(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = {}
	if self.m_nType == 1 then --坐骑
		tData = {id = 71}
		WndTips:show(element,WndCheckOther.m_root,67,tData,GlobalMethod:ccp(220,30),true,false)
	elseif self.m_nType == 5 then --足迹
		tData = {id = 72}
		WndTips:show(element,WndCheckOther.m_root,67,tData,GlobalMethod:ccp(220,30),true,false)
	elseif self.m_nType == 6 then --幻化
		tData = {id = 73}
		WndTips:show(element,WndCheckOther.m_root,67,tData,GlobalMethod:ccp(220,30),true,false)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新标题
function CellCheckOther8:update()
	if self.m_root == nil then return end
	local conTitle = GetElement(self.m_root, "conTitle_CellCheckOther8", WZUIContainer)
	local conLine = GetElement(self.m_root, "conLine_CellCheckOther8", WZUIContainer)
	local conSize = conTitle:getAbsContentSize()
	local conSizeLine = conLine:getAbsContentSize()
	if self.m_nRowNum > 1 then 
		conTitle:setAbsContentSize(GlobalMethod:CCSize(conSize.width, conSize.height * self.m_nRowNum))
		conTitle:updateRelativeSize()
		conLine:setAbsContentSize(GlobalMethod:CCSize(conSizeLine.width, conSizeLine.height * self.m_nRowNum))
		conLine:updateRelativeSize()
	end

	local txtTitle = GetElement(self.m_root, "txtTitle_CellCheckOther8", WZUILabelTTF)
	txtTitle:setText(self.m_sTitle)
	if (self.m_nType == 8 or self.m_nType == 7) and self.m_nRowNum == 1 then 
		txtTitle:setFontSize(16)
		txtTitle:setDimensions(GlobalMethod:CCSize(36,0))
	elseif self.m_nType == 1 or self.m_nType == 5 or self.m_nType == 6 then 
		GetElement(self.m_root, "btn_CellCheckOther8", WZUIButton):setVisible(true)
		GetElement(self.m_root, "imgTitle_CellCheckOther8", WZUIImage):setVisible(true)
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function CellCheckOther8:_adaptLanguage_vn(  )
	local txtTitle = GetElement(self.m_root, "txtTitle_CellCheckOther8", WZUILabelTTF)
	if txtTitle then
		txtTitle:setScale(0.6)
		txtTitle:setDimensions(GlobalMethod:CCSize(60))
	end
end

function CellCheckOther8:_adaptLanguage_tr(  )
	local txtTitle = GetElement(self.m_root, "txtTitle_CellCheckOther8", WZUILabelTTF)
	if txtTitle then
		txtTitle:setScale(0.8)
		txtTitle:setRelativePosition(GlobalMethod:ccp(0.01,0.8))
	end
end

function CellCheckOther8:_adaptLanguage_ug(  )
	local txtTitle = GetElement(self.m_root, "txtTitle_CellCheckOther8", WZUILabelTTF)
	if txtTitle then
		txtTitle:setScale(0.7)
		txtTitle:setRelativePosition(GlobalMethod:ccp(0.00560975,0.760714))
	end
end
-------------------------------------语言适配End----------------------------------------
