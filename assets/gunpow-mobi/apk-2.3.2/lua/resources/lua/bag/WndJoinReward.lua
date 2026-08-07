--WndJoinReward.lua
--@brief	WndJoinReward的UI模块
--@date		2020/12/11
--@author	hyx
--@note		参与奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndJoinReward:onEnter(element)
	self.m_root = element

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndJoinReward:onExit(element)
	self:_unInit()
end
function WndJoinReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndJoinReward:actionCallback()
	self:setTabSize()
	self:initShow()
end
--[[
desc:描述
reward_id、reward_id奖励的id和数量  reward_id = {1,2} reward_nums = {10,20}
title_name: 标题名字
change_res: 用于更换资源
tab_index : 存在页签的时候 默认为1
]]
function WndJoinReward:showInterface(desc, reward_ids, reward_nums, title_name, change_res, tab_index, other_data, nCurIndex)
	local wndReward = WndJoinReward:createElement()
    WindowManager:addWindow(wndReward,WndJoinReward,nil,false)
    self:setData(desc, reward_ids, reward_nums, title_name, change_res, tab_index, other_data, nCurIndex)
end
function WndJoinReward:setData(desc, reward_ids, reward_nums, title_name, change_res, tab_index, other_data, nCurIndex)
	self.m_sDesc = desc or ""
	self.m_tRewardIdsData = reward_ids or {}
	self.m_tRewardNumsData = reward_nums or {}
	self.m_sTitleName = title_name or LocalStrings.TREASURE_TEXT4
	self.m_bChangeRes = change_res or nil
	self.m_nTabIndex = tab_index or 0
	self.m_nSpecifyIndex = nCurIndex or 1
	self.m_tOtherData = other_data or {}
end
function WndJoinReward:initShow()
	local imgBg = GetElement(self.m_root,"imgBg",WZUI9Image)
	local img9SecBg = GetElement(self.m_root,"img9SecBg_WndJoinReward",WZUI9Image)
	local imgClose = GetElement(self.m_root,"imgClose",WZUIImage)
	local txtTitle = GetElement(self.m_root,"title_name",WZUILabelTTF)
	local str_select, str_normal, str_color
	if self.m_bChangeRes then
		if self.m_tOtherData and self.m_tOtherData.changeRes == 1 then 
			GetElement(self.m_root, "btn1", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.12,0.912))
			GetElement(self.m_root, "btn2", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.36,0.912))
			imgBg:setFile("ui/specialBg/frame_tc_bcs_x.png")
			imgClose:setFile("ui/common/common_top_btn_guanbi.png")
			str_select = "ui/common/common_mlrs_xz_01.png"
			str_normal = "ui/common/common_mlrs_xz_02.png"
			str_color = ccc3(127,70,26)
		elseif self.m_tOtherData and self.m_tOtherData.changeRes == 2 then 
			if self.m_tOtherData.bIsUseOriginSize ~= nil then 
				imgBg:setUseOriginSize(self.m_tOtherData.bIsUseOriginSize)
			end
			if self.m_tOtherData.imgBg then 
				imgBg:setFile(self.m_tOtherData.imgBg)
				if self.m_tOtherData.imgBgPt then 
					imgBg:setRelativePosition(self.m_tOtherData.imgBgPt)
				end
			end
			if self.m_tOtherData.img9SecBg then 
				img9SecBg:setFile(self.m_tOtherData.img9SecBg)
			end
			if self.m_tOtherData.imgClose then 
				imgClose:setFile(self.m_tOtherData.imgClose)
			end
			if self.m_tOtherData.titleColor then 
				txtTitle:setColor(self.m_tOtherData.titleColor)
			end
			if self.m_tOtherData.titleStrokeColor then 
				txtTitle:setStrokeColor(self.m_tOtherData.titleStrokeColor)
			end
			if self.m_tOtherData.titleStroke ~= nil then 
				txtTitle:setEnableStroke(self.m_tOtherData.titleStroke)
			end
			if self.m_tOtherData.str_select then 
				str_select = self.m_tOtherData.str_select
			else
				str_select = "ui/common/common_mlrs_xz_01.png"
			end
			if self.m_tOtherData.str_normal then 
				str_normal = self.m_tOtherData.str_normal
			else
				str_normal = "ui/common/common_mlrs_xz_02.png"
			end
			if self.m_tOtherData.str_color then 
				str_color = self.m_tOtherData.str_color
			else
				str_color = ccc3(127,70,26)
			end
		else
			imgBg:setFile("ui/common/frame_tc_xiao_zi.png")
			imgClose:setFile("ui/common/common_top_btn_guanbi_zi.png")
			str_select = "ui/activity/common_btn_47.png"
			str_normal = "ui/activity/common_btn_48.png"
			str_color = ccc3(198,130,255)
		end
	else
		imgBg:setFile("ui/common/frame_tc_xiao.png")
		imgClose:setFile("ui/common/common_top_btn_guanbi.png")
		str_select = "ui/common/common_mlrs_xz_01.png"
		str_normal = "ui/common/common_mlrs_xz_02.png"
		str_color = ccc3(127,70,26)
	end
	self.m_sNameColor = str_color
	txtTitle:setText(self.m_sTitleName)

	if self.m_nTabIndex == 0 then
		GetElement(self.m_root,"txtRewardDesc",WZUILabelTTF):setText(self.m_sDesc)
		local rewardTableList = GetElement(self.m_root,"rewardTableList",WZUITableContainer)
		rewardTableList:setVisible(true)
		rewardTableList:cleanTable()
		if self.m_sDesc == "" then
			rewardTableList:setAbsContentSize(GlobalMethod:CCSize(480,280))
			rewardTableList:updateRelativeSize()
		end
		for i=1, #self.m_tRewardIdsData do
			local key = "id_".. self.m_tRewardIdsData[i]
			local tabItem = GDatatab_item[key]
			local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=self.m_tRewardNumsData[i],quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
			local celElement,tCell = CellGoodItem:createElement()
			if celElement and tCell then
				tCell:setCellGoodItem(itemInfo, 17)
				celElement:setTag(i-1)
				rewardTableList:setCellElement(celElement)
				tCell:setItemClickFun(self,self.onItemClick)
			end
		end
	elseif self.m_nTabIndex >= 1 then
		GetElement(self.m_root,"reward_con",WZUIContainer):setVisible(true)
		for i=1, self.m_nTabIndex do
			local tab = {}
			local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
			btn:setVisible(true)
			tab.normal = GetElement(btn,"normal",WZUI9Image)
			tab.normal:setFile(str_normal)
			tab.select = GetElement(btn,"select",WZUI9Image)
			tab.select:setFile(str_select)
			tab.name = GetElement(btn,"name",WZUILabelTTF)
			tab.name:setColor(str_color)
			if self.m_tOtherData.fontSize then
				tab.name:setFontSize(self.m_tOtherData.fontSize)
			end
			if i == 1 then
				local str1 = self.m_tRewardIdsData.name or LocalStrings.ACTIVITY_TEXT19
				tab.name:setText(str1)
			elseif i == 2 then
				local str2 = self.m_tRewardNumsData.name or LocalStrings.ACTIVITY_TEXT18
				tab.name:setText(str2)
			elseif i == 3 and self.m_tOtherData.otherRewardData then
				local str2 = self.m_tOtherData.otherRewardData.name
				tab.name:setText(str2)
			end
			self.m_tRewardTabTitle[i] = tab
		end
		self.m_nCurIndex = self.m_nSpecifyIndex
		self.m_tRewardTabTitle[self.m_nCurIndex].normal:setVisible(false)
		self.m_tRewardTabTitle[self.m_nCurIndex].select:setVisible(true)
		if self.m_tOtherData.selNameColor then 
			self.m_tRewardTabTitle[self.m_nCurIndex].name:setColor(self.m_tOtherData.selNameColor)
		else
			self.m_tRewardTabTitle[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
		end
		if self.m_tOtherData.selNameStrokeEnable ~= nil then 
			self.m_tRewardTabTitle[self.m_nCurIndex].name:setEnableStroke(selNameStrokeEnable)
		else
			self.m_tRewardTabTitle[self.m_nCurIndex].name:setEnableStroke(true)
		end
		self.m_tRewardTabTitle[self.m_nCurIndex].name:setStrokeSize(4)
		if self.m_tOtherData.selNameStrokeColor then 
			self.m_tRewardTabTitle[self.m_nCurIndex].name:setStrokeColor(self.m_tOtherData.selNameStrokeColor)
		else
			self.m_tRewardTabTitle[self.m_nCurIndex].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
		end

		self:setViewVisible(self.m_nCurIndex)
	end
end

function WndJoinReward:onBtnTab(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if self.m_nCurIndex == tag then return end

	if self.m_tRewardTabTitle[self.m_nCurIndex] then
		self.m_tRewardTabTitle[self.m_nCurIndex].normal:setVisible(true)
		self.m_tRewardTabTitle[self.m_nCurIndex].select:setVisible(false)
		self.m_tRewardTabTitle[self.m_nCurIndex].name:setColor(self.m_sNameColor)
		self.m_tRewardTabTitle[self.m_nCurIndex].name:setEnableStroke(false)
	end
	if self.m_tRewardTabTitle[tag] then
		self.m_tRewardTabTitle[tag].normal:setVisible(false)
		self.m_tRewardTabTitle[tag].select:setVisible(true)
		if self.m_tOtherData.selNameColor then 
			self.m_tRewardTabTitle[tag].name:setColor(self.m_tOtherData.selNameColor)
		else
			self.m_tRewardTabTitle[tag].name:setColor(GlobalMethod:ccc3(255,236,193))
		end
		if self.m_tOtherData.selNameStrokeEnable ~= nil then 
			self.m_tRewardTabTitle[tag].name:setEnableStroke(self.m_tOtherData.selNameStrokeEnable)
		else
			self.m_tRewardTabTitle[tag].name:setEnableStroke(true)
		end
		self.m_tRewardTabTitle[tag].name:setStrokeSize(4)
		if self.m_tOtherData.selNameStrokeColor then 
			self.m_tRewardTabTitle[tag].name:setStrokeColor(self.m_tOtherData.selNameStrokeColor)
		else
			self.m_tRewardTabTitle[tag].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
		end
	end
	
	self:setViewVisible(tag)
	self.m_nCurIndex = tag
end

function WndJoinReward:setViewVisible(tag)
	GetElement(self.m_root,"tabReward1",WZUITableContainer):setVisible(tag == 1)
	GetElement(self.m_root,"tabReward2",WZUITableContainer):setVisible(tag == 2)
	GetElement(self.m_root,"tabReward3",WZUITableContainer):setVisible(tag == 3)

	local conListBg = GetElement(self.m_root,"conListBg_WndJoinReward",WZUIContainer)
	local txtChooseAtt = GetElement(self.m_root,"txtChooseAtt_WndJoinReward", WZUILabelTTF)
	local ftxtChooseAtt = GetElement(self.m_root,"ftxtChooseAtt_WndJoinReward", WZUIFreeTextBox)
	ftxtChooseAtt:setVisible(false)
	local reward_ids = {}
	local reward_nums = {}
	local tTempData = {}
	if tag == 1 then
		reward_ids = self.m_tRewardIdsData.reward_ids1 or {}
		reward_nums = self.m_tRewardIdsData.reward_nums1
		tTempData = self.m_tRewardIdsData
	elseif tag == 2 then
		reward_ids = self.m_tRewardNumsData.reward_ids2 or {}
		reward_nums = self.m_tRewardNumsData.reward_nums2
		tTempData = self.m_tRewardNumsData
	elseif tag == 3 then
		reward_ids = self.m_tOtherData.otherRewardData.reward_ids or {}
		reward_nums = self.m_tOtherData.otherRewardData.reward_nums
		tTempData = self.m_tOtherData.otherRewardData
	end
	WZLog("WndJoinReward:setViewVisible", tag)
	if ProjConfig.LANGUAGE == "vn" and self.m_tOtherData.activityId ~= g_cityExtenInfo.activity7185 then 
		tTempData.listBgSize = nil 
		tTempData.listBgPos = nil 
		tTempData.listSize = nil 
		tTempData.cellElementHeight = nil 
		tTempData.listPos = nil 
	end
	if tTempData.listBgSize then 
		conListBg:setAbsContentSize(GlobalMethod:CCSize(tTempData.listBgSize[1], tTempData.listBgSize[2]))
		conListBg:updateRelativeSize()
	end
	if tTempData.listBgPos then 
		conListBg:setRelativePosition(GlobalMethod:ccp(tTempData.listBgPos[1], tTempData.listBgPos[2]))
	end
	if tTempData.strAtt then 
		local nStart = string.find(tTempData.strAtt, "<")
		if nStart ~= nil then 
			ftxtChooseAtt:setVisible(true)
			ftxtChooseAtt:setShowText(tTempData.strAtt)
		else
			txtChooseAtt:setText(tTempData.strAtt)
		end
	else
		txtChooseAtt:setText("")
	end

	if self.m_tTabView[tag] == true then return end
	self.m_tTabView[tag] = true
	local tabReward = GetElement(self.m_root,"tabReward"..tag,WZUITableContainer)
	tabReward:cleanTable()


	if tTempData.listSize then 
		tabReward:setAbsContentSize(GlobalMethod:CCSize(tTempData.listSize[1], tTempData.listSize[2]))
		tabReward:updateRelativeSize()
	end
	if tTempData.cellElementHeight then 
		tabReward:setCellElementHeight(tTempData.cellElementHeight)
	end
	if tTempData.listPos then 
		tabReward:setRelativePosition(GlobalMethod:ccp(tTempData.listPos[1], tTempData.listPos[2]))
	end

	self.m_tRewardObj[tag] = {}
	for i=1, #reward_ids do
		local tabItem = GDatatab_item["id_".. reward_ids[i]]
		local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=reward_nums[i],quality=tabItem.quality,basicInfo=CopyTable(tabItem), index = i}
		local bVisibleLimit = false
		local strLimit = "" 
		if tTempData.leftConfig then 
			itemInfo.leftConfig = tTempData.leftConfig[i]
			bVisibleLimit, strLimit = self:getLimitData(itemInfo.leftConfig.soldNum, itemInfo.leftConfig.limitNum, itemInfo.leftConfig.dailyLimit, itemInfo.leftConfig.dailyBuyNum)
		end
		if tTempData.chooseState then 
			itemInfo.chooseState = tTempData.chooseState[i]
		end
		if tTempData.pool then 
			itemInfo.pool = tTempData.pool
		end
		if tTempData.origin then 
			itemInfo.origin = tTempData.origin
		end
		local nType = 17 
		if tTempData.type then 
			nType = tTempData.type
			itemInfo.rootNode = self.m_root
		end
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			tCell:setCellGoodItem(itemInfo, nType)
			celElement:setTag(i-1)
			tabReward:setCellElement(celElement)
			if ProjConfig.LANGUAGE == "vn" and self.m_tOtherData.activityId ~= g_cityExtenInfo.activity7185 then
				tTempData.chooseState = nil
			end
			if tTempData.chooseState then 
				tCell:setItemClickFun(WndJoinReward,self.onClickItem2)
			else
				tCell:setItemClickFun(WndJoinReward,self.onItemClick)
			end
			if bVisibleLimit then 
				tCell:_addNumLimit(strLimit)
			end
			if itemInfo.chooseState and itemInfo.chooseState == 1 then 
				tCell:setItemSelState(true)
			end
			table.insert(self.m_tRewardObj[tag], tCell)
		end
	end
end

--@brief	点击物品弹出对应的tips
function WndJoinReward:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndJoinReward.m_root,1,tData,false)
end

function WndJoinReward:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndJoinReward:getLimitData(soldNum, limitNum, dailyLimit, dailyBuyNum)
	local visible = false
	local str_title, num1, num2 = "",0,0
	local str = [[%s:%d/%d]]
	if limitNum == -1 and dailyLimit == -1 then
		visible = false
		num1,num2 = 0,1
	elseif limitNum ~= -1 and dailyLimit ~= -1 then
		visible = true
		str_title = LocalStrings.SHOP_LIMIT_TITLE
		num1 = soldNum
		num2 = limitNum
	elseif limitNum == -1 and dailyLimit ~= -1 then
		visible = true
		str_title = LocalStrings.WATERMELON_TEXT1[25]
		num1 = dailyBuyNum
		num2 = dailyLimit
	elseif limitNum ~= -1 and dailyLimit == -1 then
		visible = true
		str_title = LocalStrings.SHOP_LIMIT_TITLE
		num1 = soldNum
		num2 = limitNum
	end
	local strLimit = string.format(str,str_title, num1, num2)
	local bIsSoldOut = false 
	if num1 >= num2 then
		bIsSoldOut = true
	end
	return visible, strLimit, bIsSoldOut
end

--@brief    点击奖励回调
function WndJoinReward:onClickItem2(tCell, tag, tData)
    WZLog("WndJoinReward:onClickItem2 ")
    --每个活动的doType不一定一致，看好协议文档
    --(自选大奖):7055台无止境doType = 7,7046套圈圈doType = 6
    if tData.chooseState and tData.chooseState == 0 then 
		local _, _, bIsSoldOut = self:getLimitData(tData.leftConfig.soldNum, tData.leftConfig.limitNum, tData.leftConfig.dailyLimit, tData.leftConfig.dailyBuyNum)
	    if bIsSoldOut then
	    	if self.m_tOtherData.activityId == g_cityExtenInfo.activity7077 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.PLANETSEARCH_TEXT1[10 - self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7082 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.GOLFBALL_TEXT1[12 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7084 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.DETECTIVE_TEXT1[12 + tData.pool], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7086 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.GONGANDDRUM_TEXT1[12 + tData.pool], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7087 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.GOLD_MINER_TEXT1[5 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7089 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.DEEPSEA_TEXT1[15 - self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7024 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.ACTIVITY_TEXT121, tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7049 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.BOWLING_TEXT1[8], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7010 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.ACTIVITY_TEXT19, tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7052 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.SECRETTOWER_TEXT1[8], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7057 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.CRAZY_GASHAPON_TEXT1[11], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7051 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.WATERMELON_TEXT1[20], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7031 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.ACTIVITY_TEXT19, tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7088 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.CHESS_ACTIVITY_TEXT1[6 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7090 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.AUTUMNCAMP_TEXT1[12 + tData.pool], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7091 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.HOTBASKETBALL_TEXT1[12 + tData.pool], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7092 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.FLYKITES_TEXT1[15+ tData.pool], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7096 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.LASHTOP_TEXT1[6 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7097 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.KICKING_BIRDIE_TEXT1[6 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7098 then 
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.MAGIC_CLASSROOM_TEXT1[6 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7099 then
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.MAKE_SHOWMAN_TEXT1[7 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7100 then
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.PIANIST_TEXT1[7 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7101 then
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.CERAMIC_WORKSHOP_TEXT1[5 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7102 then
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.WEIGHTLIFTING_TEXT1[8 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7103 then
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.ARCTIC_EXPLORATION_TEXT1[6 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7104 then
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.BUILDING_BLOCKS_TEXT1[9 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7105 then
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[29], LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[18 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7106 then
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.BOATING_LAKE_TEXT1[6 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7107 then
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.BLOW_BUBBLES_TEXT1[7 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7109 then
	  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.AFFORESTATION_TEXT1[4 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	    	elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7110 then
	    		if self.m_tOtherData.tabType == 1 then
		  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.POTIONS_REFININ_TEXT1[8 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
		  	   	elseif self.m_tOtherData.tabType == 2 then
		  	   		MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.POTIONS_REFININ_TEXT1[6 + self.m_nCurIndex], tData.basicInfo.name, tData.lastTime))
	  	   		end
	  	   	elseif self.m_tOtherData.chooseInfo then 
	  	   		local chooseInfo = self.m_tOtherData.chooseInfo
	  	   		if tData.pool and chooseInfo.wordIndex then 
	  	   			MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings[chooseInfo.strKey][chooseInfo.wordIndex + tData.pool], tData.basicInfo.name, tData.lastTime))
	  	   		else
	  	   			MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], chooseInfo.strKey, tData.basicInfo.name, tData.lastTime))
	  	   		end
	    	else
	  	   		MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
	  	   	end
	  	   	return
	  	else
	  		self.m_tClickCell = tCell 
	  		local tTempData = {}
	  		local doType = 3
	  		if self.m_tOtherData.activityId == g_cityExtenInfo.activity7077 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7081 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7082 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7087 then
	  			tTempData.id = tData.index - 1
				tTempData.pool = 2 - self.m_nCurIndex
				doType = 4
	  		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7046 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7055 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7059 then
	  			tTempData.id = tData.index - 1
				tTempData.pool = 2 - self.m_nCurIndex
				doType = 7
	  		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7065 then
	  			tTempData.id = tData.index - 1
				tTempData.pool = tData.pool
				doType = 7
	  		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7083 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7089 then
	  			tTempData.id = tData.index - 1
				tTempData.pool = 2 - self.m_nCurIndex
				doType = 8
			elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7084 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7086 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7036 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7088 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7090 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7091 then
				tTempData.id = tData.index - 1
				tTempData.pool = tData.pool
				doType = 4
			elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7024 then
	  			tTempData.id = tData.index - 1
				doType = 6
			elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7049 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7031 then
	  			tTempData.id = tData.index - 1
				doType = 7
			elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7010 then
	  			tTempData.id = tData.index - 1
				doType = 5
			elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7052 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7051 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7057 then
	  			tTempData.id = tData.index - 1
				doType = 10
			elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7092 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7097 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7098 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7099 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7101 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7102 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7103 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7104 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7105 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7106 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7107 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7109 then
				tTempData.id = tData.index - 1
				tTempData.pool = 3 - self.m_nCurIndex
				doType = 4
			elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7096 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7100 then
				tTempData.id = tData.index - 1
				tTempData.pool = 2 - self.m_nCurIndex
				doType = 8
			elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7110 then
				if self.m_tOtherData.tabType == 1 then
					tTempData.pool = 3 - self.m_nCurIndex
				elseif self.m_tOtherData.tabType == 2 then
					tTempData.pool = 5 - self.m_nCurIndex
				end
				tTempData.id = tData.index - 1
				doType = 4
			elseif self.m_tOtherData.chooseInfo then 
	  	   		local chooseInfo = self.m_tOtherData.chooseInfo
				tTempData.id = tData.index - 1
				if tData.pool then 
					tTempData.pool = tData.pool
				end
				if chooseInfo.index then 
					tTempData.index = chooseInfo.index
				end
				doType = chooseInfo.doType
	  		else
				tTempData.index = tData.index - 1
				tTempData.type = 4 - self.m_nCurIndex
			end
			local stringData = json.encode(tTempData)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tOtherData.activityId, doType, stringData)
	   end
    elseif tData.chooseState and tData.chooseState == 1 then 
		self.m_tClickCell = tCell 
		local tTempData = {}
		local doType = 3
		if self.m_tOtherData.activityId == g_cityExtenInfo.activity7077 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7081 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7082 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7087 then
  			tTempData.id = tData.index - 1
			tTempData.pool = 2 - self.m_nCurIndex
			doType = 4
  		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7046 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7055 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7059 then
  			tTempData.id = tData.index - 1
			tTempData.pool = 2 - self.m_nCurIndex
			doType = 7
  		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7065 then
  			tTempData.id = tData.index - 1
			tTempData.pool = tData.pool
			doType = 7
		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7083 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7089 then
  			tTempData.id = tData.index - 1
			tTempData.pool = 2 - self.m_nCurIndex
			doType = 8
		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7084 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7086 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7036 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7088 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7090 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7091 then
			tTempData.id = tData.index - 1
			tTempData.pool = tData.pool
			doType = 4
		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7024 then
  			tTempData.id = tData.index - 1
			doType = 6
		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7049 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7031 then
  			tTempData.id = tData.index - 1
			doType = 7
		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7010 then
  			tTempData.id = tData.index - 1
			doType = 5
		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7052 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7051 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7057 then
  			tTempData.id = tData.index - 1
			doType = 10
		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7092 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7097 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7098 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7099 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7101 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7102 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7103 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7104 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7105 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7106 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7107 or self.m_tOtherData.activityId == g_cityExtenInfo.activity7109 then
			tTempData.id = tData.index - 1
			tTempData.pool = 3 - self.m_nCurIndex
			doType = 4
		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7096 or  self.m_tOtherData.activityId == g_cityExtenInfo.activity7100 then
			tTempData.id = tData.index - 1
			tTempData.pool = 2 - self.m_nCurIndex
			doType = 8
		elseif self.m_tOtherData.activityId == g_cityExtenInfo.activity7110 then
			if self.m_tOtherData.tabType == 1 then
				tTempData.pool = 3 - self.m_nCurIndex
			elseif self.m_tOtherData.tabType == 2 then
				tTempData.pool = 5 - self.m_nCurIndex
			end
			tTempData.id = tData.index - 1
			doType = 4
		elseif self.m_tOtherData.chooseInfo then 
  	   		local chooseInfo = self.m_tOtherData.chooseInfo
			tTempData.id = tData.index - 1
			if tData.pool then 
				tTempData.pool = tData.pool
			end
			if chooseInfo.only then
				return
			end
			doType = chooseInfo.doType
  		else
			tTempData.index = tData.index - 1
			tTempData.type = 4 - self.m_nCurIndex
		end
		local stringData = json.encode(tTempData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tOtherData.activityId, doType, stringData)
		tCell:setItemSelState(false)
    end
end

--@brief 	选择奖励返回
function WndJoinReward:chooseReturn(tag, index, status)
	if self.m_root == nil then return end 

	local tTempData = nil 
	if tag == 2 then 
		tTempData = self.m_tRewardNumsData
	elseif tag == 3 then 
		tTempData = self.m_tRewardIdsData
	elseif tag == 4 then 
		tTempData = self.m_tOtherData.otherRewardData
	end
	if self.m_tOtherData.activityId == g_cityExtenInfo.activity7065 then
		if tag == 2 then 
			tTempData = self.m_tRewardNumsData
		elseif tag == 3 then 
			tTempData = self.m_tOtherData.otherRewardData
		end
	end
	tTempData.chooseState[index] = status

	local tCell = self.m_tRewardObj[self.m_nCurIndex][index]
	tCell:updateChooseStateData(status)
	if status == 0 then 
		tCell:setItemSelState(false)
	elseif status == 1 then 
		tCell:setItemSelState(true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置标签大小
function WndJoinReward:setTabSize()
	if self.m_tOtherData.winType and self.m_tOtherData.winType == 1 then --暴揍策划大奖预览
		WZLog("WndJoinReward:setTabSize")
		local btn1 = GetElement(self.m_root, "btn1", WZUIButton)
		btn1:setAbsContentSize(GlobalMethod:CCSize(142,43))
		btn1:updateRelativeSize()
		btn1:setRelativePosition(GlobalMethod:ccp(0.15,0.932))
		local btn2 = GetElement(self.m_root, "btn2", WZUIButton)
		btn2:setAbsContentSize(GlobalMethod:CCSize(142,43))
		btn2:updateRelativeSize()
		btn2:setRelativePosition(GlobalMethod:ccp(0.46,0.932))
		local btn3 = GetElement(self.m_root, "btn3", WZUIButton)
		btn3:setAbsContentSize(GlobalMethod:CCSize(142,43))
		btn3:updateRelativeSize()
		btn3:setRelativePosition(GlobalMethod:ccp(0.78,0.932))
	end
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function WndJoinReward:_adaptLanguage_vn()
	local btn1 = GetElement(self.m_root,"btn1",WZUIButton)
	local name = GetElement(btn1,"name",WZUILabelTTF)
	name:setScale(0.7)
	name:setDimensions(GlobalMethod:CCSize(180,0))
	local btn2 = GetElement(self.m_root,"btn2",WZUIButton)
	local name = GetElement(btn2,"name",WZUILabelTTF)
	name:setScale(0.7)
	name:setDimensions(GlobalMethod:CCSize(180,0))
	local btn3 = GetElement(self.m_root,"btn3",WZUIButton)
	local name = GetElement(btn3,"name",WZUILabelTTF)
	name:setScale(0.7)
	name:setDimensions(GlobalMethod:CCSize(180,0))

	local ftxtChooseAtt = GetElement(self.m_root,"ftxtChooseAtt_WndJoinReward", WZUIFreeTextBox)
	ftxtChooseAtt:setScale(0.6)
	ftxtChooseAtt:setMaxWidth(780)
end
-------------------------------------语言适配end----------------------------------------
