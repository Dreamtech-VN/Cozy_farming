--CellCommunityBossWarRank.lua
--@brief	CellCommunityBossWarRank的UI模块
--@date		2017/01/18
--@note		公会Boss战绩排行Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityBossWarRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityBossWarRank:onExit(element)
	self:_unInit()
end

--@brief	点击列表弹出公会信息
function CellCommunityBossWarRank:onBtnClick(element)
	WZLog("CellCommunityBossWarRank:onBtnClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--获取并显示公会信息
	WndCommunityBossWarRank:checkGuildInfo(self.m_tData.guildId)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置排名信息
function CellCommunityBossWarRank:setRank(tData)
	WZLog("CellCommunityBossWarRank:setRank")
	self.m_tData = tData
	if tData.isFirst then
		GetElement(self.m_root,"imgFirstFlag_CellCommunityBossWarRank",WZUIImage):setVisible(true)
		GetElement(self.m_root,"atlasGuildIndex_CellCommunityBossWarRank",WZUILabelAtlasFont):setVisible(false)
		GetElement(self.m_root,"imgRanking_CellCommunityBossWarRank",WZUIImage):setVisible(false)
	else
		GetElement(self.m_root,"imgFirstFlag_CellCommunityBossWarRank",WZUIImage):setVisible(false)
	end
	if not tData.isFirst and self.m_tData.guildId == CacheCenter:getPlayerInfo().guildId then
		GetElement(self.m_root,"imgBg_CellCommunityBossWarRank",WZUI9Image):setFile("ui/common/common_scale9_di96.png")
	else
		GetElement(self.m_root,"imgBg_CellCommunityBossWarRank",WZUI9Image):setFile("ui/common/common_scale9_di7.png")
	end
	
	GetElement(self.m_root,"labGuildName_CellCommunityBossWarRank",WZUILabelTTF):setText(tData.guildName)
	GetElement(self.m_root,"labGuildLv_CellCommunityBossWarRank",WZUILabelTTF):setText("Lv"..tData.guildLv)
	local timeStr = ""
	if tData.isFirst then
		timeStr = tData.useTimeStr
	else
		local time = tData.useTime / 60
		local hour = math.floor(time /60)
		local minute = time - hour*60
		timeStr = string.format(LocalStrings.GUILD_BOSS_PASS_TIME,hour,minute)
	end
	GetElement(self.m_root,"labKillTime_CellCommunityBossWarRank",WZUILabelTTF):setText(timeStr)
	GetElement(self.m_root,"atlasGuildIndex_CellCommunityBossWarRank",WZUILabelAtlasFont):setText(tData.rankIndex)

	self:setRankTitle(tData.rankIndex)
end

--@brief	设置排名
function CellCommunityBossWarRank:setRankTitle(rank)
	local rank = tonumber(rank)
	if rank == 1 or rank == 2 or rank == 3 then
		local rankFile = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
		GetElement(self.m_root,"atlasGuildIndex_CellCommunityBossWarRank",WZUILabelAtlasFont):setVisible(false)
		GetElement(self.m_root,"imgRanking_CellCommunityBossWarRank",WZUIImage):setVisible(true)
		GetElement(self.m_root,"imgRanking_CellCommunityBossWarRank",WZUIImage):setFile(rankFile[rank])
	else
		GetElement(self.m_root,"atlasGuildIndex_CellCommunityBossWarRank",WZUILabelAtlasFont):setVisible(true)
		GetElement(self.m_root,"imgRanking_CellCommunityBossWarRank",WZUIImage):setVisible(false)
	end
end

-------------------------------------私有方法模块End----------------------------------------
