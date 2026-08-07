--CellMasterSeat.lua
--@brief	CellMasterSeat的UI模块
--@date		2015/05/27
--@author	zsq
--@note		师徒系统人物格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMasterSeat:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
    self.m_root:enableSchedule("changeRoleAni",math.random(3,5))
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMasterSeat:onExit(element)
	self:_unInit()
end

--@brief	拜师/收徒
function CellMasterSeat:onAdd(element)
	WZLog("CellMasterSeat:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local playerInfo = CacheCenter:getPlayerInfo()
	if CacheCenter:getPlayerInfo() == nil then return end
	if CacheCenter:getMasterInfo() == nil then return end
	if playerInfo.level < MASTERLEVEL then
		local masterInfo = CacheCenter:getMasterInfo()
		if masterInfo.hasMaster == true then
			MsgBoxManager:showTipBox(LocalStrings.MASTERINFO26) 
			return
		end
		--已经发送过申请
		if WndMasterTip:valInTable(self.m_tData.id, WndMasterMember.m_tSendMsg) == true then
			MsgBoxManager:showTipBox(LocalStrings.MASTERINFO45) 
			return
		end
		--我的等级小于等于35,拜师
		WndMasterTip:showByType(self.m_tData,1)
	else
		--收徒人数
		local masterInfo = CacheCenter:getMasterInfo()
		local pupilNum = masterInfo.pupil
		local moralityLevel = masterInfo.moralityLevel
		if moralityLevel == 0 then moralityLevel = 1 end
		local max_pupil = GDatatab_morality["id_"..moralityLevel].max_pupil
		--收徒人数已经达到上限
		if pupilNum == max_pupil then
			MsgBoxManager:showTipBox(string.format(LocalStrings.MASTERINFO23,pupilNum)) 
			return
		end
		--已经发送过申请
		if WndMasterTip:valInTable(self.m_tData.id, WndMasterMember.m_tSendMsg) == true then
			MsgBoxManager:showTipBox(LocalStrings.MASTERINFO45) 
			return
		end
		--我的等级大于35,收徒
		WndMasterTip:showByType(self.m_tData,2)
	end
end

--@brief	解除
function CellMasterSeat:onRemove(element)
	WZLog("CellMasterSeat:onRemove")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_bOffLineLong then
		WndMasterTip:showByType(self.m_tData,5)
	else
		WndMasterTip:showByType(self.m_tData,3)
	end
end

--@brief	设置人物选中状态
function CellMasterSeat:setChecked(bool)
	if bool == nil then return end
	GetElement(self.m_root,"conCheck_CellMasterSeat",WZUIContainer):setVisible(bool)
	GetElement(self.m_root,"armature_CellMasterSeat",WZUISpine):setVisible(bool)
	self.m_bChecked = bool
	if self.m_tParentWnd ~= nil then
		self.m_tParentWnd.m_bChecked = bool
	end
   	GetElement(self.m_root,"btnWeapon_CellMasterSeat",WZUIButton):setTouchEnable(not bool)
end

--@brief	切换人物选中状态
function CellMasterSeat:onCheck(element)
	WZLog("CellMasterSeat:onCheck",self.m_nType)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nType == 4 or self.m_nType == 3 then
		WndCheckOther:show(self.m_tData.id)
		return
 	end
	if self.m_bChecked == nil then self.m_bChecked = false end
	--窗口中没有选中的角色
	if self.m_bChecked == false and self.m_tParentWnd.m_bChecked == false then
		self:setChecked(true)
	--窗口中有选中的角色,是自己
	elseif self.m_bChecked == true and self.m_tParentWnd.m_bChecked == true then
		self:setChecked(false)
	--窗口中有选中的角色,不是自己
	elseif self.m_bChecked == false and self.m_tParentWnd.m_bChecked == true then
		self.m_tParentWnd:clearChecked()
		self:setChecked(true)
	end
end

--@brief	查看人物信息
function CellMasterSeat:onCheckInfo(element)
	WZLog("CellMasterSeat:onCheckInfo",self.m_tData.id)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tData.id)
end

--@brief	孝敬
function CellMasterSeat:onHonor(element)
	WZLog("CellMasterSeat:onHonor")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--在线才可孝敬
	WZLog("师父是否在线",self.m_tData.isOnline)
	if self.m_tData.isOnline == false then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO69)
		return
	end
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil then return end
	--次数限制
	WZLog("次数限制",masterInfo.honorTime,CacheCenter:getGameParam().xiaojingNum)
	if tonumber(masterInfo.honorTime) >= tonumber(CacheCenter:getGameParam().xiaojingNum) then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO70)
		return
	end
	--冷却时间
	WZLog("冷却时间",SystemTime:getServerTime(),masterInfo.lastTime,(SystemTime:getServerTime() - masterInfo.lastTime),CacheCenter:getGameParam().xiaojingCoolTime)
	if (SystemTime:getServerTime() - masterInfo.lastTime) <= tonumber(CacheCenter:getGameParam().xiaojingCoolTime) then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO76)
		return
	end
	ProtocolProcessorWndMaster:send_MENTORING_XiaoJing()
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil then return end
	masterInfo.lastTime = SystemTime:getServerTime()
	--发送私聊
	WndChat:sendChat(CHANNEL_WHISPER,string.format(LocalStrings.MASTERINFO79,tonumber(CacheCenter:getGameParam().xiaojingShide)),self.m_tData.id,self.m_tData.name,self.m_tData.sex,self.m_tData.level,self.m_tData.vipLevel,self.m_tData.headId,self.m_tData.faceId,self.m_tData.headColor)
	--WndChat:sendChat(channel,chatMsg,receivePlayerId,receivePlayerName,receivePlayerSex,receivePlayerLevel,receivePlayerVipLevel,receivePlayerHead,receivePlayerFace,receivePlayerHeadColor)
end

--@brief   玩家人物
function CellMasterSeat:_setPlayer(tData,position)
	if self.m_root == nil then return end
	local nSex = tData.sex or 0
	local tEquip = {}
	table.insert(tEquip,tData.headId)
	table.insert(tEquip,tData.faceId)
	table.insert(tEquip,tData.bodyId)
	table.insert(tEquip,tData.wingId)

	local conPlayerAni = self.m_root:getChildElement("conRole")

	local conPlayer
	if self.m_tPlayerAni == nil then
		if self.m_nType == 4 then
			conPlayer, _1, _2, isMonster = CreatePlayerFigure(nSex, nil, "wait0", nil, nil, nil, nil, nil, nil, nil, tData.headColor, tData.bodyColor)
		else
			conPlayer, _1, _2, isMonster = CreatePlayerFigure(nSex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, tData.headColor, tData.bodyColor)
		end
		conPlayerAni:addChild(conPlayer:getAnimNode())
		conPlayer:getAnimNode():setScale(0.85)
		self.m_tPlayerAni = conPlayer
		if isMonster == true then
			conPlayer:getAnimNode():setRelativePosition(ccp(0.5,0.23))
		end
	else
		conPlayer = self.m_tPlayerAni
	end

	if position ~= nil and position > 3 then
		conPlayer:getAnimNode():setFlipX(true)
	end
end

--@brief	点击武器
function CellMasterSeat:onWeapon(element)
	WZLog("CellMasterSeat:onWeapon")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   	WndItemInfo:showInfo(GetElement(self.m_root,"btnWeapon_CellMasterSeat",WZUIButton),
		GetElement(WndMaster.m_root,"conTips",WZUIContainer),1,self.m_tWeapon,false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置格子数据显示
--@param	nType:1师徒大厅，2我的徒弟3同门师兄弟,4师徒奖励界面自己5师门自己
--@param	position:位置
function CellMasterSeat:setMasterSeat(tData,nType,position)
	--WZLog("CellMasterSeat:setMasterSeat",Serialize(tData))
	if tData == nil then return end
	self.m_tData = tData
	nType = nType or 1
	self.m_nType = nType
	--人物信息
    local conInfo = GetElement(self.m_root,"conInfo",WZUIContainer)
    conInfo:setVisible(true)
    local bTitleStroke = false 
    local tempPoint = GlobalMethod:ccp(0.5,1.19)
    local sTitleContent = tData.title

    local txtTitle = GetElement(self.m_root,"playerTitle",WZUILabelTTF)
    
    if tData.title ~= nil and tData.title ~= "" then
        local sTitleName = SplitStringWithSeparator(tData.title,"&")
        local sNewTitle, nLetterNum = string.gsub(tData.title, "&", ",")
        local titleLen = string.len(sTitleName[1])
        if sTitleName[2] ~= nil and sTitleName[2] ~= "" then
            if tonumber(sTitleName[2]) == nil or nLetterNum > 2 then
                sTitleContent = "<"..tData.title..">"
            else
                local bExist = WZFileUtil:isFileExist(string.format(g_sTitleSpineName, sTitleName[2]) .. ".json")
                if bExist then
                    bTitleStroke = true 
                else
                    sTitleContent = "<"..tData.title..">"
                end
            end
        else
            sTitleContent = "<"..tData.title..">"
        end
	else
        sTitleContent = ""
	end
    CreateDesiSpine(conInfo, txtTitle, sTitleContent, tempPoint, bTitleStroke)

    GetElement(self.m_root,"playerLevel",WZUILabelTTF):setText(tData.level)
    GetElement(self.m_root,"playerName",WZUILabelTTF):setText(tData.name)
    GetElement(self.m_root,"playerFight",WZUILabelAtlasFont):setText(tData.fighting)

	--人物形象
	self:_setPlayer(tData,position)

	if nType == 1 then

		--拜师/收徒按钮
    	GetElement(self.m_root,"btnAdd",WZUIButton):setVisible(true)
		--解除按钮
    	GetElement(self.m_root,"conRemove",WZUIContainer):setVisible(false)
		local playerInfo = CacheCenter:getPlayerInfo()
		if playerInfo.level < MASTERLEVEL then
			--人物等级也小于35级，不显示按钮
			if tData.level < MASTERLEVEL then
				GetElement(self.m_root,"btnAdd",WZUIButton):setVisible(false)
			end
		else
			--我的等级大于等于35,收徒
    		GetElement(self.m_root,"ttfBtn1",WZUILabelTTF):setTextKey("")
    		GetElement(self.m_root,"ttfBtn2",WZUILabelTTF):setTextKey("")
    		GetElement(self.m_root,"ttfBtn1",WZUILabelTTF):setText(LocalStrings.MASTERINFO19)
    		GetElement(self.m_root,"ttfBtn2",WZUILabelTTF):setText(LocalStrings.MASTERINFO19)
			--人物等级也大于35级，不显示按钮
			if tData.level >= MASTERLEVEL or tData.level < 10 then
				GetElement(self.m_root,"btnAdd",WZUIButton):setVisible(false)
			end
		end
   		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setVisible(false)
		if position ~= nil then
			self.m_root:setScale(0.88)
			local positionY = {0.33,0.55,0.63,0.55,0.33}
			GetElement(self.m_root,"conAll",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,positionY[position]))
		end
	elseif nType == 2 then
		--拜师按钮
    	GetElement(self.m_root,"btnAdd",WZUIButton):setVisible(false)
		--解除按钮
    	GetElement(self.m_root,"conRemove",WZUIContainer):setVisible(true)
		if tData.isOnline == true then
    		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setText(LocalStrings.REWARD_BTN_ONLINE)
    		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setColor(GlobalMethod:ccc3(64,128,1))
		else
			local offline = self:getOfflineTime(tData.loginTime)
    		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setText(offline)
    		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setColor(GlobalMethod:ccc3(158,139,121))
		end
   		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setVisible(true)
		if position ~= nil then
			self.m_root:setScale(0.88)
			local positionY = {0.33,0.55,0.63,0.55,0.33}
			GetElement(self.m_root,"conAll",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,positionY[position]))
		end
	elseif nType == 3 then
		--拜师按钮
    	GetElement(self.m_root,"btnAdd",WZUIButton):setVisible(false)
		--解除按钮
    	GetElement(self.m_root,"conRemove",WZUIContainer):setVisible(false)	
    	GetElement(self.m_root,"playerTitle",WZUILabelTTF):setVisible(false)
   		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setVisible(false)
		--不显示战斗力
   		GetElement(self.m_root,"conFight",WZUIContainer):setVisible(false)
		--不显示武器
   		GetElement(self.m_root,"btnWeapon_CellMasterSeat",WZUIButton):setVisible(false)
	elseif nType == 4 then
		--拜师按钮
    	GetElement(self.m_root,"btnAdd",WZUIButton):setVisible(false)
		--解除按钮
    	GetElement(self.m_root,"conRemove",WZUIContainer):setVisible(false)	
    	GetElement(self.m_root,"playerFight",WZUILabelAtlasFont):setVisible(false)
		--调整等级，名字位置
   		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setVisible(false)
		--不显示战斗力
   		GetElement(self.m_root,"conFight",WZUIContainer):setVisible(false)
		--显示动画
		GetElement(self.m_root,"armature_CellMasterSeat",WZUISpine):setVisible(true)
		GetElement(self.m_root,"armature_CellMasterSeat",WZUISpine):setRelativePosition(GlobalMethod:ccp(0.475,1.1))
		GetElement(self.m_root,"armature1_CellMasterSeat",WZArmature):setVisible(true)
	elseif nType == 5 then
		--拜师按钮
    	GetElement(self.m_root,"btnAdd",WZUIButton):setVisible(false)
		--解除按钮
    	GetElement(self.m_root,"conRemove",WZUIContainer):setVisible(true)
		--孝敬按钮
    	GetElement(self.m_root,"btnHonor",WZUIButton):setVisible(true)
		GetElement(self.m_root,"ttfBtn41",WZUILabelTTF):setText(LocalStrings.MASTERINFO67)
		GetElement(self.m_root,"ttfBtn42",WZUILabelTTF):setText(LocalStrings.MASTERINFO67)
		GetElement(self.m_root,"ttfBtn43",WZUILabelTTF):setText(LocalStrings.MASTERINFO67)

		if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
			for i=1,3 do
				local txtBtn = GetElement(self.m_root,"ttfBtn4"..i,WZUILabelTTF)
				txtBtn:setDimensions(GlobalMethod:CCSize(160,0))
				txtBtn:setScale(0.6)
			end
		end
		--倒计时
		local masterInfo = CacheCenter:getMasterInfo()
		--if masterInfo ~= nil and masterInfo.lastTime ~= nil and CacheCenter:getGameParam().xiaojingCoolTime ~= nil and
		--		(SystemTime:getServerTime() - masterInfo.lastTime) <= tonumber(CacheCenter:getGameParam().xiaojingCoolTime) then
		--MsgBoxManager:showTipBox("开始孝敬计时器")
    		GetElement(self.m_root,"btnHonor",WZUIButton):enableSchedule("countDown",1)
		--end
		--孝敬次数用完
		if masterInfo ~= nil and masterInfo.honorTime ~= nil and CacheCenter:getGameParam().xiaojingNum ~= nil and
				masterInfo.honorTime >= tonumber(CacheCenter:getGameParam().xiaojingNum) then
			--GetElement(self.m_root,"btnHonor",WZUIButton):disableSchedule()

			GetElement(self.m_root,"ttfBtn41",WZUILabelTTF):setText(LocalStrings.ATH_CNT_NOT_ENOUGH)
			GetElement(self.m_root,"ttfBtn42",WZUILabelTTF):setText(LocalStrings.ATH_CNT_NOT_ENOUGH)
			GetElement(self.m_root,"ttfBtn43",WZUILabelTTF):setText(LocalStrings.ATH_CNT_NOT_ENOUGH)
			if ProjConfig.LANGUAGE == "vn" then
				GetElement(self.m_root,"ttfBtn41",WZUILabelTTF):setScale(0.7)
				GetElement(self.m_root,"ttfBtn42",WZUILabelTTF):setScale(0.7)
				GetElement(self.m_root,"ttfBtn43",WZUILabelTTF):setScale(0.7)
			elseif ProjConfig.LANGUAGE == "tr" then
				for i=1,3 do
					local ttfBtn = GetElement(self.m_root,"ttfBtn4"..i,WZUILabelTTF)
					ttfBtn:setDimensions(GlobalMethod:CCSize(180,0))
					ttfBtn:setScale(0.6)
				end
			elseif ProjConfig.LANGUAGE == "en" then
				for i=1,3 do
					local ttfBtn = GetElement(self.m_root,"ttfBtn4"..i,WZUILabelTTF)
					ttfBtn:setDimensions(GlobalMethod:CCSize(180,0))
					ttfBtn:setScale(0.6)
				end
			elseif ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
				for i=1,3 do
					local txtBtn = GetElement(self.m_root,"ttfBtn4"..i,WZUILabelTTF)
					txtBtn:setDimensions(GlobalMethod:CCSize(160,0))
					txtBtn:setScale(0.6)
				end
			end
		end

		if tData.isOnline == true then
    		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setText(LocalStrings.REWARD_BTN_ONLINE)
    		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setColor(GlobalMethod:ccc3(64,128,1))
		else
			local offline = self:getOfflineTime(tData.loginTime)
    		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setText(offline)
    		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setColor(GlobalMethod:ccc3(158,139,121))
		end
   		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"armature_CellMasterSeat",WZUISpine):setRelativePosition(GlobalMethod:ccp(0.475,1.1))
		GetElement(self.m_root,"armature1_CellMasterSeat",WZArmature):setVisible(true)
	end

	--显示武器
	local tWeapon
	if nType == 1 or nType == 2 or nType == 3 or nType == 5 then
		if tData.weaponId ~= nil then
			tWeapon = {id=tData.weaponId,basicInfo=GDatatab_item["id_"..tData.weaponId],extraInfo=tData.extraInfo}	
		end
	elseif nType == 4 then
		tWeapon = CacheCenter:getWeapon()
	end

	if tWeapon ~= nil then
		self.m_tWeapon = tWeapon
   		GetElement(self.m_root,"imgWeapon1",WZUIImage):setFile(tWeapon.basicInfo.icon)
   		GetElement(self.m_root,"imgWeapon2",WZUIImage):setFile(tWeapon.basicInfo.icon)
   		GetElement(self.m_root,"btnWeapon_CellMasterSeat",WZUIButton):setVisible(true)
	else
   		GetElement(self.m_root,"btnWeapon_CellMasterSeat",WZUIButton):setVisible(false)
	end
	if nType == 3 then
   		GetElement(self.m_root,"btnWeapon_CellMasterSeat",WZUIButton):setVisible(false)
	end
end

--@brief	孝敬倒计时
function CellMasterSeat:countDown()
	local masterInfo = CacheCenter:getMasterInfo()
	local countDown = CacheCenter:getGameParam().xiaojingCoolTime - (SystemTime:getServerTime() - masterInfo.lastTime)
	WZLog("孝敬倒计时",countDown)
	if countDown <= 0 then
		GetElement(self.m_root,"ttfBtn41",WZUILabelTTF):setText(LocalStrings.MASTERINFO67)
		GetElement(self.m_root,"ttfBtn42",WZUILabelTTF):setText(LocalStrings.MASTERINFO67)
		GetElement(self.m_root,"ttfBtn43",WZUILabelTTF):setText(LocalStrings.MASTERINFO67)
		if ProjConfig.LANGUAGE == "es" then
			for i=1,3 do
				local txtBtn = GetElement(self.m_root,"ttfBtn4"..i,WZUILabelTTF)
				txtBtn:setDimensions(GlobalMethod:CCSize(100,0))
				txtBtn:setScale(0.6)
			end
		end
	else
		local min = math.floor(countDown / 60)
		if min < 10 then min = "0"..min end
		local sec = countDown % 60
		if sec < 10 then sec = "0"..sec end
		WZLog(min,sec)
		GetElement(self.m_root,"ttfBtn41",WZUILabelTTF):setText(LocalStrings.MASTERINFO71..min..":"..sec)
		GetElement(self.m_root,"ttfBtn42",WZUILabelTTF):setText(LocalStrings.MASTERINFO71..min..":"..sec)
		GetElement(self.m_root,"ttfBtn43",WZUILabelTTF):setText(LocalStrings.MASTERINFO71..min..":"..sec)
		if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
			for i=1,3 do
				local ttfBtn = GetElement(self.m_root,"ttfBtn4"..i,WZUILabelTTF)
				ttfBtn:setDimensions(GlobalMethod:CCSize(180,0))
				ttfBtn:setScale(0.6)
			end
		end
	end

	local timesEnouth = false
	if masterInfo ~= nil and masterInfo.honorTime ~= nil and CacheCenter:getGameParam().xiaojingNum ~= nil and
			masterInfo.honorTime < tonumber(CacheCenter:getGameParam().xiaojingNum) then
		timesEnouth = true
	else
		GetElement(self.m_root,"ttfBtn41",WZUILabelTTF):setText(LocalStrings.ATH_CNT_NOT_ENOUGH)
		GetElement(self.m_root,"ttfBtn42",WZUILabelTTF):setText(LocalStrings.ATH_CNT_NOT_ENOUGH)
		GetElement(self.m_root,"ttfBtn43",WZUILabelTTF):setText(LocalStrings.ATH_CNT_NOT_ENOUGH)
		if ProjConfig.LANGUAGE == "vn" then
			GetElement(self.m_root,"ttfBtn41",WZUILabelTTF):setScale(0.7)
			GetElement(self.m_root,"ttfBtn42",WZUILabelTTF):setScale(0.7)
			GetElement(self.m_root,"ttfBtn43",WZUILabelTTF):setScale(0.7)
		elseif ProjConfig.LANGUAGE == "tr" then
			for i=1,3 do
				local ttfBtn = GetElement(self.m_root,"ttfBtn4"..i,WZUILabelTTF)
				ttfBtn:setDimensions(GlobalMethod:CCSize(180,0))
				ttfBtn:setScale(0.6)
			end
		elseif ProjConfig.LANGUAGE == "en" then
			for i=1,3 do
				local ttfBtn = GetElement(self.m_root,"ttfBtn4"..i,WZUILabelTTF)
				ttfBtn:setDimensions(GlobalMethod:CCSize(180,0))
				ttfBtn:setScale(0.6)
			end
		elseif ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
			for i=1,3 do
				local txtBtn = GetElement(self.m_root,"ttfBtn4"..i,WZUILabelTTF)
				txtBtn:setDimensions(GlobalMethod:CCSize(160,0))
				txtBtn:setScale(0.6)
			end
		end
	end
	--孝敬红点
	if CacheCenter:getPlayerInfo().level < MASTERLEVEL and self.m_tData.isOnline == true and countDown <= 0 and timesEnouth == true then
		GetElement(WndMaster.m_root,"hasHonor_WndMaster",WZUIImage):setVisible(true)
		GetElement(self.m_root,"hasHonor_Cell",WZUIImage):setVisible(true)
	else
		GetElement(WndMaster.m_root,"hasHonor_WndMaster",WZUIImage):setVisible(false)
		GetElement(self.m_root,"hasHonor_Cell",WZUIImage):setVisible(false)
	end
end

--@brief	显示默认背景
function CellMasterSeat:showDefault()
    GetElement(self.m_root,"conRole",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"conInfo",WZUIContainer):setVisible(false)
end

--@brief	获得离线时间字符串
function CellMasterSeat:getOfflineTime(loginTime)
	--剩余时间
	local t = loginTime
	local desc = ""
	local s,m,h,d
	--总秒数
	local tt = (SystemTime:getServerTime() - t)
	WZLog("剩余秒数",tt)
	if tt <= 0 then
		desc = LocalStrings.REWARD_BTN_ONLINE
	else
		s = tt % 60--s
		tt = math.floor(tt/60)
		m = tt % 60--m
		tt = math.floor(tt/60)
		h = tt % 24--h
		tt = math.floor(tt/24)
		d = tt 
		local tip = LocalStrings.OFFLINESTATE--剩余时间:
		--大于一天只显示天数
		if d > 0 then
			if d > 30 then
				desc = string.format(tip.."%d"..LocalStrings.SPACE31, 1)
			else
				desc = string.format(tip.."%d"..LocalStrings.DAY, d)
			end
		else
			--大于一小时只显示小时数
			if h > 0 then 
				local ds = tip.."%d%s"
				desc = string.format(ds,h,LocalStrings.HOUR1)
			elseif m > 3 then
				local ds = tip.."%d%s"
				desc = string.format(ds, m, LocalStrings.MINUTE1)
			else 
				desc = LocalStrings.JUST_NOW .. tip
			end
		end
	end
	if d ~= nil and d >= 3 then self.m_bOffLineLong = true end
	return desc
end

--@brief    切换播放角色动画
function CellMasterSeat:changeRoleAni()
    if self.m_tPlayerAni == nil then return end
    self.m_tPlayerAni:play(g_tRoleAnitionName[math.random(2)],false)
    self.m_root:disableSchedule()
   	self.m_root:enableSchedule("updateRole")
end

--@brief	角色形象动画完成回调
function CellMasterSeat:updateRole(element,t)
    if not self.m_tPlayerAni:isPlaying() then
        local isEnd = self.m_tPlayerAni:isCurrentAnimationDone()
        if isEnd == true then
			self.m_tPlayerAni:play("wait0",true)
            element:disableSchedule()
    		self.m_root:enableSchedule("changeRoleAni",math.random(3,5))
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------------语言适配Begin-------------------------------------
function CellMasterSeat:_adaptLanguage_en(  )
	local txt1 = GetElement(self.m_root,"ttfBtn1",WZUILabelTTF)
	txt1:setDimensions(GlobalMethod:CCSize(100,0))
	txt1:setFontSize(20)

	local txt2 = GetElement(self.m_root,"ttfBtn2",WZUILabelTTF)
	txt2:setDimensions(GlobalMethod:CCSize(100,0))
	txt2:setFontSize(20)

	local txt3 = GetElement(self.m_root,"ttfBtn3",WZUILabelTTF)
	txt3:setDimensions(GlobalMethod:CCSize(100,0))
	txt3:setFontSize(20)
end

function CellMasterSeat:_adaptLanguage_pt(  )
	local txt1 = GetElement(self.m_root,"ttfBtn1",WZUILabelTTF)
	txt1:setDimensions(GlobalMethod:CCSize(100,0))
	txt1:setFontSize(20)

	local txt2 = GetElement(self.m_root,"ttfBtn2",WZUILabelTTF)
	txt2:setDimensions(GlobalMethod:CCSize(100,0))
	txt2:setFontSize(20)

	local txt3 = GetElement(self.m_root,"ttfBtn3",WZUILabelTTF)
	txt3:setDimensions(GlobalMethod:CCSize(100,0))
	txt3:setFontSize(20)
end

function CellMasterSeat:_adaptLanguage_es(  )
	local txt1 = GetElement(self.m_root,"ttfBtn1",WZUILabelTTF)
	txt1:setDimensions(GlobalMethod:CCSize(100,0))
	txt1:setFontSize(20)

	local txt2 = GetElement(self.m_root,"ttfBtn2",WZUILabelTTF)
	txt2:setDimensions(GlobalMethod:CCSize(100,0))
	txt2:setFontSize(20)

	local txt3 = GetElement(self.m_root,"ttfBtn3",WZUILabelTTF)
	txt3:setDimensions(GlobalMethod:CCSize(100,0))
	txt3:setFontSize(20)
end

function CellMasterSeat:_adaptLanguage_tr(  )
	local txt1 = GetElement(self.m_root,"ttfBtn1",WZUILabelTTF)
	txt1:setDimensions(GlobalMethod:CCSize(100,0))
	txt1:setFontSize(20)

	local txt2 = GetElement(self.m_root,"ttfBtn2",WZUILabelTTF)
	txt2:setDimensions(GlobalMethod:CCSize(100,0))
	txt2:setFontSize(20)

	local txt3 = GetElement(self.m_root,"ttfBtn3",WZUILabelTTF)
	txt3:setDimensions(GlobalMethod:CCSize(100,0))
	txt3:setFontSize(20)
end
--------------------------------------------语言适配End---------------------------------------