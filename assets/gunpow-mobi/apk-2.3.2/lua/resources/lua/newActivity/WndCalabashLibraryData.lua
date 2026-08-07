--WndCalabashLibraryData.lua
--@brief	WndCalabashLibrary的数据模块
--@date		2023/02/02
--@author	XTX
--@note		葫芦娃活动-图鉴

WndCalabashLibrary = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCalabashLibrary:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nActivityId = nil 
	self.m_tTaskList = nil 
	self.m_tItemIds = {160408, 160409, 160410, 160411, 160412, 160413, 160414}
	self.m_tCellItem = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCalabashLibrary:_unInit()
	self.m_root = nil
	self.m_nActivityId = nil 
	self.m_tTaskList = nil 
	self.m_tItemIds = nil 
	self.m_tCellItem = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCalabashLibrary:createElement()
	if WndCalabashLibrary.m_root ~= nil then
		WindowManager:removeWindow(WndCalabashLibrary.m_root, WndCalabashLibrary, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCalabashLibrary")
	assert(element, "WndCalabashLibrary create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndCalabashLibrary:showInterface(activityId)
	local wndWater = WndCalabashLibrary:createElement()
	if wndWater then 
		self.m_nActivityId = activityId
		WindowManager:addWindow(wndWater, WndCalabashLibrary, false, nil, nil, true)
	end
end

--@brief 	设置任务数据
function WndCalabashLibrary:setData()
	self.m_tTaskList = WndCalabash:getLibraryData()

	self:_update()
end

--@brief	缓存推送更新物品时调用的函数
function WndCalabashLibrary:updatePlayerItemData()
	WZLog("WndCalabashLibrary:updatePlayerItemData")
	if self.m_root ~= nil then
		if self.m_tCellItem then 
			for i = 1, #self.m_tCellItem do
				self.m_tCellItem[i]:updateStatue(self.m_tTaskList[i].status)
			end
		end
	end
end

--@brief 	领取奖励后更新图鉴状态
function WndCalabashLibrary:updateLibraryStatus(id, status)
	if self.m_root == nil then return end 

	for i = 1, #self.m_tCellItem do
		local tData = self.m_tCellItem[i]:getData()
		if tData.id == id then 
			self.m_tTaskList[i].status = status
			self.m_tCellItem[i]:updateStatue(self.m_tTaskList[i].status)
			break 
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
CellCalabashLibraryItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCalabashLibraryItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_bIsLoaded = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCalabashLibraryItem:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCalabashLibraryItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCalabashLibraryItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellCalabashLibraryItem")
	element:setAbsContentSize(GlobalMethod:CCSize(656,202))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	 设置数据
function CellCalabashLibraryItem:setData(tData)
	-- body
	self.m_tData = tData
end

--@brief 	 设置数据
function CellCalabashLibraryItem:getData()
	-- body
	return self.m_tData
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCalabashLibraryItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCalabashLibraryItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCalabashLibraryItem:onExit(element)
	self:_unInit()
end

--@brief 加载
function CellCalabashLibraryItem:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellCalabashLibraryItem")
	celElement:setVisible(true)
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true 
    self:_update()
end

--@brief 	点击下拉按钮回调
function CellCalabashLibraryItem:onGetReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nActivityId = self.m_tData.activityId
	local nOpType = 7
	local tabTemp = {}
	tabTemp.id = {}
	tabTemp.num = {}
	tabTemp.id[1] = self.m_tData.id
	tabTemp.num[1] = 1	
	local stringData = json.encode(tabTemp)

	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(nActivityId, nOpType, stringData)
end

--@brief    刷新
function CellCalabashLibraryItem:_update()
	WZLog("CellCalabashLibraryItem:_update")
	--body
	local txtName = GetElement(self.m_root, "txtName_CellCalabashLibrary", WZUILabelTTF)
	if txtName then 
		txtName:setText(self.m_tData.name)
	end
	local txtDesc = GetElement(self.m_root, "txtDesc_CellCalabashLibraryItem", WZUILabelTTF)
	if txtDesc then 
		txtDesc:setText(self.m_tData.desc)
	end
	local imgCalabashIcon = GetElement(self.m_root, "imgCalabashIcon_CellCalabashLibrary", WZUIImage)
	if imgCalabashIcon then 
		imgCalabashIcon:setFile("ui/newActivity/" .. self.m_tData.icon)
	end
	self:updateStatue(self.m_tData.status)
	--奖励
	local conReward = GetElement(self.m_root, "conRewards_CellCalabashLibraryItem", WZUIContainer)
	conReward:removeAllChildrenWithCleanup(true)
	local ids, nums = nil, nil
	local nStartX = 0.1 
	local nGapping = 0.19
	local nScale = 0.7
	ids, nums = {}, {}
	for i = 1, #self.m_tData.reward do
		table.insert(ids, self.m_tData.reward[i][1])
		table.insert(nums, self.m_tData.reward[i][2])
	end
	
	for i = 1, #ids do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(tonumber(ids[i]), tonumber(nums[i]), 17)
			tNewObj:setItemClickFun(self, self.onItemClick)
			element:setRelativePosition(GlobalMethod:ccp(nStartX + (i - 1) * nGapping, 0.5))
			element:setScale(nScale)
			conReward:addChild(element)
		end
	end
end

function CellCalabashLibraryItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    local rootTemp = WndCalabashLibrary.m_root
   	WndItemInfo:showInfo(tCell.m_root, rootTemp, 1, tData, false, nil, true)
end

--@brief 	修改奖励状态
function CellCalabashLibraryItem:updateStatue(status)
	self.m_tData.status = status
	if not self.m_bIsLoaded then return end 

	local imgCalabashIcon = GetElement(self.m_root, "imgCalabashIcon_CellCalabashLibrary", WZUIImage)
	local btnReward = GetElement(self.m_root, "btnReward_CellCalabashLibraryItem", WZUIButton)
	btnReward:setTag(self.m_tData.id)
	local conGoods = GetElement(self.m_root, "conGoods_CellCalabashLibraryItem", WZUIContainer)
	conGoods:removeAllChildrenWithCleanup(true)
	local ids, nums = nil, nil
	local nStartX = 0.07 
	local nGapping = 0.14
	local nScale = 0.7
	ids, nums = {}, {}
	for i = 1, #self.m_tData.cost do
		table.insert(ids, self.m_tData.cost[i][1])
		table.insert(nums, self.m_tData.cost[i][2])
	end
	
	local bIsCanGet = true 
	for i = 1, #ids do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(tonumber(ids[i]), tonumber(nums[i]), 17)
			tNewObj:setItemClickFun(self, self.onItemClick)
			element:setRelativePosition(GlobalMethod:ccp(nStartX + (i - 1) * nGapping, 0.5))
			tNewObj:setBackImgFile("ui/newActivity/frame_tc_hlw_tj_03.png", nil, 1.5)			
			tNewObj:setQualityFrameVisible(false)
			element:setScale(nScale)
			conGoods:addChild(element)

			local nHaveNum = CacheCenter:getPlayerItemCountById(tonumber(ids[i]))
			if nHaveNum < tonumber(nums[i]) then 
				bIsCanGet = false 
			end
			tNewObj:_setItemCountText(nHaveNum, tonumber(nums[i]))
		end
	end
	if self.m_tData.status ~= 1 then 
		btnReward:setVisible(true)
		btnReward:setTouchEnable(bIsCanGet)
		imgCalabashIcon:setGrayRender(true)
	else
		btnReward:setVisible(false)
		GetElement(self.m_root, "imgHavedGet_CellCalabashLibraryItem", WZUIImage):setVisible(true)
		imgCalabashIcon:setGrayRender(false)
	end
end