--CellNewYearChangeData.lua
--@brief	CellNewYearChange的数据模块
--@date		2020/12/24
--@author	hyx
--@note		新年充值

CellNewYearChange = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewYearChange:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tChargeTaskData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearChange:_unInit()
	self.m_root = nil
	self.m_tChargeTaskData = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewYearChange:createElement()
	if CellNewYearChange.m_root ~= nil then
		WindowManager:removeWindow(CellNewYearChange.m_root, CellNewYearChange, true)
	end

	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellNewYearChange")
	assert(element, "CellNewYearChange create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

function CellNewYearChange:setActivityIdORType(activityId, _type)
	self.m_nActivityId = activityId
	self.m_nActivityType = _type
end
function CellNewYearChange:setTaskItemData(activityId, taskType, id, status, target, progress, progressCount)
	local data = {}
	local table_insert = table.insert
	local index = 1
	for i=1,#id do
		local tab = {}
		tab.activityId = activityId
		tab.id = id[i]
		tab.status = status[i]
		tab.desc = ""
		tab.reward = {}
		local config = GDatatab_new_activity_task["id_"..id[i]]
		if config then
			tab.desc = config.desc
			tab.reward = config.reward
		end
		local _progress = {}
		for i=1,progressCount[i] do
			local t_num = progress[index].."/"..target[index]
			table_insert(_progress,t_num)
			index = index + 1
		end
		tab.progress = _progress
		table_insert(data, tab)
	end
	self:taskTableSort(data)
	self.m_tChargeTaskData = data
	self:setChargeRedPoint()
	return data
end

--排序
function CellNewYearChange:taskTableSort(data_sort)
	local temp = {
		[-1] = 2, --未领取
		[0] = 1, --可领取
		[1] = 3, --已领取
	}
	local function testFunc(a,b)
		if a.status ~= b.status then
			if temp[a.status] and temp[b.status] then
				return temp[a.status] < temp[b.status]
			else
				return false
			end
		else
			return a.id < b.id
		end
	end
	table.sort(data_sort, testFunc)
end
--领取后更新
function CellNewYearChange:updateTaskData(taskId)
	if self.m_tChargeTaskData then
		for i,v in pairs(self.m_tChargeTaskData) do
			if v.id == taskId then
				v.status = 1
				break
			end
		end
		self:taskTableSort(self.m_tChargeTaskData)
		self:setChargeRedPoint()
	end
end
--处理红点
function CellNewYearChange:setChargeRedPoint()
	if self.m_tChargeTaskData then
		local status = false
		for i,v in pairs(self.m_tChargeTaskData) do
			if v.status == 0 then
				status = true
				break
			end
		end
		WndNewYearActivityMain:setRedPointStatus(self.m_nActivityType, status)
		WndNewYearActivityMain:setHolidayTitleItemRedPoint(self.m_nActivityType, status)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewYearChange:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end


-------------------------------------私有方法模块End----------------------------------------

CellChargeItem = {}
function CellChargeItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellChargeItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellChargeItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(738,122))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellChargeItem:setChargeMessage(index, data)
	self.m_tChargeData = data
end
--@brief 	开始加载
function CellChargeItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellChargeItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:chargeDateItem()
end

function CellChargeItem:chargeDateItem()
	if not self.m_tChargeData then return end

	GetElement(self.m_root,"get_img",WZUIImage):setVisible(self.m_tChargeData.status == 1)
	local btn_get = GetElement(self.m_root,"btn_get",WZUIButton)
	btn_get:setVisible(self.m_tChargeData.status == 0 or self.m_tChargeData.status == -1)
	if self.m_tChargeData.status == -1 then
		btn_get:setTouchEnable(false)
	elseif self.m_tChargeData.status == 0 then
		btn_get:setTouchEnable(true)
	end

	local charge_desc = GetElement(self.m_root,"charge_desc",WZUIFreeTextBox)
	local str = string.format(self.m_tChargeData.desc,self.m_tChargeData.progress[1],self.m_tChargeData.progress[2] or "")
	WZLog("CellChargeItem:chargeDateItem", str)
	charge_desc:setShowText(str)

	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	for i=1, #self.m_tChargeData.reward do
		local id = self.m_tChargeData.reward[i][1]
		local num = self.m_tChargeData.reward[i][2]
		local items = GDatatab_item["id_"..id]
		if items then
			local celElement, tNewObj = CellGoodItem:createElement()
			goods_con:addChild(celElement)
			celElement:setUseAbsCoordinate(true)
			celElement:setAnchorPoint(GlobalMethod:ccp(0,0))
	 		celElement:setAbsPosition(GlobalMethod:ccp(0,0))

		    local itemInfo = {id=i, name=items.name,icon=items.icon,lastNum=num,quality=items.quality,basicInfo=items}
		    tNewObj:setCellGoodItem(itemInfo,17)
			celElement:setScale(0.85)
		    tNewObj:setItemClickFun(self,self.onItemClick)
		    celElement:setAbsPosition(GlobalMethod:ccp(5+(90 * (i-1)),3))
		end
	end
end
function CellChargeItem:onItemClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndItemInfo:showInfo(tCell.m_root,WndNewYearActivityMain.m_root,1,tData,false,nil,true)	
end

--领取
function CellChargeItem:onBtnClickGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tChargeData then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tChargeData.activityId, self.m_tChargeData.id)
	end
end 

--@return	新建的表实例对象
function CellChargeItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

