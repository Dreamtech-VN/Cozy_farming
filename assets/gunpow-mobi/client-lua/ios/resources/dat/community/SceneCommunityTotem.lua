--SceneCommunityTotem.lua
--@brief	SceneCommunityTotem的UI模块
--@date		2015/04/23
--@author	zsq
--@note		公会图腾


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCommunityTotem:onEnter(element)
	self.m_root = element

	self:_addTop()

	self:_moreLanguage()

	self:_update()

	--获取瞻仰倒计时
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()

	--设置图腾一直上下浮动
    local imgTotemLevel = GetElement(self.m_root, "imgTotemLevel", WZUIImage)
    local array = CCArray:create()
    array:addObject(CCMoveBy:create(1.25,GlobalMethod:ccp(0,10)))
    array:addObject(CCMoveBy:create(1.25,GlobalMethod:ccp(0,-10)))
    local action =  CCRepeatForever:create(CCSequence:create(array))
    GetElement(self.m_root,"imgTotemLevel",WZUIImage):runAction(action)

    AdaptLanguage(self)
end

function SceneCommunityTotem:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/community/common_icon_ghtt.png",SceneCommunityTotem,SceneCommunityTotem.onClose,true,false,false,"SceneCommunityTotem")
end

function SceneCommunityTotem:_moreLanguage()
    GetElement(self.m_root,"SchoolLevel1",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO40,LocalStrings.HEALTH))
	GetElement(self.m_root,"SchoolLevel2",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO40,LocalStrings.ATTACK))
	GetElement(self.m_root,"SchoolLevel3",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO40,LocalStrings.DEFENSE))
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCommunityTotem:onExit(element)
	self:_unInit()
end

--@brief	触摸开始回调
function SceneCommunityTotem:onTouchBegin(element, pt)
	-- body
	if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

--@brief	关闭按钮
function SceneCommunityTotem:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	--进入公会场景
   	--replaceScene(SceneCommunityMain:createElement())
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	图腾升级
function SceneCommunityTotem:onUpgrade(element)
	WZLog("SceneCommunityTotem:onUpgrade")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local guildInfo = CacheCenter:getGuildInfo()
	if guildInfo == nil then return end
	if GUILDMAXLEVEL == nil then
		GUILDMAXLEVEL = GetMaxGuildLevel()
	end
	--图腾已是最高等级
	if guildInfo.totemLevel >= GUILDMAXLEVEL then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO29)
		return
	end

	--图腾等级和公会等级相同
	if guildInfo.guildLevel == guildInfo.totemLevel then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO30)
		return
	end

	local cost = 0
	for k,v in pairs(GDatatab_guild_building) do
		if v.type == 1 and v.level == (guildInfo.totemLevel + 1) then
			cost = v.cost[1][2]
		end
	end 

	WndCommunityUpgrade:showTotemUpgrade() 
	WndCommunityUpgrade.m_nCost = cost
end

--@brief	图腾说明
function SceneCommunityTotem:onInfo(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.CommunityExplain1)
	WZLog("SceneCommunityTotem:onInfo",CacheCenter:getGuildInfo().totemLevel)
end

--@brief	瞻仰图腾
function SceneCommunityTotem:onLearn(element)
	WZLog("SceneCommunityTotem:onLearn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local guildInfo = CacheCenter:getGuildInfo()

	--图腾属性
	local totemInfo = GDatatab_guild_totem["id_"..guildInfo.totemLevel]
	--瞻仰消耗金币
	if CacheCenter:getMoneyList().gold < totemInfo.cost[1][2] then
		MsgBoxManager:showConfirmCancelBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil)
		return
	end

	if os.date("%y%m%d", CacheCenter:getGuildInfo().totemPayTime) == os.date("%y%m%d", os.time()) then
		if ProjConfig.LANGUAGE == "cn" then
			MsgBoxManager:showTipBox("今天已经瞻仰过图腾")
		end
	else
		ProtocolProcessorSceneCommunity:send_GUILD_TotemPay()
		SceneCommunityMain:createLoading()
	end
end

--@brief	瞻仰成功
function SceneCommunityTotem:learnSuccess()
	if self.m_root == nil then return end
	GetElement(self.m_root,"btnLearn",WZUIButton):setTouchEnable(false)

	--获取瞻仰倒计时
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
end

--@brief	图腾时间倒计时
function SceneCommunityTotem:timeStep(element,t)
	self.m_nLeftTime = self.m_nLeftTime - 1

	if self.m_nLeftTime <= 0 then
		GetElement(self.m_root,"timeLeft_SceneTotem",WZUILabelTTF):setText("00:00:00")
		self.m_root:disableSchedule()
	end

		local s = self.m_nLeftTime % 60
		local m = ((self.m_nLeftTime - s) / 60) % 60
		local h = ((self.m_nLeftTime - s) / 60 - m) / 60
		if s < 10 then s = "0"..s end
		if m < 10 then m = "0"..m end
		if h < 10 then h = "0"..h end
		local date = h..":"..m..":"..s

		GetElement(self.m_root,"timeLeft_SceneTotem",WZUILabelTTF):setText(date)
end

--@brief	更新瞻仰时间
function SceneCommunityTotem:updateCountDown()
	if self.m_root == nil then return end
	local guildInfo = CacheCenter:getGuildInfo()
	if guildInfo == nil then return end
	self.m_nLeftTime = tonumber(guildInfo.totemPayTime)
	WZLog("SceneCommunityTotem:updateCountDown", self.m_nLeftTime)
	--图腾buff时间  膜拜时间为0或者膜拜日期不是今天显示00:00:00
	if self.m_nLeftTime == nil or self.m_nLeftTime < 0 then self.m_nLeftTime = 0 end

	if self.m_nLeftTime == 0 then
		GetElement(self.m_root,"timeLeft_SceneTotem",WZUILabelTTF):setText("00:00:00")
	else
		GetElement(self.m_root,"btnLearn",WZUIButton):setTouchEnable(false)
		self:timeStep()
		self.m_root:enableSchedule("timeStep",1)
	end
end

--@brief	快速购买金币框
function SceneCommunityTotem:buyGold(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		WndBuyActivity:showBuyInterface(26)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新公会图腾界面
function SceneCommunityTotem:_update()
	local guildInfo = CacheCenter:getGuildInfo()
	if guildInfo == nil then return end
	WZLog("SceneCommunityTotem:_update")
	--公会威望
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setText(guildInfo.prestige)
	--公会等级
	GetElement(self.m_root,"CommunityLv1",WZUILabelTTF):setText(guildInfo.guildLevel)
	--公会图腾等级
	GetElement(self.m_root,"Level1",WZUILabelTTF):setText(guildInfo.totemLevel)
	GetElement(self.m_root,"imgTotemLevel",WZUIImage):setFile("ui/community/common_icon_gonghui"..guildInfo.totemLevel..".png")
	--公会等级名称id
	local info = [[<T C="255,227,116" S="20" P="0">Lv%s </T><T C="255,236,193" S="20" P="0">%s  </T><T C="255,236,193" S="20" P="0">(ID:%s)</T>]]
	local info1 = string.format(info,guildInfo.guildLevel,guildInfo.guildName,guildInfo.guildId)
	GetElement(self.m_root,"infoFree_SceneCommunityTotem",WZUIFreeTextBox):setShowText(info1)
	--图腾属性
	local totemInfo = GDatatab_guild_totem["id_"..guildInfo.totemLevel]
	--瞻仰消耗金币
	GetElement(self.m_root,"Cost1",WZUILabelTTF):setText(totemInfo.cost[1][2])
	for i=1,3 do
		GetElement(self.m_root,"SchoolLevel"..i,WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"SchoolAttr"..i,WZUILabelTTF):setVisible(false)
	end
	
	local property = totemInfo.property
	for i=1,#property do
		GetElement(self.m_root,"SchoolLevel"..i,WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"SchoolAttr"..i,WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"SchoolLevel"..i,WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO40,ATTR_TITLE[property[i][1]]))
		GetElement(self.m_root,"SchoolAttr"..i,WZUILabelTTF):setText((property[i][2]))
	end

	--是否显示升级建筑按钮
	if guildInfo.position >= 3 then
		GetElement(self.m_root, "btnUpgrade", WZUIButton):setVisible(true)
	else
		GetElement(self.m_root, "btnUpgrade", WZUIButton):setVisible(false)
	end
end


function SceneCommunityTotem:_adaptLanguage_vn()
	local communityPrestige1 = GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF)
	communityPrestige1:setRelativePosition(GlobalMethod:ccp(0.4625,0.5))

	local schoolAttr1 = GetElement(self.m_root,"SchoolAttr1",WZUILabelTTF)
	schoolAttr1:setRelativePosition(GlobalMethod:ccp(0.8,0.5))

	local schoolAttr2 = GetElement(self.m_root,"SchoolAttr2",WZUILabelTTF)
	schoolAttr2:setRelativePosition(GlobalMethod:ccp(0.8,0.5))

	local schoolAttr3 = GetElement(self.m_root,"SchoolAttr3",WZUILabelTTF)
	schoolAttr3:setRelativePosition(GlobalMethod:ccp(0.83,0.5))

	GetElement(self.m_root,"zyTotem1",WZUILabelTTF):setScale(0.9)
	GetElement(self.m_root,"zyTotem2",WZUILabelTTF):setScale(0.9)
	GetElement(self.m_root,"zyTotem3",WZUILabelTTF):setScale(0.9)

end


--@brief	英文包适配函数
function SceneCommunityTotem:_adaptLanguage_en()
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
	for i=1,3 do
		GetElement(self.m_root,"SchoolLevel"..i,WZUILabelTTF):setScale(0.85)
		GetElement(self.m_root,"SchoolAttr"..i,WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.85,0.5))
		GetElement(self.m_root,"zyTotem"..i,WZUILabelTTF):setScale(0.75)
	end
	GetElement(self.m_root,"Cost",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0,0.5))
end

function SceneCommunityTotem:_adaptLanguage_pt(  )
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
	for i=1,3 do
		GetElement(self.m_root,"zyTotem"..i,WZUILabelTTF):setScale(0.75)
	end

	GetElement(self.m_root,"SchoolAttr1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.85,0.5))
	GetElement(self.m_root,"SchoolAttr2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.895833,0.5))
	GetElement(self.m_root,"SchoolAttr3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.904167,0.5))

	local cost = GetElement(self.m_root,"Cost",WZUILabelTTF)
	cost:setRelativePosition(GlobalMethod:ccp(0,0.5))
	cost:setFontSize(16)
end

function SceneCommunityTotem:_adaptLanguage_tr(  )
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
	for i=1,3 do
		GetElement(self.m_root,"SchoolLevel"..i,WZUILabelTTF):setScale(0.85)
		GetElement(self.m_root,"SchoolAttr"..i,WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.85,0.5))
		local zyTotem = GetElement(self.m_root,"zyTotem"..i,WZUILabelTTF)
		zyTotem:setScale(0.8)
		zyTotem:setDimensions(GlobalMethod:CCSize(130,0))
	end
	local cost = GetElement(self.m_root,"Cost",WZUILabelTTF)
	cost:setRelativePosition(GlobalMethod:ccp(0,0.5))
	cost:setFontSize(16)

	GetElement(self.m_root,"Level1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.78,0.5))
end

function SceneCommunityTotem:_adaptLanguage_es(  )
	local CommunityPrestige1 = GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF)
	CommunityPrestige1:setRelativePosition(GlobalMethod:ccp(0.43,0.5))

	local Level1 = GetElement(self.m_root,"Level1",WZUILabelTTF)
	Level1:setRelativePosition(GlobalMethod:ccp(0.78,0.5))

	GetElement(self.m_root,"SchoolLevel1",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"SchoolLevel2",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"SchoolLevel3",WZUILabelTTF):setFontSize(16)

	local SchoolAttr1 = GetElement(self.m_root,"SchoolAttr1",WZUILabelTTF)
	SchoolAttr1:setRelativePosition(GlobalMethod:ccp(0.83,0.5))

	local SchoolAttr2 = GetElement(self.m_root,"SchoolAttr2",WZUILabelTTF)
	SchoolAttr2:setRelativePosition(GlobalMethod:ccp(0.94,0.5))

	local SchoolAttr3 = GetElement(self.m_root,"SchoolAttr3",WZUILabelTTF)
	SchoolAttr3:setRelativePosition(GlobalMethod:ccp(0.98,0.5))

	local cost = GetElement(self.m_root,"Cost",WZUILabelTTF)
	cost:setFontSize(16)
	cost:setRelativePosition(GlobalMethod:ccp(-0.06,0.5))

	for i=1,3 do
		GetElement(self.m_root,"zyTotem"..i,WZUILabelTTF):setScale(0.7)
	end
	GetElement(self.m_root,"txtStarSoulButtonUpdate_SceneCommunityTotem",WZUILabelTTF):setScale(0.8)
	
end
-------------------------------------私有方法模块End----------------------------------------

