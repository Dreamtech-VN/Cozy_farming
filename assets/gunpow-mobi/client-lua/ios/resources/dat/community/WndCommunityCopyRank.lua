--WndCommunityCopyRank.lua
--@brief	WndCommunityCopyRank的UI模块
--@date		2017/11/22
--@author	zsq
--@note		公会副本伤害排名


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityCopyRank:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function WndCommunityCopyRank:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
	local guildId = CacheCenter:getGuildInfo().guildId
	local mapId = self.m_nCopyId 

	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildBossHurtRank(guildId, mapId)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityCopyRank:onExit(element)
	self:_unInit()
end

function WndCommunityCopyRank:show(nCopyId) 
	WZLog("WndCommunityCopyRank:show", nCopyId)
    local wnd = WndCommunityCopyRank:createElement()
    if wnd then
    	self.m_nCopyId = nCopyId
    	WindowManager:addWindow(wnd, WndCommunityCopyRank)
    end
end

function WndCommunityCopyRank:onClose(element) 
	WZLog("WndCommunityCopyRank:onClose")
  	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击上一个boss按钮回调
function WndCommunityCopyRank:onClickLast(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local guildId = CacheCenter:getGuildInfo().guildId
	if self.m_nCopyId > 1 then
		self.m_nCopyId = self.m_nCopyId - 1
	end

	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildBossHurtRank(guildId, self.m_nCopyId)
end

--@brief 	点击下一个boss按钮回调
function WndCommunityCopyRank:onClickNext(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local guildId = CacheCenter:getGuildInfo().guildId

	if SceneCommunityCopy.m_root then 
		if self.m_nCopyId < SceneCommunityCopy.m_tCommunityCopyInfo.bossId then
			self.m_nCopyId = self.m_nCopyId + 1
		end
	elseif SceneCommunityBossInfo.m_root then
		if self.m_nCopyId < SceneCommunityBossInfo.m_nCopyId then
			self.m_nCopyId = self.m_nCopyId + 1
		end
	end

	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildBossHurtRank(guildId, self.m_nCopyId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndCommunityCopyRank:_update() 
	WZLog("WndCommunityCopyRank:_update")
	local freeListContainer = GetElement(self.m_root,"conFree_WndCommunityCopyRank",WZUIFreeListContainer)
	freeListContainer:removeAll()

	self:_setLastOrNextBtnVisible()
	local txtTipsName = GetElement(self.m_root, "txtTipsName_WndSelectTipsStrengthen", WZUILabelTTF)
	if txtTipsName then
		local tCopyData = GDatatab_guild_boss_map["id_" .. self.m_nCopyId]
		if tCopyData then
			txtTipsName:setText(tCopyData.map_name .. LocalStrings.DAILYRESET3)
		else
			txtTipsName:setText(LocalStrings.DAILYRESET3)
		end
	end
	--没有数据时显示提示
	if self.m_tDataList == nil or #self.m_tDataList == 0 then 
		ShowPanelNullTip(freeListContainer,LocalStrings.CRANK2,GlobalMethod:ccc3(255,236,193))
	else
		removeShowPanelNullTip(freeListContainer)
	end

	for i=1,#self.m_tDataList do
		local celElement,tCell = CellCommunityCopyRank:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tDataList[i])
			freeListContainer:pushBack(celElement)
		end 
	end
	freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
end

--@brief 	设置向前向后翻的按钮的显示与否
function WndCommunityCopyRank:_setLastOrNextBtnVisible()
	-- body
	local btnLastBoss = GetElement(self.m_root, "btnLastBoss_WndCommunityCopyRank", WZUIButton)
	local btnNextBoss = GetElement(self.m_root, "btnNextBoss_WndCommunityCopyRank", WZUIButton)

	if self.m_nCopyId <= 1 then
		btnLastBoss:setVisible(false)
	else
		btnLastBoss:setVisible(true)
	end
	if SceneCommunityCopy.m_root then
		if self.m_nCopyId >= SceneCommunityCopy.m_tCommunityCopyInfo.bossId then
			btnNextBoss:setVisible(false)
		else
			btnNextBoss:setVisible(true)
		end
	elseif SceneCommunityBossInfo.m_root then
		if self.m_nCopyId >= SceneCommunityBossInfo.m_nCopyId then
			btnNextBoss:setVisible(false)
		else
			btnNextBoss:setVisible(true)
		end
	end
end



-------------------------------------私有方法模块End----------------------------------------

function WndCommunityCopyRank:_adaptLanguage_en(  )
	local txtTitle1 = GetElement(self.m_root,"txtTitle1_WndCommunityCopyRank",WZUILabelTTF)
	txtTitle1:setScale(0.8)
	txtTitle1:setDimensions(GlobalMethod:CCSize(120))
	local txtTitle2 = GetElement(self.m_root,"txtTitle2_WndCommunityCopyRank",WZUILabelTTF)
	txtTitle2:setScale(0.8)
	txtTitle2:setDimensions(GlobalMethod:CCSize(120))
	local txtTitle3 = GetElement(self.m_root,"txtTitle3_WndCommunityCopyRank",WZUILabelTTF)
	txtTitle3:setScale(0.8)
	txtTitle3:setDimensions(GlobalMethod:CCSize(120))
	local txtTitle4 = GetElement(self.m_root,"txtTitle4_WndCommunityCopyRank",WZUILabelTTF)
	txtTitle4:setScale(0.8)
	txtTitle4:setDimensions(GlobalMethod:CCSize(120))
end

function WndCommunityCopyRank:_adaptLanguage_es(  )
	local txtTitle1 = GetElement(self.m_root,"txtTitle1_WndCommunityCopyRank",WZUILabelTTF)
	txtTitle1:setScale(0.8)
	txtTitle1:setDimensions(GlobalMethod:CCSize(120))
	local txtTitle2 = GetElement(self.m_root,"txtTitle2_WndCommunityCopyRank",WZUILabelTTF)
	txtTitle2:setScale(0.8)
	txtTitle2:setDimensions(GlobalMethod:CCSize(120))
	local txtTitle3 = GetElement(self.m_root,"txtTitle3_WndCommunityCopyRank",WZUILabelTTF)
	txtTitle3:setScale(0.8)
	txtTitle3:setDimensions(GlobalMethod:CCSize(120))
	local txtTitle4 = GetElement(self.m_root,"txtTitle4_WndCommunityCopyRank",WZUILabelTTF)
	txtTitle4:setScale(0.8)
	txtTitle4:setDimensions(GlobalMethod:CCSize(120))
end

function WndCommunityCopyRank:_adaptLanguage_pt(  )
	local txtTitle1 = GetElement(self.m_root,"txtTitle1_WndCommunityCopyRank",WZUILabelTTF)
	txtTitle1:setScale(0.8)
	txtTitle1:setDimensions(GlobalMethod:CCSize(120))
	local txtTitle2 = GetElement(self.m_root,"txtTitle2_WndCommunityCopyRank",WZUILabelTTF)
	txtTitle2:setScale(0.8)
	txtTitle2:setDimensions(GlobalMethod:CCSize(120))
	local txtTitle3 = GetElement(self.m_root,"txtTitle3_WndCommunityCopyRank",WZUILabelTTF)
	txtTitle3:setScale(0.8)
	txtTitle3:setDimensions(GlobalMethod:CCSize(120))
	local txtTitle4 = GetElement(self.m_root,"txtTitle4_WndCommunityCopyRank",WZUILabelTTF)
	txtTitle4:setScale(0.8)
	txtTitle4:setDimensions(GlobalMethod:CCSize(120))
end