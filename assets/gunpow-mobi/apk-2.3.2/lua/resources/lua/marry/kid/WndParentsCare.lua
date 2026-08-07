--WndParentsCare.lua
--@brief	WndParentsCare的UI模块
--@date		2018/05/07
--@author	Tianxiang_Xu
--@note		关爱界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndParentsCare:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndParentsCare:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndParentsCare:onEnterTransitionDidFinish(element)
    -- body
    local tTempConfigCare = json.decode(CacheCenter:getGameParam().careBuffConfig)
    local tTempConfig = json.decode(CacheCenter:getGameParam().childInteractConfig)
    WZLog("WndParentsCare:onEnterTransitionDidFinish", Serialize(tTempConfigCare), Serialize(tTempConfig))
    self.m_tCareConfig = tTempConfigCare
    self.m_tPlayCarConfig = tTempConfig

    if self.m_nType == 1 then
    	self.m_careCost = self.m_tCareConfig.cost
    elseif self.m_nType == 2 then
    	self.m_careCost = self.m_tPlayCarConfig.playerCarCost
    end

    if self.m_nType == 3 or self.m_nType == 4 or self.m_nType == 5 then
    else
    	self:_update()
    end

end

--@brief	关闭
function WndParentsCare:onClose(element)
	WZLog("WndParentsCare:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	
	self:closeWindow()
end

--@brief 	关闭窗口
function WndParentsCare:closeWindow()
	-- body
	WndKidOperate.m_bIsClickFunc = false
	if self.m_nType == 5 then
		if WindowManager:getSceneRoot():getLuaObjectName() == "SceneMarryWedding" then
	        replaceScene(SceneCity:createElement())
	    elseif WindowManager:getSceneRoot():getLuaObjectName() == "SceneMarryCopy" then
        	replaceScene(SceneCity:createElement())
		elseif WindowManager:getSceneRoot():getLuaObjectName() == "SceneKidHome" then
	        replaceScene(SceneCity:createElement())
	    end
	end
	if self.m_root == nil then
		return
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击相应的小孩头像回调
function WndParentsCare:onClickKid(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if self.m_nType == 5 then return end --展示离婚结果不需要触摸

	if self.m_nType == 3 or self.m_nType == 4 then 
		if #self.m_tData == 1 then
			if self.m_tData[1].ownerId == CacheCenter:getPlayerInfo().id then --婚前自己的孩子
				if nTag == 3 then
					MsgBoxManager:showTipBox(LocalStrings.KID_TEXT87)
					return 
				end
			elseif self.m_tData[1].ownerId ~= 0 and self.m_tData[1].ownerId ~= CacheCenter:getPlayerInfo().id then --伴侣的孩子
				if nTag == 1 then
					MsgBoxManager:showTipBox(LocalStrings.KID_TEXT88)
					return 
				end
			elseif self.m_tData[1].ownerId == 0 then --婚后生的孩子
				if self.m_nType == 3 then
					if nTag == 1 then
						self:setKidFightingAddAtt(1)
					elseif nTag == 3 then
						self:setKidFightingAddAtt(3)
					end
				end

				self.m_nIndexSel = nTag
				GetElement(self.m_root, "imgSel1_WndParentsCare", WZUIImage):setVisible(false)
				GetElement(self.m_root, "imgSel3_WndParentsCare", WZUIImage):setVisible(false)
				GetElement(self.m_root, "imgSel" .. self.m_nIndexSel .. "_WndParentsCare", WZUIImage):setVisible(true)
			end			
		else
			if self.m_tData[nTag].ownerId ~= 0 and self.m_tData[nTag].ownerId ~= CacheCenter:getPlayerInfo().id then
				MsgBoxManager:showTipBox(LocalStrings.KID_TEXT88)
				return 
			else
				local bHaved = self:havedChildAlready()
				if bHaved then
					if self.m_tData[nTag].ownerId ~= CacheCenter:getPlayerInfo().id then
						MsgBoxManager:showTipBox(LocalStrings.KID_TEXT91)
						return 
					end
				else
					if self.m_tData[nTag].ownerId ~= 0 then
						MsgBoxManager:showTipBox(LocalStrings.KID_TEXT88)
						return 
					else
						if self.m_nIndexSel == nTag then return end 

						self.m_nIndexSel = nTag 
						GetElement(self.m_root, "imgSel1_WndParentsCare", WZUIImage):setVisible(false)
						GetElement(self.m_root, "imgSel2_WndParentsCare", WZUIImage):setVisible(false)
						GetElement(self.m_root, "imgSel" .. self.m_nIndexSel .. "_WndParentsCare", WZUIImage):setVisible(true)

						self:setKidFightingAddAtt()
					end
				end
			end
		end
	else
		if self.m_nIndexSel == nTag then return end 

		local imgSel1 = GetElement(self.m_root, "imgSel1_WndParentsCare", WZUIImage)
		local imgSel2 = GetElement(self.m_root, "imgSel2_WndParentsCare", WZUIImage)
		self.m_nIndexSel = nTag 
		WZLog("WndParentsCare:onClickCheckBox", nTag)
		if nTag == 1 then
			imgSel1:setVisible(true)
			imgSel2:setVisible(false)
		else
			imgSel1:setVisible(false)
			imgSel2:setVisible(true)
		end

		--刷新战力加成说明
		self:setKidFightingAddAtt()
	end
end

--@brief 	点击关爱按钮回调
function WndParentsCare:onClickCare(element)
	-- body 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nType == 1 then
		if SceneKidHome.m_nCareBuffToday == 1 then
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT71)
			return 
		end
	elseif self.m_nType == 2 then
		if SceneKidHome.m_tKidData[self.m_nIndexSel].playCar == 1 then
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT68)
			return 
		end
	end
	if self.m_nType == 1 or self.m_nType == 2 then
		local ids, num = SplitItemString(self.m_careCost)
		if not JudgeMoneyIsEnough(tonumber(ids[1]), tonumber(num[1]), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToContinue) then
			return 
		end
	elseif self.m_nType == 3 then
		local divorcePrice =  CacheCenter:getGameParam().DivorcePrice
	    if divorcePrice == nil then
	        divorcePrice = 886
	    end
	    divorcePrice = tonumber(divorcePrice)
	    if self.m_nNeedPay == 1 then 
		    if CacheCenter:getGameParam().isUseTicket == "0" then
		        if not JudgeMoneyIsEnough(70, divorcePrice, string.format(LocalStrings.DIVORCE_WEDDING_NOT_ENOUGH,divorcePrice), nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToContinue) then
		            return
		        end
		    else
		        if not JudgeMoneyIsEnough(1, divorcePrice, string.format(LocalStrings.DIVORCE_WEDDING_NOT_ENOUGH,divorcePrice), nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToContinue) then
		            return
		        end
		    end
		end
	elseif self.m_nType == 4 then
		local nKidId = 0
		if self.m_nIndexSel == 3 then
			nKidId = 0
		else
			nKidId = self.m_tData[self.m_nIndexSel].id
		end

		ProtocolProcessorWndMarry:send_WEDDING_SelectChild(nKidId)
		return 
	elseif self.m_nType == 5 then
		self:closeWindow()
		return 
	end

	self:sureToContinue()
end

--@brief 	继续关爱操作
function WndParentsCare:sureToContinue()
	-- body
	if self.m_nType == 3 then
		WndMarryManager:createLoading()

		local nKidId = 0
		if self.m_nIndexSel == 3 then
			nKidId = 0
		else
			nKidId = self.m_tData[self.m_nIndexSel].id
		end
    	ProtocolProcessorWndMarry:send_WEDDING_RemoveEngagement(nKidId)
	else
		--发送关爱协议
		SceneKidHome:_createLoading()

		if self.m_nType == 1 then
			ProtocolProcessorKid:send_WEDDING_GetChildBuff(SceneKidHome.m_tKidData[self.m_nIndexSel].id)
		elseif self.m_nType == 2 then
			if SceneKidHome.m_tCellKidRole and SceneKidHome.m_tCellKidRole[self.m_nIndexSel] then
				local bIsPlayCar = SceneKidHome.m_tCellKidRole[self.m_nIndexSel]:getPlayCarState()
				if bIsPlayCar then
					MsgBoxManager:showTipBox(LocalStrings.KID_TEXT121)
					return 
				end
			end
			ProtocolProcessorKid:send_WEDDING_ChildInteract(SceneKidHome.m_tKidData[self.m_nIndexSel].id, 2, self.m_tData.indexX - 1, self.m_tData.indexY - 1)
		end
	end
end

--@brief    规则按钮回调
function WndParentsCare:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.KID_TEXT107)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndParentsCare:_update()
	-- body
	self:setStaticText()
	self:setKidFightingAddAtt()
	self:showKidInfo()
end

--@brief 	设置静态文本
function WndParentsCare:setStaticText()
	-- body 
	local txtCare = GetElement(self.m_root, "txtCare_WndParentsCare", WZUILabelTTF)
	local txtTitle = GetElement(self.m_root, "txtTitle_WndParentsCare", WZUILabelTTF)
	local btnRule = GetElement(self.m_root, "btnRule_WndParentsCare", WZUIButton)
	if self.m_nType == 1 then
		if txtCare then
			txtCare:setText(LocalStrings.KID_TEXT9)
		end

		if txtTitle then
			txtTitle:setText(LocalStrings.KID_TEXT10)
		end
		btnRule:setVisible(true)
	elseif self.m_nType == 2 then
		if txtCare then
			txtCare:setText(LocalStrings.KID_TEXT65)
		end

		if txtTitle then
			txtTitle:setText(LocalStrings.KID_TEXT66)
		end
	elseif self.m_nType == 3 or self.m_nType == 4 then
		if txtCare then
			txtCare:setText(LocalStrings.KID_TEXT80)
		end

		if txtTitle then
			txtTitle:setText(LocalStrings.KID_TEXT79)
		end
	elseif self.m_nType == 5 then
		if txtCare then
			txtCare:setText(LocalStrings.CONFIRM)
		end

		if txtTitle then
			txtTitle:setText(LocalStrings.KID_TEXT79)
		end
	end
end

--@brief	设置战力加成文字提示和关爱消耗
function WndParentsCare:setKidFightingAddAtt(nAttIndex)
	-- body
	local ftbExplanation = GetElement(self.m_root, "ftbExplanation_WndParentsCare", WZUIFreeTextBox)
	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndParentsCare", WZUIFreeTextBox)
	local ftxtPlayerCar = GetElement(self.m_root, "ftxtPlayerCar_WndParentsCare", WZUIFreeTextBox)
	if self.m_nType == 1 then
		ftxtPlayerCar:setVisible(false)
		ftbExplanation:setVisible(true)
		ftbExplanation:setRelativePosition(GlobalMethod:ccp(0.5,0.337))
		if ftbExplanation then
			local nHours = math.floor(self.m_tCareConfig.lastMinute/60)
			local nFighting = 0
			local tItem = {}
			for i = 1, 20 do if tItem[tostring(i)] == nil then tItem[tostring(i)] = 0 end end
			for i = 1, #SceneKidHome.m_tKidData do
				local tProperty = json.decode(SceneKidHome.m_tKidData[i].property)
				local nAddPercentValue = 100

				if i ~= self.m_nIndexSel then
					nAddPercentValue = self.m_tCareConfig.otherChildRatio
				end
				for k, v in pairs(tProperty) do
					local nCareValue = SceneKidHome.m_tKidData[i].careValue
					if nCareValue > 100 then
						nCareValue = 100
					end
					tItem[tostring(k)] = tItem[tostring(k)] + math.ceil(v * (nAddPercentValue/100) * (nCareValue/100) * (self.m_tCareConfig.ratio/100))
				end
			end

			nFighting = caculateClothesFighting(tItem)

			-- 拜访加成
			local nRemainingTime = SceneKidHome.m_nSingleVisitTime - (SystemTime:getServerTime() - SceneKidHome.m_tVisitingTime)
			if nRemainingTime > 0 and SceneKidHome.m_tVisitorChild and SceneKidHome.m_tVisitorChild[1] then
				local childFight = SceneKidHome.m_tVisitorChild[1].fighting
				nFighting = math.ceil(nFighting+childFight*0.1)
			end

			ftbExplanation:setShowText(string.format(LocalStrings.KID_TEXT7, nFighting, nHours))
		end
		--关爱消耗
		local ids, num = SplitItemString(self.m_careCost)
		ftxtCost:setVisible(true)
		if ftxtCost then
			local sFormat = [[<I Z="0.5">%s</I><T C="255,236,193" S="20" P="1" SC="127,70,26" SS="4" SE="1">%d</T>]]
			local basicData = GDatatab_item["id_" .. ids[1]]
			ftxtCost:setShowText(string.format(sFormat, basicData.icon, tonumber(num[1])))
		end
	elseif self.m_nType == 2 then
		ftxtCost:setVisible(false)
		ftbExplanation:setVisible(false)
		ftxtPlayerCar:setVisible(true)
		local ids, num = SplitItemString(self.m_careCost)
		local basicData = GDatatab_item["id_" .. ids[1]]
		local sContent = string.format(LocalStrings.KID_TEXT67, tonumber(num[1]), basicData.icon, SceneKidHome.m_tKidData[self.m_nIndexSel].name, self.m_tPlayCarConfig.playAddCare, self.m_tPlayCarConfig.playContinousAddCare)
		ftxtPlayerCar:setShowText(sContent)
	elseif self.m_nType == 3 then--离婚
		ftxtPlayerCar:setVisible(false)
		ftbExplanation:setVisible(true)
		ftbExplanation:setRelativePosition(GlobalMethod:ccp(0.5,0.426))
		ftxtCost:setVisible(false)

		local divorcePrice =  CacheCenter:getGameParam().DivorcePrice
	    if divorcePrice == nil then
	        divorcePrice = 886
	    end
	    divorcePrice = tonumber(divorcePrice)

		local sContent = string.format(LocalStrings.KID_TEXT90, divorcePrice)
		if self.m_nNeedPay == 0 then 
			local spouseleave = CacheCenter:getGameParam().spouseleave
			sContent = string.format(LocalStrings.WEDDING_END_REQUEST_NOPAY, spouseleave)
		end
		if nAttIndex == 1 then
			local sTemp = ""

			if self.m_tData[1].fatherDevote > self.m_tData[1].motherDevote then
				if CacheCenter:getPlayerInfo().sex == 0 then
					sTemp = LocalStrings.KID_TEXT92
				else
					sTemp = LocalStrings.KID_TEXT93
				end
			else
				if CacheCenter:getPlayerInfo().sex == 0 then
					sTemp = LocalStrings.KID_TEXT93
				else
					sTemp = LocalStrings.KID_TEXT92
				end
			end

			sContent = sContent .. sTemp
		elseif nAttIndex == 3 then --放弃孩子
			sContent = sContent .. LocalStrings.KID_TEXT82
		else
			sContent = sContent .. LocalStrings.KID_TEXT94
		end

		local strFormat = [[<T C="127,70,26" S="20" P="1">%s</T>]]
		sContent = string.format(strFormat,sContent)
		local strFormat1 = [[<T C="158,0,0" S="20" P="1">(%s)</T>]]
		local strCDTime = string.format(strForm1, LocalStrings.MARRY_END[3] .. returnToTimeFormat_Day(self.m_nDivorceCDTime))
		ftbExplanation:setShowText(sContent .. strCDTime)
	elseif self.m_nType == 4 then
		local sContent = ""
		if self.m_nMateSelKidId == 0 then
			sContent = sContent .. LocalStrings.KID_TEXT96
		else
			local tTempData = self:getKidDataById()
			local sTemp = string.format(LocalStrings.KID_TEXT95, tTempData.name)
			sContent = sContent .. sTemp
		end

		local strFormat = [[<T C="127,70,26" S="20" P="1">%s</T>]]
		sContent = string.format(strFormat,sContent)
		ftbExplanation:setShowText(sContent)
	elseif self.m_nType == 5 then
		local sContent = ""
		if #self.m_tData == 1 then
			if self.m_tData[1].playerId == CacheCenter:getPlayerInfo().id then
				local sTemp = string.format(LocalStrings.KID_TEXT97, self.m_tData[1].name)
				sContent = sContent .. sTemp
			else
				local sTemp = string.format(LocalStrings.KID_TEXT98, self.m_tData[1].name)
				sContent = sContent .. sTemp
			end
		else
			local sName1 = ""
			local sName2 = ""
			if self.m_tData[1].playerId == CacheCenter:getPlayerInfo().id then
				sName1 = self.m_tData[1].name
			else
				sName2 = self.m_tData[1].name
			end

			if self.m_tData[2].playerId == CacheCenter:getPlayerInfo().id then
				sName1 = self.m_tData[2].name
			else
				sName2 = self.m_tData[2].name
			end

			local sTemp = string.format(LocalStrings.KID_TEXT99, sName1, sName2)
			sContent = sContent .. sTemp
		end

		local strFormat = [[<T C="127,70,26" S="20" P="1">%s</T>]]
		sContent = string.format(strFormat,sContent)
		ftbExplanation:setShowText(sContent)
	end
end

-- 拜访剩余倒计时
function WndParentsCare:_updateVisitTime()
	local conVisitKid = GetElement(self.m_root, "conVisitKid_WndParentsCare", WZUIContainer)
    local ftbVisitTime = GetElement(self.m_root, "ftbVisitTime_WndParentsCare", WZUIFreeTextBox)
    local nRemainingTime = SceneKidHome.m_nSingleVisitTime - (SystemTime:getServerTime() - SceneKidHome.m_tVisitingTime)

    if nRemainingTime <= 0 then
        ftbVisitTime:setShowText("")
        GetElement(self.m_root,"txtCareTips_WndParentsCare",WZUILabelTTF):setVisible(true)
        GetElement(self.m_root, "conVisitInfo_WndParentsCare", WZUIContainer):setVisible(false)
        self:setKidFightingAddAtt() --刷新战力
        conVisitKid:disableSchedule()
    else
        local s = nRemainingTime%60
        local m = math.floor(nRemainingTime/60)%60
        local h = math.floor(nRemainingTime/3600)

        ftbVisitTime:setShowText(string.format(LocalStrings.KID_HOME_TEXT8,h,m,s))
    end
end

--@brief 	显示孩子信息
function WndParentsCare:showKidInfo()
	-- body
	self.m_tKidCellList = {}

	if self.m_nType == 1 then
		for i = 1, #SceneKidHome.m_tKidData do
			local conKidInfo = GetElement(self.m_root, "conKidInfo" .. i .. "_WndParentsCare", WZUIContainer)
			if conKidInfo:getChildByTag(99) then
				conKidInfo:removeChildByTag(99, true)
			end

			local element, tNewObj = CellKidItem:createElement()
			if element and tNewObj then
				conKidInfo:setVisible(true)
				element:setTag(99)
				tNewObj:setData(SceneKidHome.m_tKidData[i], 2)
				conKidInfo:addChild(element)

				table.insert(self.m_tKidCellList, tNewObj)
			end
		end
		if #SceneKidHome.m_tKidData == 1 then
			local conKidInfo = GetElement(self.m_root, "conKidInfo1_WndParentsCare", WZUIContainer)
			if conKidInfo then
				conKidInfo:setRelativePosition(GlobalMethod:ccp(0.5, 0.71))
			end
		end

		--拜访
	    local nRemainingTime = SceneKidHome.m_nSingleVisitTime - (SystemTime:getServerTime() - SceneKidHome.m_tVisitingTime)
		GetElement(self.m_root,"conVisitKid_WndParentsCare",WZUIContainer):setVisible(true)
		if nRemainingTime > 0 and SceneKidHome.m_tVisitorChild and SceneKidHome.m_tVisitorChild[1] then
			GetElement(self.m_root,"txtCareTips_WndParentsCare",WZUILabelTTF):setVisible(false)
        	GetElement(self.m_root, "conVisitInfo_WndParentsCare", WZUIContainer):setVisible(true)

			local conVisitKidHead = GetElement(self.m_root, "conVisitKidHead_WndParentsCare", WZUIContainer)
			local kidHead = CellHead:show(conVisitKidHead, SceneKidHome.m_tVisitorChild[1].headId, SceneKidHome.m_tVisitorChild[1].faceId, SceneKidHome.m_tVisitorChild[1].sex, nil, nil, nil, nil, nil, nil, nil, true, SceneKidHome.m_tVisitorChild[1].headEffectId)
			kidHead:setScale(0.8)

			local strFormat = [[<T C="127,70,26" S="20" P="1">%s</T><T C="255,105,22" S="20" P="1"> %d</T>]]
			local ftbKidAttri1 = GetElement(self.m_root, "ftbKidAttri1_WndParentsCare", WZUIFreeTextBox)
			ftbKidAttri1:setShowText(string.format(strFormat,LocalStrings.SPACE55,SceneKidHome.m_tVisitorChild[1].level/10))
			local ftbKidAttri2 = GetElement(self.m_root, "ftbKidAttri2_WndParentsCare", WZUIFreeTextBox)
			ftbKidAttri2:setShowText(string.format(strFormat,LocalStrings.BATTLE..":",SceneKidHome.m_tVisitorChild[1].fighting))

			local conVisitKid = GetElement(self.m_root, "conVisitKid_WndParentsCare", WZUIContainer)
			conVisitKid:enableSchedule("_updateVisitTime",1)
		end

	elseif self.m_nType == 3 or self.m_nType == 4 then
		for i = 1, #self.m_tData do
			local conKidInfo = GetElement(self.m_root, "conKidInfo" .. i .. "_WndParentsCare", WZUIContainer)
			if conKidInfo:getChildByTag(99) then
				conKidInfo:removeChildByTag(99, true)
			end

			local element, tNewObj = CellKidItem:createElement()
			if element and tNewObj then
				conKidInfo:setVisible(true)
				element:setTag(99)
				tNewObj:setData(self.m_tData[i], 3)
				conKidInfo:addChild(element)

				table.insert(self.m_tKidCellList, tNewObj)
			end
		end
		if #self.m_tData == 1 then
			GetElement(self.m_root, "imgSel1_WndParentsCare", WZUIImage):setVisible(false)
			GetElement(self.m_root, "imgSel3_WndParentsCare", WZUIImage):setVisible(false)
			GetElement(self.m_root, "imgSel" .. self.m_nIndexSel .. "_WndParentsCare", WZUIImage):setVisible(true)
		
			local conKidInfo3 = GetElement(self.m_root, "conKidInfo3_WndParentsCare", WZUIContainer)
			conKidInfo3:setVisible(true)

			self:setKidHead()
		else
			GetElement(self.m_root, "imgSel1_WndParentsCare", WZUIImage):setVisible(false)
			GetElement(self.m_root, "imgSel2_WndParentsCare", WZUIImage):setVisible(false)
			GetElement(self.m_root, "imgSel" .. self.m_nIndexSel .. "_WndParentsCare", WZUIImage):setVisible(true)
		end
	elseif self.m_nType == 5 then
		for i = 1, #self.m_tData do
			local conKidInfo = GetElement(self.m_root, "conKidInfo" .. i .. "_WndParentsCare", WZUIContainer)
			if conKidInfo:getChildByTag(99) then
				conKidInfo:removeChildByTag(99, true)
			end

			local element, tNewObj = CellKidItem:createElement()
			if element and tNewObj then
				conKidInfo:setVisible(true)
				element:setTag(99)
				tNewObj:setData(self.m_tData[i], 5)
				conKidInfo:addChild(element)

				table.insert(self.m_tKidCellList, tNewObj)
			end
		end
		if #self.m_tData == 1 then
			local conKidInfo = GetElement(self.m_root, "conKidInfo1_WndParentsCare", WZUIContainer)
			if conKidInfo then
				conKidInfo:setRelativePosition(GlobalMethod:ccp(0.5, 0.71))
			end
			GetElement(self.m_root, "imgSel1_WndParentsCare", WZUIImage):setVisible(false)
		else
			GetElement(self.m_root, "imgSel1_WndParentsCare", WZUIImage):setVisible(false)
			GetElement(self.m_root, "imgSel2_WndParentsCare", WZUIImage):setVisible(false)
		end
	else
		for i = 1, #SceneKidHome.m_tKidData do
			local conKidInfo = GetElement(self.m_root, "conKidInfo" .. i .. "_WndParentsCare", WZUIContainer)
			if conKidInfo:getChildByTag(99) then
				conKidInfo:removeChildByTag(99, true)
			end

			local element, tNewObj = CellKidItem:createElement()
			if element and tNewObj then
				conKidInfo:setVisible(true)
				element:setTag(99)
				tNewObj:setData(SceneKidHome.m_tKidData[i], 2)
				conKidInfo:addChild(element)

				table.insert(self.m_tKidCellList, tNewObj)
			end
		end
		if #SceneKidHome.m_tKidData == 1 then
			local conKidInfo = GetElement(self.m_root, "conKidInfo1_WndParentsCare", WZUIContainer)
			if conKidInfo then
				conKidInfo:setRelativePosition(GlobalMethod:ccp(0.5, 0.71))
			end
		end
	end
end

--@brief 	设置小孩头像
function WndParentsCare:setKidHead()
	-- body
	local conHead = GetElement(self.m_root, "conHead_WndParentsCare", WZUIContainer)
	local kidHead = CellHead:show(conHead, self.m_tData[1].headId, self.m_tData[1].faceId, self.m_tData[1].sex, nil, nil, nil, nil, nil, nil, nil, true, self.m_tData[1].headEffectId)
	kidHead:setScale(1)

	GetElement(self.m_root, "txtName_WndParentsCare", WZUILabelTTF):setText(self.m_tData[1].name)
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function WndParentsCare:_adaptLanguage_vn(  )
	local txtCare = GetElement(self.m_root, "txtCare_WndParentsCare", WZUILabelTTF)
	txtCare:setScale(0.75)
	txtCare:setDimensions(GlobalMethod:CCSize(160))
end

function WndParentsCare:_adaptLanguage_en(  )
	local txtCare = GetElement(self.m_root, "txtCare_WndParentsCare", WZUILabelTTF)
	txtCare:setScale(0.75)
	txtCare:setDimensions(GlobalMethod:CCSize(160))

	local txtExplanation = GetElement(self.m_root, "txtExplanation_WndParentsCare", WZUILabelTTF)
	txtExplanation:setScale(0.8)
	txtExplanation:setDimensions(GlobalMethod:CCSize(500))
end

function WndParentsCare:_adaptLanguage_th(  )
	local txtCare = GetElement(self.m_root, "txtCare_WndParentsCare", WZUILabelTTF)
	txtCare:setScale(0.9)
end

function WndParentsCare:_adaptLanguage_pt(  )
	local txtCare = GetElement(self.m_root, "txtCare_WndParentsCare", WZUILabelTTF)
	txtCare:setScale(0.75)
	txtCare:setDimensions(GlobalMethod:CCSize(160))

	GetElement(self.m_root, "txtGiveup_WndParentsCare", WZUILabelTTF):setScale(0.8)
	
	local txtExplanation = GetElement(self.m_root, "txtExplanation_WndParentsCare", WZUILabelTTF)
	txtExplanation:setScale(0.8)
	txtExplanation:setDimensions(GlobalMethod:CCSize(500))
end

function WndParentsCare:_adaptLanguage_es(  )
	local txtCare = GetElement(self.m_root, "txtCare_WndParentsCare", WZUILabelTTF)
	txtCare:setScale(0.75)
	txtCare:setDimensions(GlobalMethod:CCSize(160))

	GetElement(self.m_root, "txtGiveup_WndParentsCare", WZUILabelTTF):setScale(0.8)
	
	local txtExplanation = GetElement(self.m_root, "txtExplanation_WndParentsCare", WZUILabelTTF)
	txtExplanation:setScale(0.8)
	txtExplanation:setDimensions(GlobalMethod:CCSize(500))
end

function WndParentsCare:_adaptLanguage_tr(  )
	local txtCare = GetElement(self.m_root, "txtCare_WndParentsCare", WZUILabelTTF)
	txtCare:setScale(0.75)
	txtCare:setDimensions(GlobalMethod:CCSize(160))
end
-------------------------------------语言适配End----------------------------------------