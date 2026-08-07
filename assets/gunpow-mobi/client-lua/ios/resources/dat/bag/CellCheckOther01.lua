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
	WndTips:show(element,WndCheckOther.m_root,2,tData,GlobalMethod:ccp(192,-122))
	GetElement(WndTips.m_root,"bgType2_WndTips",WZUI9Image):setContentSize(GlobalMethod:CCSize(150,435))
	GetElement(WndTips.m_root,"bgType2_WndTips",WZUI9Image):setRelativePosition(ccp(-0.1,0.51))
end

--@brief	竞技   tip
function CellCheckOther01:onAttr1(element)
	WZLog("CellCheckOther01:onTip2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local tData = WndCheckOther.m_tPlayerInfo
	local playNum = tData.playNum
	tData.highLightObj = self
	if playNum == 0 and tData.level < 8 then
		local title = LocalStrings.TIPS3
		local tData = {icon="ui/common/common_icon_hz3.png",
			title=title,
			level=1,
			px=0.2,
			py=0.5,
			highLightObj = self,
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0))
	else
		WndTips:show(element,WndCheckOther.m_root,4,tData,GlobalMethod:ccp(25,10))
	end
end

--@brief	排位等级
function CellCheckOther01:onAttr2(element)
	WZLog("CellCheckOther01:onTip3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local level = WndCheckOther.m_tPlayerInfo.segmentId
	if tonumber(level) == 0 then
		local title = LocalStrings.TIPS4
		local tData = {icon="ui/common/common_icon_pws1.png",
			title=title,
			level=level,
			px=0.2,
			py=0.5,
			highLightObj = self,
			pvprankMark = 1,
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0))
	else
    	local info = json.decode(WndCheckOther.m_tPlayerInfo.rankMatchMessage)
    	WZLog("CellCheckOther01:onTip3", Serialize(info))
    	local data = {level = tonumber(info.level), winNum = info.winTimes,total = info.joinTimes,maxWinNum = info.continous,exp=tonumber(info.exp)}
    	WndTips:show(element,WndCheckOther.m_root,17,data,GlobalMethod:ccp(36,-5))
	end
end

--@brief	图腾等级
function CellCheckOther01:onAttr3(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local level = WndCheckOther.m_tPlayerInfo.totemLevel
	WZLog("CellCheckOther01:onTip4",level)
	local title
	local icon = "ui/common/common_icon_gonghui.png"
	if tostring(level) == "0" then
		title = LocalStrings.TIPS5
		local tData = {icon=icon,
			title=title,
			level=0,
			highLightObj = self,
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0))
	else
		local totemInfo = GDatatab_guild_totem["id_"..level]
		local property = totemInfo.property
		local title1 = level..LocalStrings.LEVEL1..LocalStrings.TIPS6
		if ProjConfig.LANGUAGE == "vn" then
			title1 = LocalStrings.LEVEL1..LocalStrings.TIPS6..level
		end
		local guildName = WndCheckOther.m_tPlayerInfo.guildName
		local position = COMMUNITY_POSITION[tonumber(WndCheckOther.m_tPlayerInfo.position)+1]

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
			}
		WndTips:show(element,WndCheckOther.m_root,21,tData,ccp(-55,0))
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
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0))
	elseif tonumber(WndCheckOther.m_tPlayerInfo.marryFlag) == 1 then
		local tData = {icon=icon,
			title=string.format([[<T C="158,139,121" S="20" P="0">%s</T>]],LocalStrings.BAGTIP2),
			level=nil,
			scale=0.5,
			px=0.2,
			py=0.5,
			highLightObj = self,
			}
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0))
	elseif tonumber(WndCheckOther.m_tPlayerInfo.marryFlag) == 2 then
		local tBuff_id = json.decode(WndCheckOther.m_tPlayerInfo.loveSkill)
		local attrNum = 1
		local title1 = level..LocalStrings.LEVEL1..LocalStrings.LOVING_LEVEL
		if ProjConfig.LANGUAGE == "vn" then
			title1 = LocalStrings.LEVEL1..LocalStrings.LOVING_LEVEL..level
		end
		local attr = {}
		local attrVal = {}
		local tProperty = {}
		for k,v in pairs(tBuff_id) do
			local buff_id = v
			local effect_id = GDatatab_buff["id_"..buff_id].effect_id
			local effect = GDatatab_effect["id_"..effect_id].effect
			attr[attrNum] = ATTR_TITLE[effect[1][5]]
			attrVal[attrNum] = effect[1][6]
			attrNum = attrNum + 1

			local tItem = {}
			tItem[1] = effect[1][5]
			tItem[2] = effect[1][6]
			table.insert(tProperty, tItem)
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
			}
		WndTips:show(element,WndCheckOther.m_root,22,tData,ccp(-45,0))
	end
end

--@brief	师德等级
function CellCheckOther01:onAttr5(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WZLog("CellCheckOther01:onTip6")
	local level = WndCheckOther.m_tPlayerInfo.moralityLevel
	local masterName = WndCheckOther.m_tPlayerInfo.masterName
	local roleLevel = WndCheckOther.m_tPlayerInfo.level
	local icon
	local quality = -1
	local title
	local title1 = ""
	local title2 = ""
	local attr1
	local attr2
	local attr3
	local attrVal1
	local attrVal2
	local attrVal3
	local scale = 0.5
	local tProperty = {}

	local tData
	if roleLevel >= MASTERLEVEL then
		WZLog("师德等级"..level)
		icon = "ui/bag/bag_icon_shitu.png"
		title1 = string.format(LocalStrings.RANK_KING_DESC11,level)

		if tostring(level) ~= "0" then
			local tNovice = json.decode(masterName)
			tData = GDatatab_morality["id_"..level]
			title = LocalStrings.RANK_KING_DESC10
			title2 = tNovice
			attr1 = ATTR_TITLE[tData.buff[1][1]]
			attr2 = ATTR_TITLE[tData.buff[2][1]]
			attr3 = ATTR_TITLE[tData.buff[3][1]]
			attrVal1 = tData.buff[1][2]
			attrVal2 = tData.buff[2][2]
			attrVal3 = tData.buff[3][2]
			tProperty = {{tData.buff[1][1],attrVal1},{tData.buff[2][1],attrVal2},{tData.buff[3][1],attrVal3}}
		else
			title = LocalStrings.TIPS9
			local tData = {icon=icon,
				title=title,
				level=nil,
				scale=scale,
				highLightObj = self,
				}
			WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0))
			return
		end
	else
		icon = "ui/common/common_icon_shidei.png"
		if tostring(level) == "0" then
			title = LocalStrings.TIPS8
			local tData = {icon=icon,
				title=title,
				scale=scale,
				highLightObj = self,
				}
			WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0))
			return
		else
			local tNovice = json.decode(masterName)
			tData = GDatatab_morality["id_"..level]
			title = LocalStrings.RANK_KING_DESC9
			title1 = level..LocalStrings.LEVEL1..LocalStrings.RANK_KING_DESC12
			title2 = tNovice
			attr1 = ATTR_TITLE[tData.pupil_buff[1][1]]
			attr2 = ATTR_TITLE[tData.pupil_buff[2][1]]
			attr3 = ATTR_TITLE[tData.pupil_buff[3][1]]
			attrVal1 = tData.pupil_buff[1][2]
			attrVal2 = tData.pupil_buff[2][2]
			attrVal3 = tData.pupil_buff[3][2]
			scale = 0.5
			level = nil

			tProperty = {{tData.pupil_buff[1][1],attrVal1},{tData.pupil_buff[2][1],attrVal2},{tData.pupil_buff[3][1],attrVal3}}
		end
	end
	if roleLevel < MASTERLEVEL then level = 0 end
	local tData = {icon=icon,
		title=title,
		title1=title1,
		title2=title2,
		quality=quality,
		attr1=attr1,
		attr2=attr2,
		attr3=attr3,
		attrVal1=attrVal1,
		attrVal2=attrVal2,
		attrVal3=attrVal3,
		level=level,
		scale=scale,
		highLightObj = self,
		property = tProperty,
		}
	WndTips:show(element,WndCheckOther.m_root,23,tData,ccp(-45,0))
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
		WndTips:show(element,WndCheckOther.m_root,38,tData,ccp(-60,0))
	else
		WndTips:show(element,WndCheckOther.m_root,39,tData,ccp(-60,0))
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
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0))
	else
		if tData.awakeStep >= 4 then
			WndTips:show(element,WndCheckOther.m_root,40,tData,ccp(-60,180))
		else
			WndTips:show(element,WndCheckOther.m_root,40,tData,ccp(-60,0))
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
		WndTips:show(element,WndCheckOther.m_root,1,tData,GlobalMethod:ccp(30,0))
	else
		WndTips:show(element,WndCheckOther.m_root,44,tData,ccp(-60,0))
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

	
	WndTips:show(element,WndCheckOther.m_root,48,tData,ccp(-60,0))
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

	tData.level = tCardData.level
	WndTips:show(element, WndCheckOther.m_root, 49, tData, ccp(-60,0))
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

	WndTips:show(element, WndCheckOther.m_root, 50, tData, ccp(-20,20))
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
	WndTips:show(element, WndCheckOther.m_root, 53, tData, GlobalMethod:ccp(30,-10))
end

--@brief 	点击宠物徽章回调
function CellCheckOther01:onAttr13(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local petMessage = WndCheckOther.m_tPlayerInfo.petMessage
	if petMessage ~= nil and petMessage ~= "" then
		petMessage = json.decode(petMessage)
		WndTips:show(element, WndCheckOther.m_root, 13, petMessage, GlobalMethod:ccp(30,-10))
	end
end

--@brief 	点击图标回调
function CellCheckOther01:onClickIcon(element)
	-- body
	local nTag = element:getTag()
	self.m_nBtnTag = nTag

	if self.m_tTypeList[nTag] == 1 then
		self:onAttr1(element)
	elseif self.m_tTypeList[nTag] == 2 then
		self:onAttr2(element)
	elseif self.m_tTypeList[nTag] == 3 then
		self:onAttr9(element)
	elseif self.m_tTypeList[nTag] == 4 then
		self:onAttr3(element)
	elseif self.m_tTypeList[nTag] == 5 then
		self:onAttr4(element)
	elseif self.m_tTypeList[nTag] == 6 then
		self:onAttr5(element)
	elseif self.m_tTypeList[nTag] == 7 then
		self:onAttr6(element)
	elseif self.m_tTypeList[nTag] == 8 then
		self:onAttr7(element)
	elseif self.m_tTypeList[nTag] == 9 then
		self:onAttr8(element)
	elseif self.m_tTypeList[nTag] == 10 then
		self:onAttr10(element)
	elseif self.m_tTypeList[nTag] == 11 then
		self:onAttr11(element)
	elseif self.m_tTypeList[nTag] == 12 then
		self:onAttr12(element)
	elseif self.m_tTypeList[nTag] == 13 then
		self:onAttr13(element)
	end

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新Cell
function CellCheckOther01:update(tData)
	if tData == nil then return end
	--不到8级隐藏所有图标
	if WndCheckOther.m_tPlayerInfo.level < 8 then
		return
	end

	--设置竞技图标
	WZLog("CellCheckOther01:update", Serialize(self.m_tTypeList), WndCheckOther.m_tPlayerInfo.tournamentLevel)
	for i = 1, #self.m_tTypeList do
		local btnImg1 = GetElement(self.m_root,"btn" .. i .. "img1",WZUIImage)
		local btnImg2 = GetElement(self.m_root,"btn" .. i .. "img2",WZUIImage)
		if self.m_tTypeList[i] == 1 then
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
			GetElement(self.m_root,"btn" .. i, WZUIButton):setTouchEnable(true)
			btnImg1:setFile("ui/common/common_icon_enai1.png")
			btnImg2:setFile("ui/common/common_icon_enai1.png")
			btnImg1:setScale(0.5)
			btnImg2:setScale(0.5)
			GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.loveLevel)
		end
		--设置师德图标
		if self.m_tTypeList[i] == 6 then
			GetElement(self.m_root,"btn" .. i, WZUIButton):setTouchEnable(true)
			GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"numIcon" .. i .. "_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.moralityLevel)
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
	end
	
end

-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function CellCheckOther01:_adaptLanguage_vn(  )
	-- GetElement(self.m_root,"txtUser_WndPlayerInfo",WZUILabelTTF):setScale(0.7)
end

---------------------------------------语言适配End------------------------------------------
