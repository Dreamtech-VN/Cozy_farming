--WndCommunityBossWarRank.lua
--@brief	WndCommunityBossWarRank的UI模块
--@date		2017/01/18
--@note		公会Boss战绩排行

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityBossWarRank:onEnter(element)
	self.m_root = element

	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()

	ProtocolProcessorSceneCommunity:regProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildOk", "isiissivi")
	ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildBossRank(self.pageNumber )
end

--@brief onEnter函数执行完成回调
function WndCommunityBossWarRank:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, nil, nil)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityBossWarRank:onExit(element)
	self:_unInit()
	ProtocolProcessorSceneCommunity:unregProtocolCallbackFunction( Protocol.MAIN_GUILD, Protocol.GUILD_GetGuildOk, "ProtocolProcessorSceneCommunity:parse_GUILD_GetGuildOk", "isiissivi")
end


--@brief	关闭按钮
function WndCommunityBossWarRank:OnCloseClick(element)
	WZLog("WndCommunityBossWarRank:OnCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityBossWarRank, true)
	end 
end


--@brief	公会信息查看
function WndCommunityBossWarRank:checkGuildInfo(guildId)
	WZLog("WndCommunityBossWarRank:checkGuildInfo")
	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()

	--获取并显示公会信息
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuild(guildId)
end

--@brief    取得公会信息
function WndCommunityBossWarRank:getCommunityInfoOk(id, name, level, members, chairman, desc, totemLevel, warRank, rank, declaration, prestige, setting)
    WZLog("WndCommunityBossWarRank:getCommunityInfoOk", Serialize(VectorToTable(warRank)))
    --弹出公会信息窗口
    local wndCommunityInfo = WndCommunityInfo:createElement()
    WindowManager:addWindow(wndCommunityInfo, WndCommunityInfo)
    local bHaveEnemyComminityInfo = false
    --设置公会内容
    WndCommunityInfo:setFreeconText(name,tostring(id),chairman, tostring(level),tostring(members),totemLevel,0,desc,bHaveEnemyComminityInfo,VectorToTable(warRank))

    --设置通告栏内容
    WndCommunityInfo:setFreeconsCommunityDeclareText(desc)
    --设置申请入会按钮是否可用
    local guildId = CacheCenter:getPlayerInfo().guildId
    if guildId ~= nil and guildId > 0 then
        WndCommunityInfo:setJoinCommunityBtnEnable(false)
    end
	if CacheCenter:getPlayerInfo().level < tonumber(setting) then
		WndCommunityInfo:setJoinCommunityBtnEnable(false)
	end
    --取消圆圈的转动效果
    self:_stopLoading()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	刷新列表
function WndCommunityBossWarRank:_update()

	local conFirstPass = GetElement(self.m_root,"conFirstPass_WndCommunityBossWarRank",WZUIContainer)
	if self.m_tFirstGuildData.guildId and self.m_tFirstGuildData.guildId > 0 then
		removeShowPanelNullTip(conFirstPass)

		local cell,tCell = CellCommunityBossWarRank:createElement()
		tCell:setRank(self.m_tFirstGuildData)
		conFirstPass:addChild(cell)
	else
		ShowPanelNullTip(conFirstPass)
	end

	local template = nil
	for k,v in pairs(GDatatab_guild_boss_map) do
		if v.section == self.pageNumber then
			template = v
			break
		end
	end
	if template then
		GetElement(self.m_root,"labTitle_WndCommunityBossWarRank",WZUILabelTTF):setText(template.section_name)
	end
	local con = GetElement(self.m_root,"conTab_WndCommunityBossWarRank",WZUITableContainer)
	con:cleanTable()
	local conForTab = GetElement(self.m_root, "conForTab_WndCommunityBossWarRank", WZUIContainer)
	if self.m_tDataList == nil or #self.m_tDataList == 0 then
        ShowPanelNullTip(conForTab)
    else 
    	removeShowPanelNullTip(conForTab)
		for i = 1 ,#self.m_tDataList do
			local cell,tCell = CellCommunityBossWarRank:createElement()
			cell:setTag(i-1)
			con:setCellElement(cell)
			tCell:setRank(self.m_tDataList[i])
		end 
    end
end

-------------------------------------私有方法模块End----------------------------------------
