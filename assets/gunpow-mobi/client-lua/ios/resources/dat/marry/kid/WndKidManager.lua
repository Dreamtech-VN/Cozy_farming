--WndKidManager.lua
--@brief	WndKidManager的UI模块
--@date		2018/05/09
--@author	Tianxiang_Xu
--@note		小孩管理界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidManager:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidManager:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndKidManager:onEnterTransitionDidFinish(element)
    -- body
    self:setStaticText()
    self:_update()
end

--@brief 	点击标签回调
function WndKidManager:onCheck(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local nTag = element:getTag()
	if self.m_nTabIndex == nTag then return end 

	WZLog("WndKidManager:onCheck", #SceneKidHome.m_tKidData)
	if nTag == 6 then
		if #SceneKidHome.m_tKidData == 0 then
			GetElement(self.m_root, "checkGroup_WndKidManager", WZUICheckBoxGroup):setCheckIndex(self.m_nTabIndex - 1)
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT62)
			return 
		end
	end
	self.m_nTabIndex = nTag 
	self:setTab()
	self:showContent()
end

--@brief	关闭
function WndKidManager:onClose(element)
	WZLog("WndKidManager:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root == nil then
		return
	end
	if WndKidDress.m_root then
		if WndKidDress.m_tTryWearList and #WndKidDress.m_tTryWearList > 0 then
			MsgBoxManager:showConfirmBox(LocalStrings.KID_TEXT122, WndKidDress, WndKidDress.buyTryClothes, nil, nil, nil, nil, nil, WndKidDress.closeWnd)
			return
		end
	end
	self:closeWindow()
end

--@brief 	关闭窗口
function WndKidManager:closeWindow()
	-- body
	WndKidOperate.m_bIsClickFunc = false
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	触摸开始回调
function WndKidManager:onTouchBegin(element, pt)
	-- body
	if WndKidDress.m_root and not WndKidDress:checkPointInBtn(pt) then
        WndKidDress:hideSuitList()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置标题和按钮字
function WndKidManager:setStaticText()
	-- body
	GetElement(self.m_root,"txtTitle_WndKidManager",WZUILabelTTF):setText(LocalStrings.ATH_SHOP)
	for i = 1, 7 do
		GetElement(self.m_root, "txtTab" .. i .. "_WndKidManager", WZUILabelTTF):setText(LocalStrings.KID_TEXT13[i])
		GetElement(self.m_root, "txtTab" .. i .. "Sel_WndKidManager", WZUILabelTTF):setText(LocalStrings.KID_TEXT13[i])
	end
end

--@brief 	标签的高亮显示与否
function WndKidManager:setTab()
	-- body
	for i = 1, 7 do
		if i == self.m_nTabIndex then
			GetElement(self.m_root, "txtTab" .. i .. "Sel_WndKidManager", WZUILabelTTF):setVisible(true)
			GetElement(self.m_root, "imgTab" .. i .. "_WndKidManager", WZUI9Image):setVisible(true)
		else
			GetElement(self.m_root, "txtTab" .. i .. "Sel_WndKidManager", WZUILabelTTF):setVisible(false)
			GetElement(self.m_root, "imgTab" .. i .. "_WndKidManager", WZUI9Image):setVisible(false)
		end
	end

	local txtTitle = GetElement(self.m_root, "txtTitle_WndKidManager", WZUILabelTTF)
	if txtTitle then
		txtTitle:setText(LocalStrings.KID_TEXT104[self.m_nTabIndex])
	end
end

--@brief 	刷新
function WndKidManager:_update()
	-- body
	self:setTab()
	self:showContent()
end

--@brief 	根据所选标签，显示相应的内容
function WndKidManager:showContent()
	-- body
	local conContent = GetElement(self.m_root, "conContent_WndKidManager", WZUIContainer)
	if conContent then
		conContent:removeAllChildrenWithCleanup(true)
	end

	local wndTemp
	if self.m_nTabIndex == 1 then 	--家具
		wndTemp = WndKidShop:createElement()
		WndKidShop:setType(self.m_nTabIndex)
	elseif self.m_nTabIndex == 2 then --装饰
		wndTemp = WndKidShop:createElement()
		WndKidShop:setType(self.m_nTabIndex)
	elseif self.m_nTabIndex == 3 then --小孩
		wndTemp = WndKidBorn:createElement()
	elseif self.m_nTabIndex == 4 then --佣人
		wndTemp = WndKidServant:createElement()
	elseif self.m_nTabIndex == 5 then --食物
		wndTemp = WndKidShop:createElement()
		WndKidShop:setType(self.m_nTabIndex)
	elseif self.m_nTabIndex == 6 then --时装
		wndTemp = WndKidDress:createElement()
	elseif self.m_nTabIndex == 7 then --背包
		wndTemp = WndKidShop:createElement()
		WndKidShop:setType(self.m_nTabIndex)
	end

	if wndTemp then
		conContent:addChild(wndTemp)
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndKidManager:_adaptLanguage_vn(  )
	for i = 1, 7 do
		GetElement(self.m_root, "txtTab" .. i .. "_WndKidManager", WZUILabelTTF):setScale(0.88)
		GetElement(self.m_root, "txtTab" .. i .. "Sel_WndKidManager", WZUILabelTTF):setScale(0.88)
	end
end

function WndKidManager:_adaptLanguage_en(  )
	for i = 1, 7 do
		GetElement(self.m_root, "txtTab" .. i .. "_WndKidManager", WZUILabelTTF):setScale(0.7)
		GetElement(self.m_root, "txtTab" .. i .. "Sel_WndKidManager", WZUILabelTTF):setScale(0.7)
	end
end

function WndKidManager:_adaptLanguage_th(  )
	for i = 1, 7 do
		GetElement(self.m_root, "txtTab" .. i .. "_WndKidManager", WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root, "txtTab" .. i .. "Sel_WndKidManager", WZUILabelTTF):setScale(0.8)
	end
end

function WndKidManager:_adaptLanguage_tr(  )
	for i = 1, 7 do
		GetElement(self.m_root, "txtTab" .. i .. "_WndKidManager", WZUILabelTTF):setScale(0.7)
		GetElement(self.m_root, "txtTab" .. i .. "Sel_WndKidManager", WZUILabelTTF):setScale(0.7)
	end
end

function WndKidManager:_adaptLanguage_pt(  )
	for i = 1, 7 do
		GetElement(self.m_root, "txtTab" .. i .. "_WndKidManager", WZUILabelTTF):setScale(0.7)
		GetElement(self.m_root, "txtTab" .. i .. "Sel_WndKidManager", WZUILabelTTF):setScale(0.7)
	end
end

function WndKidManager:_adaptLanguage_es(  )
	for i = 1, 7 do
		GetElement(self.m_root, "txtTab" .. i .. "_WndKidManager", WZUILabelTTF):setScale(0.7)
		GetElement(self.m_root, "txtTab" .. i .. "Sel_WndKidManager", WZUILabelTTF):setScale(0.7)
	end
end
-------------------------------------语言适配End----------------------------------------