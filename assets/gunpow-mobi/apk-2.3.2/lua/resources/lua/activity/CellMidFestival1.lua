--CellMidFestival1.lua
--@brief	CellMidFestival1的UI模块
--@date		2021/08/18
--@author	hyx
--@note		中秋活动1


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMidFestival1:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMidFestival1:onExit(element)
	self:_unInit()
	self:unregister()
end
function CellMidFestival1:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
end
function CellMidFestival1:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
end
function CellMidFestival1:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_tActivityData.activityId, 1)
end
function CellMidFestival1:actionCallback()
	local txtActivityTime = GetElement(self.m_root,"txtActivityTime",WZUILabelTTF)
	local startTime = SystemTime:getTimeConverLocal(self.m_tActivityData.startTime)
	local endTime = SystemTime:getTimeConverLocal11(self.m_tActivityData.endTime)
	txtActivityTime:setText(startTime.."-"..endTime)
end
function CellMidFestival1:onBtnGetReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nRewardId then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tActivityData.activityId, self.m_nRewardId)
	end
end
function CellMidFestival1:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
end

function CellMidFestival1:onBtnCheckEquip(element)
	if not self.m_nRewardId then return end
	local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
	local info = CopyTable(GDatatab_item["id_"..taskData.reward[1][1]]) 
	if info then
		local itemInfo = {lastTime=1,lastNum=1,basicInfo=CopyTable(info)}
		WndItemInfo:showInfo(element,self.m_root,1,info,false,nil,true)
	end
end

--@brief 	点击礼包回调
function CellMidFestival1:onBtnCheckGift(element)
	if not self.m_nRewardId then return end
	local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
	local info = CopyTable(GDatatab_item["id_"..taskData.reward[1][1]]) 
	if info then
		local itemInfo = {lastTime=1,lastNum=1,basicInfo=CopyTable(info)}
		WndItemInfo:showInfo(element,self.m_root,1,info,false,nil,true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellMidFestival1:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime)
	WZLog("CellMidFestival1:_onGetTaskInfo 00", self.m_tActivityData.activityId, activityId)
	if self.m_tActivityData.activityId == activityId then
		--按照需求任务每次只会有一条
		self.m_nRewardId = id[1] or 0
		self:setGetButtomState(status[1])
		local txtRichTask = GetElement(self.m_root,"txtRichTask",WZUIFreeTextBox)
		local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
		WZLog("CellMidFestival1:_onGetTaskInfo", self.m_nRewardId)
		if taskData then
			-- taskData.param1 = 9
			local str1 = progress[1].."/"..target[1]
			local str2 = progress[2].."/"..target[2]
			txtRichTask:setShowText(string.format(taskData.desc, str1, str2))
			local _type = tonumber(taskData.param1) or 1
			--1绝版称号 2绝版时装 3限定特效框, 4头像特效框 5翅膀 6资料卡背景 7装备 8礼包 9足迹
			local str_name = {"ui/activity/text_hd_sdj_05.png", "ui/activity/text_hd_sdj_01.png", "ui/activity/text_hd_sdj_06.png", "ui/activity/text_hd_sdj_04.png", "", "", "ui/activity/text_hd_sdj_07.png", "ui/activity/text_hd_sdj_08.png", ""}
			local giftName = ""
			-- if _type == 8 then 
			-- 	local itemId = taskData.reward[1][1]
			-- 	local basicData = GDatatab_item["id_" .. itemId]
			-- 	if basicData then 
			-- 		giftName = basicData.name
			-- 	end
			-- end
			local strTxtName = {"", "", "", "", LocalStrings.NEWFIRSTCHARGE_TEXT1[2], "", "", giftName, LocalStrings.NEWFIRSTCHARGE_TEXT1[4] or ""}
			local imgTitle = GetElement(self.m_root,"imgTitle",WZUIImage)
			-- imgTitle:setFile(str_name[_type])
			imgTitle:setFile("ui/activity/text_hd_sdj_00.png")
			local txtTitle = GetElement(self.m_root, "txtTitle_CellMidFestival1", WZUILabelTTF)
			txtTitle:setText(strTxtName[_type])
			local con = GetElement(self.m_root,"con".._type,WZUIContainer)
			con:setVisible(true)
			self:setContainerType(con, _type)
		end
	end
end
function CellMidFestival1:setContainerType(node, _type)
	if not node then return end
	WZLog("CellMidFestival1:setContainerType", _type, self.m_nRewardId)
	if _type == 1 then
		local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
		if taskData then 
			local itemId = taskData.reward[1][1]
			local basicData = GDatatab_item["id_" .. itemId]
			WZLog("CellMidFestival1:setContainerType", basicData.main_type, basicData.sub_type)
	    	if basicData and basicData.main_type == 14 and basicData.sub_type == 16 then 
	    		local achieData = nil 
	    		for i, value in pairs(GDatatab_achievement) do
	    			local nStart, nEnd = string.find(value.script, tostring(itemId))
	    			if nStart and nEnd then 
	    				achieData = value
	    				break 
	    			end
	    		end
			    
	    		local value = string.match(achieData.name, "%d+")
				local data = {}
				local effectFile = "ui/common_titleframe_" .. value
				data.path = effectFile
				data.play = "size_1"
				data.loop = true
				data.ccp = GlobalMethod:ccp(0.55,0.65)
				createEffectSpine(node,data)
	    	elseif basicData and basicData.main_type == 5 and basicData.sub_type == 3 then 
			end
		end
	elseif _type == 2 then
		local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
		local data = {}
		if taskData then
			local sex = CacheCenter:getPlayerInfo().sex
			for i=1,#taskData.reward do
				local info = GDatatab_item["id_"..taskData.reward[i][1]]
				if info and info.sex == sex then
					table.insert(data, taskData.reward[i][1])
				end
			end
		end
		self:setShowRole(node, data)
	elseif _type == 3 then
		local player_info = CacheCenter:getPlayerInfo()
		GetElement(node,"txt1",WZUILabelTTF):setText(player_info.id)
		local str_guid = ""
		local txt2 = GetElement(node,"txt2",WZUILabelTTF)
		if player_info.guildName == nil or player_info.guildName == "" then
			txt2:setText(LocalStrings.NONE)
		else
			txt2:setText(player_info.guildName)
		end		
		--伴侣
		local txt3 = GetElement(node,"txt3",WZUILabelTTF)
		if player_info.mateName == nil or player_info.mateName == "" then
			txt3:setText(LocalStrings.NONE)
		else
			txt3:setText(player_info.mateName)	
		end
		--服务器
		local txt4 = GetElement(node,"txt4",WZUILabelTTF)
		local serverName = CacheCenter:getServerNameByServerId(player_info.serverId)
		if serverName == nil or serverName == "" then
			serverName = IPDhttpServer:getNameById(player_info.serverId)
		end
		txt4:setText(serverName)
		--特效
		local spineInfoEffect = GetElement(self.m_root, "spineInfoEffect_CellMidFestival1", WZUISpine)
		local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
		if spineInfoEffect and taskData then 
			local itemId = taskData.reward[1][1]
			local basicInfo = GDatatab_item["id_" .. itemId]
			if basicInfo then 
				local effectFile = "ui_checkother_info" .. basicInfo.value
				local existSpine = CheckEffectFile("checkother/" .. effectFile)
				if existSpine then 
					spineInfoEffect:setFileJson("checkother/" .. effectFile .. ".json")
					spineInfoEffect:setFileAtlas("checkother/" .. effectFile .. ".atlas")

					spineInfoEffect:play("wait1", true)

					local nScale = 1
					local nPosX = 0.5
					local nPosY = 0.5
					if basicInfo.power_skill ~= -1 then
						nScale = basicInfo.power_skill[1][1]
						nPosX = basicInfo.power_skill[1][2]
						nPosY = basicInfo.power_skill[1][3]
					end
					spineInfoEffect:setScale(nScale)
					spineInfoEffect:setRelativePosition(GlobalMethod:ccp(nPosX,nPosY))
				end
			end
		end
	elseif _type == 4 then 
		local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
		if taskData then 
			local itemId = taskData.reward[1][1]
			local basicInfo = GDatatab_item["id_" .. itemId]
			if basicInfo then 
				local effectFile = "checkother/ui_playerhead_effect" .. basicInfo.value
				local existSpine = CheckEffectFile(effectFile)
				if existSpine then 
					local data = {}
					data.path = effectFile
					data.play = "wait_2"
					data.loop = true
					data.ccp = GlobalMethod:ccp(0.55,0.65)
					createEffectSpine(node,data)
				else
					local sIndex = string.format("%04d", basicInfo.value)
		            local downloadInfo = GetDownloadInfo(sIndex, "playerhead_effect")
		            if downloadInfo == nil then return end 

		            DownloadManager:addDownloadTask(7000 + tonumber(sIndex),downloadInfo.url,downloadInfo.md5,sIndex,"DownloadResourceCallback", _G)
				end
			end
		end
	elseif _type == 5 then 
		local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
		if taskData then 
			--local itemId = 4999--taskData.reward[1][1]
			local itemId = taskData.reward[1][1]
			local basicData = GDatatab_item["id_" .. itemId]
	    	if basicData and basicData.main_type == 5 and basicData.sub_type == 3 then 
	    		local conPlayer = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, {basicData.id})
	    		conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.54,0))
				conPlayer:setScale(0.92)
		        node:addChild(conPlayer:getAnimNode())
			end
		end
	elseif _type == 6 then 
		local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
		if taskData then 
			local itemId = taskData.reward[1][1]
			local basicData = GDatatab_item["id_" .. itemId]
	    	if basicData and basicData.main_type == 25 and basicData.sub_type == 3 then 
	    		local conBgOne = GetElement(self.m_root, "conBgOne_CellMidFestival1", WZUIContainer)
	    		conBgOne:removeAllChildrenWithCleanup(true)
	    		if node:getChildByTag(66) then 
		    		node:removeChildByTag(66, true)
		    	end
		    	if basicData.animation_index_code == -1 then 
			    	local sFilePath = string.gsub(basicData.icon, "player_bg2", "player_bg")
					local sFileJsonPath = string.gsub(sFilePath, ".png", ".json")
					local bExistSpine = WZFileUtil:isFileExist(sFileJsonPath)
					if bExistSpine then 
						local clipCon = GetElement(self.m_root, "clipCon_CellMidFestival1", WZUIClippingContainer)
		    			local data = {}
		    			local effectFile = string.gsub(sFilePath, ".png", "")
						data.path = effectFile
						data.play = "animation"
						data.loop = true
						data.ccp = GlobalMethod:ccp(0.5,0.5)
		    			local spineBg = createEffectSpine(clipCon, data)
		    			spineBg:setScale(0.25)
		    			spineBg:setTag(66)
			    	else
			    		local imgBg = createImage(sFilePath, GlobalMethod:ccp(0.5,0.5), nil, true, GlobalMethod:ccp(0.5,0.5))
			    		imgBg:setTag(66)
			    		node:addChild(imgBg)
			    	end
			    else
			    	local tTempArray = SplitStringWithSeparator(basicData.animation_index_code, "&")
					for i = 1, #tTempArray do
						local strTemp = tTempArray[i]
						local tConfig = SplitStringWithSeparator(strTemp, ",")
						local nStartIndex, nEndIndex = string.find(tConfig[1], ".png")
						local effectFile = "ui/checkother/" .. tConfig[1]
						if nStartIndex and nEndIndex then 
							local imgTemp = createImage(effectFile, GlobalMethod:ccp(tonumber(tConfig[2]), tonumber(tConfig[3])), nil, true, GlobalMethod:ccp(0.5,0.5))
							conBgOne:addChild(imgTemp)
						else
							local bExistEffect = WZFileUtil:isFileExist(effectFile .. ".json")
							if bExistEffect then 
								local data = {}
								data.path = effectFile
								data.play = tConfig[4]
								data.loop = true
								data.ccp = GlobalMethod:ccp(tonumber(tConfig[2]), tonumber(tConfig[3]))
				    			createEffectSpine(conBgOne, data)
				    		end
						end
					end
			    end
			end
		end
	elseif _type == 7 then
		local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
		if taskData then 
			local itemId = taskData.reward[1][1]
			local basicData = GDatatab_item["id_" .. itemId]
	    	if basicData then 
	    		if node:getChildByTag(77) then 
		    		node:removeChildByTag(77, true)
		    	end

	    		local imgBg = createImage(basicData.icon, GlobalMethod:ccp(0.5,0.5), nil, true, GlobalMethod:ccp(0.5,0.5))
	    		imgBg:setScale(1.2)
	    		imgBg:setTag(77)
	    		node:addChild(imgBg)
			end
		end 
	elseif _type == 8 then
	elseif _type == 9 then 
		WZLog("CellMidFestival1:_onGetTaskInfo 00", self.m_tActivityData.activityId, activityId)
		local conDebris9 = GetElement(self.m_root,"conDebris9",WZUIContainer)
		conDebris9:setVisible(false)

		local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
		if taskData then 
			local itemId = taskData.reward[1][1]
			-- itemId = 12070
			local basicData = GDatatab_item["id_" .. itemId]
			if basicData then
				if basicData.main_type == 23 then
					local conPlayer = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex)
					conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.54,0))
					conPlayer:setScale(0.92)
					node:addChild(conPlayer:getAnimNode())
					if self.m_sFootRoleSpine then
						self.m_sFootRoleSpine:removeFromParentAndCleanup(true)
					end
					local footId = basicData.property[1][1]
					self.m_sFootRoleSpine = FootEffectManager:addEffect1(node,footId,{x=45,y=50},true)
					--FootEffectManager:getInstance():addEffect(basicData.id)
				elseif basicData.main_type == 9 then
					conDebris9:setVisible(true)

					if node:getChildByTag(99) then 
						node:removeChildByTag(99, true)
					end
					local element, tNewObj = CellGoodItem:createElement()
					tNewObj:setCellGoodLocalId(tonumber(taskData.reward[1][1]), tonumber(taskData.reward[1][2]), 17)
					element:setTag(99)
					element:setScale(1.2)
					node:addChild(WZUIContainer:luaTo(element))
				end
			end
		end
	
	end
end
--显示时装人物
function CellMidFestival1:setShowRole(node, data)
	if not node then return end

	local head_index,face_index,body_index
	for i = 1, #data do
		local itemInfo = GDatatab_item["id_" .. data[i]]
		if itemInfo and itemInfo.main_type == 5 then
			if itemInfo.sub_type == 0 then --头部
				head_index = data[i]
			elseif itemInfo.sub_type == 1 then --脸部
				face_index = data[i]
			elseif itemInfo.sub_type == 2 then --衣服
				body_index = data[i]
			end
		end
	end
	local bBoy = CacheCenter:getPlayerInfo().sex == 0
	local roleConPlayer = YDPlayerAnimation:createAnimation(bBoy)
	roleConPlayer:getAnimNode():setTouchEnable(false)
	node:addChild(roleConPlayer:getAnimNode())
	if head_index then
		local head = GDatatab_item["id_"..head_index].animation_index_code
		roleConPlayer:setHead(head)
	end
	if face_index then
		local face = GDatatab_item["id_"..face_index].animation_index_code
		roleConPlayer:setFace(face)
	end
	if body_index then
		local body = GDatatab_item["id_"..body_index].animation_index_code
		roleConPlayer:setBody(body)
	end
	roleConPlayer:play("wait0",true)
end
function CellMidFestival1:setGetButtomState(status)
	local btnGetReward = GetElement(self.m_root,"btnGetReward",WZUIButton)
	local txtGetReward = GetElement(btnGetReward,"txtGetReward",WZUILabelTTF)
	btnGetReward:setVisible(true)
	btnGetReward:setTouchEnable(status == 0)
	if status == -1 or status == 1 then
		txtGetReward:setColor(ccc3(255,255,255))
		if status == 1 then
			txtGetReward:setText(LocalStrings.ACTIVE_GET)
		else
			txtGetReward:setText(LocalStrings.INVITE_RECEIVE)
		end
	elseif status == 0 then
		txtGetReward:setColor(ccc3(114,55,9))
		txtGetReward:setText(LocalStrings.INVITE_RECEIVE)
	end
end
function CellMidFestival1:_onGetTaskResult(activityId, taskId)
	if self.m_tActivityData.activityId == activityId then
		WndMidFestivalActivity:setVisibleTitleRedPoint(false)
		self:setGetButtomState(1)
	end
end

-------------------------------------私有方法模块End----------------------------------------
