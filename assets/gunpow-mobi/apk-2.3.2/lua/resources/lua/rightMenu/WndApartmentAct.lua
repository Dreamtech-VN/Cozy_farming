--WndApartmentAct.lua
--@brief	WndApartmentAct的UI模块
--@date		2017/08/08
--@author	zsq
--@note		公寓活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndApartmentAct:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	ProtocolProcessorWndRankList:regAll()
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.updateRedDot, self)

	WZLog("WndApartmentAct:onEnter", CacheCenter:getGameParam().summerActivityNote)
end

--@brief    onenter函数已执行
function WndApartmentAct:onEnterTransitionDidFinish(element)
    WZLog("WndApartmentAct:onEnterTransitionDidFinish", GlobalGame.g_autoLouraActivity)
	self.m_nTag = 7

	if WndApartmentAct.soundIndex == nil then WndApartmentAct.soundIndex = 0 end

	if GlobalGame.g_autoLouraActivity == 1 then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo(4)
	end

	--更新充值信息
	WndNewActivity:updateRechargeInfo()
	self.m_root:enableSchedule("countDown", 1)

	self:setStaticText()

	WndApartmentAct:setRed2(GlobalGame.g_tRedPointList.louraAct)

	GetElement(self.m_root,"btnTip",WZUIButton):setVisible(true)
--	
	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"btnTip",WZUIButton):setVisible(false)
	end
end

--@brief 	触摸开始回调
function WndApartmentAct:onTouchBegan(element, pt)
	-- body
	WZLog("WndApartmentAct:onTouchBegan")
	if WndChristmasTree.m_root then 
		local bInWin = WndChristmasTree:checkPointInBtn(pt)
		if WndApartmentAct.m_root:getChildByTag(888) and not bInWin then 
			WZLog("WndApartmentAct:onTouchBegan")
			WndApartmentAct.m_root:removeChildByTag(888, true)
			WndApartmentAct.m_root:removeChildByTag(999, true)
		end
	end
end

function WndApartmentAct:countDown() 
	if self.m_nDisappearTime == nil then return end
	if SystemTime:getServerTime() > self.m_nDisappearTime then
		if GlobalGame.g_autoLouraActivity == 1 then
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo(4)
		end
	end
end

function WndApartmentAct:isSeckillOn()
	if WndApartmentAct.receiveSeckill == nil or WndApartmentAct.seckillStartTime == nil or WndApartmentAct.seckillEndTime == nil then
		return false
	end

	local onlineTime = tonumber(SystemTime:getServerTime()) - tonumber(WndApartmentAct.receiveSeckill)
	WZLog("WndApartmentAct:isSeckillOn2", tonumber(WndApartmentAct.seckillEndTime))
	if onlineTime <= tonumber(WndApartmentAct.seckillStartTime) then
		return false
	else
		if onlineTime < tonumber(WndApartmentAct.seckillEndTime) then
			return true
		else
			return false	
		end
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndApartmentAct:onExit(element)
	-- FootEffectManager:removeEffect1(self.m_sFootSpine)
	if self.m_sFootSpine then
		self.m_sFootSpine:removeFromParentAndCleanup(true)
		self.m_sFootSpine = nil
	end
	ProtocolProcessorWndRankList:unregAll()
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.updateRedDot, self)
	self:_unInit()
end

--@brief    创建并显示活动界面
--index：跳转活动的id
function WndApartmentAct:showInterface(index)
    WZLog("WndApartmentAct:showInterface")
    local wnd = WndApartmentAct:createElement(index)
    if wnd ~= nil then
        WindowManager:addWindow(wnd,WndApartmentAct,nil,nil,nil,true)
    end
end

function WndApartmentAct:onCloseClick(element) 
	WZLog("WndApartmentAct:onCloseClick")
	SoundManager:stopEffectSound(self.m_nSoundId)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_OutActivitiesShop( )
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndApartmentAct:onTab(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	local tag = element:getTag()
	self.m_nTag = tag
	GetElement(self.m_root,"btnTip",WZUIButton):setVisible(true)
	if tonumber(tag) == 5 then
		GetElement(self.m_root,"btnTip",WZUIButton):setVisible(false)
		
	end
	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"btnTip",WZUIButton):setVisible(false)
	end

	-- local moveCon = GetElement(self.m_root, "moveCon_WndApartmentAct", WZUIMoveContainer)
	-- self.m_nMoveElementPosY = moveCon:getMoveElement():getPositionY()
	

	self:_updateTab()
end

--@brief 	关闭活动界面(不带音效)
function WndApartmentAct:closeWindow()
	-- body
	SoundManager:stopEffectSound(self.m_nSoundId)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_OutActivitiesShop( )
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndApartmentAct:_updateTab() 
	
	if self.m_nCurIndex == self.m_nTag then return end
	self.m_nCurIndex = self.m_nTag
	for i=1,6 do
		GetElement(self.m_root,"txtAct"..i,WZUILabelTTF):setText(LocalStrings["LOURAACT"..i])
		GetElement(self.m_root,"txtAct"..i.."_sel",WZUILabelTTF):setText(LocalStrings["LOURAACT"..i])
	end
	GetElement(self.m_root,"txtAct7",WZUILabelTTF):setText(LocalStrings["LOURAACT11"])
	GetElement(self.m_root,"txtAct7_sel",WZUILabelTTF):setText(LocalStrings["LOURAACT11"])

	local actTypes = {3029,3011,3031,3029,3011,3012,3030,3043,3044,10,3051,6000,13,3032, 3021, 3023, 7000, 3054}
	self.m_tAllActivityType = actTypes
	local hasAct1 = false
	local hasAct2 = false
	local hasAct3 = false
	local hasAct4 = false
	local hasAct5 = false
	local hasAct6 = false
	local hasAct7 = false
	local hasAct8 = false
	local hasAct9 = false
	local hasAct10 = SceneCity:isSterious()  --神秘商人
	local hasAct11 = false
	local hasAct12 = false
	local hasAct13 = WndApartmentAct:isSeckillOn()
	local hasAct14 = false
	local hasAct15 = false
	local hasAct16 = false
	local hasAct17 = false 
	local hasAct18 = false 
	self.m_tTabTitleName = {}
	
	for i=1,#self.m_tListItem do
		local title = self.m_tListItem[i].title
		local tab = {}
		tab.title_id = self.m_tListItem[i].types
		tab.title_name = title
		self.m_tTabTitleName[tab.title_id] = tab

		if self.m_tListItem[i].types == 3029 then
			GetElement(self.m_root,"txtAct1",WZUILabelTTF):setText(title)
			GetElement(self.m_root,"txtAct1_sel",WZUILabelTTF):setText(title)
			hasAct1 = true
		end
		if self.m_tListItem[i].types == 3011 then
			GetElement(self.m_root,"txtAct2",WZUILabelTTF):setText(title)
			GetElement(self.m_root,"txtAct2_sel",WZUILabelTTF):setText(title)
			hasAct2 = true
		end
		if self.m_tListItem[i].types == 3031 then
			GetElement(self.m_root,"txtAct3",WZUILabelTTF):setText(title)
			GetElement(self.m_root,"txtAct3_sel",WZUILabelTTF):setText(title)
			hasAct3 = true
		end
		if self.m_tListItem[i].types == 3030 then
			GetElement(self.m_root,"txtAct7",WZUILabelTTF):setText(title)
			GetElement(self.m_root,"txtAct7_sel",WZUILabelTTF):setText(title)
			hasAct7 = true
		end
		if self.m_tListItem[i].types == 3043 then
			GetElement(self.m_root,"txtAct8",WZUILabelTTF):setText(title)
			GetElement(self.m_root,"txtAct8_sel",WZUILabelTTF):setText(title)
			hasAct8 = true
		end
		if self.m_tListItem[i].types == 3044 then
			GetElement(self.m_root,"txtAct9",WZUILabelTTF):setText(title)
			GetElement(self.m_root,"txtAct9_sel",WZUILabelTTF):setText(title)
			hasAct9 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACIVIITY_CHRISTMASTREE then
			if ProjConfig.LANGUAGE == "cn" then 
				GetElement(self.m_root,"txtAct11",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct11_sel",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct11",WZUILabelTTF):setText(title)
				GetElement(self.m_root,"txtAct11_sel",WZUILabelTTF):setText(title)
			end
			hasAct11 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACIVIITY_THEMATIC_TASKS then
			if ProjConfig.LANGUAGE == "cn" then 
				GetElement(self.m_root,"txtAct12",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct12_sel",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct12",WZUILabelTTF):setText(title)
				GetElement(self.m_root,"txtAct12_sel",WZUILabelTTF):setText(title)
			end
			hasAct12 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_SUMMER_REWARD then
			if ProjConfig.LANGUAGE == "cn" then 
				GetElement(self.m_root,"txtAct14",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct14_sel",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct14",WZUILabelTTF):setText(title)
				GetElement(self.m_root,"txtAct14_sel",WZUILabelTTF):setText(title)
			end
			hasAct14 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_ORDERREDPACK then
			if ProjConfig.LANGUAGE == "cn" then 
				GetElement(self.m_root,"txtAct15",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct15_sel",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct15",WZUILabelTTF):setText(title)
				GetElement(self.m_root,"txtAct15_sel",WZUILabelTTF):setText(title)
			end
			hasAct15 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_TYPE_FIREWORK then
			if ProjConfig.LANGUAGE == "cn" then 
				GetElement(self.m_root,"txtAct16",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct16_sel",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct16",WZUILabelTTF):setText(title)
				GetElement(self.m_root,"txtAct16_sel",WZUILabelTTF):setText(title)
			end
			hasAct16 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_MARK_COIN then
			if ProjConfig.LANGUAGE == "cn" then 
				GetElement(self.m_root,"txtAct17",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct17_sel",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct17",WZUILabelTTF):setText(title)
				GetElement(self.m_root,"txtAct17_sel",WZUILabelTTF):setText(title)
			end
			hasAct17 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_TOW_PACKAGE then
			if ProjConfig.LANGUAGE == "cn" then 
				GetElement(self.m_root,"txtAct18",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct18_sel",WZUILabelTTF):setTextKey("")
				GetElement(self.m_root,"txtAct18",WZUILabelTTF):setText(title)
				GetElement(self.m_root,"txtAct18_sel",WZUILabelTTF):setText(title)
			end
			hasAct18 = true
		end
	end
	if WndApartmentAct:canWeShare() then
		hasAct5 = true
	end
	if WndApartmentAct:showAct4() then
		hasAct4 = true
	end
	

	--美洲屏蔽首冲双倍页签
	if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1089 or ProjConfig.CHANNEL_ID == 1095 or ProjConfig.CHANNEL_ID == 1099 then
		hasAct4 = false
	end

	if self.m_nTag == 7 and hasAct7 == false then
		self.m_nTag = 8
	end
	if self.m_nTag == 8 and hasAct8 == false then
		self.m_nTag = 3
	end
	if self.m_nTag == 3 and hasAct3 == false then
		self.m_nTag = 9
	end
	if self.m_nTag == 9 and hasAct9 == false then
		self.m_nTag = 1
	end
	if self.m_nTag == 1 and hasAct1 == false then
		self.m_nTag = 2
	end
	if self.m_nTag == 2 and hasAct2 == false then
		self.m_nTag = 10
	end
	if self.m_nTag == 10 and hasAct10 == false then 
		self.m_nTag = 11 
	end
	if self.m_nTag == 11 and hasAct11 == false then 
		self.m_nTag = 12 
	end
	if self.m_nTag == 12 and hasAct12 == false then 
		self.m_nTag = 13 
	end
	if self.m_nTag == 13 and hasAct13 == false then 
		self.m_nTag = 14 
	end
	if self.m_nTag == 14 and hasAct14 == false then 
		self.m_nTag = 15 
	end
	if self.m_nTag == 15 and hasAct15 == false then 
		self.m_nTag = 16 
	end
	if self.m_nTag == 16 and hasAct16 == false then 
		self.m_nTag = 17 
	end
	if self.m_nTag == 17 and hasAct17 == false then 
		self.m_nTag = 18 
	end
	local tag = self.m_nTag
	GetElement(self.m_root, "checkGroup_WndApartmentAct", WZUICheckBoxGroup):setCheckIndex(tag-1)
	--显示开放的活动标签
	WZLog("开放标签", hasAct1, hasAct2, hasAct3, hasAct4, hasAct5, hasAct6, hasAct7, hasAct8, hasAct9, hasAct10, hasAct11, hasAct12, hasAct13, hasAct14)
	local showTabList = {}
	local tShowTabTag = {}

	if hasAct7 then
	 	table.insert(showTabList, "checkInfo7_WndApartmentAct")
	 	table.insert(tShowTabTag, 7)
	end
	if hasAct8 then
	 	table.insert(showTabList, "checkInfo8_WndApartmentAct")
	 	table.insert(tShowTabTag, 8)
	end
	if hasAct3 then
	 	table.insert(showTabList, "checkInfo3_WndApartmentAct")
	 	table.insert(tShowTabTag, 3)
	end
	if hasAct9 then
	 	table.insert(showTabList, "checkInfo9_WndApartmentAct")
	 	table.insert(tShowTabTag, 9)
	end
	if hasAct1 then
	 	table.insert(showTabList, "checkInfo1_WndApartmentAct")
	 	table.insert(tShowTabTag, 1)
	end
	if hasAct2 then
	 	table.insert(showTabList, "checkInfo2_WndApartmentAct")
	 	table.insert(tShowTabTag, 2)
	end
	if hasAct4 then
		table.insert(showTabList, "checkInfo4_WndApartmentAct")
	 	table.insert(tShowTabTag, 4)
	end
	if hasAct5 then
		table.insert(showTabList, "checkInfo5_WndApartmentAct")
	 	table.insert(tShowTabTag, 5)
	end
	if hasAct6 then
		table.insert(showTabList, "checkInfo6_WndApartmentAct")
	 	table.insert(tShowTabTag, 6)
	end
	if hasAct10 then
		table.insert(showTabList, "checkInfo10_WndApartmentAct")
	 	table.insert(tShowTabTag, 10)
	end
	if hasAct11 then
		table.insert(showTabList, "checkInfo11_WndApartmentAct")
	 	table.insert(tShowTabTag, 11)
	end
	if hasAct12 then
		table.insert(showTabList, "checkInfo12_WndApartmentAct")
	 	table.insert(tShowTabTag, 12)
	end
	if hasAct13 then
		table.insert(showTabList, "checkInfo13_WndApartmentAct")
	 	table.insert(tShowTabTag, 13)
	end
	if hasAct14 then
		table.insert(showTabList, "checkInfo14_WndApartmentAct")
	 	table.insert(tShowTabTag, 14)
	end
	if hasAct15 then
		table.insert(showTabList, "checkInfo15_WndApartmentAct")
	 	table.insert(tShowTabTag, 15)
	end
	if hasAct16 then
		table.insert(showTabList, "checkInfo16_WndApartmentAct")
	 	table.insert(tShowTabTag, 16)
	end
	if hasAct17 then
		table.insert(showTabList, "checkInfo17_WndApartmentAct")
	 	table.insert(tShowTabTag, 17)
	end
	if hasAct18 then
		table.insert(showTabList, "checkInfo18_WndApartmentAct")
	 	table.insert(tShowTabTag, 18)
	end

	
	for i=1,18 do
		GetElement(self.m_root,"checkInfo"..i.."_WndApartmentAct",WZUICheckBox):setVisible(false)
	end

	
	if self.m_sComeInFlag == nil then
		self.m_sComeInFlag = true
		local m_actTypes = {3029,3011,3031,3029,3011,3012,3030,3043,3044,10,3051,6000,13,3032, 3021, 3023, 7000, 3054}
		if self.m_nChooseActivityIndex then
			for i=1,#m_actTypes do
				if m_actTypes[i] == self.m_nChooseActivityIndex then
					self.m_nTag = i
					break
				end
			end
		end
		local nTempTag = 1
		for i = 1, GetTableLen(tShowTabTag) do
			if tShowTabTag[i] == self.m_nTag then 
				nTempTag = i
				break 
			end
		end
		
		self:setChangeTab(nTempTag, tShowTabTag[nTempTag])
		local tabListContainer = GetElement(self.m_root,"tabListContainer",WZUIFreeListContainer)
		for i = 1, #tShowTabTag do
			local element, tLuaObj = CellApartmentItem:createElement()
			self.m_tTabTitleColor[i] = tLuaObj
			tabListContainer:pushBack(WZUIContainer:luaTo(element))
			tabListContainer:getMoveElement():setPositionY(tabListContainer:getMinPosition().y)
			tLuaObj:setCellApartmentMessage(i, tShowTabTag[i], self.m_tTabTitleName[m_actTypes[tShowTabTag[i]]], nTempTag)
			tLuaObj:setCellApartmentFunc(function(sort_index,index)
				self:setChangeTab(sort_index, index)
			end)
		end
		
	end
end


function WndApartmentAct:setChangeTab(sort_index,tag)
	if self.m_nCurIndex == sort_index then return end
	if not tag then return end
	GetElement(self.m_root,"btnTip",WZUIButton):setVisible(true)
	if tonumber(tag) == 5 then
		GetElement(self.m_root,"btnTip",WZUIButton):setVisible(false)
	end
	
	if self.m_tTabTitleColor[self.m_nCurIndex] ~= nil then
		self.m_tTabTitleColor[self.m_nCurIndex]:setNormalTitleColor()
	end
	if self.m_tTabTitleColor[sort_index] ~= nil then
		self.m_tTabTitleColor[sort_index]:setSelectTitleColor()
	end
	self.m_nTag = tag
	self.m_nCurIndex = sort_index

	local conActivityC = GetElement(self.m_root, "conActivityC_WndSumVacAct", WZUIContainer)
	if conActivityC:getChildByTag(99) then 
		conActivityC:removeChildByTag(99, true)
	end
	for i = 1, 10 do
		GetElement(self.m_root,"conActivityContext"..i.."_WndApartmentAct",WZUIContainer):setVisible(false)
	end

	
	if tag == 15 or tag == 16 then
		GetElement(self.m_root,"txt11",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txt12",WZUILabelTTF):setVisible(false)
	else
		GetElement(self.m_root,"txt11",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txt12",WZUILabelTTF):setVisible(true)
	end
	
	local actTypes = {3029,3011,3031,3029,3011,3012,3030,3043,3044,10,3051,6000,13,3032, 3021, 3023, 7000, 3054}
	WZLog("点击的tag值为",tag)
	if tag <= 10 or tag == 18 then 
		if tag == 18 or tag == 9 then 
			GetElement(self.m_root,"conActivityContext".."3".."_WndApartmentAct",WZUIContainer):setVisible(true)
		else
			GetElement(self.m_root,"conActivityContext"..tag.."_WndApartmentAct",WZUIContainer):setVisible(true)
		end
		
	elseif tag == 11 then 
		
		local element = WndChristmasTree:createElement()
		element:setTag(99)
		conActivityC:addChild(element)
	elseif tag == 12 then
		
		local element = WndThematicTasks:createElement()
		element:setTag(99)
		local tActivityData = self:getActivityDataByActivityType(actTypes[12])
		WndThematicTasks:setData(tActivityData)
		conActivityC:addChild(element)
	elseif tag == 13 then
		
		local element = WndSeckill:createElement()
		element:setTag(99)
		conActivityC:addChild(element)
	elseif tag == 14 then 
		
		local element = WndSummerReward:createElement()
		element:setTag(99)
		conActivityC:addChild(element)
	elseif tag == 15 then
		
		local element = CellOrderRedPack:createElement()
		self.m_nodeElement = element 
		self.m_tCellElement = CellOrderRedPack 
		element:setTag(99)
		conActivityC:addChild(element)
	elseif tag == 16 then
		
		local element, tNewObj = CellFireworks:createElement()
		self.m_nodeElement = element 
		self.m_tCellElement = tNewObj 
		element:setTag(99)
		conActivityC:addChild(element)
	elseif tag == 17 then 	
		
		local element = CellMarkCoinPanel:createElement()
		self.m_nodeElement = element 
		self.m_tCellElement = CellMarkCoinPanel 
		element:setTag(99)
		local tActivityData = self:getActivityDataByActivityType(actTypes[17])
		CellMarkCoinPanel:setData(tActivityData)
		conActivityC:addChild(element)
	end

	if self.m_nTag == 14 or self.m_nTag == 15 or self.m_nTag == 16 then
		GetElement(self.m_root,"btnTip",WZUIButton):setVisible(false)
	end


	--神秘商店
	GetElement(self.m_root,"btnRebate",WZUIButton):setVisible(false)

	if tag == 10 then
		WndApartmentAct["_update"..self.m_nTag](WndApartmentAct)
		
		GetElement(self.m_root,"btnRebate",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnTip",WZUIButton):setVisible(true)

		if ProjConfig.LANGUAGE == "vn" then
			GetElement(self.m_root,"btnTip",WZUIButton):setVisible(false)
		end
		return
	end


	--设置活动时间
	self:setActTime()

	for i=1,#self.m_tListItem do
		WZLog("这里2？"..i,self.m_tListItem[i].types,actTypes[tag])
        if self.m_tListItem[i].types == actTypes[tag] then
       		self.m_nCurShowActivityId = tonumber(self.m_tListItem[i].types)
       		self.m_nCurShowActivityType = self.m_tListItem[i].activityId
			local bg_img = self.m_tListItem[i].param2
			self.bg_img = bg_img
        	self:_ActivityContext(self.m_tListItem[i].activityId, self.m_tListItem[i].types, bg_img)
			break
        end
	end

	--红点
	self:updateRedDot()
end

--@brief 	设置活动面板内容
function WndApartmentAct:_ActivityContext( nId, nType, bg_img)
	WZLog("WndApartmentAct:_ActivityContext  nId=",nId ,nType, bg_img, self.m_nTag)
    if self.m_root == nil then return end

	local bgImg11 = GetElement(self.m_root,"bgImg"..self.m_nTag,WZUIImage)
	if bgImg11 ~= nil then 
		--新年用新年背景
		bgImg11:setFile("ui/gameActivity/xnkl_bg_01.png")
	end

	if self.m_nTag ~= 3 then
		if bg_img ~= nil and bg_img ~= "" then
			if string.sub(bg_img,1,4) == "http" then
				--下载底图
				self:downLoadPhoto(bg_img)
			else
				--直接使用已有底图
				local bgImg = GetElement(self.m_root,"bgImg"..self.m_nTag,WZUIImage)
				if bgImg ~= nil and bg_img ~= nil and bg_img ~= "" then bgImg:setFile(bg_img) end
			end
		end
	end

    if nType == 3029 then --代言人七天登录
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(nId,nType)
    elseif nType == 3011 then --真弹一闪
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(nId,nType)
    elseif nType == 3031 then --爱情公寓
        ProtocolProcessorRecharge:send_PURCHASE_GetSummerGiftIdList(ProjConfig.CHANNEL_ID,103)
    elseif nType == 3030 then --夏日专属
        ProtocolProcessorRecharge:send_PURCHASE_GetSummerGiftIdList(ProjConfig.CHANNEL_ID,102)
    elseif nType == 3043 then
        ProtocolProcessorRecharge:send_PURCHASE_GetSummerGiftIdList(ProjConfig.CHANNEL_ID,108)
    elseif nType == 3044 then 
        ProtocolProcessorRecharge:send_PURCHASE_GetSummerGiftIdList(ProjConfig.CHANNEL_ID,109)
    elseif nType == g_tGameActivityTypes.ACIVIITY_CHRISTMASTREE then --圣诞树活动
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetChristmasGiftActivityInfo(nId)
    elseif nType == g_tGameActivityTypes.ACIVIITY_THEMATIC_TASKS then --主题任务
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityTaskList()
    elseif nType == g_tGameActivityTypes.ACTIVITY_SUMMER_REWARD then --赏金猎人
    elseif nType == g_tGameActivityTypes.ACTIVITY_ORDERREDPACK then --口令红包
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(nId, nType)
    elseif nType == g_tGameActivityTypes.ACTIVITY_TYPE_FIREWORK then --烟花
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(nId, nType)
    elseif nType == g_tGameActivityTypes.ACTIVITY_MARK_COIN then --纪念币
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetMarkTaskInfo()
    elseif nType == g_tGameActivityTypes.ACTIVITY_TOW_PACKAGE then --两个礼包
    	ProtocolProcessorRecharge:send_PURCHASE_GetSummerGiftIdList(ProjConfig.CHANNEL_ID, 107)
    end
end

--@brief	判断是否显示充值翻倍
function WndApartmentAct:showAct4()
	WZLog("WndApartmentAct:showAct4", CacheCenter:getGameParam().nianGifeEnd3)
	local temp = os.date("*t", SystemTime:getServerTime())

	local start = CacheCenter:getGameParam().nianGifeEnd3
	local year = tonumber(string.sub(start,1,4))
	local month = tonumber(string.sub(start,6,7))
	local day = tonumber(string.sub(start,9,10))
	if year ~= nil and month ~= nil and day ~= nil and temp.year >= year and temp.month >= month and temp.day >= day then
		return true
	end
	return false
end

--@brief 判断是否能微信分享
--@param element:按钮的父节点
function WndApartmentAct:canWeShare()
	WZLog("WndApartmentAct:canWeShare")
	local hasSdk = false
	for i = 1,#SNSSdkManager.m_tSdkNameList do
        sSdkName = SNSSdkManager.m_tSdkNameList[i]
        if sSdkName == nil then
            return false
        end
        if sSdkName == "com/wyd/weChat/AsynSns" or sSdkName == "wyd_weChat_adapter" then
        	hasSdk = true
        	break
        end
    end
	if hasSdk and CheckButtonShow(133) and SNSSdkManager.getWeChatKey ~= nil and SNSSdkManager:getWeChatKey() then
		return true
	end
	return false
end

-------------------------------------活动1Begin--------------------------------------
function WndApartmentAct:onAct1(tCell,tag,tData,conItem) 
	WZLog("WndApartmentAct:onAct1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)


	local tag = tag
	WZLog("点击按钮:", tag, GlobalGame.g_autoLouraActivity)
	local stats = self.status[tag]
	if stats == -1 or stats == 1 then
		WndItemInfo:onCloseClick()
		
		tData = {
            id = self.rewardItems[tag],
            lastNum = self.rewardCounts[tag],
            lastTime = 1,
            isUse = false,
            data = "",
            playerItemId = -1,
            basicInfo = GetItemLocalData(self.rewardItems[tag])
        }
		WndItemInfo:showInfo(tCell.m_root,WndApartmentAct.m_root,1,tData,false)
	else
		local activityId = self.activityId
		local rewardId = self.rewardId[tag]
		local dayIndex = tag

		WZLog("WndNewActivity:sendProtocolGetReward =",activityId,rewardId,dayIndex)
		if activityId == nil or rewardId == nil or dayIndex == nil then return end
		self.m_nDayIndex = dayIndex
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(activityId,rewardId)
	end
end

--显示UI
function WndApartmentAct:_update1()
	WZLog("WndApartmentAct:_update1 =", type(self.m_nTag), self.m_nTag)
	for i=1,7 do
		local cell = WZUISystem:getInstance():createElement("CellAct1")
       	cell = WZUIContainer:luaTo(cell)
		cell:setVisible(true)
		cell:setTag(i)
		GetElement(self.m_root,"conCell"..i,WZUIContainer):removeAllChildrenWithCleanup(true)
		GetElement(self.m_root,"conCell"..i,WZUIContainer):addChild(cell)
 
	   local celElement,tLuaObj = CellGoodItem:createElement()
	   local tData
       if celElement ~= nil then 
			tData = {
    		    id = self.rewardItems[i],
    		    lastNum = self.rewardCounts[i],
    		    lastTime = 1,
    		    num = self.rewardItemsParamCount[i],
    		    isUse = false,
    		    data = "",
    		    playerItemId = -1,
    		    basicInfo = GetItemLocalData(self.rewardItems[i])
    		}
	    	celElement = WZUIContainer:luaTo(celElement)
            tLuaObj:setCellGoodItem(tData, 20)
            tLuaObj:setItemCount(tostring(tData.num))
            tLuaObj:resetItemNumPt(GlobalMethod:ccp(0.92, 0.07))
            tLuaObj:setItemClickFun(self, self.onAct1)
            celElement:setTag(i)
			GetElement(cell,"gridAtc1",WZUIContainer):addChild(celElement)
       end

		   
		    	

	   --是否已领取
	   GetElement(cell,"conGet",WZUIContainer):setVisible(false)
	   if self.status[i] == 1 then
	   		GetElement(cell,"conGet",WZUIContainer):setVisible(true)
	   end
	   GetElement(cell,"spine1",WZUISpine):setVisible(false)
	   if self.status[i] == 0 then
	   		GetElement(cell,"spine1",WZUISpine):setVisible(true)
	   end

		
	   --天数
	   GetElement(cell,"title_CellAct1",WZUILabelTTF):setText(string.format(LocalStrings.SingInDAYS,i))
	   --礼包名字
	   GetElement(cell,"name_CellAct1",WZUILabelTTF):setText(tData.basicInfo.name)

		
	   local cellBg = GetElement(cell,"cellBg_WndApartmentAct",WZUIImage)
       if i == self.count and self.count ~= 7 then
       		cellBg:setFile("ui/gameActivity/common_qmkh_di_03.png")
       end
	   --第七天
		if i==7 then
			cellBg:setFile("ui/gameActivity/common_qmkh_di_04.png")
			GetElement(cell,"conGet",WZUIContainer):setAbsContentSize(GlobalMethod:CCSize(316,180))
			GetElement(cell,"conGet",WZUIContainer):updateRelativeSize()
			GetElement(cell,"spine1",WZUISpine):setScaleX(2.8)
			GetElement(cell,"spine1",WZUISpine):setScaleY(1.65)
		   	GetElement(cell,"spine1",WZUISpine):setRelativePosition(ccp(0.74,0.53))
		end
	end
end

-------------------------------------活动1End----------------------------------------

-------------------------------------活动2Begin--------------------------------------
--显示UI
function WndApartmentAct:_update2()
	self.exchangeTip = {}
	self.exchangeNum = {}

    local freecon_Act2 = GetElement(self.m_root, "freecon_Act2", WZUIFreeListContainer)
    freecon_Act2:removeAll()

    local nCount = #self.rewardId
    
    local tData = {}
    local nIndex = 1 
	local content = json.decode(self.content)
    for i = 1, nCount do
        local tRewardData = {}
        local tItem = {}
		tItem.count = self.rewardItemsParamCount[i]
        tItem.tRewardData = {}
        tItem.tConsumeData = {}
        tRewardData.id = self.rewardItems[(i - 1)*2 + 1]
        tRewardData.num = self.rewardItems[(i - 1)*2 + 2]
        table.insert(tItem.tRewardData, tRewardData)
        for j = 1, self.rewardItemsParamCount[i] do
            --消耗物品数据
            local tConsumeData = {}
            tConsumeData.id = self.target[nIndex]
            tConsumeData.num = self.target[nIndex + 1]
            table.insert(tItem.tConsumeData, tConsumeData)

            nIndex = nIndex + 2
        end
        tItem.content = content[i]
        tItem.rewardCount = self.rewardCounts[i]
        tItem.rewardId = self.rewardId[i]

        table.insert(tData, tItem)
    end
	WZLog("WndApartmentAct:_update2", Serialize(tData))
    
    for i = 1, nCount do
		local cell, tNewObj = CellAExchangeItem:createElement()
       	cell = WZUIContainer:luaTo(cell)
		tNewObj:setExchangeData(tData[i])
		
		cell:setContentSize(GlobalMethod:CCSize(682, 102))
        cell:setRelativeSize(GlobalMethod:CCSize(1,0.25))
		freecon_Act2:pushBack(cell)
    end

	if self.m_nConListPositionY ~= nil then
    	freecon_Act2:getMoveElement():setPositionY(self.m_nConListPositionY)
	else
    	freecon_Act2:getMoveElement():setPositionY(freecon_Act2:getMinPosition().y)
	end
end

function WndApartmentAct:onItem2(tCell,tag,tData,conItem) 
	WZLog("WndApartmentAct:onItem2")
	WndItemInfo:showInfo(tCell.m_root,WndApartmentAct.m_root,1,tData,false)
end

function WndApartmentAct:setRed2(bool) 
	if self.m_root == nil then return end

end
-------------------------------------活动2End----------------------------------------

-------------------------------------活动3Begin--------------------------------------
--显示UI
function WndApartmentAct:_update3()
	-- local conActivityC = GetElement(self.m_root,"conActivityC_WndSumVacAct",WZUIContainer)
	-- local conActivityContext2 = GetElement(conActivityC,"conActivityContext3_WndApartmentAct",WZUIContainer)

	-- for i=1,4 do
	-- 	GetElement(conActivityContext2,"conA" .. i .. "_WndSumVacAct",WZUIContainer):setVisible(false)
	-- end

	-- for i,v in ipairs(self.m_tPacksFashion) do
	-- 	WZLog("显示ui",Serialize(v))
	-- 	if i > 4 then break end
	-- 	local conA = GetElement(conActivityContext2,"conA" .. i .. "_WndSumVacAct",WZUIContainer)
	-- 	conA:setVisible(true)
	-- 	local conBtn = GetElement(conA,"conBtn_WndSumVacAct",WZUIContainer)
	-- 	local imgSoldOut = GetElement(conA,"imgSoldOut_WndSumVacAct",WZUIImage)
	-- 	local conItemInfo = GetElement(conA,"conItemInfo_WndSumVacAct",WZUIContainer)
	-- 	conItemInfo:removeAllChildrenWithCleanup(true)
	-- 	local txtPrice = GetElement(conA,"txtPrice_WndSumVacAct",WZUILabelTTF)
	-- 	local txtLimitBuyTip = GetElement(conA,"txtLimitBuyTip_WndSumVacAct",WZUILabelTTF)
	-- 	local txtPacksName = GetElement(conA,"txtPacksName_WndSumVacAct",WZUILabelTTF)
	--     local  itemInfo =	GDatatab_item["id_" .. v[11] ]
	--     local txtLimit = GetElement(conA,"txtLimit"..i,WZUIFreeTextBox)
	--     if v[14] == 0 then 
	--     	txtLimit:setVisible(false)
	--     elseif v[14] == 1 then
	--     	txtLimit:setShowText(string.format(LocalStrings.DAY_LIMIT,v[13],v[16]))
	--     elseif v[14] == 2 then
	--     	txtLimit:setShowText(string.format(LocalStrings.TOTAL_LIMIT,v[13],v[16]))
	--     end
	--     txtPacksName:setText(itemInfo.name)
	-- 	txtLimitBuyTip:setText("(" .. LocalStrings.SHOP_DAY_LIMIT .. ":" .. "1" .. LocalStrings.SHOP_CISHU .. ")" )
	-- 	imgSoldOut:setVisible(false)
	-- 	conBtn:setVisible(true)

	-- 	WndNewActivity:updateRechargeInfo(v[5],v[1],v[13])
	-- 	if v[13] <= 0 then
	-- 		txtPrice:setText(LocalStrings.BOUGHT)
	-- 		imgSoldOut:setVisible(true)
	-- 		conBtn:setVisible(false)
	-- 	else
	-- 		txtPrice:setText(v[10] )
	-- 	end
	-- 	local eItem, tItem = CellGoodItem:createElement()
	-- 	eItem:setScale(1)
	-- 	tItem:setItemClickFun(self, self.onItem3)

	-- 	local tData = {
	-- 	    id = v[11],
	-- 	    isUse = false,
	-- 	    data = "",
	-- 	    playerItemId = -1,
	-- 	    lastNum = v[3],
	-- 	    basicInfo = GetItemLocalData(v[11])
	-- 	}
	-- 	tItem:setCellGoodItem(tData, 4)
	-- 	if tItem.m_txtCount ~= nil then
 --    		tItem.m_txtCount:setRelativePosition(ccp(0.92,0.1))
	-- 	end
	-- 	conItemInfo:addChild(eItem)
	-- end
	local conActivityC = GetElement(self.m_root,"conActivityC_WndSumVacAct",WZUIContainer)
	local conActivityContext2 = GetElement(conActivityC,"conActivityContext3_WndApartmentAct",WZUIContainer)
	local tabCon = GetElement(conActivityContext2,"conForReward3_WndApartmentAct",WZUITableContainer)
	tabCon:cleanTable()
-- 	self.m_tPacksFashion = {}
-- 	self.m_tPacksFashion = {
-- [1]={
-- [1]=105,
-- [2]="shopitems/gift_001.png",
-- [3]=1,
-- [4]=0,
-- [5]="6.0",
-- [6]="31",
-- [7]=0,
-- [8]="中级升星礼包",
-- [9]="",
-- [10]="￥6",
-- [11]=1004,
-- [12]=110,
-- [13]=999,
-- [14]=0,
-- [15]=0,
-- [16]=999,
-- },
-- [2]={
-- [1]=187,
-- [2]="shopitems/gift_001.png",
-- [3]=1,
-- [4]=0,
-- [5]="388.0",
-- [6]="47",
-- [7]=0,
-- [8]="中级升星礼包",
-- [9]="8",
-- [10]="￥388",
-- [11]=1004,
-- [12]=192,
-- [13]=999,
-- [14]=0,
-- [15]=0,
-- [16]=999,
-- }
-- }
	self.m_ChoseItem = nil
	self.m_CellDataList = {}
	self.m_CellApartList = {}
	GetElement(self.m_root,"btnBatch",WZUIButton):setVisible(false)
	GetElement(self.m_root,"txtPrice1",WZUILabelTTF):setText("")
	local tab = {}
	local m_index = 0
	for i = 1,#self.m_tPacksFashion do
		local isHave = false
		-- if tab == {} then
		-- 	table.insert(tab,self.m_tPacksFashion[i][11])
		-- end
		if #tab >= 1 then
			for x = 1,#tab do
				if tab[x] == self.m_tPacksFashion[i][11] then
					isHave = true
					break
				end
			end
		end
		WndNewActivity:updateRechargeInfo(self.m_tPacksFashion[i][5],self.m_tPacksFashion[i][1],self.m_tPacksFashion[i][13])
		if not isHave then
			local celElement,tCell = cellApartmentAct3:createElement()
			table.insert(self.m_CellApartList,tCell)
			WZLog("设置的tag值",m_index)
			celElement:setTag(m_index)
			m_index = m_index + 1
	        tabCon:setCellElement(celElement)
	        tCell:setData(self.m_tPacksFashion[i])
	        table.insert(self.m_CellDataList,self.m_tPacksFashion[i])
	        table.insert(tab,self.m_tPacksFashion[i][11])
			if m_index == self.m_nChooseIndex1 then tCell:OnChoose() end
	    end
    end	
end

--选中item
function WndApartmentAct:ChooseItem(tdata)
	WZLog("选中item",tdata[1])
	GetElement(self.m_root,"btnBatch",WZUIButton):setVisible(false)
	for i = 1,#self.m_CellDataList do
		if tdata[11] == self.m_CellDataList[i][11] then
			self.m_nChooseIndex1 = i
			self.m_ChoseItem = self.m_CellDataList[i]
			self.m_CellApartList[i]:setChooseImg(true)
			GetElement(self.m_root,"txtPrice1",WZUILabelTTF):setText(self.m_CellDataList[i][10])

		else 
			self.m_CellApartList[i]:setChooseImg(false)
		end
	end

	local nBulkNum = tdata[3] --批量购买数量
	local x = 0
	for i = 1,#self.m_tPacksFashion do
		if tdata[11] == self.m_tPacksFashion[i][11] then
			x = x + 1
			if self.m_tPacksFashion[i][3] > 1 then
				nBulkNum = self.m_tPacksFashion[i][3]
			end
		end
	end
	if x >= 2 and tdata[13] >= nBulkNum then
		GetElement(self.m_root,"btnBatch",WZUIButton):setVisible(true)
	end
end

function WndApartmentAct:onBuy(element)
	WZLog("WndApartmentAct:onClickBuy ")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_ChoseItem == {} or self.m_ChoseItem == nil then
		MsgBoxManager:showTipBox(LocalStrings.BATCH_WANT_BUY)
	end
	local tag = element:getTag()
	local dataT = self.m_ChoseItem
	local playerInfo = CacheCenter:getPlayerInfo()
	if tag == 1 then
		local data = {
	            ids = dataT[1],
	            icons = dataT[2],--icons[i],
	            number = dataT[3],
	            giftNumber = dataT[4],
	            price = dataT[5],
	            payCodeId = dataT[6],
	            flag = dataT[7],
	            name = dataT[8],
	            remark = dataT[9],
	            showPrice = dataT[10],
	            itemId = dataT[11],
	            sortId = dataT[12],
	            leftTimes = dataT[13],
	            limitType = dataT[14],
	            needVipLv = dataT[15],
	            showType = 1
	        }

	    WZLog("看看看1", data.ids)
	    if data.leftTimes < data.number then
	    	MsgBoxManager:showTipBox(LocalStrings.TRANSACTION46)
	    	return
	    end
		self.tag3 = tag
		self.data3 = data
		--直接购买
		self:buy4(nil, 1)
	elseif tag == 2 then
		local m_data = nil
		for i = 1,#self.m_tPacksFashion do
			if dataT[11] == self.m_tPacksFashion[i][11] and self.m_tPacksFashion[i][3] > 1 then
				m_data = self.m_tPacksFashion[i]
			end
		end
		local data = {
	            ids = m_data[1],
	            icons = m_data[2],--icons[i],
	            number = m_data[3],
	            giftNumber = m_data[4],
	            price = m_data[5],
	            payCodeId = m_data[6],
	            flag = m_data[7],
	            name = m_data[8],
	            remark = m_data[9],
	            showPrice = m_data[10],
	            itemId = m_data[11],
	            sortId = m_data[12],
	            leftTimes = m_data[13],
	            limitType = m_data[14],
	            needVipLv = m_data[15],
	            showType = 1
	        }

	    WZLog("看看看2", data.ids)
	    if data.leftTimes < data.number then
	    	MsgBoxManager:showTipBox(LocalStrings.TRANSACTION46)
	    	return
	    end
		self.tag3 = tag
		self.data3 = data
		
		-- WndBatchBuy:showInterface(data)
		local wndBatchBuy = WndBatchBuy:createElement()
		if wndBatchBuy then
			WindowManager:addWindow(wndBatchBuy,WndBatchBuy,nil,nil,nil,true)
			WndBatchBuy:setData(data)
		end
		
		--直接购买
		-- self:buy3(nil, 1)		
	end

end

--购买
function WndApartmentAct:onClickBuy(element)
	WZLog("WndApartmentAct:onClickBuy ")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local parent = element:getParent()
	parent = parent:getParent()
	parent = WZUIContainer:luaTo(parent)
	local imgSoldOut = GetElement(parent,"imgSoldOut_WndSumVacAct",WZUIImage)
	if imgSoldOut:isVisible() then
		return
	end
	
	local tag = element:getTag()
	local dataT = self.m_tPacksFashion[tag]
	local playerInfo = CacheCenter:getPlayerInfo()
	local data = {
            ids = dataT[1],
            icons = dataT[2],--icons[i],
            number = dataT[3],
            giftNumber = dataT[4],
            price = dataT[5],
            payCodeId = dataT[6],
            flag = dataT[7],
            name = dataT[8],
            remark = dataT[9],
            showPrice = dataT[10],
            itemId = dataT[11],
            sortId = dataT[12],
            leftTimes = dataT[13],
            limitType = dataT[14],
            needVipLv = dataT[15],
            showType = 1
        }

    WZLog("看看看", Serialize(data))

	self.tag3 = tag
	self.data3 = data


	
	--直接购买
	self:buy3(nil, 1)
end

--是否拥有全部橙色坐骑
function WndApartmentAct:ownAllOrangeHorse()
	local tDataList = CacheCenter:getPlayerInfo().allMountsMessage
	local ownNum = 0
	--已拥有的坐骑
	for i=1,#tDataList do
		local tData = json.decode(tDataList[i])
		local mountsId = tData.mountsId
		local itemId = GDatatab_mounts["id_"..mountsId].item_id
		WZLog("拥有的橙色坐骑itemId",itemId)
		--圣诞麋鹿：10007,年兽：10008，熔岩霸龙：10033,冰河雪狮：10034，史诗猛犸:10035,耐萨里奥:10038,月涟漪:10043,调皮杰克:10046,苍井飞飞:10055,魔幻麋鹿车:10056
		if itemId == 10007 or itemId == 10008 or itemId == 10033 or itemId == 10034 or itemId == 10035 
				or itemId == 10038 or itemId == 10043 or itemId == 10046 or itemId == 10055 or itemId == 10056 then
			ownNum = ownNum + 1
		end
	end
	return (ownNum >=10)
end

--是否拥有全部紫色坐骑
function WndApartmentAct:ownAllPurpleHorse()
	local tDataList = CacheCenter:getPlayerInfo().allMountsMessage
	local ownNum = 0
	--已拥有的坐骑
	for i=1,#tDataList do
		local tData = json.decode(tDataList[i])
		local mountsId = tData.mountsId
		local itemId = GDatatab_mounts["id_"..mountsId].item_id
		local name = GDatatab_item["id_"..itemId].name
		WZLog("拥有的橙色坐骑itemId",itemId)
		--旱鸭子：10002,UFO：10003，谷谷鸟：10004,喜鹊：10005，飞翔的南瓜:10006,夜煞:10009,幻羽狮鹫:10026,独角兽:10031,弹弹海盗船:10036,机械沼跃鱼:10039,月夜灵猫：10041
		if name == "旱鸭子" or name == "UFO" or name == "谷谷鸟" or name == "喜鹊" or name == "飞翔的南瓜" or name == "夜煞" 
				or name == "幻羽狮鹫" or name == "独角兽" or name == "弹弹海盗船" or name == "机械沼跃鱼" or name == "月夜灵猫" then
			ownNum = ownNum + 1
		end
	end
	return (ownNum >=11)
end

function WndApartmentAct:buy3(nId, nResType) 
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local data = self.data3
		local playerInfo = CacheCenter:getPlayerInfo()
		
		--剩余次数只有一次时，加购买间隔时间限制
		WZLog("WndApartmentAct:buy3",data.ids)

		local temp = WndNewActivity:bRecharge(data.price,data.ids,playerInfo.id, data.leftTimes)
		if not temp then
		    return
		end
    	
    	if data.limitType ~= 0 and data.leftTimes <= 0 then
    	    MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_COUNT)
    	    return
    	end

    	if data.needVipLv > 0 and CacheCenter.m_tPlayerInfo.vipLevel < data.needVipLv then
    	    MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_VIP)
    	    return
    	end

    	WndVip:createLoadingUI()
    	local sdkData = WndSumVacAct:getSDKData(self.tag3,self.m_tPacksFashion)
    	PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
    	PassportSdkManager:getOrderNum(sdkData)
	end
end

function WndApartmentAct:buy4(nId, nResType) 
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local data = self.data3
		local playerInfo = CacheCenter:getPlayerInfo()
		
		--剩余次数只有一次时，加购买间隔时间限制
		WZLog("WndApartmentAct:buy4",data.ids)
		local temp = WndNewActivity:bRecharge(data.price,data.ids,playerInfo.id, data.leftTimes)
		if not temp then
		    return
		end
    	
    	if data.limitType ~= 0 and data.leftTimes <= 0 then
    	    MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_COUNT)
    	    return
    	end

    	if data.needVipLv > 0 and CacheCenter.m_tPlayerInfo.vipLevel < data.needVipLv then
    	    MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_VIP)
    	    return
    	end

    	WndVip:createLoadingUI()
    	local sdkData = WndApartmentAct:getSDKData()
    	PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
    	PassportSdkManager:getOrderNum(sdkData)
	end
end

--@brief 	转化为待发送的sdk数据
function WndApartmentAct:getSDKData()
	WZLog("WndApartmentAct:getSDKData ",Serialize(self.data3))
	local dataT = self.data3
	local itemInfo = GDatatab_item["id_"..dataT.itemId]
	local productName = itemInfo.name
	local productDesc = dataT.name
	local quantifier = LocalStrings.SHOP_IND
	local number = dataT.number
	if dataT.itemId == 50 or dataT.itemId == 51 or dataT.itemId== 52 or dataT.itemId == 56 then
		quantifier = LocalStrings.Expand
		number = 1
	end
	local sdkData = {
		id = dataT.ids,
		price = dataT.price,
		payCode = dataT.payCodeId,
		productName = productName,
		productDesc = productDesc,
		quantifier = quantifier,
		number = math.max(1,number),
		giftNumber = dataT.giftNumber,
	}
	return sdkData
end


--@brief    发送请求刷新充值进度
--@param   bRecharge：是否为充值活动刷新
function WndApartmentAct:refreshActivityContext(bRecharge)
    WZLog("WndApartmentAct:refreshActivityContext")
    if self.m_root == nil then return end
    if bRecharge then
       	self:_ActivityContext(self.m_nCurShowActivityType,self.m_nCurShowActivityId,self.bg_img)

    end
end

function WndApartmentAct:onItem3(tItem, nTag, tData)
	-- body
	WZLog("WndApartmentAct:onItem3")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WndItemInfo:showInfo(tItem.m_root,WndApartmentAct.m_root,1,tData,false)
end
-------------------------------------活动3End----------------------------------------

-------------------------------------活动4Begin--------------------------------------
--显示UI
function WndApartmentAct:_update4()
	
end

function WndApartmentAct:onAct4(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local p = element:getParent()
    p = WZUIContainer:luaTo(p)
	local tag = p:getTag()
	WZLog("WndApartmentAct:onAct4", tag)

	WndVip:showWndUI(0)

end

--@brief 	更新标签红点
function WndApartmentAct:updateRedDot()
	-- body
	if self.m_root == nil then return end 

	for i = 1, #self.m_tAllActivityType do
		local imgRed = GetElement(self.m_root, "imgRed" .. i .. "_WndApartmentAct", WZUIImage)
		if imgRed then 
			imgRed:setVisible(false)
		end
		if CacheCenter.m_tApartmentRedDotList then
			for j = 1, #CacheCenter.m_tApartmentRedDotList do
				if CacheCenter.m_tApartmentRedDotList[j] == self.m_tAllActivityType[i] then
					if imgRed then 
						imgRed:setVisible(true)
					end
				end
			end
		end
	end
end
-------------------------------------活动4End----------------------------------------

-------------------------------------活动5Begin--------------------------------------
--显示UI
function WndApartmentAct:_update5()
	WZLog("WndApartmentAct:_update5", CacheCenter:getGameParam().wechatFirstShareRewardPerDay)

	local con = GetElement(self.m_root,"conActivityContext5_WndApartmentAct",WZUIContainer)
	addWeChatBtn(con,10,GlobalMethod:ccp(0.85,0.11),1)


	local reward = CacheCenter:getGameParam().wechatFirstShareRewardPerDay
	if gWeChatShareReward ~= nil and gWeChatShareReward ~= "" then
		reward = gWeChatShareReward
	end
	if reward == nil or reward == "" then return end
	local ids,nums = SplitItemString(reward)
	for i=1,math.min(#ids,3) do
		   local celElement,tLuaObj = CellGoodItem:createElement()
		   local id = ids[i]
           if celElement ~= nil then 
				tItem = {
        		    id = id,
        		    lastNum = nums[i],
        		    lastTime = 1,
        		    isUse = false,
        		    data = "",
        		    playerItemId = -1,
        		    basicInfo = GDatatab_item["id_"..id]
        		}
		    	celElement = WZUIContainer:luaTo(celElement)
                tLuaObj:setCellGoodItem(tItem, 4)
                tLuaObj:setItemClickFun(self, self.onItem2)
                celElement:setTag(1)
				
				GetElement(self.m_root,"reward"..i,WZUIContainer):removeAllChildrenWithCleanup(true)
				GetElement(self.m_root,"reward"..i,WZUIContainer):addChild(celElement)
           end
	end
end
-------------------------------------活动5End----------------------------------------

-------------------------------------活动6Begin--------------------------------------
--显示UI
function WndApartmentAct:_update6()
    local pgconCopy = GetElement(self.m_root, "pgCon_WndApartmentAct", WZUIPageContainer)
	pgconCopy:removeAll()

	local imgs = {"lyx_pictur5","lyx_pictur6"}

	for i=1,2 do
		local cell = WZUISystem:getInstance():createElement("CellAdvertis")
       	cell = WZUIContainer:luaTo(cell)
		cell:setVisible(true)
		cell:setTag(i-1)
		pgconCopy:setPageElement(i-1,cell)

		GetElement(cell,"img_WndAdvertising",WZUIImage):setFile("ui/gameActivity/lyx/"..imgs[i]..".png")
	end
	pgconCopy:setDefaultCenterPage(0)
end

function WndApartmentAct:onJump(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local p = element:getParent()
	p = p:getParent()
    p = WZUIContainer:luaTo(p)
	local tag = tonumber(p:getTag()) + 1
	WZLog("WndApartmentAct:onJump", tag)
end

function WndApartmentAct:turnPage()
	if self.m_nTag ~= 6 then return end
    local pgconCopy = GetElement(self.m_root, "pgCon_WndApartmentAct", WZUIPageContainer)
	self.m_nCurPage = pgconCopy:getCurrentPageIndex()
	self.m_nCurPage = self.m_nCurPage + 1
	self.m_nCurPage = self.m_nCurPage % 2
	pgconCopy:setDefaultCenterPage(self.m_nCurPage)
end
-------------------------------------活动6End----------------------------------------

-------------------------------------活动7Begin--------------------------------------
function WndApartmentAct:_update7()

end

--夏日专属
function WndApartmentAct:onClickRecharge2(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if GlobalGame.g_autoLouraActivity ~= 1 then
    	MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
    	return
    end
		
	local dataT = self.m_tPacksFashion7[1]
	local playerInfo = CacheCenter:getPlayerInfo()
	local data = {
	        ids = dataT[1],
	        icons = dataT[2],--icons[i],
	        number = dataT[3],
	        giftNumber = dataT[4],
	        price = dataT[5],
	        payCodeId = dataT[6],
	        flag = dataT[7],
	        name = dataT[8],
	        remark = dataT[9],
	        showPrice = dataT[10],
	        itemId = dataT[11],
	        sortId = dataT[12],
	        leftTimes = dataT[13],
	        limitType = dataT[14],
	        needVipLv = dataT[15],
	        showType = 1
	    }

	WZLog("WndApartmentAct:onClickRecharge2",self.giftId7, data.itemId)
	self.data7 = data


	
	--检查是否拥有礼包中物品
	local own,text = checkGiftOwn(self.giftId7)
	if own then
		MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.OWN1, text), self, self.buy7, nil, nil)
	else
		self:buy7(nil, 1)
	end
end

function WndApartmentAct:buy7(nId, nResType) 
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local data = self.data7
		local playerInfo = CacheCenter:getPlayerInfo()
		--剩余次数只有一次时，加购买间隔时间限制
		WZLog("WndApartmentAct:buy9", data.leftTimes)
		if data.leftTimes <= 1 then
			local temp = WndNewActivity:bRecharge(data.price,data.ids,playerInfo.id)
			if not temp then
			    return
			end
		end

		if data.limitType ~= 0 and data.leftTimes <= 0 then
		    MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_COUNT)
		    return
		end

		if data.needVipLv > 0 and CacheCenter.m_tPlayerInfo.vipLevel < data.needVipLv then
		    MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_VIP)
		    return
		end

		WndVip:createLoadingUI()
		local sdkData = WndSumVacAct:getSDKData(1, self.m_tPacksFashion7)
		PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
		PassportSdkManager:getOrderNum(sdkData)
	end
end

-------------------------------------活动7End----------------------------------------

-------------------------------------活动8Begin--------------------------------------
function WndApartmentAct:_update8()

end

--夏日专属2
function WndApartmentAct:onClickRecharge8(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if GlobalGame.g_autoLouraActivity ~= 1 then
    	MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
    	return
    end
		
	local dataT = self.m_tPacksFashion8[1]
	local playerInfo = CacheCenter:getPlayerInfo()
	local data = {
	        ids = dataT[1],
	        icons = dataT[2],--icons[i],
	        number = dataT[3],
	        giftNumber = dataT[4],
	        price = dataT[5],
	        payCodeId = dataT[6],
	        flag = dataT[7],
	        name = dataT[8],
	        remark = dataT[9],
	        showPrice = dataT[10],
	        itemId = dataT[11],
	        sortId = dataT[12],
	        leftTimes = dataT[13],
	        limitType = dataT[14],
	        needVipLv = dataT[15],
	        showType = 1
	    }

	WZLog("WndApartmentAct:onClickRecharge2",self.giftId8, data.itemId)
	self.data8 = data


	--检查是否拥有时装
	if gCheckHaveOrNot(self.giftId8) then
		MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.OWN1, GDatatab_item["id_"..self.giftId8].name), self, self.buy8, nil)
	else
		self:buy8(nil, 1)
	end

end

function WndApartmentAct:buy8(nId, nResType) 
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local data = self.data8
		local playerInfo = CacheCenter:getPlayerInfo()

		--剩余次数只有一次时，加购买间隔时间限制
		WZLog("WndApartmentAct:buy9", data.leftTimes)
		if data.leftTimes <= 1 then
			local temp = WndNewActivity:bRecharge(data.price,data.ids,playerInfo.id)
			if not temp then
			    return
			end
		end

		if data.limitType ~= 0 and data.leftTimes <= 0 then
		    MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_COUNT)
		    return
		end

		if data.needVipLv > 0 and CacheCenter.m_tPlayerInfo.vipLevel < data.needVipLv then
		    MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_VIP)
		    return
		end

		WndVip:createLoadingUI()
		local sdkData = WndSumVacAct:getSDKData(1, self.m_tPacksFashion8)
		PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
		PassportSdkManager:getOrderNum(sdkData)
	end
end

-------------------------------------活动8End----------------------------------------

-------------------------------------活动9Begin--------------------------------------
--显示UI
function WndApartmentAct:_update9()
	local conActivityC = GetElement(self.m_root,"conActivityC_WndSumVacAct",WZUIContainer)
	local conActivityContext2 = GetElement(self.m_root,"conActivityContext3_WndApartmentAct",WZUIContainer)

	for i=1,4 do
		GetElement(self.m_root,"conA" .. i .. "_WndApartmentAct",WZUIContainer):setVisible(false)
	end
	local giftRole = GetElement(self.m_root,"giftRole",WZUIImage)
 	if #self.m_tPacksFashion9 > 3 then
 		giftRole:setRelativePosition(GlobalMethod:ccp(1.038,0.261))
 	else
 		giftRole:setRelativePosition(GlobalMethod:ccp(0.9,0.261))
 	end

	for i,v in ipairs(self.m_tPacksFashion9) do
		if i > 4 then 
			WndNewActivity:updateRechargeInfo(v[5],v[1],v[13])
		else
			local conA = GetElement(self.m_root,"conA" .. i .. "_WndApartmentAct",WZUIContainer)
			conA:setVisible(true)
			local conBtn = GetElement(conA,"conBtn_WndApartmentAct",WZUIContainer)
			local imgSoldOut = GetElement(conA,"imgSoldOut_WndApartmentAct",WZUIImage)
			local conItemInfo = GetElement(conA,"conItemInfo_WndApartmentAct",WZUIContainer)
			conItemInfo:removeAllChildrenWithCleanup(true)
			local txtPrice = GetElement(conA,"txtPrice_WndApartmentAct",WZUILabelTTF)
			local txtLimitBuyTip = GetElement(conA,"txtLimitBuyTip_WndApartmentAct",WZUILabelTTF)
			local txtPacksName = GetElement(conA,"txtPacksName_WndApartmentAct",WZUILabelTTF)
		    local txtLimit = GetElement(conA,"txtLimit"..i,WZUIFreeTextBox)
		    if v[14] == 0 then 
		    	txtLimit:setVisible(false)
		    elseif v[14] == 1 then
		    	txtLimit:setShowText(string.format(LocalStrings.DAY_LIMIT,v[13],v[16]))
		    elseif v[14] == 2 then
		    	txtLimit:setShowText(string.format(LocalStrings.TOTAL_LIMIT,v[13],v[16]))
		    end
		    local  itemInfo =	GDatatab_item["id_" .. v[11] ]
		    txtPacksName:setText(itemInfo.name)
			txtLimitBuyTip:setText("(" .. LocalStrings.SHOP_DAY_LIMIT .. ":" .. "1" .. LocalStrings.SHOP_CISHU .. ")" )
			imgSoldOut:setVisible(false)
			conBtn:setVisible(true)

			WndNewActivity:updateRechargeInfo(v[5],v[1],v[13])
			if v[13] <= 0 then
				txtPrice:setText(LocalStrings.BOUGHT)
				imgSoldOut:setVisible(true)
				conBtn:setVisible(false)
			else
				txtPrice:setText(v[10] )
			end
			local eItem, tItem = CellGoodItem:createElement()
			eItem:setScale(1)
			tItem:setItemClickFun(self, self.onItem3)

			local tData = {
			    id = v[11],
			    isUse = false,
			    data = "",
			    playerItemId = -1,
			    lastNum = v[3],
			    basicInfo = GetItemLocalData(v[11])
			}
			tItem:setCellGoodItem(tData, 4)
			if tItem.m_txtCount ~= nil then
	    		tItem.m_txtCount:setRelativePosition(ccp(0.92,0.1))
			end
			conItemInfo:addChild(eItem)
		end
	end

	GetElement(self.m_root,"conA4_WndApartmentAct",WZUIContainer):setVisible(false)

	-- if #self.m_tPacksFashion9 == 2 then 
	-- 	GetElement(self.m_root, "conForReward9_WndApartmentAct", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6, 0.5))
	-- elseif #self.m_tPacksFashion9 == 1 then 
	-- 	GetElement(self.m_root, "conForReward9_WndApartmentAct", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.7, 0.5))
	-- end
end

--购买
function WndApartmentAct:onClickBuy9(element)
	WZLog("WndApartmentAct:onClickBuy ")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local parent = element:getParent()
	parent = parent:getParent()
	parent = WZUIContainer:luaTo(parent)
	local imgSoldOut = GetElement(parent,"imgSoldOut_WndApartmentAct",WZUIImage)
	if imgSoldOut:isVisible() then
		return
	end
	
	local tag = element:getTag()
	local dataT = self.m_tPacksFashion9[tag]
	local playerInfo = CacheCenter:getPlayerInfo()
	local data = {
            ids = dataT[1],
            icons = dataT[2],--icons[i],
            number = dataT[3],
            giftNumber = dataT[4],
            price = dataT[5],
            payCodeId = dataT[6],
            flag = dataT[7],
            name = dataT[8],
            remark = dataT[9],
            showPrice = dataT[10],
            itemId = dataT[11],
            sortId = dataT[12],
            leftTimes = dataT[13],
            limitType = dataT[14],
            needVipLv = dataT[15],
            showType = 1
        }

    
	self.tag9 = tag
	self.data9 = data



	--直接购买
	self:buy9(nil, 1)
end

function WndApartmentAct:buy9(nId, nResType) 
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local data = self.data9
		local playerInfo = CacheCenter:getPlayerInfo()
		--剩余次数只有一次时，加购买间隔时间限制
		WZLog("WndApartmentAct:buy9", data.leftTimes)
		--if data.leftTimes <= 1 then
    		local temp = WndNewActivity:bRecharge(data.price,data.ids,playerInfo.id, data.leftTimes)
    		if not temp then
    		    return
    		end
		--end

    	if data.limitType ~= 0 and data.leftTimes <= 0 then
    	    MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_COUNT)
    	    return
    	end

    	if data.needVipLv > 0 and CacheCenter.m_tPlayerInfo.vipLevel < data.needVipLv then
    	    MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_VIP)
    	    return
    	end

    	WndVip:createLoadingUI()
    	local sdkData = WndSumVacAct:getSDKData(self.tag9,self.m_tPacksFashion9)
    	PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
    	PassportSdkManager:getOrderNum(sdkData)
	end
end
-------------------------------------活动9End----------------------------------------

-------------------------------------活动10 神秘商店Start----------------------------------------
function WndApartmentAct:_update10()
	WZLog("WndApartmentAct:_update10")
	ProtocolProcessorWndShop:send_MALL_GetDiscountStore( )

	local con = GetElement(self.m_root,"conActivityContext10_WndApartmentAct",WZUIContainer)
	con:enableSchedule("_countDown10",1)
end

function WndApartmentAct:setData10(status, id, gainNum, itemId, costId, price, discount, leftNum, startDateStr, endDateStr, countdown) 
	if self.m_root == nil then return end

	self.m_tDataList10 = {}	
	for i=1,#id do
		local data = {}
		data.id = id[i]
		data.gainNum = gainNum[i]
		data.itemId = itemId[i]
		data.costId = costId[i]
		data.price = price[i]
		data.discount = discount[i]
		data.leftNum = leftNum[i]
		table.insert(self.m_tDataList10, data)
	end
	self.status10 = status
	self.startDateStr10 = startDateStr
	self.endDateStr10 = endDateStr
	self.leftTime10 = countdown
	WZLog("WndApartmentAct:setData10", Serialize(self.m_tDataList10))
	WndApartmentAct:update10()
end

function WndApartmentAct:update10() 
	WZLog("WndApartmentAct:update10")
	if self.m_root == nil then return end 
	local tbCon = GetElement(self.m_root,"tbCon_WndRebate",WZUITableContainer)
	tbCon:cleanTable()

	--没有数据时显示提示
	if self.m_tDataList10 == nil or #self.m_tDataList10 == 0 then 
		do return end
	end

	for i=1,#self.m_tDataList10 do
		local celElement,tCell = CellRebateMini:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tDataList10[i])
			celElement:setTag(i-1)
			tbCon:setCellElement(celElement)
		end 
	end

	--活动时间
	if self.startDateStr10 ~= nil and self.endDateStr10 ~= nil then
		local startDateStr10 = SplitStringWithSeparator(self.startDateStr10,"-")
		local endDateStr10 = SplitStringWithSeparator(self.endDateStr10,"-")
		local date = string.format(LocalStrings.ACTIVITY_TIMELINE_KEY, tonumber(startDateStr10[1]), tonumber(startDateStr10[2]), tonumber(endDateStr10[1]), tonumber(endDateStr10[2]))
		GetElement(self.m_root,"txtDate",WZUILabelTTF):setText(date)
	end
	--贿赂消耗
	local briberyCost = CacheCenter:getGameParam().briberyCost
	local costId, costNum = SplitItemString(briberyCost)
	GetElement(self.m_root,"imgCost",WZUIImage):setFile(GDatatab_item["id_"..costId[1]].icon)
	GetElement(self.m_root,"imgCost1",WZUIImage):setFile(GDatatab_item["id_"..costId[1]].icon)
	GetElement(self.m_root,"txtCostBtn",WZUILabelTTF):setText(costNum[1])
	GetElement(self.m_root,"txtCostBtn1",WZUILabelTTF):setText(costNum[1])
	--刷新消耗
	local discountStoreRefreshCost = CacheCenter:getGameParam().discountStoreRefreshCost
	local costId, costNum = SplitItemString(discountStoreRefreshCost)
	GetElement(self.m_root,"txtCostCount_WndRebate",WZUILabelTTF):setText(costNum[1])

	GetElement(self.m_root,"tip1",WZUILabelTTF):setText(string.format(LocalStrings.EVERYDAY_REFRESH_TIME, "00:00:00"))
	local ftxtRefreshCost = GetElement(self.m_root, "ftxtRefreshCost__WndApartmentAct", WZUIFreeTextBox)
	if ftxtRefreshCost then
		local costIcon = GDatatab_item["id_" .. costId[1]].icon
		local sFormat = [[<I Z="0.35">%s</I><T C="255,236,193" S="14" P="1" SC="229,105,22" SE="1" SS="4">%d%s</T>]]
		ftxtRefreshCost:setShowText(string.format(sFormat, costIcon, costNum[1], LocalStrings.REFRESH))
		WZLog("WndApartmentAct:update10 &&&&&", string.format(sFormat, costIcon, costNum[1], LocalStrings.REFRESH))
	end

	--贿赂状态
	if self.status10 == 0 then
		GetElement(self.m_root,"btnRebate",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root,"txtRebate",WZUILabelTTF):setText(LocalStrings.REBATE1)
		
		local n = 0
		for i=1,#self.m_tDataList10 do
			if self.m_tDataList10[i].leftNum > 0 then
				n = n + 1
			end
		end
		if n < 5 then
			GetElement(self.m_root,"txtRebate",WZUILabelTTF):setText(LocalStrings.REBATE9)
			return
		end
	elseif self.status10 == 1 then
		GetElement(self.m_root,"btnRebate",WZUIButton):setTouchEnable(false)
		GetElement(self.m_root,"txtRebate",WZUILabelTTF):setText(LocalStrings.REBATE4)
	end
end

function WndApartmentAct:clickSureMoney() 
	WZLog("WndApartmentAct:clickSureMoney", self.buyId10)
	ProtocolProcessorWndShop:send_MALL_DiscountStorePurchase(self.buyId10 )
end

--刷新
function WndApartmentAct:onRefresh(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local discountStoreRefreshCost = CacheCenter:getGameParam().discountStoreRefreshCost
	local costId, costNum = SplitItemString(discountStoreRefreshCost)

	if not JudgeMoneyIsEnough(tonumber(costId[1]), tonumber(costNum[1]), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onRefresh1) then 
		return 
	end
	self:onRefresh1()
end

function WndApartmentAct:onRefresh1() 
	local tip = false
	for i=1,#self.m_tDataList10 do
		if self.m_tDataList10[i].discount ~= 0 and self.m_tDataList10[i].leftNum > 0 then
			tip = true
			break
		end
	end

	local discountStoreRefreshCost = CacheCenter:getGameParam().discountStoreRefreshCost
	local costId, costNum = SplitItemString(discountStoreRefreshCost)
	
	if tip then
		local msg1 = string.format(LocalStrings.REBATE8, tostring(costNum[1]))	
    	MsgBoxManager:showConfirmCancelBox(msg1, self, self.onRefreshConfirm, MSGBOXLEVEL_NORMAL, nil)
	else
		ProtocolProcessorWndShop:send_MALL_DiscountStoreRefresh( )
	end
end

function WndApartmentAct:onRefreshConfirm(nId, nResType)
	WZLog("WndApartmentAct:onRefreshConfirm")
	if nResType == MSGBOXRESTYPE_CONFIRM then
		ProtocolProcessorWndShop:send_MALL_DiscountStoreRefresh( )
    end
end

--贿赂
function WndApartmentAct:onRebate(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local n = 0
	for i=1,#self.m_tDataList10 do
		if self.m_tDataList10[i].leftNum > 0 then
			n = n + 1
		end
	end
	if n < 5 then
		MsgBoxManager:showTipBox(LocalStrings.REBATE7)
		return
	end

	local briberyCost = CacheCenter:getGameParam().briberyCost
	local costId, costNum = SplitItemString(briberyCost)
	if not JudgeMoneyIsEnough(tonumber(costId[1]), tonumber(costNum[1]), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onRebate1) then 
		return 
	end
	self:onRebate1()
end

function WndApartmentAct:onRebate1() 
	local briberyCost = CacheCenter:getGameParam().briberyCost
	local discountRange = CacheCenter:getGameParam().discountRange
	WZLog("WndApartmentAct:onRebate1", discountRange)
	local costId, costNum = SplitItemString(briberyCost)
	local discountValue1, discountValue2 = SplitItemString(discountRange)
	local msg1 = string.format(LocalStrings.REBATE6, tostring(costNum[1]), discountValue1[1], discountValue2[1])	
	MsgBoxManager:showConfirmBoxWithBg(msg1, self, self.onRebateConfirm, MSGBOXLEVEL_HIGH, {[MSGBOXUICFG_USEFREETXT] = true})
end

function WndApartmentAct:onRebateConfirm()
	WZLog("WndApartmentAct:onRebateConfirm")
	ProtocolProcessorWndShop:send_MALL_DiscountStoreBribery()
end

--刷新倒计时
function WndApartmentAct:_countDown10() 
	if self.m_root == nil then return end

	if self.leftTime10 == nil then self.leftTime10 = 86400 end
	self.leftTime10 = self.leftTime10 - 1
	--倒计时完刷新商品
	if self.leftTime10 < 0 then
		self.leftTime10 = 86400
		ProtocolProcessorWndShop:send_MALL_GetDiscountStore( )
	end

	local left = self.leftTime10
	GetElement(self.m_root,"txtCountDown",WZUILabelTTF):setText(utilsFormatTime(left))
end
-------------------------------------活动10 神秘商店End----------------------------------------
--@brief 口令红包收到协议回调
function WndApartmentAct:_update15()
	-- body
	WZLog("WndApartmentAct:_update15")
	if self.m_tCellElement then
		self.m_tCellElement:setMessage(self.startTime, self.endTime, self.tips, self.count, self.maxCount, self.rewardCounts)
	end
end

--@brief 	放烟花收到协议回调
function WndApartmentAct:_update16()
	-- body
	WZLog("WndApartmentAct:_update16")
	if self.m_tCellElement then
		self.m_tCellElement:setMessage(self.activityId, self.startTime, self.endTime, self.rewardCounts, self.rewardId, self.count)
	end
end
-------------------------------------私有方法模块End----------------------------------------
function WndApartmentAct:setStaticText()
	GetElement(self.m_root,"txt11",WZUILabelTTF):setText(LocalStrings.ACTIVE_TIME..":")
end


function WndApartmentAct:setActTime()
	self.m_nTag = self.m_nTag or 1

	local actTypes = self.m_tAllActivityType
	local tips = {LocalStrings.LOURAACT7,LocalStrings.LOURAACT8,""}
    local startT = nil
    local endT = nil
    local disappearTime = nil 
    for i,v in ipairs(self.m_tListItem) do
        if v.types == actTypes[self.m_nTag] then
            startT = v.startTime
            endT = v.endTime
            disappearTime = v.disappearTime
            break
        end
    end
	
	self.endTime = endT
	self.m_nDisappearTime = disappearTime

    
	local start_time = SystemTime:getTimeConverLocal1(startT)
	local end_time = SystemTime:getTimeConverLocal1(endT)
	
	if ProjConfig.LANGUAGE == "vn" then
		start_time = SystemTime:getTimeConverLocal6(startT)
		end_time = SystemTime:getTimeConverLocal6(endT)
	end

	local actT = start_time .. "-" .. end_time
	GetElement(self.m_root,"txt11_1",WZUILabelTTF):setText(actT)
	local txt_label = tips[self.m_nTag] or ""
	GetElement(self.m_root,"txt12",WZUILabelTTF):setText(txt_label)

	if self.m_nTag == 11 then 
		
		GetElement(self.m_root,"txt11",WZUILabelTTF):setText("")
		GetElement(self.m_root,"txt12",WZUILabelTTF):setText("")
	end
end

function WndApartmentAct:onRuleClick(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndApartmentAct:onRuleClick", CacheCenter:getGameParam().summerActivityNote)
    if self.m_nTag == 11 then
    	WndSingleMapDesc:showInterface1(LocalStrings.CHRISTMASTREE_TEXT9)
    elseif self.m_nTag == 17 then 
    	WndSingleMapDesc:showInterface(LocalStrings.THREE_YEAR_TEXT4, nil)
    else
    	
    	WndSingleMapDesc:showInterface(CacheCenter:getGameParam().summerActivityNote, nil)
    end
end

--@brief	下载图片
function WndApartmentAct:downLoadPhoto(url)
	local bgImg = GetElement(self.m_root,"bgImg"..self.m_nTag,WZUIImage)
	if bgImg == nil then return end

	local downURL = url
	local photoName = self:getFileName(downURL)

	downURL = downURL:gsub("\n","")
	downURL = downURL:gsub("\r","")
	--如果文件存在，不下载，直接使用
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..photoName
	local bExist = WZFileUtil:isFileExist(path)
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	WZLog("判断文件是否存在",path,photoName)
	if bExist then
		bgImg:setVisible(true)
		bgImg:setUseOriginSize(true)
		bgImg:setFile(path)
	elseif downURL ~= "" then
		if platForm == 3 then
			path = photoName
		end
		local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
		local downloadTask = WZHTTPFileLuaTask:create(CacheCenter:getPlayerInfo().id, downURL, path, self.downLoadPhotoBackFun, self)
		multiThread:addDownloadTaskInFront(downloadTask)
	end
end

function WndApartmentAct:getFileName(filename)
	local dest_filename = ""
	fn_flag = string.find(filename, "\\")
	if fn_flag then
		dest_filename = string.match(filename, ".+\\([^\\]*%.%w+)$")
	end
	
	fn_flag = string.find(filename, "/")
	if fn_flag then
		dest_filename = string.match(filename, ".+/([^/]*%.%w+)$")
	end
	return dest_filename
end

--@brief 	下载图片回调函数
function WndApartmentAct:downLoadPhotoBackFun(taskId, path, totalSize, nowSize, finish, failed)
	WZLog("WndApartmentAct:downLoadPhotoBackFun",taskId,finish,path,failed)
	if taskId ~= CacheCenter:getPlayerInfo().id then return end

	if self.m_root == nil then
		return
	elseif finish then
		WZLog("WndApartmentAct:downLoadPhotoBackFun_1",path)
		local bgImg = GetElement(self.m_root,"bgImg"..self.m_nTag,WZUIImage)
		bgImg:setVisible(true)
		bgImg:setUseOriginSize(true)
		bgImg:setFile(path)
	else
		WZLog("taskId:::::::::::::::::::::::::::::::",taskId)
	end
end

--@brief 	购买后更新限购状态
function WndApartmentAct:updateButLimitState(nCurShowActivityId)
	-- body
	if nCurShowActivityId == 3030 then 
	elseif nCurShowActivityId == 3031 then
	elseif nCurShowActivityId == 3043 then
	elseif nCurShowActivityId == 3044 then
	elseif nCurShowActivityId == 3054 then
	end
end

-------------------------------------语言适配begin--------------------------------------
function WndApartmentAct:_adaptLanguage_vn( )
	for i=1, 16 do
		local txtAct = GetElement(self.m_root,"txtAct"..i,WZUILabelTTF)
		local txtActsel = GetElement(self.m_root,"txtAct"..i.."_sel",WZUILabelTTF)
		if txtAct and txtActsel then
			txtAct:setScale(0.7)
			txtAct:setDimensions(GlobalMethod:CCSize(140))
			txtAct:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
			txtActsel:setScale(0.7)
			txtActsel:setDimensions(GlobalMethod:CCSize(140))
			txtActsel:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
		end
	end
	for i = 1, 4 do
		--3043
		local conItem = GetElement(self.m_root,"conItem"..i.."_ApartmentAct8",WZUIContainer)
		local txtItemName = GetElement(conItem,"txtItemName_WndApartmentAct",WZUILabelTTF)
		txtItemName:setScale(0.6)
		txtItemName:setDimensions(GlobalMethod:CCSize(200))
		--3031
		local conA = GetElement(self.m_root,"conA"..i.."_WndSumVacAct",WZUIContainer)
		local txtPacksName = GetElement(conA,"txtPacksName_WndSumVacAct",WZUILabelTTF)
		txtPacksName:setScale(0.6)
		txtPacksName:setDimensions(GlobalMethod:CCSize(200))
		GetElement(conA,"txtPrice_WndSumVacAct",WZUILabelTTF):setScale(0.7)
		--3030
		local conA = GetElement(self.m_root,"conItem"..i.."_ApartmentAct7",WZUIContainer)
		local txtItemName = GetElement(conA,"txtItemName_WndSumVacAct",WZUILabelTTF)
		txtItemName:setScale(0.6)
		txtItemName:setDimensions(GlobalMethod:CCSize(200))
	end
	for i = 1, 3 do
		--3044
		local conA = GetElement(self.m_root,"conA"..i.."_WndApartmentAct",WZUIContainer)
		local txtPacksName = GetElement(conA,"txtPacksName_WndApartmentAct",WZUILabelTTF)
		txtPacksName:setScale(0.6)
		txtPacksName:setDimensions(GlobalMethod:CCSize(200))
		GetElement(conA,"txtPrice_WndApartmentAct",WZUILabelTTF):setScale(0.7)
	end


	for i=1,4 do
		local conActivityContext3 = GetElement(self.m_root,"conActivityContext9_WndApartmentAct",WZUIContainer)
		local txtLimit = GetElement(conActivityContext3,"txtLimit"..i,WZUIFreeTextBox)
		txtLimit:setScale(0.9)
	end
end

function WndApartmentAct:_adaptLanguage_en( )
	for i=1, 16 do
		local txtAct = GetElement(self.m_root,"txtAct"..i,WZUILabelTTF)
		local txtActsel = GetElement(self.m_root,"txtAct"..i.."_sel",WZUILabelTTF)
		if txtAct and txtActsel then
			txtAct:setScale(0.7)
			txtAct:setDimensions(GlobalMethod:CCSize(140))
			txtAct:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
			txtActsel:setScale(0.7)
			txtActsel:setDimensions(GlobalMethod:CCSize(140))
			txtActsel:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
		end
	end
	for i = 1, 4 do
		--3043
		local conItem = GetElement(self.m_root,"conItem"..i.."_ApartmentAct8",WZUIContainer)
		local txtItemName = GetElement(conItem,"txtItemName_WndApartmentAct",WZUILabelTTF)
		txtItemName:setScale(0.6)
		txtItemName:setDimensions(GlobalMethod:CCSize(200))
		--3031
		local conA = GetElement(self.m_root,"conA"..i.."_WndSumVacAct",WZUIContainer)
		local txtPacksName = GetElement(conA,"txtPacksName_WndSumVacAct",WZUILabelTTF)
		txtPacksName:setScale(0.6)
		txtPacksName:setDimensions(GlobalMethod:CCSize(200))
		--3030
		local conA = GetElement(self.m_root,"conItem"..i.."_ApartmentAct7",WZUIContainer)
		local txtItemName = GetElement(conA,"txtItemName_WndSumVacAct",WZUILabelTTF)
		txtItemName:setScale(0.6)
		txtItemName:setDimensions(GlobalMethod:CCSize(200))
	end
	for i = 1, 3 do
		--3044
		local conA = GetElement(self.m_root,"conA"..i.."_WndApartmentAct",WZUIContainer)
		local txtPacksName = GetElement(conA,"txtPacksName_WndApartmentAct",WZUILabelTTF)
		txtPacksName:setScale(0.6)
		txtPacksName:setDimensions(GlobalMethod:CCSize(200))
	end
end

function WndApartmentAct:_adaptLanguage_pt( )
	for i=1, 16 do
		local txtAct = GetElement(self.m_root,"txtAct"..i,WZUILabelTTF)
		local txtActsel = GetElement(self.m_root,"txtAct"..i.."_sel",WZUILabelTTF)
		if txtAct and txtActsel then
			txtAct:setScale(0.7)
			txtAct:setDimensions(GlobalMethod:CCSize(140))
			txtAct:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
			txtActsel:setScale(0.7)
			txtActsel:setDimensions(GlobalMethod:CCSize(140))
			txtActsel:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
		end
	end
	for i = 1, 4 do
		--3043
		local conItem = GetElement(self.m_root,"conItem"..i.."_ApartmentAct8",WZUIContainer)
		local txtItemName = GetElement(conItem,"txtItemName_WndApartmentAct",WZUILabelTTF)
		txtItemName:setScale(0.6)
		txtItemName:setDimensions(GlobalMethod:CCSize(200))
		--3031
		local conA = GetElement(self.m_root,"conA"..i.."_WndSumVacAct",WZUIContainer)
		local txtPacksName = GetElement(conA,"txtPacksName_WndSumVacAct",WZUILabelTTF)
		txtPacksName:setScale(0.6)
		txtPacksName:setDimensions(GlobalMethod:CCSize(200))
		--3030
		local conA = GetElement(self.m_root,"conItem"..i.."_ApartmentAct7",WZUIContainer)
		local txtItemName = GetElement(conA,"txtItemName_WndSumVacAct",WZUILabelTTF)
		txtItemName:setScale(0.6)
		txtItemName:setDimensions(GlobalMethod:CCSize(200))
	end
	for i = 1, 3 do
		--3044
		local conA = GetElement(self.m_root,"conA"..i.."_WndApartmentAct",WZUIContainer)
		local txtPacksName = GetElement(conA,"txtPacksName_WndApartmentAct",WZUILabelTTF)
		txtPacksName:setScale(0.6)
		txtPacksName:setDimensions(GlobalMethod:CCSize(200))
	end
end

function WndApartmentAct:_adaptLanguage_es( )
	for i=1, 16 do
		local txtAct = GetElement(self.m_root,"txtAct"..i,WZUILabelTTF)
		local txtActsel = GetElement(self.m_root,"txtAct"..i.."_sel",WZUILabelTTF)
		if txtAct and txtActsel then
			txtAct:setScale(0.7)
			txtAct:setDimensions(GlobalMethod:CCSize(140))
			txtAct:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
			txtActsel:setScale(0.7)
			txtActsel:setDimensions(GlobalMethod:CCSize(140))
			txtActsel:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
		end
	end
	for i = 1, 4 do
		--3043
		local conItem = GetElement(self.m_root,"conItem"..i.."_ApartmentAct8",WZUIContainer)
		local txtItemName = GetElement(conItem,"txtItemName_WndApartmentAct",WZUILabelTTF)
		txtItemName:setScale(0.6)
		txtItemName:setDimensions(GlobalMethod:CCSize(200))
		--3031
		local conA = GetElement(self.m_root,"conA"..i.."_WndSumVacAct",WZUIContainer)
		local txtPacksName = GetElement(conA,"txtPacksName_WndSumVacAct",WZUILabelTTF)
		txtPacksName:setScale(0.6)
		txtPacksName:setDimensions(GlobalMethod:CCSize(200))
		--3030
		local conA = GetElement(self.m_root,"conItem"..i.."_ApartmentAct7",WZUIContainer)
		local txtItemName = GetElement(conA,"txtItemName_WndSumVacAct",WZUILabelTTF)
		txtItemName:setScale(0.6)
		txtItemName:setDimensions(GlobalMethod:CCSize(200))
	end
	for i = 1, 3 do
		--3044
		local conA = GetElement(self.m_root,"conA"..i.."_WndApartmentAct",WZUIContainer)
		local txtPacksName = GetElement(conA,"txtPacksName_WndApartmentAct",WZUILabelTTF)
		txtPacksName:setScale(0.6)
		txtPacksName:setDimensions(GlobalMethod:CCSize(200))
	end
end
-------------------------------------语言适配end--------------------------------------