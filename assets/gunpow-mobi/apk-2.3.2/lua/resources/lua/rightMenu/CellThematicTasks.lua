--CellThematicTasks.lua
--@brief	CellThematicTasks的UI模块
--@date		2017/12/08
--@author	yrd
--@note		主题任务格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellThematicTasks:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellThematicTasks:onExit(element)
	self:_unInit()
end

--@brief    加载时才显示cell信息
function CellThematicTasks:onLoadData(element)
    WZLog("CellThematicTasks:onLoadData")
    local cellElement = WZUISystem:getInstance():createElement("CellThematicTasks")
    self.m_root:addChild(cellElement)

    if self.data ~= nil then 
        self:updata()
    end
end

function CellThematicTasks:updata( )
	WZLog("CellThematicTasks:updata",self.data.id)


	GetElement(self.m_root,"btnOnGo_CellThematicTasks",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnOnGet_CellThematicTasks",WZUIButton):setVisible(false)
	GetElement(self.m_root,"imgReceived_CellThematicTasks",WZUIImage):setVisible(false)
	if self.data.status == 0 then
		GetElement(self.m_root,"btnOnGo_CellThematicTasks",WZUIButton):setVisible(true)
	elseif self.data.status == 1 then
		GetElement(self.m_root,"btnOnGet_CellThematicTasks",WZUIButton):setVisible(true)
	elseif self.data.status == 2 then
		GetElement(self.m_root,"imgReceived_CellThematicTasks",WZUIImage):setVisible(true)
	end

	local taskData = GDatatab_activity_task["id_"..self.data.id]
	GetElement(self.m_root,"imgItem_CellThematicTasks",WZUIImage):setFile("ui/"..taskData.icon)

	local tableTxtType = {LocalStrings.DAILY_TASKS_TYPE,LocalStrings.ONLY_TASKS_TYPE}
	GetElement(self.m_root,"txt1_CellThematicTasks",WZUILabelTTF):setText(tableTxtType[taskData.type])
	GetElement(self.m_root,"txt2_CellThematicTasks",WZUILabelTTF):setText(taskData.desc)
	GetElement(self.m_root,"txt3_CellThematicTasks",WZUILabelTTF):setText("("..self.data.complete.."/"..self.data.target..")")

	for i = 1, #taskData.reward do
		local itemIcon = GDatatab_item["id_"..taskData.reward[i][1]].icon
		local imgReward = GetElement(self.m_root,"imgReward"..i.."_CellThematicTasks",WZUIImage)
		imgReward:setVisible(true)
		imgReward:setFile(itemIcon)
		local txtReward = GetElement(self.m_root,"txtReward"..i.."_CellThematicTasks",WZUILabelTTF)
		txtReward:setVisible(true)
		txtReward:setText(taskData.reward[i][2])
	end

end

function CellThematicTasks:onGo( )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local taskData = GDatatab_activity_task["id_"..self.data.id]
	JumpByUIId(taskData.script[1][1],taskData.script[1][2])
	WindowManager:removeWindow(WndApartmentAct.m_root, WndApartmentAct, true)
end

function CellThematicTasks:onGet( )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	CellThematicTasks.m_tCurClick = self
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityTaskReward(self.data.id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
