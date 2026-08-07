--CellDouble11Activity.lua
--@brief	CellDouble11Activity的UI模块
--@date		2020/10/20
--@author	hyx
--@note		双11奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDouble11Activity:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDouble11Activity:onExit(element)
	self:_unInit()
end
--@brief    显示窗口
function CellDouble11Activity:showWindow( )
	if self.m_root == nil then return end 
	
	local avtivity_time = GetElement(self.m_root, "avtivity_time", WZUILabelTTF)
	if avtivity_time then
        avtivity_time:setText(os.date("%H:%M %d.%m",self.startTime) .. "-" .. os.date("%H:%M %d.%m",self.endTime))
    end

    --称号
    local conTitle = GetElement(self.m_root, "conTitle_CellDouble11Activity", WZUIContainer)
    local txtTitle = GetElement(self.m_root, "txtTitle_CellDouble11Activity", WZUILabelTTF)
    if self.rewardItems and self.rewardItems[1] then 
    	local basicData = GDatatab_item["id_" .. self.rewardItems[1]]
    	if basicData and basicData.main_type == 14 and basicData.sub_type == 16 then 
    		local achieData = nil 
    		for i, value in pairs(GDatatab_achievement) do
    			local nStart, nEnd = string.find(value.script, tostring(self.rewardItems[1]))
    			if nStart and nEnd then 
    				achieData = value
    				break 
    			end
    		end
		    local tempPoint = GlobalMethod:ccp(0.63,0.9)

		    CreateDesiSpine(conTitle, txtTitle, achieData.name, tempPoint)
		end
	end

    local status1 = self.status[1] or -1
    local status2 = self.status[2] or -1
    local btn_goto1 = GetElement(self.m_root, "btn_goto1", WZUIButton)
    if not btn_goto1 then return end
    
    btn_goto1:setVisible(status1 == -1)
	GetElement(self.m_root, "btn_goto2", WZUIButton):setVisible(status2 == -1)

	local btn_get1 = GetElement(self.m_root, "btn_get1", WZUIButton)
	local btn_get2 = GetElement(self.m_root, "btn_get2", WZUIButton)
	btn_get1:setVisible(status1 == 0 or status1 == 1)
	btn_get2:setVisible(status2 == 0 or status2 == 1)
	btn_get1:setTouchEnable(status1 == 0)
	btn_get2:setTouchEnable(status2 == 0)
	self.m_tGetButtonList[1] = btn_get1
	self.m_tGetButtonList[2] = btn_get2

	local tabItem = GDatatab_item["id_"..self.rewardItemsParamCount[1]]
	local img_item = GetElement(self.m_root, "img_item", WZUIImage)
	img_item:setFile(tabItem.icon)
	GetElement(self.m_root, "img_label", WZUILabelTTF):setText(self.rewardItemsParamCount[2])

	local diancount_1 = GetElement(self.m_root, "diancount_1", WZUILabelTTF)
	diancount_1:setText(self.count.."/"..self.target[1] or 0)
	local diancount_2 = GetElement(self.m_root, "diancount_2", WZUILabelTTF)
	diancount_2:setText(self.count.."/"..self.target[2] or 0)
end
function CellDouble11Activity:onClickBtnDouble11Get1(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.doubleElevenActivityId, 0)
end
function CellDouble11Activity:onClickBtnDouble11Get2(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.doubleElevenActivityId, 1)
end
function CellDouble11Activity:onClickBtnDouble11Goto(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndVip:showWndUI(0)
end

function CellDouble11Activity:onClickBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.OPTIMIZE_TEXT8)
end

function CellDouble11Activity:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount, rewardId)
	if rewardId == 0 then
		if self.m_tGetButtonList[1] then
			self.m_tGetButtonList[1]:setTouchEnable(false)
		end
	elseif rewardId == 1 then
		if self.m_tGetButtonList[2] then
			self.m_tGetButtonList[2]:setTouchEnable(false)
		end
	end
	WndRewardShow:showById(rewardItems,rewardCount)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
