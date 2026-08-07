--CellPvpAmuseItem.lua
--@brief	CellPvpAmuseItem的UI模块
--@date		2018/09/28
--@author	Tianxiang_Xu
--@note		各娱乐赛入口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpAmuseItem:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpAmuseItem:onExit(element)
	self:_unInit()
end

function CellPvpAmuseItem:setPvpAmuseCallFunc(func)
	self.call_func = func
end

-- 选择比赛模式
function CellPvpAmuseItem:onSelectMatch(element)
	WZLog("CellPvpAmuseItem:onSelectMatch")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nodeName = "conStateClose_CellPvpAmuseItem"
	local conStateClose = GetElement(self.m_root, nodeName, WZUIContainer)
	if conStateClose:isVisible() then
		MsgBoxManager:showTipBox(LocalStrings.PVP_HALL_34)
		return 
	end

	if self.call_func then
		self.call_func(self.m_tMatchType)
	end
end

--@brief 	点击规则按钮回调
function CellPvpAmuseItem:onClickRule(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local ruleDesc = {LocalStrings.YULE_FIGHT_RULE1, LocalStrings.YULE_FIGHT_RULE2, LocalStrings.YULE_FIGHT_RULE3, LocalStrings.YULE_FIGHT_RULE4, LocalStrings.YULE_FIGHT_RULE5, LocalStrings.YULE_FIGHT_RULE6, LocalStrings.PVP_HALL_44, LocalStrings.YULE_FIGHT_RULE8}

	WndSingleMapDesc:showInterface(ruleDesc[self.m_tMatchType])
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPvpAmuseItem:initOpenState()
	if self.m_root == nil then return end
	local open = self.openState
	local temp1 = LocalStrings.WELFARE_COMPETE2 --.. LocalStrings.MAP_EVENT_ON
	local temp2 = LocalStrings.WELFARE_COMPETE3 --.. LocalStrings.MAP_EVENT_ON
	local temp3 = LocalStrings.WELFARE_COMPETE4 --.. LocalStrings.MAP_EVENT_ON
	local temp4 = LocalStrings.WELFARE_COMPETE5 --.. LocalStrings.MAP_EVENT_ON
	local temp5 = LocalStrings.WELFARE_COMPETE6 --.. LocalStrings.MAP_EVENT_ON
	local temp6 = LocalStrings.WELFARE_COMPETE7 --.. LocalStrings.MAP_EVENT_ON
	local temp7 = LocalStrings.WELFARE_COMPETE8 --.. LocalStrings.MAP_EVENT_ON

 	local time = { temp1,temp2,temp3,temp4,temp5,temp6,temp7}    
	local hourList = {"trenchMatchOpenTime","captainMatchOpenTime","propsMatchOpenTime","meleeOpenTime","resurgenceMatchOpenTime", "monsterMatchOpenTime", "balanceMatchOpenTime", "battleRoyaledate2"}
	local modeName = {LocalStrings.PVP_HALL_14, LocalStrings.PVP_HALL_15, LocalStrings.PVP_HALL_16, LocalStrings.PVP_HALL_17, LocalStrings.PVP_HALL_18, LocalStrings.PVP_HALL_39, LocalStrings.PVP_HALL_42, LocalStrings.PVP_HALL_45}
	local descWord = {LocalStrings.PVP_HALL_19, LocalStrings.PVP_HALL_20, LocalStrings.PVP_HALL_21, LocalStrings.PVP_HALL_22, LocalStrings.PVP_HALL_23, LocalStrings.PVP_HALL_40, LocalStrings.PVP_HALL_43, LocalStrings.PVP_HALL_46}
 	local titleImg = {"ui/pvp/common_pic_jjct6.png", "ui/pvp/common_pic_jjct7.png", "ui/pvp/common_pic_jjct8.png", "ui/pvp/common_pic_jjct9.png", "ui/pvp/common_pic_jjct10.png", "ui/pvp/common_pic_jjct11.png", "ui/pvp/common_pic_jjct14.png", "ui/pvp/common_pic_jjct113.png"}

	local tempp = self.m_tMatchType
	if tempp then
		local conC = GetElement(self.m_root,"conStateClose_CellPvpAmuseItem",WZUIContainer)
		local conO = GetElement(self.m_root,"conStateOpen_CellPvpAmuseItem",WZUIContainer)
		local ftb = GetElement(self.m_root,"ftbOpenTime_CellPvpAmuseItem",WZUILabelTTF)
		local hour = GetElement(self.m_root,"ftbOpenHour_CellPvpAmuseItem",WZUILabelTTF)
		local txtGameName = GetElement(self.m_root,"txtGameName_CellPvpAmuseItem",WZUILabelTTF)
		local txtGame = GetElement(self.m_root,"txtGame_CellPvpAmuseItem",WZUILabelTTF)
		local imgNor = GetElement(self.m_root, "imgNor_CellPvpAmuseItem", WZUIImage)
		local imgSel = GetElement(self.m_root, "imgSel_CellPvpAmuseItem", WZUIImage)
		
		imgNor:setFile(titleImg[tempp])
		imgSel:setFile(titleImg[tempp])

		txtGameName:setText(modeName[tempp])
		txtGame:setText(descWord[tempp])

		conC:setVisible(not (open == 1))
		conO:setVisible((open == 1))

		if self.m_nDayBegin > 0 then
			ftb:setText(string.format(LocalStrings.AMUSE_DAY_OPEN, self.m_nDayBegin))
			
			if CacheCenter:getGameParam()[hourList[tempp]] ~= nil then
				hour:setText(CacheCenter:getGameParam()[hourList[tempp]].." "..LocalStrings.MAP_EVENT_ON)
				if ProjConfig.LANGUAGE == "es" then
					hour:setText(LocalStrings.MAP_EVENT_ON.." "..CacheCenter:getGameParam()[hourList[tempp]])
				end
			end
	    else
	    	ftb:setText("")
	    	if open == 1 then 
	    		hour:setText("")
	    	else
	    		if CacheCenter:getGameParam()[hourList[tempp]] ~= nil then
					hour:setText(CacheCenter:getGameParam()[hourList[tempp]].. LocalStrings.MAP_EVENT_ON)
					if ProjConfig.LANGUAGE == "es" then
						hour:setText(LocalStrings.MAP_EVENT_ON .. CacheCenter:getGameParam()[hourList[tempp]])
					end
				end
	    	end
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function CellPvpAmuseItem:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtEventTime_CellPvpAmuseItem",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtGame_CellPvpAmuseItem",WZUILabelTTF):setScale(0.7)
end
-------------------------------------语言适配end----------------------------------------



-------------------------------------语言适配begin----------------------------------------
function CellPvpAmuseItem:_adaptLanguage_en()
	GetElement(self.m_root,"txtEventTime_CellPvpAmuseItem",WZUILabelTTF):setScale(0.8)
	local ftb = GetElement(self.m_root,"ftbOpenTime_CellPvpAmuseItem",WZUILabelTTF)
	ftb:setScale(0.8)
	local hour = GetElement(self.m_root,"ftbOpenHour_CellPvpAmuseItem",WZUILabelTTF)
	hour:setScale(0.8)
	hour:setDimensions(GlobalMethod:CCSize(160))
	local txtGameName = GetElement(self.m_root,"txtGameName_CellPvpAmuseItem",WZUILabelTTF)
	txtGameName:setScale(0.8)
	local txtGame = GetElement(self.m_root,"txtGame_CellPvpAmuseItem",WZUILabelTTF)
	txtGame:setScale(0.8)
	txtGame:setDimensions(GlobalMethod:CCSize(190))
end
function CellPvpAmuseItem:_adaptLanguage_pt()
	local txtEventTime = GetElement(self.m_root,"txtEventTime_CellPvpAmuseItem",WZUILabelTTF)
	txtEventTime:setScale(0.6)
	txtEventTime:setDimensions(GlobalMethod:CCSize(130))
	local ftb = GetElement(self.m_root,"ftbOpenTime_CellPvpAmuseItem",WZUILabelTTF)
	ftb:setScale(0.8)
	local hour = GetElement(self.m_root,"ftbOpenHour_CellPvpAmuseItem",WZUILabelTTF)
	hour:setScale(0.8)
	hour:setDimensions(GlobalMethod:CCSize(160))
	hour:setRelativePosition(GlobalMethod:ccp(0.0185,0.76))
	local txtGameName = GetElement(self.m_root,"txtGameName_CellPvpAmuseItem",WZUILabelTTF)
	txtGameName:setScale(0.57)
	local txtGame = GetElement(self.m_root,"txtGame_CellPvpAmuseItem",WZUILabelTTF)
	txtGame:setScale(0.7)
	txtGame:setDimensions(GlobalMethod:CCSize(220))
end
function CellPvpAmuseItem:_adaptLanguage_es()
	local txtEventTime = GetElement(self.m_root,"txtEventTime_CellPvpAmuseItem",WZUILabelTTF)
	txtEventTime:setScale(0.6)
	txtEventTime:setDimensions(GlobalMethod:CCSize(130))
	local ftb = GetElement(self.m_root,"ftbOpenTime_CellPvpAmuseItem",WZUILabelTTF)
	ftb:setScale(0.8)
	local hour = GetElement(self.m_root,"ftbOpenHour_CellPvpAmuseItem",WZUILabelTTF)
	hour:setScale(0.8)
	hour:setDimensions(GlobalMethod:CCSize(160))
	hour:setRelativePosition(GlobalMethod:ccp(0.0185,0.76))
	local txtGameName = GetElement(self.m_root,"txtGameName_CellPvpAmuseItem",WZUILabelTTF)
	txtGameName:setScale(0.57)
	local txtGame = GetElement(self.m_root,"txtGame_CellPvpAmuseItem",WZUILabelTTF)
	txtGame:setScale(0.7)
	txtGame:setDimensions(GlobalMethod:CCSize(220))
end
-------------------------------------语言适配end----------------------------------------