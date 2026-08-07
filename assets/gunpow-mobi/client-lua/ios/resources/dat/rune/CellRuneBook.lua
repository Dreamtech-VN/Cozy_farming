--CellRuneBook.lua
--@brief	CellRuneBook的UI模块
--@date		2017/03/15
--@author	peiting_mao
--@note		符文图鉴


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRuneBook:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRuneBook:onExit(element)
	self:_unInit()
end

function CellRuneBook:onLoadData(  )
	local element = WZUISystem:getInstance():createElement("CellRuneBook")
	self.m_root:addChild(element)
	self:_update()
	self:_adaptSize()
	AdaptLanguage(self)
end

function CellRuneBook:_update( )
	local txtNum = GetElement(self.m_root,"txtNum_CellRuneBook",WZUILabelTTF)
	local txtName = GetElement(self.m_root,"txtName_CellRuneBook",WZUILabelTTF)
 	GetElement(self.m_root,"imgRune_CellRuneBook",WZUIImage):setFile(self.item.icon)
	txtName:setText(self.item.name)
	txtName:setColor(QUALITYCOLOR[self.item.quality])
	for i=1,#self.item.property do
	 	GetElement(self.m_root,"txtPro"..i.."_CellRuneBook",WZUILabelTTF):setText(ATTR_TITLE[self.item.property[i][1]])
	 	GetElement(self.m_root,"txtValue"..i.."_CellRuneBook",WZUILabelTTF):setText("+"..self.item.property[i][2])
	end 
	if self.isHad then --判断是否拥有符文
		txtNum:setText("×"..self.num)
	else
		GetElement(self.m_root,"img_CellRuneBook",WZUIImage):setVisible(true)
		txtNum:setText(LocalStrings.NO_GET_WORDS)
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" then
			txtNum:setFontSize(16)
		end
	end
end

--@brief	点击符文事件
function CellRuneBook:onClick( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.isHad then 
		WndSingleSellRune:showWindow(self.item,self.isUsed,self.num)
	else
		MsgBoxManager:showTipBox(LocalStrings.RUNEBOOK10)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellRuneBook:_adaptSize(  )
	local con = GetElement(self.m_root,"CellRuneBook",WZUIContainer)
	local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
	-- if screenSize.width == 1136 then
	-- 	con:setNoBorder(true)
	-- elseif screenSize.width == 1024 then
	-- 	con:setShowAll(true)
	-- elseif screenSize.width >= 1136 then
	-- 	con:setNoBorder(true)
	-- end
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-----------------------------------------
function CellRuneBook:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtName_CellRuneBook",WZUILabelTTF):setFontSize(14)
	for i=1,3 do
		GetElement(self.m_root,"txtPro"..i.."_CellRuneBook",WZUILabelTTF):setFontSize(15)
	end
end

function CellRuneBook:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtName_CellRuneBook",WZUILabelTTF):setFontSize(16)
	for i=1,3 do
		GetElement(self.m_root,"txtPro"..i.."_CellRuneBook",WZUILabelTTF):setFontSize(15)
	end
end

function CellRuneBook:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtName_CellRuneBook",WZUILabelTTF):setFontSize(14)
	for i=1,3 do
		GetElement(self.m_root,"txtPro"..i.."_CellRuneBook",WZUILabelTTF):setFontSize(15)
	end
end

function CellRuneBook:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtName_CellRuneBook",WZUILabelTTF):setFontSize(14)
	for i=1,3 do
		GetElement(self.m_root,"txtPro"..i.."_CellRuneBook",WZUILabelTTF):setFontSize(15)
	end
end
-------------------------------------语言适配End_------------------------------------------