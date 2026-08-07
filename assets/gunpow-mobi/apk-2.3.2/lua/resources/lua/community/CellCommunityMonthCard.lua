--CellCommunityMonthCard.lua
--@brief	CellCommunityMonthCard的UI模块
--@date		2015/11/04
--@author	zsq
--@note		公会月卡Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityMonthCard:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityMonthCard:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新Cell
function CellCommunityMonthCard:update(tData)
	WZLog("CellCommunityMonthCard:update",Serialize(tData))
	if tData == nil then return end
	self.m_tData = tData
	--名字
	GetElement(self.m_root,"txtName_Cell",WZUILabelTTF):setText(tData.name)
	--等级
	GetElement(self.m_root,"txtLevel_Cell",WZUILabelTTF):setText(LocalStrings.LV..tData.level)
end

--@brief	选择复选框的函数
--@param	element:表绑定的UI节点引用
function CellCommunityMonthCard:onSelCheckBox(element)
	WZLog("CellRecruitList:onSelCheckBox(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	element:setTag(self.m_tData.id)
	WndCommunityMonthCard:onCellChecked(element)
end 

--@brief	查看
function CellCommunityMonthCard:onCheck(element)
	WZLog("CellRecruitList:onCheck")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tData.id)
end 

--@brief	设置选择复选框状态的函数
--@param 	nFalg 选中状态 
function CellCommunityMonthCard:setCheckBoxSelState(element,nFalg)
	if element == nil then 
		WZLog(" CellCommunityMonthCard self.m_root is nil ")
		return 
	end 
	
	local checkBoxSel = element:getChildElement("checkBoxSel_Cell")
	if checkBoxSel ~= nil then 
		checkBoxSel = WZUICheckBox:luaTo(checkBoxSel)
		if checkBoxSel ~= nil then 
			--设置选中状态 
			checkBoxSel:setCheckIndex(nFalg)
		end 
	end 
end 
-------------------------------------私有方法模块End----------------------------------------
