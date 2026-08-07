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
end

function WndMaster:onEnterTransitionDidFinish(element)
	self.m_nCurIndex = 1

	local masterInfo = CacheCenter:getMasterInfo()
	local playerInfo = CacheCenter:getPlayerInfo()
	if playerInfo.level < MASTERLEVEL and masterInfo.hasMaster == true then
		self.m_nCurIndex = 2
	end
	if playerInfo.level >= MASTERLEVEL and masterInfo.pupil > 0 then
		self.m_nCurIndex = 2
	end

	self:_updateCheckboxGroupIndex()

	--更新界面
	self:_changeWndowByCurIndex()

	--添加顶部栏
	self:_addTop()
end

function WndMaster:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_stsd.png",WndMaster,WndMaster.onClose,false,true,false,"WndMaster")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMaster:onExit(element)
	 --add by wuweidong
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","WndMaster")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","WndMaster")
	self:_unInit()
end

--@brief	退出师徒系统
function WndMaster:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndMaster, true)
	end 
end

--@brief	点击界面
function WndMaster:onTouchBegan()
	WZLog("WndMaster:onTouchBegan",self.m_nCurIndex)
	if self.m_nCurIndex == nil then return end
	self:_updateCheckboxGroupIndex()
    -- TIP处理
	if WndTips then
		WndTips:onCloseClick()
	end
    WndItemInfo:_onCloseClick()
end

--@brief	点击界面
function WndMaster:onTouchEnd()
	WZLog("WndMaster:onTouchEnd",self.m_nCurIndex)
	if self.m_nCurIndex == nil then return end
	self:_updateCheckboxGroupIndex()
end

--@brief 	更新CheckboxGroup选中标签
function WndMaster:_updateCheckboxGroupIndex()
	GetElement(self.m_root, "checkGroup_WndMaster", WZUICheckBoxGroup):setCheckIndex(self.m_nCurIndex-1)
end

--@brief	切换到师徒大厅
function WndMaster:onCheck1(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	if 1 == self.m_nCurIndex then
		return
	end

	self.m_nCurIndex = 1
	self:_updateCheckboxGroupIndex()

	--更新界面
	self:_changeWndowByCurIndex()

	--获取师徒信息 
	ProtocolProcessorWndMaster:send_MENTORING_GetTemple()
end

--@brief	切换到师徒成员
function WndMaster:onCheck2(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local masterInfo = CacheCenter:getMasterInfo()
	local playerInfo = CacheCenter:getPlayerInfo()
	if masterInfo == nil or playerInfo == nil then return end
	WZLog("WndMaster:onCheck2",Serialize(masterInfo))
	if playerInfo.level < MASTERLEVEL and masterInfo.hasMaster == false then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO32) 
		return
	end
	if playerInfo.level >= MASTERLEVEL and masterInfo.pupil == 0 then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO33) 
		return
	end

	if 2 == self.m_nCurIndex then
		return
	end

	self.m_nCurIndex = 2

	--更新界面
	self:_changeWndowByCurIndex()

	if playerInfo.level < MASTERLEVEL then
		--我的等级小于等于35,获得我的师傅列表
		ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster()
	else
		--我的等级大于35,获得我的徒弟列表
		ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils()
	end
end

--@brief	切换到师徒奖励
function WndMaster:onCheck3(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	if 3 == self.m_nCurIndex then
		return
	end

	self.m_nCurIndex = 3

	--更新界面
	self:_changeWndowByCurIndex()
end

--@brief	切换到师徒消息
function WndMaster:onCheck4(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	if 4 == self.m_nCurIndex then
		return
	end

	self.m_nCurIndex = 4

	--设置消息已查看
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo ~= nil then
		masterInfo.message = false
	end

	--更新界面
	self:_changeWndowByCurIndex()
end

--@brief	切换到师徒目标
function WndMaster:onCheck5(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local masterInfo = CacheCenter:getMasterInfo()
	local playerInfo = CacheCenter:getPlayerInfo()
	if masterInfo == nil or playerInfo == nil then return end
	if playerInfo.level < MASTERLEVEL and masterInfo.hasMaster == false then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO32) 
		return
	end
	if playerInfo.level >= MASTERLEVEL and masterInfo.pupil == 0 then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO33) 
		return
	end

	if 5 == self.m_nCurIndex then
		return
	end

	self.m_nCurIndex = 5

	--设置消息已查看
	--local masterInfo = CacheCenter:getMasterInfo()
	--if masterInfo ~= nil then
	--	masterInfo.message = false
	--end

	--更新界面
	self:_changeWndowByCurIndex()
end

--@biref	根据当前索引打开相应界面
--@note		根据当前索引打开相应界面
function WndMaster:_changeWndowByCurIndex()
	--窗口默认不可见，清空玩家窗口设置
	if self.m_tHallElement ~= nil then
		self.m_tHallElement:setVisible(false)
	end
	if self.m_tMemberElement ~= nil then
		self.m_tMemberElement:setVisible(false)
	end
	if self.m_tRewardElement ~= nil then
		self.m_tRewardElement:setVisible(false)
	end
	if self.m_tLogElement ~= nil then
		self.m_tLogElement:setVisible(false)
	end
	if self.m_tTarget ~= nil then
		self.m_tTarget:setVisible(false)
	end
	
	local playerInfo = CacheCenter:getPlayerInfo()
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil or playerInfo == nil then return end
	--是否显示消息提示
	if masterInfo.message == true then
		GetElement(self.m_root, "hasMessage_WndMaster", WZUIImage):setVisible(true)
	else
		GetElement(self.m_root, "hasMessage_WndMaster", WZUIImage):setVisible(false)
	end
	--切换到师徒大厅
	if 1 == self.m_nCurIndex then
		if self.m_tHallElement == nil then
			self.m_tHallElement = WndMasterHall:createElement()
			local conCurWindow = self.m_root:getChildElement("conMain")
			conCurWindow:addChild(self.m_tHallElement)
		end
		GetElement(self.m_tHallElement,"tbConRole_WndMasterHall",WZUITableContainer):setVisible(false)
		self.m_tHallElement:setVisible(true)
		GetElement(self.m_root, "conBlackBg_WndMaster", WZUIContainer):setVisible(false)
	--切换到师徒成员
	elseif 2 == self.m_nCurIndex then
		if self.m_tMemberElement == nil then
			self.m_tMemberElement = WndMasterMember:createElement()
			local conCurWindow = self.m_root:getChildElement("conMain")
			conCurWindow:addChild(self.m_tMemberElement)
		end
		self.m_tMemberElement:setVisible(true)

		if playerInfo.level < MASTERLEVEL then
			--我的等级小于等于35,获得我的师傅列表
			ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster()
		else
			--我的等级大于35,获得我的徒弟列表
			ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils()
		end
		ProtocolProcessorWndMaster:send_MENTORING_GetTemple()
		GetElement(self.m_root, "conBlackBg_WndMaster", WZUIContainer):setVisible(false)
	--切换到师徒奖励
	elseif 3 == self.m_nCurIndex then
		if self.m_tRewardElement ~= nil then
			self.m_tRewardElement:removeFromParentAndCleanup(true)
			self.m_tRewardElement = nil
		end
		if self.m_tRewardElement == nil then
			self.m_tRewardElement = WndMasterReward:createElement()
			local conCurWindow = self.m_root:getChildElement("conMain")
			conCurWindow:addChild(self.m_tRewardElement)
		end
		self.m_tRewardElement:setVisible(true)

		if playerInfo.level < MASTERLEVEL then
			--我的等级小于等于35,徒弟奖励
			WndMasterReward:updateDiscipleReward()
		else
			--我的等级大于35,师傅奖励
			WndMasterReward:updateMasterReward()
		end
		GetElement(self.m_root, "conBlackBg_WndMaster", WZUIContainer):setVisible(true)
	--切换到师徒消息
	elseif 4 == self.m_nCurIndex then
		if self.m_tLogElement == nil then
			self.m_tLogElement = WndMasterLog:createElement()
			local conCurWindow = self.m_root:getChildElement("conMain")
			conCurWindow:addChild(self.m_tLogElement)
		end
		self.m_tLogElement:setVisible(true)
		GetElement(self.m_root, "conBlackBg_WndMaster", WZUIContainer):setVisible(true)
		--获得消息列表
		ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage()
	--切换到师徒目标
	elseif 5 == self.m_nCurIndex then
		if self.m_tTarget ~= nil then
			self.m_tTarget:removeFromParentAndCleanup(true)
			self.m_tTarget = nil
		end
		if self.m_tTarget == nil then
			self.m_tTarget = WndMasterTask:createElement()
			local conCurWindow = self.m_root:getChildElement("conMain")
			conCurWindow:addChild(self.m_tTarget)
		end
		self.m_tTarget:setVisible(true)
		GetElement(self.m_root, "conBlackBg_WndMaster", WZUIContainer):setVisible(true)
		--获得消息列表
		--ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
