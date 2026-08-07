--WndFootBeatCardData.lua
--@brief	WndFootBeatCard的数据模块
--@date		2021/11/02
--@author	XTX
--@note		足迹打卡

WndFootBeatCard = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFootBeatCard:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCityCardList = nil 			--打卡列表
	self.m_nCurFootNum = 0 				--当前收集的足迹数量
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFootBeatCard:_unInit()
	self.m_root = nil
	self.m_tCityCardList = nil 			--打卡列表
	self.m_nCurFootNum = nil 				--当前收集的足迹数量
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFootBeatCard:createElement()
	if WZFileUtil:isFileExist("pack/footmark/pack_footmark_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/footmark/pack_footmark_0.plist")
    end
    if WZFileUtil:isFileExist("pack/footmark/pack_footmark_1.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/footmark/pack_footmark_1.plist")
    end
	local element = WZUISystem:getInstance():createElement("WndFootBeatCard")
	assert(element, "WndFootBeatCard create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndFootBeatCard:showInterface(con)
	if WndFootBeatCard.m_root == nil then 
	    local wnd = WndFootBeatCard:createElement()
	    if con then
	        con:addChild(wnd)
	    end
	end
end

--@brief 	获取打卡数据
function WndFootBeatCard:getCityCardListOK(ids, footmarkCount, status)
	self.m_tCityCardList = {}

	for i = 1, #ids do
		local configData = GDatatab_footmark_city["id_" .. ids[i]]
		local tItem = CopyTable(configData)

		tItem.status = status[i]
		tItem.curNum = footmarkCount
		
		table.insert(self.m_tCityCardList, tItem)
	end
	WZLog("WndFootBeatCard:getCityCardListOK", Serialize(self.m_tCityCardList))
	table.sort(self.m_tCityCardList, function (a, b)
		return a.id < b.id
		end)

	self:_showBeatCardList()
end

--@brief 	领取打卡奖励
function WndFootBeatCard:getBeatCardRewardOK(id, result, itemId, itemNum)
	if result == 1 then 
		WndRewardShow:showById(itemId, itemNum)

		if self.m_root == nil then return end 

		local bHaveRedDot = false 
		for i = 1, #self.m_tCityCardList do
			if self.m_tCityCardList[i].id == id then 
				self.m_tCityCardList[i].status = 1

				local tbCityList = GetElement(self.m_root, "tbCityList_WndFootBeatCard", WZUITableContainer)
				local element = tbCityList:getCellElement(i - 1)
				element = WZUIContainer:luaTo(element)
	        	local cellItem = element:getChildElement("__CellFootCardItem")
	        	local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
	        	if cellObj and cellObj:getId() == id then 
	        		cellObj:updateStatus(self.m_tCityCardList[i].status)
	        	end 
			end

			if self.m_tCityCardList[i].status == 0 then 
				bHaveRedDot = true 
			end
		end
		GlobalGame.g_tRedPointList.footBeatCard = bHaveRedDot
		WndFootMark:showRedDot()
	elseif result == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.REWARD_HAVED_GET)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------




-------------------------------------私有方法模块End----------------------------------------
CellFootCardItem = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellFootCardItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil 
	self.loadEnd = false	-- 是否加载完成
	self.selState = false	-- 设置选中状态
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFootCardItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.loadEnd = nil		-- 是否加载完成
	self.selState = nil		-- 设置选中状态
end

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellFootCardItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFootCardItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setName("__CellFootCardItem")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(306, 406))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFootCardItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-- 设置cell中的内容
function CellFootCardItem:setData(tInfo)
    self.m_tData = tInfo
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFootCardItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFootCardItem:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end


-- 加载数据
function CellFootCardItem:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("cellFootCardItem")
    cellElement:setVisible(true)
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:_update()
end

--@brief	领取打卡奖励
function CellFootCardItem:onClickReward(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tData.status == 0 then 
    	ProtocolProcessorFootMark:send_FOOTMARK_ReceiveFootMarkCityReward(self.m_tData.id)
    else
    	local tData = {ids = {}, nums = {}}
    	local rewardList = self.m_tData.reward_boy
    	local sex = CacheCenter:getPlayerInfo().sex
    	if sex == 1 then 
    		rewardList = self.m_tData.reward_girl
    	end
    	for i = 1, #rewardList do
    		table.insert(tData.ids, rewardList[i][1])
    		table.insert(tData.nums, rewardList[i][2])
    	end
    	WndTips:show(element, WndPets.m_root, 10, tData, nil, true)
    end
end

--@brief 	刷新
function CellFootCardItem:_update()
	GetElement(self.m_root, "img9Bk_cellFootCardItem", WZUI9Image):setFile("ui/footmark/" .. self.m_tData.picture .. ".png")
	--进度
	local txtTarget = GetElement(self.m_root, "txtTarget_cellFootCardItem", WZUILabelTTF)
	if txtTarget then 
		local curNum = self.m_tData.curNum > self.m_tData.target and self.m_tData.target or self.m_tData.curNum
		txtTarget:setText(curNum .. "/" .. self.m_tData.target)
	end

	--城市名
	if self.m_tData.open_status == 1 then 
		GetElement(self.m_root, "conLock_cellFootCardItem", WZUIContainer):setVisible(false)
	else
		GetElement(self.m_root, "conLock_cellFootCardItem", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "img9Bk_cellFootCardItem", WZUI9Image):setFile("ui/common/common_shade_chushouheidi1.png")
	end

	--红点
	self:updateRedDot()
end

--@brief	获取城市Id
function CellFootCardItem:getId()
	return self.m_tData.id
end

--@brief	领取奖励，更新状态
function CellFootCardItem:updateStatus(status)
	self.m_tData.status = status
	self:updateRedDot()
end

--@brief 	红点
function CellFootCardItem:updateRedDot()
	if not self.loadEnd then return end 
	if self.m_tData.status == 0 then 
		GetElement(self.m_root, "imgRedDot_cellFootCardItem", WZUIImage):setVisible(true)
		GetElement(self.m_root, "conCanBeat_cellFootCardItem", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "btnBeatCard_WndFootBeatCard", WZUIButton):setVisible(true)
	else
		GetElement(self.m_root, "btnBeatCard_WndFootBeatCard", WZUIButton):setVisible(false)
		GetElement(self.m_root, "imgRedDot_cellFootCardItem", WZUIImage):setVisible(false)
		if self.m_tData.status == -1 then 
			GetElement(self.m_root, "conCanBeat_cellFootCardItem", WZUIContainer):setVisible(true)
		else
			GetElement(self.m_root, "conCanBeat_cellFootCardItem", WZUIContainer):setVisible(false)
		end
	end
end