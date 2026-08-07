--SceneLeagueRoom.lua
--@brief	SceneLeagueRoom的UI模块
--@date		2016-06-27
--@author	binshao
--@note		英雄联赛房间


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneLeagueRoom:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	WZLog("---------------onEnter---------------")
	ChangeChatChannel(Chat_Channel_League_ROOM)
	--self:_initTipsData()
	local arm = GetElement(self.m_root,"armVs_SceneLeagueRoom",WZArmature)
	arm:enableSchedule("armFinish",0.5)

	self:update()
	AddButtomChatToRoot("SceneLeagueRoom",self.m_root)
	AddChatToCurScene()
end

function SceneLeagueRoom:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function SceneLeagueRoom:actionCallback(element, data)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneLeagueRoom:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	显示接口
function SceneLeagueRoom:showScene()
	WZLog("SceneLeagueRoom:show self.m_root",self.m_root)
	if self.m_root == nil then 
		local scene = SceneLeagueRoom:createElement()
		replaceScene(scene)
	end
	WZLog("SceneLeagueRoom:show self.m_root1",self.m_root)
end

function SceneLeagueRoom:createLoadingBox()
	if not self.loadingId then
		self.loadingId = MsgBoxManager:showLoadingBox(10,self,self.closeLoadingBox)
	end
end

function SceneLeagueRoom:closeLoadingBox()
	MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
	self.loadingId = nil
end

function SceneLeagueRoom:onTouchBegin(element, point)
	local bPoint = WndItemInfo:checkPoint(point)
	if not bPoint then  WndItemInfo:onCloseClick() end
	WndTips:onCloseClick()
end

-- 取消匹配
function SceneLeagueRoom:onBack()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self:judgeCaptain() then
		WZLog("-----------cancel make pair-----------")
		SceneLeagueRoom:createLoadingBox()
		ProtocolProcessorWndLeague:send_HERO_EndMakePairHero( )
	end
end

function SceneLeagueRoom:onChat()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndChat:showChatWindowForFightingByOrder()
end

function SceneLeagueRoom:update()
	WZLog("----------update------------root",self.m_root)
	WZLog("----------update------------teamInfo",self.teamInfo)
	if not self.m_root then return end
	if not self.teamInfo then return end
	WZLog("----------update------------OK")
	self:initBtnAndTimeOut()
	self:createFightHead()
	self:createPlayer()
end

-- 创建玩家
function SceneLeagueRoom:createPlayer()
	WZLog("----------createPlayer------------")
	for i = 1,6 do
		local con = GetElement(self.m_root, "conPlayer"..i.."_SceneLeagueRoom", WZUIContainer)
		if self.pInfo[i] then
			-- 如果是从没人到有人，信息更新，则去掉原来的没人
			if con:getChildByTag(88) then
				con:removeChildByTag(88,true)
			end

			-- 如果有人，但没有创建有人界面，则创建有人界面
			if not con:getChildByTag(99) then
				local cell,tcell = CellLeaguePlayer:createElement()
				tcell:setData(self.pInfo[i])
				con:addChild(cell,0,99)
				WZLog("------------create have Player role-----------",i)
			end
		else
			-- 如果原来有人，变成没人
			if con:getChildByTag(99) then
				con:removeChildByTag(99,true)
			end

			-- 没人创建没人界面
			if not con:getChildByTag(88) then
				local cell,tcell = CellLeaguePlayer:createElement()
				tcell:setData(self.pInfo[i])
				con:addChild(cell,0,88)
				WZLog("------------create not Player role-----------",i)
			end
		end

	end
end

-- 创建战队头像
function SceneLeagueRoom:createFightHead()
	if self.teamInfo then
		for i = 1, 2 do
			local info = self.teamInfo[i]
			local txtName = GetElement(self.m_root, "txtName"..i.."_SceneLeagueRoom", WZUILabelTTF)
			local conIcon = GetElement(self.m_root, "conIcon"..i.."_SceneLeagueRoom", WZUIContainer)
			if info.teamName then txtName:setText(info.teamName) end
			local celElement,tCell = CellDownloadImg:createElement()
			conIcon:addChild(celElement)
			SceneLeagueMain:addDownloadFileList(info.url, tCell, nil, 60)
		end
	end
end

function SceneLeagueRoom:initTimeOut()
	local time = CacheCenter:getLeagueInfo().countDown
	WZLog("---------------timeDown--------------",time)
	self.timeLS = time or 0
	local txtTime = GetElement(self.m_root, "txtTime_SceneLeagueRoom", WZUILabelTTF)
	txtTime:setText(string.format(LocalStrings.LEAGUE_READY_JOIN,self.timeLS))
	txtTime:enableSchedule("schedultTime",1)
end

-- 开战倒计时
function SceneLeagueRoom:schedultTime(element,time)
	WZLog("-----------time out-----------",self.timeLS)
	local txtTime = GetElement(self.m_root, "txtTime_SceneLeagueRoom", WZUILabelTTF)
	self.timeLS = self.timeLS - 1
	if self.timeLS < 0 then
		self.timeLS = 0
		txtTime:disableSchedule()
	end
	txtTime:setText(string.format(LocalStrings.LEAGUE_READY_JOIN,self.timeLS))
end

-- 动画播放完
function SceneLeagueRoom:armFinish()
	local arm = GetElement(self.m_root,"armVs_SceneLeagueRoom",WZArmature)
	arm:disableSchedule()
	arm:clearAnimationFinishLuaCallback()
	local action = WZUIArmatureAnimationById:create()
	action:setAnimationId(1)
	action:setLoop(1)
	arm:runUIAction(action)
end


-- 初始化btn，海选和非队长不显示
function SceneLeagueRoom:initBtnAndTimeOut()
	if not self.btnFlag then
		self.btnFlag = true
		local flag = self:judgeCaptain()
		local btn = GetElement(self.m_root, "btnBack_SceneLeagueRoom", WZUIButton)
		btn:setVisible(flag)

		self:initTimeOut()
	end
end

-- 判断是否需要添加人数少的提示
function SceneLeagueRoom:needShowBox()
	if self.m_root and self.timeOut then
		 return true
	end
	return false
end

function SceneLeagueRoom:getTipsCon()
	local con = GetElement(self.m_root,"conTips_SceneLeagueRoom",WZUIContainer)
	return con
end

function SceneLeagueRoom:updateGrade(fightMes,teamId)
	WZLog("----------------result---------------",fightMes,teamId)
	if self.m_root == nil then return end
	local winCnt = 0
	if fightMes then
		local len = string.len(fightMes)
		for i = 1, len do
			local result = string.sub(fightMes,i,i)
			if tonumber(result) == 1 then
				winCnt = winCnt + 1
			end
		end
	end

	-- 战绩比
	local txtF = GetElement(self.m_root,"txtRate_SceneLeagueRoom",WZUILabelTTF)
	if teamId == self.teamInfo[1].teamId then
		self.myWin = winCnt
	elseif teamId == self.teamInfo[2].teamId then
		self.otherWin = winCnt
	end
	txtF:setText(self.myWin..":"..self.otherWin)

	-- 联赛round
	local round = self:getCurRound()
	local txtR = GetElement(self.m_root,"txtRound_SceneLeagueRoom",WZUILabelTTF)
	txtR:setText(round)

	local con16 = GetElement(self.m_root,"con16_SceneLeagueRoom",WZUIContainer)
	con16:setVisible(true)
end


--	2,3,4小组赛第一二三轮
--	5,6,7十六强第一二三轮
--	8,9,10八强赛第一二三轮
--	11,12,13半决赛第一二三轮
--	14,15,16决赛第一二三轮
function SceneLeagueRoom:getCurRound()
	local round = CacheCenter:getLeagueInfo().stage
	WZLog("---------------cur stage-------------",round)
	local index
	local str = ""
	if round >= 2 and round <= 4 then
		index = round - 1
		str = string.format(LocalStrings.LEAGUE62,index)
	elseif round >= 5 and round <= 7 then
		local index = round - 4
		str = string.format(LocalStrings.LEAGUE63,index)
	elseif round >= 8 and round <= 10 then
		local index = round - 7
		str = string.format(LocalStrings.LEAGUE64,index)
	elseif round >= 11 and round <= 13 then
		local index = round - 10
		str = string.format(LocalStrings.LEAGUE65,index)
	elseif round >= 14 and round <= 16 then
		local index = round - 13
		str = string.format(LocalStrings.LEAGUE66,index)
	end
	return str
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin----------------------------------------
function SceneLeagueRoom:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtTimeTip_SceneLeagueRoom",WZUILabelTTF):setScale(0.85)
end
--------------------------------------语言适配End------------------------------------------