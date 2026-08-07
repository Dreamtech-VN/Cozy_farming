--WndMidFestivalActivity.lua
--@brief	WndMidFestivalActivity的UI模块
--@date		2021/08/18
--@author	hyx
--@note		中秋活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMidFestivalActivity:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMidFestivalActivity:onExit(element)
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
end
function WndMidFestivalActivity:register()
	Protocol:reg( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityListInfoOK, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityListInfoOK", "vivsviviivivivivsvivs")
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetActivityTitleName,self._onGetActivityTitleInfo,self)
end
function WndMidFestivalActivity:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetActivityTitleName,self._onGetActivityTitleInfo,self)
end
--打开界面
function WndMidFestivalActivity:showInterface()   
	local returnActivity = WndMidFestivalActivity:createElement()
	if returnActivity ~= nil then
	    WindowManager:addWindow(returnActivity,WndMidFestivalActivity,false)
	end
end
function WndMidFestivalActivity:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function WndMidFestivalActivity:actionCallback()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo(12)
	ProtocolProcessorFestivalActivity:regAll6()
end
function WndMidFestivalActivity:initShow()
	local data = self.m_tMidFestivalActivityData
	for i=1, #data do
		local btn = GetElement(self.m_root,"btn"..data[i].client_id, WZUIButton)
		btn:setRelativePosition(ccp(0.1, 0.553 - 0.126*(i-1)))
		btn:setTag(i)
		if btn then
			local tab = {}
			tab.normal = GetElement(btn,"normal",WZUI9Image)
			tab.select = GetElement(btn,"select",WZUI9Image)
			tab.name = GetElement(btn,"name",WZUILabelTTF)
			tab.name:setText(LocalStrings.ACTIVITY_TEXT110[data[i].client_id])
			tab.redPoint = GetElement(btn,"redPoint",WZUIImage)
			local red_status = false
			if GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[data[i].typeId] then
				red_status = true
			end
			tab.redPoint:setVisible(red_status)
			self.m_tSetTitleRedPoint[i] = red_status
			self.m_tTitleItem[i] = tab
			btn:setVisible(true)
		end
	end
	self:onBtnChangeTitle(1)
end

function WndMidFestivalActivity:onBtnChangeTitle(element)
	local tag
	if type(element) == "number" then
		tag = element
	else
		tag = element:getTag()
	end
	if self.m_nSelectIndex == tag then return end
	if self.m_tTitleItem[self.m_nSelectIndex] then
		self.m_tTitleItem[self.m_nSelectIndex].normal:setVisible(true)
		self.m_tTitleItem[self.m_nSelectIndex].select:setVisible(false)
		self.m_tTitleItem[self.m_nSelectIndex].name:setEnableStroke(false)
		self.m_tTitleItem[self.m_nSelectIndex].name:setColor(ccc3(0,72,3))
	end

	if self.m_tTitleItem[tag] then
		self.m_tTitleItem[tag].normal:setVisible(false)
		self.m_tTitleItem[tag].select:setVisible(true)
		self.m_tTitleItem[tag].name:setEnableStroke(true)
		self.m_tTitleItem[tag].name:setColor(ccc3(255,250,236))
		self.m_tTitleItem[tag].name:setStrokeSize(4)
		self.m_tTitleItem[tag].name:setStrokeColor(ccc3(163,74,20))
	end

	if self.m_sCurMidFestivalActivityPanel ~= nil then
		if self.m_sCurMidFestivalActivityPanel.setVisibleStatus then
			self.m_sCurMidFestivalActivityPanel:setVisibleStatus(false)
		end
		self.m_sCurMidFestivalActivityPanel = nil
	end
	local info_data = self.m_tMidFestivalActivityData[tag]
	if not info_data then return end

	local con_panel = GetElement(self.m_root,"con_panel",WZUIContainer)
	local view = WndMidFestivalActivity.Panel[info_data.typeId]
	if self.m_tMidFestivalActivityPanel[info_data.typeId] == nil then
        if _G[view] then
            local element, tObj = (_G[view]):createElement()
            self.m_tMidFestivalActivityPanel[info_data.typeId] = tObj
            if tObj.setAcvitityData then
            	tObj:setAcvitityData(info_data)
            end
            con_panel:addChild(element)
        end
	end
	self.m_sCurMidFestivalActivityPanel = self.m_tMidFestivalActivityPanel[info_data.typeId]
	if self.m_sCurMidFestivalActivityPanel then
		if self.m_sCurMidFestivalActivityPanel.setVisibleStatus then
			self.m_sCurMidFestivalActivityPanel:setVisibleStatus(true)
		end
	end
	self.m_nSelectIndex = tag
end
--处理标签的红点
function WndMidFestivalActivity:setVisibleTitleRedPoint(visible)
	if not self.m_nSelectIndex then return end

	self.m_tTitleItem[self.m_nSelectIndex].redPoint:setVisible(visible)
	self.m_tSetTitleRedPoint[self.m_nSelectIndex] = visible
	local ststus = false
	for _,v in pairs(self.m_tSetTitleRedPoint) do
		if v == true then
			status = true
			break
		end
	end
	SceneCity:setSceneMainIconRedPoint(MIDFESTIVAL_ACTIVITY, ststus)
end
function WndMidFestivalActivity:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--点击规则按钮
function WndMidFestivalActivity:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.ACTIVITY_TEXT215)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndMidFestivalActivity:_onGetActivityTitleInfo(types,type2,activityId,title,startTime,endTime,ui_id,ui_res)
	if not type2 then return end
	if next(self.m_tMidFestivalActivityData) ~= nil then return end

	for i,v in pairs(type2) do
		if v == 12 then
			if self.m_bIsData[types[i]] == nil then
				self.m_bIsData[types[i]] = true
				self.m_nTitleIndex = self.m_nTitleIndex + 1
				local data = {}
				data.typeId = types[i]
				data.activityId = activityId[i]
				data.title = title[i]
				data.startTime = startTime[i]
				data.endTime = endTime[i]
				data.client_id = ui_id[i]
				data.client_res = ui_res[i]
				self.m_tMidFestivalActivityData[self.m_nTitleIndex] = data
			end
		end
	end
	self:initShow()
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------

function WndMidFestivalActivity:_adaptLanguage_vn()
	for i=1,3 do
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		local name = GetElement(btn,"name",WZUILabelTTF)
		name:setFontSize(16)
		name:setDimensions(GlobalMethod:CCSize(80,0))
	end
end

-------------------------------------语言适配end----------------------------------------

