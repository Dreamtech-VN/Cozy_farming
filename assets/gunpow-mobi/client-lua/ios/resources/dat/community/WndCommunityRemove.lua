--WndCommunityRemove.lua
--@brief	WndCommunityRemove的UI模块
--@date		2017/05/29
--@author	zsq
--@note		移除成员


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityRemove:onEnter(element)
	self.m_root = element
end

--@brief onEnter函数执行完成回调
function WndCommunityRemove:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, nil, nil)
	self:update()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityRemove:onExit(element)
	self:_unInit()
end

function WndCommunityRemove:onClose() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityRemove, true)
	end 
end

function WndCommunityRemove:show() 
	local wnd = WndCommunityRemove:createElement()
	WindowManager:addWindow(wnd,WndCommunityRemove)
end


function WndCommunityRemove:onCondition1(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_root:enableSchedule("updateTab",0)
end

function WndCommunityRemove:onCondition2(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_root:enableSchedule("updateTab",0)
end

function WndCommunityRemove:onCondition3(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_root:enableSchedule("updateTab",0)
end

function WndCommunityRemove:updateTab() 
	self.m_root:disableSchedule()
    --刷新列表会员队伍状态
	local con = GetElement(self.m_root,"freeconText_Wnd",WZUIFreeListContainer)
    local nCurPositionY = con:getMoveElement():getPositionY()
    local tLastSize = con:getMoveElement():getContentSize()

    self:update()

    --重新设置列表的位置
    local tCurSize = con:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > con:getMaxPosition().y then
        nTempPositionY = con:getMaxPosition().y
    end
    con:getMoveElement():setPositionY(nTempPositionY)
end

function WndCommunityRemove:onSure() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local selected = 0
		for i=1,#self.m_tCellList do
			if self.m_tCellList[i]:isSelected() then
				selected = selected + 1
			end
		end
	if selected == 0 then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_CHOOSE_PLAYER)
		return 
	end
	MsgBoxManager:showConfirmCancelBox(LocalStrings.NEWCOMMUNITY6, self, self.onSureCall, MSGBOXLEVEL_HIGH,nil)
end

function WndCommunityRemove:onSureCall(nId, nResType) 
	WZLog("WndCommunityRemove:onSureCall")
    if nResType == MSGBOXRESTYPE_CONFIRM then
    	local ids = WZLuaVector_int_:create()
		for i=1,#self.m_tCellList do
			if self.m_tCellList[i]:isSelected() then
				ids:push(self.m_tCellList[i].playerId)
			end
		end
		WZLog("删除id",Serialize(VectorToTable(ids)))
		ProtocolProcessorSceneCommunity:send_GUILD_ExpelMember(ids )
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndCommunityRemove:update() 
	if self.m_root == nil then return end
	WZLog("WndCommunityRemove:update", #SceneMemberList.m_tMemberList)
	local con = GetElement(self.m_root,"freeconText_Wnd",WZUIFreeListContainer)
	con:removeAll()
	removeShowPanelNullTip(con)

	--是否选中
	local condition1 = tonumber(GetElement(WndCommunityRemove.m_root,"condition1",WZUICheckBox):getCheckIndex())
	local condition2 = tonumber(GetElement(WndCommunityRemove.m_root,"condition2",WZUICheckBox):getCheckIndex())
	local condition3 = tonumber(GetElement(WndCommunityRemove.m_root,"condition3",WZUICheckBox):getCheckIndex())

	local celElement,tCell
	local num = 0
	local myPosition = tonumber(CacheCenter:getPlayerInfo().position)
	self.m_tCellList = {}
	local tDataList = CopyTable(SceneMemberList.m_tMemberList)
	local sortData = function(a, b)
		if a.onLine ~= b.onLine then
			return a.onLine > b.onLine
		else
			if a.weekDonate ~= b.weekDonate then
				return a.onLine < b.onLine
			else
				if a.todayContribution ~= b.todayContribution then
					return a.todayContribution < b.todayContribution
				else
					if a.fight ~= b.fight then
						return a.fight < b.fight
					else
						if a.playerLevel ~= b.playerLevel then
							return a.playerLevel < b.playerLevel
						else
							if a.position ~= b.position then
								return a.position < b.position
							else
								return a.playerId > b.playerId
							end
						end
					end
				end
			end
		end
	end
	table.sort(tDataList, sortData)

	for i=1,#tDataList do
		local position = tDataList[i].position

		if myPosition > position then
			celElement,tCell =  CellCommunityRemove:createElement()
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(tDataList[i])
			con:pushBack(celElement)
			table.insert(self.m_tCellList, tCell)
			num = num + 1

			local t = tDataList[i].onLine
			local tt = (SystemTime:getServerTime() - t)
			local dt = tDataList[i].donateTime
			local dtt = (SystemTime:getServerTime() - dt)
			WZLog("状态",condition1,condition2,condition3,t,tt,dt,dtt,position)
			WZLog("贡献时间",dt,dtt)
			if ((condition1 == 0) or tt>86400*3) and ((condition2 == 0) or dtt>86400*3) and ((condition3 == 0) or position<2) then
				WZLog("可可",condition3,position)
				tCell.isSelect = true
				if (condition1 == 0) and (condition2 == 0) and (condition3 == 0) then
					tCell.isSelect = false
				end
			else
				tCell.isSelect = false
			end
		end
	end
	if num == 0 then
		 ShowPanelNullTip(con)
	end
	con:getMoveElement():setPositionY(con:getMinPosition().y)
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-----------------------------------------
function WndCommunityRemove:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtTitle2_WndCommunityRemove",WZUILabelTTF):setScale(0.8)
	local txtTitle3 = GetElement(self.m_root,"txtTitle3_WndCommunityRemove",WZUILabelTTF)
	txtTitle3:setRelativePosition(GlobalMethod:ccp(0.78,0.5))

	for i=1,3 do
		local txtCondition = GetElement(self.m_root,"txtCondition"..i.."_WndCommunityRemove",WZUILabelTTF)
		txtCondition:setDimensions(GlobalMethod:CCSize(130,0))
		txtCondition:setScale(0.8)
	end
end

function WndCommunityRemove:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtTitle2_WndCommunityRemove",WZUILabelTTF):setScale(0.8)
	local txtTitle3 = GetElement(self.m_root,"txtTitle3_WndCommunityRemove",WZUILabelTTF)
	txtTitle3:setRelativePosition(GlobalMethod:ccp(0.78,0.5))

	for i=1,3 do
		local txtCondition = GetElement(self.m_root,"txtCondition"..i.."_WndCommunityRemove",WZUILabelTTF)
		txtCondition:setDimensions(GlobalMethod:CCSize(130,0))
		txtCondition:setScale(0.8)
	end
end

function WndCommunityRemove:_adaptLanguage_th(  )
	for i=1,3 do
		local txtCondition = GetElement(self.m_root,"txtCondition"..i.."_WndCommunityRemove",WZUILabelTTF)
		txtCondition:setDimensions(GlobalMethod:CCSize(130,0))
		txtCondition:setScale(0.8)
	end
end

function WndCommunityRemove:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtTitle2_WndCommunityRemove",WZUILabelTTF):setScale(0.8)
	local txtTitle3 = GetElement(self.m_root,"txtTitle3_WndCommunityRemove",WZUILabelTTF)
	txtTitle3:setRelativePosition(GlobalMethod:ccp(0.83,0.5))

	for i=1,3 do
		local txtCondition = GetElement(self.m_root,"txtCondition"..i.."_WndCommunityRemove",WZUILabelTTF)
		txtCondition:setDimensions(GlobalMethod:CCSize(130,0))
		txtCondition:setScale(0.8)
	end
end

function WndCommunityRemove:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtTitle2_WndCommunityRemove",WZUILabelTTF):setScale(0.8)
	local txtTitle3 = GetElement(self.m_root,"txtTitle3_WndCommunityRemove",WZUILabelTTF)
	txtTitle3:setRelativePosition(GlobalMethod:ccp(0.85,0.5))
	txtTitle3:setScale(0.8)

	for i=1,3 do
		local txtCondition = GetElement(self.m_root,"txtCondition"..i.."_WndCommunityRemove",WZUILabelTTF)
		if i == 3 then
			txtCondition:setDimensions(GlobalMethod:CCSize(200,0))
		else
			txtCondition:setDimensions(GlobalMethod:CCSize(130,0))
		end
		txtCondition:setScale(0.8)
	end
end

function WndCommunityRemove:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtTitle2_WndCommunityRemove",WZUILabelTTF):setScale(0.8)
	local txtTitle3 = GetElement(self.m_root,"txtTitle3_WndCommunityRemove",WZUILabelTTF)
	txtTitle3:setRelativePosition(GlobalMethod:ccp(0.83,0.5))

	for i=1,3 do
		local txtCondition = GetElement(self.m_root,"txtCondition"..i.."_WndCommunityRemove",WZUILabelTTF)
		txtCondition:setDimensions(GlobalMethod:CCSize(150,0))
		txtCondition:setScale(0.8)
	end
end
-------------------------------------语言适配End-------------------------------------------