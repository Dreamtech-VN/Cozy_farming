--WndFishFiveReward.lua
--@brief	WndFishFiveReward的UI模块
--@date		2021/08/26
--@author	hyx
--@note		钓鱼5钓奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFishFiveReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFishFiveReward:onExit(element)
	self:_unInit()
end
function WndFishFiveReward:showInterface(data)
	local wndReward = WndFishFiveReward:createElement()
	if wndReward ~= nil then
	    WindowManager:addWindow(wndReward,WndFishFiveReward,nil,false)
	end
	self:setRewardData(data)
end
function WndFishFiveReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndFishFiveReward:actionCallback()
	self:initShow()
end
function WndFishFiveReward:initShow()
	local fiveRewardFreeList = GetElement(self.m_root,"fiveRewardFreeList",WZUIFreeListContainer)
	fiveRewardFreeList:removeAll()
	local ids,nums,fish_type = {},{},{}
	local index = 1
	for i=1,#self.m_tRewardData.fishes do
		local _string = string.sub(self.m_tRewardData.rewards[i],2,-2)
		if self.m_tRewardData.fishes[i] == 6 or self.m_tRewardData.fishes[i] == 7 then
			if self.m_tRewardData.fishes[i] == 6 then
				local id = SplitStringWithSeparator(_string,",")[1]
				local num = SplitStringWithSeparator(_string,",")[2]
				table.insert(self.m_tFiveBigIds, id)
				table.insert(self.m_tFiveBigNums, num)
			elseif self.m_tRewardData.fishes[i] == 7 then 
				local id = SplitStringWithSeparator(_string,",")[1]
				local num = SplitStringWithSeparator(_string,",")[2]
				table.insert(self.m_tFiveSpecialIds, id)
				table.insert(self.m_tFiveSpecialNums, num)
			end
		else
			table.insert(fish_type, self.m_tRewardData.fishes[i])
			local array = SplitStringWithSeparator(_string,"&")
			ids[index] = {}
			nums[index] = {}
			for m=1,#array do
				local id = SplitStringWithSeparator(array[m],",")[1]
				local num = SplitStringWithSeparator(array[m],",")[2]
				table.insert(ids[index], id)
				table.insert(nums[index], num)
			end
			index = index + 1
		end
	end
	for i=1, #fish_type do
		local element, tLuaObj = CellFiveRewardItem:createElement()
		fiveRewardFreeList:pushBack(WZUIContainer:luaTo(element))
		fiveRewardFreeList:getMoveElement():setPositionY(fiveRewardFreeList:getMinPosition().y)
		tLuaObj:setFiveRewardData(fish_type[i], ids[i], nums[i])
	end
end
function WndFishFiveReward:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if next(self.m_tFiveBigIds) ~= nil or next(self.m_tFiveSpecialIds) ~= nil then
		local tab = {}
		tab.bigIds = self.m_tFiveBigIds
		tab.bigNums = self.m_tFiveBigNums
		tab.specialIds = self.m_tFiveSpecialIds
		tab.specialNums = self.m_tFiveSpecialNums
		WndHoraryBigReward:showInterface(3, tab)
	end
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
