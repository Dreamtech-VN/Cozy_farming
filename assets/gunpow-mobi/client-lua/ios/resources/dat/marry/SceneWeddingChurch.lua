--SceneWeddingChurch.lua
--@brief	SceneWeddingChurch的UI模块
--@date		2014/03/27
--@author	林庆凯
--@modify   qixiang_xie
--@note		结婚礼堂场景

-------------------------------------公有方法模块Begin--------------------------------------

--礼炮播放的随机位置
local salutePs = {{0.230729,0.889865},{0.486205,0.619292},{0.736896,0.846371},{0.602471,0.71346},{0.753787,0.39232},
                  {0.207926,0.378596},{0.591752,0.110117},{0.451009,0.866956},{0.229314,0.637555},{0.483102,0.334784}}

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneWeddingChurch:onEnter(element)
	self.m_root = element
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	SoundManager:playBgMusic(SoundDefine.E_MUSIC_WED,true)
	--彩色喇叭
	ChangeChatChannel(Chat_Channel_WeddingScene)
	ProtocolProcessorSceneWeddingChurch:regAll()
	
	local conBottom= GetElement(self.m_root,"conBottom_SceneWeddingChurch",WZUIContainer)
	self.m_oConBottom = conBottom
	self.m_oConBottom:enableSchedule("scheduleSortGuest")
	local playerGoldElement, tPlayerGold = CellGold:createElement()
    tPlayerGold:showCoin({1,70,2,6},{1,1,1,1})
    tPlayerGold:setCellType(0)
	conBottom:addChild(playerGoldElement)
	WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)

	GetElement(self.m_root,"imgMiddle1_SceneWeddingChurch",WZUIImage):setFile("ui/marrige/marry_pic_jhcj2.png")
	GetElement(self.m_root,"imgMiddle2_SceneWeddingChurch",WZUIImage):setFile("ui/marrige/marry_pic_jhcj.png")
	GetElement(self.m_root,"imgMiddle3_SceneWeddingChurch",WZUIImage):setFile("ui/marrige/marry_pic_jhcj.png")
	GetElement(self.m_root,"imgMiddle4_SceneWeddingChurch",WZUIImage):setFile("ui/marrige/marry_pic_jhcj2.png")
    

    local salutePrice  = CacheCenter:getGameParam().wedSalutePrice
	local id, price=  SplitItemString(salutePrice)
    GetElement(self.m_root,"txtSaluted1_SceneWeddingChurch",WZUILabelTTF):setText(price[1])
    GetElement(self.m_root,"txtSaluted2_SceneWeddingChurch",WZUILabelTTF):setText(price[2])
    GetElement(self.m_root,"txtSaluted3_SceneWeddingChurch",WZUILabelTTF):setText(price[3])
    local imgSalutedIcon1 = GetElement(self.m_root,"imgSalutedIcon1_SceneWeddingChurch", WZUIImage)
    local imgSalutedIcon2 = GetElement(self.m_root,"imgSalutedIcon2_SceneWeddingChurch", WZUIImage)
    local imgSalutedIcon3 = GetElement(self.m_root,"imgSalutedIcon3_SceneWeddingChurch", WZUIImage)
    imgSalutedIcon1:setFile(GDatatab_item["id_" .. id[1]].icon)
    imgSalutedIcon1:setScale(0.45)
    imgSalutedIcon2:setFile(GDatatab_item["id_" .. id[2]].icon)
    imgSalutedIcon2:setScale(0.45)
    imgSalutedIcon3:setFile(GDatatab_item["id_" .. id[3]].icon)
    imgSalutedIcon3:setScale(0.45)

    
    id , price=  SplitItemString(CacheCenter:getGameParam().wedRedPrice)
    GetElement(self.m_root,"txtRedPacket1_SceneWeddingChurch",WZUILabelTTF):setText(price[1])
    GetElement(self.m_root,"txtRedPacket2_SceneWeddingChurch",WZUILabelTTF):setText(price[2])
    GetElement(self.m_root,"txtRedPacket3_SceneWeddingChurch",WZUILabelTTF):setText(price[3])
    local imgRedPIcon1 = GetElement(self.m_root,"imgRedPIcon1_SceneWeddingChurch", WZUIImage)
    local imgRedPIcon2 = GetElement(self.m_root,"imgRedPIcon2_SceneWeddingChurch", WZUIImage)
    local imgRedPIcon3 = GetElement(self.m_root,"imgRedPIcon3_SceneWeddingChurch", WZUIImage)
    imgRedPIcon1:setFile(GDatatab_item["id_" .. id[1]].icon)
    imgRedPIcon1:setScale(0.45)
    imgRedPIcon2:setFile(GDatatab_item["id_" .. id[2]].icon)
    imgRedPIcon2:setScale(0.45)
    imgRedPIcon3:setFile(GDatatab_item["id_" .. id[3]].icon)
    imgRedPIcon3:setScale(0.45)
    
    id, price=  SplitItemString(CacheCenter:getGameParam().wedCandyPrice)
    GetElement(self.m_root,"txtCandies1_SceneWeddingChurch",WZUILabelTTF):setText(price[1])
    GetElement(self.m_root,"txtCandies2_SceneWeddingChurch",WZUILabelTTF):setText(price[2])
    GetElement(self.m_root,"txtCandies3_SceneWeddingChurch",WZUILabelTTF):setText(price[3])
    local imgCandiesIcon1 = GetElement(self.m_root,"imgCandiesIcon1_SceneWeddingChurch", WZUIImage)
    local imgCandiesIcon2 = GetElement(self.m_root,"imgCandiesIcon2_SceneWeddingChurch", WZUIImage)
    local imgCandiesIcon3 = GetElement(self.m_root,"imgCandiesIcon3_SceneWeddingChurch", WZUIImage)
    imgCandiesIcon1:setFile(GDatatab_item["id_" .. id[1]].icon)
    imgCandiesIcon1:setScale(0.45)
    imgCandiesIcon2:setFile(GDatatab_item["id_" .. id[2]].icon)
    imgCandiesIcon2:setScale(0.45)
    imgCandiesIcon3:setFile(GDatatab_item["id_" .. id[3]].icon)
    imgCandiesIcon3:setScale(0.45)

    local conMoveMap =  GetElement(self.m_root,"conMoveMap_SceneWeddingChurch",WZUIContainer)
    conMoveMap:enableSchedule("scheudleShowPacketOrCandies",1)
	--更新函数
	self:_update()
	--启动神父说话内容
	self:_startPriestSayWordContent()
	--设置人物走动
	self:_setPlayerAni()
	--取消圆圈的转动效果
	self:closeLoading()
	--获取CD时间

	--足迹
	local conGuest = GetElement(self.m_root, "conGuestList_SceneWeddingChurch", WZUIContainer)
	FootEffectManager:getInstance():setFootLayer(conGuest)

	ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetCDTime(self.m_nWeddingNo)
	WndChat:addChatWindowToCurScene()
	AdaptLanguage(self)
end

function SceneWeddingChurch:onEnterTransitionDidFinish()
	WZLog("SceneWeddingChurch:onEnterTransitionDidFinish")
    local armLighting = GetElement(self.m_root,"armLighting_SceneWeddingChurch",WZArmature)
    armLighting:setArmatureFile("ui/skills_jhcj_jgd_01.xml")
    armLighting:setVisible(true)
end 

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneWeddingChurch:onExit(element)
	FootEffectManager:getInstance():destroy()
	--反注册协议组所有协议
	if self.m_oConBottom then
		self.m_oConBottom:disableSchedule()
	end
	self.m_root:disableSchedule()
	if self.m_conMiddle then
	   self.m_conMiddle:disableSchedule()
	end

    ProtocolProcessorSceneWeddingChurch:unregAll()
	self:_unInit()
	
	IPDConnector.g_nNetConnectFlag = NET_FLAG_2
end


--@brief	聊天按钮点击时回调方法
function SceneWeddingChurch:onChatBtn(element)
	WZLog("SceneWeddingChurch:onChatBtn(element)")
	self:hideLeft()
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndChat:showChatWindowForFightingByOrder()
end

function SceneWeddingChurch:scheduleCalculate(element)
	WZLog("SceneWeddingChurch:scheduleCalculate")
	element:disableSchedule()
	self.m_nCount = 0
end

--@brief	返回按钮点击时回调方法
function SceneWeddingChurch:onBackBtn(element)
	WZLog("SceneWeddingChurch:onBackBtn(element)")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	if self.m_nCount == 0 then
    	self.m_nCount = 1
    	element:enableSchedule("scheduleCalculate",0.4)
    else
    	return
    end
	
	if WndMarryManager:getLoadingTag() ~= -1 then  --点击三次都没有反应则直接退出婚礼场景
		self.m_nBackCount = self.m_nBackCount + 1
		if self.m_nBackCount >= 3 then
			self:replaceSceneIsland()
			return
		end
	end

	WndMarryManager:createLoading()
	--MsgBoxManager:showConfirmBox(LocalStrings.EXIT_WEDDING_SCENE, self, self.BackBtnCallBack)
	self.m_bSendExitFlag = true 
	local playerInfo = CacheCenter:getPlayerInfo()
	if self.m_tData.manName == playerInfo.name or self.m_tData.womanName ==  playerInfo.name then --新郎与新娘退出房间
	    self:replaceSceneIsland()
	else
		ProtocolProcessorSceneWeddingChurch:send_WEDDING_EXTWedding(self.m_nWeddingNo)
		ProtocolProcessorMarryHoll:send_WEDDING_GetWedList()
	end
end

--@breif  关闭响应的浮窗
function SceneWeddingChurch:onTouchBegan(element,point,nTouchId)
	WZLog("SceneWeddingChurch:onTouchBegan")
    
    
    local touchX = point.x
    local touchY = point.y

    local conSaluted = GetElement(self.m_root,"conSaluted_SceneWeddingChurch",WZUIContainer)
    local conRedPType = GetElement(self.m_root,"conRedPType_SceneWeddingChurch",WZUIContainer)
    local conCandies = GetElement(self.m_root,"conCandies_SceneWeddingChurch",WZUIContainer)

    local conWishBless = GetElement(self.m_root,"conWishBless_SceneWeddingChurch",WZUIContainer)
    local conMyWdding = GetElement(self.m_root,"conMyWdding_SceneWeddingChurch",WZUIContainer)

    if conWishBless:isVisible() then
    	local psx , psy = conWishBless:getPosition()
    	local conSize = conWishBless:getContentSize()
    	local conWidth = conSize.width
    	local conHeight = conSize.height
    	if touchX >= psx - conWidth and touchX <= psx and touchY <= psy and touchY >= psy - conHeight then
    	   return
    	end
    end

    if conMyWdding:isVisible() then
    	local psx , psy = conMyWdding:getPosition()
    	local conSize = conMyWdding:getContentSize()
    	local conWidth = conSize.width
    	local conHeight = conSize.height
    	if touchX >= psx - conWidth and touchX <= psx and touchY <= psy and touchY >= psy - conHeight then
    	   return
    	end
    end

    if conSaluted:isVisible() then
    	local psx,psy = conSaluted:getPosition()
    	local conSize = conSaluted:getContentSize()
    	local conWidth = conSize.width
    	local conHeight = conSize.height
    	if touchX >= psx - conWidth and touchX <= psx and touchY <= psy and touchY >= psy - conHeight then
    	else
    		self:hideLeft()
    	end
    elseif conRedPType:isVisible() then
    	local psx,psy = conRedPType:getPosition()
    	local conSize = conRedPType:getContentSize()
    	local conWidth = conSize.width
    	local conHeight = conSize.height
    	if touchX >= psx - conWidth and touchX <= psx and touchY <= psy and touchY >= psy - conHeight then
    	else
    		self:hideLeft()
    	end
    elseif conCandies:isVisible() then
    	local psx,psy = conCandies:getPosition()
    	local conSize = conCandies:getContentSize()
    	local conWidth = conSize.width
    	local conHeight = conSize.height
    	if touchX >= psx - conWidth and touchX <= psx and touchY <= psy and touchY >= psy - conHeight then
    	else
    		self:hideLeft()
    	end
    end
end


--@brief	点击购买派发红包按钮点击时确定的回调方法
function SceneWeddingChurch:onSureBtnCallBack(nNum)
	WZLog("SceneWeddingChurch:onSureCallBack(nNum)")
	WZLog("nNum = ",nNum)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nSendRendNum = tonumber(nNum)
	if tonumber(nNum) < self.m_tData.rewardLowNum or tonumber(nNum) > self.m_tData.rewardHighNum then 
		return 
	end 
	
	if self.m_nSendRendNum ~= nil then 
		--派发红包（WEDDING_GiveReward = 28）
		ProtocolProcessorSceneWeddingChurch:send_WEDDING_GiveReward(self.m_nSendRendNum,self.m_nWeddingNo)
	end 
end 

--@brief	来宾按钮点击时回调方法
function SceneWeddingChurch:onGuestBtn(element)
	WZLog("SceneWeddingChurch:onGuestBtn")
	self:hideLeft()
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wndGuest = WndGuest:createElement()
   
    local guestId = {}
	local guestName = {}
	local guestLevel = {}
	local guestSex = {}
	local guestHeadId = {}
	local guestFaceId = {}
	local gusetVipLevel = {}
	local guestHeadColor = {}
	local guestBodyColor = {}
	if self.m_tData.manName ~= GlobalGame.g_tPlayerInfo.sPlayerName and self.m_tData.womanName ~= GlobalGame.g_tPlayerInfo.sPlayerName then 
		WndGuest:setIsHomeowner(false)
	end
	for i,v in ipairs(self.m_tGuest) do
		table.insert(guestId,v.guestId)
	    table.insert(guestName,v.guestName)
	    table.insert(guestLevel,v.level)
	    table.insert(guestSex,v.sex)
	    table.insert(guestHeadId,v.guestHeadId)
	    table.insert(guestFaceId,v.guestFaceId)
	    table.insert(gusetVipLevel,v.guestVipLevel)
	    table.insert(guestHeadColor,v.guestHeadColor)
	    table.insert(guestBodyColor,v.guestBodyColor)
	end

	WndGuest:GetJoinList(guestId, guestName, guestLevel, guestSex,guestHeadId,guestFaceId,GlobalGame.g_MarryPassWord,gusetVipLevel,guestHeadColor,guestBodyColor)
	WindowManager:addWindow(wndGuest,WndGuest)	
end


--@brief	礼炮祝福按钮按钮购买按钮点击时回调方法
function SceneWeddingChurch:onSureBuySalvoBtnCallBack(nNum)
	WZLog("SceneWeddingChurch:onSureBuySalvoBtnCallBack()")
	--礼炮祝福（WEDDING_Blessing = 32）
	ProtocolProcessorSceneWeddingChurch:send_WEDDING_Blessing(tonumber(nNum))
end 



--@brief	点击是否进行购买窗口确定按钮的回调函数
--@param #1 nId	消息类型
--@param #2 nResType 按钮类型
function SceneWeddingChurch:sureBtnCallback(nId,nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM  then
		WndPurchase:showBuyInterface(g_tBuyType.TYPE_OTHER,784,"ui/main/marry/marry_salute.png",SceneWeddingChurch,SceneWeddingChurch.onBuySaluteSuccessBtn)
	end
end


--@brief	购买礼炮成功的回调函数
function SceneWeddingChurch:onBuySaluteSuccessBtn()
	--礼炮祝福（WEDDING_Blessing = 32）
	WZLog("self.m_nWeddingNo = ",self.m_nWeddingNo)
	ProtocolProcessorSceneWeddingChurch:send_WEDDING_Blessing(self.m_nWeddingNo)
end

--@brief	跳转到结婚礼堂场景
function SceneWeddingChurch:onJumpToSceneWeddingChurch()
	local sceneWeddingChurch = SceneWeddingChurch:createElement()
	if sceneWeddingChurch ~= nil then
		replaceScene(sceneWeddingChurch)
	end
end

--@brief  隐藏左边的弹框
function SceneWeddingChurch:hideLeft()
	WZLog("SceneWeddingChurch:hideLeft")
	local conRedP = WZUIContainer:luaTo(self.m_root:getChildElement("conRedPType_SceneWeddingChurch"))
	local conCandies = WZUIContainer:luaTo(self.m_root:getChildElement("conCandies_SceneWeddingChurch"))
	local conSaluted = WZUIContainer:luaTo(self.m_root:getChildElement("conSaluted_SceneWeddingChurch"))
	if conSaluted:isVisible() then
		conSaluted:setVisible(false)
	end

	if conCandies:isVisible() then
		conCandies:setVisible(false)
	end

	if conRedP:isVisible() then
		conRedP:setVisible(false)
	end
end

--@brief	创建宾客动画
--@note		创建宾客动画，并创建相应定时器让其随机走动
--@param	#1 nPlayerId:玩家ID
--@param	#2 sPlayerName:玩家名字
--@param	#3 bSex:性别
--@param	#4 sPlayerFaceImg:脸
--@param	#5 sPlayerFaceImg:头象
--@param	#6 nCloses:衣服
function SceneWeddingChurch:createGuest(nPlayerId,sPlayerName,bSex,sPlayerFaceImg,sPlayerHeadImg,nCloses,headColor,bodyColor,footId)
	WZLog("SceneWeddingChurch:createGuest -----------------")
	local cellElement,tLuaObj = CellGuestList:createElement()
	if nil == cellElement and nil == tLuaObj then
		return
	end
	table.insert(self.m_tGuestElement, cellElement)
	table.insert(self.m_tGuestLuaObj, tLuaObj)
	tLuaObj:setPlayerId(nPlayerId)
	tLuaObj:setPlayerName(sPlayerName)
	tLuaObj:setEquipment(bSex,sPlayerFaceImg,sPlayerHeadImg,nCloses,headColor,bodyColor)
	tLuaObj:setFootId(footId)
	local conGuest = GetElement(self.m_root, "conGuestList_SceneWeddingChurch", WZUIContainer)
	conGuest:addChild(cellElement)
end

--@brief	根据宾客的ID移除宾客动画
--@param	nId:宾客的ID
--@note		根据宾客的ID移除宾客动画
function SceneWeddingChurch:removeGuestById(nId)
	WZLog("SceneWeddingChurch:removeGuestById----- =",nId)
	local gIndex = nil
	for i,tGuest in pairs(self.m_tGuestLuaObj) do
		
		if tGuest:getPlayerId() == nId then
			gIndex = i
		end
	end
	if gIndex then
		self.m_tGuestElement[gIndex]:removeFromParentAndCleanup(true)
		table.remove(self.m_tGuestElement, gIndex)
		table.remove(self.m_tGuestLuaObj, gIndex)
	end

	local index = nil
	for k,v in pairs(self.m_tGuest) do
		if v.guestId == nId then
			index = k
		end
	end

	if index then
		table.remove(self.m_tGuest,index)
		index = nil
	end

	for i,v in ipairs(self.m_tAlreadyLoadGuest) do
    	if v == nId then
    		index = i
    	end
    end

    if index then
		table.remove(self.m_tAlreadyLoadGuest,index)
	end
end

--@brief	执行宾客AI
--@brief	执行宾客AI，朝6个方向随机走动
function SceneWeddingChurch:_runGuestsAI(element)
	for i,tGuest in pairs(self.m_tGuestLuaObj) do
		local nPosX = self.m_tGuestElement[i]:getPositionX()
		local nPosY = self.m_tGuestElement[i]:getPositionY()
		local nGuestWalkLen = tGuest:getWalkLen()
		
		if 100 == nGuestWalkLen then
	
		elseif nGuestWalkLen > 100 and nGuestWalkLen <=110 then
			tGuest:setWalkLen(nGuestWalkLen + 1)
			return
		elseif nGuestWalkLen > 110 then
			tGuest:setCurDir(math.random(0,5))
			tGuest:setWalkLen(0)
			return
		end
		
		local nGuestDir = tGuest:getCurDir()
		--右
		if 0 == nGuestDir then
			nPosX = nPosX + 1
			
		--右上
		elseif 1 == nGuestDir then
			nPosX = nPosX + 1
			nPosY = nPosY + 1
			
		--右下
		elseif 2 == nGuestDir then
			nPosX = nPosX + 1
			nPosY = nPosY - 1
			
		--左
		elseif 3 == nGuestDir then
			nPosX = nPosX - 1
			
		--左上
		elseif 4 == nGuestDir then
			nPosX = nPosX - 1
			nPosY = nPosY + 1
			
		--左下
		elseif 5 == nGuestDir then
			nPosX = nPosX - 1
			nPosY = nPosY - 1	
		end
		
		local conGuest = GetElement(self.m_root, "conGuest_SceneWeddingChurch", WZUIContainer)
		if math.abs(nPosX-conGuest:getPositionX()) <= 420 and math.abs(nPosY-conGuest:getPositionY()) <= 140 then
			self.m_tGuestElement[i]:setPosition(GlobalMethod:ccp(nPosX, nPosY))
			tGuest:setWalkLen(nGuestWalkLen + 1)
		else
			tGuest:setCurDir(math.random(0,5))
		end
	end
end

--@brief  显示加载
function SceneWeddingChurch:showLoading()
	self.m_nLoadingTag  = MsgBoxManager:showLoadingBox()
end

--@brief  关闭加载
function SceneWeddingChurch:stopLoading()
	if self.m_nLoadingTag ==nil then
		return
	end
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)
	self.m_nLoadingTag = nil
end
    
-------------------------------------公有方法模块End----------------------------------------

    
-------------------------------------回调方法模块Begin----------------------------------------

--@brief  查看婚礼日志
function SceneWeddingChurch:onWeddingBlog(element)
	WZLog("SceneWeddingChurch:onWeddingBlog")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:hideLeft()
	ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetMarryLog(self.m_nWeddingNo)
	self:showLoading()
end

--@brief  发红包
function SceneWeddingChurch:onSendRedBagBtn(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_bShowWeddingPresent then
    	MsgBoxManager:showTipBox(LocalStrings.SEND_WEDDING_GOODS1)
    	return
    elseif self.m_bShowWeddingCake then
    	MsgBoxManager:showTipBox(LocalStrings.SEND_WEDDING_GOODS2)
    	return
    end

	local conRedP = WZUIContainer:luaTo(self.m_root:getChildElement("conRedPType_SceneWeddingChurch"))

	local conCandies = WZUIContainer:luaTo(self.m_root:getChildElement("conCandies_SceneWeddingChurch"))
	conCandies:setVisible(false)
	local conSaluted = WZUIContainer:luaTo(self.m_root:getChildElement("conSaluted_SceneWeddingChurch"))
	conSaluted:setVisible(false)

	if not conRedP:isVisible() then
		conRedP:setVisible(true)
	else
		conRedP:setVisible(false)
	end
	
end

--@brief 派喜糖
function SceneWeddingChurch:onSendCandies(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_bShowWeddingCake then
    	MsgBoxManager:showTipBox(LocalStrings.SEND_WEDDING_GOODS2)
    	return
    elseif self.m_bShowWeddingPresent then
    	MsgBoxManager:showTipBox(LocalStrings.SEND_WEDDING_GOODS1)
    	return
    end
	local conCandies = WZUIContainer:luaTo(self.m_root:getChildElement("conCandies_SceneWeddingChurch"))
	local conRedP = WZUIContainer:luaTo(self.m_root:getChildElement("conRedPType_SceneWeddingChurch"))
	local conSaluted = WZUIContainer:luaTo(self.m_root:getChildElement("conSaluted_SceneWeddingChurch"))
	conSaluted:setVisible(false)
	conRedP:setVisible(false)

    if not conCandies:isVisible() then
    	conCandies:setVisible(true)
    else
    	conCandies:setVisible(false)
    end
end

--@brief  邀请好友参加婚礼
function SceneWeddingChurch:onInvFriend(element)
	WZLog("SceneWeddingChurch:onInvFriend")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:hideLeft()
	WndFriendList:showInterface(2,SceneWeddingChurch,self.invFriendList)
end

--@brief  婚礼邀请回调
function SceneWeddingChurch:invFriendList(tData,index)
	WZLog("SceneWeddingChurch:invFriendList ")
	if tData == nil or #tData == 0 then return end
	local friendId = tData[1].id
	ProtocolProcessorSceneWeddingChurch:send_WEDDING_Invitation(friendId,self.m_nWeddingNo)
end

--@brief  放礼炮
function SceneWeddingChurch:onWishBlessBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local conSaluted = WZUIContainer:luaTo(self.m_root:getChildElement("conSaluted_SceneWeddingChurch"))
	if not conSaluted:isVisible() then
		conSaluted:setVisible(true)
	else
		conSaluted:setVisible(false)
	end

	local conCandies = WZUIContainer:luaTo(self.m_root:getChildElement("conCandies_SceneWeddingChurch"))
	conCandies:setVisible(false)
	local conRedP = WZUIContainer:luaTo(self.m_root:getChildElement("conRedPType_SceneWeddingChurch"))
	conRedP:setVisible(false)
end

--@brief  抢红包
function SceneWeddingChurch:onReceiveRedPBtn(element)
	WZLog("SceneWeddingChurch:onReceiveRedPBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetSomething(self.m_nWeddingNo,1,self.m_nOperationTime)
end

--@brief 抢喜糖
function SceneWeddingChurch:onRecCandies(element)
	WZLog("SceneWeddingChurch:onRecCandies")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetSomething(self.m_nWeddingNo,2,self.m_nOperationTime)
end

--@brief 送祝福
function SceneWeddingChurch:onSBlessing(element)
	WZLog("SceneWeddingChurch:onSBlessing")
	self:hideLeft()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorSceneWeddingChurch:send_WEDDING_Operation(self.m_nWeddingNo,3,1)
end

--@brief  显示祝福语
function SceneWeddingChurch:showBlessing(playerId,index)
	for i,v in ipairs(self.m_tGuestLuaObj) do
		if v:getPlayerId() == playerId then
			if index == 1 then
				WZLog("-------")
				v:setBlessings(LocalStrings.SEND_BLESSING_1)
			elseif index ==2 then
				WZLog("+++======")
				v:setBlessings(LocalStrings.SEND_BLESSING_2)
			elseif index ==3 then
				WZLog("++++++++")
				v:setBlessings(LocalStrings.SEND_BLESSING_3)
			end
			return
		end
	end
end

--@brief  发红包
function SceneWeddingChurch:onClickSendRedP(element)
    WZLog("SceneWeddingChurch:onClickSendRedP")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:hideLeft()
	self.m_nTempTag = element:getTag()
	local redPPrice  = CacheCenter:getGameParam().wedRedPrice
	local redPCD = CacheCenter:getGameParam().wedRedCD
	local id, price=  SplitItemString(redPPrice)

	self.m_nOperateType = 1
    if not JudgeMoneyIsEnough(tonumber(id[self.m_nTempTag]), tonumber(price[self.m_nTempTag]),nil, nil, 86, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
        return 
    end

    self:sureUseDiamondInstead()
end

--@brief  发喜糖
function SceneWeddingChurch:onClickSendCandies(element)
    WZLog("SceneWeddingChurch:onClickSendCandies")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:hideLeft()

	self.m_nTempTag = element:getTag()
	local candPrice  = CacheCenter:getGameParam().wedCandyPrice
	local id, price=  SplitItemString(candPrice)

    self.m_nOperateType = 2
    if not JudgeMoneyIsEnough(tonumber(id[self.m_nTempTag]), tonumber(price[self.m_nTempTag]),nil, nil, 86, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
        return 
    end

    self:sureUseDiamondInstead()
end

--@brief  发礼炮
function SceneWeddingChurch:onClickSendSaluted(element)
    WZLog("SceneWeddingChurch:onClickSendSaluted")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:hideLeft()
    if self.m_bNowShowSalvo then
    	MsgBoxManager:showTipBox(LocalStrings.SEND_WEDDING_GOODS4)
    	return 
    end

	self.m_nTempTag = element:getTag()
	local salutePrice  = CacheCenter:getGameParam().wedSalutePrice
	local id, price=  SplitItemString(salutePrice)

	self.m_nOperateType = 4
    if not JudgeMoneyIsEnough(tonumber(id[self.m_nTempTag]), tonumber(price[self.m_nTempTag]),nil, nil, 86, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
        return 
    end

    self:sureUseDiamondInstead()
end

--@brief    确认用钻石代替礼券放礼炮
function SceneWeddingChurch:sureUseDiamondInstead()
    -- body
    local weddingNum = self.m_nWeddingNo 

    ProtocolProcessorSceneWeddingChurch:send_WEDDING_Operation(weddingNum, self.m_nOperateType, self.m_nTempTag)
end

--@brief  跳转到充值界面
--@param    nResType:响应类型(超时，确定，取消)
function SceneWeddingChurch:clickSureMoney(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
	end
end

--@brief    快速购买金币框
--@param    nResType:响应类型(超时，确定，取消)
function SceneWeddingChurch:buyGold(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(26)
    end
end

--@brief   结婚日志排序
function sortLoveLog(a,b)
  if a.createDate > b.createDate then
  	return true
  else
  	return false
  end
end

--@brief  显示婚礼日志
function SceneWeddingChurch:showWeddingBlog(logType, createDate, playerName, coupleName, num)
	WZLog("SceneWeddingChurch:showWeddingBlog")
	if #logType == 0 then
        MsgBoxManager:showTipBox(LocalStrings.LOVING_DAILY)
        return
    end
	self:stopLoading()
	local temp = {}
	for i,v in ipairs(logType) do
		local logInfo = {}
		logInfo.logType = v
		logInfo.createDate = createDate[i]
		logInfo.playerName = playerName[i]
		logInfo.coupleName = coupleName[i]
		logInfo.num = num[i]
		table.insert(temp,logInfo)
	end

	table.sort(temp,sortLoveLog)
    local logInfos = {}
    local playerNames = CacheCenter:getPlayerInfo().name
    
    local daily = nil
    for i,v in ipairs(temp) do
       local strTime = os.date("%m-%d %H:%M",v.createDate)
       if v.logType ==1 then
       	  daily = string.format(LocalStrings.WEDDING_DIARY_1,v.playerName,strTime)
       elseif v.logType ==2 then
       	  daily = string.format(LocalStrings.WEDDING_DIARY_2,v.playerName,strTime)
       elseif v.logType ==3 then
       	  daily = string.format(LocalStrings.WEDDING_DIARY_3,v.playerName,strTime)
       elseif v.logType ==4 then
       	  daily = string.format(LocalStrings.WEDDING_DIARY_4,v.playerName,v.num,strTime)
       elseif v.logType ==5 then
       	  daily = string.format(LocalStrings.WEDDING_DIARY_5,v.playerName,strTime)
       elseif v.logType ==6 then
       	  daily = string.format(LocalStrings.WEDDING_DIARY_6,v.playerName,v.num,strTime)
       elseif v.logType ==7 then
       	  daily = string.format(LocalStrings.WEDDING_DIARY_7,v.playerName,v.num,strTime)
       elseif v.logType ==8 then
       	  daily = string.format(LocalStrings.WEDDING_DIARY_8,v.playerName,v.num,strTime)
       elseif v.logType ==9 then
       	  daily = string.format(LocalStrings.WEDDING_DIARY_9,v.playerName,v.coupleName,v.num,strTime)
       end
       table.insert(logInfos,daily)
    end
    local winGenericLog = WndGenericLog:createElement()
    WindowManager:addWindow(winGenericLog,WndGenericLog)
    WndGenericLog:setListInfo(logInfos)
    WndGenericLog:setTitleImg("ui/common/common_icon_hlrz.png")
    temp = nil
    logInfos = nil
end

--@breif  抢红包、喜糖
function SceneWeddingChurch:onRob(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	WZLog("SceneWeddingChurch:onRob ------------- = ",tag)
	if tag == 1 and not self.m_bSendRobRedPacket  then
		ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetSomething (self.m_nWeddingNo,1,self.m_nOperationTime)
	    self.m_bSendRobRedPacket = true
	elseif tag == 2 and not self.m_bSendRobCandies then
	    local itemCount = CacheCenter:getPlayerInfo().vigor
		if itemCount >= 1000 then
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_HAVED_FULL)
			return 
		end
		ProtocolProcessorSceneWeddingChurch:send_WEDDING_GetSomething (self.m_nWeddingNo,2,self.m_nOperationTime)
		self.m_bSendRobCandies = true
	end
end

--@brief  处理玩家的各种祝福
function SceneWeddingChurch:handleBlessing(operation,playerId,index,operationTime)
	WZLog("SceneWeddingChurch:handleBlessing ",operation,playerId,index)
	if self.m_root == nil then return end
	self.m_nOperationTime = operationTime
	if operation ~= 3 and operation ~=4 then
		if operation ==1 then
			local tempInfo = {}
			table.insert(tempInfo,operationTime)
			local curTime  =os.time()
			table.insert(tempInfo,curTime)

			table.insert(self.m_tRedPacket,tempInfo)
		elseif  operation ==2 then
			local tempInfo2 = {}
			table.insert(tempInfo2,operationTime)
			local curTime2  =os.time()
			table.insert(tempInfo2,curTime2)

			table.insert(self.m_tHappinessCandies,tempInfo2)
		end
		return
	end

    if operation == 3 then  --送祝福
		self:showBlessing(playerId,index)
	elseif operation == 4 then  --发礼炮
		if self.m_bNowShowSalvo then
			return
		end
		if index == 1 then
			self:showParticle("qiuhun04")
		elseif  index == 2 then
			self:showParticle("qiuhun05")
		elseif  index == 3 then
			self:showParticle("qiuhun06")
		end
	end
end

--@brief  检测是否有红包需要显示
function SceneWeddingChurch:scheudleShowPacketOrCandies(element)
	WZLog("SceneWeddingChurch:scheudleShowPacketOrCandies")
	--如果抢红包与抢喜糖都有，就判断那个发送的时间最早，最早的那个先显示
	local tempShowPacket = true
	if #self.m_tRedPacket > 0 and #self.m_tHappinessCandies > 0 then
		if self.m_tRedPacket[1][2] > self.m_tHappinessCandies[1][2] then
			tempShowPacket = false
		end
	end

	if tempShowPacket then
		if #self.m_tRedPacket > 0 and not self.m_bShowWeddingPresent and not self.m_bShowWeddingCake then
			self.m_nOperationTime = self.m_tRedPacket[1][1]
			local conPrize = WZUIContainer:luaTo(self.m_root:getChildElement("conPrize_SceneWeddingChurch"))
			local redPacketAnimation = WZUISystem:getInstance():createElement("qiuhun07")
			self.m_root:addChild(redPacketAnimation)
			conPrize:enableSchedule("showRedPacket",1)
			self.m_oCurOSN = conPrize
			self.m_bShowWeddingPresent = true
			self.m_conPrize = redPacketAnimation
			table.remove(self.m_tRedPacket,1)
			return
	    end
	end

	if #self.m_tHappinessCandies > 0 and not self.m_bShowWeddingCake and not self.m_bShowWeddingPresent then
		self.m_nOperationTime = self.m_tHappinessCandies[1][1]
		local conCandies = WZUIContainer:luaTo(self.m_root:getChildElement("conCandies2_SceneWeddingChurch"))
		local candiesAnimation = WZUISystem:getInstance():createElement("qiuhun08")
		self.m_root:addChild(candiesAnimation)
		conCandies:enableSchedule("showCandies",1)
		self.m_oCurOSN = conCandies
		self.m_bShowWeddingCake = true
		self.m_conCandies = candiesAnimation
		table.remove(self.m_tHappinessCandies,1)
		return
	end
end

--@beif  显示红包
function SceneWeddingChurch:showRedPacket(element,delat)
	if self.m_nRedPackAndCandiesCountDown == 2 then
		local conPrize = GetElement(self.m_root,"conPrize_SceneWeddingChurch",WZUIContainer)
		conPrize:setVisible(true)
	elseif self.m_nRedPackAndCandiesCountDown >= 5 then
		self:_disableRobRedPacket(element)
	end
	self.m_nRedPackAndCandiesCountDown = self.m_nRedPackAndCandiesCountDown + 1
end

--@beif  显示喜糖
function SceneWeddingChurch:showCandies(element,delat)
	if self.m_nRedPackAndCandiesCountDown == 2 then
		local conCandies2 = GetElement(self.m_root,"conCandies2_SceneWeddingChurch",WZUIContainer)
		conCandies2:setVisible(true)
	elseif self.m_nRedPackAndCandiesCountDown >= 5 then
		self:_disableRobCandiesPacket(element)
	end
	self.m_nRedPackAndCandiesCountDown = self.m_nRedPackAndCandiesCountDown + 1
end


--@brief 发红包、喜糖、祝福、礼炮回调函数
--@param result : 1、成功，2、正在发红包或喜糖
--@param  operation : 操作类型【1、发红包，2、发喜糖，3、送祝福，4、放礼炮】
function SceneWeddingChurch:sendBlessingResult(result,operation)
	WZLog("SceneWeddingChurch:sendBlessingResult")
	if result == 1 then
		
	elseif result == 2 then
		if operation == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SEND_WEDDING_GOODS1)
		elseif operation == 2 then
			MsgBoxManager:showTipBox(LocalStrings.SEND_WEDDING_GOODS2)
		elseif operation == 3 then
			MsgBoxManager:showTipBox(LocalStrings.SEND_WEDDING_GOODS3)
		elseif operation == 4 then
			MsgBoxManager:showTipBox(LocalStrings.SEND_WEDDING_GOODS4)
		end
	end
end

--@brief  派发红包后的定时器回调
function SceneWeddingChurch:redBagCallback(element,dt)
	self.m_nRedCountdown =  self.m_nRedCountdown -1  
	local btnSendRed = WZUIButton:luaTo(self.m_root:getChildElement("btnSendRedBag_SceneWeddingChurch"))
	local txtRed =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtSendRedPCountdown"))
    if self.m_nRedCountdown == 0 or self.m_nRedCountdown < 0 then
    	element:disableSchedule()
    	btnSendRed:setTouchEnable(true)
    	txtRed:setText("")
    else
    	txtRed:setText(tostring(self.m_nRedCountdown))
    	btnSendRed:setTouchEnable(false)
    end
end

--@brief  派发喜糖后的定时器回调
function SceneWeddingChurch:candiesCallback(element,dt)
	self.m_nCandiesCountdown = self.m_nCandiesCountdown -1      
	local btnSendCandies = WZUIButton:luaTo(self.m_root:getChildElement("btnSendCandies_SceneWeddingChurch"))
	local txtSendCandies =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtSendCandiesCountdown"))
    if self.m_nCandiesCountdown == 0 or self.m_nCandiesCountdown < 0  then
    	element:disableSchedule()
    	btnSendCandies:setTouchEnable(true)
    	txtSendCandies:setText("")
    else
    	txtSendCandies:setText(tostring(self.m_nCandiesCountdown))
    	btnSendCandies:setTouchEnable(false)
    end   
end

--@brief  派发祝福后的定时器回调
function SceneWeddingChurch:wishCallback(element,dt)
	self.m_nBlessingCountdown = self.m_nBlessingCountdown -1     
	local btnSBlessing = WZUIButton:luaTo(self.m_root:getChildElement("btnSBlessing_SceneWeddingChurch"))
	local txtSendBlessing =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtSendBlessingCountdown"))
    if self.m_nBlessingCountdown == 0 or self.m_nBlessingCountdown < 0  then
    	element:disableSchedule()
    	btnSBlessing:setTouchEnable(true)
    	txtSendBlessing:setText("")
    else
    	txtSendBlessing:setText(tostring(self.m_nBlessingCountdown))
    	btnSBlessing:setTouchEnable(false)
    end   
end

--@brief  派发礼炮后的定时器回调
function SceneWeddingChurch:saluteCallback(element,interval)
	self.m_nSaluteCountdown = self.m_nSaluteCountdown -1       
	local btnWishBless = WZUIButton:luaTo(self.m_root:getChildElement("btnWishBless_SceneWeddingChurch"))
	local txtSalute =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtSaluteCountdown"))
    if self.m_nSaluteCountdown == 0 or self.m_nSaluteCountdown < 0 then
    	element:disableSchedule()
    	btnWishBless:setTouchEnable(true)
    	txtSalute:setText("")
    else
    	txtSalute:setText(tostring(self.m_nSaluteCountdown))
    	btnWishBless:setTouchEnable(false)
    end
end

--@breif  显示礼炮粒子效果
--@param  particleFile : 需要播放的粒子效果文件
function SceneWeddingChurch:showParticle(particleFile)
	self.m_sParticleFile = particleFile
	self.m_bNowShowSalvo = true
	self.m_root:enableSchedule("playSalute",1)
end

--@brief 定时播放礼炮
function SceneWeddingChurch:playSalute(element,delat)
	WZLog("SceneWeddingChurch:playSalute")
	if self.m_root:getChildByTag(121+self.m_nSalute-1) then
		self.m_root:removeChildByTag(121+self.m_nSalute-1,true)
	end

	if self.m_root:getChildByTag(122+self.m_nSalute-1) then
		self.m_root:removeChildByTag(122+self.m_nSalute-1,true)
	end

	if self.m_nSalute <= self.m_nPlaySalute and self.m_root ~= nil then
		local particle = nil
		local particle2 = nil
		local particle3 = nil
		if self.m_sParticleFile ~= "qiuhun06" then
			particle = WZUISystem:getInstance():createElement(self.m_sParticleFile)
	        particle:setTag(121 + self.m_nSalute)
	    else
	    	
	    	if not self.m_root:getChildByTag(143) then
	    		particle3 = WZUISystem:getInstance():createElement(self.m_sParticleFile)
		        particle3:setTag(143)
	    	end
	    	particle2 = WZUISystem:getInstance():createElement("qiuhun09")
		    particle2:setTag(122 + self.m_nSalute)
	    	
		end
	    
	    if self.m_sParticleFile == "qiuhun05" then
	    	local par1 = GetElement(particle,"par1_qiuhun05",WZUIParticle)
	    	local indexPs = math.random(1,10)
	        local ps = salutePs[indexPs]
	        par1:setRelativePosition(GlobalMethod:ccp(ps[1],ps[2]))
	    	local par2 = GetElement(particle,"par2_qiuhun05",WZUIParticle)
	    	indexPs = math.random(1,10)
	        ps = salutePs[indexPs]
	        par2:setRelativePosition(GlobalMethod:ccp(ps[1],ps[2]))
	    	local par3 = GetElement(particle,"par3_qiuhun05",WZUIParticle)
	    	indexPs = math.random(1,10)
	        ps = salutePs[indexPs]
	        par3:setRelativePosition(GlobalMethod:ccp(ps[1],ps[2]))

	    	self.m_nPlaySalute = 6
	    elseif self.m_sParticleFile == "qiuhun06" then
	    	local par1 = GetElement(particle2,"par1_qiuhun09",WZUIParticle)
	    	local indexPs = math.random(1,10)
	        local ps = salutePs[indexPs]
	        par1:setRelativePosition(GlobalMethod:ccp(ps[1],ps[2]))
	    	local par2 = GetElement(particle2,"par2_qiuhun09",WZUIParticle)
	    	indexPs = math.random(1,10)
	        ps = salutePs[indexPs]
	        par2:setRelativePosition(GlobalMethod:ccp(ps[1],ps[2]))
	    	local par3 = GetElement(particle2,"par3_qiuhun09",WZUIParticle)
	    	indexPs = math.random(1,10)
	        ps = salutePs[indexPs]
	        par3:setRelativePosition(GlobalMethod:ccp(ps[1],ps[2]))

	    	self.m_nPlaySalute = 6
	    else
	    	local indexPs = math.random(1,10)
	        local ps = salutePs[indexPs]
	    	particle:setRelativePosition(GlobalMethod:ccp(ps[1],ps[2]))
	    	self.m_nPlaySalute = 12
	    end
	    if particle then
	    	particle:setVisible(true)
	        self.m_root:addChild(particle)
	    end

	    if particle2 then
	    	particle2:setVisible(true)
	        self.m_root:addChild(particle2)
	    end

	    if particle3 then
	    	particle3:setVisible(true)
	        self.m_root:addChild(particle3)
	    end
	   
	else
		if self.m_root:getChildByTag(143) then
		    self.m_root:removeChildByTag(143,true)
	    end

		self.m_nSalute = 0
		self.m_bNowShowSalvo = false
		element:disableSchedule()
	end
	self.m_nSalute = self.m_nSalute + 1
end

--@breif  分帧加载嘉宾
function SceneWeddingChurch:scheudleCreateGuest(element,delat)
	if self.m_nCreateGuestCount > 20 then  --大于20个来宾就不创建来宾形象了
		element:disableSchedule()
		return 
	end
	
	if self.m_nCreateGuestCount ~= self.m_nPlayerIndex and self.m_nCreateGuestCount <= #self.m_tGuest then
		local isExit = false
		for i,v in ipairs(self.m_tAlreadyLoadGuest) do
			if v == self.m_tGuest[self.m_nCreateGuestCount].guestId then
				isExit = true
				break
			end
	    end
	    if not isExit then
	    	self:createGuest(self.m_tGuest[self.m_nCreateGuestCount].guestId,self.m_tGuest[self.m_nCreateGuestCount].guestName,self.m_tGuest[self.m_nCreateGuestCount].sex,
						self.m_tGuest[self.m_nCreateGuestCount].guestFaceId,self.m_tGuest[self.m_nCreateGuestCount].guestHeadId,
						self.m_tGuest[self.m_nCreateGuestCount].guestBodyId,self.m_tGuest[self.m_nCreateGuestCount].guestHeadColor,
						self.m_tGuest[self.m_nCreateGuestCount].guestBodyColor,self.m_tGuest[self.m_nCreateGuestCount].guestHeadId,footmark)
	        table.insert(self.m_tAlreadyLoadGuest,self.m_tGuest[self.m_nCreateGuestCount].guestId)
	    end
	end

	if self.m_nCreateGuestCount > #self.m_tGuest then
		element:disableSchedule()
		return
	end
	self.m_nCreateGuestCount = self.m_nCreateGuestCount + 1
end

--@brief  每帧调用对来宾的渲染顺序进行排序,防止人物移动时出现穿插
function SceneWeddingChurch:scheduleSortGuest(element,interval)
	for i,v in ipairs(self.m_tGuestElement) do
		if v ~= nil then
			v:setZOrder(-v:getPositionY())
		end
	end
end

-------------------------------------回调方法模块End--------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	更新UI方法
function SceneWeddingChurch:_update()
	if self.m_root == nil then
		return
	end

	--更新背景UI和结婚双方信息
	self:_updateBgUi()
	--更新按钮文字UI
	self:_updateButtonTextUi()

end


--@brief 设置人物走动
function SceneWeddingChurch:_setPlayerAni()
	if self.m_root == nil then 
		return 
		WZLog("SceneWeddingChurch:_setPlayerAni() self.m_root is nil")
	end 

	if self.m_tData == nil then 
		return 
	end 
	WZLog("SceneWeddingChurch:_setPlayerAni ")
	--创建人物走动
	local playerId  = CacheCenter:getPlayerInfo().id
	local delayT = 0.1
	local playerIndex = nil
	for i,v in ipairs(self.m_tGuest) do
		if v.guestId == playerId then
			playerIndex = i
			self.m_nPlayerIndex= playerIndex
		end
	end
	
	if playerIndex ~= nil then
		table.insert(self.m_tAlreadyLoadGuest,playerId)
		self:createGuest(self.m_tGuest[playerIndex].guestId,self.m_tGuest[playerIndex].guestName,self.m_tGuest[playerIndex].sex,
						self.m_tGuest[playerIndex].guestFaceId,self.m_tGuest[playerIndex].guestHeadId,self.m_tGuest[playerIndex].guestBodyId,
						self.m_tGuest[playerIndex].guestHeadColor,self.m_tGuest[playerIndex].guestBodyColor,self.m_tGuest[playerIndex].footmark)
	    --table.remove(self.m_tGuest,playerIndex)
	end
   
    self.m_conMiddle =  GetElement(self.m_root,"conMiddle_SceneWeddingChurch",WZUIContainer)
    self.m_conMiddle:enableSchedule("scheudleCreateGuest",0.3)
end

--@brief 更新背景UI和结婚双方信息
function SceneWeddingChurch:_updateBgUi()
	WZLog("SceneWeddingChurch:_updateBgUi()")
	
	local conGroom = WZUIContainer:luaTo(GetElement(self.m_root,"conGroom_SceneWeddingChurch"))
	local conBrige = WZUIContainer:luaTo(GetElement(self.m_root,"conBrige_SceneWeddingChurch"))
	local txtGroomBrigeName = GetElement(self.m_root,"txtGroomBrigeName_SceneWeddingChurch",WZUILabelTTF)
	local txtBrigeName = GetElement(self.m_root,"txtBrigeName_SceneWeddingChurch",WZUILabelTTF)	
	--加载骨骼动画相关资源
	local wedFullDress = CacheCenter:getGameParam().wedFullDress

	local array = SplitStringWithSeparator(wedFullDress,"#")
	local equipment = nil
	for i=1,#array do
		local ids ,nums = SplitItemString(array[i],"&")
		if self.m_nWdddingType == i then
			equipment = ids
		elseif self.m_nWdddingType == i then
			equipment = ids
		elseif self.m_nWdddingType == i then
			equipment = ids
		end
	end
	--根据婚礼类型
	local tBoyEquip = {}
	local tGirlEquip = {}
	for i=1,6 do
    	if i<=3 then
    		table.insert(tBoyEquip,tonumber(equipment[i]))
    	else
    		table.insert(tGirlEquip,tonumber(equipment[i]))
    	end
	end

	local bUseBoyHeadColor = false
	local bUseBoyBodyColor = false

	local boyHeadColor = 0
	local bodyBodyColor = 0

	for i,v in ipairs(tBoyEquip) do
		if self.manHeadId == v then
			boyHeadColor = self.manHeadColour
		end

		if self.manFashionId == v then
			bodyBodyColor = self.manBodyColour
		end
	end
                  
	local conPlayer = CreatePlayerFigure(0,tBoyEquip,nil,nil,nil,nil,nil,nil,nil,nil,boyHeadColor,bodyBodyColor)
	local animNode = conPlayer:getAnimNode()
	animNode:setScale(0.64)
	conGroom:addChild(animNode)

    local bUseGirlHeadColor = false
	local bUseGirlBoyBodyColor = false

	local girlHeadColor = 0
	local girlBodyColor = 0

	for i,v in ipairs(tGirlEquip) do
		if self.womanHeadId == v then
			girlHeadColor = self.womanHeadColour
		end

		if self.womanFashionId  == v then
			girlBodyColor = self.womanBodyColour
		end
	end

	conPlayer = CreatePlayerFigure(1,tGirlEquip,nil,nil,nil,nil,nil,nil,nil,nil,girlHeadColor,girlBodyColor)
	animNode = conPlayer:getAnimNode()
	animNode:setScale(0.64)
	conBrige:addChild(animNode)

	txtGroomBrigeName:setText(self.m_tData.manName)
	txtBrigeName:setText(self.m_tData.womanName)

	if self.m_bIsMyWedding == true then
		WZUIContainer:luaTo(self.m_root:getChildElement("conMyWdding_SceneWeddingChurch")):setVisible(true)
		WZUIContainer:luaTo(self.m_root:getChildElement("conOtherBtn_SceneWeddingChurch")):setVisible(false)
	    GetElement(self.m_root,"conInvFriend_SceneWeddingChurch",WZUIContainer):setVisible(true)
	else
		WZUIContainer:luaTo(self.m_root:getChildElement("conMyWdding_SceneWeddingChurch")):setVisible(false)
		WZUIContainer:luaTo(self.m_root:getChildElement("conOtherBtn_SceneWeddingChurch")):setVisible(true)
	    GetElement(self.m_root,"conInvFriend_SceneWeddingChurch",WZUIContainer):setVisible(false)
	end

	self:resetCDTime(nil)

	
end

--@brief  复原CD时间
--@param cdType : 操作类型【1、发红包，2、发喜糖，3、送祝福，4、放礼炮】nil 全部恢复默认
function SceneWeddingChurch:resetCDTime(cdType)

	local RedCD = CacheCenter:getGameParam().wedRedCD
	local CandyCD = CacheCenter:getGameParam().wedCandyCD
    local BlessingCD = CacheCenter:getGameParam().wedBlessingCD
    local SaluteCD = CacheCenter:getGameParam().wedSaluteCD

    local redCDID,redCDT =  SplitItemString(RedCD)
    local candyCDID,candyCDT =  SplitItemString(CandyCD)
    local blessingCDID,blessingCDT =  SplitItemString(BlessingCD)
    local saluteDID,saluteCDT =  SplitItemString(SaluteCD)
    if cdType ==nil then
    	if self.m_nWdddingType ==1 then
			self.m_nRedCountdown = redCDT[1]
			self.m_nSaluteCountdown = saluteCDT[1]
			self.m_nBlessingCountdown = blessingCDT[1]
			self.m_nCandiesCountdown = candyCDID[1]
		elseif self.m_nWdddingType ==2 then
			self.m_nRedCountdown = redCDT[2]
			self.m_nSaluteCountdown = saluteCDT[2]
			self.m_nBlessingCountdown = blessingCDT[2]
			self.m_nCandiesCountdown = candyCDID[2]
		elseif self.m_nWdddingType ==3 then
			self.m_nRedCountdown = redCDT[3]
			self.m_nSaluteCountdown = saluteCDT[3]
			self.m_nBlessingCountdown = blessingCDT[3]
			self.m_nCandiesCountdown = candyCDID[3]
		end
	else
		if cdType ==1 then
			if self.m_nWdddingType ==1 then
				self.m_nRedCountdown = redCDT[1]
			elseif self.m_nWdddingType ==2 then
				self.m_nRedCountdown = redCDT[2]
			elseif self.m_nWdddingType ==3 then
				self.m_nRedCountdown = redCDT[3]
			end
			
		elseif cdType==2 then
			if self.m_nWdddingType ==1  then
				self.m_nCandiesCountdown = candyCDID[1]
			elseif self.m_nWdddingType ==2  then
				self.m_nCandiesCountdown = candyCDID[2]
			elseif self.m_nWdddingType ==3  then
				self.m_nCandiesCountdown = candyCDID[3]
			end
		elseif cdType== 3 then
			if self.m_nWdddingType ==1  then
				self.m_nCandiesCountdown = blessingCDT[1]
			elseif self.m_nWdddingType ==2  then
				self.m_nCandiesCountdown  = blessingCDT[2]
			elseif self.m_nWdddingType ==3  then
				self.m_nCandiesCountdown  = blessingCDT[3]
			end
		elseif cdType==4 then
			if self.m_nWdddingType ==1  then
				self.m_nSaluteCountdown  = saluteCDT[1]
			elseif self.m_nWdddingType ==2  then
				self.m_nSaluteCountdown =  saluteCDT[1]
			elseif self.m_nWdddingType ==3  then
				self.m_nSaluteCountdown  = saluteCDT[1]
			end
		end
    end
end


--@brief	更新按钮文字UI的函数
function SceneWeddingChurch:_updateButtonTextUi()
	if self.m_root == nil or self.m_tData == nil or self.m_tData.manName == nil then
		WZLog("self.m_root == nil or self.m_tData == nil or self.m_tData.manNam == nil")
		return
	end
	WZUIContainer:luaTo(GetElement(self.m_root,"conGuest_SceneWeddingChurch")):setVisible(true)

	--婚礼自己是主角时
	if self.m_tData.manName == GlobalGame.g_tPlayerInfo.sPlayerName or self.m_tData.womanName == GlobalGame.g_tPlayerInfo.sPlayerName then
		GetElement(self.m_root,"conMyWdding_SceneWeddingChurch"):setVisible(true)
	--来宾时
	else
		GetElement(self.m_root,"conOtherBtn_SceneWeddingChurch"):setVisible(true)
	end
	
end

function SceneWeddingChurch:_adaptLanguage_en()
    WZLog("SceneWeddingChurch:_adaptLanguage_en")
    local conPopPriest = GetElement(self.m_root,"conPopPriest_SceneWeddingChurch",WZUIContainer)
    conPopPriest:setAbsContentSize(GlobalMethod:CCSize(290,100))
    conPopPriest:updateRelativeSize()

    local txtPopPriest = GetElement(conPopPriest,"txtPopPriest_SceneWeddingChurch",WZUILabelTTF)
    txtPopPriest:setDimensions(GlobalMethod:CCSize(270,0))
    txtPopPriest:setMaxLength(60)

    local txtRoomId = GetElement(self.m_root,"txtRoomId_SceneWeddingChurch",WZUILabelTTF)
    txtRoomId:setFontSize(18)
end

function SceneWeddingChurch:_adaptLanguage_pt(  )
	local conPopPriest = GetElement(self.m_root,"conPopPriest_SceneWeddingChurch",WZUIContainer)
    conPopPriest:setAbsContentSize(GlobalMethod:CCSize(290,100))
    conPopPriest:updateRelativeSize()

    local txtPopPriest = GetElement(conPopPriest,"txtPopPriest_SceneWeddingChurch",WZUILabelTTF)
    txtPopPriest:setDimensions(GlobalMethod:CCSize(270,0))
    txtPopPriest:setMaxLength(60)
    txtPopPriest:setFontSize(20)

    local txtRoomId = GetElement(self.m_root,"txtRoomId_SceneWeddingChurch",WZUILabelTTF)
    txtRoomId:setFontSize(14)
end

function SceneWeddingChurch:_adaptLanguage_th(  )
	local conPopPriest = GetElement(self.m_root,"conPopPriest_SceneWeddingChurch",WZUIContainer)
    conPopPriest:setAbsContentSize(GlobalMethod:CCSize(290,100))
    conPopPriest:updateRelativeSize()
    local txtPopPriest = GetElement(conPopPriest,"txtPopPriest_SceneWeddingChurch",WZUILabelTTF)
    txtPopPriest:setDimensions(GlobalMethod:CCSize(270,0))
    txtPopPriest:setMaxLength(60)
    txtPopPriest:setFontSize(20)
end

function SceneWeddingChurch:_adaptLanguage_tr(  )
    local txtRoomId = GetElement(self.m_root,"txtRoomId_SceneWeddingChurch",WZUILabelTTF)
    txtRoomId:setFontSize(14)
end

function SceneWeddingChurch:_adaptLanguage_es(  )
    local txtRoomId = GetElement(self.m_root,"txtRoomId_SceneWeddingChurch",WZUILabelTTF)
    txtRoomId:setFontSize(18)
end

------------------------------动画随机START-----------------------------------------------------------------------------


------------------------------动画随机END---------------------------------------------------------------------


-------------------------------------私有方法模块End----------------------------------------
