--WndLeagueTeamDetail.lua
--@brief	WndLeagueTeamDetail的UI模块
--@date		2016/06/12
--@author	zsq
--@note		战队详情
	local GAMENAME = {LocalStrings.LEAGUE_REPLAY_TEXT7,LocalStrings.LEAGUE_REPLAY_TEXT8..LocalStrings.LEAGUE19,LocalStrings.LEAGUE_REPLAY_TEXT8..LocalStrings.LEAGUE20,LocalStrings.LEAGUE_REPLAY_TEXT8..LocalStrings.LEAGUE21,LocalStrings.LEAGUE_REPLAY_TEXT9..LocalStrings.LEAGUE19,LocalStrings.LEAGUE_REPLAY_TEXT9..LocalStrings.LEAGUE20,LocalStrings.LEAGUE_REPLAY_TEXT9..LocalStrings.LEAGUE21,LocalStrings.LEAGUE_REPLAY_TEXT10..LocalStrings.LEAGUE19,LocalStrings.LEAGUE_REPLAY_TEXT10..LocalStrings.LEAGUE20,LocalStrings.LEAGUE_REPLAY_TEXT10..LocalStrings.LEAGUE21,LocalStrings.LEAGUE_REPLAY_TEXT11..LocalStrings.LEAGUE19,LocalStrings.LEAGUE_REPLAY_TEXT11..LocalStrings.LEAGUE20,LocalStrings.LEAGUE_REPLAY_TEXT11..LocalStrings.LEAGUE21,LocalStrings.LEAGUE_REPLAY_TEXT12..LocalStrings.LEAGUE19,LocalStrings.LEAGUE_REPLAY_TEXT12..LocalStrings.LEAGUE20,LocalStrings.LEAGUE_REPLAY_TEXT12..LocalStrings.LEAGUE21,"",""}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLeagueTeamDetail:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	AddButtomChatToRoot(self.m_root:getLuaObjectName(),self.m_root)

	self:checkVoice()
end

--@brief	加载完成
function WndLeagueTeamDetail:onEnterTransitionDidFinish(element)
	--分辨率适配
	local directorSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	WZLog("WndLeagueTeamDetail:onEnterTransitionDidFinish", directorSize.width/960)
	local width = directorSize.width
	local height = directorSize.height
	local tempWidth = width/(height/640)
	if width/height > 1.5 then
		GetElement(self.m_root,"conSpeake",WZUIContainer):setScaleX(tempWidth/960)
		GetElement(self.m_root,"btnSpeaker_WndLeagueTeamDetail",WZUIButton):setScaleX((960/tempWidth)*0.65)
		GetElement(self.m_root,"btnMic_WndLeagueTeamDetail",WZUIButton):setScaleX((960/tempWidth)*0.65)
	end
	ProtocolProcessorWndLeague:send_HERO_ReadyFight()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLeagueTeamDetail:onExit(element)
	self:quitVoice()
	self:_unInit()
end

--@brief	显示接口
function WndLeagueTeamDetail:show(parent)
	WZLog("WndLeagueTeamDetail:show")
	if self.m_root == nil then 
		local wnd = WndLeagueTeamDetail:createElement()
		parent:addChild(wnd)
	else
		self.m_root:setVisible(true)
		ProtocolProcessorWndLeague:send_HERO_ReadyFight()
	end
end

--@brief	开始匹配
function WndLeagueTeamDetail:onStart(element)
	WZLog("WndLeagueTeamDetail:onStart",self.m_nLeftTime,self.m_bGameStart)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--没有比赛资格
	WZLog("比赛资格",self.m_tData.canFight,type(self.m_nGameStage),self.m_nGameStage)
	if self.m_nGameStage == 2 or self.m_nGameStage == 3 or self.m_nGameStage == 4 then
		if tonumber(string.sub(self.m_tData.canFight,1,1)) == 0 then
			MsgBoxManager:showTipBox(LocalStrings.LEAGUE53)
			return
		end
	elseif self.m_nGameStage == 5 or self.m_nGameStage == 6 or self.m_nGameStage == 7 then
		if tonumber(string.sub(self.m_tData.canFight,2,2)) == 0 then
			MsgBoxManager:showTipBox(LocalStrings.LEAGUE53)
			return
		end
	elseif self.m_nGameStage == 8 or self.m_nGameStage == 9 or self.m_nGameStage == 10 then
		if tonumber(string.sub(self.m_tData.canFight,3,3)) == 0 then
			MsgBoxManager:showTipBox(LocalStrings.LEAGUE53)
			return
		end
	elseif self.m_nGameStage == 11 or self.m_nGameStage == 12 or self.m_nGameStage == 13 or self.m_nGameStage == 14 or self.m_nGameStage == 15 or self.m_nGameStage == 16 then
		if tonumber(string.sub(self.m_tData.canFight,4,4)) == 0 then
			MsgBoxManager:showTipBox(LocalStrings.LEAGUE53)
			return
		end
	end
	--判断比赛时间
	if self.m_bGameStart == false then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE54)
		return
	end
	--队伍人数不足
	if #self.m_tData.readyPlayerId < 3 then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE55)
		return
	end
	--队伍
	if self.m_tData == nil or self.m_tData.readyed == nil or #self.m_tData.readyed < 2 then
		MsgBoxManager:showTipBox(LocalStrings.ROOM_HAVE_NOT_READY)
	else
		ProtocolProcessorWndLeague:send_HERO_MakePairHero()
	end
end

--@brief	开始匹配倒计时
function WndLeagueTeamDetail:EnterRoomOk()
	if self.m_root == nil then return end
	self.m_nMatchingCountdown = 1
	GetElement(self.m_root,"conCountDown",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"txtCountDown",WZUILabelAtlasFont):setText(self.m_nMatchingCountdown)
	--self:updateDesc()
    GetElement(self.m_root,"conCountDown",WZUIContainer):enableSchedule("updateDesc0",0.01)
	if CacheCenter:getPlayerInfo().id == self.m_nCurCaptain then
		GetElement(self.m_root,"btnCancel",WZUIButton):setVisible(true)
	else
		GetElement(self.m_root,"btnCancel",WZUIButton):setVisible(false)
	end
end

function WndLeagueTeamDetail:updateDesc0( ... )
	-- body
	self:updateDesc()
	GetElement(self.m_root,"conCountDown",WZUIContainer):enableSchedule("updateDesc",10)
end

--@brief	取消匹配
function WndLeagueTeamDetail:cancelMatch()
	WZLog("WndLeagueTeamDetail:cancelMatch")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--ProtocolProcessorWndLeague:parse_HERO_EndMakePairHeroOk()
	ProtocolProcessorWndLeague:send_HERO_EndMakePairHero()
	self.m_nMatchingCountdown = nil
	GetElement(self.m_root,"conCountDown",WZUIContainer):setVisible(false)
end

--@brief	队员准备战斗
function WndLeagueTeamDetail:onReady(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self:idInTable(CacheCenter:getPlayerInfo().id,self.m_tData.readyed) then
		ProtocolProcessorWndLeague:send_HERO_CancelReady()
	else
		ProtocolProcessorWndLeague:send_HERO_Ready()
	end
end

--@brief	武器
function WndLeagueTeamDetail:_showWeapon(index,dataIndex)
	--显示武器
	local tWeapon
	WZLog("武器特效 spWeapon"..index)
    local spWeapon1 = GetElement(self.m_root,"spWeapon"..index,WZUISpine)
	spWeapon1:setVisible(false)
	local weaponId = self.m_tDataList[dataIndex].itemId
	if weaponId ~= nil then
		tWeapon = {id=weaponId,basicInfo=GDatatab_item["id_"..weaponId],extraInfo=json.decode(self.m_tDataList[dataIndex].extraInfo)}	
	end

	if tWeapon ~= nil then
		self["m_tWeapon"..index] = tWeapon
   		GetElement(self.m_root,"imgWeapon"..index,WZUIImage):setFile(tWeapon.basicInfo.icon)
   		GetElement(self.m_root,"imgWeapon"..index..index,WZUIImage):setFile(tWeapon.basicInfo.icon)
   		GetElement(self.m_root,"btnWeapon"..index,WZUIButton):setVisible(true)

		local weaponExtranInfo = json.decode(self.m_tDataList[dataIndex].extraInfo)
		local starLevel = weaponExtranInfo.starLevel
	    starLevel = tonumber(starLevel)
	    if starLevel >=5 and  starLevel < 8 then
	    	spWeapon1:setVisible(true)
	    	spWeapon1:setAnimationName("5")
	    elseif starLevel >= 8 and starLevel < 10 then
	    	spWeapon1:setVisible(true)
	    	spWeapon1:setAnimationName("8")
	    elseif starLevel >= 10 and starLevel < 12 then
	    	spWeapon1:setVisible(true)
	    	spWeapon1:setAnimationName("10")
	    elseif starLevel >= 12 then
	    	spWeapon1:setVisible(true)
	    	spWeapon1:setAnimationName("12")
	    end
	else
   		GetElement(self.m_root,"btnWeapon"..index,WZUIButton):setVisible(false)
	end
end

--@brief	点击武器
function WndLeagueTeamDetail:onWeapon(element)
	WZLog("WndLeagueTeamDetail:onWeapon",element:getTag())
	if self["m_tWeapon"..element:getTag()] == nil then return end
	local index = element:getTag() 
   	WndItemInfo:showInfo(element, self.m_root,1,self["m_tWeapon"..index],false)
	local pt,pt1 = WndItemInfo:_gettToNodePt()--获取位置
	pt.x = pt.x + 10
	pt.y = pt.y + 70
	if tonumber(element:getTag()) == 3 then
		pt.x = pt.x - 300
	end
	if tonumber(element:getTag()) == 4 then
		pt.x = pt.x - 300
	end
	local windowElement = WZUIElementContainer:luaTo(WndItemInfo.m_root)
	windowElement:setAbsPosition( pt )
end

--@brief	宠物
function WndLeagueTeamDetail:_showPet(index,dataIndex)
	WZLog("WndLeagueTeamDetail:_showPet")
	if self.m_root == nil then return end
    local conPet = GetElement(self.m_root, "conPet"..index, WZUIContainer)
	if conPet:getChildByTag(1) then
		conPet:removeChildByTag(1,true)
	end
	local con = WZUIContainer:create()
	conPet:addChild(con)
	con:setTag(1)

	local petMessage = self.m_tDataList[dataIndex].pet
	self["m_tPet"..index] = petMessage
	if petMessage ~= nil and petMessage ~= "" then
		local ani, ani1 = CreatePetAni(con, nil, json.decode(petMessage).animation, json.decode(petMessage).advancedLevel, json.decode(petMessage).petSkinItemId)
		ani:getAnimNode():setTouchEnable(false)
        ani:getAnimNode():setScale(0.6)
		if ani1 ~= nil then
        	ani1:setScale(0.6)
		end
	end
end

--@brief	点击宠物
function WndLeagueTeamDetail:onPet(element)
	WZLog("WndLeagueTeamDetail:onPet",element:getTag())
	if self["m_tPet"..element:getTag()] == nil then return end
	local petMessage = self["m_tPet"..element:getTag()]
	WZLog("宠物触摸结束:",petMessage)
	if petMessage ~= nil and petMessage ~= "" then
		petMessage = json.decode(petMessage)
		--local conPet = WZUIWindow:luaTo(self.m_root:getChildElement("conPet_WndCheckOther"))
		if tonumber(element:getTag()) >= 3 then
			WndTips:show(element,self.m_root,13,petMessage,GlobalMethod:ccp(50,-10))
		else
			WndTips:show(element,self.m_root,13,petMessage,GlobalMethod:ccp(430,-10))
		end
	end
end

--@brief	显示人物形象
function WndLeagueTeamDetail:showRoles()
	--删除全部宠物，人物
	for i=1,4 do
		if self["conPlayer"..i] ~= nil then
			self["conPlayer"..i]:removeFromParentAndCleanup(true)
			self["conPlayer"..i] = nil
		end
	    local conPet = GetElement(self.m_root, "conPet"..i, WZUIContainer)
		if conPet:getChildByTag(1) then
			conPet:removeChildByTag(1,true)
		end
	end
	--队长
	for i=1,#self.m_tDataList do
		if self.m_tDataList[i].playerId == self.m_tData.captain then
			self:showAllRole(1,i)
		end
	end
	local position = 2
	GetElement(self.m_root,"imgVice",WZUIImage):setVisible(false)
	--副队长
	for i=1,#self.m_tDataList do
		if self.m_tDataList[i].playerId == self.m_tData.viceCaptain then
			self:showAllRole(2,i)
			GetElement(self.m_root,"imgVice",WZUIImage):setVisible(true)
			position = position + 1
		end
	end
	--队员
	for i=1,#self.m_tDataList do
		if self.m_tDataList[i].playerId ~= self.m_tData.captain and self.m_tDataList[i].playerId ~= self.m_tData.viceCaptain then
			self:showAllRole(position,i)
			position = position + 1
		end
	end
	----参战但没准备队员
	--for i=1,#self.m_tDataList do
	--	if self.m_tDataList[i].playerId ~= self.m_tData.captain and self.m_tDataList[i].playerId ~= self.m_tData.viceCaptain
	--		and self:idInTable(self.m_tDataList[i].playerId,self.m_tData.readyPlayerId)
	--		and (not self:idInTable(self.m_tDataList[i].playerId,self.m_tData.readyed)) then
	--		self:showAllRole(position,i)
	--		position = position + 1
	--	end
	--end
	----准备但没参战队员
	--for i=1,#self.m_tDataList do
	--	if self.m_tDataList[i].playerId ~= self.m_tData.captain and self.m_tDataList[i].playerId ~= self.m_tData.viceCaptain
	--		and (not self:idInTable(self.m_tDataList[i].playerId,self.m_tData.readyPlayerId))
	--		and self:idInTable(self.m_tDataList[i].playerId,self.m_tData.readyed) then
	--		self:showAllRole(position,i)
	--		position = position + 1
	--	end
	--end
	----候选队员
	--for i=1,#self.m_tDataList do
	--	if self.m_tDataList[i].playerId ~= self.m_tData.captain and self.m_tDataList[i].playerId ~= self.m_tData.viceCaptain
	--		and (not self:idInTable(self.m_tDataList[i].playerId,self.m_tData.readyed))
	--		and (not self:idInTable(self.m_tDataList[i].playerId,self.m_tData.readyPlayerId)) then
	--		self:showAllRole(position,i)
	--		position = position + 1
	--	end
	--end
	--空位
	if position > 4 then return end
	for i=position,4 do
		self["m_tRoleData"..i] = nil
		self:setBlank(i)
		--船长可以邀请
		if CacheCenter:getPlayerInfo().id == self.m_tData.captain then
			GetElement(self.m_root,"conInvite"..i,WZUIContainer):setVisible(true)
		else
			GetElement(self.m_root,"conInvite"..i,WZUIContainer):setVisible(false)
		end
	end
end

--@brief	显示人物，宠物，武器
function WndLeagueTeamDetail:showAllRole(position, dataIndex)
	--没有数据，返回
	if self.m_tDataList[dataIndex] == nil then return end
	--显示人物
	self:showRole(position,dataIndex)
	--显示宠物
	self:_showPet(position,dataIndex)
	--显示武器
	self:_showWeapon(position,dataIndex)
end

--@brief	显示人物形象
function WndLeagueTeamDetail:showRole(position, dataIndex)
	local playerId = self.m_tDataList[dataIndex].playerId
	local status = self.m_tDataList[dataIndex].status
	GetElement(self.m_root,"conRole"..position,WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conWenHao"..position,WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conOffLine"..position,WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conInvite"..position,WZUIContainer):setVisible(false)
	--等级
	GetElement(self.m_root,"roleLv"..position,WZUILabelTTF):setText(LocalStrings.LV..""..self.m_tDataList[dataIndex].level)
	--名字
	GetElement(self.m_root,"roleName"..position,WZUILabelTTF):setText(self.m_tDataList[dataIndex].name)
	GetElement(self.m_root,"roleLv"..position,WZUILabelTTF):setVisible(true)
	GetElement(self.m_root,"roleName"..position,WZUILabelTTF):setVisible(true)
	if self.m_tDataList[dataIndex].playerId == CacheCenter:getPlayerInfo().id then
		GetElement(self.m_root,"roleName"..position,WZUILabelTTF):setColor(GlobalMethod:ccc3(99,255,95))
	else
		GetElement(self.m_root,"roleName"..position,WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
	end
	--关系按钮
	GetElement(self.m_root,"conInfo_CellRoomSeat"..position,WZUIContainer):setVisible(true)
	WndLeagueTeamDetail:updateRelationBtn(position, dataIndex) 

	--阴影
	GetElement(self.m_root,"imgYY"..position,WZUIImage):setVisible(true)
	GetElement(self.m_root,"roleBg"..position,WZUI9Image):setVisible(true)

	local conP = WZUIContainer:luaTo(self.m_root:getChildElement("conRole"..position))
	local tEquip = {}
	table.insert(tEquip,self.m_tDataList[dataIndex].headId)
	table.insert(tEquip,self.m_tDataList[dataIndex].faceId)
	table.insert(tEquip,self.m_tDataList[dataIndex].bodyId)
	table.insert(tEquip,self.m_tDataList[dataIndex].wingId)
	local sex = self.m_tDataList[dataIndex].sex
	if self["conPlayer"..position] ~= nil then
		self["conPlayer"..position]:removeFromParentAndCleanup(true)
		self["conPlayer"..position] = nil
	end
	local conPlayer
	local headColor = self.m_tDataList[dataIndex].headColor
	local bodyColor = self.m_tDataList[dataIndex].bodyColor
	conPlayer, _1, _2, isMonster = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, headColor, bodyColor)
	conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.52,0.25))
	conPlayer:setScale(0.65)
	self["conPlayer"..position] = conPlayer
	conP:addChild(conPlayer:getAnimNode(),5)
	conPlayer:getAnimNode():setTouchEnable(false)
	if isMonster == true then
		conPlayer:getAnimNode():setRelativePosition(ccp(0.5,0.3))
	end

	self["m_tRoleData"..position] = self.m_tDataList[dataIndex]
	GetElement(self.m_root,"conOffLine"..position,WZUIContainer):setVisible(false)
	WZLog("设置状态前数据",position,Serialize(self.m_tDataList[dataIndex]))

	local isVoice = self:checkVoiceChannelLv()
	local conStatusBg = GetElement(self.m_root,"conStatusBg" .. position .. "_WndLeagueTeamDetail",WZUIContainer)
	local conFigure = GetElement(self.m_root,"conFigureVoice" .. position .. "_WndLeagueTeamDetail",WZUIContainer)
	local anim = GetElement(self.m_root,"animFigureVoice" .. position .. "_WndLeagueTeamDetail",WZUISpine)
	local img = GetElement(self.m_root,"imgFigureVoice" .. position .. "_WndLeagueTeamDetail",WZUIImage)

	if isVoice and playerId ~= CacheCenter:getPlayerInfo().id and (self:idInTable(playerId,self.m_tData.readyPlayerId) or self:idInTable(playerId,self.m_tData.readyed) or self:idInTable(playerId,self.m_tData.watchPlayerId)) then
        conFigure:setVisible(true)
        img:setFile("ui/common/common_icon_yuying_02.png")
		img:setGrayRender(true)
		img:setVisible(true)
		anim:setVisible(false)
        WZLog("updatePlayerSeat twe")
    end

	--人物状态
	GetElement(self.m_root,"imgCap"..position,WZUIImage):setVisible(true)
	--参战
	if self:idInTable(playerId,self.m_tData.readyPlayerId) then
		GetElement(self.m_root,"imgCap"..position,WZUIImage):setFile("ui/hero/hero_icon_canzhan.png")
		--return
	end
	--准备
	if self:idInTable(playerId,self.m_tData.readyed) then
		GetElement(self.m_root,"imgCap"..position,WZUIImage):setFile("ui/hero/hero_icon_yxzb.png")
		return
	end
	--候选
	if self:idInTable(playerId,self.m_tData.watchPlayerId) then
		GetElement(self.m_root,"imgCap"..position,WZUIImage):setFile("ui/hero/hero_icon_guanzhan.png")
		return
	end
	--未进入
	if status == -1 and (not self:idInTable(playerId,self.m_tData.readyPlayerId))
		and (not self:idInTable(playerId,self.m_tData.readyed))
		and (not self:idInTable(playerId,self.m_tData.watchPlayerId)) then
		GetElement(self.m_root,"imgCap"..position,WZUIImage):setFile("ui/hero/hero_icon_weijinru.png")

		if conStatusBg then
         	conStatusBg:setVisible(false)
            conFigure:setVisible(false)
     	end
		return
	end
	--离线
	if status > 0 then
		GetElement(self.m_root,"imgCap"..position,WZUIImage):setVisible(false)
		GetElement(self.m_root,"conOffLine"..position,WZUIContainer):setVisible(true)
		local txtOffLine = GetElement(self.m_root,"txtOffLine"..position,WZUILabelTTF)
		local showText
		if status > 86400 then
			showText = math.floor(status/86400)..LocalStrings.DAY
		elseif status > 3600 then
			showText = math.floor(status/3600)..LocalStrings.HOUR1
		else
			local min = math.ceil(status/60) 
			--WZLog("剩余秒数",status)
			--if min < 10 then min = "0"..min end
			--local s = status%60
			--WZLog("剩余秒数1",s)
			--if s < 10 then s = "0"..s end
			showText = min..LocalStrings.MINUTE1
		end
		txtOffLine:setText(LocalStrings.OFFLINESTATE..showText)
	end
end

--@brief	设置空位
function WndLeagueTeamDetail:setBlank(position)
	WZLog("WndLeagueTeamDetail:setBlank")
	GetElement(self.m_root,"roleLv"..position,WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"roleName"..position,WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"btnWeapon"..position,WZUIButton):setVisible(false)
	GetElement(self.m_root,"conWenHao"..position,WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conOffLine"..position,WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conInvite"..position,WZUIContainer):setVisible(false)
	GetElement(self.m_root,"imgYY"..position,WZUIImage):setVisible(false)
	GetElement(self.m_root,"roleBg"..position,WZUI9Image):setVisible(false)
	GetElement(self.m_root,"imgCap"..position,WZUIImage):setVisible(false)
	GetElement(self.m_root,"conInfo_CellRoomSeat"..position,WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conFigureVoice" .. position .. "_WndLeagueTeamDetail",WZUIContainer):setVisible(false)
end

--@brief	点击队员头像
function WndLeagueTeamDetail:onMember(element)
	WZLog("WndLeagueTeamDetail:onMember")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	self.m_nTag = tag

	--如果没有成员，弹出邀请界面
	if self["m_tRoleData"..tag] == nil then
		--船长可以邀请
		if CacheCenter:getPlayerInfo().id == self.m_tData.captain then
    		WndFriendList:showInterface(8,self,self.inviteMember)
		end
		return
	end
	WZLog("成员数据",Serialize(self["m_tRoleData"..tag]))
	WZLog("队长id",self.m_tData.captain)
	--队长直接显示自己信息
	--if self["m_tRoleData"..tag].playerId == self.m_tData.captain then
	--	WndCheckOther:show(self.m_tData.captain)
	--	return
	--end
	
	if WndPopupMenu.m_root ~= nil then
		WndPopupMenu:disappear()
	end

	local con = GetElement(self.m_root,"conRole"..tag,WZUIContainer)
	local popupMenu = WndPopupMenu:createElement()
	con:addChild(popupMenu,100)	
	popupMenu:setVisible(true)
	WZLog("self.m_root",self.m_root,popupMenu:getPositionX(),popupMenu:getPositionY(),popupMenu:isVisible())

	WndPopupMenu:disappear()

	local menuList = self:setManageMenuItems()
	WndPopupMenu:setPopupMenuItem(menuList,nil)
	WndPopupMenu:setCallBackFunc(self, self.onClickPopup)

	if self.m_root ~= nil then
		WndPopupMenu:popUpAtPoint(con, GlobalMethod:ccp(0, 0))
		WndPopupMenu.m_root:setPosition(GlobalMethod:ccp(0,240))
	end 
end

--@brief	根据权限设置管理菜单
function WndLeagueTeamDetail:setManageMenuItems()
	local position = tonumber(CacheCenter:getPlayerInfo().position)

	local tPopupMenuItems = {}

	local playerId = self["m_tRoleData"..self.m_nTag].playerId

	--设为参战/观战 参战观战人数大于等于4时
	if CacheCenter:getPlayerInfo().id == self.m_tData.captain and (#self.m_tData.readyPlayerId+#self.m_tData.watchPlayerId>=4) then
		if self:idInTable(playerId,self.m_tData.readyPlayerId) then
			table.insert(tPopupMenuItems,POPUPMENU_HERO2)
		elseif self:idInTable(playerId,self.m_tData.watchPlayerId) then 
			--table.insert(tPopupMenuItems,POPUPMENU_HERO1)
		end
	end

	--查看资料
	table.insert(tPopupMenuItems,POPUPMENU_HERO3)

	--设置/解除副队长
	if CacheCenter:getPlayerInfo().id == self.m_tData.captain and self["m_tRoleData"..self.m_nTag].playerId ~= self.m_tData.captain 
		and self["m_tRoleData"..self.m_nTag].playerId ~= self.m_tData.viceCaptain then
		table.insert(tPopupMenuItems,POPUPMENU_HERO6)
	end

	--设置/解除副队长
	if CacheCenter:getPlayerInfo().id == self.m_tData.captain and self["m_tRoleData"..self.m_nTag].playerId == self.m_tData.viceCaptain then
		table.insert(tPopupMenuItems,POPUPMENU_HERO7)
	end

	--邀请进入
	if (not self:idInTable(playerId,self.m_tData.readyPlayerId)) and
	 	(not self:idInTable(playerId,self.m_tData.watchPlayerId)) and
		self["m_tRoleData"..self.m_nTag].status == -1 then
		table.insert(tPopupMenuItems,POPUPMENU_HERO4)
	end

	--踢出队伍
	if CacheCenter:getPlayerInfo().id == self.m_tData.captain and playerId ~= CacheCenter:getPlayerInfo().id then
		table.insert(tPopupMenuItems,POPUPMENU_HERO5)
	end

	return tPopupMenuItems
end

--@brief  按钮回调函数
--@param #1 element:点击消息框的窗口对象
--@param #2	nId:点击消息框的那个ID
function WndLeagueTeamDetail:onClickPopup(element,nId)
	WndPopupMenu:disappear()
	if nId == POPUPMENU_HERO1 then 	
		self:onFight()
	elseif nId == POPUPMENU_HERO2 then   
		self:onDismiss()
	elseif nId == POPUPMENU_HERO3 then
		self:onCheck()
	elseif nId == POPUPMENU_HERO4 then
		self:onInvite()
	elseif nId == POPUPMENU_HERO5 then
		self:onFire()
	elseif nId == POPUPMENU_HERO6 then
		self:setViceCaptain()
	elseif nId == POPUPMENU_HERO7 then
		self:setTeamMember()
	end
end

--@brief	参战
function WndLeagueTeamDetail:onFight()
	WZLog("WndLeagueTeamDetail:onFight")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self["m_tRoleData"..self.m_nTag].playerId == nil then return end
	ProtocolProcessorWndLeague:send_HERO_ChangeStatus(self["m_tRoleData"..self.m_nTag].playerId, 1 )
end

--@brief	候选
function WndLeagueTeamDetail:onDismiss()
	WZLog("WndLeagueTeamDetail:onDismiss")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self["m_tRoleData"..self.m_nTag].playerId == nil then return end
	ProtocolProcessorWndLeague:send_HERO_ChangeStatus(self["m_tRoleData"..self.m_nTag].playerId, 2 )
end

--@brief	查看
function WndLeagueTeamDetail:onCheck()
	WZLog("WndLeagueTeamDetail:onCheck",Serialize(self["m_tRoleData"..self.m_nTag]))
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self["m_tRoleData"..self.m_nTag].playerId == nil then return end
	WndCheckOther:show(self["m_tRoleData"..self.m_nTag].playerId)
end

--@brief	邀请
function WndLeagueTeamDetail:onInvite()
	WZLog("WndLeagueTeamDetail:onInvite")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorWndLeague:send_HERO_InvitationReady(self["m_tRoleData"..self.m_nTag].playerId )
end

--@brief	邀请回调
function WndLeagueTeamDetail:onInviteCall(nId, nResType)
	WZLog("WndLeagueTeamDetail:onInviteCall",nResType)
	if nResType == 1 then
		WZLog("点击确定按钮")
		if SceneLeagueMain.m_root == nil then
			SceneLeagueMain:showInterface(2)
		else
			local checkbox1 = GetElement(SceneLeagueMain.m_root, "checkbox1_SceneLeagueMain", WZUICheckBox)
			checkbox1:setCheckIndex(0)
			local checkbox2 = GetElement(SceneLeagueMain.m_root, "checkbox2_SceneLeagueMain", WZUICheckBox)
			checkbox2:setCheckIndex(1)
			SceneLeagueMain:onTab2()
		end
	else
		WZLog("点击取消按钮")
	end
end

function WndLeagueTeamDetail:inviteMember(tData, tag)
	WZLog("WndLeagueTeamDetail:inviteMember",tag,Serialize(tData))
	if tData == nil or tData.id == nil then return end
    local id = WZLuaVector_int_:create()
   	id:push(tData.id)
	WZLog("WndLeagueTeamDetail:inviteMember",Serialize(VectorToTable(id)))
	ProtocolProcessorWndLeague:send_HERO_Invitation(id )
end

--@brief    被邀请时，确定按钮的回调  (发送进入房间的协议)
function WndLeagueTeamDetail:sendJoinTeam(teamId)
	WZLog("WndLeagueTeamDetail:sendJoinTeam",teamId)
	ProtocolProcessorWndLeague:send_HERO_Agree(teamId)	
end

--@brief	踢出
function WndLeagueTeamDetail:onFire()
	WZLog("WndLeagueTeamDetail:onFire")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--联赛期间不可踢出队员
	local timer = SceneLeagueMain.m_tTime
	if timer.nowTime > SceneLeagueMain:transformStringToTime(timer.startTime32) and
		timer.nowTime < SceneLeagueMain:transformStringToTime(timer.endTimeFThree) then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE51)
		return
	end
	--踢出确认框
	if self["m_tRoleData"..self.m_nTag].status ~= -1 and self["m_tRoleData"..self.m_nTag].status > 3600*48 then
    	MsgBoxManager:showConfirmCancelBox(LocalStrings.LEAGUE39, self, self.kickTeam, MSGBOXLEVEL_HIGH,nil)
	else
		local unit = tonumber(SceneLeagueMain.m_tTime.makePairPunish)
		if unit == nil then unit = 1 end
    	MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.LEAGUE40,unit*(self.m_tData.kictNum+1)), self, self.kickTeam, MSGBOXLEVEL_HIGH,nil)
	end
end

--@brief	设置副队长
function WndLeagueTeamDetail:setViceCaptain()
	WZLog("WndLeagueTeamDetail:setViceCaptain")
   	MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.LEAGUE68,self["m_tRoleData"..self.m_nTag].name), self, self.setViceCaptainCall, MSGBOXLEVEL_HIGH,nil)
end

function WndLeagueTeamDetail:setViceCaptainCall(nId, nResType)
	WZLog("WndLeagueTeamDetail:setViceCaptainCall",nResType)
	if nResType == 1 then
		WZLog("点击确定按钮")
		ProtocolProcessorWndLeague:send_HERO_Promotion(self["m_tRoleData"..self.m_nTag].playerId)
	else
		WZLog("点击取消按钮")
	end
end

--@brief	设置队员
function WndLeagueTeamDetail:setTeamMember()
	WZLog("WndLeagueTeamDetail:setTeamMember")
   	MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.LEAGUE69,self["m_tRoleData"..self.m_nTag].name), self, self.setTeamMemberCall, MSGBOXLEVEL_HIGH,nil)
end

function WndLeagueTeamDetail:setTeamMemberCall(nId, nResType)
	WZLog("WndLeagueTeamDetail:setTeamMemberCall",nResType)
	if nResType == 1 then
		WZLog("点击确定按钮")
		ProtocolProcessorWndLeague:send_HERO_Cancel()
	else
		WZLog("点击取消按钮")
	end
end

function WndLeagueTeamDetail:kickTeam(nId, nResType)
	WZLog("WndLeagueTeamDetail:exitTeam",nResType)
	if nResType == 1 then
		WZLog("点击确定按钮")
		ProtocolProcessorWndLeague:send_HERO_KickTeam(self["m_tRoleData"..self.m_nTag].playerId)
	else
		WZLog("点击取消按钮")
	end
end

--@brief	战队设置
function WndLeagueTeamDetail:onBtn1()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndLeagueCreate:showSetting(self.m_tData.teamName,self.m_tData.declaration,self.m_tData.photoURL)
end

--@brief	战队审核
function WndLeagueTeamDetail:onBtn2()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndLeagueRecruit:show()
end

--@brief	退出战队
function WndLeagueTeamDetail:onBtn3()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--准备状态不可退出
	if WndLeagueTeamDetail.m_tData ~= nil and WndLeagueTeamDetail:idInTable(CacheCenter:getPlayerInfo().id,WndLeagueTeamDetail.m_tData.readyed) then
		MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
		return
	end
	--联赛期间不可退出
	local timer = SceneLeagueMain.m_tTime
	if timer.nowTime > SceneLeagueMain:transformStringToTime(timer.startTime32) and
		timer.nowTime < SceneLeagueMain:transformStringToTime(timer.endTimeFThree) then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE52)
		return
	end
	--退出确认框
	if CacheCenter:getPlayerInfo().id == self.m_tData.captain then
        MsgBoxManager:showConfirmCancelBox(LocalStrings.LEAGUE32, self, self.exitTeam, MSGBOXLEVEL_HIGH,nil)
	else
		if SystemTime:getServerTime() - self.m_tData.lastFight > 3600*48 then
        	MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.LEAGUE33,""), self, self.exitTeam, MSGBOXLEVEL_HIGH,nil)
		else
			local unit = tonumber(SceneLeagueMain.m_tTime.applyPunish)
			if unit == nil then unit = 1 end
        	MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.LEAGUE34,"",unit*(self.m_tData.exitNum+1)), self, self.exitTeam, MSGBOXLEVEL_HIGH,nil)
		end
	end
end

function WndLeagueTeamDetail:exitTeam(nId, nResType)
	WZLog("WndLeagueTeamDetail:exitTeam",nResType)
	if nResType == 1 then
		WZLog("点击确定按钮")
		self.m_bExitTeam = true
		ProtocolProcessorWndLeague:send_HERO_OutTeam()
		if WndLeagueTeamList.m_root ~= nil then	WndLeagueTeamList.m_root:setVisible(true) end
		if WndLeagueTeamDetail.m_root ~= nil then WndLeagueTeamDetail.m_root:setVisible(false) end
	else
		WZLog("点击取消按钮")
	end
end

--@brief	查看大图
function WndLeagueTeamDetail:onCheckHead(element)
	WZLog("WndLeagueTeamDetail:onCheckHead")
	if self.m_tData == nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	SceneLeagueMain.m_nCheckType = 4
	SceneLeagueMain.m_tCheckWnd = WndLeagueTeamDetail
	SceneLeagueMain.m_tCheckElement = element
	ProtocolProcessorWndLeague:send_HERO_SearchTeam(self.m_tData.teamId )

	--没上传照片的玩家点击无效
	--if self.m_tData.photoURL == nil or self.m_tData.photoURL == "" then
	--	return
	--end

	--local wnd = WndSpaceView:createElement()
	--WindowManager:addWindow(wnd, WndSpaceView, true, nil, nil, true)
	--
	----根据性别设置默认头像
	--local imgShow = "ui/hero/hero_icon_yxlsdb.png"

	----如果已经下载头像
	--if self.m_tData.photoURL ~= nil and self.m_tData.photoURL ~= "" then
	--	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..self.m_tData.photoURL
	--	--如果文件存在，不下载，直接使用
	--	local bExist = WZFileUtil:isFileExist(path)
	--	if bExist then
	--		GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile(path)
	--	else
	--		GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile(imgShow)
	--	end
	--else
	--	GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile(imgShow)
	--end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndLeagueTeamDetail:update()
	if self.m_root == nil then return end
	--清除之前的队员数据
	for i=1,4 do
		self["m_tRoleData"..i] = nil
	end
	self:showRoles()
	--下场开始时间
	self:updateTime()
    self.m_root:enableSchedule("updateTime",1)
	--战队名字
	GetElement(self.m_root,"ttfTeamName",WZUILabelTTF):setText(self.m_tData.teamName)
	--战队id
	--MsgBoxManager:showTipBox(type(self.m_tData.teamId))
	--MsgBoxManager:showTipBox("战队 ID:"..tostring(self.m_tData.teamId))
	GetElement(self.m_root,"ttfTeamID",WZUILabelTTF):setText(LocalStrings.LEAGUE104..tostring(self.m_tData.teamId))
	--排名
	if tonumber(self.m_tData.rank) == 0 then
		GetElement(self.m_root,"ttf1",WZUILabelTTF):setText(LocalStrings.NONE)
	else
		GetElement(self.m_root,"ttf1",WZUILabelTTF):setText(self.m_tData.rank)
	end
	--积分
	GetElement(self.m_root,"ttf2",WZUILabelTTF):setText(self.m_tData.score)
	--战绩
	GetElement(self.m_root,"ttf3",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO67,self.m_tData.fightNum,self.m_tData.winNum))
	if ProjConfig.LANGUAGE == "en" then
		GetElement(self.m_root,"ttf3",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO67,self.m_tData.winNum,self.m_tData.fightNum))
	end
	--宣言
	GetElement(self.m_root,"ttfDeclaration",WZUILabelTTF):setText(LocalStrings.LEAGUE37..":"..self.m_tData.declaration)
	--按钮权限
	GetElement(self.m_root,"btnStart",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnReady",WZUIButton):setVisible(false)
	self.m_nCurCaptain = self.m_tData.captain
	if CacheCenter:getPlayerInfo().id == self.m_tData.captain then
		GetElement(self.m_root,"btnSet",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnRecruit",WZUIButton):setVisible(true)
		
		GetElement(self.m_root,"btnStart",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnExit",WZUIButton):setRelativePosition(ccp(0.24,0.32))
		--队长不在参数列表,也没有开始按钮
		--if (not self:idInTable(self.m_tData.captain, self.m_tData.readyPlayerId)) then
		--	GetElement(self.m_root,"btnStart",WZUIButton):setVisible(false)
		--end
	elseif CacheCenter:getPlayerInfo().id ~= self.m_tData.viceCaptain then
		GetElement(self.m_root,"btnExit",WZUIButton):setRelativePosition(ccp(0.75,0.32))
		GetElement(self.m_root,"btnSet",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnRecruit",WZUIButton):setVisible(false)

		if (not self:idInTable(CacheCenter:getPlayerInfo().id,self.m_tData.watchPlayerId)) then
			GetElement(self.m_root,"btnReady",WZUIButton):setVisible(true)
		end
	else
		GetElement(self.m_root,"btnExit",WZUIButton):setRelativePosition(ccp(0.7,0.32))
		GetElement(self.m_root,"btnSet",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnRecruit",WZUIButton):setVisible(false)
	
		GetElement(self.m_root,"btnReady",WZUIButton):setVisible(true)
		--副队长候选没有准备按钮
		if (self:idInTable(CacheCenter:getPlayerInfo().id,self.m_tData.watchPlayerId)) then
			GetElement(self.m_root,"btnReady",WZUIButton):setVisible(false)
		end
		--开始按钮
		--自己是副队长,但队长不在
		if CacheCenter:getPlayerInfo().id == self.m_tData.viceCaptain 
			and (not self:idInTable(self.m_tData.captain,self.m_tData.readyPlayerId))
			and (not self:idInTable(self.m_tData.captain,self.m_tData.watchPlayerId)) 
			and (not self:idInTable(self.m_tData.captain,self.m_tData.readyed)) then
			GetElement(self.m_root,"btnStart",WZUIButton):setVisible(true)
			self.m_nCurCaptain = self.m_tData.viceCaptain
		end
	end
	--战队图标
	local con = GetElement(self.m_root,"conHead",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	if self.m_tData.photoURL ~= "" then 
		--添加下载图片Cell
		local celElement,tCell = CellDownloadImg:createElement()
		con:addChild(celElement)

		SceneLeagueMain:addDownloadFileList(self.m_tData.photoURL, tCell, nil, 70)
	end
	--审核状态 队长才显示审核状态
	if self.m_tData.picStatus == 3 and self.m_tData.captain == CacheCenter:getPlayerInfo().id then
		GetElement(self.m_root,"txtCheck",WZUILabelTTF):setVisible(true)
	else
		GetElement(self.m_root,"txtCheck",WZUILabelTTF):setVisible(false)
	end
	--准备/取消准备
	if self:idInTable(CacheCenter:getPlayerInfo().id,self.m_tData.readyed) then
		GetElement(self.m_root,"txtReady",WZUILabelTTF):setText(LocalStrings.LEAGUE59)
	else
		GetElement(self.m_root,"txtReady",WZUILabelTTF):setText(LocalStrings.READY)
	end

	--红点
	self:setRedDot()
end

--@brief	更新时间
function WndLeagueTeamDetail:updateTime()
	--WZLog("WndLeagueTeamDetail:updateTime",type(self.m_nGameStage),self.m_nGameStage)
	if SceneLeagueMain.m_tTimeList == nil then return end
	if SceneLeagueMain.m_tTime == nil then return end
	--更新匹配时间
	if self.m_nMatchingCountdown ~= nil then
		self.m_nMatchingCountdown = self.m_nMatchingCountdown + 1
		if self.m_nMatchingCountdown > 60 then
			ProtocolProcessorWndLeague:parse_HERO_EndMakePairHeroOk()
			self.m_nMatchingCountdown = nil
			GetElement(self.m_root,"conCountDown",WZUIContainer):setVisible(false)
		else
			GetElement(self.m_root,"txtCountDown",WZUILabelAtlasFont):setText(self.m_nMatchingCountdown)
		end
	end

	local gameState = self.m_nGameStage
	if gameState == nil then return end
	local timeList = SceneLeagueMain.m_tTimeList
	local nowTime = SceneLeagueMain.m_tTime.nowTime
	--比赛开始倒计时
	if self.m_bshowCountDown == false then
		--GetElement(self.m_root, "nextStartTime", WZUILabelTTF):setText("")
		--GetElement(self.m_root, "gameStage", WZUILabelTTF):setText(GAMENAME[gameState])
		WZLog("???",gameState)
		GetElement(self.m_root, "nextStartTime", WZUILabelTTF):setText(GAMENAME[gameState].."")
	elseif self.m_bshowCountDown == true then
		--local sec = SceneLeagueMain:transformStringToTime(timeList[gameState*2-1])-nowTime
		local sec = CacheCenter:getLeagueInfo().countDown

		self.m_nLeftTime = sec
		local showText
		if sec > 86400 then
			showText = math.floor(sec/86400)..LocalStrings.DAY
		elseif sec > 3600 then
			showText = math.floor(sec/3600)..LocalStrings.HOUR1
		else
			local min = math.floor(sec/60) 
			WZLog("剩余秒数",sec)
			if min < 10 then min = "0"..min end
			local s = sec%60
			WZLog("剩余秒数1",s)
			if s < 10 then s = "0"..s end
			showText = min..":"..s
		end
		--GetElement(self.m_root, "nextStartTime", WZUILabelTTF):setText(showText..LocalStrings.LEAGUE45)
		--GetElement(self.m_root, "gameStage", WZUILabelTTF):setText(GAMENAME[gameState])
		GetElement(self.m_root, "nextStartTime", WZUILabelTTF):setText(GAMENAME[gameState]..showText..LocalStrings.LEAGUE45)
		if gameState >= 16 then
			--GetElement(self.m_root, "nextStartTime", WZUILabelTTF):setText("")
			--GetElement(self.m_root, "gameStage", WZUILabelTTF):setText("")
			GetElement(self.m_root, "nextStartTime", WZUILabelTTF):setText("")
		else
			if self.m_bFighting == true then
				--GetElement(self.m_root, "gameStage", WZUILabelTTF):setText(GAMENAME[gameState+1])
				GetElement(self.m_root, "nextStartTime", WZUILabelTTF):setText(GAMENAME[gameState+1])
				if ProjConfig.LANGUAGE == "vn" then
					GetElement(self.m_root, "gameStage", WZUILabelTTF):setText(GAMENAME[gameState])
				end
			end
		end
	end
	--海选赛不显示倒计时
	if gameState == 1 or gameState == 17 then
		--GetElement(self.m_root, "nextStartTime", WZUILabelTTF):setText("")
		--GetElement(self.m_root, "gameStage", WZUILabelTTF):setText("")
		GetElement(self.m_root, "nextStartTime", WZUILabelTTF):setText("")
	end

	--比赛赛程说明
	local showGameTime
	--WZLog("WndLeagueTeamDetail:updateTime1",gameState)
	if gameState == 1 then
		--海选赛
		showGameTime = LocalStrings.LEAGUE18..":"..SceneLeagueMain.m_tTime.startTime1.."-"..SceneLeagueMain.m_tTime.endTime1.."\n"..LocalStrings.LEAGUE111..":"..SceneLeagueMain.m_tTime.startTime.."-"..SceneLeagueMain.m_tTime.endTime.."\n"..LocalStrings.LEAGUE112.."+"..SceneLeagueMain.m_tTime.winScore..","..LocalStrings.LEAGUE113..SceneLeagueMain.m_tTime.failScore
	elseif gameState == 2 or gameState == 3 or gameState == 4 then
		--小组赛
		showGameTime = string.format(LocalStrings.LEAGUE71,string.sub(timeList[gameState*2],1,10),string.sub(self:transformStringToTime(timeList[3]),12,16),string.sub(self:transformStringToTime(timeList[5]),12,16),string.sub(self:transformStringToTime(timeList[7]),12,16))
	elseif gameState == 5 or gameState == 6 or gameState == 7 then
		--16强
		showGameTime = string.format(LocalStrings.LEAGUE72,string.sub(timeList[gameState*2],1,10),string.sub(self:transformStringToTime(timeList[9]),12,16),string.sub(self:transformStringToTime(timeList[11]),12,16),string.sub(self:transformStringToTime(timeList[13]),12,16))
	elseif gameState == 8 or gameState == 9 or gameState == 10 then
		--8强到4强
		showGameTime = string.format(LocalStrings.LEAGUE73,string.sub(timeList[gameState*2],1,10),string.sub(self:transformStringToTime(timeList[15]),12,16),string.sub(self:transformStringToTime(timeList[17]),12,16),string.sub(self:transformStringToTime(timeList[19]),12,16))
	elseif gameState == 11 or gameState == 12 or gameState == 13 then
		--半决赛
		showGameTime = string.format(LocalStrings.LEAGUE74,string.sub(timeList[gameState*2],1,10),string.sub(self:transformStringToTime(timeList[21]),12,16),string.sub(self:transformStringToTime(timeList[23]),12,16),string.sub(self:transformStringToTime(timeList[25]),12,16))
	elseif gameState == 14 or gameState == 15 or gameState == 16 or gameState == 17 then
			--WZLog(gameState)
		--决赛
		if gameState == 17 then gameState = 16 end
		showGameTime = string.format(LocalStrings.LEAGUE75,string.sub(timeList[gameState*2],1,10),string.sub(self:transformStringToTime(timeList[27]),12,16),string.sub(self:transformStringToTime(timeList[29]),12,16),string.sub(self:transformStringToTime(timeList[31]),12,16))
	else
		--WZLog("比赛阶段",gameState,self.m_bshowCountDown,WndLeagueTeamDetail.m_bGameStart)
	end
	--WZLog("比赛阶段",gameState,self.m_bFighting,WndLeagueTeamDetail.m_bGameStart)
	GetElement(self.m_root, "battleInfo", WZUILabelTTF):setText(showGameTime)

	--显示tips
	GetElement(self.m_root, "conTip", WZUIContainer):setVisible(false)
	if self.m_bshowCountDown == true and self.m_bGameStart == true then
		if CacheCenter:getPlayerInfo().id == self.m_tData.captain then
			GetElement(self.m_root, "conTip", WZUIContainer):setVisible(true)
		else
			--自己是副队长,但队长不在
			if CacheCenter:getPlayerInfo().id == self.m_tData.viceCaptain 
				and (not self:idInTable(self.m_tData.captain,self.m_tData.readyPlayerId))
				and (not self:idInTable(self.m_tData.captain,self.m_tData.watchPlayerId)) 
				and (not self:idInTable(self.m_tData.captain,self.m_tData.readyed)) then
				GetElement(self.m_root, "conTip", WZUIContainer):setVisible(true)
			end
		end
	end
end

--@param	表示时间的字符串  例如:1970.01.01 12:00
--@return 	提前10分钟->如传进来的是1970.01.01 12:00，最后得出1970.01.01 11:50
function WndLeagueTeamDetail:transformStringToTime(date)
	local time = date
	local time1 = SplitStringWithSeparator(time," ")
	local time2 = SplitStringWithSeparator(time1[#time1],":")

	local year = string.sub(time1[1],1,4)
	local month = string.sub(time1[1],6,7)
	local day = string.sub(time1[1],9,10)
	local hour = tonumber(time2[1])
	local min = tonumber(time2[2])

	local sec = os.time({year=year,month=month,day=day,hour=hour,min=min})
	sec = sec - 600
	local result = os.date("%Y.%m.%d %H:%M", sec)

	return result
end





------语音聊天
--@brief    加入语音聊天室
function WndLeagueTeamDetail:joinVoice()
	if self.m_bIsTryJoinVoice ~= true then
	    GlobalGame.m_sVoiceRoomName = "league_room_" .. self.m_tData.teamId
	    local isOk =  WGCloudVoiceNotify:JoinTeamRoom(GlobalGame.m_sVoiceRoomName)
	    WZLog("WndLeagueTeamDetail:joinVoice", GlobalGame.m_sVoiceRoomName, isOk, type(isOk))
	    if isOk ~= 0 then
	    	self.m_bIsTryJoinVoice = true
		    local call=CCCallFunc:create(function() 
		    			self.m_bIsTryJoinVoice = false
						self:joinVoice()
					end)
			local delay =  CCDelayTime:create(0.2)
			local array = CCArray:create()
			array:addObject(delay)
			array:addObject(call)
		    self.m_root:runAction(CCSequence:create(array))
		else
			self.m_bIsVoiceState = true
			self.m_bIsTryJoinVoice = false
		end
	end
end

--@brief    离开语音聊天室
function WndLeagueTeamDetail:quitVoice()
    WZLog("WndLeagueTeamDetail:quitVoice", GlobalGame.m_sVoiceRoomName)
    if GlobalGame.m_sVoiceRoomName == nil then return end
    WGCloudVoiceNotify:QuitRoom(GlobalGame.m_sVoiceRoomName)
    GlobalGame.m_sVoiceRoomName = nil
    GlobalGame.m_nVoiceId = nil
end

--@brief    语音聊天室成员状态回调
--0 停止说话
--1 开始说话
--2 继续说话
function WndLeagueTeamDetail:voiceMemberState(state)
    WZLog("WndLeagueTeamDetail:voiceMemberState one", Serialize(state))
    local index = -1
    for j=1,state.count do
        for i,v in pairs(self.m_tVoiceId) do
            local offset = (j-1) * 2
            WZLog("WndLeagueTeamDetail:voiceMemberState two-0", j, i, offset)
            if v == state.members[1 + offset] then
            	index = i
                WZLog("WndLeagueTeamDetail:voiceMemberState three", state.members[2 + offset])

                if WndLeagueTeamDetail.m_tMicState[index] == 1 then
                	local anim = GetElement(self.m_root,"animFigureVoice" .. index .. "_WndLeagueTeamDetail",WZUISpine)
	                local img = GetElement(self.m_root,"imgFigureVoice" .. index .. "_WndLeagueTeamDetail",WZUIImage)
	                local file
	                local isGray
	                if state.members[2 + offset] == 0 then
						img:setVisible(true)
						anim:setVisible(false)
	                elseif state.members[2 + offset] == 1 or state.members[2 + offset] == 2 then
	                    img:setVisible(false)
	                    anim:setVisible(true)
	                end
	            end
                break
            end
        end
    end
end

--@brief    开启语音按钮定时器
function WndLeagueTeamDetail:openVoiceTimer()
	self.m_nVoiceTimer = 0.4
	local call=CCCallFunc:create(function() 
				self:closeVoiceTimer()
			end)
	local delay =  CCDelayTime:create(self.m_nVoiceTimer)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(call)
    self.m_root:runAction(CCSequence:create(array))
end

--@brief    关闭语音按钮定时器
function WndLeagueTeamDetail:closeVoiceTimer()
	self.m_nVoiceTimer = 0
end

--@brief	听筒按钮点击后的Lua回调
function WndLeagueTeamDetail:onClickSpeaker(sender, state, isNoSend)
	if TeachGroup1.ISBATTLE == true then
        return
    end

    if GetPlayTalk() == 1 then
    	MsgBoxManager:showConfirmCancelBox(LocalStrings.VOICE_OPENSTR or "", self, self.onClickSpeakerCall, nil)
    	return
    end

    if not WGCloudVoiceNotify:IsSupportVoice() then
        MsgBoxManager:showTipBox(LocalStrings.VOICE_NOSUPPORT or "")
        return
    end

	if self.m_nVoiceTimer > 0 and sender then
		MsgBoxManager:showTipBox(LocalStrings.VOICE_CLICKMORE or "")
		return
	end

    if sender then
    	self:openVoiceTimer()
	end
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndBattleHud:onClickSpeaker", self.m_nSpeakerState, state)
    if state then
        if state ~= self.m_nSpeakerState then
            return
        end
        self.m_nSpeakerState = state
    end
    if self.m_nSpeakerState == 0 then
        WGCloudVoiceNotify:OpenSpeaker()
        GetElement(self.m_root,"imgSpeaker1_WndLeagueTeamDetail",WZUIImage):setGrayRender(false)
        GetElement(self.m_root,"imgSpeaker2_WndLeagueTeamDetail",WZUIImage):setGrayRender(false)
    else
        WGCloudVoiceNotify:CloseSpeaker()
        GetElement(self.m_root,"imgSpeaker1_WndLeagueTeamDetail",WZUIImage):setGrayRender(true)
        GetElement(self.m_root,"imgSpeaker2_WndLeagueTeamDetail",WZUIImage):setGrayRender(true)
    end
    
    if self.m_nSpeakerState == 1 then
        self:onClickMic(nil, 1, true)
    end
    self.m_nSpeakerState = 1 - self.m_nSpeakerState

    if self.m_bIsVoiceState == false then
		self:joinVoice()
	elseif isNoSend == nil then
    	ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "2," .. self.m_nSpeakerState, 0 )
	end
end

function WndLeagueTeamDetail:onClickSpeakerCall(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local data = WZDataFile:getInstance():getUserData()
		if data then		
			data:setStringValue("TalkData", "playTalk", "0")
			data:flush()
		end
		self:onClickSpeaker(true)
	end
end

function WndLeagueTeamDetail:onClickMicCall(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local data = WZDataFile:getInstance():getUserData()
		if data then		
			data:setStringValue("TalkData", "playTalk", "0")
			data:flush()
		end
		self:onClickMic(true)
	end
end

--@brief    麦克风按钮点击后的Lua回调
function WndLeagueTeamDetail:onClickMic(sender, state, isNoSend)
	if TeachGroup1.ISBATTLE == true then
        return
    end

    if GetPlayTalk() == 1 then
    	MsgBoxManager:showConfirmCancelBox(LocalStrings.VOICE_OPENSTR or "", self, self.onClickMicCall, nil)
    	return
    end

    if not WGCloudVoiceNotify:IsSupportVoice() then
        MsgBoxManager:showTipBox(LocalStrings.VOICE_NOSUPPORT or "")
        return
    end
    
	if self.m_nVoiceTimer > 0 and sender then
		MsgBoxManager:showTipBox(LocalStrings.VOICE_CLICKMORE or "")
		return
	end

	if sender then
    	self:openVoiceTimer()
	end
    --SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndBattleHud:onClickMic one", self.m_nMicState)
    
    if state then
        if state ~= self.m_nMicState then
            return
        end
        self.m_nMicState = state
    end

    if self.m_nMicState == 0 then
        WGCloudVoiceNotify:OpenMic()
        GetElement(self.m_root,"imgMic1_WndLeagueTeamDetail",WZUIImage):setGrayRender(false)
        GetElement(self.m_root,"imgMic2_WndLeagueTeamDetail",WZUIImage):setGrayRender(false)
    else
        WGCloudVoiceNotify:CloseMic()
        GetElement(self.m_root,"imgMic1_WndLeagueTeamDetail",WZUIImage):setGrayRender(true)
        GetElement(self.m_root,"imgMic2_WndLeagueTeamDetail",WZUIImage):setGrayRender(true)
    end
    
    if self.m_nMicState == 0 then
        self:onClickSpeaker(nil, 0, true)
    end

    if self.m_nMicState == 1 then
        WZLog("WndBattleHud:onClickMic two")
        --self:onClickSpeaker(nil, 1 - self.m_nSpeakerState)
        local call=CCCallFunc:create(function() 
                self:onClickSpeaker(nil, 1 - self.m_nSpeakerState)
            end)
        local delay =  CCDelayTime:create(1)
        local array = CCArray:create()
        array:addObject(delay)
        array:addObject(call)
        self.m_root:runAction(CCSequence:create(array))
    end
    self.m_nMicState = 1 - self.m_nMicState

    if self.m_bIsVoiceState == false then
		self:joinVoice()
	elseif isNoSend == nil then
    	ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM, 8, "3," .. self.m_nMicState, 0 )
	end
end

--@brief    检查是否可以语音
function WndLeagueTeamDetail:checkVoice()
	local isVoice = false
	WZLog("WndLeagueTeamDetail:checkVoice")
	if self:checkVoiceChannelLv() then
		isVoice = true
	end
	self.m_bIsVoice = isVoice

	if isVoice then
		self.m_tVoiceId = {}
    	self.m_tVoiceState = {}
    	self.m_tMicState = {}
    else
    	GetElement(self.m_root,"btnSpeaker_WndLeagueTeamDetail",WZUIButton):setVisible(false)
    	GetElement(self.m_root,"btnMic_WndLeagueTeamDetail",WZUIButton):setVisible(false)
	end
end

--@brief    检查语音渠道和等级
function WndLeagueTeamDetail:checkVoiceChannelLv()
	local isShow = false
	WZLog("WndLeagueTeamDetail:checkVoiceChannelLv", CheckTalkButtonShow(14))
	if  CheckTalkButtonShow(14) then
		isShow = true
	end

	isShow = isShow
	return isShow
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndLeagueTeamDetail:_adaptLanguage_vn(  )
	GetElement(self.m_root,"ttf1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.76,0.78))
	GetElement(self.m_root,"ttf3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.23))
	GetElement(self.m_root,"roleLv1",WZUIlabelTTF):setRelativePosition(GlobalMethod:ccp(0.12,0.925))
	GetElement(self.m_root,"roleName1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.93))
	GetElement(self.m_root,"imgLeader_WndLeagueTeamDetail",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.15,0.95))
	for i=2,4 do
		local con = GetElement(self.m_root,"conInvite"..i, WZUIContainer)
		con:setRelativePosition(GlobalMethod:ccp(0.38,0.12))
	end
	local txtCountDownTip = GetElement(self.m_root,"txtCountDownTip",WZUILabelTTF)
	txtCountDownTip:setScale(0.7)
	txtCountDownTip:setDimensions(GlobalMethod:CCSize(380,0))
end

-------------------------------------语言适配End--------------------------------------------