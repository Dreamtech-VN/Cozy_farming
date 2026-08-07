--CellRuneType.lua
--@brief	CellRuneType的UI模块
--@date		2017/03/22
--@author	peiting_mao
--@note		符文图鉴类型


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRuneType:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRuneType:onExit(element)
	self:_unInit()
end

function CellRuneType:onLoadData(  )
	local element = WZUISystem:getInstance():createElement("CellRuneType")
	self.m_root:addChild(element)
	if self.tag == 0 then
		GetElement(self.m_root,"conSel_CellRuneType",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"con_CellRuneType",WZUIContainer):setVisible(false)
		WndRuneBook.preCell = self
	end
	self:_update()
end

function CellRuneType:setIsVisble( isbool )
	if not isbool then
	-- 	GetElement(self.m_root,"conSel_CellRuneType",WZUIContainer):setVisible(true)
	-- 	GetElement(self.m_root,"con_CellRuneType",WZUIContainer):setVisible(false)
	-- else
		GetElement(self.m_root,"conSel_CellRuneType",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"con_CellRuneType",WZUIContainer):setVisible(true)
	end
end

--@brief	点击图鉴类型按钮事件
function CellRuneType:onSelectType( element )
	WZLog("--CellRuneType:onSelectType1--",WndRuneBook.preTag,self.tag)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local con = GetElement(self.m_root,"con_CellRuneType",WZUIContainer)
	local conSel = GetElement(self.m_root,"conSel_CellRuneType",WZUIContainer)
	if WndRuneBook.preTag ~= self.tag then 
		WZLog("--CellRuneType:onSelectType2--",WndRuneBook.preTag,self.tag)
		--return 
	--else
		con:setVisible(false)
		conSel:setVisible(true)
		WndRuneBook.preTag = self.tag
		WndRuneBook:onSelect(WndRuneBook.preCell,self)
		WndRuneBook:_update(self.tag)
	end
end

function CellRuneType:_update(  )
	local txt1 = GetElement(self.m_root,"txt_CellRuneType",WZUILabelTTF)
	local txt2 = GetElement(self.m_root,"txtSel_CellRuneType",WZUILabelTTF)
	if self.tag == 0 then
		txt1:setText(LocalStrings.CHAT_ALL)
		txt2:setText(LocalStrings.CHAT_ALL)
	else
		txt1:setText(ATTR_TITLE[self.tag])
		txt2:setText(ATTR_TITLE[self.tag])
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
