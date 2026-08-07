--CellDressGoodSeat.lua
--@brief	CellDressGoodSeat的UI模块
--@date		2019/06/03
--@author	Tianxiang_Xu
--@note		时装点赞-玩家形象UI


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDressGoodSeat:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDressGoodSeat:onExit(element)
	self:_unInit()
end

--@brief 	点击角色回调
function CellDressGoodSeat:onClickRole(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nType == 0 then 
		return
	elseif self.m_nType == 1 then 
		WndCharmSpace:onGiveGoodCallBack(self, self.m_tData)
	elseif self.m_nType == 2 then 
		WndCheckOther:show(self.m_tData.id)
	end 
end

--@brief 	点击点赞按钮回调
function CellDressGoodSeat:onClickGood(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTimes = WndCharmSpace:getOperateTimes()
	if nTimes <= 0 then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT6)
	else
		if self.m_tData.id == CacheCenter:getPlayerInfo().id then 
			MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT29)
			return 
		end

		ProtocolProcessorWndSpace:send_SPACE_GiveLike(self.m_tData.id)
	end
end

--@brief 	点击查看按钮回调
function  CellDressGoodSeat:onClickCheck(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndCheckOther:show(self.m_tData.id)
end

--@brief 	加载
function CellDressGoodSeat:onLoadData(element)
	-- body
	local cellElement = WZUISystem:getInstance():createElement("CellDressGoodSeat")
	self.m_root:addChild(cellElement)

	self.m_bIsLoaded = true
	self:_update()
end

--@brief 	设置点赞按钮不可见
function CellDressGoodSeat:setBottomBtnVisible(bVisible)
	-- body
	if self.m_bIsLoaded == false then return end 
	
	GetElement(self.m_root, "conButton_CellDressGoodSeat", WZUIContainer):setVisible(bVisible)
end

--@brief 	
function CellDressGoodSeat:checkPointInBtn(pt)
	-- body
	local btn
	btn = GetElement(self.m_root, "btnCheck_CellDressGoodSeat", WZUIButton)
	if btn then
		local btnSize = btn:getContentSize()
		--获得btn的世界坐标
		local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
			return true
		end 
	end
	btn = GetElement(self.m_root, "btnGiveGood_CellDressGoodSeat", WZUIButton)
	if btn then
		local btnSize = btn:getContentSize()
		--获得btn的世界坐标
		local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
			return true
		end 
	end

	return false 
end

--@brief 	更新点赞数
function CellDressGoodSeat:updateGoodNum()
	-- body
	if self.m_bIsLoaded == false then return end 

	local ftxtGoodNum = GetElement(self.m_root, "ftxtGoodNum_CellDressGoodSeat", WZUIFreeTextBox)
	local sFormat1 = [[<T C="255,227,116" S="18" P="1">%s</T>]]
	local sFormat2 = [[<I Z="1" P="1">%s</I>]]
	if ftxtGoodNum then 
		if self.m_nType == 2 then 
			local sContent = string.format(LocalStrings.CHARM_LIFT15, self.m_tData.periodNum)
			ftxtGoodNum:setShowText(string.format(sFormat1, sContent))
		else
			ftxtGoodNum:setShowText(string.format(sFormat2 .. sFormat1, "ui/charmSpace/charmspace_good_icon.png", tostring(self.m_tData.goodNum)))
		end
	end
end

--@brief 	获取点赞按钮是否可见
function CellDressGoodSeat:getBottomBtnVisible()
	-- body
	if self.m_bIsLoaded == false then return end 
	
	local conButton = GetElement(self.m_root, "conButton_CellDressGoodSeat", WZUIContainer)
	return conButton:isVisible()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	更新
function CellDressGoodSeat:_update()
	-- body
	WZLog("CellDressGoodSeat:_update", Serialize(self.m_tData))
	--点赞数/冠军届数
	local ftxtGoodNum = GetElement(self.m_root, "ftxtGoodNum_CellDressGoodSeat", WZUIFreeTextBox)
	local sFormat1 = [[<T C="255,227,116" S="18" P="1">%s</T>]]
	local sFormat2 = [[<I Z="1" P="1">%s</I>]]
	if ftxtGoodNum then 
		if self.m_nType == 2 then 
			local sContent = string.format(LocalStrings.CHARM_LIFT15, self.m_tData.periodNum)
			ftxtGoodNum:setShowText(string.format(sFormat1, sContent))
		else
			ftxtGoodNum:setShowText(string.format(sFormat2 .. sFormat1, "ui/charmSpace/charmspace_good_icon.png", tostring(self.m_tData.goodNum)))
		end
	end
	--名字
	local txtPlayerName = GetElement(self.m_root, "txtPlayerName_CellDressGoodSeat", WZUILabelTTF)
	if txtPlayerName then 
		txtPlayerName:setText(self.m_tData.playerName)
	end
	--玩家形象
	self:_showPlayer()
	--标签
	self:_setRecommendIconVisible(self.m_tData.recommendState)
end

--@brief 创建玩家形象
function CellDressGoodSeat:_showPlayer()
	-- body
	local conRole = GetElement(self.m_root, "conRole_CellDressGoodSeat", WZUIContainer)
	if conRole then 
		local tEquip = {}
	    table.insert(tEquip, self.m_tData.headId)
	    table.insert(tEquip, self.m_tData.faceId)
	    table.insert(tEquip, self.m_tData.bodyId)
	    table.insert(tEquip, self.m_tData.wingId)

		conPlayer = CreatePlayerFigure(self.m_tData.sex, tEquip, "wait0", nil, nil, ccp(-0.4,1.5), nil, nil, nil, nil,self.m_tData.headColor, self.m_tData.bodyColor)
        conRole:addChild(conPlayer:getAnimNode())
        conPlayer:getAnimNode():setScale(1)
	end
end

--@brief 	显示点赞按钮
function CellDressGoodSeat:_showBottomBtn()
	-- body
	if self.m_bIsLoaded == false then return end 

	local conButton = GetElement(self.m_root, "conButton_CellDressGoodSeat", WZUIContainer)
	if conButton:isVisible() then 
		conButton:setVisible(false)
	else
		conButton:setVisible(true)
	end
end

--@brief 	设置推荐标记的显示与否
function CellDressGoodSeat:_setRecommendIconVisible(recommendState)
	-- body
	self.m_tData.recommendState = recommendState
	if self.m_bIsLoaded == false then return end 

	if self.m_nType == 0 then 
		if self.m_tData.recommendState == 1 then 
			GetElement(self.m_root, "conRecommend_CellDressGoodSeat", WZUIContainer):setVisible(true)
		else
			GetElement(self.m_root, "conRecommend_CellDressGoodSeat", WZUIContainer):setVisible(false)
		end
		GetElement(self.m_root, "conPeriod_CellDressGoodSeat", WZUIContainer):setVisible(false)
	elseif self.m_nType == 1 then
		if self.m_tData.recommendState == 1 then 
			GetElement(self.m_root, "conRecommend_CellDressGoodSeat", WZUIContainer):setVisible(true)
		else
			GetElement(self.m_root, "conRecommend_CellDressGoodSeat", WZUIContainer):setVisible(false)
		end
		GetElement(self.m_root, "conPeriod_CellDressGoodSeat", WZUIContainer):setVisible(false)
	elseif self.m_nType == 2 then
		GetElement(self.m_root, "conRecommend_CellDressGoodSeat", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conPeriod_CellDressGoodSeat", WZUIContainer):setVisible(true)
	end
end
-------------------------------------私有方法模块End----------------------------------------
