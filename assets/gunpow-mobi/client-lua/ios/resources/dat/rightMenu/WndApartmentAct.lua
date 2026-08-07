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
	ProtocolProcessorWndActivityOnLine:regAll()
	ProtocolProcessorWndRankList:regAll()

	WZLog("WndApartmentAct:onEnter", CacheCenter:getGameParam().summerActivityNote)
end

--@brief    onenter函数已执行
function WndApartmentAct:onEnterTransitionDidFinish(element)
    WZLog("WndApartmentAct:onEnterTransitionDidFinish", GlobalGame.g_autoLouraActivity)
	self.m_nTag = 7

	if WndApartmentAct.soundIndex == nil then WndApartmentAct.soundIndex = 0 end
	--播放随机语音
	--local index = tostring(WndApartmentAct.soundIndex%3+1)
	--self.m_nSoundId = SoundManager:playEffectSound(SoundDefine["E_S_LOURA"..index])
	--WndApartmentAct.soundIndex = WndApartmentAct.soundIndex + 1


	if GlobalGame.g_autoLouraActivity == 1 then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo()
	end

	--更新充值信息
	WndNewActivity:updateRechargeInfo()

	--self.m_root:enableSchedule("turnPage", 3)
	self.m_root:enableSchedule("countDown", 1)

	self:setStaticText()

	WndApartmentAct:setRed2(GlobalGame.g_tRedPointList.louraAct)

	GetElement(self.m_root,"btnTip",WZUIButton):setVisible(true)
--	GetElement(self.m_root, "moveCon_WndApartmentAct", WZUIMoveContainer):UpdateInsidePosition()
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
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo()
		end
	end
	--判断秒杀活动是否开启
	--GetElement(self.m_root,"checkInfo13_WndApartmentAct",WZUICheckBox):setVisible(WndApartmentAct:isSeckillOn())
end

function WndApartmentAct:isSeckillOn()
	if WndApartmentAct.receiveSeckill == nil or WndApartmentAct.seckillStartTime == nil or WndApartmentAct.seckillEndTime == nil then
		return false
	end

	local onlineTime = tonumber(SystemTime:getServerTime()) - tonumber(WndApartmentAct.receiveSeckill)
	--WZLog("WndApartmentAct:isSeckillOn1", SystemTime:getServerTime())
	--WZLog("WndApartmentAct:isSeckillOn2", WndApartmentAct.receiveSeckill)
	--WZLog("WndApartmentAct:isSeckillOn3", onlineTime)
	--WZLog("WndApartmentAct:isSeckillOn4", tonumber(WndApartmentAct.seckillStartTime))
	--WZLog("WndApartmentAct:isSeckillOn5", tonumber(WndApartmentAct.seckillEndTime))
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
	ProtocolProcessorWndRankList:unregAll()
	self:_unInit()
end

--@brief    创建并显示活动界面
function WndApartmentAct:showInterface()
    WZLog("WndApartmentAct:showInterface")
	-- if GlobalGame.g_autoLouraActivity ~= 1 then
	-- 	MsgBoxManager:showTipBox(LocalStrings.WORLD_BOSS_END_TITLE)
	-- 	return
	-- end
    local wnd = WndApartmentAct:createElement()
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
	WZLog("WndApartmentAct:onTab",element:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	local tag = element:getTag()
	self.m_nTag = tag

	GetElement(self.m_root,"btnTip",WZUIButton):setVisible(true)
	if tonumber(tag) == 5 then
		GetElement(self.m_root,"btnTip",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnTip",WZUIButton):setVisible(true)
	end

	local moveCon = GetElement(self.m_root, "moveCon_WndApartmentAct", WZUIMoveContainer)
	self.m_nMoveElementPosX = moveCon:getMoveElement():getPositionX()
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
	for i=1,#self.m_tListItem do
		local title = self.m_tListItem[i].title
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
			hasAct11 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACIVIITY_THEMATIC_TASKS then
			hasAct12 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_SUMMER_REWARD then
			hasAct14 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_ORDERREDPACK then
			hasAct15 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_TYPE_FIREWORK then
			hasAct16 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_MARK_COIN then
			hasAct17 = true
		end
		if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_TOW_PACKAGE then
			hasAct18 = true
		end
	end
	if WndApartmentAct:canWeShare() then
		hasAct5 = true
	end
	if WndApartmentAct:showAct4() then
		hasAct4 = true
	end
	--if CheckButtonShow(134) then
	--	hasAct6 = true
	--end

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

	for i = 1, 18 do
		GetElement(self.m_root,"checkInfo"..i.."_WndApartmentAct",WZUICheckBox):setVisible(false)
	end

	local moveCon = GetElement(self.m_root, "moveCon_WndApartmentAct", WZUIMoveContainer)

	if self.m_nMoveElementPosX == nil then 
		local nTempTag = 1
		for i = 1, GetTableLen(tShowTabTag) do
			if tShowTabTag[i] == self.m_nTag then 
				nTempTag = i
				break 
			end
		end

		local conMove = GetElement(self.m_root, "conMove_WndApartmentAct", WZUIContainer)
		local nActCount = GetTableLen(showTabList)
		local nWidth = 105 * nActCount 
		if nWidth < 600 then 
			nWidth = 600
		end
		conMove:setAbsContentSize(GlobalMethod:CCSize(nWidth, 40))
		conMove:setRelativeSize(GlobalMethod:CCSize(1, 1))
		conMove:updateRelativeSize()

		local nTempX = moveCon:getMaxPosition().x - 330
		if nTempTag >= 6 then 
			nTempX = moveCon:getMaxPosition().x - 300
			nTempX = nTempX - (nTempTag - 5.5) * 105
			if nTempX < moveCon:getMinPosition().x then 
				nTempX = moveCon:getMinPosition().x
			end
		end
		moveCon:getMoveElement():setPositionX(nTempX)
	else
		moveCon:getMoveElement():setPositionX(self.m_nMoveElementPosX)
	end

	WZLog("uuuuuuuuuuuuuuuuuu", moveCon:getMaxPosition().x, moveCon:getMinPosition().x)
	for k, v in pairs(showTabList) do
		GetElement(self.m_root,v,WZUICheckBox):setVisible(true)
		GetElement(self.m_root,v,WZUICheckBox):setUseAbsCoordinate(true)
		GetElement(self.m_root,v,WZUICheckBox):setPosition(GlobalMethod:ccp(105*(k - 1), 40))
	end

	local conActivityC = GetElement(self.m_root, "conActivityC_WndSumVacAct", WZUIContainer)
	if conActivityC:getChildByTag(99) then 
		conActivityC:removeChildByTag(99, true)
	end
	for i = 1, 10 do
		GetElement(self.m_root,"conActivityContext"..i.."_WndApartmentAct",WZUIContainer):setVisible(false)
	end

	GetElement(self.m_root, "imgTimeBottom_wndApartmentAct", WZUIImage):setVisible(true)

	if tag <= 10 or tag == 18 then 
		if tag == 18 then 
			GetElement(self.m_root,"conActivityContext".."3".."_WndApartmentAct",WZUIContainer):setVisible(true)
		else
			GetElement(self.m_root,"conActivityContext"..tag.."_WndApartmentAct",WZUIContainer):setVisible(true)
		end
		GetElement(self.m_root,"txt11",WZUILabelTTF):setVisible(true)
		--GetElement(self.m_root,"txt11",WZUILabelTTF):setColor(ccc3(105,65,46))
		GetElement(self.m_root,"txt12",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txt12",WZUILabelTTF):setVisible(false)
	elseif tag == 11 then 
		GetElement(self.m_root,"txt11",WZUILabelTTF):setVisible(false)
		local element = WndChristmasTree:createElement()
		element:setTag(99)
		conActivityC:addChild(element)
	elseif tag == 12 then
		GetElement(self.m_root,"txt11",WZUILabelTTF):setVisible(true)
		local element = WndThematicTasks:createElement()
		element:setTag(99)
		local tActivityData = self:getActivityDataByActivityType(actTypes[12])
		WndThematicTasks:setData(tActivityData)
		conActivityC:addChild(element)
	elseif tag == 13 then
		GetElement(self.m_root,"txt11",WZUILabelTTF):setVisible(false)
		local element = WndSeckill:createElement()
		element:setTag(99)
		conActivityC:addChild(element)
	elseif tag == 14 then 
		GetElement(self.m_root,"txt11",WZUILabelTTF):setVisible(false)
		local element = WndSummerReward:createElement()
		element:setTag(99)
		conActivityC:addChild(element)
	elseif tag == 15 then
		GetElement(self.m_root,"txt11",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txt12",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root, "imgTimeBottom_wndApartmentAct", WZUIImage):setVisible(false)
		local element = CellOrderRedPack:createElement()
		self.m_nodeElement = element 
		self.m_tCellElement = CellOrderRedPack 
		element:setTag(99)
		conActivityC:addChild(element)
	elseif tag == 16 then
		GetElement(self.m_root,"txt11",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txt12",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root, "imgTimeBottom_wndApartmentAct", WZUIImage):setVisible(false)
		local element, tNewObj = CellFireworks:createElement()
		self.m_nodeElement = element 
		self.m_tCellElement = tNewObj 
		element:setTag(99)
		conActivityC:addChild(element)
	elseif tag == 17 then 	
		GetElement(self.m_root,"txt11",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txt12",WZUILabelTTF):setVisible(false)
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
	if self.m_nTag == 3 or self.m_nTag == 7 or self.m_nTag == 8 or self.m_nTag == 9 then
		local color = ccc3(255,255,255)
		GetElement(self.m_root,"txt11",WZUILabelTTF):setColor(color)
		GetElement(self.m_root,"txt12",WZUILabelTTF):setColor(color)
	end

	--神秘商店
	GetElement(self.m_root,"btnRebate",WZUIButton):setVisible(false)
--	GetElement(self.m_root,"btnTip",WZUIButton):setRelativePosition(ccp(0.879,0.153))
	if tag == 10 then
		WndApartmentAct["_update"..self.m_nTag](WndApartmentAct)
		GetElement(self.m_root,"txt11",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txt12",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"btnRebate",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnTip",WZUIButton):setVisible(true)
--		GetElement(self.m_root,"btnTip",WZUIButton):setRelativePosition(ccp(0.879,0.153))
		return
	end

	if tag > 3 and tag <= 6 then
		WZLog("活动记录", self.m_nTag)
		WndApartmentAct["_update"..self.m_nTag](WndApartmentAct)
		GetElement(self.m_root,"txt11",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txt12",WZUILabelTTF):setVisible(false)
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
	--WZLog(debug.traceback())
	WZLog("WndApartmentAct:_ActivityContext  nId=",nId ,nType, bg_img)
    if self.m_root == nil then return end

	local bgImg11 = GetElement(self.m_root,"bgImg"..self.m_nTag,WZUIImage)
	if bgImg11 ~= nil then 
		bgImg11:setFile("ui/gameActivity/newyear/happynewyear_zs10.png") 
	end

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
	--local p = element:getParent()
    --p = WZUIContainer:luaTo(p)
	--local tag = p:getTag()

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
        		    isUse = false,
        		    data = "",
        		    playerItemId = -1,
        		    basicInfo = GetItemLocalData(self.rewardItems[i])
        		}
		    	celElement = WZUIContainer:luaTo(celElement)
                tLuaObj:setCellGoodItem(tData, 20)
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

		   --第七天
		   if i==7 then
				cell:setAbsContentSize(GlobalMethod:CCSize(270,115))
				cell:updateRelativeSize()

		   		--GetElement(cell,"spine1",WZUISpine):setVisible(true)
		   		GetElement(cell,"spine1",WZUISpine):setScaleX(2.3)
		   		GetElement(cell,"spine1",WZUISpine):setRelativePosition(ccp(0.61,0.535713))
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

        table.insert(tData, tItem)
    end
	WZLog("WndApartmentAct:_update2", Serialize(tData))
    
    for i = 1, nCount do
		local cell = WZUISystem:getInstance():createElement("cellAct2")
       	cell = WZUIContainer:luaTo(cell)
		cell:setVisible(true)
		cell:setTag(i-1)
		cell:setContentSize(GlobalMethod:CCSize(630, 90))
        cell:setRelativeSize(GlobalMethod:CCSize(1,90/260))
		freecon_Act2:pushBack(cell)

        --tNewObj:setData(tData[i].tRewardData, tData[i].tConsumeData, self.m_rewardCounts[i], self.m_rewardId[i])

		--兑换需要的道具
		
		WZLog("兑换需要的道具",i,Serialize(tData))
		for i=1,4 do
			GetElement(cell,"conCellAct2"..i,WZUIContainer):setVisible(false)
		end
		local needItemNum = 0
		for j=1,math.min(tData[i].count, 4) do
		   local celElement,tLuaObj = CellGoodItem:createElement()
		   local id = tData[i].tConsumeData[j].id
		   local tItem
           if celElement ~= nil then 
				tItem = {
        		    id = id,
        		    lastNum = tData[i].tConsumeData[j].num,
        		    lastTime = 1,
        		    isUse = false,
        		    data = "",
        		    playerItemId = -1,
        		    basicInfo = GetItemLocalData(id)
        		}
		    	celElement = WZUIContainer:luaTo(celElement)
                tLuaObj:setCellGoodItem(tItem, 4)
                tLuaObj:setItemClickFun(self, self.onItem2)
                tLuaObj:_setItemVisible(false)
                celElement:setTag(j)
				celElement:setScale(0.85)
				GetElement(cell,"conCellAct2"..j,WZUIContainer):addChild(celElement)
				GetElement(cell,"conCellAct2"..j,WZUIContainer):setVisible(true)
				needItemNum = needItemNum + 1
           end

            --数量
            local nTempNum = tData[i].tConsumeData[j].num 
            if nTempNum == -1 then
                nTempNum = 1 
            end
            
            local txtNumber = GetElement(cell, string.format("txtNumber%d_CellExchangeItem", j), WZUILabelTTF)
            local nLastNum = CacheCenter:getPlayerItemCountById(tData[i].tConsumeData[j].id)
            if nLastNum == -1 then
                nLastNum = 1
            end
            txtNumber:setText(nLastNum .. "/" .. nTempNum)
			if self.exchangeTip == nil then self.exchangeTip = {} end
			if self.exchangeNum == nil then self.exchangeNum = {} end
			if self.exchangeTip[i] == nil and (tonumber(nLastNum) < tonumber(nTempNum)) then
				self.exchangeTip[i] = string.format(LocalStrings.CARD_COUNT1, [["]]..tItem.basicInfo.name..[["]])
			end
			self.exchangeNum[i] = math.floor(tonumber(nLastNum) / tonumber(nTempNum))
		end

		--兑换奖励
		   local celElement,tLuaObj = CellGoodItem:createElement()
		   local id = tData[i].tRewardData[1].id
           if celElement ~= nil then 
				tItem = {
        		    id = id,
        		    lastNum = tData[i].tRewardData[1].num,
        		    lastTime = 1,
        		    isUse = false,
        		    data = "",
        		    playerItemId = -1,
        		    basicInfo = GetItemLocalData(id)
        		}
		    	celElement = WZUIContainer:luaTo(celElement)
                tLuaObj:setCellGoodItem(tItem, 4)
                tLuaObj:setItemClickFun(self, self.onItem2)
                tLuaObj:_setItemVisible(false)
                celElement:setTag(1)
				celElement:setScale(0.85)
				GetElement(cell,"conCellAct2"..5,WZUIContainer):addChild(celElement)
				GetElement(cell,"txtNumber5_CellExchangeItem",WZUILabelTTF):setText(tData[i].tRewardData[1].num)
				if tItem.basicInfo.main_type == 5 then
					if tData[i].tRewardData[1].num == -1 then
						GetElement(cell,"txtNumber5_CellExchangeItem",WZUILabelTTF):setText(LocalStrings.YJ)
					end	
				end
           end

		if needItemNum < 4 then
			GetElement(cell,"imgD",WZUIImage):setRelativePosition(ccp(0.68-0.145*(4-needItemNum),0.51))
			GetElement(cell,"conCellAct2"..5,WZUIContainer):setRelativePosition(ccp(0.825-0.145*(4-needItemNum),0.5))
		end

    end

	if self.m_nConListPositionY ~= nil then
    	freecon_Act2:getMoveElement():setPositionY(self.m_nConListPositionY)
	else
    	freecon_Act2:getMoveElement():setPositionY(freecon_Act2:getMinPosition().y)
	end
end

function WndApartmentAct:onAct2(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local p = element:getParent()
    p = WZUIContainer:luaTo(p)
	local tag = tonumber(p:getTag()) + 1
	local i = tag
	WZLog("WndApartmentAct:onAct2", tag)

	--兑换道具不足
    if self.exchangeTip[tag] ~= nil then
        MsgBoxManager:showTipBox(self.exchangeTip[tag])
        return
    end

	--兑换次数不足
    if self.rewardCounts[tag] <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.ATH_CNT_NOT_ENOUGH)
        return 
    end

    local rewardId = self.rewardId[tag]
	self.rewardId3 = rewardId

	WZLog("兑换道具", self.activityId, rewardId)
    local freecon_Act2 = GetElement(self.m_root, "freecon_Act2", WZUIFreeListContainer)
    self.m_nConListPositionY = freecon_Act2:getMoveElement():getPositionY()

    --ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.activityId, rewardId)

	local id = self.rewardItems[(i - 1)*2 + 1]
	local maxNum = math.min(self.exchangeNum[i], self.rewardCounts[tag])
	local tItem = {
     	    id = id,
     	    lastNum = self.rewardItems[(i - 1)*2 + 2],
     	    lastTime = 1,
			maxNum = maxNum,
			unitNum = self.rewardItems[(i - 1)*2 + 2], 
     	    isUse = false,
     	    data = "",
     	    playerItemId = -1,
     	    basicInfo = GetItemLocalData(id)
     	}
	local wndOpenChest = WndOpenChest:createElement()
	WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
	WndOpenChest:setExchangeData(tItem)
end

function WndApartmentAct:onItem2(tCell,tag,tData,conItem) 
	WZLog("WndApartmentAct:onItem2")
	WndItemInfo:showInfo(tCell.m_root,WndApartmentAct.m_root,1,tData,false)
end

function WndApartmentAct:setRed2(bool) 
	if self.m_root == nil then return end
--	GetElement(self.m_root,"imgRed2_WndApartmentAct",WZUIImage):setVisible(bool)
end
-------------------------------------活动2End----------------------------------------

-------------------------------------活动3Begin--------------------------------------
--显示UI
function WndApartmentAct:_update3()
	local conActivityC = GetElement(self.m_root,"conActivityC_WndSumVacAct",WZUIContainer)
	local conActivityContext2 = GetElement(conActivityC,"conActivityContext3_WndApartmentAct",WZUIContainer)

	for i=1,4 do
		GetElement(conActivityContext2,"conA" .. i .. "_WndSumVacAct",WZUIContainer):setVisible(false)
	end

	for i,v in ipairs(self.m_tPacksFashion) do
		if i > 4 then break end
		local conA = GetElement(conActivityContext2,"conA" .. i .. "_WndSumVacAct",WZUIContainer)
		conA:setVisible(true)
		local conBtn = GetElement(conA,"conBtn_WndSumVacAct",WZUIContainer)
		local imgSoldOut = GetElement(conA,"imgSoldOut_WndSumVacAct",WZUIImage)
		local conItemInfo = GetElement(conA,"conItemInfo_WndSumVacAct",WZUIContainer)
		local txtPrice = GetElement(conA,"txtPrice_WndSumVacAct",WZUILabelTTF)
		local txtLimitBuyTip = GetElement(conA,"txtLimitBuyTip_WndSumVacAct",WZUILabelTTF)
		local txtPacksName = GetElement(conA,"txtPacksName_WndSumVacAct",WZUILabelTTF)
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
		--tItem:setCellGoodItem(tData,20)
		tItem:setCellGoodItem(tData, 4)
	--	GetElement(tItem.m_root,"btnImg_CellGoodItem",WZUI9Image):setVisible(false)
	--	GetElement(tItem.m_root,"btnImg1_CellGoodItem",WZUI9Image):setFile("")
	--	GetElement(tItem.m_root,"btnImg2_CellGoodItem",WZUI9Image):setFile("")
		if tItem.m_txtCount ~= nil then
    		tItem.m_txtCount:setRelativePosition(ccp(0.92,0.1))
		end
		conItemInfo:addChild(eItem)
	end

	if #self.m_tPacksFashion == 4 then 
		GetElement(self.m_root, "conForReward3_WndApartmentAct", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
	elseif #self.m_tPacksFashion == 3 then 
		GetElement(self.m_root, "conForReward3_WndApartmentAct", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6, 0.5))
	elseif #self.m_tPacksFashion == 2 then 
		GetElement(self.m_root, "conForReward3_WndApartmentAct", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.7, 0.5))
	elseif #self.m_tPacksFashion == 1 then 
		GetElement(self.m_root, "conForReward3_WndApartmentAct", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.8, 0.5))
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
	if imgSoldOut:isVisible()  then
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
	--判断是否拥有全部橙色坐骑
	--if tag == 4 and WndApartmentAct:ownAllOrangeHorse() then
	--	MsgBoxManager:showConfirmCancelBox(LocalStrings.GIFTTIP1 or "", self, self.buy3, nil)
	--else
	--	self:buy3(nil, 1)
	--end

	--判断是否拥有礼包中物品
	--local own, text = checkGiftOwn(data.itemId)
	--if tag == 4 and own then
	--	MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.OWN1, text), self, self.buy3, nil, nil)
	--else
	--	self:buy3(nil, 1)
	--end

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
		WZLog("WndApartmentAct:buy3", data.leftTimes)
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
    	local sdkData = WndSumVacAct:getSDKData(self.tag3,self.m_tPacksFashion)
    	PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
    	PassportSdkManager:getOrderNum(sdkData)
	end
end

--@brief    发送请求刷新充值进度
--@param   bRecharge：是否为充值活动刷新
function WndApartmentAct:refreshActivityContext(bRecharge)
    WZLog("WndApartmentAct:refreshActivityContext")
    if self.m_root == nil then return end
    if bRecharge then
       	self:_ActivityContext(self.m_nCurShowActivityType,self.m_nCurShowActivityId,self.bg_img)
        --if self.m_nCurShowActivityId == 3031  then  --夏日专属与夏日盛慧
        --	self:_ActivityContext(self.m_nCurShowActivityType,self.m_nCurShowActivityId)
        --end
        --if self.m_nCurShowActivityId == 3030  then  --夏日专属与夏日盛慧
        --	self:_ActivityContext(self.m_nCurShowActivityType,self.m_nCurShowActivityId)
        --end
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
    --if CheckButtonOpen(ISLAND_UP_WISHING_WELL) then
    --   WndPromiseShrine:showWnd()
    --else
    --    MsgBoxManager:showTipBox(LocalStrings.WORLD_BOSS_END_TITLE)
    --end
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
		for j = 1, #CacheCenter.m_tApartmentRedDotList do
			if CacheCenter.m_tApartmentRedDotList[j] == self.m_tAllActivityType[i] then
				if imgRed then 
					imgRed:setVisible(true)
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
				--celElement:setScale(0.85)
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
	--if checkGiftOwnAllHorse_1(data.itemId) then
	--	MsgBoxManager:showConfirmCancelBox(LocalStrings.GIFTTIP1 or "", self, self.buy7, nil)
	--	return
	--end

	--if checkGiftOwnAllSkin(self.giftId7) then
		--MsgBoxManager:showConfirmCancelBox(LocalStrings.GIFTTIP2 or "", self, self.buy7, nil)

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

	--检查是否拥有皮肤
	--if checkGiftOwnAllSkin(self.giftId8) then
	--	MsgBoxManager:showConfirmCancelBox(LocalStrings.GIFTTIP2 or "", self, self.buy8, nil)
	--else
	--	self:buy8(nil, 1)
	--end

	--检查是否拥有时装
	if gCheckHaveOrNot(self.giftId8) then
		MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.OWN1, GDatatab_item["id_"..self.giftId8].name), self, self.buy8, nil)
	else
		self:buy8(nil, 1)
	end

	--self:buy8(nil, 1)
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

	for i,v in ipairs(self.m_tPacksFashion9) do
		if i > 4 then break end
		local conA = GetElement(self.m_root,"conA" .. i .. "_WndApartmentAct",WZUIContainer)
		conA:setVisible(true)
		local conBtn = GetElement(conA,"conBtn_WndApartmentAct",WZUIContainer)
		local imgSoldOut = GetElement(conA,"imgSoldOut_WndApartmentAct",WZUIImage)
		local conItemInfo = GetElement(conA,"conItemInfo_WndApartmentAct",WZUIContainer)
		local txtPrice = GetElement(conA,"txtPrice_WndApartmentAct",WZUILabelTTF)
		local txtLimitBuyTip = GetElement(conA,"txtLimitBuyTip_WndApartmentAct",WZUILabelTTF)
		local txtPacksName = GetElement(conA,"txtPacksName_WndApartmentAct",WZUILabelTTF)
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
		--tItem:setCellGoodItem(tData,20)
		tItem:setCellGoodItem(tData, 4)
		-- GetElement(tItem.m_root,"btnImg_CellGoodItem",WZUI9Image):setVisible(false)
		-- GetElement(tItem.m_root,"btnImg1_CellGoodItem",WZUI9Image):setFile("")
		-- GetElement(tItem.m_root,"btnImg2_CellGoodItem",WZUI9Image):setFile("")
		if tItem.m_txtCount ~= nil then
    		tItem.m_txtCount:setRelativePosition(ccp(0.92,0.1))
		end
		conItemInfo:addChild(eItem)
	end

	GetElement(self.m_root,"conA4_WndApartmentAct",WZUIContainer):setVisible(false)
	if #self.m_tPacksFashion9 == 2 then 
		GetElement(self.m_root, "conForReward9_WndApartmentAct", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6, 0.5))
	elseif #self.m_tPacksFashion9 == 1 then 
		GetElement(self.m_root, "conForReward9_WndApartmentAct", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.7, 0.5))
	end
end

--购买
function WndApartmentAct:onClickBuy9(element)
	WZLog("WndApartmentAct:onClickBuy ")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local parent = element:getParent()
	parent = parent:getParent()
	parent = WZUIContainer:luaTo(parent)
	local imgSoldOut = GetElement(parent,"imgSoldOut_WndApartmentAct",WZUIImage)
	if imgSoldOut:isVisible()  then
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
	--if tag == 4 and checkGiftOwnAllHorse(data.itemId) then
	--	MsgBoxManager:showConfirmCancelBox(LocalStrings.GIFTTIP1 or "", self, self.buy9, nil)
	--else
	--	self:buy9(nil, 1)
	--end

	----判断是否拥有全部紫色坐骑
	--if tag == 2 and WndApartmentAct:ownAllPurpleHorse() then
	--	MsgBoxManager:showConfirmCancelBox(LocalStrings.GIFTTIP1 or "", self, self.buy9, nil)
	--else
	--	self:buy9(nil, 1)
	--end

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
	if self.m_nTag == nil then self.m_nTag = 1 end
	local actTypes = self.m_tAllActivityType
	local tips = {LocalStrings.LOURAACT7,LocalStrings.LOURAACT8,LocalStrings.LOURAACT9}
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
	WZLog("WndApartmentAct:setActTime", SystemTime:getServerTime(), startT, endT)
	self.endTime = endT
	self.m_nDisappearTime = disappearTime

    startT = os.date("%m.%d %H:%M",startT)
    endT = os.date("%m.%d %H:%M",endT)
    local actT = LocalStrings.ACTIVITY_TIME_KEY .. "：" .. startT .. "-" .. endT
    local text = GetElement(self.m_root,"txt11",WZUILabelTTF)
    text:setText(actT)
	GetElement(self.m_root,"txt12",WZUILabelTTF):setText(tips[self.m_nTag])
	GetElement(self.m_root,"txt12",WZUILabelTTF):setText("")

	if self.m_nTag == 11 then 
		text:setText("")
		GetElement(self.m_root,"txt12",WZUILabelTTF):setText("")
	end
end

function WndApartmentAct:onRuleClick(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndApartmentAct:onRuleClick", CacheCenter:getGameParam().summerActivityNote)
    if self.m_nTag == 11 then
    	WndSingleMapDesc:showInterface1(LocalStrings.CHRISTMASTREE_TEXT9, true)
    elseif self.m_nTag == 17 then 
    	WndSingleMapDesc:showInterface(LocalStrings.THREE_YEAR_TEXT4, nil, true)
    else
    	--WndSingleMapDesc:showInterface(LocalStrings.LOURAACT_DESC)
    	WndSingleMapDesc:showInterface(CacheCenter:getGameParam().summerActivityNote, nil, true)
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