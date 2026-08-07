--CellBackFightItem.lua
--@brief	CellBackFightItem的UI模块
--@date		2018/11/21
--@author	Tianxiang_Xu
--@note		回归活动-每日战斗Item


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBackFightItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBackFightItem:onExit(element)
	self:_unInit()
end

--@brief 	加载
function CellBackFightItem:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellBackFightItem")
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true
    self:_update()
end

--@brief 	点击前往按钮回调
function CellBackFightItem:onClickGoto(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	JumpByUIId(self.m_tData.uiId)
end

--@brief 	点击领取按钮回调
function CellBackFightItem:onCommitEvent(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    self.m_nloadingId = MsgBoxManager:showLoadingBox()
	CellBackFightItem.m_current_click = self
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_tData.activityId, self.m_tData.rewardId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellBackFightItem:_update()
	-- body
	local tData = self.m_tData

	local txtTitle = GetElement(self.m_root, "txtTitle_CellBackFightItem", WZUILabelTTF)
	if txtTitle then 
		txtTitle:setText(tData.tip)
	end
	--进度
	local txtCurValue = GetElement(self.m_root, "txtCurValue_CellBackFightItem", WZUILabelTTF)
	if txtCurValue then 
		txtCurValue:setText(tData.curNum .. "/" .. tData.maxNum)
	end
	--说明
	local txtDesc = GetElement(self.m_root, "txtDesc_CellBackFightItem", WZUILabelTTF)
	if txtDesc then 
		txtDesc:setText(tData.desc or "")
	end
	--领取按钮的状态
	local btnCommit = GetElement(self.m_root, "btnCommit_CellBackFightItem", WZUIButton)
	local imgYlq = GetElement(self.m_root, "imgYlq_CellBackFightItem", WZUIImage)
	imgYlq:setVisible(false)
	if tData.status == -1 then 
		btnCommit:setTouchEnable(false)
	elseif tData.status == 0 then 
		btnCommit:setTouchEnable(true)
	else
		btnCommit:setVisible(false)
		imgYlq:setVisible(true)
	end
	--奖励
	for i = 1, #tData.reward do
		local conRewardItem = GetElement(self.m_root, "conRewardItem_" .. i .. "_CellBackFightItem", WZUIContainer)
		conRewardItem:setVisible(true)
		local txtItemNum = GetElement(self.m_root, "txtItemNum_" .. i .. "_CellBackFightItem", WZUILabelTTF)
		local itemIcon = GetElement(self.m_root, "ItemIcon_" .. i .. "_CellBackFightItem", WZUIImage)
		txtItemNum:setText(tData.reward[i].num)
		local basicData = GDatatab_item["id_" .. tData.reward[i].id]
		itemIcon:setFile(basicData.icon)
	end
end

--@brief    奖励获取成功回调  
function CellBackFightItem:_GetRewardOk()
    WZLog("CellBackFightItem:_GetRewardOk")
    if self.m_root == nil then return end 
    local btnCommit = GetElement(self.m_root, "btnCommit_CellBackFightItem", WZUIButton)
    if btnCommit == nil then
        WZLog("btnCommit is nil")
        return
    end
    btnCommit:setVisible(false)

    GetElement(self.m_root, "imgYlq_CellBackFightItem", WZUIImage):setVisible(true)

    if self.m_FuncCallback ~= nil then 
        local tluaObj = self.m_tCallBackLuaObjMap[self.m_FuncCallback]
        self.m_FuncCallback(tluaObj, self.m_tData.rewardId)
    end
end


-------------------------------------私有方法模块End----------------------------------------
