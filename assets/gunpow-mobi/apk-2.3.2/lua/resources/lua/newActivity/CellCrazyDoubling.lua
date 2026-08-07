--CellCrazyDoubling.lua
--@brief	CellCrazyDoubling的UI模块
--@date		2020/07/30
--@author	yrd
--@note		疯狂翻倍子项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCrazyDoubling:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCrazyDoubling:onExit(element)
	self:_unInit()
end

function CellCrazyDoubling:onClickSelect(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = self.m_root:getTag()
	self.m_tCallbackFunc[2](self.m_tCallbackFunc[1],tag+1)
end

function CellCrazyDoubling:initUI()
	local strFormat = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SE="1" SS="4">%s</T><T C="255,255,255" S="22" P="1" SC="128,54,13" SE="1" SS="4">%s</T>]]
	local s1 = self.m_tData.tips
	local s2 = self.m_tData.taskCurFinish.."/"..self.m_tData.taskTatolFinish
	local ftbTaskName = GetElement(self.m_root,"ftbTaskName_CellCrazyDoubling",WZUIFreeTextBox)
	ftbTaskName:setShowText(string.format(strFormat,s1,s2))

	for i=1, #self.m_tData.reward do
		local conReward = GetElement(self.m_root,"conReward0"..i.."_CellCrazyDoubling",WZUIContainer)

		local celElement, tLuaObj = CellGoodItem:createElement()
        celElement = WZUIContainer:luaTo(celElement)
        tLuaObj:setCellGoodLocalId(self.m_tData.reward[i][1],self.m_tData.reward[i][2],4)
        celElement:setTag(i-1)
        tLuaObj:setItemClickFun(self,self.onClickItem)
        conReward:addChild(celElement)
        celElement:setScale(0.8)
	end
	if #self.m_tData.reward == 1 then
		GetElement(self.m_root,"conReward01_CellCrazyDoubling",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	end

	local txtDoublingLimit = GetElement(self.m_root,"txtDoublingLimit_CellCrazyDoubling",WZUILabelTTF)
	txtDoublingLimit:setText(self.m_tData.taskCurDoubling.."/"..self.m_tData.taskTatolDoubling..LocalStrings.SHOP_CISHU)


	local btnGoto = GetElement(self.m_root,"btnGoto_CellCrazyDoubling",WZUIButton)
	local imgBuyState = GetElement(self.m_root,"imgBuyState_CellCrazyDoubling",WZUIImage)
	if self.m_tData.taskStatus == -1 then
		btnGoto:setVisible(true)
		-- imgBuyState:setVisible(false)
		imgBuyState:setFile("")
	elseif self.m_tData.taskStatus == 0 then
		btnGoto:setVisible(false)
		-- imgBuyState:setVisible(true)
		imgBuyState:setFile("ui/common/common_icon_klq.png")
	elseif self.m_tData.taskStatus == 1 then
		btnGoto:setVisible(false)
		-- imgBuyState:setVisible(true)
		imgBuyState:setFile("ui/common/common_icon_ywc.png")
	end

	if self.m_tData.taskId == 1 then
		btnGoto:setVisible(false)
	end

end

function CellCrazyDoubling:showRedDot(bShow)
	GetElement(self.m_root,"imgRedDot_CellCrazyDoubling",WZUIImage):setVisible(bShow)
end

function CellCrazyDoubling:onClickGoto(element)
	if self.m_tData.taskId == 1 then
		return
	elseif self.m_tData.taskId == 2 then
		JumpByUIId(154)
	elseif self.m_tData.taskId == 3 then
		JumpByUIId(154)
	elseif self.m_tData.taskId == 4 then
		MsgBoxManager:showTipBox(LocalStrings.CRAZY_DOUBLING_TEXT7)
		return
	elseif self.m_tData.taskId == 5 then
		JumpByUIId(43)
	end
	WndFrameActivity:onCloseClick()
end

function CellCrazyDoubling:onClickItem(luaTable,tag,tData)
	WndCrazyDoubling:addTips(luaTable,tag,tData)
end

function CellCrazyDoubling:showSelectionBox(bShow)
	GetElement(self.m_root,"conSelect_CellCrazyDoubling",WZUIContainer):setVisible(bShow)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
