--WndMagicStone.lua
--@brief	WndMagicStone的UI模块
--@date		2019/10/23
--@author	Tianxiang_Xu
--@note		幻石系统界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMagicStone:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndMagicStone:regAll() 
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品

	AdaptLanguage(self)
end
--@brief	关闭按钮回调事件
function WndMagicStone:onCloseClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMagicStone:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)--反注册物品
	if self.m_root then 
		self.m_root:disableSchedule()
		local conReward = GetElement(self.m_root, "conReward_WndMagicStone", WZUIContainer)
		conReward:disableSchedule()
	end
	-- FootEffectManager:removeEffect1(self.m_sRoleSpine)
	if self.m_sRoleSpine then
		self.m_sRoleSpine:removeFromParentAndCleanup(true)
		self.m_sRoleSpine = nil
	end
	ProtocolProcessorWndMagicStone:unregAll()
	self:_unInit()
end

--@brief	界面加载完成回调
function WndMagicStone:onEnterTransitionDidFinish(element)
	--body
	self.m_nSeasonIndex = self:getCurSeasonIndex()
	ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetMagicStoneInfo()

	self:_initUI()
	self:_addTop()
	self:_showDefaultContent()
	self.m_root:enableSchedule("_caculateTime", 1)
end
--判断全服奖励的开启
function WndMagicStone:isOpenServerRewardGet()
	local stoneOpenLevel = CacheCenter:getGameParam().stoneOpenLevel
	local level = CacheCenter:getPlayerInfo().level
	local checkBoxAllServer = GetElement(self.m_root,"checkBoxAllServer_WndMagicStone",WZUICheckBox)
	checkBoxAllServer:setVisible(false)
	if self.m_nSeasonNum < 27 then --182.1版本战令改版
		if tonumber(level) >= tonumber(stoneOpenLevel) then
			checkBoxAllServer:setVisible(true)
		end
	end
end
--@brief 	点击宝箱按钮回调
function WndMagicStone:onClickBox(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndMagicAdvance:showInterface()
end

--@brief 	点击购买等级按钮回调
function WndMagicStone:onClickBuyLevel(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nSeasonNum < 27 then
		WndMagicBuyLevel:showInterface()
	else
		WndVip:showWndUI(0)
	end
end

function WndMagicStone:onClickTab(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()

	WZLog("WndMagicStone:onClickTab", nTag, self.m_nCurIndex)
	if self.m_nCurIndex == nTag then return end 

	self.m_nCurIndex = nTag
	self:_setCheckBoxSel()
	self:_update()
end

--@brief 	触摸开始回调
function WndMagicStone:onTouchBegan(element, pt)
	-- body
	WndItemInfo:onCloseClick()

	if self.goldCellInfo then
        self.goldCellInfo.tcell:removeCreateTips()
    end
end

--@brief 	关闭界面
function WndMagicStone:closeWin()
	-- body
	if self.m_root == nil then return end 

	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击领取按钮回调
function WndMagicStone:onRecvReward(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local bHaveReward = self:_judgeCanGetReward()
	local allServer = self:_judgeAllServerCanGetReward()
	if bHaveReward and self.m_nCurIndex == 0 then 
		ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetReward(4, 0)
	elseif allServer and self.m_nCurIndex == 3 then
		ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetReward(5, 0)
	else
		MsgBoxManager:showTipBox(LocalStrings.MAGIC_STONE_TEXT18)
	end
end

--@brief 	点击规则按钮回调
function WndMagicStone:onClickRule(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndSingleMapDesc:showInterface(LocalStrings.MAGIC_STONE_TEXT19)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化
function WndMagicStone:_initUI()
	-- body
	self.m_nMaxWeekAddExp = tonumber(CacheCenter:getGameParam().stoneWeekExpLimit) or 100000

	-- local txtFreshWord = GetElement(self.m_root, "txtFreshWord_WndMagicStone", WZUILabelTTF)
	-- if txtFreshWord then 
	-- 	txtFreshWord:setText(LocalStrings.MAGIC_STONE_TEXT24 .. ":")
	-- end
end

--@brief 	刷新界面
function WndMagicStone:_update()
	-- body
	local str = LocalStrings.MAGIC_STONE_TEXT24
	if self.m_nCurIndex == 1 then
		str = LocalStrings.MAGIC_STONE_TEXT13
	end
	local txtFreshWord = GetElement(self.m_root, "txtFreshWord_WndMagicStone", WZUILabelTTF)
	if txtFreshWord then 
		txtFreshWord:setText(str .. ":")
	end
	if self.m_nCurIndex == 0 then 
		self:_showReward()
	elseif self.m_nCurIndex == 1 then 
		self:_showTask()
	elseif self.m_nCurIndex == 2 then 
		self:_showShop()
	elseif self.m_nCurIndex == 3 then
		self:_showReward(self.m_nCurIndex)
	end

	self:isOpenServerRewardGet()
	self:showTime()
	self:setRedDot()
end

--@brief 	金币栏
function WndMagicStone:_addTop()
 	local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_zl.png", WndMagicStone, WndMagicStone.onCloseClick, true, false, false, "WndMagicStone")
    self.m_root:addChild(celElement)
end

--@brief 	默认显示哪个标签的内容
function WndMagicStone:_showDefaultContent()
	-- body
    self:_setCheckBoxSel()
end

--@brief 	显示和隐藏相应的内容
function WndMagicStone:_setCheckBoxSel()
    -- body
    for i = 1, 4 do
    	if self.m_nCurIndex == i - 1 then 
    		local conContent = GetElement(self.m_root, "conContent" .. (i-1) .. "_WndMagicStone", WZUIContainer)
    		if conContent then
	    		conContent:setVisible(true)
	    	end
    		GetElement(self.m_root, "conCheckBox" .. (i-1) .. "_WndMagicStone", WZUIContainer):setVisible(true)
    	else
    		local conContent = GetElement(self.m_root, "conContent" .. (i-1) .. "_WndMagicStone", WZUIContainer)
	    	if conContent then
	    		conContent:setVisible(false)
	    	end
    		GetElement(self.m_root, "conCheckBox" .. (i-1) .. "_WndMagicStone", WZUIContainer):setVisible(false)
    	end
    end
    if self.m_nCurIndex == 3 then
    	GetElement(self.m_root, "conContent0_WndMagicStone", WZUIContainer):setVisible(true)
    end
end

--@brief 	显示每10级的奖励预览
function WndMagicStone:_updatePerTenReward()
	-- body
	local conPerTen = GetElement(self.m_root, "conPerTen_WndMagicStone", WZUIContainer)
	conPerTen:removeAllChildrenWithCleanup(true)
	WZLog("WndMagicStone:_updatePerTenReward", self.m_nPreviewIndex)
	local element, tCell = CellMagicStoneReward:createElementTwo()
	if element and tCell then 
		if self.m_tRewardData[self.m_nPreviewIndex] then 
			tCell:setData1(self.m_tRewardData[self.m_nPreviewIndex], 2)
			conPerTen:addChild(element)
		end
	end
end

--@brief 	刷新时间
function WndMagicStone:showTime()
	-- body
	--时间
	local txtFreshTime = GetElement(self.m_root, "txtFreshTime_WndMagicStone", WZUILabelTTF)
	if txtFreshTime then 
		local sTime = self:getTimeFormat(self.m_nSeasonTime)
		if self.m_nCurIndex == 1 then 
			sTime = self:getTimeFormat(self.m_nFreshTime)
			if self.m_nFreshTime < 0 then 
				sTime = LocalStrings.MAGIC_STONE_TEXT23
			end
		end
		txtFreshTime:setText(sTime)
	end
end

--@brief 	显示奖励
function WndMagicStone:_showReward(index)
	index = index or 1
	
	local txtBuyLevel = GetElement(self.m_root, "txtBuyLevel_WndMagicStone", WZUILabelTTF)
	local txtC0Reward1 = GetElement(self.m_root, "txtC0Reward1_WndMagicStone", WZUILabelTTF)
	local txtC0Reward2 = GetElement(self.m_root, "txtC0Reward2_WndMagicStone", WZUILabelTTF)
	local imgC0Stone1 = GetElement(self.m_root, "imgC0Stone1_WndMagicStone", WZUIImage)
	local imgC0Stone2 = GetElement(self.m_root, "imgC0Stone2_WndMagicStone", WZUIImage)
	local imgBox2 = GetElement(self.m_root, "imgBox2_WndMagicStone", WZUIImage)
	local spDown2 = GetElement(self.m_root, "spDown2_WndMagicStone", WZUISpine)
	if self.m_nSeasonNum <= 27 then
		txtBuyLevel:setText(LocalStrings.MAGIC_STONE_TEXT6)
		txtC0Reward1:setText(LocalStrings.COMMUNITYWARGIFT_TEXT4)
		txtC0Reward2:setText(LocalStrings.MAGIC_STONE_TEXT10)
		imgC0Stone1:setVisible(false)
		imgC0Stone2:setFile("shopitems/common_icon_zhanling.png")
		imgC0Stone2:setScale(0.9)
		imgBox2:setFile("ui/common/common_icon_jingyingBox.png")
		imgBox2:setScale(0.5)

		spDown2:setAnimationName("")
		spDown2:setFileAtlas("")
		spDown2:setFileJson("")
		spDown2:setFileAtlas("city/ui_main_iconeffect.atlas")
		spDown2:setFileJson("city/ui_main_iconeffect.json")
		spDown2:setAnimationName("animation")
		spDown2:setRelativePosition(GlobalMethod:ccp(0.486667,1.15333))
		spDown2:setScale(1.2)
	else
		txtBuyLevel:setText(LocalStrings.MAGIC_STONE_TEXT25[5])
		txtC0Reward1:setText(LocalStrings.MAGIC_STONE_TEXT25[1])
		txtC0Reward2:setText(LocalStrings.MAGIC_STONE_TEXT25[2])
		imgC0Stone1:setVisible(true)
		local tmpIdx = 1
		for i=1,#self.m_tLevelInterval do
			if self.m_nMagicStoneLevel <= self.m_tLevelInterval[i] then
				tmpIdx = i
				break
			end
		end
		imgC0Stone2:setFile(string.format("shopitems/icon_xz_zl_%02d.png",tmpIdx))
		imgC0Stone2:setScale(0.5)
		imgBox2:setFile("ui/magicStone/common_sjb_bx.png")
	--	imgBox2:setFile("ui/common/common_icon_fqzb_g.png")
	--	imgBox2:setScale(0.94)

		spDown2:setAnimationName("")
		spDown2:setFileAtlas("")
		spDown2:setFileJson("")
		spDown2:setFileAtlas("ui/ui_zl_baoxiang.atlas")
		spDown2:setFileJson("ui/ui_zl_baoxiang.json")
		spDown2:setAnimationName("wait1")
		spDown2:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		spDown2:setScale(1)
	end

	local flRewardList = GetElement(self.m_root, "flRewardList_WndMagicStone", WZUIFreeListContainer)
	flRewardList:removeAll()

	local data = nil
	if index == 1 then
		data = self.m_tRewardData
		local conReward = GetElement(self.m_root, "conReward_WndMagicStone", WZUIContainer)
		conReward:enableSchedule("_updatePerTenView", 0.2)
		GetElement(self.m_root,"btnBuyLevel_WndMagicStone",WZUIButton):setVisible(true)
	elseif index == 3 then
		data = self.m_tAllServerRewardData
		flRewardList:setAbsContentSize(GlobalMethod:CCSize(596,356))
		flRewardList:updateRelativeSize()
		GetElement(self.m_root,"btnBuyLevel_WndMagicStone",WZUIButton):setVisible(false)
	end
	if not data then return end

	for i = 1, #data do
		local element, tCell = CellMagicStoneReward:createElement()
		if element and tCell then 
			element = WZUIContainer:luaTo(element)
			tCell:setData(data[i], index)
		--	element:setRelativeSize(GlobalMethod:CCSize(1.2,1))
			flRewardList:pushBack(element)
		end
	end

	local cur_pos = self.m_nMagicStoneLevel
	if index == 3 then
		_,cur_pos = self:setAllServerProgress(self.m_nAllServerAdvanceNum)
	end
	self.m_nMaxPositionX = flRewardList:getMaxPosition().x
	local nCurPositionX = self.m_nMaxPositionX - (cur_pos + 1 - 5) * 110
	if nCurPositionX > self.m_nMaxPositionX then 
		nCurPositionX = self.m_nMaxPositionX 
	elseif nCurPositionX < flRewardList:getMinPosition().x then
		nCurPositionX = flRewardList:getMinPosition().x
	end
	flRewardList:getMoveElement():setPositionX(nCurPositionX)
	
	if self.m_nPreviewIndex == nil then 
		self.m_nPreviewIndex = (math.floor((cur_pos + 1)/10) + 1) * 10
	end

	self:_showLevelAndExp(index)

	if index == 1 then
		self:_updatePerTenReward()
	elseif index == 3 then
		local conPerTen = GetElement(self.m_root, "conPerTen_WndMagicStone", WZUIContainer)
		conPerTen:removeAllChildrenWithCleanup(true)
	end
end

--@brief 	显示等级经验
function WndMagicStone:_showLevelAndExp(index)
	-- body
	local perLevelExp = tonumber(CacheCenter:getGameParam().stonlevelexp) or 1000

	local txtStoneT1 = GetElement(self.m_root, "txtStoneT1_WndMagicStone", WZUILabelTTF)
	if txtStoneT1 then 
		if index == 1 then
			if self.m_nSeasonNum <= 27 then
				txtStoneT1:setText(LocalStrings.MAGIC_STONE_TEXT7 .. ":" .. self.m_nMagicStoneLevel)
			else
				txtStoneT1:setText(string.format(LocalStrings.WATERCOUNTRY_TEXT2[10],self.m_nSeasonNum))
			end
		elseif index == 3 then
			txtStoneT1:setText(LocalStrings.OPTIMIZE_TEXT31)
		end
	end

	local txtStoneT2 = GetElement(self.m_root, "txtStoneT2_WndMagicStone", WZUILabelTTF)
	if txtStoneT2 then 
		if index == 1 then
			if self.m_nSeasonNum <= 27 then
				txtStoneT2:setText("")
			else
				local str = LocalStrings.LV..self.m_nMagicStoneLevel
				local maxLv = 0
				for i, levelData in pairs(GDatatab_stone_reward) do
					if self.m_nSeasonNum == levelData.season and maxLv < levelData.lv then
						maxLv = levelData.lv
					end
				end
				if maxLv == self.m_nMagicStoneLevel then
					str = "MAX"
				end
				txtStoneT2:setText(str)
			end
		end
	end
	--经验
	local txtCurActivityNum = GetElement(self.m_root, "txtCurActivityNum_WndMagicStone", WZUILabelTTF)
	local count = self:setAllServerProgress(self.m_nAllServerAdvanceNum)
	if txtCurActivityNum then 
		if index == 1 then
			txtCurActivityNum:setText((self.m_nCurExp - perLevelExp)  .. "/" .. self.m_nMagicStoneLevel * perLevelExp)
		elseif index == 3 then
			if self.m_nAllServerAdvanceNum < 0 then
				self.m_nAllServerAdvanceNum = 0
			end
			txtCurActivityNum:setText(self.m_nAllServerAdvanceNum.."/"..count)
		end
	end
	--进度条
	local prgExp = GetElement(self.m_root, "prgExp_WndMagicStone", WZUIProgress)
	if prgExp then 
		local percentage = math.floor((self.m_nCurExp%perLevelExp)*100/perLevelExp)
		if index == 3 then
			percentage = self.m_nAllServerAdvanceNum / count * 100
		end
		if percentage > 100 then 
			percentage = 100
		end
		prgExp:setPercentage(percentage)
	end
	local head = nil 
	local face = nil 
	local body = nil 
	local wing = nil 
	local footId = nil 
	local mount = nil 

	if self.m_sFirstComeIn == nil then
		self.m_sFirstComeIn = true
		
		local rolePlayer = self.m_root:getChildElement("rolePlayer")
		if rolePlayer:getChildByTag(20) then
			rolePlayer:removeChildByTag(20,true)
		end
		local nSex = false
		if CacheCenter:getPlayerInfo().sex == 0 then
			nSex = true --男
		end
		for i = 1, #self.m_tRewardData do
			local dress_data = {}
			if nSex == true then
				dress_data[1] = self.m_tRewardData[i].reward_boy
				dress_data[2] = self.m_tRewardData[i].advancedreward_boy
			else
				dress_data[1] = self.m_tRewardData[i].reward_girl
				dress_data[2] = self.m_tRewardData[i].advancedreward_girl
			end
			
			for j = 1, #dress_data do
				for k, value in pairs(dress_data[j]) do
					local tempData = GDatatab_item["id_"..value[1]]
					if footId == nil and tempData and tempData.main_type == 23 then 
						footId = tempData.property[1][1]
					elseif tempData and tempData.main_type == 5 and tempData.sub_type == 0 and head == nil then 
						head = tempData.animation_index_code 
					elseif tempData and tempData.main_type == 5 and tempData.sub_type == 1 and face == nil then 
						face = tempData.animation_index_code 
					elseif tempData and tempData.main_type == 5 and tempData.sub_type == 2 and body == nil then 
						body = tempData.animation_index_code 
					elseif tempData and tempData.main_type == 5 and tempData.sub_type == 3 and wing == nil then 
						wing = tempData.animation_index_code 
					elseif tempData and tempData.main_type == 2 and tempData.sub_type == 11 and mount == nil then 
						local mountData = GDatatab_mounts["id_" .. tempData.value]
						local tempDataSec = GDatatab_item["id_" .. mountData.item_id]
						if tempDataSec and tempDataSec.main_type == 11 then 
							mount = tempDataSec.animation_index_code 
						end
					end
				end
			end
		end
		if head or face or body or wing or footId or mount then 	
			--设置默认显示
		    local gameParam = CacheCenter:getGameParam()
		    if nSex == true then
		        if head == nil then head = GDatatab_item["id_"..(gameParam.defaultManHeadId or 4903)].animation_index_code end
		        if face == nil then face = GDatatab_item["id_"..(gameParam.defaultManFaceId or  4902)].animation_index_code end
		        if body == nil then body = GDatatab_item["id_"..(gameParam.defaultManBodyId or  4901)].animation_index_code end
		    else
		        if head == nil then head = GDatatab_item["id_"..(gameParam.defaultWomanHeadId or 4906)].animation_index_code end
		        if face == nil then face = GDatatab_item["id_"..(gameParam.defaultWomanFaceId or 4905)].animation_index_code end
		        if body == nil then body = GDatatab_item["id_"..(gameParam.defaultWomanBodyId or 4904)].animation_index_code end
		    end
			local conPlayer = YDPlayerAnimation:createAnimation(nSex)
			rolePlayer:addChild(conPlayer:getAnimNode(), 0, 20)
			conPlayer:setFlipX(true)
			conPlayer:setHead(head)
			conPlayer:setFace(face)
			conPlayer:setBody(body)
			conPlayer:getAnimNode():setTouchEnable(false)
			if mount ~= nil then 
				conPlayer:setMount(mount)
				conPlayer:getAnimNode():setScale(0.6)
				conPlayer:play("wait", true)
			else
				conPlayer:play("wait0", true)
			end
			if wing ~= nil then
				conPlayer:setWing(wing)
			end
			if footId ~= nil then
			    self.m_sRoleSpine = FootEffectManager:addEffect1(rolePlayer,footId,{x=130,y=50},true)
			end
		end
	end
end
--全服的时候计算下一阶段的进度条
function WndMagicStone:setAllServerProgress(num)
	if self.m_tAllServerRewardData and num then
		local count, cur = 0, 1
		if num <= self.m_tAllServerRewardData[1].exp then
			count = self.m_tAllServerRewardData[1].exp
			cur = 1
		elseif num >= self.m_tAllServerRewardData[#self.m_tAllServerRewardData].exp then
			count = self.m_tAllServerRewardData[#self.m_tAllServerRewardData].exp
			cur = #self.m_tAllServerRewardData
		else
			for i=2, (#self.m_tAllServerRewardData-1) do
				if num > self.m_tAllServerRewardData[i-1].exp and num < self.m_tAllServerRewardData[i+1].exp then
					count = self.m_tAllServerRewardData[i+1].exp
					cur = i
					break
				end
			end
		end
		return count, cur
	end
	return 0, 1
end

--@brief 	返回时间格式
function WndMagicStone:getTimeFormat(nTime)
	if nTime >= 3600 * 24 then 
		local nDay = math.floor(nTime / (3600*24))
		local nHours = math.ceil((nTime - nDay * 3600 *24) / 3600)

		return nDay .. LocalStrings.DAY .. nHours ..LocalStrings.HOUR1
	elseif nTime >= 3600 then 
		local nHours = math.floor(nTime / 3600)
		local nMinutes = math.ceil((nTime - nHours * 3600) / 60)

		return nHours .. LocalStrings.HOUR1 .. nMinutes .. LocalStrings.MINUTE1
	else
		local nMinutes = math.floor(nTime / 60)
		local nSeconds = nTime - nMinutes * 60

		return nMinutes .. LocalStrings.MINUTE1 .. nSeconds .. LocalStrings.SECOND
	end
end

--@brief 	时间
function WndMagicStone:_caculateTime(element, delta)
	-- body
	if self.m_nFreshTime > 0 then 
		self.m_nFreshTime = self.m_nFreshTime - 1
		self:showTime()
	else
		if self.m_nFreshTime == 0 then 
			self.m_nFreshTime = -1
			ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetMagicStoneInfo()
		end
	end

	if self.m_nSeasonTime > 0 then 
		self.m_nSeasonTime = self.m_nSeasonTime - 1
		self:showTime()
	else
		if self.m_nSeasonTime == 0 then 
			self.m_nSeasonTime = -1
			WZLog("WndMagicStone:_caculateTime")
			self.m_sFirstComeIn = nil
			ProtocolProcessorSceneCity:send_PLAYER_GetPlayerExtInfo()
			ProtocolProcessorWndMagicStone:send_MAGICSTONE_GetMagicStoneInfo()
		end
	end
end

--@brief 	定时刷新奖励预览内容
function WndMagicStone:_updatePerTenView(element, delta)
	-- body
	if self.m_root == nil then return end 
	if self.m_nCurIndex ~= 0 then return end 

	local flRewardList = GetElement(self.m_root, "flRewardList_WndMagicStone", WZUIFreeListContainer)
	if flRewardList then 
		local nCurPositionX = flRewardList:getMoveElement():getPositionX()
		if self.m_nMaxPositionX == nil then 
			self.m_nMaxPositionX = flRewardList:getMaxPosition().x
		end

		local nChangeX = math.ceil((self.m_nMaxPositionX - nCurPositionX) / 110)
		local nCurItemIndex = 5 + nChangeX
		local nModTen = (math.floor(nCurItemIndex/10) + 1) * 10

		if nModTen > #self.m_tRewardData then 
			nModTen = nModTen - 10
		end
		if self.m_nPreviewIndex ~= nModTen then 
			self.m_nPreviewIndex = nModTen
			self:_updatePerTenReward()
		end
	end
end

----------------------------------任务-------------------------------
--@brief 	显示任务
function WndMagicStone:_showTask()
	local txtC1Task1 = GetElement(self.m_root,"txtC1Task1_WndMagicStone",WZUILabelTTF)
	local txtC1Task2 = GetElement(self.m_root,"txtC1Task2_WndMagicStone",WZUILabelTTF)
	txtC1Task1:setText(LocalStrings.MAGIC_STONE_TEXT7 .. ":" .. self.m_nMagicStoneLevel)
	txtC1Task2:setText(string.format(LocalStrings.MAGIC_STONE_TEXT25[3], self.m_nBatch))
	local conC1TaskTop = GetElement(self.m_root,"conC1TaskTop_WndMagicStone",WZUIContainer)
	if self.m_nSeasonNum <= 27 then
		conC1TaskTop:setVisible(false)
	else
		conC1TaskTop:setVisible(true)
	end

	local tbTaskList = GetElement(self.m_root, "tbTaskList_WndMagicStone", WZUITableContainer)
	tbTaskList:cleanTable()
	WZLog("WndMagicStone:_showTask", #self.m_tTaskData)

	if self.m_nSeasonNum <= 27 then
		tbTaskList:setAbsContentSize(GlobalMethod:CCSize(686,458))
		tbTaskList:updateRelativeSize()
		tbTaskList:setRelativePosition(GlobalMethod:ccp(0.5,0.504))
		tbTaskList:setCellElementHeight(0.25)
	else
		tbTaskList:setAbsContentSize(GlobalMethod:CCSize(686,400))
		tbTaskList:updateRelativeSize()
		tbTaskList:setRelativePosition(GlobalMethod:ccp(0.5,0.455))
		tbTaskList:setCellElementHeight(0.29)
	end

	for i = 1, #self.m_tTaskData do
		local element, tCell = CellMagicStoneTask:createElement()
		if element and tCell then 
			element:setTag(i - 1)
			if self.m_tTaskData[i].state == TASKSTATUS_DOING then
				tCell:setBtnJumpID(self.m_tTaskData[i].script[1][1], self.m_tTaskData[i].script[1][2])
	            tCell:setBtnText(self.m_tTaskData[i].buttonName)
	        elseif self.m_tTaskData[i].state == TASKSTATUS_TOSUBMIT then
	            tCell:setBtnText(LocalStrings.COMPLETE_TASK)
	        end

			local _sTaskGoals = string.format("%d/%d", self.m_tTaskData[i].complete, self.m_tTaskData[i].targetNum)
			tCell:setData(self.m_tTaskData[i].id, self.m_tTaskData[i].reward, self.m_tTaskData[i].name, self.m_tTaskData[i].desc, self.m_tTaskData[i].state, self.m_tTaskData[i].id, _sTaskGoals, self.m_tTaskData[i].script, self.m_tTaskData[i].taskRcvNum, self.m_tTaskData[i].taskRcvLimit)
			tbTaskList:setCellElement(element)
		end
	end

	self:_showWeekExp()
end

--@brief 	显示周增加的经验
function WndMagicStone:_showWeekExp()
	-- body
	local txtStoneExp = GetElement(self.m_root, "txtStoneExp_WndMagicStone", WZUILabelTTF)
	local txtExpValue = GetElement(self.m_root, "txtExpValue_WndMagicStone", WZUILabelTTF)
	if txtStoneExp then 
		if self.m_nMaxWeekAddExp > self.m_nWeekExp then 
			txtStoneExp:setText(LocalStrings.MAGIC_STONE_TEXT11)
			txtExpValue:setVisible(true)
			txtExpValue:setText(self.m_nWeekExp .. "/" .. self.m_nMaxWeekAddExp)
		else
			txtStoneExp:setText(LocalStrings.MAGIC_STONE_TEXT12)
			txtExpValue:setText("")
		end
	end
end
----------------------------------------------------------------------
----------------------------------兑换-------------------------------
--@brief 	显示兑换
function WndMagicStone:_showShop()
	self:_showCoinNum()

	-- body
	local tbExchangeList = GetElement(self.m_root, "tbExchangeList_WndMagicStone", WZUITableContainer)
	tbExchangeList:cleanTable()
	WZLog("WndMagicStone:_showShop", #self.m_tShopData)

	for i = 1, #self.m_tShopData do
		local element, tCell = CellMagicStoneShop:createElement()
		if element and tCell then 
			element:setTag(i - 1)
			tCell:setData(self.m_tShopData[i])

			tbExchangeList:setCellElement(element)
		end
	end
end

--@brief 	显示数量
function WndMagicStone:_showCoinNum()
	local txtC2CoinWord = GetElement(self.m_root, "txtC2CoinWord_WndMagicStone", WZUILabelTTF)
	local txtC2CoinValue = GetElement(self.m_root, "txtC2CoinValue_WndMagicStone", WZUILabelTTF)
	if self.m_nSeasonNum <= 27 then
		txtC2CoinWord:setText("")
		txtC2CoinValue:setText("")
	else
		local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		txtC2CoinWord:setText(LocalStrings.MAGIC_STONE_TEXT25[4]..":")
		txtC2CoinValue:setText(nNum)
	end
end

----------------------------------------------------------------------

--@brief 	设置私有方法
function WndMagicStone:setRedDot()
	-- body
	local bHaveRedDot_reward = self:_judgeCanGetReward()
	local conRewardRed = GetElement(self.m_root, "conRewardRed_WndMagicStone", WZUIContainer)
	local imgBtnRedDot = GetElement(self.m_root, "imgBtnRedDot_WndMagicStone", WZUIImage)
	
	local conAllServerRed = GetElement(self.m_root,"conAllServerRed_WndMagicStone",WZUIContainer)
	local bAllServerHaveRedPoint = self:_judgeAllServerCanGetReward()
	
	if conRewardRed then 
		conRewardRed:setVisible(bHaveRedDot_reward)
	end
	if conAllServerRed then 
		conAllServerRed:setVisible(bAllServerHaveRedPoint)
	end
	if self.m_nCurIndex == 0 then	
		if imgBtnRedDot then 
			imgBtnRedDot:setVisible(bHaveRedDot_reward)
		end
	elseif self.m_nCurIndex == 3 then
		if imgBtnRedDot then 
			imgBtnRedDot:setVisible(bAllServerHaveRedPoint)
		end
	end

	local conTaskRed = GetElement(self.m_root, "conTaskRed_WndMagicStone", WZUIContainer)
	local bHaveRedDot_advance = self:_judgeTaskRedDot()
	if conTaskRed then 
		conTaskRed:setVisible(bHaveRedDot_advance)
	end

	local btn = GetElementWithoutAssert(SceneCity.m_root, "btn" .. ISLAND_UP_MAGIC_STONE .. "_WndOwnCity", WZUIButton)
	if bHaveRedDot_advance or bHaveRedDot_reward or bAllServerHaveRedPoint then
		GlobalGame.g_tRedPointList.magicStone = true
        SceneCity:setRedPoint(btn, true, GlobalMethod:ccp(73,73))
    else
		GlobalGame.g_tRedPointList.magicStone = false
        SceneCity:setRedPoint(btn,false)
        ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(243)
    end
end
-------------------------------------私有方法模块End----------------------------------------

--@brief	越南语包适配函数
function WndMagicStone:_adaptLanguage_vn()
	local txtBoxAllServerSel = GetElement(self.m_root, "txtBoxAllServerSel_WndMagicStone", WZUILabelTTF)
	if txtBoxAllServerSel then
		txtBoxAllServerSel:setScale(0.7)
	end
	local txtBoxAllServer = GetElement(self.m_root, "txtBoxAllServer_WndMagicStone", WZUILabelTTF)
	if txtBoxAllServer then
		txtBoxAllServer:setScale(0.7)
	end
	local commonReward = GetElement(self.m_root, "commonReward", WZUILabelTTF)
	if commonReward then
		commonReward:setRotation(90)
	end
	local bonusReward = GetElement(self.m_root, "bonusReward", WZUILabelTTF)
	if bonusReward then
		bonusReward:setDimensions(GlobalMethod:CCSize(330))
		bonusReward:setRotation(90)
	end
	local btnBuyBoxLabel = GetElement(self.m_root, "btnBuyBoxLabel", WZUILabelTTF)
	if btnBuyBoxLabel then
		btnBuyBoxLabel:setDimensions(GlobalMethod:CCSize(130))
		btnBuyBoxLabel:setScale(0.8)
	end

	GetElement(self.m_root, "txtC0Reward1_WndMagicStone", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtC0Reward2_WndMagicStone", WZUILabelTTF):setScale(0.7)
end