--CellCheckOther1.lua
--@brief	CellCheckOther1的UI模块
--@date		2015/07/06
--@author	zsq
--@note		玩家信息栏1


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOther1:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function CellCheckOther1:onEnterTransitionDidFinish(element)
	self:update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOther1:onExit(element)
	self:_unInit()
end

function CellCheckOther1:onTouchBegan()
	WZLog("CellCheckOther1:onTouchBegan")

end

--@brief	设置高亮
function CellCheckOther1:setHighLight(bool)
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
function CellCheckOther1:onAttr(element)
	WZLog("CellCheckOther1:onAttr")
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
function CellCheckOther1:onAttr1(element)
	WZLog("CellCheckOther1:onTip2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 1
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
function CellCheckOther1:onAttr2(element)
	WZLog("CellCheckOther1:onTip3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 2
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
    	WZLog("CellCheckOther1:onTip3", Serialize(info))
    	local data = {level = tonumber(info.level), winNum = info.winTimes,total = info.joinTimes,maxWinNum = info.continous,exp=tonumber(info.exp)}
    	WndTips:show(element,WndCheckOther.m_root,17,data,GlobalMethod:ccp(36,-5))
	end
end

--@brief	图腾等级
function CellCheckOther1:onAttr3(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 3
	local level = WndCheckOther.m_tPlayerInfo.totemLevel
	WZLog("CellCheckOther1:onTip4",level)
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
			}
		WndTips:show(element,WndCheckOther.m_root,21,tData,ccp(-55,0))
	end 
end

--@brief	恩爱等级
function CellCheckOther1:onAttr4(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 4
	WZLog("CellCheckOther1:onTip5",WndCheckOther.m_tPlayerInfo.loveSkill)
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
		for k,v in pairs(tBuff_id) do
			local buff_id = v
			local effect_id = GDatatab_buff["id_"..buff_id].effect_id
			local effect = GDatatab_effect["id_"..effect_id].effect
			attr[attrNum] = ATTR_TITLE[effect[1][5]]
			attrVal[attrNum] = effect[1][6]
			attrNum = attrNum + 1
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
			}
		WndTips:show(element,WndCheckOther.m_root,22,tData,ccp(-45,0))
	end
end

--@brief	师德等级
function CellCheckOther1:onAttr5(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 5
	WZLog("CellCheckOther1:onTip6")
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
			if ProjConfig.LANGUAGE == "vn" then
				title1 = LocalStrings.LEVEL1..LocalStrings.RANK_KING_DESC12..level
			end
			title2 = tNovice
			attr1 = ATTR_TITLE[tData.pupil_buff[1][1]]
			attr2 = ATTR_TITLE[tData.pupil_buff[2][1]]
			attr3 = ATTR_TITLE[tData.pupil_buff[3][1]]
			attrVal1 = tData.pupil_buff[1][2]
			attrVal2 = tData.pupil_buff[2][2]
			attrVal3 = tData.pupil_buff[3][2]
			scale = 0.5
			level = nil
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
		}
	WndTips:show(element,WndCheckOther.m_root,23,tData,ccp(-45,0))
end

--@brief	幻化等级
function CellCheckOther1:onAttr6(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 6

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
function CellCheckOther1:onAttr7(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 7
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
			WndTips:show(element,WndCheckOther.m_root,40,tData,ccp(-60,100))
		else
			WndTips:show(element,WndCheckOther.m_root,40,tData,ccp(-60,0))
		end
	end
end

--@brief	家园
function CellCheckOther1:onAttr8(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 8

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
function CellCheckOther1:onAttr9(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 9
	local initProperty = CacheCenter:getGameParam().initialAttribute
	local addProperty = CacheCenter:getGameParam().increaseAttribute
	WZLog("CellCheckOther1:onAttr9", initProperty, addProperty)
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
function CellCheckOther1:onAttr10(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 10

	local tCardData = json.decode(WndCheckOther.m_tPlayerInfo.cardMessage)
	local tData = {}
	tData.cardNum = {{3,0},{2,0},{1,0}}
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
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新Cell
function CellCheckOther1:update(tData)
	if tData == nil then return end
	--不到8级隐藏所有图标
	if WndCheckOther.m_tPlayerInfo.level < 8 then
		return
	end

	--竞技 排位 公会 结婚 师徒
	local btnPosition = {GlobalMethod:ccp(0.07,0.37),GlobalMethod:ccp(0.242,0.37),GlobalMethod:ccp(0.414,0.37),
			GlobalMethod:ccp(0.586,0.37),GlobalMethod:ccp(0.758,0.37),GlobalMethod:ccp(0.93,0.37),
			GlobalMethod:ccp(0.07,-0.43),GlobalMethod:ccp(0.242,-0.43),GlobalMethod:ccp(0.414,-0.43),GlobalMethod:ccp(0.586,-0.43),GlobalMethod:ccp(0.758,-0.43),GlobalMethod:ccp(0.93,-0.43)}

	local showList = {}
	local showIndex = 1
	local disableList = {}
	local disableIndex = 1

	--设置竞技图标
	if CheckButtonShow(5) then
		local hallInfo = GDatatab_integral["id_"..WndCheckOther.m_tPlayerInfo.tournamentLevel]
		local displayLv = WndCheckOther.m_tPlayerInfo.tournamentLevel--%10
		if displayLv == 0 then displayLv = 10 end
		if displayLv ~= nil then
			GetElement(self.m_root,"img1btn1",WZUIImage):setFile("ui/common/"..hallInfo.iocn..".png")
			GetElement(self.m_root,"img2btn1",WZUIImage):setFile("ui/common/"..hallInfo.iocn..".png")
		end
		GetElement(self.m_root,"btn1",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root,"numIcon1_CellCheckOther1",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"numIcon1_CellCheckOther1",WZUILabelTTF):setText(LocalStrings.LV..displayLv)
		showList[showIndex] = "btn1"
		showIndex = showIndex + 1
	else
		disableList[disableIndex] = "btn1"
		disableIndex = disableIndex + 1
	end
	--设置排位图标
	if CheckButtonShow(23) then
		local btn2 = GetElement(self.m_root,"btn2",WZUIButton)
		btn2:setTouchEnable(true)
		local tTempData = GetPvpDataByLevel(WndCheckOther.m_tPlayerInfo.segmentId)
		if btn2 then
	        local celElement, tNewObj = CellPvpLevelIcon:createElement()
	        if celElement and tNewObj then
	            tNewObj:setData(tTempData, false, 0.38, false)
	            celElement:setScale(0.38)
	            btn2:addChild(celElement)
	        end
	    end
		WZLog("sdgsdfjl",WndCheckOther.m_tPlayerInfo.segmentId)
		if tonumber(WndCheckOther.m_tPlayerInfo.segmentId) ~= 0 then
    		local info = GDatatab_trio_rank_match_config["id_"..WndCheckOther.m_tPlayerInfo.segmentId]
			for k,v in pairs(GDatatab_trio_rank_match_config) do
				if v.level3 == WndCheckOther.m_tPlayerInfo.segmentId then
					info = v
				end
			end
			if WndCheckOther.m_tPlayerInfo.segmentId > 106 then
				info = GDatatab_trio_rank_match_config["id_999"]
			end
			GetElement(self.m_root,"btn2img1",WZUIImage):setFile("ui/common/"..info.icon..".png")
			GetElement(self.m_root,"btn2img2",WZUIImage):setFile("ui/common/"..info.icon..".png")
    		GetElement(self.m_root,"numIcon2_CellCheckOther1",WZUILabelTTF):setText(LocalStrings.LV..info.level3)
    		GetElement(self.m_root,"numIcon2_CellCheckOther1",WZUILabelTTF):setVisible(true)
		end

		showList[showIndex] = "btn2"
		showIndex = showIndex + 1
	else
		disableList[disableIndex] = "btn2"
		disableIndex = disableIndex + 1
	end
	--排位印记
	if CheckButtonShow(23) then
		local btn2 = GetElement(self.m_root,"btn9",WZUIButton)
		btn2:setTouchEnable(true)
		btn2:setVisible(true)
		if WndCheckOther.m_tPlayerInfo.obtainNum > 0 then
			GetElement(self.m_root, "imgAsk_CellCheckOther1", WZUIImage):setVisible(false)
			GetElement(self.m_root, "numIcon9_CellCheckOther1", WZUILabelAtlasFont):setVisible(true)
			GetElement(self.m_root, "numIcon9_CellCheckOther1", WZUILabelAtlasFont):setText(WndCheckOther.m_tPlayerInfo.obtainNum)
		else
			GetElement(self.m_root, "numIcon9_CellCheckOther1", WZUILabelAtlasFont):setVisible(false)
			GetElement(self.m_root, "imgAsk_CellCheckOther1", WZUIImage):setVisible(true)
		end

		showList[showIndex] = "btn9"
		showIndex = showIndex + 1
	else
		disableList[disableIndex] = "btn9"
		disableIndex = disableIndex + 1
	end
	--设置公会图标
	local level = WndCheckOther.m_tPlayerInfo.totemLevel
	if tonumber(level) > 0 then
		GetElement(self.m_root,"btn3",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root,"numIcon3_CellCheckOther1",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"numIcon3_CellCheckOther1",WZUILabelTTF):setText(LocalStrings.LV..level)
		GetElement(self.m_root,"btn3img1",WZUIImage):setFile("ui/community/common_icon_gonghui"..level..".png")
		GetElement(self.m_root,"btn3img2",WZUIImage):setFile("ui/community/common_icon_gonghui"..level..".png")
		GetElement(self.m_root,"btn3img1",WZUIImage):setScale(0.5)
		GetElement(self.m_root,"btn3img2",WZUIImage):setScale(0.5)
		showList[showIndex] = "btn3"
		showIndex = showIndex + 1
	else
		disableList[disableIndex] = "btn3"
		disableIndex = disableIndex + 1
	end
	if tonumber(level) > 10 then
		GetElement(self.m_root,"btn3img1",WZUIImage):setScale(0.4)
		GetElement(self.m_root,"btn3img2",WZUIImage):setScale(0.4)
	end
	--设置恩爱图标
	if CheckButtonShow(8) then
		GetElement(self.m_root,"btn4",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root,"numIcon4_CellCheckOther1",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"numIcon4_CellCheckOther1",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.loveLevel)
		showList[showIndex] = "btn4"
		showIndex = showIndex + 1
	else
		disableList[disableIndex] = "btn4"
		disableIndex = disableIndex + 1
	end
	--设置师德图标
	if CheckButtonShow(30) then
		GetElement(self.m_root,"btn5",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root,"numIcon5_CellCheckOther1",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"numIcon5_CellCheckOther1",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.moralityLevel)
		GetElement(self.m_root,"img1btn5",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		GetElement(self.m_root,"img2btn5",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		if tonumber(WndCheckOther.m_tPlayerInfo.moralityLevel) == 0 then
			GetElement(self.m_root,"numIcon5_CellCheckOther1",WZUILabelTTF):setText("")
		end
		if tonumber(WndCheckOther.m_tPlayerInfo.level) < MASTERLEVEL then
			GetElement(self.m_root,"numIcon5_CellCheckOther1",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"img1btn5",WZUIImage):setFile("ui/common/common_icon_shidei.png")
			GetElement(self.m_root,"img2btn5",WZUIImage):setFile("ui/common/common_icon_shidei.png")
			GetElement(self.m_root,"img1btn5",WZUIImage):setScale(0.5)
			GetElement(self.m_root,"img2btn5",WZUIImage):setScale(0.5)
			GetElement(self.m_root,"img1btn5",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.5,0.55))
			GetElement(self.m_root,"img2btn5",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.5,0.55))
		end
		showList[showIndex] = "btn5"
		showIndex = showIndex + 1
	else
		disableList[disableIndex] = "btn5"
		disableIndex = disableIndex + 1
	end
	--设置幻化图标
	local shapeId = WndCheckOther.m_tPlayerInfo.shapeId
	if shapeId ~= nil and shapeId >= 0 then
		GetElement(self.m_root,"btn6",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root,"numIcon6_CellCheckOther1",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"numIcon6_CellCheckOther1",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.shapeLevel)
		GetElement(self.m_root,"img1btn6",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		GetElement(self.m_root,"img2btn6",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.5,0.5))

		showList[showIndex] = "btn6"
		showIndex = showIndex + 1
	else
		disableList[disableIndex] = "btn6"
		disableIndex = disableIndex + 1
	end
	--设置觉醒勋章
	GetElement(self.m_root,"btn7",WZUIButton):setVisible(false)
	if CheckButtonShow(120) then
		GetElement(self.m_root,"btn7",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root,"btn7",WZUIButton):setVisible(true)
		GetElement(self.m_root,"numIcon7_CellCheckOther01",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"numIcon7_CellCheckOther01",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.awakeStep)
		showList[showIndex] = "btn7"
		showIndex = showIndex + 1
	else
		disableList[disableIndex] = "btn7"
		disableIndex = disableIndex + 1
	end
	--设置家园勋章
	GetElement(self.m_root,"btn8",WZUIButton):setVisible(false)
	if CheckButtonShow(131) then
		GetElement(self.m_root,"btn8",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root,"btn8",WZUIButton):setVisible(true)
		GetElement(self.m_root,"numIcon8_CellCheckOther1",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"numIcon8_CellCheckOther1",WZUILabelTTF):setText(LocalStrings.LV..WndCheckOther.m_tPlayerInfo.homeLevel)
		showList[showIndex] = "btn8"
		showIndex = showIndex + 1
	else
		disableList[disableIndex] = "btn8"
		disableIndex = disableIndex + 1
	end
	--设置卡牌勋章
	GetElement(self.m_root,"btn10",WZUIButton):setVisible(false)
	local tCardData = json.decode(WndCheckOther.m_tPlayerInfo.cardMessage)
	if CheckButtonShow(76) and CheckButtonOpen(76) and tCardData > 0 then
		GetElement(self.m_root,"btn10",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root,"btn10",WZUIButton):setVisible(true)
		if tCardData.level > 0 then
			GetElement(self.m_root,"numIcon10_CellCheckOther1",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"numIcon10_CellCheckOther1",WZUILabelTTF):setText(LocalStrings.LV .. tCardData.level)
		else
			GetElement(self.m_root,"numIcon10_CellCheckOther1",WZUILabelTTF):setVisible(false)
		end
		showList[showIndex] = "btn10"
		showIndex = showIndex + 1
	else
		disableList[disableIndex] = "btn10"
		disableIndex = disableIndex + 1
	end
	

	WZLog("显示按钮",Serialize(showList))
	for i=1,#showList do
		GetElement(self.m_root,showList[i],WZUIButton):setRelativePosition(btnPosition[i])
	end
	for i=1,#disableList do
		GetElement(self.m_root,disableList[i],WZUIButton):setRelativePosition(btnPosition[i+#showList])
		if i+#showList == 7 then
			GetElement(self.m_root,disableList[i],WZUIButton):setVisible(false)
		end
		if i+#showList == 8 then
			GetElement(self.m_root,disableList[i],WZUIButton):setVisible(false)
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellCheckOther1:_adaptLanguage_vn()
	local txt = GetElement(self.m_root,"txtUser_WndPlayerInfo",WZUILabelTTF)
	txt:setFontSize(16)
	txt:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
end
-------------------------------------语言适配End--------------------------------------------
