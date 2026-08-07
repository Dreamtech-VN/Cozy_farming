--CellMagicStoneReward.lua
--@brief	CellMagicStoneReward的UI模块
--@date		2019/10/24
--@author	Tianxiang_Xu
--@note		幻石系统-奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMagicStoneReward:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMagicStoneReward:onExit(element)
	self:_unInit()
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function CellMagicStoneReward:onClickListItem(tItem, nTag, tData)
    WZLog("CellMagicStoneReward:onClickListItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root, WndMagicStone.m_root, 1, tData, false)
end

--@brief 	加载
function CellMagicStoneReward:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellMagicStoneReward")
	self.m_root:addChild(celElement)
	--更新函数
	self:_update()
end

--@brief 	加载
function CellMagicStoneReward:loadData()
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellMagicStoneReward")
	self.m_root:addChild(celElement)
	--更新函数
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellMagicStoneReward:_update()
	-- body
	local ftxtLevel = GetElement(self.m_root, "ftxtLevel_CellMagicStoneReward", WZUIFreeTextBox)
	local lvFormat = [[<T C="255,255,255" S="26" P="1">%d</T><T C="255,255,255" S="16" P="1">%s</T>]]
	if ftxtLevel then 
		local bg = GetElement(self.m_root,"bg_CellMagicStoneReward",WZUIImage)
		if self.m_nType == 1 then 
			ftxtLevel:setShowText(string.format(lvFormat, self.m_tData.lv, LocalStrings.LEVEL1))
			bg:setFile("ui/magicStone/common_sjb_lb.png")
		elseif self.m_nType == 2 then 
			ftxtLevel:setShowText(string.format(lvFormat, self.m_tData.lv, LocalStrings.LEVEL1..LocalStrings.PETSHOW))
			bg:setFile("ui/magicStone/common_sjbl_lb2.png")
		elseif self.m_nType == 3 then
			ftxtLevel:setShowText(string.format(lvFormat, self.m_tData.exp, ""))
			bg:setFile("ui/magicStone/common_sjb_lb.png")
		end
	end
	--等级奖励
	local conLevelReward = GetElement(self.m_root, "conLevelReward_CellMagicStoneReward", WZUIContainer)
	conLevelReward:removeAllChildrenWithCleanup(true)
	local reward = self.m_tData.reward_boy
	local rewardAdvance = self.m_tData.advancedreward_boy
	if CacheCenter:getPlayerInfo().sex == 1 then 
		reward = self.m_tData.reward_girl
		rewardAdvance = self.m_tData.advancedreward_girl
	end
	local element, tCell = CellGoodItem:createElement()
	if element and tCell then 
		element:setScale(0.9)
		tCell:setCellGoodLocalId(reward[1][1], reward[1][2], 16)
		tCell:setItemClickFun(self, self.onClickListItem)
		tCell:setBackImgFile("ui/magicStone/common_fkfb_02.png", nil, nil, GlobalMethod:ccp(0.56,0.42))
		conLevelReward:addChild(element)
	end
	--进阶奖励
	local conAdvanceReward1 = GetElement(self.m_root, "conAdvanceReward1_CellMagicStoneReward", WZUIContainer)
	conAdvanceReward1:removeAllChildrenWithCleanup(true)
	if rewardAdvance[1] then 
		element, tCell = CellGoodItem:createElement()
		if element and tCell then 
			element:setScale(0.9)
			tCell:setCellGoodLocalId(rewardAdvance[1][1], rewardAdvance[1][2], 16)
			tCell:setItemClickFun(self, self.onClickListItem)
			tCell:setBackImgFile("ui/magicStone/common_dwj_tbd.png", nil, nil, nil)
			conAdvanceReward1:addChild(element)	

			if WndMagicStone.m_nOpenState == 0 then 
				GetElement(self.m_root, "conAdvanceLock1_CellMagicStoneReward", WZUIContainer):setVisible(true)
			else
				GetElement(self.m_root, "conAdvanceLock1_CellMagicStoneReward", WZUIContainer):setVisible(false)
			end
		end
	end
	local conAdvanceReward2 = GetElement(self.m_root, "conAdvanceReward2_CellMagicStoneReward", WZUIContainer)
	conAdvanceReward2:removeAllChildrenWithCleanup(true)
	if rewardAdvance[2] then 
		element, tCell = CellGoodItem:createElement()
		if element and tCell then 
			element:setScale(0.9)
			tCell:setCellGoodLocalId(rewardAdvance[2][1], rewardAdvance[2][2], 16)
			tCell:setItemClickFun(self, self.onClickListItem)
			tCell:setBackImgFile("ui/magicStone/common_dwj_tbd.png", nil, nil, nil)
			conAdvanceReward2:addChild(element)	
			if WndMagicStone.m_nOpenState == 0 then 
				GetElement(self.m_root, "conAdvanceLock2_CellMagicStoneReward", WZUIContainer):setVisible(true)
			else
				GetElement(self.m_root, "conAdvanceLock2_CellMagicStoneReward", WZUIContainer):setVisible(false)
			end
		end
	end
	--奖励状态
	if self.m_tData.levelState == 2 then 
		GetElement(self.m_root, "imgLevelRewardState_CellMagicStoneReward", WZUIImage):setVisible(true)
	end
	if self.m_tData.advanceState == 2 then 
		if rewardAdvance[1] then 
			GetElement(self.m_root, "imgAdvanceRewardState1_CellMagicStoneReward", WZUIImage):setVisible(true)
		end

		if rewardAdvance[2] then 
			GetElement(self.m_root, "imgAdvanceRewardState2_CellMagicStoneReward", WZUIImage):setVisible(true)
		end
	end
	--
	if self.m_nType == 2 then  
		conLevelReward:setRelativePosition(GlobalMethod:ccp(0.5,0.7306))
		conAdvanceReward1:setRelativePosition(GlobalMethod:ccp(0.5,0.427877))
		conAdvanceReward2:setRelativePosition(GlobalMethod:ccp(0.5,0.158178))

		GetElement(self.m_root, "conAdvanceLock1_CellMagicStoneReward", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.427877))
		GetElement(self.m_root, "conAdvanceLock2_CellMagicStoneReward", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.158178))
	end

	--物品边框特效
	local spineLevelReward = GetElement(self.m_root,"spineLevelReward_CellMagicStoneReward",WZUISpine)
	local spineAdvanceReward1 = GetElement(self.m_root,"spineAdvanceReward1_CellMagicStoneReward",WZUISpine)
	local spineAdvanceReward2 = GetElement(self.m_root,"spineAdvanceReward2_CellMagicStoneReward",WZUISpine)
	spineLevelReward:setVisible(false)
	spineAdvanceReward1:setVisible(false)
	spineAdvanceReward2:setVisible(false)
	if WndMagicStone.m_nSeasonNum >= 27 then
		if self.m_nType == 1 then
			if self.m_tData.levelState == 1 then
				spineLevelReward:setVisible(true)
			end
			if self.m_tData.advanceState == 1 then
				if rewardAdvance[1] then
					spineAdvanceReward1:setVisible(true)
				end
				if rewardAdvance[2] then
					spineAdvanceReward2:setVisible(true)
				end
			end
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------
--@brief	越南语包适配函数
function CellMagicStoneReward:_adaptLanguage_vn()
	local txtLevel = GetElement(self.m_root, "txtLevel_CellMagicStoneReward", WZUILabelTTF)
	if txtLevel then
		txtLevel:setScale(0.75)
	end
end