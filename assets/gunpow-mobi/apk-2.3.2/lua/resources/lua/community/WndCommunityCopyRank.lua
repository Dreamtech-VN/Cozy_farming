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
	local guildId = CacheCenter:getGuildInfo().guildId
	local mapId = self.m_nCopyId 
	local txtPlayerHurt = GetElement(self.m_root, "txtPlayerHurt_WndCommunityCopyRank", WZUILabelTTF)
	if txtPlayerHurt then
		txtPlayerHurt:setText(LocalStrings.CHARM_PLAYER .. "/" .. LocalStrings.CRANK1)
	end

	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildBossHurtRank(guildId, mapId)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityCopyRank:onExit(element)
	self:_unInit()
end

function WndCommunityCopyRank:show(nCopyId, parentNode) 
	WZLog("WndCommunityCopyRank:show", nCopyId)
	if WndCommunityCopyRank.m_root then 
		local guildId = CacheCenter:getGuildInfo().guildId
		self.m_nCopyId = nCopyId
		ProtocolProcessorSceneCommunity:send_GUILD_GetGuildBossHurtRank(guildId, nCopyId)
	else
	    local wnd = WndCommunityCopyRank:createElement()
	    if wnd then
	    	self.m_nCopyId = nCopyId
	    	parentNode:addChild(wnd)
	    end
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

	--没有数据时显示提示
	if self.m_tDataList == nil or #self.m_tDataList == 0 then 
		ShowPanelNullTip(freeListContainer,LocalStrings.CRANK2,GlobalMethod:ccc3(138,122,106))
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

-------------------------------------私有方法模块End----------------------------------------

function WndCommunityCopyRank:_adaptLanguage_en(  )
end

function WndCommunityCopyRank:_adaptLanguage_es(  )
end

function WndCommunityCopyRank:_adaptLanguage_pt(  )
end