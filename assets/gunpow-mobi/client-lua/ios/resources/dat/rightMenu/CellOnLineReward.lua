--CellOnLineReward.lua
--@brief	CellOnLineReward的UI模块
--@date		2016/07/20
--@author	maopeiting
--@note		在线奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellOnLineReward:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function CellOnLineReward:onEnterTransitionDidFinish(  )
	ProtocolProcessorWndOnLineReward:regAll()
	ProtocolProcessorWndOnLineReward:send_ONLINEREWARD_GetOnlineMes()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellOnLineReward:onExit(element)
	self:_unInit()
	ProtocolProcessorWndOnLineReward:unregAll()
end

--@brief	倒计时定时器
function CellOnLineReward:scheduleUpdateRaffleTime( element )
	local txt = GetElement(CellOnLineReward.m_current.m_root,"txt_CellOnLineReward",WZUILabelTTF)
	local txtTime = GetElement(CellOnLineReward.m_current.m_root,"txtTime_CellOnLineReward",WZUILabelTTF)
	local txt1 = GetElement(CellOnLineReward.m_current.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	local txt2 = GetElement(CellOnLineReward.m_current.m_root,"txt2_CellOnLineReward",WZUILabelTTF)
	
	self.leaveTime = self.leaveTime -1
	if self.leaveTime <= 0 then
		element:disableSchedule()
		txt1:setRelativePosition(GlobalMethod:ccp(0.2,0.5))

		txt:setVisible(false) --后领取奖励

		local time = self:formatTime(self.time)
		txtTime:setText(time)

		txt1:setText(LocalStrings.HAD_ONLINE)
		
		txt2:setVisible(true)	 --请领取奖励
		txt2:setText(LocalStrings.ONLINE_REWRAD)
		--WZLog("---111111111111111--",self.id,self.rewardList[self.id+1].id)
		if self.id == 0 then
			self.rewardList[1]:setUpdateData(0)
			self.id = self.id + 1
		elseif self.id < self.length then
			self.rewardList[self.id+1]:setUpdateData(0)
			self.id = self.id + 1
		end
		-- if #self.rewardId <= 0 then
		-- 	self.rewardList[1]:setUpdateData(0)
		-- 	if self.id == 0 then
		-- 		self.id = self.id + 1
		-- 	end
		-- else
		-- 	if self.id < self.length then
		-- 		self.rewardList[self.id+1]:setUpdateData(0)
		-- 		self.id = self.id + 1
		-- 	end
		-- end
	else
		txt1:setRelativePosition(GlobalMethod:ccp(0.02,0.5))
		txt2:setVisible(false) --请领取奖励

		txt1:setText(LocalStrings.CONTINUE_ONLINE)
		local time = self:formatTime(self.leaveTime)

    	txtTime:setText(time)

		txt:setVisible(true)
	end
end

--@brief	设置奖励列表
function CellOnLineReward:_setRewardsList(  )
	local tab = GetElement(CellOnLineReward.m_current.m_root,"tab_CellOnLineReward",WZUITableContainer)
	tab:cleanTable()
	self.id = 0
	self.rewardList = {}
	for i = 1, #self.reward do
		local celElement,tCell = CellOnlineRewardItem:createElement()
		if celElement ~= nil then
			celElement = WZUIContainer:luaTo(celElement)
			if self.reward[i].time - self.OnlineTime <= 0 then
				WZLog("---#########111--")
				local count = 0
				if #self.rewardId > 0 then
					for j=1,#self.rewardId do
						if self.reward[i].id == self.rewardId[j] then
							WZLog("---#########333--")
							tCell:setData(self.reward[i],2) --0:可领取，1:不可领取,2:已领取
							break
						else
							--WZLog("---#########444--",self.reward[i].id,self.rewardId[j])
							count = count + 1 
						end
					end
					if count == #self.rewardId then
						tCell:setData(self.reward[i],0)
					end
					self.id = self.id + 1
				else
					tCell:setData(self.reward[i],0)
					self.id = self.id + 1
				end
			else
				WZLog("---#########222--")
				tCell:setData(self.reward[i],1)
			end
			celElement:setTag(i - 1)
			tab:setCellElement(celElement)
			table.insert(self.rewardList,tCell)
		end
	end
	--WZLog("---*****--11",Serialize(self.rewardList))
	local function sort(v1,v2)
		return tonumber(v1.id) < tonumber(v2.id)
	end
	table.sort(self.rewardList,sort)
	tab:getMoveElement():setPositionY(tab:getMinPosition().y)

	self:_showTime()
end

function CellOnLineReward:_showTime(  )
	WZLog("----&&&&&&&&&&&111--",#self.rewardId,self.length)
	local txtTime = GetElement(CellOnLineReward.m_current.m_root,"txtTime_CellOnLineReward",WZUILabelTTF)
	local txt = GetElement(CellOnLineReward.m_current.m_root,"txt_CellOnLineReward",WZUILabelTTF)
	local txt1 = GetElement(CellOnLineReward.m_current.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	local txt2 = GetElement(CellOnLineReward.m_current.m_root,"txt2_CellOnLineReward",WZUILabelTTF)

	-- if #self.rewardId <= 0 then
	-- 	self.time = GDatatab_online_reward["id_1"].time
	-- else
	if #self.rewardId == self.length then
		txt1:setText(LocalStrings.ONLINE_REWARD_RECEVICED)
		txtTime:setVisible(false)
		txt2:setVisible(false)
		txt:setVisible(false)
		return
	else
		if self.id <= 0 then --奖励都不可领取的状态下
			self.time = self.m_tRewardData[1].time
		elseif self.id == #self.rewardId then --奖励都已经领取完的状态下
			self.time = self.m_tRewardData[self.id+1].time
		elseif self.id > #self.rewardId then --奖励未领取完的状态下
			self.time = self.m_tRewardData[self.id].time
		end
	end
	
	self.leaveTime = self.time -self.OnlineTime
	if self.leaveTime <= 0 then
		if self.id == 0 then
			self.rewardList[1]:setUpdateData(0)
			self.id = self.id + 1
		elseif self.id == #self.rewardId then
			self.rewardList[self.id+1]:setUpdateData(0)
			self.id = self.id + 1
		end
		-- if #self.rewardId <= 0 then
		-- 	self.rewardList[1]:setUpdateData(0)
		-- 	if self.id == 0 then
		-- 		self.id = self.id + 1
		-- 	end
		-- else
		-- 	if self.id < self.length then
		-- 		self.rewardList[self.id+1]:setUpdateData(0)
		-- 		self.id = self.id + 1
		-- 	end
		-- end
		txt1:setRelativePosition(GlobalMethod:ccp(0.2,0.5))

		txt:setVisible(false) --后可以领取奖励

		local time = self:formatTime(self.OnlineTime)
		txtTime:setText(time)

		txt1:setText(LocalStrings.HAD_ONLINE)
		 
		txt2:setVisible(true)	--请领取奖励
		txt2:setText(LocalStrings.ONLINE_REWRAD)
	else
		txt1:setRelativePosition(GlobalMethod:ccp(0.02,0.5))
		txt2:setVisible(false) --请领取奖励

		txt1:setText(LocalStrings.CONTINUE_ONLINE)

		local time = self:formatTime(self.leaveTime)
		
    	txtTime:setText(time)

    	txt:setVisible(true)
		self.m_root:enableSchedule("scheduleUpdateRaffleTime",1)
	end
end


--@brief    奖励获取成功回调  
function CellOnLineReward:_GetRewardOk(  )
	self:_sortRewardList()
	self:_setRewardsList()
    --self:_showTime()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin---------------------------------------
function CellOnLineReward:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txt2_CellOnLineReward",WZUILabelTTF):setFontSize(20)
	local time = GetElement(self.m_root,"txtTime_CellOnLineReward",WZUILabelTTF)
	time:setFontSize(20)
	time:setRelativePosition(GlobalMethod:ccp(1,0.5))
	local txt1 = GetElement(self.m_root,"txt_CellOnLineReward",WZUILabelTTF)
	txt1:setFontSize(20)
	txt1:setRelativePosition(GlobalMethod:ccp(1.01,0.5))
	local txt2 = GetElement(self.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	txt2:setFontSize(20)
	txt2:setScale(0.8)
end

function CellOnLineReward:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txt2_CellOnLineReward",WZUILabelTTF):setFontSize(16)
	local txt1 = GetElement(self.m_root,"txt_CellOnLineReward",WZUILabelTTF)
	txt1:setFontSize(18)
	txt1:setRelativePosition(GlobalMethod:ccp(1,0.5))
	local time = GetElement(self.m_root,"txtTime_CellOnLineReward",WZUILabelTTF)
	time:setFontSize(18)
	time:setRelativePosition(GlobalMethod:ccp(1,0.5))

	local txt11 = GetElement(self.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	txt11:setFontSize(18)
	txt11:setScale(0.8)
end

function CellOnLineReward:_adaptLanguage_es(  )
	GetElement(self.m_root,"txt2_CellOnLineReward",WZUILabelTTF):setFontSize(20)
	local time = GetElement(self.m_root,"txtTime_CellOnLineReward",WZUILabelTTF)
	time:setFontSize(18)
	time:setRelativePosition(GlobalMethod:ccp(1,0.5))
	local txt1 = GetElement(self.m_root,"txt_CellOnLineReward",WZUILabelTTF)
	txt1:setFontSize(18)
	txt1:setRelativePosition(GlobalMethod:ccp(1,0.5))
	local txt2 = GetElement(self.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	txt2:setFontSize(18)
	txt2:setScale(0.65)
end

function CellOnLineReward:_adaptLanguage_en(  )
	GetElement(self.m_root,"txt2_CellOnLineReward",WZUILabelTTF):setFontSize(20)
	local time = GetElement(self.m_root,"txtTime_CellOnLineReward",WZUILabelTTF)
	time:setFontSize(12)
	time:setRelativePosition(GlobalMethod:ccp(1,0.5))
	local txt1 = GetElement(self.m_root,"txt_CellOnLineReward",WZUILabelTTF)
	txt1:setFontSize(12)
	txt1:setRelativePosition(GlobalMethod:ccp(1,0.5))
	local txt2 = GetElement(self.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	txt2:setFontSize(12)
end

function CellOnLineReward:_adaptLanguage_vn(  )
	local time = GetElement(self.m_root,"txtTime_CellOnLineReward",WZUILabelTTF)
	time:setFontSize(12)
	time:setRelativePosition(GlobalMethod:ccp(1,0.5))
	local txt = GetElement(self.m_root,"txt_CellOnLineReward",WZUILabelTTF)
	txt:setFontSize(12)
	txt:setRelativePosition(GlobalMethod:ccp(1,0.5))
	local txt1 = GetElement(self.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	txt1:setFontSize(12)
	local txt2 = GetElement(self.m_root,"txt2_CellOnLineReward",WZUILabelTTF)
	txt2:setFontSize(12)
	
end

function CellOnLineReward:_adaptLanguage_th(  )
	local txt1 = GetElement(self.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	txt1:setScale(0.8)
end
------------------------------------语言适配End-------------------------------------------