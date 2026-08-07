--WndPractice.lua
--@brief	WndPractice的UI模块
--@date		2016/07/20
--@author	zhangming
--@note		修炼系统


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPractice:onEnter(element)
	WZLog("WndPractice:onEnter")
	self.m_root = element
	self.t_nConListPosY = {455,555,655,755,855,955,355}

    TeachGroup1:endTeachStep({43,3})
    TeachGroup1:startGroup({43,4,self.m_root})

end

--@brief	创建窗口动画
function WndPractice:onEnterTransitionDidFinish(element)
	WZLog("WndPractice:onEnterTransitionDidFinish")
	CacheCenter:setRedState("btnPractice_ExtendUp", false)
	WndBagMain:setXiuLIanRed(CacheCenter:getRedState("btnPractice_ExtendUp")) 
    ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(166)
    GlobalGame.g_tRedPointList.practice = nil 
    local stringCost = CacheCenter:getGameParam()["shuangxiu"]
    self.m_tOpenCost = {}
    local string = string.sub(stringCost,2,-2) 
	local id = SplitStringWithSeparator(string,",")[1]
	local num = SplitStringWithSeparator(string,",")[2]
	self.m_tOpenCost[1] = tonumber(id)
	self.m_tOpenCost[2] = tonumber(num)
	--惩罚时间
	local stringTime = CacheCenter:getGameParam()["chengfa"]
	self.m_tPublishTime = SplitStringWithSeparator(stringTime, ",", nil, true)
	WZLog("WndPractice:onEnterTransitionDidFinish00000", stringTime)

	self.t_nConListPosY = {455,555,655,755,855,955,355}
	ProtocolProcessorWndPractice:regAll()
	self:actionCallback()
    
	self:moveBg()
	self:showPlayer()

	local doublePracticeConsume = CacheCenter:getGameParam().doublePracticeConsume
	local doublePracticeVipLimit = CacheCenter:getGameParam().doublePracticeVipLimit
	if doublePracticeConsume == nil or doublePracticeConsume == "" then doublePracticeConsume = "[70,5]" end
	if doublePracticeVipLimit == nil or doublePracticeVipLimit == "" then doublePracticeVipLimit = [[5]] end

	local id, num = SplitItemString(doublePracticeConsume)
	WZLog("WndPractice:onEnterTransitionDidFinish",doublePracticeConsume, Serialize(id),Serialize(num))
	GetElement(self.m_root,"imgDoubleCost",WZUIImage):setFile(GDatatab_item["id_"..id[1]].icon)
	GetElement(self.m_root,"txtDoubleCost",WZUILabelTTF):setText(num[1])

	AdaptLanguage(self)
end

--@brief	窗口动画完成回调
function WndPractice:actionCallback(element)
    ProtocolProcessorWndPractice:send_UPGRADE_RequestUpgradeInfo()
 	--local data = {}
	-- data.itime = 1
	-- data.value = 100
	-- data.nextValue = 1000
	-- data.curLv = {0,0,0,0,0,0}
	-- data.curExp = {0,0,0,0,0,0}
	-- data.attrList = {1,2,3,4,5,6}
	-- data.addExp = {800,800,800,800,800,800}
	-- data.result = {7,7,7}
	-- self:setDate(data)
	self:setFyberTime()
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndPractice:setFyberTime()
    if NeedFyber(6) then
        local conFyber = self.m_root:getChildElement("conFyber_WndPractice")
        conFyber:setVisible(true)
        GetElement(self.m_root,"txtFyber_WndPractice",WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
    end 
end

function WndPractice:onFunctionClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    DoFyberReward(6)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPractice:onExit(element)
	WZLog("WndPractice:onExit")
	if self.m_root then 
		self.m_root:disableSchedule()
	end
	ProtocolProcessorWndPractice:unregAll()
	self:_unInit()
end

--brief     设置修炼界面的数据信息
function WndPractice:setDate(data, shuangXiuStatus, shuangXiuInfo, timeLimit)
	WZLog("WndPractice:setDate:",Serialize(data), shuangXiuStatus, shuangXiuInfo, timeLimit)
	self.t_data = data
	self.t_data.itime = self.t_data.itime + 1
	self:setDoubleData(shuangXiuStatus, shuangXiuInfo, timeLimit)
	self:_initUi()
	--显示双修伙伴形象
	self:showOtherPlayer()
end

--brief     设置修炼界面的数据信息
function WndPractice:setRollResult(data)
	WZLog("WndPractice:setRollResult:",Serialize(data))
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
	--开始设置滚动的初始值
	self:_initRoll(data)
	GetElement(self.m_root,"conAll_WndPractice",WZUIContainer):setTouchEnable(false)
	GetElement(self.m_root,"spine2_WndPractice",WZUISpine):play("animation", false)
end

--@brief    点击摇杆开始
function WndPractice:onClickStar(element)
	WZLog("WndPractice:onClickStar")
	TeachGroup1:endTeachStep({43,4})
	
	if self.t_data.nextValue > self.t_data.value then
		MsgBoxManager:showTipBox(LocalStrings.NEEDMOREPRACTICE)
        return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()

	local setDouble = GetElement(self.m_root,"setDouble",WZUICheckBox)
    if setDouble:getCheckIndex() == 1 then
		local doublePracticeConsume = CacheCenter:getGameParam().doublePracticeConsume
		local doublePracticeVipLimit = CacheCenter:getGameParam().doublePracticeVipLimit
		if doublePracticeConsume == nil or doublePracticeConsume == "" then doublePracticeConsume = "[70,5]" end
		if doublePracticeVipLimit == nil or doublePracticeVipLimit == "" then doublePracticeVipLimit = [[5]] end

		local id, num = SplitItemString(doublePracticeConsume)
		if not JudgeMoneyIsEnough(tonumber(id[1]), tonumber(num[1]), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onClickStarCall) then 
			return 
		end
		self:onClickStarCall()
	else
		self:onClickStarCall()
	end
end

function WndPractice:onClickStarCall() 
	--发协议
	local setDouble = GetElement(self.m_root,"setDouble",WZUICheckBox)
	ProtocolProcessorWndPractice:send_UPGRADE_RequestUpgradeRandom(1, setDouble:getCheckIndex())
end

--@brief    点击摇杆五次
function WndPractice:onClickStar5(element)
	WZLog("WndPractice:onClickStar5")
	if self.t_data.nextValue > self.t_data.value then
		MsgBoxManager:showTipBox(LocalStrings.NEEDMOREPRACTICE)
        return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()

	local setDouble = GetElement(self.m_root,"setDouble",WZUICheckBox)
    if setDouble:getCheckIndex() == 1 then
		local doublePracticeConsume = CacheCenter:getGameParam().doublePracticeConsume
		local doublePracticeVipLimit = CacheCenter:getGameParam().doublePracticeVipLimit
		if doublePracticeConsume == nil or doublePracticeConsume == "" then doublePracticeConsume = "[70,5]" end
		if doublePracticeVipLimit == nil or doublePracticeVipLimit == "" then doublePracticeVipLimit = [[5]] end

		local id, num = SplitItemString(doublePracticeConsume)
		if not JudgeMoneyIsEnough(tonumber(id[1]), tonumber(num[1])*self.t_data.maxNum, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onClickStar5Call) then 
			return 
		end
		self:onClickStar5Call()
	else
		self:onClickStar5Call()
	end
end

function WndPractice:onClickStar5Call() 
	--发协议
	local setDouble = GetElement(self.m_root,"setDouble",WZUICheckBox)
	ProtocolProcessorWndPractice:send_UPGRADE_RequestUpgradeRandom(self.t_data.maxNum, setDouble:getCheckIndex())
end

--@brief    点击关闭界面
function WndPractice:onCloseClick(element)
	WZLog("WndPractice:onCloseClick")
	self.m_root:removeFromParentAndCleanup(true)
end

--@brief    点击关闭界面
function WndPractice:onClickCloseTips(element)
	WZLog("WndPractice:onClickCloseTips")
	GetElement(self.m_root,"conButton_WndPractice",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTips1_WndPractice",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTips2_WndPractice",WZUIContainer):setVisible(false)
end

--@brief    显示修炼item_tip
function WndPractice:onClickTips1(element)
	local x, y =  GetElement(self.m_root,"conTips1_WndPractice",WZUIContainer):getPosition()
	WZLog("WndPractice:onClickTips1:",x,y)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.t_data or not self.t_data.curLv then
		return
	end
	local tag = element:getTag()
	local filePath = {"sm","gj","fy","tz","ll","hj"}
	local s1 = {LocalStrings.HEALTH, LocalStrings.ATTACK, LocalStrings.DEFENSE, LocalStrings.TIZHI, LocalStrings.POWER, LocalStrings.PRACTICE_ARMOR}
	GetElement(self.m_root,"imgTips1Icon_WndPractice",WZUIImage):setFile("ui/practice/xiulian_icon_"..filePath[tag].."_fore.png")
	GetElement(self.m_root,"txtTips1Lv_WndPractice",WZUILabelTTF):setText("Lv"..self.t_data.curLv[tag].."  "..s1[tag])
	GetElement(self.m_root,"txtTips1Desc2_WndPractice",WZUILabelTTF):setText(s1[tag]..":")
	GetElement(self.m_root,"txtTips1Desc3_WndPractice",WZUILabelTTF):setText(""..self.t_data.attrList[tag])
	local exp = self.t_data.curExp[tag]
	local maxExp = self:_getMaxExp(tag, self.t_data.curLv[tag])
	GetElement(self.m_root,"txtTips1Exp_WndPractice",WZUILabelTTF):setText(""..exp.."/"..tonumber(maxExp))
	local proElement = GetElement(self.m_root,"proTips1_WndPractice",WZUIProgress)
	proElement:setPercentage(exp/maxExp*100)
	GetElement(self.m_root,"conButton_WndPractice",WZUIContainer):setVisible(true)
	local conTips = GetElement(self.m_root,"conTips1_WndPractice",WZUIContainer)
	conTips:setVisible(true)
	local posX,posY = GetElement(self.m_root,"conItem"..tag.."_WndPractice",WZUIContainer):getPosition()
	if tag > 3 then
		conTips:setPosition(GlobalMethod:ccp(posX-210,posY-20))
	else
		conTips:setPosition(GlobalMethod:ccp(posX+210,posY-20))
	end
end

--@brief    修炼属性tip
function WndPractice:onClickTips2(element)
	WZLog("WndPractice:onClickTips2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.NEWPRACTICE2)
end

--@brief 	点击邀请双修按钮回调
function WndPractice:onClickInvite(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nDoubleState == 2 then 
		if self.m_nLeftTime > 0 then 
			local minutes = math.ceil((self.m_nLeftTime - math.floor(self.m_nLeftTime/3600) * 3600)/60)
			MsgBoxManager:showTipBox(string.format(LocalStrings.PRACTICE_TEXT14, math.floor(self.m_nLeftTime/3600), minutes))
			return 
		end
		WndFriendList:showInterface(15, self, self.inviteFriends)
	elseif self.m_nDoubleState == 0 then 
		local sContent = string.format(LocalStrings.PRACTICE_TEXT3, self.m_tOpenCost[2], GDatatab_item["id_" .. self.m_tOpenCost[1]].name)
		MsgBoxManager:showConfirmBox(sContent, self, self.sureToOpen)
	end
end

--@brief 	确定开启双修回调
function WndPractice:sureToOpen()
	-- body
	if self.m_nDoubleState ~= 0 then return end 

	if not JudgeMoneyIsEnough(self.m_tOpenCost[1], self.m_tOpenCost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then 
		return 
	end

	self:sureUseDiamondInstead()
end

--@brief 	确定用蓝钻代替粉钻
function WndPractice:sureUseDiamondInstead()
	-- body
	--发送开启协议
	ProtocolProcessorWndPractice:send_UPGRADE_ShuangXiuAction(0)
end

--@brief	邀请好友回调
--@param	playerID:好友ID
function WndPractice:inviteFriends(tFriend)
	WZLog("SceneRoom:inviteFriends ",tFriend, tFriend.id)
    if tFriend==nil or tFriend.id == nil then
       return
    end
    ProtocolProcessorWndFriends:send_FRIEND_AddShuangXiu(tFriend.id)
end

--@brief 	点击退出按钮回调
function WndPractice:onCLickCancelDouble(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local sContent = string.format(LocalStrings.PRACTICE_TEXT5, math.floor(self.m_tPublishTime[1]/60))
	MsgBoxManager:showConfirmBox(sContent, self, self.sureToExit)
end

--@brief 	确定退出双修
function WndPractice:sureToExit()
	-- body
	--发送退出协议
	if self.m_nDoubleState ~= 1 then return end 
	ProtocolProcessorWndPractice:send_UPGRADE_ShuangXiuAction(1)
end

--@brief 	点击角色回调
function WndPractice:onClickRole(element)
	-- body
	WZLog("WndPractice:onClickRole")
	if self.m_tOtherPlayerInfo == nil or self.m_tOtherPlayerInfo == {} then return end 

	WndCheckOther:show(self.m_tOtherPlayerInfo.id)
end
-------------------------------------公有方法模块End----------------------------------------

--@breif 跳转至充值界面
function WndPractice:_gotoPay()
	WndVip:showWndUI(0)
end

--@breif 指针开始结束
function WndPractice:_anctionOver(element)
	WZLog("WndPractice:_anctionOver:", element)
	local spine = WZUISpine:luaTo(element)
	if spine:isCurrentAnimationDone() then
		element:disableSchedule()
		spine:play("a_2", true)
	end	
end

--@brief 设置容器的位置
function WndPractice:_setRollPosition(element,moveY)
	local posY = element:getPositionY()
	posY = posY + moveY
	if posY > 990 then
		posY = posY - 990 + 290
	end
	element:setPositionY(posY)
end

--@breif 初始化滚动相关数值
function WndPractice:_initRoll(data)
	WZLog("WndPractice:_initRoll", Serialize(data))
	self.t_data.addExp = CopyTable(data.addExp)
	self.t_data.addExp2 = {}
	self.t_data.curAddNum = 0
	self.t_data.needAddNum = 0
	for i =1, #data.addExp do
		table.insert(self.t_data.addExp2, data.addExp[i])
		if data.addExp[i] > 0 then
			self.t_data.needAddNum = self.t_data.needAddNum + 1
		end
	end
	self.t_data.attrList = data.attrList
	self.t_data.value = data.value
	self.t_data.nextValue = data.nextValue
	self.t_data.itime = data.itime
	self.t_nRollResult = data.result
	WZLog("WndPractice:_initRoll1",#self.t_nRollResult,self.t_nRollResult[1],self.t_nRollResult[2],self.t_nRollResult[3])
	--按钮文字
	GetElement(self.m_root,"btnText2",WZUILabelTTF):setText(string.format(LocalStrings.NEWPRACTICE1, tostring(data.maxNum)))
	if data.maxNum == 0 then
		GetElement(self.m_root,"btnText2",WZUILabelTTF):setText(string.format(LocalStrings.NEWPRACTICE1, "1"))
	end
	--今日第几次修炼
	local needValue = tonumber(self.t_data.nextValue) == 0 and LocalStrings.PETFREE2 or ""..self.t_data.nextValue 
	WZLog("WndPractice:_initRoll0:",Serialize(self.t_data),needValue)
	WZLog("WndPractice:_initRoll1:",self.t_data.itime,needValue,self.t_data.value)
	local s2 = string.format(LocalStrings.PRACTICE_USE2,self.t_data.itime,needValue)
	GetElement(self.m_root,"freeText2_WndPractice",WZUIFreeTextBox):setShowText(s2)
	GetElement(self.m_root,"txtLeft",WZUILabelTTF):setText(self.t_data.value)
	--修炼红点
	WndBagMain:setXiuLIanRed(self.t_data.value>=1000) 
	--快速播放跳过滚动
	if G_Practice_Quick == 1 then
		self:_passRoll()
	else
		self.n_speed = 140
		self.t_bActionOver = {0, 0 ,0}
		self.m_root:enableSchedule("_starRollSchedule",0.001)
	end
end

--@brief 开始滚动
function WndPractice:_starRollSchedule()
	WZLog("WndPractice:_starRollSchedule")
	self.n_speed = math.max(self.n_speed - 3,12) --减速到某个值将不再减少
	for i = 1,3 do
		local element = GetElement(self.m_root,"conList"..i.."_WndPractice")
		local posY = element:getPositionY()
		local endPosY = self.t_nConListPosY[self.t_nRollResult[i]]
		if self.n_speed <=12 and posY+self.n_speed >= endPosY and posY <= endPosY  then
			element:setPositionY(endPosY)
			self.t_bActionOver[i] = 1
		else
			self:_setRollPosition(element, self.n_speed)
		end	
	end
	if self.t_bActionOver[1] == 1 and self.t_bActionOver[2] == 1 and self.t_bActionOver[3] == 1 then
		self.m_root:disableSchedule()
		GetElement(self.m_root,"spine1_WndPractice",WZUISpine):play("a_3", false)
		--开始初始化移动特效
		self:_initMove()
	end
end

--@breif 跳过动画直接滚动
function WndPractice:_passRoll()
	WZLog("WndPractice:_passRoll")
	for i=1,3 do
		local element = GetElement(self.m_root,"conList"..i.."_WndPractice")
		local endPosY = self.t_nConListPosY[self.t_nRollResult[i]]
		element:setPositionY(endPosY)
	end
	self:_initMove()
end

--@breif 初始化特效动相关数值
function WndPractice:_initMove()
	WZLog("WndPractice:_initMove")
	--一些特效的播放位置
	local filePath = {"sm","gj","fy","tz","ll","hj","all"}
	local moveTime = 0.6
	local actionOver = true
	local posX = {430,430,430}
	local expNum = 0
	--先得出经验的数量
	local con = GetElement(self.m_root,"conAll2_WndPractice",WZUIContainer)
	for i=1, 3 do
		local result = self.t_nRollResult[i]
		if result == 7 then
			WZLog("WndPractice:_initMove_result=7")
			expNum = expNum + 1
			if expNum == 3 then
				--boom
				--self:_createSpine(con, posX[2], 250, "super")
				--self:_createSpine(con, posX[2], 250, "boom")
				local spine = WZUISpine:create()
				spine:setFileAtlas("ui/ui_xiulian_super.atlas")
				spine:setFileJson("ui/ui_xiulian_super.json")
				spine:setVisible(true)
				spine:play("ui_xiulian_super", false)
				spine:setUseOriginSize(true)
				spine:enableSchedule("_upgradeOver")
				con:addChild(spine)
				spine:setPosition(GlobalMethod:ccp(430,250))

				for i=1,6 do
					local con = GetElement(self.m_root,"conAll2_WndPractice",WZUIContainer)
					local conElement = GetElement(self.m_root,"conItem"..i.."_WndPractice",WZUIContainer)
					local posX, posY = conElement:getPosition()
					self:_createSpine(con, posX, posY, "exp_1")
				end
				DelayCallFunction(self._addExp, self, 0.6)
				return
			end
		end
	end

	self:expAni()
end

--brief 经验移动粒子动画
function WndPractice:expAni() 
	WZLog("WndPractice:expAni",Serialize(self.t_nRollResult))
	self.m_nCurAni = 1
	local p = GetElement(self.m_root,"conAll2_WndPractice",WZUIContainer)
	p:enableSchedule("expAni1",0.4)
end

function WndPractice:expAni1() 
	local p = GetElement(self.m_root,"conAll2_WndPractice",WZUIContainer)
	if self.m_nCurAni > #self.t_nRollResult then 
        p:disableSchedule()
		WZLog("动画结束")
		ProtocolProcessorWndPractice:send_UPGRADE_RequestUpgradeInfo()
		GetElement(self.m_root,"conAll_WndPractice",WZUIContainer):setTouchEnable(true)
	else
		self:expAni2()
		self.m_nCurAni = self.m_nCurAni + 3
	end
end

function WndPractice:expAni2() 
	local scale = 1
	local moveTime = 0.6
	local time = (self.m_nCurAni - 1)/3 + 1
	local con = GetElement(self.m_root,"conAll2_WndPractice",WZUIContainer)
	for i = self.m_nCurAni, (self.m_nCurAni + 2) do
		local result = self.t_nRollResult[i]
		if i == self.m_nCurAni and (result == self.t_nRollResult[self.m_nCurAni+1] or result == self.t_nRollResult[self.m_nCurAni+2]) then
			scale = 2.5
		elseif i == (self.m_nCurAni+1) and (result == self.t_nRollResult[self.m_nCurAni+2]) then
			scale = 4
		else
			if result == 7 then
				WZLog("WndPractice:expAni2_result=7")
				--播放爆炸特效
				self:_createSpine(con, 430, 250, "boom")
			else
				--生成动画文件
				local img = GetElement(self.m_root,"lizi"..result..time,WZUIParticle)
				img:stopAllActions()
				img:setScale(scale)
				img:setVisible(true)
				img:setPosition(GlobalMethod:ccp(430,250))
				img:runAction(CCScaleTo:create(moveTime,0.4))
				local conElement = GetElement(self.m_root,"conItem"..result.."_WndPractice",WZUIContainer)
				local pos_X, pos_Y = conElement:getPosition()
				WZLog("ssss:",pos_X,pos_Y,result,i)
				local actionArray = CCArray:create()
  				actionArray:addObject(CCMoveTo:create(moveTime,GlobalMethod:ccp(pos_X, pos_Y)))
				actionArray:addObject(CCCallFuncN:create(function() self:_moveOver(img) end))
  				img:runAction(CCSequence:create(actionArray))
			end
		end--
	end
end

--brief 移动完后的处理
function WndPractice:_moveOver(element)
	WZLog("WndPractice:_moveOver")
	element:setVisible(false)
	if true then
		local effect = {id={},num={},index={}}
		for i = 1, #self.t_nRollResult do
			local bAdd = true
			for j = 1, #effect.id do
				if self.t_nRollResult[i] == effect.id[j] then
					effect.num[j] = effect.num[j] + 1
					bAdd = false
				end
			end
			if bAdd and self.t_nRollResult[i] ~= 7 then
				table.insert(effect.id,self.t_nRollResult[i])
				table.insert(effect.num,1)
				table.insert(effect.index,i)
			end
		end
		WZLog("_moveOver:",#effect.id, #effect.num)
		for i =1, #effect.num do
			WZLog("_moveOver:",effect.num[i])
			if effect.num[i] >= 1 then
				local con = GetElement(self.m_root,"conAll2_WndPractice",WZUIContainer)
				local conElement = GetElement(self.m_root,"conItem"..effect.id[i].."_WndPractice",WZUIContainer)
				local posX, posY = conElement:getPosition()
				if effect.num[i] == 1 then
					self:_createSpine(con, posX, posY, "exp_1")
				else
					self:_createSpine(con, posX, posY, "exp_2")
				end
			end
		end
		--提前可以操作控制
		--GetElement(self.m_root,"conAll_WndPractice",WZUIContainer):setTouchEnable(true)
		--动作暂时到这里
		--粒子设置回原位
		element:setRelativePosition(ccp(1.5,1.5))
		self:_addExp()
	end
end

--@brief 经验动画的添加
function WndPractice:_addExp()
	WZLog("WndPractice:_addExp")
	for i =1 ,6 do
		if self.t_data.addExp ~= nil and self.t_data.addExp[i] ~= nil and self.t_data.addExp[i] > 0 then
			local proElement = GetElement(self.m_root,"pro"..i.."_WndPractice",WZUIProgress)
			proElement:enableSchedule("_addExpSchedule",0.01)
		end
	end
end

--@brief 经验动画的定时器
function WndPractice:_addExpSchedule(element)
	local tag = element:getTag()
	local needAddExp = self.t_data.addExp[tag]
	WZLog("WndPractice:_addExpSchedule:",tag,needAddExp)
	if needAddExp == 0 then
		GetElement(self.m_root,"txt"..tag.."_WndPractice",WZUILabelTTF):setVisible(false)
        element:disableSchedule()
		self.t_data.curAddNum = self.t_data.curAddNum + 1
		if self.t_data.curAddNum >= self.t_data.needAddNum then
			self:_addExpOver()
		end
        return
    end
	local speedRatio = G_Practice_Quick == 0 and 1 or 2 
	local exp = math.max(math.floor(self.t_data.addExp2[tag]/20*speedRatio),1)
    local maxExp = self:_getMaxExp(tag,self.t_data.curLv[tag])
    local addExp = (needAddExp > exp ) and exp or needAddExp
    self.t_data.addExp[tag] = needAddExp - addExp
    self.t_data.curExp[tag] = self.t_data.curExp[tag] + addExp
    if self.t_data.curExp[tag] >= maxExp then
    		if self.t_data.curLv[tag] >= 80 or self.t_data.curLv[tag] >= CacheCenter:getPlayerInfo().level then
    			return
    		end
        	self.t_data.curExp[tag] = self.t_data.curExp[tag] - maxExp
            self.t_data.curLv[tag] = self.t_data.curLv[tag] + 1
            maxExp = self:_getMaxExp(tag,self.t_data.curLv[tag])
            self:_showUpgrade(tag,self.t_data.curLv[tag])
    end
    self:_setExp(tag,self.t_data.curExp[tag],maxExp)
end

--@brief 经验动画的添加
function WndPractice:_setExp(index,exp,maxExp)
	local txtElement = GetElement(self.m_root,"txt"..index.."_WndPractice",WZUILabelTTF)
	local proElement = GetElement(self.m_root,"pro"..index.."_WndPractice",WZUIProgress)
	proElement:setPercentage(exp/maxExp*100)
	txtElement:setVisible(true)
	txtElement:setText(string.format("%.1f%%",""..(exp/maxExp*100)))
end

--@brief 经验动画的添加
function WndPractice:_addExpOver()
	local fight = math.floor((9.6*(self.t_data.attrList[5]+self.t_data.attrList[6]+self.t_data.attrList[4])+1*(self.t_data.attrList[1]+4.8*self.t_data.attrList[2]+6*self.t_data.attrList[3]))*0.75)
	upPlayerFightingAni(fight - self.n_fighting)
	self.n_fighting = fight
	GetElement(self.m_root,"font_WndPractice",WZUILabelAtlasFont):setText(math.floor(fight))
end

--@brief 升级特效的修改
function WndPractice:_showUpgrade(index,lv)
	GetElement(self.m_root,"txtLv"..index.."_WndPractice",WZUILabelTTF):setText("Lv"..lv)
	local element = GetElement(self.m_root,"conItem"..index.."_WndPractice",WZUIContainer)
	self:_createSpine(element, nil, nil, "exp_2")
end

--@brief 升级特效的播放完毕
function WndPractice:_upgradeOver(element)
	local spine = WZUISpine:luaTo(element)
	if spine:isCurrentAnimationDone() then
		element:disableSchedule()
		element:removeFromParentAndCleanup(true)
	end
	GetElement(self.m_root,"conAll_WndPractice",WZUIContainer):setTouchEnable(true)
end

--@brief 获取得到当前等级的经验
function WndPractice:_getMaxExp(index,lv)
	for k, v in pairs(GDatatab_upgrade_attr) do
		if v.type == index and v.level == lv then
			return v.lv_exp
		end
	end
	return 1
end

--创建一个粒子特效
function WndPractice:_createSpine(element, posX, posY, action)
	if posY == nil or posY < 100 then return end
	local spine = WZUISpine:create()
	spine:setFileAtlas("ui/ui_xiulian.atlas")
	spine:setFileJson("ui/ui_xiulian.json")
	spine:setVisible(true)
	spine:play(action, false)
	spine:setUseOriginSize(true)
	spine:enableSchedule("_upgradeOver")
	element:addChild(spine)
	if posX ~= nil and posY ~= nil then
		spine:setPosition(GlobalMethod:ccp(posX,posY))
	end
end

--brief  设置修炼界面的显示
function WndPractice:_initUi()
	--今日获得修炼值
	if self.m_nDoubleState == 1 then 
		local s1 = string.format(LocalStrings.PRACTICE_TEXT4,self.t_data.vigor,self.t_data.todayValue)
		GetElement(self.m_root,"freeText_WndPractice",WZUIFreeTextBox):setShowText(s1)
	else
		local s1 = string.format(LocalStrings.PRACTICE_USE,self.t_data.vigor,self.t_data.todayValue)
		GetElement(self.m_root,"freeText_WndPractice",WZUIFreeTextBox):setShowText(s1)
	end
	--今日第几次修炼
	local needValue = tonumber(self.t_data.nextValue) == 0 and LocalStrings.PETFREE2 or ""..self.t_data.nextValue
	local s2 = string.format(LocalStrings.PRACTICE_USE2,self.t_data.itime,needValue)
	GetElement(self.m_root,"freeText2_WndPractice",WZUIFreeTextBox):setShowText(s2)
	GetElement(self.m_root,"txtLeft",WZUILabelTTF):setText(self.t_data.value)
	--修炼战斗力加成
	local fight = (9.6*(self.t_data.attrList[5]+self.t_data.attrList[6]+self.t_data.attrList[4])+1*(self.t_data.attrList[1]+4.8*self.t_data.attrList[2]+6*self.t_data.attrList[3]))*0.75
	self.n_fighting = math.floor(fight)
	GetElement(self.m_root,"font_WndPractice",WZUILabelAtlasFont):setText(math.floor(fight))
	--各属性当前成长值
	for i = 1, 6 do
		GetElement(self.m_root,"txtLv"..i.."_WndPractice",WZUILabelTTF):setText("Lv"..self.t_data.curLv[i])
		local maxExp = WndPractice:_getMaxExp(i,self.t_data.curLv[i])
		GetElement(self.m_root,"pro"..i.."_WndPractice",WZUIProgress):setPercentage(self.t_data.curExp[i]/maxExp*100)
		GetElement(self.m_root,"value"..i,WZUILabelTTF):setText("+"..self.t_data.attrList[i])
	end
	--按钮文字
	GetElement(self.m_root,"btnText1",WZUILabelTTF):setText(string.format(LocalStrings.NEWPRACTICE1, "1"))
	GetElement(self.m_root,"btnText2",WZUILabelTTF):setText(string.format(LocalStrings.NEWPRACTICE1, tostring(self.t_data.maxNum)))
	if self.t_data.maxNum == 0 then
		GetElement(self.m_root,"btnText2",WZUILabelTTF):setText(string.format(LocalStrings.NEWPRACTICE1, "1"))
	end
end
-------------------------------------私有方法模块Begin--------------------------------------
--@brief	显示双修人物形象
function WndPractice:showOtherPlayer()
	if self.m_root == nil then return end
	if self.conOtherPlayer ~= nil then 
		self.conOtherPlayer:getAnimNode():removeFromParentAndCleanup(true) 
		self.conOtherPlayer = nil
	end
	WZLog("WndPractice:showOtherPlayer", self.m_nDoubleState)
	if self.m_nDoubleState == 1 then 
		GetElement(self.m_root, "btnInvite_WndPractice", WZUIButton):setVisible(false)
		GetElement(self.m_root, "btnCancelDouble_WndPractice", WZUIButton):setVisible(true)
		GetElement(self.m_root, "btnRole_WndPractice", WZUIButton):setVisible(true)

		local tEquip = {}
		table.insert(tEquip, self.m_tOtherPlayerInfo.head)
		table.insert(tEquip, self.m_tOtherPlayerInfo.face)
		table.insert(tEquip, self.m_tOtherPlayerInfo.body)
		table.insert(tEquip, self.m_tOtherPlayerInfo.wing)
		local headColor = self.m_tOtherPlayerInfo.headcolor
		local bodyColor = self.m_tOtherPlayerInfo.bodycolor

		local sex = self.m_tOtherPlayerInfo.sex
	    local conP = WZUIContainer:luaTo(self.m_root:getChildElement("conMain"))
	    if not self.conOtherPlayer then
			local conPlayer
        	conPlayer = CreatePlayerFigure(sex, tEquip, "run", nil, nil ,nil, nil, nil ,nil, nil, headColor ,bodyColor)
			conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.32,0.2))
        	conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))

	        self.conOtherPlayer = conPlayer
			self.conOtherPlayer:play("run",true)
	        conP:addChild(conPlayer:getAnimNode(),5)

	        self:_createPlayerName(conPlayer:getAnimNode(), self.m_tOtherPlayerInfo.name)
	    end
	else
		GetElement(self.m_root, "btnInvite_WndPractice", WZUIButton):setVisible(true)
		GetElement(self.m_root, "btnRole_WndPractice", WZUIButton):setVisible(false)
		GetElement(self.m_root, "btnCancelDouble_WndPractice", WZUIButton):setVisible(false)
	end
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------
function WndPractice:_adaptLanguage_en(  )
	local value4 = GetElement(self.m_root,"value4",WZUILabelTTF)
	value4:setRelativePosition(GlobalMethod:ccp(0.8,-2))

	local value5 = GetElement(self.m_root,"value5",WZUILabelTTF)
	value5:setRelativePosition(GlobalMethod:ccp(0.83,-2))

	local value6 = GetElement(self.m_root,"value6",WZUILabelTTF)
	value6:setRelativePosition(GlobalMethod:ccp(0.66,-2))

	local btnText1 = GetElement(self.m_root,"btnText1",WZUILabelTTF)
	btnText1:setScale(0.7)
	btnText1:setDimensions(GlobalMethod:CCSize(150))
	local btnText2 = GetElement(self.m_root,"btnText2",WZUILabelTTF)
	btnText2:setScale(0.7)
	btnText2:setDimensions(GlobalMethod:CCSize(150))

	GetElement(self.m_root,"txtTips1Desc3_WndPractice",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.5))
	
	GetElement(self.m_root,"txtRemaining_WndPractice",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.8,0.5))

	GetElement(self.m_root,"txtDoubleCost",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtDoubleCost2",WZUILabelTTF):setScale(0.7)	
	local freeText2 = GetElement(self.m_root,"freeText2_WndPractice",WZUIFreeTextBox)
	freeText2:setScale(0.7)
	freeText2:setRelativePosition(GlobalMethod:ccp(0.61,0.2))
	
	
end

function WndPractice:_adaptLanguage_pt(  )
	local value4 = GetElement(self.m_root,"value4",WZUILabelTTF)
	value4:setRelativePosition(GlobalMethod:ccp(0.7,-2))

	local value5 = GetElement(self.m_root,"value5",WZUILabelTTF)
	value5:setRelativePosition(GlobalMethod:ccp(0.66,-2))

	local value6 = GetElement(self.m_root,"value6",WZUILabelTTF)
	value6:setRelativePosition(GlobalMethod:ccp(0.8,-2))

	GetElement(self.m_root,"btnText1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"btnText2",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"txtTips1Desc3_WndPractice",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.37,0.5))

	GetElement(self.m_root,"txtItemName4_WndPractice",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtItemName6_WndPractice",WZUILabelTTF):setScale(0.7)
end

function WndPractice:_adaptLanguage_th(  )
	local value6 = GetElement(self.m_root,"value6",WZUILabelTTF)
	value6:setRelativePosition(GlobalMethod:ccp(0.74,-2))
end

function WndPractice:_adaptLanguage_vn(  )
	local value2 = GetElement(self.m_root,"value2",WZUILabelTTF)
	value2:setRelativePosition(GlobalMethod:ccp(0.66,-2))

	local value4 = GetElement(self.m_root,"value4",WZUILabelTTF)
	value4:setRelativePosition(GlobalMethod:ccp(0.63,-2))

	local value5 = GetElement(self.m_root,"value5",WZUILabelTTF)
	value5:setRelativePosition(GlobalMethod:ccp(0.69,-2))

	local value6 = GetElement(self.m_root,"value6",WZUILabelTTF)
	value6:setRelativePosition(GlobalMethod:ccp(0.66,-2))

	GetElement(self.m_root,"txtDoubleCost",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtDoubleCost2",WZUILabelTTF):setScale(0.8)
end

function WndPractice:_adaptLanguage_tr(  )
	local value4 = GetElement(self.m_root,"value4",WZUILabelTTF)
	value4:setRelativePosition(GlobalMethod:ccp(0.83,-2))

	local value5 = GetElement(self.m_root,"value5",WZUILabelTTF)
	value5:setRelativePosition(GlobalMethod:ccp(0.66,-2))

	GetElement(self.m_root,"btnText1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"btnText2",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"txtTips1Desc3_WndPractice",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.5))

	GetElement(self.m_root,"txtItemName4_WndPractice",WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"txtItemName5_WndPractice",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"txtDoubleCost",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtDoubleCost2",WZUILabelTTF):setScale(0.7)	
	GetElement(self.m_root,"freeText2_WndPractice",WZUIFreeTextBox):setScale(0.7)
end

function WndPractice:_adaptLanguage_es(  )
	local value4 = GetElement(self.m_root,"value4",WZUILabelTTF)
	value4:setRelativePosition(GlobalMethod:ccp(0.7,-2))

	local value5 = GetElement(self.m_root,"value5",WZUILabelTTF)
	value5:setRelativePosition(GlobalMethod:ccp(0.66,-2))

	local value2 = GetElement(self.m_root,"value2",WZUILabelTTF)
	value2:setRelativePosition(GlobalMethod:ccp(0.65,-2))

	local value3 = GetElement(self.m_root,"value3",WZUILabelTTF)
	value3:setRelativePosition(GlobalMethod:ccp(0.65,-2))

	GetElement(self.m_root,"btnText1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"btnText2",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"txtTips1Desc3_WndPractice",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.37,0.5))

	GetElement(self.m_root,"txtItemName4_WndPractice",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtItemName5_WndPractice",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtItemName2_WndPractice",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtItemName3_WndPractice",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"freeText2_WndPractice",WZUIFreeTextBox):setScale(0.9)
end
-------------------------------------语言适配End----------------------------------------
