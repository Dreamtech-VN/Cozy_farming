--CellPhantomItem1.lua
--@brief	CellPhantomItem1的UI模块
--@date		2021/03/04
--@author	hyc
--@note		皮肤Item


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPhantomItem1:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPhantomItem1:onExit(element)
	self:_unInit()
end

--@brief	选中皮肤
function CellPhantomItem1:onSelect()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if WndPhantom.m_tSelectedCell ~= nil then
		WndPhantom.m_tSelectedCell:setHighLight(false)
	end
	WndPhantom.m_tSelectedCell = self
	WndPhantom.RefineData = self.m_tData
    WndPhantom.showId = self.m_tData.id
	self:setHighLight(true)

	WndPhantom:onFresh(self.m_tData) 
	WndPhantom:playAttackAni()
end

--@brief    点击幻化按键
function CellPhantomItem1:onFighting(element)
    WZLog("---------------------fighting----------------------")
    WndPhantom:onUse(element, self.m_tData)
end

--@brief    点击取消按键
function CellPhantomItem1:onDown(element)
    WZLog("---------------------onDown----------------------")
    WndPhantom:onCancel(element, self.m_tData)
end

--@brief 	加载
function CellPhantomItem1:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellPhantomItem1")
	self.m_root:addChild(celElement)

	self.m_bIsLoaded = true
	self:_update()
	AdaptLanguage(self)
end

-- 设置选中状态
function CellPhantomItem1:setHighLight(isSel)
    self.selState = isSel

    if self.m_bIsLoaded == false then return end
    local conSel = GetElement(self.m_root, "img9Choose_CellPhantomItem1", WZUI9Image)
    conSel:setVisible(self.selState)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellPhantomItem1:_update()
	-- body
	local tData = self.m_tData
	--拥有和使用状态
	self:setPhantomState()
--	WZLog("单个皮肤",Serialize(tData))
	-- --选中状态
	self:setHighLight(self.selState)

 	local starCnt = tData.advancedLevel or 0
 	GetElement(self.m_root,"txtName_CellPhantomItem1",WZUILabelTTF):setText(tData.name)
 	GetElement(self.m_root,"txtXing_CellPhantomItem1",WZUILabelTTF):setText(starCnt)
    GetElement(self.m_root,"imgBg_CellPhantomItem1",WZUIImage):setFile(g_tQualityBG[tData.quality])
    GetElement(self.m_root,"imgName_CellPhantomItem1",WZUIImage):setFile(g_tQualityNameBG[tData.quality])
    GetElement(self.m_root,"imgIcon_CellPhantomItem1",WZUIImage):setFile(tData.bust)
    GetElement(self.m_root,"imgFight_CellPhantomItem1",WZUIImage):setVisible(tData.use)

end

--@brief	拥有和使用状态
function CellPhantomItem1:setPhantomState()
	-- body
	local tData = self.m_tData
	if self.m_bIsLoaded == false then return end 

	if tData.own == true then
		GetElement(self.m_root,"conNot_CellPhantomItem1",WZUIContainer):setVisible(false)
	else
		GetElement(self.m_root,"conNot_CellPhantomItem1",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conXing_CellPhantomItem1",WZUIContainer):setVisible(false)
	end

end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellPhantomItem1:_adaptLanguage_vn()
    GetElement(self.m_root,"txtName_CellPhantomItem1",WZUILabelTTF):setScale(0.7)
end
-------------------------------------语言适配End----------------------------------------


