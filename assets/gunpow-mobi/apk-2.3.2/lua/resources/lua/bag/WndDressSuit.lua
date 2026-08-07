--WndDressSuit.lua
--@brief	WndDressSuit的UI模块
--@date		2018/03/28
--@author	Tianxiang_Xu
--@note		时装套装方案


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDressSuit:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDressSuit:onExit(element)
	self:_unInit()
end

--@brief 	界面加载完成回调
function WndDressSuit:showWin()
	-- body
	if self.m_nType == 6 then 
		self.m_tConfigData = json.decode(CacheCenter:getGameParam().dressSuitConfig3)
	elseif self.m_nType == 7 then 
		self.m_tConfigData = json.decode(CacheCenter:getGameParam().dressSuitConfig2)
	elseif self.m_nType == 8 then 
		self.m_tConfigData = json.decode(CacheCenter:getGameParam().dressSuitConfig4)
	elseif self.m_nType == 10 then 
		self.m_tConfigData = json.decode(CacheCenter:getGameParam().dressSuitConfig5)
	else
		self.m_tConfigData = json.decode(CacheCenter:getGameParam().dressSuitConfig)
	end
	
	WZLog("WndDressSuit:onEnterTransitionDidFinish", Serialize(self.m_tConfigData))
	self.m_nMaxSuitNum = self.m_tConfigData.maxNum or 7

	self:setSuitData()
end

--@brief 	点击当前套装按钮回调
--@note 	收起或展示设定的套装
function WndDressSuit:onClickShow(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nType == 3 then
		if not SceneRoom.m_bCanClickSeat then
			MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
			return 
		end
	end

	self.m_bIsOpenList = not self.m_bIsOpenList
	
	self:setArrowAndListState()
end

--@brief 	隐藏套装列表
function WndDressSuit:hideSuitList()
	-- body
	if self.m_root == nil then return end 
	if self.m_bIsOpenList == false then return end 

	self.m_bIsOpenList = not self.m_bIsOpenList
	self:setArrowAndListState()
end

--@brief 	点击改名按钮回调
function WndDressSuit:onClickRename(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tUseData = self:getCurUseSuit()
	if self.m_nType == 8 then 
		if tUseData.id == 1 or tUseData.id == 2 then 
			MsgBoxManager:showTipBox(LocalStrings.SKILLSUIT_ATT)
			return 
		end		
	end

	local element = WndEditBox:createElement()
	WndEditBox:setOkCallBack(self.onApplyRename, self)
	WndEditBox:setOtherData(tUseData)
	WndEditBox:setData(LocalStrings.INPUT_NEW_NAME, LocalStrings.CLICK_TO_INPUT_NAME)
	WindowManager:addWindow(element, WndEditBox)
end

--@brief 	点击套装按钮回调
function WndDressSuit:onClickChange(element)
	-- body
	WZLog("点击套装按钮回调",self.m_nType,element:getTag(),Serialize(self:getCurUseSuit()))
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nType == 3 then
		if not SceneRoom.m_bCanClickSeat then
			MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
			return 
		end
	end

	local nTag = element:getTag()
	local tUseData = self:getCurUseSuit()
	--如果点击的是正在使用的，则不处理
	if nTag == tUseData.id then
		return 
	end

	if nTag == 99 then --新增
		local nCurNum = #self.m_tSuitData
		local nCostIndex = nCurNum - self.m_tConfigData.defaultNum + 1

		local string = string.sub(self.m_tConfigData.cost[nCostIndex], 2, -2) 
		local id = SplitStringWithSeparator(string,",")[1]
		local num = SplitStringWithSeparator(string,",")[2]
		local tBasicData = GDatatab_item["id_" .. id]

		local sAtt
		if self.m_nType == 6 or self.m_nType == 7 or self.m_nType == 8 or self.m_nType == 10 then 
			sAtt = string.format(LocalStrings.NEWSEAT_OPENCOST, tonumber(num), tBasicData.icon, nCurNum + 1)
		else
			sAtt = string.format(LocalStrings.DRESSSUIT_TEXT3, tonumber(num), tBasicData.name, nCurNum + 1)
		end
		MsgBoxManager:showConfirmBox(sAtt, self, self.sureToAdd)
	else --使用当前选中的时装
		WZLog("WndDressSuit:onClickChange", nTag)
		if self.m_nType == 6 or self.m_nType == 7 or self.m_nType == 8 then 
			if self.m_nType == 7 then 
				SceneRune:resetEnterState()
			elseif self.m_nType == 6 then 
				g_blessDataGetIndex = 2
			end
			ProtocolProcessorRecycling:send_PLAYERITEM_SwitchSuit(self.m_nType, nTag)
		elseif self.m_nType == 10 then
			ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipUseScheme(nTag)
		else
			ProtocolProcessorRecycling:send_PLAYERITEM_SwitchDressSuit(nTag)
		end
	end
end

--@brief 	
function WndDressSuit:sureToAdd()
	-- body
	local nCurNum = #self.m_tSuitData
	local nCostIndex = nCurNum - self.m_tConfigData.defaultNum + 1

	local string = string.sub(self.m_tConfigData.cost[nCostIndex], 2, -2) 
	local id = SplitStringWithSeparator(string,",")[1]
	local num = SplitStringWithSeparator(string,",")[2]

	if not JudgeMoneyIsEnough(tonumber(id), tonumber(num), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiamondToAdd) then
		return 
	end
	self:sureUseDiamondToAdd()
end

--@brief 	确定用钻石代替粉钻增加套装
function WndDressSuit:sureUseDiamondToAdd()
	-- body
	if self.m_nType == 6 or self.m_nType == 7 or self.m_nType == 8 then 
		ProtocolProcessorRecycling:send_PLAYERITEM_IncreaseSuitNum(self.m_nType)
	elseif self.m_nType == 10 then
		ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipSchemeAdd()
	else
		ProtocolProcessorRecycling:send_PLAYERITEM_IncreaseDressSuitNum()
	end
end

--@brief	改名笔回调
function WndDressSuit:onApplyRename(txt,lua,tData)
	result = JudgeResultInClientForInputText(4, txt)
	if result == 0 then 
		if self.m_nType == 6 or self.m_nType == 7 or self.m_nType == 8 then 
			ProtocolProcessorRecycling:send_PLAYERITEM_ModifySuitName(self.m_nType, tData.id, txt)
		elseif self.m_nType == 10 then
			ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipSchemeReName(tData.id, txt)
		else
			ProtocolProcessorRecycling:send_PLAYERITEM_ModifyDressSuitName(tData.id, txt)
		end
	else
		self:displayResult(result)
	end
end

--@brief    显示改名结果
--@param    #1返回的结果result : 1、成功，2、重名，3、非法字符，4、名字不能为空，5、名字太长, 6、名字太短,7、纯数字
function WndDressSuit:displayResult(result)
    WZLog("************** WndDressSuit:displayResult **************** ", result,self.m_nUseType)

    if result == 1 then
	    MsgBoxManager:showTipBox(LocalStrings.DRESSSUIT_TEXT2)
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.NAME_HAVED_EXIST)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO3)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
    elseif result == 10 or result == 5 then
        MsgBoxManager:showTipBox(LocalStrings.DRESSSUIT_TEXT1)
    elseif result == 6 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_TOO_SHOOT)
    elseif result == 7 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_CANT_BE_NUMBER)
    elseif result == 8 then 
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO5)
    end
end

--@brief 	
function WndDressSuit:checkPointInBtn(pt)
	-- body
	local btn
	btn = GetElement(self.m_root, "conTop_WndDressSuit", WZUIContainer)
	if btn then
		local btnSize = btn:getContentSize()
		--获得btn的世界坐标
		local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
			return true
		end 
	end
	btn = GetElement(self.m_root, "conOther_WndDressSuit", WZUIContainer)
	if btn then
		local btnSize = btn:getContentSize()
		--获得btn的世界坐标
		local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
			return true
		end 
	end

	if self.m_nType == 1 or self.m_nType == 2 then
		btn = GetElement(self.m_root, "btnRename_WndDressSuit", WZUIButton)
		if btn then
			local btnSize = btn:getContentSize()
			--获得btn的世界坐标
			local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
			if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
				return true
			end 
		end
	end

	return false 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndDressSuit:_update()
	-- body
	local tUseData = self:getCurUseSuit()
	local txtSelSuitName = GetElement(self.m_root, "txtSelSuitName_WndDressSuit", WZUILabelTTF)
	if txtSelSuitName then
		txtSelSuitName:setText(tUseData.name)
	end
	--
	if self.m_nType == 3 or self.m_nType == 4 or self.m_nType == 5 or self.m_nType == 9 then
		GetElement(self.m_root, "btnRename_WndDressSuit", WZUIButton):setVisible(false)
	else
		GetElement(self.m_root, "btnRename_WndDressSuit", WZUIButton):setVisible(true)
	end
	if self.m_nType == 3 or self.m_nType == 4 then 
		GetElement(self.m_root, "btnTop_WndDressSuit", WZUIButton):setVisible(false)
	end

	self:setArrowAndListState()
	self:_createSuitList()
end

--@brief 	创建套装列表
function WndDressSuit:_createSuitList()
	-- body
	local conOther = GetElement(self.m_root, "conOther_WndDressSuit", WZUIContainer)
	local conSuitList = GetElement(self.m_root, "conSuitList_WndDressSuit", WZUIContainer)
	self.m_nodeSuitSel = nil 
	conSuitList:removeAllChildrenWithCleanup(true)

	local nTotalNum = #self.m_tSuitData 
	local nNum = nTotalNum
	if nTotalNum < self.m_nMaxSuitNum and self.m_nType ~= 3 and self.m_nType ~= 4 and self.m_nType ~= 5 or self.m_nType ~= 9 then
		nNum = nNum + 1
	end
	if self.m_bIsTrun == true then
		conOther:setAnchorPoint(GlobalMethod:ccp(0.5,-0.3))
	end
	conOther:setAbsContentSize(GlobalMethod:CCSize(120, nNum * 36))
	conOther:updateRelativeSize()
	local nGapY = 1/(nNum * 2)
	for i = 1, nTotalNum do
		local btnSuit = self:_createBtn(self.m_tSuitData[i].name)
    	btnSuit:setRelativePosition(GlobalMethod:ccp(0.38, (1 - nGapY) - (i - 1) * nGapY * 2))
    	btnSuit:setTag(self.m_tSuitData[i].id)

    	conSuitList:addChild(btnSuit)
    	if self.m_tSuitData[i].bIsUsed then
    		if self.m_nodeSuitSel == nil then
				self:_createRectSel()
			end

			self.m_nodeSuitSel:setRelativePosition(GlobalMethod:ccp(0.5, (1 - nGapY) - (i - 1) * nGapY * 2))
    	end
	end

	if nTotalNum < self.m_nMaxSuitNum and self.m_nType ~= 3 and self.m_nType ~= 4 and self.m_nType ~= 5 or self.m_nType ~= 9 then
		local btnAdd = self:_createBtn("+", 24, GlobalMethod:ccc3(99,255,95))
		btnAdd:setRelativePosition(GlobalMethod:ccp(0.38, (1 - nGapY) - (nTotalNum) * nGapY * 2))
		btnAdd:setTag(99)

		conSuitList:addChild(btnAdd)
	end
end

--@brief    创建按钮
function WndDressSuit:_createBtn(btnText, fontSize, FontColor)
    -- body
    local btnSuit = WZUIButton:create()
    btnSuit:setUseAbsSize(true)
    btnSuit:setAbsContentSize(GlobalMethod:CCSize(120, 36))
    local imgNor = WZUIImage:create()
    imgNor:setFile("ui/common/frame_fengexian_01.png")
    imgNor:setUseOriginSize(true)
    imgNor:setScaleX(3.6)
    imgNor:setRelativePosition(GlobalMethod:ccp(0.6,0.07))
    if btnText ~= "+" then
    	btnSuit:addChild(imgNor)
    end

    local txtBtn = WZUILabelTTF:create()
    if fontSize then 
    	txtBtn:setFontSize(fontSize)
    else
    	txtBtn:setFontSize(20)
    end
    if FontColor then
    	txtBtn:setColor(FontColor)
    else
    	txtBtn:setColor(GlobalMethod:ccc3(255,255,255))
    end
    txtBtn:setEnableStroke(false)
    txtBtn:setStrokeSize(4)
    txtBtn:setStrokeColor(GlobalMethod:ccc3(127,70,26))
    txtBtn:setAnchorPoint(GlobalMethod:ccp(0,0.5))
    txtBtn:setRelativePosition(GlobalMethod:ccp(0.2,0.45))
    txtBtn:setText(btnText)
    txtBtn:setTag(44)
    btnSuit:addChild(txtBtn)
    btnSuit:setLuaDoneFunctionName("onClickChange")

    if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
    	txtBtn:setScale(0.8)
	elseif ProjConfig.LANGUAGE == "ug" then
		txtBtn:setScale(0.6)
    end
    return btnSuit
end

--@brief 	设置箭头和列表的状态
function WndDressSuit:setArrowAndListState()
	-- body
	local imgArrow = GetElement(self.m_root, "imgArrow_WndDressSuit", WZUIImage)
	if imgArrow then
		imgArrow:setFlipY(self.m_bIsOpenList)
	end
	GetElement(self.m_root, "conOther_WndDressSuit", WZUIContainer):setVisible(self.m_bIsOpenList)
end

--@brief 	创建选中当前选中的套装
function WndDressSuit:_createRectSel()
	-- body
	if self.m_nodeSuitSel == nil then
		self.m_nodeSuitSel = WZUIContainer:create()
		self.m_nodeSuitSel:setAbsContentSize(GlobalMethod:CCSize(120,38))
		self.m_nodeSuitSel:setUseAbsSize(true)

		local img9 = WZUI9Image:create()
		img9:setFile("ui/common/frame_xz.png")

		self.m_nodeSuitSel:addChild(img9)

		local conSuitList = GetElement(self.m_root, "conSuitList_WndDressSuit", WZUIContainer)
		conSuitList:addChild(self.m_nodeSuitSel)
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function WndDressSuit:_adaptLanguage_en()
	local btnRename = GetElement(self.m_root, "btnRename_WndDressSuit", WZUIButton)
	btnRename:setRelativePosition(GlobalMethod:ccp(1.3,0.6))
	GetElement(self.m_root, "txtSelSuitName_WndDressSuit", WZUILabelTTF):setScale(0.9)
end

function WndDressSuit:_adaptLanguage_vn()
	local btnRename = GetElement(self.m_root, "btnRename_WndDressSuit", WZUIButton)
	btnRename:setRelativePosition(GlobalMethod:ccp(1.2,0.6))
end

function WndDressSuit:_adaptLanguage_th()
	local btnRename = GetElement(self.m_root, "btnRename_WndDressSuit", WZUIButton)
	btnRename:setRelativePosition(GlobalMethod:ccp(1.3,0.6))
end

function WndDressSuit:_adaptLanguage_pt()
	local btnRename = GetElement(self.m_root, "btnRename_WndDressSuit", WZUIButton)
	btnRename:setRelativePosition(GlobalMethod:ccp(1.4,0.6))

	GetElement(self.m_root, "txtSelSuitName_WndDressSuit", WZUILabelTTF):setScale(0.8)
end

function WndDressSuit:_adaptLanguage_es()
	local btnRename = GetElement(self.m_root, "btnRename_WndDressSuit", WZUIButton)
	btnRename:setRelativePosition(GlobalMethod:ccp(1.3,0.6))
	local imgRename = GetElement(self.m_root, "imgRename_WndDressSuit", WZUIImage)
	imgRename:setRelativePosition(GlobalMethod:ccp(0.5,0.0666663))

	GetElement(self.m_root, "txtSelSuitName_WndDressSuit", WZUILabelTTF):setScale(0.8)
end

function WndDressSuit:_adaptLanguage_tr()
	local btnRename = GetElement(self.m_root, "btnRename_WndDressSuit", WZUIButton)
	btnRename:setRelativePosition(GlobalMethod:ccp(1.4,0.6))

	GetElement(self.m_root, "txtSelSuitName_WndDressSuit", WZUILabelTTF):setScale(0.8)
end

function WndDressSuit:_adaptLanguage_ug()
	local btnRename = GetElement(self.m_root, "btnRename_WndDressSuit", WZUIButton)
	btnRename:setRelativePosition(GlobalMethod:ccp(1.3,0.6))
	local txtRename = GetElement(self.m_root, "txtRename_WndDressSuit", WZUILabelTTF)
	txtRename:setDimensions(GlobalMethod:CCSize(120))
	txtRename:setRelativePosition(GlobalMethod:ccp(0.5,0.583333))
	local imgRename = GetElement(self.m_root, "imgRename_WndDressSuit", WZUIImage)
	imgRename:setRelativePosition(GlobalMethod:ccp(0.5,0.0666663))

	GetElement(self.m_root, "txtSelSuitName_WndDressSuit", WZUILabelTTF):setScale(0.6)
end
-------------------------------------语言适配End----------------------------------------
