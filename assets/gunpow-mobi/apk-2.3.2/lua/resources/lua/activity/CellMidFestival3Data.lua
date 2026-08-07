--CellMidFestival3Data.lua
--@brief	CellMidFestival3的数据模块
--@date		2021/08/18
--@author	hyx
--@note		中秋活动1

CellMidFestival3 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellMidFestival3:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tActivityData = {}
	self.m_tMidfestivalTaskData = {}
	self.m_tMidFestivalTaskItem = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMidFestival3:_unInit()
	self.m_root = nil
	self.m_tActivityData = {}
	self.m_tMidfestivalTaskData = {}
	self.m_tMidFestivalTaskItem = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellMidFestival3:createElement()
	if CellMidFestival3.m_root ~= nil then
		WindowManager:removeWindow(CellMidFestival3.m_root, CellMidFestival3, true)
	end
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellMidFestival3")
	assert(element, "CellMidFestival3 create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end
function CellMidFestival3:setAcvitityData(data)
	self.m_tActivityData = data
end



--======= 任务领取奖励 ========
MidFestivalTaskItem = {}
function MidFestivalTaskItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nRewardId = nil
	self.m_tRewardData = nil
	self.m_nTaskActivityId = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function MidFestivalTaskItem:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = {}
	self.m_nRewardId = nil
	self.m_tRewardData = nil
	self.m_nTaskActivityId = nil
end

--@brief	创建控件
function MidFestivalTaskItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(592,112))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function MidFestivalTaskItem:setTaskData(index, data, activityId)
	self.m_nIndex = index
	self.m_tRewardData = data
	self.m_nTaskActivityId = activityId
end

--@brief 	开始加载
function MidFestivalTaskItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("midFestivalTaskItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()	
end
function MidFestivalTaskItem:setData()
	
	self.m_tGoodItemCell[self.m_nIndex] = {}
	self:setTaskItemMessage(self.m_nIndex, self.m_tRewardData)
end
function MidFestivalTaskItem:setTaskItemMessage(index, data)
	local btnGet = GetElement(self.m_root,"btnGet",WZUIButton)
	btnGet:setVisible(false)
	local imgGet = GetElement(self.m_root,"imgGet",WZUIImage)
	imgGet:setVisible(false)
	if data.status == 0 or data.status == -1 then
		btnGet:setVisible(true)
		btnGet:setTouchEnable(data.status == 0)
	elseif data.status == 1 then
		imgGet:setVisible(true)
	end
	local txtRichTaskDesc = GetElement(self.m_root,"txtRichTaskDesc",WZUIFreeTextBox)
	local temp_str = data.progress .. "/" .. data.target
	txtRichTaskDesc:setShowText(string.format(data.desc,temp_str))
	self.m_nRewardId = data.id
	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	local reward_id = {}
	local reward_num = {}
	for i=1, #data.reward do
		table.insert(reward_id, data.reward[i][1])
		table.insert(reward_num, data.reward[i][2])
	end
	HoraryLevelRewardItem:setCommonRewardData(index, 5, reward_id, reward_num, goods_con, WndMidFestivalActivity, self.m_tGoodItemCell)
end
function MidFestivalTaskItem:onBtnClickGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nRewardId then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_nTaskActivityId, self.m_nRewardId)
	end
end
--@return	新建的表实例对象
function MidFestivalTaskItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellMidFestival3:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
