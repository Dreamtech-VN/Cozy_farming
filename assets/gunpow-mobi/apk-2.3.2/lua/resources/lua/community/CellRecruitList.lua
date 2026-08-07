--CellRecruitList.lua
--@brief	CellRecruitList的UI模块
--@date		2013/12/31
--@author	林庆凯
--@note		会员申批列表,公会捐献列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRecruitList:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRecruitList:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


--@brief	选择复选框的函数
--@param	element:表绑定的UI节点引用
function CellRecruitList:onSelCheckBox(element)
	WZLog("CellRecruitList:onSelCheckBox(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--element:setTag(self.m_root:getTag())
	element:setTag(self:getPlayerId())
	self.m_bCheckBoxSelFlag = self:getCheckBoxSelState()
	WZLog("self.m_bCheckBoxSelFlag  = ",self.m_bCheckBoxSelFlag )
	WZLog("self:getPlayerId() = ",self:getPlayerId())

	WndRecruit:onSelCheckBoxByCelRecruit(self:getPlayerId(),self.m_bCheckBoxSelFlag)
end 


--@brief	设置选择复选框状态的函数
--@param 	nFalg 选中状态 
function CellRecruitList:setCheckBoxSelState(element,nFalg)
	if element == nil then 
		WZLog(" CellRecruitList:setEditBoxSelState(nFalg) self.m_root is nil ")
		return 
	end 
	
	local checkBoxSel = element:getChildElement("checkBoxSel_CellRecruitList")
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
function CellRecruitList:getCheckBoxSelState()
	if self.m_root == nil then 
		WZLog("CellRecruitList:getCheckBoxSelState() self.m_root is nil ")
		return 
	end 
	
	local checkBoxSel = self.m_root:getChildElement("checkBoxSel_CellRecruitList")
	if checkBoxSel ~= nil then 
		checkBoxSel = WZUICheckBox:luaTo(checkBoxSel)
		if checkBoxSel ~= nil then 
			--设置选中状态 
			return checkBoxSel:getCheckIndex()
		end 
	end 
end 



-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新列表内容的函数(等级背景,等级数量,姓名,性别)
function CellRecruitList:_update()
	if self.m_root == nil then 	return end 
	
	--等级
	GetElement(self.m_root,"txtLv_CellRecruitList",WZUILabelTTF):setText(self.m_nLevel)
	
	--姓名
	local txtName = self.m_root:getChildElement("txtName_CellRecruitList")
	if txtName ~= nil then 
		txtName = WZUILabelTTF:luaTo(txtName)
		if txtName ~= nil then 
			txtName:setText(self.m_sTxtName)
		end 
	end 
	
	--战斗力
	GetElement(self.m_root,"fightTitle",WZUILabelTTF):setText(LocalStrings.COMBAT..":") 
	GetElement(self.m_root,"ttfFighting",WZUILabelTTF):setText(self.fight) 
	
	--头像
	local imgHead = CellHead:show(GetElement(self.m_root,"conHead_Cell",WZUIContainer),self.headId,self.faceId,self.m_nImgSex,nil,nil,self.vipLevel, self.headColor, nil, nil, nil, nil, self.m_nHeadEffectId)
	imgHead:setScale(1.1)
end 

--@brief	查看玩家信息
function CellRecruitList:onCheck()
	WZLog("CellRecruitList:onCheck")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_nId)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------
function CellRecruitList:_adaptLanguage_vn()
end

function CellRecruitList:_adaptLanguage_tr(  )
	local fightTitle = GetElement(self.m_root,"fightTitle",WZUILabelTTF)
	fightTitle:setScale(0.7)
	fightTitle:setRelativePosition(GlobalMethod:ccp(0.4,0.34))

	local ttfFight = GetElement(self.m_root,"ttfFighting",WZUILabelTTF)
	ttfFight:setRelativePosition(GlobalMethod:ccp(0.51,0.34))
	ttfFight:setScale(0.8)
end

function CellRecruitList:_adaptLanguage_es()
	local ttfFighting = GetElement(self.m_root,"ttfFighting",WZUILabelTTF)
	ttfFighting:setFontSize(18)
	ttfFighting:setRelativePosition(GlobalMethod:ccp(0.55,0.34))
	local fightTitle = GetElement(self.m_root,"fightTitle",WZUILabelTTF)
	fightTitle:setScale(0.8)
	fightTitle:setRelativePosition(GlobalMethod:ccp(0.41,0.34))
	GetElement(self.m_root,"txtName_CellRecruitList",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配End----------------------------------------