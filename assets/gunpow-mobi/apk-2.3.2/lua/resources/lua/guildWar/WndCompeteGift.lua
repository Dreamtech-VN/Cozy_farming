-- WndCompeteGift
-- @brief:公会战奖励UI模块
-- @date: 2017-02-22 16:17:43
-- @author: zhenwei_jian
-- @note:奖励列表

-------------------------------------公有方法模块Begin--------------------------------------

--@brief 显示该界面
function WndCompeteGift:showWnd(nType)
	local wnd = self:createElement()
	if nType ~= nil then
		WndCompeteGift.m_nType = nType or 1
	end
	WindowManager:addWindow( wnd , WndCompeteGift)
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCompeteGift:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)

	--设置标签
	for i = 2, 3 do
		GetElement(self.m_root, string.format("imgTab%d", i), WZUI9Image):setVisible(false)
		GetElement(self.m_root, string.format("txtTab%dSel", i), WZUILabelTTF):setVisible(false)
	end

end

--@brief    onenter函数已执行
function WndCompeteGift:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true, "_update", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCompeteGift:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮
function WndCompeteGift:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCompeteGift, true)
	end 
end

--@brief 	触摸开始回调
function WndCompeteGift:onTouchBegin(element, pt)
	-- body
	if WndTips.m_root ~= nil and not WndTips:checkPointInBtn(pt) then
        WndTips:onCloseClick()
    end

    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end


--@brief	点击标签切换
function WndCompeteGift:onCheck(element)
	WZLog("WndCompeteGift:onCheck", self.m_nType)

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
	local nTag = element:getTag()
	self.m_nTabNum = nTag

	--家园排行榜
	if self.m_nType == 2 or self.m_nType == 3 then
		if self.m_nType == 2 then
			self:showFamilyReward()
		elseif self.m_nType == 3 then
			self:showKidHomeReward()
		end

		--设置标签
		for i = 1, 2 do
			GetElement(self.m_root, string.format("imgTab%d", i), WZUI9Image):setVisible(false)
			GetElement(self.m_root, string.format("txtTab%dSel", i), WZUILabelTTF):setVisible(false)
		end

		GetElement(self.m_root, string.format("imgTab%d", nTag), WZUI9Image):setVisible(true)
		GetElement(self.m_root, string.format("txtTab%dSel", nTag), WZUILabelTTF):setVisible(true)
		return
	end

	--刷新界面
	self:_update()

	--设置标签
	for i = 1, 3 do
		GetElement(self.m_root, string.format("imgTab%d", i), WZUI9Image):setVisible(false)
		GetElement(self.m_root, string.format("txtTab%dSel", i), WZUILabelTTF):setVisible(false)
	end

	GetElement(self.m_root, string.format("imgTab%d", nTag), WZUI9Image):setVisible(true)
	GetElement(self.m_root, string.format("txtTab%dSel", nTag), WZUILabelTTF):setVisible(true)

end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	更新界面
function WndCompeteGift:_update()
	if self.m_nType == 2 then 
		self:showFamilyReward()
		return 
	end
	if self.m_nType == 3 then 
		self:showKidHomeReward()
		return 
	end
	
	GetElement(self.m_root,"txtTab1",WZUILabelTTF):setText(LocalStrings.COMMUNITYWARGIFT_TEXT1)
	GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF):setText(LocalStrings.COMMUNITYWARGIFT_TEXT1)
	GetElement(self.m_root,"txtTab2",WZUILabelTTF):setText(LocalStrings.COMMUNITYWARGIFT_TEXT2)
	GetElement(self.m_root,"txtTab2Sel",WZUILabelTTF):setText(LocalStrings.COMMUNITYWARGIFT_TEXT2)
	GetElement(self.m_root,"txtTab3",WZUILabelTTF):setText(LocalStrings.COMMUNITYWARGIFT_TEXT3)
	GetElement(self.m_root,"txtTab3Sel",WZUILabelTTF):setText(LocalStrings.COMMUNITYWARGIFT_TEXT3)
	GetElement(self.m_root,"checkInfo2",WZUICheckBox):setVisible(true)
	GetElement(self.m_root,"conTab3",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"btmTip",WZUILabelTTF):setText(LocalStrings.COMMUNITYWARGIFT_TEXT6)

	local freeListContainer = GetElement(self.m_root,"freelist_Gift", WZUIFreeListContainer)
	freeListContainer:removeAll()

	local mDataList = self.m_tDataMap[self.m_nTabNum]
	if nil == mDataList then
		return
	end

	for i, mConfig in ipairs(mDataList) do
		local celElement, tCell = CellCompeteGift:createElement()
		if celElement ~= nil and tCell ~= nil then
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(mConfig)
			freeListContainer:pushBack(celElement)
			table.insert(self.m_tCellList, tCell)
		end
	end

	freeListContainer:update()
	freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
end

-------------------------------------私有方法模块End--------------------------------------

function WndCompeteGift:showFamilyReward() 
	WZLog("WndCompeteGift:showFamilyReward", self.m_nTabNum)
	WndCompeteGift.m_nType = 2
	GetElement(self.m_root,"txtTab1",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP15)
	GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP15)
	GetElement(self.m_root,"txtTab2",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP16)
	GetElement(self.m_root,"txtTab2Sel",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP16)
	GetElement(self.m_root,"checkInfo2",WZUICheckBox):setVisible(false)
	GetElement(self.m_root,"conTab3",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"btmTip",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP17)
	if GlobalMethod:crossServiceOpen() == 0 then
		GetElement(self.m_root,"checkInfo1",WZUICheckBox):setVisible(false)
		GetElement(self.m_root,"conTab2",WZUIContainer):setVisible(false)
	else
		GetElement(self.m_root,"checkInfo1",WZUICheckBox):setVisible(true)
		GetElement(self.m_root,"conTab2",WZUIContainer):setVisible(true)
	end
	
	local freeListContainer = GetElement(self.m_root,"freelist_Gift", WZUIFreeListContainer)
	freeListContainer:removeAll()

	local n = GetTableLen(GDatatab_home_reward)
	for i = 1, n do
		local mConfig = GDatatab_home_reward["id_"..i]
		if mConfig.type == tonumber(self.m_nTabNum) then
			WZLog("家园排行榜Cell", Serialize(mConfig))
			local celElement, tCell = CellCompeteGift:createElement()
			if celElement ~= nil and tCell ~= nil then
				celElement = WZUIContainer:luaTo(celElement)
				tCell:setData(mConfig)
				freeListContainer:pushBack(celElement)
			end
		end
	end

	freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
end

--@brief 	小家排名奖励
function WndCompeteGift:showKidHomeReward() 
	WZLog("WndCompeteGift:showKidHomeReward", self.m_nTabNum)
	self.m_nType = 3
	GetElement(self.m_root,"txtTab1",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP15)
	GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP15)
	GetElement(self.m_root,"txtTab2",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP16)
	GetElement(self.m_root,"txtTab2Sel",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP16)
	GetElement(self.m_root,"checkInfo2",WZUICheckBox):setVisible(false)
	GetElement(self.m_root,"conTab3",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"btmTip",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP17)
	if GlobalMethod:crossServiceOpen() == 0 then
		GetElement(self.m_root,"checkInfo1",WZUICheckBox):setVisible(false)
		GetElement(self.m_root,"conTab2",WZUIContainer):setVisible(false)
	else
		GetElement(self.m_root,"checkInfo1",WZUICheckBox):setVisible(true)
		GetElement(self.m_root,"conTab2",WZUIContainer):setVisible(true)
	end
	
	local freeListContainer = GetElement(self.m_root,"freelist_Gift", WZUIFreeListContainer)
	freeListContainer:removeAll()

	local n = GetTableLen(GDatatab_house_reward)
	for i = 1, n do
		local mConfig = GDatatab_house_reward["id_"..i]
		if mConfig.type == tonumber(self.m_nTabNum) then
			local celElement, tCell = CellCompeteGift:createElement()
			if celElement ~= nil and tCell ~= nil then
				celElement = WZUIContainer:luaTo(celElement)
				tCell:setData(mConfig)
				freeListContainer:pushBack(celElement)
			end
		end
	end

	freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
end
-------------------------------------私有方法模块End--------------------------------------
-------------------------------------语言适配Begin----------------------------------------
function WndCompeteGift:_adaptLanguage_en(  )
	local  txtTab1 = GetElement(self.m_root,"txtTab1",WZUILabelTTF)
	txtTab1:setScale(0.6)
	txtTab1:setDimensions(GlobalMethod:CCSize(140))
	local  txtTab1Sel = GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF)
	txtTab1Sel:setScale(0.6)
	txtTab1Sel:setDimensions(GlobalMethod:CCSize(140))

	local  txtTab2 = GetElement(self.m_root,"txtTab2",WZUILabelTTF)
	txtTab2:setScale(0.6)
	txtTab2:setDimensions(GlobalMethod:CCSize(140))
	local  txtTab2Sel = GetElement(self.m_root,"txtTab2Sel",WZUILabelTTF)
	txtTab2Sel:setScale(0.6)
	txtTab2Sel:setDimensions(GlobalMethod:CCSize(140))

	local  txtTab3 = GetElement(self.m_root,"txtTab3",WZUILabelTTF)
	txtTab3:setScale(0.6)
	txtTab3:setDimensions(GlobalMethod:CCSize(140))
	local  txtTab3Sel = GetElement(self.m_root,"txtTab3Sel",WZUILabelTTF)
	txtTab3Sel:setScale(0.6)
	txtTab3Sel:setDimensions(GlobalMethod:CCSize(140))
end

function WndCompeteGift:_adaptLanguage_th(  )
	for i=1,3 do
		local txtTab = GetElement(self.m_root,"txtTab"..i,WZUILabelTTF)
		txtTab:setScale(0.75)
		local txtTabSel = GetElement(self.m_root,"txtTab"..i.."Sel",WZUILabelTTF)
		txtTabSel:setScale(0.75)
	end
end

function WndCompeteGift:_adaptLanguage_pt(  )
	local txtTab1 = GetElement(self.m_root,"txtTab1",WZUILabelTTF)
	txtTab1:setScale(0.62)
	txtTab1:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	txtTab1:setDimensions(GlobalMethod:CCSize(110,0))
	local txtTab1Sel = GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF)
	txtTab1Sel:setScale(0.62)
	txtTab1Sel:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	txtTab1Sel:setDimensions(GlobalMethod:CCSize(110,0))

	local txtTab2 = GetElement(self.m_root,"txtTab2",WZUILabelTTF)
	txtTab2:setScale(0.62)
	txtTab2:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	txtTab2:setDimensions(GlobalMethod:CCSize(110,0))
	local txtTab2Sel = GetElement(self.m_root,"txtTab2Sel",WZUILabelTTF)
	txtTab2Sel:setScale(0.62)
	txtTab2Sel:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	txtTab2Sel:setDimensions(GlobalMethod:CCSize(110,0))

	local txtTab3 = GetElement(self.m_root,"txtTab3",WZUILabelTTF)
	txtTab3:setScale(0.62)
	txtTab3:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	txtTab3:setDimensions(GlobalMethod:CCSize(110,0))
	local txtTab3Sel = GetElement(self.m_root,"txtTab3Sel",WZUILabelTTF)
	txtTab3Sel:setScale(0.62)
	txtTab3Sel:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	txtTab3Sel:setDimensions(GlobalMethod:CCSize(110,0))

	GetElement(self.m_root,"txtTab2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	GetElement(self.m_root,"txtTab2Sel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	GetElement(self.m_root,"txtTab3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	GetElement(self.m_root,"txtTab3Sel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end

function WndCompeteGift:_adaptLanguage_es(  )
	for i=1,3 do
		local txtTab = GetElement(self.m_root,"txtTab"..i,WZUILabelTTF)
		txtTab:setScale(0.7)
		txtTab:setDimensions(GlobalMethod:CCSize(110,0))
		
		local txtTabSel = GetElement(self.m_root,"txtTab"..i.."Sel",WZUILabelTTF)
		txtTabSel:setScale(0.7)
		txtTabSel:setDimensions(GlobalMethod:CCSize(110,0))
	end
end

function WndCompeteGift:_adaptLanguage_vn(  )
	for i=1,3 do
		local txtTab = GetElement(self.m_root,"txtTab"..i,WZUILabelTTF)
		txtTab:setScale(0.8)
		txtTab:setDimensions(GlobalMethod:CCSize(110,0))
		
		local txtTabSel = GetElement(self.m_root,"txtTab"..i.."Sel",WZUILabelTTF)
		txtTabSel:setScale(0.8)
		txtTabSel:setDimensions(GlobalMethod:CCSize(110,0))
	end
end

function WndCompeteGift:_adaptLanguage_tr(  )
	local txtTab1 = GetElement(self.m_root,"txtTab1",WZUILabelTTF)
	txtTab1:setScale(0.65)
	txtTab1:setDimensions(GlobalMethod:CCSize(120))
	local txtTab1Sel = GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF)
	txtTab1Sel:setScale(0.65)
	txtTab1Sel:setDimensions(GlobalMethod:CCSize(120))
	local txtTab2 = GetElement(self.m_root,"txtTab2",WZUILabelTTF)
	txtTab2:setScale(0.65)
	txtTab2:setDimensions(GlobalMethod:CCSize(120))
	local txtTab2Sel = GetElement(self.m_root,"txtTab2Sel",WZUILabelTTF)
	txtTab2Sel:setScale(0.65)
	txtTab2Sel:setDimensions(GlobalMethod:CCSize(120))
	local txtTab3 = GetElement(self.m_root,"txtTab3",WZUILabelTTF)
	txtTab3:setScale(0.65)
	txtTab3:setDimensions(GlobalMethod:CCSize(120))
	local txtTab3Sel = GetElement(self.m_root,"txtTab3Sel",WZUILabelTTF)
	txtTab3Sel:setScale(0.65)
	txtTab3Sel:setDimensions(GlobalMethod:CCSize(120))
end

function WndCompeteGift:_adaptLanguage_ug(  )
	local  txtTab1 = GetElement(self.m_root,"txtTab1",WZUILabelTTF)
	txtTab1:setScale(0.6)
	txtTab1:setDimensions(GlobalMethod:CCSize(140))
	local  txtTab1Sel = GetElement(self.m_root,"txtTab1Sel",WZUILabelTTF)
	txtTab1Sel:setScale(0.6)
	txtTab1Sel:setDimensions(GlobalMethod:CCSize(140))

	local  txtTab2 = GetElement(self.m_root,"txtTab2",WZUILabelTTF)
	txtTab2:setScale(0.6)
	txtTab2:setDimensions(GlobalMethod:CCSize(140))
	local  txtTab2Sel = GetElement(self.m_root,"txtTab2Sel",WZUILabelTTF)
	txtTab2Sel:setScale(0.6)
	txtTab2Sel:setDimensions(GlobalMethod:CCSize(140))

	local  txtTab3 = GetElement(self.m_root,"txtTab3",WZUILabelTTF)
	txtTab3:setScale(0.6)
	txtTab3:setDimensions(GlobalMethod:CCSize(140))
	local  txtTab3Sel = GetElement(self.m_root,"txtTab3Sel",WZUILabelTTF)
	txtTab3Sel:setScale(0.6)
	txtTab3Sel:setDimensions(GlobalMethod:CCSize(140))

	GetElement(self.m_root,"btmTip",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配End------------------------------------------