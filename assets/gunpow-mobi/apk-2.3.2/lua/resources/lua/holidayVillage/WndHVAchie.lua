--WndHVAchie.lua
--@brief	WndHVAchie的UI模块
--@date		2022/05/27
--@author	XTX
--@note		度假村-成就界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVAchie:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVAchie:onExit(element)
	self:_unInit()
end

--@brief 	加载完成回调
function WndHVAchie:onEnterTransitionDidFinish(element)
	WZLog("WndHVAchie:onEnterTransitionDidFinish")
	self:_setStaticText()
	local hostInfo = WndHVOperate.m_tLuaTable:getHostInfo()
	self:setData(hostInfo.hvCoolValue)
end

--@brief 	点击关闭按钮回调
function WndHVAchie:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, WndHVAchie , true)
end

--@brief 	点击复选框回调
function WndHVAchie:onClickUse(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_achieElementSel then 
		local nTagSel = self.m_achieElementSel:getTag()
		if nTagSel == nTag then 
			self.m_achieElementSel = nil 
		else
			self.m_achieElementSel:setCheckIndex(0)
			self.m_achieElementSel = WZUICheckBox:luaTo(element)
		end
	end

end

--@brief 	点击查看属性按钮回调
function WndHVAchie:onClickProperty(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()

	local tData = {}
	tData.winType = 2
	tData.property = self.m_tAchieData[nTag].property
	tData.fighting = WndCard:_caculateFighting(tData.property)
	WndTips:show(element,WndHVAchie.m_root,82,tData,GlobalMethod:ccp(-20,-100),true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置静态文本
function WndHVAchie:_setStaticText()
	GetElement(self.m_root, "txtTitle_WndHVAchie", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[19])
end

--@brief 	刷新
function WndHVAchie:_update()
	local tbAchie = GetElement(self.m_root, "tbAchie_WndHVAchie", WZUITableContainer)
	tbAchie:cleanTable()

	for i = 1, #self.m_tAchieData do
		local element = WZUISystem:getInstance():createElement("CellHVAchieItem")
		WZLog("WndHVAchie:_update", type(element))
        if element == nil then
            return 
        end
        element:setTag(i - 1)
        element:setVisible(true)
        self:_setAchieCell(element, self.m_tAchieData[i], i)
        tbAchie:setCellElement(element)
	end
end

--@brief 设置每个成就的数据
function WndHVAchie:_setAchieCell(element, tAchieData, nIndex)
	local txtAchieName = GetElement(element, "txtAchieName_CellHVAchieItem", WZUILabelTTF)
	if txtAchieName then 
		txtAchieName:setText(tAchieData.name)
	end
	--图标
	local spineIcon = GetElement(element, "spineIcon_CellHVAchieItem", WZUISpine)
	local bIsFileExist = CheckEffectFile(tAchieData.icon)
	if spineIcon and bIsFileExist then 
		spineIcon:setFileAtlas(tAchieData.icon .. ".atlas")
		spineIcon:setFileJson(tAchieData.icon .. ".json")

		spineIcon:play("wait_1", true)
	end
	--进度
	local ftxtProgress = GetElement(element, "ftxtProgress_CellHVAchieItem", WZUIFreeTextBox)
	if ftxtProgress then
		local strFormat = [[<T C="127,70,26" S="20" P="1">%s:</T><T C="229,105,22" S="20" P="1">%d/%d</T>]]
		local nCurPro = tAchieData.progress > tAchieData.target and tAchieData.target or tAchieData.progress

		local strContent = string.format(strFormat, LocalStrings.HOLIDAYVILLAGE_TEXT1[38], nCurPro, tAchieData.target)
		ftxtProgress:setShowText(strContent)
	end
	GetElement(element, "btnProperty_CellHVAchieItem", WZUIButton):setTag(nIndex)
	--
	local cbUse = GetElement(element, "cbUse_WndHVAchie", WZUICheckBox)
    cbUse:setTag(tAchieData.id)
    if tAchieData.status >= 1 then 
    	cbUse:setVisible(true)
    end
end
-------------------------------------私有方法模块End----------------------------------------
