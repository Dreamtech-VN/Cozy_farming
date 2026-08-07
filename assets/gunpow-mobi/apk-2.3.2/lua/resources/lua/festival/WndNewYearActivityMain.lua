--WndNewYearActivityMain.lua
--@brief	WndNewYearActivityMain的UI模块
--@date		2020/12/24
--@author	hyx
--@note		2021新年活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndNewYearActivityMain:onEnter(element)
	self.m_root = element
	self:register()

    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndNewYearActivityMain:onExit(element)
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
end
function WndNewYearActivityMain:register()
	Protocol:reg( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityListInfoOK, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityListInfoOK", "vivsviviivivivivsvivs")
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetActivityTitleName,self._onGetActivityTitleInfo,self)
end
function WndNewYearActivityMain:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetActivityTitleName,self._onGetActivityTitleInfo,self)
end
--根据活动的id来进行跳转界面
--typeId 如果不传就默认第一个
function WndNewYearActivityMain:showInterface(typeId)
	local wndNewYear = WndNewYearActivityMain:createElement(typeId)
	if wndNewYear then
	    WindowManager:addWindow(wndNewYear,WndNewYearActivityMain,nil,false)
	end	
end

function WndNewYearActivityMain:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndNewYearActivityMain:actionCallback()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo(10)
	ProtocolProcessorFestivalActivity:regAll6()
end

function WndNewYearActivityMain:initShow()
	local activityTitleList = GetElement(self.m_root,"activityTitleList",WZUIFreeListContainer)
	if not activityTitleList then return end

	local configInfo = self:getNewYearActivityData()
	if not configInfo or next(configInfo) == nil then return end

	local activityId, activityType = nil --
	local default_index = nil --当找不到活动id的时候就会默认显示第一个
	for i,v in pairs(configInfo) do
		if not default_index then
			default_index = v.typeId
		end
		if v.typeId == self.m_nTurnActivityTypeID then
			activityId = v.activityId
			activityType = v.typeId
			break
		end
	end
	if activityId == nil then
		activityId = configInfo[default_index].activityId
		activityType = configInfo[default_index].typeId
	end
	for i,v in pairs(configInfo) do
		if self.m_tTitleCellIten[i] == nil then
			local element, tLuaObj = CellNewYearTitleItem:createElement(activityType)
			self.m_tTitleCellIten[i] = tLuaObj
			activityTitleList:pushBack(WZUIContainer:luaTo(element))
			activityTitleList:getMoveElement():setPositionY(activityTitleList:getMinPosition().y)
			local visible = self:getHolidayIdRedPointStatus(v.typeId)
			tLuaObj:setNewYearActivityMessage(v.title, v.activityId, v.typeId, visible)
			tLuaObj:setFuncTitleItem(function(activityId, _type)
				self:setTouchTitleChange(activityId, _type)
			end)
		end
	end
	self:setTouchTitleChange(activityId, activityType)
end

function WndNewYearActivityMain:setTouchTitleChange(activityId, _type)
	--WZLog("WndNewYearActivityMain:setTouchTitleChange", activityId, _type)
	if self.m_nCurIndex == _type then return end

	if self.m_sTouchTitleItem ~= nil then
		self.m_sTouchTitleItem:setItemNormal()
	end
	self.m_sTouchTitleItem = self.m_tTitleCellIten[_type]
	if self.m_sTouchTitleItem ~= nil then
		self.m_sTouchTitleItem:setItemSelect()
	end

	if self.m_sCurNewYearActivityPanel ~= nil then
		if self.m_sCurNewYearActivityPanel.setVisibleStatus then
			self.m_sCurNewYearActivityPanel:setVisibleStatus(false)
		end
		self.m_sCurNewYearActivityPanel = nil
	end
	
	local activityPanel = GetElement(self.m_root,"activityPanel",WZUIContainer)
	local activity_info = self:getNewYearActivityData(_type)
	if not activity_info then return end

	local view = WndNewYearActivityMain.WndNewYearActivityPanel[activity_info.client_id]
	if self.m_tActivityPanel[_type] == nil then
        if _G[view] then
            local element, tObj = (_G[view]):createElement()
            self.m_tActivityPanel[_type] = tObj
            if tObj.setActivityIdORType then
	            tObj:setActivityIdORType(activityId, _type)
	        end
            activityPanel:addChild(element)
        end
	end
	self.m_sCurNewYearActivityPanel = self.m_tActivityPanel[_type]
	if self.m_sCurNewYearActivityPanel then
		if self.m_sCurNewYearActivityPanel.setVisibleStatus then
			self.m_sCurNewYearActivityPanel:setVisibleStatus(true)
		end
	end
	self:setActivityTime(_type)
	self.m_nCurIndex = _type

	-- local title_img = GetElement(self.m_root,"title_img",WZUIImage)
	-- if title_img then
	-- 	local imgName = ""
	-- 	if self.m_nCurIndex == 7004 then
	-- 		imgName = "ui/festival/hd_pic_6znq_title_sb.png" --手办
	-- 	elseif self.m_nCurIndex == 7005 then
	-- 		imgName = "ui/festival/hd_pic_7znq_title_yh.png" --庆典-烟花
	-- 	elseif self.m_nCurIndex == 7006 then
	-- 		imgName = "ui/festival/hd_pic_7znq_title_kh.png" --爆爆-狂欢
	-- 	elseif self.m_nCurIndex == 7007 then
	-- 		imgName = "ui/festival/hd_pic_7znq_title_hl.png" --
	-- 	elseif self.m_nCurIndex == 7011 then
	-- 		imgName = "ui/festival/hd_pic_7znq_title_hl.png" --福利-贺礼
	-- 	end
	-- 	title_img:setFile(imgName)
	-- end
end
--活动时间
function WndNewYearActivityMain:setActivityTime(_typeID)
	local activity_time = GetElement(self.m_root,"activity_time",WZUILabelTTF)
	if activity_time then
		local time_info = self:getNewYearActivityData(_typeID)
		if time_info then
			local _start = SystemTime:getTimeConverLocal(time_info.startTime)
			local _end = SystemTime:getTimeConverLocal3(time_info.endTime)
			local tStartTime = SystemTime:getTimeTabelByServerTimestamp(time_info.startTime)
			_start = tStartTime.year .. "." .. tStartTime.month .. "." .. tStartTime.day .. " " .. string.format("%02d",tStartTime.hour) .. ":" .. string.format("%02d",tStartTime.min) .. ":" .. string.format("%02d",tStartTime.sec)
			local tEndTime = SystemTime:getTimeTabelByServerTimestamp(time_info.endTime)
			_end = tEndTime.year .. "." .. tEndTime.month .. "." .. tEndTime.day .. " " .. string.format("%02d",tEndTime.hour) .. ":" .. string.format("%02d",tEndTime.min) .. ":" .. string.format("%02d",tEndTime.sec)
			activity_time:setText(_start.."-".._end)
		end
	end
end
function WndNewYearActivityMain:onBtnClickRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_nCurIndex then return end

	local rule_text = nil
	if self.m_nCurIndex == 7004 then
		rule_text = LocalStrings.NEWYEAR_TEXT1 --新年充值
	elseif self.m_nCurIndex == 7005 then
		rule_text = LocalStrings.NEWYEAR_TEXT2 --新年祈福
	elseif self.m_nCurIndex == 7006 then
		rule_text = LocalStrings.NEWYEAR_TEXT3 --新年红包
	elseif self.m_nCurIndex == 7007 then
		rule_text = LocalStrings.NEWYEAR_TEXT4 --新年商城
	elseif self.m_nCurIndex == 7011 then
		rule_text = LocalStrings.NEWYEAR_TEXT24 --签到
	end
	if rule_text then
   		WndSingleMapDesc:showInterface(rule_text)
   	end
end

--处理红点显示
function WndNewYearActivityMain:setHolidayTitleItemRedPoint(_type,visible)
	if self.m_tTitleCellIten and self.m_tTitleCellIten[_type] then
		self.m_tTitleCellIten[_type]:setItemRedPoint(visible)
	end
end

function WndNewYearActivityMain:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndNewYearActivityMain:_onGetActivityTitleInfo(types,type2,activityId,title,startTime,endTime,ui_id,ui_res)
	if not type2 then return end
    for i,v in pairs(type2) do
	    if v == 10 then --新年活动
	        local data = {}
	        data.typeId = types[i]
	        data.activityId = activityId[i]
	        data.title = title[i]
	        data.startTime = startTime[i]
	        data.endTime = endTime[i]
	        data.client_id = ui_id[i]
	        data.client_res = ui_res[i]
	        WndNewYearActivityMain:setNewYearActivityData(data)
	    end
	end
	self:initShow()
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------

function CellNewYearTitleItem:_adaptLanguage_vn()
	local title_name = GetElement(self.m_root,"title_name",WZUILabelTTF)
	title_name:setScale(0.7)
	title_name:setDimensions(GlobalMethod:CCSize(220,0))
end

-------------------------------------语言适配End----------------------------------------