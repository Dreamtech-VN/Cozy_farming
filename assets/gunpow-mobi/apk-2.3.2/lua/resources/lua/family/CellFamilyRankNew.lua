--CellFamilyRankNew.lua
--@brief	CellFamilyRankNew的UI模块
--@date		2017/08/01
--@author	zsq
--@note		家园排行榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFamilyRankNew:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFamilyRankNew:onExit(element)
	self:_unInit()
end

function CellFamilyRankNew:onRole() 
	WZLog("CellFamilyRankNew:onRole")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData.playerId == nil then return end
	WndCheckOther:show(self.m_tData.playerId)
end

function CellFamilyRankNew:onFamily() 
	WZLog("CellFamilyRankNew:onFamily")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData.playerId == nil then return end
	if self.m_nType == 2 then
		SceneKidHome:showInterface(self.m_tData.playerId)
	elseif self.m_nType == 3 or self.m_nType == 4 then
		SceneHolidayVillage:showInterface(self.m_tData.playerId)
	else
		SceneFamily:showInterface(self.m_tData.playerId)
	end
end

function CellFamilyRankNew:onClickCheck()
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tData.playerId == nil then return end
	-- WndCheckOther:show(self.m_tData.playerId)
	ProtocolProcessorWndBag:regAll1()
	ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(self.m_tData.playerId) 
end

--@brief 	设置数据
--@param 	nType : 默认家园排行榜单；2->小孩排行榜单；3好友度假村；4好友拜访度假村操作日志
function CellFamilyRankNew:setData(tData, nType) 
	WZLog("CellFamilyRankNew:setData")
	self.m_tData = tData
	self.m_nType = nType
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新公会内容的函数（包括排名，ID，公会名称，公会等级，公会威望）
function CellFamilyRankNew:onLoadData()
	local element = WZUISystem:getInstance():createElement("CellFamilyRankNew")

    self.m_root:addChild(element)
	element:setLuaObjectIndex(self)

	if self.m_root == nil then return end 
	local tData = self.m_tData

	AdaptLanguage(self)

	if self.m_nType == 4 then 
		self:showOperateLog()
		return 
	end
	--排名前三显示图片
	local picName = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
	if tonumber(self.m_tData.rank) ~= nil and tonumber(self.m_tData.rank) >= 1 and tonumber(self.m_tData.rank) <= 3 then
    	GetElement(self.m_root, "imgName_CellFamilyRankNew", WZUIImage):setVisible(true)
    	GetElement(self.m_root, "txtRanking_CellFamilyRankNew", WZUILabelAtlasFont):setVisible(false)
    	GetElement(self.m_root, "imgName_CellFamilyRankNew", WZUIImage):setFile(picName[tonumber(self.m_tData.rank)])
	end
	
	--排名
	local txtRanking = self.m_root:getChildElement("txtRanking_CellFamilyRankNew")
	if txtRanking ~= nil then 
		txtRanking = WZUILabelAtlasFont:luaTo(txtRanking)
		if txtRanking ~= nil then 
			txtRanking:setText(self.m_tData.rank)
		end 
		if self.m_tData.rank == -1 then
			txtRanking:setText("")
			-- GetElement(WndFamilyRank.m_root,"txtFirst_SceneCommunity",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP9)
			-- GetElement(WndFamilyRank.m_root,"txtSecond_SceneCommunity",WZUILabelTTF):setText("")
			GetElement(self.m_root,"conHeadInfo_CellFamilyRankNew",WZUIContainer):setRelativePosition(ccp(0.4, 0.5))
		else
			-- GetElement(WndFamilyRank.m_root,"txtFirst_SceneCommunity",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP7)
			-- GetElement(WndFamilyRank.m_root,"txtSecond_SceneCommunity",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP9)
			GetElement(self.m_root,"conHeadInfo_CellFamilyRankNew",WZUIContainer):setRelativePosition(ccp(0.5, 0.5))
		end
	end 
	
	--名称
	local txtCommunityName = self.m_root:getChildElement("txtCommunityName_CellFamilyRankNew")
	local imgKuafu = GetElement(self.m_root,"imgKua_CellFamilyRankNew",WZUIImage)
	if txtCommunityName ~= nil then 
		txtCommunityName= WZUILabelTTF:luaTo(txtCommunityName)
		if txtCommunityName ~= nil then 
			--是否不同服
			txtCommunityName:setText(self.m_tData.name)
			if tonumber(self.m_tData.serverId) ~= tonumber(CacheCenter:getPlayerInfo().serverId) then
				imgKuafu:setFile("ui/common/common_icon_kuafu.png")
			end
			if self.m_tData.playerId == CacheCenter:getPlayerInfo().id then
				txtCommunityName:setColor(GlobalMethod:ccc3(99,255,95))
			end
		end 
	end
	WZLog("显示排行:",self.m_tData.name)
	local txtSheerLuxury = GetElement(self.m_root,"txtSheerLuxury_CellFamilyRankNew",WZUILabelTTF)
	if self.m_nType == 2 then
		local str = "--"
		if self.m_tData.level then
			str = string.format(LocalStrings.SPACE55 .. "%.1f" .. LocalStrings.SPACE91, self.m_tData.level/10)
		end
		txtSheerLuxury:setText(str)
	elseif self.m_nType == 3 then
		GetElement(self.m_root, "txtLevel_CellFamilyRankNew", WZUILabelTTF):setText(LocalStrings.LV .. self.m_tData.level)
		imgKuafu:setRelativePosition(GlobalMethod:ccp(0.5, 0.65))
		local achieData = GDatatab_holiday_achievement["id_" .. self.m_tData.achieId]
		if achieData then 
			txtSheerLuxury:setText(achieData.name)
		else
			txtSheerLuxury:setText("")
		end
	else
		--家园豪华度
		txtSheerLuxury:setText(LocalStrings.FAMILY_TEXT3 .. ":" .. self.m_tData.sheerLuxury)
	end

	--主人头像
	local conPlayerAni = GetElement(self.m_root,"conHead_Cell",WZUIContainer)
	if self.m_nType == 2 then
		local imgHead = CellHead:show(conPlayerAni, tData.headId, tData.faceId, tData.sex, false, GlobalMethod:ccp(0.54,0.29), nil, nil, nil, nil, nil, true, tData.headEffectId)
		-- imgHead:setScale(0.75)
	else
		local imgHead = CellHead:show(conPlayerAni, tData.headId, tData.faceId, tData.sex, false, GlobalMethod:ccp(0.54,0.29), tData.vipLevel, tData.headColor, nil, nil, nil, nil, tData.headEffectId)
		-- imgHead:setScale(0.75)
	end
	--可偷取按钮的显示
	if self.m_nType ~= 2 then
		self:setGoldIconVivible()
	end
end 

--@brief 	设置金币图标的可见与否
function CellFamilyRankNew:setGoldIconVivible()
	-- body
	local imgGoldIcon = GetElement(self.m_root, "imgGoldIcon_CellFamilyRankNew", WZUIImage)
	if imgGoldIcon then
		if self.m_nType == 3 then 
			imgGoldIcon:setFile("ui/holidayVillage/otherImg/common_icon_djc_kt.png")
			imgGoldIcon:setScale(1)
			if self.m_tData.stealState == true then 
				imgGoldIcon:setVisible(true)
			else
				imgGoldIcon:setVisible(false)
			end
		else
			if self.m_tData.stealState == 1 then
				imgGoldIcon:setVisible(true)
			else
				imgGoldIcon:setVisible(false)
			end
		end
	end
end

--@brief 	显示操作日志
function CellFamilyRankNew:showOperateLog()
	local tData = self.m_tData

	GetElement(self.m_root, "btnHead_CellFamilyRankNew", WZUIButton):setVisible(false)
	GetElement(self.m_root, "imgName_CellFamilyRankNew", WZUIImage):setVisible(false)
	GetElement(self.m_root, "conHeadInfo_CellFamilyRankNew", WZUIContainer):setVisible(false)
	local conRank = GetElement(self.m_root, "conRank_CellFamilyRankNew", WZUIContainer)
	conRank:setAbsContentSize(GlobalMethod:CCSize(374,60))
	conRank:updateRelativeSize()

	local ftxtLog = GetElement(self.m_root, "ftxtLog_CellFamilyRankNew", WZUIFreeTextBox)
	WZLog("CellFamilyRankNew:showOperateLog 00", type(ftxtLog))
	if ftxtLog then 
		local visitorDay = os.date("*t", tData.time)
    	local strTime = string.format("%02d%s%02d%s %02d%s%02d%s", visitorDay.month, LocalStrings.SPACE31, visitorDay.day, LocalStrings.SPACE32, visitorDay.hour, LocalStrings.HOUR, visitorDay.min, LocalStrings.MINUTE)
    	local strKuafu = ""
    	if tonumber(tData.serverId) ~= tonumber(CacheCenter:getPlayerInfo().serverId) then
    		strKuafu = "ui/common/common_icon_kuafu.png"
    	end
		local strContent = string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[11], strTime, strKuafu, tData.name)
		if tData.opType == 1 then --偷走鲜花
			local basicInfo = GDatatab_item["id_" .. tData.itemId]
			local strTemp1 = string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[15], tData.itemNum)
			local strTemp = string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[12], strTemp1, basicInfo.name)
			strContent = strContent .. strTemp
		elseif tData.opType == 2 then --帮忙抓虫
			strContent = strContent .. LocalStrings.HOLIDAYVILLAGE_TEXT1[13]
		elseif tData.opType == 3 then --试图偷花，被精灵阻止
			local strBotany = GDatatab_item["id_" .. tData.itemId]
			local strSpirit = GDatatab_holiday_spirit["id_"..tData.itemNum]
			local strContent2 = string.format(LocalStrings.HOLIDAYVILLAGE_TEXT4[28], strBotany.name, strSpirit.name)
			strContent = strContent .. strContent2
		end
		WZLog("CellFamilyRankNew:showOperateLog", strContent)
		ftxtLog:setShowText(strContent)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------私有方法模块End----------------------------------------
function CellFamilyRankNew:_adaptLanguage_ug(  )
	GetElement(self.m_root,"txtSheerLuxury_CellFamilyRankNew",WZUILabelTTF):setScale(0.7)
end

function CellFamilyRankNew:_adaptLanguage_vn()
	local ftxtLog = GetElement(self.m_root, "ftxtLog_CellFamilyRankNew", WZUIFreeTextBox)
	ftxtLog:setScale(0.7)
	ftxtLog:setMaxWidth(480)
end

-------------------------------------私有方法模块End----------------------------------------
