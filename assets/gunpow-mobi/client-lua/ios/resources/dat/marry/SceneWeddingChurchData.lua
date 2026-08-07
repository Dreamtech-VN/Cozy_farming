--SceneWeddingChurchData.lua
--@brief	SceneWeddingChurch的数据模块
--@date		2014/03/27
--@author	林庆凯
--@note		结婚礼堂场景


SceneWeddingChurch = {
	--请不要在这里定义变量
    m_bsetOpenPassWord = 0   --是否已经勾选密码
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneWeddingChurch:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTouchBgX = nil              --触摸开始X轴
	self.m_nTouchBgY = nil              --触摸开始Y轴
	self.m_nFlapX = true                --翻转X轴初始为true
	self.m_nPosX = nil                  --
	self.m_nPosY = nil     	
	self.m_nSpeed = 20                	--行走速度
	self.m_nFrontDirction = 1           --上次行走方向
	self.m_nGuestNum = 0                --宾客数量
	self.m_nTouchFlag = false           --触摸移动位置
	self.m_nWeddingNo = nil             --婚礼编号
	self.m_nWdddingType = nil           --婚礼类型
	self.m_nSendRendNum = nil           --派发红包数量
	self.m_nCurSayIndex = 1             --当前神父说话索引
	self.m_tGuestElement = {}			--宾客动画节点列表
	self.m_tGuestLuaObj = {}			--宾客动画lua表对象列表
	self.m_nLoadingCircleId = nil       --转菊花ID
	self.m_bSendExitFlag = false        --退出婚礼现象标志
	self.m_tData = {}
	self.m_nFirworkTime = nil           --播放烟花时间次数
	self.m_tFirworkElement = {}         --烟花对象表
	self.m_bShowGroomBrige = false      --默认不显示新郎
	self.m_bShowBrige = false     	    --默认不显示新郎
	self.m_nShowCurChatNum = 1          --初始化当前聊天数量 
	self.m_nReshBrigeGroomFlag = false  --刷新新郎新郎标志位
	self.m_bIsMyselfSend = false        --是否自已发送
	self.m_tGuest = {}                  --存放来宾信息(id,名字，装备)
	self.m_bIsMyWedding = false         --是否是当前玩家的婚礼
	self.m_nLoadingTag = nil
	self.m_nRedCountdown = 0            --发红包倒计时
	self.m_nSaluteCountdown = 0         --发礼炮倒计时
	self.m_nBlessingCountdown = 0       --发祝福倒计时
	self.m_nCandiesCountdown = 0        --发喜糖倒计时
	self.m_nOperationTime = nil         --操作时间
	self.m_nSalute = 0                  --记录放礼炮的个数(最多12)
	self.m_sParticleFile = nil
	self.m_nRedPackAndCandiesCountDown = 1
	self.m_nCreateGuestCount = 1
	self.m_nPlayerIndex = nil
	self.m_sHallPass = nil       
	self.m_bShowWeddingPresent = false      --是否正在播放红包动画  
	self.m_bShowWeddingCake = false      --是否正在播放喜糖动画 
	self.m_conMiddle = nil
	self.m_conPrize = nil
	self.m_conCandies = nil
	self.m_bSendRobRedPacket = false
	self.m_bSendRobCandies = false
	self.m_bNowShowSalvo = false           --是否正在放礼炮
	self.m_nPlaySalute = 12
	self.m_oConBottom = nil
	self.m_tAlreadyLoadGuest = {}
	self.m_tRedPacket = {}                  --存放待处理的红包事件
	self.m_tHappinessCandies = {}           --存放待处理的喜糖事件
	self.m_oCurOSN = nil                    --记录当前在播放的红包或者喜糖的schedule节点对象
	self.m_nBackCount = 0
	self.m_nCount = 0
	self.manHeadColour = nil 
	self.womanHeadColour = nil 
	self.manBodyColour = nil 
	self.womanBodyColour = nil 
	self.manFashionId = nil 
	self.womanFashionId = nil 
	self.manHeadId = nil
	self.womanHeadId = nil

	self.m_nTempTag = nil 
	self.m_nOperateType = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneWeddingChurch:_unInit()
	self.m_root = nil
	self.m_nTouchBgPt = nil             --触摸开始位置
	self.m_nFlapX = nil                 --翻转X轴初始为true
	self.m_nPosX = nil                  --
	self.m_nPosY = nil  
	self.m_nSpeed = nil                 --行走速度
	self.m_nFrontDirction = nil         --上次行走方向
	self.m_nGuestNum = nil     
	self.m_nTouchFlag = nil             --触摸移动位置
	self.m_nWeddingNo = nil             --婚礼编号
	self.m_nWdddingType = nil           --婚礼类型
	self.m_nSendRendNum = nil           --派发红包数量
	self.m_nCurSayIndex = nil              --当前神父说话索引
	self.m_tGuestElement = nil			--宾客动画节点列表
	self.m_tGuestLuaObj = nil			--宾客动画lua表对象列表
	self.m_nLoadingCircleId = nil       --转菊花ID
	self.m_bSendExitFlag = false        --退出婚礼现象标志
	self.m_tData = nil 
	self.m_nFirworkTime = nil           --播放烟花时间次数
	self.m_tFirworkElement = nil        --烟花对象表
	self.m_bShowGroomBrige = nil        --显示新郎
	self.m_bShowBrige = nil     	    --显示新郎
	self.m_nShowCurChatNum = nil        --初始化当前聊天数量 
	self.m_nReshBrigeGroomFlag = nil    --刷新新郎新郎标志位
	self.m_bIsMyselfSend = nil          --是否自已发送
	self.m_tGuest = nil
	self.m_bIsMyWedding = nil  
	self.m_nLoadingTag = nil
	self.m_nRedCountdown = nil           
	self.m_nSaluteCountdown = nil        
	self.m_nBlessingCountdown = nil       
	self.m_nCandiesCountdown = nil     
	self.m_nOperationTime = nil  
	self.m_nSalute = nil
	self.m_sParticleFile = nil
	self.m_nRedPackAndCandiesCountDown = nil
	self.m_nCreateGuestCount = nil
	self.m_nPlayerIndex = nil
	self.m_sHallPass = nil    
	self.m_bShowWeddingPresent = nil
	self.m_bShowWeddingCake = nil
	self.m_conMiddle = nil
	self.m_conPrize = nil
	self.m_conCandies = nil
	self.m_bSendRobRedPacket = nil
	self.m_bSendRobCandies = nil
	self.m_nPlaySalute = nil
	self.m_bNowShowSalvo = nil
	self.m_oConBottom = nil
	self.m_tAlreadyLoadGuest = nil
	self.m_tRedPacket = nil
	self.m_tHappinessCandies = nil    
	self.m_oCurOSN = nil 
	self.m_nBackCount = nil
	self.m_nCount = nil
	self.manHeadColour = nil 
	self.womanHeadColour = nil 
	self.manBodyColour = nil 
	self.womanBodyColour = nil 
	self.manFashionId = nil 
	self.womanFashionId = nil 
	self.manHeadId = nil
	self.womanHeadId = nil

	self.m_nTempTag = nil 
	self.m_nOperateType = nil 
end

--@brief  取得显示聊天数量
function SceneWeddingChurch:GetCurChatNum()
	if self.m_root ~= nil then 
		return self.m_nShowCurChatNum
	end 
end 

--@brief  当前显示聊天数量减1
function SceneWeddingChurch:SetShowCurChatNumAdd()
	if self.m_root ~= nil then 
		self.m_nShowCurChatNum = self.m_nShowCurChatNum + 1 
	end 
end 

--@brief  当前显示聊天数量+1
function SceneWeddingChurch:SetShowCurChatNumSub()
	if self.m_root ~= nil then 
		self.m_nShowCurChatNum = self.m_nShowCurChatNum - 1 
	end 
end 



--@brief  设置婚礼编号
--@param  nWeddingNo:婚礼编号
function SceneWeddingChurch:setWeddingNo(nWeddingNo)
	self.m_nWeddingNo = nWeddingNo
end


--@brief  设置婚礼类型
--@param  nWeddingNo:婚礼类型
function SceneWeddingChurch:setWddingType(nWdddingType)
	self.m_nWdddingType = nWdddingType
end


--@brief   创建加载框
function SceneWeddingChurch:createLoading()
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function SceneWeddingChurch:closeLoading()
	if self.m_nLoadingCircleId ~= nil then 
		MsgBoxManager:stopLoadingBoxByMsgId(nId)
	end 
end

--@brief   取得最小最大红包数量 
--@param #1 最小红包数量  
--@param #2 最大红包数量
function SceneWeddingChurch:getMinMaxRewardNum()
	return self.m_tData.rewardLowNum,self.m_tData.rewardHighNum
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneWeddingChurch:createElement()
	local element = WZUISystem:getInstance():createElement("SceneWeddingChurch")
	assert(element, "SceneWeddingChurch create element failed!")
	self:_init()
	return element
end


--@brief	进入婚礼现场（WEDDING_JoinWeddingOk = 23)（服务器返回）
--@param manName : 新郎名称，不在婚礼现场为""
--@param womanName : 新娘名称，不在婚礼现场为""
--@param playerId : 来宾玩家id
--@param playerName : 来宾玩家昵称
--@param playerHeadId : 来宾的头
--@param playerFaceId : 来宾的脸
--@param playerBodyId : 来宾的身
--@param playerWingId : 来宾的翅膀
--@param sex : 来宾性别，true是男，false是女
--@param level : 来宾等级
--@param marryType : 婚礼类型
--@param weddingHallId : 婚礼id
--@param footmark : 足迹
--@brief	进入婚礼现场（WEDDING_JoinWeddingOk = 23)(服务返回)
                                         
function SceneWeddingChurch:JoinWeddingOk(manName, womanName, playerId, playerName, playerHeadId, playerFaceId, playerBodyId, playerWingId, sex, level, marryType, weddingHallId,manFaceId,womanFaceId,hallPass,vipLevel,guestHeadColors,guestBodyColors,manHeadColour,womanHeadColour,manBodyColour,womanBodyColour,manFashionId,womanFashionId,manHeadId,womanHeadId,footmark)
	WZLog("SceneWeddingChurch:JoinWeddingOk =",manBodyColour)
	if SceneRoom ~= nil and (SceneRoom.m_root  or SceneBossRoom.m_root  or WndLeagueTeamDetail.m_root  or SceneBattle.m_root or WndTowerScroll.m_root or SceneWeddingChurch.m_root  or SceneLeagueRoom.m_root or SceneBattleLoading.m_root) then
	   return
	end

	if SceneWeddingChurch.m_root == nil then 
		local sceneWeddingChurch = SceneWeddingChurch:createElement()
		if sceneWeddingChurch ~= nil then 
			replaceScene(sceneWeddingChurch)
		end 
		self.m_root = sceneWeddingChurch
	end 
	GlobalGame.g_MarryPassWord = hallPass
	if hallPass ~= nil and string.len(hallPass) > 0 then
		self.m_sHallPass = hallPass
	end
	self.m_nWdddingType = marryType
	self.m_nWeddingNo = weddingHallId
    
	self.m_tData = {}
	self.m_tData.priestSay = {}
	self.m_tData.manName = manName
	self.m_tData.womanName = womanName
	self.m_tData.bridegroomFaceId = manFaceId
	self.m_tData.brideFaceId =  womanFaceId

	self.manHeadColour = manHeadColour 
	self.womanHeadColour = womanHeadColour 
	self.manBodyColour = manBodyColour 
	self.womanBodyColour = womanBodyColour 
	self.manFashionId = manFashionId 
	self.womanFashionId = womanFashionId 
	self.manHeadId = manHeadId
	self.womanHeadId = womanHeadId

    GlobalGame.g_manName = manName
    GlobalGame.g_womanName = womanName
    
    self.m_tGuest = {}
    for i=1,#playerId do
    	local guestInfo = {}
    	guestInfo.guestId = playerId[i]
    	guestInfo.guestName = playerName[i]
    	guestInfo.guestHeadId = playerHeadId[i]
    	guestInfo.guestFaceId = playerFaceId[i]
    	guestInfo.guestBodyId = playerBodyId[i]
    	guestInfo.guestWingId = playerWingId[i]
    	guestInfo.guestVipLevel = vipLevel[i]
    	guestInfo.guestHeadColor = guestHeadColors[i]
    	guestInfo.guestBodyColor = guestBodyColors[i]
    	guestInfo.sex = sex[i]
    	guestInfo.level = level[i]
    	guestInfo.footmark = footmark[i]
    	table.insert(self.m_tGuest,guestInfo)
    end
   
    --神父说话内容
    local priestSay = LocalStrings.PRIEST_SAY
	for var3 = 1,#priestSay do 
		table.insert(self.m_tData.priestSay,priestSay[var3])
	end

	if self.m_tData.manName == GlobalGame.g_tPlayerInfo.sPlayerName or self.m_tData.womanName == GlobalGame.g_tPlayerInfo.sPlayerName then
       self.m_bIsMyWedding = true
    end
    self.m_bShowGroomBrige = true 
	self.m_bShowBrige = true

	local conWeddingId = GetElement(self.m_root,"conWeddingId_SceneWeddingChurch",WZUIContainer)
	conWeddingId:setVisible(true)
	local txtRoomId = GetElement(conWeddingId,"txtRoomId_SceneWeddingChurch",WZUILabelTTF)
	txtRoomId:setText(LocalStrings.MARRY_ID .. weddingHallId)
end

--@brief  从服务端获取到CD时间
function SceneWeddingChurch:getCDTime(cdType, leaveTime, weddingHallId)
	WZLog("SceneWeddingChurch:getCDTime ")
	for i,v in ipairs(cdType) do
		if v ==1 then
			local lTime = leaveTime[i]
			self.m_nRedCountdown = lTime
			if self.m_nRedCountdown >0 then
				local conRedBag =  WZUIContainer:luaTo(self.m_root:getChildElement("conRedBag_SceneWeddingChurch"))
			    conRedBag:enableSchedule("redBagCallback",1)
				local btnSendRed = WZUIButton:luaTo(self.m_root:getChildElement("btnSendRedBag_SceneWeddingChurch"))
	            local txtRed =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtSendRedPCountdown"))
    	        txtRed:setText(tostring(self.m_nRedCountdown))
    	        btnSendRed:setTouchEnable(false)
			end
		elseif v==2 then
			local lTime = leaveTime[i]
			self.m_nCandiesCountdown = lTime
			if self.m_nCandiesCountdown > 0 then
				local conCandies =  WZUIContainer:luaTo(self.m_root:getChildElement("conCandies_SceneWeddingChurch"))
			    conCandies:enableSchedule("candiesCallback",1)
				local btnSendCandies = WZUIButton:luaTo(self.m_root:getChildElement("btnSendCandies_SceneWeddingChurch"))
	            local txtSendCandies =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtSendCandiesCountdown"))
    	        txtSendCandies:setText(tostring(self.m_nCandiesCountdown))
    	        btnSendCandies:setTouchEnable(false) 
			end
		elseif v==3 then
            local lTime = leaveTime[i]
			self.m_nSaluteCountdown = lTime
			if self.m_nSaluteCountdown > 0 then
				local conCandies =  WZUIContainer:luaTo(self.m_root:getChildElement("conWishBless_SceneWeddingChurch"))
			    conCandies:enableSchedule("saluteCallback",1)
			    local btnWishBless = WZUIButton:luaTo(self.m_root:getChildElement("btnWishBless_SceneWeddingChurch"))
	            local txtSalute =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtSaluteCountdown"))
    	        txtSalute:setText(tostring(self.m_nSaluteCountdown))
    	        btnWishBless:setTouchEnable(false)
			end
		elseif v==4 then
			local lTime = leaveTime[i]
			self.m_nBlessingCountdown = lTime
			if self.m_nBlessingCountdown> 0 then
				local conSBlessing =  WZUIContainer:luaTo(self.m_root:getChildElement("conSBlessing_SceneWeddingChurch"))
			    conSBlessing:enableSchedule("wishCallback",1)
			    local btnSBlessing = WZUIButton:luaTo(self.m_root:getChildElement("btnSBlessing_SceneWeddingChurch"))
			    btnSBlessing:setTouchEnable(false)
			    local txtSendBlessing =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtSendBlessingCountdown"))
			    txtSendBlessing:setText(tostring(self.m_nBlessingCountdown))
			end
		end
	end
end


--@brief	婚礼结束（WEDDING_WeddingOver = 34）(服务器返回)
function SceneWeddingChurch:WeddingOver()
	WZLog("SceneWeddingChurch:WeddingOver()")
	if self.m_root == nil then 
		return 
	end
	self:replaceSceneIsland()
	DelayCallFunction(function ()
		MsgBoxManager:showTipBox(LocalStrings.WEDDING_OVER)
	end,nil,0.5)
end 


--@brief	退出婚礼现场（WEDDING_ExtWeddingOk = 25)
function SceneWeddingChurch:ExtWeddingOk(playerId)
	WZLog("SceneWeddingChurch:ExtWeddingOk",playerId)
	if self.m_root == nil then 
		return 
	end
	if playerId == GlobalGame.g_tPlayerInfo.nPlayerId and self.m_tData.manName ~= GlobalGame.g_tPlayerInfo.sPlayerName and self.m_tData.womanName ~= GlobalGame.g_tPlayerInfo.sPlayerName then
		if not self.m_bSendExitFlag then   --被人踢出婚礼现场
		   MsgBoxManager:showTipBox(LocalStrings.GET_OUT_WEDDING_HALL)
		   self:replaceSceneIsland()
		end
	else  --宾客
		WZLog("-------------************ =",playerId)
		self:removeGuestById(playerId)
	end 
end 

--@brief	切换到主城界面
function SceneWeddingChurch:replaceSceneIsland()
	local sceneCity = SceneCity:createElement()
	if sceneCity ~= nil then 
		replaceScene(sceneCity)
	end 
end

--@brief  返回到婚礼列表里
function SceneWeddingChurch:replaceWeddingList()
	
end

--@brief	刷新礼炮数（WEDDING_PlayerHaveBless = 35）(服务器返回)
function SceneWeddingChurch:PlayerHaveBless(BlessingNum)
	WZLog("SceneWeddingChurch:PlayerHaveBless(BlessingNum)")
	if self.m_root == nil then 
		return 
	end 
	self.m_bIsMyselfSend = true 
	self.m_tData.BlessingNum = BlessingNum -1  --数值需要减一保存，因为购买成功马上播放一次礼炮
	WZUILabelTTF:luaTo(GetElement(self.m_root,"txtBlessNum_SceneWeddingChurch")):setText("(" .. self.m_tData.BlessingNum .. ")")
end 


--@brief	刷新婚礼现场（WEDDING_RefreshWedding = 36）
function SceneWeddingChurch:RefreshWedding(playerId, playerName, playerHeadId, playerFaceId, playerBodyId, playerWingId, sex, level,headColor,bodyColor,footmark)
	WZLog("SceneWeddingChurch:RefreshWedding")
	--如果ID是新郎新娘（显示新郎，显示新郎）
	if  self:_ifBrigeGroomOrBrigeEnter(playerName) then 
		return 
	else
		
		local bExist= false
		for i,v in ipairs(self.m_tGuest) do
			if v.guestId == playerId then
				bExist = true
			end
		end
		if not bExist then
			local guestInfo = {}
			guestInfo.guestId = playerId
			guestInfo.guestName = playerName
			guestInfo.guestHeadId = playerHeadId
			guestInfo.guestFaceId = playerFaceId
			guestInfo.guestBodyId = playerBodyId
			guestInfo.guestWingId = playerWingId
			guestInfo.guestHeadColor = headColor
			guestInfo.guestBodyColor = bodyColor
			guestInfo.sex = sex
			guestInfo.level = level
			guestInfo.footmark = footmark
			table.insert(self.m_tGuest,guestInfo)
			if #self.m_tGuest >=20 then
			    return
		    end
			--设置人物走动
		    self:createGuest(playerId,playerName,sex,playerFaceId,playerHeadId,playerBodyId,headColor,bodyColor,footmark)
		end
	end
end 


--@brief 判断是否是新郎新娘进入
function SceneWeddingChurch:_ifBrigeGroomOrBrigeEnter(sPlayerName)
	WZLog("sPlayerName = ",sPlayerName)
	WZLog("self.m_tData.manName = ",self.m_tData.manName)
	if sPlayerName == self.m_tData.manName or sPlayerName == self.m_tData.womanName then 
		return  true 
	end
	return false 
end 


--@brief	退出婚礼（WEDDING_EXTWedding = 24）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function SceneWeddingChurch:ExitWeddingErrorProcess(nFlag, sMessage)
	self:replaceSceneIsland()
end

--@brief  抢红包、喜糖获得的奖励
function SceneWeddingChurch:RobResult(result,operation,num)
	WZLog("SceneWeddingChurch:RobResult ",result,operation,num)
	if result then
		if operation ==1 then
			MsgBoxManager:showConfirmBox(string.format(LocalStrings.ROB_TRUE_RED,num),nil,nil,nil,nil,true)
		    if self.m_oCurOSN ~= nil then
		    	self:_disableRobRedPacket(self.m_oCurOSN)
		    end
		elseif operation ==2 then
			MsgBoxManager:showConfirmBox(string.format(LocalStrings.ROB_TRUE_CADDIES,num),nil,nil,nil,nil,true)
		    if self.m_oCurOSN ~= nil then
		    	self:_disableRobCandiesPacket(self.m_oCurOSN)
		    end
		   
		end
	else
		if operation ==1 then
			MsgBoxManager:showConfirmBox(LocalStrings.ROB_FALSE,nil,nil,nil,nil,true)
			if  self.m_oCurOSN ~= nil then
				self:_disableRobRedPacket(self.m_oCurOSN)
			end
		elseif operation ==2 then
			MsgBoxManager:showConfirmBox(LocalStrings.CANDIES_FALSE,nil,nil,nil,nil,true)
			if self.m_oCurOSN ~= nil then
				self:_disableRobCandiesPacket(self.m_oCurOSN)
			end
		end
	end
end

function SceneWeddingChurch:resetRobRedOrCandies()
	if self.m_root then
		self.m_bSendRobRedPacket = false
	    self.m_bSendRobCandies = false
	end
end

-------------------------------- ---------------公有方法模块End------------------------------------------------------


-----------------------------------------------私有方法模块Begin---------------------------------------------------

function SceneWeddingChurch:_disableRobRedPacket(element)
	element:disableSchedule()
	element:setVisible(false)
	self.m_nRedPackAndCandiesCountDown = 1
	self.m_bShowWeddingPresent = false
	self.m_bSendRobRedPacket = false
	if self.m_conPrize then		
		self.m_conPrize:removeFromParentAndCleanup(true)
	end
	self.m_conPrize = nil
	self.m_oCurOSN = nil
end

function SceneWeddingChurch:_disableRobCandiesPacket(element)
	element:disableSchedule()
	element:setVisible(false)
	self.m_nRedPackAndCandiesCountDown = 1
	self.m_bShowWeddingCake = false
	self.m_bSendRobCandies = false
	if self.m_conCandies then
		self.m_conCandies:removeFromParentAndCleanup(true)	
	end
	self.m_conCandies = nil
	self.m_oCurOSN = nil
end


--@brief 启动神父说话内容
function SceneWeddingChurch:_startPriestSayWordContent()
	if self.m_root == nil then 
		WZLog("SceneWeddingChurch:_startPriestSayWordConten()")
		return 
	end 
	local spinePriest = WZUISpine:luaTo(GetElement(self.m_root,"spPriest_SceneWeddingChurch"))
	spinePriest:enableSchedule("SchedulePriestWord",6.8)
end 



--@brief	更新神父说话内容
--@param	element:定时器绑定的UI节点引用
--@param	delta:定时器回调间隔
--@note		采用定时器逐帧加载tbconContainer的每一项(或几项)，防止在同一帧中加载太多数据导致的卡顿以及瞬间的内存脉冲
function SceneWeddingChurch:SchedulePriestWord(element,delta)
	--WZLog("SceneWeddingChurch:SchedulePriestWord(element,delta)")
	if element == nil  then 
		element:disableSchedule()
	end 	
	
	if self.m_tData == nil or self.m_tData.priestSay == nil then 
		return 
	end 
	 WZUILabelTTF:luaTo(
	 GetElement(self.m_root,"txtPopPriest_SceneWeddingChurch")):setText(self.m_tData.priestSay[self.m_nCurSayIndex])
	GetElement(self.m_root,"conPopPriest_SceneWeddingChurch"):setVisible(true)
	WZUILabelTTF:luaTo(
		GetElement(self.m_root,"txtPopPriest_SceneWeddingChurch")):enableSchedule("ScheduletxtShowTime",3.8)
	if self.m_nCurSayIndex ~= #self.m_tData.priestSay then 
		self.m_nCurSayIndex = self.m_nCurSayIndex + 1 
	else 
		self.m_nCurSayIndex = 1 
	end 
end 



--@brief	不显示神父说话内容
--@param	element:定时器绑定的UI节点引用
--@param	delta:定时器回调间隔
--@note		采用定时器逐帧加载tbconContainer的每一项(或几项)，防止在同一帧中加载太多数据导致的卡顿以及瞬间的内存脉冲
function SceneWeddingChurch:ScheduletxtShowTime(element,delta)
	--WZLog("SceneWeddingChurch:ScheduletxtShowTime(element,delta)")
	if element == nil  then 
		element:disableSchedule()
	end 	
	GetElement(self.m_root,"conPopPriest_SceneWeddingChurch"):setVisible(false)
	element:disableSchedule()
end 



--@brief	更新新郎说话内容
--@param	element:定时器绑定的UI节点引用
--@param	delta:定时器回调间隔
--@note		采用定时器逐帧加载tbconContainer的每一项(或几项)，防止在同一帧中加载太多数据导致的卡顿以及瞬间的内存脉冲
function SceneWeddingChurch:ScheduleShowBrigeGroomChatTime(element,delta)
	--WZLog("SceneWeddingChurch:ScheduleShowChatTime(element,delta)")
	if element == nil  then 
		element:disableSchedule()
	end 	
	--GetElement(self.m_root,"conPopBrigeGroom_SceneWeddingChurch"):setVisible(false)
	--GetElement(self.m_root,"txtGroomBrigeName_SceneWeddingChurch",WZUILabelTTF):setVisible(true)
	--element:disableSchedule()
end 





--@brief	更新新娘说话内容
--@param	element:定时器绑定的UI节点引用
--@param	delta:定时器回调间隔
--@note		采用定时器逐帧加载tbconContainer的每一项(或几项)，防止在同一帧中加载太多数据导致的卡顿以及瞬间的内存脉冲
function SceneWeddingChurch:ScheduleShowBrigeChatTime(element,delta)
	--WZLog("SceneWeddingChurch:ScheduleShowChatTime(element,delta)")
	if element == nil  then 
		element:disableSchedule()
	end 	
	GetElement(self.m_root,"conPopBrige_SceneWeddingChurch"):setVisible(false)
	GetElement(self.m_root,"txtBrigeName_SceneWeddingChurch",WZUILabelTTF):setVisible(true)
	element:disableSchedule()
end 




----------------------------------------私有方法模块End--------------------------------------------------------
