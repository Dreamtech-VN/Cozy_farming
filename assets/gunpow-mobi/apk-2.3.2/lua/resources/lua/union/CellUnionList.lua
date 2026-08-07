--CellUnionList.lua
--@brief	CellUnionList的UI模块
--@date		2024/01/12
--@author	XTX
--@note		联盟列表Item


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellUnionList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellUnionList:onExit(element)
	self:_unInit()
end

--@brief	点击容器（CELL时）时的触发函数
function CellUnionList:onBtnClickEvent(element)
	if self.m_root ~=nil and element ~= nil then 
		WZLog("CellUnionList:onBtnClickEvent(element)")
	end 

	WndUnionList:onBtnClickEventByCellCommunitList(element,self.m_sId)
end 

--@brief	点击申请按钮
function CellUnionList:onApply(element)
	WZLog("CellUnionList:onApply", self.setting)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--判断入会等级
	if CacheCenter:getPlayerInfo().level < tonumber(self.setting) then
		MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT1[22], tostring(self.setting)))
		return
	end
	--判断入会VIP等级
	if CacheCenter:getPlayerInfo().vipLevel < tonumber(self.vipLevel) then
		MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT1[23], tostring(self.vipLevel)))
		return
	end
	--战力判断
	if CacheCenter:getPlayerInfo().fighting < self.m_nFighting then 
		MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT1[39], tostring(self.m_nFighting)))
		return 
	end
	--申请入会协议
	if self.m_sId ~= nil then
		ProtocolProcessorUnion:send_LEAGUE_ApplyLeague(self.m_sId, self.m_sName)
		element:setTouchEnable(false)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新公会内容的函数（包括排名，ID，公会名称，公会等级，公会威望）
function CellUnionList:_update()
	if self.m_root == nil then 
		WZLog("CellUnionList:_update() self.m_root is nil ")
		return 
	end 
	
	--排名
	local txtLeader = self.m_root:getChildElement("txtLeader_CellUnionList")
	if txtLeader ~= nil then 
		txtLeader = WZUILabelTTF:luaTo(txtLeader)
		if txtLeader ~= nil then 
			txtLeader:setText(self.m_sLeaderName)
		end 
	end 
	
	--ID
	local ftxtUnionId = self.m_root:getChildElement("ftxtUnionId_CellUnionList")
	if ftxtUnionId ~= nil then 
		ftxtUnionId = WZUIFreeTextBox:luaTo(ftxtUnionId)
		if ftxtUnionId ~= nil then 
			if self.m_sId ~= nil then
				local formatStr = [[<T C="127,70,26" S="20" P="1">ID:</T><T C="229,105,22" S="20" P="1">%d</T>]]
				ftxtUnionId:setShowText(string.format(formatStr, self.m_sId))
			end
		end 
	end 
	
	--名称
	local formatStr = [[<T C="127,70,26" S="20" P="1">%s</T>]]
	local txtCommunityName = self.m_root:getChildElement("txtUnionName_CellUnionList")
	if txtCommunityName ~= nil then 
		txtCommunityName= WZUIFreeTextBox:luaTo(txtCommunityName)
		if txtCommunityName ~= nil and self.m_sLevel ~= nil and self.m_sName ~= nil then 
			txtCommunityName:setShowText(string.format(formatStr, self.m_sName))
		end 
	end 

	--入会限制
	local open_level = 15
	local fId = 230
	if GDatatab_button_info ~= nil and GDatatab_button_info["id_" .. fId] ~= nil then
		open_level = GDatatab_button_info["id_" .. fId].open_level
	end
	if self.setting and self.setting > open_level then 
		open_level = self.setting
	end

	if (self.setting == open_level and self.vipLevel == 0 and self.m_nFighting == 0) or (self.setting == 0 and self.vipLevel == 0 and self.m_nFighting == 0) then
		GetElement(self.m_root,"ftxtUnionLimit_CellUnionList",WZUIFreeTextBox):setShowText(string.format(formatStr, LocalStrings.COMMUNITYINFO235))
	elseif tostring(self.setting) ~= nil and self.vipLevel ~= nil and self.m_nFighting ~= nil then
		GetElement(self.m_root,"ftxtUnionLimit_CellUnionList",WZUIFreeTextBox):setShowText(string.format(LocalStrings.UNION_TEXT1[40], open_level, self.vipLevel, self.m_nFighting))
	else
		GetElement(self.m_root,"ftxtUnionLimit_CellUnionList",WZUIFreeTextBox):setShowText(string.format(formatStr, LocalStrings.COMMUNITYINFO235))
	end

	--是否显示申请按钮
	local unionInfo = CacheCenter:getPlayerInfo().unionInfo

	if unionInfo == nil or unionInfo.id and unionInfo.id < 1 then
		GetElement(self.m_root, "btnApply_CellUnionList", WZUIButton):setVisible(true)
		self:setElementPosition(false)
	else
		GetElement(self.m_root, "btnApply_CellUnionList", WZUIButton):setVisible(false)
		self:setElementPosition(true)
	end
	local maxNum = 100
	if GDatatab_league_level["id_".. self.m_sLevel] ~= nil then
		maxNum = GDatatab_league_level["id_".. self.m_sLevel].total
	end
	--在公会内显示人数
	GetElement(self.m_root,"txtUnionMemberNum_CellUnionList",WZUILabelTTF):setText(self.members.."/"..maxNum)
	
end 

--@brief	把底图设置成绿色
function CellUnionList:setGreen()
	GetElement(self.m_root, "imgBtn1_CellUnionList", WZUI9Image):setFile("ui/common/frame_lieb_01.png")
	GetElement(self.m_root, "imgBtn2_CellUnionList", WZUI9Image):setFile("ui/common/frame_lieb_01.png")
	GetElement(self.m_root, "imgBtn3_CellUnionList", WZUI9Image):setFile("ui/common/frame_lieb_01.png")
end

--@brief	根据是否加入公会设置控件位置
--@param	inCommunity:是否加入公会
function CellUnionList:setElementPosition(inCommunity)
	local inCommunity = inCommunity or false
	if inCommunity == true then
		-- GetElement(self.m_root, "txtLeader_CellUnionList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.07,0.5))
		-- GetElement(self.m_root, "ftxtUnionId_CellUnionList", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.318,0.31))
		-- GetElement(self.m_root, "txtUnionName_CellUnionList", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.32,0.7))
		-- GetElement(self.m_root, "txtUnionMemberNum_CellUnionList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.645,0.5))
		-- GetElement(self.m_root, "ftxtUnionLimit_CellUnionList", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.88,0.5))
	else
		-- GetElement(self.m_root, "txtLeader_CellUnionList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.07,0.5))
		-- GetElement(self.m_root, "ftxtUnionId_CellUnionList", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.29,0.31))
		-- GetElement(self.m_root, "txtUnionName_CellUnionList", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.292,0.7))
		-- GetElement(self.m_root, "txtUnionMemberNum_CellUnionList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.5))
		-- GetElement(self.m_root, "ftxtUnionLimit_CellUnionList", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.725,0.5))
	end
end




-------------------------------------私有方法模块End----------------------------------------
