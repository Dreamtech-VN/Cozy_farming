--CellLoginReward.lua
--@brief	CellLoginReward的UI模块
--@date		2021/05/20
--@author	hyx
--@note		选择回归奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLoginReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLoginReward:onExit(element)
	self:_unInit()
end

function CellLoginReward:showInterface(activityId,reward)   
	local wndReward = CellLoginReward:createElement(activityId,reward)
	if wndReward ~= nil then
	    WindowManager:addWindow(wndReward,CellLoginReward,nil,false)
	end
end

function CellLoginReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function CellLoginReward:actionCallback()
	local rewardTableContainer = GetElement(self.m_root,"rewardTableContainer",WZUITableContainer)
	rewardTableContainer:cleanTable()
	if self.m_tRewardData then
		for i=1, #self.m_tRewardData.reward do
			local tabItem = GDatatab_item["id_".. self.m_tRewardData.reward[i][1]]
			local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=self.m_tRewardData.reward[i][2],quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
			local celElement,tCell = CellGoodItem:createElement()
			if celElement and tCell then
				tCell:setCellGoodItem(itemInfo, 17)
				celElement:setTag(i-1)
				rewardTableContainer:setCellElement(celElement)

				tCell:setGoodItemCallFunc(function(tCell, tag, itenData)
					self:setGetChooseItemData(tCell, tag, itenData)
				end)
			end
		end
	end
end
function CellLoginReward:setGetChooseItemData(tCell, tag, itenData)
	WndItemInfo:onCloseClick()
	if not self.m_tGetChooseType[tag] then
		local choose_num = self:getn_table(self.m_tGetChooseType)
		if choose_num >= 1 then
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT32)
			return
		end
		self.m_tGetChooseType[tag] = true
		tCell:setItemSelState(true)
		WndItemInfo:showInfo(tCell.m_root,self.m_root,1,itenData,false)
	else
		tCell:setItemSelState(false)
		self.m_tGetChooseType[tag] = nil
	end
end
--获取真实的长度
function CellLoginReward:getn_table(nums)
	if not nums or next(nums) == nil then return 0 end
	local count = 0
	for i,v in pairs(nums) do
		if v ~= nil then
			count = count + 1
		end
	end
	return count
end
function CellLoginReward:onBtnSure()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tRewardData then
		local get_index = nil
		for i,v in pairs(self.m_tGetChooseType) do
			if v then
				get_index = i
				break
			end
		end
		if get_index then
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId,self.m_tRewardData.id, get_index+1)
		else
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT34)
		end
	end
end
function CellLoginReward:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
