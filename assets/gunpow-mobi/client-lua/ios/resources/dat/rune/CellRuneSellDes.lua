--CellRuneSellDes.lua
--@brief	CellRuneSellDes的UI模块
--@date		2017/03/27
--@author	peiting_mao
--@note		符文出售详情


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRuneSellDes:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRuneSellDes:onExit(element)
	self:_unInit()
end

function CellRuneSellDes:onLoadData(  )
	local element = WZUISystem:getInstance():createElement("CellRuneSellDes")
	self.m_root:addChild(element)
	self:_update()
	AdaptLanguage(self)
end

--@brief 	点击选中或取消选中
function CellRuneSellDes:onClick(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local imgGou = GetElement(self.m_root, "imgGou_CellRuneSellDes", WZUIImage)
	imgGou:setVisible(not imgGou:isVisible())

	WndSellRune:resetRuneChooseState(WndSellDes.m_nTag, self.item)
end

function CellRuneSellDes:_update(  )
	local txtNum = GetElement(self.m_root,"txtNum_CellRuneSellDes",WZUILabelTTF)
	local txtName = GetElement(self.m_root,"txtName_CellRuneSellDes",WZUILabelTTF)
 	txtNum:setText("×"..self.item.runeNum)
	txtName:setText(self.item.name)
	txtName:setColor(QUALITYCOLOR[self.item.quality])
	for i=1,#self.item.property do
	 	GetElement(self.m_root,"txtPro"..i.."_CellRuneSellDes",WZUILabelTTF):setText(ATTR_TITLE[self.item.property[i][1]])
	 	GetElement(self.m_root,"txtValue"..i.."_CellRuneSellDes",WZUILabelTTF):setText("+"..self.item.property[i][2])
	end 
	GetElement(self.m_root,"imgRune_CellRuneSellDes",WZUIImage):setFile(self.item.icon)

	self:setChooseState(self.item.bChoose)
end

--@brief 	设置选中状态
function CellRuneSellDes:setChooseState(bIsChoose)
	-- body
	local imgGou = GetElement(self.m_root, "imgGou_CellRuneSellDes", WZUIImage)
	if imgGou then
		imgGou:setVisible(bIsChoose)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellRuneSellDes:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtPro1_CellRuneSellDes",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.06,0.601563))
	GetElement(self.m_root,"txtPro2_CellRuneSellDes",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.06,0.390625))
	GetElement(self.m_root,"txtPro3_CellRuneSellDes",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.06,0.179688))
	GetElement(self.m_root,"txtValue1_CellRuneSellDes",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.588172,0.59375))
	GetElement(self.m_root,"txtValue2_CellRuneSellDes",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.588172,0.390625))
	GetElement(self.m_root,"txtValue3_CellRuneSellDes",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.588172,0.179688))
end

function CellRuneSellDes:_adaptLanguage_pt(  )
	local txtName = GetElement(self.m_root,"txtName_CellRuneSellDes",WZUILabelTTF)
	txtName:setScale(0.65)
	txtName:setDimensions(GlobalMethod:CCSize(180))

	local txtPro1 = GetElement(self.m_root,"txtPro1_CellRuneSellDes",WZUILabelTTF)
	txtPro1:setScale(0.9)
	txtPro1:setRelativePosition(GlobalMethod:ccp(0.06,0.601563))
	local txtPro2 = GetElement(self.m_root,"txtPro2_CellRuneSellDes",WZUILabelTTF)
	txtPro2:setScale(0.9)
	txtPro2:setRelativePosition(GlobalMethod:ccp(0.06,0.390625))
	local txtPro3 = GetElement(self.m_root,"txtPro3_CellRuneSellDes",WZUILabelTTF)
	txtPro3:setScale(0.9)
	txtPro3:setRelativePosition(GlobalMethod:ccp(0.06,0.179688))
	local txtValue1 = GetElement(self.m_root,"txtValue1_CellRuneSellDes",WZUILabelTTF)
	txtValue1:setScale(0.9)
	txtValue1:setRelativePosition(GlobalMethod:ccp(0.628,0.59375))
	local txtValue2 = GetElement(self.m_root,"txtValue2_CellRuneSellDes",WZUILabelTTF)
	txtValue2:setScale(0.9)
	txtValue2:setRelativePosition(GlobalMethod:ccp(0.628,0.390625))
	local txtValue3 = GetElement(self.m_root,"txtValue3_CellRuneSellDes",WZUILabelTTF)
	txtValue3:setScale(0.9)
	txtValue3:setRelativePosition(GlobalMethod:ccp(0.628,0.179688))
end

function CellRuneSellDes:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtName_CellRuneSellDes",WZUILabelTTF):setFontSize(14)
end

function CellRuneSellDes:_adaptLanguage_es(  )
	local txtName = GetElement(self.m_root,"txtName_CellRuneSellDes",WZUILabelTTF)
	txtName:setScale(0.65)
	txtName:setDimensions(GlobalMethod:CCSize(180))

	local txtPro1 = GetElement(self.m_root,"txtPro1_CellRuneSellDes",WZUILabelTTF)
	txtPro1:setScale(0.8)
	txtPro1:setRelativePosition(GlobalMethod:ccp(0.06,0.601563))
	local txtPro2 = GetElement(self.m_root,"txtPro2_CellRuneSellDes",WZUILabelTTF)
	txtPro2:setScale(0.8)
	txtPro2:setRelativePosition(GlobalMethod:ccp(0.06,0.390625))
	local txtPro3 = GetElement(self.m_root,"txtPro3_CellRuneSellDes",WZUILabelTTF)
	txtPro3:setScale(0.8)
	txtPro3:setRelativePosition(GlobalMethod:ccp(0.06,0.179688))
	local txtValue1 = GetElement(self.m_root,"txtValue1_CellRuneSellDes",WZUILabelTTF)
	txtValue1:setScale(0.8)
	txtValue1:setRelativePosition(GlobalMethod:ccp(0.7,0.59375))
	local txtValue2 = GetElement(self.m_root,"txtValue2_CellRuneSellDes",WZUILabelTTF)
	txtValue2:setScale(0.8)
	txtValue2:setRelativePosition(GlobalMethod:ccp(0.7,0.390625))
	local txtValue3 = GetElement(self.m_root,"txtValue3_CellRuneSellDes",WZUILabelTTF)
	txtValue3:setScale(0.8)
	txtValue3:setRelativePosition(GlobalMethod:ccp(0.7,0.179688))
end

function CellRuneSellDes:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtPro1_CellRuneSellDes",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtPro2_CellRuneSellDes",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtPro3_CellRuneSellDes",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtValue1_CellRuneSellDes",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtValue2_CellRuneSellDes",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtValue3_CellRuneSellDes",WZUILabelTTF):setScale(0.8)
end

function CellRuneSellDes:_adaptLanguage_tr(  )
	local txtName = GetElement(self.m_root,"txtName_CellRuneSellDes",WZUILabelTTF)
	txtName:setScale(0.65)
	txtName:setDimensions(GlobalMethod:CCSize(180))

	local txtPro1 = GetElement(self.m_root,"txtPro1_CellRuneSellDes",WZUILabelTTF)
	txtPro1:setScale(0.7)
	txtPro1:setRelativePosition(GlobalMethod:ccp(0.06,0.601563))
	local txtPro2 = GetElement(self.m_root,"txtPro2_CellRuneSellDes",WZUILabelTTF)
	txtPro2:setScale(0.7)
	txtPro2:setRelativePosition(GlobalMethod:ccp(0.06,0.390625))
	local txtPro3 = GetElement(self.m_root,"txtPro3_CellRuneSellDes",WZUILabelTTF)
	txtPro3:setScale(0.7)
	txtPro3:setRelativePosition(GlobalMethod:ccp(0.06,0.179688))
	local txtValue1 = GetElement(self.m_root,"txtValue1_CellRuneSellDes",WZUILabelTTF)
	txtValue1:setScale(0.7)
	txtValue1:setRelativePosition(GlobalMethod:ccp(0.628,0.59375))
	local txtValue2 = GetElement(self.m_root,"txtValue2_CellRuneSellDes",WZUILabelTTF)
	txtValue2:setScale(0.7)
	txtValue2:setRelativePosition(GlobalMethod:ccp(0.628,0.390625))
	local txtValue3 = GetElement(self.m_root,"txtValue3_CellRuneSellDes",WZUILabelTTF)
	txtValue3:setScale(0.7)
	txtValue3:setRelativePosition(GlobalMethod:ccp(0.628,0.179688))
end
---------------------------------------语言适配End------------------------------------------
