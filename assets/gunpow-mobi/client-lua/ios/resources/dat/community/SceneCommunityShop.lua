--SceneCommunityShop.lua
--@brief	SceneCommunityShop的UI模块
--@date		2015/04/24
--@author	zsq
--@note		公会商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCommunityShop:onEnter(element)
	self.m_root = element
	self:_addTop()

	--获得公会商品列表
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildStore()

	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	AdaptLanguage(self)
end

function SceneCommunityShop:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/community/common_icon_ghsd.png",SceneCommunityShop,SceneCommunityShop.onClose,true,false,false,"SceneCommunityShop")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCommunityShop:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
end

--@brief	关闭按钮
function SceneCommunityShop:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	--进入公会场景
   	--replaceScene(SceneCommunityMain:createElement())
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	开始按下回调函数
function SceneCommunityShop:onTouchBegan(element,pt)
	local bPoint = WndItemInfo:checkPoint(pt,GlobalMethod:ccp(0,0))
	WZLog("SceneCommunityShop:onTouchBegan")
	if bPoint == false then
		WndItemInfo:onCloseClick()
	end
end

--@brief	更新物品
function SceneCommunityShop:updatePlayerItemData()
	WZLog("SceneCommunityShop:updatePlayerItemData",self.m_nCostId)
	--如果消耗个人贡献
	if tonumber(self.m_nCostId) == 7 then
		local donate = GetElement(self.m_root, "Contribution1", WZUILabelTTF):getText()
		donate = donate - self.m_nCost
		CacheCenter:getGuildInfo().totalDonate = CacheCenter:getGuildInfo().totalDonate - self.m_nCost
		GetElement(self.m_root, "Contribution1", WZUILabelTTF):setText(donate)
		self.m_nCost = 0
	end

	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildStore()
end

--@brief	公会商店刷新
function SceneCommunityShop:onRefresh()
	WZLog("SceneCommunityShop:onRefresh")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	--免费刷新次数
	local count = GetElement(self.m_root, "refreshTime4", WZUILabelTTF):getText()
	count = tonumber(count)
	if count <= 0 then
		--MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO46)
		--弹出是否使用贡献刷新商品的窗口
		local wndDismissCommunity = WndDismissCommunity:createElement()
		WindowManager:addWindow(wndDismissCommunity,WndDismissCommunity)
		WndDismissCommunity:setRefreshShopItem()
    	WndDismissCommunity:setBtnVisable(1)
	else
		ProtocolProcessorSceneCommunity:send_GUILD_RefreshGuildStore()
	end
end

--@brief	公会商店升级
function SceneCommunityShop:onUpgrade()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local guildInfo = CacheCenter:getGuildInfo()
	if GUILDMAXLEVEL == nil then
		GUILDMAXLEVEL = GetMaxGuildLevel()
	end
	--公会商店已是最高等级
	if guildInfo.storeLevel >= GUILDMAXLEVEL then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO39)
		return
	end

	--公会商店等级和公会等级相同
	if guildInfo.guildLevel == guildInfo.storeLevel then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO30)
		return
	end

	local cost = 0
	for k,v in pairs(GDatatab_guild_building) do
		if v.type == 3 and v.level == (guildInfo.storeLevel + 1) then
			cost = v.cost[1][2]
		end
	end 

	WndCommunityUpgrade:showShopUpgrade() 
	WndCommunityUpgrade.m_nCost = cost
end

--@brief	公会商店说明
function SceneCommunityShop:onInfo()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.CommunityExplain3)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新商品列表
function SceneCommunityShop:_update()
	local guildInfo = CacheCenter:getGuildInfo()
	if guildInfo == nil then return end
	
	local discount 

	for k,v in pairs(GDatatab_guild_store_discount) do
		if v.store_level == guildInfo.storeLevel then
			discount = (v.discount/1000)
		end
	end

	--设置公会威望
	GetElement(self.m_root, "CommunityPrestige1", WZUILabelTTF):setText(guildInfo.prestige)

	--设置个人贡献
	GetElement(self.m_root, "Contribution1", WZUILabelTTF):setText(guildInfo.totalDonate)

	--设置公会等级
	GetElement(self.m_root, "CommunityLv1", WZUILabelTTF):setText(guildInfo.guildLevel)

	--设置公会商店等级
	GetElement(self.m_root, "ShopLv1", WZUILabelTTF):setText(guildInfo.storeLevel)

	--公会等级名称id
	local info = [[<T C="79,60,48" S="20" P="0">Lv%s </T><T C="128,54,13" S="20" P="0">%s  </T><T C="138,122,106" S="20" P="0">(ID:%s)</T>]]
	local info1 = string.format(info,guildInfo.guildLevel,guildInfo.guildName,guildInfo.guildId)
	GetElement(self.m_root,"infoFree_SceneCommunityShop",WZUIFreeTextBox):setShowText(info1)

	local timeString = {"晚上9点","凌晨2点","早上9点","中午12点","下午6点"}
	--语言适配
	local language = ProjConfig.LANGUAGE
	if language ~= "cn"  then
		timeString = {"PM 9:00","AM 2:00","AM 9:00","AM 12:00","PM 6:00"}
	end
	
	--下次自动刷新时间
	local hours = os.date("%H", self.nextRefreshTime)
	hours = tonumber(hours)
	local displayTime
	if (hours >= 21 and hours <= 24) or hours == 0 or hours == 1 then
		displayTime = timeString[1]
	elseif hours >= 2 and hours < 9 then
		displayTime = timeString[2]
	elseif hours >= 9 and hours < 12 then
		displayTime = timeString[3]
	elseif hours >= 12 and hours < 18 then
		displayTime = timeString[4]
	elseif hours >= 18 and hours < 21 then
		displayTime = timeString[5]
	end

	GetElement(self.m_root, "refreshTime1", WZUILabelTTF):setText(displayTime)

	--免费刷新次数
	GetElement(self.m_root, "refreshTime4", WZUILabelTTF):setText(self.refreshCount)

	local tableCon = GetElement(self.m_root,"tbcon_SceneShop",WZUITableContainer)
	--加载表格元素
	for i = 1,#self.m_tShopList do 
		local celElement,tCell =  CellCommunityShop:createElement()
		local itemInfo = self.m_tShopList[i]
		local id, num = SplitItemString(itemInfo.store)
		local costID, cost = SplitItemString(itemInfo.cost)
		if celElement ~= nil and tCell ~= nil then 
			tCell:setCellShop(itemInfo,itemInfo.storeId,id[1],num[1],cost[1],itemInfo.status,itemInfo.guildLevel,discount,costID[1])
			celElement:setTag(i - 1)
			tableCon:setCellElement(celElement)
		end 
	end 

	--是否显示升级建筑按钮
	if guildInfo.position >= 3 then
		GetElement(self.m_root, "btnUpgrade", WZUIButton):setVisible(true)
	else
		GetElement(self.m_root, "btnUpgrade", WZUIButton):setVisible(false)
	end
end

--@brief	设置个人贡献
function SceneCommunityShop:setContribution(contribution)
	GetElement(self.m_root, "Contribution1", WZUILabelTTF):setText(contribution)
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Began------------------------------------------
function SceneCommunityShop:_adaptLanguage_vn(  )
	GetElement(self.m_root,"Contribution1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.525,0.5))
	GetElement(self.m_root,"refreshTime1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.46,0.5))
	GetElement(self.m_root,"refreshTime4",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.575,0.5))
	GetElement(self.m_root,"ShopLv1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.34,0.5))
end

--@brief	英文包适配函数
function SceneCommunityShop:_adaptLanguage_en()
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.5))
	GetElement(self.m_root,"Contribution1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.53,0.5))
end

function SceneCommunityShop:_adaptLanguage_pt(  )
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.5))
	GetElement(self.m_root,"Contribution1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.52,0.5))
	GetElement(self.m_root,"Contribution",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"refreshTime3",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"refreshTime4",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.5))
end

function SceneCommunityShop:_adaptLanguage_tr(  )
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.5))
	GetElement(self.m_root,"Contribution1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
	GetElement(self.m_root,"Contribution",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"ShopLv1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.65,0.5))
	GetElement(self.m_root,"refreshTime4",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.5))
	local refreshTime1 = GetElement(self.m_root,"refreshTime1",WZUILabelTTF)
	refreshTime1:setRelativePosition(GlobalMethod:ccp(0.68,0.5))
end

function SceneCommunityShop:_adaptLanguage_es(  )
	local refreshTime = GetElement(self.m_root,"refreshTime",WZUILabelTTF)
	refreshTime:setDimensions(GlobalMethod:CCSize(200,0))
	refreshTime:setFontSize(16)

	local refreshTime1 = GetElement(self.m_root,"refreshTime1",WZUILabelTTF)
	refreshTime1:setRelativePosition(GlobalMethod:ccp(0.7,0.5))

	local CommunityPrestige1 = GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF)
	CommunityPrestige1:setRelativePosition(GlobalMethod:ccp(0.45,0.5))

	local ShopLv1 = GetElement(self.m_root,"ShopLv1",WZUILabelTTF)
	ShopLv1:setRelativePosition(GlobalMethod:ccp(0.57,0.5))

	local refreshTime4 = GetElement(self.m_root,"refreshTime4",WZUILabelTTF)
	refreshTime4:setRelativePosition(GlobalMethod:ccp(0.6,0.5))

	GetElement(self.m_root,"refreshTime3",WZUILabelTTF):setFontSize(16)
end
-------------------------------------语言适配End--------------------------------------------
