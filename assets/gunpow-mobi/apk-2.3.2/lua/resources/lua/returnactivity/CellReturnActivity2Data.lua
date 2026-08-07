--CellReturnActivity2Data.lua
--@brief	CellReturnActivity2的数据模块
--@date		2021/05/19
--@author	hyx
--@note		回归活动王者归来

CellReturnActivity2 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellReturnActivity2:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBtnChangeTitle = {}
	self.m_nCurIndex = nil
	self.m_sBoxCommonObj = nil
	self.m_tOpenListView = {}
	self.m_tGetStatusData = {}
	self.m_tDayTaskData = {}
	self.m_tBoxRewardData = {}
	self.m_tCellObjData = {}
	self.m_nCurDay = 1
	self.m_tTitleRedpoint = {false,false,false,false,false} --头顶标题的红点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellReturnActivity2:_unInit()
	self.m_root = nil
	self.m_tBtnChangeTitle = {}
	self.m_nCurIndex = nil
	self.m_sBoxCommonObj = nil
	self.m_tOpenListView = {}
	self.m_tGetStatusData = {}
	self.m_tDayTaskData = {}
	self.m_tBoxRewardData = {}
	self.m_tCellObjData = {}
	self.m_nCurDay = 1
	self.m_tTitleRedpoint = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellReturnActivity2:createElement()
	if CellReturnActivity2.m_root ~= nil then
		WindowManager:removeWindow(CellReturnActivity2.m_root, CellReturnActivity2, true)
	end

	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellReturnActivity2")
	assert(element, "CellReturnActivity2 create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end
function CellReturnActivity2:setActivityIdORType(activityId, _type)
	self.m_nActivityId = activityId
	self.m_nActivityType = _type
end

function CellReturnActivity2:setGetStatusData(id, status, target, progress, progressCount)
	for i=1,#id do
		local tab = {}
		tab.id = id[i]
		tab.status = status[i]
		tab.target = target[i]
		tab.progress = progress[i]
		self.m_tGetStatusData[tab.id] = tab
	end
end

function CellReturnActivity2:setDayTaskData( _type )
	local data = {}
	local table_insert = table.insert
	for i,v in pairs(GDatatab_new_activity_task) do
		if v.activity_type == _type then
			table_insert(data, v)
		end
	end
	local temp_data = {}
	for i,v in pairs(data) do
		if temp_data[v.day] == nil then
			temp_data[v.day] = {}
		end
		local tab = {}
		tab.id = v.id
		tab.desc = v.desc
		tab.reward = v.reward
		tab.jump = v.script[1][1]
		tab.status = -1
		tab.target = 1
		tab.progress = 0
		if self.m_tGetStatusData[tab.id] then
			tab.status = self.m_tGetStatusData[tab.id].status
			tab.target = self.m_tGetStatusData[tab.id].target
			tab.progress = self.m_tGetStatusData[tab.id].progress
		end
		table_insert(temp_data[v.day],tab)
	end
	self.m_tDayTaskData = temp_data
end
--左边大标题红点
function CellReturnActivity2:getTitleRedPoint()
	local status = false
	for i,v in pairs(self.m_tTitleRedpoint) do
		if v == true then
			status = true
			break
		end
	end
	local box_status = false
	for i,v in pairs(self.m_tBoxRewardData) do
		if v.status == true then
			box_status = true
			break
		end
	end
	status = status or box_status
	WndReturnActivityMain:setReturnRedPointStatus(self.m_nActivityType, status)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellReturnActivity2:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end


--======== 王者回归子项=============
CellActivity2Item = {}
function CellActivity2Item:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellActivity2Item:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellActivity2Item:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(716,100))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellActivity2Item:setCellItem2Data(data, type_id)
	self.m_tCellItem2Data = data
	self.m_nTypeId = type_id 
end
--@brief 	开始加载
function CellActivity2Item:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("listItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData(self.m_tCellItem2Data)
end

function CellActivity2Item:setData(data)
	if not data then return end
	
	GetElement(self.m_root,"btnGoto",WZUIButton):setVisible(data.status == -1)
	GetElement(self.m_root,"btnGet",WZUIButton):setVisible(data.status == 0)
	GetElement(self.m_root,"imgGet",WZUIImage):setVisible(data.status == 1)
	local str_tag = data.progress.."/"..data.target
	GetElement(self.m_root,"txtDesc",WZUIFreeTextBox):setShowText(string.format(data.desc, str_tag))
	GetElement(self.m_root,"txtOrder",WZUILabelTTF):setText(data.progress.."/"..data.target)

	local txtRreward = GetElement(self.m_root,"txtRreward",WZUIFreeTextBox)
	local str = ""
	for i=1, #data.reward do
		local icon = GDatatab_item["id_"..data.reward[i][1]].icon
		local num = data.reward[i][2]
		str = str .. string.format([[<I Z="0.5">%s</I><T C="255,236,193" S="20" P="1">%d</T><BL>32</BL>]],icon,num)
	end
	txtRreward:setShowText(str)
end
function CellActivity2Item:onBtnGoto()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tCellItem2Data then
		JumpByUIId(self.m_tCellItem2Data.jump)
		WindowManager:removeWindow(WndReturnActivityMain.m_root, WndReturnActivityMain, true)
	end
end
function CellActivity2Item:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tCellItem2Data then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_nTypeId, self.m_tCellItem2Data.id)
	end
end
--@return	新建的表实例对象
function CellActivity2Item:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
