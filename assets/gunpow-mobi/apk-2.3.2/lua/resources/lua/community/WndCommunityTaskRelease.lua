--WndCommunityTaskRelease.lua
--@brief	WndCommunityTaskRelease的UI模块
--@date		2016/06/17
--@author	zsq
--@note		公会发布任务界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityTaskRelease:onEnter(element)
	self.m_root = element
	 AdaptLanguage(self)
end

--@brief	加载完
function WndCommunityTaskRelease:onEnterTransitionDidFinish(element)
	self.m_nCost = GDatatab_guild_task_flush["id_1"].cost[1][2]
	self.m_nCostId = GDatatab_guild_task_flush["id_1"].cost[1][1]

	local guildPublishTaskCost = CacheCenter:getGameParam().guildPublishTaskCost
	local strConfig = string.sub(guildPublishTaskCost, 2, -2) 
	self.m_tReleaseCostNums = SplitStringWithSeparator(strConfig, ",", nil, true)

	self:showTitleList()
	self:update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityTaskRelease:onExit(element)
	self:_unInit()
end

--@brief	显示接口
function WndCommunityTaskRelease:show(parent)
	WZLog("WndCommunityTaskRelease:show")
	if self.m_root == nil then 
		local wnd = WndCommunityTaskRelease:createElement()
		parent:addChild(wnd)
	else
		self.m_root:setVisible(true)
		self:update()
	end
end

--@brief	锁定任务
function WndCommunityTaskRelease:onLock(element)
	if self.m_tID == nil then self.m_tID = {} end

	if self.m_tSelectedCell.m_bLocked then
		self.m_tSelectedCell:setLocked(false)
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO124)
	else
		self.m_tSelectedCell:setLocked(true)
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO123)
	end

	for k,v in pairs(GDatatab_guild_task_flush) do
		if #self.m_tID == v.sum then
			GetElement(self.m_root,"txtCost1",WZUILabelTTF):setText(v.cost[1][2])
			self.m_nCost = v.cost[1][2]
			self.m_nCostId = v.cost[1][1]
			break 
		end
	end
	local imgCostIcon1 = GetElement(self.m_root, "imgCostIcon1_WndCommunityTaskRelease", WZUIImage)
	if imgCostIcon1 and self.m_nCostId then
		imgCostIcon1:setFile(GDatatab_item["id_" .. self.m_nCostId].icon)
	end

	if #self.m_tID >= 4 then
		GetElement(self.m_root,"btnRefresh",WZUIButton):setTouchEnable(false)
		GetElement(self.m_root, "txtLeft_WndRelease", WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(148,148,148))
		GetElement(self.m_root, "txtCost1", WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(148,148,148))
		GetElement(self.m_root, "imgCostIcon1_WndCommunityTaskRelease", WZUIImage):setGrayRender(true)
	else
		GetElement(self.m_root,"btnRefresh",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root, "txtLeft_WndRelease", WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(163,74,20))
		GetElement(self.m_root, "txtCost1", WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(163,74,20))
		GetElement(self.m_root, "imgCostIcon1_WndCommunityTaskRelease", WZUIImage):setGrayRender(false)
	end

end

--@brief	刷新任务
function WndCommunityTaskRelease:onRefresh(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if not JudgeMoneyIsEnough(self.m_nCostId, self.m_nCost, nil, nil, nWindowId, nil, nil, nil, nil, self, self.clickSureMoney) then
		return 
	end

    self:clickSureMoney()
end

--@brief	点击礼券不足用钻石代替购买界面确定按钮回调
function WndCommunityTaskRelease:clickSureMoney()
	local id = WZLuaVector_int_:create()
	for i=1,#self.m_tID do
      	id:push(self.m_tID[i])
	end
	WZLog(Serialize(VectorToTable(id)))
	ProtocolProcessorSceneCommunity:send_GUILD_RequestFlushTask(id)
end

--@brief	发布任务
function WndCommunityTaskRelease:onPublish(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if not JudgeMoneyIsEnough(self.m_nReleaseCostId, self.m_tReleaseCostNums[self.m_nTopTabIndex], nil, nil, GlobalGame.g_nCurrentUIChannelId) then
		return
	end
   	MsgBoxManager:showConfirmCancelBox(LocalStrings.COMMUNITYINFO126, self, self.publish, MSGBOXLEVEL_HIGH,nil)
end

function WndCommunityTaskRelease:publish(nId, nResType)
	WZLog("WndLeagueTeamDetail:exitTeam",nResType)
	if nResType == 1 then
		WZLog("点击确定按钮")
    	local id = WZLuaVector_int_:create()
		for i=1,#WndCommunityTask.m_tDataList2 do
			WZLog("发布任务",Serialize(WndCommunityTask.m_tDataList2[i].idList))
			if WndCommunityTask.m_tDataList2[i].taskType == -1 then 
    	  		id:push(WndCommunityTask.m_tDataList2[i].idList)
    	  	end
		end
		WZLog("发布任务id",Serialize(VectorToTable(id)))
		ProtocolProcessorSceneCommunity:send_GUILD_PublishTask(id )
	else
		WZLog("点击取消按钮")
	end
end

function WndCommunityTaskRelease:onItemClick(tCell,tag,tData)
	WZLog("WndCommunityTaskRelease:onItemClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)	
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndCommunityTaskRelease:update()
	if WndCommunityTask.m_tDataList2 == nil then return end

	for k,v in pairs(GDatatab_guild_task_flush) do
		if #self.m_tID == v.sum then
			GetElement(self.m_root,"txtCost1",WZUILabelTTF):setText(v.cost[1][2])
			self.m_nCost = v.cost[1][2]
			self.m_nCostId = v.cost[1][1]
			break 
		end
	end
	local imgCostIcon1 = GetElement(self.m_root, "imgCostIcon1_WndCommunityTaskRelease", WZUIImage)
	if imgCostIcon1 and self.m_nCostId then
		imgCostIcon1:setFile(GDatatab_item["id_" .. self.m_nCostId].icon)
	end

	local txtCost2 = GetElement(self.m_root,"txtCost2",WZUILabelTTF)
	local imgCostIcon2 = GetElement(self.m_root,"imgCostIcon2_WndCommunityTaskRelease",WZUIImage)
	txtCost2:setVisible(false)
	imgCostIcon2:setVisible(false)
	if self.m_tReleaseCostNums[self.m_nTopTabIndex] ~= 0 then
		txtCost2:setText(self.m_tReleaseCostNums[self.m_nTopTabIndex])
		txtCost2:setVisible(true)
		imgCostIcon2:setFile(GDatatab_item["id_"..self.m_nReleaseCostId].icon)
		imgCostIcon2:setVisible(true)
	end

	--显示任务
	local freeListContainer = GetElement(self.m_root,"freeCon_WndCommunityTaskRelease",WZUIFreeListContainer)
	freeListContainer:removeAll()
	local nFirstTaskIndex = nil 
	for i = 1, #WndCommunityTask.m_tDataList2 do
--		WZLog("显示任务",Serialize(WndCommunityTask.m_tDataList2[i]))
		local nTaskType = WndCommunityTask.m_tDataList2[i].taskType
		local taskId = WndCommunityTask.m_tDataList2[i].idList
		local taskInfo = GDatatab_guild_task["id_"..taskId]
		local nTempType = -1
		if self.m_nTopTabIndex <= WndCommunityTask.m_nTaskDayIndex then
			nTempType = self.m_nTopTabIndex - 1
		end
		if nTaskType == nTempType then
			if not nFirstTaskIndex then nFirstTaskIndex = i end
			local celElement,tCell = CellCommunityTaskRelease:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement = WZUIContainer:luaTo(celElement)
				tCell:setData(taskInfo,WndCommunityTask.m_tDataList2[i].currCount,WndCommunityTask.m_tDataList2[i].totalCount)
				freeListContainer:pushBack(celElement)
				freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
			end 
		end
	end

	--发布状态
	if WndCommunityTask.m_nTaskDayIndex >= self.m_nTopTabIndex then
		GetElement(self.m_root,"btnRefresh",WZUIButton):setVisible(false)
		GetElement(self.m_root,"txtCost1",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"imgCostIcon1_WndCommunityTaskRelease",WZUIImage):setVisible(false)
		GetElement(self.m_root,"btnPublish",WZUIButton):setVisible(false)
		GetElement(self.m_root,"txtCost2",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"imgCostIcon2_WndCommunityTaskRelease",WZUIImage):setVisible(false)
		GetElement(self.m_root,"txtPublish",WZUILabelTTF):setVisible(true)
		self:refreshTime()
		self.m_root:enableSchedule("refreshTime",1)
	else
		GetElement(self.m_root,"btnRefresh",WZUIButton):setVisible(true)
		GetElement(self.m_root,"txtCost1",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"imgCostIcon1_WndCommunityTaskRelease",WZUIImage):setVisible(true)
		GetElement(self.m_root,"btnPublish",WZUIButton):setVisible(true)
		GetElement(self.m_root,"txtCost2",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"imgCostIcon2_WndCommunityTaskRelease",WZUIImage):setVisible(true)
		GetElement(self.m_root,"txtPublish",WZUILabelTTF):setVisible(false)
	end
end

--@brief	刷新截止时间
function WndCommunityTaskRelease:refreshTime()
	local now = os.date("*t", os.time())
	local t = os.time({year=now.year,month=now.month,day=now.day,hour=24,min=0})
	if self.m_nTopTabIndex >= 2 then
		t = os.time({year=now.year,month=now.month,day=now.day + (self.m_nTopTabIndex - 2),hour=24,min=0})
	end
	local leftSec = t - os.time()
	local desc = "00:00"
	if leftSec > 0 then 
		local hour = math.floor(leftSec/3600)
		if hour < 10 then hour = "0"..hour end
		local min = math.ceil(leftSec%3600/60)
		if min < 10 then min = "0"..min end
		local sec = leftSec%60
		if sec < 10 then sec = "0"..sec end
		desc = hour..":"..min..":"..sec
	end
	if self.m_nTopTabIndex == 1 then 
		GetElement(self.m_root,"txtPublish",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO125..desc)
	elseif self.m_nTopTabIndex > 1 then
		GetElement(self.m_root,"txtPublish",WZUILabelTTF):setText(LocalStrings.COMMUNITYTASK_TEXT2..desc)
	end
end



--@brief 	显示任务标签
function WndCommunityTaskRelease:showTitleList()
	local nCount = self.m_nTopTabCount
	if tonumber(WndCommunityTask.m_bJurisdiction) == 1 then 
		nCount = self.m_nTopTabCount
	else
		nCount = WndCommunityTask.m_nTaskDayIndex
	end

	self.m_tTitleElementList = {}
	local flcBoxGroup = GetElement(self.m_root,"flcTitleGroup_WndCommunityTaskRelease",WZUIFreeListContainer)
	flcBoxGroup:removeAll()
	for i=1,nCount do
		local btnTitleBox = CreateElement("btnTitleBox_WndCommunityTaskRelease")
		btnTitleBox = WZUIButton:luaTo(btnTitleBox)
		btnTitleBox:setTag(i-1)
		btnTitleBox:setLuaDoneFunctionName("onClickTitle")
		local conTitleBtnNor = GetElement(btnTitleBox,"conTitleBtnNor_WndCommunityTaskRelease",WZUIContainer)
		local conTitleBtnSel = GetElement(btnTitleBox,"conTitleBtnSel_WndCommunityTaskRelease",WZUIContainer)
		if i == self.m_nTopTabIndex then
			conTitleBtnNor:setVisible(false)
			conTitleBtnSel:setVisible(true)
		else
			conTitleBtnNor:setVisible(true)
			conTitleBtnSel:setVisible(false)
		end
		local txtTitleBtnNor = GetElement(btnTitleBox,"txtTitleBtnNor_WndCommunityTaskRelease",WZUILabelTTF)
		local txtTitleBtnSel = GetElement(btnTitleBox,"txtTitleBtnSel_WndCommunityTaskRelease",WZUILabelTTF)
		txtTitleBtnNor:setText(LocalStrings.COMMUNITYTASK_TEXT1[i])
		txtTitleBtnSel:setText(LocalStrings.COMMUNITYTASK_TEXT1[i])
		btnTitleBox:setVisible(true)
		flcBoxGroup:pushBack(btnTitleBox)
		table.insert(self.m_tTitleElementList,btnTitleBox)
	end
	flcBoxGroup:getMoveElement():setPositionY(flcBoxGroup:getMinPosition().y)
end

--@brief 	显示任务标签
function WndCommunityTaskRelease:onClickTitle(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()

	if nTag > WndCommunityTask.m_nTaskDayIndex then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYTASK_TEXT3)
		return 
	end

	self.m_tID = {}
	self.m_nTopTabIndex = nTag + 1

	for i=1,#self.m_tTitleElementList do
		local conTitleBtnNor = GetElement(self.m_tTitleElementList[i],"conTitleBtnNor_WndCommunityTaskRelease",WZUIContainer)
		local conTitleBtnSel = GetElement(self.m_tTitleElementList[i],"conTitleBtnSel_WndCommunityTaskRelease",WZUIContainer)
		if i == self.m_nTopTabIndex then
			conTitleBtnNor:setVisible(false)
			conTitleBtnSel:setVisible(true)
		else
			conTitleBtnNor:setVisible(true)
			conTitleBtnSel:setVisible(false)
		end
	end

	for k,v in pairs(GDatatab_guild_task_flush) do
		if #self.m_tID == v.sum then
			GetElement(self.m_root,"txtCost1",WZUILabelTTF):setText(v.cost[1][2])
			break 
		end
	end

	local txtCost2 = GetElement(self.m_root,"txtCost2",WZUILabelTTF)
	local imgCostIcon2 = GetElement(self.m_root,"imgCostIcon2_WndCommunityTaskRelease",WZUIImage)
	txtCost2:setVisible(false)
	imgCostIcon2:setVisible(false)
	if self.m_tReleaseCostNums[self.m_nTopTabIndex] ~= 0 then
		txtCost2:setText(self.m_tReleaseCostNums[self.m_nTopTabIndex])
		txtCost2:setVisible(true)
		imgCostIcon2:setFile(GDatatab_item["id_"..self.m_nReleaseCostId].icon)
		imgCostIcon2:setVisible(true)
	end

	self:update()
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function WndCommunityTaskRelease:_adaptLanguage_th()
    WZLog("WndCommunityTaskRelease:_adaptLanguage_th")
    GetElement(self.m_root,"txtLeft_WndRelease",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCost1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtRight_WndRelease",WZUILabelTTF):setScale(0.8)
end

function WndCommunityTaskRelease:_adaptLanguage_en()
	GetElement(self.m_root,"txtLeft_WndRelease",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCost1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtRight_WndRelease",WZUILabelTTF):setScale(0.8)
end

function WndCommunityTaskRelease:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtLeft_WndRelease",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCost1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRight_WndRelease",WZUILabelTTF):setScale(0.7)
end

function WndCommunityTaskRelease:_adaptLanguage_vn()
	GetElement(self.m_root,"txtLeft_WndRelease",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCost1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtRight_WndRelease",WZUILabelTTF):setScale(0.8)
end

function WndCommunityTaskRelease:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtLeft_WndRelease",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCost1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRight_WndRelease",WZUILabelTTF):setScale(0.7)
end

function WndCommunityTaskRelease:_adaptLanguage_es(  )

	GetElement(self.m_root,"txtLeft_WndRelease",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtCost1",WZUILabelTTF):setScale(0.7)

	local txtRight = GetElement(self.m_root,"txtRight_WndRelease",WZUILabelTTF)
	txtRight:setDimensions(GlobalMethod:CCSize(150,0))
	txtRight:setScale(0.8)
end
-------------------------------------语言适配End----------------------------------------
