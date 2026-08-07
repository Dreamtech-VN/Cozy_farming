--CellMarkCoinItem.lua
--@brief	CellMarkCoinItem的UI模块
--@date		2019/04/23
--@author	Tianxiang_Xu
--@note		纪念币活动-任务列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMarkCoinItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMarkCoinItem:onExit(element)
	self:_unInit()
end

--@brief    加载时才显示cell信息
function CellMarkCoinItem:onLoadData(element)
    WZLog("CellMarkCoinItem:onLoadData")
    local cellElement = WZUISystem:getInstance():createElement("CellMarkCoinItem")
    self.m_root:addChild(cellElement)

    if self.data ~= nil then 
        self:updata()
    end
end

function CellMarkCoinItem:updata( )
	WZLog("CellMarkCoinItem:updata",self.data.id)

	local btnReceive = GetElement(self.m_root, "btnReceive_CellMarkCoinItem", WZUIButton)
	local btnReceiveCoin = GetElement(self.m_root, "btnReceiveCoin_CellMarkCoinItem", WZUIButton)
	local imgHavedGet1 = GetElement(self.m_root, "imgHavedGet1_CellMarkCoinItem", WZUIImage)
	local imgHavedGet2 = GetElement(self.m_root, "imgHavedGet2_CellMarkCoinItem", WZUIImage)
	if self.data.status == 0 then
		btnReceive:setTouchEnable(false)
		imgHavedGet1:setVisible(false)
	elseif self.data.status == 1 then
		btnReceive:setTouchEnable(true)
		imgHavedGet1:setVisible(false)
	elseif self.data.status == 2 then
		btnReceive:setVisible(false)
		imgHavedGet1:setVisible(true)
	end

	if self.data.statusCoin == 0 then
		btnReceiveCoin:setTouchEnable(false)
		imgHavedGet2:setVisible(false)
	elseif self.data.statusCoin == 1 then
		btnReceiveCoin:setTouchEnable(true)
		imgHavedGet2:setVisible(false)
	elseif self.data.statusCoin == 2 then
		btnReceiveCoin:setVisible(false)
		imgHavedGet2:setVisible(true)
	end

	local taskData = GDatatab_mark_task["id_" .. self.data.id]

	GetElement(self.m_root, "txtTaskName_CellMarkCoinItem", WZUILabelTTF):setText(taskData.name)
	GetElement(self.m_root, "txtTaskDesc_CellMarkCoinItem", WZUILabelTTF):setText(taskData.desc)
	GetElement(self.m_root, "txtProgress_CellMarkCoinItem", WZUILabelTTF):setText("("..self.data.complete.."/"..self.data.target..")")
	if taskData.script == {} or taskData.script == -1 or taskData.script[1][1] == 0 then 
		GetElement(self.m_root, "btnGoto_CellmarkCoinItem", WZUIButton):setVisible(false)
	end
	--任务奖励
	for i = 1, #taskData.reward do
		if i > 2 then break end 
		GetElement(self.m_root, "conReward" .. i .. "_CellMarkCoinItem", WZUIContainer):setVisible(true)

		local itemIcon = GDatatab_item["id_"..taskData.reward[i][1]].icon
		local imgIcon = GetElement(self.m_root, "imgIcon"..i.."_CellMarkCoinItem", WZUIImage)
		imgIcon:setVisible(true)
		imgIcon:setFile(itemIcon)

		local txtNum = GetElement(self.m_root, "txtNum"..i.."_CellMarkCoinItem", WZUILabelTTF)
		txtNum:setVisible(true)
		txtNum:setText(taskData.reward[i][2])
	end

	--任务奖励
	for i = 3, #taskData.reward2 + 2 do
		if i > 4 then break end 
		GetElement(self.m_root, "conReward" .. i .. "_CellMarkCoinItem", WZUIContainer):setVisible(true)

		local itemIcon = GDatatab_item["id_"..taskData.reward2[i - 2][1]].icon
		local imgIcon = GetElement(self.m_root, "imgIcon"..i.."_CellMarkCoinItem", WZUIImage)
		imgIcon:setVisible(true)
		imgIcon:setFile(itemIcon)

		local txtNum = GetElement(self.m_root, "txtNum"..i.."_CellMarkCoinItem", WZUILabelTTF)
		txtNum:setVisible(true)
		txtNum:setText(taskData.reward2[i - 2][2])
	end
end

function CellMarkCoinItem:onClickGet(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	CellMarkCoinItem.m_tCurClick = self
	local nTag = element:getTag()
	WZLog("CellMarkCoinItem:onClickGet", nTag, type(self.data), Serialize(self.data))
	if nTag == 1 then  --任务奖励
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveMarkTaskReward(self.data.id, nTag)
	elseif nTag == 2 then  --纪念币奖励
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveMarkTaskReward(self.data.id, nTag)
	elseif nTag == 3 then 	--前往
		local taskData = GDatatab_mark_task["id_" .. self.data.id]
		JumpByUIId(taskData.script[1][1], taskData.script[1][2])

		WindowManager:removeWindow(WndApartmentAct.m_root, WndApartmentAct, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
