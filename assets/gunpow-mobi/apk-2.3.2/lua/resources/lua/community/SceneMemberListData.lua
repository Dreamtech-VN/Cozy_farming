--SceneMemberListData.lua
--@brief	SceneMemberList的数据模块
--@date		2013/12/26
--@author	林庆凯
--@note		成员列表场景

SceneMemberList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneMemberList:_init()
	self.m_root = nil	 	  			 --场景根节点
	self.m_nCurWindowFlag = 0            --当前窗口标记数值   
	self.m_sCurCelName = nil             --点击当前单元格的名字
	self.m_nCurCelId = nil          	 --点击当前单元格的ID
	self.m_tBackSceneLuaObj = nil		 --点击返回按钮返回的场景绑定的Lua表引用
	self.m_nLoadingCircleId = nil        --加载圆圈ID
	self.m_nPageNumber = nil             --当前页
	self.m_nTotalNumber = nil            --总页数
	self.m_bUpPageShowLastPosition = false --向上翻页，显示上一页底部
	self.m_nGuildId = nil
	self.m_sGuildName = nil
	self.m_nPrestige = nil
	self.m_nMembers = nil
	self.m_sDesc = nil
	self.m_nSetting = nil
	self.m_nNewApply = nil
	self.m_nTotemLevel = nil
	self.m_nSchoolLevel = nil
	self.m_nStoreLevel = nil
	self.m_nJob = nil
	self.m_tMemberList = {}              --存取从服务器返回的成员数据的表
	self.m_nTag = nil                    --标记 
	self.m_nCurrentCellIndex = nil       --当前表格元素的值
	self.m_tCellList = nil
	--self.m_nTime = nil					 --当前选中成员离线时间
	self.m_nState = nil
   	self.m_nConListPositionY = nil
	self.m_bFirstEntry = nil
	self.m_tTop = nil
	self.sureBtnState = nil
	self.m_sFind = nil
	self.m_nNoticeStatus = nil 			--公会公告审核字段0、待审核，1、未通过，2、已通过
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneMemberList:_unInit()
	self.m_root = nil
	self.m_nCurWindowFlag = nil 
	self.m_sCurCelName = nil     
	self.m_tBackSceneLuaObj = nil		--点击返回按钮返回的场景绑定的Lua表引用
	self.m_nLoadingCircleId = nil       --加载圆圈ID
	self.m_nPageNumber = nil             --当前页
	self.m_nTotalNumber = nil            --总页数
	self.m_bUpPageShowLastPosition = nil --向上翻页，显示上一页底部
	self.m_nGuildId = nil
	self.m_sGuildName = nil
	self.m_nPrestige = nil
	self.m_nMembers = nil
	self.m_sDesc = nil
	self.m_nSetting = nil
	self.m_nNewApply = nil
	self.m_nTotemLevel = nil
	self.m_nSchoolLevel = nil
	self.m_nStoreLevel = nil
	self.m_nJob = nil
	self.m_tMemberList = nil 
	self.m_nTag = nil                    --标记 
	self.m_tCellList = nil
	--self.m_nTime = nil					 --当前选中成员离线时间
	self.m_nState = nil
   	self.m_nConListPositionY = nil
	self.m_bFirstEntry = nil
	self.m_tTop = nil
	self.sureBtnState = nil
	self.m_sFind = nil
	self.m_nNoticeStatus = nil 			--公会公告审核字段0、待审核，1、未通过，2、已通过
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneMemberList:createElement()
	local element = WZUISystem:getInstance():createElement("SceneMemberList")
	assert(element, "SceneMemberList create element failed!")
	self:_init()
	return element
end

--@brief	设置点击返回按钮返回的场景绑定的Lua表引用
--@param	tLuaObj，场景绑定的Lua表引用
--@note		点击返回按钮后切换到设置的场景，如果tLuaObj设置为nil，则禁用返回按钮
function SceneMemberList:setBackSceneLuaObj(tLuaObj)
	self.m_tBackSceneLuaObj = tLuaObj
end

--设置当前窗口标记数值的函数
--@param  nCurWindowFlag 窗口标记数值，1为自己本身，2为会长让位
function SceneMemberList:setCurWindowFlag(nCurWindowFlag)
	self.m_nCurWindowFlag = nCurWindowFlag
end 

--设置公会ID的函数
--@param  公会ID
function SceneMemberList:setCommonityId(nId)
	self.m_nId = nId 
end 

--返回公会ID的函数
--return  公会ID
function SceneMemberList:getCommonityId()
	return self.m_nId
end 

--@brief	设置自己职位的函数 
--@param  nMyJob  自己职位
function SceneMemberList:setMyJob(nMyJob)
	self.m_nMyJob = nMyJob
end 

--@brief	取得当前单元格的玩家ID函数 
--@return   self.m_nCurCelId  当前单元格的玩家ID
function SceneMemberList:getCurCelPlayerId()
	WZLog("SceneMemberList:getCurCelPlayerId()")
	WLLog("self.m_nCurCelId = ",self.m_nCurCelId)
	
	return self.m_nCurCelId
end 

--@brief	取得当前点击单元格的玩家职位函数 
--@return   nMyJob  自己职位
function SceneMemberList:getCurCelPlayerJob()
	return self.m_nMyJob
end 

--@brief	取得当前点击单元格的玩家职位函数 
--@return   nMyJob  自己职位
function SceneMemberList:setLoadingCircle()
	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
end 

--@brief	取得成员列表客户端接受到服务端发送的好友列表后的数据处理回调方法 
--@param	buyDonate:捐献时间
function SceneMemberList:getCommunityMemberList(guildId, guildName, guildLevel, prestige, members, desc, setting, totemLevel, schoolLevel, storeLevel, newApply, id, headId, faceId, name, level, post, donate, totalDonate, loginTime, isOnline, buyDonate, totemPayTime, sex, weekDonate, lastDonate, allDonate, vipLevel, fireNum, headColor, rmLevel, tournamentLevel, rankMatchLevel, examine, fight, donateTime, declaration, limitDonate, joinVipLevel, guildwarStage, qualification, noticeStatus)
--	WZLog("SceneMemberList:getCommunityMemberList",Serialize(limitDonate),Serialize(faceId),Serialize(sex))
	self.m_nPageNumber = 1             --当前页
	self.m_nTotalNumber = 1           --总页数

	self.m_nGuildId = guildId
	self.m_sGuildName = guildName
	self.m_nGuildLevel = guildLevel
	self.m_nPrestige = prestige
	self.m_nMembers = members
	self.m_sDesc = desc
	self.m_nSetting = setting

	self.m_nTotemLevel = totemLevel
	self.m_nSchoolLevel = schoolLevel
	self.m_nStoreLevel = storeLevel
	self.m_nNewApply = newApply
	self.m_nFireNum = fireNum
	self.m_nLimitDonate = 0
	self.joinVipLevel = joinVipLevel
	self.guildwarStage = guildwarStage
	self.qualification = qualification

	self.m_nNoticeStatus = noticeStatus

	self.m_tMemberList = {}
	for i=1,#id do
		local tempList = {}
		tempList.playerName = name[i]
		tempList.position = post[i]
		tempList.playerContribution = totalDonate[i]
		tempList.onLine = loginTime[i]
		tempList.donateTime = donateTime[i]
		tempList.rank = ""
		tempList.playerId = id[i]
		tempList.playerLevel = level[i]
		tempList.onLineState = isOnline[i]  --1在线，0不在线
		tempList.todayContribution = donate[i]
		tempList.headId = headId[i]
		tempList.faceId = faceId[i]
		tempList.headColor = headColor[i]
		tempList.sex = sex[i]
		tempList.weekDonate = weekDonate[i]
		tempList.lastDonate = lastDonate[i]
		tempList.allDonate = allDonate[i]
		tempList.vipLevel = vipLevel[i]
		tempList.fight = fight[i]
		tempList.zsLevel = -1
		if tostring(id[i]) == tostring(CacheCenter:getPlayerInfo().id) then
			tempList.oneself = 1
			self.m_nLimitDonate = limitDonate[i]
		else
			tempList.oneself = 0
		end
		table.insert(self.m_tMemberList,tempList)
	end

	--for i=1,10 do
	--	local len = #self.m_tMemberList
	--	local tData = self.m_tMemberList[1]
	--	tData.playerId = tData.playerId + i
	--	tData.playerName = tData.playerName..i
	--	table.insert(self.m_tMemberList,tData)
	--end

	table.sort(self.m_tMemberList , _sortMember)
--	self.m_tMemberList = {
--{playerName="玩家1",position=COMMUNITY_PRESIDENT,playerContribution=500,onLine=25,rank=1,playerId=123,playerLevel=55,onLineState="在线",todayContribution=78,zsLevel=-1},
--{playerName="玩家2",position=COMMUNITY_VICE_PRESIDENT,playerContribution=400,onLine=35,rank=2,playerId=223,playerLevel=45,onLineState="在线",todayContribution=68,zsLevel=-1},
--{playerName="玩家3",position=COMMUNITY_ELDER,playerContribution=300,onLine=45,rank=3,playerId=323,playerLevel=35,onLineState="在线",todayContribution=58,zsLevel=-1},
--{playerName="玩家4",position=COMMUNITY_ELITE,playerContribution=200,onLine=55,rank=4,playerId=423,playerLevel=25,onLineState="在线",todayContribution=48,zsLevel=-1},
--{playerName="玩家5",position=COMMUNITY_MEMBER,playerContribution=100,onLine=65,rank=5,playerId=523,playerLevel=15,onLineState="在线",todayContribution=38,zsLevel=-1}}
--
	self:_update()
	self:addDonate()
	--如果查看贡献界面打开，刷新贡献界面
	if WndCommunityCheckDonate and WndCommunityCheckDonate.m_root ~= nil then
		WndCommunityCheckDonate:update()
	end

	--取消圆圈的转动效果
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)
end 

--@brief	成员按职位排序
function _sortMember(a,b)
	--自己排首位
	if a.oneself ~= b.oneself then
		return a.oneself > b.oneself
	--在线
	elseif a.onLineState ~= b.onLineState then
		return a.onLineState >= b.onLineState
	--职位
	elseif a.position ~= b.position then
		return a.position >= b.position
	--等级
	elseif a.playerLevel ~= b.playerLevel then
		return a.playerLevel >= b.playerLevel
	--贡献
	elseif a.todayContribution ~= b.todayContribution then
		return a.todayContribution >= b.todayContribution
	--ID
	else
		return a.playerId < b.playerId
	end
end

--@brief	添加好友成功的从服务器返回的回调方法
--@param	 playerId 添加成功的好友ID
function SceneMemberList:addFriendNew(playerId)
	if  WindowManager:ifSceneActive()  then 
		MsgBoxManager:showTipBox(LocalStrings.FRIEND_ADD_SUCCESS)
	end 
end 

--@brief	升（降）职成功的从服务器返回的回调方法
--@isUp	  true:升职  false:降职
function SceneMemberList:changePositionOk(isUp)
	--刷新成员列表
	ProtocolProcessorSceneCommunity:send_COMMUNITY_GetCommunityMemberListNew(self.m_nId,self.m_nPageNumber)
	if isUp == true then
		MsgBoxManager:showTipBox(self.m_sCurCelName .. LocalStrings.SUCCESS_UP_JOB)
	else 
		MsgBoxManager:showTipBox(self.m_sCurCelName .. LocalStrings.SUCCESS_DOWN_JOB)
	end 
end 

--@brief	开除公会员成功从服务器返回的回调方法
function SceneMemberList:firedMemberOk()
	 WndDismissCommunity:onCloseWindowBtn()
	--显示已被踢出公会
	MsgBoxManager:showTipBox(self.m_sCurCelName .. LocalStrings.ALREADY_REMOVE_COMMUNITY)
	--刷新成员列表
	local currentPage = WndDismissCommunity.m_nCurrentPage
	--WZLog("WndDismissCommunity.m_nCurrentPage",self.m_nPageNumber)
	ProtocolProcessorSceneCommunity:send_COMMUNITY_GetCommunityMemberListNew(self.m_nId,self.m_nPageNumber)
end 

function SceneMemberList:onFightClick(element) 
	SceneCommunityMain:onFightClick()
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------公会设置--------------------------------------
function SceneMemberList:onChangeName() 
	WZLog("SceneMemberList:onChangeName")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if CheckButtonOpen(157) then 
		if tonumber(CacheCenter:getPlayerInfo().position) ~= 4 then --公会改名必须是会长
			local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.CONFIRM}
			MsgBoxManager:showConfirmBox(LocalStrings.YOU_CANT_CHANGE_NAME, self,self.clickSureBack, nil, tCustomUIConfig, true)
			return 
		end

		if CacheCenter:getPlayerItemCountById(101) <= 0 then
			checkIsOnSale(101)
			return
		end

		local tData = CacheCenter:getPlayerItemById(101)
		local element = WndEditBox:createElement()
		WndEditBox:setOkCallBack(WndBag.onApplyRename, WndBag)
		WndEditBox:setOtherData(tData)
		WndEditBox:setData(LocalStrings.INPUT_NEW_NAME, LocalStrings.CLICK_TO_INPUT_NAME)
		WindowManager:addWindow(element, WndEditBox)
	end
end

--@brief	保存按钮回调函数
function SceneMemberList:onSaveClick()
	WZLog("SceneMemberList保存按钮回调函数")
	self:onDeclaration()
end

--@brief	设置保存按钮上的文字
function SceneMemberList:setSaveBtnText(txt)
	for i=1,3 do
		local img = GetElement(self.m_root,"imgSave"..i.."_SceneMemberList",WZUI9Image)
		if txt == LocalStrings.SAVE then
			img:setFile("ui/bag/common_icon_bcz.png")
		else
			img:setFile("ui/bag/common_icon_xf.png")
		end
	end
end

function SceneMemberList:onCheckCall() 
	--self.m_root:disableSchedule()
end

-------------------------------------公会管理板块----------------------------------------
function SceneMemberList:onManage1() 
	WZLog("SceneMemberList:onManage1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:onInvite()
end

function SceneMemberList:onManage2() 
	WZLog("SceneMemberList:onManage2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCommunityRemove:show() 
end

function SceneMemberList:onManage3() 
	WZLog("SceneMemberList:onManage3")
	self:onDonate()
end

function SceneMemberList:onManage4()
	WZLog("SceneMemberList:onManage4")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:onAppoint()
end

function SceneMemberList:onManage5() 
	WZLog("SceneMemberList:onManage5")
	self:onApply()
end

function SceneMemberList:onManage6() 
	WZLog("SceneMemberList:onManage6")
	self:onMail()
end

--@brief 	点击入会限制按钮回调
function SceneMemberList:onManage7(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCommunityLog:showInterface()
end

--@brief	操作日志
function SceneMemberList:onCheckLog1(element)
	WZLog("SceneMemberList:onCheckLog1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorSceneCommunity:send_GUILD_GetOperationLog()
end

--@brief	捐献日志
function SceneMemberList:onCheckLog2(element)
	WZLog("SceneMemberList:onCheckLog2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorSceneCommunity:send_GUILD_GetDonateLog()
end

function SceneMemberList:updateManage()
	ProtocolProcessorSceneCommunity:send_GUILD_GetOperationLog()

	local guildInfo = CacheCenter:getGuildInfo()
	GetElement(self.m_root,"CommunityMember3",WZUILabelTTF):setText(self.m_nMembers.."/"..GDatatab_guild_level["id_"..guildInfo.guildLevel].total)

	GetElement(self.m_root,"btnManage1",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnManage2",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnManage4",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnManage5",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnManage6",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnManage7",WZUIButton):setVisible(false)
	local position = tonumber(CacheCenter:getPlayerInfo().position)	
	if position >= COMMUNITY_VICE_PRESIDENT then
		GetElement(self.m_root,"btnManage1",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnManage2",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnManage4",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnManage5",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnManage6",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnManage7",WZUIButton):setVisible(true)
	elseif position == COMMUNITY_ELDER then
		GetElement(self.m_root,"btnManage4",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnManage5",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnManage6",WZUIButton):setVisible(true)
	end
end

--@brief	保存操作日志
function SceneMemberList:setOperateLog(username, operator, action, level, createTime)
	self.username1 = username
	self.operator1 = operator
	self.action1 = action
	self.level1 = level
	self.createTime1 = createTime

	self:showLog()
end

--@brief	保存捐献日志
function SceneMemberList:setDonateLog(username, costType, cost, reward, createTime)
	self.username2 = username
	self.costType2 = costType
	self.cost2 = cost
	self.reward2 = reward
	self.createTime2 = createTime

	self:showDonateLog()
end

--@brief	显示公会日志
function SceneMemberList:showLog()
	local conForLog = GetElement(self.m_root, "freeconText_SceneMemberList", WZUIFreeListContainer)
	if self.username1 == nil or #self.username1 == 0 then 
		--暂无数据
		ShowPanelNullTip( conForLog)
		return 
	end
	removeShowPanelNullTip(conForLog)

	self:updateOperatorLog()
end

--@brief	显示公会捐献日志
function SceneMemberList:showDonateLog()
	if self.m_root == nil then return end
	local conForLog = GetElement(self.m_root, "freeconText_SceneMemberList", WZUIFreeListContainer)
	conForLog:removeAll()
	if self.username2 == nil or #self.username2 == 0 then 
		--暂无数据
		ShowPanelNullTip( conForLog)
		return 
	end
	removeShowPanelNullTip(conForLog)

	self:updateDonateLog()
end

--@brief	更新公会操作日志
function SceneMemberList:updateOperatorLog()
	local freeListContainer = GetElement(self.m_root,"freeconText_SceneMemberList",WZUIFreeListContainer)
	local position = {["0"] = LocalStrings.NORMAL_COMMUNITY_MEMBER,["1"] = LocalStrings.PICK,
		["2"] = LocalStrings.ELDERS,["3"] = LocalStrings.VICE_PRESIDENT,["4"] = LocalStrings.PRESIDENT}
	if freeListContainer ~= nil then 
		for i = #self.username1,1,-1 do
			local celElement,tFreeCell = CellCommunityInfoList:createElement()
			celElement:setTag(i-1)
			if celElement ~= nil and tFreeCell ~= nil then 
    			local log = ""
				local time = os.date("%m-%d  %H:%M", self.createTime1[i])
					if self.action1[i] == 1 then           
						log = string.format(LocalStrings.COMMUNITYLOG1,self.username1[i])
					elseif self.action1[i] == 3 then         
						if self.level1 ~= nil and self.level1[i] ~= nil then
							log = string.format(LocalStrings.COMMUNITYLOG2,self.operator1[i],self.username1[i],position[tostring(self.level1[i])])
						end
					elseif self.action1[i] == 6 then         
						log = string.format(LocalStrings.COMMUNITYLOG2,self.operator1[i],self.username1[i],position["4"])
					elseif self.action1[i] == 2 then        
						log = string.format(LocalStrings.COMMUNITYLOG3,self.username1[i])
					elseif self.action1[i] == 4 then        
						if self.level1 ~= nil and self.level1[i] ~= nil then
							log = string.format(LocalStrings.COMMUNITYLOG4,self.operator1[i],self.username1[i],position[tostring(self.level1[i])])
						end
					elseif self.action1[i] == 7 then       
						log = string.format(LocalStrings.COMMUNITYLOG5,self.operator1[i],self.level1[i])
					elseif self.action1[i] == 8 then       
						log = string.format(LocalStrings.COMMUNITYLOG10,self.operator1[i],self.level1[i])
					elseif self.action1[i] == 5 then       
						log = string.format(LocalStrings.COMMUNITYLOG7,self.operator1[i],self.username1[i])
					elseif self.action1[i] == 9 then       
						log = string.format(LocalStrings.COMMUNITYLOG11,self.operator1[i],self.level1[i])
					elseif self.action1[i] == 10 then       
						log = string.format(LocalStrings.COMMUNITYLOG6,self.operator1[i],self.level1[i])
					end
--				WZLog("显示日志",log)
				tFreeCell:setLog(log,self.createTime1[i], self.createTime1[i+1])
				celElement = WZUIContainer:luaTo(celElement)
				local freeconSize = freeListContainer:getContentSize()				
				local cellSize = celElement:getAbsContentSize()
				--自由列表只能支持相对大小
				--celElement:setRelativeSize(GlobalMethod:CCSize(cellSize.width/freeconSize.width, cellSize.height/freeconSize.height))
				freeListContainer:pushBack(celElement)
			end 
		end 
	end 
	freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
end

--@brief	更新公会捐献日志
function SceneMemberList:updateDonateLog()
	local freeListContainer = GetElement(self.m_root,"freeconText_SceneMemberList",WZUIFreeListContainer)
	if freeListContainer ~= nil then 
		for i = #self.username2,1,-1 do
			local celElement,tFreeCell = CellCommunityInfoList:createElement()
			if celElement ~= nil and tFreeCell ~= nil then 
    			local log = ""
				local time = os.date("%m-%d %H:%M", self.createTime2[i])
				if self.username2[i] == nil or self.cost2[i] == nil or self.reward2[i] == nil then return end
					if self.costType2[i] == 1 then
						log = string.format(LocalStrings.COMMUNITYLOG8,self.username2[i],self.cost2[i],self.reward2[i])
					else
						log = string.format(LocalStrings.COMMUNITYLOG9,self.username2[i],self.cost2[i],self.reward2[i])
					end
				tFreeCell:setLog(log,self.createTime2[i], self.createTime2[i+1])
				celElement = WZUIContainer:luaTo(celElement)
				local freeconSize = freeListContainer:getContentSize()				
				local cellSize = celElement:getAbsContentSize()
				--自由列表只能支持相对大小
				--celElement:setRelativeSize(GlobalMethod:CCSize(cellSize.width/freeconSize.width, cellSize.height/freeconSize.height))
				freeListContainer:pushBack(celElement)
			end 
		end 
	end 
	freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
end
-------------------------------------私有方法模块End----------------------------------------
