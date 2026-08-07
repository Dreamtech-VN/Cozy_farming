--CellCheckOtherBg.lua
--@brief	CellCheckOtherBg的UI模块
--@date		2018/05/02
--@author	Tianxiang_Xu
--@note		玩家信息中的背景cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOtherBg:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOtherBg:onExit(element)
	self:_unInit()
end

--@brief 	点击回调
function CellCheckOtherBg:onClickCell(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndCheckOther:clickBgCellCallBack(element, self, self.m_tData)
end

--@brief 	加载
function CellCheckOtherBg:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellCheckOtherBg")
	self.m_root:addChild(celElement)

	self.m_bIsLoaded = true
	self:_update()
end

--@brief 	设置选中状态
function CellCheckOtherBg:setSelState(bVisible)
	-- body
	self.m_bIsSel = bVisible 
	if not self.m_bIsLoaded then return end 

	local conSel = GetElement(self.m_root, "conSel_CellCheckOtherBg", WZUIContainer)
	if conSel then
		conSel:setVisible(bVisible)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	
function CellCheckOtherBg:_update()
	-- body
	local imgBg = GetElement(self.m_root, "imgBg_CellCheckOtherBg", WZUIImage)
	if imgBg then
		imgBg:setFile(self.m_tData.icon)
	end
	local ftxtPrice = GetElement(self.m_root, "ftxtPrice_CellCheckOtherBg", WZUIFreeTextBox)
	local state = -1 
	local nNum = CacheCenter:getPlayerItemCountById(self.m_tData.id)
	if nNum > 0 then
		state = 0 
	end

	if self.m_tData.id == 830 then
		GetElement(self.m_root, "txtDefault_CellCheckOtherBg", WZUILabelTTF):setVisible(true)
		state = 0 
	else
		GetElement(self.m_root, "txtDefault_CellCheckOtherBg", WZUILabelTTF):setVisible(false)
	end

	if CacheCenter:getPlayerInfo().background and CacheCenter:getPlayerInfo().background == self.m_tData.id then
		state = 1
	end

	if ftxtPrice then
		if state == -1 then
			local sFormat = [[<I Z="0.5">%s</I><T C="255,255,255" S="18" P="1" SC="79,60,48" SS="4" SE="1">%d</T>]]
			local tCostData = GDatatab_item["id_" .. self.m_tData.property[1][1]] 
			ftxtPrice:setVisible(true)
			WZLog("CellCheckOtherBg:_update", self.m_tData.property[1][1])
			if tCostData then
				ftxtPrice:setShowText(string.format(sFormat, tCostData.icon, self.m_tData.property[1][2]))
			end
		elseif state == 0 then
			ftxtPrice:setVisible(false)
			local sFormat = [[<T C="255,227,116" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]]
			ftxtPrice:setShowText(string.format(sFormat, LocalStrings.IN_USE))
		else
			ftxtPrice:setVisible(true)
			local sFormat = [[<T C="255,227,116" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]]
			ftxtPrice:setShowText(string.format(sFormat, LocalStrings.IN_USE))
		end
	end

	self:setSelState(self.m_bIsSel)
end

function CellCheckOtherBg:setUseingVisible(bVisible)
	-- body
	local ftxtPrice = GetElement(self.m_root, "ftxtPrice_CellCheckOtherBg", WZUIFreeTextBox)
	if ftxtPrice then
		ftxtPrice:setVisible(bVisible)
	end
end


-------------------------------------私有方法模块End----------------------------------------
