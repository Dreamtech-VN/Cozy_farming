--CellKidItem.lua
--@brief	CellKidItem的UI模块
--@date		2018/05/07
--@author	Tianxiang_Xu
--@note		小孩信息展示


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellKidItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellKidItem:onExit(element)
	self:_unInit()
end

--@brief 	点击小孩头像回调
function CellKidItem:onClickHead(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nType == 1 then
		WndKidOperate:onClickBabyHeadCallBack(self, self.m_tData)
	end
end

--@brief 	设置信息的显示和隐藏
function CellKidItem:setInfoState(bVisible)
	-- body
	GetElement(self.m_root, "conInfo_CellKidItem", WZUIContainer):setVisible(bVisible)
	GetElement(self.m_root, "btnHead_CellKidItem", WZUIButton):setVisible(bVisible)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellKidItem:_update()
	-- body
	--小孩头像
	self:setKidHead()
	--小孩名字
	local txtName = GetElement(self.m_root, "txtName_CellKidItem", WZUILabelTTF)
	if txtName then
		txtName:setText(self.m_tData.name)
	end
	--小孩岁数
	self:setKidAge()
	--设置愉悦值
	self:setKidHappiness()
	--父母关爱值
	self:setKidCareValue()

	AdaptLanguage(self)
end

--@brief 	设置小孩头像
function CellKidItem:setKidHead()
	-- body
	local conHead = GetElement(self.m_root, "conHead_CellKidItem", WZUIContainer)
	local kidHead = CellHead:show(conHead, self.m_tData.headId, self.m_tData.faceId, self.m_tData.sex, nil, nil, nil, nil, nil, nil, nil, true)
	kidHead:setScale(1)
end

--@brief 	设置小孩的愉悦值
function CellKidItem:setKidHappiness()
	-- body
	--小孩愉悦值
	local ftxtHappiness = GetElement(self.m_root, "ftxtHappiness_CellKidItem", WZUIFreeTextBox)
	
	if ftxtHappiness then
		if self.m_nType == 1 then
			ftxtHappiness:setShowText(string.format(LocalStrings.KID_TEXT2, self.m_tData.happiness))
		elseif self.m_nType == 2 then
			local sFormat =  [[<T C="255,236,193" S="18" P="1" SC="127,70,26" SS="4" SE="0">%s:</T><T C="255,236,193" S="18" P="1" SC="127,70,26" SS="4" SE="0">%d</T>]]
			local nFighting = self.m_tData.fighting
			ftxtHappiness:setShowText(string.format(sFormat, LocalStrings.BATTLE, nFighting))
		elseif self.m_nType == 3 then
			local sFormat =  [[<T C="255,236,193" S="18" P="1" SC="127,70,26" SS="4" SE="0">%s:</T><T C="255,236,193" S="18" P="1" SC="127,70,26" SS="4" SE="0">%d</T>]]
			local nFighting = self.m_tData.fighting
			ftxtHappiness:setShowText(string.format(sFormat, LocalStrings.BATTLE, nFighting))
		elseif self.m_nType == 5 then
			ftxtHappiness:setShowText(string.format(LocalStrings.KID_TEXT100, self.m_tData.playerName))
		end
	end
end

--@brief 	设置小孩的岁数
function CellKidItem:setKidAge()
	-- body
	--小孩愉悦值
	local ftxtAge = GetElement(self.m_root, "ftxtAge_CellKidItem", WZUIFreeTextBox)
	if ftxtAge then
		ftxtAge:setShowText(string.format(LocalStrings.KID_TEXT1, (self.m_tData.level/10)))
	end
end

--@brief 	设置关爱值
function CellKidItem:setKidCareValue()
	-- body
	--父母关爱值
	local ftxtCareVale = GetElement(self.m_root, "ftxtCareVale_CellKidItem", WZUIFreeTextBox)
	local ftxtCareVale2 = GetElement(self.m_root, "ftxtCareVale2_CellKidItem", WZUIFreeTextBox)
	local ftxtAge = GetElement(self.m_root, "ftxtAge_CellKidItem", WZUIFreeTextBox)
	local ftxtHappiness = GetElement(self.m_root, "ftxtHappiness_CellKidItem", WZUIFreeTextBox)
	if self.m_nType == 3 then
		ftxtCareVale2:setVisible(true)
		ftxtCareVale:setShowText(string.format(LocalStrings.KID_TEXT77, self.m_tData.fatherDevote))
		ftxtCareVale2:setShowText(string.format(LocalStrings.KID_TEXT78, self.m_tData.motherDevote))
		ftxtAge:setRelativePosition(GlobalMethod:ccp(0.37, 0.9))
		ftxtHappiness:setRelativePosition(GlobalMethod:ccp(0.37, 0.63))
		ftxtCareVale:setRelativePosition(GlobalMethod:ccp(0.37, 0.37))
		ftxtCareVale2:setRelativePosition(GlobalMethod:ccp(0.37, 0.1))
	elseif self.m_nType == 5 then
		ftxtCareVale:setVisible(false)
		ftxtCareVale2:setVisible(false)
		
		ftxtAge:setRelativePosition(GlobalMethod:ccp(0.37, 0.7))
		ftxtHappiness:setRelativePosition(GlobalMethod:ccp(0.37, 0.3))
	else
		ftxtCareVale2:setVisible(false)
		if ftxtCareVale then
			ftxtCareVale:setShowText(string.format(LocalStrings.KID_TEXT3, self.m_tData.careValue))
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function CellKidItem:_adaptLanguage_en( )
	local ftxtCareVale = GetElement(self.m_root, "ftxtCareVale_CellKidItem", WZUIFreeTextBox)
	ftxtCareVale:setScale(0.7)
	ftxtCareVale:setMaxWidth(300)
	local ftxtCareVale2 = GetElement(self.m_root, "ftxtCareVale2_CellKidItem", WZUIFreeTextBox)
	ftxtCareVale2:setScale(0.7)
	ftxtCareVale2:setMaxWidth(300)
	local ftxtAge = GetElement(self.m_root, "ftxtAge_CellKidItem", WZUIFreeTextBox)
	ftxtAge:setScale(0.7)
	ftxtAge:setMaxWidth(300)
	local ftxtHappiness = GetElement(self.m_root, "ftxtHappiness_CellKidItem", WZUIFreeTextBox)
	ftxtHappiness:setScale(0.7)
	ftxtHappiness:setMaxWidth(300)
end

function CellKidItem:_adaptLanguage_pt( )
	local ftxtCareVale = GetElement(self.m_root, "ftxtCareVale_CellKidItem", WZUIFreeTextBox)
	ftxtCareVale:setScale(0.65)
	ftxtCareVale:setMaxWidth(210)
	local ftxtCareVale2 = GetElement(self.m_root, "ftxtCareVale2_CellKidItem", WZUIFreeTextBox)
	ftxtCareVale2:setScale(0.65)
	ftxtCareVale2:setMaxWidth(210)
	local ftxtAge = GetElement(self.m_root, "ftxtAge_CellKidItem", WZUIFreeTextBox)
	ftxtAge:setScale(0.65)
	ftxtAge:setMaxWidth(210)
	local ftxtHappiness = GetElement(self.m_root, "ftxtHappiness_CellKidItem", WZUIFreeTextBox)
	ftxtHappiness:setScale(0.65)
	ftxtHappiness:setMaxWidth(210)
end

function CellKidItem:_adaptLanguage_es( )
	local ftxtCareVale = GetElement(self.m_root, "ftxtCareVale_CellKidItem", WZUIFreeTextBox)
	ftxtCareVale:setScale(0.65)
	ftxtCareVale:setMaxWidth(210)
	local ftxtCareVale2 = GetElement(self.m_root, "ftxtCareVale2_CellKidItem", WZUIFreeTextBox)
	ftxtCareVale2:setScale(0.65)
	ftxtCareVale2:setMaxWidth(210)
	local ftxtAge = GetElement(self.m_root, "ftxtAge_CellKidItem", WZUIFreeTextBox)
	ftxtAge:setScale(0.65)
	ftxtAge:setMaxWidth(210)
	local ftxtHappiness = GetElement(self.m_root, "ftxtHappiness_CellKidItem", WZUIFreeTextBox)
	ftxtHappiness:setScale(0.65)
	ftxtHappiness:setMaxWidth(210)
end
-------------------------------------语言适配End----------------------------------------