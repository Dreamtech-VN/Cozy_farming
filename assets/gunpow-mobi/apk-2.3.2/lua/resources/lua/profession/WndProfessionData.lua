--WndProfessionData.lua
--@brief	WndProfession的数据模块
--@date		2019/11/11
--@author	Tianxiang_Xu
--@note		职业系统

WndProfession = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndProfession:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nProfessionSel = nil 		--职业选中界面选中的职业索引
	self.m_nCurProfessionId = nil 		--当前职业Id
	self.m_bIsPreview = false 			--是否预览状态
	self.m_nProfessionChangeTimes = 0 	-- 转职次数
	self.m_nBornSkillResetTimes = 0 	--天赋重置次数
	self.m_tBornSkillData = nil 		--天赋数据
	self.m_nSelBornSkillIndex = 1 		--选中的天赋索引
	self.m_nLoadingId = nil 
	self.m_bIsActivity = false 			--是否激活
	self.m_nTurnIndex = 1 				--当前界面是一转还是二转
	self.m_nProfessionState = nil 		--职业的状态
	self.m_nSaveTurnIndex = nil 		--切换浏览状态用于保存当下选择一转还是二转
	self.m_tSecondTurnData = nil 		--二转天赋数据
	self.m_nCrystalOperateType = nil 	--水晶的操作类型
	self.m_tBeforeData = nil 			--升级、转换前的数据
	self.m_nOperateTreeType = nil 		--树类型【0=一转天赋树 | 1=二转角色天赋树 | 2=二转宠物天赋树】
	self.m_bIsTransColor = false 		--是否水晶转换
	self.m_nAdvanceSkillLv = -1 			--进阶技能等级
	self.m_nAdvanceSkillFloor = 0 		--进阶技能的层
	self.m_tAdvanceProperty = nil 		--进阶技能属性
	self.m_bIsChooseAdSkill = false  	--是否选中进阶技能
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndProfession:_unInit()
	self.m_root = nil
	self.m_nProfessionSel = nil 		--职业选中界面选中的职业索引
	self.m_nCurProfessionId = nil 		--当前职业Id
	self.m_bIsPreview = nil 			--是否预览状态
	self.m_nProfessionChangeTimes = nil 	-- 转职次数
	self.m_nBornSkillResetTimes = nil 
	self.m_tBornSkillData = nil 		--天赋数据
	self.m_nSelBornSkillIndex = nil 		--选中的天赋索引
	self.m_nLoadingId = nil 
	self.m_bIsActivity = nil 			--是否激活
	self.m_nTurnIndex = nil 
	self.m_nProfessionState = nil 		--职业的状态
	self.m_nSaveTurnIndex = nil 		--切换浏览状态用于保存当下选择一转还是二转
	self.m_tSecondTurnData = nil 		--二转天赋数据
	self.m_nCrystalOperateType = nil 	--水晶的操作类型
	self.m_tBeforeData = nil 			--升级、转换前的数据
	self.m_nOperateTreeType = nil
	self.m_bIsTransColor = nil 
	self.m_nAdvanceSkillLv = nil 			--进阶技能等级
	self.m_nAdvanceSkillFloor = nil 		--进阶技能的层
	self.m_tAdvanceProperty = nil 			--进阶技能属性
	self.m_bIsChooseAdSkill = nil  	--是否选中进阶技能
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndProfession:createElement()
	if WndProfession.m_root ~= nil then
		WindowManager:removeWindow(WndProfession.m_root, WndProfession, true)
	end
	local element = WZUISystem:getInstance():createElement("WndProfession")
	assert(element, "WndProfession create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndProfession:showInterface()
	-- body
	local  wndProfession= WndProfession:createElement()
    if wndProfession~= nil then
        WindowManager:addWindow(wndProfession, WndProfession, false)
    end
end

--@brief 	设置数据
function WndProfession:setData(status, profession, professionChangeCount, talentResetCount, node, talentSkill, talentResetCount2, roleNode, roleTalentSkill, petNode, petTalentSkill, advLv, advGrade, attrType, attrValue)
	-- body
	self:_stopLoading()
	WZLog("WndProfession:setData", status, profession, professionChangeCount, talentResetCount, Serialize(node), Serialize(talentSkill))
	self.m_nCurProfessionId = profession
	self.m_nProfessionChangeTimes = professionChangeCount 	-- 转职次数
	self.m_nBornSkillResetTimes = talentResetCount 	--天赋重置次数
	self.m_nSecondSkillResetTimes = talentResetCount2 -- 二转重置次数
	self.m_nProfessionState = status --0=不可开启|1=可开启1转|2=可开启2转【注：为2必然可以开启二转，为1需要前端额外进行判断是否可开启二转】

	self:setBornSkillData()
	if profession > 0 then 
		for i = 1, #node do
			local tProfessionData = self.m_tBornSkillData[profession]
			for j = 1, #tProfessionData do
				if tProfessionData[j].node == node[i] then 
					tProfessionData[j] = CopyTable(GDatatab_mage_Skill["id_" .. talentSkill[i]])
					tProfessionData[j].state = 1
					break 
				end
			end
		end

		if self.m_topCellLua then 
			self.m_topCellLua.goldCellInfo.tcell:createResetBtn(self, self.onClickReset, GlobalMethod:ccp(0.91, 0.5))
		end
	end
	--设置二转数据
	self:setSecondTurnData()
	if profession > 0 then 
		--角色线
		local nPreNum = 200 --二转职业配置的是  201 202 203 宠物的是  204 205 206
		local professionNum = 3 
		for i = 1, #roleNode do
			local tProfessionData = self.m_tSecondTurnData[profession]
			for j = 1, #tProfessionData do
				if tProfessionData[j].node == roleNode[i] and tProfessionData[j].profession == nPreNum + profession then 
					tProfessionData[j] = CopyTable(GDatatab_mage_Skill["id_" .. roleTalentSkill[i]])
					tProfessionData[j].state = 1
					break 
				end
			end
		end
		--宠物线
		for i = 1, #petNode do
			local tProfessionData = self.m_tSecondTurnData[profession]
			for j = 1, #tProfessionData do
				if tProfessionData[j].node == petNode[i] and tProfessionData[j].profession == nPreNum + professionNum + profession then 
					tProfessionData[j] = CopyTable(GDatatab_mage_Skill["id_" .. petTalentSkill[i]])
					tProfessionData[j].state = 1
					break 
				end
			end
		end
	end
	--设置进阶技能数据
	self:setAdvanceSkillData(advLv, advGrade, attrType, attrValue)
--	WZLog("WndProfession:setData 111", Serialize(roleNode), Serialize(roleTalentSkill), Serialize(petNode), Serialize(petTalentSkill), Serialize(self.m_tSecondTurnData))

	self:_update()

	self:showCrystalStateAfterUpgrade()
end

--@brief 	升级天赋技能成功
function WndProfession:upgradeSuccess(treeType)
	--body
	self:_stopLoading()

	self.m_nOperateTreeType = treeType

	if treeType > 0 and self.m_nCrystalOperateType ~= nil then return end 

	if self.m_bIsActivity then 
		MsgBoxManager:showTipBox(LocalStrings.NEWSKILL15)
	else
		if self.m_nCrystalOperateType == 3 or self.m_bIsTransColor then 
			MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TWO14)
			self.m_bIsTransColor = false 	
		else
			MsgBoxManager:showTipBox("ui/common/bt_text_sjcg_1.png")	
		end
	end
end

--@brief  	设置进阶技能数据
function WndProfession:setAdvanceSkillData(advLv, advGrade, attrType, attrValue, result)
	WZLog("WndProfession:setAdvanceSkillData", advLv, advGrade, Serialize(attrType), Serialize(attrValue), tostring(result))
	self.m_nAdvanceSkillLv = advLv or 1 			--进阶技能等级
	self.m_nAdvanceSkillFloor = advGrade or -1 		--进阶技能的层
	self.m_tAdvanceProperty = {}
	for i = 1, #attrType do
		local tItem = {}
		tItem[1] = attrType[i]
		tItem[2] = attrValue[i]

		table.insert(self.m_tAdvanceProperty, tItem)
	end
	if result then 
		self:_stopLoading()
		
		if result == 1 then 
			MsgBoxManager:showTipBox("ui/common/bt_text_sjcg_1.png")	
		elseif result == 2 then 
			MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TEXT15)
		elseif result == 3 then 
			MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT31)
		end
		--刷新属性显示和消耗
		self:_showAdvanceSkillContent()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置各职业天赋数据
function WndProfession:setBornSkillData()
	-- body
	if self.m_tBornSkillData == nil then 
		self.m_tBornSkillData = {}
		for i = 1, 3 do
			if self.m_tBornSkillData[i] == nil then 
				self.m_tBornSkillData[i] = {}
			end

			local tStartNodeList = {}
			for j, value in pairs(GDatatab_mage_Skill) do
				if value.profession == i and value.node == 0 then 
					table.insert(tStartNodeList, value)
				end
			end
			table.sort(tStartNodeList, function (a,b)
				-- body
				return a.id < b.id
			end)
			--第一条线的数据
			local nTempNum = 1
			self.m_tBornSkillData[i][nTempNum] = CopyTable(tStartNodeList[1])
			local tTempSkill = self.m_tBornSkillData[i][nTempNum]
			nTempNum = nTempNum + 1
			while nTempNum < 8 do
				if type(tTempSkill.parent_id) == "table" then 
					for k = 1, GetTableLen(tTempSkill.parent_id[1]) do
						local tItem = GDatatab_mage_Skill["id_" .. tTempSkill.parent_id[1][k]]
						if tItem.node ~= tTempSkill.node then 
							self.m_tBornSkillData[i][nTempNum] = CopyTable(tItem)
							nTempNum = nTempNum + 1
							tTempSkill = tItem
							break 
						end
					end
				end
			end
			--第8个节点
			local tEndNodeList = {}
			for j, value in pairs(GDatatab_mage_Skill) do
				if value.profession == i and value.node == 8 then 
					table.insert(tEndNodeList, value)
				end
			end
			table.sort(tEndNodeList, function (a,b)
				-- body
				return a.id < b.id
			end)
			self.m_tBornSkillData[i][nTempNum] = CopyTable(tEndNodeList[1])
			nTempNum = nTempNum + 1
			--第二条线的数据
			tTempSkill = CopyTable(tStartNodeList[1])
			while nTempNum < 10 do
				if type(tTempSkill.parent_id) == "table" then 
					local tParentIdTwo = tTempSkill.parent_id[2] or tTempSkill.parent_id[1]
					for k = 1, GetTableLen(tParentIdTwo) do
						local tItem = GDatatab_mage_Skill["id_" .. tParentIdTwo[k]]
						if tItem.node ~= tTempSkill.node then 
							self.m_tBornSkillData[i][nTempNum] = CopyTable(tItem)
							nTempNum = nTempNum + 1
							tTempSkill = tItem
							break 
						end
					end
				end
			end
		end
	end

	for i = 1, 3 do
		for j = 1, #self.m_tBornSkillData[i] do
			self.m_tBornSkillData[i][j].state = 0 
		end
	end
end

--@brief 	获取天赋下级数据
function WndProfession:_getBornSkillNextLevelData(tCurData)
	-- body
	if tCurData == nil then return nil end 
	WZLog("WndProfession:_getBornSkillNextLevelData", Serialize(tCurData))
	for i, value in pairs(GDatatab_mage_Skill) do
		if value.profession == tCurData.profession and value.node == tCurData.node and value.lv == tCurData.lv + 1 then 
			if type(tCurData.parent_id) == "table" then 
				for j = 1, #tCurData.parent_id do
					if tCurData.parent_id[j][1] == value.id then 
						return value 
					end
				end
			end
		end
	end

	return nil
end

--@brief    数据加载动画
function WndProfession:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndProfession:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief 	判断是否需要重置天赋
function WndProfession:_judgeNeedReset()
	-- body
	if self.m_nCurProfessionId == 0 then return false end 

	local curTurnData = nil
	if self.m_nTurnIndex == 1 then 
		curTurnData = self.m_tBornSkillData[self.m_nCurProfessionId]
	elseif self.m_nTurnIndex == 2 then 
		curTurnData = self.m_tSecondTurnData[self.m_nCurProfessionId]
	end

	for i = 1, #curTurnData do
		local tempData = curTurnData[i]
		if tempData.state == 1 then 
			return true
		end
	end

	return false 
end

--@brief 	获取激活的是哪条线路
--@result 	1:线路1；2：线路2；0：还没有决定
function WndProfession:getActiveLineIndex()
	-- body
	local nLine = 0
	if self.m_nCurProfessionId and self.m_nCurProfessionId > 0 then 
		for i = 1, #self.m_tBornSkillData[self.m_nCurProfessionId] do
			local tempData = self.m_tBornSkillData[self.m_nCurProfessionId][i]
			if tempData.state == 1 and tempData.node == 1 then 
				nLine = 1
				break 
			elseif tempData.state == 1 and tempData.node == 2 then 
				nLine = 2
				break 
			end
		end
	end

	return nLine
end

--@brief 	设置二转天赋数据
function WndProfession:setSecondTurnData()
	-- body
	local nPreNum = 200 --二转职业配置的是  201 202 203 宠物的是  204 205 206
	local professionNum = 3 
	if self.m_tSecondTurnData == nil then 
		self.m_tSecondTurnData = {}
		for i = 1, professionNum do
			if self.m_tSecondTurnData[i] == nil then 
				self.m_tSecondTurnData[i] = {}
			end

			--角色线的数据
			for k = 1, 5 do
				for j, value in pairs(GDatatab_mage_Skill) do
					if value.profession == nPreNum + i and value.node == k - 1 and value.lv == 1 then 
						self.m_tSecondTurnData[i][k] = CopyTable(value)
						break 
					end
				end
			end
			--宠物线的数据
			local nTempNum = 5 + 1
			for k = 1, 4 do
				for j, value in pairs(GDatatab_mage_Skill) do
					if value.profession == nPreNum + i + professionNum and value.node == k - 1 and value.lv == 1 then 
						self.m_tSecondTurnData[i][nTempNum] = CopyTable(value)
						nTempNum = nTempNum + 1
						break 
					end
				end
			end
		end
	end

	for i = 1, 3 do
		for j = 1, #self.m_tSecondTurnData[i] do
			self.m_tSecondTurnData[i][j].state = 0 
		end
	end
end

--@brief 	根据职业、进阶技能等级和层级，获取技能数据
--@param 	bNextLevel: 是否获取下一级的数据
function WndProfession:getAdvanceSkillData(bNextLevel)
	if self.m_nCurProfessionId == 0 or self.m_nAdvanceSkillLv <= 0 then return end 

	if bNextLevel then 
		local tempData = nil 
		--先查找当前阶的下一层
		for i, value in pairs(GDatatab_profession_advance) do
			if value.profession == self.m_nCurProfessionId and value.lv == self.m_nAdvanceSkillLv and value.grade == self.m_nAdvanceSkillFloor + 1 then 
				tempData = value
				break 
			end
		end
		if tempData then 
			return tempData 
		end
		--如果当前阶的下一层没找到，则中下一阶的第一层
		for i, value in pairs(GDatatab_profession_advance) do
			if value.profession == self.m_nCurProfessionId and value.lv == self.m_nAdvanceSkillLv + 1 and value.grade == 1 then 
				tempData = value
				break 
			end
		end
		return tempData 
	else
		for i, value in pairs(GDatatab_profession_advance) do
			if value.profession == self.m_nCurProfessionId and value.lv == self.m_nAdvanceSkillLv and value.grade == self.m_nAdvanceSkillFloor then 
				return value
			end
		end
	end

	return nil 
end
-------------------------------------私有方法模块End----------------------------------------
