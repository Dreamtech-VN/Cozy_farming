--CellLeaguePlayer.lua
--@brief	CellLeaguePlayer的UI模块
--@date		2016-06-27
--@author	binshao
--@note		房间玩家


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeaguePlayer:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeaguePlayer:onExit(element)
	self:_unInit()
end

-- 查看武器
function CellLeaguePlayer:onEquip(element)
	local data = self.data
	if not data.extranInfo or not next(data.extranInfo) then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WZLog("-------------onEquip---------------")
	local conEquip= GetElement(self.m_root,"conEquip_CellLeaguePlayer",WZUIContainer)
	local weaponInfo = {}
	weaponInfo.id = data.equip[4]
	weaponInfo.basicInfo = GDatatab_item["id_"..data.equip[4]]
	weaponInfo.extraInfo = data.extranInfo
	weaponInfo.maintype = weaponInfo.basicInfo.main_type
	weaponInfo.subtype = weaponInfo.basicInfo.sub_type
	weaponInfo.isUse = true

	-- 武器tips
	local con = SceneLeagueRoom:getTipsCon()
	WndItemInfo:showInfo(conEquip,con,1,weaponInfo,false,nil,false)
end


-- 查看宠物
function CellLeaguePlayer:onPet()
	local data = self.data
	if not data.pet or not next(data.pet) then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local conPet= GetElement(self.m_root,"conPet_CellLeaguePlayer",WZUIContainer)
	local con = SceneLeagueRoom:getTipsCon()
	local pos = GlobalMethod:ccp(200,-30)
	if data.pos == 3 or data.pos == 6 then
		pos = GlobalMethod:ccp(200,0)
	end

	WndTips:show(conPet,con,13,data.pet,pos)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellLeaguePlayer:update()
	local data = self.data

	-- 是否存在玩家
	local imgDi = GetElement(self.m_root, "imgHeiDi_CellLeaguePlayer", WZUI9Image)
	local conHave = GetElement(self.m_root, "conHave_CellLeaguePlayer", WZUIContainer)
	local conNot = GetElement(self.m_root, "conNot_CellLeaguePlayer", WZUIContainer)
	if data then
		imgDi:setVisible(false)
		conHave:setVisible(true)
		conNot:setVisible(false)
	else
		imgDi:setVisible(true)
		conHave:setVisible(false)
		conNot:setVisible(true)
		return
	end

	-- 玩家等级
	local txtLv = GetElement(self.m_root,"txtPlayerLevel_CellLeaguePlayer",WZUILabelTTF)
	txtLv:setText("Lv"..data.playerLevel)

	-- 玩家名字
	local txtName = GetElement(self.m_root,"txtPlayerName_CellLeaguePlayer",WZUILabelTTF)
	txtName:setText(data.playerName)

	local serverId = IPDhttpServer:getCurServerId()
	local ftbName = GetElement(self.m_root, "ftbName_CellLeaguePlayer", WZUIFreeTextBox)
	local txtName = GetElement(self.m_root,"txtPlayerName_CellLeaguePlayer",WZUILabelTTF)
	-- 本服
	if tonumber(serverId) == tonumber(data.serverId) then
		ftbName:setVisible(false)
		txtName:setVisible(true)
		txtName:setText(data.playerName)
	else
		-- 跨服
		ftbName:setVisible(true)
		txtName:setVisible(false)
		ftbName:setShowText(string.format(LocalStrings.ALL_SERCER_RANK_NAME1,data.playerName))
	end

	-- 玩家战斗力
	local txtFight = GetElement(self.m_root, "labFireCnt_CellLeaguePlayer", WZUILabelAtlasFont)
	txtFight:setText(data.fighting)

	-- 创建玩家形象
	local conP = GetElement(self.m_root,"conPlayer_CellLeaguePlayer",WZUIContainer)
	local conPlayer, _1, _2, isMonster = CreatePlayerFigure(data.playerSex,data.equip,nil,nil,nil,nil,nil,nil,nil,nil,data.headColor,data.bodyColor)
	local pNode = conPlayer:getAnimNode()
	pNode:setScale(0.6)
	conP:addChild(pNode)
	if isMonster == true then
		conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0))
		conPlayer:getAnimNode():setRelativePosition(ccp(0.5,0.25))
	end

	-- 宠物
	local petInfo = data.pet
	if petInfo then
		if petInfo.itemId and petInfo.animation then
			local conPet= GetElement(self.m_root,"conPet_CellLeaguePlayer",WZUIContainer)
			local ani,par =  CreatePetAni(conPet,petInfo.itemId,petInfo.animation,petInfo.advancedLevel, petInfo.petSkinItemId)
			ani:setScale(0.48)
			if par then par:setScale(0.48) end
			ani:getAnimNode():setTouchEnable(false)
		end
	end

	-- 武器图片
	local imgEquip = GetElement(self.m_root,"imgEquip_CellLeaguePlayer",WZUIImage)
	local equipInfo = GDatatab_item["id_"..data.equip[4]]
	local icon = equipInfo.icon
	imgEquip:setFile(icon)

	-- 武器特效
	local spine = GetElement(self.m_root,"spineEquip_CellLeaguePlayer",WZUISpine)
	local aniName = self:_getAniName()
	WZLog("--------------equip star level----------------",self.data.extranInfo.starLevel,aniName)
	if aniName then
		spine:play(tostring(aniName),true)
		spine:setVisible(true)
	else
		spine:setVisible(false)
	end

	-- 右边的玩家
	if data.pos >= 4 then
		local imgDi = GetElement(self.m_root, "imgDi_CellLeaguePlayer", WZUIImage)
		imgDi:setScaleX(-1)

		conP:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		conP:setRelativePosition(GlobalMethod:ccp(0,0.55))

		local conF = GetElement(self.m_root,"conFight_CellLeaguePlayer",WZUIContainer)
		conF:setRelativePosition(GlobalMethod:ccp(0.95,0.5))

		local conEquip= GetElement(self.m_root,"conEquip_CellLeaguePlayer",WZUIContainer)
		conEquip:setRelativePosition(GlobalMethod:ccp(0.4,0.22561))

		local conNameLv= GetElement(self.m_root,"conNameLv_CellLeaguePlayer",WZUIContainer)
		conNameLv:setRelativePosition(GlobalMethod:ccp(0.82,0.5))

		local conPet= GetElement(self.m_root,"conPet_CellLeaguePlayer",WZUIContainer)
		conPet:setRelativePosition(GlobalMethod:ccp(0.45,0.5))

		local btnPet= GetElement(self.m_root,"btnPet_CellLeaguePlayer",WZUIButton)
		btnPet:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
	end
end

-- 获取武器特效动画的名字
function CellLeaguePlayer:_getAniName()
	local starLevel = self.data.extranInfo.starLevel
	local star = {12,10,8,5}
	for i = 1, #star do
		if starLevel >= star[i] then return star[i] end
	end
	return nil
end
-------------------------------------私有方法模块End----------------------------------------