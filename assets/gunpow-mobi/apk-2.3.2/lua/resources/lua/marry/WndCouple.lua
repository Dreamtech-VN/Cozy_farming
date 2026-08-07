--WndCouple.lua
--@brief	WndCouple的UI模块
--@date		2022/07/18
--@author	yrd
--@note		夫妻界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCouple:onEnter(element)
	self.m_root = element
	self:_addTop()

	self:updateTheme(self.m_nThemeIndex)
	self:updateContent(self.m_nThemeIndex)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCouple:onExit(element)
	self:_unInit()
end

--@brief	顶部栏
function WndCouple:_addTop()
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_jh.png", self, self.onCloseClick, true, false, false, "WndCouple")
    self.m_root:addChild(celElement)
end

--@brief	关闭按钮回调事件
function WndCouple:onCloseClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	点击标题
function WndCouple:onClickTheme(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local nTag = element:getTag()

	if nTag == self.m_nThemeIndex then
		return
	end

	self:updateTheme(nTag)
	self:updateContent(nTag)
end

--@brief	更新标题栏
function WndCouple:updateTheme(nIndex)
	local checkThemeGroup = GetElement(self.m_root, "checkThemeGroup_WndCouple", WZUICheckBoxGroup)

	if nIndex == 1 then
		if not CheckButtonOpen(ISLAND_RIGHT_COUPLE) then
			checkThemeGroup:setCheckIndex(self.m_nThemeIndex - 1)
			return
		end
		self.m_nThemeIndex = nIndex
		checkThemeGroup:setCheckIndex(self.m_nThemeIndex - 1)
	elseif nIndex == 2 then
		if not CheckButtonOpen(COUPLE_MARRIAGE) then
			checkThemeGroup:setCheckIndex(self.m_nThemeIndex - 1)
			return
		end
		if not (WndMarryManager.m_tMarryStatus.marryStatus == 2 and WndMarryManager.m_tMarryStatus.wedTime == -1) then
			checkThemeGroup:setCheckIndex(self.m_nThemeIndex - 1)
			MsgBoxManager:showTipBox(LocalStrings.COUPLE_TEXT2[1])
			return
		end
		self.m_nThemeIndex = nIndex
		checkThemeGroup:setCheckIndex(self.m_nThemeIndex - 1)
	end

end

--@brief	更新内容
function WndCouple:updateContent(nIndex)
	if nIndex == 1 then
		self:onClickMarry()
	elseif nIndex == 2 then
		self:showmarriage()
	end
end

--@brief	更新背景图片
function WndCouple:updateBGImg(nIndex)
	local imgBG = GetElement(self.m_root,"imgBG_WndCouple",WZUIImage)
	if nIndex == 1 then
		imgBG:setFile("ui/common_bg/marry_bg_01.png")
	elseif nIndex == 2 then
		imgBG:setFile("ui/common_bg/marry_bg_06.png")
	end
end

--@brief    点击夫妻按钮回调
function WndCouple:onClickMarry()
    TeachGroup1:endTeachStep({24,1})
    if not CheckButtonOpen(ISLAND_RIGHT_COUPLE) then return end
    WndMarryManager:createLoading()
    WndMarryManager:initManager()
end

--brief     显示婚礼大厅
function WndCouple:showMarrHoll(element)
    self:updateTheme(1)
    self:updateBGImg(1)

    local conMarry = GetElement(self.m_root,"conContent_WndCouple",WZUIContainer)
    conMarry:removeAllChildrenWithCleanup(true)
    wndMarryHoll = WndMarryHoll:createElement()
    conMarry:addChild(wndMarryHoll)
end

--@brief    显示夫妻关系
function WndCouple:showMarryWed()
    if not CheckButtonOpen(ISLAND_RIGHT_COUPLE) then return end
    
    self:updateTheme(1)
    self:updateBGImg(1)

    local conMarry = GetElement(self.m_root,"conContent_WndCouple",WZUIContainer)
    conMarry:removeAllChildrenWithCleanup(true)
    sceneMarryWedding = SceneMarryWedding:createElement()
    conMarry:addChild(sceneMarryWedding)
end

--@brief    显示姻缘
function WndCouple:showmarriage()
    if not CheckButtonOpen(COUPLE_MARRIAGE) then return end

	if not (WndMarryManager.m_tMarryStatus.marryStatus == 2 and WndMarryManager.m_tMarryStatus.wedTime == -1) then
		return
	end

    self:updateTheme(2)
    self:updateBGImg(2)

    local conMarry = GetElement(self.m_root,"conContent_WndCouple",WZUIContainer)
    conMarry:removeAllChildrenWithCleanup(true)
    local wndMarriage = WndMarriage:createElement()
    conMarry:addChild(wndMarriage)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
