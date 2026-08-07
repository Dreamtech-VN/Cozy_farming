--CellNewOnLineReward.lua
--@brief	CellOnLineReward的UI模块
--@date		2016/07/20
--@author	maopeiting
--@note		在线奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewOnLineReward:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function CellNewOnLineReward:onEnterTransitionDidFinish(  )
	
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewOnLineReward:onExit(element)
	self:_unInit()
end

--@brief	倒计时定时器
function CellNewOnLineReward:scheduleUpdateRaffleTime( element )
	local txt = GetElement(CellNewOnLineReward.m_current.m_root,"txt_CellOnLineReward",WZUILabelTTF)
	local txtTime = GetElement(CellNewOnLineReward.m_current.m_root,"txtTime_CellOnLineReward",WZUILabelTTF)
	local txt1 = GetElement(CellNewOnLineReward.m_current.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	local txt2 = GetElement(CellNewOnLineReward.m_current.m_root,"txt2_CellOnLineReward",WZUILabelTTF)
	
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
function CellNewOnLineReward:_setRewardsList(  )
	local tab = GetElement(CellNewOnLineReward.m_current.m_root,"tab_CellOnLineReward",WZUITableContainer)
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
			GetElement(celElement,"btn_CellOnlineRewardItem",WZUIButton):setLuaDoneFunctionName("onNewClick")
			table.insert(self.rewardList,tCell)
		end
	end
	--WZLog("---*****--11",Serialize(self.rewardList))
	local function sort(v1,v2)
		return tonumber(v1.id) < tonumber(v2.id)
	end
	table.sort(self.rewardList,sort)
	tab:getMoveElement():setPositionY(tab:getMinPosition().y)

	-- self:_showTime()
end

function CellNewOnLineReward:_showTime(  )
	WZLog("----&&&&&&&&&&&111--",#self.rewardId)
	if not self.time then return end
	
	local txtTime = GetElement(CellNewOnLineReward.m_current.m_root,"txtTime_CellOnLineReward",WZUILabelTTF)
	local txt = GetElement(CellNewOnLineReward.m_current.m_root,"txt_CellOnLineReward",WZUILabelTTF)
	local txt1 = GetElement(CellNewOnLineReward.m_current.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	local txt2 = GetElement(CellNewOnLineReward.m_current.m_root,"txt2_CellOnLineReward",WZUILabelTTF)

	if #self.rewardId == self.length then
		txt1:setText(LocalStrings.ONLINE_REWARD_RECEVICED)
		txtTime:setVisible(false)
		txt2:setVisible(false)
		txt:setVisible(false)
		return
	else
		if self.id <= 0 then --奖励都不可领取的状态下
			self.time = self:getDataById(1)
		elseif self.id == #self.rewardId then --奖励都已经领取完的状态下
			self.time = self:getDataById(self.id + 1)
		elseif self.id > #self.rewardId then --奖励未领取完的状态下
			self.time = self:getDataById(self.id)
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
		-- self.m_root:enableSchedule("scheduleUpdateRaffleTime",1)
	end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin---------------------------------------
function CellNewOnLineReward:_adaptLanguage_pt(  )
	local txt1 = GetElement(self.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	txt1:setScale(0.7)
end
function CellNewOnLineReward:_adaptLanguage_es(  )
	local txt1 = GetElement(self.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	txt1:setScale(0.7)
end
function CellNewOnLineReward:_adaptLanguage_en(  )
	local txt1 = GetElement(self.m_root,"txt1_CellOnLineReward",WZUILabelTTF)
	txt1:setScale(0.7)
end
-------------------------------------语言适配End---------------------------------------