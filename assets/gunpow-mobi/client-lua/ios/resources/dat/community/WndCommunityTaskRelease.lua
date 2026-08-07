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

	self:_setCheckBoxText()
	self:setTopTabVisible()
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
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tID == nil then self.m_tID = {} end
	if self.m_tSelectedCell == nil or self.m_tSelectedCell.m_root == nil then 
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO127)
		return
	end
	if self.m_tSelectedCell.m_bLocked then
		GetElement(self.m_root,"txtLockWord",WZUILabelTTF):setText(LocalStrings.WORD_LOCK)
		self.m_tSelectedCell:setLocked(false)
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO124)
	else
		GetElement(self.m_root,"txtLockWord",WZUILabelTTF):setText(LocalStrings.TIPSWORD6)
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
			GetElement(self.m_root,"txtLockWord",WZUILabelTTF):setScale(0.7)
		end
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

	local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndCommunityTaskRelease", WZUIImage)
	if imgCostIcon and self.m_nCostId then
		imgCostIcon:setFile(GDatatab_item["id_" .. self.m_nCostId].icon)
		imgCostIcon:setScale(0.55)
	end

	if #self.m_tID >= 4 then
		GetElement(self.m_root,"btnRefresh",WZUIButton):setTouchEnable(false)
	else
		GetElement(self.m_root,"btnRefresh",WZUIButton):setTouchEnable(true)
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

--@brief 	点击顶部标签回调
function WndCommunityTaskRelease:onClickTab(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_nTopTabIndex == nTag then return end 
	if nTag > WndCommunityTask.m_nTaskDayIndex + 1 then
		WZLog("WndCommunityTaskRelease:onClickTab", self.m_nTopTabIndex - 1)
		GetElement(self.m_root, "checkboxGroup_WndCommunityTaskRelease", WZUICheckBoxGroup):setCheckIndex(self.m_nTopTabIndex - 1)
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYTASK_TEXT3)
		return 
	end
	self.m_tID = {} 
	self.m_nTopTabIndex = nTag
	for k,v in pairs(GDatatab_guild_task_flush) do
		if #self.m_tID == v.sum then
			GetElement(self.m_root,"txtCost1",WZUILabelTTF):setText(v.cost[1][2])
			break 
		end
	end
	self:update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndCommunityTaskRelease:update()
	if WndCommunityTask.m_tDataList2 == nil then return end
	
	local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndCommunityTaskRelease", WZUIImage)
	if imgCostIcon and self.m_nCostId then
		imgCostIcon:setFile(GDatatab_item["id_" .. self.m_nCostId].icon)
		imgCostIcon:setScale(0.55)
	end
	--显示任务
	local freeListContainer = GetElement(self.m_root,"freeCon_WndCommunityTaskRelease",WZUIFreeListContainer)
	freeListContainer:removeAll()
	local nFirstTaskIndex = nil 
	for i = 1, #WndCommunityTask.m_tDataList2 do
--		WZLog("显示任务",Serialize(WndCommunityTask.m_tDataList2[i]))
		local nTaskType = WndCommunityTask.m_tDataList2[i].taskType
		local nTempType = -1 
		local taskId = WndCommunityTask.m_tDataList2[i].idList
		local taskInfo = GDatatab_guild_task["id_"..taskId]
		if WndCommunityTask.m_nTaskDayIndex == 0 then 
			nTempType = -1 
		elseif WndCommunityTask.m_nTaskDayIndex == 1 then
			if self.m_nTopTabIndex == 1 then 
				nTempType = 0 
			elseif self.m_nTopTabIndex == 2 then
				nTempType = -1
			end
		elseif WndCommunityTask.m_nTaskDayIndex == 2 then
			if self.m_nTopTabIndex == 1 then 
				nTempType = 0 
			elseif self.m_nTopTabIndex == 2 then
				nTempType = 1
			elseif self.m_nTopTabIndex == 3 then
				nTempType = -1
			end
		elseif WndCommunityTask.m_nTaskDayIndex == 3 then
			if self.m_nTopTabIndex == 1 then 
				nTempType = 0 
			elseif self.m_nTopTabIndex == 2 then
				nTempType = 1
			elseif self.m_nTopTabIndex == 3 then
				nTempType = 2
			end
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

	local taskId = WndCommunityTask.m_tDataList2[nFirstTaskIndex].idList
	local tData = GDatatab_guild_task["id_"..taskId]
	--显示第一个任务详情
	self:updateDetail(tData,WndCommunityTask.m_tDataList2[nFirstTaskIndex].currCount,WndCommunityTask.m_tDataList2[nFirstTaskIndex].totalCount)
	--显示奖励
	for i=1,2 do
		local con = GetElement(self.m_root,"conReward"..i,WZUIContainer)
		con:removeAllChildrenWithCleanup(true)
		local itemData = GDatatab_item["id_"..tData.gh_reward[i][1]]
        local itemInfo = {name=itemData.name,icon=itemData.icon,lastNum=tData.gh_reward[i][2],quality=itemData.quality,basicInfo=CopyTable(itemData)}
		--创建格子
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			celElement:setScale(0.8)
			tCell:setCellGoodItem(itemInfo,2)
			tCell:setItemClickFun(self,self.onItemClick)
			con:addChild(celElement)
		end
	end
	for i=1,2 do
		local con = GetElement(self.m_root,"conReward"..(i+2),WZUIContainer)
		con:removeAllChildrenWithCleanup(true)
		local itemData = GDatatab_item["id_"..tData.gr_reward[i][1]]
        local itemInfo = {name=itemData.name,icon=itemData.icon,lastNum=tData.gr_reward[i][2],quality=itemData.quality,basicInfo=CopyTable(itemData)}
		--创建格子
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			celElement:setScale(0.8)
			tCell:setCellGoodItem(itemInfo,2)
			tCell:setItemClickFun(self,self.onItemClick)
			con:addChild(celElement)
		end
	end

	--发布状态
	if WndCommunityTask.m_nTaskDayIndex >= self.m_nTopTabIndex then
		GetElement(self.m_root,"btnRefresh",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnPublish",WZUIButton):setVisible(false)
		GetElement(self.m_root,"txtPublish",WZUILabelTTF):setVisible(true)
		self:refreshTime()
		self.m_root:enableSchedule("refreshTime",1)

		--锁定按钮
		GetElement(self.m_root,"btnLock",WZUIButton):setVisible(false)
		GetElement(self.m_root,"txtLocked",WZUILabelTTF):setVisible(false)
		--进度
		GetElement(self.m_root,"conPublish",WZUIContainer):setVisible(true)
	else
		GetElement(self.m_root,"btnRefresh",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnPublish",WZUIButton):setVisible(true)
		GetElement(self.m_root,"txtPublish",WZUILabelTTF):setVisible(false)

		--锁定按钮
		GetElement(self.m_root,"btnLock",WZUIButton):setVisible(true)
		GetElement(self.m_root,"txtLocked",WZUILabelTTF):setVisible(true)
		--进度
		GetElement(self.m_root,"conPublish",WZUIContainer):setVisible(false)
	end
end

--@brief	刷新截止时间
function WndCommunityTaskRelease:refreshTime()
	local now = os.date("*t", os.time())
	local t = os.time({year=now.year,month=now.month,day=now.day,hour=24,min=0})
	if self.m_nTopTabIndex == 2 then
		t = os.time({year=now.year,month=now.month,day=now.day,hour=24,min=0})
	elseif self.m_nTopTabIndex == 3 then
		t = os.time({year=now.year,month=now.month,day=now.day + 1 ,hour=24,min=0})
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
	elseif self.m_nTopTabIndex == 2 then
		GetElement(self.m_root,"txtPublish",WZUILabelTTF):setText(LocalStrings.COMMUNITYTASK_TEXT2..desc)
	elseif self.m_nTopTabIndex == 3 then
		GetElement(self.m_root,"txtPublish",WZUILabelTTF):setText(LocalStrings.COMMUNITYTASK_TEXT2..desc)
	end
end

--@param	配置任务表数据
function WndCommunityTaskRelease:updateDetail(tData,cur,total)
	--任务名
	GetElement(self.m_root,"taskName",WZUILabelTTF):setText(tData.name)
	--进度
	GetElement(self.m_root,"txtScore_WndCommunityTaskRelease",WZUILabelTTF):setText(cur.."/"..total)
	if total == 0 then
		GetElement(self.m_root,"progressBar",WZUIProgress):setPercentage(0)
	else
		GetElement(self.m_root,"progressBar",WZUIProgress):setPercentage(math.floor(cur*100/total))
	end

	--按钮文字
	if GetElement(self.m_root,"txtLockWord",WZUILabelTTF):getText() == "" then
		GetElement(self.m_root,"txtLockWord",WZUILabelTTF):setText(LocalStrings.WORD_LOCK)
	end
	if self.m_tSelectedCell ~= nil and self.m_tSelectedCell.m_bLocked ~= nil then
		if self.m_tSelectedCell.m_bLocked then
			GetElement(self.m_root,"txtLockWord",WZUILabelTTF):setText(LocalStrings.TIPSWORD6)
			if ProjConfig.LANGUAGE == "pt" then
				GetElement(self.m_root,"txtLockWord",WZUILabelTTF):setScale(0.7)
			end
		else
			GetElement(self.m_root,"txtLockWord",WZUILabelTTF):setText(LocalStrings.WORD_LOCK)
		end
	end
	--星数
	for i=1,5 do
		GetElement(self.m_root,"star"..i,WZUIImage):setVisible(false)
	end
	for i=1,tData.star do
		GetElement(self.m_root,"star"..i,WZUIImage):setVisible(true)
	end
	--描述
	GetElement(self.m_root,"txtDetail",WZUILabelTTF):setText(tData.detaildesc)
	--奖励
	GetElement(self.m_root,"taskName",WZUILabelTTF):setText(tData.name)
	--gh_reward = {{1,100},{11,1186}},gr_reward = {{1,100},{2,1186}}
	--显示奖励
	for i=1,2 do
		local con = GetElement(self.m_root,"conReward"..i,WZUIContainer)
		con:removeAllChildrenWithCleanup(true)
		local itemData = GDatatab_item["id_"..tData.gh_reward[i][1]]
        local itemInfo = {name=itemData.name,icon=itemData.icon,lastNum=tData.gh_reward[i][2],quality=itemData.quality,basicInfo=CopyTable(itemData)}
		--创建格子
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			celElement:setScale(0.8)
			tCell:setCellGoodItem(itemInfo,2)
			tCell:setItemClickFun(self,self.onItemClick)
			con:addChild(celElement)
		end
	end
	for i=1,2 do
		local con = GetElement(self.m_root,"conReward"..(i+2),WZUIContainer)
		con:removeAllChildrenWithCleanup(true)
		local itemData = GDatatab_item["id_"..tData.gr_reward[i][1]]
        local itemInfo = {name=itemData.name,icon=itemData.icon,lastNum=tData.gr_reward[i][2],quality=itemData.quality,basicInfo=CopyTable(itemData)}
		--创建格子
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			celElement:setScale(0.8)
			tCell:setCellGoodItem(itemInfo,2)
			tCell:setItemClickFun(self,self.onItemClick)
			con:addChild(celElement)
		end
	end
end

--@brief 	设置标签文字
function WndCommunityTaskRelease:_setCheckBoxText()
	-- body
	for i = 1, 3 do
		local txtBox = GetElement(self.m_root, "txtBox" .. i .. "_WndCommunityTaskRelease", WZUILabelTTF)
		local txtBoxSel = GetElement(self.m_root, "txtBoxSel" .. i .. "_WndCommunityTaskRelease", WZUILabelTTF)
		txtBox:setText(LocalStrings.COMMUNITYTASK_TEXT1[i])
		txtBoxSel:setText(LocalStrings.COMMUNITYTASK_TEXT1[i])
	end
end

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
	GetElement(self.m_root,"txtPersonal_WndCommunityTaskRelease",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.015,0.15))
	for i = 1, 3 do
		local txtBox = GetElement(self.m_root, "txtBox" .. i .. "_WndCommunityTaskRelease", WZUILabelTTF)
		local txtBoxSel = GetElement(self.m_root, "txtBoxSel" .. i .. "_WndCommunityTaskRelease", WZUILabelTTF)
		txtBox:setScale(0.65)
		txtBox:setDimensions(GlobalMethod:CCSize(150))
		txtBoxSel:setScale(0.65)
		txtBoxSel:setDimensions(GlobalMethod:CCSize(150))
	end

	local txtDetail = GetElement(self.m_root,"txtDetail",WZUILabelTTF)
	txtDetail:setScale(0.8)
	txtDetail:setDimensions(GlobalMethod:CCSize(310))
end

function WndCommunityTaskRelease:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtLeft_WndRelease",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCost1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRight_WndRelease",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtPersonal_WndCommunityTaskRelease",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.015,0.15))
	GetElement(self.m_root,"txtLocked",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(160,0))

	for i = 1, 3 do
		local txtBox = GetElement(self.m_root, "txtBox" .. i .. "_WndCommunityTaskRelease", WZUILabelTTF)
		local txtBoxSel = GetElement(self.m_root, "txtBoxSel" .. i .. "_WndCommunityTaskRelease", WZUILabelTTF)
		txtBox:setScale(0.65)
		txtBox:setDimensions(GlobalMethod:CCSize(150))
		txtBoxSel:setScale(0.65)
		txtBoxSel:setDimensions(GlobalMethod:CCSize(150))
	end

	local txtDetail = GetElement(self.m_root,"txtDetail",WZUILabelTTF)
	txtDetail:setScale(0.8)
	txtDetail:setDimensions(GlobalMethod:CCSize(310))
end

function WndCommunityTaskRelease:_adaptLanguage_vn()
	GetElement(self.m_root,"txtLeft_WndRelease",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCost1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtRight_WndRelease",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtPersonal_WndCommunityTaskRelease",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.01,0.15))
	GetElement(self.m_root,"txtLocked",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.0110345,0.59))
	GetElement(self.m_root,"txtPersonal1_WndCommunityTaskRelease",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.01,0.32))
end

function WndCommunityTaskRelease:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtLeft_WndRelease",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCost1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRight_WndRelease",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtPersonal_WndCommunityTaskRelease",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.02,0.15))
	GetElement(self.m_root,"txtPersonal1_WndCommunityTaskRelease",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.07,0.32))
	GetElement(self.m_root,"txtLocked",WZUILabelTTF):setScale(0.83)

	for i = 1, 3 do
		local txtBox = GetElement(self.m_root, "txtBox" .. i .. "_WndCommunityTaskRelease", WZUILabelTTF)
		local txtBoxSel = GetElement(self.m_root, "txtBoxSel" .. i .. "_WndCommunityTaskRelease", WZUILabelTTF)
		txtBox:setScale(0.65)
		txtBox:setDimensions(GlobalMethod:CCSize(150))
		txtBoxSel:setScale(0.65)
		txtBoxSel:setDimensions(GlobalMethod:CCSize(150))
	end
end

function WndCommunityTaskRelease:_adaptLanguage_es(  )
	local txtLocked = GetElement(self.m_root,"txtLocked",WZUILabelTTF)
	txtLocked:setScale(0.8)
	txtLocked:setDimensions(GlobalMethod:CCSize(160,0))

	local txtPersonal = GetElement(self.m_root,"txtPersonal_WndCommunityTaskRelease",WZUILabelTTF)
	txtPersonal:setRelativePosition(GlobalMethod:ccp(0.05,0.32))
	txtPersonal:setScale(0.8)

	local txtPersonal1 = GetElement(self.m_root,"txtPersonal1_WndCommunityTaskRelease",WZUILabelTTF)
	txtPersonal1:setRelativePosition(GlobalMethod:ccp(0.03,0.15))
	txtPersonal1:setScale(0.8)

	GetElement(self.m_root,"txtLeft_WndRelease",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtCost1",WZUILabelTTF):setScale(0.7)

	local txtRight = GetElement(self.m_root,"txtRight_WndRelease",WZUILabelTTF)
	txtRight:setDimensions(GlobalMethod:CCSize(150,0))
	txtRight:setScale(0.8)
	for i = 1, 3 do
		local txtBox = GetElement(self.m_root, "txtBox" .. i .. "_WndCommunityTaskRelease", WZUILabelTTF)
		local txtBoxSel = GetElement(self.m_root, "txtBoxSel" .. i .. "_WndCommunityTaskRelease", WZUILabelTTF)
		txtBox:setScale(0.6)
		txtBox:setDimensions(GlobalMethod:CCSize(170))
		txtBoxSel:setScale(0.6)
		txtBoxSel:setDimensions(GlobalMethod:CCSize(170))
	end
	
	local txtDetail = GetElement(self.m_root,"txtDetail",WZUILabelTTF)
	txtDetail:setScale(0.8)
	txtDetail:setDimensions(GlobalMethod:CCSize(310))
end
-------------------------------------私有方法模块End----------------------------------------
