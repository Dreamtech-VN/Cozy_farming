--CellMasterTask.lua
--@brief	CellMasterTask的UI模块
--@date		2016/07/23
--@author	zsq
--@note		师徒任务Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMasterTask:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMasterTask:onExit(element)
	self:_unInit()
end

function CellMasterTask:setData(tData)
	WZLog("CellMasterTask:setData")
	self.m_tData = tData
end

--@brief	点击完成
function CellMasterTask:onFinish()
	WZLog("CellMasterTask:onFinish")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData == nil then return end
	WndMasterTask.m_bShowReward = self.m_tData.id
	ProtocolProcessorWndMaster:send_MENTORING_GetReward(self.m_tData.id )
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellMasterTask:onLoadData(element)
	local cellElement = WZUISystem:getInstance():createElement("CellMasterTask")
	assert(cellElement, "CellMasterTask cellElement create failed!")
    self.m_root:addChild(cellElement)

	if self.m_tData == nil then return end
	local tTable = GDatatab_mentoring_task["id_"..self.m_tData.id]
	local numOfComplete = self.m_tData.numOfComplete
	--奖励1图标
	GetElement(self.m_root,"imgReward1",WZUIImage):setFile(GDatatab_item["id_"..tTable.reward[1][1]].icon)
	--奖励1数量
	GetElement(self.m_root,"txtReward1",WZUILabelTTF):setText(tTable.reward[1][2])
	--奖励2图标
	GetElement(self.m_root,"imgReward2",WZUIImage):setFile(GDatatab_item["id_"..tTable.reward[2][1]].icon)
	--奖励2数量
	GetElement(self.m_root,"txtReward2",WZUILabelTTF):setText(tTable.reward[2][2])
	--描述
	GetElement(self.m_root,"txtDesc",WZUILabelTTF):setText(tTable.name)
	--图标
	GetElement(self.m_root,"imgIcon_CellMasterTask",WZUIImage):setFile("ui/"..tTable.icon)
	--完成数量
	GetElement(self.m_root,"txtTarget",WZUILabelTTF):setText(numOfComplete.."/"..tTable.num)
	--完成按钮
	if numOfComplete >= tTable.num then
		GetElement(self.m_root,"btnFinish_CellMasterTask",WZUIButton):setVisible(true)
		GetElement(self.m_root,"txtTarget",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txtFinish",WZUILabelTTF):setVisible(true)
	else
		GetElement(self.m_root,"btnFinish_CellMasterTask",WZUIButton):setVisible(false)
		GetElement(self.m_root,"txtTarget",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txtFinish",WZUILabelTTF):setVisible(false)
	end

	--已领取
	if WndMasterTask.giveTaskId ~= nil and #WndMasterTask.giveTaskId ~= 0 then
		for i=1,#WndMasterTask.giveTaskId do
			if self.m_tData.id == WndMasterTask.giveTaskId[i] then
				GetElement(self.m_root,"btnFinish_CellMasterTask",WZUIButton):setVisible(false)
				GetElement(self.m_root,"txtTarget",WZUILabelTTF):setVisible(false)
				GetElement(self.m_root,"txtFinish",WZUILabelTTF):setVisible(true)
				return
			end
		end
	end
	AdaptLanguage(self)
end




-------------------------------------私有方法模块End----------------------------------------

---------------------------------------语言适配Begin-------------------------------------
function CellMasterTask:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtFinish",WZUILabelTTF):setFontSize(20)
end

function CellMasterTask:_adaptLanguage_en(  )
	local txtDesc = GetElement(self.m_root,"txtDesc",WZUILabelTTF)
	txtDesc:setFontSize(20)
	txtDesc:setDimensions(GlobalMethod:CCSize(500))
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.181,0.737037))

	GetElement(self.m_root,"txtFinish",WZUILabelTTF):setScale(0.8)
end

function CellMasterTask:_adaptLanguage_es(  )
	local txtDesc = GetElement(self.m_root,"txtDesc",WZUILabelTTF)
	txtDesc:setFontSize(16)
	GetElement(self.m_root,"txtFinish1_CellMasterTask",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtFinish2_CellMasterTask",WZUILabelTTF):setFontSize(20)
end

function CellMasterTask:_adaptLanguage_tr(  )
	local txtDesc = GetElement(self.m_root,"txtDesc",WZUILabelTTF)
	txtDesc:setFontSize(20)
	txtDesc:setDimensions(GlobalMethod:CCSize(500))
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.181,0.737037))
	GetElement(self.m_root,"txtFinish1_CellMasterTask",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtFinish2_CellMasterTask",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtFinish",WZUILabelTTF):setScale(0.7)
end
---------------------------------------语言适配End------------------------------------------