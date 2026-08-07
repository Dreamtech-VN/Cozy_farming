--CellMondayPlanCard.lua
--@brief	WndMondayPlanCard的UI模块
--@date		2020/07/07
--@author	yrd
--@note		周一计划卡


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMondayPlanCard:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMondayPlanCard:onExit(element)
	self:_unInit()
end

function CellMondayPlanCard:showWindow()
	local nServerTime = SystemTime:getServerTime()
	if nServerTime >= self.endTime then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITYCLOSE)
		return
	end

	-- 按钮状态
	local week = tonumber(os.date("%w",nServerTime))
	-- if self.num > 0 then --已购买周一卡
	-- 	if self.rewardStatus == 1 then --可领取
	-- 		self:setBtnStatus(1,LocalStrings.GET_REWARD,true)
	-- 	elseif self.rewardStatus == 2 then --已领取
	-- 		self:setBtnStatus(2,LocalStrings.ACTIVE_GET,false)
	-- 	else --不能领取
	-- 		self:setBtnStatus(2,LocalStrings.GET_REWARD,false)
	-- 	end
	-- else --未购买周一卡
	-- 	if week == 1 then --星期一
	-- 		self:setBtnStatus(1,LocalStrings.ACTIVITY_TEXT_DESC_24,false)
	-- 	else --星期二到七
	-- 		self:setBtnStatus(2,LocalStrings.ACTIVITY_TEXT_DESC_24,false)
	-- 	end
	-- end

	if self.rewardStatus == 1 then --可领取
		self:setBtnStatus(1,LocalStrings.GET_REWARD,true)
	elseif self.rewardStatus == 2 then --已领取
		self:setBtnStatus(2,LocalStrings.ACTIVE_GET,false)
	elseif self.rewardStatus == 0 then --不能领取
		self:setBtnStatus(2,LocalStrings.GET_REWARD,false)
	elseif self.rewardStatus == -1 then --没有周一卡
		if week == 1 then --星期一
			self:setBtnStatus(1,LocalStrings.ACTIVITY_TEXT_DESC_24,false)
		else --星期二到七
			self:setBtnStatus(2,LocalStrings.ACTIVITY_TEXT_DESC_24,false)
		end
	end


	-- 奖励
	local tab = GetElement(self.m_root,"tab_CellMondayPlanCard",WZUITableContainer)
	tab:cleanTable()
	for i=1,#self.itemId do
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell ~= nil then
			celElement:setTag(i-1)
			tCell:setCellGoodLocalId(self.itemId[i],self.itemNum[i],4)
			tCell:clearItemQualityPic(true)
			tCell:setItemClickFun(self,self.onTips)
			tab:setCellElement(celElement)
		end
	end

end

--@brief	设置按钮状态
--@param	nType : 1正常橙色, 2灰色
--@param	sTxt : 按钮字内容
--@param	bRedDot : 红点显示
function CellMondayPlanCard:setBtnStatus(nType,sTxt,bRedDot)
	local txtBuy = GetElement(self.m_root,"txtBuy_CellMondayPlanCard",WZUILabelTTF)
	local imgBuy = GetElement(self.m_root,"imgBuy_CellMondayPlanCard",WZUI9Image)
	local spineBtn = GetElement(self.m_root,"spineBtn_CellMondayPlanCard",WZUISpine)
	spineBtn:setVisible(false)
	local imgRedDot = GetElement(self.m_root,"imgRedDot_CellMondayPlanCard",WZUIImage)
	
	txtBuy:setText(sTxt)
	if ProjConfig.LANGUAGE == "vn" then
		txtBuy:setScale(0.8)
		txtBuy:setDimensions(GlobalMethod:CCSize(150))
	end
	if bRedDot == true then
		imgRedDot:setVisible(true)
	else
		imgRedDot:setVisible(false)
	end
	if nType == 1 then
		txtBuy:setColor(GlobalMethod:ccc3(255,250,236))
		txtBuy:setStrokeColor(GlobalMethod:ccc3(163,74,20))
		imgBuy:setGrayRender(false)
		-- spineBtn:setVisible(true)
	elseif nType == 2 then
		txtBuy:setColor(GlobalMethod:ccc3(255,255,255))
		txtBuy:setStrokeColor(GlobalMethod:ccc3(80,61,50))
		imgBuy:setGrayRender(true)
		-- spineBtn:setVisible(false)
	end
end

--@brief	显示tips
function CellMondayPlanCard:onTips( tCell,tag,tData )
	WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief	点击按钮回调
function CellMondayPlanCard:onClickBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nServerTime = SystemTime:getServerTime()
	if nServerTime >= self.endTime then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITYCLOSE)
		return
	end

	local week = tonumber(os.date("%w",nServerTime))
	-- if self.num > 0 then
	-- 	if self.rewardStatus == 1 then
	-- 		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.activityId,0)
	-- 	elseif self.rewardStatus == 2 then
	-- 		MsgBoxManager:showTipBox(LocalStrings.VIP_CURDAYRECV)
	-- 	else
	-- 		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT_DESC_30)
	-- 	end
	-- else
	-- 	if week == 1 then
	-- 		WndGameActivity:_createLoading()
	-- 		popFastRechargeUI(259)
	-- 	else
	-- 		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT_DESC_31)
	-- 	end
	-- end

	if self.rewardStatus == 1 then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.activityId,0)
	elseif self.rewardStatus == 2 then
		MsgBoxManager:showTipBox(LocalStrings.VIP_CURDAYRECV)
	elseif self.rewardStatus == 0 then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT_DESC_30)
	elseif self.rewardStatus == -1 then
		if week == 1 then
			WndGameActivity:_createLoading()
			popFastRechargeUI(259)
		else
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT_DESC_31)
		end
	end

end

--@brief	购买成功显示tips
function CellMondayPlanCard:onBuyOkTips()
	WndOneActivityRule:showInterface(2,LocalStrings.ACTIVITY_TEXT_DESC_27,LocalStrings.ACTIVITY_TEXT_DESC_28)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
