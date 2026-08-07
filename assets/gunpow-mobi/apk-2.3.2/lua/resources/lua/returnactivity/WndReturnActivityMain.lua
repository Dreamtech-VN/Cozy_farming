--WndReturnActivityMain.lua
--@brief	WndReturnActivityMain的UI模块
--@date		2021/05/19
--@author	hyx
--@note		回归活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndReturnActivityMain:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndReturnActivityMain:onExit(element)
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
end
function WndReturnActivityMain:register()
	Protocol:reg( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityListInfoOK, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityListInfoOK", "vivsviviivivivivsvivs")
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetActivityTitleName,self._onGetActivityTitleInfo,self)
end
function WndReturnActivityMain:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetActivityTitleName,self._onGetActivityTitleInfo,self)
end
--打开界面
function WndReturnActivityMain:showInterface()   
	local returnActivity = WndReturnActivityMain:createElement()
	if returnActivity ~= nil then
	    WindowManager:addWindow(returnActivity,WndReturnActivityMain,nil,false)
	end
end
function WndReturnActivityMain:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function WndReturnActivityMain:actionCallback()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo(11)
	ProtocolProcessorFestivalActivity:regAll6()
end
function WndReturnActivityMain:initShow()
	local activityTitleList = GetElement(self.m_root,"activityTitleList",WZUIFreeListContainer)
	if not activityTitleList then return end

	local configInfo = self:getReturnActivityData()
	if not configInfo or next(configInfo) == nil then return end

	local temp_data = {}
	for i,v in pairs(configInfo) do
		table.insert(temp_data,v)
	end
	table.sort( temp_data, function(a,b) return a.typeId < b.typeId end)

	local activityId = temp_data[1].activityId
	local activityType = temp_data[1].typeId
	for i,v in pairs(temp_data) do
		if self.m_tReturnTitleCellIten[v.typeId] == nil then
			local element, tLuaObj = CellReturnActivityTitleItem:createElement(activityType)
			self.m_tReturnTitleCellIten[v.typeId] = tLuaObj
			activityTitleList:pushBack(WZUIContainer:luaTo(element))
			activityTitleList:getMoveElement():setPositionY(activityTitleList:getMinPosition().y)
			local visible = self:getHolidayIdRedPointStatus(v.typeId)
			tLuaObj:setReturnActivityMessage(v.title, v.activityId, v.typeId, visible)
			tLuaObj:setFuncTitleItem(function(activityId, _type)
				self:setTouchTitleChange(activityId, _type)
			end)
		end
	end
	self:setTouchTitleChange(activityId, activityType)
end
local title_name = {
	[7014] = LocalStrings.ACTIVITY_TEXT26,
	[7015] = LocalStrings.ACTIVITY_TEXT27,
	[7016] = LocalStrings.ACTIVITY_TEXT28,
	[7017] = LocalStrings.ACTIVITY_TEXT29,
}
function WndReturnActivityMain:setTouchTitleChange(activityId, _type)
	if self.m_nCurIndex == _type then return end
	GetElement(self.m_root,"txtActivityName",WZUILabelTTF):setText(title_name[_type])

	if self.m_sTouchTitleItem ~= nil then
		self.m_sTouchTitleItem:setItemNormal()
	end
	self.m_sTouchTitleItem = self.m_tReturnTitleCellIten[_type]
	if self.m_sTouchTitleItem ~= nil then
		self.m_sTouchTitleItem:setItemSelect()
	end

	if self.m_sCurReturnActivityPanel ~= nil then
		if self.m_sCurReturnActivityPanel.setVisibleStatus then
			self.m_sCurReturnActivityPanel:setVisibleStatus(false)
		end
		self.m_sCurReturnActivityPanel = nil
	end
	
	local activityPanel = GetElement(self.m_root,"item_container",WZUIContainer)
	local activity_info = self:getReturnActivityData(_type)
	if not activity_info then return end

	local view = WndReturnActivityMain.Panel[_type]
	if self.m_tReturnActivityPanel[_type] == nil then
        if _G[view] then
            local element, tObj = (_G[view]):createElement()
            self.m_tReturnActivityPanel[_type] = tObj
            if tObj.setActivityIdORType then
	            tObj:setActivityIdORType(activityId, _type)
	        end
            activityPanel:addChild(element)
        end
	end
	self.m_sCurReturnActivityPanel = self.m_tReturnActivityPanel[_type]
	if self.m_sCurReturnActivityPanel then
		if self.m_sCurReturnActivityPanel.setVisibleStatus then
			self.m_sCurReturnActivityPanel:setVisibleStatus(true)
		end
	end
	self.m_nCurIndex = _type
end

--处理红点显示
function WndReturnActivityMain:setReturnHolidayTitleItemRedPoint(_type,visible)
	if not self.m_root then return end

	if self.m_tReturnTitleCellIten and self.m_tReturnTitleCellIten[_type] then
		self.m_tReturnTitleCellIten[_type]:setItemRedPoint(visible)
	end
end

function WndReturnActivityMain:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndReturnActivityMain:_onGetActivityTitleInfo(types,type2,activityId,title,startTime,endTime,ui_id,ui_res)
	if not type2 then return end
	for i,v in pairs(type2) do
		if v == 11 and types[i] > 0 then --回归活动
			local data = {}
			data.typeId = types[i]
			data.activityId = activityId[i]
			data.title = title[i]
			data.startTime = startTime[i]
			data.endTime = endTime[i]
			data.client_id = ui_id[i]
			data.client_res = ui_res[i]
			self:setReturnActivityData(data)
		end
	end

	self:initShow()
end




-------------------------------------私有方法模块End----------------------------------------
