--CellCommunityList.lua
--@brief	CellCommunityList的UI模块
--@date		2013/12/24
--@author	林庆凯
--@note		创建公会列表的容器


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityList:onEnter(element)
	self.m_root = element
--	self:_update()
--	self:setCommunity1Context("22","1300","onEnter","5","20000")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityList:onExit(element)
	self:_unInit()
end



--@brief	点击容器（CELL时）时的触发函数
function CellCommunityList:onBtnClickEvent(element)
	if self.m_root ~=nil and element ~= nil then 
		WZLog("CellCommunityList:onBtnClickEvent(element)")
	end 
	--跳到公会主场景执行相关函数
	SceneCommunity:onBtnClickEventByCellCommunitList(element,self.m_sId)
end 

--@brief	点击申请按钮
function CellCommunityList:onApply(element)
	WZLog("CellCommunityList:onApply", self.setting)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--判断入会等级
	if CacheCenter:getPlayerInfo().level < tonumber(self.setting) then
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO231, tostring(self.setting)))
		return
	end
	--判断入会VIP等级
	if CacheCenter:getPlayerInfo().vipLevel < tonumber(self.vipLevel) then
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO232, tostring(self.vipLevel)))
		return
	end
	--申请入会协议
	if self.m_sId ~= nil then
		ProtocolProcessorSceneCommunity:send_GUILD_ApplyGuild(self.m_sId )
		element:setTouchEnable(false)
	end
	--SceneCommunityMain:createLoading()
end

--@brief	把容器中的字体设为红色的函数
function CellCommunityList:setFontWithRedColor()
	if self.m_root ==nil then 
		WZLog("CellCommunityList:setFontWithRedColor() is nil ")
	end 

	--local color = GlobalMethod:ccc3(255,89,74)
	local color = GlobalMethod:ccc3(64,128,1)
	
	--排名
	local txtRanking = self.m_root:getChildElement("txtRanking_CellCommunityList")
	if txtRanking ~= nil then 
		txtRanking = WZUILabelTTF:luaTo(txtRanking)
		if txtRanking ~= nil then 
			txtRanking:setColor(GlobalMethod:ccc3(158,0,0))
		end 
	end 
	
	--ID
	local txtCommunityId = self.m_root:getChildElement("txtCommunityId_CellCommunityList")
	if txtCommunityId ~= nil then 
		txtCommunityId = WZUILabelTTF:luaTo(txtCommunityId)
		if txtCommunityId ~= nil then 
			txtCommunityId:setColor(color)
		end 
	end 
	
	--名称
	local txtCommunityName = self.m_root:getChildElement("txtCommunityName_CellCommunityList")
	if txtCommunityName ~= nil then 
		txtCommunityName= WZUILabelTTF:luaTo(txtCommunityName)
		if txtCommunityName ~= nil then 
			txtCommunityName:setColor(color)
		end 
	end 

	GetElement(self.m_root,"txtCommunityLimit_CellCommunityList",WZUILabelTTF):setColor(color)
	
	--威望
	local txtCommunityPrestige = self.m_root:getChildElement("txtCommunityPrestige_CellCommunityList")
	if txtCommunityPrestige ~= nil then 
		txtCommunityPrestige = WZUILabelTTF:luaTo(txtCommunityPrestige)
		if txtCommunityPrestige ~= nil then 
			txtCommunityPrestige:setColor(color)
		end 
	end 
end 
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新公会内容的函数（包括排名，ID，公会名称，公会等级，公会威望）
function CellCommunityList:_update()
	if self.m_root == nil then 
		WZLog("CellCommunityList:_update() self.m_root is nil ")
		return 
	end 

	--排名前三显示图片
	local picName = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
	if tonumber(self.m_sRanking) ~= nil and tonumber(self.m_sRanking) >= 1 and tonumber(self.m_sRanking) <= 3 then
    	GetElement(self.m_root, "imgName_CellCommunityList", WZUIImage):setVisible(true)
    	GetElement(self.m_root, "txtRanking_CellCommunityList", WZUILabelTTF):setVisible(false)
    	GetElement(self.m_root, "imgName_CellCommunityList", WZUIImage):setFile(picName[tonumber(self.m_sRanking)])
	end
	
	--排名
	local txtRanking = self.m_root:getChildElement("txtRanking_CellCommunityList")
	if txtRanking ~= nil then 
		txtRanking = WZUILabelTTF:luaTo(txtRanking)
		if txtRanking ~= nil then 
			txtRanking:setText(self.m_sRanking)
		end 
	end 
	
	--ID
	local txtCommunityId = self.m_root:getChildElement("txtCommunityId_CellCommunityList")
	if txtCommunityId ~= nil then 
		txtCommunityId = WZUILabelTTF:luaTo(txtCommunityId)
		if txtCommunityId ~= nil then 
			if self.m_sId ~= nil then
				txtCommunityId:setText("ID:"..self.m_sId)
			end
		end 
	end 
	
	--名称
	local txtCommunityName = self.m_root:getChildElement("txtCommunityName_CellCommunityList")
	if txtCommunityName ~= nil then 
		txtCommunityName= WZUILabelTTF:luaTo(txtCommunityName)
		if txtCommunityName ~= nil and self.m_sLevel ~= nil and self.m_sName ~= nil then 
			txtCommunityName:setText("LV"..self.m_sLevel.." "..self.m_sName)
		end 
	end 
	
	--威望
	local txtCommunityPrestige = self.m_root:getChildElement("txtCommunityPrestige_CellCommunityList")
	if txtCommunityPrestige ~= nil then 
		txtCommunityPrestige = WZUILabelTTF:luaTo(txtCommunityPrestige)
		if txtCommunityPrestige ~= nil then 
			txtCommunityPrestige:setText(self.m_sPrestige)
		end 
	end 

	--入会限制
	local open_level = 15
	if GDatatab_button_info ~= nil and GDatatab_button_info["id_9"] ~= nil then
		open_level = GDatatab_button_info["id_9"].open_level
	end
	if (self.setting == open_level and self.vipLevel == 0) or (self.setting == 0 and self.vipLevel == 0) then
		GetElement(self.m_root,"txtCommunityLimit_CellCommunityList",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO235)
	elseif tostring(self.setting) ~= nil and self.vipLevel ~= nil then
		GetElement(self.m_root,"txtCommunityLimit_CellCommunityList",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO236, tostring(self.setting)).."\n".."VIP"..self.vipLevel)
	else
		GetElement(self.m_root,"txtCommunityLimit_CellCommunityList",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO235)
	end

	--是否显示申请按钮
	local guildId = CacheCenter:getPlayerInfo().guildId

	if guildId == nil or guildId < 1 then
		GetElement(self.m_root, "btnApply", WZUIButton):setVisible(true)
		self:setElementPosition(false)
	else
		GetElement(self.m_root, "btnApply", WZUIButton):setVisible(false)
		self:setElementPosition(true)

		local maxNum = 100
		if GDatatab_guild_level["id_".. self.m_sLevel] ~= nil then
			maxNum = GDatatab_guild_level["id_".. self.m_sLevel].total
		end
		--在公会内显示人数
		GetElement(self.m_root,"txtCommunityLimit_CellCommunityList",WZUILabelTTF):setText(self.members.."/"..maxNum)
	end
	
end 

--@brief	把底图设置成绿色
function CellCommunityList:setGreen()
	GetElement(self.m_root, "imgBtn1_CellCommunityList", WZUI9Image):setFile("ui/common/common_scale9_di38.png")
	GetElement(self.m_root, "imgBtn2_CellCommunityList", WZUI9Image):setFile("ui/common/common_scale9_di38.png")
	GetElement(self.m_root, "imgBtn3_CellCommunityList", WZUI9Image):setFile("ui/common/common_scale9_di38.png")
end

--@brief	根据是否加入公会设置控件位置
--@param	inCommunity:是否加入公会
function CellCommunityList:setElementPosition(inCommunity)
	local inCommunity = inCommunity or false
	if inCommunity == true then
		GetElement(self.m_root, "txtRanking_CellCommunityList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.07,0.5))
		GetElement(self.m_root, "txtCommunityId_CellCommunityList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.318,0.31))
		GetElement(self.m_root, "txtCommunityName_CellCommunityList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.32,0.7))
		GetElement(self.m_root, "txtCommunityPrestige_CellCommunityList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.645,0.5))
		GetElement(self.m_root, "txtCommunityLimit_CellCommunityList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.88,0.5))
	else
		GetElement(self.m_root, "txtRanking_CellCommunityList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.07,0.5))
		GetElement(self.m_root, "txtCommunityId_CellCommunityList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.29,0.31))
		GetElement(self.m_root, "txtCommunityName_CellCommunityList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.292,0.7))
		GetElement(self.m_root, "txtCommunityPrestige_CellCommunityList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.5))
		GetElement(self.m_root, "txtCommunityLimit_CellCommunityList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.725,0.5))
	end
end





-------------------------------------私有方法模块End----------------------------------------
