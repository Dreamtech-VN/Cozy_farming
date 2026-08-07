--WndDoubleSeven.lua
--@brief	WndDoubleSeven的UI模块
--@date		2020/07/30
--@author	hyx
--@note		七夕活动主界面


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDoubleSeven:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	ProtocolProcessorNewActivity:regAll()
	CacheCenter:registerUpatePlayerItemObserver(self)
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDoubleSeven:onExit(element)
	ProtocolProcessorNewActivity:unregAll()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
	if self.playerMyHead then
		self.playerMyObj:DeleteMe()
		self.playerMyHead = nil
	end
	if self.playerFriendHead then
		self.playerFriendHeadObj:DeleteMe()
		self.playerFriendHead = nil
	end
	self:unregister()
end
function WndDoubleSeven:register()
	GlobalGame:getGameEventDispathcer():Add(WndDoubleSevenEvent.WndDoubleSevenEvent_InitMessage,self._onDoubleSevenMainInit,self)
	GlobalGame:getGameEventDispathcer():Add(WndDoubleSevenEvent.WndDoubleSevenEvent_SendGiftResult,self._onSendGiftResult,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
end
function WndDoubleSeven:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndDoubleSevenEvent.WndDoubleSevenEvent_InitMessage,self._onDoubleSevenMainInit,self)
	GlobalGame:getGameEventDispathcer():Remove(WndDoubleSevenEvent.WndDoubleSevenEvent_SendGiftResult,self._onSendGiftResult,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
end

function WndDoubleSeven:showInterface()
	local wndDoubleSeven = WndDoubleSeven:createElement()
	if wndDoubleSeven ~= nil then
	    WindowManager:addWindow(wndDoubleSeven,WndDoubleSeven,nil,false)
	end
end

function WndDoubleSeven:onEnterTransitionDidFinish(element)
	self:setConfreeValue()
	self:initShow()
	ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiActivityInfo( )
end
local propGiveName = { LocalStrings.SPACE26, GDatatab_item["id_857"].name, GDatatab_item["id_858"].name }
function WndDoubleSeven:initShow()
	GetElement(self.m_root, "activity_label", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TIME_KEY..": ")
	self.activity_time = GetElement(self.m_root, "activity_time", WZUILabelTTF)
	GetElement(self.m_root, "label_friend", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT2)

	self.containdeMyHead = GetElement(self.m_root, "conMyHead", WZUIContainer)
	GetElement(self.containdeMyHead, "myConfressLabel", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT8)
	self.myConfreeValue = GetElement(self.containdeMyHead, "myConfressValue", WZUILabelTTF)
	
	local headurl = CacheCenter:getPlayerInfo().headScul
	local sex = CacheCenter:getPlayerInfo().sex
	self.playerMyHead, self.playerMyObj = WndCustomHead:createElement()
	self.playerMyObj:setHead(headurl, sex)
    self.containdeMyHead:addChild(self.playerMyHead) 


	self.containerFriendHead = GetElement(self.m_root, "conFriendHead", WZUIContainer)
	GetElement(self.containerFriendHead, "choosefriendLabel", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT1)
	GetElement(self.containerFriendHead, "friendConfressLabel", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT9)
	self.btnInviteFriend = GetElement(self.containerFriendHead,"btnInviteFriend",WZUIButton)
	self.friendConfreeValue = GetElement(self.containerFriendHead, "friendConfressValue", WZUILabelTTF)

    --告白任务
	local conTesk = GetElement(self.m_root, "conTesk", WZUIContainer)
	GetElement(conTesk,"teskLabel",WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT3)
	self.taskRedpoint = GetElement(conTesk,"taskRedpoint",WZUIImage)
	if GlobalGame.g_tRedPointList.task_redpoint then
		self.taskRedpoint:setVisible(GlobalGame.g_tRedPointList.task_redpoint)
	end

	--情侣榜
	local conRank = GetElement(self.m_root, "conRank", WZUIContainer)
	GetElement(conRank,"rankLabel",WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT4)
	--告白情书
	local conInvite = GetElement(self.m_root, "conInvite", WZUIContainer)
	GetElement(conInvite,"inviteLabel",WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT5)
	self.invateRedpoint = GetElement(conInvite,"invateRedpoint",WZUIImage)
	if GlobalGame.g_tRedPointList.invite_redpoint then
		self.invateRedpoint:setVisible(GlobalGame.g_tRedPointList.invite_redpoint)
	end

	local iten = {70,857,858}
	for i = 1, 3 do
		local confreeItem = GetElement(self.m_root,"confreeItem"..i,WZUIContainer)
		local item_icon = GetElement(confreeItem,"item_icon"..i,WZUIImage)
		local icon_str = GDatatab_item["id_"..iten[i]]
		if icon_str then
			if i == 1 then
				item_icon:setFile("ui/doubleSeven/hd_qx_hua.png")
			else
				item_icon:setFile(icon_str.icon)
			end
		end
		local btnConfree = GetElement(confreeItem,"btnConfree"..i,WZUIButton)
		GetElement(btnConfree,"countLabel",WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT6)
		if i ~= 1 then
			GetElement(confreeItem,"countLabel"..i,WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT7)
			if i == 2 then
				GetElement(confreeItem,"count2",WZUILabelTTF):setText(CacheCenter:getPlayerItemCountById(iten[i]))
			elseif i == 3 then
				GetElement(confreeItem,"count3",WZUILabelTTF):setText(CacheCenter:getPlayerItemCountById(iten[i]))
			end
		end
    end
end
function WndDoubleSeven:updatePlayerItemData()
	local confreeItem2 = GetElement(self.m_root,"confreeItem2",WZUIContainer)
	if confreeItem2 then
		GetElement(confreeItem2,"count2",WZUILabelTTF):setText(CacheCenter:getPlayerItemCountById(857))
	end
	local confreeItem3 = GetElement(self.m_root,"confreeItem3",WZUIContainer)
	if confreeItem3 then
		GetElement(confreeItem3,"count3",WZUILabelTTF):setText(CacheCenter:getPlayerItemCountById(858))
	end
end
--红点
function WndDoubleSeven:showInvateRedpoint(visible)
	if self.m_root == nil then return end  
	if self.invateRedpoint then
		self.invateRedpoint:setVisible(visible)
	end
end
function WndDoubleSeven:showTaskRedpoint(visible)
	if self.m_root == nil then return end  
	if self.taskRedpoint then
		self.taskRedpoint:setVisible(visible)
	end
end

--@brief 	红点
function WndDoubleSeven:showRedDot()
	-- body
	if self.m_root == nil then return end 

	self:showInvateRedpoint(GlobalGame.g_tRedPointList.invite_redpoint)
    self:showTaskRedpoint(GlobalGame.g_tRedPointList.task_redpoint)
end

--点击告白的时候
function WndDoubleSeven:onClickConFree(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = tonumber(element:getTag())
	local prop = WndDoubleSevenProp:createElement(tag, propGiveName[tag])
	WindowManager:addWindow(prop,WndDoubleSevenProp,nil,false)
end

--选择好友
function WndDoubleSeven:onClickInviteFriend()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	WndDoubleSevenInvit:showInterface(1)
end
--1:告白任务 2:情侣榜 3:告白情书
function WndDoubleSeven:onClickTeskType(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if tag == 1 then
		local task = WndDoubleSevenTask:createElement()
        WindowManager:addWindow(task,WndDoubleSevenTask,nil,false)
	elseif tag == 2 then
		local rank = WndDoubleSevenRank:createElement()
        WindowManager:addWindow(rank,WndDoubleSevenRank,nil,false)
    elseif tag == 3 then
    	WndDoubleSevenInvit:showInterface(2)
	end
end

function WndDoubleSeven:onClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
function WndDoubleSeven:setBaseMessage(playerId, headurl, myConfess, confessSum, itemId, itemNum)
	if playerId == 0 then
	else
		if self.btnInviteFriend then
			self.btnInviteFriend:setTouchEnable(false)
		end
		if not self.playerFriendHead then
			self.playerFriendHead, self.playerFriendHeadObj = WndCustomHead:createElement()
		    if self.containerFriendHead then
			    self.containerFriendHead:addChild(self.playerFriendHead)
			end
		end
		if self.playerFriendHead then
			local sex = CacheCenter:getPlayerInfo().sex
			if sex == 1 then
				sex = 0
			elseif sex == 0 then
				sex = 1
			end
			self.playerFriendHeadObj:setHead(headurl, sex)
		end
	end
	myConfess = myConfess or 0
	confessSum = confessSum or 0
	if self.myConfreeValue and self.friendConfreeValue then
		self.myConfreeValue:setText(myConfess)
		self.friendConfreeValue:setText(confessSum - myConfess)
	end
	--需要弹窗的时候
	if #itemId ~= 0 then
		local str = LocalStrings.DOUBLE_SEVEN_TEXT10
		for i=1,#itemId do
			local value = self:getConfreeOtherValue(itemId[i])
			local str_name = ""
			if itemId[i] == 70 then
				str_name = LocalStrings.SPACE26
			else
				str_name = GDatatab_item["id_"..itemId[i]].name
			end
			str = str .. "\n" .. string.format(LocalStrings.DOUBLE_SEVEN_TEXT11,str_name,itemNum[i],value*itemNum[i])
		end
	    MsgBoxManager:showConfirmBox(str, self, nil, nil, nil,true, nil, true)
	end
end
--@brief    規則說明
function WndDoubleSeven:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.DOUBLE_SEVEN_TEXT34)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndDoubleSeven:_onDoubleSevenMainInit(activityId, startTime, endTime, playerId, headScul, myConfess, confessSum, itemId, itemNum)
	if self.activity_time then
		self.activity_time:setText(SystemTime:getTimeConverLocal(startTime).."-"..SystemTime:getTimeConverLocal1(endTime))
	end
	self:setBindFriend(playerId)
	self:setMyConfreeValue( myConfess )
	self:setBaseMessage(playerId,headScul,myConfess,confessSum,itemId, itemNum)
end
--告白禮物
function WndDoubleSeven:_onSendGiftResult(myConfess, confessSum)
	MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT32)
	self:setMyConfreeValue( myConfess )
	if self.myConfreeValue then
		self.myConfreeValue:setText(myConfess)
	end
	if self.friendConfreeValue then
		self.friendConfreeValue:setText(confessSum - myConfess)
	end
end


function WndDoubleSeven:_adaptLanguage_vn(  )
	GetElement(self.m_root,"activity_time",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.27,0.155))
	GetElement(self.m_root,"btnRule",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.95,0.1))

	local containdeMyHead = GetElement(self.m_root, "conMyHead", WZUIContainer)
	GetElement(containdeMyHead,"myConfressValue",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.05,-0.108))

	local conFriendHead = GetElement(self.m_root, "conFriendHead", WZUIContainer)
	GetElement(conFriendHead,"friendConfressValue",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.02,-0.108))
	
	local confreeItem2 = GetElement(self.m_root,"confreeItem2",WZUIContainer)
	GetElement(confreeItem2,"count2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.5))
	local confreeItem3 = GetElement(self.m_root,"confreeItem3",WZUIContainer)
	GetElement(confreeItem3,"count3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.5))

	local teskLabel = GetElement(self.m_root,"teskLabel",WZUILabelTTF)
	teskLabel:setDimensions(GlobalMethod:CCSize(80))
	local rankLabel = GetElement(self.m_root,"rankLabel",WZUILabelTTF)
	rankLabel:setDimensions(GlobalMethod:CCSize(80))
	local inviteLabel = GetElement(self.m_root,"inviteLabel",WZUILabelTTF)
	inviteLabel:setDimensions(GlobalMethod:CCSize(80))
end
-------------------------------------私有方法模块End----------------------------------------
