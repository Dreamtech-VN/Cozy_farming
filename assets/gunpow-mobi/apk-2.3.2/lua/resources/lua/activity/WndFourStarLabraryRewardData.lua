--WndFourStarLabraryRewardData.lua
--@brief	WndFourStarLabraryReward的数据模块
--@date		2021/02/24
--@author	hyx
--@note		图鉴奖励

WndFourStarLabraryReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFourStarLabraryReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tLibraryRewardData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFourStarLabraryReward:_unInit()
	self.m_root = nil
	self.m_tLibraryRewardData = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFourStarLabraryReward:createElement()
	if WndFourStarLabraryReward.m_root ~= nil then
		WindowManager:removeWindow(WndFourStarLabraryReward.m_root, WndFourStarLabraryReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFourStarLabraryReward")
	assert(element, "WndFourStarLabraryReward create element failed!")
	self:_init()
	return element
end

function WndFourStarLabraryReward:setLibraryTaskListData(id, status)
	for i=1,#id do
		local tab = {}
		tab.id = id[i]
		tab.status = status[i]
		local desc = ""
		local reward = {}
		if GDatatab_new_activity_task["id_"..id[i]] then
			desc = GDatatab_new_activity_task["id_"..id[i]].desc
			reward = GDatatab_new_activity_task["id_"..id[i]].reward
		end
		tab.desc = desc
		tab.reward = reward
		self.m_tLibraryRewardData[i] = tab
	end
	self:taskTableSort(self.m_tLibraryRewardData)
end

function WndFourStarLabraryReward:taskTableSort(data_sort)
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
--================== 图鉴奖励任务子项 ========================
CellLibraryRewardTaskItem = {}
function CellLibraryRewardTaskItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLibraryRewardTaskItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellLibraryRewardTaskItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(652,132))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellLibraryRewardTaskItem:setLibraryTaskMessage(index, data)
	self.m_nIndex = index
	self.m_tTaskItemData = data
end

--@brief 	开始加载
function CellLibraryRewardTaskItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("reward_item")
	celElement:setVisible(true)
	element:addChild(celElement)
	self:setTaskDataItem()
end

function CellLibraryRewardTaskItem:setTaskDataItem()
	if not self.m_tTaskItemData then return end
	local data = self.m_tTaskItemData

	GetElement(self.m_root,"freeTxtTitle",WZUIFreeTextBox):setShowText(data.desc)
	local btnGet = GetElement(self.m_root,"btnGet",WZUIButton)
	local image_get = GetElement(self.m_root,"image_get",WZUIImage)
	if data.status == 1 then
		btnGet:setVisible(false)
		image_get:setVisible(true)
	else
		image_get:setVisible(false)
		btnGet:setVisible(true)
		if data.status == -1 then
			btnGet:setTouchEnable(false)
		elseif data.status == 0 then
			btnGet:setTouchEnable(true)
		end
	end

	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	for i=1, #data.reward do
		local key = "id_"..data.reward[i][1]
		local tabItem = GDatatab_item[key]
		local num = data.reward[i][2]
		local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(GDatatab_item[key])}
		local celElement,tLuaObj = CellGoodItem:createElement()
		goods_con:addChild(celElement)
		celElement:setScale(0.95)
		celElement:setUseAbsCoordinate(true)
		tLuaObj:setCellGoodItem(itemInfo, 17)
		tLuaObj:setItemClickFun(WndFourStarLabraryReward,self.onItemClick)
		local _x = 35 + (i-1) * 85
		celElement:setAbsPosition(GlobalMethod:ccp(_x, 45))
	end
end
function CellLibraryRewardTaskItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndFourStarLabraryReward.m_root,1,tData,false,nil,true)
end
function CellLibraryRewardTaskItem:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tTaskItemData then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(g_cityExtenInfo.activity7008, self.m_tTaskItemData.id )
	end
end

--@return	新建的表实例对象
function CellLibraryRewardTaskItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
