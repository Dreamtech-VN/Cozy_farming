--CellCommunityDonate.lua
--@brief	CellCommunityDonate的UI模块
--@date		2013/12/31
--@author	林庆凯
--@note		会员申批列表,公会捐献列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityDonate:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityDonate:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


--@brief	选择复选框的函数
--@param	element:表绑定的UI节点引用
function CellCommunityDonate:onSelCheckBox(element)
	WZLog("CellCommunityDonate:onSelCheckBox(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--element:setTag(self.m_root:getTag())
	element:setTag(self:getPlayerId())
	self.m_bCheckBoxSelFlag = self:getCheckBoxSelState()
	WZLog("self.m_bCheckBoxSelFlag  = ",self.m_bCheckBoxSelFlag )
	WZLog("self:getPlayerId() = ",self:getPlayerId())

		WndCommunityDonate:onCellChecked(element)
end 


--@brief	设置选择复选框状态的函数
--@param 	nFalg 选中状态 
function CellCommunityDonate:setCheckBoxSelState(element,nFalg)
	if element == nil then 
		WZLog(" CellCommunityDonate:setEditBoxSelState(nFalg) self.m_root is nil ")
		return 
	end 
	
	local checkBoxSel = element:getChildElement("checkBoxSel_CellCommunityDonate")
	if checkBoxSel ~= nil then 
		checkBoxSel = WZUICheckBox:luaTo(checkBoxSel)
		if checkBoxSel ~= nil then 
			--设置选中状态 
			checkBoxSel:setCheckIndex(nFalg)
		end 
	end 
end 



--@brief	取得选择复选框状态的函数
--@param 	nFalg 选中状态 
function CellCommunityDonate:getCheckBoxSelState()
	if self.m_root == nil then 
		WZLog("CellCommunityDonate:getCheckBoxSelState() self.m_root is nil ")
		return 
	end 
	
	local checkBoxSel = self.m_root:getChildElement("checkBoxSel_CellCommunityDonate")
	if checkBoxSel ~= nil then 
		checkBoxSel = WZUICheckBox:luaTo(checkBoxSel)
		if checkBoxSel ~= nil then 
			--设置选中状态 
			return checkBoxSel:getCheckIndex()
		end 
	end 
end 



-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置公会捐献
function CellCommunityDonate:setCommunityDonate(content)
	WZLog(content)
	--捐献内容
	GetElement(self.m_root,"txtName_CellCommunityDonate",WZUIFreeTextBox):setShowText(content)
	
	if ProjConfig.LANGUAGE == "en" then
		GetElement(self.m_root,"txtName_CellCommunityDonate",WZUIFreeTextBox):setScale(0.85)
	end
	if ProjConfig.LANGUAGE == "th" then
		GetElement(self.m_root,"txtName_CellCommunityDonate",WZUIFreeTextBox):setScale(0.85)
	end
	if ProjConfig.LANGUAGE == "pt" then
		local txtName = GetElement(self.m_root,"txtName_CellCommunityDonate",WZUIFreeTextBox)
		txtName:setScale(0.85)
		txtName:setMaxWidth(460)
	end
	if ProjConfig.LANGUAGE == "tr" then
		local txtName = GetElement(self.m_root,"txtName_CellCommunityDonate",WZUIFreeTextBox)
		txtName:setScale(0.8)
		txtName:setMaxWidth(460)
	end
	if ProjConfig.LANGUAGE == "es" then
		local txtName = GetElement(self.m_root,"txtName_CellCommunityDonate",WZUIFreeTextBox)
		txtName:setScale(0.8)
		txtName:setMaxWidth(460)
	end
end


-------------------------------------私有方法模块End----------------------------------------
