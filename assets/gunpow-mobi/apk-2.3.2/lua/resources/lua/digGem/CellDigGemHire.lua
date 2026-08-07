--CellDigGemHire.lua
--@brief	CellDigGemHire的UI模块
--@date		2021/03/31
--@author	yrd
--@note		挖矿界面-雇佣格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDigGemHire:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDigGemHire:onExit(element)
	self:_unInit()
end

--@brief	打开加载动画
function CellDigGemHire:onEnterTransitionDidFinish(element)
	self:updateUI()
end

--@brief	刷新界面
function CellDigGemHire:updateUI()
	--头像
	local conHead = GetElement(self.m_root, "conHead_CellDigGemHire", WZUIContainer)
	CellHead:show(conHead, self.m_tData.headItemId, self.m_tData.faceItemId, self.m_tData.sex, false, nil, self.m_tData.vipLevel, self.m_tData.headColor)
	--矿工等级 名字
	local ftbName = GetElement(self.m_root, "ftbName_CellDigGemHire", WZUIFreeTextBox)
	local strFormat = [[<T C="127,70,26" S="18" P="1">%s  </T><T C="127,70,26" S="18" P="1"> Lv</T><T C="255,105,22" S="18" P="1">%s</T>]]
	ftbName:setShowText(string.format(strFormat,self.m_tData.playerName,self.m_tData.minerLevel))
	--事件
	local txtEvent = GetElement(self.m_root, "txtEvent_CellDigGemHire", WZUILabelTTF)
	local strTime = ""
	local nLogTime = SystemTime:getServerTime() - self.m_tData.logTime
	if nLogTime < 60 then --刚刚
		strTime = LocalStrings.DIGGEM_TEXT55[1]
	elseif nLogTime < 3600 then --分钟前
		strTime = string.format(LocalStrings.DIGGEM_TEXT55[2],math.floor(nLogTime/60))
	elseif nLogTime < 86400 then --小时前
		strTime = string.format(LocalStrings.DIGGEM_TEXT55[3],math.floor(nLogTime/3600))
	else --天前
		strTime = string.format(LocalStrings.DIGGEM_TEXT55[4],math.floor(nLogTime/86400))
	end
	local strEvent = ""
	if self.m_tData.logtype == 9 then --雇佣你进行挖矿
		strEvent = LocalStrings.DIGGEM_TEXT54[1]
	elseif self.m_tData.logtype == 10 then --给了你一个飞吻
		strEvent = LocalStrings.DIGGEM_TEXT54[2]
	elseif self.m_tData.logtype == 11 then --喂你吃了个面包
		strEvent = LocalStrings.DIGGEM_TEXT54[3]
	elseif self.m_tData.logtype == 12 then --鞭打了你
		strEvent = LocalStrings.DIGGEM_TEXT54[4]
	end
	if strEvent ~= "" then
		txtEvent:setText(strTime..strEvent)
	end
	--好友状态
	local ftbCost = GetElement(self.m_root,"ftbCost_CellDigGemHire", WZUIFreeTextBox)
	local btnCost = GetElement(self.m_root,"btnCost_CellDigGemHire",WZUIButton)
	local txtHiring = GetElement(self.m_root,"txtHiring_CellDigGemHire", WZUILabelTTF)
	local txtRemainingTime = GetElement(self.m_root,"txtRemainingTime_CellDigGemHire", WZUILabelTTF)
	txtRemainingTime:disableSchedule()
	if self.m_tData.hireId == 0 or self.m_tData.hireEndTime < SystemTime:getServerTime() then --没被雇佣
		ftbCost:setVisible(true)
		btnCost:setVisible(true)
		txtHiring:setVisible(false)
		txtRemainingTime:setVisible(false)

    	local tEmployInfo = GDatatab_mining_employ["id_"..self.m_tData.minerLevel]
    	local sCostIcon = GDatatab_item["id_"..tEmployInfo.price[1][1]].icon
	    local miningConfig = json.decode(CacheCenter:getGameParam().miningConfig)
		local toolHours = math.ceil(WndDigGem.m_nToolLeftTime/3600)
    	local minHours = math.min(miningConfig.employTime,toolHours) --最多不能超过配置的8小时
    	local strFormat = [[<I Z="0.35">%s</I><T C="127,70,26" S="18" P="0">%s</T>]]
		ftbCost:setShowText(string.format(strFormat,sCostIcon,tEmployInfo.price[1][2]*minHours))

		if minHours <= 0 then
			ftbCost:setVisible(false)
		end
	else
		ftbCost:setVisible(false)
		btnCost:setVisible(false)
		txtHiring:setVisible(true)
		txtRemainingTime:setVisible(true)

		txtHiring:setText(LocalStrings.DIGGEM_TEXT71)
		if self.m_tData.hireId == CacheCenter:getPlayerInfo().id then
			txtHiring:setText(LocalStrings.DIGGEM_TEXT53)
		end
		txtRemainingTime:setText("")
		local nTime = self.m_tData.hireEndTime - SystemTime:getServerTime()
		if nTime > 0 then
			local strTime = returnToTimeFormat(nTime)
			txtRemainingTime:setText(strTime)
			txtRemainingTime:enableSchedule("_countDownSchedule",1)
		end
	end
end

function CellDigGemHire:_countDownSchedule(element)
	local txtRemainingTime = GetElement(self.m_root,"txtRemainingTime_CellDigGemHire", WZUILabelTTF)
	local nTime = self.m_tData.hireEndTime - SystemTime:getServerTime()
	if nTime <= 0 then
		self:updateUI()
	end
	local strTime = returnToTimeFormat(nTime)
	txtRemainingTime:setText(strTime)
end

-- 点击雇佣按钮回调
function CellDigGemHire:onClickHire(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --开始挖矿才能雇佣
    if WndDigGem.m_bIsStart ~= true then
    	MsgBoxManager:showTipBox(LocalStrings.DIGGEM_TEXT66)
    	return
    end
    --最多雇佣2个人
    if WndDigGem.m_nHireNum >= 2 then
    	MsgBoxManager:showTipBox(LocalStrings.DIGGEM_TEXT70)
    	return
    end
    --改玩家已被雇佣
    if self.m_tData.hireId ~= 0 and self.m_tData.hireEndTime >= SystemTime:getServerTime() then
    	MsgBoxManager:showTipBox(LocalStrings.DIGGEM_TEXT67)
    	return
    end
    --货币不够
    local tEmployInfo = GDatatab_mining_employ["id_"..self.m_tData.minerLevel]
    local nItemCount = CacheCenter:getPlayerItemCountById(tEmployInfo.price[1][1])
    local miningConfig = json.decode(CacheCenter:getGameParam().miningConfig)
	local toolHours = math.ceil(WndDigGem.m_nToolLeftTime/3600)
    local minHours = math.min(miningConfig.employTime,toolHours) --最多不能超过配置的8小时
    WZLog("雇佣需要得矿井",tEmployInfo.price[1][1],tEmployInfo.price[1][2])
    if nItemCount < tEmployInfo.price[1][2]*minHours then
        JudgeMoneyIsEnough(tEmployInfo.price[1][1], tEmployInfo.price[1][2]*minHours,nil,nil,194)
        return 
    end
    ProtocolProcessorDigGem:send_MINING_HireFriend(self.m_tData.playerId)
end

-- 点击玩家头像回调
function CellDigGemHire:onClickHead(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tData.playerId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
