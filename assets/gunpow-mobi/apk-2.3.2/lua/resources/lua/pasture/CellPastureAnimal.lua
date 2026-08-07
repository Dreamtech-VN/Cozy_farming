--CellPastureAnimal.lua
--@brief	CellPastureAnimal的UI模块
--@date		2021/05/14
--@author	hyx
--@note		牧场坐骑


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPastureAnimal:onEnter(element)
	self.m_root = element
	self:register()
end

local aniScale = 0.35 --坐骑缩小的比例
local time_step = 0.01 --时间计步器
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPastureAnimal:onExit(element)
	if self.m_sAniComposeSpine then
		self.m_sAniComposeSpine:removeFromParentAndCleanup(true)
		self.m_sAniComposeSpine = nil
	end
	if self.m_sManegerMaster then
    	self.m_sManegerMaster:removeFromParentAndCleanup(true)
    	self.m_sManegerMaster = nil
    end
	if self.m_sMountStealTimeSchedule then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sMountStealTimeSchedule)
 		self.m_sMountStealTimeSchedule = nil
 	end
 	if self.m_nManagerScheduleTime then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nManagerScheduleTime)
 		self.m_nManagerScheduleTime = nil
 	end
 	if self.m_nPastureAniScheduleId then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nPastureAniScheduleId)
 		self.m_nPastureAniScheduleId = nil
 	end
	self:unregister()
 	self:clearMountData()
	self:_unInit()
end
function CellPastureAnimal:register()
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_GetBaseInfo,self._onGetPastureBaseInfo,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_PastureManage,self._onGetManagerMountResult,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_BuyMount,self._onBuyMountResult,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_MountCompose,self._onPastureComposeResult,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_SellMount,self._onSellMountResult,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_GetFriendPastureList,self._onPastureFriendListInfo,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_MountsProduce,self._onPastureProduceResult,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_StealPastureMounts,self._onPastureStealResult,self)
end
function CellPastureAnimal:unregister()
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_GetBaseInfo,self._onGetPastureBaseInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_PastureManage,self._onGetManagerMountResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_BuyMount,self._onBuyMountResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_MountCompose,self._onPastureComposeResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_SellMount,self._onSellMountResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_GetFriendPastureList,self._onPastureFriendListInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_MountsProduce,self._onPastureProduceResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_StealPastureMounts,self._onPastureStealResult,self)
end

function CellPastureAnimal:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function CellPastureAnimal:actionCallback()
	self:initShow()
	ProtocolProcessorFamily:send_MOUNTSPASTURE_GetPlayerMountsPasture(self.m_nPlayerId)
end
function CellPastureAnimal:initShow()
	self:_addTop()
	self.m_sAniAreaContainer = GetElement(self.m_root,"aniAreaContainer",WZUIContainer)
	GetElement(self.m_root,"txtBtnGotoWorker",WZUILabelTTF):setText(LocalStrings.PASTURE_TEXT6[2])
	self:setMoveAnimalSell(  )
end
function CellPastureAnimal:_addTop()
    local cellTopHand = GetElement(self.m_root,"topContainer",WZUIContainer)
    local cell,tcell = CellTopHandle:createElement()
    cellTopHand:addChild(cell)
    tcell:setTopData("ui/common/txt_common_icon_muc.png",self,self.onCloseClick,true,false,false,"CellPastureAnimal")
end
function CellPastureAnimal:onCloseClick(element)
    WZLog("WndBagMain:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(WndPastureBusiness.m_root, WndPastureBusiness, true)
end
function CellPastureAnimal:onBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   	WndSingleMapDesc:showInterface(LocalStrings.PASTURE_TEXT48)
end
--牧场坐骑跑动逻辑
function CellPastureAnimal:showPastureMount()
	if not self.m_sAniAreaContainer then return end
	doStopAllActions(self.m_sAniAreaContainer)

	for i=1,self.m_nMountNum do
		self:setCreateInitAnimalPosition(i)
	end
	if not self.m_nPastureAniScheduleId then
		self.m_nPastureAniScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
			for i=1, self.m_nMountNum do
				self:createAnimalWork(i)
			end
		end, 3.5, false)
	end

	--允许点击的区域
	local pastureBg = GetElement(self.m_root,"pastureBg",WZUIImage)
	pastureBg:setLuaTouchBeganFunction("touchAniBegan")
	pastureBg:setLuaTouchMovedFunction("touchAniMoved")
	pastureBg:setLuaTouchEndedFunction("touchAniEnded")
	pastureBg:setLuaTouchMoveoutFunction("touchAniMoveout")
end
--创建坐骑
function CellPastureAnimal:createMount(info, start_x, start_y)
	local container = WZUIContainer:create()
	container:setUseAbsSize(true)
	container:setAbsContentSize(GlobalMethod:CCSize(80, 60))
	container:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	container:setTouchEnable(false)
	container:setShowAll(true)
	self.m_sAniAreaContainer:addChild(container,1)

	local pastureMountId = GDatatab_pasture_mounts["id_"..info.mountId].animation_index_code
	local ani = CreateRunMountNoPlayer(pastureMountId, "wait", true)
	container:setAbsPosition(GlobalMethod:ccp(start_x, start_y))
    ani:getAnimNode():setTouchEnable(false)
    ani:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    container:addChild(ani:getAnimNode())
    ani:getAnimNode():setScale(aniScale)

    if info and info.mountBeStolenTime and info.mountBeStolenTime > 0 then
    	local time = WZUILabelTTF:create()
		time:setText(LocalStrings.PASTURE_TEXT50)
		time:setAnchorPoint(ccp(0.5,0))
	    time:setRelativePosition(ccp(0.5,1))
	    time:setColor(ccc3(255,236,193))
		time:setEnableStroke(true)
		time:setStrokeColor(GlobalMethod:ccc3(132,66,29))
		time:setStrokeSize(4)
	    time:setFontSize(20)
	    container:addChild(time,10)
    end

    if info and info.mountStealTime and info.mountStealTime > 0 then
	    local time = WZUILabelTTF:create()
		time:setText(SystemTime:getTimeConverLocal2(info.mountStealTime))
	    time:setAnchorPoint(ccp(0.5,0))
	    time:setRelativePosition(ccp(0.5,1))
	    time:setColor(ccc3(255,236,193))
		time:setEnableStroke(true)
		time:setStrokeColor(GlobalMethod:ccc3(132,66,29))
		time:setStrokeSize(4)
	    time:setFontSize(20)
	    container:addChild(time,10)
	    self.m_tTxtMountStealTime[self.m_nStealIndex] = time
	    self.m_tMountStealTime[self.m_nStealIndex] = info.mountStealTime
	    self.m_tStealMountId[self.m_nStealIndex] = info.playerMountsId

	    self.m_nStealIndex = self.m_nStealIndex + 1
	    if not self.m_sMountStealTimeSchedule then
	    	self.m_sMountStealTimeSchedule = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
	    		for i=1, #self.m_tTxtMountStealTime do
	    			if self.m_tTxtMountStealTime[i] and tolua.isnull(self.m_tTxtMountStealTime[i]) == false then
		    			self.m_tMountStealTime[i] = self.m_tMountStealTime[i] - 1
		    			if self.m_tMountStealTime[i] == 0 then
		    				self.m_tMountStealTime[i] = -1
		    				if self.m_tTxtMountStealTime[i] then
		    					self.m_tTxtMountStealTime[i]:removeFromParentAndCleanup(true)
		    					self.m_tTxtMountStealTime[i] = nil
		    				end
		    				self:setSellMountChange(self.m_tStealMountId[i])
		    			else
			    			if self.m_tTxtMountStealTime[i] then
				    			self.m_tTxtMountStealTime[i]:setText(SystemTime:getTimeConverLocal2(self.m_tMountStealTime[i]))
				    		end
			    		end
			    	end
	    		end
	    	end, 1, false)
	    end
	end

    return container, ani
end
--创建坐骑的时候初始化的位置
function CellPastureAnimal:setCreateInitAnimalPosition(create_pos, init_startX, init_startY)
	if not self.m_sAniAreaContainer then return end
	local width = self.m_sAniAreaContainer:getAbsContentSize().width - 50
	local height = 300
	local start_x = init_startX or math.random(30,width)
	local start_y = init_startY or math.random(20,height)
	local end_x = math.random(200,width)
	local end_y = math.random(20,height)
	local mount_info = self.m_tPastureAnimalId[create_pos]
	self.m_tPlayerMountContainer[create_pos], self.m_tPlayerMount[create_pos] = self:createMount(mount_info, start_x, start_y)
	self.m_tPlayerMountContainer[create_pos]:setName(mount_info.isStealMount..mount_info.mountId..mount_info.mountLevel)
	
	self.m_tCreateCoinContainer[mount_info.playerMountsId] = self.m_tPlayerMountContainer[create_pos]

	self.m_tMountRunORWait[create_pos] = nil
	self.m_tAnimalWalkControl[create_pos] = nil
	--计算轨迹
    local time = 0
    local index = 1
	while time < 1 do
		local pos = self:oneOrderBezier(time, {start_x, start_y}, {end_x, end_y})
		if self.m_tAniPosList[index] and self.m_tAniPosList[index][create_pos] then
			self.m_tAniPosList[index][create_pos].x = pos.x
			self.m_tAniPosList[index][create_pos].y = pos.y
		else
			if self.m_tAniPosList[index] == nil then
				self.m_tAniPosList[index] = {}
			end
			table.insert(self.m_tAniPosList[index], pos)
		end
		index = index + 1
		time = time + time_step
	end
	self:createAnimalWork(create_pos)
	self.m_tMountIndex[create_pos] = 1
end
--曲线坐标计算
function CellPastureAnimal:oneOrderBezier(t, p1, p2)
	local x1, y1 = p1[1], p1[2]
	local x2, y2 = p2[1], p2[2]
	local x = x1 + (x2 - x1) * t
	local y = y1 + (y2 - y1) * t
	return {x = x, y = y}
end
--坐骑行走
function CellPastureAnimal:createAnimalWork(index)
	if not self.m_sAniAreaContainer then return end

	if self.m_tIsStop[index] then return end
	if self.m_bMountAniReplace[index] == nil then
		self.m_bMountAniReplace[index] = true
		--判断哪一只可以走动哪一只原地踏步
		if self.m_nMountNum > 1 then
			if self.m_bIsMountRunOrWait == false then
				self.m_bIsMountRunOrWait = true
			end		
		end
		local num = math.random(1, 10)
		if num >= 5 then
			self.m_tMountRunORWait[index] = true
		end
		self.m_tAnimalWalkControl[index] = nil
		if self.m_sAniAreaContainer then
			self.m_sAniAreaContainer:enableSchedule("updataAnimalPosition", 0.005)
		end
	elseif self.m_bMountAniReplace[index] == true then
		self.m_bIsMountRunOrWait = false
		self.m_tMountRunORWait[index] = nil
		self.m_bMountAniReplace[index] = nil

		self.m_tAnimalWalkControl[index] = nil
		if self.m_sAniAreaContainer then
			self.m_sAniAreaContainer:disableSchedule()
		end
		if self.m_tPlayerMount[index] then
			self.m_tPlayerMount[index]:play("wait", true)
		end
	end
end

function CellPastureAnimal:updataAnimalPosition(element,time)
	for i=1,self.m_nMountNum do
		if self.m_tMountRunORWait[i] == nil then
			if self.m_tAnimalWalkControl[i] == nil then
				self.m_tAnimalWalkControl[i] = true
				if self.m_tPlayerMount[i] then
					self.m_tPlayerMount[i]:play("wait", true)
				end
			end
		else
			if self.m_tMountIndex[i] then
				local index = self.m_tMountIndex[i]
				if self.m_tAniPosList[index+1] and self.m_tAniPosList[index] and self.m_tAniPosList[index][i] then
					if self.m_tAnimalWalkControl[i] == nil then
						self.m_tAnimalWalkControl[i] = true
						if self.m_tPlayerMount[i] then
							self.m_tPlayerMount[i]:play("walk", true)
						end
					end

					local num = self.m_tAniPosList[index+1][i].x - self.m_tAniPosList[index][i].x
					if num < 0 then
						if self.m_tPlayerMount[i] then
							self.m_tPlayerMount[i]:getAnimNode():setFlipX(true)
						end
					else
						if self.m_tPlayerMount[i] then
							self.m_tPlayerMount[i]:getAnimNode():setFlipX(false)
						end
					end
				end

				if self.m_tAniPosList[index] and self.m_tAniPosList[index][i] then
					if self.m_tPlayerMountContainer[i] and tolua.isnull(self.m_tPlayerMountContainer[i]) == false then
						self.m_tPlayerMountContainer[i]:setAbsPosition(GlobalMethod:ccp(self.m_tAniPosList[index][i].x, self.m_tAniPosList[index][i].y))
						self.m_tPlayerMountContainer[i]:setZOrder(1000 - self.m_tAniPosList[index][i].y)
					end
				else
					local start_x = self.m_tAniPosList[self.m_tMountIndex[i]-1][i].x
					local start_y = self.m_tAniPosList[self.m_tMountIndex[i]-1][i].y
					self.m_tMountIndex[i] = 1
					--计算轨迹
				    local time = 0
				    local index = 1
				    local width = self.m_sAniAreaContainer:getAbsContentSize().width - 50
					local height = 300
					local _x = math.random(30,width)
					local _y = math.random(20,height)
					while time < 1 do
						local pos = self:oneOrderBezier(time, {start_x, start_y}, {_x, _y})
						if self.m_tAniPosList[index] then
							self.m_tAniPosList[index][i].x = pos.x
							self.m_tAniPosList[index][i].y = pos.y
						end
						index = index + 1
						time = time + time_step
					end
				end
				self.m_tMountIndex[i] = self.m_tMountIndex[i] + 1
			end
		end
	end
end
function CellPastureAnimal:aniRect(_x,_y,_width,_height)
    return { x = _x, y = _y, width = _width, height = _height }
end
--点与正方形的碰撞
function CellPastureAnimal:rectContainsPoint( rect, point )
    local ret = false
    if (point.x >= rect.x) and (point.x <= rect.x + rect.width) and (point.y >= rect.y) and (point.y <= rect.y + rect.height) then
        ret = true
    end
    return ret
end
function CellPastureAnimal:touchAniBegan(element,point)
	if self.m_bIsMyPastureNotTouch then
		return
	end
	
	self.m_sTouchStealMount = nil
	self.m_nTouchAni = nil
	for i=1, self.m_nMountNum do
		self.m_tIsStop[i] = true
		if self.m_sAniAreaContainer then
			self.m_sAniAreaContainer:disableSchedule()
			if self.m_tPlayerMount[i] then
				self.m_tPlayerMount[i]:play("wait", true)
			end
		end
	end
	for i=1, self.m_nMountNum do
		if self.m_tPlayerMountContainer[i] then
			local point1 = self.m_tPlayerMountContainer[i]:convertToWorldSpace(GlobalMethod:ccp(0,0))
			local rect = self:aniRect(point1.x,point1.y,self.m_tPlayerMountContainer[i]:getContentSize().width, self.m_tPlayerMountContainer[i]:getContentSize().height)
			local _bool = self:rectContainsPoint(rect, ccp(point.x, point.y))
			if _bool == true then
				self.m_nTouchAni = i
				local temp_point = self.m_sAniAreaContainer:convertToNodeSpace(GlobalMethod:ccp(point.x,point.y))
				self.m_nTouchPosX = temp_point.x
				self.m_nTouchPosY = temp_point.y
				self:setMoveAnimalSell( true )
				break
			end
		end
	end
	if self.m_tPastureAnimalId[self.m_nTouchAni] and self.m_tPastureAnimalId[self.m_nTouchAni].mountStealTime and self.m_tPastureAnimalId[self.m_nTouchAni].mountStealTime > 0 then
		self.m_sTouchStealMount = true
		self:setMoveAnimalSell(  )
		return
	end
	self.m_nTouchStartX = point.x
	self.m_nTouchStartY = point.y
	self.m_isAnimalMoved = nil

	--合成的时候不是同一类都隐藏
	if self.m_nTouchAni then
		local target_name = self.m_tPlayerMountContainer[self.m_nTouchAni]:getName()
		for i=1,self.m_nMountNum do
			if i ~= self.m_nTouchAni then
				if self.m_tPlayerMountContainer[i] and self.m_tPlayerMountContainer[i]:getName() ~= target_name then
					self.m_tPlayerMountContainer[i]:setVisible(false)
				end
			end
		end
	end
end
function CellPastureAnimal:touchAniMoved(element,point)
	if self.m_sTouchStealMount then return end

	if self.m_bIsMyPastureNotTouch then
		return
	end
	if not self.m_isAnimalMoved and self.m_nTouchStartX and self.m_nTouchStartY then
		if (point.x - self.m_nTouchStartX) > 5 or (point.y - self.m_nTouchStartY) > 5 then
			return
		end
	end
	
	self.m_isAnimalMoved = true
	if self.m_nTouchAni and self.m_tPlayerMountContainer[self.m_nTouchAni] then
		local point1 = self.m_sAniAreaContainer:convertToNodeSpace(GlobalMethod:ccp(point.x,point.y))
		self.m_tPlayerMountContainer[self.m_nTouchAni]:setAbsPosition(GlobalMethod:ccp(point1.x, point1.y))
	end
end
-- --正方形与正方形的碰撞
function CellPastureAnimal:rectIntersectsRect( rect1, rect2 )
    local intersect = not ( rect1.x > rect2.x + rect2.width  or rect1.x + rect1.width  < rect2.x or
                    		rect1.y > rect2.y + rect2.height or rect1.y + rect1.height < rect2.y )
    return intersect
end
function CellPastureAnimal:touchAniEnded(element,point)
	if self.m_sTouchStealMount then return end

	if self.m_bIsMyPastureNotTouch then
		return
	end
	self:setMoveAnimalSell(  )
	if self.m_nTouchAni and self.m_tPlayerMountContainer[self.m_nTouchAni] then
		local point1 = self.m_sAniAreaContainer:convertToNodeSpace(GlobalMethod:ccp(point.x,point.y))
		local width_scale = self.m_tPlayerMountContainer[self.m_nTouchAni]:getContentSize().width
		local height_scale = self.m_tPlayerMountContainer[self.m_nTouchAni]:getContentSize().height
		
		self.m_nComposeEndPosX = point1.x
		self.m_nComposeEndPosY = point1.y
		local isResetOriginal = nil --是否从移到最后的位置开始行走
		--出售的时候
		local rect_2 = self:aniRect(point1.x, point1.y, width_scale, height_scale)
		local rect_steal = self:aniRect(207,-15, 100, 100)
		local rect_status = self:rectIntersectsRect( rect_steal, rect_2 )
		if rect_status == true then
			isResetOriginal = true
			local info = GDatatab_pasture_mounts["id_"..self.m_tPastureAnimalId[self.m_nTouchAni].mountId].recycleMess
			local tabItem = GDatatab_item["id_"..info[1][1]]
			local str = string.format(LocalStrings.PASTURE_TEXT38,tabItem.icon, info[1][2])
			MsgBoxManager:showConfirmBox(str, self, function()
				ProtocolProcessorFamily:send_MOUNTSPASTURE_SellPastureMounts(self.m_tPastureAnimalId[self.m_nTouchAni].playerMountsId)
			end,nil,nil,nil,nil,nil,function()
				if self.m_nTouchPosX and self.m_nTouchPosY and self.m_tPlayerMountContainer[self.m_nTouchAni] then
					self.m_tPlayerMountContainer[self.m_nTouchAni]:setAbsPosition(GlobalMethod:ccp(self.m_nTouchPosX, self.m_nTouchPosY))
					self:setMoveAnimalSell(  )
				end
			end)
		end
		--判断碰撞
		for i=1,self.m_nMountNum do
			if i ~= self.m_nTouchAni then
				--不动的坐骑
				if self.m_tPlayerMountContainer[i] then
					local rect_1 = self:aniRect(self.m_tPlayerMountContainer[i]:getAbsPosition().x,self.m_tPlayerMountContainer[i]:getAbsPosition().y, width_scale, height_scale)
					local rect_state = self:rectIntersectsRect( rect_1, rect_2 )
					--相同坐骑合并升级的时候
					if self.m_tPastureAnimalId[i] and self.m_tPastureAnimalId[i].mountStealTime and self.m_tPastureAnimalId[i].mountStealTime > 0 then
						-- -偷来的坐骑
					else
						if rect_state == true and self.m_tPlayerMountContainer[self.m_nTouchAni]:getName() == self.m_tPlayerMountContainer[i]:getName() then 
							local mount_info = self.m_tPastureAnimalId[i]
							if mount_info then
								-- 被偷中的坐骑不能合成
								if mount_info.mountBeStolenTime and mount_info.mountBeStolenTime > 0 or self.m_tPastureAnimalId[self.m_nTouchAni].mountBeStolenTime and self.m_tPastureAnimalId[self.m_nTouchAni].mountBeStolenTime > 0 then
									MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT_1)
									break
								end
								-- 固定住的  拖动的那个
								ProtocolProcessorFamily:send_MOUNTSPASTURE_PastureMountsUpgrade(mount_info.playerMountsId, self.m_tPastureAnimalId[self.m_nTouchAni].playerMountsId)
								isResetOriginal = true
							end
							break
						end
					end
				end
			end
		end
		
		if isResetOriginal == nil then
			self.m_tMountRunORWait[self.m_nTouchAni] = nil
			--计算轨迹
		    local time = 0
		    local index = 1
			local _x = math.random(30, self.m_sAniAreaContainer:getAbsContentSize().width - 50)
			local _y = math.random(20, 300)
			while time < 1 do
				local pos = self:oneOrderBezier(time, {point1.x, point1.y}, {_x, _y})
				if self.m_tAniPosList[index] then
					self.m_tAniPosList[index][self.m_nTouchAni].x = pos.x
					self.m_tAniPosList[index][self.m_nTouchAni].y = pos.y
				end
				index = index + 1
				time = time + time_step
			end
			self.m_tMountIndex[self.m_nTouchAni] = 1
		end
	end
	self.m_isAnimalMoved = nil
	for i=1, self.m_nMountNum do
		self.m_tIsStop[i] = nil
		if self.m_tPlayerMountContainer[i] then
			self.m_tPlayerMountContainer[i]:setVisible(true)
		end
	end
end

function CellPastureAnimal:touchAniMoveout()
	if self.m_sTouchStealMount then return end
	if self.m_bIsMyPastureNotTouch then
		return
	end
	self:cancelMountCompose()
end
function CellPastureAnimal:cancelMountCompose()
	self:setMoveAnimalSell(  )
	for i=1, self.m_nMountNum do
		self.m_tIsStop[i] = nil
		if self.m_tPlayerMountContainer[i] then
			self.m_tPlayerMountContainer[i]:setVisible(true)
		end
	end
	if self.m_nTouchPosX and self.m_nTouchPosY and self.m_tPlayerMountContainer[self.m_nTouchAni] and self.m_isAnimalMoved then
		self.m_tPlayerMountContainer[self.m_nTouchAni]:setAbsPosition(GlobalMethod:ccp(self.m_nTouchPosX, self.m_nTouchPosY))
	end
	self.m_isAnimalMoved = nil
end

--拖动时候会判断是否是出售坐骑
function CellPastureAnimal:setMoveAnimalSell( status )
	if not self.m_root then return end
	local btnBuy = GetElement(self.m_root,"btnBuy",WZUIButton)
	local imgBtnBuy = GetElement(btnBuy,"imgBtnBuy",WZUIImage)
	local txtBtnBuyName = GetElement(btnBuy,"txtBtnBuyName",WZUILabelTTF)
	status = status or nil
	--出售的时候
	if status == true then
		txtBtnBuyName:setText(LocalStrings.PASTURE_TEXT12)
		imgBtnBuy:setFile("ui/family/other/pasture/Icon_common_mc_cszq.png")
	else
		txtBtnBuyName:setText(LocalStrings.ATH_SHOP)
		imgBtnBuy:setFile("ui/family/other/pasture/Icon_common_mc_gmzq.png")
	end
end

--偷盗
function CellPastureAnimal:onBtnSteal()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if next(self.m_tPastureAnimalId) == nil then
		MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT51)
		return
	end
	if self.m_nStealPlayerId then
		ProtocolProcessorFamily:send_MOUNTSPASTURE_StealPastureMounts(self.m_nStealPlayerId)
	end
end
function CellPastureAnimal:onBtnBuy()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPastureShop:showInterface()
end
--收集
function CellPastureAnimal:onBtnCollect()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPastureMount:showInterface() 
end
--偷盗日记
function CellPastureAnimal:onBtnLog()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPastureLog:showInterface()
end
--工人
function CellPastureAnimal:onBtnWorker()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local info = self:getBasePastureInfo()
	if info and info.level then
		local data = GDatatab_pastureland["id_"..info.level]
		if data then
			local item_info = GDatatab_item["id_"..data.workerprice[1][1]]
			local str = string.format(LocalStrings.PASTURE_TEXT16,data.workeraddition[1][1].."%",data.workeraddition[1][2].."%",data.workerprice[1][2],item_info.name)
			MsgBoxManager:showConfirmBox(str, self, function() 
				if CacheCenter:getPlayerItemCountById(data.workerprice[1][1]) < data.workerprice[1][2] then
					MsgBoxManager:showConfirmBox(LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, self,self.clickSureMoney)
				else
					ProtocolProcessorFamily:send_MOUNTSPASTURE_ManageMountsPastureland()
				end
			end)
		end
	end
end
--@brief	点击确定充值回调
function CellPastureAnimal:clickSureMoney()
	PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep2, Chat_Channel_Guild_Shop)
	PassportSdkManager:gotoPaymentPage()
end
-- 快速购买的时候
function CellPastureAnimal:setQuickStatus()
	local imgQuickPic = GetElement(self.m_root,"imgQuickPic",WZUIImage)
	local txtQuickPrice = GetElement(self.m_root,"txtQuickPrice",WZUIFreeTextBox)
	local max_lev = self.m_nMountMaxLevel - 3
	if max_lev <= 0 then
		max_lev = 1
	end
	--如果牧场存在比快速购买低级的动物时候
	local level = self:getPastureLevel()
	local lev_info = WndPastureBusiness:getPastureLevelExp(level)
	local status = false
	if lev_info then
		if (self.m_nHasMountNum-self.m_nStealMountNum) >= lev_info.num then
			status = true
		end
	end
	if status == true then
		local temp_level = 1
		for i,v in pairs(self.m_tMountLevelData) do
			if v.mountStealTime == 0 and v.mountLevel > temp_level then
				temp_level = v.mountLevel
			end
		end
		if max_lev > temp_level then
			max_lev = temp_level
		end
	end	
	local info = GDatatab_pasture_mounts["id_"..max_lev]
	if info then
		local mountId = info.animation_index_code
		local nItemId = GDatatab_mounts["id_".. mountId].item_id
		local tItemData = GetItemLocalData(nItemId)
		imgQuickPic:setFile(tItemData.icon)

		local item_info = GDatatab_item["id_"..info.price[1][1]]
		if item_info then
			txtQuickPrice:setShowText(string.format([[<I Z="0.5">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]],item_info.icon,info.price[1][2]))
		end
	end
end
function CellPastureAnimal:onBtnQuickBuy()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local level = self:getPastureLevel()
	local lev_info = WndPastureBusiness:getPastureLevelExp(level)
	if lev_info then
		if (self.m_nHasMountNum-self.m_nStealMountNum) >= lev_info.num then
			self:setQuickBuy(true)
			return
		end
	end
	self:setQuickBuy()
end
function CellPastureAnimal:setQuickBuy(is_quick)
	is_quick = is_quick or nil
	local max_lev = self.m_nMountMaxLevel - 3
	if max_lev <= 0 then
		max_lev = 1
	end
	local temp_max_lev = max_lev
	local temp_level = 100
	if is_quick == true then
		--如果牧场存在比快速购买低级的动物时候
		for i,v in pairs(self.m_tMountLevelData) do
			if v.mountStealTime == 0 and temp_level > v.mountLevel then
				temp_level = v.mountLevel
			end
		end
		temp_max_lev = temp_level
		if max_lev > temp_level then
			temp_max_lev = temp_level
		end
		self.m_sIsQuickBuyMount = true
	end
	if is_quick and temp_level > max_lev then
		MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT59)
		return
	end
	local info = GDatatab_pasture_mounts["id_"..temp_max_lev]
	if info then
		local itemCount = WndPastureBusiness:getCoinNumber()
		if itemCount >= info.price[1][2] then
			ProtocolProcessorFamily:send_MOUNTSPASTURE_PurchasePastureMounts(info.id)
		else
			WndFastGetItems:show(info.price[1][1], info.price[1][2])
		end
	end
end
--判断进入他人界面是按钮的显示
function CellPastureAnimal:setBtnOthersPasture(visible)
	if not self.m_root then return end
	GetElement(self.m_root,"btnSteal",WZUIButton):setVisible(not visible)
	GetElement(self.m_root,"btnBuy",WZUIButton):setVisible(visible)
	GetElement(self.m_root,"btnWorker",WZUIButton):setVisible(visible)
	GetElement(self.m_root,"btnCollect",WZUIButton):setVisible(visible)
	GetElement(self.m_root,"btnLog",WZUIButton):setVisible(visible)
	GetElement(self.m_root,"btnGotoPasture",WZUIButton):setVisible(not visible)
	GetElement(self.m_root,"btnQuickBuy",WZUIButton):setVisible(visible)
	local btnGotoWorker = GetElement(self.m_root,"btnGotoWorker",WZUIButton)
	if visible == true then
		btnGotoWorker:setRelativePosition(GlobalMethod:ccp(0.525,0.085))
	else
		btnGotoWorker:setRelativePosition(GlobalMethod:ccp(0.26,0.085))
	end
end
function CellPastureAnimal:onBtnGotoPasture()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_sMountStealTimeSchedule then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sMountStealTimeSchedule)
 		self.m_sMountStealTimeSchedule = nil
 	end
 	if self.m_tTxtMountStealTime then
	 	for i,v in pairs(self.m_tTxtMountStealTime) do
		 	if v then
				v:removeFromParentAndCleanup(true)
				v = nil
			end
		end
	end
	self.m_tTxtMountStealTime = {}
	self:clearMountData()
	self.m_tCreateMinCoinData = {}
	ProtocolProcessorFamily:send_MOUNTSPASTURE_GetPlayerMountsPasture(CacheCenter:getPlayerInfo().id)
end
--好友牧场
function CellPastureAnimal:onBtnFriendPasture()
	if not self.m_root then return end

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local friendListContainer = GetElement(self.m_root,"friendListContainer",WZUIContainer)
	self:setPastureListAction()
	if self.m_tBtnFriendTitle[1] == nil then
		self:setFriendListBtn()
	end 
	if friendListContainer:isVisible() == true then
		ProtocolProcessorFamily:send_MOUNTSPASTURE_GetPlayerPastureFriendList(CacheCenter:getPlayerInfo().id)
	end
end
function CellPastureAnimal:onBtnGotoWorker()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--进入他人牧场不能进入工坊
	local m_bOther = self:setIsOtherPasture()
	if m_bOther and m_bOther == true then
		MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT27)
		return
	end

	WndPastureBusiness:createWorker()
end
--好友牧场列表出来动作
function CellPastureAnimal:setPastureListAction()
	if not self.m_root then return end

	self.m_tOpenTitleFriendView = {}
	local temp_friendListContainer = GetElement(self.m_root,"temp_friendListContainer",WZUIContainer)
	local friendListContainer = GetElement(self.m_root,"friendListContainer",WZUIContainer)
	if not friendListContainer then 
		return
	end
	if friendListContainer:isVisible() == false then
		friendListContainer:setVisible(true)
		temp_friendListContainer:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	else
		friendListContainer:setVisible(false)
		temp_friendListContainer:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	end
	temp_friendListContainer:setRelativePosition(GlobalMethod:ccp(1,0.45))
end
--
function CellPastureAnimal:setFriendListBtn()
	for i=1,2 do
		local tab = {}
		local btn = GetElement(self.m_root,"friendBtn"..i,WZUIButton)
		tab.normal = GetElement(btn,"normal",WZUI9Image)
		tab.select = GetElement(btn,"select",WZUI9Image)
		tab.name = GetElement(btn,"name",WZUILabelTTF)
		tab.name:setColor(GlobalMethod:ccc3(127,70,26))
		self.m_tBtnFriendTitle[i] = tab
	end
	self.m_nCurFriendIndex = 1
	self.m_tBtnFriendTitle[self.m_nCurFriendIndex].normal:setVisible(false)
	self.m_tBtnFriendTitle[self.m_nCurFriendIndex].select:setVisible(true)
	self.m_tBtnFriendTitle[self.m_nCurFriendIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
	self.m_tBtnFriendTitle[self.m_nCurFriendIndex].name:setEnableStroke(true)
	self.m_tBtnFriendTitle[self.m_nCurFriendIndex].name:setStrokeSize(4)
	self.m_tBtnFriendTitle[self.m_nCurFriendIndex].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
end
function CellPastureAnimal:onBtnFriendTitle(element)
	local tag = element:getTag()
	if self.m_nCurFriendIndex == tag then return end

	if self.m_tBtnFriendTitle[self.m_nCurFriendIndex] then
		self.m_tBtnFriendTitle[self.m_nCurFriendIndex].normal:setVisible(true)
		self.m_tBtnFriendTitle[self.m_nCurFriendIndex].select:setVisible(false)
		self.m_tBtnFriendTitle[self.m_nCurFriendIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
		self.m_tBtnFriendTitle[self.m_nCurFriendIndex].name:setEnableStroke(false)
	end
	if self.m_tBtnFriendTitle[tag] then
		self.m_tBtnFriendTitle[tag].normal:setVisible(false)
		self.m_tBtnFriendTitle[tag].select:setVisible(true)
		self.m_tBtnFriendTitle[tag].name:setColor(GlobalMethod:ccc3(255,236,193))
		self.m_tBtnFriendTitle[tag].name:setEnableStroke(true)
		self.m_tBtnFriendTitle[tag].name:setStrokeSize(4)
		self.m_tBtnFriendTitle[tag].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
	end
	GetElement(self.m_root,"friendList1",WZUIFreeListContainer):setVisible(tag == 1)
	GetElement(self.m_root,"friendList2",WZUIFreeListContainer):setVisible(tag == 2)
	self.m_nCurFriendIndex = tag
	if self.m_tOpenTitleFriendView[2] == nil then
		self.m_tOpenTitleFriendView[2] = true
		local friendList2 = GetElement(self.m_root,"friendList2",WZUIFreeListContainer)
		friendList2:removeAll()
		for i=1, #self.m_tStealFriendData do
			local element, tLuaObj = CellPastureFriendItem:createElement()
			friendList2:pushBack(WZUIContainer:luaTo(element))
			friendList2:getMoveElement():setPositionY(friendList2:getMinPosition().y)
			tLuaObj:setBaseFriendData(i, self.m_tStealFriendData[i], false)
		end
	end
end

function CellPastureAnimal:clearMountData()
	self.m_tPastureAnimalId = {}
	self.m_nBuyMountCount = 0
	self.m_tMountLevelData = {}
	self.m_tAniPosList = {}
	self.m_tMountIndex = {}
	self.m_bIsMountRunOrWait = false
	self.m_tIsStop = {}
	self.m_bMountAniReplace = {}

	if self.m_sAniAreaContainer then
		doStopAllActions(self.m_sAniAreaContainer)
		self.m_sAniAreaContainer:disableSchedule()
	end
	if self.m_tPlayerMountContainer then
		for i,v in pairs(self.m_tPlayerMountContainer) do
			if v then
				v:removeFromParentAndCleanup(true)
				v = nil
			end
		end
	end
	self.m_tPlayerMountContainer = {}
	if self.m_tPlayerMount then
		for i,v in pairs(self.m_tPlayerMount) do
			if v then
				v:removeFromParentAndCleanup(true)
				v = nil
			end
		end
	end
	self.m_tPlayerMount = {}
	self.m_tMountRunORWait = {}
end

function CellPastureAnimal:updatePastureItemData(coinNum)
	if self.m_root then
		coinNum = coinNum or WndPastureBusiness:getCoinNumber()
		local txtPastureItemNum = GetElement(self.m_root,"txtPastureItemNum",WZUIFreeTextBox)
		local tabItem = GDatatab_item["id_97"]
		if tabItem then
			local totle_num = 0
			for i,v in pairs(self.m_tCreateMinCoinData) do
				if v and v.mountId then
					local info = GDatatab_pasture_mounts["id_"..v.mountId] 
					if info then
						totle_num = totle_num + info.output[1][2]
					end
				end
			end
			txtPastureItemNum:setShowText(string.format([[<I Z="0.5">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d  +%d/10%s</T>]],tabItem.icon, coinNum, totle_num, LocalStrings.SECOND))
		end
		WndPastureShop:setChangeCoin(coinNum)
	end
end
--经验条与等级
function CellPastureAnimal:setPastureLevelORExp( exp, level )
	if not self.m_root then return end

	GetElement(self.m_root,"txtLev",WZUILabelTTF):setText("Lv."..level)
	local expProgress = GetElement(self.m_root,"expProgress",WZUIProgress)
	local txtProgress = GetElement(self.m_root,"txtProgress",WZUILabelTTF)

	self:setChangeMount( )
	local lev_info = WndPastureBusiness:getPastureLevelExp(level+1)
	if lev_info then
		txtProgress:setText(exp.."/"..lev_info.exp)
		expProgress:setPercentage(exp / lev_info.exp * 100)
	else --最大等级
		txtProgress:setText("Max")
		expProgress:setPercentage(100)
	end	
end
--坐骑数量
function CellPastureAnimal:setChangeMount( )
	if not self.m_root then return end
	local level = self:getPastureLevel()
	local lev_info = WndPastureBusiness:getPastureLevelExp(level)
	if lev_info then
		if self.m_nHasMountNum <= 0 then
			self.m_nHasMountNum = 0
		end
		local txtPastureItemNum1 = GetElement(self.m_root,"txtPastureItemNum1",WZUIFreeTextBox)
		txtPastureItemNum1:setShowText(string.format([[<I Z="0.5">shopitems/horse_0001.png</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d/%d</T>]],self.m_nHasMountNum - self.m_nStealMountNum, lev_info.num))
		WndPastureShop:setChangeMountNum(self.m_nHasMountNum,lev_info.num)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--牧场基本信息
function CellPastureAnimal:_onGetPastureBaseInfo(playerId, playerName, level, exp, playerMountsId, mountIds, mountsLevel, mountStealTime, mountBeStolenTime, serverId, 
	slotNum, beStolenCount, stealCount, isInManage, manageRemainTime, coins, propsCream, maxMountsLevel)
	if not self.m_root then return end
	self.m_nStealMountNum = 0
	if self.m_nPastureAniScheduleId then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nPastureAniScheduleId)
 		self.m_nPastureAniScheduleId = nil
 	end
 	if self.m_sMountStealTimeSchedule then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_sMountStealTimeSchedule)
 		self.m_sMountStealTimeSchedule = nil
 	end
 	for i,v in pairs(self.m_tTxtMountStealTime) do
	 	if v then
			v:removeFromParentAndCleanup(true)
			v = nil
		end
	end
	self.m_tTxtMountStealTime = {}

	self.m_nMountNum = #mountIds
	GetElement(self.m_root,"txtName",WZUILabelTTF):setText(playerName)
	self.m_nInitPastureExp = exp
	self:setPastureLevelORExp( exp, level )

	local txtPastureItemNum = GetElement(self.m_root,"txtPastureItemNum",WZUIFreeTextBox)
	local txtPastureItemNum1 = GetElement(self.m_root,"txtPastureItemNum1",WZUIFreeTextBox)
	--本人的时候
	if CacheCenter:getPlayerInfo().id == playerId then
		self.m_bIsMyPastureNotTouch = nil
		txtPastureItemNum:setVisible(true)
		txtPastureItemNum1:setVisible(true)
		self:setBtnOthersPasture(true)
		self:setPastureLevel(level)
		local data = {}
		data.level = level
		data.name = playerName
		data.cur_exp = exp
		self:setBasePastureInfo(data)		
	else --进入他人的牧场
		txtPastureItemNum:setVisible(false)
		txtPastureItemNum1:setVisible(false)
		self:setBtnOthersPasture(false)
		self:clearMountData()
		self.m_nStealPlayerId = playerId
		self.m_bIsMyPastureNotTouch = true
	end
	for i=1,#mountIds do
		local temp_lev = {}
		temp_lev.playerMountsId = playerMountsId[i]
		temp_lev.mountLevel = mountsLevel[i]
		temp_lev.mountId = mountIds[i]
		temp_lev.mountStealTime = mountStealTime[i] --偷来的
		self.m_tMountLevelData[i] = temp_lev

		local tab = {}
		tab.playerMountsId = playerMountsId[i]
		tab.mountId = mountIds[i]
		tab.mountLevel = mountsLevel[i]

		tab.serverId = serverId[i]
		tab.mountStealTime = mountStealTime[i] --偷来的
		tab.isStealMount = "_false"
		if tab.mountStealTime > 0 then
			tab.isStealMount = "_true"
			self.m_nStealMountNum = self.m_nStealMountNum + 1
		end
		tab.mountBeStolenTime = mountBeStolenTime[i]
		self.m_tPastureAnimalId[i] = tab
		self.m_nBuyMountCount = self.m_nBuyMountCount + 1
	end
	for i=1,#mountIds do
		local tab = {}
		tab.playerMountsId = playerMountsId[i]
		tab.mountId = mountIds[i]
		self.m_tCreateMinCoinData[i] = tab
	end

	self.m_nHasMountNum = GetTableLen(self.m_tMountLevelData)
	self:setChangeMount( )
	self:updatePastureItemData(coins)
	WndPastureBusiness:setCoinNumber(coins)
	WndPastureBusiness:setWorkerNumber(propsCream)
	self.m_nMountMaxLevel = maxMountsLevel
	self:setQuickStatus()
	self:showPastureMount()

	if self.m_sManegerMaster then
		self.m_sManegerMaster:setVisible(false)
	end
	if self.m_txtManagerTime then
		self.m_txtManagerTime:setVisible(false)
	end
	if isInManage == 1 then
		self:createWorkeMaster(manageRemainTime)
	end
end

--购买坐骑返回
function CellPastureAnimal:_onBuyMountResult(mountId, playerMountsId, serverId)
	MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_SUCCESS)
	local temp_level = nil
	local temp_playerMountsId = nil
	for i,v in pairs(self.m_tMountLevelData) do
		if v.mountStealTime == 0 and v.mountId == mountId then
			temp_level = v.mountLevel
			temp_playerMountsId = v.playerMountsId
			break
		end
	end
	local temp_lev = {}
	temp_lev.playerMountsId = playerMountsId
	temp_lev.mountLevel = GDatatab_pasture_mounts["id_"..mountId].level
	temp_lev.mountId = mountId
	temp_lev.mountStealTime = 0
	table.insert(self.m_tMountLevelData,temp_lev)

	local quick_compase = nil
	if temp_level then
		local max_lev = self.m_nMountMaxLevel - 3
		if max_lev <= 0 then
			max_lev = 1
		end
		if self.m_sIsQuickBuyMount and temp_level <= max_lev then
			quick_compase = true
		end
	end
	self.m_nHasMountNum = self.m_nHasMountNum + 1
	if quick_compase == true and self.m_sIsQuickBuyMount == true then
		-- 固定住的  拖动的那个
		local compose_index = nil
		for i = 1, #self.m_tPastureAnimalId do
			if self.m_tPastureAnimalId[i] and self.m_tPastureAnimalId[i].playerMountsId == temp_playerMountsId then
				compose_index = i
				break
			end
		end
		if compose_index and self.m_tAniPosList[1][compose_index] then
			self.m_nComposeEndPosX = self.m_tAniPosList[1][compose_index].x
			self.m_nComposeEndPosY = self.m_tAniPosList[1][compose_index].y
		else
			self.m_nComposeEndPosX = math.random(30, self.m_sAniAreaContainer:getAbsContentSize().width - 50)
			self.m_nComposeEndPosY = math.random(20, 300)
		end
		ProtocolProcessorFamily:send_MOUNTSPASTURE_PastureMountsUpgrade(temp_playerMountsId, playerMountsId)
	else
		self:setChangeMount( )
		local tab = {}
		tab.playerMountsId = playerMountsId
		tab.mountId = mountId
		tab.mountLevel = GDatatab_pasture_mounts["id_"..mountId].level
		tab.serverId = serverId
		tab.mountStealTime = 0
		tab.isStealMount = "_false"
		table.insert(self.m_tPastureAnimalId, tab)

		local tab = {}
		tab.playerMountsId = playerMountsId
		tab.mountId = mountId
		table.insert(self.m_tCreateMinCoinData, tab)

		self.m_nMountNum = #self.m_tPastureAnimalId
		self.m_nBuyMountCount = self.m_nBuyMountCount + 1
		for i=1,self.m_nMountNum do
			self.m_tAnimalWalkControl[i] = nil
			self.m_tMountRunORWait[i] = nil
		end
		self:setCreateInitAnimalPosition(self.m_nBuyMountCount)
	end
	self:setQuickStatus()
	self.m_sIsQuickBuyMount = nil
end

--好友牧场
function CellPastureAnimal:_onPastureFriendListInfo(playerId, name, sex, isOnline, vipLevel, pastureLevel, faceItemId, headItemId, headColor, beStolenCount, isThief, stoleTime, canSteal, serverId)
	local data = self:setFriendPastureData(playerId, name, sex, isOnline, vipLevel, pastureLevel, faceItemId, headItemId, headColor,beStolenCount, isThief, stoleTime, canSteal, serverId)

	self.m_tFriendPastureData = data
	local friendList1 = GetElement(self.m_root,"friendList1",WZUIFreeListContainer)
	friendList1:removeAll()
	for i=1, #data do
		local element, tLuaObj = CellPastureFriendItem:createElement()
		friendList1:pushBack(WZUIContainer:luaTo(element))
		friendList1:getMoveElement():setPositionY(friendList1:getMinPosition().y)
		tLuaObj:setBaseFriendData(i, data[i], true)
		tLuaObj:setCallFunc(function()
			self:setPastureListAction()
		end)
	end
end

--管理牧场，工人模式
function CellPastureAnimal:_onGetManagerMountResult(manageRemainTime)
	--添加工人
	self:createWorkeMaster(manageRemainTime)
end
function CellPastureAnimal:createWorkeMaster(managerTime)
	if self.m_sManegerMaster then
		self.m_sManegerMaster:setVisible(true)
		self.m_nManagerTime = managerTime
		if self.m_txtManagerTime then
			self.m_txtManagerTime:setVisible(true)
		end
		return
	end

	local lev = self:getPastureLevel()
	local info = WndPastureBusiness:getPastureLevelExp(lev)
	if not info then return end

	local worker_con = GetElement(self.m_root,"worker_con",WZUIContainer)
	if worker_con:getChildByTag(88) then
        worker_con:removeChildByTag(88, true)
    end
    local guai = WMonster:buildGuai(info.guai_id)
    guai:getShopAnimation():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    guai:getShopAnimation():setUseAbsCoordinate(true)
    guai:getShopAnimation():play("wait", true)
    guai:getShopAnimation():setScale(1)
    worker_con:addChild(guai:getShopAnimation(), 0, 88)
    self.m_sManegerMaster = guai:getShopAnimation()
    local time = WZUILabelTTF:create()
    self.m_txtManagerTime = time
    if managerTime then
	   self.m_nManagerTime = managerTime
	else
		self.m_nManagerTime = info.keepduration
	end
	time:setText(SystemTime:getTimeConverLocal2(self.m_nManagerTime))
    time:setAnchorPoint(ccp(0.5,0))
    time:setRelativePosition(ccp(0,1))
    time:setColor(ccc3(255,236,193))
    time:setFontSize(22)
    time:setEnableStroke(true)
    time:setStrokeColor(ccc3(132,66,29))
    time:setStrokeSize(4)

    worker_con:addChild(time,100)
    if not self.m_nManagerScheduleTime then
		self.m_nManagerScheduleTime = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
			self.m_nManagerTime = self.m_nManagerTime - 1
			if self.m_nManagerTime < 0 then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nManagerScheduleTime)
 				self.m_nManagerScheduleTime = nil
				local worker_con = GetElement(self.m_root,"worker_con",WZUIContainer)
				if worker_con:getChildByTag(88) then
			        worker_con:removeChildByTag(88, true)
			    end
			    if self.m_txtManagerTime then
			    	self.m_txtManagerTime:removeFromParentAndCleanup(true)
			    	self.m_txtManagerTime = nil
			    end
			    if self.m_sManegerMaster then
			    	self.m_sManegerMaster:removeFromParentAndCleanup(true)
			    	self.m_sManegerMaster = nil
			    end
			else
				if self.m_txtManagerTime and tolua.isnull(self.m_txtManagerTime) == false then
					self.m_txtManagerTime:setText(SystemTime:getTimeConverLocal2(self.m_nManagerTime))
				end
			end
		end, 1, false)
	end
end

--坐骑合成
function CellPastureAnimal:_onPastureComposeResult(mountId, playerMountsId, level, consumeId, serverId)
	--被消耗的坐骑 consumeId 不属于坐骑表的id，是一个服里面唯一的id
	--playerMountsId  留下的id
	-- mountId 牧场坐骑表的id
	MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT18)
	if mountId > self.m_nMountMaxLevel then
		WndRewardShow:showPastureInterface(mountId)
	end
	for i,v in pairs(self.m_tCreateMinCoinData) do
		if v and v.playerMountsId == consumeId then
			self.m_tCreateMinCoinData[i] = nil
			break
		end
	end

	for i = #self.m_tMountLevelData,1,-1 do
		if self.m_tMountLevelData[i] and self.m_tMountLevelData[i].playerMountsId == consumeId then
			table.remove(self.m_tMountLevelData, i)
			break
		end
	end

	for i = #self.m_tPastureAnimalId,1,-1 do
		if self.m_tPastureAnimalId[i] and consumeId == self.m_tPastureAnimalId[i].playerMountsId then
				if self.m_tPlayerMountContainer[i] then
				self.m_tPlayerMountContainer[i]:removeFromParentAndCleanup(true)
				self.m_tPlayerMountContainer[i] = nil
			end
			if self.m_tPlayerMount[i] then
				self.m_tPlayerMount[i]:removeFromParentAndCleanup(true)
				self.m_tPlayerMount[i] = nil
			end
		else
			if self.m_tPlayerMountContainer[i] then
				self.m_tPlayerMountContainer[i]:setVisible(true)
			end
		end
	end
	for i=1,self.m_nMountNum do
		self.m_tAnimalWalkControl[i] = nil
		self.m_tIsStop[i] = nil
		self.m_bMountAniReplace[i] = nil
		self.m_tMountRunORWait[i] = nil
	end

	for i,v in pairs(self.m_tCreateMinCoinData) do
		if v and v.playerMountsId == playerMountsId then
			self.m_tCreateMinCoinData[i].mountId = mountId
			break
		end
	end
	self:updatePastureItemData()

	local lev_index -- 合成之后处理的id
	local temp_level = 1
	for i=1,#self.m_tPastureAnimalId do
		if self.m_tPastureAnimalId[i] and self.m_tPastureAnimalId[i].playerMountsId == playerMountsId then
			self.m_tPastureAnimalId[i].mountId = mountId
			self.m_tPastureAnimalId[i].mountLevel = self.m_tPastureAnimalId[i].mountLevel + 1
			if self.m_tPlayerMountContainer[i] then
				self.m_tPlayerMountContainer[i]:removeFromParentAndCleanup(true)
				self.m_tPlayerMountContainer[i] = nil
			end
			if self.m_tPlayerMount[i] then
				self.m_tPlayerMount[i]:removeFromParentAndCleanup(true)
				self.m_tPlayerMount[i] = nil
			end
			temp_level = self.m_tPastureAnimalId[i].mountLevel
			lev_index = i
			break
		end
	end
	for i,v in pairs(self.m_tMountLevelData) do
		if v.playerMountsId == playerMountsId then
			v.playerMountsId = playerMountsId
			v.mountId = mountId
			v.mountLevel = temp_level
			break
		end
	end

	if lev_index then
		self:setCreateInitAnimalPosition(lev_index, self.m_nComposeEndPosX, self.m_nComposeEndPosY)

		if self.m_nComposeEndPosX then
			local aniSpineContainer = GetElement(self.m_root,"aniSpineContainer",WZUIContainer)
			if self.m_sAniComposeSpine then
				self.m_sAniComposeSpine:removeFromParentAndCleanup(true)
				self.m_sAniComposeSpine = nil
			end
			SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
			self.m_sAniComposeSpine = WZUISpine:create()
			self.m_sAniComposeSpine:setTouchEnable(false)
			self.m_sAniComposeSpine:setFileJson("battle/skill/skill_baozha_sd.json")
			self.m_sAniComposeSpine:setFileAtlas("battle/skill/skill_baozha_sd.atlas")
			self.m_sAniComposeSpine:play("animation", false)
			self.m_sAniComposeSpine:setUseAbsCoordinate(true)
			self.m_sAniComposeSpine:setAnchorPoint(ccp(0.5,0))
			self.m_sAniComposeSpine:setAbsPosition(GlobalMethod:ccp(self.m_nComposeEndPosX, self.m_nComposeEndPosY))
			aniSpineContainer:addChild(self.m_sAniComposeSpine)
		end
	end
	--合成的时候在最大值
	local nComposeMaxLevel = 1
	local temp_max = self.m_nMountMaxLevel
	for i,v in pairs(self.m_tMountLevelData) do
		if v and v.mountLevel > nComposeMaxLevel and v.mountStealTime == 0 then
			nComposeMaxLevel = v.mountLevel
		end
	end
	if nComposeMaxLevel > temp_max then
	else
		nComposeMaxLevel = temp_max
	end
	self.m_nMountMaxLevel = nComposeMaxLevel
	self.m_nHasMountNum = self.m_nHasMountNum - 1
	self:setQuickStatus()
	self:setChangeMount( )
end
--偷取坐骑
function CellPastureAnimal:_onPastureStealResult(targetId, mountsId)
	local name = ""
	for i,v in pairs(self.m_tFriendPastureData) do
		if v.playerId == targetId then
			name = v.name
			break
		end
	end
	local info = GDatatab_pasture_mounts["id_"..mountsId]
	local str = string.format(LocalStrings.PASTURE_TEXT49,name,mountsId,info.name)
	MsgBoxManager:showTipBox(str)

	for i = #self.m_tPastureAnimalId,1,-1 do
		if self.m_tPastureAnimalId[i] and mountsId == self.m_tPastureAnimalId[i].mountId then
			for m = #self.m_tMountLevelData,1,-1 do
				if self.m_tMountLevelData[i] and self.m_tMountLevelData[i].mountId == mountsId then
					table.remove(self.m_tMountLevelData, i)
					break
				end
			end
			local time = WZUILabelTTF:create()
			time:setText(LocalStrings.PASTURE_TEXT50)
			time:setAnchorPoint(ccp(0.5,0))
		    time:setRelativePosition(ccp(0.5,1))
		    time:setColor(ccc3(255,236,193))
			time:setEnableStroke(true)
			time:setStrokeColor(GlobalMethod:ccc3(132,66,29))
			time:setStrokeSize(4)
		    time:setFontSize(20)
		    self.m_tPlayerMountContainer[i]:addChild(time,10)

			self.m_tIsStop[i] = nil
			self.m_bMountAniReplace[i] = nil
			self.m_tMountRunORWait[i] = nil
			break
		end
	end
end
--出售坐骑
function CellPastureAnimal:_onSellMountResult(mountsId)
	MsgBoxManager:showTipBox(LocalStrings.SALE_SUCCESS)
	self:setMoveAnimalSell(  )

	for i,v in pairs(self.m_tCreateMinCoinData) do
		if v and v.playerMountsId == mountsId then
			self.m_tCreateMinCoinData[i] = nil
			break
		end
	end
	self:updatePastureItemData()
	
	self:setSellMountChange(mountsId)
	self.m_tCreateCoinContainer[mountsId] = nil
end

--出售坐骑
function CellPastureAnimal:setSellMountChange(mountsId)
	self.m_bIsMountRunOrWait = false
	for i = #self.m_tPastureAnimalId,1,-1 do
		if self.m_tPastureAnimalId[i] and mountsId == self.m_tPastureAnimalId[i].playerMountsId then
			for m = #self.m_tMountLevelData,1,-1 do
				if self.m_tMountLevelData[i] and self.m_tMountLevelData[i].playerMountsId == mountsId then
					table.remove(self.m_tMountLevelData, i)
					break
				end
			end
			if self.m_tPlayerMountContainer[i] then
				self.m_tPlayerMountContainer[i]:removeFromParentAndCleanup(true)
				self.m_tPlayerMountContainer[i] = nil
			end
			if self.m_tPlayerMount[i] then
				self.m_tPlayerMount[i]:removeFromParentAndCleanup(true)
				self.m_tPlayerMount[i] = nil
			end
		else
			if self.m_tPlayerMountContainer[i] then
				self.m_tPlayerMountContainer[i]:setVisible(true)
			end
		end
		self.m_tIsStop[i] = nil
		self.m_bMountAniReplace[i] = nil
		self.m_tMountRunORWait[i] = nil
	end
	self.m_nMountNum = self.m_nBuyMountCount
	self.m_nHasMountNum = self.m_nHasMountNum - 1
	self:setQuickStatus()
	self:setChangeMount( )
end

function CellPastureAnimal:_onPastureProduceResult(mountsId, pastureCoin, propsCream, exp)
	if self.m_bIsMyPastureNotTouch then
		return
	end
	for i=1, #exp do
		self.m_nInitPastureExp = self.m_nInitPastureExp + exp[i]
	end
	local level = WndPastureBusiness:getPastureLevel()
	self:setPastureLevelORExp( self.m_nInitPastureExp, level )

	local data = {}
	data.level = level
	data.name = self:getBasePastureInfo().name
	data.cur_exp = self.m_nInitPastureExp
	self:setBasePastureInfo(data)
	WndPastureBusiness:setWorkerBaseInfo( )
	
	self:runActionCoin(pastureCoin, propsCream, exp)
end
--牧场币、道具精华的特效
function CellPastureAnimal:runActionCoin(pastureCoin, propsCream, exp)
	if next(pastureCoin) == nil then return end

	local totle_coin, totle_cream, totle_exp = 0,0,0
	for i=1,#pastureCoin do
		totle_coin = totle_coin + pastureCoin[i]
		totle_cream = totle_cream + propsCream[i]
		totle_exp = totle_exp + exp[i]
	end	
	local node = self:createGetItem()

	local txtCoin = WZUIFreeTextBox:create()
	txtCoin:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
	txtCoin:setMaxWidth(200)
	node:addChild(txtCoin)

	local tabItem = GDatatab_item["id_97"]
	local str = string.format([[<I Z="0.5">%s</I><T C="255,236,193" S="26" P="1" SC="132,66,29" SS="4" SE="1"> +%d</T>]],tabItem.icon, totle_coin)
	txtCoin:setShowText(str)

	local time = 0.3
	local array = CCArray:create()
	local move =  CCMoveTo:create(time, GlobalMethod:ccp(1136*0.5, 380))
	local actionTo = CCScaleTo:create(0.6, 0)
	array:addObject(move)
	array:addObject(actionTo)
	local action1 = CCSpawn:create(array)
	array:addObject(action1)

	--精华
	array:addObject(CCCallFunc:create(function()
		node:setScale(1)
		node:setAbsPosition(GlobalMethod:ccp(1136*0.5, 320))
		local tabItem = GDatatab_item["id_99"]
		local str = string.format([[<I Z="0.5">%s</I><T C="255,236,193" S="26" P="1" SC="132,66,29" SS="4" SE="1"> +%d</T>]],tabItem.icon, totle_cream)
		txtCoin:setShowText(str)
	end))
	local move1 =  CCMoveTo:create(time, GlobalMethod:ccp(1136*0.5, 380))
	local actionTo1 = CCScaleTo:create(0.6, 0)
	array:addObject(move1)
	array:addObject(actionTo1)
	local action1_1 = CCSpawn:create(array)
	array:addObject(action1_1)

	--经验
	array:addObject(CCCallFunc:create(function()
		node:setScale(1)
		node:setAbsPosition(GlobalMethod:ccp(1136*0.5, 320))
		local tabItem = GDatatab_item["id_3"]
		local str = string.format([[<I Z="0.5">%s</I><T C="255,236,193" S="26" P="1" SC="132,66,29" SS="4" SE="1"> +%d</T>]],tabItem.icon, totle_exp)
		txtCoin:setShowText(str)
	end))
	local move2 =  CCMoveTo:create(time, GlobalMethod:ccp(1136*0.5, 380))
	local actionTo2 = CCScaleTo:create(0.6, 0)
	array:addObject(move2)
	array:addObject(actionTo2)
	local action1_2 = CCSpawn:create(array)
	array:addObject(action1_2)

	local seq = CCSequence:create(array)
	node:runAction(seq)
end
function CellPastureAnimal:createGetItem()
	if not self.m_root then return end

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
	element:setUseAbsCoordinate(true)
	element:setAbsContentSize(GlobalMethod:CCSize(208,40))
	element:setAbsPosition(GlobalMethod:ccp(1136*0.5, 320))
	self.m_root:addChild(element)

	local image = WZUI9Image:create()
	image:setFile("ui/common/common_01.png")
	element:addChild(image)

	return element
end
-------------------------------------私有方法模块End----------------------------------------
