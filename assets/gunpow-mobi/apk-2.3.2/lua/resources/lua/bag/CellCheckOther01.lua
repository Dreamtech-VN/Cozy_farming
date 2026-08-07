--CellCheckOther01.lua
--@brief	CellCheckOther01的UI模块
--@date		2015/07/06
--@author	zsq
--@note		玩家信息栏1


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOther01:onEnter(element)
	self.m_root = element
end

function CellCheckOther01:onEnterTransitionDidFinish(element)
	
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOther01:onExit(element)
	self:_unInit()
end

function CellCheckOther01:onTouchBegan()
	WZLog("CellCheckOther01:onTouchBegan")

end

--@brief	设置高亮
function CellCheckOther01:setHighLight(bool)
	if self.m_root == nil then return end
	if self.m_nBtnTag == nil then return end
	local btn = GetElement(self.m_root,"btn"..self.m_nBtnTag,WZUIButton)
	if bool == true then
		btn:setButtonStatus(1)
	elseif bool == false then
		btn:setButtonStatus(0)
	end
end

--@brief	点击属性按钮
function CellCheckOther01:onAttr(element)
	WZLog("CellCheckOther01:onAttr")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = {icon="",
	attrInfo1=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.HEALTH,WndCheckOther.m_tPlayerInfo.hp),
	attrInfo2=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.ATTACK,WndCheckOther.m_tPlayerInfo.attack),
	attrInfo3=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.DEFENSE,WndCheckOther.m_tPlayerInfo.defend),
	attrInfo4=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.CRIT,WndCheckOther.m_tPlayerInfo.critRate),
	attrInfo5=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.FREESTORM,WndCheckOther.m_tPlayerInfo.reduceCrit),
	attrInfo6=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.TIZHI,WndCheckOther.m_tPlayerInfo.physique),
	attrInfo7=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.POWER,WndCheckOther.m_tPlayerInfo.force),
	attrInfo8=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.PRACTICE_ARMOR,WndCheckOther.m_tPlayerInfo.armor),
	attrInfo9=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.AGILITY,WndCheckOther.m_tPlayerInfo.agility),
	attrInfo10=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.LUCKY,WndCheckOther.m_tPlayerInfo.luck),
	attrInfo11=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.ANTIBREAKING,WndCheckOther.m_tPlayerInfo.wreckDefense),
	attrInfo12=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.AVOIDINJURY,WndCheckOther.m_tPlayerInfo.injuryFree),
	attrInfo13=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.RANGE,WndCheckOther.m_tPlayerInfo.range),
	}
	WndTips:show(element,WndCheckOther.m_root,2,tData,GlobalMethod:ccp(192,-122), true)
	GetElement(WndTips.m_root,"bgType2_WndTips",WZUI9Image):setContentSize(GlobalMethod:CCSize(150,435))
	GetElement(WndTips.m_root,"bgType2_WndTips",WZUI9Image):setRelativePosition(ccp(-0.1,0.51))
end

--@brief	竞技   tip
function CellCheckOther01:onAttr0(element)
	WZLog("CellCheckOther01:onTip0")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local tData = WndCheckOther.m_tPlayerInfo
	local playNum = tData.playNum
	tData.highLightObj = self
	tData.winType = 1 
	if playNum == 0 and tData.level < 8 then
		local title = LocalStrings.TIPS3
		local tData = {icon="ui/common/common_icon_hz3.png",
			title=title,
			level=1,
			px=0.2,
			py=0.5,
			winType = 1, 
			highLightObj = self,
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0), true)
	else
		WndTips:show(element,WndCheckOther.m_root,4,tData,GlobalMethod:ccp(25,10), true)
	end
end

--@brief	娱乐赛   tip
function CellCheckOther01:onAttr1(element)
	WZLog("CellCheckOther01:onTip1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	tData = json.decode(WndCheckOther.m_tPlayerInfo.ylJsonInfo)
	tData.highLightObj = self
	tData.winType = 2
	WndTips:show(element,WndCheckOther.m_root,4,tData,GlobalMethod:ccp(25,10), true)
end

--@brief	排位等级
function CellCheckOther01:onAttr2(element)
	WZLog("CellCheckOther01:onTip3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local level = WndCheckOther.m_tPlayerInfo.segmentId
	local maxLevel = WndCheckOther.m_tPlayerInfo.myMaxSegmentLevel
	if tonumber(level) == 0 then
		local title = LocalStrings.TIPS4
		local tData = {icon="ui/common/common_icon_pws1.png",
			title=title,
			level=level,
			px=0.2,
			py=0.5,
			highLightObj = self,
			pvprankMark = 1,
			maxLevel = maxLevel,
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0), true)
	else
    	local info = json.decode(WndCheckOther.m_tPlayerInfo.rankMatchMessage)
    	WZLog("CellCheckOther01:onTip3", maxLevel, Serialize(info))
    	local data = {level = tonumber(info.level), winNum = info.winTimes,total = info.joinTimes,maxWinNum = info.continous,exp=tonumber(info.exp), maxLevel = maxLevel}
    	WndTips:show(element,WndCheckOther.m_root,17,data,GlobalMethod:ccp(36,-5), true)
	end
end

--@brief	图腾等级
function CellCheckOther01:onAttr3(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local level = WndCheckOther.m_tPlayerInfo.totemLevel
	WZLog("CellCheckOther01:onTip3",level)
	local title
	local icon = "ui/common/common_icon_gonghui.png"
	if tostring(level) == "0" then
		title = LocalStrings.TIPS5
		local tData = {icon=icon,
			title=title,
			level=0,
			highLightObj = self,
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0), true)
	else
		local totemInfo = GDatatab_guild_totem["id_"..level]
		local property = totemInfo.property
		local title1 = level..LocalStrings.LEVEL1..LocalStrings.TIPS6
		if ProjConfig.LANGUAGE == "vn" then
			title1 = LocalStrings.LEVEL1..LocalStrings.TIPS6..level
		end
		local guildName = WndCheckOther.m_tPlayerInfo.guildName
		local position = COMMUNITY_POSITION[tonumber(WndCheckOther.m_tPlayerInfo.position)+1]
		local guildInfo = WndCheckOther.m_tGuildInfo

		local attr = {}
		local attrVal = {}
		for i=1,#property do
			attr[i] = ATTR_TITLE[property[i][1]]
			attrVal[i] = property[i][2]
		end
		icon = "ui/community/common_icon_gonghui"..level..".png"
		local tData = {icon=icon,
			title1=title1,
			guildName=guildName,
			level=level,
			position=position,
			attr1=attr[1],
			attr2=attr[2],
			attr3=attr[3],
			attrVal1=attrVal[1],
			attrVal2=attrVal[2],
			attrVal3=attrVal[3],
			highLightObj = self,
			property = totemInfo.property,
			guildInfo = guildInfo, 
			}
		WndTips:show(element,WndCheckOther.m_root,21,tData,ccp(-55,0), true)
	end 
end

--@brief	恩爱等级
function CellCheckOther01:onAttr4(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WZLog("CellCheckOther01:onTip5",WndCheckOther.m_tPlayerInfo.loveSkill)
	local level = WndCheckOther.m_tPlayerInfo.loveLevel
	local sex = WndCheckOther.m_tPlayerInfo.sex
	local mateName = WndCheckOther.m_tPlayerInfo.mateName
	local icon = "ui/common/common_icon_enai1.png"
	if tonumber(WndCheckOther.m_tPlayerInfo.marryFlag) == 0 then 
		local tData = {icon=icon,
			title=LocalStrings.TIPS7,
			level=nil,
			scale=0.5,
			px=0.2,
			py=0.5,
			highLightObj = self,
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0), true)
	elseif tonumber(WndCheckOther.m_tPlayerInfo.marryFlag) == 1 then
		local tData = {icon=icon,
			title=string.format([[<T C="158,139,121" S="20" P="0">%s</T>]],LocalStrings.BAGTIP2),
			level=nil,
			scale=0.5,
			px=0.2,
			py=0.5,
			highLightObj = self,
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0), true)
	elseif tonumber(WndCheckOther.m_tPlayerInfo.marryFlag) == 2 then
		local tBuff_id = json.decode(WndCheckOther.m_tPlayerInfo.loveSkill)
		local attrNum = 1
		local title1 = level..LocalStrings.LEVEL1..LocalStrings.LOVING_LEVEL
		if ProjConfig.LANGUAGE == "vn" then
			title1 = LocalStrings.LEVEL1..LocalStrings.LOVING_LEVEL..level
		end
		local mateInfo = {}
		local tIdList = SplitStringWithSeparator(WndCheckOther.m_tPlayerInfo.coupleMes, "|", nil, true)
		mateInfo.faceId = tIdList[1]
		mateInfo.headId = tIdList[2]
		mateInfo.headColour = tIdList[3]
		mateInfo.sex = WndCheckOther.m_tPlayerInfo.sex == 0 and 1 or 0
		mateInfo.playerId = tIdList[7]
		mateInfo.fight = tIdList[9]
		mateInfo.lv = tIdList[10]
		mateInfo.vipLevel = tIdList[11]

		local attr = {}
		local attrVal = {}
		local tProperty = {}
		for k,v in pairs(tBuff_id) do
			local buff_id = v
			local effect_id = GDatatab_buff["id_"..buff_id].effect_id
			local effect = GDatatab_effect["id_"..effect_id].effect
			for j, value in pairs(effect) do
				attr[attrNum] = ATTR_TITLE[value[5]]
				attrVal[attrNum] = value[6]
				attrNum = attrNum + 1

				local tItem = {}
				tItem[1] = value[5]
				tItem[2] = value[6]
				table.insert(tProperty, tItem)
			end
		end
		local tData = {icon=icon,
			title1=title1,
			mateName=mateName,
			attr1=attr[1],
			attr2=attr[2],
			attr3=attr[3],
			attrVal1=attrVal[1],
			attrVal2=attrVal[2],
			attrVal3=attrVal[3],
			level=level,
			scale=0.5,
			highLightObj = self,
			property = tProperty,
			mateInfo = mateInfo,
			playerId = mateInfo.playerId,
			}
		WndTips:show(element,WndCheckOther.m_root,22,tData,ccp(-45,0), true)
	end
end

--@brief	师德等级
function CellCheckOther01:onAttr5(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local quality = -1
	local title1,title2,title3 = "","",""
	local attr1,attr2,attr3,attrVal1,attrVal2,attrVal3,title,icon
	local scale = 0.5
	local property = {}

	--师傅信息
	local masterName = WndCheckOther.m_tPlayerInfo.masterName
	local masterInfo = json.decode(masterName)
	local masterLevel = WndCheckOther.m_tPlayerInfo.moralityLevel
	if masterLevel <= 0  then
		masterLevel = 1
	end

	--徒弟信息
	local pupliInfo = WndCheckOther.m_tPlayerInfo.pupliInfo
	local discipleInfo = json.decode(pupliInfo)
	local myMoralityLevel = WndCheckOther.m_tPlayerInfo.myMoralityLevel
	if myMoralityLevel <= 0  then
		myMoralityLevel = 1
	end

	local tData = {}
	--没有徒弟或师傅的时候
	if next(masterInfo) == nil and next(discipleInfo) == nil then
		tData.icon = "ui/bag/bag_icon_shitu.png"
		tData.title = LocalStrings.TIPS8
		tData.scale = 0.5
		tData.highLightObj = self
		local isSelf = nil
		local state = 1 --拜师
		local playerInfo = CacheCenter:getPlayerInfo()
		local otherInfo = WndCheckOther.m_tPlayerInfo
		if playerInfo.id ~= otherInfo.id then
			isSelf = true
			if playerInfo.level >= 35 and playerInfo.level > otherInfo.level and playerInfo.fighting > otherInfo.fighting then
				state = 2 --收徒
			end
			if state == 1 and playerInfo.masterName ~= "" and playerInfo.masterName ~= "{}" then 
				isSelf = false
			end
		end
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0), true, nil, true, {isSelf = isSelf,state = state})
	else
		if next(discipleInfo) ~= nil and next(masterInfo) ~= nil then
			local temp_info1 = GDatatab_morality["id_"..myMoralityLevel]
			local tempValue = CellRelation:getRelationName(3, myMoralityLevel)

			local data1 = {}
			data1.icon = "ui/common/common_icon_shidei.png"
			data1.title = LocalStrings.APPRENTICE
			data1.title2 = discipleInfo
			data1.title1 = ""
			data1.title3 = string.gsub(tempValue.title, "的", "")
			data1.attr1 = ATTR_TITLE[temp_info1.buff[1][1]]
			data1.attr2 = ATTR_TITLE[temp_info1.buff[2][1]]
			data1.attr3 = ATTR_TITLE[temp_info1.buff[3][1]]
			data1.attrVal1 = temp_info1.buff[1][2]
			data1.attrVal2 = temp_info1.buff[2][2]
			data1.attrVal3 = temp_info1.buff[3][2]
			data1.property = {{temp_info1.buff[1][1], data1.attrVal1},{temp_info1.buff[2][1], data1.attrVal2},{temp_info1.buff[3][1], data1.attrVal3}}
			
			local temp_info2 = GDatatab_morality["id_"..masterLevel]
			local data2 = {}
			data2.icon = "ui/common/common_icon_shidei.png"
			data2.title = LocalStrings.MASTER
			data2.title2 = masterInfo
			data2.title1 = masterLevel..LocalStrings.LEVEL1..LocalStrings.RANK_KING_DESC12
			data2.title3 = WndCheckOther.m_tPlayerInfo.guildName
			data2.attr1 = ATTR_TITLE[temp_info2.buff[1][1]]
			data2.attr2 = ATTR_TITLE[temp_info2.buff[2][1]]
			data2.attr3 = ATTR_TITLE[temp_info2.buff[3][1]]
			data2.attrVal1 = temp_info2.buff[1][2]
			data2.attrVal2 = temp_info2.buff[2][2]
			data2.attrVal3 = temp_info2.buff[3][2]
			data2.property = {{temp_info2.buff[1][1], data2.attrVal1},{temp_info2.buff[2][1], data2.attrVal2},{temp_info2.buff[3][1], data2.attrVal3}}
			WndMasterDisciple:showInterface(data1, data2)
		else
			if next(discipleInfo) ~= nil then
				local temp_info = GDatatab_morality["id_"..myMoralityLevel]
				local tempValue = CellRelation:getRelationName(3, myMoralityLevel)
				local title3 = string.gsub(tempValue.title, "的", "")
				self:setMasterDiscipleTips(element,LocalStrings.APPRENTICE, discipleInfo, "", title3, temp_info.buff)
			elseif next(masterInfo) ~= nil then
				local temp_info = GDatatab_morality["id_"..masterLevel]
				local title = masterLevel..LocalStrings.LEVEL1..LocalStrings.RANK_KING_DESC12
				self:setMasterDiscipleTips(element,LocalStrings.MASTER, masterInfo, title, WndCheckOther.m_tPlayerInfo.guildName, temp_info.pupil_buff)
			end
		end
	end
end
--个人空间显示师傅与徒弟的tip
function CellCheckOther01:setMasterDiscipleTips(element,str_name, msg_info, title, title3, info, _ccp)
	local tData = {}
	_ccp = _ccp or ccp(-145,0)
	tData.icon = "ui/common/common_icon_shidei.png"
	tData.title = str_name
	tData.title2 = msg_info
	tData.title1 = title
	tData.scale = 0.5
	tData.title3 = title3

	tData.attr1 = ATTR_TITLE[info[1][1]]
	tData.attr2 = ATTR_TITLE[info[2][1]]
	tData.attr3 = ATTR_TITLE[info[3][1]]
	tData.attrVal1 = info[1][2]
	tData.attrVal2 = info[2][2]
	tData.attrVal3 = info[3][2]
	tData.property = {{info[1][1], tData.attrVal1},{info[2][1], tData.attrVal2},{info[3][1], tData.attrVal3}}
	WndTips:show(element,WndCheckOther.m_root,23,tData, _ccp, true)
end

--@brief	幻化等级
function CellCheckOther01:onAttr6(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	local shapeId = WndCheckOther.m_tPlayerInfo.shapeId
	local shapeLevel = WndCheckOther.m_tPlayerInfo.shapeLevel
	local shapeSkillId = WndCheckOther.m_tPlayerInfo.shapeSkillId
	tData.lv = shapeLevel
	tData.id = shapeId
	tData.shapeSkillId = shapeSkillId
	if tData.lv > 0 then
		WndTips:show(element,WndCheckOther.m_root,38,tData,ccp(-60,0), true)
	else
		WndTips:show(element,WndCheckOther.m_root,39,tData,ccp(-60,0), true)
	end
end

--@brief	觉醒
function CellCheckOther01:onAttr7(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	local awakeStep = WndCheckOther.m_tPlayerInfo.awakeStep
	local awakeSoulLevel = WndCheckOther.m_tPlayerInfo.awakeSoulLevel
	local awakeSkillId = WndCheckOther.m_tPlayerInfo.awakeSkillId
	tData.awakeStep = awakeStep
	tData.awakeSoulLevel = awakeSoulLevel
	tData.awakeSkillId = awakeSkillId
	if awakeStep <= 0 then
		local tData = {
			icon="ui/common/common_icon_juexing.png",
			title=LocalStrings.TIPS11,
			level=nil,
			scale=0.5,
			px=0.2,
			py=0.5,
			highLightObj = self,
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0), true)
	else
		if tData.awakeStep >= 4 then
			WndTips:show(element,WndCheckOther.m_root,40,tData,ccp(-60,180), true)
		else
			WndTips:show(element,WndCheckOther.m_root,40,tData,ccp(-60,0), true)
		end
	end
end

--@brief	家园
function CellCheckOther01:onAttr8(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	local homeLevel = WndCheckOther.m_tPlayerInfo.homeLevel
	local sheerLuxury = WndCheckOther.m_tPlayerInfo.sheerLuxury
	tData.homeLevel = homeLevel
	tData.sheerLuxury = sheerLuxury

	if homeLevel <= 0 then
		local tData = {
			icon="ui/bag/common_icon_hzfamily.png",
			title=LocalStrings.FAMILYSHOP12,
			level=nil,
			scale=1,
			px=0.2,
			py=0.5,
			highLightObj = self,
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0), true)
	else
		WndTips:show(element,WndCheckOther.m_root,44,tData,ccp(-60,0), true)
	end
end

--@brief	排位印记
function CellCheckOther01:onAttr9(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local initProperty = CacheCenter:getGameParam().initialAttribute
	local addProperty = CacheCenter:getGameParam().increaseAttribute
	WZLog("CellCheckOther01:onAttr9", initProperty, addProperty)
	local id, num = SplitItemString(initProperty)
	local idAdd, numAdd = SplitItemString(addProperty)
	local tProperty = {}
	for i = 1, #id do
		local tItem = {}
		tItem[1] = tonumber(id[i])
		tItem[2] = tonumber(num[i])

		table.insert(tProperty, tItem)
	end

	local obtainNum = WndCheckOther.m_tPlayerInfo.obtainNum
	if obtainNum > 0 then
		for i = 1, #tProperty do
			for j = 1, #idAdd do
				if tProperty[i][1] == tonumber(idAdd[j]) then
					tProperty[i][2] = tProperty[i][2] + (obtainNum) * tonumber(numAdd[j])
					break 
				end
			end
		end
	end
	local tData = {}
	tData.level = obtainNum
	tData.name = LocalStrings.PVPNEW_TEXT4
	tData.property = tProperty

	
	WndTips:show(element,WndCheckOther.m_root,48,tData,ccp(-60,0), true)
end

--@brief 	点击卡牌徽章回调
function CellCheckOther01:onAttr10(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tCardData = json.decode(WndCheckOther.m_tPlayerInfo.cardMessage)
	WZLog("CellCheckOther01:onAttr10", WndCheckOther.m_tPlayerInfo.cardMessage)
	local tData = {}
	tData.cardNum = {{4,0},{3,0},{2,0},{1,0}}
	tData.property = {}
	local array = SplitStringWithSeparator(tCardData.qAn, ",")
	for i = 1, #array do
		local id = SplitStringWithSeparator(array[i], "|")[1]
		local num = SplitStringWithSeparator(array[i], "|")[2]
		for j = 1, #tData.cardNum do
			if tData.cardNum[j][1] == tonumber(id) then
				tData.cardNum[j][2] = tonumber(num)
				break 
			end
		end
	end

	local sProperty = SplitStringWithSeparator(tCardData.pstr, ",")
	for i = 1, #sProperty do
		local id = SplitStringWithSeparator(sProperty[i], "|")[1]
		local num = SplitStringWithSeparator(sProperty[i], "|")[2]
		local tItem = {}
		tItem[1] = tonumber(id)
		tItem[2] = tonumber(num)

		table.insert(tData.property, tItem)
	end

	table.sort(tData.property, function (a,b)
		-- body
		return a[1] < b[1]
	end)

	tData.collectNum = tCardData.num
	tData.dataType = 1
	tData.level = tCardData.level
	WndTips:show(element, WndCheckOther.m_root, 49, tData, ccp(-60,0), true)
end

--@brief 	点击孩子徽章回调
function CellCheckOther01:onAttr11(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tKidData = json.decode(WndCheckOther.m_tPlayerInfo.childMes)
	local tData = {}
	tData.kidData = tKidData
	tData.property = json.decode(WndCheckOther.m_tPlayerInfo.careBuffProp)
	tData.careToday = WndCheckOther.m_tPlayerInfo.careToday
	WZLog("CellCheckOther01:onAttr11", Serialize(tData.property))
	table.sort(tData.property, function (a,b)
		-- body
		return a[1] < b[1]
	end)

	WndTips:show(element, WndCheckOther.m_root, 50, tData, ccp(-20,20), true)
end

--@brief 	点击成就徽章回调
function CellCheckOther01:onAttr12(element)
	--body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = {}
	tData.property = {}
	tData.level = 0 
	local tProperty = json.decode(WndCheckOther.m_tPlayerInfo.badgeInfo)
	if tProperty then 
		for i, v in pairs(tProperty) do
			local tItem = {}
			local tBasicData = WndDesignationMain:_getLevelTableInfo(tonumber(i), v)
			tItem[1] = tonumber(i)
			if tonumber(i) ~= 1 then 
				tItem[1] = tonumber(i) + 1
			end
			tItem[2] = tBasicData.add_attribute

			table.insert(tData.property, tItem)

			tData.level = tData.level + v
		end
	end

	table.sort(tData.property, function (a,b)
		-- body
		return a[1] < b[1]
	end)
	WndTips:show(element, WndCheckOther.m_root, 53, tData, GlobalMethod:ccp(30,-10), true)
end

--@brief 	点击宠物徽章回调
function CellCheckOther01:onAttr13(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local petMessage = WndCheckOther.m_tPlayerInfo.petMessage
	if petMessage ~= nil and petMessage ~= "" then
		petMessage = json.decode(petMessage)
		petMessage.tEquip = WndCheckOther.m_tPlayerInfo.petEquip
		WndTips:show(element, WndCheckOther.m_root, 13, petMessage, GlobalMethod:ccp(30,-10), true)
	end
end

--@brief	恩爱等级
function CellCheckOther01:onAttr14(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local attrNum = 1
	local wedBufLevel = WndCheckOther.m_tPlayerInfo.wedBufLevel
	local wedBufTime = WndCheckOther.m_tPlayerInfo.wedBufTime
	local tWedBuff = GDatatab_wed_buf["id_"..wedBufLevel]

	local attr = {}
	local attrVal = {}
	local tProperty = {}
	for k,v in pairs(tWedBuff.property) do
		attr[attrNum] = ATTR_TITLE[v[1]]
		attrVal[attrNum] = v[2]
		attrNum = attrNum + 1

		local tItem = {}
		tItem[1] = v[1]
		tItem[2] = v[2]
		table.insert(tProperty, tItem)
	end
	local tData = {
			wedBufLevel=wedBufLevel,
			wedBufTime=wedBufTime,
			attr1=attr[1],
			attr2=attr[2],
			attr3=attr[3],
			attrVal1=attrVal[1],
			attrVal2=attrVal[2],
			attrVal3=attrVal[3],
			property = tProperty,
		}
	WndTips:show(element,WndCheckOther.m_root,66,tData,ccp(0,0), true)
end

--@brief 	职业勋章
function CellCheckOther01:onAttr15(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndTips:show(element,WndCheckOther.m_root,68,{},ccp(-160,120),true)
end

--@brief 	点击祈福勋章回调
function CellCheckOther01:onAttr16(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tPrayData = json.decode(WndCheckOther.m_tPlayerInfo.prayInfo)
	local tData = {}
	tData.cardNum = {{4,0},{3,0},{2,0},{1,0}}
	local totalLevel = 0
	for i, value in pairs(tPrayData.level) do
		totalLevel = totalLevel + value
		for j = 1, #tData.cardNum do
			if tonumber(i) == tData.cardNum[j][1] then 
				tData.cardNum[j][2] = value
				break 
			end
		end
	end

	tData.property = {}
	for i, value in pairs(tPrayData.property) do
		local tItem = {}
		tItem[1] = tonumber(i)
		tItem[2] = value

		table.insert(tData.property, tItem)
	end

	table.sort(tData.property, function (a,b)
		-- body
		return a[1] < b[1]
	end)
	tData.dataType = 2
	tData.level = totalLevel
	WndTips:show(element, WndCheckOther.m_root, 49, tData, ccp(-60,100), true)
end

--@brief 	点击丹道修真勋章回调
function CellCheckOther01:onAttr17(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local itemId = self.m_tTypeList[self.m_nBtnTag][2]
	local tBasicData = GDatatab_item["id_" .. itemId]
	local tData = {}
	tData.itemId = itemId
	tData.name = tBasicData.name
	tData.desc = tBasicData.desc
	tData.icon = tBasicData.icon
	local nNum = self.m_tTypeList[self.m_nBtnTag][3]
	local totalLevel = 0
	local property = {}
	if GDatatab_activity_medal then 
		for i, value in pairs(GDatatab_activity_medal) do
			if value.item_id == itemId and value.lv <= nNum and value.lv > totalLevel then 
				totalLevel = value.lv
				property = value.property
			end
		end
	end

	tData.property = property
	tData.level = totalLevel
	WndTips:show(element, WndCheckOther.m_root, 79, tData, ccp(30,100), true)
end

--@brief	符文共振
function CellCheckOther01:onAttr18(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	tData.value = WndCheckOther.m_tPlayerInfo.runeResonateAdd
	
	WndTips:show(element,WndCheckOther.m_root,84,tData,ccp(0,0), true)
end

--@brief	卡魂瞻仰
function CellCheckOther01:onAttr19(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	tData.value = WndCheckOther.m_tPlayerInfo.cardSoulBuffAdd
	
	WndTips:show(element,WndCheckOther.m_root,85,tData,ccp(0,0), true)
end

--@brief	图腾洗礼
function CellCheckOther01:onAttr20(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	tData.value = WndCheckOther.m_tPlayerInfo.guildBaptismAdd
	tData.level = WndCheckOther.m_tPlayerInfo.totemLevel
	
	WndTips:show(element,WndCheckOther.m_root,86,tData,ccp(0,0), true)
end

--@brief	战略赛2v2
function CellCheckOther01:onAttr21(element)
	WZLog("CellCheckOther01:onAttr21")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local zlsInfo = WndCheckOther.m_tPlayerInfo.zlsJsonInfo
	local level = zlsInfo.level2V2
	if level == 0 then
		local title = LocalStrings.PVP_STRATEGIC_TEXT4[1]
		local tData = {
				title=title,
				showType = 2,
				animation = "ui/otherUI/icon_cbqt_01",
				icon = "ui/common/common_icon_clz_01.png",
				icon = "ui/common/common_icon_clz_01.png",
				action = "wait_1",
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0), true)
	else
		local tData = {}
		tData.pvpmode = 2
		tData.level = zlsInfo.level2V2
		tData.score = zlsInfo.score2V2
		tData.joinNum = zlsInfo.joinNum2V2
		tData.winNum = zlsInfo.winNum2V2
    	WndTips:show(element,WndCheckOther.m_root,89,tData,nil,true)
	end
end

--@brief	战略赛3v3
function CellCheckOther01:onAttr22(element)
	WZLog("CellCheckOther01:onAttr22")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local zlsInfo = WndCheckOther.m_tPlayerInfo.zlsJsonInfo
	local level = zlsInfo.level3V3
	if level == 0 then
		local title = LocalStrings.PVP_STRATEGIC_TEXT4[2]
		local tData = {
				title=title,
				showType = 2,
				animation = "ui/otherUI/icon_cbqt_01",
				icon = "ui/common/common_icon_clz_01.png",
				icon = "ui/common/common_icon_clz_01.png",
				action = "wait_1",
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0), true)
	else
		local tData = {}
		tData.pvpmode = 3
		tData.level = zlsInfo.level3V3
		tData.score = zlsInfo.score3V3
		tData.joinNum = zlsInfo.joinNum3V3
		tData.winNum = zlsInfo.winNum3V3
    	WndTips:show(element,WndCheckOther.m_root,89,tData,nil,true)
	end
end

--@brief 	点击图标回调
function CellCheckOther01:onClickIcon(element)
	-- body
	local nTag = element:getTag()
	self.m_nBtnTag = nTag

	if type(self.m_tTypeList[nTag]) == "table" then 
		local nTypeTemp = self.m_tTypeList[nTag][1]
		if nTypeTemp == 17 then --丹道修真勋章
			self:onAttr17(element)
		end
	else
		if self.m_tTypeList[nTag] == 0 then --竞技
			self:onAttr0(element)
		elseif self.m_tTypeList[nTag] == 1 then --娱乐赛
			self:onAttr1(element)
		elseif self.m_tTypeList[nTag] == 2 then --排位
			self:onAttr2(element)
		elseif self.m_tTypeList[nTag] == 3 then --排位印记
			self:onAttr9(element)
		elseif self.m_tTypeList[nTag] == 4 then --公会图标
			self:onAttr3(element)
		elseif self.m_tTypeList[nTag] == 5 then --恩爱图标
			self:onAttr4(element)
		elseif self.m_tTypeList[nTag] == 6 then --师德图标
			self:onAttr5(element)
		elseif self.m_tTypeList[nTag] == 7 then --幻化图标
			self:onAttr6(element)
		elseif self.m_tTypeList[nTag] == 8 then --觉醒图标
			self:onAttr7(element)
		elseif self.m_tTypeList[nTag] == 9 then --家园图标
			self:onAttr8(element)
		elseif self.m_tTypeList[nTag] == 10 then --卡牌图标
			self:onAttr10(element)
		elseif self.m_tTypeList[nTag] == 11 then --孩子
			self:onAttr11(element)
		elseif self.m_tTypeList[nTag] == 12 then --成就
			self:onAttr12(element)
		elseif self.m_tTypeList[nTag] == 13 then --宠物
			self:onAttr13(element)
		elseif self.m_tTypeList[nTag] == 14 then --婚礼buff
			self:onAttr14(element)
		elseif self.m_tTypeList[nTag] == 15 then --职业
			self:onAttr15(element)
		elseif self.m_tTypeList[nTag] == 16 then --祈福
			self:onAttr16(element)
		elseif self.m_tTypeList[nTag] == 18 then --符文共振
			self:onAttr18(element)
		elseif self.m_tTypeList[nTag] == 19 then --卡魂瞻仰
			self:onAttr19(element)
		elseif self.m_tTypeList[nTag] == 20 then --图腾洗礼
			self:onAttr20(element)
		elseif self.m_tTypeList[nTag] == 21 then --战略赛2v2
			self:onAttr21(element)
		elseif self.m_tTypeList[nTag] == 22 then --战略赛3v3
			self:onAttr22(element)
		end
	end
end

--@brief 	标题
function CellCheckOther01:addTitle()
	-- body
	if self.m_sTitle == nil then return end 
	if self.m_root == nil then return end 

	local conForTitle = GetElement(self.m_root, "conForTitle_CellCheckOther01", WZUIContainer)
	local celElement,tCell = CellCheckOther8:createElement()
	if celElement ~= nil and tCell ~= nil then 
		celElement = WZUIContainer:luaTo(celElement)
		tCell:setTitle(self.m_sTitle, self.m_nRowNum)

		conForTitle:addChild(celElement)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新Cell
function CellCheckOther01:update(tData)
	if tData == nil then return end
	self:addTitle()
	--不到8级隐藏所有图标
	if WndCheckOther.m_tPlayerInfo.level < 8 then
		return
	end

	--设置竞技图标
	WZLog("CellCheckOther01:update", Serialize(self.m_tTypeList), WndCheckOther.m_tPlayerInfo.tournamentLevel)
	for i = 1, #self.m_tTypeList do
		local btnImg1 = GetElement(self.m_root,"btn" .. i .. "img1",WZUIImage)
		local btnImg2 = GetElement(self.m_root,"btn" .. i .. "img2",WZUIImage)
		if type(self.m_tTypeList[i]) == "table" then 
			local nTypeTemp = self.m_tTypeList[i][1]
			self.m_tMedalInfo = {}
			self.m_tMedalInfo[1] = self.m_tTypeList[i][2]
			self.m_tMedalInfo[2] = self.m_tTypeList[i][3]

			--设置丹道修真勋章
			if nTypeTemp == 17 then
				local itemId = self.m_tMedalInfo[1]
				local tItemData = GDatatab_item["id_" .. itemId]
				GetElement(self.m_root,"btn" .. i,WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"btn" .. i,WZUIButton):setVisible(true)
				btnImg1:setFile(tItemData.icon)
				btnImg1:setScale(0.6)
				btnImg2:setFile(tItemData.icon)
				btnImg2:setScale(0.6)
				local nNum = self.m_tMedalInfo[2] 
				local nTotalLevel = 0
				if GDatatab_activity_medal then 
					for k, value in pairs(GDatatab_activity_medal) do
						if value.item_id == itemId and value.lv <= nNum and value.lv > nTotalLevel then 
							nTotalLevel = value.lv
						end
					end
				end
				if nTotalLevel > 0 then
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV .. nTotalLevel)
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				else
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(false)
				end
			end
		else
			if self.m_tTypeList[i] == 0 then
				local hallInfo = GDatatab_integral["id_"..WndCheckOther.m_tPlayerInfo.tournamentLevel]
				local displayLv = WndCheckOther.m_tPlayerInfo.tournamentLevel--%10
				if displayLv == 0 then displayLv = 10 end
				if displayLv ~= nil then
					btnImg1:setFile("ui/common/"..hallInfo.iocn..".png")
					btnImg2:setFile("ui/common/"..hallInfo.iocn..".png")
				end
				GetElement(self.m_root, "btn" .. i, WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..displayLv)
			end
			if self.m_tTypeList[i] == 1 then
				if WndCheckOther.m_tPlayerInfo.ylJsonInfo and string.sub(WndCheckOther.m_tPlayerInfo.ylJsonInfo,1,1) == "{" then
					local tempData = json.decode(WndCheckOther.m_tPlayerInfo.ylJsonInfo)
					if tempData then
						local hallInfo = GDatatab_entertainment_level["id_"..tempData.level]
						local displayLv = tempData.level
						if displayLv ~= nil then
							btnImg1:setFile("ui/common/"..hallInfo.iocn..".png")
							btnImg2:setFile("ui/common/"..hallInfo.iocn..".png")
						end
						GetElement(self.m_root, "btn" .. i, WZUIButton):setTouchEnable(true)
						GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
						GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..displayLv)
					end
				end
			end
			--设置排位图标
			if self.m_tTypeList[i] == 2 then
				local btn2 = GetElement(self.m_root, "btn" .. i, WZUIButton)
				btn2:setTouchEnable(true)
				-- local tTempData = GetPvpDataByLevel(WndCheckOther.m_tPlayerInfo.segmentId)
				-- if btn2 then
			 --        local celElement, tNewObj = CellPvpLevelIcon:createElement()
			 --        if celElement and tNewObj then
			 --            tNewObj:setData(tTempData, false, 0.38, false)
			 --            celElement:setScale(0.38)
			 --            btn2:addChild(celElement)
			 --        end
			 --    end
				WZLog("sdgsdfjl",WndCheckOther.m_tPlayerInfo.segmentId)
				if tonumber(WndCheckOther.m_tPlayerInfo.segmentId) >= 0 then
		    		local info = GDatatab_trio_rank_match_config["id_" .. WndCheckOther.m_tPlayerInfo.segmentId]
					for k,v in pairs(GDatatab_trio_rank_match_config) do
						if v.level3 == WndCheckOther.m_tPlayerInfo.segmentId then
							info = v
						end
					end
					if WndCheckOther.m_tPlayerInfo.segmentId > 106 then
						info = GDatatab_trio_rank_match_config["id_999"]
					end
					btnImg1:setScale(0.32)
					btnImg2:setScale(0.32)
					btnImg1:setFile("ui/common/"..info.icon..".png")
					btnImg2:setFile("ui/common/"..info.icon..".png")

					local spinePath = "icon_qingtong_01"
					if info.icon == "common_icon_pws1" then
						spinePath = "icon_qingtong_01"
					elseif info.icon == "common_icon_pws2" then
						spinePath = "icon_baiyin_01"
					elseif info.icon == "common_icon_pws3" then
						spinePath = "icon_huangjin_01"
					elseif info.icon == "common_icon_pws4" then
						spinePath = "icon_baijin_01"
					elseif info.icon == "common_icon_pws5" then
						spinePath = "icon_zuanshi_01"
					elseif info.icon == "common_icon_pws6" then
						spinePath = "icon_rongyao_01"
					end
					local spinePath1 = "ui/otherUI/" .. spinePath
				    local existSpine = CheckEffectFile(spinePath1)
				    if existSpine then 	
						btnImg1:setFile("")
						btnImg2:setFile("")
						local spineIcon = WZUISpine:create()
						spineIcon:setTouchEnable(false)
						spineIcon:setFileJson(spinePath1 .. ".json")
						spineIcon:setFileAtlas(spinePath1 .. ".atlas")
						spineIcon:setUseOriginSize(true)
						spineIcon:play("wait_1",true)
						btnImg1:addChild(spineIcon)
						local spineIcon = WZUISpine:create()
						spineIcon:setTouchEnable(false)
						spineIcon:setFileJson(spinePath1 .. ".json")
						spineIcon:setFileAtlas(spinePath1 .. ".atlas")
						spineIcon:setUseOriginSize(true)
						spineIcon:play("wait_1",true)
						btnImg2:addChild(spineIcon)
					end

		    		GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..info.level3)
		    		GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				end
			end
			--排位印记
			if self.m_tTypeList[i] == 3 then
				local btn2 = GetElement(self.m_root,"btn" .. i,WZUIButton)
				btn2:setTouchEnable(true)
				btn2:setVisible(true)
				GetElement(self.m_root, "numIcon" .. i .. "_CellCheckOther01", WZUILabelTTF):setVisible(false)

				btnImg1:setFile("ui/pvp/common_icon_ry.png")
				btnImg2:setFile("ui/pvp/common_icon_ry.png")

				if WndCheckOther.m_tPlayerInfo.obtainNum > 0 then
					GetElement(self.m_root, "atlasNumIcon" .. i .. "_CellCheckOther01", WZUILabelAtlasFont):setVisible(true)
					GetElement(self.m_root, "imgAsk" .. i .. "_CellCheckOther01", WZUIImage):setVisible(false)
					GetElement(self.m_root, "atlasNumIcon" .. i .. "_CellCheckOther01", WZUILabelAtlasFont):setText(WndCheckOther.m_tPlayerInfo.obtainNum)
				else
					GetElement(self.m_root, "atlasNumIcon" .. i .. "_CellCheckOther01", WZUILabelAtlasFont):setVisible(false)
					GetElement(self.m_root, "imgAsk" .. i .. "_CellCheckOther01", WZUIImage):setVisible(true)
				end
			end
			--设置公会图标
			if self.m_tTypeList[i] == 4 then
				local level = WndCheckOther.m_tPlayerInfo.totemLevel
				GetElement(self.m_root,"btn" .. i, WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..level)
				btnImg1:setFile("ui/community/common_icon_gonghui"..level..".png")
				btnImg2:setFile("ui/community/common_icon_gonghui"..level..".png")
				btnImg1:setScale(0.5)
				btnImg2:setScale(0.5)
				
				if tonumber(level) > 10 then
					btnImg1:setScale(0.4)
					btnImg2:setScale(0.4)
				end
			end
			--设置恩爱图标
			if self.m_tTypeList[i] == 5 then
				local btnTemp = GetElement(self.m_root,"btn" .. i, WZUIButton)
				btnTemp:setTouchEnable(true)
				btnImg1:setFile("ui/checkother/common_icon_banlv.png")
				btnImg2:setFile("ui/checkother/common_icon_banlv.png")
				btnImg1:setScale(0.75)
				btnImg2:setScale(0.75)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.loveLevel)
				if WndCheckOther.m_tPlayerInfo.coupleMes and WndCheckOther.m_tPlayerInfo.coupleMes ~= "" then 
					local tIdList = SplitStringWithSeparator(WndCheckOther.m_tPlayerInfo.coupleMes, "|", nil, true)
					local mateSex = WndCheckOther.m_tPlayerInfo.sex == 0 and 1 or 0
					local cellElement =  CellHead:show(btnTemp, tIdList[2], tIdList[1], mateSex, nil, nil, nil, tIdList[3])
				end
			end
			--设置师德图标
			if self.m_tTypeList[i] == 6 then
				GetElement(self.m_root,"btn" .. i, WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.myMoralityLevel)
				btnImg1:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
				btnImg2:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
				if tonumber(WndCheckOther.m_tPlayerInfo.moralityLevel) == 0 then
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText("")
				end
				btnImg1:setFile("ui/bag/bag_icon_shitu.png")
				btnImg2:setFile("ui/bag/bag_icon_shitu.png")
				btnImg1:setScale(0.5)
				btnImg2:setScale(0.5)
				if tonumber(WndCheckOther.m_tPlayerInfo.level) < MASTERLEVEL then
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(false)
					btnImg1:setRelativePosition(GlobalMethod:ccp(0.5,0.55))
					btnImg2:setRelativePosition(GlobalMethod:ccp(0.5,0.55))
				end
			end
			--设置幻化图标
			if self.m_tTypeList[i] == 7 then
				GetElement(self.m_root,"btn" .. i, WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.shapeLevel)
				btnImg1:setFile("ui/common/common_icon_huanli.png")
				btnImg2:setFile("ui/common/common_icon_huanli.png")
				btnImg1:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
				btnImg2:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
				btnImg1:setScale(0.5)
				btnImg2:setScale(0.5)
			end
			--设置觉醒勋章
			if self.m_tTypeList[i] == 8 then
				GetElement(self.m_root,"btn" .. i, WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"btn" .. i, WZUIButton):setVisible(true)
				btnImg1:setFile("ui/common/common_icon_juexing.png")
				btnImg2:setFile("ui/common/common_icon_juexing.png")
				btnImg1:setScale(0.5)
				btnImg2:setScale(0.5)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.awakeStep)
			end
			--设置家园勋章
			if self.m_tTypeList[i] == 9 then
				WZLog("显示家园勋章")
				GetElement(self.m_root,"btn" .. i, WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"btn" .. i, WZUIButton):setVisible(true)
				btnImg1:setFile("ui/bag/common_icon_hzfamily.png")
				btnImg2:setFile("ui/bag/common_icon_hzfamily.png")
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.homeLevel)
			end
			--设置卡牌勋章
			if self.m_tTypeList[i] == 10 then
				local tCardData = json.decode(WndCheckOther.m_tPlayerInfo.cardMessage)
				GetElement(self.m_root,"btn" .. i,WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"btn" .. i,WZUIButton):setVisible(true)
				btnImg1:setFile("ui/bag/common_icon_kapai2.png")
				btnImg2:setFile("ui/bag/common_icon_kapai2.png")
				btnImg1:setScale(0.5)
				btnImg2:setScale(0.5)
				if tCardData.level > 0 then
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV .. tCardData.level)
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				else
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(false)
				end
			end
			--设置孩子徽章
			if self.m_tTypeList[i] == 11 then
				GetElement(self.m_root,"btn" .. i,WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"btn" .. i,WZUIButton):setVisible(true)
				btnImg1:setFile("ui/checkother/icon_baby.png")
				btnImg2:setFile("ui/checkother/icon_baby.png")
				btnImg1:setScale(0.7)
				btnImg2:setScale(0.7)
				
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(false)
			end
			--设置成就徽章
			if self.m_tTypeList[i] == 12 then
				GetElement(self.m_root,"btn" .. i,WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"btn" .. i,WZUIButton):setVisible(true)
				btnImg1:setFile("ui/achievement/common_icon_cjsmhz.png")
				btnImg2:setFile("ui/achievement/common_icon_cjsmhz.png")
				btnImg1:setScale(0.42)
				btnImg2:setScale(0.42)
				
				local tProperty = json.decode(WndCheckOther.m_tPlayerInfo.badgeInfo)
				local nTempLevel = 0 
				if tProperty then 
					for i, v in pairs(tProperty) do
						nTempLevel = nTempLevel + v
					end
				end
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV .. nTempLevel)
			end
			--设置宠物徽章
			if self.m_tTypeList[i] == 13 then
				local btnPet = GetElement(self.m_root, "btn" .. i, WZUIButton)
				btnPet:setTouchEnable(true)
				btnPet:setVisible(true)
				btnImg1:setFile(WndCheckOther.m_tPlayerInfo.petInfo.icon)
				btnImg2:setFile(WndCheckOther.m_tPlayerInfo.petInfo.icon)
				btnImg1:setScale(0.85)
				btnImg2:setScale(0.85)
				
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV .. WndCheckOther.m_tPlayerInfo.petInfo.upgradeLevel)
			end
			--设置婚礼buff
			if self.m_tTypeList[i] == 14 then
				GetElement(self.m_root,"btn" .. i, WZUIButton):setTouchEnable(true)
				btnImg1:setFile("ui/common/common_icon_hunyan.png")
				btnImg2:setFile("ui/common/common_icon_hunyan.png")
				btnImg1:setScale(0.6)
				btnImg2:setScale(0.6)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.wedBufLevel)
			end
			--设置职业勋章
			if self.m_tTypeList[i] == 15 then
				GetElement(self.m_root,"btn"..i,WZUIButton):setTouchEnable(true)
				if WndCheckOther.m_tPlayerInfo.professionAttr2 == "{}" then
					btnImg1:setFile(g_professionIcon[WndCheckOther.m_tPlayerInfo.professionId])
					btnImg2:setFile(g_professionIcon[WndCheckOther.m_tPlayerInfo.professionId])
				else 
					btnImg1:setFile(g_professionIcon2[WndCheckOther.m_tPlayerInfo.professionId])
					btnImg2:setFile(g_professionIcon2[WndCheckOther.m_tPlayerInfo.professionId])
				end
				btnImg1:setScale(0.6)
				btnImg2:setScale(0.6)			
			end
			--设置祈福勋章
			if self.m_tTypeList[i] == 16 then
				local tPrayData = json.decode(WndCheckOther.m_tPlayerInfo.prayInfo)
				GetElement(self.m_root,"btn" .. i,WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"btn" .. i,WZUIButton):setVisible(true)
				btnImg1:setFile("ui/common/common_icon_qfxz.png")
				btnImg2:setFile("ui/common/common_icon_qfxz.png")
				local nTotalLevel = 0 
				for i, value in pairs(tPrayData.level) do
					nTotalLevel = nTotalLevel + value
				end
				if nTotalLevel > 0 then
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV .. nTotalLevel)
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				else
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(false)
				end
			end
			--设置符文共振
			if self.m_tTypeList[i] == 18 then
				GetElement(self.m_root,"btn" .. i, WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"btn" .. i, WZUIButton):setVisible(true)
				btnImg1:setFile("ui/common/xz_icon_fuwen.png")
				btnImg2:setFile("ui/common/xz_icon_fuwen.png")
			end
			--设置卡魂瞻仰
			if self.m_tTypeList[i] == 19 then
				GetElement(self.m_root,"btn" .. i, WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"btn" .. i, WZUIButton):setVisible(true)
				btnImg1:setFile("ui/common/xz_icon_kh.png")
				btnImg2:setFile("ui/common/xz_icon_kh.png")
			end
			--设置图腾洗礼
			if self.m_tTypeList[i] == 20 then
				GetElement(self.m_root,"btn" .. i, WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"btn" .. i, WZUIButton):setVisible(true)
				btnImg1:setFile("ui/common/xz_icon_ttxl.png")
				btnImg2:setFile("ui/common/xz_icon_ttxl.png")
			end

			--战略赛2v2
			if self.m_tTypeList[i] == 21 then
				local btn2 = GetElement(self.m_root, "btn" .. i, WZUIButton)
				btn2:setTouchEnable(true)
				if WndCheckOther.m_tPlayerInfo.zlsJsonInfo ~= "" then
					local level = WndCheckOther.m_tPlayerInfo.zlsJsonInfo.level2V2
					local score = WndCheckOther.m_tPlayerInfo.zlsJsonInfo.score2V2
					local joinNum = WndCheckOther.m_tPlayerInfo.zlsJsonInfo.joinNum2V2
					local winNum = WndCheckOther.m_tPlayerInfo.zlsJsonInfo.winNum2V2
					local tLeveInfo = GetZlsPvpDataByLevel(level)

					local spinePath = "ui/otherUI/" .. tLeveInfo.animation
				    local existSpine = CheckEffectFile(spinePath)
				    if existSpine then 
				    	btnImg1:setScale(0.32)
						btnImg2:setScale(0.32)
						btnImg1:setFile("")
						btnImg2:setFile("")
						
						local spineIcon = WZUISpine:create()
						spineIcon:setTouchEnable(false)
						spineIcon:setUseOriginSize(true)
						spineIcon:setFileJson(spinePath .. ".json")
						spineIcon:setFileAtlas(spinePath .. ".atlas")
						spineIcon:play(tLeveInfo.action,true)
						btnImg1:addChild(spineIcon)
						local spineIcon = WZUISpine:create()
						spineIcon:setTouchEnable(false)
						spineIcon:setUseOriginSize(true)
						spineIcon:setFileJson(spinePath .. ".json")
						spineIcon:setFileAtlas(spinePath .. ".atlas")
						spineIcon:play(tLeveInfo.action,true)
						btnImg2:addChild(spineIcon)
					else
						btnImg1:setScale(0.25)
						btnImg2:setScale(0.25)
						btnImg1:setFile("ui/common/"..tLeveInfo.icon..".png")
						btnImg2:setFile("ui/common/"..tLeveInfo.icon..".png")
					end

					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..level)
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				end
			end
			--战略赛3v3
			if self.m_tTypeList[i] == 22 then
				local btn2 = GetElement(self.m_root, "btn" .. i, WZUIButton)
				btn2:setTouchEnable(true)
				if WndCheckOther.m_tPlayerInfo.zlsJsonInfo ~= "" then
					local level = WndCheckOther.m_tPlayerInfo.zlsJsonInfo.level3V3
					local score = WndCheckOther.m_tPlayerInfo.zlsJsonInfo.score3V3
					local joinNum = WndCheckOther.m_tPlayerInfo.zlsJsonInfo.joinNum3V3
					local winNum = WndCheckOther.m_tPlayerInfo.zlsJsonInfo.winNum3V3
					local tLeveInfo = GetZlsPvpDataByLevel(level)

					local spinePath = "ui/otherUI/" .. tLeveInfo.animation
				    local existSpine = CheckEffectFile(spinePath)
				    if existSpine then 
				    	btnImg1:setScale(0.32)
						btnImg2:setScale(0.32)
						btnImg1:setFile("")
						btnImg2:setFile("")
		
						local spineIcon = WZUISpine:create()
						spineIcon:setTouchEnable(false)
						spineIcon:setUseOriginSize(true)
						spineIcon:setFileJson(spinePath .. ".json")
						spineIcon:setFileAtlas(spinePath .. ".atlas")
						spineIcon:play(tLeveInfo.action,true)
						btnImg1:addChild(spineIcon)
						local spineIcon = WZUISpine:create()
						spineIcon:setTouchEnable(false)
						spineIcon:setUseOriginSize(true)
						spineIcon:setFileJson(spinePath .. ".json")
						spineIcon:setFileAtlas(spinePath .. ".atlas")
						spineIcon:play(tLeveInfo.action,true)
						btnImg2:addChild(spineIcon)
					else
						btnImg1:setScale(0.25)
						btnImg2:setScale(0.25)
						btnImg1:setFile("ui/common/"..tLeveInfo.icon..".png")
						btnImg2:setFile("ui/common/"..tLeveInfo.icon..".png")
					end

					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..level)
					GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
				end
			end

		end
	end
end

-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function CellCheckOther01:_adaptLanguage_vn(  )
	
end

---------------------------------------语言适配End------------------------------------------
