--CellGVGRankList.lua
--@brief	CellGVGRankList的UI模块
--@date		2017/02/25
--@author	qixiang
--@note		出线赛与入围赛的cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGVGRankList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGVGRankList:onExit(element)
	self:_unInit()
end

function CellGVGRankList:onLoadData(element)
	-- body
	WZLog("CellGVGRankList:onLoadData")
	local txtCommName = GetElement(self.m_root,"txtCommName_CellGVGRankList",WZUILabelTTF)
	local imgRank = GetElement(self.m_root,"imgRank_CellGVGRankList",WZUIImage)
	local txtRank = GetElement(self.m_root,"txtRank_CellGVGRankList",WZUILabelTTF)
	local txtCommLong = GetElement(self.m_root,"txtCommLong_CellGVGRankList",WZUILabelTTF)
    local txtIntegral =	GetElement(self.m_root,"txtIntegral_CellGVGRankList",WZUILabelTTF)
    local txtWinningRate = GetElement(self.m_root,"txtWinningRate_CellGVGRankList",WZUILabelTTF)
    local txtPlayerInfo = GetElement(self.m_root,"txtPlayerInfo_CellGVGRankList",WZUILabelTTF)
    local imgBg = GetElement(self.m_root,"imgBg_CellGVGRankList",WZUI9Image)
	txtCommLong:setText("")
	txtRank:setText("")
	txtCommName:setText("")
	txtIntegral:setText("")
	txtWinningRate:setText("")
	imgBg:setFile("ui/common/common_scale9_di7.png")
	if self.m_nType == 1 then --全服(本服)
		local rank = self.m_tFinalistComData.rank
		if rank >= 4 then
			imgRank:setFile("")
			txtRank:setText(rank)
		else
			if rank == 1 then
				imgRank:setFile("ui/common/common_icon_1st.png")
			elseif rank == 2 then
				imgRank:setFile("ui/common/common_icon_2nd.png")
			elseif rank == 3 then
				imgRank:setFile("ui/common/common_icon_3rd.png")
			end
		end
		txtCommName:setText(self.m_tFinalistComData.name)
		local name = "(" .. self.m_tFinalistComData.commOrdername .. ")"
		txtCommLong:setText(name)
		txtIntegral:setText(self.m_tFinalistComData.integral)
		local rate = math.floor(self.m_tFinalistComData.winNum / self.m_tFinalistComData.fightNum * 100)
		local temp = string.format(LocalStrings.ATH_DESC_7,self.m_tFinalistComData.fightNum,self.m_tFinalistComData.winNum,rate)
		txtWinningRate:setText(temp)
		local playerInfo = CacheCenter:getPlayerInfo()
		if playerInfo.guildId == self.m_tFinalistComData.commNum then
			imgBg:setFile("ui/common/common_scale9_di38.png")
		end
	else  --成员
		local rank = self.m_tQualifyingData.rank
		if rank >= 4 then
			imgRank:setFile("")
			txtRank:setText(rank)
		else
			if rank == 1 then
				imgRank:setFile("ui/common/common_icon_1st.png")
			elseif rank == 2 then
				imgRank:setFile("ui/common/common_icon_2nd.png")
			elseif rank == 3 then
				imgRank:setFile("ui/common/common_icon_3rd.png")
			end
		end
		local temp = "Lv" .. self.m_tQualifyingData.level .. " " .. self.m_tQualifyingData.name
		txtPlayerInfo:setText(temp)
		txtIntegral:setText(self.m_tQualifyingData.integral)
		local rate = math.floor(self.m_tQualifyingData.winNum / self.m_tQualifyingData.fightNum * 100)
		local temp = string.format(LocalStrings.ATH_DESC_7,self.m_tQualifyingData.fightNum,self.m_tQualifyingData.winNum,rate)
		txtWinningRate:setText(temp)
		local playerInfo = CacheCenter:getPlayerInfo()
		if playerInfo.id == self.m_tQualifyingData.playerId then
			imgBg:setFile("ui/common/common_scale9_di38.png")
		end
	end
end

function CellGVGRankList:onClickPlayer(element)
	-- body
	WZLog("CellGVGRankList:onClickPlayer")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nType == 2 then
		local playerId = self.m_tQualifyingData.playerId
		if playerId then
			WndCheckOther:show(playerId)
		end
	else
		local commId = tonumber(self.m_tFinalistComData.commNum)
		WZLog("commId = ",commId)
		ProtocolProcessorSceneCommunity:send_GUILD_GetGuild(commId, 1)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
