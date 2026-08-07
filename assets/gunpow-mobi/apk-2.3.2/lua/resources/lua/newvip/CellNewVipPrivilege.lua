--CellNewVipPrivilege.lua
--@brief	CellNewVipPrivilege的UI模块
--@date		2021/03/22
--@author	hyx
--@note		贵族特权


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewVipPrivilege:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewVipPrivilege:onExit(element)
	self:unregister()
	self:_unInit()
end

function CellNewVipPrivilege:register()
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_PrivilegeInfo,self._onGetPrivilegeInfo,self)
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_GetPrivilegeResult,self._onGetPrivilegeResult,self)
end
function CellNewVipPrivilege:unregister()
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_PrivilegeInfo,self._onGetPrivilegeInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_GetPrivilegeResult,self._onGetPrivilegeResult,self)
end

function CellNewVipPrivilege:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function CellNewVipPrivilege:actionCallback()
	ProtocolProcessorWndVip:send_VIP_GetVipPrivilegeGift()
	self:initShow()
	if self.m_bIsJumpToFamous then 
		self.m_bIsJumpToFamous = false 
		WndNewVip:setMainContainerVisible(false)
		WndNewVip:setChangeTitle(5)
		CellNewVipPrivilegeRank:showInterface(2) 
	end
end
function CellNewVipPrivilege:initShow()
	if not self.m_root then return end

	local str = [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">%s</T><T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1">%s%d</T>]]
	
	local pInfo = CacheCenter:getPlayerInfo()
	self.m_nCurVipIndex = pInfo.vipLevel > 0 and pInfo.vipLevel or 1
	if self.m_nCurVipIndex >= self.m_nMaxVipLevel + 1 then
		self.m_nCurVipIndex = self.m_nMaxVipLevel
	end

	local txtCurWelfareVip = GetElement(self.m_root,"txtCurWelfareVip",WZUILabelTTF)
	txtCurWelfareVip:setText(string.format(LocalStrings.NEWVIP_TEXT5, pInfo.vipLevel))

	local imgPrivillegeProgess = GetElement(self.m_root,"imgPrivillegeProgess",WZUIProgress)
	local txtCurrentVip = GetElement(self.m_root,"txtCurrentVip",WZUIFreeTextBox)
	txtCurrentVip:setShowText(string.format(str,LocalStrings.CHAT_CURRENT,LocalStrings.NEWVIP_TEXT6, pInfo.vipLevel))
	local txtNextVip = GetElement(self.m_root,"txtNextVip",WZUIFreeTextBox)
	local imgCurLevel = GetElement(self.m_root,"imgCurLevel",WZUIImage)
	if pInfo.vipLevel <= 15 then
        imgCurLevel:setFile("ui/newvip/icon_vip_hgg.png")
    elseif pInfo.vipLevel >= 16 and pInfo.vipLevel <= 19 then
        imgCurLevel:setFile("ui/newvip/icon_vip_hgg_1.png")
    elseif pInfo.vipLevel > 19 and pInfo.vipLevel <= 22 then
        imgCurLevel:setFile("ui/newvip/icon_vip_hgg_2.png")
    elseif pInfo.vipLevel > 22 then
        imgCurLevel:setFile("ui/newvip/icon_vip_hgg_3.png")
    end

	if pInfo.vipLevel == WndVip:_getMaxLevel() then
        imgPrivillegeProgess:setPercentage(100)
        txtNextVip:setShowText(LocalStrings.NEWVIP_TEXT8)
	else
		--说明
        local nextVipLv = pInfo.vipLevel+1
        if GDatatab_vip then
	        local vipData = GDatatab_vip["id_"..nextVipLv]
	        txtNextVip:setShowText(string.format(LocalStrings.NEWVIP_TEXT7,tonumber(vipData.exp-pInfo.vipExp),nextVipLv))
	        -- 进度条
	        imgPrivillegeProgess:setPercentage(math.floor(pInfo.vipExp/vipData.exp*100))
	    end
	end

	-- local privilege_reward = GetElement(self.m_root,"privilege_reward",WZUIContainer)
	-- self.m_sFreeListAdvanced = GetElement(privilege_reward,"freeListAdvanced",WZUIFreeListContainer)
	-- self.m_sFreeListAdvanced:removeAll()
	-- for i = 1, 5 do
	-- 	local element, tLuaObj = AdvancedRewardItem:createElement()
	-- 	self.m_sFreeListAdvanced:pushBack(WZUIContainer:luaTo(element))
	-- 	self.m_sFreeListAdvanced:getMoveElement():setPositionX(self.m_sFreeListAdvanced:getMaxPosition().x)
	-- end
end

function CellNewVipPrivilege:onBtnWelfare()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local welfare = CellNewVipPrivilegeWelfare:createElement()
    if welfare ~= nil then
        WindowManager:addWindow(welfare,CellNewVipPrivilegeWelfare,nil,false)
    end
end
function CellNewVipPrivilege:onBtnVipRank()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndNewVip:setMainContainerVisible(false)
	WndNewVip:setChangeTitle(5)
	CellNewVipPrivilegeRank:showInterface() 
end
function CellNewVipPrivilege:onBtnCLickLeft()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if (self.m_nCurVipIndex - 1) <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.NEWVIP_TEXT10)
		return
	end
	self.m_nCurVipIndex = self.m_nCurVipIndex - 1
	self:setChangeAdvancedVipReward(self.m_nCurVipIndex)
end
function CellNewVipPrivilege:onBtnCLickRight()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("CellNewVipPrivilege:onBtnCLickRight", self.m_nCurVipIndex, WndVip:_getMaxLevel(), self.m_nMaxVipLevel)
	if (self.m_nCurVipIndex + 1) > WndVip:_getMaxLevel() then
		MsgBoxManager:showTipBox(LocalStrings.NEWVIP_TEXT9)
		return
	end
	if (self.m_nCurVipIndex + 1) > self.m_nMaxVipLevel then
		MsgBoxManager:showTipBox(LocalStrings.NEWVIP_TEXT9)
		return
	end
	self.m_nCurVipIndex = self.m_nCurVipIndex + 1
	self:setChangeAdvancedVipReward(self.m_nCurVipIndex)
end

function CellNewVipPrivilege:setChangeAdvancedVipReward(index)
	if not self.m_root then return end
	if WndVip.m_tDataList == nil or #WndVip.m_tDataList == 0 then return end
	index = index and index > 0 and index or (CacheCenter:getPlayerInfo().vipLevel > 0 and CacheCenter:getPlayerInfo().vipLevel or 1)
	if index > self.m_nMaxVipLevel then 
		index = self.m_nMaxVipLevel 
	end

	local privilege_reward = GetElement(self.m_root,"privilege_reward",WZUIContainer)
	local vipFashOpen_con = GetElement(self.m_root,"vipFashOpen_con",WZUIContainer) --待定
	vipFashOpen_con:setVisible(false)
	local role_con = GetElement(self.m_root,"role_con",WZUIContainer) --人物
	role_con:setVisible(false)
	local role_privilage = GetElement(self.m_root,"role_privilage",WZUIContainer) --文字特权
	role_privilage:setVisible(false)
	local id,num = {},{}
	if WndVip.m_tDataList[index] and WndVip.m_tDataList[index].gift then
		id,num = SplitItemString(WndVip.m_tDataList[index].gift)
	end
	GetElement(self.m_root, "txtSubTitle_CellNewVipPrivilege", WZUILabelTTF):setText(string.format(LocalStrings.NEWVIP_TEXT4, index))
	self:showAdvancedReward(id, num, index)

	if next(id) == nil then
		vipFashOpen_con:setVisible(true)
		GetElement(vipFashOpen_con,"txtVipFash",WZUILabelTTF):setText(string.format(LocalStrings.NEWVIP_TEXT27,tonumber(index)))
		return
	else
		local show = self:setShowRole(id)
		if show == 0 then
			role_privilage:setVisible(true)
			GetElement(role_privilage,"txtVipPrivilege",WZUILabelTTF):setText(string.format(LocalStrings.NEWVIP_TEXT27,tonumber(index)))
			self:txtShowPrivilege(index)
		else
			role_con:setVisible(true)
			local tTitleList = {LocalStrings.NEWVIP_TEXT30, LocalStrings.NEWVIP_TEXT33, LocalStrings.NEWVIP_TEXT34, LocalStrings.NEWVIP_TEXT35, LocalStrings.NEWVIP_TEXT36, LocalStrings.NEWVIP_TEXT37, LocalStrings.OTHER_TEXT1[12], LocalStrings.OTHER_TEXT1[13]}
			GetElement(role_con,"roleFashionCurLevel",WZUILabelTTF):setText(string.format(tTitleList[show],tonumber(index)))
		end
	end
end

function CellNewVipPrivilege:removeDestoy(con)
	if self.m_sFootRoleSpine then
 		self.m_sFootRoleSpine:removeFromParentAndCleanup(true)
 		self.m_sFootRoleSpine = nil
	end
	if self.m_sAniMount then
 		self.m_sAniMount:removeFromParentAndCleanup(true)
 		self.m_sAniMount = nil
	end
	if self.m_sWeaponCellItem then
 		self.m_sWeaponCellItem:removeFromParentAndCleanup(true)
 		self.m_sWeaponCellItem = nil
	end
	if self.m_sConSkinPlayer then
 		self.m_sConSkinPlayer:removeFromParentAndCleanup(true)
 		self.m_sConSkinPlayer = nil
	end

	if con then 
		if con:getChildByTag(77) then 
			con:removeChildByTag(77, true)
		end
		if con:getChildByTag(88) then 
			con:removeChildByTag(88, true)
		end
	end
end
function CellNewVipPrivilege:showAdvancedReward(id, num, index)
	local privilege_reward = GetElement(self.m_root,"privilege_reward",WZUIContainer)

	local freeListAdvanced = GetElement(privilege_reward,"freeListAdvanced",WZUIFreeListContainer)
	freeListAdvanced:removeAll()
	if WndVip.m_tDataList[index] then
		for i = 1, #id do
			local element, tLuaObj = AdvancedRewardItem:createElement()
			freeListAdvanced:pushBack(WZUIContainer:luaTo(element))
			freeListAdvanced:getMoveElement():setPositionX(freeListAdvanced:getMaxPosition().x)
			tLuaObj:setAdvancedRewardData(id[i], num[i], WndVip.m_tDataList[index].status)
		end
	end
end

--文字特权
function CellNewVipPrivilege:txtShowPrivilege(index)
	local text2 = [[<I Z="1">ui/newvip/common_icon_huang.png</I><T C="255,251,237" S="24"> %s</T>]]
	local role_privilage = GetElement(self.m_root,"role_privilage",WZUIContainer)
	local pointY = 0.65
	local str = LocalStrings.NEWVIP_TEXT29[index]
	for i, v in pairs(self.m_tVipPrivilegeTxt) do
		if v then
			v:setVisible(false)
		end
	end
	if str then
		for i = 1, #str do
			if self.m_tVipPrivilegeTxt[i] == nil then
				local txt = WZUIFreeTextBox:create()
				txt:setMaxWidth(220)
				txt:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
				role_privilage:addChild(txt)
				self.m_tVipPrivilegeTxt[i] = txt
			end
			self.m_tVipPrivilegeTxt[i]:setVisible(true)
			self.m_tVipPrivilegeTxt[i]:setShowText(string.format(text2, str[i]))
			self.m_tVipPrivilegeTxt[i]:setRelativePosition(GlobalMethod:ccp(0.1, pointY - (i - 1) * 0.15))
		end
	end
end
--显示时装的展示
function CellNewVipPrivilege:setShowRole(data)
	local is_role, head_index, face_index, body_index, foot_index, mount_index, weapon_index, wing_index, skin_index, headEffectId, infoEffectId = self:isShowRole(data)
	if is_role == false then 
		return 0
	end

	local nTempIndex = 1 
	local role_con = GetElement(self.m_root,"role_con",WZUIContainer)
	local con = GetElement(self.m_root,"con",WZUIContainer)
	self:removeDestoy(con)
	--形象
	if con:getChildByTag(50) then
		con:removeChildByTag(50, true)
		self.m_sRoleConPlayer = nil
	end

	if head_index or face_index or body_index or wing_index then
		local nSex = false
		head_index = head_index or 4906
		face_index = face_index or 4905
		body_index = body_index or 4904
		if CacheCenter:getPlayerInfo().sex == 0 then
			nSex = true --男
			head_index = head_index or 4903
			face_index = face_index or 4902
			body_index = body_index or 4901
		end
		self:shoeRoleBody(con, head_index, face_index, body_index, wing_index, nSex)
		if wing_index then 
			nTempIndex = 6
		else
			nTempIndex = 1
		end
	end
	if foot_index then
		local nSex = false
		head_index = head_index or 4906
		face_index = face_index or 4905
		body_index = body_index or 4904
		if CacheCenter:getPlayerInfo().sex == 0 then
			nSex = true --男
			head_index = head_index or 4903
			face_index = face_index or 4902
			body_index = body_index or 4901
		end
		self:shoeRoleBody(con, head_index, face_index, body_index, wing_index, nSex)
		self:showRoleFoot(con, foot_index)

		nTempIndex = 2
	end
	if mount_index then
		self:showRoleMount(con, mount_index)
		nTempIndex = 3
	end
	if weapon_index then
		self:showRoleWeapon(con, weapon_index)
		nTempIndex = 4
	end
	if skin_index then
		self:showRoleSkin(con, skin_index)
		nTempIndex = 5
	end
	if headEffectId then 
		self:showHeadOrInfoEffect(con, headEffectId)
		nTempIndex = 7
	end
	if infoEffectId then 
		self:showHeadOrInfoEffect(con, nil, infoEffectId)
		nTempIndex = 8
	end

	return nTempIndex 
end
--判断时候显示人物
function CellNewVipPrivilege:isShowRole(data)
	local head_index, face_index, body_index, foot_index, mount_index, weapon_index, wing_index, skin_index, headEffectId, infoEffectId = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil 
	local is_role = false
	for i = 1, #data do
		if data[i] ~= nil then
			local itemInfo = GDatatab_item["id_" .. data[i]]
			WZLog("CellNewVipPrivilege:isShowRole", itemInfo.main_type)
			if itemInfo.main_type == 5 and itemInfo.sub_type == 0 then --头部
				head_index = data[i]
			elseif itemInfo.main_type == 5 and itemInfo.sub_type == 1 then --脸部
				face_index = data[i]
			elseif itemInfo.main_type == 5 and itemInfo.sub_type == 2 then --衣服
				body_index = data[i]
			elseif itemInfo.main_type == 2 and itemInfo.sub_type == 11 then--坐骑
				mount_index = data[i]
			elseif itemInfo.main_type == 23 then --足迹
				foot_index = data[i]
			elseif itemInfo.main_type == 4 then --武器
				if itemInfo.sub_type == 0 or itemInfo.sub_type == 1 then
					weapon_index = data[i]
				end
			elseif itemInfo.main_type == 20 and itemInfo.sub_type == 1 then --皮肤
				skin_index = data[i]
			elseif itemInfo.main_type == 5 and itemInfo.sub_type == 3 then --翅膀
				wing_index = data[i]
			--礼包
			elseif itemInfo.main_type == 3 then 
				local giftItems = getItemsInGift(tonumber(data[i]))
				WZLog("CellNewVipPrivilege:isShowRole 22", data[i], Serialize(giftItems))
				for j = 1, #giftItems do
					local itemInfo = GDatatab_item["id_" .. giftItems[j].id]
					if itemInfo.main_type == 5 and itemInfo.sub_type == 0 then --头部
						head_index = giftItems[j].id
					elseif itemInfo.main_type == 5 and itemInfo.sub_type == 1 then --脸部
						face_index = giftItems[j].id
					elseif itemInfo.main_type == 5 and itemInfo.sub_type == 2 then --衣服
						body_index = giftItems[j].id
					elseif itemInfo.main_type == 2 and itemInfo.sub_type == 11 then--坐骑
						mount_index = giftItems[j].id
					elseif itemInfo.main_type == 23 then --足迹
						foot_index = giftItems[j].id
					elseif itemInfo.main_type == 4 then --武器
						if itemInfo.sub_type == 0 or itemInfo.sub_type == 1 then
							weapon_index = giftItems[j].id
						end
					elseif itemInfo.main_type == 20 and itemInfo.sub_type == 1 then --皮肤
						skin_index = giftItems[j].id
					elseif itemInfo.main_type == 5 and itemInfo.sub_type == 3 then --翅膀
						wing_index = giftItems[j].id
					elseif itemInfo.main_type == 2 and itemInfo.sub_type == 49 then --信息特效框
						infoEffectId = giftItems[j].id
					elseif itemInfo.main_type == 40 then --头像特效框
						headEffectId = giftItems[j].id
					end
				end
			elseif itemInfo.main_type == 2 and itemInfo.sub_type == 49 then --信息特效框
				infoEffectId = data[i]
			elseif itemInfo.main_type == 40 then --头像特效框
				headEffectId = data[i]
			end
		end
	end
	if head_index or face_index or body_index or foot_index or mount_index or weapon_index or wing_index or skin_index or headEffectId or infoEffectId then
		is_role = true
	end
	return is_role, head_index, face_index, body_index, foot_index, mount_index, weapon_index, wing_index, skin_index, headEffectId, infoEffectId
end
--形象
function CellNewVipPrivilege:shoeRoleBody(con,head_index, face_index, body_index, wing_index, nSex)
	if con:getChildByTag(50) then
		con:removeChildByTag(50, true)
		self.m_sRoleConPlayer = nil
	end
	if self.m_sRoleConPlayer == nil then
		self.m_sRoleConPlayer = YDPlayerAnimation:createAnimation(nSex)
		self.m_sRoleConPlayer:getAnimNode():setTag(50)
		con:addChild(self.m_sRoleConPlayer:getAnimNode())
		if head_index then
			local head = GDatatab_item["id_"..head_index].animation_index_code
			self.m_sRoleConPlayer:setHead(head)
		end
		if face_index then
			local face = GDatatab_item["id_"..face_index].animation_index_code
			self.m_sRoleConPlayer:setFace(face)
		end
		if body_index then
			local body = GDatatab_item["id_"..body_index].animation_index_code
			self.m_sRoleConPlayer:setBody(body)
		end
		if wing_index then
			local wing = GDatatab_item["id_"..wing_index].animation_index_code
			self.m_sRoleConPlayer:setWing(wing)
		end
		self.m_sRoleConPlayer:play("wait0",true)
	end
end
--显示足迹
function CellNewVipPrivilege:showRoleFoot(con, foot_index)
	if foot_index then
		if self.m_sFootRoleSpine then
     		self.m_sFootRoleSpine:removeFromParentAndCleanup(true)
		end
		local foot_info = GDatatab_item["id_"..foot_index]
		local footId = nil
		if foot_info then
			footId = foot_info.property[1][1]
		end
	    self.m_sFootRoleSpine = FootEffectManager:addEffect1(con,footId,{x=45,y=50},true)
	end
end
--坐骑
function CellNewVipPrivilege:showRoleMount(con, mount_index)
	if mount_index then
		if self.m_sAniMount then
     		self.m_sAniMount:removeFromParentAndCleanup(true)
		end
		local head,body = CacheCenter:getHeadAndBodyColor()
		local tEquip = CacheCenter:getEquipmentList()
	    self.m_sAniMount = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, tEquip, "wait",nil,nil,nil,nil,nil,nil,nil,head,body,false)
	    local mount_id = WndApartmentAct:getMountId(mount_index)
	    local index_code = GDatatab_item["id_"..mount_id].animation_index_code
	    self.m_sAniMount:setMount(index_code)
	    local node = self.m_sAniMount:getAnimNode()
	    node:setScale(0.75)
	    node:setRelativePosition(GlobalMethod:ccp(0.3,0))
	    con:addChild(node)		
	end
end
--武器
function CellNewVipPrivilege:showRoleWeapon(con, weapon_index)
	if weapon_index then
		if self.m_sWeaponCellItem then
     		self.m_sWeaponCellItem:removeFromParentAndCleanup(true)
		end
		local cell,tcell = CellGoodItem:createElement()
		self.m_sWeaponCellItem = cell
	    if cell then
	        cell = WZUIContainer:luaTo(cell)
			local tabItem = GDatatab_item["id_"..weapon_index]
			local cellData = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=1,quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
	        tcell:setCellGoodItem(cellData,5)
	        con:addChild(cell)
	        cell:setRelativePosition(GlobalMethod:ccp(0.5,0.8))
	    end
	end
end
--皮肤
function CellNewVipPrivilege:showRoleSkin(con, skin_index)
	if skin_index then
		if self.m_sConSkinPlayer then
     		self.m_sConSkinPlayer:removeFromParentAndCleanup(true)
		end
		local tabItem = GDatatab_item["id_"..skin_index]
		if tabItem then
			local skin = tabItem.property[1][1]
			self.m_sConSkinPlayer = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, {}, "wait0", nil, nil ,nil, nil, nil ,nil, nil, nil, nil,true, skin)
			self.m_sConSkinPlayer:setScale(0.8)
			self.m_sConSkinPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			con:addChild(self.m_sConSkinPlayer:getAnimNode())
		end
	end
end

function CellNewVipPrivilege:onBtnClickRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.RECHARGE_DESC)
end

--显示足迹
function CellNewVipPrivilege:showHeadOrInfoEffect(con, headEffectId, infoEffectId)
	if headEffectId and tonumber(headEffectId) > 0 then
		local basicInfo = GDatatab_item["id_" .. headEffectId]
		if basicInfo and basicInfo.value > 0 then
			local effectFile = "checkother/ui_playerhead_effect" .. basicInfo.value
			local data = {}
			data.path = effectFile 
			data.play = "wait_1"
			data.loop = true
			local existSpine = CheckEffectFile(effectFile)
			if existSpine then 
				if con:getChildByTag(77) then
					con:removeChildByTag(77, true)
				end
				local spineHeadEffect = createEffectSpine(con, data)
				spineHeadEffect:setTag(77)
			else
				local sIndex = string.format("%04d", basicInfo.value)
	            local downloadInfo = GetDownloadInfo(sIndex, "playerhead_effect")
	            if downloadInfo == nil then return end 

	            DownloadManager:addDownloadTask(7000 + tonumber(sIndex),downloadInfo.url,downloadInfo.md5,sIndex,"DownloadResourceCallback", _G)
			end
		end
	end

	if infoEffectId and tonumber(infoEffectId) > 0 then
		local basicInfo = GDatatab_item["id_" .. infoEffectId]
		if basicInfo and basicInfo.value > 0 then
			local effectFile = "checkother/ui_checkother_info" .. basicInfo.value
			local data = {}
			data.path = effectFile 
			data.play = "wait1"
			data.loop = true
			local existSpine = CheckEffectFile(effectFile)
			if existSpine then 
				if con:getChildByTag(88) then
					con:removeChildByTag(88, true)
				end
				local spineInfoEffect = createEffectSpine(con, data)
				spineInfoEffect:setScale(0.6)
				spineInfoEffect:setTag(88)
			end
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewVipPrivilege:_onGetPrivilegeInfo()
	self:setChangeAdvancedVipReward()
end
--领取返回
function CellNewVipPrivilege:_onGetPrivilegeResult(result, level, rewardItemIds, rewardItemNums)
	if result == 1 then
		WndRewardShow:showById(rewardItemIds, rewardItemNums)
		if WndVip.m_tDataList and WndVip.m_tDataList[level] then
			for i=1,#WndVip.m_tDataList do
				if WndVip.m_tDataList[level].vipLevel == level then
					WndVip.m_tDataList[level].status = 1
					break
				end
			end
			local id,num = {},{}
			if WndVip.m_tDataList[level] and WndVip.m_tDataList[level].gift then
				id,num = SplitItemString(WndVip.m_tDataList[level].gift)
			end
			self:showAdvancedReward(id,num,level)
		end
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
	elseif result == 3 then
		MsgBoxManager:showTipBox(LocalStrings.NEWVIP_TEXT26)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellNewVipPrivilege:_adaptLanguage_vn()
	local txtNextVip = GetElement(self.m_root,"txtNextVip",WZUIFreeTextBox)
	txtNextVip:setMaxWidth(300)
	txtNextVip:setRelativePosition(GlobalMethod:ccp(0.35,0.98))
end
-------------------------------------语言适配End----------------------------------------