--WndDollMachineTaskData.lua
--@brief	WndDollMachineTask的数据模块
--@date		2021/04/29
--@author	hyx
--@note		娃娃机任务

WndDollMachineTask = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDollMachineTask:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTaskTitle = {}
	self.m_nCurTaskIndex = nil
	self.m_nActivityId = nil
	self.m_tTaskData = {}
	self.m_tCellTaskItem = {}
	self.m_nActivityType = 0
	self.m_bIsChangeBtn = true
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDollMachineTask:_unInit()
	self.m_root = nil
	self.m_tTaskTitle = {}
	self.m_nCurTaskIndex = nil
	self.m_nActivityId = nil
	self.m_tTaskData = {}
	self.m_tCellTaskItem = {}
	self.m_nActivityType = 0
	self.m_bIsChangeBtn = true
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDollMachineTask:createElement()
	if WndDollMachineTask.m_root ~= nil then
		WindowManager:removeWindow(WndDollMachineTask.m_root, WndDollMachineTask, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDollMachineTask")
	assert(element, "WndDollMachineTask create element failed!")
	self:_init()
	return element
end
--排序
function WndDollMachineTask:taskTableSort(data_sort)
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

function WndDollMachineTask:setTaskData(id, status, target, progress)
	local data = {}
	if id and next(id) ~= nil then
		local index = 1
		for i=1,#id do
			local config = GDatatab_new_activity_task["id_"..id[i]]
			if config then
				local tab = {}
				tab.id = id[i]
				tab.status = status[i]
				tab.target = target[i]
				tab.progress = progress[i]
				tab.desc = ""
				tab.reward = {}
				tab.desc = config.desc
				tab.reward = config.reward
				data[index] = tab
				index = index + 1	
			end
		end
	end
	return data
end

--=========== 任务子项 ===============
CellTaskItem = {}
function CellTaskItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nTaskRewardId = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellTaskItem:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = {}
	self.m_nTaskRewardId = nil
end

--@brief	创建控件
function CellTaskItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,112))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end
--_type: 0:默认是娃娃机的  1:占星
function CellTaskItem:setTeakItemData(index, activityId, data, _type)
	self.m_nIndex = index
	self.m_nActivityId = activityId
	self.m_sTaskData = data
	self.m_nType = _type or 0
end

--@brief 	开始加载
function CellTaskItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("itemTask")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()

	AdaptLanguage(self)
end

function CellTaskItem:setData()
	if not self.m_sTaskData then return end

	local img9_bg = GetElement(self.m_root,"img9_bg",WZUI9Image)
	local img9_title = GetElement(self.m_root,"img9_title",WZUI9Image)
	if self.m_nType == 1 or self.m_nType == 2 or self.m_nType == 3 or self.m_nType == 4 then
		img9_bg:setFile("ui/common/frame_lieb.png")
		img9_title:setFile("ui/common/title_frame_02.png")
	end
	self.m_tGoodItemCell[self.m_nIndex] = {}
	self:setTaskItemMessage(self.m_nIndex, self.m_sTaskData)
end
function CellTaskItem:setTaskItemMessage(index,data)
	local btnGoto = GetElement(self.m_root,"btnGoto",WZUIButton)
	btnGoto:setVisible(false)--data.status == -1)
	local btnGet = GetElement(self.m_root,"btnGet",WZUIButton)
	btnGet:setVisible(false)--data.status == 0)
	local imgGet = GetElement(self.m_root,"imgGet",WZUIImage)
	imgGet:setVisible(false)--data.status == 1)
	if data.status == -1 then
		btnGoto:setVisible(true)
		btnGoto:setTouchEnable(false)
	elseif data.status == 0 then
		btnGet:setVisible(true)
	elseif data.status == 1 then
		imgGet:setVisible(true)
	end

	local txtTitleDesc = GetElement(self.m_root,"txtTitleDesc",WZUIFreeTextBox)
	local txt = data.progress.."/"..data.target
	if data.desc ~= "" then
		txtTitleDesc:setShowText(string.format(data.desc,txt))
	end

	self.m_nTaskRewardId = data.id
	for i=1, 8 do --最大8个奖励
		if self.m_tGoodItemCell[index] and self.m_tGoodItemCell[index][i] and self.m_tGoodItemCell[index][i].celElement then
			self.m_tGoodItemCell[index][i].celElement:setVisible(false)
		end
	end
	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	for i=1, #data.reward do
		local id = data.reward[i][1]
		local num = data.reward[i][2]
		local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(GDatatab_item["id_"..id])}
		if self.m_tGoodItemCell[index][i] == nil then
			local celElement, tLuaObj = CellGoodItem:createElement()
			goods_con:addChild(celElement)
			celElement:setScale(0.85)
			celElement:setUseAbsCoordinate(true)
			local tab = {}
			tab.celElement = celElement
			tab.tLuaObj = tLuaObj
			self.m_tGoodItemCell[index][i] = tab
		end
		if self.m_tGoodItemCell[index][i] and self.m_tGoodItemCell[index][i].celElement and self.m_tGoodItemCell[index][i].tLuaObj then
			local celElement = self.m_tGoodItemCell[index][i].celElement
			local tLuaObj = self.m_tGoodItemCell[index][i].tLuaObj
			tLuaObj:setCellGoodItem(itemInfo, 17)
			tLuaObj:setItemClickFun(WndDollMachineTask,self.onItemClick)
			local _x = 35 + (i-1) * 85
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 40))
			celElement:setVisible(true)
		end
	end
end
function CellTaskItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndDollMachineTask.m_root,1,tData,false,nil,true)
end
function CellTaskItem:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nTaskRewardId and self.m_nActivityId then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_nActivityId, self.m_nTaskRewardId)
	end
end
function CellTaskItem:onBtnGoto()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(WndDollMachineTask.m_root, WndDollMachineTask, true)
end
--@return	新建的表实例对象
function CellTaskItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


function CellTaskItem:_adaptLanguage_vn()
	local txtTitleDesc = GetElement(self.m_root,"txtTitleDesc",WZUIFreeTextBox)
	txtTitleDesc:setMaxWidth(800)
end