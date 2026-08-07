--WndMaster.lua
--@brief	WndMaster的UI模块
--@date		2015/05/27
--@author	zsq
--@note		师徒大厅


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMaster:onEnter(element)
	self.m_root = element

	self:register()

    ProtocolProcessorWndMaster:regAll1()
	ProtocolProcessorWndMaster:send_MENTORING_GetTemple()

	self:_initStaticText()

	self:_addTop()
end

function WndMaster:register()
    GlobalGame:getGameEventDispathcer():Add(FriendEvent.FriendEvent_TeachBox,self._onGetBuyBoxResult,self)
    GlobalGame:getGameEventDispathcer():Add(FriendEvent.FriendEvent_TeachActivityBox,self._onGetActivityBoxInfo,self)
    GlobalGame:getGameEventDispathcer():Add(FriendEvent.FriendEvent_RemoveTeachRelation,self._onRemoveTeachRelationResult,self)
    GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.updateRedDot, self)
end

function WndMaster:unregister()
    GlobalGame:getGameEventDispathcer():Remove(FriendEvent.FriendEvent_TeachBox,self._onGetBuyBoxResult,self)
    GlobalGame:getGameEventDispathcer():Remove(FriendEvent.FriendEvent_TeachActivityBox,self._onGetActivityBoxInfo,self)
    GlobalGame:getGameEventDispathcer():Remove(FriendEvent.FriendEvent_RemoveTeachRelation,self._onRemoveTeachRelationResult,self)
    GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.updateRedDot, self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMaster:onExit(element)
	self:_unInit()
	self:unregister()
end

function WndMaster:onEnterTransitionDidFinish(element)
end

--@brief	初始化静态文本
function WndMaster:_initStaticText()
	GetElement(self.m_root, "txtCheckN1_WndMaster", WZUILabelTTF):setText(LocalStrings.HALL)
	GetElement(self.m_root, "txtCheckS1_WndMaster", WZUILabelTTF):setText(LocalStrings.HALL)
	GetElement(self.m_root, "txtCheckN2_WndMaster", WZUILabelTTF):setText(LocalStrings.OPTIMIZE_TEXT56)
	GetElement(self.m_root, "txtCheckS2_WndMaster", WZUILabelTTF):setText(LocalStrings.OPTIMIZE_TEXT56)
	GetElement(self.m_root, "txtCheckN3_WndMaster", WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[1])
	GetElement(self.m_root, "txtCheckS3_WndMaster", WZUILabelTTF):setText(LocalStrings.FACTION_TEXT1[1])
	GetElement(self.m_root, "txtCheckN4_WndMaster", WZUILabelTTF):setText(LocalStrings.APPRENTICE)
	GetElement(self.m_root, "txtCheckS4_WndMaster", WZUILabelTTF):setText(LocalStrings.APPRENTICE)
	GetElement(self.m_root, "txtCheckN5_WndMaster", WZUILabelTTF):setText(LocalStrings.TASK_UINAME)
	GetElement(self.m_root, "txtCheckS5_WndMaster", WZUILabelTTF):setText(LocalStrings.TASK_UINAME)
	GetElement(self.m_root, "txtCheckN6_WndMaster", WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
	GetElement(self.m_root, "txtCheckS6_WndMaster", WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
	GetElement(self.m_root, "txtCheckN7_WndMaster", WZUILabelTTF):setText(LocalStrings.MASTERINFO24)
	GetElement(self.m_root, "txtCheckS7_WndMaster", WZUILabelTTF):setText(LocalStrings.MASTERINFO24)
end

--@brief	顶部栏
function WndMaster:_addTop()
	local cell,tcell = CellTopHandle:createElement()
	self.m_root:addChild(cell)
	tcell:setTopData("ui/common/common_icon_stsd.png",self,self.onClose,false,true,false,"WndMaster")
end

--@brief	退出师徒系统
function WndMaster:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	点击界面
function WndMaster:onTouchBegan(element, pt)
	WZLog("WndMaster:onTouchBegan")
	WndItemInfo:closeWin()

	self:checkCloseTarget(pt)
end

--@brief	点击界面
function WndMaster:onTouchEnd()
	WZLog("WndMaster:onTouchEnd")
end

function WndMaster:checkCloseTarget(pt)
    if self.m_root == nil then return end

    local conTarget = GetElement(self.m_root, "conTarget_WndMaster", WZUIContainer)
    if conTarget:isVisible() then
	    local conSize = conTarget:getContentSize()
	    local ptA = conTarget:convertToWorldSpace(GlobalMethod:ccp(0,0))
	    if (pt.x > ptA.x and pt.x < ptA.x + conSize.width) and (pt.y > ptA.y and pt.y < ptA.y + conSize.height) then
    	else
	        conTarget:setVisible(false)
	    end
    end
end

--@brief	切换标签
function WndMaster:onCheck(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()

	if tag == self.m_nCurIndex then
		return
	end

	self.m_nCurIndex = tag

	self:updateUI()
end

--@brief	切换标签
function WndMaster:updateCheck()
	GetElement(self.m_root,"checkGroup_WndMaster",WZUICheckBoxGroup):setCheckIndex(self.m_nCurIndex-1)
end

--@biref	根据当前索引打开相应界面
function WndMaster:updateUI()
	self:updateRedDot()
	self:updateCheck()

	--窗口默认不可见，清空玩家窗口设置
	for i=1,7 do
		if self.m_tCheckElement[i] then
			self.m_tCheckElement[i]:setVisible(false)
		end
	end

	local playerInfo = CacheCenter:getPlayerInfo()
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil or playerInfo == nil then return end

	local conMain = GetElement(self.m_root,"conMain_WndMaster",WZUIContainer)
	--切换到师徒大厅
	if 1 == self.m_nCurIndex then --大厅
		if self.m_tCheckElement[self.m_nCurIndex] == nil then
			self.m_tCheckElement[self.m_nCurIndex] = WndMasterHall:createElement()
			conMain:addChild(self.m_tCheckElement[self.m_nCurIndex])
		end
	elseif 2 == self.m_nCurIndex then --师门
		if self.m_tCheckElement[self.m_nCurIndex] ~= nil then
			self.m_tCheckElement[self.m_nCurIndex]:removeFromParentAndCleanup(true)
			self.m_tCheckElement[self.m_nCurIndex] = nil
		end
		if self.m_tCheckElement[self.m_nCurIndex] == nil then
			self.m_tCheckElement[self.m_nCurIndex] = WndMasterMember1:createElement(1)
			conMain:addChild(self.m_tCheckElement[self.m_nCurIndex])
			ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster()
		end
		WndMasterMember1:setSceneType()
	elseif 3 == self.m_nCurIndex then --宗门
		if self.m_tCheckElement[self.m_nCurIndex] ~= nil then
			self.m_tCheckElement[self.m_nCurIndex]:removeFromParentAndCleanup(true)
			self.m_tCheckElement[self.m_nCurIndex] = nil
		end
		if self.m_tCheckElement[self.m_nCurIndex] == nil then
			self.m_tCheckElement[self.m_nCurIndex] = WndFactionMain:createElement()
			conMain:addChild(self.m_tCheckElement[self.m_nCurIndex])
		end
	elseif 4 == self.m_nCurIndex then --徒弟
		-- if self.m_tCheckElement[self.m_nCurIndex] ~= nil then
		-- 	self.m_tCheckElement[self.m_nCurIndex]:removeFromParentAndCleanup(true)
		-- 	self.m_tCheckElement[self.m_nCurIndex] = nil
		-- end
		if self.m_tCheckElement[self.m_nCurIndex] == nil then
			self.m_tCheckElement[self.m_nCurIndex] = WndMasterMember:createElement(2)
			conMain:addChild(self.m_tCheckElement[self.m_nCurIndex])
		end
		ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils()
		WndMasterMember:setSceneType()
	elseif 5 == self.m_nCurIndex then --任务
		if self.m_tCheckElement[self.m_nCurIndex] ~= nil then
			self.m_tCheckElement[self.m_nCurIndex]:removeFromParentAndCleanup(true)
			self.m_tCheckElement[self.m_nCurIndex] = nil
		end
		if self.m_tCheckElement[self.m_nCurIndex] == nil then
			self.m_tCheckElement[self.m_nCurIndex] = WndFactionTask:createElement()
			conMain:addChild(self.m_tCheckElement[self.m_nCurIndex])
		end
	elseif 6 == self.m_nCurIndex then --奖励
		if self.m_tCheckElement[self.m_nCurIndex] ~= nil then
			self.m_tCheckElement[self.m_nCurIndex]:removeFromParentAndCleanup(true)
			self.m_tCheckElement[self.m_nCurIndex] = nil
		end
		if self.m_tCheckElement[self.m_nCurIndex] == nil then
			self.m_tCheckElement[self.m_nCurIndex] = WndMasterReward:createElement()
			conMain:addChild(self.m_tCheckElement[self.m_nCurIndex])
		end
	elseif 7 == self.m_nCurIndex then --消息
		if self.m_tCheckElement[self.m_nCurIndex] == nil then
			self.m_tCheckElement[self.m_nCurIndex] = WndMasterLog:createElement()
			conMain:addChild(self.m_tCheckElement[self.m_nCurIndex])
		end
		ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage()
	end
	if self.m_tCheckElement[self.m_nCurIndex] then
		self.m_tCheckElement[self.m_nCurIndex]:setVisible(true)
	end

	local conBtns = GetElement(self.m_root,"conBtns_WndMaster",WZUIContainer)
	if 2 == self.m_nCurIndex then
		conBtns:setVisible(true)
	else
		conBtns:setVisible(false)
	end
end

--@brief	师徒大厅说明
function WndMaster:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.MASTERINFO3)
end

--@brief	点击师徒目标按钮回调
function WndMaster:onBtnClickMasterTager(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_tTarget ~= nil then
        self.m_tTarget:removeFromParentAndCleanup(true)
        self.m_tTarget = nil
    end
    if self.m_tTarget == nil then
        self.m_tTarget = WndMasterTask:createElement()
        local conTarget = GetElement(self.m_root,"conTarget_WndMaster",WZUIContainer)
        conTarget:addChild(self.m_tTarget)
        conTarget:setVisible(true)
	    self.m_tTarget:setVisible(true)
    end
end

--@brief	点击师徒宝箱按钮回调
function WndMaster:onBtnClickMasterBox(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local masterInfo = CacheCenter:getMasterInfo()
    if masterInfo and masterInfo.hasMaster == true then
        ProtocolProcessorWndMaster:send_MENTORING_GetMyBagInfo()
    else
        MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT71)
    end
end

--@brief	是否存在购买宝箱行为
function WndMaster:_onGetBuyBoxResult(bagType)
    if bagType == -2 then
        MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT72)
    elseif bagType == 0 then --购买宝箱
        WndMasterBuyBox:showInterface()
    elseif bagType == 1 or bagType == 2 or bagType == 3 then
        ProtocolProcessorWndMaster:send_MENTORING_GetBagInfo(0)
    end
end

--@brief	查看宝箱的活跃度
function WndMaster:_onGetActivityBoxInfo(playerId, progress, bagType, status)
    --本人的时候
    if playerId == 0 then
        WndMasterBoxActivity:showInterface(progress, bagType, status)
    end
end

--@brief	解除关系
function WndMaster:_onRemoveTeachRelationResult()
    --返回师徒大厅
    self.m_nCurIndex = 1
    self:updateUI()
end

--@brief	更新红点
function WndMaster:updateRedDot()
	self:setMasterTagerRedPoint()
	self:setDisCipleRedPoint()

	self:setMasterLogRedPoint()
end

--@brief	师徒目标的红点
function WndMaster:setMasterTagerRedPoint()
    if not self.m_root then return end

    local imgCheckRedDot2 = GetElement(self.m_root,"imgCheckRedDot2_WndMaster",WZUIImage)
    local visible = GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[300] or GlobalGame.g_tRedPointTypeList[301])
    imgCheckRedDot2:setVisible(visible)

    local hasTarget = GetElement(self.m_root,"hasTarget_WndMaster",WZUIImage)
    local visible =  GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[300]
    hasTarget:setVisible(visible)
end

--@brief	徒弟购买宝箱红点
function WndMaster:setDisCipleRedPoint()
    if not self.m_root then return end

    local imgCheckRedDot2 = GetElement(self.m_root,"imgCheckRedDot2_WndMaster",WZUIImage)
    local visible =  GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[300] or GlobalGame.g_tRedPointTypeList[301])
    imgCheckRedDot2:setVisible(visible)

    local hasTarget = GetElement(self.m_root,"hasBox_WndMaster",WZUIImage)
    local visible =  GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[301]
    hasTarget:setVisible(visible)
end

--@brief	消息的红点
function WndMaster:setMasterLogRedPoint()
    if not self.m_root then return end

    local masterInfo = CacheCenter:getMasterInfo()
    if not masterInfo then return end

    if masterInfo.message == true then
        GetElement(self.m_root, "imgCheckRedDot7_WndMaster", WZUIImage):setVisible(true)
    else
        GetElement(self.m_root, "imgCheckRedDot7_WndMaster", WZUIImage):setVisible(false)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
