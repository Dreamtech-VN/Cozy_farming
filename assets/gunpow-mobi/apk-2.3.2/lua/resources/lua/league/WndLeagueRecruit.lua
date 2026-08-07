--WndLeagueRecruit.lua
--@brief	WndLeagueRecruit的UI模块
--@date		2016/06/14
--@author	zsq
--@note		战队审批


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLeagueRecruit:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function WndLeagueRecruit:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

function WndLeagueRecruit:actionCallback(element, data)
	--self:update()
	ProtocolProcessorWndLeague:send_HERO_GetApplyList()
end

--@brief	显示接口
function WndLeagueRecruit:show()
	WZLog("WndLeagueRecruit:show")
	if self.m_root == nil then 
		local wnd = WndLeagueRecruit:createElement()
		WindowManager:addWindow(wnd, WndLeagueRecruit, nil, nil, true)
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLeagueRecruit:onExit(element)
	self:_unInit()
end

function WndLeagueRecruit:onClose()
	WZLog("WndLeagueRecruit:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief	审核同意
function WndLeagueRecruit:onAgree()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--队伍已经有4人，提示返回
	if #WndLeagueTeamDetail.m_tDataList >= 4 then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE44)
		return 
	end 
	if self.m_tID == nil then return end
    local id = WZLuaVector_int_:create()
	for i=1,#self.m_tID do
       	id:push(self.m_tID[i])
	end
	WZLog("WndLeagueRecruit:onAgree",Serialize(VectorToTable(id)))
	if id:size() == 0 then
		return
	end
	ProtocolProcessorWndLeague:send_HERO_Reviewed(id, 1 )
	--管理红点  审批全部申请时，去掉红点
	if id:size() >= #self.m_tDataList then
		WndLeagueTeamDetail.m_bNeedRecruit = false
		GetElement(WndLeagueTeamDetail.m_root,"imgRed",WZUIImage):setVisible(false)
	end
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief	审核拒绝
function WndLeagueRecruit:onRefuse()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndLeagueRecruit:onAgree")
	if self.m_tID == nil then return end
    local id = WZLuaVector_int_:create()
	for i=1,#self.m_tID do
       	id:push(self.m_tID[i])
	end
	if id:size() == 0 then
		return
	end
	ProtocolProcessorWndLeague:send_HERO_Reviewed(id, 2 )
	--管理红点  审批全部申请时，去掉红点
	if id:size() >= #self.m_tDataList then
		WndLeagueTeamDetail.m_bNeedRecruit = false
		GetElement(WndLeagueTeamDetail.m_root,"imgRed",WZUIImage):setVisible(false)
	end
    WindowManager:removeWindow(self.m_root , self , true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndLeagueRecruit:update()
	WZLog("WndLeagueRecruit:update")
	if self.m_root == nil then return end 
	local freeListContainer = GetElement(self.m_root,"freeCon_WndLeagueRecruit",WZUIFreeListContainer)
	freeListContainer:removeAll()

	--没有数据时显示提示
	if self.m_tDataList == nil or #self.m_tDataList == 0 then 
		ShowPanelNullTip(freeListContainer,nil,GlobalMethod:ccc3(195,171,148))
		WndLeagueTeamDetail.m_bNeedRecruit = false
		GetElement(WndLeagueTeamDetail.m_root,"imgRed",WZUIImage):setVisible(false)
	else
		removeShowPanelNullTip(freeListContainer)
	end

	for i=1,#self.m_tDataList do
		local celElement,tCell = CellLeagueRecruit:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tDataList[i])
			freeListContainer:pushBack(celElement)
			freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
		end 
	end

	GetElement(self.m_root,"ttfNumber",WZUILabelTTF):setText(#WndLeagueTeamDetail.m_tDataList.."/4")
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-----------------------------------------
function WndLeagueRecruit:_adaptLanguage_vn(  )
	GetElement(self.m_root,"ttfNumber",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.25,0.843))
end
-------------------------------------语言适配End--------------------------------------------