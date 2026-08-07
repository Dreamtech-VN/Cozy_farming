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
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tData then return end
	local masterInfo = CacheCenter:getMasterInfo()
	--收徒
	if self.m_tData.state == 2 then
		local pupilNum = masterInfo.pupil

		--收徒人数已经达到上限
		if data_pupil and pupilNum == data_pupil.max_pupil then
			MsgBoxManager:showTipBox(string.format(LocalStrings.MASTERINFO23,pupilNum)) 
			return
		end
		--已经发送过申请
		if WndMasterTip:valInTable(self.m_tData.id, WndMasterMember.m_tSendMsg) == true then
			MsgBoxManager:showTipBox(LocalStrings.MASTERINFO45) 
			return
		end
		WndMasterTip:showByType(self.m_tData,2)
	elseif self.m_tData.state == 1 then --拜师
		if masterInfo.hasMaster == true then
			MsgBoxManager:showTipBox(LocalStrings.MASTERINFO26) 
			return
		end
		--已经发送过申请
		if WndMasterTip:valInTable(self.m_tData.id, WndMasterMember.m_tSendMsg) == true then
			MsgBoxManager:showTipBox(LocalStrings.MASTERINFO50) 
			return
		end
		WndMasterTip:showByType(self.m_tData,1)
	end
end

--@brief	解除
function CellMasterSeat:onRemove(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local masterInfo = CacheCenter:getMasterInfo()
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
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nType == 4 or self.m_nType == 3 then
		WndCheckOther:show(self.m_tData.id)
		return
 	end
	self.m_bChecked = self.m_bChecked or false
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
	--冷却时间
	if (SystemTime:getServerTime() - masterInfo.lastXjTime) <= tonumber(CacheCenter:getGameParam().xiaojingCoolTime) then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO76)
		return
	end
	--发送私聊
	WndChat:sendChat(CHANNEL_WHISPER,string.format(LocalStrings.MASTERINFO79,tonumber(CacheCenter:getGameParam().xiaojingShide)),self.m_tData.id,
		self.m_tData.name,self.m_tData.sex,self.m_tData.level,self.m_tData.vipLevel,self.m_tData.headId,self.m_tData.faceId,self.m_tData.headColor, self.m_tData.headEffectId)
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
--	WZLog("师徒模型",Serialize(tData))
	local conPlayer, isMonster = nil,nil
	if self.m_tPlayerAni == nil then
		if self.m_nType == 4 then
			conPlayer, _, _, isMonster = CreatePlayerFigure(nSex, nil, "wait0", nil, nil, nil, nil, nil, nil, nil, tData.headColor, tData.bodyColor)
		else
			conPlayer, _, _, isMonster = CreatePlayerFigure(nSex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, tData.headColor, tData.bodyColor)
		end
		conPlayerAni:addChild(conPlayer:getAnimNode())
		conPlayer:getAnimNode():setScale(0.7)
		conPlayer:getAnimNode():setTouchEnable(false)
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
   	WndItemInfo:showInfo(element,WndFriends.m_root,1,self.m_tWeapon,false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置格子数据显示
--@param	nType:1师徒大厅，2我的徒弟 3同门师兄弟 4师徒奖励界面自己 5师门自己
--@param	position:位置
--is_teach 是否可以授业
function CellMasterSeat:setMasterSeat(tData, nType, position, is_teach)
	if tData == nil then return end
	
	is_teach = is_teach or nil
	local shiFuLevel = CacheCenter:getGameParam().shiFuLevel
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
    if nType == 4 or nType == 3 then
    	txtTitle:setVisible(false)
    else
    	txtTitle:setVisible(true)
    end
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
	if nType ~= 4 then
	    CreateDesiSpine(conInfo, txtTitle, sTitleContent, tempPoint, bTitleStroke)
	end

    GetElement(self.m_root,"playerLevel",WZUILabelTTF):setText(tData.level)
    local playerName = GetElement(self.m_root,"playerName",WZUILabelTTF)
    playerName:setText(tData.name)
    if nType == 4 then
    	playerName:setEnableStroke(false)
    	playerName:setColor(GlobalMethod:ccc3(255,255,255))
    end
    GetElement(self.m_root,"playerFight",WZUILabelAtlasFont):setText(tData.fighting)
    --跨服标记
    if tData.serverId and tData.serverId ~= CacheCenter:getPlayerInfo().serverId then 
    	playerName:setRelativePosition(GlobalMethod:ccp(0.40,0.312))
    	GetElement(self.m_root, "imgKuafu_CellMasterSeat", WZUIImage):setVisible(true)
    end

	--人物形象
	self:_setPlayer(tData,position)

	--拜师/收徒按钮
	GetElement(self.m_root,"btnAdd",WZUIButton):setVisible(nType == 1)
	--解除按钮
    local conRemove = GetElement(self.m_root,"conRemove",WZUIContainer)
    conRemove:setVisible(nType == 2 or nType == 5)
    --显示战斗力
    GetElement(self.m_root,"conFight",WZUIContainer):setVisible(nType == 1 or nType == 5)
    
    --在线状态
    local onlineState = GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF)
    if nType == 2 or nType == 5 then
    	--师徒授业
    	if nType == 2 then
	    	if not is_teach then
	    		self:setTeachStatus(true)
	    	else
	    		self:setTeachStatus(false)
	    	end
	    	--宝箱的红点

	    end
    	if tData.isOnline == true then
    		onlineState:setText(LocalStrings.REWARD_BTN_ONLINE)
		else
			local offline = self:getOfflineTime(tData.loginTime)
    		onlineState:setText(offline)
		end
    	onlineState:setVisible(true)
    end
    --由于人物缩小，所以顶部的消息会往下移动
    local conTopInfo = GetElement(conInfo,"conTopInfo",WZUIContainer)
    if nType ~= 4 then
	    conTopInfo:setRelativePosition(ccp(0.5,0.85))
	    if nType == 2 then
	    	onlineState:setAnchorPoint(ccp(0,0.5))
	    	onlineState:setRelativePosition(ccp(0.32,0.8))
	    end
	end
    --类型判断
	if nType == 1 then
		local txtIsMaster = GetElement(self.m_root,"txtIsMaster",WZUILabelTTF)
		if tData.state == 1 then
			txtIsMaster:setText(LocalStrings.MASTERINFO18)
		elseif tData.state == 2 then
			txtIsMaster:setText(LocalStrings.MASTERINFO19)
		end

		if position ~= nil then
			self.m_root:setScale(0.88)
			local positionY = {0.5,0.65,0.8,0.65,0.5}
			GetElement(self.m_root,"conAll",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,positionY[position]))
		end
	elseif nType == 2 then
		--显示宝箱
		local btnDiscipleBox = GetElement(conTopInfo,"btnDiscipleBox",WZUIButton)
		if tData.bagType ~= 0 then
			btnDiscipleBox:setVisible(true)
			local str_box = {"ui/task/task_activity_close3.png","ui/task/task_activity_close4.png","ui/task/task_activity_close5.png"}
			GetElement(btnDiscipleBox,"imgDiscipleBox",WZUIImage):setFile(str_box[tData.bagType])
		end
		self:setDisCipleRedPoint(tData.bagStatus == 0)
		conRemove:setRelativePosition(ccp(0.5,0.47))
	elseif nType == 3 then
		--不显示武器
   		GetElement(self.m_root,"btnWeapon_CellMasterSeat",WZUIButton):setVisible(false)
	elseif nType == 4 then
    	GetElement(self.m_root,"playerFight",WZUILabelAtlasFont):setVisible(false)
		--显示动画
		GetElement(self.m_root,"armature_CellMasterSeat",WZUISpine):setVisible(true)
		GetElement(self.m_root,"armature_CellMasterSeat",WZUISpine):setRelativePosition(GlobalMethod:ccp(0.475,1.1))
		GetElement(self.m_root,"armature1_CellMasterSeat",WZArmature):setVisible(true)
	elseif nType == 5 then
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

	local btnWeapon = GetElement(self.m_root,"btnWeapon_CellMasterSeat",WZUIButton)
	if tWeapon ~= nil then
		self.m_tWeapon = tWeapon
   		GetElement(self.m_root,"imgWeapon1",WZUIImage):setFile(tWeapon.basicInfo.icon)
   		GetElement(self.m_root,"imgWeapon2",WZUIImage):setFile(tWeapon.basicInfo.icon)
   		btnWeapon:setVisible(true)
	else
   		btnWeapon:setVisible(false)
	end
	if nType == 2 or nType == 3 then
   		btnWeapon:setVisible(false)
	end
end
--点击宝箱
function CellMasterSeat:onBtnDiscipleBox()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tData then return end
	if self.m_tData.bagStatus == 0 then
		ProtocolProcessorWndMaster:send_MENTORING_ReceiveBag(self.m_tData.id)
	else
		WndMasterCurBoxActivity:showInterface(self.m_tData.id)
	end
end
function CellMasterSeat:setBoxState(id, state)
	self.m_tData.id = id
	self.m_tData.bagStatus = state
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
--徒弟宝箱红点
function CellMasterSeat:setDisCipleRedPoint(visible)
	if not self.m_root then return end
	GetElement(self.m_root,"imgDiscipleBoxRedPoint",WZUIImage):setVisible(visible)
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
function CellMasterSeat:setTeachStatus(status)
	if not self.m_root then return end
	local btnTeach = GetElement(self.m_root,"btnTeach",WZUIButton)
	btnTeach:setVisible(true)
	btnTeach:setTouchEnable(status)
end
--师徒授业
function CellMasterSeat:onBtnClickTeach()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tData then return end
	ProtocolProcessorWndMaster:send_MENTORING_ShouYe(self.m_tData.id)
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