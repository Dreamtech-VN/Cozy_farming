--WndWakeupData.lua
--@brief	WndWakeup的数据模块
--@date		2017/05/20
--@author	Tianxiang_Xu
--@note		觉醒模块

WndWakeup = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWakeup:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tLeftList = nil 				--左菜单数据
	self.m_nLeftSelIndex = nil 			--左菜单选中索引
	self.m_tLeftCell = nil 
	self.m_nTopSelIndex = nil  			--保存任务界面顶部复选框上次选中索引
	self.m_nSoulLevel = 0 				--觉醒之魂等级
	self.m_nCurSoulExp = 1  			--觉醒之魂当前经验
	self.m_nBodyState = 0  				--觉醒之体状态
	self.m_tWakeupList = nil 			
	self.m_nLoadingId = nil 
	self.m_tPowerList = nil 
	self.m_topCellLua = nil 
	self.m_nAwakeSkillId = nil 
	self.m_bIsTraining = false
	self.m_nEvolveLevel = 0 			--进化等级
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWakeup:_unInit()
	self.m_root = nil
	self.m_tLeftList = nil 
	self.m_nLeftSelIndex = nil 				
	self.m_tLeftCell = nil 
	self.m_nTopSelIndex = nil 
	self.m_nSoulLevel = nil 
	self.m_nCurSoulExp = nil 
	self.m_nBodyState = nil 
	self.m_tWakeupList = nil 
	self.m_nLoadingId = nil 
	self.m_tPowerList = nil 
	self.m_topCellLua = nil 
	self.m_nAwakeSkillId = nil 
	self.m_bIsTraining = nil 
	self.m_nEvolveLevel = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWakeup:createElement()
	if WndWakeup.m_root ~= nil then
		WindowManager:removeWindow(WndWakeup.m_root, WndWakeup, true)
	end
	local element = WZUISystem:getInstance():createElement("WndWakeup")
	assert(element, "WndWakeup create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndWakeup:showInterface(nLeftSelIndex)
	-- body
	if CheckButtonOpen(120) then
		local wndWakeup = WndWakeup:createElement()
		if wndWakeup then
			self.m_nLeftSelIndex = nLeftSelIndex or 0
			WindowManager:addWindow(wndWakeup, WndWakeup, nil, nil, nil, true)
		end
	end
end

--@brief	设置做菜单数据
function WndWakeup:setLeftListData(nCurSection)
	-- body
	self.m_tLeftList = {}
	for i = 1, nCurSection + 1 do
		local tItem = {}
		tItem.id = i 
		tItem.name = LocalStrings.WAKEUP_TEXT1[i]

		table.insert(self.m_tLeftList, tItem)
	end

	self:_update()
end

--@brief 	保存任务界面中当前选中的顶部标签索引
function WndWakeup:setTopSelIndex(nIndex)
	-- body
	self.m_nTopSelIndex = nIndex 
end

--@brief 	返回任务界面中当前选中的顶部标签索引
function WndWakeup:getTopSelIndex()
	-- body
	return self.m_nTopSelIndex 
end

--@brief 	设置数据
function WndWakeup:setData(awakeConfigId, task, status, taskConfigId, progress, soulLevel, soulExp, suitDrawStatus, inbornId, awakeSkillId, evolveLevel)
	-- body
	self:_stopLoading()

	self.m_nSoulLevel = soulLevel 
	self.m_nCurSoulExp = soulExp
	self.m_nBodyState = suitDrawStatus 

	self.m_tWakeupList = {}
	WZLog("WndWakeup:setData", Serialize(task), Serialize(taskConfigId), Serialize(progress), evolveLevel)
	for i = 1, #awakeConfigId do
		local tItem = {}

		tItem.id = awakeConfigId[i]
		tItem.taskData = self:_getWakeupTaskData(task[i], taskConfigId, progress)
		tItem.status = status[i]
		-- if tItem.id == 4 then 
		-- 	tItem.status = 2
		-- end
		tItem.basicInfo = CopyTable(GDatatab_awake_base["id_" .. awakeConfigId[i]])

		table.insert(self.m_tWakeupList, tItem)
	end
	table.sort(self.m_tWakeupList, function (a,b)
		return a.id < b.id 
	end)

	local nCurSection = self:_getActiveNum()
	if not self.m_nTopSelIndex then
		self.m_nTopSelIndex = nCurSection
		if self.m_tWakeupList[nCurSection + 1] and self.m_tWakeupList[nCurSection + 1].status > 0 then
			self.m_nTopSelIndex = nCurSection + 1
		end
	end
	self:setLeftListData(nCurSection)

	--显示天赋点重置按钮
	if self.m_tWakeupList[3].status == 2 then
		self.m_topCellLua.goldCellInfo.tcell:createResetBtn(self, self.onClickReset)
	end

	WZLog("WndWakeup:setData", Serialize(inbornId), awakeSkillId)
	self:setPowerData(inbornId)
	--设置觉醒之技数据
	self:setSkillData(awakeSkillId)
	--设置进化等级
	self:setEvolveLevel(evolveLevel)

	if self.m_nLeftSelIndex == 0 then
		self:_createWakeup()
	else
		self:_createWakeupDetail(self.m_nLeftSelIndex)
	end
end

--@brief 	根据索引获取相应的觉醒任务数据
function WndWakeup:getTaskData(nIndex)
	-- body
	for i = 1, #self.m_tWakeupList do
		if nIndex == self.m_tWakeupList[i].id then
			return self.m_tWakeupList[i]
		end
	end

	return nil 
end

--@brief 	设置觉醒之力的数据
function WndWakeup:setPowerData(id)
	-- body
	self.m_tPowerList = {}

	for i = 1, #id do
		if GDatatab_talent_Skill["id_" .. id[i]] then 
			local tItem = {}
			tItem.id = id[i] 
			tItem.type = GDatatab_talent_Skill["id_" .. id[i]].type
			if tItem.type <= 15 then
				table.insert(self.m_tPowerList, tItem)
			end
		end
	end

	table.sort(self.m_tPowerList, function (a,b)
		-- body
		return a.type < b.type
	end)
end

--@brief 	设置觉醒之技的数据
function WndWakeup:setSkillData(awakeSkillId)
	-- body
	self.m_nAwakeSkillId = awakeSkillId
end

--@brief 	获取觉醒之力数据
function WndWakeup:getPowerData()
	-- body
	return self.m_tPowerList 
end

--@brief 	获取觉醒之技子技能Id
function WndWakeup:getAwakeSkillId()
	-- body
	return self.m_nAwakeSkillId
end

--@brief	获取觉醒之魂等级和当前经验
function WndWakeup:getSoulLevelAndExp()
	-- body
	return self.m_nSoulLevel, self.m_nCurSoulExp
end

----@brief	获取幻化时装的领取状态
function WndWakeup:getBodyState()
	-- body
	return self.m_nBodyState
end

--@brief 	觉醒成功
--@param 	awakeId:觉醒的id
function WndWakeup:awakeOk(awakeId)
	-- body
	self:_stopLoading()

	local spinePath = "ui/otherUI/common_icon_jxcg"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOK = WZUISpine:create()
		if spineOK then
	        self.m_root:addChild(spineOK)
	        spineOK:setFileAtlas(spinePath .. ".atlas")
	        spineOK:setFileJson(spinePath .. ".json")
	        spineOK:play("common_icon_jxcg", false)
	        spineOK:setShowAll(true)
	        spineOK:setRelativePosition(GlobalMethod:ccp(0.5, 1))
	        spineOK:setTouchEnable(false)
	        spineOK:enableSchedule("removeTheAction",1.2)
		end
	else
		local _sIndex = "common_icon_jxcg"
        local downloadInfo = GetDownloadInfo(_sIndex, "uiEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(14206,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
        end
	end
	--修改觉醒的id状态
	self:_createLoading()
    ProtocolProcessorWakeup:send_AWAKE_GetAwakeInfo()
end

--@brief 	移除掉觉醒成功特效
function WndWakeup:removeTheAction(element)
	-- body
	if element then
		element:removeFromParentAndCleanup(true)
	end
end

--@brief 	培养成功
function WndWakeup:trainOK(currentLevel, currentExp, baseExp, multiple, preLevel, level)
	--body
	self:_stopLoading()
	if self.m_bIsTraining then 
		CellWakeupDetail:resetImmediately(self.m_nSoulLevel, self.m_nCurSoulExp)
		self.m_bIsTraining = false
	end

	self.m_bIsTraining = true

	self.m_nSoulLevel = currentLevel 
	self.m_nCurSoulExp = currentExp

	CellWakeupDetail:trainOK(currentLevel, currentExp, baseExp, multiple, preLevel, level)
end

--@brief 	领取幻化皮肤成功
function WndWakeup:receiveSkinOK()
	-- body
	self:_stopLoading()
	self.m_nBodyState = 1

	local sequence = WZUIActionSequence:create()
    local delayAni3 = WZUIActionDelayTime:create()
    delayAni3:setDuration(0.65)

    local functionAni = WZUIActionCallLuaFunction:create()
    functionAni:setLuaFunction("_openBodyBoxSpine")

    local functionAni1 = WZUIActionCallLuaFunction:create()
    functionAni1:setLuaFunction("_afterSpine")

    sequence:setChildAction(functionAni)
    sequence:setChildAction(delayAni3)
    sequence:setChildAction(functionAni1)

    self.m_root:runUIAction(sequence)
end

--@brief 	激活或升级天赋技能成功
function WndWakeup:upgradeInbornOK(talentId)
	-- body
	self:_stopLoading()

	local tTempData = GDatatab_talent_Skill["id_" .. talentId]
	WZLog("WndWakeup:upgradeInbornOK", talentId)
	if tTempData == nil then return end 

	if tTempData.type <= 15 then 
		for i = 1, #self.m_tPowerList do 
			if self.m_tPowerList[i].type == tTempData.type then 
				self.m_tPowerList[i].id = talentId
				break 
			end
		end
	end
	CellWakeupDetail:upgradeInbornOK(talentId)
end

--@brief 	播放打开宝箱特效
function WndWakeup:_openBodyBoxSpine()
	-- body
	GetElement(self.m_root, "conRecSkin_WndWakeup", WZUIContainer):setVisible(true)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndWakeup", WZUISpine)
	if spineOpen then
		spineOpen:setVisible(true)
		spineOpen:play("ui_juexingzhihun_lingqu", false)
	end
end

--@brief 	
function WndWakeup:_afterSpine()
	-- body
	GetElement(self.m_root, "conRecSkin_WndWakeup", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "spineOpen_WndWakeup", WZUISpine):setVisible(false)

	local skinId = CellWakeupDetail:_getCorrectSkin()
	local tData = {}
	tData.shapeId = skinId
	tData.remainTime = -1

	WndPhantomShow:show(tData)
	CellWakeupDetail:showInterface(nil, self.m_nLeftSelIndex)
end
--@brief 	重置觉醒天赋点OK
function WndWakeup:resetInbornAndSkillOK(status, inbornId, awakeSkillId)
	--body
	if self.m_root == nil then return end 
	self:_stopLoading()

	if status == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT45)

		WZLog("WndWakeup:setData", Serialize(inbornId), awakeSkillId)
		self:setPowerData(inbornId)
		--设置觉醒之技数据
		self:setSkillData(awakeSkillId)

		if self.m_nLeftSelIndex == 3 or self.m_nLeftSelIndex == 4 then
			self:_createWakeupDetail(self.m_nLeftSelIndex)
		end
	end
end

--@brief 	进化成功
function WndWakeup:evolveOk(status)
	--body
	self:_stopLoading()
	WZLog("WndWakeup:evolveOk", status)
	if status == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.WAKEUP_TEXT52)
		self.m_nEvolveLevel = self.m_nEvolveLevel + 1
		local nAddLevel = 0
		local tEvolveData = GDatatab_awake_evolution["id_" .. self.m_nEvolveLevel]
		if tEvolveData.pre_id == -1 then 
			nAddLevel = tEvolveData.lv_open
		elseif tEvolveData.pre_id > 0 then 
			local tPreEvolveData = GDatatab_awake_evolution["id_" .. tEvolveData.pre_id]
			nAddLevel = tEvolveData.lv_open - tPreEvolveData.lv_open
		end
		CacheCenter:getGameParam().gameMaxLevel = CacheCenter:getGameParam().gameMaxLevel + nAddLevel
		self:_createWakeupDetail(self.m_nLeftSelIndex)
	end
end

--@brief 	设置进化等级
function WndWakeup:setEvolveLevel(evolveLevel)
	-- body
	self.m_nEvolveLevel = evolveLevel
end

--@brief 	获取进化等级
function WndWakeup:getEvolveLevel()
	-- body
	return self.m_nEvolveLevel 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	根据传进来的任务id返回任务数据
--@param 	sId: 任务id组："1,2,3"
--@param 	taskConfigId: 所有任务id
--@param 	progress: 所有任务进度
function WndWakeup:_getWakeupTaskData(sId, taskConfigId, progress)
	-- body
	local tId = SplitStringWithSeparator(sId, ",")
	local tTaskData = {}

	for i = 1, #tId do
		local tItem = {}
		tItem.id = tId[i]
		tItem.basicInfo = CopyTable(GDatatab_awake_task["id_" .. tId[i]])
		for j = 1, #taskConfigId do
			if tonumber(tId[i]) == taskConfigId[j] then
				tItem.complete = progress[j]
				break 
			end
		end
		if tItem.basicInfo.task_type == 5 then
			local tTempData = SplitStringWithSeparator(tItem.basicInfo.params, ",")
			tItem.target = tTempData[3]
		else
			tItem.target = 1
		end

		table.insert(tTaskData, tItem)
	end

	return tTaskData
end

--@brief 	获取已经激活的数量
function WndWakeup:_getActiveNum()
	-- body
	local nTempNum = 0

	for i = 1, #self.m_tWakeupList do
		if self.m_tWakeupList[i].status == 2 then
			nTempNum = nTempNum + 1
		end
	end

	return nTempNum 
end

--@brief    数据加载动画
function WndWakeup:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndWakeup:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief 	判断是否需要重置
function WndWakeup:_judgeNeedReset()
	-- body
	local bNeedReset = false 

	for i = 1, #self.m_tPowerList do
		local tData = GDatatab_talent_Skill["id_" .. self.m_tPowerList[i].id] 
		if tData.level > 0 then
			bNeedReset = true
			break 
		end
	end

	if not bNeedReset then
		if self.m_nAwakeSkillId then
			local tData = GDatatab_skill["id_" .. self.m_nAwakeSkillId]
			if tData and tData.specialAttackParam > 1 then
				bNeedReset = true
			end
		end
	end

	return bNeedReset
end
-------------------------------------私有方法模块End----------------------------------------
