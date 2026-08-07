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
	local tag = element:getTag()
	--图腾属性
	local totemInfo = GDatatab_guild_totem["id_"..guildInfo.totemLevel]
	WZLog("图腾洗礼",totemInfo.baptism_cost[1][1],totemInfo.baptism_cost[1][2])
	if tag == 2 then
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.COMMUNITYINFO243,totemInfo.baptism_cost[1][2]),self,self.refreshSure, nil, nil)
	else 
		--瞻仰消耗金币
		if tag == 0 and CacheCenter:getMoneyList().gold < totemInfo.cost[1][2] then
			MsgBoxManager:showConfirmCancelBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil)
			return
		end
		--双倍瞻仰消耗
		if tag == 1 then
			if not JudgeMoneyIsEnough(totemInfo.double_cost[1][1], totemInfo.double_cost[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureCost2) then
				return
			end
		end
		if os.date("%y%m%d", CacheCenter:getGuildInfo().totemPayTime) == os.date("%y%m%d", os.time()) then
			if ProjConfig.LANGUAGE == "cn" then
				MsgBoxManager:showTipBox(LocalStrings.ZHANYANGTIME)
			end
		else
			ProtocolProcessorSceneCommunity:send_GUILD_TotemPay(tag)
			SceneCommunityMain:createLoading()
		end
	end
end

function SceneCommunityTotem:sureCost2()
	ProtocolProcessorSceneCommunity:send_GUILD_TotemPay(1)
	SceneCommunityMain:createLoading()
end

function SceneCommunityTotem:refreshSure()
	-- body
	local guildInfo = CacheCenter:getGuildInfo()
	local totemInfo = GDatatab_guild_totem["id_"..guildInfo.totemLevel]
	if guildInfo.totalDonate < totemInfo.baptism_cost[1][2] then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO37)
		return
	end
	SceneCommunityMain:createLoading()	
	ProtocolProcessorSceneCommunity:send_GUILD_TotemPay(2)
end

--@brief	瞻仰成功
function SceneCommunityTotem:learnSuccess(ntype)
	if self.m_root == nil then return end
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
	if ntype ~= 2 then
	--获取瞻仰倒计时
		GetElement(self.m_root,"btnLearn",WZUIButton):setTouchEnable(false)
		GetElement(self.m_root,"btnLearn1",WZUIButton):setTouchEnable(false)
	else 
		-- WZLog("洗礼成功")
		GetElement(self.m_root,"btnUpgrade2",WZUIButton):setTouchEnable(false)
		GetElement(self.m_root,"btnUpgrade3",WZUIButton):setTouchEnable(false)
	end
end

--@brief	图腾时间倒计时
function SceneCommunityTotem:timeStep(element,t)
	self.m_nLeftTime = self.m_nLeftTime - 1

	if self.m_nLeftTime <= 0 then
		self.time1 = GetElement(self.m_root,"timeLeft_SceneTotem",WZUILabelTTF)
		self.time1:setText("00:00:00")
		self.time1:disableSchedule()
	end

		local s = self.m_nLeftTime % 60
		local m = ((self.m_nLeftTime - s) / 60) % 60
		local h = ((self.m_nLeftTime - s) / 60 - m) / 60
		if s < 10 then s = "0"..s end
		if m < 10 then m = "0"..m end
		if h < 10 then h = "0"..h end
		local date = h..":"..m..":"..s

		self.time1:setText(date)
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
	self.time1 = GetElement(self.m_root,"timeLeft_SceneTotem",WZUILabelTTF)
	self.time2 = GetElement(self.m_root,"timeLeft1_SceneTotem",WZUILabelTTF)
	if self.m_nLeftTime == 0 then
		self.time1:setText("00:00:00")
	else
		GetElement(self.m_root,"btnLearn",WZUIButton):setTouchEnable(false)
		GetElement(self.m_root,"btnLearn1",WZUIButton):setTouchEnable(false)
		self:timeStep()
		self.time1:enableSchedule("timeStep",1)
	end
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setText(guildInfo.prestige)
	WZLog("是否可以洗礼",guildInfo.isXili)
	if guildInfo.isXili > 0 then
		self.m_nLeftTime1 = guildInfo.isXili
		GetElement(self.m_root,"btnUpgrade2",WZUIButton):setTouchEnable(false)
		GetElement(self.m_root,"btnUpgrade3",WZUIButton):setTouchEnable(false)
		self:timeStep1()
		self.time2:enableSchedule("timeStep1",1)
	elseif guildInfo.isXili == 0 then
		self.time2:setText("00:00:00")
	end
end

--@brief	洗礼时间倒计时
function SceneCommunityTotem:timeStep1(element,t)
	self.m_nLeftTime1 = self.m_nLeftTime1 - 1

	if self.m_nLeftTime1 <= 0 then
		self.time2 = GetElement(self.m_root,"timeLeft1_SceneTotem",WZUILabelTTF)
		self.time2:setText("00:00:00")
		self.time2:disableSchedule()
	end

		local s = self.m_nLeftTime1 % 60
		local m = ((self.m_nLeftTime1 - s) / 60) % 60
		local h = ((self.m_nLeftTime1 - s) / 60 - m) / 60
		if s < 10 then s = "0"..s end
		if m < 10 then m = "0"..m end
		if h < 10 then h = "0"..h end
		local date = h..":"..m..":"..s

		self.time2:setText(date)
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
	--公会图腾等级
	GetElement(self.m_root,"Level1",WZUILabelTTF):setText(guildInfo.totemLevel)
	GetElement(self.m_root,"imgTotemLevel",WZUIImage):setFile("ui/community/common_icon_gonghui"..guildInfo.totemLevel..".png")
	--公会等级名称id
	local info = [[<T C="255,227,116" S="20" P="0" SC="132,66,29" SS="4" SE="1">Lv%s </T><T C="255,236,193" S="20" P="0" SC="132,66,29" SS="4" SE="1">%s</T><T C="255,236,193" S="20" P="0" SC="132,66,29" SS="4" SE="1">(ID:%s)</T>]]
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
	GetElement(self.m_root,"btnUpgrade",WZUIButton):setVisible(false)
	GetElement(self.m_root,"conUpgrade1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conUpgrade2",WZUIContainer):setVisible(false)
	-- local needNum = json.decode(CacheCenter:getGameParam()["baptismRequire"])
	-- WZLog("更新公会图腾界面",json.decode(CacheCenter:getGameParam()["baptismRequire"]))
	-- local haveNum = CacheCenter:getPlayerItemCountById(7)
	GetElement(self.m_root,"Cost2",WZUILabelTTF):setText(totemInfo.double_cost[1][2])
	--是否显示升级建筑按钮
	if guildInfo.position >= 3 then
		-- GetElement(self.m_root, "btnUpgrade", WZUIButton):setVisible(true)
		if guildInfo.isXili >= 0 then
			GetElement(self.m_root,"conUpgrade1",WZUIContainer):setVisible(true)
			GetElement(self.m_root,"time1",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"timeLeft1_SceneTotem",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"conValue1",WZUIContainer):setVisible(true)
			GetElement(self.m_root,"conValue2",WZUIContainer):setVisible(true)
			GetElement(self.m_root,"conValue3",WZUIContainer):setVisible(true)
			GetElement(self.m_root,"conValue4",WZUIContainer):setVisible(true)
		else 
			GetElement(self.m_root,"btnUpgrade",WZUIButton):setVisible(true)
			GetElement(self.m_root,"time1",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"timeLeft1_SceneTotem",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"conValue1",WZUIContainer):setVisible(false)
			GetElement(self.m_root,"conValue2",WZUIContainer):setVisible(false)
			GetElement(self.m_root,"conValue3",WZUIContainer):setVisible(false)
			GetElement(self.m_root,"conValue4",WZUIContainer):setVisible(false)
		end
	else
		if guildInfo.isXili >= 0 then
			GetElement(self.m_root,"conUpgrade2",WZUIContainer):setVisible(true)
			GetElement(self.m_root,"time1",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"timeLeft1_SceneTotem",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"conValue1",WZUIContainer):setVisible(true)
			GetElement(self.m_root,"conValue2",WZUIContainer):setVisible(true)
			GetElement(self.m_root,"conValue3",WZUIContainer):setVisible(true)
			GetElement(self.m_root,"conValue4",WZUIContainer):setVisible(true)
		end
		-- GetElement(self.m_root, "btnUpgrade", WZUIButton):setVisible(false)
	end
	GetElement(self.m_root,"add2",WZUILabelTTF):setText(totemInfo.baptism_property[1][2])
	GetElement(self.m_root,"add4",WZUILabelTTF):setText(totemInfo.baptism_property[2][2])
	GetElement(self.m_root,"add6",WZUILabelTTF):setText(totemInfo.baptism_property[3][2])
	local add7 = GetElement(self.m_root,"add7",WZUIFreeTextBox)
	add7:setShowText(string.format(LocalStrings.COMMUNITYINFO249,ATTR_TITLE[totemInfo.baptism_addition[1][1]],tonumber(totemInfo.baptism_addition[1][2])/100 .. "%"))
	GetElement(self.m_root,"rewardNum1",WZUILabelTTF):setText(totemInfo.gift[1][2])
	GetElement(self.m_root,"rewardNum2",WZUILabelTTF):setText(totemInfo.gift[1][2])
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

	GetElement(self.m_root,"imgCost2",WZUIImage):setFile("shopitems/diamond.png")

	GetElement(self.m_root,"zyTotem111",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"zyTotem211",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"zyTotem311",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"timeLeft1_SceneTotem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.75,0.2))

	GetElement(self.m_root,"add6",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.5))
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


function SceneCommunityTotem:_adaptLanguage_ug(  )
	GetElement(self.m_root,"CommunityPrestige",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.5))
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0,0.5))
	GetElement(self.m_root,"txtStarSoulButtonUpdate_SceneCommunityTotem",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"Level",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.77,0.5))
	GetElement(self.m_root,"Level1",WZUILabelTTF):setAnchorPoint(GlobalMethod:ccp(1,0.5))
	GetElement(self.m_root,"SchoolLevel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))

	local SchoolLevel1 = GetElement(self.m_root,"SchoolLevel1",WZUILabelTTF)
	SchoolLevel1:setScale(0.8)
	SchoolLevel1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	SchoolLevel1:setRelativePosition(GlobalMethod:ccp(1.2,0.5))
	local SchoolLevel2 = GetElement(self.m_root,"SchoolLevel2",WZUILabelTTF)
	SchoolLevel2:setScale(0.8)
	SchoolLevel2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	SchoolLevel2:setRelativePosition(GlobalMethod:ccp(1.2,0.5))
	local SchoolLevel3 = GetElement(self.m_root,"SchoolLevel3",WZUILabelTTF)
	SchoolLevel3:setScale(0.8)
	SchoolLevel3:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	SchoolLevel3:setRelativePosition(GlobalMethod:ccp(1.2,0.5))
	local SchoolLevel1 = GetElement(self.m_root,"SchoolAttr1",WZUILabelTTF)
	SchoolLevel1:setScale(0.8)
	SchoolLevel1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	SchoolLevel1:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
	local SchoolLevel2 = GetElement(self.m_root,"SchoolAttr2",WZUILabelTTF)
	SchoolLevel2:setScale(0.8)
	SchoolLevel2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	SchoolLevel2:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
	local SchoolLevel3 = GetElement(self.m_root,"SchoolAttr3",WZUILabelTTF)
	SchoolLevel3:setScale(0.8)
	SchoolLevel3:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	SchoolLevel3:setRelativePosition(GlobalMethod:ccp(0.15,0.5))

	local cost = GetElement(self.m_root,"Cost",WZUILabelTTF)
	cost:setScale(0.7)
	cost:setDimensions(GlobalMethod:CCSize(200))
	cost:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
	local Cost1 = GetElement(self.m_root,"Cost1",WZUILabelTTF)
	Cost1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	Cost1:setRelativePosition(GlobalMethod:ccp(0.43,0.5))

	local zyTotem1 = GetElement(self.m_root,"zyTotem1",WZUILabelTTF)
	zyTotem1:setScale(0.6)
	zyTotem1:setDimensions(GlobalMethod:CCSize(220))
	local zyTotem2 = GetElement(self.m_root,"zyTotem2",WZUILabelTTF)
	zyTotem2:setScale(0.6)
	zyTotem2:setDimensions(GlobalMethod:CCSize(220))
	local zyTotem3 = GetElement(self.m_root,"zyTotem3",WZUILabelTTF)
	zyTotem3:setScale(0.6)
	zyTotem3:setDimensions(GlobalMethod:CCSize(220))
end
-------------------------------------私有方法模块End----------------------------------------

