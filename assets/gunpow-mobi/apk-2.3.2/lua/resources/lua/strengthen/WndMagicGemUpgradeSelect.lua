--WndMagicGemUpgradeSelect.lua
--@brief	WndMagicGemUpgradeSelect的UI模块
--@date		2019/07/24
--@author	yrd
--@note		魔力宝石升级选择


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMagicGemUpgradeSelect:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMagicGemUpgradeSelect:onExit(element)
	self:_unInit()
end

function WndMagicGemUpgradeSelect:show(tData,tag)
	local wnd = WndMagicGemUpgradeSelect:createElement()
	WindowManager:addWindow(wnd,WndMagicGemUpgradeSelect,nil,nil,nil,true)
	self.m_tData = tData
	self.m_nNum = tData.lastNum
	self.m_nMaxNum = tData.lastNum
	self.m_tag = tag
	self:update()
end

function WndMagicGemUpgradeSelect:onClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndMagicGemUpgradeSelect:onClickItem(tItem, nTag, tData)
    WZLog("WndMagicGemUpgradeSelect:onClickItem ")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData1 = CopyTable(tData)
	self.tag = tag
	tData1.tBtnList = nil
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData1, false)
end

function WndMagicGemUpgradeSelect:onClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	-- self.m_tData.lastNum = self.m_nNum
	local tData = CopyTable(self.m_tData)
	tData.lastNum = self.m_nNum
	--回到魔力宝石选择界面
	-- WndSelectTipsStrengthen:getSelectGemData(self.m_tData)
	WndMagicGemUpgrade:addMagicGemToCell(tData,self.m_tag)
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndMagicGemUpgradeSelect:update()
	GetElement(self.m_root,"title_WndMagicGemUpgradeSelect",WZUILabelTTF):setText(LocalStrings.MY_GEM)
	GetElement(self.m_root,"txtBtn_WndMagicGemUpgradeSelect",WZUILabelTTF):setText(LocalStrings.CONFIRM)

    local conImage = GetElement(self.m_root,"con_WndMagicGemUpgradeSelect",WZUIContainer)
    local cell,tcell = CellGoodItem:createElement()
    if cell then
        cell = WZUIContainer:luaTo(cell)
       	tcell:setCellGoodItem(self.m_tData, 4)
        tcell:setItemClickFun(self, self.onClickItem)
        conImage:addChild(cell)
    end

	self:refresh()
end

function WndMagicGemUpgradeSelect:refresh()
	GetElement(self.m_root,"useNum_WndMagicGemUpgradeSelect",WZUILabelTTF):setText(self.m_nNum)
end

--@brief	减少10个
function WndMagicGemUpgradeSelect:onMutiReduce(element)
	WZLog("WndMagicGemUpgradeSelect:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum > 1 then
		if self.m_nNum <= 10 then
			self.m_nNum = 1
		else
			self.m_nNum = self.m_nNum - 10
		end
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	self:refresh()
end

--@brief	减少1个
function WndMagicGemUpgradeSelect:onReduce(element)
	WZLog("WndMagicGemUpgradeSelect:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	self:refresh()
end

--@brief	增加10个
function WndMagicGemUpgradeSelect:onMutiAdd(element)
	WZLog("WndMagicGemUpgradeSelect:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum < self.m_nMaxNum then
		if self.m_nNum + 10 <= self.m_nMaxNum then
			 self.m_nNum = self.m_nNum + 10
		else
			 self.m_nNum = self.m_nMaxNum
		end
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	self:refresh()
end

--@brief	增加1个
function WndMagicGemUpgradeSelect:onAdd(element)
	WZLog("WndMagicGemUpgradeSelect:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum + 1 <= self.m_nMaxNum then
		self.m_nNum = self.m_nNum + 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	self:refresh()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
