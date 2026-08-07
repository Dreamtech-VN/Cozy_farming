--WndCommunityUpgrade.lua
--@brief	WndCommunityUpgrade的UI模块
--@date		2015/04/27
--@author	zsq
--@note		公会升级


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityUpgrade:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityUpgrade:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮
function WndCommunityUpgrade:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityUpgrade, true)
	end 
end

--@brief	显示公会升级
function WndCommunityUpgrade:showCommunityUpgrade()
	self:showInterface()
	self.m_nType = 0
	GetElement(self.m_root,"title",WZUILabelTTF):setText(LocalStrings.COMMUNITY3)
	GetElement(self.m_root,"conCommunity",WZUIContainer):setVisible(true)
	--设置升级界面
	local guildInfo = CacheCenter:getGuildInfo()
	GetElement(self.m_root,"community2",WZUILabelTTF):setText(LocalStrings.LV..guildInfo.guildLevel)
	GetElement(self.m_root,"community4",WZUILabelTTF):setText(LocalStrings.LV..(tonumber(guildInfo.guildLevel)+1))

	GetElement(self.m_root,"conCost1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conCost2",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"community7",WZUILabelTTF):setText(GDatatab_guild_level["id_"..(guildInfo.guildLevel+1)].cost[2][2])
	GetElement(self.m_root,"community8",WZUILabelTTF):setText(GDatatab_guild_level["id_"..(guildInfo.guildLevel+1)].cost[1][2])
	--消耗图标
	local imgCostIcon1 = GetElement(self.m_root, "imgCostIcon1_WndCommunityUpgrade", WZUIImage)
	if imgCostIcon1 then
		imgCostIcon1:setFile(GDatatab_item["id_" .. GDatatab_guild_level["id_"..(guildInfo.guildLevel+1)].cost[2][1]].icon)
		imgCostIcon1:setScale(0.6)
	end
	local imgCostIcon2 = GetElement(self.m_root, "imgCostIcon2_WndCommunityUpgrade", WZUIImage)
	if imgCostIcon2 then
		imgCostIcon2:setFile(GDatatab_item["id_" .. GDatatab_guild_level["id_"..(guildInfo.guildLevel+1)].cost[1][1]].icon)
		imgCostIcon2:setScale(0.6)
	end
end

--@brief	显示图腾升级
function WndCommunityUpgrade:showTotemUpgrade()
	self:showInterface()
	self.m_nType = 1
	GetElement(self.m_root,"title",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO70)
	GetElement(self.m_root,"conCommunity",WZUIContainer):setVisible(true)
	--设置升级界面
	local guildInfo = CacheCenter:getGuildInfo()
	GetElement(self.m_root,"community2",WZUILabelTTF):setText(LocalStrings.LV..guildInfo.totemLevel)
	GetElement(self.m_root,"community4",WZUILabelTTF):setText(LocalStrings.LV..(tonumber(guildInfo.totemLevel)+1))
	for k,v in pairs(GDatatab_guild_building) do
		if v.type == 1 and v.level == (guildInfo.totemLevel + 1) then
			GetElement(self.m_root,"community6",WZUILabelTTF):setText(v.cost[1][2])
		end
	end

	GetElement(self.m_root,"conCost1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conCost2",WZUIContainer):setVisible(false)
end

--@brief	显示技能学堂升级
function WndCommunityUpgrade:showSchoolUpgrade(schoolLevel, cost)
	self:showInterface()
	self.m_nType = 2
	GetElement(self.m_root,"title",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO71)

	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
		GetElement(self.m_root,"title",WZUILabelTTF):setFontSize(18)
	end

	GetElement(self.m_root,"conCommunity",WZUIContainer):setVisible(true)
	--设置升级界面
	local guildInfo = CacheCenter:getGuildInfo()
	GetElement(self.m_root,"community2",WZUILabelTTF):setText(LocalStrings.LV..schoolLevel)
	GetElement(self.m_root,"community4",WZUILabelTTF):setText(LocalStrings.LV..(schoolLevel+1))
	GetElement(self.m_root,"community6",WZUILabelTTF):setText(cost)

	GetElement(self.m_root,"conCost1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conCost2",WZUIContainer):setVisible(false)
end

--@brief	显示商店升级
function WndCommunityUpgrade:showShopUpgrade()
	self:showInterface()
	self.m_nType = 3
	GetElement(self.m_root,"title",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO72)
	GetElement(self.m_root,"conCommunity",WZUIContainer):setVisible(true)
	--设置升级界面
	local guildInfo = CacheCenter:getGuildInfo()
	GetElement(self.m_root,"community2",WZUILabelTTF):setText(LocalStrings.LV..guildInfo.storeLevel)
	GetElement(self.m_root,"community4",WZUILabelTTF):setText(LocalStrings.LV..(tonumber(guildInfo.storeLevel)+1))
	for k,v in pairs(GDatatab_guild_building) do
		if v.type == 3 and v.level == (guildInfo.storeLevel + 1) then
			GetElement(self.m_root,"community6",WZUILabelTTF):setText(v.cost[1][2])
		end
	end

	GetElement(self.m_root,"conCost1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conCost2",WZUIContainer):setVisible(false)
end

--@brief	点击升级按钮
function WndCommunityUpgrade:onUpGrade()
	WZLog("WndCommunityUpgrade:onUpGrade")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local guildInfo = CacheCenter:getGuildInfo()
	--是否有足够威望
	if guildInfo.prestige >= self.m_nCost then
	else
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO31)
		return
	end
	
	if self.m_nType == 0 then
		--公会升级判断是否有足够钻石
		if JudgeMoneyIsEnough(self.m_nCostId,self.m_nCostZuan,nil,nil,31, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
			self:sureUseDiamondInstead()
			return 
		end
	end
	if self.m_nType == 1 then
		ProtocolProcessorSceneCommunity:send_GUILD_BuildUpLevel(1)
		SceneCommunityMain:createLoading()
		GUILDUPGRADETYPE = 1
	end
	if self.m_nType == 2 then
		ProtocolProcessorSceneCommunity:send_GUILD_BuildUpLevel(2)
		SceneCommunityMain:createLoading()
		GUILDUPGRADETYPE = 2
	end
	if self.m_nType == 3 then
		ProtocolProcessorSceneCommunity:send_GUILD_BuildUpLevel(3)
		SceneCommunityMain:createLoading()
		GUILDUPGRADETYPE = 3
	end
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityUpgrade, true)
	end 
end

--@brief 	礼券不足时确认用钻石代替升级
function WndCommunityUpgrade:sureUseDiamondInstead()
	-- body
	ProtocolProcessorSceneCommunity:send_GUILD_GuildUpLevel()

	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityUpgrade, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	根据类型显示内容
function WndCommunityUpgrade:showInterface()
	local wndCommunityUpgrade = WndCommunityUpgrade:createElement()
	if wndCommunityUpgrade ~= nil then 
		WindowManager:addWindow(wndCommunityUpgrade,WndCommunityUpgrade,nil,nil,nil,true)
	end 
end




-------------------------------------私有方法模块End----------------------------------------
----------------------------------------语言适配Begin-----------------------------------------
function WndCommunityUpgrade:_adaptLanguage_pt(  )
	GetElement(self.m_root,"community5",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.5))
end

function WndCommunityUpgrade:_adaptLanguage_es(  )
	local txtCost = GetElement(self.m_root,"txtCost_WndCommunityUpgrade",WZUILabelTTF)
	txtCost:setFontSize(18)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.28,0.5))

	local community5 = GetElement(self.m_root,"community5",WZUILabelTTF)
	community5:setFontSize(18)
	community5:setRelativePosition(GlobalMethod:ccp(0.28,0.5))

	GetElement(self.m_root,"txtOK_WndDismissCommunity",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"title",WZUILabelTTF):setScale(0.6)

	GetElement(self.m_root,"community2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.5))
end

function WndCommunityUpgrade:_adaptLanguage_ug(  )
	local community5 = GetElement(self.m_root,"community5",WZUILabelTTF)
	community5:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
	local community6 = GetElement(self.m_root,"community6",WZUILabelTTF)
	community6:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
	community6:setAnchorPoint(GlobalMethod:ccp(1,0.5))

	local txtCost = GetElement(self.m_root,"txtCost_WndCommunityUpgrade",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.57,0.5))
	GetElement(self.m_root, "imgCostIcon1_WndCommunityUpgrade", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.54,0.5))
	local community7 = GetElement(self.m_root,"community7",WZUILabelTTF)
	community7:setRelativePosition(GlobalMethod:ccp(0.51,0.5))
	community7:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	GetElement(self.m_root, "imgCostIcon2_WndCommunityUpgrade", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
	local community8 = GetElement(self.m_root,"community8",WZUILabelTTF)
	community8:setRelativePosition(GlobalMethod:ccp(0.37,0.5))
	community8:setAnchorPoint(GlobalMethod:ccp(1,0.5))

	local txtOK = GetElement(self.m_root,"txtOK_WndDismissCommunity",WZUILabelTTF)
	txtOK:setScale(0.7)
	txtOK:setDimensions(GlobalMethod:CCSize(170))

	GetElement(self.m_root,"title",WZUILabelTTF):setScale(0.6)
end
----------------------------------------语言适配End-------------------------------------------