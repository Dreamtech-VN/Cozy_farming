--CellNewVipWelfare.lua
--@brief	CellNewVipWelfare的UI模块
--@date		2021/03/22
--@author	hyx
--@note		贵族福利


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewVipWelfare:onEnter(element)
	self.m_root = element
	self:register()
	
    if ProjConfig.LANGUAGE == "vn" then
    	GetElement(self.m_root,"btn1",WZUIButton):setVisible(false)
    	GetElement(self.m_root,"btn3",WZUIButton):setVisible(false)
    	GetElement(self.m_root,"btn2",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.10885,1.00881))
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewVipWelfare:onExit(element)
	self:_unInit()
	self:unregister()
end

function CellNewVipWelfare:register()
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_GiftInfo,self._onGetGiftListInfo,self)
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_RebateInfo,self._onGetRebateListInfo,self)
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_WeekGiftInfo,self._onGetWeekGiftInfo,self)
end
function CellNewVipWelfare:unregister()
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_GiftInfo,self._onGetGiftListInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_RebateInfo,self._onGetRebateListInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_WeekGiftInfo,self._onGetWeekGiftInfo,self)
end

function CellNewVipWelfare:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function CellNewVipWelfare:actionCallback()
	self:initShow()
end
function CellNewVipWelfare:initShow()
	self.m_sGiftTabContainer = GetElement(self.m_root,"giftTabContainer",WZUITableContainer)
	self.m_sRebateFreeList = GetElement(self.m_root,"rebateFreeListContainer",WZUIFreeListContainer)
	self.m_sWeekGiftFreeList = GetElement(self.m_root,"weekGiftFreeListContainer",WZUIFreeListContainer)
	for i=1,3 do
		local tab = {}
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		tab.normal = GetElement(btn,"normal"..i,WZUI9Image)
		tab.select = GetElement(btn,"select"..i,WZUI9Image)
		tab.select:setVisible(false)
		tab.name = GetElement(btn,"name"..i,WZUILabelTTF)
		tab.name:setText(LocalStrings.NEWVIP_TEXT2[i])
		tab.name:setColor(GlobalMethod:ccc3(191,208,255))
		self.m_tWelfareTitleView[i] = tab
	end
	self.m_tWelfareTitleView[self.m_nCurTitleIndex].select:setVisible(true)
	self.m_tWelfareTitleView[self.m_nCurTitleIndex].name:setEnableStroke(true)
    self.m_tWelfareTitleView[self.m_nCurTitleIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
    self.m_tWelfareTitleView[self.m_nCurTitleIndex].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
    self.m_tWelfareTitleView[self.m_nCurTitleIndex].name:setStrokeSize(4)

    --默认
    self:setChangeTitle(self.m_nCurTitleIndex)
end

function CellNewVipWelfare:onBtnClickTitle(element)
	local tag = element:getTag()
	if tag == self.m_nCurTitleIndex then
		return
	end
	if self.m_tWelfareTitleView[tag] then
		self.m_tWelfareTitleView[tag].select:setVisible(true)
		self.m_tWelfareTitleView[tag].normal:setVisible(false)
		self.m_tWelfareTitleView[tag].name:setEnableStroke(true)
	    self.m_tWelfareTitleView[tag].name:setColor(GlobalMethod:ccc3(255,236,193))
	    self.m_tWelfareTitleView[tag].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
	    self.m_tWelfareTitleView[tag].name:setStrokeSize(4)
	end
	if self.m_tWelfareTitleView[self.m_nCurTitleIndex] then
		self.m_tWelfareTitleView[self.m_nCurTitleIndex].select:setVisible(false)
		self.m_tWelfareTitleView[self.m_nCurTitleIndex].normal:setVisible(true)
		self.m_tWelfareTitleView[self.m_nCurTitleIndex].name:setColor(GlobalMethod:ccc3(191,208,255))
		self.m_tWelfareTitleView[self.m_nCurTitleIndex].name:setEnableStroke(false)
	end
	self:setChangeTitle(tag)
	self.m_nCurTitleIndex = tag
end
--点击标题
function CellNewVipWelfare:setChangeTitle(tag)
	if self.m_tTitleViewShow[tag] == nil then
		if tag == 1 then
			self:_createRebateList()
		elseif tag == 2 then
			self:_createWeekPackageList()
		elseif tag == 3 then
			self:_createGiftList()
		end
		self.m_tTitleViewShow[tag] = true
	end
	self.m_sRebateFreeList:setVisible(tag == 1)
	self.m_sWeekGiftFreeList:setVisible(tag == 2)
	self.m_sGiftTabContainer:setVisible(tag == 3)
end

-- 创建礼包列表
function CellNewVipWelfare:_createGiftList()
	local data = WndVip:getGiftList()
    if not data then
    	ProtocolProcessorRecharge:send_PURCHASE_GetGiftIdList(ProjConfig:getChannelId())
        self:createLoadingUI()
        return
    end
    self.m_sGiftTabContainer:cleanTable()
    for i = 1, #data do
        local rData = data[i]
        rData.showType = 1
        local cell,tcell = CellVipPowerList:createElement(1)
        cell:setTag(i-1)
        self.m_sGiftTabContainer:setCellElement(cell)
        tcell:setData(rData)
    end
end

-- 创建返利列表
function CellNewVipWelfare:_createRebateList()
	if not WndVip.m_tRebateList then
        ProtocolProcessorWndVip:send_VIP_GetVipRebateInfo()
        return
    end
    if not self.m_sRebateFreeList then return end

    self.m_sRebateFreeList:removeAll()
    for i=1,#WndVip.m_tRebateList do
    	local rData = WndVip.m_tRebateList[i]
 		local element, tLuaObj = CellVipGiftList:createElement()
		self.m_sRebateFreeList:pushBack(WZUIContainer:luaTo(element))
		self.m_sRebateFreeList:getMoveElement():setPositionY(self.m_sRebateFreeList:getMinPosition().y)
		tLuaObj:setData(rData)
    end
end
function CellNewVipWelfare:createLoadingUI()
    if not self.loadingId_CellWelfare then
    	self.loadingId_CellWelfare = MsgBoxManager:showLoadingBox(5,self,self.closeLoadingUI)
    end
end
function CellNewVipWelfare:closeLoadingUI()
    if self.loadingId_CellWelfare then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId_CellWelfare)
        self.loadingId_CellWelfare = nil
    end
end

--@brief    创建周礼包列表
function CellNewVipWelfare:_createWeekPackageList()
    if not WndVip.m_tWeekPackageList then
        CellNewVipWelfare:createLoadingUI_weekGift()
        ProtocolProcessorWndVip:send_MALL_GetVipGift()
        return
    end
    if not self.m_sWeekGiftFreeList then return end

    self.m_sWeekGiftFreeList:removeAll()
    for i=1,#WndVip.m_tWeekPackageList do
    	local rData = WndVip.m_tWeekPackageList[i]
 		local element, tLuaObj = CellVipGiftList:createElement()
		self.m_sWeekGiftFreeList:pushBack(WZUIContainer:luaTo(element))
		self.m_sWeekGiftFreeList:getMoveElement():setPositionY(self.m_sWeekGiftFreeList:getMinPosition().y)
		tLuaObj:setData(rData, 1)
    end
end
function CellNewVipWelfare:createLoadingUI_weekGift()
    if not self.loadingId_weekGift_CellWelfare then
    	self.loadingId_weekGift_CellWelfare = MsgBoxManager:showLoadingBox(5,self,self.closeLoadingUI_weekGift)
    end
end
function CellNewVipWelfare:closeLoadingUI_weekGift()
    if self.loadingId_weekGift_CellWelfare then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId_weekGift_CellWelfare)
        self.loadingId_weekGift_CellWelfare = nil
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewVipWelfare:_onGetGiftListInfo()
	self:closeLoadingUI()
	self:_createGiftList()
end

function CellNewVipWelfare:_onGetRebateListInfo()
	self:_createRebateList()
end
function CellNewVipWelfare:_onGetWeekGiftInfo()
	self:_createWeekPackageList()
end
-------------------------------------私有方法模块End----------------------------------------
